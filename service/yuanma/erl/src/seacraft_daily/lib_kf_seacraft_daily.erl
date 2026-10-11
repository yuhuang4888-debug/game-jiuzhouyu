%%%-----------------------------------
%%% @Module      : lib_kf_seacraft_daily
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 一月 2020 17:14
%%% @Description : 海战日常
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_kf_seacraft_daily).
-author("carlos").
-include("common.hrl").
-include("errcode.hrl").
-include("seacraft_daily.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("clusters.hrl").

%% API
-export([]).



mon_be_kill(SceneId, Atter, Minfo, Klist) ->
	case lib_seacraft_daily:is_scene(SceneId) of
		true ->
			mod_kf_seacraft_daily:kill_mon(SceneId, Atter, Klist, Minfo);
		_ ->
			skip
	end.


%% 保存数据库
save_sea_msg_to_db(SeaMsg) ->
	save_sea_msg_only_to_db(SeaMsg),
	#sea_msg{rank_list = RankList, sea_id = SeaId} = SeaMsg,
	[save_role_single_to_db(Role, SeaId) ||Role <- RankList].

save_sea_msg_only_to_db(SeaMsg) ->
	#sea_msg{brick_num = Num, zone_id = ZoneId, sea_id = SeaId} = SeaMsg,
	Sql = io_lib:format(?save_sea_msg, [ZoneId, SeaId, Num]),
	db:execute(Sql).

save_role_single_to_db(RoleRank, SeaId) ->
	#role_rank{
		server_id = ServerId,
		server_num = ServerNum,
		server_name = ServerName,
		role_id = RoleId,
		role_name = RoleName,
		power = Power,
		pos = Pos,
		brick_num = Num
	} = RoleRank,
	Sql = io_lib:format(?save_role_rank, [RoleId, SeaId, util:fix_sql_str(RoleName), ServerId, ServerNum, ServerName, Pos, Num, Power]),
	db:execute(Sql).


send_role_be_kill_tv(NowSeaId, _KillServerId, KillServerNum,
	_AtterId, KillName, DefRoleSeaId, DefServerId, DefServerNum, _DefRoleId, DefRoleName) ->
	SeaName = lib_seacraft_daily:get_sea_name(NowSeaId),
%%	?MYLOG("cym", "send_role_be_kill_tv +++++++ ~n", []),
	ZoneId = lib_clusters_center_api:get_zone(DefServerId),
	ServerList = mod_zone_mgr:get_zone_server(ZoneId),
	[mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{camp, DefRoleSeaId}, ?MOD_SEACRAFT_DAILY, 2,
	[DefServerNum, util:make_sure_binary(DefRoleName), util:make_sure_binary(SeaName), KillServerNum, util:make_sure_binary(KillName), NowSeaId]])
		|| #zone_base{server_id = ServerId}<-ServerList].























