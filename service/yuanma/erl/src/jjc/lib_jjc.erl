%%%------------------------------------
%%% @Module  : lib_jj
%%% @Author  :  fwx
%%% @Created :  2017-11-20
%%% @Description: jjc
%%%------------------------------------
-module(lib_jjc).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("jjc.hrl").
-include("def_module.hrl").
-include("role.hrl").
-include("hero_halo.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("faker.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").

%% 登录
get_honour(RoleId) ->
    %% 获取荣誉值
    case db:get_row(io_lib:format(?sql_select_db_honour, [RoleId])) of
        [] -> 0;
        [RoleId, Honour] -> Honour
    end.

%% 登录
load_status_jjc(RoleId) ->
    case db_role_jjc_select(RoleId) of
        [BreakIdListBin] -> BreakIdList = util:bitstring_to_term(BreakIdListBin);
        [] -> BreakIdList = []
    end,
    #status_jjc{break_id_list = BreakIdList}.

%% 挑战对手  后续增加场景判断
challenge_image_role(Player, SelfRank, RivalId, RivalRank, Skills, ChallengeType) ->
    #player_status{sid = Sid, id = RoleId, combat_power = SelCombat, figure = Figure} = Player,
    case do_check_challenge_lv(Player) of
        true ->
            % SelCombat = get_inspire_combat(RoleId, Combat),
            case RivalId of  %% 0 为假人
                0 -> RivalCombat = 0;
                _ ->
                    case lib_role:get_role_show(RivalId) of
                        [] -> TmpCombat = 0;
                        #ets_role_show{combat_power = TmpCombat} -> skip
                    end,
                    %%?PRINT("~p,~p,~p~n", [Percent, RivalId, TmpCombat]),
                    % RivalCombat = get_inspire_combat(RivalId, TmpCombat)
                    RivalCombat = TmpCombat
            end,
            SelfImage = #image_role{
                rank      = SelfRank,
                role_info = #faker_info{ % 临时构造，检查需要
                    role_id      = RoleId,
                    figure       = Figure,
                    combat_power = SelCombat
            }},
            RivalImage = #image_role{
                rank      = RivalRank,
                role_info = #faker_info{ % 临时构造，检查需要
                    role_id      = RivalId,
                    combat_power = RivalCombat
            }},
            ChallengeTimes = lib_hero_halo:calc_jjc_challenge_times(Player, ChallengeType),
            ChallengeRole = #challenge_role{
                self_image  = SelfImage,
                rival_image = RivalImage,
                challenge_times = ChallengeTimes
            },
            % ?PRINT("Embattle:~p ~n", [ChallengeRole]),
            if
                (SelfRank > 10 orelse SelfRank == 0) andalso RivalRank =< 3 ->
                    NewPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_280, 28000, [?ERRCODE(err280_rank_limit_not_to_battle)]);
                SelfRank == RivalRank ->
                    NewPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_280, 28000, [?ERRCODE(err280_not_battle_myslef)]);
                SelfRank < RivalRank, SelfRank /= 0, ChallengeType == 1 ->
                    NewPlayer1 = Player,
                    mod_jjc:cast_to_jjc(right_now_clear, [ChallengeRole]),
                    CallbackData = #callback_join_act{type = ?MOD_JJC, times = ChallengeTimes},
                    {ok, NewPlayer} = lib_player_event:dispatch(NewPlayer1, ?EVENT_JOIN_ACT, CallbackData);
                ChallengeType == 1 ->
                    NewPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_280, 28000, [?ERRCODE(err280_can_not_direct_battle)]);
                true ->
                    case lib_player_check:check_all(Player) of
                        true ->
                            NewPlayer1 = lib_player:soft_action_lock(Player, ?ERRCODE(err280_on_battle_state)),
                            mod_jjc:cast_to_jjc(create_battle, [ChallengeRole, Skills]),
                            CallbackData = #callback_join_act{type = ?MOD_JJC, times = ChallengeTimes},
                            {ok, NewPlayer} = lib_player_event:dispatch(NewPlayer1, ?EVENT_JOIN_ACT, CallbackData);
                        {false, ErrCode} ->
                            NewPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_280, 28000, [ErrCode])
                    end
            end;
        {false, ErrCode} ->
            NewPlayer = Player,
            lib_server_send:send_to_sid(Sid, pt_280, 28000, [ErrCode])
    end,
    {ok, NewPlayer}.

