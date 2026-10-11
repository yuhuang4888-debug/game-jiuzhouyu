%% ---------------------------------------------------------------------------
%% @doc lib_dungeon.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本处理:玩家进程,基本函数
%% ---------------------------------------------------------------------------
-module(lib_dungeon).
-export([
        enter_dungeon/2
        , enter_dungeon/3
    ]).

-export([
        is_on_dungeon/1
    ]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("partner.hrl").
-include("def_module.hrl").
-include("hero_halo.hrl").
-include("def_daily.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("partner_battle.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("relationship.hrl").
-include("language.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("vip.hrl").
-include("sql_dungeon.hrl").
-include("def_vip.hrl").
-include("buff.hrl").
-include("daily.hrl").
-include("boss.hrl").
-include("collect.hrl").
-include("role.hrl").
-include("marriage.hrl").
-include("supreme_vip.hrl").
-include("def_goods.hrl").
-include("weekly_card.hrl").

%% -----------------------------------------------------------------
%% 副本说明:
%%  切场景要通知副本进程,及时清空数据
%%
%% 流程
%%  1、进入
%%      （1）检查
%%          a.lib_dungeon_check:enter_dungeon => 检查副本进入
%%          b.lib_dungeon:check_dungeon_count_cond(Dun#dungeon.count_cond, Dun, Player) =>检查
%%          c.lib_dungeon:check_dungeon_condition(Dun#dungeon.condition, Dun, DunPid, Player),
%%          d.lib_dungeon:check_dungeon_time_open(Dun),
%%          e.lib_dungeon:check_extra(Player, Dun),
%%  2、退出
%%      （1）延迟登出(必须触发事件才走登出)
%%          触发元素:{delay_logout, ReserveTime}
%%          lib_dungeon_mod:delay_logout
%%      （2）玩家登出(触发事件,登出)
%%          触发元素:{logout}
%%          默认副本失败
%%          lib_dungeon_mod:delay_logout
%%      （3）跳过副本(必须触发事件才走登出)
%%          触发元素:{skip_dungeon}
%%          lib_dungeon_mod:delay_logout
%%      （4）主动退出(触发事件,登出)
%%          触发元素:{active_quit}
%%          默认副本失败
%%          lib_dungeon_mod:delay_logout
%%
%%  3、结算
%%          lib_dungeon_mod:dungeon_result => 结算处理
%%      （1）延迟结算:玩家退出副本才算结算,因为期间可以加好友等操作增加积分获得奖励
%%
%%      （2）立刻结算:
%%
%%      （3）关卡结算:
%%          发奖励:lib_dungeon_mod:handle_level_send_reward
%% 副本类型
%%  五芒星副本
%%      1:助战没有奖励
%%      2:胜利获得全部奖励,失败只有一半
%%  冒险副本
%%      1:助战没有奖励
%%      2:走评分
%%      3:发奖励走评分的奖励
%%  遗忘之境
%%      1:关卡
%%      2:初始化要根据场景读取事件,以及同步辅助事件到指定的场景(默认是全部场景).
%%      3:关卡结算
%%      4:切换关卡
%%      5:判断是否完成所有关卡,直接结算
%%
%%  结果条件
%%      {quit_time, QuitTime}:触发结算的时候,多少秒退出副本
%% -----------------------------------------------------------------

%% 玩家信息转化成副本相关信息
trans_to_dungeon_role(Player, Dun) when is_record(Player, player_status) ->
    #player_status{
        id = Id, figure = #figure{lv = Lv} = Figure, pid = Pid, scene = PScene, server_id = ServerId, exp = Exp,
        server_num = ServerNum,
        scene_pool_id = PScenePoolId, copy_id = PCopyId, x = PX, y = PY, team = Team,
        combat_power = CombatPower, battle_attr = #battle_attr{hp_lim = HpLim},
        dungeon = #status_dungeon{out = Out = #dungeon_out{is_again = IsAgain}, wave_map = WaveMap},
        collect = #collect_status{drop_end_time = CollectDropEndTime}, setting = StatusSetting, weekly_card_status = WeeklyCardStatus} = Player,
    #dungeon{id = DunId, type = DunType} = Dun,
    DataBfEnter = #{lv_before => Lv, exp_before => Exp},
    Count = lib_hero_halo:calc_dun_challenge_times(Player, Dun),
    % case data_scene:get(SceneId) of
    %     [] -> BattleType = ?PARTNER_BATTLE_TYPE_NO;
    %     #ets_scene{parnter_battle_type = BattleType} -> skip
    % end,
    % if
    %     BattleType == ?PARTNER_BATTLE_TYPE_GROUP ->
    %         PartnerList = lib_partner_api:get_battle_partners(Player),
    %         PartnerMap = trans_to_dungeon_partner_map(PartnerList, #{}),
    %         PartnerGroup = ?PARTNER_GROUP_1;
    %     true ->
    %         PartnerGroup = ?PARTNER_GROUP_BAN,
    %         PartnerMap = #{}
    % end,
    {Scene, ScenePoolId, CopyId, X, Y} =
    case lib_boss:is_in_outside_scene(PScene) of
        true -> {PScene, PScenePoolId, PCopyId, PX, PY};
        false -> {0, 0, 0, 0, 0}
    end,
    case IsAgain == 1 of
        true -> #dungeon_out{scene = OutScene, scene_pool_id = OutScenePoolId, copy_id = OutCopyId, x = OutX, y = OutY} = Out;
        false -> OutScene = Scene, OutScenePoolId = ScenePoolId, OutCopyId = CopyId, OutX = X, OutY = Y
    end,
    case DunId == ?CREATE_ROLE_DUN of
        true -> NewHpLim = 100000;
        false -> NewHpLim = HpLim
    end,
    CollectDropsArgs = [{collect_drop_end, CollectDropEndTime}],
    Node = mod_disperse:get_clusters_node(),
    HelpType = lib_dungeon_team:get_help_type(Player, DunId),
    HistoryWave = get_dun_history_wave(DunId, WaveMap),
    PassTimeList = get_dun_pass_time_list(DunId, WaveMap),
    Role = #dungeon_role{
        id = Id
        , node = Node
        , figure = Figure
        , combat_power = CombatPower
        , hp = NewHpLim
        , hp_lim = NewHpLim
        , pid = Pid
        , server_id = ServerId
        , server_num = ServerNum
        , scene = OutScene
        , scene_pool_id = OutScenePoolId
        , copy_id = OutCopyId
        , x = OutX
        , y = OutY
        , team_id = Team#status_team.team_id
        , team_position = Team#status_team.positon
        , help_type = HelpType
        , is_first_reward = calc_is_first_reward(Id, DunType, DunId)
        , drop_times_args = CollectDropsArgs
        , data_before_enter = DataBfEnter
        , reward_ratio = lib_custom_act_liveness:get_server_effect_by_dun_type(Player, DunType)
        , history_wave = HistoryWave
        , pass_time_list = PassTimeList
        , setting_list = lib_dungeon_setting:get_setting_list(Player, DunId)
        , count = Count
        , setting = lib_game:get_dungeon_role_setting(StatusSetting)
        , weekly_card_status = WeeklyCardStatus
    },
    lib_dungeon_api:invoke(DunType, init_dungeon_role, [Player, Dun, Role], Role).

trans_to_dungeon_partner_map([], PartnerMap) -> PartnerMap;
trans_to_dungeon_partner_map([#partner{id = Id, partner_id = PartnerId, pos = Pos} = Partner|T], PartnerMap) ->
    BA = lib_player_attr:attr_to_battle_attr(Partner#partner.battle_attr),
    HpLim = BA#battle_attr.hp_lim,
    DunPartner = #dungeon_partner{id = Id, partner_id = PartnerId, pos = Pos, hp = HpLim , hp_lim = HpLim, partner = Partner},
    IsGroup1 = lists:member(Pos, ?PARTNER_GROUP_1_POS_LIST),
    IsGroup2 = lists:member(Pos, ?PARTNER_GROUP_2_POS_LIST),
    if
        IsGroup1 -> PartnerGroup = ?PARTNER_GROUP_1;
        IsGroup2 -> PartnerGroup = ?PARTNER_GROUP_2;
        true -> PartnerGroup = ?PARTNER_GROUP_1
    end,
    DunPartnerList = maps:get(PartnerGroup, PartnerMap, []),
    NewPartnerMap = PartnerMap#{PartnerGroup => lists:keystore(Id, #dungeon_partner.id, DunPartnerList, DunPartner)},
    trans_to_dungeon_partner_map(T, NewPartnerMap).

%% -----------------------------------------------------------------
%% 玩家进程操作
%% -----------------------------------------------------------------

%% 协议进入副本
% pp_enter_dungeon()
%% @return {ok, Player}
enter_dungeon(Player, DunId) ->
    enter_dungeon(Player, DunId, ?DUN_CREATE).

%% 重新进入副本
%% Out : 退出的场景记录
again_enter_dungeon(#player_status{dungeon = StatusDun} = Player, DunId, Out) ->
    NewPlayer = Player#player_status{dungeon = StatusDun#status_dungeon{out = Out}},
    enter_dungeon(NewPlayer, DunId, ?DUN_AGAIN).

%% 进入副本
%% EnterType : pid() | ?DUN_CREATE(创建副本) | ?DUN_AGAIN(重新进入)
%% @return {ok, Player}
enter_dungeon(Player0, DunId, EnterType) ->
    Dun = data_dungeon:get(DunId),
    case lib_dungeon_check:enter_dungeon(Player0, Dun, EnterType) of
        skip ->
            {ok, Player0};
        true ->
            PlayerAfTeam = lib_dungeon_team:init_help_type(Player0, DunId),
            Player = lib_dungeon_setting:init_setting_list_for_enter(PlayerAfTeam, DunId),
            enter_dungeon_done(Player, Dun, EnterType);
        {false, ErrInfo} ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrInfo),
            {ok, BinData} = pt_610:write(61001, [DunId, 0, ErrorCodeInt, ErrorCodeArgs]),
            lib_server_send:send_to_sid(Player0#player_status.sid, BinData),
            {ok, Player0}
    end.

%% 获得真实消耗
%% @return Cost
calc_real_cost_multi(Player, Dun, Count) ->
    case calc_real_cost_multi_return_type(Player, Dun, Count) of
        {auto_buy, _Cost, AutoCost} -> AutoCost;
        {true, Cost} -> Cost
    end.

%% @return {true, Cost} | {auto_buy, Cost, NewCost}
calc_real_cost_multi_return_type(Player, Dun, Count) ->
    OldCost     = calc_cost_multi(Player, Dun, Count),
    IsAutoBuy   = get_default_auto_buy_option(Dun),
    IsVipLimit  = get_vip_lv_auto_buy_limit(Player, Dun),
    IsEnough    = lib_goods_util:check_object_list(Player, OldCost),
    AutoBuyList = lib_goods_api:calc_auto_buy_list(OldCost),

    GoodsNotEnough = ?GOODS_NOT_ENOUGH,
    case {IsAutoBuy, IsVipLimit, IsEnough, AutoBuyList} of
        % 可自动购买;达到vip限制等级;原消耗物品不足;可计算自动购买列表
        {true, true, {false, GoodsNotEnough}, {ok, NewCost}} ->
            {auto_buy, OldCost, NewCost};
        _ ->
            {true, OldCost}
    end.

check_invite_other(Player, Dun, OtherId) ->
    #dungeon{type = DunType} = Dun,
    case lib_dungeon_api:get_special_api_mod(DunType, dunex_check_invite_other, 3) of
        undefined ->
            case lib_player:get_alive_pid(OtherId) of
                false -> {false, ?ERRCODE(err610_xxx)};
                _Pid ->
                  true
            end;
        Mod ->
            Mod:dunex_check_invite_other(Player, Dun, OtherId)
    end.

%% 发送消息
send_info(Player, StartTime, StartTimeMs, EndTime, Level, LevelEndTime, OwnerId, WaveNum) ->
    {ok, BinData} = pt_610:write(61004, [StartTime, StartTimeMs, EndTime, Level, LevelEndTime, OwnerId, WaveNum]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

% 转换错误码
trans_error_code(ErrorCode, Player) ->
    #player_status{figure = #figure{name = Name}} = Player,
    SceneOfTransfer = ?ERRCODE(err120_cannot_transfer_scene),
    SceneOfBattle = ?ERRCODE(err120_cannot_transfer_on_battle),
    DunOfEnter = ?ERRCODE(err610_not_on_enter_scene),
    DunOfSafe = ?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon),
    case ErrorCode of
        SceneOfTransfer ->
            {
                {?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon_by_other), [Name]}
                , ?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon)
            };
        SceneOfBattle ->
            {
                {?ERRCODE(err610_cannot_join_act_on_battle_with_name), [Name]}
                , ?ERRCODE(err610_cannot_join_act_on_battle)
            };
        DunOfEnter ->
            {
                {?ERRCODE(err610_not_on_enter_scene_by_other), [Name]}
                , ?ERRCODE(err610_not_on_enter_scene)
            };
        DunOfSafe ->
            {
                {?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon_by_other), [Name]}
                , ?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon)
            };
        _ ->
            {
                ErrorCode
                , ErrorCode
            }
    end.

%% 进入副本处理:创建副本和进入副本场景,副本前扣除相关东西
enter_dungeon_done(PS, Dun, DunPid) when is_pid(DunPid) ->
    DungeonRole = trans_to_dungeon_role(PS, Dun),
    mod_dungeon:ask_for_enter(DunPid, DungeonRole),
    {ok, lib_player:soft_action_lock(PS, ?ERRCODE(err610_had_on_dungeon))};
enter_dungeon_done(PS, Dun, _EnterType) ->
    #player_status{team = #status_team{team_id = TeamId}} = PS,
    #dungeon{id = DunId} = Dun,
    DungeonRole = trans_to_dungeon_role(PS, Dun),
    StartDunArgs = get_start_dun_args(PS, Dun),
    mod_dungeon:start(TeamId, self(), DunId, [DungeonRole], StartDunArgs),
    {ok, lib_player:soft_action_lock(PS, ?ERRCODE(err610_had_on_dungeon))}.

cost(Player, DunId) ->
    Dun = data_dungeon:get(DunId),
    IsAutoBuy = get_default_auto_buy_option(Dun),
    VipLvAutoBuyLimit = get_vip_lv_auto_buy_limit(Player, Dun),
    case calc_cost(Player, Dun) of
        [] ->
            {true, Player};
        Cost ->
            if
                IsAutoBuy andalso VipLvAutoBuyLimit ->
                    case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, dungeon_enter_cost, integer_to_list(DunId)) of
                        {true, NewPlayer, _RealCostList} -> {true, NewPlayer};
                        Other -> Other
                    end;
                true ->
                    lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_enter_cost, integer_to_list(DunId))
            end
    end.

%% 根据副本类型判断是否单人副本
is_dungeon_type_single(DunType) ->
    DunIds = data_dungeon:get_ids_by_type(DunType),
    case DunIds of
        [] ->
            false;
        [DunId|_] ->
            is_dungeon_single(DunId)
    end.

%% 根据副本id判断是否单人副本
is_dungeon_single(DunId) when is_integer(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{condition = Condition} ->
            is_dungeon_single(Condition);
        _ ->
            false
    end;
%% 是否单人副本
is_dungeon_single(Condition) ->
    case lists:keyfind(num, 1, Condition) of
        {num, 1, 1} -> true;
        _ -> false
    end.

%% 副本次数增加以及处理次数增加的相关逻辑[副本进程使用]
dungeon_count_increment(DunParms, RoleId, HelpType, CountDeduct) ->
    dungeon_count_increment_multi(DunParms, RoleId, HelpType, CountDeduct, 1).

dungeon_count_increment(L, DunId, DunType, RoleId, HelpType) ->
    dungeon_count_increment_multi(L, DunId, DunType, RoleId, HelpType, 1).

%% 副本次数增加以及处理次数增加的相关逻辑[副本进程使用]
dungeon_count_increment_multi(DunId, RoleId, HelpType, CountDeduct, Count) when is_integer(DunId) ->
    case data_dungeon:get(DunId) of
        Dun when is_record(Dun, dungeon) ->
            dungeon_count_increment_multi(Dun, RoleId, HelpType, CountDeduct, Count);
        _ ->
            skip
    end;
dungeon_count_increment_multi(Dun, RoleId, HelpType, CountDeduct, Count) ->
    #dungeon{id = DunId, type = DunType, count_deduct = DunCountDeduct, count_cond = CountConditions} = Dun,
    Count1 = mod_counter:get_count_offline(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, DunId),
    if
        DunType =:= ?DUNGEON_TYPE_VIP_PER_BOSS andalso Count1 =:= 0 andalso DunCountDeduct =:= CountDeduct->
            mod_counter:plus_count_offline(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, DunId, 1),
            [handle_task_trigger(RoleId, DunType, DunId)||_Seq<-lists:seq(1, Count)];
        DunCountDeduct =:= CountDeduct ->
            dungeon_count_increment_multi(CountConditions, DunId, DunType, RoleId, HelpType, Count),
            % ?MYLOG("hjhtask", "dungeon_count_increment RoleId:~p DunType:~p DunId:~p ~n", [RoleId, DunType, DunId]),
            [handle_task_trigger(RoleId, DunType, DunId)||_Seq<-lists:seq(1, Count)];
        true ->
            skip
    end.

%% 副本次数增加   %%幻饰副本第一次通关不扣除
dungeon_count_increment_multi([T|L], DunId, ?DUNGEON_TYPE_MAGIC_ORNAMENTS, RoleId, HelpType, Count) -> %%
    CounterCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    if
        CounterCount == 0 ->
            skip;
        true ->
            case T of
                % 每日
                {?DUN_COUNT_COND_DAILY, _MaxNum} when HelpType == ?HELP_TYPE_NO ->
                    CountType = lib_dungeon_api:get_daily_count_type(?DUNGEON_TYPE_MAGIC_ORNAMENTS, DunId),
                    mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count);
                {?DUN_COUNT_COND_DAILY_REWARD, _MaxNum} when HelpType == ?HELP_TYPE_NO ->
                    CountType = lib_dungeon_api:get_daily_count_type(?DUNGEON_TYPE_MAGIC_ORNAMENTS, DunId),
                    mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count);
                {?DUN_COUNT_COND_WEEK, _MaxNum} ->
                    mod_week:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
                {?DUN_COUNT_COND_PERMANENT, _MaxNum} ->
                    mod_counter:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
                {?DUN_COUNT_COND_DAILY_HELP, _MaxNum} when HelpType == ?HELP_TYPE_YES ->
                    CountType = lib_dungeon_api:get_daily_help_type(?DUNGEON_TYPE_MAGIC_ORNAMENTS, DunId),
                    mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType, Count);
                _ -> skip
            end
    end,
    dungeon_count_increment_multi(L, DunId, ?DUNGEON_TYPE_MAGIC_ORNAMENTS, RoleId, HelpType, Count);
dungeon_count_increment_multi([T|L], DunId, DunType, RoleId, HelpType, Count) ->
    case T of
        % 每日
        {?DUN_COUNT_COND_DAILY, _MaxNum} when HelpType == ?HELP_TYPE_NO ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count),
            Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType),
            % lib_to_be_strong:update_data_by_duntype(RoleId, DunType, AllCountLimit, Num);
            lib_dungeon_resource:add_challenges_daily_count(RoleId, DunType, DunId, Count),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_to_be_strong, update_data_by_duntype, [DunType, _MaxNum, Num, CountType]);
        {?DUN_COUNT_COND_DAILY_REWARD, _MaxNum} when HelpType == ?HELP_TYPE_NO ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count),
            Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_to_be_strong, update_data_by_duntype,
                [DunType, _MaxNum, Num, CountType]);
        {?DUN_COUNT_COND_WEEK, _MaxNum} ->
            mod_week:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
        {?DUN_COUNT_COND_PERMANENT, _MaxNum} ->
            mod_counter:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
        {?DUN_COUNT_COND_DAILY_HELP, _MaxNum} when HelpType == ?HELP_TYPE_YES ->
            CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType, Count);
        _ -> skip
    end,
    dungeon_count_increment_multi(L, DunId, DunType, RoleId, HelpType, Count);
dungeon_count_increment_multi(_, _DunId, _DunType, _RoleId, _HelpType, _Count) -> ok.

