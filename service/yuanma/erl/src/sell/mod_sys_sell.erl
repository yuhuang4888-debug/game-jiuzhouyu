%% ---------------------------------------------------------------------------
%% @doc 系统交易
%% @author lxl
%% @since  2020-08-28
%% @deprecated
%% ---------------------------------------------------------------------------
-module (mod_sys_sell).

-include ("common.hrl").
-include ("rec_sell.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("def_module.hrl").

%% API
-export([
    start_link/0
    , daily_timer/0
    , replenish_goods/1
    , get_zones_ck/3
    , gm_refresh_sys_goods/0
    , open_kf_sell/0
]).

%% 
-record(sys_sell_state, {
    is_cls = false
    , open_zone = []    %% 开启的区域，每天4点更新一次
    , ref_goods_list = []  %% [{{zoneid,goods_id},time}]
    , ref = undefined 
}).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

daily_timer() ->
    case util:is_cls() of 
        true ->
            mod_zone_mgr:common_get_info(?MODULE, get_zones_ck, []);
        _ ->
            gen_server:cast(?MODULE, daily_timer)
    end.

replenish_goods(List) ->
    gen_server:cast(?MODULE, {replenish_goods, List}).
    
get_zones_ck(ServerInfo, _Z2SMap, _A) ->
    gen_server:cast(?MODULE, {get_zones_ck, ServerInfo}).

open_kf_sell() ->
    gen_server:cast(?MODULE, open_kf_sell).

gm_refresh_sys_goods() ->
    gen_server:cast(?MODULE, gm_refresh_sys_goods).

%% ------------------------------------ %% -----------------------------------

do_init(_Args) ->
    State = #sys_sell_state{
        is_cls = util:is_cls()
    },
    case State#sys_sell_state.is_cls of 
        true ->
            mod_zone_mgr:common_get_info(?MODULE, get_zones_ck, []),
            NewState = State;
        _ ->
            case mod_global_counter:get_count(?MOD_SELL, 1) > 0 of 
                true -> %% 已开启跨服市场
                    NewState = State#sys_sell_state{open_zone = []};
                _ -> 
                    State1 = State#sys_sell_state{open_zone = [{0, config:get_server_id(), util:get_open_day()}]},
                    NewState = calc_ref(State1)
            end
            
    end,
    {ok, NewState}.


do_cast({get_zones_ck, ServerInfo}, State) ->
    NowTime = utime:unixtime(),
    F = fun({ServerId, Optime, WorldLv, _ServerNum, _ServerName}, List) ->
        OpenDay = utime:diff_days(NowTime, Optime) + 1,
        case OpenDay >= data_sell:get_cfg(kf_open_day_max) orelse 
            (OpenDay >= data_sell:get_cfg(kf_open_day_min) andalso WorldLv >= data_sell:get_cfg(kf_open_lv)) 
        of 
            true -> 
                case lib_clusters_center_api:get_zone(ServerId) of 
                    ZoneId when ZoneId > 0 ->
                        {ZoneId, OldServerId, OldOpenDay} = ulists:keyfind(ZoneId, 1, List, {ZoneId, 0, 0}), 
                        {NewServerId, NewOpenDay} = ?IF(OpenDay > OldOpenDay, {ServerId, OpenDay}, {OldServerId, OldOpenDay}),
                        lists:keystore(ZoneId, 1, List, {ZoneId, NewServerId, NewOpenDay});
                    _ -> List
                end;
            _ -> List
        end
    end,
    OpenZone = lists:foldl(F, [], ServerInfo),
    %?PRINT("get_zones_ck# OpenZone:~p~n", [OpenZone]),
    NewState = State#sys_sell_state{open_zone = OpenZone},
    case utime:unixtime_to_localtime(NowTime) of 
        {_, {?FOUR, _, _}} ->
            NewState1 = refresh_sell_goods(NewState),
            LastState = calc_ref(NewState1);
        _ ->
            LastState = calc_ref(NewState)
    end,
    {noreply, LastState};

do_cast(gm_refresh_sys_goods, State) ->
    NewState1 = refresh_sell_goods(State),
    LastState = calc_ref(NewState1),
    {noreply, LastState};

