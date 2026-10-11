%%%---------------------------------------
%%% module      : data_activitycalen
%%% description : 活动日历配置
%%%
%%%---------------------------------------
-module(data_activitycalen).
-compile(export_all).
-include("activitycalen.hrl").



get_push_config(155,0) ->
	#ac_push{module = 155,module_sub = 0,push = 0,push_msg = "夺旗战场还有5分钟开始"};

get_push_config(279,0) ->
	#ac_push{module = 279,module_sub = 0,push = 0,push_msg = "永恒圣殿还有5分钟开始"};

get_push_config(646,0) ->
	#ac_push{module = 646,module_sub = 0,push = 0,push_msg = "野外领主还有5分钟开始"};

get_push_config(_Module,_Modulesub) ->
	#ac_push{}.

get_reward_config(1) ->
	#ac_reward{id = 1,live = 40,reward = [{1,[{0,38070001,1}]}]};

get_reward_config(2) ->
	#ac_reward{id = 2,live = 80,reward = [{1,[{2,0,50}]}]};

get_reward_config(3) ->
	#ac_reward{id = 3,live = 120,reward = [{1,[{0,38070001,1}]}]};

get_reward_config(4) ->
	#ac_reward{id = 4,live = 150,reward = [{1,[{0,32010480,1}]}]};

get_reward_config(_Id) ->
	#ac_reward{}.

get_reward_id() ->
[1,2,3,4].

get_live_config(132,0) ->
	#ac_liveness{module = 132,module_sub = 0,act_type = 1,name = <<"推荐挂机"/utf8>>,start_lv = 50,end_lv = 9999,max = 1,res_max = 0,live = 0};

get_live_config(135,0) ->
	#ac_liveness{module = 135,module_sub = 0,act_type = 2,name = <<"参加1次九魂圣殿"/utf8>>,start_lv = 130,end_lv = 9999,max = 1,res_max = 1,live = 10};

get_live_config(137,0) ->
	#ac_liveness{module = 137,module_sub = 0,act_type = 2,name = <<"勾玉擂台"/utf8>>,start_lv = 50,end_lv = 9999,max = 1,res_max = 0,live = 10};

get_live_config(157,0) ->
	#ac_liveness{module = 157,module_sub = 0,act_type = 1,name = <<"限时活动"/utf8>>,start_lv = 100,end_lv = 9999,max = 1,res_max = 0,live = 0};

get_live_config(189,1) ->
	#ac_liveness{module = 189,module_sub = 1,act_type = 1,name = <<"巡航"/utf8>>,start_lv = 200,end_lv = 9999,max = 2,res_max = 0,live = 5};

get_live_config(189,2) ->
	#ac_liveness{module = 189,module_sub = 2,act_type = 1,name = <<"掠夺船只"/utf8>>,start_lv = 200,end_lv = 9999,max = 3,res_max = 0,live = 5};

get_live_config(218,0) ->
	#ac_liveness{module = 218,module_sub = 0,act_type = 2,name = <<"尊神战场"/utf8>>,start_lv = 120,end_lv = 9999,max = 1,res_max = 1,live = 0};

get_live_config(241,1) ->
	#ac_liveness{module = 241,module_sub = 1,act_type = 2,name = <<"众生之门"/utf8>>,start_lv = 130,end_lv = 9999,max = 5,res_max = 0,live = 0};

get_live_config(280,0) ->
	#ac_liveness{module = 280,module_sub = 0,act_type = 1,name = <<"挑战10次竞技场"/utf8>>,start_lv = 110,end_lv = 9999,max = 10,res_max = 10,live = 2};

get_live_config(281,0) ->
	#ac_liveness{module = 281,module_sub = 0,act_type = 2,name = <<"巅峰竞技"/utf8>>,start_lv = 180,end_lv = 9999,max = 10,res_max = 1,live = 1};

get_live_config(283,1) ->
	#ac_liveness{module = 283,module_sub = 1,act_type = 1,name = <<"异域大妖"/utf8>>,start_lv = 160,end_lv = 9999,max = 4,res_max = 0,live = 5};

get_live_config(285,1) ->
	#ac_liveness{module = 285,module_sub = 1,act_type = 2,name = <<"午间派对"/utf8>>,start_lv = 100,end_lv = 9999,max = 1,res_max = 1,live = 0};

get_live_config(300,1) ->
	#ac_liveness{module = 300,module_sub = 1,act_type = 1,name = <<"日常任务"/utf8>>,start_lv = 65,end_lv = 9999,max = 20,res_max = 20,live = 1};

get_live_config(300,2) ->
	#ac_liveness{module = 300,module_sub = 2,act_type = 1,name = <<"结社任务"/utf8>>,start_lv = 130,end_lv = 9999,max = 10,res_max = 10,live = 1};

get_live_config(402,2) ->
	#ac_liveness{module = 402,module_sub = 2,act_type = 2,name = <<"结社晚宴"/utf8>>,start_lv = 95,end_lv = 9999,max = 1,res_max = 1,live = 10};

get_live_config(460,4) ->
	#ac_liveness{module = 460,module_sub = 4,act_type = 1,name = <<"蛮荒大妖"/utf8>>,start_lv = 240,end_lv = 9999,max = 2,res_max = 0,live = 0};

get_live_config(460,12) ->
	#ac_liveness{module = 460,module_sub = 12,act_type = 1,name = <<"世界大妖"/utf8>>,start_lv = 78,end_lv = 9999,max = 3,res_max = 0,live = 10};

get_live_config(460,20) ->
	#ac_liveness{module = 460,module_sub = 20,act_type = 1,name = <<"秘境大妖"/utf8>>,start_lv = 400,end_lv = 9999,max = 9,res_max = 0,live = 0};

get_live_config(470,1) ->
	#ac_liveness{module = 470,module_sub = 1,act_type = 1,name = <<"蜃气楼"/utf8>>,start_lv = 320,end_lv = 9999,max = 3,res_max = 0,live = 0};

get_live_config(471,0) ->
	#ac_liveness{module = 471,module_sub = 0,act_type = 1,name = <<"怨灵封印"/utf8>>,start_lv = 360,end_lv = 9999,max = 3,res_max = 0,live = 0};

get_live_config(506,0) ->
	#ac_liveness{module = 506,module_sub = 0,act_type = 2,name = <<"最强结社"/utf8>>,start_lv = 125,end_lv = 9999,max = 1,res_max = 0,live = 10};

get_live_config(610,2) ->
	#ac_liveness{module = 610,module_sub = 2,act_type = 1,name = <<"资源副本"/utf8>>,start_lv = 130,end_lv = 9999,max = 2,res_max = 2,live = 5};

get_live_config(610,5) ->
	#ac_liveness{module = 610,module_sub = 5,act_type = 1,name = <<"寻装觅刃"/utf8>>,start_lv = 95,end_lv = 9999,max = 3,res_max = 3,live = 10};

get_live_config(610,10) ->
	#ac_liveness{module = 610,module_sub = 10,act_type = 1,name = <<"击杀专属大妖"/utf8>>,start_lv = 120,end_lv = 9999,max = 1,res_max = 0,live = 10};

get_live_config(610,13) ->
	#ac_liveness{module = 610,module_sub = 13,act_type = 1,name = <<"姻缘副本"/utf8>>,start_lv = 170,end_lv = 9999,max = 1,res_max = 0,live = 10};

get_live_config(610,18) ->
	#ac_liveness{module = 610,module_sub = 18,act_type = 1,name = <<"万物有灵"/utf8>>,start_lv = 130,end_lv = 9999,max = 2,res_max = 2,live = 10};

get_live_config(610,20) ->
	#ac_liveness{module = 610,module_sub = 20,act_type = 1,name = <<"挑战2次恶灵退治"/utf8>>,start_lv = 70,end_lv = 9999,max = 2,res_max = 2,live = 10};

get_live_config(610,32) ->
	#ac_liveness{module = 610,module_sub = 32,act_type = 1,name = <<"神纹烙印"/utf8>>,start_lv = 290,end_lv = 9999,max = 2,res_max = 0,live = 0};

get_live_config(_Module,_Modulesub) ->
	#ac_liveness{}.

get_live_key() ->
[{132,0},{135,0},{137,0},{157,0},{189,1},{189,2},{218,0},{241,1},{280,0},{281,0},{283,1},{285,1},{300,1},{300,2},{402,2},{460,4},{460,12},{460,20},{470,1},{471,0},{506,0},{610,2},{610,5},{610,10},{610,13},{610,18},{610,20},{610,32}].

get_ac(132,0,0) ->
	#base_ac{module = 132,module_sub = 0,ac_sub = 0,ac_name = <<"主线挂机"/utf8>>,ac_icon = 13200,num = 1,start_lv = 50,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"挂机升级就是这么简单！"/utf8>>,reward = [{50,[{3,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = []};

