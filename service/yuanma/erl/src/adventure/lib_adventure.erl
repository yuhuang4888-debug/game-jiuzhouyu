%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2019 22:08
%%%-------------------------------------------------------------------
-module(lib_adventure).
-author("whao").

%% API
-include("common.hrl").
-include("server.hrl").
-include("hero_halo.hrl").
-include("figure.hrl").
-include("adventure.hrl").
-include("predefine.hrl").
-include("chat.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("counter_global.hrl").


-compile(export_all).

%% ---------------------------------- 登录 -----------------------------------
login(RoleId) ->
    CurStage = lib_adventure_util:get_act_stage(), % 当前活动期数
    NewAdven =
        case lib_adventure_util:db_adventure_select(RoleId) of
            [] ->
                Adven = #status_adventure{stage = CurStage},
                fix_adven_shop(RoleId, [], 0, Adven);
            Info ->
                [Stage, Circle, Location, GLucky, ShopGoods, LastTime] = Info,
                GainLoc = util:bitstring_to_term(GLucky),
                NewShopGoods = util:bitstring_to_term(ShopGoods),
                ThrowTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_THROW_NUM),
                Adven = if
                    CurStage =/= Stage ->
                        #status_adventure{stage = CurStage, circle = ?INIT_CIRCLE, location = ?INIT_LOCATION, gain_list = []};
                    ThrowTimes == 0 ->
                        #status_adventure{stage = Stage, circle = ?INIT_CIRCLE, location = ?INIT_LOCATION, gain_list = []};
                    true ->
                        #status_adventure{stage = Stage, circle = Circle, location = Location, gain_list = GainLoc}
                end,
                fix_adven_shop(RoleId, NewShopGoods, LastTime, Adven)
        end,
    NewAdven.


%% 冒险商城登录
fix_adven_shop(RoleId, ShopGoods, LastTime, Adven) ->
    NowTime = utime:unixtime(),
    NewAdven =
        case utime:is_same_day(NowTime, LastTime) of
            true ->
                Adven#status_adventure{shop_goods = ShopGoods, last_time = NowTime};
            false ->
                NewShopGoods = refresh_adven_shop(1),
                Adven#status_adventure{shop_goods = NewShopGoods, last_time = NowTime}
        end,
    lib_adventure_util:db_adventure_replace(RoleId, NewAdven),
    NewAdven.


%%%% ---------------------------------- 登录end --------------------------------

%% 获得到达最远的格子
get_max_location(Location, BackLocation) ->
    case BackLocation == [] of
        true -> Location;
        false ->
            BackMax = lists:max(BackLocation),
            max(Location, BackMax)
    end.

%% ---------------------------------- 投骰子 ---------------------------------
adventure_throw(IsCheap, PS) ->
    #player_status{id = RoleId, status_adventure = StatusAdven} = PS,
    #status_adventure{stage = Stage, circle = Circle, location = Location, gain_list = GainList} = StatusAdven,
    case lib_adventure_util:is_open(data_adventure:get_adventure_info(Stage)) of
        false ->
            {false, ?ERRCODE(err427_act_not_open)};  % 没有开启
        _ ->
            ThrowTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_THROW_NUM),
            ExtraFreeTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_THROW_NUM),
            NewThrowTimes = max(ThrowTimes-ExtraFreeTimes, 0) + 1, % 当前投掷次数先减去额外免费次数再拿来算消耗
            #adventure_rand_cfg{cost = Cost, weight = Weight} = data_adventure:get_adventure_rand(NewThrowTimes),
            %% 投骰子消耗
            NewCost = get_adventure_throw_cost(IsCheap, Cost),
            %% 扣除物品，不够自动购买
            case lib_goods_api:cost_objects_with_auto_buy(PS, NewCost, adventure_throw, "") of
                {true, NewPS, LastCost} ->
                    Point = urand:rand_with_weight(Weight), % 点数
                    NewLocation = ?IF(Point + Location > ?MAX_LOCATION, ?MAX_LOCATION, Point + Location),
                    StartLoc = ?IF(Location == ?MAX_LOCATION, ?MAX_LOCATION, Location + 1),
                    %% 更新数据
                    {GainReward, TrueReward} = get_adventure_throw_reward(Circle, Stage, NewLocation, StartLoc),
                    NewGainList = ulists:object_list_merge(GainList ++ TrueReward),
                    NewStatusAdven = StatusAdven#status_adventure{location = NewLocation, gain_list = NewGainList},
                    lib_adventure_util:db_adventure_replace(RoleId, NewStatusAdven),
                    lib_log_api:log_adventure_throw(RoleId, Stage, LastCost, Circle, Location, Circle, NewLocation, Point, TrueReward),
                    %% 增加次数
                    mod_daily:increment(RoleId, ?MOD_ADVENTURE, ?ADVEN_THROW_NUM),
                    %% 发送奖励
                    Produce = #produce{type = adventure_throw, reward = TrueReward},
                    NewPS1 = lib_goods_api:send_reward(NewPS, Produce),
                    NewPS2 = NewPS1#player_status{status_adventure = NewStatusAdven},
                    LastReward = ?IF(NewLocation == ?MAX_LOCATION, NewGainList, []),
                    {ok, NewPS2, Circle, NewLocation, max(0, NewLocation - Location), GainReward, LastReward};
                {false, Res, _} ->
                    {false, Res}
            end
    end.

