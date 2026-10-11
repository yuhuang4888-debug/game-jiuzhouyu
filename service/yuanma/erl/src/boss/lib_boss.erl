%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 25 Nov 2017 by root <root@localhost.localdomain>

-module(lib_boss).

-compile(export_all).

-include("server.hrl").
-include("boss.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("drop.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("attr.hrl").
-include("activitycalen.hrl").
-include("buff.hrl").
-include("domain.hrl").
-include("rec_event.hrl").
-include("investment.hrl").

make_record(role_boss, [BossType, Vit, VitAddToday, VitCanBack, LastVitTime, BuyCount, ExtraCount, Time, NextEnterTime, DieTime, DieTimes]) ->
    #role_boss{
        boss_type = BossType, vit = Vit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = LastVitTime,
        buy_count = BuyCount, die_times = DieTimes, extra_count = ExtraCount, stime = Time, die_time = DieTime,  next_enter_time = NextEnterTime
    }.

%% 登录
login(Player) ->
    #player_status{
        id = RoleId, last_login_time = LoginTime, last_task_id = LastTaskId,
        figure = #figure{lv = RoleLv}
    } = Player,
    Fun = fun(TemBossType, Acc) ->
        TemList = db_role_boss_select(RoleId, TemBossType),
        Acc ++ TemList
    end,
    BossTypeList = [?BOSS_TYPE_OUTSIDE, ?BOSS_TYPE_NEW_OUTSIDE],
    List = lists:foldl(Fun, [], BossTypeList),
    F = fun([ TemBossType | _ ] = T) ->
        RoleBoss0 = make_record(role_boss, T),
        RoleBoss = calc_vit_info(Player, RoleBoss0),
        RoleBoss /= RoleBoss0 andalso db_role_boss_replace(RoleId, RoleBoss),
        {TemBossType, RoleBoss}
    end,
    BossMap = maps:from_list(lists:map(F, List)),
    F2 = fun(BossType, TmpMap) ->
        case maps:get(BossType, TmpMap, []) of
            [] ->
                Vit = ?BOSS_TYPE_KV_INIT_VIT(BossType),
                RoleBoss = make_record(role_boss, [BossType, Vit, 0, 0, LoginTime, 0, 0, 0, 0, 0, 0]);
            RoleBoss ->
                ok
        end,
        maps:put(BossType, RoleBoss, TmpMap)
    end,
    % daily_icon_control(Player),%%推送世界boss入口图标 %%%%%%
    %% 未完成任务的情况下才会有野外boss特殊层数据
    LastTaskId =< ?SPECIAL_BOSS_TASK_ID
        andalso mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_SPECIAL),
    mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_PHANTOM_PER),
    mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_WORLD_PER),
    NewBossMap = lists:foldl(F2, BossMap, BossTypeList),
    StatusBoss = #status_boss{boss_map = NewBossMap},
    Player#player_status{status_boss = StatusBoss}.

%% 38160001
use_boss_tired_goods(Ps, GoodsTypeId, Num) ->
    #player_status{
        figure = #figure{name = RoleName, vip = VipLv, vip_type = VipType},
        id = RoleId, sid = Sid, status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss
    } = Ps,
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    NowTime = utime:unixtime(),
    List = ?BOSS_TYPE_KV_GOODS_ADD_VIT(BossType),
    case lists:keyfind(GoodsTypeId, 1, List) of
        {_, AddVitOne} ->AddVitOne;
        _ -> AddVitOne = 1
    end,
    case data_boss:get_boss_type(BossType) of
        #boss_type{module = _ModuleId, daily_id = _CounterId} ->
            case maps:get(BossType, TmpMap, []) of
                #role_boss{vit = OldVit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = OldLastVitTime} ->
                    #role_boss{vit = NVit, last_vit_time = LastVitTime} = RoleBoss0 = calc_vit(Ps, BossType),
                    Vit = NVit + AddVitOne * Num,
                    RoleBoss = RoleBoss0#role_boss{vit = Vit};
                _ ->
                    Vit = ?BOSS_TYPE_KV_INIT_VIT(BossType) + AddVitOne * Num,
                    VitAddToday = 0, VitCanBack = 0,
                    LastVitTime = NowTime, OldVit = 0, OldLastVitTime = 0,
                    RoleBoss = make_record(role_boss, [BossType, Vit, 0, 0, LastVitTime, 0, 0, 0, 0, 0, 0])
            end,
            db_role_boss_replace(RoleId, RoleBoss),
            NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
            StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
            NewPs = Ps#player_status{status_boss = StatusBoss},
            SceneData = lib_boss_api:make_boss_tired_map(NewPs, BossType),
            VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
            CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
            MaxVit = CfgMaxVit+VipAddMaxCount,
            AddVitTime = ?BOSS_TYPE_KV_ADD_VIT_TIME(BossType),
            FixAddVitTime = vip_reduce_vit_time(Ps, AddVitTime),
            lib_log_api:log_boss_vit_change(RoleId, RoleName, OldVit, OldLastVitTime,
                [{0, GoodsTypeId, Num}], 0, Vit, LastVitTime, MaxVit, FixAddVitTime),
            {ok, BinData} = pt_460:write(46044, [Vit, MaxVit, VitAddToday, VitCanBack, LastVitTime]),
            lib_server_send:send_to_sid(Sid, BinData),
            mod_scene_agent:update(NewPs, [{scene_boss_tired, SceneData}]),
            %% 更新协助boss状态
            lib_guild_assist:update_bl_state(NewPs),
            {ok, NewPs};
        _ ->
            {false, ?ERRCODE(err460_no_boss_type)}
    end.

%% 每日清理在线玩家的数据
daily_clear() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [daily_clear_helper(E#ets_online.id) || E <- OnlineRoles].
daily_clear_helper(RoleId) ->
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    NowTime = utime:unixtime(),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, update_role_boss_midnight, [BossType]),
    db_role_boss_update(RoleId, BossType, 0, 0, NowTime).

update_role_boss_midnight(Ps, BossType) ->
    NowTime = utime:unixtime(),
    #player_status{status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss} = Ps,

    % 次数购买刷新
    case maps:get(BossType, TmpMap, []) of
        #role_boss{} = TemRoleBoss ->
            RoleBoss = TemRoleBoss#role_boss{buy_count = 0, extra_count = 0, stime = NowTime};
        _ ->
            RoleBoss = make_record(role_boss, [BossType, 0, 0, 0, 0, 0, 0, NowTime, 0, 0, 0])
    end,
    NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
    StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
    Ps1 = Ps#player_status{status_boss = StatusBoss},

    % 疲劳值刷新
    {ok, Ps2} = pp_boss:handle(46043, Ps1, [BossType]),

    SceneData = lib_boss_api:make_boss_tired_map(Ps2, BossType),
    mod_scene_agent:update(Ps2, [{scene_boss_tired, SceneData}]),
    {ok, Ps2}.

%%
try_to_updata_senen_data(Ps, BossType) ->
    SceneData = lib_boss_api:make_boss_tired_map(Ps, BossType),
    mod_scene_agent:update(Ps, [{scene_boss_tired, SceneData}]),
    {ok, Ps}.

get_boss_tired(Id) ->
    case data_boss:get_boss_type(?BOSS_TYPE_WORLD) of
        #boss_type{module = _Module, daily_id = _CounterId} ->
            mod_daily:get_count(Id, ?MOD_BOSS, ?MOD_BOSS_TIRE, ?BOSS_TYPE_WORLD);
        _ -> 0
    end.

get_temple_boss_tired(Id) ->
    case data_boss:get_boss_type(?BOSS_TYPE_TEMPLE) of
        #boss_type{module = _Module, daily_id = _CounterId} ->
            mod_daily:get_count(Id, ?MOD_BOSS, ?MOD_BOSS_TIRE, ?BOSS_TYPE_TEMPLE);
        _ -> 0
    end.

get_phantom_boss_tired(Id) ->
    case data_boss:get_boss_type(?BOSS_TYPE_PHANTOM) of
        #boss_type{module = _Module, daily_id = _CounterId} ->
            lib_eudemons_land:get_boss_tired(Id);
        _ -> 0
    end.

%% 检查踢出蛮荒禁地和上古神庙
change_add_anger_out(Ps, BossType, _BossId, OtherMap) ->
    if
        BossType =/= ?BOSS_TYPE_FORBIDDEN andalso BossType =/= ?BOSS_TYPE_TEMPLE andalso BossType =/= ?BOSS_TYPE_DOMAIN ->
            Ps;
        true ->
            #player_status{id = RoleId, scene = SceneId, x = OldX, y = OldY} = Ps,
            FbdScenes = data_boss:get_boss_type_scene(BossType),
            case lists:member(SceneId, FbdScenes) of
                false -> Ps;
                true ->
                    NowTime = utime:unixtime(),
                    StayTime = case maps:get({enter_time, BossType, SceneId, RoleId}, OtherMap, false) of
                                   EnterTime when is_integer(EnterTime) andalso EnterTime > 0 -> NowTime - EnterTime;
                                   _ -> 0
                               end,
                    if
                        StayTime > 0 ->
                            lib_boss:add_exit_log(Ps, BossType, 2, SceneId, OldX, OldY, StayTime),
                            lib_scene:change_scene(Ps, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim, 1}]);
                        true ->
                            ?ERR("Error BossType:~p, SceneId:~p, StayTime: ~p", [BossType, SceneId, StayTime])
                    end
            end
    end.

%% 是不是在boss场景:排除给人boss
is_in_boss(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = SceneType} ->
			if
				SceneType == ?SCENE_TYPE_WORLD_BOSS;
				SceneType == ?SCENE_TYPE_TEMPLE_BOSS;
				SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS;
				SceneType == ?SCENE_TYPE_SUIT_BOSS;
				SceneType == ?SCENE_TYPE_HOME_BOSS;
				SceneType == ?SCENE_TYPE_OUTSIDE_BOSS;
				SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS;
				SceneType == ?SCENE_TYPE_FEAST_BOSS;
				SceneType == ?SCENE_TYPE_ABYSS_BOSS;
                SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS;
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER;
                SceneType == ?SCENE_TYPE_WORLD_BOSS_PER;
                SceneType == ?SCENE_TYPE_DOMAIN_BOSS ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

%% boss之家才需要判断拾取等级
is_in_boss_drop(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_HOME_BOSS ->
            true;
        _ ->
            false
    end.

%% 判断是不是在本服的Boss场景类型
is_in_all_boss(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = SceneType} ->
			if
				SceneType == ?SCENE_TYPE_WORLD_BOSS;
				SceneType == ?SCENE_TYPE_TEMPLE_BOSS;
				SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS;
				SceneType == ?SCENE_TYPE_SUIT_BOSS;
				SceneType == ?SCENE_TYPE_HOME_BOSS;
				SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS;
				SceneType == ?SCENE_TYPE_OUTSIDE_BOSS;
				SceneType == ?SCENE_TYPE_ABYSS_BOSS;
				SceneType == ?SCENE_TYPE_FEAST_BOSS;
				SceneType == ?SCENE_TYPE_PHANTOM_BOSS;
                SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS;
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER;
                SceneType == ?SCENE_TYPE_WORLD_BOSS_PER;
                SceneType == ?SCENE_TYPE_DOMAIN_BOSS ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

%% 根据场景判断Boss类型
get_boss_type_by_scene(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = SceneType} ->
			if
				SceneType == ?SCENE_TYPE_WORLD_BOSS ->
					?BOSS_TYPE_WORLD;
				SceneType == ?SCENE_TYPE_TEMPLE_BOSS ->
					?BOSS_TYPE_TEMPLE;
				SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS ->
					?BOSS_TYPE_FORBIDDEN;
				SceneType == ?SCENE_TYPE_SUIT_BOSS ->
					?BOSS_TYPE_FORBIDDEN;
				SceneType == ?SCENE_TYPE_HOME_BOSS ->
					?BOSS_TYPE_HOME;
				SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS ->
					?BOSS_TYPE_FAIRYLAND;
				SceneType == ?SCENE_TYPE_OUTSIDE_BOSS ->
					?BOSS_TYPE_OUTSIDE;
				SceneType == ?SCENE_TYPE_ABYSS_BOSS ->
					?BOSS_TYPE_ABYSS;
				SceneType == ?SCENE_TYPE_PHANTOM_BOSS ->
					?BOSS_TYPE_PHANTOM;
				SceneType == ?SCENE_TYPE_FEAST_BOSS ->
					?BOSS_TYPE_FEAST;
                SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS ->
                    ?BOSS_TYPE_NEW_OUTSIDE;
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS ->
                    ?BOSS_TYPE_SPECIAL;
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER ->
                    ?BOSS_TYPE_PHANTOM_PER;
                SceneType == ?SCENE_TYPE_DOMAIN_BOSS ->
                    ?BOSS_TYPE_DOMAIN;
                SceneType == ?SCENE_TYPE_EUDEMONS_BOSS ->
                    ?BOSS_TYPE_PHANTOM;
                SceneType == ?SCENE_TYPE_WORLD_BOSS_PER ->
                    ?BOSS_TYPE_WORLD_PER;
                SceneType == ?SCENE_TYPE_KF_GREAT_DEMON ->
                    ?BOSS_TYPE_KF_GREAT_DEMON;
                true ->
                    ?ERR("boss cfg err scene ~p!~n", [Scene]),
                    0
            end;
        _ ->
            ?ERR("boss cfg err scene ~p!~n", [Scene]),
            0
    end.

%% 是不是在蛮荒禁地 或 秘境领域
is_in_forbdden_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
                SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS -> true;  %%   蛮荒BOSS场景
                SceneType == ?SCENE_TYPE_DOMAIN_BOSS -> true;
            %%                SceneType == ?SCENE_TYPE_SUIT_BOSS ->true ;
                true -> false
            end;
        _ -> false
    end.

%% 是不是秘境领域
is_in_domain_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
            %%         秘境领域BOSS场景
                SceneType == ?SCENE_TYPE_DOMAIN_BOSS -> true;
                true -> false
            end;
        _ -> false
    end.


%% 是不是在世界boss场景
is_in_world_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_WORLD_BOSS} -> true;
        _ -> false
    end.

%% 是不是在上古神庙场景
is_in_temple_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_TEMPLE_BOSS} -> true;
        _ -> false
    end.

%% 是不是在野外boss场景
is_in_outside_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_OUTSIDE_BOSS} -> true;
        _ -> false
    end.

%% 是不是在新野外boss场景
is_in_new_outside_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_NEW_OUTSIDE_BOSS} -> true;
        _ -> false
    end.

%% 是不是在新野外boss场景
is_in_special_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SPECIAL_BOSS} -> true;
        _ -> false
    end.

%% 是不是野外boss
is_in_abyss_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_ABYSS_BOSS} -> true;
        _ -> false
    end.
%% 是不是秘境boss
is_in_fairy_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_FAIRYLAND_BOSS} -> true;
        _ -> false
    end.
%% 是不是幻兽领
is_in_phantom_boss(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = ?SCENE_TYPE_PHANTOM_BOSS} ->
			true;
		_ ->
			false
	end.
%% 是不是跨服秘境大妖
is_in_kf_great_demon_boss(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_KF_GREAT_DEMON} ->
            true;
        _ ->
            false
    end.

