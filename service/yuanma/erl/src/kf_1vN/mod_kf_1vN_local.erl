%%%-----------------------------------
%%% @Module  : mod_kf_1vN_local
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN(本地)
%%%-----------------------------------
-module(mod_kf_1vN_local).

-include("common.hrl").
-include("def_module.hrl").
-include("kf_1vN.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("server.hrl").

%% API
-export([start_link/0, sign/8, sign_back/1, sign_info/1, get_act_info/2, enter/1, stage_change/5,
        quit/5, get_score_rank/4, get_def_rank/2, get_challenge_rank/2, get_rank/4, set_race_1_rank/1, 
        update_race_2_rank/3, get_def_daily_award/1, change_def_num_m/1, sync_state/1, set_sign_num/1,
        update_sign_power/2, send_area_msg/2,
        add_bet/1, send_bet_list/1, receive_bet_reward/2, set_bet_battle_result/5, send_top_info/3, set_top/3,
        send_top_info_from_other_server/6, send_top_info_on_top_server/6, send_top_info_back_to_cluster/5
    ]).
-export([gm_start_1/3, gm_start_2/2]).
-export([get_auction_stage/1, sync_auction_state/1]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(state, {
        stage=0,    %% 比赛阶段
        sub_stage=0,%% 比赛子阶段
        optime=0,   %% 此阶段开启时间
        edtime=0,   %% 此阶段结束时间
        sign_num=0, %% 报名人数
        def_num_m = #{}, %% 擂主人数
        sign_info = [], %% 本服报名名单 [{Id, 所属战区},....]
        last_sign_info = [],    %% 上次报名名单 [{Id, 所属战区},....],用于查看赛区信息
        race_1_rank_m = #{},     %% 资格赛排行榜 
        def_rank_m = #{},        %% 擂主排行榜 
        challenger_rank_m = #{}, %% 挑战者排行榜
        node = undefined,
        auction_stage=0,
        auction_edtime=0,
        bet_m = #{}         %% 竞猜信息 #{Id => [#kf_1vN_bet{},...]}
        , top_m = #{}       %% 上次擂主缓存 #{Area => {RoleId, 13013的协议, 时间}}
    }).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_act_info(Id, Sid) -> 
    gen_server:cast(?MODULE, {get_act_info, Id, Sid}).

sign(ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, ServerName) ->
    gen_server:cast(?MODULE, {sign, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, ServerName}).

sign_back(Id) -> 
    gen_server:cast(?MODULE, {sign_back, Id}).

sign_info(SignInfos) -> 
    gen_server:cast(?MODULE, {sign_info, SignInfos}).

enter(KfRole) -> 
    gen_server:cast(?MODULE, {enter, KfRole}).

stage_change(Stage, MatchTurn, EdTime, SubStage, SubEdTime) -> 
    gen_server:cast(?MODULE, {stage_change, Stage, MatchTurn, EdTime, SubStage, SubEdTime}).

quit(Id, CopyId, QuitType, Hp, HpLim) ->
    ?INFO("mod_kf_1vn role quilt:~p", [{Id, QuitType, Hp, HpLim}]),
    gen_server:cast(?MODULE, {quit, Id, CopyId, QuitType, Hp, HpLim}).

get_score_rank(Id, Sid, Lv, CArea) -> 
    gen_server:cast(?MODULE, {get_score_rank, Id, Sid, Lv, CArea}).

get_def_rank(Id, Sid) -> 
    gen_server:cast(?MODULE, {get_def_rank, Id, Sid}).

get_challenge_rank(Id, Sid) -> 
    gen_server:cast(?MODULE, {get_challenge_rank, Id, Sid}).

get_rank(Id, Sid, Lv, CArea) -> 
    gen_server:cast(?MODULE, {get_rank, Id, Sid, Lv, CArea}).

get_def_daily_award(Id) -> 
    gen_server:cast(?MODULE, {get_def_daily_award, Id}).

set_race_1_rank(ShortRankM) -> 
    gen_server:cast(?MODULE, {set_race_1_rank, ShortRankM}).

update_race_2_rank(Area, DefRank, ChallengerRank) -> 
    gen_server:cast(?MODULE, {update_race_2_rank, Area, DefRank, ChallengerRank}).

change_def_num_m(DefNumM) -> 
    gen_server:cast(?MODULE, {change_def_num_m, DefNumM}).

sync_state(Args) -> 
    gen_server:cast(?MODULE, {sync_state, Args}).

get_auction_stage(Id) -> 
    gen_server:cast(?MODULE, {get_auction_stage, Id}).

sync_auction_state(Args) -> 
    gen_server:cast(?MODULE, {sync_auction_state, Args}).

set_sign_num(Num) -> 
    gen_server:cast(?MODULE, {set_sign_num, Num}).

gm_start_1(SignTime, Race1PreTime, Race1Time) -> 
    gen_server:cast(?MODULE, {gm_start_1, SignTime, Race1PreTime, Race1Time}).

gm_start_2(Race2PreTime, Race2Time) -> 
    gen_server:cast(?MODULE, {gm_start_2, Race2PreTime, Race2Time}).

update_sign_power(Id, Power) ->
    gen_server:cast(?MODULE, {update_sign_power, Id, Power}).

%% 发送赛区信息
send_area_msg(Area, BinData) ->
    gen_server:cast(?MODULE, {send_area_msg, Area, BinData}).

%% 增加竞猜
add_bet(Bet) ->
    gen_server:cast(?MODULE, {add_bet, Bet}).

%% 查看竞猜记录
send_bet_list(RoleId) ->
    gen_server:cast(?MODULE, {send_bet_list, RoleId}).

%% 领取竞猜奖励
receive_bet_reward(RoleId, Key) ->
    gen_server:cast(?MODULE, {receive_bet_reward, RoleId, Key}).

%% 设置竞猜战斗结果
set_bet_battle_result(RoleId, BattleId, BetTime, BattleResult, BetResult) ->
    gen_server:cast(?MODULE, {set_bet_battle_result, RoleId, BattleId, BetTime, BattleResult, BetResult}).

%% 请求最强王者
send_top_info(RoleId, Lv, Area) ->
    gen_server:cast(?MODULE, {send_top_info, RoleId, Lv, Area}).

set_top(Area, RoleId, BinData) ->
    gen_server:cast(?MODULE, {set_top, Area, RoleId, BinData}).

init([]) ->
    %erlang:send_after(5000, self(), 'get_state'),
    Node = mod_disperse:get_clusters_node(),
%%    spawn(fun() ->
%%        timer:sleep(15000),
%%        mod_clusters_node:apply_cast(mod_kf_1vN, sync_state, [Node]),
%%        mod_clusters_node:apply_cast(mod_kf_1vN_auction, sync_auction_state, [Node, 0])
%%    end),
    BetM = lib_kf_1vN:get_bet_map(),
    LastSignInfo = lib_kf_1vN:get_last_sign_list(),
    {ok, #state{stage=?KF_1VN_FREE, node=Node, bet_m=BetM, last_sign_info=LastSignInfo}}.


handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("Handle request[~p] error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, _State) ->
    ?ERR("Handle unkown request[~p]~n", [_Request]),
    {ok, ok}.


handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle msg[~p] error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({gm_start_1, SignTime, Race1PreTime, Race1Time}, State) ->
    mod_clusters_node:apply_cast(mod_kf_1vN_mgr, gm_start_1, [SignTime, Race1PreTime, Race1Time]),
    % 报名期间清理数据
    lib_kf_1vN:db_clean_sign(),
    {noreply, State#state{sign_num=0, def_num_m=#{}, sign_info=[]}};

do_handle_cast({gm_start_2, Race2PreTime, Race2Time}, State) ->
    mod_clusters_node:apply_cast(mod_kf_1vN_mgr, gm_start_2, [Race2PreTime, Race2Time]),
    {noreply, State};


do_handle_cast({set_race_1_rank, RankM}, State) ->
    {noreply, State#state{race_1_rank_m=RankM}};

do_handle_cast({update_race_2_rank, Area, DefRank, ChallengerRank}, State) -> 
    #state{def_rank_m=DefRankM, challenger_rank_m=ChallengerRankM} = State,
    DefRankM1 = DefRankM#{Area => DefRank},
    ChallengerRankM1 = ChallengerRankM#{Area => ChallengerRank},
    {noreply, State#state{def_rank_m=DefRankM1, challenger_rank_m=ChallengerRankM1}};

do_handle_cast({get_score_rank, Id, Sid, Lv, CArea}, State) ->
    Area = case CArea of
        0 -> 
            case lists:keyfind(Id, 1, State#state.sign_info) of
                {_, TmpArea} when TmpArea > 0 -> TmpArea;
                _ ->
                    case lists:keyfind(Id, 1, State#state.last_sign_info) of
                        {_, TmpArea} when TmpArea > 0 -> TmpArea;
                        _ -> data_kf_1vN:get_area(Lv)
                    end
            end;
        _ -> CArea
    end,
    Ranks = maps:get(Area, State#state.race_1_rank_m, []),
    Ranks1 = [{
            E#kf_1vN_score_rank.rank, E#kf_1vN_score_rank.id, E#kf_1vN_score_rank.platform, E#kf_1vN_score_rank.server_num, E#kf_1vN_score_rank.server_name, 
            E#kf_1vN_score_rank.name, E#kf_1vN_score_rank.guild_name, E#kf_1vN_score_rank.vip, E#kf_1vN_score_rank.score, E#kf_1vN_score_rank.win, 
            E#kf_1vN_score_rank.lose, E#kf_1vN_score_rank.n_combat_power, E#kf_1vN_score_rank.career, E#kf_1vN_score_rank.lv} || E <- Ranks], 
    {ok, BinData} = pt_621:write(62110, [Area, Ranks1]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

do_handle_cast({get_def_rank, Id, Sid}, State) -> 
    case lists:keyfind(Id, 1, State#state.sign_info) of
        false -> skip;
        {_, Area} -> 
            Ranks = maps:get(Area, State#state.def_rank_m, []),
            Ranks1 = [{
                    E#kf_1vN_def_rank.rank, E#kf_1vN_def_rank.id, E#kf_1vN_def_rank.platform, E#kf_1vN_def_rank.server_num, E#kf_1vN_def_rank.name, E#kf_1vN_def_rank.guild_name, 
                    E#kf_1vN_def_rank.vip, E#kf_1vN_def_rank.score, E#kf_1vN_def_rank.race_2_turn, E#kf_1vN_def_rank.race_2_lose, E#kf_1vN_def_rank.n_combat_power, 
                    E#kf_1vN_def_rank.race_2_time} || E <- Ranks],
%%            ?PRINT("62114 ~p~n", [{Area, Ranks1}]),
            {ok, BinData} = pt_621:write(62114, [Ranks1]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};

do_handle_cast({get_challenge_rank, Id, Sid}, State) -> 
    case lists:keyfind(Id, 1, State#state.sign_info) of
        false -> skip;
        {_, Area} -> 
            Ranks = maps:get(Area, State#state.challenger_rank_m, []),
            Ranks1 = [{
                    E#kf_1vN_challenger_rank.rank, E#kf_1vN_challenger_rank.id, E#kf_1vN_challenger_rank.server_num, E#kf_1vN_challenger_rank.name, E#kf_1vN_challenger_rank.guild_name, E#kf_1vN_challenger_rank.vip,
                    E#kf_1vN_challenger_rank.score, E#kf_1vN_challenger_rank.n_combat_power, E#kf_1vN_challenger_rank.career} || E <- Ranks], 
            {ok, BinData} = pt_621:write(62115, [Ranks1]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};

do_handle_cast({get_rank, Id, Sid, Lv, CArea}, State) -> 
    Area = case CArea of
        0 -> 
            case lists:keyfind(Id, 1, State#state.sign_info) of
                {_, TmpArea} when TmpArea > 0 -> TmpArea;
                _ ->
                    case lists:keyfind(Id, 1, State#state.last_sign_info) of
                        {_, TmpArea} when TmpArea > 0 -> TmpArea;
                        _ -> data_kf_1vN:get_area(Lv)
                    end
            end;
        _ -> CArea
    end,
    Ranks = maps:get(Area, State#state.def_rank_m, []),
    Ranks1 = [{
            E#kf_1vN_def_rank.rank, E#kf_1vN_def_rank.server_id, E#kf_1vN_def_rank.id, E#kf_1vN_def_rank.platform, E#kf_1vN_def_rank.server_num, E#kf_1vN_def_rank.server_name, 
            E#kf_1vN_def_rank.name, E#kf_1vN_def_rank.guild_name, E#kf_1vN_def_rank.vip, E#kf_1vN_def_rank.score, E#kf_1vN_def_rank.race_2_turn, E#kf_1vN_def_rank.n_combat_power, 
            E#kf_1vN_def_rank.career, E#kf_1vN_def_rank.race_2_time, E#kf_1vN_def_rank.race_2_lose, E#kf_1vN_def_rank.lv, E#kf_1vN_def_rank.hp, E#kf_1vN_def_rank.hp_lim} || E <- Ranks],
%%    ?PRINT("62116 ~p~n", [{Area, Ranks1}]),
    {ok, BinData} = pt_621:write(62116, [Area, Ranks1, []]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

% do_handle_cast({get_def_daily_award, Id}, State) -> 
%     case lists:keyfind(Id, 1, State#state.sign_info) of
%         false -> skip;
%         {_, Area} -> 
%             Ranks = maps:get(Area, State#state.def_rank_m, []),
%             case lists:keyfind(Id, #kf_1vN_def_rank.id, Ranks) of
%                 false -> skip;
%                 #kf_1vN_def_rank{rank=Rank} -> skip
%             end
%     end,
%     {noreply, State};

do_handle_cast({get_act_info, Id, Sid}, State) -> 
    #state{sign_num=SignNum, def_num_m=DefNumM, sign_info=SignInfo} = State,
    IsSign = case lists:keyfind(Id, 1, SignInfo) of
        false -> Area=0, 0; 
        {_, Area} -> 1
    end,
    DefNum = maps:get(Area, DefNumM, 0),
%%    ?PRINT("DefNum ~w~n", [DefNum]),
    {ok, BinData} = pt_621:write(62100, [IsSign, SignNum, DefNum, Area]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

do_handle_cast({sign, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, SerName}, State) ->
    case State#state.stage of
        ?KF_1VN_SIGN -> 
            mod_clusters_node:apply_cast(mod_kf_1vN, sign, [State#state.node, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, SerName]);
        _ -> 
            {ok, BinData} = pt_621:write(62102, [?ERRCODE(err621_battle_is_end)]),
            lib_server_send:send_to_uid(Id, BinData)
    end,
    {noreply, State};

do_handle_cast({update_sign_power, Id, Power}, State) ->
    case State#state.stage of
        ?KF_1VN_SIGN ->
            case lists:keyfind(Id, 1, State#state.sign_info) of
                false -> skip;
                _ ->
                    mod_clusters_node:apply_cast(mod_kf_1vN, update_sign_info, [Id, [{power, Power}]])
            end;
        _ -> skip
    end,
    {noreply, State};

do_handle_cast({sign_back, Id}, State) ->
    #state{sign_info=SignInfo} = State,
    lib_kf_1vN:db_save_sign(Id),
    {noreply, State#state{sign_info=[{Id, 0}|lists:keydelete(Id, 1, SignInfo)]}};

do_handle_cast({set_sign_num, Num}, State) ->
    % #state{sign_num=SignNum} = State,
    {noreply, State#state{sign_num=Num}}; 

do_handle_cast({sign_info, SignInfos}, State) ->
    {noreply, State#state{sign_info=SignInfos}};

do_handle_cast({enter, KfRole}, State) -> 
    % ?MYLOG("lzh1vn", "enter Stage:~p ~n", [State#state.stage]),
    case State#state.stage >= ?KF_1VN_RACE_1_PRE of
        true  -> mod_clusters_node:apply_cast(mod_kf_1vN, enter, [State#state.node, KfRole]);
        false -> skip
    end,
    {noreply, State};

do_handle_cast({stage_change, Stage, MatchTurn, EdTime, SubStage, SubEdTime}, State) ->
    OpenDayLimit = data_kf_1vN_m:get_config(open_day),
    case util:get_open_day() >= OpenDayLimit of
        false -> {noreply, State};
        true  -> 
            {ok, BinData} =  pt_621:write(62101, [Stage, MatchTurn, EdTime, SubStage, SubEdTime]),
            lib_server_send:send_to_all(BinData),
            case Stage of
                ?KF_1VN_RACE_1_PRE -> 
                    lib_chat:send_TV({all}, ?MOD_KF_1VN, 1, []),
                    lib_activitycalen_api:success_start_activity(?MOD_KF_1VN),
                    mod_activity_onhook:act_enter(?MOD_KF_1VN, 0, [Id || {Id, _} <- State#state.sign_info]),
                    % 清理战魂商城兑换
                    lib_kf_1vN:clear_exchange_counter(),
                    % 自动发送押注奖励
                    auto_send_bet_reward(State),
                    ok;
                ?KF_1VN_RACE_2_PRE -> 
                    lib_chat:send_TV({all}, ?MOD_KF_1VN, 10, []);
                ?KF_1VN_RACE_2 ->
                    lib_chat:send_TV({all}, ?MOD_KF_1VN, 2, []);
                ?KF_1VN_FREE -> 
                    lib_activitycalen_api:success_end_activity(?MOD_KF_1VN);
                _ -> skip
            end,
            case Stage of
                ?KF_1VN_RACE_1_PRE ->
                    {noreply, State#state{stage=Stage, sub_stage=SubStage, edtime=EdTime, bet_m=#{}}};
                ?KF_1VN_SIGN -> 
                    lib_kf_1vN:clean_1vn(),
                    SignList = lib_kf_1vN:get_sign_list(),
                    Node = mod_disperse:get_clusters_node(),
                    #state{bet_m=BetM, last_sign_info=LastSignInfo}=State,
                    {noreply, #state{stage=Stage, sub_stage=SubStage, edtime=EdTime, sign_info=SignList, last_sign_info=LastSignInfo, node=Node, bet_m=BetM}};
                ?KF_1VN_FREE -> 
                    #state{sign_info=SignInfo}=State,
                    lib_kf_1vN:db_clean_sign(),
                    lib_kf_1vN:db_clean_last_sign(),
                    lib_kf_1vN:db_save_last_sign(SignInfo),
                    {noreply, State#state{stage=Stage, sub_stage=SubStage, edtime=EdTime, sign_num=0, def_num_m=#{}, sign_info=[], last_sign_info=SignInfo}};
                _ -> 
                    {noreply, State#state{stage=Stage, sub_stage=SubStage, edtime=EdTime}}
            end
    end;

do_handle_cast({change_def_num_m, DefNumM}, State) ->
    {noreply, State#state{def_num_m=DefNumM}};

do_handle_cast({quit, Id, CopyId, QuitType, Hp, HpLim}, State) -> 
    mod_clusters_node:apply_cast(mod_kf_1vN, quit, [State#state.node, Id, CopyId, QuitType, Hp, HpLim]),
    {noreply, State};

do_handle_cast({sync_state, [Stage, SubStage, OpTime, EdTime, SignNum, DefNumM, DefRankM, Race1RankM]}, State) ->
    OpenDayLimit = data_kf_1vN_m:get_config(open_day),
    case util:get_open_day() >= OpenDayLimit of
        false -> {noreply, State#state{def_rank_m=DefRankM}};
        true  -> 
            NewState = State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sign_num=SignNum, def_num_m=DefNumM, def_rank_m=DefRankM, race_1_rank_m=Race1RankM},
            {noreply, NewState}
    end;

do_handle_cast({get_auction_stage, Id}, State) -> 
    #state{auction_stage=Stage, auction_edtime=EdTime} = State,
    {ok, BinData} = pt_621:write(62129, [Stage, EdTime]),
    lib_server_send:send_to_uid(Id, BinData),
    {noreply, State};

do_handle_cast({sync_auction_state, [Stage, EdTime, Broadcast]}, State) -> 
    case Broadcast of
        1 -> 
            {ok, BinData} = pt_621:write(62129, [Stage, EdTime]),
            lib_server_send:send_to_all(BinData);
        _ -> skip
    end,
    {noreply,State#state{auction_stage=Stage, auction_edtime=EdTime}};

do_handle_cast({send_area_msg, Area, BinData}, State) ->
    #state{sign_info=SignList} = State,
    % ?MYLOG("hjhpk", "send_area_msg Area:~p SignList:~p ~n", [Area, SignList]),
    OpenDayLimit = data_kf_1vN_m:get_config(open_day),
    case util:get_open_day() >= OpenDayLimit of
        false -> {noreply, State};
        true  -> 
            F = fun({RoleId, TmpArea}, ExcList) -> 
                case TmpArea == Area of
                    true -> lib_server_send:send_to_uid(RoleId, BinData);
                    false -> skip
                end,
                [RoleId|ExcList]
            end,
            ExcList = lists:foldl(F, [], SignList),
            mod_chat_agent:send_msg([{kf_1vn_area, ExcList, Area, BinData}]),
            {noreply, State}
    end;

do_handle_cast({add_bet, Bet}, State) ->
    lib_kf_1vN:db_save_bet(Bet),
    #state{bet_m=BetM} = State,
    #kf_1vN_bet{key=Key, role_id=RoleId} = Bet,
    BetL = maps:get(RoleId, BetM, []),
    NewBetL = lists:keystore(Key, #kf_1vN_bet.key, BetL, Bet),
    NewBetM = maps:put(RoleId, NewBetL, BetM),
    % ?MYLOG("hjhkf1vn", "add_bet Bet:~p ~n", [Bet]),
    {noreply, State#state{bet_m=NewBetM}};

do_handle_cast({set_bet_battle_result, RoleId, BattleId, BetTime, BattleResult, BetResult}, State) ->
    #state{bet_m=BetM} = State,
    BetL = maps:get(RoleId, BetM, []),
    <<Key:48>> = <<BattleId:16, BetTime:32>>,
    case lists:keyfind(Key, #kf_1vN_bet.key, BetL) of
        #kf_1vN_bet{status = ?KF_1VN_BET_STATUS_NO} = Bet ->
            NewBet = Bet#kf_1vN_bet{battle_result=BattleResult, bet_result=BetResult, status=?KF_1VN_BET_STATUS_NOT_GET},
            lib_kf_1vN:db_save_bet(NewBet),
            NewBetL = lists:keystore(Key, #kf_1vN_bet.key, BetL, NewBet),
            NewBetM = maps:put(RoleId, NewBetL, BetM),
            % ?MYLOG("hjhkf1vn", "set_bet_battle_result BattleId:~p BetTime:~p winBet:~p ~n", [BattleId, BetTime, NewBet]),
            {noreply, State#state{bet_m=NewBetM}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({send_bet_list, RoleId}, State) ->
    #state{stage=Stage, bet_m=BetM} = State,
    BetL = maps:get(RoleId, BetM, []),
    F = fun(Bet, List) ->
        #kf_1vN_bet{key=Key, race_2_turn=Turn, platform=Platform, server_num=ServerNum, name=Name,
            bet_cost_type=BetCostType, bet_result=BetResult, status=Status} = Bet,
        BetR = if
            BetResult > 0 -> BetResult;
            Stage == ?KF_1VN_FREE -> 2; %% 猜对,空闲期还没结算就默认为猜对
            true -> 0
        end,
        case BetR > 0 of
            true -> [{Key, Platform, ServerNum, Name, Turn, BetCostType, BetR, Status}|List];
            false -> List
        end
    end,
    List = lists:foldl(F, [], BetL),
    %?MYLOG("lzhbet", "send_bet_list List:~p BetM:~p ~n", [List, BetM]),
    {ok, BinData} = pt_621:write(62133, [List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({receive_bet_reward, RoleId, Key}, State) ->
    case check_receive_bet_reward(State, RoleId, Key) of
        {false, ErrCode} ->
            {ok, BinData} = pt_621:write(62132, [ErrCode, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State};
        {true, Bet, BetR, Reward} ->
            #state{bet_m=BetM} = State,
            BetL = maps:get(RoleId, BetM, []),
            #kf_1vN_bet{race_2_turn=Turn, battle_id=BattleId, bet_time=BetTime, battle_result=BattleResult, bet_cost_type=CostType, bet_opt_no=BetOpt} = Bet,
            NewBet = Bet#kf_1vN_bet{status=?KF_1VN_BET_STATUS_HAD_GET},
            lib_kf_1vN:db_save_bet(NewBet),
            lib_log_api:log_kf_1vn_bet_receive(RoleId, Turn, BattleId, BetTime, BattleResult, CostType, BetOpt, BetR, Reward),
            Remark = lists:concat(["CostType:", CostType, ",BetOpt:", BetOpt, ",BetR:", BetR]),
            Produce = #produce{type = kf_1vn_bet, reward = Reward, remark=Remark, show_tips=?SHOW_TIPS_3},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            NewBetL = lists:keystore(Key, #kf_1vN_bet.key, BetL, NewBet),
            NewBetM = maps:put(RoleId, NewBetL, BetM),
            {ok, BinData} = pt_621:write(62134, [Key]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State#state{bet_m=NewBetM}}
    end;

do_handle_cast({send_top_info, RoleId, Lv, CArea}, #state{stage=Stage} = State) ->
    Area = case CArea of
        0 -> 
            case lists:keyfind(RoleId, 1, State#state.sign_info) of
                {_, TmpArea} when TmpArea > 0 -> TmpArea;
                _ ->
                    case lists:keyfind(RoleId, 1, State#state.last_sign_info) of
                        {_, TmpArea} when TmpArea > 0 -> TmpArea;
                        _ -> data_kf_1vN:get_area(Lv)
                    end
            end;
        _ -> CArea
    end,
    Ranks = maps:get(Area, State#state.def_rank_m, []),
    % TODO:优化,最强王者记录在进程中,防止打开界面过多请求
    case lists:keyfind(1, #kf_1vN_def_rank.rank, Ranks) of
        _ when Stage =/= ?KF_1VN_FREE andalso Stage =/= ?KF_1VN_END -> skip;
        false -> skip;
        #kf_1vN_def_rank{server_id=ServerId, id=TopId} = _DefRank ->
            NowTime = utime:unixtime(),
            case maps:get(Area, State#state.top_m, false) of
                {TopId, BinData, LastTime} when NowTime =< LastTime+3600 -> lib_server_send:send_to_uid(RoleId, BinData);
                _ ->
                    Node = mod_disperse:get_clusters_node(), 
                    mod_clusters_node:apply_cast(?MODULE, send_top_info_from_other_server, [ServerId, TopId, ?MOD_KF_1VN, Node, RoleId, Area])
            end
    end,
    {noreply, State};

do_handle_cast({set_top, Area, RoleId, BinData}, State) ->
    % ?MYLOG("hjhtop", "set_top Area:~p RoleId:~p BinData:~p ~n", [Area, RoleId, BinData]),
    #state{top_m = TopM} = State,
    NewTopM = maps:put(Area, {RoleId, BinData, utime:unixtime()}, TopM),
    NewState = State#state{top_m = NewTopM},
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    ?ERR("Handle unkown msg[~p]~n", [_Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle info[~p] error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~p]~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% -----------------------------------------------------------------
%% cast call info 函数调用
%% -----------------------------------------------------------------

%% 自动发送押注奖励
auto_send_bet_reward(State) ->
    #state{bet_m=BetM} = State,
    lib_kf_1vN:db_clean_bet(),
    F = fun(RoleId, BetL, Acc) ->
        F2 = fun(#kf_1vN_bet{key = Key}, SumReward) ->
            case check_receive_bet_reward(State, RoleId, Key) of
                {false, _ErrCode} -> SumReward;
                {true, Bet, BetR, Reward} ->
                    #kf_1vN_bet{race_2_turn=Turn, battle_id=BattleId, bet_time=BetTime, battle_result=BattleResult, bet_cost_type=CostType, bet_opt_no=BetOpt} = Bet,
                    lib_log_api:log_kf_1vn_bet_receive(RoleId, Turn, BattleId, BetTime, BattleResult, CostType, BetOpt, BetR, Reward),
                    Reward++SumReward
            end
        end,
        Reward = lists:foldl(F2, [], BetL),
        UqReward = lib_goods_api:make_reward_unique(Reward),
        case UqReward == [] of
            true -> skip;
            false -> lib_mail_api:send_sys_mail([RoleId], utext:get(6210011), utext:get(6210012), UqReward)
        end,
        Acc
    end,
    maps:fold(F, ok, BetM).

%% 检查领取
check_receive_bet_reward(State, RoleId, Key) ->
    #state{stage=Stage, bet_m=BetM} = State,
    BetL = maps:get(RoleId, BetM, []),
    case lists:keyfind(Key, #kf_1vN_bet.key, BetL) of
        false -> {false, ?MISSING_CONFIG};
        % #kf_1vN_bet{status = ?KF_1VN_BET_STATUS_NO} -> {false, ?ERRCODE(err621_not_result_to_get_bet_reward)};
        #kf_1vN_bet{status = ?KF_1VN_BET_STATUS_HAD_GET} -> {false, ?ERRCODE(err621_had_get_bet_reward)};
        Bet ->
            #kf_1vN_bet{race_2_turn=Turn, bet_cost_type=BetCostType, bet_result=BetResult} = Bet,
            BetR = if
                % BattleResult > 0 andalso BattleResult == BetSide -> 2; %% 猜对
                % BattleResult > 0 -> 1; %% 猜错
                BetResult > 0 -> BetResult;
                Stage == ?KF_1VN_FREE -> 2; %% 猜对,空闲期还没结算就默认为猜对
                true -> 0
            end,
            KvList = data_kf_1vN:get_cost_list(Turn),
            case lists:keyfind(BetCostType, 1, KvList) of
                false -> WinReward = [], LoseReward = [];
                {_BetCostType, _Cost, WinReward, LoseReward} -> ok
            end,
            Reward = if
                BetR == 2 -> WinReward;
                true -> LoseReward
            end,
            case BetR > 0 of
                true -> {true, Bet, BetR, Reward};
                false -> {false, ?ERRCODE(err621_not_result_to_get_bet_reward)}
            end
    end.

%% 从别的服发送霸主信息
send_top_info_from_other_server(ServerId, RoleId, ModId, Node, ToId, Area) ->
    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, 
        [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, send_top_info_on_top_server, [ServerId, ModId, Node, ToId, Area]]).

%% 在霸主玩家服处理玩家数据,返回给跨服中心
send_top_info_on_top_server(Player, ServerId, ModId, Node, ToId, Area) ->
    #player_status{id = Id, figure = Figure, combat_power = Power, server_name = ServerName, server_num = ServerNum} = Player,
    {ok, BinData} = pt_130:write(13013, [ServerId, ServerNum, Id, ModId, Power, Figure, ServerName]),
    mod_clusters_node:apply_cast(?MODULE, send_top_info_back_to_cluster, [ServerId, Node, ToId, BinData, Area]).

%% 跨服中心处理
send_top_info_back_to_cluster(ServerId, Node, ToId, BinData, Area) ->
    lib_server_send:send_to_uid(Node, ToId, BinData),
    mod_clusters_center:apply_cast(ServerId, mod_kf_1vN_local, set_top, [Area, ToId, BinData]),
    ok.