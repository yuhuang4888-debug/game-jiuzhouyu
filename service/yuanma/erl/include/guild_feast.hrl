%%-----------------------------------------------------------------------------
%% @Module  :       guild_feast
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-02
%% @Description:    公会晚宴
%%-----------------------------------------------------------------------------

-define(ACT_STATUS_CLOSE, 0).
-define(ACT_STATUS_OPEN, 1).
-define(ACT_STATUS_EXIT, 2).

-define(QUIZ_STATUS_CLOSE, 0).
-define(QUIZ_STATUS_ANSWER, 1).
-define(QUIZ_STATUS_WAIT, 2).
-define(QUIZ_STATUS_DRADON, 3).
%%-define(DRAGON_POINT,  5).   %%答对一题所得龙魂,或者一个火苗对于龙魂
-define(GUILD_FEAST_STAGE_FIRE, 1).     %%晚会阶段 篝火
%%-define(GUILD_FEAST_STAGE_QUESTION_WAIT, 2). %%晚会阶段 答题准备
%%-define(GUILD_FEAST_STAGE_QUESTION, 3). %%晚会阶段 答题
%%-define(GUILD_FEAST_STAGE_DRAGON_WAIT, 4).   %%晚会阶段 远古巨龙准备阶段
%%-define(GUILD_FEAST_STAGE_DRAGON, 5).   %%晚会阶段 远古巨龙

-define(GUILD_BOSS_WAIT, 1).            %%公会boss 公会boss等待阶段
-define(GUILD_BOSS_SUMMON, 2).          %%晚会阶段  公会boss召唤阶段
-define(GUILD_FEAST_STAGE_QUESTION_WAIT, 3). %%晚会阶段 答题准备
-define(GUILD_FEAST_STAGE_QUESTION, 4). %%晚会阶段 答题(新版融合了轮换小游戏)
-define(GUILD_FEAST_STAGE_DRAGON_WAIT, 5).   %%晚会阶段 远古巨龙准备阶段
-define(GUILD_FEAST_STAGE_DRAGON, 6).   %%晚会阶段 远古巨龙



-define(white_fire,  1). %%白色火苗
-define(blue_fire,   2). %%蓝色火苗
-define(purple_fire, 3). %%紫色火苗


-define(no_one_right_answer, 27).    %%一个人都没答对的传闻id
-define(no_one_right_answer_last, 37).  % 最后一题没人答对
-define(first_right_answer,  21).    %%第一名答对传闻id
-define(person_right_answer, 22).    %%个人答对传闻id
-define(person_err_answer,   23).    %%个人答错传闻id
-define(first_right_answer_kf,  36).    % 跨服第一名答对传闻id

-define(can_summon_dragon,   1).     %%可以召唤远古巨龙
-define(can_not_summon_dragon,   0). %%可以召唤远古巨龙

-define(reborn_time,  10).  %% 10秒复活

-define(min_quiz_time, 5).  %% 答对一题后，剩余时间

-define(tv_rank_limit, 10).  %%公会排名传闻,小于等于 10名则发送传闻


% -define(?GFEAST_QUIZ_KEY, fun(GuildId) ->
%     lists:concat(["P_GFeast_Quiz_Topic_", GuildId])                %% 晚宴答题题库 #{GuildId => [TopicId]}
% end).

-define(DEF_SCENE_PID, 0).      %% 默认场景池id

-define(RANK_LEN, 10).          %%长度

-define(GAME_TYPE_CTRL, data_guild_feast:get_cfg(game_type_ctrl)). % 每周游戏轮换控制
-define(MINI_GAME_NOT_FINISHED, 0). % 小游戏未结束
-define(MINI_GAME_HAS_FINISHED, 1). % 小游戏已结束

%% 公会晚宴常量配置
-record(gfeast_cfg, {
	id = 0,
	key = "",
	val = 0,
	desc = ""
}).

%% 公会晚宴答题配置
-record(gfeast_topic_cfg, {
	id = 0,                     %% 题目id
	content = "",               %% 题目内容
	answer = ""                 %% 答案
}).


%% 公会晚宴答题配置 ---           新的，上面的record暂时废置
-record(gfeast_question_cfg, {
	id = 0                              %% 题目id
	, weight = 0                        %% 权重
	, topic_type = 1                    %% 题目类型1选择题2问答题
	, question = ""                     %% 题目
	, right = 0                         %% 正确选择题答案 1,2,3,4
	, right_answer = ""                 %% 正确文本答案
	, answer1 = ""                      %% 选项1
	, answer2 = ""                      %% 选项2
	, answer3 = ""                      %% 选项3
	, answer4 = ""                      %% 选项4
}).


