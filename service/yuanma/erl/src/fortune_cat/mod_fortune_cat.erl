%% ---------------------------------------------------------------------------
%% @doc mod_fortune_cat

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/5
%% @deprecated  招财猫榜单进程（定制活动）
%% ---------------------------------------------------------------------------
-module(mod_fortune_cat).

-include ("common.hrl").
-include ("custom_act.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([add_record/6, act_end/1, send_turntable_records/2]).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_record(SubType, RoleId, Name, GoodsId, GoodsNum, IsRare) ->
    gen_server:cast(?MODULE, {'add_record', [SubType, RoleId, Name, GoodsId, GoodsNum, IsRare]}).

send_turntable_records(RoleId, SubType) ->
    gen_server:cast(?MODULE, {'send_turntable_records', [RoleId, SubType]}).

act_end(ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', ActInfo}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

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

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({'add_record', Args}, State) ->
    [SubType, RoleId, Name, GoodsId, GoodsNum, IsRare] = Args,
    TypeMap = maps:get(SubType, State, #{}),

    RoleRecordMap = maps:get(role_record, TypeMap, #{}),
    RoleRecords = maps:get(RoleId, RoleRecordMap, []),
    NewRoleRecords = [{RoleId, Name, GoodsId, GoodsNum}|RoleRecords],
    NewRoleRecordMap = maps:put(RoleId, NewRoleRecords, RoleRecordMap),
    TypeMapTmp = maps:put(role_record, NewRoleRecordMap, TypeMap),

%%    NewTypeMap = case IsRare of
%%        1 ->
%%            GlobalRecords = maps:get(global_record, TypeMap, []),
%%            NewGlobalRecords = [{RoleId, Name, GoodsId, GoodsNum}|GlobalRecords],
%%            maps:put(global_record, NewGlobalRecords, TypeMapTmp);
%%        _ -> TypeMapTmp
%%    end,

    GlobalRecords = maps:get(global_record, TypeMap, []),
    NewGlobalRecords = [{RoleId, Name, GoodsId, GoodsNum}|GlobalRecords],
    NewTypeMap = maps:put(global_record, NewGlobalRecords, TypeMapTmp),

    %% 主动推送记录
    send_turntable_records(RoleId, SubType),

    {noreply, maps:put(SubType, NewTypeMap, State)};

do_handle_cast({'send_turntable_records', [RoleId, SubType]}, State) ->
    TypeMap = maps:get(SubType, State, #{}),
    GlobalRecords = maps:get(global_record, TypeMap, []),
    RoleRecordMap = maps:get(role_record, TypeMap, #{}),
    RoleRecords = maps:get(RoleId, RoleRecordMap, []),
    ?PRINT("@@@ ~p ~n", [[?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType, RoleRecords, GlobalRecords]]),
    lib_server_send:send_to_uid(RoleId, pt_332, 33226, [?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType, RoleRecords, GlobalRecords]),
    {noreply, State};

do_handle_cast({'act_end', #act_info{key = {?CUSTOM_ACT_TYPE_FORTUNE_CAT, SubType}}}, State) ->
    {noreply, maps:remove(SubType, State)};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

%%==============================DB=====================================
