%%-----------------------------------------------------------------------------
%% @Module  :       mod_daily_turntable.erl
%% @Author  :       Fwx
%% @Created :       2018-07-02
%% @Description:    每日转盘全服数据
%%-----------------------------------------------------------------------------
-module (mod_daily_turntable).
-include ("common.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,add_record/5
    ,send_records/2
]).

-define (SERVER, ?MODULE).
-define (REC_LEN, 15).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_record(SubType, RoleId, RoleName, GradeId, Time) ->
    gen_server:cast(?SERVER, {add_record, SubType, RoleId, RoleName, GradeId, Time}).

send_records(RoleId, SubType) ->
    gen_server:cast(?SERVER, {send_records, RoleId, SubType}).

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

do_handle_cast({add_record, SubType, RoleId, RoleName, GradeId, Time}, State) ->
    List = maps:get({records, SubType}, State, []),
    NewList = [{RoleId, RoleName, GradeId, Time}|List],
    CutList
    = case length(NewList) of
        L when L > ?REC_LEN ->
            lists:sublist(NewList, ?REC_LEN);
        _ ->
            NewList
    end,
    % {ok, BinData} = pt_331:write(33132, [SubType, CutList]),
    % lib_server_send:send_to_uid(RoleId, BinData), 
    {noreply, State#{{records, SubType} => CutList}};

do_handle_cast({send_records, RoleId, SubType}, State) ->
    List = maps:get({records, SubType}, State, []),
    {ok, BinData} = pt_331:write(33154, [SubType, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal

