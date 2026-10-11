%%%--------------------------------------
%%% @Module  : pp_holy_ghost
%%% @Author  : fwx
%%% @Created : 2018.5.28
%%% @Description:  圣灵
%%%--------------------------------------
-module(pp_holy_ghost).

-export([handle/3, send_error/2, broadcast_to_scene/1]).

-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("holy_ghost.hrl").
-include("def_module.hrl").

%% 圣灵信息
handle(Cmd = 60602, Player, _Data) ->
    #player_status{sid = Sid, holy_ghost = StatuHG} = Player,
    #status_holy_ghost{
        ghost      = GhostL,
        ghost_illu = IlluL,
        fight_id   = FightId,
        illus_id   = IlluId,
        display    = Display
    } = StatuHG,
    SendGL = [{Id, Stage, Lv} || #ghost{id = Id, stage = Stage, lv = Lv} <- GhostL],
    SendIL = [Id || #ghost_illu{id = Id} <- IlluL],
    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [FightId, IlluId, SendGL, SendIL, Display]);

%% 单个圣灵
handle(Cmd = 60603, Player, [Id]) ->
    #player_status{sid = Sid, holy_ghost = StatuHG} = Player,
    #status_holy_ghost{ghost = GhostL} = StatuHG,
    case lists:keyfind(Id, #ghost.id, GhostL) of
        #ghost{stage = Stage, exp = Exp, lv = Lv, attr = Attr, combat = Combat} ->
            lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Id, Stage, Exp, Lv, Attr, Combat]);
        _ -> skip
    end;

%% 单个幻形
handle(Cmd = 60604, Player, [IlluId]) ->
    #player_status{sid = Sid, holy_ghost = StatuHG} = Player,
    #status_holy_ghost{ghost_illu = IlluL} = StatuHG,
    case lists:keyfind(IlluId, #ghost_illu.id, IlluL) of
        #ghost_illu{active_time = AcTimeStamp, effect_time = EffectTime, attr = Attr, combat = Combat} ->
            FinalTime = AcTimeStamp + EffectTime + 60 - ((AcTimeStamp + EffectTime)rem 60 ) ,
            lib_server_send:send_to_sid(Sid, pt_606, Cmd, [IlluId, FinalTime, Attr, Combat]);
        _ -> skip
    end;

%% 遗迹充能次数
handle(Cmd = 60605, Player, _) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    GIds = data_holy_ghost:get_relic_good_ids(),
    CounterL = mod_counter:get_count(RoleId, ?MOD_HOLY_GHOST, GIds),
    F = fun
            ({GId, Count}) ->
                {RelicId, MaxTimes} = lib_holy_ghost:get_relic_max_times(GId, RoleLv),
                {GId, RelicId, Count, MaxTimes}
        end,
    SendL = [F(T) || T <- CounterL],
    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [SendL]);

%% 圣灵激活
handle(Cmd = 60606, Player, [Id]) ->
    NowTime = utime:unixtime(),
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{ghost = GhostL} = StatusHG,
    case lib_module:is_open(?MOD_HOLY_GHOST, 1, RoleLv) of
        true ->
            case lists:keymember(Id, #ghost.id, GhostL) of
                true ->
                    NewPlayer = Player,
                    send_error(Sid, ?ERRCODE(err606_already_active));
                false ->
                    case data_holy_ghost:get_holy_ghost(Id) of
                        #base_holy_ghost{active_cost = [], name = GhostName} ->
                            Ghost = #ghost{
                                id          = Id,
                                stage       = 1,
                                active_time = NowTime
                            },
                            NewGhostL = [Ghost | GhostL],
                            NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{ghost = NewGhostL}),
                            {ok, _, NewPlayerTmp} = pp_holy_ghost:handle(60611, Player#player_status{holy_ghost = NewStatusHG}, [1, Id]),
                            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
                            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                            db:execute(io_lib:format(?sql_replace_holy_ghost, [RoleId, Id, 1, 0, 0, NowTime])),
                            lib_log_api:log_holy_ghost_active(RoleId, GhostName, []),
                            lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Id]);
                        #base_holy_ghost{active_cost = Cost, name = GhostName} ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, holy_ghost, "") of
                                {true, PlayerTmp} ->
                                    Ghost = #ghost{
                                        id          = Id,
                                        stage       = 1,
                                        active_time = NowTime
                                    },
                                    NewGhostL = [Ghost | GhostL],
                                    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{ghost = NewGhostL}),
                                    {ok, _, NewPlayerTmp} = pp_holy_ghost:handle(60611, PlayerTmp#player_status{holy_ghost = NewStatusHG}, [1, Id]),
                                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    db:execute(io_lib:format(?sql_replace_holy_ghost, [RoleId, Id, 1, 0, 0, NowTime])),
                                    lib_log_api:log_holy_ghost_active(RoleId, GhostName, Cost),
                                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Id]);
                                {false, Code, PlayerTmp} ->
                                    NewPlayer = PlayerTmp,
                                    send_error(Sid, Code)
                            end;
                        _ ->
                            NewPlayer = Player,
                            send_error(Sid, ?ERRCODE(err_config))
                    end
            end;
        _ ->
            NewPlayer = Player,
            send_error(Sid, ?ERRCODE(err606_lv_limit))
    end,
    {ok, battle_attr, NewPlayer};

