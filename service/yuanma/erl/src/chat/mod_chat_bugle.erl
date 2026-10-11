%% ---------------------------------------------------------------------------
%% @doc mod_chat_bugle.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-13
%% @deprecated
%% ---------------------------------------------------------------------------
-module(mod_chat_bugle).

-behaviour(gen_server).

-export([]).

-compile(export_all).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("chat.hrl").
-include("common.hrl").

-record(state, {
        bugle_queue = queue:new(),     %% 玩家喇叭队列
        gm_bugle_queue = queue:new(),  %% gm喇叭队列(优先)
        ref = none                     %% 定时器
    }).

%% gm发送系统喇叭
gm_put(ShowTime, Msg)->
    MsgSend = lib_word:filter_text_gm(Msg),
    PackData = [?CHAT_CHANNEL_HORN, 1, MsgSend],
    Bugle = #bugle{show_time = ShowTime, msg = PackData},
    gen_server:cast({global, ?MODULE}, {'gm_put', Bugle}).

put(Bugle) ->
    gen_server:cast({global, ?MODULE}, {'put', Bugle}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    {ok, #state{} }.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% gm发送喇叭
handle_cast({'gm_put', Bugle}, State) ->
    #state{gm_bugle_queue = GmBugleQueue, ref = Ref} = State,
    NewGmBugleQueue = queue:in(Bugle, GmBugleQueue),
    case is_reference(Ref) of
        true ->
            NewState = State#state{gm_bugle_queue = NewGmBugleQueue};
        false ->
            {{value, OutBugle}, NewBugleQueue2} = queue:out(NewGmBugleQueue),
            #bugle{show_time = ShowTime} = OutBugle,
            send_gm_bugle(OutBugle),
            NewRef = erlang:send_after(ShowTime*1000, self(), {'send_bugle'}),
            NewState = State#state{bugle_queue = NewBugleQueue2, ref = NewRef}
    end,
    {noreply, NewState};

handle_cast({'put', Bugle}, State) ->
    #state{bugle_queue = BugleQueue, ref = Ref} = State,
    NewBugleQueue = queue:in(Bugle, BugleQueue),
    case is_reference(Ref) of
        true ->
            NewState = State#state{bugle_queue = NewBugleQueue};
        false ->
            {{value, OutBugle}, NewBugleQueue2} = queue:out(NewBugleQueue),
            #bugle{show_time = ShowTime} = OutBugle,
            send_bugle(OutBugle),
            NewRef = erlang:send_after(ShowTime*1000, self(), {'send_bugle'}),
            NewState = State#state{bugle_queue = NewBugleQueue2, ref = NewRef}
    end,
    {noreply, NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'send_bugle'}, State) ->
    #state{gm_bugle_queue = GmBugleQueue, bugle_queue = BugleQueue, ref = Ref} = State,
    util:cancel_timer(Ref),
    case queue:out(GmBugleQueue) of
        {empty, _NewGmBugleQueue} ->
            case queue:out(BugleQueue) of
                {empty, NewBugleQueue} ->
                    NewState = State#state{bugle_queue = NewBugleQueue, ref = none};
                {{value, OutBugle}, NewBugleQueue} ->
                    #bugle{show_time = ShowTime} = OutBugle,
                    send_bugle(OutBugle),
                    NewRef = erlang:send_after(ShowTime*1000, self(), {'send_bugle'}),
                    NewState = State#state{bugle_queue = NewBugleQueue, ref = NewRef}
            end;
        {{value, GmOutBugle}, NewGmBugleQueue} ->
            #bugle{show_time = ShowTime} = GmOutBugle,
            send_gm_bugle(GmOutBugle),
            NewRef = erlang:send_after(ShowTime*1000, self(), {'send_bugle'}),
            NewState = State#state{gm_bugle_queue = NewGmBugleQueue, ref = NewRef}
    end,
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

send_gm_bugle(OutBugle)->
    #bugle{show_time = ShowTime, msg = PackData, send_type = SendType} = OutBugle,
    [CHANNEL, Gm, MsgSend] = PackData,
    {ok, BinData} = pt_110:write(11021, [CHANNEL, Gm, ShowTime, MsgSend]),
    % lib_server_send:send_to_all(BinData),
    send_bugle_msg(SendType, BinData),
    ok.

send_bugle(#bugle{role_id = RoleId, msg = Chat, send_type = SendType}) ->
    #chat{
        channel = Channel
        , sender_server_num = ServerNum
        , sender_id = Id
        , sender_figure = Figure
        , sender_server_id = SerId
        , sender_server_name = ServerName
        , msg_send = MsgSend
        , args = Args
        , args_result = ArgsResult
        , utime = Utime
        , province = Province
        , city = City
        , horn_type = HornType
    } = Chat,
    {ok, BinData} = pt_110:write(11029, [Channel, ServerNum, SerId, ServerName, Province, City, HornType, Id, Figure, MsgSend, Args, ArgsResult, Utime]),
    List = data_horn:get_value(cost_goods),
    case lists:keyfind(SendType, 1, List) of
        {_, Cost} when is_list(Cost) -> Cost;
        _ -> Cost = []
    end,
    lib_log_api:log_bugle(RoleId, SendType, MsgSend, Cost),
    send_bugle_msg(SendType, BinData),
    ok.

send_bugle_msg(SendType, BinData) when SendType == ?SELF_SERVER ->
    lib_server_send:send_to_all(BinData);
send_bugle_msg(SendType, BinData) when SendType == ?SELF_ZONE ->
    ServerId = config:get_server_id(),
    mod_clusters_node:apply_cast(?MODULE, send_bugle_zone, [ServerId, BinData]);
send_bugle_msg(SendType, BinData) when SendType == ?ALL_SERVER ->
    mod_clusters_node:apply_cast(?MODULE, send_bugle_all_node, [BinData]);
send_bugle_msg(_, _) -> skip.

send_bugle_zone(ServerId, BinData) ->
    mod_zone_mgr:chat_by_server_id(ServerId, BinData).

send_bugle_all_node(BinData) ->
    mod_clusters_center:apply_to_all_node(lib_server_send, send_to_all, [BinData]).