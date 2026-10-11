%% ---------------------------------------------------------------------------
%% @doc guild.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-19
%% @deprecated 公会
%% ---------------------------------------------------------------------------

%% @说明
%%  1.公会圣殿等级就是公会等级
%%  2.call进程判断的时候最好在玩家进程,不要在公会进程

%% ----------------------- 进程字典定义 -----------------------
%% 公会数据较大,使用进程State会导致存储和读取的性能差,目前使用进程字典来避免.

%% 公会进程的进程字典
-define(P_GUILD, "P_Guild"). % 公会Maps Value:#{GuildId => #guild{} }
-define(P_GUILD_MEMBER(GuildId), lists:concat(["P_Guild_Member_", GuildId])).   % 公会玩家Maps Value:#{MemberId => #guild_member{}}
-define(P_MEMBER_GUILD_ID, "P_Member_Guild_Id").  % 成员和公会id的Maps Value:#{玩家id => 公会id}
-define(P_GUILD_DEPOT, "P_Guild_Depot"). % 公会仓库
-define(P_GUILD_SKILL, "P_Guild_Skill"). % 公会技能

% -define(P_GUILD_BUILDING_LV(GuildId), lists:concat(["P_Guild_Building_Lv_", GuildId])).   % 建筑 Value:#{BuildingType => BuildingLv}
-define(P_POS_PERMISSION(GuildId), lists:concat(["P_Pos_Permission_", GuildId])).   % 职位权限 Value:#{Pos => #{PermissionType=IsAllow} }
-define(P_POS_NAME(GuildId), lists:concat(["P_Pos_Name_", GuildId])).   % 职位名字 Value:#{Pos => PositionName}

-define(P_GUILD_APPLY, "P_Guild_Apply").    % Value:#{ {RoleId, GuildId} => #guild_apply{} }
-define(P_GUILD_APPLY_GUILD, "P_Guild_Apply_Guild").  % Value:{GuildId => [RoleId|...]}