%% 是不是节日boss
is_in_feast_boss(Scene) ->
	case data_scene:get(Scene) of
		#ets_scene{type = ?SCENE_TYPE_FEAST_BOSS} ->
			true;
		_ ->
			false
	end.

% 获取进入的最大次数限制
get_entertimes_limit(BossType) ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{tired = Count} ->
            Count;
        true -> 0
    end.

%% boss的消耗
get_boss_consume_type(BossType) ->
    if
        BossType == ?BOSS_TYPE_HOME -> boss_home;
        BossType == ?BOSS_TYPE_FORBIDDEN -> boss_forbidden;
        BossType == ?BOSS_TYPE_TEMPLE -> boss_temple;
        BossType == ?BOSS_TYPE_ABYSS -> boss_abyss;
        BossType == ?BOSS_TYPE_OUTSIDE -> boss_outside;
        BossType == ?BOSS_TYPE_DOMAIN -> boss_domain;
        BossType == ?BOSS_TYPE_KF_GREAT_DEMON -> kf_great_demon_boss;
        true -> boss_unkown
    end.

%% -------- 获取采集次数上限
get_boss_collect_times_max(?BOSS_TYPE_PHANTOM) ->
	2;
get_boss_collect_times_max(_BossType) ->
	0.

%% 检查是不是在首领和幻兽之域
%% check_all_boss_scene(Scene) ->
%%     InWorldOrHomeBoss = is_in_boss_drop(Scene),
%%     InEudemonsBoss = lib_eudemons_land:is_in_eudemons_boss(Scene),
%%     InForbBoss = is_in_forbdden_boss(Scene),
%%     IsKfHegemonyScene = lib_kf_hegemony_api:is_kf_hegemony_scene(Scene),
%%     InWorldOrHomeBoss orelse InEudemonsBoss orelse InForbBoss orelse IsKfHegemonyScene.

%% 检查是不是需要触发ai的场景
check_need_ai_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} ->
            if
                % Type == ?SCENE_TYPE_WORLD_BOSS             %% 世界首领
                Type == ?SCENE_TYPE_HOME_BOSS              %% 首领之家
                orelse Type == ?SCENE_TYPE_FORBIDDEB_BOSS  %% 蛮荒禁地
                orelse Type == ?SCENE_TYPE_SUIT_BOSS
                orelse Type == ?SCENE_TYPE_TEMPLE_BOSS     %% 上古神庙
                orelse Type == ?SCENE_TYPE_EUDEMONS_BOSS   %% 幻兽之域
                orelse Type == ?SCENE_TYPE_KF_HEGEMONY     %% 服战
                orelse Type == ?SCENE_TYPE_OUTSIDE_BOSS    %% 野外boss
                orelse Type == ?SCENE_TYPE_FAIRYLAND_BOSS  %% 秘境boss
                orelse Type == ?SCENE_TYPE_PHANTOM_BOSS    %% 幻兽领
	            orelse Type == ?SCENE_TYPE_FEAST_BOSS      %% 节日boss
                orelse Type == ?SCENE_TYPE_NEW_OUTSIDE_BOSS%% 新野外boss
                orelse Type == ?SCENE_TYPE_SPECIAL_BOSS    %% 野外特殊场景
                orelse Type == ?SCENE_TYPE_SANCTUARY       %% 圣域
                orelse Type == ?SCENE_TYPE_KF_SANCTUARY    %% 跨服圣域
                    orelse Type == ?SCENE_TYPE_DECORATION_BOSS  %% 幻饰boss
                    orelse Type == ?SCENE_TYPE_DRAGON_LANGUAGE_BOSS  %% 龙语boss
                orelse Type == ?SCENE_TYPE_ABYSS_BOSS      %% boss之家
                orelse Type == ?SCENE_TYPE_KF_GREAT_DEMON  %% 跨服秘境boss
                    ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

check_collect_times(_MonId, MonCfgId, [RoleId, BossType, _BossId]) ->
    case data_boss:get_boss_cfg(MonCfgId) of
        #boss_cfg{type = _BossType} when BossType == ?BOSS_TYPE_DOMAIN ->
            true;
        #boss_cfg{type = _BossType} when BossType == _BossType ->
            CollectTimes = mod_daily:get_count(RoleId, ?MOD_BOSS, ?MOD_BOSS_COLLECT, BossType),
            CollectTimesMax = lib_boss:get_boss_collect_times_max(BossType),
            case CollectTimes >= CollectTimesMax of
                false -> true;
                _ -> {false, 7}
            end;
        _ -> true
    end.


%% 获取神庙下次怪物刷新时间
get_temple_boss_next_time(BossType, NowTime) when BossType == ?BOSS_TYPE_TEMPLE ->
    case data_boss:get_boss_type(BossType) of
        #boss_type{refresh_time = [{FH, FM} | _] = RTList} ->
            do_get_next_time(RTList, NowTime, {FH, FM});
        _ -> ?ERR(" boss cfg err:~p~n", [BossType]), false
    end.
get_temple_boss_next_time(NowTime)->
    case data_boss:get_boss_type(?BOSS_TYPE_TEMPLE) of
        #boss_type{refresh_time = [{FH, FM} | _] = RTList} ->
            do_get_next_time(RTList, NowTime, {FH, FM});
        _ -> ?ERR(" boss cfg err:~n", []), false
    end.

do_get_next_time([], NowTime, {FH, FM}) ->
    ?ONE_DAY_SECONDS - utime:get_seconds_from_midnight(NowTime) + FH * 3600 + FM * 60;
do_get_next_time([{H, M} | T], NowTime, {FH, FM}) ->
    T1 = utime:get_seconds_from_midnight(NowTime),
    T2 = H * 3600 + M * 60,
    case T1 < T2 of
        true ->
            T2 - T1;
        false ->
            do_get_next_time(T, NowTime, {FH, FM})
    end.

%% 判断神庙内怪物类型
%% 固定Boss fixed_boss|随机Boss rand_boss|精英怪 rare_mon|普通采集怪 cl_mon|稀有采集怪 rare_cl_mon|小怪 norm_mon
get_temple_mon_type(BossType, BossId) when BossType == ?BOSS_TYPE_TEMPLE ->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{type = BossType, rand_xy = RXYList} ->
            case data_mon:get(BossId) of
                #mon{kind = ?MON_KIND_NORMAL, boss = ?MON_LOCAL_BOSS} ->
                    ?IF(RXYList =:= [], fixed_boss, rand_boss);
                #mon{kind = ?MON_KIND_NORMAL, boss = ?MON_ELITE} -> rare_mon;
                #mon{kind = ?MON_KIND_COLLECT, boss = ?MON_ELITE} -> rare_cl_mon;
                _ -> none
            end;
        _ ->
            case data_mon:get(BossId) of
                #mon{kind = ?MON_KIND_COLLECT, boss = ?MON_NORMAL} -> cl_mon;
                #mon{kind = ?MON_KIND_NORMAL, boss = ?MON_NORMAL} -> norm_mon;
                _ -> none
            end
    end;
get_temple_mon_type(_,_) -> none.

%% 判断幻兽领怪物类型
%% boss : 首领 cl_mon : 采集怪 none：其他
get_phatom_boss_type(BossType, BossId) when BossType == ?BOSS_TYPE_PHANTOM ->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{type = BossType} ->
            case data_mon:get(BossId) of
                #mon{kind = MonKind} when MonKind == ?MON_KIND_COUNT_COLLECT; MonKind == ?MON_KIND_COLLECT ->
                    cl_mon;
                _ -> boss
            end;
        _ ->
           none
    end;
get_phatom_boss_type(_, _) -> none.

%% 判断秘境领域怪物类型
%% boss : 首领 cl_mon : 采集怪 none：其他
get_domain_boss_type(BossType, BossId) when BossType == ?BOSS_TYPE_DOMAIN ->
    case lists:member(BossId, data_boss:get_boss_by_mon_type(?DOMAIN_SPECIAL_BOSS)) of   % 1: 特殊 2 ，宝箱 3 高级宝箱
        true -> sp_boss;
        false ->
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = BossType} ->
                    case data_mon:get(BossId) of
                        #mon{kind = MonKind} when MonKind == ?MON_KIND_COUNT_COLLECT; MonKind == ?MON_KIND_COLLECT ->
                            cl_mon;
                        _ -> boss
                    end;
                _ -> none
            end
    end;
get_domain_boss_type(_, _) -> none.


%% 神庙精英怪生成
%% 以配置的坐标以中心一定半径内生成若干只 总数不超过配置的生成上限

temple_create_rand_mon(_, _, _, XYL, [], Num, _) -> {XYL, Num};
temple_create_rand_mon(rand_boss, BossId, Scene, XYL, LessXYL, Num, MaxNum) ->
    case Num < MaxNum of
        true ->
            {X, Y} = urand:list_rand(LessXYL),
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
            {[{X , Y}|XYL], Num + 1};
        false -> {XYL, Num}
    end;
temple_create_rand_mon(rare_mon, BossId, Scene, XYL, ALLXYL, Num, MaxNum) ->
    case Num < MaxNum of
        true ->
            RL = rec_xy_list(XYL, ALLXYL),
            F = fun({X, Y} , AccL) ->
                        case length([ {X0, Y0} || {X0, Y0} <- RL, X0 == X, Y0 == Y ]) < 3 of
                            true -> [{X, Y}|AccL];
                            false -> AccL
                        end
                end,
            L =  lists:foldl(F, [], ALLXYL),
            case L of
                [] -> {XYL, Num};
                _ ->
                    {X, Y} = urand:list_rand(L),
                    {RX, RY} = umath:rand_point_in_circle(X, Y, 200, 1),
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, RX, RY, 1, 0, 1, []),
                    {[{RX , RY}|XYL], Num + 1}
            end;
        false -> {XYL, Num}
    end;
temple_create_rand_mon(rare_cl_mon, BossId, Scene, XYL, LessXYL, Num, MaxNum) ->
    temple_create_rand_mon(rand_boss, BossId, Scene, XYL, LessXYL, Num, MaxNum).

rec_xy_list(_, []) -> [];
rec_xy_list(RXYL, AXYL) ->
    [begin
         [{_, {NX, NY}}|_] = lists:keysort(1, [ {umath:distance({RX, RY}, {AX, AY}), {AX, AY}} || {AX, AY} <- AXYL ]),
         {NX, NY}
     end ||{RX, RY}  <- RXYL ].

%% 计算体力值
%% @return #role_boss{}
calc_vit(Player, BossType) when
        BossType == ?BOSS_TYPE_OUTSIDE
        ->
    #player_status{status_boss = StatusBoss} = Player,
    #status_boss{boss_map = BossMap} = StatusBoss,
    #role_boss{vit = Vit, last_vit_time = LastVitTime} = RoleBoss = maps:get(BossType, BossMap),
    MaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
    AddVitTime = ?BOSS_TYPE_KV_ADD_VIT_TIME(BossType),
    NowTime = utime:unixtime(),
    AddVit = max(NowTime - LastVitTime, 0) div AddVitTime,
    NewLastVitTime = NowTime - max(NowTime - LastVitTime, 0) rem AddVitTime,
    NewVit = min(Vit+AddVit, MaxVit),
    case NewVit >= MaxVit of
        true -> RoleBoss#role_boss{vit = NewVit, last_vit_time = 0};
        false -> RoleBoss#role_boss{vit = NewVit, last_vit_time = NewLastVitTime}
    end;
calc_vit(Player, TBossType) when
        TBossType == ?BOSS_TYPE_NEW_OUTSIDE orelse TBossType == ?BOSS_TYPE_SPECIAL
        ->
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    #player_status{status_boss = StatusBoss} = Player,
    #status_boss{boss_map = BossMap} = StatusBoss,
    RoleBoss = maps:get(BossType, BossMap),
    calc_vit_info(Player, RoleBoss);
calc_vit(Player, BossType) ->
    #player_status{status_boss = StatusBoss} = Player,
    #status_boss{boss_map = BossMap} = StatusBoss,
    maps:get(BossType, BossMap).

%% 计算体力信息
%% @return #role_boss{}
calc_vit_info(Player, #role_boss{boss_type = BossType} = RoleBoss) when
        BossType == ?BOSS_TYPE_NEW_OUTSIDE; BossType == ?BOSS_TYPE_SPECIAL ->
    % 参数
    NowTime = utime:unixtime(),
    #player_status{
        figure = #figure{vip = VipLv, vip_type = VipType}
    } = Player,
    #role_boss{
        vit = Vit0,
        vit_add_today = VitAddToday0,
        vit_can_back = VitCanBack0,
        last_vit_time = LastVitTime0
    } = RoleBoss,

    % 计算玩家恢复一点体力需要的时间
    AddVitTime0 = ?BOSS_TYPE_KV_ADD_VIT_TIME(BossType),
    AddVitTime = vip_reduce_vit_time(Player, AddVitTime0),

    % 玩家可达到的最大体力值
    MaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
    RealMaxVit = MaxVit + VipAddMaxCount,

    % 玩家每天最大可恢复体力值数和最大可找回体力数
    AddVitMax = ?BOSS_TYPE_KV_ADD_VIT_MAX(BossType),
    BackVitMax = ?BOSS_TYPE_KV_BACK_VIT_MAX(BossType),

    % 计算
    case utime_logic:is_logic_same_day(LastVitTime0, NowTime) of
    true -> % 与上次计算处于同一天,计算新的体力值
        if
            Vit0 >= RealMaxVit; VitAddToday0 >= AddVitMax -> % 满体力;恢复体力达上限
                Vit = Vit0,
                VitAddToday = VitAddToday0,
                LastVitTime = NowTime;
            LastVitTime0 == 0 -> % 新创号,体力拉满
                Vit = RealMaxVit,
                VitAddToday = 0,
                LastVitTime = NowTime;
            true -> % 正常体力恢复流程
                AddVit0 = (NowTime - LastVitTime0) div AddVitTime,
                AddVit = lists:min([AddVit0, AddVitMax-VitAddToday0, RealMaxVit-Vit0]),
                Vit = Vit0 + AddVit,
                VitAddToday = VitAddToday0 + AddVit,
                LastVitTime = NowTime - (NowTime - LastVitTime0) rem AddVitTime
        end,
        VitCanBack = VitCanBack0;
    false -> % 与上次计算处于不同天,计算可找回体力值,体力值重置
        DiffDays = utime_logic:logic_diff_days(LastVitTime0, NowTime),
        VitCanBackNoLim = (Vit0 + AddVitMax - VitAddToday0) + (DiffDays - 1) * RealMaxVit,
        % Vit = max(RealMaxVit, Vit0),
        Vit = RealMaxVit, % 超出上限的部分也会重置
        VitAddToday = 0,
        VitCanBack = min(BackVitMax, VitCanBackNoLim),
        LastVitTime = NowTime
    end,

    RoleBoss#role_boss{
        vit = Vit,
        vit_add_today = VitAddToday,
        vit_can_back = VitCanBack,
        last_vit_time = LastVitTime
    };

calc_vit_info(_Player, RoleBoss) ->
    RoleBoss.

