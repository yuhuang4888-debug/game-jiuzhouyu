%%-----------------------------------------------------------------------------
%% @Module  :       lib_team_match.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-09
%% @Description:    组队匹配
%%-----------------------------------------------------------------------------

-module (lib_team_match).
-include ("team.hrl").
-include ("common.hrl").
-include("task.hrl").
-include("def_module.hrl").
-include("team_enlist.hrl").
-include("def_fun.hrl").
-include("beings_gate.hrl").

-export([
    get_match_mod/2
    , try_match_fake_mb/1
    , get_fake_join_in_time/3
    , get_fake_agree_gap/3
    , check_available_team/6
    , get_team_dun_id/3
    , get_team_auto_type/2
    , get_special_api_mod/4
    , filter_zone_mod_team/5
    , get_enlist_team_dun_id/3
]).

get_match_mod(_ActivityId, _SubTypeId) -> undefined.

%% -----------------------------------------------------------------
%% @desc  根据活动类型执行特殊api
%% @param
%% @return
%% -----------------------------------------------------------------
get_special_api_mod(ActivityId, _SubTypeId, 0, 0) ->
    case ActivityId of
        ?ACTIVITY_ID_BEINGS_GATE -> undefined;
        _ -> undefined
    end;
get_special_api_mod(ActivityId, _SubTypeId, ApiName, ArgsNum) ->
    Mod
        = case ActivityId of
              ?ACTIVITY_ID_BEINGS_GATE -> lib_beings_gate_api;
              _ -> undefined
          end,
    if
        Mod =/= undefined -> ?IF(lists:member({ApiName, ArgsNum}, Mod:module_info(exports)), Mod, undefined);
        true -> undefined
    end.

