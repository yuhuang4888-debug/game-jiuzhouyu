%%%------------------------------------
%%% @Module  : mod_jjc_cast
%%% @Author  :  xiaoxiang
%%% @Created :  2017-03-23
%%% @Description: jjc
%%%------------------------------------
-module(mod_jjc_cast).
-export([]).

-compile(export_all).

-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("jjc.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("role.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("reincarnation.hrl").
-include("mount.hrl").
-include("counter.hrl").
-include("attr.hrl").
-include("server.hrl").
-include("faker.hrl").

% 获取玩家jjc信息
get_jjc_role(State, RoleId, _Figure, SelCombat, Honour, PetId, BreakIdList) ->
    %% 鼓舞处理的战力
    Combat = lib_jjc:get_inspire_combat(RoleId, SelCombat),
    {JJCNum, RefreshTime} = get_challenge_num(RoleId),
    #real_role{rank = Rank, history_rank = HistoryRank, is_reward = IsReward, reward_rank = RewardRank} = get_real_role(State, RoleId),
    %% 客户端显示用血量
    Hp = lib_jjc:get_hp(Combat),
    LastRewardRank = ?IF(IsReward == ?JJC_HAVE_NOT_REWARD, Rank, RewardRank),
    % ?PRINT("~p ~n", [{Rank, HistoryRank, Combat, Hp, JJCNum, Honour, IsReward, PetId}]),
    NewBreakIdList = [BreakId||BreakId<-BreakIdList, lists:member(BreakId, data_jjc:get_break_reward_id_list())],
    lib_server_send:send_to_uid(RoleId, pt_280, 28001, [Rank, HistoryRank, LastRewardRank, Combat, Hp, JJCNum, RefreshTime, Honour, IsReward, PetId, NewBreakIdList]),
    State.

%% 获得剩余的次数, 挑战次数 = 最大次数 - 今日使用次数
%% @return {当前次数, 刷新时间}
get_challenge_num(RoleId) ->
    [MaxNum] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
    ChallengeNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_CHALLENGE_NUM),
    {MaxNum - ChallengeNum, 0}.
%%    case data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX) of
%%        [] -> MaxNum = 0;
%%        [MaxNum] -> ok
%%    end,
%%    [ResumeTime] = data_jjc:get_jjc_value(?JJC_COUNT_RESUME_TIME),
%%    case mod_counter:get(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_CHALLENGE_NUM) of
%%        false -> Count = 0, RefreshTime = 0;
%%        #ets_counter{count = Count, refresh_time = RefreshTime} -> ok
%%    end,
%%    NowTime = utime:unixtime(),
%%    Elapse = NowTime - RefreshTime,
%%    if
%%        Count >= MaxNum -> {Count, NowTime};
%%        Elapse < ResumeTime -> {Count, RefreshTime};
%%        true ->
%%            ResumeCount = Elapse div ResumeTime,
%%            Count2 = min(Count + ResumeCount, MaxNum),
%%            RefreshTime2 = RefreshTime + ResumeCount * ResumeTime,
%%            case Count2 >= MaxNum of
%%                true -> {Count2, NowTime};
%%                false -> {Count2, RefreshTime2}
%%            end
%%    end.

%% 处理减少次数的逻辑
handle_decrement_challenge_num(RoleId, ChallengeTimes) ->
    mod_daily:plus_count(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_CHALLENGE_NUM, ChallengeTimes),
    %% 我要变强
    [MaxNum] = data_jjc:get_jjc_value(?JJC_FREE_NUM_MAX),
    ChallengeNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_CHALLENGE_NUM),
    MaxNum - ChallengeNum == 0 andalso
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_to_be_strong, update_data_jjc, []),
%%    {Count, RefreshTime} = get_challenge_num(RoleId),
%%    NewCount = max(Count - 1, 0),
%%    mod_counter:set_count(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_CHALLENGE_NUM, NewCount, RefreshTime),
%%    mod_daily:increment(RoleId, ?MOD_JJC, ?JJC_USE_NUM),
    ok.

%% 增加挑战次数
plus_challenge_num(RoleId, AddCount) ->
    ChallengeNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?JJC_CHALLENGE_NUM),
    NewChallengeNum = ChallengeNum - AddCount, %max(ChallengeNum - AddCount, 0),
    mod_daily:set_count(RoleId, ?MOD_JJC, ?JJC_CHALLENGE_NUM, NewChallengeNum),
%%    {Count, RefreshTime} = get_challenge_num(RoleId),
%%    NewCount = Count + AddCount,
%%    mod_counter:set_count(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_CHALLENGE_NUM, NewCount, RefreshTime),
    ok.

%% 随机对手
random_rival_role(State, RoleId, Combat) ->
    #real_role{rank = Rank} = get_real_role(State, RoleId),
    %% [#image_role]
    List = do_random_rival(State, Rank, RoleId, Combat),
    F = fun(ImageRole, TempList) ->
        #image_role{rank = RivalRank, role_info = FakerInfo} = ImageRole,
        #faker_info{
            role_id      = RivalId,     figure      = TmpFigure,
            combat_power = RivalCombat, battle_attr = #battle_attr{hp = Hp}
        } = FakerInfo,
        Figure = ?IF(is_record(TmpFigure, figure), TmpFigure, #figure{}),
        PetId = Figure#figure.lb_pet_figure,
        % ?PRINT("Figure RivalId:~p RivalRank:~p, MountFigure:~w ~n", [RivalId, RivalRank, Figure#figure.mount_figure]),
        [{RivalRank, RivalId, RivalCombat, Hp, PetId, Figure} | TempList]
    end,
    InfoList = lists:foldl(F, [], List),
    lib_server_send:send_to_uid(RoleId, pt_280, 28002, [InfoList]),
    State.

%% 创建战场 一方战死或按跳过时再结算
create_battle(State, ChallengeRole, Skills) ->
    #jjc_state{battle_status_maps = BStatusMaps} = State,
    #challenge_role{
        self_image  = TmpSeflImage,
        rival_image = TmpRivalImage
    } = ChallengeRole,
    #image_role{
        rank = SelfRank,
        role_info = #faker_info{
            role_id = RoleId
    }} = TmpSeflImage,
    #image_role{
        rank = RivalRank
    } = TmpRivalImage,
    ChencList = [challenge_num, rival_rank, self_rank, self_battle_status, rival_battle_status],
    case check_challenge(State, ChallengeRole, ChencList) of
        {true, NewState} ->
            case get({RoleId, fake_list}) of
                FakeImageL when is_list(FakeImageL) ->
                    case lists:keyfind(RivalRank, 1, FakeImageL) of
                        {_, RivalImage} when is_record(RivalImage, image_role) ->
                            % 构造己方的image_role
                            SelfInfo = lib_faker_api:create_faker(?MOD_JJC, {RoleId, SelfRank}),
                            SelfImage = TmpSeflImage#image_role{role_info = SelfInfo},
                            NewChallengeRole = ChallengeRole#challenge_role{self_image = SelfImage, rival_image = RivalImage},
                            put({RoleId, challenge_image}, NewChallengeRole),
                            BStatusMaps1 = maps:put(SelfRank, ?BATTLE_STATUS, BStatusMaps),
                            NewBStatusMaps = maps:put(RivalRank, ?BATTLE_STATUS, BStatusMaps1),
                            LastState = NewState#jjc_state{battle_status_maps = NewBStatusMaps},
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_jjc, create_fake_battle, [Skills, NewChallengeRole]);
                        _ -> LastState = NewState,lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err280_on_battle_state)])
                    end;
                _ -> LastState = NewState, lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err280_on_battle_state)])
            end;
        {false, Errcode, NewState} ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err280_on_battle_state)]),
            LastState = NewState,
            lib_server_send:send_to_uid(RoleId, pt_280, 28000, [Errcode])
    end,
    LastState.

