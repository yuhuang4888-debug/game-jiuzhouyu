%% 公会声望
-define(SOURCE_LIMIT, 1).                     % 声望获取途径：有限制
-define(SOURCE_NOT_LIMIT, 2).                     % 声望获取途径：无有限制

%% 进程state
-record(prestige_state, {
        role_map = #{}
    }).

%% 玩家信息
-record(role_prestige, {
          role_id = 0                          % 玩家ID
        , job_id = 0                        % 职位id
        , all_prestige = 0                 % 总声望
        , high_title = 0                   % 历史最高头衔
        , old_guild = 0                    % 上一个公会的公会id(弃用)
        , records_init = 0
        , prestige_records = []             % 声望获取记录
    }).

-record(prestige_data, {
        prestige_got = 0                 % 获得值
        , got_source = 0                 % 获取途径
        , time = 0             % 时间戳
    }).


-define (SQL_PRESITGE_SELECT,	<<"select `role_id`, `all_prestige`, `high_title`, `old_guild` from `role_presitge`">>).
-define (SQL_PRESITGE_DATA,	<<"select `prestige_got`, `got_source`, `time` from `role_presitge_data` where role_id=~p">>).

-define (SQL_PRESITGE_REPLACE,	<<"replace into `role_presitge` set `role_id`=~p, `all_prestige`=~p, `high_title`=~p, `old_guild`=~p">>).
-define (SQL_PRESITGE_DATA_REPLACE,	<<"replace into `role_presitge_data` set `role_id`=~p, `prestige_got`=~p, `got_source`=~p, `time`=~p">>).

-define (SQL_PRESITGE_UPDATE,	<<"update `role_presitge` set `all_prestige`=~p where `role_id`=~p ">>).
-define (SQL_PRESITGE_TITLE_UPDATE,   <<"update `role_presitge` set `high_title`=~p where `role_id`=~p ">>).
-define (SQL_PRESITGE_GUILD_UPDATE,	<<"update `role_presitge` set `old_guild`=~p where `role_id`=~p ">>).
-define (SQL_PRESITGE_DELETE,	<<"delete from `role_presitge` where `role_id`=~p ">>).
-define (SQL_PRESITGE_DATA_DELETE,	<<"truncate table `role_presitge_data` ">>).
