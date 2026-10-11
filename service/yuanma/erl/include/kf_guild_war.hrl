%%-----------------------------------------------------------------------------
%% @Module  :       kf_guild_war
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------

%% 配置宏定义
-define(CFG_ID_NEED_OPDAY,                      1).         %% 开服多少天开启活动
-define(CFG_ID_ACT_OPEN_WEEK,                   2).         %% 每周几开活动
-define(CFG_ID_APPOINT_TIME,                    3).         %% 宣战期时间[开始时间,结束时间]{时,分,秒}
-define(CFG_ID_CONFIRM_TIME,                    4).         %% 确认期时间[开始时间,结束时间]{时,分,秒}，确认期时间的开始时间必须是宣战期时间的结束时间
-define(CFG_ID_FIR_ROUND_TIME,                  5).         %% 第一轮时间[开始时间,结束时间]{时,分,秒}，第一轮的开始时间必须是确认期时间的结束时间
-define(CFG_ID_SEC_ROUND_TIME,                  6).         %% 第二轮时间[开始时间,结束时间]{时,分,秒}
-define(CFG_ID_SCENE_ID,                        7).         %% 活动场景id
-define(CFG_ID_OPEN_LV,                         8).         %% 活动开启等级
-define(CFG_ID_GUILD_PARTICIPANTS_NUM_LIM,      9).         %% 每个公会最大参与人数
-define(CFG_ID_BUILDING_SCORE_PLUS_CD,          10).        %% 已占领的据点每隔多久（s）加一次个人积分
-define(CFG_ID_SCORE_AUTO_PLUS,                 11).        %% 已占领的据点每次增加多少个人积分
-define(CFG_ID_KILL_MON_ADD_SCORE,              12).        %% 击杀怪物增加的个人积分
-define(CFG_ID_KILL_PLAYER_ADD_SCORE,           13).        %% 击杀敌对玩家增加的个人积分
-define(CFG_ID_ASSISTS_ADD_SCORE,               14).        %% 助攻增加的个人积分
-define(CFG_ID_FIR_OCCUPY_BUILDING_ADD_SCORE,   15).        %% 首次占领建筑增加的额外积分
-define(CFG_ID_NORMAL_DONATE_TIMES_LIM,         16).        %% 道具捐献次数上限
-define(CFG_ID_GOLD_DONATE_TIMES_LIM,           17).        %% 钻石捐献次数上限
-define(CFG_ID_NORMAL_DONATE_COST,              18).        %% 道具捐献消耗
-define(CFG_ID_GOLD_DONATE_COST,                19).        %% 钻石捐赠消耗
-define(CFG_ID_NORMAL_DONATE_ADD_RESOURCE,      20).        %% 道具捐献增加的资源
-define(CFG_ID_GOLD_DONATE_ADD_RESOURCE,        21).        %% 钻石捐献增加的资源
-define(CFG_ID_DONATE_REWARD,                   22).        %% 捐赠奖励
-define(CFG_ID_BID_LIST_LEN,                    23).        %% 出价列表长度
-define(CFG_ID_DEFENDER_BORN_POINTS,            24).        %% 守方出生坐标点
-define(CFG_ID_ATTACKER_BORN_POINTS,            25).        %% 攻方出生坐标点
-define(CFG_ID_BUILDING_AUTO_RESTORE_CD,        26).        %% 船坞多少(s)没有受到攻击自动回满血
-define(CFG_ID_PROPS_ID_1_MON_ID,               27).        %% 道具1召唤的怪物
-define(CFG_ID_PROPS_ID_1_MON_TEXTURE,          28).        %% 道具1召唤的怪物贴图
-define(CFG_ID_PROPS_ID_2_MON_ID,               29).        %% 道具2召唤的怪物
-define(CFG_ID_PROPS_ID_2_MON_TEXTURE,          30).        %% 道具2召唤的怪物贴图
-define(CFG_ID_PROPS_ID_3_SKILL_ID,             31).        %% 道具3所加buff对应的技能Id

-define(MSG_TYPE_ACT_STATUS,                    1).
-define(MSG_TYPE_UPDATE_ROLE_INFO,              2).
-define(MSG_TYPE_SYNC_GUILD_INFO,               3).
-define(MSG_TYPE_SYNC_SER_INFO_IN_INIT,         4).
-define(MSG_TYPE_EXCHANGE_SHIP_SUCCESS,         5).
-define(MSG_TYPE_BID_RESULT,                    6).
-define(MSG_TYPE_LOCAL_INIT,                    7).
-define(MSG_TYPE_RESET_SEASON,                  8).

