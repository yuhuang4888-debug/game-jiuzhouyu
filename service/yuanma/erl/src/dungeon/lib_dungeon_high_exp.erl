%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_high_exp.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-09-02
%% @deprecated 高级经验副本
%% ---------------------------------------------------------------------------
-module(lib_dungeon_high_exp).

-include("server.hrl").
-include("dungeon.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("buff.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").

-export([
    dunex_check_extra/2
        , init_dungeon_role/3
        , dunex_handle_enter_dungeon/2
        , dunex_handle_enter_dungeon_for_setting/5
        , dunex_handle_quit_dungeon/2
        , dunex_handle_quit_dungeon_on_off/3
        , clean_buff/2
        % , push_settlement/2
        % 击杀本波怪物处理
        , dunex_mon_event_id_kill_all_mon/2
        , high_exp_finish_wave/4
        , dunex_add_exp/5
        , dunex_add_goods_buff/3
        , add_goods_buff_for_player/3
        , dunex_send_wave_panel_info/2
        % 鼓舞
        , encourage/3
        , do_encourage_ps/8
        , dunex_setup_encourage_count/4
        , dunex_get_encourage_count/2
        , get_enter_wave/2
        , dunex_send_jump_wave_info/3
        , dunex_reset_xy/2
        , reset_xy_help/5
    ]).

-export([
        pull_cost/3
        % dungeon_count_increment/5, 
        , dunex_handle_enter_dungeon_for_wave/4
        ]).


%% 检查额外的参数
dunex_check_extra(Player, Dun) ->
    lib_dungeon_setting:check_enter_setting(Player, Dun).

%% 拉进副本扣除
pull_cost(Player, DunId, SettingL) ->
    Dun = data_dungeon:get(DunId),
    #{cost := Cost} = lib_dungeon_setting:make_setting_data_info(SettingL, Dun, #{}),
    case lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_enter_cost, integer_to_list(DunId)) of
        {true, NewPlayer} -> {true, NewPlayer};
        Other -> Other
    end.

% %% 扣除次数
% dungeon_count_increment(Dun, RoleId, HelpType, DeductType, SettingList) ->
%     #{count := Count} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
%     lib_dungeon:dungeon_count_increment_multi(Dun, RoleId, HelpType, DeductType, Count).

%% 初始化
init_dungeon_role(_Player, Dun, #dungeon_role{setting_list = SettingList} = Role) ->
    #{count := Count, gold_count := GoldCount, coin_count := CoinCount} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
    Role#dungeon_role{
        count = Count,
        typical_data = #{
            {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_COIN} => CoinCount,
            {?DUN_ROLE_SPECIAL_KEY_ENCOURAGE, count, ?ENCOURAGE_COST_TYPE_GOLD} => GoldCount
        }
    };

init_dungeon_role(_, _, Role) ->
    Role.

