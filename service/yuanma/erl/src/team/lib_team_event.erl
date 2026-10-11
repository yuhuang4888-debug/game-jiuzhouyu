%% ---------------------------------------------------------------------------
%% @doc lib_team_event
%% @author hejiahua@163.com
%% @since  2020-07-16
%% @deprecated  队伍event
%% ---------------------------------------------------------------------------
-module(lib_team_event).

-include("team.hrl").
-include("errcode.hrl").
-include("def_module.hrl").

-compile(export_all).

%% 加入队伍
join_team(State, _MbInfo) -> State.

%% 仲裁成功
arbitrate_result_success(State, DungeonRoleList) ->
    #team{target_enlist = #team_enlist{module_id = Module}} = State,
    if
        Module =:= ?MOD_BEINGS_GATE -> lib_beings_gate_api:destroy_portal(State, DungeonRoleList);
        true -> skip
    end.