get_ac(135,0,1) ->
	#base_ac{module = 135,module_sub = 0,ac_sub = 1,ac_name = <<"九魂妖塔"/utf8>>,ac_icon = 13500,num = 1,start_lv = 130,end_lv = 9999,ac_type = 2,week = [2,4,6],month = [],time = [],time_region = [{{20,30},{20,45}}],open_day = [{1,9999}],merge_day = [{0,999}],about = <<"参与九魂妖塔，击败对手,争夺九魂秘宝奖励！"/utf8>>,reward = [{50,[{0,32060111,0},{0,35,0},{0,32010114,0},{0,19020002,0},{0,19020001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(137,0,1) ->
	#base_ac{module = 137,module_sub = 0,ac_sub = 1,ac_name = <<"勾玉擂台"/utf8>>,ac_icon = 13700,num = 1,start_lv = 250,end_lv = 9999,ac_type = 2,week = [1],month = [],time = [],time_region = [{{21,0},{21,20}}],open_day = [{5,9999}],merge_day = [{0,999}],about = <<"参与勾玉擂台，挑战对手,无论输赢，均可领取海量勾玉！"/utf8>>,reward = [{50,[{0,35,0},{0,35,0},{0,35,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(157,0,0) ->
	#base_ac{module = 157,module_sub = 0,ac_sub = 0,ac_name = <<"限时活动"/utf8>>,ac_icon = 15700,num = 1,start_lv = 100,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"参加限时活动可获得活跃度及经验道具奖励"/utf8>>,reward = [{50,[{0,1032,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(186,0,1) ->
	#base_ac{module = 186,module_sub = 0,ac_sub = 1,ac_name = <<"四海争霸"/utf8>>,ac_icon = 18600,num = 1,start_lv = 400,end_lv = 9999,ac_type = 2,week = [7],month = [],time = [],time_region = [{{20,30},{20,50}}],open_day = [{30,9999}],merge_day = [{0,999}],about = <<"纵横四海，统御一方！"/utf8>>,reward = [{1,[{0,19020002,0},{0,32010194,0},{0,19010003,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{28,36255100,30}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(189,1,0) ->
	#base_ac{module = 189,module_sub = 1,ac_sub = 0,ac_name = <<"巡航"/utf8>>,ac_icon = 18901,num = 1,start_lv = 200,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [{4,9999}],merge_day = [{0,999}],about = <<"璀璨之海巡航可获得大量绑玉奖励"/utf8>>,reward = [{1,[{2,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(189,2,0) ->
	#base_ac{module = 189,module_sub = 2,ac_sub = 0,ac_name = <<"掠夺船只"/utf8>>,ac_icon = 18902,num = 1,start_lv = 200,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [{4,9999}],merge_day = [{0,999}],about = <<"掠夺船只"/utf8>>,reward = [{1,[{2,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(206,1,0) ->
	#base_ac{module = 206,module_sub = 1,ac_sub = 0,ac_name = <<"百鬼夜行"/utf8>>,ac_icon = 206,num = 1,start_lv = 130,end_lv = 9999,ac_type = 2,week = [],month = [],time = [],time_region = [{{11,00},{11,30}},{{15,00},{15,30}}],open_day = [{1,9999}],merge_day = [{0,9999}],about = <<"百鬼来袭，夜沾满城风雨"/utf8>>,reward = [{50,[{0,5902011,0},{0,5901005,0},{255,36255115,0},{0,32060119,0},{2,0,0},{3,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(218,0,1) ->
	#base_ac{module = 218,module_sub = 0,ac_sub = 1,ac_name = <<"尊神战场"/utf8>>,ac_icon = 21800,num = 1,start_lv = 130,end_lv = 9999,ac_type = 2,week = [1,3,5,7],month = [],time = [],time_region = [{{20,30},{20,50}}],open_day = [{1,29}],merge_day = [{0,999}],about = <<"三族争霸，荣耀之战一触即发，和阵营成员一起夺得阵营的尊严和荣耀！"/utf8>>,reward = [{50,[{0,32060111,0},{0,12010108,0},{0,32010114,0},{0,19020001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(218,0,2) ->
	#base_ac{module = 218,module_sub = 0,ac_sub = 2,ac_name = <<"尊神战场"/utf8>>,ac_icon = 21800,num = 1,start_lv = 130,end_lv = 9999,ac_type = 2,week = [1,3,5],month = [],time = [],time_region = [{{20,30},{20,50}}],open_day = [{30,9999}],merge_day = [{0,999}],about = <<"三族争霸，荣耀之战一触即发，和阵营成员一起夺得阵营的尊严和荣耀！"/utf8>>,reward = [{50,[{0,32060111,0},{0,12010108,0},{0,32010114,0},{0,19020001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(241,1,0) ->
	#base_ac{module = 241,module_sub = 1,ac_sub = 0,ac_name = <<"众生之门"/utf8>>,ac_icon = 241,num = 1,start_lv = 130,end_lv = 9999,ac_type = 2,week = [],month = [],time = [],time_region = [{{10,00},{10,25}},{{14,00},{14,25}},{{17,00},{17,25}},{{19,00},{19,25}}],open_day = [{1,9999}],merge_day = [{0,9999}],about = <<"芸芸众生，一门窥知百相!"/utf8>>,reward = [{50,[{3,0,0},{0,16020004,0},{0,17020004,0},{0,18020004,0},{0,19020004,0},{0,20020004,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(279,1,0) ->
	#base_ac{module = 279,module_sub = 1,ac_sub = 0,ac_name = <<"天启之源"/utf8>>,ac_icon = 27900,num = 1,start_lv = 470,end_lv = 9999,ac_type = 2,week = [2,5],month = [],time = [],time_region = [{{21,0},{21,25}}],open_day = [{42,9999}],merge_day = [{0,999}],about = <<"击败守护者大妖，即可获得进入天启之源的资格，击杀圣殿中的各种怪物即可获得丰厚的天启圣装奖励！"/utf8>>,reward = [{1,[{0,38310002,0},{0,38310004,0},{0,38310008,0},{0,38310001,0},{0,38310006,0},{0,38310010,0},{0,38310009,0},{0,38310007,0},{0,38310003,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{28,36255100,30}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(280,0,0) ->
	#base_ac{module = 280,module_sub = 0,ac_sub = 0,ac_name = <<"竞技场"/utf8>>,ac_icon = 28000,num = 1,start_lv = 110,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"挑战对手，争夺最高排名！"/utf8>>,reward = [{50,[{2,0,0},{0,36255010,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(281,0,1) ->
	#base_ac{module = 281,module_sub = 0,ac_sub = 1,ac_name = <<"巅峰竞技"/utf8>>,ac_icon = 28101,num = 1,start_lv = 160,end_lv = 9999,ac_type = 2,week = [1,2,3,4,5,6,7],month = [],time = [],time_region = [{{21,0},{21,20}}],open_day = [{1,3}],merge_day = [{0,999}],about = <<"参与巅峰对决,胜者为王!"/utf8>>,reward = [{1,[{0,18010003,0},{2,0,0},{255,41,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(281,0,2) ->
	#base_ac{module = 281,module_sub = 0,ac_sub = 2,ac_name = <<"巅峰竞技"/utf8>>,ac_icon = 28101,num = 1,start_lv = 160,end_lv = 9999,ac_type = 2,week = [3,7],month = [],time = [],time_region = [{{21,0},{21,20}}],open_day = [{5,9999}],merge_day = [{0,999}],about = <<"参与巅峰对决,胜者为王!"/utf8>>,reward = [{1,[{0,18010003,0},{2,0,0},{255,41,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(283,1,1) ->
	#base_ac{module = 283,module_sub = 1,ac_sub = 1,ac_name = <<"异域活动"/utf8>>,ac_icon = 28301,num = 1,start_lv = 160,end_lv = 999,ac_type = 1,week = [],month = [],time = [],time_region = [{{8,0},{19,30}},{{21,30},{2,0}}],open_day = [{2,3}],merge_day = [{0,999}],about = <<"参加异域活动，击杀异域大妖可获得大量影装！"/utf8>>,reward = [{1,[{0,6006407,0},{0,6007407,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(283,1,2) ->
	#base_ac{module = 283,module_sub = 1,ac_sub = 2,ac_name = <<"异域活动"/utf8>>,ac_icon = 28301,num = 1,start_lv = 160,end_lv = 999,ac_type = 1,week = [],month = [],time = [],time_region = [{{8,0},{19,30}}],open_day = [{4,4}],merge_day = [{0,999}],about = <<"参加异域活动，击杀异域大妖可获得大量影装！"/utf8>>,reward = [{1,[{0,6006407,0},{0,6007407,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(285,1,1) ->
	#base_ac{module = 285,module_sub = 1,ac_sub = 1,ac_name = <<"午间派对"/utf8>>,ac_icon = 28501,num = 1,start_lv = 100,end_lv = 9999,ac_type = 2,week = [],month = [],time = [],time_region = [{{12,0},{12,10}}],open_day = [{1,9999}],merge_day = [{0,999}],about = <<"一起参加午间派对，海量经验送不停！丰厚礼包尽情领！"/utf8>>,reward = [{50,[{0,35,0},{0,32010182,0},{0,32010183,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(300,1,0) ->
	#base_ac{module = 300,module_sub = 1,ac_sub = 0,ac_name = <<"日常任务"/utf8>>,ac_icon = 30001,num = 1,start_lv = 65,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"完成日常可获丰厚的经验和铜币奖励，320级后更可免费扫荡，轻松减负！记得每天完成哦！"/utf8>>,reward = [{50,[{3,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(300,2,0) ->
	#base_ac{module = 300,module_sub = 2,ac_sub = 0,ac_name = <<"结社任务"/utf8>>,ac_icon = 30002,num = 1,start_lv = 130,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"完成任务后可以获得大量的结社资金，320级后可免费扫荡哦！"/utf8>>,reward = [{150,[{8,0,0},{4,0,0},{3,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(402,2,1) ->
	#base_ac{module = 402,module_sub = 2,ac_sub = 1,ac_name = <<"结社晚宴"/utf8>>,ac_icon = 40200,num = 3,start_lv = 95,end_lv = 999,ac_type = 2,week = [],month = [],time = [],time_region = [{{20,0},{20,15}}],open_day = [{1,9999}],merge_day = [{0,999}],about = <<"参加结社晚宴活动,可以获得大量的经验！"/utf8>>,reward = [{50,[{0,35,0},{0,38040009,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(460,4,0) ->
	#base_ac{module = 460,module_sub = 4,ac_sub = 0,ac_name = <<"蛮荒大妖"/utf8>>,ac_icon = 46004,num = 1,start_lv = 240,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"击杀蛮荒大妖是最快获取共鸣材料的途径，记得每天都要进去玩耍哦！"/utf8>>,reward = [{50,[{0,38240101,0},{0,38240102,0},{0,38240201,0},{0,38240301,0},{0,38240027,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(460,12,0) ->
	#base_ac{module = 460,module_sub = 12,ac_sub = 0,ac_name = <<"世界大妖"/utf8>>,ac_icon = 46006,num = 1,start_lv = 78,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"挑战世界大妖,红橙装备任你拿！"/utf8>>,reward = [{50,[{0,101015072,0},{0,102015072,0},{0,103015072,0},{0,104015072,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(460,20,0) ->
	#base_ac{module = 460,module_sub = 20,ac_sub = 0,ac_name = <<"秘境大妖"/utf8>>,ac_icon = 46016,num = 1,start_lv = 400,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"击败强大的秘境大妖，收集降神装备，更有机会获得珍贵的降神碎片！"/utf8>>,reward = [{50,[{0,7120101,0},{0,7120102,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(470,1,0) ->
	#base_ac{module = 470,module_sub = 1,ac_sub = 0,ac_name = <<"蜃气楼"/utf8>>,ac_icon = 47001,num = 1,start_lv = 320,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [{8,9999}],merge_day = [{0,9999}],about = <<"听说这里的蜃妖很凶猛滴！击杀可获得珍贵的蜃妖装备哦！"/utf8>>,reward = [{50,[{0,39510011,0},{0,101015082,0},{0,102015082,0},{0,39010502,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(471,0,0) ->
	#base_ac{module = 471,module_sub = 0,ac_sub = 0,ac_name = <<"怨灵封印"/utf8>>,ac_icon = 47100,num = 1,start_lv = 360,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [{8,9999}],merge_day = [{0,9999}],about = <<"挑战怨灵封印,丰富装备任你拿！"/utf8>>,reward = [{1,[{0,55015201,0},{0,55025201,0},{0,55035201,0},{0,55045201,0},{0,55055201,0},{0,55065201,0}]},{580,[{0,79010505,0},{0,79030505,0},{0,79040505,0},{0,79050505,0},{0,79060505,0},{0,79070505,0},{0,79080505,0},{0,79090505,0},{0,79100505,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(506,0,1) ->
	#base_ac{module = 506,module_sub = 0,ac_sub = 1,ac_name = <<"最强结社"/utf8>>,ac_icon = 50500,num = 1,start_lv = 125,end_lv = 9999,ac_type = 2,week = [],month = [],time = [],time_region = [{{21,0},{21,30}}],open_day = [{4,4}],merge_day = [{0,999}],about = <<"参加最强结社,争夺最高结社荣誉！"/utf8>>,reward = [{50,[{0,20030008,0},{0,38250017,0},{0,35,0},{0,20020001,0},{0,36255010,0},{0,37010001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(506,0,2) ->
	#base_ac{module = 506,module_sub = 0,ac_sub = 2,ac_name = <<"最强结社"/utf8>>,ac_icon = 50500,num = 1,start_lv = 125,end_lv = 9999,ac_type = 2,week = [6],month = [],time = [],time_region = [{{21,0},{21,35}}],open_day = [{5,9999}],merge_day = [{0,999}],about = <<"参加最强结社,争夺最高结社荣誉！"/utf8>>,reward = [{50,[{0,20030008,0},{0,38250017,0},{0,35,0},{0,20020001,0},{0,36255010,0},{0,37010001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(610,2,0) ->
	#base_ac{module = 610,module_sub = 2,ac_sub = 0,ac_name = <<"资源副本"/utf8>>,ac_icon = 61000,num = 1,start_lv = 130,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"挑战不同副本，获取各种成长资源"/utf8>>,reward = [{50,[{3,0,0},{0,16020001,0},{0,18020001,0},{0,19020001,0},{0,17020001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(610,5,0) ->
	#base_ac{module = 610,module_sub = 5,ac_sub = 0,ac_name = <<"寻装觅刃"/utf8>>,ac_icon = 61005,num = 1,start_lv = 95,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"和小伙伴们一起组队通关寻装觅刃，有机会获得高级装备哦！简直是每天必做任务之一！"/utf8>>,reward = [{50,[{0,101015072,0},{0,102015072,0},{0,103015072,0},{0,104015072,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(610,10,0) ->
	#base_ac{module = 610,module_sub = 10,ac_sub = 0,ac_name = <<"专属大妖"/utf8>>,ac_icon = 46002,num = 1,start_lv = 140,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"再也不用担心大妖被抢了！这里的大妖任由你来殴打！"/utf8>>,reward = [{50,[{0,101015072,0},{0,102015072,0},{0,103015072,0},{0,104015072,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(610,13,0) ->
	#base_ac{module = 610,module_sub = 13,ac_sub = 0,ac_name = <<"姻缘副本"/utf8>>,ac_icon = 61013,num = 1,start_lv = 170,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"缘分的试炼从这里开始，通关后可获得大量培养材料！"/utf8>>,reward = [{140,[{3,0,0},{0,38100002,0},{0,23020001,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(610,20,0) ->
	#base_ac{module = 610,module_sub = 20,ac_sub = 0,ac_name = <<"恶灵退治"/utf8>>,ac_icon = 61020,num = 1,start_lv = 70,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [],merge_day = [{0,999}],about = <<"静悄悄地告诉你，这里产出的经验是非常多的哦！"/utf8>>,reward = [{50,[{5,0,0},{5,0,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(610,32,0) ->
	#base_ac{module = 610,module_sub = 32,ac_sub = 0,ac_name = <<"神纹烙印"/utf8>>,ac_icon = 61032,num = 1,start_lv = 290,end_lv = 9999,ac_type = 1,week = [],month = [],time = [],time_region = [],open_day = [{5,9999}],merge_day = [{0,999}],about = <<"通过神纹烙印可获得大量神纹"/utf8>>,reward = [{1,[{0,36020001,0},{0,38040030,0},{0,6310402,0},{0,6410302,0},{0,32010463,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [],sign_up_mail = []};

