%%% ----------------------------------------------------
%%% @Module:        3v3
%%% @Author:        zhl
%%% @Description:   跨服3v3头文件
%%% @Created:       2017/07/04
%%% ----------------------------------------------------

%% =========================  跨服中心数据  ===============================


-define(ETS_RANK_DATA,                 kf_3v3_team_rank_data).  %% 排行数据
-define(ETS_TEAM_DATA,                 kf_team_data).  %% 队伍数据
-define(ETS_ROLE_DATA,                 kf_role_data).  %% 玩家数据
-define(ETS_PK_DATA,                   kf_pk_data).    %% 战斗数据

-define(PK_3V3_SCENE_ID,                42001).      %% 3v3战斗场景id
-define(PK_3V3_SCENE,                   [?PK_3V3_SCENE_ID]).    %% 跨服3v3战斗场景列表
-define(PK_3V3_SCENE_POOL_ID_LIST,      [1,2,3,4,5]).   %% 进程池Id列表

-define(PK_3V3_ONLINE,    1).
-define(PK_3V3_OFFLINE,   2).
-define(PK_3V3_MAX_SCORE, 2000).

-define(KF_3V3_LV_LIMIT,               300).            %% 开放等级限制
-define(KF_3V3_ROOM_LIMIT,             45).             %% 房间数量限制 - 一个场景限制人数270以内
-define(KF_3V3_MATCH_TIME,             30).             %% 最大匹配时间
-define(KF_3V3_PK_TIME,                180).            %% 战斗时间3min
-define(KF_3V3_RANK_LIMIT,             100).            %% 排行榜上限
-define(KF_3V3_MEMBER_LIMIT,           3).              %% 队伍人员限制##只是初始化的默认值,修改人数需要同步mod_3v3_center和mod_3v3_local进程中的member_limit字段
-define(KF_3V3_REVIVE_TIME,            0).              %% 3v3复活时间

-define(KF_3V3_STATE_YET,              1).              %% 活动状态 - 还未开始
-define(KF_3V3_STATE_START,            2).              %% 活动状态 - 开始
-define(KF_3V3_STATE_END,              3).              %% 活动状态 - 结束
-define(KF_3V3_PK_READY,               1).              %% 战斗状态 - 准备中
-define(KF_3V3_PK_START,               2).              %% 战斗状态 - 开始
-define(KF_3V3_PK_END,                 3).              %% 战斗状态 - 结束
-define(KF_3V3_IS_AUTO,                1).              %% 满员自动开始
-define(KF_3V3_UNREADY,                0).              %% 还未准备好
-define(KF_3V3_IS_READY,               1).              %% 已准备好了
-define(KF_3V3_START_ROLE,             1).              %% 开始匹配 - 组队
-define(KF_3V3_STOP_ROLE,              2).              %% 取消匹配 - 组队

-define(KF_3V3_GROUP_BLUE, 1).         %% 蓝色
-define(KF_3V3_GROUP_RED,  2).         %% 红色

-define(KF_3V3_RESULT_DRAW,     0).         %% 打平
-define(KF_3V3_RESULT_BLUE,     1).         %% 蓝方胜利
-define(KF_3V3_RESULT_RED,      2).         %% 红方胜利

-define(SERVER_OPEN_DAY, 3).                %% 开服条件

-define(kf_3v3_match_time, 5000).                 %% 5000
-define(kf_3v3_match_times_limit, 5).             %% 匹配次数上限
-define(kf_3v3_pk_add_point_time, 5000).          %% 增加积分时长
-define(kf_3v3_add_score,         5).             %% 增加pk积分

-define(kf_3v3_enter_tower,         1).             %% 进塔
-define(kf_3v3_quit_tower,          0).             %% 出塔

-define(kf_3v3_role_speed,          10).             %% 每一个玩家增加的占领进度

-define(kf_3v3_count_win_id, 1).                     %% 胜利计数器子id
-define(kf_3v3_count_match_id, 2).                   %% 匹配计数器子id