%% 圣灵升阶
handle(Cmd = 60607, Player, [Id, GoodId]) ->
    #player_status{sid = Sid, id = RoleId, holy_ghost = StatusHG, figure = #figure{name = RoleName}} = Player,
    #status_holy_ghost{ghost = GhostL} = StatusHG,
    [{_, OwnNum}] = lib_goods_api:get_goods_num(RoleId, [GoodId]),
    if
        OwnNum =< 0 -> send_error(Sid, ?ERRCODE(err606_not_enough_cost));
        true ->
            case lists:keyfind(Id, #ghost.id, GhostL) of
                #ghost{stage = Stage, exp = Exp, lv = Lv, active_time = Actime} = Ghost ->
                    case data_holy_ghost:get_holy_ghost_stage(Id, Stage + 1) of
                        #base_holy_ghost_stage{} ->
                            case data_holy_ghost:get_holy_ghost(Id) of
                                #base_holy_ghost{stage_cost = StageCost, name = GhostName} ->
                                    case lists:keyfind(GoodId, 1, StageCost) of
                                        {_, OneExp} ->  % 物品提供经验值
                                            #base_holy_ghost_stage{exp = MaxExp} = data_holy_ghost:get_holy_ghost_stage(Id, Stage),
                                            GoodNum = case Exp + OneExp >= MaxExp of
                                                          true -> 1;
                                                          _ -> min(OwnNum, util:ceil((MaxExp - Exp) / OneExp))
                                                      end,
                                            ExpPlus = OneExp * GoodNum,
                                            case lib_goods_api:cost_object_list_with_check(Player, Cost = [{?TYPE_GOODS, GoodId, GoodNum}], holy_ghost, "") of
                                                {true, PlayerTmp} ->
                                                    {NewStage, NewExp} = do_stage_up_help(Id, Stage, Exp, ExpPlus, MaxExp, RoleName),
                                                    NewGhostL = lists:keystore(Id, #ghost.id, GhostL, Ghost#ghost{stage = NewStage, exp = NewExp}),
                                                    NewStatusHG = lib_holy_ghost:sync_data(PlayerTmp, StatusHG#status_holy_ghost{ghost = NewGhostL}),
                                                    NewPlayer = lib_player:count_player_attribute(PlayerTmp#player_status{holy_ghost = NewStatusHG}),
                                                    db:execute(io_lib:format(?sql_replace_holy_ghost, [RoleId, Id, NewStage, NewExp, Lv, Actime])),
                                                    lib_log_api:log_holy_ghost_stage(RoleId, GhostName, Cost, Stage, Exp, NewStage, NewExp),
                                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Id, NewStage, NewExp]);
                                                {false, ErrCode, PlayerTmp} ->
                                                    NewPlayer = PlayerTmp,
                                                    send_error(Sid, ErrCode)
                                            end;
                                        _ ->
                                            NewPlayer = Player,
                                            send_error(Sid, ?ERRCODE(err_config))
                                    end;
                                _ ->
                                    NewPlayer = Player,
                                    send_error(Sid, ?ERRCODE(err_config))
                            end;
                        _ ->
                            NewPlayer = Player,
                            send_error(Sid, ?ERRCODE(err606_max_stage))
                    end;
                _ ->
                    NewPlayer = Player,
                    send_error(Sid, ?ERRCODE(err606_not_active))
            end,
            {ok, battle_attr, NewPlayer}
    end;

%% 圣灵觉醒
handle(Cmd = 60608, Player, [Id]) ->
    #player_status{sid = Sid, id = RoleId, holy_ghost = StatusHG, figure = #figure{name = _RoleName}} = Player,
    #status_holy_ghost{ghost = GhostL} = StatusHG,
    case lists:keyfind(Id, #ghost.id, GhostL) of
        #ghost{stage = Stage, exp = Exp, lv = Lv, active_time = Actime} = Ghost ->
            case data_holy_ghost:get_holy_ghost_awake(Id, Lv + 1) of
                #base_holy_ghost_awake{cost = Cost} ->
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, holy_ghost, "") of
                        {true, PlayerTmp} ->
                            NewLv = Lv + 1,
                            NewGhostL = lists:keystore(Id, #ghost.id, GhostL, Ghost#ghost{lv = NewLv}),
                            NewStatusHG = lib_holy_ghost:sync_data(PlayerTmp, StatusHG#status_holy_ghost{ghost = NewGhostL}),
                            NewPlayer = lib_player:count_player_attribute(PlayerTmp#player_status{holy_ghost = NewStatusHG}),
                            db:execute(io_lib:format(?sql_replace_holy_ghost, [RoleId, Id, Stage, Exp, NewLv, Actime])),
                            #base_holy_ghost{name = GhostName} = data_holy_ghost:get_holy_ghost(Id),
                            lib_log_api:log_holy_ghost_awake(RoleId, GhostName, Cost, Lv, NewLv),
                            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                            lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Id, NewLv]);
                        {false, ErrCode, PlayerTmp} ->
                            NewPlayer = PlayerTmp,
                            send_error(Sid, ErrCode)
                    end;
                _ ->
                    NewPlayer = Player,
                    send_error(Sid, ?ERRCODE(err606_max_lv))
            end;
        _ ->
            NewPlayer = Player,
            send_error(Sid, ?ERRCODE(err606_not_active))
    end,
    {ok, battle_attr, NewPlayer};

%% 圣灵幻形激活
handle(Cmd = 60609, Player, [IlluId]) ->
    NowTime = utime:unixtime(),
    #player_status{sid = Sid, id = RoleId, holy_ghost = StatusHG, figure = #figure{lv = RoleLv}} = Player,
    #status_holy_ghost{ghost_illu = IlluL} = StatusHG,
    case lib_module:is_open(?MOD_HOLY_GHOST, 1, RoleLv) of
        true ->
            case lists:keyfind(IlluId, #ghost_illu.id, IlluL) of
                false ->
                    case data_holy_ghost:get_holy_ghost_illu(IlluId) of
                        #base_holy_ghost_figure{name = IlluName, active_cost = Cost, effect_time = EffTime} ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, holy_ghost, "") of
                                {true, PlayerTmp} ->
                                    GhostIllu = #ghost_illu{
                                        id          = IlluId,
                                        active_time = NowTime,
                                        effect_time = EffTime
                                    },
                                    NewIlluL = [GhostIllu | IlluL],
                                    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{ghost_illu = NewIlluL}),
                                    {ok, _, NewPlayerTmp} = pp_holy_ghost:handle(60611, PlayerTmp#player_status{holy_ghost = NewStatusHG}, [2, IlluId]),
                                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    lib_player_record:role_func_check_update(RoleId, holyghost_illu, {IlluId, NowTime + EffTime}),
                                    lib_log_api:log_holy_ghost_illu_active(RoleId, IlluName, 0, Cost),
                                    db:execute(io_lib:format(?sql_replace_holy_ghost_illu, [RoleId, IlluId, NowTime, EffTime])),
                                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [IlluId]);
                                {false, ErrCode, PlayerTmp} ->
                                    NewPlayer = PlayerTmp, send_error(Sid, ErrCode)
                            end;
                        _ ->
                            NewPlayer = Player, send_error(Sid, ?ERRCODE(err_config))
                    end;
                #ghost_illu{} ->
                    NewPlayer = Player,  send_error(Sid, ?ERRCODE(err606_already_active))
            end;
        _ ->
            NewPlayer = Player, send_error(Sid, ?ERRCODE(err606_lv_limit))
    end,
    {ok,  battle_attr, NewPlayer};


%% 圣灵出战
%% Type:1圣灵出战 2幻形出战
handle(Cmd = 60611, Player, [Type, Id]) ->
    #player_status{sid = Sid, id = RoleId, holy_ghost = StatusHG, figure = Figure} = Player,
    #status_holy_ghost{ghost = GhostL, ghost_illu = IlluL, fight_id = FightId, illus_id = IlluId, display = Display, bound_ids = BoundIds} = StatusHG,
    case Type of
        1 when Id /= FightId ->
            case lists:keyfind(Id, #ghost.id, GhostL) of
                #ghost{} ->
                    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{fight_id = Id, illus_id = 0}),
                    PlayerTmp = lib_player:count_player_attribute(Player#player_status{holy_ghost = NewStatusHG}),
                    lib_player:send_attribute_change_notify(PlayerTmp, ?NOTIFY_ATTR),
                    NewPlayer = PlayerTmp#player_status{figure = Figure#figure{h_ghost_figure = NewStatusHG#status_holy_ghost.figure_id}},
                    broadcast_to_scene(NewPlayer),
                    #base_holy_ghost{name = GhostName} = data_holy_ghost:get_holy_ghost(Id),
                    lib_log_api:log_holy_ghost_fight(RoleId, GhostName),
                    db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, Id, 0, Display, util:term_to_string(BoundIds)])),
                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Type, Id]);
                _ ->
                    NewPlayer = Player,  send_error(Sid, ?ERRCODE(err606_not_active))
            end;
        2 when Id /= IlluId ->
            case lists:keyfind(Id, #ghost_illu.id, IlluL) of
                #ghost_illu{} ->
                    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{fight_id = 0, illus_id = Id}),
                    PlayerTmp = lib_player:count_player_attribute(Player#player_status{holy_ghost = NewStatusHG}),
                    lib_player:send_attribute_change_notify(PlayerTmp, ?NOTIFY_ATTR),
                    NewPlayer = PlayerTmp#player_status{figure = Figure#figure{h_ghost_figure = NewStatusHG#status_holy_ghost.figure_id}},
                    broadcast_to_scene(NewPlayer),
                    #base_holy_ghost_figure{name = IlluName} = data_holy_ghost:get_holy_ghost_illu(Id),
                    lib_log_api:log_holy_ghost_fight(RoleId, IlluName),
                    db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, 0, Id, Display, util:term_to_string(BoundIds)])),
                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Type, Id]);
                _ ->
                    NewPlayer = Player,  send_error(Sid, ?ERRCODE(err606_not_active))
            end;
        _ ->
            NewPlayer = Player, send_error(Sid, ?ERRCODE(err606_already_illu))
    end,
    {ok, battle_attr, NewPlayer};

