%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_exp.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-10-31
%% @Description:    经验副本特殊逻辑
%%-----------------------------------------------------------------------------
-module (lib_dungeon_exp).
-include ("dungeon.hrl").
-include ("errcode.hrl").
-include ("server.hrl").
-include ("predefine.hrl").
-include ("common.hrl").
-include ("rec_event.hrl").
-include ("def_event.hrl").
-include ("figure.hrl").
-include("buff.hrl").
-include("goods.hrl").
-include("def_fun.hrl").

-export ([
    dunex_check_extra/2
    ,pull_cost/3
    ,init_dungeon_role/3
    ,dunex_handle_enter_dungeon_for_setting/5
    ,dunex_handle_quit_dungeon/2
    ,dunex_handle_quit_dungeon_on_off/3
    ,dunex_encourage/3
    ,do_encourage_ps/7
    ,dunex_setup_encourage_count/4
    ,dunex_get_encourage_count/2
    ,dunex_get_force_quit_time/1
    ,dunex_change_lv_when_role_out/2
    ,dunex_handle_enter_dungeon/2
    ,dunex_get_start_dun_args/2
    ,dunex_handle_dungeon_result/1
    ,dun_exp_finish_ps/4
    ,dunex_push_settlement/2
    ]).

-export ([
    clean_buff/2
    , handle_lv_up/2
    , dunex_handle_kill_mon/4
    , dunex_begin_create_mon/1
    , dunex_trigger_add_exp/2
    , dunex_add_exp/3
    , dunex_send_panel_info/2
    ]).

-define(BASE_COMBAT_POWER(Lv), min(30000*math:exp(0.016*Lv),1000*math:pow(Lv, 2)-440000*Lv+50000000)).
-define(EXP_IN_EVERY_SECOND(BaseCombat, Combat, Lv, Percent),
    min(max(1.35,(math:pow(Combat*((1+Percent)/10000)/BaseCombat,0.35)+0.75)),2.35)*(655200*math:exp(0.007245*max(Lv, 173)))
).

%% 热更使用，临时放这里
-define(DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_BEGIN_TIME, "trigger_exp_begin_time"). %% 触发经验本开始时间
-define(DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_TIMES, "trigger_exp_trigger_times"). %% 触发经验本次数
-define(DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_REF, "trigger_exp_trigger_ref"). %% 触发经验本定时器

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 副本的回调
dunex_push_settlement(State, DungeonRole) ->
    #dungeon_state{
        result_type = ResultType,
        dun_id = DunId,
        now_scene_id = SceneId,
        result_subtype = ResultSubtype
    } = State,
    #dungeon_role{
        typical_data = TypicalData, reward_map = RewardMap,
        count = Count, help_type = HelpType
    } = DungeonRole,
    % NowTime = utime:longunixtime(),
    Ref = maps:get(?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_REF, TypicalData, undefined),
    util:cancel_timer(Ref),

    % 经验本又双叒叕改逻辑了， 不走定时触发了，服务端托管战斗 @modify20220510
    % BeginTime = maps:get(?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_BEGIN_TIME, TypicalData, NowTime),
    % TriggerTimes = maps:get(?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_TIMES, TypicalData, (NowTime - BeginTime) div 1000),
    % % 获取没有触发的次数，（定时器肯定有点偏差）
    % NoTriggerTimes = max(0, (NowTime - BeginTime) div 1000 - TriggerTimes),
    % NoGetExp = send_exp(DungeonRole, SceneId, NoTriggerTimes),
    NoGetExp = 0,

    {EnterLv, EnterExp} = maps:get(?DUN_ROLE_SPECIAL_KEY_ENTER_EXP_INFO, TypicalData, {0, 0}),
    LastExpGet = maps:get(?DUN_ROLE_SPECIAL_KEY_EXP_RECORD, TypicalData, 0),
    Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0) + NoGetExp,
    ThRatio = round(EnterExp / data_exp:get(EnterLv) * 1000),
    IsNewReward = ?IF(Exp > LastExpGet, 1, 0),
    Grade
        = if
              ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
                  0;
              true ->
                  Score = lib_dungeon:calc_score(State, DungeonRole#dungeon_role.id),
                  case data_dungeon_grade:get_dungeon_grade(DunId, Score) of
                      #dungeon_grade{grade = Value} ->
                          Value;
                      _ ->
                          0
                  end
          end,
    RewardList = lib_dungeon:get_source_list(RewardMap),
    MultipleReward = maps:get(?REWARD_SOURCE_DUNGEON_MULTIPLE, RewardMap, []),
    case MultipleReward of
        [] ->
            {ok, BinData} = pt_610:write(61003, [ResultType, ResultSubtype, DunId, Grade, SceneId, RewardList,
                [], [{9, HelpType}, {10, IsNewReward}, {11, EnterLv}, {12, ThRatio}], Count]);
        _ ->
            {ok, BinData} = pt_610:write(61003, [ResultType, ResultSubtype, DunId, Grade, SceneId, RewardList,
                [{?DUNGEON_PUSH_SETTLE_MULTIPLE_REWARD, MultipleReward}], [{9, HelpType}, {10, IsNewReward}, {11, EnterLv}, {12, ThRatio}], Count])
    end,
    lib_dungeon_mod:send_to_uid(DungeonRole#dungeon_role.node, DungeonRole#dungeon_role.id, BinData).

%% 副本结束，支线任务触发
%% 记录副本信息
dunex_handle_dungeon_result(State) ->
    #dungeon_state{role_list = RoleList, dun_id = DunId} = State,
    [begin
         Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
         lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, dun_exp_finish_ps, [DunId, Exp, Count])
         % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, dun_exp_finish, [Exp])
     end||#dungeon_role{id = RoleId, typical_data = TypicalData, count = Count}<-RoleList],
    State.

dun_exp_finish_ps(Player, DunId, Exp, Count) ->
    #player_status{dungeon_record = Record, id = RoleId} = Player,
    KvList = maps:get(DunId, Record, []),
    {_, OldExpRecord} = ulists:keyfind(?DUNGEON_REC_LAST_EXP_GET, 1, KvList, {?DUNGEON_REC_LAST_EXP_GET, 0}),
    Data0 = lists:keystore(?DUNGEON_REC_UPDATE_TIME, 1, KvList, {?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}),
    Data = lists:keystore(?DUNGEON_REC_LAST_EXP_GET, 1, Data0, {?DUNGEON_REC_LAST_EXP_GET, max(OldExpRecord, Exp div Count)}),
    NewRecord = maps:put(DunId, Data, Record),
    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, dun_exp_finish, [Exp]),
    Player#player_status{dungeon_record = NewRecord}.

