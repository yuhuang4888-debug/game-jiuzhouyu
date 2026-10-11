%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_custom_act).

-include("custom_act.hrl").
-include("daily.hrl").
-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("language.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("custom_act_list.hrl").
-include("shake.hrl").
-include("def_daily.hrl").
-include("rec_recharge.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([make_record/2]).

-export([
    get_custom_act_list/0
    , reload_act_list/1
    , timer_check/1
    , day_trigger/1
    , pack_custom_act_list/1
    , count_reward_status/3
    , count_receive_times/3
    , reward_status/3
    , receive_reward/4
    , receive_reward/5
    , act_end/3
    , send_reward_status_direct/5
    , send_error_code/2
    , make_rwparam/1
    , make_rwparam/3
    , make_rwparam/4
    , get_open_lv/1
    , make_rank_rwparam/4
    , broadcast_act_info/2
    , update_receive_times/5
    , custom_act_reward_is_all_deactive/2
]).

-export([
    is_kf_act/2,
    sync_kf_act_info/3
]).

%% 额外数据处理
-export([
    act_data/3
    , act_other_data/3
    , save_act_data_to_player/2
    , save_other_act_data_to_player/4
    , delete_act_data_to_player_without_db/3
    , db_load_custom_act_data/1
    , db_save_custom_act_data/2
    , db_delete_custom_act_data/2
    , db_delete_custom_act_data/3
    ]).

make_record(custom_act_data, [Type, SubType, Data]) ->
    NewData0 = util:bitstring_to_term(Data),
    NewData = convert_data(Type, SubType, NewData0),
    #custom_act_data{
        id = {Type, SubType}, type = Type, subtype = SubType, data = NewData
    }.

convert_data(Type, SubType, Data) when Type == ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
    lib_bonus_treasure:convert_data(Type, SubType, Data);
convert_data(_Type, _SubType, Data) -> Data.

%% 获取配置中有效的活动列表
get_custom_act_list() ->
    case get(?P_VAILD_ACT_TYPE_LIST) of
        undefined ->
            ActList = get_custom_act_list_from_cfg(),
            put(?P_VAILD_ACT_TYPE_LIST, ActList),
            {ok, ActList};
        ActList ->
            %% 检查文件修改时间 如果和进程字典里面存储的文件最后修改时间不一致则重新加载
            case lib_custom_act_check:check_file_mtime() of
                {false, LastMtime} ->
                    erase(?P_VAILD_ACT_TYPE_LIST),
                    put(?P_CUSTOM_ACT_NORMAL_LAST_MTIME, LastMtime),
                    {reload};
                _ ->
                    {ok, ActList}
            end
    end.

%% 重新加载定制活动
reload_act_list(State) ->
    erase(?P_VAILD_ACT_TYPE_LIST),
    OldOpenL = lib_custom_act_util:get_custom_act_open_list(),

    db:execute(io_lib:format(?clear_opening_custom_act, [])),
    ets:delete_all_objects(?ETS_CUSTOM_ACT),

    % 处理不能开启多个子类型的活动(要放回到db和ets)
    [
        begin
            #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime} = ActInfo,
            db:execute(io_lib:format(?insert_opening_custom_act, [Type, SubType, WLv, Stime, Etime])),
            ets:insert(?ETS_CUSTOM_ACT, ActInfo)
        end || #act_info{key = {Type, _}} = ActInfo <- OldOpenL, lib_custom_act_check:check_unique_type(Type)
    ],

    {ok, ActList} = get_custom_act_list(),

    NowTime = utime:unixtime(),
    WorldLv = util:get_world_lv(),
    ArgsMap = lib_custom_act_util:make_check_args_map(NowTime),
    F = fun(T, Acc) ->
        case T of
            {Type, SubType} ->
                case do_timer_check(Type, SubType, ArgsMap) of
                    {true, Stime, Etime} ->
                        case lists:keyfind({Type, SubType}, #act_info.key, OldOpenL) of
                            #act_info{wlv = OWLv} -> WLv = OWLv;
                            _ -> WLv = WorldLv
                        end,
                        ActInfo = #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime},
                        TList = act_start(?RELOAD_START, ActInfo, NowTime),
                        TList ++ Acc;
                    _ ->
                        %% 重新加载造成的活动结束当成手动结束处理
                        case lists:keyfind({Type, SubType}, #act_info.key, OldOpenL) of
                            ActInfo when is_record(ActInfo, act_info) ->
                                act_end(?CUSTOM_ACT_STATUS_MANUAL_CLOSE, ActInfo, NowTime);
                            _ ->
                                skip
                        end,
                        Acc
                end;
            _ -> Acc
        end
    end,
    ActOpenList = lists:foldl(F, [], ActList),
    %% 跨服的活动要重新放回活动列表
    F1 = fun(T, Acc) ->
        case T of
            #act_info{key = {Type, SubType}} = ActInfo ->
                case is_kf_act(Type, SubType) of
                    true ->
                                ets:insert(?ETS_CUSTOM_ACT, ActInfo),
                                [ActInfo|Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    LastActOpenList = lists:foldl(F1, ActOpenList, OldOpenL),
    PackList = pack_custom_act_list(LastActOpenList),
    {ok, BinData} = pt_331:write(33101, [PackList]),
    lib_server_send:send_to_all(BinData),
    ?ERR("Reload Custom Act List", []),
    State.

%% 从配置获取定制活动列表
get_custom_act_list_from_cfg() ->
    NormalList = case data_custom_act_extra:get_switch(?CUSTOM_ACT_NORMAL) of
                     ?CUSTOM_ACT_SWITCH_OPEN ->
                         NormalCfgL = data_custom_act:get_act_list(),
                         %% 这里之后要再加一层检测,检测是否有配置除了子类型不同其他都是一样的
                         [{Type, SubType} || {Type, SubType} <- NormalCfgL, SubType < ?EXTRA_CUSTOM_ACT_SUB_ADD, lib_custom_act_check:check_cfg(Type, SubType)];
                     _ ->
                         []
                 end,
    ExtraList = case data_custom_act_extra:get_switch(?CUSTOM_ACT_EXTRA) of
                    ?CUSTOM_ACT_SWITCH_OPEN ->
                        ExtraCfgL = data_custom_act_extra:get_act_list(),
                        [{Type, SubType + ?EXTRA_CUSTOM_ACT_SUB_ADD} || {Type, SubType} <- ExtraCfgL, lib_custom_act_check:check_cfg(Type, SubType + ?EXTRA_CUSTOM_ACT_SUB_ADD)];
                    _ ->
                        []
                end,
    ActList0 = [{Type, SubType} || {Type, SubType} <- NormalList ++ ExtraList, lib_custom_act:is_kf_act(Type, SubType) == false],
    % 对只能开启一个子类型的活动进行处理,使子类型较大的排前面进行判断
    F = fun({Type, _}) -> lists:member(Type, ?UNIQUE_CUSTOM_ACT_TYPE) end,
    {ActList1, ActList2} = lists:partition(F, ActList0),
    ActList2 ++ lists:reverse(lists:sort(ActList1)).

%% 活动开启
act_start(_OpenType, ActInfo, _NowTime) ->
    #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime} = ActInfo,
    OpSubtypeL = lib_custom_act_util:get_open_subtype_list(Type),
    IsKfActType = is_kf_act(Type, SubType),
    case lib_custom_act_check:check_unique_type(Type) of
        true ->
            case OpSubtypeL of
                [] -> %% 同类型的活动没有开启直接开启
                    BroadCastL = [ActInfo],
                    case IsKfActType of
                        true -> %% 跨服的定制活动不用保存到本服数据库
                            skip;
                        _ ->
                            db:execute(io_lib:format(?insert_opening_custom_act, [Type, SubType, WLv, Stime, Etime]))
                    end,
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                [#act_info{key = {Type, SubType}, wlv = OWLv, stime = OStime, etime = OEtime}] when OStime =/= Stime; OEtime =/= Etime -> %% 类型相同的更新开启结束时间
                    BroadCastL = [ActInfo#act_info{wlv = OWLv}],
                    case IsKfActType of
                        true -> %% 跨服的定制活动不用保存到本服数据库
                            skip;
                        _ ->
                            db:execute(io_lib:format(?update_opening_custom_act, [Stime, Etime, Type, SubType]))
                    end,
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo#act_info{wlv = OWLv});
                [#act_info{key = {Type, SubType}}] -> % 原本正在开启的活动
                    BroadCastL = [ActInfo];
                _ ->
                    % ?MYLOG("custom_act", "act_start 3~n", []),
                    BroadCastL = []
            end;
        false ->
            case lists:keyfind({Type, SubType}, #act_info.key, OpSubtypeL) of
                false ->
                    BroadCastL = [ActInfo],
                    case IsKfActType of
                        true -> %% 跨服的定制活动不用保存到本服数据库
                            skip;
                        _ ->
                            db:execute(io_lib:format(?insert_opening_custom_act, [Type, SubType, WLv, Stime, Etime]))
                    end,
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                #act_info{wlv = OWLv, stime = OStime, etime = OEtime} when OStime =/= Stime; OEtime =/= Etime -> %% 类型相同的更新开启结束时间
                    BroadCastL = [ActInfo#act_info{wlv = OWLv}],
                    case IsKfActType of
                        true -> %% 跨服的定制活动不用保存到本服数据库
                            skip;
                        _ ->
                            db:execute(io_lib:format(?update_opening_custom_act, [Stime, Etime, Type, SubType]))
                    end,
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo#act_info{wlv = OWLv});
                _ -> BroadCastL = []
            end
    end,    % ?MYLOG("hjhact", "act_start ActInfo:~p lists:keyfind({Type, SubType}, #act_info.key, OpSubtypeL):~p BroadCastL:~p ~n",
    %     [ActInfo, lists:keyfind({Type, SubType}, #act_info.key, OpSubtypeL), BroadCastL]),
    case BroadCastL =/= [] of
        true ->
            %% 通知其他功能模块定制活动的开启状态
            notify_other_module(?CUSTOM_ACT_STATUS_OPEN, IsKfActType, ActInfo, Stime, Etime);
        % case OpenType == ?TIMER_START orelse OpenType == ?RELOAD_START of
        %     true -> %% 通过定时器开启或者后台重新加载开启的定制活动才要广播给客户端
        %         broadcast_act_info(?CUSTOM_ACT_STATUS_OPEN, BroadCastL);
        %     _ -> skip
        % end;
        false -> skip
    end,
    handle_other_act_start(ActInfo),
    BroadCastL.

%% 活动结束
act_end(CloseType, ActInfo, NowTime) ->
    #act_info{
        key = {Type, SubType},
        wlv = WLv,
        stime = Stime,
        etime = Etime
    } = ActInfo,
    IsKfActType = is_kf_act(Type, SubType),
    case IsKfActType of
        false ->
            db:execute(io_lib:format(?delete_opening_custom_act, [Type, SubType])),
            send_reward_with_act_end(ActInfo);
        _ -> skip
    end,
    ets:delete(?ETS_CUSTOM_ACT, {Type, SubType}),
    lib_log_api:log_custom_act(Type, SubType, WLv, Stime, Etime, CloseType, NowTime),
    %% 广播给玩家
    {ok, BinData} = pt_331:write(33103, [[{Type, SubType}]]),
    lib_server_send:send_to_all(BinData),
%%    handle_other_act_end(ActInfo),
    notify_other_module(CloseType, IsKfActType, ActInfo, Stime, Etime).

%% 活动结算
act_settlement(NowTime) ->
    Mspec = ets:fun2ms(fun(#act_info{etime = Etime} = T) when NowTime >= Etime -> T end),
    EndList = ets:select(?ETS_CUSTOM_ACT, Mspec),
    F = fun(ActInfo) ->
        act_end(?CUSTOM_ACT_STATUS_CLOSE, ActInfo, NowTime)
        end,
    lists:foreach(F, EndList).

%% 每分钟检测当前是否有定制活动符合开启条件
timer_check(State) ->
    case get_custom_act_list() of
        {ok, ActList} ->
            % ?PRINT("timer_check ~n", []),
            NowTime = utime:unixtime(),
            WLv = util:get_world_lv(),
            ArgsMap = lib_custom_act_util:make_check_args_map(NowTime),

            %% 先处理已开启的活动的结算逻辑
            act_settlement(NowTime),

            F = fun(T, Acc) ->
                case T of
                    {Type, SubType} ->
                        case do_timer_check(Type, SubType, ArgsMap) of
                            {true, Stime, Etime} ->
                                ActInfo = #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime},
                                TList = act_start(?TIMER_START, ActInfo, NowTime),
                                TList ++ Acc;
                            _ ->
                                Acc
                        end;
                    _ -> Acc
                end
                end,
            BroadCastL = lists:foldl(F, [], ActList),
            broadcast_act_info(?CUSTOM_ACT_STATUS_OPEN, BroadCastL),
            %% 检查同步下来的跨服定制活动是否满足开启条件
            NewState = timer_check_kf_act(State, ArgsMap),
            %%处理特殊活动
            handle_other_act(),
            NewState;
        {reload} -> %% 重新加载定制活动
            %% 由于外服推送beam到热更有时间差，可能导致这次检测到时候beam文件还未热而取得的旧的配置，所以要多次重新加载
            NewRef = util:send_after(State#custom_act_state.rl_check_ref, 60000, self(), {'reload'}),
            reload_act_list(State#custom_act_state{rl_check_ref = NewRef, rl_check_times = 0})
    end.

timer_check_kf_act(State) ->
    NowTime = utime:unixtime(),
    ArgsMap = lib_custom_act_util:make_check_args_map(NowTime),
    timer_check_kf_act(State, ArgsMap).

timer_check_kf_act(State, ArgsMap) ->
    #custom_act_state{unopen_kf_act = UnOpenKfActL} = State,
    #{time := NowTime} = ArgsMap,
    WLv = util:get_world_lv(),
    F = fun(#act_info{key = {Type, SubType}} = T, {Acc, TmpBroadCastL}) ->
        %% 需要在本服检查一遍是否符合开服/合服或者其他限制条件的要求
        case do_timer_check(Type, SubType, ArgsMap) of
            {true, Stime, Etime} ->
                case check_special_kf_custom_open(T, Stime, Etime) of
                    true ->
                        ActInfo = #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime},
                        TList = act_start(?TIMER_START, ActInfo, NowTime),
                        {Acc, TList ++ TmpBroadCastL};
                    _ ->
                        {[T | Acc], TmpBroadCastL}
                end;
            _ ->
                % ?ERR("Type:~p UN OPEN>>>>>>>>", [Type]),
                {[T | Acc], TmpBroadCastL}
        end
        end,
    {NewUnOpenKfActL, BroadCastL} = lists:foldl(F, {[], []}, UnOpenKfActL),
    broadcast_act_info(?CUSTOM_ACT_STATUS_OPEN, BroadCastL),
    % ?ERR("NewUnOpenKfActL:~p", [NewUnOpenKfActL]),
    State#custom_act_state{unopen_kf_act = NewUnOpenKfActL}.

do_timer_check(Type, SubType, ArgsMap) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        ActInfo when is_record(ActInfo, custom_act_cfg) ->
            do_timer_check_helper(ActInfo, ArgsMap);
        _ -> false
    end.

do_timer_check_helper(ActInfo, ArgsMap) ->
    case lib_custom_act_check:check_in_act_time(ActInfo, ArgsMap) of
        {true, Stime, Etime} ->
            case do_timer_check_other(ActInfo) of
                true ->
                    {true, Stime, Etime};
                _ -> false
            end;
        _ -> false
    end.

%% 特殊活动有开启要求的放到这里检查
do_timer_check_other(_ActInfo) -> true.

day_trigger(?TWELVE) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_custom_act_api, update_custom_drop_map, []) || E <- OnlineRoles],
    clear_act_data(?CUSTOM_ACT_CLEAR_ZERO);
day_trigger(?FOUR) ->
    clear_act_data(?CUSTOM_ACT_CLEAR_FOUR);
day_trigger(_) -> skip.

%% 一些特殊检查
check_special_kf_custom_open(ActInfo, Stime, _Etime) ->
    #act_info{key = {Type, _SubType}, stime = STimeKf} =  ActInfo,
    if
        Type == ?CUSTOM_ACT_TYPE_FLOWER_RANK -> %% 跨服鲜花榜：活动开启的第一天，满足开服天数的服才能开启
            case utime:is_same_day(STimeKf, Stime) of
                true -> true;
                _ -> false
            end;
        Type == ?CUSTOM_ACT_TYPE_KF_GROUP_BUY -> %% 活动开启时过了购买时间，不开启
            case lib_kf_group_buy:check_act_open_extra(ActInfo, Stime) of
                true -> true;
                _ -> false
            end;
        true ->
            true
    end.

%% ================ 清理规则 ======================
%% 如果某个定制活动同时在自己的进程以及玩家进程都有数据需要清理
%% 这里只清理各个活动进程自己的数据,不处理在线玩家的定制活动数据
%% 如果要清理在线玩家身上的数据,统一在相关的活动数据加一个数据的更新时间戳字段,如果最后更新的时间戳和玩家当前操作的时间戳不在同一逻辑清理天内,则把数据清理掉
%% 判断是否在同一逻辑清理天内可调用接口lib_custom_act_util:in_same_clear_day()

%%--------------------------------------------------
%% 清理活动开启期间的数据
%% @param  ClearType CUSTOM_ACT_CLEAR_ZERO 0点 | CUSTOM_ACT_CLEAR_FOUR 4点
%% @return           description
%%--------------------------------------------------
clear_act_data(ClearType) ->
    %% 对正在开启的定制活动清理数据
    OpSubtypeL = lib_custom_act_util:get_custom_act_open_list(),
    F = fun(T, RL) ->
        #act_info{
            key = {Type, SubType}
        } = T,
        case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
            #custom_act_cfg{clear_type = ClearType} ->
                do_clear_act_data(T, ClearType),
                [{Type, SubType} | RL];
            _ -> RL
        end
        end,
    RefreshActList = lists:foldl(F, [], OpSubtypeL),
    {ok, Bin} = pt_331:write(33108, [RefreshActList]),
    lib_server_send:send_to_all(Bin),
    ok.

%% 这里只做各个进程自己的数据清理
do_clear_act_data(ActInfo, ClearType) ->
    do_clear_act_data_helper(ActInfo, ClearType).

%% 累积充值，每日充值清理时要补发奖励
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType}, stime = STime} = _ActInfo, ClearType) when ClearType =/=? CUSTOM_ACT_CLEAR_NULL ->
    Type = ?CUSTOM_ACT_TYPE_RECHARGE_GIFT,
%%    STime = lib_custom_act_util:get_act_logic_stime(ActInfo),
    NSTime = max(STime, utime:unixdate() - ?ONE_DAY_SECONDS),
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    %% 当天重置的档次
    spawn(fun() ->
        case lib_recharge_data:db_get_all_recharge_log_between_time(NSTime, utime:unixtime()) of  %% 昨天到现在的
            [] ->
                skip;
            List ->
                ReceiveList = db:get_all(io_lib:format(?select_custom_act_reward_receive_by_type, [Type, SubType])),
                FCombine = fun([RoleId, GradeId, ReceiveTimes, UTime], M) ->
                    OL = maps:get(RoleId, M, []), maps:put(RoleId, [{GradeId, ReceiveTimes, UTime}|OL], M)
                end,
                ReceiveMap = lists:foldl(FCombine, #{}, ReceiveList),
                F = fun([RoleId, SumGold]) ->
                    F2 = fun({GradeId, ReceiveTimes, UTime}, L2) ->
                        case lists:member(GradeId, L2) of
                            true ->
                                IsSameClearDay = lib_custom_act_util:in_same_clear_day(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType, utime:unixdate() - ?ONE_DAY_SECONDS, UTime),
                                if
                                    IsSameClearDay == true andalso ReceiveTimes > 0 -> %% 昨天是已经领取了
                                        lists:delete(GradeId, L2);
                                    true -> %% 昨天没有领取
                                        L2
                                end
                        end
                        end,
                        %% 找出可以领但是没有领的奖励id
                        RoleReceiveList = maps:get(RoleId, ReceiveMap, []),
                        NotReceiveList = lists:foldl(F2, GradeIdList, RoleReceiveList),
                        %?PRINT("NotReceiveList ~p~n", [{RoleId, NotReceiveList}]),
                        case NotReceiveList == [] of
                            true -> skip;
                            _ ->
                                RewardParam = make_rwparam(RoleId),
                                F3 = fun(GradeId, L3) ->
                                    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                                        #custom_act_reward_cfg{condition = Conditions} = RewardCfg ->
                                            case lists:keyfind(today_gold, 1, Conditions) of
                                                {today_gold, Gold} when SumGold >= Gold ->
                                                    Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                                                    Reward ++ L3;
                                                _ -> L3
                                            end;
                                        _ -> L3
                                    end
                                  end,
                                GoodsList = lists:foldl(F3, [], NotReceiveList),
                                GoodsList =/= [] andalso
                                    lib_mail_api:send_sys_mail([RoleId], utext:get(3310038), utext:get(3310039), GoodsList)
                        end,
                timer:sleep(100)
                end,
                    lists:foreach(F, List)
        end
          end),
    ok;


%% 砸蛋
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_SMASHED_EGG, _SubType}} = ActInfo, _ClearType) ->
    mod_smashed_egg:daily_clear(ActInfo),
    ok;
%% 惊喜扭蛋
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_LUCKEY_EGG, _SubType}} = ActInfo, _ClearType) ->
    mod_luckey_egg:daily_clear(ActInfo),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}, wlv = Wlv} = _ActInfo, ClearType) when
        Type == ?CUSTOM_ACT_TYPE_BONUS_TREE;Type == ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE ->
    if
        ClearType =/= ?CUSTOM_ACT_CLEAR_NULL ->
            lib_bonus_tree:send_reward_day_clear(Type, SubType, Wlv, ClearType);
        true ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType) when Type == ?CUSTOM_ACT_TYPE_BONUS_POOL ->
    lib_bonus_pool:midnight_update(Type, SubType, ClearType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType) when Type == ?CUSTOM_ACT_TYPE_DRAW_REWARD ->
    lib_bonus_draw:midnight_update(Type, SubType, ClearType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE ->
    lib_festival_recharge:day_clear_act_data(Type, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_RECHARGE_ONE ->
    lib_recharge_one:day_clear_act_data(Type, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_HOLY_SUMMON ->
    lib_holy_summon:day_clear_act_data(Type, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_PRAY ->
    lib_bonus_pray:day_clear_act_data(Type, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW ->
    lib_select_pool_draw:act_start(Type, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            mod_luckey_wheel_local:clear_data(Type, SubType);
        true ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType)
when Type == ?CUSTOM_ACT_TYPE_ACTIVATION orelse Type == ?CUSTOM_ACT_TYPE_RECHARGE ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            lib_activation_draw:day_clear(Type, SubType);
        true ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, _ClearType) when
        Type == ?CUSTOM_ACT_TYPE_COLWORD;
        Type == ?CUSTOM_ACT_TYPE_LIVENESS ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, clear_type) of
        {clear_type, day} ->
            % db:execute(io_lib:format(?delete_custom_drop_log, [Type, SubType]));
            lib_custom_act_api:clear_act_drop(Type, SubType);
        _ ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType}} = _ActInfo, _ClearType)  ->
    mod_red_envelopes_rain:clear_daily(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType}} = _ActInfo, _ClearType)  ->
    lib_fortune_cat:clear_daily(?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE, SubType}} = _ActInfo, _ClearType)  ->
    mod_contract_challenge:flush_daily_task(SubType),
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType)
when Type == ?CUSTOM_ACT_TYPE_TASK_REWARD ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            mod_custom_act_task:clear_data(Type, SubType);
        true ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{key = {Type, SubType}} = _ActInfo, ClearType)