%% 马上结算
right_now_clear(State, ChallengeRole) ->
    #challenge_role{
        self_image = TmpSeflImage,
        rival_image = TmpRivalImage,
        challenge_times = ChallengeTimes
    } = ChallengeRole,
    #image_role{
        rank = SelfRank,
        role_info = #faker_info{
            role_id = RoleId
    }} = TmpSeflImage,
    #image_role{
        rank = RivalRank
    } = TmpRivalImage,
    ChencList = [challenge_num, rival_rank, self_rank, self_battle_status, rival_battle_status],
    case check_challenge(State, ChallengeRole, ChencList) of
        {true, NewState0} ->
            case get({RoleId, fake_list}) of
                FakeImageL when is_list(FakeImageL) ->
                    case lists:keyfind(RivalRank, 1, FakeImageL) of
                        {_, RivalImage} when is_record(RivalImage, image_role) ->
                            % 构造己方的image_role
                            SelfInfo = lib_faker_api:create_faker(?MOD_JJC, {RoleId, SelfRank}),
                            SelfImage = TmpSeflImage#image_role{role_info = SelfInfo},
                            NewChallengeRole = ChallengeRole#challenge_role{self_image = SelfImage, rival_image = RivalImage},
                            put({RoleId, challenge_image}, NewChallengeRole),
                            case SelfRank == 0 of
                                true -> NewState = challenge_image_role_result(NewState0, RoleId, ChallengeTimes);
                                false -> NewState = challenge_image_role_result(NewState0, RoleId, SelfRank<RivalRank, ChallengeTimes)
                            end;
                        _ -> NewState = NewState0
                    end;
                _ -> NewState = NewState0
            end;
        {false, Errcode, NewState} -> lib_server_send:send_to_uid(RoleId, pt_280, 28000, [Errcode])
    end,
    NewState.

%% 获取挑战次数信息
get_challenge_num(State, RoleId, VipType, VipLv) ->
    %% 根据vip等级的可购买次数
    MaxBuyNum = lib_vip_api:get_vip_privilege(?MOD_JJC, 1, VipType, VipLv),
    BuyNum = mod_daily:get_count(RoleId, ?MOD_JJC, ?DEFAULT_SUB_MODULE, ?JJC_BUY_NUM),
    {JJCNum, RefreshTime} = get_challenge_num(RoleId),
    CanBuyNum = max(MaxBuyNum - BuyNum, 0),
    % ?PRINT("~p, ~p, ~p, ~p ~n", [JJCNum, RefreshTime, BuyNum, MaxBuyNum]),
    lib_server_send:send_to_uid(RoleId, pt_280, 28004, [?SUCCESS, JJCNum, RefreshTime, CanBuyNum]),
    State.

%% 获取鼓舞次数信息
get_inspire_num(State, RoleId) ->
    InspireNum = mod_daily:get_count_offline(RoleId, ?MOD_JJC, ?JJC_INSPIRE_NUM),
    lib_server_send:send_to_uid(RoleId, pt_280, 28006, [?SUCCESS, InspireNum]),
    State.

%% 获取奖励
get_reward(State, RoleId) ->
    RealRole = get_real_role(State, RoleId),
    #real_role{is_reward = IsReward, reward_rank = RewardRank} = RealRole,
    case IsReward of
        ?JJC_HAVE_REWARD ->
            Reward = get_rank_reward(RewardRank),
            %% 更改领取奖励状态
            NewRealRole = RealRole#real_role{is_reward = ?JJC_HAVE_NOT_REWARD},
            %% 更新state
            NewState = put_real_role(State, RoleId, NewRealRole),
            %% 发奖励
            % Produce = #produce{title = utext:get(294), content = utext:get(295), reward = Reward, type = jjc_rank_reward, show_tips = 1},
            % lib_goods_api:send_reward_with_mail(RoleId, Produce),
            lib_mail_api:send_sys_mail([RoleId], utext:get(294), utext:get(295), Reward),
            %日志
            lib_log_api:log_jjc_clear(RoleId, RewardRank, Reward),
            lib_server_send:send_to_uid(RoleId, pt_280, 28008, [?SUCCESS, ?JJC_HAVE_NOT_REWARD, Reward]);
        ?JJC_HAVE_NOT_REWARD ->
            NewState = State
        %lib_server_send:send_to_uid(RoleId, pt_280, 28000, [?ERRCODE(err280_none_reward)])
    end,
    NewState.

%% 获取被挑战记录
get_challenge_record(State, RoleId) ->
    RealRole = get_real_role(State, RoleId),
    Record = RealRole#real_role.record,
    %%?PRINT("~p ~n", [Record]),
    case Record of
        [] -> BinRecord = [];
        _ ->
            F = fun(#challenge_record{rival_id = RivalId, result = Result, rank_change = RankRange, time = Time} = ChallengeRecord) ->
                case lib_role:get_role_show(RivalId) of
                    [] ->
                        #challenge_record{
                            rival_name = Name, rival_career = Career, rival_sex = Sex, rival_turn = Turn, rival_vip_lv = VipLv, rival_lv = Lv,
                            rival_combat = Combat
                            } = ChallengeRecord,
                        Picture = "", PictureVer = 0;
                    #ets_role_show{
                            figure = #figure{
                                name = Name, picture = Picture, picture_ver = PictureVer, career = Career,
                                sex = Sex, turn = Turn, lv = Lv, vip = VipLv}
                            , combat_power = Combat} ->
                        skip
                end,
                if
                    RankRange > 0 -> Code = ?RANK_UP, LastRange = RankRange;
                    RankRange < 0 -> Code = ?RANK_DOWN, LastRange = abs(RankRange);
                    true -> Code = ?RANK_STAY, LastRange = RankRange
                end,
                {RivalId, Picture, PictureVer, Name, Career, Sex, Turn, VipLv, Lv, Combat, Result, Code, LastRange, Time}
            end,
            BinRecord = lists:map(F, Record)
    end,
    %?PRINT("~p ~n", [BinRecord]),
    lib_server_send:send_to_uid(RoleId, pt_280, 28009, [?SUCCESS, BinRecord]),
    State.