%% 扫荡用
dungeon_count_plus([T|L], DunId, DunType, RoleId, Count) ->
    % #dungeon{id = DunId, type = DunType} = Dun,
    case T of
        % 每日
        {?DUN_COUNT_COND_DAILY, _MaxNum} ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            lib_dungeon_resource:add_sweep_daily_count(RoleId, DunType, DunId, Count),
            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count);
        {?DUN_COUNT_COND_DAILY_REWARD, _MaxNum} ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType, Count);
        {?DUN_COUNT_COND_WEEK, _MaxNum} -> mod_week:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
        {?DUN_COUNT_COND_PERMANENT, _MaxNum} -> mod_counter:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, Count);
        % {?DUN_COUNT_COND_DAILY_HELP, _MaxNum} when HelpType == ?HELP_TYPE_YES ->
        %     CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
        %     mod_daily:increment_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType);
        _ -> skip
    end,
    dungeon_count_plus(L, DunId, DunType, RoleId, Count);

dungeon_count_plus([], _, _, _, _) -> ok.

%% 批量设置次数
dungeon_count_plus(RoleId, DunIds, Num, OP) ->
    F = fun
        (DunId, {Daily, Weekly, Permanent} = Acc) ->
            case data_dungeon:get(DunId) of
                #dungeon{count_cond = CountConditions, type = DunType} ->
                    DailyCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
                    plus_count_by_count_cond(CountConditions, DailyCountType, DunId, Num, Daily, Weekly, Permanent, OP);
                _ ->
                    Acc
            end
    end,
    {DailyList, WeeklyList, PermanentList} =  lists:foldl(F, {[], [], []}, DunIds),
    if
        DailyList =/= [] ->
            mod_daily:plus_count(RoleId, DailyList);
        true ->
            ok
    end,
    if
        WeeklyList =/= [] ->
            mod_week:plus_count(RoleId, WeeklyList);
        true ->
            ok
    end,
    if
        PermanentList =/= [] ->
            mod_counter:plus_count(RoleId, PermanentList);
        true ->
            ok
    end.

plus_count_by_count_cond([H|CountConditions], DailyCountType, DunId, Num, Daily, Weekly, Permanent, Op) ->
    case H of
        % 每日
        {?DUN_COUNT_COND_DAILY, _MaxNum} ->
            case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DailyCountType}, 1, Daily) of
                false ->
                    Daily1 = [{{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DailyCountType}, Num}|Daily];
                _ ->
                    Daily1 = Daily
            end,
            LastDaily = case lib_dungeon_resource:is_resource_dungeon_type(DailyCountType) of
                            true ->
                                if
                                    Op == 1 ->
                                        case lists:keyfind({?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, DailyCountType}, 1, Daily1) of
                                            false ->
                                                [{{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, DailyCountType}, Num}|Daily1];
                                            _ ->
                                                Daily1
                                        end;
                                    Op == 2 ->
                                        Key = {?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DailyCountType},
                                        case lists:keyfind(Key, 1, Daily1) of
                                            {Key, Num2} ->
                                                lists:keystore(Key, 1, Daily1, {Key, Num2 + 1});
                                            false ->
                                                [{{?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, DailyCountType}, Num}|Daily1];
                                            _ ->
                                                Daily1
                                        end;
                                    true ->
                                        Daily1
                                end;
                            false ->
                                Daily1
                      end,
            plus_count_by_count_cond(CountConditions, DailyCountType, DunId, Num, LastDaily, Weekly, Permanent, Op);
        {?DUN_COUNT_COND_WEEK, _MaxNum} ->
            Weekly1 = lists:keystore({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId}, 1, Weekly, {{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId}, Num}),
            plus_count_by_count_cond(CountConditions, DailyCountType, DunId, Num, Daily, Weekly1, Permanent, Op);
        {?DUN_COUNT_COND_PERMANENT, _MaxNum} ->
            Permanent1 = lists:keystore({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId}, 1, Permanent, {{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId}, Num}),
            plus_count_by_count_cond(CountConditions, DailyCountType, DunId, Num, Daily, Weekly, Permanent1, Op);
        % {?DUN_COUNT_COND_DAILY_HELP, _MaxNum} when HelpType == ?HELP_TYPE_YES ->
        %     CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
        %     mod_daily:increment_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType);
        _ -> plus_count_by_count_cond(CountConditions, DailyCountType, DunId, Num, Daily, Weekly, Permanent, Op)
    end;

plus_count_by_count_cond([], _, _, _, Daily, Weekly, Permanent, _Op) ->
    {Daily, Weekly, Permanent}.

%% 获得副本启动参数 Object是什么类型，由各个副本特殊逻辑去管理
get_start_dun_args(Object, #dungeon{type = DunType} = Dun) ->
    lib_dungeon_api:invoke(DunType, dunex_get_start_dun_args, [Object, Dun], []).

%% 主动退出副本
active_quit(Player) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    case is_on_dungeon(Player) of
        true -> mod_dungeon:active_quit(CopyId, RoleId);
        false -> immediate_quit_dungeon(Player, [0, ?DUN_RESULT_SUBTYPE_ACTIVE_QUIT, 0])
    end.

%% 直接退出副本
%% 注意: 修改本函数要检查 lib_dungeon:handle_role_out/3 中重新挑战副本的处理
immediate_quit_dungeon(Player, [ResultType, ResultSubtype, Score]) ->
    #player_status{
        id     = RoleId, scene   = SceneId,
        figure = Figure, dungeon = Dungeon,
        team   = Team, x = NowX, y = NowY
    } = Player,
    #figure{lv = _Lv, guild_id = GuildId} = Figure,
    #status_dungeon{out = Out, dun_id = DunId, dun_type = DunType} = Dungeon,
    #dungeon_out{scene = OldSceneId, scene_pool_id = ScenePoolId, copy_id = OldCopyId, x = X, y = Y} = Out,
    #status_team{team_id = TeamId} = Team,

    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType == ?SCENE_TYPE_DUNGEON; SceneType == ?SCENE_TYPE_MAIN_DUN ->
            % 经验;特殊副本处理;协助;队伍
            log_exp_gain(Player, DunId, ResultSubtype, Score),
            Player1 = handle_quit_dungeon(Player, DunId),
            Player2 = lib_guild_assist:quit_dungeon(Player1, DunId, DunType),
            lib_dungeon_util:quit_dungeon(DunType, TeamId, RoleId, ResultType),
            % 场景切换 1.退出去的场景为0;2.公会id等于0和玩家退出的场景为公会场景
            StatusDunAttrList = [
                {dun_id, 0}, {dun_type, 0}, {is_end, ?DUN_IS_END_NO}, {dead_time, 0}, {revive_count, 0},
                {out, #dungeon_out{}}, {help_type, 0}, {revive_map, #{}}, {count, 1}
            ],
            SceneArgs = lib_dungeon_api:invoke(DunType, dunex_get_quit_scene_args, [Player], []),
            AttrList = [{status_dungeon, StatusDunAttrList}, {ghost, 0}, {group, 0}, {change_scene_hp_lim, 1}, {is_change_scene_log, 0} | SceneArgs],
            case OldSceneId == 0 orelse (GuildId == 0 andalso lib_guild:is_guild_scene(OldSceneId)) of
                true ->
                    NewPlayer = lib_scene:change_scene(Player2, 0, 0, 0, 0, 0, true, AttrList);
                false ->
                    {QuitX, QuitY} =
                        case DunType of
                            ?DUNGEON_TYPE_ENCHANTMENT_GUARD -> {NowX, NowY};
                            ?DUNGEON_TYPE_MAIN -> {NowX, NowY};
                            ?DUNGEON_TYPE_DAILY -> {NowX, NowY};
                            _ -> {X, Y}
                        end,
                    NewPlayer = lib_scene:change_scene(Player2, OldSceneId, ScenePoolId, OldCopyId, QuitX, QuitY, false, AttrList)
            end,
            % 协助状态处理
            if
                TeamId > 0 ->
                    #player_status{help_type_setting = HMap} = Player,
                    case maps:find(DunId, HMap) of
                        {ok, HelpType} when is_integer(HelpType) ->
                            NewPlayer1 = NewPlayer;
                        _ ->
                            case lib_dungeon_team:get_default_help_type(Player, DunId) of
                                ?HELP_TYPE_YES ->
                                    #dungeon{type = DunType} = data_dungeon:get(DunId),
                                    SameTypeIds = data_dungeon:get_ids_by_type(DunType),
                                    NHMap = lists:foldl(fun
                                                            (Id, M) ->
                                                                M#{Id => ?HELP_TYPE_YES}
                                                        end, HMap, SameTypeIds),
                                    NewPlayer1 = NewPlayer#player_status{help_type_setting = NHMap},
                                    mod_team:cast_to_team(TeamId, {'set_help_type', Player#player_status.id, DunId, ?HELP_TYPE_YES});
                                _ ->
                                    NewPlayer1 = NewPlayer
                            end
                    end;
                true ->
                    NewPlayer1 = NewPlayer
            end,
            {ok, lib_player:break_action_lock(NewPlayer1, ?ERRCODE(err610_had_on_dungeon))};
        _ ->

            {ok, Player}
    end.

%% 副本关闭
close_dungeon(Player, ResultType, SceneList, CopyId, Score) ->
    #player_status{scene = SceneId, copy_id = RoleCopyId} = Player,
    case lists:member(SceneId, SceneList) andalso RoleCopyId == CopyId of
        true -> immediate_quit_dungeon(Player, [ResultType, ?DUN_RESULT_SUBTYPE_NO, Score]);
        false -> {ok, Player}
    end.

%% 拉玩家进入副本
pull_player_into_dungeon(Player, Data) ->
    [DunId, DunType, ChangeSceneId, ChangeScenePoolId, CopyId, ChangeSceneX, ChangeSceneY, Hp, HpLim, DeadTime, ReviveCount, Out, ReviveMap,
        IsEnd, HelpType, DataBfEnter, Location, SettingList0, WaveNum, Count0] = Data,
    {SettingList, Count} = if
        DunType == ?DUNGEON_TYPE_EQUIP -> lib_dungeon_equip:relac_setting_list_for_pull(Player, DunId, HelpType, SettingList0, Count0);
        true -> {SettingList0, Count0}
    end,
    Result = if
        DunType == ?DUNGEON_TYPE_HIGH_EXP -> lib_dungeon_high_exp:pull_cost(Player, DunId, SettingList);
        DunType == ?DUNGEON_TYPE_EXP_SINGLE -> lib_dungeon_exp:pull_cost(Player, DunId, SettingList);
        DunType == ?DUNGEON_TYPE_VIP_PER_BOSS -> ?IF(mod_counter:get_count(Player#player_status.id, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, DunId) =:= 0,
            {true, Player}, cost(Player, DunId));
        true -> cost(Player, DunId)
    end,
    case Result of
        {true, CostPlayer} ->
            % case Hp == 0 of
            %     true -> Ghost = 1;
            %     false -> Ghost = 0
            % end,
            Ghost = 0, % 强制非幽灵状态状态
            case Hp == 0 of
                true ->
                    #player_status{scene = LeaveSceneId} = CostPlayer,
                    ?ERR("Hp==0 pull_player_into_dungeon LeaveSceneId:~p DunId:~p ~n", [LeaveSceneId, DunId]);
                false ->
                    skip
            end,
            Dun = data_dungeon:get(DunId),
            dungeon_count_increment_multi(Dun, Player#player_status.id, HelpType, ?DUN_COUNT_DEDUCT_ENTER, Count),
            #player_status{dungeon = Dungeon} = CostPlayer,
            NewPlayer = CostPlayer#player_status{
                dungeon = Dungeon#status_dungeon{
                    dun_id = DunId, dun_type = DunType,
                    dead_time = DeadTime, revive_count = ReviveCount,
                    out = Out,
                    revive_map = ReviveMap,
                    is_end = IsEnd,
                    help_type = HelpType, %% 掉落用
                    count = Count
                    }
                },
            SceneArgs = lib_dungeon_api:invoke(DunType, dunex_get_scene_args, [NewPlayer], []),
            AttrList = [{hp, Hp}, {hp_lim, HpLim}, {ghost, Ghost}, {group, ?DUN_DEF_GROUP}, {is_change_scene_log, 1}] ++ SceneArgs,
            % ?MYLOG("hjhteam", "ChangeSceneX:~p,ChangeSceneY:~p~n", [ChangeSceneX, ChangeSceneY]),
            {X, Y} = lib_team_dungeon_mod:get_xy_msg(DunType, DunId, Location, ChangeSceneX, ChangeSceneY),
            NewPlayer2 = lib_scene:change_scene(NewPlayer, ChangeSceneId, ChangeScenePoolId, CopyId, X, Y, false, AttrList),
            NewPlayer3 = handle_enter_dungeon(NewPlayer2, DunId),
            #player_status{dungeon = StatusDungeon} = NewPlayer3,
            NewPlayer4 = NewPlayer3#player_status{dungeon = StatusDungeon#status_dungeon{data_before_enter = DataBfEnter}},
%%            ?IF(Dun#dungeon.type =/= ?DUNGEON_TYPE_RUNE, mod_hi_point:success_end(Player#player_status.id,  ?MOD_DUNGEON, Dun#dungeon.type), skip),
            role_success_end_activity(Player#player_status.id, Player#player_status.figure#figure.lv, HelpType, Dun, Count),
            {ok, BinData} = pt_610:write(61001, [DunId, ChangeSceneId, ?SUCCESS, ""]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            % Lock = ?ERRCODE(err610_had_on_dungeon),
            PlayerAfSetting = lib_dungeon_api:invoke(DunType, dunex_handle_enter_dungeon_for_setting,
                                                    [NewPlayer4, Dun, HelpType, SettingList, Count], NewPlayer4),
            % 波数
            PlayerAfWave = lib_dungeon_api:invoke(DunType, dunex_handle_enter_dungeon_for_wave,
                                                [PlayerAfSetting, Dun, SettingList, WaveNum], PlayerAfSetting),
            {ok, lib_player:setup_action_lock(PlayerAfWave, ?ERRCODE(err610_had_on_dungeon))};
        {false, Code, _} ->
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_610:write(61001, [DunId, 0, CodeInt, CodeArgs]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            mod_dungeon:handle_enter_fail(CopyId, Player#player_status.id, Code),
            {ok, Player}
    end.

handle_enter_dungeon(Player, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType, time = Time} = Dun ->
            Player1 = lib_dungeon_api:invoke(DunType, dunex_handle_enter_dungeon, [Player, Dun], Player),
            Player2
            = case check_other_exp_act(Player1) of
                true ->
                    Player1;
                _ ->
                    CheckDunExpRatio = lib_dungeon_api:check_custom_act_exp_ratio(Player),
                    %% 获取配置
                    Ratio = case lib_dungeon_api:get_custom_act_exp_ratio(DunType) of
                        Ratio0 when CheckDunExpRatio -> Ratio0;
                        _ -> 0
                    end,
                    %% 全服效果
                    Effect = lib_custom_act_liveness:get_server_effect_by_dun_type(Player1, DunType),
                    NewRatio = Effect*?RATIO_COEFFICIENT + Ratio,
                    case NewRatio > 0 of
                        true -> lib_goods_buff:add_goods_temp_buff(Player1, ?BUFF_EXP_DUN_ACT, [{attr, [{?EXP_ADD, NewRatio}]}], utime:unixtime() + Time);
                        false -> Player1
                    end
            end,
            Player2;
        _ ->
            Player
    end.

%% 副本结束触发(玩家身上)
%% @param ResultType 结果
%% @param ResultSubtype 子结果
%% @param Args: 必须要有 #{dun_id = DunId, dun_type = DunType, result_type = ResultType, out = #dungeon_out{} },其他根据副本类型自己加
%% @return {ok, Player}
handle_dungeon_direct_end(Player, ResultType, _ResultSubType, Args) when
        ResultType == ?DUN_RESULT_TYPE_FAIL;
        ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
    #{out := Out, dun_type := DunType} = Args,
    NewPlayer = update_status_dungeon([{out, Out}, {is_end, ?DUN_IS_END_YES}], Player),
    case pp_dungeon:handle(61038, NewPlayer, [DunType]) of
        {ok, NewPlayer1} ->
            {ok, NewPlayer1};
        _ ->
            {ok, NewPlayer}
    end.

%% 玩家离开副本时,触发本函数
%% @param OutType 玩家退出类型(out ：退出， again ：重新进入副本的处理 )
handle_role_out(RoleId, _OutType, [DunId, _ResultType, ResultSubtype, Score, OffMap]) when is_integer(RoleId)->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} = Dun ->
            % 离线处理退出副本
            lib_dungeon_api:invoke(DunType, dunex_handle_quit_dungeon_on_off, [RoleId, OffMap, Dun], skip);
        _ ->
            skip
    end,
    % ?DEBUG("handle_role_out DunId:~p OffMap:~p ~n", [DunId, OffMap]),
    log_exp_gain(RoleId, OffMap, DunId, ResultSubtype, Score),
    ok;
handle_role_out(Player, out, [ResultType, ResultSubtype, Score]) ->
    % ?DEBUG("handle_role_out:out ~n", []),
    immediate_quit_dungeon(Player, [ResultType, ResultSubtype, Score]);
handle_role_out(Player, again, [_ResultType, ResultSubtype, Score]) ->
    % ?DEBUG("handle_role_out:do_out_logic ~n", []),
    #player_status{
        scene = SceneId,
        dungeon = #status_dungeon{dun_id = DunId}
        } = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            NewPlayer = handle_quit_dungeon(Player, DunId),
            log_exp_gain(Player, DunId, ResultSubtype, Score),
            {ok, lib_player:break_action_lock(NewPlayer, ?ERRCODE(err610_had_on_dungeon))};
        _ ->
            {ok, Player}
    end.
    % immediate_quit_dungeon(Player, [ResultType, ResultSubtype, Score]).

%% 处理玩家离开副本
handle_quit_dungeon(Player, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} = Dun ->
            Player1 = lib_dungeon_api:invoke(DunType, dunex_handle_quit_dungeon, [Player, Dun], Player),
            Player2 = lib_goods_buff:remove_goods_temp_buff(Player1, ?BUFF_EXP_DUN_ACT),
            Player2;
        _ ->
            Player
    end.

%% 登录初始化数据
login(Player) ->
    PlayerAfLoad = load_dungeon_record(Player),
    #player_status{id = RoleId, dungeon = Dungeon} = PlayerAfLoad,
    Dungeon1 = reload_status_dun(RoleId, Dungeon),
    PlayerAfRepair = repair_dungeon_record(PlayerAfLoad#player_status{dungeon = Dungeon1}),
    %% 20220523 设定的时间点之前的玩家统一根据玩家等级战力进行跳关操作
    repair_old_version_player_data(PlayerAfRepair),
    PlayerAfRepair.

%% 副本重连
reconnect(#player_status{id = RoleId, figure = Figure, pid = Pid, scene = SceneId} = Player, ?NORMAL_LOGIN) ->
    case mod_dungeon_agent:get_dungeon_record(RoleId) of
        [] ->
            case lib_scene:is_dungeon_scene(SceneId) of
                true ->
                    lib_scene:player_change_default_scene(RoleId, [{change_scene_hp_lim, 0}]),
                    {ok, Player};
                false ->
                    {next, Player}
            end;
        [#dungeon_record{dun_pid = DunPid, dun_id = DunId}] ->
            case misc:is_process_alive(DunPid) of
                true ->
                    case data_dungeon:get(DunId) of
                        [] ->
                            {next, Player};
                        _Dungeon ->
                            mod_dungeon:login(DunPid, RoleId, [{figure, Figure}, {pid, Pid}]),
                            {ok, Player}
                    end;
                false ->
                   {next, Player}
            end
    end;
reconnect(#player_status{scene = SceneId, dungeon = StatusDun} = Player, ?RE_LOGIN) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #status_dungeon{dun_type = DunType} = StatusDun,
            case lib_gm_stop:check_gm_close_act(?MOD_DUNGEON, DunType) of
                true ->
                    NewPlayer = lib_scene:change_relogin_scene(Player, []);
                _ ->
                    NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err610_had_on_dungeon)}])
            end,
            {ok, NewPlayer};
        false ->
            case lib_scene:is_dungeon_scene(SceneId) of
                true ->
                    NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err610_had_on_dungeon)}]),
                    {ok, NewPlayer};
                false ->
                    case ?ERRCODE(err610_had_on_dungeon) =:= Player#player_status.action_lock of
                        true ->
                            {next, lib_player:break_action_lock(Player, Player#player_status.action_lock)};
                        _ ->
                            {next, Player}
                    end
            end
    end.

%% 重新登录
% relogin(Player) ->
%     case lib_dungeon:is_on_dungeon(Player) of
%         true ->
%             #player_status{id = RoleId, copy_id = CopyId} = Player,
%             mod_dungeon:relogin(CopyId, RoleId);
%         false ->
%             skip
%     end.

%% 延迟登出
delay_stop(Player) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{
                id = RoleId, scene = SceneId, scene_pool_id = ScenePoolId,
                dungeon = #status_dungeon{dun_type = DunType}
                } = Player,
            case DunType of
                ?DUNGEON_TYPE_EXP_SINGLE ->
                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'go_to_onhook_place', RoleId});
                ?DUNGEON_TYPE_RANK_KF ->
                    delay_logout(Player);
                _ ->
                    skip
            end;
        false ->
            skip
    end,
    Player.

%% 延迟登出
delay_logout(Player) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim} } = Player,
            OffMap = make_off_map(Player),
            mod_dungeon:delay_logout(CopyId, RoleId, Hp, HpLim, OffMap);
        false ->
            skip
    end.