when Type == ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            lib_bonus_treasure:clear_data(Type, SubType);
        true ->
            skip
    end,
    ok;
do_clear_act_data_helper(#act_info{stime = StartTime, wlv = Wlv, key = {Type = ?CUSTOM_ACT_TYPE_SIGN_REWARD, SubType}} = _ActInfo, ClearType) ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            lib_sign_reward_act:refresh_player_login_times(Type, SubType),
            lib_sign_reward_act:send_unrecieve_signact_recharge(midnight, Type, SubType, Wlv, StartTime);
        true ->
            skip
    end,
    ok;
%% 超级特惠礼包
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_SPECIAL_GIFT, _SubType}} = ActInfo, _ClearType) ->
    lib_special_gift:daily_clear(ActInfo),
    ok;
%% 充值大回馈
do_clear_act_data_helper(#act_info{key = {Type = ?CUSTOM_ACT_TYPE_RECHARGE_REBATE, SubType}} = _ActInfo, _ClearType) ->
    lib_recharge_rebate_act:clear_data(Type, SubType),
    ok;
%% 广告
do_clear_act_data_helper(#act_info{key = {Type = ?CUSTOM_ACT_TYPE_ADVERTISEMENT, SubType}} = _ActInfo, _ClearType) ->
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])),
%%    lib_recharge_rebate_act:clear_data(Type, SubType),
    Sql = io_lib:format(<<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>, [Type, SubType]),
    db:execute(Sql),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_custom_act, delete_act_data_to_player_without_db, [Type, SubType]) || E <- OnlineRoles];

%% 系统邮件
do_clear_act_data_helper(#act_info{key = {?CUSTOM_ACT_TYPE_SYS_MAIL, _SubType}} = ActInfo, _ResetType) ->
    lib_custom_act_sys_mail:daily_trigger(ActInfo);

do_clear_act_data_helper(_ActInfo, _ClearType) ->
    skip.

%% 定制活动奖励的可领取状态
%% 某些活动类型有自己的协议不走通用协议要在这里过滤掉
reward_status(_, ActType, _) when
    ActType == ?CUSTOM_ACT_TYPE_DAILY_CHARGE orelse         %% 每日累充有自己的状态协议
    ActType == ?CUSTOM_ACT_TYPE_RUSH_RANK orelse            %% 开服冲榜有自己的状态协议
    ActType == ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD orelse     %% Boss首杀有自己的状态协议
    ActType == ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE orelse      %% 幸运转盘有自己的协议
    ActType == ?CUSTOM_ACT_TYPE_RED_ENVELOPES orelse        %% 活动红包有自己的协议
    ActType == ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN orelse        %% 活动红包有自己的协议
    ActType == ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD orelse  %% 0元礼包有自己的协议
    ActType == ?CUSTOM_ACT_TYPE_SEVEN_DAY orelse            %% 七日挑战奖励走掉落
    ActType == ?CUSTOM_ACT_TYPE_MON_INVADE orelse           %% 异兽入侵走副本
    ActType == ?CUSTOM_ACT_TYPE_LEVEL_ACT orelse            %% 等级抢购活动有自己的协议
    ActType == ?CUSTOM_ACT_TYPE_LEVEL_ACT_1 orelse
    ActType == ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD orelse    %% 等级活跃抽奖
    ActType == ?CUSTOM_ACT_TYPE_FORTUNE_CAT orelse          %% 招财猫
    ActType == ?CUSTOM_ACT_TYPE_ESCORT orelse               %% 矿石护送
    ActType == ?CUSTOM_ACT_TYPE_TASK_REWARD orelse          %% 幸运寻宝 --完成任务获得奖励
    ActType == ?CUSTOM_ACT_TYPE_TREASURE_HUNT orelse        %% 幸运鉴宝
    ActType == ?CUSTOM_ACT_TYPE_RECHARGE_POLITE             %% 累充有礼
    ->
    skip;
reward_status(Player, Type, SubType) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            send_reward_status(Player, ActInfo);
        _ ->
            send_error_code(Player#player_status.id, ?ERRCODE(err331_act_closed))
    end.

%% 勇者盟约
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_GUILD_CREAT, _}} = ActInfo) ->
    lib_guild_create_act:send_reward_status(Player, ActInfo);

%% 节日首冲
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType}} = _ActInfo) ->
    lib_festival_recharge:info(Player, ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType);

%% 一元礼包
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_RECHARGE_ONE, SubType}} = _ActInfo) ->
    lib_recharge_one:info(Player, ?CUSTOM_ACT_RECHARGE_ONE, SubType);


%%%% 嗨点
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_HI_POINT, _}} = ActInfo) ->
    mod_hi_point:send_reward_status(Player#player_status.id, ActInfo);

%% 公会争霸
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_GWAR, SubType}} = ActInfo) ->
    case mod_custom_act_gwar:check_custom_act_gwar_open(SubType) of
        true ->
            mod_custom_act_gwar:send_reward_status(Player#player_status.id, ActInfo);
        _ ->
            GradeIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_GWAR, SubType),
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId) of
                    #custom_act_reward_cfg{
                        name = Name, desc = Desc, condition = Condition, format = Format, reward = Reward
                    } ->
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, ?ACT_REWARD_CAN_NOT_GET, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ -> Acc
                end
                end,
            PackList = lists:foldl(F, [], GradeIds),
            {ok, BinData} = pt_331:write(33104, [?CUSTOM_ACT_TYPE_GWAR, SubType, PackList]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType}} = _ActInfo) ->
    lib_limit_gift:send_reward_status(Player, SubType);

send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_INVESTMENT, _SubType}} = ActInfo) ->
    lib_festival_investment:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo)when
        Type == ?CUSTOM_ACT_TYPE_TRAIN_STAGE;
        Type == ?CUSTOM_ACT_TYPE_TRAIN_POWER ->
    lib_train_act:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo)when
        Type == ?CUSTOM_ACT_TYPE_LIVENESS ->
    lib_custom_act_liveness:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when