%% 进入场景
dunex_handle_enter_dungeon(Player, #dungeon{id = _DunId}) ->
    % lib_player_event:add_listener(?EVENT_LV_UP, ?MODULE, handle_lv_up),
    Player.

%% 进入场景的设置
dunex_handle_enter_dungeon_for_setting(Player, #dungeon{type = DunType} = Dun, _HelpType, SettingList, _Count) ->
    case data_dungeon_special:get(DunType, encourage_data) of
        {SkillId,_GoldCountLimit,_CoinCountLimit,_GoldCost,_CoinCost} -> 
            #{gold_count := GoldCount, coin_count := CoinCount} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
            % ?MYLOG("hjhhigh", "[GoldCount, CoinCount]:~p ~n", [[GoldCount, CoinCount]]),
            NewPlayer = lib_goods_buff:add_skill_buff(Player, SkillId, GoldCount + CoinCount, ?BUFF_SKILL_NO),
            {ok, BinData} = pt_610:write(61065, [CoinCount, GoldCount]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData),
            NewPlayer;
        _ ->
            Player
    end.

%% 目前不需要处理
% %% 处理进入等级
% change_lv_when_role_out(RoleList, DunType) ->
%     lib_dungeon:calc_enter_lv(RoleList, DunType).

%% 退出场景
dunex_handle_quit_dungeon(#player_status{id = RoleId, dungeon_record = Record} = Player, #dungeon{id = DunId, type = DunType}) ->
    % lib_player_event:remove_listener(?EVENT_LV_UP, ?MODULE, handle_lv_up),
    case data_dungeon_special:get(DunType, encourage_data) of
        {SkillId,_,_,_,_} -> lib_player_event:add_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff, SkillId);
        _ -> skip
    end,
    KvList = maps:get(DunId, Record, []),
    Data = lists:keystore(?DUNGEON_REC_UPDATE_TIME, 1, KvList, {?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}),
    NewRecord = maps:put(DunId, Data, Record),
    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
    Player#player_status{dungeon_record = NewRecord}.

%% 玩家离线退出场景
dunex_handle_quit_dungeon_on_off(RoleId, _OffMap, #dungeon{id = DunId, type = _DunType}) ->
    Data = lib_dungeon:get_dungeon_record_data(RoleId, DunId),
    NewData = lists:keystore(?DUNGEON_REC_UPDATE_TIME, 1, Data, {?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}),
    lib_dungeon:save_dungeon_record(RoleId, DunId, NewData),
    ok.

%% 清理buff
clean_buff(Player, #event_callback{param = SkillId}) ->
    lib_player_event:remove_listener(?EVENT_FIN_CHANGE_SCENE, ?MODULE, clean_buff),
    NewPlayer = lib_goods_buff:remove_skill_buff(Player, SkillId),
    {ok, NewPlayer}.

% %% 结算
% push_settlement(State, #dungeon_role{typical_data = TypicalData, node = Node, history_wave = HistoryWave} = DungeonRole) ->
%     #dungeon_state{
%         result_type = ResultType,
%         wave_num = WaveNum
%     } = State,
%     Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
%     % RewardList = lib_dungeon:calc_base_reward_list(DungeonRole),
%     ?MYLOG("hjhhigh", "push_settlement [WaveNum, HistoryWave, Exp]:~p ~n", [[WaveNum, HistoryWave, Exp]]),
%     if
%         ResultType == ?DUN_RESULT_TYPE_SUCCESS -> FinishWaveNum = WaveNum;
%         true -> FinishWaveNum = max(0, WaveNum-1)
%     end,
%     {ok, BinData} = pt_610:write(61060, [FinishWaveNum, HistoryWave, Exp]),
%     lib_server_send:send_to_uid(Node, DungeonRole#dungeon_role.id, BinData).

%% 处理对应怪物事件配置ID的怪全部被杀死
dunex_mon_event_id_kill_all_mon(State, CommonEvent) ->
    #dungeon_state{dun_id = DunId, wave_num = WaveNum, role_list = RoleList} = State,
    #dungeon_common_event{args = Args} = CommonEvent,
    case lists:keyfind(wave_no, 1, Args) of
        {wave_no, WaveNum} -> 
            Dun = data_dungeon:get(DunId),
            F = fun(#dungeon_role{id = RoleId, node = Node, setting_list = SettingList} = DungeonRole) ->
                #{count := Count} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
                lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, high_exp_finish_wave, [DunId, WaveNum, Count]),
                DungeonRole
            end,
            NewRoleList = lists:map(F, RoleList),
            State#dungeon_state{role_list = NewRoleList};
        _ ->
            State
    end.

%% 完成波数
high_exp_finish_wave(#player_status{id = RoleId, copy_id = CopyId} = Player, DunId, WaveNum, Count) ->
    % ?MYLOG("hjhhigh", "[DunId, WaveNum, Count]:~p ~n", [[DunId, WaveNum, Count]]),
    case data_dungeon_wave:get_wave_helper(DunId, WaveNum) of
        #dungeon_wave_helper{reward = Reward} when Reward =/= [] ->
            % 加物品
            CountReward = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-Reward, Type =/= ?TYPE_EXP],
            Produce = #produce{type = dungeon, reward = CountReward, remark = integer_to_list(DunId)},
            {ok, _, PlayerAfReward, UpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
            % 加经验
            ExpReward = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-Reward, Type == ?TYPE_EXP],
            AddExp = ?IF(ExpReward == [], 0, lists:sum([Num||{_Type, _GoodsTypeId, Num}<-ExpReward])),
            PlayerAfExp = lib_player:add_exp(PlayerAfReward, AddExp, ?ADD_EXP_DUN_ADD, [{dun_id, DunId}]),
            case lib_dungeon:is_on_dungeon(PlayerAfExp) of
                true -> 
                    % 经验有加成的
                    SeeRewardL = lib_goods_api:make_see_reward_list(CountReward, UpGoodsL),
                    NewSeeRewardL = [{Type, GoodsTypeId, Num, GoodsId}||{Type, GoodsTypeId, Num, GoodsId}<-SeeRewardL],
                    mod_dungeon:set_reward(CopyId, RoleId, [{?REWARD_SOURCE_OTHER_DROP, NewSeeRewardL}], false);
                false -> 
                    skip
            end;
        _ ->
            PlayerAfExp = Player
    end,
    {ok, PlayerAfExp}.

%% 增加经验
dunex_add_exp(State, RoleId, AddExp, BaseExp, GoodsExpRatio) ->
    % ?INFO("add_exp AddExp:~p ~n", [AddExp]),
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData} = Role ->
            % 计算物品经验加成
            ExpList = maps:get(?DUN_ROLE_SPECIAL_KEY_EXP_LIST, TypicalData, []),
            case lists:keyfind(GoodsExpRatio, 1, ExpList) of
                false -> NewExpList = [{GoodsExpRatio, BaseExp}|ExpList];
                {_, OldExp} -> NewExpList = lists:keystore(GoodsExpRatio, 1, ExpList, {GoodsExpRatio, BaseExp+OldExp})
            end,
            TypicalDataAfExpL = maps:put(?DUN_ROLE_SPECIAL_KEY_EXP_LIST, NewExpList, TypicalData),
            % 加经验
            Value = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalDataAfExpL, 0),
            NewValue = Value+AddExp, 
            % ?MYLOG("hjhhighexp", "add_exp NewExpList:~p NewValue:~p ~n", [NewExpList, NewValue]),
            NewTypicalData = maps:put(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, NewValue, TypicalDataAfExpL),
            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            StateAfPanel = dunex_send_wave_panel_info(NewState, RoleId),
            StateAfReward = lib_dungeon_mod:set_reward(RoleId, [{?REWARD_SOURCE_WAVE, [{?TYPE_EXP, 0, AddExp, 0}]}], false, StateAfPanel),
            StateAfReward;
        _ ->
            State
    end.

%% 使用物品buff
dunex_add_goods_buff(State, RoleId, GoodsExpRatio) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{node = Node, typical_data = TypicalData} = Role ->
            ExpList = maps:get(?DUN_ROLE_SPECIAL_KEY_EXP_LIST, TypicalData, []),
            F = fun({Ratio, BaseExp}, {TmpExpList, AddExp}) ->
                case GoodsExpRatio > Ratio of
                    true -> {[{GoodsExpRatio, BaseExp}|TmpExpList], AddExp+BaseExp*(GoodsExpRatio-Ratio)};
                    false -> {[{Ratio, BaseExp}|TmpExpList], AddExp}
                end
            end,
            {NewExpList, AddExp} = lists:foldl(F, {[], 0}, ExpList),
            CombineExpList = util:combine_list(NewExpList),
            TypicalDataAfExpL = maps:put(?DUN_ROLE_SPECIAL_KEY_EXP_LIST, CombineExpList, TypicalData),
            NewAddExp = umath:ceil(AddExp),
            % 加经验
            Value = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalDataAfExpL, 0),
            NewValue = Value+NewAddExp, 
            % ?MYLOG("hjhhighexp", "add_goods_buff CombineExpList:~p NewAddExp:~p NewValue:~p ~n", [CombineExpList, NewAddExp, NewValue]),
            NewTypicalData = maps:put(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, NewValue, TypicalDataAfExpL),
            NewRole = Role#dungeon_role{typical_data = NewTypicalData},
            NewRoleList = lists:keystore(RoleId, #dungeon_role.id, RoleList, NewRole),
            NewState = State#dungeon_state{role_list = NewRoleList},
            StateAfPanel = dunex_send_wave_panel_info(NewState, RoleId),
            StateAfReward = lib_dungeon_mod:set_reward(RoleId, [{?REWARD_SOURCE_WAVE, [{?TYPE_EXP, 0, NewAddExp, 0}]}], false, StateAfPanel),
            case NewAddExp > 0 of
                true -> lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, add_goods_buff_for_player, [DunId, NewAddExp]);
                false -> skip
            end,
            StateAfReward;
        _ ->
            State
    end.

%% 不用再通知到副本进程
add_goods_buff_for_player(Player, DunId, AddExp) ->
    PlayerAfExp = lib_player:add_exp(Player, AddExp, ?ADD_EXP_DUN, [{dun_id, DunId}]),
    {ok, PlayerAfExp}.

%% 波数副本面板
dunex_send_wave_panel_info(State, RoleId) ->
    #dungeon_state{role_list = RoleList, wave_num = WaveNum, wave_start_time = WaveStartTime, wave_end_time = WaveEndTime} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData, node = Node, history_wave = HistoryWave} ->
            Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
            % ?MYLOG("hjhhigh", "[WaveNum, WaveStartTime, WaveEndTime, HistoryWave, Exp]:~p ~n", 
            %     [[WaveNum, WaveStartTime, WaveEndTime, HistoryWave, Exp]]),
            {ok, BinData} = pt_610:write(61059, [WaveNum, WaveStartTime, WaveEndTime, HistoryWave, Exp]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            State;
        _ ->
            State
    end.

%% 鼓舞
encourage(State, RoleId, CostType) ->
    #dungeon_state{dun_id = DunId, dun_type = DunType, role_list = RoleList} = State,
    Res
    = case data_dungeon_special:get(DunType, encourage_data) of
        {SkillId,GoldCountLimit,CoinCountLimit,GoldCost,CoinCost} ->
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                #dungeon_role{typical_data = TypicalData, node = Node, setting_list = SettingList} = Role ->
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
                            Dun = data_dungeon:get(DunId),
                            #{count := Count} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
                            MultiCost = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-Cost],
                            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, do_encourage_ps, 
                                [DunId, CostType, Count, MultiCost, SkillId, CoinCount, GoldCount]),
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

% Count 副本次数
do_encourage_ps(Player, DunId, CostType, Count, Cost, SkillId, CoinCount, GoldCount) ->
    #player_status{dungeon = #status_dungeon{dun_id = DunId0}, id = RoleId, sid = Sid, copy_id = CopyId} = Player,
    IsOnDungeon = lib_dungeon:is_on_dungeon_ongoing(Player),
    if
        DunId0 == DunId andalso IsOnDungeon ->
            Remark = lists:concat(["Count:", integer_to_list(Count)]),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, dungeon_encourage, Remark) of
                {true, NewPlayer} ->
                    if
                        CostType =:= ?ENCOURAGE_COST_TYPE_COIN ->
                            NewCoinCount = CoinCount + 1, NewGoldCount = GoldCount;
                        true ->
                            NewCoinCount = CoinCount, NewGoldCount = GoldCount + 1
                    end,
                    NewPlayer1 = lib_goods_buff:add_skill_buff(NewPlayer, SkillId, NewCoinCount + NewGoldCount, ?BUFF_SKILL_NO),
                    mod_dungeon:setup_encourage_count(CopyId, RoleId, CostType, 1),
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