%% 投骰子消耗
get_adventure_throw_cost(IsCheap, Cost) ->
    if
        Cost =:= [] ->
            [];
        IsCheap == 0 ->
            Cost;
        true ->
            [{_, _, GoldNum}] = Cost,
            CheapGoodsId = data_adventure:get_adventure_kv(1), % 物品
            GoodsByGold = data_adventure:get_adventure_kv(2), % 优惠劵抵用的钻石数量
            CheapGoodsNum = round(GoldNum / GoodsByGold),
            [{0, CheapGoodsId, CheapGoodsNum}]
    end.

%% 投骰子奖励
get_adventure_throw_reward(Circle, Stage, NewLocation, StartLoc) ->
    Fun = fun(LocationTmp, {ListTmp, GiftTmp}) ->
        AdvenType = data_adventure:get_adventure_loc(Stage, LocationTmp, Circle),
        RewardWeight = data_adventure:get_adventure_reward(Stage, AdvenType),
        Reward = urand:rand_with_weight(RewardWeight), %  权重计算的奖励
        DoubleWeight = data_adventure:get_adventure_kv(8),
        WeekDay = utime:day_of_week(), % 星期几
        {WeekDay, CountWeight} = lists:keyfind(WeekDay, 1, DoubleWeight),
        IsDouble = urand:rand_with_weight(CountWeight), % 倍数
        NewReward = [{GoodsTypeTmp, GoodsIdTmp, GoodsNumTmp * IsDouble} || {GoodsTypeTmp, GoodsIdTmp, GoodsNumTmp} <- Reward],
        {[{LocationTmp, IsDouble, NewReward} | ListTmp], NewReward ++ GiftTmp}
    end,
    lists:foldl(Fun, {[], []}, lists:seq(StartLoc, NewLocation)).

%% ---------------------------------- 投骰子end -----------------------------------



%% -------------------     重置骰子     --------------------------
adventure_reset(PS) ->
    #player_status{id = RoleId, status_adventure = StatusAdven, figure = #figure{vip_type = VipType, vip = Vip}} = PS,
    #status_adventure{stage = Stage, circle = Circle, location = Location} = StatusAdven,
    IsOpen = lib_adventure_util:is_open(data_adventure:get_adventure_info(Stage)),
    % vip等级相关的重置次数
    AllResetTimes = lib_vip_api:get_vip_privilege(?MOD_ADVENTURE, ?MOD_ADVENTURE_RESET_TIME, VipType, Vip),
    ResetTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_RESET_NUM),
    UseFreeTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_RESET_NUM),
    HaloExtraTimes = lib_hero_halo:get_halo_extra_times(PS, ?HALO_ADVENTURE_TIMES),
    if
        IsOpen =:= false ->
            {false, ?ERRCODE(err427_act_not_open)};
        ResetTimes >= AllResetTimes + HaloExtraTimes ->
            {false, ?ERRCODE(err427_no_reset_times)};
        Location =/= ?MAX_LOCATION ->
            {false, ?ERRCODE(err427_not_last_loc)};
        true ->
            ResetCost = data_adventure:get_adventure_kv(3),
            {_, TrueCost} =
                case (HaloExtraTimes - UseFreeTimes) > 0 of
                    true -> {0, []};
                    _ ->
                        lists:keyfind(ResetTimes + 1, 1, ResetCost)
                end,
            case lib_goods_api:cost_object_list_with_check(PS, TrueCost, adventure_reset, "") of
                {true, NewPS} ->
                    NewCircle = Circle + 1,
                    NewStatusAdven = StatusAdven#status_adventure{circle = NewCircle, location = ?INIT_LOCATION, gain_list = []},
                    lib_adventure_util:db_adventure_replace(RoleId, NewStatusAdven),
                    lib_log_api:log_adventure_throw(RoleId, Stage, TrueCost, Circle, Location, NewCircle, ?INIT_LOCATION, 0, []),
                    mod_daily:increment(RoleId, ?MOD_ADVENTURE, ?ADVEN_RESET_NUM),
                    TrueCost == [] andalso mod_daily:increment(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_RESET_NUM),
                    NewPS1 = NewPS#player_status{status_adventure = NewStatusAdven},
                    {ok, NewPS1, NewCircle};
                {false, Res, _} ->
                    {false, Res}
            end
    end.

