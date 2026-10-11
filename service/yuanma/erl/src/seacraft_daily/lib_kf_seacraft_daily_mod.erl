%%%-----------------------------------
%%% @Module      : lib_kf_seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 17:14
%%% @Description : 海战日常
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_kf_seacraft_daily_mod).
-author("carlos").
-include("common.hrl").
-include("errcode.hrl").
-include("seacraft_daily.hrl").
-include("scene.hrl").
-include("clusters.hrl").
-include("predefine.hrl").
-include("battle.hrl").
-include("def_module.hrl").

%% API
-export([]).




init() ->
    %% 初始化
    ZoneLvList = calc_lv(),
    RankList = get_role_rank_list(),
%%    SceneId = data_sea_craft_daily:get_kv(scene_id),
%%    {X1, Y1} = data_sea_craft_daily:get_kv(statue_coord),
%%    {X2, Y2} = data_sea_craft_daily:get_kv(guard_coord),
    F = fun({ZoneId, _Lv}, ZoneList) ->
        F2 = fun(SeaId, AccList) ->
            BrickNum = get_sea_brick(ZoneId, SeaId),
            SeaRankList =
                case lists:keyfind({ZoneId, SeaId}, 1, RankList) of
                    {_, V} ->
                        V;
                    _ ->
                        []
                end,
            %%初始化话场景里的怪物  ZoneId 为场景进程id  SeaId 为房间id
            StatueId = create_mon(statue, ZoneId, SeaId, ZoneLvList, []),
            GuardId = create_mon(guard, ZoneId, SeaId, ZoneLvList, []),
            SeaMsg = #sea_msg{zone_id = ZoneId, sea_id = SeaId, brick_num = BrickNum,
                statue_status = ?live, guard_status = ?live, rank_list = SeaRankList,
                statue_id = StatueId, guard_id = GuardId},
            [SeaMsg | AccList]
             end,
        SeaListIds = data_seacraft:get_all_camp(),
        SeaList = lists:foldl(F2, [], SeaListIds),
        ZoneMsg = #zone_msg{sea_list = SeaList, zone_id = ZoneId},
        [ZoneMsg | ZoneList]
        end,
    ZoneMsgList = lists:foldl(F, [], ZoneLvList),
    Ref = calc_ref([]),
%%    ?MYLOG("cym", "ZoneMsgList ~p~n", [ZoneMsgList]),
    #sea_craft_daily_state{zone_list = ZoneMsgList, ref = Ref}.


%%计算小跨服的平均世界等级 返回 [{ZoneId, AvgLv}]
calc_lv() ->
    ServerList = mod_zone_mgr:get_all_zone(),
    List = calc_lv(ServerList, []),
    NewList = [{ZoneId, erlang:round(AllLv / Num)} || {ZoneId, AllLv, Num} <- List],
    NewList.

calc_lv([], AccList) ->
    AccList;
