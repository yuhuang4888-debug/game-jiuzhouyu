%%%---------------------------------------
%%% module      : data_popup
%%% description : 功能弹窗配置
%%%
%%%---------------------------------------
-module(data_popup).
-compile(export_all).
-include("popup.hrl").



get_base_popup(4290201) ->
	#base_popup{id = 4290201,mod_id = 429,sub_id = 0,login_trigger = 3,cond_trigger = [{2,[{1001,3}]}],content = <<"封印千术可领取"/utf8>>};

get_base_popup(4290202) ->
	#base_popup{id = 4290202,mod_id = 429,sub_id = 0,login_trigger = 3,cond_trigger = [{2,[{1002,3}]}],content = <<"菖蒲绣锦可领取"/utf8>>};

get_base_popup(4290203) ->
	#base_popup{id = 4290203,mod_id = 429,sub_id = 0,login_trigger = 3,cond_trigger = [{2,[{1003,3}]}],content = <<"千草琉璃可领取"/utf8>>};

get_base_popup(4290204) ->
	#base_popup{id = 4290204,mod_id = 429,sub_id = 0,login_trigger = 3,cond_trigger = [{2,[{1004,3}]}],content = <<"兵破生锥可领取"/utf8>>};

get_base_popup(4290205) ->
	#base_popup{id = 4290205,mod_id = 429,sub_id = 0,login_trigger = 3,cond_trigger = [{2,[{1005,3}]}],content = <<"彩羽灵鹫可领取"/utf8>>};

get_base_popup(_Id) ->
	[].

get_all_popup_ids() ->
[4290201,4290202,4290203,4290204,4290205].

get_popup_ids(429,0) ->
[4290201,4290202,4290203,4290204,4290205];

get_popup_ids(_Modid,_Subid) ->
	[].

