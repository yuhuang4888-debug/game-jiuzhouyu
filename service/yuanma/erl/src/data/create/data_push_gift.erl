%%%---------------------------------------
%%% module      : data_push_gift
%%% description : 礼包推送配置
%%%
%%%---------------------------------------
-module(data_push_gift).
-compile(export_all).
-include("push_gift.hrl").



get_push_gift(1,1) ->
	#base_push_gift{gift_id = 1,sub_id = 1,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12036},{discount,3},{cost_now,[{1,0,168}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,2) ->
	#base_push_gift{gift_id = 1,sub_id = 2,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12044},{discount,2},{cost_now,[{1,0,268}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,3) ->
	#base_push_gift{gift_id = 1,sub_id = 3,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12052},{discount,2},{cost_now,[{1,0,138}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,4) ->
	#base_push_gift{gift_id = 1,sub_id = 4,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12060},{discount,2},{cost_now,[{1,0,138}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,5) ->
	#base_push_gift{gift_id = 1,sub_id = 5,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12068},{discount,3},{cost_now,[{1,0,328}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,6) ->
	#base_push_gift{gift_id = 1,sub_id = 6,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12076},{discount,4},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,7) ->
	#base_push_gift{gift_id = 1,sub_id = 7,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12084},{discount,4},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,8) ->
	#base_push_gift{gift_id = 1,sub_id = 8,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12092},{discount,4},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(1,9) ->
	#base_push_gift{gift_id = 1,sub_id = 9,title_name = <<"御魂礼包"/utf8>>,name = <<"御魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,dungeon_id,12100},{discount,4},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(2,1) ->
	#base_push_gift{gift_id = 2,sub_id = 1,title_name = <<"转生礼包"/utf8>>,name = <<"转生礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,turn,2},{discount,1},{cost_now,[{1,0,128}]}],clear_type = 0,grade_type = 2};

get_push_gift(2,2) ->
	#base_push_gift{gift_id = 2,sub_id = 2,title_name = <<"转生礼包"/utf8>>,name = <<"转生礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,turn,3},{discount,1},{cost_now,[{1,0,128}]}],clear_type = 0,grade_type = 2};

get_push_gift(2,3) ->
	#base_push_gift{gift_id = 2,sub_id = 3,title_name = <<"转生礼包"/utf8>>,name = <<"转生礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,turn,4},{discount,1},{cost_now,[{1,0,268}]}],clear_type = 0,grade_type = 2};

get_push_gift(3,1) ->
	#base_push_gift{gift_id = 3,sub_id = 1,title_name = <<"坐骑礼包"/utf8>>,name = <<"坐骑礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,mount_cnt,2},{discount,1},{cost_now,[{1,0,58}]}],clear_type = 0,grade_type = 2};

get_push_gift(4,1) ->
	#base_push_gift{gift_id = 4,sub_id = 1,title_name = <<"侍魂礼包"/utf8>>,name = <<"侍魂礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,mate_cnt,2},{discount,1},{cost_now,[{1,0,58}]}],clear_type = 0,grade_type = 2};

get_push_gift(5,1) ->
	#base_push_gift{gift_id = 5,sub_id = 1,title_name = <<"图谱礼包"/utf8>>,name = <<"图谱礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,mon_color_pic,{4,1}},{discount,2},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(5,2) ->
	#base_push_gift{gift_id = 5,sub_id = 2,title_name = <<"图谱礼包"/utf8>>,name = <<"图谱礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,mon_color_pic,{5,1}},{discount,2},{cost_now,[{1,0,188}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,1) ->
	#base_push_gift{gift_id = 6,sub_id = 1,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,2},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,2) ->
	#base_push_gift{gift_id = 6,sub_id = 2,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,4},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,3) ->
	#base_push_gift{gift_id = 6,sub_id = 3,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,6},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,4) ->
	#base_push_gift{gift_id = 6,sub_id = 4,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,8},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,5) ->
	#base_push_gift{gift_id = 6,sub_id = 5,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,10},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,6) ->
	#base_push_gift{gift_id = 6,sub_id = 6,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,12},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,7) ->
	#base_push_gift{gift_id = 6,sub_id = 7,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,14},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,8) ->
	#base_push_gift{gift_id = 6,sub_id = 8,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,16},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,9) ->
	#base_push_gift{gift_id = 6,sub_id = 9,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,18},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,10) ->
	#base_push_gift{gift_id = 6,sub_id = 10,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,20},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,11) ->
	#base_push_gift{gift_id = 6,sub_id = 11,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,22},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,12) ->
	#base_push_gift{gift_id = 6,sub_id = 12,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,24},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,13) ->
	#base_push_gift{gift_id = 6,sub_id = 13,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,26},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(6,14) ->
	#base_push_gift{gift_id = 6,sub_id = 14,title_name = <<"强者礼包"/utf8>>,name = <<"强者礼包"/utf8>>,duration = 10800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,wash_cnt,28},{discount,3},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,1) ->
	#base_push_gift{gift_id = 7,sub_id = 1,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{discount,3},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,2) ->
	#base_push_gift{gift_id = 7,sub_id = 2,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,2},{discount,1},{cost_now,[{1,0,28}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,3) ->
	#base_push_gift{gift_id = 7,sub_id = 3,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,2},{discount,2},{cost_now,[{1,0,168}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,4) ->
	#base_push_gift{gift_id = 7,sub_id = 4,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,2},{discount,2},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,5) ->
	#base_push_gift{gift_id = 7,sub_id = 5,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,2},{discount,2},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,6) ->
	#base_push_gift{gift_id = 7,sub_id = 6,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,2},{discount,2},{cost_now,[{1,0,208}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,7) ->
	#base_push_gift{gift_id = 7,sub_id = 7,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,3},{discount,1},{cost_now,[{1,0,18}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,8) ->
	#base_push_gift{gift_id = 7,sub_id = 8,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,3},{discount,2},{cost_now,[{1,0,68}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,9) ->
	#base_push_gift{gift_id = 7,sub_id = 9,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,3},{discount,2},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,10) ->
	#base_push_gift{gift_id = 7,sub_id = 10,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,3},{discount,2},{cost_now,[{1,0,128}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,11) ->
	#base_push_gift{gift_id = 7,sub_id = 11,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,3},{discount,2},{cost_now,[{1,0,208}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,12) ->
	#base_push_gift{gift_id = 7,sub_id = 12,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,4},{discount,1},{cost_now,[{1,0,48}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,13) ->
	#base_push_gift{gift_id = 7,sub_id = 13,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,4},{discount,3},{cost_now,[{1,0,168}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,14) ->
	#base_push_gift{gift_id = 7,sub_id = 14,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,4},{discount,3},{cost_now,[{1,0,388}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,15) ->
	#base_push_gift{gift_id = 7,sub_id = 15,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,4},{discount,3},{cost_now,[{1,0,208}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,16) ->
	#base_push_gift{gift_id = 7,sub_id = 16,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,4},{discount,3},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,17) ->
	#base_push_gift{gift_id = 7,sub_id = 17,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,5},{discount,3},{cost_now,[{1,0,88}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,18) ->
	#base_push_gift{gift_id = 7,sub_id = 18,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,5},{discount,2},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,19) ->
	#base_push_gift{gift_id = 7,sub_id = 19,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,5},{discount,2},{cost_now,[{1,0,128}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,20) ->
	#base_push_gift{gift_id = 7,sub_id = 20,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,5},{discount,3},{cost_now,[{1,0,218}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,21) ->
	#base_push_gift{gift_id = 7,sub_id = 21,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,5},{discount,3},{cost_now,[{1,0,288}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,22) ->
	#base_push_gift{gift_id = 7,sub_id = 22,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,6},{discount,1},{cost_now,[{1,0,48}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,23) ->
	#base_push_gift{gift_id = 7,sub_id = 23,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,6},{discount,2},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,24) ->
	#base_push_gift{gift_id = 7,sub_id = 24,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,6},{discount,2},{cost_now,[{1,0,288}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,25) ->
	#base_push_gift{gift_id = 7,sub_id = 25,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,6},{discount,3},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,26) ->
	#base_push_gift{gift_id = 7,sub_id = 26,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,6},{discount,3},{cost_now,[{1,0,388}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,27) ->
	#base_push_gift{gift_id = 7,sub_id = 27,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,0}]},{trigger,register_days,7},{discount,2},{cost_now,[{1,0,208}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,28) ->
	#base_push_gift{gift_id = 7,sub_id = 28,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,7},{discount,2},{cost_now,[{1,0,108}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,29) ->
	#base_push_gift{gift_id = 7,sub_id = 29,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,2}]},{trigger,register_days,7},{discount,3},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,30) ->
	#base_push_gift{gift_id = 7,sub_id = 30,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,7},{discount,3},{cost_now,[{1,0,368}]}],clear_type = 0,grade_type = 2};

