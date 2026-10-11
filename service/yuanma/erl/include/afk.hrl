%% ---------------------------------------------------------------------------
%% @doc afk.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-31
%% @deprecated 挂机规则2
%% ---------------------------------------------------------------------------

%% kv值
-define(AFK_KV(Key), data_afk:get_value(Key)).
-define(AFK_KV_MAX_TIME, ?AFK_KV(1)).           % 离线最大时长(单位秒)
-define(AFK_KV_MAX_DAY_BGOLD, ?AFK_KV(2)).      % 每天最大的绑钻数量
-define(AFK_KV_EXP_BACK_GOODS, ?AFK_KV(3)).     % 额外找回的经验药水道具ID
-define(AFK_KV_UNIT_TIME, ?AFK_KV(4)).          % 奖励计算的单位时间（秒）##不能填0,根据策划配置来计算单位时间,改动要通知服务端
-define(AFK_KV_UNIT_TIME_FACTOR, ?AFK_KV(5)).   % 挂机单位时间倍率##不能填0,根据策划配置来计算单位时间,改动要通知服务端,?AFK_KV_UNIT_TIME*3=间隔触发时间
-define(AFK_KV_BACK_UNIT_TIME, ?AFK_KV(6)).     % 找回挂机奖励的单位时间（秒）
-define(AFK_KV_BACK_EXP_FACTOR, ?AFK_KV(7)).    % 找回挂机经验加成比率(万分比)
-define(AFK_KV_NO_KILL_MON_TIME, ?AFK_KV(8)).   % 没有击杀任何野怪超过X秒,进入挂机
-define(AFK_KV_TV_LIST, ?AFK_KV(9)).            % 传闻物品列表##[GoodsTypeId]
-define(AFK_KV_TV_BGOLD_NUM, ?AFK_KV(10)).      % 绑定钻石触发传闻数量##绑定钻石数量
-define(AFK_KV_OPEN_LV, ?AFK_KV(11)).           % 挂机开放等级
-define(AFK_KV_DEFAULT_AFK_TIME, ?AFK_KV(12)).  % 创建角色默认挂机时间(秒)
-define(AFK_KV_MAX_ALL_AFK_TIME, ?AFK_KV(13)).  % 最大挂机时长（单位秒）##玩家在线和离线挂机的时长限制
-define(AFK_KV_MAX_BACK_SECOND,  ?AFK_KV(14)).  % 额外可找回经验最大时长（秒）
-define(AFK_KV_AUTO_FUSION_LV,   ?AFK_KV(15)).  % 自动吞噬的等级

-define(AFK_INIT_NO, 0).            % 没有初始化##不要触发挂机事件,也不能领取奖励。登录流程时不升级,客户端显示异常
-define(AFK_INIT_YES, 1).           % 初始化

%% 挂机规则
-record(status_afk, {
        is_init = 0                 % 是否初始化完##没有初始化完不能修改更新时间点,除了登出和重连
        , afk_left_time = 0         % 挂机剩余时间
        , afk_utime = 0             % 挂机更新时间点
        , afk_stop_et = 0           % 挂机终止结束时间戳
        , no_goods_list = []        % 未领取物品列表##yy25d使用,
        , day_bgold = 0             % 每天绑定钻石
        , day_utime = 0             % 每天更新时间
        % 离线的处理
        , exp_ratio_list = []       % 经验比率加成##[{BuffType, 倍率, 结束时间戳}]
        , off_reward_list = []      % 离线获得的奖励列表##废弃
        , off_lv = 0                % 未挂机时的等级
        , off_cost_afk_time = 0     % 离线消耗的挂机时间
        , back_time = 0             % 能找回的总时间
        , back_exp = 0              % 能找回的总经验
        , had_back_time = 0         % 已经找回的时间
        , trigger_log = undefined
        , all_afk_utime = 0         % 所有已使用的挂机时间##离线触发时间和在线挂机时间都会使这个值增加
    }).

-record(status_afk_trigger_log, {
        acc_multi = 0
        , acc_reward = []
        , begin_time = 0
        , acc_bgold = 0
}).

%% 挂机规则
-record(base_afk, {
        lv = 0                      % 等级
        , base_power = 0            % 标准战力
        , base_exp = 0              % 标准经验
        , base_coin = 0             % 标准铜币
        , drop_list = []            % 掉落列表[1和2对应的所有掉落物品id]
        , drop_rule = []            % 掉落规则1:1+2:1=250; 3:1=750 = [ {[{1,1}, {2, 1}], 250}, {[{3,1}], 750} ] %% 默认概率是1000：(权重和随机
    }).


-define(sql_role_afk_select, <<"
    SELECT 
        afk_left_time, afk_utime, no_goods_list, day_bgold, day_utime, exp_ratio_list, all_afk_utime, back_time, back_exp,had_back_time
    FROM role_afk WHERE role_id = ~p">>).
-define(sql_role_afk_replace, <<"
    REPLACE INTO 
        role_afk(role_id, afk_left_time, afk_utime, no_goods_list, day_bgold, day_utime, all_afk_utime, exp_ratio_list, back_time, back_exp,had_back_time)
    VALUES(~p, ~p, ~p, '~s', ~p, ~p, ~p, '~s',~p,~p,~p)">>).
-define(sql_role_afk_update_day_bgold, <<"UPDATE role_afk set day_bgold = ~p, day_utime = ~p WHERE role_id = ~p">>).

-define(sql_role_afk_update_receive_reward, <<"UPDATE role_afk set all_afk_utime = 0, no_goods_list = '[]' WHERE role_id = ~p">>).