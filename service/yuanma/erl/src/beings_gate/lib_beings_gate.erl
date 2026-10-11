%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 16:06
%%% @deprecated 众生之门玩家进程逻辑层
%%% -------------------------------------------------------------------

-module(lib_beings_gate).

-include("server.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("beings_gate.hrl").
-include("predefine.hrl").

%% API
-export([enter_beings_gate_scene/1, quit_beings_gate_scene/1, enter_portal/3, re_login/2]).

%% -----------------------------------------------------------------
%% @desc 进入众生之门场景
%% @param PS
%% @return
%% -----------------------------------------------------------------
enter_beings_gate_scene(PS) ->
    #player_status{id = RoleId, server_id = ServerId, scene = Scene} = PS,
    case lib_player_check:check_list(PS, [action_free]) of
        {false, ErrCode} ->
            {ok, BinData} = pt_241:write(24104, [ErrCode]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            case Scene =:= ?SCENE_LOCAL orelse Scene =:= ?SCENE_CENTER of
                true ->
                    {ok, BinData} = pt_241:write(24104, [?ERRCODE(err241_in_beings_gate)]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                false -> mod_beings_gate_local:enter_beings_gate_scene(RoleId, ServerId)
            end
    end.

%% -----------------------------------------------------------------
%% @desc 退出众生之门场景
%% @param PS
%% @return
%% -----------------------------------------------------------------
quit_beings_gate_scene(PS) ->
    #player_status{id = RoleId, scene = SceneId} = PS,
    #ets_scene{type = Type} = data_scene:get(SceneId),
    case Type == ?SCENE_TYPE_BEINGS_GATE of
        true ->
            NewPlayer = lib_scene:change_scene(PS, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim, 100}]),
            {ok, BinData} = pt_241:write(24105, [?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData);
        false ->
            {ok, BinData} = pt_241:write(24105, [?ERRCODE(err241_no_in_beings_gate)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewPlayer = PS
    end,
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% @desc 进入传送门
%% @param PS       玩家记录
%% @param Flag     发送类别
%% @param PortalId 传送门Id
%% @return {ok, NewPS}
%% -----------------------------------------------------------------
enter_portal(PS, Flag, PortalId) ->
    #player_status{id = RoleId} = PS,
    case Flag of
        true ->
            {ok, BinData} = pt_241:write(24103, [?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, PS#player_status{portal_id = PortalId}};
        false ->
            {ok, BinData} = pt_241:write(24103, [?ERRCODE(err241_no_portal_id)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, PS}
    end.

%% -----------------------------------------------------------------
%% @desc 玩家重连登录处理
%% @param
%% @return
%% -----------------------------------------------------------------
re_login(Player, ?NORMAL_LOGIN) ->
    #player_status{scene = SceneId} = Player,
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    case SceneType of
        ?SCENE_TYPE_BEINGS_GATE ->
            NewPlayer = lib_scene:change_default_scene(Player, [{group, 0}, {change_scene_hp_lim, 1}]),
            {ok, NewPlayer};
        _ ->
            {next, Player}
    end;
re_login(Player, ?RE_LOGIN) ->
    #player_status{scene = SceneId} = Player,
    #ets_scene{type = SceneType} = data_scene:get(SceneId),
    case SceneType of
        ?SCENE_TYPE_BEINGS_GATE ->
            NewPlayer = lib_scene:change_relogin_scene(Player, [{change_scene_hp_lim, 100}]),
            {ok, NewPlayer};
        _ ->
            {next, Player}
    end.
