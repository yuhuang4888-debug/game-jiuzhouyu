%%-----------------------------------------------------------------------------
%% @Module  :       top_pk.hrl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-05
%% @Description:    巅峰竞技
%%-----------------------------------------------------------------------------

-define (DAILY_ID_REWARD_STATE, 1).     %% 日常id 用来标识今天是否领过每日荣誉值
-define (DAILY_ID_ENTER_COUNT, 2).      %% 每日进入次数
-define (DAILY_ID_BUY_COUNT, 3).        %% 每日购买次数
-define (DAILY_ID_COUNT_REWARD_MARK, 4).%% 日常id 用来标识今天领过次数奖励的状态 2#0000000000000000 标识领过第1 5 10次的奖励 有点意思

-define (STATE_NONE, 0).        %% DAILY_ID_REWARD_STATE 的值的含义 未设置
-define (STATE_SETUP, 1).       %% DAILY_ID_REWARD_STATE 的值的含义 已设置未领取
-define (STATE_GOT, 2).         %% DAILY_ID_REWARD_STATE 的值的含义 已经领取

-define (RANK_NUM_MAX, 1000).     %% 排行榜最多人数

-define(rank_show_num_max, 50).   %% 排行榜显示长度
-define(top_rank_res_win,  1).   %% 胜利
-define(top_rank_res_fail, 0).   %% 失败

-define(season_reward_title, 2810001). %%邮件标题
-define(season_reward_content, 2810002). %% 邮件内容

-define(rank_iron,   1).        %% 黑铁段位
-define(rank_bronze, 2).        %% 青铜段位



-define(top_pk_stage_wait, 1).  %% 等待阶段
-define(top_pk_stage_pk,   2).  %% pk阶段
-define(top_pk_stage_quit, 3).  %% 退出阶段

-define(top_pk_hp_ratio,   10000000). %%血量倍数

-define(top_pk_not_lv_limit_cmd, [28101, 28105, 28107, 28115]). %% 不受等级限制协议
-define(top_pk_fake_man_min_lv, 300).  %% 假人最下等级


%% 段位配置
-record (base_top_pk_grade, {
    grade_num,      %% 段位序号
    name,           %% 段位名
    max_star,       %% 最大星数
    rewards         %% 段位奖励
    }).

%% 段位星级配置
-record (base_top_pk_grade_detail, {
    grade_num,  %% 段位     
    star_num,   %% 星级
    win_star,   %% 胜利获得星数
    lose_star,  %% 失败失去星数
    honor_value,    %% 可领的每日荣誉值
    rewards         %% 赛季奖励
    }).

%% 段位奖励
-record (base_top_pk_rank_reward, {
    rank_lv         = 0,    %% 段位等级
    big_rank        = 0,    %% 大段位
    rank_name       = "",   %% 段位名称
    point           = 0,    %% 下一阶所需要达到的积分
    day_reward      = [],   %% 每日奖励
    local_day_reward = [],  %% 本服每日奖励
    is_stage_reward = 0,    %% 是否阶段奖励 1:是 0 否
    stage_reward    = [],   %% 阶段奖励
    local_stage_reward = [],%% 本服阶段奖励
    other_reward    = [],   %% 其他奖励
    resource_id     = []    %% '资源id'
}).

%% 巅峰竞技玩家状态 是被动初始化的，使用的时候请确认已经调用过load_data()
-record (top_pk_status, {   
    season_id = 0   %% 赛季id
    ,grade_num = 1  %% 段位
    ,rank_lv   = 1  %% 段位等级
    ,star_num = 0   %% 星级
    ,point    = 0   %% 积分
    ,history_match_count = 0    %% 历史匹配次数
    ,history_win_count = 0      %% 历史胜利次数
    ,serial_win_count = 0       %% 连胜次数
    ,serial_fail_count = 0      %% 连败次数
    ,season_match_count = 0     %% 赛季匹配次数
    ,season_win_count = 0       %% 赛季胜利次数
    ,season_reward_status = 0   %% 赛季段位奖励状态 2#0000000000000000000000000000000000000000000000000000000000000000  %%64位，对应64个小段 0是未领取 1是已经领取
    ,daily_honor_value = 0      %% 可领的每日荣誉值
    ,pk_state = []              %% 匹配状态
    ,season_end_time = []       %% 记录的赛季结束时间
    ,yesterday_rank_lv = 1      %% 昨天的段位信息
    ,ref               = []     %% 延迟定时器
    }).


-record (rank_role, {
    role_id = 0,            %% 玩家id
    role_name = "",         %% 玩家名
    career = 0,             %% 职业
    power = 0,              %% 战力
    guild_name = "",        %% 帮派名
    platform = "",          %% 平台
    server = 0,             %% 服务器编号
    server_id = 0,          %% 服务器id
    grade_num = 0,          %% 段位
    star_num = 0            %% 星级  %% 废弃
    ,rank_lv  = 1           %% 段位等级
    ,point   = 0            %% 积分
    ,match_count = 0        %% 匹配次数
    }).


-record(match_info, {
    role_key,       %% {node(), roleId}
    grade_num,      %% 大段位
    star_num,       %% todo
    match_step = 0, %% 走到第几步，未开始的时候为0
    match_time,     %% 匹配时间
    platform,       %% 平台标识
    serv_num,       %% 服名称
    name,           %% 玩家名称
    power,          %% 战力
    point,          %% 当前积分
    rank_lv         %% 段位等级
%%	, rank_float = 0  %% 段位浮动,允许玩家上下浮动差距
}).