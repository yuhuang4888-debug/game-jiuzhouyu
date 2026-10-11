%%%-----------------------------------
%%% @Module      : lib_kf_seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 17:14
%%% @Description : 海战日常
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_seacraft_daily).
-author("carlos").
-include("common.hrl").
-include("errcode.hrl").
-include("seacraft_daily.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("goods.hrl").
-include("guild.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("drop.hrl").
-include("def_fun.hrl").

%% API
-export([]).


logout(PS) ->
    #player_status{scene = Scene} = PS,
    case is_scene(Scene) of
        true ->
            pp_seacraft_daily:handle(18708, PS, []);
        _ ->
            ok
    end.

day_trigger() ->
    Sql = io_lib:format("UPDATE   role_sea_craft_daily set  task_list = '[]'  , carry_count = 0, defend_count = 0", []),
    db:execute(Sql),
    %% 周常
    case utime:day_of_week() of
        1 ->
            Sql2 = io_lib:format("UPDATE   role_sea_craft_daily set  week_task_list = '[]'", []),
            db:execute(Sql2);
        _ ->
            ok
    end,
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, day_trigger, []) || RoleId <- IdList].

day_trigger(PS) ->
    #player_status{sea_craft_daily = Daily,scene = Scene} = PS,
    case Daily of
        #role_sea_craft_daily{} ->
            DailyNew = Daily#role_sea_craft_daily{task_list = [], carry_count = 0, defend_count = 0},
            %% 周常
            case utime:day_of_week() of
                1 ->
                    DailyLast = DailyNew#role_sea_craft_daily{week_task_list = []};
                _ ->
                    DailyLast = DailyNew
            end,
            case  is_scene(Scene) of
                true ->
                    pp_seacraft_daily:handle(18708, PS, []);
                _ ->
                    skip
            end,
            PS#player_status{sea_craft_daily = DailyLast};
        _ ->
            PS
    end.