%% 获取王者榜信息（前3名）
get_rank_pre_3(State, RoleId) ->
    #jjc_state{rank_maps = RankMaps} = State,
    F = fun(Rank, TmpL) ->
        case maps:get(Rank, RankMaps, false) of
            RR when is_record(RR, rank_role) -> %% 有真人数据
                RankRoleId = RR#rank_role.role_id,
                case lib_role:get_role_show(RankRoleId) of
                    [] -> Figure = #figure{}, TmpCombat = 0;
                    #ets_role_show{figure = Figure, combat_power = TmpCombat} -> skip
                end;
            _ -> %% 没真人数据 用假人数据
                #image_role{role_info = #faker_info{figure = Figure, combat_power = TmpCombat}} = create_robot_image_role(Rank),
                RankRoleId = 0
        end,
        [{Rank, RankRoleId, TmpCombat, Figure} | TmpL]
        end,
    List = lists:foldl(F, [], lists:seq(1, 3)),
    LastList = lists:reverse(List),
    %?PRINT("~p~n", [LastList]),
    lib_server_send:send_to_uid(RoleId, pt_280, 28011, [?SUCCESS, LastList]),
    State.

%% 领取突破奖励
handle_get_break_reward(State, RoleId, BreakId) ->
    #real_role{history_rank = HistoryRank} = get_real_role(State, RoleId),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_jjc, handle_get_break_reward, [HistoryRank, BreakId]),
    State.

%%-------------- 每日20点59分清算竞技排行奖励--------------%%
refresh_reward(State) ->
    #jjc_state{real_maps = RealMaps} = State,
    RealList = maps:keys(RealMaps),
    % ?PRINT("RealList:~p ~n", [RealList]),
    spawn(?MODULE, timer_reward_to_db, [RealList]),
    State.

%% 结算之后 每50ms更新一个玩家的数据库，每30个玩家睡眠100ms
timer_reward_to_db(RoleList) ->
    timer_reward_to_db_help(RoleList, 1).

timer_reward_to_db_help([], _Index) -> skip;
timer_reward_to_db_help([RoleId | T], Index) ->
    timer:sleep(50),
    case Index rem 30 of
        0 ->
            timer:sleep(100);
        _ ->
            skip
    end,
    mod_jjc:cast_to_jjc(timer_reward_to_db, [RoleId]),
    timer_reward_to_db_help(T, Index + 1).

