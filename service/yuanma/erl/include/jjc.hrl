%% ---------------------------------------------------------
%% @doc jjc
%% @author fwx
%% @since  2017-11-20
%% @deprecated 竞技场
%% ----------------------------------------------------------
-define(JJC_FREE_NUM_MAX,    1).           %% 最大挑战次数
-define(JJC_INSPIRE_NUM_MAX, 2).           %% 最大鼓舞次数
-define(JJC_CONFIG_LV,       3).           %% 竞技场开放等级
-define(JJC_MAX_RANK,        4).           %% jjc最低排名
-define(JJC_ROBOT_LV,        5).           %% 假人等级
-define(JJC_ROBOT_CAREER,    6).           %% 假人职业
-define(JJC_ROBOT_CLOTH,     7).           %% 假人衣服Id
-define(JJC_ROBOT_WEAPON,    8).           %% 假人武器Id
-define(JJC_ROBOT_PET,       9).           %% 假人宠物Id
-define(JJC_MAX_RECORD,      10).          %% 战斗记录最大数量
-define(JJC_SCENE_ID,        11).          %% 竞技场景id
-define(JJC_BORN_POS,        12).          %% 竞技场景出生坐标列表
-define(JJC_START_TIME,      13).          %% 开始前倒计时间
-define(JJC_BATTLE_TIME,     14).          %% 战斗持续时间
-define(JJC_SELF_POS,        15).          %% 真人坐标
-define(JJC_REWARD_TIME,     16).          %% 结算界面持续时间
-define(JJC_COUNT_RESUME_TIME,  17).       %% 挑战次数恢复时间(单位秒)

-define(RANK_STAY,          0).            %% 排名没变化
-define(RANK_UP,            1).            %% 排名上升
-define(RANK_DOWN,          2).            %% 排名下降

-define(JJC_HAD_REWARD,     2).            %% 已领奖励
-define(JJC_HAVE_REWARD,    1).            %% 可领奖励
-define(JJC_HAVE_NOT_REWARD,0).            %% 不可领

-define(JJC_INSPIRE_NUM,    1).            %% 战力鼓舞次数    yyhx_3d 弃用
-define(JJC_USE_NUM,        2).            %% 已挑战次数     yyhx_3d 弃用
-define(JJC_BUY_NUM,        3).            %% 购买次数
-define(JJC_CHALLENGE_NUM,  4).            %% 挑战次数

-define(JJC_WIN,            1).            %% 胜利
-define(JJC_FAIL,           0).            %% 失败

-define(HUNDRED_PERCENT,  100).            %% 百分百

-define(BATTLE_STATUS,      1).             %% 战斗中
-define(NOT_BATTLE_STATUS,  0).             %% 不在战斗中

%% 假人属性
-define(JJC_ROBOT_VIP, 3).                  %% 假人默认vip

%% 购买次数配置
-record(jjc_buy_cfg, {
    num   = 0,           %% 购买次数
    type  = 0,           %% 货币类型
    price = 0            %% 价格
    }).

%% 名次突破奖励配置
-record(jjc_reward_break_cfg, {
    id = 0,              %% 编号##领取主键
    rank   = 0,          %% 排名
    reward = []          %% 奖励
    }).

%% 排名奖励配置
-record(jjc_reward_rank_cfg, {
    id     = 0,          %% 区域Id
    min    = 0,          %% 排名下限
    max    = 0,          %% 排名上限
    reward = [],         %% 奖励
    about  = ""          %% 描述
    }).

%% 对手搜索配置
-record(jjc_search_cfg, {
    id    = 0,           %% 区域id
    max   = 0,           %% 排名上限
    min   = 0,           %% 排名下限
    range = 0            %% 搜索范围参数
    }).

%% 战力鼓舞配置
-record(jjc_inspire_cfg, {
    num     = 0,         %% 鼓舞次数
    type    = 0,         %% 货币类型
    price   = 0,         %% 价格
    percent = 0          %% 增加百分比
    }).

%% 战力鼓舞配置
-record(base_jjc_challenge_reward, {
        lv = 0              %% 等级
        , win_reward = []   %% 胜利奖励##[{Type, GoodsTypeId, Num}]
        , lose_reward = []  %% 失败奖励##[{Type, GoodsTypeId, Num}]
    }).

%% 假人配置
-record(base_jjc_robot, {
        lrank = 0                   %% 排名下限
        , hrank = 0                 %% 排名上限
        , power_range = [0, 0]      %% 战力范围
        , lv_range = [0, 0]         %% 等级范围
        , rmount = []               %% 坐骑资源
        , rmate = []                %% 伙伴资源
        , rpet = []                 %% 宠物资源
        , rfly = []                 %% 翅膀资源
        , rholyorgan = []           %% 圣器资源
    }).