-define(ACT_STATUS_CLOSE,                       0).         %% 休战期
-define(ACT_STATUS_APPOINT,                     1).         %% 宣战期
-define(ACT_STATUS_CONFIRM,                     2).         %% 确认期
-define(ACT_STATUS_BATTLE,                      3).         %% 战斗期
-define(ACT_STATUS_REST,                        4).         %% 空窗期

-define(SEAS_TYPE_EDGE_SEA,                     1).         %% 贫瘠海域
-define(SEAS_TYPE_OPEN_SEA,                     2).         %% 外海域
-define(SEAS_TYPE_INSEA,                        3).         %% 内海域
-define(SEAS_TYPE_CENTER_SEA,                   4).         %% 中央海域

-define(SEAS_SUBTYPE_EAST_SEA,                  1).         %% 东海
-define(SEAS_SUBTYPE_WEST_SEA,                  2).         %% 西海
-define(SEAS_SUBTYPE_NORTH_SEA,                 3).         %% 北海

-define(GAME_TYPE_OPEN_SEA,                     1).         %% 外海
-define(GAME_TYPE_INSEA,                        2).         %% 内海

-define(DONATE_TYPE_PROPS,                      1).         %% 使用道具捐献
-define(DONATE_TYPE_GOLD,                       2).         %% 使用钻石捐献

-define(EXCHANEG_TYPE_RESOURCE,                 1).         %% 资源兑换
-define(EXCHANGE_TYPE_GOLD,                     2).         %% 钻石兑换

-define(DONATE_TYPE_LIST,                       [?DONATE_TYPE_PROPS]).

-define(DAILY_REWARD_COUNTER_ID,                1).         %% 日常奖励

-define(BUILDING_TYPE_NORMAL,                   1).         %% 普通建筑
-define(BUILDING_TYPE_CORE,                     2).         %% 核心建筑

-define(ENTER_SCENE,                            1).         %% 进入场景
-define(EXIT_SCENE,                             2).         %% 退出场景

-define(REWARD_NO_FINISH,                       0).         %% 未达成奖励
-define(REWARD_NO_RECEIVE,                      1).         %% 已经达成奖励未领取
-define(REWARD_HAS_RECEIVE,                     2).         %% 已经领取奖励

-define(DEFAULT_SHIP_ID,                        1).         %% 默认的战舰id

-define(JOIN_GUILD_NUM,                         2).         %% 每个服前几名公会参战

-define(PROPS_TERRAIN_LIM_NO,                   0).         %% 道具使用地形不限制
-define(PROPS_TERRAIN_LIM_LAND,                 1).         %% 道具只能在陆地使用
-define(PROPS_TERRAIN_LIM_SEA,                  2).         %% 道具只能在海域使用

-define(PROPS_CFD_ID_1,                         1).         %% 护卫舰道具
-define(PROPS_CFD_ID_2,                         2).         %% 帝国卫士道具
-define(PROPS_CFD_ID_3,                         3).         %% 进攻号角道具
-define(PROPS_CFD_ID_4,                         4).         %% 高级战舰道具

-define(NORMAL_BUILDING_NUM,                    4).         %% 普通船坞建筑数量

-define(FORBID_PK_DURATION,                     30).        %% 战斗开始后多久时间内不能进行战斗

%% ------------------------------- 配置 -----------------------------------------
%% 跨服公会战岛屿配置
-record(kf_gwar_island_cfg, {
    id = 0,                             %% 岛屿id
    seas_type = 0,                      %% 所属海域类型
    seas_subtype = 0,                   %% 所属海域子类型
    name = <<>>,                        %% 名字
    icon = 0,                           %% 图标
    min_bid = 0,                        %% 最低宣战消耗的公会资金
    next_id = 0,                        %% 自动宣战岛屿id
    chief_reward = [],                  %% 会长奖励
    member_reward = [],                 %% 公会成员奖励
    normal_reward = []                  %% 普通玩家奖励
    }).

%% 跨服公会战建筑配置
-record(kf_gwar_building_cfg, {
    id = 0,                             %% 建筑id
    type = 0,                           %% 建筑类型
    name = <<>>,                        %% 名字
    mid = 0,                            %% 怪物类型id
    pos = {0, 0},                       %% 坐标
    texture = [],                       %% 贴图
    att_score = 0,                      %% 每次攻击增加的积分
    occupy_score = 0,                   %% 首次占领增加的积分
    onhook_pos = {0, 0},                %% 挂机坐标点
    reborn_point = {0, 0}               %% 复活点坐标
    }).

%% 跨服公会战战舰配置
-record(kf_gwar_ship_cfg, {
    id = 0,                             %% 战舰id
    name = <<>>,                        %% 战舰名字
    desc = <<>>,                        %% 战舰描述
    model_id = 0,                       %% 战舰模型id
    condition = [],                     %% 获得战舰的条件
    attr = [],                          %% 属性加成
    skill = []                          %% 技能列表
    }).

