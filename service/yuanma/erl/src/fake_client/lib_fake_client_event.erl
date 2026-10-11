%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_event.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client_event).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("fake_client.hrl").

-export([
	load_scene_success/1
	, change_scene_success/1
	, object_move/4
	, object_enter/2
	, object_leave/2
	, object_change_attr/4
	, drop_enter/2
	, drop_leave/2
	, drop_change_attr/4
	, close_fake_client/2
	]).


load_scene_success(PS) ->
	PS1 = lib_fake_client_api:load_scene_success(PS),
	%% 开启自动挂机(把挂机放在最后，可能一些模块数据会改变挂机行为)
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:start_behavior(PS1);
		_ ->
			lib_fake_client_battle:start_battle(PS1)
	end.

change_scene_success(PS) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			lib_player_behavior:stop_behavior(PS);
		_ ->
			PS
	end.

object_move(PS, BX, BY, Id) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{move, Id, BX, BY}])
	end.

object_enter(PS, ObjectList) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{enter, ObjectList}])
	end.

object_leave(PS, ObjectIdList) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{leave, ObjectIdList}])
	end.

object_change_attr(PS, Sign, Id, AttrList) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{change_attr, Sign, Id, AttrList}])
	end.

%% 新增掉落包
drop_enter(PS, DropList) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{drop_enter, DropList}])
	end.

%% 删除掉落包
drop_leave(PS, DropIdL) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{drop_leave, DropIdL}])
	end.

%% 掉落包信息修改
drop_change_attr(PS, DropId, RoleId, DropEndTime) ->
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS;
		_ ->
			lib_fake_client_battle:change_target(PS, [{drop_change, DropId, RoleId, DropEndTime}])
	end.

%% 关闭客户端
close_fake_client(PS, Msg) ->
	%% 先发奖励
	PS1 = lib_fake_client_goods:close_fake_client(PS, Msg),
	case lib_fake_client:get_onhook_type() of
		?ON_HOOK_BEHAVIOR ->
			PS2 = PS1;
		_ ->
			PS2 = lib_fake_client_battle:close_fake_client(PS1, Msg)
	end,
	PS3 = lib_fake_client_api:close_fake_client(PS2, Msg),
	PS3.