get_push_gift(7,31) ->
	#base_push_gift{gift_id = 7,sub_id = 31,title_name = <<"特色礼包"/utf8>>,name = <<"特色礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger_limit,[{vip,5}]},{trigger,register_days,7},{discount,5},{cost_now,[{1,0,888}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,1) ->
	#base_push_gift{gift_id = 8,sub_id = 1,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,150},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,2) ->
	#base_push_gift{gift_id = 8,sub_id = 2,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,160},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,3) ->
	#base_push_gift{gift_id = 8,sub_id = 3,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,170},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,4) ->
	#base_push_gift{gift_id = 8,sub_id = 4,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,180},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,5) ->
	#base_push_gift{gift_id = 8,sub_id = 5,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,190},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,6) ->
	#base_push_gift{gift_id = 8,sub_id = 6,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,200},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,7) ->
	#base_push_gift{gift_id = 8,sub_id = 7,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,210},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,8) ->
	#base_push_gift{gift_id = 8,sub_id = 8,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,220},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,9) ->
	#base_push_gift{gift_id = 8,sub_id = 9,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,230},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,10) ->
	#base_push_gift{gift_id = 8,sub_id = 10,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,240},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,11) ->
	#base_push_gift{gift_id = 8,sub_id = 11,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,250},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,12) ->
	#base_push_gift{gift_id = 8,sub_id = 12,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,260},{discount,1},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,13) ->
	#base_push_gift{gift_id = 8,sub_id = 13,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,315},{trigger,register_days,5},{discount,2},{cost_now,[{1,0,288}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,14) ->
	#base_push_gift{gift_id = 8,sub_id = 14,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,335},{discount,3},{cost_now,[{1,0,328}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,15) ->
	#base_push_gift{gift_id = 8,sub_id = 15,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,350},{discount,3},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,16) ->
	#base_push_gift{gift_id = 8,sub_id = 16,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,355},{trigger,register_days,5},{discount,3},{cost_now,[{1,0,60}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,17) ->
	#base_push_gift{gift_id = 8,sub_id = 17,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,365},{discount,3},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,18) ->
	#base_push_gift{gift_id = 8,sub_id = 18,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,371},{discount,3},{cost_now,[{1,0,368}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,19) ->
	#base_push_gift{gift_id = 8,sub_id = 19,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,375},{trigger,register_days,8},{discount,4},{cost_now,[{1,0,1288}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,20) ->
	#base_push_gift{gift_id = 8,sub_id = 20,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,380},{discount,2},{cost_now,[{1,0,428}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,21) ->
	#base_push_gift{gift_id = 8,sub_id = 21,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,385},{trigger,register_days,8},{discount,4},{cost_now,[{1,0,128}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,22) ->
	#base_push_gift{gift_id = 8,sub_id = 22,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,390},{discount,2},{cost_now,[{1,0,888}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,23) ->
	#base_push_gift{gift_id = 8,sub_id = 23,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,400},{discount,3},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,24) ->
	#base_push_gift{gift_id = 8,sub_id = 24,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,410},{trigger,register_days,30},{discount,3},{cost_now,[{1,0,1288}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,25) ->
	#base_push_gift{gift_id = 8,sub_id = 25,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,420},{trigger,register_days,30},{discount,3},{cost_now,[{1,0,528}]}],clear_type = 0,grade_type = 2};

get_push_gift(8,26) ->
	#base_push_gift{gift_id = 8,sub_id = 26,title_name = <<"等级礼包"/utf8>>,name = <<"等级礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level ,430},{discount,3},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(9,1) ->
	#base_push_gift{gift_id = 9,sub_id = 1,title_name = <<"神巫激活"/utf8>>,name = <<"神巫激活"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id,4},{discount,2},{cost_now,[{1,0,198}]}],clear_type = 0,grade_type = 2};

get_push_gift(9,2) ->
	#base_push_gift{gift_id = 9,sub_id = 2,title_name = <<"神巫激活"/utf8>>,name = <<"神巫激活"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id,5},{discount,2},{cost_now,[{1,0,198}]}],clear_type = 0,grade_type = 2};

get_push_gift(9,3) ->
	#base_push_gift{gift_id = 9,sub_id = 3,title_name = <<"神巫激活"/utf8>>,name = <<"神巫激活"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id,10},{discount,2},{cost_now,[{1,0,328}]}],clear_type = 0,grade_type = 2};

