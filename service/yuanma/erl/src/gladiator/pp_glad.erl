%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%% 决斗场
%%% @end
%%% Created : 02. 一月 2019 14:28
%%%-------------------------------------------------------------------
-module(pp_glad).
-author("whao").


-compile(export_all).
-include("gladiator.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("counter.hrl").
-include("role.hrl").
-include("server.hrl").
%% API
-export([handle/3]).


%% 获取状态
handle(65300, #player_status{id = RoleId, server_id = _ServerId}, []) ->
    mod_glad_local:send_glad_info(RoleId);

%% 获取人物信息
handle(65301, #player_status{id = RoleId, server_id = ServerId}, []) ->
    mod_glad_local:send_glad_role_info(RoleId, ServerId);

%% 挑战次数信息
handle(65302, #player_status{id = RoleId, figure = Figure}, []) ->
    lib_glad_battle:send_glad_get_challenge_num(RoleId, Figure);

%% 刷新随机对手
handle(65303, #player_status{id = RoleId, figure = Figure, combat_power = RoleCombat, server_id = ServerId}, []) ->
    mod_glad_local:glad_random_rival_role(RoleId, Figure#figure.medal_id, RoleCombat, Figure#figure.lv, ServerId);

%% 战斗假人信息
handle(65304, Player, []) ->
    #player_status{sid = Sid, glad_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:apply_cast(BattlePid, lib_glad, send_fake_data, []);
        false ->
            lib_server_send:send_to_sid(Sid, pt_653, 65399, [?FAIL])
    end;

%% 进入挑战
handle(65305, #player_status{sid = Sid} = Player, [RivalId, Combat, ChanType]) when ChanType == 0 ->
    #player_status{glad_battle_pid = BattlePid} = Player,
    lib_task_api:fin_glad(Player, 1),
    case misc:is_process_alive(BattlePid) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_653, 65399, [?ERRCODE(err280_on_battle_state)]);
        false ->
            lib_glad:challenge_image_role(Player, RivalId, Combat, ChanType)
    end;

%% 退出战斗
handle(65306, Player, []) ->
    #player_status{id = RoleId, sid = Sid, glad_battle_pid = BattlePid} = Player,
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:stop(BattlePid),
            mod_glad_local:challenge_image_role_result(RoleId, false);
        false ->
            lib_server_send:send_to_sid(Sid, pt_653, 65306, [?FAIL])
    end;

%% 领取阶段奖励
handle(65307, #player_status{id = RoleId, sid = Sid, server_id = SerId}, [Stage]) ->
    ServerTime = util:get_open_day(), %  开服天数
    F = fun(E) -> E =< ServerTime end,
    AllOpenday = data_gladiator:get_glad_all_stg_openday(),
    Openday = lists:max(lists:filter(F, AllOpenday)),
    case data_gladiator:get_glad_stage_reward(Openday, Stage) of
        #glad_stage_reward{} ->
            mod_glad_local:get_stage_reward(RoleId, Stage, SerId);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_653, 65307, [Stage, ?ERRCODE(err653_cant_get_stage)])
    end;

%% 购买挑战次数
handle(65308, Player, [BuyNum]) ->
    #player_status{id = RoleId, gold = PreGold, bgold = PreBGold, figure = #figure{vip_type = VipType, vip = Vip}} = Player,
    MaxBuyNum = lib_vip_api:get_vip_privilege(?MOD_GLADITOR, 1, VipType, Vip),
    Num = mod_daily:get_count(RoleId, ?MOD_GLADITOR, ?GLAD_BUY_NUM),
    if
        BuyNum == 0 -> NewPlayerTmp = Player;
        BuyNum + Num =< MaxBuyNum ->
            F = fun(TmpNum, TmpCost) ->
                {TmpNum, Cost1} = lists:keyfind(TmpNum, 1, ?GLAD_KV_EXTRA_NUM_COST),
                [Cost1 | TmpCost]
                end,
            Cost = lists:foldl(F, [], lists:seq(Num + 1, BuyNum + Num)),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, glad_buy_num, "") of
                {true, NewPlayerTmp} ->
                    #player_status{gold = AfterGold, bgold = AfterBGold} = NewPlayerTmp,
                    mod_daily:plus_count(RoleId, ?MOD_GLADITOR, ?GLAD_BUY_NUM, BuyNum),
                    lib_glad:plus_challenge_num(RoleId, BuyNum),
                    %% 日志
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_resource_back, add_vip_buy_count, [?MOD_GLADITOR, 0, BuyNum]),
                    lib_log_api:log_glad_buy_times(RoleId, PreGold, PreBGold, BuyNum, AfterGold, AfterBGold),
                    lib_server_send:send_to_uid(RoleId, pt_653, 65308, [?SUCCESS]);
                {false, ErrorCode, NewPlayerTmp} ->
                    lib_server_send:send_to_uid(RoleId, pt_653, 65308, [ErrorCode])
            end;
        true ->
            NewPlayerTmp = Player,
            lib_server_send:send_to_uid(RoleId, pt_653, 65308, [?ERRCODE(err280_over_max_buy_num)])
    end,
    {ok, NewPlayerTmp};

%% 获取排行榜
handle(65310, #player_status{id = RoleId, server_id = ServerId}, []) ->
    mod_glad_local:get_glad_rank_list(RoleId, ServerId);



%% 跳过战斗
handle(65311, Player, _Data) ->
    RewardTime = ?GLAD_KV_SHOW_LAST_TIME,
    #player_status{id = RoleId, sid = Sid, glad_battle_pid = BattlePid} = Player,
    UnixTime = utime:unixtime(),
    case misc:is_process_alive(BattlePid) of
        true ->
            mod_battle_field:apply_cast(BattlePid, lib_glad, skip_battle, [RoleId]),
            lib_server_send:send_to_sid(Sid, pt_653, 65309, [2, UnixTime + RewardTime]),
            lib_server_send:send_to_sid(Sid, pt_653, 65311, [?SUCCESS]);
        false ->
            lib_server_send:send_to_sid(Sid, pt_653, 65311, [?FAIL])
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.