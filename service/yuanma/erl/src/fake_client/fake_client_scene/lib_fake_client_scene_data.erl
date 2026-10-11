%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_scene_data.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 场景数据处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_scene_data).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("drop.hrl").
-include("def_fun.hrl").
-include("fake_client.hrl").

-compile(export_all).

-define(sign_to_key(Sign), 
	case Sign of 
		?BATTLE_SIGN_PLAYER -> user;
		_ -> object
	end).

%% 场景对象移动，更改坐标数据
user_move(PS, BX, BY, Id, _F, _FX, _FY) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = move(SceneObjectData, user, Id, BX, BY),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

object_move(PS, X, Y, Id) ->	
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = move(SceneObjectData, object, Id, X, Y),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

move(SceneObjectData, Key, Id, X, Y) ->
	ObjectMap = maps:get(Key, SceneObjectData, #{}),
	case maps:get(Id, ObjectMap, 0) of 
		#ets_scene_user{} = User ->
			NewObjectMap = maps:put(Id, User#ets_scene_user{x=X, y=Y}, ObjectMap),
			maps:put(Key, NewObjectMap, SceneObjectData);
		#scene_object{} = SObject ->
			NewObjectMap = maps:put(Id, SObject#scene_object{x=X, y=Y}, ObjectMap),
			maps:put(Key, NewObjectMap, SceneObjectData);
		_ -> SceneObjectData
	end.

%% 加载场景
load_scene(PS, UserList, MonList, PartnerList, NormalList, DummyList) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	%#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	%% 加载场景，重置scene_object_data
	SceneObjectData1 = add_object(#{}, user, lists:keydelete(RoleId, #ets_scene_user.id, UserList)),
	NewSceneObjectData = add_object(SceneObjectData1, object, MonList++PartnerList++NormalList++DummyList),
	NewFakeClient = FakeClient#fake_client{
		scene_object_data = NewSceneObjectData, 
		forbid_clt_mon = [],
		drop_goods_data = #{},
		forbid_pick = [],
		last_ten_xy = []
	},
	PS#player_status{fake_client = NewFakeClient}.

add_object(SceneObjectData, Key, ObjectList) ->
	ObjectMap = maps:get(Key, SceneObjectData, #{}),
	NewObjectMap = add_object(ObjectMap, ObjectList),
	maps:put(Key, NewObjectMap, SceneObjectData).

add_object(ObjectMap, []) -> ObjectMap;
add_object(ObjectMap, [Object|ObjectList]) ->
	case Object of 
		#ets_scene_user{id = Id} -> 
			NewObjectMap = maps:put(Id, Object, ObjectMap),
			add_object(NewObjectMap, ObjectList);
		#scene_object{id = Id} ->
			NewObjectMap = maps:put(Id, Object, ObjectMap),
			add_object(NewObjectMap, ObjectList);
		_ -> add_object(ObjectMap, ObjectList)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 场景对象进入视野
%% 玩家进入
user_enter(PS, UserList) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = add_object(SceneObjectData, user, lists:keydelete(RoleId, #ets_scene_user.id, UserList)),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

object_enter(PS, ObjectList) ->
	#player_status{id = _RoleId, fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = add_object(SceneObjectData, object, ObjectList),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 场景对象离开视野
%% 玩家离开
user_leave(PS, UserIdList) ->
	#player_status{id = RoleId, fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = remove_object(SceneObjectData, user, lists:delete(RoleId, UserIdList)),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

object_leave(PS, ObjectIdList) ->
	#player_status{id = _RoleId, fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	NewSceneObjectData = remove_object(SceneObjectData, object, ObjectIdList),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

remove_object(SceneObjectData, _Key, []) -> SceneObjectData;
remove_object(SceneObjectData, Key, ObjectIdList) ->
	ObjectMap = maps:get(Key, SceneObjectData, #{}),
	NewObjectMap = remove_object(ObjectMap, ObjectIdList),
	maps:put(Key, NewObjectMap, SceneObjectData).

remove_object(ObjectMap, []) -> ObjectMap;
remove_object(ObjectMap, [ObjectId|ObjectIdList]) ->
	NewObjectMap = maps:remove(ObjectId, ObjectMap),
	remove_object(NewObjectMap, ObjectIdList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 场景对象属性更改
object_change_attr(PS, Sign, Id, AttrList) ->
	#player_status{id = _RoleId, fake_client = FakeClient} = PS,
	#fake_client{scene_object_data = SceneObjectData} = FakeClient,
	Key = ?sign_to_key(Sign),
	NewSceneObjectData = object_change_attr2(SceneObjectData, Key, Id, AttrList),
	PS#player_status{fake_client = FakeClient#fake_client{scene_object_data = NewSceneObjectData}}.

object_change_attr2(SceneObjectData, Key, Id, AttrList) ->
	ObjectMap = maps:get(Key, SceneObjectData, #{}),
	case maps:get(Id, ObjectMap, 0) of 
		#ets_scene_user{id = Id} = User -> 
			NewObject = object_change_attr_do(User, AttrList),
			NewObjectMap = maps:put(Id, NewObject, ObjectMap),
			maps:put(Key, NewObjectMap, SceneObjectData);
		#scene_object{id = Id} = SObject ->
			NewObject = object_change_attr_do(SObject, AttrList),
			NewObjectMap = maps:put(Id, NewObject, ObjectMap),
			maps:put(Key, NewObjectMap, SceneObjectData);
		_ -> SceneObjectData
	end.

object_change_attr_do(User, []) -> User;
object_change_attr_do(User, [{K, V}|AttrList]) ->
	case K of 
		hide ->
			NewUser = ?IF(is_record(User, ets_scene_user), User#ets_scene_user{battle_attr = User#ets_scene_user.battle_attr#battle_attr{hide = V}},
				User#scene_object{battle_attr = User#scene_object.battle_attr#battle_attr{hide = V}}),
			object_change_attr_do(NewUser, AttrList);
		ghost ->
			NewUser = ?IF(is_record(User, ets_scene_user), User#ets_scene_user{battle_attr = User#ets_scene_user.battle_attr#battle_attr{ghost = V}},
				User#scene_object{battle_attr = User#scene_object.battle_attr#battle_attr{ghost = V}}),
			object_change_attr_do(NewUser, AttrList);
		group ->
			NewUser = ?IF(is_record(User, ets_scene_user), User#ets_scene_user{battle_attr = User#ets_scene_user.battle_attr#battle_attr{group = V}},
				User#scene_object{battle_attr = User#scene_object.battle_attr#battle_attr{group = V}}),
			object_change_attr_do(NewUser, AttrList);
		_ ->
			object_change_attr_do(User, AttrList)
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 掉落包处理
%%% 增加掉落包
drop_enter(PS, DropList) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{drop_goods_data = DropGoodsData} = FakeClient,
	NewDropGoodsData = add_drop_goods(DropList, DropGoodsData),
	PS#player_status{fake_client = FakeClient#fake_client{drop_goods_data = NewDropGoodsData}}.

%% 掉落包消失
drop_leave(PS, DropIdL) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{drop_goods_data = DropGoodsData} = FakeClient,
	NewDropGoodsData = maps:without(DropIdL, DropGoodsData),
	PS#player_status{fake_client = FakeClient#fake_client{drop_goods_data = NewDropGoodsData}}.

drop_change_attr(PS, DropId, RoleId, DropEndTime) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{drop_goods_data = DropGoodsData} = FakeClient,
	case maps:get(DropId, DropGoodsData, 0) of 
		0 -> PS;
		DropGoods ->
			NewDropGoods = DropGoods#ets_drop{pick_player_id = RoleId, pick_end_time = DropEndTime},
			NewDropGoodsData = maps:put(DropId, NewDropGoods, DropGoodsData),
			PS#player_status{fake_client = FakeClient#fake_client{drop_goods_data = NewDropGoodsData}}
	end.

add_drop_goods([], DropGoodsData) -> DropGoodsData;
add_drop_goods([DropGoods|DropList], DropGoodsData) ->
	add_drop_goods(DropList, maps:put(DropGoods#ets_drop.id, DropGoods, DropGoodsData)).

