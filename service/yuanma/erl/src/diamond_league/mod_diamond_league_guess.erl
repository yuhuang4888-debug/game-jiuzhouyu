%%-----------------------------------------------------------------------------
%% @Module  :       mod_diamond_league_guess.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-28
%% @Description:    星钻联赛竞猜
%%-----------------------------------------------------------------------------

-module (mod_diamond_league_guess).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,setup_state/4
    ,update_state/4
    ,set_competitors_for_guess/3
    ,get_my_cur_guess_infos/2
    ,guess/3
    ,get_my_guess_summary/1
    ,get_role_guess_info/1
    ,get_guess_reward/2
    ,update_team_after_battle_end/1
    ,get_guess_end_time/1
]).

-record (state, {
    cycle_index = 0,
    round = 0,
    start_time = 0,
    end_time = 0,
    guess_end_time = 0,
    competitors = [],
    guess_roles = []
    }). 

-record (guess_role, {
    role_id = 0,
    guess_rounds = []   %% #guess_round{}
    }).

-record (guess_round, { %% 竞猜数据 一个阶段为一场竞猜
    round_id = 0,   
    price_id = 0, 
    pairs = [],     %% #guess_pair{} 一场中有几组匹配
    setup_status = 0,   %% 0 未初始化 1 初始化
    reward_status = 0   %% 奖励领取状态
    }).

-record (guess_pair, { %% 竞猜匹配队伍
    pair_id = 0,
    roles = [],     %% 一个匹配中有两个队伍
    choose_role = 0    %% 我选择的队伍
    }).

-define (BUY, 1).
-define (MODIFY, 2).

-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

setup_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {setup_state, CycleIndex, StateId, StartTime, EndTime}).

update_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {update_state, CycleIndex, StateId, StartTime, EndTime}).

set_competitors_for_guess(CurRound, List, GuessEndTime) ->
    gen_server:cast(?SERVER, {set_competitors_for_guess, CurRound, List, GuessEndTime}).

get_my_cur_guess_infos(RoleId, Sid) ->
    gen_server:cast(?SERVER, {get_my_cur_guess_infos, RoleId, Sid}).

guess(RoleId, GuessInfo, PriceId) ->
    gen_server:cast(?SERVER, {guess, RoleId, GuessInfo, PriceId}).

get_my_guess_summary(RoleId)  ->
    gen_server:cast(?SERVER, {get_my_guess_summary, RoleId}).

get_role_guess_info(RoleId) ->
    gen_server:cast(?SERVER, {get_role_guess_info, RoleId}).

get_guess_reward(RoleId, RoundId) ->
    gen_server:cast(?SERVER, {get_guess_reward, RoleId, RoundId}).


update_team_after_battle_end(Result) ->
    gen_server:cast(?SERVER, {update_team_after_battle_end, Result}).

get_guess_end_time(Sid) ->
    gen_server:cast(?SERVER, {get_guess_end_time, Sid}).

