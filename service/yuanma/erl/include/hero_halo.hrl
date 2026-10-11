%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             主角光环
%%% @end
%%% Created : 19. 11月 2022 15:05
%%%-------------------------------------------------------------------

-define(NO_REWARD,      0).       %% 未领取
-define(ALREADY_REWARD, 1).       %% 已领取

-define(HALO_DROP_SPEED,                2).     %% 拾取速度
-define(HALO_TYPE_JJC,                  3).     %% 竞技场扫荡次数
-define(HALO_SEA_TIMES,                 4).     %% 璀璨之海船只免费升级
-define(HALO_DUNGEON_CHALLENGE_TIMES,   5).     %% 副本次数合并
-define(HALO_DECORATION_BUFF,           7).     %% 怨灵封印pvp伤害减免
-define(HALO_ADVENTURE_TIMES,           8).     %% 遗迹探宝免费次数
-define(HALO_DUN_WEEK_BUFF,             9).     %% 极地试炼加伤害buff

-define(NOT_USE_HALO,      0).     %% 不使用特权
-define(USE_HALO,          1).     %% 使用特权

-define(DUN_TYPE,       1).         %% 副本
-define(BOSS_TYPE,      2).         %% BOSS

%% 主角光环充值id
-define(HALO_RECHARGE_ID,   data_key_value:get(5140000)).
%% 主角光环购买持续时间
-define(HALO_BUY_TIME,   data_key_value:get(5140001)).
%% 主角光环购买时间限制
-define(HALO_INTERVAL_BUY_TIME,   data_key_value:get(5140003)).

-record(base_hero_halo,{
	id = 0                      % 特权id
	, picture = []              % 原画id
	, desc = []                 % 描述
	, supplement_desc = []      % 客户端补充说明
	, reward = []               % 奖励
	, condition = []            % 条件
	, weight = 0                % 权重
	, value = []                % 特权参数
}).

-record(halo_status,{
	end_time = 0            % 结束时间
	, privilege_list = []   % 特权奖励领取列表
	, is_send = 0           % 是否补发过未领取奖励
}).

-define(sql_select_hero_halo, <<"select end_time, privilege_list, is_send from role_halo where role_id = ~p">>).

-define(sql_replace_hero_halo, <<"replace into role_halo (role_id, end_time, privilege_list, is_send) values (~p, ~p, '~s', ~p)">>).