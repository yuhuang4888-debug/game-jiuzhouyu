%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------
-module (mod_kf_sell).

-include ("common.hrl").
-include ("rec_sell.hrl").
-include("errcode.hrl").

%% API
-export([
    start_link/0
    , list_category_sell_num/3
    , list_sub_category_sell_goods/7
    , filter_goods/4
    , send_sell_up_view_info/4
    , check_sell_up_goods/5
    , sell_up/2
    , sell_down/6
    , send_on_sell_goods_list/2
    , send_specify_sell_list/1
    , pay_sell/9
    , send_sell_record/2
    , refresh/0
    , daily_timer/1
    , send_p2p_red_point/1
    , check_seek_goods/5
    , seek_goods/1
    , delete_seek/1
    , sell_seek_goods/11
    , send_self_seek_list/1
    , send_seek_list/1
    , show_state/0
    , reload/0
    , lock_refresh/1
    , handle_new_merge_server_ids/6
    , zone_change/2
    , center_connected/2
    , delete_sys_sell/0
    , get_replenish_goods/1
    , market_shout/1
]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).



center_connected(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {center_connected, ServerId, MergeSerIds}).

zone_change(_OldZone, _NewZone) ->
    reload().

handle_new_merge_server_ids(ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds) ->
    gen_server:cast(?MODULE, {handle_new_merge_server_ids, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds}).

list_category_sell_num(ServerId, PlayerId, Category) ->
    gen_server:cast(?MODULE, {list_category_sell_num, ServerId, PlayerId, Category}).

list_sub_category_sell_goods(ServerId, PlayerId, Category, SubCategory, Stage, Star, Color) ->
    gen_server:cast(?MODULE, {list_sub_category_sell_goods, ServerId, PlayerId, Category, SubCategory, Stage, Star, Color}).

filter_goods(Cmd, ServerId, PlayerId, Args) ->
    gen_server:cast(?MODULE, {filter_goods, Cmd, ServerId, PlayerId, Args}).

send_sell_up_view_info(ServerId, PlayerId, GoodsId, GTypeId) ->
    gen_server:cast(?MODULE, {send_sell_up_view_info, ServerId, PlayerId, GoodsId, GTypeId}).

check_sell_up_goods(SellType, ServerId, PlayerId, PlayerVipLv, SpecifyId) ->
    gen_server:call(?MODULE, {check_sell_up_goods, SellType, ServerId, PlayerId, PlayerVipLv, SpecifyId}, 1000). %% 设置超时时间为1s

sell_up(GoodsSell, IsShout) ->
    gen_server:call(?MODULE, {sell_up, GoodsSell, IsShout}, 1500).

sell_down(ServerId, PlayerId, SellType, Id, GTypeId, GoodsNum) ->
    gen_server:call(?MODULE, {sell_down, ServerId, PlayerId, SellType, Id, GTypeId, GoodsNum}, 1500).

send_on_sell_goods_list(ServerId, PlayerId) ->
    gen_server:cast(?MODULE, {send_on_sell_goods_list, ServerId, PlayerId}).

send_specify_sell_list(PlayerId) ->
    gen_server:cast(?MODULE, {send_specify_sell_list, PlayerId}).

pay_sell(ServerId, ServerNum, PlayerId, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice) ->
    gen_server:call(?MODULE, {pay_sell, ServerId, ServerNum,PlayerId, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice}, 1500).

send_sell_record(ServerId, PlayerId) ->
    gen_server:cast(?MODULE, {send_sell_record, ServerId, PlayerId}).

send_p2p_red_point(PlayerId) ->
    gen_server:cast(?MODULE, {send_p2p_red_point, PlayerId}).

refresh() ->
    gen_server:cast(?MODULE, refresh).

daily_timer(_Delay) ->
    gen_server:cast(?MODULE, daily_timer).


check_seek_goods(ServerId, PlayerId, PlayerVipLv, SellTimes, LimitTimes) ->
    gen_server:call(?MODULE, {check_seek_goods, ServerId, PlayerId, PlayerVipLv, SellTimes, LimitTimes}, 1000). %% 设置超时时间为1s

