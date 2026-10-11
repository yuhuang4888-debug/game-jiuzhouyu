%%% -------------------------------------------------------------------
%%% @doc        pp_beings_gate                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-02 14:30               
%%% @deprecated 众生之门控制层
%%% -------------------------------------------------------------------

-module(pp_beings_gate).

-include("server.hrl").
-include("team.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("errcode.hrl").

%% API
-export([handle/3]).

%% -----------------------------------------------------------------
%% @desc 获取众生之门活动状态
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24101, PS, [])->
    #player_status{id = RoleId, portal_id = _PortalId} = PS,
    % ?MYLOG("lwcbeings","PortalId:~p~n",[PortalId]),
    mod_beings_gate_local:send_beings_gate_info({RoleId, uid});

%% -----------------------------------------------------------------
%% @desc 获取传送门信息
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24102, PS, []) ->
    #player_status{id = RoleId, server_id = ServerId} = PS,
    mod_beings_gate_local:send_beings_portal_info(RoleId, ServerId);

%% -----------------------------------------------------------------
%% @desc 进入传送门
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24103, PS, [PortalId]) ->
    %?MYLOG("lwcbeings","PortalId:~p~n",[PortalId]),
    #player_status{id = RoleId, server_id = ServerId, team = #status_team{team_id = TeamId, positon = Position}} = PS,
    TeamId > 0 andalso Position =:= ?TEAM_LEADER andalso mod_beings_gate_local:enter_portal(PortalId, ServerId, RoleId);

%% -----------------------------------------------------------------
%% @desc 进入众生之门场景
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24104, PS, []) ->
    lib_beings_gate:enter_beings_gate_scene(PS);

%% -----------------------------------------------------------------
%% @desc 退出众生之门场景
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24105, PS, []) ->
    lib_beings_gate:quit_beings_gate_scene(PS);

%% -----------------------------------------------------------------
%% @desc 获取次数信息
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24107, PS, []) ->
    #player_status{id = RoleId} = PS,
    HelpCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, ?DUNGEON_TYPE_BEINGS_GATE),
    DailyCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, ?DUNGEON_TYPE_BEINGS_GATE),
    {ok, BinData} = pt_241:write(24107, [HelpCount, DailyCount]),
    %?MYLOG("lwcbeings", "{HelpCount, DailyCount}:~p~n", [{HelpCount, DailyCount}]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% -----------------------------------------------------------------
%% @desc 进入众生之门玩法
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24108, PS, []) ->
    #player_status{id = RoleId, team = TeamStatus} = PS,
    #status_team{team_id = TeamId, positon = Position} = TeamStatus,
    lib_beings_gate:enter_beings_gate_scene(PS),
    {ok, BinData} = pt_241:write(24108, [?SUCCESS]),
    ?IF(TeamId > 0 andalso Position =:= ?TEAM_LEADER, mod_team:cast_to_team(TeamId, {'enter_beings_gate', RoleId}), lib_server_send:send_to_uid(RoleId, BinData));

%% -----------------------------------------------------------------
%% @desc 获得招募副本Id
%% @param
%% @return
%% -----------------------------------------------------------------
handle(24109, PS, []) ->
    DunId = lib_beings_gate_util:get_beings_gate_dungeon_id(),
    {ok, BinData} = pt_241:write(24109, [DunId]),
    lib_server_send:send_to_uid(PS#player_status.id, BinData);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