%% 跨服公会战道具配置
-record(kf_gwar_props_cfg, {
    id = 0,                             %% 道具id
    name = <<>>,                        %% 名字
    desc = <<>>,                        %% 描述
    icon = 0,                           %% 图标id
    times_lim = 0,                      %% 使用次数上限
    terrain = 0,                        %% 地形限制
    cost_score = 0,                     %% 消耗物资
    cost_gold = 0                       %% 消耗钻石
    }).

%% 跨服公会战阶段奖励配置
-record(kf_gwar_stage_reward_cfg, {
    id = 0,
    min_wlv = 0,                        %% 世界等级下限
    max_wlv = 0,                        %% 世界等级上限
    score = 0,                          %% 所需积分
    reward = []                         %% 奖励
    }).

%% 跨服公会战排名奖励配置
-record(kf_gwar_ranking_reward_cfg, {
    id = 0,                             %% 奖励id
    min_ranking = 0,                    %% 排名下限
    max_ranking = 0,                    %% 排名上限
    score_plus = 0,                     %% 积分奖励
    reward = []                         %% 奖励
    }).

%% 跨服公会战击杀奖励配置
-record(kf_gwar_kill_reward_cfg, {
    id = 0,                             %% 奖励id
    min_ranking = 0,                    %% 排名下限
    max_ranking = 0,                    %% 排名上限
    reward = []                         %% 奖励
    }).

%% 跨服公会战赛季奖励配置
-record(kf_gwar_season_reward_cfg, {
    ranking = 0,                        %% 排名
    reward = []                         %% 奖励
    }).

-record(kf_guild_war_state, {
    status = 0,
    etime = 0,
    round = 0,
    max_room_id = 1,
    ref = [],
    score_ref = [],                         %% 积分定时器
    guild_map = #{},                        %% #{公会id => #guild_info{}}
    island_map = #{},                       %% #{岛屿id => #island_info{}}
    room_index = #{},                       %% #{公会id => pid}
    bid_index = #{}                         %% #{公会id => 出价宣战的岛屿id}
    }).

-record(kf_guild_war_local_state, {
    sync = 0,                               %% 同步标识
    sync_ref = [],                          %% 同步数据定时器
    status = 0,                             %% 活动状态
    round = 0,                              %% 轮次
    etime = 0,                              %% 当前活动阶段结束时间
    qualification_list = [],                %% 本次参战的第一二名公会列表[{guild_id, guild_name, ranking}]
    confirm_time = 0,                       %% 参赛公会资格确认时间
    resource_map = #{},                     %% #{公会id => #resource_info{}}
    donate_map = #{}                        %% 捐赠物资Map #{{RoleId, GuildId, Type} => Times}
    }).

-record(guild_info, {
    ser_id = 0,                             %% 服务器id
    ser_name = <<>>,
    guild_id = 0,
    guild_name = <<>>,
    score = 0,
    ranking = 0,
    island_id = 0,                          %% 占领的岛屿id
    score_utime = 0,                        %% 积分更新时间
    island_utime = 0                        %% 岛屿更新时间
    }).

-record(island_info, {
    guild_id = 0,                           %% 占领的公会id
    bid_list = [],                          %% 出价列表
    battle_pid = []                         %% 战斗房间pid
    }).

-record(resource_info, {
    num = 0,                                %% 拥有的资源数量
    funds = 0,                              %% 宣战资金
    props_list = [],                        %% 拥有的道具列表
    times_map = #{}                         %% 本场战斗道具的使用次数
    }).

-record(dominator_info, {
    role_id = 0,
    figure = undefined,
    guild_id = 0,
    pos = 0
    }).

-record(bid_info, {
    ser_id = 0,
    ser_name = <<>>,
    guild_id = 0,
    guild_name = <<>>,
    bid = 0,
    time = 0
    }).

-record(building_info, {
    id = 0,                                 %% 建筑id
    guild_id = 0,                           %% 归属的公会id
    hp = 0,                                 %% 血量
    hp_ref = [],                            %% 血量恢复定时器
    occupy_times = #{}                      %% #{guild_id => 占领次数}
    }).