Type == ?CUSTOM_ACT_TYPE_VIP_GIFT ->
    lib_custom_act_vip_gift:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_BONUS_POOL ->
    lib_bonus_pool:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, SubType}}) when Type == ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE ->
    mod_contract_challenge:send_reward_status(Player#player_status.id, SubType);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_STAR_TREK ->
    lib_star_trek:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
    lib_special_gift:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_UP_POWER_RANK ->
    lib_up_power:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_RUSH_PACKAGE ->
    lib_rush_package:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{key = {Type, _SubType}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY ->
    lib_custom_daily_direct_buy:send_reward_status(Player, ActInfo);

%% 外形直购
send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_FIGURE_BUY, _SubType}} = ActInfo) ->
    lib_figure_buy_act:send_reward_status(Player, ActInfo);

send_reward_status(Player, #act_info{ key= {Type, SubType}}) when Type == ?CUSTOM_ACT_TYPE_FIRST_DAY_BENEFITS ->
    lib_first_day_benefits:send_reward_status(Player, Type, SubType);

send_reward_status(Player, #act_info{ key= {Type, SubType}}) when Type == ?CUSTOM_ACT_CYCLE_RANK_RECHARGE ->
    lib_custom_cycle_rank:send_reward_status(Player, Type, SubType);

send_reward_status(Player, #act_info{ key= {Type, SubType}}) when Type == ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE ->
    lib_custom_cycle_rank_recharge:send_reward_status(Player, Type, SubType);

send_reward_status(Player, #act_info{key = {Type = ?CUSTOM_ACT_TYPE_DESTINY_TURN, SubType}}) ->
    lib_destiny_turntable:send_reward_status(Player, Type, SubType);

send_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_WEEK_OVERVIEW, _SubType}} = ActInfo) ->
    lib_week_overview:send_reward_status(Player, ActInfo);

%% 特殊活动根据自己的活动类型扩展
send_reward_status(Player, ActInfo) ->
    send_reward_status_normal(Player, ActInfo).

send_reward_status_normal(Player, ActInfo) ->
    #act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}, {open_day}], RewardCfg) of
                    true ->
                        %% 计算奖励的领取状态
                        Status = count_reward_status(Player, ActInfo, RewardCfg),
                        %% 计算奖励的已领取次数
                        ReceiveTimes = count_receive_times(Player, ActInfo, RewardCfg),
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
        end,
    PackList = lists:foldl(F, [], GradeIds),
    % ?MYLOG("cym",  "Type ~p, SubType  ~p  PackList ~p ~n  ",  [Type, SubType, PackList]),
    %?PRINT(Type == 65 orelse Type == 66, "reward status ~p~n", [PackList]),
    if
        Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY
        orelse Type == ?CUSTOM_ACT_TYPE_TREE_SHOP orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD
            orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
            SendList = lists:keysort(1, PackList);
        true ->
            SendList = PackList
    end,
    {ok, BinData} = pt_331:write(33104, [Type, SubType, SendList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).

%% 定制活动奖励能领取的是否全部领取
custom_act_reward_is_all_deactive(ActInfo, Player) ->
	#act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
            } = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}, {open_day}], RewardCfg) of
                    true ->
                        %% 计算奖励的领取状态
                    Status = count_reward_status(Player, ActInfo, RewardCfg),
                        [ Status =/= 0 andalso Status =/= 1 | Acc ];
                    _ ->
                        [true | Acc]
                end;
            _ -> [true | Acc]
        end
        end,
	not lists:member(false, lists:foldl(F, [], GradeIds)).


send_reward_status_direct(RoleId, Type, SubType, StatusMFA, ReceiveTimesMFA) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    {StatusM, StatusF, StatusA} = StatusMFA,
    {ReceiveTimesM, ReceiveTimesF, ReceiveTimesA} = ReceiveTimesMFA,

    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                %% 计算奖励的领取状态
                Status = StatusM:StatusF(RewardCfg, StatusA),
                %% 计算奖励的已领取次数
                ReceiveTimes = ReceiveTimesM:ReceiveTimesF(RewardCfg, ReceiveTimesA),
                % ReceiveTimes = count_receive_times(Player, ActInfo, RewardCfg),
                ConditionStr = util:term_to_string(Condition),
                RewardStr = util:term_to_string(Reward),
                [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
            _ -> Acc
        end
        end,
    PackList = lists:foldl(F, [], GradeIds),
    % ?ERR("send_reward_status_direct ~n~p~n", [PackList]),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 各个活动根据自己的活动类型进行判断
%% 集字没有次数限制直接返回可以领取
count_reward_status(_Player, #act_info{key = {?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL, _SubType}}, _RewardCfg) ->
    ?ACT_REWARD_CAN_NOT_GET; %%
count_reward_status(_Player, #act_info{key = {?CUSTOM_ACT_TYPE_FLOWER_RANK, _SubType}}, _RewardCfg) ->
    ?ACT_REWARD_CAN_NOT_GET; %%
count_reward_status(_Player, #act_info{key = {?CUSTOM_ACT_TYPE_WED_RANK, _SubType}}, _RewardCfg) ->
    ?ACT_REWARD_CAN_NOT_GET; %%
count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD, _SubType}} = ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ ->
            case lib_custom_act_check:check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
                {false, _ErrorCode} ->
                    ?ACT_REWARD_CAN_NOT_GET;
                _ ->
                    ?ACT_REWARD_CAN_GET
            end
    end;
count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SIGN_REWARD, _SubType}} = ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ ->
            case lib_custom_act_check:check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
                {false, _ErrorCode} ->
                    ?ACT_REWARD_CAN_NOT_GET;
                _ ->
                    ?ACT_REWARD_CAN_GET
            end
    end;
count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SPECIAL_GIFT, _SubType}} = ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ -> ?ACT_REWARD_CAN_NOT_GET
    end;
count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ADVERTISEMENT, _SubType}} = ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_CAN_NOT_GET; %% 广告特殊处理
	    {false, _} -> ?ACT_REWARD_HAS_GET;
        _ -> ?ACT_REWARD_CAN_GET
    end;

count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ENVELOPE_REBATE, _SubType}} = ActInfo, RewardCfg) ->
    lib_envelope_rebate:count_reward_status(Player, ActInfo, RewardCfg);

