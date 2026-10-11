%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-31
%% Description: 活动礼包检查类
%% --------------------------------------------------------
-module(lib_gift_check).
-compile(export_all).
-include("def_goods.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("gift.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("vip.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").

%% ================================= 礼包和的等级职业礼包 =================================
%% Return = {ok, GoodsInfo, GiftInfo, Cost} | {fail, Code} | {fail, {Code, Args}}
ckeck_use_gift(Ps, Gs, GoodsInfo, GoodsNum) when is_record(GoodsInfo, goods) ->
    case data_gift:get(GoodsInfo#goods.goods_id) of
        [] ->
            ?INFO("GoodsInfo:~p", [GoodsInfo#goods.goods_id]),
            {fail, ?ERRCODE(err150_gift_cfg_missing)};
        GiftInfo ->
            case ckeck_use_gift(Ps, Gs, GiftInfo, GoodsNum, GoodsInfo) of
                {ok, Cost, GiftReward, RewardList} -> {ok, GoodsInfo, GiftInfo, Cost, GiftReward, RewardList};
                Error -> Error
            end
    end.

check_use_gift_base(PS, GS, GoodsInfo, GiftInfo, Num) ->
    NowTime = utime:unixtime(),
    if
        is_record(GiftInfo, ets_gift) =/= true ->
            ?INFO("GoodsInfo:~p", [GoodsInfo]),
            {fail, ?ERRCODE(err150_gift_cfg_missing)};
        GiftInfo#ets_gift.status =:= 0 ->
            {fail, ?ERRCODE(err150_gift_status_error)};
        GiftInfo#ets_gift.start_time > 0 andalso NowTime < GiftInfo#ets_gift.start_time ->
            {fail, ?ERRCODE(err150_gift_nobegin)};
        GiftInfo#ets_gift.end_time > 0 andalso NowTime > GiftInfo#ets_gift.end_time ->
            {fail, ?ERRCODE(err150_gift_overtime)};
        true ->
            case lib_gift_new:get_gift_reward(PS, GoodsInfo, GiftInfo) of
                [] -> {fail, ?ERRCODE(err150_gift_reward_miss)};
                GiftReward ->
                    RewardList = lib_gift_new:calc_gift_goods(PS, GS, GiftReward, GiftInfo, Num),
                    NewRewardList = lib_goods_api:make_reward_unique(RewardList),
                    {ok, NewRewardList, GiftReward}
%                     CellNum = lib_gift_util:get_gift_cell(GiftReward, Num),
%                     case data_goods_type:get(GiftInfo#ets_gift.goods_id) of
%                         [] ->
%                             {fail, ?ERRCODE(err150_no_goods)};
%                         #ets_goods_type{subtype = SubType} ->
%                             Bag = if
%                                       SubType == ?GOODS_GIFT_STYPE_RUNE -> ?GOODS_LOC_RUNE_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_SOUL -> ?GOODS_LOC_SOUL_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_EUDEMONS -> ?GOODS_LOC_EUDEMONS_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_FURNITURE -> ?GOODS_LOC_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_MOUNT_EQUIP -> ?GOODS_LOC_MOUNT_EQUIP_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_MATE_EQUIP -> ?GOODS_LOC_MATE_EQUIP_BAG;
% %%                                      SubType == ?GOODS_GIFT_STYPE_PET_EQUIP -> ?GOODS_LOC_BAG;
%                                       SubType == ?GOODS_GIFT_STYPE_DECORATION -> ?GOODS_LOC_DECORATION;
%                                       true -> ?GOODS_LOC_BAG
%                                   end,
%                             HaveCell = lib_goods_util:get_null_cell_num(GS, Bag),
%                             if
%                                 CellNum > HaveCell ->
%                                     case SubType of
%                                         ?GOODS_GIFT_STYPE_RUNE ->
%                                             {fail, ?ERRCODE(err416_rune_bag_full)};
%                                         ?GOODS_GIFT_STYPE_SOUL ->
%                                             {fail, ?ERRCODE(err150_soul_bag_full)};
%                                         ?GOODS_GIFT_STYPE_EUDEMONS ->
%                                             {fail, ?ERRCODE(err173_eudemons_bag_full)};
%                                         ?GOODS_GIFT_STYPE_FURNITURE ->
%                                             {fail, ?ERRCODE(err177_house_bag_full)};
%                                         ?GOODS_GIFT_STYPE_MOUNT_EQUIP ->
%                                             {fail, ?ERRCODE(err150_mount_equip_bag_full)};
%                                         ?GOODS_GIFT_STYPE_MATE_EQUIP ->
%                                             {fail, ?ERRCODE(err150_mate_equip_bag_full)};
% %%                                        ?GOODS_GIFT_STYPE_PET_EQUIP ->
% %%                                            {fail, ?ERRCODE(err165_pet_equip_bag_full)};
%                                         _ ->
%                                             {fail, ?ERRCODE(err150_no_cell)}
%                                     end;
%                                 true ->
%                                     {ok, GiftReward}
%                             end
%                     end
            end
    end.

%% Return = {ok, GoodsInfo, GiftInfo, Cost} | {fail, Code} | {fail, {Code, Args}}
ckeck_use_gift(PS, GS, GiftInfo, Num, GoodsInfo) when is_record(GiftInfo, ets_gift) ->
    case check_use_gift_base(PS, GS, GoodsInfo, GiftInfo, Num) of
        {ok, RewardList, GiftReward} ->
            case check_gift_condition(GiftInfo#ets_gift.condition, GiftInfo, PS, Num, GoodsInfo, []) of
                {true, Cost} -> {ok, Cost, GiftReward, RewardList};
                Res -> Res
            end;
        {fail, Res} ->
            {fail, Res}
    end;

ckeck_use_gift(_Ps, _Gs, GiftInfo, Num, _GoodsInfo) ->
    ?ERR("Unkown GiftInfo:~p~n", [{GiftInfo, Num}]),
    {fail, ?ERRCODE(err150_gift_cfg_missing)}.

%% ================================= 自选宝箱使用检查 =================================
check_use_optional_gift(PS, GS, GoodsId, SeqList) ->
    Num = lists:sum([ NoNum || {_SeqNo, NoNum} <- SeqList]),
    case lib_goods_check:check_use_goods(PS, GoodsId, Num, GS) of
        {fail, Errno} ->
            {ErrnoInt, _} = util:parse_error_code(Errno),
            case ErrnoInt == ?ERRCODE(err150_lv_err_2) of
                true ->
                    {fail, ?ERRCODE(err150_lv_err)};
                _ ->
                    {fail, ErrnoInt}
            end;
        {ok, GoodsInfo, OptionalGift} ->
            #optional_gift{optional_num = _OpNum, list = List} = OptionalGift,
            case get_seq_goods_list(SeqList, List, []) of
                {true, GoodsList} ->
                    NGoodsList = lib_goods_api:make_reward_unique(GoodsList),
                    case lib_goods_api:can_give_goods(PS, NGoodsList) of
                        true ->
                            {ok, GoodsInfo, OptionalGift, NGoodsList, Num};
                        {false, Res} ->
                            {fail, Res}
                    end;
                Res ->
                    Res
            end;
        _ -> {fail, ?FAIL}
    end.

%% 获取列表内容
get_seq_goods_list([], _List, Goods)->
    ?IF(Goods == [], {fail, 0}, {true, Goods});
get_seq_goods_list([{No, NoNum}|SeqList], List, Goods)->
    case catch lists:nth(No, List) of
        {Type, Id, Num} -> get_seq_goods_list(SeqList, List, [{Type, Id, Num*NoNum}|Goods]);
        Err ->
            ?ERR("get_seq_goods_list by no error:~p", [Err]),
            {fail, ?ERRCODE(err150_seqlist_notmatch)}
    end.

%% ================================= npc礼包使用检查 =================================
check_npc_gift(PlayerStatus, GoodsStatus, GiftId, Card) ->
    NowTime = utime:unixtime(),
    GiftInfo = data_gift:get(GiftId),
    if  is_record(GiftInfo, ets_gift) =:= false ->
            {fail, ?ERRCODE(err150_no_goods)};
        GiftInfo#ets_gift.status =:= 0 ->
            {fail, ?ERRCODE(err150_gift_unactive)};
        GiftInfo#ets_gift.start_time > 0 andalso GiftInfo#ets_gift.start_time > NowTime ->
            {fail, ?ERRCODE(err150_gift_nobegin)};
        GiftInfo#ets_gift.end_time > 0 andalso GiftInfo#ets_gift.end_time =< NowTime ->
            {fail, ?ERRCODE(err150_gift_overtime)};
        true ->
            GoodsTypeInfo = data_goods_type:get(GiftInfo#ets_gift.goods_id),
            if
                is_record(GoodsTypeInfo, ets_goods_type) =:= false ->
                    {fail, ?ERRCODE(err150_no_goods)};
                PlayerStatus#player_status.figure#figure.lv < GoodsTypeInfo#ets_goods_type.level ->
                    {fail, ?ERRCODE(err150_lv_err)};
                true ->
                    case check_npc_gift2(PlayerStatus, GiftInfo, Card, GoodsTypeInfo, GoodsStatus) of
                        %% 条件不符
                        false -> {fail, ?ERRCODE(err150_require_err)};
                        %% 已领取过
                        ok -> {fail, ?ERRCODE(err150_gift_got)};
                        true ->
                            CellNum = lib_gift_util:get_gift_cell(GiftInfo, 1),
                            HaveCell = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_BAG),
                            if  %% 格子不足
                                CellNum > HaveCell ->
                                    {fail, ?ERRCODE(err150_no_cell)};
                                true ->
                                    {ok, GiftInfo}
                            end
                    end
            end
    end.

check_npc_gift2(PlayerStatus, GiftInfo, _Card, GoodsTypeInfo, _GoodsStatus) ->
    GoodsTypeInfo = data_goods_type:get(GiftInfo#ets_gift.goods_id),
    if
        %% 礼包领取方式不正确
        GiftInfo#ets_gift.get_way =/= ?GIFT_GET_WAY_NPC andalso GiftInfo#ets_gift.get_way =/= ?GIFT_GET_WAY_CLIENT ->
            false;
        %% 会员礼包
        GiftInfo#ets_gift.goods_id =:= ?GIFT_GOODS_ID_MEMBER ->
            Vip = PlayerStatus#player_status.vip,
            case Vip#role_vip.vip_lv > 0 of
                true -> ok;
                false -> false
            end;
        %% 新手卡激活
        %% GiftInfo#ets_gift.give_way =:= ?GIFT_GIVE_WAY_CARD ->
        %%     case binary:match(list_to_binary(Card), <<"'">>) of
        %%         nomatch ->
        %%             case check_gift_card(PlayerStatus#player_status.accname, Card) of
        %%                 false -> false;
        %%                 true -> check_gift_queue(PlayerStatus#player_status.id, GiftInfo#ets_gift.id)
        %%             end;
        %%         _ -> false
        %%     end;
        %% 媒体推广礼包
        GiftInfo#ets_gift.goods_id =:= ?GIFT_GOODS_ID_MEDIA ->
            case lib_gift_util:get_base_gift_card(PlayerStatus#player_status.accname) of
                [] -> false;
                [Card2] ->
                    case lib_gift_util:get_gift_card(Card2) of
                        [] -> check_gift_queue(PlayerStatus#player_status.id, GiftInfo#ets_gift.goods_id);
                        _ -> false
                    end
            end;
        %% 所有玩家
        true ->
            check_gift_queue(PlayerStatus#player_status.id, GiftInfo#ets_gift.goods_id)
    end.

check_gift_queue(PlayerId, GiftId) ->
    case lib_gift_util:get_gift_queue(PlayerId, GiftId) of
        [] -> true;
        _ -> ok
    end.

%% 判断新手卡是否正确
check_gift_card(AccName, Card) ->
    {CardKey, ServerIds} = config:get_card(),
    HexList = case ServerIds of
                  List when is_list(List) ->
                      [string:to_upper(util:md5(lists:concat([AccName, SId, CardKey]))) || SId <- ServerIds];
                  _ -> []
              end,
    lists:member(string:to_upper(Card), HexList).

%% ================================= 次数礼包 检查 =================================
check_use_count_gift(PS, GS, GoodsInfo, GoodsNum) ->
    case lib_gift_new:get_count_gift(GoodsInfo#goods.goods_id, PS#player_status.figure#figure.sex) of
        [] -> {fail, ?ERRCODE(err150_gift_cfg_missing)};
        GiftInfo ->
            case check_use_count_gift(PS, GS, GiftInfo, GoodsNum, GoodsInfo) of
                ok -> {ok, GoodsInfo, GiftInfo, [], [], []};
                Error -> Error
            end
    end.

check_use_count_gift(PS, GS, GiftInfo, _GoodsNum, GoodsInfo) ->
    #player_status{figure = #figure{sex = Sex}} = PS,
    [CountGift] = ?IF(GoodsInfo#goods.other#goods_other.optional_data == [], [#count_gift{}], GoodsInfo#goods.other#goods_other.optional_data),
    #count_gift{day_count = DayCount, use_count = UseCount, last_get_time = LastGetTime, freeze_endtime = FreezeEndtime} = CountGift,
    #base_count_gift{reward = Reward} = GiftInfo,
    TotalCountMax = lib_gift_new:get_count_gift_count(GoodsInfo#goods.goods_id, Sex, total),
    DayCountMax = lib_gift_new:get_count_gift_count(GoodsInfo#goods.goods_id, Sex, day),
    NowTime = utime:unixtime(),
    IsToday = utime:is_same_day(LastGetTime, NowTime),
    if
        UseCount >= TotalCountMax -> {fail, ?ERRCODE(err150_gift_no_count)};
        IsToday andalso DayCount >= DayCountMax -> {fail, ?ERRCODE(err150_gift_no_count)};
        NowTime < FreezeEndtime -> {fail, ?ERRCODE(err150_gift_in_freeze)};
        true ->
            case lists:keyfind(UseCount+1, 1, Reward) of
                {_, GiveRewardList} ->
                    case lib_goods:can_give_goods(GS, GiveRewardList) of
                        true -> ok;
                        {false, Res} -> {fail, Res}
                    end;
                _ ->
                    {fail, ?MISSING_CONFIG}
            end
    end.

%% ================================= 奖池礼包 检查 =================================

%% @return {ok, GoodsInfo, GiftInfo, CostList, GiftReward, RewardList}
check_use_pool_gift(PS, _GS, GoodsInfo, _GoodsNum) ->
    GiftId = GoodsInfo#goods.goods_id,
    Round = lib_gift_util:get_pool_gift_round(PS#player_status.id, GiftId),
    case data_pool_gift:get(GiftId, Round) of
        GiftInfo when is_record(GiftInfo, base_pool_gift) ->
            {ok, GoodsInfo, GiftInfo, [], [], []};
        _ ->
            {false, ?ERRCODE(err150_gift_cfg_missing)}
    end.


%% ================================= private fun =================================
%% 礼包开启条件检查
check_gift_condition([], _Gift, _Ps, _Num, _GoodsInfo, Cost) -> {true, Cost};
check_gift_condition([{K, V}|Condition], Gift, Ps, Num, GoodsInfo, Cost) ->
    case K of
        cost -> %% 消耗
            NewCost = format_cost_goods(V, []),
            case lib_goods_util:check_object_list(Ps, NewCost) of
                true -> check_gift_condition(Condition, Gift, Ps, Num, GoodsInfo, NewCost);
                {false, Code} -> {fail, Code}
            end;
        count -> %% 次数判断
            UseCount = mod_daily:get_count(Ps#player_status.id, ?MOD_GOODS, ?MOD_GOODS_GIFT, Gift#ets_gift.goods_id),
            if
                UseCount >= V -> {fail, ?ERRCODE(err150_num_limit)};
                UseCount + Num > V -> {fail, ?ERRCODE(err150_num_over)};
                true -> check_gift_condition(Condition, Gift, Ps, Num, GoodsInfo, Cost)
            end;
        lv -> %% 玩家等级
            if
                V > Ps#player_status.figure#figure.lv -> {fail, ?ERRCODE(err150_lv_not_enough)};
                true -> check_gift_condition(Condition, Gift, Ps, Num, GoodsInfo, Cost)
            end;
        ctime -> %% 获得之后几天后开
            DiffDay = utime:diff_day(GoodsInfo#goods.ctime),
            case DiffDay >= V of
                false -> {fail, {?ERRCODE(err150_day_not_enough), [V - DiffDay, Gift#ets_gift.goods_id]}};
                true -> check_gift_condition(Condition, Gift, Ps, Num, GoodsInfo, Cost)
            end;
        _ ->
            check_gift_condition(Condition, Gift, Ps, Num, GoodsInfo, Cost)
    end.

%% 格式化礼包扣除物品
format_cost_goods([], Objects) -> Objects;
format_cost_goods([{?TYPE_GOODS, GId, Num}|T], Objects) ->
    format_cost_goods(T, [{?TYPE_GOODS, GId, Num}|Objects]);
format_cost_goods([{?TYPE_GOLD, _OGold, NGold}|T], Objects) ->
    format_cost_goods(T, [{?TYPE_GOLD, 0, NGold}|Objects]);
format_cost_goods([{?TYPE_BGOLD, _OGold, NGold}|T], Objects) ->
    format_cost_goods(T, [{?TYPE_BGOLD, 0, NGold}|Objects]);
format_cost_goods([{?TYPE_COIN, _OCoin, NCoin}|T], Objects) ->
    format_cost_goods(T, [{?TYPE_COIN, 0, NCoin}|Objects]);
format_cost_goods([_H|T], Objects) ->
    format_cost_goods(T, Objects).

%% 计算礼包的筛选条件
get_filter_items([], _FilterData, Result) ->
    Result;
get_filter_items([H|Filter], FilterData, [Lv, Sex, Career, Turn]) ->
    case H of

        sex ->
            get_filter_items(Filter, FilterData, [Lv, FilterData#filter_gift_data.sex, Career, Turn]);
        career ->
            get_filter_items(Filter, FilterData, [Lv, Sex, FilterData#filter_gift_data.career, Turn]);
        turn ->
            get_filter_items(Filter, FilterData, [Lv, Sex, Career, FilterData#filter_gift_data.turn]);
        %% lv, server_lv, rune
        lv ->
            get_filter_items(Filter, FilterData, [FilterData#filter_gift_data.lv, Sex, Career, Turn]);
        server_lv -> %% 世界等级
            ServerLv = util:get_world_lv(),
            get_filter_items(Filter, FilterData, [ServerLv, Sex, Career, Turn]);
        rune ->
            get_filter_items(Filter, FilterData, [FilterData#filter_gift_data.rune, Sex, Career, Turn]);
        open_day ->
            get_filter_items(Filter, FilterData, [FilterData#filter_gift_data.open_day, Sex, Career, Turn]);
        mod_level ->
            get_filter_items(Filter, FilterData, [FilterData#filter_gift_data.mod_level, Sex, Career, Turn]);
        _ ->
            get_filter_items(Filter, FilterData, [Lv, Sex, Career, Turn])
    end.
