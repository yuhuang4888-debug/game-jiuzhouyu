-module(pp_c_sanctuary).

-include("figure.hrl").
-include("cluster_sanctuary.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_module.hrl").

-export([
		handle/3
	]).

handle(Cmd, Player, Args) -> 
	#player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,	
	case data_cluster_sanctuary:get_san_value(open_lv) of
		LimitLv when is_integer(LimitLv) andalso Lv >= LimitLv ->
			case do_handle(Cmd, Player, Args) of
				{ok, NewPlayer} when is_record(NewPlayer, player_status) -> {ok, NewPlayer};
				_ -> {ok, Player}
			end;
		_ ->
			send_error(RoleId, ?ERRCODE(lv_limit)),
			{ok, Player}
	end.

send_error(RoleId, Code) -> 
	{ok, BinData} = pt_284:write(28414, [Code]),
   	lib_server_send:send_to_uid(RoleId, BinData).

%% 界面数据
do_handle(28400, Player, []) ->
	#player_status{id = RoleId, server_id = ServerId} = Player,
    % ?PRINT("=========== Openday:~p~n",[28400]),
	% Node = node(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            ?PRINT("=========== Openday:~p~n",[Openday]),skip;
        true ->
            % mod_c_sanctuary:get_info(ServerId, Node, RoleId)
            mod_c_sanctuary_local:get_info(ServerId, RoleId)
    end,
	% ?PRINT("28400 ~p~n",[1]),
	{ok, Player};

%% 获取建筑数据
do_handle(28401, Player, [Scene]) ->
	#player_status{id = RoleId, server_id = ServerId} = Player,
    % ?PRINT("=========== Openday:~p~n",[28401]),
	% Node = node(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            ?PRINT("=========== Openday:~p~n",[Openday]),skip;
        true ->
            % mod_c_sanctuary:get_construction_info(ServerId, Node, RoleId, Scene)
            mod_c_sanctuary_local:get_construction_info(ServerId, RoleId, Scene)
    end,
	{ok, Player};

%% 获取排行榜数据
do_handle(28403, Player, [Scene, MonId]) ->
	#player_status{id = RoleId, server_id = ServerId} = Player,
	% Node = node(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            ?PRINT("=========== Openday:~p~n",[Openday]),skip;
        true ->
            % mod_c_sanctuary:get_rank_info(ServerId, Node, RoleId, Scene, MonId)
            mod_c_sanctuary_local:get_rank_info(ServerId, RoleId, Scene, MonId)
    end,
	{ok, Player};

%% 进入
do_handle(28404, Player, [Scene]) ->
    % ?PRINT("Scene:~p~n",[Scene]),
	#player_status{id = RoleId, server_id = ServerId, scene = SceneId} = Player,
	case check_before_enter(Player, Scene) of
        {false, Code} ->
            NewPlayer = Player,
            {ok, BinData} = pt_284:write(28404, [Code]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            Node = node(),
            NeedOut = lib_boss:is_in_outside_scene(SceneId),
            NewPlayer = Player#player_status{action_lock = {utime:unixtime() + 5, ?ERRCODE(err284_enter_cluster)}},
            mod_c_sanctuary:enter(ServerId, Node, RoleId, Scene, NeedOut)
    end,
    {ok, NewPlayer};

% 个人积分奖励状态
do_handle(28405, Player, []) ->
	#player_status{id = RoleId, kf_sanctuary_info = KfSanInfo} = Player,
	#kf_sanctuary_info{paied = Paied, anger = Anger, score = Score, score_status = ScoreStage, clear_time = ClearTime} = KfSanInfo,
	NewScoreStage =lib_c_sanctuary:calc_role_score_reward(Score, ScoreStage, Paied),
	if
		NewScoreStage == ScoreStage ->
			NewKfSanInfo = KfSanInfo;
		true ->
			NScoreStage = util:term_to_string(NewScoreStage),
		    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, Paied, Anger, Score, ClearTime, NScoreStage])),
			NewKfSanInfo = KfSanInfo#kf_sanctuary_info{score_status = NewScoreStage}
	end,
    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(NewScoreStage),
	{ok, BinData} = pt_284:write(28405, [Score, Paied, Anger, SendScoreStage]),
	% ?MYLOG("xlh","SAN ROLE_info:~p~n",[{Score, Paied, Anger, ScoreStage}]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, Player#player_status{kf_sanctuary_info = NewKfSanInfo}};

%% 解锁个人积分后续奖励
do_handle(28406, Player, []) ->
	#player_status{id = RoleId, kf_sanctuary_info = KfSanInfo, 
			server_id = ServerId, server_num = ServerNum,
			figure = #figure{name = RoleName}} = Player,
	#kf_sanctuary_info{paied = Paied, anger = Anger, score = Score, score_status = ScoreStage, clear_time = ClearTime} = KfSanInfo,
	if
		Paied == 0 ->
			Cost = data_cluster_sanctuary:get_san_value(unlock_stage_reward),
			case lib_goods_api:cost_objects_with_auto_buy(Player, Cost,  kf_sanctuary_satge, "") of
		        {false, Code, NewPs} ->
		            NewKfSanInfo = KfSanInfo;
		        {true, NewPs,_} ->
					NewScoreStage =lib_c_sanctuary:calc_role_score_reward(Score, ScoreStage, 1),
					NewKfSanInfo = KfSanInfo#kf_sanctuary_info{paied = 1, score_status = NewScoreStage},
		        	lib_log_api:log_kf_score_reward(ServerId, ServerNum, RoleId, RoleName, Score, 1, []),
                    SendScoreStage = lib_c_sanctuary:transform_stage_state_for_client(NewScoreStage),
		        	{ok, Bin} = pt_284:write(28405, [Score, 1, Anger, SendScoreStage]),
					lib_server_send:send_to_uid(RoleId, Bin),
		        	NScoreStage = util:term_to_string(NewScoreStage),
		        	db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, 1, Anger, Score, ClearTime, NScoreStage])),
		        	Code = 1
		    end;
		true ->
			NewPs = Player,
			NewKfSanInfo = KfSanInfo,
			Code = ?ERRCODE(has_unlocked)
	end,
    {ok, BinData} = pt_284:write(28406, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs#player_status{kf_sanctuary_info = NewKfSanInfo}};

%% 退出
do_handle(28407, Player, []) ->
	{IsOut, ErrCode} = lib_scene:is_transferable_out(Player),
    case IsOut of
        true ->
        	#player_status{id = RoleId, server_id = ServerId, scene = Scene} = Player, %% 可以切换pk状态的场景在退出时都需要将pk状态设置为和平模式
        	case data_scene:get(Scene) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
                    NewPs = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100}, 
                    {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
                    % NewPs = lib_scene:change_default_scene(Player, [{group, 0},{collect_checker, undefined},
                    %       {change_scene_hp_lim, 100},{pk, {?PK_PEACE, true}}]),
                    mod_c_sanctuary:exit(ServerId, RoleId, Scene);
                _ ->
                    NewPs = Player
            end;
        false ->
            NewPs = Player
    end,
    {ok, BinData} = pt_284:write(28407, [ErrCode]),
    lib_server_send:send_to_uid(NewPs#player_status.id, BinData),
    {ok, NewPs};

%% 领取归属奖励
do_handle(28408, Player, [Scene]) ->
	#player_status{id = RoleId, server_id = ServerId} = Player,
	Node = node(),
	mod_c_sanctuary:recieve_bl_reward(RoleId, Node, ServerId, Scene),
	{ok, Player};

%% 领取积分奖励
do_handle(28409, Player, [Score]) ->
	#player_status{id = RoleId, kf_sanctuary_info = KfSanInfo, 
			server_id = ServerId, server_num = ServerNum,
			figure = #figure{name = RoleName}} = Player,
	#kf_sanctuary_info{score_status = ScoreStage, paied = Paied, anger = Anger, score = TScore, clear_time = ClearTime} = KfSanInfo,
    case data_cluster_sanctuary:get_id_by_score(Score) of
        [Id] ->
            case lists:keyfind(Id, 1, ScoreStage) of
                {Id, ?HAS_ACHIEVE} ->
                    case data_cluster_sanctuary:get_score_cfg(Score) of
                        #base_san_score{reward = Reward} ->
                            Code = 1,
                            NStage = lists:keystore(Id,1, ScoreStage, {Id, ?HAS_RECIEVE}),
                            NewPlayer = Player#player_status{kf_sanctuary_info = KfSanInfo#kf_sanctuary_info{score_status = NStage}},
                            NewStage = util:term_to_string(NStage), 
                            db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, Paied, Anger, TScore, ClearTime, NewStage])),
                            lib_log_api:log_kf_score_reward(ServerId, ServerNum, RoleId, RoleName, Score, Paied, Reward),
                            LastPlayer = lib_goods_api:send_reward(NewPlayer, Reward, kf_sanctuary_score, 0);
                        _ ->
                            Code = ?ERRCODE(error_data),
                            LastPlayer = Player
                    end;
                {Score, ?HAS_RECIEVE} ->
                    Code = ?ERRCODE(has_recieve),
                    LastPlayer = Player;
                _ ->
                    Code = ?ERRCODE(not_achieve),
                    LastPlayer = Player
            end;
        _ ->
            Code = ?ERRCODE(error_data),
            LastPlayer = Player
    end,
	{ok, BinData} = pt_284:write(28409, [Score, Code]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, LastPlayer};