get_push_gift(9,4) ->
	#base_push_gift{gift_id = 9,sub_id = 4,title_name = <<"神巫激活"/utf8>>,name = <<"神巫激活"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id,8},{discount,3},{cost_now,[{1,0,428}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,1) ->
	#base_push_gift{gift_id = 10,sub_id = 1,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{1,5}},{discount,2},{cost_now,[{1,0,688}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,2) ->
	#base_push_gift{gift_id = 10,sub_id = 2,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{2,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,3) ->
	#base_push_gift{gift_id = 10,sub_id = 3,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{3,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,4) ->
	#base_push_gift{gift_id = 10,sub_id = 4,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{4,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,5) ->
	#base_push_gift{gift_id = 10,sub_id = 5,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{5,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,6) ->
	#base_push_gift{gift_id = 10,sub_id = 6,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{10,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(10,7) ->
	#base_push_gift{gift_id = 10,sub_id = 7,title_name = <<"神巫升阶"/utf8>>,name = <<"神巫升阶"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,partner_id_stage,{8,5}},{discount,2},{cost_now,[{1,0,798}]}],clear_type = 0,grade_type = 2};

get_push_gift(11,2) ->
	#base_push_gift{gift_id = 11,sub_id = 2,title_name = <<"共鸣打造"/utf8>>,name = <<"共鸣打造"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,suit_cnt,{{2,1},5}},{discount,2},{cost_now,[{1,0,248}]}],clear_type = 0,grade_type = 2};

get_push_gift(11,3) ->
	#base_push_gift{gift_id = 11,sub_id = 3,title_name = <<"共鸣打造"/utf8>>,name = <<"共鸣打造"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,suit_cnt,{{2,2},3}},{discount,2},{cost_now,[{1,0,248}]}],clear_type = 0,grade_type = 2};

get_push_gift(11,4) ->
	#base_push_gift{gift_id = 11,sub_id = 4,title_name = <<"共鸣打造"/utf8>>,name = <<"共鸣打造"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,suit_cnt,{{2,2},5}},{discount,2},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(11,5) ->
	#base_push_gift{gift_id = 11,sub_id = 5,title_name = <<"共鸣打造"/utf8>>,name = <<"共鸣打造"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,suit_cnt,{{2,3},3}},{discount,2},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,1) ->
	#base_push_gift{gift_id = 12,sub_id = 1,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 30},{trigger_limit, [{bag_have, 38040019, 0, 1}]},{discount,4},{cost_now,[{1,0,228}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,2) ->
	#base_push_gift{gift_id = 12,sub_id = 2,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 50},{discount,4},{cost_now,[{1,0,248}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,3) ->
	#base_push_gift{gift_id = 12,sub_id = 3,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 70},{discount,4},{cost_now,[{1,0,368}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,4) ->
	#base_push_gift{gift_id = 12,sub_id = 4,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 100},{discount,4},{cost_now,[{1,0,388}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,5) ->
	#base_push_gift{gift_id = 12,sub_id = 5,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 130},{discount,4},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(12,6) ->
	#base_push_gift{gift_id = 12,sub_id = 6,title_name = <<"灵饰礼包"/utf8>>,name = <<"灵饰礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, decoration_level, 160},{discount,4},{cost_now,[{1,0,508}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,1) ->
	#base_push_gift{gift_id = 13,sub_id = 1,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,150},{discount,3},{cost_now,[{1,0,98}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,2) ->
	#base_push_gift{gift_id = 13,sub_id = 2,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger, medal_level, 19},{discount,3},{cost_now,[{1,0,308}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,3) ->
	#base_push_gift{gift_id = 13,sub_id = 3,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,310},{discount,3},{cost_now,[{1,0,308}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,4) ->
	#base_push_gift{gift_id = 13,sub_id = 4,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,340},{discount,3},{cost_now,[{1,0,388}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,5) ->
	#base_push_gift{gift_id = 13,sub_id = 5,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,370},{discount,3},{cost_now,[{1,0,488}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,6) ->
	#base_push_gift{gift_id = 13,sub_id = 6,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,400},{discount,3},{cost_now,[{1,0,588}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,7) ->
	#base_push_gift{gift_id = 13,sub_id = 7,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,430},{discount,3},{cost_now,[{1,0,728}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,8) ->
	#base_push_gift{gift_id = 13,sub_id = 8,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,460},{discount,3},{cost_now,[{1,0,728}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,9) ->
	#base_push_gift{gift_id = 13,sub_id = 9,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,490},{discount,3},{cost_now,[{1,0,888}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,10) ->
	#base_push_gift{gift_id = 13,sub_id = 10,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,520},{discount,3},{cost_now,[{1,0,888}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,11) ->
	#base_push_gift{gift_id = 13,sub_id = 11,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,550},{discount,3},{cost_now,[{1,0,1088}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,12) ->
	#base_push_gift{gift_id = 13,sub_id = 12,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,580},{discount,3},{cost_now,[{1,0,1288}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,13) ->
	#base_push_gift{gift_id = 13,sub_id = 13,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,610},{discount,3},{cost_now,[{1,0,1388}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,14) ->
	#base_push_gift{gift_id = 13,sub_id = 14,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,640},{discount,3},{cost_now,[{1,0,1588}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,15) ->
	#base_push_gift{gift_id = 13,sub_id = 15,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,670},{discount,3},{cost_now,[{1,0,1588}]}],clear_type = 0,grade_type = 2};

get_push_gift(13,16) ->
	#base_push_gift{gift_id = 13,sub_id = 16,title_name = <<"境界礼包"/utf8>>,name = <<"勋章礼包"/utf8>>,duration = 21600,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,level,700},{discount,3},{cost_now,[{1,0,1688}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,1) ->
	#base_push_gift{gift_id = 14,sub_id = 1,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,6},{discount,5},{cost_now,[{1,0,168}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,2) ->
	#base_push_gift{gift_id = 14,sub_id = 2,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 18000,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,7},{discount,5},{cost_now,[{1,0,168}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,3) ->
	#base_push_gift{gift_id = 14,sub_id = 3,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 28800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,9},{discount,5},{cost_now,[{1,0,600}]},{trigger_limit, [{equip_have, 39,4,2,0,2}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,4) ->
	#base_push_gift{gift_id = 14,sub_id = 4,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 28800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,9},{discount,4},{cost_now,[{1,0,480}]},{trigger_limit, [{equip_have, 39,4,2,3,999}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,5) ->
	#base_push_gift{gift_id = 14,sub_id = 5,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 28800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,10},{discount,5},{cost_now,[{1,0,600}]},{trigger_limit, [{equip_have, 39,4,2,0,3}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,6) ->
	#base_push_gift{gift_id = 14,sub_id = 6,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 28800,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,10},{discount,4},{cost_now,[{1,0,480}]},{trigger_limit, [{equip_have, 39,4,2,4,999}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,7) ->
	#base_push_gift{gift_id = 14,sub_id = 7,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,12},{discount,4},{cost_now,[{1,0,1388}]},{trigger_limit, [{equip_have, 39,5,2,0,2}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,8) ->
	#base_push_gift{gift_id = 14,sub_id = 8,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,12},{discount,4},{cost_now,[{1,0,1188}]},{trigger_limit, [{equip_have, 39,5,2,3,999}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,9) ->
	#base_push_gift{gift_id = 14,sub_id = 9,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,13},{discount,4},{cost_now,[{1,0,1188}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,10) ->
	#base_push_gift{gift_id = 14,sub_id = 10,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,14},{discount,4},{cost_now,[{1,0,1188}]}],clear_type = 0,grade_type = 2};

