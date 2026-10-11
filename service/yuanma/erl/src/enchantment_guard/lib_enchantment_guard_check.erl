%%%-----------------------------------
%%% @Module      : lib_enchantment_guard_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 13. 八月 2018 19:21
%%% @Description : 结界守护检查
%%%-----------------------------------
-module(lib_enchantment_guard_check).
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("onhook.hrl").
-include("vip.hrl").
-include("enchantment_guard.hrl").
-author("chenyiming").

%% API
-compile(export_all).

%% 判断是否已激活整个古宝
is_active_whole_soap(SoapItem) ->
	#enchantment_soap_item{active_debris = DebrisIdL, soap_id = SoapId} = SoapItem,
	AllDebrisIdL = data_enchantment_guard:list_debris_id(SoapId),
	length(AllDebrisIdL) == length(DebrisIdL).

%% -----------------------------------------------------------------
%% @desc     功能描述 封印之前的检查
%% @param    参数     MaxTimes::integer 最大封印次数
%%                    CurrentTimes::integer  当前封印次数
%%                   NewCost::[{Type, Goods_id,Number}]
%%                   Ps
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
seal(MaxTimes, CurrentTimes, Cost, Ps) ->
	CheckList = [
		{check_seal_times, MaxTimes, CurrentTimes},
		{check_cost, Ps, Cost}
	],
	check_list(CheckList).


%%关卡是否正确
check_get_sweep(Gate) ->
	CheckList = [
		{check_gate, Gate}
	],
	check_list(CheckList).

%%增加关卡之前的检查
add_gate(Gate, Num) ->
	CheckList = [
		{check_gate, Gate + Num}
	],
	check_list(CheckList).

%%执行扫荡前的检查
check_do_sweep(Ps) ->
	#player_status{enchantment_guard = Guard, id = Id, vip = Vip} = Ps,
	#enchantment_guard{gate = Gate, sweep = Sweep} = Guard,
	case Sweep of
		{} ->
			{false, ?FAIL};
		_ ->
			#sweep{cost = Cost} = Sweep,
			CheckList = [
				{check_exist_sweep, Sweep},
				{check_sweep_times, Id, Vip},
				{check_gate, Gate},
				{check_cost, Ps, Cost}
			],
			check_list(CheckList)
	end.


%%副本进程获取怪物信息的检查
get_mon(Gate) ->
	CheckList = [
		{check_gate, Gate + 1}
	],
	check_list(CheckList).

