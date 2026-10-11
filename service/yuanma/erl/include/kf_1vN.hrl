%%%-----------------------------------
%%% @Module  : lib_kf_1vN
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN 头文件
%%%-----------------------------------

-define(KF_1VN_FREE, 			0).		%% 空闲
-define(KF_1VN_SIGN, 			1).		%% 报名
-define(KF_1VN_RACE_1_PRE, 	    2).		%% 淘汰赛准备
-define(KF_1VN_RACE_1, 			3).		%% 淘汰赛
-define(KF_1VN_RACE_2_PRE, 		4).		%% 挑战赛准备
-define(KF_1VN_RACE_2, 			5).		%% 挑战赛
-define(KF_1VN_END, 			6).		%% 结束

-define(KF_1VN_STATE_WAIT, 		0).		%% 等待
-define(KF_1VN_STATE_BET, 		2).		%% 押注
-define(KF_1VN_STATE_MATCH, 	1).		%% 匹配
-define(KF_1VN_STATE_FIGHT, 	3).		%% 战斗
-define(KF_1VN_STATE_END, 	    4).		%% 结束

-define(KF_1VN_ROLE_WEED, 		0).		%% 淘汰
-define(KF_1VN_ROLE_WAIT, 		1).		%% 等待战斗
-define(KF_1VN_ROLE_FIGHT, 		2).		%% 对战中
-define(KF_1VN_ROLE_SIGN, 		3).		%% 报名
-define(KF_1VN_ROLE_FAIL,		4).		%% 擂主失败

-define (SIDE_CHALLENGER, 0).	%% 挑战者
-define (SIDE_DEF, 1).	%% 擂主


-define(KF_1VN_C_TYPE_PLAYER, 1).  %% 真实玩家
-define(KF_1VN_C_TYPE_ROBOT,  2).   %% 机器人

-define(KF_1VN_CFG_ENTER_LV,        1).   %% 进入等级配置key
-define(KF_1VN_CFG_RACE_1_XY,       2).   %% 资格赛双倍出生坐标配置key
-define(KF_1VN_CFG_DEF_XY,          3).   %% 擂主出生坐标配置key
-define(KF_1VN_CFG_CHALLENGER_XY,   4).   %% 挑战者出生坐标配置key
-define(KF_1VN_CFG_PER_SCENE_XY,    5).   %% 等待场景出生坐标配置key
-define(KF_1VN_CFG_BET_TIME,        6).   %% 竞猜时间配置key
-define(KF_1VN_CFG_ACT_MIN_NUM,     7).   %% 开活动的最低人数配置key
-define(KF_1VN_CFG_AREA_MIN_NUM,    8).   %% 每个区域的最低人数配置key
-define(KF_1VN_CFG_AUCTION_MIN_LV,  9).   %% 拍卖全服邮件最低等级（包含）
-define(KF_1VN_CFG_RACE_1_MAX_COUNT, 10). %% 资格赛最大次数配置key
-define(KF_1VN_CFG_BET_MAX_COUNT, 11).    %% 本轮次竞猜的最大次数
-define(KF_1VN_CFG_RACE_1_MAX_COUNT_CLIENT, 12).   %% 资格赛最大匹配次数##客户端使用
-define(KF_1VN_CFG_OPEN_DAY, 13).         %% 开服天数key

-define(RACE_1_MATCH_COUNT, 4).     %% 资格赛大于多少出机器人
%-define(RACE_1_MATCH_COUNT, -1).     %% 资格赛大于多少出机器人

%% 配置-1vN活动开启时间
-record(kf_1vN_time_cfg, {
        id = 0,             %% 活动唯一id
        open_week = [],     %% 周几开启
        signtime = {0, 0},  %% 报名开启时间
        optime = {0, 0},    %% 活动开启时间
        race_1_pre = 0,     %% 资格赛准备时间(s)
        race_1 = 0,         %% 资格赛时间(s)
        race_1_m_time = 0,  %% 资格赛匹配时间(s)
        race_1_b_time = 0,  %% 资格赛战斗时间(s)
        race_2_pre = 0,     %% 挑战赛准备时间(s)
        race_2 = 0,         %% 挑战赛时间(s)
        race_2_m_time = 0,  %% 挑战赛匹配时间(s)
        race_2_b_time = 0   %% 挑战赛战斗时间(s)
    }).

%% 配置-1vN分组
-record(kf_1vN_group, {
        id=0,
        hard=0,
        robot_args=0,
        height=0
    }).

%% 配置-1vN守擂匹配
-record(kf_1vN_race_2_match, {
        stage=0,
        hard=0,
        c_num=0
    }).

