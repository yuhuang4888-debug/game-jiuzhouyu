%% ---------------------------------------------------------------------------
%% @doc mod_recharge_act
%% @author liuxl
%% @since  2017-04-10
%% @deprecated  充值活动进程
%% ---------------------------------------------------------------------------
-module(mod_recharge_act).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([
    start_link/0
    , get_player_daily_gift/2
    , get_daily_gift_state/2 
    , purchase_daily_gift/2 
    , receive_daily_gift/2 
    , clear_daily_gift/1 
    ]).
-compile(export_all).
-include("recharge_act.hrl").
-include("common.hrl").
-include("def_fun.hrl").

%%-----------------------------

%% 获取玩家的每日礼包状态
get_player_daily_gift(RoleId, ProductIds) ->
    gen_server:call({global, ?MODULE}, {get_player_daily_gift, RoleId, ProductIds}, 1000).
    
get_daily_gift_state(RoleId, ProductId) ->
    gen_server:call({global, ?MODULE}, {get_daily_gift_state, RoleId, ProductId}, 1000).

purchase_daily_gift(RoleId, ProductId) ->
    gen_server:cast({global, ?MODULE}, {purchase_daily_gift, RoleId, ProductId}).

receive_daily_gift(RoleId, ProductId) ->
    gen_server:cast({global, ?MODULE}, {receive_daily_gift, RoleId, ProductId}).

clear_daily_gift(DelaySec) ->
    gen_server:cast({global, ?MODULE}, {clear_daily_gift, DelaySec}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    Sql = io_lib:format(?SQL_DAILY_GIFT_SELECT_ALL, []),
    List = db:get_all(Sql),
    DailyGift = init_player_daily_gift(List, #{}),
    State = #recharge_act_state{
        daily_gift = DailyGift
    },
    {ok, State}.

init_player_daily_gift([], Map) -> Map;
init_player_daily_gift([H|List], Map) ->
    case H of 
        [PlayerId, ProductId, State] when State == ?DAILY_STATE_NOT_GET ->
            PSDaily = #ps_daily{player_id = PlayerId, product_id = ProductId, state = State},
            NewMap = maps:put({PlayerId, ProductId}, PSDaily, Map),
            init_player_daily_gift(List, NewMap);
        _ -> init_player_daily_gift(List, Map)
    end.


%% ====================
%% hanle_call
%% ====================
do_handle_call({get_player_daily_gift, RoleId, ProductIds}, _From, State) ->
    #recharge_act_state{ daily_gift = DailyGift } = State,
    F = fun(ProductId, List) ->
        case maps:get({RoleId, ProductId}, DailyGift, none) of 
            #ps_daily{state = ProductState} -> [{ProductId, ProductState}|List]; 
            _ -> [{ProductId, ?DAILY_STATE_NOT_PURCHASE}|List]
        end
    end,
    ProductList = lists:foldl(F, [], ProductIds),
    {reply, ProductList, State};
do_handle_call({get_daily_gift_state, RoleId, ProductId}, _From, State) ->
    #recharge_act_state{ daily_gift = DailyGift } = State,
    Reply = case maps:get({RoleId, ProductId}, DailyGift, none) of 
        #ps_daily{state = ProductState} -> {ok, ProductState};
        _ -> {ok, ?DAILY_STATE_NOT_PURCHASE}
    end,
    {reply, Reply, State};
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({purchase_daily_gift, RoleId, ProductId}, State) ->
    #recharge_act_state{ daily_gift = DailyGift } = State,
    PSDaily = #ps_daily{player_id = RoleId, product_id = ProductId, state = ?DAILY_STATE_NOT_GET},
    NewDailyGift = maps:put({RoleId, ProductId}, PSDaily, DailyGift),
    lib_daily_gift:db_update_daily_gift(PSDaily),
    %?PRINT("NewDailyGift ~p~n", [NewDailyGift]),
    {noreply, State#recharge_act_state{daily_gift = NewDailyGift}};

do_handle_cast({receive_daily_gift, RoleId, ProductId}, State) -> 
    #recharge_act_state{ daily_gift = DailyGift } = State,
    PSDaily = #ps_daily{player_id = RoleId, product_id = ProductId, state = ?DAILY_STATE_GET},
    NewDailyGift = maps:put({RoleId, ProductId}, PSDaily, DailyGift),
    lib_daily_gift:db_update_daily_gift(PSDaily),
    {noreply, State#recharge_act_state{daily_gift = NewDailyGift}};

do_handle_cast({clear_daily_gift, DelaySec}, State) ->
    #recharge_act_state{daily_gift = DailyGift} = State,
    spawn(fun() ->
                  util:multiserver_delay(DelaySec, lib_daily_gift, clear_daily_gift, [DailyGift])
          end),
    lib_daily_gift:db_clear_daily_gift(),
    {noreply, State#recharge_act_state{daily_gift = #{}}};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info(_Info, State) -> {noreply, State}.