%% 登出
logout(Player) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId, battle_attr = #battle_attr{hp = Hp, hp_lim = HpLim}} = Player,
            OffMap = make_off_map(Player),
            mod_dungeon:logout(CopyId, RoleId, Hp, HpLim, OffMap);
        false ->
            skip
    end.

%% 打包离线时所需数据,来进程操作,数据量尽量少
%% role
make_off_map(Player) ->
    #player_status{figure = #figure{lv = Lv}, exp = Exp, dungeon = #status_dungeon{data_before_enter = DataBfEnter}} = Player,
    case DataBfEnter of
        DataM when is_map(DataM) -> DataM#{lv => Lv, exp => Exp};
        _ -> #{}
    end.

%% 跳过副本
skip_dungeon(Player) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            #player_status{id = RoleId, copy_id = CopyId} = Player,
            mod_dungeon:skip_dungeon(CopyId, RoleId);
        false ->
            skip
    end.

%% 发送副本复活信息
send_reveive_info(Player) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            case get_revive_info(Player) of
                {false, _ErrorCode} -> IsRevive = 0, NextReviveTime = 0;
                {true, NextReviveTime} -> IsRevive = 1
            end,
            {ok, BinData} = pt_200:write(20009, [IsRevive, NextReviveTime]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false ->
            skip
    end.

%% -----------------------------------------------------------------
%% 关卡处理
%% -----------------------------------------------------------------

change_next_level(Node, RoleId, DunPid, DunId, DunType, Level, SceneId, ScenePoolId) ->
    case unode:is_my_node(Node) of
        true ->
            change_next_level(RoleId, DunPid, DunId, DunType, Level, SceneId, ScenePoolId);
        _ ->
            unode:apply(Node, ?MODULE, change_next_level, [RoleId, DunPid, DunId, DunType, Level, SceneId, ScenePoolId])
    end.

%% 切换下一个关卡
change_next_level(RoleId, DunPid, DunId, DunType, Level, SceneId, ScenePoolId) when is_integer(RoleId) ->
    case lib_player:is_online_global(RoleId) of
        true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_dungeon, change_next_level, [DunPid, DunId, DunType, Level, SceneId, ScenePoolId]);
        false -> skip
    end;
