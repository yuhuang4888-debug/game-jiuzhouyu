%%-----------------------------------------------------------------------------
%% @Module  :       lib_custom_act_kf
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    跨服定制活动逻辑模块
%%-----------------------------------------------------------------------------
-module(lib_custom_act_kf).

-include("custom_act.hrl").
-include("daily.hrl").
-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
    get_custom_act_list/0
    , reload_act_list/1
    , timer_check/1
    , day_trigger/1
    , act_end/3
    , sync_server_data/2
]).

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

    db:execute(io_lib:format(?clear_opening_kf_custom_act, [])),
    ets:delete_all_objects(?ETS_CUSTOM_ACT),

    {ok, ActList} = get_custom_act_list(),

    NowTime = utime:unixtime(),
    ArgsMap = lib_custom_act_util:make_check_args_map(NowTime),
    F = fun(T, Acc) ->
            case T of
                {Type, SubType} ->
                    case do_timer_check(Type, SubType, ArgsMap) of
                        {true, Stime, Etime} ->
                            ActInfo = #act_info{key = {Type, SubType}, wlv = 0, stime = Stime, etime = Etime},
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
    BroadCastL = lists:foldl(F, [], ActList),
    %% 同步跨服定制活动信息到各个服
    sync_to_local(?CUSTOM_ACT_STATUS_OPEN, BroadCastL),
    ?ERR("Reload Custom Act List In Kf, BroadCastL:~p", [BroadCastL]),
    State.

%% 从配置获取定制活动列表
%% 非跨服的定制活动类型要过滤掉
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
    ActList0 = [{Type, SubType} || {Type, SubType} <- NormalList ++ ExtraList, lib_custom_act:is_kf_act(Type, SubType)],
    % 对只能开启一个子类型的活动进行处理,使子类型较大的排前面进行判断
    F = fun({Type, _}) -> lists:member(Type, ?UNIQUE_CUSTOM_ACT_TYPE) end,
    {ActList1, ActList2} = lists:partition(F, ActList0),
    ActList2 ++ lists:reverse(lists:sort(ActList1)).

