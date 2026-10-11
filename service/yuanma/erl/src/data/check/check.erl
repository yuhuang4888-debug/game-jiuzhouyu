%% ---------------------------------------------------------------------------
%% @doc 配置检测脚本
%% @author hek
%% @since  2016-05-16
%% @deprecated 本模块提供配置检测脚本
%% ---------------------------------------------------------------------------
-module(check).
-compile(export_all).
-include("common.hrl").
% -include("rec_husong.hrl").

%%% Note: 
%%% 游戏节点脚本启动前，调用配置检测脚本，只有检测通过时才启动游戏节点
%%% Usage:
%%% 1.少量检测在本模块新增一个check方法，并添加到main/1，如check_husong_data/0
%%% 2.大量检测，另起一个模块，并添加到添加到main/1
main(_) ->
	check_husong_data(),
	ok.

%% 检测护送配置
check_husong_data() ->
	% NpcList = lib_husong:get_kv_cfg(?CFG_KEY_HUSONG_NPC_LIST),
	% DayConfig = lib_husong:get_kv_cfg(?CFG_KEY_HUSONG_OPEN_DAY),
	% lists:foreach(
	% 	fun({ {MinOpenDay, MaxOpenDay}, SceneId, NpcId }) -> 
	% 		{ {MinOpenDay, MaxOpenDay}, SceneId, NpcId }
	% 	end, NpcList),
	% lists:foreach(
	% 	fun({ {MinOpenDay, MaxOpenDay}, OpenDayList }) -> 
	% 		{ {MinOpenDay, MaxOpenDay}, OpenDayList }
	% 	end, DayConfig),
	ok.