seek_goods(SeekGoods) ->
    gen_server:call(?MODULE, {seek_goods, SeekGoods}, 1500).

delete_seek({ServerId, PlayerId, Id}) ->
    gen_server:cast(?MODULE, {delete_seek, ServerId, PlayerId, Id}).

sell_seek_goods(ServerId, ServerNum, PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating) ->
    gen_server:call(?MODULE, {sell_seek_goods, ServerId, ServerNum,PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating}, 1500).

send_self_seek_list({ServerId, PlayerId, Cmd}) ->
    gen_server:cast(?MODULE, {send_self_seek_list, ServerId, PlayerId, Cmd}).

send_seek_list({ServerId, PlayerId, Cmd, PageNo, PageSize}) ->
    gen_server:cast(?MODULE, {send_seek_list, ServerId, PlayerId, Cmd, PageNo, PageSize}).

show_state() ->
    gen_server:cast(?MODULE, {show_state}).

reload() ->
    gen_server:cast(?MODULE, {reload}).

lock_refresh(IsLock) ->
    gen_server:call(?MODULE, {lock_refresh, IsLock}, 1500).

delete_sys_sell() ->    
    gen_server:cast(?MODULE, {delete_sys_sell}).

get_replenish_goods(TimeoutGoods) ->
    gen_server:cast(?MODULE, {get_replenish_goods, TimeoutGoods}).

%% 主动喊话
market_shout(Args) ->
    gen_server:cast(?MODULE, {market_shout, Args}).

%% ------------------------------------ %% -----------------------------------

do_init(_Args) ->
    State = lib_sell_mod_kf:init(),
    {ok, State}.

do_call({check_sell_up_goods, SellType, ServerId, PlayerId, PlayerVipLv, SpecifyId}, _From, State) ->
    Res = lib_sell_mod_kf:check_sell_up_goods(State, SellType, ServerId, PlayerId, PlayerVipLv, SpecifyId),
    {reply, Res, State};

