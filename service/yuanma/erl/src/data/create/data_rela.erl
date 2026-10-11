%%%---------------------------------------
%%% module      : data_rela
%%% description : 好友上限配置
%%%
%%%---------------------------------------
-module(data_rela).
-compile(export_all).
-include("relationship.hrl").



get_intimacy_lv_cfg(1) ->
	#intimacy_lv_cfg{lv = 1,color = 0,name = "萍水相逢",intimacy = 0,attr = []};

get_intimacy_lv_cfg(2) ->
	#intimacy_lv_cfg{lv = 2,color = 1,name = "相见恨晚",intimacy = 99,attr = [{1,60},{2,1200}]};

get_intimacy_lv_cfg(3) ->
	#intimacy_lv_cfg{lv = 3,color = 1,name = "志同道合",intimacy = 450,attr = [{1,108},{2,2160}]};

get_intimacy_lv_cfg(4) ->
	#intimacy_lv_cfg{lv = 4,color = 2,name = "患难与共",intimacy = 900,attr = [{1,194},{2,3880}]};

get_intimacy_lv_cfg(5) ->
	#intimacy_lv_cfg{lv = 5,color = 2,name = "义结金兰",intimacy = 1800,attr = [{1,349},{2,6980}]};

get_intimacy_lv_cfg(6) ->
	#intimacy_lv_cfg{lv = 6,color = 2,name = "情深似海",intimacy = 3600,attr = [{1,628},{2,12560}]};

get_intimacy_lv_cfg(7) ->
	#intimacy_lv_cfg{lv = 7,color = 3,name = "肝胆相照",intimacy = 7200,attr = [{1,1130},{2,22600}]};

get_intimacy_lv_cfg(8) ->
	#intimacy_lv_cfg{lv = 8,color = 3,name = "亲密无间",intimacy = 14400,attr = [{1,2034},{2,40680}]};

get_intimacy_lv_cfg(9) ->
	#intimacy_lv_cfg{lv = 9,color = 3,name = "心有灵犀",intimacy = 28800,attr = [{1,3661},{2,73220}]};

get_intimacy_lv_cfg(10) ->
	#intimacy_lv_cfg{lv = 10,color = 4,name = "心心相印",intimacy = 57600,attr = [{1,6590},{2,131800}]};

get_intimacy_lv_cfg(11) ->
	#intimacy_lv_cfg{lv = 11,color = 4,name = "白首同归",intimacy = 115200,attr = [{1,11862},{2,237240}]};

get_intimacy_lv_cfg(_Lv) ->
	[].

get_intimacy_lv_cfg_ids() ->
[11,10,9,8,7,6,5,4,3,2,1].


get_rela_value(enermy_num_limit) ->
[100];

get_rela_value(_Key) ->
	[].

get_intimacy_obtain_cfg(1) ->
	#intimacy_obtain_cfg{type = 1,trigger_obj = [3101],intimacy = 5,times = 3};

get_intimacy_obtain_cfg(2) ->
	#intimacy_obtain_cfg{type = 2,trigger_obj = [{0,3}],intimacy = 5,times = 3};

get_intimacy_obtain_cfg(_Type) ->
	[].