%% -----------------------------------------------------------------
%% @desc 检测队伍是否符合匹配
%% @param
%% @return
%% -----------------------------------------------------------------
check_available_team(ModuleGroupMap, ActivityId, SubTypeId, TeamId, Mb, TeamMaps) ->
    #mb{server_id = ServerId} = Mb,
    case maps:get(TeamId, TeamMaps, false) of
        #team_enlist_info{
            num      = Num,
            matching = Matching,
            max_num  = NumMax,
            leader_id = LeaderId,
            members = Mbs
        } when Num < NumMax andalso Matching == 1 ->
            Leader = ulists:keyfind(?TEAM_LEADER, #mb.location, Mbs, #mb{}),
            filter_zone_mod_team(ModuleGroupMap, ActivityId, SubTypeId, ServerId, Leader);
        _Team -> false
    end.

%% -----------------------------------------------------------------
%% @desc 获得组队副本Id
%% @param
%% @return
%% -----------------------------------------------------------------
get_team_dun_id(?ACTIVITY_ID_BEINGS_GATE, _SubModule, _DunId) -> ?IF(util:is_cls(), urand:list_rand(?DUNGEON_CENTER), lib_beings_gate_util:get_beings_gate_dungeon_id());
get_team_dun_id(_Module, _SubModule, DunId) -> DunId.

get_enlist_team_dun_id(?ACTIVITY_ID_BEINGS_GATE, _SubModule, _DunId) -> ?IF(util:is_cls(), urand:list_rand(?DUNGEON_CENTER), urand:list_rand(?DUNGEON_LOCAL));
get_enlist_team_dun_id(_Module, _SubModule, DunId) -> DunId.

%% -----------------------------------------------------------------
%% @desc 获得是否自动开始标志
%% @param
%% @return
%% -----------------------------------------------------------------
get_team_auto_type(?ACTIVITY_ID_BEINGS_GATE, _SubModule) -> ?NO_AUTO_START;
get_team_auto_type(_Module, _SubModule) -> ?AUTO_START.

% try_match_fake_mb(#team{cls_type = ?NODE_GAME} = State) ->
%     Ref = util:send_after(State#team.fake_mb_ref, ?FAKE_JOIN_IN_TIME, self(), try_match_fake_mb),
%     {ok, State#team{fake_mb_ref = Ref}};
try_match_fake_mb(#team{} = State) ->
    #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}} = State,
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{match_fake_man = 1} ->
            JoinInTime = get_fake_join_in_time(State, ActivityId, SubTypeId),
            Ref = util:send_after(State#team.fake_mb_ref, JoinInTime, self(), try_match_fake_mb),
            {ok, State#team{fake_mb_ref = Ref}};
        _ ->
            skip
    end;

try_match_fake_mb(_) -> skip.


%% 获得假人匹配的时间(毫秒)
get_fake_join_in_time(State, Module = ?ACTIVITY_ID_EQUIP, SubModule) ->
    #team{member = Members} = State,
    {FakeMbs, RealMbs} = lists:partition(fun(Mb) -> lib_team:is_fake_mb(Mb) end, Members),
    TimeList = data_team_m:get_fake_join_in_time_list(Module),
    DefJoinTime = data_team_m:get_fake_join_in_time(Module, SubModule, length(FakeMbs)),
    F = fun({TaskId, JoinTime}, MinJoinTime) ->
        F2 = fun(#mb{task_map = TaskMap}, SecMinJoinTime) ->
            case maps:get(TaskId, TaskMap, []) of
                ?TASK_STATE_TRIGGER -> min(SecMinJoinTime, JoinTime);
                _ -> SecMinJoinTime
            end
        end,
        lists:foldl(F2, MinJoinTime, RealMbs)
    end,
    JoinTime = lists:foldl(F, DefJoinTime, TimeList),
    JoinTime;
get_fake_join_in_time(State, Module, SubModule) ->
    #team{member = Members} = State,
    FakeMbs = [Mb || Mb <- Members, lib_team:is_fake_mb(Mb)],
    data_team_m:get_fake_join_in_time(Module, SubModule, length(FakeMbs)).

get_fake_agree_gap(State, Module = ?ACTIVITY_ID_EQUIP, _SubModule) ->
    #team{member = Members} = State,
    RealMbs = [Mb||Mb<-Members, not lib_team:is_fake_mb(Mb)],
    DefGapTime = data_team_m:get_config(fake_agree_gap),
    GapList = data_team_m:get_fake_agree_gap(Module),
    F = fun({TaskId, JoinTime}, MinJoinTime) ->
        F2 = fun(#mb{task_map = TaskMap}, SecMinJoinTime) ->
            case maps:get(TaskId, TaskMap, []) of
                ?TASK_STATE_TRIGGER -> min(SecMinJoinTime, JoinTime);
                _ -> SecMinJoinTime
            end
             end,
        lists:foldl(F2, MinJoinTime, RealMbs)
        end,
    GapTime = lists:foldl(F, DefGapTime, GapList),
    GapTime;
get_fake_agree_gap(_, _, _) -> data_team_m:get_config(fake_agree_gap).


%% 过滤不符合的分服248模式的队伍
filter_zone_mod_team(ModuleGroupMap, ActivityId, SubTypeId, ServerId, Leader) ->
    #mb{server_id = LeaderSerId} = Leader,
    Module = lib_team:get_module(ActivityId, SubTypeId),
    IsZoneMod = lib_team:is_zone_mod(ActivityId, SubTypeId),
    if
        Module == 0 -> true;
        ServerId == LeaderSerId -> true;
        IsZoneMod ->
            Zone = lib_clusters_center_api:get_zone(ServerId),
            LeaderZone = lib_clusters_center_api:get_zone(LeaderSerId),
            case Zone =/= LeaderZone of
                true -> false;
                _ ->
                    ZoneGroupMap = maps:get(Module, ModuleGroupMap, #{}),
                    ServerModMap = maps:get(Zone, ZoneGroupMap, #{}),
                    maps:get(ServerId, ServerModMap, 1) == maps:get(LeaderSerId, ServerModMap, 2)
            end;
        true ->
            true
    end.