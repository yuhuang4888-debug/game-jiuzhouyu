%%%-----------------------------------
%%% @Module      : advertisement
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 14. 四月 2021 16:53
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-author("carlos").



-record(advertisement_cfg, {
	version_id = 0 , % '版本id',
	mod_id = 0, % '功能id',
	mod_sub_id = 0 , % '功能子id',
	max_count = 0 , % '触发次数限制',
	%%doc ="" '描述@lang@',
	reward = [], % '奖励',
	clear_type = 0 , % 清理类型
	advertisement_id = "", % 广告id
	platform = ""        %% 渠道
}).


-record(advertisement, {
     key = 0       %% {id, sub_id}
	 ,mod_id = 0   %% 功能id
	 , sub_id = 0  %% 子id
	 , ad_id = ""  %% 广告id
	 , grade = 0   %% 档次id
	 , cd = 0
	 , count = 0   %% 触发次数
	 , time  = 0   %% 时间
}).

-record(advertisement_status, {
	mod_id = 0   %% 功能id
	, sub_id = 0  %% 子id
	, grade = 0   %% 档次id
	,lists = []   %% [#advertisement{}]
}).


%%====db=======================

-define(sql_replace_ad, <<"REPLACE  into  role_advertisement(`role_id`, `mod_id`, `mod_sub_id`, `advertisement_id`, `time`, `count`)
 values(~p, ~p, ~p, '~s', ~p, ~p)">>).

-define(sql_delete_by_id, <<"DELETE  from   role_advertisement where    mod_id = ~p  and    mod_sub_id =  ~p">>).


-define(sql_select_by_id, <<"select  mod_id, advertisement_id, mod_sub_id, time, count from   role_advertisement where  role_id = ~p">>).


-define(save_log, <<"insert  into   log_role_advertisement(`role_id`, `mod_id`, `mod_sub_id`, `advertisement_id`, `time`, `count`)
 values(~p, ~p, ~p, '~s', ~p, ~p)">>).