%% 找回体力
%% @return @player_status{}
find_back_vit(PS, BossType, VitBackNum, BackVitCost) ->
    % 物品扣除
    {true, PS1} = lib_goods_api:cost_object_list(PS, BackVitCost, 'find_back_vit', ""),

    % 计算新的体力值
    #role_boss{
        vit = Vit0,
        vit_add_today = VitAddToday,
        vit_can_back = VitCanBack0,
        last_vit_time = LastVitTime
    } = RoleBoss0 = calc_vit(PS, BossType),
    Vit = Vit0 + VitBackNum,
    VitCanBack = VitCanBack0 - VitBackNum,
    RoleBoss = RoleBoss0#role_boss{vit = Vit, vit_can_back = VitCanBack},

    % 保存
    #player_status{id = RoleId, sid = SId, status_boss = StatusBoss0} = PS1,
    #status_boss{boss_map = BossMap} = StatusBoss0,
    StatusBoss = StatusBoss0#status_boss{boss_map = maps:put(BossType, RoleBoss, BossMap)},
    PS2 = PS1#player_status{status_boss = StatusBoss},
    db_role_boss_replace(RoleId, RoleBoss),

    % 更新场景体力信息
    SceneData = lib_boss_api:make_boss_tired_map(PS2, BossType),
    mod_scene_agent:update(PS2, [{scene_boss_tired, SceneData}]),

    % 反馈客户端
    {MaxVit, _} = lib_boss_api:get_new_outside_boss_maxtired(PS2),
    lib_server_send:send_to_sid(SId, pt_460, 46044, [Vit, MaxVit, VitAddToday, VitCanBack, LastVitTime]),

    PS2.

%% 离开定时器
leave_ref(Player, BossType, _BossId, StayTime) ->
    #player_status{scene = SceneId, x = OldX, y = OldY} = Player,
    BossScenes = data_boss:get_boss_type_scene(BossType),
    case lists:member(SceneId, BossScenes) of
        true ->
            add_exit_log(Player, BossType, 1, SceneId, OldX, OldY, StayTime),
            lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 1}]);
        false -> Player
    end.

%% 掉落
mon_drop(Player, FirstId, MonArgs, BossType, BossId) when BossType == ?BOSS_TYPE_OUTSIDE ->%;BossType == ?BOSS_TYPE_NEW_OUTSIDE;BossType == ?BOSS_TYPE_SPECIAL ->
    #player_status{id = RoleId} = Player,
    case cost_af_result(Player, BossType, BossId) of
        {false, _ErrorCode, NewPlayer} ->
            {ok, NewPlayer};
        {true, NewPlayer} ->
            % 自己的归属
            case FirstId == RoleId of
                true -> Alloc = ?ALLOC_SINGLE;
                false -> Alloc = ?ALLOC_SINGLE_2
            end,
            % 是否有掉落规则
            AllocList = data_drop:get_rule_list(BossId),
            DropPs = case lists:member(Alloc, AllocList) of
                true -> lib_goods_drop:handle_drop_list(NewPlayer, MonArgs, Alloc, 0, [], []);
                false -> NewPlayer
            end,
            {ok, TaskDropPs} = lib_task_drop:handle_task_drop_list(DropPs, MonArgs#mon_args.scene, MonArgs#mon_args.mid, Alloc),
            LastPs = lib_goods_drop:handle_other_drop_list(TaskDropPs, MonArgs, Alloc, 0, []),
            lib_task_api:kill_boss(RoleId, BossType, MonArgs#mon_args.lv),
            {ok, LastPs}
    end;
% mon_drop(Player, FirstId, MonArgs, BossType, BossId) when BossType == ?BOSS_TYPE_ABYSS ->
%     #player_status{id = RoleId, scene = _SceneId, scene_pool_id = _ScenePoolId, figure = _Figure} = Player,
%     % 自己的归属
%     case FirstId == RoleId of
%         true ->
%             % {ok, BinData} = pt_460:write(46030, [RoleId, Figure]),
%             % lib_server_send:send_to_scene(SceneId, ScenePoolId, BinData),
%             Alloc = ?ALLOC_SINGLE;
%         false ->
%             Alloc = ?ALLOC_SINGLE_2
%     end,
%     % 是否有掉落规则
%     AllocList = data_drop:get_rule_list(BossId),
%     DropPs = case lists:member(Alloc, AllocList) of
%         true -> lib_goods_drop:handle_drop_list(Player, MonArgs, Alloc, 0, [], []);
%         false -> Player
%     end,
%     {ok, TaskDropPs} = lib_task_drop:handle_task_drop_list(DropPs, MonArgs#mon_args.scene, MonArgs#mon_args.mid, Alloc),
%     LastPs = lib_goods_drop:handle_other_drop_list(TaskDropPs, MonArgs, Alloc, 0, []),
%     lib_task_api:kill_boss(RoleId, BossType, MonArgs#mon_args.lv),
%     {ok, LastPs};
mon_drop(Player, FirstId, MonArgs, BossType, BossId) when BossType == ?BOSS_TYPE_FAIRYLAND ->
    #player_status{id = RoleId} = Player,
    % 自己的归属
    case FirstId == RoleId of
        true ->
            %%日常
            mod_boss:handle_activitycalen_kill(RoleId, BossType), %%归属才能完成日常
            Alloc = ?ALLOC_SINGLE;
        false -> Alloc = ?ALLOC_SINGLE_2
    end,
    % 是否有掉落规则
    AllocList = data_drop:get_rule_list(BossId),
    DropPs = case lists:member(Alloc, AllocList) of
        true -> lib_goods_drop:handle_drop_list(Player, MonArgs, Alloc, 0, [], []);
        false -> Player
    end,
    {ok, TaskDropPs} = lib_task_drop:handle_task_drop_list(DropPs, MonArgs#mon_args.scene, MonArgs#mon_args.mid, Alloc),
    LastPs = lib_goods_drop:handle_other_drop_list(TaskDropPs, MonArgs, Alloc, 0, []),
    lib_task_api:kill_boss(RoleId, BossType, MonArgs#mon_args.lv),
    {ok, LastPs};
mon_drop(Player, _FirstId, _MonArgs, _BossType, _BossId) ->
    {ok, Player}.

%% 出结算后扣除
cost_af_result(Player, BossType, BossId) ->
    #role_boss{vit = CalcVit, last_vit_time = NewLastVitTime} = RoleBoss = calc_vit(Player, BossType),
    CostVit = ?BOSS_TYPE_KV_COST_VIT(BossType),
    case CalcVit >= CostVit of
        true ->
            #player_status{id = RoleId, status_boss = StatusBoss} = Player,
            #status_boss{boss_map = BossMap} = StatusBoss,
            case NewLastVitTime == 0 of
                true -> NewLastVitTime2 = utime:unixtime();
                false -> NewLastVitTime2 = NewLastVitTime
            end,
            NewRoleBoss = RoleBoss#role_boss{vit = CalcVit-CostVit, last_vit_time = NewLastVitTime2},
            NewStatusBoss = StatusBoss#status_boss{boss_map = maps:put(BossType, NewRoleBoss, BossMap)},
            NewPlayer = Player#player_status{status_boss = NewStatusBoss},
            SceneData = lib_boss_api:make_boss_tired_map(NewPlayer, BossType),
            mod_scene_agent:update(NewPlayer, [{scene_boss_tired, SceneData}]),
            db_role_boss_replace(RoleId, NewRoleBoss),
            log_boss_cost(NewPlayer, Player, 1, BossType, BossId, []),
            {true, NewPlayer};
        false ->
            CheckCost = lib_goods_api:check_object_list(Player, ?BOSS_TYPE_KV_COST_TICKET(BossType)),
            case CheckCost == true of
                true ->
                    About = lists:concat(["BossType", BossType, "BossId", BossId]),
                    ConsumeType = get_boss_consume_type(BossType),
                    case lib_goods_api:cost_object_list(Player, ?BOSS_TYPE_KV_COST_TICKET(BossType), ConsumeType, About) of
                        {false, ErrorCode, NewPlayer} -> {false, ErrorCode, NewPlayer};
                        {true, NewPlayer} ->
                            log_boss_cost(NewPlayer, Player, 1, BossType, BossId, ?BOSS_TYPE_KV_COST_TICKET(BossType)),
                            {true, NewPlayer}
                    end;
                false ->
                    {false, ?ERRCODE(err460_not_enough_ticket_to_result), Player}
            end
    end.

%% 发送首次奖励
%% @return {true|false(是否有奖励), Player, 奖励}
send_first_reward(#player_status{id = RoleId, figure = #figure{name = Name}} = Player, ObjectScene, BossId) ->
    case data_boss:get_boss_cfg(BossId) of
        [] -> {false, Player, []};
        #boss_cfg{first_award = []} -> {false, Player, []};
        #boss_cfg{first_award = FirstAward} ->
            Count = mod_counter:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, BossId),
            case Count == 0 of
                true ->
                    Reward = lib_goods_api:calc_reward(Player, FirstAward),
                    mod_counter:increment(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, BossId),
                    Remark = lists:concat(["BossId:", BossId]),
                    Produce = #produce{type = boss_first_award, reward = Reward, show_tips = ?SHOW_TIPS_3, remark = Remark},
                    {ok, _, NewPlayer, UpGoodsList} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
                    % 获得唯一键
                    SeeRewardL = lib_goods_api:make_see_reward_list(Reward, UpGoodsList),
                    BossType = lib_boss:get_boss_type_by_scene(ObjectScene),
                    lib_boss_api:boss_add_drop_log(RoleId, Name, ObjectScene, BossType, BossId, SeeRewardL, UpGoodsList),
                    {true, NewPlayer, SeeRewardL};
                false ->
                    {false, Player, []}
            end
    end.

updata_boss_info(Ps) ->
    mod_scene_agent:update(Ps, [{fairyland_tired, 0}]).

%% 秘籍创建boss
gm_create_local_boss(BossId)->
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{type = BossType, scene = Scene, x = X, y = Y} ->
            lib_mon:clear_scene_mon_by_mids(Scene, 0, 0, 1, [BossId]),
            MonName = lib_mon:get_name_by_mon_id(BossId),
            SceneName = lib_scene:get_scene_name(Scene),
            lib_chat:send_TV({all}, 460, 2, [MonName, SceneName, Scene, X, Y, BossType]),
            %% lib_scene_object:async_create_object(1, 1301003, 1301, 0, 4530, 4060, 1, 0, 1, []).
            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []);
        _ ->
            skip
    end.

%% 1:结算消耗2:进入消耗
log_boss_cost(Player, OldPlayer, Type, BossType, BossId, Cost) ->
    #player_status{id = RoleId, figure = #figure{vip = VipLv}, team = #status_team{team_id = TeamId}} = OldPlayer,
    #role_boss{vit = Vit, last_vit_time = LastVitTime} = calc_vit(Player, BossType),
    #role_boss{vit = BeforeVit, last_vit_time = BeforeLastVitTime} = calc_vit(OldPlayer, BossType),
    lib_log_api:log_boss_cost(RoleId, TeamId, VipLv, Type, BossType, BossId, BeforeVit, BeforeLastVitTime, Vit, LastVitTime, Cost),
    ok.

%%目前用于圣域
update_role_boss(Ps, BossType, NextEnterTime, DieTime, DieTimes) ->
    #player_status{id = RoleId, status_boss = #status_boss{boss_map = BossMap} = OldStatusBoss, last_login_time = LastLoginTime} = Ps,
    case maps:get(BossType, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss ,role_boss) ->
            NewRoleBoss = TemRoleBoss#role_boss{next_enter_time = NextEnterTime, die_time = DieTime,
                die_times = DieTimes};
        _ ->
            NewRoleBoss = make_record(role_boss, [BossType, 0, 0, 0, 0, 0, 0, LastLoginTime, NextEnterTime, DieTime, DieTimes])
    end,
    db_role_boss_replace(RoleId, NewRoleBoss),
    NewBossMap = maps:put(BossType, NewRoleBoss, BossMap),
    {ok, Ps#player_status{status_boss = OldStatusBoss#status_boss{boss_map = NewBossMap}}}.

update_role_boss(Ps, BossType, DieTime) ->
    #player_status{
        id = RoleId,
        status_boss = #status_boss{boss_map = BossMap} = OldStatusBoss,
        last_login_time = LastLoginTime
    } = Ps,

    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, player_die_times) of
        TimeCfg when is_integer(TimeCfg) andalso TimeCfg > 0 -> TimeCfg;
        _ -> TimeCfg = 300
    end,
    case data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost) of
        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
        _ -> TimeCfg2 = 20
    end,
    % NewList = get_real_die_time_list(BeKillTime, TimeCfg, NowTime),

    case maps:get(BossType, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss ,role_boss) ->
            #role_boss{die_time = LastDieTime, die_times = LastDieTimes} = TemRoleBoss,
            if
                LastDieTime + TimeCfg < DieTime ->
                    {RebornTime, MinTimes} =lib_boss_mod:count_die_wait_time(1, DieTime),
                    DieTimes = 1,
                    NewRoleBoss = TemRoleBoss#role_boss{next_enter_time = RebornTime, die_time = DieTime,
                            die_times = DieTimes};
                true ->
                    {RebornTime, MinTimes} = lib_boss_mod:count_die_wait_time(LastDieTimes+1, DieTime),
                    DieTimes = LastDieTimes + 1,
                    NewRoleBoss = TemRoleBoss#role_boss{next_enter_time = RebornTime, die_time = DieTime,
                            die_times = LastDieTimes+1}
            end;

        _ ->
            {RebornTime, MinTimes} =lib_boss_mod:count_die_wait_time(1, DieTime),
            DieTimes = 1,
            NewRoleBoss = make_record(role_boss, [BossType, 0, 0, 0, 0, 0, 0, LastLoginTime, RebornTime, DieTime, 1])
    end,
    if
        DieTimes > MinTimes ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, RebornTime, DieTime + TimeCfg, DieTime + TimeCfg2]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, RebornTime, DieTime + TimeCfg, 0])
    end,
    db_role_boss_replace(RoleId, NewRoleBoss),
    NewBossMap = maps:put(BossType, NewRoleBoss, BossMap),
    {ok, Ps#player_status{status_boss = OldStatusBoss#status_boss{boss_map = NewBossMap}}}.

%% 数据库
db_role_boss_select(RoleId, BossType) ->
    Sql = io_lib:format(?sql_role_boss_select, [RoleId, BossType]),
    db:get_all(Sql).

db_role_boss_replace(RoleId, RoleBoss) ->
    #role_boss{boss_type = BossType, vit = Vit, vit_add_today = VitAddToday, vit_can_back = VitCanBack, last_vit_time = LastVitTime,
        buy_count = BuyCount, die_times = DieTimes, extra_count = ExtraCount, stime = STime, next_enter_time = NextEnterTime, die_time = DieTime} = RoleBoss,
    Sql = io_lib:format(?sql_role_boss_replace, [RoleId, BossType, Vit, VitAddToday, VitCanBack, LastVitTime, BuyCount, ExtraCount, STime,
        NextEnterTime, DieTime, DieTimes]),
    db:execute(Sql).

db_role_boss_update(RoleId, BossType, BuyCount, ExtraCount, STime) ->
    Sql = io_lib:format(?sql_role_boss_update, [BuyCount, ExtraCount, STime, RoleId, BossType]),
    db:execute(Sql).
%%===========================================================================================
%%                                 世界boss
%%===========================================================================================

