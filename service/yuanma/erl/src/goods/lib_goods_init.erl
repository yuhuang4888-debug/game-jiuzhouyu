%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-13
%% Description: 物品实用工具类
%% --------------------------------------------------------
-module(lib_goods_init).
-compile(export_all).
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("sql_goods.hrl").
-include("def_module.hrl").
-include("sell.hrl").

init_goods_online(PlayerId, GoodsDict) ->
    %% 初始化在线玩家背包物品表
    {NewDict, TimeoutGoods} = init_goods(PlayerId, GoodsDict),
    {NewDict, TimeoutGoods}.

%% 初始化物品
init_goods(PlayerId, GoodsDict) ->

    %% 移除过期物品
    % F4 = fun([Id, GoodsTypeId, GoodsNum, _Location, _Type, _EquipType]) ->
    %              if
    %                  GoodsTypeId == ?GOODS_ID_ANGER orelse GoodsTypeId == ?GOODS_ID_DEVIL ->
    %                      skip; %% 天使和恶魔过滤掉
    %                  true ->
    %                      lib_goods_util:delete_goods(Id),
    %                      lib_log_api:log_throw(goods_timeout, PlayerId, Id, GoodsTypeId, GoodsNum, 0, 0),
    %                      %% case Location of
    %                      %%    %%  邮件附件
    %                      %%     7 -> lib_mail:delete_mail_goods_on_db(Id); 后面再加上
    %                      %%     _ -> skip
    %                      %% end
    %                      {GoodsTypeId, GoodsNum}
    %              end
    %      end,
    % Sql4 = io_lib:format(?SQL_GOODS_LIST_BY_EXPIRE, [PlayerId, utime:unixtime()]),
    % TimeoutGoods = case db:get_all(Sql4) of
    %     [] -> [];
    %     GoodsList5 when is_list(GoodsList5) ->
    %         F44 = fun() -> lists:map(F4, GoodsList5) end,
    %         lib_goods_util:transaction(F44);
    %     _ -> []
    % end,

    LocationList = ?GOODS_LOC_BAG_TYPES_LOGIN,

    NewGoodsDict = get_location_dict(LocationList, PlayerId, GoodsDict),
    TimeoutGoods = get_timeout_goods(NewGoodsDict),
    %?PRINT("init_goods###### TimeoutGoods ~p ~n", [TimeoutGoods]),
    {NewGoodsDict, TimeoutGoods}.

get_location_dict([T|G], PlayerId, NewGoodsDict) ->
    Sql = io_lib:format(?SQL_GOODS_LIST_BY_LOCATION, [PlayerId, T]),
    NewGoodsDict1 = case db:get_all(Sql) of
        [] ->
            NewGoodsDict;
        GoodsList when is_list(GoodsList) ->
            insert_dict(GoodsList, NewGoodsDict);
        _ ->
            NewGoodsDict
    end,
    get_location_dict(G, PlayerId, NewGoodsDict1);
get_location_dict([], _PlayerId, NewGoodsDict) ->
    NewGoodsDict.

