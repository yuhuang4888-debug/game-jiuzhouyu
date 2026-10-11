%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :玩家pk记录
%%%-------------------------------------------------------------------

-module(lib_pk_log).

-include("pk_log.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("scene.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("battle.hrl").
-include("common.hrl").

% login(RoleId) ->

-export([
        login/2,
        relogin/1,
        handle_event/2,
        update_pk_log_map/3,
        update_pk_status/2,
        update_pk_status_midnight/1
        , day_clear/0
        ,kf_pk_log_map/8
        ,get_be_kill_log/1
    ]).

login(_RoleId, _LoginTime) -> %% 策划说只需要保存本次登陆的pk记录
    % List = db_select(RoleId),
    % NowTime = utime:unixtime(),
    % BeforeOneMounth = NowTime - 30*86400,
    % Fun = fun([_RoleId, SceneId, ServerId, ServerNum, AtterName, AtterId, Time, Sign], Map) ->
    %     case Time >= BeforeOneMounth of
    %         true ->
    %             case maps:get(RoleId, Map, []) of
    %                 #pk_log{} = OldPkLog -> skip;
    %                 _ ->
    %                     OldPkLog = #pk_log{role_id = RoleId, kill_log = [], kf_kill_log = []}
    %             end,
    %             #pk_log{kill_log = KillLog, kf_kill_log = KfKillLog} = OldPkLog,
    %             if
    %                 ServerId == 0 orelse ServerNum == 0 ->
    %                     Val = {SceneId, Sign, Time, AtterName, AtterId},
    %                     PkLog = OldPkLog#pk_log{kill_log = [Val|KillLog]};
    %                 true ->
    %                     Val = {SceneId, Sign, Time, ServerId, ServerNum, AtterName, AtterId},
    %                     PkLog = OldPkLog#pk_log{kf_kill_log = [Val|KfKillLog]}
    %             end,
    %             maps:put(RoleId, PkLog, Map);
    %         _ ->
    %             Map
    %     end
    % end,
    % PKlogMap = lists:foldl(Fun, #{}, List),
    % #pk_status{pk_log_map = PKlogMap}.
    #pk_status{pk_log_map = #{}}.

relogin(PS) ->
    PS.

get_be_kill_log(#player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, pk_status= #pk_status{pk_log_map = PkMap}}) ->
    case maps:get(RoleId, PkMap, []) of
        #pk_log{kill_log = KillLog, kf_kill_log = KfKillLog} ->
            Fun = fun
                ({SceneId, Sign, Time, AtterName, AtterId}, Acc) when Sign == ?PK_BE_KILL ->
                    [{SceneId, Sign, Time, ServerId, ServerNum, AtterName, AtterId}|Acc];
                ({_, Sign, _, _, _, _, _} = Val, Acc) when Sign == ?PK_BE_KILL ->
                    [Val|Acc];
                (_, Acc) -> Acc
            end,
            SendKillLog = lists:foldl(Fun, [], KillLog),
            SendKfKillLog = lists:foldl(Fun, [], KfKillLog),
            SendKillLog++SendKfKillLog;
        _ ->
            []
    end.


kf_pk_log_map(AtterId, SceneId, SceneName, NowTime, DServerId, DServerNum, DieName, DieId) ->
    KfKillInfo = [{SceneId, ?PK_KILL, NowTime, DServerId, DServerNum, DieName, DieId}],
    lib_server_send:send_to_uid(AtterId, pt_619, 61902, [?PK_KILL, NowTime, SceneName, DServerId, DServerNum, DieName, DieId]),
    lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_pk_log, update_pk_status, [KfKillInfo]).


%% KillInfo:[{SceneId, sign, time, anmyname}](某次pk信息) sign:0击杀，1被杀
update_pk_log_map(PKlogMap, RoleId, [{_SceneId, _Sign, _Time, _AtterName, _AtterId}] = KillInfo) ->
    case maps:get(RoleId, PKlogMap, []) of
        #pk_log{kill_log = KillLog} = Tem ->
            Pk = Tem#pk_log{kill_log = KillInfo ++ KillLog};
        [] ->
            Pk = #pk_log{role_id = RoleId, kill_log = KillInfo}
    end,
    % 策划说只需要保存本次登陆的pk记录 role_id, scene_id, server_id, server_num, attr_name, attr_id, stime, sign
    % db_insert(RoleId, SceneId, 0, 0, AtterName, AtterId, Time, Sign),
    maps:put(RoleId, Pk, PKlogMap);
update_pk_log_map(PKlogMap, RoleId, [{_SceneId, _Sign, _Time, _ServerId, _ServerNum, _AtterName, _AtterId}] = KillInfo) ->
    case maps:get(RoleId, PKlogMap, []) of
        #pk_log{kf_kill_log = KillLog} = Tem ->
            Pk = Tem#pk_log{kf_kill_log = KillInfo ++ KillLog};
        [] ->
            Pk = #pk_log{role_id = RoleId, kf_kill_log = KillInfo}
    end,
    % db_insert(RoleId, SceneId, ServerId, ServerNum, AtterName, AtterId, Time, Sign),
    maps:put(RoleId, Pk, PKlogMap).

%% 凌晨清理内存
update_pk_status_midnight(#player_status{id = RoleId, pk_status= #pk_status{pk_log_map = PkMap}} = AttrPs) ->
    NowTime = utime:unixtime(),
    % BeforeOneMounth = NowTime - 30*86400,
    BeforeOneMounth = NowTime,
    case maps:get(RoleId, PkMap, []) of
        #pk_log{kill_log = KillLog, kf_kill_log = KfKillLog} = OldPkLog ->
            Fun = fun
                ({_, _, Time, _, _} = Val, Acc) when Time >= BeforeOneMounth ->
                    [Val|Acc];
                ({_, _, Time, _, _, _, _} = Val, Acc) when Time >= BeforeOneMounth ->
                    [Val|Acc];
                (_, Acc) -> Acc
            end,
            NewKillLog = lists:foldl(Fun, [], KillLog),
            NewKfKillLog = lists:foldl(Fun, [], KfKillLog),
            PkLog = OldPkLog#pk_log{kill_log = NewKillLog, kf_kill_log = NewKfKillLog},
            NewPkMap = maps:put(RoleId, PkLog, PkMap);
        _ ->
            OldPkLog = #pk_log{role_id = RoleId, kill_log = [], kf_kill_log = []},
            NewPkMap = maps:put(RoleId, OldPkLog, PkMap)
    end,
    {ok, AttrPs#player_status{pk_status= #pk_status{pk_log_map = NewPkMap}}}.

%% 更新内存数据
update_pk_status(AttrPs, KillInfo) ->
    #player_status{id = RoleId, pk_status = #pk_status{pk_log_map = PkMap}} = AttrPs,
    NewPkMap = update_pk_log_map(PkMap, RoleId, KillInfo),
    {ok, AttrPs#player_status{pk_status= #pk_status{pk_log_map = NewPkMap}}}.

%% 处理死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{
                    server_id = DServerId,
                    server_num = DServerNum,
                    id = DieId,
                    scene = SceneId,
                    pk_status = #pk_status{pk_log_map = PkMap},
                    figure = #figure{name = DieName}} = Player,
    InBoss = is_in_pk_scene(SceneId),
    InkfScene = is_in_kf_pk_scene(SceneId),
    NowTime = utime:unixtime(),
    #{attersign := AtterSign, atter := Atter, hit := _HitList} = Data,
    #battle_return_atter{
            real_id = AtterId,
            real_name = AtterName,
            server_id = KServerId,
            server_num = KServerNum,
            mask_id = MaskId} = Atter,
    SceneName = lib_scene:get_scene_name(SceneId),
    SceneType = case data_scene:get(SceneId) of
                    #ets_scene{type = SType} -> SType;
                    _ -> 0
                end,
    NeedWrapName = lib_player:is_need_wrap_name_scene(SceneId),
    NewDieName = case NeedWrapName of true -> lib_player:get_wrap_role_name(Player); _ -> DieName end,
    NewAtterName = case NeedWrapName of true -> lib_player:get_wrap_role_name(AtterName, [MaskId]); _ -> AtterName end,
    % 被玩家打死有效
    case AtterSign == ?BATTLE_SIGN_PLAYER of
        true ->
            lib_log_api:log_pk(DServerId, DieId, DieName, KServerId, AtterId, AtterName, ?PK_BE_KILL, SceneId, SceneType),
            case lists:member(KServerId, config:get_merge_server_ids()) of
                true -> lib_log_api:log_pk(KServerId, AtterId, AtterName, DServerId, DieId, DieName, ?PK_KILL, SceneId, SceneType);
                false ->
                    mod_clusters_node:apply_cast(mod_clusters_center, apply_cast,
                            [KServerId, lib_log_api, log_pk, [KServerId, AtterId, AtterName, DServerId, DieId, DieName, ?PK_KILL, SceneId, SceneType]])
                    % mod_clusters_center:apply_cast(KServerId, lib_log_api, log_pk, [KServerId, AtterId, AtterName, DServerId, DieId, DieName, ?PK_KILL, SceneId])
            end,
            if
                InBoss ->
                    lib_server_send:send_to_uid(AtterId, pt_619, 61901, [?PK_KILL, NowTime, SceneName, NewDieName, DieId]),
                    lib_player:apply_cast(AtterId, ?APPLY_CAST_SAVE, lib_pk_log, update_pk_status,
                            [[{SceneId, ?PK_KILL, NowTime, NewDieName, DieId}]]),
                    lib_server_send:send_to_uid(DieId, pt_619, 61901,
                            [?PK_BE_KILL, NowTime, SceneName, NewAtterName, AtterId]),
                    NewPKmap = update_pk_log_map(PkMap, DieId, [{SceneId, ?PK_BE_KILL, NowTime, NewAtterName, AtterId}]);
                InkfScene ->
                    mod_online_statistics:cast_center([{'player_die', KServerId,AtterId,SceneId,SceneName,NowTime,DServerId,DServerNum,NewDieName,DieId}]),
                    lib_server_send:send_to_uid(DieId, pt_619, 61902,
                            [?PK_BE_KILL, NowTime, SceneName, KServerId, KServerNum, NewAtterName, AtterId]),
                    NewPKmap = update_pk_log_map(PkMap, DieId,
                            [{SceneId, ?PK_BE_KILL, NowTime, KServerId, KServerNum, NewAtterName, AtterId}]);
                true ->
                    NewPKmap = PkMap
            end;
        false ->
            NewPKmap = PkMap
    end,
    {ok, Player#player_status{pk_status= #pk_status{pk_log_map = NewPKmap}}};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 没有被调用
day_clear() -> %ok. %% 策划说只需要保存本次登陆的pk记录
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [daily_clear_helper(E#ets_online.id) || E <- OnlineRoles].

daily_clear_helper(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_pk_log, update_pk_status_midnight, []).
    % NowTime = utime:unixtime(),
    % BeforeOneMounth = NowTime - 30*86400,
    % spawn(fun() ->
    %     timer:sleep(urand:rand(10,200)),
    %     Sql = io_lib:format("DELETE FROM `player_pk_log` WHERE `stime` < ~p", [BeforeOneMounth]),
    %     db:execute(Sql)
    % end).

% db_select(RoleId) ->
%     Sql = io_lib:format(?sql_pk_log_select_1, [RoleId]),
%     db:get_all(Sql).

% %% 策划说只需要保存本次登陆的pk记录
% db_insert(RoleId, SceneId, ServerId, ServerNum, AtterName, AtterId, Time, Sign) ->
%     NewName = util:make_sure_binary(AtterName),
%     Sql = io_lib:format(?sql_pk_log_insert, [RoleId, SceneId, ServerId, ServerNum, NewName, AtterId, Time, Sign]),
%     db:execute(Sql).

%% 判断是不是在需要记录pk的场景类型
is_in_pk_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
                SceneType == ?SCENE_TYPE_WORLD_BOSS orelse
                SceneType == ?SCENE_TYPE_TEMPLE_BOSS orelse
                SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS orelse
                SceneType == ?SCENE_TYPE_SUIT_BOSS orelse
                SceneType == ?SCENE_TYPE_HOME_BOSS orelse
                SceneType == ?SCENE_TYPE_FAIRYLAND_BOSS orelse
                SceneType == ?SCENE_TYPE_OUTSIDE_BOSS orelse
                SceneType == ?SCENE_TYPE_ABYSS_BOSS orelse
                SceneType == ?SCENE_TYPE_FEAST_BOSS orelse
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS orelse
                SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS orelse
                SceneType == ?SCENE_TYPE_SPECIAL_BOSS orelse
                SceneType == ?SCENE_TYPE_SANCTUARY orelse
                SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER orelse
                SceneType == ?SCENE_TYPE_WORLD_BOSS_PER
                ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.

is_in_kf_pk_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = SceneType} ->
            if
                SceneType == ?SCENE_TYPE_EUDEMONS_BOSS orelse
                SceneType == ?SCENE_TYPE_KF_SANCTUARY orelse
                SceneType == ?SCENE_TYPE_SANCTUM ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.
