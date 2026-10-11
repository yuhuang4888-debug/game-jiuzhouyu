%%%---------------------------------------
%%% module      : data_red_envelopes
%%% description : 红包配置
%%%
%%%---------------------------------------
-module(data_red_envelopes).
-compile(export_all).
-include("red_envelopes.hrl").



get(1) ->
	#red_envelopes_cfg{id = 1,type = 1,ownership_type = 1,name = <<"提升VIP4红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP4</color>，获得<color@1>100绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP4尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,4}],money = 100,min_num = 10};

get(2) ->
	#red_envelopes_cfg{id = 2,type = 1,ownership_type = 1,name = <<"提升VIP5红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP5</color>，获得<color@1>150绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP5尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,5}],money = 150,min_num = 10};

get(3) ->
	#red_envelopes_cfg{id = 3,type = 1,ownership_type = 1,name = <<"提升VIP6红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP6</color>，获得<color@1>200绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP6尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,6}],money = 200,min_num = 10};

get(4) ->
	#red_envelopes_cfg{id = 4,type = 1,ownership_type = 1,name = <<"提升VIP7红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP7</color>，获得<color@1>300绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP7尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,7}],money = 300,min_num = 10};

get(5) ->
	#red_envelopes_cfg{id = 5,type = 1,ownership_type = 1,name = <<"提升VIP8红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP8</color>，获得<color@1>500绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP8尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,8}],money = 500,min_num = 10};

get(6) ->
	#red_envelopes_cfg{id = 6,type = 1,ownership_type = 1,name = <<"提升VIP9红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP9</color>，获得<color@1>800绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP9尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,9}],money = 800,min_num = 10};

get(7) ->
	#red_envelopes_cfg{id = 7,type = 1,ownership_type = 1,name = <<"提升VIP10红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP10</color>，获得<color@1>1000绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP10尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,10}],money = 1000,min_num = 10};

get(8) ->
	#red_envelopes_cfg{id = 8,type = 1,ownership_type = 1,name = <<"提升VIP11红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP11</color>，获得<color@1>1000绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP11尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,11}],money = 1000,min_num = 10};

get(9) ->
	#red_envelopes_cfg{id = 9,type = 1,ownership_type = 1,name = <<"提升VIP12红包"/utf8>>,desc = <<"恭喜<color@2>{1}</color>提升至<color@1>VIP12</color>，获得<color@1>1000绑玉</color>尊享红包"/utf8>>,greetings = <<"VIP12尊享红包"/utf8>>,trigger_interval = 1,trigger_times = 1,condition = [{vip,12}],money = 1000,min_num = 10};

get(11) ->
	#red_envelopes_cfg{id = 11,type = 2,ownership_type = 1,name = <<"每日累充红包"/utf8>>,desc = <<"<color@2>{1}</color>完成每日累充，获得<color@1>100绑玉</color>尊享红包"/utf8>>,greetings = <<"每日累充红包"/utf8>>,trigger_interval = 3,trigger_times = 1,condition = [{today_recharge,300}],money = 100,min_num = 10};

get(13) ->
	#red_envelopes_cfg{id = 13,type = 4,ownership_type = 1,name = <<"每日首充红包"/utf8>>,desc = <<"<color@2>{1}</color>完成每日首充，获得<color@1>50绑玉</color>尊享红包"/utf8>>,greetings = <<"每日首充红包"/utf8>>,trigger_interval = 3,trigger_times = 1,condition = [],money = 50,min_num = 10};

get(14) ->
	#red_envelopes_cfg{id = 14,type = 5,ownership_type = 1,name = <<"月卡投资红包"/utf8>>,desc = <<"<color@2>{1}</color>进行月卡投资，获得<color@1>50绑玉</color>尊享红包"/utf8>>,greetings = <<"月卡投资红包"/utf8>>,trigger_interval = 3,trigger_times = 1,condition = [],money = 50,min_num = 10};

get(15) ->
	#red_envelopes_cfg{id = 15,type = 6,ownership_type = 1,name = <<"等级投资红包"/utf8>>,desc = <<"<color@2>{1}</color>进行等级投资，获得<color@1>50绑玉</color>尊享红包"/utf8>>,greetings = <<"等级投资红包"/utf8>>,trigger_interval = 3,trigger_times = 1,condition = [],money = 50,min_num = 10};

get(4203004) ->
	#red_envelopes_cfg{id = 4203004,type = 99,ownership_type = 1,name = <<"大妖首杀"/utf8>>,desc = <<"<color@2>{1}</color>完成<color@1>全服首杀</color>，获得<color@1>150绑玉</color>尊享红包"/utf8>>,greetings = <<"恭喜您获得大妖首杀结社红包"/utf8>>,trigger_interval = 0,trigger_times = 0,condition = [],money = 150,min_num = 20};

get(42060002) ->
	#red_envelopes_cfg{id = 42060002,type = 99,ownership_type = 1,name = <<"御魂塔首杀"/utf8>>,desc = <<"<color@2>{1}</color>完成<color@1>符文高塔首杀</color>，获得<color@1>50绑玉</color>尊享红包"/utf8>>,greetings = <<""/utf8>>,trigger_interval = 0,trigger_times = 0,condition = [],money = 50,min_num = 10};

get(42060003) ->
	#red_envelopes_cfg{id = 42060003,type = 99,ownership_type = 1,name = <<"神巫副本首通"/utf8>>,desc = <<"<color@2>{1}</color>完成<color@1>神巫副本首通</color>，获得<color@1>50绑玉</color>尊享红包"/utf8>>,greetings = <<""/utf8>>,trigger_interval = 0,trigger_times = 0,condition = [],money = 50,min_num = 10};

get(_Id) ->
	[].

get_ids() ->
[1,2,3,4,5,6,7,8,9,11,13,14,15,4203004,42060002,42060003].


get_ids_by_type(1) ->
[1,2,3,4,5,6,7,8,9];


get_ids_by_type(2) ->
[11];


get_ids_by_type(4) ->
[13];


get_ids_by_type(5) ->
[14];


get_ids_by_type(6) ->
[15];


get_ids_by_type(99) ->
[4203004,42060002,42060003];

get_ids_by_type(_Type) ->
	[].

get_goods_cfg(4203004) ->
	#red_envelopes_goods_cfg{goods_type_id = 4203004,ownership_type = 1,name = <<"大妖首杀结社红包"/utf8>>,desc = <<"大妖首杀结社红包"/utf8>>,greetings = <<"大妖首杀结社红包"/utf8>>,money_type = 2,money = 150,min_num = 20,times_lim = 0};

get_goods_cfg(42060002) ->
	#red_envelopes_goods_cfg{goods_type_id = 42060002,ownership_type = 1,name = <<"御魂塔首杀红包"/utf8>>,desc = <<"御魂塔首杀红包"/utf8>>,greetings = <<"御魂塔首杀红包"/utf8>>,money_type = 2,money = 50,min_num = 10,times_lim = 0};

get_goods_cfg(42060003) ->
	#red_envelopes_goods_cfg{goods_type_id = 42060003,ownership_type = 1,name = <<"神巫副本首通红包"/utf8>>,desc = <<"神巫副本首通红包"/utf8>>,greetings = <<"神巫副本首通红包"/utf8>>,money_type = 2,money = 50,min_num = 10,times_lim = 0};

get_goods_cfg(_Goodstypeid) ->
	[].