get_timeout_goods(GoodsDict) ->
    NowTime = utime:unixtime(),
    F = fun(_, [Value], List) ->
        case Value#goods.expire_time > 0 andalso Value#goods.expire_time < NowTime of 
            true -> [{Value#goods.id, Value#goods.goods_id, Value#goods.num}|List];
            _ -> List
        end
    end,
    dict:fold(F, [], GoodsDict).

insert_dict([], Dict) ->
    Dict;
insert_dict([Info|H], Dict) ->
    case lib_goods_util:make_info(goods, Info) of
        [GoodsInfo] ->
            NewGoodsDict1 = lib_goods_dict:add_dict_goods(GoodsInfo, Dict);
        _ ->
            NewGoodsDict1 = Dict
    end,
    insert_dict(H, NewGoodsDict1).

insert_dict([], Dict, _EquipAttrDict) ->
    Dict;
insert_dict([Info|H], Dict, EquipAttrDict) ->
    case lib_goods_util:make_info(goods, Info, EquipAttrDict) of
        [GoodsInfo] ->
            NewGoodsDict1 = lib_goods_dict:add_dict_goods(GoodsInfo, Dict);
        _ ->
            NewGoodsDict1 = Dict
    end,
    insert_dict(H, NewGoodsDict1, EquipAttrDict).

% init_null_cells_list(MaxBagNullCell, GoodsDict) ->
%     F = fun(TmpLocation) ->
%         TmpMaxCellNum = case TmpLocation of
%             ?GOODS_LOC_BAG -> MaxBagNullCell;
%             _ -> ?GET_BAG_MAX_CELL_NUM(TmpLocation)
%         end,
%         {TmpLocation, TmpMaxCellNum}
%     end,
%     List = lists:map(F, ?GOODS_LOC_BAG_TYPES),
%     NullCellsMap = lists:foldl(fun({TmpLocation, TmpMaxNullCell}, AccMap) ->
%         TmpList = lists:seq(1, TmpMaxNullCell),
%         AccMap#{TmpLocation => TmpList}
%     end, #{}, List),
%     F1 = fun(_Key, [Value], AccMap) ->
%         #goods{location = TmpLocation, cell = TmpCell} = Value,
%         case lists:member(TmpLocation, ?GOODS_LOC_BAG_TYPES) of
%             true ->
%                 TmpNullCellList = maps:get(TmpLocation, AccMap, []),
%                 NewTmpNullCellList = lists:delete(TmpCell, TmpNullCellList),
%                 maps:put(TmpLocation, NewTmpNullCellList, AccMap);
%             false -> AccMap
%         end
%     end,
%     dict:fold(F1, NullCellsMap, GoodsDict).

init_num_cells_map(PlayerLv, VipType, VipLv, CellNum, StorageNum, GoodsDict) ->
    F = fun(TmpLocation) ->
        TmpMaxCellNum = get_location_limit(TmpLocation, {PlayerLv, VipType, VipLv, CellNum, StorageNum}),
        {TmpLocation, TmpMaxCellNum}
    end,
    List = lists:map(F, ?GOODS_LOC_BAG_TYPES),
    NumCellsMap = lists:foldl(fun({TmpLocation, TmpMaxCellNum}, AccMap) ->
        ?IF(TmpMaxCellNum > 0, AccMap#{TmpLocation => {0, TmpMaxCellNum}}, AccMap)  
    end, #{}, List),
    F1 = fun(_Key, [Value], AccMap) ->
        #goods{location = TmpLocation} = Value,
        NewAccMap = lib_goods_util:occupy_num_cells(AccMap, TmpLocation, 1),
        NewAccMap
    end,
    dict:fold(F1, NumCellsMap, GoodsDict).


get_location_limit(?GOODS_LOC_BAG, {_PlayerLv, _VipType, _VipLv, CellNum, _StorageNum}) ->
    DefaultNum = lib_vip_api:get_num_by_vip_defualt(?MOD_GOODS, 5),
    ?IF(CellNum >= DefaultNum, CellNum, DefaultNum);
get_location_limit(?GOODS_LOC_STORAGE, {_PlayerLv, _VipType, _VipLv, _CellNum, StorageNum}) ->
    DefaultNum = lib_vip_api:get_num_by_vip_defualt(?MOD_GOODS, 6),
    ?IF(StorageNum >= DefaultNum, StorageNum, DefaultNum);
get_location_limit(?GOODS_LOC_DECORATION_BAG, _Args) ->
    DecorBagNum = data_decoration:get_decoration_kv(1),
    ?IF(DecorBagNum > 0, DecorBagNum, 100);
get_location_limit(?GOODS_LOC_SEAL, _Args) ->
    case data_seal:get_seal_value(1) of
        [SealNumCfg] -> SealNumCfg;
        _ -> SealNumCfg = 200
    end,
    SealNumCfg;
get_location_limit(?GOODS_LOC_DEMONS_SKILL, _Args) ->
    case data_demons:get_key(9) of
        NumCfg when is_integer(NumCfg) -> NumCfg;
        _ -> NumCfg = 100
    end,
    NumCfg;
get_location_limit(?GOODS_LOC_MOUNT_EQUIP_BAG, _Args) ->
    100;
get_location_limit(?GOODS_LOC_MATE_EQUIP_BAG, _Args) ->
    100;
get_location_limit(?GOODS_LOC_CONSTELLATION, _Args) ->
    case data_constellation_equip:get_value(max_bag_num) of
        MaxNum when is_integer(MaxNum) -> MaxNum;
        _ -> MaxNum = 100
    end,
    MaxNum;
get_location_limit(?GOODS_LOC_GOD_COURT, _Args) ->
    200;
get_location_limit(_, _) -> 0.

