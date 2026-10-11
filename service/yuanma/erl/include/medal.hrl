%%%-----------------------------------
%%% @Module      : medal
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 28. 八月 2018 17:34
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


%% --------------------------------------------------------
%% 配置宏
%% --------------------------------------------------------


%%数据记录


%%勋章信息
-record(medal, {
	id = 0                       %%勋章id
	, medal_name = ''            %%勋章名
	, mark = ''                  %%备注
	, cost = []                  %%晋升消耗
	, add_attr = []              %%属性加成
	, large_image_id = 0         %%资源大图标ID
	, small_image_id = 0         %%资源小图标ID
	, medal_start = 0            %%星数
	, upgrade_power = 0          %%升级到下一级所需战力
	, other_condition = []       %%其他条件
	, is_repair = 0              %%0 未修复，1  已经修复
	, title = ""                 %% 头衔
	, stren_lv = 0                  %% 强化等级
	, stren_exp = 0              %% 强化经验
}).