change_next_level(Player, DunPid, _DunId, _DunType, _Level, SceneId, ScenePoolId) ->
    [TargetX, TargetY] = lib_scene:get_born_xy(SceneId),
    % ?PRINT("change_next_level :~w ~n", [[DunPid, _DunId, _DunType, _Level, SceneId, ScenePoolId]]),
    NewPlayer = lib_scene:change_scene(Player, SceneId, ScenePoolId, DunPid, TargetX, TargetY, false, [{ghost, 0}, {change_scene_hp_lim, 0}]),
    NewPlayer1 = case NewPlayer#player_status.online == ?ONLINE_OFF of
        true ->
            case data_scene:get(NewPlayer#player_status.scene) of
                #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
                     {ok, TmpStatus} = pp_scene:handle(12002, NewPlayer, ok), TmpStatus;
                _ -> NewPlayer
            end;
        false ->
            NewPlayer
    end,
    {ok, NewPlayer1}.

%% -----------------------------------------------------------------
%% 通用函数
%% -----------------------------------------------------------------

%% 是否在副本中(副本有可能结束)
is_on_dungeon(Player) ->
    #player_status{copy_id = CopyId, dungeon = StatusDun} = Player,
    #status_dungeon{dun_id = DunId} = StatusDun,
    DunId > 0 andalso misc:is_process_alive(CopyId).

%% 是否副本仍在进行中(副本没有结束)
is_on_dungeon_ongoing(Player) ->
    #player_status{copy_id = CopyId, dungeon = StatusDun} = Player,
    #status_dungeon{dun_id = DunId, is_end = IsEnd} = StatusDun,
    DunId > 0 andalso IsEnd == ?DUN_IS_END_NO andalso misc:is_process_alive(CopyId).

%% 能不能在副本中复活
%% 注意:目前副本只有类型9
%% @return true | {false, ErrorCode}
check_revive_on_dungeon(Player, Type) ->
    #player_status{battle_attr = #battle_attr{hp = Hp}, dungeon = StatusDun} = Player,
    IsOnDungeon = is_on_dungeon(Player),
    DunType = lib_dungeon_api:get_dungeon_type(StatusDun#status_dungeon.dun_id),
    if
        IsOnDungeon == false andalso Type =/= 6 andalso Type =/= 9 -> true;
        %% IsOnDungeon andalso Type == 6 andalso Hp =/= 0 -> {false, 5};
        IsOnDungeon andalso Type == 6 andalso Hp == 0 -> true; %% 玩家在副本中客户端请求幽灵状态
        IsOnDungeon andalso Type == ?REVIVE_SOUL_DUNGEON andalso Hp == 0 -> true;
        IsOnDungeon andalso DunType == ?DUNGEON_TYPE_WEEK_DUNGEON ->
            %% 周常副本要到副本进程那判断复活
            Node = node(),
            mod_dungeon:async_revive(Player#player_status.copy_id, Player#player_status.id, Node),
            {false, 255};
        IsOnDungeon andalso Type == 9 ->                       %% 玩家在副本中请求副本复活类型
            case get_revive_info(Player) of
                {false, ErrorCode} -> {false, ErrorCode};
                {true, NextReiveTime} ->
                    %% 客户端有误差
                    case utime:unixtime() >= NextReiveTime-2 of
                        true -> true;
                        false ->
                            case can_revive_before_timeout(Player#player_status.dungeon#status_dungeon.dun_id) of
                                true -> true;
                                _ -> {false, 5}
                            end
                    end
            end;
        %% 其他的情况
        true -> {false, 5}
    end.

can_revive_before_timeout(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_VIP_PER_BOSS} ->
            true;
        _ ->
            false
    end.

%% 获取复活信息[错误码跟复活协议挂钩]
get_revive_info(Player) ->
    #player_status{dungeon = StatusDun} = Player,
    #status_dungeon{dun_id = DunId, dead_time = DeadTime, revive_count = ReviveCount} = StatusDun,
    get_revive_info(DunId, DeadTime, ReviveCount).

%% 获得复活信息
get_revive_info(DunId, DeadTime, ReviveCount) ->
    Dun = data_dungeon:get(DunId),
    if
        % 复活次数不足
        is_record(Dun, dungeon) == false -> {false, 7};
        % 本副本不允许复活
        Dun#dungeon.revive_type == ?DUN_REVIVE_TYPE_NO -> {false, 9};
        % 复活次数已满
        ReviveCount >= Dun#dungeon.revive_count andalso Dun#dungeon.revive_count =/= 0 -> {false, 7};
        true ->
            #dungeon{revive_type = ReviveType, revive_time = ReviveTime} = Dun,
            case ReviveType == ?DUN_REVIVE_TYPE_TIME_OVERLAY of
                true -> NextReiveTime = DeadTime+(ReviveCount+1)*ReviveTime;
                false -> NextReiveTime = DeadTime+ReviveTime
            end,
            {true, NextReiveTime}
    end.

%% 更新副本状态
update_status_dungeon([], Player) -> Player;
update_status_dungeon([H|T], Player) ->
    #player_status{dungeon = StatusDun} = Player,
    case H of
        {dun_id, DunId} -> NewStatusDun = StatusDun#status_dungeon{dun_id = DunId};
        {dun_type, DunType} -> NewStatusDun = StatusDun#status_dungeon{dun_type = DunType};
        {is_end, IsEnd} -> NewStatusDun = StatusDun#status_dungeon{is_end = IsEnd};
        {dead_time, DeadTime} -> NewStatusDun = StatusDun#status_dungeon{dead_time = DeadTime};
        {revive_count, ReviveCount} -> NewStatusDun = StatusDun#status_dungeon{revive_count = ReviveCount};
        {out, DungeonOut} -> NewStatusDun = StatusDun#status_dungeon{out = DungeonOut};
        {help_type, HelpType} -> NewStatusDun = StatusDun#status_dungeon{help_type = HelpType};
        {revive_map, ReviveMap} -> NewStatusDun = StatusDun#status_dungeon{revive_map = ReviveMap};
        {count, Count} -> NewStatusDun = StatusDun#status_dungeon{count = Count}
    end,
    NewPlayer = Player#player_status{dungeon = NewStatusDun},
    update_status_dungeon(T, NewPlayer).

%% 获取复活点
get_review_xy(Player) ->
    #player_status{scene = SceneId, x = X, y = Y, dungeon = #status_dungeon{revive_map = ReviveMap} } = Player,
    case maps:get(SceneId, ReviveMap, []) of
        [] ->
            % case data_scene:get(SceneId) of
            %     [] -> {X, Y};
            %     #ets_scene{x = NewX, y = NewY} -> {NewX, NewY}
            % end;
            {X, Y, 1};
        {NewX, NewY} ->
            {NewX, NewY, 2}
    end.

%% 获得最大助战次数
get_max_help_count(Dun) ->
    case Dun of
        #dungeon{count_cond = CountCond, type = Type, id = DunId} ->
            if
                Type =:= ?DUNGEON_TYPE_EQUIP -> %% 取得助战奖励次数
                    case data_dungeon_special:get(DunId, help_rewards) of
                        {MaxNum, _} ->
                            MaxNum;
                        _ ->
                            0
                    end;
                Type =:= ?DUNGEON_TYPE_DRAGON -> %% 取得助战奖励次数
                    case data_dungeon_special:get(Type, help_rewards) of
                        {MaxNum, _} ->
                            MaxNum;
                        _ ->
                            0
                    end;
                true -> %% 普通的助战次数
                    case lists:keyfind(?DUN_COUNT_COND_DAILY_HELP, 1, CountCond) of
                        {?DUN_COUNT_COND_DAILY_HELP, MaxNum} -> MaxNum;
                        _ -> 0
                    end
            end;
        _ ->
            0
    end.

update_dungeon_record(#player_status{dungeon_record = undefined} = PS, Data) ->
    NewPS = load_dungeon_record(PS),
    update_dungeon_record(NewPS, Data);

update_dungeon_record(PS, #callback_dungeon_succ{dun_type = DunType} = Data) ->
    lib_dungeon_api:invoke(DunType, dunex_update_dungeon_record, [PS, Data], PS).

load_dungeon_record(#player_status{id = RoleId, dungeon_record = undefined} = PS) ->
    SQL = io_lib:format("SELECT `dun_id`, `data` FROM `dungeon_best_record` WHERE `player_id`=~p", [RoleId]),
    All = db:get_all(SQL),
    Record = init_dungeon_record(All, #{}),
    PS#player_status{dungeon_record = Record};

load_dungeon_record(PS) -> PS.

init_dungeon_record([[DunId, Data]|T], Rec) ->
    Value = util:bitstring_to_term(Data),
    init_dungeon_record(T, Rec#{DunId => Value});
init_dungeon_record([], Rec) -> Rec.

get_dungeon_record_data(RoleId, DunId) ->
    SQL = io_lib:format("SELECT `data` FROM `dungeon_best_record` WHERE `player_id`=~p and `dun_id`=~p", [RoleId, DunId]),
    case db:get_row(SQL) of
        [Data] -> util:bitstring_to_term(Data);
        _ -> []
    end.

save_dungeon_record(RoleId, DunId, Value) ->
    SQL = io_lib:format("REPLACE INTO `dungeon_best_record` (`player_id`, `dun_id`, `data`) VALUES (~p, ~p, '~s')", [RoleId, DunId, util:term_to_string(Value)]),
    % ?PRINT("~s~n", [SQL]),
    db:execute(SQL).

save_dungeon_record(_RoleId, []) -> ok;
save_dungeon_record(RoleId, List) ->
    ValueSql = save_dungeon_record_sql(List, RoleId, "", 1),
    Sql = "REPLACE INTO `dungeon_best_record` (`player_id`, `dun_id`, `data`) VALUES " ++ ValueSql,
    db:execute(Sql),
    ok.

save_dungeon_record_sql([], _RoleId, TmpSql, _Index) -> TmpSql;
save_dungeon_record_sql([{DunId, Value}|T], RoleId, TmpSql, Index) ->
    TmpSql1 = case Index of
        1 -> io_lib:format("(~w, ~w, '~s') ", [RoleId, DunId, util:term_to_string(Value)]) ++ TmpSql;
        _ -> io_lib:format("(~w, ~w, '~s'), ", [RoleId, DunId, util:term_to_string(Value)]) ++ TmpSql
    end,
    save_dungeon_record_sql(T, RoleId, TmpSql1, Index+1).

%% 计算已经消耗次数
calc_use_count(RoleId, DunId, DunType, [{?DUN_COUNT_COND_DAILY, _}|T], _, WeeklyCount, PermanentCount, DailyCountList) ->
    Num
    = case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, lib_dungeon_api:get_daily_count_type(DunType, DunId)}, 1, DailyCountList) of
        {_, Count} ->
            Count;
        _ ->
            0
    end,
    calc_use_count(RoleId, DunId, DunType, T, Num, WeeklyCount, PermanentCount, DailyCountList);

calc_use_count(RoleId, DunId, DunType, [{?DUN_COUNT_COND_WEEK, _}|T], DailyCount, _, PermanentCount, DailyCountList) ->
    Num = mod_week:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    calc_use_count(RoleId, DunId, DunType, T, DailyCount, Num, PermanentCount, DailyCountList);

calc_use_count(RoleId, DunId, DunType, [{?DUN_COUNT_COND_PERMANENT, _}|T], DailyCount, WeeklyCount, _, DailyCountList) ->
    Num = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    calc_use_count(RoleId, DunId, DunType, T, DailyCount, WeeklyCount, Num, DailyCountList);

calc_use_count(_RoleId, _DunId, _DunType, [], DailyCount, WeeklyCount, PermanentCount, _TypicalDailyCount) ->
    {DailyCount, WeeklyCount, PermanentCount}.

calc_record_score(DunId, DunType, RecData) ->
    lib_dungeon_api:invoke(DunType, dunex_calc_record_score, [DunId, RecData], 0).

%% 获得时间的积分
%% @param List [{耗时开始时间,耗时结束时间,加分}]

get_time_score(DunId, PassTime) when is_integer(DunId) ->
    case data_dungeon_grade:get_dungeon_score(DunId) of
        #dungeon_score{time_score_list = CfgTimeScoreList} ->
            get_time_score(CfgTimeScoreList, PassTime);
        _ ->
            0
    end;

get_time_score([], _Time) -> 0;
get_time_score([{Min, Max, Score}|_L], Time) when Time>=Min, Time=<Max -> Score;
get_time_score([_|L], Time) -> get_time_score(L, Time).

get_time_score_step([], _Time) -> 0;
get_time_score_step([{Min, Max, Score}|L], Time) when Time>=Min, Time=<Max ->
    case L of
        [{NextMin, _NextMax, NextScore}|_] ->
            {Score, NextMin, NextScore};
        _ ->
            Score
    end;
get_time_score_step([_|L], Time) -> get_time_score_step(L, Time).

calc_score(#dungeon_state{dun_type = DunType} = State, RoleId) ->
    DefScore = do_calc_score(State, RoleId),
    lib_dungeon_api:invoke(DunType, dunex_calc_score, [State, RoleId], DefScore).

%% 计算分数
do_calc_score(State, RoleId) ->
    {LevelScoreList, IntimacyScoreList, RelaScoreList, GuildScoreList, TimeScoreList, MonScore} = calc_score_help(State, RoleId),
    LevelScore = lists:sum([Score||{_Level, _StartTime, _EndTime, _ResultTime, Score}<-LevelScoreList]),
    IntimacyScore = lists:sum([Score||{_TmpRoleId, _Intimacy, _IntimacyLv, Score}<-IntimacyScoreList]),
    RelaScore = lists:sum([Score||{_TmpRoleId, _RelaType, _IsAskAdd, Score}<-RelaScoreList]),
    GuildScore = lists:sum([Score||{_TmpRoleId, _TmpGuildId, _IsInviteGuild, Score}<-GuildScoreList]),
    TimeScore = lists:sum([Score||{_StartTime, _EndTime, _ResultTime, Score}<-TimeScoreList]),
    LevelScore+IntimacyScore+RelaScore+GuildScore+TimeScore+MonScore.

%% 计算分数辅助函数
calc_score_help(State, RoleId) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList, start_time = StartTime, end_time = EndTime,
        result_time = ResultTime, mon_score = MonScore, story_play_time_mi = StoryTimeMI} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        false -> {[], [], [], [], [], 0};
        #dungeon_role{figure = #figure{guild_id = GuildId}, rela_list = RelaList} ->
            case data_dungeon_grade:get_dungeon_score(DunId) of
                [] -> {[], [], [], [], [], 0};
                #dungeon_score{
                        same_guild_score = SameGuildScore
                        , friend_score = FriendScore
                        , intimacy_score_list = CfgIntimacyScoreList
                        , time_score_list = CfgTimeScoreList
                        } ->
                    F = fun(
                            #dungeon_role_rela{
                                id = TmpRoleId
                                , rela_type = RelaType
                                , intimacy = Intimacy
                                , is_ask_add = IsAskAdd
                                , is_invite_guild = IsInviteGuild
                                }
                            , {IntimacyScoreList, RelaScoreList, GuildScoreList}) ->
                        case lists:keyfind(TmpRoleId, #dungeon_role.id, RoleList) of
                            false -> {IntimacyScoreList, RelaScoreList, GuildScoreList};
                            #dungeon_role{figure = #figure{guild_id = TmpGuildId} } ->
                                case GuildId == TmpGuildId orelse IsInviteGuild == 1 of
                                    true -> CalcGuildScore = SameGuildScore;
                                    false -> CalcGuildScore = 0
                                end,
                                case RelaType == ?RELA_TYPE_FRIEND orelse IsAskAdd == 1 of
                                    true -> CalcFriendScore = FriendScore;
                                    false -> CalcFriendScore = 0
                                end,
                                IntimacyLv = data_relationship:get_intimacy_lv(Intimacy),
                                CalcIntimacyScore = get_intimacy_score(CfgIntimacyScoreList, IntimacyLv),
                                NewIntimacyScoreList = [{TmpRoleId, Intimacy, IntimacyLv, CalcIntimacyScore}|IntimacyScoreList],
                                NewRelaScoreList = [{TmpRoleId, RelaType, IsAskAdd, CalcFriendScore}|RelaScoreList],
                                NewGuildScoreList = [{TmpRoleId, TmpGuildId, IsInviteGuild, CalcGuildScore}|GuildScoreList],
                                {NewIntimacyScoreList, NewRelaScoreList, NewGuildScoreList}
                        end
                    end,
                    {IntimacyScoreList, RelaScoreList, GuildScoreList} = lists:foldl(F, {[],[],[]}, RelaList),
                    PassTime = max(ResultTime - StartTime - erlang:round(StoryTimeMI / 1000), 0),
                    TimeScore = lib_dungeon:get_time_score(CfgTimeScoreList, PassTime),
                    TimeScoreList = [{StartTime, EndTime, ResultTime, TimeScore}],
                    LevelScoreList = calc_level_score_list(State),
                    {LevelScoreList, IntimacyScoreList, RelaScoreList, GuildScoreList, TimeScoreList, MonScore}
            end
    end.

%% 获得关卡分数列表
calc_level_score_list(State) ->
    #dungeon_state{dun_id = DunId, level_result_list = LevelResultList} = State,
    case data_dungeon_grade:get_level_time_scores(DunId) of
        [] ->
            [];
        _ ->
            [calc_level_score(DunId, LevelRes) || LevelRes <- LevelResultList]
    end.

calc_level_score(DunId, #dungeon_level_result{level = Level, start_time = StartTime, end_time = EndTime, result_type = ResultType, result_time = ResultTime}) ->
    case EndTime-StartTime == 0 of
        true -> TimeRatio = 100;
        false -> TimeRatio = min(max(round((ResultTime-StartTime)/(EndTime-StartTime)*100), 0), 100)
    end,
    case data_dungeon_grade:get_dungeon_level_score(DunId, TimeRatio) of
        [] -> Score = 0;
        #dungeon_level_score{score = WinScore, base_score = BaseScore} ->
            case ResultType == ?DUN_RESULT_TYPE_SUCCESS of
                true -> Score = WinScore + BaseScore;
                false -> Score = BaseScore
            end
    end,
    {Level, StartTime, EndTime, ResultTime, Score}.


%% 获得亲密度的积分
%% @param List [{最小亲密度等级,最大亲密度等级,加分}]
get_intimacy_score([], _IntimacyLv) -> 0;
get_intimacy_score([{Min, Max, Score}|_L], IntimacyLv) when IntimacyLv>=Min, IntimacyLv=<Max -> Score;
get_intimacy_score([_|L], IntimacyLv) -> get_intimacy_score(L, IntimacyLv).

send_dungeon_msg(#dungeon_role{node = Node, id = RoleId}, CodeArgs) ->
    {CodeInt, Args} = util:parse_error_code(CodeArgs),
    {ok, BinData} = pt_610:write(61000, [CodeInt, Args]),
    unode:apply(Node, lib_server_send, send_to_uid, [RoleId, BinData]).
    % lib_server_send:send_to_uid(RoleId, BinData).

%% 获取当前推荐的副本id
get_recommend_dun(Player, DunType) ->
    case data_dungeon:get_ids_by_type(DunType) of
        [] ->
            {DunType, 0};
        [DunId] ->
            Dun = data_dungeon:get(DunId),
            {DunType, get_daily_left_count(Player, Dun)};
        IdList ->
            % #player_status{figure = #figure{lv = Lv}} = Player,
            F = fun
                (Id) ->
                    #dungeon{condition = Conditions} = data_dungeon:get(Id),
                    case check_recommend(Player, Conditions, 0) of
                        {ok, Lv} ->
                            {Id, Lv};
                        _ ->
                            false
                    end
            end,
            case [{Id, Lv} || {Id, Lv} <- [F(Id) || Id <- IdList]] of
                [] ->
                    {DunType, 0};
                [{DunId, _}|_] ->
                    Dun = data_dungeon:get(DunId),
                    {DunType, get_daily_left_count(Player, Dun)}
            end
    end.

check_recommend(Player, [{finish_dun_id, DunId}|T], Lv) ->
    Count = mod_counter:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    if
        Count > 0 ->
            check_recommend(Player, T, Lv);
        true -> false
    end;

check_recommend(Player, [{lv, NeedLv}|T], _) -> check_recommend(Player, T, NeedLv);

check_recommend(Player, [_|T], Lv) -> check_recommend(Player, T, Lv);

check_recommend(_Player, [], Lv) -> {ok, Lv}.

%% 获得剩余次数
get_daily_left_count(PS, Dun) ->
    {_, LeftCount} = get_daily_count(PS, Dun),
    LeftCount.

%% 获取玩家副本剩余和总进入次数
%% @return {总次数, 剩余次数}
get_daily_count(PS, Dun) ->
    #player_status{id = RoleId} = PS,
    #dungeon{count_cond = CountCond, id = DunId, type = DunType} = Dun,
    case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCond) of
        {_, Max} ->
            CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            Diff = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                       true ->
                           {?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, CountType};
                       _ ->
                           {?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType}
                   end,
            DailyList = [Diff, {?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType}, {?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType}],
            VipFreeCount = lib_vip_api:get_vip_privilege(PS, ?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType)),
            SupvipAddCount = lib_supreme_vip_api:get_dungeon_num_add(PS, DunType),
            case mod_daily:get_count(RoleId, DailyList) of
                [{_, Num}, {_, BuyCount}, {_, AddCount}] ->
                    AllCount = Max + BuyCount + AddCount + VipFreeCount + SupvipAddCount,
                    {AllCount, max(0,  AllCount- Num)};
                _ ->
                    {0, 0}
            end;
        _ ->
            {16#FFFF, 16#FFFF}
    end.

get_daily_count_list(RoleId, DunType) ->
    mod_daily:get_count(RoleId, lib_dungeon_api:get_daily_count_type_list(DunType)).

get_daily_use_count(DunType, DunId, DailyList, Operate) ->
    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    BuyCount
    = case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType}, 1, DailyList)  of
        {_, C} ->
            C;
        _ ->
            0
    end,
    AddCountType = lib_dungeon_api:get_daily_add_type(DunType, DunId),
    AddCount =
    case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, AddCountType}, 1, DailyList)  of
        {_, AddC} ->
            AddC;
        _ ->
            0
    end,
    DailyCount
    = case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType}, 1, DailyList) of
        {_, Count} ->
            Count;
        _ ->
            0
    end,
    HasSweepCount
    = case Operate of
          1 ->
              case lists:keyfind({?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_CHALLENGE, CountType}, 1, DailyList) of
                  {_, SCount} -> SCount;
                  _ -> 0
              end;
          2 ->
              case lists:keyfind({?MOD_DUNGEON, ?MOD_RESOURCE_DUNGEON_SWEEP, CountType}, 1, DailyList) of
                  {_, SCount} -> SCount;
                  _ -> 0
              end
      end,
    case lists:member(DunType, ?DUNGEON_NEW_VERSION_MATERIEL_LIST) of
        true ->
            HasSweepCount - BuyCount - AddCount;
        false ->
            DailyCount- BuyCount - AddCount
    end.

pick_all(Drops) ->
    NowTime = utime:unixtime(),
    F = fun
        (DropInfo, Acc) ->
            if
                DropInfo#ets_drop.expire_time + 15 > NowTime ->
                    lib_goods_drop:drop_to_goodslist(DropInfo) ++ Acc;
                true ->
                    Acc
            end
    end,
    % ?DEBUG("pick_all player_id = ~p~n ids = ~p~n", [RoleId, [Id || #ets_drop{id = Id} <- Drops]]),
    lists:foldl(F, [], Drops).

get_need_lv(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{condition = Conditions} ->
            case lists:keyfind(lv, 1, Conditions) of
                {lv, NeedLv} ->
                    NeedLv;
                _ -> 1
            end;
        _ ->
            1
    end.

get_recommend_dun_id(Player, DunType) ->
    case data_dungeon:get_ids_by_type(DunType) of
        [] ->
            0;
        Ids ->
            #player_status{figure = #figure{lv = RoleLv}} = Player,
            LvList = lists:reverse(lists:keysort(2, [{Id, get_need_lv(Id)} || Id <- Ids])),
            calc_recommend_dun_id(RoleLv, LvList)
    end.

calc_recommend_dun_id(RoleLv, [{Id, NeedLv}|_]) when RoleLv >= NeedLv ->
    Id;

calc_recommend_dun_id(RoleLv, [_|T]) ->
    calc_recommend_dun_id(RoleLv, T);

calc_recommend_dun_id(_RoleLv, []) -> 0.

%%calc_base_reward_list(DungeonRole) ->
%%    case DungeonRole#dungeon_role.calc_reward_list of
%%        {msg, _Code, Rewards} ->
%%            ok;
%%        [{base, Rewards}|_] ->
%%            ok;
%%        Rewards -> ok
%%    end,
%%    %% 显示用，此时并未捡起来
%%    DropGoods = pick_all(DungeonRole#dungeon_role.drop_list),
%%    lib_goods_api:make_reward_unique(DungeonRole#dungeon_role.drop_reward_list ++ DropGoods ++ Rewards).

calc_base_reward_list(#dungeon_role{reward_map = RewardMap}) ->
    lib_dungeon:get_source_list(RewardMap).

%% 获取进入等级
%% 用于生怪:进入平均等级
calc_enter_lv([], _) -> 99;
calc_enter_lv(RoleList, DunType) ->
    Lvs = [Lv||#dungeon_role{figure = #figure{lv = Lv}}<-RoleList],
    SumLv = lists:sum([Lv||#dungeon_role{figure = #figure{lv = Lv}}<-RoleList]),
    case DunType of
        ?DUNGEON_TYPE_EXP ->
            max(trunc(SumLv/length(RoleList)), trunc(0.8*lists:max(Lvs)));
        ?DUNGEON_TYPE_EVIL ->
            max(trunc(SumLv/length(RoleList)), trunc(0.95*lists:max(Lvs)));
        _ ->
            trunc(SumLv/length(RoleList))
    end.

login_back_to_scene(Player, SceneId, ScenePoolId, CopyId, X, Y, AttrList) ->
    lib_scene:change_scene(Player, SceneId, ScenePoolId, CopyId, X, Y, false, AttrList).


handle_achievement(Player, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            lib_guild_daily:enter_dun(DunType, Player#player_status.id),
            case DunType of
%%                ?DUNGEON_TYPE_ENCHANTMENT_GUARD ->
%%                    {ok, NewPlayer} = lib_achievement_api:pass_enchantment_dun_event(Player, []);
               ?DUNGEON_TYPE_RUNE ->
                   % lib_achievement_api:pass_soul_dun_floor(Player, DunId),
                   {ok, NewPlayer} = lib_achievement_api:dungeon_soul_event(Player, []);
                ?DUNGEON_TYPE_RUNE2 ->
                    lib_achievement_api:pass_rune_dun_floor(Player, DunId),
                    {ok, NewPlayer} = lib_achievement_api:dungeon_rune_event(Player, []);
                ?DUNGEON_TYPE_EXP ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_exp_event(Player, []);
                ?DUNGEON_TYPE_COIN ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_coin_event(Player, []);
                ?DUNGEON_TYPE_EQUIP ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_equip_event(Player, []);
                ?DUNGEON_TYPE_EXP_SINGLE ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_exp_event(Player, []);
                ?DUNGEON_TYPE_PER_BOSS ->
                    {ok, NewPlayer} = lib_achievement_api:boss_personal_event(Player, DunId);
                ?DUNGEON_TYPE_TOWER ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_tower_floor(Player, DunType);
                ?DUNGEON_TYPE_COUPLE ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_cuple_event(Player, DunType);
                ?DUNGEON_TYPE_SPRITE_MATERIAL ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_sprite_event(Player, DunType);
                ?DUNGEON_TYPE_PARTNER ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_partner_event(Player, DunType);
                ?DUNGEON_TYPE_VIP_PER_BOSS ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_vip_perboss_event(Player, DunType);
                ?DUNGEON_TYPE_MOUNT_MATERIAL ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_mount_event(Player, DunType);
                ?DUNGEON_TYPE_AMULET_MATERIAL ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_amulet_event(Player, DunType);
                ?DUNGEON_TYPE_WEAPON_MATERIAL ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_weapon_event(Player, DunType);
                ?DUNGEON_TYPE_WING_MATERIAL ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_wing_event(Player, DunType);
                ?DUNGEON_TYPE_BACK_ACCESSORIES ->
                    {ok, NewPlayer} = lib_achievement_api:dungeon_back_event(Player, DunType);
                _ ->
                    NewPlayer = Player
            end;
        _ ->
            NewPlayer = Player
    end,
    NewPlayer.

%%通关副本日常处理
handle_activitycalen(#player_status{id =RoleId},  DunId) ->
%%    ?MYLOG("cym", "+++++ DunId ~p~n", [DunId]),
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            case  DunType  of
                ?DUNGEON_TYPE_PER_BOSS ->
                    handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_PERSON_BOSS,  1);
%%                ?DUNGEON_TYPE_VIP_PER_BOSS ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_VIP_PERSONAL_BOSS,  1);
                ?DUNGEON_TYPE_WING ->
                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_WING,  1);
                ?DUNGEON_TYPE_PARTNER ->
                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_PARTNER,  1);
                ?DUNGEON_TYPE_MON_INVADE ->
                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_MON_INVADE,  1);
                ?DUNGEON_TYPE_COUPLE ->
                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_COUPLE,  1);
                _ ->
                    case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                        true -> handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  DunType,  1);
                        false -> ok
                    end
            end;
        _ ->
            skip
    end.

%% 触发任务
handle_task_trigger(RoleId, DunType, DunId) when is_integer(RoleId) ->
    if
        DunType == ?DUNGEON_TYPE_EQUIP ->
            EquipCountType = lib_dungeon_api:get_daily_count_type(?DUNGEON_TYPE_EQUIP, 0),
            Count = mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, EquipCountType),
            lib_role:update_role_show(RoleId, [{daily_dun, EquipCountType, Count}]);
        true ->
            skip
    end,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, handle_task_trigger, [DunType, DunId]);
handle_task_trigger(#player_status{id = RoleId} = Player, DunType, DunId) ->
    if
        DunType == ?DUNGEON_TYPE_RUNE2 orelse DunType == ?DUNGEON_TYPE_TOWER ->
            Level = lib_dungeon_api:get_dungeon_level(Player, DunType),
            lib_task_api:fin_dun_level(RoleId, DunType, Level);
        true ->
            skip
    end,
    lib_task_api:fin_dun_type(RoleId, DunType),
    lib_task_api:fin_dun(RoleId, DunId),
    {ok, PlaerAfSkill} = lib_dungeon_learn_skill:fin_dun(Player, DunId),
    {ok, PlayerAfSupvip} = lib_supreme_vip_api:trigger_dun(PlaerAfSkill, DunType, DunId),
    {ok, PlayerAfSupvip}.

calc_buy_count_cost(BuyCost, VipBuyCount, Count, Acc) when Count > 0 ->
    NewCount = VipBuyCount + 1,
    case lists:keyfind(NewCount, 1, BuyCost) of
        {_, Num} ->
            calc_buy_count_cost(BuyCost, NewCount, Count - 1, Acc + Num);
        _ ->
            calc_buy_count_cost(BuyCost, NewCount, Count - 1, Acc)
    end;

calc_buy_count_cost(_, _, _, Acc) -> Acc.

%% 获得副本日常数据
%% @return [{DunType, [#dungeon_info{},...]},...]
get_daily_data(RoleId, DataList, DunType, MFA) ->
    case lists:keyfind(unknown, #dungeon_info.daily_count, DataList) of
        false ->
            get_weekly_data(RoleId, [{DunType, DataList}], MFA);
        _ ->
            mod_daily:apply_cast(RoleId, ?MODULE, get_daily_data, [RoleId, [{DunType, DataList}], MFA])
    end.

%% 在日常进程获取数据
get_daily_data([RoleId, List, MFA]) ->
    DailyDataList = [{DunType, do_get_daily_data(RoleId, DataList, DunType)} || {DunType, DataList} <- List],
    get_weekly_data(RoleId, DailyDataList, MFA).

do_get_daily_data(RoleId, DataList, DunType) ->
    % [#dungeon_info{id = DunId}|_] = DataList,
    DataListWithDailyCount
    = case lib_dungeon_api:get_daily_count_type(DunType, -1) of
        DunType ->
            DailyCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunType),
            [Data#dungeon_info{daily_count = DailyCount} || Data <- DataList];
        _ ->
            [begin
                DailyCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Data#dungeon_info.id),
                Data#dungeon_info{daily_count = DailyCount}
            end || Data <- DataList]
    end,
    DataListWithBuyCount
    = case lib_dungeon_api:get_daily_buy_type(DunType, -1) of
        DunType ->
            BuyCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_BUY, DunType),
            [Data#dungeon_info{buy_count = BuyCount} || Data <- DataListWithDailyCount];
        _ ->
            [begin
                BuyCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_BUY, Data#dungeon_info.id),
                Data#dungeon_info{buy_count = BuyCount}
            end || Data <- DataListWithDailyCount]
    end,
    DataListWithResetCount
    = case lib_dungeon_api:get_daily_reset_type(DunType, -1) of
        DunType ->
            ResetCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_RESET, DunType),
            [Data#dungeon_info{reset_count = ResetCount} || Data <- DataListWithBuyCount];
        _ ->
            [begin
                ResetCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_RESET, Data#dungeon_info.id),
                Data#dungeon_info{reset_count = ResetCount}
            end || Data <- DataListWithBuyCount]
    end,
    DataListWithAddCount
    = case lib_dungeon_api:get_daily_add_type(DunType, -1) of
        DunType ->
            AddCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, DunType),
            [Data#dungeon_info{add_count = AddCount} || Data <- DataListWithResetCount];
        _ ->
            [begin
                AddCount = lib_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, Data#dungeon_info.id),
                Data#dungeon_info{add_count = AddCount}
            end || Data <- DataListWithResetCount]
    end,
    % get_weekly_data(RoleId, DataListWithResetCount, DunType, MFA).
    DataListWithAddCount.

get_weekly_data(RoleId, List, MFA) ->
    case lists:any(fun
        ({_, DataList}) ->
            lists:keyfind(unknown, #dungeon_info.weekly_count, DataList) =/= false
    end, List) of
        false ->
            get_permanent_count(RoleId, List, MFA);
        _ ->
            mod_week:apply_cast(RoleId, ?MODULE, get_weekly_data, [RoleId, List, MFA])
    end.

%% 在星期计数进程里
get_weekly_data([RoleId, List, MFA]) ->
    WeeklyDataList = [{DunType, do_get_weekly_data(RoleId, DataList)} || {DunType, DataList} <- List],
    get_permanent_count(RoleId, WeeklyDataList, MFA).

do_get_weekly_data(RoleId, DataList) ->
    [begin
        WeeklyCount = lib_week:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Data#dungeon_info.id),
        Data#dungeon_info{weekly_count = WeeklyCount}
    end || Data <- DataList].
    % get_permanent_count(RoleId, DataListWithWeeklyCount, DunType, MFA).


get_permanent_count(RoleId, List, {_M,_F,_A} = MFA) ->
    % case lists:any(fun
    %     ({_, DataList}) ->
    %         lists:keyfind(unknown, #dungeon_info.permanent_count, DataList) =/= false
    % end, List) of
    %     false ->
    %         M:F(RoleId, List, A);
    %     _ ->
    %         mod_counter:apply_cast(RoleId, ?MODULE, get_permanent_count, [RoleId, List, MFA])
    % end.
    % 必须执行,要在 mod_counter 获得胜利次数
    mod_counter:apply_cast(RoleId, ?MODULE, get_permanent_count, [RoleId, List, MFA]).

%% 在终生次数进程里
get_permanent_count([RoleId, List, {M,F,A}]) ->
    PermanentDataList = [{DunType, do_get_permanent_count(RoleId, DataList)} || {DunType, DataList} <- List],
    M:F(RoleId, PermanentDataList, A).

do_get_permanent_count(RoleId, DataList) ->
    [begin
        PermanentCount = lib_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Data#dungeon_info.id),
        SuccessCount = lib_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, Data#dungeon_info.id),
        IsFirstChallenge = ?IF(lib_counter:get_count(RoleId, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, Data#dungeon_info.id) =:= 0, 0, 1),
        Data#dungeon_info{permanent_count = PermanentCount, success_count = SuccessCount, is_first_challenge = IsFirstChallenge}
    end || Data <- DataList].

send_dungeon_info(RoleId, [{DunType, DataList}], [RoleLv]) ->
    FormatList = [
        begin
            IsSweep = ?IF(lib_dungeon_sweep:simple_check_sweep(DungeonInfo, RoleLv), 1, 0),
            IsFinish = ?IF(SuccessCount >= 1, 1, 0),
            %% VIP个人BOSS是否首次挑战
            FirstChallenge = ?IF(DunType == ?DUNGEON_TYPE_VIP_PER_BOSS, [{10, IsFirstChallenge}], []),
            NewData = [{5, IsFinish}] ++ FirstChallenge ++ Data,
            {DunId, DailyCount, WeeklyCount, ?IF(Data =:= [],PermanentCount,max(PermanentCount, 1)), ResetCount, BuyCount, AddCount, IsSweep, NewData}
        end ||
        #dungeon_info{
            id                 = DunId,
            daily_count        = DailyCount,
            weekly_count       = WeeklyCount,
            permanent_count    = PermanentCount,
            reset_count        = ResetCount,
            buy_count          = BuyCount,
            add_count          = AddCount,
            data               = Data,
            success_count      = SuccessCount,
            is_first_challenge = IsFirstChallenge
        } = DungeonInfo <- DataList
        ],
    %%?PRINT("Send:~p~n", [{DunType, FormatList}]),
    {ok, BinData} = pt_610:write(61020, [DunType, FormatList]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 根据副本类型创建 #dungeon_info{} 列表信息
create_dungeon_infos(Rec, DunType) ->
    Ids = data_dungeon:get_ids_by_type(DunType),
    F = fun
        (DunId) ->
            IsRec = maps:is_key(DunId, Rec),
            DefData = maps:get(DunId, Rec, []),
            Data = lib_dungeon_api:invoke(DunType, dunex_get_best_record, [DunId, Rec], DefData),
            #dungeon{count_cond = CountCondition} = data_dungeon:get(DunId),
            DailyCount
            = case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCondition) of
                false ->
                    case lists:keyfind(?DUN_COUNT_COND_DAILY_REWARD, 1, CountCondition) of
                        false ->
                            0;
                        _ ->
                            unknown
                    end;
                _ ->
                    unknown
            end,
            WeeklyCount
            = case lists:keyfind(?DUN_COUNT_COND_WEEK, 1, CountCondition) of
                false ->
                    0;
                _ ->
                    unknown
            end,
            PermanentCount
            = case lists:keyfind(?DUN_COUNT_COND_PERMANENT, 1, CountCondition) of
                false ->
                    0;
                _ ->
                    unknown
            end,
            #dungeon_info{id = DunId, data = Data, is_rec = IsRec, daily_count = DailyCount, weekly_count = WeeklyCount, permanent_count = PermanentCount}
    end,
    [F(DunId) || DunId <- Ids].

%% 发送副本摘要信息
get_summary_dungeon_info(RoleId, RoleLv, Rec, Args) ->
    Types = data_dungeon:get_types(),
    List = [{DunType, create_dungeon_infos(Rec, DunType)} || DunType <- Types],
    SlimList = [{DunType, [Info || Info <- DataList, get_need_lv(Info#dungeon_info.id) =< RoleLv]} || {DunType, DataList} <- List],
    mod_daily:apply_cast(RoleId, ?MODULE, get_daily_data, [RoleId, SlimList, {?MODULE, send_summary_info, Args}]).

send_summary_info(RoleId, List, Args) ->
    FormatList = [check_dungeon_available(DunType, DataList, Args) || {DunType, DataList} <- List],
    {ok, BinData} = pt_610:write(61037, [FormatList]),
    % ?PRINT("61037 ~p~n", [FormatList]),
    lib_server_send:send_to_uid(RoleId, BinData).

send_typical_summary_info(RoleId, [{DunType, DataList}], Args) ->
    {DunType, Available, LeftCount, AllCount} = check_dungeon_available(DunType, DataList, Args),
    {ok, BinData} = pt_610:write(61038, [DunType, Available, LeftCount, AllCount]),
    % ?PRINT("61038 >> ~p ~p~n", [DunType, check_dungeon_available(DunType, DataList)]),
    lib_server_send:send_to_uid(RoleId, BinData).

check_dungeon_available(DunType, DataList, Args) when
        DunType =:= ?DUNGEON_TYPE_COIN orelse
        DunType =:= ?DUNGEON_TYPE_PET orelse
        DunType =:= ?DUNGEON_TYPE_EQUIP orelse
        DunType =:= ?DUNGEON_TYPE_RUNE orelse
        DunType =:= ?DUNGEON_TYPE_VIP_PER_BOSS orelse
        DunType =:= ?DUNGEON_TYPE_WAKE orelse
        DunType =:= ?DUNGEON_TYPE_EXP orelse
        DunType =:= ?DUNGEON_TYPE_EXP_SINGLE
        ->
    {Available, LeftCount, AllCount} = calc_dungeon_summary(DataList, Args),
    {DunType, Available, LeftCount, AllCount};
    % case ulists:any(fun
    %     (#dungeon_info{id = DunId, daily_count = DailyCount, buy_count = BuyCount}) ->
    %         case data_dungeon:get(DunId) of
    %             #dungeon{count_cond = CountCondition} ->
    %                 case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCondition) of
    %                     {_, DailyLimit} ->
    %                         DailyLimit + BuyCount - DailyCount > 0;
    %                     _ ->
    %                         false
    %                 end;
    %             _ ->
    %                 false
    %         end
    % end, DataList) of
    %     true ->
    %         1;
    %     _ ->
    %         0
    % end;

check_dungeon_available(DunType, _, _) -> {DunType, 0, 0, 0}.

calc_dungeon_summary([DunInfo|T], Args) ->
    #dungeon_info{id = DunId, daily_count = DailyCount, buy_count = BuyCount, add_count = AddCount} = DunInfo,
    case data_dungeon:get(DunId) of
        #dungeon{count_cond = CountCondition, type = DunType} ->
            case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCondition) of
                {_, DailyLimit} ->
                    VipLv = get_args(vip, Args, 0),
                    VipType = get_args(vip_type, Args, 0),
                    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
                    VipFreeCount = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType), VipType, VipLv),
                    VipSweepCount = case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                                        true ->
                                            lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_BUY_RIGHT_ID(CountType), VipType, VipLv);
                                        _ ->
                                            0
                                    end,
                    AllCountLimit = DailyLimit + BuyCount + AddCount + VipFreeCount + VipSweepCount,
                    LeftCount = max(AllCountLimit - DailyCount, 0),
                    Available = if LeftCount > 0 -> 1; true -> 0 end,
                    {Available, LeftCount, AllCountLimit};
                _ ->
                    calc_dungeon_summary(T, Args)
            end;
        _ ->
            calc_dungeon_summary(T, Args)
    end;
calc_dungeon_summary([], _Args) -> {0, 0, 0}.

get_args(Key, Args, Default) ->
    case lists:keyfind(Key, 1, Args) of
        {Key, V} ->
            V;
        _ ->
            Default
    end.

%% 自动购买进入消耗
get_default_auto_buy_option(#dungeon{type = DunType}) ->
    case DunType of
        ?DUNGEON_TYPE_VIP_PER_BOSS ->
            true;
        ?DUNGEON_TYPE_WAKE ->
            true;
        _ ->
            false
    end;
get_default_auto_buy_option(_) -> false.

role_success_end_activity(RoleId, Dun) ->  %%进入场景时调用
    role_success_end_activity(RoleId, 1, ?HELP_TYPE_NO, Dun, 1).

role_success_end_activity(RoleId, _RoleLv, HelpType, Dun, Count) ->
    lib_baby_api:join_dungeon(RoleId, Dun#dungeon.type, Count),
    ?IF(HelpType == ?HELP_TYPE_NO,
        begin
            Data = #callback_dungeon_enter{dun_id = Dun#dungeon.id, dun_type = Dun#dungeon.type, count = Count},
            lib_player_event:async_dispatch(RoleId, ?EVENT_DUNGEON_ENTER, Data)
        end, skip),
    case Dun#dungeon.type of
        ?DUNGEON_TYPE_EXP_SINGLE ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_EXP_SINGLE, Count);
        ?DUNGEON_TYPE_RUNE2 ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_RUNE2, Count);
        ?DUNGEON_TYPE_TOWER ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_TOWER, Count);
        ?DUNGEON_TYPE_VIP_PER_BOSS ->
            lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_BOSS, ?BOSS_TYPE_VIP_PERSONAL, Count),
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_VIP_PER_BOSS, Count);
        ?DUNGEON_TYPE_EQUIP ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_EQUIP, Count);
        ?DUNGEON_TYPE_HIGH_EXP ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_HIGH_EXP, Count);
        ?DUNGEON_TYPE_DRAGON ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_DUNGEON,  ?DUNGEON_TYPE_DRAGON, Count);
        ?DUNGEON_TYPE_BEINGS_GATE ->
            lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_BEINGS_GATE, 1, Count);
        _DunType ->
            skip
%%            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_DUNGEON, DunType)  %%不用全部都通知
    end.

daily_reset(Player, ?FOUR) ->
    % {ok, MonInvadePlayer} = lib_dungeon_mon_invade:handle_daily_reward(Player),
    Player#player_status{help_type_setting = #{}};

daily_reset(Player, _) ->
    Player.

% calc_cost(Player, #dungeon{cost = [{_, _, Cost0}|_] = CostList, id = DunId, type = DunType}) when is_list(Cost0) ->
%     CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
%     Num = mod_daily:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType) + 1,
%     {ok, {_, _, Cost}} = ulists:find(fun
%         ({X, Y, _}) ->
%             X =< Num andalso Num =< Y
%     end, CostList),
%     Cost;

% calc_cost(_Player, #dungeon{cost = Cost}) -> Cost;

calc_cost(Player, Dun) -> calc_cost_multi(Player, Dun, 1).

%% 多次计算
calc_cost_multi(Player, #dungeon{id = DunId, type = DunType} = Dun, Count) ->
    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    Num = mod_daily:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType),
    calc_cost_multi(Player, Dun, Num, Count, []);

calc_cost_multi(_, _, _) ->
    [].

calc_cost_multi(_Player, _Dun, _StartCount, Count, SumCost) when Count =< 0 -> lib_goods_api:make_reward_unique(SumCost);

calc_cost_multi(Player, #dungeon{cost = [{_, _, Cost0}|_] = CostList} = Dun, StartCount, Count, SumCost) when is_list(Cost0) ->
    Num = StartCount + Count,
    {ok, {_, _, Cost}} = ulists:find(fun
        ({X, Y, _}) ->
            X =< Num andalso Num =< Y
    end, CostList),
    calc_cost_multi(Player, Dun, StartCount, Count-1, Cost++SumCost);

calc_cost_multi(Player, #dungeon{cost = Cost} = Dun, StartCount, Count, SumCost) ->
    calc_cost_multi(Player, Dun, StartCount, Count-1, Cost++SumCost);

calc_cost_multi(_, _, _, _, SumCost) -> SumCost.



check_other_exp_act(Player) ->
    NowTime = utime:unixtime(),
    case Player#player_status.collect of
        #collect_status{exp_end_time = EndTime} when NowTime < EndTime ->
            true;
        _ ->
            false
    end.

get_mul_drop_times(#dungeon{type = DunType}, #player_status{collect = #collect_status{drop_end_time = DropEndTime}} = Player) ->
    N = case lib_dungeon_api:get_custom_act_drop_times(DunType) of
        N0 when N0 > 1 ->
            N0;
        _ ->
            lib_collect:get_custom_act_drop_times(DunType, DropEndTime)
    end,
    Effect = lib_custom_act_liveness:get_server_effect_by_dun_type(Player, DunType),
    N + Effect;
get_mul_drop_times(DunType, #player_status{collect = #collect_status{drop_end_time = DropEndTime}} = Player) ->
    N = case lib_dungeon_api:get_custom_act_drop_times(DunType) of
            N0 when N0 > 1 ->
                N0;
            _ ->
                lib_collect:get_custom_act_drop_times(DunType, DropEndTime)
        end,
    Effect = lib_custom_act_liveness:get_server_effect_by_dun_type(Player, DunType),
    N + Effect.

log_exp_gain(#player_status{id = RoleId} = Player, DunId, ResultSubtype, Score) ->
    OffMap = make_off_map(Player),
    log_exp_gain(RoleId, OffMap, DunId, ResultSubtype, Score),
    ok.

log_exp_gain(RoleId, OffMap, DunId, ResultSubtype, Score) ->
    case dun_need_log_exp(DunId) of
        true ->
            case OffMap of
                #{lv_before := Lv, exp_before := Exp, lv := NewLv, exp := NewExp,
                  mon_exp := MonExp, ratio1 := Ratio1, ratio2 := Ratio2} ->
                    lib_log_api:log_dungeon_exp_gain(RoleId, DunId, Lv, NewLv, calc_got_exp(NewLv, NewExp, Lv, Exp), MonExp, Ratio1, Ratio2, ResultSubtype, Score, utime:unixtime());
                #{lv_before := Lv, exp_before := Exp, lv := NewLv, exp := NewExp} -> % 兼容更新后正好结算的玩家
                    lib_log_api:log_dungeon_exp_gain(RoleId, DunId, Lv, NewLv, calc_got_exp(NewLv, NewExp, Lv, Exp), 0, 0, 0, ResultSubtype, Score, utime:unixtime());
                _ ->
                    ok
            end;
        false ->
            skip
    end.

calc_got_exp(NewLv, AddExp, Lv, Exp) when NewLv > Lv ->
    MaxExp = data_exp:get(NewLv),
    if
        NewLv - Lv == 1 ->
            AddExp + MaxExp - Exp;
        true ->
            calc_got_exp(NewLv - 1, MaxExp + AddExp, Lv, Exp)
    end;
calc_got_exp(_NewLv, AddExp, _Lv, Exp) ->
    max(AddExp - Exp, 0).

dun_need_log_exp(DunId) ->
    case data_dungeon:get(DunId)of
        #dungeon{type = DunType} ->
            DunType =:= ?DUNGEON_TYPE_EXP
                orelse DunType =:= ?DUNGEON_TYPE_PET
                orelse DunType =:= ?DUNGEON_TYPE_EQUIP
                orelse DunType =:= ?DUNGEON_TYPE_GUILD_GUARD
                orelse DunType =:= ?DUNGEON_TYPE_WAKE
                orelse DunType =:= ?DUNGEON_TYPE_EXP_SINGLE;
        _ ->
            false
    end.

clear_dun_enter_count(PlayerId, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            DailyCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            mod_daily:set_count_offline(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DailyCountType, 0),
            ok;
        _ ->
            error
    end.

repair_dungeon(RoleId, DunId, Count, MailContent) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType, cost = [{GoodsId, Num}], name = DunName} ->
            DailyCountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
            CurCount = mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DailyCountType),
            case min(CurCount, Count) of
                BackCount when BackCount > 0 ->
                    BackCost = [{?TYPE_BIND_GOODS, GoodsId, Num * BackCount}],
                    mod_daily:set_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DailyCountType, CurCount - BackCount),
                    Title = uio:format("{1}副本补偿", [DunName]),
                    CostName = data_goods:get_goods_name(GoodsId),
                    Content = uio:format(MailContent, [DunName, CostName, BackCount]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, BackCost);
                _ ->
                    skip
            end;
        _ ->
            error
    end.

%% 购买副本次数
buy_count(#player_status{id = RoleId} = Player, DunId, Count) ->
    case check_buy_count(Player, DunId, Count) of
        {false, ErrorCode} -> NewPlayer = Player, ShowVipBuyCount = 0, DunType = false;
        {true, Dun, DunType, CountType, VipBuyCount, NewVipBuyCount, BGoldNum} ->
            case lib_goods_api:cost_object_list_with_check(Player, [{?TYPE_BGOLD, 0, BGoldNum}],  dungeon_count_buy_cost, integer_to_list(DunId)) of
                {true, NewPlayer0} ->
                    ErrorCode = ?SUCCESS, ShowVipBuyCount = NewVipBuyCount,
                    NewPlayer =
                    case lib_dungeon_api:invoke(DunType, dunex_buy_count_done, [Player, Dun, VipBuyCount, Count], NewPlayer0) of
                        {ok, TemPlayer} -> TemPlayer;
                        _ -> NewPlayer0
                    end,
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_resource_back, add_vip_buy_count, [?MOD_DUNGEON, DunType, Count]),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, buy_dun, [DunType, Count]),
                    mod_daily:set_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType, NewVipBuyCount);
                _ ->
                    ErrorCode = ?ERRCODE(err610_buy_cost_error),
                    NewPlayer = Player,
                    ShowVipBuyCount = VipBuyCount
            end
    end,
    {ok, BinData} = pt_610:write(61021, [ErrorCode, DunId, ShowVipBuyCount]),
    lib_server_send:send_to_sid(NewPlayer#player_status.sid, BinData),
    case ErrorCode == ?SUCCESS andalso is_integer(DunType) of
        true ->
            % 副本摘要信息更新
            case pp_dungeon:handle(61038, NewPlayer, [DunType]) of
                {ok, NewPlayer1} -> {ok, NewPlayer1};
                _ -> {ok, NewPlayer}
            end;
        false ->
            {ok, NewPlayer}
    end.

%% 检查购买
check_buy_count(Player, DunId, Count) ->
    case data_dungeon:get(DunId) of
        #dungeon{buy_count_cost = [_|_] = BuyCost, type = DunType} = Dun when Count >0 ->
            #player_status{id = RoleId, figure = #figure{vip = VipLv, vip_type = VipType}, marriage = #marriage_status{lover_role_id = LoverId}} = Player,
            CountType = lib_dungeon_api:get_daily_buy_type(DunType, DunId),
            VipCountLimit = lib_vip_api:get_vip_privilege(?MOD_DUNGEON, ?VIP_DUNGEON_BUY_RIGHT_ID(CountType), VipType, VipLv),
            VipBuyCount = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType),
            NewVipBuyCount = VipBuyCount + Count,
            BGoldNum = calc_buy_count_cost(BuyCost, VipBuyCount, Count, 0),
            if
                %% 伴侣副本要结婚才能买次数
                DunType == ?DUNGEON_TYPE_COUPLE andalso LoverId == 0 -> {false, ?ERRCODE(err610_buy_not_marriage)};
                % vip购买次数检查
                is_integer(VipCountLimit) == false orelse VipCountLimit =< 0 -> {false, ?ERRCODE(err610_buy_vip_error)};
                % vip购买次数是否足够
                NewVipBuyCount > VipCountLimit -> {false, ?ERRCODE(err610_buy_limit_error)};
                % 购买消耗不能等于0
                BGoldNum == 0 -> {false, ?ERRCODE(err610_buy_count_error)};
                true -> {true, Dun, DunType, CountType, VipBuyCount, NewVipBuyCount, BGoldNum}
            end;
        _ ->
            {false, ?ERRCODE(err610_buy_count_error)}
    end.

%% 使用物品次数物品
use_dungeon_count_goods(PlayerStatus, GoodsTypeId, GoodsNum) ->
    case data_goods:get_effect_val(GoodsTypeId, dun_id) of
        0 -> {false, ?ERRCODE(err150_type_err)};
        DunId ->
            NewPs = lib_dungeon:add_dungeon_count(PlayerStatus, DunId, GoodsNum),
            case data_dungeon:get(DunId) of
                #dungeon{type = DunType} -> pp_dungeon:handle(61020, NewPs, [DunType]);
                _ -> skip
            end,
            {ok, NewPs}
    end.

%% 增加副本次数
add_dungeon_count(#player_status{id = RoleId} = Player, DunId, Count) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            CountType = lib_dungeon_api:get_daily_add_type(DunType, DunId),
            case get_add_count_limit_by_dungeon(DunId, DunType) of
                not_limit ->
                    mod_daily:plus_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType, Count);
                CountLimit ->
                    case mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType) >= CountLimit of
                        false ->
                            mod_daily:plus_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType, Count);
                        _ ->
                            skip
                    end
            end;
        _ ->
            skip
    end,
    Player.

%% 增加副本次数
add_dungeon_type_count(#player_status{id = RoleId} = Player, DunType, Count) ->
    mod_daily:plus_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, DunType, Count),
    Player.


add_dungeon_count_offline(RoleId, DunId, Count) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            CountType = lib_dungeon_api:get_daily_add_type(DunType, DunId),
            case get_add_count_limit_by_dungeon(DunId, DunType) of
                not_limit ->
                    mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType, Count);
                CountLimit ->
                    case mod_daily:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType) >= CountLimit of
                        false ->
                            mod_daily:plus_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, CountType, Count);
                        _ ->
                            skip
                    end
            end;
        _ ->
            skip
    end.

%% 获取副本增加次数的上限
get_add_count_limit_by_dungeon(_DunId, DunType) ->
    if
        DunType == ?DUNGEON_TYPE_COUPLE -> 1; %% 情人副本增加次数上限1次
        true ->
            not_limit
    end.

%% 获得额外的奖励领取列表
send_extra_reward_info(#player_status{id = RoleId, sid = Sid}, DunType) ->
    CounterList = get_extra_reward_counter_list(DunType),
    ResultList = mod_counter:get_count(RoleId, CounterList),
    F = fun
        ({{_Mod, ?MOD_DUNGEON_SUCCESS, _DunId}, _Num}, List) -> List;
        ({{_Mod, SubMod, DunId}, Num}, List) ->
            case Num > 0 of
                true -> RewardStatus = 1;
                false ->
                    case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId}, 1, ResultList) of
                        {_, SuccessCount} when SuccessCount > 0 -> RewardStatus = 0;
                        _ -> RewardStatus = 2
                    end
            end,
            case get_reward_type_by_sub_mod(SubMod) of
                0 -> List;
                RewardType -> [{DunId, RewardType, RewardStatus}|List]
            end
    end,
    DunList = lists:foldl(F, [], ResultList),
    {ok, BinData} = pt_610:write(61042, [DunType, DunList]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

get_extra_reward_counter_list(DunType) ->
    case get_extra_reward_counter_type(DunType, -1) of
        DunType ->
            [
                {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunType},
                {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_NORAML, DunType},
                {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_TOP, DunType}
                ];
        _ ->
            F = fun(DunId, List) ->
                #dungeon{extra_reward = ExtraReward} = data_dungeon:get(DunId),
                F2 = fun({Mod, SubMod, TmpDunId}, ExtraList) ->
                    RewardType = get_reward_type_by_sub_mod(SubMod),
                    case lists:keyfind(RewardType, 1, ExtraReward) of
                        {RewardType, RewardList} when RewardList =/= [] -> [{Mod, SubMod, TmpDunId}|ExtraList];
                        _ -> ExtraList
                    end
                end,
                ExtraDailyList =  [
                    {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_NORAML, DunId},
                    {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_TOP, DunId}
                    ],
                ExtraList = lists:foldl(F2, [], ExtraDailyList),
                [{?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId}|ExtraList]++List
            end,
            lists:foldl(F, [], data_dungeon:get_ids_by_type(DunType))
    end.

%% 获取额外奖励的永久日常
get_extra_reward_counter_type(DunType, DunId) ->
    if
        DunType == ?DUNGEON_TYPE_VIP_PER_BOSS ->
            DunId;
        DunType == ?DUNGEON_TYPE_PER_BOSS ->
            DunId;
        DunType == ?DUNGEON_TYPE_TOWER ->
            DunId;
        DunType == ?DUNGEON_TYPE_MAGIC_ORNAMENTS ->
            DunId;
        DunType == ?DUNGEON_TYPE_RUNE2 ->
            DunId;
        DunType == ?DUNGEON_TYPE_LIMIT_TOWER ->
            DunId;
        true ->
            DunType
    end.

%% 根据子模块获得额外奖励类型
get_reward_type_by_sub_mod(?MOD_DUNGEON_EXTRA_REWARD_NORAML) -> ?DUN_EXTRA_REWARD_TYPE_NORAML;
get_reward_type_by_sub_mod(?MOD_DUNGEON_EXTRA_REWARD_TOP) -> ?DUN_EXTRA_REWARD_TYPE_TOP;
get_reward_type_by_sub_mod(?MOD_DUNGEON_EXTRA_REWARD_FIRST) -> ?DUN_EXTRA_REWARD_TYPE_FIRST;
get_reward_type_by_sub_mod(_) -> 0.

%% 根据额外奖励类型获得子模块
get_sub_mod_by_reward_type(?DUN_EXTRA_REWARD_TYPE_NORAML) -> ?MOD_DUNGEON_EXTRA_REWARD_NORAML;
get_sub_mod_by_reward_type(?DUN_EXTRA_REWARD_TYPE_TOP) -> ?MOD_DUNGEON_EXTRA_REWARD_TOP;
get_sub_mod_by_reward_type(?DUN_EXTRA_REWARD_TYPE_FIRST) -> ?MOD_DUNGEON_EXTRA_REWARD_FIRST;
get_sub_mod_by_reward_type(_) -> 0.

%% 发送副本奖励数据
send_dun_reward_info(RoleId, DunType) ->
    CounterList = get_reward_counter_list(DunType),
    ResultList = mod_counter:get_count(RoleId, CounterList),
    F = fun
        ({{_Mod, ?MOD_DUNGEON_SUCCESS, _DunId}, _Num}, List) -> List;
        ({{_Mod, SubMod, DunId}, Num}, List) ->
            case Num > 0 of
                true -> RewardStatus = 1;
                false ->
                    case lists:keyfind({?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId}, 1, ResultList) of
                        {_, SuccessCount} when SuccessCount > 0 -> RewardStatus = 0;
                        _ -> RewardStatus = 2
                    end
            end,
            case get_reward_type_by_sub_mod(SubMod) of
                0 -> List;
                RewardType -> [{DunId, RewardType, RewardStatus}|List]
            end
    end,
    DunList = lists:foldl(F, [], ResultList),
    {ok, BinData} = pt_611:write(61113, [DunType, DunList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

get_reward_counter_list(DunType) ->
    case get_extra_reward_counter_type(DunType, -1) of
        DunType ->
            [
                {?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunType},
                {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_NORAML, DunType},
                {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_TOP, DunType}
                ];
        _ ->
            F = fun(DunId, List) ->
                #base_dun_reward{reward = Reward} = data_dungeon:get_dun_reward(DunId),
                F2 = fun({Mod, SubMod, TmpDunId}, ExtraList) ->
                    RewardType = get_reward_type_by_sub_mod(SubMod),
                    case lists:keyfind(RewardType, 1, Reward) of
                        {RewardType, RewardList} when RewardList =/= [] -> [{Mod, SubMod, TmpDunId}|ExtraList];
                        _ -> ExtraList
                    end
                end,
                ExtraDailyList =  [
                    {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_NORAML, DunId},
                    {?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_TOP, DunId}
                    ],
                ExtraList = lists:foldl(F2, [], ExtraDailyList),
                [{?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId}|ExtraList]++List
            end,
            lists:foldl(F, [], data_dungeon:get_dun_reward_ids(DunType))
    end.

%% 获取副本奖励
receive_dun_reward(RoleId, Figure, RewardArgsList) ->
    %% 收集奖励以及要修改计数器列表{{Module, SubModule, Type},1}
    case check_receive_dun_reward(RewardArgsList, RoleId, Figure, [], []) of
        {false, ErrorCode} ->
            TotalRewardList = [];
        {true, TotalRewardList, CounterTypeList} ->
            ErrorCode = ?SUCCESS,
            mod_counter:plus_count(RoleId, CounterTypeList),
            Produce = #produce{type = dungeon_reward, reward = TotalRewardList},
            lib_goods_api:send_reward_by_id(Produce, RoleId)
    end,
    {ok, BinData} = pt_611:write(61112, [ErrorCode, RewardArgsList, TotalRewardList]),
    lib_server_send:send_to_uid(RoleId, BinData).

check_receive_dun_reward([], _RoleId, _Figure, TotalRewardList, CounterTypeList) ->
    {true, TotalRewardList, CounterTypeList};
check_receive_dun_reward([{DunId, RewardType} | RewardArgsList], RoleId, Figure, TotalRewardList, CounterTypeList) when
        RewardType == ?DUN_EXTRA_REWARD_TYPE_NORAML;
        RewardType == ?DUN_EXTRA_REWARD_TYPE_TOP ->
    case data_dungeon:get_dun_reward(DunId) of
        [] -> {false, ?MISSING_CONFIG};
        #base_dun_reward{dun_type = DunType, reward = Reward} ->
            CounterType = get_extra_reward_counter_type(DunType, DunId),
            SubMod = get_sub_mod_by_reward_type(RewardType),
            SuccessCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, CounterType),
            RewardCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubMod, CounterType),
            LastRewardList = case lists:keyfind(RewardType, 1, Reward) of
                {RewardType, RewardList} ->
                    lib_goods_api:calc_reward(Figure, RewardList);
                _ -> []
            end,
            if
                CounterType == 0 orelse SubMod == 0 orelse LastRewardList =:= [] ->
                    {false, ?ERRCODE(err610_not_reward)};
                RewardCount > 0 ->
                    {false, ?ERRCODE(err610_had_receive_reward)};
                SuccessCount == 0 ->
                    {false, ?ERRCODE(err610_must_pass_to_receive_reward)};
                true ->
                    check_receive_dun_reward(RewardArgsList, RoleId, Figure, TotalRewardList ++ LastRewardList, [{{?MOD_DUNGEON, SubMod, CounterType}, 1} | CounterTypeList])
            end
    end;
check_receive_dun_reward(_RewardArgsList, _RoleId, _Figure, _TotalRewardList, _CounterTypeList) ->
    ?ERR("check_receive_dun_reward _RewardArgsList:~p", [_RewardArgsList]),
    {false, ?ERRCODE(err610_not_reward)}.

%% 获取额外奖励
%% 额外奖励已经抽出来到副本奖励配置了
%% 见receive_dun_reward
receive_extra_reward(#player_status{id = RoleId, sid = Sid} = Player, DunId, RewardType) ->
    case check_receive_extra_reward(Player, DunId, RewardType) of
        {false, ErrorCode} -> NewPlayer = Player, RewardList = [];
        {true, CounterType, SubMod, RewardList} ->
            ErrorCode = ?SUCCESS,
            mod_counter:increment(RoleId, ?MOD_DUNGEON, SubMod, CounterType),
            Produce = #produce{type = dungeon_extra_reward, subtype = CounterType, remark = lists:concat(["SubMod:", SubMod]), reward = RewardList},
            NewPlayer = lib_goods_api:send_reward(Player, Produce)
    end,
    {ok, BinData} = pt_610:write(61043, [ErrorCode, DunId, RewardType, RewardList]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

check_receive_extra_reward(#player_status{id = RoleId}, DunId, RewardType) when
        RewardType == ?DUN_EXTRA_REWARD_TYPE_NORAML;
        RewardType == ?DUN_EXTRA_REWARD_TYPE_TOP ->
    case data_dungeon:get(DunId) of
        [] -> {false, ?ERRCODE(err610_dungeon_not_exist)};
        #dungeon{type = DunType, extra_reward = ExtraReward} ->
            CounterType = get_extra_reward_counter_type(DunType, DunId),
            SubMod = get_sub_mod_by_reward_type(RewardType),
            case lists:keyfind(RewardType, 1, ExtraReward) of
                {RewardType, RewardList} -> ok;
                _ -> RewardList = []
            end,
            SuccessCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, CounterType),
            RewardCount = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubMod, CounterType),
            if
                CounterType == 0 orelse SubMod == 0 orelse RewardList == [] ->
                    {false, ?ERRCODE(err610_not_reward)};
                RewardCount == 1 ->
                    {false, ?ERRCODE(err610_had_receive_reward)};
                SuccessCount == 0 ->
                    {false, ?ERRCODE(err610_must_pass_to_receive_reward)};
                true ->
                    {true, CounterType, SubMod, RewardList}
            end
    end;
check_receive_extra_reward(_Player, _DunId, _RewardType) ->
    ?DEBUG("check_receive_extra_reward _DunId:~p _RewardType:~p ~n", [_DunId, _RewardType]),
    {false, ?ERRCODE(err610_not_reward)}.

%% 计算是否有首次奖励
calc_is_first_reward(RoleId, DunType, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{extra_reward = ExtraReward} ->
            case lists:keyfind(?DUN_EXTRA_REWARD_TYPE_FIRST, 1, ExtraReward) of
                {_, Reward} when Reward =/= [] ->
                    CounterType = get_extra_reward_counter_type(DunType, DunId),
                    Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_FIRST, CounterType),
                    ?IF(Count == 0, 1, 0);
                _ ->
                    0
            end;
        _ ->
            0
    end.

%% 获得额外奖励
get_extra_reward(Figure, DunId, ExtraType) ->
    case data_dungeon:get(DunId) of
        #dungeon{extra_reward = ExtraReward} ->
            case lists:keyfind(ExtraType, 1, ExtraReward) of
                {_ExtraType, Reward} -> lib_goods_api:calc_reward(Figure, Reward);
                _ -> []
            end;
        _ ->
            []
    end.

%% 发送首次奖励的处理
increment_af_send_first_reward(RoleId, DunType, DunId) ->
    CounterType = get_extra_reward_counter_type(DunType, DunId),
    mod_counter:increment_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_EXTRA_REWARD_FIRST, CounterType),
    ok.

%%
%%%%扫荡后，通知活动日历
%%handle_dungeon_sweep(DunId, #player_status{id =RoleId}, AutoNum) ->
%%    case data_dungeon:get(DunId) of
%%        #dungeon{type = DunType} ->
%%            case  DunType  of
%%                ?DUNGEON_TYPE_PER_BOSS ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_PERSON_BOSS,  AutoNum);
%%                ?DUNGEON_TYPE_VIP_PER_BOSS ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_VIP_BOSS,  AutoNum);
%%                ?DUNGEON_TYPE_RUNE2 ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_RUNE2,  AutoNum);
%%                ?DUNGEON_TYPE_WING ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_WING,  AutoNum);
%%                ?DUNGEON_TYPE_ENCHANTMENT_GUARD ->
%%                    handle_dungeon_sweep_helper(RoleId, ?DUNGEON_TYPE_ENCHANTMENT_GUARD,  0,  AutoNum);
%%                ?DUNGEON_TYPE_TOWER ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_TOWER,  AutoNum);
%%                ?DUNGEON_TYPE_EXP_SINGLE ->
%%                    handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_EXP_SINGLE,  AutoNum);
%%                _ ->
%%                    ok
%%            end;
%%        _ ->
%%            ok
%%    end.

