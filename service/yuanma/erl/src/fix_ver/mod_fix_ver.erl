%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%            补丁秘籍管理进程
%%% @end
%%% Created : 25. 7月 2022 10:01
%%%-------------------------------------------------------------------
-module(mod_fix_ver).
-author("xzj").

-behaviour(gen_server).
-include("fix_ver.hrl").
-include("common.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    FixState = lib_fix_ver:init_fix(),
    FinState = lib_fix_ver:start_fix(FixState),
    {ok, FinState}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