get_push_gift(14,11) ->
	#base_push_gift{gift_id = 14,sub_id = 11,title_name = <<"蜃妖礼包"/utf8>>,name = <<"蜃妖礼包"/utf8>>,duration = 43200,start_time = 1594224000,end_time = 1910793599,open_days = [{1,999}],merge_days = [],condition = [{trigger,eudemons_level,15},{discount,4},{cost_now,[{1,0,1188}]}],clear_type = 0,grade_type = 2};

get_push_gift(_Giftid,_Subid) ->
	[].

get_gift_list_all() ->
[{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{2,1},{2,2},{2,3},{3,1},{4,1},{5,1},{5,2},{6,1},{6,2},{6,3},{6,4},{6,5},{6,6},{6,7},{6,8},{6,9},{6,10},{6,11},{6,12},{6,13},{6,14},{7,1},{7,2},{7,3},{7,4},{7,5},{7,6},{7,7},{7,8},{7,9},{7,10},{7,11},{7,12},{7,13},{7,14},{7,15},{7,16},{7,17},{7,18},{7,19},{7,20},{7,21},{7,22},{7,23},{7,24},{7,25},{7,26},{7,27},{7,28},{7,29},{7,30},{7,31},{8,1},{8,2},{8,3},{8,4},{8,5},{8,6},{8,7},{8,8},{8,9},{8,10},{8,11},{8,12},{8,13},{8,14},{8,15},{8,16},{8,17},{8,18},{8,19},{8,20},{8,21},{8,22},{8,23},{8,24},{8,25},{8,26},{9,1},{9,2},{9,3},{9,4},{10,1},{10,2},{10,3},{10,4},{10,5},{10,6},{10,7},{11,2},{11,3},{11,4},{11,5},{12,1},{12,2},{12,3},{12,4},{12,5},{12,6},{13,1},{13,2},{13,3},{13,4},{13,5},{13,6},{13,7},{13,8},{13,9},{13,10},{13,11},{13,12},{13,13},{13,14},{13,15},{13,16},{14,1},{14,2},{14,3},{14,4},{14,5},{14,6},{14,7},{14,8},{14,9},{14,10},{14,11}].

get_push_gift_reward(1,1,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 1,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,568}]},{discount,3},{buy_cnt,1},{cost_now,[{1,0,168}]}],rewards = [{0,26990005,1},{0,26990005,1},{0,35,168}]};

get_push_gift_reward(1,2,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 2,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,1088}]},{discount,2.5},{buy_cnt,1},{cost_now,[{1,0,268}]}],rewards = [{0,26010002,1},{0,26990005,2},{0,35,128}]};

get_push_gift_reward(1,3,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 3,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,958}]},{discount,2},{buy_cnt,1},{cost_now,[{1,0,188}]}],rewards = [{0,26990005,1},{0,38040012,200},{0,35,138}]};

get_push_gift_reward(1,4,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 4,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,958}]},{discount,2},{buy_cnt,1},{cost_now,[{1,0,188}]}],rewards = [{0,26990005,1},{0,38040012,200},{0,35,138}]};

get_push_gift_reward(1,5,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 5,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,2188}]},{discount,2.9},{buy_cnt,1},{cost_now,[{1,0,638}]}],rewards = [{0,36255006,5},{0,26990005,2},{0,35,328}]};

get_push_gift_reward(1,6,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 6,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,4.1},{buy_cnt,1},{cost_now,[{1,0,688}]}],rewards = [{0,32010525,1},{0,38040012,200},{0,35,688}]};

get_push_gift_reward(1,7,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 7,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,4.1},{buy_cnt,1},{cost_now,[{1,0,688}]}],rewards = [{0,32010525,1},{0,38040012,200},{0,35,688}]};

get_push_gift_reward(1,8,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 8,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,4.1},{buy_cnt,1},{cost_now,[{1,0,688}]}],rewards = [{0,32010525,1},{0,38040012,200},{0,35,688}]};

get_push_gift_reward(1,9,1) ->
	#base_push_gift_reward{gift_id = 1,sub_id = 9,grade_id = 1,name = <<"御魂礼包"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,4.1},{buy_cnt,1},{cost_now,[{1,0,688}]}],rewards = [{0,32010525,1},{0,38040012,200},{0,35,688}]};

get_push_gift_reward(2,1,1) ->
	#base_push_gift_reward{gift_id = 2,sub_id = 1,grade_id = 1,name = <<"转生礼包"/utf8>>,condition = [{cost,[{1,0,1328}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,128}]}],rewards = [{0,32010442,2},{0,35,128}]};

get_push_gift_reward(2,2,1) ->
	#base_push_gift_reward{gift_id = 2,sub_id = 2,grade_id = 1,name = <<"转生礼包"/utf8>>,condition = [{cost,[{1,0,1328}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,128}]}],rewards = [{0,32010442,2},{0,35,128}]};

get_push_gift_reward(2,3,1) ->
	#base_push_gift_reward{gift_id = 2,sub_id = 3,grade_id = 1,name = <<"转生礼包"/utf8>>,condition = [{cost,[{1,0,2768}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,268}]}],rewards = [{0,34010345,25},{0,35,268}]};

get_push_gift_reward(3,1,1) ->
	#base_push_gift_reward{gift_id = 3,sub_id = 1,grade_id = 1,name = <<"坐骑礼包"/utf8>>,condition = [{cost,[{1,0,558}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,58}]}],rewards = [{0,16020002,10},{0,35,58}]};

get_push_gift_reward(4,1,1) ->
	#base_push_gift_reward{gift_id = 4,sub_id = 1,grade_id = 1,name = <<"侍魂礼包"/utf8>>,condition = [{cost,[{1,0,558}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,58}]}],rewards = [{0,17020002,10},{0,35,58}]};

get_push_gift_reward(5,1,1) ->
	#base_push_gift_reward{gift_id = 5,sub_id = 1,grade_id = 1,name = <<"图谱礼包"/utf8>>,condition = [{cost,[{1,0,418}]},{discount,2.3},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010520,1},{0,32010519,1},{0,35,98}]};

get_push_gift_reward(5,2,1) ->
	#base_push_gift_reward{gift_id = 5,sub_id = 2,grade_id = 1,name = <<"图谱礼包"/utf8>>,condition = [{cost,[{1,0,848}]},{discount,2.2},{buy_cnt,1},{cost_now,[{1,0,188}]}],rewards = [{0,32010521,1},{0,32010520,1},{0,35,188}]};