%% -------------------     重置骰子 end    --------------------------

%% 增加当天额外免费投掷次数
add_extra_free_throw_times(Player, Count) ->
    #player_status{id = RoleId} = Player,
    mod_daily:plus_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_FREE_THROW_NUM, Count).

%% -------------------------  重置0点  ---------------------------

clear_daily(Player) ->
    #player_status{status_adventure = Adventure} = Player,
    CurStage = lib_adventure_util:get_act_stage(), % 当前活动期数
    NewAdventure = Adventure#status_adventure{stage = CurStage, circle = ?INIT_CIRCLE, location = ?INIT_LOCATION, gain_list = []},
    NewPlayer = Player#player_status{status_adventure = NewAdventure},
    pp_adventure:handle(42701, NewPlayer, []),
    NewPlayer.

%% 更新数据库
update_sql_clear() ->
    GLucky = util:term_to_bitstring([]),
    Sql = io_lib:format("update `adventure_role` set `circle` = ~p, `location` = ~p, gain_lucky = '~s' ", [?INIT_CIRCLE, ?INIT_LOCATION, GLucky]),
    db:execute(Sql).


%% -------------------    冒险商城   ------------------
%% 商城的界面
adven_shop_pack_goods(ShopGoods) ->
    Fun = fun({GoodsId, GoodsState}, PackListTmp) ->
        #adventure_shop_cfg{
            type = Type,
            reward = Reward,
            show_price = ShowPrice,
            price = Price,
            over_cheap = OverCheap
        } =
            data_adventure:get_adventure_shop(GoodsId),
        [{GoodsId, Type, Reward, ShowPrice, Price, OverCheap, GoodsState} | PackListTmp]
          end,
    lists:foldl(Fun, [], ShopGoods).

%% 商城购买
adven_shop_buy(GoodsId, Player) ->
    #player_status{id = RoleId, status_adventure = Adven} = Player,
    #status_adventure{stage = Stage, shop_goods = ShopGood} = Adven,
    IsOpen = lib_adventure_util:is_open(data_adventure:get_adventure_info(Stage)),
    case {IsOpen, lists:keyfind(GoodsId, 1, ShopGood)} of
        {false, _} ->
            {false, ?ERRCODE(err427_act_not_open)};
        {_, {GoodsId, ?ADVEN_SHOP_NOT_BUY}} ->
            #adventure_shop_cfg{type = Type, price = Price, reward = Reward} = data_adventure:get_adventure_shop(GoodsId),
            case Type == 0 of
                true ->
                    Produce = #produce{type = adven_shop, reward = Reward},
                    NewPlayer1 = lib_goods_api:send_reward(Player, Produce), % 发送奖励
                    NewShopGoods = lists:keystore(GoodsId, 1, ShopGood, {GoodsId, ?ADVEN_SHOP_HAS_BUY}),
                    NewAdven = Adven#status_adventure{shop_goods = NewShopGoods},
                    %% 更新数据库
                    lib_adventure_util:db_adventure_replace(RoleId, NewAdven),
                    lib_log_api:log_adventure_shop(RoleId, 1, [], Reward),
                    NewPlayer2 = NewPlayer1#player_status{status_adventure = NewAdven},
                    {ok, NewPlayer2};
                false ->
                    Cost = [{1, 0, Price}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, adven_shop, "") of
                        {true, NewPlayer} ->
                            Produce = #produce{type = adven_shop, reward = Reward},
                            NewPlayer1 = lib_goods_api:send_reward(NewPlayer, Produce), % 发送奖励
                            NewShopGoods = lists:keystore(GoodsId, 1, ShopGood, {GoodsId, ?ADVEN_SHOP_HAS_BUY}),
                            NewAdven = Adven#status_adventure{shop_goods = NewShopGoods},
                            %% 更新数据库
                            lib_adventure_util:db_adventure_replace(RoleId, NewAdven),
                            lib_log_api:log_adventure_shop(RoleId, 1, Cost, Reward),
                            NewPlayer2 = NewPlayer1#player_status{status_adventure = NewAdven},
                            {ok, NewPlayer2}
                        ;
                        {false, Res, _} ->
                            {false, Res}
                    end
            end;
        {_, {GoodsId, ?ADVEN_SHOP_HAS_BUY}} ->
            {false, ?ERRCODE(err427_shop_has_buy)};
        _ ->
            {false, ?ERRCODE(err427_shop_no_goods)}
    end.