calc_lv([#zone_base{zone = ZoneId, world_lv = Lv} | ServerList], AccList) ->
    case lists:keyfind(ZoneId, 1, AccList) of
        {_, OldLv, OldNum} ->
            NewAccList = lists:keystore(ZoneId, 1, AccList, {ZoneId, OldLv + Lv, OldNum + 1});
        _ ->
            NewAccList = lists:keystore(ZoneId, 1, AccList, {ZoneId, Lv, 1})
    end,
    calc_lv(ServerList, NewAccList).


%% -----------------------------------------------------------------
%% @desc     功能描述   从数据库中查询玩家的贡献数据
%% @param    参数
%% @return   返回值    [{{ZoneId, SeaId}, RankList}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_role_rank_list() ->
    ZoneList = mod_zone_mgr:get_all_zone(),
    Sql = io_lib:format(?select_role_rank, []),
    List = db:get_all(Sql),
    F = fun([RoleId, SeaId, RoleName, ServerId, ServerNum, ServerName, Pos, BrickNum, Power], AccList) ->
        ZoneId = get_zone_id(ServerId, ZoneList),
        Role = #role_rank{
            role_id = RoleId,
            role_name = binary_to_list(RoleName),
            sea_id = SeaId,
            server_id = ServerId,
            server_num = ServerNum,
            server_name = binary_to_list(ServerName),
            pos = Pos,
            brick_num = BrickNum
            , power = Power

        },
        case lists:keyfind({ZoneId, SeaId}, 1, AccList) of
            {_, RankList} ->
                lists:keystore({ZoneId, SeaId}, 1, AccList, {{ZoneId, SeaId}, [Role | RankList]});
            _ ->
                lists:keystore({ZoneId, SeaId}, 1, AccList, {{ZoneId, SeaId}, [Role]})
        end
        end,
    lists:foldl(F, [], List).


get_zone_id(ServerId, ZoneList) ->
    case lists:keyfind(ServerId, #zone_base.server_id, ZoneList) of
        #zone_base{zone = ZoneId} ->
            ZoneId;
        _ ->
            0
    end.



get_sea_brick(ZoneId, SeaId) ->
    Sql = io_lib:format(?select_sea_msg, [ZoneId, SeaId]),
    case db:get_row(Sql) of
        [BrickNum] ->
            BrickNum;
        _ ->
            data_sea_craft_daily:get_kv(default_brick)
    end.

get_sea_brick2(SeaId, SeaList) ->
    case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
        #sea_msg{brick_num = Num} ->
            Num;
        _ ->
            0
    end.


%%整点定时器
calc_ref(OldRef) ->
    {_, {_H, M, S}} = utime:localtime(),
    Time = if
               M == 0 andalso S == 0 ->
                   1;
               true ->
                   (59 - M) * 60 + (60 - S)
           end,
    util:send_after(OldRef, max(1, Time) * 1000, self(), {boss_reborn}).



boss_reborn(BossType, ZoneId, SeaId, State) ->
    %%
%%    ?MYLOG("cym", "boss_reborn ~p~n", [{BossType, ZoneId, SeaId}]),
%%    ?MYLOG("cym", "ZoneId ~p, SeaId  ~p", [ZoneId, SeaId]),
    ZoneLvList = calc_lv(),
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{statue_ref = _StatueRef, guard_ref = _GuardRef, guard_small_list = GuardSmallList, statue_small_list = StatueSmallList} = SeaMsg ->
%%                    ?MYLOG("cym", "ZoneId ~p, SeaId  ~p", [ZoneId, SeaId]),
                    if
                        BossType == ?MON_SYS_BOSS_TYPE_SEA_STATUE ->
                            StatueId = create_mon(statue, ZoneId, SeaId, ZoneLvList, StatueSmallList),
                            SeaMsgNew = SeaMsg#sea_msg{statue_id = StatueId, statue_status = ?live, statue_small_list = []},
                            SeaListNew = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, SeaMsgNew),
                            ZoneListNew = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, ZoneMsg#zone_msg{sea_list = SeaListNew}),
                            State#sea_craft_daily_state{zone_list = ZoneListNew};
                        BossType == ?MON_SYS_BOSS_TYPE_SEA_GUARD ->
                            GuardId = create_mon(guard, ZoneId, SeaId, ZoneLvList, GuardSmallList),
                            SeaMsgNew = SeaMsg#sea_msg{guard_id = GuardId, guard_status = ?live, guard_small_list = []},
                            SeaListNew = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, SeaMsgNew),
                            ZoneListNew = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, ZoneMsg#zone_msg{sea_list = SeaListNew}),
                            State#sea_craft_daily_state{zone_list = ZoneListNew};
                        true ->
                            State
                    end;
                _ ->
                    State
            end;
        _ ->
            State
    end.



%%%% -----------------------------------------------------------------
%%%% @desc     功能描述   boss重生 策略，状态全部置为复活 ， 检查之前的状态，如果为死亡则立即创建怪物
%%%% @param    参数       State
%%%% @return   返回值     NewState
%%%% @history  修改历史
%%%% -----------------------------------------------------------------
%%boss_reborn(State) -> %% 检查检查
%%    ZoneLvList = calc_lv(),
%%    #sea_craft_daily_state{zone_list = ZoneList, ref = OldRef} = State,
%%%%    ?MYLOG("cym", "ZoneList ~p~n", [ZoneList]),
%%    F = fun(#zone_msg{sea_list = SeaList, zone_id = ZoneId} = OldZone, AccList) ->
%%        F2 = fun(SeaMsg, AccList2) ->
%%            #sea_msg{statue_status = Statue, guard_status = Guard, sea_id = SeaId} = SeaMsg,
%%            if
%%                Statue == ?die ->
%%                    StatueId = create_mon(statue, ZoneId, SeaId, ZoneLvList),
%%                    SeaMsgNew = SeaMsg#sea_msg{statue_id = StatueId};
%%                true ->
%%                    SeaMsgNew = SeaMsg
%%            end,
%%            if
%%                Guard == ?die ->
%%                    GuardId = create_mon(guard, ZoneId, SeaId, ZoneLvList),
%%                    SeaMsgNew2 = SeaMsgNew#sea_msg{guard_id = GuardId};
%%                true ->
%%                    SeaMsgNew2 = SeaMsgNew
%%            end,
%%            SeaMsgNew3 = SeaMsgNew2#sea_msg{statue_status = ?live, guard_status = ?live},
%%            [SeaMsgNew3 | AccList2]
%%             end,
%%        NewSeaList = lists:foldl(F2, [], SeaList),
%%        NewZone = OldZone#zone_msg{sea_list = NewSeaList},
%%        [NewZone | AccList]
%%        end,
%%    NewZoneList = lists:foldl(F, [], ZoneList),
%%    NewRef = calc_ref(OldRef),
%%    State#sea_craft_daily_state{zone_list = NewZoneList, ref = NewRef}.

get_all_statue_boss() ->
    [BossId||[_, BossId]<-data_sea_craft_daily:get_all_boss()].

get_all_guard_boss() ->
    [BossId||[BossId, _]<-data_sea_craft_daily:get_all_boss()].


create_mon(statue, ZoneId, SeaId, ZoneLvList, ClearList) -> %%创建雕像
%%    ?MYLOG("mon", "ZoneId ~p, SeaId  ~p", [ZoneId, SeaId]),
    SceneId = data_sea_craft_daily:get_kv(scene_id),
    {X, Y} = data_sea_craft_daily:get_kv(statue_coord),
    lib_mon:clear_scene_mon_by_ids(SceneId, ZoneId, 1, ClearList),
    case lists:keyfind(ZoneId, 1, ZoneLvList) of
        {_, Lv} ->
            [_GuardId, StatueId] = data_sea_craft_daily:get_boss_id(Lv),
            %% 清理怪物，保证不会多刷
            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, SeaId, 1, get_all_statue_boss()),
%%            ?MYLOG("cym", "~p~n", [{50001201, 50001202, 50001203, 50001204}]),
            lib_mon:async_create_mon(StatueId, SceneId, ZoneId, X, Y, 0, SeaId, 1, [{group, SeaId}]),
            StatueId;
        _R ->
%%            ?MYLOG("cym", "~p ~n", [_R]),
            0
    end;
create_mon(guard, ZoneId, SeaId, ZoneLvList, ClearList) ->  %%创建守卫
%%    ?MYLOG("mon", "ZoneId ~p, SeaId  ~p", [ZoneId, SeaId]),
    SceneId = data_sea_craft_daily:get_kv(scene_id),
    {X, Y} = data_sea_craft_daily:get_kv(guard_coord),
    lib_mon:clear_scene_mon_by_ids(SceneId, ZoneId, 1, ClearList),
    case lists:keyfind(ZoneId, 1, ZoneLvList) of
        {_, Lv} ->
            [GuardId, _StatueId] = data_sea_craft_daily:get_boss_id(Lv),
            %% 清理怪物，保证不会多刷
            lib_mon:clear_scene_mon_by_mids(SceneId, ZoneId, SeaId, 1, get_all_guard_boss()),
%%            ?MYLOG("cym", "~p~n", [{50001201, 50001202, 50001203, 50001204}]),
            lib_mon:async_create_mon(GuardId, SceneId, ZoneId, X, Y, 0, SeaId, 1, [{group, SeaId}]),
            GuardId;
        _R ->
%%            ?MYLOG("cym", "~p ~n", [_R]),
            0
    end;
create_mon(_, _, _, _, _) ->
    0.


create_small_mon(Type, ZoneId, SeaId, ZoneLvList) ->
    SceneId = data_sea_craft_daily:get_kv(scene_id),
    case lists:keyfind(ZoneId, 1, ZoneLvList) of
        {_, Lv} ->
            [{GuardMonList, StatueMonList}] = data_sea_craft_daily:get_small_mon_list(Lv),
            case Type of
                guard ->
                    MonList = GuardMonList;
                _ ->
                    MonList = StatueMonList
            end,
            F = fun({Mon, X, Y}, AccList) ->
                    MonAutoId = lib_mon:sync_create_mon(Mon, SceneId, ZoneId, X, Y, 0, SeaId, 1, [{group, SeaId}]),
                    [MonAutoId | AccList]
                end,
%%            ?MYLOG("cym", "MonList ~p~n", [MonList]),
            lists:foldl(F, [], MonList);
        _ ->
            []
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述    怪物被击杀  1改变状态， 2完成任务
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
kill_mon(_SceneId, Atter, Klist, Minfo, State) ->
    #scene_object{config_id = MonId, scene_pool_id = ZoneId, copy_id = SeaId} = Minfo,
    case data_mon:get(MonId) of
        #mon{boss = BossType} ->
            ok;
        _ ->
            BossType = 0
    end,
%%    ?MYLOG("mon", "BossType  ~p~n", [BossType]),
    #battle_return_atter{camp_id = KillSeaId, server_num = KillServerNum, real_name = KillName} = Atter,
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{guard_ref = OldGuardRef, statue_ref = OldStatueRef} = Sea ->
                    finish_act(Klist, BossType),
                    ZoneListLv = calc_lv(),
                    NewSea =
                        if
                            BossType == ?MON_SYS_BOSS_TYPE_SEA_STATUE ->
%%                              ?MYLOG("cym", "BossType  ~p~n", [BossType]),
                                %% 发送tv
                                send_mon_be_kill_tv(statue, KillSeaId, KillServerNum, KillName, SeaId, ZoneId),
                                {Ref, Time} = get_boss_reborn_ref(BossType, OldStatueRef, ZoneId, SeaId),
                                MonList = create_small_mon(statue, ZoneId, SeaId, ZoneListLv),
                                Sea#sea_msg{statue_status = ?die,
                                    statue_ref = Ref, statue_reborn_time = Time, statue_small_list = MonList};
                            BossType == ?MON_SYS_BOSS_TYPE_SEA_GUARD ->
                                send_mon_be_kill_tv(guard, KillSeaId, KillServerNum, KillName, SeaId, ZoneId),
                                {Ref, Time} = get_boss_reborn_ref(BossType, OldGuardRef, ZoneId, SeaId),
                                MonList = create_small_mon(guard, ZoneId, SeaId, ZoneListLv),
                                Sea#sea_msg{guard_status = ?die, guard_ref = Ref,
                                    guard_reborn_time = Time, guard_small_list = MonList};
                            true ->
                                Sea
                        end,
                    broadcast_to_copy(NewSea),
                    NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSea),
                    NewZoneMsg = ZoneMsg#zone_msg{sea_list = NewSeaList},
                    NewZoneList = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, NewZoneMsg),
                    State#sea_craft_daily_state{zone_list = NewZoneList};
                _ ->
                    State
            end;
        _ ->
            State
    end.

