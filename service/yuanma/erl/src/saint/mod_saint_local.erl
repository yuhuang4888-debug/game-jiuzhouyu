%%%--------------------------------------
%%% @Module  : mod_saint_local
%%% @Author  : fwx
%%% @Created : 2018.6.13
%%% @Description:  圣者殿
%%%--------------------------------------
-module(mod_saint_local).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("def_fun.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("saint.hrl").
-include("role.hrl").

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 启动时通知跨服节点同步
sync_saint_info(RoleL) ->
    gen_server:cast(?MODULE, {'sync_saint_info', RoleL}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, #local_saint_state{}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Saint Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Saint Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_handle_cast({'sync_saint_info', RoleL}, State) ->
    F = fun
            ({SaintId, ServerId, RoleId}) ->
                case lib_role:get_role_show(RoleId) of
                    [] -> skip;
                    #ets_role_show{figure = Figure} ->
                        mod_clusters_node:apply_cast(mod_saint, update_saint_info, [ServerId, {SaintId, Figure, util:get_server_name()}])
                end
        end,
    [F(T) || T <- RoleL],
    {noreply, State};

do_handle_cast(Msg, State) ->
    ?ERR("~p ~p Saint Cast No Match:~w~n", [?MODULE, ?LINE, [Msg]]),
    {noreply, State}.

do_handle_info(_Info, State) ->
    ?ERR("~p ~p Saint Info No Match:~w~n", [?MODULE, ?LINE, [_Info]]),
    {noreply, State}.

