%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%         仙灵直购协议
%%% @end
%%% Created : 12. 7月 2022 15:43
%%%-------------------------------------------------------------------
-module(pp_fairy_buy).

-include("common.hrl").
-include("def_module.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

% 请求仙灵直购界面数据
handle(51300, Ps, [FairyId]) ->
    lib_fairy_buy:send_fairy_buy_info(Ps, FairyId);

%% 仙灵直购节点激活
handle(51301, Ps, [FairyId, NodeId]) ->
    {Err, NewPs} = lib_fairy_buy:activate_node(Ps, FairyId, NodeId),
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_513, 51301, [FairyId, NodeId, Err]),
    {ok, NewPs};

handle(51302, Ps, [FairyId]) ->
    FairyIdList = data_fairy_buy:get_all_fairy_id(),
    case lists:member(FairyId, FairyIdList) of
        true ->
            mod_counter:set_count(Ps#player_status.id, ?MODULE_FAIRY_BUY, FairyId, 1);
        _ ->
            skip
    end,
    {ok, Ps};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

