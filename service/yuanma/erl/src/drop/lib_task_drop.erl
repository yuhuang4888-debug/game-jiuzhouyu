%% ---------------------------------------------------------------------------
%% @doc lib_task_drop.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-01-02
%% @deprecated 任务掉落
%% ---------------------------------------------------------------------------

-module(lib_task_drop).
-compile(export_all).

-include("server.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("team.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("awakening.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("dungeon.hrl").

%% 登录
login(#player_status{tid = TaskPid} = Player) ->
    % 任务id
    TaskIdL = data_task_drop:get_task_id_list(),
    FuncTaskIdL = data_task_drop:get_task_func_task_id_list(),
    SumTaskIdL = util:ulist(TaskIdL++FuncTaskIdL),
    DropTaskIdL = mod_task:get_trigger_task_id_list(TaskPid, SumTaskIdL),
    % 任务阶段
    TaskStageL = data_task_drop:get_task_func_task_stage_list(),
    DropTaskStageL = mod_task:get_trigger_task_stage_list(TaskPid, TaskStageL),
    % ?INFO("login DropTaskIdL:~p DropTaskStageL:~p ~n", [DropTaskIdL, DropTaskStageL]),
    Player#player_status{drop_task_id_list = DropTaskIdL, drop_task_stage_list = DropTaskStageL}.

%% 任务掉落
task_drop(Player, MonArgs, PList, FirstAttr, MainRoleId) ->
    #player_status{id = RoleId} = Player,
    #mon_args{mid = MonCfgId} = MonArgs,
    AllocList = data_task_drop:get_alloc_list(MonCfgId),
    case RoleId == MainRoleId of
        true -> [alloc_task_drop(Player, MonArgs, Alloc, PList, FirstAttr)||Alloc <- AllocList];
        false -> [alloc_task_drop(Player, MonArgs, Alloc, PList, FirstAttr)||Alloc <- AllocList, Alloc == ?ALLOC_HURT_EQUAL]
    end.

%% 任务掉落[分配]
alloc_task_drop(Player, MonArgs, Alloc, PList, FirstAttr) ->
    #player_status{id = RoleId, team = Team} = Player,
    #mon_args{mid = MonCfgId, scene = SceneId} = MonArgs,
    DropIdList = data_task_drop:get_drop_id_list(MonCfgId),
    if
        % 队伍不处理
        Team#status_team.team_id =/= 0 andalso Alloc == ?ALLOC_EQUAL ->
            skip;
        Alloc == ?ALLOC_HURT_EQUAL ->
            F = fun(DropId, Satisfying) ->
                case data_task_drop:get_drop(DropId) of
                    #base_task_drop{alloc = Alloc} -> [DropId|Satisfying];
                    _ -> Satisfying
                end
            end,
            Satisfying = lists:foldl(F, [], DropIdList),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_task_drop_list, [SceneId, Satisfying]);
        Alloc == ?ALLOC_SINGLE orelse Alloc == ?ALLOC_SINGLE_2 ->
            F = fun(DropId, KvList) ->
                case data_task_drop:get_drop(DropId) of
                    #base_task_drop{alloc = Alloc, bltype = BLType} ->
                        {DropRoleId, _MaxTeamDropR, _TeamHurts} = lib_goods_drop:calc_hurt_role_info(MonCfgId, SceneId, BLType, RoleId, Team, PList, FirstAttr),
                        case lists:keyfind(DropRoleId, 1, KvList) of
                            false -> [{DropRoleId, [DropId]}|KvList];
                            {DropRoleId, TmpDropIdList} -> lists:keystore(DropRoleId, 1, KvList, {DropRoleId, [DropId|TmpDropIdList]})
                        end;
                    _ ->
                        KvList
                end
            end,
            KvList = lists:foldl(F, [], DropIdList),
            % 获取所有满足条件的掉落
            [lib_player:apply_cast(DropRoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_task_drop_list, [SceneId, TmpDropIdList])
                ||{DropRoleId, TmpDropIdList}<-KvList];
        true ->
            skip
    end.

%% 根据怪物类型id,生成任务掉落
handle_task_drop_list(#player_status{scene = SceneId} = Player, MonCfgId) ->
    DropIdL = data_task_drop:get_drop_id_list(MonCfgId),
    handle_task_drop_list(Player, SceneId, DropIdL).

%% 根据怪物类型id和分配类型,生成任务掉落
handle_task_drop_list(Player, SceneId, MonCfgId, Alloc) ->
    DropIdL = data_task_drop:get_drop_id_list(MonCfgId),
    F = fun(DropId) ->
        case data_task_drop:get_drop(DropId) of
            #base_task_drop{alloc = Alloc} -> true;
            _ -> false
        end
    end,
    FilterDropIdL = lists:filter(F, DropIdL),
    handle_task_drop_list(Player, SceneId, FilterDropIdL).

%% 注意:这里就是处理掉落逻辑,之前的都是判断是否有掉落
%% 处理任务掉落
handle_task_drop_list(Player, SceneId, DropIdL) ->
    #player_status{drop_task_id_list = TaskIdL} = Player,
    F = fun(DropId, SumRewardL) ->
        #base_task_drop{task_id_list = TmpTaskIdL, reward_type = RewardType, reward_list = RewardList} = data_task_drop:get_drop(DropId),
        F2 = fun(TaskId) -> lists:member(TaskId, TaskIdL) end,
        case lists:any(F2, TmpTaskIdL) of
            true -> RewardListAfCalc = calc_reward_list(Player, RewardType, RewardList);
            false -> RewardListAfCalc = []
        end,
        RewardListAfCalc ++ SumRewardL
    end,
    RewardL = lists:foldl(F, [], DropIdL),
    Remark = util:term_to_string(DropIdL),
    Produce = #produce{type = task_drop, reward = RewardL, show_tips = ?SHOW_TIPS_3, remark = Remark},
    {ok, _, NewPlayer, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
    % ?INFO("SceneId:~p RewardL:~p DropIdL:~w~n", [SceneId, RewardL, DropIdL]),
    % 获得唯一键
    SeeRewardL = lib_goods_api:make_see_reward_list(RewardL, UpGoodsList),
    Callback = #callback_task_drop{reward = RewardL, see_reward_list = SeeRewardL, scene_id = SceneId},
    {ok, NewPlayer2} = lib_player_event:dispatch(NewPlayer, ?EVENT_TASK_DROP, Callback),
    {ok, NewPlayer2}.

%% 计算奖励
calc_reward_list(_Player, ?DROP_REWARD_TYPE_COMMON, RewardList) -> RewardList;
calc_reward_list(_Player, ?DROP_REWARD_TYPE_WEIGHT, WeightList) ->
    case urand:rand_with_weight(WeightList) of
        false -> [];
        RewardList -> RewardList
    end;
calc_reward_list(_Player, ?DROP_REWARD_TYPE_WEIGHT2, WeightList) ->
    case urand:rand_with_weight(WeightList) of
        false -> [];
        WeightList2 ->
            case urand:rand_with_weight(WeightList2) of
                false -> [];
                RewardList -> RewardList
            end
    end;
calc_reward_list(Player, ?DROP_REWARD_TYPE_AWAKENING, WeightList) ->
    #player_status{awakening = AwakeningStatus} = Player,
    #awakening{max_active_id = MaxActiveId} = AwakeningStatus,
    WeightList2 = calc_awakening_reward_list(WeightList, MaxActiveId),
    case urand:rand_with_weight(WeightList2) of
        false -> [];
        RewardList -> RewardList
    end;
calc_reward_list(_Player, _, _) -> [].

calc_awakening_reward_list([], _NowActiveId) -> [];
calc_awakening_reward_list([{{MinCell, MaxCell}, WeightList}|T], NowActiveId) ->
    case NowActiveId >= MinCell andalso NowActiveId =< MaxCell of
        true -> WeightList;
        false -> calc_awakening_reward_list(T, NowActiveId)
    end.

%% 测试掉落
% test_calc_reward_list(Max, Max, Count) -> Count;
% test_calc_reward_list(Min, Max, Count) ->
%     case urand:rand_with_weight([{200,[{0,38110015,1}]},{9800,[]}]) of
%         false -> NCount = Count;
%         [{0,38110015,1}] -> ?PRINT("test_calc_reward_list ~n", []), NCount = Count+1;
%         _ -> NCount = Count
%     end,
%     test_calc_reward_list(Min+1, Max, NCount).

%% -----------------------------------------------------------------
%% 功能的任务掉落
%% -----------------------------------------------------------------

get_task_func_reward(Player, Type) ->
    #player_status{drop_task_id_list = TaskIdL} = Player,
    FuncTaskIdL = data_task_drop:get_task_func_task_id_list(Type),
    F = fun(TaskId, SumRewardL) ->
        case lists:member(TaskId, TaskIdL) of
            true ->
                #base_task_func_drop{reward_type = RewardType, reward_list = RewardList} = data_task_drop:get_task_func_drop(Type, TaskId),
                RewardListAfCalc = calc_reward_list(Player, RewardType, RewardList);
            false ->
                RewardListAfCalc = []
        end,
        RewardListAfCalc ++ SumRewardL
    end,
    lists:foldl(F, [], FuncTaskIdL).

get_task_func_reward(Player, Type, MonLv) ->
    #player_status{drop_task_id_list = TaskIdL} = Player,
    FuncTaskIdL = data_task_drop:get_task_func_task_id_list(Type),
    F = fun(TaskId, SumRewardL) ->
        case lists:member(TaskId, TaskIdL) of
            true ->
                #base_task_func_drop{reward_type = RewardType, mon_lv = CfgMonLv, reward_list = RewardList} = data_task_drop:get_task_func_drop(Type, TaskId),
                RewardListAfCalc = ?IF(MonLv>=CfgMonLv, calc_reward_list(Player, RewardType, RewardList), []);
            false ->
                RewardListAfCalc = []
        end,
        RewardListAfCalc ++ SumRewardL
    end,
    lists:foldl(F, [], FuncTaskIdL).

%% 任务阶段
%% 注：已计算物品掉落限制
get_task_stage_func_reward(Player, Type, SceneType, MonLv) ->
    get_task_stage_func_reward_multi(Player, Type, SceneType, MonLv, 1).

get_task_stage_func_reward_multi(Player, Type, SceneType, MonLv, Multi) ->
    get_task_stage_func_reward_multi_help(Player, Type, SceneType, MonLv, Multi, {[], []}).

get_task_stage_func_reward_multi_help(Player, _Type, _SceneType, _MonLv, Multi, {RewardL, SendBagList}) when Multi =< 0 ->
    case {Player#player_status.online, SendBagList} of
        {_, []} -> % 直接发背包的奖励为空
            NewPlayer = Player,
            AfkRewardList = RewardL;
        {?ONLINE_ON, _} ->
            UniqueBagList = lib_goods_api:make_reward_unique(SendBagList),
            Produce = #produce{type = 'afk_off', reward = UniqueBagList},
            NewPlayer = lib_goods_api:send_reward(Player, Produce),
            AfkRewardList = RewardL;
        _ -> % 处于登出阶段，把发背包奖励也放到挂机奖励中（由于此时玩家进程会先退出，所以即使调用离线apply_cast也会找不到进程导致奖励发放失败）
            NewPlayer = Player,
            AfkRewardList = RewardL ++ SendBagList
    end,
    {NewPlayer, lib_goods_api:make_reward_unique(AfkRewardList)};
get_task_stage_func_reward_multi_help(Player, Type, SceneType, MonLv, Multi, {RewardL, SendBagList}) ->
    #player_status{drop_task_stage_list = TaskStageL} = Player,
    FuncTaskStageL = data_task_drop:get_task_func_task_stage_list(Type),
    F = fun({TaskId, Stage}, {SumRewardL, SendRewardL}) ->
        BaseFuncDrop = data_task_drop:get_task_stage_func_drop(Type, TaskId, Stage, SceneType),
        case lists:member({TaskId, Stage}, TaskStageL) andalso is_record(BaseFuncDrop, base_task_stage_func_drop) of
            true ->
                #base_task_stage_func_drop{
                    reward_type = RewardType, mon_lv = CfgMonLv, reward_list = RewardList, condition = Condition
                } = BaseFuncDrop,
                IsSatisfyCon = MonLv>=CfgMonLv andalso check_task_func_condition(Player, Condition),
                RewardListAfCalc0 = ?IF(IsSatisfyCon, calc_reward_list(Player, RewardType, RewardList), []),
                #produce{reward = RewardListAfCalc} = calc_filter_limit_produce(Player, #produce{reward = RewardListAfCalc0}); % 计算掉落限制
            false ->
                RewardListAfCalc = []
        end,
        {RewardListAfCalc1, DirectSendL} = handle_drop_way(Player, BaseFuncDrop, RewardListAfCalc), % 判断是否直接入背包
        {RewardListAfCalc1 ++ SumRewardL, SendRewardL ++ DirectSendL}
    end,
    {OneRewardL, SendRewards} = lists:foldl(F, {[], []}, FuncTaskStageL),
    get_task_stage_func_reward_multi_help(Player, Type, SceneType, MonLv, Multi-1, {OneRewardL++RewardL, SendBagList++SendRewards}).

%% 检查阶段任务掉落额外条件
check_task_func_condition(_Player, []) -> true;
check_task_func_condition(#player_status{scene = SceneId} = Player, [{scene_id, SceneIds}|T]) ->
    case lists:member(SceneId, SceneIds) of
        true -> check_task_func_condition(Player, T);
        _ -> false
    end;
check_task_func_condition(#player_status{dungeon = #status_dungeon{dun_id = DunId}} = Player, [{dun_id, DunIds}|T]) ->
    case lists:member(DunId, DunIds) of
        true -> check_task_func_condition(Player, T);
        _ -> false
    end;
check_task_func_condition(_Player, _Condition) -> false.

%% 掉落方式处理
%% 注：因不返回玩家，对玩家的操作要使用异步处理
handle_drop_way(_Player, _BaseFuncDrop, []) -> {[], []};

handle_drop_way(_Player, #base_task_stage_func_drop{drop_way = ?TASK_STAGE_DROP_WAY_BAG}, RewardList) ->
    {[], RewardList};

handle_drop_way(_Player, _BaseFuncDrop, RewardList) -> {RewardList, []}.


%% 野外挂机掉落
outside_mon_die_event(Player, SceneType, MonLv) ->
    {ok, PlayerAfTask} = handle_task_onhook_drop(Player, MonLv),
    {ok, PlayerAfTaskFunc} = handle_task_func_onhook_drop(PlayerAfTask, SceneType, MonLv),
    {ok, PlayerAfTaskFunc}.

handle_task_onhook_drop(Player, MonLv) ->
    % 任务id
    TaskFuncType = ?TASK_FUNC_TYPE_ONHOOK,
    RewardList = get_task_func_reward(Player, TaskFuncType, MonLv),
    Remark = lists:concat(["MonLv:", MonLv]),
    Produce = #produce{type = task_func_drop, reward = RewardList, show_tips = ?SHOW_TIPS_3, remark = Remark},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    {ok, NewPlayer}.

%% 任务阶段挂机类型掉落
handle_task_func_onhook_drop(Player, SceneType, MonLv) ->
    % 任务阶段
    TaskFuncType = ?TASK_FUNC_TYPE_ONHOOK,
    {PlayerTmp, RewardList} = get_task_stage_func_reward(Player, TaskFuncType, SceneType, MonLv),
    RewardList2 = ulists:object_list_plus_extra(RewardList),
    Remark = lists:concat(["MonLv:", MonLv]),
    Produce = #produce{type = task_stage_func_drop, reward = RewardList2, show_tips = ?SHOW_TIPS_3, remark = Remark},
    NewPlayer = ?IF(RewardList2 == [], PlayerTmp, lib_goods_api:send_reward(PlayerTmp, Produce)),
    {ok, NewPlayer}.

calc_filter_limit_produce(#player_status{id = RoleId}, #produce{reward = Goods} = Produce) ->
    %% 判断物品是否有上限
    F = fun({Type, GoodsId, Num}, {TDayList, TList}) ->
        case data_drop_limit:get_goods_limit(?TYPE_GOODS, GoodsId) of
            #base_drop_limit{}-> {[{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}|TDayList], TList};
            _ -> {TDayList, [{Type, GoodsId, Num}|TList]}
        end
    end,
    {DayLimitGoods, CanSendGoods} = lists:foldl(F, {[], []}, Goods),
    CanSendDayGoods = if
        DayLimitGoods =/= [] ->
            case catch mod_daily:get_count(RoleId, DayLimitGoods) of
                LimitCounts when is_list(LimitCounts)->
                    F1 = fun({{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}, Count}, {DList, NDList}) ->
                        #base_drop_limit{limit_num = LimitNum} = data_drop_limit:get_goods_limit(?TYPE_GOODS, GoodsId),
                        case LimitNum > Count of
                            false -> {DList, NDList};
                            true ->
                                {Type, GoodsId, Num} = lists:keyfind(GoodsId, 2, Goods),
                                NewNum = min(Num, LimitNum - Count),
                                % ?PRINT("calc_filter_limit_produce ~p~n", [{DayLimitGoods, LimitNum, Count, Num, NewNum}]),
                                {[{Type, GoodsId, NewNum}|DList], [{{?MOD_GOODS, ?MOD_GOODS_DROP, GoodsId}, Count+NewNum}|NDList]}
                        end
                    end,
                    {SendDGoods, AddCounts} = lists:foldl(F1, {[], []}, LimitCounts),
                    mod_daily:set_count(RoleId, AddCounts),
                    SendDGoods;
                _ ->
                    []
            end;
        true ->
            []
    end,
    SendGoods = lists:append(CanSendDayGoods, CanSendGoods),
    Produce#produce{reward = SendGoods}.

%% -----------------------------------------------------------------
%% 接口
%% -----------------------------------------------------------------

%% 怪物死亡
mon_die(Minfo, Klist, BLWhos) ->
    #scene_object{scene = SceneId, figure = Figure} = Minfo,
    % 挂机
    SceneTypeList = data_task_drop:get_task_func_scene_type_list(?TASK_FUNC_TYPE_ONHOOK),
    case data_scene:get(SceneId) of
        #ets_scene{type=SceneType} -> ok;
        _ -> SceneType = 0
    end,
    IsMember = lists:member(SceneType, SceneTypeList),
    IsClustersScene = lib_scene:is_clusters_scene(SceneId),
    if
        IsMember == false -> skip;
        SceneType == 0 -> skip;
        IsClustersScene ->
            % 只有归属才有掉落
            [lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_task_drop, handle_task_func_onhook_drop, [SceneType, Figure#figure.lv])
                ||#mon_atter{id = RoleId, node = Node} <- BLWhos];
        true ->
            case SceneType of
                ?SCENE_TYPE_OUTSIDE ->
                    % 任意伤害都有掉落
                    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_task_drop, outside_mon_die_event, [SceneType, Figure#figure.lv])
                        ||#mon_atter{id = RoleId} <- Klist];
                _ ->
                    % 只有归属才有掉落
                    DropperList = ?IF(BLWhos == [], Klist, BLWhos),
                    %?PRINT("Klist ~p ~n BLWhos ~p ~n", [Klist, BLWhos]),
                    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_task_drop, handle_task_func_onhook_drop, [SceneType, Figure#figure.lv])
                        ||#mon_atter{id = RoleId} <- DropperList]
            end
    end.
