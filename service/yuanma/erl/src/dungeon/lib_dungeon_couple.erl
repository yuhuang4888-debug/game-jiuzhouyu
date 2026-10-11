%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_couple.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-12
%% @Description:    情缘副本
%%-----------------------------------------------------------------------------

-module (lib_dungeon_couple).
-include ("dungeon.hrl").
-include ("figure.hrl").
-include ("scene.hrl").
-include ("predefine.hrl").
-include ("common.hrl").
-include ("def_goods.hrl").
-include ("def_module.hrl").
-include("def_vip.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("relationship.hrl").
-include("marriage.hrl").
-include("team.hrl").
-include("faker.hrl").

-export ([
    dunex_get_send_reward/2
    ,dunex_handle_kill_mon/4
    ,dunex_get_start_dun_args/2
    ,sex_attack_mon_born/3
    ,change_attack_sex/2
    ,hurt_check/3
    ,sex_mon_change_hp/4
    ,dunex_special_pp_handle/4
    , init_dungeon_role/3
    , dunex_check_invite_other/3
    , check_invite_other_to_dun/2
    , dungeon_result/6
    , answer_time_out/2
    , dunex_answer_dun_question/3
    , dunex_buy_count_done/4
    , do_dup_mirror_to_battle/3
    ]).

dunex_get_send_reward(#dungeon_state{result_type = ResultType}, _) when ResultType =/= ?DUN_RESULT_TYPE_SUCCESS ->
    [];

dunex_get_send_reward(#dungeon_state{dun_id = DunId} = State, DungeonRole) ->
    #dungeon_state{typical_data = TypicalData} = State,
    #dungeon_role{id = RoleId} = DungeonRole,
    Score = lib_dungeon:calc_score(State, RoleId),
    BaseRewards  = lib_dungeon_api:get_dungeon_grade(DungeonRole, DunId, Score),
    case maps:get(couple_dun_data, TypicalData, undefined) of 
        [1, _QuestionId, AnswerList, Ref|_] -> 
            is_reference(Ref) andalso util:cancel_timer(Ref),
            case AnswerList of 
                [{_RoleId1, Answer1}, {_RoleId2, Answer2}] when Answer1 == Answer2 ->
                    ?PRINT("get_send_reward double ~n", []),
                    [{?REWARD_SOURCE_DUNGEON, BaseRewards}, {?REWARD_SOURCE_DUNGEON_MULTIPLE, BaseRewards}];
                _ ->
                    ?PRINT("get_send_reward single ~n", []),
                    [{?REWARD_SOURCE_DUNGEON, BaseRewards}]
            end;
        _ ->
            [{?REWARD_SOURCE_DUNGEON, BaseRewards}]
    end;

dunex_get_send_reward(_, _) -> [].

dungeon_result(State, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList, typical_data = TypicalData, close_ref = CloseRef} = State,
    util:cancel_timer(CloseRef),
    case maps:get(couple_dun_data, TypicalData, undefined) of 
        [0, _, _AnswerList, _Ref|_] when ResultType == ?DUN_RESULT_TYPE_SUCCESS ->
            %% 获取答题信息，告诉客户端开始答题
            case data_dun_answer:get_questions_by_dun(DunId) of 
                [] -> QuestionId = 0;
                L -> 
                    [QuestionId|_] = ulists:list_shuffle(L),
                    {ok, Bin} = pt_610:write(61089, [DunId, QuestionId, 1, utime:unixtime() + 30]),
                    [ lib_server_send:send_to_uid(RoleId, Bin) || #dungeon_role{id = RoleId} <- RoleList]
            end,
            Ref = util:send_after([], 30000, self(), {apply, ?MODULE, answer_time_out, [SettlementType, ResultType, ResultSubtype, _ResultLevel, Args]}),
            DunEndArgs = [SettlementType, ResultType, ResultSubtype, _ResultLevel, Args],
            NewTypicalData = maps:put(couple_dun_data, [1, QuestionId, [], Ref, DunEndArgs], TypicalData),
            {noreply, State#dungeon_state{typical_data = NewTypicalData}};
        _ ->
            NewTypicalData = maps:put(couple_dun_data, [1, 0, [], none, []], TypicalData),
            lib_dungeon_mod:dungeon_result(State#dungeon_state{typical_data = NewTypicalData}, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args)
    end.

answer_time_out(State, [SettlementType, ResultType, ResultSubtype, _ResultLevel, Args]) ->
    {noreply, NewState} = lib_dungeon_mod:dungeon_result(State, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args),
    NewState.

dunex_answer_dun_question(State, RoleId, Answer) ->
    #dungeon_state{dun_id = DunId, role_list = RoleList, typical_data = TypicalData} = State,
    case maps:get(couple_dun_data, TypicalData, undefined) of 
        [1, QuestionId, AnswerList, Ref, [SettlementType, ResultType, ResultSubtype, _ResultLevel, Args]=DunEndArgs] -> 
            case lib_dungeon:if_answer_valid(DunId, QuestionId, Answer) of 
               false -> State;
               _ ->
                    NewAnswerList = lists:keystore(RoleId, 1, AnswerList, {RoleId, Answer}),
                    IsAllRoleAnswer = length([1 || #dungeon_role{id = RoleId1} <- RoleList, lists:keymember(RoleId1, 1, NewAnswerList) == false]) == 0,
                    NewRef = ?IF(IsAllRoleAnswer == true, none, Ref),
                    IsAllRoleAnswer andalso util:cancel_timer(Ref),
                    NewTypicalData = maps:put(couple_dun_data, [1, QuestionId, NewAnswerList, NewRef, DunEndArgs], TypicalData),
                    NewState = State#dungeon_state{typical_data = NewTypicalData},
                    case IsAllRoleAnswer of 
                        true ->
                            MergeAnswer = lists:umerge([[AnswerTmp] || {_, AnswerTmp} <- NewAnswerList]),
                            SameAnswer = ?IF(length(MergeAnswer) == 1, 2, 3),
                            {ok, Bin1} = pt_610:write(61090, [SameAnswer]),
                            [lib_server_send:send_to_uid(RoleId1, Bin1) || #dungeon_role{id = RoleId1} <- RoleList],
                            {ok, Bin} = pt_610:write(61089, [DunId, QuestionId, 2, 0]),
                            [lib_server_send:send_to_uid(RoleId1, Bin) || #dungeon_role{id = RoleId1} <- RoleList],
                            {noreply, LastState} = lib_dungeon_mod:dungeon_result(NewState, SettlementType, ResultType, ResultSubtype, _ResultLevel, Args),
                            LastState; 
                        _ ->
                            NewState
                    end       
            end;
        _E ->
            State
    end.

dunex_handle_kill_mon(State, _MonId, _CreateKey, _DieDatas) -> State.
    % #dungeon_state{dun_id  =DunId, typical_data = TypicalData} = State,
    % case data_dungeon_special:get(DunId, mon_group) of
    %     undefined ->
    %         ok;
    %     List ->
    %         case lists:keyfind(MonId, 2, List) of
    %             {Time, MonId, PartnerId} ->
    %                 ok;
    %             _ ->
    %                 case lists:keyfind(MonId, 3, List) of
    %                     {Time, PartnerId, MonId} ->
    %                         ok;
    %                     _ ->
    %                         Time = PartnerId = 0
    %                 end
    %         end,
    %         if
    %             PartnerId =:= 0 ->
    %                 ok;
    %             true ->
    %                 case maps:find({?DUN_STATE_SPCIAL_KEY_MON_REVIVE, PartnerId}, TypicalData) of
    %                     {ok, ReviveRef} ->
    %                         util:cancel_timer(ReviveRef),
    %                         NewTypicalData = maps:remove({?DUN_STATE_SPCIAL_KEY_MON_REVIVE, PartnerId}, TypicalData),
    %                         State#dungeon_state{typical_data = NewTypicalData};
    %                     _ ->
    %                         ReviveRef = erlang:send_after(Time * 1000, self(), {revive_mon, MonId, CreateKey}),
    %                         NewTypicalData = TypicalData#{{?DUN_STATE_SPCIAL_KEY_MON_REVIVE, MonId} => ReviveRef},
    %                         State#dungeon_state{typical_data = NewTypicalData}
    %                 end
    %         end
    % end.

dunex_get_start_dun_args(_, #dungeon{id = _DunId}) ->
    [{typical_data,
        [
        {couple_dun_data, [0, 0, [], none, []]}
        ]
    }].
    % case data_dungeon_special:get(DunId, sex_attack_mons) of
    %     undefined ->
    %         [];
    %     List ->
    %         ReplaceMons = [{MonId, MonId, 
    %                                       [
    %                                         {born_handler, {?MODULE, sex_attack_mon_born, [Time, Sex]}}, 
    %                                         {hp_change_handler, {?MODULE, sex_mon_change_hp, lists:reverse(lists:sort(HPList))}},
    %                                         {hurt_check, {?MODULE, hurt_check, [Sex]}}
    %                                       ]
    %                         } 
    %         || {MonId, Time, Sex, HPList} <- List],
    %         TypicalArgs = {?DUN_STATE_SPCIAL_KEY_REPLACE_MON, ReplaceMons},
    %         [{typical_data, [TypicalArgs]}]
    % end.

sex_mon_change_hp(SceneObject, Hp, _Klist, [Hp1|T]) ->
    if
        Hp < Hp1 ->
            #scene_object{id = Id, copy_id = CopyId, mon = #scene_mon{create_key = CreateKey}, config_id = MonId} = SceneObject,
            MonPid = self(), %% 这个函数在怪物进程执行
            CopyId ! {apply, ?MODULE, change_attack_sex, [CreateKey, MonPid, Id, MonId]},
            HPList = [H || H <- T, H < Hp],
            {ok, HPList};
        true ->
            skip
    end;
sex_mon_change_hp(_, _, _, []) -> stop.

sex_attack_mon_born(_, SceneObject, [Time, Sex]) ->
    #scene_object{id = Id, copy_id = CopyId, mon = #scene_mon{create_key = CreateKey}, config_id = MonId} = SceneObject,
    % NewSex = if Sex =:= ?MALE -> ?FEMALE; true -> ?MALE end,
    MonPid = self(), %% 这个函数在怪物进程执行
    CopyId ! {apply, ?MODULE, change_attack_sex, [Time, Sex, CreateKey, MonPid, Id, MonId]}.
    % erlang:send_after(Time * 1000, CopyId, {apply, ?MODULE, change_attack_sex, [Time, Sex, CreateKey, MonPid, Id, MonId]}).

% sex_mon_born(State, [Time, Sex, CreateKey, MonPid, Id, MonId]) ->
%     #dungeon_state{typical_data = TypicalData} = State,
%     ChangeSexMap = maps:get(?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON, TypicalData, #{}),
%     MonMap = maps:get(MonId, ChangeSexMap, #{}),
%     NewMonMap = MonMap#{Id => Sex},
%     NewChangeSexMap = ChangeSexMap#{MonId => NewMonMap},
%     NewTypicalData = TypicalData#{?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON => NewChangeSexMap},
%     NewState = State#dungeon_state{typical_data = NewTypicalData},
%     change_attack_sex(NewState, [Time, Sex, CreateKey, MonPid, Id, MonId]).

change_attack_sex(State, [CreateKey, MonPid, Id, MonId]) ->
    case lib_dungeon_mon_event:is_alive_mon_on_common_event(State, CreateKey) of
        true ->
            #dungeon_state{typical_data = TypicalData} = State,
            case maps:find(?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON, TypicalData) of
                {ok, ChangeSexMap} ->
                    case maps:find(MonId, ChangeSexMap) of
                        {ok, #{Id := Sex} = MonMap} ->
                            NewSex = if Sex =:= ?MALE -> ?FEMALE; true -> ?MALE end,
                            MonPid ! {'change_attr', [{hurt_check, {?MODULE, hurt_check, [NewSex]}}]},
                            NewMonMap = MonMap#{Id => NewSex},
                            NewChangeSexMap = ChangeSexMap#{MonId => NewMonMap},
                            NewTypicalData = TypicalData#{?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON => NewChangeSexMap},
                            NewState = State#dungeon_state{typical_data = NewTypicalData},
                            NewState;
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end;


change_attack_sex(State, [Time, Sex, CreateKey, MonPid, Id, MonId]) ->
    case lib_dungeon_mon_event:is_alive_mon_on_common_event(State, CreateKey) of
        true ->
            NewSex = if Sex =:= ?MALE -> ?FEMALE; true -> ?MALE end,
            MonPid ! {'change_attr', [{hurt_check, {?MODULE, hurt_check, [NewSex]}}]},
            erlang:send_after(Time * 1000, self(), {apply, ?MODULE, change_attack_sex, [Time, NewSex, CreateKey, MonPid, Id, MonId]}),
            #dungeon_state{typical_data = TypicalData} = State,
            ChangeSexMap = maps:get(?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON, TypicalData, #{}),
            MonMap = maps:get(MonId, ChangeSexMap, #{}),
            NewMonMap = MonMap#{Id => Sex},
            NewChangeSexMap = ChangeSexMap#{MonId => NewMonMap},
            NewTypicalData = TypicalData#{?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON => NewChangeSexMap},
            NewState = State#dungeon_state{typical_data = NewTypicalData},
            lib_dungeon_mod:send_msg(NewState, pack_61098_data(NewState)),
            NewState;
        _ ->
            skip
    end.

hurt_check(AttUser, _, [Sex]) ->
    case AttUser of
        #ets_scene_user{figure = #figure{sex = Sex}} ->
            true;
        _ ->
            false
    end.

dunex_special_pp_handle(State, Sid, 61098, []) ->
    lib_server_send:send_to_sid(Sid, pack_61098_data(State));

dunex_special_pp_handle(_State, _, _, _) ->
    ok.

pack_61098_data(State) ->
    #dungeon_state{typical_data = TypicalData} = State,
    DataList
    = case maps:find(?DUN_STATE_SPCIAL_KEY_CHANGE_SEX_MON, TypicalData) of
        {ok, ChangeSexMap} ->
            [{Id, MonId, Sex} || {MonId, MonMap} <- maps:to_list(ChangeSexMap), {Id, Sex} <- maps:to_list(MonMap)];
        _ ->
            []
    end,
    {ok, BinData} = pt_610:write(61098, [DataList]),
    BinData.

init_dungeon_role(#player_status{id = _RoleId} = _Player, #dungeon{count_cond = _CountCond, type = _DunType, id = _DunId}, Role) ->
    % RewardCount = case lists:keyfind(?DUN_COUNT_COND_DAILY_REWARD, 1, CountCond) of
    %     {_, Max} ->
    %         CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    %         VipFreeCount = lib_vip_api:get_vip_privilege(Player, ?MOD_DUNGEON, ?VIP_DUNGEON_ENTER_RIGHT_ID(CountType)),
    %         AddCountType = lib_dungeon_api:get_daily_add_type(DunType, DunId),
    %         DataList = [{?MOD_DUNGEON, ?MOD_DUNGEON_BUY, CountType},
    %         {?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType},
    %         {?MOD_DUNGEON, ?MOD_DUNGEON_ADD_COUNT, AddCountType}],
    %         case mod_daily:get_count(RoleId, DataList) of
    %             [{_, BuyCount}, {_, Num}, {_, AddCount}] ->
    %                 max(0, Max + BuyCount + VipFreeCount + AddCount - Num);
    %              _ ->
    %                 0
    %         end;
    %     _ -> 0
    % end,
    Role.

dunex_buy_count_done(Player, Dun, _VipBuyCount, Count) ->
    #player_status{marriage = #marriage_status{lover_role_id = LoverId}} = Player,
    #dungeon{id = DunId} = Dun,
    case LoverId > 0 of 
        false -> skip;
        _ ->
            case lib_player:get_alive_pid(LoverId) of 
                false -> 
                    lib_dungeon:add_dungeon_count_offline(LoverId, DunId, Count);
                Pid -> 
                    lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, lib_dungeon, add_dungeon_count, [DunId, Count])
            end
    end.


dunex_check_invite_other(Player, Dun, OtherId) ->
    MyTeamId = Player#player_status.team#status_team.team_id,
    case MyTeamId > 0 of 
        true ->
            {false, ?ERRCODE(err172_in_team_dungeon)};
        _ ->
            case lib_player:get_alive_pid(OtherId) of 
                false ->
                    %% 按策划要求，情缘副本支持伴侣镜像
                    %% {false, ?ERRCODE(err240_other_offline)};
                    {true, other_no_online};
                Pid ->
                    case lib_role:is_role_real_online(OtherId) of
                        false ->
                            %% {false, ?ERRCODE(err240_other_offline)},
                            {true, other_no_online};
                        true ->
                            MySex = Player#player_status.figure#figure.sex,
                            LoverId = Player#player_status.figure#figure.lover_role_id,
                            case lib_player:apply_call(Pid, ?APPLY_CALL_SAVE, ?MODULE, check_invite_other_to_dun, [Dun]) of
                                {true, OtherSex} ->
                                    case MySex =/= OtherSex orelse OtherId == LoverId of
                                        true -> true;
                                        _ ->
                                            FriendList = lib_relationship:get_relas_by_types(Player#player_status.id, ?RELA_TYPE_FRIEND),
                                            IntimacyNeed = ?IntimacyDunNeed,
                                            case lists:keyfind(OtherId, #rela.other_rid, FriendList) of
                                                #rela{intimacy = Intimacy} when Intimacy>=IntimacyNeed -> true;
                                                _ -> {false, ?ERRCODE(err172_dun_intimacy_not_enough)}
                                            end
                                    end;
                                {false, Res} -> {false, Res};
                                _Err -> {false, ?FAIL}
                            end
                    end
            end
    end.

check_invite_other_to_dun(Player, Dun) ->
    MyTeamId = Player#player_status.team#status_team.team_id,
    case MyTeamId > 0 of 
        true -> {{false, ?ERRCODE(err172_other_in_team_dungeon)}, Player};
        _ ->
            case lib_dungeon_check:enter_dungeon(Player, Dun, ?DUN_CREATE) of
                true ->
                    Sex = Player#player_status.figure#figure.sex,
                    {{true, Sex}, Player};
                {false, Code} -> 
                    Name = Player#player_status.figure#figure.name,
                    CodeMsg = util:make_error_code_msg(Code),
                    {{false, {?ERRCODE(err240_me_to_other), [Name, CodeMsg]}}, Player}
            end
    end.

%% 制作伴侣的镜像参与情缘副本的战斗
do_dup_mirror_to_battle(Player, DunId, OtherId) ->
    #player_status{id = PlayerId} = Player,
    Dun = data_dungeon:get(DunId),
    case lib_dungeon_check:enter_dungeon(Player, Dun, ?DUN_CREATE) of
        true ->
            DungeonRole = lib_dungeon:trans_to_dungeon_role(Player, Dun),
            StartArgs = lib_dungeon:get_start_dun_args(Player, Dun),
            DunPid = mod_dungeon:start(0, self(), DunId, [DungeonRole], StartArgs),
            %% 获取伴侣的属性和外观等,
            FakeInfo = lib_faker:create_faker_by_role(OtherId),
            #faker_info{
                server_id = FakeServerId, server_num = FakeServerNum, figure = FakeFigure,
                active_skills = FakeSkills, passive_skills = PassiveSkills, battle_attr = BattleAttr
            } = FakeInfo,
            FixFigure = [{FakeServerId, FakeServerNum, FakeFigure, 2}],
            mod_dungeon:apply(DunPid, lib_team_dungeon_mod, create_dummy, {FixFigure, BattleAttr, FakeSkills ++ PassiveSkills, 0}),
            lib_player:soft_action_lock(Player, ?ERRCODE(err610_had_on_dungeon));
        {false, Code} ->
            CodeMsg = util:make_error_code_msg(Code),
            lib_server_send:send_to_sid(Player#player_status.sid, pt_610, 61046, [CodeMsg]),
            lib_dungeon:report_invite_result_msg(4, PlayerId, #figure{}, OtherId, #figure{}, DunId),
            Player
    end.