-define(P_GUILD_MERGE, "P_Guild_Merge").    % [#guild_merge{},...]

% -define(P_GUILD_WAR_SHINE_BUY(GuildId), lists:concat(["P_Guild_War_Shine_Buy_", GuildId])).    % 公会祭坛购买 Value:#guild_war_shine_buy{}
% -define(P_GUILD_WAR_SHINE_MACHINE(GuildId), lists:concat(["P_Guild_War_Shine_Machine_", GuildId])). % Value: [{MachineId, Num}|...]

-define(P_GUILD_DONATE_LOG(GuildId), lists:concat(["P_GUILD_DONATE_LOG_", GuildId])).   % 捐献日志 Value:[{Name, DonateNum, Gfunds, Time}|..]

-define(P_GUILD_SORT, "P_Guild_Sort"). % [GuildId]

-define(P_SANCTUARY_GUILD, "P_Sanctuary_Guild"). % 公会Maps Value:#{GuildId => #guild{} }

%% ----------------------- 职位定义(#guild_member.position/.sec_position) -----------------------
-define(POS_CHIEF, 1).          % 会长
-define(POS_DUPTY_CHIEF, 2).    % 副会长
-define(POS_NORMAIL, 3).        % 普通成员 默认是普通成员
-define(POS_BABY, 4).           % 宝贝(男/女神)
-define(POS_ELITE, 5).          % 精英

%% 职位(用于初始化职位名字和职位权限列表)
-define(POS_LIST, [
        ?POS_NORMAIL
        , ?POS_DUPTY_CHIEF
        , ?POS_CHIEF
        , ?POS_BABY
        , ?POS_ELITE
    ]).

%% 能被任命的职位
-define(BE_APPOINT_POS_LIST, [
        ?POS_NORMAIL
        , ?POS_DUPTY_CHIEF
        , ?POS_BABY
        , ?POS_ELITE
    ]).

%% 能被修改权限的职位列表
% -define(MODIFIED_PERMISSION_POS_LIST, [
%         ?POS_BABY
%         , ?POS_DIRECTOR
%         , ?POS_DUPTY_CHIEF
%     ]).

%% ----------------------- 权限(permission) -----------------------
-define(PERMISSION_APPROVE_APPLY, 1).               % 审批申请
-define(PERMISSION_APPOINT_POS, 2).                 % 任命职位
-define(PERMISSION_FIRE_MEMBER, 3).                 % 开除成员
-define(PERMISSION_MODIFY_TENET_AND_ANNOUNCE, 4).   % 宣言/公告修改
-define(PERMISSION_APPROVE_SETTING, 5).             % 审批设置
-define(PERMISSION_OPEN_ACT, 6).                    % 开启活动
-define(PERMISSION_UPGRADE_GUILD, 8).               % 升级公会
-define(PERMISSION_MANAGE_DEPOT, 9).                % 管理仓库
-define(PERMISSION_RESEARCH_SKILLS, 10).            % 技能管理
-define(PERMISSION_SEND_GUILD_MAIL, 11).            % 发送公会邮件
-define(PERMISSION_RENAME, 12).                     % 改名
-define(PERMISSION_MERGE_GUILD, 13).                % 合并公会

%% 可修改的权限列表
-define(MODIFIABLE_PERMISSION_LIST, [
        ?PERMISSION_APPROVE_APPLY
        , ?PERMISSION_FIRE_MEMBER
        , ?PERMISSION_UP_BUILDING
    ]).

%% ----------------------- #guild.apply_type -----------------------
-define(APPROVE_TYPE_AUTO, 0).          % 自动
-define(APPROVE_TYPE_MANUAL, 1).        % 手动

%% ----------------------- permission_type is_allow -----------------------
-define(IS_ALLOW_NO, 0).                % 不允许使用该权限
-define(IS_ALLOW_YES, 1).               % 允许

%% ----------------------- 搜索和匹配 -----------------------

%% 公会成员的搜索
%% search_guild_memer
-define(sgm_default, 0).                % 默认
-define(sgm_lv, 1).                     % 等级
-define(sgm_guild_pos, 2).              % 公会职位
-define(sgm_donate, 3).                 % 贡献
-define(sgm_liveness, 4).               % 活跃度
-define(sgm_online_pos_lv, 5).          % 根据在线,职位,等级降序(40006默认)
-define(sgm_pos_donate_lv_liveness, 6). % 根据职位,贡献,等级,活跃度降序(40008默认)
-define(sgm_pos_lv_donate, 7).          % 根据职位,等级,贡献降序(40016默认)

-define(sort_flag_desc, 0).             % 降序
-define(sort_flag_asc, 1).              % 升序

-define(member_type_all, 0).            % 所有成员
-define(member_type_online, 1).         % 在线成员
-define(member_type_logout, 2).         % 离线成员

%% search 的 特殊类型
-define(s_special_type_normal, 0).         % 正常
-define(s_special_type_take_me_first, 1).  % 提取自己在最前面

-define(MANUAL_APPOINT, 1).                 % 手动任命会长
-define(AUTO_APPOINT, 2).                   % 自动任命会长

-define(CREATE_GUILD, 0).                   % 创建公会
-define(DISBAND_REASON_ACTIVITY, 1).        % 活跃度不足自动解散
-define(DISBAND_REASON_MEMBER_NUM, 2).      % 人数达不到要求自动解散
-define(DISBAND_REASON_CHIEF_QUIT, 3).      % 会长退出公会
-define(DISBAND_REASON_GM, 4).              % GM解散公会
-define(DISBAND_REASON_CHIEF_DISBAND, 5).   % 会长主动解散
-define(DISBAND_REASON_GUILD_MERGE, 6).     % 公会合并解散

%% ----------------------- 事件定义 -----------------------

-define(GEVENT_APPOINT_POSITION_TO_CHIEF, 1).       % 任命成会长
-define(GEVENT_APPOINT_POSITION_TO_OTHER, 2).       % 任命成其他职位(除了会长，领袖，学徒)
-define(GEVENT_RENAME_POSITION, 3).                 % 修改职位称谓
-define(GEVENT_BECOME_NORAML_AF_APPOINT_OTHER_TO_CHIEF, 4).     % 在任命其他人为会长后旧会长第一职位变成普通成员
-define(GEVENT_CREATE_GUILD, 5).                   % 创建公会
-define(GEVENT_QUIT, 6).                           % 主动退出
-define(GEVENT_KICK_OUT, 7).                       % 被踢出公会
-define(GEVENT_UPGRADE_GUILD, 8).                  % 升级公会
-define(GEVENT_JOIN_GUILD, 9).                  % 加入公会

%% ----------------------- 日志定义 -----------------------

-define(SEPARATOR_STRING, "=>").

-define(GLOG_CREATE, 1).                % 创建公会
-define(GLOG_JOIN, 2).                  % 加入公会
-define(GLOG_KICK_OUT, 3).              % 踢出公会
-define(GLOG_POS_CHANGE, 4).            % 职位变动
-define(GLOG_DISBAND, 5).               % 解散公会
-define(GLOG_QUIT, 6).                  % 主动退出公会
-define(GLOG_AUTO_CHIEF, 7).            % 自动任命会长
% -define(GLOG_DONATE, 7).                % 捐献

%% ----------------------- 公会设置定义 -----------------------

-define(GUILD_SETTING_DEPOT_AUTO_DESTROY, 1).   % 公会仓库自动清理设置项

%% ----------------------- 其他定义 -----------------------
-define(GUILD_PID, misc:get_global_pid(mod_guild)). % 公会进程

-define(MAX_SMALLINT, 65535).                       % 最大的smallint数值
-define(MAX_INT, 4294967295).                       % 最大的int数值

-define(CAL_GUILD_POWER_VAILD_TIME, 86400 * 2).     % 超过这个离线时间不计入公会战力
-define(AUTO_DISBAND_OFFLINE_TIME, 86400 * 7).      % 公会所有成员离线超过这个时间自动解散
-define(AUTO_DISBAND_AF_WARNNING, 86400).           % 在解散警告时间多久后自动解散公会
-define(AUTO_DISBAND_NEED_NUM, 5).                  % 公会少于这个人数进入自动解散倒计时
-define(APPLY_EXPIRED_TIME, 86400).                 % 申请过期时间
-define(DEPOT_EXP_EXCHANGE_SCORE, 20000).            % 仓库里面的经验道具兑换需要积分
-define(DEPOT_EXP_GOODS_ID, data_guild_m:get_config(depot_exp_goods_id)).              % 仓库经验道具的物品类型id
-define(DEPOT_RECORD_SHOW_LEN,   80).               % 仓库记录显示长度限制
-define(DEPOT_RECORD_MAX_LEN,    100).              % 仓库记录缓存长度限制
-define(DONATE_RECORD_MAX_LEN,    100).              % 每日捐献记录缓存长度限制
-define(GUILD_DEPOT_EXCG_TASK_ID, data_guild:get_cfg(guild_depot_excg_task_id)).    % 公会仓库捐献任务id

%% ---------------------- 公会共用仓库操作 ----------------------
-define(GUILD_DEPOT_CTRL_ADD, 1).                    % 往仓库存放道具
-define(GUILD_DEPOT_CTRL_EXCHANGE, 2).               % 从仓库兑换道具
-define(GUILD_DEPOT_CTRL_DESTORY, 3).                % 销毁仓库道具
-define(GUILD_DEPOT_CTRL_AUTO_DESTORY, 4).           % 销毁仓库道具

%% ---------------------- 公会仓库特殊物品id ----------------------
-define(GUILD_DEPOT_SPECIAL_PROP, 0). % 仓库经验道具
-define(GUILD_DEPOT_TASK_EQUIP, 1).   % 兑换任务物品

%% ---------------------- 公会合并状态 ----------------------
-define(GUILD_MERGE_SELF,      0).  % 本公会
-define(GUILD_MERGE_REQUEST,   1).  % 已请求
-define(GUILD_MERGE_ALLOW,     2).  % 可合并
-define(GUILD_MERGE_NOT_ALLOW, 3).  % 不可合并
-define(GUILD_MERGE_AGREED,    4).  % 已同意
-define(GUILD_MERGE_NONE,     99).  % 无状态(玩家无公会)

%% ---------------------- 公会合并主副公会 ----------------------
-define(GUILD_MERGE_REL_NONE,       0). % 无公会
-define(GUILD_MERGE_REL_MASTER,     1). % 主公会
-define(GUILD_MERGE_REL_VICE,       2). % 副公会

%% ---------------------- 公会合并申请响应操作 ----------------------
-define(GUILD_MERGE_OP_AGREE,   1). % 同意合并
-define(GUILD_MERGE_OP_REFUSE,  2). % 拒绝合并

%% ---------------------- 公会晚宴 ----------------------
-define(guild_feast_top_num, 30).                    %公会晚宴，前几名的平均等级

%% ---------------------- 公会玩家消息类型 ----------------------
-define(GUILD_MEMBER_MSG_WELCOME, 1). % 入会欢迎
-define(GUILD_MEMBER_MSG_DAILY_TITLE_REWARD, 2). % 每日头衔礼包

%% ------------------------------------------------
%% @doc 游戏数据格式
%% ------------------------------------------------

%% ----------- 基础 --------------
%% 公会
-record(guild, {
        id = 0                          % 公会id
        , name = <<>>                   % 公会名字
        , name_upper = ""               % 公会名字（大写）
        , tenet = <<>>                  % 公会宣言
        , announce = <<>>               % 公会公告
        , chief_id = 0                  % 会长id
        , chief_name = <<>>             % 会长名字
        , lv = 0                        % 等级
        , realm = 0                     % 阵营
        , reputation = 0                % 声望(旧的排行榜要用到暂时不删除)
        , gfunds = 0                    % 公会资金
        , growth_val = 0                % 公会成长值
        , gactivity = 0                 % 公会活跃度
        , dun_score = 0                 % 公会副本积分
        , member_num = 0                % 公会成员数量
        , combat_power = 0              % 公会战力
        , combat_power_ten = 0          % 前十名战力
        , create_time = 0               % 创建时间
        , modify_times = 0              % 公告修改次数
        , modify_time = 0               % 公告修改时间
        , approve_type = 0              % 审批类型 0:自动 1:手动
        , auto_approve_lv = 0           % 自动加入的等级
        , auto_approve_power = 0        % 自动加入的战力
        , disband_warnning_time = 0     % 自动解散警告时间
        , division = 0                  % 公会争霸赛区评级
        , c_rename = 0                  % 免费改名次数 0: 没有免费改名 >1:能免费改名字
        , c_rename_time = 0             % 最后免费改名时间
    }).

%% 公会成员
-record(guild_member, {
        id = 0                          % 玩家ID
        , figure = undefined            % #figure{}
        , guild_id = 0                  % 公会ID
        , guild_name = <<>>             % 公会名称
        , position = 0                  % 职位
        , donate = 0                    % 贡献值
        , historical_donate = 0         % 本帮历史贡献值
        , prestige = 0                  % 声望值
        , prestige_title = 0            % 声望头衔
        , online_flag = 0               % 是否在线
        , combat_power = 0              % 玩家当前战力
        , h_combat_power = 0            % 历史最高战力
        , last_login_time = 0           % 最后登录时间
        , last_logout_time = 0          % 最后登出游戏时间
        , depot_score = 0               % 仓库积分
        , create_time = 0               % 入会时间
    }).

%% 公会请求
-record(guild_apply, {
        key = undefined                 % key值
        , role_id = 0                   % 玩家id
        , guild_id = 0                  % 公会id
        , create_time = 0               % 创建时间
    }).

%% 公会合并
-record(guild_merge, {
    key         = {0, 0},   % {申请公会id, 目标公会id}
    apply_gid   = 0,        % 申请公会id
    target_gid  = 0,        % 目标公会id
    master_gid  = 0,        % 主公会id
    status      = 0,        % 申请状态/公会合并状态 ?GUILD_MERGE_REQUEST | ?GUILD_MERGE_AGREED
    apply_time  = 0,        % 申请时间
    agree_time  = 0         % 同意时间
}).

%% 玩家进程status
-record(status_guild, {
        id = 0                          % 公会id
        , name = <<>>                   % 公会名字
        , lv = 0                        % 公会等级
        , position = 0                  % 职位
        , position_name = <<>>          % 职位名字
        , create_time = 0               % 入会时间
        , realm = 0                     % 阵营/势力
    }).

%% 公会仓库物品
-record(depot_goods, {
    id = 0,
    guild_id = 0,
    goods_id = 0,
    num = 0,
    color = 0,
    addition = [],
    extra_attr = [],
    rating = 0,
    overall_rating = 0,
    create_time = 0
    }).

%% 公会仓库操作记录
-record(depot_record, {
    id = 0,
    role_name = <<>>,
    type = 0,                           % 1:捐献 2:兑换 3:销毁
    goods_id = 0,
    type_id = 0,
    num = 0,
    color = 0,
    rating = 0,
    overall_rating = 0,
    addition = [],
    extra_attr = [],
    time = 0
    }).

%% 公会仓库
-record(guild_depot, {
    depot_goods = [],
    depot_record = [],
    record_len = 0,
    auto_destroy = {4, 4, 1} % 仓库自动清理设置 (默认:四阶 橙色 一星)
    }).

%% 公会技能
-record(guild_skill, {
    guild_id = 0,                      % 公会id
    skill_id = 0,                      % 技能id
    research_lv = 0                    % 研究等级
    }).

%% 公会技能 ps上的
-record(status_guild_skill, {
    attr = [],
    gskill_map = #{}
    }).

%% ------------------------------------------------
%% @doc 公会基础配置
%% ------------------------------------------------

%% ----------- 基础 --------------
%% 公会等级配置
-record(guild_lv_cfg, {
    lv = 0,
    member_capacity = 0,
    growth_val_limit = 0,
    upgrade_desc = ""
    }).

%% 公会职位配置
-record(guild_pos_cfg, {
    position = 0            % 职位(看宏)
    , name = ""             % 职位名字
    , permission_list = []  % 权限列表
    , num = 0               % 人数
}).

%% 公会技能
-define(DEFAULT_GSKILL_RESEARCH_LV,  3).    %% 默认公会技能研究等级
-record(guild_skill_cfg, {
    skill_id = 0            % 技能id
    , skill_name = ""       % 技能名
    , type = 0              % 类型 1: 基础技能 2: 高级技能
    , unlock_lv = 0         % 解锁需要的公会等级
}).

%% 公会技能研究
-record(guild_skill_research_cfg, {
    skill_id = 0                    % 技能id(技能配置表)
    , lv = 0                        % 等级
    , research_condition = []       % 研究条件
    , research_cost = []            % 研究消耗
    , learn_condition = []          % 学习条件
    , learn_cost = []               % 学习消耗
    , attr_list = []                % 属性加成
}).

%% 公会捐献配置
-record(base_guild_donate, {
    donate_type = 0                    % 捐献类型
    , donate_cost = []
    , donate_reward = []
    , donate_times = 0
}).

%% 公会捐献配置
-record(base_guild_activity_gift, {
    id = 0                    %
    , activity = 0
    , reward = []
    , icon = 0
}).
