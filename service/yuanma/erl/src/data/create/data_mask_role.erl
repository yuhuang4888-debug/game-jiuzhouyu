%%%---------------------------------------
%%% module      : data_mask_role
%%% description : 蒙面配置
%%%
%%%---------------------------------------
-module(data_mask_role).
-compile(export_all).
-include("mask_role.hrl").




get_mask_name(1) ->
<<"蒙面人"/utf8>>;

get_mask_name(_Id) ->
	"".


get_duration(38250027) ->
{1,3600};

get_duration(_Goodsid) ->
	0.

