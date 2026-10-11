%%%-----------------------------------
%%% @Module      : revelation_equip
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 六月 2019 16:58
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


-define(pos_list, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).
-define(pos_length, 10).

-define(gathering_star, 3).   %%聚灵生效等级

-define(gathering_enable, 1).
-define(gathering_unable, 0).

-record(revelation_equip_cfg, {
	goods_id = 0                %% 物品id
	, stage = 0                  %% 阶数
	, star = 0                   %% 星数
	, base_rating = 0            %% 基础评分
	, recommend_attr = []        %% 推荐属性
	, other_attr = []            %% 额外属性
}).



-record(role_revelation_equip, {
	max_figure_id = 0            %% 最大形象id
	, current_figure = 0         %% 当前形象id
	, gathering = []             %% [{pos, lv, exp}] {位置, 等级, 经验}   %%这里要保存10个位置
	, skill = []                 %% [{skill, lv}] 技能
	, power = 0                  %% 战力相关的升级技能，升级吞噬，穿脱下装备的时候  战力 = 装备本身属性 + 套装属性 + 吞噬属性 + 技能属性战力 + 技能本身的战力
	, attr = []                  %% 总属性
	, skill_power = 0            %% 技能战力
}).


-define(replace_sql, <<"replace  into role_revelation_equip(role_id, max_figure_id, current_figure, gathering, skill) values(~p, ~p, ~p, '~s', '~s')">>).
-define(select_sql,
	<<"select  max_figure_id, current_figure, gathering, skill from  role_revelation_equip where   role_id = ~p">>).