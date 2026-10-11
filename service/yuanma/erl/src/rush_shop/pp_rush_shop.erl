%% ---------------------------------------------------------------------------
%% @doc 抢购商城协议处理.
%% @author zhaoyu
%% @since  2014-07-10
%% @update by ningguoqiang 2015-07-14
%% ---------------------------------------------------------------------------
-module(pp_rush_shop).

-export([
        handle/3    %% 处理协议请求
]).

-include("common.hrl").
-include("server.hrl").

%% 获得抢购商城物品列表 
handle(64000, #player_status{} = Player, []) ->
    ?PRINT("64000~n",[]),
    Now = utime:longunixtime(),
    case get({'pp', 64000}) of
        N when is_integer(N) andalso (Now - N) < 200 ->
            skip;
        _ ->
            lib_rush_shop:goods_list(Player),
            put({'pp', 64000}, Now),
            ok
    end;

%% 购买抢购商城物品
handle(64001, #player_status{sid = Sid} = Player, [ID, Num]) ->
    case lib_rush_shop:buy_goods(Player, ID, Num) of
        {ok, #player_status{} = NewPlayer} ->
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, BinData} = pt_640:write(64001, [ErrorCode, ID, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData),
            ok
    end;

handle(_Cmd, _Player, _Data) ->
    {error, "pp_rush_shop no match"}.