get_push_gift_reward(6,1,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 1,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,2,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 2,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,3,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 3,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,4,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 4,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,5,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 5,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,6,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 6,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,7,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 7,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,8,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 8,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,9,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 9,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,10,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 10,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,11,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 11,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,12,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 12,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,13,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 13,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(6,14,1) ->
	#base_push_gift_reward{gift_id = 6,sub_id = 14,grade_id = 1,name = <<"强者礼包"/utf8>>,condition = [{cost,[{1,0,458}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,1},{0,38040005,200},{0,35,108}]};

get_push_gift_reward(7,1,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 1,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,298}]},{discount,3.3},{buy_cnt,2},{cost_now,[{1,0,98}]}],rewards = [{0,38160001,1},{0,14010003,1},{0,35,98}]};

get_push_gift_reward(7,2,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 2,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,188}]},{discount,1.5},{buy_cnt,1},{cost_now,[{1,0,28}]}],rewards = [{0,37020002,1},{0,35,28}]};

get_push_gift_reward(7,3,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 3,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,888}]},{discount,1.9},{buy_cnt,1},{cost_now,[{1,0,168}]}],rewards = [{0,34010341,1},{0,32010519,1},{0,35,168}]};

get_push_gift_reward(7,4,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 4,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,488}]},{discount,2.2},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,22030001,50},{0,22030101,2},{0,35,108}]};

get_push_gift_reward(7,5,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 5,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,2688}]},{discount,1.8},{buy_cnt,1},{cost_now,[{1,0,488}]}],rewards = [{0,34010342,1},{0,32010520,1},{0,35,488}]};

get_push_gift_reward(7,6,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 6,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1008}]},{discount,2.1},{buy_cnt,1},{cost_now,[{1,0,208}]}],rewards = [{0,22030001,100},{0,22030101,3},{0,35,208}]};

get_push_gift_reward(7,7,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 7,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,218}]},{discount,0.8},{buy_cnt,1},{cost_now,[{1,0,18}]}],rewards = [{0,16020002,4},{0,35,18}]};

get_push_gift_reward(7,8,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 8,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,368}]},{discount,1.8},{buy_cnt,1},{cost_now,[{1,0,68}]}],rewards = [{0,38040027,2},{0,38040005,100},{0,35,68}]};

get_push_gift_reward(7,9,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 9,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,468}]},{discount,2.3},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,34010021,1},{0,34010021,1},{0,35,108}]};

get_push_gift_reward(7,10,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 10,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,728}]},{discount,1.8},{buy_cnt,1},{cost_now,[{1,0,128}]}],rewards = [{0,38040027,4},{0,38040005,200},{0,35,128}]};

get_push_gift_reward(7,11,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 11,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1008}]},{discount,2.1},{buy_cnt,1},{cost_now,[{1,0,208}]}],rewards = [{0,22030002,100},{0,22030102,3},{0,35,208}]};

get_push_gift_reward(7,12,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 12,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,498}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,48}]}],rewards = [{0,22030001,30},{0,35,48}]};

get_push_gift_reward(7,13,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 13,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,608}]},{discount,2.8},{buy_cnt,2},{cost_now,[{1,0,168}]}],rewards = [{0,32010129,30},{0,35,168}]};

get_push_gift_reward(7,14,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 14,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1588}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,388}]}],rewards = [{0,6011405,1},{0,35,388}]};

get_push_gift_reward(7,15,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 15,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1008}]},{discount,2.1},{buy_cnt,2},{cost_now,[{1,0,208}]}],rewards = [{0,38240201,10},{0,35,208}]};

get_push_gift_reward(7,16,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 16,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,2488}]},{discount,2},{buy_cnt,1},{cost_now,[{1,0,488}]}],rewards = [{0,6011406,1},{0,35,488}]};

get_push_gift_reward(7,17,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 17,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,488}]},{discount,1.8},{buy_cnt,2},{cost_now,[{1,0,88}]}],rewards = [{0,32010129,30},{0,35,168}]};

get_push_gift_reward(7,18,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 18,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,608}]},{discount,1.8},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040027,2},{0,38040005,100},{0,35,108}]};

get_push_gift_reward(7,19,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 19,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,408}]},{discount,3.1},{buy_cnt,1},{cost_now,[{1,0,128}]}],rewards = [{0,22030002,30},{0,22030102,2},{0,35,128}]};

get_push_gift_reward(7,20,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 20,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,818}]},{discount,2.7},{buy_cnt,1},{cost_now,[{1,0,218}]}],rewards = [{0,38040027,2},{0,38040005,200},{0,35,218}]};

get_push_gift_reward(7,21,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 21,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1088}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,288}]}],rewards = [{0,22030003,60},{0,22030103,3},{0,35,288}]};

get_push_gift_reward(7,22,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 22,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,218}]},{discount,2.2},{buy_cnt,1},{cost_now,[{1,0,48}]}],rewards = [{0,22030002,20},{0,35,48}]};

get_push_gift_reward(7,23,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 23,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1288}]},{discount,2.2},{buy_cnt,2},{cost_now,[{1,0,288}]}],rewards = [{0,38240201,20},{0,35,288}]};

get_push_gift_reward(7,24,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 24,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1868}]},{discount,1.5},{buy_cnt,1},{cost_now,[{1,0,288}]}],rewards = [{0,22030003,30},{0,22030103,1},{0,35,288}]};

get_push_gift_reward(7,25,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 25,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,2688}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,688}]}],rewards = [{0,38240301,12},{0,35,488}]};

get_push_gift_reward(7,26,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 26,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1388}]},{discount,2.8},{buy_cnt,1},{cost_now,[{1,0,388}]}],rewards = [{0,14110007,1},{0,35,388}]};

get_push_gift_reward(7,27,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 27,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1008}]},{discount,2.1},{buy_cnt,1},{cost_now,[{1,0,208}]}],rewards = [{0,38240201,20},{0,35,288}]};

get_push_gift_reward(7,28,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 28,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,508}]},{discount,2.1},{buy_cnt,1},{cost_now,[{1,0,108}]}],rewards = [{0,38040002,2},{0,35,108}]};

get_push_gift_reward(7,29,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 29,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,2688}]},{discount,2.6},{buy_cnt,2},{cost_now,[{1,0,688}]}],rewards = [{0,38240301,12},{0,35,488}]};

get_push_gift_reward(7,30,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 30,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,1168}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,368}]}],rewards = [{0,38040002,4},{0,35,368}]};

get_push_gift_reward(7,31,1) ->
	#base_push_gift_reward{gift_id = 7,sub_id = 31,grade_id = 1,name = <<"特色礼包"/utf8>>,condition = [{cost,[{1,0,3888}]},{discount,2.3},{buy_cnt,2},{cost_now,[{1,0,888}]}],rewards = [{0,38240301,15},{0,35,688}]};

get_push_gift_reward(8,1,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 1,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,2,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 2,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,3,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 3,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,4,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 4,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,5,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 5,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,6,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 6,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,7,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 7,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,8,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 8,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,9,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 9,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,10,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 10,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,11,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 11,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,32010456,10},{0,32060001,2},{0,35,98}]};

