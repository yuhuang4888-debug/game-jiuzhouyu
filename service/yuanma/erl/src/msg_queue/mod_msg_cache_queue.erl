%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%         客户端消息缓存队列，负责广播延迟播报
%%% @end
%%% Created : 27. 5月 2022 16:35
%%%-------------------------------------------------------------------
-module(mod_msg_cache_queue).
-author("suyougame").

-behaviour(gen_server).
-include("common.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    update_queue/4
    , role_offline/1
    , send_queue/2
]).

-define(SERVER, ?MODULE).
-define(MAX_LEN, 20).

-record(msg_cache_queue, {
    cache_msg_map = #{}         %% #{role_id => msg_map} / msg_map = #{proto_id => msg_list}
%%    cache_record_map = #{}       %% #{role_id => record_map} / record_map = #{proto_id => {ref, record_list}}
}).

%% 更新缓存消息队列
update_queue(RoleId, ProtoId, Msg, Type) ->
    gen_server:cast(?MODULE, {update_queue, RoleId, ProtoId, Msg, Type}).

%% 玩家离线删除队列中玩家数据
role_offline(RoleId) ->
    gen_server:cast(?MODULE, {role_offline, RoleId}).

%% 发送玩家队列中消息
send_queue(RoleId, ProtoId) ->
    gen_server:cast(?MODULE, {send_queue, RoleId, ProtoId}).




%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, #msg_cache_queue{}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({update_queue, RoleId, ProtoId, Msg, Type}, State) ->
    #msg_cache_queue{cache_msg_map = CacheMap} = State,
    MsgMap =  maps:get(RoleId, CacheMap, #{}),
    MsgList = maps:get(ProtoId, MsgMap, []),
    case length(MsgList) < ?MAX_LEN of
        true ->
            NewMsg =
                case Type of
                    record ->
                        %% 就算客户端不发送消息过来，也需要将记录持久化
                        Ref = erlang:send_after(60000, self(), {do_send_queue, Type, Msg}),
                        {Type, Ref, Msg};
                    mfa_record ->
                        %% 就算客户端不发送消息过来，也需要将记录持久化
                        Ref = erlang:send_after(60000, self(), {do_send_queue, Type, Msg}),
                        {Type, Ref, Msg};
                    mfa_tv ->
                        {Type, undefined, Msg};
                    _ ->
                        {Type, undefined, Msg}
                end,
            NewMsgList = [NewMsg | MsgList],
            NewMsgMap = maps:put(ProtoId, NewMsgList, MsgMap),
            NewCacheMap = maps:put(RoleId, NewMsgMap, CacheMap);
        _ ->
            NewCacheMap = CacheMap
    end,
    NewState = State#msg_cache_queue{cache_msg_map = NewCacheMap},
    {noreply, NewState};

handle_cast({role_offline, RoleId}, State = #msg_cache_queue{}) ->
    #msg_cache_queue{cache_msg_map = CacheMap} = State,
    NewCacheMap = maps:remove(RoleId, CacheMap),
    NewState = State#msg_cache_queue{cache_msg_map = NewCacheMap},
    {noreply, NewState};

handle_cast({send_queue, RoleId, ProtoId}, State = #msg_cache_queue{}) ->
    #msg_cache_queue{cache_msg_map = CacheMap} = State,
    MsgMap =  maps:get(RoleId, CacheMap, #{}),
    MsgList = maps:get(ProtoId, MsgMap, []),
    lists:foreach(fun({Type, TimerRef, Msg}) ->
        case Type of
            record ->
                util:cancel_timer(TimerRef),
                mod_custom_act_record:cast(Msg);
            tv ->
                {ModleId, Id, Arg} = Msg,
                lib_chat:send_TV({all}, ModleId, Id, Arg);
            mfa_record ->
                {Modle, Fun, Arg} = Msg,
                util:cancel_timer(TimerRef),
                Modle:Fun(Arg);
            mfa_tv ->
                {Modle, Fun, Arg} = Msg,
                Modle:Fun(Arg);
            _ -> skip
        end
                  end, MsgList),
    NewMsgMap = maps:remove(ProtoId, MsgMap),
    NewCacheMap = maps:put(RoleId, NewMsgMap, CacheMap),
    NewState = State#msg_cache_queue{cache_msg_map = NewCacheMap},
    {noreply, NewState};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({do_send_queue, Type, Msg}, State) ->
    case Type of
        record ->
            mod_custom_act_record:cast(Msg);
        _ -> skip
    end,
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
