%%-----------------------------------------------------------------------------
%% @Module  :       guild_war
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-01
%% @Description:    公会争霸
%%-----------------------------------------------------------------------------

%% 赛区级别
-define(DIVISION_TYPE_S, 1).                        %% S级赛区
-define(DIVISION_TYPE_A, 2).                        %% A级赛区
-define(DIVISION_TYPE_B, 3).                        %% B级赛区
-define(DIVISION_TYPE_C, 4).                        %% C级赛区
-define(DIVISION_TYPE_D, 5).                        %% D级赛区

-define(ORIGIN_DIVISION_MAP,
    #{
        ?DIVISION_TYPE_S => []
        , ?DIVISION_TYPE_A => []
        , ?DIVISION_TYPE_B => []
        , ?DIVISION_TYPE_C => []
        , ?DIVISION_TYPE_D => []
    }).

%% 活动状态
-define(ACT_STATUS_CLOSE,       0).                 %% 活动关闭阶段
-define(ACT_STATUS_CONFIRM,     1).                 %% 活动信息确认阶段，确认参加公会争霸的公会信息
-define(ACT_STATUS_BATTLE,      2).                 %% 对战阶段
-define(ACT_STATUS_REST,        3).                 %% 停战休息阶段

%% 战斗分组
-define(GROUP_RED,  1).                             %% 红方
-define(GROUP_BLUE, 2).                             %% 蓝方

-define(FIRST_GAME_GUILD_NUM,   16).                %% 第一届比赛公会数量
-define(DIVISION_GUILD_NUM,     4).                 %% 每个赛区的公会数量

%% 存放在guild_war_key_val表的key
-define(GLOBAL_KEY_VAL_COMFIRM_STATUS,      1).         %% 是否已经进行过D赛区比赛信息确认
-define(GLOBAL_KEY_VAL_GAME_TIMES,          2).         %% 比赛举办次数
-define(GLOBAL_KEY_VAL_STREAK_TIMES,        3).         %% 本届主宰公会连胜次数
-define(GLOBAL_KEY_VAL_DOMINATOR_GUILD_ID,  4).         %% 本届主宰公会id

%% 活动传闻
-define(TV_TYPE_BATTLE_START,       1).
-define(TV_TYPE_BATTLE_END,         2).
-define(TV_TYPE_COMBO,              3).
-define(TV_TYPE_OCCUPY,             4).
-define(TV_TYPE_RES_BE_ATTACKED,    5).
-define(TV_TYPE_RESOURCE,           6).

-define(GWAR_SCENE_POOL_ID,     0).

-define(ALLOT_REWARD_TYPE_STREAK,   1).             %% 分配连胜奖励
-define(ALLOT_REWARD_TYPE_BREAK,    2).             %% 分配终结奖励

-define(ALLOT_TYPE_MANUAL,      1).                     %% 会长手动分配
-define(ALLOT_TYPE_BE_BREAK,    2).                     %% 被终结连胜自动分配给会长
-define(ALLOT_TYPE_MERGE,       3).                     %% 合服重置自动分配给会长

-record(gwar_cfg, {
    id = 0,
    key = "",
    val = 0,
    desc = ""
    }).

%% 公会争霸战斗奖励配置
-record(gwar_reward_cfg, {
    min_wlv = 0,                    %% 世界等级下限
    max_wlv = 0,                    %% 世界等级上限
    division = 0,                   %% 赛区级别
    round = 0,                      %% 比赛回合次数
    victory_reward = [],            %% 胜方奖励
    failure_reward = []             %% 负方奖励
    }).

%% 公会争霸连胜奖励配置
-record(gwar_streak_reward_cfg, {
    min_wlv = 0,                    %% 世界等级下限
    max_wlv = 0,                    %% 世界等级上限
    streak_times = 0,               %% 连胜次数
    reward = []                     %% 奖励
    }).

%% 公会争霸终结连胜奖励配置
-record(gwar_break_reward_cfg, {
    min_wlv = 0,                    %% 世界等级下限
    max_wlv = 0,                    %% 世界等级上限
    streak_times = 0,               %% 连胜次数
    reward = []                     %% 奖励
    }).

-record(status_guild_war, {
    status = 0,                     %% 状态
    etime = 0,                      %% 当前状态结束时间
    ref = undefine,                 %% 活动定时器
    game_times = 0,                 %% 已比赛举办次数 0:表示首届比赛
    index_map = #{},                %% #{guild_id => division}  用于同步公会信息做索引用
    division_map = #{},             %% 参加公会争霸的公会Map #{division => [#status_gwar_guild{}]} 每场比赛结束了所在赛区的公会要根据胜利场数排序
    room_map = #{},                 %% #{room_id => #gwar_room{}}
    status_dominator = []           %% 当前主宰公会的信息
    }).

