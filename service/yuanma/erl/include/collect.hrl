%%-----------------------------------------------------------------------------
%% @Module  :       collect.hrl
%% @Author  :       huyihao
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-04-25
%% @Description:    我爱女神
%%-----------------------------------------------------------------------------

-define(TypeSelfNormal, 1).
-define(TypeSelfSpecial, 2).
-define(TypeDoubleExp, 1).
-define(TypeDoubleDungeon, 2).
-define(TypeBossReset, 3).
-define(TypeAllReward, 4).

-record(collect_state, {
    subtype_list = []
    }).

-record(collect_status, {
    exp_end_time = 0,
    drop_end_time = 0
    }).

-record(collect_info, {
    subtype = 0,
    all_point = 0,
    exp_end_time = 0,
    drop_end_time = 0,
    player_list = []
    }).

-record(collect_player_info, {
    role_id = 0,
    player_point = 0,
    get_reward_id_list = []         %% 获得的个人奖励id
    }).

-record(collect_all_reward_con, {
    subtype = 0,
    reward_id = 0,
    type = 0,
    point = 0,
    time = 0,
    goods_list = []
    }).

-record(collect_self_reward_con, {
    subtype = 0,
    type = 0,
    reward_id = 0,
    weight = 0,
    goods_list = [],
    stage_points = 0
    }).

-define(SelectCollectAllNumAllSql,
    <<"SELECT `subtype`, `all_point`, `exp_end_time`, `drop_end_time` FROM `collect_all_num`">>).
-define(ReplaceCollectAllNumSql,
    <<"REPLACE INTO `collect_all_num` (`subtype`, `all_point`, `exp_end_time`, `drop_end_time`) VALUES (~p, ~p, ~p, ~p)">>).
-define(DeleteCollectAllNumAllSql, 
    <<"DELETE FROM `collect_all_num`">>).
-define(DeleteCollectAllNumSql, 
    <<"DELETE FROM `collect_all_num` WHERE `subtype` IN (~s)">>).

-define(SelectCollectPlayerInfoAllSql,
    <<"SELECT `subtype`, `role_id`, `player_point`, `get_reward_id_list` FROM `collect_player_info`">>).
-define(ReplaceCollectPlayerInfoSql,
    <<"REPLACE INTO `collect_player_info` (`subtype`, `role_id`, `player_point`, `get_reward_id_list`) VALUES (~p, ~p, ~p, '~s')">>).
-define(DeleteCollectPlayerInfoSql, 
    <<"DELETE FROM `collect_player_info` WHERE `subtype` IN (~s)">>).