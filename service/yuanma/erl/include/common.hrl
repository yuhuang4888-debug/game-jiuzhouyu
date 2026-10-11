%%%------------------------------------------------
%%% File    : common.hrl
%%% Author  : xyao
%%% Created : 2011-06-14
%%% Description: 公共定义
%%%------------------------------------------------

-record(errorcode_msg, {
    type = "",
    about  = ""
}).

%% 游戏定义
%-define(DEV_SERVER, true). %% 是否外服环境 正式环境要去掉这个宏定义

%% 版本定义
%%  NOTE: 新增版本和新版本上线要重新核实相关配置，特别是时区问题
%%  一、必须要跟运营核实一遍 lib_vsn.erl 模块的所有配置
%%  二、必须要处理好时区 ?DEFAULT_UTC_ZONE 定义 和 lib_vsn:utc_zone/0 函数
%%  1、 国内和繁体版本是不用处理的，对应的时间配置也不会增加对应的时区转换函数(utime:utc_unixtime(时间戳))。（php帮忙处理的）
%%  2、 ?DEFAULT_UTC_ZONE 和 lib_vsn:utc_zone/0 一般不需要修改，因为都是以东八区来处理逻辑的。
%%  (1)[2021年8月11日]目前后台所有配置的时区都以东八区的时间（重点，后台时区都以北京时区！！！！），也就是北京时间。服务器重启的时候会重新计算时区，对应的时间配置会进行时区的转化（有一些版本根据需求排除掉）。
%%  (2)如果有一些版本的性能有问题，处理方式有两种，但是只能使用第一种情况，除非有特殊情况，那么需要跟主管和运营确认一下
%%      a、对应版本后台的时区转换成对应的时区，比如日本服就转化成日本时区，且对应的时间配置不要增加对应的时区转换函数(跟php说)
%%      b、对应版本后台的时区转换成对应的时区，比如日本服就转化成日本时区，对应 ?DEFAULT_UTC_ZONE 定义 和 lib_vsn:utc_zone/0 增加日本时区的定义。
-define(GAME_VER, 1).  %% 游戏版本定义 -- 同步不同语言版本的时候无需同步此宏, 数字含义如下：
-define(GAME_VER_NORMAL,    1). %% 普通版本
-define(GAME_VER_TW,        2). %% 台湾
-define(GAME_VER_EN,        3). %% 英文
-define(GAME_VER_HW,        4). %% 韩国
-define(GAME_VER_JP,        5). %% 日本
-define(GAME_VER_TH,        6). %% 泰文
-define(GAME_VER_BR,        7). %% 巴西
-define(GAME_VER_RU,        8). %% 俄罗斯
-define(GAME_VER_AR,        9). %% 中东
-define(GAME_VER_ID,        10).%% 印度尼西亚
-define(GAME_VER_VN,        11).%% 越南

%% 默认时区定义
%% NOTE:
-define(DEFAULT_UTC_ZONE,
    case ?GAME_VER of
        ?GAME_VER_NORMAL -> 8;
        ?GAME_VER_TW -> 8;
        _ -> 8
    end).

-ifdef(DEV_SERVER).             %% 是否开发环境
-define(IS_DEV_SERVER, true).
-else.
-define(IS_DEV_SERVER, false).
-endif.

-ifdef(DEV_SERVER).
-define(PRINT(F, A), io:format("~w[line:~4w]: "++F, [?MODULE, ?LINE | A])).
-define(PRINT(Expr, F, A), case Expr of true -> io:format("~w[line:~4w]: "++F, [?MODULE, ?LINE | A]); _ -> ok end).
-else.
-define(PRINT(_F, _A), no_print).
-define(PRINT(_Expr, _F, _A), no_print).
-endif.

-ifdef(DEV_SERVER).
-define(ERR_MSG(Cmd, ErrCode),
    case data_errorcode_msg:get(ErrCode) of
        #errorcode_msg{type = Type, about = Msg} ->
            io:format("~w[line:~w]:{~p, ~p, ~s}~n ", [?MODULE, ?LINE, Cmd, Type, ulists:list_to_bin(Msg) ]);
        _ ->
            io:format("~w[line:~w]:{~p, ~p}~n ", [?MODULE, ?LINE, Cmd, ErrCode])
    end).
-else.
-define(ERR_MSG(_Cmd, _ErrCode), no_print).
-endif.

