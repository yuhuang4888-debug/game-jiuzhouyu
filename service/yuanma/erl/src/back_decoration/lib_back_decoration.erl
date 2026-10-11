%% ---------------------------------------------------------------------------
%% @doc lib_back_decoration

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019-09-04
%% @deprecated  背饰系统
%% ---------------------------------------------------------------------------
-module(lib_back_decoration).
-include ("common.hrl").
-include ("errcode.hrl").
-include ("back_decoration.hrl").
-include ("predefine.hrl").
-include ("def_fun.hrl").
-include ("server.hrl").
-include ("skill.hrl").
-include ("figure.hrl").
-compile([export_all]).

login(Player) ->
	#player_status{id = RoleId, figure = Figure} = Player,
	DecorationList   = db_get_decoration_all(RoleId),
	DecorationStatus = cal_decoration_status(DecorationList),
	NewPlayer        = Player#player_status{back_decoration_status = DecorationStatus},
	NewFigure        = init_decoration_figure(Figure, DecorationList),
	LastPlayer       = NewPlayer#player_status{figure = NewFigure},
	%?PRINT("============= init decoration_status ~p figure:~p ~n", [NewFigure#figure.mount_figure, NewFigure#figure.mount_figure_ride]),
	LastPlayer.

off_login(Player) ->
	#player_status{id = RoleId, figure = Figure} = Player,
	DecorationList   = db_get_decoration_all(RoleId),
	DecorationStatus = cal_decoration_status(DecorationList),
	NewDecorationStatus = DecorationStatus#back_decoration_status{back_decoration_list = []},
	NewPlayer        = Player#player_status{back_decoration_status = NewDecorationStatus},
	NewFigure        = init_decoration_figure( Figure, DecorationList),
	LastPlayer       = NewPlayer#player_status{figure = NewFigure},
	%?PRINT("============= init decoration_status ~p figure:~p ~n", [NewFigure#figure.mount_figure, NewFigure#figure.mount_figure_ride]),
	LastPlayer.

%% 竞技场获取背饰外形
get_figure(RoleId) ->
	DecorationList = db_get_decoration_all(RoleId),
	case get_decoration(DecorationList) of 
		{DecorationId, _Stage, _State, ActiveStage} ->
			case data_back_decoration:get_decoration_cfg(DecorationId, ActiveStage) of 
				#base_back_decoration{figure_id = FigureId} ->
					[{?BACK_DECROTEION_TYPE_ID, FigureId, 0}];
				_ -> []
			end;
		[] -> []
	end.


init_decoration_figure(Figure, DecorationList) ->
	case get_decoration(DecorationList) of 
		{DecorationId, _Stage, State, ActiveStage} ->
			case data_back_decoration:get_decoration_cfg(DecorationId, ActiveStage) of 
				#base_back_decoration{figure_id = FigureId} ->
					BackDecoraFigure = [{?BACK_DECROTEION_TYPE_ID, FigureId, 0}],
					BackDecoraFigureRide = [{?BACK_DECROTEION_TYPE_ID, State}],
					Figure#figure{back_decora_figure = BackDecoraFigure, back_decora_figure_ride = BackDecoraFigureRide};
				_ -> Figure
			end;
		[] -> Figure
	end.

%% 获取外形数据，用于选择角色时
get_figure_list(RoleId) ->
	DecorationList   = db_get_decoration_all(RoleId),
	case get_decoration(DecorationList) of 
		{DecorationId, _Stage, _State, ActiveStage} ->
			case data_back_decoration:get_decoration_cfg(DecorationId, ActiveStage) of 
				#base_back_decoration{figure_id = FigureId} -> [{?BACK_DECROTEION_TYPE_ID, FigureId, 0}];
				_ -> []
			end;
		[] -> []
	end.

%% 获取幻化的背饰
get_decoration(DecorationList) ->
	case DecorationList of 
		[] -> [];%没有背饰返回[]
		_ ->
			case lists:keyfind(1, #back_decoration.state, DecorationList) of 
				#back_decoration{back_decoration_id = ID, stage = Stage, state = State, active_stage = ActiveStage} -> 
					{ID, Stage, State, ActiveStage};
				false ->%没有激活的返回[]
					[]
			end
	end.

%% 计算back_decoration_status 状态
cal_decoration_status(DecorationList) ->
	GetAttrSkill = fun(Decoration, [Attrs, Skills, SkillPower]) ->
				#back_decoration{back_decoration_id = DecorationId, stage = Stage} = Decoration,
				case data_back_decoration:get_decoration_cfg(DecorationId, Stage) of
					[] -> 
						[Attrs, Skills, 0];
					DecorationCfg ->
						#base_back_decoration{attr = Attr, skill = Skill} = DecorationCfg,
						{NewSkill, Power} = get_skill_power(Skill),
						[Attrs ++ Attr, Skills ++ NewSkill, SkillPower + Power]
				end
			end,
	[NewAttr, NewSkill, NewSkillPower] = lists:foldl(GetAttrSkill, [[], [], 0], DecorationList),
	#back_decoration_status{attr = NewAttr, skills = NewSkill, skill_combat = NewSkillPower, back_decoration_list = DecorationList}.

%%获取激活的背饰列表
get_decoration_list(Player) ->
	#player_status{sid = Sid
		,back_decoration_status = DecorationStatus
		} = Player,
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	List = [{ID, Stage, State} || #back_decoration{back_decoration_id = ID, stage = Stage, state = State} <- DecorationList],
	{ok, BinData} = pt_141:write(14101, [List]),
	lib_server_send:send_to_sid(Sid, BinData).

%%获取背饰详情
get_detail_decoration(Player, DecorationID) ->
	#player_status{sid = Sid
		,back_decoration_status = DecorationStatus
		, original_attr         = OriginAttr
		} = Player,
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	case lists:keyfind(DecorationID, #back_decoration.back_decoration_id, DecorationList) of
		#back_decoration{state = State, stage = Stage, back_decoration_id = DecorationID, active_stage = ActiveStage} ->
			if
				State == 1 ->
					#base_back_decoration{figure_id = FigureId} = data_back_decoration:get_decoration_cfg(DecorationID, ActiveStage);
				true -> FigureId = 0
			end,
			{NewAttr, Combat, Skill} = get_attr_combat_skill(DecorationID, Stage, OriginAttr),
			{ok, BinData}            = pt_141:write(14102, [?SUCCESS, DecorationID, Stage, State, FigureId, Skill, NewAttr, Combat]),
			%?PRINT("============= back_decoration_detail is: ~p ~p ~p ~n", [DecorationID, Combat, NewAttr]),
			lib_server_send:send_to_sid(Sid, BinData);
		_ 	-> skip %未激活不做处理
	end,
	{ok, Player}.

%%幻化背饰
%================如果当前id和stage已经的是幻化的状态取消幻化，否则都是幻化=======
%1。 修改指定back_decoration中的值
%2。 同时取消翅膀的幻化状态
%3。 广播当前场景
%================
illusion_decoration(Player, DecorationID, Stage) ->
	DecorationStatus = Player#player_status.back_decoration_status,
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	case lists:keyfind(DecorationID, #back_decoration.back_decoration_id, DecorationList) of
		#back_decoration{stage = OldStage} ->%
			if 
				OldStage < Stage ->  %%没解锁当前等级
					{false, ?ERRCODE(err_141_stage_not_match), Player};
				true ->
					do_illusion_decoration(Player, DecorationID, Stage, illusion)
			end;
		false -> 
			%?PRINT("============fail  ~n", []),
			{false, ?ERRCODE(err_141_no_decoration), Player}
	end.

do_illusion_decoration(Player, DecorationID, Stage, illusion) ->
	DecorationStatus = Player#player_status.back_decoration_status,
	case change_illusion(Player, DecorationStatus, DecorationID, Stage) of
		{true, NewDecoration, NewDecorationStatus, CancelOrIllusion} -> 
			%将翅膀幻化成基础状态
			NewPlayerTmp = lib_mount_api:cancel_swing(Player),
			NewPlayer = NewPlayerTmp#player_status{back_decoration_status = NewDecorationStatus},
			%?PRINT("=========CancelOrIllusion: ~p ~n", [CancelOrIllusion]),
			broadcast_to_scene(NewPlayer, NewDecoration, CancelOrIllusion),
			LastPlayer = upd_figure(NewPlayer, ?BACK_DECROTEION_TYPE_ID, CancelOrIllusion, get_figure_id(NewDecoration)),
			{true, LastPlayer};			
		{false, ErrorCode} -> 
			%?PRINT("============fail~p  ~n", [ErrorCode]),
			{false, ErrorCode, Player}
	end.

%%激活背饰(激活后自动幻化)
active_decoration(Player, DecorationID) ->
	DecorationStatus = Player#player_status.back_decoration_status,
	DecorationList   = DecorationStatus#back_decoration_status.back_decoration_list,
	%?PRINT("============active_begin ~p ~n", [DecorationID]),
	case check_active_decoration_cost(Player, DecorationList, DecorationID) of 
		{true, DecorationCfg} -> do_active_decoration(Player, DecorationCfg);
		{false, ErrorCode} -> 
			%?PRINT("============active_fail ~p ~n", [ErrorCode]),
			{false, ErrorCode, Player}
	end.

do_active_decoration(Player, DecorationCfg) ->
	#player_status{id = RoleId, figure = Figure} = Player,
	#base_back_decoration{cost = Cost, skill = Skills} = DecorationCfg,
	case lib_goods_api:cost_object_list_with_check(Player, Cost, back_decoration_active, "") of
		{true, NewPlayerTmp} ->
			%记录日志
			DecorationStatus    = NewPlayerTmp#player_status.back_decoration_status,
			case replace_decoration(RoleId, DecorationCfg, DecorationStatus) of
				{ok, NewDecoration, NewDecorationStatus} ->
					#back_decoration{back_decoration_id = NewDecorationId, stage = Stage, state = State, active_stage = ActiveStage} = NewDecoration,
					lib_log_api:log_back_decoration(RoleId, Figure#figure.name, NewDecorationId, ?ACTIVE_DEC, 0, Stage, Cost),
					%取消翅膀幻化
					NewPlayerTmp1       = lib_mount_api:cancel_swing(NewPlayerTmp),
					NewPlayer           = NewPlayerTmp1#player_status{back_decoration_status = NewDecorationStatus},
					db_insert_decoration(RoleId, NewDecorationId, Stage, State, ActiveStage),
					broadcast_to_scene(NewPlayer, NewDecoration, illusion),
					NewPlayerTmp2       = upd_figure(NewPlayer, ?BACK_DECROTEION_TYPE_ID, illusion, get_figure_id(NewDecoration)),
					%战力发送
					?PRINT("-=-=-=-=skill :~p ~n", [NewDecorationStatus#back_decoration_status.skills]),
					LastPlayer = lib_player:count_player_attribute(NewPlayerTmp2),
					lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
					mod_scene_agent:update(LastPlayer, [{passive_skill, Skills}, {battle_attr, LastPlayer#player_status.battle_attr}]),
					%?PRINT("============active_success ~p ~n", [NewDecoration]),
					{true, LastPlayer};	
				{false, ErrorCode} -> {false, ErrorCode, Player}
			end;
        {false, ErrorCode2, NewPlayer} -> {false, ErrorCode2, NewPlayer}
    end.

%%背饰升阶
upgrade_stage(Player, DecorationID) ->
	DecorationStatus = Player#player_status.back_decoration_status,
	DecorationList   = DecorationStatus#back_decoration_status.back_decoration_list,
	%?PRINT("============upgrade_begin ~p ~n", [DecorationID]),
	case check_upgrade_decoration_cost(Player, DecorationList, DecorationID) of 
		{true, DecorationCfg} -> do_upgrade_stage(Player, DecorationCfg);
		{false, ErrorCode} -> 
			%?PRINT("============upgrade_fail ~p ~n", [ErrorCode]),
			{false, ErrorCode, Player}
	end.

do_upgrade_stage(Player, DecorationCfg) ->
	#player_status{sid = Sid, id = RoleId, original_attr = OriginAttr, figure = Figure} = Player,
	#base_back_decoration{cost = Cost} = DecorationCfg,%%升级消耗，下一等级的配置
	case lib_goods_api:cost_object_list_with_check(Player, Cost, back_decoration_upgrade_stage, "") of
		{true, NewPlayerTmp} ->
			%记录日志
			DecorationStatus = NewPlayerTmp#player_status.back_decoration_status,
			case replace_decoration(RoleId, DecorationCfg, DecorationStatus) of
				{ok, NewDecoration, NewDecorationStatus} ->
					#back_decoration{back_decoration_id = NewDecorationId, stage = Stage, state = State} = NewDecoration,
					NewPlayer  =  NewPlayerTmp#player_status{back_decoration_status = NewDecorationStatus},
					lib_log_api:log_back_decoration(RoleId, Figure#figure.name, NewDecorationId, ?UPGRADE_DEC, Stage - 1, Stage, Cost),
					%% 根据实际情况是否广播，如果当前升级的背饰是幻化中的且改变了形象则广播
					NewPlayerTmp2 = judge_status_broadcast(NewPlayer, NewDecoration),
					%战力发送
					LastPlayer = lib_player:count_player_attribute(NewPlayerTmp2),
					lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
					%%发送升阶成功后的信息给客户端
					{Attr, Combat, Skill} = get_attr_combat_skill(NewDecorationId, Stage, OriginAttr),
					{ok, BinData} = pt_141:write(14105, [?SUCCESS, NewDecorationId, Stage, State, [SkillId || {SkillId, _} <- Skill], Attr, Combat]),
					lib_server_send:send_to_sid(Sid, BinData),
					%?PRINT("-=-=-=-=-=-=~p[~p]:addSkill:~p ~n", [?MODULE, ?LINE,Skill]),
					mod_scene_agent:update(LastPlayer, [{passive_skill, Skill}, {battle_attr, LastPlayer#player_status.battle_attr}]),
					%?PRINT("============upgrade_success ~p ~n", [NewDecoration]),
					{true, LastPlayer};	
				{false, ErrorCode} -> {false, ErrorCode, Player}
			end;
        {false, ErrorCode2, NewPlayer} -> {false, ErrorCode2, NewPlayer}
    end.

%%获取背饰默认战力
get_default_decoration(Player, DecorationId) ->
	#player_status{sid = Sid, original_attr = OriginAttr} = Player,
	StarCombat = get_expact_combat(DecorationId, 0, OriginAttr),
	{ok, BinData} = pt_141:write(14106, [DecorationId, StarCombat]),
	lib_server_send:send_to_sid(Sid, BinData).

%%当调用翅膀幻化的时候调用
%%取消背饰的幻化
cancel_illusion(Player) ->
	DecorationStatus = Player#player_status.back_decoration_status,
	DecorationList   = DecorationStatus#back_decoration_status.back_decoration_list,
	case lists:keyfind(1, #back_decoration.state, DecorationList) of 
		Decoration = #back_decoration{back_decoration_id = DecorationId, stage = Stage, state = 1} ->
			NewDecList   = lists:keystore(1, #back_decoration.state, DecorationList, Decoration#back_decoration{state = 0}),
			db_upd_decoration(Player#player_status.id, DecorationId, Stage, 0, 0),
			NewDecStatus = DecorationStatus#back_decoration_status{back_decoration_list = NewDecList},
			NewPlayer    = Player#player_status{back_decoration_status = NewDecStatus},
			%?PRINT("=============current_back_decoration_state_list: ~p ~n", [NewDecList]),
			%广播给同一场景的玩家
			broadcast_to_scene(NewPlayer, Decoration, cancel),
			LastPlayer = upd_figure(NewPlayer, ?BACK_DECROTEION_TYPE_ID, cancel, get_figure_id(Decoration)),
			{ok, LastPlayer};
		_ -> {ok, Player}
	end.

%% gm命令，清空所有背饰
gm_clear_decoration(Player) ->
	#player_status{
    	id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y, figure = Figure} = Player,
    % 广播去掉背饰
    {ok, BinData} = pt_141:write(14100, [?BACK_DECROTEION_TYPE_ID, RoleId, ?NOTRIDE, 0, 0]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
	NewFigure = Figure#figure{back_decora_figure = [], back_decora_figure_ride = []},
	NewPlayer = Player#player_status{back_decoration_status = #back_decoration_status{}, figure = NewFigure},
	%更新场景信息
	mod_scene_agent:update(NewPlayer, [{back_decora_figure, []}, {back_decora_figure_ride, []}]),
    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
	db_gm_clear_decoration(RoleId),
	NewPlayer.


%%-------------------------------------------私有函数------------------------------------------------%%

%% 获取技能战力
get_skill_power([]) -> 
	{[], 0};
get_skill_power([{SkillId, Lv}]) ->
	case data_skill:get_lv_data(SkillId, Lv) of 
		#skill_lv{power = Power} -> {[{SkillId, Lv}],Power};
		_ ->  
			{[{SkillId, Lv}],0}
	end;
get_skill_power(_) ->  
	{[],0}.

get_figure_id(Decoration) when is_record(Decoration, back_decoration) ->
	#back_decoration{back_decoration_id = Id, active_stage = ActiveStage} = Decoration,
	case data_back_decoration:get_decoration_cfg(Id, ActiveStage) of
		#base_back_decoration{figure_id = FigureId} -> FigureId;
		_ -> 0
	end;
get_figure_id(_) -> 0.

%%更新figure，一般调用完广播之后再调用该函数
%%更新玩家自身的figure同时还要更新ets里的figure
upd_figure(Player, TypeId, illusion, FigureId) ->
	do_upd_figure(Player, TypeId, ?ISRIDE, FigureId);
upd_figure(Player, TypeId, _, FigureId) ->
	do_upd_figure(Player, TypeId, ?NOTRIDE, FigureId).

do_upd_figure(Player, TypeId, ?ISRIDE, FigureId) ->
	#player_status{figure = Figure, id = RoleId} = Player,
	#figure{back_decora_figure = DecoraFigure, back_decora_figure_ride = DecoraFigureRide} = Figure,
	NewDecoraFigure = lists:keystore(TypeId, 1, DecoraFigure, {TypeId, FigureId, 0}),
	NewDecoraFigureRide = lists:keystore(TypeId, 1, DecoraFigureRide, {TypeId, ?ISRIDE}),
	NewFigure = Figure#figure{back_decora_figure = NewDecoraFigure, back_decora_figure_ride = NewDecoraFigureRide},
	NewPlayer = Player#player_status{figure = NewFigure},
	mod_scene_agent:update(NewPlayer, [{back_decora_figure, NewDecoraFigure}, {back_decora_figure_ride, NewDecoraFigureRide}]),
    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
	NewPlayer;
do_upd_figure(Player, _TypeId, ?NOTRIDE, _FigureId) ->
	#player_status{figure = Figure, id = RoleId} = Player,
	NewDecoraFigure = [],
	NewDecoraFigureRide = [],
	NewFigure = Figure#figure{back_decora_figure = NewDecoraFigure, back_decora_figure_ride = NewDecoraFigureRide},
	%?PRINT("==back_decora_figure:~p, back_decora_figure_ride:~p ~n",[NewDecoraFigure, NewDecoraFigureRide]),
	NewPlayer = Player#player_status{figure = NewFigure},
	mod_scene_agent:update(NewPlayer, [{back_decora_figure, NewDecoraFigure}, {back_decora_figure_ride, NewDecoraFigureRide}]),
    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
	NewPlayer.

%% 我穿的是A 从A1强化到a2 形象进阶 切
%% 穿的是A 激活B 切B
%% 穿的是A 进阶B 不切
%% Decoration升级之后的背饰
judge_status_broadcast(Player, Decoration) -> 
	#player_status{back_decoration_status = DecorationStatus, id = RoleId} = Player,
	#back_decoration{back_decoration_id = NewId, stage = NewStage} = Decoration,
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	case lists:keyfind(1, #back_decoration.state, DecorationList) of 
		CurrentDecoration = #back_decoration{back_decoration_id = NewId} ->%%升级当前背饰(注意这个背饰记录是已经修改过的)
			#base_back_decoration{figure_id = NewFigureId} =  data_back_decoration:get_decoration_cfg(NewId, NewStage),
			#base_back_decoration{figure_id = OldFigureId} =  data_back_decoration:get_decoration_cfg(NewId, NewStage - 1),
			if 
				NewFigureId =/= OldFigureId ->
					%?PRINT("figure not equal change figureid~n", []),
					db_upd_decoration(RoleId, NewId, NewStage, 1, NewStage),
					NewDecoration = CurrentDecoration#back_decoration{active_stage = NewStage},
					broadcast_to_scene(Player, NewDecoration, illusion),
					%修改幻化状态
					NewPlayer = upd_figure(Player, ?BACK_DECROTEION_TYPE_ID, illusion, NewFigureId),
					NewList = lists:keystore(NewId, #back_decoration.back_decoration_id, DecorationList, NewDecoration),
					NewStaus = DecorationStatus#back_decoration_status{back_decoration_list = NewList},
					NewPlayer#player_status{back_decoration_status = NewStaus};
				true -> %%
					%?PRINT("figure equal not change figureid ~p ~p ~p ~p ~n", [NewFigureId, OldFigureId, NewStage, NewStage - 1]),
					db_update_simple(RoleId, NewId, NewStage),
					Player
			end;
		_ -> %其他情况
			db_update_simple(RoleId, NewId, NewStage),
			Player
	end.


%%获得背饰的属性，战力，技能
get_attr_combat_skill(DecorationID, Stage, OriginAttr) ->
	{FAttr, Skill} = case data_back_decoration:get_decoration_cfg(DecorationID, Stage) of 
		#base_back_decoration{attr = Attr, skill = Ski} -> {Attr, Ski};
		_ -> {[], []}
	end,
	{_,SkillPower} = get_skill_power(Skill),
    StarCombat = lib_player:calc_partial_power(OriginAttr, SkillPower, FAttr),
	{FAttr, StarCombat, Skill}.

%%获得背饰的期望战力
get_expact_combat(DecorationID, Stage, OriginAttr) ->
	{FAttr, Skill} = case data_back_decoration:get_decoration_cfg(DecorationID, Stage) of 
		#base_back_decoration{attr = Attr, skill = Ski} -> {Attr, Ski};
		_ -> {[], []}
	end,
	{_,SkillPower} = get_skill_power(Skill),
    StarCombat = lib_player:calc_expact_power(OriginAttr, SkillPower, FAttr),
	StarCombat.

%%背饰发生变化，广播给其他玩家
%%广播完成之后都需要调用:upd_figure
broadcast_to_scene(Player, Decoration, illusion) ->
	#player_status{
    	id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y} = Player,
    #back_decoration{back_decoration_id = DecorationID, active_stage = Active_Stage} = Decoration,
    case data_back_decoration:get_decoration_cfg(DecorationID, Active_Stage) of 
    	#base_back_decoration{figure_id = FigureID} ->
    		{ok, BinData} = pt_141:write(14100, [?BACK_DECROTEION_TYPE_ID, RoleId, ?ISRIDE, FigureID, 0]),
    		lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData);
    		%?PRINT("==illusion=====broadcast figureid:~p, poolid: ~p, x:~p, y:~p,stage:~p ~n", [FigureID, PoolId, X, Y, Active_Stage]);
    	[] -> skip
    end,
    ok;
broadcast_to_scene(Player, Decoration, cancel) ->
	#player_status{
    	id = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x = X, y = Y} = Player,
    #back_decoration{back_decoration_id = DecorationID, active_stage = Active_Stage} = Decoration,
    case data_back_decoration:get_decoration_cfg(DecorationID, Active_Stage) of 
    	#base_back_decoration{} ->
    		{ok, BinData} = pt_141:write(14100, [?BACK_DECROTEION_TYPE_ID, RoleId, ?NOTRIDE, 0, 0]),
    		lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData);
    		%?PRINT("==cancel=====broadcast figureid:~p, poolid: ~p, x:~p, y:~p,stage:~p ~n", [0, PoolId, X, Y, Active_Stage]);
    	[] -> skip
    end,
    ok;
broadcast_to_scene(_Player, _Decoration, _) -> ok.

%%改变幻化(未添加事务)
change_illusion(Player, DecorationStatus, DecorationID, Stage) ->
	RoleId = Player#player_status.id,
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	case lists:keyfind(DecorationID, #back_decoration.back_decoration_id, DecorationList) of 
		false -> {false, ?ERRCODE(err_141_no_decoration)};
		BeIllusionDecoration -> %当前幻化的阶数和请求幻化不一致，进行幻化
			case lists:keyfind(1, #back_decoration.state, DecorationList) of
				false -> 
					NewDecoration = BeIllusionDecoration#back_decoration{state = 1, active_stage = Stage},
					NewDecorationList = lists:keystore(DecorationID, #back_decoration.back_decoration_id, DecorationList, NewDecoration),
					db_upd_decoration(RoleId, DecorationID, NewDecoration#back_decoration.stage, 1, Stage),
					NewDecorationStatus = DecorationStatus#back_decoration_status{back_decoration_list = NewDecorationList},
					{true, NewDecoration, NewDecorationStatus,illusion};
				%% 没有其他背饰幻化 或者 同一类型之间幻化，直接修改即可
				#back_decoration{back_decoration_id = DecorationID, active_stage = Stage} -> 
					NewDecoration = BeIllusionDecoration#back_decoration{state = 1, active_stage = Stage},
					NewDecorationList = lists:keystore(DecorationID, #back_decoration.back_decoration_id, DecorationList, NewDecoration),
					db_upd_decoration(RoleId, DecorationID, NewDecoration#back_decoration.stage, 1, Stage),
					NewDecorationStatus = DecorationStatus#back_decoration_status{back_decoration_list = NewDecorationList},
					{true, NewDecoration, NewDecorationStatus,illusion};
				%% 不同类型幻化，先修改之前的幻化再幻化当前请求的
				Decoration = #back_decoration{back_decoration_id = ID} ->
					List1 = lists:keystore(ID, #back_decoration.back_decoration_id, DecorationList,Decoration#back_decoration{state = 0, active_stage = 0}),
					db_upd_decoration(RoleId, ID, Decoration#back_decoration.stage, 0, 0),
					%再幻化新的背饰
					NewDecoration = BeIllusionDecoration#back_decoration{state = 1, active_stage = Stage},
					NewDecorationList = lists:keystore(DecorationID, #back_decoration.back_decoration_id, List1, NewDecoration),
					db_upd_decoration(RoleId, DecorationID, NewDecoration#back_decoration.stage, 1, Stage),
					NewDecorationStatus = DecorationStatus#back_decoration_status{back_decoration_list = NewDecorationList},
					%?PRINT("==========change_illusion111 ~n", []),
					{true, NewDecoration, NewDecorationStatus, illusion}
			end
	end.

check_active_decoration_cost(Player, DecorationList, DecorationID) ->
	case lists:keyfind(DecorationID, #back_decoration.back_decoration_id, DecorationList) of 
		#back_decoration{} -> {false, ?ERRCODE(err_141_had_active)};
		false ->
			case data_back_decoration:get_decoration_cfg(DecorationID, 0) of 
				DecorationCfg = #base_back_decoration{cost = Cost} ->
					case lib_goods_api:check_object_list(Player, Cost) of
						true -> {true, DecorationCfg};
						{false, ErrorCode} -> {false, ErrorCode}
					end;
				_ -> {false, ?ERRCODE(err_141_error_cfg)}
			end
	end.

check_upgrade_decoration_cost(Player, DecorationList, DecorationID) ->
	case lists:keyfind(DecorationID, #back_decoration.back_decoration_id, DecorationList) of 
		#back_decoration{stage = Stage} -> 
			case data_back_decoration:get_decoration_cfg(DecorationID, Stage+1) of 
				DecorationCfg = #base_back_decoration{cost = Cost} ->
					case lib_goods_api:check_object_list(Player, Cost) of
						true -> {true, DecorationCfg};
						{false, ErrorCode} -> {false, ErrorCode}
					end;
				[] -> {false, ?ERRCODE(err_141_max_stage)}
			end;
		false -> {false, ?ERRCODE(err_141_had_no_active)}
	end.

%% 根据背饰配置获取新的配置（当激活升级时调用），并且返回新的Status
%% DecorationCfg下一等级的配置
replace_decoration(RoleId, DecorationCfg, DecorationStatus) when is_record(DecorationStatus, back_decoration_status) ->
	DecorationList = DecorationStatus#back_decoration_status.back_decoration_list,
	ID = DecorationCfg#base_back_decoration.back_decoration_id,
	NewStage = DecorationCfg#base_back_decoration.stage,
	case lists:keyfind(ID, #back_decoration.back_decoration_id, DecorationList) of 
		false -> % 激活
			NewDecoration = #back_decoration{stage = 0, state = 1, back_decoration_id = ID, active_stage = 0},
			case lists:keyfind(1, #back_decoration.state, DecorationList) of
				false ->% 没有幻化其他背饰
					NewDecorationList = lists:keystore(ID, #back_decoration.back_decoration_id, DecorationList, NewDecoration),
					NewDecorationStatus = cal_decoration_status(NewDecorationList),
					{ok, NewDecoration, NewDecorationStatus};
				Decoration1 = #back_decoration{back_decoration_id = BId, stage = Stage} -> % 幻化了其他背饰
					Decoration2 = Decoration1#back_decoration{state = 0, active_stage = 0},
					db_upd_decoration(RoleId, BId, Stage, 0, 0),
					NewDecorationList1 = lists:keystore(BId, #back_decoration.back_decoration_id, DecorationList, Decoration2),
					NewDecorationList2 = lists:keystore(ID, #back_decoration.back_decoration_id, NewDecorationList1, NewDecoration),
					NewDecorationStatus = cal_decoration_status(NewDecorationList2),
					{ok, NewDecoration, NewDecorationStatus}
			end;
		Decoration -> %%升级
			NewDecoration = Decoration#back_decoration{stage = NewStage},
			NewDecorationList = lists:keystore(ID, #back_decoration.back_decoration_id, DecorationList, NewDecoration),
			NewDecorationStatus = cal_decoration_status(NewDecorationList),
			{ok, NewDecoration, NewDecorationStatus}
	end;
replace_decoration(_RoleId, _DecorationCfg, _DecorationStatus) -> {false, ?FAIL}.

become_record([ID, Stage, State, ActiveStage]) ->
	#back_decoration{back_decoration_id = ID, stage = Stage, state = State, active_stage = ActiveStage}.


%%------------------------------------db------------------------------------%%
db_get_decoration_all(RoleId) ->
	List = db:get_all(io_lib:format(?sql_select_all_back_decocation, [RoleId])),
	DecorationList = [become_record(X) || X <- List],
	DecorationList.

db_upd_decoration(RoleId, DecorationID, Stage, State, ActiveStage) -> 
	db:execute(io_lib:format(?sql_upd_back_decocation, [RoleId, DecorationID, Stage, State, ActiveStage])).

db_update_simple(RoleId, DecorationID, Stage) ->
	db:execute(io_lib:format(?sql_upd_simple, [Stage, DecorationID, RoleId])).

db_insert_decoration(RoleId, DecorationID, Stage, State, ActiveStage) ->
	db:execute(io_lib:format(?sql_insert_back_decocation, [RoleId, DecorationID, Stage, State, ActiveStage])).

db_gm_clear_decoration(RoleId) ->
	db:execute(io_lib:format(?gm_sql_clear_back_decocation, [RoleId])).