get_ac(621,0,1) ->
	#base_ac{module = 621,module_sub = 0,ac_sub = 1,ac_name = <<"最强王者"/utf8>>,ac_icon = 62101,num = 1,start_lv = 250,end_lv = 9999,ac_type = 2,week = [4],month = [],time = [],time_region = [{{21,0},{21,30}}],open_day = [{5,9999}],merge_day = [{0,999}],about = <<"以一敌众，是时候展示真正的技术了！争当跨服最强者！"/utf8>>,reward = [{1,[{0,38064013,0},{0,68010006,0},{0,68010007,0},{0,32010004,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(652,31,0) ->
	#base_ac{module = 652,module_sub = 31,ac_sub = 0,ac_name = <<"异域夺宝"/utf8>>,ac_icon = 65200,num = 1,start_lv = 160,end_lv = 9999,ac_type = 2,week = [],month = [],time = [],time_region = [{{19,30},{19,45}}],open_day = [{2,4}],merge_day = [{0,999}],about = <<"和结社的小伙伴们一起殴打怪物夺取他们身上的装备宝物吧！异域积分越高，副本奖励倍率越丰厚哦！"/utf8>>,reward = [{1,[{0,101055052,0},{0,101055062,0},{0,101055072,0}]}],ask = 0,look = 0,other = [],sign_up_reward = [{0,32010497,1}],sign_up_mail = [{sign_up,339,340},{fail,341,342}]};

get_ac(_Module,_Modulesub,_Acsub) ->
	#base_ac{}.

get_ac_list() ->
[{132,0,0},{135,0,1},{137,0,1},{157,0,0},{186,0,1},{189,1,0},{189,2,0},{206,1,0},{218,0,1},{218,0,2},{241,1,0},{279,1,0},{280,0,0},{281,0,1},{281,0,2},{283,1,1},{283,1,2},{285,1,1},{300,1,0},{300,2,0},{402,2,1},{460,4,0},{460,12,0},{460,20,0},{470,1,0},{471,0,0},{506,0,1},{506,0,2},{610,2,0},{610,5,0},{610,10,0},{610,13,0},{610,20,0},{610,32,0},{621,0,1},{652,31,0}].

