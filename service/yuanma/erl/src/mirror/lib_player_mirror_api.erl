%% ---------------------------------------------------------------------------
%% @doc 玩家历史镜像(1个小时更新一次)
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (lib_player_mirror_api).
%% -include("rec_mirror.hrl").
%% -export ([
%% 	update_mirror_attr/1, 			%% 更新玩家镜像信息
%% 	get_mirror_rank_status/0, 		%% 获取镜像排行生成状态
%% 	get_mirror_rank_count/0, 		%% 获取镜像排行总数
%% 	get_player_id_by_rank_id/1, 	%% 根据历史镜像排名获取排名所在玩家id
%% 	timer_rank/0, 					%% 定时刷新玩家镜像排行
%% 	timer_rank/1,  					%% 定时刷新玩家镜像排行
%% 	cast_to_mirror/4 				%% 镜像cast方式到lib_player:apply_cast/6执行MFA	
%% ]).
%% -export ([
%% 	send_rival_list/5 				%% cast到镜像进程获取英雄战场对手信息
%% ]).

%% %% 更新玩家镜像信息
%% update_mirror_attr(PS) -> 
%% 	%% 镜像排行生成期间，不给更新
%% 	case get_mirror_rank_status() of 
%% 		0 -> lib_player_mirror_mod:update_mirror_attr(PS);
%% 		_ -> skip
%% 	end.

%% %% 获取镜像排行生成状态
%% %% @return 0空闲|1正在生成排行
%% get_mirror_rank_status() ->
%% 	case ets:lookup(?ETS_MIRROR, rank_status) of
%%         [] -> 0;
%%         [{_, RankStatus}] -> RankStatus
%%     end.

%% %% 获取镜像排行总数
%% get_mirror_rank_count() ->
%% 	case ets:lookup(?ETS_MIRROR, rank_count) of
%%         [] -> 0;
%%         [{_, RankCount}] -> RankCount
%%     end.

%% %% 根据历史镜像排名获取排名所在玩家id
%% get_player_id_by_rank_id(RankId) ->
%% 	case ets:lookup(?ETS_MIRROR_RANK, RankId) of
%%         [] -> 0;
%%         [{_, PlayerId}] -> PlayerId
%%     end.

%% %% 定时刷新玩家镜像排行
%% timer_rank() ->
%% 	timer_rank(1).

%% timer_rank(Stage) ->
%% 	mod_player_mirror:timer_rank(Stage).

%% %% 镜像cast方式到lib_player:apply_cast/6执行MFA
%% cast_to_mirror(PlayerId, M, F, A) ->
%% 	mod_player_mirror:cast_to_mirror(PlayerId, M, F, A).

%% %% cast到镜像进程获取英雄战场对手信息
%% send_rival_list(Cmd, PlayerId, Num, NumMax, AttackMap) ->
%% 	mod_player_mirror:send_rival_list({Cmd, PlayerId, Num, NumMax, AttackMap}).	
