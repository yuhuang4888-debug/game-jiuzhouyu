%% ---------------------------------------------------------------------------
%% @doc mod_player_create
%% @author ming_up@foxmail.com
%% @since  2016-08-26
%% @deprecated  玩家id计数器
%% ---------------------------------------------------------------------------
-module(mod_player_create).
-behaviour(gen_server).
-include("common.hrl").

-export([start_link/0, get_new_id/0, get_serid_by_id/1, get_real_serid_by_id/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {last_id=1, server_id=1}).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

get_new_id() -> 
    gen_server:call(misc:get_global_pid(?MODULE), 'get_new_id').

get_serid_by_id(Id) -> 
    <<SerId:16, _/binary>> = <<Id:48>>,
    SerId.

get_real_serid_by_id(Id) ->
    ServerId = get_serid_by_id(Id),
    case config:get_merge_server_ids() of 
        [] -> ServerId;
        MergeSerIds ->
            case lists:member(ServerId, MergeSerIds) of 
                false -> ServerId;
                true -> config:get_server_id()
            end
    end.

init([]) -> 
    process_flag(priority, high),
    AutoId = case db:get_row(<<"select count from auto_id where type=1">>) of
        [] -> 0;
        [TmpAutoId|_] -> TmpAutoId
    end,
    SerId = config:get_server_id(),
    LastId = case db:get_row(io_lib:format(<<"select id from player_login where server_id=~w order by id desc limit 1">>, [SerId])) of
        [] -> AutoId + 1;
        [Id|_] ->        
            <<_:16, TmpLastId:32>> = <<Id:48>>,
            max(TmpLastId, AutoId) + 1
    end,
    {ok, #state{last_id=LastId, server_id=SerId}}.

handle_call('get_new_id' , _FROM, #state{last_id=LastId, server_id=SerId} = Status) ->
    <<PlayerId:48>> = <<SerId:16, LastId:32>>,
    case catch db:execute(io_lib:format(<<"replace into auto_id set type=1, count=~w">>, [LastId])) of
        {'EXIT', _} = Reason -> ?ERR("get_new_id error = ~p", [Reason]);
        _ -> skip
    end,
    {reply, PlayerId, Status#state{last_id=LastId+1}};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_cast(_R , Status) ->
    {noreply, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.