get_push_gift_reward(8,12,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 12,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,988}]},{discount,1},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,34010021,2},{0,35,98}]};

get_push_gift_reward(8,13,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 13,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,1.7},{buy_cnt,1},{cost_now,[{1,0,288}]}],rewards = [{0,6310103,1},{0,38040030,20},{0,35,288}]};

get_push_gift_reward(8,14,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 14,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,1028}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,328}]}],rewards = [{0,32010194,2},{0,34010020,1},{0,35,328}]};

get_push_gift_reward(8,15,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 15,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,888}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,228}]}],rewards = [{0,6102001,1},{0,35,228}]};

get_push_gift_reward(8,16,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 16,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,198}]},{discount,3},{buy_cnt,1},{cost_now,[{1,0,60}]}],rewards = [{0,38040030,20},{0,35,60}]};

get_push_gift_reward(8,17,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 17,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,888}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,228}]}],rewards = [{0,6102001,1},{0,35,228}]};

get_push_gift_reward(8,18,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 18,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,1288}]},{discount,2.9},{buy_cnt,1},{cost_now,[{1,0,368}]}],rewards = [{0,14110006,5},{0,14110003,5},{0,35,368}]};

get_push_gift_reward(8,19,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 19,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,3388}]},{discount,3.8},{buy_cnt,1},{cost_now,[{1,0,1288}]}],rewards = [{0,34010149,1},{0,35,888}]};

get_push_gift_reward(8,20,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 20,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,2088}]},{discount,2.3},{buy_cnt,1},{cost_now,[{1,0,488}]}],rewards = [{0,53030504,1},{0,35,488}]};

get_push_gift_reward(8,21,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 21,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,328}]},{discount,3.9},{buy_cnt,1},{cost_now,[{1,0,128}]}],rewards = [{0,38040019,1},{0,35,128}]};

get_push_gift_reward(8,22,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 22,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,3668}]},{discount,2.4},{buy_cnt,1},{cost_now,[{1,0,888}]}],rewards = [{0,38300101,25},{0,38300102,25},{0,35,888}]};

get_push_gift_reward(8,23,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 23,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,888}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,228}]}],rewards = [{0,6102001,1},{0,35,228}]};

get_push_gift_reward(8,24,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 24,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,3888}]},{discount,3.3},{buy_cnt,1},{cost_now,[{1,0,1288}]}],rewards = [{0,7120102,30},{0,35,1288}]};

get_push_gift_reward(8,25,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 25,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,1628}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,528}]}],rewards = [{0,34010389,1},{0,35,528}]};

get_push_gift_reward(8,26,1) ->
	#base_push_gift_reward{gift_id = 8,sub_id = 26,grade_id = 1,name = <<"等级礼包"/utf8>>,condition = [{cost,[{1,0,888}]},{discount,2.6},{buy_cnt,1},{cost_now,[{1,0,228}]}],rewards = [{0,6102001,1},{0,35,228}]};

get_push_gift_reward(9,1,1) ->
	#base_push_gift_reward{gift_id = 9,sub_id = 1,grade_id = 1,name = <<"神巫激活"/utf8>>,condition = [{cost,[{1,0,998}]},{discount,2},{buy_cnt,3},{cost_now,[{1,0,198}]}],rewards = [{0,22030004,30},{0,22030104,1},{0,35,198}]};

get_push_gift_reward(9,2,1) ->
	#base_push_gift_reward{gift_id = 9,sub_id = 2,grade_id = 1,name = <<"神巫激活"/utf8>>,condition = [{cost,[{1,0,998}]},{discount,2},{buy_cnt,3},{cost_now,[{1,0,198}]}],rewards = [{0,22030005,30},{0,22030105,1},{0,35,198}]};

get_push_gift_reward(9,3,1) ->
	#base_push_gift_reward{gift_id = 9,sub_id = 3,grade_id = 1,name = <<"神巫激活"/utf8>>,condition = [{cost,[{1,0,998}]},{discount,3.3},{buy_cnt,4},{cost_now,[{1,0,328}]}],rewards = [{0,22030010,30},{0,22030110,1},{0,35,328}]};

get_push_gift_reward(9,4,1) ->
	#base_push_gift_reward{gift_id = 9,sub_id = 4,grade_id = 1,name = <<"神巫激活"/utf8>>,condition = [{cost,[{1,0,1688}]},{discount,2.5},{buy_cnt,4},{cost_now,[{1,0,428}]}],rewards = [{0,22030008,40},{0,22030108,1},{0,35,328}]};

get_push_gift_reward(10,1,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 1,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,1.8},{buy_cnt,2},{cost_now,[{1,0,688}]}],rewards = [{0,22030001,120},{0,22030101,2},{0,35,888}]};

get_push_gift_reward(10,2,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 2,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030002,170},{0,22030102,2},{0,35,998}]};

get_push_gift_reward(10,3,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 3,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030003,170},{0,22030103,2},{0,35,998}]};

get_push_gift_reward(10,4,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 4,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030004,170},{0,22030104,2},{0,35,998}]};

get_push_gift_reward(10,5,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 5,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030005,170},{0,22030105,2},{0,35,998}]};

get_push_gift_reward(10,6,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 6,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030010,70},{0,22030110,2},{0,35,998}]};

get_push_gift_reward(10,7,1) ->
	#base_push_gift_reward{gift_id = 10,sub_id = 7,grade_id = 1,name = <<"神巫升阶"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,2},{buy_cnt,2},{cost_now,[{1,0,798}]}],rewards = [{0,22030008,105},{0,22030108,2},{0,35,998}]};

get_push_gift_reward(11,2,1) ->
	#base_push_gift_reward{gift_id = 11,sub_id = 2,grade_id = 1,name = <<"共鸣打造"/utf8>>,condition = [{cost,[{1,0,1388}]},{discount,2.8},{buy_cnt,2},{cost_now,[{1,0,248}]}],rewards = [{0,38240201,10},{0,32010129,20},{0,35,248}]};

get_push_gift_reward(11,3,1) ->
	#base_push_gift_reward{gift_id = 11,sub_id = 3,grade_id = 1,name = <<"共鸣打造"/utf8>>,condition = [{cost,[{1,0,1388}]},{discount,2.8},{buy_cnt,2},{cost_now,[{1,0,248}]}],rewards = [{0,38240201,10},{0,32010129,20},{0,35,248}]};

get_push_gift_reward(11,4,1) ->
	#base_push_gift_reward{gift_id = 11,sub_id = 4,grade_id = 1,name = <<"共鸣打造"/utf8>>,condition = [{cost,[{1,0,2788}]},{discount,2.5},{buy_cnt,2},{cost_now,[{1,0,488}]}],rewards = [{0,38240201,20},{0,32010129,50},{0,35,488}]};

