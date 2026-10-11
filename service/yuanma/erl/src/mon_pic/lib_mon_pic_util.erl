%%%--------------------------------------
%%% @Module  : lib_mon_pic_util
%%% @Author  : zengzy 
%%% @Created : 2018-04-10
%%% @Description:  怪物图鉴
%%%--------------------------------------
-module(lib_mon_pic_util).
-compile(export_all).
-export([
 
    ]).

-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("mon_pic.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

%% ---------------------------------- 激活检测 -----------------------------------
check_active(_PS, _PicId, []) -> true;
check_active(PS, PicId, [H|T]) ->
	case do_check_active(PS, PicId, H) of
		true -> check_active(PS, PicId, T);
		{false, Err} -> {false, Err}
	end.


do_check_active(_PS, PicId, check_cfg) ->
	Cfg = data_mon_pic:get_pic(PicId),
	check({check_cfg, Cfg, base_pic});
do_check_active(PS, PicId, check_active) ->
	case lib_mon_pic:get_pic(PS, PicId) of
		false -> true;
		_-> {false, ?ERRCODE(err442_has_active)}
	end;
do_check_active(PS, PicId, check_cost) ->
	#base_pic{lv=Lv} = data_mon_pic:get_pic(PicId),
	Cost = data_mon_pic:get_lv_cost(PicId,Lv),	
	?IF(Cost==[], {false,?ERRCODE(err442_cfg_fail)}, check({check_cost,Cost,PS}) );
do_check_active(PS, PicId, check_open) ->
	#base_pic{open_con=OpenCon} = data_mon_pic:get_pic(PicId),
	F = fun({Pid,NeedLv},N)->
		case lib_mon_pic:get_pic(PS, Pid) of
			false -> N;
			#mon_pic{lv=Lv} ->
				?IF(Lv>=NeedLv, N+1, N) 
		end
	end,
	Sum = lists:foldl(F, 0, OpenCon),
	case Sum>=length(OpenCon) of
		true-> true;
		false-> {false, ?ERRCODE(err442_condition_not_enough)} 
	end;
do_check_active(PS, PicId, check_lv) ->
	#base_pic{open_lv=NeedLv} = data_mon_pic:get_pic(PicId),
	Figure = PS#player_status.figure,
	Lv = Figure#figure.lv,
	case Lv>= NeedLv of
		true-> true;
		false-> {false, ?ERRCODE(err442_lv_not_enough)} 
	end;
do_check_active(_PS, PicId, check_other) ->
	#base_pic{open_other=Other} = data_mon_pic:get_pic(PicId),
	F = fun(_,N)->
		N
	end,
	Sum = lists:foldl(F, 0, Other),
	case Sum>=length(Other) of
		true-> true;
		false-> {false, ?ERRCODE(err442_condition_not_enough)} 
	end;	
do_check_active(_PS, _PicId, _ ) ->
	{false, ?FAIL}.


%% ---------------------------------- 升级检测 -----------------------------------
check_up_lv(_PS, _PicId, []) -> true;
check_up_lv(PS, PicId, [H|T]) ->
	case do_check_up_lv(PS, PicId, H) of
		true -> check_up_lv(PS, PicId, T);
		{false, Err} -> {false, Err}
	end.


do_check_up_lv(PS, PicId, check_active) ->
	case lib_mon_pic:get_pic(PS, PicId) of
		false -> {false, ?ERRCODE(err442_not_active)}; 
		_-> true 
	end;
do_check_up_lv(PS, PicId, check_max_lv) ->
	MaxLv = data_mon_pic:get_pic_max_lv(PicId),
	#mon_pic{lv=Lv} = lib_mon_pic:get_pic(PS, PicId),
	case Lv< MaxLv of
		true->true;
		false-> {false, ?ERRCODE(err442_has_max_lv)} 
	end;	
do_check_up_lv(PS, PicId, check_cost) ->
	#mon_pic{lv=Lv} = lib_mon_pic:get_pic(PS, PicId),
	Cost = data_mon_pic:get_lv_cost(PicId,Lv+1),	
	?IF(Cost==[], {false,?ERRCODE(err442_cfg_fail)}, check({check_cost,Cost,PS}) );	
do_check_up_lv(_PS, _PicId, _ ) ->
	{false, ?FAIL}.

%% ---------------------------------- 激活组合检测 -----------------------------------
check_active_group(_PS, _GroupId, []) -> true;
check_active_group(PS, GroupId, [H|T]) ->
	case do_check_active_group(PS, GroupId, H) of
		true -> check_active_group(PS, GroupId, T);
		{false, Err} -> {false, Err}
	end.


do_check_active_group(PS, GroupId, check_cfg) ->
	StatusPic = PS#player_status.mon_pic,
	GroupList = StatusPic#status_mon_pic.group_list,
	case lists:keyfind(GroupId, 1, GroupList) of 
		false-> Lv = 1;
		{_, OLv} -> Lv = OLv+1
	end,
	Cfg = data_mon_pic:get_group(GroupId,Lv),
	check({check_cfg, Cfg, base_group});
do_check_active_group(PS, GroupId, check_condition) ->
	StatusPic = PS#player_status.mon_pic,
	PicList = StatusPic#status_mon_pic.pic_list,
	GroupList = StatusPic#status_mon_pic.group_list,
	case lists:keyfind(GroupId, 1, GroupList) of 
		false-> Lv = 1;
		{_, OLv} -> Lv = OLv+1
	end,
	#base_group{need_list=NeedList} = data_mon_pic:get_group(GroupId, Lv),
	KeyPos = #mon_pic.pic_id,
	F = fun({PicId,NeedLv}, N)->
		case lists:keyfind(PicId, KeyPos, PicList) of
			false-> N;
			#mon_pic{lv=PicLv} -> 
				?IF(PicLv>=NeedLv, N+1, N)
		end
	end,
	Sum = lists:foldl(F, 0, NeedList),
	case Sum>=length(NeedList) of
		true->true;
		false-> {false,?ERRCODE(err442_condition_not_enough)} 
	end;
do_check_active_group(_PS, _GroupId, _ ) ->
	{false, ?FAIL}.


%% ---------------------------------- 通用检测函数 -----------------------------------
check({check_cfg, Cfg, Atom}) ->
	case is_record(Cfg, Atom) of
		true->true;
		false->{false,?ERRCODE(err442_cfg_fail)}  
	end;
check({check_cost,CostList,PS}) ->
	Result = lib_goods_util:check_object_list(PS,CostList),
	case Result of
		true->
			true;
		{false,Res}->
			{false,Res};
		_Othre->
			true
	end;	
check(_) ->
    {false,?FAIL}.

%% ---------------------------------- db函数 -----------------------------------
db_pic_group_select(RoleId)->
	Sql = io_lib:format(?sql_pic_group_select,[RoleId]),
	db:get_all(Sql).


db_pic_group_replace(RoleId,GroupId,Lv) ->
	Sql = io_lib:format(?sql_pic_group_replace, [RoleId,GroupId,Lv]),
	db:execute(Sql).


db_pic_select(RoleId)->
	Sql = io_lib:format(?sql_mon_pic_select,[RoleId]),
	db:get_all(Sql).


db_pic_replace(RoleId,PicId,Lv) ->
	Sql = io_lib:format(?sql_mon_pic_replace, [RoleId,PicId,Lv]),
	db:execute(Sql).


