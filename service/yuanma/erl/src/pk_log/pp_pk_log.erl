-module(pp_pk_log).

-export([handle/3]).

-include("server.hrl").
-include("pk_log.hrl").

handle(61900, Ps, []) ->
	#player_status{id = RoleId, pk_status = #pk_status{pk_log_map = PkMap}} = Ps,
	case maps:get(RoleId, PkMap, []) of
		#pk_log{kill_log = KillLog, kf_kill_log = KFkillLog} ->
			F = fun({SceneId, Sign, Time, AttrName, AttrId}, Acc) ->
				SceneName = lib_scene:get_scene_name(SceneId),
				[{Sign, Time, SceneName, AttrName, AttrId}|Acc]
			end,
			SendList = lists:foldl(F, [], KillLog),
			F2 = fun({KSceneId, KSign, KTime, KServerId, KServerNum, KAttrName, KAttrId}, KAcc) ->
				KSceneName = lib_scene:get_scene_name(KSceneId),
				[{KSign, KTime, KSceneName, KServerId, KServerNum, KAttrName, KAttrId}|KAcc]
			end,
			SendList2 = lists:foldl(F2, [], KFkillLog);
		[] ->	
			SendList = [], SendList2 = []
	end,
	lib_server_send:send_to_uid(RoleId, pt_619, 61900, [SendList, SendList2]);
%% 默认匹配
handle(_Cmd, Ps, _Data) ->
   {ok, Ps}.