get_push_gift_reward(11,5,1) ->
	#base_push_gift_reward{gift_id = 11,sub_id = 5,grade_id = 1,name = <<"共鸣打造"/utf8>>,condition = [{cost,[{1,0,2788}]},{discount,2.5},{buy_cnt,2},{cost_now,[{1,0,488}]}],rewards = [{0,38240201,20},{0,32010129,50},{0,35,488}]};

get_push_gift_reward(12,1,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 1,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,600}]},{discount,3.8},{buy_cnt,1},{cost_now,[{1,0,228}]}],rewards = [{0,38040019,1},{0,38040018,80}]};

get_push_gift_reward(12,2,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 2,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,700}]},{discount,3.5},{buy_cnt,1},{cost_now,[{1,0,248}]}],rewards = [{0,38040019,1},{0,38040018,100}]};

get_push_gift_reward(12,3,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 3,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,900}]},{discount,4.1},{buy_cnt,1},{cost_now,[{1,0,368}]}],rewards = [{0,38040019,2},{0,38040018,100}]};

get_push_gift_reward(12,4,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 4,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,1000}]},{discount,3.9},{buy_cnt,1},{cost_now,[{1,0,388}]}],rewards = [{0,38040019,2},{0,38040018,120}]};

get_push_gift_reward(12,5,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 5,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,1300}]},{discount,3.8},{buy_cnt,1},{cost_now,[{1,0,488}]}],rewards = [{0,38040019,3},{0,38040018,140}]};

get_push_gift_reward(12,6,1) ->
	#base_push_gift_reward{gift_id = 12,sub_id = 6,grade_id = 1,name = <<"灵饰礼包"/utf8>>,condition = [{cost,[{1,0,1400}]},{discount,3.6},{buy_cnt,1},{cost_now,[{1,0,508}]}],rewards = [{0,38040019,3},{0,38040018,160}]};

get_push_gift_reward(13,1,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 1,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,300}]},{discount,3.3},{buy_cnt,1},{cost_now,[{1,0,98}]}],rewards = [{0,38040044,3},{0,35,98}]};

get_push_gift_reward(13,2,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 2,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,1000}]},{discount,3.1},{buy_cnt,1},{cost_now,[{1,0,308}]}],rewards = [{0,38040044,10},{0,35,308}]};

get_push_gift_reward(13,3,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 3,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,1000}]},{discount,3.1},{buy_cnt,1},{cost_now,[{1,0,308}]}],rewards = [{0,38040044,10},{0,35,308}]};

get_push_gift_reward(13,4,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 4,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,1300}]},{discount,3},{buy_cnt,1},{cost_now,[{1,0,388}]}],rewards = [{0,38040044,13},{0,35,388}]};

get_push_gift_reward(13,5,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 5,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,1500}]},{discount,3.3},{buy_cnt,1},{cost_now,[{1,0,488}]}],rewards = [{0,38040044,15},{0,35,488}]};

get_push_gift_reward(13,6,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 6,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,2000}]},{discount,2.9},{buy_cnt,1},{cost_now,[{1,0,588}]}],rewards = [{0,38040044,20},{0,35,588}]};

get_push_gift_reward(13,7,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 7,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,2500}]},{discount,2.9},{buy_cnt,1},{cost_now,[{1,0,728}]}],rewards = [{0,38040044,25},{0,35,728}]};

get_push_gift_reward(13,8,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 8,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,2500}]},{discount,2.9},{buy_cnt,1},{cost_now,[{1,0,728}]}],rewards = [{0,38040044,25},{0,35,728}]};

get_push_gift_reward(13,9,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 9,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,3000}]},{discount,3},{buy_cnt,1},{cost_now,[{1,0,888}]}],rewards = [{0,38040044,30},{0,35,888}]};

get_push_gift_reward(13,10,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 10,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,3000}]},{discount,3},{buy_cnt,1},{cost_now,[{1,0,888}]}],rewards = [{0,38040044,30},{0,35,888}]};

get_push_gift_reward(13,11,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 11,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,3500}]},{discount,3.1},{buy_cnt,1},{cost_now,[{1,0,1088}]}],rewards = [{0,38040044,35},{0,35,1088}]};

get_push_gift_reward(13,12,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 12,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,4000}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,1288}]}],rewards = [{0,38040044,40},{0,35,1288}]};

get_push_gift_reward(13,13,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 13,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,4500}]},{discount,3.1},{buy_cnt,1},{cost_now,[{1,0,1388}]}],rewards = [{0,38040044,45},{0,35,1388}]};

get_push_gift_reward(13,14,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 14,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,1588}]}],rewards = [{0,38040044,50},{0,35,1588}]};

get_push_gift_reward(13,15,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 15,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,5000}]},{discount,3.2},{buy_cnt,1},{cost_now,[{1,0,1588}]}],rewards = [{0,38040044,50},{0,35,1588}]};

get_push_gift_reward(13,16,1) ->
	#base_push_gift_reward{gift_id = 13,sub_id = 16,grade_id = 1,name = <<"境界礼包"/utf8>>,condition = [{cost,[{1,0,6000}]},{discount,2.8},{buy_cnt,1},{cost_now,[{1,0,1688}]}],rewards = [{0,38040044,60},{0,35,1688}]};

get_push_gift_reward(14,1,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 1,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,350}]},{discount,4.8},{buy_cnt,1},{cost_now,[{1,0,168}]}],rewards = [{0,32010316,1},{0,39510000,30}]};

get_push_gift_reward(14,2,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 2,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,350}]},{discount,4.8},{buy_cnt,1},{cost_now,[{1,0,168}]}],rewards = [{0,34010059,1},{0,39510000,30}]};

get_push_gift_reward(14,3,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 3,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,1200}]},{discount,5},{buy_cnt,1},{cost_now,[{1,0,600}]}],rewards = [{0,34010185,1},{0,39510000,40}]};

get_push_gift_reward(14,4,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 4,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,1200}]},{discount,4},{buy_cnt,1},{cost_now,[{1,0,480}]}],rewards = [{0,34010185,1},{0,39510000,40}]};

get_push_gift_reward(14,5,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 5,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,1200}]},{discount,5},{buy_cnt,1},{cost_now,[{1,0,600}]}],rewards = [{0,34010185,1},{0,39510000,40}]};

get_push_gift_reward(14,6,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 6,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,1200}]},{discount,4},{buy_cnt,1},{cost_now,[{1,0,480}]}],rewards = [{0,34010185,1},{0,39510000,40}]};

get_push_gift_reward(14,7,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 7,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,3300}]},{discount,4.2},{buy_cnt,1},{cost_now,[{1,0,1388}]}],rewards = [{0,32010141,1},{0,39510000,60}]};

get_push_gift_reward(14,8,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 8,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,3300}]},{discount,3.6},{buy_cnt,1},{cost_now,[{1,0,1188}]}],rewards = [{0,32010141,1},{0,39510000,60}]};

get_push_gift_reward(14,9,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 9,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,3300}]},{discount,3.6},{buy_cnt,1},{cost_now,[{1,0,1188}]}],rewards = [{0,32010141,1},{0,39510000,60}]};

