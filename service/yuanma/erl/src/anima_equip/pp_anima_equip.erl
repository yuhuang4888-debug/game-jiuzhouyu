%% ---------------------------------------------------------------------------
%% @doc 灵器模块
%% @author lxl
%% @since  2018-09-10
%% @deprecated
%% ---------------------------------------------------------------------------
-module(pp_anima_equip).
-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("anima_equip.hrl").

%% 穿戴
handle(18001, #player_status{sid = Sid} = PS, [AnimaId, GoodsId, EquipPos]) ->
    case lib_anima_equip:equip_anima(PS, AnimaId, GoodsId, EquipPos) of
        {ok, NewPS, AnimaEquip} ->
            ?PRINT("18001 AnimaEquip : ~p~n", [AnimaEquip]),
            #anima_equip{type_id = GTypeId} = AnimaEquip,
            {ok, Bin} = pt_180:write(18001, [?SUCCESS, AnimaId, GoodsId, EquipPos, GTypeId]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, battle_attr, NewPS};
        {false, Res} -> 
            ?PRINT("18001 Res : ~p~n", [Res]),
            {ok, Bin} = pt_180:write(18001, [Res, AnimaId, GoodsId, EquipPos, 0]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, PS}
    end;

%% 卸下
handle(18002, #player_status{sid = Sid} = PS, [AnimaId, EquipPos]) ->
    case lib_anima_equip:unequip_anima(PS, AnimaId, EquipPos) of
        {ok, NewPS} ->
            ?PRINT("18002  : ~p~n", [ok]),
            {ok, Bin} = pt_180:write(18002, [?SUCCESS, AnimaId, 0, EquipPos, 0]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, battle_attr, NewPS};
        {false, Res} -> 
            ?PRINT("18002 Res : ~p~n", [Res]),
            {ok, Bin} = pt_180:write(18002, [Res, AnimaId, 0, EquipPos, 0]),
            lib_server_send:send_to_sid(Sid, Bin),
            {ok, PS}
    end;

handle(_Cmd, _PS, _Data) ->
    ?ERR("no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_equip no match"}.