-record(status_gwar_guild, {
    guild_id = 0,                   %% 公会id
    guild_name = <<>>,              %% 公会名字
    chief_id = 0,                   %% 会长id
    division = 0,                   %% 赛区
    ranking = 0,                    %% 同赛区的公会排名
    ranking_score = 0,              %% 排名积分 用来确定本届比赛结束后的排名
    match_id = 0,                   %% 匹配id相同的表示同一赛区小组的对手 0表示轮空 >0表示匹配成功
    room_id = 0,                    %% 所在房间id
    streak_times = 0,               %% 连胜次数
    win_times = 0,                  %% 本届比赛胜利次数
    combat_power = 0                %% 公会战力 用于确定D赛区公会初始排名以及每回合比赛的结果影响因素之一
    }).

-record(status_reward, {
    reward = [],                    %% 奖励
    extra = 0,                      %% 附加信息，连胜奖励用于保存奖励对应的连胜次数
    allot_times = 0                 %% 奖励分配次数
    }).

-record(status_dominator, {
    guild_id = 0,                   %% 主宰公会的id
    guild_name = 0,                 %% 主宰公会的名字
    chief_id = 0,                   %% 主宰公会会长id
    streak_times = 0,               %% 连胜次数
    reward = #{},                   %% 连胜奖励 #{奖励id => #status_reward{}}
    break_reward = #status_reward{} %% 终结奖励 #status_reward{}
    }).

%% 公会战房间信息
-record(gwar_room, {
    pid = undefine,
    division = 0,
    % group_index = #{},            %% 分组id索引 #{guild_id => group_id}
    winner_id = 0                   %% 获胜的公会id
    }).

%% 公会争霸战斗status 战斗房间进程内部status
-record(status_gwar_battle, {
    room_id = 0,                    %% 房间id
    division = 0,                   %% 哪个赛区的房间
    round = 0,                      %% 第几轮次比赛
    start_pk_time = 0,              %% 允许战斗的开始时间
    etime = 0,                      %% 战斗结束时间
    ref = 0,                        %% 活动流程定时器
    res_ref = undefine,             %% 资源刷新定时器，根据在场公会人数定时增加资源
    guild_map = #{},                %% #{guild_id => #gwar_guild_info{}} 分组id:红方 蓝方
    resource_mon_map = #{}          %% 资源怪 #{mon_key => #resource_mon_info{}}
    }).

-record(gwar_guild_info, {
    guild_id = 0,                   %% 公会id
    guild_name = <<>>,              %% 公会名字
    group_id = 0,                   %% 分组id 战斗场景内的分组id:红方 蓝方
    resource = 0,                   %% 资源
    combat_power = 0,               %% 公会战力
    resource_mon_num = 0,           %% 拥有资源怪数量
    role_num = 0,                   %% 玩家人数
    role_map = #{},                 %% 参与公会争霸的玩家列表#{role_id => #gwar_role_info{}}
    plus_rate = 0                   %% 资源增长速率
    }).

-record(gwar_role_info, {
    role_id = 0,
    scene = 0,                      %% 当前所在场景 0: 表示已经退出活动场景
    combo = 0,                      %% 连杀数
    die_num = 0                     %% 死亡次数
    }).

-record(resource_mon_info, {
    id = 0,                         %% 资源怪id create_key里面的id
    ref = [],                       %% 资源定时器，定时给占领资源点的一方增加资源数量
    hp_ref = [],                    %% 回血定时器，资源怪一定时间内未受到攻击自动回满血量
    guild_id = 0                    %% 占领的公会id
    }).

-define(sql_guild_war_division,
    <<"select g.id, g.name, g.chief_id, gw.division, gw.ranking from guild as g inner join guild_war_division as gw on g.id = gw.guild_id">>).
-define(sql_guild_war_reward,
    <<"select id, guild_id, streak_times, reward, allot_times from guild_war_reward">>).
-define(sql_guild_war_break_reward,
    <<"select guild_id, reward, allot_times from guild_war_break_reward">>).
-define(sql_select_guild_short_info,
    <<"select name, chief_id from guild where id = ~p">>).
-define(sql_select_global_key_val,
    <<"select val from guild_war_key_val where id = ~p">>).

-define(sql_update_global_key_val,
    <<"replace guild_war_key_val(id, val) values(~p, '~s')">>).
-define(sql_update_streak_reward,
    <<"update guild_war_reward set allot_times = ~p where id = ~p">>).
-define(sql_update_streak_reward_more,
    <<"update guild_war_reward set allot_times = ~p where id in (~s)">>).
-define(sql_update_break_reward,
    <<"update guild_war_break_reward set allot_times = ~p where guild_id = ~p">>).

-define(sql_delete_guild,
    <<"delete from guild_war_division where guild_id = ~p">>).

-define(sql_guild_war_clear_division,
    <<"truncate table guild_war_division">>).
-define(sql_guild_war_clear_streak_reward,
    <<"truncate table guild_war_reward">>).
-define(sql_guild_war_clear_break_reward,
    <<"truncate table guild_war_break_reward">>).
-define(sql_guild_war_clear_global_key_val,
    <<"truncate table guild_war_key_val">>).