%% 检查额外的参数
%% 注：经验副本不需要检查合并内容(因为合并选项是检查后再设置的,此处为旧的合并数据)
dunex_check_extra(_Player, #dungeon{id = _DunId} = _Dun) -> true.
    % SettingL = lib_dungeon_setting:get_setting_list(Player, DunId),
    % % lib_dungeon_setting:check_enter_setting(Player, Dun).
    % #{count:=Count, cost:=SettingCost} = _SettingInfo = lib_dungeon_setting:make_setting_data_info(SettingL, Dun, #{}),
    % % ?MYLOG("hjhexp", "Count:~p SettingCost:~p SettingInfo:~p ~n", [Count, SettingCost, SettingInfo]),
    % case lib_dungeon_check:check_dungeon_count(Dun#dungeon.count_cond, Dun, Count, Player) of
    %     {false, ErrCode} -> {false, ErrCode};
    %     true ->
    %         MultiCost = lib_dungeon:calc_real_cost_multi(Player, Dun, Count),
    %         % ?MYLOG("hjhexp", "Count:~p SettingCost:~p MultiCost:~p ~n", [Count, SettingCost, MultiCost]),
    %         lib_goods_api:check_object_list(Player, SettingCost++MultiCost)
    % end.

%% 拉进副本扣除
pull_cost(Player, DunId, SettingL) ->
    Dun = data_dungeon:get(DunId),
    #{count:=Count, cost := SettingCost} = lib_dungeon_setting:make_setting_data_info(SettingL, Dun, #{}),
    MultiCost = lib_dungeon:calc_real_cost_multi(Player, Dun, Count),
    SumCost = SettingCost ++ MultiCost,
    % ?MYLOG("hjhexp", "Count:~p SettingCost:~p MultiCost:~p SumCost:~p ~n", [Count, SettingCost, MultiCost, SumCost]),
    case lib_goods_api:cost_object_list_with_check(Player, SumCost, dungeon_enter_cost, integer_to_list(DunId)) of
        {true, NewPlayer} -> {true, NewPlayer};
        Other -> Other
    end.

%% 初始化
init_dungeon_role(#player_status{dungeon_record = Record, figure = #figure{lv = Lv}, exp = Exp}, #dungeon{id = DunId} = Dun, #dungeon_role{setting_list = SettingList} = Role) ->
    #{count := Count, gold_count := GoldCount, coin_count := CoinCount} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
    KvList = maps:get(DunId, Record, []),
    {_, LastExpGet} = ulists:keyfind(?DUNGEON_REC_LAST_EXP_GET, 1, KvList, {?DUNGEON_REC_LAST_EXP_GET, 0}),
    Role#dungeon_role{
        count = Count,
        typical_data = #{
            ?DUN_ROLE_SPECIAL_KEY_ENTER_EXP_INFO => {Lv, Exp},
            ?DUN_ROLE_SPECIAL_KEY_EXP_RECORD => LastExpGet,
            {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN} => CoinCount,
            {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD} => GoldCount
        }
    };

init_dungeon_role(_, _, Role) ->
    Role.

%% 进入场景的设置
dunex_handle_enter_dungeon_for_setting(Player, #dungeon{id = DunId} = Dun, _HelpType, SettingList, _Count) ->
    case data_dungeon_special:get(DunId, encourage_data) of
        {SkillId,_GoldCountLimit,_CoinCountLimit,_GoldCost,_CoinCost} ->
            #{gold_count := GoldCount, coin_count := CoinCount} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
            NewPlayer = lib_goods_buff:add_skill_buff(Player, SkillId, GoldCount + CoinCount, ?BUFF_SKILL_NO),
            {ok, BinData} = pt_610:write(61065, [CoinCount, GoldCount]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            NewPlayer;
        _ ->
            Player
    end.

dunex_handle_quit_dungeon(Player, #dungeon{id = DunId, type = _DunType}) ->
    lib_player_event:remove_listener(?EVENT_LV_UP, ?MODULE, handle_lv_up),
    case data_dungeon_special:get(DunId, encourage_data) of
        {SkillId,_,_,_,_} -> lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff, SkillId);
        _ -> skip
    end,
    % KvList = maps:get(DunId, Record, []),
    % Data = lists:keystore(?DUNGEON_REC_UPDATE_TIME, 1, KvList, {?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}),
    % NewRecord = maps:put(DunId, Data, Record),
    % lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
    lib_player_behavior:online_end(Player).

dunex_handle_quit_dungeon_on_off(RoleId, _OffMap, #dungeon{id = DunId, type = _DunType}) ->
    Data = lib_dungeon:get_dungeon_record_data(RoleId, DunId),
    NewData = lists:keystore(?DUNGEON_REC_UPDATE_TIME, 1, Data, {?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}),
    lib_dungeon:save_dungeon_record(RoleId, DunId, NewData),
    ok.

dunex_handle_enter_dungeon(Player, #dungeon{id = DunId}) ->
    %% 设置托管 TODO 做成配置
    lib_player:apply_cast(Player#player_status.id, ?APPLY_CAST_SAVE, lib_player_behavior, online_start, [onhook]),
    lib_player_event:add_listener(?EVENT_LV_UP, ?MODULE, handle_lv_up),
    %% 经验本默认进入添加1级伤害buff (增伤50%
    case data_dungeon_special:get(DunId, encourage_data) of
        {SkillId,_,_,_,_} ->
            lib_goods_buff:add_skill_buff(Player, SkillId, 1, ?BUFF_SKILL_NO);
        _ -> Player
    end.

clean_buff(Player, #event_callback{param = SkillId}) ->
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff),
    NewPlayer = lib_goods_buff:remove_skill_buff(Player, SkillId),
    {ok, NewPlayer}.

dunex_encourage(State, RoleId, CostType) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList} = State,
    Res
    = case data_dungeon_special:get(DunId, encourage_data) of
        {SkillId,GoldCountLimit,CoinCountLimit,GoldCost,CoinCost} ->
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                #dungeon_role{typical_data = TypicalData, node = Node} = Role ->
                    CoinCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN}, TypicalData, 0),
                    GoldCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD}, TypicalData, 0),
                    LockTime = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, lock}, TypicalData, 0),
                    Now = utime:unixtime(),
                    if
                        Now - LockTime < 5 ->
                            {false, ?ERRCODE(operation_too_quickly)};
                        CostType =:= ?ENCOURAGE_COST_TYPE_GOLD andalso GoldCount >= GoldCountLimit ->
                            {false, ?ERRCODE(err610_encourage_gold_count_limit)};
                        CostType =:= ?ENCOURAGE_COST_TYPE_COIN andalso CoinCount >= CoinCountLimit ->
                            {false, ?ERRCODE(err610_encourage_coin_count_limit)};
                        true ->
                            NewTypicalData = TypicalData#{{?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, lock} => Now},
                            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
                            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
                            NewState = State#dungeon_state{role_list = NewRoleList},
                            Cost
                            = if
                                CostType =:= ?ENCOURAGE_COST_TYPE_COIN ->
                                    [CoinCost];
                                true ->
                                    [GoldCost]
                            end,
                            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, do_encourage_ps,
                                [DunId, CostType, Cost, SkillId, CoinCount, GoldCount]),
                            {ok, NewState}
                    end;
                _ ->
                    Node = none,
                    {false, ?FAIL}
            end;
        _ ->
            Node = none,
            {false, ?ERRCODE(missing_config)}
    end,
    case Res of
        {false, Code} ->
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_610:write(61000, [CodeInt, CodeArgs]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            Res
    end.

do_encourage_ps(Player, DunId, CostType, Cost, SkillId, CoinCount, GoldCount) ->
    #player_status{dungeon = #status_dungeon{dun_id = DunId0}, id = RoleId, sid = Sid, copy_id = CopyId} = Player,
    IsOnDungeon = lib_dungeon:is_on_dungeon_ongoing(Player),
    if
        DunId0 == DunId andalso IsOnDungeon->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_encourage, "") of
                {true, NewPlayer} ->
