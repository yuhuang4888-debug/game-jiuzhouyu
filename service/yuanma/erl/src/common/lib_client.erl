%% ---------------------------------------------------------------------------
%% @doc lib_client.erl

%% @author hjh
%% @since  2016-08-19
%% @deprecated  客户端展示等通用函数
%% ---------------------------------------------------------------------------

-module(lib_client).

-export([goods_format/1, add_a_player_timer/1, delete_a_player_timer/1]).

%% 物品客户端展示格式
goods_format(L) ->
    goods_format(L, []).

goods_format([], Format) -> Format;
goods_format([T|L], Format) ->
    case T of
        {_, GoodsTypeId, Num}   -> NewFormat = [{GoodsTypeId, Num}|Format];
        _                       -> NewFormat = Format
    end,
    goods_format(L, NewFormat).

%% 添加定时器做统计
add_a_player_timer(Id) ->
    case get({'can_not_receive_12005', Id}) of 
        undefined ->
            TimerRef = erlang:send_after(30*1000, self(), {'can_not_receive_12005', Id}),
            put({'can_not_receive_12005', Id}, {TimerRef, 1});
        {OldTimerRef, CNum} ->
            util:cancel_timer(OldTimerRef),
            TimerRef = erlang:send_after(30*1000, self(), {'can_not_receive_12005', Id}),
            put({'can_not_receive_12005', Id}, {TimerRef, CNum+1})
    end.

%% 删除统计定时器
delete_a_player_timer(Id)->
    case get({'can_not_receive_12005', Id}) of 
        undefined ->
            skip;
        {OldTimerRef, _CNum} ->
            util:cancel_timer(OldTimerRef),
            erase({'can_not_receive_12005', Id})
    end.
