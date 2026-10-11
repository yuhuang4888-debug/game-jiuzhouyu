%%%---------------------------------------------------------------------
%%% 玩家历史镜像相关record定义
%%%---------------------------------------------------------------------

%% -define (ETS_MIRROR, ets_mirror).
%% -define (ETS_MIRROR_RANK, ets_mirror_rank).

%% -record (mirror_player, {
%% 	id 		   = 0,
%% 	rank_id    = 0,
%% 	lv 		   = 0,
%% 	hightest_combat_power = 0,
%% 	battle_attr= #{},
%% 	skill_list = [],
%% 	embattle_list = []
%% }).

%% -record (mirror_state, {
%% 	player_map = #{}, 		%% 玩家镜像数据 #{id => #mirror_player{}}
%% 	rank_map   = #{}, 		%% 镜像战力排行 #{rank_id => player_id}
%% 	player_tmp_map = #{},	%% 玩家镜像数据 #{id => #mirror_player{}} 注: 生成排行步骤四的临时player_map
%% 	rank_tmp_map   = #{}, 	%% 镜像战力排行 #{rank_id => player_id}   注: 生成排行步骤一的临时rank_map,此时player_map还未更新(rank_map，player_map需要保持同步)
%% 	ref 	   = none 		%% 定时器引用
%% }).

%% %% -------------------------- db相关宏定义 ---------------------------
%% -define (sql_player_mirror_insert,  	<<"insert ignore into `player_mirror`(`player_id`, `lv`, `hightest_combat_power`, `battle_attr`, `skill_list`,
%% 											`embattle_list`, `time`) values(~p, ~p, ~p, '~s', '~s', '~s', ~p)">>).
%% -define (sql_player_mirror_update,  	<<"update `player_mirror` set `lv` = ~p, `hightest_combat_power` =~p, `battle_attr` = '~s', `skill_list` = '~s',
%% 											`embattle_list` = '~s', `time` = ~p where `player_id` = ~p">>).
%% -define (sql_player_mirror_count, 		<<"select count(*) from `player_mirror`">>).
%% -define (sql_player_mirror_combatpower_select, 
%% 										<<"select `player_id`, `hightest_combat_power` from `player_mirror`">>).
%% -define (sql_player_mirror_delete, 		<<"delete  from `player_mirror` where  `player_id` = ~p">>).

%% -define (sql_player_mirror_rank_truncate,<<"truncate table `player_mirror_rank`">>).
%% -define (sql_player_mirror_rank_copy,   <<"replace into `player_mirror_rank`(`player_id`, `lv`, `hightest_combat_power`, `battle_attr`, `skill_list`,
%% 											`embattle_list`) select `player_id`, `lv`, `hightest_combat_power`, `battle_attr`, `skill_list`,
%% 											`embattle_list` from `player_mirror` limit ~p, ~p">>).
%% -define (sql_player_mirror_rank_update, <<"update `player_mirror_rank` set `rank_id` = ~p where `player_id` = ~p">>).
%% -define (sql_player_mirror_rank_select, <<"select `player_id`, `rank_id`, `lv`, `hightest_combat_power`, `battle_attr`, `skill_list`, `embattle_list` 
%% 											from `player_mirror_rank` limit ~p, ~p">>).
%% -define (sql_player_mirror_rank_select_all, 
%% 										<<"select `player_id`, `rank_id`, `lv`, `hightest_combat_power`, `battle_attr`, `skill_list`, `embattle_list` from `player_mirror_rank`">>).
%% -define (sql_player_mirror_rank_combatpower_select, 
%% 										<<"select `player_id`, `hightest_combat_power` from `player_mirror_rank`">>).
%% -define (sql_player_mirror_rankid_0_count,<<"select count(*) from `player_mirror_rank` where `rank_id` = 0">>).