-record(jjc_state, {
    real_maps = maps:new(),   %% 玩家 role_id => #real_role{}
    rank_maps = maps:new(),    %% 排名 rank => role_id
    battle_status_maps = maps:new() %% 是否战斗状态中 rank => Status
    }).

-record(real_role, {
    role_id      = 0,         %% 角色id
    rank         = 0,         %% 排名
    history_rank = 0,         %% 历史最高排名
    record       = [],        %% 战斗记录 [#challenge_record{}..]
    is_reward    = 0,         %% 奖励领取状态
    reward_rank  = 0          %% 奖励根据的排名
    }).

-record(rank_role, {
    rank         = 0,         %% 排名
    role_id      = 0          %% 玩家ID
    }).

%% 随机列表对手信息
-record(image_role, {
    rank         = 0,        %% 排名
    role_info    = undefined %% 对手信息 #faker_info{}(faker.hrl)
    % role_id      = 0,        %% 玩家ID
    % figure       = undefined,%% #figure{}
    % hp           = 0,        %% 血量(客户端显示)
    % combat       = 0         %% 战力
    }).

%% 挑战用record
% -record(challenge_role, {
%     role_id      = 0,       %% 角色id
%     role_lv      = 0,       %% 角色等级
%     self_figure  = undefined,%% 自己形象
%     self_combat  = 0,       %% 自己的战力
%     self_rank    = 0,       %% 自己的排名
%     history_rank = 0,       %% 历史最高排名
%     rival_id     = 0,       %% 对手id
%     rival_figure = undefined,%% 对手形象
%     rival_rank   = 0,       %% 对手排名
%     rival_combat = 0        %% 对手战力
%     }).

%% 挑战用record
-record(challenge_role, {
    self_image  = undefined, % 自己的信息 #image_role{}
    rival_image = undefined,     % 对手的信息 #image_role{}
    challenge_times = 1          % 挑战次数
}).

 %% 被挑战记录
 -record(challenge_record, {
    role_id      = 0,       %% 角色id
    time         = 0,       %% 时间戳
    rival_id     = 0,       %% 对方玩家id#id=0是假人，则记录一些假人数据
    rival_name   = "",      %% 假人的名字
    rival_career = 0,       %% 假人的职业
    rival_sex    = 0,       %% 假人的性别
    rival_turn   = 0,       %% 假人的转数
    rival_vip_type = 0,     %% 假人的vip类型
    rival_vip_lv = 0,       %% 假人的vip等级
    rival_lv     = 0,       %% 假人的等级
    rival_combat = 0,       %% 假人的战力
    result       = 0,       %% 胜负结果 1：胜 0 ：负
    rank_change  = 0        %% 排名变化
    }).

%% 竞技场结构
-record(status_jjc, {
        break_id_list = []
    }).

-define(sql_select_db_real_role,
    <<"select role_id, rank, history_rank, is_reward, reward_rank
    from jjc_real_role">>).

-define (sql_select_real_role_by_id,
    <<"select rank, history_rank, is_reward, reward_rank
    from jjc_real_role where role_id = ~p">>).

-define(sql_select_db_honour,
    <<"select role_id, honour
    from jjc_honour where role_id = ~p">>).

-define(sql_select_db_challenge_record,
     <<"select time, rival_id, rival_name, rival_career, rival_sex, rival_turn, rival_vip_type, rival_vip_lv, rival_lv, rival_combat, result, rank_change
     from jjc_record where role_id = ~p">>).

-define(sql_insert_db_real_role,
    <<"insert into jjc_real_role (role_id, rank, history_rank, is_reward, reward_rank)
    values (~p, ~p, ~p, ~p, ~p)">>).

-define(sql_replace_db_real_role,
    <<"replace into jjc_real_role (role_id, rank, history_rank, is_reward, reward_rank)
    values (~p, ~p, ~p, ~p, ~p)">>).

-define(sql_update_db_reward_state,
    <<"update jjc_real_role set is_reward = ~p, reward_rank = ~p
    where role_id = ~p">>).

-define(sql_update_db_real_role_rank,
    <<"update jjc_real_role set rank = ~p
    where role_id = ~p">>).

-define(sql_replace_db_jjc_honour,
    <<"replace into jjc_honour (role_id, honour)
    values (~p, ~p)">>).


-define(sql_replace_db_challenge_record,
    <<"replace into jjc_record (role_id, time, rival_id, rival_name, rival_career, rival_sex, rival_turn, rival_vip_type, rival_vip_lv, rival_lv, rival_combat, result, rank_change)
    values (~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).

-define(sql_delete_db_challenge_record, <<"delete from jjc_record
                    where role_id = ~p and time = ~p ">>).

%% 玩家竞技场信息
-define(sql_role_jjc_select, <<"SELECT break_id_list FROM role_jjc WHERE role_id = ~p">>).
-define(sql_role_jjc_replace, <<"REPLACE INTO role_jjc (role_id, break_id_list) VALUES (~p, '~s')">>).