%% 根据排名读取配置随机对手列表
%% return  [#image_role{}]
do_random_rival(State, Rank, RoleId, Combat) ->
    RId = get_rank_id(Rank),
    RankId = ?IF(RId == 0, lists:max(data_jjc:get_id_list()), RId),
    MaxRank = case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
                  [] -> 0;
                  [TmpMaxRank] -> TmpMaxRank
              end,
    Range = case data_jjc:get_search_cfg(RankId) of
                #jjc_search_cfg{range = TmpRange} -> TmpRange;
                _ -> 0
            end,
    case data_jjc:get_search_cfg(RankId - 1) of
        #jjc_search_cfg{max = PreMax, range = PreRange} -> skip;
        _ -> PreMax = PreRange = 0
    end,
    RandRankL = if
        %% 对手排名列表 排名前3和未上榜的情况特殊处理
        Rank == 1 -> [2, 3, 4];
        Rank == 2 -> [1, 3, 4];
        Rank == 3 -> [1, 2, 4];
        %% 未上榜的情况
        Rank == 0 orelse Rank == MaxRank ->
            [try_to_rand_robot(State, Combat, MaxRank - 3 * Range, MaxRank - 2 * Range - 1),
            try_to_rand_robot(State, Combat, MaxRank - 2 * Range, MaxRank - Range - 1),
            try_to_rand_robot(State, Combat, MaxRank - Range, MaxRank - 1)];
         %% 普遍情况
        true ->
            [lib_jjc:alter_rand(max((Rank - 2 * Range), (PreMax - 2 * PreRange)), Rank - Range - 1),
            lib_jjc:alter_rand(max((Rank - Range), (PreMax - PreRange)), Rank - 1),
            lib_jjc:alter_rand(Rank + 1, min((Rank + Range), MaxRank))]
    end,
    NRandRankL = lists:usort([1, 2, 3] ++ RandRankL),
    LastList = lists:reverse([get_image_role(State, RandRank) || RandRank <- NRandRankL, RandRank > 0]),
    FakeImageL = [{ImageRole#image_role.rank, ImageRole} || ImageRole <- LastList],
    put({RoleId, fake_list}, FakeImageL),
    LastList.

%% 尝试随机出机器人
try_to_rand_robot(State, _Combat, Min, Max) ->
    #jjc_state{rank_maps = RankMaps} = State,
    F = fun(Rank) -> maps:is_key(Rank, RankMaps) end,
    {Satisfying, NotSatisfying} = lists:partition(F, lists:seq(Min, Max)),
    % ?PRINT("Satisfying:~p, NotSatisfying:~p ~n", [Satisfying, NotSatisfying]),
    if
        % 优先假人
        NotSatisfying =/= [] -> urand:list_rand(NotSatisfying);
        % 没有假人也没有真人
        Satisfying == [] -> urand:rand(Min, Max);
        % 有真人,选战力底的
        true ->
            F2 = fun(Rank, Result) ->
                case maps:get(Rank, RankMaps, false) of
                    #rank_role{role_id = RoleId} ->
                        #image_role{
                            role_info = #faker_info{combat_power = TmpCombat}
                        } = get_real_image_role(State, Rank, RoleId),
                        case Result of
                            {_OldRank, OldCombat} when OldCombat > TmpCombat -> {Rank, TmpCombat};
                            false -> {Rank, TmpCombat};
                            _ -> Result
                        end;
                    _ ->
                        Result
                end
            end,
            case lists:foldl(F2, false, Satisfying) of
                false -> urand:rand(Min, Max);
                {Rank, _RankCombat} -> Rank
            end
    end.

%% 根据排名获取对手，state中不存在，若不存在，则为机器人配置
%% 必须保证Rank大于0
% return  #image_role{}
get_image_role(State, Rank) when Rank > 0 ->
    #jjc_state{rank_maps = RankMaps} = State,
    case maps:get(Rank, RankMaps, false) of
        #rank_role{role_id = RoleId} ->
            ImageRole = get_real_image_role(State, Rank, RoleId);
        _ ->
            ImageRole = create_robot_image_role(Rank)
    end,
    ImageRole;
get_image_role(_State, _Rank) ->
    #image_role{}.


%% 根据Rank，获得排名区间
get_rank_id(Rank) ->
    IdList = data_jjc:get_id_list(),
    do_get_rank_id(Rank, IdList).

do_get_rank_id(_Rank, []) -> 0;
do_get_rank_id(Rank, [H | T]) ->
    case data_jjc:get_search_cfg(H) of
        #jjc_search_cfg{max = Max, min = Min} -> ok;
        _ -> Max = Min = 0
    end,
    case Max >= Rank andalso Rank >= Min of
        true ->
            H;
        _ ->
            do_get_rank_id(Rank, T)
    end.

%% 根据Rank，获得排名奖励
get_rank_reward(Rank) ->
    IdList = data_jjc:get_rank_reward_id_list(),
    do_get_rank_reward_id(Rank, IdList).

do_get_rank_reward_id(_Rank, []) -> [];
do_get_rank_reward_id(Rank, [H | T]) ->
    case data_jjc:get_rank_reward_cfg(H) of
        #jjc_reward_rank_cfg{max = Max, min = Min, reward = Reward} -> ok;
        _ -> Max = Min = 0, Reward = []
    end,
    case Max >= Rank andalso Rank >= Min of
        true ->
            Reward;
        _ ->
            do_get_rank_reward_id(Rank, T)
    end.

%% 取消突破奖励自动发放
%% 根据Rank, 获得名次突破奖励
get_break_reward(_RoleId, _Rank, _HistoryRank) -> [].
    % if
    %     Rank =< HistoryRank orelse HistoryRank == 0 ->      %% 突破历史排名 发放邮件奖励
    %         Reward = get_cfg_break_reward(Rank, HistoryRank),
    %         case Reward == [] of
    %             true -> skip;
    %             false ->
    %                 Produce = #produce{title = utext:get(211), content = utext:get(212, [Rank]), reward = Reward, type = jjc_challenge_break_reward, show_tips = ?SHOW_TIPS_0},
    %                 lib_goods_api:send_reward_with_mail(RoleId, Produce),
    %                 % lib_mail_api:send_sys_mail([RoleId], utext:get(211), utext:get(212, [Rank]), Reward),
    %                 %% 日志
    %                 lib_log_api:log_jjc_break_rank(RoleId, Rank, Reward)
    %         end,
    %         Reward;
    %     true ->
    %         []
    % end.

get_cfg_break_reward(_Rank, _HistoryRank) -> [].
%     [CfgMaxRank] = data_jjc:get_jjc_value(?JJC_MAX_RANK),
%     MaxRank = ?IF(HistoryRank == 0, CfgMaxRank+1, HistoryRank),
%     Reward = do_get_break_reward(Rank, MaxRank, []),
%     UqReward = lib_goods_api:make_reward_unique(Reward),
%     [{Type, GoodsTypeId, umath:ceil(Num)}||{Type, GoodsTypeId, Num}<-UqReward].

% do_get_break_reward(Rank, MaxRank, SumReward) when Rank >= MaxRank -> SumReward;
% do_get_break_reward(Rank, MaxRank, SumReward) ->
%     case data_jjc:get_break_reward_cfg(Rank) of
%         #jjc_reward_break_cfg{reward = Reward} -> ok;
%         _ -> Reward = []
%     end,
%     do_get_break_reward(Rank+1, MaxRank, Reward++SumReward).

% get_cfg_break_rank(Rank) ->
%     RankList = data_jjc:get_break_reward_rank_list(),
%     do_get_break_rank(Rank, RankList).

% do_get_break_rank(_Rank, []) -> [];
% do_get_break_rank(Rank, [H | T]) ->
%     case data_jjc:get_break_reward_cfg(H) of
%         #jjc_reward_break_cfg{rank = CfgRank} -> ok;
%         _ -> CfgRank = 0
%     end,
%     case Rank =< CfgRank of
%         true ->
%             CfgRank;
%         _ ->
%             do_get_break_rank(Rank, T)
%     end.

%% 获取真人image_role{}
get_real_image_role(_State, Rank, RoleId) ->
    FakerInfo = lib_faker_api:create_faker(?MOD_JJC, {RoleId, Rank}),
    #image_role{
        rank      = Rank,
        role_info = FakerInfo
    }.

%% 创建机器人形象和战力信息
create_robot_image_role(Rank) ->
    FakerInfo = lib_faker_api:create_faker(?MOD_JJC, Rank),
    #image_role{
        rank      = Rank,
        role_info = FakerInfo
    }.

%% 结算结果，减少自己挑战次数
challenge_image_role_result(State, RoleId) ->
    challenge_image_role_result(State, RoleId, 1).

challenge_image_role_result(State, RoleId, ChallengeTimes) ->
    case get({RoleId, challenge_image}) of
        #challenge_role{
            self_image = #image_role{
                role_info = #faker_info{
                    combat_power = SelCombat
            }},
            rival_image = #image_role{
                role_info = #faker_info{
                    combat_power = RivalCombat
            }}
        } ->
            IsWin = SelCombat > RivalCombat,
            challenge_image_role_result(State, RoleId, IsWin, ChallengeTimes);
        _ ->
            challenge_image_role_result(State, RoleId, true, ChallengeTimes)
    end.