%% 死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = DefRoleId, scene = SceneId, copy_id = RoomId,
        sea_craft_daily = Daily, guild = Guild, figure = Figure} = Player,
    #{attersign := AtterSign, atter := Atter, hit := HitList} = Data,
    #battle_return_atter{id = AtterId, server_id = AtterServerId, server_num = KillServerNum, real_name = KillName} = Atter,
    #status_guild{realm = MySeaId} = Guild,
    case is_scene(SceneId) of
        true ->
            Arg1 = {RoomId, AtterServerId, KillServerNum, AtterId, KillName, MySeaId, config:get_server_id(), config:get_server_num(), DefRoleId, Figure#figure.name},
            Arg2 = {Daily, RoomId},
            Arg3 = {RoomId, DefRoleId, AtterServerId, AtterId},
            #status_guild{realm = MySeaId} = Guild,
            #role_sea_craft_daily{status = CarryStatus} = Daily,
            if
                AtterSign == ?BATTLE_SIGN_PLAYER ->
                    send_role_be_kill_tv(RoomId, AtterServerId, KillServerNum,
                        AtterId, KillName, MySeaId, config:get_server_id(), config:get_server_num(), DefRoleId, Figure#figure.name),
                    [begin
                         mod_clusters_node:apply_cast(mod_kf_seacraft_daily,
                             player_be_kill, [CarryStatus, RoomId, config:get_server_id(),
                                 config:get_server_num(), DefRoleId, MySeaId, Node, HitRoleId])
                     end || #hit{node = Node, id = HitRoleId} <- HitList, Node =/= 0],
                    mod_clusters_node:apply_cast(mod_kf_seacraft_daily,
                        player_be_kill, [CarryStatus, RoomId, config:get_server_id(), config:get_server_num(), DefRoleId, MySeaId, AtterServerId, AtterId]);
                true ->
                    skip
            end,
            case Daily of
                #role_sea_craft_daily{status = ?carrying} ->
                    %% 卸下搬砖
                    pp_seacraft_daily:handle(18706, Player, []);
                _ ->
                    skip

            end,
            ?IF(MySeaId == RoomId, skip, mod_seacraft_local:role_die_handle(Arg1, Arg2, Arg3));
        false ->
            skip
    end,
    {ok, Player}.

%% 角色死亡回调(mod_seacraft_local进程调用)
%% 判断封边
%% @param IsRetreat 是否封边
die_handle(IsRetreat, Arg1, Arg2, Arg3) ->
    {RoomId, AtterServerId, _KillServerNum, AtterId, _KillName, _MySeaId,
        ServerId, _ServerNum, DefRoleId, _RoleName} = Arg1,
    {_Daily, Camp} = Arg2,
    {RoomId, DefRoleId, AtterServerId, AtterId} = Arg3,
%%    send_role_be_kill_tv(RoomId, AtterServerId, KillServerNum,AtterId,
%%        KillName, MySeaId, ServerId, ServerNum, DefRoleId, RoleName),
%%    case Daily of
%%        #role_sea_craft_daily{status = ?carrying} ->
%%            %% 卸下搬砖
%%            pp_seacraft_daily:handle(18706, Player, []),
%%            mod_clusters_node:apply_cast(mod_kf_seacraft_daily,
%%                player_be_kill, [?carrying, RoomId, config:get_server_id(), config:get_server_num(), DefRoleId, MySeaId, AtterServerId, AtterId]);
%%        _ ->
%%            mod_clusters_node:apply_cast(mod_kf_seacraft_daily,
%%                player_be_kill, [?common, RoomId, config:get_server_id(), config:get_server_num(), DefRoleId, MySeaId, AtterServerId, AtterId])
%%
%%    end,
    case IsRetreat of
        false -> skip;
        true ->
            lib_server_send:send_to_uid(DefRoleId, pt_187, 18714, [1]),
            spawn(fun() ->
                timer:sleep(3000),
                lib_scene:player_change_scene(DefRoleId, 0, 0, 0, false, [{action_free, ?ERRCODE(err187_in_scene)}, {camp, 0}, {group, 0}, {del_hp_each_time,[]}, {change_scene_hp_lim, 100}]),
                mod_clusters_node:apply_cast(mod_kf_seacraft_daily, quit_sea, [ServerId, DefRoleId, Camp])
                  end)
    end.

player_be_kill(PS, ?common, NowSeaId, _CarryServerId, _CarryServerNum, _CarryRoleId, _DefSeaId) ->
    #player_status{guild = Guild, id = RoleId, sea_craft_daily = _Daily} = PS,
    #status_guild{realm = MySeaId} = Guild,
%%    mod_daily:get_count(RoleId, ?MOD_SANCTUARY, ?sanctuary_boss_tired_daily_id),
    mod_daily:increment(RoleId, ?MOD_SEACRAFT_DAILY, 1),
    KillCount = mod_daily:get_count(RoleId, ?MOD_SEACRAFT_DAILY, 1),  %% 杀人次数
    if
        MySeaId == NowSeaId -> %% 在自己海域击杀了别人完成任务了
            %% 本国杀人
            send_kill_reward_in_my_sea(RoleId, KillCount),
            finish_act(RoleId, 3, 1);  %%击杀人入侵者人的任务
        true ->
            send_kill_reward_in_other_sea(RoleId, KillCount), %% 他国杀人
            ok
    end,
    pp_seacraft_daily:do_handle(18703, PS, []),
    PS;
player_be_kill(PS, _CarryStatus, NowSeaId, CarryServerId, CarryServerNum, CarryRoleId, _DefSeaId) ->
    #player_status{sea_craft_daily = Daily, guild = Guild, id = RoleId} = PS,
    #status_guild{realm = MySeaId} = Guild,
    NeedCount = data_sea_craft_daily:get_kv(defend_count),
    mod_daily:increment(RoleId, ?MOD_SEACRAFT_DAILY, 1),
    KillCount = mod_daily:get_count(RoleId, ?MOD_SEACRAFT_DAILY, 1),  %% 杀人次数
    if
        MySeaId == NowSeaId -> %% 在自己海域击杀了别人完成任务了
            %% 本国杀人
            send_kill_reward_in_my_sea(RoleId, KillCount),
            finish_act(RoleId, 3, 1),  %%击杀人入侵者人的任务
            case Daily of
                #role_sea_craft_daily{defend_count = DefendCount} ->
%%                  ?MYLOG("cym", "player_be_kill+++++ MySeaId ~p  NowSeaId ~p ~n", [MySeaId, NowSeaId]),
                    if
                        DefendCount >= NeedCount andalso MySeaId == NowSeaId ->
                            lib_log_api:log_sea_craft_daily_defend(RoleId, CarryServerId, CarryServerNum, CarryRoleId, DefendCount + 1, []),
                            DailyNew = Daily#role_sea_craft_daily{defend_count = DefendCount + 1},
                            save_to_db(Daily, RoleId),
                            LastPS = PS#player_status{sea_craft_daily = DailyNew};
                        DefendCount < NeedCount andalso MySeaId == NowSeaId ->  %%
                            DailyNew = Daily#role_sea_craft_daily{defend_count = DefendCount + 1},
                            save_to_db(Daily, RoleId),
                            Reward = data_sea_craft_daily:get_kv(defend_reward),
                            lib_log_api:log_sea_craft_daily_defend(RoleId, CarryServerId, CarryServerNum, CarryRoleId, DefendCount + 1, Reward),
                            %%  发送奖励
                            lib_goods_api:send_reward_with_mail(RoleId,
                                #produce{reward = Reward, type = sea_craft_daily_defend_reward, show_tips = ?SHOW_TIPS_3}),
                            LastPS = PS#player_status{sea_craft_daily = DailyNew};
                        true ->
                            LastPS = PS
                    end;
                _ ->
                    LastPS = PS
            end,
            pp_seacraft_daily:do_handle(18703, PS, []),
            LastPS;
        true ->
            send_kill_reward_in_other_sea(RoleId, KillCount), %% 他国杀人
            pp_seacraft_daily:do_handle(18703, PS, []),
            PS
    end.




login(PS) ->
    Sql = io_lib:format(?select_role_local_msg, [PS#player_status.id]),
    Res = db:get_row(Sql),
    get_exp_attr(PS),
    async_set_sea_brick_num(PS),
    case Res of
        [TaskList, CarryCount, DefendCount, BrickColor, WeekTaskList] ->
            Daily = #role_sea_craft_daily{task_list = util:bitstring_to_term(TaskList), week_task_list = util:bitstring_to_term(WeekTaskList),
                carry_count = CarryCount, defend_count = DefendCount, brick_color = BrickColor, status = ?common},

            PS#player_status{sea_craft_daily = Daily};
        _ ->
            PS#player_status{sea_craft_daily = #role_sea_craft_daily{}}
    end.


get_exp_attr(PS) ->
    %%开服天数限制
    #player_status{figure = F, guild = Guild, id = RoleId} = PS,
    #status_guild{realm = SeaId} = Guild,
    NeedOpenDay = 1,
    NeedLv = 1,
    OpenDay = util:get_open_day(),
    if
        SeaId == 0 ->
            skip;
        OpenDay < NeedOpenDay ->
            skip;
        F#figure.lv < NeedLv ->
            skip;
        true ->
            %%
            mod_clusters_node:apply_cast(mod_kf_seacraft_daily, get_exp_attr, [config:get_server_id(), RoleId, SeaId])
    end.


re_login(PS) ->
    #player_status{battle_attr = BA, scene = Scene, copy_id = EnterSeaId, guild = #status_guild{realm = MySeaId}} = PS,
    get_exp_attr(PS),
    #battle_attr{hp = Hp} = BA,
    InScene = is_scene(Scene),
%%    ?MYLOG("cmy2", "Hp  ~p  InScene ~p ~n", [Hp, InScene]),
    if
        Hp =< 0 andalso InScene == true ->
            {X, Y} = lib_kf_seacraft_daily_mod:get_born_xy(MySeaId, EnterSeaId),
%%            mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
%%                [RoleId, SceneId, ZoneId, EnterSeaId, X, Y, false, [{group, MySeaId},{camp, MySeaId},
%% {action_lock, ?ERRCODE(err187_in_scene)}, {change_scene_hp_lim, 100}]]).
            NewPlayer = lib_scene:change_relogin_scene(PS#player_status{x = X, y = Y}, [{change_scene_hp_lim, 100}, {group, MySeaId}, {camp, MySeaId}]),
            NewPlayer;
        true ->
            PS
    end.



finish_act(RoleId, TaskId, Count) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_seacraft_daily, finish_act2, [TaskId, Count]).



finish_act2(PS, TaskId, AddCount) ->
    #player_status{sea_craft_daily = Daily, id = RoleId} = PS,
    #role_sea_craft_daily{task_list = TaskList, week_task_list = WeekTaskList} = Daily,
    case data_sea_craft_daily:get_task(TaskId) of
        #sea_daily_task_cfg{type = ?task_daily} ->  %日常任务
            case lists:keyfind(TaskId, 1, TaskList) of
                {_, Count, Status} ->
                    lib_log_api:log_sea_craft_daily_task(RoleId, TaskId, Count, Count + AddCount),
                    NewTaskList = lists:keystore(TaskId, 1, TaskList, {TaskId, Count + AddCount, Status});
                _ ->
                    lib_log_api:log_sea_craft_daily_task(RoleId, TaskId, 0, AddCount),
                    NewTaskList = lists:keystore(TaskId, 1, TaskList, {TaskId, AddCount, ?not_get_reward})
            end,
            NewDaily = Daily#role_sea_craft_daily{task_list = NewTaskList},
            save_to_db(NewDaily, RoleId),
            LastPS = PS#player_status{sea_craft_daily = NewDaily};
        _ -> %% 周常任务
            case lists:keyfind(TaskId, 1, WeekTaskList) of
                {_, Count, Status} ->
                    lib_log_api:log_sea_craft_daily_task(RoleId, TaskId, Count, Count + AddCount),
                    NewWeekTaskList = lists:keystore(TaskId, 1, WeekTaskList, {TaskId, Count + AddCount, Status});
                _ ->
                    lib_log_api:log_sea_craft_daily_task(RoleId, TaskId, 0, AddCount),
                    NewWeekTaskList = lists:keystore(TaskId, 1, WeekTaskList, {TaskId, AddCount, ?not_get_reward})
            end,
            NewDaily = Daily#role_sea_craft_daily{week_task_list = NewWeekTaskList},
            save_to_db(NewDaily, RoleId),
            LastPS = PS#player_status{sea_craft_daily = NewDaily}
    end,
    pp_seacraft_daily:handle(18712, LastPS, []),
    LastPS.




is_scene(SceneId) ->
    SceneIdCfg = data_sea_craft_daily:get_kv(scene_id),
    SceneId == SceneIdCfg.

%% 保存数据库
save_to_db(NewDaily, RoleId) ->
    #role_sea_craft_daily{task_list = TaskList, week_task_list = WeekTaskList,
        carry_count = CarryCount, defend_count = DefendCount, brick_color = BrickColor} = NewDaily,
    Sql = io_lib:format(?save_role_local_msg, [RoleId, util:term_to_bitstring(TaskList),
        CarryCount, DefendCount, BrickColor, util:term_to_bitstring(WeekTaskList)]),
    db:execute(Sql).


get_upgrade(OldLv, Lv) ->
    get_upgrade(OldLv, Lv, []).


get_upgrade(Lv, Lv, Cost) ->
    Cost;
get_upgrade(OldLv, Lv, Cost) ->
    case data_sea_craft_daily:get_brick(OldLv) of
        #brick_cfg{cost = NewCost} ->
            get_upgrade(OldLv + 1, Lv, Cost ++ NewCost);
        _ ->
            Cost
    end.

check_skill_has_learn(Status, _SkillId) ->
    #player_status{scene = Scene, sea_craft_daily = Daily} = Status,
    #role_sea_craft_daily{status = Carry} = Daily,
    IsInScene = is_scene(Scene),
    if
        IsInScene == false ->
            false;
        Carry == ?common ->
            false;
        true ->
            true
    end.

%% 计算战力
count_attr(PS) ->
    ?PRINT("count_attr :~p~n", [start]),
    #player_status{
        battle_attr = OldBA
        , sea_craft_daily = Daily
        , guild = Guild
    } = PS,
    #battle_attr{hp = OldHp, hp_lim = OldHpLim, speed = OldSpeed, pk = OldPk, skill_effect = OldSkillEffect} = OldBA,
    #role_sea_craft_daily{brick_color = BrickColor} = Daily,
    case data_sea_craft_daily:get_brick(BrickColor) of
        #brick_cfg{attr = Attr} ->
            ok;
        _ ->
            Attr = []
    end,
    TotalAttr = lib_player_attr:to_attr_record(Attr),
    _NewCombatPower = lib_player:calc_all_power(TotalAttr),
    #attr{hp = NewHp, speed = BattleSpeed} = TotalAttr,
    %% 血量
    GapHp = NewHp - OldHpLim,
    RealHp = if
                 GapHp < 0 -> NewHp;
                 true -> min(OldHp + GapHp, NewHp)
             end,
    NewBA = #battle_attr{hp = RealHp, hp_lim = NewHp, speed = BattleSpeed, battle_speed = BattleSpeed,
        attr = TotalAttr, pk = OldPk, skill_effect = OldSkillEffect, group = Guild#status_guild.realm
    },
    NewPS = PS#player_status{battle_attr = NewBA},
    case OldSpeed /= BattleSpeed of
        false -> skip;
        true ->
            lib_scene:change_speed(NewPS#player_status.id, NewPS#player_status.scene, NewPS#player_status.scene_pool_id,
                NewPS#player_status.copy_id, NewPS#player_status.x, NewPS#player_status.y, NewBA#battle_attr.speed, ?BATTLE_SIGN_PLAYER)
    end,
    NewPS.



notice_local_start_carry_brick(RoleId, BrickColor, SeaBrickNum, Type) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, notice_local_start_carry_brick2, [BrickColor, SeaBrickNum, Type]).


%%完成搬砖     日志
notice_local_start_carry_brick2(PS, BrickColor, SeaBrickNum, finish_carry) ->
    #player_status{sea_craft_daily = Daily, figure = Figure, id = RoleId, guild = Guild} = PS,
    #role_sea_craft_daily{carry_count = Count, brick_color = OldBrickColor} = Daily,
    DailyNew = Daily#role_sea_craft_daily{status = ?common, brick_color = BrickColor, carry_count = Count + 1},
    save_to_db(DailyNew, RoleId),
    FigureNew = Figure#figure{brick_color = 0},
    PS1 = PS#player_status{sea_craft_daily = DailyNew, figure = FigureNew, del_hp_each_time = []},
    PS2 = lib_player:count_player_attribute(PS1),
%%    mod_scene_agent:update(PS2, [{del_hp_each_time, []}]),  %%取消每秒扣除血量限制
    #player_status{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = PS2,
    {ok, BinData} = pt_120:write(12009, [RoleId, Hp, HpLim]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    %lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),
    %%改变形象
    lib_scene:broadcast_player_attr(PS2, [{14, 0}]),  %%
    #status_guild{realm = MySeaId} = Guild,
    PassiveSkill = lib_skill:get_skill_passive(PS2),
%%    ?MYLOG("skill", "PassiveSkill ~p~n", [PassiveSkill]),
    mod_scene_agent:update(PS2, [{brick_color, 0}, {del_hp_each_time, []}, {battle_attr, PS2#player_status.battle_attr}, {group, MySeaId}, {passive_skill, PassiveSkill}]),
    NeedCount = data_sea_craft_daily:get_kv(carry_brick_count),
    if
        Count + 1 =< NeedCount ->
            Reward = get_carry_brick_reward(OldBrickColor, SeaBrickNum, Figure#figure.lv),
            % ?MYLOG("cym", "Reward ~p  Count ~p ~n", [Reward, Count]),
            if
                Reward =/= [] ->
                    lib_log_api:log_sea_craft_daily_carry_brick(RoleId, 0, 0, 0, 0, 0, BrickColor, 3, Reward),
                    lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = sea_craft_carry_brick_reward}),
                    {ok, Bin} = pt_187:write(18710, [Count + 1, Reward]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    PS2;
                true ->
                    PS2
            end;
        true ->
            % ?MYLOG("cym", "NeedCount ~p  Count ~p ~n", [NeedCount, Count]),
            {ok, Bin} = pt_187:write(18710, [Count + 1, []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            PS2
    end;

%% 结束搬砖
notice_local_start_carry_brick2(PS, BrickColor, _SeaBrickNum, end_carry) ->
    #player_status{sea_craft_daily = Daily, figure = Figure, id = RoleId, guild = Guild, scene_pool_id = PoolId,
        scene = SceneId, copy_id = CopyId} = PS,
    DailyNew = Daily#role_sea_craft_daily{status = ?common, brick_color = BrickColor},
    save_to_db(DailyNew, RoleId),
    FigureNew = Figure#figure{brick_color = 0},
    PS1 = PS#player_status{sea_craft_daily = DailyNew, figure = FigureNew, del_hp_each_time = []},
    PS2 = lib_player:count_player_attribute(PS1),
    #player_status{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = PS2,
    {ok, BinData} = pt_120:write(12009, [RoleId, Hp, HpLim]),
    lib_server_send:send_to_scene(SceneId, PoolId, CopyId, BinData),
%%    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    %lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),
    %%改变形象
    lib_scene:broadcast_player_attr(PS2, [{14, 0}]),  %%
    #status_guild{realm = MySeaId} = Guild,
    PassiveSkill = lib_skill:get_skill_passive(PS2),
%%    ?MYLOG("skill", "PassiveSkill ~p~n", [PassiveSkill]),

    mod_scene_agent:update(PS2, [{brick_color, 0}, {del_hp_each_time, []}, {battle_attr, PS2#player_status.battle_attr}, {group, MySeaId}, {passive_skill, PassiveSkill}]),
    {ok, Bin} = pt_187:write(18706, [?SUCCESS]),
%%    ?MYLOG("cym", "end_carry ~n", []),
    lib_server_send:send_to_uid(RoleId, Bin),
    PS2;

%% 开始搬砖
notice_local_start_carry_brick2(PS, BrickColor, _SeaBrickNum, start_carry) ->
    #player_status{sea_craft_daily = Daily, figure = Figure, id = RoleId, guild = Guild,
        scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId} = PS,
    DailyNew = Daily#role_sea_craft_daily{status = ?carrying, brick_color = BrickColor},
    save_to_db(DailyNew, RoleId),
    FigureNew = Figure#figure{brick_color = BrickColor},
    DelHpEachTime = data_sea_craft_daily:get_kv(del_hp_each_time),
    PS1 = PS#player_status{sea_craft_daily = DailyNew, figure = FigureNew, del_hp_each_time = [DelHpEachTime, DelHpEachTime]},
    PS2 = lib_player:count_player_attribute(PS1),
%%    mod_scene_agent:update(PS2, [{del_hp_each_time, [0.01,0.01]}]),  %%每秒扣除血量限制
    #player_status{battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = PS2,
    {ok, BinData} = pt_120:write(12009, [RoleId, Hp, HpLim]),
    lib_server_send:send_to_scene(SceneId, PoolId, CopyId, BinData),
%%    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    %lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),
    %%添加临时技能,不用添加，释放的时候检查即可
    %%改变形象
    lib_scene:broadcast_player_attr(PS2, [{14, BrickColor}]),  %%
    #status_guild{realm = MySeaId} = Guild,
    PassiveSkill = lib_skill:get_skill_passive(PS2),
    DeletePassiveSkill =  lib_skill:get_skill_passive(PS),
%%    ?MYLOG("skill", "PassiveSkill ~p~n", [PassiveSkill]),
%%    ?MYLOG("skill", "DeletePassiveSkill ~p~n", [DeletePassiveSkill]),
    mod_scene_agent:update(PS2, [{delete_passive_skill, DeletePassiveSkill}, {brick_color, BrickColor}, {del_hp_each_time, [DelHpEachTime, DelHpEachTime]},
        {battle_attr, PS2#player_status.battle_attr}, {group, MySeaId}, {passive_skill, PassiveSkill}]),
    {ok, Bin} = pt_187:write(18705, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, Bin),
    PS2.



get_carry_brick_reward(BrickColor, _SeaBrickNum, RoleLv) ->
    case data_sea_craft_daily:get_brick(BrickColor) of
        #brick_cfg{reward = Reward1} ->
            ok;
        _ ->
            Reward1 = []
    end,
    case data_sea_craft_daily:get_brick(BrickColor) of
        #brick_cfg{exp_ratio = Ratio} -> %% 万分比
            ExpNum = erlang:round(math:pow(1.2, ((RoleLv - 150) / 50)) * 180000000 * Ratio / 10000);
        _ ->
            ExpNum = 0
    end,
    if
        ExpNum == 0 ->
            Reward1;
        true ->
            Reward1 ++ [{?TYPE_EXP, 0, ExpNum}]
    end.


%%    测试
get_exp_attr2(PS, BrickNum) ->
%%    ?MYLOG("cym", "BrickNum ~p~n", [BrickNum]),
    #player_status{sea_craft_daily = Daily} = PS,
    case Daily of
        #role_sea_craft_daily{} ->
            NewDailyPS = PS#player_status{sea_craft_daily = Daily#role_sea_craft_daily{sea_brick_num = BrickNum}},
            LastPs = lib_player:count_player_attribute(NewDailyPS),
            LastPs;
        _ ->
            PS
    end.

get_exp_attr_right(PlayerStatus) ->
    #player_status{sea_craft_daily = Daily} = PlayerStatus,
    case Daily of
        #role_sea_craft_daily{attr = Attr} ->
            Attr;
        _ ->
            []
    end.



revive(Status) ->
    #player_status{guild = Guild, copy_id = NowSeaId} = Status,
    #status_guild{realm = MySeaId} = Guild,
    {X, Y} = lib_kf_seacraft_daily_mod:get_born_xy(MySeaId, NowSeaId),
    [{x, X}, {y, Y}].



get_sea_name(SeaId) ->
    case data_seacraft:get_camp_name(SeaId) of
        [] ->
            "";
        Name ->
            Name
    end.



send_role_be_kill_tv(NowSeaId, KillServerId, KillServerNum,
    AtterId, KillName, DefRoleSeaId, DefServerId, DefServerNum, DefRoleId, DefRoleName) ->
    mod_clusters_node:apply_cast(lib_kf_seacraft_daily, send_role_be_kill_tv, [NowSeaId, KillServerId, KillServerNum,
        AtterId, KillName, DefRoleSeaId, DefServerId, DefServerNum, DefRoleId, DefRoleName]).

async_set_sea_brick_num(Player) ->
    #player_status{guild = StatusGuild, id = RoleId} = Player,
    case StatusGuild of
        #status_guild{realm = Camp} when Camp =/= 0 ->
            mod_seacraft_local:async_set_sea_brick_num(RoleId, Camp);
        _ -> skip
    end.

%% 同步砖块数量
update_sea_brick_num(Player, Camp, SeaBrickNum) ->
    #player_status{guild = StatusGuild, sea_craft_daily = Daily} = Player,
    case StatusGuild of
        #status_guild{realm = Camp} ->
            NewDaily = Daily#role_sea_craft_daily{sea_brick_num = SeaBrickNum},
            Player#player_status{sea_craft_daily = NewDaily};
        _ -> Player
    end.

%% 掉落翻倍
calc_drop_rule_for_drop_rule(Player, EtsDropRule) ->
    #player_status{sea_craft_daily = Daily} = Player,
    #role_sea_craft_daily{sea_brick_num = BrickNum} = Daily,
    Ratio = data_sea_craft_daily:get_exp_attr(BrickNum),  %% 增加的掉落概率
    List = data_sea_craft_daily:get_kv(drop_list),
    #ets_drop_rule{drop_rule = DropRule} = EtsDropRule,
    NewDropRule = do_calc_drop_rule_for_drop_rule(DropRule, Ratio, List, []),
    EtsDropRule#ets_drop_rule{drop_rule = NewDropRule}.


%%calc_drop_rule_for_drop_rule(Ps, DropRule) ->
%%    #player_status{sea_craft_daily = Daily} = Ps,
%%    #role_sea_craft_daily{sea_brick_num = BrickNum} = Daily,
%%    Ratio = data_sea_craft_daily:get_exp_attr(BrickNum),  %% 增加的掉落概率
%%    List = data_sea_craft_daily:get_kv(drop_list),
%%    NewDropRule = do_calc_drop_rule_for_drop_rule(DropRule, Ratio, List, []),
%%    NewDropRule.



do_calc_drop_rule_for_drop_rule([], _Value, _Args, Result) -> lists:reverse(Result);
do_calc_drop_rule_for_drop_rule([{L, R} | T], Value, Args, Result) ->
    F = fun({ListId, Num}) ->
        case lists:member(ListId, Args) of
            true ->
                NewNum = Num * (1 + Value / ?RATIO_COEFFICIENT),
                % 获得整数掉落数量
                NumInt = umath:floor(NewNum),
                % 小数值要随机是否掉落多1个
                NumFloatRatio = round((NewNum - NumInt) * ?RATIO_COEFFICIENT),
                Rand = urand:rand(1, ?RATIO_COEFFICIENT),
                case Rand =< NumFloatRatio of
                    true -> NumSum = NumInt + 1;
                    false -> NumSum = NumInt
                end,
                % ?MYLOG("hjhdrop", "Num:~p, NewNum:~p Rand:~p NumFloatRatio:~p NumSum:~p ~n", [Num, NewNum, Rand, NumFloatRatio, NumSum]),
                {ListId, NumSum};
            false ->
                {ListId, Num}
        end
        end,
    NewL = lists:map(F, L),
    do_calc_drop_rule_for_drop_rule(T, Value, Args, [{NewL, R} | Result]).


broadcast_to_copy(RoleId, SeaId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, broadcast_to_copy2, [SeaId]).

broadcast_to_copy2(PS, _SeaId) ->
    pp_seacraft_daily:handle(18701, PS, []),
    pp_seacraft_daily:handle(18703, PS, []),
    PS.


%% 本国杀人奖励
send_kill_reward_in_my_sea(RoleId, KillCount) ->
    PreCount = data_sea_craft_daily:get_kv(pre_kill_count),
    %% sea_craft_daily_kill_reward
    if
        KillCount =< PreCount ->  %% 前20次的奖励
            Reward = data_sea_craft_daily:get_kv(pre_kill_reward),
            lib_goods_api:send_reward_with_mail(RoleId, #produce{show_tips = ?SHOW_TIPS_3, reward = Reward, type = sea_craft_daily_kill_reward});
        true ->
            Reward = data_sea_craft_daily:get_kv(af_kill_reward),
            lib_goods_api:send_reward_with_mail(RoleId, #produce{show_tips = ?SHOW_TIPS_3, reward = Reward, type = sea_craft_daily_kill_reward})
    end.


send_kill_reward_in_other_sea(RoleId, _KillCount) ->
    Reward = data_sea_craft_daily:get_kv(in_other_sea_kill_reward),
    lib_goods_api:send_reward_with_mail(RoleId, #produce{show_tips = ?SHOW_TIPS_3, reward = Reward, type = sea_craft_daily_kill_reward}).



is_carry(Ps) ->
    #player_status{sea_craft_daily = Daily} = Ps,
    case Daily of
        #role_sea_craft_daily{status = ?carrying} ->
            true;
        _ ->
            false
    end.

force_quit_scene(?MOD_SEACRAFT_DAILY, 0) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, force_quit_scene, []) || RoleId <- IdList];
force_quit_scene(_, _) ->
    skip.

force_quit_scene(PS) ->
    #player_status{server_id = ServerId, id = RoleId, copy_id = SeaId, sea_craft_daily = Daily
        ,scene = Scene, guild = StatuGuild} = PS,
    #role_sea_craft_daily{status = CarryStatus} = Daily,
    IsInScene = lib_seacraft_daily:is_scene(Scene),
    if
        IsInScene == true ->
            lib_scene:player_change_scene(RoleId, 0, 0, 0, false, [{action_free, ?ERRCODE(err187_in_scene)}, {camp, 0}, {group, 0}, {del_hp_each_time,[]}, {change_scene_hp_lim, 100}]),
            if
                CarryStatus == ?carrying ->
                    #status_guild{realm = MySeaId} = StatuGuild,
                    mod_clusters_node:apply_cast(mod_kf_seacraft_daily, end_carry_brick, [ServerId, RoleId, SeaId, MySeaId]);
                true ->
                    sikp
            end,
            mod_clusters_node:apply_cast(mod_kf_seacraft_daily, quit_sea, [ServerId, RoleId, SeaId]);
        true ->
            skip
    end,
    PS.

gm_kick() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, gm_kick, []) || RoleId <- IdList].


gm_kick(PS) ->
    #player_status{id = RoleId, copy_id = SeaId, sea_craft_daily = Daily
        ,scene = Scene, guild = StatuGuild} = PS,
    #role_sea_craft_daily{status = CarryStatus} = Daily,
    case data_sea_craft_daily:get_kv(scene_id) of
        Scene ->
            lib_scene:player_change_scene(RoleId, 0, 0, 0, false, [{action_free, ?ERRCODE(err187_in_scene)}, {camp, 0}, {group, 0}, {del_hp_each_time,[]}, {change_scene_hp_lim, 100}]),
            if
                CarryStatus == ?carrying ->
                    #status_guild{realm = MySeaId} = StatuGuild,
                    mod_clusters_node:apply_cast(mod_kf_seacraft_daily, end_carry_brick, [config:get_server_id(), RoleId, SeaId, MySeaId]);
                true ->
                    sikp
            end,
            mod_clusters_node:apply_cast(mod_kf_seacraft_daily, quit_sea, [config:get_server_id(), RoleId, SeaId]);
        _ ->
            skip
    end,
    PS.


gm_kf_clear_scene() ->
    ZoneIds = mod_zone_mgr:get_all_zone_ids(),
    SceneId = data_sea_craft_daily:get_kv(scene_id),
    [lib_scene:clear_scene(SceneId, ZoneId) ||ZoneId <- ZoneIds].


%% -----------------------------------------------------------------
%% @desc     功能描述   扣除gm扣除背包物品
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------


gm_cost_goods() ->
    List =
        [[{4294967297,[{101021150,20}]}],[{3126736191663,[{103014112,5}]}],[{2787433775635,[{102104132,5}]}],[{2714419332148,[{103014122,5}]}],[{2804613644410,[{101104142,5}]}],[{3255585211019,[{102024122,5}]}],[{2753074037258,[{101014132,4}]}],[{2963527435810,[{101064122,4}]}],[{2993592205531,[{103014122,4}]}],[{3126736191663,[{101014122,4}]}],[{2826088481575,[{101104122,4}]}],[{2843268349966,[{101014132,4}]}],[{2976412338366,[{102064122,4}]}],[{2804613644410,[{101084142,4}]}],[{2804613644410,[{101104132,4}]}],[{2804613644410,[{102024142,4}]}],[{2804613644410,[{102044142,4}]}],[{2804613644410,[{102104142,4}]}],[{2589865279792,[{102104132,4}]}],[{2838973383288,[{101014122,4}]}],[{2838973383288,[{102014122,4}]}],[{2847563317679,[{101024122,3}]}],[{2847563317679,[{102084122,3}]}],[{2705829396674,[{101024132,3}]}],[{2753074037258,[{101104132,3}]}],[{2753074037258,[{102064132,3}]}],[{2963527435810,[{101014112,3}]}],[{2572685410657,[{101014112,3}]}],[{2744484102374,[{101024122,3}]}],[{2559800508670,[{102044132,3}]}],[{2559800508670,[{102104132,3}]}],[{3148211028035,[{101024102,3}]}],[{2993592205531,[{102084132,3}]}],[{3027951944601,[{101104112,3}]}],[{3126736191663,[{101024122,3}]}],[{2946347565207,[{102084112,3}]}],[{2950642534348,[{101084122,3}]}],[{2826088481054,[{102014112,3}]}],[{2826088481054,[{102044112,3}]}],[{2826088481575,[{102044122,3}]}],[{2843268349966,[{101064132,3}]}],[{2843268349966,[{102044132,3}]}],[{2843268349966,[{103014132,3}]}],[{2787433775635,[{101064132,3}]}],[{2508260901212,[{102084132,3}]}],[{2508260901665,[{101014132,3}]}],[{2508260901665,[{101104122,3}]}],[{2508260901665,[{102064132,3}]}],[{3199750635840,[{104014122,3}]}],[{3212635538167,[{102014112,3}]}],[{3212635538167,[{102014122,3}]}],[{3281355015135,[{102024122,3}]}],[{2972117368991,[{101104102,3}]}],[{2972117370316,[{102044122,3}]}],[{2972117370316,[{102064112,3}]}],[{2804613644410,[{104014142,3}]}],[{2804613644805,[{102044122,3}]}],[{2804613644805,[{102064132,3}]}],[{2804613644805,[{102104142,3}]}],[{3066606650224,[{102064112,3}]}],[{2576980377994,[{102014132,3}]}],[{2576980377994,[{102024132,3}]}],[{2589865279792,[{102024132,3}]}],[{3135326126829,[{101104102,3}]}],[{3143916060780,[{101084122,3}]}],[{2838973383288,[{101104122,3}]}],[{2838973383288,[{102044122,3}]}],[{2838973383288,[{102104112,3}]}],[{2838973383288,[{103014102,3}]}],[{2838973383288,[{103014122,3}]}],[{3045131812948,[{104014122,3}]}],[{2907692861038,[{102044122,3}]}],[{2907692861467,[{102024112,3}]}],[{2911987826761,[{102014112,3}]}],[{2911987826761,[{102104112,3}]}],[{3216930505589,[{101084102,2}]}],[{3216930505589,[{102024122,2}]}],[{3216930505589,[{103014122,2}]}],[{2847563317679,[{101084122,2}]}],[{2847563317679,[{101104122,2}]}],[{2847563317679,[{102014102,2}]}],[{2847563317679,[{102014112,2}]}],[{2847563317679,[{102024112,2}]}],[{2847563317679,[{102024122,2}]}],[{2847563317679,[{102044112,2}]}],[{2847563317679,[{102044122,2}]}],[{2847563317679,[{102104122,2}]}],[{2847563317679,[{103014122,2}]}],[{2856153252726,[{102024102,2}]}],[{2856153252726,[{102084112,2}]}],[{2684354560031,[{102044112,2}]}],[{2684354560132,[{103014132,2}]}],[{2705829396640,[{101014132,2}]}],[{2705829396674,[{102024132,2}]}],[{2705829396674,[{104014122,2}]}],[{2705829396674,[{104014132,2}]}],[{2753074037258,[{101014122,2}]}],[{2753074037258,[{101064142,2}]}],[{2753074037258,[{101084122,2}]}],[{2753074037258,[{102014132,2}]}],[{2753074037337,[{101014122,2}]}],[{2753074037337,[{101044132,2}]}],[{2753074037337,[{102084132,2}]}],[{2753074037625,[{102014122,2}]}],[{2753074037625,[{102024112,2}]}],[{2753074037625,[{102084142,2}]}],[{2753074037625,[{102104122,2}]}],[{2963527434396,[{102064122,2}]}],[{2963527434396,[{102104122,2}]}],[{2727304233831,[{102024122,2}]}],[{2740189135842,[{102024132,2}]}],[{2564095475799,[{102024122,2}]}],[{2564095475799,[{102084122,2}]}],[{2581275344929,[{101044112,2}]}],[{2581275344929,[{101104122,2}]}],[{2744484102374,[{101084122,2}]}],[{2744484102374,[{102044122,2}]}],[{2744484102374,[{102064112,2}]}],[{2559800508529,[{101064122,2}]}],[{2559800508529,[{102104122,2}]}],[{2559800508670,[{101024112,2}]}],[{2559800508670,[{101064112,2}]}],[{2559800508670,[{104014132,2}]}],[{2559800509078,[{101024132,2}]}],[{2559800509078,[{102084112,2}]}],[{2559800509078,[{102084132,2}]}],[{2559800509522,[{102104112,2}]}],[{2495375999274,[{101014142,2}]}],[{2495375999274,[{101044142,2}]}],[{2495375999994,[{102064142,2}]}],[{3148211028035,[{101014112,2}]}],[{3148211028035,[{102104112,2}]}],[{3148211028035,[{103014112,2}]}],[{3148211028035,[{104014102,2}]}],[{2993592205531,[{101014122,2}]}],[{2993592205531,[{101084122,2}]}],[{2993592205531,[{102084122,2}]}],[{2993592207450,[{102084132,2}]}],[{3238405341240,[{101064112,2}]}],[{3027951944490,[{104014112,2}]}],[{3036541878969,[{101104102,2}]}],[{3036541878969,[{104014102,2}]}],[{3040836845835,[{102064112,2}]}],[{3122441225143,[{102044122,2}]}],[{3122441225143,[{104014122,2}]}],[{3126736191663,[{101104112,2}]}],[{3126736191663,[{102064112,2}]}],[{3126736191663,[{104014102,2}]}],[{2942052598010,[{101014122,2}]}],[{2942052598010,[{101024132,2}]}],[{2942052598010,[{101044132,2}]}],[{2942052598010,[{101064132,2}]}],[{2942052598010,[{101084132,2}]}],[{2942052598010,[{101104132,2}]}],[{2942052598774,[{101024122,2}]}],[{2942052598774,[{101044112,2}]}],[{2946347565207,[{101104112,2}]}],[{2950642532475,[{102104122,2}]}],[{3092376453309,[{101064122,2}]}],[{3092376454030,[{101104122,2}]}],[{3092376454030,[{102064132,2}]}],[{2821793513739,[{102024122,2}]}],[{2821793514840,[{103014112,2}]}],[{2826088481054,[{102064122,2}]}],[{2826088481295,[{102064132,2}]}],[{2826088481575,[{101014122,2}]}],[{2826088481575,[{102024122,2}]}],[{2826088481575,[{102064122,2}]}],[{2826088481575,[{102084122,2}]}],[{2834678416439,[{102024122,2}]}],[{2787433775247,[{102014122,2}]}],[{2787433775635,[{101024132,2}]}],[{2787433775635,[{101044132,2}]}],[{2787433775635,[{102024132,2}]}],[{2787433775635,[{103014132,2}]}],[{2508260901453,[{102084122,2}]}],[{2714419331112,[{101024122,2}]}],[{2714419331112,[{101084112,2}]}],[{2714419331112,[{101104122,2}]}],[{2714419331112,[{102084122,2}]}],[{2714419331496,[{101014122,2}]}],[{2714419331496,[{101084122,2}]}],[{2714419331496,[{102014122,2}]}],[{2714419331496,[{102024132,2}]}],[{2714419331496,[{102064122,2}]}],[{2714419331496,[{102084132,2}]}],[{2714419331496,[{104014122,2}]}],[{2714419331609,[{101104112,2}]}],[{2714419331609,[{102044122,2}]}],[{2714419332148,[{103014132,2}]}],[{3277060047656,[{102024112,2}]}],[{3281355014460,[{102064102,2}]}],[{3281355015135,[{101014112,2}]}],[{3191160701385,[{102044112,2}]}],[{2671469659150,[{101024132,2}]}],[{2976412336350,[{102014122,2}]}],[{2976412336350,[{102104112,2}]}],[{2976412337968,[{101084112,2}]}],[{2976412337968,[{102014122,2}]}],[{2976412338366,[{101064132,2}]}],[{2976412338366,[{102024112,2}]}],[{2976412338366,[{102024122,2}]}],[{2976412338366,[{102104122,2}]}],[{2976412338366,[{104014132,2}]}],[{2972117369656,[{102064112,2}]}],[{2972117370027,[{101044102,2}]}],[{2972117370316,[{101024122,2}]}],[{2972117370316,[{102014102,2}]}],[{2972117370316,[{102104122,2}]}],[{2972117370316,[{103014102,2}]}],[{2972117370789,[{103014122,2}]}],[{2796023709833,[{101104122,2}]}],[{2796023709833,[{102044112,2}]}],[{2804613644410,[{101014142,2}]}],[{2804613644410,[{101024142,2}]}],[{2804613644410,[{102014122,2}]}],[{2804613644410,[{102024132,2}]}],[{2804613644805,[{101014132,2}]}],[{2804613644805,[{101044122,2}]}],[{2804613644805,[{101084122,2}]}],[{2804613644805,[{102044132,2}]}],[{3062311682108,[{102044122,2}]}],[{3062311682108,[{102104122,2}]}],[{3062311682256,[{101014122,2}]}],[{3066606649360,[{101024112,2}]}],[{3066606650224,[{101024112,2}]}],[{3066606650224,[{102104132,2}]}],[{2568390443998,[{102014132,2}]}],[{2576980377994,[{101014122,2}]}],[{2576980377994,[{103014132,2}]}],[{2585570312299,[{101024132,2}]}],[{2585570312364,[{101024132,2}]}],[{2585570312364,[{102024132,2}]}],[{2585570312611,[{102014122,2}]}],[{2589865279792,[{101064142,2}]}],[{2589865279792,[{103014142,2}]}],[{3006477107222,[{101084102,2}]}],[{3135326126829,[{101084112,2}]}],[{3135326126829,[{102064112,2}]}],[{3135326126829,[{103014102,2}]}],[{3268470112653,[{101014112,2}]}],[{3268470113203,[{102014122,2}]}],[{3272765080397,[{101104112,2}]}],[{2813203580365,[{102044112,2}]}],[{2838973383288,[{101024102,2}]}],[{2838973383288,[{101024122,2}]}],[{2838973383288,[{101064112,2}]}],[{2838973383288,[{101064122,2}]}],[{2838973383288,[{101104112,2}]}],[{2838973383288,[{102014102,2}]}],[{2838973383288,[{102044112,2}]}],[{2838973383288,[{102064122,2}]}],[{2838973383288,[{102084112,2}]}],[{2838973383288,[{102104102,2}]}],[{2838973383288,[{104014122,2}]}],[{2838973383473,[{102064122,2}]}],[{3045131812948,[{102084112,2}]}],[{3049426780825,[{102024102,2}]}],[{2886218023079,[{101064112,2}]}],[{2890512990526,[{101014112,2}]}],[{2890512990526,[{104014112,2}]}],[{2907692861038,[{101024102,2}]}],[{2907692861038,[{101064122,2}]}],[{2907692861038,[{101084122,2}]}],[{2907692861038,[{102104122,2}]}],[{2907692861038,[{103014112,2}]}],[{2907692861313,[{101014112,2}]}],[{2907692861313,[{101024112,2}]}],[{2907692861467,[{103014102,2}]}],[{2911987826761,[{101044122,2}]}],[{2911987827166,[{101044132,2}]}],[{2911987827166,[{101064132,2}]}],[{2911987827166,[{102014132,2}]}],[{3161095930535,[{101064112,2}]}],[{3161095930535,[{104014112,2}]}],[{3173980832167,[{101104112,2}]}],[{3216930505039,[{101044122,1}]}],[{3216930505589,[{101014122,1}]}],[{3216930505589,[{101024122,1}]}],[{3216930505589,[{101064112,1}]}],[{3216930505589,[{102064122,1}]}],[{2954937499686,[{102064122,1}]}],[{2847563317325,[{102014102,1}]}],[{2847563317369,[{101104122,1}]}],[{2847563317679,[{101064112,1}]}],[{2847563317679,[{101104102,1}]}],[{2847563317679,[{101104112,1}]}],[{2847563317679,[{102014122,1}]}],[{2847563317679,[{102064122,1}]}],[{2847563317679,[{102084112,1}]}],[{2847563317679,[{102104102,1}]}],[{2847563317679,[{103014102,1}]}],[{2856153252726,[{101014102,1}]}],[{2856153252726,[{101024102,1}]}],[{2856153252726,[{101104112,1}]}],[{2856153252726,[{102014112,1}]}],[{2856153252726,[{102104102,1}]}],[{2684354560031,[{101024112,1}]}],[{2684354560031,[{101044122,1}]}],[{2684354560031,[{101064112,1}]}],[{2684354560031,[{101064122,1}]}],[{2684354560031,[{101084112,1}]}],[{2684354560031,[{102044122,1}]}],[{2684354560031,[{104014112,1}]}],[{2684354560132,[{101084122,1}]}],[{2684354560132,[{102014132,1}]}],[{2684354560132,[{102024122,1}]}],[{2684354560132,[{102084122,1}]}],[{2705829396640,[{102024132,1}]}],[{2705829396640,[{102104132,1}]}],[{2705829396674,[{103014142,1}]}],[{3015067041923,[{102084132,1}]}],[{2753074037258,[{101014142,1}]}],[{2753074037258,[{101024142,1}]}],[{2753074037258,[{101084132,1}]}],[{2753074037258,[{101084142,1}]}],[{2753074037258,[{101104142,1}]}],[{2753074037258,[{102014142,1}]}],[{2753074037258,[{102024112,1}]}],[{2753074037258,[{102064122,1}]}],[{2753074037258,[{102104142,1}]}],[{2753074037258,[{104014142,1}]}],[{2753074037337,[{101024132,1}]}],[{2753074037337,[{101064112,1}]}],[{2753074037337,[{101064132,1}]}],[{2753074037337,[{101064142,1}]}],[{2753074037337,[{101104122,1}]}],[{2753074037337,[{101104132,1}]}],[{2753074037337,[{102014122,1}]}],[{2753074037337,[{102024112,1}]}],[{2753074037337,[{102044122,1}]}],[{2753074037337,[{102044142,1}]}],[{2753074037337,[{102084112,1}]}],[{2753074037337,[{102104142,1}]}],[{2753074037337,[{103014132,1}]}],[{2753074037625,[{101044122,1}]}],[{2753074037625,[{101064142,1}]}],[{2753074037625,[{102044132,1}]}],[{2753074037625,[{102084132,1}]}],[{2753074037625,[{102104112,1}]}],[{2753074037625,[{102104142,1}]}],[{2753074037625,[{103014122,1}]}],[{2753074037625,[{104014132,1}]}],[{2753074037707,[{102044122,1}]}],[{2757369004507,[{102014112,1}]}],[{2761663972161,[{102064132,1}]}],[{2765958938641,[{101104112,1}]}],[{2765958939504,[{102014132,1}]}],[{2963527434396,[{101064122,1}]}],[{2963527434396,[{101104122,1}]}],[{2963527434396,[{102024122,1}]}],[{2963527435454,[{101044102,1}]}],[{2963527435454,[{101084122,1}]}],[{2963527435454,[{104014122,1}]}],[{2963527435810,[{101014132,1}]}],[{2963527435810,[{102024122,1}]}],[{2963527435810,[{102104122,1}]}],[{2727304233311,[{101014132,1}]}],[{2727304233311,[{101104132,1}]}],[{2727304233311,[{101104142,1}]}],[{2727304233311,[{102014132,1}]}],[{2727304233311,[{102104142,1}]}],[{2727304233831,[{101064112,1}]}],[{2727304233831,[{101064122,1}]}],[{2727304233831,[{101084122,1}]}],[{2727304233831,[{102084122,1}]}],[{2727304233831,[{103014112,1}]}],[{2727304233926,[{101064132,1}]}],[{2731599200326,[{101014112,1}]}],[{2731599200326,[{102064112,1}]}],[{2731599200326,[{102084122,1}]}],[{2731599201223,[{102064112,1}]}],[{2731599201223,[{104014122,1}]}],[{2735894167905,[{102064122,1}]}],[{2740189134870,[{102014112,1}]}],[{2740189135736,[{101024122,1}]}],[{2740189135736,[{102104132,1}]}],[{2740189135842,[{101024132,1}]}],[{2740189135842,[{101084122,1}]}],[{2740189135842,[{103014132,1}]}],[{2564095475799,[{101014112,1}]}],[{2564095475799,[{101104112,1}]}],[{2564095475799,[{101104122,1}]}],[{2564095475799,[{102024132,1}]}],[{2564095475799,[{102064122,1}]}],[{2564095475799,[{103014112,1}]}],[{2564095475799,[{104014112,1}]}],[{2572685410449,[{102024122,1}]}],[{2572685410657,[{101014122,1}]}],[{2581275344929,[{101064122,1}]}],[{2581275344929,[{102014112,1}]}],[{2581275344929,[{102024122,1}]}],[{2581275345683,[{101024122,1}]}],[{2744484102374,[{102014122,1}]}],[{2770253906902,[{101024112,1}]}],[{2770253906902,[{101044112,1}]}],[{2559800508529,[{101044132,1}]}],[{2559800508529,[{101084122,1}]}],[{2559800508529,[{102044122,1}]}],[{2559800508670,[{101084112,1}]}],[{2559800508670,[{101084132,1}]}],[{2559800508670,[{101104122,1}]}],[{2559800508670,[{102064132,1}]}],[{2559800508670,[{102084142,1}]}],[{2559800508670,[{103014132,1}]}],[{2559800509078,[{101064132,1}]}],[{2559800509078,[{101084132,1}]}],[{2559800509078,[{102084122,1}]}],[{2559800509390,[{101024132,1}]}],[{2559800509390,[{101064122,1}]}],[{2559800509390,[{101104122,1}]}],[{2559800509390,[{102044112,1}]}],[{2559800509390,[{102064122,1}]}],[{2559800509390,[{104014112,1}]}],[{2559800509522,[{102024112,1}]}],[{2559800509522,[{102024122,1}]}],[{2495375999103,[{103014142,1}]}],[{2495375999274,[{101064132,1}]}],[{2495375999274,[{102014142,1}]}],[{2495375999274,[{102024132,1}]}],[{2495375999274,[{102044142,1}]}],[{2495376001388,[{101044122,1}]}],[{2495376001388,[{102014132,1}]}],[{2495376001388,[{102024142,1}]}],[{2495376001388,[{104014142,1}]}],[{2503965934098,[{101104122,1}]}],[{2503965934553,[{101024132,1}]}],[{2503965934553,[{102064122,1}]}],[{2503965934553,[{104014112,1}]}],[{2503965934620,[{102044122,1}]}],[{3148211028028,[{101064112,1}]}],[{3148211028035,[{101024112,1}]}],[{3148211028035,[{101044112,1}]}],[{3148211028035,[{102084102,1}]}],[{3148211028035,[{103014122,1}]}],[{3148211028219,[{101064112,1}]}],[{3148211028219,[{102104122,1}]}],[{3148211028256,[{101044102,1}]}],[{3148211028256,[{102064112,1}]}],[{3148211028256,[{103014112,1}]}],[{3148211028943,[{102024112,1}]}],[{3148211028961,[{101104112,1}]}],[{3148211028961,[{102014112,1}]}],[{3148211028961,[{102044112,1}]}],[{3156800963437,[{101044102,1}]}],[{3156800963437,[{102044112,1}]}],[{3156800963437,[{102084132,1}]}],[{3813930958968,[{101014092,1}]}],[{2529735737476,[{104014122,1}]}],[{2534030704732,[{101014142,1}]}],[{2534030704798,[{101024132,1}]}],[{2534030704798,[{101104132,1}]}],[{2534030704798,[{102024132,1}]}],[{2534030704798,[{102044122,1}]}],[{2534030704798,[{102064132,1}]}],[{2993592205531,[{101024122,1}]}],[{2993592205531,[{101104112,1}]}],[{2993592205531,[{101104122,1}]}],[{2993592205531,[{102024112,1}]}],[{2993592205531,[{104014112,1}]}],[{2993592207450,[{101024112,1}]}],[{2993592207450,[{101044122,1}]}],[{2993592207450,[{101104122,1}]}],[{2993592207450,[{102024122,1}]}],[{2993592207450,[{102024132,1}]}],[{2993592207450,[{102064112,1}]}],[{2993592207450,[{102064122,1}]}],[{2993592207484,[{101014122,1}]}],[{2993592207484,[{102064132,1}]}],[{2993592207484,[{103014112,1}]}],[{3238405341240,[{101024102,1}]}],[{3238405341240,[{101044122,1}]}],[{3238405341240,[{101104122,1}]}],[{3238405342078,[{101064112,1}]}],[{3238405342078,[{102044112,1}]}],[{3246995276529,[{101024102,1}]}],[{3246995276529,[{102044102,1}]}],[{3246995276529,[{103014102,1}]}],[{3027951944601,[{101024112,1}]}],[{3027951944601,[{101084112,1}]}],[{3027951944601,[{102064112,1}]}],[{3027951944601,[{103014102,1}]}],[{3036541878969,[{101014102,1}]}],[{3036541878969,[{101024102,1}]}],[{3036541878969,[{101084102,1}]}],[{3036541878969,[{102084112,1}]}],[{3036541878969,[{104014112,1}]}],[{3040836845953,[{103014122,1}]}],[{3040836846298,[{102104112,1}]}],[{3122441224549,[{101024112,1}]}],[{3122441224549,[{102024122,1}]}],[{3122441225143,[{101044122,1}]}],[{3126736191663,[{101024102,1}]}],[{3126736191663,[{101024112,1}]}],[{3126736191663,[{101044112,1}]}],[{3126736191663,[{101044122,1}]}],[{3126736191663,[{102014102,1}]}],[{3126736191663,[{102014122,1}]}],[{3126736191663,[{102024102,1}]}],[{3126736191663,[{102024122,1}]}],[{3126736191663,[{102084112,1}]}],[{3126736192359,[{102044112,1}]}],[{2942052598010,[{101014132,1}]}],[{2942052598010,[{101024122,1}]}],[{2942052598010,[{101044112,1}]}],[{2942052598010,[{101084122,1}]}],[{2942052598010,[{102014132,1}]}],[{2942052598010,[{102024132,1}]}],[{2942052598010,[{102064132,1}]}],[{2942052598010,[{102084132,1}]}],[{2942052598010,[{102104132,1}]}],[{2942052598010,[{103014122,1}]}],[{2942052598010,[{104014132,1}]}],[{2942052598774,[{101024112,1}]}],[{2942052598774,[{103014132,1}]}],[{2942052598774,[{104014112,1}]}],[{2942052599911,[{101084122,1}]}],[{2942052599911,[{102084132,1}]}],[{2946347565141,[{101044122,1}]}],[{2946347565141,[{101064122,1}]}],[{2946347565141,[{101084132,1}]}],[{2946347565141,[{102084122,1}]}],[{2946347565207,[{101064132,1}]}],[{2946347565207,[{101104122,1}]}],[{2946347565207,[{102044122,1}]}],[{2946347565207,[{102064122,1}]}],[{2946347565207,[{102084102,1}]}],[{2946347565282,[{102104112,1}]}],[{2950642532467,[{102024112,1}]}],[{2950642532475,[{101014112,1}]}],[{2950642532475,[{101064122,1}]}],[{2950642532475,[{101104122,1}]}],[{2950642532475,[{102024122,1}]}],[{2950642532475,[{102064122,1}]}],[{2950642532475,[{102084122,1}]}],[{2950642534348,[{102084112,1}]}],[{2950642534348,[{104014122,1}]}],[{2950642534357,[{101044122,1}]}],[{2950642534357,[{102084122,1}]}],[{3895535338560,[{102044092,1}]}],[{3088081485825,[{101064122,1}]}],[{3088081485825,[{104014102,1}]}],[{3088081486054,[{101014122,1}]}],[{3088081486054,[{103014122,1}]}],[{3092376453122,[{101064112,1}]}],[{3092376453309,[{101014122,1}]}],[{3092376453309,[{101024112,1}]}],[{3092376453309,[{101024122,1}]}],[{3092376453309,[{102024122,1}]}],[{3092376453309,[{102044112,1}]}],[{3092376453309,[{102064122,1}]}],[{3092376453309,[{102104122,1}]}],[{3092376453309,[{103014122,1}]}],[{3092376454030,[{101014122,1}]}],[{3092376454030,[{102044122,1}]}],[{3092376454159,[{102024102,1}]}],[{3788161155665,[{101024122,1}]}],[{3788161155665,[{102044112,1}]}],[{3792456122441,[{101044112,1}]}],[{3792456122441,[{102014102,1}]}],[{3792456122441,[{103014112,1}]}],[{3792456122441,[{104014112,1}]}],[{3792456122731,[{101104102,1}]}],[{2821793513739,[{101064102,1}]}],[{2821793513739,[{101084112,1}]}],[{2821793513863,[{102044112,1}]}],[{2821793514047,[{101084102,1}]}],[{2826088481054,[{101014112,1}]}],[{2826088481054,[{101024112,1}]}],[{2826088481054,[{101024122,1}]}],[{2826088481054,[{101084122,1}]}],[{2826088481054,[{102014102,1}]}],[{2826088481054,[{102014132,1}]}],[{2826088481054,[{102044102,1}]}],[{2826088481054,[{104014122,1}]}],[{2826088481182,[{101044122,1}]}],[{2826088481182,[{102014122,1}]}],[{2826088481182,[{102064122,1}]}],[{2826088481182,[{102084132,1}]}],[{2826088481295,[{101024122,1}]}],[{2826088481295,[{101104112,1}]}],[{2826088481575,[{101024122,1}]}],[{2826088481575,[{102014122,1}]}],[{2826088481575,[{104014122,1}]}],[{2834678416439,[{101024122,1}]}],[{2834678416439,[{101104122,1}]}],[{2834678416439,[{102084122,1}]}],[{2834678416523,[{102024102,1}]}],[{2843268349966,[{101024132,1}]}],[{2843268349966,[{101064122,1}]}],[{2843268349966,[{102024132,1}]}],[{2843268349966,[{102064122,1}]}],[{2843268349966,[{102064132,1}]}],[{2843268349966,[{102084132,1}]}],[{2843268349977,[{101044122,1}]}],[{2843268349977,[{102024122,1}]}],[{2787433775635,[{101044112,1}]}],[{2787433775635,[{101064122,1}]}],[{2787433775635,[{101084122,1}]}],[{2787433775635,[{101084132,1}]}],[{2787433775635,[{101104122,1}]}],[{2787433775635,[{101104132,1}]}],[{2787433775635,[{102014132,1}]}],[{2787433775635,[{102024122,1}]}],[{2787433775635,[{102044112,1}]}],[{2787433775635,[{102084122,1}]}],[{2787433775635,[{104014132,1}]}],[{2787433775667,[{102064132,1}]}],[{2508260901212,[{101014122,1}]}],[{2508260901212,[{101044122,1}]}],[{2508260901212,[{101104132,1}]}],[{2508260901665,[{101014122,1}]}],[{2508260901665,[{101024112,1}]}],[{2508260901665,[{102014122,1}]}],[{2508260901665,[{102014132,1}]}],[{2508260901665,[{102024112,1}]}],[{2508260901665,[{103014132,1}]}],[{2508260901665,[{104014132,1}]}],[{2508260901770,[{101084122,1}]}],[{2512555869053,[{102044142,1}]}],[{3199750635840,[{101084112,1}]}],[{3199750635840,[{101084122,1}]}],[{3199750635840,[{102014112,1}]}],[{3212635537989,[{101024122,1}]}],[{3212635537989,[{101044102,1}]}],[{3212635537989,[{101044112,1}]}],[{3212635537989,[{101104112,1}]}],[{3212635537989,[{102014122,1}]}],[{3212635537989,[{102044112,1}]}],[{3212635537989,[{102064112,1}]}],[{3212635538167,[{101064112,1}]}],[{3212635538167,[{102044122,1}]}],[{3212635538167,[{102104122,1}]}],[{2710124364570,[{101084122,1}]}],[{2710124364570,[{102024112,1}]}],[{2710124364782,[{101084132,1}]}],[{2714419331112,[{101024132,1}]}],[{2714419331112,[{101044122,1}]}],[{2714419331112,[{101064122,1}]}],[{2714419331112,[{101084122,1}]}],[{2714419331112,[{102044132,1}]}],[{2714419331112,[{102064132,1}]}],[{2714419331112,[{102084132,1}]}],[{2714419331112,[{103014122,1}]}],[{2714419331496,[{101024112,1}]}],[{2714419331496,[{101024132,1}]}],[{2714419331496,[{101044122,1}]}],[{2714419331496,[{101104122,1}]}],[{2714419331496,[{102014132,1}]}],[{2714419331496,[{104014132,1}]}],[{2714419331609,[{101044132,1}]}],[{2714419331609,[{102084122,1}]}],[{2714419332148,[{101014112,1}]}],[{2714419332148,[{101064122,1}]}],[{2714419332148,[{101104122,1}]}],[{2714419332148,[{101104132,1}]}],[{2714419332148,[{102044112,1}]}],[{2723009266261,[{101024132,1}]}],[{2723009266261,[{101064132,1}]}],[{2723009266261,[{101084122,1}]}],[{2723009266261,[{101104122,1}]}],[{2723009266261,[{102064122,1}]}],[{2723009266261,[{102104132,1}]}],[{2723009266261,[{104014122,1}]}],[{3277060046993,[{102104112,1}]}],[{3277060047656,[{101014112,1}]}],[{3277060047656,[{101024102,1}]}],[{3277060047656,[{101044122,1}]}],[{3277060047656,[{101044132,1}]}],[{3277060047656,[{104014112,1}]}],[{3281355014262,[{102014122,1}]}],[{3281355014262,[{102024112,1}]}],[{3281355014262,[{102064122,1}]}],[{3281355014460,[{104014102,1}]}],[{3281355014463,[{102024112,1}]}],[{3281355014463,[{102104112,1}]}],[{3281355014463,[{103014112,1}]}],[{3281355014558,[{101014132,1}]}],[{3281355014558,[{102024112,1}]}],[{3281355014558,[{102064122,1}]}],[{3281355014558,[{104014132,1}]}],[{3281355015135,[{101014122,1}]}],[{3281355015135,[{101044122,1}]}],[{3281355015135,[{102024102,1}]}],[{3281355015135,[{103014102,1}]}],[{3191160701385,[{101044112,1}]}],[{3191160701385,[{102084102,1}]}],[{3191160701385,[{104014102,1}]}],[{3805341025105,[{102104112,1}]}],[{3805341025133,[{101024112,1}]}],[{2667174691432,[{102084132,1}]}],[{2667174691432,[{104014132,1}]}],[{2671469659150,[{104014122,1}]}],[{2976412336163,[{102084122,1}]}],[{2976412336350,[{101014102,1}]}],[{2976412336350,[{101024122,1}]}],[{2976412336350,[{101064122,1}]}],[{2976412336350,[{102044122,1}]}],[{2976412336604,[{102064132,1}]}],[{2976412336604,[{104014122,1}]}],[{2976412336644,[{102044112,1}]}],[{2976412337004,[{101024122,1}]}],[{2976412337004,[{101044112,1}]}],[{2976412337004,[{101064122,1}]}],[{2976412337004,[{101084112,1}]}],[{2976412337004,[{101084122,1}]}],[{2976412337004,[{101104122,1}]}],[{2976412337004,[{102014132,1}]}],[{2976412337004,[{102064112,1}]}],[{2976412337004,[{102084112,1}]}],[{2976412337968,[{101014112,1}]}],[{2976412337968,[{102024112,1}]}],[{2976412337968,[{102024122,1}]}],[{2976412337968,[{102064122,1}]}],[{2976412337968,[{102084132,1}]}],[{2976412338366,[{101014112,1}]}],[{2976412338366,[{101044102,1}]}],[{2976412338366,[{101044122,1}]}],[{2976412338366,[{101084122,1}]}],[{2976412338366,[{102014112,1}]}],[{2976412338366,[{102024102,1}]}],[{2976412338366,[{102044102,1}]}],[{2976412338366,[{102044112,1}]}],[{2976412338366,[{102044132,1}]}],[{2976412338366,[{102064102,1}]}],[{2976412338366,[{102064112,1}]}],[{2976412338366,[{102084112,1}]}],[{2976412338366,[{102084122,1}]}],[{2976412338366,[{103014112,1}]}],[{2980707303777,[{101084112,1}]}],[{2980707303777,[{103014102,1}]}],[{2980707305091,[{103014122,1}]}],[{2967822402677,[{101024112,1}]}],[{2967822403230,[{101014112,1}]}],[{2972117368991,[{101024112,1}]}],[{2972117368991,[{101064102,1}]}],[{2972117368991,[{101104112,1}]}],[{2972117368991,[{102014102,1}]}],[{2972117369656,[{101024102,1}]}],[{2972117369656,[{101044112,1}]}],[{2972117369656,[{101104112,1}]}],[{2972117369656,[{102014102,1}]}],[{2972117369656,[{102014122,1}]}],[{2972117369656,[{102084122,1}]}],[{2972117370027,[{101014102,1}]}],[{2972117370027,[{101104102,1}]}],[{2972117370027,[{102014112,1}]}],[{2972117370027,[{102024102,1}]}],[{2972117370027,[{102044102,1}]}],[{2972117370027,[{104014102,1}]}],[{2972117370316,[{101024112,1}]}],[{2972117370316,[{101044102,1}]}],[{2972117370316,[{101064122,1}]}],[{2972117370316,[{101084112,1}]}],[{2972117370316,[{102024122,1}]}],[{2972117370316,[{102044102,1}]}],[{2972117370316,[{102044112,1}]}],[{2972117370316,[{102084102,1}]}],[{2972117370316,[{102104102,1}]}],[{2972117370316,[{104014112,1}]}],[{2972117370316,[{104014122,1}]}],[{2972117370789,[{101064122,1}]}],[{2972117370789,[{102014132,1}]}],[{2796023709833,[{101014122,1}]}],[{2796023709833,[{103014112,1}]}],[{2796023710650,[{101014142,1}]}],[{2804613644410,[{101014122,1}]}],[{2804613644410,[{101014132,1}]}],[{2804613644410,[{101024122,1}]}],[{2804613644410,[{101044142,1}]}],[{2804613644410,[{102064132,1}]}],[{2804613644410,[{102064142,1}]}],[{2804613644410,[{103014132,1}]}],[{2804613644410,[{103014142,1}]}],[{2804613644805,[{101024122,1}]}],[{2804613644805,[{101024132,1}]}],[{2804613644805,[{101044142,1}]}],[{2804613644805,[{101064132,1}]}],[{2804613644805,[{101084112,1}]}],[{2804613644805,[{102014112,1}]}],[{2804613644805,[{102024122,1}]}],[{2804613644805,[{102024142,1}]}],[{2804613644805,[{102064122,1}]}],[{2804613644805,[{102084132,1}]}],[{2804613644805,[{102104132,1}]}],[{2804613644805,[{104014122,1}]}],[{2804613644996,[{101064122,1}]}],[{3062311682108,[{101014122,1}]}],[{3062311682108,[{102014112,1}]}],[{3062311682108,[{102084112,1}]}],[{3062311682108,[{104014122,1}]}],[{3062311682108,[{104014132,1}]}],[{3062311682256,[{101024112,1}]}],[{3062311682256,[{101064132,1}]}],[{3062311682256,[{102044112,1}]}],[{3062311682256,[{102064112,1}]}],[{3062311682256,[{103014112,1}]}],[{3062311682997,[{102044102,1}]}],[{3066606649360,[{102014112,1}]}],[{3066606649360,[{102044112,1}]}],[{3066606649360,[{104014112,1}]}],[{3066606650224,[{101014132,1}]}],[{3066606650224,[{102014122,1}]}],[{3066606650224,[{102024132,1}]}],[{3066606650224,[{102044112,1}]}],[{3066606650224,[{102044122,1}]}],[{3066606650224,[{102064132,1}]}],[{3066606650224,[{102104122,1}]}],[{3070901617449,[{102064122,1}]}],[{3070901617449,[{102084122,1}]}],[{3075196584215,[{102014122,1}]}],[{3075196584918,[{102044122,1}]}],[{2568390443130,[{102104122,1}]}],[{2568390443461,[{101014132,1}]}],[{2568390443461,[{102064132,1}]}],[{2568390443704,[{103014122,1}]}],[{2568390443848,[{102024132,1}]}],[{2568390443990,[{103014122,1}]}],[{2568390443998,[{101044132,1}]}],[{2576980377994,[{102044122,1}]}],[{2576980377994,[{102044132,1}]}],[{2576980377994,[{102104132,1}]}],[{2585570312299,[{101014132,1}]}],[{2585570312299,[{101084132,1}]}],[{2585570312299,[{101104132,1}]}],[{2585570312364,[{101044122,1}]}],[{2585570312364,[{102104122,1}]}],[{2585570312364,[{102104132,1}]}],[{2585570312364,[{103014122,1}]}],[{2585570312364,[{104014122,1}]}],[{2585570312611,[{101014132,1}]}],[{2585570312611,[{101044122,1}]}],[{2585570312611,[{101084122,1}]}],[{2585570312611,[{102024132,1}]}],[{2585570312611,[{102104112,1}]}],[{2585570312611,[{102104132,1}]}],[{2585570312611,[{104014122,1}]}],[{2589865279792,[{101024132,1}]}],[{2589865279792,[{101064112,1}]}],[{2589865279792,[{102014142,1}]}],[{2589865279792,[{102084122,1}]}],[{2589865279792,[{102104112,1}]}],[{2589865279792,[{103014122,1}]}],[{2589865279792,[{103014132,1}]}],[{3002182139943,[{103014102,1}]}],[{3006477107222,[{101014112,1}]}],[{3006477107222,[{101044102,1}]}],[{3006477107222,[{102014112,1}]}],[{3006477107222,[{102024112,1}]}],[{3006477107222,[{102024122,1}]}],[{3006477107222,[{102044102,1}]}],[{3006477107222,[{102084122,1}]}],[{3135326126829,[{101014112,1}]}],[{3135326126829,[{101024102,1}]}],[{3135326126829,[{101044102,1}]}],[{3135326126829,[{101104112,1}]}],[{3135326126829,[{102084112,1}]}],[{3135326126829,[{103014112,1}]}],[{3135326126829,[{104014102,1}]}],[{3143916060780,[{101044112,1}]}],[{3143916060780,[{101104122,1}]}],[{3143916060780,[{102014112,1}]}],[{3143916060780,[{102024112,1}]}],[{3143916060780,[{102084122,1}]}],[{3255585211019,[{101014112,1}]}],[{3255585211019,[{101064122,1}]}],[{3259880178565,[{102014122,1}]}],[{3264175145003,[{102014122,1}]}],[{3264175145003,[{102064112,1}]}],[{3268470113203,[{101024122,1}]}],[{3268470113203,[{101064122,1}]}],[{3268470113203,[{102064122,1}]}],[{3268470113203,[{103014122,1}]}],[{3272765079882,[{101014122,1}]}],[{3272765079882,[{101024102,1}]}],[{3272765079882,[{101084112,1}]}],[{3272765079882,[{103014112,1}]}],[{3272765079882,[{104014112,1}]}],[{3272765080397,[{101084112,1}]}],[{2813203578905,[{101104112,1}]}],[{2813203578905,[{102014122,1}]}],[{2813203579372,[{102084102,1}]}],[{2813203580365,[{101024112,1}]}],[{2813203580365,[{101084112,1}]}],[{2813203580365,[{102064112,1}]}],[{2813203580365,[{102084112,1}]}],[{2830383448171,[{101104112,1}]}],[{2838973383288,[{101024112,1}]}],[{2838973383288,[{101044122,1}]}],[{2838973383288,[{101084112,1}]}],[{2838973383288,[{102014132,1}]}],[{2838973383288,[{102024122,1}]}],[{2838973383288,[{102064102,1}]}],[{2838973383288,[{102064112,1}]}],[{2838973383288,[{102084102,1}]}],[{2838973383288,[{102084122,1}]}],[{2838973383288,[{102084132,1}]}],[{2838973383288,[{102104122,1}]}],[{2838973383288,[{104014132,1}]}],[{2838973383473,[{102104122,1}]}],[{2838973383473,[{103014122,1}]}],[{3045131812948,[{101014122,1}]}],[{3045131812948,[{101024102,1}]}],[{3045131812948,[{101084102,1}]}],[{3045131812948,[{102024122,1}]}],[{3045131812948,[{102084122,1}]}],[{3045131812948,[{102104122,1}]}],[{3045131813042,[{102014102,1}]}],[{3049426780270,[{101064122,1}]}],[{3049426780270,[{101104122,1}]}],[{3049426780270,[{102084102,1}]}],[{3049426780270,[{102104122,1}]}],[{3049426780270,[{104014122,1}]}],[{3049426780355,[{102024112,1}]}],[{3049426780355,[{102044122,1}]}],[{3049426780355,[{102084112,1}]}],[{3049426780370,[{101064112,1}]}],[{3049426780370,[{102014122,1}]}],[{3049426780825,[{101014102,1}]}],[{3049426780825,[{101024102,1}]}],[{3049426780825,[{101044112,1}]}],[{3049426780825,[{101064112,1}]}],[{3049426780825,[{101064122,1}]}],[{3049426780825,[{101084102,1}]}],[{3049426780825,[{101104112,1}]}],[{3049426780825,[{102044102,1}]}],[{3049426780825,[{102064102,1}]}],[{3049426780825,[{102084122,1}]}],[{3049426780825,[{102104112,1}]}],[{3049426780825,[{103014112,1}]}],[{3049426780831,[{101024122,1}]}],[{2886218023079,[{102044102,1}]}],[{2886218023079,[{103014102,1}]}],[{2890512990526,[{101024112,1}]}],[{2890512990526,[{101024122,1}]}],[{2890512990526,[{101044112,1}]}],[{2890512990526,[{102014122,1}]}],[{2890512990526,[{102024122,1}]}],[{2890512990526,[{102064112,1}]}],[{2890512990526,[{102104122,1}]}],[{2890512990526,[{103014122,1}]}],[{2899102926946,[{101024122,1}]}],[{2907692859398,[{101044102,1}]}],[{2907692859398,[{101044122,1}]}],[{2907692859398,[{101084112,1}]}],[{2907692859398,[{101084122,1}]}],[{2907692859398,[{102044112,1}]}],[{2907692859398,[{102084112,1}]}],[{2907692860908,[{101014122,1}]}],[{2907692860908,[{101044112,1}]}],[{2907692861038,[{101014112,1}]}],[{2907692861038,[{101104112,1}]}],[{2907692861038,[{102024102,1}]}],[{2907692861038,[{102084112,1}]}],[{2907692861038,[{103014122,1}]}],[{2907692861038,[{104014112,1}]}],[{2907692861199,[{101044122,1}]}],[{2907692861199,[{102104102,1}]}],[{2907692861313,[{101014122,1}]}],[{2907692861313,[{101044112,1}]}],[{2907692861313,[{101064112,1}]}],[{2907692861313,[{101104112,1}]}],[{2907692861313,[{102044102,1}]}],[{2907692861313,[{102044112,1}]}],[{2907692861313,[{102064122,1}]}],[{2907692861313,[{102084112,1}]}],[{2907692861313,[{102104102,1}]}],[{2907692861313,[{104014112,1}]}],[{2907692861467,[{101014112,1}]}],[{2907692861467,[{102104122,1}]}],[{2907692861467,[{103014122,1}]}],[{2907692861622,[{104014112,1}]}],[{2911987826761,[{101064122,1}]}],[{2911987826761,[{103014132,1}]}],[{2911987827166,[{101084132,1}]}],[{2911987827166,[{101104112,1}]}],[{2911987827166,[{102084122,1}]}],[{2911987827431,[{102024122,1}]}],[{2911987827449,[{101024132,1}]}],[{2911987827449,[{102084132,1}]}],[{2911987829142,[{102064112,1}]}],[{3341484556568,[{102044112,1}]}],[{3161095929869,[{102014122,1}]}],[{3161095929869,[{103014122,1}]}],[{3161095930535,[{102014122,1}]}],[{3161095930535,[{102064112,1}]}],[{3161095930535,[{102084112,1}]}],[{3169685865502,[{101084122,1}]}],[{3173980831833,[{101084102,1}]}],[{3173980831911,[{102084112,1}]}],[{3173980832167,[{102064102,1}]}],[{3173980832448,[{101024112,1}]}],[{3173980832448,[{102104122,1}]}]
    ],
    [begin
%%         timer:sleep(200),
         [gm_cost_goods(RoleId, GoodId, Num)  || {GoodId, Num} <- GoodList]
     end ||[{RoleId, GoodList}] <- List].



gm_cost_goods(RoleId, GoodId, Num) when is_integer(RoleId) ->
    if
        Num > 0 ->
            Pid = misc:get_player_process(RoleId),
            case misc:is_process_alive(Pid) of
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, gm_cost_goods, [GoodId, Num]);
                _ ->
                    Sql1 = io_lib:format(<<"select   gid  from  goods_high   where  goods_id =  ~p   and (location = 4  or   location = 5 ) and pid = ~p ">>, [GoodId, RoleId]),
                    List = db:get_all(Sql1),
                    List2 = [Gid || [Gid]<-List],
                    Length = length(List2),
                    if
                        Length =< 0 ->
                            skip;
                        true ->
                            LastNum = min(Num, Length),
                            List3 = lists:sublist(List2, LastNum),
                            [begin
                                 %% DELETE from goods_low where gid = ~p
                                 Sql2 = io_lib:format(<<"DELETE from goods_low where gid = ~p">>, [Gid]),
                                 %% DELETE from goods_high where gid = ~p
                                 Sql3 = io_lib:format(<<"DELETE from goods_high where gid = ~p">>, [Gid]),
                                 %% DELETE from goods where id  = ~p
                                 Sql4 = io_lib:format(<<"DELETE from goods where id  = ~p">>, [Gid]),
                                 db:execute(Sql2),
                                 db:execute(Sql3),
                                 db:execute(Sql4)
                             end
                                || Gid <- List3]
                    end
            end;
        true ->
            skip
    end;


gm_cost_goods(Ps, GoodId, Num) ->
    case  lib_goods_api:get_goods_num(Ps, [GoodId]) of
        [{GoodId, MaxNum} | _] ->
            LastNum = min(Num, MaxNum),
            case lib_goods_api:cost_object_list_with_check(Ps, [{?TYPE_GOODS, GoodId, LastNum}], gm, "gm") of
                {true, NewPs} ->
                    {ok, NewPs};
                {false, _ErrorCode, _} ->
                    {ok, Ps}
            end;
        _ ->
            {ok, Ps}
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------


gm_cost_goods2() ->
    List =
        [[{4294967297,[{101021150,20}]}],[{3126736191663,[{103014112,5}]}],[{2787433775635,[{102104132,5}]}],[{2714419332148,[{103014122,5}]}],[{2804613644410,[{101104142,5}]}],[{3255585211019,[{102024122,5}]}],[{2753074037258,[{101014132,4}]}],[{2963527435810,[{101064122,4}]}],[{2993592205531,[{103014122,4}]}],[{3126736191663,[{101014122,4}]}],[{2826088481575,[{101104122,4}]}],[{2843268349966,[{101014132,4}]}],[{2976412338366,[{102064122,4}]}],[{2804613644410,[{101084142,4}]}],[{2804613644410,[{101104132,4}]}],[{2804613644410,[{102024142,4}]}],[{2804613644410,[{102044142,4}]}],[{2804613644410,[{102104142,4}]}],[{2589865279792,[{102104132,4}]}],[{2838973383288,[{101014122,4}]}],[{2838973383288,[{102014122,4}]}],[{2847563317679,[{101024122,3}]}],[{2847563317679,[{102084122,3}]}],[{2705829396674,[{101024132,3}]}],[{2753074037258,[{101104132,3}]}],[{2753074037258,[{102064132,3}]}],[{2963527435810,[{101014112,3}]}],[{2572685410657,[{101014112,3}]}],[{2744484102374,[{101024122,3}]}],[{2559800508670,[{102044132,3}]}],[{2559800508670,[{102104132,3}]}],[{3148211028035,[{101024102,3}]}],[{2993592205531,[{102084132,3}]}],[{3027951944601,[{101104112,3}]}],[{3126736191663,[{101024122,3}]}],[{2946347565207,[{102084112,3}]}],[{2950642534348,[{101084122,3}]}],[{2826088481054,[{102014112,3}]}],[{2826088481054,[{102044112,3}]}],[{2826088481575,[{102044122,3}]}],[{2843268349966,[{101064132,3}]}],[{2843268349966,[{102044132,3}]}],[{2843268349966,[{103014132,3}]}],[{2787433775635,[{101064132,3}]}],[{2508260901212,[{102084132,3}]}],[{2508260901665,[{101014132,3}]}],[{2508260901665,[{101104122,3}]}],[{2508260901665,[{102064132,3}]}],[{3199750635840,[{104014122,3}]}],[{3212635538167,[{102014112,3}]}],[{3212635538167,[{102014122,3}]}],[{3281355015135,[{102024122,3}]}],[{2972117368991,[{101104102,3}]}],[{2972117370316,[{102044122,3}]}],[{2972117370316,[{102064112,3}]}],[{2804613644410,[{104014142,3}]}],[{2804613644805,[{102044122,3}]}],[{2804613644805,[{102064132,3}]}],[{2804613644805,[{102104142,3}]}],[{3066606650224,[{102064112,3}]}],[{2576980377994,[{102014132,3}]}],[{2576980377994,[{102024132,3}]}],[{2589865279792,[{102024132,3}]}],[{3135326126829,[{101104102,3}]}],[{3143916060780,[{101084122,3}]}],[{2838973383288,[{101104122,3}]}],[{2838973383288,[{102044122,3}]}],[{2838973383288,[{102104112,3}]}],[{2838973383288,[{103014102,3}]}],[{2838973383288,[{103014122,3}]}],[{3045131812948,[{104014122,3}]}],[{2907692861038,[{102044122,3}]}],[{2907692861467,[{102024112,3}]}],[{2911987826761,[{102014112,3}]}],[{2911987826761,[{102104112,3}]}],[{3216930505589,[{101084102,2}]}],[{3216930505589,[{102024122,2}]}],[{3216930505589,[{103014122,2}]}],[{2847563317679,[{101084122,2}]}],[{2847563317679,[{101104122,2}]}],[{2847563317679,[{102014102,2}]}],[{2847563317679,[{102014112,2}]}],[{2847563317679,[{102024112,2}]}],[{2847563317679,[{102024122,2}]}],[{2847563317679,[{102044112,2}]}],[{2847563317679,[{102044122,2}]}],[{2847563317679,[{102104122,2}]}],[{2847563317679,[{103014122,2}]}],[{2856153252726,[{102024102,2}]}],[{2856153252726,[{102084112,2}]}],[{2684354560031,[{102044112,2}]}],[{2684354560132,[{103014132,2}]}],[{2705829396640,[{101014132,2}]}],[{2705829396674,[{102024132,2}]}],[{2705829396674,[{104014122,2}]}],[{2705829396674,[{104014132,2}]}],[{2753074037258,[{101014122,2}]}],[{2753074037258,[{101064142,2}]}],[{2753074037258,[{101084122,2}]}],[{2753074037258,[{102014132,2}]}],[{2753074037337,[{101014122,2}]}],[{2753074037337,[{101044132,2}]}],[{2753074037337,[{102084132,2}]}],[{2753074037625,[{102014122,2}]}],[{2753074037625,[{102024112,2}]}],[{2753074037625,[{102084142,2}]}],[{2753074037625,[{102104122,2}]}],[{2963527434396,[{102064122,2}]}],[{2963527434396,[{102104122,2}]}],[{2727304233831,[{102024122,2}]}],[{2740189135842,[{102024132,2}]}],[{2564095475799,[{102024122,2}]}],[{2564095475799,[{102084122,2}]}],[{2581275344929,[{101044112,2}]}],[{2581275344929,[{101104122,2}]}],[{2744484102374,[{101084122,2}]}],[{2744484102374,[{102044122,2}]}],[{2744484102374,[{102064112,2}]}],[{2559800508529,[{101064122,2}]}],[{2559800508529,[{102104122,2}]}],[{2559800508670,[{101024112,2}]}],[{2559800508670,[{101064112,2}]}],[{2559800508670,[{104014132,2}]}],[{2559800509078,[{101024132,2}]}],[{2559800509078,[{102084112,2}]}],[{2559800509078,[{102084132,2}]}],[{2559800509522,[{102104112,2}]}],[{2495375999274,[{101014142,2}]}],[{2495375999274,[{101044142,2}]}],[{2495375999994,[{102064142,2}]}],[{3148211028035,[{101014112,2}]}],[{3148211028035,[{102104112,2}]}],[{3148211028035,[{103014112,2}]}],[{3148211028035,[{104014102,2}]}],[{2993592205531,[{101014122,2}]}],[{2993592205531,[{101084122,2}]}],[{2993592205531,[{102084122,2}]}],[{2993592207450,[{102084132,2}]}],[{3238405341240,[{101064112,2}]}],[{3027951944490,[{104014112,2}]}],[{3036541878969,[{101104102,2}]}],[{3036541878969,[{104014102,2}]}],[{3040836845835,[{102064112,2}]}],[{3122441225143,[{102044122,2}]}],[{3122441225143,[{104014122,2}]}],[{3126736191663,[{101104112,2}]}],[{3126736191663,[{102064112,2}]}],[{3126736191663,[{104014102,2}]}],[{2942052598010,[{101014122,2}]}],[{2942052598010,[{101024132,2}]}],[{2942052598010,[{101044132,2}]}],[{2942052598010,[{101064132,2}]}],[{2942052598010,[{101084132,2}]}],[{2942052598010,[{101104132,2}]}],[{2942052598774,[{101024122,2}]}],[{2942052598774,[{101044112,2}]}],[{2946347565207,[{101104112,2}]}],[{2950642532475,[{102104122,2}]}],[{3092376453309,[{101064122,2}]}],[{3092376454030,[{101104122,2}]}],[{3092376454030,[{102064132,2}]}],[{2821793513739,[{102024122,2}]}],[{2821793514840,[{103014112,2}]}],[{2826088481054,[{102064122,2}]}],[{2826088481295,[{102064132,2}]}],[{2826088481575,[{101014122,2}]}],[{2826088481575,[{102024122,2}]}],[{2826088481575,[{102064122,2}]}],[{2826088481575,[{102084122,2}]}],[{2834678416439,[{102024122,2}]}],[{2787433775247,[{102014122,2}]}],[{2787433775635,[{101024132,2}]}],[{2787433775635,[{101044132,2}]}],[{2787433775635,[{102024132,2}]}],[{2787433775635,[{103014132,2}]}],[{2508260901453,[{102084122,2}]}],[{2714419331112,[{101024122,2}]}],[{2714419331112,[{101084112,2}]}],[{2714419331112,[{101104122,2}]}],[{2714419331112,[{102084122,2}]}],[{2714419331496,[{101014122,2}]}],[{2714419331496,[{101084122,2}]}],[{2714419331496,[{102014122,2}]}],[{2714419331496,[{102024132,2}]}],[{2714419331496,[{102064122,2}]}],[{2714419331496,[{102084132,2}]}],[{2714419331496,[{104014122,2}]}],[{2714419331609,[{101104112,2}]}],[{2714419331609,[{102044122,2}]}],[{2714419332148,[{103014132,2}]}],[{3277060047656,[{102024112,2}]}],[{3281355014460,[{102064102,2}]}],[{3281355015135,[{101014112,2}]}],[{3191160701385,[{102044112,2}]}],[{2671469659150,[{101024132,2}]}],[{2976412336350,[{102014122,2}]}],[{2976412336350,[{102104112,2}]}],[{2976412337968,[{101084112,2}]}],[{2976412337968,[{102014122,2}]}],[{2976412338366,[{101064132,2}]}],[{2976412338366,[{102024112,2}]}],[{2976412338366,[{102024122,2}]}],[{2976412338366,[{102104122,2}]}],[{2976412338366,[{104014132,2}]}],[{2972117369656,[{102064112,2}]}],[{2972117370027,[{101044102,2}]}],[{2972117370316,[{101024122,2}]}],[{2972117370316,[{102014102,2}]}],[{2972117370316,[{102104122,2}]}],[{2972117370316,[{103014102,2}]}],[{2972117370789,[{103014122,2}]}],[{2796023709833,[{101104122,2}]}],[{2796023709833,[{102044112,2}]}],[{2804613644410,[{101014142,2}]}],[{2804613644410,[{101024142,2}]}],[{2804613644410,[{102014122,2}]}],[{2804613644410,[{102024132,2}]}],[{2804613644805,[{101014132,2}]}],[{2804613644805,[{101044122,2}]}],[{2804613644805,[{101084122,2}]}],[{2804613644805,[{102044132,2}]}],[{3062311682108,[{102044122,2}]}],[{3062311682108,[{102104122,2}]}],[{3062311682256,[{101014122,2}]}],[{3066606649360,[{101024112,2}]}],[{3066606650224,[{101024112,2}]}],[{3066606650224,[{102104132,2}]}],[{2568390443998,[{102014132,2}]}],[{2576980377994,[{101014122,2}]}],[{2576980377994,[{103014132,2}]}],[{2585570312299,[{101024132,2}]}],[{2585570312364,[{101024132,2}]}],[{2585570312364,[{102024132,2}]}],[{2585570312611,[{102014122,2}]}],[{2589865279792,[{101064142,2}]}],[{2589865279792,[{103014142,2}]}],[{3006477107222,[{101084102,2}]}],[{3135326126829,[{101084112,2}]}],[{3135326126829,[{102064112,2}]}],[{3135326126829,[{103014102,2}]}],[{3268470112653,[{101014112,2}]}],[{3268470113203,[{102014122,2}]}],[{3272765080397,[{101104112,2}]}],[{2813203580365,[{102044112,2}]}],[{2838973383288,[{101024102,2}]}],[{2838973383288,[{101024122,2}]}],[{2838973383288,[{101064112,2}]}],[{2838973383288,[{101064122,2}]}],[{2838973383288,[{101104112,2}]}],[{2838973383288,[{102014102,2}]}],[{2838973383288,[{102044112,2}]}],[{2838973383288,[{102064122,2}]}],[{2838973383288,[{102084112,2}]}],[{2838973383288,[{102104102,2}]}],[{2838973383288,[{104014122,2}]}],[{2838973383473,[{102064122,2}]}],[{3045131812948,[{102084112,2}]}],[{3049426780825,[{102024102,2}]}],[{2886218023079,[{101064112,2}]}],[{2890512990526,[{101014112,2}]}],[{2890512990526,[{104014112,2}]}],[{2907692861038,[{101024102,2}]}],[{2907692861038,[{101064122,2}]}],[{2907692861038,[{101084122,2}]}],[{2907692861038,[{102104122,2}]}],[{2907692861038,[{103014112,2}]}],[{2907692861313,[{101014112,2}]}],[{2907692861313,[{101024112,2}]}],[{2907692861467,[{103014102,2}]}],[{2911987826761,[{101044122,2}]}],[{2911987827166,[{101044132,2}]}],[{2911987827166,[{101064132,2}]}],[{2911987827166,[{102014132,2}]}],[{3161095930535,[{101064112,2}]}],[{3161095930535,[{104014112,2}]}],[{3173980832167,[{101104112,2}]}],[{3216930505039,[{101044122,1}]}],[{3216930505589,[{101014122,1}]}],[{3216930505589,[{101024122,1}]}],[{3216930505589,[{101064112,1}]}],[{3216930505589,[{102064122,1}]}],[{2954937499686,[{102064122,1}]}],[{2847563317325,[{102014102,1}]}],[{2847563317369,[{101104122,1}]}],[{2847563317679,[{101064112,1}]}],[{2847563317679,[{101104102,1}]}],[{2847563317679,[{101104112,1}]}],[{2847563317679,[{102014122,1}]}],[{2847563317679,[{102064122,1}]}],[{2847563317679,[{102084112,1}]}],[{2847563317679,[{102104102,1}]}],[{2847563317679,[{103014102,1}]}],[{2856153252726,[{101014102,1}]}],[{2856153252726,[{101024102,1}]}],[{2856153252726,[{101104112,1}]}],[{2856153252726,[{102014112,1}]}],[{2856153252726,[{102104102,1}]}],[{2684354560031,[{101024112,1}]}],[{2684354560031,[{101044122,1}]}],[{2684354560031,[{101064112,1}]}],[{2684354560031,[{101064122,1}]}],[{2684354560031,[{101084112,1}]}],[{2684354560031,[{102044122,1}]}],[{2684354560031,[{104014112,1}]}],[{2684354560132,[{101084122,1}]}],[{2684354560132,[{102014132,1}]}],[{2684354560132,[{102024122,1}]}],[{2684354560132,[{102084122,1}]}],[{2705829396640,[{102024132,1}]}],[{2705829396640,[{102104132,1}]}],[{2705829396674,[{103014142,1}]}],[{3015067041923,[{102084132,1}]}],[{2753074037258,[{101014142,1}]}],[{2753074037258,[{101024142,1}]}],[{2753074037258,[{101084132,1}]}],[{2753074037258,[{101084142,1}]}],[{2753074037258,[{101104142,1}]}],[{2753074037258,[{102014142,1}]}],[{2753074037258,[{102024112,1}]}],[{2753074037258,[{102064122,1}]}],[{2753074037258,[{102104142,1}]}],[{2753074037258,[{104014142,1}]}],[{2753074037337,[{101024132,1}]}],[{2753074037337,[{101064112,1}]}],[{2753074037337,[{101064132,1}]}],[{2753074037337,[{101064142,1}]}],[{2753074037337,[{101104122,1}]}],[{2753074037337,[{101104132,1}]}],[{2753074037337,[{102014122,1}]}],[{2753074037337,[{102024112,1}]}],[{2753074037337,[{102044122,1}]}],[{2753074037337,[{102044142,1}]}],[{2753074037337,[{102084112,1}]}],[{2753074037337,[{102104142,1}]}],[{2753074037337,[{103014132,1}]}],[{2753074037625,[{101044122,1}]}],[{2753074037625,[{101064142,1}]}],[{2753074037625,[{102044132,1}]}],[{2753074037625,[{102084132,1}]}],[{2753074037625,[{102104112,1}]}],[{2753074037625,[{102104142,1}]}],[{2753074037625,[{103014122,1}]}],[{2753074037625,[{104014132,1}]}],[{2753074037707,[{102044122,1}]}],[{2757369004507,[{102014112,1}]}],[{2761663972161,[{102064132,1}]}],[{2765958938641,[{101104112,1}]}],[{2765958939504,[{102014132,1}]}],[{2963527434396,[{101064122,1}]}],[{2963527434396,[{101104122,1}]}],[{2963527434396,[{102024122,1}]}],[{2963527435454,[{101044102,1}]}],[{2963527435454,[{101084122,1}]}],[{2963527435454,[{104014122,1}]}],[{2963527435810,[{101014132,1}]}],[{2963527435810,[{102024122,1}]}],[{2963527435810,[{102104122,1}]}],[{2727304233311,[{101014132,1}]}],[{2727304233311,[{101104132,1}]}],[{2727304233311,[{101104142,1}]}],[{2727304233311,[{102014132,1}]}],[{2727304233311,[{102104142,1}]}],[{2727304233831,[{101064112,1}]}],[{2727304233831,[{101064122,1}]}],[{2727304233831,[{101084122,1}]}],[{2727304233831,[{102084122,1}]}],[{2727304233831,[{103014112,1}]}],[{2727304233926,[{101064132,1}]}],[{2731599200326,[{101014112,1}]}],[{2731599200326,[{102064112,1}]}],[{2731599200326,[{102084122,1}]}],[{2731599201223,[{102064112,1}]}],[{2731599201223,[{104014122,1}]}],[{2735894167905,[{102064122,1}]}],[{2740189134870,[{102014112,1}]}],[{2740189135736,[{101024122,1}]}],[{2740189135736,[{102104132,1}]}],[{2740189135842,[{101024132,1}]}],[{2740189135842,[{101084122,1}]}],[{2740189135842,[{103014132,1}]}],[{2564095475799,[{101014112,1}]}],[{2564095475799,[{101104112,1}]}],[{2564095475799,[{101104122,1}]}],[{2564095475799,[{102024132,1}]}],[{2564095475799,[{102064122,1}]}],[{2564095475799,[{103014112,1}]}],[{2564095475799,[{104014112,1}]}],[{2572685410449,[{102024122,1}]}],[{2572685410657,[{101014122,1}]}],[{2581275344929,[{101064122,1}]}],[{2581275344929,[{102014112,1}]}],[{2581275344929,[{102024122,1}]}],[{2581275345683,[{101024122,1}]}],[{2744484102374,[{102014122,1}]}],[{2770253906902,[{101024112,1}]}],[{2770253906902,[{101044112,1}]}],[{2559800508529,[{101044132,1}]}],[{2559800508529,[{101084122,1}]}],[{2559800508529,[{102044122,1}]}],[{2559800508670,[{101084112,1}]}],[{2559800508670,[{101084132,1}]}],[{2559800508670,[{101104122,1}]}],[{2559800508670,[{102064132,1}]}],[{2559800508670,[{102084142,1}]}],[{2559800508670,[{103014132,1}]}],[{2559800509078,[{101064132,1}]}],[{2559800509078,[{101084132,1}]}],[{2559800509078,[{102084122,1}]}],[{2559800509390,[{101024132,1}]}],[{2559800509390,[{101064122,1}]}],[{2559800509390,[{101104122,1}]}],[{2559800509390,[{102044112,1}]}],[{2559800509390,[{102064122,1}]}],[{2559800509390,[{104014112,1}]}],[{2559800509522,[{102024112,1}]}],[{2559800509522,[{102024122,1}]}],[{2495375999103,[{103014142,1}]}],[{2495375999274,[{101064132,1}]}],[{2495375999274,[{102014142,1}]}],[{2495375999274,[{102024132,1}]}],[{2495375999274,[{102044142,1}]}],[{2495376001388,[{101044122,1}]}],[{2495376001388,[{102014132,1}]}],[{2495376001388,[{102024142,1}]}],[{2495376001388,[{104014142,1}]}],[{2503965934098,[{101104122,1}]}],[{2503965934553,[{101024132,1}]}],[{2503965934553,[{102064122,1}]}],[{2503965934553,[{104014112,1}]}],[{2503965934620,[{102044122,1}]}],[{3148211028028,[{101064112,1}]}],[{3148211028035,[{101024112,1}]}],[{3148211028035,[{101044112,1}]}],[{3148211028035,[{102084102,1}]}],[{3148211028035,[{103014122,1}]}],[{3148211028219,[{101064112,1}]}],[{3148211028219,[{102104122,1}]}],[{3148211028256,[{101044102,1}]}],[{3148211028256,[{102064112,1}]}],[{3148211028256,[{103014112,1}]}],[{3148211028943,[{102024112,1}]}],[{3148211028961,[{101104112,1}]}],[{3148211028961,[{102014112,1}]}],[{3148211028961,[{102044112,1}]}],[{3156800963437,[{101044102,1}]}],[{3156800963437,[{102044112,1}]}],[{3156800963437,[{102084132,1}]}],[{3813930958968,[{101014092,1}]}],[{2529735737476,[{104014122,1}]}],[{2534030704732,[{101014142,1}]}],[{2534030704798,[{101024132,1}]}],[{2534030704798,[{101104132,1}]}],[{2534030704798,[{102024132,1}]}],[{2534030704798,[{102044122,1}]}],[{2534030704798,[{102064132,1}]}],[{2993592205531,[{101024122,1}]}],[{2993592205531,[{101104112,1}]}],[{2993592205531,[{101104122,1}]}],[{2993592205531,[{102024112,1}]}],[{2993592205531,[{104014112,1}]}],[{2993592207450,[{101024112,1}]}],[{2993592207450,[{101044122,1}]}],[{2993592207450,[{101104122,1}]}],[{2993592207450,[{102024122,1}]}],[{2993592207450,[{102024132,1}]}],[{2993592207450,[{102064112,1}]}],[{2993592207450,[{102064122,1}]}],[{2993592207484,[{101014122,1}]}],[{2993592207484,[{102064132,1}]}],[{2993592207484,[{103014112,1}]}],[{3238405341240,[{101024102,1}]}],[{3238405341240,[{101044122,1}]}],[{3238405341240,[{101104122,1}]}],[{3238405342078,[{101064112,1}]}],[{3238405342078,[{102044112,1}]}],[{3246995276529,[{101024102,1}]}],[{3246995276529,[{102044102,1}]}],[{3246995276529,[{103014102,1}]}],[{3027951944601,[{101024112,1}]}],[{3027951944601,[{101084112,1}]}],[{3027951944601,[{102064112,1}]}],[{3027951944601,[{103014102,1}]}],[{3036541878969,[{101014102,1}]}],[{3036541878969,[{101024102,1}]}],[{3036541878969,[{101084102,1}]}],[{3036541878969,[{102084112,1}]}],[{3036541878969,[{104014112,1}]}],[{3040836845953,[{103014122,1}]}],[{3040836846298,[{102104112,1}]}],[{3122441224549,[{101024112,1}]}],[{3122441224549,[{102024122,1}]}],[{3122441225143,[{101044122,1}]}],[{3126736191663,[{101024102,1}]}],[{3126736191663,[{101024112,1}]}],[{3126736191663,[{101044112,1}]}],[{3126736191663,[{101044122,1}]}],[{3126736191663,[{102014102,1}]}],[{3126736191663,[{102014122,1}]}],[{3126736191663,[{102024102,1}]}],[{3126736191663,[{102024122,1}]}],[{3126736191663,[{102084112,1}]}],[{3126736192359,[{102044112,1}]}],[{2942052598010,[{101014132,1}]}],[{2942052598010,[{101024122,1}]}],[{2942052598010,[{101044112,1}]}],[{2942052598010,[{101084122,1}]}],[{2942052598010,[{102014132,1}]}],[{2942052598010,[{102024132,1}]}],[{2942052598010,[{102064132,1}]}],[{2942052598010,[{102084132,1}]}],[{2942052598010,[{102104132,1}]}],[{2942052598010,[{103014122,1}]}],[{2942052598010,[{104014132,1}]}],[{2942052598774,[{101024112,1}]}],[{2942052598774,[{103014132,1}]}],[{2942052598774,[{104014112,1}]}],[{2942052599911,[{101084122,1}]}],[{2942052599911,[{102084132,1}]}],[{2946347565141,[{101044122,1}]}],[{2946347565141,[{101064122,1}]}],[{2946347565141,[{101084132,1}]}],[{2946347565141,[{102084122,1}]}],[{2946347565207,[{101064132,1}]}],[{2946347565207,[{101104122,1}]}],[{2946347565207,[{102044122,1}]}],[{2946347565207,[{102064122,1}]}],[{2946347565207,[{102084102,1}]}],[{2946347565282,[{102104112,1}]}],[{2950642532467,[{102024112,1}]}],[{2950642532475,[{101014112,1}]}],[{2950642532475,[{101064122,1}]}],[{2950642532475,[{101104122,1}]}],[{2950642532475,[{102024122,1}]}],[{2950642532475,[{102064122,1}]}],[{2950642532475,[{102084122,1}]}],[{2950642534348,[{102084112,1}]}],[{2950642534348,[{104014122,1}]}],[{2950642534357,[{101044122,1}]}],[{2950642534357,[{102084122,1}]}],[{3895535338560,[{102044092,1}]}],[{3088081485825,[{101064122,1}]}],[{3088081485825,[{104014102,1}]}],[{3088081486054,[{101014122,1}]}],[{3088081486054,[{103014122,1}]}],[{3092376453122,[{101064112,1}]}],[{3092376453309,[{101014122,1}]}],[{3092376453309,[{101024112,1}]}],[{3092376453309,[{101024122,1}]}],[{3092376453309,[{102024122,1}]}],[{3092376453309,[{102044112,1}]}],[{3092376453309,[{102064122,1}]}],[{3092376453309,[{102104122,1}]}],[{3092376453309,[{103014122,1}]}],[{3092376454030,[{101014122,1}]}],[{3092376454030,[{102044122,1}]}],[{3092376454159,[{102024102,1}]}],[{3788161155665,[{101024122,1}]}],[{3788161155665,[{102044112,1}]}],[{3792456122441,[{101044112,1}]}],[{3792456122441,[{102014102,1}]}],[{3792456122441,[{103014112,1}]}],[{3792456122441,[{104014112,1}]}],[{3792456122731,[{101104102,1}]}],[{2821793513739,[{101064102,1}]}],[{2821793513739,[{101084112,1}]}],[{2821793513863,[{102044112,1}]}],[{2821793514047,[{101084102,1}]}],[{2826088481054,[{101014112,1}]}],[{2826088481054,[{101024112,1}]}],[{2826088481054,[{101024122,1}]}],[{2826088481054,[{101084122,1}]}],[{2826088481054,[{102014102,1}]}],[{2826088481054,[{102014132,1}]}],[{2826088481054,[{102044102,1}]}],[{2826088481054,[{104014122,1}]}],[{2826088481182,[{101044122,1}]}],[{2826088481182,[{102014122,1}]}],[{2826088481182,[{102064122,1}]}],[{2826088481182,[{102084132,1}]}],[{2826088481295,[{101024122,1}]}],[{2826088481295,[{101104112,1}]}],[{2826088481575,[{101024122,1}]}],[{2826088481575,[{102014122,1}]}],[{2826088481575,[{104014122,1}]}],[{2834678416439,[{101024122,1}]}],[{2834678416439,[{101104122,1}]}],[{2834678416439,[{102084122,1}]}],[{2834678416523,[{102024102,1}]}],[{2843268349966,[{101024132,1}]}],[{2843268349966,[{101064122,1}]}],[{2843268349966,[{102024132,1}]}],[{2843268349966,[{102064122,1}]}],[{2843268349966,[{102064132,1}]}],[{2843268349966,[{102084132,1}]}],[{2843268349977,[{101044122,1}]}],[{2843268349977,[{102024122,1}]}],[{2787433775635,[{101044112,1}]}],[{2787433775635,[{101064122,1}]}],[{2787433775635,[{101084122,1}]}],[{2787433775635,[{101084132,1}]}],[{2787433775635,[{101104122,1}]}],[{2787433775635,[{101104132,1}]}],[{2787433775635,[{102014132,1}]}],[{2787433775635,[{102024122,1}]}],[{2787433775635,[{102044112,1}]}],[{2787433775635,[{102084122,1}]}],[{2787433775635,[{104014132,1}]}],[{2787433775667,[{102064132,1}]}],[{2508260901212,[{101014122,1}]}],[{2508260901212,[{101044122,1}]}],[{2508260901212,[{101104132,1}]}],[{2508260901665,[{101014122,1}]}],[{2508260901665,[{101024112,1}]}],[{2508260901665,[{102014122,1}]}],[{2508260901665,[{102014132,1}]}],[{2508260901665,[{102024112,1}]}],[{2508260901665,[{103014132,1}]}],[{2508260901665,[{104014132,1}]}],[{2508260901770,[{101084122,1}]}],[{2512555869053,[{102044142,1}]}],[{3199750635840,[{101084112,1}]}],[{3199750635840,[{101084122,1}]}],[{3199750635840,[{102014112,1}]}],[{3212635537989,[{101024122,1}]}],[{3212635537989,[{101044102,1}]}],[{3212635537989,[{101044112,1}]}],[{3212635537989,[{101104112,1}]}],[{3212635537989,[{102014122,1}]}],[{3212635537989,[{102044112,1}]}],[{3212635537989,[{102064112,1}]}],[{3212635538167,[{101064112,1}]}],[{3212635538167,[{102044122,1}]}],[{3212635538167,[{102104122,1}]}],[{2710124364570,[{101084122,1}]}],[{2710124364570,[{102024112,1}]}],[{2710124364782,[{101084132,1}]}],[{2714419331112,[{101024132,1}]}],[{2714419331112,[{101044122,1}]}],[{2714419331112,[{101064122,1}]}],[{2714419331112,[{101084122,1}]}],[{2714419331112,[{102044132,1}]}],[{2714419331112,[{102064132,1}]}],[{2714419331112,[{102084132,1}]}],[{2714419331112,[{103014122,1}]}],[{2714419331496,[{101024112,1}]}],[{2714419331496,[{101024132,1}]}],[{2714419331496,[{101044122,1}]}],[{2714419331496,[{101104122,1}]}],[{2714419331496,[{102014132,1}]}],[{2714419331496,[{104014132,1}]}],[{2714419331609,[{101044132,1}]}],[{2714419331609,[{102084122,1}]}],[{2714419332148,[{101014112,1}]}],[{2714419332148,[{101064122,1}]}],[{2714419332148,[{101104122,1}]}],[{2714419332148,[{101104132,1}]}],[{2714419332148,[{102044112,1}]}],[{2723009266261,[{101024132,1}]}],[{2723009266261,[{101064132,1}]}],[{2723009266261,[{101084122,1}]}],[{2723009266261,[{101104122,1}]}],[{2723009266261,[{102064122,1}]}],[{2723009266261,[{102104132,1}]}],[{2723009266261,[{104014122,1}]}],[{3277060046993,[{102104112,1}]}],[{3277060047656,[{101014112,1}]}],[{3277060047656,[{101024102,1}]}],[{3277060047656,[{101044122,1}]}],[{3277060047656,[{101044132,1}]}],[{3277060047656,[{104014112,1}]}],[{3281355014262,[{102014122,1}]}],[{3281355014262,[{102024112,1}]}],[{3281355014262,[{102064122,1}]}],[{3281355014460,[{104014102,1}]}],[{3281355014463,[{102024112,1}]}],[{3281355014463,[{102104112,1}]}],[{3281355014463,[{103014112,1}]}],[{3281355014558,[{101014132,1}]}],[{3281355014558,[{102024112,1}]}],[{3281355014558,[{102064122,1}]}],[{3281355014558,[{104014132,1}]}],[{3281355015135,[{101014122,1}]}],[{3281355015135,[{101044122,1}]}],[{3281355015135,[{102024102,1}]}],[{3281355015135,[{103014102,1}]}],[{3191160701385,[{101044112,1}]}],[{3191160701385,[{102084102,1}]}],[{3191160701385,[{104014102,1}]}],[{3805341025105,[{102104112,1}]}],[{3805341025133,[{101024112,1}]}],[{2667174691432,[{102084132,1}]}],[{2667174691432,[{104014132,1}]}],[{2671469659150,[{104014122,1}]}],[{2976412336163,[{102084122,1}]}],[{2976412336350,[{101014102,1}]}],[{2976412336350,[{101024122,1}]}],[{2976412336350,[{101064122,1}]}],[{2976412336350,[{102044122,1}]}],[{2976412336604,[{102064132,1}]}],[{2976412336604,[{104014122,1}]}],[{2976412336644,[{102044112,1}]}],[{2976412337004,[{101024122,1}]}],[{2976412337004,[{101044112,1}]}],[{2976412337004,[{101064122,1}]}],[{2976412337004,[{101084112,1}]}],[{2976412337004,[{101084122,1}]}],[{2976412337004,[{101104122,1}]}],[{2976412337004,[{102014132,1}]}],[{2976412337004,[{102064112,1}]}],[{2976412337004,[{102084112,1}]}],[{2976412337968,[{101014112,1}]}],[{2976412337968,[{102024112,1}]}],[{2976412337968,[{102024122,1}]}],[{2976412337968,[{102064122,1}]}],[{2976412337968,[{102084132,1}]}],[{2976412338366,[{101014112,1}]}],[{2976412338366,[{101044102,1}]}],[{2976412338366,[{101044122,1}]}],[{2976412338366,[{101084122,1}]}],[{2976412338366,[{102014112,1}]}],[{2976412338366,[{102024102,1}]}],[{2976412338366,[{102044102,1}]}],[{2976412338366,[{102044112,1}]}],[{2976412338366,[{102044132,1}]}],[{2976412338366,[{102064102,1}]}],[{2976412338366,[{102064112,1}]}],[{2976412338366,[{102084112,1}]}],[{2976412338366,[{102084122,1}]}],[{2976412338366,[{103014112,1}]}],[{2980707303777,[{101084112,1}]}],[{2980707303777,[{103014102,1}]}],[{2980707305091,[{103014122,1}]}],[{2967822402677,[{101024112,1}]}],[{2967822403230,[{101014112,1}]}],[{2972117368991,[{101024112,1}]}],[{2972117368991,[{101064102,1}]}],[{2972117368991,[{101104112,1}]}],[{2972117368991,[{102014102,1}]}],[{2972117369656,[{101024102,1}]}],[{2972117369656,[{101044112,1}]}],[{2972117369656,[{101104112,1}]}],[{2972117369656,[{102014102,1}]}],[{2972117369656,[{102014122,1}]}],[{2972117369656,[{102084122,1}]}],[{2972117370027,[{101014102,1}]}],[{2972117370027,[{101104102,1}]}],[{2972117370027,[{102014112,1}]}],[{2972117370027,[{102024102,1}]}],[{2972117370027,[{102044102,1}]}],[{2972117370027,[{104014102,1}]}],[{2972117370316,[{101024112,1}]}],[{2972117370316,[{101044102,1}]}],[{2972117370316,[{101064122,1}]}],[{2972117370316,[{101084112,1}]}],[{2972117370316,[{102024122,1}]}],[{2972117370316,[{102044102,1}]}],[{2972117370316,[{102044112,1}]}],[{2972117370316,[{102084102,1}]}],[{2972117370316,[{102104102,1}]}],[{2972117370316,[{104014112,1}]}],[{2972117370316,[{104014122,1}]}],[{2972117370789,[{101064122,1}]}],[{2972117370789,[{102014132,1}]}],[{2796023709833,[{101014122,1}]}],[{2796023709833,[{103014112,1}]}],[{2796023710650,[{101014142,1}]}],[{2804613644410,[{101014122,1}]}],[{2804613644410,[{101014132,1}]}],[{2804613644410,[{101024122,1}]}],[{2804613644410,[{101044142,1}]}],[{2804613644410,[{102064132,1}]}],[{2804613644410,[{102064142,1}]}],[{2804613644410,[{103014132,1}]}],[{2804613644410,[{103014142,1}]}],[{2804613644805,[{101024122,1}]}],[{2804613644805,[{101024132,1}]}],[{2804613644805,[{101044142,1}]}],[{2804613644805,[{101064132,1}]}],[{2804613644805,[{101084112,1}]}],[{2804613644805,[{102014112,1}]}],[{2804613644805,[{102024122,1}]}],[{2804613644805,[{102024142,1}]}],[{2804613644805,[{102064122,1}]}],[{2804613644805,[{102084132,1}]}],[{2804613644805,[{102104132,1}]}],[{2804613644805,[{104014122,1}]}],[{2804613644996,[{101064122,1}]}],[{3062311682108,[{101014122,1}]}],[{3062311682108,[{102014112,1}]}],[{3062311682108,[{102084112,1}]}],[{3062311682108,[{104014122,1}]}],[{3062311682108,[{104014132,1}]}],[{3062311682256,[{101024112,1}]}],[{3062311682256,[{101064132,1}]}],[{3062311682256,[{102044112,1}]}],[{3062311682256,[{102064112,1}]}],[{3062311682256,[{103014112,1}]}],[{3062311682997,[{102044102,1}]}],[{3066606649360,[{102014112,1}]}],[{3066606649360,[{102044112,1}]}],[{3066606649360,[{104014112,1}]}],[{3066606650224,[{101014132,1}]}],[{3066606650224,[{102014122,1}]}],[{3066606650224,[{102024132,1}]}],[{3066606650224,[{102044112,1}]}],[{3066606650224,[{102044122,1}]}],[{3066606650224,[{102064132,1}]}],[{3066606650224,[{102104122,1}]}],[{3070901617449,[{102064122,1}]}],[{3070901617449,[{102084122,1}]}],[{3075196584215,[{102014122,1}]}],[{3075196584918,[{102044122,1}]}],[{2568390443130,[{102104122,1}]}],[{2568390443461,[{101014132,1}]}],[{2568390443461,[{102064132,1}]}],[{2568390443704,[{103014122,1}]}],[{2568390443848,[{102024132,1}]}],[{2568390443990,[{103014122,1}]}],[{2568390443998,[{101044132,1}]}],[{2576980377994,[{102044122,1}]}],[{2576980377994,[{102044132,1}]}],[{2576980377994,[{102104132,1}]}],[{2585570312299,[{101014132,1}]}],[{2585570312299,[{101084132,1}]}],[{2585570312299,[{101104132,1}]}],[{2585570312364,[{101044122,1}]}],[{2585570312364,[{102104122,1}]}],[{2585570312364,[{102104132,1}]}],[{2585570312364,[{103014122,1}]}],[{2585570312364,[{104014122,1}]}],[{2585570312611,[{101014132,1}]}],[{2585570312611,[{101044122,1}]}],[{2585570312611,[{101084122,1}]}],[{2585570312611,[{102024132,1}]}],[{2585570312611,[{102104112,1}]}],[{2585570312611,[{102104132,1}]}],[{2585570312611,[{104014122,1}]}],[{2589865279792,[{101024132,1}]}],[{2589865279792,[{101064112,1}]}],[{2589865279792,[{102014142,1}]}],[{2589865279792,[{102084122,1}]}],[{2589865279792,[{102104112,1}]}],[{2589865279792,[{103014122,1}]}],[{2589865279792,[{103014132,1}]}],[{3002182139943,[{103014102,1}]}],[{3006477107222,[{101014112,1}]}],[{3006477107222,[{101044102,1}]}],[{3006477107222,[{102014112,1}]}],[{3006477107222,[{102024112,1}]}],[{3006477107222,[{102024122,1}]}],[{3006477107222,[{102044102,1}]}],[{3006477107222,[{102084122,1}]}],[{3135326126829,[{101014112,1}]}],[{3135326126829,[{101024102,1}]}],[{3135326126829,[{101044102,1}]}],[{3135326126829,[{101104112,1}]}],[{3135326126829,[{102084112,1}]}],[{3135326126829,[{103014112,1}]}],[{3135326126829,[{104014102,1}]}],[{3143916060780,[{101044112,1}]}],[{3143916060780,[{101104122,1}]}],[{3143916060780,[{102014112,1}]}],[{3143916060780,[{102024112,1}]}],[{3143916060780,[{102084122,1}]}],[{3255585211019,[{101014112,1}]}],[{3255585211019,[{101064122,1}]}],[{3259880178565,[{102014122,1}]}],[{3264175145003,[{102014122,1}]}],[{3264175145003,[{102064112,1}]}],[{3268470113203,[{101024122,1}]}],[{3268470113203,[{101064122,1}]}],[{3268470113203,[{102064122,1}]}],[{3268470113203,[{103014122,1}]}],[{3272765079882,[{101014122,1}]}],[{3272765079882,[{101024102,1}]}],[{3272765079882,[{101084112,1}]}],[{3272765079882,[{103014112,1}]}],[{3272765079882,[{104014112,1}]}],[{3272765080397,[{101084112,1}]}],[{2813203578905,[{101104112,1}]}],[{2813203578905,[{102014122,1}]}],[{2813203579372,[{102084102,1}]}],[{2813203580365,[{101024112,1}]}],[{2813203580365,[{101084112,1}]}],[{2813203580365,[{102064112,1}]}],[{2813203580365,[{102084112,1}]}],[{2830383448171,[{101104112,1}]}],[{2838973383288,[{101024112,1}]}],[{2838973383288,[{101044122,1}]}],[{2838973383288,[{101084112,1}]}],[{2838973383288,[{102014132,1}]}],[{2838973383288,[{102024122,1}]}],[{2838973383288,[{102064102,1}]}],[{2838973383288,[{102064112,1}]}],[{2838973383288,[{102084102,1}]}],[{2838973383288,[{102084122,1}]}],[{2838973383288,[{102084132,1}]}],[{2838973383288,[{102104122,1}]}],[{2838973383288,[{104014132,1}]}],[{2838973383473,[{102104122,1}]}],[{2838973383473,[{103014122,1}]}],[{3045131812948,[{101014122,1}]}],[{3045131812948,[{101024102,1}]}],[{3045131812948,[{101084102,1}]}],[{3045131812948,[{102024122,1}]}],[{3045131812948,[{102084122,1}]}],[{3045131812948,[{102104122,1}]}],[{3045131813042,[{102014102,1}]}],[{3049426780270,[{101064122,1}]}],[{3049426780270,[{101104122,1}]}],[{3049426780270,[{102084102,1}]}],[{3049426780270,[{102104122,1}]}],[{3049426780270,[{104014122,1}]}],[{3049426780355,[{102024112,1}]}],[{3049426780355,[{102044122,1}]}],[{3049426780355,[{102084112,1}]}],[{3049426780370,[{101064112,1}]}],[{3049426780370,[{102014122,1}]}],[{3049426780825,[{101014102,1}]}],[{3049426780825,[{101024102,1}]}],[{3049426780825,[{101044112,1}]}],[{3049426780825,[{101064112,1}]}],[{3049426780825,[{101064122,1}]}],[{3049426780825,[{101084102,1}]}],[{3049426780825,[{101104112,1}]}],[{3049426780825,[{102044102,1}]}],[{3049426780825,[{102064102,1}]}],[{3049426780825,[{102084122,1}]}],[{3049426780825,[{102104112,1}]}],[{3049426780825,[{103014112,1}]}],[{3049426780831,[{101024122,1}]}],[{2886218023079,[{102044102,1}]}],[{2886218023079,[{103014102,1}]}],[{2890512990526,[{101024112,1}]}],[{2890512990526,[{101024122,1}]}],[{2890512990526,[{101044112,1}]}],[{2890512990526,[{102014122,1}]}],[{2890512990526,[{102024122,1}]}],[{2890512990526,[{102064112,1}]}],[{2890512990526,[{102104122,1}]}],[{2890512990526,[{103014122,1}]}],[{2899102926946,[{101024122,1}]}],[{2907692859398,[{101044102,1}]}],[{2907692859398,[{101044122,1}]}],[{2907692859398,[{101084112,1}]}],[{2907692859398,[{101084122,1}]}],[{2907692859398,[{102044112,1}]}],[{2907692859398,[{102084112,1}]}],[{2907692860908,[{101014122,1}]}],[{2907692860908,[{101044112,1}]}],[{2907692861038,[{101014112,1}]}],[{2907692861038,[{101104112,1}]}],[{2907692861038,[{102024102,1}]}],[{2907692861038,[{102084112,1}]}],[{2907692861038,[{103014122,1}]}],[{2907692861038,[{104014112,1}]}],[{2907692861199,[{101044122,1}]}],[{2907692861199,[{102104102,1}]}],[{2907692861313,[{101014122,1}]}],[{2907692861313,[{101044112,1}]}],[{2907692861313,[{101064112,1}]}],[{2907692861313,[{101104112,1}]}],[{2907692861313,[{102044102,1}]}],[{2907692861313,[{102044112,1}]}],[{2907692861313,[{102064122,1}]}],[{2907692861313,[{102084112,1}]}],[{2907692861313,[{102104102,1}]}],[{2907692861313,[{104014112,1}]}],[{2907692861467,[{101014112,1}]}],[{2907692861467,[{102104122,1}]}],[{2907692861467,[{103014122,1}]}],[{2907692861622,[{104014112,1}]}],[{2911987826761,[{101064122,1}]}],[{2911987826761,[{103014132,1}]}],[{2911987827166,[{101084132,1}]}],[{2911987827166,[{101104112,1}]}],[{2911987827166,[{102084122,1}]}],[{2911987827431,[{102024122,1}]}],[{2911987827449,[{101024132,1}]}],[{2911987827449,[{102084132,1}]}],[{2911987829142,[{102064112,1}]}],[{3341484556568,[{102044112,1}]}],[{3161095929869,[{102014122,1}]}],[{3161095929869,[{103014122,1}]}],[{3161095930535,[{102014122,1}]}],[{3161095930535,[{102064112,1}]}],[{3161095930535,[{102084112,1}]}],[{3169685865502,[{101084122,1}]}],[{3173980831833,[{101084102,1}]}],[{3173980831911,[{102084112,1}]}],[{3173980832167,[{102064102,1}]}],[{3173980832448,[{101024112,1}]}],[{3173980832448,[{102104122,1}]}]
        ],
    [begin
%%         timer:sleep(200),
         [gm_cost_goods(RoleId, GoodId, Num)  || {GoodId, Num} <- GoodList]
     end ||[{RoleId, GoodList}] <- List].



gm_cost_goods2(RoleId, GoodId, Num) when is_integer(RoleId) ->
    if
        Num > 0 ->
            Pid = misc:get_player_process(RoleId),
            case misc:is_process_alive(Pid) of
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_seacraft_daily, gm_cost_goods, [GoodId, Num]);
                _ ->
                    Sql1 = io_lib:format(<<"select   gid  from  goods_high   where  goods_id =  ~p   and (location = 4  or   location = 5 ) and pid = ~p ">>, [GoodId, RoleId]),
                    List = db:get_all(Sql1),
                    List2 = [Gid || [Gid]<-List],
                    Length = length(List2),
                    if
                        Length =< 0 ->
                            skip;
                        true ->
                            LastNum = min(Num, Length),
                            List3 = lists:sublist(List2, LastNum),
                            [begin
                            %% DELETE from goods_low where gid = ~p
                                 Sql2 = io_lib:format(<<"DELETE from goods_low where gid = ~p">>, [Gid]),
                                 %% DELETE from goods_high where gid = ~p
                                 Sql3 = io_lib:format(<<"DELETE from goods_high where gid = ~p">>, [Gid]),
                                 %% DELETE from goods where id  = ~p
                                 Sql4 = io_lib:format(<<"DELETE from goods where id  = ~p">>, [Gid]),
                                 db:execute(Sql2),
                                 db:execute(Sql3),
                                 db:execute(Sql4)
                             end
                                || Gid <- List3]
                    end
            end;
        true ->
            skip
    end.
    