get_push_gift_reward(14,10,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 10,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,3300}]},{discount,3.6},{buy_cnt,1},{cost_now,[{1,0,1188}]}],rewards = [{0,32010141,1},{0,39510000,60}]};

get_push_gift_reward(14,11,1) ->
	#base_push_gift_reward{gift_id = 14,sub_id = 11,grade_id = 1,name = <<"蜃妖礼包"/utf8>>,condition = [{cost,[{1,0,3300}]},{discount,3.6},{buy_cnt,1},{cost_now,[{1,0,1188}]}],rewards = [{0,32010141,1},{0,39510000,60}]};

get_push_gift_reward(_Giftid,_Subid,_Gradeid) ->
	[].

get_grade_list(1,1) ->
[1];

get_grade_list(1,2) ->
[1];

get_grade_list(1,3) ->
[1];

get_grade_list(1,4) ->
[1];

get_grade_list(1,5) ->
[1];

get_grade_list(1,6) ->
[1];

get_grade_list(1,7) ->
[1];

get_grade_list(1,8) ->
[1];

get_grade_list(1,9) ->
[1];

get_grade_list(2,1) ->
[1];

get_grade_list(2,2) ->
[1];

get_grade_list(2,3) ->
[1];

get_grade_list(3,1) ->
[1];

get_grade_list(4,1) ->
[1];

get_grade_list(5,1) ->
[1];

get_grade_list(5,2) ->
[1];

get_grade_list(6,1) ->
[1];

get_grade_list(6,2) ->
[1];

get_grade_list(6,3) ->
[1];

get_grade_list(6,4) ->
[1];

get_grade_list(6,5) ->
[1];

get_grade_list(6,6) ->
[1];

get_grade_list(6,7) ->
[1];

get_grade_list(6,8) ->
[1];

get_grade_list(6,9) ->
[1];

get_grade_list(6,10) ->
[1];

get_grade_list(6,11) ->
[1];

get_grade_list(6,12) ->
[1];

get_grade_list(6,13) ->
[1];

get_grade_list(6,14) ->
[1];

get_grade_list(7,1) ->
[1];

get_grade_list(7,2) ->
[1];

get_grade_list(7,3) ->
[1];

get_grade_list(7,4) ->
[1];

get_grade_list(7,5) ->
[1];

get_grade_list(7,6) ->
[1];

get_grade_list(7,7) ->
[1];

get_grade_list(7,8) ->
[1];

get_grade_list(7,9) ->
[1];

get_grade_list(7,10) ->
[1];

get_grade_list(7,11) ->
[1];

get_grade_list(7,12) ->
[1];

get_grade_list(7,13) ->
[1];

get_grade_list(7,14) ->
[1];

get_grade_list(7,15) ->
[1];

get_grade_list(7,16) ->
[1];

get_grade_list(7,17) ->
[1];

get_grade_list(7,18) ->
[1];

get_grade_list(7,19) ->
[1];

get_grade_list(7,20) ->
[1];

get_grade_list(7,21) ->
[1];

get_grade_list(7,22) ->
[1];

get_grade_list(7,23) ->
[1];

get_grade_list(7,24) ->
[1];

get_grade_list(7,25) ->
[1];

get_grade_list(7,26) ->
[1];

get_grade_list(7,27) ->
[1];

get_grade_list(7,28) ->
[1];

get_grade_list(7,29) ->
[1];

get_grade_list(7,30) ->
[1];

get_grade_list(7,31) ->
[1];

get_grade_list(8,1) ->
[1];

get_grade_list(8,2) ->
[1];

get_grade_list(8,3) ->
[1];

get_grade_list(8,4) ->
[1];

get_grade_list(8,5) ->
[1];

get_grade_list(8,6) ->
[1];

get_grade_list(8,7) ->
[1];

get_grade_list(8,8) ->
[1];

get_grade_list(8,9) ->
[1];

get_grade_list(8,10) ->
[1];

get_grade_list(8,11) ->
[1];

get_grade_list(8,12) ->
[1];

get_grade_list(8,13) ->
[1];

get_grade_list(8,14) ->
[1];

get_grade_list(8,15) ->
[1];

get_grade_list(8,16) ->
[1];

get_grade_list(8,17) ->
[1];

get_grade_list(8,18) ->
[1];

get_grade_list(8,19) ->
[1];

get_grade_list(8,20) ->
[1];

get_grade_list(8,21) ->
[1];

get_grade_list(8,22) ->
[1];

get_grade_list(8,23) ->
[1];

get_grade_list(8,24) ->
[1];

get_grade_list(8,25) ->
[1];

get_grade_list(8,26) ->
[1];

get_grade_list(9,1) ->
[1];

get_grade_list(9,2) ->
[1];

get_grade_list(9,3) ->
[1];

get_grade_list(9,4) ->
[1];

get_grade_list(10,1) ->
[1];

get_grade_list(10,2) ->
[1];

get_grade_list(10,3) ->
[1];

get_grade_list(10,4) ->
[1];

get_grade_list(10,5) ->
[1];

get_grade_list(10,6) ->
[1];

get_grade_list(10,7) ->
[1];

get_grade_list(11,2) ->
[1];

get_grade_list(11,3) ->
[1];

get_grade_list(11,4) ->
[1];

get_grade_list(11,5) ->
[1];

get_grade_list(12,1) ->
[1];

get_grade_list(12,2) ->
[1];

get_grade_list(12,3) ->
[1];

get_grade_list(12,4) ->
[1];

get_grade_list(12,5) ->
[1];

get_grade_list(12,6) ->
[1];

get_grade_list(13,1) ->
[1];

get_grade_list(13,2) ->
[1];

get_grade_list(13,3) ->
[1];

get_grade_list(13,4) ->
[1];

get_grade_list(13,5) ->
[1];

get_grade_list(13,6) ->
[1];

get_grade_list(13,7) ->
[1];

get_grade_list(13,8) ->
[1];

get_grade_list(13,9) ->
[1];

get_grade_list(13,10) ->
[1];

get_grade_list(13,11) ->
[1];

get_grade_list(13,12) ->
[1];

get_grade_list(13,13) ->
[1];

get_grade_list(13,14) ->
[1];

get_grade_list(13,15) ->
[1];

get_grade_list(13,16) ->
[1];

get_grade_list(14,1) ->
[1];

get_grade_list(14,2) ->
[1];

get_grade_list(14,3) ->
[1];

get_grade_list(14,4) ->
[1];

get_grade_list(14,5) ->
[1];

get_grade_list(14,6) ->
[1];

get_grade_list(14,7) ->
[1];

get_grade_list(14,8) ->
[1];

get_grade_list(14,9) ->
[1];

get_grade_list(14,10) ->
[1];

get_grade_list(14,11) ->
[1];

get_grade_list(_Giftid,_Subid) ->
	[].

