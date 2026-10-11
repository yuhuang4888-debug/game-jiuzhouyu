%% ---------------------------------------------------------------------------
%% @doc mod_mystery_shop
%% @author zengzy
%% @since  2017-11-28
%% @deprecated  使魔商店
%% ---------------------------------------------------------------------------
-module(mod_mystery_shop).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([
    start_link/0
    ]).
-compile(export_all).
-include("shop.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
%%-----------------------------

%%玩家登录加载
login(RoleId, Career, Lv)->
    gen_server:cast({global, ?MODULE}, {login,RoleId, Career, Lv}).

logout(RoleId) ->
    gen_server:cast({global, ?MODULE}, {logout,RoleId}).

%% 商店主页
shop_main_show(RoleId,Type,Career,HitNum,TurnStage,Lv) ->
    gen_server:cast({global, ?MODULE}, {shop_main_show,RoleId,Type,Career,HitNum,HitNum,TurnStage,Lv}).

%% 手动刷新
hit_refresh(RoleId,Type,Career,HitNum,TurnStage,Lv) ->
    gen_server:cast({global, ?MODULE}, {hit_refresh,RoleId,Type,Career,HitNum,TurnStage,Lv}).

%% 购买商品
buy_shop(RoleId,Type,Career,Id,Price) ->
    gen_server:call({global, ?MODULE}, {buy_shop,RoleId,Type,Career,Id,Price}, 3000).

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
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = lib_mystery_shop:init(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({buy_shop,RoleId,Type,Career,Id,Price}, _From, State) ->
    lib_mystery_shop:buy_shop(RoleId,Type,Career,Id,Price,State);
do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({login, RoleId, Career, Lv}, State)->
    lib_mystery_shop:login(RoleId, Career, Lv, State);
do_handle_cast({logout,RoleId},State)->
    lib_mystery_shop:logout(RoleId,State);
do_handle_cast({shop_main_show,RoleId,Type,Career,HitNum,HitNum,TurnStage,Lv},State)->
    lib_mystery_shop:shop_main_show(RoleId,Type,Career,HitNum,TurnStage,Lv,State);
do_handle_cast({hit_refresh,RoleId,Type,Career,HitNum,TurnStage,Lv},State) ->
    lib_mystery_shop:hit_refresh(RoleId,Type,Career,HitNum,TurnStage,Lv,State);
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({Type,Career,refresh_sell}, State) ->
    lib_mystery_shop:refresh_sell(Type,Career,State);
do_handle_info(_Info, State) -> {noreply, State}.



