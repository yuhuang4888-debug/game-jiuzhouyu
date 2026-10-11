%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 25 Nov 2017 by root <root@localhost.localdomain>

-module(lib_eudemons_land).
-compile(export_all).

-include("server.hrl").
-include("eudemons_land.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("boss.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("drop.hrl").
-include("def_fun.hrl").
-include("gift.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("guild.hrl").
-include("task.hrl").

%% 登录初始化
eudemons_boss_login(PS)->
    case db:get_row(io_lib:format("select eudemons_lv, eudemons_exp from eudemons_boss_lv where role_id=~p", [PS#player_status.id])) of
        [Lv, Exp] -> ok;
        _ -> Lv = 1, Exp = 0
    end,
    ?PRINT("eudemons_boss_login ~p~n", [{Lv, Exp}]),
    PS#player_status{eudemons_boss = #eudemons_boss{lv = Lv, exp = Exp}}.


re_login(PS, _LoginType) ->
    #player_status{scene = Scene, x = X, y = Y, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = PS,
    case is_in_eudemons_boss(Scene) of
        true ->
            case Hp == 0 of
                true ->
                    #ets_scene{x = TX, y = TY} = data_scene:get(Scene),
                    NewPS = lib_scene:change_relogin_scene(PS#player_status{x = TX, y = TY}, [{ghost, 0}, {change_scene_hp_lim, 0}]),
                    {ok, NewPS};
                _ ->
                    EudemonsBoss = make_record(eudemons_boss, PS),
                    %?PRINT("re_login Hp ~p~n", [Hp]),
                    mod_clusters_node:apply_cast(mod_eudemons_land, re_login, [EudemonsBoss, Scene, X, Y, Hp, HpLim]),
                    % KvList = [{ghost, 0}],
                    % NewKvList = ?IF(Hp < round(HpLim * 0.03), [{change_scene_hp, round(HpLim * 0.03)}|KvList], KvList),
                    NewPS = lib_scene:change_relogin_scene(PS, []),
                    {ok, NewPS}
            end;
        _ ->
            {next, PS}
    end.

exit_eudemons_land(PS) ->
    #player_status{id = RoleId, scene = Scene, server_id = ServerId} = PS,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_eudemons_land, exit_eudemons_land, [Node, RoleId, Scene, ServerId]),
    ok.

handle_event(Player, #event_callback{type_id = ?EVENT_GOODS_DROP, data = Data}) when is_record(Player, player_status) ->
    #callback_goods_drop{mon_args = MonArgs, alloc = Alloc, goods_list = GoodsList, up_goods_list = UpGoodsL} = Data,
    #mon_args{scene = ObjectScene} = MonArgs,
    case is_in_eudemons_boss(ObjectScene) of
        true ->
            if
                Alloc == ?ALLOC_SINGLE -> RewardType = 1;
                Alloc == ?ALLOC_SINGLE_2 -> RewardType = 2;
                true -> RewardType = 0
            end,
            SeeRewardL = lib_goods_api:make_see_reward_list(GoodsList, UpGoodsL),
            % RecordList = format_drop_record(Player, MonArgs, UpGoodsL),
            % case length(RecordList) > 0 of
            %     true ->
            %         mod_clusters_node:apply_cast(mod_eudemons_land, boss_add_drop_log, [Player#player_status.server_id, RecordList]);
            %     _ ->
            %         skip
            % end,
            {ok, BinData} = pt_470:write(47015, [RewardType, SeeRewardL]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false ->
            skip
    end,
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_DROP_CHOOSE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, scene = SceneId, figure = #figure{name = _RoleName}} = Player,
    case is_in_eudemons_boss(SceneId) of
        true ->
            #{goods := DropReward, mon_id := BossId} = Data,
            Notice = maps:get(notice, Data, []),
            case DropReward of
                [{_, GoodsTypeId, _}|_] when Notice =/= [] ->
                    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
                        #eudemons_boss_cfg{layers = Layer} ->
                            NeedRecordGoodsIds = ?EUDEMONS_RECORD_GOODS_LIST,
                            NowTime = utime:unixtime(),
                            case lists:member(GoodsTypeId, NeedRecordGoodsIds) of
                                true ->
                                    ExtraAttr = maps:get(extra_attr, Data, []),
                                    Rating = maps:get(rating, Data, 0),
                                    RoleName = lib_player:get_wrap_role_name(Player),
                                    RecordList = [{RoleId, ServerId, ServerNum, RoleName, BossId, Layer, GoodsTypeId, Rating, ExtraAttr, NowTime}],
                                    %?PRINT("RecordList:~p~n", [RecordList]),
                                    mod_clusters_node:apply_cast(mod_eudemons_land, boss_add_drop_log, [ServerId, RecordList]);
                                _ ->
                                    skip
                            end;
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_BOSS_KILL, data = #callback_boss_kill{boss_type = ?BOSS_TYPE_PHANTOM_PER, boss_id = BossId}}) ->
    NewPlayer = mod_server_cast:set_data_sub([{eudemons_boss_lv, BossId}], Player),
    {ok, NewPlayer};
handle_event(Player, _EventCallback) ->
    {ok, Player}.

update_max_tired(PS) ->
    #eudemons_boss_type{tired = OldTired} = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
    ExtraTired = lib_eudemons_land:get_extra_times(PS),
    lib_guild_assist:update_bl_state(PS),
    lib_server_send:send_to_sid(PS#player_status.sid, pt_470, 47023, [OldTired + ExtraTired]).

fin_task(PS, TaskId) ->
    #task{type = TaskType, award_list = RewardList} = data_task:get(TaskId),
    case TaskType == ?TASK_TYPE_DAILY_EUDEMONS orelse (TaskId == ?EUDEMONS_CLT_TASK_ID andalso TaskType == ?TASK_TYPE_DAY) of
        true ->
            #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName}} = PS,
            case TaskType == ?TASK_TYPE_DAILY_EUDEMONS of
                true ->
                    ScoreAdd = 20;
                _ ->
                    ScoreList = [Num ||{Type, Id, Num} <- RewardList, Type == ?TYPE_CURRENCY, Id == ?GOODS_ID_EUDEMONS_SCORE],
                    ScoreAdd = lists:sum([0|ScoreList])
            end,
            ?PRINT("fin_task ## ScoreAdd ~p~n", [ScoreAdd]),
            case ScoreAdd > 0 of
                true ->
                    Args = [RoleId, RoleName, ServerId, ServerNum, ScoreAdd],
                    mod_clusters_node:apply_cast(mod_eudemons_land, fin_task_daily, [Args]);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

get_eudemons_clt_task() ->
    ?EUDEMONS_CLT_TASK_ID.

%% 是不是在boss场景:排除给人boss
is_in_eudemons_boss(Scene)->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} -> true;
        _ -> false
    end.

send_eudemons_level(PS) ->
    #player_status{sid = Sid, eudemons_boss = #eudemons_boss{lv = Lv, exp = Exp}} = PS,
    lib_server_send:send_to_sid(Sid, pt_470, 47019, [Lv, Exp, 0]).

send_eudemons_level(PS, ExpAdd) ->
    #player_status{sid = Sid, eudemons_boss = #eudemons_boss{lv = Lv, exp = Exp}} = PS,
    lib_server_send:send_to_sid(Sid, pt_470, 47019, [Lv, Exp, ExpAdd]).

send_rank_info(PS) ->
    #player_status{id = RoleId, sid = Sid, server_id = ServerId} = PS,
    mod_eudemons_land_local:send_rank_info(ServerId, RoleId, Sid).


update_boss_collect_times(BossType, BossId, AttrId, FirstAttr, MonArgs) ->
    #eudemons_boss_cfg{is_rare = IsRare} = data_eudemons_land:get_eudemons_boss_cfg(BossId),
    {CollMod, CollSubMod, CollCounterId} = data_eudemons_boss_m:get_counter_module(BossType, {collect, IsRare}),
    if
        IsRare == ?MON_CL_RARE ->
            mod_daily:increment_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            CollectTimes = mod_daily:get_count_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            UpdateInfoList = [{2, CollectTimes}];
        IsRare == ?MON_CL_NORMAL ->
            mod_daily:increment_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            CollectTimes = mod_daily:get_count_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            UpdateInfoList = [{1, CollectTimes}];
        IsRare == ?MON_CL_CRYSTAL ->
            mod_daily:increment_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            CollectTimes = mod_daily:get_count_offline(AttrId, CollMod, CollSubMod, CollCounterId),
            Mid = ?EUDEMONS_CLT_TASK_MON_ID,
            lib_task_api:collect_mon(AttrId, Mid),
            UpdateInfoList = [{3, CollectTimes}];
        IsRare == ?MON_CL_TASK ->
            lib_task_api:collect_mon(AttrId, BossId),
            UpdateInfoList = [];
        true ->
            UpdateInfoList = []
    end,
    send_role_info(AttrId, UpdateInfoList),
    #eudemons_boss_cfg{goods = Goods} = EudemonsBossCfg = data_eudemons_land:get_eudemons_boss_cfg(BossId),
    case lib_player:get_alive_pid(AttrId) of
        false ->
            update_eudemons_exp(AttrId, BossId),
            Produce = #produce{type = eudemons_boss, reward = Goods, remark = lists:concat([BossType, BossId])},
            lib_goods_api:send_reward_with_mail(AttrId, Produce);
        Pid ->
            lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, handle_collect_boss_online, [BossType, EudemonsBossCfg, FirstAttr, MonArgs])
    end,
    ok.

handle_collect_boss_online(PS, BossType, #eudemons_boss_cfg{is_rare = IsRare}=EudemonsBossCfg, _FirstAttr, _MonArgs) when IsRare =/= ?MON_CL_TASK ->
    #player_status{sid = Sid} = PS,
    RoleName = lib_player:get_wrap_role_name(PS),
    #eudemons_boss_cfg{boss_id = BossId, goods = Reward, layers = Layers, condition = Condition} = EudemonsBossCfg,
    F = fun(Value, {L, L1}) ->
        case Value of
            {?TYPE_GOODS, GoodsId, Num} ->
                case data_goods_type:get(GoodsId) of
                    #ets_goods_type{type = ?GOODS_TYPE_GIFT} ->
                        case lib_gift_new:get_gift_goods(PS, GoodsId, Num) of
                            {true, GiftList, GiftReward} ->
                                #ets_gift_reward{tv_goods_id = TvGoodIds} = GiftReward,
                                TvNeedList = [GoodsTypeId ||{?TYPE_GOODS, GoodsTypeId, _Num} <- GiftList, lists:member(GoodsTypeId, TvGoodIds)],
                                {GiftList ++ L, [{GoodsId, TvNeedList}|L1]};
                            _ -> {[Value|L], L1}
                        end;
                    _ -> {[Value|L], L1}
                end;
            _ -> {[Value|L], L1}
        end
    end,
    {RewardList, TvList} = lists:foldl(F, {[], []}, Reward),
    ?PRINT("RewardList ~p~n", [RewardList]),
    Produce = #produce{type = eudemons_boss, reward = RewardList, remark = lists:concat([BossType, BossId])},
    {_, _, NewPS, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(PS, Produce),
    %% 传闻
    case TvList of
        [] -> ok;
        _ ->
            {_, EnterLv} = ulists:keyfind(lv, 1, Condition, {lv, 380}),
            F1 = fun({GiftId, TvGoods}) ->
                [
                    lib_chat:send_TV({all_lv, EnterLv, 9999}, ?MOD_EUDEMONS_BOSS, 8, [RoleName, Layers, GiftId, TvGoodsId])
                    || TvGoodsId <- TvGoods
                ]
            end,
            lists:foreach(F1, TvList)
    end,
    SeeRewardL = lib_goods_api:make_see_reward_list(RewardList, UpGoodsList),
    %?PRINT("SeeRewardL ~p~n", [SeeRewardL]),
    {ok, BinData} = pt_470:write(47015, [3, SeeRewardL]),
    lib_server_send:send_to_sid(Sid, BinData),
    LastPS = update_eudemons_exp_ps(NewPS, BossId),
    {ok, LastPS};
handle_collect_boss_online(PS, _BossType, _EudemonsBossCfg, _FirstAttr, _MonArgs) ->
    %% 任务掉落
    % case IsRare == ?MON_CL_TASK andalso is_record(MonArgs, mon_args) of
    %     true ->
    %         lib_task_drop:task_drop(LastPS, MonArgs, [], FirstAttr);
    %     _ ->
    %         ok
    % end,
    {ok, PS}.


handle_boss_be_kill(RoleId, BossType, BossId, BossLv, KillAutoId) when is_integer(RoleId) ->
    case BossType of
        ?BOSS_TYPE_EUDEMONS ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_boss_be_kill, [BossType, BossId, BossLv, KillAutoId]);
        _ ->
            Args = [0, RoleId, KillAutoId, config:get_server_id(), 0, "", 0, 0, 0],
            mod_clusters_node:apply_cast(mod_eudemons_land, handle_boss_be_kill_succ, [Args]),
            ?ERR("handle_boss_be_kill BOSS TYPE ERR :~p~n", [BossType]),
            skip
    end;
handle_boss_be_kill(PS, BossType, BossId, BossLv, KillAutoId) ->
    #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, scene = RoleScene, figure = #figure{name = RoleName}} = PS,
    #eudemons_boss_type{tired = OldTired} = data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS),
    NewMaxTired = OldTired + lib_eudemons_land:get_extra_times(PS),
    {TiredMod, TiredSubMod, TiredCounterId} = data_eudemons_boss_m:get_counter_module(BossType, tired),
    TiredUse = mod_daily:get_count(RoleId, TiredMod, TiredSubMod, TiredCounterId),
    BossCfg = data_eudemons_land:get_eudemons_boss_cfg(BossId),
    ?PRINT("handle_boss_be_kill ######## start ~n", []),
    if
        TiredUse >= NewMaxTired ->
            Args = [0, RoleId, KillAutoId, ServerId, 0, "", 0, 0, 0],
            mod_clusters_node:apply_cast(mod_eudemons_land, handle_boss_be_kill_succ, [Args]),
            ?INFO("handle_boss_be_kill tire max:~p~n", [{TiredUse, NewMaxTired}]),
            {ok, PS};
        BossCfg#eudemons_boss_cfg.scene =/= RoleScene ->
            Args = [0, RoleId, KillAutoId, ServerId, 0, "", 0, 0, 0],
            mod_clusters_node:apply_cast(mod_eudemons_land, handle_boss_be_kill_succ, [Args]),
            ?INFO("handle_boss_be_kill not in scene :~p~n", [{BossCfg#eudemons_boss_cfg.scene, RoleScene}]),
            {ok, PS};
        true ->
            handle_boss_be_kill_event(PS, BossType, BossCfg, BossLv),
            %% 掉落
            %lib_goods_drop:mon_drop(node(), RoleId, Minfo, KList, FirstAttr),
            %% 增加次数
            mod_daily:increment(RoleId, TiredMod, TiredSubMod, TiredCounterId),
            %% 增加圣兽领积分等信息
            ScoreType = ?IF(BossCfg#eudemons_boss_cfg.is_rare >= ?MON_CL_NORMAL, ?SCORE_TYPE_3, ?SCORE_TYPE_2),
            AddScore = lib_eudemons_land:get_kill_mon_score(BossId),
            Args = [1, RoleId, KillAutoId, ServerId, ServerNum, RoleName, ServerId, ScoreType, AddScore],
            mod_clusters_node:apply_cast(mod_eudemons_land, handle_boss_be_kill_succ, [Args]),
            %% 额外掉落
            MonArgs = #mon_args{scene = RoleScene, mid = BossId, lv = BossLv},
            case data_drop_other:get_alloc_type(BossId) of
                AllocList when AllocList =/= [] ->
                    [lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_goods_drop, handle_other_drop_list, [MonArgs, Alloc, 0, []]) || Alloc <- AllocList];
                _ ->
                    skip
            end,
            %% 更新一下玩家的boss状态
            {ok, PS1} = lib_guild_assist:update_bl_state(PS),
            PsAfSet = mod_server_cast:set_data_sub([{eudemons_boss_tired, 1}, {eudemons_boss_lv, BossId}], PS1),
            {ok, PsAfSet}
    end.

handle_boss_be_kill_event(PS, BossType, BossCfg, BossLv) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    #eudemons_boss_cfg{boss_id = BossId, is_rare = IsRare} = BossCfg,
    %% boss击杀任务
    lib_task_api:kill_boss(RoleId, ?BOSS_TYPE_PHANTOM, BossLv),
    %% 事件触发
    CallBackData = #callback_boss_kill{boss_type = ?BOSS_TYPE_PHANTOM, boss_id = BossId},
    lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData),
    %% 嗨点
    lib_hi_point_api:hi_point_task_kill_kf_boss(RoleId, RoleLv, BossType),
    %% 成就
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_achievement_api, boss_achv_finish, [?BOSS_TYPE_PHANTOM, BossId]),
    %% 争夺值
    lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_EUDEMONS_BOSS, BossType, 1),
    %% 日常
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_EUDEMONS_BOSS, BossType),
    %% 使魔任务
    lib_demons_api:boss_be_kill(RoleId, ?BOSS_TYPE_PHANTOM, BossId),
    %% 通知游戏服完成boss击杀（契约挑战任务）
    ?IF(IsRare == 0, lib_contract_challenge_api:kill_eudemons_boss(RoleId), skip),
    ok.

update_boss_tired(RoleId, BossType, BossId) ->
    case BossType of
        ?BOSS_TYPE_EUDEMONS ->
            {TiredMod, TiredSubMod, TiredCounterId} = data_eudemons_boss_m:get_counter_module(BossType, tired),
            ?PRINT("update_boss_tired ~p~n",[{TiredMod, TiredSubMod, TiredCounterId}]),
            mod_daily:increment(RoleId, TiredMod, TiredSubMod, TiredCounterId),
            %% 更新一下玩家的boss状态
            lib_guild_assist:update_bl_state(RoleId),
            lib_player:update_player_info(RoleId, [{eudemons_boss_tired, 1}, {eudemons_boss_lv, BossId}]);
        _ -> ok
    end.

get_boss_tired(RoleId) ->
    {TiredMod, TiredSubMod, TiredCounterId} = data_eudemons_boss_m:get_counter_module(?BOSS_TYPE_EUDEMONS, tired),
    Tired = mod_daily:get_count(RoleId, TiredMod, TiredSubMod, TiredCounterId),
    Tired.

small_mon_be_kill(RoleId, MonId) ->
    DropList = ?EUDEMONS_SAMLL_MON_DROP,
    %?PRINT("small_mon_be_kill ##################### ~n",[]),
    case lists:keyfind(MonId, 1, DropList) of
        {MonId, DropGoodsId, Weight} ->
            case urand:rand(1, 10000) =< Weight of
                true ->
                    lib_task_api:collect_goods(RoleId, [{DropGoodsId, 1}]);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

update_eudemons_exp(RoleId, BossId) when is_integer(RoleId) ->
    case db:get_row(io_lib:format("select eudemons_lv, eudemons_exp from eudemons_boss_lv where role_id=~p", [RoleId])) of
        [Lv, Exp] -> ok;
        _ -> Lv = 0, Exp = 0
    end,
    ExpAdd = get_boss_exp_add(BossId),
    {NewLv, NewExp} = add_eudemons_exp(Lv, Exp, ExpAdd),
    SqlRe = io_lib:format("replace into eudemons_boss_lv set role_id=~p, eudemons_lv=~p, eudemons_exp=~p", [RoleId, NewLv, NewExp]),
    db:execute(SqlRe),
    {NewLv, NewExp}.
update_eudemons_exp_ps(PS, BossId) ->
    #player_status{id = RoleId, eudemons_boss = EudemonsBossStatus, scene = Scene} = PS,
    #eudemons_boss{lv = Lv, exp = Exp} = EudemonsBossStatus,
    ExpAdd = get_boss_exp_add(BossId),
    {NewLv, NewExp} = add_eudemons_exp(Lv, Exp, ExpAdd),
    lib_log_api:log_eudemons_land_level(RoleId, Lv, Exp, NewLv, NewExp, ExpAdd),
    SqlRe = io_lib:format("replace into eudemons_boss_lv set role_id=~p, eudemons_lv=~p, eudemons_exp=~p", [RoleId, NewLv, NewExp]),
    db:execute(SqlRe),
    is_in_eudemons_boss(Scene) andalso NewLv =/= Lv andalso mod_scene_agent:update(PS, [{mod_level, NewLv}]),
    NewPS = PS#player_status{eudemons_boss = EudemonsBossStatus#eudemons_boss{lv = NewLv, exp = NewExp}},
    send_eudemons_level(NewPS, ExpAdd),
    if
        NewLv =/= lv ->
            LastPS = lib_push_gift_api:eudemons_level_up(NewPS, NewLv);
        true ->
            LastPS = NewPS
    end,
    ?PRINT("update_eudemons_exp_ps ## :~p~n", [{NewLv, NewExp}]),
    LastPS.

gm_add_eudemons_exp(PS, ExpAdd) ->
    #player_status{id = RoleId, eudemons_boss = EudemonsBossStatus, scene = Scene} = PS,
    #eudemons_boss{lv = Lv, exp = Exp} = EudemonsBossStatus,
    {NewLv, NewExp} = add_eudemons_exp(Lv, Exp, ExpAdd),
    lib_log_api:log_eudemons_land_level(RoleId, Lv, Exp, NewLv, NewExp, ExpAdd),
    SqlRe = io_lib:format("replace into eudemons_boss_lv set role_id=~p, eudemons_lv=~p, eudemons_exp=~p", [RoleId, NewLv, NewExp]),
    db:execute(SqlRe),
    is_in_eudemons_boss(Scene) andalso NewLv =/= Lv andalso mod_scene_agent:update(PS, [{mod_level, NewLv}]),
    NewPS = PS#player_status{eudemons_boss = EudemonsBossStatus#eudemons_boss{lv = NewLv, exp = NewExp}},
    send_eudemons_level(NewPS, ExpAdd),
    send_eudemons_level(NewPS, ExpAdd),
    if
        NewLv =/= lv ->
            LastPS = lib_push_gift_api:eudemons_level_up(NewPS, NewLv);
        true ->
            LastPS = NewPS
    end,
    LastPS.

add_eudemons_exp(Lv, Exp, ExpAdd) ->
    case Lv >= data_eudemons_exp:get_eudemons_max_lv() of
        true -> {Lv, Exp};
        _ ->
            ExpNeed = data_eudemons_exp:get_eudemons_exp(Lv+1),
            case Exp + ExpAdd >= ExpNeed of
                true ->
                    add_eudemons_exp(Lv+1, 0, Exp + ExpAdd - ExpNeed);
                _ -> {Lv, Exp + ExpAdd}
            end
    end.

add_score_info_to_server(PlayerScore, ScoreType, AddScore) ->
    %% 更新榜单数据
    mod_eudemons_land_local:sync_score_info_to_server(PlayerScore),
    #player_score{role_id = RoleId} = PlayerScore,
    SerId = config:get_server_id(),
    case mod_player_create:get_real_serid_by_id(RoleId) of
        SerId -> %% 本服玩家加积分
            lib_server_send:send_to_uid(RoleId, pt_470, 47022, [ScoreType, AddScore]),
            case ScoreType == ?SCORE_TYPE_4 of
                true -> %% 任务得到的积分已经发过奖励，不用再发
                    skip;
                _ ->
                    Reward = ?IF(AddScore > 0, [{?TYPE_CURRENCY, ?GOODS_ID_EUDEMONS_SCORE, AddScore}], []),
                    Produce = #produce{type = eudemons_boss_score, reward = Reward, remark = lists:concat([ScoreType]), show_tips = ?SHOW_TIPS_3},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce)
            end;
        _ -> %%
            skip
    end.

get_boss_exp_add(BossId) ->
    ExpAdd = data_eudemons_exp:get_boss_kill_exp(BossId),
    ExpAdd.

get_eudemons_land_level(PS) ->
    case PS#player_status.eudemons_boss of
        #eudemons_boss{lv = Lv} -> Lv;
        _ -> 0
    end.

%% 击杀玩家获得的积分
get_kill_player_score(_AttLv, _DeadLv) ->
    0.
%% 击杀boss获得的积分
get_kill_mon_score(BossId) ->
    KillScore = data_eudemons_exp:get_boss_kill_score(BossId),
    KillScore.

check_collect_times(_MonId, MonCfgId, [RoleId, BossType, _BossId]) ->
    case data_eudemons_land:get_eudemons_boss_cfg(MonCfgId) of
        #eudemons_boss_cfg{type = _BossType, is_rare = IsRare} when BossType == _BossType ->
            case IsRare == ?MON_CL_TASK of
                true -> %% 任务采集怪，不限制
                    true;
                _ ->
                    {CollMod, CollSubMod, CollCounterId} = data_eudemons_boss_m:get_counter_module(BossType, {collect, IsRare}),
                    {NormalCount, RareCount, CrystalCount} = data_eudemons_boss_m:get_boss_collect_max(BossType),
                    CollectTimes = mod_daily:get_count(RoleId, CollMod, CollSubMod, CollCounterId),
                    case IsRare of
                        ?MON_CL_NORMAL -> CollectTimesMax = NormalCount;
                        ?MON_CL_RARE -> CollectTimesMax = RareCount;
                        ?MON_CL_CRYSTAL -> CollectTimesMax = CrystalCount;
                        _ -> CollectTimesMax = 0
                    end,
                    ?PRINT("check_collect_times ~p~n", [{CollectTimes, CollectTimesMax}]),
                    case CollectTimes >= CollectTimesMax of
                        false -> true;
                        _ -> {false, 7}
                    end
            end;
        _ ->
            true
    end.

send_rank_reward(PlayerScoreList) ->
    NowTime = utime:unixtime(),
    spawn(fun() -> send_rank_reward_do(lists:reverse(PlayerScoreList), NowTime, 1) end),
    ok.

send_rank_reward_do([], _NowTime, _Acc) -> ok;
send_rank_reward_do([{RoleId, RankType, Value, RoleRank}|PlayerScoreList], NowTime, Acc) ->
    Acc rem 20 == 0 andalso timer:sleep(200),
    RewardList = data_eudemons_exp:get_rank_reward(RankType, RoleRank),
    {NewRewardList, DsgtId} = split_designation(RewardList),
    %% 日志记录
    lib_log_api:log_eudemons_land_rank_local(RoleId, RankType, RoleRank, Value, RewardList, NowTime),
    %% 称号
    DsgtId > 0 andalso lib_designation_api:active_dsgt_common(RoleId, DsgtId),
    %% 邮件发奖励
    if
        RankType == ?RANK_TYPE_1 ->
            Title = utext:get(4700001),
            Content = utext:get(4700002, [RoleRank]);
        RankType == ?RANK_TYPE_2 ->
            Title = utext:get(4700003),
            Content = utext:get(4700004, [RoleRank]);
        true ->
            Title = utext:get(4700005),
            Content = utext:get(4700006, [RoleRank])
    end,
    lib_mail_api:send_sys_mail([RoleId], Title, Content, NewRewardList),
    ?PRINT("send_rank_reward_do RewardList: ~p~n", [RewardList]),
    send_rank_reward_do(PlayerScoreList, NowTime, Acc+1).

split_designation(RewardList) ->
    F = fun({Type, GoodsTypeId, Num}, {List, DsgtId}) ->
        case Type == ?TYPE_GOODS orelse Type == ?TYPE_BIND_GOODS of
            true ->
                case data_goods_type:get(GoodsTypeId) of
                    #ets_goods_type{type = ?GOODS_TYPE_PROPS, subtype = ?GOODS_PROPS_STYPE_DESG} ->
                        case data_designation:get_designation_id([{?TYPE_GOODS, GoodsTypeId, 1}]) of
                            [DesignationId] ->
                                {List, DesignationId};
                            _ ->
                              {[{Type, GoodsTypeId, Num}|List], DsgtId}
                        end;
                    _ ->
                        {[{Type, GoodsTypeId, Num}|List], DsgtId}
                end;
            _ ->
                {[{Type, GoodsTypeId, Num}|List], DsgtId}
        end
    end,
    {NewRewardList, DsgtId} = lists:foldl(F, {[], 0}, RewardList),
    {NewRewardList, DsgtId}.

send_role_info(AttrId, List) ->
    lib_server_send:send_to_uid(AttrId, pt_470, 47016, [List]).

eudemons_boss_open() ->
    case util:get_open_day() >= ?EUDEMONS_BOSS_OPEN_DAY of
        true -> true;
        _ -> false
    end.

player_die(Atter,Status) ->
    #battle_return_atter{
        server_id = AttServerId,
        server_num = AttServerNum,
        id  = AUid,
        real_name = AttName,
        sign  = AtterSign,
        guild_id = AttGuildId,
        lv = AttLv,
        mask_id = AttMaskId
    } = Atter,
    #player_status{
        id=DeadUid, scene = Scene, x = X, y = Y, server_id = ServerId, server_num = ServerNum, guild = #status_guild{id = GuildId},
        figure = #figure{name = DeadName, lv = DeadLv, mask_id = DeadMaskId}
    }=Status,
    case is_in_eudemons_boss(Scene) of
        false ->
            ignore;
        true ->
            AtterInfo = [AUid, AttName, AttLv, AtterSign, AttGuildId, AttServerId, AttServerNum, AttMaskId],
            DerInfo = [DeadUid, DeadName, DeadLv, GuildId, ServerId, ServerNum, DeadMaskId],
            mod_clusters_node:apply_cast(mod_eudemons_land, player_die, [AtterInfo, DerInfo, Scene, X, Y])
    end.

make_record(eudemons_boss, PS) ->
    #player_status{
        id = RoleId, server_id = ServerId, server_num = ServerNum, server_name = ServerName, platform = PlatForm,
        figure = #figure{name = RoleName}, status_boss = StatusBoss
    } = PS,
    #status_boss{boss_map = BossMap} = StatusBoss,
    case maps:get(?BOSS_TYPE_PHANTOM, BossMap, undefined) of
        #role_boss{die_times = DieTimes, die_time = DieTime, next_enter_time = _NextEnterTime} ->
            ok;
        _ ->
            DieTime = 0, DieTimes = 0
    end,
    BeKillCount = ?IF(DieTimes == 0, [], lists:duplicate(DieTimes, DieTime)),
    #eudemons_boss{
        role_id = RoleId, name = RoleName, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
        plat_form = PlatForm, node = node(), bekill_count = BeKillCount
    }.

%% 根据场景id，获取该场景下的一个bossid和层数
get_one_boss_info_by_scene(Scene) ->
    AllBossId = data_eudemons_land:get_all_eudemons_boss_id(),
    get_one_boss_info_by_scene_do(AllBossId, Scene).

get_one_bossid_and_layer(Scene) ->
    AllBossId = data_eudemons_land:get_all_eudemons_boss_id(),
    case get_one_boss_info_by_scene_do(AllBossId, Scene) of
        #eudemons_boss_cfg{boss_id = BossId, layers = Layer} ->
            {BossId, Layer};
        _ -> {0, 0}
    end.

get_one_boss_info_by_scene_do([], _Scene) -> [];
get_one_boss_info_by_scene_do([BossId|AllBossId], Scene) ->
    case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
        #eudemons_boss_cfg{scene = Scene} = BossConfig ->
            BossConfig;
        _ ->
            get_one_boss_info_by_scene_do(AllBossId, Scene)
    end.

% format_drop_record(PS, MonArgs, UpGoodsL) ->
%     #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, figure = #figure{name = RoleName}} = PS,
%     #mon_args{mid = BossId, scene = _Scene} = MonArgs,
%     case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
%         #eudemons_boss_cfg{layers = Layer} ->
%             NeedRecordGoodsIds = ?EUDEMONS_RECORD_GOODS_LIST,
%             NowTime = utime:unixtime(),
%             F = fun(Goods, List) ->
%                 #goods{goods_id = GoodsTypeId, other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} = Goods,
%                 %?PRINT("format_drop_record GoodsTypeId : ~p~n", [GoodsTypeId]),
%                 case lists:member(GoodsTypeId, NeedRecordGoodsIds) of
%                     true ->
%                         ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []),
%                         [{RoleId, ServerId, ServerNum, RoleName, BossId, Layer, GoodsTypeId, Rating, ExtraAttr, NowTime}|List];
%                     _ ->
%                         List
%                 end
%             end,
%             lists:foldl(F, [], UpGoodsL);
%         _ ->
%             []
%     end.

%% 已经执行过
% gm_add_eudemons_exp_all() ->
%     case util:get_open_day() > 5 of
%         true ->
%             case db:get_all("select id, lv from player_low where lv >= 360") of
%                 [] -> ok;
%                 L ->
%                     F = fun([RoleId, Lv], Acc) ->
%                             ExpAdd1 = round((19+(Lv-360)/5+1)*((Lv-360)/5+1)/2/1608*4000),
%                             ExpAdd = max(ExpAdd1, 0),
%                             %?PRINT("gm_add ## :~p~n", [{RoleId, Lv, ExpAdd}]),
%                             case lib_player:get_alive_pid(RoleId) of
%                                 false ->
%                                     case db:get_row(io_lib:format("select eudemons_lv,eudemons_exp from eudemons_boss_lv where role_id=~p", [RoleId])) of
%                                         [OldEudemonsLv, OldEudemonsExp] -> ok;
%                                         _ -> OldEudemonsLv = 1, OldEudemonsExp = 0
%                                     end,
%                                     {NewEudemonsLv, NewEudemonsExp} = add_eudemons_exp(OldEudemonsLv, OldEudemonsExp, ExpAdd),
%                                     SqlRe = io_lib:format("replace into eudemons_boss_lv set role_id=~p, eudemons_lv=~p, eudemons_exp=~p", [RoleId, NewEudemonsLv, NewEudemonsExp]),
%                                     db:execute(SqlRe);
%                                 Pid ->
%                                     lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, gm_add_eudemons_exp, [ExpAdd])
%                             end,
%                             Acc rem 30 == 0 andalso timer:sleep(1000),
%                             Acc + 1
%                     end,
%                     lists:foldl(F, 1, L),
%                     ok
%             end;
%         _ ->
%             ok
%     end.

gm_add_eudemons_exp_all() ->
    case db:get_all("select role_id, eudemons_lv, eudemons_exp from eudemons_boss_lv ") of
        [] -> ok;
        L ->
            F = fun([RoleId, OldEudemonsLv, OldEudemonsExp], Acc) ->
                    ExpAdd = 0,
                    case lib_player:get_alive_pid(RoleId) of
                        false ->
                            {NewEudemonsLv, NewEudemonsExp} = add_eudemons_exp(OldEudemonsLv, OldEudemonsExp, ExpAdd),
                            SqlRe = io_lib:format("replace into eudemons_boss_lv set role_id=~p, eudemons_lv=~p, eudemons_exp=~p", [RoleId, NewEudemonsLv, NewEudemonsExp]),
                            db:execute(SqlRe);
                        Pid ->
                            lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, gm_add_eudemons_exp, [ExpAdd])
                    end,
                    Acc rem 30 == 0 andalso timer:sleep(1000),
                    Acc + 1
            end,
            lists:foldl(F, 1, L),
            ok
    end.

gm_add_eudemons_task_score(RoleId, Type, ScoreAdd) ->
    RoleName = lib_role:get_role_name(RoleId),
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    ScoreType = ?IF(Type == 2, ?SCORE_TYPE_4, ?SCORE_TYPE_2),
    Args = [RoleId, RoleName, ServerId, ServerNum, ScoreType, ScoreAdd],
    mod_clusters_node:apply_cast(mod_eudemons_land, gm_add_score, [Args]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 没用函数

% %% 幻兽之域1层小怪：
% get_eudemons_scene_mon(1501)->
%     [
%      [1501101,9, [{4568,2294},{4883,2275},{4572,2005},{4400,2138},{4424,2453},{4712,2446},{4559,2578},{4730,2137},{4226,2299}]],
%      [1501102,11,[{2844, 970}, {3185,996}, {2412,829}, {2718,840}, {3042,874}, {2228,664}, {2586,702}, {2894,756}, {2460,514}, {2766,627},{2639,436}]],
%      [1501103,12,[{6720,1546},{6595,1429},{6810,1421},{6712,1289},{6955,1286},{6831,1135},{6010,785},{5881,617},{6181,635},{6057,508},{6382,497},{6252,370}]],
%      [1501104,12,[{7775,3754},{7989,3744},{8201,3756},{8413,3746},{7779,3570},{7989,3568},{8207,3574},{8427,3554},{7765,3380},{7987,3388},{8221,3390},{7975,3216}]],
%      [1501105,11,[{2777,5408},{2966,5408},{3179,5411},{2787,5237},{2987,5236},{3186,5239},{2789,5060},{2984,5065},{3191,5059},{2987,4876},{3198,4880}]],
%      [1501106,12,[{5380,6491},{5566,6492},{5768,6499},{5950,6493},{5373,6322},{5582,6314},{5761,6323},{5958,6319},{5369,6144},{5581,6143},{5767,6135},{5961,6146}]]
%     ];

% %% 幻兽之域2层小怪：
% get_eudemons_scene_mon(1502) ->
%     [
%      [1502101,9,[{4568,2294},{4883,2275},{4572,2005},{4400,2138},{4424,2453},{4712,2446},{4559,2578},{4730,2137},{4226,2299}]],
%      [1502102,11,[{2844,970},{3185,996},{2412,829},{2718,840},{3042,874},{2228,664},{2586,702},{2894,756},{2460,514},{2766,627},{2639,436}]],
%      [1502103,12,[{6720,1546},{6595,1429},{6810,1421},{6712,1289},{6955,1286},{6831,1135},{6010,785},{5881,617},{6181,635},{6057,508},{6382,497},{6252,370}]],
%      [1502104,12,[{7775,3754},{7989,3744},{8201,3756},{8413,3746},{7779,3570},{7989,3568},{8207,3574},{8427,3554},{7765,3380},{7987,3388},{8221,3390},{7975,3216}]],
%      [1502105,11,[{2777,5408},{2966,5408},{3179,5411},{2787,5237},{2987,5236},{3186,5239},{2789,5060},{2984,5065},{3191,5059},{2987,4876},{3198,4880}]],
%      [1502106,12,[{5380,6491},{5566,6492},{5768,6499},{5950,6493},{5373,6322},{5582,6314},{5761,6323},{5958,6319},{5369,6144},{5581,6143},{5767,6135},{5961,6146}]]
%     ];
% get_eudemons_scene_mon(_SceneId)->
%     [].


% %% 38170001
% use_boss_tired_goods(#player_status{id = RoleId, sid = Sid, eudemons_boss = EudemonsBoss} = Ps, Num)->
%     case data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS) of
%         #eudemons_boss_type{module_id = ModuleId, counter_id = CounterId} ->
%             BossTired = mod_daily:get_count(RoleId, ModuleId, CounterId),
%             if
%                 BossTired =< 0 -> {false, ?ERRCODE(err150_no_boss_tired)};
%                 true ->
%                     NewNum = if BossTired > Num -> Num; true -> BossTired end,
%                     NewBossTired = BossTired - NewNum,
%                     mod_daily:set_count(RoleId, ModuleId, CounterId, NewBossTired),
%                     NewEudemonsBoss = EudemonsBoss#eudemons_boss{eudemons_boss_tired = NewBossTired},
%                     mod_scene_agent:update(Ps, [{eudemons_boss_tired, NewBossTired}]),
%                     lib_server_send:send_to_sid(Sid, pt_470, 47009, [NewBossTired]),
%                     {ok, Ps#player_status{eudemons_boss = NewEudemonsBoss}, NewNum}
%             end
%     end.

% %% 4点更新还在幻兽之域的玩家的进程信息
% update_eudemons_boss_info(Ps)->
%     #player_status{scene = Scene, eudemons_boss = EudemonsBoss} = Ps,
%     #eudemons_boss{cl_boss_info = ClBossInfo} = EudemonsBoss,
%     NewCLInfo = [{K, 0} || {K, _Count} <- ClBossInfo],
%     NewEudemonsBoss = EudemonsBoss#eudemons_boss{eudemons_boss_tired = 0, cl_boss_info = NewCLInfo},
%     mod_scene_agent:update(Ps, [{boss_tired, 0}, {eudemons_boss_tired, 0}, {eudemons_boss_clinfo, NewCLInfo}]),
%     case is_in_eudemons_boss(Scene) of
%         false -> ok;
%         true ->
%             Node = mod_disperse:get_clusters_node(),
%             mod_clusters_node:apply_cast(mod_eudemons_land, update_role_eudemons_boss, [Node, NewEudemonsBoss])
%     end,
%     NewEudemonsBoss.

% %% 发送采集tips
% send_cl_tips(ClCountInfo, Key, BossType, IsRare, Node, RoleId)->
%     #eudemons_boss_type{count = NolCount, rare_count = RareCount}
%         = data_eudemons_land:get_eudemons_boss_type(BossType),
%     LessCount = if
%                     IsRare == ?MON_CL_NORMAL ->
%                         {_, UsedCount} = lists:keyfind(Key, 1, ClCountInfo),
%                         max(NolCount - UsedCount, 0);
%                     true ->
%                         AllClBossId = data_eudemons_land:get_cl_boss_ids(),
%                         AllRareCount = calc_all_rare_cl_count(AllClBossId, ClCountInfo, 0),
%                         max(RareCount - AllRareCount, 0)
%                 end,
%     String = utext:get(?MOD_EUDEMONS_BOSS, 6, [LessCount]),
%     {ok, Bin} = pt_110:write(11020, [String]),
%     lib_clusters_center:send_to_uid(Node, RoleId, Bin).

% %% 检查采集
% check_eudemons_boss_cl(User, MonId)->
%     case data_eudemons_land:get_eudemons_boss_cfg(MonId) of
%         #eudemons_boss_cfg{type = Type, is_rare = IsRare,
%                            module_id = ModId, counter_id = CId} when IsRare >= ?MON_CL_NORMAL->
%             case data_eudemons_land:get_eudemons_boss_type(Type) of
%                 [] -> 4; %% 采集失败
%                 #eudemons_boss_type{count = NorCount, rare_count = RareCount} ->
%                     #ets_scene_user{eudemons_cl_info = ClBossInfo} = User,
%                     if
%                         IsRare == ?MON_CL_RARE -> %% 有多个计数id
%                             AllClBossId = data_eudemons_land:get_cl_boss_ids(),
%                             AllRareCount = calc_all_rare_cl_count(AllClBossId, ClBossInfo, 0),
%                             if AllRareCount >= RareCount -> 10; true -> true end;
%                         true -> %% 普通采集怪就只有一个计数id
%                             K = {ModId, ?DEF_SUB_MOD, CId},
%                             case lists:keyfind(K, 1, ClBossInfo) of
%                                 false -> true;
%                                 {_, UsedCount} ->
%                                     if NorCount =< UsedCount -> 9; true -> true end
%                             end
%                     end
%             end;
%         _R ->
%             true
%     end.

% %% 计算珍贵的采集次数
% calc_all_rare_cl_count([], _ClBossInfo, Count)-> Count;
% calc_all_rare_cl_count([BossId|AllClBossId], ClBossInfo, Count)->
%     case data_eudemons_land:get_eudemons_boss_cfg(BossId) of
%         [] ->
%             calc_all_rare_cl_count(AllClBossId, ClBossInfo, Count);
%         #eudemons_boss_cfg{ is_rare = IsRare, module_id = ModId, counter_id = CId} ->
%             if
%                 IsRare =/= ?MON_CL_RARE ->
%                     calc_all_rare_cl_count(AllClBossId, ClBossInfo, Count);
%                 true ->
%                     case lists:keyfind({ModId, ?DEF_SUB_MOD, CId}, 1, ClBossInfo) of
%                         false ->
%                             calc_all_rare_cl_count(AllClBossId, ClBossInfo, Count);
%                         {_, Count1} ->
%                             calc_all_rare_cl_count(AllClBossId, ClBossInfo, Count+Count1)
%                     end
%             end
%     end.

% eudemons_boss_login(Ps)->
%     case data_eudemons_land:get_eudemons_boss_type(?BOSS_TYPE_EUDEMONS) of
%         #eudemons_boss_type{count = _NlCount, rare_count = _ClCount,
%                             tired = _MaxTired, module_id = ModuleId, counter_id = CounterId} ->
%             #player_status{id = RoleId, server_name = SName, platform = Pfrom,
%                            server_id = SerId, server_num = SNum, figure = Figure} = Ps,
%             AllClBossId = data_eudemons_land:get_cl_boss_ids(),
%             BossTiredKey = {ModuleId, ?DEF_SUB_MOD, CounterId},
%             F = fun(BossId, L) ->
%                         #eudemons_boss_cfg{module_id = BossMId, counter_id = BossCId, cl_count = _BossClCount}
%                             = data_eudemons_land:get_eudemons_boss_cfg(BossId),
%                         [{BossMId, ?DEF_SUB_MOD, BossCId}|L]
%                 end,
%             TypeList =  lists:usort(lists:foldl(F, [BossTiredKey], AllClBossId)),
%             AllDailyCounts = mod_daily:get_count(RoleId, TypeList),
%             BossTired = case lists:keyfind(BossTiredKey, 1, AllDailyCounts) of
%                             false -> 0;
%                             {_, TBossTired} -> TBossTired
%                         end,
%             ClBossCountInfo = lists:keydelete(BossTiredKey, 1, AllDailyCounts),
%             Ps#player_status{eudemons_boss = #eudemons_boss{role_id = RoleId, name = Figure#figure.name,
%                                                             server_id = SerId, server_name = SName,
%                                                             plat_form = Pfrom, server_num = SNum,
%                                                             cl_boss_info = ClBossCountInfo, eudemons_boss_tired = BossTired}};
%         _ ->
%             #player_status{id = RoleId, server_name = SName, platform = Pfrom,
%                            server_id = SerId, server_num = SNum, figure = Figure} = Ps,
%             Ps#player_status{eudemons_boss = #eudemons_boss{role_id = RoleId, name = Figure#figure.name,
%                                                             server_id = SerId, server_name = SName,
%                                                             plat_form = Pfrom, server_num = SNum}}
%     end.

