%%-----------------------------------------------------------------------------
%% @Module  :       mod_lucky_turntable.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-31
%% @Description:    幸运转盘全服数据
%%-----------------------------------------------------------------------------
-module (mod_lucky_turntable).
-include ("common.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,add_record/7
    ,send_records/3
]).

-define (SERVER, ?MODULE).
-define (REC_LEN, 15).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_record(Type, SubType, RoleId, RoleName, GoodsId, Num, N) ->
    gen_server:cast(?SERVER, {add_record, Type, SubType, RoleId, RoleName, GoodsId, Num, N}).

send_records(RoleId, Type, SubType) ->
    gen_server:cast(?SERVER, {send_records, RoleId, Type, SubType}).

%% private
init([]) ->
    {ok, #{}}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({add_record, Type, SubType, RoleId, RoleName, GoodsId, Num, N}, State) ->
    List = maps:get({records, Type, SubType}, State, []),
    NewList = [{RoleId, RoleName, GoodsId, Num, N}|List],
    CutList
    = case length(NewList) of
        L when L > ?REC_LEN ->
            lists:sublist(NewList, ?REC_LEN);
        _ ->
            NewList
    end,
    % {ok, BinData} = pt_331:write(33132, [SubType, CutList]),
    % lib_server_send:send_to_uid(RoleId, BinData), 
    {noreply, State#{{records, Type, SubType} => CutList}};

do_handle_cast({send_records, RoleId, Type, SubType}, State) ->
    List = maps:get({records, Type, SubType}, State, []),
    {ok, BinData} = pt_331:write(33132, [Type, SubType, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

