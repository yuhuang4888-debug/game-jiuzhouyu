%%%------------------------------------
%%% @Module  : pp_jjc
%%% @Author  : fwx
%%% @Created :  2017-11-20
%%% @Description: jjc
%%%------------------------------------
-module(pp_jjc).
-export([]).

-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("pet.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("jjc.hrl").
-include("def_module.hrl").

%% 获取玩家jjc信息
handle(28001, Player, _Data) ->
    #player_status{id = RoleId, figure = Figure, combat_power = Combat, jjc_honour = Honour, status_pet = StatusPet, jjc = StatusJjc} = Player,
    mod_jjc:cast_to_jjc(get_jjc_role, [RoleId, Figure, Combat, Honour, StatusPet#status_pet.figure_id, StatusJjc#status_jjc.break_id_list]);

%% 随机对手
handle(28002, Player, _Data) ->
    #player_status{id = RoleId, combat_power = Combat} = Player,
    mod_jjc:cast_to_jjc(random_rival_role, [RoleId, Combat]);

%% 挑战对手
handle(28003, Player, [SelfRank, RivalId, RivalRank, ChallengeType]) ->
    %?PRINT("28003 :~p ~n", [Player#player_status.id]),
    #player_status{quickbar = QuickBar, jjc_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true -> skip;
        false ->
            Skills = [{Id, 1} || {_, Type, Id, _} <- QuickBar, Type =:= 2],
            lib_jjc:challenge_image_role(Player, SelfRank, RivalId, RivalRank, Skills, ChallengeType)
    end;

%% 挑战次数信息
handle(28004, Player, _Data) ->
    %?PRINT("28004  ~n", []),
    #player_status{id = RoleId, figure = Figure} = Player,
    mod_jjc:cast_to_jjc(get_challenge_num, [RoleId, Figure#figure.vip_type, Figure#figure.vip]);

%% 购买挑战次数
handle(28005, Player, [BuyNum]) ->
    %?PRINT("28006  ~n", []),
    #player_status{id = RoleId, gold = PreGold, bgold = PreBGold, coin = PreCoin, figure = #figure{vip_type = VipType, vip = Vip}} = Player,
    %?PRINT("~p,~p~n", [PreGold, PreBGold]),
    MaxBuyNum = lib_vip_api:get_vip_privilege(?MOD_JJC, 1, VipType, Vip),
    Num = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_BUY_NUM),
    if
        BuyNum == 0 -> NewPlayerTmp = Player;
        BuyNum + Num =< MaxBuyNum ->
            Cost = lists:foldl(fun(TmpNum, TmpCost) ->
                case data_jjc:get_buy_cfg(TmpNum) of
                    #jjc_buy_cfg{type = Type, price = Price} -> skip;
                    _ -> Type = Price = 0
                end,
                [{Type, 0, Price} | TmpCost]
                               end, [], lists:seq(Num + 1, BuyNum + Num)),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, jjc_buy_num, "") of
                {true, NewPlayerTmp} ->
                    #player_status{gold = AfterGold, bgold = AfterBGold, coin = AfterCoin} = NewPlayerTmp,
                    %?PRINT("~p,~p~n", [AfterGold, AfterBGold]),
                    mod_daily:plus_count(RoleId, ?MOD_JJC, ?JJC_BUY_NUM, BuyNum),
                    mod_jjc_cast:plus_challenge_num(RoleId, BuyNum),
                    %% 日志
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_resource_back, add_vip_buy_count, [?MOD_JJC, 0, BuyNum]),
                    lib_log_api:log_jjc_buy_times(RoleId, PreGold, PreBGold, PreCoin, BuyNum, AfterGold, AfterBGold, AfterCoin),
                    lib_server_send:send_to_uid(RoleId, pt_280, 28005, [?SUCCESS]);
                {false, ErrorCode, NewPlayerTmp} ->
                    lib_server_send:send_to_uid(RoleId, pt_280, 28000, [ErrorCode])
            end;
        true ->
            NewPlayerTmp = Player,
            lib_server_send:send_to_uid(RoleId, pt_280, 28000, [?ERRCODE(err280_over_max_buy_num)])
    end,
    {ok, NewPlayerTmp};

% %% 战力鼓舞信息
% handle(28006, Player, _Data) ->
%     %?PRINT("28006  ~n", []),
%     mod_jjc:cast_to_jjc(get_inspire_num, [Player#player_status.id]);

% %% 增加鼓舞次数
% handle(28007, Player, _Data) ->
%     %?PRINT("28007  ~n", []),
%     #player_status{id = RoleId, gold = PreGold, bgold = PreBGold, coin = PreCoin, combat_power = Combat} = Player,
%     case data_jjc:get_jjc_value(?JJC_INSPIRE_NUM_MAX) of
%         [] -> MaxInspireNum = 0;
%         [MaxInspireNum] -> skip
%     end,
%     InspireNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_INSPIRE_NUM),
%     if
%         InspireNum < MaxInspireNum ->
%             case data_jjc:get_inspire_cfg(NewInspireNum = InspireNum + 1) of
%                 #jjc_inspire_cfg{type = Type, price = Price, percent = Percent} ->
%                     case lib_goods_api:cost_object_list_with_check(Player, [{Type, 0, Price}], jjc_inspire, "") of
%                         {true, NewPlayerTmp} ->
%                             #player_status{gold = AfterGold, bgold = AfterBGold, coin = AfterCoin} = NewPlayerTmp,
%                             mod_daily:increment(RoleId, ?MOD_JJC, ?JJC_INSPIRE_NUM),
%                             NewCombat = Combat + round(Combat * Percent / 100),
%                             % 日志
%                             lib_log_api:log_jjc_inspire(RoleId, PreGold, PreBGold, PreCoin, Combat, NewInspireNum, AfterGold, AfterBGold, AfterCoin, NewCombat),
%                             lib_server_send:send_to_uid(RoleId, pt_280, 28007, [?SUCCESS, NewCombat]);
%                         {false, ErrorCode, NewPlayerTmp} ->
%                             lib_server_send:send_to_uid(RoleId, pt_280, 28000, [ErrorCode])
%                     end;
%                 _ ->
%                     NewPlayerTmp = Player,
%                     lib_server_send:send_to_uid(RoleId, pt_280, 28000, [?ERRCODE(err_config)])
%             end;
%         true ->
%             lib_server_send:send_to_uid(RoleId, pt_280, 28000, [?ERRCODE(err280_jjc_inspire_max)]),
%             NewPlayerTmp = Player
%     end,
%     {ok, NewPlayerTmp};

% %% 领取奖励
% handle(28008, Player, _Data) ->
%     #player_status{id = RoleId} = Player,
%     case catch mod_jjc:jjc_reward(RoleId) of
%         {ok, {RewardState, Reward}} ->
%             case RewardState of
%                 ?JJC_HAVE_REWARD ->
%                     case lib_goods_do:can_give_goods(Reward) of
%                         true ->
%                             mod_jjc:cast_to_jjc(get_reward, [RoleId]);
%                         {false, ErrorCode} ->
%                             lib_server_send:send_to_uid(RoleId, pt_280, 28000, [ErrorCode])
%                     end;
%                 ?JJC_HAVE_NOT_REWARD ->
%                     skip
%             end;
%         Res ->
%             ?ERR("jjc_reward error:~p", [Res]),
%             {fail, ?ERRCODE(system_busy)}
%     end;

%% 返回被挑战记录
handle(28009, Player, _Data) ->
    mod_jjc:cast_to_jjc(get_challenge_record, [Player#player_status.id]);

%% 返回荣誉值
handle(28010, Player, _Data) ->
    #player_status{id = RoleId, jjc_honour = Honour} = Player,
    lib_server_send:send_to_uid(RoleId, pt_280, 28010, [?SUCCESS, Honour]);

%% 返回王者榜信息（前3名）
handle(28011, Player, _Data) ->
    mod_jjc:cast_to_jjc(get_rank_pre_3, [Player#player_status.id]);

%% 退出战斗场景
handle(28012, Player, _Data) ->
    #player_status{sid = Sid, jjc_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:stop(BattlePid);
        false ->
            lib_server_send:send_to_sid(Sid, pt_280, 28012, [?FAIL])
    end;

%% 战斗假人信息
handle(28013, Player, _Data) ->
    #player_status{sid = Sid, jjc_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:apply_cast(BattlePid, lib_jjc_battle, send_fake_data, []);
        false ->
            lib_server_send:send_to_sid(Sid, pt_280, 28000, [?FAIL])
    end;

%% 跳过战斗
handle(28015, Player, _Data) ->
    case data_jjc:get_jjc_value(?JJC_REWARD_TIME) of
        [] -> RewardTime = 10;
        [RewardTime] -> skip
    end,
    #player_status{id = RoleId, sid = Sid, jjc_battle_pid = BattlePid} = Player,
    UnixTime = utime:unixtime(),
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:apply_cast(BattlePid, lib_jjc_battle, skip_battle, [RoleId]),
            lib_server_send:send_to_sid(Sid, pt_280, 28014, [2, UnixTime + RewardTime]),
            lib_server_send:send_to_sid(Sid, pt_280, 28015, [?SUCCESS]);
        false ->
            lib_server_send:send_to_sid(Sid, pt_280, 28015, [?FAIL])
    end;

%% 领取突破奖励
handle(28017, Player, [BreakId]) ->
    mod_jjc:cast_to_jjc(handle_get_break_reward, [Player#player_status.id, BreakId]);

%% 战斗loading结束发送
handle(28018, Player, []) ->
    #player_status{jjc_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true -> mod_battle_field:apply_cast(BattlePid, lib_jjc_battle, trigger_battle, []);
        false -> skip
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.