%%%---------------------------------------
%%% module      : data_wx_subscribe
%%% description : 推送活动信息配置
%%%
%%%---------------------------------------
-module(data_wx_subscribe).
-compile(export_all).
-include("wx.hrl").



get_act_info(132) ->
	#base_wx_act_subscribe{act_id = 132,title = <<"您的离线挂机收益已满"/utf8>>,content = <<"上线领取吧"/utf8>>,rewards = <<""/utf8>>};

get_act_info(135) ->
	#base_wx_act_subscribe{act_id = 135,title = <<"九魂妖塔"/utf8>>,content = <<"争夺至尊九魂秘宝奖励！"/utf8>>,rewards = <<""/utf8>>};

get_act_info(137) ->
	#base_wx_act_subscribe{act_id = 137,title = <<"勾玉擂台"/utf8>>,content = <<"参与即可领取海量勾玉！"/utf8>>,rewards = <<""/utf8>>};

get_act_info(186) ->
	#base_wx_act_subscribe{act_id = 186,title = <<"四海争霸"/utf8>>,content = <<"参与获得海量奖励"/utf8>>,rewards = <<""/utf8>>};

get_act_info(218) ->
	#base_wx_act_subscribe{act_id = 218,title = <<"尊神战场"/utf8>>,content = <<"赢取时装碎片以及御魂"/utf8>>,rewards = <<""/utf8>>};

get_act_info(279) ->
	#base_wx_act_subscribe{act_id = 279,title = <<"天启之源"/utf8>>,content = <<"参与获得丰厚天启圣装"/utf8>>,rewards = <<""/utf8>>};

get_act_info(281) ->
	#base_wx_act_subscribe{act_id = 281,title = <<"巅峰竞技"/utf8>>,content = <<"参与即可获取大量荣耀值"/utf8>>,rewards = <<""/utf8>>};

get_act_info(285) ->
	#base_wx_act_subscribe{act_id = 285,title = <<"午间派对"/utf8>>,content = <<"海量经验送不停！"/utf8>>,rewards = <<""/utf8>>};

get_act_info(402) ->
	#base_wx_act_subscribe{act_id = 402,title = <<"结社晚宴"/utf8>>,content = <<"参与获取大量的经验！"/utf8>>,rewards = <<""/utf8>>};

get_act_info(505) ->
	#base_wx_act_subscribe{act_id = 505,title = <<"最强结社"/utf8>>,content = <<"获取稀有时装、装备和材料！"/utf8>>,rewards = <<""/utf8>>};

get_act_info(621) ->
	#base_wx_act_subscribe{act_id = 621,title = <<"最强王者"/utf8>>,content = <<"挑战赢取稀有宝宝幻化"/utf8>>,rewards = <<""/utf8>>};

get_act_info(652) ->
	#base_wx_act_subscribe{act_id = 652,title = <<"异域夺宝"/utf8>>,content = <<"击败怪物，赢取装备宝物"/utf8>>,rewards = <<""/utf8>>};

get_act_info(_Actid) ->
	[].