get_ac_list_exclude_sub() ->
[{132,0},{135,0},{137,0},{157,0},{186,0},{189,1},{189,2},{206,1},{218,0},{241,1},{279,1},{280,0},{281,0},{283,1},{285,1},{300,1},{300,2},{402,2},{460,4},{460,12},{460,20},{470,1},{471,0},{506,0},{610,2},{610,5},{610,10},{610,13},{610,20},{610,32},{621,0},{652,31}].

get_ac_sub(132,0) ->
[0];

get_ac_sub(135,0) ->
[1];

get_ac_sub(137,0) ->
[1];

get_ac_sub(157,0) ->
[0];

get_ac_sub(186,0) ->
[1];

get_ac_sub(189,1) ->
[0];

get_ac_sub(189,2) ->
[0];

get_ac_sub(206,1) ->
[0];

get_ac_sub(218,0) ->
[1,2];

get_ac_sub(241,1) ->
[0];

get_ac_sub(279,1) ->
[0];

get_ac_sub(280,0) ->
[0];

get_ac_sub(281,0) ->
[1,2];

get_ac_sub(283,1) ->
[1,2];

get_ac_sub(285,1) ->
[1];

get_ac_sub(300,1) ->
[0];

get_ac_sub(300,2) ->
[0];

get_ac_sub(402,2) ->
[1];

get_ac_sub(460,4) ->
[0];

get_ac_sub(460,12) ->
[0];

get_ac_sub(460,20) ->
[0];

get_ac_sub(470,1) ->
[0];

get_ac_sub(471,0) ->
[0];

get_ac_sub(506,0) ->
[1,2];

get_ac_sub(610,2) ->
[0];

get_ac_sub(610,5) ->
[0];

get_ac_sub(610,10) ->
[0];

get_ac_sub(610,13) ->
[0];

get_ac_sub(610,20) ->
[0];

get_ac_sub(610,32) ->
[0];

get_ac_sub(621,0) ->
[1];

get_ac_sub(652,31) ->
[0];

get_ac_sub(_Module,_Modulesub) ->
	[].

get_ac_by_lv(50,1) ->
[{132,0,0}];

get_ac_by_lv(130,2) ->
[{135,0,1},{206,1,0},{218,0,1},{218,0,2},{241,1,0}];

get_ac_by_lv(130,1) ->
[{300,2,0},{610,2,0}];

get_ac_by_lv(250,2) ->
[{137,0,1},{621,0,1}];

get_ac_by_lv(100,1) ->
[{157,0,0}];

get_ac_by_lv(100,2) ->
[{285,1,1}];

get_ac_by_lv(400,2) ->
[{186,0,1}];

get_ac_by_lv(400,1) ->
[{460,20,0}];

get_ac_by_lv(200,1) ->
[{189,1,0},{189,2,0}];

get_ac_by_lv(470,2) ->
[{279,1,0}];

get_ac_by_lv(110,1) ->
[{280,0,0}];

get_ac_by_lv(160,2) ->
[{281,0,1},{281,0,2},{652,31,0}];

get_ac_by_lv(160,1) ->
[{283,1,1},{283,1,2}];

get_ac_by_lv(65,1) ->
[{300,1,0}];

get_ac_by_lv(95,2) ->
[{402,2,1}];

get_ac_by_lv(95,1) ->
[{610,5,0}];

get_ac_by_lv(240,1) ->
[{460,4,0}];

get_ac_by_lv(78,1) ->
[{460,12,0}];

get_ac_by_lv(320,1) ->
[{470,1,0}];

get_ac_by_lv(360,1) ->
[{471,0,0}];

get_ac_by_lv(125,2) ->
[{506,0,1},{506,0,2}];

get_ac_by_lv(140,1) ->
[{610,10,0}];

get_ac_by_lv(170,1) ->
[{610,13,0}];

get_ac_by_lv(70,1) ->
[{610,20,0}];

get_ac_by_lv(290,1) ->
[{610,32,0}];

get_ac_by_lv(_Startlv,_Actype) ->
	[].


get_start_lv_list(1) ->
[50,100,200,110,160,65,130,240,78,400,320,360,95,140,170,70,290];


get_start_lv_list(2) ->
[130,250,400,470,160,100,95,125];

get_start_lv_list(_Actype) ->
	[].

get_liveness(0) ->
	#base_liveness_lv{lv = 0,liveness = 10,attr = [{1,0},{2,0}]};

get_liveness(1) ->
	#base_liveness_lv{lv = 1,liveness = 12,attr = [{1,20},{2,400}]};

get_liveness(2) ->
	#base_liveness_lv{lv = 2,liveness = 14,attr = [{1,40},{2,800}]};

get_liveness(3) ->
	#base_liveness_lv{lv = 3,liveness = 16,attr = [{1,60},{2,1200}]};

get_liveness(4) ->
	#base_liveness_lv{lv = 4,liveness = 18,attr = [{1,80},{2,1600}]};

get_liveness(5) ->
	#base_liveness_lv{lv = 5,liveness = 20,attr = [{1,100},{2,2000}]};

get_liveness(6) ->
	#base_liveness_lv{lv = 6,liveness = 22,attr = [{1,120},{2,2400}]};

get_liveness(7) ->
	#base_liveness_lv{lv = 7,liveness = 24,attr = [{1,140},{2,2800}]};

get_liveness(8) ->
	#base_liveness_lv{lv = 8,liveness = 26,attr = [{1,160},{2,3200}]};

get_liveness(9) ->
	#base_liveness_lv{lv = 9,liveness = 28,attr = [{1,180},{2,3600}]};

get_liveness(10) ->
	#base_liveness_lv{lv = 10,liveness = 30,attr = [{1,200},{2,4000}]};

get_liveness(11) ->
	#base_liveness_lv{lv = 11,liveness = 32,attr = [{1,220},{2,4400}]};

get_liveness(12) ->
	#base_liveness_lv{lv = 12,liveness = 34,attr = [{1,240},{2,4800}]};

get_liveness(13) ->
	#base_liveness_lv{lv = 13,liveness = 36,attr = [{1,260},{2,5200}]};

get_liveness(14) ->
	#base_liveness_lv{lv = 14,liveness = 38,attr = [{1,280},{2,5600}]};

get_liveness(15) ->
	#base_liveness_lv{lv = 15,liveness = 40,attr = [{1,300},{2,6000}]};

get_liveness(16) ->
	#base_liveness_lv{lv = 16,liveness = 42,attr = [{1,320},{2,6400}]};

get_liveness(17) ->
	#base_liveness_lv{lv = 17,liveness = 44,attr = [{1,340},{2,6800}]};

get_liveness(18) ->
	#base_liveness_lv{lv = 18,liveness = 46,attr = [{1,360},{2,7200}]};

get_liveness(19) ->
	#base_liveness_lv{lv = 19,liveness = 48,attr = [{1,380},{2,7600}]};

get_liveness(20) ->
	#base_liveness_lv{lv = 20,liveness = 50,attr = [{1,400},{2,8000}]};

get_liveness(21) ->
	#base_liveness_lv{lv = 21,liveness = 52,attr = [{1,420},{2,8400}]};

get_liveness(22) ->
	#base_liveness_lv{lv = 22,liveness = 54,attr = [{1,440},{2,8800}]};

get_liveness(23) ->
	#base_liveness_lv{lv = 23,liveness = 56,attr = [{1,460},{2,9200}]};

get_liveness(24) ->
	#base_liveness_lv{lv = 24,liveness = 58,attr = [{1,480},{2,9600}]};

get_liveness(25) ->
	#base_liveness_lv{lv = 25,liveness = 60,attr = [{1,500},{2,10000}]};

get_liveness(26) ->
	#base_liveness_lv{lv = 26,liveness = 62,attr = [{1,520},{2,10400}]};

get_liveness(27) ->
	#base_liveness_lv{lv = 27,liveness = 64,attr = [{1,540},{2,10800}]};

get_liveness(28) ->
	#base_liveness_lv{lv = 28,liveness = 66,attr = [{1,560},{2,11200}]};

get_liveness(29) ->
	#base_liveness_lv{lv = 29,liveness = 68,attr = [{1,580},{2,11600}]};

get_liveness(30) ->
	#base_liveness_lv{lv = 30,liveness = 70,attr = [{1,600},{2,12000}]};

get_liveness(31) ->
	#base_liveness_lv{lv = 31,liveness = 72,attr = [{1,620},{2,12400}]};

get_liveness(32) ->
	#base_liveness_lv{lv = 32,liveness = 74,attr = [{1,640},{2,12800}]};

get_liveness(33) ->
	#base_liveness_lv{lv = 33,liveness = 76,attr = [{1,660},{2,13200}]};

get_liveness(34) ->
	#base_liveness_lv{lv = 34,liveness = 78,attr = [{1,680},{2,13600}]};

