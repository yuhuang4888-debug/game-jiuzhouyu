%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_scene_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 场景数据处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_scene_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("fake_client.hrl").

%% 
handle_proto(12001, PS, [BX, BY, Id, F, FX, FY]) ->
	%?PRINT("12001  : ~p~n", [{BX, BY, Id}]),
	NPS = lib_fake_client_scene_data:user_move(PS, BX, BY, Id, F, FX, FY),
	LastPS = lib_fake_client_event:object_move(NPS, BX, BY, Id),
	LastPS;

%% 加载场景
handle_proto(12002, PS, [UserList, MonList, PartnerList, NormalList, DummyList, _MarkList]) ->
	%?PRINT("12002 length(UserList), length(MonList), length(DummyList) : ~p~n", [{length(UserList), length(MonList), length(DummyList)}]),
	NPS = lib_fake_client_scene_data:load_scene(PS, UserList, MonList, PartnerList, NormalList, DummyList),
	LastPS = lib_fake_client_event:load_scene_success(NPS),
	LastPS;

%% 玩家进入
handle_proto(12003, PS, [User]) ->
	%?PRINT("12003 join User : ~p~n", [User#ets_scene_user.id]),
	NPS = lib_fake_client_scene_data:user_enter(PS, [User]),
	LastPS = lib_fake_client_event:object_enter(NPS, [User]),
	LastPS;

%% 玩家离开
handle_proto(12004, PS, [Id]) ->
	%?PRINT("12004 user disappear Id : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:user_leave(PS, [Id]),
	LastPS = lib_fake_client_event:object_leave(NPS, [Id]),
	LastPS;

%% 切换场景,直接加载场景
handle_proto(12005, PS, [_Id, _X, _Y, _ErrCode, _DunId, _Callback, _TransType]) ->
	%?PRINT("12005 change scene_id : ~p~n", [_Id]),
	{ok, NPS} = pp_scene:handle(12002, PS, server),
	LastPS = lib_fake_client_event:change_scene_success(NPS),
	LastPS;

%% 怪物消失
handle_proto(12006, PS, [Id]) ->
	%?PRINT("12006 mon disappear Id : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:object_leave(PS, [Id]),
	LastPS = lib_fake_client_event:object_leave(NPS, [Id]),
	LastPS;

%% 怪物进入视野
handle_proto(12007, PS, [SceneObject]) ->
	%?PRINT("12007 join Mon : ~p~n", [SceneObject#scene_object.id]),
	NPS = lib_fake_client_scene_data:object_enter(PS, [SceneObject]),
	LastPS = lib_fake_client_event:object_enter(NPS, [SceneObject]),
	LastPS;

%% 怪物移动
handle_proto(12008, PS, [X, Y, Id]) ->
	%?PRINT("12008 Mon move : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:object_move(PS, X, Y, Id),
	LastPS = lib_fake_client_event:object_move(NPS, X, Y, Id),
	LastPS;

%% 加载信息
handle_proto(12011, PS, [AddUserList, DelUserIdList]) ->
	%?PRINT("12011 load len(AddUserList), len(DelUserIdList) : ~p~n", [{length(AddUserList), length(DelUserIdList)}]),
	PS1 = lib_fake_client_scene_data:user_enter(PS, AddUserList),
	PS2 = lib_fake_client_scene_data:user_leave(PS1, DelUserIdList),
	NPS = lib_fake_client_event:object_enter(PS2, AddUserList),
	LastPS = lib_fake_client_event:object_leave(NPS, DelUserIdList),
	LastPS;

%% 加载怪物信息
handle_proto(12012, PS, [AddMonList, AddPartnerList, AddNormalList, AddDummyList, DelObjectIdList]) ->
	AddObjectList = AddMonList++AddPartnerList++AddNormalList++AddDummyList,
	%?PRINT("12012 load len(AddobjectList), len(DelobjectIdList) : ~p~n", [{length(AddObjectList), length(DelObjectIdList)}]),
	PS1 = lib_fake_client_scene_data:object_enter(PS, AddObjectList),
	PS2 = lib_fake_client_scene_data:object_leave(PS1, DelObjectIdList),
	NPS = lib_fake_client_event:object_enter(PS2, AddObjectList),
	LastPS = lib_fake_client_event:object_leave(NPS, DelObjectIdList),
	LastPS;

%% 怪物进入视野
handle_proto(12013, PS, [SceneObject]) ->
	%?PRINT("12013 join Mon : ~p~n", [SceneObject#scene_object.id]),
	NPS = lib_fake_client_scene_data:object_enter(PS, [SceneObject]),
	LastPS = lib_fake_client_event:object_enter(NPS, [SceneObject]),
	LastPS;

%% 怪物进入视野
handle_proto(12014, PS, [SceneObject]) ->
	%?PRINT("12014 join Mon : ~p~n", [SceneObject#scene_object.id]),
	NPS = lib_fake_client_scene_data:object_enter(PS, [SceneObject]),
	LastPS = lib_fake_client_event:object_enter(NPS, [SceneObject]),
	LastPS;

%% 怪物进入视野
handle_proto(12015, PS, [SceneObject]) ->
	%?PRINT("12015 join Mon : ~p~n", [SceneObject#scene_object.id]),
	NPS = lib_fake_client_scene_data:object_enter(PS, [SceneObject]),
	LastPS = lib_fake_client_event:object_enter(NPS, [SceneObject]),
	LastPS;

%% 掉落包
handle_proto(12017, PS, [_MonId, _Time, _Scene, _X, _Y, _Boss, DropList]) ->
	%?PRINT("12017 length(DropList) : ~p~n", [length(DropList)]),
	NPS = lib_fake_client_scene_data:drop_enter(PS, DropList),
	LastPS = lib_fake_client_event:drop_enter(NPS, DropList),
	LastPS;

%% 掉落包
handle_proto(12018, PS, [DropList]) ->
	%?PRINT("12018 length(DropList) : ~p~n", [length(DropList)]),
	NPS = lib_fake_client_scene_data:drop_enter(PS, DropList),
	LastPS = lib_fake_client_event:drop_enter(NPS, DropList),
	LastPS;

%% 掉落包消失
handle_proto(12019, PS, [DropIdL]) ->
	%?PRINT("12019 DropIdL : ~p~n", [DropIdL]),
	NPS = lib_fake_client_scene_data:drop_leave(PS, DropIdL),
	LastPS = lib_fake_client_event:drop_leave(NPS, DropIdL),
	LastPS;

%% 掉落包信息更新
handle_proto(12024, PS, [DropId, RoleId, DropEndTime]) ->
	%?PRINT("12024 DropId : ~p~n", [{DropId, RoleId, DropEndTime}]),
	NPS = lib_fake_client_scene_data:drop_change_attr(PS, DropId, RoleId, DropEndTime),
	LastPS = lib_fake_client_event:drop_change_attr(NPS, DropId, RoleId, DropEndTime),
	LastPS;


%% 隐藏属性
handle_proto(12070, PS, [Sign, Id, Hide]) ->
	%?PRINT("12070 hide : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:object_change_attr(PS, Sign, Id, [{hide, Hide}]),
	LastPS = lib_fake_client_event:object_change_attr(NPS, Sign, Id, [{hide, Hide}]),
	LastPS;

%% 幽灵属性
handle_proto(12071, PS, [Sign, Id, Ghost]) ->
	%?PRINT("12071 ghost : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:object_change_attr(PS, Sign, Id, [{ghost, Ghost}]),
	LastPS = lib_fake_client_event:object_change_attr(NPS, Sign, Id, [{ghost, Ghost}]),
	LastPS;

%% 分组属性
handle_proto(12072, PS, [Sign, Id, Group]) ->
	%?PRINT("12072 group : ~p~n", [Id]),
	NPS = lib_fake_client_scene_data:object_change_attr(PS, Sign, Id, [{group, Group}]),
	LastPS = lib_fake_client_event:object_change_attr(NPS, Sign, Id, [{group, Group}]),
	LastPS;

%% 复活信息
handle_proto(12083, PS, [ReviveType, _ScenceId, _X, _Y, _SceneName, _Hp, _Gold, _BGold, _AttProtectedTime]) ->
	%?PRINT("12083 12083 : ~p~n", [ReviveType]),
	case ReviveType of 
		2 -> %% 重新加载场景
			{ok, LastPS} = pp_scene:handle(12002, PS, server);
		_ -> %% 原地复活不处理
			LastPS = PS
	end,
	LastPS;

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    %?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.