count_reward_status(Player, #act_info{key = {?CUSTOM_ACT_TYPE_THE_CARNIVAL, _SubType}} = ActInfo, RewardCfg) ->
    lib_custom_the_carnival:count_reward_status(Player, ActInfo, RewardCfg);

count_reward_status(Player, ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ ->
            case lib_custom_act_check:check_receive_reward_conditions(Player, ActInfo, RewardCfg) of
                {false, ErrorCode} ->
                    case ErrorCode =:= ?ERRCODE(err331_act_time_out) of
                        true ->
                            ?ACT_REWARD_TIME_OUT;
                        false ->
                            ?ACT_REWARD_CAN_NOT_GET
                    end;
                _ ->
                    ?ACT_REWARD_CAN_GET
            end
    end.

%% 各个活动根据自己的活动类型进行判断

%% 活动兑换 已兑次数
count_receive_times(Player, #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId})
when Type == ?CUSTOM_ACT_TYPE_ACT_EXCHANGE; Type == ?CUSTOM_ACT_TYPE_COLWORD ->
%%    UnixDate = utime:unixdate(),
    UnixDate = utime:standard_unixdate(),
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lists:keyfind(clear_type, 1, Condition) of
        {_, ClearType} ->
            RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
            case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                    case ClearType of
                        day -> ?IF(Utime >= UnixDate, ReceiveTimes, 0);
                        _ -> ?IF(Utime >= Stime andalso Utime =< Etime, ReceiveTimes, 0)
                    end;
                _ -> 0
            end;
        _ -> 0
    end;
%% 活动兑换 已兑次数
count_receive_times(Player, #act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{condition = Condition, grade = GradeId})
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY orelse Type == ?CUSTOM_ACT_TYPE_TREE_SHOP orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD
    orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    UnixDate = utime:standard_unixdate(),
    case lists:keyfind(clear_type, 1, Condition) of
        {_, ClearType} ->
            RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
            case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                    case ClearType of
                        day ->?IF(Utime >= UnixDate, ReceiveTimes, 0);
                        _ ->?IF(Utime >= Stime andalso Utime =< Etime, ReceiveTimes, 0)
                    end;
                _ -> 0
            end;
        _ -> 0
    end;
%% 节日活动兑换 已兑次数
count_receive_times(Player, #act_info{key = {Type = ?CUSTOM_ACT_TYPE_EXCHANGE_NEW, SubType}, stime = Stime, etime = Etime}, #custom_act_reward_cfg{grade = GradeId}) ->
%%    UnixDate = utime:unixdate(),
    UnixDate = utime:standard_unixdate(),
    #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case lists:keyfind(refresh, 1, RewardCondition) of
        {_, ClearType} ->
            RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
            case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                    case ClearType of
                        1 -> ?IF(Utime >= UnixDate, ReceiveTimes, 0);
                        _ -> ?IF(Utime >= Stime andalso Utime =< Etime, ReceiveTimes, 0)
                    end;
                _ -> 0
            end;
        _ -> 0
    end;
%% 等级弹窗奖励
count_receive_times(Player, #act_info{key = {Type, SubType}, stime = _Stime, etime = _Etime}, #custom_act_reward_cfg{grade = GradeId})
    when Type == ?CUSTOM_ACT_TYPE_LV_BLOCK orelse Type == ?CUSTOM_ACT_TYPE_ADVERTISEMENT ->
    RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{receive_times = ReceiveTimes} ->
            ReceiveTimes;
        _ ->
            0
    end;
count_receive_times(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SALE, SubType}, stime = _Stime, etime = _Etime}, #custom_act_reward_cfg{grade = GradeId})  ->
    RewardMap = Player#player_status.status_custom_act#status_custom_act.reward_map,
    #custom_act_reward_cfg{condition = RewardCondition} = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_SALE, SubType, GradeId),
    case maps:get({?CUSTOM_ACT_TYPE_SALE, SubType, GradeId}, RewardMap, []) of
        #reward_status{receive_times = ReceiveTimes, utime = UTime} ->
            case lib_custom_act_check:check_act_condtion([clear_type], RewardCondition) of
                [day] -> ?IF(UTime >= utime:standard_unixdate(), ReceiveTimes, 0);
                _ -> ReceiveTimes
            end;
        _ ->
            0
    end;
count_receive_times(_Player, _ActInfo, _RewardCfg) ->
    0.

%% 不处理的类型
receive_reward(_Player, ActType, _SubType, _GradeId) when
        ActType =:= ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE orelse
        ActType =:= ?CUSTOM_ACT_TYPE_RED_ENVELOPES orelse
        ActType =:= ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN orelse
        ActType =:= ?CUSTOM_ACT_TYPE_LUCKEY_EGG orelse
        ActType =:= ?CUSTOM_ACT_TYPE_FORTUNE_CAT orelse
        ActType =:= ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD orelse
        ActType =:= ?CUSTOM_ACT_TYPE_KF_GROUP_BUY orelse
        ActType =:= ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD_PLUS ->
    skip;

%% 每日累充
receive_reward(Player, ?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, GradeId) ->
    case lib_recharge_cumulation:receive_reward(Player, SubType, GradeId) of
        {ok, NewPlayer} ->
            {ok, BinData} = pt_331:write(33105, [?SUCCESS, ?CUSTOM_ACT_TYPE_DAILY_CHARGE, SubType, GradeId]),
            lib_server_send:send_to_sid(NewPlayer#player_status.sid, BinData),
            {ok, NewPlayer};
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33100, [ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

%% 勇者盟约
receive_reward(Player, ?CUSTOM_ACT_TYPE_GUILD_CREAT, SubType, GradeId) ->
    lib_guild_create_act:receive_reward(Player, SubType, GradeId);

%% 节日首冲
receive_reward(Player, ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType, GradeId) ->
    lib_festival_recharge:get_reward(Player, ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType, GradeId);

%% 一元礼包
receive_reward(Player, ?CUSTOM_ACT_RECHARGE_ONE, SubType, GradeId) ->
    lib_recharge_one:get_reward(Player, ?CUSTOM_ACT_RECHARGE_ONE, SubType, GradeId);

%% 冲榜特惠礼包
receive_reward(Player, ?CUSTOM_ACT_TYPE_RUSH_PACKAGE, SubType, GradeId) ->
    lib_rush_package:get_reward(Player, ?CUSTOM_ACT_TYPE_RUSH_PACKAGE, SubType, GradeId);

%% 嗨点
receive_reward(#player_status{id = RoleId} = Player, ?CUSTOM_ACT_TYPE_HI_POINT, SubType, GradeId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, GradeId) of
        #custom_act_reward_cfg{} = RewardCfg ->
            case lists:keyfind({?CUSTOM_ACT_TYPE_HI_POINT, SubType}, #act_info.key, lib_custom_act_util:get_custom_act_open_list()) of
                false -> send_error_code(RoleId, ?ERRCODE(err331_act_closed));
                ActInfo ->
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        true ->
                            mod_hi_point:receive_reward(Player#player_status.id, SubType, GradeId, Reward);
                        {false, ErrorCode} ->
                            send_error_code(RoleId, ErrorCode)
                    end
            end;
        _ -> send_error_code(RoleId, ?ERRCODE(err_config))
    end;

%% 超值礼包|精品特卖
receive_reward(#player_status{sid = Sid} = Player, Type, SubType, GradeId)
    when Type =:= ?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG orelse Type =:= ?CUSTOM_ACT_TYPE_SPEC_SELL ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        #custom_act_reward_cfg{condition = Condition} ->
            [Price] = lib_custom_act_check:check_act_condtion([now_price], Condition),
            case lib_goods_api:check_object_list(Player, Price) of
                true ->
                    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
                        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
                            %% 先更新次数 避免更新次数出问题玩家重复领取
                            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
                            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                                {false, ErrCode} ->
                                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                                    lib_server_send:send_to_sid(Sid, BinData);
                                Player2 ->
                                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    {ok, Player2}
                            end;
                        {false, ErrCode} ->
                            {ok, BinData} = pt_331:write(33100, [ErrCode]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                {false, Err} -> lib_server_send:send_to_sid(Sid, pt_331, 33100, [Err])
            end;
        _ -> lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err_config)])
    end;

%% 限时礼包 领取奖励
receive_reward(Player, ?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT = Type, SubType, GradeId) ->
    #player_status{id = _RoleId, sid = Sid} = Player,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} ->
            case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
                {true, ActInfo, _NewReceiveTimes, RewardList, RewardCfg} ->
                    case do_receive_reward(Player, ActInfo, RewardList, RewardCfg) of
                        {false, ErrCode} ->
%%                            ?MYLOG("cym", "Err ~p Type ~p SubType  ~p~n", [ErrCode, Type, SubType]),
                            {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        Player2 ->
%%                            ?MYLOG("cym", "Err ~p Type ~p SubType  ~p~n", [?SUCCESS, Type, SubType]),
                            {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            show_tv(Type, SubType, Player2, RewardCfg, RewardList),
                            {ok, Player2}
                    end;
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33100, [ErrCode]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            skip
    end;

%% 公会争霸
receive_reward(#player_status{id = RoleId} = Player, ?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_GWAR, SubType, GradeId) of
        #custom_act_reward_cfg{} = RewardCfg ->
            case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_GWAR, SubType) of
                #act_info{} = ActInfo ->
                    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        true ->
                            mod_custom_act_gwar:receive_reward(Player#player_status.id, ActInfo, GradeId, Reward);
                        {false, ErrorCode} ->
                            send_error_code(RoleId, ErrorCode)
                    end;
                _ -> send_error_code(RoleId, ?ERRCODE(err331_act_closed))
            end;
        _ -> send_error_code(RoleId, ?ERRCODE(err_config))
    end;


%% 摇摇乐 领取奖励
receive_reward(Player, ?CUSTOM_ACT_TYPE_SHAKE = Type, SubType, GradeId) ->
    #player_status{id = _RoleId, sid = Sid} = Player,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} ->
            case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
                {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
                    %% 先更新次数 避免更新次数出问题玩家重复领取
                    Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
                    case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                        {false, ErrCode} ->
                            {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        Player2 ->
                            {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            show_tv(Type, SubType, Player2, RewardCfg, RewardList),
                            {ok, Player2}
                    end;
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33100, [ErrCode]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            skip
    end;

%% 节日投资
receive_reward(Player, ?CUSTOM_ACT_TYPE_INVESTMENT = Type, SubType, GradeId) ->
    #player_status{id = _RoleId, sid = Sid} = Player,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} = ActInfo ->
            case lib_festival_investment:receive_reward(Player, ActInfo, GradeId) of
                {true, NewPlayer, _RewardList, _RewardCfg} ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPlayer};
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        _ ->
            skip
    end;

%% 关注公众号:不发协议
receive_reward(Player, Type, SubType, GradeId) when
        Type == ?CUSTOM_ACT_TYPE_FOLLOW ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                {false, _ErrCode} ->
                    skip;
                Player2 ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player2#player_status.sid, BinData),
                    {ok, Player2}
            end;
        {false, _ErrCode} ->
            skip
    end;

%% vip特惠礼包
receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_VIP_GIFT ->
    #player_status{id = _RoleId, sid = Sid} = Player,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} = ActInfo ->
            case lib_custom_act_vip_gift:reveive_reward(Player, ActInfo, GradeId) of
                {ok, NewPS} ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPS};
                {false, Res, NewPS} ->
                    {ok, BinData} = pt_331:write(33105, [Res, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPS}
            end;
        _ ->
            skip
    end;

%% 契约挑战奖励
receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE ->
    #player_status{id = _RoleId} = Player,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} ->
            mod_contract_challenge:receive_reward(Player#player_status.id, SubType, GradeId);
        _ ->
            skip
    end;

%% 幸运寻宝
receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_TASK_REWARD ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} ->
            lib_custom_act_task:get_reward(Player, Type, SubType, GradeId);
        _ ->
            skip
    end;

%% 星际旅行奖励
receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_STAR_TREK ->
    lib_star_trek:receive_reward(Player, Type, SubType, GradeId);

%% 超值特惠礼包奖励
receive_reward(#player_status{id = RoleId} = Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, Player};
                NewPlayer ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, NewPlayer}
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, Player}
    end;

receive_reward(Player, Type, SubType, GradeId)when Type == ?CUSTOM_ACT_TYPE_COMMON_DRAW ->
    lib_common_draw:receive_reward(Player, Type, SubType, GradeId);

%% 等级弹窗活动奖励
receive_reward(#player_status{id = RoleId} = Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_LV_BLOCK ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, Player};
                NewPlayer ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, NewPlayer}
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, Player}
    end;

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE ->
    lib_envelope_rebate:receive_reward(Player, Type, SubType, GradeId);

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_THE_CARNIVAL ->
    lib_custom_the_carnival:receive_reward(Player, Type, SubType, GradeId);

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_SALE ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            case do_receive_reward(Player, ActInfo, RewardList, RewardCfg) of
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                Player1 ->
                    Player2 = update_receive_times(Player1, Type, SubType, GradeId, NewReceiveTimes),
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player2#player_status.sid, BinData),
                    show_tv(Type, SubType, Player2, RewardCfg, RewardList),
                    {ok, Player2}
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33100, [ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;
%% 累充有礼的领取方式
receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_RECHARGE_POLITE ->
    lib_custom_act_recharge_polite:get_recharge_polite_reward(Player, Type, SubType, GradeId);

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_TYPE_FIRST_DAY_BENEFITS ->
    lib_first_day_benefits:get_benefits_rewards(Player, Type, SubType, GradeId);

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_CYCLE_RANK_RECHARGE ->
    lib_custom_cycle_rank:get_act_rewards(Player, Type, SubType, GradeId);

receive_reward(Player, Type, SubType, GradeId) when Type == ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE ->
    lib_custom_cycle_rank_recharge:get_act_rewards(Player, Type, SubType, GradeId);

receive_reward(Player, ?CUSTOM_ACT_TYPE_DESTINY_TURN = Type, SubType, GradeId) ->
    lib_destiny_turntable:receive_reward(Player, Type, SubType, GradeId);

receive_reward(Player, ?CUSTOM_ACT_TYPE_WEEK_OVERVIEW = Type, SubType, GradeId) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{} ->
            lib_week_overview:receive_reward(Player, Type, SubType, GradeId);
        _ ->
            skip
    end;

%% 领取奖励
receive_reward(Player, Type, SubType, GradeId) ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg) of
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33105, [ErrCode, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                Player2 ->
                    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player2#player_status.sid, BinData),
                    show_tv(Type, SubType, Player2, RewardCfg, RewardList),
                    {ok, Player2}
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33100, [ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end.

%% 兑换多份奖励
receive_reward(Player, Type, SubType, GradeId, Num) ->
    case lib_custom_act_check:check_receive_reward(Player, Type, SubType, GradeId, Num) of
        {true, ActInfo, NewReceiveTimes, RewardList, RewardCfg} ->
            %% 先更新次数 避免更新次数出问题玩家重复领取
            Player1 = update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
            case do_receive_reward(Player1, ActInfo, RewardList, RewardCfg, Num) of
                {false, ErrCode} ->
                    {ok, BinData} = pt_331:write(33179, [ErrCode, Num, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                Player2 ->
                    {ok, BinData} = pt_331:write(33179, [?SUCCESS, Num, Type, SubType, GradeId]),
                    lib_server_send:send_to_sid(Player2#player_status.sid, BinData),
                    show_tv(Type, SubType, Player2, RewardCfg, RewardList),
                    {ok, Player2}
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_331:write(33100, [ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end.
%%--------------------------------------------------
%% 根据活动类型自己处理各自的领取奖励逻辑
%% @param  Player     #player_status{}
%% @param  ActInfo    #act_info{}
%% @param  RewardList [{ObjectType, Id, Num}]
%% @return            #player_status{}|{false, ErrCode}
%%--------------------------------------------------
do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD, SubType}}, RewardList, RewardCfg) ->
    #custom_act_reward_cfg{condition = Condition,grade = GradeId} = RewardCfg,
    {_, ExGoods, ModId, CounterId} = lists:keyfind(goods_exchange, 1, Condition),
    % ?PRINT("@@@@@@@@@@ ExGoods, ModId, CounterId:~p~n",[{ExGoods, ModId, CounterId}]),
    case lib_goods_api:cost_object_list(Player, ExGoods, col_world_act, "") of
        {true, NewPs} ->
            if
                ModId > 0 andalso CounterId > 0 ->
                    mod_global_counter:plus_count(ModId, ?CUSTOM_ACT_TYPE_COLWORD, CounterId, 1),
                    [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, ?CUSTOM_ACT_TYPE_COLWORD, CounterId}],
                        [{global_diff_day, 1}]),
                    {ok, Bin} = pt_331:write(33106, [?CUSTOM_ACT_TYPE_COLWORD, SubType, ModId, CounterId, ExchangeTime, GradeId]),
                    lib_server_send:send_to_all(Bin);
                true ->
                    skip
            end,
            lib_goods_api:send_reward(NewPs, RewardList, col_world_act, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {Type, SubType}}, RewardList, RewardCfg)
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY
    orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD  orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    {CurrencyType, RealPrice} =
        case lists:keyfind(price, 1, Condition) of
            {price, CT, _, RP} ->{CT,RP};
            _ ->
                ?ERR("MISSING_CONFIG {Type, SubType, Condition}:~p~n",[{Type, SubType, Condition}]),
                {1,50}
        end,
    Day =
        case lists:keyfind(sp_gap_time, 1, Condition) of
            {sp_gap_time, D} -> D;
            _ -> 1
        end,
    {ModId, CounterId} =
        case lists:keyfind(counter, 1, Condition) of
            {counter, X, Y} -> {X,Y};
            _ ->{0,0}
        end,
    CostOrProduceType = if
                Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP -> feast_shop;
                Type == ?CUSTOM_ACT_TYPE_RUSH_BUY -> rush_to_buy;
                true -> rush_buy
              end,
    case lib_goods_api:cost_object_list(Player, [{CurrencyType, 0, RealPrice}], CostOrProduceType, "") of
        {true, NewPs} ->
            if
                ModId > 0 andalso CounterId > 0 ->
                    mod_global_counter:plus_count(ModId, Type, CounterId, 1),
                    [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],
                        [{global_diff_day, Day}]),
                    {ok, Bin} = pt_331:write(33106, [Type, SubType, ModId, CounterId, ExchangeTime, GradeId]),
                    lib_server_send:send_to_all(Bin);
                true ->
                    skip
            end,
            lib_log_api:log_custom_act_reward(Player, Type, SubType, GradeId, RewardList),
            lib_goods_api:send_reward(NewPs, RewardList, CostOrProduceType, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType}}, RewardList, RewardCfg) ->
    #custom_act_reward_cfg{
        grade = GradeId,
        condition = Conditions
    } = RewardCfg,
    {cost, CostList} = lists:keyfind(cost, 1, Conditions),
    {discount, Discount} = lists:keyfind(discount, 1, Conditions),
    [{CostGoodsType, CostGoodsId, CostNum} | _] = CostList,
    NewCostNum = round(CostNum * Discount / 100),
    case NewCostNum =< 0 of
        true ->
            {false, ?FAIL};
        false ->
            case lib_goods_api:cost_object_list_with_check(Player, [{CostGoodsType, CostGoodsId, NewCostNum}], limit_buy, "") of
                {true, NewPs} ->
                    lib_goods_api:send_reward(NewPs, RewardList, col_world_act, 0),
                    mod_limit_buy:add_grade_daily_num(SubType, GradeId, Player#player_status.id),
                    NewPs;
                {false, Res, _} ->
                    {false, Res}
            end
    end;

do_receive_reward(Player, #act_info{key = {Type, SubType}}, RewardList, RewardCfg)
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    case lists:keyfind(cost, 1, Condition) of
        {cost, CostList} when is_list(CostList) -> CostList;
        _ -> CostList = []
    end,
    CostOrProduceType = bonus_tree_shop,
    case lib_goods_api:cost_object_list(Player, CostList, CostOrProduceType, "") of
        {true, NewPs} ->
            lib_log_api:log_custom_act_reward(NewPs, Type, SubType, GradeId, RewardList),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {money, MoneyType} = ulists:keyfind(money, 1, Conditions, {money, 0}),
            Score = lib_goods_api:get_currency(NewPs, MoneyType),
            lib_server_send:send_to_uid(NewPs#player_status.id, pt_332, 33231, [Type, SubType, Score]),
            lib_goods_api:send_reward(NewPs, RewardList, CostOrProduceType, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_ACT_EXCHANGE = ActType, ActSubType}}, RewardList, RewardCfg) ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    {_, ExGoods, _, _} = lists:keyfind(goods_exchange, 1, Condition),
    case lib_goods_api:cost_object_list(Player, ExGoods, exchange_act, "") of
        {true, NewPs} ->
            lib_log_api:log_custom_act_reward(Player, ActType, ActSubType, GradeId, RewardList),
            lib_goods_api:send_reward(NewPs, RewardList, exchange_act, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_EXCHANGE_NEW = ActType, ActSubType}}, RewardList, RewardCfg) ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    {_, ExGoods} = lists:keyfind(cost, 1, Condition),
    case lib_goods_api:cost_object_list(Player, ExGoods, exchange_act_new, "") of
        {true, NewPs} ->
            lib_log_api:log_custom_act_reward(Player, ActType, ActSubType, GradeId, RewardList),
            lib_goods_api:send_reward(NewPs, RewardList, exchange_act_new, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG = Type, SubType}}, RewardList, RewardCfg) ->
    NowTime = utime:unixtime(),
    #player_status{figure = #figure{lv = Lv}, overflow_gift = TimeMaps} = Player,
    LvTime = maps:get(SubType, TimeMaps, 0),
    #custom_act_cfg{condition = Conditon0} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    [CfgLv, BuyDay] = lib_custom_act_check:check_act_condtion([role_lv, buy_day], Conditon0),
    [Cost] = lib_custom_act_check:check_act_condtion([now_price], Condition),
    case Lv >= CfgLv andalso (NowTime - LvTime) =< (BuyDay * ?ONE_DAY_SECONDS) of
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, overflow_gift_act, "") of
                {true, NewPs} ->
                    case lists:keyfind(gift_id, 1, Condition) of
                        {gift_id, GiftId} ->
                            lib_goods_api:send_reward(NewPs, [{?TYPE_GOODS, GiftId, 1}], overflow_gift_act, 0);
                        _ ->
                            lib_goods_api:send_reward(NewPs, RewardList, overflow_gift_act, 0)
                    end;
                {false, Res, _} -> {false, Res}
            end;
        false -> {false, ?ERRCODE(lv_limit)}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SPEC_SELL = Type, SubType}}, RewardList, RewardCfg) ->
    NowTime = utime:unixtime(),
    #player_status{figure = #figure{lv = Lv}, spec_sell_act = TimeMaps} = Player,
    LvTime = maps:get(SubType, TimeMaps, 0),
    #custom_act_cfg{condition = Conditon0} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    [CfgLv] = lib_custom_act_check:check_act_condtion([role_lv], Conditon0),
    [Cost] = lib_custom_act_check:check_act_condtion([now_price], Condition),
    case lib_custom_act_check:check_act_condtion([buy_day], Conditon0) of %% 有配的情况下 用此天数限制 不配的话整个活动时间能买
        [BuyDay] ->
            CanBuy = Lv >= CfgLv andalso (NowTime - LvTime) =< (BuyDay * ?ONE_DAY_SECONDS);
        _ -> CanBuy = Lv >= CfgLv
    end,
    case CanBuy of
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, spec_sell_act, "") of
                {true, NewPs} ->
                    lib_goods_api:send_reward(NewPs, RewardList, spec_sell_act, 0);
                {false, Res, _} ->
                    {false, Res}
            end;
        false -> {false, ?ERRCODE(lv_limit)}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_FASHION_ACT, SubActType}}, RewardList, RewardCfg) ->
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    {cost, CostList} = lists:keyfind(cost, 1, Condition),
    case lib_goods_api:cost_object_list(Player, CostList, fashion_act, "") of
        {true, NewPs} ->
            Produce = #produce{
                type = custom_act,
                subtype = ?CUSTOM_ACT_TYPE_FASHION_ACT,
                reward = RewardList,
                remark = util:term_to_string(SubActType)
            },
            lib_goods_api:send_reward(NewPs, Produce);
        {false, Res, _} ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SHAKE, SubActType}}, RewardList, RewardCfg) ->
    #player_status{id = RoleId} = Player,
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
    {stage, Stage} = lists:keyfind(stage, 1, Condition),
    Times = lib_shake:get_draw_times(Player, SubActType),
    case Times >= Stage of
        true ->
            Produce = #produce{
                type = custom_act,
                subtype = ?CUSTOM_ACT_TYPE_SHAKE,
                reward = RewardList,
                remark = util:term_to_string(SubActType)
            },
            NewPS = lib_goods_api:send_reward(Player, Produce),