do_handle(28410, Player, []) ->
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            ?PRINT("=========== Openday:~p~n",[Openday]),skip;
        true ->
            mod_c_sanctuary_local:get_act_opentime(Player#player_status.id)
    end,
	{ok, Player};

do_handle(28412, Player, [Scene, MonId]) ->
	#player_status{id = RoleId} = Player,
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            ?PRINT("=========== Openday:~p~n",[Openday]),skip;
        true ->
            mod_c_sanctuary_local:get_mon_pk_log(RoleId, Scene, MonId)
    end,
	{ok, Player};

do_handle(28415, Player, []) ->
	#player_status{id = RoleId, kf_sanctuary_info = KfSanInfo} = Player,
	#kf_sanctuary_info{die_time_list = DieList, die_time = DieTime, buff_end = BuffEndTime} = KfSanInfo,
	case data_cluster_sanctuary:get_boss_type_kv(revive_point_gost) of
        TimeCfg2 when is_integer(TimeCfg2) andalso TimeCfg2 > 0 -> TimeCfg2;
        _ -> TimeCfg2 = 20
    end,
	DieTimes = erlang:length(DieList),
    {RebornTime, MinTimes} =lib_c_sanctuary:count_die_wait_time(DieTimes, DieTime),
    if
        DieTimes > MinTimes ->
            lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, RebornTime, BuffEndTime, DieTime + TimeCfg2]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, RebornTime, BuffEndTime, 0])
    end,
    {ok, Player};