-define(kf_3v3_continuous_kill, 3).                  %%连杀超过3次才推送

-define(KF_3V3_PK_TIME2,                200).        %%200左右


-define(single_result, 0).  %% 单人排位赛结果
-define(common_result, 1).  %% 战队排位赛结果
-define(champion_result, 2).  %%冠军赛结果
-define(ob_result, 3).  %%观战结果


-define(team_num,                3).        %%战队人数
-define(accept,                  1).        %%接受进入战队
-define(refuse,                  0).        %%拒绝进入战队

-define(team_rank_length,                20).        %%排名长度
-define(vote_default, 2). %% 没有投票
-define(vote_accept, 1 ). %% 同意
-define(vote_not_accept,  0). %%反对
-define(vote_time,        15). %%15秒的的投票时间

-define(team_pk, 2).  %%pk中
-define(team_matching, 1).  %% 匹配中
-define(team_not_matching, 0).  %%普通状态

-define(team_win, 1).   %%胜利
-define(team_fail, 0).   %%失败
-define(team_draw, 2).   %%平局



%%---------------------------冠军赛 ----------------------------------
-define(champion_pk_scene, 42002).  %% 冠军赛等待场景
-define(champion_pk_x, 1597).  %% x坐标
-define(champion_pk_y, 1372).  %% y坐标
-define(champion_pre_time,  60 * 5).  %%冠军赛 前置时间入场时间
-define(champion_guess_time,  60).  %%冠军赛 竞猜时间

-define(champion_pk_time,    186).  %%冠军赛 pk时间 180 + 3 + 3


-define(champion_close, 0).  %%冠军赛
-define(champion_open,  1).  %%开启状态
-define(champion_pk,    2).  %%pk状态
-define(champion_guess,    3).  %% 竞猜状态
-define(champion_last_turn,  4).  %% 最后轮次



-define(team_3v3_create, 1).                % 创建战队
-define(team_3v3_join, 2).                  % 加入战队
-define(team_3v3_knick_out, 3).              % 踢出战队
-define(team_3v3_change_leader, 4).            % 职位变动
-define(team_3v3_disband, 5).               % 解散战队
-define(team_3v3_quit, 6).                  % 主动退出战队
-define(team_3v3_auto_leader, 7).            % 自动任命会长
-define(team_3v3_change_name, 8).            % 改名
% -define(GLOG_DONATE, 7).                % 捐献

-define(lose_k,   0.2).  %%失败的k值系数
-define(is_single, 1).   %%单人模式
-define(not_single, 0).   %%战队模式


-define(single_max_match_count, 60).


%% 跨服3v3排行数据
-record(kf_3v3_rank_data, {
        server_name = "",                               %% 平台
        server_num = 0,                              %% 服号
        server_id = 0,                               %% 角色所在的服务器id
        role_id = 0,                                 %% 玩家ID
        nickname = "",                               %% 玩家昵称
        career = 0,                                  %% 职业
        sex = 0,                                     %% 性别
        lv = 0,                                      %% 等级
        vip_lv = 0,                                  %% VIP等级
        power = 0,                                   %% 战力
        tier = 0,                                    %% 段位
        star = 0,                                    %% 星数
        time = 0,                                    %% 上榜时间
        score = 0                                    %% 每周所得积分 - 每周日都需要重置
    }).


%% 跨服3v3team数据
-record(kf_3v3_team_rank_data, {
        server_name = "",                            %% 平台
        server_num = 0,                              %% 服号
        server_id = 0,                               %% 角色所在的服务器id
        team_id = 0,                                 %% 战队id
        leader_id = 0,                              %% z队长id
        leader_name = "",                            %% 队长名字
        team_name = "",                              %% 战队名称
        power = 0,                                   %% 战力
        tier = 0,                                    %% 段位
        star = 0,                                    %% 星数
        time = 0                                    %% 上榜时间
}).

