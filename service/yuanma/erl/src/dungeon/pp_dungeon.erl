%% ---------------------------------------------------------------------------
%% @doc pp_dungeon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本协议处理
%% ---------------------------------------------------------------------------
-module(pp_dungeon).
-export([handle/3]).

-include("server.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("def_daily.hrl").
-include("errcode.hrl").
-include("def_vip.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% 进入副本
handle(61001, Player, [DunId]) ->
    lib_dungeon:enter_dungeon(Player, DunId);

%% 主动退出副本
handle(61002, Player, []) ->
    % ?PRINT("RoleId:~p ~n", [Player#player_status.id]),
    lib_dungeon:active_quit(Player);

%% 通用结算界面
handle(61003, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:push_settlement(CopyId, RoleId);
        false -> skip
    end;

%% 副本信息
handle(61004, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_dungeon_info(Player#player_status.copy_id, Player#player_status.sid);
        false -> skip
    end;

%% 事件触发
handle(61006, Player, [EventTypeId]) ->
    % ?PRINT("61006 EventTypeId:~p ~n", [EventTypeId]),
    #player_status{id = RoleId, scene = SceneId, scene_pool_id = ScenePoolId} = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            mod_scene_agent:dispatch_dungeon_event(SceneId, ScenePoolId, RoleId, EventTypeId);
        _ ->
            skip
    end;

%% 坐标事件
handle(61007, Player, [X, Y]) ->
    % ?PRINT("61007 X:~p, Y:~p ~n", [X, Y]),
    #player_status{scene = SceneId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:dispatch_dungeon_event(CopyId, ?DUN_EVENT_TYPE_ID_ROLE_XY, #dun_callback_role_xy{scene_id = SceneId, x = X, y = Y});
        false -> skip
    end;

%% 发送剧情事件
handle(61010, Player, [StoryId, SubStoryId, IsEnd]) when IsEnd == 0 orelse IsEnd == 1 ->
    % ?PRINT("61010 StoryId:~p, SubStoryId:~p ~n", [StoryId, SubStoryId]),
    #player_status{copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:update_story(CopyId, StoryId, SubStoryId, IsEnd);
        false -> skip
    end;

%% 助战次数
handle(61011, #player_status{id = RoleId} = Player, [DunId]) ->
    Dun = data_dungeon:get(DunId),
    if
        is_record(Dun, dungeon) == false -> HelpCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, DunId);
        true ->
            CountType = lib_dungeon_api:get_daily_help_type(Dun#dungeon.type, DunId),
            HelpType
            = case Dun#dungeon.type of
                ?DUNGEON_TYPE_EQUIP ->
                    ?MOD_DUNGEON_HELP_AWARD;
                ?DUNGEON_TYPE_DRAGON ->
                    ?MOD_DUNGEON_HELP_AWARD;
                _ ->
                    ?MOD_DUNGEON_HELP
            end,
            HelpCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, HelpType, CountType)
    end,
    MaxHelpCount = lib_dungeon:get_max_help_count(Dun),
    LeftCount = max(MaxHelpCount - HelpCount, 0),
    {ok, BinData} = pt_610:write(61011, [DunId, LeftCount]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 结算界面
handle(61013, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:push_settlement(CopyId, RoleId);
        false -> skip
    end;

%% 剧情播放通知
handle(61014, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_story_list(CopyId, RoleId);
        false -> skip
    end;

%% 结算界面2(关卡)
handle(61016, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:push_settlement(CopyId, RoleId);
        false -> skip
    end;

%% 跳过副本
handle(61017, Player, []) ->
    lib_dungeon:skip_dungeon(Player);

%% 退出副本时间
handle(61018, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_flow_quit_time(CopyId, RoleId);
        false -> skip
    end;

%% 发送坐标事件的触发情况
handle(61019, Player, [SceneId]) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_xy_list(CopyId, RoleId, SceneId);
        false -> skip
    end;

% ########### 获取副本状态信息 ##############
handle(61020, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    handle(61020, NewPlayer, Args),
    {ok, NewPlayer};

% ########### 获取副本状态信息 ##############
handle(61020, Player, [DunType]) ->
    #player_status{dungeon_record = Rec, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    DataList = lib_dungeon:create_dungeon_infos(Rec, DunType),
    lib_dungeon:get_daily_data(RoleId, DataList, DunType, {lib_dungeon, send_dungeon_info, [RoleLv]});
    % {ok, BinData} = pt_610:write(61020, [DunType, DataList]),
    % lib_server_send:send_to_sid(Sid, BinData);

% ########### 购买副本次数 ##############
% 购买的次数含义根据副本类型不同而不同 如聚魂副本是重置次数，而宠物副本是进入次数
handle(61021, Player, [DunId, Count]) when Count > 0 ->
    {ok, NewPlayer} = lib_dungeon:buy_count(Player, DunId, Count),
    {ok, NewPlayer};

%% 扫荡
handle(61022, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61022, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;
handle(61022, #player_status{pid = Pid, id = PlayerId} = Player, [DunId, AutoNum]) ->
%%    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    Dun = data_dungeon:get(DunId),
    IsOnSameType = lib_dungeon:is_on_same_dun_type(DunId, Player),  %% 扫荡类型和所在副本类型一致，则不允许扫荡
    case Dun of
        #dungeon{} ->
            NoCfg = false;
        _ ->
            NoCfg = true
    end,
    if
        IsOnSameType ->
            Code = ?ERRCODE(err610_had_on_dungeon), RewardsList = [], NewPlayer = Player, Score = 0, DailyCount = undefined;
        NoCfg ->
            Code = ?ERRCODE(err_config), RewardsList = [], NewPlayer = Player, Score = 0, DailyCount = undefined; %% 因为成功才会使用，所以这里填undefined
        true ->
            #dungeon{type = DunType, count_cond = CountCondition} = Dun,
            %% 获取副本进入次数和购买次数
            DailyList = lib_dungeon_api:get_daily_sweep_times_type_list(DunType),
            DailyCountList = mod_daily:get_count(Player#player_status.id, DailyList),
            HasSweepNum = mod_daily:get_count(PlayerId, ?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DunType),   %% 已经扫荡的次数
            case lib_dungeon_sweep:check_sweep(Player, Dun, AutoNum, DailyCountList, HasSweepNum + 1) of
                {false, Code} ->
                    RewardsList = [], NewPlayer = Player, Score = 0, DailyCount = undefined;
                {ok, RewardsList0, BaseCosts, Score} ->
                    Costs = [I || {_, _, Num} = I <- BaseCosts, Num > 0],
                    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
                    DailyCount = lib_dungeon_resource:get_daily_sweep_times(DunType, AutoNum, CountType, DailyCountList),
                    Rewards = lib_dungeon_api:get_sweep_all_reward(RewardsList0),
                    %% 消耗物品
                    Result = lib_goods_do:can_give_goods(Rewards, [?GOODS_LOC_BAG]),
                    case Result of
                        {false, ResultCode} ->
                            CanGive = false,
                            GoodsEnough = false,
                            CostPlayer = Player;
                        true ->
                            CanGive = true,
                            ResultCode = 1,
                            Mark = lists:concat([DunId, "-", AutoNum]),
                            case lib_dungeon_sweep:sweep_cost(Player, DunId, DunType, Costs, dungeon_count_sweep_cost, Mark) of
                                {true, CostPlayer} ->
                                    GoodsEnough = true;
                                _ ->
                                    GoodsEnough = false,
                                    CostPlayer = Player
                            end
                    end,
                    %% 发送奖励
                    if
                        CanGive == false ->
                            Code = ResultCode,
                            RewardsList = [],
                            NewPlayer = Player;
                        GoodsEnough == false ->
                            Code = ?ERRCODE(goods_not_enough),
                            RewardsList = [],
                            NewPlayer = Player;
                        true ->
                            lib_dungeon:dungeon_count_plus(CountCondition, DunId, DunType, Player#player_status.id, AutoNum),
                            ?IF(DunType == ?DUNGEON_TYPE_PET2, mod_daily:increment(Player#player_status.id, ?MOD_DUNGEON, 11), skip),
                            Code = ?SUCCESS,
                            IsOnLine = ?IF(Pid == undefined, false, is_process_alive(Pid)),
                            if
                                IsOnLine == true ->
                                    {RewardsList, TmpPlayer} = lib_dungeon_sweep:send_sweep_dungeon_reward_online(DunType, CostPlayer, RewardsList0);
                                true ->
                                    {RewardsList, TmpPlayer} = lib_dungeon_sweep:send_sweep_dungeon_reward_offline(DunType, CostPlayer, RewardsList0, Rewards)
                            end,
                            Data = #callback_dungeon_succ{dun_id = Dun#dungeon.id, dun_type = Dun#dungeon.type, count = AutoNum},
                            lib_player_event:async_dispatch(CostPlayer#player_status.id, ?EVENT_DUNGEON_SUCCESS, Data),
                            lib_hi_point_api:hi_point_task_sweep_dun(Player#player_status.id, Player#player_status.figure#figure.lv, DunType, AutoNum),
                            %?MYLOG("lwccard","RewardsList:~p~n",[RewardsList]),
                            {ok, SupVipPlayer} = lib_supreme_vip_api:dun_clean(TmpPlayer, Dun#dungeon.type, AutoNum),
                            NewPlayer = lib_dungeon_sweep:handle_finish_duns(SupVipPlayer, DunType, lists:duplicate(AutoNum, Dun#dungeon.id)),
                            handle(61038, NewPlayer, [DunType]),
                            pp_dungeon_sec:handle(61121, NewPlayer, [DunType])
                    end
            end
    end,
    case Code =:= ?SUCCESS of
        true ->
            %% 61022 DailyCount 在为资源副本时，对应的当天已扫荡的总次数
            {ok, BinData} = pt_610:write(61022, [Code, DunId, Score, DailyCount, AutoNum, RewardsList]);
        _ ->
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_610:write(61000, [CodeInt, CodeArgs])
    end,
    lib_server_send:send_to_sid(NewPlayer#player_status.sid, BinData),
    {ok, NewPlayer};

% ########### 获取当前时间评分状态 ##############
handle(61023, Player, []) ->
    #player_status{copy_id = CopyId, id = RoleId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:get_time_score_step(CopyId, RoleId);
        false -> skip
    end;

% ########### 获取副本是否可用 ##############
handle(61024, Player, []) ->
    AllTypes = data_dungeon:get_types(),
    F = fun
        (Type) ->
            {_DunId, Res} = lib_dungeon:get_recommend_dun(Player, Type),
            {Type, Res}
    end,
    List = [F(T) || T <- AllTypes],
    {ok, BinData} = pt_610:write(61024, [List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

% ########### 鼓舞 ##############
handle(61025, Player, [CostType]) when
    CostType =:= ?ENCOURAGE_COST_TYPE_COIN orelse
    CostType =:= ?ENCOURAGE_COST_TYPE_GOLD ->
    #player_status{copy_id = CopyId, id = RoleId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:encourage(CopyId, RoleId, CostType);
        false -> skip
    end;

% ########### 鼓舞状态数据 ##############
handle(61026, Player, []) ->
    #player_status{copy_id = CopyId, id = RoleId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:get_encourage_count(CopyId, RoleId);
        false -> skip
    end;

%% ########### 副本重置 ##############
handle(61027, Player, [DunId]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            ResetCountType = lib_dungeon_api:get_daily_reset_type(DunType, DunId),
            %% 购买次数要么是重置次数要么是日常次数
            BuyCountType = lib_dungeon_api:get_daily_buy_type(DunType, DunId),
            DailyList = lib_dungeon_api:get_daily_count_type_list(DunType),
            List = [{?MOD_DUNGEON, ?MOD_DUNGEON_RESET, ResetCountType},{?MOD_DUNGEON, ?MOD_DUNGEON_BUY, BuyCountType}|DailyList],
            case data_dungeon_special:get(ResetCountType, dungeon_reset_count) of
                undefined ->
                    lib_server_send:send_to_sid(Sid, pt_610, 61000, [?FAIL, []]);
                ResetCountLimit ->
                    % ResetCountLimit = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, VipRightType, VipLv),
                    case mod_daily:get_count(RoleId, List) of
                        [{ResetKey, ResetCount},{_, BuyCount}|DailyCountList] when ResetCount < ResetCountLimit + BuyCount ->
                            case [X || {_, C} = X <- DailyCountList, C > 0] of
                                [] -> %% 当前无需重置
                                    lib_server_send:send_to_sid(Sid, pt_610, 61000, [?ERRCODE(err610_nothing_reset), []]);
                                AvailableList ->
                                    ReduceList = [{K, C-1} || {K, C} <- AvailableList],
                                    SetList = [{ResetKey, ResetCount + 1}|ReduceList],
                                    mod_daily:set_count(RoleId, SetList),
%%                                    ?IF(DunType == ?DUNGEON_TYPE_RUNE, mod_hi_point:clear_flag(?MOD_DUNGEON, DunType), skip),
                                    lib_server_send:send_to_sid(Sid, pt_610, 61027, [DunId]),
                                    handle(61038, Player, [DunType])
                            end;
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_610, 61000, [?ERRCODE(err610_reset_count_limit), []])
                    end
            end;
        _ ->
            skip
    end;

% ########### 按类型扫荡 ##############

handle(61028, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61028, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;
handle(61028, #player_status{pid = Pid} = Player, [DunType]) ->
    IsOnLine = ?IF(Pid == undefined, false, is_process_alive(Pid)),
    case lib_dungeon:is_on_same_dun_type2(DunType, Player) of
        true ->
            Code = ?ERRCODE(err610_had_on_dungeon), RewardsList = [], NewPlayer = Player;
        _ ->
            case lib_dungeon_sweep:check_sweep(Player, DunType) of
                {false, Code} ->
                    RewardsList = [], NewPlayer = Player;
                {ok, RewardsList0, Costs} ->
                    Mark = lists:concat([DunType, ":", length(RewardsList0)]),
                    Rewards = lib_goods_api:make_reward_unique(lists:flatten([R1 ++ R2 ++R3 || {_, [{_, R1}, {_, R2}, {_, R3}]} <- RewardsList0])),
                    case lib_goods_do:can_give_goods(Rewards, [?GOODS_LOC_BAG]) of
                        true ->
                            case lib_dungeon_sweep:sweep_cost(Player, 0, DunType, Costs, dungeon_count_sweep_cost, Mark) of
                                {true, CostPlayer} ->
                                    % mod_daily:set_count(Player#player_status.id, DailyCountList),%% 批量扫荡目前只修改日常次数
                                    DunIds = [Id || {Id, _} <- RewardsList0],
                                    lib_dungeon:dungeon_count_plus(Player#player_status.id, DunIds, 1, 2),
                                    Code = ?SUCCESS,
                                    if
                                        IsOnLine == true ->
                                            F = fun({TempDunId, [{?REWARD_SOURCE_DUNGEON, FBaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, FMultipleReward}]}, {AccList, FunPs}) ->
                                                {_, _, NewFunPs, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(FunPs, #produce{reward = FBaseReward ++ FMultipleReward,
                                                    type = dungeon_count_sweep_rewards, subtype = DunType}),
                                                FunSeeRewardList     = lib_goods_api:make_see_reward_list(FBaseReward, UpGoodsList),
                                                NewUpGoodsList       = lib_dungeon:take_see_reward_list_from_up_goods_list(FunSeeRewardList, UpGoodsList),
                                                FunMultipleSeeReward = lib_goods_api:make_see_reward_list(FMultipleReward, NewUpGoodsList),
                                                case FunMultipleSeeReward of
                                                    [] ->
                                                        {[{TempDunId, FunSeeRewardList, []} | AccList], NewFunPs};
                                                    _ ->
                                                        {[{TempDunId, FunSeeRewardList, [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, FunMultipleSeeReward}]} | AccList], NewFunPs}
                                                end
                                            end,
                                            {RewardsList, TmpPlayer} = lists:foldl(F, {[], CostPlayer}, RewardsList0);
                                        true ->
                                            TmpPlayer   = lib_goods_api:send_reward(CostPlayer, Rewards, dungeon_count_sweep_rewards, DunType),
                                            F = fun({TempDunId, [{?REWARD_SOURCE_DUNGEON, FBaseReward}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, FMultipleReward}]}, AccList) ->
                                                FunSeeRewardList     = lib_goods_api:make_see_reward_list(FBaseReward, []),
                                                FunMultipleSeeReward = lib_goods_api:make_see_reward_list(FMultipleReward, []),
                                                case FunMultipleSeeReward of
                                                    [] ->
                                                        [{TempDunId, FunSeeRewardList, []} | AccList];
                                                    _ ->
                                                        [{TempDunId, FunSeeRewardList, [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, FunMultipleSeeReward}]} | AccList]
                                                end
                                                end,
                                            RewardsList = lists:foldl(F, [], RewardsList0)
                                    end,
%%                                    RewardsList = RewardsList0,
%%                                    TmpPlayer = lib_goods_api:send_reward(CostPlayer, Rewards, dungeon_count_sweep_rewards, DunType),
                                    NewPlayer = lib_dungeon_sweep:handle_finish_duns(TmpPlayer, DunType, DunIds),
                                    handle(61038, NewPlayer, [DunType]);
                                _ ->
                                    Code = ?ERRCODE(goods_not_enough),
                                    RewardsList = [],
                                    NewPlayer = Player
                            end;
                        {false, ErrorCode} ->
                            Code = ErrorCode,
                            RewardsList = [],
                            NewPlayer = Player
                    end
            end
    end,
    % ?MYLOG("cym", "RewardsList ~p~n", [RewardsList]),
    case Code =:= ?SUCCESS of
        true ->
            {ok, BinData} = pt_610:write(61028, [DunType, RewardsList]);
        _ ->
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_610:write(61000, [CodeInt, CodeArgs])
    end,
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% pt_61030_[]
%% 获取下一波怪物生成的时间
handle(61030, Player, []) ->
     case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, id = RoleId} = Player,
            mod_dungeon:get_next_wave_time(CopyId, RoleId);
        _ ->
            ok
    end;

%% 获取当前副本的所有杀怪数
handle(61031, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, id = RoleId} = Player,
            mod_dungeon:get_die_mon_count(CopyId, RoleId);
        _ ->
            ok
    end;

%% ########### 伤害排行榜 ##############
handle(61032, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, id = RoleId} = Player,
            mod_dungeon:get_hurt_rank(CopyId, RoleId);
        _ ->
            ok
    end;

%% ########### 伤害排行榜 ##############
handle(61034, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, id = RoleId} = Player,
            mod_dungeon:get_hp_list(CopyId, RoleId);
        _ ->
            ok
    end;

handle(61035, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, sid = Sid} = Player,
            mod_dungeon:handle_special(CopyId, Sid, 61035, []);
        _ ->
            ok
    end;

handle(61036, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, sid = Sid} = Player,
            mod_dungeon:handle_special(CopyId, Sid, 61036, []);
        _ ->
            ok
    end;

%% 副本摘要信息
handle(61037, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61037, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;
handle(61037, Player, []) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv, vip_type = VipType, vip = VipLv}, dungeon_record = Rec} = Player,
    lib_dungeon:get_summary_dungeon_info(RoleId, Lv, Rec, [{vip, VipLv}, {vip_type, VipType}]);

%% 副本摘要信息更新
handle(61038, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61038, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;
handle(61038, Player, [DunType]) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, vip_type = VipType, vip = VipLv}, dungeon_record = Rec} = Player,
    SlimList = [{DunType, [Info || Info <- lib_dungeon:create_dungeon_infos(Rec, DunType), lib_dungeon:get_need_lv(Info#dungeon_info.id) =< RoleLv]}],
    mod_daily:apply_cast(RoleId, lib_dungeon, get_daily_data, [RoleId, SlimList, {lib_dungeon, send_typical_summary_info, [{vip, VipLv}, {vip_type, VipType}]}]),
    {ok, Player};

handle(61039, Player, [DunId]) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            lib_dungeon_api:invoke(DunType, dunex_enter_next_dungeon, [Player, DunId], skip);
        _ ->
            skip
    end;

handle(61040, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, sid = Sid} = Player,
            mod_dungeon:get_skip_mon_num(CopyId, Sid);
        _ ->
            ok
    end;

handle(61041, Player, [_DunId]) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{
                copy_id = CopyId, id = RoleId, sid = Sid, figure = #figure{lv = NewLv}, exp = NewExp,
                dungeon = #status_dungeon{data_before_enter = #{lv_before := LvBefore, exp_before := ExpBefore}}
            } = Player,
            mod_dungeon:get_exp_got(CopyId, [RoleId, Sid, LvBefore, ExpBefore, NewLv, NewExp]);
        _ ->
            ok
    end;

%% 获得额外的奖励领取列表
%% 副本配置的额外奖励已经抽取出来，参考61113
handle(61042, Player, [DunType]) ->
    lib_dungeon:send_extra_reward_info(Player, DunType);

%% 领取额外的奖励
%% 抽取出来了副本通用奖励配置，参考61112
handle(61043, Player, [DunType, RewardType]) ->
    lib_dungeon:receive_extra_reward(Player, DunType, RewardType);

%% 发送面板信息
handle(61044, #player_status{copy_id = CopyId, id = RoleId} = Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_panel_info(CopyId, RoleId);
        false -> skip
    end;

%% 发送副本冷却时间
handle(61045, Player, [DunId]) ->
    lib_dungeon:send_cd_info(Player, DunId);

%% 邀请玩家进入副本
handle(61046, Player, [Type, DunId, OtherId]) ->
    lib_dungeon:invite_dun(Player, Type, DunId, OtherId);

%% 回应邀请玩家
handle(61047, Player, [DunId, InviterId, AnswerType]) ->
    case  data_dungeon:get(DunId) of
        #dungeon{}  ->
            lib_dungeon:answer_invite_dun(Player, DunId, InviterId, AnswerType);
        _ ->
            ok
    end;

%% 波数副本面板
handle(61059, Player, []) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true -> mod_dungeon:send_wave_panel_info(CopyId, RoleId);
        false -> skip
    end;

%% 开关设置
handle(61062, Player, [DunId]) ->
    lib_dungeon_setting:send_info(Player, DunId);

%% 开关设置
handle(61063, Player, [DunId, Type, SelectType, IsOpen, Count]) ->
    lib_dungeon_setting:setting(Player, DunId, Type, SelectType, IsOpen, Count);

%% 副本复位
handle(61064, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId} = Player,
            mod_dungeon:reset_xy(CopyId, RoleId);
        false ->
            skip
    end;

%% 各自副本的特殊信息
handle(61088, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId} = Player,
            mod_dungeon:send_dungeon_special_info(CopyId, RoleId);
        false ->
            skip
    end;

%% 提交答案
handle(61090, Player, [Answer]) ->
    lib_dungeon:answer_dun_question(Player, Answer);

%% 抢夺扣血
handle(61091, Player, []) ->
    lib_dungeon:rob_mon_bl(Player);

%% 异兽入侵领取累计奖励
handle(61092, Player, [DunType,DunId]) ->
    #player_status{id = RoleId, dungeon_record = Record, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    case maps:get(DunId, Record, []) of
        [_,_,_,{4, State},{5, OpenDay}] = List ->
            if
                State == 2 -> %%已领取
                    {ok, BinData} = pt_610:write(61092, [DunId,?ERRCODE(reward_is_got), State, []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                State == 1 -> %%完成未领取
                    case lib_dungeon_mon_invade:get_value_reward(OpenDay, RoleLv) of
                        Reward when Reward =/= [] -> skip;
                        _ -> Reward = data_mon_invade:get_value(stage_reward)
                    end,
                    % ?PRINT("Reward:~p~n",[Reward]),
                    TmpPlayer = lib_goods_api:send_reward(Player, Reward, mon_invade, DunType),
                    NewList = lists:keystore(4, 1, List, {4, 2}),
                    NewRecord = maps:put(DunId, NewList, Record),
                    lib_dungeon:save_dungeon_record(RoleId, DunId, NewList),
                    {ok, BinData} = pt_610:write(61092, [DunId, 1, 2, Reward]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                    NewPlayer = TmpPlayer#player_status{dungeon_record = NewRecord},
                    {ok, NewPlayer};
                true ->
                    {ok, BinData} = pt_610:write(61092, [DunId,?ERRCODE(err610_value_not_enougth), 0, []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
            end;
        _ ->
            {ok, BinData} = pt_610:write(61092, [DunId,?ERRCODE(err610_value_not_enougth), 0, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;
% 异兽入侵界面协议
handle(61093, Player, [DunType, DunId]) ->
    #player_status{id = RoleId, dungeon_record = Record} = Player,
    case maps:get(DunId, Record, []) of
        [{1, _},{2, Value},{3, NextBossBornTime},{4, State}, _] -> skip;
        _ ->
            Value = 0,NextBossBornTime = 0, State = 0
    end,
    EnterTimes = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunType),
    case data_dungeon:get(DunId) of
        #dungeon{open_begin = OpenBegin, open_end = OpenEnd} ->
            OpenDay = util:get_open_day(),
            if
                OpenDay >= OpenBegin andalso OpenDay =< OpenEnd ->
                    TodayZero = utime:unixdate(),
                    EndTime = (OpenEnd - OpenDay + 1) * 86400 + TodayZero;
                true ->
                    EndTime = 0
            end;
        _ ->
            EndTime = 0
    end,
    {ok, BinData} = pt_610:write(61093, [DunType,DunId,Value,NextBossBornTime,EnterTimes,EndTime,State]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

handle(61094, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, sid = Sid} = Player,
            mod_dungeon:handle_special(CopyId, Sid, 61094, []);
        _ ->
            ok
    end;

handle(61095, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, id = RoleId, dungeon = #status_dungeon{dun_id = DunId}} = Player,
            case data_dungeon_special:get(DunId, slow_down_cfg) of
                {Price, _, _} ->
                    Cost = ?WAKE_DUNGEON_SLOWDOWN_COST(Price),
                    case lib_goods_api:check_object_list(Player, Cost) of
                        true ->
                            mod_dungeon:apply(CopyId, lib_dungeon_wake, slow_mons_down, RoleId);
                        {false, Code} ->
                            {ok, BinData} = pt_610:write(61000, [Code, []]),
                            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_610:write(61000, [?FAIL, []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
            end;
        _ ->
            ok
    end;

handle(61096, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61096, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;

handle(61096, Player, []) ->
    #player_status{dungeon_record = Rec, sid = Sid, id = RoleId} = Player,
    case lib_dungeon_evil:get_daily_reward(Player, Rec) of
        {ok, State, Rewards} ->
            if
                State =:= 1 -> %% 可领取
                    case lib_goods_api:can_give_goods(Player, Rewards) of
                        true ->
                            NewPlayer = lib_goods_api:send_reward(Player, Rewards, dungeon_evil_daily_reward, 0),
                            NewRecord = lib_dungeon_evil:set_daily_reward_got(RoleId, Rec),
                            {ok, BinData} = pt_610:write(61096, [?SUCCESS]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            {ok, NewPlayer#player_status{dungeon_record = NewRecord}};
                        {false, ErrorCode} ->
                            {ok, BinData} = pt_610:write(61096, [ErrorCode]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                State =:= 2 -> %% 已领取
                    {ok, BinData} = pt_610:write(61096, [?ERRCODE(reward_is_got)]),
                    lib_server_send:send_to_sid(Sid, BinData);
                true ->
                    {ok, BinData} = pt_610:write(61096, [?FAIL]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        {false, Code} ->
            {ok, BinData} = pt_610:write(61096, [Code]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

handle(61097, #player_status{dungeon_record = undefined} = Player, Args) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    case handle(61097, NewPlayer, Args) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end;

handle(61097, Player, []) ->
    #player_status{dungeon_record = Rec, sid = Sid} = Player,
    case lib_dungeon_evil:get_daily_reward(Player, Rec) of
        {ok, State, Rewards} ->
            ok;
        _ ->
            State = 0, Rewards = []
    end,
    {ok, BinData} = pt_610:write(61097, [State, Rewards]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(61098, Player, []) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{copy_id = CopyId, sid = Sid} = Player,
            mod_dungeon:handle_special(CopyId, Sid, 61098, []);
        _ ->
            ok
    end;


%% 快速出怪
handle(61052, PS, []) ->
    #player_status{id = RoleId, server_id = ServerId, copy_id = CopyId} = PS,
    case lib_dungeon:is_on_dungeon(PS) of
        true -> mod_dungeon:quick_create_mon(CopyId, RoleId, ServerId);
        false -> skip
    end;

%% 快速出怪信息
handle(61053, PS, []) ->
    #player_status{id = RoleId, server_id = ServerId, copy_id = CopyId} = PS,
    case lib_dungeon:is_on_dungeon(PS) of
        true -> mod_dungeon:send_quick_create_mon_info(CopyId, RoleId, ServerId);
        false -> skip
    end;

%% 龙纹副本最佳记录
handle(61050, PS, [DunId, Wave]) ->
    Time = lib_dun_dragon:get_wave_pass_time(PS, DunId, Wave),
    mod_clusters_node:apply_cast(mod_dun_dragon_rank_cluster,
        send_record, [node(), PS#player_status.sid, DunId, Wave, Time]);

%%%% 龙纹副本成就奖励列表
%%handle(61051, PS, [DunId]) ->
%%    #player_status{id = RoleId, dungeon_record = Record} = PS,
%%    List = lib_dungeon:get_dragon_record_list(DunId, Record),
%%    {ok, Bin} = pt_610:write(61051, [DunId, List]),
%%    lib_server_send:send_to_uid(RoleId, Bin);

%%
%%%% 龙纹副本领取奖励
%%handle(61054, PS, [DunId, Wave]) ->
%%    #player_status{id = RoleId, dungeon_record = Record} = PS,
%%    DragonRecord = maps:get(DunId, Record, []),
%%    case lists:keyfind(Wave, 1, DragonRecord) of
%%        {Wave, Time, Status} ->
%%            if
%%                Status == 0 ->  %%不能领取
%%                    {ok, Bin} = pt_650:write(61054, [?FAIL, DunId, Wave]),
%%                    lib_server_send:send_to_uid(RoleId, Bin);
%%                Status == 2 ->  %%已经领取了
%%                    {ok, Bin} = pt_650:write(61054, [?ERRCODE(err610_had_receive_reward), DunId, Wave]),
%%                    lib_server_send:send_to_uid(RoleId, Bin);
%%                Status == 1 ->  %%可以领取
%%                    NewDragonRecord = lists:keystore(Wave, 1, DragonRecord, {Wave, Time, 2}),
%%                    lib_dungeon:save_dungeon_record(RoleId, DunId, NewDragonRecord),
%%                    NewRecord = maps:put(DunId, NewDragonRecord, Record),
%%                    {ok, Bin} = pt_650:write(61054, [?SUCCESS, DunId, Wave]),
%%                    lib_server_send:send_to_uid(RoleId, Bin),
%%                    {ok, PS#player_status{dungeon_record = NewRecord}}
%%            end;
%%        _ ->
%%            {ok, Bin} = pt_650:write(61054, [?FAIL, DunId, Wave]),
%%            lib_server_send:send_to_uid(RoleId, Bin)
%%    end;

%% 查看试炼副本技能数量
handle(61055, Role, _) ->
    #player_status{id = RoleId, copy_id = CopyId} = Role,
    case lib_dungeon:is_on_dungeon(Role) of
        true -> mod_dungeon:send_skill_info(CopyId, RoleId);
        false -> skip
    end;

%% 释放buff技能
handle(61056, Role, [SkillId]) ->
    #player_status{id = RoleId, copy_id = CopyId, battle_attr = BattleAttr} = Role,
    IsGhost = BattleAttr#battle_attr.ghost,
    case lib_dungeon:is_on_dungeon(Role) of
        true when IsGhost==0 -> mod_dungeon:casting_skill(CopyId, RoleId, SkillId);
        true ->
            {ok, BinData} = pt_610:write(61056, [?ERRCODE(err610_skill_error_in_ghost)]),
            lib_server_send:send_to_sid(Role#player_status.sid, BinData);
        false -> skip
    end;

%% 龙纹副本领取情况
handle(61051, Role, [DunId]) ->
    lib_dun_dragon:send_stage_reward_info(Role, DunId),
    {ok, Role};

%% 龙纹副本领取奖励
handle(61054, Role, [DunId, Wave]) ->
    {ok, NewRole} = lib_dun_dragon:gain_stage_reward(Role, DunId, Wave),
    {ok, NewRole};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.