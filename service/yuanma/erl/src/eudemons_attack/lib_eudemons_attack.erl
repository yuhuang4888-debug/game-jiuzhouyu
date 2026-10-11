%%-----------------------------------------------------------------------------
%% @Module  :       lib_eudemons_attack.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-05
%% @Description:    幻兽入侵活动
%%-----------------------------------------------------------------------------

-module (lib_eudemons_attack).
-include ("server.hrl").
-include ("attr.hrl").
-include ("errcode.hrl").
-include ("custom_act.hrl").
-include ("predefine.hrl").
-include ("goods.hrl").
-include ("figure.hrl").
-include ("eudemons_act.hrl").
-export ([
    player_enter_ready/3
    ,handle_battle_result/10
    ,handle_battle_result_ps/9
    ]).

player_enter_ready(Player, BattlePid, ActSubType) ->
    case lib_player_check:check_all(Player) of
        true ->
            #player_status{id = RoleId, scene = OSceneId, scene_pool_id = OPoolId, copy_id = OCopyId, x = X, y = Y, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}, figure = #figure{lv = Lv, name = Name, career = Career, sex = Sex, turn = Turn, picture = Pic}, combat_power = Power} = Player,
            FigureData = [Lv, Name, Career, Sex, Turn, Pic, Power],
            Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim, FigureData],
            mod_battle_field:player_enter(BattlePid, RoleId, Args),
            Player#player_status{battle_field = #{act_subtype => ActSubType}};
        {false, Code} ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_603, 60300, [Code])
    end.

handle_battle_result(RoleId, Rank, EndTime, KillerId, NotMail, ActInfo, SimpleFigure, RoomId, Hurt, BossHp) when KillerId > 0 ->
    %% 排名奖励
    % RwIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType),
    % RankRewardId = calc_rank_reward_id(Rank),
    case lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, handle_battle_result_ps, [Rank, EndTime, KillerId, NotMail, ActInfo, RoomId, Hurt, BossHp]) of
        skip ->
            handle_battle_result_offline(RoleId, Rank, KillerId, ActInfo, SimpleFigure, RoomId, Hurt, BossHp);
        _ ->
            ok
    end;

handle_battle_result(RoleId, Rank, EndTime, KillerId, NotMail, #act_info{key = {_, ActId}}, _SimpleFigure, RoomId, Hurt, BossHp) ->
    HurtPercent = trunc(Hurt/BossHp*10000),
    lib_log_api:log_eudemons_attack(ActId, RoleId, Rank, RoomId, if RoleId == KillerId -> 1; true -> 0 end, Hurt, HurtPercent, [], utime:unixtime()),
    if
        NotMail ->
            {ok, BinData0} = pt_603:write(60302, [3, EndTime]),
            lib_server_send:send_to_uid(RoleId, BinData0),
            {ok, BinData} = pt_603:write(60305, [0, Rank, []]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            ok
    end.


handle_battle_result_ps(Player, Rank, EndTime, KillerId, NotMail, #act_info{key = {_, ActSubType}, wlv = Wlv}, RoomId, Hurt, BossHp) ->
    #player_status{figure = #figure{lv = Lv, sex = Sex}, sid = Sid, id = RoleId} = Player,
    RewardParam = #reward_param{player_lv = Lv, sex = Sex, wlv = Wlv},
    TotalRewards = calc_total_rewards(Rank, RoleId =:= KillerId, ActSubType, RewardParam),
    HurtPercent = trunc(Hurt/BossHp*10000),
    ActName = lib_custom_act_util:get_act_name(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType),
    lib_log_api:log_eudemons_attack(ActSubType, RoleId, Rank, RoomId, if RoleId == KillerId -> 1; true -> 0 end, Hurt, HurtPercent, TotalRewards, utime:unixtime()),
    if
        NotMail ->
            {ok, BinData0} = pt_603:write(60302, [3, EndTime]),
            lib_server_send:send_to_sid(Sid, BinData0),
            {ok, BinData} = pt_603:write(60305, [1, Rank, TotalRewards]),
            lib_server_send:send_to_sid(Sid, BinData),
            Produce = #produce{type = eudemons_act_reward, reward = TotalRewards, subtype = Rank, title = utext:get(3310009, [ActName]), content = utext:get(3310010, [ActName])},
            RewardPlayer = lib_goods_api:send_reward_with_mail(Player, Produce),
            {ok, RewardPlayer};
        true ->
            Title = utext:get(3310009, [ActName]),
            Content = utext:get(3310011, [ActName]),
            lib_mail_api:send_sys_mail([Player#player_status.id], Title, Content, TotalRewards)
    end.

handle_battle_result_offline(RoleId, Rank, KillerId, #act_info{key = {_, ActSubType}, wlv = Wlv}, SimpleFigure, RoomId, Hurt, BossHp) ->
    #simple_figure{lv = Lv, sex = Sex} = SimpleFigure,
    RewardParam = #reward_param{player_lv = Lv, wlv = Wlv, sex = Sex},
    TotalRewards = calc_total_rewards(Rank, RoleId =:= KillerId, ActSubType, RewardParam),
    ActName = lib_custom_act_util:get_act_name(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType),
    Title = utext:get(3310009, [ActName]),
    Content = utext:get(3310011, [ActName]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, TotalRewards),
    HurtPercent = trunc(Hurt/BossHp*10000),
    lib_log_api:log_eudemons_attack(ActSubType, RoleId, Rank, RoomId, if RoleId == KillerId -> 1; true -> 0 end, Hurt, HurtPercent, TotalRewards, utime:unixtime()).

calc_total_rewards(Rank, IsBossKiller, ActSubType, #reward_param{wlv = Wlv} = RewardParam) ->
    RankReward
    = case calc_rank_reward_id(Rank, ActSubType) of
        0 ->
            [];
        RwId ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType, RwId) of
                RewardCfg when is_record(RewardCfg, custom_act_reward_cfg) ->
                    lib_custom_act_util:count_act_reward(RewardParam, RewardCfg);
                _ ->
                    []
            end
    end,
    KillReward
    = if
        IsBossKiller ->
            data_eudemons_act:get_killer_reward(ActSubType, Wlv);
        true ->
            []
    end,
    KillReward ++ RankReward.


calc_rank_reward_id(Rank, ActSubType) ->
    RwIds = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType),
    calc_rank_reward_id(ActSubType, Rank, RwIds).

calc_rank_reward_id(ActSubType, Rank, [Id|T]) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, ActSubType, Id) of
        #custom_act_reward_cfg{condition = Conditions} ->
            case lists:keyfind(hurt_rank, 1, Conditions) of
                {hurt_rank, {Min, Max}} when Min =< Rank andalso Rank =< Max ->
                    Id;
                _ ->
                    calc_rank_reward_id(ActSubType, Rank, T)
            end;
        _ ->
            calc_rank_reward_id(ActSubType, Rank, T)
    end;

calc_rank_reward_id(_ActSubType, _Rank, []) -> 0.
