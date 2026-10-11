%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-29
%% Description: 仓库物品操作
%% --------------------------------------------------------
-module(lib_storage_util).
-compile(export_all).
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("sql_goods.hrl").
-include("server.hrl").
-include("sell.hrl").
-include ("errcode.hrl").



% 检查某个物品存入
check_movein_pos(PlayerStatus, GoodsStatus, GoodsInfo, ToPos) ->
    #player_status{id = RoleId, sell = Sell, storage_num = StoNum, cell_num = BagCell} = PlayerStatus,
    if
        %% 正在交易中
        Sell#status_sell.sell_status =/= 0  ->
            {fail, ?ERRCODE(err150_in_sell)};
        true ->
            case data_goods_type:get(GoodsInfo#goods.goods_id) of
                %% 物品类型不存在
                [] ->
                    {fail, ?ERRCODE(err150_no_goods_type)};
                _GoodsTypeInfo ->
                    AllGoods = lib_goods_util:get_goods_list(RoleId, ToPos, GoodsStatus#goods_status.dict),
                    UsedNum = length(AllGoods),
                    if
                        %% 背包
                        ToPos == ?GOODS_LOC_BAG andalso BagCell < (UsedNum + 1) ->
                            {fail, ?ERRCODE(err150_no_cell)};
                        %% 仓库
                        ToPos == ?GOODS_LOC_STORAGE andalso StoNum < (UsedNum + 1) ->
                            {fail, ?ERRCODE(err150_storage_no_cell)};
                        true ->
                            {ok, GoodsInfo}
                    end
            end
    end.

%% 物品存入某个位置
movein_pos(GoodsStatus, GoodsInfo, Location) ->
    F = fun() ->
                ok = lib_goods_dict:start_dict(),
                %% 修改物品的位置
                %[_NewGoodsInfo, NewGoodsStatus] = lib_goods:change_goods_cell(GoodsInfo, Location, 0, GoodsStatus),
                {ok, NewGoodsStatus, RewardResult} = lib_goods:move_a2b({GoodsInfo, Location}, GoodsStatus),
                %% 日志记录
                SuccGoods = maps:get(?REWARD_RESULT_SUCC, RewardResult, []),
                FailGoods = maps:get(?REWARD_RESULT_IGNOR, RewardResult, []),
                lib_log_api:log_move_goods(GoodsStatus#goods_status.player_id, GoodsInfo#goods.location, Location, SuccGoods, FailGoods),
                {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
                {ok, NewGoodsStatus#goods_status{dict = Dict}, UpGoods}
        end,
    lib_goods_util:transaction(F).

change_money_goods_to_money(GoodsStatus, GoodsInfo) ->
    F = fun() ->
            ok = lib_goods_dict:start_dict(),
            [NewGoodsStatus, _] = lib_goods:delete_one(GoodsInfo, [GoodsStatus, GoodsInfo#goods.num]),
            {Dict, _UpGoods} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
            MoneyList = change_money_goods_to_money_helper(GoodsInfo, GoodsInfo#goods.num),
            {ok, NewGoodsStatus#goods_status{dict = Dict}, MoneyList}
    end,
    lib_goods_util:transaction(F).
    
change_money_goods_to_money_helper(GoodsInfo, Num) ->
    case GoodsInfo#goods.subtype of 
        ?GOODS_SUBTYPE_GOLD -> [{?TYPE_GOLD, 0, Num}];
        ?GOODS_SUBTYPE_BGOLD -> [{?TYPE_BGOLD, 0, Num}];
        ?GOODS_SUBTYPE_COIN -> [{?TYPE_COIN, 0, Num}];
        ?GOODS_SUBTYPE_EXP -> [{?TYPE_EXP, 0, Num}];
        _ -> []
    end.


%% --------------------------- private ------------------------------------------------
get_storage_goods_info(GoodsId) ->
    Sql = io_lib:format(?SQL_STORAGE_LIST_BY_GID, [GoodsId]),
    case db:get_row(Sql) of
        [] -> [0, 0, 0];
        [PlayerId, GuildId, Num] -> [PlayerId, GuildId, Num]
    end.

%% 移进仓库
change_storage_into(GoodsInfo, Location, Cell, Num, GoodsStatus) ->
    NewGoodsInfo = change_storage(GoodsInfo, Location, Cell, Num),
    Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id}, GoodsStatus#goods_status.dict),
    NewStatus = GoodsStatus#goods_status{dict = Dict},
    NewStatus.

change_storage_out(GoodsInfo, Location, Cell, Num, GoodsStatus) ->
    NewGoodsInfo = change_storage(GoodsInfo, Location, Cell, Num),
    Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
    NewStatus = GoodsStatus#goods_status{dict = Dict},
    NewStatus.

%% 移出、移进仓库
change_storage(GoodsInfo, Location, Cell, Num) ->
    Sql1 = io_lib:format(?SQL_GOODS_UPDATE_PLAYER1, [GoodsInfo#goods.player_id, GoodsInfo#goods.id]),
    db:execute(Sql1),
    Sql2 = io_lib:format(?SQL_GOODS_UPDATE_GUILD2, [GoodsInfo#goods.player_id, GoodsInfo#goods.bind, GoodsInfo#goods.trade, GoodsInfo#goods.id]),
    db:execute(Sql2),
    Sql3 = io_lib:format(?SQL_GOODS_UPDATE_GUILD3, [GoodsInfo#goods.player_id, GoodsInfo#goods.guild_id, Location, Cell, Num, GoodsInfo#goods.id]),
    db:execute(Sql3),
    GoodsInfo#goods{location=Location, cell=Cell, num=Num}.


%% 更新原有的可叠加物品
update_overlap_storage([GoodsId, _Cell, GoodsNum], [Num, MaxOverlap]) ->
    case Num > 0 of
        true when GoodsNum < MaxOverlap ->
            case GoodsNum + Num > MaxOverlap of
                %总数超出可叠加数
                true ->
                    OldNum = MaxOverlap,
                    NewNum = Num + GoodsNum - MaxOverlap;
                false ->
                    OldNum = Num + GoodsNum,
                    NewNum = 0
            end,
            change_storage_num(GoodsId, OldNum);
        true ->
            NewNum = Num;
        false ->
            NewNum = 0
    end,
    [NewNum, MaxOverlap].

%%更改物品数量
change_storage_num(GoodsId, Num) ->
    Sql = io_lib:format(?SQL_GOODS_UPDATE_NUM, [Num, GoodsId]),
    db:execute(Sql).

get_val(Sql) ->
    Num = db:get_one(Sql),
    case is_integer(Num) of
        true ->
            Num;
        false ->
            0
    end.

%% 仓库数
get_storage_count(PlayerId, GuildId) ->
    case GuildId > 0 of
        true ->
            Sql = io_lib:format(?SQL_STORAGE_COUNT1, [GuildId]);
        false ->
            Sql = io_lib:format(?SQL_STORAGE_COUNT2, [PlayerId, ?GOODS_LOC_STORAGE])
    end,
    get_val(Sql).

%% 物品类型数量
get_storage_type_count(PlayerId, GuildId, GoodsTypeId, Bind) ->
    case GuildId > 0 of
        true ->
            Sql = io_lib:format(?SQL_STORAGE_TYPE_COUNT1, [GuildId, GoodsTypeId]);
        false ->
            Sql = io_lib:format(?SQL_STORAGE_TYPE_COUNT2, [PlayerId, ?GOODS_LOC_STORAGE, GoodsTypeId, Bind])
    end,
    get_val(Sql).

%%-----------------------------------------------------------
%% @doc 获取需要的背包格子数
%%-----------------------------------------------------------
get_need_cell_num(PlayerId, GoodsStatus, ObjectList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    AddGoodsList = combine_object_with_goods_id_and_overlap(ObjectList),
    Fdo = fun({AddGoodsInfo, _}, NeedNumList) ->
        #goods{goods_id = GoodsTypeId, bind = RealBind, num = Num} = AddGoodsInfo,
        #ets_goods_type{bag_location = BagLocation, max_overlap = MaxOverlap} = data_goods_type:get(GoodsTypeId),
        GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GoodsTypeId, RealBind, BagLocation, Dict),
        CellNum = lib_storage_util:get_null_cell_num(GoodsList, AddGoodsInfo, MaxOverlap, Num),
        case lists:keyfind(BagLocation, 1, NeedNumList) of
            {BagLocation, NeedNum} ->
                lists:keystore(BagLocation, 1, NeedNumList, {BagLocation, NeedNum + CellNum});
            _ ->
                lists:keystore(BagLocation, 1, NeedNumList, {BagLocation, CellNum})
        end
    end,
    NeedNumList = lists:foldl(Fdo, [], AddGoodsList),
    NeedNumList.

%%-----------------------------------------------------------
%% @doc 检查增加同类型的物品还需要多少格子数
%%-----------------------------------------------------------
get_null_cell_num(GoodsList, AddGoodsInfo, MaxNum, GoodsNum) when MaxNum > 1 ->
    F = fun(GoodsInfo, AddNum) ->
        case lib_goods_util:can_overlap_same_cell(GoodsInfo, AddGoodsInfo) of 
            true -> 
                MergeNum = max(MaxNum - GoodsInfo#goods.num, 0), max(AddNum - MergeNum, 0);
            _ -> AddNum
        end
    end,
    NewAddNum = lists:foldl(F, GoodsNum, GoodsList),
    util:ceil(NewAddNum/MaxNum);
get_null_cell_num(_GoodsList, _AddGoodsInfo, _MaxNum, GoodsNum) ->
    GoodsNum.


%%-----------------------------------------------------------
%% @doc 获取相同道具所对应的格子数
%% return: [{背包类型,所需格子数,一个格子存放道具数量,道具列表}]
%%-----------------------------------------------------------
get_same_goods_cell_num(PlayerId, GoodsStatus, ObjectList) ->
    #goods_status{dict = Dict} = GoodsStatus,
    AddGoodsList = combine_object_with_goods_id_and_overlap(ObjectList),
    Fdo = fun({AddGoodsInfo, SourceItemList}, LocationNumList) ->
        #goods{goods_id = GoodsTypeId, bind = RealBind, num = Num} = AddGoodsInfo,
        #ets_goods_type{bag_location = BagLocation, max_overlap = MaxOverlap} = data_goods_type:get(GoodsTypeId),
        GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GoodsTypeId, RealBind, BagLocation, Dict),
        CellNum = lib_storage_util:get_null_cell_num(GoodsList, AddGoodsInfo, MaxOverlap, Num),
        [{BagLocation, CellNum, ?IF(MaxOverlap>1, MaxOverlap, 1), SourceItemList}|LocationNumList]
    end,
    LocationNumList = lists:foldl(Fdo, [], AddGoodsList),
    LocationNumList.

%% 根据物品id和是否可叠加，合并要添加的道具，方便判断格子数
%% return: [{GoodsInfo, SourceItemList}], SourceItemList: 合并成同一个goodsInfo的ObjectList
combine_object_with_goods_id_and_overlap(ObjectList) ->
    UniqeObjectList = lib_goods_api:make_reward_unique(ObjectList),
    F = fun(Item, UniqeGoodsList) ->
            case Item of 
                {?TYPE_GOODS, GoodsTypeId, Num} -> Attr = [];
                {?TYPE_GOODS, GoodsTypeId, Num, Bind} -> Attr = [{bind, Bind}];
                {?TYPE_BIND_GOODS, GoodsTypeId, Num} -> Attr = [{bind, ?BIND}];
                {?TYPE_ATTR_GOODS, GoodsTypeId, Num, Attr1} -> Attr = Attr1;
                _ -> GoodsTypeId = 0, Num = 0, Attr = []
            end,
            case GoodsTypeId > 0 of 
                true ->
                    case data_goods_type:get(GoodsTypeId) of 
                        GoodsTypeInfo when is_record(GoodsTypeInfo, ets_goods_type) ->
                            GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo, Attr),
                            {_, UniqeGoodsListWithId} = ulists:keyfind(GoodsTypeId, 1, UniqeGoodsList, {GoodsTypeId, []}),
                            lists:keystore(GoodsTypeId, 1, UniqeGoodsList, {GoodsTypeId, [{GoodsInfo#goods{num = Num}, [Item]}|UniqeGoodsListWithId]});
                        _ ->
                            ?ERR("miss cfg GoodsTypeId:~p", [GoodsTypeId]),
                            UniqeGoodsList
                    end;
                _ ->
                    UniqeGoodsList
            end
    end,
    UniqeGoodsList = lists:foldl(F, [], UniqeObjectList),
    %% 将相同typeid的并且能进行合并的物品进行合并
    F2 = fun({_GoodsTypeId, UniqeGoodsListWithId}, AddGoodsList) ->
        NewUniqeGoodsListWithId = combine_can_overlap_goods(UniqeGoodsListWithId),
        NewUniqeGoodsListWithId ++ AddGoodsList
    end,
    AddGoodsList = lists:foldl(F2, [], UniqeGoodsList),
    AddGoodsList.

%% 合并能叠加在一起的物品
combine_can_overlap_goods(GoodsList) ->
    F = fun({GoodsInfo, SourceItem}, List) ->
        case List of 
            [] -> [{GoodsInfo, SourceItem}|List];
            _ ->
                F2 = fun({GoodsInfo1, SourceItem1}, {List2, IsMatch}) ->
                    case lib_goods_util:can_overlap_same_cell(GoodsInfo1, GoodsInfo) of 
                        true ->
                            OldNum = GoodsInfo1#goods.num,
                            AddNum = GoodsInfo#goods.num,
                            {[{GoodsInfo1#goods{num = OldNum+AddNum}, SourceItem1++SourceItem}|List2], true};
                        _ -> {[{GoodsInfo1, SourceItem1}|List2], IsMatch}
                    end
                end,
                case lists:foldl(F2, {[], false}, List) of 
                    {NewList, true} -> NewList;
                    {NewList, false} -> [{GoodsInfo, SourceItem}|NewList]
                end
        end
    end,
    lists:foldl(F, [], GoodsList).

%%-------------------------------------------------
%% 检查增加同样类型的物品需要多少格子
%%------------------------------------------------
get_null_storage_num(TypeNum, GoodsNum, MaxNum) ->
    case MaxNum > 1 of
        true ->
            OldCellNum = util:ceil(TypeNum/MaxNum), %% 向上取整
            NewCellNum = util:ceil((TypeNum + GoodsNum)/MaxNum),
            (NewCellNum - OldCellNum);
        false ->
            GoodsNum
    end.

%% 取仓库物品类型表
get_storage_type_list(GoodsInfo, MaxNum) ->
    case GoodsInfo#goods.guild_id > 0 of
        true -> %% 帮派
            Sql = io_lib:format(?SQL_STORAGE_LIST_BY_GUILD, [GoodsInfo#goods.guild_id, GoodsInfo#goods.goods_id, MaxNum]);
        false ->
            Sql = io_lib:format(?SQL_STORAGE_LIST_BY_TYPE, [GoodsInfo#goods.player_id, ?GOODS_LOC_STORAGE, GoodsInfo#goods.goods_id, GoodsInfo#goods.bind, MaxNum])
    end,
    GoodsList = lib_goods_util:get_list(Sql),
    sort_storage(GoodsList).

sort_storage(GoodsList) ->
    F = fun([_, C1, _], [_, C2, _]) -> C1 < C2 end,
    lists:sort(F, GoodsList).

% 仓库扩展
expand_bag(RoleId, ?GOODS_LOC_BAG, NewCellMaxNum) ->
    Sql = io_lib:format(?SQL_PLAYER_UPDATE_CELL, [NewCellMaxNum, RoleId]),
    db:execute(Sql);
expand_bag(RoleId, ?GOODS_LOC_STORAGE, NewCellMaxNum) ->
    Sql = io_lib:format(?SQL_PLAYER_UPDATE_STORAGE_NUM, [NewCellMaxNum, RoleId]),
    db:execute(Sql);
expand_bag(_, _, _) -> skip.
    