get_liveness(35) ->
	#base_liveness_lv{lv = 35,liveness = 80,attr = [{1,700},{2,14000}]};

get_liveness(36) ->
	#base_liveness_lv{lv = 36,liveness = 82,attr = [{1,720},{2,14400}]};

get_liveness(37) ->
	#base_liveness_lv{lv = 37,liveness = 84,attr = [{1,740},{2,14800}]};

get_liveness(38) ->
	#base_liveness_lv{lv = 38,liveness = 86,attr = [{1,760},{2,15200}]};

get_liveness(39) ->
	#base_liveness_lv{lv = 39,liveness = 88,attr = [{1,780},{2,15600}]};

get_liveness(40) ->
	#base_liveness_lv{lv = 40,liveness = 90,attr = [{1,800},{2,16000}]};

get_liveness(41) ->
	#base_liveness_lv{lv = 41,liveness = 92,attr = [{1,820},{2,16400}]};

get_liveness(42) ->
	#base_liveness_lv{lv = 42,liveness = 94,attr = [{1,840},{2,16800}]};

get_liveness(43) ->
	#base_liveness_lv{lv = 43,liveness = 96,attr = [{1,860},{2,17200}]};

get_liveness(44) ->
	#base_liveness_lv{lv = 44,liveness = 98,attr = [{1,880},{2,17600}]};

get_liveness(45) ->
	#base_liveness_lv{lv = 45,liveness = 100,attr = [{1,900},{2,18000}]};

get_liveness(46) ->
	#base_liveness_lv{lv = 46,liveness = 102,attr = [{1,920},{2,18400}]};

get_liveness(47) ->
	#base_liveness_lv{lv = 47,liveness = 104,attr = [{1,940},{2,18800}]};

get_liveness(48) ->
	#base_liveness_lv{lv = 48,liveness = 106,attr = [{1,960},{2,19200}]};

get_liveness(49) ->
	#base_liveness_lv{lv = 49,liveness = 108,attr = [{1,980},{2,19600}]};

get_liveness(50) ->
	#base_liveness_lv{lv = 50,liveness = 110,attr = [{1,1000},{2,20000}]};

get_liveness(51) ->
	#base_liveness_lv{lv = 51,liveness = 112,attr = [{1,1020},{2,20400}]};

get_liveness(52) ->
	#base_liveness_lv{lv = 52,liveness = 114,attr = [{1,1040},{2,20800}]};

get_liveness(53) ->
	#base_liveness_lv{lv = 53,liveness = 116,attr = [{1,1060},{2,21200}]};

get_liveness(54) ->
	#base_liveness_lv{lv = 54,liveness = 118,attr = [{1,1080},{2,21600}]};

get_liveness(55) ->
	#base_liveness_lv{lv = 55,liveness = 120,attr = [{1,1100},{2,22000}]};

get_liveness(56) ->
	#base_liveness_lv{lv = 56,liveness = 122,attr = [{1,1120},{2,22400}]};

get_liveness(57) ->
	#base_liveness_lv{lv = 57,liveness = 124,attr = [{1,1140},{2,22800}]};

get_liveness(58) ->
	#base_liveness_lv{lv = 58,liveness = 126,attr = [{1,1160},{2,23200}]};

get_liveness(59) ->
	#base_liveness_lv{lv = 59,liveness = 128,attr = [{1,1180},{2,23600}]};

get_liveness(60) ->
	#base_liveness_lv{lv = 60,liveness = 130,attr = [{1,1200},{2,24000}]};

get_liveness(61) ->
	#base_liveness_lv{lv = 61,liveness = 132,attr = [{1,1220},{2,24400}]};

get_liveness(62) ->
	#base_liveness_lv{lv = 62,liveness = 134,attr = [{1,1240},{2,24800}]};

get_liveness(63) ->
	#base_liveness_lv{lv = 63,liveness = 136,attr = [{1,1260},{2,25200}]};

get_liveness(64) ->
	#base_liveness_lv{lv = 64,liveness = 138,attr = [{1,1280},{2,25600}]};

get_liveness(65) ->
	#base_liveness_lv{lv = 65,liveness = 140,attr = [{1,1300},{2,26000}]};

get_liveness(66) ->
	#base_liveness_lv{lv = 66,liveness = 142,attr = [{1,1320},{2,26400}]};

get_liveness(67) ->
	#base_liveness_lv{lv = 67,liveness = 144,attr = [{1,1340},{2,26800}]};

get_liveness(68) ->
	#base_liveness_lv{lv = 68,liveness = 146,attr = [{1,1360},{2,27200}]};

get_liveness(69) ->
	#base_liveness_lv{lv = 69,liveness = 148,attr = [{1,1380},{2,27600}]};

get_liveness(70) ->
	#base_liveness_lv{lv = 70,liveness = 150,attr = [{1,1400},{2,28000}]};

get_liveness(71) ->
	#base_liveness_lv{lv = 71,liveness = 152,attr = [{1,1420},{2,28400}]};

get_liveness(72) ->
	#base_liveness_lv{lv = 72,liveness = 154,attr = [{1,1440},{2,28800}]};

get_liveness(73) ->
	#base_liveness_lv{lv = 73,liveness = 156,attr = [{1,1460},{2,29200}]};

get_liveness(74) ->
	#base_liveness_lv{lv = 74,liveness = 158,attr = [{1,1480},{2,29600}]};

get_liveness(75) ->
	#base_liveness_lv{lv = 75,liveness = 160,attr = [{1,1500},{2,30000}]};

get_liveness(76) ->
	#base_liveness_lv{lv = 76,liveness = 162,attr = [{1,1520},{2,30400}]};

get_liveness(77) ->
	#base_liveness_lv{lv = 77,liveness = 164,attr = [{1,1540},{2,30800}]};

get_liveness(78) ->
	#base_liveness_lv{lv = 78,liveness = 166,attr = [{1,1560},{2,31200}]};

get_liveness(79) ->
	#base_liveness_lv{lv = 79,liveness = 168,attr = [{1,1580},{2,31600}]};

get_liveness(80) ->
	#base_liveness_lv{lv = 80,liveness = 170,attr = [{1,1600},{2,32000}]};

get_liveness(81) ->
	#base_liveness_lv{lv = 81,liveness = 172,attr = [{1,1620},{2,32400}]};

get_liveness(82) ->
	#base_liveness_lv{lv = 82,liveness = 174,attr = [{1,1640},{2,32800}]};

get_liveness(83) ->
	#base_liveness_lv{lv = 83,liveness = 176,attr = [{1,1660},{2,33200}]};

get_liveness(84) ->
	#base_liveness_lv{lv = 84,liveness = 178,attr = [{1,1680},{2,33600}]};

get_liveness(85) ->
	#base_liveness_lv{lv = 85,liveness = 180,attr = [{1,1700},{2,34000}]};

get_liveness(86) ->
	#base_liveness_lv{lv = 86,liveness = 182,attr = [{1,1720},{2,34400}]};

get_liveness(87) ->
	#base_liveness_lv{lv = 87,liveness = 184,attr = [{1,1740},{2,34800}]};

get_liveness(88) ->
	#base_liveness_lv{lv = 88,liveness = 186,attr = [{1,1760},{2,35200}]};

get_liveness(89) ->
	#base_liveness_lv{lv = 89,liveness = 188,attr = [{1,1780},{2,35600}]};

get_liveness(90) ->
	#base_liveness_lv{lv = 90,liveness = 190,attr = [{1,1800},{2,36000}]};

get_liveness(91) ->
	#base_liveness_lv{lv = 91,liveness = 192,attr = [{1,1820},{2,36400}]};

get_liveness(92) ->
	#base_liveness_lv{lv = 92,liveness = 194,attr = [{1,1840},{2,36800}]};

get_liveness(93) ->
	#base_liveness_lv{lv = 93,liveness = 196,attr = [{1,1860},{2,37200}]};

get_liveness(94) ->
	#base_liveness_lv{lv = 94,liveness = 198,attr = [{1,1880},{2,37600}]};

get_liveness(95) ->
	#base_liveness_lv{lv = 95,liveness = 200,attr = [{1,1900},{2,38000}]};

get_liveness(96) ->
	#base_liveness_lv{lv = 96,liveness = 202,attr = [{1,1920},{2,38400}]};

get_liveness(97) ->
	#base_liveness_lv{lv = 97,liveness = 204,attr = [{1,1940},{2,38800}]};

get_liveness(98) ->
	#base_liveness_lv{lv = 98,liveness = 206,attr = [{1,1960},{2,39200}]};

get_liveness(99) ->
	#base_liveness_lv{lv = 99,liveness = 208,attr = [{1,1980},{2,39600}]};

get_liveness(100) ->
	#base_liveness_lv{lv = 100,liveness = 210,attr = [{1,2000},{2,40000}]};

get_liveness(101) ->
	#base_liveness_lv{lv = 101,liveness = 212,attr = [{1,2020},{2,40400}]};

get_liveness(102) ->
	#base_liveness_lv{lv = 102,liveness = 214,attr = [{1,2040},{2,40800}]};

get_liveness(103) ->
	#base_liveness_lv{lv = 103,liveness = 216,attr = [{1,2060},{2,41200}]};

