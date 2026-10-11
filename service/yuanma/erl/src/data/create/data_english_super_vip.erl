%%%---------------------------------------
%%% module      : data_english_super_vip
%%% description : 英文需求_SVIP功能配置
%%%
%%%---------------------------------------
-module(data_english_super_vip).
-compile(export_all).
-include("english_super_vip.hrl").



get_vip_act_info(1) ->
	#base_english_super_vip{act_id = 1,start_time = 1656604800,end_time = 1972310399,condition = [{open_channel, ["yy25dlaya_kf"]},{open_lv, 35}, {recharge_money, 1000}],ad_content = [{["yy25dlaya_kf"], [1]}],pic_content = [{["yy25dlaya_kf"], [1]}],pri_content = [{["yy25dlaya_kf"], [1,2,3,4,5]}],con_content = [{["yy25dlaya_kf"], [1]}]};

get_vip_act_info(2) ->
	#base_english_super_vip{act_id = 2,start_time = 1659283200,end_time = 1756655999,condition = [{open_channel, ["jzy_sh921_yiyou_PM003042"]},{open_lv, 35}, {recharge_money, 6}],ad_content = [{["jzy_sh921_yiyou_PM003042"], [1]}],pic_content = [{["jzy_sh921_yiyou_PM003042"], [2]}],pri_content = [{["jzy_sh921_yiyou_PM003042"], [6,7,8,9]}],con_content = [{["jzy_sh921_yiyou_PM003042"], [2]}]};

get_vip_act_info(_Actid) ->
	[].

get_all_act_id() ->
[1,2].

