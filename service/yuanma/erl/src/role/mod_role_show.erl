%% ---------------------------------------------------------------------------
%% @doc mod_role_show.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-04-24
%% @deprecated 玩家展示ets同步进程
%% ---------------------------------------------------------------------------
-module(mod_role_show).
-export([]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).

-include_lib("stdlib/include/ms_transform.hrl").

-include("common.hrl").
-include("role.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").

%% 更新
update(Id, KeyList) ->
    gen_server:cast(?MODULE, {'update', Id, KeyList}).

%% 日常清理
daily_clear(ClockType) ->
    gen_server:cast(?MODULE, {'daily_clear', ClockType}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Req Error:~p~n", [[Req, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% call
%%%===================================================================
do_handle_call(_Req, _From, State) ->
    ?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%%%===================================================================
%%% cast
%%%===================================================================

do_handle_cast({'update', Id, KeyList}, State) ->
    %% 更新玩家展示Ets
    lib_role:update_role_show_help(Id, KeyList),
    {noreply, State};

do_handle_cast({'daily_clear', ClockType}, State) ->
    do_daily_clear(ClockType),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?PRINT("Msg:~p~n", [_Msg]),
    {noreply, State}.

%%%===================================================================
%%% info
%%%===================================================================

do_handle_info(_Info, State) ->
    ?PRINT("Info: ~p~n", [_Info]),
    {noreply, State}.

%%%===================================================================
%%% other
%%%===================================================================

%% 日常清理
do_daily_clear(ClockType) ->
    EquipCountType = lib_dungeon_api:get_daily_count_type(?DUNGEON_TYPE_EQUIP, 0),
    % Mspec = ets:fun2ms(fun(#ets_role_show{id = RoleId, dun_daily_map = DunDailyMap}) ->
    %     {RoleId, DunDailyMap}
    % end),
    % 判断是否要清理
    case lib_daily:is_clear(ClockType, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, EquipCountType) of
        true ->
            F = fun(#ets_role_show{id = RoleId, dun_daily_map = DunDailyMap}, Acc) ->
                case maps:get(EquipCountType, DunDailyMap, 0) > 0 of
                    true ->
                        NewDunDailyMap = maps:put(EquipCountType, 0, DunDailyMap),
                        ets:update_element(?ETS_ROLE_SHOW, RoleId, [{#ets_role_show.dun_daily_map, NewDunDailyMap}]);
                    false ->
                        skip
                end,
                Acc
            end,
            ets:foldl(F, ok, ?ETS_ROLE_SHOW),
            ok;
        false ->
            skip
    end.
    