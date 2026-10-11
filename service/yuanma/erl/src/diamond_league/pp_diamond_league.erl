%%-----------------------------------------------------------------------------
%% @Module  :       pp_diamond_league.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-23
%% @Description:    星钻联赛
%%-----------------------------------------------------------------------------

-module (pp_diamond_league).
-include ("common.hrl").
-include ("server.hrl").
-include ("diamond_league.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").
-include("guild.hrl").

-export ([handle/3]).

handle(60401, Player, []) ->
    mod_diamond_league_local:get_state_info(Player#player_status.id);

handle(60402, Player, []) ->
    #player_status{hightest_combat_power = HightestPower, combat_power = Power} = Player,
    mod_diamond_league_local:get_apply_info(Player#player_status.id, max(HightestPower, Power));

handle(60403, Player, []) ->
    #player_status{
        id = RoleId, 
        hightest_combat_power = Power, 
        figure = #figure{lv = RoleLv, name = RoleName}, 
        server_name = ServName,
        guild = #status_guild{name = GuildName}
    } = Player,
    case data_diamond_league:get_kv(?CFG_KEY_OPEN_LV) of
        Lv when Lv =< RoleLv ->
            case data_diamond_league:get_kv(?CFG_KEY_APPLY_COST) of
                [_|_] = Cost ->
                    case lib_goods_api:check_object_list(Player, Cost) of
                        true ->
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(lib_diamond_league_apply, apply, [Node, RoleId, [Power, RoleName, ServName, GuildName, RoleLv]]);
                        {false, Code} ->
                            {ok, BinData} = pt_604:write(60400, [Code, []]),
                            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_604:write(60400, [?FAIL, []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
            end;
        _ ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(lv_limit), []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

handle(60404, Player, []) ->
    mod_diamond_league_local:get_league_info(Player#player_status.id);

handle(60405, Player, []) ->
    #player_status{id = RoleId} = Player,
    case lib_player_check:check_all(Player) of
        true ->
            mod_diamond_league_local:player_enter(RoleId);
        {false, Code} ->
            {ok, BinData} = pt_604:write(60400, [Code, []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

handle(60406, #player_status{id = RoleId}, []) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_battle_info, [Node, RoleId]);

handle(60410, Player, []) ->
    #player_status{id = RoleId, battle_field = BattleField} = Player,
    case BattleField of
        #{mod_lib := lib_diamond_league_battle, pid := BattlePid} ->
            mod_battle_field:player_quit(BattlePid, RoleId, []);
        _ ->
            case Player#player_status.action_lock =:= ?ERRCODE(err604_in_the_act) of
                true ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_diamond_league_schedule, player_quit, [Node, RoleId]);
                _ ->
                    ok
            end
    end;

handle(60411, Player, [BuyNum]) ->
    #player_status{scene = SceneId, id = RoleId} = Player,
    WaitingScene = data_diamond_league:get_kv(?CFG_KEY_WAITING_SCENE),
    if
        SceneId =:= WaitingScene ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, buy_life, [Node, RoleId, BuyNum]);
        true ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_competitor), []]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

handle(60412, Player, []) ->
    #player_status{id = RoleId} = Player,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_competition_list, [Node, RoleId]);

handle(60413, Player, [SkillId]) ->
    case Player#player_status.battle_field of
        #{mod_lib := lib_diamond_league_battle, pid := BattlePid} = BattleField ->
            SkillList = maps:get(support_skills, BattleField, []),
            case lists:keyfind(SkillId, 1, SkillList) of
                {SkillId, C, LastUseTime} ->
                    NextUseCount = C + 1;
                _ ->
                    NextUseCount = 1, LastUseTime = 0
            end,
            case data_diamond_league:get_skill_cfg(SkillId, NextUseCount) of
                [Cost, Cd|_] ->
                    NowTime = utime:unixtime(),
                    if
                        NowTime >= LastUseTime + Cd ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, diamond_league_skill, integer_to_list(SkillId)) of
                                {true, NewPlayer} ->
                                    % {ok, NewPlayer} = lib_skill_buff:add_buff(CostPlayer, SkillId, 1),
                                    #player_status{figure = #figure{name = Name}} = Player,
                                    mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, player_use_skill, [Name, SkillId]),
                                    case data_diamond_league:get_skill_cfg(SkillId, NextUseCount + 1) of
                                        [[{_, _, Price}|_], NextCd] ->
                                            ok;
                                        _ ->
                                            Price = 0, NextCd = 0
                                    end,
                                    NewSkillList = lists:keystore(SkillId, 1, SkillList, {SkillId, NextUseCount, NowTime}),
                                    NewBattleField = BattleField#{support_skills => NewSkillList},
                                    {ok, BinData} = pt_604:write(60413, [SkillId, Price, NowTime + NextCd]),
                                    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                                    {ok, NewPlayer#player_status{battle_field = NewBattleField}};
                                {false, Code, _} ->
                                    {CodeInt, CodeArgs} = util:parse_error_code(Code),
                                    {ok, BinData} = pt_604:write(60400, [CodeInt, CodeArgs]),
                                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
                            end;
                        true ->
                            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_skill_cd), []]),
                            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
                    end;
                _ -> 
                    {ok, BinData} = pt_604:write(60400, [?FAIL, []]),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData)
            end;
        _ ->
            ok
    end;