%% 配置-1vN拍卖匹配
-record(kf_1vN_auction_cfg, {
        id=0,
        goods=[],
        cost=[],
        ser_award=[]
    }).



%% 进程记录

%% 报名和竞猜记录
-record(kf_1vN_role_sign, {
        server_id = 0,
        id = 0,
        name = "",
        platform = "",                         % 平台标示
        server_num = 0,                        % 所在的服标示
        server_name = "",
        lv = 0,
        area = 0,
        % battle_id = 0,
        % bet_side=0,
        bet_list = [],      %% 竞猜列表##[{BattleId, BetSide}]
        combat_power=0,
        race_1_seed=0
    }).
%% 1vN角色基本信息
-record(kf_1vN_role, {
        id = 0,
        server_id=0,
        platform = "",                         % 平台标示
        server_num = 0,                        % 所在的服标示
        server_name = "",
        figure=undefined,
        attr=undefined,
        combat_power=0,     %% 匹配战力##最高战力
        n_combat_power = 0, %% 当前战力##客户端显示
        score=0,
        win=0,            %% 胜利次数
        race_1_times=0,
        race_1_match=0,   %% 资格赛匹配次数，影响匹配参数
        race_1_seed = 0,
        win_streak= 0,    %% 连胜次数
        lose_streak = 0,  %% 连败次数
        enter=0,
        area=0,
        out=0,            %% 是否在资格赛中被淘汰
        pk=0,             %% 是否战斗
        pk_time = 0,      %% 战斗结束时间
        exp = 0,
        pk_pid = undefined,
        scene_pool_id = 0,
        race_2_turn=0,
        race_2_time = 0,
        race_2_lose=0,
        race_2_match_heigh=0,
        race_2_side = 0,
        race_2_bet_id = 0,
        race_2_battle_id = 0,
        watch_battle_id = 0,
        hp = 0,           %% 资格赛胜利的血量
        hp_lim = 0        %% 资格赛胜利的血量上限
    }).

-record(kf_1vN_role_pk, {
        type = 0,  %% ?KF_1VN_C_TYPE_PLAYER|?KF_1VN_C_TYPE_ROBOT
        id = 0,
        server_id = 0,
        name = "",
        platform = "",                         % 平台标示
        server_num = 0,                        % 所在的服标示
        server_name = "",
        scene_pool_id=0,
        career = 0,
        sex= 1,
        turn = 0,               % 转生次数
        lv = 0,                 % 等级
        picture = "",
        picture_ver = 0,
        area = 0,
        score = 0,
        win = 0,
        win_streak = 0,
        lose_streak = 0,
        race_1_times = 0,
        attr=undefined,
        combat_power = 0,
        n_combat_power = 0, %% 当前战力##客户端显示
        is_dead = 0,
        hard = 0,
        is_quit = false
    }).

-record(kf_1vN_score_rank, {
        rank = 0,
        id = 0,
        server_id=0,
        platform = "",          % 平台标示
        server_num = 0,         % 所在的服标示
        server_name = "",
        name="",
        guild_name="",
        vip =0,
        score=0,
        win=0,
        lose=0,
        combat_power = 0,
        n_combat_power = 0, %% 当前战力##客户端显示
        career=0,
        lv=0                    % 等级
    }).

%% 活动时间信息
-record(kf_1vN_time, {
	sign_start = 0,				%% 报名开始时间
    race_1_pre_start = 0,       %% 资格赛等待开始时间
	race_1_start = 0,			%% 淘汰赛开启时间
	race_1_end = 0,				%% 淘汰赛结束时间
	race_2_pre_start = 0,		%% 挑战赛准备开启时间
    race_2_start = 0,			%% 挑战赛开启时间
    race_2_end = 0,             %% 挑战赛结束时间
	show = 0 					%% 展示时长
	}).

%% 活动数据
-record(kf_1vN_info, {
    ac_id=0,
	all_time = #kf_1vN_time{},	%% 整个活动开启的时间信息
	stage = 0,					%% 活动阶段:0空闲 1报名 2淘汰赛 3挑战赛准备 4挑战赛 5展示 6聊天时间
	start_time = 0,				%% 活动开启时间
	end_time = 0,				%% 活动结束时间(0表示动态结束)
	state = 0,					%% 活动状态(0空闲 1等待 2进行中 3押注 4战斗)
    ref=undefined               %% 定时器
	}).

-define(KF_1VN_RACE_2_AC_END_TYPE_NO, 0).       % 未结算
-define(KF_1VN_RACE_2_AC_END_TYPE_RESULT, 1).   % 结算了
-define(KF_1VN_RACE_2_AC_END_TYPE_READY, 2).    % 准备结算

