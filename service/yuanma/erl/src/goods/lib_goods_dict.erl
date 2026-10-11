%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-23
%% Description: 物品进程字典
%% --------------------------------------------------------
-module(lib_goods_dict).
-compile(export_all).
-include("goods.hrl").
-include("sell.hrl").
-include("common.hrl").
-include("server.hrl").

%% 进程字典
start_dict() ->
	put(goods_act, []),
	ok.

close_dict() ->
	erase(goods_act),
	ok.

append_dict(Val, Dict) ->
	case get(goods_act) of
		undefined ->
			NewDict = handle_item([[Val]], Dict);
		Val2 ->
			put(goods_act, Val2++[Val]),
            NewDict = Dict
	end,
	NewDict.

handle_dict(Dict) ->
    {NewDict, _Value} = do_handle_dict(Dict),
    NewDict.

handle_dict_and_notify(Dict) ->
    {NewDict, Value} = do_handle_dict(Dict),
    GoodsList = get_goods_list(Value, Dict, []),
    {NewDict, GoodsList}.
    
do_handle_dict(Dict) ->
    {NewDict, Value} = case erase(goods_act) of
        undefined -> 
            {Dict, []};
        Val when is_list(Val) -> 
            NewD = handle_item([Val], Dict),
            {NewD, Val};
        _ -> 
            {Dict, []}
    end,
    {NewDict, Value}.

get_goods_list([], _Dict, GoodsList) -> GoodsList;
get_goods_list([OneOperation | T], Dict, GoodsList) ->
    Goods = case OneOperation of
        {add, goods, GoodsInfo} ->
            GoodsInfo;
        {del, goods, GoodsId} ->
            case lib_goods_util:get_goods(GoodsId, Dict) of
                [] -> [];
                G -> G#goods{num = 0}
            end;
        _ ->
            []
    end,
    case Goods of
        [] ->
            get_goods_list(T, Dict, GoodsList);
        _ ->
            get_goods_list(T, Dict, [Goods | GoodsList])
    end.



handle_item([[]], D) ->
    D;
handle_item([Item], D) ->
    [Item1|T] = Item,
    D1 = handle_item1(Item1, D),
    handle_item([T], D1).

handle_item1(Item, D) ->
    case Item of
        {add, goods, GoodsInfo} ->
            D1 = add_dict_goods(GoodsInfo, D);
        {del, goods, GoodsId} ->
            D1 = dict:erase(GoodsId, D);
        {add, sell, SellInfo} ->
            ets:insert(?ETS_SELL, SellInfo),
            D1 = D;
        {del, sell, Id} ->
            ets:delete(?ETS_SELL, Id),
            D1 = D;
        _Other ->
            D1 = D
    end,
    D1.

%% 增加物品
add_dict_goods(GoodsInfo, Dict) ->
    Key = GoodsInfo#goods.id,
    case is_integer(Key) andalso Key > 0 of
        true ->
            case dict:is_key(Key, Dict) of
                true ->
                    %% 更新
                    Dict1 = dict:erase(Key, Dict),
                    Dict2 = dict:append(Key, GoodsInfo, Dict1);
                false ->
                    Dict2 = dict:append(Key, GoodsInfo, Dict)
            end;
        false ->
            Dict2 = Dict
    end,
    Dict2.

%%----------------------------------------
%% 取出列表,从dict取
%% [{A1, B1}, {A2, B2}] -> [B1,B2] 
%%----------------------------------------
get_list([], L) ->
    L;
get_list([H|T], L) ->
    {_, List} = H,
    L1 = List ++ L,
    get_list(T, L1).

%% 获取新增物品唯一id(注：只适用于一次只新增一个物品的情况)
%% 暂时用于记录日志
get_add_goods_id() ->
    case get(goods_act) of
        undefined -> 0;
        Val when is_list(Val) -> 
            case [GoodsInfo || {Operation, goods, GoodsInfo}<-Val, Operation == add] of
                [#goods{id = GoodsId}|_] -> GoodsId;
                _ -> 0
            end;
        _ -> 0
    end.

add_goods_to_dict(Dict, GoodsList) ->
    F = fun(GoodsInfo, TmpDict) ->
        Key = GoodsInfo#goods.id,
        case dict:is_key(Key, TmpDict) of
            true ->
                %% 更新
                Dict1 = dict:erase(Key, TmpDict),
                dict:append(Key, GoodsInfo, Dict1);
            false ->
                dict:append(Key, GoodsInfo, TmpDict)
        end
    end,
    lists:foldl(F, Dict, GoodsList).