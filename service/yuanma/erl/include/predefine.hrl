%% ---------------------------------------------------------------------------
%% @doc predefine.erl
%% @author ming_up@foxmail.com
%% @since  2016-09-06
%% @deprecated 游戏定义
%% ---------------------------------------------------------------------------

%% 场景
-define(MAIN_CITY_SCENE,              10001).   %% 主城id
-define(MAIN_CITY_RAND_XY,    [{1177,1314}]).  %% 主城随机出生坐标点
-define(MAIN_CITY_SCENE_LIST,       [10001]).   %% 是否在主城
-define(BORN_SCENE,                   10000).   %% 新手出生场景id
-define(BORN_SCENE_COORD,       {4339, 1669}).  %% 新手场景出生点
-define(BORN_SPECAIL_TASK,        10000100).    %% 新手特殊任务

%% 玩家阵营
-define(REALM_KUNLUN,  1).   %% 1昆仑
-define(REALM_XUANDU,  2).   %% 2玄都
-define(REALM_PENGLAI, 3).   %% 3蓬莱

%% 所有阵营
-define(ALL_REALM, [?REALM_KUNLUN, ?REALM_XUANDU, ?REALM_PENGLAI]).

%% 性别
-define(MALE,          1).   %% 男
-define(FEMALE,        2).   %% 女

%% pk模式
-define(PK_PEACE,      0).   %% 和平:不能攻击任何人
-define(PK_ALL,        1).   %% 全体:所有人 
-define(PK_FORCE,      2).   %% 强制:攻击非同帮和非同队伍的其他玩家
-define(PK_SERVER,     3).   %% 同服(跨服)
-define(PK_GUILD,      4).   %% 公会:攻击非同帮的其他玩家##同队伍不同帮派也会攻击
-define(PK_CAMP,       5).   %% 阵营

% -define(PK_PEACE_ULTIMATE,      4).   %% 终极和平:不能攻击任何人且不能被任何人攻击
% -define(PK_SERVER_DEF, 11).  %% 跨服入侵防守
% -define(PK_SERVER_ATT, 12).  %% 跨服入侵进攻

%% 通用切换的pk模式 [场景类型使用:?SCENE_SUBTYPE_PK]
-define(PK_NORMAL_L, [?PK_PEACE, ?PK_ALL, ?PK_FORCE, ?PK_SERVER, ?PK_GUILD, ?PK_CAMP]).

%% 职业
-define(SOLDIER,    1).     %% 战士
-define(SWORDGIRL,  2).     %% 剑姬
-define(KNIGHT,     3).     %% 骑士
-define(ARCHER,     4).     %% 弓箭手

%% 开放的职业列表
-define(CAREER_LIST, [?SOLDIER, ?SWORDGIRL, ?KNIGHT, ?ARCHER]).

%% 计数器类型
-define(COUNTER_DAILY,      1). %% 日次数
-define(COUNTER_WEEK,       2). %% 周次数
-define(COUNTER_LIFETIME,   3). %% 终生次数

%% APPLY_CAST类型
-define(APPLY_CAST,         1). %% 进程cast方式执行MFA
-define(APPLY_CAST_STATUS,  2). %% 进程cast方式执行MFA，默认添加#status{}作为A的第一个参数
-define(APPLY_CAST_SAVE,    3). %% 进程cast方式执行MFA，默认添加#status{}作为A的第一个参数，且保存新的#status{}

%% APPLY_CALL类型
-define(APPLY_CALL,         1). %% 进程call方式执行MFA
-define(APPLY_CALL_STATUS,  2). %% 进程call方式执行MFA，默认添加#status{}作为A的第一个参数
-define(APPLY_CALL_SAVE,    3). %% 进程call方式执行MFA，默认添加#status{}作为A的第一个参数，且保存新的#status{}

%% HandleOffline类型
-define(NOT_HAND_OFFLINE,   0). %% HandleOffline类型：不处理离线情况
-define(HAND_OFFLINE,       1). %% HandleOffline类型：处理离线情况

%% 货币类型
-define(BGOLD_AND_GOLD, bgold_and_gold).    %% 绑定元宝和元宝（优先绑定元宝）
-define(BGOLD,          bgold).             %% 绑定元宝
-define(GOLD,           gold).              %% 元宝
-define(COIN,           coin).              %% 铜币
-define(GCOIN,          gcoin).             %% 公会币
-define(HONOUR,         honour).            %% 荣誉值
-define(CURRENCY,       currency).          %% 特殊货币

%% 影响SQL语句的非法字符
%% 增加\非法数据库操作字符: "\\\\"
-define(ESC_ILLEGAL_SQL_CHARS, ["'", "/" , "\"", "_", "<", ">", "\\\\"]).

