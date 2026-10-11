-module(lib_goods_consume_record).
-include("common.hrl").
-include("record.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_id_create.hrl").


-export([
	get_consume_record_map/1,
	set_consume_record_map/1,
	get_consume_record_with_id/4,
	get_consume_record_with_id/5,
	del_consume_record_with_id/4,
	del_consume_record_with_id/5,
	get_consume_record_with_mod_key/4,
	get_consume_record_with_mod_key/5,
	del_consume_record_with_mod_key/4,
	del_consume_record_with_mod_key/5,
	add_goods_comsume_record/6,     %% 记录消耗
	add_goods_comsume_record/7,
	format_goods_plus/1,
	db_update_consume_list/1
]).

-export([
	init_consume_record_map/1,
	db_delete_consume_record/1
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 物品消耗记录
%% 1 记录信息存放在玩家进程字段中
%% 2 mod_key字段最好也是唯一的，方便功能内部根据mod_key去找到具体的消耗
%%


get_consume_record_map(RoleId) ->
	case get({?MODULE, player_consume_record}) of 
		undefined ->
			ConsumeRecordMap = init_consume_record_map(RoleId),
			set_consume_record_map(ConsumeRecordMap),
			ConsumeRecordMap;
		ConsumeRecordMap ->
			ConsumeRecordMap
	end.

set_consume_record_map(ConsumeRecordMap) ->
	put({?MODULE, player_consume_record}, ConsumeRecordMap),
    ok.

init_consume_record_map(RoleId) ->
	case db_select_consume_record_by_role_id(RoleId) of 
		[] -> #{};
		DbList ->
			init_consume_record_map_do(DbList, RoleId, #{})
	end.

init_consume_record_map_do([], _RoleId, Map) -> Map;
init_consume_record_map_do([[Id, ModKeyStr, Mod, SubMod, ConsumeListStr, Time]|DbList], RoleId, Map) ->
	ConsumeRecord = make_consume_record(Id, RoleId, util:bitstring_to_term(ModKeyStr), Mod, SubMod, util:bitstring_to_term(ConsumeListStr), Time),
	OldList = maps:get({Mod, SubMod}, Map, []),
	NewMap = maps:put({Mod, SubMod}, [ConsumeRecord|OldList], Map),
	init_consume_record_map_do(DbList, RoleId, NewMap).


%% 记录物品的消耗记录
%% ConsumeList:[{Type,id,num}|{#goods{}, num}]
add_goods_comsume_record(PS, Mod, SubMod, ModKey, ConsumeList, Format) -> 
	ConsumeRecordMap = get_consume_record_map(PS#player_status.id),
	{_ConsumeRecord, NewConsumeRecordMap} = add_goods_comsume_record(PS, Mod, SubMod, ModKey, ConsumeList, Format, ConsumeRecordMap),
    set_consume_record_map(NewConsumeRecordMap),
    ok.

add_goods_comsume_record(PS, Mod, SubMod, ModKey, ConsumeList, Format, ConsumeRecordMap) ->
	ConsumeListFormat = trans_consume_record(PS, Mod, SubMod, Format, ConsumeList, []),
	%?PRINT("comsume_record### :~p~n", [ConsumeListFormat]),
    Id = mod_id_create:get_new_id(?CONSUME_RECORD_ID_CREATE),
    ConsumeRecord = make_consume_record(Id, PS#player_status.id, ModKey, Mod, SubMod, ConsumeListFormat, utime:unixtime()),
    db_replace_consume_record(ConsumeRecord),
    OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
    NewConsumeRecordMap = maps:put({Mod, SubMod}, [ConsumeRecord|OldRecordList], ConsumeRecordMap),
    {ConsumeRecord, NewConsumeRecordMap}.

%% 根据id获取消耗记录(玩家进程)
get_consume_record_with_id(PS, Mod, SubMod, Id) ->
	ConsumeRecordMap = get_consume_record_map(PS#player_status.id),
	get_consume_record_with_id(PS, Mod, SubMod, Id, ConsumeRecordMap).

get_consume_record_with_id(_PS, Mod, SubMod, Id, ConsumeRecordMap) ->
	OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
	case lists:keyfind(Id, #consume_record.id, OldRecordList) of 
		#consume_record{} = ConsumeRecord -> ConsumeRecord;
		_ -> fail
	end.

%% 根据id删除记录
del_consume_record_with_id(PS, Mod, SubMod, Id) ->
	ConsumeRecordMap = get_consume_record_map(PS#player_status.id),
	NewConsumeRecordMap = del_consume_record_with_id(PS, Mod, SubMod, Id, ConsumeRecordMap),
	set_consume_record_map(NewConsumeRecordMap).

del_consume_record_with_id(_PS, Mod, SubMod, Id, ConsumeRecordMap) ->
	OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
	case lists:keyfind(Id, #consume_record.id, OldRecordList) of 
		#consume_record{} -> 
			db_delete_consume_record([Id]),
			NewRecordList = lists:keydelete(Id, #consume_record.id, OldRecordList),
			NewConsumeRecordMap = maps:put({Mod, SubMod}, NewRecordList, ConsumeRecordMap),
			NewConsumeRecordMap;
		_ -> ConsumeRecordMap
	end.

%% 根据mod_key获取消耗记录列表
get_consume_record_with_mod_key(PS, Mod, SubMod, ModKey) ->
	ConsumeRecordMap = get_consume_record_map(PS#player_status.id),
	get_consume_record_with_mod_key(PS, Mod, SubMod, ModKey, ConsumeRecordMap).
	
get_consume_record_with_mod_key(_PS, Mod, SubMod, ModKey, ConsumeRecordMap) ->
	OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
	F = fun(ConsumeRecord) ->
		ConsumeRecord#consume_record.mod_key == ModKey
	end,
	case lists:filter(F, OldRecordList) of 
		[] -> fail;
		List -> 
			lists:reverse(lists:keysort(#consume_record.time, List))
	end.

%% 根据mod_key删除记录
del_consume_record_with_mod_key(PS, Mod, SubMod, ModKey) ->
	ConsumeRecordMap = get_consume_record_map(PS#player_status.id),
	NewConsumeRecordMap = del_consume_record_with_mod_key(PS, Mod, SubMod, ModKey, ConsumeRecordMap),
	set_consume_record_map(NewConsumeRecordMap).

del_consume_record_with_mod_key(_PS, Mod, SubMod, ModKey, ConsumeRecordMap) ->
	OldRecordList = maps:get({Mod, SubMod}, ConsumeRecordMap, []),
	F = fun(ConsumeRecord) ->
		ConsumeRecord#consume_record.mod_key == ModKey
	end,
	case lists:filter(F, OldRecordList) of 
		[] -> ConsumeRecordMap;
		List -> 
			db_delete_consume_record([Id||#consume_record{id = Id} <- List]),
			NewRecordList = OldRecordList -- List,
			NewConsumeRecordMap = maps:put({Mod, SubMod}, NewRecordList, ConsumeRecordMap),
			NewConsumeRecordMap
	end.

make_consume_record(Id, RoleId, ModKey, Mod, SubMod, ConsumeList, Time) ->
	#consume_record{
		id = Id,                     
	    role_id = RoleId,
	    mod_key = ModKey,                    
	    mod = Mod,
	    sub_mod = SubMod,
	    consume_list = ConsumeList,
	    time = Time             
	}.

trans_consume_record(_PS, _Mod, _SubMod, _Format, [], Return) -> 
	format_goods_plus(Return);
trans_consume_record(PS, Mod, SubMod, Format, [Item|ConsumeList], Return) ->
    case Item of 
        {Goods, Num} when is_record(Goods, goods) ->
            FormatItem = format_consume_record(Format, Goods, Num),
            trans_consume_record(PS, Mod, SubMod, Format, ConsumeList, [FormatItem|Return]);
        {Type, TypeId, Num} ->
            trans_consume_record(PS, Mod, SubMod, Format, ConsumeList, [{Type, TypeId, Num}|Return]);
        _ ->
            ?ERR("trans_consume_record, RoleId:~p,Mod:~p,SubMod:~p,Item:~p", [PS#player_status.id, Mod, SubMod, Item]),
            trans_consume_record(PS, Mod, SubMod, Format, ConsumeList, Return)
    end.

format_consume_record(Format, Goods, Num) ->
    F = fun(Atom, List) ->
        case Atom of 
            bind ->
                [{bind, Goods#goods.bind}|List];
            _ ->
                List
        end
    end,
    AttrList = lists:foldl(F, [], Format),
    {?TYPE_ATTR_GOODS, Goods#goods.goods_id, Num, AttrList}.

format_goods_plus(FormatGoods) ->
	format_goods_plus(FormatGoods, [], []).

format_goods_plus([], NormalGoods, AttrGoods) ->
	F = fun({Key, Num}, List) ->
		{?TYPE_ATTR_GOODS, TypeId, AttrList} = Key,
		[{?TYPE_ATTR_GOODS, TypeId, Num, AttrList}|List]
	end,
	NormalGoods ++ lists:foldl(F, [], AttrGoods);
format_goods_plus([Item|FormatGoods], NormalGoods, AttrGoods) ->
	case Item of 
		{?TYPE_ATTR_GOODS, TypeId, Num, AttrList} ->
			NAttrList = ?IF(AttrList == [], [], lists:keysort(1, AttrList)),
			Key = {?TYPE_ATTR_GOODS, TypeId, NAttrList},
			case lists:keyfind(Key, 1, AttrGoods) of 
				{_, OldNum} -> NewAttrGoods = lists:keystore(Key, 1, AttrGoods, {Key, OldNum+Num});
				_ -> NewAttrGoods = [{Key, Num}|AttrGoods]
			end,
			format_goods_plus(FormatGoods, NormalGoods, NewAttrGoods);
		_ ->
			format_goods_plus(FormatGoods, [Item|NormalGoods], AttrGoods)
	end.

db_replace_consume_record(ConsumeRecord) ->
	#consume_record{
		id = Id, role_id = RoleId, mod = Mod, sub_mod = SubMod, mod_key = ModKey, consume_list = ConsumeList, time = Time
	} = ConsumeRecord,
	Sql = usql:replace(consume_record, [id, role_id, mod_key, mod, sub_mod, consume_list, time], [[Id, RoleId, util:term_to_bitstring(ModKey), Mod, SubMod, util:term_to_bitstring(ConsumeList), Time]]),
	db:execute(Sql).

db_delete_consume_record(IdList) ->
	Sql = io_lib:format("delete from consume_record where id in (~s)", [ulists:list_to_string(IdList, ",")]),
    db:execute(Sql).

db_select_consume_record_by_role_id(RoleId) ->
    Sql = usql:select(consume_record, [id, mod_key, mod, sub_mod, consume_list, time], [{role_id, RoleId}]),
    db:get_all(Sql).

db_update_consume_list(ConsumeRecord) ->
	#consume_record{
		id = Id, consume_list = ConsumeList
	} = ConsumeRecord,	
	Sql = io_lib:format("update consume_record set consume_list = '~s' where id = ~p", [util:term_to_bitstring(ConsumeList), Id]),
	db:execute(Sql).