%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 22. 四月 2019 20:06
%%%-------------------------------------------------------------------
-module(mod_shake).
-author("whao").

-include("shake.hrl").
-include("def_fun.hrl").
-include("common.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile([export_all]).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 初始化
init([]) ->
    State = lib_shake_mod:init(),
    {ok, State}.


shake_add_log(RoleId, RoleName, RewardList) ->
    gen_server:cast(?MODULE, {'shake_add_log', RoleId, RoleName, RewardList}).

get_shake_log(RoleId, Type, SubType) ->
    gen_server:cast(?MODULE, {'get_shake_log', RoleId, Type, SubType}).

%%  handle cast
handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'shake_add_log', RoleId, RoleName, RewardList}, State) ->
    #shake_state{record_list = RecordList} = State,
    NewRecordList = lib_shake_mod:shake_add_log(RoleId, RoleName, RewardList, RecordList),
    NewState = State#shake_state{record_list = NewRecordList},
    List = lib_shake_mod:record_to_list(NewRecordList),
    ?PRINT("33199 ==========List :~p~n",[List]),
    {ok, BinData} = pt_331:write(33199, [List]),
    lib_server_send:send_to_all(all_lv, {?Shake_Lv, 99999999}, BinData),
    {ok, NewState};

do_handle_cast({'get_shake_log', RoleId, Type, SubType}, State) ->
    #shake_state{record_list = RecordList} = State,
    List = lib_shake_mod:record_to_list(RecordList),
    ?PRINT("33198 ==========Type:~p, SubType:~p, List :~p~n",[Type, SubType, List]),
    {ok, BinData} = pt_331:write(33198, [1, Type, SubType, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.


%% handle info
handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.



do_handle_info(_Info, State) -> {ok, State}.


%% handle call
handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.


do_handle_call(_Request, _State) -> {ok, ok}.



terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.