-record(kf_guild_war_battle, {
    room_id = 0,                                        %% 房间id
    round = 0,                                          %% 第几轮比赛
    ref = [],                                           %% 房间关闭定时器
    island_id = 0,                                      %% 岛屿id
    forbid_pk_etime = 0,                                %% 活动房间开启后多少时间内禁止攻击
    etime = 0,                                          %% 战斗结束时间
    guild_map = #{},                                    %% 公会Map #{guild_id => #guild_battle_info{}}
    building_map = #{},                                 %% #{building_id => #building_info{}}
    role_list = []                                      %% 参战玩家列表 [#role_battle_info{}]
    }).

%% 玩家战斗信息
-record(role_battle_info, {
    node = [],
    server_id = 0,                                      %% 服务器id
    server_name = <<>>,                                 %% 服务器名字
    role_id = 0,                                        %% 玩家id
    role_name = <<>>,                                   %% 玩家名字
    scene = 0,                                          %% 玩家所在场景id
    guild_id = 0,                                       %% 所属公会id
    group = 0,                                          %% 阵营分组
    ship_id = 0,                                        %% 玩家当前选择的战舰id
    ship_ids = [],                                      %% 已经拥有的战舰id列表
    score = 0,                                          %% 积分
    ranking = 0,                                        %% 排名
    kill_num = 0,                                       %% 击杀数量
    die_num = 0,                                        %% 死亡次数
    combo = 0,                                          %% 当前连杀数
    max_combo = 0                                       %% 最大连杀数
    }).

%% 公会战斗
-record(guild_battle_info, {
    ser_id = 0,
    ser_name = <<>>,
    guild_id = 0,                                       %% 公会id
    guild_name = <<>>,                                  %% 公会名字
    tag = 0,                                            %% 攻方/守方 1:攻方 2:守方
    group = 0,                                          %% 阵营分组
    born_point = {0, 0},                                %% 出生坐标点
    dump_up_point = undefined,                          %% 召集点
    role_num = 0,                                       %% 场景玩家数量
    building_num = 0,                                   %% 占领的建筑数量
    score = 0,                                          %% 积分
    ranking = 0,                                        %% 排名
    utime = 0                                           %% 积分更新时间
    }).

-record(status_kf_guild_war, {                          %% 玩家身上的跨服公会战信息
    in_sea = 0,                                         %% 是否在海里 0: 不在 1: 在
    ship_id = ?DEFAULT_SHIP_ID                          %% 玩家默认拥有的战舰id
    }).

-define(sql_select_kf_gwar_guild_info,
    <<"select guild_id, guild_name, ser_id, ser_name, island_id, score, score_utime, island_utime from kf_guild_war_guild">>).

-define(sql_select_kf_gwar_bid_info,
    <<"select guild_id, guild_name, ser_id, ser_name, island_id, bid, time from kf_guild_war_bid_info">>).

-define(sql_select_kf_gwar_resource_info,
    <<"select guild_id, resource, funds, props_list from kf_guild_war_resource">>).

-define(sql_select_kf_gwar_donate_info,
    <<"select role_id, guild_id, type, times from kf_guild_war_role_donate">>).

-define(sql_select_kf_gwar_join_guild,
    <<"select guild_id, guild_name, ranking, time from kf_guild_war_join_guild">>).

-define(sql_update_kf_gwar_donate_list,
    <<"replace into kf_guild_war_role_donate(role_id, guild_id, type, times) values(~p, ~p, ~p, ~p)">>).

-define(sql_update_kf_gwar_resource,
    <<"replace into kf_guild_war_resource(guild_id, resource, funds, props_list) values(~p, ~p, ~p, '~s')">>).

-define(sql_insert_kf_gwar_join_guild,
    <<"insert into kf_guild_war_join_guild(guild_id, guild_name, ranking, time) values(~p, '~s', ~p, ~p)">>).

-define(sql_update_kf_gwar_bid,
    <<"replace into kf_guild_war_bid_info(guild_id, guild_name, ser_id, ser_name, island_id, bid, time) values(~p, '~s', ~p, '~s', ~p, ~p, ~p)">>).

-define(sql_update_kf_gwar_guild_info,
    <<"replace into kf_guild_war_guild(guild_id, guild_name, ser_id, ser_name, island_id, score, score_utime, island_utime)
        values(~p, '~s', ~p, '~s', ~p, ~p, ~p, ~p)">>).

-define(sql_delete_kf_gwar_bid,
    <<"delete from kf_guild_war_bid_info where guild_id = ~p">>).

-define(sql_delete_kf_gwar_bid_more,
    <<"delete from kf_guild_war_bid_info where guild_id in (~s)">>).

-define(sql_clear_kf_gwar_join_guild,
    <<"truncate table kf_guild_war_join_guild">>).

-define(sql_clear_kf_gwar_donate_list,
    <<"truncate table kf_guild_war_role_donate">>).

-define(sql_clear_kf_gwar_bid,
    <<"truncate table kf_guild_war_bid_info">>).

-define(sql_clear_kf_gwar_guild,
    <<"truncate table kf_guild_war_guild">>).