cost_reborn(#player_status{id = RoleId, server_id = ServerId} = Player, BossType, BossId) ->
    case check_cost_reborn(Player, BossType) of
        {false, ErrCode} -> ok;
        {true, Cost} ->
            ErrCode = ?SUCCESS,
            mod_clusters_node:apply_cast(mod_eudemons_land, cost_reborn, [ServerId, RoleId, BossType, BossId, Cost])
    end,
    case ErrCode == ?SUCCESS of
        true -> skip;
        false ->
            {ok, BinData} = pt_470:write(47035, [ErrCode, BossType, BossId]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

check_cost_reborn(Player, BossType) ->
    BaseBossType = data_boss:get_boss_type(BossType),
    if
        is_record(BaseBossType, boss_type) == false -> {false, ?MISSING_CONFIG};
        BaseBossType#boss_type.reborn_cost == [] -> {false, ?ERRCODE(err460_no_cost_reborn)};
        true ->
            #boss_type{reborn_cost = Cost} = BaseBossType,
            case lib_goods_api:check_object_list(Player, Cost) of
                {false, ErrCode} -> {false, ErrCode};
                true -> {true, Cost}
            end
    end.

%% 确认消耗
ack_cost_reborn(Player, BossType, BossId, Cost) ->
    #player_status{id = RoleId, server_id = ServerId, scene = SceneId, x = X, y = Y} = Player,
    About = lists:concat(["BossType:", BossType, ",BossId:", BossId]),
    case lib_goods_api:cost_object_list_with_check(Player, Cost, boss_cost_reborn, About) of
        {false, ErrCode, NewPlayer} -> ok;
        {true, NewPlayer} ->
            ErrCode = ?SUCCESS,
            lib_log_api:log_boss_cost_reborn(RoleId, SceneId, X, Y, BossType, BossId, Cost)
    end,
    case ErrCode == ?SUCCESS of
        true -> skip;
        false ->
            {ok, BinData} = pt_470:write(47035, [ErrCode, BossType, BossId]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    mod_clusters_node:apply_cast(mod_eudemons_land, ack_cost_reborn, [ServerId, RoleId, BossType, BossId, ErrCode]),
    {ok, NewPlayer}.

get_extra_times(PS) ->
    Times1 = lib_goods_buff:get_module_extra_times(PS, {?MOD_EUDEMONS_BOSS, 0}),
    Times2 = lib_contract_challenge:get_extra_player_time(PS, ?MOD_EUDEMONS_BOSS, 0),
    Times1 + Times2.