%% private
init([]) ->
    {ok, #state{}}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({setup_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    if
        StateId =:= ?STATE_KING_CHOOSE ->
            % NowTime = utime:unixtime(),
            % Round = ((NowTime - StartTime) * ?KING_ROUND_NUM) div (EndTime - StartTime) + 1,
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_competitors_for_guess, [Node]),
            {noreply, State#state{start_time = StartTime, end_time = EndTime, cycle_index = CycleIndex}};
        true ->
            {noreply, State}
    end;

do_handle_cast({update_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    if
        StateId =:= ?STATE_KING_CHOOSE ->
            % NowTime = utime:unixtime(),
            % Round = ((NowTime - StartTime) * ?KING_ROUND_NUM) div (EndTime - StartTime) + 1,
            % Node = mod_disperse:get_clusters_node(),
            % mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_competitors_for_guess, [Node]),
            State1 = State;
        StateId =:= ?STATE_CLOSED ->
            State1 = do_send_reward_bg(State);
        true ->
            State1 = State
    end,
    {noreply, State1#state{start_time = StartTime, end_time = EndTime, cycle_index = CycleIndex}};

do_handle_cast({set_competitors_for_guess, CurRound, List, GuessEndTime}, #state{competitors = OldPairs} = State) ->
    CompetitorPairs = init_pairs(List, OldPairs),
    OpenLv = data_diamond_league:get_kv(?CFG_KEY_OPEN_LV),
    {ok, BinData} = pt_604:write(60428, [GuessEndTime]),
    lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData),
    {noreply, State#state{competitors = CompetitorPairs, round = CurRound, guess_end_time = GuessEndTime}};

do_handle_cast({get_my_cur_guess_infos, _RoleId, _Sid}, #state{round = 0} = State) ->
    {noreply, State};
do_handle_cast({get_my_cur_guess_infos, RoleId, Sid}, State) ->
    #state{round = CurRound, guess_end_time = GuessEndTime} = State,
    {Round, NewState} = try_init_role_guess(State, RoleId),
    case Round of
        #guess_round{pairs = Respond, price_id = PriceId} ->
            ok;
        _ -> 
            Respond = [], PriceId = 0
    end,
    case data_diamond_league:get_reward_counts(length(Respond), max(1, PriceId)) of
        [MinCount|_] ->
            ok;
        _ ->
            MinCount = 0
    end,
    % ?DEBUG("get_my_guess_summary ~p~n", [Respond]),
    FormatRespond 
    = [
        {PairId, ChooseId, RId1, Name1, ServerName1, Sex1, Career1, Turn1, Pic1, PicVsn1, Power1, RId2, Name2, ServerName2, Sex2, Career2, Turn2, Pic2, PicVsn2, Power2} || #guess_pair{pair_id = PairId, choose_role = ChooseId, roles = [#league_role{role_id = RId1, power = Power1, data = #{figure := #league_figure{name = Name1, server_name = ServerName1, sex = Sex1, career = Career1, turn = Turn1, pic = Pic1, picvsn = PicVsn1}}}, #league_role{role_id = RId2, power = Power2, data = #{figure := #league_figure{name = Name2, server_name = ServerName2, sex = Sex2, career = Career2, turn = Turn2, pic = Pic2, picvsn = PicVsn2}}}]} <- Respond
    ],
    % ?PRINT("60420 ~p~n", [[CurRound, MinCount, PriceId, GuessEndTime]]),
    lib_server_send:send_to_sid(Sid, pt_604, 60420, [CurRound, MinCount, PriceId, GuessEndTime, FormatRespond]),
    {noreply, NewState};

do_handle_cast({guess, RoleId, GuessInfo, PriceId}, State) ->
    #state{round = RoundId, guess_roles = GuessRoleList, cycle_index = CycleIndex, guess_end_time = GuessEndTime} = State,
    NowTime = utime:unixtime(),
    if
        RoundId > 0 andalso NowTime < GuessEndTime ->
            case lists:keyfind(RoleId, #guess_role.role_id, GuessRoleList) of
                #guess_role{guess_rounds = Rounds} = Role->
                    case lists:keyfind(RoundId, #guess_round.round_id, Rounds) of
                        #guess_round{pairs = Pairs, price_id = OldPriceId} = Round ->
                            case check_guess(GuessInfo, Pairs, [], 0, 0) of
                                {ok, NewPairs, ChooseFlag} ->
                                    %% 已经选过了不用再扣消耗
                                    RealPriceId = if OldPriceId > 0 -> OldPriceId; true -> PriceId end,
                                    case ChooseFlag > 0 orelse (catch lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, lib_diamond_league, cost_guess_price, [PriceId]) =:= true) of
                                        true  ->
                                            Round2 = Round#guess_round{pairs = NewPairs, price_id = RealPriceId},
                                            save_round(RoleId, Round2, CycleIndex),
                                            log_guess(RoleId, Round2, if ChooseFlag > 0 -> ?MODIFY; true -> ?BUY end),
                                            Rounds2 = lists:keystore(RoundId, #guess_round.round_id, Rounds, Round2),
                                            Role2 = Role#guess_role{guess_rounds = Rounds2},
                                            NewGuessRoleList = lists:keystore(RoleId, #guess_role.role_id, GuessRoleList, Role2),
                                            NewState = State#state{guess_roles = NewGuessRoleList},
                                            if
                                                ChooseFlag > 0 ->
                                                    lib_server_send:send_to_uid(RoleId, pt_604, 60421, [?ERRCODE(err604_guest_modify), GuessInfo]);
                                                true ->
                                                    lib_server_send:send_to_uid(RoleId, pt_604, 60421, [?SUCCESS, GuessInfo])
                                            end;
                                        _ ->
                                            % lib_server_send:send_to_uid(RoleId, pt_604, 60400, [CostCode, []]),
                                            NewState = State
                                    end;
                                {error, Code} ->
                                    lib_server_send:send_to_uid(RoleId, pt_604, 60400, [Code, []]),
                                    NewState = State
                            end;
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_604, 60400, [?FAIL, []]),
                            NewState = State
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_604, 60400, [?FAIL, []]),
                    NewState = State
            end,
            {noreply, NewState};
        true ->
            lib_server_send:send_to_uid(RoleId, pt_604, 60400, [?ERRCODE(err604_not_guess_time), []]),
            {noreply, State}
    end;

do_handle_cast({get_my_guess_summary, RoleId}, State0) ->
    {MyCurRound, State} = try_init_role_guess(State0, RoleId),
    CurHasGuess
    = case MyCurRound of
        #guess_round{pairs = Pairs} ->
            case lists:any(fun (P) -> P#guess_pair.choose_role > 0 end, Pairs) of
                true ->
                    1;
                _ ->
                    0
            end;
        _ ->
            0
    end,
    #state{competitors = CompetitorPairs, guess_roles = Roles} = State,
    case lists:keyfind(RoleId, #guess_role.role_id, Roles) of
        #guess_role{guess_rounds = Rounds} = Role ->
            case lists:keyfind(0, #guess_round.setup_status, Rounds) of
                false ->
                    HasReward = calc_reward_status(Rounds),
                    lib_server_send:send_to_uid(RoleId, pt_604, 60422, [HasReward, CurHasGuess]),
                    {noreply, State};
                _ ->
                    Rounds1 = [init_round(Round, CompetitorPairs) || Round <- Rounds],
                    Role1 = Role#guess_role{guess_rounds = Rounds1},
                    HasReward = calc_reward_status(Rounds1),
                    lib_server_send:send_to_uid(RoleId, pt_604, 60422, [HasReward, CurHasGuess]),
                    Roles1 = lists:keystore(RoleId, #guess_role.role_id, Roles, Role1),
                    {noreply, State#state{guess_roles = Roles1}}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_604, 60422, [0, CurHasGuess]),
            {noreply, State}
    end;


do_handle_cast({get_role_guess_info, RoleId}, State) ->
    #state{competitors = CompetitorPairs, guess_roles = Roles, round = CurRound} = State,
    if
        CurRound > 0 ->
            TargetList = lists:seq(?MELEE_ROUND_NUM + 1, CurRound),
            case lists:keyfind(RoleId, #guess_role.role_id, Roles) of
                #guess_role{guess_rounds = Rounds} = Role ->
                    case lists:keyfind(0, #guess_round.setup_status, Rounds) of
                        false ->
                            RoundsArgs = convert_to_60423(Rounds, TargetList, []),
                            lib_server_send:send_to_uid(RoleId, pt_604, 60423, [RoundsArgs]),
                            {noreply, State};
                        _ ->
                            Rounds1 = [init_round(Round, CompetitorPairs) || Round <- Rounds],
                            Role1 = Role#guess_role{guess_rounds = Rounds1},
                            RoundsArgs = convert_to_60423(Rounds1, TargetList, []),
                            lib_server_send:send_to_uid(RoleId, pt_604, 60423, [RoundsArgs]),
                            Roles1 = lists:keystore(RoleId, #guess_role.role_id, Roles, Role1),
                            {noreply, State#state{guess_roles = Roles1}}
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_604, 60423, [[]]),
                    {noreply, State}
            end;
        true ->
            lib_server_send:send_to_uid(RoleId, pt_604, 60423, [[]]),
            {noreply, State}
    end;

do_handle_cast({get_guess_reward, RoleId, RoundId}, State) ->
    #state{guess_roles = Roles, cycle_index = CycleIndex} = State,
    case lists:keyfind(RoleId, #guess_role.role_id, Roles) of
        #guess_role{guess_rounds = Rounds} = Role ->
            case calc_gurss_rewards(Rounds, RoundId) of
                {error, Code} ->
                    lib_server_send:send_to_uid(RoleId, pt_604, 60400, [Code, []]),
                    {noreply, State};
                {NewRounds, ChangeRounds, [_|_] = Rewards} ->
                    case catch lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, lib_diamond_league, give_guess_rewards, [lib_goods_api:make_reward_unique(Rewards)]) of
                        ok ->
                            save_round(RoleId, ChangeRounds, CycleIndex),
                            Role2 = Role#guess_role{guess_rounds = NewRounds},
                            NewRoles = lists:keystore(RoleId, #guess_role.role_id, Roles, Role2),
                            lib_server_send:send_to_uid(RoleId, pt_604, 60424, [RoundId]),
                            {noreply, State#state{guess_roles = NewRoles}};
                        {false, Code} ->
                            {CodeInt, CodeArgs} = util:parse_error_code(Code),
                            lib_server_send:send_to_uid(RoleId, pt_604, 62400, [CodeInt, CodeArgs]),
                            {noreply, State};
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_604, 62400, [?ERRCODE(system_busy), []]),
                            {noreply, State}
                    end;
                _B ->
                    lib_server_send:send_to_uid(RoleId, pt_604, 62400, [?ERRCODE(err604_guess_reward_error), []]),
                    {noreply, State}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_604, 60400, [?ERRCODE(err604_guess_reward_error), []]),
            {noreply, State}
    end;

do_handle_cast({update_team_after_battle_end, {RoundId, PairId, WinId}}, State) ->
    #state{competitors = CompetitorPairs, guess_roles = Roles} = State,
    NewPairs
    = case lists:keyfind(PairId, 1, CompetitorPairs) of
        {PairId, RoleList} ->
            NewList = [R#league_role{win = if RoleId =:= WinId -> ?WIN_STATE_WIN; true -> ?WIN_STATE_LOSE end} || #league_role{role_id = RoleId} = R <- RoleList],
            lists:keystore(PairId, 1, CompetitorPairs, {PairId, NewList});
        _ ->
            CompetitorPairs
    end,
    NewRoles = update_guess_roles(Roles, {RoundId, PairId, WinId}, NewPairs),
    {noreply, State#state{competitors = NewPairs, guess_roles = NewRoles}};

do_handle_cast({get_guess_end_time, Sid}, #state{guess_end_time = GuessEndTime} = State) ->
    {ok, BinData} = pt_604:write(60428, [GuessEndTime]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    ?ERR("~p~n", [State]),
    {noreply, State}.

%% internal
init_pairs([#league_role{index = Index} = R|T], Acc) ->
    P = Index div 2,
    Acc1
    = case lists:keyfind(P, 1, Acc) of
        {P, L} ->
            L2 = lists:keystore(Index, #league_role.index, L, R),
            lists:keystore(P, 1, Acc, {P, L2});
        _ ->
            [{P, [R]}|Acc]
    end,
    init_pairs(T, Acc1);

init_pairs([], Acc) -> Acc.

try_init_role_guess(State, RoleId) ->
    #state{
        guess_roles = GuessRoleList, 
        competitors = CompetitorPairs, 
        round = RoundId, 
        cycle_index = CycleIndex
    } = State,
    %% 尝试加在数据库
    case lists:keyfind(RoleId, #guess_role.role_id, GuessRoleList) of
        false ->
            Role = load(RoleId, CompetitorPairs, CycleIndex),
            GuessRoleList1 = lists:keystore(RoleId, #guess_role.role_id, GuessRoleList, Role);
        Role ->
            GuessRoleList1 = GuessRoleList
    end,
    #guess_role{guess_rounds = Rounds} = Role,
    %% 尝试初始化当前阶段数据
    case lists:keyfind(RoundId, #guess_round.round_id, Rounds) of
        false ->  
            case init_role_round(RoleId, RoundId, CompetitorPairs, CycleIndex) of
                R when is_record(R, guess_round) ->
                    NewRounds = [R|Rounds],
                    Role2 = Role#guess_role{guess_rounds = NewRounds},
                    GuessRoleList2 = lists:keystore(RoleId, #guess_role.role_id, GuessRoleList1, Role2);
                _ ->
                    R = undefined,
                    GuessRoleList2 = GuessRoleList1
            end;
        #guess_round{setup_status = 0} = Round ->
            R = init_round(Round, CompetitorPairs),
            Rounds2 = lists:keystore(RoundId, #guess_round.round_id, Rounds, R),
            Role2 = Role#guess_role{guess_rounds = Rounds2},
            GuessRoleList2 = lists:keystore(RoleId, #guess_role.role_id, GuessRoleList1, Role2);
        R ->
            GuessRoleList2 = GuessRoleList1
    end,
    {R, State#state{guess_roles = GuessRoleList2}}.

load(RoleId, CompetitorPairs, CycleIndex) ->
    SQL = io_lib:format("SELECT `round_id`, `pairs`, `reward_is_got`, `price_id` FROM `diamond_league_guess` WHERE `role_id` = ~p AND `cycle_index` = ~p", [RoleId, CycleIndex]),
    All = db:get_all(SQL),
    Rounds = init_rounds(All, CompetitorPairs, []),
    #guess_role{role_id = RoleId, guess_rounds = Rounds}.

save_round(RoleId, #guess_round{round_id = RoundId, pairs = Pairs, reward_status = RewardStatus, price_id = PriceId}, CycleIndex) ->
    PairsDataStr = util:term_to_string(pairs_to_pair_data(Pairs)),
    SQL = io_lib:format("REPLACE INTO `diamond_league_guess` (`role_id`, `round_id`, `pairs`, `reward_is_got`, `price_id`, `cycle_index`) VALUES (~p, ~p, '~s', ~p, ~p, ~p)", [RoleId, RoundId, PairsDataStr, RewardStatus, PriceId, CycleIndex]),
    db:execute(SQL);
save_round(RoleId, [_|_] = Rounds, CycleIndex) ->
    Values = [begin PairsDataStr = util:term_to_string(pairs_to_pair_data(Pairs)), io_lib:format("(~p, ~p, '~s', ~p, ~p, ~p)", [RoleId, RoundId, PairsDataStr, RewardStatus, PriceId, CycleIndex]) end || #guess_round{round_id = RoundId, reward_status = RewardStatus, pairs = Pairs, price_id = PriceId} <- Rounds],
    ValuesStr = ulists:list_to_string(Values, ","),
    SQL = io_lib:format("REPLACE INTO `diamond_league_guess` (`role_id`, `round_id`, `pairs`, `reward_is_got`, `price_id`, `cycle_index`) VALUES ~s", [ValuesStr]),
    db:execute(SQL);

save_round(_, _, _) -> skip.

pairs_to_pair_data(Pairs) ->
    [{PairId, ChooseId} || #guess_pair{pair_id = PairId, choose_role = ChooseId} <- Pairs].

init_rounds([H|T], CompetitorPairs, Acc) ->
    [RoundId, PairsDataStr, RewardStatus, PriceId] = H,
    PairsData = util:bitstring_to_term(PairsDataStr),
    % Ts = [Team || Team <- Teams, Team#kf_chaotic_battle_team.round_id =:= RoundId],
    case fill_pairs(PairsData, CompetitorPairs, [], 1) of
        {SetupStatus, Pairs} ->
            R = #guess_round{round_id = RoundId, pairs = Pairs, setup_status = SetupStatus, reward_status = RewardStatus, price_id = PriceId},
            init_rounds(T, CompetitorPairs, [R|Acc]);
        _ ->
            init_rounds(T, CompetitorPairs, Acc)
    end;

init_rounds([], _, Acc) -> Acc.

fill_pairs([H|T], CompetitorPairs, Acc, SetupStatus) ->
    {PairId, ChooseId} = H,
    case lists:keyfind(PairId, 1, CompetitorPairs) of
        {PairId, RoleList} ->
            NewSetupStatus = SetupStatus band 1,
            fill_pairs(T, CompetitorPairs, [#guess_pair{pair_id = PairId, roles = RoleList, choose_role = ChooseId}|Acc], NewSetupStatus);
        _ ->
            NewSetupStatus = 0,
            fill_pairs(T, CompetitorPairs, [#guess_pair{pair_id = PairId, choose_role = ChooseId}|Acc], NewSetupStatus)
    end;

fill_pairs([], _, Acc, SetupStatus) ->
    {SetupStatus, Acc}.

init_role_round(RoleId, RoundId, CompetitorPairs, CycleIndex) ->
    case [Pair || {_, [#league_role{round = Round}, _|_]} = Pair <- CompetitorPairs, Round =:= RoundId] of
        [] ->
            [];
        AllPairs  ->
            ChoosePairs
            = if
                length(AllPairs) =< ?MAX_GUESS_COUNT ->
                    AllPairs;
                true ->
                    WeightList = [{100, P} || P <- AllPairs],
                    urand:list_rand_by_weight(WeightList, ?MAX_GUESS_COUNT)
            end,
            Round = #guess_round{round_id = RoundId, pairs = [#guess_pair{pair_id = PairId, roles = Roles} || {PairId, Roles} <- ChoosePairs]},
            save_round(RoleId, Round, CycleIndex),
            Round
    end.

init_round(#guess_round{setup_status = SetupStatus} = R, _) when SetupStatus > 0 ->
    R;

init_round(Round, CompetitorPairs) ->
    #guess_round{pairs = Pairs0} = Round,
    PairsData = pairs_to_pair_data(Pairs0),
    case fill_pairs(PairsData, CompetitorPairs, [], 1) of
        {SetupStatus, Pairs} ->
            Round#guess_round{pairs = Pairs, setup_status = SetupStatus};
        _ ->
            Round
    end.

do_send_reward_bg(#state{cycle_index = CycleIndex} = State) ->
    SQL = io_lib:format("SELECT `role_id`, `round_id`, `pairs`, `reward_is_got`, `price_id` FROM `diamond_league_guess` WHERE `reward_is_got`=0 AND `cycle_index`= ~p", [CycleIndex]),
    case db:get_all(SQL) of
        [] ->
            ok;
        All ->
            #state{competitors = CompetitorPairs} = State,
            F = fun
                ([RoleId, RoundId, PairsStr, RewardStatus, PriceId], Acc) ->
                    case lists:keyfind(RoleId, 1, Acc) of
                        {RoleId, List} ->
                            lists:keystore(RoleId, 1, Acc, {RoleId, [[RoundId, PairsStr, RewardStatus, PriceId]|List]});
                        _ ->
                            [{RoleId, [[RoundId, PairsStr, RewardStatus, PriceId]]}|Acc]
                    end
            end,
            RolesData = lists:foldl(F, [], All),
            F2 = fun
                ({RoleId, RoleData}) ->
                    Rounds = init_rounds(RoleData, CompetitorPairs, []),
                    #guess_role{role_id = RoleId, guess_rounds = Rounds}
            end,
            Roles = [F2(R) || R <- RolesData],
            F3 = fun
                (#guess_role{role_id = RoleId, guess_rounds = Rounds}) ->
                    case calc_gurss_rewards(Rounds, 0) of
                        {_, ChangeRounds, [_|_] = Rewards} ->
                            % {Title, Content} = data_diamond_league_text:get_guess_left_reward_mail(),
                            Title = utext:get(6040007),
                            Content = utext:get(6040008),
                            lib_mail_api:send_sys_mail([RoleId], Title, Content, lib_goods_api:make_reward_unique(Rewards)),
                            save_round(RoleId, ChangeRounds, CycleIndex),
                            timer:sleep(1000);
                        _ ->
                            ok
                    end
            end,
            spawn(fun
                () ->
                    [F3(R) || R <- Roles]
            end)
    end,
    State#state{competitors = [], guess_roles = []}.

calc_gurss_rewards(Rounds, 0) ->
    F = fun
        (Round, {RoundsAcc, ChangeAcc, RewardsAcc}) ->
            case Round of
                #guess_round{pairs = Pairs, reward_status = 0, price_id = PriceId} ->
                    case calc_pairs_result(Pairs, 0) of
                        {ok, Count} ->
                            case data_diamond_league:get_guess_reward(length(Pairs), Count, PriceId) of
                                [_|_] = Rewards ->
                                    Round2 = Round#guess_round{reward_status = 1},
                                    {[Round2|RoundsAcc], [Round2|ChangeAcc], Rewards ++ RewardsAcc};
                                _ ->
                                    {[Round|RoundsAcc], ChangeAcc, RewardsAcc}
                            end;
                        _ ->
                            {[Round|RoundsAcc], ChangeAcc, RewardsAcc}
                    end;
                _ ->
                    {[Round|RoundsAcc], ChangeAcc, RewardsAcc}
            end
    end,
    lists:foldl(F, {[], [], []}, Rounds);

calc_gurss_rewards(Rounds, RoundId) ->
    case lists:keyfind(RoundId, #guess_round.round_id, Rounds) of
        #guess_round{reward_status = 1} ->
            {error, ?ERRCODE(err604_guess_reward_is_got)};
        #guess_round{pairs = Pairs, price_id = PriceId} = Round->
            case calc_pairs_result(Pairs, 0) of
                {ok, Count} ->
                    case data_diamond_league:get_guess_reward(length(Pairs), Count, PriceId) of
                        [_|_] = Rewards ->
                            Round2 = Round#guess_round{reward_status = 1},
                            NewRounds = lists:keystore(RoundId, #guess_round.round_id, Rounds, Round2),
                            ChangeRounds = [Round2],
                            {NewRounds, ChangeRounds, Rewards};
                        _ ->
                            {error, ?ERRCODE(err604_guess_reward_error)}
                    end;
                _ ->
                    {error, ?ERRCODE(err604_guess_reward_error)}
            end;
        _ ->
            {error, ?ERRCODE(err604_guess_reward_error)}
    end.


calc_pairs_result([#guess_pair{roles = Roles, choose_role = ChooseId}|T], Count) ->
    case lists:any(fun
        (#league_role{win = WinState}) ->
            WinState =:= ?WIN_STATE_NONE
    end, Roles) of
        true ->
            {error, unfinish};
        _ ->
        case lists:keyfind(?WIN_STATE_WIN, #league_role.win, Roles) of
            #league_role{role_id = ChooseId} ->
                calc_pairs_result(T, Count + 1);
            false when ChooseId > 0 -> %% 两只队伍都失败了，竞猜者算赢
                calc_pairs_result(T, Count + 1);
            _ ->
                calc_pairs_result(T, Count)
        end
    end;

calc_pairs_result([], Count) -> {ok, Count}.

check_guess([{PairId, RoleId}|T], Pairs, Acc, Change, ChooseFlag) when RoleId > 0 ->
    case lists:keytake(PairId, #guess_pair.pair_id, Pairs) of
        {value, #guess_pair{roles = Roles, choose_role = ChooseId} = P, Others} ->
            if
                ChooseId =:= RoleId ->
                    check_guess(T, Others, [P|Acc], Change, ChooseFlag);
                true ->
                    case lists:keyfind(RoleId, #league_role.role_id, Roles) of
                        false ->
                            {error, ?ERRCODE(err604_guest_role_error)};
                        _ ->
                            check_guess(T, Others, [P#guess_pair{choose_role = RoleId}|Acc], 1, ChooseFlag bor ChooseId)
                    end
            end;
        _ ->
            check_guess(T, Pairs, Acc, Change, ChooseFlag)
    end;

check_guess([_|T], Pairs, Acc, Change, ChooseFlag) ->
    check_guess(T, Pairs, Acc, Change, ChooseFlag);

check_guess([], [], _, 0, _) -> {error, ?ERRCODE(err604_guess_no_change)};

check_guess([], [], Acc, 1, ChooseFlag) -> {ok, Acc, ChooseFlag};

check_guess([], [_|_], _, _, _) -> {error, ?ERRCODE(err604_any_guess_not_choosed)}.

log_guess(RoleId, Round, Op) ->
    #guess_round{round_id = RoundId, pairs = Pairs} = Round,
    RoundName = lib_diamond_league:get_round_name(RoundId),
    PairFormat = fun
        (#guess_pair{choose_role = ChooseId, roles = Roles}) ->
            ChooseName
            = case lists:keyfind(ChooseId, #league_role.role_id, Roles) of
                #league_role{data = #{figure := #league_figure{name = Name}}} ->
                    Name;
                _ ->
                    <<" ">>
            end,
            PairsName = [uio:format("{1}", [Name]) || #league_role{data = #{figure := #league_figure{name = Name}}} <- Roles],
            % PairsName = ulists:implode("-", [util:make_sure_list(Name) || #league_role{data = #{figure := #league_figure{name = Name}}} <- Roles]),
            uio:format("[{1},({2})]", [ulists:implode("-", PairsName), ChooseName])
            % io_lib:write("{[~s], ~s}", [PairsName, util:make_sure_list(ChooseName)])
    end,
    GuessInfoStr = ulists:implode("= =", [PairFormat(P) || P <- Pairs]),
    % GuessInfoStr = io_lib:write([PairFormat(P) || P <- Pairs], [{'encoding','unicode'}]),
    lib_log_api:log_diamond_league_guess(RoleId, RoundName, GuessInfoStr, Op, utime:unixtime()).


calc_reward_status([#guess_round{reward_status = 1}|T]) ->  %% 已经领取
    calc_reward_status(T);
calc_reward_status([#guess_round{pairs = Pairs, price_id = PriceId}|T]) ->
    case calc_pairs_result(Pairs, 0) of
        {ok, Count} ->
            AllCount = length(Pairs),
            case data_diamond_league:get_guess_reward(AllCount, Count, PriceId) of
                [_|_] ->
                    1;
                _ ->
                    calc_reward_status(T)
            end;
        _ ->
            calc_reward_status(T)
    end;

calc_reward_status([]) -> 0.

convert_to_60423(Rounds, [RoundId|T], Acc) ->
    case lists:keytake(RoundId, #guess_round.round_id, Rounds) of
        {value, R, Others} ->
            ok;
        _ ->
            R = #guess_round{round_id = RoundId},
            Others = Rounds
    end,
    #guess_round{price_id = PriceId, pairs = Pairs, reward_status = RewardStatus} = R,
    PairArgs = convert_to_60423_pair(Pairs),
    case calc_pairs_result(Pairs, 0) of
        {ok, Count} ->
            Status = if RewardStatus =:= 1 -> 2; true -> 1 end,
            Rewards = data_diamond_league:get_guess_reward(length(Pairs), Count, PriceId);
        _ ->
            Status = 0,
            Rewards = []
    end,
    Acc2 = [{RoundId, PriceId, Status, PairArgs, Rewards}|Acc],
    convert_to_60423(Others, T, Acc2);

convert_to_60423(_Rounds, [], Acc) -> Acc.

convert_to_60423_pair(Pairs) ->
    F = fun
        (#guess_pair{roles = Roles, choose_role = ChooseId}) ->
            WinId
            = case lists:any(fun
                (#league_role{win = WinState}) ->
                    WinState =:= ?WIN_STATE_NONE
            end, Roles) of
                true ->
                    0;
                _ ->
                    case lists:keyfind(?WIN_STATE_WIN, #league_role.win, Roles) of
                        #league_role{role_id = RoleId} ->
                            RoleId;
                        _ ->    %% 全败算赢
                            ChooseId
                    end
            end,
            case lists:keyfind(ChooseId, #league_role.role_id, Roles) of
                #league_role{data = Data} ->
                    #league_figure{sex = Sex, career = Career, pic = Pic, picvsn = PicVsn, turn = Turn} = maps:get(figure, Data, #league_figure{});
                _ ->
                    #league_figure{sex = Sex, career = Career, pic = Pic, picvsn = PicVsn, turn = Turn} = #league_figure{}
            end,
            {ChooseId, WinId, Sex, Career, Turn, Pic, PicVsn}
    end,
    [F(P) || P <- Pairs, P#guess_pair.choose_role > 0].

update_guess_roles(GuessRoleList, {RoundId, PairId, WinId}, CompetitorPairs) ->
    F = fun
        (Role) ->
            #guess_role{guess_rounds = Rounds} = Role,
            case lists:keyfind(RoundId, #guess_round.round_id, Rounds) of
                #guess_round{pairs = Pairs, setup_status = SetupStatus} = Round ->
                    if
                        SetupStatus =:= 0 ->
                            Round2 = init_round(Round, CompetitorPairs),
                            Rounds2 = lists:keystore(RoundId, #guess_round.round_id, Rounds, Round2),
                            Role#guess_role{guess_rounds = Rounds2};
                        true ->
                            case lists:keyfind(PairId, #guess_pair.pair_id, Pairs) of
                                #guess_pair{roles = RoleList} = P ->
                                    NewList = [R#league_role{win = if RoleId =:= WinId -> ?WIN_STATE_WIN; true -> ?WIN_STATE_LOSE end} || #league_role{role_id = RoleId} = R <- RoleList],
                                    P2 = P#guess_pair{roles = NewList},
                                    Pairs2 = lists:keystore(PairId, #guess_pair.pair_id, Pairs, P2),
                                    Round2 = Round#guess_round{pairs = Pairs2},
                                    Rounds2 = lists:keystore(RoundId, #guess_round.round_id, Rounds, Round2),
                                    Role#guess_role{guess_rounds = Rounds2};
                                _ ->
                                    Role
                            end
                    end;
                _ ->
                    Role
            end
    end,
    NewRoles = [F(R) || R <- GuessRoleList],
    NewRoles.