%%                    ?PRINT("CostType ~p~n", [CostType]),
                    if
                        CostType =:= ?ENCOURAGE_COST_TYPE_COIN ->
                            NewCoinCount = CoinCount + 1, NewGoldCount = GoldCount;
                        true ->
                            NewCoinCount = CoinCount, NewGoldCount = GoldCount + 1
                    end,
                    %% buff等级 = 鼓舞次数+1
                    %% buff 1 级 是进入副本提供， 每次鼓舞提供对应的等级buff
                    BuffLv = NewCoinCount + NewGoldCount + 1,
                    NewPlayer1 = lib_goods_buff:add_skill_buff(NewPlayer, SkillId, BuffLv, ?BUFF_SKILL_NO),
                    mod_dungeon:setup_encourage_count(CopyId, RoleId, CostType, 1),
                    case data_dungeon:get(DunId) of
                        #dungeon{type = Type} when Type =:= ?DUNGEON_TYPE_EXP_SINGLE ->
                            lib_achievement_api:dungeon_exp_encourage_event(Player, CostType);
                        _ ->
                            skip
                    end,
                    {ok, BinData} = pt_610:write(61025, [?SUCCESS, NewCoinCount, NewGoldCount]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPlayer1};
                {false, Code, _} ->
                    mod_dungeon:setup_encourage_count(CopyId, RoleId, CostType, 0),
                    {ok, BinData} = pt_610:write(61025, [Code, CoinCount, GoldCount]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        true ->
            skip
    end.

dunex_setup_encourage_count(State, RoleId, CostType, AddCount) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData} = Role ->
            TypicalCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, CostType}, TypicalData, 0),
            NewTypicalData = TypicalData#{
                {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, CostType} => TypicalCount + AddCount,
                {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, lock} => 0
            },
            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            % NewCoinCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN}, NewTypicalData, 0),
            % NewGoldCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD}, NewTypicalData, 0),
            % {ok, BinData} = pt_610:write(61026, [NewCoinCount, NewGoldCount]),
            % lib_server_send:send_to_uid(RoleId, BinData),
            {ok, NewState};
        _ ->
            skip
    end.

