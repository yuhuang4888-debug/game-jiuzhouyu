%%%-----------------------------------
%%% @Module  : mod_kf_1vN_auction
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 拍卖管理进程
%%%-----------------------------------
-module(mod_kf_1vN_auction).

-include("common.hrl").
-include("kf_1vN.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("vip.hrl").

%% API
-export([auction_start/1, auction_end/0]).
-export([start_link/0, get_info/2, get_rank/3, is_can_auction/0, price_add/1, follow/3, get_past_list/2, sync_auction_state/2]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(state, {
        issue=0,
        stage=0,
        auction_list=[],
        follow_list=[],
        ref = undefined,
        optime = 0,
        edtime = 0,
        past_list=[]
    }).

-record(auction, {
        id=0,
        result=0,
        last_price=0,
        goods = [],
        cost = [],
        bidders = [],   %% [#bidder{}, ...]
        rank = [],      %% [#bidder{}, ...]
        min_rank_price = 0

    }).

-record(bidder, {
        id=0,           %% 玩家id
        server_id=0,    %% 服id
        server_num=0,   %% 服数
        name = "",      %% 玩家名字
        price = 0,      %% 玩家拍卖价格（包含代金卷）
        voucher = 0,     %% 代金卷数量
        payment_refs = [] %% 预付款单据引用
    }).

-record(past_auction, {
        issue=1, 
        server_num=0, 
        name="", 
        price=0, 
        goods=[]
    }).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

auction_start(Time) -> 
    gen_server:cast(?MODULE, {auction_start, Time}).

auction_end() -> 
     erlang:send(?MODULE, auction_end).

get_info(Node, Id) -> 
    gen_server:cast(?MODULE, {get_info, Node, Id}).

get_rank(Node, Id, AuctionId) -> 
    gen_server:cast(?MODULE, {get_rank, Node, Id, AuctionId}).

is_can_auction() -> 
    gen_server:call(?MODULE, is_can_auction).

price_add([Node, SerId, SerNum, Id, Name, AuctionId, PriceAdd, VoucherAdd, Ref]) ->
    gen_server:call(?MODULE, {price_add, Node, SerId, SerNum, Id, Name, AuctionId, PriceAdd, VoucherAdd, Ref}).

follow(SerId, Id, Follow) -> 
    gen_server:cast(?MODULE, {follow, SerId, Id, Follow}).

get_past_list(Node, Id) -> 
    gen_server:cast(?MODULE, {get_past_list, Node, Id}).

sync_auction_state(Node, Brocast) -> 
    gen_server:cast(?MODULE, {sync_auction_state, Node, Brocast}).

init([]) ->
    State = init_state(),
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply, State1} ->
            {reply, Reply, State1};
        {false, Reply} -> 
            {reply, Reply, State};
        Err ->
            ?ERR("Handle call[~p] error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(is_can_auction, State) -> 
    {ok, State#state.stage==1, State};

%% 加价
do_handle_call({price_add, Node, SerId, SerNum, Id, Name, AuctionId, PriceAdd, VoucherAdd, Ref}, State) ->
    #state{stage=Stage, auction_list=AuctionList, follow_list=FollowList} = State,
    Result = case Stage of
        1 -> 
%%            ?PRINT("price_add ~p~n", [{Id, PriceAdd, VoucherAdd}]),
            case lists:keyfind(AuctionId, #auction.id, AuctionList) of
                #auction{bidders=Bidders, rank=Rank, min_rank_price=MinRankPrice} = Auction-> 
                    case lists:keyfind(Id, #bidder.id, Bidders) of
                        #bidder{price=OldPrice, voucher=OldVoucher, payment_refs = Refs} = OldBidder ->
                            Bidder = OldBidder#bidder{id=Id, server_id=SerId, server_num=SerNum, name=Name, price=OldPrice+PriceAdd, voucher=OldVoucher+VoucherAdd, payment_refs = [Ref|Refs]},
                            Bidders1 = lists:keyreplace(Id, #bidder.id, Bidders, Bidder);
                        _ -> 
                            Bidder = #bidder{id=Id, server_id=SerId, server_num=SerNum, name=Name, price=PriceAdd, voucher=VoucherAdd, payment_refs = [Ref]},
                            Bidders1 = [Bidder|Bidders]
                    end,
                    {ShortRank, NewMinRankPrice} = case Bidder#bidder.price > MinRankPrice of
                        true  -> 
                            Rank1 = lists:reverse(lists:keysort(#bidder.price, [Bidder|lists:keydelete(Id, #bidder.id, Rank)])),
                            case Rank1 of
                                [#bidder{id = Id}, #bidder{id = LastNo1}|_] ->
                                    case Rank of
                                        [#bidder{id = LastNo1, server_id = ServerId}|_] -> %% 给被顶替者发邮件
                                            Title = utext:get(333),
                                            Content = utext:get(334),
                                            mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[LastNo1], Title, Content, []]);
                                        _ ->
                                            ok
                                    end;
                                _ ->
                                    ok
                            end,
                            case length(Rank1) >= 10 of
                                true  ->
                                    #bidder{price=MinRankPrice1} = lists:last(Rank1),
                                    {lists:sublist(Rank1, 10), MinRankPrice1};
                                false -> {Rank1, MinRankPrice}
                            end;
                        false -> {Rank, MinRankPrice}
                    end,
                    AuctionList1 = lists:keyreplace(AuctionId, #auction.id, AuctionList, Auction#auction{bidders=Bidders1, rank=ShortRank, min_rank_price=NewMinRankPrice}),
                    db_save_bidder(AuctionId, Bidder),
                    {ok, BinData} = pt_621:write(62126, [?SUCCESS]),
                    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
                    {ok, BinData1} = pt_621:write(62125, [AuctionId, get_rank_send(ShortRank)]),
                    send_to_follow(FollowList, BinData1),
                    lib_log_api:log_kf_1vn_auction(AuctionId, Id, SerId, SerNum, Name, PriceAdd, Bidder#bidder.price, VoucherAdd),
                    {true, State#state{auction_list=AuctionList1}};
                _ -> false
            end;
        _ -> false
    end,
    case Result of
        {true, State1} -> {ok, true, State1};
        false -> {false, false}
    end;

do_handle_call(_Request, _State) ->
    ?ERR("do_handle_call unkown request[~p]~n", [_Request]),
    {ok, ok}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle cast[~p] error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 拍卖开始
do_handle_cast({auction_start, Time}, State) -> 
    #state{issue=OldIssue, past_list=PastList} = State,
    Ids = data_kf_1vN:get_auction_ids(),
    F = fun(Id) -> 
            #kf_1vN_auction_cfg{goods=Goods, cost=Cost} = data_kf_1vN:get_auction_info(Id),
            #auction{id=Id, goods=Goods, cost=Cost, result=1}
    end,
    AuctionList = lists:map(F, Ids),
    Ref = erlang:send_after(Time*1000, self(), auction_end),
    Now = utime:unixtime(),
    db_save_issue(OldIssue+1, Now, Now+Time),
    db_clean_bidder_rank(),
    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, sync_auction_state, [[1, Now+Time, 1]]),
    {noreply, #state{issue=OldIssue+1, stage=1, auction_list=AuctionList, ref=Ref, edtime=utime:unixtime()+Time, past_list=PastList}};

%% 获取拍卖信息
do_handle_cast({get_info, Node, Id}, State) -> 
    #state{auction_list=AuctionList, edtime=EdTime} = State,
    F = fun(Auction) -> 
            #auction{id=AuctionId, result=Result, last_price=LastPrice, bidders=Bidders} = Auction,
            case lists:keyfind(Id, #bidder.id, Bidders) of
                #bidder{price=Price} -> ok;
                _ -> Price = 0
            end,
            {AuctionId, Result, LastPrice, Price}
    end,
    AuctionListSend = lists:map(F, AuctionList),
%%    ?PRINT(" AuctionListSend ~w~n", [AuctionListSend]),
    {ok, BinData} = pt_621:write(62124, [AuctionListSend, EdTime]),
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
    {noreply, State};

%% 获取拍卖排行榜
do_handle_cast({get_rank, Node, Id, AuctionId}, State) -> 
    #state{auction_list=AuctionList} = State,
    Rank = case lists:keyfind(AuctionId, #auction.id, AuctionList) of
        #auction{rank = TmpRank} -> TmpRank;
        _ -> []
    end,
    RankSend = get_rank_send(Rank), 
    {ok, BinData} = pt_621:write(62125, [AuctionId, RankSend]),
%%    ?PRINT(" RankSend ~w~n", [RankSend]),
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
    {noreply, State};

%% 获取拍卖排行榜
do_handle_cast({get_past_list, Node, Id}, State) -> 
    #state{past_list=PassList} = State,
%%    ?PRINT("get_past_list ~p~n", [PassList]),
    PastListSend = [{Issue, SerNum, Name, Goods, Price} || #past_auction{issue=Issue, server_num=SerNum, name=Name, price=Price, goods=Goods} <- PassList],
    {ok, BinData} = pt_621:write(62128, [PastListSend]),
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
    {noreply, State};


%% 关注拍卖变化
do_handle_cast({follow, SerId, Id, Follow}, State) -> 
     #state{follow_list=FollowList} = State,
     FollowList1 = case Follow of
         0 -> lists:keydelete(Id, 2, FollowList);
         1 -> lists:keystore(Id, 2, FollowList, {SerId, Id})
     end,
     {noreply, State#state{follow_list=FollowList1}};

do_handle_cast({sync_auction_state, Node, Broadcast}, State) -> 
    #state{stage=Stage, edtime=EdTime} = State,
    mod_clusters_center:apply_cast(Node, mod_kf_1vN_local, sync_auction_state, [[Stage, EdTime, Broadcast]]),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?ERR("do_handle_cast unkown msg[~p]~n", [_Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, Reason, NewState} -> 
            {stop, Reason, NewState};
        Err ->
            ?ERR("Handle info[~p] error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% 拍卖时间结束
do_handle_info(auction_end, State) ->
    #state{ref=Ref, issue=Issue, auction_list=AuctionList, past_list=PastList} = State,
    util:cancel_timer(Ref),
    SerAllTitle = utext:get(327),
    MinLv = data_kf_1vN:get_value(?KF_1VN_CFG_AUCTION_MIN_LV),
    
    F = fun(Auction, [TmpAuctionList, TmpPastList]) -> 
            #auction{id=AuctionId, goods=Goods, bidders=Bidders, rank=Rank} = Auction,
            case Rank of
                [#bidder{server_id=SerId, server_num=SerNum, name=Name, id=Id, price=Price, payment_refs = Refs}|_] ->
                    GoodsStr = util:make_goods_str(Goods),
                    mod_clusters_center:apply_cast(SerId, lib_kf_1vN, auction_success, [Id, Goods, Refs]),
                    return_gold_and_goods(lists:keydelete(Id, #bidder.id, Bidders), GoodsStr),

                    SerAllContent = utext:get(328, [Name, GoodsStr]),
                    #kf_1vN_auction_cfg{ser_award = SerAllAward} = data_kf_1vN:get_auction_info(AuctionId),
                    mod_clusters_center:apply_cast(SerId, lib_mail_api, send_sys_mail_to_all, [SerAllTitle, SerAllContent, util:term_to_string(SerAllAward), <<>>, MinLv, 0]),
                    db_save_bidder_rank(Rank, AuctionId, Issue),
                    db_save_past_auction(Issue, SerNum, Name, Price, Goods),
                    PastAuction=#past_auction{issue=Issue, server_num=SerNum, name=Name, price=Price, goods=Goods},
                    [[Auction#auction{result=2, bidders=[], last_price=Price}|TmpAuctionList], [PastAuction | TmpPastList]]; 
                _ -> 
                    [[Auction#auction{result=2, bidders=[]}|TmpAuctionList], TmpPastList]
            end
    end,
    [AuctionList1, PastList1] = lists:foldl(F, [[], PastList], AuctionList),
    db_clean_bidder(),
    db_clean_past_auction(Issue-10),
    F1 = fun(#past_auction{issue=EIssue}) ->
            EIssue < Issue - 10
    end,
    {_, PastList2} = lists:partition(F1, PastList1),
    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, sync_auction_state, [[0, 0, 1]]),
    {noreply, #state{issue=Issue, stage=0, auction_list=lists:reverse(AuctionList1), past_list=PastList2}};

do_handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~p]~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


init_state() -> 
    Now = utime:unixtime(),
    Ids = data_kf_1vN:get_auction_ids(),
    PastList = db_get_past_auction(),
    case db:get_all(<<"select issue, optime, edtime from kf_1vn_auction limit 1">>) of
        [[Issue, OpTime, EdTime]|_] when EdTime > Now -> 

            F = fun(Id) -> 
                    #kf_1vN_auction_cfg{goods=Goods, cost=Cost} = data_kf_1vN:get_auction_info(Id),
                    {Bidders, Rank} = db_get_bidders(Id),
                    #auction{id=Id, goods=Goods, cost=Cost, result=1, bidders=Bidders, rank=Rank}
            end,
            AuctionList = lists:map(F, Ids),
            Ref = erlang:send_after((EdTime-Now)*1000, self(), auction_end),
            #state{issue=Issue, optime=OpTime, edtime=EdTime, stage=1, auction_list=AuctionList, past_list=PastList, ref=Ref};
        Other -> 
            Issue1 = case Other of
                [[Issue, _, _]|_] -> Issue;
                _ -> 1
            end,
            F = fun(Id) -> 
                    #kf_1vN_auction_cfg{goods=Goods, cost=Cost} = data_kf_1vN:get_auction_info(Id),
                    {Rank, LastPrice} = db_get_bidder_rank(Id),
                    #auction{id=Id, goods=Goods, cost=Cost, result=2, rank=Rank, last_price=LastPrice}
            end,
            AuctionList = lists:map(F, Ids),
            #state{issue=Issue1, optime=Now, edtime=Now, stage=0, auction_list=AuctionList, past_list=PastList}
    end.

get_rank_send(Rank) -> 
    [{BSerNum, BName, BPrice} || #bidder{server_num=BSerNum, name=BName, price=BPrice} <- Rank].

send_to_follow([{SerId, Id}|T], BinData) -> 
    mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]),
    send_to_follow(T, BinData);
send_to_follow([], _BinData) -> ok.

return_gold_and_goods([#bidder{server_id=SerId, id=Id, payment_refs = Refs}|T], GoodsStr) ->
%%    ReturnGoods = case Price - Voucher of
%%        GoldNum when GoldNum =< 0 -> [{?TYPE_GOODS, VoucherId, Voucher}];
%%        GoldNum ->  [{?TYPE_GOODS, VoucherId, Voucher}, {?TYPE_GOLD, 0, GoldNum}]
%%    end,
%%    mod_clusters_center:apply_cast(SerId, lib_mail_api, send_sys_mail, [[Id], LoseTitle, LoseContent, ReturnGoods]),
    mod_clusters_center:apply_cast(SerId, lib_kf_1vN, auction_lose, [Id, GoodsStr, Refs]),
    return_gold_and_goods(T, GoodsStr);
return_gold_and_goods([], _) -> ok.

db_get_bidders(AuctionId) -> 
    L = db:get_all(io_lib:format(<<"select id,server_id, server_num, name, price, voucher, payment_refs from kf_1vn_bidder where auction_id=~w order by price desc, time asc">>, [AuctionId])),
    F = fun([Id, SerId, SerNum, Name, Price, Voucher, RefsStr]) ->
            #bidder{id=Id, server_id=SerId, server_num=SerNum, name=Name, price=Price, voucher=Voucher, payment_refs = util:bitstring_to_term(RefsStr)}
    end,
    Bidders = lists:map(F, L),
    {Bidders, lists:sublist(Bidders, 10)}.

db_save_bidder(AuctionId, Bidder) -> 
    #bidder{id=Id, server_id=SerId, server_num=SerNum, name=Name, price=Price, voucher=Voucher, payment_refs = Refs} = Bidder,
    db:execute(io_lib:format(<<"replace into kf_1vn_bidder set auction_id=~w, id=~w, server_id=~w, server_num=~w, name='~s', price=~w, voucher=~w, payment_refs = '~s'">>, [AuctionId, Id, SerId, SerNum, Name, Price, Voucher, util:term_to_string(Refs)])),
    ok.

db_clean_bidder() -> 
    db:execute(<<"truncate kf_1vn_bidder">>).

db_get_bidder_rank(AuctionId) -> 
    L = db:get_all(io_lib:format(<<"select id, server_id, server_num, name, price from kf_1vn_auction_rank where auction_id=~w order by rank asc">>, [AuctionId])),
    F = fun([Id, SerId, SerNum, Name, Price]) ->
            %?PRINT("db_get_bidder_rank ~p~n", [{Name, util:bitstring_to_term(Name)}]),
            #bidder{id=Id, server_id=SerId, server_num=SerNum, name=Name, price=Price}
    end,
    Bidders = lists:map(F, L),
    LastPrice = case Bidders of
        [#bidder{price=Price}|_] -> Price;
        _ -> 0
    end,
    {lists:sublist(Bidders, 10), LastPrice}.

db_clean_bidder_rank() -> 
    db:execute(<<"truncate kf_1vn_auction_rank">>),
    ok.
db_save_bidder_rank([], _Area, _Issue) -> ok;
db_save_bidder_rank(Rank, AuctionId, _Issue) -> 
    ValueSql = db_save_bidder_rank_sql(Rank, AuctionId, "", 1),
    Sql = "insert into kf_1vn_auction_rank (auction_id, id, server_id, server_num, name, price, rank) values " ++ ValueSql,
    db:execute(Sql),
    ok.

db_save_bidder_rank_sql([], _AuctionId, TmpSql, _Index) -> TmpSql;
db_save_bidder_rank_sql([#bidder{id=Id, server_id=SerId, server_num=ServerNum, name=Name, price=Price}|T], AuctionId, TmpSql, Index) -> 
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, ~w, ~w, '~s', ~w, ~w) ", [AuctionId, Id, SerId, ServerNum, Name, Price, Index]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, ~w, ~w, '~s', ~w, ~w), ", [AuctionId, Id, SerId, ServerNum, Name, Price, Index]) ++ TmpSql
    end,
    db_save_bidder_rank_sql(T, AuctionId, TmpSql1, Index+1).


db_save_issue(Issue, OpTime, EdTime) -> 
    db:execute(<<"truncate kf_1vn_auction">>),
    db:execute(io_lib:format(<<"insert into kf_1vn_auction set issue=~w, optime=~w, edtime=~w">>, [Issue, OpTime, EdTime])).


db_get_past_auction() -> 
    L = db:get_all(<<"select issue, server_num, name, price, awards from kf_1vn_auction_award order by id">>),
    F = fun([Issue, SerNum, Name, Price, Awards]) -> 
            #past_auction{issue=Issue, server_num=SerNum, name=Name, price=Price, goods=util:bitstring_to_term(Awards)}
    end,
    lists:map(F, L).

%% 保存往期拍卖纪录
db_save_past_auction(Issue, SerNum, Name, Price, Awards) -> 
    db:execute(io_lib:format(<<"insert into kf_1vn_auction_award set issue=~w, server_num=~w, name='~s', price=~w, awards='~s'">>, 
            [Issue, SerNum, Name, Price, util:term_to_bitstring(Awards)])).

db_clean_past_auction(Issue) -> 
    db:execute(io_lib:format(<<"delete from kf_1vn_auction_award where issue < ~w">>, [Issue])).