challenge_image_role_result(State, RoleId, IsWin, ChallengeTimes) ->
    case get({RoleId, challenge_image}) of
        #challenge_role{
            self_image = #image_role{
                rank = SelfRank,
                role_info = #faker_info{
                    figure = #figure{lv = Lv} = SelfFigure,
                    combat_power = SelCombat
            }},
            rival_image = #image_role{
                rank = RivalRank,
                role_info = #faker_info{
                    role_id = RivalId,
                    figure = RivalFigure,
                    combat_power = RivalCombat
            }}
        } ->
            case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
                [MaxRank] ->
                    lib_jjc_event:finish_battle(RoleId, Lv, ChallengeTimes),
                    ?IF(IsWin andalso (SelfRank > RivalRank orelse SelfRank == 0),
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, jjc_rank, [RivalRank]),
                        skip),
                    #figure{name = RivalName, career = RivalCareer, sex = RivalSex, turn = RivalTurn, vip_type = RivalVipType, vip = RivalVipLv, lv = RivalLv} = RivalFigure,
                    if
                        SelfRank == 0 ->    %% 挑战之前未上榜的情况
                            if
                                IsWin ->  %% 战力大于对手 更换自己的排名 写入maps和数据库
                                    Result = ?JJC_WIN,
                                    LastRank = RivalRank,
                                    LastRivalRank = SelfRank,
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_WIN, rank_change = MaxRank - RivalRank
                                        },
                                    NewRR = RR#real_role{role_id = RoleId, rank = RivalRank, history_rank = RivalRank, record = refresh_challenge_record(RR, Record)},
                                    %% 处理次数
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    State2 = put_rank_role(State1, RivalRank, RoleId),
                                    %% 成就
                                    lib_achievement_api:async_event(RoleId, lib_achievement_api, participate_jjc_event, RivalRank),
                                    BreakReward = get_break_reward(RoleId, RivalRank, 0),
                                    case RivalId == 0 of    %% 如果对手是玩家，更换对手排名 更新挑战记录
                                        true -> LastState = State2;
                                        _ ->
                                            RivalRR = get_real_role(State2, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_FAIL, rank_change = RivalRank - MaxRank},
                                            send_challenge_record(RivalRecord),
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, rank = SelfRank, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            LastState = put_real_role(State2, RivalId, NewRivalRR)
                                    end,
                                    %% 传闻
                                    if
                                        RivalRank =< 3 andalso RivalRank > 0 ->
                                            lib_chat:send_TV({all}, ?MOD_JJC, 1, [SelfFigure#figure.name, RivalFigure#figure.name, RivalRank]);
                                        true -> skip
                                    end;
                                true ->         %% 挑战失败 排名无变化
                                    Result = ?JJC_FAIL,
                                    LastRank = SelfRank,
                                    LastRivalRank = RivalRank,
                                    BreakReward = [],
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_FAIL, rank_change = 0
                                        },
                                    NewRR = RR#real_role{record = refresh_challenge_record(RR, Record)},
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    case RivalId == 0 of    %% 如果对手是玩家
                                        true -> LastState = State1;
                                        _ ->
                                            RivalRR = get_real_role(State1, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_WIN},
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            LastState = put_real_role(State1, RivalId, NewRivalRR)
                                    end
                            end;
                        SelfRank > RivalRank ->
                            case IsWin of  %% 战力大于对手 更换自己的排名 写入maps和数据库
                                true ->
                                    Result = ?JJC_WIN,
                                    LastRank = RivalRank,
                                    LastRivalRank = SelfRank,
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_WIN, rank_change = SelfRank - RivalRank
                                        },
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    NewRR = RR#real_role{
                                        role_id = RoleId, rank = RivalRank, history_rank = min(RivalRank, RR#real_role.history_rank),
                                        record = refresh_challenge_record(RR, Record)
                                        }, %% 未上榜 maps里没有
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    State2 = put_rank_role(State1, RivalRank, RoleId),
                                    %% 成就
                                    lib_achievement_api:async_event(RoleId, lib_achievement_api, participate_jjc_event, RivalRank),
                                    BreakReward = get_break_reward(RoleId, RivalRank, RR#real_role.history_rank),
                                    case RivalId == 0 of    %% 如果对手是玩家，更换对手排名  如果对手是假人 移除rankmaps里的
                                        true ->
                                            LastState = remove_rank_role(State2, SelfRank);
                                        _ ->
                                            RivalRR = get_real_role(State1, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_FAIL, rank_change = RivalRank - SelfRank},
                                            send_challenge_record(RivalRecord),
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, rank = SelfRank, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            State3 = put_real_role(State2, RivalId, NewRivalRR),
                                            LastState = put_rank_role(State3, SelfRank, RivalId)
                                    end,
                                    if
                                        RivalRank =< 3 andalso RivalRank > 0 ->
                                            lib_chat:send_TV({all}, ?MOD_JJC, 1, [SelfFigure#figure.name, RivalFigure#figure.name, RivalRank]);
                                        true -> skip
                                    end;
                                false ->         %% 挑战失败 排名无变化 如果对手是玩家 保存战斗记录
                                    Result = ?JJC_FAIL,
                                    LastRank = SelfRank,
                                    LastRivalRank = RivalRank,
                                    BreakReward = [],
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_FAIL, rank_change = 0
                                        },
                                    NewRR = RR#real_role{record = refresh_challenge_record(RR, Record)},
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    case RivalId == 0 of
                                        true ->
                                            LastState = State1;
                                        _ ->
                                            RivalRR = get_real_role(State1, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_WIN},
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            LastState = put_real_role(State1, RivalId, NewRivalRR)
                                    end
                            end;
                        SelfRank < RivalRank ->     %% 挑战排名比自己低的情况 排名不变动 更新战斗记录
                            case IsWin of
                                true ->
                                    Result = ?JJC_WIN,
                                    LastRank = SelfRank,
                                    LastRivalRank = RivalRank,
                                    BreakReward = [],
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_WIN, rank_change = 0
                                        },
                                    NewRR = RR#real_role{record = refresh_challenge_record(RR, Record)},
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    case RivalId == 0 of    %% 如果对手是玩家，更换对手排名
                                        true -> LastState = State1;
                                        _ ->
                                            RivalRR = get_real_role(State1, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_FAIL},
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            LastState = put_real_role(State1, RivalId, NewRivalRR)
                                    end;
                                false ->         %% 挑战失败 排名无变化 如果对手是玩家 保存战斗记录
                                    Result = ?JJC_FAIL,
                                    LastRank = SelfRank,
                                    LastRivalRank = RivalRank,
                                    BreakReward = [],
                                    RR = get_real_role(State, RoleId),
                                    Record = #challenge_record{
                                        role_id = RoleId, time = utime:unixtime(), rival_id = RivalId,
                                        rival_name = RivalName, rival_career = RivalCareer, rival_sex = RivalSex, rival_turn = RivalTurn,
                                        rival_vip_type = RivalVipType, rival_vip_lv = RivalVipLv, rival_lv = RivalLv, rival_combat = RivalCombat,
                                        result = ?JJC_FAIL, rank_change = 0
                                        },
                                    NewRR = RR#real_role{record = refresh_challenge_record(RR, Record)},
                                    handle_decrement_challenge_num(RoleId, ChallengeTimes),
                                    State1 = put_real_role(State, RoleId, NewRR),
                                    case RivalId == 0 of
                                        true ->
                                            LastState = State1;
                                        _ ->
                                            RivalRR = get_real_role(State1, RivalId),
                                            RivalRecord = #challenge_record{role_id = RivalId, time = utime:unixtime(), rival_id = RoleId, result = ?JJC_WIN},
                                            NewRivalRR = RivalRR#real_role{role_id = RivalId, record = refresh_challenge_record(RivalRR, RivalRecord)},
                                            LastState = put_real_role(State1, RivalId, NewRivalRR)
                                    end
                            end;
                        true ->
                            Result = ?JJC_FAIL,
                            LastRank = SelfRank,
                            LastRivalRank = RivalRank,
                            BreakReward = [],
                            LastState = State
                    end,
                    %% 挑战奖励 (公式暂定)
                    ChallengeReward = lib_jjc:get_challenge_reward(Result, Lv),
                    ChallengeRewardN = [{G1, G2, Num * ChallengeTimes} || {G1, G2, Num} <-ChallengeReward],
                    ClearRoleL = [{RoleId, SelfFigure, SelfRank, LastRank, SelCombat},
                        {RivalId, RivalFigure, RivalRank, LastRivalRank, RivalCombat}],
                    %% 发奖励
                    Produce = #produce{title = utext:get(296), content = utext:get(297), reward = ChallengeRewardN, type = jjc_challenge_reward, show_tips = ?SHOW_TIPS_0},
                    lib_goods_api:send_reward_with_mail(RoleId, Produce),
                    lib_common_rank_api:refresh_rank_by_jjc_rank(RoleId, RivalId),
                    %% 日志
                    lib_log_api:log_jjc(RoleId, SelfRank, RivalId, RivalRank, Result, LastRank),
                    % ?PRINT("[ClearRoleL, Result, ChallengeReward, BreakReward]:~p~n", [[ClearRoleL, Result, ChallengeReward, BreakReward]]),
                    lib_server_send:send_to_uid(RoleId, pt_280, 28003, [ClearRoleL, Result, ChallengeRewardN, BreakReward]),
                    LastState;
                [] ->
                    lib_server_send:send_to_uid(RoleId, pt_280, 28000, [?ERRCODE(err_config)]),
                    LastState = State
            end;
        _ -> LastState = State
    end,
    erase({RoleId, challenge_image}),
    LastState.