get_wldboss_cfg() ->
    case data_activitycalen:get_ac(?MOD_BOSS,?BOSS_TYPE_WORLD,1) of
        #base_ac{week = OpenDayList,time_region = OpenTime,open_day = ServerOpenDay} ->skip;
        _ -> OpenDayList = [],OpenTime = [],ServerOpenDay = [{0,0}]
    end,
    {OpenTime, OpenDayList, ServerOpenDay}.

daily_icon_control(Ps) ->
    NowTime = utime:unixtime(),
    Day = utime:day_of_week(),
    OpenDay = util:get_open_day(),
    {_,OpenDayList, [{Min,Max}]} = get_wldboss_cfg(),
    #figure{lv = Lv} = Ps#player_status.figure,
    OpenLv = lib_module:get_open_lv(?MOD_BOSS, ?BOSS_TYPE_WORLD),
    IsLimit = if
        Lv >= OpenLv andalso OpenDay >= Min andalso OpenDay =< Max ->
            true;
        true ->
            false
    end,
    % OpenDayList = data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD,world_begin_day),%%获取周几开启活动
    case IsLimit andalso lists:member(Day, OpenDayList) of
        true ->
            IsOpenHour = is_open_hour(),
            if
                IsOpenHour == true ->
                    erlang:send_after(1000, mod_boss, {'wldboss_enter_icon', Ps#player_status.sid});
                true ->
                    {true, BossBronTime} = get_wldboss_borntime(NowTime),
                    RealSendT = max(2, BossBronTime - ?WLDBOSS_ENTER_ICON_TIME),
                    erlang:send_after(RealSendT * 1000, mod_boss, {'wldboss_enter_icon', Ps#player_status.sid})
             end;
        false->
            {ok, BinData} = pt_460:write(46017, [0]),
            lib_server_send:send_to_sid(Ps#player_status.sid, BinData)
    end.

%%


%%是否是世界boss开放时间段
is_open_hour() ->
    NowTime = utime:unixtime(),
    is_open_hour(NowTime).
is_open_hour(NowTime) ->
    Day = utime:day_of_week(NowTime),
    % OpenDayList = data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD,world_begin_day),
    {OpenTime,OpenDayList,_} = get_wldboss_cfg(),
    case lists:member(Day, OpenDayList) of
        true ->
            % OpenTime = data_boss:get_boss_type_kv(1,world_start_end_time),
            {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
            Tem = NowSH * 60 + NowSM,
            Fun = fun({{SH, SM},{EH,EM}}) ->
                % ?PRINT("Tem:~p,SH * 60 +SM:~p,EH * 60 + EM:~p~n",[Tem, SH * 60 +SM, EH * 60 + EM]),
                SH * 60 +SM =< Tem andalso Tem < EH * 60 + EM
            end,
            % ?PRINT("ulists:find(Fun, OpenTime)::~p~n",[ulists:find(Fun, OpenTime)]),
            case ulists:find(Fun, OpenTime) of
                {ok,_} ->
                    true;
                _ ->
                    false
            end;
        false ->
            false
    end.
%%获得世界boss生成时间(s)
get_wldboss_borntime(NowTime) ->
    Day = utime:day_of_week(NowTime),
    % OpenDayList = data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD,world_begin_day),
    % OpenList = data_boss:get_boss_type_kv(1,world_start_end_time),
    {OpenList,OpenDayList,_} = get_wldboss_cfg(),
    [{{Sh, Sm}, _EndT}|_] = OpenList,
    {Date, _Time} = utime:unixtime_to_localtime(NowTime),
    % StartTime = utime:unixtime({Date, {Sh, Sm,0}}),
    % {{LastSh,LastSm}, _LastEnd} = lists:last(OpenList),
    DisTime = get_next_open_time(Day,0,OpenDayList),
    case lists:member(Day, OpenDayList) of
        true ->
            {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
            case get_next_time({NowSH, NowSM}, OpenList) of %%获取开启时间段中第一个开启时间大于nowtime的时间
                {ok, {{SH, SM}, _}} ->
                    TemStartT = utime:unixtime({Date, {SH, SM,0}}),
                    {true, TemStartT -NowTime};
                _ ->
                    {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
                    RealStartT = utime:unixtime({Date1, {Sh, Sm,0}}),
                    {true, RealStartT -NowTime}
            end;
        false ->
            {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
            RealStartT = utime:unixtime({Date1, {Sh, Sm,0}}),
            {true, RealStartT -NowTime}
    end.

get_wldboss_endtime(NowTime) ->
    Day = utime:day_of_week(NowTime),
    % OpenDayList = data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD,world_begin_day),
    % OpenList = data_boss:get_boss_type_kv(1,world_start_end_time),
    {OpenList,OpenDayList,_} = get_wldboss_cfg(),
    [{_, {Eh,Em}}|_] = OpenList,
    {Date, _Time} = utime:unixtime_to_localtime(NowTime),
    % EndTime = utime:unixtime({Date, {Eh, Em,0}}),
    % {{LastSh,LastSm}, _LastEnd} = lists:last(OpenList),
    DisTime = get_next_open_time(Day,0,OpenDayList),
    case lists:member(Day, OpenDayList) of
        true ->
            {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
            case get_next_end_time({NowSH, NowSM}, OpenList) of %%获取开启时间段中第一个关闭时间大于nowtime的时间
                {ok, {_, {EH,EM}}} ->
                    TemStartT = utime:unixtime({Date, {EH, EM,0}}),
                    {true, TemStartT -NowTime};
                _ ->
                    {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
                    RealStartT = utime:unixtime({Date1, {Eh, Em,0}}),
                    {true, RealStartT -NowTime}
            end;
        false ->
            {Date1, _Time1} = utime:unixtime_to_localtime(NowTime + DisTime),
            RealStartT = utime:unixtime({Date1, {Eh, Em,0}}),
            {true, RealStartT -NowTime}
    end.

get_next_open_time(Day, TempTime,OpenDayList) ->%%距离下一个开放日的时间差距（s）
    case Day + 1 =< 7 of
        true ->
            case lists:member(Day+1, OpenDayList) of
                true ->
                    TempTime+86400;
                false ->
                    get_next_open_time(Day+1, TempTime+86400,OpenDayList)
            end;
        false ->
            get_next_open_time(0, TempTime, OpenDayList)
    end.

get_next_time({TemSH, TemSM}, OpenList) ->
    Tem = TemSH * 60 + TemSM,
    Fun = fun({{SH, SM}, _}) ->
        Tem < SH * 60 + SM
    end,
    ulists:find(Fun, OpenList).%%返回第一个比TemS大的活动开启时间(如果存在)

get_next_end_time({TemSH, TemSM}, OpenList) ->
    Tem = TemSH * 60 + TemSM,
    Fun = fun({_, {Eh,Em}}) ->
        Tem < Eh * 60 + Em
    end,
    ulists:find(Fun, OpenList).

do_inspire_self(Player, SkillType,InspireType, InspireList, OldInspireList) ->
    #player_status{id = RoleId} = Player,
    [{?INSPIRE_TYPE1, Num1},{?INSPIRE_TYPE2,Num2}] = InspireList,
    Cost = case InspireType == 1 of
        true ->
            data_boss:get_boss_type_kv(1,world_updamage1_cost);
        false ->
            data_boss:get_boss_type_kv(1,world_updamage2_cost)
    end,
    Inspire1Max = data_boss:get_boss_type_kv(1,world_upway1_times),
    Inspire2Max = data_boss:get_boss_type_kv(1,world_upway2_times),
    case lib_goods_api:cost_object_list_with_check(Player, Cost, worldboss_encourage, "") of
        {true, NewPlayer} ->
            lib_server_send:send_to_uid(RoleId, pt_460, 46020, [1, Inspire1Max-Num1, Inspire2Max-Num2]),
            NewPlayer1 = lib_goods_buff:add_skill_buff(NewPlayer, SkillType, Num1 + Num2 + 1, ?BUFF_SKILL_NO),
            mod_boss:setup_inspire_count(RoleId, InspireList),
            {ok, NewPlayer1};
        {false, _Code, _} ->
            if
                InspireType == 1 ->
                    %?PRINT("coin_not_enough ,InspireType:~p~n",[InspireType]),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46020,
                        [?ERRCODE(coin_not_enough), Inspire1Max-Num1, Inspire2Max-Num2]);
                true ->
                    %?PRINT("gold_not_enough ,InspireType:~p~n",[InspireType]),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46020,
                        [?ERRCODE(gold_not_enough), Inspire1Max-Num1, Inspire2Max-Num2])
            end,
            mod_boss:setup_inspire_count(RoleId, OldInspireList),
            {ok, Player}
    end.


quit_world_boss(Player, SkillId) ->
    NewPlayer = lib_goods_buff:remove_skill_buff(Player, SkillId),
    {ok, NewPlayer}.

quit_world_boss_timeout(Ps, BossType)->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, x = OldX, y = OldY} = Ps,
    case lib_boss:is_in_all_boss(SceneId) of
        false -> skip;
        true ->
            mod_boss:quit(RoleId, BossType, CopyId, SceneId, OldX, OldY),
            if
                BossType == ?BOSS_TYPE_WORLD ->
                    {ok, NewPlayer} = lib_boss:quit_world_boss(Ps, ?INSPIRE_SKILL_ID);
                true ->
                    NewPlayer = Ps
            end,
            NewPs = lib_scene:change_scene(NewPlayer, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}]),
            {ok, NewPs}
    end.
% rank_damage(Player, Name, NewRankList, NeedSendL) ->
%     Fun = fun({N, H}, {Sum, HurtN, PerHurt, Rank}) ->
%         case N =/= Name of
%             true -> {Sum+1, HurtN, H, Rank};
%             false ->
%                 {Sum, H, PerHurt, Sum}
%         end
%     end,
%     {_Count, RHurt, PHurt, RealRank} = lists:foldl(Fun, {1,0,0,0}, NewRankList),
%     Distance = max(PHurt-RHurt, 0),
%     lib_server_send:send_to_uid(Player#player_status.id, pt_460, 46019, [RealRank, RHurt, Name, Distance, NeedSendL]),
%     {ok, Player}.

%%重连
%是否在boss场景
%活动是否结束
%boss是否死亡
reconnect(#player_status{id = RoleId, figure = Figure, pid = Pid, scene = SceneId, last_logout_time = LastLogoutTime} = Player, _Reconnect) ->
    NowTime = utime:unixtime(),
    IsSameDay = utime:is_same_date(LastLogoutTime, NowTime),
    case is_in_world_boss(SceneId) andalso IsSameDay of
        true ->
            case is_worldboss_active_end(NowTime) of
                true ->%%活动结束
                    NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err460_had_on_boss)}]),
                    {ok, NewPlayer};
                false ->%%未结束
                    KilledBoss = get_killed_wldboss_list(),
                    %?PRINT("KilledBoss:~p~n",[KilledBoss]),
                    BossId = get_bossid(Figure#figure.turn,Figure#figure.lv),
                    case lists:member(BossId, KilledBoss) of
                        true ->
                            NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err460_had_on_boss)}]),
                            {ok, NewPlayer};
                        false ->
                            NewPlayer = lib_scene:change_relogin_scene(Player, []),
                            mod_boss:get_inspire_count(NewPlayer#player_status.id),
                            mod_boss:add_inspire_buff(RoleId,Pid),
                            pp_boss:handle(46022, NewPlayer, [?BOSS_TYPE_WORLD, BossId]),
                            {ok, NewPlayer}
                    end
            end;
        false->
            % NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err460_had_on_boss)}]),
            {next, Player}
    end.
get_wldboss_status() ->
    KillWldBoss = lib_boss:get_killed_wldboss_list(),
    ShowWldBoss = lib_boss:get_wldBoss_need_show(),%%显示在界面上的boss才会有状态
    %?PRINT("KillWldBoss:~p~n ShowWldBoss:~p~n",[KillWldBoss, ShowWldBoss]),
    Fun = fun(BossId,Acc) ->
        case lists:member(BossId, KillWldBoss) of
            true ->
                [{BossId, 0}|Acc];
            false ->
                [{BossId, 1}|Acc]
        end
    end,
    lists:foldl(Fun, [], ShowWldBoss).

get_killed_wldboss_list() ->
    mod_boss:get_killed_wldboss().

get_all_worldboss_id() ->
    AllBossid = data_boss:get_all_boss_id(),
    Fun =fun(BossId, Acc) ->
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{type = Type, condition = Condition} when Type == ?BOSS_TYPE_WORLD ->
                    [{BossId, Condition}|Acc];
                _ ->
                    Acc
            end
        end,
    lists:foldl(Fun, [], AllBossid).

%%根据转生、等级来获得该玩家可以攻击的世界boss
get_bossid(Turn, _Lv) ->
    WorldBoss = get_all_worldboss_id(),
    % ?PRINT("Turn:~p,Lv:~p,WorldBoss:~p~n",[Turn, Lv,WorldBoss]),
    Fun = fun({BossId, Condition}, Return) ->
        case Condition of
            [{turn, MinT, MaxT}] ->
                if
                    Turn >= MinT andalso Turn =< MaxT ->
                        BossId;
                    true ->
                        Return
                end;
            _ ->
                Return
        end
    end,
    lists:foldl(Fun, 0, WorldBoss).

%%获取入口界面显示的世界boss（可被攻击）
get_wldBoss_need_show() ->
    AllWldBoss = get_all_worldboss_id(),
    Opday = util:get_open_day(),
    Fun = fun({BossId,_},Acc) ->
        case data_boss:get_boss_cfg(BossId) of
            [] -> Acc;
            #boss_cfg{open_day = [{OpDmin, OpDmax}]} ->
                if
                    Opday >= OpDmin andalso Opday =< OpDmax ->
                        % ?PRINT("BossId:~p~n",[BossId]),
                        [BossId|Acc];
                    true ->
                        Acc
                end
        end
    end,
    lists:foldl(Fun, [], AllWldBoss).

do_inspire_reconnect(Player, SkillType, Num) ->
    NewPlayer = lib_goods_buff:add_skill_buff(Player, SkillType, Num),
    {ok, NewPlayer}.