%% 颜色类型0-7:物品的品质，怪物的颜色
-define(WHITE,             0).  %% 白色
-define(GREEN,             1).  %% 绿色
-define(BLUE,              2).  %% 蓝色
-define(PURPLE,            3).  %% 紫色
-define(ORANGE,            4).  %% 橙色
-define(RED,               5).  %% 红色
-define(DARK_GOLD,         6).  %% 暗金色
-define(PINK,              7).  %% 粉色
-define(DIAMOND,           8).  %% 钻石

%% 模型
-define(LV_MODEL,          1).  %% 模型：1等级模型
-define(FASHION_MODEL,     2).  %% 模型：2时装模型
-define(GOD_EQUIP_MODEL,   3).  %% 模型：3神装模型(神兵)
%% 部件
-define(MODEL_PART_CLOTH,  1).  %% 部件：1衣服
-define(MODEL_PART_WEAPON, 2).  %% 部件：2武器
-define(MODEL_PART_HEAD,   3).  %% 部件：3头部

%% 发送相关玩家值给客户端更新
-define(NOTIFY_ATTR,      1).   %% 玩家基本战斗属性
-define(NOTIFY_MONEY,     2).   %% 货币属性
-define(NOTIFY_PK,        3).   %% 罪恶值
-define(NOTIFY_CURRENCY,  4).   %% 特殊货币

%% 物品
-define(GOODS,        goods).   %% 物品宏

%% 登录类型
-define(RECONNECT_NO,     0).   %% 不需要重新连接或特殊处理
-define(NORMAL_LOGIN,     1).   %% 玩家进程不存在时的登录
-define(RE_LOGIN,         2).   %% 玩家进程还存在时的登录
-define(RECONNECT_DEAL,   3).   %% 重连处理了
-define(ONHOOK_AGENT_LOGIN,4).  %% 挂机代理登录

%% 登出类型
-define(NORMAL_LOGOUT,    1).   %% 真实登出
-define(DELAY_LOGOUT,     2).   %% 延迟登出

%% 登出日志类型
%% 注意事项
%% (1)延迟登出日志,可能会触发以下登出日志
%% 延迟登出 -> 离线挂机登出(玩家上线触发)
%% 延迟登出 -> 离线挂机没有挂机点登出
%% 延迟登出 -> 正常退出日志
-define(LOGOUT_LOG_NORMAL,      1).   %% 正常退出日志
-define(LOGOUT_LOG_ERROR,       2).   %% 异常退出日志
-define(LOGOUT_LOG_SERVER_STOP, 3).   %% 停服正常退出日志
-define(LOGOUT_LOG_DELAY,       4).   %% 中间延迟下线日志
-define(LOGOUT_LOG_FORBIDDEN,   5).   %% 玩家被封号下线
-define(LOGOUT_LOG_WAIGUA,      6).   %% 玩家使用外挂被踢下线
-define(LOGOUT_LOG_IP,          7).   %% 玩家IP重复被踢下线
-define(LOGOUT_LOG_DH,          8).   %% 玩家顶号操作
-define(LOGOUT_LOG_ONHOOK,      9).   %% 离线挂机登出(玩家上线触发)
-define(LOGOUT_LOG_ONHOOK_NO_PLACE, 10).    %% 离线挂机没有挂机点登出
-define(LOGOUT_LOG_AGENT_ONHOOK, 11). %% 服务端托管离线挂机登出
-define(LOGOUT_LOG_AGENT_ONHOOK_NO_PLACE, 12).  %% 托管离线挂机没有挂机点登出

%% 默认头像id
-define(SOLDIER_PICTURE,     <<"1">>).   %% 骑士头像
-define(SWORDGIRL_PICTURE,   <<"2">>).   %% 射手头像
-define(KNIGHT_PICTURE,      <<"3">>).   %% 骑士头像
-define(ARCHER_PICTURE,      <<"4">>).   %% 射手头像

-define(INIT_DRESS_UP_PICTURE,      <<"90">>).   %% 新版装扮头像

%% 属性记录日志
-define(ATTR_LOG_NO, 0).                %% 属性不记录
-define(ATTR_LOG_LOGOUT, 1).            %% 登出记录
-define(ATTR_LOG_LOGIN, 2).             %% 登录记录
-define(ATTR_LOG_LOGIN_AND_OUT, 3).     %% 登录登出记录

%% 本账号下是否首个角色
-define(ACC_FIRST_ROLE_UNCERT,  0).     %% 未确定是否首个角色
-define(ACC_FIRST_ROLE_TRUE,    1).     %% 账号下首个角色
-define(ACC_FIRST_ROLE_FALSE,   2).     %% 账号下非首个角色

%% 网络类型
-define(NETWORK_UNKNOWN,    0).     % 未知网络
-define(NETWORK_WIFI,       1).     % wifi
-define(NETWORK_MOBILE,     2).     % 移动网络