%% ?ERR接口是否忽略调用mod_game_error value:: 1(忽略)
%% 假设?ERR接口调用mod_game_error抛异常，里面某处逻辑调用?ERR，?ERR再调用mod_game_error
%% 这样形成相互循环调用，故mod_game_error逻辑里面以及需要忽略的地方，应设置标识1(忽略)
%% -define(IGNORE_WEB_IN_ERR, ignore_web_in_err).
%% 重要必要消息记录到WEB后台:记录文件和WEB后台
-define(WEBERR(F, A, RoleId), util:weblog(F, A, ?MODULE, ?LINE, RoleId)).
-define(ERR(F, A), util:errlog(F, A, ?MODULE, ?LINE)).
-define(INFO(F, A), util:info(F, A, ?MODULE, ?LINE)).

-ifdef(DEV_SERVER).
-define(DEBUG(F, A), util:debug(F, A, ?MODULE, ?LINE)).
-define(MYLOG(LogName, F, A), util:log_file(LogName, F, A, ?MODULE, ?LINE)).   % 自己定义文件名
-define(MYLOG(Expr, LogName, F, A), case Expr of true -> ?MYLOG(LogName, F, A); _ -> ok end).
-else.
-define(DEBUG(_F, _A), no_debug).
-define(MYLOG(_NAME, _F, _A), no_mylog).
-define(MYLOG(_Expr, _NAME, _F, _A), no_mylog).
-endif.

%% 协议匹配失败日志记录
-define(CMDFLAG, true).
-define(CMDLOG(F, A), (fun()-> if ?CMDFLAG == true -> ?ERR(F, A); true -> skip end end)()).

%% 函数使用本宏定义不能定义A和B变量,否则报错就匹配失败
-define(TRY_CATCH(X), (fun()-> try X catch A : B -> ?ERR("~p : ~p : ~p : ~p\n", [??X, A, B, erlang:get_stacktrace()]), {A, B} end end)() ).

%%数据库
-define(DB, gsrv_mysql).

%% 节点类型
-define(NODE_GAME, 0).      %% 游戏节点
-define(NODE_CENTER, 1).    %% 跨服节点

%% 节点类型(重复了)
-define(CLS_TYPE_GAME, 0).          %% 游戏服
-define(CLS_TYPE_CENTER, 1).        %% 跨服中心

%% 节点node Id
-define(GAME_NODE_ID, 10).      %% 游戏服node id
-define(CLUSTERS_NODE_ID, 0).   %% 跨服中心node id

-define(SERVER_STATUS_CLOSE,    0). %% 服务器状态: 0关闭
-define(SERVER_STATUS_STARTED,  1). %% 服务器状态: 1开启
-define(SERVER_STATUS_STARTING, 2). %% 服务器状态: 2开启中

-define(CLUSTER_LINK_CLOSE, 0).     %% 跨服连接状态: 断开连接
-define(CLUSTER_LINK_CONNECTED, 1). %% 跨服连接状态: 已连接

-define(ONE_KBYTE,                     1024).  %% 1kb

-define(ONE_MIN,                         60).
-define(DIFF_SECONDS_0000_1970, 62167219200).
-define(ONE_DAY_SECONDS,              86400).
-define(ONE_WEEK_SECONDS,         (86400*7)).
-define(ONE_HOUR_SECONDS,             3600).

%% 逻辑天数
-define(LOGIC_NEW_DAY,                    0).  %% 0点为新的一天
-define(DAY_LOGIC_OFFSET_HOUR,            0).  %% 天数逻辑偏移小时
-define(DAY_LOGIC_OFFSET_SECONDS,         (?DAY_LOGIC_OFFSET_HOUR*3600)).

-ifdef(DEV_SERVER).
-define(DELAY_DAILY_TIME_SPACE, 1). % 开发可以尽快执行，避免有些刷新延迟太久测试不到
-else.
-define(DELAY_DAILY_TIME_SPACE, 20000). % 用20秒时间来消化全服在线玩家1个功能的日常刷新
-endif.

-define(OBJECT_TUPLE(Type, GoodsId, Num), {Type, GoodsId, Num}).

