%%%---------------------------------------
%%% module      : data_domain
%%% description : 秘境领域配置
%%%
%%%---------------------------------------
-module(data_domain).
-compile(export_all).
-include("domain.hrl").



get_domain_kill_reward(1) ->
	#domain_kill_reward_cfg{reward_id = 1,stage = 1,kill_boss_num = 1,limit_down = 1,limit_up = 9999,reward_list = [{100,7110001,2},{100,32010235,1},{100,7120101,1}]};

get_domain_kill_reward(2) ->
	#domain_kill_reward_cfg{reward_id = 2,stage = 2,kill_boss_num = 3,limit_down = 1,limit_up = 9999,reward_list = [{100,7110001,5},{100,32010235,1},{100,7120102,1}]};

get_domain_kill_reward(3) ->
	#domain_kill_reward_cfg{reward_id = 3,stage = 3,kill_boss_num = 6,limit_down = 1,limit_up = 9999,reward_list = [{100,7110002,1},{100,32010236,1},{100,7120102,1}]};

get_domain_kill_reward(_Rewardid) ->
	[].

get_all_stage() ->
[1,2,3].

get_domain_stage_lv(1,_Lv) when _Lv =< 9999, _Lv >= 1 ->
	#domain_kill_reward_cfg{reward_id=1,stage=1,kill_boss_num=1,limit_down=1,limit_up=9999,reward_list=[{100,7110001,2},{100,32010235,1},{100,7120101,1}]};
get_domain_stage_lv(2,_Lv) when _Lv =< 9999, _Lv >= 1 ->
	#domain_kill_reward_cfg{reward_id=2,stage=2,kill_boss_num=3,limit_down=1,limit_up=9999,reward_list=[{100,7110001,5},{100,32010235,1},{100,7120102,1}]};
get_domain_stage_lv(3,_Lv) when _Lv =< 9999, _Lv >= 1 ->
	#domain_kill_reward_cfg{reward_id=3,stage=3,kill_boss_num=6,limit_down=1,limit_up=9999,reward_list=[{100,7110002,1},{100,32010236,1},{100,7120102,1}]};
get_domain_stage_lv(_Stage,_Lv) ->
	[].

get_domain_special_boss(430001) ->
	#domain_special_boss_cfg{boss_id = 430001,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430002) ->
	#domain_special_boss_cfg{boss_id = 430002,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430003) ->
	#domain_special_boss_cfg{boss_id = 430003,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430004) ->
	#domain_special_boss_cfg{boss_id = 430004,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430005) ->
	#domain_special_boss_cfg{boss_id = 430005,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430006) ->
	#domain_special_boss_cfg{boss_id = 430006,sp_boss_list = [],sp_boss_weight = [{50,[430101]},{950,[]}]};

get_domain_special_boss(430009) ->
	#domain_special_boss_cfg{boss_id = 430009,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430010) ->
	#domain_special_boss_cfg{boss_id = 430010,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430011) ->
	#domain_special_boss_cfg{boss_id = 430011,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430012) ->
	#domain_special_boss_cfg{boss_id = 430012,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430013) ->
	#domain_special_boss_cfg{boss_id = 430013,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430014) ->
	#domain_special_boss_cfg{boss_id = 430014,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430015) ->
	#domain_special_boss_cfg{boss_id = 430015,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430016) ->
	#domain_special_boss_cfg{boss_id = 430016,sp_boss_list = [],sp_boss_weight = [{80,[430105]},{920,[]}]};

get_domain_special_boss(430017) ->
	#domain_special_boss_cfg{boss_id = 430017,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430018) ->
	#domain_special_boss_cfg{boss_id = 430018,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430019) ->
	#domain_special_boss_cfg{boss_id = 430019,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430020) ->
	#domain_special_boss_cfg{boss_id = 430020,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430021) ->
	#domain_special_boss_cfg{boss_id = 430021,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430022) ->
	#domain_special_boss_cfg{boss_id = 430022,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430023) ->
	#domain_special_boss_cfg{boss_id = 430023,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(430024) ->
	#domain_special_boss_cfg{boss_id = 430024,sp_boss_list = [],sp_boss_weight = [{100,[430109]},{900,[]}]};

get_domain_special_boss(_Bossid) ->
	[].