%%--------------------------------------%%
alter_rand(A, B) ->
    ?IF(A > B, urand:rand(B, A), urand:rand(A, B)).

%% 计算鼓舞战力
get_inspire_combat(RoleId, Combat) ->
    InspireNum = mod_daily:get_count_offline(RoleId, ?MOD_JJC, ?JJC_INSPIRE_NUM),
    case data_jjc:get_inspire_cfg(InspireNum) of
        #jjc_inspire_cfg{percent = Percent} -> skip;
        _ -> Percent = 0
    end,
    Combat + round(Combat * Percent / ?HUNDRED_PERCENT).

%% 获得假人战力
get_robot_combat(Rank) ->       %% 公式
    MaxRank = case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
                  [] -> 99999;
                  [TmpMaxRank] -> TmpMaxRank
              end,
    if
        Rank > 0 andalso Rank =< 1000 ->
            (MaxRank - Rank) * 200 + 10000;
        Rank > 1000 andalso Rank =< 2000 ->
            (MaxRank - Rank) * 100 + 10000;
        true ->
            (MaxRank - Rank) * 50 + 10000
    end.

%% 获取血量
get_hp(Combat) ->
    Combat * 20.

%% 战后奖励（经验，荣誉值）
%% 经验 y=415,000*1.5^((x-170)/50)
%% 输为赢得一半
% get_challenge_reward(Result, Lv) ->
%     Exp = round(415000 * math:pow(1.5, (Lv - 170) / 50)),
%     Honour = 150,
%     case Result of
%         ?JJC_FAIL ->
%             Reward = [{?TYPE_EXP, 0, round(Exp * 0.5)}, {?TYPE_HONOUR, 0, round(Honour * 0.5)}];
%         ?JJC_WIN ->
%             Reward = [{?TYPE_EXP, 0, Exp}, {?TYPE_HONOUR, 0, Honour}]
%     end,
%     Reward.
get_challenge_reward(Result, Lv) ->
    case data_jjc:get_jjc_challenge_reward(Lv) of
        % #base_jjc_challenge_reward{exp = Exp, honour = Honour, fail_ratio = FailRatio} ->
        %     case Result of
        %         ?JJC_FAIL -> [{?TYPE_EXP, 0, round(Exp * FailRatio)}, {?TYPE_HONOUR, 0, round(Honour * FailRatio)}];
        %         ?JJC_WIN -> [{?TYPE_EXP, 0, Exp}, {?TYPE_HONOUR, 0, Honour}]
        %     end;
        #base_jjc_challenge_reward{win_reward = WinReward, lose_reward = LoseReward} ->
            case Result of
                ?JJC_FAIL -> LoseReward;
                ?JJC_WIN -> WinReward
            end;
        _ ->
            []
    end.