%%           日志
            lib_log_api:log_shake(RoleId, SubActType, 0, 0, [], GradeId, RewardList),
            NewPS;
        false ->
            {false, ?ERRCODE(err331_shake_not_enough)}
    end;
do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubActType}}, RewardList, RewardCfg) ->
    #player_status{id = RoleId, limit_gift = LimitGift, figure = Figure} = Player,
    #custom_act_reward_cfg{grade = GradeId, condition = Condition, name = ActName} = RewardCfg,
    Cost = lib_limit_gift:get_limit_gift_cost(Condition),
    if
        Cost == [] ->
            {false, ?MISSING_CONFIG};
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, limit_gift_cost, "") of
                {true, NewPS} ->
                    Produce = #produce{
                        type = custom_act,
                        subtype = ?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT,
                        reward = RewardList,
                        remark = util:term_to_string(SubActType)
                    },
                    %%  传闻
                    lib_chat:send_TV(all, ?MOD_AC_CUSTOM, 29, [Figure#figure.name, ActName, ?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubActType]),
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    %%日志
                    lib_log_api:log_custom_act_reward(Player,
                        ?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubActType, GradeId, RewardList),
                    NewLimitGift = lib_limit_gift:update_limit_gift_status(LimitGift, SubActType, GradeId, RoleId),
                    NewPS#player_status{limit_gift = NewLimitGift};
                {false, ErrCode, _} ->
                    {false, ErrCode}
            end
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_SUPPLY, SubActType}}, RewardList, RewardCfg) ->
    #player_status{id = RoleId} = Player,
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
    {liveness, Liveness} = lists:keyfind(liveness, 1, Condition),
    Activity = mod_daily:get_count_offline(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_SUPPLY),
    case Activity >= Liveness of
        true ->
            Produce = #produce{
                type = custom_act,
                subtype = ?CUSTOM_ACT_TYPE_SUPPLY,
                reward = RewardList,
                remark = util:term_to_string(SubActType)
            },
            NewPS = lib_goods_api:send_reward(Player, Produce),
            %% 日志
            lib_log_api:log_custom_act_reward(Player, ?CUSTOM_ACT_TYPE_SUPPLY, SubActType, GradeId, RewardList),
            NewPS;
        false ->
            {false, ?ERRCODE(err157_1_live_not_enough)}
    end;

%% 关注公众号
do_receive_reward(Player, #act_info{key = {MainActType, SubActType}} = _ActInfo, RewardList, RewardCfg) when
        MainActType == ?CUSTOM_ACT_TYPE_FOLLOW ->
    case RewardCfg of
        #custom_act_reward_cfg{grade = GradId, name = Title, desc = Content} ->
            ok;
        _ ->
            GradId = 0, Title = "", Content = ""
    end,
    lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradId, RewardList),
    case Title == "" orelse Content == "" of
        true -> lib_mail_api:send_sys_mail([Player#player_status.id], utext:get(3310058), utext:get(3310059), RewardList);
        false -> lib_mail_api:send_sys_mail([Player#player_status.id], Title, Content, RewardList)
    end,
    Player;

%% 超值特惠礼包
do_receive_reward(#player_status{id = RoleId} = Player, #act_info{key = {Type, SubType}} = _ActInfo, RewardList, RewardCfg) when Type == ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
    case lists:keyfind(cost_type, 1, Condition) of
        {cost_type, CostType} ->
            if
                CostType == 4 orelse CostType == 3 -> %% 直购礼包不走这里
                    Player;
                true ->  %% 钻石绑钻购买要扣除物品再发奖励
                    case lib_special_gift:get_cost_list(CostType, Condition) of
                        {true, CostList} ->
                            case lib_goods_api:cost_object_list_with_check(Player, CostList, special_gift_act, "") of
                                {true, NewPs} ->
                                    lib_special_gift:send_reward(Player, Type, SubType, GradeId, RewardList),
                                    lib_special_gift:af_send_reward(NewPs, Type, SubType, Condition),
                                    NewPs;
                                {false, ErrCode, _} ->
                                    {false, ErrCode}
                            end;
                        {false, ErrCode} ->
                            {false, ErrCode}
                    end
            end;
        _ ->  %% 领取额外奖励
            case lists:keyfind(extra_reward, 1, Condition) of
                {extra_reward} ->
                    lib_special_gift:db_delete_role_special_gift_extra_reward(RoleId, Type, SubType),
                    lib_special_gift:send_reward(Player, Type, SubType, GradeId, RewardList),
                    lib_special_gift:af_send_reward(Player, Type, SubType, Condition),
                    Player;
                _ ->
                    {false, ?MISSING_CONFIG}
            end
    end;

%% 等级弹窗奖励
do_receive_reward(Player, #act_info{key = {MainActType, SubActType}} = _ActInfo, RewardList, RewardCfg) when
        MainActType == ?CUSTOM_ACT_TYPE_LV_BLOCK ->
    #custom_act_reward_cfg{grade = GradeId} = RewardCfg,
    lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradeId, RewardList),
    Produce=#produce{type = lv_block, title = data_language:get(3310099), content = data_language:get(3310100), reward = RewardList, show_tips = 3},
    lib_goods_api:send_reward(Player, Produce);

do_receive_reward(Player, #act_info{key = {MainActType, SubActType}} = _ActInfo, RewardList, RewardCfg) when
    MainActType == ?CUSTOM_ACT_TYPE_SALE ->
    #player_status{id = RoleId, figure = #figure{name = Name}} = Player,
    IsFirstRec = lib_recharge_first:is_buy(Player),
    case lib_custom_act_check:check_act_condition(MainActType, SubActType, [is_first_rec]) of
        [1] when not IsFirstRec -> IsSatisfy = false;
        _ -> IsSatisfy = true
    end,
    #custom_act_reward_cfg{grade = GradeId, condition = Condition, name = RewardName} = RewardCfg,
    case lib_custom_act_check:check_act_condtion([is_rmb, cost, tv_id], Condition) of
        _ when not IsSatisfy ->%% 没有首冲不给买
            {false, ?ERRCODE(err331_login_times_limit)};
        %% IsRmb == 1 是直购的，不能直接领取，通过充值获取
        [0, [], TvId] ->
            lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradeId, RewardList),
            LastPlayer = lib_goods_api:send_reward(Player, #produce{type = custom_act_sale, reward = RewardList}),
            TvId =/= 0 andalso lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 70, [Name, RoleId, RewardName]),
            LastPlayer;
        [0, Cost, TvId] ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, custom_act_sale, "") of
                {true, NewPlayer} ->
                    lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradeId, RewardList),
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, #produce{type = custom_act_sale, reward = RewardList}),
                    TvId =/= 0 andalso lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 70, [Name, RoleId, RewardName]),
                    LastPlayer;
                {false, ErrCode, _} ->
                    {false, ErrCode}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end;

do_receive_reward(Player, ActInfo, RewardList, _RewardCfg) ->
    case lib_goods_api:can_give_goods(Player, RewardList) of
        true ->
            #act_info{
                key = {MainActType, SubActType}
            } = ActInfo,
            Produce = #produce{
                type = custom_act,
                subtype = MainActType,
                reward = RewardList,
                remark = util:term_to_string(SubActType)
            },
	        case _RewardCfg of
		        #custom_act_reward_cfg{grade = GradId} ->
			        ok;
		        _ ->
			        GradId = 0
	        end,
            lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradId, RewardList),
            lib_goods_api:send_reward(Player, Produce);
        {false, ErrorCode} ->
            {false, ErrorCode}
    end.

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_COLWORD, SubType}}, RewardList, RewardCfg, Num) ->
    #custom_act_reward_cfg{condition = Condition, grade = GradeId} = RewardCfg,
    {_, ExGoods, ModId, CounterId} = lists:keyfind(goods_exchange, 1, Condition),
    % ?PRINT("@@@@@@@@@@ ExGoods, ModId, CounterId:~p~n",[{ExGoods, ModId, CounterId}]),
    Fun = fun({T, GT, N}, Acc) ->
        [{T, GT, N*Num}|Acc]
    end,
    RealCost = lists:foldl(Fun, [], ExGoods),
    case lib_goods_api:cost_object_list(Player, RealCost, col_world_act, "") of
        {true, NewPs} ->
            if
                ModId > 0 andalso CounterId > 0 ->
                    [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, ?CUSTOM_ACT_TYPE_COLWORD, CounterId}],
                        [{global_diff_day, 1}]),
                    % ?PRINT("@@@@@@@@@@ ModId, CounterId, ExchangeTime:~p~n",[{ModId, CounterId, ExchangeTime}]),
                    mod_global_counter:set_count(ModId, ?CUSTOM_ACT_TYPE_COLWORD, CounterId, ExchangeTime+Num),
                    {ok, Bin} = pt_331:write(33106, [?CUSTOM_ACT_TYPE_COLWORD, SubType, ModId, CounterId, ExchangeTime+Num, GradeId]),
                    lib_server_send:send_to_all(Bin);
                true ->
                    skip
            end,
            lib_goods_api:send_reward(NewPs, RewardList, col_world_act, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {Type, SubType}}, RewardList, RewardCfg, Num)
when Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY
    orelse Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY ->
    #custom_act_reward_cfg{condition = Condition, grade = GradeId} = RewardCfg,
    {CurrencyType, RealPrice} =
        case lists:keyfind(price, 1, Condition) of
            {price, CT, _, RP} ->{CT,RP};
            _ ->
                ?ERR("MISSING_CONFIG {Type, SubType, Condition}:~p~n",[{Type, SubType, Condition}]),
                {1,50}
        end,
    Day =
        case lists:keyfind(sp_gap_time, 1, Condition) of
            {sp_gap_time, D} -> D;
            _ -> 1
        end,
    {ModId, CounterId} =
        case lists:keyfind(counter, 1, Condition) of
            {counter, X, Y} -> {X,Y};
            _ ->{0,0}
        end,
    CostOrProduceType = if
                Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP -> feast_shop;
                Type == ?CUSTOM_ACT_TYPE_RUSH_BUY -> rush_to_buy;
                true -> rush_buy
              end,
    case lib_goods_api:cost_object_list(Player, [{CurrencyType, 0, RealPrice}], CostOrProduceType, "") of
        {true, NewPs} ->
            if
                ModId > 0 andalso CounterId > 0 ->
                    [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],
                        [{global_diff_day, Day}]),
                    mod_global_counter:set_count(ModId, Type, CounterId, ExchangeTime+Num),
                    {ok, Bin} = pt_331:write(33106, [Type, SubType, ModId, CounterId, ExchangeTime+Num, GradeId]),
                    lib_server_send:send_to_all(Bin);
                true ->
                    skip
            end,
            lib_log_api:log_custom_act_reward(Player, Type, SubType, GradeId, RewardList),
            case lists:keyfind(tv_id, 1, Condition) of
                {tv_id, TvId} ->
                    #player_status{id = RoleId} = Player,
                    ActName = lib_custom_act_util:get_act_name(Type, SubType),
                    [{Gtype, GoodsTypeId, _}|_] = lists:reverse(RewardList),
                    RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
                    WrapperName = lib_player:get_wrap_role_name(Player),
                    lib_chat:send_TV(all, ?MOD_AC_CUSTOM, TvId, [WrapperName, RoleId, ActName, RealGtypeId, Type, SubType]);
                _ -> skip
            end,
            lib_goods_api:send_reward(NewPs, RewardList, CostOrProduceType, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {Type, SubType}}, RewardList, RewardCfg, _Num)
when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    case lists:keyfind(cost, 1, Condition) of
        {cost, CostList} when is_list(CostList) -> CostList;
        _ -> CostList = []
    end,
    CostOrProduceType = bonus_tree_shop,
    case lib_goods_api:cost_object_list(Player, CostList, CostOrProduceType, "") of
        {true, NewPs} ->
            lib_log_api:log_custom_act_reward(Player, Type, SubType, GradeId, RewardList),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {money, MoneyType} = ulists:keyfind(money, 1, Conditions, {money, 0}),
            Score = lib_goods_api:get_currency(NewPs, MoneyType),
            lib_server_send:send_to_uid(NewPs#player_status.id, pt_332, 33231, [Type, SubType, Score]),
            lib_goods_api:send_reward(NewPs, RewardList, CostOrProduceType, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, #act_info{key = {?CUSTOM_ACT_TYPE_EXCHANGE_NEW = ActType, ActSubType}}, RewardList, RewardCfg, Num) ->
    #custom_act_reward_cfg{condition = Condition, grade =GradeId} = RewardCfg,
    {_, ExGoods} = lists:keyfind(cost, 1, Condition),
    Fun = fun({T, GT, N}, Acc) ->
        [{T, GT, N*Num}|Acc]
    end,
    RealCost = lists:foldl(Fun, [], ExGoods),
    case lib_goods_api:cost_object_list(Player, RealCost, exchange_act_new, "") of
        {true, NewPs} ->
            lib_log_api:log_custom_act_reward(Player, ActType, ActSubType, GradeId, RewardList),
            lib_goods_api:send_reward(NewPs, RewardList, exchange_act_new, 0);
        Res ->
            {false, Res}
    end;

do_receive_reward(Player, ActInfo, RewardList, _RewardCfg, _) ->
    case lib_goods_api:can_give_goods(Player, RewardList) of
        true ->
            #act_info{
                key = {MainActType, SubActType}
            } = ActInfo,
            Produce = #produce{
                type = custom_act,
                subtype = MainActType,
                reward = RewardList,
                remark = util:term_to_string(SubActType)
            },
            case _RewardCfg of
                #custom_act_reward_cfg{grade = GradId} ->
                    ok;
                _ ->
                    GradId = 0
            end,
            lib_log_api:log_custom_act_reward(Player, MainActType, SubActType, GradId, RewardList),
            lib_goods_api:send_reward(Player, Produce);
        {false, ErrorCode} ->
            {false, ErrorCode}
    end.