do_call({sell_up, GoodsSell, IsShout}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:sell_up(State, GoodsSell, IsShout),
    {reply, Res, NewState};

do_call({sell_down, ServerId, PlayerId, SellType, Id, GTypeId, GoodsNum}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:sell_down(State, ServerId, PlayerId, SellType, Id, GTypeId, GoodsNum),
    {reply, Res, NewState};

do_call({pay_sell, ServerId, ServerNum, PlayerId, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:pay_sell(State, ServerId, ServerNum, PlayerId, SellType, Id, SellerId, GTypeId, GoodsNum, UnitPrice),
    {reply, Res, NewState};

do_call({check_seek_goods, ServerId, PlayerId, PlayerVipLv, SellTimes, LimitTimes}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:check_seek_goods(State, ServerId, PlayerId, PlayerVipLv, SellTimes, LimitTimes),
    {reply, Res, NewState};

do_call({seek_goods, SeekGoods}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:seek_goods(State, SeekGoods),
    {reply, Res, NewState};

do_call({sell_seek_goods, ServerId, ServerNum, PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating}, _From, State) ->
    {Res, NewState} = lib_sell_mod_kf:sell_seek_goods(State,  ServerId, ServerNum,PlayerId, VipType, VipLv, Id, BuyerId, GTypeId, GoodsNum, ExtraAttr, Rating),
    {reply, Res, NewState};

do_call({lock_refresh, IsLock}, _From, State) ->
    put({lock_refresh}, IsLock),
    {reply, ok, State};

do_call(_Request, _From, State) ->
    {reply, ok, State}.


do_cast({center_connected, ServerId, MergeSerIds}, State) ->
    #sell_state_kf{connect_servers = ConnectServers} = State,
    ConnectServersNew = [ServerId] ++ MergeSerIds ++ ConnectServers,
%%    ?MYLOG("cym", "ConnectServersNew~p~n", [ConnectServersNew]),
    StateNew = State#sell_state_kf{connect_servers = ConnectServersNew},
%%    ?MYLOG("cym", "StateNew~p~n", [StateNew]),
    {noreply, StateNew};



do_cast({handle_new_merge_server_ids, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds}, _State) ->
    StateNew = lib_sell_mod_kf:handle_new_merge_server_ids(_State, ServerId, ServerNum, ServerName,  WorldLv, Time, NewMergeSerIds),
    {noreply, StateNew};




do_cast({list_category_sell_num, ServerId, PlayerId, SellType}, State) ->
    NewState = lib_sell_mod_kf:list_category_sell_num(State, ServerId, PlayerId, SellType),
    {noreply, NewState};

do_cast({list_sub_category_sell_goods, ServerId, PlayerId, Category, SubCategory, Stage, Star, Color}, State) ->
    lib_sell_mod_kf:list_sub_category_sell_goods(State, ServerId, PlayerId, Category, SubCategory, Stage, Star, Color),
    {noreply, State};

do_cast({filter_goods, Cmd, ServerId, PlayerId, Args}, State) ->
    lib_sell_mod_kf:filter_goods(State, ServerId, PlayerId, Args, Cmd),
    {noreply, State};

do_cast({send_sell_up_view_info, ServerId, PlayerId, GoodsId, GTypeId}, State) ->
    lib_sell_mod_kf:send_sell_up_view_info(State, ServerId,PlayerId, GoodsId, GTypeId),
    {noreply, State};

do_cast({send_on_sell_goods_list, ServerId, PlayerId}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #sell_state_kf{
        zone_map = ZoneMap
    } = State,
    ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
    #sell_state_zone{
        player_market_sell_map = PlayerSellMap
    } = ZoneMsg,
    PlayerSellGoodsL = maps:get(PlayerId, PlayerSellMap, []),
    PackList = lib_sell_mod_kf:pack_sell_goods_list(PlayerSellGoodsL, ?PACK_TYPE_MARKET, []),
    {ok, Bin} = pt_151:write(15109, [PackList]),
    lib_sell_mod_kf:send_to_uid_kf(ServerId, PlayerId, Bin),
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15109, [PackList]),
    {noreply, State};

do_cast({send_specify_sell_list, PlayerId}, State) ->
    #sell_state{
        p2p_sell_map = P2PSellMap
    } = State,
    P2PSellList = maps:to_list(P2PSellMap),
    F = fun(T, [SelfGL, SpecifySelfGL]) ->
        case T of
            #sell_goods_kf{player_id = PlayerId} ->
                [[T|SelfGL], SpecifySelfGL];
            #sell_goods_kf{specify_id = PlayerId} ->
                [SelfGL, [T|SpecifySelfGL]];
            _ ->
                [SelfGL, SpecifySelfGL]
        end
    end,
    F1 = fun({_, List}, Acc) ->
        lists:foldl(F, Acc, List)
    end,
    [SelfSellL, SpecifySelfSellL] = lists:foldl(F1, [[], []], P2PSellList),
    PackList = lib_sell_mod_kf:pack_sell_goods_list(SelfSellL, ?PACK_TYPE_SELL_TO_OTHER, []),
    PackList1 = lib_sell_mod_kf:pack_sell_goods_list(SpecifySelfSellL, ?PACK_TYPE_SELL_TO_ME, []),
    lib_server_send:send_to_uid(PlayerId, pt_151, 15110, [PackList, PackList1]),
    {noreply, State};

do_cast({send_sell_record, ServerId, PlayerId}, State) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    #sell_state_kf{
        zone_map = ZoneMap
    } = State,
    ZoneMsg = maps:get(ZoneId, ZoneMap, #sell_state_zone{}),
    #sell_state_zone{
        sell_record_list = SellRecordList
    } = ZoneMsg,
    NowTime = utime:unixtime(),
    CleanTime = lib_sell_kf:get_record_expired_time(),
    F = fun(T, [Acc1, Acc2]) ->
        case T of
            #sell_record_kf{
                player_id = TmpSellerId,
                buyer_id = TmpBuyerId,
                time = TmpTime
            } when NowTime - TmpTime < CleanTime ->
                case TmpSellerId == PlayerId orelse TmpBuyerId == PlayerId of
                    true -> NewAcc1 = [T|Acc1];
                    false -> NewAcc1 = Acc1
                end,
                [NewAcc1, [T|Acc2]];
            _ -> [Acc1, Acc2]
        end
    end,
    [SelfRecordL, NewSellRecordL] = lists:foldl(F, [[], []], SellRecordList),
    
    PackList = lib_sell_mod_kf:pack_sell_record_list(SelfRecordL, PlayerId, []),
    ?PRINT("++++++++++++++++ZoneMap ~p ~n", [ZoneMap]),
    ?PRINT("++++++++++++++++SellRecordList ~p ~n", [SellRecordList]),
    ?PRINT("++++++++++++++++ ~p ~n", [PackList]),
    {ok, Bin} = pt_151:write(15112, [PackList]),
    lib_sell_mod_kf:send_to_uid_kf(ServerId, PlayerId, Bin),
%%    lib_server_send:send_to_uid(PlayerId, pt_151, 15112, [PackList]),
    ZoneMsgNew = ZoneMsg#sell_state_zone{sell_record_list = NewSellRecordL},
    ZoneMapNew = maps:put(ZoneId, ZoneMsgNew, ZoneMap),
    {noreply, State#sell_state_kf{zone_map = ZoneMapNew}};

do_cast({send_p2p_red_point, PlayerId}, State) ->
    #sell_state{
        p2p_sell_map = P2PSellMap
    } = State,
    P2PSellList = maps:values(P2PSellMap),
    case lib_sell_check:check_anyone_sell2me(P2PSellList, PlayerId) of
        true -> Result = 1;
        _ -> Result = 0
    end,
    lib_server_send:send_to_uid(PlayerId, pt_151, 15113, [Result]),
    {noreply, State};

do_cast(refresh, State) ->
    case get({lock_refresh}) of 
        true -> NewState = State;
        _ ->
            NewState = lib_sell_mod_kf:auto_sell_down(State)
    end,
    {noreply, NewState};



do_cast(daily_timer, State) ->
    NewState = lib_sell_mod_kf:daily_timer(State),
    {noreply, NewState};

do_cast(stop, State) ->
    {stop, normal, State};

do_cast({delete_seek, ServerId, PlayerId, Id}, State) ->
    NewState = lib_sell_mod_kf:delete_seek(State, ServerId, PlayerId, Id),
    {noreply, NewState};

do_cast({send_self_seek_list, ServerId, PlayerId, Cmd}, State) ->
    lib_sell_mod_kf:send_self_seek_list(State, ServerId, PlayerId, Cmd),
    {noreply, State};

do_cast({send_seek_list, ServerId, PlayerId, Cmd, PageNo, PageSize}, State) ->
    lib_sell_mod_kf:send_seek_list(State, ServerId, PlayerId, Cmd, PageNo, PageSize),
    {noreply, State};

do_cast({show_state}, State) ->
    ?PRINT("show state ~p~n", [State]),
    {noreply, State};

do_cast({reload}, _State) ->
    erase(),
    #sell_state_kf{connect_servers = ConnectServerIds} = _State,
    NewState = lib_sell_mod_kf:init(ConnectServerIds),
    ?PRINT("reload ================== succ ~n", []),
    {noreply, NewState};

do_cast({delete_sys_sell}, State) ->
    #sell_state_kf{zone_map = ZoneMap} = State,
    F = fun(T) -> T#sell_goods_kf.player_id == 0 end,
    F1 = fun(SubCategory, SubCategoryList, {SubSellMap, Acc}) ->
        {DelList, NewSubCategoryList} = lists:partition(F, SubCategoryList),
        NewSubSellMap = maps:put(SubCategory, NewSubCategoryList, SubSellMap),
        {NewSubSellMap, [Id || #sell_goods_kf{id = Id} <- DelList]++Acc}
    end,
    F2 = fun(Category, CategorySellMap, {SellMap, Acc}) ->
        {NewCategorySellMap, NewAcc} = maps:fold(F1, {#{}, Acc}, CategorySellMap),
        NewSellMap = maps:put(Category, NewCategorySellMap, SellMap),
        {NewSellMap, NewAcc}
    end,
    F3 = fun(ZoneId, ZoneMsg, {Map, Acc}) ->
        #sell_state_zone{market_sell_map = MarketSellMap, player_market_sell_map = PlayerMarketSellMap} = ZoneMsg,
        NewPlayerMarketSellMap = maps:remove(0, PlayerMarketSellMap),
        {NewMarketSellMap, NewAcc} = maps:fold(F2, {#{}, Acc}, MarketSellMap),
        NewZoneMsg = ZoneMsg#sell_state_zone{market_sell_map = NewMarketSellMap, player_market_sell_map = NewPlayerMarketSellMap, category_change = #{}},
        {maps:put(ZoneId, NewZoneMsg, Map), NewAcc}
    end,
    {NewZoneMap, DelIdList} = maps:fold(F3, {#{}, []}, ZoneMap),
    %?PRINT("kf#delete_sys_sell DelIdList:~p~n", [DelIdList]),
    case DelIdList =/= [] of 
        true ->
            Args = util:link_list(DelIdList),
            catch db:execute(io_lib:format(?sql_sell_delete_more_kf, [Args]));
        _ ->
            ok
    end,
    NewState = State#sell_state_kf{zone_map = NewZoneMap},
    {noreply, NewState};

do_cast({get_replenish_goods, TimeoutGoods}, State) ->
    #sell_state_kf{
        zone_map = ZoneMap
    } = State,
    F1 = fun(_SubCategory, SubCategoryList, {ZoneId, Acc}) ->
        List = [{GoodsId, 1} || #sell_goods_kf{player_id = 0, gtype_id = GoodsId} <- SubCategoryList, lists:member({ZoneId, GoodsId}, TimeoutGoods)],
        case List of 
            [_|_] -> 
                {ZoneId, ulists:kv_list_plus_extra([[], List]) ++ Acc};
            _ -> {ZoneId, Acc}
        end
    end,
    F2 = fun(_Category, CategorySellMap, {ZoneId, Acc}) ->
        {_, NewAcc} = maps:fold(F1, {ZoneId, Acc}, CategorySellMap),
        {ZoneId, NewAcc}
    end,
    F3 = fun(ZoneId, ZoneMsg, Acc) ->
        #sell_state_zone{market_sell_map = MarketSellMap} = ZoneMsg,
        case lists:keymember(ZoneId, 1, TimeoutGoods) of 
            true ->
                {_, List} = maps:fold(F2, {ZoneId, []}, MarketSellMap),
                [{ZoneId, List}|Acc];
            _ ->
                Acc
        end
    end,
    ReplenishList = maps:fold(F3, [], ZoneMap),
    %% 合并
    F4 = fun({ZoneId, GoodsId}, List) ->
        case lists:keyfind(ZoneId, 1, List) of 
            {_, GoodsList} ->
                case lists:keymember(GoodsId, 1, GoodsList) of 
                    true -> List; _ -> lists:keyreplace(ZoneId, 1, List, {ZoneId, [{GoodsId, 0}|GoodsList]})
                end;
            _ ->
                [{ZoneId, [{GoodsId, 0}]}|List]
        end
    end,
    NewReplenishList = lists:foldl(F4, ReplenishList, TimeoutGoods),
    %?PRINT("kf#get_replenish_goods NewReplenishList:~p~n", [NewReplenishList]),
    mod_sys_sell:replenish_goods(NewReplenishList),
    {noreply, State};

do_cast({market_shout, Args}, State) ->
    lib_sell_mod_kf:market_shout(Args, State),
    {noreply, State};

do_cast(_Msg, State) ->
    {noreply, State}.

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

