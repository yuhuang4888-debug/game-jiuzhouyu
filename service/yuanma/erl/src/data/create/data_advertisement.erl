%%%---------------------------------------
%%% module      : data_advertisement
%%% description : 广告配置
%%%
%%%---------------------------------------
-module(data_advertisement).
-compile(export_all).
-include("advertisement.hrl").



get_cfg_by_id(1,610,2) ->
	#advertisement_cfg{version_id = 1,mod_id = 610,mod_sub_id = 2,max_count = 1,reward = [],clear_type = 1,advertisement_id = "1",platform = "1"};

get_cfg_by_id(1,610,18) ->
	#advertisement_cfg{version_id = 1,mod_id = 610,mod_sub_id = 18,max_count = 1,reward = [],clear_type = 1,advertisement_id = "2",platform = "1"};

get_cfg_by_id(1,416,1) ->
	#advertisement_cfg{version_id = 1,mod_id = 416,mod_sub_id = 1,max_count = 1,reward = [],clear_type = 0,advertisement_id = "3",platform = "1"};

get_cfg_by_id(1,416,2) ->
	#advertisement_cfg{version_id = 1,mod_id = 416,mod_sub_id = 2,max_count = 1,reward = [],clear_type = 0,advertisement_id = "4",platform = "1"};

get_cfg_by_id(1,416,3) ->
	#advertisement_cfg{version_id = 1,mod_id = 416,mod_sub_id = 3,max_count = 1,reward = [],clear_type = 0,advertisement_id = "5",platform = "1"};

get_cfg_by_id(1,179,1) ->
	#advertisement_cfg{version_id = 1,mod_id = 179,mod_sub_id = 1,max_count = 1,reward = [{0,1102015063,1}],clear_type = 0,advertisement_id = "6",platform = "1"};

get_cfg_by_id(1,417,1) ->
	#advertisement_cfg{version_id = 1,mod_id = 417,mod_sub_id = 1,max_count = 1,reward = [],clear_type = 0,advertisement_id = "7",platform = "1"};

get_cfg_by_id(1,610,20) ->
	#advertisement_cfg{version_id = 1,mod_id = 610,mod_sub_id = 20,max_count = 1,reward = [],clear_type = 1,advertisement_id = "8",platform = "1"};

get_cfg_by_id(_Versionid,_Modid,_Modsubid) ->
	[].


get_ad_list_by_ver(1) ->
[{610,2},{610,18},{416,1},{416,2},{416,3},{179,1},{417,1},{610,20}];

get_ad_list_by_ver(_Versionid) ->
	[].

