%% ---------------------------------------------------------------------------
%% @doc lib_custom_act_holyorgan_hire.erl

%% @author  lxl
%% @email  
%% @since  2018-10-24
%% @deprecated 圣器租用
%% ---------------------------------------------------------------------------
-module(lib_custom_act_holyorgan_hire).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").

%% 登陆
login(PS) ->
	#player_status{id = RoleId} = PS,
	case db_holyorgan_hire_select(RoleId) of
		[] -> PS#player_status{hire_status = #hire_status{}};
		List ->
			login_init(PS, List)
	end.

login_init(PS, HireList) ->
	NowTime = utime:unixtime(),
	F = fun([Type, SubType, HireTimes, AccHireTimes, HireTime, Time], {List, List2}) ->
		case lib_custom_act_api:is_open_act(Type, SubType) of 
			true ->
				{_NeedCancel, NewHireTimes, NewHireTime} = check_cancel_hire_holyorgan(Type, SubType, HireTimes, AccHireTimes, HireTime),
				HireState = get_hire_state(Type, SubType, AccHireTimes),
				%cancel_holyorgan(PS, NeedCancel, Type, SubType),
				NewTime = ?IF(NowTime>=Time, 0, Time),
				?IF(Time>0 andalso NowTime>=Time, send_expire_mail(PS#player_status.id), ok),
				HireInfo = #hire_info{
					key = {Type, SubType}, type = Type, subtype = SubType, hire_times = NewHireTimes, 
					acc_hire_times = AccHireTimes, hire_time = NewHireTime, time = NewTime, hire_state = HireState
				},
				case NewTime =/= Time orelse NewHireTimes =/= HireTimes orelse NewHireTime =/= HireTime of 
					true -> db_holyorgan_hire_replace(PS#player_status.id, HireInfo);
					_ -> ok
				end,
				{[HireInfo|List], List2};
			_ -> {List, [{Type, SubType}|List2]}
		end
	end,
	{NewHireList, DeleteList} = lists:foldl(F, {[], []}, HireList),
	%?PRINT("login_init ~p~n", [NewHireList]),
	db_holyorgan_hire_delete(PS#player_status.id, DeleteList),
	Ref = start_hire_timer(PS, NewHireList, []),
	PS#player_status{hire_status = #hire_status{hire_list = NewHireList, ref = Ref}}.

%% 获取租借信息
get_hire_act_info(PS, Type, SubType) ->
	case lib_custom_act_api:is_open_act(Type, SubType) of 
		true ->
			HireInfo = get_role_hire_info(PS, Type, SubType),
			#hire_info{
				hire_times = _HireTimes, acc_hire_times = AccHireTimes, hire_time = HireTime, time = _Time, hire_state = HireState
			} = HireInfo,
			TodayIsHire = today_is_hire(HireTime),
			HireTimes = ?IF(TodayIsHire == true, _HireTimes, 0),
			Time = ?IF(_Time > 0 andalso utime:unixtime() >= _Time, 0, _Time),
			%?PRINT("get_hire_act_info ~p~n", [{HireTimes, AccHireTimes, Time, HireState}]),
			{ok, Bin} = pt_332:write(33201, [1, Type, SubType, HireTimes, AccHireTimes, Time, HireState]);
		_ -> 
			{ok, Bin} = pt_332:write(33201, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, 0, 0])
	end,
	lib_server_send:send_to_sid(PS#player_status.sid, Bin).

%% 获取租借到期
clear_hire_info(PS) ->
	Now = utime:unixtime() + 5,
	#player_status{id = RoleId, hire_status = #hire_status{hire_list = HireList, ref = ORef}} = PS,
	F = fun(#hire_info{time = Time} = HireInfo, List) ->
		case Time =/= 0 andalso Now >= Time of 
			true ->
				NewHireInfo = HireInfo#hire_info{time = 0},
				send_expire_mail(RoleId),
				db_holyorgan_hire_replace(RoleId, NewHireInfo),
				[NewHireInfo|List];
			_ -> [HireInfo|List]
		end
	end,
	NewHireList = lists:foldl(F, [], HireList),
	Ref = start_hire_timer(PS, NewHireList, ORef),
	PS#player_status{hire_status = #hire_status{hire_list = NewHireList, ref = Ref}}.

%% 租借
hire(PS, Type, SubType) ->
	case lib_custom_act_api:is_open_act(Type, SubType) of 
		true ->
			HireInfo = get_role_hire_info(PS, Type, SubType),
			case hire_check(PS, HireInfo) of 	
				{ok, NewHireInfo, HireCost} ->
					hire_core(PS, NewHireInfo, HireCost);
				{false, Res} ->
					?PRINT("hire_check Res ~p~n", [Res]),
					{false, Res, PS}
			end;
		_ -> 
			{false, ?ERRCODE(err331_act_closed), PS}
	end.

hire_check(PS, HireInfo) ->
	#hire_info{type = Type, subtype = SubType, hire_times = _HireTimes, acc_hire_times = AccHireTimes, hire_time = HireTime, time = OTime, hire_state = HireState} = HireInfo,
	{TypeId, IllusionId} = get_hire_illusion_type(Type, SubType),
	CanActive = lib_mount:can_active_figure(PS, TypeId, IllusionId),
	IsHire = today_is_hire(HireTime),
	if 
		CanActive =/= true -> 
			case CanActive of 
				{false, 2} -> {false, ?ERRCODE(err322_figure_not_open)};
				{false, 3} -> {false, ?ERRCODE(err322_already_active)};
				_ -> {false, ?MISSING_CONFIG}
			end;	
		IsHire == true -> {false, ?ERRCODE(err322_today_is_hire)};
		HireState == ?HIRE_STATE_ENOUGH -> {false, ?ERRCODE(err322_no_need_hire)};
		true ->
			NowTime = utime:unixtime(),
			NewHireTimes = 1, NewAccHireTimes = AccHireTimes + 1, 
			NewHireState = get_hire_state(Type, SubType, NewAccHireTimes),
			Duration = get_hire_duration(Type, SubType),
			NewTime = ?IF(NewHireState == ?HIRE_STATE_ENOUGH, 0, ?IF(NowTime>=OTime, NowTime+Duration, OTime+Duration)),
			NewHireInfo = HireInfo#hire_info{hire_times = NewHireTimes, acc_hire_times = NewAccHireTimes, hire_time = NowTime, time = NewTime, hire_state = NewHireState},
			case get_hire_cost(Type, SubType) of 
				[] -> {false, ?MISSING_CONFIG};
				HireCost ->
					case lib_goods_api:check_object_list(PS, HireCost) of 
						{false, Res} -> {false, Res};
						true ->
							{ok, NewHireInfo, HireCost}
					end
			end
	end.

hire_core(PS, HireInfo, HireCost) ->
	#player_status{id = RoleId, hire_status = #hire_status{hire_list = HireList}, figure = #figure{name = RoleName, career = Career}} = PS,
	#hire_info{type = Type, subtype = SubType, time = EndTime, acc_hire_times = AccHireTimes} = HireInfo,
	{TypeId, IllusionId} = get_hire_illusion_type(Type, SubType),
	case lib_goods_api:cost_object_list(PS, HireCost, hire_act, lists:concat([Type, "_", SubType])) of 
		{true, PS1} ->
			%% 日志
			lib_log_api:log_holyorgan_hire(RoleId, Type, SubType, AccHireTimes, HireCost, EndTime),
			%% db
			db_holyorgan_hire_replace(RoleId, HireInfo),
			%% 激活形象
			PS2 = lib_mount:active_figure_api(PS1, TypeId, IllusionId, [{end_time, EndTime}]),
			NewHireList = lists:keystore({Type, SubType}, #hire_info.key, HireList, HireInfo),
			Ref = start_hire_timer(PS, NewHireList, PS2#player_status.hire_status#hire_status.ref),
			%?PRINT("hire_core NewHireList ~p~n", [NewHireList]),
			IllusionName = lib_mount:get_illusion_name(TypeId, IllusionId, Career),
			lib_chat:send_TV({all}, 332, 1, [RoleName, util:make_sure_binary(IllusionName)]),
			NewPS = PS2#player_status{hire_status = #hire_status{hire_list = NewHireList, ref = Ref}},
			{ok, NewPS, HireInfo};
		{false, Res, _} ->
			{false, Res, PS}
	end.

get_role_hire_info(PS, Type, SubType) ->
	#player_status{hire_status = #hire_status{hire_list = HireList}} = PS,
	case lists:keyfind({Type, SubType}, #hire_info.key, HireList) of
		#hire_info{} = HireInfo -> HireInfo;
		_ -> 
			#hire_info{
				key = {Type, SubType}, type = Type, subtype = SubType
			}
	end.

%% 登陆时检查租借日期，清理相关信息
check_cancel_hire_holyorgan(Type, SubType, HireTimes, AccHireTimes, HireTime) ->
	IsToday = utime:is_today(HireTime),
	if
		HireTime == 0 ->
			{false, 0, 0};
		IsToday == true ->  %% 没有跨天
			{false, HireTimes, HireTime};    
		HireTimes == 0 ->  %% 跨天了，但是之前没有租用
			{false, 0, 0};
		true -> 
			case lib_custom_act_util:keyfind_act_condition(Type, SubType, acc_hire_times) of 
				{acc_hire_times, AccTimes} when AccHireTimes >= AccTimes -> Cancel = false;
				_ -> Cancel = true
			end,
			{Cancel, 0, 0}
	end.

today_is_hire(HireTime) ->
	case HireTime > 0 andalso utime:is_today(HireTime) of 
		true -> true;
		_ -> false
	end.

%% 获取活动的永久获得状态
get_hire_state(Type, SubType, AccHireTimes) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, acc_hire_times) of 
		{acc_hire_times, AccTimes} when AccHireTimes >= AccTimes -> ?HIRE_STATE_ENOUGH;
		_ -> ?HIRE_STATE_NOT_ENOUGH
	end.
%% 获取租借消耗
get_hire_cost(Type, SubType) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, hire_cost) of 
		{hire_cost, Gold} -> [{?TYPE_GOLD, 0, Gold}];
		_ -> []
	end.
%% 获取租借后得到的神兵类型
get_hire_illusion_type(Type, SubType) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, hire_content) of 
		{hire_content, [TypeId, Id]} -> {TypeId, Id};
		_ -> {0, 0}
	end.
%% 获取租借时长
get_hire_duration(Type, SubType) ->
	case lib_custom_act_util:keyfind_act_condition(Type, SubType, time) of 
		{time, Duration} -> Duration;
		_ -> ?HIRE_TIME
	end.

%% 检查租借时间，开启定时器
start_hire_timer(PS, HireList, ORef) ->
	#player_status{pid = Pid} = PS,
	F = fun(#hire_info{time = Time}, List) ->
		?IF(Time>0, [Time|List], List)
	end,
	TimeList = lists:foldl(F, [], HireList),
	case lists:sort(TimeList) of 
		[] -> [];
		[TimeMin|_] ->
			ExpireTime = TimeMin - utime:unixtime(),
			NewRef = util:send_after(ORef, max(1, ExpireTime) * 1000, Pid, {'mod', ?MODULE, clear_hire_info, []}),
			NewRef
	end.

send_expire_mail(RoleId) ->
	Title = utext:get(3320001),
	Content = utext:get(3320002),
	lib_mail_api:send_sys_mail([RoleId], Title, Content, []).

%% db函数
db_holyorgan_hire_select(RoleId) ->
	Sql = io_lib:format(?sql_hire_act_select_all, [RoleId]),
	db:get_all(Sql).

db_holyorgan_hire_replace(RoleId, HireInfo) ->
	#hire_info{
		type = Type, subtype = SubType,
		hire_times = HireTimes, acc_hire_times = AccHireTimes, hire_time = HireTime, time = Time
	} = HireInfo,
	Sql = io_lib:format(?sql_hire_act_replace, [RoleId, Type, SubType, HireTimes, AccHireTimes, HireTime, Time]),
	db:execute(Sql).

db_holyorgan_hire_delete(RoleId, DeleteList) ->
	F = fun({Type, SubType}) ->
		Sql = io_lib:format(?sql_hire_act_delete, [RoleId, Type, SubType]),
		db:execute(Sql)
	end,
	lists:foreach(F, DeleteList).
