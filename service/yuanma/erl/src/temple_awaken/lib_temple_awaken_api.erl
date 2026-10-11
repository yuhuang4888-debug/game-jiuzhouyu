%% ---------------------------------------------------------------------------
%% @doc lib_temple_awaken_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/1
%% @deprecated  神殿觉醒api接口处理，比如任务完成触发
%% ---------------------------------------------------------------------------
-module(lib_temple_awaken_api).

%% API
-compile([export_all]).

-include("server.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("boss.hrl").
-include("fashion.hrl").
-include("temple_awaken.hrl").
-include("mount.hrl").
-include("team.hrl").
-include("goods.hrl").

%% 激活幻型调用，取消掉神殿幻型
cancel_chapter_illusion(Player, TypeId) ->
    case lists:keyfind(TypeId, 2, ?ILLUSION_CHAPTERS) of
        false -> {ok, Player};
        {Chapter, _} ->
            case lib_temple_awaken:be_cancel_wear(Player, Chapter, TypeId) of
                {ok, wear, NewPs} -> skip;
                {ok, NewPs} -> skip
            end,
            {ok, NewPs}
    end.

%% 穿戴时装(衣服调用)调用，取消掉神殿幻型
cancel_chapter_fashion(Player, PosId) ->
    case lists:keyfind(PosId, 1, ?FASHION_CHAPTER) of
        false -> {ok, Player};
        {_, Chapter} ->
            case lib_temple_awaken:be_cancel_wear(Player, Chapter, ?POS_CLOTH) of
                {ok, wear, NewPs} ->
                    #base_temple_awaken{pos_type = TypeId} = data_temple_awaken:get_temple_awaken(Chapter),
                    #player_status{figure = Figure} = NewPs,
                    #figure{mount_figure_ride = MFigureRide, mount_figure = MFigure} = Figure,
                    NewMFigure = lists:keydelete(TypeId, 1, MFigure),
                    NewMFigureRide = lists:keydelete(TypeId, 1, MFigureRide),
                    NewFigure = Figure#figure{mount_figure = NewMFigure, mount_figure_ride = NewMFigureRide},
                    LastPs = NewPs#player_status{figure = NewFigure},
                    lib_temple_awaken:broadcast_info(LastPs, Chapter, 0),
                    {ok, LastPs};
                {ok, NewPs} -> {ok, NewPs}
            end
    end.

%% 检查当前激将幻化的幻型位置对应的神殿模型是否幻化了
%%  --如果已经没幻化则跳过
%%  --如果幻化了则取消神殿的幻化，再判断当前
%% 坐骑的幻型数据是否和之前的一样，一样的话则
%% 不作逻辑处理，广播原本的模型即可，不一样的
%% 话走正常逻辑（神殿幻型只会替换figure的值，
%% 不会替换status_mount数据）
check_and_unwear_model(Player, StatusType, Type, Args) ->
    #status_mount{type_id = TypeId, illusion_type = IllusionType, stage = Stage, illusion_id = IllusionId} = StatusType,
    case lists:keyfind(TypeId, 2, ?ILLUSION_CHAPTERS) of
        false -> {ok, Player};
        {Chapter, _} ->
            case lib_temple_awaken:be_cancel_wear(Player, Chapter, TypeId) of
                {ok, wear, NewPs} ->
                    IsSatisfy = ?IF(IllusionType == ?BASE_MOUNT_FIGURE, IllusionType == Type andalso Stage == Args, IllusionType == Type andalso IllusionId == Args),
                    if
                        IsSatisfy -> {ok, nodeal, NewPs};
                        true ->  {ok, NewPs}
                    end;
                {ok, NewPs} ->
                    {ok, NewPs}
            end
    end.

%% 广播乘骑状态
broadcast_change_ride_status(FigureId, TypeId, Player) ->
    case lists:keyfind(TypeId, 2, ?ILLUSION_CHAPTERS) of
        false -> FigureId;
        {Chapter, _} ->
            #player_status{temple_awaken = #status_temple_awaken{temple_awaken_map = TempleAwakenMap}, figure = #figure{career = Career}} = Player,
            case maps:get(Chapter, TempleAwakenMap, false) of
                #chapter_status{is_ware = ?IS_WARE} ->
                    #base_temple_awaken_suit{figure_id = ResFigureId} = data_temple_awaken:get_career_suit(Chapter, Career),
                    ResFigureId;
                _ -> FigureId
            end
    end.

%% 每日0点执行触发
%% 一些涉及到开服天数的任务进度需要
day_trigger() ->
    [lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?MODULE, day_trigger, [])||#ets_online{id = RoleId}<-ets:tab2list(?ETS_ONLINE)].

day_trigger(Ps) ->
    trigger(Ps, [{lv_day, Ps#player_status.figure#figure.lv}]).

%% ==========================================Trigger Fun=========================================================

%% 上线事件 EVENT_LOGIN_CAST
handle_event(Player, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    %% 防止卡进度
    {ok, NewPlayerTmp} = lib_temple_awaken:auto_check_task(Player),
%%    {ok, NewPlayer} = lib_temple_awaken_event:finish_main_task(NewPlayerTmp),
    trigger(NewPlayerTmp, [{lv_day, NewPlayerTmp#player_status.figure#figure.lv}]);

%% 升级事件
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    case catch lib_temple_awaken:level_up_unlock(Player) of
        {ok, NewPlayer} -> skip;
        _Error ->
            ?ERR("temple_awaken handle level up error ~p ~n", [_Error]),
            NewPlayer = Player
    end,
%%    ?MYLOG("zhtemple", "TempleAwaken ~p ~n", [NewPlayer#player_status.temple_awaken]),
    RoleLv = Player#player_status.figure#figure.lv,
    trigger(NewPlayer, [{lv, RoleLv}, {lv_day, RoleLv}]);

%% 战力改变
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) ->
    trigger(Player, [{combat, Player#player_status.combat_power}]);

%% 副本完成
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_id = DunId, count = Count}}) ->
    trigger(Player, [{enter_dun, DunId, Count}]);
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = #callback_dungeon_succ{dun_type = DunType, dun_id = DunId, count = Count, help_type = ?HELP_TYPE_NO}}) ->
    case DunType of
        ?DUNGEON_TYPE_RUNE2 ->
            Level = lib_dungeon_rune:get_dungeon_level(Player),
            ?PRINT("{rune_dun, Level} ~p ~n", [{rune_dun, Level}]),
            {ok, PlayerTmp1} = trigger(Player, [{rune_dun, Level}]);
        _ -> PlayerTmp1 = Player
    end,
    trigger(PlayerTmp1, [{dun, DunType, Count}, {dun_id, DunId, Count}]);

%% 转生成功
handle_event(Player, #event_callback{type_id = ?EVENT_TURN_UP}) ->
    trigger(Player, [{turn, Player#player_status.figure#figure.turn}]);


handle_event(_Player, _CallBack) ->
    {ok, _Player}.


%% 功能开启(完成指定任务ID)
trigger_finish_task(Player, TaskId) ->
    {PreTaskId, _CurrentTaskId} = ?AWAKEN_TASK_INFO,
    case PreTaskId == TaskId of
        true -> lib_server_send:send_to_sid(Player#player_status.sid, pt_429, 42909, [1]);
        _ -> skip
    end,
    case lists:member(TaskId, ?NEED_CHECK_TASK_ID) of
        true -> trigger(Player, [{finish_task, TaskId}]);
        _ -> {ok, Player}
    end.

%% 坐骑模块升级
trigger_mount_stage(Player, #status_mount{type_id = TypeId, stage = Stage, star = Star}) ->
    trigger(Player, [{mount, TypeId, Stage, Star}]).
trigger_mount_stage(Player, TypeId, Stage, Star) ->
    trigger(Player, [{mount, TypeId, Stage, Star}]).


%% 击杀怪物
trigger_kill_mon(IsClsType, ?BATTLE_SIGN_PLAYER, _AtterId, ServerId, Mid, BLWhos) ->
    BossTypeList = [?BOSS_TYPE_NEW_OUTSIDE],
    case data_boss:get_boss_cfg(Mid) of
        #boss_cfg{type = BossType0} ->
            %% 无限层世界boss当成世界boss|策划说只处理神殿觉醒和任务（lib_task_api）相关的，锤倒过来再改
            BossType = ?IF(BossType0 == ?BOSS_TYPE_WORLD_PER, ?BOSS_TYPE_NEW_OUTSIDE, BossType0),
            case lists:member(BossType, BossTypeList) of
                true ->
                    #mon{lv = Lv} = data_mon:get(Mid),
                    [begin
                         case IsClsType of
                             1 ->
                                 mod_clusters_center:apply_cast(ServerId, lib_temple_awaken_api, async_trigger, [PlayerId, [{boss_lv, BossType, Lv, 1}]]);
                             _ ->
                                 lib_temple_awaken_api:async_trigger(PlayerId, [{boss_lv, BossType, Lv, 1}])
                         end
                     end||#mon_atter{id = PlayerId}<-BLWhos];
                _ -> skip
            end ;
        _ -> skip
    end;
trigger_kill_mon(_IsClsType, _AtterSign, _AtterId, _ServerId, _Mid, _BLWhos) ->
    skip.

%% （跨服）圣域boss击杀
trigger_sanctuary_boss(Player) when is_record(Player, player_status) ->
    trigger(Player, [{boss_type, ?BOSS_TYPE_KF_SANCTUARY, 1}]);
trigger_sanctuary_boss(RoleId) when is_integer(RoleId) ->
    async_trigger(RoleId, [{boss_type, ?BOSS_TYPE_KF_SANCTUARY, 1}]).

%% 活跃度等级
trigger_active_lv(Player, ActiveLv) ->
    trigger(Player, [{active_lv, ActiveLv}]).

%% 强化总等级， 强化触发
trigger_strength_sum_lv(Player, EquipStrenList) ->
    trigger(Player, [{strength_sum_lv, EquipStrenList}]).

%% 装备状态
trigger_equip_status(Player, EquipList) ->
    trigger(Player, [{equip_status, EquipList}]).

%% 勋章等级
trigger_medal_lv(Player, MedalLv) ->
    trigger(Player, [{medal_lv, MedalLv}]).

%% 进入蛮荒
trigger_enter_ml(RoleId) ->
    async_trigger(RoleId, [{enter_mh, 1}]).

%% 装备合成
trigger_compose_equip(RoleId, ComposeGoodsList) ->
    async_trigger(RoleId, [{compose_equip, ComposeGoodsList}]).

%% 套装激活状态
trigger_suit_status(Player, EquipSuitState) ->
    trigger(Player, [{suit, EquipSuitState}]).

%% 圣印状态
trigger_seal_status(Player, SealList) ->
    trigger(Player, [{seal_status, SealList}]).

%% 装备洗练状态
trigger_wash_status(Player, WashStatus) ->
    WashList = maps:to_list(WashStatus),
    Fun = fun
              ({_Key, #equip_wash{duan = Duan}}, AccDuan) -> AccDuan + Duan;
              (_, AccDuan) -> AccDuan
          end,
    SumDuan = lists:foldl(Fun, 0, WashList),
    trigger(Player, [{wash_status, WashStatus}, {wash_sum_lv, SumDuan}]).

%% 激活伙伴
trigger_active_companion(Player, CompanionId) ->
    trigger(Player, [{active_companion, CompanionId}]).

%% 激活幻兽
trigger_active_eudemon(Player, EudemonId) ->
    trigger(Player, [{active_eudemon, EudemonId}]).

%% 激活降神
trigger_active_god(Player, GodId) ->
    trigger(Player, [{active_god, GodId}]).

%% 幻饰评分
trigger_decoration_rate(Player) ->
    Rate = lib_decoration:get_overall_rating(Player),
    trigger(Player, [{decoration_rate, Rate}]).

%% 降神升星
trigger_god_star(Player, GodId, GodStar) ->
    trigger(Player, [{god_status, GodId, GodStar}]).


%% 触发入口
async_trigger(Player, Args) when is_record(Player, player_status) ->
    async_trigger(Player#player_status.id, Args);
async_trigger(PlayerId, Args) when is_integer(PlayerId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_temple_awaken_api, trigger, [Args]).

trigger(Player, []) -> {ok, Player};
trigger(Player, Args) when is_list(Args) ->
    case catch lib_temple_awaken:trigger(Player, Args) of
        {ok, NewPlayer} -> skip;
        _Error ->
            %?MYLOG("zhtemple", "_Error ~p ~n", [_Error]),
            ?ERR("temple_awaken_trigger_error, role_id ~p, Args ~p ~n", [Player#player_status.id, Args]),
            NewPlayer = Player
    end ,
    {ok, NewPlayer};
trigger(Player, _Args) ->
    ?ERR("temple_awaken_trigger_args_error, Args ~p ~n", [_Args]),
    {ok, Player}.