is_worldboss_active_end(NowTime)->
    Day = utime:day_of_week(),
    % OpenDayList = data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD,world_begin_day),
    {OpenTime,OpenDayList,_} = get_wldboss_cfg(),
    case lists:member(Day, OpenDayList) of
        true ->
            % OpenTime = data_boss:get_boss_type_kv(1,world_start_end_time),
            {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
            Tem = NowSH * 60 + NowSM,
            Fun = fun({{SH, SM},{EH,EM}}) ->

                SH * 60 +SM =< Tem andalso Tem =< EH * 60 + EM
            end,
            case ulists:find(Fun, OpenTime) of
                {ok,{_, _}} ->
                    false;
                _ ->
                    true
            end;
        false ->
            true
    end.

send_reward_byrank(Player, Produce,FirstName, FirstHurt, AttrName, Rank, RewardList, BossId,Content,Title) ->
    Lv = Player#player_status.figure#figure.lv,
    Pic = Player#player_status.figure,
    % ?PRINT("FirstName:~p, FirstHurt:~p, AttrName:~p, Rank:~p, Lv:~p, Pic:~p, RewardList:~p~n",
    %     [FirstName, FirstHurt, AttrName, Rank, Lv, Pic, RewardList]),
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene} ->
            if
                Scene == Player#player_status.scene->
                    {ok, Bin} = pt_460:write(46021, [FirstName, FirstHurt, AttrName, Rank, Lv, Pic, RewardList]),
                    lib_server_send:send_to_uid(Player#player_status.id, Bin),
                    NewPlayer = lib_goods_api:send_reward(Player, Produce);
                true ->
                    lib_mail_api:send_sys_mail([Player#player_status.id], Title, Content, RewardList),
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer}.


%% 登出
logout(Player) ->
    case lib_boss:is_in_world_boss(Player#player_status.scene) of
        true ->
            lib_boss:quit_world_boss(Player, ?INSPIRE_SKILL_ID);
        false ->
            skip
    end.

special_boss_logout(Player) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId, scene = Scene, x = OldX, y = OldY} = Player,
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SPECIAL_BOSS} ->
            mod_special_boss:exit(RoleId, ?BOSS_TYPE_SPECIAL, Scene, OldX, OldY);
        #ets_scene{type = ?SCENE_TYPE_PHANTOM_BOSS_PER} ->
            mod_special_boss:exit(RoleId, ?BOSS_TYPE_PHANTOM_PER, Scene, OldX, OldY);
        #ets_scene{type = ?SCENE_TYPE_WORLD_BOSS_PER} ->
            mod_special_boss:exit(RoleId, ?BOSS_TYPE_WORLD_PER, Scene, OldX, OldY);
        _ ->
            skip
    end,
    mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_SPECIAL),
    mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_PHANTOM_PER),
    mod_special_boss:boss_data_remove(RoleId, RoleLv, ?BOSS_TYPE_WORLD_PER),
    Player.

% send_reveive_info(Player) ->
%     case lib_boss:is_in_world_boss(Player#player_status.scene) of
%         true ->
%             case data_boss:get_boss_type_kv(?BOSS_TYPE_WORLD, world_resurgence_time) of
%                 [] -> IsRevive = 0, NextReviveTime = 0;
%                 NextReviveTime -> IsRevive = 1
%             end,
%             {ok, BinData} = pt_200:write(20009, [IsRevive, NextReviveTime]),
%             lib_server_send:send_to_sid(Player#player_status.sid, BinData);
%         false ->
%             skip
%     end.

check_revive(Player, Type) ->
    #player_status{scene = SceneId} = Player,
    IsWlbossScene = is_in_world_boss(SceneId),
    IsFairyScene = is_in_fairy_boss(SceneId),
    IsNewOutSideS = is_in_new_outside_boss(SceneId),
    IsSpecialScene = is_in_special_boss(SceneId),
    IsSanctuaryScene = lib_sanctuary:is_sanctuary_scene(SceneId),
    IsEudemonsScene = lib_eudemons_land:is_in_eudemons_boss(SceneId),
%%    IsForBossScene = is_in_forbdden_boss(SceneId),  消耗时加上
    if
        Type =:= ?REVIVE_WORLD_BOSS ->
            if
                IsWlbossScene ->
                    case data_boss:get_boss_type_kv(1,world_resurgence_cost) of
                        [{MoneyType, Money}] ->
                            {true, MoneyType, Money, revive};
                        _ -> true
                    end;
                IsFairyScene ->
                    case data_boss:get_boss_type_kv(9,fairy_resurgence_cost) of
                        [{MoneyType, Money}] ->
                            {true, MoneyType, Money, revive};
                        _ -> true
                    end;
                IsNewOutSideS orelse IsSpecialScene ->
                    case data_boss:get_boss_type_kv(12,new_outside_resurgence_cost) of
                        [{MoneyType, Money}] ->
                            {true, MoneyType, Money, revive};
                        _ -> true
                    end;
                true ->
                    {false, 5}
            end;
        Type == ?REVIVE_BOSS ->
            if
                IsNewOutSideS orelse IsSpecialScene orelse IsSanctuaryScene orelse IsEudemonsScene ->
                    true;
                true ->
                    {false, 5}
            end;
        true ->
            true
    end.

revive(Player, Type) when Type == ?REVIVE_WLDBOSS_POINT ->
    #player_status{scene = SceneId} = Player,
    IsWlbossScene = lib_boss:is_in_world_boss(SceneId),
    IsFairyScene = is_in_fairy_boss(SceneId),
    IsForScene = is_in_forbdden_boss(SceneId),
    IsNewOutSideS = is_in_new_outside_boss(SceneId),
    IsSpecialScene = is_in_special_boss(SceneId),
    IsDomainScene = is_in_domain_boss(SceneId),
    IsInKfGreatDemon = is_in_kf_great_demon_boss(SceneId),
    if
        IsWlbossScene == true orelse IsFairyScene == true orelse IsForScene == true
            orelse IsNewOutSideS == true orelse IsSpecialScene == true orelse IsDomainScene == true
            orelse IsInKfGreatDemon == true ->
            case data_scene:get(SceneId) of
                #ets_scene{x = X,y = Y} -> ok;
                _ ->
                    ?ERR("world boss revive SceneId:~p~n ", [SceneId]),
                    X = 0,
                    Y = 0
            end;
        true ->
            ?ERR("not in world boss SceneId:~p~n ", [SceneId]),
            X = 0,
            Y = 0
    end,
    {X, Y};
revive(Player, Type) when Type == ?REVIVE_BOSS ->  %%安全区变幽灵/尸体复活
    #player_status{scene = SceneId} = Player,
    IsNewOutSideS = is_in_new_outside_boss(SceneId),
    IsSpecialScene = is_in_special_boss(SceneId),
    IsSanctuaryScene = lib_sanctuary:is_sanctuary_scene(SceneId),
    IsEudemonsScene = lib_eudemons_land:is_in_eudemons_boss(SceneId),
    if
        IsNewOutSideS == true orelse IsSpecialScene == true orelse IsSanctuaryScene == true orelse IsEudemonsScene == true ->
            case data_scene:get(SceneId) of
                #ets_scene{x = X,y = Y} -> ok;
                _ ->
                    ?ERR("boss revive SceneId:~p~n ", [SceneId]),
                    X = 0,
                    Y = 0
            end;
        true ->
            ?ERR("not in boss SceneId:~p~n ", [SceneId]),
            X = 0,
            Y = 0
    end,
    {X, Y};
revive(_, _) -> {0,0}.
%% 场景进程处理
clear_scene_palyer(BossType) ->
    UserList = lib_scene_agent:get_scene_user(),
    [begin
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss, quit_world_boss_timeout, [BossType])
    end|| #ets_scene_user{id = RoleId}<-UserList].

%%===========================================================================================
%%                                 世界boss
%%===========================================================================================

broadcast_role_info(RoleId, ValueList) ->
    {ok, Bin} = pt_460:write(46025, [ValueList]),
    lib_server_send:send_to_uid(RoleId, Bin).

add_exit_log(Ps, BossType, Type, Scene, OldX, OldY, StayTime) -> %%Type:0表示进入，1表示正常退出，2满疲劳退出
    #player_status{id = RoleId,
        figure = #figure{name = RoleName, lv = RoleLv},
        y = Y, x = X,
        team = Team
    } = Ps,
    case Team of
        #status_team{team_id = TeamId} -> skip;
        _ -> TeamId = 0
    end,
    %% 获取最近的boss
    BossCdfL = [data_boss:get_boss_cfg(BossId)||{BossId, _}<-data_boss:get_boss_by_scene(BossType, Scene)],
    F = fun(Cfg, {MinBossId, MinLayer, MinDis}) ->
        case Cfg of
            #boss_cfg{boss_id = BId, layers = Layer, x = BossX, y = BossY} ->
                Dis = umath:distance_pow({OldX, OldY}, {BossX, BossY}),
                ?IF(Dis < MinDis, {BId, Layer, Dis}, {MinBossId, MinLayer, MinDis});
            _ -> {MinBossId, MinDis}
        end
    end,
    {BossId, Layers, _} = lists:foldl(F, {0, 0, infinity}, BossCdfL),
    % Minute = StayTime div 60,
    % Second = StayTime rem 60,
    % RealStayTime = Minute + handle_float(Second/60, 2),
    lib_log_api:log_enter_or_exit_boss(RoleId, RoleName, RoleLv, Layers, BossType, BossId, Type, [], StayTime, Scene, OldX, OldY, TeamId),
    ta_agent_fire:log_enter_or_exit_boss(Ps, RoleLv, Layers, BossId, BossType, Type, StayTime, Scene, OldX, OldY, TeamId),
    {ok, Ps}.

add_kill_log(Ps, BossType, RewardList, BossId, TeamId) ->
    Fun = fun({Type, GoodsTypeId, Num, _Id}, Acc) ->
        [{Type, GoodsTypeId, Num} | Acc]
          end,
    RewardL = lists:foldl(Fun, [], RewardList),
    if
        RewardL =/= [] ->
            #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}} = Ps,
            case data_boss:get_boss_by_scene(BossType, Ps#player_status.scene) of
                [{_, Layers} | _] -> Layers;
                _ -> Layers = 0
            end,
            BossName = lib_mon:get_name_by_mon_id(BossId),
            lib_log_api:log_boss_kill(RoleId, RoleName, RoleLv, Layers, BossType, BossId, BossName, RewardL, TeamId),
            ta_agent_fire:log_boss_kill(Ps, RoleLv, Layers, BossType, BossId, TeamId);
        true ->
            skip
    end,
    {ok, Ps}.

% %% 保留小数点后几位数字
% %% Float：需要处理的小数 Num:保留几位小数
% handle_float(Float, Num) ->
%     N = math:pow(10, Num),
%     round(Float * N)/N.
%%===========================================================================================
%%                                节日boss
%%===========================================================================================
enter_feast_boss(Ps) ->
    enter_feast_boss(Ps, normal).

enter_feast_boss(Ps, EnterType) ->
	#player_status{scene = NowScene, figure = F} = Ps,
	FeastBossScene = data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_boss_scene),
	IsActOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_BOSS),
	TimeOpen  = lib_custom_act_api:is_feast_boss_time_open(),
	LvLimit   = lib_custom_act_api:is_feast_boss_limit_lv(F#figure.lv),
    case EnterType of
        relogin ->
            IsOutSide = true,
            IsSameScene = false;
        _ ->
            IsOutSide = lib_scene:is_outside_scene(NowScene),
            IsSameScene = NowScene == FeastBossScene
    end,
	if
        IsOutSide == false ->  %%不是野外场景
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(cannot_transferable_scene)]);
		LvLimit == false ->  %%活动没开
			lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err331_lv_not_enougth)]);
		IsSameScene ->  %%已经在场景内
			lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err120_already_in_scene)]);
		IsActOpen == true andalso TimeOpen == true ->
            mod_boss:enter(Ps#player_status.id,Ps#player_status.figure#figure.lv, Ps#player_status.weekly_card_status, ?BOSS_TYPE_FEAST, 0);
		true ->
			lib_server_send:send_to_sid(Ps#player_status.sid, pt_460, 46003, [?ERRCODE(err157_act_not_open)])
	end,
	{ok, Ps}.

%%进入节日boss场景
feast_boss_change_scene(RoleId, CopyId) ->
	lib_scene:player_change_scene(RoleId, ?FEAST_BOSS_SCENE, ?feast_def_scene_pool_id, CopyId, true, [{group, ?DEF_ROLE_BATTLE_GROUP},
		{collect_checker, {mod_boss, check_feast_boss_collect_times, {RoleId, CopyId}}}]).

%%房间是否满人CopyMsg::lists() [#copy_msg{}]
is_max_role_num(_CopyMsg, ?FEAST_BOSS_MAX_COPY_ID) ->  %%达到最大房间的时候，不在新开房间
	false;
is_max_role_num(CopyMsg, MaxCopyId) ->
	is_max_role_num_helper(CopyMsg, MaxCopyId).

is_max_role_num_helper(_CopyMsg, 0) ->
	true;
is_max_role_num_helper(CopyMsg, CopyId) ->
    case lists:keyfind(CopyId, #copy_msg.copy_id, CopyMsg) of
        #copy_msg{role_num = Num, status = Status, start_time = StartTime} ->
            case Num >= ?FEAST_BOSS_COPY_ROLE_NUM orelse Status == ?BOSS_COPY_CLOSE
                orelse (utime:unixtime() - StartTime > ?feast_boss_copy_enter_time_limit )of
                true -> %%这个房间满了，或者关键关闭了 找下一个房间， 或者是已经超时了，
                    is_max_role_num_helper(CopyMsg, CopyId - 1);
                false -> %%这个房间可以进去
                    {false, CopyId}
            end;
        _ -> %%找不到这个房间，则新开一个房间，相当于房间满人
            true
    end.
%% -----------------------------------------------------------------
%% @desc     功能描述 获得节日boss采集怪生成列表
%% @param    参数     MonCfgId::integer() 击杀的boss怪物配置id
%%                    Num::ingeter() 房间内的人数
%% @return   返回值   {[{怪物id, 数量}], 最大采集数}
%% @history  修改历史
%% -----------------------------------------------------------------
get_feast_boss_box_create_list(MonCfgId, Num) ->
	case  data_boss:get_feast_collect_mon(MonCfgId, Num) of
		#feast_boss_role_collection_cfg{fixation_list = FixationList, random_list = RandomList, collect_max = CollectMax} ->
            if
                RandomList == [] ->
                    Random = [];
                true ->
                    {_W,  _Random} = util:find_ratio(RandomList, 1),
                    Random = [_Random]
            end,
			{FixationList  ++  Random, CollectMax};
		_ ->
			{[],  0}
	end.
%%获取节日boss的来源那个方位
get_feast_boss_from(BoxList, AutoId) ->
	case  lists:keyfind(AutoId, #boss_status.boss_auto_id, BoxList) of
		#boss_status{other_map = Map} ->
			maps:get(?feast_boss_from, Map, {1, 1});
		_ ->
			{1, 1}
	end.
%%发送节日boss宝箱奖励
send_feast_boss_box_reward(RoleId, RoleLv) ->
	case get_feast_boss_box_reward(RoleLv) of
		[] ->
			[];
		Reward ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_boss, send_feast_boss_box_reward_in_ps, [Reward]),
			Reward
	end.

send_feast_boss_box_reward_in_ps(PS, Reward) ->
    #player_status{figure = F} = PS,
    TvGoodList = data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_boss_tv_goods_list),
    Produce = #produce{reward = Reward, type = feast_boss_box_reward, show_tips = ?SHOW_TIPS_3},
    case lib_goods_api:send_reward_with_mail_return_goods(PS, Produce) of
        {ok, bag, LastPlayer, UpGoodsList} ->
            send_feast_boss_box_reward_tv(F#figure.name, UpGoodsList, TvGoodList),
            LastPlayer;
        _ ->
            PS
    end.


send_feast_boss_box_reward_tv(_Name, [], _TvGoodList) ->
    skip;
send_feast_boss_box_reward_tv(Name, [H |UpGoodsList], TvGoodList) ->
    #goods{goods_id = GoodsId, other = Other} = H,
    #goods_other{rating = Rating, extra_attr = ExtraAttr} = Other,
    case lists:member(GoodsId, TvGoodList) of
        true ->
            lib_chat:send_TV({all}, ?MOD_BOSS, 17, [Name, GoodsId, Rating, util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, []))]);
        _ ->
            ok
    end,
    send_feast_boss_box_reward_tv(Name, UpGoodsList, TvGoodList).


get_feast_boss_crystal_mon_list() ->
	case  data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, crystal_mon_id) of
		[] ->
			[];
		_M ->
			[_M]
	end.
%%退出节日boss场景
quit_feast_boss(#player_status{scene = Scene, id = RoleId} = Ps) ->
    FeastBossScene = ?FEAST_BOSS_SCENE,
    if
        Scene == FeastBossScene ->
            lib_scene:player_change_scene(RoleId, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, {collect_checker, undefined}]);
        true ->
            skip
    end,
    Ps.

%% -----------------------------------------------------------------
%% @desc     功能描述 广播宝箱信息
%% @param    参数     BossAutoId::boss唯一id, BossX:bossX坐标, BossY::bossY坐标, BoxList::[{AutoId, MonCfgId, X, Y}]
%% @return   返回值    无
%% @history  修改历史
%% -----------------------------------------------------------------
broadCast_feast_box(BossAutoId, BossX, BossY, BoxList, CopyId) ->
%%    ?MYLOG("cym2", "bossId ~p,  x y ~p", [BossAutoId, {BossX, BossY}]),
    LastBoxList = [pack_feast_box(AutoId, MonCfgId, BoxX, BoxY)||{AutoId, MonCfgId, BoxX, BoxY} <- BoxList],
    {ok, Bin}   = pt_460:write(46027, [BossAutoId, BossX, BossY, LastBoxList]),
%%    ?MYLOG("cym",  "BoxList ~p~n",  [LastBoxList]),
    lib_server_send:send_to_scene(?FEAST_BOSS_SCENE, 0, CopyId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述 打包宝箱的生成信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
pack_feast_box(AutoId, MonCfgId, BoxX, BoxY) ->
    case data_mon:get(MonCfgId) of
        #mon{hp_lim = Hp, lv = Lv, name = Name, speed = Speed, icon = Icon, icon_effect = IconEffect, icon_texture = IconTexture, weapon_id = WeaponId,
        att_type = AttType, kind = Kind, color = Color, out = OnHook, boss = Boss, collect_time = CollectTime, is_be_clicked = Clicked,
            is_be_atted = BeAtted} ->
            Hide     = 0, %%是否隐藏
            Ghost    = 0, %%不是幽灵
            Group    = 0, %%战斗分组
            GuildId  = 0, %%公会id
            Angel    = 0, %%出生角度
            AttrType = 0, %%五行
            Title    = 0, %%头衔
            {BoxX, BoxY, AutoId, MonCfgId, Hp, Hp, Lv, Name, Speed, Icon,
                IconEffect, IconTexture, WeaponId, AttType, Kind, Color, OnHook, Boss, CollectTime, Clicked,
                BeAtted, Hide, Ghost, Group, GuildId, Angel, AttrType, Title};
        _ ->
            {0,0,0,0,0,0,0,"",0,0,
                "",0,0,0,0,0,0,0,0,0,
                0,0,0,0,0,0,0,0}
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  更新节日boss玩家采集信息
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
update_feast_boss_collect_reward(CollectMap, Reward, RoleId) ->
	FeastBossCollectMap    = maps:get(?feast_boss_collect_reward, CollectMap, #{}),
	RewardList             = maps:get(RoleId, FeastBossCollectMap, []),
	NewRewardList          = RewardList ++ Reward,
	NewFeastBossCollectMap = maps:put(RoleId, NewRewardList, FeastBossCollectMap),
	NewCollectMap          = maps:put(?feast_boss_collect_reward, NewFeastBossCollectMap, CollectMap),
	NewCollectMap.

get_max_feast_boss_num() ->
    case  data_boss:get_boss_type_kv(?BOSS_TYPE_FEAST, feast_boss_wave) of
        [] ->
            0;
        V ->
            4 * V
    end.

get_feast_boss_box_reward(RoleLv) ->
    case lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_BOSS) of
        [SubType | _ ] ->
            case data_boss:get_feast_boss_reward(SubType, RoleLv) of
                [DrawList, RewardPoolList] ->
                    lib_goods_api:get_reward_by_draw_mul_times(DrawList, RewardPoolList);
                _ ->
                    []
            end;
        _ ->
            []
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述  秘境boss宝箱奖池计算
%% @param    Type:抽奖类型，钻石（1）|绑钻（2）
%% @return   返回值
%% -----------------------------------------------------------------
get_draw_pool(PoolId, Type, CurTimes) ->
    case data_boss:get_all_grade_id(PoolId) of
        Grades when is_list(Grades) andalso Grades =/= [] ->
            get_draw_pool_helper(PoolId, Type, CurTimes, Grades, [], []);
        _ ->
            ?ERR("Error in cfg, no such PoolId:~p~n",[PoolId]),
            {[],[]}
    end.

get_draw_pool_helper(_PoolId, _Type, _CurTimes, [], TemPool, TemSpecial) ->
        {TemPool, TemSpecial};
get_draw_pool_helper(PoolId, Type, CurTimes, [GradeId|T], TemPool, TemSpecial) ->
    case data_boss:get_boss_draw_reward_cfg(PoolId, GradeId) of
        #fairy_boss_draw_reward_cfg{times = Times, bweight = Bweight, weight = ExtraWeight} = RewardCfg ->
            if
                Times =/= 0 andalso CurTimes rem Times == 0 ->
                    get_draw_pool_helper(PoolId, Type, CurTimes, T, TemPool, [RewardCfg|TemSpecial]);
                Type == 1 ->
                    get_draw_pool_helper(PoolId, Type, CurTimes, T, [{Bweight+ExtraWeight, RewardCfg}|TemPool], TemSpecial);
                true ->
                    get_draw_pool_helper(PoolId, Type, CurTimes, T, [{Bweight, RewardCfg}|TemPool], TemSpecial)
            end;
        _ ->
            ?ERR("Error in cfg, no such grade:~p~n",[GradeId]),
            {[],[]}
    end.

get_limit_times() ->
    case data_boss:get_limit_draw_times() of
        LimitTimes when is_integer(LimitTimes) ->skip;
        _ -> LimitTimes = 0
    end,
    LimitTimes.

send_draw_data(Player, _ToRoleId, BossId, EndTime, Times, scene) -> %%boss被击杀广播给所有场景的玩家
    case data_boss:get_boss_cfg(BossId) of
        #boss_cfg{scene = Scene} ->
            #player_status{id = RoleId, combat_power = Combat, figure = Figure} = Player,
            #figure{name = Name, lv = Lv, career = Career, picture = Picture, picture_ver = PictureVer} = Figure,
            LimitTimes = get_limit_times(),
            {ok, Bin} = pt_460:write(46031, [BossId, RoleId, Name, Career, Lv, Combat,
                    Picture, PictureVer, EndTime, Times, LimitTimes]),
            lib_server_send:send_to_scene(Scene, 0, 0, Bin);
        _ ->
            ?ERR("BossId:~p cfg is not exists~n",[BossId]),
            skip
    end,
    {ok, Player}.

send_draw_data(Player, ToRoleId, BossId, EndTime, Times) ->
    #player_status{id = RoleId, combat_power = Combat, figure = Figure} = Player,
    #figure{name = Name, lv = Lv, career = Career, picture = Picture, picture_ver = PictureVer} = Figure,
    LimitTimes = get_limit_times(),
    lib_server_send:send_to_uid(ToRoleId, pt_460, 46031, [BossId, RoleId, Name,
            Career, Lv, Combat, Picture, PictureVer, EndTime, Times, LimitTimes]),
    {ok, Player}.

handle_draw_reward(RewardCfgs, RoleName) ->
    Fun = fun(RewardCfg, Acc) ->
        #fairy_boss_draw_reward_cfg{reward = RewardL, extra = Extra} = RewardCfg,
        case RewardL of
            [{_T, _G, _N}]  ->
                GoodsName = lib_goods_api:get_first_object_name(RewardL),
                case lists:keyfind(is_tv, 1, Extra) of
                    {is_tv, 1} -> lib_chat:send_TV({all}, 460, 12, [RoleName, GoodsName]);
                    _ -> skip
                end,
                [{_T, _G, _N}|Acc];
            _ ->
                ?ERR("Error cfg IN fairyland boss draw RewardCfg:~p~n",[RewardCfg]),
                Acc
        end
    end,
    lists:foldl(Fun, [], RewardCfgs).

%%依据online_num_map对应等极段的在线人数,计算复活时间倍率
calc_online_user(OnlineNumMap, BossType, BossId) ->
    OnlineNumList = maps:to_list(OnlineNumMap),
    case data_boss:get_lv_stage(BossType, BossId) of
        [{MinLv, MaxLv}] ->
            OnlineNum = calc_online_user_help(OnlineNumList, MinLv, MaxLv),
            % ?PRINT("OnlineNumMap:~p,OnlineNum:~p~n",[OnlineNumMap,OnlineNum]),
            case data_boss:get_times(BossType, BossId, OnlineNum) of
                Times when is_integer(Times) andalso Times > 0 -> Times;
                _ -> 0
            end;
        _ ->
            0
    end.

%%OnlineNumList :[{{InLv, AxLv}, Num}...] InLv, AxLv等级差距都为5，Num 为对应等级段玩家日活跃数
calc_online_user_help(OnlineNumList, MinLv, MaxLv) ->
    TemMinLv = (MinLv div ?LV_GAP)*?LV_GAP, %%策划说MinLv, MaxLv都是5的倍数，呃（我不信），还是自己再次处理下
    TemMaxLv = (MaxLv div ?LV_GAP)*?LV_GAP,
    Fun = fun({{InLv, AxLv}, Num}, Sum) ->
        if
            InLv >= TemMinLv andalso AxLv =< TemMaxLv ->
                Sum + Num;
            true ->
                Sum
        end
    end,
    lists:foldl(Fun, 0, OnlineNumList).

%% 只处理?RE_LOGIN类型的重连，其他走正常登陆流程
re_login(#player_status{id = RoleId, last_task_id = LastTaskId, figure = #figure{lv = RoleLv}, status_boss = StatusBoss, scene = SceneId} = Player, _LoginType) ->
    #status_boss{boss_map = BossMap, reborn_ref = OldRef} = StatusBoss,
    %% 野外boss特殊层数据初始化,未完成任务才会初始化
    LastTaskId =< ?SPECIAL_BOSS_TASK_ID
        andalso mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_SPECIAL),
    mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_PHANTOM_PER),
    mod_special_boss:boss_init(RoleId, RoleLv, ?BOSS_TYPE_WORLD_PER),
    IsInBoss = is_in_all_boss(SceneId),
    if
        IsInBoss ->
            BossType = get_boss_type_by_scene(SceneId),
            if
                BossType == ?BOSS_TYPE_SPECIAL orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
                    case maps:get(?BOSS_TYPE_NEW_OUTSIDE, BossMap, []) of
                        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
                            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
                        _E ->
                            DieTime = 0,DieTimes = 0
                    end;
                true ->
                    DieTime = 0,DieTimes = 0
            end,
            case data_boss:get_boss_by_scene(BossType, SceneId) of
                [{_, Layer}|_]  -> Layer;
                _ -> ?ERR("CFG lost {BossType,SceneId}:~p~n",[{BossType,SceneId}]),Layer = 0
            end,
            case data_scene:get(SceneId) of
                #ets_scene{x = X,y = Y} -> ok;
                _ ->
                    ?ERR("boss revive SceneId:~p~n ", [SceneId]),
                    X = 0,
                    Y = 0
            end,
            lib_server_send:send_to_uid(RoleId, pt_460, 46035, [BossType, Layer]),
