%%%---------------------------------------
%%% module      : data_wx
%%% description : 微信配置
%%%
%%%---------------------------------------
-module(data_wx).
-compile(export_all).
-include("wx.hrl").




get_kv(1) ->
[yy_sh921_wx_ios_P0004143,yy_sh921_wx_P0004130,yy_sh921_lj_ios_P0008630,config_yy_sh921_wx_PM000876];


get_kv(2) ->
10;


get_kv(3) ->
[{2,0,30}];


get_kv(4) ->
1;


get_kv(5) ->
10;


get_kv(11) ->
[yy_sh921_wx_ios_P0004143,yy_sh921_wx_P0004130,yy_sh921_lj_ios_P0008630,config_yy_sh921_wx_PM000876];


get_kv(12) ->
[{2,0,20},{0,14020001,1},{3,0,50000}];


get_kv(13) ->
[{2,0,200}];


get_kv(14) ->
30;

get_kv(_Key) ->
	[].

get_temp(132) ->
	#base_wx_subscribe_temp{id = 132,temp_id = "_WjRzjHXLdyLPA8rHLBwaL9MuNzef0SPszh4C3U0JiM",package_code = "P0010643",args = [1,5,6],pos = 5,desc = <<"您的离线挂机收益已满"/utf8>>};

get_temp(135) ->
	#base_wx_subscribe_temp{id = 135,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 4,desc = <<"九魂妖塔"/utf8>>};

get_temp(137) ->
	#base_wx_subscribe_temp{id = 137,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 3,desc = <<"勾玉擂台"/utf8>>};

get_temp(186) ->
	#base_wx_subscribe_temp{id = 186,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 3,desc = <<"四海争霸"/utf8>>};

get_temp(218) ->
	#base_wx_subscribe_temp{id = 218,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 4,desc = <<"尊神战场"/utf8>>};

get_temp(279) ->
	#base_wx_subscribe_temp{id = 279,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 2,desc = <<"天启之源"/utf8>>};

get_temp(281) ->
	#base_wx_subscribe_temp{id = 281,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 4,desc = <<"巅峰竞技"/utf8>>};

get_temp(285) ->
	#base_wx_subscribe_temp{id = 285,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 1,desc = <<"午间派对"/utf8>>};

get_temp(402) ->
	#base_wx_subscribe_temp{id = 402,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 1,desc = <<"结社晚宴"/utf8>>};

get_temp(505) ->
	#base_wx_subscribe_temp{id = 505,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 2,desc = <<"最强结社"/utf8>>};

get_temp(621) ->
	#base_wx_subscribe_temp{id = 621,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 3,desc = <<"最强王者"/utf8>>};

get_temp(652) ->
	#base_wx_subscribe_temp{id = 652,temp_id = "Hb9l69L4zhS8_vnjSimQl-PCUzeUofXb3haSPlEWpxM",package_code = "P0010643",args = [1,2,3,4],pos = 2,desc = <<"异域夺宝"/utf8>>};

get_temp(_Id) ->
	[].

get_arg(1) ->
	#base_wx_subscribe_temp_arg{arg_id = 1,arg_str = "thing1",lan_id = 0,desc = <<"活动名称"/utf8>>};

get_arg(2) ->
	#base_wx_subscribe_temp_arg{arg_id = 2,arg_str = "time8",lan_id = 0,desc = <<"开始时间"/utf8>>};

get_arg(3) ->
	#base_wx_subscribe_temp_arg{arg_id = 3,arg_str = "time9",lan_id = 0,desc = <<"结束时间"/utf8>>};

get_arg(4) ->
	#base_wx_subscribe_temp_arg{arg_id = 4,arg_str = "thing12",lan_id = 0,desc = <<"活动详情"/utf8>>};

get_arg(5) ->
	#base_wx_subscribe_temp_arg{arg_id = 5,arg_str = "date2",lan_id = 0,desc = <<"开始时间"/utf8>>};

get_arg(6) ->
	#base_wx_subscribe_temp_arg{arg_id = 6,arg_str = "phrase6",lan_id = 0,desc = <<"奖励状态"/utf8>>};

get_arg(_Argid) ->
	[].

