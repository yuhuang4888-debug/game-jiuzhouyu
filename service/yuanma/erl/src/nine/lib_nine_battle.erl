%% ---------------------------------------------------------------------------
%% @doc lib_nine_battle.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿
%% ---------------------------------------------------------------------------
-module(lib_nine_battle).
-compile(export_all).

-include("role_nine.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("jjc.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("clusters.hrl").
-include("server.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% 判断是否开发
-ifdef(DEV_SERVER).
-define(is_kf,  true).
-else.
-define(is_kf,  false).  %%
-endif.

make_record(nine_rank, [ZoneId, GroupId, RoleId, Name, Career, ServerId, ServerName, ServerNum, MaxLayerId, MaxKill, MaxDKill, Score]) ->
    #nine_rank{
        zone_id = ZoneId,
        role_id = RoleId,
        group_id = GroupId,
        name    = Name,
        career  = Career,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        max_layer_id = MaxLayerId,
        max_kill  = MaxKill,
        max_dkill = MaxDKill,
        score  = Score
    }.

%% 跨服中心初始化
init(?CLS_TYPE_CENTER) ->
    ZoneMap = init_zone_map(),
    %mod_zone_mgr:nine_partition_init(),
    #nine_state{state_type = ?CLS_TYPE_CENTER, cls_type = ?CLS_TYPE_CENTER, zone_map = ZoneMap};
%% 游戏服初始化
init(ClsType) ->
    ZoneMap = init_zone_map(),
    util:send_after([], 30 * 1000, self(), sync_server_data),
    #nine_state{state_type = ClsType, cls_type = ClsType, zone_map = ZoneMap}.

init_zone_map() ->
    List = db_role_nine_get(),
    F = fun(T, Map) ->
        NineRank = make_record(nine_rank, T),
        #nine_rank{zone_id = ZoneId, group_id = GroupId} = NineRank,
        #nine_zone{ranks = Ranks} = Zone = maps:get({ZoneId, GroupId}, Map, #nine_zone{}),
        NewZone = Zone#nine_zone{ranks = [NineRank|Ranks], group_id = GroupId, zone_id = ZoneId},
        maps:put({ZoneId, GroupId}, NewZone, Map)
    end,
    ZoneMap = lists:foldl(F, #{}, List),
%%    ?PRINT("@@@@ZoneMap !~p ~n~n", [ZoneMap]),
    sort_zone_map(ZoneMap).

request_init_data(#nine_state{state_type = ?CLS_TYPE_CENTER, group_map = GroupMap} = _State, ServerId) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case maps:get(ZoneId, GroupMap, false) of
        false -> skip;
        {ServerMap, ModGroupMap} ->
            case maps:get(ServerId, ServerMap, false) of
                false -> skip;
                {ModNum, GroupId} ->
                    ZoneBases = maps:get({ModNum, GroupId}, ModGroupMap, []),
                    mod_clusters_center:apply_cast(ServerId, mod_nine_local, sync_partition, [{ZoneId, GroupId, ModNum, ZoneBases}])
            end
    end,
    ok.

%% 同步分服情况
sync_partition(#nine_state{state_type = ?CLS_TYPE_GAME} = State, NineZone) ->
    {_ZoneId, GroupId, Mod, ZoneBases} = NineZone,
    ?PRINT("@@@sync partition mod is ~p ~n ~n", [Mod]),
    case is_cls_open(Mod) of
        true ->
            NewState = State#nine_state{group_id = GroupId, mod = Mod, servers = ZoneBases, cls_type = ?CLS_TYPE_CENTER},
            OnlineList = ets:tab2list(?ETS_ONLINE),
            [send_nine_info(NewState, RoleId) || #ets_online{id = RoleId} <- OnlineList],
            {noreply, NewState};
        false ->
            {noreply, State}
    end;
sync_partition(State, _NineZone) ->{noreply, State}.

%%===================================================
%% 排序
sort_zone_map(ZoneMap) ->
    F = fun(_Key, #nine_zone{ranks = Ranks} = Zone) ->
        NewRanks = sort_ranks(Ranks),
        Zone#nine_zone{ranks = NewRanks}
    end,
    maps:map(F, ZoneMap).

sort_ranks(Ranks) ->
    NewRanks = compare_data(Ranks),
    NewRanks2 = compare_rank(NewRanks, 1, []),
    NewRanks2.

%% 排序 积分 击杀数
compare_data(Ranks)->
    F = fun(A1, A2) ->
        if
            % A1#nine_rank.score == A2#nine_rank.score -> A1#nine_rank.max_kill >= A2#nine_rank.max_kill;
            % true -> A1#nine_rank.score > A2#nine_rank.score
            A1#nine_rank.max_kill == A2#nine_rank.max_kill -> A1#nine_rank.combat_power >= A2#nine_rank.combat_power;
            true -> A1#nine_rank.max_kill > A2#nine_rank.max_kill
        end
    end,
    lists:sort(F, Ranks).

%% 排名赋值
compare_rank([], _, Ranks) -> lists:reverse(Ranks);
compare_rank([H|T], Rank, Ranks)->
    compare_rank(T, Rank+1, [H#nine_rank{rank=Rank}|Ranks]).

%% 活动开始
act_start(#nine_state{state_type = ?CLS_TYPE_GAME, mod = Mod} = State, AcSub) ->
    case is_cls_open(Mod) of
        true ->
            mod_nine_center:cast_center([{'apply', act_start, [AcSub]}]),
            NewState = State;
        false ->
            NewState = do_act_start(State, AcSub)
    end,
    {noreply, NewState};
act_start(State, AcSub) ->
    NewState = do_act_start(State, AcSub),
    {noreply, NewState}.

do_act_start(#nine_state{status = Status} = State, AcSub) when Status =/= ?STATE_OPEN ->
    if
        ?is_kf == true ->
            do_act_start_help(State, utime:unixtime(), utime:unixtime() + 900);
        true ->
            case lib_activitycalen:get_act_open_time_region(?MOD_NINE, 0, AcSub) of  %%
                {ok, [Stime, Etime]} ->
                    do_act_start_help(State, Stime, Etime);
                false -> State
            end
    end;

do_act_start(State, _AcSub) ->
    State.

do_act_start_help(State, Stime, Etime) ->
    #nine_state{
        state_type = StateType, cls_type = ClsType, zone_map = _ZoneMap, ref = OldRef, rank_ref = OldRankRef,
        flag_ref = OldFlagRef, score_ref = OldScoreRef, group_map = GroupMap
        } = State,
%%    ?PRINT("@@@@@stgm ZoneMap ~p.....~n~n", [ZoneMap]),
    ?IF(ClsType == ?CLS_TYPE_CENTER,
%%        clear_all_nine_scene(GroupMap, ?CLS_TYPE_CENTER),
        cls_clear_nine_scene(GroupMap),
%%        clear_nine_scene({?DEFAULT_ZONE_ID,?DEFAULT_GROUP_ID}, ClsType, ?DEFAULT_GROUP_ID, 1)
        clear_nine_scene(?DEFAULT_ZONE_ID)
    ),
    db_role_nine_truncate(),
    Ref = util:send_after(OldRef, max(Etime - utime:unixtime(), 0)*1000, self(), {'apply', act_end}),
    RankRef = util:send_after(OldRankRef, ?NINE_KV_RANK_REFRESH_TIME*1000, self(), {'apply', rank_ref}),
    FlagRef = util:send_after(OldFlagRef, ?NINE_KV_FLAG_TIME*1000, self(), {'apply', flag_ref}),
    ScoreRef = util:send_after(OldScoreRef, ?NINE_KV_LAYER_SCORE_TIME*1000, self(), {'apply', score_ref}),
    NewState = State#nine_state{status = ?STATE_OPEN, stime = Stime, etime = Etime, zone_map = #{}, role_map = #{},
        ref = Ref, rank_ref = RankRef, flag_ref = FlagRef, score_ref = ScoreRef},
    case StateType == ?CLS_TYPE_GAME of
        true ->
            BinData = get_nine_info_bin(NewState),
            lib_server_send:send_to_all(BinData),
            lib_activitycalen_api:success_start_activity(?MOD_NINE);
        false ->
            Args = [{?CLS_TYPE_CENTER, ?STATE_OPEN, Stime, Etime}],
            mod_clusters_center:apply_to_all_node(mod_nine_local, sync_data, [Args])
    end,
%%    ?PRINT("@@@@@stgm start.....~p~n~n", [State#nine_state.servers]),
    NewState.

%% 同步数据
sync_data(#nine_state{status = _Status, cls_type = _ClsType, mod = Mod} = State, Args) ->
    [{NClsType, NStatus, Stime, Etime}] = Args,
    %% 同步需要判斷當前活動是否開啟（由於開發40天前後開啟時間不一樣，但是都由跨服中心開啟活動，需要過濾下）
    NewState =
        case is_cls_open(Mod) of
            true ->
                case NStatus of
                    ?STATE_CLOSE ->
                        NewStateTmp = State#nine_state{cls_type = NClsType, status = NStatus, stime = Stime, etime = Etime},
                        lib_activitycalen_api:success_end_activity(?MOD_NINE),
                        BinData = get_nine_info_bin(NewStateTmp),
                        lib_server_send:send_to_all(BinData),
                        NewStateTmp;
                    _ ->
                        if
                            ?is_kf == true ->
                                lib_activitycalen_api:success_start_activity(?MOD_NINE),
                                NewStateTmp = State#nine_state{cls_type = NClsType, status = NStatus, stime = Stime, etime = Etime},
                                BinData = get_nine_info_bin(NewStateTmp),
                                lib_server_send:send_to_all(BinData),
                                NewStateTmp;
                            true ->
                                case lib_activitycalen_api:check_ac_start(?MOD_NINE) of  %%
                                    true ->
                                        lib_activitycalen_api:success_start_activity(?MOD_NINE),
                                        NewStateTmp = State#nine_state{cls_type = NClsType, status = NStatus, stime = Stime, etime = Etime},
                                        BinData = get_nine_info_bin(NewStateTmp),
                                        lib_server_send:send_to_all(BinData),
                                        NewStateTmp;
                                    _ -> State
                                end
                        end
                end;
            false ->
                State
        end,
    {noreply, NewState}.

%% 设置单服模式
%% 默认状态即可（再发送信息到用户）
gm_single_mod(#nine_state{state_type = ?CLS_TYPE_GAME}) ->
    ZoneMap = init_zone_map(),
    NewState = #nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ?CLS_TYPE_GAME, zone_map = ZoneMap},
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [send_nine_info(NewState, RoleId) || #ets_online{id = RoleId} <- OnlineList],
    {noreply, NewState}.

%% 秘籍活动开始
%% @param Type 开启类型
gm_act_start(#nine_state{state_type = ?CLS_TYPE_GAME, mod = Mod} = State, Etime) ->
    case utime:unixtime() < Etime of
        true ->
            case is_cls_open(Mod) of
                false -> NewState = do_act_start_help(State, utime:unixtime(), Etime);
                true ->
                    mod_nine_center:cast_center([{'apply', gm_act_start, [Etime]}]),
                    NewState = State
            end;
        false ->
            NewState = State
    end,
    {noreply, NewState};
gm_act_start(State,  Etime) ->
    NewState = do_act_start_help(State, utime:unixtime(), Etime),
    {noreply, NewState}.

%% 跨服检查并创建房间信息
%% 非九层的进入 不掉层
copy_check_and_create(#nine_rank{role_id = RoleId, server_id = ServerId} = OldNineRank, State, ZoneId, GroupId, Mod, WorldLv, LayerId)->
    #nine_state{zone_map = ZoneMap, cls_type = ClsType, role_map = RoleMap} = State,
    NineZoneInit = maps:get({ZoneId, GroupId}, ZoneMap, #nine_zone{}),
    MaxLayer = data_nine:get_max_layer_id(Mod),

    %% 进人了，定时创建密保 当nine_zone第一次记创建，把九魂秘宝也创建下
    IsFirstRoleEnter = NineZoneInit == #nine_zone{},
    ?PRINT(RoleId == 4294967319, "NineZoneInit ~p ~n IsFirstRoleEnter ~p ~n", [NineZoneInit, IsFirstRoleEnter]),
    case IsFirstRoleEnter of
        true ->
            #base_nine{scene_id = NineBfSceneId, cls_scene_id = NineClsSceneId} = data_nine:get_nine(Mod, MaxLayer),
            case ClsType == ?CLS_TYPE_GAME of
                true -> NineSceneId = NineBfSceneId;
                false -> NineSceneId = NineClsSceneId
            end,
            {X, Y} = ?NINE_KV_FLAG_MON_XY,
            lib_mon:async_create_mon(?NINE_KV_FLAG_MON_ID, NineSceneId, ZoneId, X, Y, 0, GroupId, 1, []),
            ?PRINT("CREATE FALGMON [NineSceneId, ZoneId, X, Y, 0, GroupId] ~p ~n", [[NineSceneId, ZoneId, X, Y, 0, GroupId]]),
            IsCreateFlag = 1,
            NineZone = NineZoneInit#nine_zone{zone_id = ZoneId, mod = Mod, lv = WorldLv, group_id = GroupId};
        false ->
            IsCreateFlag = NineZoneInit#nine_zone.is_create_flag,
            NineZone = NineZoneInit
    end,

    %% 九层不分房间！
    %% 现在逻辑不掉层，判断玩家是否第一次进入
    %% 玩家选房间，如果该房间是第一次进入，创建怪物（九层除外）
    case maps:get(RoleId, RoleMap, false) of
        #nine_rank{layer_id = OldLayerId, copy_id = OldCopyId} = NineRank when OldLayerId =/= LayerId ->
            %% 玩家第一次进入该层
            CopyListTmp = leave_old_copy(NineZone#nine_zone.copy_list, OldLayerId, OldCopyId, MaxLayer),
            {CopyId, IsNewCopy, NewCopyList} = get_copy_id(NineZone#nine_zone{copy_list = CopyListTmp}, LayerId, MaxLayer),
%%            ?MYLOG("lzhninecopy", "enter next layer RoleId ~p  NewRoleNum ~p ~n", [RoleId, NewRoleNum ]),
%%            ?PRINT("OldCopyList, CopyId, IsNewCopy, NewCopyList ~p ~n", [[NineZone#nine_zone.copy_list, CopyId, IsNewCopy, NewCopyList]]),
            if
                not IsNewCopy -> skip;
                true ->
                    create_nine_copy(ClsType, ZoneId, WorldLv, CopyId, Mod, LayerId, NewCopyList)
            end,
            NewNineRank = NineRank#nine_rank{copy_id = CopyId, is_on = 1, layer_id = LayerId},
            NewNineZone = NineZone#nine_zone{copy_list = NewCopyList, is_create_flag = IsCreateFlag},
            NewRoleMap =  maps:put(RoleId, NewNineRank, RoleMap),
            NewZoneMap = maps:put({ZoneId, GroupId}, NewNineZone, ZoneMap),
            {CopyId, NewNineRank, State#nine_state{zone_map = NewZoneMap, role_map = NewRoleMap}};
        #nine_rank{copy_id = CopyId} = NineRank ->
            %% 玩家在改层在复活
%%            ?MYLOG("lzhninecopy", "revie layer RoleId ~p  , LayerId ~p ~n", [RoleId, LayerId]),
            {CopyId, NineRank#nine_rank{is_on = 1}, State};
        _ -> % 首次进入
            %% 进入第一层
%%            ?MYLOG("lzhninecopy", "enter first layer RoleId ~p ~n", [RoleId ]),
            % 事件触发
            CallbackData = #callback_join_act{type = ?MOD_NINE},
            dispatch_execute(ServerId, lib_player_event, async_dispatch, [RoleId, ?EVENT_JOIN_ACT, CallbackData]),

            {CopyId, IsNewCopy, NewCopyList} = get_copy_id(NineZone, LayerId, MaxLayer),
            if
                not IsNewCopy -> skip;
                true ->
                    create_nine_copy(ClsType, ZoneId, WorldLv, CopyId, Mod, LayerId, NewCopyList)
            end,
            NewNineRank = OldNineRank#nine_rank{role_id = RoleId, copy_id = CopyId, is_on = 1, layer_id = LayerId},
            NewNineZone = NineZone#nine_zone{copy_list = NewCopyList, is_create_flag = IsCreateFlag},
            NewRoleMap = maps:put(RoleId, NewNineRank, RoleMap),
            NewZoneMap = maps:put({ZoneId, GroupId}, NewNineZone, ZoneMap),
            {CopyId, NewNineRank, State#nine_state{zone_map = NewZoneMap, role_map = NewRoleMap}}
    end.


create_nine_copy(ClsType, ZoneId, WorldLv, CopyId, Mod, LayerId, _NewCopyList)  ->
    case ClsType == ?CLS_TYPE_GAME of
        true -> OpenDay = util:get_open_day();
        false -> OpenDay = ?NINE_KV_CLS_OPEN_DAY
    end,
    #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId, mon_num = MonNum, mon_pos = MonPosL} = data_nine:get_nine(Mod, LayerId),
    case ClsType == ?CLS_TYPE_GAME of
        true -> SceneId = BfSceneId;
        false -> SceneId = ClsSceneId
    end,
    SubMonPosL = lists:sublist(MonPosL, MonNum),
    %% 初始创建怪物日志，方便排除bug
%%    lib_log_api:log_nine(0, "create_monster", 0, LayerId, 0, 0, 0, []),
    F2 = fun({X, Y}) -> create_monster(ZoneId, WorldLv, LayerId, OpenDay, SceneId, X, Y, CopyId) end,
%%    ?MYLOG("lzhninecopy", "create_monster LayerId ~p CopyId ~p ~n NewCopyList ~p ~n", [LayerId, CopyId, NewCopyList]),
    lists:foreach(F2, SubMonPosL).

%% 检查并且创建 (yy3d 弃用 ，房间进一步细分
check_and_create(State, ZoneId, GroupId, WorldLv, Mod) ->
    #nine_state{cls_type = ClsType, zone_map = ZoneMap, stime = Stime} = State,
    case maps:is_key({ZoneId, GroupId}, ZoneMap) of
        true ->
            State;
        false ->
            % 清理数据
            clear_nine_scene({ZoneId, GroupId}, ClsType, GroupId, Mod),
            % 创建区域
            Zone = create_zone(ClsType, ZoneId, WorldLv, Stime, GroupId, Mod),
            NewZoneMap = maps:put({ZoneId, GroupId}, Zone, ZoneMap),
            State#nine_state{zone_map = NewZoneMap}
    end.

%% 创建区域
create_zone(ClsType, ZoneId, WorldLv, Stime, GroupId, Mod) ->
    case ClsType == ?CLS_TYPE_GAME of
        true -> OpenDay = util:get_open_day();
        false -> OpenDay = ?NINE_KV_CLS_OPEN_DAY
    end,
    F = fun(LayerId) ->
        #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId, mon_num = MonNum, mon_pos = MonPosL} = data_nine:get_nine(Mod, LayerId),
        case ClsType == ?CLS_TYPE_GAME of
            true -> SceneId = BfSceneId;
            false -> SceneId = ClsSceneId
        end,
        % F2 = fun(_No) ->
        %     case urand:list_rand(MonPosL) of
        %         null -> skip;
        %         {X, Y} ->
        %             create_robot(ZoneId, WorldLv, LayerId, OpenDay, SceneId, X, Y)
        %             % create_monster(ZoneId, LayerId, SceneId, X, Y)
        %     end
        % end,
        % util:for(1, MonNum, F2)
        SubMonPosL = lists:sublist(MonPosL, MonNum),
        %% 初始创建怪物日志，方便排除bug
        lib_log_api:log_nine(0, "create_monster", 0, LayerId, 0, 0, 0, []),
        F2 = fun({X, Y}) -> create_monster(ZoneId, WorldLv, LayerId, OpenDay, SceneId, X, Y, GroupId) end,
        lists:foreach(F2, SubMonPosL)
    end,
    LayerIdList = data_nine:get_nine_layer_id_list(Mod),
    lists:foreach(F, LayerIdList),
    % 创建秘宝,开启后第N分钟才有秘宝
    case utime:unixtime() >= Stime of % + ?NINE_KV_FLAG_TIME - 20 of
        true ->
            LayerId = data_nine:get_max_layer_id(Mod),
            #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId} = data_nine:get_nine(Mod, LayerId),
            case ClsType == ?CLS_TYPE_GAME of
                true -> SceneId = BfSceneId;
                false -> SceneId = ClsSceneId
            end,
            {X, Y} = ?NINE_KV_FLAG_MON_XY,
            lib_mon:async_create_mon(?NINE_KV_FLAG_MON_ID, SceneId, ZoneId, X, Y, 0, GroupId, 1, []),
            IsCreateFlag = 1;
        false ->
            IsCreateFlag = 0
    end,
    #nine_zone{zone_id = ZoneId, is_create_flag = IsCreateFlag, group_id = GroupId}.

%% 创建怪物
create_monster(ZoneId, WorldLv, _LayerId, _OpenDay, SceneId, X, Y, CopyId) ->
    % RobotAttrL = get_robot_attr_list(LayerId, OpenDay),
    MonId = urand:list_rand(?NINE_KV_MON_LIST),
    case data_mon:get(MonId) of
        #mon{lv = Lv} -> AutoLv = max(Lv, WorldLv);
        _ -> AutoLv = WorldLv
    end,
    lib_mon:async_create_mon(MonId, SceneId, ZoneId, X, Y, 1, CopyId, 1, [{auto_lv, AutoLv}, {die_handler, {lib_nine_api, object_die_handler, []}}]),
    ok.

get_robot_attr_list(LayerId, OpenDay) ->
    Power = data_nine:get_robot_pow(LayerId, OpenDay),
    PowerAttrList = data_nine:get_power_attr(),
    [{AttrType, round(Value*Power)}||{AttrType, Value}<-PowerAttrList].

% %% 创建假人[读取竞技场的数据]
% create_robot(ZoneId, WorldLv, LayerId, OpenDay, SceneId, X, Y) ->
%    case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
%         [] -> Rank = 0;
%         [MaxRank] -> Rank = urand:rand(1, MaxRank)
%     end,
%     % figure
%     case data_jjc:get_jjc_robot(Rank) of
%         [] -> Robot = #base_jjc_robot{};
%         Robot -> ok
%     end,
%     #base_jjc_robot{
%         power_range = [MinPower, MaxPower], lv_range = [MinLv, MaxLv],
%         rmount = RMount, rmate = RMate, rpet = RPet, rfly = RFly, rholyorgan = RHolyorgan
%         } = Robot,
%     Career = urand:list_rand(?CAREER_LIST),
%     SexList = [Sex||{TmpCareer, Sex}<-data_career:get_all_career(), TmpCareer==Career],
%     Sex = urand:list_rand(SexList),
%     Turn = urand:list_rand(lists:seq(0, ?MAX_TURN)),
%     case WorldLv > 0 of
%         true -> Lv0 = urand:rand(max(WorldLv-?NINE_KV_DUMMY_LV_RANGE, 1), WorldLv+?NINE_KV_DUMMY_LV_RANGE);
%         false -> Lv0 = urand:rand(MinLv, MaxLv)
%     end,
%     Lv = ?IF(Lv0 < 130, urand:rand(130, 140), Lv0),
%     LvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),
%     _Combat = urand:rand(MinPower, MaxPower),
%     MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount)}]),
%     MateKv = ?IF(RMate == [], [], [{?MATE_ID, urand:list_rand(RMate)}]),
%     PetKv = ?IF(RPet == [], [], [{?PET_ID, urand:list_rand(RPet)}]),
%     FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly)}]),
%     HolyorganKv = case lists:keyfind(Career, 1, RHolyorgan) of
%         {_, HolyorganL} when HolyorganL =/= [] -> [{?HOLYORGAN_ID, urand:list_rand(HolyorganL)}];
%         _ -> []
%     end,
%     Name = case data_jjc:get_robot_name_list() of
%         [] -> "守卫";
%         NameList -> urand:list_rand(NameList)
%     end,
%     MountFigure = MountKv ++ MateKv ++ PetKv ++ FlyKv ++ HolyorganKv,
%     Figure = #figure{name = Name, sex = Sex, turn = Turn, career = Career, lv = Lv, lv_model = LvModel, mount_figure = MountFigure},
%     % battle_attr
%     RobotAttr = get_robot_attr(LayerId, OpenDay),
%     BattleAttr = #battle_attr{hp=RobotAttr#attr.hp, hp_lim=RobotAttr#attr.hp, speed=?SPEED_VALUE, attr=RobotAttr},
%     % skill
%     Skills = data_skill:get_ids(Career, Sex),
%     Args = [{figure, Figure}, {battle_attr, BattleAttr}, {skill, Skills}, {die_handler, {lib_nine_api, dummy_die_handler, []}},
%         {revive_time, ?NINE_KV_ROBOT_REVIVE_TIME}, {group, 2}, {warning_range, 5000}, {born_handler, {lib_nine_api, dummy_born_handler, [LayerId]}}],
%     lib_scene_object:async_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, ZoneId, X, Y, 1, 0, 1, Args),
%     % lib_scene_object:async_create_a_dummy(Scene, ZoneId, X, Y, ZoneId, 1, Figure, BattleAttr, Args),
%     ok.

% get_robot_attr(LayerId, OpenDay) ->
%     Power = data_nine:get_robot_pow(LayerId, OpenDay),
%     PowerAttrList = data_nine:get_power_attr(),
%     NewPowerAttrList = [{AttrType, round(Value*Power)}||{AttrType, Value}<-PowerAttrList],
%     lib_player_attr:to_attr_record(NewPowerAttrList).

%% 是否跨服活动
is_cls_open(Mod) ->
%%    OpenDay = util:get_open_day(),
%%    OpenDay >= ?NINE_KV_CLS_OPEN_DAY.
    Mod =/= ?NINE_PARTITION_1.


%% 活动结束[定时器 #nine_state.ref]
act_end(State) ->
    #nine_state{
        cls_type = ClsType, role_map = RoleMap, zone_map = ZoneMap, ref = OldRef, rank_ref = OldRankRef,
        flag_ref = OldFlagRef, score_ref = OldScoreRef, group_map = GroupMap
        } = State,
    % 定时器清理
    util:cancel_timer(OldRef),
    util:cancel_timer(OldRankRef),
    util:cancel_timer(OldFlagRef),
    util:cancel_timer(OldScoreRef),
    % 发送奖励
    {NewRoleMap, NewZoneMap} = sort_zone_map(RoleMap, ZoneMap, ClsType),
    {NewRoleMap2, NewZoneMap1} = update_flag_reward(NewZoneMap, NewRoleMap),
    NewRoleMap3 = update_rank_reward(NewRoleMap2),
    spawn(fun() -> send_rank_reward(maps:values(NewRoleMap3)) end),
    spawn(fun() -> send_result(maps:values(NewRoleMap3), NewZoneMap1) end),
    spawn(fun() -> db_role_nine_batch(maps:values(NewRoleMap3)) end),
    % 清理玩家和场景
    ?IF(ClsType == ?CLS_TYPE_CENTER,
%%        clear_all_nine_scene(GroupMap, ?CLS_TYPE_CENTER),
        cls_clear_nine_scene(GroupMap),
%%        clear_nine_scene({?DEFAULT_ZONE_ID,?DEFAULT_GROUP_ID}, ClsType, ?DEFAULT_GROUP_ID, 1)
        clear_nine_scene(?DEFAULT_ZONE_ID)
    ),
    NewState = State#nine_state{
        status = ?STATE_CLOSE, etime = 0, role_map = #{}, ref = none, rank_ref = none,
        flag_ref = none, score_ref = none, zone_map = #{}
        },
    case ClsType == ?CLS_TYPE_GAME of
        true ->
            BinData = get_nine_info_bin(NewState),
            lib_server_send:send_to_all(BinData),
            lib_activitycalen_api:success_end_activity(?MOD_NINE);
        false ->
            Args = [{?CLS_TYPE_GAME, ?STATE_CLOSE, 0, 0}],
            mod_clusters_center:apply_to_all_node(mod_nine_local, sync_data, [Args])
    end,
    {noreply, NewState}.

%% 活动结束
gm_act_end(#nine_state{status = Status} = State) when Status =/= ?STATE_OPEN -> {noreply, State};
gm_act_end(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State) ->
    case ClsType == ?CLS_TYPE_GAME of
        true -> act_end(State);
        false -> {noreply, State}
    end;
gm_act_end(State) ->
    act_end(State).

%% 排序
sort_zone_map(RoleMap, ZoneMap, _ClsType) ->
    Ranks = maps:values(RoleMap),
    F = fun({ZoneId, GroupId}, Zone) ->
        TmpRanks = [NineRank||#nine_rank{zone_id = TmpZoneId, group_id = TmpGroupId}=NineRank<-Ranks,
            TmpZoneId==ZoneId, TmpGroupId == GroupId],
        NewRanks = sort_ranks(TmpRanks),
        Zone#nine_zone{ranks = NewRanks}
    end,
    NewZoneMap = maps:map(F, ZoneMap),
    F2 = fun(_Key, #nine_zone{ranks = TmpRanks}, List) ->
        KvRanks = [{RoleId, NineRank}||#nine_rank{role_id = RoleId} = NineRank<-TmpRanks],
        KvRanks++List
    end,
    KvRanks = maps:fold(F2, [], NewZoneMap),
    NewRoleMap = maps:from_list(KvRanks),
    {NewRoleMap, NewZoneMap}.

%% 更新秘宝奖励
update_flag_reward(ZoneMap, RoleMap) ->
    F = fun(Key, #nine_zone{fid = Fid, findex = FIndex, f_role_list = FRoleL} = Zone, {TmpRoleMap, TmpZoneMap}) ->
        case maps:get(Fid, TmpRoleMap, false) of
            false -> {TmpRoleMap, TmpZoneMap};
            #nine_rank{server_id = ServerId, server_num = ServerNum, role_id = RoleId, name = RoleName, reward = Reward} = NineRank ->
                Award = ?NINE_KV_FLAG_REWARD,
                dispatch_execute(ServerId, ?MODULE, add_award, [Fid, ?NINE_AWARD_TYPE_SCORE, Award]),
                log_nine(NineRank, ?NINE_AWARD_TYPE_RESULT, 0, 0, Award),
                NewFRoleL = [{FIndex, ServerNum, RoleId, RoleName}|FRoleL],
                NewTmpRoleMap = maps:put(Fid, NineRank#nine_rank{reward = Award++Reward}, TmpRoleMap),
                NewTmpZoneMap = TmpZoneMap#{Key => Zone#nine_zone{findex = FIndex + 1, f_role_list = NewFRoleL}},
                {NewTmpRoleMap, NewTmpZoneMap}
        end
    end,
    maps:fold(F, {RoleMap, ZoneMap}, ZoneMap).

%% 更新榜单奖励
update_rank_reward(RoleMap) ->
    F = fun(_K, NineRank) ->
        #nine_rank{rank = RankNo, reward = Reward} = NineRank,
        RankReward = data_nine:get_rank_award(RankNo),
        NineRank#nine_rank{reward = RankReward++Reward}
    end,
    maps:map(F, RoleMap).

send_rank_reward([]) -> skip;
send_rank_reward([NineRank|T]) ->
    #nine_rank{role_id = RoleId, server_id = ServerId, rank = RankNo} = NineRank,
    case data_nine:get_rank_award(RankNo) of
        [] -> skip;
        Award ->
            dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, ?NINE_AWARD_TYPE_RESULT, Award]),
            log_nine(NineRank, ?NINE_AWARD_TYPE_RESULT, 0, 0, Award),
            timer:sleep(50)
    end,
    send_rank_reward(T).

%% 发送结算
send_result([], _ZoneMap) -> skip;
send_result([NineRank|T], ZoneMap) ->
    #nine_rank{
        role_id = RoleId, server_id = ServerId, zone_id = ZoneId, group_id = GroupId,
        is_on = IsOn, max_layer_id = MaxLayerId, reward = Reward
    } = NineRank,
    #nine_zone{f_role_list = FRoleL, firsts = [FirstSerNum, _, FirstName]} = maps:get({ZoneId, GroupId}, ZoneMap, #nine_zone{}),
    F = fun({FIndex, FSerNum, _, RName}) -> {FIndex, FSerNum, RName} end,
    SendFRoleL = lists:map(F, FRoleL),
    %?PRINT("SendFRoleL ~p ~n", [SendFRoleL]),
    case IsOn == 1 of
        true ->
            {ok, BinData} = pt_135:write(13507, [MaxLayerId, Reward, FirstSerNum, FirstName, SendFRoleL]),
            dispatch_execute(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
        false ->
            skip
    end,
    send_result(T, ZoneMap).

%% 跨服进程清理房间
cls_clear_nine_scene(GroupMap) ->
    F = fun(ZoneId, {ModGroupMap, _}) ->
        ModGroups = maps:values(ModGroupMap),
        lists:map(fun({Mod, _GroupId}) ->
                    SceneIdList = data_nine:get_nine_cls_scene_list(Mod),
                    [begin
                         mod_scene_agent:apply_cast(SceneId, ZoneId, ?MODULE, do_clear_nine_scene_help, []),
                         lib_scene:clear_scene(SceneId, ZoneId)
                     end||SceneId<-SceneIdList]
                  end, ModGroups)
        end,
    maps:map(F, GroupMap),
    ok.
%% 游戏服进程清理房间
clear_nine_scene(ZoneId) ->
    SceneIdList = data_nine:get_nine_scene_list(1),
    [begin
         mod_scene_agent:apply_cast(SceneId, ZoneId, ?MODULE, do_clear_nine_scene_help, []),
         lib_scene:clear_scene(SceneId, ZoneId)
     end||SceneId<-SceneIdList],
    ok.

%%==================================yyhx_3d弃用（根据参加人数细分房间） start===============================================
%% 跨服中心调用
clear_all_nine_scene(GroupMap, ?CLS_TYPE_CENTER) when is_map(GroupMap) ->
    F = fun(ZoneId, {ModGroupMap, _}) ->
            ModGroups = maps:values(ModGroupMap),
            lists:map(fun({Mod, GroupId}) -> clear_nine_scene(ZoneId, ?CLS_TYPE_CENTER, GroupId, Mod) end, ModGroups)
        end,
    maps:map(F, GroupMap);
clear_all_nine_scene(_, _) -> skip.

clear_nine_scene({ZoneId, GroupId}, ClsType, GroupId, Mod) ->
    case ClsType == ?CLS_TYPE_GAME of
        true -> SceneIdList = data_nine:get_nine_scene_list(Mod);
        false -> SceneIdList = data_nine:get_nine_cls_scene_list(Mod)
    end,
    do_clear_nine_scene(SceneIdList, ZoneId, GroupId);
clear_nine_scene(ZoneId, ClsType, GroupId, Mod) ->
    case ClsType == ?CLS_TYPE_GAME of
        true -> SceneIdList = data_nine:get_nine_scene_list(Mod);
        false -> SceneIdList = data_nine:get_nine_cls_scene_list(Mod)
    end,
    do_clear_nine_scene(SceneIdList, ZoneId, GroupId).

do_clear_nine_scene([], _ZoneId, _GroupId) -> skip;
do_clear_nine_scene([SceneId|T], ZoneId, GroupId) ->
    mod_scene_agent:apply_cast(SceneId, ZoneId, ?MODULE, do_clear_nine_scene_help, [GroupId]),
    lib_scene:clear_scene_room(SceneId, ZoneId, GroupId),
    do_clear_nine_scene(T, ZoneId, GroupId).

%%=================================yyhx_3d弃用（根据参加人数细分房间） end================================================

%% 进程处理
do_clear_nine_scene_help() ->
    UserList = lib_scene_agent:get_scene_user(),
    [begin
         Args = [RoleId, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim,1}, {action_free, ?ERRCODE(err135_can_not_change_scene_in_nine)}]],
         dispatch_execute(ServerId, lib_scene, player_change_scene, Args)
     end|| #ets_scene_user{id = RoleId, server_id=ServerId}<-UserList],
    ok.
%% yyhx_3d弃用（根据参加人数细分房间）
do_clear_nine_scene_help(CopyId) ->
    UserList = lib_scene_agent:get_scene_user(CopyId),
    [begin
        Args = [RoleId, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim,1}, {action_free, ?ERRCODE(err135_can_not_change_scene_in_nine)}]],
        dispatch_execute(ServerId, lib_scene, player_change_scene, Args)
    end|| #ets_scene_user{id = RoleId, server_id=ServerId}<-UserList],
    ok.

%% 榜单定时器[#nine_state.rank_ref]
rank_ref(#nine_state{status = Status, cls_type = ClsType} = State) when Status == ?STATE_OPEN ->
    #nine_state{role_map = RoleMap, zone_map = ZoneMap, rank_ref = OldRef} = State,
    {NewRoleMap, NewZoneMap} = sort_zone_map(RoleMap, ZoneMap, ClsType),
    Ref = util:send_after(OldRef, ?NINE_KV_RANK_REFRESH_TIME*1000, self(), {'apply', rank_ref}),
    NewState = State#nine_state{role_map = NewRoleMap, zone_map = NewZoneMap, rank_ref = Ref},
    {noreply, NewState};
rank_ref(State) ->
    {noreply, State}.

%% 秘宝定时器
flag_ref(#nine_state{status = Status, cls_type = ?CLS_TYPE_GAME} = State) when Status == ?STATE_OPEN ->
    #nine_state{zone_map = ZoneMap, role_map = RoleMap, cls_type = ClsType, flag_ref = OldRef} = State,
    case maps:get({?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}, ZoneMap, false) of
        #nine_zone{is_create_flag = IsCreate, fid = Fid, f_server_num = FSerNum, fname = Fname, findex = OldIndex, f_role_list = FRoleL} = NineZone ->
            Index = OldIndex + 1,
            case IsCreate == 1 of
                true -> NewNineZone = NineZone#nine_zone{findex = Index};
                false ->
                    LayerId = data_nine:get_max_layer_id(1),
                    #base_nine{scene_id = SceneId} = data_nine:get_nine(1, LayerId),
                    {X, Y} = ?NINE_KV_FLAG_MON_XY,
                    lib_mon:async_create_mon(?NINE_KV_FLAG_MON_ID, SceneId, ?DEFAULT_ZONE_ID, X, Y, 0, ?DEFAULT_GROUP_ID, 1, []),
                    % 秘宝传闻
                    zone_dispatch_execute(?DEFAULT_ZONE_ID, lib_chat, send_TV, [{all}, ?MOD_NINE, 3, []]),
                    NewNineZone = NineZone#nine_zone{is_create_flag = 1, findex = Index}
            end,
            case maps:get(Fid, RoleMap, false) of
                false -> NewRoleMap = RoleMap, NewZoneMap = ZoneMap#{{?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID} => NewNineZone};
                #nine_rank{role_id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, reward = Reward} = NineRank ->
                    Award = ?NINE_KV_FLAG_REWARD,
                    dispatch_execute(ServerId, ?MODULE, add_award, [Fid, ?NINE_AWARD_TYPE_SCORE, Award]),
                    % 秘宝结算传闻
                    zone_dispatch_execute(?DEFAULT_ZONE_ID, lib_chat, send_TV, [{all}, ?MOD_NINE, 7, [Name, OldIndex]]),
                    log_nine(NineRank, ?NINE_AWARD_TYPE_RESULT, 0, 0, Award),
                    NewFRoleL = [{OldIndex, ServerNum, RoleId, Name}|FRoleL],
                    NewZoneMap = ZoneMap#{{?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID} => NewNineZone#nine_zone{f_role_list = NewFRoleL}},
                    NewRoleMap = maps:put(Fid, NineRank#nine_rank{reward = Award++Reward}, RoleMap)
            end,
            FlagRef = util:send_after(OldRef, ?NINE_KV_FLAG_TIME*1000, self(), {'apply', flag_ref}),
            NewState = State#nine_state{zone_map = NewZoneMap, role_map = NewRoleMap, flag_ref = FlagRef},
            FlagSec = calc_flag_sec(NewState),
            {ok, BinData} = pt_135:write(13504, [Index, FSerNum,Fid, Fname, FlagSec]),
            %send_to_scene(ClsType, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID, 1, BinData),
            send_to_all(ClsType, RoleMap, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID, BinData),
%%            send_13510(ClsType, 1, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID, Fid),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;
flag_ref(#nine_state{status = Status, cls_type = ?CLS_TYPE_CENTER} = State) when Status == ?STATE_OPEN ->
    #nine_state{zone_map = ZoneMap, role_map = RoleMap, cls_type = ClsType, flag_ref = OldRef, group_map = GroupMap} = State,
    KFModList = [?NINE_PARTITION_2, ?NINE_PARTITION_4, ?NINE_PARTITION_8],
    F = fun({ZoneId, GroupId}, Zone, {TmpZoneMap, TmpRoleMap}) ->
        #nine_zone{fid = Fid, is_create_flag = IsCreate, findex = OldIndex, f_role_list = FRoleL, group_id = ZGroupId, zone_id = ZZoneId} = Zone,
        Index = OldIndex + 1,
        %?PRINT("Index ~p ~n", [Index]),
        case IsCreate == 1 of
            true -> NewTmpZoneMap = TmpZoneMap#{{ZoneId, GroupId} => Zone#nine_zone{findex = Index}};
            false ->
                {_, ModGroupMap} = maps:get(ZoneId, GroupMap, {#{}, #{}}),
                FF = fun(Mod, TmpZoneMap1) ->
                        case maps:get({Mod, GroupId}, ModGroupMap, false) of
                            false ->  TmpZoneMap1;
                            _ ->
                                LayerId = data_nine:get_max_layer_id(Mod),
                                #base_nine{cls_scene_id = SceneId} = data_nine:get_nine(Mod, LayerId),
                                {X, Y} = ?NINE_KV_FLAG_MON_XY,
                                lib_mon:async_create_mon(?NINE_KV_FLAG_MON_ID, SceneId, ZoneId, X, Y, 0, GroupId, 1, []),
                                % 秘宝传闻
                                zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId, lib_chat, send_TV, [{all}, ?MOD_NINE, 3, []]),
                                ZoneKey = {ZoneId, GroupId},
                                maps:put(ZoneKey, Zone#nine_zone{is_create_flag = 1, findex = Index}, TmpZoneMap1)
                        end
                    end,
                NewTmpZoneMap = lists:foldl(FF, TmpZoneMap, KFModList)
        end,
        case maps:get(Fid, TmpRoleMap, false) of
            false -> NewTmpRoleMap = TmpRoleMap, LastTmpZoneMap = NewTmpZoneMap;
            #nine_rank{role_id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, reward = Reward, mod = Mod} = NineRank ->
                Award = ?NINE_KV_FLAG_REWARD,
                dispatch_execute(ServerId, ?MODULE, add_award, [Fid, ?NINE_AWARD_TYPE_SCORE, Award]),
                log_nine(NineRank, ?NINE_AWARD_TYPE_RESULT, 0, 0, Award),
                % 秘宝传闻
                zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId, lib_chat, send_TV, [{all}, ?MOD_NINE, 7, [Name]]),
                NewFRoleL = [{OldIndex, ServerNum, RoleId, Name}|FRoleL],
                %?PRINT("NewFRoleL ~p ~n", [NewFRoleL]),
                case maps:get({ZZoneId, ZGroupId},NewTmpZoneMap, false) of
                    false -> LastTmpZoneMap = NewTmpZoneMap;
                    Z ->
                        LastTmpZoneMap = NewTmpZoneMap#{{ZZoneId, ZGroupId} => Z#nine_zone{f_role_list = NewFRoleL}}
                end ,
                NewTmpRoleMap = maps:put(Fid, NineRank#nine_rank{reward = Award++Reward}, TmpRoleMap)
        end,
        {LastTmpZoneMap, NewTmpRoleMap}
        end,
    {NewZoneMap, NewRoleMap} = maps:fold(F, {ZoneMap, RoleMap}, ZoneMap),
    FlagRef = util:send_after(OldRef, ?NINE_KV_FLAG_TIME*1000, self(), {'apply', flag_ref}),
    NewState = State#nine_state{zone_map = NewZoneMap, role_map = NewRoleMap, flag_ref = FlagRef},
    F2 = fun({ZoneId, GroupId}, #nine_zone{f_server_num = FSerNum, fid = Fid, fname = Fname, findex = Index}, Acc) ->
        {_, ModGroupMap1} = maps:get(ZoneId, GroupMap, {#{}, #{}}),
        [
            case maps:get({Mod, GroupId}, ModGroupMap1, false) of %% 找到改组的mod（分服模式）
                false -> skip;
                _ ->
                    FlagSec = calc_flag_sec(NewState),
                    {ok, BinData} = pt_135:write(13504, [Index, FSerNum, Fid, Fname, FlagSec]),
                    send_to_all(ClsType, RoleMap, ZoneId, GroupId, BinData)
                    %send_to_scene(ClsType, ZoneId, GroupId, Mod, BinData)
%%                    send_13510(ClsType, Mod, ZoneId, GroupId, Fid)
            end
            ||Mod <- KFModList
        ],
        Acc
        end,
    maps:fold(F2, ok, NewZoneMap),
    {noreply, NewState};
flag_ref(State) ->
    {noreply, State}.

%% 积分定时器
score_ref(#nine_state{status = Status} = State) when Status == ?STATE_OPEN ->
    #nine_state{role_map = RoleMap, score_ref = OldRef} = State,
    F = fun(RoleId, NineRank) ->
        #nine_rank{server_id = ServerId, score = OScore, is_on = IsOn, layer_id = LayerId, reward = Reward, mod = Mod} = NineRank,
        AddScore = data_nine:get_layer_score(Mod,LayerId),
        case IsOn == 1 andalso AddScore > 0 of
            true ->
                CurScore = OScore + AddScore,
                MinGrade = calc_score_grade(OScore),
                MaxGrade = calc_score_grade(CurScore),
                Award = calc_score_grade_award(MinGrade, MaxGrade, []),
                dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, ?NINE_AWARD_TYPE_SCORE, Award]),
                NewNineRank = NineRank#nine_rank{score = CurScore, reward = Reward++Award},
                log_nine(NewNineRank, ?NINE_AWARD_TYPE_SCORE, MinGrade, MaxGrade, Award),
                % {ok, BinData} = pt_135:write(13508, [AddScore, CurScore]),
                % dispatch_execute(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
                NewNineRank;
            false ->
                NineRank
        end
    end,
    NewRoleMap = maps:map(F, RoleMap),
    ScoreRef = util:send_after(OldRef, ?NINE_KV_LAYER_SCORE_TIME*1000, self(), {'apply', score_ref}),
    NewState = State#nine_state{role_map = NewRoleMap, score_ref = ScoreRef},
    {noreply, NewState};
score_ref(State) ->
    {noreply, State}.

%% -----------------------------------------------------------------
%% 进程通信
%% -----------------------------------------------------------------

%% 对象死亡
object_die(#nine_state{status = Status} = State, _SceneId, _RoleId, _ServerId, _PoolId, _CopyId) when Status =/= ?STATE_OPEN -> {noreply, State};
object_die(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, SceneId, RoleId, ServerId, PoolId, CopyId) ->
    case is_nine_bf_scene(State, SceneId) of
        true ->
            case ClsType == ?CLS_TYPE_GAME of
                true -> do_object_die(State, SceneId, RoleId, ServerId, PoolId, CopyId);
                false -> {noreply, State}
            end;
        false -> {noreply, State}
    end;

object_die(State, SceneId, RoleId, ServerId, _PoolId, _CopyId) ->
    case is_nine_cls_scene(State, SceneId) of
        true -> do_object_die(State, SceneId, RoleId, ServerId, _PoolId, _CopyId);
        false -> {noreply, State}
    end.

do_object_die(State, SceneId, RoleId, _ServerId, PoolId, _CopyId) ->
    #nine_state{role_map = RoleMap, cls_type = ClsType} = State,
    case maps:get(RoleId, RoleMap, false) of
        false -> {noreply, State};
        #nine_rank{zone_id = ZoneId, dkill = OldDkill, mod = Mod} = NineRank ->
            AddScore = data_nine_m:get_add_score(NineRank, #nine_rank{}),
            {IsNextLayer, NineRankAfKill} = after_kill_player(NineRank, AddScore, ?BATTLE_SIGN_MON),
            NewRoleMap = maps:put(RoleId, NineRankAfKill, RoleMap),
            NewState = State#nine_state{role_map = NewRoleMap},
            #nine_rank{layer_id = LayerId, dkill = Dkill, group_id = GroupId} = NineRankAfKill,
            case OldDkill == Dkill of
                true -> skip;
                false -> mod_scene_agent:apply_cast(SceneId, ZoneId, ?MODULE, dkill_notice, [ClsType, ZoneId, GroupId, Mod, RoleId, Dkill])
            end,
            case IsNextLayer of
                true ->
                    role_enter(NewState, NineRankAfKill, LayerId + 1, PoolId, GroupId, false, false, []);
                false ->
                    send_battle_info(NewState, NineRankAfKill),
                    {noreply, NewState}
            end
    end.

%% 击杀之后的处理
after_kill_player(NineRank, AddScore, DieSign) ->
    #nine_rank{
        role_id = RoleId,
        server_id = ServerId,
        score  = OScore,
        mod = Mod,
        kill   = OKill,             %% 当前击杀
        max_kill  = OMaxKill,       %% 历史击杀
        dkill  = ODkill,            %% 当前连杀
        max_dkill = OMaxDkill,      %% 历史连杀(最高)
        reward = Reward             %% 奖励列表
    }=NineRank,
    % 真人算两点积分,假人为一点积分
    case DieSign == ?BATTLE_SIGN_PLAYER of
        true ->
            dispatch_execute(ServerId, lib_achievement_api, async_event, [RoleId, lib_achievement_api, nine_kill_object, 1]),
            AddKill = 2, AddDkill = 1;
        false ->
            AddKill = 1, AddDkill = 0
    end,
    %% 历史击杀更新、数据更新
    NewNineRank = NineRank#nine_rank{
        score = OScore+AddScore,
        kill  = OKill+AddKill,
        max_kill = OMaxKill+AddKill,
        dkill = ODkill+AddDkill,
        max_dkill = max(ODkill+AddDkill, OMaxDkill)
    },
    %% 积分奖励
    #nine_rank{kill = Kill, layer_id = LayerId, score = CurScore} = NewNineRank,
    MinGrade = calc_score_grade(OScore),
    MaxGrade = calc_score_grade(CurScore),
    Award = calc_score_grade_award(MinGrade, MaxGrade, []),
    dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, ?NINE_AWARD_TYPE_SCORE, Award]),
    NewNineRank2 = NewNineRank#nine_rank{reward = Reward++Award},
    log_nine(NewNineRank2, ?NINE_AWARD_TYPE_SCORE, MinGrade, MaxGrade, Award),
    % {ok, BinData} = pt_135:write(13508, [AddScore, CurScore]),
    % dispatch_execute(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
    %% 是否跳层
    case LayerId < data_nine:get_max_layer_id(Mod) of
        true ->
            #base_nine{kill_num = CfgKillNum} = data_nine:get_nine(Mod, LayerId),
            % ?MYLOG("hjh", "Kill:~p CfgKillNum:~p ~n", [Kill, CfgKillNum]),
            case Kill >= CfgKillNum of
                true ->
                    NewNineRank3 = NewNineRank2#nine_rank{kill=0, layer_id=LayerId},
                    {true, NewNineRank3};
                false ->
                    {false, NewNineRank2}
            end;
        false ->
            {false, NewNineRank2}
    end.

calc_score_grade(Score) ->
    ScoreList = data_nine:get_grade_score_list(),
    do_calc_score_grade(lists:reverse(ScoreList), Score).

do_calc_score_grade([], _Score) -> 0;
do_calc_score_grade([{Grade, CfgScore}|T], Score) ->
    case Score >= CfgScore of
        true -> Grade;
        false -> do_calc_score_grade(T, Score)
    end.

calc_score_grade_award(Max, Max, Award) -> Award;
calc_score_grade_award(Min, Max, Award) ->
    case data_nine:get_grade_award(Min+1) of
        [] -> calc_score_grade_award(Min+1, Max, Award);
        R -> calc_score_grade_award(Min+1, Max, R++Award)
    end.

%% 击杀玩家
kill_player(#nine_state{status = Status} = State, _SceneId, _, _AtterId, _Name, _DieId, _DieName, _DieServerId, _PoolId, _CopyId) when Status =/= ?STATE_OPEN -> {noreply, State};
kill_player(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, SceneId, ServerNum, AtterId, Name, DieId, DieName, DieServerId, PoolId, CopyId) ->
    case is_nine_bf_scene(State, SceneId) of
        true ->
            case ClsType == ?CLS_TYPE_GAME of
                true -> do_kill_player(State, SceneId, ServerNum, AtterId, Name, DieId, DieName, DieServerId, PoolId, CopyId);
                false -> {noreply, State}
            end;
        false -> {noreply, State}
    end;
kill_player(State, SceneId, ServerNum, AtterId, Name, DieId, DieName, DieServerId, PoolId, CopyId) ->
    case is_nine_cls_scene(State, SceneId) of
        true -> do_kill_player(State, SceneId, ServerNum, AtterId, Name, DieId, DieName, DieServerId, PoolId, CopyId);
        false -> {noreply, State}
    end.

do_kill_player(State, SceneId, ServerNum, AtterId, Name, DieId, DieName, _DieServerId, PoolId, CopyId) ->
    #nine_state{role_map = RoleMap, zone_map = ZoneMap, cls_type = ClsType, group_map = GroupMap} = State,
    AttNineRank = maps:get(AtterId, RoleMap, false),
    DieNineRank = maps:get(DieId, RoleMap, false),
    case AttNineRank =/= false of
        true ->
            #nine_rank{zone_id = ZoneId, group_id = GroupId, mod = Mod} = AttNineRank,
            case DieNineRank =/= false of
                true ->
                    AddScore = data_nine_m:get_add_score(AttNineRank, DieNineRank),
                    {IsNextLayer, NewAttNineRank} = after_kill_player(AttNineRank, AddScore, ?BATTLE_SIGN_PLAYER),
                    NewDieNineRank = DieNineRank#nine_rank{dkill = 0},
                    NewRoleMap = RoleMap#{AtterId=>NewAttNineRank, DieId=>NewDieNineRank};
                false ->
                    AddScore = data_nine_m:get_add_score(AttNineRank, #nine_rank{}),
                    {IsNextLayer, NewAttNineRank} = after_kill_player(AttNineRank, AddScore, ?BATTLE_SIGN_PLAYER),
                    NewRoleMap = RoleMap#{AtterId=>NewAttNineRank}
            end,
            #nine_zone{fid = Fid, findex = FIndex} = Zone = maps:get({ZoneId, GroupId}, ZoneMap),
            case DieId == Fid of
                true ->
                    FlagSec = calc_flag_sec(State),
                    {ok, BinData} = pt_135:write(13504, [FIndex, ServerNum, AtterId, Name, FlagSec]),
                    send_to_all(ClsType, RoleMap, ZoneId, GroupId, BinData),
                    %send_to_scene(ClsType, PoolId, CopyId,Mod, BinData),
%%                    send_13510(ClsType, Mod, PoolId, GroupId, AtterId),
                    % 易主
                    zone_dispatch_execute(GroupMap, PoolId, Mod, GroupId,lib_chat, send_TV, [{all}, ?MOD_NINE, 1, [Name, DieName]]),
                    NewZone = Zone#nine_zone{f_server_num = ServerNum,fid = AtterId, fname = Name};
                false ->
                    NewZone = Zone
            end,
            #nine_rank{layer_id = LayerId, dkill = Dkill} = NewAttNineRank,
            mod_scene_agent:apply_cast(SceneId, ZoneId, ?MODULE, dkill_notice, [ClsType, ZoneId, CopyId, Mod, AtterId, Dkill]),
            ZoneKey = ?IF(ClsType == ?CLS_TYPE_CENTER, {ZoneId, NewZone#nine_zone.group_id}, {?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}),
            NewZoneMap = maps:put(ZoneKey, NewZone, ZoneMap),
            NewState = State#nine_state{role_map = NewRoleMap, zone_map = NewZoneMap},
            case IsNextLayer of
                true ->
                    role_enter(NewState, NewAttNineRank, LayerId + 1, PoolId, GroupId, false, false, []);
                false ->
                    send_battle_info(NewState, NewAttNineRank),
                    {noreply, NewState}
            end;
        false ->
            {noreply, State}
    end.

%% 连杀通知
dkill_notice(ClsType, ZoneId, CopyId, Mod, RoleId, Dkill) ->
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{figure = Figure} ->
%%            ?PRINT("ClsType, ZoneId, GroupId, Mod, RoleId, Dkill ~p ~p ~p ~p ~p ~p ~n", [ClsType, ZoneId, GroupId, Mod, RoleId, Dkill]),
            {ok, BinData} = pt_135:write(13509, [RoleId, Figure, Dkill]),
            send_to_scene(ClsType, ZoneId, CopyId,Mod, BinData);
        _ ->
            skip
    end.

%% 复活
revive(#nine_state{status = Status} = State, _RoleId, _ServerId, _Type, _SceneId, _CopyId) when Status =/= ?STATE_OPEN -> {noreply, State};
revive(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, RoleId, ServerId, Type, SceneId, CopyId) ->
    case is_nine_bf_scene(State, SceneId) of
        true ->
            case ClsType == ?CLS_TYPE_GAME of
                true -> do_revive(State, RoleId, ServerId, Type, SceneId, CopyId);
                false -> {noreply, State}
            end;
        false -> {noreply, State}
    end;
revive(State, RoleId, ServerId, Type, SceneId, CopyId) ->
    case is_nine_cls_scene(State, SceneId) of
        true ->
            do_revive(State, RoleId, ServerId, Type, SceneId, CopyId);
        false ->
            {noreply, State}
    end.

do_revive(State, RoleId, _ServerId, _Type, _SceneId, _CopyId) ->
    #nine_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, false) of
        false -> {noreply, State};
        #nine_rank{} = NineRank ->
%%            #base_nine{is_drop = IsDrop, drop_rate = DropRate} = data_nine:get_nine(Mod, LayerId),
%%            case IsDrop == 1 of
%%                true -> NewDropRate = ?IF(Type == ?REVIVE_NINE_GOLD, 0, DropRate);
%%                false -> NewDropRate = 0
%%            end,
            NewNineRank = NineRank#nine_rank{dkill = 0},
            NewState = State#nine_state{role_map = maps:put(RoleId, NewNineRank, RoleMap)},
            {noreply, NewState}
%%            case urand:rand(1, ?RATIO_COEFFICIENT) =< NewDropRate of
%%                true ->
%%                    role_enter(State, NineRank, LayerId-1, ZoneId, CopyId, true, false, []);
%%                false ->
%%%%                    #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId, born_pos = BornPosL} = data_nine:get_nine(Mod, LayerId),
%%%%                    % 切场景
%%%%                    case Type == ?REVIVE_NINE_GOLD of
%%%%                        true -> skip;
%%%%                        false ->
%%%%                            KeyValueList = [
%%%%                                {group, 0}
%%%%                                % , {pk, {?PK_ALL, true}}
%%%%                                ],
%%%%                            case util:is_cls() of
%%%%                                true -> SceneId = ClsSceneId;
%%%%                                false -> SceneId = BfSceneId
%%%%                            end,
%%%%                            {X, Y} = urand:list_rand(BornPosL),
%%%%                            dispatch_execute(ServerId, lib_scene, player_change_scene, [RoleId, SceneId, ZoneId, GroupId, X, Y, false, KeyValueList])
%%%%                    end,
%%                    NewState = State#nine_state{role_map = maps:put(RoleId, NewNineRank, RoleMap)},
%%                    {noreply, NewState}
%%            end
    end.

%% 采集秘宝
collect_flag(#nine_state{status = Status} = State, _RoleId, _SceneId, _PoolId, _CopyId) when Status =/= ?STATE_OPEN -> {noreply, State};
collect_flag(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, RoleId, SceneId, PoolId, CopyId) ->
    case is_nine_bf_scene(State, SceneId) of
        true ->
            case ClsType == ?CLS_TYPE_GAME of
                true -> do_collect_flag(State, RoleId, PoolId, CopyId);
                false -> {noreply, State}
            end;
        false ->
            {noreply, State}
    end;

collect_flag(State, RoleId, SceneId, PoolId, CopyId) ->
    case is_nine_cls_scene(State, SceneId) of
        true -> do_collect_flag(State, RoleId, PoolId, CopyId);
        false -> {noreply, State}
    end.

do_collect_flag(State, RoleId, PoolId, CopyId) ->
    #nine_state{cls_type = ClsType, role_map = RoleMap, zone_map = ZoneMap, group_map = GroupMap} = State,
    ?PRINT("@@@@@@@@@@@@@@cj mb ~p ~n", [RoleId]),
    case maps:get(RoleId, RoleMap, false) of
        false -> {noreply, State};
        #nine_rank{zone_id = ZoneId, server_num = FSerNum, name = Name, group_id = GroupId, mod = Mod} ->
            Zone = maps:get({ZoneId, GroupId}, ZoneMap),
            NewZone = Zone#nine_zone{fid = RoleId, fname = Name, f_server_num = FSerNum},
            ZoneKey = ?IF(ClsType == ?CLS_TYPE_CENTER, {ZoneId, CopyId}, {?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}),
            NewZoneMap = maps:put(ZoneKey, NewZone, ZoneMap),
            NewState = State#nine_state{zone_map = NewZoneMap},
            FlagSec = calc_flag_sec(State),
            {ok, BinData} = pt_135:write(13504, [Zone#nine_zone.findex, FSerNum, RoleId, Name, FlagSec]),
            send_to_all(ClsType, RoleMap, ZoneId, GroupId, BinData),
            %send_to_scene(ClsType, PoolId, CopyId, Mod, BinData),
%%            send_13510(ClsType, Mod, PoolId, CopyId, RoleId),
            zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId, lib_chat, send_TV, [{all}, ?MOD_NINE, 4, [Name]]),
            {noreply, NewState}
    end.

calc_flag_sec(#nine_state{flag_ref = FlagRef}) ->
    calc_flag_sec(FlagRef);
calc_flag_sec(FlagRef) ->
    utime:unixtime() +
        case catch erlang:read_timer(FlagRef) of
            N when is_integer(N) -> N div 1000;
            _ -> 0
        end.

%% -----------------------------------------------------------------
%% 玩家进程
%% -----------------------------------------------------------------

%% 获取状态
send_nine_info(State, RoleId) ->
    BinData = get_nine_info_bin(State),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

get_nine_info_bin(State) ->
    #nine_state{status = Status, etime = Etime, servers = ZoneBases, mod = Mod, group_id = GroupId} = State,
    {ServerInfoList, AvgLv} =
        case Mod of
            ?NINE_PARTITION_1 ->
                ServerInfoList1 = [{config:get_server_id(), config:get_server_num(),util:get_server_name(), util:get_world_lv()}],
                AvgLv1 = util:get_world_lv(),
                {ServerInfoList1, AvgLv1};
            _ ->
                F = fun(ZoneBase, {InfoList, SLv}) ->
                    #zone_base{server_id = Id, server_name = Name, server_num = Num, world_lv = Lv} = ZoneBase,
                    Item = {Id, Num, Name, Lv},
                    {[Item|InfoList], SLv + Lv}
                    end,
                {ServerInfoList2, AllLv} = lists:foldl(F, {[], 0}, ZoneBases),
                Length = length(ServerInfoList2),
                AvgLv2 = ?IF(Length == 0 , util:get_world_lv(), AllLv div Length),
                {ServerInfoList2, AvgLv2}
        end,
    {ok, BinData} = pt_135:write(13500, [Status, Etime, Mod, GroupId, ServerInfoList, AvgLv]),
    BinData.

%% 战场日志
send_nine_rank_list(#nine_state{state_type = ?CLS_TYPE_GAME, group_id = GroupId, zone_id = ZoneId}=State, RoleId, ServerId) ->
    case is_bf_execute(State) of
        true -> send_nine_rank_list_help(State, RoleId, ServerId, ZoneId, GroupId);
        false -> mod_nine_center:cast_center([{apply, send_nine_rank_list, [RoleId, ServerId]}])
    end;
send_nine_rank_list(State, RoleId, ServerId) ->
    %ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #nine_state{group_id = GroupId, zone_id = ZoneId} = State,
    send_nine_rank_list_help(State, RoleId, ServerId, ZoneId, GroupId),
    ok.

%% 辅助函数
send_nine_rank_list_help(State, RoleId, ServerId, ZoneId, GroupId) ->
    #nine_state{zone_map = ZoneMap} = State,
    #nine_zone{f_role_list = FRoleL, firsts = [FirstSerNum, _, FirstName]} = maps:get({ZoneId, GroupId}, ZoneMap, #nine_zone{}),
    F = fun({FIndex, FSerNum, _, RName}) -> {FIndex, FSerNum, RName} end,
    SendFRoleL = lists:map(F, FRoleL),
    {ok, BinData} = pt_135:write(13501, [FirstSerNum, FirstName, SendFRoleL]),
    send_to_uid(ServerId, RoleId, BinData),
    ok.

%% 参战
apply_war(#nine_state{status = Status} = State, NineRank, _LayerId, _EnterType) when Status =/= ?STATE_OPEN ->
    #nine_rank{role_id = RoleId, server_id = ServerId} = NineRank,
    {ok, BinData} = pt_135:write(13502, [?ERRCODE(err135_not_open)]),
    send_to_uid(ServerId, RoleId, BinData),
    {noreply, State};
apply_war(#nine_state{state_type = ?CLS_TYPE_GAME, mod = Mod, group_id = GroupId, role_map = RoleMap} = State, NineRank, LayerId, EnterType) ->
    case is_cls_open(Mod) of
        false ->
            #nine_rank{role_id = RoleId} = NineRank,
            case maps:get(RoleId, RoleMap, false) of
                false -> NewLayerId = LayerId;
                TempNineRank ->NewLayerId = TempNineRank#nine_rank.layer_id
            end,
            if
                %% 掉层
                EnterType == true ->
                    {noreply, NewState} = role_enter(State, NineRank#nine_rank{group_id = ?DEFAULT_GROUP_ID, zone_id = ?DEFAULT_ZONE_ID},
                        NewLayerId, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID, EnterType, false, []);
                true ->
                    {noreply, NewState} = role_enter(State, NineRank#nine_rank{group_id = ?DEFAULT_GROUP_ID, zone_id = ?DEFAULT_ZONE_ID},
                        NewLayerId, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID, EnterType,  true, [{action_lock, ?ERRCODE(err135_can_not_change_scene_in_nine)}])
            end,

            {noreply, NewState};
        true ->
            NewState = State,
            mod_nine_center:cast_center([{apply, apply_war, [NineRank#nine_rank{mod = Mod}, LayerId, GroupId, EnterType]}])
    end,
    {noreply, NewState}.
apply_war(State, NineRank, LayerId, GroupId, EnterType) ->
    #nine_state{role_map = RoleMap} = State,
    #nine_rank{role_id = RoleId, server_id = ServerId} = NineRank,
    case maps:get(RoleId, RoleMap, false) of
        false -> NewNineRank = NineRank, NewLayerId = LayerId;
        TempNineRank -> NewNineRank = TempNineRank, NewLayerId = NewNineRank#nine_rank.layer_id
    end,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    if
        %% 掉层
        EnterType == true ->
            {noreply, NewState} = role_enter(State, NewNineRank#nine_rank{group_id = GroupId, zone_id = ZoneId}, NewLayerId, ZoneId, GroupId, EnterType, false, []);
        true ->
            {noreply, NewState} = role_enter(State, NewNineRank#nine_rank{group_id = GroupId, zone_id = ZoneId}, NewLayerId, ZoneId, GroupId, EnterType, true, [{action_lock, ?ERRCODE(err135_can_not_change_scene_in_nine)}])
    end,
    {noreply, NewState}.

%% 玩家进入的逻辑处理
%% @param IsDropLayer 是否掉层    IsDropLayer == enter 野外进入，则用原来的层数
%%
role_enter(OldState, #nine_rank{world_lv = WorldLv, mod = Mod, role_id = RoleId} = NineRank, LayerIdOld, ZoneId, GroupId, _IsDropLayer, NeedOut, OtherKeyValueList) ->
    {CopyId, AfCheckNineRank, State} = copy_check_and_create(NineRank, OldState, ZoneId, GroupId, Mod, WorldLv, LayerIdOld),
    %% 不掉层了
    LayerId = LayerIdOld,
    #nine_state{zone_map = ZoneMap, role_map = RoleMap, cls_type = ClsType, group_map = GroupMap} = State,
    #nine_zone{firsts = OldFirsts} = Zone = maps:get({ZoneId, GroupId}, ZoneMap, #nine_zone{}),
    ModMaxLayerId = data_nine:get_max_layer_id(Mod),
    NineRankAfCopy = AfCheckNineRank,
    %% 首次登陆奖励
    #nine_rank{role_id = RoleId, name = Name, server_id = ServerId, server_num = ServerNum, max_layer_id = MaxLayerId, reward = Reward} = NineRankAfCopy,
    NineRankAfLayer = NineRankAfCopy#nine_rank{layer_id = LayerId, max_layer_id = max(LayerId, MaxLayerId)},
    #base_nine{first_award = FirstAward, award = Award, scene_id = BfSceneId, cls_scene_id = ClsSceneId, born_pos = BornPosL} = data_nine:get_nine(Mod, LayerId),
    Firsts = case LayerId >= ModMaxLayerId andalso OldFirsts == ?DEFAULT_FIRSTS of
        true ->
            % 发送奖励
            dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, ?NINE_AWARD_TYPE_FIRST, FirstAward]),
            log_nine(NineRankAfLayer, ?NINE_AWARD_TYPE_FIRST, 0, 0, FirstAward),
            % 登顶传闻
            zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId,  lib_chat, send_TV, [{all}, ?MOD_NINE, 2, [Name]]),
            NewReward = FirstAward++Reward,
            [ServerNum, RoleId, Name];
        false ->
            NewReward = Reward,
            OldFirsts
    end,
    %% 层数奖励
    case LayerId>MaxLayerId of
        true->
            % 发送奖励
            dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, ?NINE_AWARD_TYPE_LAYER, Award]),
            log_nine(NineRankAfLayer, ?NINE_AWARD_TYPE_LAYER, 0, 0, Award),
            NewReward2 = Award++NewReward;
        false ->
            NewReward2 = Award++NewReward
    end,
    %% 发送信息
    NewZone = Zone#nine_zone{firsts = Firsts},
    ZoneKey = ?IF(ClsType == ?CLS_TYPE_CENTER, {ZoneId, GroupId}, {?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}),
    NewZoneMap = maps:put(ZoneKey, NewZone, ZoneMap),
    NineRankAfReward = NineRankAfLayer#nine_rank{reward = NewReward2},
    NewRoleMap = maps:put(RoleId, NineRankAfReward, RoleMap),
    NewState = State#nine_state{zone_map = NewZoneMap, role_map = NewRoleMap},
    {ok, BinData} = pt_135:write(13502, [?SUCCESS]),
    send_to_uid(ServerId, RoleId, BinData),
    send_battle_info(NewState, NineRankAfReward),
    send_flag_info(NewState, RoleId, ServerId, ZoneId, CopyId),
    KeyValueList = [
        {group, 0}
        , {nine_mod, {Mod, LayerId}}
        , {change_scene_hp_lim, 100}
        , {ghost, 0}
        |OtherKeyValueList
        ],
    case util:is_cls() of
        true -> SceneId = ClsSceneId;
        false -> SceneId = BfSceneId
    end,
    {X, Y} = urand:list_rand(BornPosL),
    dispatch_execute(ServerId, lib_scene, player_change_scene, [RoleId, SceneId, ZoneId, CopyId, X, Y, NeedOut, KeyValueList]),
    %%通知活动日历，参与活动
    dispatch_execute(ServerId, lib_activitycalen_api, role_success_end_activity, [RoleId, ?MOD_NINE, 0]),
    case maps:get(RoleId, RoleMap, 0) of
        %% 第一次进入
        0 ->
            % 事件触发
            CallbackData = #callback_join_act{type = ?MOD_NINE},
            dispatch_execute(ServerId, lib_player_event, async_dispatch, [RoleId, ?EVENT_JOIN_ACT, CallbackData]),
            dispatch_execute(ServerId, lib_baby_api, join_nine, [RoleId]);
        _ -> skip
    end,
    {noreply, NewState}.

%% 获得玩家信息
update_nine_rank_af_enter(State, NineRank, ZoneId) ->
    #nine_state{role_map = RoleMap} = State,
    #nine_rank{role_id = RoleId} = NineRank,
    NewNineRank = maps:get(RoleId, RoleMap, NineRank),
    #nine_rank{
        name = Name,
        career = Career,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower
    } = NineRank,
    NewNineRank#nine_rank{
        name = Name,
        career = Career,
        server_id = ServerId,
        zone_id = ZoneId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower,
        is_on = 1
    }.

%% 退出战斗
quit(#nine_state{status = Status} = State, _RoleId, _ServerId, _SceneId) when Status =/= ?STATE_OPEN -> {noreply, State};
quit(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, RoleId, ServerId, SceneId) ->
    case is_nine_bf_scene(State, SceneId) of
        true ->
            case ClsType == ?CLS_TYPE_GAME of
                true -> do_quit(State, RoleId, ServerId);
                false ->
                    mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId, SceneId]}]),
                    {noreply, State}
            end;
        false -> {noreply, State}
    end;
quit(State, RoleId, ServerId, SceneId) ->
    case is_nine_cls_scene(State, SceneId) of
        true -> do_quit(State, RoleId, ServerId);
        false -> {noreply, State}
    end.


do_quit(State, RoleId, _ServerId) ->
    #nine_state{role_map = RoleMap, zone_map = ZoneMap, state_type = _StateType, cls_type = ClsType, group_map = GroupMap} = State,
    case maps:get(RoleId, RoleMap, false) of
        false ->
            NewRoleMap = RoleMap, NewZoneMap = ZoneMap;
        #nine_rank{zone_id = ZoneId, group_id = GroupId, mod = Mod, layer_id = LayerId, copy_id = CopyId} = NineRank ->
            NewNineRank = NineRank#nine_rank{is_on=0},  %%修改下，保存退出信息
            NewRoleMap = maps:put(RoleId, NewNineRank, RoleMap),
            case maps:get({ZoneId, GroupId}, ZoneMap, false) of
                #nine_zone{fid = RoleId, copy_list = OldCopyList, findex = FIndex} = Zone ->
                    #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId} = data_nine:get_nine(Mod, data_nine:get_max_layer_id(Mod)),
                    case ClsType == ?CLS_TYPE_GAME of
                        true -> SceneId = BfSceneId;
                        false -> SceneId = ClsSceneId
                    end,
                    MaxLayerId = data_nine:get_max_layer_id(Mod),
                    NewCopyList = leave_old_copy(OldCopyList, LayerId, CopyId, MaxLayerId),
                    lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, GroupId, 1, [?NINE_KV_FLAG_MON_ID]),
                    FlagSec = calc_flag_sec(State),
                    {ok, BinData} = pt_135:write(13504, [FIndex, 0, 0, <<>>, FlagSec]),
                    %send_to_scene(ClsType, ZoneId, GroupId, Mod, BinData),
                    send_to_all(ClsType, RoleMap, ZoneId, GroupId, BinData),
                    {X, Y} = ?NINE_KV_FLAG_MON_XY,
                    lib_mon:async_create_mon(?NINE_KV_FLAG_MON_ID, SceneId, ZoneId, X, Y, 0, GroupId, 1, []),
                    % 秘宝出现
                    zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId, lib_chat, send_TV, [{all}, ?MOD_NINE, 3, []]),
                    NewZone = Zone#nine_zone{fid = 0, fname = "", f_server_num = 0, copy_list = NewCopyList},
                    ZoneKey = ?IF(ClsType == ?CLS_TYPE_CENTER, {ZoneId, NewZone#nine_zone.group_id}, {?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}),
                    NewZoneMap = maps:put(ZoneKey, NewZone, ZoneMap);
                #nine_zone{copy_list = OldCopyList} =Zone ->
                    MaxLayerId = data_nine:get_max_layer_id(Mod),
                    NewCopyList = leave_old_copy(OldCopyList, LayerId, CopyId, MaxLayerId),
                    NewZone = Zone#nine_zone{copy_list = NewCopyList},
                    ZoneKey = ?IF(ClsType == ?CLS_TYPE_CENTER, {ZoneId, NewZone#nine_zone.group_id}, {?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID}),
                    NewZoneMap = maps:put(ZoneKey, NewZone, ZoneMap);
                _ ->
                    NewZoneMap = ZoneMap
            end
    end,
    NewState = State#nine_state{role_map = NewRoleMap, zone_map = NewZoneMap},
    {noreply, NewState}.

%% 发送战斗信息
send_battle_info(State, NineRank) ->
    #nine_state{etime = Etime, zone_map = ZoneMap} = State,
    #nine_rank{role_id = RoleId, server_id = ServerId, zone_id = ZoneId, group_id = GroupId, layer_id = LayerId, max_layer_id = MaxLayerId, kill = Kill, score = Score} = NineRank,
    #nine_zone{firsts = [ServerNum, _FirstId, FirstName]} = maps:get({ZoneId,GroupId}, ZoneMap, #nine_zone{}),
    {ok, BinData} = pt_135:write(13503, [LayerId, MaxLayerId, max(Etime, 0), Kill, Score, ServerNum, FirstName]),
    send_to_uid(ServerId, RoleId, BinData),
    ok.

send_flag_info(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType, status = Status, zone_id = ZoneId, group_id = GroupId} = State, RoleId, ServerId) ->
    case ClsType == ?CLS_TYPE_GAME orelse Status =/= ?STATE_OPEN of
        true -> send_flag_info_help(State, RoleId, ServerId, ZoneId, GroupId);
        false -> mod_nine_center:cast_center([{apply, send_flag_info, [RoleId, ServerId]}])
    end,
    ok;
send_flag_info(State, RoleId, ServerId) ->
    #nine_state{group_map = GroupMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ServerModMap, _} = maps:get(ZoneId, GroupMap, {#{}, #{}}),
    {_, GroupId} = maps:get(ServerId, ServerModMap, {0,0}),
    send_flag_info(State, RoleId, ServerId, ZoneId, GroupId),
    ok.


%% 秘宝信息
send_flag_info(#nine_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType, status = Status} = State, RoleId, ServerId, ZoneId, GroupId) ->
    % 本服开启或者活动没有开启
    case ClsType == ?CLS_TYPE_GAME orelse Status =/= ?STATE_OPEN of
        true -> send_flag_info_help(State, RoleId, ServerId, ?DEFAULT_ZONE_ID, ?DEFAULT_GROUP_ID);
        false -> mod_nine_center:cast_center([{apply, send_flag_info, [RoleId, ServerId, ZoneId, GroupId]}])
    end,
    ok;
send_flag_info(State, RoleId, ServerId, ZoneId, GroupId) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    send_flag_info_help(State, RoleId, ServerId, ZoneId, GroupId),
    ok.

send_flag_info_help(State, RoleId, ServerId, ZoneId, GroupId) ->
    #nine_state{zone_map = ZoneMap} = State,
    #nine_zone{fid = Fid, fname = Fname, f_server_num = FSerNum, findex = FIndex} = maps:get({ZoneId, GroupId}, ZoneMap, #nine_zone{}),
    FlagSec = calc_flag_sec(State),
    {ok, BinData} = pt_135:write(13504, [FIndex, FSerNum, Fid, Fname, FlagSec]),
    send_to_uid(ServerId, RoleId, BinData),
    ok.

%% 是否本服执行
is_bf_execute(#nine_state{cls_type = ClsType, status = Status, mod = Mod}) ->
    % 是否本服活动开启
    Bool1 = ClsType == ?CLS_TYPE_GAME andalso Status == ?STATE_OPEN,
    % 没有达到跨服开启且没有活动
    Bool2 = is_cls_open(Mod) == false andalso Status =/= ?STATE_OPEN,
    Bool1 orelse Bool2.

%% 派发执行
dispatch_execute(ServerId, M, F, A) ->
    case util:is_cls() of
        true -> mod_clusters_center:apply_cast(ServerId, M, F, A);
        false -> erlang:apply(M, F, A)
    end.

%% 跨服中心给玩家发协议
send_to_uid(ServerId, RoleId, BinData) ->
    case util:is_cls() of
        true -> mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
        false -> lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% 区域派发处理[本地进程使用]
zone_dispatch_execute(#nine_state{cls_type = ClsType, status = Status}, M, F, A) ->
    case ClsType == ?CLS_TYPE_CENTER andalso Status == ?STATE_OPEN of
        true -> erlang:apply(M, F, A);
        false -> ok
    end;
%% 区域派发[要在本服判断是否开启活动]
zone_dispatch_execute(ZoneId, M, F, A) ->
    case util:is_cls() of
        true -> mod_zone_mgr:apply_cast_to_zone(1, ZoneId, mod_nine_local, zone_dispatch_execute, [M, F, A]);
        false -> erlang:apply(M, F, A)
    end.

%% 区域派发[要在本服判断是否开启活动]
zone_dispatch_execute(GroupMap, ZoneId, ModNum, GroupId, M, F, A) ->
    case util:is_cls() of
        true ->
            case maps:get(ZoneId, GroupMap, false) of
                false -> skip;
                {_, ZonesMap} ->
                    case maps:get({ModNum, GroupId}, ZonesMap, false) of
                        false -> skip;
                        ZoneList ->
                            [ mod_clusters_center:apply_cast(ServerId,mod_nine_local, zone_dispatch_execute, [M, F, A])
                                ||#zone_base{server_id = ServerId}<-ZoneList]
                    end
            end;
        false -> erlang:apply(M, F, A)
    end.

%% @param Type 1积分 2层 3秘宝 4顶层首奖 5结算奖励
add_award(_RoleId, _Type, []) -> skip;
add_award(RoleId, Type, Award) ->
    Produce = #produce{type = role_nine, subtype = Type, reward = Award, remark = "", show_tips = ?SHOW_TIPS_3},
    lib_goods_api:send_reward_with_mail(RoleId, Produce),
    ok.

%% 发送到场景
send_to_scene(ClsType, {ZoneId, GroupId}, GroupId, Mod, BinData) -> send_to_scene(ClsType, ZoneId, GroupId, Mod, BinData);
send_to_scene(ClsType, ZoneId, GroupId, Mod, BinData) ->
    F = fun(LayerId) ->
        #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId} = data_nine:get_nine(Mod, LayerId),
        case ClsType == ?CLS_TYPE_GAME of
            true -> SceneId = BfSceneId;
            false -> SceneId = ClsSceneId
        end,
%%        ?PRINT("@@@@~p ~p ~p ~p ~n", [SceneId, ZoneId, GroupId, BinData]),
        lib_server_send:send_to_scene(SceneId, ZoneId, GroupId, BinData)
    end,
    lists:foreach(F, data_nine:get_nine_layer_id_list(Mod)),
    ok.

send_to_all(ClsType, RoleMap, _ZoneId, _GroupId, BinData) ->
    case util:is_cls() of
        true -> ZoneId = _ZoneId, GroupId = _GroupId;
        _ -> ZoneId = ?DEFAULT_ZONE_ID, GroupId = ?DEFAULT_GROUP_ID
    end,
    RoleList = maps:values(RoleMap),
    [case ClsType of
         ?CLS_TYPE_CENTER -> mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [RoleId, BinData]);
         _ -> lib_server_send:send_to_uid(RoleId, BinData)
     end ||#nine_rank{role_id = RoleId, server_id = SerId, zone_id = ZoneId0, group_id = GroupId0, is_on = 1}
        <-RoleList, ZoneId0 == ZoneId andalso GroupId == GroupId0],
    ok.


%% 日志
log_nine(_Nine, _Type, _MinGrade, _MaxGrade, []) -> skip;
log_nine(Nine, Type, MinGrade, MaxGrade, Award) ->
    #nine_rank{role_id = RoleId, name = Name, layer_id = LayerId, score = CurScore} = Nine,
    lib_log_api:log_nine(RoleId, Name, CurScore, LayerId, Type, MinGrade, MaxGrade, Award),
    ok.

%% 是否跨服场景
%% 九魂圣殿本服场景
is_nine_bf_scene(State, SceneId) ->
    #nine_state{mod = Mod} = State,
    SceneIdList = data_nine:get_nine_scene_list(Mod),
    lists:member(SceneId, SceneIdList).
%% 九魂圣殿跨服场景
is_nine_cls_scene(State, SceneId) ->
    #nine_state{mod = Mod} = State,
    SceneIdList = data_nine:get_nine_cls_scene_list(Mod),
    lists:member(SceneId, SceneIdList).

%% 离开之前的房间
leave_old_copy(OldCopyList, LayerId, _OldCopyId, LayerId) -> OldCopyList;
leave_old_copy(OldCopyList, OldLayerId, OldCopyId, _MaxLayerId) ->
    case lists:keyfind({OldCopyId, OldLayerId}, 1, OldCopyList) of
        false -> OldCopyList;
        {_, RoleNum} ->
            lists:keystore({OldCopyId, OldLayerId}, 1, OldCopyList, {{OldCopyId, OldLayerId}, max(RoleNum - 1, 0)})
    end.


%% 获取九魂房间号, 最高层不分房间！！
get_copy_id(NineZone, LayerId, LayerId) ->
    #nine_zone{copy_list = CopyList, group_id = GroupId} = NineZone,
    CopyId = GroupId,
    {_, OldNum} = ulists:keyfind({CopyId, LayerId}, 1, CopyList, {{CopyId, LayerId}, 0}),
    NewRoleNum = OldNum + 1,
    NewCopyList = lists:keystore({CopyId, LayerId}, 1, CopyList, {{CopyId, LayerId}, NewRoleNum}),
    {CopyId, false, NewCopyList};
get_copy_id(NineZone, LayerId, _MaxLayerId) ->
    #nine_zone{copy_list = CopyList, group_id = GroupId} = NineZone,
    FilterList = lists:filter(fun({{_, CLayerId}, _}) -> CLayerId == LayerId end, CopyList),
    SortCopyList = lists:sort(fun({_, RoleNum1}, {_, RoleNum2}) ->RoleNum1 < RoleNum2 end, FilterList),
    case SortCopyList of
        [] ->
            CopyId = lists:concat([GroupId, "_", nine_copy, "_", 1]),
            IsNewRoom = true,
            NewCopyList = lists:keystore({CopyId, LayerId}, 1, CopyList, {{CopyId, LayerId}, 1});
        [{{OldCopyId, _}, RoleNum}|_] ->
            IsNewCopyId = RoleNum >= ?NINE_KV_COPY_NUM,
            if
                IsNewCopyId ->
                    IsNewRoom = true,
                    CopyId = new_copy_id(GroupId, SortCopyList),
                    NewCopyList = [{{CopyId, LayerId}, 1}|CopyList];
                true ->
                    IsNewRoom = false,
                    CopyId = OldCopyId,
                    NewCopyList = lists:keystore({OldCopyId, LayerId}, 1, CopyList, {{OldCopyId, LayerId}, RoleNum+1})
            end
    end,
    {CopyId, IsNewRoom, NewCopyList}.

new_copy_id(GroupId, CopyList) ->
    Length = length(CopyList) + 1,
    lists:concat([GroupId, "_", nine_copy, "_", Length]).

%% 只发给第九层的人
%%send_13510(ClsType, Mod, ZoneId, GroupId, RoleId) ->
%%    MaxLayer = data_nine:get_max_layer_id(Mod),
%%    #base_nine{scene_id = BfSceneId, cls_scene_id = ClsSceneId} = data_nine:get_nine(Mod, MaxLayer),
%%    SceneId = ?IF(ClsType == ?CLS_TYPE_GAME, BfSceneId, ClsSceneId),
%%    send_13510(SceneId, ZoneId, GroupId, RoleId).
%%send_13510(SceneId, PoolId, CopyId, RoleId) ->
%%    mod_scene_agent:apply_cast(SceneId, PoolId, ?MODULE, send_13510, [CopyId, RoleId]).
%%send_13510(GroupId, RoleId) ->
%%    case lib_scene_agent:get_user(RoleId) of
%%        #ets_scene_user{figure = Figure} ->
%%            {ok, BinData} = pt_135:write(13510, [Figure]),
%%            lib_scene_agent:send_to_local_scene(GroupId, BinData);
%%        _ -> skip
%%    end.


%% -----------------------------------------------------------------
%% 数据库
%% -----------------------------------------------------------------

%% 获取
db_role_nine_get() ->
    db:get_all(io_lib:format(?SQL_ROLE_NINE_GET, [])).

%% 批量存储
db_role_nine_batch(Ranks) ->
    SubSQL = splice_sql(Ranks, []),
    case SubSQL == [] of
        true -> skip;
        false ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?SQL_ROLE_NINE_BATCH, [SQL]),
%%            ?MYLOG("zhnine", "NSQL ~s ~n", [NSQL]),
            db:execute(NSQL)
    end,
    ok.

splice_sql([], UpdateSQL) ->
    UpdateSQL;
splice_sql([Rank | Rest], UpdateSQL) ->
    #nine_rank{
        zone_id = ZoneId,
        role_id = RoleId,
        group_id = GroupId,
        name    = Name,
        career  = Career,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        max_layer_id = MaxLayerId,
        max_kill  = MaxKill,
        max_dkill = MaxDKill,
        score  = Score
    } = Rank,
    NameBin = util:fix_sql_str(Name),
    ServerNameBin = util:make_sure_binary(ServerName),
    SQL = io_lib:format(?SQL_ROLE_NINE_VALUES, [ZoneId, GroupId, RoleId, NameBin, Career, ServerId, ServerNameBin, ServerNum, MaxLayerId, MaxKill, MaxDKill, Score]),
    splice_sql(Rest, [SQL | UpdateSQL]).

db_role_nine_truncate() ->
    db:execute(io_lib:format(?SQL_ROLE_NINE_TRUNCATE, [])).

%% 获得战斗信息
get_battle_info(State, RoleId) ->
    #nine_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, false) of
        false -> {noreply, State};
        NineRank -> send_battle_info(State, NineRank)
    end.