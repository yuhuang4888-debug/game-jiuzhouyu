%%-----------------------------------------------------------------------------
%% @Module  :       guild_boss
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-07
%% @Description:    公会Boss
%%-----------------------------------------------------------------------------

-define(P_GUILD_BOSS, "P_GUILD_BOSS").                          %% 进程字典 #{guild_id => #status_gboss{}}

-define(REF_UPDATE_INTERVAL, 5 * 60).                           %% 更新数据库Boss血量的定时器
-define(REF_UPDATE_GBOSS_HP, "P_REF_UPDATE_GBOSS_HP").          %% 更新数据库Boss血量的定时器

-define(GBOSS_STATUS_CLOSE, 0).                                 %% 关闭阶段
-define(GBOSS_STATUS_OPEN, 1).                                  %% 开启阶段
-define(GBOSS_STATUS_SETTLEMENT, 2).                            %% 副本结算阶段(胜利结算|失败结算)

-define(GBOSS_AUCTION_REWARD_TYPE_1, 1).                            %% 普通拍品
-define(GBOSS_AUCTION_REWARD_TYPE_2, 2).                            %% 珍惜拍品

%% 公会Boss常量配置
-record(gboss_cfg, {
    id = 0,
    key = "",
    val = 0,
    desc = ""
    }).

%% 公会副本配置
-record(gboss_dun_cfg, {
    dun_id = 0,                 %% 副本id
    min_wlv = 0,                %% 世界等级下限
    max_wlv = 0,                %% 世界等级上限
    boss_id = 0,                %% Boss怪物Id
    fix_reward = [],            %% 参与奖
    auction_reward = [],        %% 拍卖产出
    bgold_auction_reward = [],  %% 绑钻拍卖产出
    reward = []                 %% 奖励预览
    }).

-record(status_gboss, {
    guild_id = 0,               %% 公会id
    dun_pid = undefine,         %% 副本进程
    dun_id = 0,                 %% 副本id
    optime = 0,                 %% 副本开启时间 >0表示已经开启
    kill_time = 0,              %% boss击杀时间 >0表示已经击杀
    hp = 0,                     %% Boss剩余血量 0:表示Boss满血
    mon_state = 0,              %% 怪物状态 1 已击杀
    gboss_mat = 0,              %% 兽粮
    challenge_times = 0,        %% 挑战次数
    auto_drumup = 1,            %% 1 默认自动召集
    last_drum_up_time = 0,       %% 上次召集时间
    auction_reward = [],        %% 拍卖品列表
    role_list = [],
    drop_mon_list = [],          %% 掉落宝箱列表
    drop_mon_expire_time = 0,    %% 宝箱消失时间
    drop_mon_expire_ref = none   %% 宝箱定时器
    }).

-record(gboss_role, {
    role_id = 0,               %% 玩家id
    is_enter = 0,
    is_hurt = 0,
    is_show = 0,
    clt_list = []
    }).

-record(gboss_state, {
    guild_id = 0,               %% 公会id
    scene = 0,
    pool_id = 0,
    war_state = 0,
    optime = 0,
    end_time = 0,
    dun_id = 0,
    role_list = [],
    ref = []
    }).

-define(sql_select_guild_boss, 
    <<"select guild_id, dun_id, optime, hp, gboss_mat, challenge_times, auto_drumup, drum_up_time from guild_boss">>).
-define(sql_save_guild_boss, 
    <<"replace into guild_boss(guild_id, dun_id, optime, hp, gboss_mat, challenge_times, auto_drumup, drum_up_time) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(sql_reset_challenge_times, 
    <<"update guild_boss set challenge_times = 0">>).
-define(sql_reset_dun_id, 
    <<"update guild_boss set dun_id = 0, drum_up_time = 0">>).
-define(sql_update_guild_boos_hp, 
    <<"update guild_boss set hp = ~p where guild_id = ~p">>).
-define(sql_update_guild_boos_mat, 
    <<"update guild_boss set gboss_mat = ~p where guild_id = ~p">>).
-define(sql_kill_guild_boos, 
    <<"update guild_boss set dun_id = 0, optime = 0, hp = 0 where guild_id = ~p">>).
-define(sql_delete_guild_boos_by_guild_id, 
    <<"delete from guild_boss where guild_id = ~p">>).