%% 遗迹充能
handle(Cmd = 60612, Player, [GId]) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{relic_attr = RelicAttr} = StatusHG,
    OpenLv = lib_module:get_open_lv(?MOD_HOLY_GHOST, 1),
    [{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GId]),
    if
        OwnNum =< 0 -> send_error(Sid, ?ERRCODE(err606_not_enough_cost));
        RoleLv < OpenLv -> send_error(Sid, ?ERRCODE(err606_lv_limit));
        true ->
            case data_holy_ghost:get_holy_ghost_relic(GId) of
                #base_holy_ghost_relic{id = RelicId, attr = Attr} ->
                    Count = mod_counter:get_count_offline(RoleId, ?MOD_HOLY_GHOST, GId),
                    {_, MaxTimes} = lib_holy_ghost:get_relic_max_times(GId, RoleLv),
                    UseNum = min(MaxTimes - Count, OwnNum),
                    case Count < MaxTimes of
                        true ->
                            Cost = [{?TYPE_GOODS, GId, UseNum}],
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, holy_ghost, "") of
                                {true, PlayerTmp} ->
                                    PlusAttr = [{AId, AVal * UseNum} || {AId, AVal} <- Attr],
                                    NewRelicAttr = util:combine_list(PlusAttr ++ RelicAttr),
                                    mod_counter:plus_count(RoleId, ?MOD_HOLY_GHOST, GId, UseNum),
                                    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{relic_attr = NewRelicAttr}),
                                    NewPlayer = lib_player:count_player_attribute(PlayerTmp#player_status{holy_ghost = NewStatusHG}),
                                    #base_holy_ghost_relic_open{name = RelicName} = data_holy_ghost:get_relic_open(RelicId),
                                    lib_log_api:log_holy_ghost_relic(RoleId, RelicName, Cost),
                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [GId]);
                                {false, ErrCode, PlayerTmp} ->
                                    NewPlayer = PlayerTmp, send_error(Sid, ErrCode)
                            end;
                        false ->
                            NewPlayer = Player, send_error(Sid, ?ERRCODE(err606_relic_max_times))
                    end;
                _ -> NewPlayer = Player, send_error(Sid, ?ERRCODE(err_config))
            end,
            {ok, battle_attr, NewPlayer}
    end;

