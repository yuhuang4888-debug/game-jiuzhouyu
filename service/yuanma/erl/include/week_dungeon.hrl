

-define(WEEKDUN_KEY_1,     1).   

-record(weekdun_status, {
        dun_score = []
        , in_dungeon_data = #{}
    }).

-record(week_dungeon_data, {
        role_list = []
        , boss_map = #{}        % 
    }).

-record(week_dun_role, {
        role_id = 0
        , boss_drop = []        % 
    }).

-record(week_dun_rank_role, {
        role_id = 0
        , role_name = ""
        , server_id = 0
        , server_num = 0
    }).

-record(week_dun_result, {
        boss_map = #{}
        , week_dun_role = #week_dun_role{}        % 
        , is_all_help = false
    }).

-record(week_dun_state, {
        role_map = #{}          %% role_id => #week_dun_rank_role{}
        , rank_list = []        % [{DunId, List}]
        , rank_limit = []       % [{DunId, Limit}]
    }).

-record(week_dun_rank, {
        key = []          %% 玩家列表
        , pass_time = 0
        , time = 0
        , rank = 0
    }).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 配置
-record(base_week_dungeon, {
		dun_id = 0
        , dun_name = ""
        , single_dun_id = 0        % 单人模式下副本id
        , team_dun_id = 0          % 组队模式下副本id
        , single_rewards = []    % 通关奖励
        , team_rewards = []    % 通关奖励
        , revive_count = 0   % 复活次数0无限
        , help_count = 0     % 助战奖励次数
        , help_reward = []   % 助战奖励  
        , time_score = []    % 时间评分
        , dun_attr = []      % 玩家属性
        , active_skill = []
        , passive_skill = []
    }).

-record(base_week_dungeon_rank, {
        dun_id = 0
        , rank1 = 0        % 
        , rank2 = 0   % 
        , rewards = []       % 通关奖励
    }).

-record(base_week_dungeon_boss, {
        dun_id = 0
        , boss_id = 0        % 
        , rewards_view = []       % 奖励预览
    }).