%% 发送挑战记录
send_challenge_record(ChallengeRecord) ->
    #challenge_record{role_id = RoleId, rival_id = RivalId, result = Result, rank_change = RankRange, time = Time} = ChallengeRecord,
    case lib_role:get_role_show(RivalId) of
        [] ->
            #challenge_record{
                rival_name = Name, rival_career = Career, rival_sex = Sex, rival_turn = Turn, rival_vip_lv = VipLv, rival_lv = Lv,
                rival_combat = Combat
                } = ChallengeRecord,
            Picture = "", PictureVer = 0;
        #ets_role_show{
                figure = #figure{
                name = Name, picture = Picture, picture_ver = PictureVer, career = Career,
                sex = Sex, turn = Turn, lv = Lv, vip = VipLv}
                , combat_power = Combat} ->
            skip
    end,
    if
        RankRange > 0 -> Code = ?RANK_UP, LastRange = RankRange;
        RankRange < 0 -> Code = ?RANK_DOWN, LastRange = abs(RankRange);
        true -> Code = ?RANK_STAY, LastRange = RankRange
    end,
    lib_server_send:send_to_uid(RoleId, pt_280, 28016, [RivalId, Picture, PictureVer, Name, Career, Sex, Turn, VipLv, Lv, Combat, Result, Code, LastRange, Time]),
    ok.

%% 刷新被挑战记录
refresh_challenge_record(RealRole, Record) ->
    #real_role{record = RecordL} = RealRole,
    case data_jjc:get_jjc_value(?JJC_MAX_RECORD) of
        [MaxRecordNum] -> ok;
        [] -> MaxRecordNum = 10
    end,
    TmpRecordL = [Record | RecordL],
    if
        length(TmpRecordL) > MaxRecordNum ->
            NewRecordL = lists:sublist(TmpRecordL, MaxRecordNum),
            remove_db_challenge_record(lists:nth(length(TmpRecordL), TmpRecordL));
        true -> NewRecordL = TmpRecordL
    end,
    replace_db_challenge_record(Record),
    NewRecordL.

set_battle_status(State, RankList, BattleStatus) ->
    #jjc_state{battle_status_maps = BStatusMaps} = State,
    F = fun(Rank, AccMap) ->
        maps:put(Rank, BattleStatus, AccMap)
        end,
    NewMaps = lists:foldl(F, BStatusMaps, RankList),
    State#jjc_state{battle_status_maps = NewMaps}.

%% 获取排名信息(异步返回)
%% @param Type 类型,根据类型来回调函数
%% @param RankNoL [排名位置,...]
%% @return [{RankNo, RoleId, Figure, BattleAttr, Combat},...]
cast_get_rank_info(State, _Type, RankNoL) ->
    #jjc_state{rank_maps = RankMaps} = State,
    F = fun(RankNo) ->
        case maps:get(RankNo, RankMaps, false) of
            #rank_role{role_id = RoleId} ->
                case catch lib_offline_player:get_player_info(RoleId, all) of
                    #player_status{figure = Figure, combat_power = Combat, battle_attr = BattleAttr} ->
                        {RankNo, RoleId, Figure, BattleAttr, Combat};
                    _ -> create_robot(RankNo)
                end;
            _ ->
                create_robot(RankNo)
        end
    end,
    _List = lists:map(F, RankNoL),
    case _Type of
        {Mod, Fun, Args} ->
            apply(Mod, Fun, [_List|Args]);
        _ -> skip
    end,
    State.