%% 完成击杀boss任务
finish_act(Klist, BossType) ->
    TeakIds = data_sea_craft_daily:get_task_ids(),
    [begin
         case data_sea_craft_daily:get_task(TeakId) of
             #sea_daily_task_cfg{condition = Condition} ->
                 case check_kill_boss(Condition, BossType) of
                     true ->
                         [mod_clusters_center:apply_cast(ServerId, lib_seacraft_daily, finish_act, [RoleId, TeakId, 1])
                             || #mon_atter{server_id = ServerId, id = RoleId} <- Klist];
                     _ ->
                         skip
                 end;
             _ ->
                 skip
         end
     end
        || TeakId <- TeakIds].

check_kill_boss(Condition, BossType) ->
    case lists:keyfind(kill, 1, Condition) of
        {_, BossType} ->
            true;
        _ ->
            false
    end.

get_info(ServerId, RoleId, BrickColor, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} ->
            InfoList = pack_info(SeaList, BrickColor),
            {ok, Bin} = pt_187:write(18701, [InfoList]),
            send_to_role(ServerId, RoleId, Bin);
        _ ->
            skip
    end.

get_reborn_time(?live) ->
    0;
get_reborn_time(?die) ->
    {_, {_H, M, S}} = utime:localtime(),
    Time = if
               M == 0 andalso S == 0 ->
                   1;
               true ->
                   (59 - M) * 60 + (60 - S)
           end,
    utime:unixtime() + Time.

pack_info(SeaList, BrickColor) ->
    F = fun(#sea_msg{brick_num = BrickNum, sea_id = SeaId,
        statue_status = _Status1, guard_status = _Status2, statue_reborn_time = StatueRebornTime,
        guard_reborn_time = GuardRebornTime}, AccList) ->
        [{SeaId, StatueRebornTime, GuardRebornTime, BrickNum, BrickColor} | AccList]
        end,
    lists:foldl(F, [], SeaList).


send_to_role(ServerId, RoleId, Bin) ->
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).


enter_daily(RoleMsg, EnterSeaId, State) ->
    #role_msg{zone_id = ZoneId, role_id = RoleId, server_id = ServerId} = RoleMsg,
    #sea_craft_daily_state{zone_list = ZoneList, status = Status} = State,
