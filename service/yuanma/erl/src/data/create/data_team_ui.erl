%%%---------------------------------------
%%% module      : data_team_ui
%%% description : 组队大厅ui配置
%%%
%%%---------------------------------------
-module(data_team_ui).
-compile(export_all).
-include("team.hrl").



get(1,0) ->
	#team_enlist_cfg{activity_id = 1,activity_name = "无目标",subtype_id = 0,subtype_name = "无目标",module_id = 0,sub_module = 0,dun_id = 0,scene_id = 0,num = 3,auto_pos = [],default_lv_min = 1,default_lv_max = 999,auto_pair = 0,exp_scale_type = 1,match_fake_man = 0,is_zone_mod = 0};

get(3,1) ->
	#team_enlist_cfg{activity_id = 3,activity_name = "世界BOSS",subtype_id = 1,subtype_name = "世界大妖",module_id = 460,sub_module = 0,dun_id = 0,scene_id = 0,num = 3,auto_pos = [],default_lv_min = 1,default_lv_max = 999,auto_pair = 0,exp_scale_type = 1,match_fake_man = 0,is_zone_mod = 0};

get(4,1) ->
	#team_enlist_cfg{activity_id = 4,activity_name = "BOSS之家",subtype_id = 1,subtype_name = "大妖之境",module_id = 460,sub_module = 0,dun_id = 0,scene_id = 0,num = 3,auto_pos = [],default_lv_min = 1,default_lv_max = 999,auto_pair = 0,exp_scale_type = 1,match_fake_man = 0,is_zone_mod = 0};

get(5,1) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 1,subtype_name = "95级寻装觅刃（新手）",module_id = 610,sub_module = 0,dun_id = 5001,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 95,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,2) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 2,subtype_name = "140级寻装觅刃（基础）",module_id = 610,sub_module = 0,dun_id = 5002,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 140,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,3) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 3,subtype_name = "200级寻装觅刃（普通）",module_id = 610,sub_module = 0,dun_id = 5003,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 200,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,4) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 4,subtype_name = "250级寻装觅刃（困难）",module_id = 610,sub_module = 0,dun_id = 5004,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 250,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,5) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 5,subtype_name = "300级寻装觅刃（专精）",module_id = 610,sub_module = 0,dun_id = 5005,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 300,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,6) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 6,subtype_name = "350级寻装觅刃（达人）",module_id = 610,sub_module = 0,dun_id = 5006,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 350,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,7) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 7,subtype_name = "400级寻装觅刃（强者）",module_id = 610,sub_module = 0,dun_id = 5007,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 400,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,8) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 8,subtype_name = "450级寻装觅刃（大师）",module_id = 610,sub_module = 0,dun_id = 5008,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 450,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,9) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 9,subtype_name = "500级寻装觅刃（末日）",module_id = 610,sub_module = 0,dun_id = 5009,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 500,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,10) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 10,subtype_name = "550级寻装觅刃（噩梦）",module_id = 610,sub_module = 0,dun_id = 5010,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 550,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,11) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 11,subtype_name = "600级寻装觅刃（灾难）",module_id = 610,sub_module = 0,dun_id = 5011,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 600,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,12) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 12,subtype_name = "650级寻装觅刃（灭世）",module_id = 610,sub_module = 0,dun_id = 5012,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 650,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(5,13) ->
	#team_enlist_cfg{activity_id = 5,activity_name = "装备副本",subtype_id = 13,subtype_name = "700级寻装觅刃（天神）",module_id = 610,sub_module = 0,dun_id = 5013,scene_id = 5001,num = 3,auto_pos = [],default_lv_min = 700,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(6,1) ->
	#team_enlist_cfg{activity_id = 6,activity_name = "龙纹副本",subtype_id = 1,subtype_name = "神纹烙印（冒险）",module_id = 610,sub_module = 0,dun_id = 32001,scene_id = 2030,num = 3,auto_pos = [],default_lv_min = 290,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(6,2) ->
	#team_enlist_cfg{activity_id = 6,activity_name = "龙纹副本",subtype_id = 2,subtype_name = "神纹烙印（白银）",module_id = 610,sub_module = 0,dun_id = 32002,scene_id = 2030,num = 3,auto_pos = [],default_lv_min = 310,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(6,3) ->
	#team_enlist_cfg{activity_id = 6,activity_name = "龙纹副本",subtype_id = 3,subtype_name = "神纹烙印（黄金）",module_id = 610,sub_module = 0,dun_id = 32003,scene_id = 2030,num = 3,auto_pos = [],default_lv_min = 350,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(6,4) ->
	#team_enlist_cfg{activity_id = 6,activity_name = "龙纹副本",subtype_id = 4,subtype_name = "神纹烙印（钻石）",module_id = 610,sub_module = 0,dun_id = 32004,scene_id = 2030,num = 3,auto_pos = [],default_lv_min = 430,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(6,5) ->
	#team_enlist_cfg{activity_id = 6,activity_name = "龙纹副本",subtype_id = 5,subtype_name = "神纹烙印（大师）",module_id = 610,sub_module = 0,dun_id = 32005,scene_id = 2030,num = 3,auto_pos = [],default_lv_min = 520,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 0};

