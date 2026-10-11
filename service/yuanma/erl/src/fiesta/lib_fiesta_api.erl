%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_fiesta_api.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-12-08
%%% @modified
%%% @description    祭典功能外部接口函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_fiesta_api).

-include("boss.hrl").
-include("common.hrl").
-include("def_daily.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("def_recharge.hrl").
-include("dungeon.hrl").
% -include("errcode.hrl").
-include("fiesta.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("server.hrl").
-include("sql_player.hrl").
-include("treasure_hunt.hrl").
-include("welfare.hrl").

-export([handle_event/2, trigger/2, use_buff_goods/3]).

-export([gm_reset_fiesta/1, gm_add_fiesta_exp/2, gm_set_reg_time/2, gm_finish_task/2,
         gm_activate_premium_fiesta/2, gm_finish_task/3, gm_finish_task2/3]).

% -compile(export_all).

%%% ============================================== api =============================================

%% -----------------------------------------------
%% @doc 普通事件触发处理
-spec
handle_event(PS, Ec) -> {ok, NewPS} when
    PS :: #player_status{},
    Ec :: #event_callback{},
    NewPS :: #player_status{}.
%% -----------------------------------------------
handle_event(#player_status{fiesta = undefined} = PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    case lib_fiesta:init_fiesta([], PS) of
        undefined -> {ok, PS};
        Fiesta ->
            NewPS1 = PS#player_status{fiesta = Fiesta},
            NewPS2 = trigger({acc_login_days, 1}, NewPS1), % 开启时直接触发任务进度(因为有可能同一天已多次登入登出,所以不能用handle_event/2)
            lib_fiesta:send_fiesta_info(NewPS2),
            {ok, NewPS2}
    end;
handle_event(#player_status{fiesta = undefined} = PS, _) -> {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}) ->
    RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
    if
        RealGold > 0 ->
            NewPS1 = trigger({recharge_first, 1}, PS),
            NewPS  = trigger({acc_recharge, RealGold}, NewPS1);
        true ->
            NewPS = PS
    end,
    FiestaId = lib_fiesta:get_fiesta_id(NewPS),
    case lib_fiesta_data:get_premium_type_buy(FiestaId, Product#base_recharge_product.product_id) of % 购买激活高级祭典
        Type when Type == ?PREMIUM_FIESTA; Type == ?PREMIUM_FIESTA2 ->
            LastPS = lib_fiesta:activate_premium_fiesta_prop(Type, NewPS);
        _ ->
            LastPS = NewPS
    end,
    {ok, LastPS};
handle_event(PS, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
    case Data of
        #callback_money_cost{cost = N, money_type = ?GOLD} ->
            NewPS = trigger({acc_consume, N}, PS),
            {ok, NewPS};
        #callback_money_cost{cost = N, money_type = MoneyType} when MoneyType == ?BGOLD; MoneyType == ?BGOLD_AND_GOLD ->
            NewPS = trigger({acc_consume_bgold, N}, PS),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;
handle_event(PS, #event_callback{type_id = ?EVENT_BOSS_KILL,
                                 data = #callback_boss_kill{boss_type = BossType}}) ->
    NewPS =
    case BossType of
        ?BOSS_TYPE_NEW_OUTSIDE ->
            trigger({kill_world_boss, 1}, PS);
        % ?BOSS_TYPE_VIP_PERSONAL -> % 专属boss被杀不会走这个事件
        %     trigger({kill_per_boss, 1}, PS);
        ?BOSS_TYPE_PHANTOM ->
            trigger({kill_eudemons_boss, 1}, PS);
        ?BOSS_TYPE_DECORATION_BOSS ->
            trigger({kill_decoration_boss, 1}, PS);
        ?BOSS_TYPE_SANCTUARY ->
            trigger({kill_sanctuary_boss, 1}, PS);
        ?BOSS_TYPE_KF_SANCTUARY ->
            trigger({kill_sanctuary_boss, 1}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_EQUIP_COMPOSE,
                                 data = #callback_equip_compose{goods_list = ComposeList}}) ->
    List1 = [Goods || #goods{color = ?RED} = Goods <- ComposeList],
    NewPS = trigger({compose_red_equip, length(List1)}, PS),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_BOSS_DUNGEON_ENTER,
                                 data = #callback_boss_dungeon_enter{boss_type = BossType}}) ->
    NewPS =
    case BossType of
        ?BOSS_TYPE_FORBIDDEN ->
            trigger({enter_forbidden_dungeon, 1}, PS);
        ?BOSS_TYPE_DOMAIN ->
            trigger({enter_fairyland_dungeon, 1}, PS);
        ?BOSS_TYPE_KF_GREAT_DEMON ->
            trigger({enter_fairyland_dungeon, 1}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_JOIN_ACT,
                                 data = #callback_join_act{type = ActType, subtype = SubType, times = N}}) ->
    NewPS =
    case ActType of
        ?MOD_SEA_TREASURE ->
            trigger({enter_sea_treasure, 1}, PS);
        ?MOD_MIDDAY_PARTY ->
            trigger({enter_midday_party, 1}, PS);
        ?MOD_GUILD_ACT ->
            case SubType of
                guild_feast ->
                    trigger({enter_guild_feast, 1}, PS);
                guild_feast_fire ->
                    trigger({enter_guild_fire, 1}, PS);
                % guild_war ->
                %     trigger({enter_guild_war, 1}, PS);
                _ ->
                    PS
            end;
        ?MOD_JJC ->
            trigger({enter_jjc, N}, PS);
        ?MOD_TREASURE_HUNT ->
            case SubType of
                ?TREASURE_HUNT_TYPE_RUNE ->
                    trigger({rune_hunt, N}, PS);
                ?TREASURE_HUNT_TYPE_EUQIP ->
                    trigger({treasure_hunt, N}, PS);
                ?TREASURE_HUNT_TYPE_PEAK ->
                    trigger({peak_hunt, N}, PS);
                ?TREASURE_HUNT_TYPE_EXTREME ->
                    trigger({extreme_hunt, N}, PS);
                _ ->
                    PS
            end;
        ?MOD_WELFARE ->
            case SubType of
                ?WELFARE_DAILY_CHECKIN ->
                    trigger({sign_in, 1}, PS);
                _ ->
                    PS
            end;
        ?MOD_NINE ->
            trigger({enter_nine_palace, 1}, PS);
        ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
            trigger({enter_holy_battlefield, 1}, PS);
        ?MOD_TOPPK ->
            trigger({enter_top_pk, 1}, PS);
        ?MOD_DRUMWAR ->
            trigger({enter_drumwar, 1}, PS);
        ?MOD_PRAY ->
            trigger({acc_pray, 1}, PS);
        ?MOD_TERRITORY_WAR ->
            trigger({enter_guild_war, 1}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS,
                                 data = #callback_dungeon_succ{dun_type = DunType, count = Count}}) ->
    NewPS =
    case DunType of
        ?DUNGEON_TYPE_EQUIP ->
            trigger({pass_equip_dungeon, Count}, PS);
        ?DUNGEON_TYPE_VIP_PER_BOSS ->
            trigger({kill_per_boss, Count}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SWEEP,
                                 data = #callback_dungeon_sweep{dun_type = DunType, count = Count}}) ->
    NewPS =
    case DunType of
        ?DUNGEON_TYPE_PARTNER_NEW -> % 神巫副本(契灵、新伙伴)
            trigger({sweep_partner_new_dungeon, Count}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_ADD_LIVENESS,
                                 data = #callback_activity_live{activity_live = _N}}) ->
    N = mod_daily:get_count(PS#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    NewPS = trigger({liveness, N}, PS),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_ENTER,
                                 data = #callback_dungeon_enter{dun_type = DunType, count = Count}}) ->
    NewPS =
    case DunType of
        ?DUNGEON_TYPE_EXP_SINGLE ->
            trigger({enter_exp_dungeon, Count}, PS);
        ?DUNGEON_TYPE_DRAGON ->
            trigger({enter_dragon_dungeon, Count}, PS);
        _ ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{
        login_time_before_last = LastLoginTime1,
        last_login_time = LastLoginTime2,
        last_logout_time = LastLogoutTime
    } = PS,
    % 累计登录条件判断
    % 首先判断上次登出时间(LastLogoutTime)是否已跨天
    %   Y - (此时因有可能顶号登录触发导致LastLogoutTime未更新,执行下列判断)
    %       判断上次登录时间(LastLoginTime1)和本次登录时间(LastLoginTime2)是否跨天(0点时为离线状态)
    %       orelse
    %       本次登录时间(LastLoginTime2)是否与当前时间同天(0点时为在线状态)
    %       Y - 更新登录次数
    %       N - 顶号登录
    %   N - 同天登录
    NewPS =
    case utime:diff_days(LastLogoutTime) > 0 andalso (utime:diff_days(LastLoginTime1, LastLoginTime2) > 0 orelse utime:diff_days(LastLoginTime2) > 0) of
        true ->
            trigger({acc_login_days, 1}, PS);
        false ->
            PS
    end,
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) ->
    #player_status{figure = #figure{turn = Turn}} = PS,
    NewPS =
    case Turn of
        1 -> trigger({turn_task1, 1}, PS);
        2 -> trigger({turn_task2, 1}, PS);
        3 -> trigger({turn_task3, 1}, PS);
        _ -> PS
    end,
    {ok, NewPS};

handle_event(PS, _) -> {ok, PS}.

%% -----------------------------------------------
%% @doc 祭典任务触发处理
-spec
trigger({CType, Arg}, PS) -> NewPS when
    CType :: atom(), % 任务内容类型
    Arg :: term(),
    PS :: #player_status{},
    NewPS :: #player_status{}.
%% -----------------------------------------------
trigger(_, #player_status{fiesta = undefined} = PS) -> PS;
trigger({CType, Arg}, PS) ->
    % 查询当前符合Type且未完成的任务
    UnfinishTasks = get_unfinish_tasks(CType, PS),
    % 任务触发
    F = fun({TaskType, TaskL}, AccPS) ->
        NAccPS = trigger_task(TaskType, TaskL, Arg, AccPS),
        lib_fiesta:send_task_info(TaskType, NAccPS),
        NAccPS
    end,
    NewPS = lists:foldl(F, PS, UnfinishTasks),
    NewPS.

%% -----------------------------------------------
%% @doc 使用祭典增益道具
-spec
use_buff_goods(PS, GoodsInfo, GoodsNum) -> {ok, NewPS} when
    PS :: #player_status{},
    GoodsInfo :: #goods{},
    GoodsNum :: integer(),
    NewPS :: #player_status{}.
%% -----------------------------------------------
use_buff_goods(PS, GoodsInfo, GoodsNum) ->
    #goods{goods_id = GTypeId} = GoodsInfo,
    EndTime = lib_fiesta:get_expired_time(PS),
    lib_goods_buff:add_goods_buff(PS, GTypeId, GoodsNum, [{etime, EndTime}]).

%%% =============================================== gm =============================================

%% 清理玩家祭典,重新初始化
gm_reset_fiesta(PS) ->
    #player_status{id = RoleId} = PS,
    lib_fiesta_data:clear_player_fiesta(RoleId),
    NewPS = lib_fiesta:login(PS),
    lib_fiesta:send_fiesta_info(NewPS),
    lib_fiesta:send_task_info(0, NewPS),
    {ok, NewPS}.

%% 增加祭典经验
gm_add_fiesta_exp(PS, AddExp) when is_record(PS, player_status) ->
    NewPS = lib_fiesta:add_fiesta_exp(AddExp, PS),
    lib_fiesta:send_fiesta_info(NewPS),
    {ok, NewPS};
gm_add_fiesta_exp(RoleId, AddExp) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, gm_add_fiesta_exp, [AddExp]),
    ok.

%% 设置创角天数
gm_set_reg_time(PS, RegTime) ->
    #player_status{id = RoleId} = PS,
    db:execute(io_lib:format(?sql_update_reg_time, [RegTime, RoleId])),
    NewPS = PS#player_status{reg_time = RegTime},
    {ok, NewPS}.

%% 完成任务
gm_finish_task(PS, TaskId) when is_integer(TaskId) ->
    #base_fiesta_task{content = CType, target_num = N} = data_fiesta:get_base_fiesta_task(TaskId),
    trigger({CType, N}, PS);
gm_finish_task(PS, TaskContent) ->
    TaskIds = data_fiesta:get_task_ids_by_ctype(TaskContent),
    TmpNums = [
        begin
            #base_fiesta_task{target_num = N} = data_fiesta:get_base_fiesta_task(TaskId),
            N
        end || TaskId <- TaskIds
    ],
    MaxN = lists:max(TmpNums),
    trigger({TaskContent, MaxN}, PS).

%% 激活高级祭典
gm_activate_premium_fiesta(RoleId, Type) when Type == ?PREMIUM_FIESTA; Type == ?PREMIUM_FIESTA2 ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_fiesta, activate_premium_fiesta_prop, [Type]).

%% 完成任务(外服秘籍)
%% @param RoleIdList :: [RoleId,...]
%%        TaskContent :: atom()
%%        N :: integer()
gm_finish_task(RoleIdListStr, TaskContentStr, N) ->
    RoleIdList = util:string_to_term(RoleIdListStr),
    TaskContent = list_to_atom(string:strip(TaskContentStr)),
    F = fun(RoleId) ->
        lib_player:apply_cast(RoleId, ?APPLY_CALL_SAVE, ?HAND_OFFLINE, ?MODULE, gm_finish_task2, [TaskContent, N])
    end,
    lists:foreach(F, RoleIdList).

gm_finish_task2(PS, TaskContent, N) ->
    trigger({TaskContent, N}, PS).

%%% ======================================= private functions ======================================

%% 根据任务内容类型获取相关未完成任务
get_unfinish_tasks(CType, PS) ->
    #player_status{figure = #figure{lv = Lv}, reg_time = RegTime} = PS,
    TaskM = lib_fiesta:get_task_map(PS),
    RelaTaskIds = data_fiesta:get_task_ids_by_ctype(CType),
    F = fun({TaskType, TaskL0}, AccL) ->
        TaskL = [Task || #fiesta_task{task_id = TaskId} = Task <- TaskL0,
                         lists:member(TaskId, RelaTaskIds),
                         lib_fiesta_data:is_task_can_received(Lv, RegTime, TaskId),
                         not lib_fiesta_data:is_task_finish_total(Task)],
        [{TaskType, TaskL} | AccL]
    end,
    lists:foldl(F, [], maps:to_list(TaskM)).

%% 任务触发
trigger_task(_, [], _, PS) -> PS;
trigger_task(_, [[]], _, PS) -> PS; % 秘籍兼容
trigger_task(TaskType, [Task | T0], Arg, PS) ->
    #player_status{id = RoleId} = PS,
    #fiesta_task{task_id = TaskId} = Task,
    #base_fiesta_task{
        times = TotalTimes, target_num = TargetNum
    } = data_fiesta:get_base_fiesta_task(TaskId),
    {TaskL, TaskM, Fiesta} = lib_fiesta:gex_task_list(TaskType, PS),
    % 计算新任务值
    NewTask = lib_fiesta_data:update_task_by_trigger(TaskType, Task, Arg),
    % 后续处理
    #fiesta_task{cur_num = NewCurNum, finish_times = FinishTimes, acc_times = AccTimes} = NewTask,
    case NewCurNum >= TargetNum andalso FinishTimes+AccTimes < TotalTimes of
        true -> % 溢出的数值还能触发完成任务,加入处理队列
            T = [NewTask | T0];
        false ->
            T = T0
    end,
    % 日志,入库,更新PS
    lib_fiesta:log_fiesta_task_progress(RoleId, TaskType, NewTask),
    lib_fiesta_data:db_replace_fiesta_task(RoleId, TaskType, NewTask),
    NewPS = lib_fiesta:set_task(NewTask, TaskL, TaskType, TaskM, Fiesta, PS),

    trigger_task(TaskType, T, Arg, NewPS).