%%    ?MYLOG("cym", "Status ~p~n", [Status]),
%%    ?PRINT("++++++++++++ ~p~n", [Status]),
    if
        Status == ?zone_recalc ->
            {ok, Bin} = pt_187:write(18700, [?FAIL]),
            send_to_role(ServerId, RoleId, Bin),
            State;
        true ->
            case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
                #zone_msg{sea_list = SeaList} = Zone ->
                    case lists:keyfind(EnterSeaId, #sea_msg.sea_id, SeaList) of
                        #sea_msg{role_list = RoleList} = OldSea ->
                            pull_role_into_scene(RoleMsg, EnterSeaId),
                            NewRoleList = lists:keystore(RoleId, #role_msg.role_id, RoleList, RoleMsg),
                            NewSeaList = lists:keystore(EnterSeaId, #sea_msg.sea_id, SeaList, OldSea#sea_msg{role_list = NewRoleList}),
                            NewZoneList = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, Zone#zone_msg{sea_list = NewSeaList}),
                            State#sea_craft_daily_state{zone_list = NewZoneList};
                        _ ->
                            State
                    end;
                _ ->
                    State
            end
    end.
    


pull_role_into_scene(RoleMsg, EnterSeaId) ->
    #role_msg{role_id = RoleId, zone_id = ZoneId, sea_id = MySeaId, server_id = ServerId} = RoleMsg,
    SceneId = data_sea_craft_daily:get_kv(scene_id),
    {X, Y} = get_born_xy(MySeaId, EnterSeaId),
%%	lib_scene:player_change_scene(RoleId, SceneId, ZoneId, EnterSeaId, X, Y, true, []).
    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
        [RoleId, SceneId, ZoneId, EnterSeaId, X, Y, false, [{group, MySeaId},{camp, MySeaId}, {action_lock, ?ERRCODE(err187_in_scene)}, {change_scene_hp_lim, 100}]]).

get_born_xy(SeaId, SeaId) ->
    data_sea_craft_daily:get_kv(my_sea_coord);
get_born_xy(_SeaId, _SeaId2) ->
    data_sea_craft_daily:get_kv(other_sea_coord).




get_scene_msg(ZoneId, ServerId, RoleId, SeaId, CarryCount, DefendCount, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{brick_num = BrickNum, statue_id = BossId1, statue_reborn_time = Time1,
                    guard_id = BossId2, guard_reborn_time = Time2} ->
                    BossPackList = get_boss_pack_list([{BossId1, Time1}, {BossId2, Time2}]),
%%                    ?MYLOG("cymboss", "18703 ~p~n", [{SeaId, BrickNum, CarryCount, DefendCount, BossPackList}]),
                    {ok, Bin} = pt_187:write(18703, [SeaId, BrickNum, CarryCount, DefendCount, BossPackList]),
                    send_to_role(ServerId, RoleId, Bin);
                _ ->
                    ok
            end;
        _ ->
            skip
    end.



get_sea_daily_all_rank(ZoneId, MySeaId, ServerId, RoleId, _RoleName, JobId, Power, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} ->
            F = fun(#sea_msg{rank_list = TempList}, AccRankList) ->
                TempList ++ AccRankList
                end,
            RankList = lists:foldl(F, [], SeaList),
            SortRank = sort_rank(RankList),
            {MyBrickNum, MyRank, MyPower, MyPos} = get_my_rank_msg(RoleId, JobId, Power, SortRank),
            PackInfoList = [{SeaId, Pos, ServerNum, RoleName, RankPower, BrickNum} ||
                #role_rank{
                    pos = Pos, server_num = ServerNum, sea_id = SeaId,
                    role_name = RoleName, power = RankPower, brick_num = BrickNum
                } <- SortRank],
            {ok, Bin} = pt_187:write(18711, [MyBrickNum, MySeaId, MyRank, MyPower, MyPos, PackInfoList]),
            send_to_role(ServerId, RoleId, Bin);
        _ ->
            sikp
    end.



get_daily_rank(ZoneId, SeaId, ServerId, RoleId, _RoleName, JobId, Power, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{rank_list = RankList} ->
                    SortRank = sort_rank(RankList),
                    {MyBrickNum, MyRank, MyPower, MyPos} = get_my_rank_msg(RoleId, JobId, Power, SortRank),
                    PackInfoList = [{Pos, ServerNum, RoleName, RankPower, BrickNum} || #role_rank{pos = Pos, server_num = ServerNum,
                        role_name = RoleName, power = RankPower, brick_num = BrickNum} <- SortRank],
                    {ok, Bin} = pt_187:write(18704, [SeaId, MyBrickNum, MyRank, MyPower, MyPos, PackInfoList]),
%%                    ?MYLOG("cym", "~p~n", [{SeaId, MyBrickNum, MyRank, MyPower, MyPos, PackInfoList}]),
                    send_to_role(ServerId, RoleId, Bin);
                _ ->
                    ok
            end;
        _ ->
            sikp
    end.


get_my_rank_msg(RoleId, JobId, Power, RankList) ->
    case lists:keyfind(RoleId, #role_rank.role_id, RankList) of
        #role_rank{brick_num = BrickNum, power = MyPower, rank = Rank} ->
            {BrickNum, Rank, MyPower, JobId};
        _ ->
            {0, 0, Power, JobId}
    end.


sort_rank(RankList) ->
    F = fun(#role_rank{brick_num = Num1}, #role_rank{brick_num = Num2}) ->
        Num1 >= Num2
        end,
    List = lists:sort(F, RankList),
    sort_rank2(List, 0, []).


sort_rank2([], _PreRank, Res) ->
    lists:reverse(Res);
sort_rank2([Rank | List], PreRank, Res) ->
    sort_rank2(List, PreRank + 1, [Rank#role_rank{rank = PreRank + 1} | Res]).


start_carry_brick(ZoneId, ServerId, RoleId, SeaId, BrickColor, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{role_list = RoleList, brick_num = OldBrickNum} = SeaMsg ->
                    case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
                        #role_msg{sea_id = RoleSeaId} = RoleMsg ->
                            %% 更新本服的形象各种状态，添加临时技能，变为暂时属性
                            notice_local_start_carry_brick(ServerId, RoleId, BrickColor, 0, start_carry),
                            %%发送传闻
                            send_carry_brick_tv(RoleMsg, SeaId),

                            %%更新玩家状态
                            GetNum = get_other_sea_brick_num(OldBrickNum, BrickColor), %% 夺取的数量
                            %% log
                            RoleSeaBrickNum = get_sea_brick2(RoleSeaId, SeaList),
                            lib_log_api:log_sea_craft_daily_carry_brick(RoleId, RoleSeaId, SeaId, RoleSeaBrickNum, OldBrickNum, GetNum, BrickColor, 1, []),
                            %% 组装信息
                            RoleMsgNew = RoleMsg#role_msg{status = ?carrying, brick_color = BrickColor, brick_num = GetNum},
                            RoleListNew = lists:keystore(RoleId, #role_msg.role_id, RoleList, RoleMsgNew),
                            NewSeaMsg = SeaMsg#sea_msg{role_list = RoleListNew, brick_num = OldBrickNum - GetNum},
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_seacraft_local, update_brick_num, [SeaId, OldBrickNum - GetNum]),
                            %% 广播场景信息 03 01
                            broadcast_to_copy(NewSeaMsg),
                            lib_kf_seacraft_daily:save_sea_msg_only_to_db(NewSeaMsg),
                            NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                            ZoneListNew = lists:keystore(ZoneId,
                                #zone_msg.zone_id, ZoneList, ZoneMsg#zone_msg{sea_list = NewSeaList}),
                            StateNew = State#sea_craft_daily_state{zone_list = ZoneListNew},
                            StateNew;
                        _ ->
                            ?ERR("error not have role ~p~n", [RoleId]),
                            State
                    end;
                _ ->
                    ?ERR("error seaId ~p~n", [SeaId]),
                    State
            end;
        _ ->
            ?ERR("error zoneId ~p  ZoneList ~p~n", [ZoneId, ZoneList]),
            State
    end.


end_carry_brick(ZoneId, SeaId, _MySeaId, ServerId, RoleId, State) ->  %% SeaId当前海域
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{role_list = RoleList, brick_num = OldBrickNum} = SeaMsg ->
                    case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
                        #role_msg{brick_color = BrickColor, brick_num = BrickNum, sea_id = RoleSeaId} = RoleMsg ->
                            %% 更新本服的形象各种状态，添加临时技能，变为暂时属性
                            notice_local_start_carry_brick(ServerId, RoleId, BrickColor, 0, end_carry),
                            %%更新玩家状态
                            RoleMsgNew = RoleMsg#role_msg{status = ?common},
                            %%log
                            RoleSeaBrickNum = get_sea_brick2(RoleSeaId, SeaList),
                            lib_log_api:log_sea_craft_daily_carry_brick(RoleId, RoleSeaId, SeaId, RoleSeaBrickNum, OldBrickNum, BrickNum, BrickColor, 2, []),
                            RoleListNew = lists:keystore(RoleId, #role_msg.role_id, RoleList, RoleMsgNew),
                            NewSeaMsg = SeaMsg#sea_msg{role_list = RoleListNew, brick_num = OldBrickNum + BrickNum},
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_seacraft_local, update_brick_num, [SeaId, OldBrickNum + BrickNum]),
                            %% 广播场景信息 03 01
                            broadcast_to_copy(NewSeaMsg),
                            lib_kf_seacraft_daily:save_sea_msg_only_to_db(NewSeaMsg),
                            NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                            ZoneListNew = lists:keystore(ZoneId,
                                #zone_msg.zone_id, ZoneList, ZoneMsg#zone_msg{sea_list = NewSeaList}),
                            StateNew = State#sea_craft_daily_state{zone_list = ZoneListNew},
                            StateNew;
                        _ ->
                            ?ERR("error not have role ~p~n", [RoleId]),
                            State
                    end;
                _ ->
                    ?ERR("error seaId ~p~n", [SeaId]),
                    State
            end;
        _ ->
            ?ERR("error zoneId ~p  ZoneList ~p~n", [ZoneId, ZoneList]),
            State
    end.


quit_sea(ZoneId, SeaId, _ServerId, RoleId, State) ->
%%    ?MYLOG("cym", "quit_sea ~p~n", [{SeaId, _ServerId, RoleId}]),
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{role_list = RoleList} = SeaMsg ->
                    RoleListNew = lists:keydelete(RoleId, #role_msg.role_id, RoleList),
                    NewSeaMsg = SeaMsg#sea_msg{role_list = RoleListNew},
%%                    ?MYLOG("cym", "NewSeaMsg ~p~n", [NewSeaMsg]),
                    NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                    ZoneListNew = lists:keystore(ZoneId,
                        #zone_msg.zone_id, ZoneList, ZoneMsg#zone_msg{sea_list = NewSeaList}),
                    StateNew = State#sea_craft_daily_state{zone_list = ZoneListNew},
                    StateNew;
                _ ->
                    State
            end;
        _ ->
            State
    end.


finish_carry(ZoneId, SeaId, AddSeaId, ServerId, RoleId, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{role_list = RoleList, brick_num = CarrySeaBrickNum} = SeaMsg ->
                    case lists:keyfind(RoleId, #role_msg.role_id, RoleList) of
                        #role_msg{brick_num = BrickNum, sea_id = RoleSeaId, brick_color = BrickColor} = RoleMsg ->

                            %%更新玩家状态
                            RoleMsgNew = RoleMsg#role_msg{status = ?common, brick_color = 1, brick_num = 0},
                            RoleListNew = lists:keystore(RoleId, #role_msg.role_id, RoleList, RoleMsgNew),
                            NewSeaMsg = SeaMsg#sea_msg{role_list = RoleListNew},
                            NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                            %%更新海域信息
                            NewSeaList1 = change_sea_brick(NewSeaList, AddSeaId, BrickNum),
                            NewSeaBrickNum = get_sea_brick2(AddSeaId, NewSeaList1),
                            %% 更新本服的形象各种状态，添加临时技能，变为暂时属性
                            notice_local_start_carry_brick(ServerId, RoleId, 1, NewSeaBrickNum, finish_carry),   %%结束搬运且将砖块的品质设置为1
                            %%更新排行榜信息
                            NewSeaList2 = add_brick_num_to_role(AddSeaId, NewSeaList1, RoleMsg),
                            NewZoneMsg = ZoneMsg#zone_msg{sea_list = NewSeaList2},
                            ZoneListNew = lists:keystore(ZoneId,
                                #zone_msg.zone_id, ZoneList, NewZoneMsg),
                            StateNew = State#sea_craft_daily_state{zone_list = ZoneListNew},
                            %% log
                            RoleSeaBrickNum = get_sea_brick2(RoleSeaId, SeaList),
                            %% 同步砖块数量
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_seacraft_local, update_brick_num, [AddSeaId, NewSeaBrickNum]),
                            lib_log_api:log_sea_craft_daily_carry_brick(RoleId, RoleSeaId, SeaId, RoleSeaBrickNum, CarrySeaBrickNum, BrickNum, BrickColor, 3, []),
                            StateNew;
                        _ ->
                            ?ERR("error not have role ~p~n", [RoleId]),
                            State
                    end;
                _ ->
                    ?ERR("error seaId ~p~n", [SeaId]),
                    State
            end;
        _ ->
            ?ERR("error zoneId ~p  ZoneList ~p~n", [ZoneId, ZoneList]),
            State
    end.


%%通知本地开始搬砖了
notice_local_start_carry_brick(ServerId, RoleId, BrickColor, SeaBrickNum, Type) ->
    mod_clusters_center:apply_cast(ServerId, lib_seacraft_daily, notice_local_start_carry_brick, [RoleId, BrickColor, SeaBrickNum, Type]).


change_sea_brick(SeaList, AddSeaId, BrickNum) ->
    case lists:keyfind(AddSeaId, #sea_msg.sea_id, SeaList) of
        #sea_msg{brick_num = OldNum} = OldSeaMsg ->
            SeaMsg = OldSeaMsg#sea_msg{brick_num = max(0, OldNum + BrickNum)},
            %% 广播场景信息 03 01
            broadcast_to_copy(SeaMsg),
            lib_kf_seacraft_daily:save_sea_msg_only_to_db(SeaMsg),
            SeaListNew = lists:keystore(AddSeaId, #sea_msg.sea_id, SeaList, SeaMsg),
            SeaListNew;
        _ ->
            SeaList
    end.

add_brick_num_to_role(SeaId, SeaList, RoleMsg) ->
    #role_msg{
        role_id = RoleId,
        role_name = RoleName,
        server_id = ServerId,
        server_num = ServerNum
        , job_id = JobId
        , brick_num = BrickNum
        , power = Power
    } = RoleMsg,
    case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
        #sea_msg{rank_list = RankList} = SeaMg ->
            case lists:keyfind(RoleId, #role_msg.role_id, RankList) of
                #role_rank{brick_num = OldNum} = OldRank ->
                    NewRoleRank = OldRank#role_rank{brick_num = OldNum + BrickNum, power = Power, pos = JobId},
                    lib_kf_seacraft_daily:save_role_single_to_db(NewRoleRank, SeaId),
                    RankListNew = lists:keystore(RoleId, #role_rank.role_id, RankList, NewRoleRank),
                    SeaMgNew = SeaMg#sea_msg{rank_list = RankListNew},
                    lists:keystore(SeaId, #sea_msg.sea_id, SeaList, SeaMgNew);
                _ ->
                    NewRoleRank = #role_rank{
                        server_id = ServerId,
                        server_num = ServerNum,
                        role_id = RoleId,
                        role_name = RoleName,
                        power = Power,
                        pos = JobId,
                        brick_num = BrickNum,
                        rank = 0
                        , sea_id = SeaId
                    },
                    lib_kf_seacraft_daily:save_role_single_to_db(NewRoleRank, SeaId),
                    RankListNew = lists:keystore(RoleId, #role_rank.role_id, RankList, NewRoleRank),
                    SeaMgNew = SeaMg#sea_msg{rank_list = RankListNew},
                    lists:keystore(SeaId, #sea_msg.sea_id, SeaList, SeaMgNew)
            end;
        _ ->
            SeaList
    end.


handle_reset_brick_num(State) ->
    {_, {H, _, _}} = utime:localtime(),
    #sea_craft_daily_state{ref = OldRef} = State,
    Ref = calc_ref(OldRef),
    BrickNum = data_sea_craft_daily:get_kv(default_brick),
    if
        H == 12 ->
            #sea_craft_daily_state{zone_list = ZoneList} = State,
            F = fun(#zone_msg{sea_list = SeaList} = ZoneMsg, AccZoneList) ->
                FF = fun(Sea, AccSealList) ->
                    NewSea = Sea#sea_msg{brick_num = BrickNum},
                    lib_kf_seacraft_daily:save_sea_msg_only_to_db(NewSea),
                    [NewSea | AccSealList]
                     end,
                NewSeaList = lists:foldl(FF, [], SeaList),
                ZoneMsgNew = ZoneMsg#zone_msg{sea_list = NewSeaList},
                [ZoneMsgNew | AccZoneList]
                end,
            ZoneListNew = lists:foldl(F, [], ZoneList),
            State#sea_craft_daily_state{zone_list = ZoneListNew, ref = Ref};
        true ->
            State#sea_craft_daily_state{ref = Ref}
    end.


%%抢夺其他海域的砖块数量
get_other_sea_brick_num(OldBrickNum, BrickColor) ->
    case data_sea_craft_daily:get_brick(BrickColor) of
        #brick_cfg{snatch_ratio = SnatchList} ->
            BuildingLv =  data_sea_craft_daily:get_building_lv(OldBrickNum),
            case lists:keyfind(BuildingLv, 1, SnatchList) of
                {_, Num} ->
                    min(Num, OldBrickNum);
                _ ->
                    0
            end;
        _ ->
            0
    end.


get_exp_attr(ZoneId,  ServerId, RoleId, SeaId, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{brick_num = BrickNum} ->
                    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
                        [RoleId, ?APPLY_CALL_SAVE, lib_seacraft_daily, get_exp_attr2, [BrickNum]]);
                _ ->
                    skip

            end;
        _ ->
            State
    end.


day_trigger(State) ->
    %% 通知每个服清理日常
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    F = fun(ZoneMsg, AccZoneList) ->
            #zone_msg{sea_list = SeaList} = ZoneMsg,
            FF = fun(SeaMsg, {AccSeaList, AccRanList}) ->
                    #sea_msg{rank_list = RankList} = SeaMsg,
                    spawn(fun() -> send_rank_reward(RankList) end),
                    SeaMsgNew = SeaMsg#sea_msg{rank_list = []},
                    {[SeaMsgNew | AccSeaList], RankList ++ AccRanList}
                end,
            {NewSeaList, AllRankList} = lists:foldl(FF, {[], []}, SeaList),
        spawn(fun() -> send_all_rank_reward(AllRankList) end),
        ZoneMsgNew = ZoneMsg#zone_msg{sea_list = NewSeaList},
        [ZoneMsgNew | AccZoneList]
        end,
    NewZoneList = lists:foldl(F, [], ZoneList),
    %% 删除数据库
    Sql = io_lib:format(<<"truncate    sea_craft_daily_rank ">>, []),
    db:execute(Sql),
    State#sea_craft_daily_state{zone_list = NewZoneList}.


%% 单海域排行榜
send_rank_reward(RankList) ->
    SortList = sort_rank(RankList),
    [begin
         #role_rank{rank = Rank, server_id = ServerId, role_id = RoleId, server_num = ServerNum, brick_num = Num, sea_id = SeaId} = Role,
         case data_sea_craft_daily:get_single_rank_reward(Rank) of
             [] ->
                 skip;
             Reward ->
                 timer:sleep(100),
                 Title = utext:get(1870001),
                 Content = utext:get(1870002, [Rank]),
                 lib_log_api:log_sea_craft_daily_rank_settle(1, SeaId,  RoleId, ServerId, ServerNum, Num, Rank, Reward),
                 mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail,
                     [[RoleId], Title, Content, Reward])
         end
     end ||Role <-SortList].

%% 全海域排行榜
send_all_rank_reward(RankList) ->
    SortList = sort_rank(RankList),
    [begin
         #role_rank{rank = Rank, server_id = ServerId, role_id = RoleId, server_num = ServerNum, brick_num = Num, sea_id = SeaId} = Role,
         case data_sea_craft_daily:get_all_sea_rank_reward(Rank) of
             [] ->
                 skip;
             Reward ->
                 timer:sleep(100),
                 Title = utext:get(1870001),
                 Content = utext:get(1870003, [Rank]),
                 lib_log_api:log_sea_craft_daily_rank_settle(2, SeaId, RoleId, ServerId, ServerNum, Num, Rank, Reward),
                 mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail,
                     [[RoleId], Title, Content, Reward])
         end
     end ||Role <-SortList].



%% 打包boss信息
get_boss_pack_list(BossIdList) ->
    F = fun({Id, Time}, AccList) ->
            case data_mon:get(Id) of
                #mon{lv = Lv, name = Name} ->
                    [{Id, Lv, Name, Time} | AccList];
                _ ->
                    AccList
            end
        end,
    lists:foldl(F, [], BossIdList).

hurt_mon(Minfo, Atter, ZoneId, State) ->
    #scene_object{scene = _Scene, scene_pool_id = _Pool, copy_id = SeaId, config_id = MonCfgId} = Minfo,
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    #battle_return_atter{camp_id = KillSeaId, server_num = KillServerNum, real_name = KillName} = Atter,
%%    ?MYLOG("cym", "KillName ~p~n", [KillName]),
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{statue_cd = StatueCd, guard_cd = GuardCd} = SeaMsg ->
                    Now = utime:unixtime(),
                    CfgCd = data_sea_craft_daily:get_kv(boss_tv),
                    case  data_mon:get(MonCfgId) of
                        #mon{boss = ?MON_SYS_BOSS_TYPE_SEA_STATUE} -> %% 雕像
                            if
                                Now > StatueCd -> %% cd好 了
                                    %% 发送tv
                                    send_mon_be_hurt_tv(statue, KillSeaId, KillServerNum, KillName, SeaId, ZoneId),
                                    %% 组装信息回去
                                    NewSeaMsg = SeaMsg#sea_msg{statue_cd = Now + CfgCd},
                                    SeaListNew = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                                    ZoneMsgNew = ZoneMsg#zone_msg{sea_list = SeaListNew},
                                    ZoneListNew = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, ZoneMsgNew),
                                    State#sea_craft_daily_state{zone_list = ZoneListNew};
                                true ->
                                    State
                            end;
                        #mon{boss = ?MON_SYS_BOSS_TYPE_SEA_GUARD} -> %%守卫
                            if
                                Now > GuardCd -> %% cd好 了
                                    %% 发送tv
                                    send_mon_be_hurt_tv(guard, KillSeaId, KillServerNum, KillName, SeaId, ZoneId),
                                    %% 组装信息回去
                                    NewSeaMsg = SeaMsg#sea_msg{guard_cd = Now + CfgCd},
                                    SeaListNew = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                                    ZoneMsgNew = ZoneMsg#zone_msg{sea_list = SeaListNew},
                                    ZoneListNew = lists:keystore(ZoneId, #zone_msg.zone_id, ZoneList, ZoneMsgNew),
                                    State#sea_craft_daily_state{zone_list = ZoneListNew};
                                true ->
                                    State
                            end;
                        _ ->
                            State
                    end;
                _ ->
                    State
            end;
        _ ->
            State
    end.



%%发送搬运传闻  {camp, Camp}
send_carry_brick_tv(RoleMsg, SeaId) ->
    #role_msg{role_name = RoleName, sea_id = RoleSeaId, zone_id = ZoneId} = RoleMsg,
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    SeaName = lib_seacraft_daily:get_sea_name(RoleSeaId),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
        [{camp, SeaId}, ?MOD_SEACRAFT_DAILY, 1, [util:make_sure_binary(SeaName), util:make_sure_binary(RoleName), SeaId]]) ||
    #zone_base{server_id = ServerId}<- ServerList].


send_mon_be_hurt_tv(statue, KillSeaId, KillServerNum, KillName, SeaId, ZoneId) ->
%%        ?PRINT("send_carry_brick_tv +++++++++++ ~n", [] ),
    KillSeaName = lib_seacraft_daily:get_sea_name(KillSeaId),
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
        [{camp, SeaId}, ?MOD_SEACRAFT_DAILY, 3, [util:make_sure_binary(KillSeaName), KillServerNum, util:make_sure_binary(KillName), SeaId]]) || #zone_base{server_id = ServerId}<- ServerList ];

send_mon_be_hurt_tv(guard, KillSeaId, KillServerNum, KillName, SeaId, ZoneId) ->
%%        ?PRINT("send_carry_brick_tv +++++++++++ ~n", [] ),
    KillSeaName = lib_seacraft_daily:get_sea_name(KillSeaId),
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
        [{camp, SeaId}, ?MOD_SEACRAFT_DAILY, 4, [util:make_sure_binary(KillSeaName), KillServerNum, util:make_sure_binary(KillName), SeaId]]) || #zone_base{server_id = ServerId}<- ServerList ];

send_mon_be_hurt_tv(_, _, _, _, _, _) ->
    ok.

send_mon_be_kill_tv(statue, KillSeaId, _KillServerNum, KillName, SeaId, ZoneId) ->
%%        ?PRINT("send_carry_brick_tv +++++++++++ ~n", [] ),
    KillSeaName = lib_seacraft_daily:get_sea_name(KillSeaId),
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
        [{camp, SeaId}, ?MOD_SEACRAFT_DAILY, 5, [util:make_sure_binary(KillSeaName), util:make_sure_binary(KillName), SeaId]]) || #zone_base{server_id = ServerId} <- ServerList];

send_mon_be_kill_tv(guard, KillSeaId, _KillServerNum, KillName, SeaId, ZoneId) ->
%%        ?PRINT("send_carry_brick_tv +++++++++++ ~n", [] ),
    KillSeaName = lib_seacraft_daily:get_sea_name(KillSeaId),
    ServerList = mod_zone_mgr:get_zone_server(ZoneId),
    [mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV,
        [{camp, SeaId}, ?MOD_SEACRAFT_DAILY, 6, [util:make_sure_binary(KillSeaName), util:make_sure_binary(KillName), SeaId]]) || #zone_base{server_id = ServerId} <- ServerList];

send_mon_be_kill_tv(_, _, _, _, _, _) ->
    ok.


get_boss_reborn_ref(?MON_SYS_BOSS_TYPE_SEA_STATUE, OldRef, ZoneId, SeaId) ->
    Time = data_sea_craft_daily:get_kv(statue_reborn_time),
    Ref = util:send_after(OldRef, Time * 1000, self(), {?MON_SYS_BOSS_TYPE_SEA_STATUE, ZoneId, SeaId}),
    {Ref, utime:unixtime() + Time};


get_boss_reborn_ref(?MON_SYS_BOSS_TYPE_SEA_GUARD, OldRef, ZoneId, SeaId) ->
    Time = data_sea_craft_daily:get_kv(guard_reborn_time),
    Ref = util:send_after(OldRef, Time * 1000, self(), {?MON_SYS_BOSS_TYPE_SEA_GUARD, ZoneId, SeaId}),
    {Ref, utime:unixtime() + Time};

get_boss_reborn_ref(_, _OldRef, _ZoneId, _SeaId) ->
    {[], 0}.



%% 广播 03 和 01
broadcast_to_copy(SeaMsg) ->
%%    ?MYLOG("cym", "broadcast_to_copy ~p ~n", [SeaMsg]),
    #sea_msg{role_list = RoleList} = SeaMsg,
    [ mod_clusters_center:apply_cast(ServerId, lib_seacraft_daily, broadcast_to_copy, [RoleId, SeaId])
        ||#role_msg{server_id = ServerId, role_id = RoleId, sea_id = SeaId} <- RoleList].



zone_change(_ServerId, OldZone, NewZone, State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    [begin
         Sql1 = io_lib:format(<<"DELETE  from  sea_craft_daily where   zone_id = ~p">>, [OldZone]),
         Sql2 = io_lib:format(<<"DELETE  from  sea_craft_daily where   zone_id = ~p">>, [NewZone]),
         db:execute(Sql1),
         db:execute(Sql2),
         [ [ begin
                 Sql3 = io_lib:format(<<"DELETE  from  sea_craft_daily_rank where   role_id = ~p">>, [RoleId]),
                 db:execute(Sql3)
             end
             ||#role_rank{role_id = RoleId} <-RoleList] || #sea_msg{rank_list = RoleList}  <-SeaList]
     end ||  #zone_msg{zone_id = ZoneId, sea_list = SeaList}<-ZoneList, ZoneId == OldZone orelse ZoneId == NewZone ],
    %%  定时器全部取消
    F = fun(#zone_msg{zone_id = ZoneFunId, sea_list = SealListFun} = ZoneFun, AccList) ->
        if
            ZoneFunId == OldZone orelse  ZoneFunId == NewZone ->
                SealListFunNew = [FunSea#sea_msg{brick_num = data_sea_craft_daily:get_kv(default_brick), role_list = [], rank_list = []}
                    || FunSea<-SealListFun],
                [ZoneFun#zone_msg{sea_list = SealListFunNew} | AccList];
            true ->
                [ZoneFun | AccList]
        end
        end,
    ZoneListNew = lists:foldl(F, [], ZoneList),
    ZoneLvList = calc_lv(),
    case lists:keymember(NewZone, #zone_msg.zone_id, ZoneList) of
        true ->
            ZoneListLast = ZoneListNew;
        _ ->
            F2 = fun(SeaId, AccList) ->
                BrickNum = get_sea_brick(NewZone, SeaId),
                %%初始化话场景里的怪物  ZoneId 为场景进程id  SeaId 为房间id
                StatueId = create_mon(statue, NewZone, SeaId, ZoneLvList, []),
                GuardId = create_mon(guard, NewZone, SeaId, ZoneLvList, []),
                SeaMsg = #sea_msg{zone_id = NewZone, sea_id = SeaId, brick_num = BrickNum,
                    statue_status = ?live, guard_status = ?live,
                    statue_id = StatueId, guard_id = GuardId},
                [SeaMsg | AccList]
                 end,
            SeaListIds = data_seacraft:get_all_camp(),
            SeaList = lists:foldl(F2, [], SeaListIds),
            ZoneMsg = #zone_msg{sea_list = SeaList, zone_id = NewZone},
            ZoneListLast =  [ZoneMsg | ZoneListNew]
            
    end,
    NewState = State#sea_craft_daily_state{zone_list = ZoneListLast},
    NewState.
    
    


gm_add_sea_brick(ServerId, SeaId, Num, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
        #zone_msg{sea_list = SeaList} = ZoneMsg ->
            case lists:keyfind(SeaId, #sea_msg.sea_id, SeaList) of
                #sea_msg{} = SeaMsg ->
                    %%更新玩家状态
                    NewSeaMsg = SeaMsg#sea_msg{brick_num = Num},
                    lib_kf_seacraft_daily:save_sea_msg_only_to_db(NewSeaMsg),
                    NewSeaList = lists:keystore(SeaId, #sea_msg.sea_id, SeaList, NewSeaMsg),
                    NewZoneMsg = ZoneMsg#zone_msg{sea_list = NewSeaList},
                    ZoneListNew = lists:keystore(ZoneId,
                        #zone_msg.zone_id, ZoneList, NewZoneMsg),
                    mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, mod_seacraft_local, update_brick_num, [SeaId, Num]),
                    StateNew = State#sea_craft_daily_state{zone_list = ZoneListNew},
                    StateNew;
                _ ->
                    ?ERR("error seaId ~p~n", [SeaId]),
                    State
            end;
        _ ->
            ?ERR("error zoneId ~p  ZoneList ~p~n", [ZoneId, ZoneList]),
            State
    end.


zone_reset_start(State) ->
    #sea_craft_daily_state{zone_list = ZoneList} = State,
    F = fun(#zone_msg{sea_list = SeaList} = ZoneMsg, ZoneAccList) ->
            FF = fun(#sea_msg{role_list = RoleList, brick_num = OldBrickNum} = SeaMsg, AccSeaList) ->
                    AddNum = kick_role(RoleList),
                    NewSeaMsg = SeaMsg#sea_msg{role_list = [], brick_num = OldBrickNum + AddNum},
                    lib_kf_seacraft_daily:save_sea_msg_only_to_db(NewSeaMsg),
                    [NewSeaMsg | AccSeaList]
                end,
            NewSeaList = lists:foldl(FF, [], SeaList),
            NewZoneMsg = ZoneMsg#zone_msg{sea_list = NewSeaList},
            [NewZoneMsg | ZoneAccList]
        end,
    NewZoneList = lists:foldl(F, [], ZoneList),
    State#sea_craft_daily_state{zone_list = NewZoneList, status = ?zone_recalc}.



%% 提返回搬运数量
kick_role(RoleList) ->
    F = fun(#role_msg{brick_num = BrickNum, status = Status, server_id = ServerId, role_id = RoleId, brick_color = BrickColor}, Num) ->
        mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene,
            [RoleId, 0, 0, 0, false, [{action_free, ?ERRCODE(err187_in_scene)}, {camp, 0}, {group, 0}, {del_hp_each_time,[]}, {change_scene_hp_lim, 100}]]),
        if
            Status == ?carrying ->
                notice_local_start_carry_brick(ServerId, RoleId, BrickColor, 0, end_carry),
                Num + BrickNum;
            true ->
                Num
        end
        end,
    lists:foldl(F, 0, RoleList).





end_recalc_all_zone(State) ->
    %% 初始化
    #sea_craft_daily_state{zone_list = OldZoneList } =State,
%%    ?MYLOG("cym", "State  ~p~n", [State]),
    ZoneLvList = calc_lv(),
%%    ZoneLvList = [ {3, 100} | _ZoneLvList],
%%    ?MYLOG("cym", "ZoneLvList  ~p~n", [ZoneLvList]),
    F = fun({ZoneId, _Lv}, ZoneList) ->
        case lists:keymember(ZoneId, #zone_msg.zone_id, ZoneList) of
            true ->
                ZoneList;
            _ ->
                F2 = fun(SeaId, AccList) ->
                    BrickNum = get_sea_brick(ZoneId, SeaId),
                    %%初始化话场景里的怪物  ZoneId 为场景进程id  SeaId 为房间id
                    StatueId = create_mon(statue, ZoneId, SeaId, ZoneLvList, []),
                    GuardId = create_mon(guard, ZoneId, SeaId, ZoneLvList, []),
                    SeaMsg = #sea_msg{zone_id = ZoneId, sea_id = SeaId, brick_num = BrickNum,
                        statue_status = ?live, guard_status = ?live,
                        statue_id = StatueId, guard_id = GuardId},
                    [SeaMsg | AccList]
                     end,
                SeaListIds = data_seacraft:get_all_camp(),
                SeaList = lists:foldl(F2, [], SeaListIds),
                ZoneMsg = #zone_msg{sea_list = SeaList, zone_id = ZoneId},
                [ZoneMsg | ZoneList]
        end
        end,
    ZoneMsgList = lists:foldl(F, OldZoneList, ZoneLvList),
%%    ?MYLOG("cym", "ZoneMsgList  ~p~n", [ZoneMsgList]),
    StateNew = #sea_craft_daily_state{zone_list = ZoneMsgList, status = 0},
%%    ?MYLOG("cym", "State  ~p~n", [StateNew]),
    StateNew.












