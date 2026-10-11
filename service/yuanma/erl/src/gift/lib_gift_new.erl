%%%--------------------------------------
%%% @Module  : lib_gift_new
%%% @Author  : calvin
%%% @Email   : calvinzhong888@gmail.com
%%% @Created : 2012.7.3
%%% @Description: 礼包相关代码（新版）
%%%--------------------------------------

-module(lib_gift_new).
-include("def_goods.hrl").
-include("goods.hrl").
-include("gift.hrl").
-include("server.hrl").
-include("common.hrl").
-include("sql_goods.hrl").
-include("unite.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("guild.hrl").

-export ([
          use_gift/8,               %% 在背包中打开礼包
          get_optional_gift/3,      %% 获取自选礼包配置
          use_optional_gift/6,      %% 在背包中使用自选礼包
          fetch_gift_in_good/3,     %% 领取礼包的方法
          fetch_gift_in_good/4,     %% 领取礼包的方法
          send_goods_notice_msg/2	%% 右下角显示获得具体什么物品
          , get_count_gift_info/2   %% 获取次数礼包信息
          , format_other_data/1
          , get_count_gift_count/3  %% 获取礼包配置次数
          , get_count_gift/2        %% 获取次数礼包配置
          , is_lv_gift/1            %% 是否是等级礼包
          , is_rune_gift/1          %% 是否是符文礼包
          , is_open_day_gift/1      %% 是否是开服天数礼包
         ]).

-export([
         update_to_received/3,      %% 更新礼包为领取状态（修改表并加缓存）
         set_gift_fetch_status/3,   %% 设置礼包领取状态（只加缓存）
         get_gift_fetch_status/2,   %% 获取礼包领取状态
         trigger_fetch/2,           %% 触发达成礼包，但状态为未领取
         trigger_finish/2           %% 触发达成礼包，状态为已经领取
        ]).

%% 计算礼包内容
-export([get_gift_goods/3
        , get_gift_reward/3
        , calc_gift_goods/5
        , get_gift_level/3]).

get_gift_goods(PS, GiftId, Num) ->
    GiftInfo = data_gift:get(GiftId),
    GS = lib_goods_do:get_goods_status(),
    case lib_gift_check:check_use_gift_base(PS, GS, none, GiftInfo, Num) of
        {ok, RewardList, GiftReward} ->
            %GiftList = calc_gift_goods(PS, GS, GiftReward, GiftInfo, Num),
            NewGiftList = RewardList,
            {true, NewGiftList, GiftReward};
        Res -> Res
    end.

%% 直接调用领取礼包的方法
fetch_gift_in_good(PS, GS, GiftId) ->
    fetch_gift_in_good(PS, GS, GiftId, 1).

fetch_gift_in_good(PS, GS, GiftId, GiftNum) ->
    GiftInfo = data_gift:get(GiftId),
    case lib_gift_check:ckeck_use_gift(PS, GS, GiftInfo, GiftNum) of
        %% 直接领取礼包内物品
        ok when GiftInfo#ets_gift.get_way =:= 1->
            case private_gift_to_package(GS, GiftInfo, GiftNum) of
                {ok, NewGS, GoodsL} ->
                    GiveList = [{?TYPE_GOODS, GiftInfo#ets_gift.goods_id, GiftNum}],
                    {ok, PS, NewGS, GoodsL, GiveList};
                {fail, ErrorCode} ->
                    {fail, ErrorCode}
            end;
        %% 直接领取礼包内物品
        ok ->
            private_gift_to_open_in_goods(PS, GS, GiftInfo, GiftNum);
        {fail, ErrorCode} ->
            {fail, ErrorCode}
    end.

%% 将礼包放进背包，不打开礼包的东西
private_gift_to_package(GS, GiftInfo, GiftNum) ->
    GoodsTypeId = GiftInfo#ets_gift.goods_id,
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                {ok, NewGS} = lib_goods:give_goods({GoodsTypeId, GiftNum}, GS),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS#goods_status.dict),
                NewGS2 = NewGS#goods_status{dict = Dict},
                {ok, NewGS2, GoodsL}
        end,
    case lib_goods_util:transaction(F) of
        {ok, GoodsStatus, UpdateL} ->
            lib_goods_api:notify_client(GoodsStatus#goods_status.player_id, UpdateL),
            {ok, GoodsStatus, UpdateL};
        {db_error, {error, {_Type, not_found}}} ->
            {fail, ?ERRCODE(err150_no_goods_type)};
        {db_error, {error, {cell_num, not_enough}}} ->
            {fail, ?ERRCODE(err150_no_cell)};
        _ ->
            {fail, ?ERRCODE(err150_gift_fetch_error)}
    end.

%% 直接打开礼包获取里面的物品
private_gift_to_open_in_goods(PS, GS, GiftInfo, GiftNum) ->
    GiftReward = get_gift_reward(PS, none, GiftInfo),
    GiftList = calc_gift_goods(PS, GS, GiftReward, GiftInfo, GiftNum),
    GiftList2 = merge_helper(GiftList, [], []),
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                [_, NewPS, NewGST, _, _, _]
                    = lists:foldl(fun private_give_gift_item/2, [GiftInfo, PS, GS, ?UNBIND, 0, []], GiftList2),
                NewGSR = update_to_received(NewGST, NewPS#player_status.id, GiftInfo#ets_gift.goods_id),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGSR#goods_status.dict),
                LastGS = NewGSR#goods_status{dict = Dict},
                lib_goods_api:notify_client(LastGS#goods_status.player_id, GoodsL),
                %% 写开礼包日志
                About = pack_get_log_about(GiftList2),
                %% lib_log_api:log_gift(PS#player_status.id, GiftInfo#ets_gift.id, GiftInfo#ets_gift.goods_id, GiftInfo#ets_gift.id, GiftNum, About),
                lib_log_api:log_gift(PS#player_status.id, 0, GiftInfo#ets_gift.goods_id, 0, GiftNum, About),
                lib_goods_api:send_tv_tip(PS#player_status.id, 1, GiftList2),
                {ok, NewPS, LastGS, GoodsL, GiftList2}
        end,
    lib_goods_util:transaction(F).

%% 获取次数礼包的信息
get_count_gift_info(PS, GoodsId) ->
    #player_status{figure = #figure{sex = Sex}} = PS,
    GS = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods_info(GoodsId, GS#goods_status.dict),
    case is_record(GoodsInfo, goods) of
        true when GoodsInfo#goods.type == ?GOODS_TYPE_COUNT_GIFT andalso GoodsInfo#goods.player_id == GS#goods_status.player_id ->
            case GoodsInfo#goods.other#goods_other.optional_data of
                [#count_gift{use_count=UseCount, freeze_endtime=FreezeEndtime}] ->
                    TotalCount = get_count_gift_count(GoodsInfo#goods.goods_id, Sex, total),
                    {UseCount, TotalCount, FreezeEndtime};
                _ ->
                    TotalCount = get_count_gift_count(GoodsInfo#goods.goods_id, Sex, total),
                    {0, TotalCount, 0}
            end;
        _ ->
            {0, 0, 0}
    end.

%%-------------------------------------------------------------------
%% @doc 在背包中打开礼包，goods进程会调用该方法,在该方法里面，不能再去调用goods进程的方法 游戏线
%% use_gift(PS, GS, GoodsInfo, GiftInfo, GoodsNum) ->
%%     {NewPS, NewGS, NewGoodsNum, GiveList} | {fail,Error}
%%----------------------------------------------------------------------------------
use_gift(PS, GS, GoodsInfo, GiftInfo, GoodsNum, Cost, GiftReward, RewardList) ->
    case GoodsInfo#goods.type of
        ?GOODS_TYPE_COUNT_GIFT ->
            use_count_gift(PS, GS, GoodsInfo, GiftInfo, GoodsNum, Cost);
        ?GOODS_TYPE_POOL_GIFT ->
            use_pool_gift(PS, GS, GoodsInfo, GoodsNum);
        _ ->
            case lib_goods:can_give_goods(GS, RewardList) of
                true ->
                    use_common_gift(PS, GS, GoodsInfo, GiftInfo, GoodsNum, Cost, GiftReward, RewardList);
                {false, Res} -> {fail, Res}
            end
    end.

use_common_gift(PS, GS, GoodsInfo, GiftInfo, GoodsNum, Cost, GiftReward, RewardList) ->
    %?PRINT("use_common_gift ~p~n", [GiftReward]),
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                %% 先删除本礼包
                [NewStatus, _] = lib_goods:delete_one(GoodsInfo, [GS, GoodsNum]),
                About = lists:concat(["gift_id:", GiftInfo#ets_gift.goods_id]),
                %% 删除消耗
                {true, NewGS, NewPS} = lib_goods_util:cost_object_list(PS, Cost, use_gift, About, NewStatus),
                %% 计算礼包奖励
                NewNum = GoodsInfo#goods.num - GoodsNum,
                %GiftList = calc_gift_goods(PS, NewGS, GiftReward, GiftInfo, GoodsNum),
                %?PRINT("calc_gift_goods ~p~n", [GiftList]),
                GiftList2 = RewardList,
                [_, NewPs, NewGs, _, _, _] =
                    lists:foldl(fun private_give_gift_item/2, [GiftInfo, NewPS, NewGS, GoodsInfo#goods.bind, 0, []], GiftList2),
                LastGS = update_to_received(NewGs, PS#player_status.id, GiftInfo#ets_gift.goods_id),
                {D, GoodsL} = lib_goods_dict:handle_dict_and_notify(LastGS#goods_status.dict),
                {ok, NewPs, LastGS#goods_status{dict = D}, NewNum, GiftList2, GoodsL}
        end,
    case lib_goods_util:transaction(F) of
        {ok, LastNewPS, LastNewGoodsStatus1, LastNewNum, LastGiveList, UpdateGoodsList} ->
            %% 礼包使用日志
            About = pack_get_log_about(LastGiveList),
            lib_supreme_vip_api:collect_goods(PS#player_status.id, About),
            lib_log_api:log_gift(PS#player_status.id, GoodsInfo#goods.id, GiftInfo#ets_gift.goods_id,
                                 GiftInfo#ets_gift.goods_id, GoodsNum, About),
            %% 记录开启次数
            case lists:keyfind(count, 1, GiftInfo#ets_gift.condition) of
                false -> skip;
                {count, _Count} -> mod_daily:plus_count(PS#player_status.id, ?MOD_GOODS,
                                                        ?MOD_GOODS_GIFT, GiftInfo#ets_gift.goods_id, GoodsNum)
            end,
            lib_goods_api:notify_client(LastNewPS, UpdateGoodsList),
            %% 礼包传闻
            private_get_valuable_send_tv(LastNewPS, GiftInfo, GiftReward, LastGiveList, UpdateGoodsList),
            %% 重新包装显示列表
            FF = fun({TType, TGoodsTypeId, TNum}, TL) ->
                        case lists:keyfind(TGoodsTypeId, #goods.goods_id, UpdateGoodsList) of
                            false -> [{0, TType, TGoodsTypeId, TNum}|TL];
                            #goods{id = TGId} -> [{TGId, TType, TGoodsTypeId, TNum}|TL]
                        end
                end,
            NLGiveList = lists:foldl(FF, [], LastGiveList),
            {ok, LastNewPS, LastNewGoodsStatus1, LastNewNum, NLGiveList};
        Err ->
            {fail, Err}
    end.

%% 获取自选礼包配置数据
get_optional_gift(GiftId, RoleCareer, Lv) ->
    Career = ?IF(lists:member(RoleCareer, data_optional_gift:get_gift_career(GiftId)), RoleCareer, 0),
    ConditionList = data_optional_gift:get_gift_condition(GiftId),
    OpenDay = util:get_open_day(),
    {RSlv, RElv, RSopenDay, REopenDay} =
        case get_optional_gift_condition(ConditionList, OpenDay, Lv) of
            [] ->
                [T |_] = ConditionList,
                T;
            RCondition -> RCondition
        end,
    data_optional_gift:get_by_id(GiftId, RSlv, RElv, RSopenDay, REopenDay, Career).

get_optional_gift_condition([], _OpenDay, _Lv) -> [];
get_optional_gift_condition([{CSlv, CElv, CSopenDay, CEopenDay} | N], OpenDay, Lv) ->
    case CSlv =<Lv andalso Lv =< CElv andalso CSopenDay =< OpenDay andalso OpenDay =< CEopenDay of
        true ->
            {CSlv, CElv, CSopenDay, CEopenDay};
        _ ->
            get_optional_gift_condition(N, OpenDay, Lv)
    end.

%% 获取自选宝箱物品内容
%% Num:玩家使用的礼包数量
%% SeqList:内容序号
use_optional_gift(PS, GoodsStatus, GoodsInfo, _OptionalGift, GoodsList, Num) ->
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                %% 先删除自选宝箱
                [NewGS, _] = lib_goods:delete_one(GoodsInfo, [GoodsStatus, Num]),
                %% 发送物品
                [_, _, NewPS, NewGs, _, GiveList]
                    = lists:foldl(fun give_reward_item/2, [optional_gift, GoodsInfo#goods.goods_id, PS,
                                                           NewGS, GoodsInfo#goods.bind, []],
                                  GoodsList),
                {D, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGs#goods_status.dict),
                {ok, NewPS, NewGs#goods_status{dict = D}, GoodsL, GiveList}
        end,
    case lib_goods_util:transaction(F) of
        {ok, LastNewPS, LastNewGoodsStatus, UpdateGoodsList, TipGiveList} ->
            %% 发送获得物品信息给客户端显示在右下角
            lib_gift_new:send_goods_notice_msg(PS, TipGiveList),
            %% 写开等级礼包日志
            About = About = pack_get_log_about(TipGiveList),
            lib_log_api:log_gift(PS#player_status.id, GoodsInfo#goods.id,
                                 GoodsInfo#goods.goods_id, GoodsInfo#goods.goods_id, Num, About),
            lib_goods_api:notify_client(LastNewPS, UpdateGoodsList),
            lib_goods_do:set_goods_status(LastNewGoodsStatus),
            {ok, ?SUCCESS, LastNewPS};
        _Err->
            {fail, ?FAIL, _Err}
    end.

%% 使用次数宝箱 默认只打开一次
use_count_gift(PS, GoodsStatus, GoodsInfo, GiftInfo, _GoodsNum, _Cost) ->
    F = fun() ->
            ok = lib_goods_dict:start_dict(),
            use_count_gift_core(PS, GoodsStatus, GoodsInfo, GiftInfo)
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewPS, NewGS, NewNum, UpdateGoodsList, GiveList} ->
            %% 发送获得物品信息给客户端显示在右下角
            lib_gift_new:send_goods_notice_msg(PS, GiveList),
            %% 写开等级礼包日志
            About = pack_get_log_about(GiveList),
            lib_supreme_vip_api:collect_goods(PS#player_status.id, About),
            lib_log_api:log_gift(PS#player_status.id, GoodsInfo#goods.id,
                                 GoodsInfo#goods.goods_id, GoodsInfo#goods.goods_id, 1, About),
            lib_goods_api:notify_client(NewPS, UpdateGoodsList),
            %% 重新包装显示列表
            FF = fun({TType, TGoodsTypeId, TNum}, TL) ->
                    case lists:keyfind(TGoodsTypeId, #goods.goods_id, UpdateGoodsList) of
                        false -> [{0, TType, TGoodsTypeId, TNum}|TL];
                        #goods{id = TGId} -> [{TGId, TType, TGoodsTypeId, TNum}|TL]
                    end
            end,
            NGiveList = lists:foldl(FF, [], GiveList),
            %?PRINT("use_count_gift NGiveList ~p~n", [NGiveList]),
            {ok, NewPS, NewGS, NewNum, NGiveList};
        _Err->
            ?ERR("use count gift err ~p~n", [_Err]),
            {fail, ?FAIL}
    end.

use_count_gift_core(PS, GoodsStatus, GoodsInfo, GiftInfo) ->
    NowTime = utime:unixtime(),
    #player_status{figure = #figure{sex = Sex}} = PS,
    OptionalData = GoodsInfo#goods.other#goods_other.optional_data,
    [CountGift] = ?IF(OptionalData == [], [#count_gift{}], OptionalData),
    #count_gift{day_count = DayCount, use_count = UseCount, last_get_time = LastGetTime} = CountGift,
    #base_count_gift{freeze_time = FreezeTime, reward = Reward} = GiftInfo,
    TotalCountMax = lib_gift_new:get_count_gift_count(GoodsInfo#goods.goods_id, Sex, total),
    DayCountMax = lib_gift_new:get_count_gift_count(GoodsInfo#goods.goods_id, Sex, day),
    IsToday = utime:is_same_day(LastGetTime, NowTime),
    NewDayCount = ?IF(IsToday, DayCount + 1, 1),
    NewUseCount = UseCount + 1,
    NewLastGetTime = NowTime,
    NewFreezeEndTime = if
        NewDayCount >= DayCountMax -> utime:unixdate() + ?ONE_DAY_SECONDS;
        FreezeTime > 0 ->
            ?IF( (NowTime+FreezeTime)>=(utime:unixdate() + ?ONE_DAY_SECONDS), utime:unixdate() + ?ONE_DAY_SECONDS, NowTime+FreezeTime );
        true -> 0
    end,
    NewCountGift = #count_gift{day_count = NewDayCount, use_count = NewUseCount, last_get_time = NewLastGetTime, freeze_endtime = NewFreezeEndTime},
    %?PRINT("use_count_gift_core NewCountGift ~p~n", [NewCountGift]),
    NewGoodsInfo = GoodsInfo#goods{other = GoodsInfo#goods.other#goods_other{optional_data = [NewCountGift]}},
    lib_goods_util:change_goods_other(NewGoodsInfo#goods.id, format_other_data(NewGoodsInfo)),
    %% 次数用完了，删除礼包
    case NewUseCount >= TotalCountMax of
        true ->
            NewNum = NewGoodsInfo#goods.num - 1,
            Op = delete,
            [GoodsStatus1, _] = lib_goods:delete_one(NewGoodsInfo, [GoodsStatus, 1]);
        _ ->
            NewNum = NewGoodsInfo#goods.num,
            Op = change,
            Dict1 = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            GoodsStatus1 = GoodsStatus#goods_status{dict = Dict1}
    end,
    %% 获取奖励
    case lists:keyfind(NewUseCount, 1, Reward) of
        {_, RewardList} -> ok;
        _ -> RewardList = []
    end,
    %% 发送物品
    [_, _, NewPS, NewGS, _, GiveList]
        = lists:foldl(fun give_reward_item/2, [count_gift, GoodsInfo#goods.goods_id, PS, GoodsStatus1, GoodsInfo#goods.bind, []], RewardList),
    {D, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGS#goods_status.dict),
    case Op of
        delete -> NGoodsL = GoodsL;
        _ ->
            NGoodsL = [Item || Item <- GoodsL, Item#goods.id =/= GoodsInfo#goods.id]
    end,
    {ok, NewPS, NewGS#goods_status{dict = D}, NewNum, NGoodsL, GiveList}.

format_other_data(GoodsInfo) when GoodsInfo#goods.type == ?GOODS_TYPE_COUNT_GIFT ->
    case GoodsInfo#goods.other#goods_other.optional_data of
        [CountGift] -> ok;
        _ -> CountGift = #count_gift{}
    end,
    #count_gift{day_count = DayCount, use_count = UseCount, last_get_time = LastGetTime, freeze_endtime = FreezeEndtime} = CountGift,
    [?GOODS_OTHER_KEY_COUNT_GIFT, DayCount, UseCount, LastGetTime, FreezeEndtime];
format_other_data(GoodsInfo) when GoodsInfo#goods.type == ?GOODS_TYPE_GIFT ->
    case GoodsInfo#goods.other#goods_other.optional_data of
        L when is_list(L), length(L) > 0 -> [?GOODS_OTHER_KEY_GIFT|L];
        _ -> []
    end;
format_other_data(_GoodsInfo) ->
    [].

get_gift_level(PS, GoodsId, GoodsTypeId) ->
    GS = lib_goods_do:get_goods_status(),
    case lib_goods_util:get_goods(GoodsId, GS#goods_status.dict) of
        #goods{goods_id = NewGoodsTypeId} = GoodsInfo -> ok;
        _ -> NewGoodsTypeId = GoodsTypeId, GoodsInfo = none
    end,
    case data_gift:get(NewGoodsTypeId) of
        #ets_gift{} = GiftInfo ->
            FilterData = make_filter_data(PS, GoodsInfo, GiftInfo),
            [Lv, _Sex, _Career, _Turn] = lib_gift_check:get_filter_items(GiftInfo#ets_gift.filter, FilterData, [0, 0, 0, 0]),
            Lv;
        _ -> 0
    end.

%% 奖池礼包使用
%% @return {ok, PS, GS, Num, RewardList} | {fail, ?FAIL}
use_pool_gift(PS, GS, GoodsInfo, GoodsNum) ->
    use_pool_gift(PS, GS, GoodsInfo, GoodsNum, []).

use_pool_gift(PS, GS, GoodsInfo, 0, RewardList) ->
    NewNum = ?IF(is_record(GoodsInfo, goods), GoodsInfo#goods.num, 0),
    {ok, PS, GS, NewNum, RewardList};

use_pool_gift(PS, GS, GoodsInfo, GoodsNum, RewardList) ->
    case use_pool_gift_one(PS, GS, GoodsInfo) of
        {ok, PS1, GS1, Rewards} ->
            GoodsInfo1 = lib_goods_util:get_goods(GoodsInfo#goods.id, GS1#goods_status.dict),
            use_pool_gift(PS1, GS1, GoodsInfo1, GoodsNum-1, Rewards++RewardList);
        Err ->
            Err
    end.

use_pool_gift_one(PS, GS, GoodsInfo) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    #goods{id = GoodsId, goods_id = GiftId, bind = Bind} = GoodsInfo,

    Round = lib_gift_util:get_pool_gift_round(RoleId, GiftId),
    FailTimes = lib_gift_util:get_pool_gift_fail_times(RoleId, GiftId),
    {IsPrem, Round1, FailTimes1, RewardList} = calc_pool_gift_reward(GiftId, Round, FailTimes),

    F = fun() ->
        ok = lib_goods_dict:start_dict(),

        % 礼包数量删除
        [GS1, _] = lib_goods:delete_one(GoodsInfo, [GS, 1]),

        % 物品发放，更新物品字典
        [_, _, PS1, GS2, _, GiveList] =
            lists:foldl(fun give_reward_item/2, [pool_gift, GiftId, PS, GS1, Bind, []], RewardList),
        {D, GoodsL} = lib_goods_dict:handle_dict_and_notify(GS2#goods_status.dict),

        % 设值新的礼包轮次和失败次数
        lib_gift_util:set_pool_gift_round(RoleId, GiftId, Round1),
        lib_gift_util:set_pool_gift_fail_times(RoleId, GiftId, FailTimes1),

        {ok, PS1, GS2#goods_status{dict = D}, GoodsL, GiveList}
    end,
    case lib_goods_util:transaction(F) of
        {ok, NewPS, NewGS, UpdateList, GiveList} ->
            % 日志
            About = pack_get_log_about(GiveList),
            lib_log_api:log_gift(RoleId, GoodsId, GiftId, GiftId, 1, About),

            % 通知客户端，重新包装显示列表
            lib_goods_api:notify_client(NewPS, UpdateList),
            FF = fun({TType, TGoodsTypeId, TNum}, TL) ->
                    case lists:keyfind(TGoodsTypeId, #goods.goods_id, UpdateList) of
                        false -> [{0, TType, TGoodsTypeId, TNum}|TL];
                        #goods{id = TGId} -> [{TGId, TType, TGoodsTypeId, TNum}|TL]
                    end
            end,
            NGiveList = lists:foldl(FF, [], GiveList),

            % 任务触发
            lib_supreme_vip_api:collect_goods(RoleId, About),

            % 传闻
            IsPrem andalso send_pool_reward_tv(GiveList, UpdateList, RoleName, GiftId, ""),

            {ok, NewPS, NewGS, NGiveList};
        Err ->
            ?ERR("use pool gift err ~p~n", [Err]),
            {fail, ?FAIL}
    end.

calc_pool_gift_reward(GiftId, Round, FailTimes) ->
    #base_pool_gift{
        normal_times = NormalTimes,
        normal_pool = NormalPool,
        prem_times = PremTimes,
        prem_pool = PremPool
    } = GiftInfo = data_pool_gift:get(GiftId, Round),

    IsPrem = lib_gift_util:is_pool_gift_premium(GiftInfo, FailTimes),
    {Times, Pool} = ?IF(IsPrem, {PremTimes, PremPool}, {NormalTimes, NormalPool}),
    {Round1, FailTimes1} = ?IF(IsPrem, {Round+1, 0}, {Round, FailTimes+1}),
    Rewards = lists:flatten([urand:rand_with_weight(Pool) || _ <- lists:seq(1, Times)]),

    {IsPrem, Round1, FailTimes1, lib_goods_api:make_reward_unique(Rewards)}.

%% 奖池礼包传闻
%% @param GoodsList :: [#goods{},...]
%%        GoodsStr :: string() 多个奖励物品拼接而成的字符串
send_pool_reward_tv([{Type, GTypeId, Num} | T], GoodsList, RoleName, GiftId, GoodsStr)
        when Type == ?TYPE_GOODS; Type == ?TYPE_BIND_GOODS ->
    case lists:keyfind(GTypeId, #goods.goods_id, GoodsList) of
        false ->
            send_pool_reward_tv(T, GoodsList, RoleName, GiftId, GoodsStr);
        #goods{other = #goods_other{rating = Rating, extra_attr = ExtraAttr}} ->
            Delim = ?IF(GoodsStr == "", "", "  "),
            AttrS = util:term_to_string(data_attr:unified_format_extra_attr(ExtraAttr, [])),
            GoodsS = utext:get(?MOD_GOODS, 28, [GTypeId, Rating, AttrS, Num]),
            GoodsStr1 = lists:concat([GoodsStr, Delim, GoodsS]),
            send_pool_reward_tv(T, GoodsList, RoleName, GiftId, GoodsStr1)
    end;

send_pool_reward_tv([], _, RoleName, GiftId, GoodsStr) ->
    lib_chat:send_TV({all}, ?MOD_GOODS, 27, [RoleName, GiftId, GoodsStr]),
    ok.

%% ================================= private fun =================================
%% 整理合并列表
merge_helper([{Type = ?TYPE_GOODS, GoodsTypeId, GoodsNum}| GiftList], GoodsList, Save) ->
    NewGoodsList = case lists:keyfind({Type, GoodsTypeId}, 1, GoodsList) of
                       {_, Num} -> [{ {Type, GoodsTypeId}, GoodsNum+Num}| lists:keydelete({Type, GoodsTypeId}, 1, GoodsList)];
                       false    -> [{ {Type, GoodsTypeId}, GoodsNum} | GoodsList]
                   end,
    merge_helper(GiftList, NewGoodsList, Save);
merge_helper([{Type = ?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}| GiftList], GoodsList, Save) ->
    NewGoodsList = case lists:keyfind({Type, GoodsTypeId}, 1, GoodsList) of
                       {_, Num} -> [{ {Type, GoodsTypeId}, GoodsNum+Num}| lists:keydelete({Type, GoodsTypeId}, 1, GoodsList)];
                       false    -> [{ {Type, GoodsTypeId}, GoodsNum} | GoodsList]
                   end,
    merge_helper(GiftList, NewGoodsList, Save);
merge_helper([H | GiftList], GoodsList, Save) ->
    merge_helper(GiftList, GoodsList, [H|Save]);
merge_helper([], GoodsList, Save) ->
    F = fun ({ {?TYPE_GOODS, GoodsTypeId}, GoodsNum}) -> {?TYPE_GOODS, GoodsTypeId, GoodsNum};
            ({ {?TYPE_BIND_GOODS, GoodsTypeId}, GoodsNum}) -> {?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}
        end,
    GoodsList2 = lists:map(F, GoodsList),
    GoodsList2 ++ Save.

%% 具体处理礼包配置的各种属性奖励或物品奖励
%% IsFetchGoods	该项值只针对物品或者装备，对其他配的没影响。值0：会获取物品和装备  1：不会获取物品和装备  2：不会获取装备
private_give_gift_item(Item, [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList]) ->
    case Item of
        {?TYPE_EXP, _, Exp} ->
            NewPlayerStatus = lib_player:add_exp(PlayerStatus, Exp),
            [GiftInfo, NewPlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GOLD, _, Gold} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Gold, gold),
            lib_log_api:log_produce(gift, gold, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GiftInfo#ets_gift.goods_id, ", Money=", Gold])),
            [GiftInfo, NewPlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_BGOLD, _, BGold} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, BGold, bgold),
            lib_log_api:log_produce(gift, bgold, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GiftInfo#ets_gift.goods_id, ", Money=", BGold])),
            [GiftInfo, NewPlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_COIN, _, Coin} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Coin, coin),
            lib_log_api:log_produce(gift, coin, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GiftInfo#ets_gift.goods_id, ", Money=", Coin])),
            [GiftInfo, NewPlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GFUNDS, _, Gfunds} -> %% 公会资金
            mod_guild:add_gfunds(PlayerStatus#player_status.id, PlayerStatus#player_status.guild#status_guild.id, Gfunds, gift),
            [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GDONATE, _, Donate} -> %% 公会贡献
            mod_guild:add_donate(PlayerStatus#player_status.id, Donate, gift, {gift, GiftInfo#ets_gift.goods_id}),
            [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_SEA_EXPLOIT, _, Exploit} -> %海域功勋
            NewPs = lib_seacraft_extra_api:add_exploit(PlayerStatus, Exploit, {produce, gift}),
            [GiftInfo, NewPs, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GUILD_DRAGON_MAT, _, GGragonVal} -> %% 公会龙魂
            mod_guild_boss:add_gboss_mat(PlayerStatus#player_status.id, PlayerStatus#player_status.guild#status_guild.id, GGragonVal, gift),
            [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GUILD_PRESTIGE, _, Num} -> %% 公会声望
            mod_guild_prestige:add_prestige([PlayerStatus#player_status.id, gift, ?GOODS_ID_GUILD_PRESTIGE, Num, 0]),
            [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_FASHION_NUM, PosId, Num} -> %% 时装精华
            NewGoodsStatus = lib_fashion:fashion_add_upgrade_num(PosId, Num, GoodsStatus),
            [GiftInfo, PlayerStatus, NewGoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_RUNE, _, Num} -> %% 符文经验
            NewGoodsStatus = lib_rune:add_rune_point(Num, GoodsStatus),
            [GiftInfo, PlayerStatus, NewGoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_SOUL, _, Num} -> %% 聚魂经验
            NewGoodsStatus = lib_soul:add_soul_point(Num, GoodsStatus),
            [GiftInfo, PlayerStatus, NewGoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_RUNE_CHIP, _, Num} -> %% 符文碎片
            NewGoodsStatus = lib_rune:add_rune_chip(Num, GoodsStatus),
            [GiftInfo, PlayerStatus, NewGoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_CURRENCY, CurrencyId, Num} ->
            NewPS = lib_goods_util:add_currency(PlayerStatus, CurrencyId, Num),
            [GiftInfo, NewPS, GoodsStatus, Bind, IsFetchGoods, GoodsList];
        {?TYPE_GOODS, GoodsTypeId, GoodsNum} -> %% 物品
            GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
            case is_record(GoodsTypeInfo, ets_goods_type) of
                true  -> skip;
                false -> ?ERR("important bug, need to tell plotter the  badrecord goodsTypeId=~p, giftId=~p", [GoodsTypeId, GiftInfo#ets_gift.goods_id])
            end,
            NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
            if
                GiftInfo#ets_gift.bind =/= 0 -> GoodsInfo = NewInfo#goods{bind=?BIND};
                Bind > 0 -> GoodsInfo = NewInfo#goods{bind=?BIND};
                true -> GoodsInfo = NewInfo#goods{bind=?UNBIND}
            end,
            if
                IsFetchGoods =:= 0 ->
                    {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
                    lib_log_api:log_goods(use_gift, 0, GoodsTypeId, GoodsNum, PlayerStatus#player_status.id, lists:concat([GiftInfo#ets_gift.goods_id, "_", Bind])),
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, GoodsList];
                IsFetchGoods =:= 2 ->
                    {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
                    lib_log_api:log_goods(use_gift, 0, GoodsTypeId, GoodsNum, PlayerStatus#player_status.id, lists:concat([GiftInfo#ets_gift.goods_id, "_", Bind])),
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, GoodsList];
                true ->
                    NewStatus = GoodsStatus,
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, [Item|GoodsList]]
            end;
        {?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum} -> %% 绑定物品
            GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
            case is_record(GoodsTypeInfo, ets_goods_type) of
                true  -> skip;
                false -> ?ERR("important bug, need to tell plotter the  badrecord goodsTypeId=~p, giftId=~p", [GoodsTypeId, GiftInfo#ets_gift.goods_id])
            end,
            NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
            GoodsInfo = NewInfo#goods{bind=?BIND},
            if
                IsFetchGoods =:= 0 ->
                    {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
                    lib_log_api:log_goods(use_gift, 0, GoodsTypeId, GoodsNum, PlayerStatus#player_status.id, lists:concat([GiftInfo#ets_gift.goods_id, "_", 1])),
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, GoodsList];
                IsFetchGoods =:= 2 ->
                    {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
                    lib_log_api:log_goods(use_gift, 0, GoodsTypeId, GoodsNum, PlayerStatus#player_status.id, lists:concat([GiftInfo#ets_gift.goods_id, "_", 1])),
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, GoodsList];
                true ->
                    NewStatus = GoodsStatus,
                    [GiftInfo, PlayerStatus, NewStatus, Bind, IsFetchGoods, [Item|GoodsList]]
            end;
        %% {gift, GiftId} -> %% 礼包
        %%     lib_gift_util:add_gift(PlayerStatus#player_status.id, GiftId, 1),
        %%     GiftList = [GiftId | GoodsStatus#goods_status.gift_list],
        %%     NewStatus = GoodsStatus#goods_status{gift_list = GiftList},
        %%     [PlayerStatus, NewStatus, Bind, IsFetchGoods, GoodsList];
        _ ->
            [GiftInfo, PlayerStatus, GoodsStatus, Bind, IsFetchGoods, GoodsList]
    end.


%% 向玩家添加物品列表
give_reward_item(Item, [Type, GoodsId, PlayerStatus, GoodsStatus, Bind, GiveList]) ->
    case Item of
        %% 加经验
        {?TYPE_EXP, _, Exp} ->
            NewPlayerStatus = lib_player:add_exp(PlayerStatus, Exp),
            [Type, GoodsId, NewPlayerStatus, GoodsStatus, Bind, [Item|GiveList]];
        %% 元宝
        {?TYPE_GOLD, _, Gold} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Gold, gold),
            %% 写货币日志
            lib_log_api:log_produce(Type, gold, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GoodsId, ", Money=", Gold])),
            [Type, GoodsId, NewPlayerStatus, GoodsStatus, Bind, [Item|GiveList]];
        %% 绑定元宝
        {?TYPE_BGOLD, _, Silver} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Silver, bgold),
            %% 写货币日志
            lib_log_api:log_produce(Type, gold, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GoodsId, ", Money=", Silver])),
            [Type, GoodsId, NewPlayerStatus, GoodsStatus, Bind, [Item|GiveList]];
        %% 金币
        {?TYPE_COIN, _, Coin} ->
            NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Coin, coin),
            %% 写货币日志
            lib_log_api:log_produce(Type, coin, PlayerStatus, NewPlayerStatus, lists:concat(["GiftId=", GoodsId, ", Money=", Coin])),
            [Type, GoodsId, NewPlayerStatus, GoodsStatus, Bind, [Item|GiveList]];
        %% 物品
        {?TYPE_GOODS, GoodsTypeId, GoodsNum} ->
            GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
            case is_record(GoodsTypeInfo, ets_goods_type) of
                true  -> skip;
                false -> ?ERR("[GIFT_ERROR]: player_id:~p, goodsTypeId=~p, GiftId=~p~n", [PlayerStatus#player_status.id, GoodsTypeId, GoodsId])
            end,
            NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
            case Bind > 0 of
                true -> GoodsInfo = NewInfo#goods{bind=?BIND};
                false -> GoodsInfo = NewInfo#goods{bind=?UNBIND}
            end,
            {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
            [Type, GoodsId, PlayerStatus, NewStatus, Bind, [Item|GiveList]];
        {?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum} -> %% 绑定物品
            GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
            case is_record(GoodsTypeInfo, ets_goods_type) of
                true  -> skip;
                false -> ?ERR("[GIFT_ERROR]: player_id:~p, goodsTypeId=~p, GiftId=~p~n", [PlayerStatus#player_status.id, GoodsTypeId, GoodsId])
            end,
            NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
            GoodsInfo = NewInfo#goods{bind=?BIND},
            {ok, {NewStatus, _}} = lib_goods:add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo),
            [Type, GoodsId, PlayerStatus, NewStatus, Bind, [Item|GiveList]];
        _ ->
            [Type, GoodsId, PlayerStatus, GoodsStatus, Bind, GiveList]
    end.

%% 整理日志备注内容
pack_get_log_about(GiftList) ->
    F = fun(Item, List) ->
                case Item of
                    {?TYPE_GOODS, Id, Num} -> [{Id, Num}|List];
                    {?TYPE_BIND_GOODS, Id, Num} -> [{Id, Num}|List];
                    {?TYPE_COIN, _Id, Num} -> [{?GOODS_ID_COIN, Num}|List];
                    {?TYPE_GOLD, _Id, Num} -> [{?GOODS_ID_GOLD, Num}|List];
                    {?TYPE_BGOLD, _Id, Num} -> [{?GOODS_ID_BGOLD, Num}|List];
                    {?TYPE_EXP, _Id, Num} -> [{?GOODS_ID_EXP, Num}|List];
                    {?TYPE_GFUNDS, _Id, Num} -> [{?GOODS_ID_GFUNDS, Num}|List];
                    {?TYPE_GDONATE, _Id, Num} -> [{?GOODS_ID_GDONATE, Num}|List];
                    {?TYPE_SEA_EXPLOIT, _Id, Num} -> [{?GOODS_ID_SEA_EXPLOIT, Num}|List];
                    {?TYPE_GUILD_DRAGON_MAT, _Id, Num} -> [{?GOODS_ID_GDRAGON_MAT, Num}|List];
                    {?TYPE_GUILD_PRESTIGE, _Id, Num} -> [{?GOODS_ID_GUILD_PRESTIGE, Num}|List];
                    {?TYPE_FASHION_NUM, PosId, Num} -> [{?GOODS_ID_FASHION_NUM(PosId), Num}|List];
                    {?TYPE_RUNE, _Id, Num} -> [{?GOODS_ID_RUNE, Num}|List];
                    {?TYPE_SOUL, _Id, Num} -> [{?GOODS_ID_SOUL, Num}|List];
                    {?TYPE_RUNE_CHIP, _Id, Num} -> [{?GOODS_ID_RUNE_CHIP, Num}|List];
                    {?TYPE_CURRENCY, Id, Num} -> [{Id, Num}|List];
                    _R ->
                        ?ERR("unowkn item type:~p~n", [_R]),
                        List
                end
        end,
    lists:foldl(F, [], GiftList).

%% ================================= private fun =================================
get_gift_reward(PS, GoodsInfo, GiftInfo) ->
    FilterData = make_filter_data(PS, GoodsInfo, GiftInfo),
    [Lv, Sex, Career, Turn] = lib_gift_check:get_filter_items(GiftInfo#ets_gift.filter, FilterData, [0, 0, 0, 0]),
    GiftReward = data_gift:get_gift_reward(GiftInfo#ets_gift.goods_id, Lv, Sex, Career, Turn),
    GiftReward.

%% 计算礼包物品
calc_gift_goods(_Ps, GS, GiftReward, GiftInfo, Num) when is_record(GiftReward, ets_gift_reward) ->
    #goods_status{gift_list = GiftList} = GS,
    #ets_gift{goods_id = GiftId} = GiftInfo,
    #ets_gift_reward{fixed_gifts = FixedGifts, is_back = IsBack,
                     rand = Rand, rand_gifts = RandGift, first_gifts = FirstGift} = GiftReward,
    case lists:member(GiftId, GiftList) orelse FirstGift == [] of
        true -> %% 不是第一次打开 或者 FirstGift 为空
            NewFixedGifts = [{Type, GId, GN*Num} || {Type, GId, GN} <- FixedGifts],
            calc_rand_goods_nums(RandGift, Rand, IsBack, NewFixedGifts, Num);
        _ -> %% 第一次打开
            RewardAgain = case Num == 1 of
                true -> [];
                _ ->
                    NewFixedGifts = [{Type, GId, GN*(Num-1)} || {Type, GId, GN} <- FixedGifts],
                    calc_rand_goods_nums(RandGift, Rand, IsBack, NewFixedGifts, Num-1)
            end,
            FirstGift ++ RewardAgain
    end;
calc_gift_goods(Ps, _GS, _GiftReward, GiftInfo, _Num) ->
    ?ERR("calc_gift_goods err player_id:~p, gift_id:~p  ~n", [Ps#player_status.id, GiftInfo#ets_gift.goods_id]),
    [].

%% 多次开启
calc_rand_goods_nums(_RandGift, _Rand, _IsBack, Gifts, 0) -> Gifts;
calc_rand_goods_nums(RandGift, Rand, IsBack, Gifts, Num) ->
    NewGifts = calc_rand_goods(RandGift, Rand, IsBack, Gifts),
    calc_rand_goods_nums(RandGift, Rand, IsBack, NewGifts, Num-1).

%% 单次计算礼包的随机物品
calc_rand_goods([], _RandNum, _IsBack, Goods)-> Goods;
calc_rand_goods(_RandGift, 0, _IsBack, Goods)-> Goods;
calc_rand_goods(RandGift, RandNum, IsBack, Goods)->
    TotalRatio = lib_goods_util:get_ratio_total(RandGift, 2),
    Rand = urand:rand(1, TotalRatio),
    case lib_goods_util:find_ratio(RandGift, 0, Rand, 2) of
        null ->
            calc_rand_goods(RandGift, RandNum-1, IsBack, Goods);
        {G, _R} = Gift ->
            NewRandGift = ?IF(IsBack == 0, RandGift -- [Gift], RandGift),
            calc_rand_goods(NewRandGift, RandNum-1, IsBack, [G|Goods])
    end.

%% 发送获得物品信息给客户端显示在右下角
send_goods_notice_msg(PS, GiveList) ->
    F = fun(Item, Data) ->
                case Item of
                    {?TYPE_GOODS, GoodsTypeId, GoodsNum} ->
                        [{GoodsTypeId, GoodsNum} | Data];
                    {?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum} ->
                        [{GoodsTypeId, GoodsNum} | Data];
                    {?TYPE_GOLD, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_GOLD, GoodsNum} | Data];
                    {?TYPE_COIN, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_COIN, GoodsNum} | Data];
                    {?TYPE_EXP, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_EXP, GoodsNum} | Data];
                    {?TYPE_GFUNDS, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_GFUNDS, GoodsNum} | Data];
                    {?TYPE_GDONATE, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_GDONATE, GoodsNum} | Data];
                    {?TYPE_GUILD_DRAGON_MAT, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_GDRAGON_MAT, GoodsNum} | Data];
                    {?TYPE_GUILD_PRESTIGE, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_GUILD_PRESTIGE, GoodsNum} | Data];
                    {?TYPE_FASHION_NUM, PosId, GoodsNum} ->
                        [{?GOODS_ID_FASHION_NUM(PosId), GoodsNum} | Data];
                    {?TYPE_RUNE, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_RUNE, GoodsNum} | Data];
                    {?TYPE_SOUL, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_SOUL, GoodsNum} | Data];
                    {?TYPE_RUNE_CHIP, _GoodsTypeId, GoodsNum} ->
                        [{?GOODS_ID_RUNE_CHIP, GoodsNum} | Data];
                    {goods, GoodsTypeId, GoodsNum} ->
                        [{GoodsTypeId, GoodsNum} | Data];
                    {coin, CoinNum} ->
                        CoinId = ?GOODS_ID_COIN,
                        [{CoinId, CoinNum} | Data];
                    {gold, GoldNum} ->
                        GoldId = ?GOODS_ID_GOLD,
                        [{GoldId, GoldNum} | Data];
                    {bgold, GoldNum} ->
                        GoldId = ?GOODS_ID_BGOLD,
                        [{GoldId, GoldNum} | Data];
                    {exp, GoldNum} ->
                        GoldId = ?GOODS_ID_EXP,
                        [{GoldId, GoldNum} | Data];
                    _ ->
                        Data
                end
        end,
    NewList = lists:foldl(F, [], GiveList),
    case length(NewList) > 0 of
        true ->
            Type = 1, % 右下角飘字
            {ok, BinData} = pt_110:write(11060, [Type, NewList]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData);
        _ ->
            skip
    end.

%% 礼包传闻
private_get_valuable_send_tv(PS, Gift, GiftReward, GiveList, UpdateGoods) ->
    #ets_gift_reward{tv_goods_id = TvGoodIds} = GiftReward,
    Name = PS#player_status.figure#figure.name,
    send_gift_reward_tv(GiveList, Name, Gift#ets_gift.goods_id, TvGoodIds, UpdateGoods).

%% 礼包物品传闻
send_gift_reward_tv([], _, _, _, _) -> ok;
send_gift_reward_tv([{Type, GoodsTypeId, _Num}|T], Name, GiftId, TvGoodIds, UpdateGoodsList)
  when Type == ?TYPE_GOODS; Type == ?TYPE_BIND_GOODS ->
    case lists:member(GoodsTypeId, TvGoodIds) of
        false -> ok;
        true ->
            case lists:keyfind(GoodsTypeId, #goods.goods_id, UpdateGoodsList) of
                false -> ok;
                #goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
                    Attr = data_attr:unified_format_extra_attr(OExtraAttr, []),
                    StringAttr = util:term_to_string(Attr),
                    lib_chat:send_TV({all}, ?MOD_GOODS, 5, [Name, GiftId, GoodsTypeId, Rating, StringAttr])
            end
    end,
    send_gift_reward_tv(T, Name, GiftId, TvGoodIds, UpdateGoodsList);
send_gift_reward_tv([_|T], Name, GiftId, TvGoodIds, UpdateGoodsList) -> send_gift_reward_tv(T, Name, GiftId, TvGoodIds, UpdateGoodsList).

%% 获取礼包领取状态
%% 返回：-1未领取（未插入记录），0未领取（已经插入记录），1已经领取
get_gift_fetch_status(RoleId, GiftId) ->
    CacheKey = ?GIFT_CACHE_KEY(RoleId, GiftId),
    Result = mod_daily_dict:get_special_info(CacheKey),
    case Result of
        undefined ->
            Sql = io_lib:format(?SQL_GIFT_LIST_FETCH_ROW, [RoleId, GiftId]),
            case db:get_row(Sql) of
                [] ->
                    mod_daily_dict:set_special_info(CacheKey, -1),
                    -1;
                [_, _, Status] ->
                    %% Status 0为未领取，1为领取
                    mod_daily_dict:set_special_info(CacheKey, Status),
                    Status
            end;
        Data ->
            Data
    end.

%% 更新礼包为领取状态（修改表并加缓存）
update_to_received(GS, PlayerId, GiftId) ->
    #goods_status{gift_list = GiftList} = GS,
    case lists:member(GiftId, GiftList) of
        true ->
            update_to_received(PlayerId, GiftId),
            GS;
        _ ->
            trigger_finish(PlayerId, GiftId),
            NewGiftList = [GiftId|GiftList],
            GS#goods_status{gift_list = NewGiftList}
    end.

update_to_received(PlayerId, GiftId) ->
    Sql = io_lib:format(?SQL_GIFT_LIST_UPDATE_TO_RECEIVED, [utime:unixtime(), PlayerId, GiftId]),
    db:execute(Sql),
    set_gift_fetch_status(PlayerId, GiftId, 1).

%% 设置礼包领取状态
set_gift_fetch_status(RoleId, GiftId, Status) ->
    mod_daily_dict:set_special_info(?GIFT_CACHE_KEY(RoleId, GiftId), Status).

%% 触发达成礼包，状态为未领取奖励
trigger_fetch(RoleId, GiftId) ->
    Now = utime:unixtime(),
    Sql = io_lib:format(?SQL_GIFT_LIST_INSERT, [RoleId, GiftId, Now, Now, 0, 0]),
    db:execute(Sql),
    mod_daily_dict:set_special_info(?GIFT_CACHE_KEY(RoleId, GiftId), 0).

%% 触发达成礼包，状态为已经领取
trigger_finish(RoleId, GiftId) ->
    Now = utime:unixtime(),
    Sql = io_lib:format(?SQL_GIFT_LIST_INSERT, [RoleId, GiftId, Now, Now, 1, 1]),
    db:execute(Sql),
    mod_daily_dict:set_special_info(?GIFT_CACHE_KEY(RoleId, GiftId), 1).

%% 获取次数礼包配置的总次数 Type: total, day
get_count_gift_count(GoodsTypeId, Sex, Type) ->
    case lib_gift_new:get_count_gift(GoodsTypeId, Sex) of
        #base_count_gift{condition = Condition} ->
            case lists:keyfind(Type, 1, Condition) of
                {Type, Num} -> Num;
                _ -> 0
            end;
        _ -> 0
    end.

get_count_gift(GoodsTypeId, Sex) ->
    case data_optional_gift:get_count_gift(GoodsTypeId, Sex) of
        #base_count_gift{} = BaseCountGift -> BaseCountGift;
        _ ->
           data_optional_gift:get_count_gift(GoodsTypeId, 0)
    end.

make_filter_data(PS, GoodsInfo, GiftInfo) ->
    #player_status{figure = Figure} = PS,
    #figure{career = Career, sex = Sex, turn = Turn} = Figure,
    case GoodsInfo of
        #goods{other = #goods_other{optional_data = OptionalData}} ->
            case lists:keyfind(?GOODS_OTHER_SUBKEY_GIFT_LV, 1, OptionalData) of
                {_, PlayerLv} -> ok; _ -> PlayerLv = Figure#figure.lv
            end,
            case lists:keyfind(?GOODS_OTHER_SUBKEY_GIFT_RUNE, 1, OptionalData) of
                {_, Rune} -> ok; _ -> Rune = lib_dungeon_rune:get_dungeon_level(PS)
            end,
            case lists:keyfind(?GOODS_OTHER_SUBKEY_GIFT_OPEN_DAY, 1, OptionalData) of
                {_, OpenDay} -> ok; _ -> OpenDay = util:get_open_day()
            end,
            ModLevel = get_mod_level(PS, GiftInfo);
        _ ->
            PlayerLv = Figure#figure.lv,  Rune = lib_dungeon_rune:get_dungeon_level(PS), OpenDay = util:get_open_day(),
            ModLevel = get_mod_level(PS, GiftInfo)
    end,
    #filter_gift_data{
        lv = PlayerLv, sex = Sex, career = Career, turn = Turn, rune = Rune, open_day = OpenDay, mod_level = ModLevel
    }.

is_lv_gift(GoodsTypeId) ->
    case data_gift:get(GoodsTypeId) of
        #ets_gift{filter = Filter} -> lists:member(lv, Filter);
        _ -> false
    end.

is_rune_gift(GoodsTypeId) ->
    case data_gift:get(GoodsTypeId) of
        #ets_gift{filter = Filter} -> lists:member(rune, Filter);
        _ -> false
    end.

is_open_day_gift(GoodsTypeId) ->
    case data_gift:get(GoodsTypeId) of
        #ets_gift{filter = Filter} -> lists:member(open_day, Filter);
        _ -> false
    end.

get_mod_level(PS, GiftInfo) ->
    case data_goods_type:get(GiftInfo#ets_gift.goods_id) of
        #ets_goods_type{type = ?GOODS_TYPE_GIFT, subtype = ?GOODS_GIFT_STYPE_EUDEMONS_LAND} ->
            lib_eudemons_land:get_eudemons_land_level(PS);
        #ets_goods_type{type = ?GOODS_TYPE_GIFT, subtype = ?GOODS_GIFT_STYPE_CONSTELLATION} ->
            lib_constellation_equip:get_role_active_constellation(PS);
        _ ->
            0
    end.