dunex_get_encourage_count(State, RoleId) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData, node = Node} ->
            CoinCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN}, TypicalData, 0),
            GoldCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD}, TypicalData, 0),
            {ok, BinData} = pt_610:write(61026, [CoinCount, GoldCount]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end.


dunex_get_force_quit_time(_) ->
    50.

dunex_change_lv_when_role_out(RoleList, DunType) ->
    lib_dungeon:calc_enter_lv(RoleList, DunType).

handle_lv_up(Player, _Evt) ->
    #player_status{figure = #figure{lv = Lv}, id = RoleId, copy_id = CopyId} = Player,
    if
        is_pid(CopyId) ->
            mod_dungeon:update_role_lv(CopyId, RoleId, Lv);
        true ->
            lib_player_event:remove_listener(?EVENT_LV_UP, ?MODULE, handle_lv_up)
    end,
    {ok, Player}.

dunex_get_start_dun_args(_, _) ->
    TypicalArgs = {?DUN_STATE_SPCIAL_KEY_COMMON_DUNR, [{find_target, 1000}]},
    [{typical_data, [TypicalArgs]}].

%% 击杀怪物
dunex_handle_kill_mon(State, _Mid, _CreateKey, DieDatas) ->
    % ?INFO("handle_kill_mon ~n", []),
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(killer, 1, DieDatas) of
        {killer, RoleId} ->
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                #dungeon_role{typical_data = TypicalData} = Role ->
                    Value = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_DIE, TypicalData, 0),
                    NewValue = Value+1,
                    % ?INFO("handle_kill_mon NewValue:~p ~n", [NewValue]),
                    NewTypicalData = maps:put(?DUN_ROLE_SPECIAL_KEY_MON_DIE, NewValue, TypicalData),
                    NewRole = Role#dungeon_role{typical_data = NewTypicalData},
                    NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
                    NewState = State#dungeon_state{role_list = NewRoleList},
                    dunex_send_panel_info(NewState, RoleId),
                    NewState;
                _ ->
                    State
            end;
        _ ->
            State
    end.