%% 创建机器人的属性
create_robot(RankNo) ->
    % figure
    case data_jjc:get_jjc_robot(RankNo) of
        [] -> Robot = #base_jjc_robot{};
        Robot -> ok
    end,
    #base_jjc_robot{
        power_range = [MinPower, MaxPower], lv_range = [MinLv, MaxLv],
        rmount = RMount, rmate = RMate, rpet = RPet, rfly = RFly, rholyorgan = RHolyorgan
        } = Robot,
    {Career, Sex} = lib_career:rand_career_and_sex(),
    Turn = urand:list_rand(lists:seq(0, ?MAX_TURN)),
    Lv = urand:rand(MinLv, MaxLv),
    LvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),
    Combat = urand:rand(MinPower, MaxPower),
    MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount), 0}]),
    MateKv = ?IF(RMate == [], [], [{?MATE_ID, urand:list_rand(RMate), 0}]),
    PetKv = ?IF(RPet == [], [], [{?PET_ID, urand:list_rand(RPet), 0}]),
    FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly), 0}]),
    HolyorganKv = case lists:keyfind(Career, 1, RHolyorgan) of
        {_, HolyorganL} when HolyorganL =/= [] -> [{?HOLYORGAN_ID, urand:list_rand(HolyorganL), 0}];
        _ -> []
    end,
    Name = case data_jjc:get_robot_name_list() of
        [] -> utext:get(182); %%"守卫";
        NameList -> urand:list_rand(NameList)
    end,
    MountFigure = MountKv ++ MateKv ++ PetKv ++ FlyKv ++ HolyorganKv,
    Figure = #figure{name = Name, sex = Sex, turn = Turn, career = Career, lv = Lv, lv_model = LvModel, mount_figure = MountFigure, vip = ?JJC_ROBOT_VIP},
    % battle_attr
    RobotAttr = get_robot_attr(Combat),
    BattleAttr = #battle_attr{hp=RobotAttr#attr.hp, hp_lim=RobotAttr#attr.hp, speed=?SPEED_VALUE, attr=RobotAttr},
    {RankNo, 0, Figure, BattleAttr, Combat}.

%% 计算属性
get_robot_attr(Power) ->
    PowerAttrList = data_jjc:get_power_attr(),
    NewPowerAttrList = [{AttrType, round(Value*Power)}||{AttrType, Value}<-PowerAttrList],
    lib_player_attr:to_attr_record(NewPowerAttrList).

%%-------------------------每天定时清算奖励----------------------------------%%
timer_reward_to_db(State, RoleId) ->
    RealRole = get_real_role(State, RoleId),
    #real_role{rank = Rank} = RealRole,
    NowTime = utime:unixtime(),
    case lib_role:get_role_show(RoleId) of
        [] -> LastTime = NowTime;
        #ets_role_show{last_logout_time = LastTime} -> skip
    end,
    if
        (NowTime - LastTime > ?ONE_WEEK_SECONDS) andalso LastTime > 0 ->    %% 超过一周 清楚排名数据 奖励等保留
            update_db_real_role_rank(RoleId, 0),
            #jjc_state{real_maps = RealMaps, rank_maps = RankMaps} = State,
            lib_common_rank_api:refresh_rank_by_jjc_rank(RoleId,0),
            NewRealRole = RealRole#real_role{rank = 0},
            NewRealMaps = maps:put(RoleId, NewRealRole, RealMaps),
            NewRankMaps = maps:remove(Rank, RankMaps),
            NewState = State#jjc_state{real_maps = NewRealMaps, rank_maps = NewRankMaps};
        true ->
            IsReward = case get_rank_reward(Rank) of
                           [] -> ?JJC_HAVE_NOT_REWARD;
                           _ -> ?JJC_HAVE_REWARD
                       end,
            NewRealRole = RealRole#real_role{is_reward = IsReward, reward_rank = Rank},
            #jjc_state{real_maps = RM} = State,
            update_db_reward(NewRealRole),
            NewRM = maps:put(RoleId, NewRealRole, RM),
            NewState = State#jjc_state{real_maps = NewRM}
    end,
    % 领取奖励
    NewState2 = get_reward(NewState, RoleId),
    %?PRINT("~p~n", [NewState]),
    NewState2.


%% 获取maps里角色信息 没有的话返回默认(Rank为0) 不处理maps
%% @return    #real_role{}
get_real_role(State, RoleId) ->
    #jjc_state{real_maps = RM} = State,
    case maps:get(RoleId, RM, false) of
        false ->
            RR = lib_jjc:get_db_real_role(RoleId);
        RR ->
            skip
    end,
    RR.

%% 获取maps里排名信息 没有的话返回默认(Rank为0) 不处理maps
%% @return    #rank_role{}
get_rank_role(State, Rank) ->
    #jjc_state{rank_maps = RM} = State,
    case maps:get(Rank, RM, false) of
        false ->
            RR = #rank_role{rank = Rank};
        RR ->
            skip
    end,
    RR.

%% 处理maps 和 数据库
put_real_role(State, RoleId, RealRole) ->
    #jjc_state{real_maps = RM} = State,
    NewRealRole = RealRole#real_role{role_id = RoleId},
    case maps:get(RoleId, RM, false) of
        false ->
            insert_db_real_role(NewRealRole);
        OldRealRole ->
            case OldRealRole =:= NewRealRole of
                true ->
                    skip;
                _ ->
                    replace_db_real_role(NewRealRole)
            end
    end,
    NewRM = maps:put(RoleId, NewRealRole, RM),
    State#jjc_state{real_maps = NewRM}.

put_rank_role(State, Rank, RoleId) ->
    #jjc_state{rank_maps = RM} = State,
    RankRole = #rank_role{role_id = RoleId, rank = Rank},
    NewRM = maps:put(Rank, RankRole, RM),
    State#jjc_state{rank_maps = NewRM}.

remove_rank_role(State, Rank) ->
    #jjc_state{rank_maps = RM} = State,
    NewRM = maps:remove(Rank, RM),
    State#jjc_state{rank_maps = NewRM}.

%%------------check--------------

%% check 挑战资格
check_challenge(State, _ChallengeRole, []) -> {true, State};
check_challenge(State, ChallengeRole, [H | T]) ->
    case do_check_challenge(State, ChallengeRole, H) of
        {true, NewState} ->
            check_challenge(NewState, ChallengeRole, T);
        {false, Errcode, NewState} ->
            % ?PRINT("-------err H:~p------------ ~n", [H]),
            {false, Errcode, NewState}
    end.

%% 对手排名是否改变
do_check_challenge(State, ChallengeRole, rival_rank) ->
    #challenge_role{rival_image = RivalImage} = ChallengeRole,
    #image_role{rank = RivalRank, role_info = #faker_info{role_id = RivalId}} = RivalImage,
    %?PRINT("~p-~p ~n", [RivalId, RivalRank]),
    RR = get_rank_role(State, RivalRank),
    case RR of
        #rank_role{role_id = RivalId, rank = RivalRank} ->
            {true, State};
        _ ->
            if
                RR#rank_role.role_id == 0 andalso RivalId == 0 -> {true, State};
                true -> {false, ?ERRCODE(err280_rival_rank_change), State}
            end
    end;
%% 自己排名是否改变
do_check_challenge(State, ChallengeRole, self_rank) ->
    #challenge_role{self_image = SelfImage} = ChallengeRole,
    #image_role{rank = SelfRank, role_info = #faker_info{role_id = RoleId}} = SelfImage,
    %?PRINT("~p-~p ~n", [RoleId, SelfRank]),
    RR = get_real_role(State, RoleId),
    %?PRINT("~p~n", [State]),
    case RR of
        #real_role{role_id = RoleId, rank = SelfRank} ->
            {true, State};
        _ ->
            if
                RR#real_role.rank == 0 andalso SelfRank == 0 -> {true, State};
                true -> {false, ?ERRCODE(err280_self_rank_change), State}
            end
    end;