%% 商城手动刷新
adven_shop_refresh(Player) ->
    #player_status{id = RoleId, status_adventure = Adven} = Player,
    RefreshTimes = mod_daily:get_count(RoleId, ?MOD_ADVENTURE, ?ADVEN_SHOP_RESET_NUM),
    NewRefreshTimes = RefreshTimes + 1,
    RefreshCost = data_adventure:get_adventure_shop_refresh(NewRefreshTimes),
    case lib_goods_api:cost_object_list_with_check(Player, RefreshCost, adven_shop, "") of
        {true, NewPlayer} ->
            NewShopGoods = refresh_adven_shop(0),
            mod_daily:increment(RoleId, ?MOD_ADVENTURE, ?ADVEN_SHOP_RESET_NUM),
            NowTime = utime:unixtime(),
            NewAdven = Adven#status_adventure{shop_goods = NewShopGoods, last_time = NowTime},
            %% 更新数据库
            lib_adventure_util:db_adventure_replace(RoleId, NewAdven),
            lib_log_api:log_adventure_shop(RoleId, 2, RefreshCost, NewShopGoods),
            NewPlayer1 = NewPlayer#player_status{status_adventure = NewAdven},
            NextRefreshCost = data_adventure:get_adventure_shop_refresh(NewRefreshTimes + 1),
            PackList = adven_shop_pack_goods(NewShopGoods),
            {ok, NewPlayer1, NewRefreshTimes, NextRefreshCost, PackList};
        {false, Res, _} ->
            {false, Res}
    end.

%% 自动刷新商城的商品 0: 手动 1：自动
refresh_adven_shop(IsAuto) ->
    RefreshCfg = % 刷新配置
    case IsAuto of
        1 ->
            data_adventure:get_adventure_kv(13);
        _ ->
            data_adventure:get_adventure_kv(14)
    end,
    AllShopType = data_adventure:get_adven_shop_type(),
    Fun = fun(TypeIdTmp, ShopGoodsTmp) ->
        case lists:keyfind(TypeIdTmp, 1, RefreshCfg) of
            {TypeIdTmp, GoodsNumTmp} ->
                AutoRefreshWeight = data_adventure:get_adventure_shop_weight(TypeIdTmp),
                GoodsListTmp = urand:list_rand_by_weight(AutoRefreshWeight, GoodsNumTmp),
                ShopGoodsTmp ++ GoodsListTmp;
            _ ->
                ShopGoodsTmp
        end
          end,
    AllShopGoods = lists:foldl(Fun, [], AllShopType),
    [{GoodsId, ?ADVEN_SHOP_NOT_BUY} || GoodsId <- AllShopGoods].

gm_reset_adventure_stage(Stage) ->
    spawn(fun() -> gm_reset_adventure_stage_do(Stage) end),
    ok.

gm_reset_adventure_stage_do(Stage) ->
    Sql = io_lib:format("select role_id, stage from adventure_role", []),
    case db:get_all(Sql) of
        [] -> ok;
        List ->
            F = fun([RoleId, OldStage], Acc) ->
                case OldStage =/= Stage of
                    true ->
                        case lib_player:get_alive_pid(RoleId) of
                            false ->
                                SqlRe = io_lib:format("update `adventure_role` set stage=~p where role_id=~p ", [Stage, RoleId]),
                                db:execute(SqlRe);
                            Pid ->
                                lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, gm_reset_adventure_stage_in_ps, [Stage])
                        end,
                        Acc rem 30 == 0 andalso timer:sleep(1000),
                        Acc+1;
                    _ ->
                        Acc
                end
            end,
            lists:foldl(F, 1, List)
    end.

gm_reset_adventure_stage_in_ps(PS, NewStage) ->
    #player_status{id = RoleId, status_adventure = StatusAdven} = PS,
    SqlRe = io_lib:format("update `adventure_role` set stage=~p where role_id=~p ", [NewStage, RoleId]),
    db:execute(SqlRe),
    {ok, PS#player_status{status_adventure = StatusAdven#status_adventure{stage = NewStage}}}.
