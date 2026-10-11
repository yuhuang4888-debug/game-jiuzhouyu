%%%---------------------------------------
%%% module      : data_robot_chat
%%% description : 假人聊天配置
%%%
%%%---------------------------------------
-module(data_robot_chat).
-compile(export_all).



get_type_list() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17].


get_type_cond(1) ->
[{lv,10}];


get_type_cond(2) ->
[{lv,20}];


get_type_cond(3) ->
[{lv,30},{open_day,1}];


get_type_cond(4) ->
[{lv,40}];


get_type_cond(5) ->
[{lv,55}];


get_type_cond(6) ->
[{lv,69}];


get_type_cond(7) ->
[{lv,84}];


get_type_cond(8) ->
[{lv,104}];


get_type_cond(9) ->
[{lv,120}];


get_type_cond(10) ->
[{lv,129}];


get_type_cond(11) ->
[{lv,140}];


get_type_cond(12) ->
[{lv,148}];


get_type_cond(13) ->
[{lv,173}];


get_type_cond(14) ->
[{lv,170}];


get_type_cond(15) ->
[{lv,180},{open_day,1}];


get_type_cond(16) ->
[{lv,180},{open_day,2}];


get_type_cond(17) ->
[{open_day,6}];

get_type_cond(_Type) ->
	[].

get_occupy_name_list() ->
[<<"小帅"/utf8>>,<<"美美"/utf8>>,<<"如月"/utf8>>,<<"神无月"/utf8>>,<<"高坂琴里"/utf8>>,<<"红果果"/utf8>>,<<"铃儿响叮当"/utf8>>,<<"今井京"/utf8>>,<<"莽就完了"/utf8>>,<<"爱随风"/utf8>>,<<"完美主义"/utf8>>,<<"奈奈"/utf8>>,<<"水中月"/utf8>>,<<"琉璃酱"/utf8>>,<<"傲视群雄"/utf8>>,<<"一梦千年"/utf8>>,<<"醉生梦死"/utf8>>,<<"巅峰王者"/utf8>>,<<"冰激凌"/utf8>>,<<"少时轻狂"/utf8>>,<<"明月"/utf8>>,<<"哎哟哟"/utf8>>,<<"梦醒时分"/utf8>>,<<"漆黑之眼"/utf8>>,<<"回忆"/utf8>>,<<"绘梨花"/utf8>>,<<"倾城之恋"/utf8>>,<<"李木子"/utf8>>,<<"绯色幼月"/utf8>>,<<"夏天"/utf8>>,<<"凛凛喵"/utf8>>,<<"独恋红尘"/utf8>>,<<"醉恋佳人"/utf8>>,<<"燕尾蝶"/utf8>>,<<"爱情相信眼泪"/utf8>>,<<"带头冲锋"/utf8>>,<<"牧濑酱"/utf8>>,<<"喵帕斯"/utf8>>,<<"子夜"/utf8>>,<<"传说"/utf8>>,<<"姑娘不哭"/utf8>>,<<"小傻瓜"/utf8>>,<<"尹若沫"/utf8>>,<<"夏欣"/utf8>>,<<"郑红竹"/utf8>>,<<"大和"/utf8>>,<<"可爱喵喵"/utf8>>,<<"小妞酱"/utf8>>,<<"小雨"/utf8>>,<<"真爱无敌"/utf8>>].

