-module(pp_flower).

-export([handle/3]).

-include("server.hrl").
-include("flower.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("common.hrl").

handle(Cmd, PS, Data) ->
    #player_status{figure = Figure} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_FLOWER, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PS, Data);
        false -> skip
    end.

%% 赠送鲜花
do_handle(Cmd = 22301, #player_status{id = RoleId, server_id = SelfServerId} = Player, [ReceiverId, ReceiverSerId, GoodsId, GoodsNum, IsAnonymous]) when ReceiverId =/= RoleId ->
    case is_same_server(SelfServerId, ReceiverSerId) of 
        true ->
            {Code, NewPlayer} = lib_flower:send_gift(Player, ReceiverId, GoodsId, GoodsNum, IsAnonymous);
        _ ->
            {Code, NewPlayer} = lib_flower:send_gift_kf(Player, ReceiverId, ReceiverSerId, GoodsId, GoodsNum, IsAnonymous)
    end,
    ?PRINT("send_gift ## ~p~n", [Code]),
    {ok, BinData} = pt_223:write(Cmd, [Code, ReceiverId, ReceiverSerId, GoodsId, GoodsNum]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, battle_attr, NewPlayer};

%% 收礼记录
do_handle(Cmd = 22302, Player, []) ->
    #player_status{sid = Sid, id = RoleId} = Player,
    GiftRecordList = lib_flower:get_flower_gift_record(RoleId),
    {ok, BinData} = pt_223:write(Cmd, [GiftRecordList]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 鲜花相关信息
do_handle(Cmd = 22303, Player, []) ->
    #player_status{sid = Sid, flower = Flower} = Player,
    {ok, BinData} = pt_223:write(Cmd, [Flower#flower.flower_num, Flower#flower.charm, Flower#flower.fame]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 鲜花相关信息
do_handle(22305, Player, [Id]) ->
    {Code, NewPlayer} = lib_flower:thanks_flower(Player, Id),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_223, 22305, [Code, Id]),
    {ok, NewPlayer};

do_handle(_Cmd, _Player, _Data) ->
    {error, "pp_flower no match~n"}.

is_same_server(SelfServerId, ReceiverSerId) ->
    case SelfServerId == ReceiverSerId orelse lists:member(ReceiverSerId, config:get_merge_server_ids()) == true of 
        true -> true;
        _ -> false 
    end.
    