%%%-----------------------------------
%%% @Module      : magic_circle
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 24. 十一月 2018 11:16
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


-define(magic_circle_open, 1).   %%魔法阵开启状态
-define(magic_circle_close, 0).  %%魔法阵关闭状态

-define(common_create_type, 0).  %%普通召唤
-define(special_create_type, 1). %%特殊召唤  用于免费体验

-define(magic_circle_count_type, 1).  %%免费次数体验次数计数器子类型

-define(naughty_imp, 1).    %%调皮小鬼
-define(eggshell_angel, 2). %%蛋壳天使
-define(naughty_devil, 3).  %%调皮恶魔
-define(guardian_angel, 4). %%守护天使



-record(magic_circle, {
    lv      = 0        %%0 无魔法阵 1 :调皮小鬼 2 蛋壳天使 3  调皮恶魔 4  守护天使
	,status = ?magic_circle_close        %%0 :未激活  1 已激活
	,attr   = []       %%魔法阵属性
	,ref    = []       %%失效定时器
	,free_flag =  0    %%免费体验  0：没有免费体验  1：可以免费体验  2正在免费体验
	,show      = 1     %%是否幻化  0：不幻化  1：幻化
	,end_time  = 0        %%结束时间戳
}).


-record(data_magic_circle, {
	pre_lv  = 0               %% 前置魔法阵等级
    ,magic_circle_lv = 0      %% '魔法阵等级',
    ,lv	                      %% '玩家等级',
    ,name                     %% '魔法阵名称',
    ,cost	                  %% '召唤消耗',
    ,last_day                 %% '持续天数',
    ,attr                     %% '加成属性',
}).