%% 获取鼓舞信息
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

%% 获得进入波数
get_enter_wave(CommonEventMap, RoleList) ->
    case RoleList of
        [] -> 0;
        _ ->
            MinHistoryWave = lists:min([HistoryWave||#dungeon_role{history_wave = HistoryWave}<-RoleList]),
            CurWave = max(0, MinHistoryWave - 5),
            F = fun({BelongType, _CommonEventId}, CommonEvent, MaxWaveNo) ->
                #dungeon_common_event{args = Args} = CommonEvent,
                case lists:keyfind(wave_no, 1, Args) of
                    false -> MaxWaveNo;
                    {wave_no, WaveNo} ->
                        if
                            BelongType == ?DUN_EVENT_BELONG_TYPE_MON -> 
                                max(WaveNo, MaxWaveNo);
                            true ->
                                MaxWaveNo
                        end
                end
            end,
            CfgMax = maps:fold(F, 0, CommonEventMap),
            % ?MYLOG("hjhhigh", "[MinHistoryWave, CurWave, CfgMax]:~p ~n", [[MinHistoryWave,CurWave,CfgMax]]),
            if
                CurWave > CfgMax -> max(0, CfgMax - 5);
                true -> CurWave
            end
    end.

%% 波数
dunex_handle_enter_dungeon_for_wave(#player_status{id = RoleId, copy_id = CopyId} = Player, #dungeon{id = DunId} = Dun, SettingList, WaveNum) ->
    #{count := Count} = lib_dungeon_setting:make_setting_data_info(SettingList, Dun, #{}),
    FinishWaveNum = max(0, WaveNum-1),
    case calc_wave_reward(DunId, FinishWaveNum, []) of
        [] -> PlayerAfExp = Player;
        Reward ->
            CountReward = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-Reward, Type =/= ?TYPE_EXP],
            Produce = #produce{type = dungeon, reward = CountReward, remark = integer_to_list(DunId)},
            {ok, _, PlayerAfReward, UpGoodsL} = lib_goods_api:send_reward_with_mail_return_goods(Player, Produce),
            % 加经验
            ExpReward = [{Type, GoodsTypeId, Num*Count}||{Type, GoodsTypeId, Num}<-Reward, Type == ?TYPE_EXP],
            AddExp = ?IF(ExpReward == [], 0, lists:sum([Num||{_Type, _GoodsTypeId, Num}<-ExpReward])),
            PlayerAfExp = lib_player:add_exp(PlayerAfReward, AddExp, ?ADD_EXP_DUN_ADD, [{dun_id, DunId}]),
            % ?MYLOG("hjhhigh", "[ExpReward, AddExp]:~p ~n", [[ExpReward,AddExp]]),
            case lib_dungeon:is_on_dungeon(Player) of
                true -> 
                    % 经验有加成的
                    SeeRewardL = lib_goods_api:make_see_reward_list(CountReward, UpGoodsL),
                    NewSeeRewardL = [{Type, GoodsTypeId, Num, GoodsId}||{Type, GoodsTypeId, Num, GoodsId}<-SeeRewardL],
                    mod_dungeon:set_reward(CopyId, RoleId, [{?REWARD_SOURCE_OTHER_DROP, NewSeeRewardL}], false);
                false -> 
                    skip
            end
    end,
    case lib_dungeon:is_on_dungeon(PlayerAfExp) of
        true -> 
            case FinishWaveNum > 0 of
                true -> mod_dungeon:send_jump_wave_info(CopyId, RoleId, WaveNum);
                false -> skip
            end;
        false -> 
            skip
    end,
    PlayerAfExp.

calc_wave_reward(_DunId, 0, SumReward) -> SumReward;
calc_wave_reward(DunId, WaveNum, SumReward) ->
    case data_dungeon_wave:get_wave_helper(DunId, WaveNum) of
        #dungeon_wave_helper{reward = Reward} -> MewSumReward = Reward ++ SumReward;
        _ -> MewSumReward = SumReward
    end,
    calc_wave_reward(DunId, WaveNum-1, MewSumReward).

%% 发送跳关信息
dunex_send_jump_wave_info(State, RoleId, WaveNum) ->
    #dungeon_state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
        #dungeon_role{typical_data = TypicalData, node = Node, history_wave = HistoryWave} ->
            Exp = maps:get(?DUN_ROLE_SPECIAL_KEY_ADD_EXP, TypicalData, 0),
            {ok, BinData} = pt_610:write(61061, [WaveNum, HistoryWave, Exp]),
            % ?MYLOG("hjhhigh", "send_jump_wave_info:~p ~n", [[WaveNum, HistoryWave, Exp]]),
            lib_server_send:send_to_uid(Node, RoleId, BinData);
        _ ->
            skip
    end,
    State.

%% 复位:客户端播完特效就复位
dunex_reset_xy(State, RoleId) ->
    #dungeon_state{dun_id = DunId, now_scene_id = SceneId, scene_pool_id = ScenePoolId, is_end = IsEnd, role_list = RoleList} = State,
    if
        IsEnd == ?DUN_IS_END_YES -> State;
        true ->
            case lists:keyfind(RoleId, #dungeon_role.id, RoleList) of
                #dungeon_role{node = Node} ->
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ?MODULE, reset_xy_help, 
                        [DunId, SceneId, ScenePoolId, self()]);
                _ ->
                    skip
            end,
            State
    end.

reset_xy_help(Player, DunId, SceneId, ScenePoolId, DunPid) ->
    #player_status{dungeon = #status_dungeon{dun_id = DunId0}} = Player,
    IsOnDungeon = lib_dungeon:is_on_dungeon_ongoing(Player),
    if
        DunId0 == DunId andalso IsOnDungeon ->
            [TargetX, TargetY] = lib_scene:get_born_xy(SceneId),
            NewPlayer = lib_scene:change_scene(Player, SceneId, ScenePoolId, DunPid, TargetX, TargetY, false, []),
            {ok, NewPlayer};
        true ->
            {ok, Player}
    end.