%%%------------------------------------
%%% @Module  : mon_pic.hrl
%%% @Author  : zengzy
%%% @Created : 2018-04-10
%%% @Description: 怪物图鉴
%%%------------------------------------

%% ps图鉴状态
-record(status_mon_pic, {
		pic_list = [], 		 %%图鉴列表,格式[#mon_pic{}]
		group_list = [],	 %%激活的组合id, 格式[{GroupId, Lv}]
		attr = [],  		 %%总属性,包括所有图鉴属性+图鉴组合属性
		special_attr = []	 %%特殊属性（武器攻击。。。）
    }).

%%图鉴类型记录(为了扩展，暂时不用)
% -record(pic, { 
% 		type = 0,			 %%图鉴类型
% 		group_list = [],     %%激活的组合id
% 		mon_pic_list = [],   %%图鉴列表,格式[#mon_pic{}]
% 		attr = []			 %%总属性, 所有图鉴属性+组合属性
% 	}).

%%图鉴记录
-record(mon_pic,{
		pic_id = 0,			 %%图鉴id
		lv = 0,			 	 %%等级
		attr = []		     %%属性
	}).

%%图鉴配置记录
-record(base_pic,{           %% base_mon_pic
		id = 0,
		type = 0,
		group = 0 ,			 %% 暂弃
		quality = 0,
		lv = 0,
		open_con = [],
		open_lv = 0,
		open_other = [],
		description = ""
	}).

%%图鉴组合配置记录
-record(base_group,{        %% base_mon_pic_group
		id = 0,
		type = 0,
		lv = 0,
		name = "",
		need_list = [],
		attr = []
	}).

%% -------------------------- sql宏定义 ---------------------------
-define(sql_pic_group_select, 		<<"select group_id,lv from mon_pic_group where role_id = ~p">>).
-define(sql_pic_group_replace, 		<<"replace into mon_pic_group(role_id, group_id, lv) values(~p, ~p, ~p) ">>).
-define(sql_mon_pic_select,         <<"select pic_id, lv from mon_pic where role_id =~p">>).
-define(sql_mon_pic_replace, 		<<"replace into mon_pic(role_id, pic_id, lv) values(~p, ~p, ~p) ">>).