%% 1vN 擂台赛记录
-record(kf_1vN_race_2, {
        def_list=[],
        challenger_list=[],
        match_list=[],
        battle_id = 1,
        bet_m=#{},              %% #{BattleId=>[{ServerId, Id, DefIsWin, _BetType},...]}
        def_rank=[]             %% 擂主排行##[#kf_1vN_def_rank{}]
        , ac_end_type = 0       %% 是否结算 0:未结算 1:结算了 2:准备结算
    }).

-define(KF_1VN_RACE_2_MATCH_STATUS_NO, 0).      % 未开始
-define(KF_1VN_RACE_2_MATCH_STATUS_END, 2).     % 结束

%% 1vN对战(匹配)列表
-record(kf_1vN_race_2_match_info, {
        battle_id = 0,
        status=0,           %% 0:未开始 2:结束
        scene_pool_id=0,
        copy_id=undefined,
        def_role=undefined,
        challengers=[],
        battle_win=0,       %% 0:无结算 1:擂主胜 2:挑战者胜利
        hp=0,               %% 擂主血量
        hp_lim=0,           %% 擂主血量上限
        live_num=0,         %% 挑战者存活数
        watch_ids=[],
        watch_num=0
    }).

%% 擂主排行
-record(kf_1vN_def_rank, {
        rank = 0,
        id = 0,
        server_id=0,
        platform = "",                         % 平台标示
        server_num=0,
        server_name = "",
        name="",
        guild_name="",
        vip =0,
        score=0,
        race_2_lose=0,          % 是否已经失败
        race_2_turn=1,          % 玩家轮次
        race_2_time=0,          % 存活时间
        combat_power = 0,
        n_combat_power = 0, %% 当前战力##客户端显示
        career = 0,
        enter=0,
        lv=0,                   % 等级
        hp = 0,           %% 资格赛胜利的血量
        hp_lim = 0        %% 资格赛胜利的血量上限
    }).

%% 挑战赛
-record(kf_1vN_challenger_rank, {
        rank = 0,
        id = 0,
        server_id=0,
        server_num=0,
        name="",
        guild_name="",
        vip =0,
        score=0,
        combat_power = 0,
        n_combat_power = 0, %% 当前战力##客户端显示
        career = 0,
        enter=0
    }).

%% 玩家记录
-record(status_kf1vn, {
       def_type=0,  %% 1擂主 2挑战者
       turn = 0     %% 擂主存活轮次
    }).

-define(KF_1VN_BET_STATUS_NO, 0).       % 未有结果
-define(KF_1VN_BET_STATUS_HAD_GET, 1).  % 已经领取
-define(KF_1VN_BET_STATUS_NOT_GET, 2).  % 未领取

%% 竞猜
-record(kf_1vN_bet, {
        key = 0             % key值,不存在数据库,只是用于辨别 <<Key:48>>=<<battle_id:16,bet_time:int32>>
        , battle_id = 0     % 战场id
        , bet_time = 0      % 押注时间,进入擂主赛准备时间就记录,用于作为本轮竞猜的主键
        , role_id = 0       % 玩家id
        , race_2_turn = 1   % 玩家轮次
        % , player_id = 0     % 擂主id
        , platform = ""     % 平台标示
        , server_num = 0    % 擂主服数
        , name = ""         % 擂主名字
        % , career = 0        % 擂主职业
        % , turn = 0          % 擂主转生
        % , sex = 0           % 擂主性别
        % , picture = ""      % 头像url
        % , picture_ver = 0   % 头像版本号
        , battle_result = 0 % 0 未有结果 1 擂主胜 2 挑战者胜
        % , bet_side = 0      % 废弃##1 擂主胜利 2 挑战者胜
        % , bet_type = 0      % 废弃##改成押注消耗类型
        , bet_cost_type = 0 % 押注消耗类型
        , bet_opt_no = 0    % 押注选项
        , bet_result = 0    % 0未有结果 1猜错 2猜对
        , status = 0        % 0未有结果 1已经领取 2未领取
    }).

%% 押注类型
-define(KF_1VN_BET_TYPE_WINLOSE, 0).    % 输赢
-define(KF_1VN_BET_TYPE_HP, 1).         % 擂主血量
-define(KF_1VN_BET_TYPE_LIVENUM, 2).    % 剩余挑战者数量

%% 竞猜配置
-record(base_kf_1vn_bet, {
        turn = 0            % 轮次
        , type = 0          % 押注类型
        , opt_list = []     % 押注选项列表##[{选项,最小值,最大值}|{选项,擂主胜负(1胜,2挑战者胜利)}]
        % , ratio = 0         % 赔率##暂时不用
        , cost_list = []    % 押注消耗列表##[{投入金额,胜利获得金额,猜错获得金额}]
    }).