%% 更新领奖次数
%% 注:领奖次数保存在status_custom_act的reward_map里面才使用这个接口
update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RoleId = Player#player_status.id,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    if
        Type == ?CUSTOM_ACT_TYPE_SIGN_REWARD ->
            {LoginTimes, _} = lib_sign_reward_act:get_login_times(Player, Type, SubType);
        true ->
            LoginTimes = 0
    end,
    NowTime = utime:unixtime(),
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        RwStatus when is_record(RwStatus, reward_status) ->
            SQL = io_lib:format(?update_custom_act_reward_receive, [NewReceiveTimes, NowTime, RoleId, Type, SubType, GradeId]),
            NewRwStatus = RwStatus#reward_status{receive_times = NewReceiveTimes, utime = NowTime, login_times = LoginTimes};
        _ ->
            SQL = io_lib:format(?insert_custom_act_reward_receive, [RoleId, Type, SubType, GradeId, NewReceiveTimes, NowTime]),
            NewRwStatus = #reward_status{receive_times = NewReceiveTimes, utime = NowTime, login_times = LoginTimes}
    end,
    db:execute(SQL),
    NewRewardMap = RewardMap#{{Type, SubType, GradeId} => NewRwStatus},
    Player#player_status{status_custom_act = StatusCustomAct#status_custom_act{reward_map = NewRewardMap}}.

%%--------------------------------------------------
%% %% 通知其他功能模块定制活动的开启状态[会多次执行]
%% @param  ActStatus CUSTOM_ACT_STATUS_CLOSE | CUSTOM_ACT_STATUS_OPEN | CUSTOM_ACT_STATUS_MANUAL_CLOSE
%% 注:CUSTOM_ACT_STATUS_MANUAL_CLOSE类型直接清理相关数据即可,不用处理发奖励的逻辑
%% @param  Type      活动主类型
%% @param  SubType   活动子类型
%% @param  Stime     活动开始时间 活动开始时Stime的值不一定就是当前时间
%% @param  Etime     活动结束时间 活动结束时Etime的值不一定就是当前时间
%% @return           description
%%--------------------------------------------------
notify_other_module(ActStatus, IsKfActType, #act_info{key = {Type, SubType}, wlv = WLv} = ActInfo, Stime, Etime) when IsKfActType == false ->
    % ?MYLOG("act", "notify_other_module {Type, SubType}:~p ActStatus:~p ~n", [{Type, SubType}, ActStatus]),
    case ActStatus of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            case Type of
                ?CUSTOM_ACT_TYPE_FLOWER_RANK_LOCAL ->
                    mod_flower_act_local:send_charm_local_reward(SubType);
                ?CUSTOM_ACT_TYPE_WED_RANK ->
                    mod_flower_act_local:clear_wed_rank(SubType);
                % ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                %     mod_clusters_node:apply_cast(mod_kf_flower_act, send_reward, [SubType]);
                ?CUSTOM_ACT_TYPE_SMASHED_EGG ->
                    mod_smashed_egg:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_ACT_BOSS ->
                    mod_act_boss:act_end(ActStatus, Type, SubType);
                ?CUSTOM_ACT_TYPE_PERFECT_LOVER ->
                    mod_perfect_lover:act_close(SubType);
                ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD ->
                    mod_boss_first_blood:act_end(ActStatus, SubType);
                ?CUSTOM_ACT_TYPE_RED_ENVELOPES ->
                    mod_red_envelopes:clear_act_red_envelopes();
                ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN ->
                    mod_red_envelopes_rain:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK ->
                    mod_eudemons_attack:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_COLLECT ->
                    mod_collect:act_end(SubType);
                ?CUSTOM_ACT_TYPE_RECHARGE_RANK ->
                    mod_consume_rank_act:clear_recharge_rank_act(ActStatus, SubType, WLv);
                ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD ->
                    mod_login_return_reward:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_CONSUME_RANK ->
                    mod_consume_rank_act:clear_consume_rank_act(ActStatus, SubType, WLv);
                ?CUSTOM_ACT_TYPE_LUCAY_FLOP ->
                    mod_lucky_flop:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_GWAR ->
                    mod_custom_act_gwar:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_SHAKE ->
                    lib_shake:db_shake_subtype_delete(SubType);
                Type when
                        Type == ?CUSTOM_ACT_TYPE_BONUS_TREE;Type == ?CUSTOM_ACT_TYPE_DRAW_REWARD;
                        Type == ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE ->
                    mod_custom_act_record:cast({remove_log, Type, SubType});
                % ?CUSTOM_ACT_TYPE_BONUS_TREE ->
                %     spawn(fun() -> lib_bonus_tree:send_reward_act_end(Type, SubType) end);
                ?CUSTOM_ACT_TYPE_LIVENESS ->
                    mod_custom_act_liveness:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_LUCKEY_EGG ->
                    mod_luckey_egg:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE ->
                    lib_lucky_turntable:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_INVESTMENT ->
                    lib_festival_investment:act_clear(Type, SubType, Stime, Etime, WLv);
                Type when
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT;
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT_1->
                    lib_level_act:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE ->
                    lib_festival_recharge:act_clear(Type, SubType, WLv);
                ?CUSTOM_ACT_RECHARGE_ONE ->
                    lib_recharge_one:day_clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_HOLY_SUMMON ->
                    lib_holy_summon:day_clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
                    lib_train_act:act_close(Type, SubType);
                ?CUSTOM_ACT_TYPE_TRAIN_POWER ->
                    lib_train_act:act_close(Type, SubType);
                ?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW ->
                    lib_select_pool_draw:act_end(Type, SubType, WLv);
                ?CUSTOM_ACT_TYPE_BETA_RECORD ->
                    lib_beta_login:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_BONUS_POOL ->
                    lib_bonus_pool:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL ->
                    mod_luckey_wheel_local:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_PRAY ->
                    mod_custom_act_record:cast({remove_log, Type, SubType}),
                    OnlineRoles = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pray, updata_info, [Type, SubType, close]) || E <- OnlineRoles];
                ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD ->
                    mod_level_draw_reward:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_HI_POINT ->
                    mod_hi_point:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET ->
                    lib_recharge_return:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_FORTUNE_CAT ->
                    lib_fortune_cat:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE ->
                    mod_contract_challenge:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_STAR_TREK ->
                    lib_star_trek:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_SPECIAL_GIFT ->
                    lib_special_gift:act_end(ActStatus, Type, SubType);
                ?CUSTOM_ACT_TYPE_DESTINY_TURN ->
                    lib_destiny_turntable:act_end(ActInfo);
                Type when
                    Type == ?CUSTOM_ACT_TYPE_ACTIVATION;
                    Type == ?CUSTOM_ACT_TYPE_RECHARGE->
                    lib_activation_draw:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_TASK_REWARD ->
                    mod_custom_act_task:clear_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
                    lib_bonus_treasure:clear_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_COMMON_DRAW ->
                    lib_common_draw:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_CREATE_ROLE ->
                    lib_create_role_act:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_RECHARGE_REBATE ->
                    lib_recharge_rebate_act:clear_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_RUSH_PACKAGE ->
                    lib_rush_package:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY ->
                    lib_custom_daily_direct_buy:clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
                    lib_rush_treasure_api:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE ->
                    lib_envelope_rebate:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_THE_CARNIVAL ->
                    lib_custom_the_carnival:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_RECHARGE_POLITE ->
                    lib_custom_act_recharge_polite:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_FIRST_DAY_BENEFITS ->
                    lib_first_day_benefits:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_CREATE_GIFT ->
                    lib_custom_create_gift:act_end(Type, SubType);
                ?CUSTOM_ACT_CYCLE_RANK_RECHARGE ->
                    lib_custom_cycle_rank:act_end(Type, SubType);
                ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE ->
                    lib_custom_cycle_rank_recharge:act_end(Type, SubType);
                _ -> skip
            end;
        ?CUSTOM_ACT_STATUS_OPEN ->
            case Type of
                % ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                %     mod_clusters_node:apply_cast(mod_kf_flower_act, act_open, [SubType]);
                ?CUSTOM_ACT_TYPE_ACT_BOSS ->
                    mod_act_boss:act_start(Type, SubType);
                ?CUSTOM_ACT_TYPE_PERFECT_LOVER ->
                    mod_perfect_lover:act_start(SubType);
                ?CUSTOM_ACT_TYPE_ACT_FIREWORKS ->
                    lib_fireworks_act:act_start(SubType);
                ?CUSTOM_ACT_TYPE_CLOUD_BUY ->
                    mod_cloud_buy_mgr:act_start(SubType);
                ?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK ->
                    mod_eudemons_attack:act_start(Type, SubType);
                ?CUSTOM_ACT_TYPE_DAILY_CHARGE ->
                    OnlineRoles = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_recharge_cumulation, update_daily, []) || E <- OnlineRoles];
                ?CUSTOM_ACT_TYPE_PRAY ->
                    OnlineRoles = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pray, updata_info, [Type, SubType, open]) || E <- OnlineRoles];
                ?CUSTOM_ACT_TYPE_DRAW_REWARD ->
                    OnlineRoles = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_draw, init_data, []) || E <- OnlineRoles];
                Type when
                        Type == ?CUSTOM_ACT_TYPE_BONUS_TREE;
                        Type == ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE ->
                    OnlineRoles = ets:tab2list(?ETS_ONLINE), %% 0点/4点清理对在线玩家的特殊处理（数据放在玩家进程）
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_tree, init_online_player, []) || E <- OnlineRoles];
                ?CUSTOM_ACT_TYPE_LIVENESS ->
                    mod_custom_act_liveness:act_start(Type, SubType);
                ?CUSTOM_ACT_TYPE_FEAST_COST_RANK ->
                    mod_feast_cost_rank:act_start(SubType);
                ?CUSTOM_ACT_TYPE_LUCKEY_EGG ->
                    mod_luckey_egg:act_start(ActInfo);
                Type when
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT;
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT_1->
                    lib_level_act:act_open(Type, SubType, Stime, Etime);
                ?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW ->
                    lib_select_pool_draw:act_start(Type, SubType);
                ?CUSTOM_ACT_TYPE_BONUS_POOL ->
                    lib_bonus_pool:act_open(Type, SubType);
                ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL ->
                    mod_luckey_wheel_local:act_open(Type, SubType, Etime);
                ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD ->
                    mod_level_draw_reward:act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN ->
                    mod_red_envelopes_rain:act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET ->
                    lib_recharge_return:act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_HI_POINT ->
                    mod_hi_point:custom_act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE ->
                    mod_contract_challenge:act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_SIGN_REWARD ->
                    lib_sign_reward_act:refresh_player_login_times(Type, SubType);
                ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
                    lib_rush_treasure_api:act_open();
                ?CUSTOM_ACT_TYPE_THE_CARNIVAL ->
                    lib_custom_the_carnival:act_start(Type, SubType);
                _ -> skip
            end;
        ?CUSTOM_ACT_STATUS_MANUAL_CLOSE ->
            case Type of
                ?CUSTOM_ACT_TYPE_SMASHED_EGG ->
                    mod_smashed_egg:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_ACT_BOSS ->
                    mod_act_boss:act_end(ActStatus, Type, SubType);
                ?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD ->
                    mod_boss_first_blood:act_end(ActStatus, SubType);
                ?CUSTOM_ACT_TYPE_RED_ENVELOPES ->
                    mod_red_envelopes:clear_act_red_envelopes();
                ?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN ->
                    mod_red_envelopes_rain:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK ->
                    mod_eudemons_attack:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_RECHARGE_RANK ->
                    mod_consume_rank_act:clear_recharge_rank_act(ActStatus, SubType, WLv);
                ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD ->
                    mod_login_return_reward:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_CONSUME_RANK ->
                    mod_consume_rank_act:clear_consume_rank_act(ActStatus, SubType, WLv);
                ?CUSTOM_ACT_TYPE_LUCAY_FLOP ->
                    mod_lucky_flop:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_GWAR ->
                    mod_custom_act_gwar:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_LIVENESS ->
                    mod_custom_act_liveness:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_LUCKEY_EGG ->
                    mod_luckey_egg:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE ->
                    lib_lucky_turntable:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_INVESTMENT ->
                    lib_festival_investment:act_clear(Type, SubType, Stime, Etime, WLv);
                Type when
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT;
                    Type == ?CUSTOM_ACT_TYPE_LEVEL_ACT_1 ->
                    lib_level_act:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE ->
                    lib_festival_recharge:act_clear(Type, SubType, WLv);
                ?CUSTOM_ACT_RECHARGE_ONE ->
                    lib_recharge_one:day_clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_HOLY_SUMMON ->
                    lib_holy_summon:day_clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_TRAIN_STAGE ->
                    lib_train_act:act_close(Type, SubType);
                ?CUSTOM_ACT_TYPE_TRAIN_POWER ->
                    lib_train_act:act_close(Type, SubType);
                ?CUSTOM_ACT_TYPE_BONUS_POOL ->
                    lib_bonus_pool:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW ->
                    lib_select_pool_draw:act_end(Type, SubType, WLv);
                ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL ->
                    mod_luckey_wheel_local:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_PRAY ->
                    OnlineRoles = ets:tab2list(?ETS_ONLINE),
                    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pray, updata_info, [Type, SubType, close]) || E <- OnlineRoles];
                ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD ->
                    mod_level_draw_reward:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_RECHARGE_RETURN_RESET ->
                    lib_recharge_return:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_FORTUNE_CAT ->
                    lib_fortune_cat:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_CONTRACT_CHALLENGE ->
                    mod_contract_challenge:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_STAR_TREK ->
                    lib_star_trek:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_DESTINY_TURN ->
                    lib_destiny_turntable:act_end(ActInfo);
                Type when
                    Type == ?CUSTOM_ACT_TYPE_ACTIVATION;
                    Type == ?CUSTOM_ACT_TYPE_RECHARGE  ->
                    lib_activation_draw:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
                    lib_bonus_treasure:clear_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_TASK_REWARD ->
                    mod_custom_act_task:clear_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_RUSH_PACKAGE ->
                    lib_rush_package:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_DAILY_DIRECT_BUY ->
                    lib_custom_daily_direct_buy:clear_act_data(Type, SubType);
                ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
                    lib_rush_treasure_api:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE ->
                    lib_envelope_rebate:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_THE_CARNIVAL ->
                    lib_custom_the_carnival:act_end(Type, SubType);
                ?CUSTOM_ACT_TYPE_RECHARGE_POLITE ->
                    lib_custom_act_recharge_polite:act_end(Type, SubType);
                ?CUSTOM_ACT_CYCLE_RANK_RECHARGE ->
                    lib_custom_cycle_rank:act_end(Type, SubType);
                ?CUSTOM_ACT_CYCLE_RANK_ONE_CHARGE ->
                    lib_custom_cycle_rank_recharge:act_end(Type, SubType);
                _ -> skip
            end;
        _ -> skip
    end,
    ok;
notify_other_module(_, _, _, _, _) -> ok.

%% 广播活动开启结束信息
broadcast_act_info(_, []) -> skip;
broadcast_act_info(?CUSTOM_ACT_STATUS_OPEN, ActList) ->
    PackList = pack_custom_act_list(ActList),
    {ok, BinData} = pt_331:write(33102, [PackList]),
    lib_server_send:send_to_all(BinData);
broadcast_act_info(_, _ActList) -> skip.

