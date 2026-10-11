%% ---------------------------------------------------------------------------
%% @doc 属性通用模块
%% @author zzm
%% @since  2014-06-25
%% @deprecated 本模块主要用于各个功能模块中的属性保存，同时使得易于修改属性类型
%% ---------------------------------------------------------------------------
-module(lib_player_attr).

-include("predefine.hrl").
-include("attr.hrl").

-export([
         attr_to_battle_attr/1,     %% 主属性转化为战斗属性
         get_list_base_attr_kv/1,   %% 返回八个基础属性
         get_list_base_attr/1       %% 返回八个基础属性
        ]).

-export([
         get_value_by_id/2,         %% 根据属性id从属性中获取值
         get_value_by_ids/2,        %% 根据属性id列表从属性中获取值
         set_value_by_id/3,         %% 对某个属性值赋值
         to_attr/1,                 %% 属性列表转换为属性map
         to_attr_record/1,          %% 属性列表转换为属性Map
         list_add_to_attr/1,        %% 属性列表转换为属性Map
         list_add_to_attr/2,        %% 属性列表增加到属性Map
         to_kv_list/1,              %% 属性转换为属性列表
         add_attr/2,                %% 属性相加
         minus_attr/2,              %% 属性相减
         partial_attr_convert/1,    %% 功能内部的基础属性加成转换成基础属性
         count_lv_attr/2,           %% 计算等级基础属性百分比加成属性
         filter_specify_attr/2      %% 从属性列表中筛选出指定属性
         , set_battle_attr/2
        ]).

%% 属性列表类型
%% 详细编号(AttrbuteId)参考predefine.hrl文件中的编号
-type attr_key_value_list() :: [{AttrbuteId::integer(), Value::integer() | float()}].

%% ---------------------------------------------------------------------------
%% @doc 根据属性id从record中获取属性值
-spec get_value_by_id(AttributeId, AttrMaps) ->  Return when
      AttributeId :: integer(),       %% 属性id
      AttrMaps    :: #attr{} | #{},   %% 属性记录
      Return      :: integer().       %% 属性值
%% ---------------------------------------------------------------------------
get_value_by_id(AttributeId, AttrMaps) when is_map(AttrMaps) ->
    maps:get(AttributeId, AttrMaps, 0);
get_value_by_id(AttributeId, Attr) when is_record(Attr, attr), AttributeId > 0, AttributeId+1 =< size(Attr) ->
    element(AttributeId+1, Attr);
get_value_by_id(_, _) -> 0.

get_value_by_ids(AttributeIds, AttrMaps) ->
    [get_value_by_id(AttributeId, AttrMaps) || AttributeId <- AttributeIds].

%% ---------------------------------------------------------------------------
%% @doc 根据属性id从record中获取属性值
-spec set_value_by_id(AttributeId, Value, AttrMaps) ->  Return when
      AttributeId :: integer(),       %% 属性id
      Value       :: integer(),       %% 属性值
      AttrMaps    :: #attr{} | #{},   %% 属性记录
      Return      :: #attr{} | #{}.   %% 属性记录
%% ---------------------------------------------------------------------------
set_value_by_id(AttributeId, Value, AttrMaps) when is_map(AttrMaps) ->
    maps:put(AttributeId, Value, AttrMaps);
set_value_by_id(AttributeId, Value, Attr) when is_record(Attr, attr), AttributeId+1 =< size(Attr) ->
    setelement(AttributeId+1, Attr, Value);
set_value_by_id(_, _, Attr) -> Attr.

%% ---------------------------------------------------------------------------
%% @doc 属性maps转换为属性列表（顺序会变成倒序）
-spec to_kv_list(AttrMaps) ->  Return when
      AttrMaps    :: #{},
      Return      :: attr_key_value_list().
%% ---------------------------------------------------------------------------
to_kv_list(AttrMaps) when is_map(AttrMaps) ->
    maps:to_list(AttrMaps);

to_kv_list(Attr) when is_record(Attr, attr) ->
    [_|List] = tuple_to_list(Attr),
    F = fun(Value, {Index, Result}) ->
                case Value > 0 of
                    true -> {Index+1, [{Index, Value}|Result]};
                    false -> {Index+1, Result}
                end
        end,
    {_, Res} = lists:foldl(F, {1, []}, List),
    Res.

%% ---------------------------------------------------------------------------
%% @doc 属性列表转换为属性
-spec to_attr(AttrKeyValueList) ->  AttrMaps when
      AttrKeyValueList :: attr_key_value_list(),
      AttrMaps         :: #{}.
%% ---------------------------------------------------------------------------
to_attr(AttrKeyValueList) ->
    maps:from_list(AttrKeyValueList).