get_liveness(104) ->
	#base_liveness_lv{lv = 104,liveness = 218,attr = [{1,2080},{2,41600}]};

get_liveness(105) ->
	#base_liveness_lv{lv = 105,liveness = 220,attr = [{1,2100},{2,42000}]};

get_liveness(106) ->
	#base_liveness_lv{lv = 106,liveness = 222,attr = [{1,2120},{2,42400}]};

get_liveness(107) ->
	#base_liveness_lv{lv = 107,liveness = 224,attr = [{1,2140},{2,42800}]};

get_liveness(108) ->
	#base_liveness_lv{lv = 108,liveness = 226,attr = [{1,2160},{2,43200}]};

get_liveness(109) ->
	#base_liveness_lv{lv = 109,liveness = 228,attr = [{1,2180},{2,43600}]};

get_liveness(110) ->
	#base_liveness_lv{lv = 110,liveness = 230,attr = [{1,2200},{2,44000}]};

get_liveness(111) ->
	#base_liveness_lv{lv = 111,liveness = 232,attr = [{1,2220},{2,44400}]};

get_liveness(112) ->
	#base_liveness_lv{lv = 112,liveness = 234,attr = [{1,2240},{2,44800}]};

get_liveness(113) ->
	#base_liveness_lv{lv = 113,liveness = 236,attr = [{1,2260},{2,45200}]};

get_liveness(114) ->
	#base_liveness_lv{lv = 114,liveness = 238,attr = [{1,2280},{2,45600}]};

get_liveness(115) ->
	#base_liveness_lv{lv = 115,liveness = 240,attr = [{1,2300},{2,46000}]};

get_liveness(116) ->
	#base_liveness_lv{lv = 116,liveness = 242,attr = [{1,2320},{2,46400}]};

get_liveness(117) ->
	#base_liveness_lv{lv = 117,liveness = 244,attr = [{1,2340},{2,46800}]};

get_liveness(118) ->
	#base_liveness_lv{lv = 118,liveness = 246,attr = [{1,2360},{2,47200}]};

get_liveness(119) ->
	#base_liveness_lv{lv = 119,liveness = 248,attr = [{1,2380},{2,47600}]};

get_liveness(120) ->
	#base_liveness_lv{lv = 120,liveness = 250,attr = [{1,2400},{2,48000}]};

get_liveness(121) ->
	#base_liveness_lv{lv = 121,liveness = 252,attr = [{1,2420},{2,48400}]};

get_liveness(122) ->
	#base_liveness_lv{lv = 122,liveness = 254,attr = [{1,2440},{2,48800}]};

get_liveness(123) ->
	#base_liveness_lv{lv = 123,liveness = 256,attr = [{1,2460},{2,49200}]};

get_liveness(124) ->
	#base_liveness_lv{lv = 124,liveness = 258,attr = [{1,2480},{2,49600}]};

get_liveness(125) ->
	#base_liveness_lv{lv = 125,liveness = 260,attr = [{1,2500},{2,50000}]};

get_liveness(126) ->
	#base_liveness_lv{lv = 126,liveness = 262,attr = [{1,2520},{2,50400}]};

get_liveness(127) ->
	#base_liveness_lv{lv = 127,liveness = 264,attr = [{1,2540},{2,50800}]};

get_liveness(128) ->
	#base_liveness_lv{lv = 128,liveness = 266,attr = [{1,2560},{2,51200}]};

get_liveness(129) ->
	#base_liveness_lv{lv = 129,liveness = 268,attr = [{1,2580},{2,51600}]};

get_liveness(130) ->
	#base_liveness_lv{lv = 130,liveness = 270,attr = [{1,2600},{2,52000}]};

get_liveness(131) ->
	#base_liveness_lv{lv = 131,liveness = 272,attr = [{1,2620},{2,52400}]};

get_liveness(132) ->
	#base_liveness_lv{lv = 132,liveness = 274,attr = [{1,2640},{2,52800}]};

get_liveness(133) ->
	#base_liveness_lv{lv = 133,liveness = 276,attr = [{1,2660},{2,53200}]};

get_liveness(134) ->
	#base_liveness_lv{lv = 134,liveness = 278,attr = [{1,2680},{2,53600}]};

get_liveness(135) ->
	#base_liveness_lv{lv = 135,liveness = 280,attr = [{1,2700},{2,54000}]};

get_liveness(136) ->
	#base_liveness_lv{lv = 136,liveness = 282,attr = [{1,2720},{2,54400}]};

get_liveness(137) ->
	#base_liveness_lv{lv = 137,liveness = 284,attr = [{1,2740},{2,54800}]};

get_liveness(138) ->
	#base_liveness_lv{lv = 138,liveness = 286,attr = [{1,2760},{2,55200}]};

get_liveness(139) ->
	#base_liveness_lv{lv = 139,liveness = 288,attr = [{1,2780},{2,55600}]};

get_liveness(140) ->
	#base_liveness_lv{lv = 140,liveness = 290,attr = [{1,2800},{2,56000}]};

get_liveness(141) ->
	#base_liveness_lv{lv = 141,liveness = 292,attr = [{1,2820},{2,56400}]};

get_liveness(142) ->
	#base_liveness_lv{lv = 142,liveness = 294,attr = [{1,2840},{2,56800}]};

get_liveness(143) ->
	#base_liveness_lv{lv = 143,liveness = 296,attr = [{1,2860},{2,57200}]};

get_liveness(144) ->
	#base_liveness_lv{lv = 144,liveness = 298,attr = [{1,2880},{2,57600}]};

get_liveness(145) ->
	#base_liveness_lv{lv = 145,liveness = 300,attr = [{1,2900},{2,58000}]};

get_liveness(146) ->
	#base_liveness_lv{lv = 146,liveness = 302,attr = [{1,2920},{2,58400}]};

get_liveness(147) ->
	#base_liveness_lv{lv = 147,liveness = 304,attr = [{1,2940},{2,58800}]};

get_liveness(148) ->
	#base_liveness_lv{lv = 148,liveness = 306,attr = [{1,2960},{2,59200}]};

get_liveness(149) ->
	#base_liveness_lv{lv = 149,liveness = 308,attr = [{1,2980},{2,59600}]};

get_liveness(150) ->
	#base_liveness_lv{lv = 150,liveness = 310,attr = [{1,3000},{2,60000}]};

get_liveness(151) ->
	#base_liveness_lv{lv = 151,liveness = 312,attr = [{1,3020},{2,60400}]};

get_liveness(152) ->
	#base_liveness_lv{lv = 152,liveness = 314,attr = [{1,3040},{2,60800}]};

get_liveness(153) ->
	#base_liveness_lv{lv = 153,liveness = 316,attr = [{1,3060},{2,61200}]};

get_liveness(154) ->
	#base_liveness_lv{lv = 154,liveness = 318,attr = [{1,3080},{2,61600}]};

get_liveness(155) ->
	#base_liveness_lv{lv = 155,liveness = 320,attr = [{1,3100},{2,62000}]};

get_liveness(156) ->
	#base_liveness_lv{lv = 156,liveness = 322,attr = [{1,3120},{2,62400}]};

get_liveness(157) ->
	#base_liveness_lv{lv = 157,liveness = 324,attr = [{1,3140},{2,62800}]};

get_liveness(158) ->
	#base_liveness_lv{lv = 158,liveness = 326,attr = [{1,3160},{2,63200}]};

get_liveness(159) ->
	#base_liveness_lv{lv = 159,liveness = 328,attr = [{1,3180},{2,63600}]};

get_liveness(160) ->
	#base_liveness_lv{lv = 160,liveness = 330,attr = [{1,3200},{2,64000}]};

get_liveness(161) ->
	#base_liveness_lv{lv = 161,liveness = 332,attr = [{1,3220},{2,64400}]};

get_liveness(162) ->
	#base_liveness_lv{lv = 162,liveness = 334,attr = [{1,3240},{2,64800}]};

get_liveness(163) ->
	#base_liveness_lv{lv = 163,liveness = 336,attr = [{1,3260},{2,65200}]};

get_liveness(164) ->
	#base_liveness_lv{lv = 164,liveness = 338,attr = [{1,3280},{2,65600}]};

get_liveness(165) ->
	#base_liveness_lv{lv = 165,liveness = 340,attr = [{1,3300},{2,66000}]};

get_liveness(166) ->
	#base_liveness_lv{lv = 166,liveness = 342,attr = [{1,3320},{2,66400}]};

get_liveness(167) ->
	#base_liveness_lv{lv = 167,liveness = 344,attr = [{1,3340},{2,66800}]};

get_liveness(168) ->
	#base_liveness_lv{lv = 168,liveness = 346,attr = [{1,3360},{2,67200}]};

get_liveness(169) ->
	#base_liveness_lv{lv = 169,liveness = 348,attr = [{1,3380},{2,67600}]};

get_liveness(170) ->
	#base_liveness_lv{lv = 170,liveness = 350,attr = [{1,3400},{2,68000}]};

get_liveness(171) ->
	#base_liveness_lv{lv = 171,liveness = 352,attr = [{1,3420},{2,68400}]};