%is_kf_act(?CUSTOM_ACT_TYPE_FLOWER_RANK, _SubType) -> false;
is_kf_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, _SubType) -> false;
% case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf) of
%     {if_kf, 0} -> false;
%     _ -> true
% end;
is_kf_act(Type, _SubType) ->
    lists:member(Type, ?KF_CUSTOM_ACT_TYPE).

%% 同步跨服定制活动的信息到本服
sync_kf_act_info(ActStatusType, ActInfoL, State) when ActStatusType == ?CUSTOM_ACT_STATUS_CLOSE orelse ActStatusType == ?CUSTOM_ACT_STATUS_MANUAL_CLOSE ->
    #custom_act_state{unopen_kf_act = UnOpenKfActL} = State,
    NowTime = utime:unixtime(),
    F = fun(#act_info{key = {Type, SubType}}, Acc) ->
        case ets:lookup(?ETS_CUSTOM_ACT, {Type, SubType}) of
            [#act_info{wlv = WLv, stime = Stime, etime = Etime}] -> %% 从跨服中心同步过来的时候活动的世界等级默认为-1，如果这个结束的时候活动的世界等级没有变化则视为本服没有参加过这次活动
                ets:delete(?ETS_CUSTOM_ACT, {Type, SubType}),
                case WLv >= 0 of
                    true ->
                        lib_log_api:log_custom_act(Type, SubType, WLv, Stime, Etime, ActStatusType, NowTime);
                    _ -> skip
                end,
                %% 广播给玩家
                {ok, BinData} = pt_331:write(33103, [[{Type, SubType}]]),
                lib_server_send:send_to_all(BinData),
                Acc;
            _ ->
                lists:keydelete({Type, SubType}, #act_info.key, Acc)
        end
        end,
    NewUnOpenKfActL = lists:foldl(F, UnOpenKfActL, ActInfoL),
    State#custom_act_state{unopen_kf_act = NewUnOpenKfActL};
sync_kf_act_info(?CUSTOM_ACT_STATUS_OPEN, ActInfoL, State) ->
    #custom_act_state{unopen_kf_act = UnOpenKfActL} = State,
    timer_check_kf_act(State#custom_act_state{unopen_kf_act = ActInfoL ++ UnOpenKfActL});
sync_kf_act_info(_, _, State) -> State.

%%--------------------------------------------------
%% 打包定制活动列表
%% @param  ActList [#act_info{}]
%% @return         description
%%--------------------------------------------------
pack_custom_act_list(ActList) ->
    F = fun(T, Acc) ->
        case T of
            #act_info{ %% 过滤嗨点活动
                key = {?CUSTOM_ACT_TYPE_HI_POINT, _}
            } -> Acc;
            #act_info{
                key = {Type, SubType},
                wlv = Wlv,
                stime = Stime,
                etime = Etime
            } ->
                case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                    #custom_act_cfg{
                        name = Name,
                        desc = Desc,
                        act_type = ActType,
                        show_id = ShowId,
                        condition = Condition
                    } when Type == ?CUSTOM_ACT_TYPE_BONUS_POOL;Type == ?CUSTOM_ACT_TYPE_INVESTMENT;
                    Type == ?CUSTOM_ACT_TYPE_PRAY; Type == ?CUSTOM_ACT_TYPE_BONUS_TREE->
                        case lists:keyfind(wlv, 1, Condition) of
                            {_, [{Min, Max}|_]} when Wlv >= Min andalso Wlv =< Max ->
                                % ?PRINT("=========== {Type, SubType}:~p~n",[{Type, SubType}]),
                                [{Type, SubType, ActType, ShowId, Wlv, Name, Desc, util:term_to_string(Condition), Stime, Etime} | Acc];
                            _E ->
                                % ?PRINT("_E:~p~n",[_E]),
                                Acc
                        end;
                    #custom_act_cfg{
                        name = Name,
                        desc = Desc,
                        act_type = ActType,
                        show_id = ShowId,
                        condition = Condition
                    } ->
                        [{Type, SubType, ActType, ShowId, Wlv, Name, Desc, util:term_to_string(Condition), Stime, Etime} | Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
        end,
    lists:foldl(F, [], ActList).

%% 发送错误码
send_error_code(RoleId, ErrorCode) ->
    {ok, BinData} = pt_331:write(33100, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).


make_rwparam(RoleId) when is_integer(RoleId) ->
    [_NickName, Sex, Lv, Career| _] = lib_player:get_player_low_data(RoleId),
    make_rwparam(Lv, Sex, Career);
make_rwparam(#player_status{figure = #figure{lv = Lv, sex = Sex, career = Career}}) ->
    Wlv = util:get_world_lv(),
    #reward_param{player_lv = Lv, sex = Sex, wlv = Wlv, career = Career}.

make_rwparam(Lv, Sex, Career) ->
    Wlv = util:get_world_lv(),
    make_rwparam(Lv, Sex, Wlv, Career).
make_rwparam(Lv, Sex, Wlv, Career) ->
    #reward_param{player_lv = Lv, sex = Sex, wlv = Wlv, career = Career}.

make_rank_rwparam(Lv, Sex, Wlv, Career) ->
    #reward_rank_param{player_lv = Lv, sex = Sex, wlv = Wlv, career = Career}.

send_reward_with_act_end(#act_info{stime = StartTime, key = {Type = ?CUSTOM_ACT_TYPE_SIGN_REWARD, SubType}, wlv = Wlv}) ->
    case lib_vsn:is_jp() of % 日文需求,活动结束不发未领奖励
        true -> skip;
        false ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, delete_act_data_to_player_without_db, [Type, SubType]) || E <- OnlineRoles],
            lib_sign_reward_act:send_unrecieve_signact_recharge(act_end, Type, SubType, Wlv, StartTime)
    end,
    ok;
send_reward_with_act_end(#act_info{key = {?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType}} = ActInfo) ->
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType) of
        #custom_act_cfg{clear_type = ClearType} ->
            do_clear_act_data(ActInfo, ClearType),
            do_clear_act_data_with_act_end(ActInfo, ClearType);
        _ -> skip
    end,
    ok;
send_reward_with_act_end(#act_info{key = {?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, _SubType}} = ActInfo) ->
    do_clear_act_data_with_act_end(ActInfo, 1);
send_reward_with_act_end(#act_info{key = {?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubType}}) ->
    mod_feast_cost_rank:act_end(SubType),
    ok;

send_reward_with_act_end(#act_info{key = {Type, SubType}, wlv = Wlv}) when
        Type == ?CUSTOM_ACT_TYPE_BONUS_TREE;Type == ?CUSTOM_ACT_TYPE_MOUNT_TURNTABLE ->
    spawn(fun() ->lib_bonus_tree:send_reward_act_end(Type, SubType, Wlv) end),
    ok;
send_reward_with_act_end(#act_info{key = {Type, SubType}, wlv = _Wlv}) when Type == ?CUSTOM_ACT_TYPE_DRAW_REWARD ->
    lib_bonus_draw:act_end(Type,SubType),
    ok;
send_reward_with_act_end(#act_info{key = {Type, SubType}}) when
        Type == ?CUSTOM_ACT_TYPE_COLWORD;
        Type == ?CUSTOM_ACT_TYPE_LIVENESS ->
    % db:execute(io_lib:format(?delete_custom_drop_log, [Type, SubType])),
    lib_custom_act_api:clear_act_drop(Type, SubType),
    ok;

send_reward_with_act_end(#act_info{key = {Type, SubType}}) when Type == ?CUSTOM_ACT_TYPE_TREE_SHOP ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {money, MoneyType} = ulists:keyfind(money, 1, Conditions, {money, 0}),
    lib_goods_api:db_delete_currency_by_currency_id(MoneyType),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_bonus_tree:refresh_player_data(E#ets_online.id, MoneyType) || E <- OnlineRoles], %% 玩家内存数据处理
    ok;

send_reward_with_act_end(#act_info{key = {Type, SubType}}) when Type == ?CUSTOM_ACT_TYPE_UP_POWER_RANK ->
    mod_up_power_rank:act_end(SubType),
    ok;

send_reward_with_act_end(#act_info{key = {Type, _}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_7_RECHARGE ->
    do_clear_act_data_with_act_end(ActInfo, 1),
    ok;

send_reward_with_act_end(#act_info{key = {Type, _}} = ActInfo) when Type == ?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE ->
    do_clear_act_data_with_act_end(ActInfo, 1),
    ok;

send_reward_with_act_end(_ActInfo) ->
    ok.

%% 领取奖励后传闻
show_tv(?CUSTOM_ACT_TYPE_RECHARGE_GIFT, SubType, Player, RewardCfg, _RewardList) ->
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    Type = ?CUSTOM_ACT_TYPE_RECHARGE_GIFT,
    case lists:keyfind(is_tv, 1, Condition) of
        {is_tv, 1} ->
            WrapperName = lib_player:get_wrap_role_name(Player),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 24, [WrapperName, Type, SubType]);
        _ -> ok
    end;

show_tv(?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType, Player, RewardCfg, RewardList) ->
    #custom_act_reward_cfg{condition = Condition} = RewardCfg,
    WrapperName = lib_player:get_wrap_role_name(Player),
    #player_status{id = PlayerId} = Player,
    case lists:keyfind(grade, 1, Condition) of
        {grade, _} -> % 大奖
            [{_, GoodsTypeId, _}|_] = RewardList,
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 65, [WrapperName, PlayerId, GoodsTypeId]);
        _ -> % 普通奖励
            {_, Tier} = ulists:keyfind(tier, 1, Condition, {tier, 1}),
            GradeList = data_custom_act:get_reward_grade_list(?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType),
            % 获取当前档次的大奖grade_id
            F = fun(GradeId) ->
                #custom_act_reward_cfg{condition = Cond} = data_custom_act:get_reward_info(?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType, GradeId),
                T = lists:keyfind(tier, 1, Cond),
                BigGrade = lists:keyfind(grade, 1, Cond),
                case {T, BigGrade} of
                    {Tier, {grade, _}} -> true;
                    _ -> false
                end
            end,
            % 获取大奖的物品id
            case ulists:find(F, GradeList) of
                {ok, GradeId} ->
                    #custom_act_reward_cfg{reward = RewardL} = data_custom_act:get_reward_info(?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE, SubType, GradeId),
                    [{_, GoodsTypeId, _}|_] = RewardL;
                _ ->
                    GoodsTypeId = 0
            end,
            % 传闻
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 66, [WrapperName, PlayerId, GoodsTypeId])
    end;

show_tv(_Type, _SubType, _Player, _RewardCfg, _RewardList) ->
    ok.

get_open_lv(Type) ->
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    if
        SubTypes =/= [] ->
            [SubType | _] = SubTypes,
            #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lists:keyfind(role_lv, 1, Condition) of
                {_, LimitLv} when is_integer(LimitLv) -> LimitLv;
                _ -> 999
            end;
    % Type == ?CUSTOM_ACT_TYPE_SIGN_REWARD ->
    %     200;
    % Type == ?CUSTOM_ACT_TYPE_EXCHANGE_NEW ->
    %     160;
        true ->
            999
    end.


do_clear_act_data_with_act_end(#act_info{key = {Type, SubType}, stime = NSTime} = ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_RECHARGE_GIFT ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    %% 累计档次的清理
    spawn(fun() ->
        case lib_recharge_data:db_get_all_recharge_log_between_time(NSTime, utime:unixtime()) of
            [] ->
                skip;
            List ->
                ReceiveList = db:get_all(io_lib:format(?select_custom_act_reward_receive_by_type, [Type, SubType])),
                FCombine = fun([RoleId, GradeId, ReceiveTimes, UTime], M) ->
                    OL = maps:get(RoleId, M, []), maps:put(RoleId, [{GradeId, ReceiveTimes, UTime}|OL], M)
                           end,
                ReceiveMap = lists:foldl(FCombine, #{}, ReceiveList),
                F = fun([RoleId, SumGold]) ->
                    RoleReceiveList = maps:get(RoleId, ReceiveMap, []),
                    F2 = fun({GradeId, _ReceiveTimes, _UTime}, L2) ->
                        case lists:member(GradeId, L2) of
                            true ->
                                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                                    RewardCfgFun2 when is_record(RewardCfgFun2, custom_act_reward_cfg) ->
                                        case  lib_custom_act_check:check_reward_receive_times(RoleReceiveList, ActInfo, RewardCfgFun2) of
                                            false ->
                                                lists:delete(GradeId, L2);
                                            _ ->
                                                L2
                                        end;
                                    _ ->
                                        lists:delete(GradeId, L2)
                                end;
                            _ -> L2
                        end
                         end,
                    %% 找出可以领但是没有领的奖励id
                    NotReceiveList = lists:foldl(F2, GradeIdList, RoleReceiveList),
                    %?PRINT("NotReceiveList ~p~n", [{RoleId, NotReceiveList}]),
                    case NotReceiveList == [] of
                        true -> skip;
                        _ ->
                            RewardParam = make_rwparam(RoleId),
                            F3 = fun(GradeId, L3) ->
                                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                                    #custom_act_reward_cfg{condition = Conditions} = RewardCfg ->
                                        case lists:keyfind(gold, 1, Conditions) of
                                            {gold, Gold} when SumGold >= Gold ->
                                                Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                                                Reward ++ L3;
                                            _ -> L3
                                        end;
                                    _ -> L3
                                end
                                 end,
                            GoodsList = lists:foldl(F3, [], NotReceiveList),
                            GoodsList =/= [] andalso
                                lib_mail_api:send_sys_mail([RoleId], utext:get(3310038), utext:get(3310039), GoodsList)
                    end,
                    timer:sleep(100)
                    end,
                lists:foreach(F, List)
        end
          end),
    ok;
do_clear_act_data_with_act_end(#act_info{key = {Type, SubType}, stime = NSTime, etime = EndTime} = ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_CONTINUOUS_RECHARGE ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    %% 累计档次的清理
    spawn(fun() ->
        Map = lib_recharge_data:daily_recharge_map_from_db([{NSTime, EndTime}]),
%%        ?MYLOG("cym", "do_clear_act_data_with_act_end  Map  ~p ~n", [Map]),
        ReceiveList = db:get_all(io_lib:format(?select_custom_act_reward_receive_by_type, [Type, SubType])),
        FCombine = fun([RoleId, GradeId, ReceiveTimes, UTime], M) ->
            OL = maps:get(RoleId, M, []), maps:put(RoleId, [{GradeId, ReceiveTimes, UTime}|OL], M)
                   end,
        ReceiveMap = lists:foldl(FCombine, #{}, ReceiveList),
        F = fun({RoleId, DailyList}) ->
            RoleReceiveList = maps:get(RoleId, ReceiveMap, []),
            F2 = fun({GradeId, _ReceiveTimes, _UTime}, L2) ->
                case lists:member(GradeId, L2) of
                    true ->
                        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                            RewardCfgFun2 when is_record(RewardCfgFun2, custom_act_reward_cfg) ->
                                case  lib_custom_act_check:check_reward_receive_times(RoleReceiveList, ActInfo, RewardCfgFun2) of
                                    false ->
                                        lists:delete(GradeId, L2);
                                    _ ->
                                        L2
                                end;
                            _ ->
                                lists:delete(GradeId, L2)
                        end;
                    _ -> L2
                end
                 end,
            %% 找出可以领但是没有领的奖励id
            NotReceiveList = lists:foldl(F2, GradeIdList, RoleReceiveList),
%%            ?MYLOG("cym", "do_clear_act_data_with_act_end GradeIdList ~p  ~n", [GradeIdList]),
%%            ?MYLOG("cym", "do_clear_act_data_with_act_end NotReceiveList ~p  ~n", [NotReceiveList]),
            %?PRINT("NotReceiveList ~p~n", [{RoleId, NotReceiveList}]),
            case NotReceiveList == [] of
                true -> skip;
                _ ->
                    RewardParam = make_rwparam(RoleId),
%%	                ?IF(4294967405 == RoleId, ?MYLOG("cym", "DailyList ~p  ~n", [DailyList]), skip),
                    F3 = fun(GradeId, L3) ->
                        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                            #custom_act_reward_cfg{condition = Conditions} = RewardCfg ->
                                case lists:keyfind(gold, 1, Conditions) of
                                    {gold, Gold} ->
                                        case lists:keyfind(day, 1, Conditions) of
                                            {day, NeedDay} ->
                                                EnoughDay = lists:sum([1 || #daily_recharge{total_gold = G} <- DailyList, G >= Gold]),
                                                if
                                                    EnoughDay >= NeedDay ->
%%	                                                    ?IF(4294967405 == RoleId, ?MYLOG("cym", "RoleId GradeId  EnoughDay ~p  ~n",
%%		                                                    [{RoleId, GradeId, EnoughDay, NeedDay}]), skip),
                                                        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                                                        Reward ++ L3;
                                                    true ->
                                                        L3
                                                end;
                                            _ ->
                                                L3
                                        end;
                                    _ -> L3
                                end;
                            _ -> L3
                        end
                         end,
                    GoodsList = lists:foldl(F3, [], NotReceiveList),
                    GoodsList =/= [] andalso
                        lib_mail_api:send_sys_mail([RoleId], utext:get(3310099), utext:get(3310100), GoodsList)
            end,
            timer:sleep(100)
            end,
        lists:foreach(F, maps:to_list(Map))
          end),
    ok;

%% 七日累充补发
do_clear_act_data_with_act_end(#act_info{key = {Type, SubType}, stime = NSTime, etime = EndTime} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_7_RECHARGE ->
    % 七日累充的所有档次
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    % 新开进程补发奖励
    spawn(fun() ->
        DailyRechargeMap = lib_recharge_data:daily_recharge_map_from_db([{NSTime, EndTime}]),
        ReceiveList = db:get_all(io_lib:format(?select_custom_act_reward_receive_by_type, [Type, SubType])),
        % F1: 将用户已经领取的档次作为列表存入Map中
        F1 = fun([RoleId, GradeId, _, _], Map) ->
            OldReceived = maps:get(RoleId, Map, []),
            maps:put(RoleId, [GradeId | OldReceived], Map)
        end,
        % 用户已经领取的档次 RoleId => [Grade1, Grade2...]
        ReceivedGradeMap = lists:foldl(F1, #{}, ReceiveList),
        % F2: 将用户七天内的充值总额存入AllRechargeMap中 RoleId => Golds
        F2 = fun({RoleId, DailyList}, AllRechargeMap) ->
            AllRecharge = lists:foldl(
                fun(#daily_recharge{total_gold = G}, All) ->
                    All + G
                end, 0, DailyList),
            maps:put(RoleId, AllRecharge, AllRechargeMap)
        end,
        AllRechargeMap = lists:foldl(F2, #{}, maps:to_list(DailyRechargeMap)),
        % SendReward: 将没有领取的档次奖励补发
        SendReward = fun({RoleId, TotalRecharge}) ->
            % F3 ：将满足条件但没有领取的奖励筛选出来
            F3 = fun(GradeId, RewardList) ->
                try
                    RewardParam = make_rwparam(RoleId),
                    #custom_act_reward_cfg{condition = Conditions} =
                    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                    {gold, NeedValue} = lists:keyfind(gold, 1, Conditions),
                    case TotalRecharge >= NeedValue andalso not lists:member(GradeId, maps:get(RoleId, ReceivedGradeMap, [])) of
                        true ->
                            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                            Reward ++ RewardList;
                        false ->
                            RewardList
                    end
                catch
                    _ErrType : Reason ->
                        ?ERR("Reward send error, RoleId: ~p, Config Err: ~p", [RoleId, Reason]),
                        []
                end
            end,

            % 发放奖励
            RewardList = lists:foldl(F3, [], GradeIdList),
            case RewardList of
                [] -> skip;
                RewardList ->
                    lib_mail_api:send_sys_mail([RoleId], utext:get(3310103), utext:get(3310104), RewardList)
            end
        end,
        lists:foreach(SendReward, maps:to_list(AllRechargeMap))
    end),
    ok;

do_clear_act_data_with_act_end(#act_info{key = {Type, SubType}, stime = NSTime, etime = EndTime} = _ActInfo, _ClearType) when Type == ?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    % 新开进程补发奖励
    spawn(fun() ->
        DailyRechargeMap = lib_recharge_data:daily_recharge_map_from_db([{NSTime, EndTime}]),
        ReceiveList = db:get_all(io_lib:format(?select_custom_act_reward_receive_by_type, [Type, SubType])),
        % F1: 将用户已经领取的档次作为列表存入Map中
        F1 = fun([RoleId, GradeId, _, _], Map) ->
            OldReceived = maps:get(RoleId, Map, []),
            maps:put(RoleId, [GradeId | OldReceived], Map)
        end,
        % 用户已经领取的档次 RoleId => [Grade1, Grade2...]
        ReceivedGradeMap = lists:foldl(F1, #{}, ReceiveList),
        F2 = fun({RoleId, DailyList}, AllRechargeMap) ->
            AllRecharge = lists:foldl(
                fun(#daily_recharge{total_gold = G}, All) ->
                    All + G
                end, 0, DailyList),
            maps:put(RoleId, AllRecharge, AllRechargeMap)
        end,
        AllRechargeMap = lists:foldl(F2, #{}, maps:to_list(DailyRechargeMap)),
        % SendReward: 将没有领取的档次奖励补发
        SendReward = fun({RoleId, TotalRecharge}) ->
            % F3 ：将满足条件但没有领取的奖励筛选出来
            F3 = fun(GradeId, RewardList) ->
                try
                    RewardParam = make_rwparam(RoleId),
                    #custom_act_reward_cfg{condition = Conditions} =
                        RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                    {gold, NeedValue} = lists:keyfind(gold, 1, Conditions),
                    case TotalRecharge >= NeedValue andalso not lists:member(GradeId, maps:get(RoleId, ReceivedGradeMap, [])) of
                        true ->
                            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                            Reward ++ RewardList;
                        false ->
                            RewardList
                    end
                catch
                    _ErrType : Reason ->
                        ?ERR("Reward send error, RoleId: ~p, Config Err: ~p", [RoleId, Reason]),
                        []
                end
            end,
            % 发放奖励
            RewardList = lists:foldl(F3, [], GradeIdList),
            case RewardList of
                [] -> skip;
                RewardList ->
                    lib_mail_api:send_sys_mail([RoleId], utext:get(3310207), utext:get(3310208), RewardList)
            end
        end,
        lists:foreach(SendReward, maps:to_list(AllRechargeMap))
    end),
    ok;

do_clear_act_data_with_act_end(_ActInfo, _ClearType) ->
    skip.

%% ----------------------------------------------------------------------------------------------------------
%% @desc     功能描述   处理定制活动的额外逻辑
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------------------------------------------------
handle_other_act_start(#act_info{key = {?CUSTOM_ACT_TYPE_FEAST_BOSS, _SubType}}) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_BOSS) of
        true ->
            skip;
        false ->
%%            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 28, []),
            mod_boss:feast_boss_act_start()
    end;
handle_other_act_start(#act_info{key = {?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT, SubType}, stime = StartTime, etime = EndTime}) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_TIME_LIMIT_GIFT) of
        true ->
            skip;
        false ->
            %%开启活动的时候清理旧数据
            lib_limit_gift:del_limit_gift_over_data(SubType, StartTime, EndTime)

    end;
handle_other_act_start(_ActInfo) ->
    ok.

%%handle_other_act_end(#act_info{key = {?CUSTOM_ACT_TYPE_FEAST_BOSS,  _SubType}}) ->
%%    case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_BOSS) of
%%        true ->
%%            ?MYLOG("cym", "feast  boss end ~n",  []),
%%            mod_boss:feast_boss_act_end();
%%        false ->
%%            skip
%%    end;
%%handle_other_act_end(_)  ->
%%    ok.


handle_other_act() ->
    %%处理节日boss
    TimeOpen   = lib_custom_act_api:is_feast_boss_time_open(),
    ActOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_BOSS), %%当天是否开启
    case lib_custom_act_api:is_feast_boss_tv_time() of
        {true, TvM} ->
            if
                TvM == 0 ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 28, []);
                true ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 27, [TvM])
            end;
        _ ->
            skip
    end,
    if
        TimeOpen == false andalso ActOpen -> %% 当天活动开启， 但是时间条件不满足
            mod_boss:feast_boss_act_end(); %%清理数据
        true ->
            skip
    end.

%% ---------------------------------------------------------------------------
%% @doc 获取指定活动的活动数据
-spec act_data(Player, Type, SubType) -> Return when
    Player      :: #player_status{},
    Type        :: integer(),
    SubType     :: integer(),
    Return      :: false | #custom_act_data{}.
%% ---------------------------------------------------------------------------
act_data(Player, Type, SubType) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    Key = {Type, SubType},
    maps:get(Key, DataMap, false).

%% ---------------------------------------------------------------------------
%% @doc 获取指定活动的活动数据
-spec act_other_data(Player, Type, SubType) -> Return when
    Player      :: #player_status{},
    Type        :: integer(),
    SubType     :: integer(),
    Return      :: false | term().
%% ---------------------------------------------------------------------------
act_other_data(Player, Type, SubType) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{other_data_map = DataMap} = StatusCustomAct,
    Key = {Type, SubType},
    maps:get(Key, DataMap, false).

%% ---------------------------------------------------------------------------
%% @doc 保存活动数据到角色
-spec save_act_data_to_player(Player, ActData) -> NewPlayer when
    Player      :: #player_status{},
    ActData     :: #custom_act_data{},
    NewPlayer   :: #player_status{}.
%% ---------------------------------------------------------------------------
save_act_data_to_player(Player, ActData) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    Key = ActData#custom_act_data.id,
    NewDataMap = maps:put(Key, ActData, DataMap),
    NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
    db_save_custom_act_data(Player, ActData),
    Player#player_status{status_custom_act = NewStatusCustomAct}.

%% ---------------------------------------------------------------------------
%% @doc 保存活动数据到角色
-spec save_other_act_data_to_player(Player, Type, SubType, Data) -> NewPlayer when
    Player      :: #player_status{},
    Type        :: integer(),
    SubType     :: integer(),
    Data        :: term(),
    NewPlayer   :: #player_status{}.
%% ---------------------------------------------------------------------------
save_other_act_data_to_player(Player, Type, SubType, Data) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{other_data_map = OtherDataMap} = StatusCustomAct,
    NewOtherDataMap = maps:put({Type, SubType}, Data, OtherDataMap),
    NewStatusCustomAct = StatusCustomAct#status_custom_act{other_data_map = NewOtherDataMap},
    Player#player_status{status_custom_act = NewStatusCustomAct}.

%% 删除定制活动数据到角色(不处理数据库)
delete_act_data_to_player_without_db(Player, Type, SubType) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    NewDataMap = maps:remove({Type, SubType}, DataMap),
    NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
    Player#player_status{status_custom_act = NewStatusCustomAct}.

%% ---------------------------------------------------------------------------
%% @doc 获得定制活动的保存的统计数据
-spec db_load_custom_act_data(PlayerId) -> DataList when
    PlayerId    :: integer(),
    DataList    :: [#custom_act_data{}].
%% ---------------------------------------------------------------------------
db_load_custom_act_data(PlayerId) ->
    SQL = io_lib:format(?SQL_SELECT_CUSTOM_ACT_DATA, [PlayerId]),
    DbList = db:get_all(SQL),
    F = fun(T, TmpList) ->
            Tmp = make_record(custom_act_data, T),
            [Tmp | TmpList]
    end,
    DataList = lists:foldl(F, [], DbList),
    DataList.

%% ---------------------------------------------------------------------------
%% @doc 定制活动的保存的统计数据保存到数据库
-spec db_save_custom_act_data(Player, CustomActData) -> ok when
    Player          :: #player_status{},
    CustomActData   :: #custom_act_data{}.
%% ---------------------------------------------------------------------------
db_save_custom_act_data(PlayerId, CustomActData) when is_integer(PlayerId)->
    #custom_act_data{type = Type, subtype = SubType, data = Data} = CustomActData,
    NewData = convert_db_data(Type, SubType, Data),
    SQL = io_lib:format(?SQL_SAVE_CUSTOM_ACT_DATA, [PlayerId, Type, SubType, NewData]),
    db:execute(SQL),
    ok;
db_save_custom_act_data(Player, CustomActData) ->
    #player_status{id = PlayerId} = Player,
    #custom_act_data{type = Type, subtype = SubType, data = Data} = CustomActData,
    NewData = convert_db_data(Type, SubType, Data),
    SQL = io_lib:format(?SQL_SAVE_CUSTOM_ACT_DATA, [PlayerId, Type, SubType, NewData]),
    db:execute(SQL),
    ok.

convert_db_data(Type, SubType, Data) when Type == ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
    NewData = lib_bonus_treasure:convert_db_data(Type, SubType, Data),
    util:term_to_string(NewData);
convert_db_data(_Type, _SubType, Data) -> util:term_to_string(Data).

%% ---------------------------------------------------------------------------
%% @doc 根据主次类别删除定制活动的保存的统计数据
-spec db_delete_custom_act_data(Type, SubType) -> ok when
    Type        :: integer(),
    SubType     :: integer().
%% ---------------------------------------------------------------------------
db_delete_custom_act_data(Type, SubType) ->
    SQL = io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType]),
    db:execute(SQL),
    ok.

%% ---------------------------------------------------------------------------
%% @doc 删除定制活动的保存的统计数据
-spec db_delete_custom_act_data(PlayerId, Type, SubType) -> ok when
    PlayerId    :: integer() | #player_status{},
    Type        :: integer(),
    SubType     :: integer().
%% ---------------------------------------------------------------------------
db_delete_custom_act_data(PlayerId, Type, SubType) when is_integer(PlayerId) ->
    SQL = io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_2, [PlayerId, Type, SubType]),
    db:execute(SQL),
    ok;
db_delete_custom_act_data(Player, Type, SubType) ->
    #player_status{id = PlayerId} = Player,
    db_delete_custom_act_data(PlayerId, Type, SubType).