%% 活动开启
act_start(_OpenType, ActInfo, _NowTime) ->
    #act_info{key = {Type, SubType}, wlv = WLv, stime = Stime, etime = Etime} = ActInfo,
    OpSubtypeL = lib_custom_act_util:get_open_subtype_list(Type),
    case lib_custom_act_check:check_unique_type(Type) of
        true ->
            case OpSubtypeL of
                [] -> %% 同类型的活动没有开启直接开启
                    BroadCastL = [ActInfo],
                    db:execute(io_lib:format(?insert_opening_kf_custom_act, [Type, SubType, WLv, Stime, Etime])),
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                [#act_info{key = {Type, SubType}, stime = OStime, etime = OEtime}] when OStime =/= Stime; OEtime =/= Etime -> %% 类型相同的更新开启结束时间
                    BroadCastL = [ActInfo],
                    db:execute(io_lib:format(?update_opening_kf_custom_act, [Stime, Etime, Type, SubType])),
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                _ -> BroadCastL = []
            end;
        false ->
            case lists:keyfind({Type, SubType}, #act_info.key, OpSubtypeL) of
                false ->
                    BroadCastL = [ActInfo],
                    db:execute(io_lib:format(?insert_opening_kf_custom_act, [Type, SubType, WLv, Stime, Etime])),
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                #act_info{stime = OStime, etime = OEtime} when OStime =/= Stime; OEtime =/= Etime -> %% 类型相同的更新开启结束时间
                    BroadCastL = [ActInfo],
                    db:execute(io_lib:format(?update_opening_kf_custom_act, [Stime, Etime, Type, SubType])),
                    ets:insert(?ETS_CUSTOM_ACT, ActInfo);
                _ -> BroadCastL = []
            end
    end,
    case BroadCastL =/= [] of
        true ->
            %% 通知其他功能模块定制活动的开启状态
            notify_other_module(?CUSTOM_ACT_STATUS_OPEN, ActInfo, Stime, Etime);
        false -> skip
    end,
    BroadCastL.

%% 活动结束
act_end(CloseType, ActInfo, NowTime) ->
    #act_info{
        key   = {Type, SubType},
        wlv   = WLv,
        stime = Stime,
        etime = Etime
    } = ActInfo,
    db:execute(io_lib:format(?delete_opening_kf_custom_act, [Type, SubType])),
    ets:delete(?ETS_CUSTOM_ACT, {Type, SubType}),
    lib_log_api:log_custom_act(Type, SubType, WLv, Stime, Etime, CloseType, NowTime),
    %% 同步跨服定制活动信息到各个服
    sync_to_local(CloseType, [ActInfo]),
    notify_other_module(CloseType, ActInfo, Stime, Etime).

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
            NowTime = utime:unixtime(),
            ArgsMap = lib_custom_act_util:make_check_args_map(NowTime),

            %% 先处理已开启的活动的结算逻辑
            act_settlement(NowTime),

            F = fun(T, Acc) ->
                    case T of
                        {Type, SubType} ->
                            case do_timer_check(Type, SubType, ArgsMap) of
                                {true, Stime, Etime} ->
                                    ActInfo = #act_info{key = {Type, SubType}, wlv = 0, stime = Stime, etime = Etime},
                                    TList = act_start(?TIMER_START, ActInfo, NowTime),
                                    TList ++ Acc;
                                _ ->
                                    Acc
                            end;
                        _ -> Acc
                    end
                end,
            BroadCastL = lists:foldl(F, [], ActList),
            %% 同步跨服定制活动信息到各个服
            sync_to_local(?CUSTOM_ACT_STATUS_OPEN, BroadCastL),
            State;
        {reload} -> %% 重新加载定制活动
            %% 由于外服推送beam到热更有时间差，可能导致这次检测到时候beam文件还未热而取得的旧的配置，所以要多次重新加载
            NewRef = util:send_after(State#custom_act_state.rl_check_ref, 60000, self(), {'reload'}),
            reload_act_list(State#custom_act_state{rl_check_ref = NewRef, rl_check_times = 0})
    end.

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
    clear_act_data(?CUSTOM_ACT_CLEAR_ZERO);
day_trigger(?FOUR) ->
    clear_act_data(?CUSTOM_ACT_CLEAR_FOUR);
day_trigger(_) -> skip.

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
    F = fun(T) ->
        #act_info{
            key = {Type, SubType}
        } = T,
        case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
            #custom_act_cfg{clear_type = ClearType} ->
                do_clear_act_data(Type, SubType);
            _ -> skip
        end
    end,
    lists:foreach(F, OpSubtypeL).

%% 这里只做各个进程自己的数据清理
do_clear_act_data(_Type, _SubType) ->
    skip.

%%--------------------------------------------------
%% %% 通知其他功能模块定制活动的开启状态
%% @param  ActStatus CUSTOM_ACT_STATUS_CLOSE | CUSTOM_ACT_STATUS_OPEN | CUSTOM_ACT_STATUS_MANUAL_CLOSE
%% 注:CUSTOM_ACT_STATUS_MANUAL_CLOSE类型直接清理相关数据即可,不用处理发奖励的逻辑
%% @param  Type      活动主类型
%% @param  SubType   活动子类型
%% @param  Stime     活动开始时间 活动开始时Stime的值不一定就是当前时间
%% @param  Etime     活动结束时间 活动结束时Etime的值不一定就是当前时间
%% @return           description
%%--------------------------------------------------
notify_other_module(ActStatus, #act_info{key = {Type, SubType}} = ActInfo, _Stime, _Etime) ->
    case ActStatus of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            case Type of
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD ->
                    mod_kf_cloud_buy:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GBOLD ->
                    mod_kf_cloud_buy:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_FEAST_COST_RANK2 ->
                    mod_feast_cost_rank_clusters:act_end(SubType);
                ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                    mod_kf_flower_act:send_reward(SubType);
                ?CUSTOM_ACT_TYPE_KF_GROUP_BUY ->
                    mod_kf_group_buy:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_ESCORT ->
                    mod_escort_kf:custom_act_end();
                _ -> skip
            end;
        ?CUSTOM_ACT_STATUS_OPEN ->
            case Type of
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD ->
                    mod_kf_cloud_buy:act_start(Type, SubType, ActInfo);
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GBOLD ->
                    mod_kf_cloud_buy:act_start(Type, SubType, ActInfo);
                ?CUSTOM_ACT_TYPE_FEAST_COST_RANK2 ->
                    mod_feast_cost_rank_clusters:act_start(SubType);
                ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                    mod_kf_flower_act:act_open(SubType);
                ?CUSTOM_ACT_TYPE_KF_GROUP_BUY ->
                    mod_kf_group_buy:act_start(ActInfo);
                ?CUSTOM_ACT_TYPE_ESCORT ->
                    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                        #custom_act_cfg{condition = Condition} ->
                            {_, List} = ulists:keyfind(time, 1, Condition, {time, []}),
                            mod_escort_kf:act_start(List);
                        _ ->
                            skip
                    end;
                _  -> skip
            end;
        ?CUSTOM_ACT_STATUS_MANUAL_CLOSE ->
            case Type of
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GOLD ->
                    mod_kf_cloud_buy:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_KF_CLOUD_BUY_GBOLD ->
                    mod_kf_cloud_buy:act_end(ActStatus, ActInfo);
                ?CUSTOM_ACT_TYPE_FEAST_COST_RANK2 ->
                    mod_feast_cost_rank_clusters:act_end(SubType);
                ?CUSTOM_ACT_TYPE_FLOWER_RANK ->
                    mod_kf_flower_act:send_reward(SubType);
                ?CUSTOM_ACT_TYPE_KF_GROUP_BUY ->
                    mod_kf_group_buy:act_end(ActInfo);
                ?CUSTOM_ACT_TYPE_ESCORT ->
                    mod_escort_kf:custom_act_end();
                _  -> skip
            end;
        _ -> skip
    end,
    ok.

sync_server_data(State, ServerId) ->
    OpenList = lib_custom_act_util:get_custom_act_open_list(),
    mod_clusters_center:apply_cast(ServerId, mod_custom_act, sync_kf_act_info, [?CUSTOM_ACT_STATUS_OPEN, OpenList]),
    State.


%%--------------------------------------------------
%% 同步跨服定制活动信息到各个本地服
%% @param  Type     见CUSTOM_ACT_STATUS
%% @param  ActInfoL [#act_info{}]
%% @return          description
%%--------------------------------------------------
sync_to_local(Type, ActInfoL) ->
    mod_clusters_center:apply_to_all_node(mod_custom_act, sync_kf_act_info, [Type, ActInfoL]).