get_liveness(172) ->
	#base_liveness_lv{lv = 172,liveness = 354,attr = [{1,3440},{2,68800}]};

get_liveness(173) ->
	#base_liveness_lv{lv = 173,liveness = 356,attr = [{1,3460},{2,69200}]};

get_liveness(174) ->
	#base_liveness_lv{lv = 174,liveness = 358,attr = [{1,3480},{2,69600}]};

get_liveness(175) ->
	#base_liveness_lv{lv = 175,liveness = 360,attr = [{1,3500},{2,70000}]};

get_liveness(176) ->
	#base_liveness_lv{lv = 176,liveness = 362,attr = [{1,3520},{2,70400}]};

get_liveness(177) ->
	#base_liveness_lv{lv = 177,liveness = 364,attr = [{1,3540},{2,70800}]};

get_liveness(178) ->
	#base_liveness_lv{lv = 178,liveness = 366,attr = [{1,3560},{2,71200}]};

get_liveness(179) ->
	#base_liveness_lv{lv = 179,liveness = 368,attr = [{1,3580},{2,71600}]};

get_liveness(180) ->
	#base_liveness_lv{lv = 180,liveness = 370,attr = [{1,3600},{2,72000}]};

get_liveness(181) ->
	#base_liveness_lv{lv = 181,liveness = 372,attr = [{1,3620},{2,72400}]};

get_liveness(182) ->
	#base_liveness_lv{lv = 182,liveness = 374,attr = [{1,3640},{2,72800}]};

get_liveness(183) ->
	#base_liveness_lv{lv = 183,liveness = 376,attr = [{1,3660},{2,73200}]};

get_liveness(184) ->
	#base_liveness_lv{lv = 184,liveness = 378,attr = [{1,3680},{2,73600}]};

get_liveness(185) ->
	#base_liveness_lv{lv = 185,liveness = 380,attr = [{1,3700},{2,74000}]};

get_liveness(186) ->
	#base_liveness_lv{lv = 186,liveness = 382,attr = [{1,3720},{2,74400}]};

get_liveness(187) ->
	#base_liveness_lv{lv = 187,liveness = 384,attr = [{1,3740},{2,74800}]};

get_liveness(188) ->
	#base_liveness_lv{lv = 188,liveness = 386,attr = [{1,3760},{2,75200}]};

get_liveness(189) ->
	#base_liveness_lv{lv = 189,liveness = 388,attr = [{1,3780},{2,75600}]};

get_liveness(190) ->
	#base_liveness_lv{lv = 190,liveness = 390,attr = [{1,3800},{2,76000}]};

get_liveness(191) ->
	#base_liveness_lv{lv = 191,liveness = 392,attr = [{1,3820},{2,76400}]};

get_liveness(192) ->
	#base_liveness_lv{lv = 192,liveness = 394,attr = [{1,3840},{2,76800}]};

get_liveness(193) ->
	#base_liveness_lv{lv = 193,liveness = 396,attr = [{1,3860},{2,77200}]};

get_liveness(194) ->
	#base_liveness_lv{lv = 194,liveness = 398,attr = [{1,3880},{2,77600}]};

get_liveness(195) ->
	#base_liveness_lv{lv = 195,liveness = 400,attr = [{1,3900},{2,78000}]};

get_liveness(196) ->
	#base_liveness_lv{lv = 196,liveness = 402,attr = [{1,3920},{2,78400}]};

get_liveness(197) ->
	#base_liveness_lv{lv = 197,liveness = 404,attr = [{1,3940},{2,78800}]};

get_liveness(198) ->
	#base_liveness_lv{lv = 198,liveness = 406,attr = [{1,3960},{2,79200}]};

get_liveness(199) ->
	#base_liveness_lv{lv = 199,liveness = 408,attr = [{1,3980},{2,79600}]};

get_liveness(200) ->
	#base_liveness_lv{lv = 200,liveness = 410,attr = [{1,4000},{2,80000}]};

get_liveness(201) ->
	#base_liveness_lv{lv = 201,liveness = 412,attr = [{1,4020},{2,80400}]};

get_liveness(202) ->
	#base_liveness_lv{lv = 202,liveness = 414,attr = [{1,4040},{2,80800}]};

get_liveness(203) ->
	#base_liveness_lv{lv = 203,liveness = 416,attr = [{1,4060},{2,81200}]};

get_liveness(204) ->
	#base_liveness_lv{lv = 204,liveness = 418,attr = [{1,4080},{2,81600}]};

get_liveness(205) ->
	#base_liveness_lv{lv = 205,liveness = 420,attr = [{1,4100},{2,82000}]};

get_liveness(206) ->
	#base_liveness_lv{lv = 206,liveness = 422,attr = [{1,4120},{2,82400}]};

get_liveness(207) ->
	#base_liveness_lv{lv = 207,liveness = 424,attr = [{1,4140},{2,82800}]};

get_liveness(208) ->
	#base_liveness_lv{lv = 208,liveness = 426,attr = [{1,4160},{2,83200}]};

get_liveness(209) ->
	#base_liveness_lv{lv = 209,liveness = 428,attr = [{1,4180},{2,83600}]};

get_liveness(210) ->
	#base_liveness_lv{lv = 210,liveness = 430,attr = [{1,4200},{2,84000}]};

get_liveness(211) ->
	#base_liveness_lv{lv = 211,liveness = 432,attr = [{1,4220},{2,84400}]};

get_liveness(212) ->
	#base_liveness_lv{lv = 212,liveness = 434,attr = [{1,4240},{2,84800}]};

get_liveness(213) ->
	#base_liveness_lv{lv = 213,liveness = 436,attr = [{1,4260},{2,85200}]};

get_liveness(214) ->
	#base_liveness_lv{lv = 214,liveness = 438,attr = [{1,4280},{2,85600}]};

get_liveness(215) ->
	#base_liveness_lv{lv = 215,liveness = 440,attr = [{1,4300},{2,86000}]};

get_liveness(216) ->
	#base_liveness_lv{lv = 216,liveness = 442,attr = [{1,4320},{2,86400}]};

get_liveness(217) ->
	#base_liveness_lv{lv = 217,liveness = 444,attr = [{1,4340},{2,86800}]};

get_liveness(218) ->
	#base_liveness_lv{lv = 218,liveness = 446,attr = [{1,4360},{2,87200}]};

get_liveness(219) ->
	#base_liveness_lv{lv = 219,liveness = 448,attr = [{1,4380},{2,87600}]};

get_liveness(220) ->
	#base_liveness_lv{lv = 220,liveness = 450,attr = [{1,4400},{2,88000}]};

get_liveness(221) ->
	#base_liveness_lv{lv = 221,liveness = 452,attr = [{1,4420},{2,88400}]};

get_liveness(222) ->
	#base_liveness_lv{lv = 222,liveness = 454,attr = [{1,4440},{2,88800}]};

get_liveness(223) ->
	#base_liveness_lv{lv = 223,liveness = 456,attr = [{1,4460},{2,89200}]};

get_liveness(224) ->
	#base_liveness_lv{lv = 224,liveness = 458,attr = [{1,4480},{2,89600}]};

get_liveness(225) ->
	#base_liveness_lv{lv = 225,liveness = 460,attr = [{1,4500},{2,90000}]};

get_liveness(226) ->
	#base_liveness_lv{lv = 226,liveness = 462,attr = [{1,4520},{2,90400}]};

get_liveness(227) ->
	#base_liveness_lv{lv = 227,liveness = 464,attr = [{1,4540},{2,90800}]};

get_liveness(228) ->
	#base_liveness_lv{lv = 228,liveness = 466,attr = [{1,4560},{2,91200}]};

get_liveness(229) ->
	#base_liveness_lv{lv = 229,liveness = 468,attr = [{1,4580},{2,91600}]};

get_liveness(230) ->
	#base_liveness_lv{lv = 230,liveness = 470,attr = [{1,4600},{2,92000}]};

get_liveness(231) ->
	#base_liveness_lv{lv = 231,liveness = 472,attr = [{1,4620},{2,92400}]};

get_liveness(232) ->
	#base_liveness_lv{lv = 232,liveness = 474,attr = [{1,4640},{2,92800}]};

get_liveness(233) ->
	#base_liveness_lv{lv = 233,liveness = 476,attr = [{1,4660},{2,93200}]};

get_liveness(234) ->
	#base_liveness_lv{lv = 234,liveness = 478,attr = [{1,4680},{2,93600}]};

get_liveness(235) ->
	#base_liveness_lv{lv = 235,liveness = 480,attr = [{1,4700},{2,94000}]};

get_liveness(236) ->
	#base_liveness_lv{lv = 236,liveness = 482,attr = [{1,4720},{2,94400}]};

get_liveness(237) ->
	#base_liveness_lv{lv = 237,liveness = 484,attr = [{1,4740},{2,94800}]};

get_liveness(238) ->
	#base_liveness_lv{lv = 238,liveness = 486,attr = [{1,4760},{2,95200}]};

get_liveness(239) ->
	#base_liveness_lv{lv = 239,liveness = 488,attr = [{1,4780},{2,95600}]};

