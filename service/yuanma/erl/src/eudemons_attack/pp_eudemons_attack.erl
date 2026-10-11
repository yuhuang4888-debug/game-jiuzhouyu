%%-----------------------------------------------------------------------------
%% @Module  :       pp_eudemons_attack.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-19
%% @Description:    幻兽入侵
%%-----------------------------------------------------------------------------

-module (pp_eudemons_attack).
-export ([handle/3]).
-include ("server.hrl").
-include ("custom_act.hrl").
-include ("errcode.hrl").
-include ("figure.hrl").
-include ("common.hrl").

handle(60301, Player, []) ->
    mod_eudemons_attack:get_act_info(Player#player_status.id);

handle(60302, Player, []) ->
    case Player#player_status.battle_field of
        #{mod_lib := lib_eudemons_attack_field, pid := BattlePid} ->
            mod_battle_field:apply_cast(BattlePid, lib_eudemons_attack_field, send_field_time, Player#player_status.id);
        _ ->
            ok
    end;

handle(60303, Player, [GoodsId]) ->
    #player_status{battle_field = BattleField} = Player,
    case BattleField of
        #{mod_lib := lib_eudemons_attack_field, act_subtype := ActSubType, encourage := EncourageInfo} when is_map(EncourageInfo) ->
            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType, buff) of
                {buff, BuffList} ->
                    case lists:keyfind(GoodsId, 1, BuffList) of
                        {GoodsId, SkillId} ->
                            PrevLv = maps:get(SkillId, EncourageInfo, 0),
                            MaxLv = lib_skill_api:get_skill_max_lv(SkillId),
                            if
                                PrevLv < MaxLv ->
                                    NewLv = PrevLv + 1,
                                    Cost = [{?TYPE_GOODS, GoodsId, 1}],
                                    case lib_goods_api:cost_object_list_with_check(Player, Cost, eudemons_attack_encourage, "") of
                                        {true, CostPlayer} ->
                                            NewPlayer = lib_goods_buff:add_skill_buff(CostPlayer, SkillId, NewLv),
                                            {ok, BinData} = pt_603:write(60303, [GoodsId, NewLv]),
                                            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
                                            NewEncourageInfo = EncourageInfo#{SkillId => NewLv},
                                            {ok, NewPlayer#player_status{battle_field = BattleField#{encourage => NewEncourageInfo}}};
                                        {false, Code, _} ->
                                            lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [Code]);
                                        _ ->
                                            lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [?FAIL])
                                    end;
                                true ->
                                    lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [?ERRCODE(err280_inspire_max)])
                            end;
                        _ ->
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [?FAIL])
                    end;
                _ ->
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [?FAIL])
            end;
        _ ->
            ok
    end;

handle(60304, Player, []) ->
    #player_status{id = RoleId, battle_field = BattleField} = Player,
    case BattleField of
        #{mod_lib := lib_eudemons_attack_field, pid := BattlePid} ->
            mod_battle_field:apply_cast(BattlePid, lib_eudemons_attack_field, get_hurt_ranks, RoleId);
        _ ->
            ok
    end;
    % lib_eudemons_attack_field:get_hurt_ranks(Player);

handle(60306, Player, []) ->
    mod_eudemons_attack:get_battle_result(Player#player_status.id); 

handle(60307, Player, []) ->
    case lib_player_check:check_all(Player) of
        true ->
            mod_eudemons_attack:player_enter(Player#player_status.id, Player#player_status.figure#figure.lv);
        {false, Code} ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [Code])
    end;

handle(60308, Player, []) ->
    case Player#player_status.battle_field of
        #{mod_lib := lib_eudemons_attack_field, pid := BattlePid} ->
            Args = lib_eudemons_attack_field:pack_quit_args(Player, 0),
            mod_battle_field:player_quit(BattlePid, Player#player_status.id, Args);
        _ ->
            ok
    end;
    % lib_eudemons_attack:player_quit(Player);

handle(60309, Player, []) ->
    case Player#player_status.battle_field of
        #{mod_lib := lib_eudemons_attack_field, pid := BattlePid} ->
            mod_battle_field:apply_cast(BattlePid, lib_eudemons_attack_field, send_hurt_step_info, Player#player_status.id);
        _ ->
            ok
    end;

handle(_Cmd, _Player, _Data) ->
    {error, "pp_eudemons_attack no match~n"}.