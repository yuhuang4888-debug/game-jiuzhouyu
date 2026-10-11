%%-----------------------------------------------------------------------------
%% @Module  :       fireworks_act.hrl
%% @Author  :       Fwx
%% @Created :       2018-3-6
%% @Description:    烟花盛典活动
%%-----------------------------------------------------------------------------

-define(OPEN_LV, 100).

-define(CONVERT_ADD_CLEAR, 1000).       %% 到达周期会清零
-define(CONVERT_ALL_SERVER, 10000).     %% 本次活动全服烟花使用次数
-define(CONVERT_ADD, 100).              %% 本次活动全服抽到对应id物品次数（活动内不清）

%% 常量配置
-record(base_fireworks_act_cfg, {
    id   = 0,
    key  = "",
    val  = 0,
    desc = ""
}).

-record(base_fireworks_act, {
    id = 0,             % 唯一id
    wlv = 0,            % 世界等级
    goods = [],         % 单种奖励
    weight = 0,         % 基础权重
    limit_num = 0,      % 单次烟花使用次数周期内道具获取上限
    all_server_num= 0,  % 全服限制次数
    is_tv = 0           % 是否发通告
}).

-record(base_fireworks_plus_weight, {
    id = 0,             % 唯一id
    times = 0,          % 次数
    plus_weight = 0     % 增加权重
}).

-record(fireworks, {
    utime = 0,          % 更新时间
    use_num= 0,         % 烟花使用次数
    wlv = 0,            % 活动开始时世界等级
    infoL = []          % [#reward_info{}]
}).

-record(reward_info,{
    id = 0,             % 唯一id
    num = 0,            % 获得次数
    limit_num = 0,      % 数量上限
    utime = 0           % 更新时间
}).

-define(select_fireworks_act,
    <<"select use_num, wlv, utime from fireworks_act where role_id = ~p">>).

-define(select_fireworks_reward_info,
    <<"select id, num, limit_num, utime from fireworks_reward_info where role_id = ~p">>).

-define(replace_fireworks_act,
    <<"replace into fireworks_act(role_id, use_num, wlv, utime)
    values(~p, ~p, ~p, ~p)">>).

-define(replace_fireworks_reward_info,
    <<"replace into fireworks_reward_info(role_id, id, num, limit_num, utime)
    values(~p, ~p, ~p, ~p, ~p)">>).

-define(delete_fireworks_reward_info_role_id,
    <<"delete from fireworks_reward_info where role_id = ~p">>).