do_handle(28419, Player, []) ->
    #player_status{id = RoleId} = Player,
    % Node = node(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            skip;
        true ->
            % mod_c_sanctuary:get_rank_info(ServerId, Node, RoleId, Scene, MonId)
            mod_c_sanctuary_local:get_point_rank_info(RoleId)
    end;

do_handle(28420, Player, []) ->
    #player_status{id = RoleId} = Player,
    % Node = node(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            skip;
        true ->
            % mod_c_sanctuary:get_rank_info(ServerId, Node, RoleId, Scene, MonId)
            mod_c_sanctuary_local:get_auction_produce_end_time(RoleId)
    end;

do_handle(_, Player, _) -> {ok, Player}.

check_before_enter(Player, Scene) ->
    List = [{gm_close}, {action_lock}, {scene, Scene}, {change_other_scene}, {scene_type, Scene}],
    check_before_enter_help(Player, List).

check_before_enter_help(Player, [{gm_close}|T]) ->
    case lib_gm_stop:check_gm_close_act(?MOD_C_SANCTUARY, 0) of
        true -> check_before_enter_help(Player, T);
        _ -> {false, ?ERR_GM_STOP}
    end;
check_before_enter_help(Player, [{action_lock}|T]) ->
    #player_status{action_lock = ActionLock} = Player,
    Lock = ?ERRCODE(err284_enter_cluster),
    Now = utime:unixtime(),
    case ActionLock of
        Lock -> {false, Lock};
        {Time, Lock} -> 
            if
                Now >= Time ->
                    check_before_enter_help(Player, T);
                true ->
                    {false, Lock}
            end;
        _ -> check_before_enter_help(Player, T)
    end;
check_before_enter_help(Player, [{scene, Scene}|T]) ->
    #player_status{scene = SceneId} = Player,
    if
        SceneId == Scene ->
            {false, ?ERRCODE(already_in_scene)};
        true ->
            check_before_enter_help(Player, T)
    end;
check_before_enter_help(Player, [{change_other_scene}|T]) ->
    case lib_boss:chang_other_mod_scene(Player) of
        {false, ErCode} -> {false, ErCode};
        _ -> check_before_enter_help(Player, T)
    end;
check_before_enter_help(Player, [{scene_type, Scene}|T]) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            check_before_enter_help(Player, T);
        _ ->
            {false, ?ERRCODE(err186_error_data)}
    end;
check_before_enter_help(_Player, []) -> true.