%%进入副本的检查
before_enter(#player_status{team = _Team, enchantment_guard = Guard, scene = SceneId, figure = #figure{lv = RoleLv}} = _Ps) ->
	%#status_team{team_id  = TeamId} = Team,
	#enchantment_guard{gate = Gate} = Guard,
	CheckList = [
		%%{check_is_single, TeamId},  %%队伍检查  野外没有组队模式，
		{check_wave, Guard},   %%波数检查
		{check_lv, Gate + 1, RoleLv},   %%波数检查
		{check_gate, Gate + 1},
        {check_scene, SceneId}
	],
	check_list(CheckList).

check_active_debris(PS, SoapId, DebrisId) ->
	#player_status{enchantment_guard = GuardStatus} = PS,
	#enchantment_guard{soap_status = SoapStatus} = GuardStatus,
	#enchantment_soap_status{soap_map = SoapMap} = SoapStatus,
	CheckList = [
		{check_condition, SoapId, DebrisId, SoapMap},
		{check_active, SoapId, DebrisId, SoapMap},
		{check_cost, SoapId, DebrisId, PS}
	],
	case check_list(CheckList) of
		true ->
			#base_enchantment_guard_soap_debris{cost = Cost} =
				data_enchantment_guard:get_soap_debris(SoapId, DebrisId),
			{true, Cost};
		ErrInfo -> ErrInfo
	end.


check_list([]) ->
	true;
check_list([H | CheckList]) ->
	case check(H) of
		true ->
			check_list(CheckList);
		{false, Res} ->
			{false, Res}
	end.

% 场景检查
check({check_scene, SceneId}) ->
    case lib_scene:is_outside_scene(SceneId) of
        true -> true;
        false -> {false, ?ERRCODE(cannot_transferable_scene)}
    end;

%检查是否有扫荡信息
check({check_exist_sweep, Sweep}) ->
	case Sweep of
		{} ->
			{false, ?ERRCODE(err133_no_exist_sweep)};
		#sweep{} ->
			true
	end;

check({check_lv, Gate, RoleLv}) ->  %% 等级检查
	LvLimit = data_enchantment_guard:get_lv_by_id(Gate),
	if
		RoleLv >= LvLimit ->
			true;
		true ->
			{false, ?ERRCODE(err610_not_enough_lv_to_enter_dungeon)}
	end;

%%检查关卡是否正确
check({check_gate, Gate}) ->
	case data_enchantment_guard:get_boss(Gate) of
		[] ->
			{false, ?ERRCODE(err133_err_gate)};
		_ ->
			true
	end;
%%检查扫荡次数     TODO: VIP配置临时改下
check({check_sweep_times, Id, _Vip}) ->
	#role_vip{vip_type = VipType,vip_lv =  VipLv  }  = _Vip,
	MaxTimes  = lib_vip_api:get_vip_privilege(?ENCHANTMENT_GUAND, ?SWEEP_VIP_ID, VipType, VipLv),
	CurrentTimes = mod_daily:get_count(Id, ?ENCHANTMENT_GUAND, ?SWEEP_COUNT_ID),
	if
		CurrentTimes >= MaxTimes ->
			{false, ?ERRCODE(err133_max_sweep_times)};
		true ->
			true
	end;

%%检查是否单人
check({check_is_single, Id}) ->
	if
		Id == 0 ->
			true;
		true ->
			{false, ?ERRCODE(err133_not_single)}
	end;

%%波数检查
check({check_wave, Guard}) ->
	#enchantment_guard{wave = W, gate = Gate} = Guard,
	case data_enchantment_guard:get_wave_by_id(Gate + 1) of
		[] ->
			{false, ?ERRCODE(err133_err_gate)};
		[MaxWave] ->
			if
				W >= MaxWave ->
					true;
				true ->
					{false, ?ERRCODE(err133_no_enough_wave)}
			end
	end;

%%检查消耗是否足够
check({check_cost, Ps, Cost}) ->
	case lib_goods_api:check_object_list(Ps, Cost) of
		true ->
			true;
		{false, Res} ->
			{false, Res}
	end;

%%检查封印次数是否足够
check({check_seal_times, MaxTimes, CurrentTimes}) ->
	if
		MaxTimes >= CurrentTimes + 1 ->
			true;
		true ->
			{false, ?ERRCODE(err133_not_enough_seal_times)}
	end;

check({check_condition, SoapId, DebrisId, SoapMap}) ->
	case data_enchantment_guard:get_soap(SoapId) of
		#base_enchantment_guard_soap{condition = []} -> IsNext = true;
		#base_enchantment_guard_soap{condition = [{active, NeedSoapId}|_]} ->
			IsNext = is_active_whole_soap(maps:get(NeedSoapId, SoapMap, #enchantment_soap_item{soap_id = NeedSoapId}));
		_ -> IsNext = false
	end,
	case data_enchantment_guard:get_soap_debris(SoapId, DebrisId) of
		_ when not IsNext -> {false, ?ERRCODE(err133_active_pre_soap)};
		#base_enchantment_guard_soap_debris{condition = []} -> true;
		#base_enchantment_guard_soap_debris{condition = [{active, NeedDebrisId}|_]} ->
			#enchantment_soap_item{active_debris = DebrisIdL2} = maps:get(SoapId, SoapMap, #enchantment_soap_item{}),
			case lists:member(NeedDebrisId, DebrisIdL2) of
				true -> true;
				_ -> {false, ?ERRCODE(err133_active_pre_debris)}
			end;
		_ ->
			{false, ?ERRCODE(err133_active_pre_debris)}
	end;

check({check_active, SoapId, DebrisId, SoapMap}) ->
	#enchantment_soap_item{active_debris = DebrisIdL} = maps:get(SoapId, SoapMap, #enchantment_soap_item{soap_id = SoapId}),
	case lists:member(DebrisId, DebrisIdL) of
		true -> {false, ?ERRCODE(err161_already_active)};
		_ -> true
	end;

check({check_cost, SoapId, DebrisId, PS}) ->
	case data_enchantment_guard:get_soap_debris(SoapId, DebrisId) of
		#base_enchantment_guard_soap_debris{cost = Cost} ->
			lib_goods_api:check_object_list(PS, Cost);
		_ ->
			{false, ?MISSING_CONFIG}
	end.