%% 跨服3v3战斗数据
-record(kf_3v3_pk_data, {
        pk_pid = 0,                                  %% 战斗进程PID
        scene_id = 0,                                %% 场景ID
        scene_pool_id = 0,                           %% 场景PoolId
        room_id = 0,                                 %% 房间号
        state = 0,                                   %% PK状态

        %% ===================== 成员退出战斗不清除战斗数据中的队友数据 =================
        team_data_a = [],                            %% A 队伍数据 - #kf_3v3_team_data{}
        team_data_b = []                             %% B 队伍数据 - #kf_3v3_team_data{}
        ,type = 0                                    %% 0 普通排位赛， 1， 冠军赛
    }).

%% 跨服3v3队伍数据
-record(kf_3v3_team_data, {
        team_id = 0,                                 %% 队伍ID
        team_name = "",                              %% 队伍名字
        captain_name = "",                           %% 队长名
        server_name = "",                               %% 平台
        server_num = 0,                              %% 服号
        server_id = 0,                               %% 服id
        captain_id = 0,                              %% 队长ID
        captain_sid = 0,                             %% 队长的sendid
        password = 0,                                %% 密码
        lv_limit = 0,                                %% 等级要求
        power_limit = 0,                             %% 战力要求
        is_auto = 0,                                 %% 是否自动开始
        member_num = 0,                              %% 队伍人数
        map_power = 0,                               %% 映射战力 = round(玩家总战力 / 队伍已有人数)
        match_count = 0,                             %% 匹配次数  %%  战队之间匹配的次数
        match_count_in_team = 0,                     %% 匹配个人的次数
        is_pk = 0,                                   %% 是否在pk
        is_match = 0,                                %% 是否在匹配  0：否 1：是
        power = 0,
        match_count2 = 0 ,                           %% 匹配次数 赛季的匹配次数
        win_count = 0,                               %% 胜利次数 赛季的胜利次数
        member_data = []                             %% 成员数据 [#kf_3v3_role_data{}]
        ,tier        = 0                             %% 段位
        ,point       = 0                             %% 积分
        ,team_type = 0                               %% 0 是战队  1， 是个人散队
    }).

%% 跨服3v3玩家数据
-record(kf_3v3_role_data, {
        node = 0,                                    %% 节点
        server_name = "",                               %% 平台
        server_num = 0,                              %% 服号
        server_id = 0,                               %% 角色所在的服务器id
        role_id = 0,                                 %% 玩家ID
        sid = 0,                                     %% 玩家消息进程
        figure = undefined,                          %% #figure{}
        % nickname = "",                               %% 玩家昵称
        % sex = 0,                                     %% 性别
        % lv = 0,                                      %% 等级
        % vip = 0,                                     %% VIP等级
        power = 0,                                   %% 战力
        % fashion_id = 0,                              %% 时装ID
        % train_weapon = 0,                            %% 神武 - ?TWEAPON
        % train_fly = 0,                               %% 神翼 - ?TFLY
        is_ready = ?KF_3V3_IS_READY,                 %% 是否默认准备好了
        pk_time = 0,                                 %% 上一次PK时间

        tier = 0,                                    %% 段位  %%个人不在有段位和星数
        star = 0,                                    %% 星数
        continued_win = 0,                           %% 连续胜利场次
        old_scene_info=undefined,                    %% 进入时的坐标 {OldScene, OldScenePooldId, OldCopyId, OldX, OldY}
%%        is_fake = 0                                  %% 是否假人 0:不是 1:是
%%        ,fake_battle_attr = [],                       %% 假人战斗属性
        %% =============== 每次进入新的队伍都要重置 =================
        match_count = 0,                             %% 匹配队伍次数  废弃
        team_id = 0,                                 %% 队伍ID
        group = 0,                                   %% 组别
        pk_pid = 0                                   %% 3v3 pk进程
        ,is_single = ?not_single                     %% 是否单人模式  默认战队模式
    }).

%% =========================  本服数据  ===============================

%% 关注列表
-record(attention_list, {
        role_id = 0,                                 %% 玩家ID
        sid = 0                                      %% 消息进程
    }).

%% 玩家3v3数据
-record(role_3v3, {
        tier = 1,                                    %% 段位
        star = 0,                                    %% 星数
        old_tier = 1,                                %% 段位
        old_star = 0,                                %% 星数
        continued_win = 0,                           %%
        daily_win = 0,                               %% 每日胜利连续胜利场次场次
        daily_pk = 0,                                %% 每日战斗场次
        daily_honor = 0,                             %% 声望值赛季后清除，废弃，存在玩家的特殊货币了
        pack_time = 0,                               %% 今日领取荣誉时间
        pack_reward = [{0, 0}, {1, 0}, {2, 0}, {3, 0}],      %% 今日领取的活跃奖励 [{id, 状态}]
        pk_time = 0,                                 %% 上一次PK时间
        daily_time = 0                               %% 上次日常刷新时间
        ,fame_reward = []                            %% 声望奖励列表  [{声望奖励di, 状态}]  0 未领取 2:已领取
        ,yesterday_tier = 1                          %% 昨日段位
    }).

%% 玩家基本数据
-record(role_data, {
        node = 0,                                    %% 节点
        server_name = "",                               %% 平台
        server_num = 0,                              %% 服号
        server_id = 0,                               %% 角色所在的服务器id
        role_id = 0,                                 %% 玩家ID
        sid = 0,                                     %% 玩家消息进程
        figure = undefined,                          %% #figure{}
        % nickname = "",                               %% 玩家昵称
        % sex = 0,                                     %% 性别
        % lv = 0,                                      %% 等级
        % vip = 0,                                     %% VIP等级
        power = 0,                                   %% 战力
        % fashion_id = 0,                              %% 时装ID
        % train_weapon = 0,                            %% 神武 - ?TWEAPON
        % train_fly = 0,                               %% 神翼 - ?TFLY

        tier = 0,                                    %% 段位
        star = 0,                                    %% 星数
        continued_win = 0,                           %% 连续胜利场次
        old_scene_info=undefined,                    %% 进入时的坐标 {OldScene, OldScenePooldId, OldCopyId, OldX, OldY}

        %% ================= 以下字段用于创建队伍所用 ===================
        password = 0,                                %% 密码
        lv_limit = 0,                                %% 等级要求
        power_limit = 0,                             %% 战力要求
        is_auto = 0,                                 %% 是否自动开始

        %% ================= 以下字段用于匹配组队所用 ===================
        match_count = 0                              %% 匹配队伍次数
        ,is_single = 0                               %% 0 不是个人匹配， 1 个人匹配
    }).

%% 活动时间配置
-record(act_info, {
        id = 0,                                      %% 活动ID
        week = [],                                   %% 开启周
        time = []                                    %% 开启时间
    }).

%% 段位配置
-record(tier_info, {
        tier = 0,                                    %% 段位
        stage = 0,                                   %% 客户端用的段位
        tier_name = "",                              %% 段位名称
        star = 0,                                    %% 升级星数
        daily_reward = 0,                            %% 每日段位奖励
        win_star = 0,                                %% 单场胜利星数
        lose_star = 0,                               %% 单场失败星数
        win_reward = 0,                              %% 单场胜利奖励
        lose_reward = 0                              %% 单场失败奖励
        ,win_fame = 0                                %% 胜利声望值
        ,lose_fame = 0                               %% 失败获得声望值
        ,season_reward = []                          %% 赛季结算段位奖励
        ,today_reward = []                           %% 今日段位奖励
        ,k_value = 0                                 %% k值参数
    }).


%% 个人积分
-record(role_score, {
        team_id = 0,
        group = 0,
        server_name = "",                          %% 平台
        server_num = 0,                         %% 服号
        server_id = 0,                          %% 服务器独立唯一标识
        role_id = 0,                            %% 玩家ID
        figure = undefined,                     %% #figure{}
        % nickname = "",                          %% 玩家昵称
        % sex = 0,                                %% 性别
        % lv = 0,                                 %% 等级
        % vip = 0,                                %% VIP等级
        power = 0,                              %% 战力
        % fashion_id = 0,                         %% 时装ID
        % train_weapon = 0,                       %% 神武 - ?TWEAPON
        % train_fly = 0,                          %% 神翼 - ?TFLY
        sid = 0,                                %% 消息进程
        tier = 0,                               %% 段位
        star = 0,                               %% 星数
        continued_win = 0,                      %% 连胜场次
        honor = 0,                              %% 奖励声望值
        reward = [],                            %% 奖励
        collect = 0,                            %% 采集神塔次数
        kill = 0,                               %% 击杀次数
        continuous_kill_count = 0,             %% 连杀次数
        killed = 0,                             %% 被击杀次数
        assist = 0,                             %% 助攻次数
        old_scene_info = undefined,             %% 进来前的场景信息 {OldScene, OldScenePooldId, OldCopyId, OldX, OldY}
        is_fake = 0,                            %% 是否假人
        online = 0                              %% 是否在线标志
        ,is_single = 0                          %% 0 非单人 1 单人匹配下
}).

%% 队伍积分
-record(team_score, {
        team_id = 0,
        team_name = "",
        group = 0,
        map_power =0,
        server_id = 0
        ,server_name = ""
        , server_num = 0
        , leader_id = 0
        , leader_name = "",
        score = 0,                              %% 队伍总积分
        occupy_time = 0,                        %% 占据神塔时间
        kill = 0,                               %% 总击杀次数
        killed = 0,                             %% 总被击杀次数
        assist = 0                              %% 总助攻次数
		,tier = 0                               %% 段位
		,star = 0                               %% 星数
		,continue_win = 0                       %% 连赢
		,fame = 0                               %% 荣誉
        ,result = ?team_draw                    %% 战斗结果
        ,team_type = 0                          %% 0 是战队  1， 是个人散队
}).

%% 神塔数据
-record(tower_data, {
        mon_id = 0,                             %% 神塔ID
        progress_rate = 0,                      %% 进度
        progress_rate_speed = 0,                %% 每秒速度
        time = 0,                               %% 开始占领时间
        end_time = 0,                           %% 结束占领时间
        blue_role_list = [],                    %% 红色方玩家列表
        red_role_list  = [],                    %% 蓝色方玩家列表
        group = 0                               %% 占据组别
        ,rate_ref = []                          %% 定时器
}).




-record(team_local_3v3, {
        team_id = 0,
        server_id = 0,
        name = "",
        leader_id = 0,
        leader_name = "",
        match_count = 0,
        win_count = 0,
        point = 0,
        rank = 0,
        matching_status = ?team_not_matching,
        apply_list = [],  %%申请人列表  [#team_local_3v3_role{}]
        role_list = [],
        vote_list = []  %% 发起投票的人  {role, }
        ,vote_end_time = 0 %% 投票结束时间戳
        ,vote_ref = []     %% 投票定时器
        ,today_count = 0   %% 今天匹配次数
        ,yesterday_point = 0 %% 昨日积分
        ,champion_rank   = 0 %% 冠军赛排名
        ,is_change_name = 0   %% 0 未改名 1 改名了
}).


-record(vote_role, {
        server_id = 0,
        role_id = 0,
        role_name = "",
        vote_type = ?vote_default   %%
}).


-record(team_local_3v3_role, {
        role_id = 0,
        server_id = 0,
        server_num = 0,
        server_name = 0,
        matching_status = ?team_not_matching,
        turn = 0,
        power = 0,
        login_time = 0,
        logout_time = 0
        ,lv = 0
        ,picture
        ,picture_id
        ,role_name = ""
        %% -  不保存数据库
        ,career = 0
        ,on_line = 0  %% 默认不在线
}).


%%玩家进程中的数据
-record(role_3v3_new, {
        team_id = 0,   %%战队id
        team_name = "", %%
        leader_id = 0
        ,is_in_champion_pk = 0   %%0 否 1 是
        ,guess_record = []       %%竞猜记录  [#role_guess_record{}]
}).


-record(team_state, {
        team_list = [],           %% [#team_local_3v3{}]
        team_role_id_list = []  %%维护有战队的玩家id
        ,kf_3v3_status = ?KF_3V3_STATE_END
        ,kf_3v3_end_time = 0
        ,end_ref = []    %% 结束定时器
}).


-record(champion_state, {
        ref = []               %% 冠军赛开始定时器
        ,start_time = 0         %% 冠军赛开始时间
        ,get_data_ref = []     %% 获取数据定时器
        ,team_list = []        %% 队伍列表
        ,status = ?champion_close %% 开启状态
        ,stage_ref = []        %% 阶段定时器
%%        ,in_scene_role = []    %% 场景内玩家id
        ,stage_end_time = 0    %% 阶段结算时间
        ,turn = 0              %% 第几轮  全部从1开始 开始竞猜 就
        ,guess_list = []       %% 竞猜列表   %%每一轮都要清空
        ,guess_role_id_list    %% 玩家竞猜列表，每一轮，都会维护一个玩家id 列表，用于标识玩家是否在这一轮参加过竞猜
}).


-record(champion_team, {
        team_id = 0           %% 队伍id
        ,team_name = ""
        ,server_id = 0        %% 服id
        ,server_num = 0
        ,server_name = ""
        ,star        = 0
        ,rank        = 0      %% 最开始的时候的排名
        ,leader_id   = 0
        ,leader_name = ""
        ,win_count = 0        %%胜利次数冠军赛
        ,match_win_count = 0  %%排位赛胜利次数
        ,match_count = 0      %%排位场次
        ,role_list = []       %%队员列表
        ,pk_pid = []          %%pk的pid
        ,group = 0            %%组别
        ,wheel_space = 0      %% 0 轮空  1 不是轮空
}).


-record(champion_team_role, {
        role_id = 0           %% 玩家id
        ,role_name = ""       %% 玩家名字
        ,team_id = 0           %% 队伍id
        ,server_id = 0        %% 服id
        ,server_num = 0
        ,server_name = ""
        , career = 0            %% 职业
        , sex = 0               %% 性别
        , turn = 0
        , power = 0
        , lv_figure = []        %%等级模型 [{key, value}]
        , fashion_model = []    %%时装  [{key, model_id, color_id}]
        , mount_figure = []     %% 坐骑 [{key, value}]
        , picture = ""          %% 头像地址
        , picture_id = 0        %% 头像id
        , is_in_champion_scene = 0  %%0 不在，1 在
        , pk_pid = []
        , group = 0
        , lv
}).


%%竞猜配置
-record(base_guess_config, {
        turn = 0           %% 轮次id
        ,type = 0       %% 题目类型
        ,opt_list = []           %% 选项
        ,cost_list = []        %% 押注上下限
        ,reward_list = []      %% 奖励列表
}).


%%竞猜配置
-record(role_guess_record, {
        key =  {},         %% key值 {turn, team_a_id, team_b_id, time最开始时间}
        turn = 0           %% 轮次id
        ,pk_res = []       %% 比赛结果 [{类型, 结果}]  1 胜利方 2 塔数 3 积分
        ,opt = 0           %% 选项
        ,res = 0           %% 竞猜结果   0 未出结果 1 对 2 错',
        ,team_a = ""        %% 队伍a的名字
        ,team_b = ""        %% 队伍b的名字
        ,reward = []        %% 奖励
        ,cost = []          %% 押注消耗
        ,status = 0         %% 领取状态   '0 未出结果 1 可以领取 2 已经领取',
        ,team_a_id = 0
        ,team_b_id = 0
        ,time = 0           %% 时间
}).

%%竞猜配置
-record(kf_guess_msg, {
         key = {0, 0, 0}   %% {turn, team_a_id, team_b_id}
        ,turn = 0          %% 轮次
        ,team_a_id = 0     %%
        ,team_a_name = ""  %% 队伍名字
        ,team_b_id = 0     %%
        ,team_b_name = ""  %%
        ,role_list = []    %% [{server_id, role_id}]
        ,pk_res = []       %%
        ,is_settle = 0     %% 是否已经结算  ， 如果到了再次竞猜的时候，还没有结算，则这个竞猜流盘 1 已经结算（暂时没用）
}).



-define(SQL_SELECT_3V3_RANK, "select server_name, server_num, server_id, role_id, nickname, career,
    sex, lv, vip_lv, power, tier, star, score, time from kf_3v3_rank order by (rank_id) asc").




%%%战队排名
-define(SQL_SELECT_3V3_RANK_TEAM,
        "select  `team_id`, `team_name`, `server_name`, `server_id`, `server_num`, `leader_id`, `leader_name`, `power`,  `tier`, `star`, `time` from  kf_team_3v3_rank").
-define(SQL_REPLACE_3V3_RANK_ONE, "replace into kf_team_3v3_rank(`team_id`, `team_name`, `server_name`,
`server_id`, `server_num`, `leader_id`, `leader_name`, `power`,  `tier`, `star`, `time`) values ~ts").

-define(SQL_REPLACE_3V3_RANK_VALUES, "(~w, '~s', '~s', ~w, ~w, ~w, '~s', ~w, ~w, ~w, ~w)").

-define(SQL_DELETE_3V3_RANK_ONE, "delete from kf_team_3v3_rank where team_id = ~p").
-define(SQL_DELETE_3V3_RANK_VALUES, "(role_id = ~w)").





-define(SQL_SELECT_3V3_ROLE, "select old_tier, old_star, tier, star, continued_win, daily_win, 
    daily_pk, daily_honor, pack_reward, pack_time, daily_time, fame_reward, yesterday_tier from role_3v3 where role_id = ~w").
-define(SQL_REPLACE_3V3_ROLE, "replace into role_3v3 (role_id, old_tier, old_star, tier, star, 
    continued_win, daily_win, daily_pk, daily_honor, pack_reward, pack_time, daily_time, fame_reward, yesterday_tier) values (~w, ~w, ~w, ~w, ~w,
    ~w, ~w, ~w, ~w, '~ts', ~w, ~w, '~ts', ~p)").

%%% 战队相关的

-define(select_3v3_team, "select  team_id, `name`,  leader_id, match_count, win_count, point, today_count, yesterday_point, champion_rank, have_change_name, server_id, leader_name from  team_3v3").
-define(select_3v3_team_role, "select  role_id, server_num, server_name, turn, login_time, logout_time, power, server_id, lv, picture_id, picture, role_name  from  team_3v3_role where team_id = ~p").
-define(save_team,
        "replace into  team_3v3(team_id, `name`, leader_id, match_count, win_count, point, today_count, yesterday_point, champion_rank, have_change_name, server_id, leader_name) values(~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s')").
-define(save_team_role,
        "replace into  team_3v3_role(team_id, role_id, server_num, server_name, turn, login_time, logout_time, power, server_id, lv, picture_id, picture, role_name)
        values(~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s')").

-define(delete_team_role,
        "delete  from   team_3v3_role where   team_id = ~p   and  role_id = ~p").
-define(delete_team,
        "delete  from   team_3v3 where   team_id = ~p").

-define(save_team_role_ps,
	"replace into  team_3v3_role_in_ps(role_id, leader_id, team_id, team_name) values(~p, ~p, ~p, '~s')").


-define(select_from_guess_record,
        "select  `pk_res`, `turn`, `opt`, `res`, `team_a`, `team_b`, `reward`, `cost`, `status`, `time`, team_a_id, team_b_id from champion_3v3_guess_record where role_id = ~p").
-define(save_guess_record,
        "replace into  champion_3v3_guess_record(role_id, `pk_res`, `turn`, `opt`, `res`, `team_a`, `team_b`, `reward`, `cost`, `status`, `time`, team_a_id, team_b_id)
         values(~p, '~s', ~p, ~p, ~p, '~s', '~s', '~s', '~s', ~p, ~p, ~p, ~p)").