do_cast(open_kf_sell, State) ->
    mod_sell:delete_sys_sell(),
    util:cancel_timer(State#sys_sell_state.ref),
    LastState = State#sys_sell_state{open_zone = []},
    {noreply, LastState};

do_cast(daily_timer, State) ->
    case State#sys_sell_state.is_cls of 
        true -> LastState = State;
        _ ->
            case mod_global_counter:get_count(?MOD_SELL, 1) > 0 of 
                true -> %% 已开启跨服市场
                    LastState = State#sys_sell_state{open_zone = []};
                _ -> 
                    NewState = State#sys_sell_state{open_zone = [{0, config:get_server_id(), util:get_open_day()}]},
                    NewState1 = refresh_sell_goods(NewState),
                    LastState = calc_ref(NewState1)
            end
    end,
    {noreply, LastState};

do_cast({replenish_goods, ReplenishList}, State) ->
    #sys_sell_state{
        is_cls = IsCls
        , open_zone = OpenZone
    } = State,
    F2 = fun({GoodsId, Num}, {ServerId, OpenDay, List}) ->
        case data_sys_sell:get_sys_sell(GoodsId, OpenDay) of 
            #base_sys_sell{group_num = GroupNum} = SysSell when Num < GroupNum ->
                {ServerId, OpenDay, calc_sell_goods(SysSell, ServerId, GroupNum-Num) ++ List};
            _ -> {ServerId, OpenDay, List}
        end
    end,
    F = fun({ZoneId, GoodsList}, List) ->
        case lists:keyfind(ZoneId, 1, OpenZone) of 
            {_, ServerId, OpenDay} ->
                {_, _, NewList} = lists:foldl(F2, {ServerId, OpenDay, List}, GoodsList),
                NewList;
            _ -> List
        end
    end,
    SellGoodsList = lists:foldl(F, [], ReplenishList),
    %?PRINT("replenish_goods# ReplenishList:~p~n", [ReplenishList]),
    %?PRINT("replenish_goods# SellGoodsList:~p~n", [SellGoodsList]),
    SellGoodsList =/= [] andalso spawn(fun() -> refresh_sell_goods_do(IsCls, SellGoodsList) end),
    {noreply, State};


do_cast(_Msg, State) ->
    {noreply, State}.

do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_info('replenish', State) ->
    #sys_sell_state{
        is_cls = IsCls
        , ref_goods_list = RefGoodsList 
    } = State,
    NowTime = utime:unixtime(),
    F = fun({_, Time}) -> NowTime >= Time end,
    {TimeoutGoods, NewRefGoodsList} = lists:partition(F, RefGoodsList),
    %?PRINT("replenish# TimeoutGoods:~p~n", [TimeoutGoods]),
    handle_replenish_goods(IsCls, TimeoutGoods),
    NewState = State#sys_sell_state{ref_goods_list = NewRefGoodsList},
    LastState = calc_ref(NewState),
    {noreply, LastState};

do_info(_Info, State) ->
    {noreply, State}.

init(Args) ->
    case catch do_init(Args) of
        {'EXIT', Reason} ->
            ?ERR("init error:~p~n", [Reason]),
            {stop, Reason};
        {ok, State} ->
            {ok, State};
        Other ->
            {stop, Other}
    end.

handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


refresh_sell_goods(State) ->
    #sys_sell_state{
        is_cls = IsCls
        ,  open_zone = OpenZone
    } = State,
    case IsCls of 
        false ->
            mod_sell:delete_sys_sell();
        _ ->
            mod_kf_sell:delete_sys_sell()
    end,
    SellGoodsList = lists:flatten([calc_sys_goods_list(ServerId, OpenDay) || {_ZoneId, ServerId, OpenDay} <- OpenZone]),
    %?PRINT("refresh_sell_goods# SellGoodsList:~p~n", [SellGoodsList]),
    SellGoodsList =/= [] andalso spawn(fun() -> refresh_sell_goods_do(IsCls, SellGoodsList) end),
    State.

refresh_sell_goods_do(IsCls, SellGoodsList) ->
    NowTime = utime:unixtime(),
    F = fun({GoodsId, ServerId, GoodsNum, Price}) ->
        case data_goods_type:get(GoodsId) of 
            #ets_goods_type{sell_category = SellCategory, sell_subcategory = SellSubCategory} = GoodsTypeInfo ->
                GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
                GoodsOther = lib_goods:new_goods_other(GoodsInfo),
                NewGoodsInfo = GoodsInfo#goods{other = GoodsOther},
                case IsCls of 
                    true ->
                        SellGoods = make_sell_kf(GoodsId, ServerId, GoodsNum, Price, SellCategory, SellSubCategory, NowTime, NewGoodsInfo),
                        catch mod_kf_sell:sell_up(SellGoods, false);
                    _ ->
                        SellGoods = make_sell(GoodsId, ServerId, GoodsNum, Price, SellCategory, SellSubCategory, NowTime, NewGoodsInfo),
                        catch mod_sell:sell_up(SellGoods, false)
                end,
                timer:sleep(200),
                ok;
            _ ->
                ok
        end
    end,
    lists:foreach(F, SellGoodsList).