get_liveness(240) ->
	#base_liveness_lv{lv = 240,liveness = 490,attr = [{1,4800},{2,96000}]};

get_liveness(241) ->
	#base_liveness_lv{lv = 241,liveness = 492,attr = [{1,4820},{2,96400}]};

get_liveness(242) ->
	#base_liveness_lv{lv = 242,liveness = 494,attr = [{1,4840},{2,96800}]};

get_liveness(243) ->
	#base_liveness_lv{lv = 243,liveness = 496,attr = [{1,4860},{2,97200}]};

get_liveness(244) ->
	#base_liveness_lv{lv = 244,liveness = 498,attr = [{1,4880},{2,97600}]};

get_liveness(245) ->
	#base_liveness_lv{lv = 245,liveness = 500,attr = [{1,4900},{2,98000}]};

get_liveness(246) ->
	#base_liveness_lv{lv = 246,liveness = 502,attr = [{1,4920},{2,98400}]};

get_liveness(247) ->
	#base_liveness_lv{lv = 247,liveness = 504,attr = [{1,4940},{2,98800}]};

get_liveness(248) ->
	#base_liveness_lv{lv = 248,liveness = 506,attr = [{1,4960},{2,99200}]};

get_liveness(249) ->
	#base_liveness_lv{lv = 249,liveness = 508,attr = [{1,4980},{2,99600}]};

get_liveness(250) ->
	#base_liveness_lv{lv = 250,liveness = 510,attr = [{1,5000},{2,100000}]};

get_liveness(251) ->
	#base_liveness_lv{lv = 251,liveness = 512,attr = [{1,5020},{2,100400}]};

get_liveness(252) ->
	#base_liveness_lv{lv = 252,liveness = 514,attr = [{1,5040},{2,100800}]};

get_liveness(253) ->
	#base_liveness_lv{lv = 253,liveness = 516,attr = [{1,5060},{2,101200}]};

get_liveness(254) ->
	#base_liveness_lv{lv = 254,liveness = 518,attr = [{1,5080},{2,101600}]};

get_liveness(255) ->
	#base_liveness_lv{lv = 255,liveness = 520,attr = [{1,5100},{2,102000}]};

get_liveness(256) ->
	#base_liveness_lv{lv = 256,liveness = 522,attr = [{1,5120},{2,102400}]};

get_liveness(257) ->
	#base_liveness_lv{lv = 257,liveness = 524,attr = [{1,5140},{2,102800}]};

get_liveness(258) ->
	#base_liveness_lv{lv = 258,liveness = 526,attr = [{1,5160},{2,103200}]};

get_liveness(259) ->
	#base_liveness_lv{lv = 259,liveness = 528,attr = [{1,5180},{2,103600}]};

get_liveness(260) ->
	#base_liveness_lv{lv = 260,liveness = 530,attr = [{1,5200},{2,104000}]};

get_liveness(261) ->
	#base_liveness_lv{lv = 261,liveness = 532,attr = [{1,5220},{2,104400}]};

get_liveness(262) ->
	#base_liveness_lv{lv = 262,liveness = 534,attr = [{1,5240},{2,104800}]};

get_liveness(263) ->
	#base_liveness_lv{lv = 263,liveness = 536,attr = [{1,5260},{2,105200}]};

get_liveness(264) ->
	#base_liveness_lv{lv = 264,liveness = 538,attr = [{1,5280},{2,105600}]};

get_liveness(265) ->
	#base_liveness_lv{lv = 265,liveness = 540,attr = [{1,5300},{2,106000}]};

get_liveness(266) ->
	#base_liveness_lv{lv = 266,liveness = 542,attr = [{1,5320},{2,106400}]};

get_liveness(267) ->
	#base_liveness_lv{lv = 267,liveness = 544,attr = [{1,5340},{2,106800}]};

get_liveness(268) ->
	#base_liveness_lv{lv = 268,liveness = 546,attr = [{1,5360},{2,107200}]};

get_liveness(269) ->
	#base_liveness_lv{lv = 269,liveness = 548,attr = [{1,5380},{2,107600}]};

get_liveness(270) ->
	#base_liveness_lv{lv = 270,liveness = 550,attr = [{1,5400},{2,108000}]};

get_liveness(271) ->
	#base_liveness_lv{lv = 271,liveness = 552,attr = [{1,5420},{2,108400}]};

get_liveness(272) ->
	#base_liveness_lv{lv = 272,liveness = 554,attr = [{1,5440},{2,108800}]};

get_liveness(273) ->
	#base_liveness_lv{lv = 273,liveness = 556,attr = [{1,5460},{2,109200}]};

get_liveness(274) ->
	#base_liveness_lv{lv = 274,liveness = 558,attr = [{1,5480},{2,109600}]};

get_liveness(275) ->
	#base_liveness_lv{lv = 275,liveness = 560,attr = [{1,5500},{2,110000}]};

get_liveness(276) ->
	#base_liveness_lv{lv = 276,liveness = 562,attr = [{1,5520},{2,110400}]};

get_liveness(277) ->
	#base_liveness_lv{lv = 277,liveness = 564,attr = [{1,5540},{2,110800}]};

get_liveness(278) ->
	#base_liveness_lv{lv = 278,liveness = 566,attr = [{1,5560},{2,111200}]};

get_liveness(279) ->
	#base_liveness_lv{lv = 279,liveness = 568,attr = [{1,5580},{2,111600}]};

get_liveness(280) ->
	#base_liveness_lv{lv = 280,liveness = 570,attr = [{1,5600},{2,112000}]};

get_liveness(281) ->
	#base_liveness_lv{lv = 281,liveness = 572,attr = [{1,5620},{2,112400}]};

get_liveness(282) ->
	#base_liveness_lv{lv = 282,liveness = 574,attr = [{1,5640},{2,112800}]};

get_liveness(283) ->
	#base_liveness_lv{lv = 283,liveness = 576,attr = [{1,5660},{2,113200}]};

get_liveness(284) ->
	#base_liveness_lv{lv = 284,liveness = 578,attr = [{1,5680},{2,113600}]};

get_liveness(285) ->
	#base_liveness_lv{lv = 285,liveness = 580,attr = [{1,5700},{2,114000}]};

get_liveness(286) ->
	#base_liveness_lv{lv = 286,liveness = 582,attr = [{1,5720},{2,114400}]};

get_liveness(287) ->
	#base_liveness_lv{lv = 287,liveness = 584,attr = [{1,5740},{2,114800}]};

get_liveness(288) ->
	#base_liveness_lv{lv = 288,liveness = 586,attr = [{1,5760},{2,115200}]};

get_liveness(289) ->
	#base_liveness_lv{lv = 289,liveness = 588,attr = [{1,5780},{2,115600}]};

get_liveness(290) ->
	#base_liveness_lv{lv = 290,liveness = 590,attr = [{1,5800},{2,116000}]};

get_liveness(291) ->
	#base_liveness_lv{lv = 291,liveness = 592,attr = [{1,5820},{2,116400}]};

get_liveness(292) ->
	#base_liveness_lv{lv = 292,liveness = 594,attr = [{1,5840},{2,116800}]};

get_liveness(293) ->
	#base_liveness_lv{lv = 293,liveness = 596,attr = [{1,5860},{2,117200}]};

get_liveness(294) ->
	#base_liveness_lv{lv = 294,liveness = 598,attr = [{1,5880},{2,117600}]};

get_liveness(295) ->
	#base_liveness_lv{lv = 295,liveness = 600,attr = [{1,5900},{2,118000}]};

get_liveness(296) ->
	#base_liveness_lv{lv = 296,liveness = 602,attr = [{1,5920},{2,118400}]};

get_liveness(297) ->
	#base_liveness_lv{lv = 297,liveness = 604,attr = [{1,5940},{2,118800}]};

get_liveness(298) ->
	#base_liveness_lv{lv = 298,liveness = 606,attr = [{1,5960},{2,119200}]};

get_liveness(299) ->
	#base_liveness_lv{lv = 299,liveness = 608,attr = [{1,5980},{2,119600}]};

get_liveness(300) ->
	#base_liveness_lv{lv = 300,liveness = 0,attr = [{1,6000},{2,120000}]};

get_liveness(_Lv) ->
	[].

get_lv_list() ->
[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300].


get_value(1) ->
[{241301,1}];


get_value(2) ->
1000010;


get_value(3) ->
20;

get_value(_Key) ->
	0.

get_liveness_active(1) ->
	#base_liveness_active{id = 1,lv = 1,figure_id = 1};

get_liveness_active(2) ->
	#base_liveness_active{id = 2,lv = 34,figure_id = 2};

get_liveness_active(3) ->
	#base_liveness_active{id = 3,lv = 67,figure_id = 3};

get_liveness_active(4) ->
	#base_liveness_active{id = 4,lv = 100,figure_id = 4};

get_liveness_active(5) ->
	#base_liveness_active{id = 5,lv = 133,figure_id = 5};

get_liveness_active(6) ->
	#base_liveness_active{id = 6,lv = 166,figure_id = 6};

get_liveness_active(_Id) ->
	[].

get_active_ids() ->
[1,2,3,4,5,6].

get_active_lvs() ->
[1,34,67,100,133,166].