%% 奖励列表(object_list)-类型定义
-define(TYPE_GOODS,             0). %% 物品
-define(TYPE_GOLD,              1). %% 钻石
-define(TYPE_BGOLD,             2). %% 绑钻
-define(TYPE_COIN,              3). %% 金币
-define(TYPE_GDONATE,           4). %% 公会贡献度
-define(TYPE_EXP,               5). %% 经验
-define(TYPE_CHARM,             6). %% 魅力
-define(TYPE_FAME,              7). %% 名誉
-define(TYPE_GFUNDS,            8). %% 公会资金
-define(TYPE_FASHION_NUM,       9). %% 时装精华
-define(TYPE_RUNE,              10). %% 符文经验
-define(TYPE_SOUL,              11). %% 聚魂经验
-define(TYPE_ARTI_BLUE,         12). %% 神器强化积分蓝
-define(TYPE_ARTI_PURPLE,       13). %% 神器强化积分紫
-define(TYPE_ARTI_ORANGE,       14). %% 神器强化积分橙
-define(TYPE_RUNE_CHIP,         15). %% 符文碎片
-define(TYPE_HONOUR,            16). %% 竞技荣誉值
-define(TYPE_GUILD_GROWTH,      17). %% 公会成长值
-define(TYPE_STAR_POWER,        20). %% 星力积分
-define(TYPE_GUILD_ACTIVITY,    21). %% 公会活跃度
-define(TYPE_GUILD_DRAGON_MAT,  24). %% 公会龙魂
-define(TYPE_GUILD_PRESTIGE,    28). %% 公会声望
-define(TYPE_SEA_EXPLOIT,       29). %% 个人阵营功勋（海战）
-define(TYPE_BIND_GOODS,        100). %% 绑定物品
-define(TYPE_ATTR_GOODS,        101). %% 带有属性的物品 叠加类型物品只能带绑定属性 非叠加物品参考lib_goods_util:set_goods_info()的属性
-define(TYPE_CURRENCY,          255). %% 特殊货币类型

%% 每日计数器需要记录获取消耗的物品类型(lib_goods_util:do_cost_money/4 仍要手动处理)
-define(DAILY_COUNTER_REC_TYPES, [
    ?TYPE_GOLD, ?TYPE_BGOLD
]).

%% 玩家在线状态
-define(ONLINE_OFF,        0).   %% 玩家离线
-define(ONLINE_ON,         1).   %% 玩家在线
-define(ONLINE_OFF_ONHOOK, 2).   %% 玩家离线挂机中
-define(ONLINE_FAKE_ON,    3).   %% 伪在线

%% 玩家加经验类型
-define(ADD_EXP_NO,        0).   %% 无类型
-define(ADD_EXP_GM,        1).   %% GM
-define(ADD_EXP_TASK,      2).   %% 任务
-define(ADD_EXP_MON,       3).   %% 个人杀怪
-define(ADD_EXP_DUN,       4).   %% 副本(无加成)
-define(ADD_EXP_TEAM_MON,  5).   %% 队伍杀怪
-define(ADD_EXP_GOODS,     6).   %% 物品使用加经验
-define(ADD_EXP_ONHOOK,    7).   %% 离线经验找回
-define(ADD_EXP_GUILD_FEAST, 8).   %% 帮派宴会
-define(ADD_EXP_ONHOOK_GOODS,9). %% 挂机经验物品找回
-define(ADD_EXP_MIDDAY_PARTY, 10).   %% 午间晚会
-define(ADD_EXP_DUN_ADD, 11).   %% 副本有加成的
-define(ADD_EXP_HOLY_SPIRIT_BATTLEFIELD, 12).   %%圣灵战场
-define(ADD_EXP_SEA_DAILY, 13).   %%国战日常
-define(ADD_EXP_AFK,       14).   %% 挂机规则

%% 公共宏函数定义

%% 比较函数
-define (OP (A, Op, B), case Op of
    gt  -> A     >      B;  %% greater than
    lt  -> A     <      B;  %% less than
    eq  -> A    =:=     B;  %% equal
    ge  -> A    >=      B;  %% greater equal
    le  -> A    =<      B;  %% less equal
    _   -> false
end).

%% 时间
-define(SEC(X), timer:seconds(X)).      % 定时器时间

%% http
-define(HTTP_REQ_GIFT_CARD,     1).     % 礼包请求
-define(HTTP_REQ_COME_BACK,     2).     % 返利
-define(HTTP_REQ_WORDS_LIST,    3).     % 屏蔽词列表
-define(HTTP_REQ_WORDS_GET,     4).     % 屏蔽词内容

%% 屏蔽词
-define(WORD_GET_ALL,   1).     % 全部
-define(WORD_UPDATE,    2).     % 添加
-define(WORD_DELETE,    3).     % 删除

%% base_game.server_type
-define(SERVER_TYPE_NO,         0).     % 无设置
-define(SERVER_TYPE_OFFICIAL,   1).     % 正式服
-define(SERVER_TYPE_TEST,       2).     % 测试服
-define(SERVER_TYPE_SHENHE,     3).     % 审核服