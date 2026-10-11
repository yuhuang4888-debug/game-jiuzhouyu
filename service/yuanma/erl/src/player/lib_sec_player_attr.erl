%% ---------------------------------------------------------------------------
%% @doc 第二套属性通用模块
%% @author zzm
%% @since  2014-06-25
%% @deprecated 本模块主要用于各个功能模块中的属性保存，同时使得易于修改属性类型
%% ---------------------------------------------------------------------------
-module(lib_sec_player_attr).

-export([
        to_attr_map/1
        , to_attr_map/2
        , to_list/1
        , get_value_to_int/2
        , get_value_to_int/3
        , get_value_to_list/3
        , make_attr_with_lv_add/2
    ]).

-include("attr.hrl").

%% 转换成map
%% @param List [{Type, Subtype, Value}|{Type, Value}|List|Map]
to_attr_map(List) ->
    to_attr_map2(List, #{}).

%% 转换成map
%% @param List [{Type, Subtype, Value}|{Type, Value}|List|Map]
%% @parm FilterL 抽取对应的类型或者子类型,一定会存在map中 [{Type, Subtype, DefaultValue}|Type]
%% @parm Map
to_attr_map(List, FilterL) ->
    Map = to_attr_map2(List, #{}),
    F = fun
        ({Type, Subtype, DefaultValue}, TmpMap) ->
            TypeMap = maps:get(Type, Map, #{}),
            Value = maps:get(Subtype, TypeMap, DefaultValue),
            TmpTypeMap = maps:get(Type, TmpMap, #{}),
            NewTmpTypeMap = TmpTypeMap#{Subtype=>Value},
            TmpMap#{Type=>NewTmpTypeMap};
        (Type, TmpMap) ->
            TypeMap = maps:get(Type, Map, #{}),
            TmpMap#{Type=>TypeMap}
    end,
    lists:foldl(F, #{}, FilterL).

to_attr_map2([], Map) -> Map;
to_attr_map2([H|T], Map) when is_list(H) ->
    NewMap = to_attr_map_help(H, Map),
    to_attr_map2(T, NewMap);
to_attr_map2([H|T], Map) when is_map(H) ->
    List = to_list(H),
    NewMap = to_attr_map_help(List, Map),
    to_attr_map2(T, NewMap);
to_attr_map2([H|T], Map) ->
    NewMap = to_attr_map_help([H], Map),
    to_attr_map2(T, NewMap).

%% 转化map,特殊类型在这里做特殊处理
to_attr_map_help([], Map) -> Map;
to_attr_map_help([{Type, Value}|T], Map) ->
    IsLvAdd = lists:member(Type, ?SEC_ATTR_LV_ADD_LIST),
    IsFilter = lists:member(Type, ?SEC_ATTR_LIST_FILTER),
    if
        IsLvAdd -> to_attr_map_help([{Type, ?ADD_PER_LV, Value}|T], Map);
        IsFilter -> to_attr_map_help([{Type, 0, Value}|T], Map);
        true -> to_attr_map_help(T, Map)
    end;
to_attr_map_help([{Type, Subtype, Value}|T], Map) ->
    TypeMap = maps:get(Type, Map, #{}),
    case is_integer(Value) of
        true -> 
            OldValue = maps:get(Subtype, TypeMap, 0),
            NewValue = OldValue+Value,
            NewTypeMap = TypeMap#{Subtype=>NewValue};
        false -> 
            ValueList = maps:get(Subtype, TypeMap, []),
            NewValueList = [Value|ValueList],
            NewTypeMap = TypeMap#{Subtype=>NewValueList}
    end,
    to_attr_map_help(T, Map#{Type=>NewTypeMap}).

%% 转成list
to_list(Map) -> 
    F = fun(K, Value, List) ->
        F2 = fun(SecK, SecValue, SecTmpList) -> [{K, SecK, SecValue}|SecTmpList] end,
        maps:fold(F2, [], Value) ++ List
    end,
    maps:fold(F, [], Map).

%% 获得对应的类型,转换成int
%% @param KvList [Type(Subtype会默认为0)|{Type, SubType}]
get_value_to_int(Map, KvList) when is_list(KvList) ->
    F = fun
        ({Type, Subtype}) -> get_value_to_int(Map, Type, Subtype);
        (Type) -> get_value_to_int(Map, Type)
    end,
    lists:map(F, KvList);
get_value_to_int(Map, Type) ->
    get_value_to_int(Map, Type, 0).

get_value_to_int(Map, Type, Subtype) -> 
    case maps:find(Type, Map) of
        error -> 0;
        {ok, TypeMap} -> maps:get(Subtype, TypeMap, 0)
    end.

%% 获得对应的类型,转换成list
get_value_to_list(Map, Type, Subtype) -> 
    case maps:find(Type, Map) of
        error -> [];
        {ok, TypeMap} -> maps:get(Subtype, TypeMap, [])
    end.

%% -----------------------------------------------------------------
%% logic 功能代码
%% -----------------------------------------------------------------

%% 根据等级加成计算出记录
%% @return #attr{}
make_attr_with_lv_add(Map, Lv) ->
    F = fun(Type, Attr) ->
        F2 = fun(Subtype, Value, SecAttr) ->
            #attr{att = Att, hp = Hp, wreck = Wreck, def = Def, hit = Hit, dodge = Dodge, crit = Crit, ten = Ten} = SecAttr,
            case Subtype == 0 of 
                true -> Add = 0;
                false -> 
                    case is_integer(Value) of 
                        true -> Add = (Lv div Subtype)*Value;
                        _ ->
                            Add = calc_attr_lv_add(Value, Lv, Subtype, 0)
                    end
            end,
            if
                Value == 0 -> SecAttr;
                Type == ?LV_ATT -> SecAttr#attr{att = Att+Add};
                Type == ?LV_HP -> SecAttr#attr{hp = Hp+Add};
                Type == ?LV_WRECK -> SecAttr#attr{wreck = Wreck+Add};
                Type == ?LV_DEF -> SecAttr#attr{def = Def+Add};
                Type == ?LV_HIT -> SecAttr#attr{hit = Hit+Add};
                Type == ?LV_DODGE -> SecAttr#attr{dodge = Dodge+Add};
                Type == ?LV_CRIT -> SecAttr#attr{crit = Crit+Add};
                Type == ?LV_TEN -> SecAttr#attr{ten = Ten+Add};
                true -> SecAttr
            end
        end,
        maps:fold(F2, Attr, maps:get(Type, Map, #{}))
    end,
    lists:foldl(F, #attr{}, ?SEC_ATTR_LV_ADD_LIST).

calc_attr_lv_add([], _Lv, _Subtype, Add) -> Add;
calc_attr_lv_add([{BaseValue, AddValue}|Value], Lv, Subtype, Add) ->
    %% 初始值 + 等级/等级间隔*增加数值
    calc_attr_lv_add(Value, Lv, Subtype, Add + BaseValue + (Lv div Subtype)*AddValue);
calc_attr_lv_add([_|Value], Lv, Subtype, Add) ->
    calc_attr_lv_add(Value, Lv, Subtype, Add).