%% 1显示|0隐藏
handle(Cmd = 60613, Player, [Type]) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{ghost = GhostL, ghost_illu = IlluL, fight_id = FightId, illus_id = IlluId, display = Display, bound_ids = BoundIds} = StatusHG,
    if
        Type =/= ?HOLY_GHOST_DISPLAY andalso Type =/= ?HOLY_GHOST_HIDE -> skip;
        Type == Display -> skip;
        GhostL =:= [] andalso IlluL =:= [] -> skip;
        true ->
            NewStatusHG = StatusHG#status_holy_ghost{display = Type},
            NewPlayer = Player#player_status{figure = Figure#figure{h_ghost_display = Type}, holy_ghost = NewStatusHG},
            db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, FightId, IlluId, Type, util:term_to_string(BoundIds)])),
            broadcast_to_scene(NewPlayer),
            lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Type]),
            {ok, NewPlayer}
    end;

%% 结界上阵信息
handle(Cmd = 60614, Player, _) ->
    #player_status{sid = Sid, figure = #figure{lv = _RoleLv}, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{bound_ids = BoundIds} = StatusHG,
    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [BoundIds]);

%% 结界上阵|替换
handle(Cmd = 60615, Player, [Location, Id]) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = _RoleLv}, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{fight_id = FightId, illus_id = IlluId,  display = Display, bound_ids = BoundL} = StatusHG,
    NewBoundL = lists:keystore(Location, 1, BoundL, {Location, Id}),
    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{bound_ids = NewBoundL}),
    NewPlayer = lib_player:count_player_attribute(Player#player_status{holy_ghost = NewStatusHG}),
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, FightId, IlluId, Display, util:term_to_string(NewBoundL)])),
    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Location, Id]),
    {ok, battle_attr, NewPlayer};