%%扫荡后，通知活动日历
handle_dungeon_sweep_by_type(#player_status{id = RoleId}, DunType) ->
    case  DunType  of % 部分模块和通关事件触发重复，注释掉这边的
        % ?DUNGEON_TYPE_PER_BOSS ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_PERSON_BOSS,  1);
        ?DUNGEON_TYPE_VIP_PER_BOSS ->
            lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_BOSS, ?MOD_SUB_VIP_PERSONAL_BOSS, 1),
            handle_dungeon_sweep_helper(RoleId, ?MOD_BOSS,  ?MOD_SUB_VIP_PERSONAL_BOSS,  1);
        ?DUNGEON_TYPE_RUNE2 ->
            handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_RUNE2 ,  1);
        % ?DUNGEON_TYPE_WING ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_WING,  1);
        ?DUNGEON_TYPE_ENCHANTMENT_GUARD ->
            handle_dungeon_sweep_helper(RoleId, ?DUNGEON_TYPE_ENCHANTMENT_GUARD,  0,  1);
        ?DUNGEON_TYPE_TOWER ->
            handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_TOWER ,  1);
        ?DUNGEON_TYPE_EXP_SINGLE ->
            handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_EXP_SINGLE,  1);
        % ?DUNGEON_TYPE_MOUNT ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_MOUNT,  1);
        % ?DUNGEON_TYPE_PARTNER ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_PARTNER,  1);
        % ?DUNGEON_TYPE_COIN ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_COIN,  1);
        % ?DUNGEON_TYPE_MON_INVADE ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_MON_INVADE,  1);
        % ?DUNGEON_TYPE_COUPLE ->
        %     handle_dungeon_sweep_helper(RoleId, ?MOD_DUNGEON,  ?DUNGEON_TYPE_COUPLE,  1);
        _ ->
            ok
    end.