handle(60415, Player, []) ->
    #player_status{action_lock = ActionLock, id = RoleId, battle_field = BattleField} = Player,
    Node = mod_disperse:get_clusters_node(),
    case BattleField of
        #{mod_lib := lib_diamond_league_battle, pid := BattlePid} ->
            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, get_60415_msg, [Node, RoleId]);
        {lib_diamond_league_battle, visit, BattlePid} ->
            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, get_60415_msg, [Node, RoleId]);
        _ ->
            case ?ERRCODE(err604_in_the_act) of
                ActionLock ->
                    mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_60415_msg, [Node, RoleId]);
                _ ->
                    skip
            end
    end;


handle(60416, #player_status{id = RoleId}, []) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_round_win_roles, [Node, RoleId]);

handle(60417, Player, [CycleIndex]) when CycleIndex > 0 ->
    mod_diamond_league_local:get_history(Player#player_status.id, CycleIndex);

handle(60419, Player, []) ->
    mod_diamond_league_local:get_apply_list(Player#player_status.id);

handle(60420, #player_status{id = RoleId, sid = Sid}, []) ->
    mod_diamond_league_guess:get_my_cur_guess_infos(RoleId, Sid);

handle(60421, #player_status{id = RoleId}, [PriceId, GuessInfo]) ->
    mod_diamond_league_guess:guess(RoleId, GuessInfo, PriceId);

handle(60422, #player_status{id = RoleId}, []) ->
    mod_diamond_league_guess:get_my_guess_summary(RoleId);

handle(60423, #player_status{id = RoleId}, []) ->
    mod_diamond_league_guess:get_role_guess_info(RoleId);

handle(60424, #player_status{id = RoleId}, [RoundId]) ->
    mod_diamond_league_guess:get_guess_reward(RoleId, RoundId);

handle(60425, #player_status{id = RoleId}, [RoleId]) ->
    skip;
handle(60425, #player_status{action_lock = ActionLock, id = RoleId} = Player, [BattleRoleId]) ->
    #player_status{scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, sid = Sid} = Player,
    case ActionLock =:= ?ERRCODE(err604_in_the_act) of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, visit_battle, [Node, RoleId, BattleRoleId, [SceneId, ScenePoolId, CopyId, X, Y]]);
        _ ->
            OpenLv = data_diamond_league:get_kv(?CFG_KEY_OPEN_LV),
            if
                Player#player_status.figure#figure.lv >= OpenLv ->
                    case lib_player_check:check_all(Player) of
                        true ->
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(mod_diamond_league_schedule, visit_battle, [Node, RoleId, BattleRoleId, [SceneId, ScenePoolId, CopyId, X, Y]]);
                        {false, Code} ->
                            {CodeInt, CodeArgs} = util:parse_error_code(Code),
                            {ok, BinData} = pt_604:write(60400, [CodeInt, CodeArgs]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                true ->
                    {ok, BinData} = pt_604:write(60400, [?ERRCODE(lv_limit), []]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end;

handle(60427, Player, []) ->
    #player_status{id = RoleId, battle_field = BattleField} = Player,
    case BattleField of
        {lib_diamond_league_battle, visit, BattlePid} ->
            Node = mod_disperse:get_clusters_node(),
            mod_battle_field:apply_cast(BattlePid, lib_diamond_league_battle, visit_leave, {Node, RoleId});
        _ ->
            ok
    end;

handle(60428, Player, []) ->
    mod_diamond_league_guess:get_guess_end_time(Player#player_status.sid);


handle(_Cmd, _Player, _Args) ->
    ?ERR("pp_diamond_league ~p ~p no match ~n", [_Cmd, _Args]).