%%%--------------------------------------
%%% @Module  : lib_mystery_shop
%%% @Author  : zengzy 
%%% @Created : 2017-11-28
%%% @Description:  神秘商店
%%%--------------------------------------
-module(lib_mystery_shop).
-compile(export_all).
-export([]).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("goods.hrl").
-include("relationship.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("attr.hrl").

%% ---------------------------------- 管理进程 -----------------------------------
init() ->
    State = init_state(),
    State.

%%  初始化上
init_state() ->
%%    获取上架商品
    case db_mystery_shop_select() of
        [] ->
            init_refresh_state(#status_shop{});
        List ->
            GoodList = make_shop_goods(List, []),       % 更新物品
            ShopStatus = #status_shop{shop_goods = GoodList},
            %%判断是否有未开启的
            init_refresh_state(ShopStatus)
    end.

make_shop_goods([], GoodList) -> GoodList;
make_shop_goods([Info | T], GoodList) ->
    [Type, Career, Sells, LastTime] = Info,
    TypeList = data_shop:get_shop_type_list(),
    case lists:member({Type, Career}, TypeList) of
        true ->
            Now = utime:unixtime(),
            {Time, Refresh} = lib_mystery_shop:get_shop_refresh_time(Type, Career, LastTime),
            ShopGoods = case Time > Now of
                            true ->
                                SellList = util:bitstring_to_term(Sells),
                                Ref = erlang:send_after((Time - Now) * 1000, self(), {Type, Career, refresh_sell}),
                                #shop_goods{key = {Type, Career}, type = Type, career = Career, sell_list = SellList, last_sell_time = LastTime, ref = Ref};
                            false ->
                                SellList = init_sell_good(Type, Career),
                                Ref = erlang:send_after(Refresh * 1000, self(), {Type, Career, refresh_sell}),
                                SellList =/= [] andalso db_mystery_shop_replace(Type, Career, SellList, Now),
                                #shop_goods{key = {Type, Career}, type = Type, career = Career, sell_list = SellList, last_sell_time = Now, ref = Ref}
                        end,
            make_shop_goods(T, [ShopGoods | GoodList]);
        false ->
            %%老配置数据 删除
            Sql = io_lib:format("delete from `mystery_shop_goods` where type=~p and career=~p", [Type, Career]),
            db:execute(Sql),
            make_shop_goods(T, GoodList)
    end.

%%初始化新一轮
init_refresh_state(ShopStatus) ->
    TypeList = data_shop:get_shop_type_list(),
    {NShopStatus, DeleteType} = init_refresh_state_help(TypeList, ShopStatus, []),
    spawn(fun() -> db_delete_type(DeleteType) end),
    NShopStatus.

%% 循环所有的    {Type,Career}
init_refresh_state_help([], ShopStatus, DeleteType) -> {ShopStatus, DeleteType};
init_refresh_state_help([{Type, Career} = Key | T], ShopStatus, DeleteType) ->
    #status_shop{shop_goods = GoodList, role_hit = RoleHit, role_buy = RoleBuy} = ShopStatus,
    case lists:keyfind(Key, #shop_goods.key, GoodList) of
        false ->
            SellList = init_sell_good(Type, Career),
            Now = utime:unixtime(),
            {_, Refresh} = lib_mystery_shop:get_shop_refresh_time(Type, Career, Now),
            Ref = erlang:send_after(Refresh * 1000, self(), {Type, Career, refresh_sell}),
            %%替换新列表
            SellList =/= [] andalso db_mystery_shop_replace(Type, Career, SellList, Now),
            NRoleHit = maps:remove(Type, RoleHit),
            NRoleBuy = maps:remove(Type, RoleBuy),
            Info = #shop_goods{key = {Type, Career}, type = Type, career = Career, sell_list = SellList, last_sell_time = Now, ref = Ref},
            NShopStatus = ShopStatus#status_shop{shop_goods = [Info | GoodList], role_hit = NRoleHit, role_buy = NRoleBuy},
            init_refresh_state_help(T, NShopStatus, [Type | lists:delete(Type, DeleteType)]);
        #shop_goods{} -> init_refresh_state_help(T, ShopStatus, DeleteType)   % 找到刷新state
    end.

%%获取新一轮类型商品
init_sell_good(Type, Career) ->
    List = data_shop:get_weight_good(Type, Career),   % 获取有权重的物品  [{weight,id,IsMust}]
%%    获取必然与随机的列表
    {List1, List2} = get_must_random(List),
    case lists:member(Type, ?SHOP_TYPE_CAREER) of
        true ->
            CommonList = data_shop:get_weight_good(Type, 0),
            {CommonList1, CommonList2} = get_must_random(CommonList),
            NList = List1 ++ CommonList1;
        false ->
            NList = List1,
            CommonList2 = 0
    end,
    MustList = List2 ++ CommonList2,
    MustNum = length(MustList),  % 必然出现的列表长度
    Discount = data_shop:get_goods_type_discount(Type, Career), % 类型有没有折扣
    ShowNum = data_shop:get_goods_show_num(Type, Career),       % 显示商品的数量
    MustSellList = get_weight_must_good(Discount, MustList, 0, []),
    RandSellList = get_weight_rand_good(Discount, NList, 0, [], max(0, ShowNum - MustNum)),
    MustSellList ++ RandSellList.

%%获取新一轮类型商品
init_sell_good(Type, Career, Lv) ->
    List = data_shop:get_special_lv(Lv, Type, Career),   % 获取有权重的物品  [{weight,id,IsMust}]
%%    获取必然与随机的列表
    {List1, List2} = get_must_random(List),
    case lists:member(Type, ?SHOP_TYPE_CAREER) of
        true ->
            CommonList = data_shop:get_special_lv(Lv, Type, 0),
            {CommonList1, CommonList2} = get_must_random(CommonList);
        false ->
            CommonList1 = [], CommonList2 = []
    end,
    MustList = CommonList2 ++ List2,
    NList = CommonList1 ++ List1,
    MustNum = length(MustList),  % 必然出现的列表长度
    Discount = data_shop:get_goods_type_discount(Type, Career), % 类型有没有折扣
    ShowNum = data_shop:get_goods_show_num(Type, Career),       % 显示商品的数量
    MustSellList = get_weight_must_good(Discount, MustList, 0, []),
    RandSellList = get_weight_rand_good(Discount, NList, 0, [], max(0, ShowNum - MustNum)),
    MustSellList ++ RandSellList.

%%    分离必然与随机的列表  return {随机，必然}
get_must_random(List) ->
    List1 = [{Weight, Id} || {Weight, Id, IsMust} <- List, IsMust == ?RANDOM],
    List2 = [Id || {_Weight, Id, IsMust} <- List, IsMust == ?MUST],
    {List1, List2}.

%%必然出现的商品
get_weight_must_good(DType, List, _Num, Result) when DType == ?DISCOUNT ->
    get_discount_weight_must_good(List, Result);
%%获取没折扣必然出现的商品
get_weight_must_good(DType, List, _Num, Result) when DType == ?NOT_DISCOUNT ->
    get_not_discount_weight_must_good(List, Result);
get_weight_must_good(_DType, _List, _Num, _Result) -> [].

%%有折扣价物品
get_discount_weight_must_good([], SellList) -> SellList;
get_discount_weight_must_good([Id | Least], SellList) ->
    #base_shop_good{old_price = Cost} = data_shop:get_mystery_goods(Id),
    [{_, _, OldPrice}] = Cost,
    {Discount, _} = util:find_ratio(data_shop:get_goods_discount(Id), 2),  % 随机折扣
    Price = umath:ceil(OldPrice * (Discount / 10)),
    get_discount_weight_must_good(Least, [{Id, Discount, Price} | SellList]).

%%无折扣价物品
get_not_discount_weight_must_good([], SellList) -> SellList;
get_not_discount_weight_must_good([Id | Least], SellList) ->
    #base_shop_good{old_price = Cost} = data_shop:get_mystery_goods(Id),
    [{_, _, OldPrice}] = Cost,
    get_not_discount_weight_must_good(Least, [{Id, 10, OldPrice} | SellList]).
%%--------------------------------
%%获取折扣随机商品
get_weight_rand_good(DType, List, _Num, Result, ShowNum) when DType == ?DISCOUNT ->
    get_discount_weight_rand_good(List, ShowNum, 0, Result);
%%获取没折扣随机商品
get_weight_rand_good(DType, List, _Num, Result, ShowNum) when DType == ?NOT_DISCOUNT ->
    get_not_discount_weight_rand_good(List, ShowNum, 0, Result);
get_weight_rand_good(_DType, _List, _Num, _Result, _ShowNum) -> [].

%%有折扣价物品
get_discount_weight_rand_good([], _MaxNum, _N, SellList) -> SellList;
get_discount_weight_rand_good(_List, MaxNum, MaxNum, SellList) -> SellList;
get_discount_weight_rand_good(List, MaxNum, N, SellList) ->
    {_, Id} = util:find_ratio(List, 1),         %  随机按权重取id
    #base_shop_good{old_price = Cost} = data_shop:get_mystery_goods(Id),
    [{_, _, OldPrice}] = Cost,
    {Discount, _} = util:find_ratio(data_shop:get_goods_discount(Id), 2),  % 随机折扣
    Price = umath:ceil(OldPrice * (Discount / 10)),
    NewList = lists:keydelete(Id, 2, List),
    get_discount_weight_rand_good(NewList, MaxNum, N + 1, [{Id, Discount, Price} | SellList]).

%%无折扣价物品
get_not_discount_weight_rand_good([], _MaxNum, _N, SellList) -> SellList;
get_not_discount_weight_rand_good(_List, MaxNum, MaxNum, SellList) -> SellList;
get_not_discount_weight_rand_good(List, MaxNum, N, SellList) ->
    {_, Id} = util:find_ratio(List, 1),
    NewList = lists:keydelete(Id, 2, List),
    #base_shop_good{old_price = Cost} = data_shop:get_mystery_goods(Id),
    [{_, _, OldPrice}] = Cost,
    get_not_discount_weight_rand_good(NewList, MaxNum, N + 1, [{Id, 10, OldPrice} | SellList]).

%%玩家登录加载
login(RoleId, Career, Lv, State) ->
    #status_shop{role_hit = RoleHit, role_buy = RoleBuy} = State,
    {NewRoleHit, NewRoleBuy} = login_help(RoleHit, RoleBuy, RoleId, Career, Lv),
    NewState = State#status_shop{role_hit = NewRoleHit, role_buy = NewRoleBuy},
    {noreply, NewState}.

%初始化手动刷新
login_help(RoleHit, RoleBuy, RoleId, Career, Lv) ->
    {NewRoleHit, NewRoleBuy} = 
    case db_mystery_shop_buy_select(RoleId) of
        [] -> 
            {RoleHit, RoleBuy};
        List ->
            make_handle_role(List, RoleHit, RoleBuy)
    end,
    case maps:get(?SHOP_TYPE_DRAGON, NewRoleHit, []) of %% 龙纹商城特殊处理
        [] -> 
            NCareer = trans_type_career(?SHOP_TYPE_DRAGON, Career),
            SellList = init_sell_good(?SHOP_TYPE_DRAGON, NCareer, Lv),
            NListSell = [{RoleId, SellList}],
            db_mystery_shop_buy_replace(RoleId, ?SHOP_TYPE_DRAGON, SellList, []),
            {maps:put(?SHOP_TYPE_DRAGON, NListSell, NewRoleHit), NewRoleBuy};
        _ ->
            {NewRoleHit, NewRoleBuy}
    end.

%%
make_handle_role([], RoleHit, RoleBuy) -> {RoleHit, RoleBuy};
make_handle_role([[RoleId, Type, SellList, BuyList] | T], RoleHit, RoleBuy) ->
    BList = util:bitstring_to_term(BuyList),
    SList = util:bitstring_to_term(SellList),
    case SList =/= [] of
        true ->
            ListSell = maps:get(Type, RoleHit, []),
            NListSell = [{RoleId, SList} | lists:keydelete(RoleId, 1, ListSell)],
            NRoleHit = maps:put(Type, NListSell, RoleHit);
        false ->
            NRoleHit = RoleHit
    end,
    ListBuy = maps:get(Type, RoleBuy, []),
    NListBuy = [{RoleId, BList} | lists:keydelete(RoleId, 1, ListBuy)],
    NRoleBuy = maps:put(Type, NListBuy, RoleBuy),
    make_handle_role(T, NRoleHit, NRoleBuy).

%%玩家退出
logout(RoleId, State) ->
    #status_shop{role_hit = RoleHit, role_buy = RoleBuy} = State,
    TypeList = data_shop:get_shop_type_list(),
    {NewRoleHit, NewRoleBuy} = logout_help(TypeList, RoleId, RoleHit, RoleBuy),
    NewState = State#status_shop{role_hit = NewRoleHit, role_buy = NewRoleBuy},
    {noreply, NewState}.

logout_help([], _RoleId, RoleHit, RoleBuy) -> {RoleHit, RoleBuy};
logout_help([{Type, _} | T], RoleId, RoleHit, RoleBuy) ->
    HitList = maps:get(Type, RoleHit, []),
    NHistList = lists:keydelete(RoleId, 1, HitList),
    NRoleHit = maps:put(Type, NHistList, RoleHit),
    BuyList = maps:get(Type, RoleBuy, []),
    NBuyList = lists:keydelete(RoleId, 1, BuyList),
    NRoleBuy = maps:put(Type, NBuyList, RoleBuy),
    logout_help(T, RoleId, NRoleHit, NRoleBuy).

%% 刷新商店
refresh_sell(Type, Career, State) ->
    #status_shop{shop_goods = GoodList} = State,
    NGoodList = lists:keydelete({Type, Career}, #shop_goods.key, GoodList),
    NewState = init_refresh_state(State#status_shop{shop_goods = NGoodList}),
    {noreply, NewState}.

%%  首页
shop_main_show(RoleId, Type, Career, HitNum, TurnStage, Lv, State) ->
    #status_shop{shop_goods = GoodList, role_buy = RoleBuy, role_hit = RoleHit} = State,
    HitList = maps:get(Type, RoleHit, []),
    NCareer = trans_type_career(Type, Career),
    case lists:keyfind({Type, NCareer}, #shop_goods.key, GoodList) of
        false -> NewRoleHit = RoleHit;
        #shop_goods{sell_list = ShopList, last_sell_time = LastTime} ->
            {Time, _} = lib_mystery_shop:get_shop_refresh_time(Type, NCareer, LastTime),
            SellList = 
            case lists:keyfind(RoleId, 1, HitList) of   %找到上架的商品
                false when Type == ?SHOP_TYPE_DRAGON ->
                    SellL = init_sell_good(?SHOP_TYPE_DRAGON, NCareer, Lv),
                    NListSell = [{RoleId, SellL}|HitList],
                    NewRoleHit = maps:put(?SHOP_TYPE_DRAGON, NListSell, RoleHit),
                    db_mystery_shop_buy_replace(RoleId, ?SHOP_TYPE_DRAGON, SellL, []),
                    SellL;
                false -> 
                    NewRoleHit = RoleHit, ShopList;
                {_, SList} -> 
                    NewRoleHit = RoleHit, SList
            end,
            BuyList = maps:get(Type, RoleBuy, []),
            SendList = make_send_sell_list(RoleId, BuyList, SellList, TurnStage, Lv),
            {ok, BinData} = pt_153:write(15305, [Type, Time, HitNum, SendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State#status_shop{role_hit = NewRoleHit}}.

%%手动刷新
hit_refresh(RoleId, Type, Career, HitNum, TurnStage, Lv, State) ->
    #status_shop{shop_goods = GoodList, role_buy = RoleBuy, role_hit = RoleHit} = State,
    NCareer = trans_type_career(Type, Career),
    SellList = init_sell_good(Type, NCareer, Lv),
    case lists:keyfind({Type, NCareer}, #shop_goods.key, GoodList) of
        false -> Time = utime:unixtime();
        #shop_goods{last_sell_time = LastTime} ->
            {Time, _} = lib_mystery_shop:get_shop_refresh_time(Type, NCareer, LastTime)
    end,
    HitList = maps:get(Type, RoleHit, []),
    NHitList = lists:keystore(RoleId, 1, HitList, {RoleId, SellList}),
    NRoleHit = maps:put(Type, NHitList, RoleHit),
    BuyList = maps:get(Type, RoleBuy, []),
    case lists:keyfind(RoleId, 1, BuyList) of
        false -> _BList = [], NBuyList = BuyList;
        {_, _BList} -> NBuyList = lists:keydelete(RoleId, 1, BuyList)
    end,
    %%修改db数据库
    db_mystery_shop_buy_replace(RoleId, Type, SellList, []),
    NRoleBuy = maps:put(Type, NBuyList, RoleBuy),
    SendList = make_send_sell_list(RoleId, NBuyList, SellList, TurnStage, Lv),
%%    ?PRINT("15305 Type, Time, HitNum, SendList :~w~n", [[Type, Time, HitNum, SendList]]),
    {ok, BinData} = pt_153:write(15305, [Type, Time, HitNum, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewState = State#status_shop{role_buy = NRoleBuy, role_hit = NRoleHit},
    {noreply, NewState}.

%%  购买商品
buy_shop(RoleId, Type, Career, Id, Price, State) ->
    #status_shop{shop_goods = GoodList, role_buy = RoleBuy, role_hit = RoleHit} = State,
    HitList = maps:get(Type, RoleHit, []),
    {SType, SellList} =
        case lists:keyfind(RoleId, 1, HitList) of
            false ->
                NCareer = trans_type_career(Type, Career),
                #shop_goods{sell_list = SList} = lists:keyfind({Type, NCareer}, #shop_goods.key, GoodList),
                {2, SList};
            {_, SList1} -> {1, SList1}
        end,
    case lists:keyfind(Id, 1, SellList) of
        {_, _, SellPrice} ->  %有卖
            case SellPrice == Price of
                true ->
                    BuyList = maps:get(Type, RoleBuy, []),
                    case lists:keyfind(RoleId, 1, BuyList) of
                        false ->
                            NList = [{Id, 1}],
                            NBuyList = [{RoleId, NList} | BuyList],
                            NRoleBuy = maps:put(Type, NBuyList, RoleBuy),
                            NewState = State#status_shop{role_buy = NRoleBuy},
                            %%修改db数据库
                            case SType == 1 of
                                true -> db_mystery_shop_buy_replace(RoleId, Type, SellList, NList);
                                false -> db_mystery_shop_buy_replace(RoleId, Type, [], NList)
                            end,
                            Reply = true;
                        {_, OList} ->
                            case lists:keyfind(Id, 1, OList) of   % 判断是否买过
                                false ->
                                    NOList = [{Id, 1} | OList],
                                    NBuyList = lists:keyreplace(RoleId, 1, BuyList, {RoleId, NOList}),
                                    NRoleBuy = maps:put(Type, NBuyList, RoleBuy),
                                    NewState = State#status_shop{role_buy = NRoleBuy},
                                    %%修改db数据库
                                    case SType == 1 of
                                        true -> db_mystery_shop_buy_replace(RoleId, Type, SellList, NOList);
                                        false -> db_mystery_shop_buy_replace(RoleId, Type, [], NOList)
                                    end,
                                    Reply = true;
                                {Id, Num} ->
                                    #base_shop_good{limit = LimitNum} = data_shop:get_mystery_goods(Id),
                                    case Num >= LimitNum andalso LimitNum =/= 0 of
                                        false ->
                                            NOList = [{Id, Num + 1} | OList],
                                            NBuyList = lists:keyreplace(RoleId, 1, BuyList, {RoleId, NOList}),
                                            NRoleBuy = maps:put(Type, NBuyList, RoleBuy),
                                            NewState = State#status_shop{role_buy = NRoleBuy},
                                            %%修改db数据库
                                            case SType == 1 of
                                                true -> db_mystery_shop_buy_replace(RoleId, Type, SellList, NOList);
                                                false -> db_mystery_shop_buy_replace(RoleId, Type, [], NOList)
                                            end,
                                            Reply = true;
                                        true -> NewState = State,
                                            Reply = {false, ?ERRCODE(err153_not_enough_goods_to_buy)}
                                    end
                            end
                    end;
                false -> NewState = State, Reply = {false, ?ERRCODE(err153_price_err)}
            end;
        false -> NewState = State, Reply = {false, ?ERRCODE(err153_goods_not_on_sale)}
    end,
    ?PRINT("Reply:~p, [Type, Career, Id]:~p~n", [Reply,[Type, Career, Id]]),
    {reply, Reply, NewState}.

%%商品列表加状态
make_send_sell_list(RoleId, RoleBuy, SellList, TurnStage, Lv) ->
    BuyList = case lists:keyfind(RoleId, 1, RoleBuy) of
                  false -> [];
                  {_, List} -> List
              end,
    make_send_sell_list_help(BuyList, SellList, [], TurnStage, Lv).

%%make_send_sell_list_help([], SList, _Result, _, _) ->
%%
%%    [{Id, Discount, Price, 1, 0} || {Id, Discount, Price} <- SList];
make_send_sell_list_help(_List, [], Result, _, _) -> Result;
make_send_sell_list_help(List, [{Id, Discount, Price} | T], Result, TurnStage, Lv) ->
    case data_shop:get_mystery_goods(Id) of
        #base_shop_good{reborn = Reborn, day = OpenDay,
            role_lv = RoleLv, server_lv = ServerLv} ->
            ServerTime = util:get_open_day(),           %  开服天数
            WorldLv = util:get_world_lv(),              %  世界等级
            CheckList = [
                {check_enough_turn_stage, TurnStage, Reborn},
                {check_open_day, ServerTime, OpenDay},
                % {check_enough_lv, Lv, RoleLv},
                {check_world_lv, WorldLv, ServerLv}
            ],
            case lib_mystery_util:checklist(CheckList) of
                true ->
                    %%     从买过的商品取出购买数量
                    {Type, Number} =
                        case lists:keyfind(Id, 1, List) of
                            {Id, Num} -> {?HAS_BUY, Num};
                            false -> {?NOT_BUY, 0}
                        end,
                    make_send_sell_list_help(List, T, [{Id, Discount, Price, Type, Number} | Result], TurnStage, Lv);
                {false, _Err} ->
                    make_send_sell_list_help(List, T, Result, TurnStage, Lv)
            end;
        _ ->
            make_send_sell_list_help(List, T, Result, TurnStage, Lv)
    end.


%%判断是否分类型
trans_type_career(Type, Career) ->
    case lists:member(Type, ?SHOP_TYPE_CAREER) of
        true -> Career;
        false -> 0
    end.

%% ---------------------------------- 玩家进程 -----------------------------------
%% 玩家登陆
login(RoleId, Career, Lv) ->
    mod_mystery_shop:login(RoleId, Career, Lv),
    case db_shop_role_select(RoleId) of
        [] -> #status_func{};
        List ->
            Now = utime:unixtime(),
            F = fun([Type, HitNum, Time], TmpList) ->
                case utime:is_logic_same_day(Time) of
                    true -> [{Type, HitNum, Time} | TmpList];
                    false ->
                        db_shop_role_replace(RoleId, Type, 0, Now),
                        [{Type, 0, Now} | TmpList]
                end
                end,
            FuncList = lists:foldl(F, [], List),
            #status_func{func_list = FuncList}
    end.

%%玩家退出
logout(PS) ->
    mod_mystery_shop:logout(PS#player_status.id).

%%商店主页
shop_main_show(PS, Type) ->
    #player_status{id = RoleId, mystery_shop = StatusFunc, figure = #figure{lv = Lv, career = Career, turn_stage = TurnStage}} = PS,
    #status_func{func_list = FuncList} = StatusFunc,
    case lists:keyfind(Type, 1, FuncList) of
        false -> mod_mystery_shop:shop_main_show(RoleId, Type, Career, 0, TurnStage, Lv);
        {Type, HitNum, _} ->
            mod_mystery_shop:shop_main_show(RoleId, Type, Career, HitNum, TurnStage, Lv)
    end.

%%手动刷新
hit_refresh(PS, Type) ->
    #player_status{id = RoleId, figure = #figure{career = Career, lv = Lv, turn_stage = TurnStage}, mystery_shop = StatusFunc} = PS,
    #status_func{func_list = FuncList} = StatusFunc,
    HitNum = case lists:keyfind(Type, 1, FuncList) of
                 false -> 0;
                 {Type, Num, _} -> Num
             end,
    case data_shop:get_hit_cost(Type, HitNum + 1) of
        [CostGold, CostPaper] ->
            case CostPaper of
                {_, PaperId, CPaper} ->
                    [{_PaperId, PaperNum}] = lib_goods_api:get_goods_num(PS, [PaperId]),
                    MissCfg = false,
                    PaperEnough =   if
                                        PaperNum < CPaper ->
                                            false;
                                        true ->
                                            true
                                    end;
                _ ->
                    MissCfg = true,
                    PaperEnough = true
            end,
            NotEnough =
                case lib_goods_api:check_object_list(PS, [CostGold]) of
                    true -> false;
                    {false, _} -> true
                end,
            if
                NotEnough andalso PaperEnough == false -> {false, ?GOLD_NOT_ENOUGH};
                true ->
%%          优先消耗后面的物品
                    TureCost =
                        case PaperEnough == true andalso MissCfg == false of
                            true -> CostPaper;
                            false -> CostGold
                        end,
%%                    ?PRINT("TureCost :~p~n",[TureCost]),
                    case lib_goods_api:cost_object_list(PS, [TureCost], mystery_shop, "mystery_shop") of
                        {true, NewPS} ->
                            Now = utime:unixtime(),
                            mod_mystery_shop:hit_refresh(RoleId, Type, Career, HitNum + 1, TurnStage, Lv),
                            NFuncList = lists:keystore(Type, 1, FuncList, {Type, HitNum + 1, Now}),
                            NStatusFunc = StatusFunc#status_func{func_list = NFuncList},
                            %%修改db
                            db_shop_role_replace(RoleId, Type, HitNum + 1, Now),
%%                            ?PRINT("15306 Errcode~p~n",[?SUCCESS]),
                            {ok, BinData} = pt_153:write(15306, [?SUCCESS]),
                            lib_server_send:send_to_uid(RoleId, BinData),
                            {true, NewPS#player_status{mystery_shop = NStatusFunc}};
                        {false, _, _} ->
                            {false, ?GOLD_NOT_ENOUGH}
                    end
            end;
        _ -> {false, ?ERRCODE(err153_missing_config)}
    end.

%%购买商品
role_buy_shop(PS, Type, Id, Price) ->
    #player_status{id = RoleId, figure = #figure{career = Career, lv = Lv, turn_stage = TurnStage}} = PS,
    case data_shop:get_mystery_goods(Id) of
        #base_shop_good{
            goods = GoodList, old_price = OCost,
            reborn = Reborn, day = OpenDay,
            role_lv = RoleLv, server_lv = ServerLv} = Cfg ->
            ServerTime = util:get_open_day(),           %  开服天数
            WorldLv = util:get_world_lv(),              %  世界等级
            CheckList = [
                {check_enough_turn_stage, TurnStage, Reborn},
                {check_open_day, ServerTime, OpenDay},
                % {check_enough_lv, Lv, RoleLv},
                {check_world_lv, WorldLv, ServerLv},
                {check_shop_buy, PS, Cfg, Price}
            ],
            case lib_mystery_util:checklist(CheckList) of
                true ->
                    case catch mod_mystery_shop:buy_shop(RoleId, Type, Career, Id, Price) of
                        {false, Err} -> {false, Err};
                        true ->
                            Cost =
                                case Price == 0 of
                                    true -> OCost;
                                    false ->
                                        [{TypeId, GoodId, _}] = OCost,
                                        [{TypeId, GoodId, Price}]
                                end,
                            ?PRINT("COST:~p~n", [Cost]),
                            case lib_goods_api:cost_object_list(PS, Cost, mystery_shop, "mystery_shop") of
                                {true, NewPS} ->
                                    ?PRINT("15307 ~w~n", [[?SUCCESS, Type, Id]]),
                                    {ok, BinData} = pt_153:write(15307, [?SUCCESS, Type, Id]),
                                    lib_server_send:send_to_uid(RoleId, BinData),
                                    Produce = #produce{reward = GoodList, show_tips = 1, type = mystery_shop},
                                    LastPS = lib_goods_api:send_reward(NewPS, Produce),
                                    lib_mystery_util:log_shop_bag(RoleId, Id, Cost, GoodList),
                                    {true, LastPS};
                                {false, _, _} ->
                                    ?INFO("cost fail~p~n", [RoleId]),
                                    {false, ?FAIL}
                            end;
                        _ -> {false, ?FAIL}
                    end;
                {false, Err} -> {false, Err}
            end;
        [] -> {false, ?ERRCODE(err153_missing_config)}
    end.

%% ---------------------------------- db 函数 -----------------------------------
db_shop_role_select(RoleId) ->
    Sql = io_lib:format(?sql_mystery_shop_role_select, [RoleId]),
    db:get_all(Sql).

db_shop_role_replace(RoleId, Type, Num, Time) ->
    Sql = io_lib:format(?sql_mystery_shop_role_replace, [RoleId, Type, Num, Time]),
    db:execute(Sql).

db_mystery_shop_select() ->
    Sql = io_lib:format(?sql_mystery_shop_goods_select, []),
    db:get_all(Sql).

db_mystery_shop_replace(Type, Career, SellList, Time) ->
    LSList = util:term_to_bitstring(SellList),
    Sql = io_lib:format(?sql_mystery_shop_goods_replace, [Type, Career, LSList, Time]),
    db:execute(Sql).

db_mystery_shop_buy_select(RoleId) ->
    Sql = io_lib:format(?sql_mystery_shop_buy_select, [RoleId]),
    db:get_all(Sql).

db_mystery_shop_buy_replace(RoleId, Type, SellList, BuyList) ->
    LSList = util:term_to_bitstring(SellList),
    BSList = util:term_to_bitstring(BuyList),
    Sql = io_lib:format(?sql_mystery_shop_buy_replace, [RoleId, Type, LSList, BSList]),
    db:execute(Sql).

db_mystery_shop_buy_delete(Type) ->
    Sql = io_lib:format("delete from `mystery_shop_buy` where type=~p ", [Type]),
    db:execute(Sql).

db_delete_type([]) -> ok;
db_delete_type([Type | T]) ->
    db_mystery_shop_buy_delete(Type),
    db_delete_type(T).

get_shop_refresh_time(Type, Career, LastTime) ->
    get_shop_refresh_time(Type, Career, utime:unixtime(), LastTime).
get_shop_refresh_time(Type, Career, NowTime, LastTime) ->
    case data_shop:get_shop_refresh_time(Type, Career) of
        TimeList when is_list(TimeList) andalso TimeList =/= [] ->
            % NowTime = utime:unixtime(),
            case get_next_time(NowTime, TimeList) of %%获取开启时间段中第一个大于nowtime的时间
                Refresh when is_integer(Refresh) ->
                    {Refresh + NowTime, Refresh};
                _ ->
                    ?ERR("data_shop get_shop_refresh_time MissCfg TimeList:~p ~n",[TimeList]),
                    {0, 0}
            end;
        Refresh when is_integer(Refresh) -> {LastTime + Refresh, Refresh};
        _ -> {0, 0}
    end.



get_next_time(NowTime, TimeList) ->
    {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime),
    case get_next_time_core({NowSH, NowSM, NowSS}, TimeList) of
        {ok, {SH, SM, SS}} ->
            TemTime = utime:unixtime({_D, {SH, SM, SS}}),
            % ?PRINT("1 TemTime:~p, NowTime:~p~n",[TemTime, NowTime]),
            max(TemTime-NowTime, 1);
        _ ->
            NowDate = utime:unixdate(NowTime),
            {_D1,{NowSH1,NowSM1, NowSS1}} = utime:unixtime_to_localtime(NowDate+86400),
            case get_next_time_core({NowSH1, NowSM1, NowSS1}, TimeList) of
                {ok, {SH, SM, SS}} ->
                    TemTime = utime:unixtime({_D1, {SH, SM, SS}}),
                    % ?PRINT("2 TemTime:~p, NowTime:~p~n",[TemTime, NowTime]),
                    max(TemTime-NowTime, 1);
                _ -> 0
            end
    end.


get_next_time_core({TemSH, TemSM, TemSS}, TimeList) ->
    Tem = (TemSH * 60 + TemSM) * 60 + TemSS,
    Fun = fun({SH, SM, SS}) ->
        Tem =< (SH * 60 + SM) * 60 + SS
    end,
    ulists:find(Fun, TimeList).