%%            {RebornTime, _} =lib_boss_mod:count_die_wait_time(DieTimes, DieTime),
            #player_status{battle_attr = BA} = Player,
            #battle_attr{hp = Hp} = BA,
            if
                % 处理野外boss的重连逻辑
                BossType == ?BOSS_TYPE_NEW_OUTSIDE; BossType == ?BOSS_TYPE_SPECIAL;
                BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    {RebornTime, MinTimes} = lib_boss_mod:count_die_wait_time(DieTimes, DieTime),
%%                    ?MYLOG("cym", "RebornTime ~p  MinTimes ~p  NowTime ~p ~n", [RebornTime, MinTimes, NowTime]),
                    FatigueBuffTime = data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, player_die_times),
                    ReviveGhostTime = data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost),
                    %% 取消复活定时器
                    util:cancel_timer(OldRef),
                    %%通知客户端复活信息
                    if
                        Hp =< 0 ->
                            NewPlayer = lib_scene:change_relogin_scene(Player, []),
                            {Sign, KillerName, KillId} = get_last_kill_msg(Player),
%%                            ?MYLOG("cym", "Sign, KillerName ~p ~n", [{Sign, KillerName, KillId}]),
                            {ok, Bin0} = pt_200:write(20013, [Sign, KillerName, 0, 0, 0, 0, KillId]),
                            lib_server_send:send_to_uid(RoleId, Bin0),
                            if
                                DieTimes > MinTimes ->
%%                                    ?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, DieTime + FatigueBuffTime, DieTime + ReviveGhostTime}]),
                                    lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, RebornTime, DieTime + FatigueBuffTime, DieTime + ReviveGhostTime]);
                                true ->
%%                                    ?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, NowTime + FatigueBuffTime, 0}]),
                                    lib_server_send:send_to_uid(RoleId, pt_460, 46034, [DieTimes, RebornTime, DieTime + FatigueBuffTime, 0])
                            end,
                            {ok, NewPlayer};
                        true ->
                            % NewPlayer = lib_scene:change_relogin_scene(Player, [{change_scene_hp_lim, 100}, {ghost, 0}]),
                            % 不回血
                            NewPlayer = lib_scene:change_relogin_scene(Player, [{ghost, 0}]),
                            {ok, NewPlayer}

                    end;
                BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_PHANTOM orelse BossType == ?BOSS_TYPE_ABYSS ->
                    % NewPlayer = lib_scene:change_relogin_scene(Player, [{change_scene_hp_lim, 100},{ghost, 0},{pk, {?PK_PEACE, true}}]),
                    % 不回血
                    case Hp =< 0 of
                        true when BossType == ?BOSS_TYPE_FORBIDDEN ->
                             HpAttr = [{change_scene_hp_lim, 100}, {xy, {X, Y}}];
                        true -> HpAttr = [{change_scene_hp_lim, 100}];
                        false -> HpAttr = []
                    end,
                    case BossType of
                        ?BOSS_TYPE_DOMAIN ->
                            mod_boss:send_domain_cl_boss(RoleId);
                        _ -> skip
                    end,
                    NewPlayer = lib_scene:change_relogin_scene(Player, HpAttr++[{ghost, 0}]),
                    if
                        Hp =< 0 ->
                            {Sign, KillerName, KillId} = get_last_kill_msg(Player),
                            {ok, Bin0} = pt_200:write(20013, [Sign, KillerName, 0, 0, 0, 0, KillId]),
                            lib_server_send:send_to_uid(RoleId, Bin0);
                        true ->
                            skip
                    end,
                    {ok, NewPlayer};
                BossType == ?BOSS_TYPE_FEAST ->
                    lib_boss:enter_feast_boss(Player, relogin),
                    {next, Player};
                BossType == ?BOSS_TYPE_KF_GREAT_DEMON ->
                    mod_great_demon_local:send_demon_box_info(RoleId);
                true ->
                    {next, Player}
            end;
        true ->
            {next, Player}
    end.