-record(status_gfeast, {
	status = 0,                 %% 0: 未开启 1: 已开启
	stage = 0,                  %% 阶段 0:未开启， 1，篝火，2：篝火到答题等待， 3：答题， 4：答题到巨龙准备，5 巨龙阶段
	etime = 0,                  %% 当前状态结束时间
    game_type = undefined,      %% 宴会二阶段游戏类型 quiz | note_crash
	quiz_stime = 0,             %% 答题开始时间
	gfeast_reward = #{},        %% 宴会 #{RoleId => #gfeast_role_reward{}}  %%现在也不用了
	gfeast_guild = [],          %% 参与的帮派id列表  [#gfeast_guild{}]
	gfeast_rank = [],           %% 答题积分排行榜 [#gfeast_rank_info{}]
    mini_game_rank = [],        %% 小游戏分数排行榜 [#gfeast_rank_role{},...] (接入小游戏新增)
	ref = [],                   %% 活动定时器
	mon_map = #{},              %% 怪物map  #{MonId => {GuildId, ref（超时定时器）}}
	fire_map = #{},             %% 篝火map   #{guildId => {FireId}}
	fire_exp_map = #{},         %% #{role_id, exp}
	quiz_ref = []               %% 答题定时器,
	,quiz_pid = undefine        %% 答题进程  废弃
    ,quiz_map = #{}             %% 答题题目状态 #{题目id => 是否结束(true | false)}
	,stage_ref                  %% 阶段定时器。
	,can_summon_ref = []        %% 限制召唤远古巨龙的定时器
	,can_summon_dragon = ?can_summon_dragon      %% 是否可以召唤远古巨龙 当然要在巨龙阶段且的情况下才能召唤远古巨龙
	,topic_list = []            %% 题目列表
	,is_kf  = 0                 %%  0 不是跨服  1 是跨服
	,send_act_end = 0           %%  0 向跨服没有发过结束信息  1  发过
	,gfeast_guild_rank = []     %%  公会积分排行榜 [#gfeast_guild_rank_info{}]
    ,guild_role_map = #{}       %% 公会玩家积分信息 #{GuildId => [{RoleId, RoleName, Point, Time},...]}
    ,role_list = []             %% 公会答题玩家信息（仅保存当前题目）
}).

-record(status_quiz, {
	status = 0,                 %% 0: 未开启 1: 答题中 2: 等待出题中
	etime = 0,                  %% 当前阶段结束时间
	guild_id = 0,               %% 公会id  %% 目前不用了
	tlist = [],                 %% 本次出题id列表
	tid = 0,                    %% 当前题目id
	type = 1,                   %% 题目类型 默认选择题， 1选择题，2， 问答题
	content = "",               %% 题目内容
	answer = "",                %% 题目正确文本答案
	right_answer = 0,           %% 选择题正确答案
	no1_name = undefine,        %% 第一名
	ref = []                    %% 题目定时器
	,rank  = 0                  %% 名次
    ,role_list = []             %% 答对的玩家信息 [#gfeast_rank_role{},...]
	,no    = 0                  %% 题号
	, question_list = []        %% 答题信息 [#question_msg{}]
	, guild_point_list = []     %%  [{guildId, name, point， time}]
	, guild_role_map = #{}      %% guildId => [{role_id, name, point, time}] 因为历史原因此处还没改成record
}).


%%答题信息
-record(question_msg,  {
	role_id = 0,                %% 玩家角色id
	role_name = "",             %% 玩家名称
	status     = 0 ,            %% 状态  0，本轮没有回答，1，本轮回答了
	rank    = 0,                %% 名次
	combo   = 0                 %% 连对次数
}).


%% 宴会个人奖励
-record(gfeast_role_reward, {   %% 基本不用了，废除
	scene_id = 0,               %% 玩家当前所在场景id 不在活动场景为0
	guild_id = 0,               %% 公会id
	receive_times = 0,          %% 领取奖励次数
	right_times = 0,            %% 答对次数
	exp = 0,                    %% 累计的经验奖励
	gdonate = 0,                %% 累计的贡献奖励
	last_exp_plus_time = 0,     %% 上次刷新经验时间
	last_donate_plus_time = 0   %% 上次刷新贡献时间
}).

%% 宴会参与的公会
-record(gfeast_guild, {
	guild_id = 0,               %% 公会id
	fire_list = [],             %% 篝火列表 [{fire_id, color}]
	role_list = [],             %% 玩家列表
	get_fire_list = [],         %% 获得火苗的玩家列表
	guild_name = "",            %% 公会名字
	quiz_pid = undefine,        %% 答题房间的进程pid
	score = 0,                  %% 答题积分  --弃用
 	dragon_point = 0,           %% 龙魂数量
	fire_wave = 0,              %% 火苗波数
	next_fire_time = 0,         %% 下一波时间戳
	ref = undefine,             %% 离场定时器  %%弃用
	pre_dragon_ref = []         %% 进去阶段4(巨龙等待阶段)的定时器
	,enter_dragon_ref = []      %% 进入巨龙模式(阶段5)定时器
	,dragon_time_out_ref = []   %% 巨龙time_out定时器
	,utime = 0                  %% 积分刷新时间
	,dragon_list = []           %% 召唤的巨龙列表
	,summon_card = 1            %% 当前的召唤卡
	,add_exp_ratio = 0              %% 经验加成
	,is_buy_food = 0            %%  是否买了高级菜肴，0 没有买，  1 买了， 一个公会只能买一次
}).

%% 宴会答题积分榜
-record(gfeast_rank_info, {
	role_id = 0,                %% 玩家id
	guild_id = 0,               %% 公会id
	guild_name = 0,             %% 公会名字
	rank_list  = [],            %% [#rank{}]    之前是公会内的排名， 现在是本服所有玩家，所以这没用了
	role_name  = "",            %% 玩家昵称
	score = 0,                  %% 积分
	rank_no = 0,                %% 排名
	get_reward_status = 0,      %% 0可以领取 1不可领取  默认可以领取，领取一次后，变为1
	utime = 0                   %% 积分刷新时间
}).

%% 宴会答题积分榜
-record(gfeast_guild_rank_info, {
	guild_id = 0,               %% 公会id
	guild_name = 0,             %% 公会名字
	rank_list  = [],            %% [{Rank, RoleName, point},...]
	score = 0,                  %% 积分
	rank_no = 0,                %% 排名
	utime = 0                   %% 积分刷新时间
}).

%% 宴会玩家信息
-record(gfeast_player, {
    id              = 0         % 玩家id
    ,lv             = 0         % 玩家等级
    ,name           = ""        % 玩家名
    ,pic            = ""        % 头像地址
    ,pic_ver        = 0         % 头像版本号
    ,gid            = 0         % 公会等级
    ,gname          = ""        % 公会名
    % ,pieces         = []        % 拥有的玩法宝箱碎片 [{PiecesId, Num}...]
    % ,tips           = []        % 拥有的宴会宝箱提示/纸条 [{TipsId, Args}]
    % ,input_times    = 0         % 密码输入次数
    % ,is_active      = false     % 是否可获得拍卖分红和在场奖励(在开启宴会宝箱前进过场)
    ,is_finished    = false     % 小游戏阶段是否已完成游戏
    ,tref           = []        % 小游戏计时
}).

%% 宴会排行榜个人信息
-record(gfeast_rank_role, {
    role_id         = 0         % 玩家id
    ,role_name      = ""        % 玩家名
    ,guild_id       = 0         % 公会名
    ,server_id      = 0         % 服id
    ,server_num     = 0         % 服数
    ,score          = 0         % 小游戏分数
    ,rank           = 0         % 名次
    ,time           = 0         % 时间
    ,other_infos    = #{}       % 其它游戏信息
}).

-record(rank,{
	rold_id = 0,                %% 玩家id
	role_name ="",              %% 玩家名字
	score     = 0,              %% 积分
	rank_no   = 0,              %% 排名
	utime     = 0               %% 积分刷新时间
}).

%%火苗生成池
-record(guild_fire_pool, {
	min_role_num = 0,           %% '最小人数',
	max_role_num = 0,           %% '最大人数',
	fire_num_pool = [],          %% '火苗数量生成池',
	blue_fire_pool = [],         %% '蓝火苗生成池',
	purple_fire_pool = []       %% '紫火苗生成池',
}).



-record(topic_status, {
	zone_map = #{} % #{ZoneId => [#server_group{},...]}
	,status = 0    %% 0 未开启，  1 开启了
	,group_msg = [] % [#transport_msg{},...]
}).



-record(server_group, {
	group_id   = 0,    %% 模式分组id
	zone_id = 0,
	topic_list = [],
	mod = 0 %% 模式id
%%	, tlist = [],                    %% 剩下的题目
	, right_tid = []                 %% 答对的题目
	,tid = 0                         %% 当前题目的id
    ,tmap = #{}                      % #{题目id => [#gfeast_rank_role{},...]}
    ,quiz_map = #{}                  % 答题题目状态 #{题目id => 是否结束(true | false)}
	,server_ids = []
	,server_num = []
	, guild_point_list = []     %%  [{guildId, ServerId,  name, point}]
	, guild_role_map = #{}      %%   guildId => [{RoleId, RoleName, Point, Time, ServerId, ServerNum},...]
    , mini_game_rank = []       % [#gfeast_rank_role{},...]
}).

-record(guild_topic_msg, {
	guild_id = 0 ,
	guild_name = "",
	point = 0,
	time = 0  %% 更新时间
}).

-define(sql_clear_special_currency,
	<<"DELETE from  player_special_currency where currency_id = ~p">>).