%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created :  3 Feb 2018 by root <root@localhost.localdomain>
-module(pp_designation).

-export([handle/3]).
-include("designation.hrl").
-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("errcode.hrl").

%% 获取称号列表
handle(41101, PlayerStatus, []) ->
    #player_status{sid = Sid, dsgt_status = DsgtStatus} = PlayerStatus,
    {List, ExpireList} = lib_designation:get_player_dsgt(DsgtStatus),
    F = fun(RmDsgtId, PSTmp) ->
                {ok, PsTmp} = lib_designation:cancel_dsgt(PSTmp, RmDsgtId),
                PsTmp
        end,
    NewPS = lists:foldl(F, PlayerStatus, ExpireList),
    Figure = NewPS#player_status.figure,
    %%圣域称号特殊处理
    NewList = lib_sanctuary:get_right_send_designation_list(List),
    {ok, BinData} = pt_411:write(41101, [Figure#figure.designation, NewList]),
    %?PRINT("UsedDsgtId:~p, DesignationList:~p~n", [Figure#figure.designation, List]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPS};

%% 佩戴称号
handle(41102, PlayerStatus, [DsgtId]) ->
    #player_status{id = PlayerId, sid = Sid, figure = Figure, dsgt_status = DsgtStatus,
                  scene = SceneId, scene_pool_id = ScenePId, copy_id = CopyId, x = X, y = Y} = PlayerStatus,
    UsedDsgtId = Figure#figure.designation,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    CheckList = [
                 {check_change_same_id, {DsgtId, UsedDsgtId}},
                 {check_id_valid, {DsgtId, DsgtMap}},
                 {check_is_expire, {DsgtId, DsgtMap}}
                ],
    case lib_designation_util:checklist(CheckList) of
        true ->
            NewDsgtStatus = lib_designation:change_dsgt(DsgtId, Figure#figure.designation, DsgtStatus),
            mod_scene_agent:update(PlayerStatus, [{designation, DsgtId}]),
            NewFigure = Figure#figure{designation = DsgtId},
            NewPs = PlayerStatus#player_status{figure = NewFigure, dsgt_status = NewDsgtStatus},
            %% 佩戴成功
            {ok, BinData1} = pt_411:write(41102, [?CODE_OK, DsgtId]),
            lib_server_send:send_to_sid(Sid, BinData1),
            %% 场景广播
            {ok, BinData2} = pt_411:write(41105, [PlayerId, DsgtId]),
            lib_server_send:send_to_area_scene(SceneId, ScenePId, CopyId, X, Y, BinData2),
            {ok, NewPs};
        {fail, ErrCode} ->
            {ok, BinData} = pt_411:write(41102, [ErrCode, 0]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 卸下称号
handle(41103, PlayerStatus, [DsgtId]) ->
    #player_status{id = RoleId, sid = Sid, figure = Figure, dsgt_status = DsgtStatus,
                   scene = SceneId, scene_pool_id = ScenePId, copy_id = CopyId, x = X, y = Y} = PlayerStatus,
    UsedDsgtId = Figure#figure.designation,
    CheckList = [
                 {check_hide_current, {DsgtId, UsedDsgtId}},
                 {check_current_exist, {DsgtId, DsgtStatus#dsgt_status.dsgt_map}}
                ],
    case lib_designation_util:checklist(CheckList) of
        true ->
            NewDsgtStatus = lib_designation:hide_dsgt(DsgtId, DsgtStatus),
            mod_scene_agent:update(PlayerStatus, [{designation, 0}]),
            NewFigure = Figure#figure{designation = 0},
            NewPs = PlayerStatus#player_status{dsgt_status = NewDsgtStatus, figure = NewFigure},
            {ok, BinData} = pt_411:write(41103, [?CODE_OK]),
            lib_server_send:send_to_sid(Sid, BinData),
            %% 场景广播
            {ok, BinData2} = pt_411:write(41105, [RoleId, 0]),
            lib_server_send:send_to_area_scene(SceneId, ScenePId, CopyId, X, Y, BinData2),
            {ok, NewPs};
        {fail, ErrCode} ->
            {ok, BinData} = pt_411:write(41103, [ErrCode]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;
%%称号升阶
handle(41106, PlayerStatus, [DsgtId]) ->
    {ok, OldPower, UsedDsgtId, NewPlayerS} = lib_designation:up_dsgt(PlayerStatus, DsgtId),
    #player_status{sid = Sid, dsgt_status = DsgtStatus, combat_power = CombatPower} = NewPlayerS,
    PowerAdd = CombatPower - OldPower,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case maps:get(DsgtId, DsgtMap, none) of
        none ->
            skip;
        #designation{dsgt_order = Order} ->
            {ok, BinData} = pt_411:write(41106, [1, Order, PowerAdd, UsedDsgtId, DsgtId]),
            %?PRINT("{DsgtId, NewOrder, PowerAdd, UsedDsgtId}:~p~n",[{DsgtId, Order, PowerAdd, UsedDsgtId}]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {ok, battle_attr, NewPlayerS};

handle(41107, PS, [DsgtId]) ->
   lib_designation:get_dsgt_power(PS, DsgtId);

%% 激活称号   
handle(41109, PS, [DsgtId]) ->
    {ok, OldPower, UsedDsgtId, NewPs} = lib_designation:active_dsgt_bygoods(PS, DsgtId),
    #player_status{sid = Sid, dsgt_status = DsgtStatus, combat_power = CombatPower} = NewPs,
    PowerAdd = CombatPower - OldPower,
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    case maps:get(DsgtId, DsgtMap, none) of
        none ->
            skip;
        _ ->
            {ok, BinData} = pt_411:write(41109, [1, PowerAdd, UsedDsgtId, DsgtId]),
            %?PRINT("{DsgtId, NewOrder, PowerAdd, UsedDsgtId}:~p~n",[{DsgtId, Order, PowerAdd, UsedDsgtId}]),
            lib_server_send:send_to_sid(Sid, BinData),
            lib_task_api:active_dsg(PS, maps:size(DsgtMap)),
            lib_task_api:active_dsg_id(PS, DsgtId)
    end,
    {ok, battle_attr, NewPs};

%% 称号过期处理
handle(41110, PS, [DsgtId]) ->
    ?PRINT("enter 41110", []),
    case lib_designation:cancel_dsgt(PS, DsgtId) of
        {ok, NewPS} ->
            {ok, BinData} = pt_411:write(41110, [?SUCCESS]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData),
            {ok, NewPS};
        _ ->
            {ok, BinData} = pt_411:write(41110, [?FAIL]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData)
    end;

handle(_, PlayerStatus, _) ->
    {ok, PlayerStatus}.
