%%%-----------------------------------
%%% @Module      : attr_medicament
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 02. 一月 2019 17:39
%%% @Description : 文件摘要
%%%-----------------------------------
-author("chenyiming").


-define(attr_medicament_lv_list, [1, 2, 3, 4]).

-record(role_attr_medicament,{
	attr_list  = [],         %% 属性列表
	count_list = []          %% {GoodTypeId, 当天次数, 使用总次数}
}).




%%=========================sql =======================
-define(select_attr_medicament,
	<<"select   attr_list from  role_attr_medicament   where  role_id = ~p">>).

-define(select_attr_medicament_count,
	<<"select  goods_type_id, day_count, all_count from  role_attr_medicament_count    where  role_id = ~p">>).


-define(replace_attr_medicament,
	<<"REPLACE INTO  role_attr_medicament  VALUES(~p,  ~p)">>).


-define(replace_attr_medicament_count,
	<<"REPLACE INTO  role_attr_medicament_count  VALUES(~p, ~p, ~p, ~p)">>).

-define(set_attr_medicament_day_count,
	<<"UPDATE  role_attr_medicament_count  set  day_count = ~p">>).

