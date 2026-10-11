%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%  惊喜礼包
%%% @end
%%% Created : 24. 四月 2019 1:14
%%%-------------------------------------------------------------------
-author("whao").


%%  惊喜礼包配置   base_surprise_gift
-record(surprise_gift_cfg, {
    gift_id = 0,        %% 礼包id
    gift_dec = "",		%% 礼包描述
    gift_price = [],    %% 礼包价格  [ vip显示价格 , 实际价格 ]
    gift_reward = [],	%% 礼包奖励
    return_gold = [],   %% 每天返还钻石数
    return_day = 0  ,   %% 累计返还天数
    model_id = 0,
    model_power = 0
}).


%% 惊喜礼包抽奖配置  base_surprise_gift_draw
-record(surprise_gift_draw, {
    turn_id= 0,         %%  轮次
    gift_id = 0,        %%  抽奖礼包id
    reward_weigh = 0 , %%  奖励权重
    reward_list =[],    %%  奖励内容
    is_tv = 0           %%  是否传闻
}).


%%  惊喜礼包kv配置  base_surprise_gift_kv
-record(base_surprise_gift_kv,{
    key = 0,        %% 键
    name = "",      %% 名称
    value = [],     %% 数据
    desc = ""       %% 备注
}).


-record(status_surprise,{
    draw_times = 0,  % 总抽奖次数
    add_free_times = 0, %% 额外增加了的免费抽奖次数
    use_free_times = 0, %% 已经使用的免费抽奖次数
    turn_id = 0,     % 抽奖轮数
    gift_list = [],  % 礼包状态列表 [{gift_id, buy_time, Day}]   已购买 购买时间 领取返利天数
    draw_list = []   % 抽奖礼包   [draw_id,...]      当前轮次的抽奖id
}).




%% k-v 表
-define(SURP_KV(Key), data_surprise:get_surprise_kv(Key)).

-define(SURP_KV_VIP_LEV,                 ?SURP_KV(1)).   %% VIP等级限制
-define(SURP_KV_OPEN_DAY,                ?SURP_KV(2)).   %% 开服天数限制
-define(SURP_KV_OPEN_LEV,                ?SURP_KV(3)).   %% 角色等级可见限制

-define(MAX_DRAW_ID, 0).    % 已经都抽完了

-define(DAILY_FREE, 1).     % 购买完礼包后每日可获得的免费抽奖次数




%% 获取玩家数据库
-define(sql_select_surprise,
    <<"select role_id, draw_times, add_free_times, use_free_times, turn_id, gift_list, draw_list from player_surprise_gift where role_id = ~p">>).

%% 更新数据库
-define(sql_replace_surprise,
    <<"replace into `player_surprise_gift`(role_id, draw_times, add_free_times, use_free_times, turn_id, gift_list, draw_list) values(~p, ~p, ~p, ~p, ~p, '~ts', '~ts')">>).


