get(7,1) ->
	#team_enlist_cfg{activity_id = 7,activity_name = "极地副本",subtype_id = 1,subtype_name = "极寒之地",module_id = 610,sub_module = 0,dun_id = 36101,scene_id = 2035,num = 3,auto_pos = [],default_lv_min = 450,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 0,is_zone_mod = 0};

get(7,2) ->
	#team_enlist_cfg{activity_id = 7,activity_name = "极地副本",subtype_id = 2,subtype_name = "埋骨之地",module_id = 610,sub_module = 0,dun_id = 36102,scene_id = 2037,num = 3,auto_pos = [],default_lv_min = 490,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 0,is_zone_mod = 0};

get(8,1) ->
	#team_enlist_cfg{activity_id = 8,activity_name = "龙语秘境",subtype_id = 1,subtype_name = "龙语秘境",module_id = 651,sub_module = 0,dun_id = 0,scene_id = 46001,num = 3,auto_pos = [],default_lv_min = 999,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 0,is_zone_mod = 0};

get(9,1) ->
	#team_enlist_cfg{activity_id = 9,activity_name = "众生之门",subtype_id = 1,subtype_name = "众生之门",module_id = 241,sub_module = 0,dun_id = 0,scene_id = 0,num = 3,auto_pos = [],default_lv_min = 130,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 1,is_zone_mod = 1};

get(10,1) ->
	#team_enlist_cfg{activity_id = 10,activity_name = "百鬼夜行",subtype_id = 1,subtype_name = "百鬼夜行",module_id = 206,sub_module = 0,dun_id = 0,scene_id = 0,num = 3,auto_pos = [],default_lv_min = 130,default_lv_max = 999,auto_pair = 1,exp_scale_type = 0,match_fake_man = 0,is_zone_mod = 1};

get(_Activityid,_Subtypeid) ->
	[].

get_key_list() ->
[{1,0},{3,1},{4,1},{5,1},{5,2},{5,3},{5,4},{5,5},{5,6},{5,7},{5,8},{5,9},{5,10},{5,11},{5,12},{5,13},{6,1},{6,2},{6,3},{6,4},{6,5},{7,1},{7,2},{8,1},{9,1},{10,1}].


get_activity_subtype_ids(1) ->
[0];


get_activity_subtype_ids(3) ->
[1];


get_activity_subtype_ids(4) ->
[1];


get_activity_subtype_ids(5) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13];


get_activity_subtype_ids(6) ->
[1,2,3,4,5];


get_activity_subtype_ids(7) ->
[1,2];


get_activity_subtype_ids(8) ->
[1];


get_activity_subtype_ids(9) ->
[1];


get_activity_subtype_ids(10) ->
[1];

get_activity_subtype_ids(_Activityid) ->
	[].

get_target_name(1,0) ->
"无目标";

get_target_name(3,1) ->
"世界大妖";

get_target_name(4,1) ->
"大妖之境";

get_target_name(5,1) ->
"95级寻装觅刃（新手）";

get_target_name(5,2) ->
"140级寻装觅刃（基础）";

get_target_name(5,3) ->
"200级寻装觅刃（普通）";

get_target_name(5,4) ->
"250级寻装觅刃（困难）";

get_target_name(5,5) ->
"300级寻装觅刃（专精）";

get_target_name(5,6) ->
"350级寻装觅刃（达人）";

get_target_name(5,7) ->
"400级寻装觅刃（强者）";

get_target_name(5,8) ->
"450级寻装觅刃（大师）";

get_target_name(5,9) ->
"500级寻装觅刃（末日）";

get_target_name(5,10) ->
"550级寻装觅刃（噩梦）";

get_target_name(5,11) ->
"600级寻装觅刃（灾难）";

get_target_name(5,12) ->
"650级寻装觅刃（灭世）";

get_target_name(5,13) ->
"700级寻装觅刃（天神）";

get_target_name(6,1) ->
"神纹烙印（冒险）";

get_target_name(6,2) ->
"神纹烙印（白银）";

get_target_name(6,3) ->
"神纹烙印（黄金）";

get_target_name(6,4) ->
"神纹烙印（钻石）";

get_target_name(6,5) ->
"神纹烙印（大师）";

get_target_name(7,1) ->
"极寒之地";

get_target_name(7,2) ->
"埋骨之地";

get_target_name(8,1) ->
"龙语秘境";

get_target_name(9,1) ->
"众生之门";

get_target_name(10,1) ->
"百鬼夜行";

get_target_name(_Activityid,_Subtypeid) ->
	"".


get_exp_scale(2) ->
2000;


get_exp_scale(3) ->
3000;

get_exp_scale(_Membercount) ->
	0.

