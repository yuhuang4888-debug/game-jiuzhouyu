%% ---------------------------------------------------------------------------
%% @doc 活动参与记录服务api
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (lib_act_join_api).
-include ("common.hrl").
-include ("rec_act_join.hrl").

-export ([
	get_join/1,
	get_join_num/1,
	add_join/3,
	clear_module/1,
	quit_guild/1,
	add_authentication_player/1,
	get_authentication_player/2,
	get_authentication_player_num/2,
	clear_with_authentication_id/2
]).

%% 获取参与一个活动的玩家
%% @return [{PlayerId, GuildId}|...}
get_join(ModuleId) ->
	mod_act_join:get_join(ModuleId).

%% 获取参与一个活动参与人数
%% @return [{PlayerId, GuildId}|...}
get_join_num(ModuleId) ->
	mod_act_join:get_join_num(ModuleId).

%% 添加参与记录
add_join(PlayerId, GuildId, ModuleId) ->
	lib_log_api:join_log(PlayerId, GuildId, ModuleId),
	mod_act_join:add_join(PlayerId, GuildId, ModuleId),
	ok.

%% 清除一个活动参与记录
clear_module(ModuleId) ->
	mod_act_join:clear_module(ModuleId),
	ok.

%% 退出公会，清除活动参与记录
quit_guild(PlayerId) ->
	mod_act_join:quit_guild(PlayerId),
	ok.

%% AuthenticationList 由各自功能统计好玩家后，调用 mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE) 后得到的列表
%% AuthenticationList: [{AuthenticationId, PlayerId, GuildId, ModuleId}]
add_authentication_player(AuthenticationList) ->
	mod_act_join:add_authentication_player(AuthenticationList),
	ok.

%% 根据认证id和功能id获取参与玩家
%% @return [{PlayerId, GuildId}|...}
get_authentication_player(AuthenticationId, ModuleId) ->
	mod_act_join:get_authentication_player(AuthenticationId, ModuleId).

%% 获取参与一个活动参与人数
get_authentication_player_num(AuthenticationId, ModuleId) ->
	mod_act_join:get_authentication_player_num(AuthenticationId, ModuleId).

clear_with_authentication_id(AuthenticationId, ModuleId) ->
	mod_act_join:clear_with_authentication_id(AuthenticationId, ModuleId),
	ok.