%% 结界下阵
handle(Cmd = 60616, Player, [Location, Id]) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = _RoleLv}, holy_ghost = StatusHG} = Player,
    #status_holy_ghost{fight_id = FightId, illus_id = IlluId,  display = Display, bound_ids = BoundL} = StatusHG,
    NewBoundL = lists:keydelete(Location, 1, BoundL),
    NewStatusHG = lib_holy_ghost:sync_data(Player, StatusHG#status_holy_ghost{bound_ids = NewBoundL}),
    NewPlayer = lib_player:count_player_attribute(Player#player_status{holy_ghost = NewStatusHG}),
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, FightId, IlluId, Display, util:term_to_string(NewBoundL)])),
    lib_server_send:send_to_sid(Sid, pt_606, Cmd, [Location, Id]),
    {ok, battle_attr, NewPlayer};


handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

%%--------------------------------------------%%

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_606:write(60600, [CodeInt, CodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData).

do_stage_up_help(Id, Stage, Exp, ExpPlus, MaxExp, RoleName) ->
    case Exp + ExpPlus >= MaxExp of
        true ->
            NextStage = Stage + 1,
            NextExp = Exp + ExpPlus - MaxExp,
            case data_holy_ghost:get_holy_ghost_stage(Id, NextStage) of
                #base_holy_ghost_stage{exp = NextMaxExp, is_tv = IsTv} ->
                    %% 传闻 （考虑到一个物品能升很多级的情况， 所以放在这）
                    case IsTv == 1 of
                        true ->
                            #base_holy_ghost{name = GhostName} = data_holy_ghost:get_holy_ghost(Id),
                            lib_chat:send_TV({all}, ?MOD_HOLY_GHOST, 1, [RoleName, GhostName, NextStage]);
                        false -> skip
                    end,
                    %% 能再升下一级的情况
                    case NextExp >= NextMaxExp of
                        true -> do_stage_up_help(Id, NextStage, 0, NextExp, NextMaxExp, RoleName);
                        _ -> {NextStage, NextExp}
                    end;
                _ -> {Stage, Exp + ExpPlus}
            end;
        false -> {Stage, Exp + ExpPlus}
    end.

%%  广播给场景玩家
broadcast_to_scene(Player) ->
    #player_status{
        id            = RoleId,
        scene         = Sid,
        scene_pool_id = PoolId,
        copy_id       = CopyId,
        x             = X,
        y             = Y,
        holy_ghost    = StatusHG
    } = Player,
    #status_holy_ghost{figure_id = FigureId, display = Display} = StatusHG,
    mod_scene_agent:update(Player, [{holy_ghost_figure, {FigureId, Display}}]),
    {ok, BinData} = pt_606:write(60601, [RoleId, FigureId, Display]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).