%% 挑战次数
do_check_challenge(State, ChallengeRole, challenge_num) ->
    #challenge_role{self_image = SelfImage} = ChallengeRole,
    #image_role{role_info = #faker_info{role_id = RoleId}} = SelfImage,
    {JJCNum, _RefreshTime} = get_challenge_num(RoleId),
    case JJCNum > 0 of
        true ->
            {true, State};
        false ->
            {false, ?ERRCODE(err280_jjc_num_not_enough), State}
    end;
%% 对手是否在战斗中
do_check_challenge(State, ChallengeRole, rival_battle_status) ->
    #jjc_state{battle_status_maps = BStatusMaps} = State,
    #challenge_role{rival_image = #image_role{rank = RivalRank}} = ChallengeRole,
    case maps:get(RivalRank, BStatusMaps, ?NOT_BATTLE_STATUS) of
        ?NOT_BATTLE_STATUS ->
            {true, State};
        ?BATTLE_STATUS ->
            {false, ?ERRCODE(err280_on_battle_state), State}
    end;
%% 自己是否在战斗中
do_check_challenge(State, ChallengeRole, self_battle_status) ->
    #jjc_state{battle_status_maps = BStatusMaps} = State,
    #challenge_role{self_image = #image_role{rank = SelfRank}} = ChallengeRole,
    case SelfRank == 0 of
        true ->
            {true, State};
        false ->
            case maps:get(SelfRank, BStatusMaps, ?NOT_BATTLE_STATUS) of
                ?NOT_BATTLE_STATUS ->
                    {true, State};
                ?BATTLE_STATUS ->
                    {false, ?ERRCODE(err280_on_battle_state), State}
            end
    end;

%% 容错
do_check_challenge(State, _ChallengeRole, _Msg) ->
    {false, ?FAIL, State}.

fix_jjc_battle_status(#jjc_state{battle_status_maps = BStatusMaps} = State, RoleId) ->
    case get({RoleId, challenge_image}) of
        #challenge_role{
            self_image = #image_role{
                rank = SelfRank
            },
            rival_image = #image_role{
                rank = 0,
                role_info = #faker_info{
                    figure = undefined
            }}
        } ->
            NewBStatusMaps = maps:put(SelfRank, ?NOT_BATTLE_STATUS, BStatusMaps),
            erase({RoleId, challenge_image}),
            State#jjc_state{battle_status_maps = NewBStatusMaps};
        _ ->
            State
    end.

fix_jjc_battle_status(State) ->
    Data = get(),
    F = fun(T, TmpState) ->
        case T of
            {{RoleId, challenge_image},
             #challenge_role{
                rival_image = #image_role{
                    rank = 0,
                    role_info = #faker_info{
                        figure = undefined
            }}}} ->
                fix_jjc_battle_status(State, RoleId);
            _ ->
                TmpState
        end
    end,
    lists:foldl(F, State, Data).

force_fix_jjc_battle_status(#jjc_state{battle_status_maps = BStatusMaps} = State, RoleId) ->
    case get({RoleId, challenge_image}) of
        #challenge_role{
            self_image = #image_role{
                rank = SelfRank
            },
            rival_image = #image_role{
                rank = RivalRank
            }
        } ->
            NewBStatusMaps = maps:put(SelfRank, ?NOT_BATTLE_STATUS, BStatusMaps),
            NewBStatusMaps2 = maps:put(RivalRank, ?NOT_BATTLE_STATUS, NewBStatusMaps),
            erase({RoleId, challenge_image}),
            State#jjc_state{battle_status_maps = NewBStatusMaps2};
        _ ->
            State
    end.

%% --------------------db------------------------

%---insert---
insert_db_real_role(RealRole) ->
    #real_role{
        role_id      = RoleId,
        rank         = Rank,                   %% 排名
        history_rank = HistoryRank,
        is_reward    = IsReward,
        reward_rank  = RewardRank
    } = RealRole,
    Sql = io_lib:format(?sql_insert_db_real_role, [RoleId, Rank, HistoryRank, IsReward, RewardRank]),
    db:execute(Sql).

%---update---
update_db_reward(RealRole) ->
    #real_role{
        role_id     = RoleId,
        is_reward   = IsReward,
        reward_rank = RewardRank
    } = RealRole,
    Sql = io_lib:format(?sql_update_db_reward_state, [IsReward, RewardRank, RoleId]),
    db:execute(Sql).

update_db_real_role_rank(RoleId, Rank) ->
    Sql = io_lib:format(?sql_update_db_real_role_rank, [Rank, RoleId]),
    db:execute(Sql).

% ---replace---
replace_db_real_role(RealRole) ->
    #real_role{
        role_id      = RoleId,
        rank         = Rank,                   %% 排名
        history_rank = HistoryRank,
        is_reward    = IsReward,
        reward_rank  = RewardRank
    } = RealRole,
    Sql = io_lib:format(?sql_replace_db_real_role, [RoleId, Rank, HistoryRank, IsReward, RewardRank]),
    db:execute(Sql).

replace_db_challenge_record(ChallRecord) ->
    #challenge_record{
        role_id     = RoleId,
        time        = Time,
        rival_id    = RivalId,
        rival_name  = RivalName,
        rival_career = RivalCareer,
        rival_sex   = RivalSex,
        rival_turn  = RivalTurn,
        rival_vip_type = RivalVipType,
        rival_vip_lv = RivalVipLv,
        rival_lv    = RivalLv,
        rival_combat = RivalCombat,
        result      = Result,
        rank_change = RankChange
    } = ChallRecord,
    RivalNameBin = util:fix_sql_str(RivalName),
    Sql = io_lib:format(?sql_replace_db_challenge_record, [RoleId, Time, RivalId, RivalNameBin, RivalCareer, RivalSex, RivalTurn,
        RivalVipType, RivalVipLv, RivalLv, RivalCombat, Result, RankChange]),
    db:execute(Sql).

replace_db_jjc_honour(RoleId, Honour) ->
    Sql = io_lib:format(?sql_replace_db_jjc_honour, [RoleId, Honour]),
    db:execute(Sql).

%%---delete---
remove_db_challenge_record(ChallRecord) ->
    #challenge_record{
        role_id = RoleId,
        time    = Time
    } = ChallRecord,
    Sql = io_lib:format(?sql_delete_db_challenge_record, [RoleId, Time]),
    db:execute(Sql).