%% 刷怪事件开始，可以开始累计经验
dunex_begin_create_mon(State) ->
    NowTime = utime:longunixtime(),
    #dungeon_state{role_list = RoleList} = State,
    F = fun(Role) ->
        #dungeon_role{typical_data = TypicalData, id = _RoleId} = Role,
        %Ref = erlang:send_after(1000, self(), {'exp_dungeon_trigger', RoleId}),
        Ref = undefined,
        NewTypicalData = TypicalData#{
            ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_BEGIN_TIME => NowTime,
            ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_TIMES => 0,
            ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_REF => Ref
        },
        % {ok, BinData} = pt_611:write(61119, [NowTime]),
        % lib_server_send:send_to_uid(Node, RoleId, BinData),
        Role#dungeon_role{typical_data = NewTypicalData}
    end,
    NewRoleList = lists:map(F, RoleList),
    State#dungeon_state{role_list = NewRoleList}.

%% 触发经验增加,客户端主动触发，不走杀怪流程获取经验
%% 弃用 经验本又双叒叕改逻辑了， 不走定时触发了，服务端托管战斗 @modify20220510
dunex_trigger_add_exp(State, RoleId) ->
    #dungeon_state{role_list = RoleList, now_scene_id = SceneId, end_time = EndTime} = State,
    NowTime = utime:longunixtime(),
    IsEnd = NowTime div 1000 > EndTime,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        _ when IsEnd ->
            State;
        #dungeon_role{
            typical_data = #{
                ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_TIMES := Times,
                ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_REF := OldRef
            } = TypicalData
        } = Role ->
            send_exp(Role, SceneId, 1),
            Ref = util:send_after(OldRef, 1000, self(), {'exp_dungeon_trigger', RoleId}),
            NewTypicalData = TypicalData#{
                ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_TIMES => Times + 1,
                ?DUN_ROLE_SPECIAL_KEY_TRIGGER_EXP_TRIGGER_REF => Ref
            },
            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            %{ok, BinData} = pt_611:write(61119, [NowTime + 1000]),
            %lib_server_send:send_to_uid(Node, RoleId, BinData),
            NewState;
        _ ->
            State
    end.

send_exp(_Role, _SceneId, 0) -> 0;
send_exp(Role, SceneId, TriggerTimes) ->
    #dungeon_role{
        typical_data = TypicalData, node = Node, id = RoleId,
        figure = #figure{lv = RoleLv}, combat_power = CombatPower
    } = Role,
    CoinCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN}, TypicalData, 0),
    GoldCount = maps:get({?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD}, TypicalData, 0),
    Per = (CoinCount + GoldCount) * 1000,
    BasePower = ?BASE_COMBAT_POWER(RoleLv),
    Exp = round(?EXP_IN_EVERY_SECOND(BasePower, CombatPower, RoleLv, Per) * TriggerTimes ),
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_player, share_mon_exp, [Exp, ?ADD_EXP_MON, [], SceneId]),
    Exp.

%% 增加经验，玩家身上获取经验回调到副本
dunex_add_exp(State, RoleId, AddExp) ->
    % ?INFO("add_exp AddExp:~p ~n", [AddExp]),
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData} = Role ->
            Value = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
            NewValue = Value+AddExp,
            % ?INFO("add_exp NewValue:~p ~n", [NewValue]),
            NewTypicalData = maps:put(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, NewValue, TypicalData),
            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            dunex_send_panel_info(NewState, RoleId),
            NewState;
        _ ->
            State
    end.

%% 发送面板信息
dunex_send_panel_info(State, RoleId) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData, node = Node} ->
            KillNum = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_DIE, TypicalData, 0),
            Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
            {ok, BinData} = pt_610:write(61044, [KillNum, Exp]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            State
    end.