to_attr_record(AttrMap) when is_map(AttrMap) ->
    F = fun(Index, Value, AttrR) ->
                setelement(Index+1, AttrR, Value)
        end,
    maps:fold(F, #attr{}, AttrMap);

to_attr_record(AttrKeyValueList) ->
    MaxIndex = size(#attr{}),
    F = fun({Index, Value}, Attr) ->
                case Index < MaxIndex of
                    true  -> setelement(Index+1, Attr, Value);
                    false -> Attr
                end
        end,
    lists:foldl(F, #attr{}, AttrKeyValueList).

%% 属性列表增加到属性
%% return map
list_add_to_attr(AttrList)->
    list_add_to_attr(AttrList, ?DEF_ATTR_MAP).

list_add_to_attr([], AttrMaps) -> AttrMaps;
list_add_to_attr([{AttributeId, Value} | T], AttrMaps) ->
    OldValue = maps:get(AttributeId, AttrMaps, 0),
    list_add_to_attr(T, AttrMaps#{AttributeId => OldValue + Value}).

%% ---------------------------------------------------------------------------
%% @doc %% 属性相加
-spec add_attr(OutPutType, AttrListList) -> AttrMaps when
      OutPutType      :: list|map|record,
      AttrListList    :: [attr_key_value_list()] | [#attr{}] | [attr_key_value_list() | #attr{}| #{}],
      AttrMaps        :: #{}.
%% ---------------------------------------------------------------------------
add_attr(OutPutType, []) -> 
    case OutPutType of
        list -> [];
        map  -> #{};
        record -> #attr{}
    end;
add_attr(OutPutType, AttrList) ->
    NewAttrList = [add_attr_helper(Attr) || Attr <- AttrList],
    PlusAttrList = ulists:kv_list_plus_extra(NewAttrList),
    case OutPutType of
        list -> PlusAttrList;
        map  -> to_attr(PlusAttrList);
        record -> to_attr_record(PlusAttrList)
    end.

%% 转化为通用格式
add_attr_helper(Attr) when is_map(Attr) orelse is_record(Attr, attr) ->
    to_kv_list(Attr);
add_attr_helper([{_, _} | _] = Attr) ->
    Attr;
add_attr_helper(_) -> [].


%% ---------------------------------------------------------------------------
%% @doc %% 属性相加
-spec minus_attr(OutPutType, AttrListList) -> AttrMaps when
      OutPutType      :: list|map|record,
      AttrListList    :: [attr_key_value_list()] | [#attr{}] | [attr_key_value_list() | #attr{}| #{}],
      AttrMaps        :: #{}.
%% ---------------------------------------------------------------------------
minus_attr(_, []) -> #{};
minus_attr(OutPutType, AttrList) ->
    NewAttrList = [minus_attr_helper(Attr) || Attr <- AttrList],
    PlusAttrList = ulists:kv_list_minus_extra(NewAttrList),
    case OutPutType of
        list -> PlusAttrList;
        map  -> to_attr(PlusAttrList);
        record -> to_attr_record(PlusAttrList)
    end.

%% 转化为通用格式
minus_attr_helper(Attr) when is_map(Attr) orelse is_record(Attr, attr) ->
    to_kv_list(Attr);
minus_attr_helper([{_, _} | _] = Attr) ->
    Attr;
minus_attr_helper(_) -> [].

%% 一般属性转换为战斗属性
attr_to_battle_attr(AttrMaps) when is_map(AttrMaps) ->
    Attr = to_attr_record(AttrMaps),
    attr_to_battle_attr(Attr);
attr_to_battle_attr(Attr) ->
    %% Hp = calc_hp_by_attr(Attr),
    #battle_attr{attr = Attr}.

%% 功能内部的基础属性加成转换成基础属性
%% 有全属性加成的要转化到单属性加成列表
%% 转换完后会把原属性表的局部属性剔除掉
%% 属性系数万分比(即:放大了10000倍,计算的时候要除以10000)
partial_attr_convert(AttrList) ->
    AttrList1 = util:combine_list(AttrList),
    CombineList = case lists:keyfind(?PARTIAL_WHOLE_ADD_RATIO, 1, AttrList1) of
                      {?PARTIAL_WHOLE_ADD_RATIO, WholeAddRatio} when WholeAddRatio > 0 ->
                          % WholeAdd = [{AttrId + ?PARTIAL2GLOBAL_INTERVAL, WholeAddRatio} || AttrId <- ?BASE_ATTR_LIST],
                          WholeAdd = [{AttrId, WholeAddRatio} || AttrId <- ?PARTIAL_TYPE],
                          AttrList2 = lists:keydelete(?PARTIAL_WHOLE_ADD_RATIO, 1, AttrList1),
                          util:combine_list(WholeAdd ++ AttrList2);
                      _ -> AttrList1
                  end,
    %% 筛选出全局的属性
    GlobalAttrList = lists:filter(fun({TmpKey, _TmpVal}) ->
                                          lists:member(TmpKey, ?PARTIAL_TYPE) == false
                                  end, CombineList),
    lists:foldl(fun({TmpKey, TmpVal}, AccList) ->
                        case ?PARTIAL2GLOBAL(TmpKey) of
                            TmpCKey when is_integer(TmpCKey) ->
                                case lists:keyfind(TmpCKey, 1, AccList) of
                                    {TmpCKey, AttrVal} ->
                                        lists:keystore(TmpCKey, 1, AccList, {TmpCKey, round(AttrVal * (1 + TmpVal / ?RATIO_COEFFICIENT))});
                                    _ -> AccList
                                end;
                            _ -> AccList
                        end
                end, GlobalAttrList, CombineList).

%% 计算等级属性加成
count_lv_attr(LvAttr, AddAttrList) ->
    %% 基础属性
    BaseKvList = get_list_base_attr_kv(LvAttr),
    %% 基础属性加成万分比
    AllAddAttrList = ulists:kv_list_plus_extra(AddAttrList),
    F = fun(AttrType, AddList) ->
                case lists:keyfind(AttrType, 1, AllAddAttrList) of
                    false -> TenAddR = 0;
                    {_, TenAddR} -> skip
                end,
                [{AttrType, TenAddR}|AddList]
        end,
    LvAttrRList = lists:reverse(lists:foldl(F, [], ?LV_ADD_RATIO_TYPE)),
    calc_lv_attr_add_ratio(BaseKvList, LvAttrRList, []).

%% 计算加成:一一对应
calc_lv_attr_add_ratio([], [], LvAttr) -> LvAttr;
calc_lv_attr_add_ratio([{K, V}|BaseKvList], [{_, VR}|LvAttrRList], LvAttr) ->
    NV = round(V * (1+VR/?RATIO_COEFFICIENT)),
    calc_lv_attr_add_ratio(BaseKvList, LvAttrRList, [{K, NV}|LvAttr]);
calc_lv_attr_add_ratio([{K, V}|BaseKvList], [_|LvAttrRList], LvAttr) ->
    calc_lv_attr_add_ratio(BaseKvList, LvAttrRList, [{K, V}|LvAttr]);
calc_lv_attr_add_ratio([_|BaseKvList], [_|LvAttrRList], LvAttr) ->
    calc_lv_attr_add_ratio(BaseKvList, LvAttrRList, LvAttr).


%%--------------------------------------------------
%% 从属性列表中筛选出指定属性
%% @param  AttrL          属性列表[{属性id, 属性值}]
%% @param  SpecifyAttrMap 要筛选出的指定属性Map #{属性id => 值}
%% @return                筛选出的指定属性Map #{属性id => 值}
%%--------------------------------------------------
filter_specify_attr(AttrL, SpecifyAttrMap) ->
    lists:foldl(fun({TmpKey, TmpVal}, TmpMap) ->
                        case maps:is_key(TmpKey, TmpMap) of
                            true ->
                                #{TmpKey := PreVal} = TmpMap,
                                TmpMap#{TmpKey => PreVal + TmpVal};
                            false -> TmpMap
                        end
                end, SpecifyAttrMap, AttrL).


%% 从列表中拿出基础属性:AttrList不能有重复键
%% 返回[{k,v}...]列表
get_list_base_attr_kv(AttrList)->
    F = fun(K, TL)->
                case lists:keyfind(K, 1, AttrList) of
                    false -> [{K, 0}|TL];
                    E -> [E|TL]
                end
        end,
    lists:reverse(lists:foldl(F, [], ?BASE_ATTR_LIST)).

%% 从列表中拿出基础属性:AttrList不能有重复键
%% 返回[V,V1...]列表
get_list_base_attr(AttrList)->
    F = fun(K, TL)->
                case lists:keyfind(K, 1, AttrList) of
                    false -> [0|TL];
                    {K, V} -> [V|TL]
                end
        end,
    lists:reverse(lists:foldl(F, [], ?BASE_ATTR_LIST)).

%% 设置战斗属性
set_battle_attr(BattleAttr, AttrKeyValueList) ->
    #battle_attr{attr = MonAttr} = BattleAttr,
    MaxIndex = size(#attr{}),
    F = fun({Index, Value}, Attr) -> 
        case Index < MaxIndex of
            true  -> setelement(Index+1, Attr, Value);
            false -> Attr 
        end
    end,
    NewMonAttr = lists:foldl(F, MonAttr, AttrKeyValueList),
    BattleAttr#battle_attr{
        hp = NewMonAttr#attr.hp, hp_lim = NewMonAttr#attr.hp, attr = NewMonAttr,
        speed = NewMonAttr#attr.speed
        }.