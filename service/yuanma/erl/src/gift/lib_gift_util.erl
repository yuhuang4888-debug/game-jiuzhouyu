%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-31
%% Description: 活动礼包工具类
%% --------------------------------------------------------
-module(lib_gift_util).
-compile(export_all).
-include("def_goods.hrl").
-include("goods.hrl").
-include("gift.hrl").
-include("server.hrl").
-include("sql_goods.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

%%-----------------------------------------------------------------
%% @doc 取打开礼包需要的格子
%% -spec get_gift_cell(GiftInfo, GiftNum) -> TotalNum when
%% GiftInfo     ::      #ets_info{}         礼包记录
%% GiftNum      ::      integer()           礼包数量
%% TotalNum     ::      integer()           总数量
%% @end
%%-----------------------------------------------------------------
get_gift_cell(GiftReward, Num) ->
    #ets_gift_reward{fixed_gifts = FixedGifts, rand = Rand, rand_gifts = RandGifts} = GiftReward,
    %% 获取固定礼包物品的格子数
    FixedNum = ?IF(FixedGifts == [], 0, get_gifts_fixlist_cell(FixedGifts, Num)),
    %% 获取随机物品数量的格子数
    RandCell = ?IF(Rand == 0 orelse RandGifts == [], 0,
                   get_one_gifts_cell(RandGifts, 0) * Num * Rand),
    FixedNum + RandCell.

%%------------------------------------------------------
%% @doc 获取礼包物品列表需要的格子数
%% -spec get_gift_cell(Item, Sum) -> Num        when
%% Item     ::        atom          类型
%% Sum      ::        integer       总数
%% Num      ::        integer       新的总数
%% @end
%%------------------------------------------------------
get_gifts_cell({Type, GoodTypeId, Num}, Sum) when
      Type == ?TYPE_GOODS;  Type == ?TYPE_BIND_GOODS ->
    case data_goods_type:get(GoodTypeId) of
        #ets_goods_type{max_overlap = MaxOverlap} ->
            if
                MaxOverlap > Num -> Sum + 1;
                MaxOverlap == 0 -> Sum + Num;
                true -> Sum + util:ceil(Num / MaxOverlap)
            end;
        _ ->
            Sum
    end;
get_gifts_cell(_, Sum) -> Sum.

get_gifts_fixlist_cell(FixList, GiftNum) ->
    Sum = lists:foldl(fun get_gifts_cell/2, 0, FixList),
    Sum * GiftNum.

%% add_online_gift(PlayerId, GiftId) ->
%%     case get_gift_queue(PlayerId, GiftId) of
%%         [] -> add_gift(PlayerId, GiftId, 0);
%%         _ -> mod_give(PlayerId, GiftId, util:unixtime(), 0)
%%     end.

%% get_gift_queue(PlayerId, GiftId) ->
%%     Sql = io_lib:format(?SQL_GIFT_QUEUE_SELECT, [PlayerId, GiftId]),
%%     db:get_row(Sql).

%% add_gift(PlayerId, GiftId, Status) ->
%%     Sql = io_lib:format(?SQL_GIFT_QUEUE_INSERT, [PlayerId, GiftId, util:unixtime(), Status]),
%%     db:execute(Sql).

%% mod_give(PlayerId, GiftId, GiveTime, Status) ->
%%     Sql = io_lib:format(?SQL_GIFT_QUEUE_UPDATE_GIVE, [GiveTime, Status, PlayerId, GiftId]),
%%     db:execute(Sql).

%% add_npc_gift(PlayerId, GiftId) ->
%%     NowTime = util:unixtime(),
%%     Sql = io_lib:format(?SQL_GIFT_QUEUE_INSERT_FULL, [PlayerId, GiftId, NowTime, 1, NowTime, 1]),
%%     db:execute(Sql).

add_gift_card(PlayerId, Card, Type) ->
    Sql = io_lib:format(?SQL_GIFT_CARD_INSERT, [PlayerId, Card, Type, util:unixtime()]),
    db:execute(Sql).

get_base_gift_card(Accname) ->
    Sql = io_lib:format(?SQL_GIFT_CARD_BASE_SELECT, [Accname]),
    db:get_row(Sql).

get_gift_card(Card) ->
    Sql = io_lib:format(?SQL_GIFT_CARD_SELECT, [Card]),
    db:get_row(Sql).

get_charge(PlayerId) ->
    Sql = io_lib:format(?SQL_CHARGE_SELECT, [PlayerId]),
    db:get_row(Sql).

%% 检查是否充值
check_charge(PlayerId) ->
    case get_charge(PlayerId) of
        [Id] when Id > 0 -> true;
        _ -> false
    end.

%% 获取随机物品里面占据最大的背包数
get_one_gifts_cell([], Cell) -> Cell;
get_one_gifts_cell([{{Type, GoodTypeId, Num}, _R}|RandGifts], Cell)->
    GNum = if
               Type == ?TYPE_GOODS orelse Type == ?TYPE_BIND_GOODS ->
                   case data_goods_type:get(GoodTypeId) of
                       #ets_goods_type{max_overlap = MaxOverlap} ->
                           ?IF(MaxOverlap == 0, Num, 1);
                       _ -> 0
                   end;
               true -> 0
           end,
    NewCell = ?IF(Cell >= GNum, Cell, GNum),
    get_one_gifts_cell(RandGifts, NewCell).

%% 获取奖池礼包当前轮次
get_pool_gift_round(PlayerId, GiftId) ->
    mod_counter:get_count(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_ROUND, GiftId) + 1. % 从1开始

%% 递增奖池礼包轮次
inc_pool_gift_round(PlayerId, GiftId) ->
    mod_counter:increment(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_ROUND, GiftId).

%% 设值奖池礼包轮次
set_pool_gift_round(PlayerId, GiftId, V) ->
    mod_counter:set_count(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_ROUND, GiftId, V-1).

%% 获取奖池礼包失败次数(未抽到高级奖励)
get_pool_gift_fail_times(PlayerId, GiftId) ->
    mod_counter:get_count(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_FAIL, GiftId).

%% 递增奖池礼包失败次数
inc_pool_gift_fail_times(PlayerId, GiftId) ->
    mod_counter:increment(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_FAIL, GiftId).

%% 设值奖池礼包失败次数
set_pool_gift_fail_times(PlayerId, GiftId, V) ->
    mod_counter:set_count(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_FAIL, GiftId, V).

%% 清空奖池礼包失败次数
clr_pool_gift_fail_times(PlayerId, GiftId) ->
    mod_counter:set_count(PlayerId, ?MOD_GOODS, ?MOD_GOODS_PGIFT_FAIL, GiftId, 0).

%% 判断奖池礼包当次抽奖能否抽高级奖池
%% @return boolean()
is_pool_gift_premium(GiftInfo, FailTimes) ->
    #base_pool_gift{
        init_rate = InitRate,
        inc_rate = IncRate,
        sum_rate = SumRate
    } = GiftInfo,
    Rate = InitRate + IncRate * FailTimes,
    Rate >= urand:rand(1, SumRate).

%% 测试GiftId的奖池礼包需要多少次可以抽高级奖池
test_is_pool_gift_premium(GiftId, Round) when is_integer(GiftId) ->
    GiftInfo = data_pool_gift:get(GiftId, Round),
    test_is_pool_gift_premium(GiftInfo, 1);

test_is_pool_gift_premium(GiftInfo, Times) ->
    case is_pool_gift_premium(GiftInfo, Times-1) of
        true -> Times;
        false -> test_is_pool_gift_premium(GiftInfo, Times+1)
    end.

test_is_pool_gift_premium_n(GiftId, Round, N) ->
    ResList = [test_is_pool_gift_premium(GiftId, Round) || _ <- lists:seq(1, N)],
    lists:sum(ResList) / length(ResList).