%% 检查竞技所需等级
do_check_challenge_lv(Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case data_jjc:get_jjc_value(?JJC_CONFIG_LV) of
        [] -> MinLv = 0;
        [MinLv] -> ok
    end,
    if
        Lv < MinLv -> {false, ?ERRCODE(err280_lv_not_enough)};
        true -> true
    end.

timer_reward() ->
    mod_jjc:cast_to_jjc(refresh_reward, []).


%% 加荣誉值
add_honour(Player, Num) ->
    #player_status{id = RoleId, jjc_honour = Honour} = Player,
    NewHonour = Honour + Num,
    db:execute(io_lib:format(?sql_replace_db_jjc_honour, [RoleId, NewHonour])),
    NewPs = Player#player_status{jjc_honour = NewHonour},
    send_honour_to_client(NewPs),
    NewPs.

cost_honour(PlayerStatus, Cost, MoneyType, Type, About) ->
    NewPlayerStatus1 = cost_honour(PlayerStatus, Cost, MoneyType),
    if
        Type =/= [] andalso Type =/= none ->
            %% 日志
            lib_log_api:log_cost_honour(Type, PlayerStatus, NewPlayerStatus1, About);
        true -> skip
    end,
    NewPlayerStatus1.

cost_honour(Player, Cost, _MoneyType) ->
    #player_status{id = Id, sid = _Sid, jjc_honour = Honour} = Player,
    NewPlayerStatus = Player#player_status{jjc_honour = NewHonour = (Honour - Cost)},
    Sql = io_lib:format(?sql_replace_db_jjc_honour, [Id, NewHonour]),
    db:execute(Sql),
    send_honour_to_client(NewPlayerStatus),
    NewPlayerStatus.


get_db_real_role(RoleId) ->
    case db:get_row(io_lib:format(?sql_select_real_role_by_id, [RoleId])) of
        [Rank, HistoryRank, IsReward, RewardRank] ->
            Sql = io_lib:format(?sql_select_db_challenge_record, [RoleId]),
            TmpRecordL = lists:foldl(
                fun([Time, RivalId, RivalName, RivalCareer, RivalSex, RivalTurn, RivalVipType, RivalVipLv, RivalLv, RivalCombat, Result, RankRange], TmpRL) ->
                    TmpRecord = #challenge_record{
                        role_id = RoleId,
                        time = Time,
                        rival_id = RivalId,
                        rival_name  = RivalName,
                        rival_career = RivalCareer,
                        rival_sex   = RivalSex,
                        rival_turn  = RivalTurn,
                        rival_vip_type = RivalVipType,
                        rival_vip_lv = RivalVipLv,
                        rival_lv    = RivalLv,
                        rival_combat = RivalCombat,
                        result = Result,
                        rank_change = RankRange},
                    [TmpRecord | TmpRL]
                end, [], db:get_all(Sql)),
            % 根据时间戳排序
            case TmpRecordL of
                [] -> RecordL = [];
                _ ->
                    RecordL = lists:sort(
                        fun(A, B) ->
                            if
                                is_record(A, challenge_record) ->
                                    if
                                        A#challenge_record.time > B#challenge_record.time -> true;
                                        true -> false
                                    end;
                                true -> false
                            end
                        end, TmpRecordL)
            end,
            #real_role{
                role_id      = RoleId,
                rank         = Rank,                    %% 排名
                history_rank = HistoryRank,         %% 历史排名
                record       = RecordL,
                is_reward    = IsReward,
                reward_rank  = RewardRank
            };
        _ -> #real_role{role_id = RoleId}
    end.