calc_ref(State) ->
    #sys_sell_state{
        is_cls = _IsCls
        , open_zone = OpenZone
        , ref_goods_list = RefGoodsList 
        , ref = Ref
    } = State,
    NowTime = utime:unixtime(),
    F = fun({ZoneId, _ServerId, OpenDay}, List) ->
        calc_ref_goods_list(List, ZoneId, OpenDay, NowTime)
    end,
    NewRefGoodsList = lists:foldl(F, RefGoodsList, OpenZone),
    case NewRefGoodsList of 
        [] -> NewRef = Ref;
        _ ->
            Timeout = lists:min([ExpireTime||{_, ExpireTime} <- NewRefGoodsList]),
            %?PRINT("calc_ref# Timeout:~p~n", [Timeout]),
            NewRef = util:send_after(Ref, max(100, (Timeout-NowTime)*1000), self(), 'replenish')
    end,
    NewState = State#sys_sell_state{ref_goods_list = NewRefGoodsList, ref = NewRef},
    NewState.

handle_replenish_goods(_IsCls, []) -> ok;
handle_replenish_goods(IsCls, TimeoutGoods) ->
    TimeoutGoodsList = [{ZoneId, GoodsId} || {{ZoneId, GoodsId}, _} <- TimeoutGoods],
    case IsCls of 
        false ->
            mod_sell:get_replenish_goods(TimeoutGoodsList);
        _ ->
            mod_kf_sell:get_replenish_goods(TimeoutGoodsList)
    end.

calc_ref_goods_list(RefGoodsList, ZoneId, OpenDay, NowTime) ->
    IdList = get_sys_sell_by_openday(OpenDay),
    F = fun(Id, List) ->
        case data_sys_sell:get_sys_sell(Id, OpenDay) of 
            #base_sys_sell{goods_id = GoodsId, replenish = ReplenishTime} ->
                [{{ZoneId, GoodsId}, NowTime+ReplenishTime}|lists:keydelete({ZoneId, GoodsId}, 1, List)];
            _ ->    
                List
        end
    end,
    lists:foldl(F, RefGoodsList, IdList).

calc_sys_goods_list(ServerId, OpenDay) ->
    IdList = get_sys_sell_by_openday(OpenDay),
    F = fun(Id, List) ->
        case data_sys_sell:get_sys_sell(Id, OpenDay) of 
            #base_sys_sell{group_num = GroupNum} = SysSell ->
                SellGoodsList = calc_sell_goods(SysSell, ServerId, GroupNum),
                SellGoodsList ++ List;
            _ ->    
                List
        end
    end,
    lists:foldl(F, [], IdList).

calc_sell_goods(SysSell, ServerId, GroupNum) ->
    #base_sys_sell{
        goods_id = GoodsId
        , price = UnitPrice
        , num = GoodsNumRange
    } = SysSell,
    case GoodsNumRange of 
        [{NumMin, NumMax}] when NumMin < NumMax ->
            F = fun(_I, List) ->
                GoodsNum = urand:rand(NumMin, NumMax),
                Price = UnitPrice*GoodsNum,
                [{GoodsId, ServerId, GoodsNum, Price}|List]
            end,
            lists:foldl(F, [], lists:seq(1, GroupNum));
        _ ->
            []
    end.

get_sys_sell_by_openday(OpenDay) ->
    List = data_sys_sell:get_sys_sell_by_openday(),
    [Id ||{Id, OpenDay1, OpenDay2} <- List, OpenDay>=OpenDay1, OpenDay=<OpenDay2].

make_sell_kf(GoodsId, ServerId, GoodsNum, Price, Category, SubCategory, NowTime, GoodsInfo) ->
    #sell_goods_kf{
        server_id = ServerId,
        server_num = 0,
        player_id = 0,
        sell_type = ?SELL_TYPE_MARKET,
        gtype_id = GoodsId,
        category = Category,
        sub_category = SubCategory,
        goods_num = GoodsNum,
        unit_price = Price,
        other = GoodsInfo#goods.other,
        time = NowTime
    }.

make_sell(GoodsId, _ServerId, GoodsNum, Price, Category, SubCategory, NowTime, GoodsInfo) ->
    #sell_goods{
        player_id       = 0,
        sell_type       = ?SELL_TYPE_MARKET,
        gtype_id        = GoodsId,
        category        = Category,
        sub_category    = SubCategory,
        goods_num       = GoodsNum,
        unit_price      = Price,
        other           = GoodsInfo#goods.other,
        time            = NowTime
    }.

