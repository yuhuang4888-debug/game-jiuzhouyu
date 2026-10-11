%%%--------------------------------------
%%% @Author  : xiaoxiang
%%% @Email   : 
%%% @Created : 2017.3.20
%%% @Description: vip
%%%--------------------------------------

%%--------------------------------

-record(role_vip, {
    vip_type = 0              %% 特权卡类型：1白银vip，2紫晶vip，3皇钻vip
    ,vip_lv = 0               %% vip等级
    ,vip_exp = 0              %% vip当前经验
    ,vip_hide = 0             %% vip隐藏
    , free_time = 0           %% 免费到期时间 ，如果是0 则是没有过免费vip， 如果在免费期间，购买，升级，取消定时器
    , free_ref = []           %% 免费vip 时间
    ,cost_gold = 0            %% 当前消耗不足10钻的非绑钻石，每消耗10钻加1点经验
    ,fetched_list = []        %% 已领取奖励的vip等级列表
    ,week_list = []           %% 可领取周礼包奖励  [{VipLv, UnLockTime, LastGotTime}]  [{vip等级, 解锁时间, 上次获取时间}]
    ,login_exp_time = 0       %% 登录获得vip经验时间
    ,vip_card_list = []       %% 特权卡列表 [#vip_card{}]
    ,free_card = []           %% 免费卡列表  {vip_type, State}    State : 1 可领取  2 已领取
    ,total_login_time = 0     %% 累计登陆时间
%%    ,first_login_time = 0     %% 首次
}).

-record(vip_card, {
    vip_type = 0              %% 特权卡类型：1白银vip，2紫晶vip，3皇钻vip
    , forever = 0             %% 是否永久：0否，1是
    , is_temp_card = 0        %% 是否体验卡：0否，1体验卡
    , end_time = 0            %% 过期时间 
    , award_status = 0        %% 首次激活奖励状态：0未获得，1已获得
    , vip_card = 0            %% 卡类型
}).

%% vip数量data
-record(data_num_by_vip, {  %%  base_num_by_vip
    module_id = 0,          %%  功能id
    id        = 0,          %%  类型
    vip_type  = 0,          %%  特权卡类型
    vip       = 0,          %%  vip
    num       = 0           %%  数量
}).

%% vip数量基础
-record(data_num_by_vip_info,{  %% base_num_by_vip_info
    module_id = 0,              %%  功能id
    id        = 0,              %%  类型
    name      = [],             %%  描述
    num_type  = 0,              %%  数值类型
    num       = 0,              %%  默认数量
    about     = []              %%  备注
}).

%% VIP配置（新）
-record(data_vip, {             %% base_vip_config
    vip_lv                      %% vip 等级
    ,need_gold                  %% 累计经验
    ,rewards                    %% 奖励
    ,week_max_times             %% 周礼包数量
    ,week_rewards               %% 周礼包奖励
    ,value                      %% 价值
    ,reward_cost = []           %% vip等级奖励消耗
}).

%% 特权卡配置
-record(data_vip_card, {        %% base_vip_card
    vip_type = 0,               %% 特权卡类型：1白银vip，2紫晶vip，3皇钻vip
    vip_name = "",              %% 特权卡名称
    price = 0,                  %% 特权卡价格
    give_lv = 0,                %% 保送vip等级
    vip_exp = 0,                %% 特权卡经验
    expire_type = 0,            %% 有效期类型：0永久类型，1秒类型，2小时类型，3天数类型
    expire_time = 0,            %% 有效期数值
    award_list = []  ,          %% 首次购买奖励
    get_config = []             %% 领取条件
}).

%% 特权卡道具
-record(data_vip_goods, {       %% base_vip_goods
    goods_id = 0,               %% 物品id
    vip_type = 0,               %% 特权卡类型：1白银vip，2紫晶vip，3皇钻vip
    is_temp_card = 0,           %% 是否体验卡：0否，1体验卡
    expire_type = 0,            %% 有效期类型：0永久类型，1秒类型，2小时类型，3天数类型
    expire_time = 0,            %% 有效期数值
    give_lv = 0,                %% 保送vip等级
    vip_exp = 0                 %% 特权卡经验
}).

%% 特权卡ets时效表
-record (ets_vip_card, {
    key         = {0,0},        %% 主键 {玩家id, 特权卡类型}
    end_time    =  0            %% 结束时间戳 
}).



-define(ETS_VIP_CARD, ets_vip_card).    %% 特权卡时效

-define(GIVE_EXP, 50).              %% 赠送经验值
%%-define(VIP_TYPE_SILVER, 1).            %% 特权卡类型：1白银vip
%%-define(VIP_TYPE_AMETHYST,2).           %% 特权卡类型：2紫晶vip
%%-define(VIP_TYPE_EMPEROR, 3).           %% 特权卡类型：3皇钻vip

%%-define(GOODS_ID_VIP_EXP, 300060).      %% 物品类型Id：vip经验   影响lib_goods_usee.erl


-define(SP_NUM_TYPE,    2).         %%  特殊类型

-define(INSERT_VIP_INFO,                <<"insert into `role_vip`(`id`,`vip_lv`) values(~p,~p)">>).
-define(SELECT_VIP_INFO,                <<"select `vip_lv`,`vip_exp`, `vip_hide`, `cost_gold`, `fetched_list`, `week_list`, `login_exp_time`, `free_card`, `total_login_time` from `role_vip` where `id`=~p">>).
-define(SELECT_VIP_LV,                  <<"select vip_lv from role_vip where id=~p">>).
-define(UPDATE_VIP_INFO,                <<"update `role_vip` set `vip_lv`=~p,`vip_exp`=~p, `cost_gold`=~p where `id`=~p">>).
-define(UPDATE_VIP_HIDE,                <<"update `role_vip` set `vip_hide`= ~p where `id`=~p">>).
-define(UPDATE_VIP_REWARD,              <<"update `role_vip` set `fetched_list`=\"~ts\" where `id`=~p">>).
-define(UPDATE_VIP_WEEK_REWARD,         <<"update `role_vip` set `week_list` = \"~ts\" where `id`=~p">>).
-define(UPDATE_VIP_TOTAL_TIME,          <<"update `role_vip` set `total_login_time` = ~p, `free_card` = \"~ts\" where `id` = ~p">>).
-define(UPDATE_VIP_LOGIN_EXP_TIME,      <<"update `role_vip` set `login_exp_time`= ~p where `id`=~p">>).


-define(UPDATE_VIP_FREE_VIP,                <<"update `role_vip` set `free_time` =~p where `id`=~p">>).


%% 特权卡
-define(INSERT_VIP_CARD,                <<"replace into role_vip_card(id, vip_type, forever, is_temp_card, end_time, award_status) values(~p, ~p, ~p, ~p, ~p, ~p)">>).
-define(SELECT_VIP_CARD,                <<"select vip_type, forever, is_temp_card, end_time, award_status from role_vip_card where id = ~p">>).
-define(UPDATE_VIP_CARD_AWARD_STATUS,   <<"update role_vip_card set award_status = ~p where id=~p and vip_type=~p">>).

%% 钻石vip
%%-define(SELECT_SUP_VIP, <<"select forever,end_time,daily_award_count,last_charge_time,continue_charge_days,total_charge
%%                                    ,gold_exchange_counts,goods_exchange_counts,diamonds,diamonds_exchange_info,exchange_list from role_vip_sup where role_id = ~p">>).
%%-define(SAVE_SUP_VIP,   <<"replace into role_vip_sup(role_id,forever,end_time,daily_award_count,last_charge_time,continue_charge_days,total_charge
%%                                    ,gold_exchange_counts,goods_exchange_counts, diamonds,diamonds_exchange_info,exchange_list) values(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~ts', '~ts')">>).
%%-define(INSERT_SUP_VIP, <<"replace into role_vip_sup(role_id, end_time) values (~p, ~p)">>).
%%-define(DELETE_SUP_VIP, <<"delete from role_vip_sup where role_id = ~p">>).

% 错误码
% 领取vip奖励
-define(ERR_REWARD_SUCC       , 1). % 成功领取
-define(ERR_REWARD_VIPLV_LIMIT, 2). % vip等级不足
-define(ERR_REWARD_FETCHED    , 3). % 已被领取

% 领取周礼包
-define(ERR_WEEK_REWARD_SUCC   , 1). % 成功领取
-define(ERR_WEEK_REWARD_FETCHED, 2). % 已被领取
-define(ERR_WEEK_ISNT_PAY,       3). % 体验卡

-define(VIP_CONVERT, 100).  % vip配置扩大10倍
%% 钻石vip适用错误码
%% 1   成功
%% 10  你已经是钻石vip了哦
%% 11  钱不够
%% 12  已经领取过了哦
%% 13  你还不是钻石vip哦
%% 14  配置不存在
%% 15  兑换次数已达上限
%% 16  物品不足
%% 17  钻石不足
%% 18  还不是永久钻石vip