create_fake_battle(Player, _RoleSkils, ChallengeRole) ->
    #player_status{id = RoleId, jjc_battle_pid = OldBattlePid} = Player,
    case misc:is_process_alive(OldBattlePid) of
        true ->
            BattlePid = undefined,
            NewPlayer = Player;
        false ->
            #challenge_role{
                self_image  = #image_role{rank = SelfRank},
                rival_image = #image_role{rank = RivalRank}
            } = ChallengeRole,

            case catch mod_battle_field:start(lib_jjc_battle, [fake_man, ChallengeRole]) of
                BattlePid when is_pid(BattlePid) ->
                    NewPlayer = battle_field_create_done(Player, BattlePid, RoleId);
                _ ->
                    mod_jjc:cast_to_jjc(set_battle_status, [[SelfRank, RivalRank], ?NOT_BATTLE_STATUS]),
                    BattlePid = undefined,
                    NewPlayer = battle_field_close(Player, init_error)
            end
    end,
    {ok, NewPlayer#player_status{jjc_battle_pid = BattlePid}}.

% create_fake_battle(Player, RivalId, _RoleSkils, SelfCombat, RivalCombat, RivalFigure, SelfRank, RivalRank) ->
%     #player_status{id = RoleId, figure = RoleFigure, jjc_battle_pid = OldBattlePid, battle_attr = RoleBattleAttr} = Player,
%     case misc:is_process_alive(OldBattlePid) of
%         true ->
%             BattlePid = undefined,
%             NewPlayer = Player;
%         false ->
%             %% TODO 获取真实的 BA
%             %% 根据战力来计算所属性
%             SlefAttr = mod_jjc_cast:get_robot_attr(SelfCombat),
%             RoleBattleAttr = #battle_attr{hp=SlefAttr#attr.hp, hp_lim=SlefAttr#attr.hp, attr=SlefAttr},
%             RoleSkills = data_skill:get_ids(RoleFigure#figure.career, RoleFigure#figure.sex),
%             %% TODO 获取真实的BA
%             RivalAttr = mod_jjc_cast:get_robot_attr(RivalCombat),
%             RivalBattleAttr = #battle_attr{hp=RivalAttr#attr.hp, hp_lim=RivalAttr#attr.hp, attr=RivalAttr},
%             if
%                 RivalId == 0 ->
%                     #figure{career = Career, sex = Sex} = RivalFigure,
%                     RivalSkills = data_skill:get_ids(Career, Sex);
%                 true ->
%                     #figure{career = Career, sex = Sex} = RivalFigure,
%                     RivalSkills = data_skill:get_ids(Career, Sex)
%             end,
%             %[AAA] = lib_offline_api:get_player_info(RoleId, [ #player_status.battle_attr]),
%             RoleFakeData = [RoleFigure, RoleBattleAttr, RoleSkills],
%             RivalFakeData = [RivalFigure, RivalBattleAttr, RivalSkills],
%             case catch mod_battle_field:start(lib_jjc_battle, [RoleId, RivalId, fake_man, RoleFakeData, RivalFakeData, SelfRank, RivalRank]) of
%                 BattlePid when is_pid(BattlePid) ->
%                     NewPlayer = battle_field_create_done(Player, BattlePid, RoleId);
%                 _ ->
%                     mod_jjc:cast_to_jjc(set_battle_status, [[SelfRank, RivalRank], ?NOT_BATTLE_STATUS]),
%                     BattlePid = undefined,
%                     NewPlayer = battle_field_close(Player, init_error)
%             end
%     end,
%     {ok, NewPlayer#player_status{jjc_battle_pid = BattlePid}}.

battle_field_create_done(Player, BattlePid, RoleId) ->
    #player_status{
        sid           = _Sid,
        scene         = OSceneId,
        scene_pool_id = OPoolId,
        copy_id       = OCopyId,
        x             = X,
        y             = Y,
        battle_attr   = #battle_attr{hp = Hp, hp_lim = HpLim}
    } = Player,
    NewPlayer = lib_player:setup_action_lock(Player, ?ERRCODE(err280_on_battle_state)),
    Args = [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim],
    mod_battle_field:player_enter(BattlePid, RoleId, Args),
    NewPlayer.

battle_field_close(Player, _Resaon) ->
    lib_player:break_action_lock(Player, ?ERRCODE(err280_on_battle_state)).


send_honour_to_client(#player_status{jjc_honour =  Honour, sid =  Sid}) ->
%%    ?MYLOG("cym",  "carlos  ~p~n ",  [ Honour]),
    lib_server_send:send_to_sid(Sid, pt_280, 28010, [?SUCCESS, Honour]).

%% -------------------------------------------------
%% 领取阶段奖励
%% -------------------------------------------------

%% 获取突破奖励
handle_get_break_reward(Player, HistoryRank, BreakId) ->
    case check_handle_get_break_reward(Player, HistoryRank, BreakId) of
        {false, ErrCode} -> PlayerAfReward = Player, Reward = [];
        {true, RankId, Reward} ->
            ErrCode = ?SUCCESS,
            #player_status{id = RoleId, jjc = StatusJjc} = Player,
            #status_jjc{break_id_list = BreakIdList} = StatusJjc,
            NewBreakIdList = [BreakId|BreakIdList],
            NewStatusJjc = StatusJjc#status_jjc{break_id_list = NewBreakIdList},
            db_role_jjc_replace(RoleId, NewStatusJjc),
            PlayerAfSave = Player#player_status{jjc = NewStatusJjc},
            Produce = #produce{type = jjc_break_reward, reward = Reward, remark = BreakId},
            PlayerAfReward = lib_goods_api:send_reward(PlayerAfSave, Produce),
            lib_log_api:log_jjc_break_rank(RoleId, BreakId, RankId, Reward)
    end,
    ?PRINT("HistoryRank:~p, RankId:~p ErrCode:~p~n", [HistoryRank, BreakId, ErrCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_280, 28017, [ErrCode, BreakId, Reward]),
    {ok, PlayerAfReward}.

check_handle_get_break_reward(Player, HistoryRank, BreakId) ->
    #player_status{jjc = StatusJjc} = Player,
    #status_jjc{break_id_list = BreakIdList} = StatusJjc,
    IsMember = lists:member(BreakId, BreakIdList),
    BaseBreakReward = data_jjc:get_break_reward_cfg(BreakId),
    if
        IsMember -> {false, ?ERRCODE(err280_had_reward)};
        HistoryRank == 0 -> {false, ?ERRCODE(err280_have_not_reward)};
        is_record(BaseBreakReward, jjc_reward_break_cfg) == false -> {false, ?MISSING_CONFIG};
        BaseBreakReward#jjc_reward_break_cfg.rank < HistoryRank -> {false, ?ERRCODE(err280_have_not_reward)};
        true ->
            #jjc_reward_break_cfg{rank = RankId, reward = Reward} = BaseBreakReward,
            case lib_goods_do:can_give_goods(Reward) of
                {false, ErrorCode} -> {false, ErrorCode};
                true -> {true, RankId, Reward}
            end
    end.

%% 获取玩家竞技场信息
db_role_jjc_select(RoleId) ->
    Sql = io_lib:format(?sql_role_jjc_select, [RoleId]),
    db:get_row(Sql).

%% 保存玩家竞技场信息
db_role_jjc_replace(RoleId, StatusJjc) ->
    #status_jjc{break_id_list = BreakIdList} = StatusJjc,
    Sql = io_lib:format(?sql_role_jjc_replace, [RoleId, util:term_to_string(BreakIdList)]),
    db:execute(Sql).

%% 输出
gm_sql_break_id_list() ->
    BreakIdList = data_jjc:get_break_reward_id_list(),
    % Str = "update role_jjc jjc,jjc_real_role role set jjc.break_id_list = '~s' where jjc.role_id = role.role_id and role.history_rank <= ~p;\n",
    F = fun(BreakId, Str) ->
        #jjc_reward_break_cfg{rank = RankId} = data_jjc:get_break_reward_cfg(BreakId),
        F2 = fun(TmpBreakId) ->
            #jjc_reward_break_cfg{rank = TmpRankId} = data_jjc:get_break_reward_cfg(TmpBreakId),
            TmpRankId >= RankId
        end,
        TmpBreakIdList = lists:filter(F2, BreakIdList),
        lists:concat([Str, "update role_jjc jjc, jjc_real_role role set jjc.break_id_list = \\'", util:term_to_string(TmpBreakIdList),
            "\\' where jjc.role_id = role.role_id and role.history_rank > 0 and role.history_rank <= ", RankId, ";\n"])
    end,
    Str = lists:foldl(F, "", lists:reverse(BreakIdList)),
    lib_log_api:log_attr(1, 1, 1, Str),
    ?INFO("~p ~n", [Str]).
