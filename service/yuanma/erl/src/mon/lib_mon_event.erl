%% ---------------------------------------------------------------------------
%% @doc lib_mon_event
%% @author ming_up@foxmail.com
%% @since  2016-12-29
%% @deprecated  怪物对外事件
%% ---------------------------------------------------------------------------
-module(lib_mon_event).
-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("predefine.hrl").
-include("dungeon.hrl").
-include("attr.hrl").
-include("drop.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

-export([
        be_killed/7,
        be_collected/6,
        be_picked/2,
        be_hurted/8,
        be_rebound_hurt/4,
        hp_change/3,
        move/1,
        move_end/1,
        broadcast_hurt_list/2,
        be_stop/1,
        be_die/1,
        hurt_remove/4,
        assist_add/2,
        assist_remove/2,
        assist_change/2
    ]).

be_killed(Minfo, Klist, Atter, AtterSign, FirstAttr, BLWhos, AssistDataList) ->
    #scene_object{
       id = AutoId, mon=Mon, scene = SceneId, scene_pool_id=ScenePoolId, copy_id = CopyId, mod_args = ModArgs,
       sign = DieSign, skill_owner = SkillOwner, die_info = DieInfoList, x = X, y = Y, d_x = DX, d_y = DY, figure = Figure} = Minfo,
    #scene_mon{exp=Exp, kind = MonKind, mid=Mid, exp_share_type = ExpShareType, boss = Boss, create_key = CreateKey, mon_sys = MonSys} = Mon,
    #battle_return_atter{
        id = AtterId, real_name = AtterName, team_id = TeamId, server_id = ServerId, server_num = ServerNum,
        guild_id = GuildId, node = AtterNode
        } = Atter,
    DieDatas = get_die_data(DieInfoList, Minfo, [], Klist),
    BlFirstAttr = lib_mon_util:get_bl_whos_first_attr(FirstAttr, AssistDataList),
    lib_dungeon_api:kill_mon(SceneId, CopyId, AutoId, DieSign, Mon, SkillOwner, [{killer, AtterId}|DieDatas]),
    MonArgs = #mon_args{
        id = AutoId, mid = Mid, kind = MonKind, lv = Figure#figure.lv,
        ctime = Mon#scene_mon.ctime, boss = Boss, mon_sys = MonSys, scene = SceneId, hurt_list = Klist,
        scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, d_x = DX, d_y = DY, name = Figure#figure.name},
    %% 触发增加亲密度
    lib_relationship_api:event_trigger({kill_mon, Mid, MonKind, Boss, BLWhos}),
    lib_task_drop:mon_die(Minfo, Klist, BLWhos),
    lib_decoration_boss_api:kill_mon(Minfo, Klist, Atter, AtterSign, BlFirstAttr, BLWhos, MonArgs),
    lib_guild_assist:boss_be_kill(Minfo, BLWhos, AssistDataList),
    case lib_scene:is_clusters_scene(SceneId) of
        true  ->
            ?IF(Exp =< 0, skip, share_mon_exp(Mid, ExpShareType, Klist, Exp, SceneId, ScenePoolId, CopyId, X, Y)),
            %% 幻兽之域boss击杀
            mod_eudemons_land:eudemons_boss_be_kill(SceneId, ScenePoolId, Mid, ServerId, ServerNum, Atter, BlFirstAttr, BLWhos, MonArgs, Minfo),
            %% 跨服秘境大妖
            mod_great_demon:great_demon_boss_be_kill([SceneId, ScenePoolId, Mid, ServerId, Atter, BLWhos, MonArgs, Minfo, FirstAttr]),
            ?IF(lib_void_fam:is_in_void_fam(SceneId), mod_void_fam:kill_mon(AtterId, AtterName, Mid, SceneId), skip),
            %% 永恒碑谷
            lib_eternal_valley_api:kill_mon(1, AtterSign, AtterId,ServerId, Mid, BLWhos),
            %% 跨服公会战
            lib_kf_guild_war_api:kill_mon(AtterId, Minfo),
            %% 跨服圣域
            %lib_c_sanctuary_api:mon_be_killed(BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName),
            lib_sanctuary_cluster_api:mon_be_killed(BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName),
            %% 永恒圣殿
            lib_kf_sanctum:sanctum_mon_be_kill(BLWhos, Klist, SceneId, ScenePoolId, CopyId, Mid),
            %% 跨服掉落处理
            lib_drop:cluster_mon_drop(Minfo, MonArgs, Atter, AtterSign, BLWhos, BlFirstAttr),
            %% 任务
            lib_task_api:cluster_kill_mon(Klist, SceneId, Mid, Figure#figure.lv),
            %% 至尊vip
            lib_supreme_vip_api:cluster_kill_boss(Atter, BLWhos, MonSys, Figure#figure.lv),
            %% 圣灵战场
            mod_holy_spirit_battlefield_room:kill_mon(SceneId, Atter, Klist, Minfo),
            %% 公会领地战
            mod_territory_war_fight:kill_mon(Atter, Minfo),
            %% 怒海争霸
            lib_seacraft:mon_be_kill(Atter, Minfo),
            %% 海战日常
            lib_kf_seacraft_daily:mon_be_kill(SceneId, Atter, Minfo, Klist),
            %% 矿石护送
            lib_escort:mon_be_killed(SceneId, ScenePoolId, CopyId, X, Y, ServerId, Mid, AutoId, Figure#figure.lv, Figure#figure.guild_id, AtterId, AtterName),
            %% 神殿觉醒
            lib_temple_awaken_api:trigger_kill_mon(1, AtterSign, AtterId,ServerId, Mid, BLWhos),
            % 百鬼夜行
            lib_night_ghost_api:boss_be_killed(true, Minfo, Klist, Atter, AtterSign);
        false -> %% 非跨服调用
            %%主线副本
            lib_enchantment_guard:add_kill_mon_num_hooking(SceneId, AtterId, Klist),
            %%圣域
            lib_sanctuary:boss_be_kill(Mon, SceneId, AtterId, Klist, GuildId, AtterName, X, Y, ScenePoolId),
            %%活动首杀
            mod_first_kill:boss_be_kill(Mon, SceneId, AtterId, Klist),
            ?IF(lib_void_fam:is_in_void_fam(SceneId), mod_void_fam_local:kill_mon(AtterId, AtterName, Mid, SceneId), skip),
            %% 公会争霸
            %%lib_guild_battle_api:kill_mon(Atter, Minfo),
            %% 公会领地战
            mod_territory_war_fight:kill_mon(Atter, Minfo),
            %% 永恒碑谷
            % ?PRINT("boss be killed AtterSign,AtterId,ServerId, Mid, FirstAttr, BLWhos:~w~n",[[AtterSign,AtterId,ServerId, Mid,FirstAttr, BLWhos]]),
            lib_eternal_valley_api:kill_mon(0, AtterSign,AtterId,ServerId, Mid, BLWhos),
            %% 公会晚宴
            mod_guild_feast_mgr:kill_boss(AtterId, MonArgs, ModArgs),
            %% 公会boss
            mod_guild_boss:kill_mon(Atter, Minfo),
            %% 圣灵战场本服也会
            mod_holy_spirit_battlefield_room:kill_mon(SceneId, Atter, Klist, Minfo),
            %% 使魔副本
            lib_dun_demon:demon_die(MonArgs),
            %% 午间派对
            mod_midday_party:mon_be_kill(AtterId, MonArgs),
            %% 神殿觉醒
            lib_temple_awaken_api:trigger_kill_mon(0, AtterSign, AtterId,ServerId, Mid, BLWhos),
            % 百鬼夜行
            lib_night_ghost_api:boss_be_killed(false, Minfo, Klist, Atter, AtterSign),
            % ?IF(AtterId==4294967297, ?MYLOG("hjhdunmon", "be_killed DUNGEON_TYPE_EXP_SINGLE AtterId:~p SceneId:~p, MonId:~p ~n",
            %     [AtterId, SceneId, Mon#scene_mon.mid]), skip),
            %% 活动Boss
            case CreateKey of
                act_boss ->
                    BossName = lib_mon:get_name_by_mon_id(Mid),
                    mod_act_boss:kill_boss(AtterId, AtterName, BossName, SceneId);
                _ -> skip
            end,
            if
                AtterSign == ?BATTLE_SIGN_PLAYER ->
                    %% 避免队伍重复触发任务
                    Fun = fun(P, TeamIds) ->
                        if
                            P#mon_atter.team_id == 0 ->
                                lib_task_api:kill_mon(P#mon_atter.id, SceneId, Mid, Figure#figure.lv),
                                TeamIds;
                            true ->
                                case lists:member(P#mon_atter.team_id, TeamIds) of
                                    true -> TeamIds;
                                    false ->
                                        lib_team_api:kill_mon(P#mon_atter.team_id, SceneId, Mid, Figure#figure.lv),
                                        [P#mon_atter.team_id|TeamIds]
                                end
                          end
                    end,
                    lists:foldl(Fun, [], Klist),
                    ?IF(Exp =< 0, skip, share_mon_exp(Mid, ExpShareType, Klist, Exp, SceneId, ScenePoolId, CopyId, X, Y)),
                    mod_boss:boss_be_kill(SceneId, ScenePoolId, Mid, AtterId, AtterName, BLWhos, DX, DY, BlFirstAttr, MonArgs),
                    lib_territory_treasure:mon_be_killed(Minfo, Mid),
                    %% 触发成就
                    case Boss =:= ?MON_NORMAL_OUSIDE of
                        true ->lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_achievement_api, mon_die_event, [Figure#figure.lv]);
                        _ -> skip
                    end,
                    %% 野外场景
                    case data_scene:get(SceneId) of
                        #ets_scene{type= SceneType} when SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS
                        orelse SceneType == ?SCENE_TYPE_SPECIAL_BOSS  ->
                            case data_drop:get_rule_list(Mon#scene_mon.mid) of
                                [Alloc|_] ->
                                    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, alloc_drop_role, [MonArgs, Alloc, Klist, BlFirstAttr])
                                        || #mon_atter{id = RoleId} <- BLWhos];
                                _ ->
                                    skip
                            end;
                        _ -> skip
                    end,
                    % 掉落
                    case lib_boss:is_in_forbdden_boss(SceneId) of
                        true -> % 蛮荒boss
                            #battle_return_atter{world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, node = Node} = Atter,
                            MonAttr = #mon_atter{id = AtterId, server_id = ServerId, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, node = Node},
                            [#mon_atter{id = BlRoleId, node = BlNode}|_] = ?IF(BLWhos == [], [MonAttr], BLWhos),
                            % lib_player:apply_cast(BlRoleId, ?APPLY_CAST_STATUS, lib_goods_drop, mon_drop, [Minfo, Klist, BlFirstAttr]);
                            lib_goods_drop:mon_drop(BlNode, BlRoleId, Minfo, Klist, BlFirstAttr);
                        false ->
                            % lib_player:apply_cast(AtterId, ?APPLY_CAST_STATUS, lib_goods_drop, mon_drop, [Minfo, Klist, BlFirstAttr])
                            lib_goods_drop:mon_drop(AtterNode, AtterId, Minfo, Klist, BlFirstAttr)
                    end,
                    %% 任务触发击杀boss
                    lib_task_api:kill_boss(Klist, MonSys, Figure#figure.lv),
                    lib_supreme_vip_api:kill_boss(Atter, BLWhos, MonSys, Figure#figure.lv),
                    lib_player:update_player_vip_boss_count(Atter#battle_return_atter.id, MonSys),
                    % 野外场景处理
                    case data_scene:get(SceneId) of
                        #ets_scene{type=?SCENE_TYPE_OUTSIDE} -> lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_afk, kill_mon, []);
                        _ -> skip
                    end;
                AtterSign == ?BATTLE_SIGN_MON ->
                    mod_boss:boss_be_kill_by_mon(SceneId, ScenePoolId, Mid, AtterId, AtterName, BLWhos, DX, DY, BlFirstAttr, MonArgs);
                AtterSign == ?BATTLE_SIGN_DUMMY andalso TeamId > 0 ->
                    [mod_team:cast_to_team(TeamId, {'alloc_drop', MonArgs, ?ALLOC_EQUAL, Klist}) || ?ALLOC_EQUAL <- data_drop:get_rule_list(Mon#scene_mon.mid)];
                true ->
                    skip
            end
    end,
    ok.

be_collected(Minfo, CollectorNode, CollectorId, ServerId, CollectorName, FirstAttr) ->
    #scene_object{
        id = OnlyId,
        scene=SceneId,
        scene_pool_id=ScenePoolId,
        copy_id = CopyId,
        d_x  = X,
        d_y = Y,
        mod_args = ModArgs,
        mon= Mon = #scene_mon{mid=Mid, create_key=_CreateKey},
        figure = Figure
    } = Minfo,
    lib_nine_api:collect_flag(CollectorId, Minfo),
    MonArgs = #mon_args{id = OnlyId, mid = Mon#scene_mon.mid, kind = Mon#scene_mon.kind, lv = Figure#figure.lv,
        ctime = Mon#scene_mon.ctime, boss = Mon#scene_mon.boss, mon_sys = Mon#scene_mon.mon_sys, scene = SceneId,
        scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, d_x = X, d_y = Y, name = Figure#figure.name,
        collect_times = Mon#scene_mon.collect_times
    },
    case lib_scene:is_clusters_scene(SceneId) of
        true  ->
            lib_seacraft:mon_be_collect(FirstAttr, Minfo),
            mod_eudemons_land:eudemons_boss_be_kill(SceneId, ScenePoolId, Mid, ServerId, FirstAttr#mon_atter.server_num, CollectorId, CollectorName, FirstAttr, [], MonArgs, Minfo),
            case lib_boss:is_in_kf_great_demon_boss(SceneId) of
                true ->
                    lib_goods_drop:mon_drop(CollectorNode, CollectorId, Minfo, [], []),
                    Attrker = #battle_return_atter{id = CollectorId, real_name = CollectorName, server_id = ServerId},
                    mod_great_demon:great_demon_boss_be_kill(SceneId, ScenePoolId, Mid, ServerId,
                        Attrker, [], MonArgs, Minfo, FirstAttr);
                false ->
                    skip
            end;
        false -> %% 采集掉落
            % lib_player:apply_cast(CollectorId, ?APPLY_CAST_STATUS, lib_goods_drop, mon_drop, [Minfo, [], []]),
            lib_goods_drop:mon_drop(CollectorNode, CollectorId, Minfo, [], []),
            lib_task_api:collect_mon(CollectorId, Mid),
            lib_marriage_wedding:collect_mon(CollectorId, OnlyId, Mid, CopyId),
            lib_treasure_chest:collect_finish(CollectorId, Minfo),
            mod_guild_feast_mgr:kill_boss(CollectorId, MonArgs, ModArgs),
            mod_guild_boss:be_collected(CollectorId, OnlyId, Mid, SceneId, CopyId),
            mod_midday_party:be_collected(CollectorId, MonArgs),
            mod_boss:boss_be_kill(SceneId, ScenePoolId, Mid, CollectorId, CollectorName, [], X, Y, FirstAttr, MonArgs)
    end.

be_picked(Minfo, CollectorId) ->
    #scene_object{id = AutoId, mon=Mon, scene = SceneId, scene_pool_id=_ScenePoolId, copy_id = CopyId, sign = DieSign, skill_owner = SkillOwner, skill=_Skill} = Minfo,
%%    case Skill of
%%        %% 自己对自己释放，减少配置的难度
%%        [{SkillId, SkillLv}|_] -> lib_battle_api:assist_anything(SceneId, ScenePoolId, ?BATTLE_SIGN_PLAYER, CollectorId, ?BATTLE_SIGN_PLAYER, CollectorId, SkillId, SkillLv);
%%        _ -> skip
%%    end,
    lib_dungeon_api:kill_mon(SceneId, CopyId, AutoId, DieSign, Mon, SkillOwner, []),
    lib_dungeon_api:pick_mon(Minfo, CollectorId).
    % case lib_scene:is_clusters_scene(SceneId) of
    %     true  -> skip;
    %     false -> lib_dungeon_api:kill_mon(SceneId, CopyId, AutoId, DieSign, Mon, SkillOwner, [])
    % end.

%% 怪物受伤处理
be_hurted(Minfo, _OldMinfo, Atter, MonAtter, AtterSign, Hurt, _NewKlist, Klist) ->
    #scene_object{id = Id, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My, mon = Mon, config_id = ConfigId} = Minfo,
    #battle_return_atter{
        id = RoleId, server_id = ServerId, real_name = RoleName, server_num = ServerNum, server_name = ServerName, mask_id = MaskId, assist_id = AssistId,
        team_id = TeamId
    } = Atter,
    #scene_mon{mid = _MonId, boss = Boss} = Mon,
    lib_kf_guild_war_api:attack_mon(Atter#battle_return_atter.id, Minfo),
    lib_boss_api:be_hurted(Minfo, Atter#battle_return_atter.pid, Atter#battle_return_atter.id,
        Atter#battle_return_atter.real_name, Hurt),
    lib_territory_treasure:mon_be_hurt(Minfo, Atter#battle_return_atter.id, Atter#battle_return_atter.real_name, Hurt),
    mod_sanctuary:mon_be_hurt(Minfo, Atter#battle_return_atter.id),
    % mod_c_sanctuary:mon_hurt(ObjectScene, PoolId, CopyId, ServerId, MonId, RoleId, RoleName, Hurt),
    %%lib_guild_battle_api:hurt_mon(Minfo, Atter#battle_return_atter.id),
    %% 公会领地领地战
    mod_territory_war_fight:hurt_mon(Minfo, Atter#battle_return_atter.id),
    %% 公会boss
    mod_guild_boss:hurt_mon(Atter, Minfo),
    %% 跨服圣域
    %lib_c_sanctuary_api:mon_be_hurt(Minfo, Atter, Hurt),
    lib_sanctuary_cluster_api:mon_be_hurt(Minfo, Atter, Hurt),
    %% 矿石护送
    lib_escort:mon_hurt(Atter, Minfo, Hurt),
    %% 怒海争霸
    lib_seacraft:mon_be_hurt(Atter, Minfo, Hurt),
    %% 圣灵战场
    mod_holy_spirit_battlefield_room:mon_be_hurt(SceneId, Atter, Minfo),
    %% 幻饰boss伤害
    lib_decoration_boss_api:hurt_mon(Minfo, Atter, Hurt),
    %% 海战日常伤害
    mod_kf_seacraft_daily:hurt_mon(Minfo, Atter),
    %% 公会协助
    lib_guild_assist:boss_be_hurt(MonAtter, Klist, Hurt),
    %% 怪物伤害通知##通用伤害榜单,不支持的话就功能内部处理,只有需要本榜单才发送
    if
        AtterSign == ?BATTLE_SIGN_PLAYER andalso Hurt =/= 0 ->
            % ?MYLOG("hjhhurtrank", "SceneId:~w ~n", [SceneId]),
            case lib_mon_mod:is_need_hurt_notice(SceneId, ConfigId, Boss) of
                true ->
                    NeedWrapName = lib_player:is_need_wrap_name_scene(SceneId),
                    WrapName = ?IF(NeedWrapName == true, lib_player:get_wrap_role_name(RoleName, [MaskId]), RoleName),
                    % ?MYLOG("sanctum", "12026 ~p~n", [ServerName]),
                    {ok, Bin} = pt_120:write(12026, [Id, ConfigId, RoleId, WrapName, ServerId, ServerNum, ServerName, TeamId, 0, Hurt, AssistId]), % 队伍职位暂定为0
                    % ?MYLOG("hjhhurtrank", "NewKlist Id:~p Hurt:~p~n, be_hurted:~w ~n", [Id, Hurt, _NewKlist]),
                    lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, Mx, My, Bin);
                false ->
                    skip
            end;
        true ->
            skip
    end,
    case lib_scene:is_clusters_scene(SceneId) of
        true -> skip;
        false -> skip
    end.

%% 怪物反弹伤害处理
be_rebound_hurt(_, _, _,_) -> ok.

%% 血量发生变化
hp_change(Minfo, OldMinfo, _Klist) ->
    #scene_object{copy_id = CopyId, battle_attr = #battle_attr{hp=Hp, hp_lim=HpLim}, mon = #scene_mon{mid = MonId}} = Minfo,
    #scene_object{battle_attr = #battle_attr{hp=OldHp} } = OldMinfo,
    case get(dungeon_hp_rate) of
        undefined -> skip;
        HpRateList ->
            HpR1 = Hp/HpLim,
            HpR2 = OldHp/HpLim,
            F = fun(EventHp) -> (EventHp>=HpR1 andalso EventHp=<HpR2) orelse (EventHp>=HpR2 andalso EventHp=<HpR1) end,
            case lists:filter(F, HpRateList) of
                [] -> skip;
                FilterHpRateList ->
                    LeftHpRateList = HpRateList -- FilterHpRateList,
                    case LeftHpRateList == [] of
                        true -> erase(dungeon_hp_rate);
                        false -> put(dungeon_hp_rate, LeftHpRateList)
                    end,
                    EventData = #dun_callback_mon_hp_rate{mon_id = MonId, hp_rate_list = FilterHpRateList},
                    mod_dungeon:dispatch_dungeon_event(CopyId, ?DUN_EVENT_TYPE_ID_MON_HP, EventData)
            end
    end.

%% 广播怪物伤害
broadcast_hurt_list(_Minfo, _Klist) ->
    ok.

%% 移除伤害
%% @param DelUsersIds 移除伤害的玩家id [RoleId, ...]
hurt_remove(_Minfo, _OldKlist, _NewKlist, []) -> skip;
hurt_remove(Minfo, _OldKlist, _NewKlist, DelUsersIds) ->
    #scene_object{id = Id, config_id = ConfigId, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My, mon = Mon} = Minfo,
    #scene_mon{mid = _MonId, boss = Boss} = Mon,
    %% 怪物伤害通知##通用伤害榜单,不支持的话就功能内部处理,只有需要本榜单才发送
    case lib_mon_mod:is_need_hurt_notice(SceneId, ConfigId, Boss) andalso DelUsersIds =/= [] of
        true ->
            {ok, Bin} = pt_120:write(12027, [Id, ConfigId, DelUsersIds]),
            % ?MYLOG("hjhhurtrank", "NewKlist Id:~p DelUsersIds:~w hurt_remove:~w ~n", [Id, DelUsersIds, _NewKlist]),
            lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, Mx, My, Bin);
        false ->
            skip
    end.

%% 走路
move(_Minfo) ->
    % #scene_object{id = Id, x = X, y = Y, mon = Mon, skill_owner = SkillOwner} = Minfo,
    lib_escort:mon_move(_Minfo),
    ok.

%% 走完路径
move_end(_Minfo) ->
    % #scene_object{battle_attr= BA, mon = Mon, skill_owner = SkillOwner} = Minfo,
    ok.

%% 被清理
be_stop(Minfo) ->
    #scene_object{id = AutoId, scene = SceneId, copy_id = CopyId, sign = Sign, battle_attr= BA, mon = Mon, skill_owner = SkillOwner} = Minfo,
    lib_dungeon_api:stop_mon(SceneId, CopyId, AutoId, Sign, Mon, SkillOwner, BA#battle_attr.hp, BA#battle_attr.hp_lim),
    lib_escort:mon_stop(Minfo),
    ok.

%% 被死亡(一些ai触发的)
be_die(_Minfo) ->
    ok.

%% 怪物的掉落处理
%% common_mon_drop(Atter, Minfo, Klist, FirstAttr)->
%%     #scene_object{
%%        id = MonAutoId, scene = ObjectScene, scene_pool_id = ObjectPoolId,
%%        copy_id = ObjectCopyId, x = X, y = Y, mon = Mon, figure = Figure
%%       } = Minfo,
%%     MonArgs = #mon_args{
%%                  id = MonAutoId, mid = Mon#scene_mon.mid, kind = Mon#scene_mon.kind,
%%                  boss = Mon#scene_mon.boss, scene = ObjectScene, scene_pool_id = ObjectPoolId,
%%                  copy_id = ObjectCopyId, x = X, y = Y, name = Figure#figure.name},
%%     lists:foreach(fun(Alloc) ->
%%                           alloc_drop(PlayerStatus, MonArgs, Alloc, PList, FirstAttr)
%%                   end, data_drop:get_rule_list(Mon#scene_mon.mid)).
%%     do.

%% 获取死亡数据
get_die_data([title|T], Minfo, Acc, Klist) ->
    #scene_object{figure = #figure{title = Title}} = Minfo,
    get_die_data(T, Minfo, [{title, Title}|Acc], Klist);
get_die_data([klist|T], Minfo, Acc, Klist) ->
    get_die_data(T, Minfo, [{klist, Klist}|Acc], Klist);
get_die_data([_|T], Minfo, Acc, Klist) ->
    get_die_data(T, Minfo, Acc, Klist);
get_die_data([], _Minfo, Acc, _Klist) -> Acc.

%% 经验分享
share_mon_exp(_Mid, ?EXP_SHARE_ALL_TO_ATTACKER, Klist, Exp, SceneId, _ScenePoolId, _CopyId, _X, _Y) ->
    [lib_player:apply_cast(P#mon_atter.node, P#mon_atter.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_player, share_mon_exp, [Exp, ?ADD_EXP_MON, [], SceneId]) || P <- Klist];
share_mon_exp(_Mid, ?EXP_SHARE_PART_TO_ATTACKER, Klist, Exp0, SceneId, _ScenePoolId, _CopyId, _X, _Y) ->
    AllHurt = lists:sum([P#mon_atter.hurt || P <- Klist]),
    [begin
         Exp = max(trunc(Exp0 * P#mon_atter.hurt / AllHurt), 1),
         lib_player:apply_cast(P#mon_atter.node, P#mon_atter.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_player, share_mon_exp, [Exp, ?ADD_EXP_MON, [], SceneId])
     end || P <- Klist];
share_mon_exp(Mid, ?EXP_SHARE_TO_SCENE, _Klist, Exp, SceneId, ScenePoolId, CopyId, _X, _Y) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, player_apply_cast,
                               [CopyId, ?APPLY_CAST_SAVE, lib_player, share_mon_dynamic_exp, [Mid, Exp, SceneId]]);
share_mon_exp(Mid, ?EXP_SHARE_ALL_TO_ATTACKER_DYNAMIC, Klist, Exp, SceneId, _ScenePoolId, _CopyId, _X, _Y) ->
    [lib_player:apply_cast(P#mon_atter.node, P#mon_atter.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_player, share_mon_dynamic_exp, [Mid, Exp, SceneId]) || P <- Klist];
share_mon_exp(_, _, _, _, _, _, _, _, _) -> ok.

assist_add(Minfo, AssistData) ->
    #scene_object{id = Id, config_id = ConfigId, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = Minfo,
    #assist_data{assist_id = AssistId,
        mon_atter = #mon_atter{id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, server_name = ServerName}
    } = AssistData,
    {ok, Bin} = pt_120:write(12044, [Id, ConfigId, AssistId, RoleId, Name, ServerId, ServerNum, ServerName]),
    lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, Mx, My, Bin).

assist_remove(Minfo, DelAssistId) ->
    #scene_object{id = Id, config_id = ConfigId, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = Minfo,
    {ok, Bin} = pt_120:write(12045, [Id, ConfigId, DelAssistId]),
    lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, Mx, My, Bin).

assist_change(Minfo, ChangeIds) ->
    #scene_object{id = Id, config_id = ConfigId, scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = Mx, y = My} = Minfo,
    {ok, Bin} = pt_120:write(12028, [Id, ConfigId, ChangeIds]),
    lib_server_send:send_to_area_scene(SceneId, ScenePoolId, CopyId, Mx, My, Bin).
