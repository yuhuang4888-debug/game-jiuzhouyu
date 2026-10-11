%% ---------------------------------------------------------------------------
%% @doc mod_kf_chat.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-12-17
%% @deprecated 跨服查看物品
%% ---------------------------------------------------------------------------
-module(mod_kf_chat).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).

-include("common.hrl").
-include("errcode.hrl").

-record(channel, {
        channel = 0         % 频道.可以是其他值,不一定是频道
        , goods_list = []   % [{goods_id,BinData}]
    }).

-record(state, {
        channel_m = #{}     % 物品map; Key:频道, Value:#channel{}
    }).

%% 小配置
get_config(T) ->
    case T of
        % 物品列表最大长度
        goods_max_len -> 50;
        % 物品列表截断上限
        goods_sub_len -> 100
    end.

%% -----------------------------------------------
%% 接口
%% -----------------------------------------------

%% 增加物品
%% @param BinDataL [{GoodsId, BinData}]
add_goods_info_list(Channel, BinDataL) ->
    gen_server:cast(?MODULE, {'add_goods_info_list', Channel, BinDataL}).

%% 查看物品
send_goods_info(ServerId, RoleId, Channel, GoodsId) ->
    gen_server:cast(?MODULE, {'send_goods_info', ServerId, RoleId, Channel, GoodsId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, #state{}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, _From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

do_handle_call(_Request, _From, State)->
    {reply, ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -----------------------------------------------
%% handle_cast
%% -----------------------------------------------

do_handle_cast({'add_goods_info_list', Channel, BinDataL}, State) ->
    % ?PRINT("Channel:~p, BinDataL:~p ~n", [Channel, BinDataL]),
    #state{channel_m = ChannelM} = State,
    ChannelRec = maps:get(Channel, ChannelM, #channel{channel=Channel}),
    #channel{goods_list = GoodsList} = ChannelRec,
    F = fun({GoodsId, BinData}, L) -> [{GoodsId, BinData}|lists:delete(GoodsId, L)] end,
    NewGoodsList = lists:foldl(F, GoodsList, lists:reverse(BinDataL)),
    MaxLen = get_config(goods_max_len),
    SubLen = get_config(goods_sub_len),
    case length(NewGoodsList) > SubLen of
        true -> SubGoodsList = lists:sublist(NewGoodsList, MaxLen);
        false -> SubGoodsList = NewGoodsList
    end,
    NewChannelRec = ChannelRec#channel{goods_list = SubGoodsList},
    NewChannelM = maps:put(Channel, NewChannelRec, ChannelM),
    NewState = State#state{channel_m = NewChannelM},
    {noreply, NewState};

do_handle_cast({'send_goods_info', Node, RoleId, Channel, GoodsId}, State) ->
    #state{channel_m = ChannelM} = State,
    ChannelRec = maps:get(Channel, ChannelM, #channel{channel=Channel}),
    #channel{goods_list = GoodsList} = ChannelRec,
    case lists:keyfind(GoodsId, 1, GoodsList) of
        false -> ErrCode = ?ERRCODE(err150_no_goods), GoodsBinData = <<>>;
        {GoodsId, GoodsBinData} -> ErrCode = ?SUCCESS
    end,
    % ?PRINT("Channel:~p, GoodsId:~p ErrCode:~p ~n", [Channel, GoodsId, ErrCode]),
    {ok, BinData} = pt_110:write(11026, [ErrCode]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    case ErrCode == ?SUCCESS of
        true -> lib_server_send:send_to_uid(Node, RoleId, GoodsBinData);
        false -> skip
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% -----------------------------------------------
%% handle_info
%% -----------------------------------------------

do_handle_info(_Info, State) ->
    {noreply, State}.

%% -----------------------------------------------
%% 内部函数util
%% -----------------------------------------------