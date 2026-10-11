%%%-----------------------------------
%%% @Module      : lib_advertisement_util
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 14. 四月 2021 20:03
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_advertisement_util).
-include("common.hrl").
-include("advertisement.hrl").
-author("carlos").

%% API
-export([]).


%%
save_db(RoleId, Ad) ->
	#advertisement{ad_id = _AdId, mod_id = ModId, sub_id = SubId, count = Count, time = Time} = Ad,
	Sql = io_lib:format(?sql_replace_ad, [RoleId, ModId, SubId, "1", Time, Count]),
	db:execute(Sql).


delete_db_with_id(ModId, SubId) ->
	Sql = io_lib:format(?sql_delete_by_id, [ModId, SubId]),
	db:execute(Sql).

save_log(RoleId, ModId, SubId, Count) ->
	Sql = io_lib:format(?save_log, [RoleId, ModId, SubId, "0", utime:unixtime(), Count]),
	db:execute(Sql).