%% 判断掉落类型
alloc_drop_role(Ps, MonArgs, _Alloc, _PList, _FirstAttr) ->
    #player_status{
        id = RoleId, team = _Team,
        figure = #figure{name = RoleName, vip = VipLv, vip_type = VipType},
        status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss
    } = Ps,
    #mon_args{scene = Scene, mid = BossId} = MonArgs,
    TemBossType = get_boss_type_by_scene(Scene),
    if
        TemBossType == ?BOSS_TYPE_NEW_OUTSIDE orelse TemBossType == ?BOSS_TYPE_SPECIAL ->
            BossType = ?BOSS_TYPE_NEW_OUTSIDE,
            case data_boss:get_boss_cfg(BossId) of
                #boss_cfg{tired_add = DeleteVit} -> skip;
                _ -> DeleteVit = 999
            end,
            NowTime = utime:unixtime(),
            case maps:get(BossType, TmpMap, []) of
                #role_boss{vit = Vit, last_vit_time = LastVitTime} = TemRoleBoss -> skip;
                _ ->
                    Vit = ?BOSS_TYPE_KV_INIT_VIT(BossType), LastVitTime = NowTime,
                    TemRoleBoss = #role_boss{vit = Vit, last_vit_time = LastVitTime}
            end,
            VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
            MaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
            if
                Vit >= MaxVit+VipAddMaxCount ->
                    RoleBoss = TemRoleBoss#role_boss{vit = max(Vit - DeleteVit, 0), last_vit_time = NowTime};
                true ->
                    RoleBoss = TemRoleBoss#role_boss{vit = max(Vit - DeleteVit, 0)}
            end,
            db_role_boss_replace(RoleId, RoleBoss),
            NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
            StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
            NewPs = Ps#player_status{status_boss = StatusBoss},
            AddVitTime = ?BOSS_TYPE_KV_ADD_VIT_TIME(BossType),
            FixAddVitTime = vip_reduce_vit_time(Ps, AddVitTime),
            lib_log_api:log_boss_vit_change(RoleId, RoleName, Vit, LastVitTime, [], BossId,
                RoleBoss#role_boss.vit, RoleBoss#role_boss.last_vit_time, MaxVit+VipAddMaxCount, FixAddVitTime),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss, try_to_updata_senen_data, [BossType]),
            %% 更新协助boss状态
            lib_guild_assist:update_bl_state(RoleId),
            % ?PRINT("Vit:~p DeleteVit:~p, NowTime:~p~n, NewBossMap:~p~n",[Vit, DeleteVit, NowTime, NewBossMap]),
            lib_server_send:send_to_uid(RoleId, pt_460, 46011, [max(Vit - DeleteVit, 0)]);
        true ->
            NewPs = Ps
    end,
    {ok, NewPs}.

gm_set_boss_vit(Ps, NewVit) ->
    #player_status{
        id = RoleId,
        figure = #figure{vip = VipLv, vip_type = VipType},
        status_boss = #status_boss{boss_map = TmpMap} = OldStatusBoss
    } = Ps,
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    NowTime = utime:unixtime(),
    case maps:get(BossType, TmpMap, []) of
        #role_boss{vit_add_today = VitAddToday, vit_can_back = VitCanBack} = TemRoleBoss -> skip;
        _ ->
            VitAddToday = 0, VitCanBack = 0,
            TemRoleBoss = #role_boss{}
    end,
    VipAddMaxCount = lib_vip_api:get_vip_privilege(?MOD_BOSS, ?NEW_OUTSIDE_BOSS_VIP_VALUE, VipType, VipLv),
    CfgMaxVit = ?BOSS_TYPE_KV_MAX_VIT(BossType),
    MaxVit = CfgMaxVit+VipAddMaxCount,
    RoleBoss = TemRoleBoss#role_boss{vit = NewVit, last_vit_time = NowTime},
    {ok, BinData} = pt_460:write(46044, [NewVit, MaxVit, VitAddToday, VitCanBack, NowTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    db_role_boss_replace(RoleId, RoleBoss),
    NewBossMap = maps:put(BossType, RoleBoss, TmpMap),
    StatusBoss = OldStatusBoss#status_boss{boss_map = NewBossMap},
    NewPs = Ps#player_status{status_boss = StatusBoss},
    SceneData = lib_boss_api:make_boss_tired_map(NewPs, BossType),
    mod_scene_agent:update(NewPs, [{scene_boss_tired, SceneData}]),
    NewPs.

%% 修改玩家last_vit_time
gm_set_last_vit_time(PS, FixTime) ->
    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
    #player_status{id = RoleId, status_boss = StatusBoss} = PS,
    #status_boss{boss_map = BossMap} = StatusBoss,
    RoleBoss = maps:get(BossType, BossMap, #role_boss{}),

    RoleBoss1 = RoleBoss#role_boss{last_vit_time = FixTime},
    BossMap1 = maps:put(BossType, RoleBoss1, BossMap),
    StatusBoss1 = StatusBoss#status_boss{boss_map = BossMap1},
    PS1 = PS#player_status{status_boss = StatusBoss1},
    db_role_boss_replace(RoleId, RoleBoss1),

    PS1.

update_role_bosstired(RoleId, MonArgs, MaxTired) ->
    #mon_args{scene = Scene, mid = BossId} = MonArgs,
    IsInBoss = is_in_all_boss(Scene),
    if
        IsInBoss ->
            BossType = get_boss_type_by_scene(Scene),
            if
                BossType == ?BOSS_TYPE_NEW_OUTSIDE orelse BossType == ?BOSS_TYPE_SPECIAL ->
                    BossTired = mod_daily:get_count(RoleId, ?MOD_BOSS, 0, ?BOSS_TYPE_NEW_OUTSIDE),
                    case data_boss:get_boss_cfg(BossId) of
                        #boss_cfg{scene = _SceneId, drop_lv = _DropLv} ->
                            if
                                BossTired < MaxTired ->
                                    mod_daily:increment(RoleId, ?MOD_BOSS, 0, ?BOSS_TYPE_NEW_OUTSIDE),
                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss, try_to_updata_senen_data, [?BOSS_TYPE_NEW_OUTSIDE]),
                                    NewBossTired = BossTired + 1;
                                true ->
                                    NewBossTired = BossTired
                            end;
                        _ ->
                            NewBossTired = BossTired
                    end,
                    %% 更新协助boss状态
                    lib_guild_assist:update_bl_state(RoleId),
                    lib_server_send:send_to_uid(RoleId, pt_460, 46011, [NewBossTired]);
                true ->
                    skip
            end;
        true ->
            skip
    end.

%%延迟登出处理
delay_stop(PS) ->
    #player_status{scene = SceneId, battle_attr = BA, status_boss = #status_boss{boss_map = BossMap}} = PS,
    #battle_attr{hp = Hp} = BA,
    IsInBoss = is_in_all_boss(SceneId),
    if
        IsInBoss == false ->
            PS;
        true ->
            BossType = get_boss_type_by_scene(SceneId),
            if
                BossType == ?BOSS_TYPE_ABYSS ->
                    if
                        Hp =< 0 ->
                            NewPlayer = lib_scene:change_default_scene(PS, [{change_scene_hp_lim, 100}, {ghost, 0}, {pk, {?PK_PEACE, true}}]);
                        true ->
                            NewPlayer = PS
                    end,
                    NewPlayer;
                BossType == ?BOSS_TYPE_SPECIAL orelse BossType == ?BOSS_TYPE_NEW_OUTSIDE ->
                    case maps:get(?BOSS_TYPE_NEW_OUTSIDE, BossMap, []) of
                        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
                            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
                        _ ->
                            DieTime = 0, DieTimes = 0
                    end,
                    NowTime = utime:unixtime(),
                    {RebornTime, _MinTimes} = lib_boss_mod:count_die_wait_time(DieTimes, DieTime),
%%                    ?MYLOG("cym", "RebornTime ~p NowTime ~p~n", [RebornTime, NowTime]),
                    ReviveGhostTime = data_boss:get_boss_type_kv(?BOSS_TYPE_NEW_OUTSIDE, revive_point_gost), %?幽灵时间
                    RebornTimeAfterDieTimeLimit = get_reborn_time_after_die_time_limit(?BOSS_TYPE_NEW_OUTSIDE, DieTimes),
                    if
                        Hp =< 0 ->  %%血量为0则让他定时复活
                            RebornRef = util:send_after([], max(min(RebornTime + RebornTimeAfterDieTimeLimit - NowTime,
                                DieTime + ReviveGhostTime - NowTime) * 1000, 500),
                                self(), {'mod', lib_boss, player_reborn, [?BOSS_TYPE_NEW_OUTSIDE]}),
                            NewPlayer = PS#player_status{status_boss = PS#player_status.status_boss#status_boss{reborn_ref = RebornRef}};
                        true ->
                            NewPlayer = PS
                    end,
                    NewPlayer;
                true ->
                    PS
            end
    end.


player_reborn(Ps, BossType) ->
    #player_status{status_boss = StatusBoss} = Ps,
    #status_boss{reborn_ref = OldRef} = StatusBoss,
    util:cancel_timer(OldRef),
    #player_status{scene = SceneId, battle_attr = BA, status_boss = StatusBoss} = Ps,
    #status_boss{boss_map = BossMap} = StatusBoss,
    IsInBoss = is_in_all_boss(SceneId),
    case maps:get(BossType, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
        _ ->
            DieTime = 0, DieTimes = 0
    end,
    NowTime = utime:unixtime(),
    {RebornTime, _MinTimes} = lib_boss_mod:count_die_wait_time(DieTimes, DieTime),
    RebornTimeAfterDieTimeLimit = get_reborn_time_after_die_time_limit(BossType, DieTimes),
    #battle_attr{hp = Hp} = BA,
    if
        IsInBoss == true ->
            #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
            GhostAbsTime = abs(RebornTime + RebornTimeAfterDieTimeLimit - NowTime),
%%            ?MYLOG("cym", "RebornTime ~p NowTime ~p  ~n", [RebornTime, NowTime]),
            if
                Hp =< 0 ->  %%血量为0则，让他复活到出生点
                    if
                        GhostAbsTime > 1 -> %%不是自动复活时间，而是搬运幽灵时间
                            RebornRef = util:send_after([], max((RebornTime + RebornTimeAfterDieTimeLimit - NowTime) * 1000, 500), self(), %%下一次复活
                                {'mod', lib_boss, player_reborn, [BossType]}),
                            Player1 = lib_scene:change_relogin_scene(Ps#player_status{x = X, y = Y}, [{hp, 0}]),
                            NewPlayer = Player1#player_status{status_boss = StatusBoss#status_boss{reborn_ref = RebornRef}};
                        true -> %% 直接复活
                            NewPlayer = lib_scene:change_relogin_scene(Ps#player_status{x = X, y = Y}, [{change_scene_hp_lim, 100}, {ghost, 0}])
                    end;
                true ->
                    NewPlayer = Ps
            end;
        true ->
            NewPlayer = Ps
    end,
    NewPlayer.

get_last_kill_msg(PS) ->
    #player_status{last_be_kill = Kill} = PS,
%%    ?MYLOG("cym", "Kill ~p ~n", [Kill]),
    case lists:keyfind(sign, 1, Kill) of
        {sign, Sign} ->
            ok;
        _ ->
            Sign = 1
    end,
    case lists:keyfind(name, 1, Kill) of
        {name, Name} ->
            ok;
        _ ->
            Name = utext:get(181)
    end,
	case lists:keyfind(id, 1, Kill) of
		{id, AttId} ->
			ok;
		_ ->
			AttId = 0
	end,
    {Sign, Name, AttId}.

get_reborn_time_after_die_time_limit(BossType, DieTimes) ->
    List = data_boss:get_boss_type_kv(BossType, reborn_time_after_die_time_limit),
    get_reborn_time_after_die_time_limit_help(List, DieTimes).

get_reborn_time_after_die_time_limit_help([], _DieTimes) ->
    0;
get_reborn_time_after_die_time_limit_help([{Count, Time} | T], DieTimes) ->
    if
        DieTimes =< Count ->
            Time;
        true ->
            get_reborn_time_after_die_time_limit_help(T, DieTimes)
    end.


is_in_can_change_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
                % SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS orelse
                SceneType == ?SCENE_TYPE_ABYSS_BOSS;
                SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS;
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER;
                SceneType == ?SCENE_TYPE_WORLD_BOSS_PER ->
                    % SceneType == ?SCENE_TYPE_DUNGEON ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

is_in_outside_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
                SceneType == ?SCENE_TYPE_OUTSIDE orelse ?SCENE_TYPE_NORMAL->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

is_in_sanctuary_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} ->
            true;
        _ ->
            false
    end.

chang_other_mod_scene(Ps) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, x = OldX, y = OldY} = Ps,
    IsInBoss = is_in_can_change_scene(SceneId),
    OusideScene = is_in_outside_scene(SceneId),
    IsInEudemons = lib_eudemons_land:is_in_eudemons_boss(SceneId),
    IsInKfSanctuary = lib_sanctuary_cluster_util:is_in_sanctuary_scene(SceneId),
    IsInSanctuary = is_in_sanctuary_scene(SceneId),
    IsKfGreatDemon = lib_boss:is_in_kf_great_demon_boss(SceneId),
    {IsOut, ErrCode} = lib_scene:is_transferable_out(Ps),
    if
        IsOut == false ->
            {false, ErrCode};
        OusideScene == true ->
            skip;
        IsInBoss == true ->
            BossType = lib_boss:get_boss_type_by_scene(SceneId),
            if
                BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    mod_special_boss:exit(RoleId, BossType, SceneId, OldX, OldY);
                true ->
                    mod_boss:quit(RoleId, BossType, CopyId, SceneId, OldX, OldY)
            end;
        IsInEudemons == true ->
            lib_eudemons_land:exit_eudemons_land(Ps);
        IsInKfSanctuary == true ->
            %mod_c_sanctuary:exit(Ps#player_status.server_id, Ps#player_status.id, Ps#player_status.scene);
            mod_sanctuary_cluster_local:quit(RoleId, SceneId);
        IsInSanctuary == true ->
           true;
        IsKfGreatDemon ->
            lib_great_demon_local:exit_great_demon(Ps);
        true ->
            {false, ?ERRCODE(err120_cannot_transfer_scene)}
    end.




%% 初始化领域boss
domain_boss_init(BossType, BossId, BossCfg, RebornTime) ->
    #boss_cfg{boss_id = BossId, type = BossType, scene = Scene, x = X, y = Y, reborn_time = RebornTimes} = BossCfg,
    NowTime = utime:unixtime(),
    RebornSpanTime = max(0, RebornTime - NowTime),
    PhatomBossType = get_domain_boss_type(BossType, BossId),
    if
        PhatomBossType == cl_mon -> %% 采集怪
            cl_boss_reborn(RebornTime, BossCfg, [], RebornTimes);
        PhatomBossType == sp_boss -> %% 特殊怪
            _Boss = #boss_status{boss_id = BossId};
        PhatomBossType == boss -> %% boss
            if
                RebornSpanTime > 0 ->
                    RemindTime = max(0, RebornSpanTime - ?REMIND_TIME),
                    RemindRef = ?IF(RemindTime =< 0, undefined,
                        erlang:send_after(RemindTime * 1000, self(), {'boss_remind', BossType, BossId})),
                    RebornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId}),
                    _Boss = #boss_status{boss_id = BossId, reborn_time = RebornTime, remind_ref = RemindRef, reborn_ref = RebornRef};
                true ->
                    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X, Y, 1, 0, 1, []),
                    _Boss = #boss_status{boss_id = BossId}
            end;
        true ->
            _Boss = #boss_status{boss_id = BossId}
    end.




%% 采集怪刷新
cl_boss_reborn(RebornTime, BossCfg, XYList, RebornTimes) ->
    NowTime = utime:unixtime(),
    RebornSpanTime = max(0, RebornTime - NowTime),
    #boss_cfg{boss_id = BossId, type = BossType, scene = Scene, num = Num, rand_xy = RandXy} = BossCfg,
    {NewRebornTime, NewReBornRef} =
        case RebornSpanTime > 0 of
            true ->
                NRebornTime = RebornTime,
                NReBornRef = erlang:send_after(RebornSpanTime * 1000, self(), {'boss_reborn', BossType, BossId}),
                {NRebornTime, NReBornRef};
            _ ->
                RebornSpan = mod_boss:get_reborn_time(RebornTimes),
                NRebornTime = NowTime + RebornSpan,
                NReBornRef = erlang:send_after(RebornSpan * 1000, self(), {'boss_reborn', BossType, BossId}),
                {NRebornTime, NReBornRef}
        end,
%%    ?PRINT("cl_boss_reborn  BossId:~p, Num:~p  Scene :~p ~n",[BossId, Num, Scene]),
    CreateNum = max(0, Num - length(XYList)),

    case CreateNum > 0 of
        true ->
            NewRandXy = ulists:list_shuffle(RandXy),
            LastRandXy = NewRandXy -- XYList,
            F = fun(_I, {XyList, PosList}) ->
                [{X1, Y1} | LeftXyList] = XyList,
                lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossId, Scene, 0, X1, Y1, 1, 0, 1, []),
                {LeftXyList, [{X1, Y1} | PosList]}
                end,
            {_, NewPosList} = lists:foldl(F, {LastRandXy, XYList}, lists:seq(1, CreateNum)),
            %% 广播boss|采集怪物重生信息
            {ok, Bin} = pt_460:write(46009, [BossType, BossId, NewRebornTime, Num]),
            %% 广播采集怪坐标信息
            {ok, Bin2} = pt_460:write(46036, [BossId, NewPosList]),
            lib_server_send:send_to_scene(Scene, 0, 0, Bin),
            lib_server_send:send_to_scene(Scene, 0, 0, Bin2),
            lib_mon:get_scene_mon(Scene, 0, 0, [#scene_object.config_id]),
            #boss_status{boss_id = BossId, reborn_time = NewRebornTime, xy = NewPosList, reborn_ref = NewReBornRef};
        _ ->
            #boss_status{boss_id = BossId, reborn_time = NewRebornTime, xy = XYList, reborn_ref = NewReBornRef}
    end.

create_domain_special_boss(Scene, BossMap, State) ->
    BossType = ?BOSS_TYPE_DOMAIN,
    case data_boss:get_boss_by_scene(BossType, Scene) of
        BossList when is_list(BossList) andalso BossList =/= [] ->
            NowTime = utime:unixtime(),
            case calc_boss_id(BossList) of
                #domain_special_boss_cfg{sp_boss_weight = SpBossWeight} ->
                    SpBossByWeight = get_create_boss_id(SpBossWeight),
                    case SpBossByWeight of
                        [] -> State#boss_state{boss_domain_map = BossMap};
                        _ ->
                            NewBossMap = create_domain_special_boss_core(BossType, BossMap, SpBossByWeight, NowTime),
                            State#boss_state{boss_domain_map = NewBossMap, domain_lock = NowTime}
                    end;
                _ -> State#boss_state{boss_domain_map = BossMap}
            end;
        _ -> State
    end.

calc_boss_id([{BossId, _}|BossList]) ->
    case data_domain:get_domain_special_boss(BossId) of
        #domain_special_boss_cfg{} = DomainBoss -> DomainBoss;
        _ -> calc_boss_id(BossList)
    end;
calc_boss_id(_) -> [].

get_create_boss_id([{_, BossIdList}|_]) when is_list(BossIdList) andalso BossIdList =/= [] ->
    BossIdList;
get_create_boss_id([_|T]) -> get_create_boss_id(T);
get_create_boss_id([]) -> [].

%% 秘境领域 生成特殊怪
create_domain_special_boss(BossType, BossId, BossMap, State) ->
    NowTime = utime:unixtime(),
    #boss_state{domain_lock = DomainLock} = State,
    case data_domain:get_domain_special_boss(BossId) of
        #domain_special_boss_cfg{sp_boss_weight = SpBossWeight} ->
            case DomainLock > NowTime of
                true -> % 不可以生成新的特殊怪
                    State#boss_state{boss_domain_map = BossMap};
                false ->
                    SpBossByWeight = urand:rand_with_weight(SpBossWeight), % 按权重生成
                    case SpBossByWeight of
                        [] -> State#boss_state{boss_domain_map = BossMap};
                        _ ->
                            NewDomainLock =  NowTime + ?BOSS_TYPE_KV_BOSS_REVIVE_CD(BossType),  % 冷却时间
                            NewBossMap = create_domain_special_boss_core(BossType, BossMap, SpBossByWeight, NewDomainLock),
%%                            ?PRINT("NewBossMap :~p~n",[NewBossMap]),
                            State#boss_state{boss_domain_map = NewBossMap, domain_lock = NewDomainLock}
                    end
            end;
        _ -> State#boss_state{boss_domain_map = BossMap}
    end.

create_domain_special_boss_core(BossType, BossMap, SpBossByWeight, NewDomainLock) ->
    #boss_type{condition = Condition} = data_boss:get_boss_type(BossType),
    {_, EnterLv} = ulists:keyfind(lv, 1, Condition, {lv, 0}),
    % 传闻
    [BossIdSendTV | _] = SpBossByWeight,
    MonName = lib_mon:get_name_by_mon_id(BossIdSendTV),
    #boss_cfg{scene = SceneSendTV} = data_boss:get_boss_cfg(BossIdSendTV),
    SceneSendTVName = lib_scene:get_scene_name(SceneSendTV),
    lib_chat:send_TV({all_lv, EnterLv, 999}, ?MOD_BOSS, 18, [MonName, SceneSendTVName, SceneSendTV]),
%%                            NewDomainLock = NowTime +1,
    Fun = fun(BossIdTmp, BossMapTmp) ->
        #boss_cfg{type = BossType, scene = Scene, num = Num, rand_xy = RandXy} = data_boss:get_boss_cfg(BossIdTmp),
        case maps:get(BossIdTmp, BossMapTmp, null) of
            null ->
                BossMapTmp;
            #boss_status{xy = BossXYList} ->
                CreateNum = max(0, Num - length(BossXYList)),
                case CreateNum > 0 of
                    false -> %% 已存在不生成
                        BossMapTmp;
                    true ->
                        LastRandXy = RandXy -- BossXYList,
                        F = fun(_I, {XyList, PosList}) ->
                            [{X1, Y1} | LeftXyList] = XyList,
                            lib_scene_object:async_create_object(?BATTLE_SIGN_MON, BossIdTmp, Scene, 0, X1, Y1, 1, 0, 1, []),
                            {LeftXyList, [{X1, Y1} | PosList]}
                            end,
                        {_, NewPosList} = lists:foldl(F, {LastRandXy, BossXYList}, lists:seq(1, CreateNum)),
                        %% 广播boss|采集怪物重生信息
                        {ok, Bin} = pt_460:write(46009, [BossType, BossIdTmp, NewDomainLock, Num]),
                        %% 广播采集怪坐标信息
                        {ok, Bin2} = pt_460:write(46036, [BossIdTmp, NewPosList]),
                        lib_server_send:send_to_scene(Scene, 0, 0, Bin),
                        lib_server_send:send_to_scene(Scene, 0, 0, Bin2),
                        lib_mon:get_scene_mon(Scene, 0, 0, [#scene_object.config_id]),
                        BossStatus = #boss_status{boss_id = BossIdTmp, xy = NewPosList},
                        NewBossMapTmp = maps:put(BossIdTmp, BossStatus, BossMapTmp),
                        NewBossMapTmp
                end
        end
    end,
    lists:foldl(Fun, BossMap, SpBossByWeight).

%% 记录玩家击杀情况  [#domain_kill{}] [#mon_attr{}]
save_domain_kill(DomainKill, BLWhos) ->
    F = fun(#mon_atter{id = Id}, DomainKillTmp) ->
        NewDomainBossKill =
            case lists:keyfind(Id, #domain_boss_kill.role_id, DomainKillTmp) of
                #domain_boss_kill{kill_num = KillNum} = DomainBossKill ->
                    DomainBossKill#domain_boss_kill{kill_num = KillNum + 1};
                _ ->
                    #domain_boss_kill{role_id = Id, kill_num = 1, get_list = []}
            end,
        lib_boss_mod:db_role_domain_boss_kill_replace(NewDomainBossKill),
        lists:keystore(Id, #domain_boss_kill.role_id, DomainKillTmp, NewDomainBossKill)
    end,
    lists:foldl(F, DomainKill, BLWhos).


%% 4点清除领域boss奖励
domain_mail_reward(State) ->
    #boss_state{domain_kill = DomainKill} = State,
    domain_mail_reward_helper(DomainKill).

domain_mail_reward_helper([]) ->
    skip;

domain_mail_reward_helper([DomainBossKill | Tmp]) ->
    #domain_boss_kill{role_id = RoleID, kill_num = KillNumTmp, get_list = GetListTmp} = DomainBossKill,
    lib_player:apply_cast(RoleID, ?APPLY_CAST_STATUS, lib_boss, domain_mail_reward_helper, [KillNumTmp, GetListTmp]),
    domain_mail_reward_helper(Tmp).

domain_mail_reward_helper(#player_status{id = RoleId, figure = Figure} = PS, KillNumTmp, GetListTmp) ->
    #figure{lv = Lv} = Figure,
    %% 可能需要的发的阶数
    AllDomainStage = data_domain:get_all_stage(),
    LeastStage = AllDomainStage -- GetListTmp,
    Fun = fun(StageTmp, RewardTmp) ->
        #domain_kill_reward_cfg{reward_list = RewardListTmp, kill_boss_num = KillBossNum} =
            data_domain:get_domain_stage_lv(StageTmp, Lv),
        case KillNumTmp >= KillBossNum of
            true ->
                RewardListTmp ++ RewardTmp;
            false ->
                RewardTmp
        end
          end,
    RewardList = lists:foldl(Fun, [], LeastStage),
    % Produce = #produce{type = boss_domain, reward = RewardList},
    % {ok, _NewPS} = lib_goods_api:send_reward_with_mail(PS, Produce).
    if
        RewardList =/= [] ->
            Title = utext:get(4600009), Content = utext:get(4600010),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
        true ->
            skip
    end,
    {ok, PS}.


%% 进场宝箱boss 信息
send_domain_cl_boss(RoleId, DomainMap) ->
    Fun = fun(BossId, #boss_status{xy = XYList}, SendTmp) ->
        case get_domain_boss_type(?BOSS_TYPE_DOMAIN, BossId) of
            cl_mon ->
                [{BossId, XYList} | SendTmp];
            sp_boss ->
                ?PRINT("BossId:~p, XYList:~p~n",[BossId, XYList]),
                [{BossId, XYList} | SendTmp];
            _ ->
                SendTmp
        end
          end,
    SendList = maps:fold(Fun, [], DomainMap),
    lib_server_send:send_to_uid(RoleId, pt_460, 46039, [SendList]).


%%   采集boss 击杀处理
do_domain_mon_be_kill(BossType, BossId, MonArgs, Boss, BossMap, AttrId, BLWhos) ->
    #mon_args{d_x = X, d_y = Y} = MonArgs,
    #boss_status{boss_id = BossId, num = Num, xy = PosList, reborn_time = RebornTime} = Boss,
    #boss_cfg{scene = Scene} = data_boss:get_boss_cfg(BossId),
    NewPosList = lists:delete({X, Y}, PosList),
    ?PRINT("do_domain_mon_be_kill PosList X, Y, NewPosList :~p ~p ~p, ~p~n",[PosList, X, Y, NewPosList]),
    NewBoss = Boss#boss_status{num = max(0, Num - 1), xy = NewPosList},
    {ok, Bin} = pt_460:write(46009, [BossType, BossId, RebornTime, max(0, Num - 1)]),
    SendPosList = NewPosList,
    {ok, Bin1} = pt_460:write(46036, [BossId, SendPosList]),
    lib_server_send:send_to_scene(Scene, 0, 0, Bin),
    lib_server_send:send_to_scene(Scene, 0, 0, Bin1),
    NowTime = utime:unixtime(),
    %% 事件触发
    CallBackData = #callback_boss_kill{boss_type = BossType, boss_id = BossId},
    [lib_player_event:async_dispatch(RoleId, ?EVENT_BOSS_KILL, CallBackData)||#mon_atter{id = RoleId}<-BLWhos],
    %% 成就触发
    lib_player:apply_cast(AttrId, ?APPLY_CAST_STATUS, lib_achievement_api, boss_achv_finish, [BossType, BossId]),
    mod_boss:handle_activitycalen_kill([], AttrId, [], BossType),
    %% 玩家击杀和日志
    case [P#mon_atter.id || P <- BLWhos] of
        [] ->
            lib_log_api:log_boss(BossType, BossId, AttrId, "[]", NowTime);
        BLIds ->
            StrBLIds = util:term_to_string(BLIds),
            lib_log_api:log_boss(BossType, BossId, AttrId, StrBLIds, NowTime),
            [begin
            %% boss击杀任务
                 lib_task_api:kill_boss(BlId, BossType, MonArgs#mon_args.lv),
                 lib_baby_api:boss_be_kill(BlId, BossType, BossId),
                 lib_demons_api:boss_be_kill(BlId, BossType, BossId)
             end || BlId <- BLIds]
    end,
    maps:update(BossId, NewBoss, BossMap).

%% 消耗复活
cost_reborn(#player_status{id = RoleId, scene = SceneId, x = X, y = Y} = Player, BossType, BossId, Cost) ->
    About = lists:concat(["BossType:", BossType, ",BossId:", BossId]),
    case lib_goods_api:cost_object_list_with_check(Player, Cost, boss_cost_reborn, About) of
        {false, ErrCode, NewPlayer} -> {{false, ErrCode}, NewPlayer};
        {true, NewPlayer} ->
            lib_log_api:log_boss_cost_reborn(RoleId, SceneId, X, Y, BossType, BossId, Cost),
            {true, NewPlayer}
    end.

%% 激活月卡特权时，世界大妖的体力冷却时间减少20%
vip_reduce_vit_time(Player, OldVitTime) ->
    ReduceRate = lib_investment:get_month_card_addition(Player, ?MONTH_CARD_VIP_VIT_TIME),
    LastVitTime = OldVitTime * (1 - ReduceRate/100),
    umath:floor(LastVitTime).