handle_dungeon_sweep_helper(RoleId,  Mod,   SubType,  Count) ->
    lib_activitycalen_api:role_success_end_activity(RoleId,  Mod, SubType, Count).

%% 在副本中增加经验,需要缓存
%% @return #player_status{}
add_exp(Player, ExpType, ExpAdd, BaseExp) ->
    #player_status{id = RoleId, scene = SceneId, dungeon = #status_dungeon{dun_type = DunType}, copy_id = DunPid} = Player,
    % ?PRINT("ExpType:~p ExpAdd:~p ~n", [ExpType, ExpAdd]),
    IsDungeonScene = lib_scene:is_dungeon_scene(SceneId),
    % 因为频率大,需要处理才通知副本进程
    if
        IsDungeonScene == false -> skip;
        ExpType =/= ?ADD_EXP_DUN andalso ExpType =/= ?ADD_EXP_MON andalso ExpType =/= ?ADD_EXP_DUN_ADD -> skip;
        DunType == ?DUNGEON_TYPE_EXP_SINGLE ->
            case is_on_dungeon(Player) of
                true -> mod_dungeon:add_exp(DunPid, RoleId, ExpAdd);
                false -> skip
            end;
        % 排除副本经验类型
        DunType == ?DUNGEON_TYPE_HIGH_EXP andalso ExpType =/= ?ADD_EXP_DUN ->
            case is_on_dungeon(Player) of
                true ->
                    GoodsExpRatio = lib_goods_buff:get_goods_buff_value(Player, ?BUFF_EXP_KILL_MON),
                    mod_dungeon:add_exp(DunPid, RoleId, ExpAdd, BaseExp, GoodsExpRatio);
                false ->
                    skip
            end;
        true ->
            skip
    end,
    ?IF(IsDungeonScene, update_dun_exp_info(Player, ExpType, ExpAdd, BaseExp), Player).

%% 更新副本经验信息
%% @return #player_status{}
update_dun_exp_info(Player, ExpType, ExpAdd, BaseExp) when ExpType == ?ADD_EXP_MON ->
    #player_status{dungeon = DunStatus} = Player,
    #status_dungeon{data_before_enter = DataM} = DunStatus,
    % 计算首次杀怪经验倍率和最新杀怪倍率
    case maps:get(ratio1, DataM, undefined) of
        Ratio1 when is_number(Ratio1) ->
            Ratio2 = ExpAdd / BaseExp;
        undefined ->
            Ratio1 = Ratio2 = ExpAdd / BaseExp
    end,
    % 计算杀怪经验
    OldMonExp = maps:get(mon_exp, DataM, 0),
    NewMonExp = OldMonExp + ExpAdd,

    NewDataM = DataM#{ratio1 => Ratio1, ratio2 => Ratio2, mon_exp => NewMonExp},
    Player#player_status{dungeon = DunStatus#status_dungeon{data_before_enter = NewDataM}};
update_dun_exp_info(Player, _, _, _) -> Player.

%% 获得经验次数比例
get_exp_count_ratio(Player, ExpType) ->
    #player_status{scene = SceneId, dungeon = #status_dungeon{dun_type = DunType, count = Count}} = Player,
    IsDungeonScene = lib_scene:is_dungeon_scene(SceneId),
    % 因为频率大,需要处理才通知副本进程
    if
        IsDungeonScene == false -> 1;
        DunType == ?DUNGEON_TYPE_EXP_SINGLE andalso ExpType == ?ADD_EXP_MON ->
            % Count不可能等于0的,除非异常
            case Count =< 0 of
                true -> ?ERR("get_exp_count_ratio error count:~p ~n", [Count]);
                false -> skip
            end,
            case is_on_dungeon(Player) of
                true -> max(1, Count);
                false -> 1
            end;
        true ->
            1
    end.

%% 发送多倍掉落奖励
send_count_drop(Player, MonArgs, Alloc) ->
    #player_status{id = RoleId, scene = SceneId, dungeon = #status_dungeon{dun_id = DunId, dun_type = DunType, count = Count}} = Player,
    IsDungeonScene = lib_scene:is_dungeon_scene(SceneId),
    % 因为频率大,需要处理才通知副本进程
    if
        IsDungeonScene == false -> skip;
        DunType == ?DUNGEON_TYPE_EQUIP andalso Count >= 2 ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_dungeon, send_count_drop_help, [DunId, DunType, MonArgs, Alloc, Count - 1]);
        true ->
            skip
    end.

send_count_drop_help(Player, DunId, DunType, MonArgs, Alloc, Count) ->
    #player_status{id = RoleId, copy_id = CopyId} = Player,
    F = fun(_Seq, SumBlReward) ->
        BlReward = lib_drop_reward:calc_drop_reward(Player, MonArgs, Alloc),
        BlReward ++ SumBlReward
    end,
    BlReward = lib_goods_api:make_reward_unique(lists:foldl(F, [], lists:seq(1, Count))),
    Remark = lists:concat(["DunId:", DunId, "DunType:", DunType, "Count:", Count]),
    BlProduce = #produce{type = dungeon_count_drop, reward = BlReward, remark = Remark},
    {ok, _, BlPlayer, BlUpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, BlProduce),
    case is_on_dungeon(Player) of
        true ->
            BlSeeRewardL = lib_goods_api:make_see_reward_list(BlReward, BlUpGoodsL),
            Key = ?IF(DunType == ?DUNGEON_TYPE_EQUIP, ?REWARD_SOURCE_DUNGEON_MULTIPLE, ?REWARD_SOURCE_DROP),
            mod_dungeon:set_reward(CopyId, RoleId, [{Key, BlSeeRewardL}], false);
        false ->
            skip
    end,
    {ok, BlPlayer}.


%% 增加物品buff
add_goods_buff(Player, _BuffType = ?BUFF_EXP_KILL_MON) ->
    #player_status{id = RoleId, scene = SceneId, dungeon = #status_dungeon{dun_type = DunType}, copy_id = DunPid} = Player,
    IsDungeonScene = lib_scene:is_dungeon_scene(SceneId),
    % 因为频率大,需要处理才通知副本进程
    if
        IsDungeonScene == false -> Player;
        DunType == ?DUNGEON_TYPE_HIGH_EXP ->
            case is_on_dungeon(Player) of
                true ->
                    GoodsExpRatio = lib_goods_buff:get_goods_buff_value(Player, ?BUFF_EXP_KILL_MON),
                    mod_dungeon:add_goods_buff(DunPid, RoleId, GoodsExpRatio);
                false ->
                    skip
            end,
            Player;
        true ->
            Player
    end;
