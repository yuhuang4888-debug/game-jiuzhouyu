%% ---------------------------------------------------------------------------
%% @doc 抢购商城进程.
%% @author zhaoyu
%% @since  2014-07-08
%% @update by ningguoqiang 2015-07-14
%% ---------------------------------------------------------------------------
-module(mod_rush_shop).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([
        init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
        ,daily_clear/0
]).

-include("common.hrl").
-include("rush_shop.hrl").

%% ---------------------------------------------------------------------------
%% @doc 删除可以重置商品记录
daily_clear() ->
    gen_server:cast({global, ?MODULE}, {daily_clear}).

%% ---------------------------------------------------------------------------

%% ---------------------------------------------------------------------------
%% @doc Starts the server
-spec start_link() -> {ok, Pid} | ignore | {error, Error} when
    Pid :: pid(),
    Error :: term().
%% ---------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
%% @doc Initializes the server
-spec init(Args) ->
    {ok, State}
    | {ok, State, Timeout}
    | ignore
    | {stop, Reason} when
    Args    :: term() ,
    State   :: none,
    Timeout :: non_neg_integer() | infinity,
    Reason  :: term().
%% ---------------------------------------------------------------------------
init([]) ->
    self() ! 'init_rush_shop',
    {ok, #rush_shop{}}.


%% ---------------------------------------------------------------------------
%% @doc Handling call messages
-spec handle_call(Request, From, State) ->
    {reply, Reply, State}
    | {reply, Reply, State, Timeout}
    | {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, Reply, State}
    | {stop, Reason, State} when
    Request :: term(),
    From :: pid(),
    State :: #rush_shop{},
    Reply :: term(),
    State :: #rush_shop{},
    Timeout :: non_neg_integer() | infinity.
%% ---------------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% ---------------------------------------------------------------------------
%% @doc Handling cast messages
-spec handle_cast(Msg, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Msg :: term(),
    State :: #rush_shop{},
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle msg[~w] error:~w!~n", [Msg, Err]),
            {noreply, State}
    end.

%% 查询商城商品信息
do_handle_cast({'list_goods', Sid, DoneNums}, State) ->
    % ?PRINT("TEST ~p! ~p! ~p!~n",[State, Sid, DoneNums]),
    lib_rush_shop:list_goods(State, Sid, DoneNums),
    {ok, State};

%% 购买商品
do_handle_cast({'goods_buy', RoleID, ID, Num, Done}, State) ->
    lib_rush_shop:goods_buy(State, RoleID, ID, Num, Done);

%% 重新加载商城商品(GM)
do_handle_cast({'reload', _Node}, State) ->
    lib_rush_shop:reload(State);

%% 零点删除记录
do_handle_cast({'daily_clear'}, State) ->
    lib_rush_shop:reset_clear(State);

do_handle_cast(_Msg, State) ->
    {ok, State}.

%% ---------------------------------------------------------------------------
%% @doc Handling all non call/cast messages
-spec handle_info(Info, State) ->
    {noreply, State}
    | {noreply, State, Timeout}
    | {stop, Reason, State} when
    Info :: term(),
    State :: #rush_shop{},
    Timeout :: non_neg_integer() | infinity,
    Reason :: term().
%% ---------------------------------------------------------------------------
handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle info[~w] error:~w!~n", [Info, Err]),
            {noreply, State}
    end.

%% 初始化抢购商城
do_handle_info('init_rush_shop', _State) ->
    NewState = lib_rush_shop_data:init_all(),
    %% 初始化更新标志
    put('refresh', false),
    {ok, NewState};

%% 定时下架物品
do_handle_info('del', State) ->
    lib_rush_shop:broadcast_delete_goods(State);

%% 定时开售物品
do_handle_info('add', State) ->
    lib_rush_shop:broadcast_goods(State);

%% 定时刷新物品
do_handle_info('refresh', State) ->
    lib_rush_shop:broadcast_remaining_num(State),
    {ok, State};

%% 检测是否变更数据
do_handle_info('check', State) ->
    lib_rush_shop:check_refresh(State);

do_handle_info(_Info, State) ->
    {ok, State}.


%% ---------------------------------------------------------------------------
%% @doc called by a gen_server when it is about to terminate
-spec terminate(Reason, State) -> ok when
    Reason :: term(),
    State :: #rush_shop{}.
%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.


%% ---------------------------------------------------------------------------
%% @doc Convert process state when code is changed
-spec code_change(OldVsn, State, Extra) -> {ok, NewState} when
    OldVsn :: term(),
    State :: #rush_shop{},
    Extra :: term(),
    NewState :: #rush_shop{}.
%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