add_goods_buff(Player, _BuffType) ->
    Player.

%% -----------------------------------------------------------------
%% @desc     功能描述 处理副本发送了奖励后的处理逻辑 主要是要通知副本进程，奖励的唯一id，用于客户端的显示
%% @param    参数    IsCls::integer()  0 单服  1 跨服
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_send_reward(#player_status{id = RoleId, pid = Pid} = PS, _Reward, IsCls, CopyPid, DungeonTransportMsg, DungeonRole) ->
    #dungeon_role{reward_map = RewardMap, is_push_settle_in_ps = PushSettleInPs}  = DungeonRole,
    #dungeon_transport_msg{produce = Produce, base_reward = BaseReward,
        first_reward = FirstReward, multiple_reward = MultipleReward, weekly_card_reward = WeeklyCardReward} = DungeonTransportMsg,
    AllReward =  BaseReward ++ FirstReward ++ MultipleReward ++ WeeklyCardReward,
    IsOnline = ?IF(Pid == undefined, false, is_process_alive(Pid)),
    if
        AllReward == [] ->
            LastPlayer  = PS,
            UpGoodsList = [];
        IsOnline == true ->
            case lib_goods_api:send_reward_with_mail_return_goods(PS, Produce) of
                {ok, bag, _Player, _UpGoodsList} ->
                    LastPlayer  = _Player,
                    UpGoodsList = _UpGoodsList;
                {ok, mail, _Player, []} ->
                    LastPlayer  = _Player,
                    UpGoodsList = []
            end;
        true ->
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            LastPlayer       = PS,
            UpGoodsList      = []
    end,
    SeeRewardList     = lib_goods_api:make_see_reward_list(BaseReward ++ FirstReward, UpGoodsList),  %%唯一id的奖励
    NewUpGoodsList    = take_see_reward_list_from_up_goods_list(SeeRewardList, UpGoodsList),
    MultipleSeeReward = lib_goods_api:make_see_reward_list(MultipleReward, NewUpGoodsList),
    NewUpGoodsListA    = take_see_reward_list_from_up_goods_list(MultipleSeeReward, NewUpGoodsList),
    WeeklyCardSeeReward = lib_goods_api:make_see_reward_list(WeeklyCardReward, NewUpGoodsListA),
    State = #dungeon_state{
        dun_id              = DungeonTransportMsg#dungeon_transport_msg.dun_id,
        dun_type            = DungeonTransportMsg#dungeon_transport_msg.dun_type,
        now_scene_id        = DungeonTransportMsg#dungeon_transport_msg.now_scene_id,
        result_type         = DungeonTransportMsg#dungeon_transport_msg.result_type,
        result_subtype      = DungeonTransportMsg#dungeon_transport_msg.result_subtype,
        role_list           = DungeonTransportMsg#dungeon_transport_msg.role_list,
        start_time          = DungeonTransportMsg#dungeon_transport_msg.start_time,
        end_time            = DungeonTransportMsg#dungeon_transport_msg.end_time,
        result_time         = DungeonTransportMsg#dungeon_transport_msg.result_time,
        mon_score           = DungeonTransportMsg#dungeon_transport_msg.mon_score,
        level_result_list   = DungeonTransportMsg#dungeon_transport_msg.level_result_list,
	    finish_wave_list    = DungeonTransportMsg#dungeon_transport_msg.finish_wave_list
    },
    NewRewardMap = maps:put(?REWARD_SOURCE_DUNGEON, SeeRewardList, RewardMap),
    SourRewardListA = [{?REWARD_SOURCE_DUNGEON, SeeRewardList}],
    SourRewardListB = ?IF(length(MultipleSeeReward) =:= 0, SourRewardListA, [{?REWARD_SOURCE_DUNGEON_MULTIPLE, MultipleSeeReward} | SourRewardListA]),
    SourRewardList = ?IF(length(WeeklyCardSeeReward) =:= 0, SourRewardListB, [{?REWARD_SOURCE_WEEKLY_CARD, WeeklyCardSeeReward} | SourRewardListB]),
    NewRewardMap1 = NewRewardMap#{?REWARD_SOURCE_DUNGEON_MULTIPLE => MultipleSeeReward, ?REWARD_SOURCE_WEEKLY_CARD => WeeklyCardSeeReward},
    if
        PushSettleInPs == ?DUNGEON_FORCE_PUSH_SETTLE_YES andalso IsOnline == true ->  %% 玩家直接退出了
            lib_dungeon_mod:push_settlement(State, DungeonRole#dungeon_role{is_reward = ?DUN_IS_REWARD_YES, reward_map = NewRewardMap1});
        true ->
            ok
    end,
    case IsCls of
        true ->
            % mod_clusters_node:apply_cast(mod_dungeon, set_reward, [CopyPid, RoleId, SourRewardList,
            %    ?IF(PushSettleInPs == ?DUNGEON_FORCE_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_NO)]);
            mod_dungeon:set_reward(CopyPid, RoleId, SourRewardList,
                ?IF(PushSettleInPs == ?DUNGEON_FORCE_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_NO));
        false ->
            mod_dungeon:set_reward(CopyPid, RoleId, SourRewardList,
                ?IF(PushSettleInPs == ?DUNGEON_FORCE_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_YES, ?DUNGEON_PUSH_SETTLE_NO))
    end,
    LastPlayer.

%%获取来源map的奖励 基础奖励
get_source_list(RewardMap)->
    get_source_list(RewardMap, ?REWARD_SOURCE_LIST, []).
get_source_list(_RewardMap, [], AccList) -> AccList;
get_source_list(RewardMap, [H | T], AccList) ->
    get_source_list(RewardMap, T, maps:get(H, RewardMap, []) ++ AccList).


get_source_list_all(RewardMap) ->
    get_source_list(RewardMap, ?REWARD_SOURCE_LIST_ALL, []).


get_reward_by_source(Reward,  Source) ->
    case lists:keyfind(Source, 1, Reward) of
        {_, SourceReward} ->
            SourceReward;
        _ ->
            []
    end.

take_see_reward_list_from_up_goods_list([], UpGoodsList) ->
    UpGoodsList;
take_see_reward_list_from_up_goods_list([ {_GoodsType, GoodsId, _, _} | T], UpGoodsList) ->
    NewUpGoodsList = lists:keydelete(GoodsId, #goods.goods_id, UpGoodsList),
    take_see_reward_list_from_up_goods_list(T, NewUpGoodsList).

%% 修复副本记录:次数增加了，但是没有副本记录
repair_dungeon_record(#player_status{id = RoleId} = Player) ->
    % cast 到 日常进程
    mod_counter:apply_cast(RoleId, ?MODULE, repair_dungeon_records_on_counter, [RoleId]),
    Player.

repair_dungeon_records_on_counter([RoleId]) ->
    F = fun(DunType) ->
        DunIds = data_dungeon:get_ids_by_type(DunType),
        F2 = fun(DunId) ->
            Count = lib_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
            Count > 0
        end,
        List = lists:filter(F2, DunIds),
        MaxDunId = ?IF(List==[], 0, lists:max(List)),
        {DunType, MaxDunId}
    end,
    KvList = lists:map(F, [?DUNGEON_TYPE_RUNE2, ?DUNGEON_TYPE_TOWER]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, repair_dungeon_records_on_server, [KvList]),
    ok.

repair_dungeon_records_on_server(#player_status{id = RoleId, dungeon_record = Rec} = Player, KvList) ->
    F = fun(DunType, PlayerAfType) ->
        DunIds = data_dungeon:get_ids_by_type(DunType),
        case lists:keyfind(DunType, 1, KvList) of
            {DunType, MaxDunId} -> ok;
            _ -> MaxDunId = 0
        end,
        F2 = fun(DunId, {PlayerAfId, Bool}) ->
            case DunId =< MaxDunId andalso maps:is_key(DunId, Rec) == false of
                true ->
                    % ?MYLOG("hjh", "RoleId:~p DunId:~p ~n", [Player#player_status.id, DunId]),
                    if
                        DunType == ?DUNGEON_TYPE_TOWER ->
                            ResultData = #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, pass_time = 5},
                            {lib_dungeon_tower:dunex_update_dungeon_record(PlayerAfId, ResultData), true};
                        DunType == ?DUNGEON_TYPE_RUNE2 ->
                            ResultData = #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, pass_time = 5},
                            {lib_dungeon_rune:dunex_update_dungeon_record(PlayerAfId, ResultData), true};
                        true ->
                            {PlayerAfId, Bool}
                    end;
                false ->
                    {PlayerAfId, Bool}
            end
        end,
        {NewPlayerAfType, Bool} = lists:foldl(F2, {PlayerAfType, false}, DunIds),
        Level = lib_dungeon_api:get_dungeon_level(NewPlayerAfType, DunType),
        ?IF(Bool, lib_task_api:fin_dun_level(RoleId, DunType, Level), skip),
        NewPlayerAfType
    end,
    lists:foldl(F, Player, [?DUNGEON_TYPE_RUNE2, ?DUNGEON_TYPE_TOWER]).

%% 发送副本冷却时间
send_cd_info(Player, DunId) ->
    NextTime = get_cd_info(Player, DunId),
    {ok, BinData} = pt_610:write(61045, [DunId, NextTime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).

get_cd_info(#player_status{dungeon_record = RecMap}, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{condition = Condition} ->
            case lists:keyfind(cd, 1, Condition) of
                {cd, Cd} -> ok;
                _ -> Cd = 0
            end,
            KvList = maps:get(DunId, RecMap, []),
            case lists:keyfind(?DUNGEON_REC_UPDATE_TIME, 1, KvList) of
                {_, LastTime} -> ok;
                _ -> LastTime = 0
            end,
            LastTime + Cd;
        _ ->
            0
    end.

%% 抢夺
rob_mon_bl(#player_status{id = RoleId, scene = Scene, scene_pool_id = ScenePoolId, dungeon = #status_dungeon{dun_type = DunType}} = Player) ->
    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    if
        IsOnDungeon == false -> skip;
        DunType == ?DUNGEON_TYPE_BOSS_GUIDE orelse DunType == ?DUNGEON_TYPE_BOSS_GUIDE2 ->
            mod_scene_agent:apply_cast(Scene, ScenePoolId, ?MODULE, rob_mon_bl_on_scene, [RoleId]);
        true ->
            skip
    end.

rob_mon_bl_on_scene(RoleId) ->
    User = lib_scene_agent:get_user(RoleId),
    case is_record(User, ets_scene_user) of
        true ->
            #ets_scene_user{scene = SceneId, copy_id = CopyId, x = X, y = Y, battle_attr=BA, node=Node} = User,
            #battle_attr{hp=Hp, hp_lim=HpLim} = BA,
            NewHp = urand:rand(umath:ceil(Hp*0.7), umath:ceil(Hp*0.8)),
            {ok, BinData} = pt_120:write(12009, [RoleId, NewHp, HpLim]),
            case data_scene:get(SceneId) of
                #ets_scene{broadcast = Broadcast} -> ok;
                _ -> Broadcast = 0
            end,
            lib_battle:send_to_scene(CopyId, X, Y, Broadcast, BinData),
            lib_battle:rpc_cast_to_node(Node, lib_player, update_player_info, [RoleId, [{hp, NewHp}]]),
            lib_scene_agent:put_user(User#ets_scene_user{battle_attr=BA#battle_attr{hp=NewHp}}),
            {ok, BinData2} = pt_610:write(61091, [?SUCCESS]),
            lib_server_send:send_to_uid(Node, RoleId, BinData2);
        false ->
            skip
    end.

%% 秘籍清理副本次数
gm_clear_dun_count(#player_status{id = RoleId}, Type) ->
    [
    begin
        case mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId) > 0 of
            true -> mod_counter:set_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, 0);
            false -> skip
        end
    end||DunId<-data_dungeon:get_ids_by_type(Type)].

invite_dun(Player, Type, DunId, OtherId) ->
    #player_status{id = RoleId, figure = Figure, dungeon = StatusDungeon} = Player,
    DataBeforeEnter = StatusDungeon#status_dungeon.data_before_enter,
    case Type of
        1 ->
            Dun = data_dungeon:get(DunId),
            CheckResult = check_invite_dun(Player, Dun, OtherId),
            case CheckResult of
                true ->
                    ?PRINT("invite_dun succ ~n", []),
                    case lib_role:get_role_show(OtherId) of
                        #ets_role_show{figure = OtherFigure} ->
                            Code = 1,
                            report_invite_result_msg(1, RoleId, Figure, OtherId, OtherFigure, DunId),
                            ExpireTime =  utime:unixtime()+15,
                            NewDataBeforeEnter = DataBeforeEnter#{invite_dun => {DunId, OtherId, ExpireTime}},
                            NewStatusDungeon = StatusDungeon#status_dungeon{data_before_enter = NewDataBeforeEnter},
                            lib_player:apply_cast(OtherId, ?APPLY_CAST_SAVE, ?MODULE, set_other_be_invited_dun, [DunId, RoleId, ExpireTime]),
                            NewPlayer = lib_player:soft_action_lock(Player#player_status{dungeon = NewStatusDungeon}, ?ERRCODE(err610_invitting_other_to_dun), 15);
                        _ ->
                            Code = ?FAIL,
                            NewPlayer = Player
                    end,
                    CodeMsg = util:make_error_code_msg(Code),
                    ?PRINT("invite_dun Code ~p ~n", [Code]),
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61046, [CodeMsg]),
                    {ok, NewPlayer};
                {false, Code} ->
                    NewPlayer = Player,
                    CodeMsg = util:make_error_code_msg(Code),
                    ?PRINT("invite_dun Code ~p ~n", [Code]),
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61046, [CodeMsg]),
                    {ok, NewPlayer};
                {true, other_no_online} ->
                    %% 当该副本类型允许邀请镜像参战时，直接进行副本不在需要同意
                    lib_dungeon_couple:do_dup_mirror_to_battle(Player, DunId, OtherId)
            end;
        _ ->
            case maps:get(invite_dun, DataBeforeEnter, undefined) of
                {DunId, OtherId, _} ->
                    NewDataBeforeEnter = DataBeforeEnter#{invite_dun => undefined},
                    NewStatusDungeon = StatusDungeon#status_dungeon{data_before_enter = NewDataBeforeEnter},
                    NewPlayer = lib_player:break_action_lock(Player#player_status{dungeon = NewStatusDungeon}, ?ERRCODE(err610_invitting_other_to_dun)),
                    report_invite_result_msg(2, RoleId, #figure{}, OtherId, #figure{}, DunId),
                    {ok, NewPlayer};
                _ ->
                    {ok, Player}
            end
    end.

%% 设置被邀请者状态
set_other_be_invited_dun(PS, DunId, RoleId, ExpireTime) ->
    #player_status{dungeon = StatusDungeon} = PS,
    DataBeforeEnter = StatusDungeon#status_dungeon.data_before_enter,
    NewDataBeforeEnter = maps:put(be_invited_dun, {DunId, RoleId, ExpireTime}, DataBeforeEnter),
    NewPS = PS#player_status{dungeon = StatusDungeon#status_dungeon{data_before_enter = NewDataBeforeEnter}},
    NewPS.

%% 被邀请者掉线通知邀请方
offline_answer_invite_dun(PS) ->
    #player_status{dungeon = StatusDungeon} = PS,
    DataBeforeEnter = StatusDungeon#status_dungeon.data_before_enter,
    case maps:get(be_invited_dun, DataBeforeEnter, undefined) of
        {_DunId, OtherId, _ExpireTime} ->
            NewPS = PS#player_status{dungeon = StatusDungeon#status_dungeon{data_before_enter = maps:put(be_invited_dun, undefined, DataBeforeEnter)}},
            %% 被邀请者掉线通知邀请方
            {ok, Bin} = pt_610:write(61047, [?ERRCODE(err240_other_offline), 2]),
            lib_server_send:send_to_uid(OtherId, Bin),
            NewPS;
        _ -> PS
    end.

%% 清理被邀请者状态
empty_other_be_invited_dun(PS) ->
    #player_status{dungeon = StatusDungeon} = PS,
    DataBeforeEnter = StatusDungeon#status_dungeon.data_before_enter,
    PS#player_status{dungeon = StatusDungeon#status_dungeon{data_before_enter = maps:put(be_invited_dun, undefined, DataBeforeEnter)}}.

answer_invite_dun(Player, DunId, InviterId, AnswerType) ->
    #player_status{id = OtherId} = Player,
    Dun = data_dungeon:get(DunId),
    %?PRINT("answer_invite_dun ~p ~n", [{OtherId, InviterId, AnswerType}]),
    case lib_dungeon_check:enter_dungeon(Player, Dun, ?DUN_CREATE) of
        true ->
            DungeonRole = trans_to_dungeon_role(Player, Dun),
            case lib_player:apply_call(InviterId, ?APPLY_CALL_SAVE, ?MODULE, check_answer_invite_dun, [OtherId, Dun, AnswerType]) of
                {false, Code} ->
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61047, [Code, AnswerType]);
                ok -> %% 拒绝进入副本
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61047, [1, AnswerType]),
                    report_invite_result_msg(3, InviterId, #figure{}, OtherId, #figure{}, DunId);
                {ok, DungeonRoleInviter} ->
                    AtartArgs = get_start_dun_args(Player, Dun),
                    mod_dungeon:start(0, self(), DunId, [DungeonRoleInviter, DungeonRole], AtartArgs),
                    NewPlayer = lib_player:soft_action_lock(Player, ?ERRCODE(err610_had_on_dungeon)),
                    {ok, NewPlayer};
                _Err ->
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61047, [?FAIL, AnswerType]),
                    ok
            end;
        {false, Code} ->
            {ErrorCodeInt, _ErrorCodeArgs} = util:parse_error_code(Code),
            lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61047, [ErrorCodeInt, AnswerType]),
            report_invite_result_msg(4, InviterId, #figure{}, OtherId, #figure{}, DunId)
    end.

check_answer_invite_dun(Player, OtherId, Dun, AnswerType) ->
    #player_status{id = _RoleId, dungeon = StatusDungeon} = Player,
    DataBeforeEnter = StatusDungeon#status_dungeon.data_before_enter,
    #dungeon{id = DunId} = Dun,
    case maps:get(invite_dun, DataBeforeEnter, undefined) of
        {DunId, OtherId, ExpireTime} ->
            case utime:unixtime() =< ExpireTime of
                true ->
                    Code = 1;
                _ -> Code = ?ERRCODE(err610_invite_timeout)
            end;
        _ -> Code = ?ERRCODE(err610_not_invite_dun)
    end,
    case Code == 1 of
        true ->
            Player1 = Player#player_status{dungeon = StatusDungeon#status_dungeon{data_before_enter = maps:put(invite_dun, undefined, DataBeforeEnter)}},
            lib_player:apply_cast(OtherId, ?APPLY_CAST_SAVE, ?MODULE, empty_other_be_invited_dun, []),
            NewPlayer = lib_player:break_action_lock(Player1, ?ERRCODE(err610_invitting_other_to_dun)),
            case AnswerType of
                1 ->
                    DungeonRole = trans_to_dungeon_role(Player1, Dun),
                    LastPlayer = lib_player:soft_action_lock(NewPlayer, ?ERRCODE(err610_had_on_dungeon)),
                    {{ok, DungeonRole}, LastPlayer};
                _ ->
                    {ok, NewPlayer}
            end;
        _ ->
            {{false, Code}, Player}
    end.

check_invite_dun(Player, Dun, OtherId) ->
    case lib_dungeon_check:enter_dungeon(Player, Dun, ?DUN_CREATE) of
        true ->
            case check_invite_other(Player, Dun, OtherId) of
                true -> true;
                Res -> Res
            end;
        Res -> Res
    end.

report_invite_result_msg(Code, RoleId, Figure, OtherId, OtherFigure, DunId) ->
    {ok, Bin} = pt_610:write(61048, [Code, [{1, RoleId, Figure}, {2, OtherId, OtherFigure}], DunId]),
    lib_server_send:send_to_uid(OtherId, Bin),
    lib_server_send:send_to_uid(RoleId, Bin).

answer_dun_question(Player, Answer) ->
    case is_on_dungeon(Player) of
        true ->
            mod_dungeon:answer_dun_question(Player#player_status.copy_id, Player#player_status.id, Answer);
        _ -> ok
    end.

if_answer_valid(DunId, QuestionId, Answer) ->
    case data_dun_answer:get_answers(DunId, QuestionId) of
        [] -> false;
        List ->
            NewList = [util:make_sure_binary(Answer1) || Answer1 <- List],
            lists:member(util:make_sure_binary(Answer), NewList)
    end.

get_dragon_record_time(DunId, Wave, Record) ->
    DragonRecord = maps:get(DunId, Record, []),
    case lists:keyfind(Wave, 1, DragonRecord) of
        {Wave, Time, _Status} ->
            Time;
        _ ->
            0
    end.

get_dragon_record_list(DunId, Record) ->
    DragonRecord = maps:get(DunId, Record, []),
    [{Wave, Status} ||{Wave, _Time, Status} <- DragonRecord].

%% 获取特定副本的历史波数
get_dun_history_wave(DunId, WaveMap) ->
    case data_dungeon:get(DunId) of
        #dungeon{type=Type} when
                Type == ?DUNGEON_TYPE_DRAGON;
                Type == ?DUNGEON_TYPE_HIGH_EXP ->
            case maps:get(DunId, WaveMap, false) of
                #role_dungeon_wave{history_wave = HistoryWave} -> HistoryWave;
                _ -> 0
            end;
        _ -> 0
    end.

%% 获取特定副本的波数最佳通过时间列表
get_dun_pass_time_list(DunId, WaveMap) ->
    case data_dungeon:get(DunId) of
        #dungeon{type=Type} when Type == ?DUNGEON_TYPE_DRAGON ->
            case maps:get(DunId, WaveMap, false) of
                #role_dungeon_wave{pass_time_list = PassTimeList} -> PassTimeList;
                _ -> []
            end;
        _ -> []
    end.

%% 加载副本信息
reload_status_dun(RoleId, StatusDun) ->
    % 波数
    WaveList = db_role_dungeon_wave_select(RoleId),
    F2 = fun(T, TmpWaveMap) ->
        Wave = make_record(role_dungeon_wave, T),
        #role_dungeon_wave{dun_id = DunId} = Wave,
        maps:put(DunId, Wave, TmpWaveMap)
    end,
    WaveMap = lists:foldl(F2, #{}, WaveList),
    SettingMap = lib_dungeon_setting:get_setting_map_from_db(RoleId),
    StatusDun#status_dungeon{wave_map = WaveMap, setting_map = SettingMap}.

%% 波数
db_role_dungeon_wave_replace(RoleId, DungeonWave) ->
    #role_dungeon_wave{dun_id = DunId, cur_wave = CurWave, history_wave = HistoryWave, get_list = GetList, pass_time_list = PassTimeList} = DungeonWave,
    Sql = io_lib:format(?sql_role_dungeon_wave_replace, [RoleId, DunId, CurWave, HistoryWave, util:term_to_bitstring(GetList), util:term_to_bitstring(PassTimeList)]),
    db:execute(Sql).

%% 波数
db_role_dungeon_wave_replace(RoleId, DunId, CurWave, HistoryWave, GetList, PassTimeList) ->
    Sql = io_lib:format(?sql_role_dungeon_wave_replace, [RoleId, DunId, CurWave, HistoryWave, util:term_to_bitstring(GetList), util:term_to_bitstring(PassTimeList)]),
    db:execute(Sql).

db_role_dungeon_wave_select(RoleId) ->
    Sql = io_lib:format(?sql_role_dungeon_wave_select, [RoleId]),
    db:get_all(Sql).

db_role_dungeon_wave_select_by_dun_id(RoleId, DunId) ->
    Sql = io_lib:format(?sql_role_dungeon_wave_select_by_dunid, [RoleId, DunId]),
    db:get_all(Sql).

db_role_dungeon_wave_clear() ->
    Sql = io_lib:format(?sql_role_dungeon_wave_clear, []),
    db:execute(Sql).

db_role_dungeon_wave_clear_by_role_id(RoleId) ->
    Sql = io_lib:format(?sql_role_dungeon_wave_clear_by_role_id, [RoleId]),
    db:execute(Sql).

db_role_dungeon_wave_delete_by_role_id(RoleId) ->
    Sql = io_lib:format(?sql_role_dungeon_wave_delete_by_role_id, [RoleId]),
    db:execute(Sql).

make_record(role_dungeon_wave, [DunId, CurWave, HistoryWave, GetList, PassTimeList]) ->
    case is_list(GetList) of
        true -> NewGetList = GetList;
        false ->
            case util:bitstring_to_term(GetList) of
                undefined -> NewGetList = [];
                NewGetList -> ok
            end
    end,
    case is_list(PassTimeList) of
        true -> NewPassTimeList = PassTimeList;
        false ->
            case util:bitstring_to_term(PassTimeList) of
                undefined -> NewPassTimeList = [];
                NewPassTimeList -> ok
            end
    end,
    #role_dungeon_wave{dun_id = DunId, cur_wave = CurWave, history_wave = HistoryWave, get_list = NewGetList, pass_time_list = NewPassTimeList}.

%% 发送阶段奖励
send_stage_reward(Player, DunId, _GainWaveList, StageReward) ->
    Produce = #produce{
        type = dungeon_wave_stage, subtype = DunId,
        reward = StageReward
    },
    {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(Player, Produce),
    {ok, NewPlayer}.


replace_dungeon_wave(#player_status{id = _RoleId} = Player, #dungeon_end_info{dun_type = DunType} = DunegonEndInfo) when
        DunType == ?DUNGEON_TYPE_DRAGON ->
    #status_dungeon{wave_map = WaveMap} = Dungeon = Player#player_status.dungeon,
    #dungeon_end_info{
        dun_id = DunId, finish_wave = Wave, history_wave = _OldHistoryWave, pass_time_list= PassTimeList
    } = DunegonEndInfo,
%%    ?MYLOG("cym", "DunegonEndInfo ~p~n", [DunegonEndInfo]),
    case maps:get(DunId, WaveMap, []) of
        #role_dungeon_wave{
            cur_wave = _OldCurWave, history_wave = OldHistoryWave
        } = DungeonWave ->
            HistoryWave = max(OldHistoryWave, Wave),
            NewDungeonWave = DungeonWave#role_dungeon_wave{
                cur_wave = Wave, history_wave = HistoryWave, pass_time_list = PassTimeList};
        [] ->
            HistoryWave = Wave,
            NewDungeonWave = #role_dungeon_wave{
                dun_id = DunId, cur_wave = Wave, history_wave = HistoryWave, pass_time_list = PassTimeList}
    end,
    NewWaveMap = maps:put(DunId, NewDungeonWave, WaveMap),
    NewDungeon = Dungeon#status_dungeon{wave_map = NewWaveMap},
    LastPlayer = Player#player_status{dungeon = NewDungeon},
%%    lib_dun_dragon:send_stage_reward_info(LastPlayer, DunId),
    LastPlayer;
replace_dungeon_wave(#player_status{id = _RoleId} = Player, #dungeon_end_info{dun_type = DunType} = DunegonEndInfo) when
        DunType == ?DUNGEON_TYPE_HIGH_EXP ->
    #status_dungeon{wave_map = WaveMap} = Dungeon = Player#player_status.dungeon,
    #dungeon_end_info{
        result_type = ResultType,
        dun_id = DunId, battle_wave = BattleWave, history_wave = _OldHistoryWave, pass_time_list= PassTimeList
    } = DunegonEndInfo,
    if
        ResultType == ?DUN_RESULT_TYPE_SUCCESS -> Wave = BattleWave;
        true -> Wave = max(0, BattleWave-1)
    end,
%%    ?MYLOG("cym", "DunegonEndInfo ~p~n", [DunegonEndInfo]),
    case maps:get(DunId, WaveMap, []) of
        #role_dungeon_wave{
            cur_wave = _OldCurWave, history_wave = OldHistoryWave
        } = DungeonWave ->
            HistoryWave = max(OldHistoryWave, Wave),
            NewDungeonWave = DungeonWave#role_dungeon_wave{
                cur_wave = Wave, history_wave = HistoryWave, pass_time_list = PassTimeList};
        [] ->
            HistoryWave = Wave,
            NewDungeonWave = #role_dungeon_wave{
                dun_id = DunId, cur_wave = Wave, history_wave = HistoryWave, pass_time_list = PassTimeList}
    end,
    NewWaveMap = maps:put(DunId, NewDungeonWave, WaveMap),
    NewDungeon = Dungeon#status_dungeon{wave_map = NewWaveMap},
    LastPlayer = Player#player_status{dungeon = NewDungeon},
%%    lib_dun_dragon:send_stage_reward_info(LastPlayer, DunId),
    LastPlayer;
replace_dungeon_wave(#player_status{} = Player, _DunegonEndInfo) ->
    Player.

replace_dungeon_wave_db(RoleId, #dungeon_end_info{dun_type = DunType} = DunegonEndInfo) when
        is_integer(RoleId) andalso
        (
            DunType == ?DUNGEON_TYPE_DRAGON
            )->
    #dungeon_end_info{
        dun_id = DunId, finish_wave = Wave, history_wave = OldHistoryWave, pass_time_list= PassTimeList
    } = DunegonEndInfo,
    HistoryWave = max(OldHistoryWave, Wave),
    DungeonWave = case db_role_dungeon_wave_select_by_dun_id(RoleId, DunId) of
        [T] -> make_record(role_dungeon_wave, T);
        _ -> #role_dungeon_wave{}
    end,
    GetList = DungeonWave#role_dungeon_wave.get_list,
    db_role_dungeon_wave_replace(RoleId, DunId, Wave, HistoryWave, GetList, PassTimeList);
replace_dungeon_wave_db(RoleId, #dungeon_end_info{dun_type = DunType} = DunegonEndInfo) when
        is_integer(RoleId) andalso
        (
            DunType == ?DUNGEON_TYPE_HIGH_EXP
            )->
    #dungeon_end_info{
        result_type = ResultType,
        dun_id = DunId, battle_wave = BattleWave, history_wave = OldHistoryWave, pass_time_list= PassTimeList
    } = DunegonEndInfo,
    if
        ResultType == ?DUN_RESULT_TYPE_SUCCESS -> Wave = BattleWave;
        true -> Wave = max(0, BattleWave-1)
    end,
    HistoryWave = max(OldHistoryWave, Wave),
    DungeonWave = case db_role_dungeon_wave_select_by_dun_id(RoleId, DunId) of
        [T] -> make_record(role_dungeon_wave, T);
        _ -> #role_dungeon_wave{}
    end,
    GetList = DungeonWave#role_dungeon_wave.get_list,
    db_role_dungeon_wave_replace(RoleId, DunId, Wave, HistoryWave, GetList, PassTimeList);
replace_dungeon_wave_db(_RoleId, _DunegonEndInfo) -> skip.


%% 条件通过返回true ,不满足返回 false
get_vip_lv_auto_buy_limit(Player, Dun) ->
    #player_status{vip = Vip} = Player,
    #role_vip{vip_lv = Lv} = Vip,
    case Dun of
        #dungeon{condition = Condition} ->
%%            ?MYLOG("dun", "Condition ~p~n", [Condition]),
            case lists:keyfind(vip_lv_auto_buy, 1, Condition) of
                {_, LimitLv} ->
                    Lv >= LimitLv;
                _ ->
                    true
            end;
        _ ->
            true
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述  是否扫荡的副本类型与所在的副本类型相同
%% @param    参数      SweepDunId::integer 扫荡的副本id
%% @return   返回值    true | false
%% @history  修改历史
%% -----------------------------------------------------------------
is_on_same_dun_type(SweepDunId, Player) ->
    #player_status{copy_id = CopyId, dungeon = StatusDun} = Player,
    #status_dungeon{dun_id = MyDunId} = StatusDun,
    case misc:is_process_alive(CopyId) andalso MyDunId > 0 of
        true ->
            case data_dungeon:get(MyDunId) of
                #dungeon{type = MyType} ->
                    ok;
                _ ->
                    MyType = 0
            end,
            case data_dungeon:get(SweepDunId) of
                #dungeon{type = SweepType} ->
                    ok;
                _ ->
                    SweepType = 0
            end,
            if
                SweepType == MyType ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述  是否扫荡的副本类型与所在的副本类型相同
%% @param    参数      SweepType::integer 扫荡的副本类型
%% @return   返回值    true | false
%% @history  修改历史
%% -----------------------------------------------------------------
is_on_same_dun_type2(SweepType, Player) ->
    #player_status{copy_id = CopyId, dungeon = StatusDun} = Player,
    #status_dungeon{dun_id = MyDunId} = StatusDun,
    case misc:is_process_alive(CopyId) andalso MyDunId > 0 of
        true ->
            case data_dungeon:get(MyDunId) of
                #dungeon{type = MyType} ->
                    ok;
                _ ->
                    MyType = 0
            end,
            if
                SweepType == MyType ->
                    true;
                true ->
                    false
            end;
        _ ->
            false
    end.


%%gm 强制退出场景 特殊情况
force_quit_scene(?MOD_DUNGEON, DunType) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_dungeon, force_quit_scene_in_ps, [DunType]) || RoleId <- IdList];

force_quit_scene(_, _) ->
    skip.

force_quit_scene_in_ps(Player, DunType) ->
    #player_status{dungeon = StatusDun, scene = SceneId} = Player,
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            case StatusDun of
                #status_dungeon{dun_type = DunType, dun_id = _DunId} ->
                    case lib_scene:is_dungeon_scene(SceneId) of
                        true ->
                            NewPlayer = lib_scene:change_default_scene(Player, [{change_scene_hp_lim, 0},{action_free, ?ERRCODE(err610_had_on_dungeon)}]);
                        _ ->
                            NewPlayer = Player
                    end;
                _ ->
                    NewPlayer = Player
            end,
            {ok, NewPlayer};
        false ->
            {ok, Player}
    end.

%% 秘籍 补回玩家的副本进入次数
%% 多人副本在跨服中心执行，单人副本在游戏服执行
%% @param RoleId    玩家id，如为0则对所有玩家适用
%% @param DunType   副本类型
%% @param STime     最早进入副本的时间戳
%% @param ETime     最晚进入副本的时间戳，如为0则忽略时间
%% @param Count     补回次数,如RoleId=/=0，Count=1
gm_increase_dungeon_enter_count(RoleId, DunType, STime, ETime, Count) ->
    List = gm_get_increase_dungeon_enter_count_list(RoleId, DunType, STime, ETime),
    F = fun([Id], Map) ->
        case maps:find(Id, Map) of
            % 防止对同一玩家的数据过快写入导致覆盖
            true ->
                NewMap = Map,
                timer:sleep(200);
            _ ->
                NewMap = maps:put(Id, true, Map)
        end,
        case is_dungeon_type_single(DunType) of
            % 单人副本
            true ->
                mod_daily:plus_count_offline(Id, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, DunType, Count),
                lib_dungeon:gm_refresh_dungeon_enter_count_local(Id, DunType);
            % 多人副本
            false ->
                <<SerId:16, _AutoId:32>> = <<Id:48>>,
                mod_clusters_center:apply_cast(SerId, mod_daily, plus_count_offline, [Id, ?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, DunType, Count]),
                mod_clusters_center:apply_cast(SerId, lib_dungeon, gm_refresh_dungeon_enter_count_local, [Id, DunType])
        end,
        NewMap
    end,
    lists:foldl(F, #{}, List).

%% 获取要操作的RoleId列表
gm_get_increase_dungeon_enter_count_list(RoleId, _DunType, _STime, 0) ->
    [[RoleId]];
gm_get_increase_dungeon_enter_count_list(RoleId, DunType, STime, ETime) ->
    Log = ?IF(is_dungeon_type_single(DunType), log_single_dungeon, log_multi_dungeon),
    Type = ?DUN_LOG_TYPE_ENTER,
    case RoleId of
        % 搜索全服符合条件的玩家
        0 ->
            Sql = io_lib:format("select role_id from ~p where dun_type=~p and time > ~p and time < ~p", [Log, Type, STime, ETime]);
        % 搜索目标玩家符合条件的记录
        _ ->
            Sql = io_lib:format("select role_id from ~p where dun_type=~p and time > ~p and time < ~p and role_id=~p", [Log, Type, STime, ETime, RoleId])
    end,
    List = db:get_all(Sql),
    List.

%% 在线刷新玩家的副本状态信息
gm_refresh_dungeon_enter_count_local(RoleId, DunType) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_dungeon, gm_refresh_dungeon_enter_count, [DunType]).

gm_refresh_dungeon_enter_count(PS, DunType) ->
    pp_dungeon:handle(61020, PS, [DunType]).

get_data(Player) ->
    #player_status{ dungeon_record = Rec, id = PlayerId } = Player,
    ?INFO("Rec:~p//Coyunt:~p", [Rec, mod_counter:get_count(PlayerId, ?MOD_DUNGEON, 4)]).


repair_old_version_player_data(Player) ->
    NeedRepairTime = 1653408000,
    #player_status{reg_time = RegTime, id = PlayerId} = Player,
    IsOldPlayer = RegTime < NeedRepairTime,    %% 修复时间之前的都是老玩家，需要修复数据
    OpenTime = util:get_open_time(),
    IsOldServer = OpenTime < NeedRepairTime,   %% 是否为老服
    case IsOldServer andalso IsOldPlayer of
        true ->
            case mod_counter:get_count(PlayerId, ?MOD_DUNGEON, 4) >= 1 of
                true -> skip;
                false -> lib_player_event:add_listener(?EVENT_LOGIN_CAST, ?MODULE, handle_event, [])
            end;
        false -> skip
    end.

handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{combat_power = Combat, figure = #figure{ lv = PlayerLevel }, id = PlayerId} = PS,
    case mod_counter:get_count(PlayerId, ?MOD_DUNGEON, 4) >= 1 of
        true -> skip;
        _ ->
            mod_counter:apply_cast(PlayerId, ?MODULE, do_repair_old_version_player_data, [PlayerId, Combat, PlayerLevel])
    end,
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

do_repair_old_version_player_data([PlayerId, PlayerCombat, PlayerLevel]) ->
    Fun = fun(DunType, AccL) ->
        DunIds = data_dungeon:get_ids_by_type(DunType),
        Fun2 = fun(DunId) ->
            #dungeon{ recommend_power = Combat, condition = ConditionL } = data_dungeon:get(DunId),
            {lv, ChallengeLv} = ulists:keyfind(lv, 1, ConditionL, {lv, 0}),
            %% 等级与战力都符合配置推荐的，则可完成跳关
            PlayerLevel >= ChallengeLv andalso PlayerCombat >= Combat
        end,
        Filter = lists:filter(Fun2, DunIds),
        case Filter of
            [] -> AccL;
            _ ->
                MaxDunId = lists:max(Filter),
                [{DunType, MaxDunId}|AccL]
        end
    end,
    KvList = lists:foldl(Fun, [], ?DUNGEON_NEW_VERSION_MATERIEL_LIST),
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, ?MODULE, repair_dungeon_records_lhh, [KvList]),
    ok.

repair_dungeon_records_lhh(Player, KvList) ->
    #player_status{id = PlayerId } = Player,
    F = fun(DunType, PlayerAfType) ->
        DunIds = data_dungeon:get_ids_by_type(DunType),
        {DunType, MaxDunId} = ulists:keyfind(DunType, 1, KvList, {DunType, 0}),
        F2 = fun(DunId, {PlayerAfId, Bool}) ->
            case DunId =< MaxDunId of
                true ->
                    ResultData = #callback_dungeon_succ{dun_id = DunId, dun_type = DunType, pass_time = 5},
                    {lib_dungeon_coin:dunex_update_dungeon_record(PlayerAfId, ResultData), true};
                false ->
                    {PlayerAfId, Bool}
            end
        end,
        {NewPlayerAfType, Bool} = lists:foldl(F2, {PlayerAfType, false}, DunIds),
        Level = lib_dungeon_api:get_dungeon_level(NewPlayerAfType, DunType),
        case Bool of
            true ->
                mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, MaxDunId, 1),
                lib_task_api:fin_dun_level(PlayerId, DunType, Level);
            _ ->
                skip
        end,
        pp_dungeon:handle(61020, NewPlayerAfType, [DunType]),
        NewPlayerAfType
    end,
    LastPlayer = lists:foldl(F, Player, ?DUNGEON_NEW_VERSION_MATERIEL_LIST),
    mod_counter:plus_count(PlayerId, ?MOD_DUNGEON, 4, 1),
    LastPlayer.

gm_clear_repair(Player) ->
    #player_status{ id = PlayerId } = Player,
    mod_counter:cut_count(PlayerId, ?MOD_DUNGEON, 4, 1).