%%%-----------------------------------
%%% @Module  : mod_kf_1vN
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN数据进程(跨服中心)
%%%-----------------------------------
-module(mod_kf_1vN).

-include("common.hrl").
-include("kf_1vN.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("server.hrl").

-compile(export_all).

-define(EXP_ADD_TIME, 10000). %% 增加经验间隔
-define(WATCH_MAX_NUM, 100).  %% 单场战斗观战人数上限

%% API
-export([start_link/0, sign/9, enter/2, stage_change/4, quit/6, get_banner/2,
        update_role/3, exit_pk/2, get_bet_list/2, bet_battle/8,
        race_2_pk_result/8, get_race_2_rank_top/2, watch/4, update_sign_info/2
        ,get_sign_list/3, to_62105_battle/1
    ]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(state, {
        gm_lock = 0,
        ac_id = 0,
        stage = 0,
        sub_stage = 0,
        optime = 0,
        edtime = 0,
        sub_edtime = 0,
        bet_time = 0,       %% 竞猜时间,进入擂主赛准备时间就记录,用于作为本轮竞猜的主键
        area_list=[],
        max_scene_pool=0,
        scene_pool_m = #{}, %% 赛区区分(暂时不用) #{Area => {MinScenePoolId, MaxScenePoolId}}
        sign_num = 0,
        sign_list = [],      %% 报名信息 [{Id1, Lv},...]
        role_m = #{},        %% 参加玩家信息（全区域) #{Area1 => [#kf_1vN_role{},...],...}
        race_1_rank_m = #{}, %% 资格赛排行榜（全区域) #{Area1 => [#kf_1vN_score_rank{},...],...}
        race_2_m = #{},      %% 挑战赛信息（全区域) #{Area1 => [#kf_1vN_race_2{},...],...}
        def_num_m=#{},
        seed_num_m=#{},
        match_time = 0,
        battle_time = 0,
        match_ref=undefined,
        match_turn = 1,
        last_match_time=0,
        exp_ref=undefined,
        sorted_sign_list = undefined,   %% 有序的报名信息
        max_power = 10000000
        , ser_info_list = []    %% 服信息列表 [{Platform, ServerNum, ServerName},...]
    }).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

sync_state(Node) -> gen_server:cast(?MODULE, {sync_state, Node}).

sign(Node, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, ServerName) -> gen_server:cast(?MODULE, {sign, Node, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, ServerName}).

update_sign_info(Id, Args) -> gen_server:cast(?MODULE, {update_sign_info, Id, Args}).

get_stage_info(Node, Id) -> gen_server:cast(?MODULE, {get_stage_info, Node, Id}).

enter(Node, KfRole) -> gen_server:cast(?MODULE, {enter, Node, KfRole}).

stage_change(Stage, OpTime, EdTime, AcId) -> gen_server:cast(?MODULE, {stage_change, Stage, OpTime, EdTime, AcId}).

quit(Node, Id, CopyId, QuitType, Hp, HpLim) -> gen_server:cast(?MODULE, {quit, Node, Id, CopyId, QuitType, Hp, HpLim}).

get_banner(Node, Id) -> gen_server:cast(?MODULE, {get_banner, Node, Id}).

update_role(Area, Id, KeyList) -> gen_server:cast(?MODULE, {update_role, Area, Id, KeyList}).

exit_pk(Area, Id) -> gen_server:cast(?MODULE, {exit_pk, Area, Id}).

race_2_pk_result(BattleId, DefIsWin, Area, Id, CombatPower, Hp, HpLim, LiveNum) -> gen_server:cast(?MODULE, {race_2_pk_result, BattleId, DefIsWin, Area, Id, CombatPower, Hp, HpLim, LiveNum}).

get_bet_list(Node, Id) -> gen_server:cast(?MODULE, {get_bet_list, Node, Id}).

get_sign_list(Node, Id, MyPower) -> gen_server:cast(?MODULE, {get_sign_list, Node, Id, MyPower}).

bet_battle(Node, ServerId, Id, RoleName, ClientTurn, BattleId, OptNo, CostType) -> gen_server:cast(?MODULE, {bet_battle, Node, ServerId, Id, RoleName, ClientTurn, BattleId, OptNo, CostType}).

get_race_2_rank_top(Node, Id) -> gen_server:cast(?MODULE, {get_race_2_rank_top, Node, Id}).

watch(Node, ServerId, Id, BattleId) -> gen_server:cast(?MODULE, {watch, Node, ServerId, Id, BattleId}).

gm_start_1() -> gen_server:cast(?MODULE, {gm_start_1}).

gm_clear_user() -> gen_server:cast(?MODULE, {gm_clear_user}).

gm_open_lock() -> gen_server:cast(?MODULE, {gm_open_lock}).

print() -> gen_server:cast(?MODULE, {print}).

init([]) ->
    Race1RankM = lib_kf_1vN:db_get_kf_1vn_score_rank(),
    Race2M = lib_kf_1vN:db_get_def_rank(),
    State = #state{stage=?KF_1VN_FREE, race_1_rank_m=Race1RankM, race_2_m=Race2M},
    % 通知
    %sync_state_to_all(State),
    {ok, State}.

handle_call(Request, _From, State) ->
%%    ?MYLOG("lzh1vn", "handle_call Request ~p ~n", [Request]),
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
%%    ?MYLOG("lzh1vn", "handle_cast Msg ~p ~n", [Msg]),
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle msg[~p] error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 清空所有数据
do_handle_cast({gm_start_1}, _State) ->
    lib_kf_1vN:db_clean_sign_center(),
    {ok, State} = init([]),
    {noreply, State};

%% gm清空所有场景玩家（防止Bug产生玩家无法退出场景
do_handle_cast({gm_clear_user}, State) ->
    #state{role_m = RoleM} = State,
    Fun = fun(_Area, RoleL) ->
        lists:map(fun
            (#kf_1vN_role{enter = 1, server_id = ServerId, id = RoleId} = Role) ->
                lib_kf_1vN:quit_to_main_scene(ServerId, RoleId),
                Role#kf_1vN_role{enter = 0};
            (Role) -> Role
        end, RoleL)
    end,
    NewRoleM = maps:map(Fun, RoleM),
    {noreply, State#state{role_m = NewRoleM, gm_lock = ?GM_CLOSE_MOD}};

do_handle_cast({gm_open_lock}, State) ->
    {noreply, State#state{gm_lock = ?GM_OPEN_MOD}};

do_handle_cast({sync_state, Node}, State) ->
    #state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sign_num=SignNum, def_num_m=DefNumM, race_2_m=Race2M, race_1_rank_m=Race1RankM} = State,
    F = fun(Area, Race2, TmpDefRankM) ->
            TmpDefRankM#{Area => Race2#kf_1vN_race_2.def_rank}
    end,
    DefRankM = maps:fold(F, #{}, Race2M),
    F2 = fun(_Area, ScoreRank) -> lists:sublist(ScoreRank, 100) end,
    ShortRace1RankM = maps:map(F2, Race1RankM),
    mod_clusters_center:apply_cast(Node, mod_kf_1vN_local, sync_state, [[Stage, SubStage, OpTime, EdTime, SignNum, DefNumM, DefRankM, ShortRace1RankM]]),
    {noreply, State};

%% 报名
do_handle_cast({sign, Node, ServerId, Id, Lv, Name, CombatPower, Platform, ServerNum, ServerName}, State) when State#state.stage == ?KF_1VN_SIGN ->
%%    ?PRINT("sign role ~w~n", [{Node, Id, Lv}]),
    #state{sign_num=SignNum, sign_list=SignList} = State,
    Result = case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false  -> {true, SignNum+1, [#kf_1vN_role_sign{server_id=ServerId, id=Id, lv=Lv, combat_power=CombatPower, name = Name, platform=Platform, server_num=ServerNum, server_name = ServerName}|SignList]};
        KfRole when is_record(KfRole, kf_1vN_role_sign) -> {true, SignNum, lists:keyreplace(Id, #kf_1vN_role_sign.id, SignList, KfRole#kf_1vN_role_sign{server_id=ServerId, id=Id, lv=Lv, combat_power=CombatPower})};
        _ -> false
    end,
    case Result of
        false ->
            {ok, BinData} = pt_621:write(62102, [?ERRCODE(err621_is_signed)]),
            lib_clusters_center:send_to_uid(Node, Id, BinData),
            {noreply, State};
        {true, SignNum1, SignList1} ->
            {ok, BinData} = pt_621:write(62102, [?SUCCESS]),
            lib_clusters_center:send_to_uid(Node, Id, BinData),
            mod_clusters_center:apply_cast(Node, mod_kf_1vN_local, sign_back, [Id]),
            mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, set_sign_num, [SignNum1]),
            lib_kf_1vN:db_save_sign_center(ServerId, Id, Lv, CombatPower, Name, Platform, ServerNum, ServerName),
            lib_log_api:log_kf_1vn_sign(Id, ServerId, Lv, Name),
            {noreply, State#state{sign_num = SignNum1, sign_list=SignList1, sorted_sign_list = undefined}}
    end;

do_handle_cast({update_sign_info, Id, Kvs}, State) when State#state.stage == ?KF_1VN_SIGN ->
    #state{sign_list = SignList} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false ->
            {noreply, State};
        Role ->
            F = fun
                    ({lv, Lv}, R) ->
                        R#kf_1vN_role_sign{lv = Lv};
                    ({power, Power}, R) ->
                        R#kf_1vN_role_sign{combat_power = Power};
                    ({name, Name}, R) ->
                        R#kf_1vN_role_sign{name = Name};
                    (_, R) -> R
                end,
            R2 = lists:foldl(F, Role, Kvs),
            SignList1 = lists:keystore(Id, #kf_1vN_role_sign.id, SignList, R2),
            {noreply, State#state{sorted_sign_list = undefined, sign_list = SignList1}}
    end;


do_handle_cast({get_sign_list, Node, RoleId, MyPower}, State) ->
    #state{sorted_sign_list = SortedSignList, sign_list = SignList, sign_num = SignNum} = State,
    case SortedSignList of
        undefined ->
            NewSortList = init_sorted_sign_list(SignList),
            {ok, BinData} = pt_621:write(62130, [SignNum, NewSortList, MyPower]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State#state{sorted_sign_list = NewSortList}};
        _ ->
            {ok, BinData} = pt_621:write(62130, [SignNum, SortedSignList, MyPower]),
            lib_server_send:send_to_uid(Node, RoleId, BinData),
            {noreply, State}
    end;

do_handle_cast({get_stage_info, Node, Id}, State) ->
    #state{stage=Stage, sub_stage=SubStage, edtime=EdTime, sub_edtime=SubEdTime, match_turn=MatchTurn} = State,
    {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn, EdTime, SubStage, SubEdTime]),
    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),

    {noreply, State};



do_handle_cast({enter, Node, KfRole}, State) when State#state.gm_lock == 1 ->
    {ok, BinData} = pt_621:write(62103, [?ERR_GM_STOP]),
    lib_clusters_center:send_to_uid(Node, KfRole#kf_1vN_role.id, BinData),
    {noreply, State};
do_handle_cast({enter, Node, KfRole}, State) when State#state.stage >= ?KF_1VN_RACE_1_PRE ->
    % ?PRINT("enter role ~w~n", [KfRole#kf_1vN_role.id]),
    #state{sign_list=SignList, role_m=RoleM, max_scene_pool=_MaxScenePool, scene_pool_m = ScenePoolM} = State,
    #kf_1vN_role{id=Id, figure=Figure, combat_power=CombatPower} = KfRole,
    Result = case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
         false -> {false, ?ERRCODE(err621_no_sign)};
         #kf_1vN_role_sign{area=Area, race_1_seed=Race1Seed} ->
             Race1PreScene = data_kf_1vN_m:get_config(race_1_pre_scene),
             {PreX, PreY} = lib_kf_1vN:pre_scene_xy(),
             case maps:get(Area, RoleM, false) of
                 false when State#state.stage >= ?KF_1VN_RACE_2_PRE -> {false, ?ERRCODE(err621_not_in_race_2)};
                 false ->
                     % ScenePoolId = urand:rand(0, MaxScenePool),
                     ScenePoolId = rand_scene_pool_id(ScenePoolM, Area),
                     mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, Race1PreScene, ScenePoolId, 0, PreX, PreY, true, [{action_lock, ?ERRCODE(err621_in_kf_1vn)}, {change_scene_hp_lim,1}]]),
                     {true, Area, RoleM#{ Area=> [KfRole#kf_1vN_role{area=Area, scene_pool_id=ScenePoolId, race_1_seed=Race1Seed, enter=1}]}};
                 #kf_1vN_role{out=1} -> {false, ?ERRCODE(err621_not_in_race_2)};
                 Roles ->
                     Roles1 = case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
                                  false -> %% 第一次进入
                                      % ScenePoolId = urand:rand(0, MaxScenePool),
                                      ScenePoolId = rand_scene_pool_id(ScenePoolM, Area),
                                      mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, Race1PreScene, ScenePoolId, 0, PreX, PreY, true, [{action_lock, ?ERRCODE(err621_in_kf_1vn)}, {change_scene_hp_lim,1}]]),
                                      [KfRole#kf_1vN_role{scene_pool_id=ScenePoolId, area=Area, race_1_seed=Race1Seed, enter=1} | Roles];
                                  RoleO ->
                                      RoleN = RoleO#kf_1vN_role{figure=Figure, combat_power=CombatPower, enter=1},
                                      mod_clusters_center:apply_cast(Node, lib_achievement_api, async_event, [Id, lib_achievement_api, cluster_1vn_event, []]),
                                      mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, Race1PreScene, RoleO#kf_1vN_role.scene_pool_id, 0, PreX, PreY, true, [{action_lock, ?ERRCODE(err621_in_kf_1vn)}, {change_scene_hp_lim,1}]]),
                                      lists:keyreplace(Id, #kf_1vN_role.id, Roles, RoleN)
                              end,
                     {true, Area, RoleM#{ Area => Roles1}}
             end
     end,
    case Result of
        {false, ErrCode} ->
            {ok, BinData} = pt_621:write(62103, [ErrCode]),
            lib_clusters_center:send_to_uid(Node, KfRole#kf_1vN_role.id, BinData),
            {noreply, State};
        {true, Area1, RoleM1} ->
            {ok, BinData} = pt_621:write(62103, [?SUCCESS]),
            lib_clusters_center:send_to_uid(Node, KfRole#kf_1vN_role.id, BinData),
            State1 = State#state{role_m=RoleM1},
            send_banner(Area1, Id, State1),
            %% 参加活动，增加活跃
            mod_clusters_center:apply_cast(Node, lib_activitycalen_api, role_success_end_activity, [Id, ?MOD_KF_1VN, 0]),
            {noreply, State1}
    end;

%% 阶段状态改变
do_handle_cast({stage_change, Stage, OpTime, EdTime, AcId}, State) ->
    % ?MYLOG("kf1vnstage", "stage_change ~w~n", [{Stage, OpTime, EdTime}]),
    State1 = case Stage of
        ?KF_1VN_SIGN ->
            util:cancel_timer(State#state.match_ref),
            SubStage = ?KF_1VN_STATE_WAIT,
            SubEdTime = EdTime,
            lib_kf_1vN:clean_def_rank(),
            lib_kf_1vN:clean_kf_1vn_score_rank(),
            SignList = lib_kf_1vN:get_sign_list_center(),
            SignNum = length(SignList),
            State#state{ac_id=AcId, stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime, race_1_rank_m=#{}, race_2_m=#{}, sign_list=SignList, sign_num=SignNum};
        ?KF_1VN_RACE_1_PRE ->
            util:cancel_timer(State#state.match_ref),
            #state{sign_list=SignList, sign_num=SignNum} = State,
            MinNum = data_kf_1vN:get_value(?KF_1VN_CFG_ACT_MIN_NUM),
            case SignNum < MinNum of
                true ->
                    self()!ac_stop,
                    Title = utext:get(6210013),
                    Content = utext:get(6210014, [MinNum]),
                    [mod_clusters_center:apply_cast(E#kf_1vN_role_sign.server_id, lib_mail_api, send_sys_mail, [[E#kf_1vN_role_sign.id], Title, Content, []])  || E <- SignList],
                    SubStage = ?KF_1VN_STATE_WAIT,
                    SubEdTime = EdTime,
                    State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime};
                false ->
                    {SignListNew, AreaList} = cut_area(SignList),
                    {DefNumM, SeedNumM} = calc_def_num(AreaList, SignListNew, #{}, #{}),
                    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, change_def_num_m, [DefNumM], 10),
                    MaxScenePool = min(10, State#state.sign_num div 100),
                    ScenePoolM = make_scene_pool_m(SignListNew),
                    % ?MYLOG("lzh1vn", "ScenePoolM:~p ~n", [ScenePoolM]),
                    change_local_area(SignListNew, #{}),
                    SetSeedSignList = set_seed_role_sign(AreaList, SignListNew, SeedNumM),
                    ExpRef = erlang:send_after(?EXP_ADD_TIME, self(), add_exp),
                    SubStage = ?KF_1VN_STATE_WAIT,
                    SubEdTime = EdTime,
                    SortedSignList = init_sorted_sign_list(SignList),
                    MaxPower
                    = case SortedSignList of
                          [{_, _, _, Power}|_] ->
                              Power;
                          _ ->
                              10000000
                      end,
                    SerInfoList = make_ser_info_list(SignListNew),
                    State#state{stage=Stage, sub_stage=SubStage, max_scene_pool=MaxScenePool, scene_pool_m=ScenePoolM, optime=OpTime, edtime=EdTime,
                        sub_edtime=SubEdTime, sign_list=SetSeedSignList, area_list=AreaList, exp_ref=ExpRef, def_num_m=DefNumM, seed_num_m=SeedNumM,
                        sorted_sign_list = SortedSignList, max_power = MaxPower, ser_info_list = SerInfoList}
            end;
        ?KF_1VN_RACE_1 ->
            util:cancel_timer(State#state.match_ref),
            #kf_1vN_time_cfg{race_1_m_time=MatchTime, race_1_b_time=BattleTime} = data_kf_1vN:get_info(AcId),
            %% 开始匹配
            MatchRef = erlang:send_after(MatchTime*1000, self(), match),
            SubStage = ?KF_1VN_STATE_MATCH,
            SubEdTime = OpTime+MatchTime,
            State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime, match_time=MatchTime, battle_time=BattleTime, match_turn=1, match_ref=MatchRef};
        ?KF_1VN_RACE_2_PRE ->
            util:cancel_timer(State#state.match_ref),
            #state{role_m=RoleM, def_num_m=DefNumM} = State,
            F = fun(Area, ORoles, [TmpRace2M, TmpRolesM]) ->
                Roles = sort_roles_by_score(ORoles),
                RolesUp  = [ E1 || E1 <- Roles, E1#kf_1vN_role.score > 0],
                RolesUpLen = length(RolesUp),
                DefNum = maps:get(Area, DefNumM),
                SelectDefNum  = min(DefNum, RolesUpLen),
                send_race_1_reward(Roles, SelectDefNum, 1),
                RolesOut = [ begin
                            % lib_kf_1vN:quit_to_main_scene(E2#kf_1vN_role.server_id, E2#kf_1vN_role.id), % 无积分玩家不踢出
                            E2#kf_1vN_role{out=1}  end || E2 <- Roles, E2#kf_1vN_role.score =< 0],
                F2 = fun(#kf_1vN_role{id=TmpId, server_id=ServerId, combat_power=CombatPower, attr=Attr} = Role, [TmpDefNum, Rank, DefList, ChallengerRoles, TmpDefIds, TmpChallengerIds]) ->
                    case TmpDefNum > SelectDefNum of
                        true ->
                            mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[TmpId], utext:get(6210001), utext:get(6210003, [Rank]), []]),
                            mod_clusters_center:apply_cast(Role#kf_1vN_role.server_id, lib_kf_1vN, update_player_1vn, [Role#kf_1vN_role.id, 2, 0]),
                            [TmpDefNum, Rank+1, DefList, [Role#kf_1vN_role{race_2_side=?SIDE_CHALLENGER}|ChallengerRoles], TmpDefIds, [{TmpId, CombatPower} |TmpChallengerIds]];
                        false ->
                            mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[TmpId], utext:get(6210001), utext:get(6210002, [Rank]), []]),
                            mod_clusters_center:apply_cast(Role#kf_1vN_role.server_id, lib_kf_1vN, update_player_1vn, [Role#kf_1vN_role.id, 1, 0]),
                            [TmpDefNum+1, Rank+1, [Role#kf_1vN_role{race_2_side=?SIDE_DEF}|DefList], ChallengerRoles, [{TmpId, Attr}|TmpDefIds], TmpChallengerIds]
                    end
                end,
                [_, _, DefRoles, ChallengerRoles, DefIds, ChallengerIds] = lists:foldl(F2, [1, 1, [], [], [], []], RolesUp),
                NewRoles = RolesOut++DefRoles++ChallengerRoles,
                {DefRank, ChallenageRank} = sort_race_2_rank(NewRoles, [], []),
                ShortDefRank = lists:sublist(DefRank, 100),
                ShortChallenageRank = lists:sublist(ChallenageRank, 100),
                mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, update_race_2_rank, [Area, ShortDefRank, ShortChallenageRank], 50),
                case DefIds of
                    [] -> self() ! {ac_end, Area};
                    _  -> skip
                end,
                %% 初始化玩家类型
                [TmpRace2M#{Area => #kf_1vN_race_2{def_list=DefIds, challenger_list=ChallengerIds, def_rank=ShortDefRank}}, TmpRolesM#{Area=>NewRoles}]
            end,
            [Race2MN, RoleMN] = maps:fold(F, [#{}, RoleM], RoleM),
            SubStage = ?KF_1VN_STATE_WAIT,
            SubEdTime = EdTime,
            NewState = State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime, match_time=0, battle_time=0, match_turn=1, match_ref=undefined, role_m=RoleMN, race_2_m=Race2MN, bet_time = OpTime},
            send_race_2_banner(NewState),
            NewState;
        ?KF_1VN_RACE_2 ->
            util:cancel_timer(State#state.match_ref),
            #kf_1vN_time_cfg{race_2_m_time=MatchTime, race_2_b_time=BattleTime} = data_kf_1vN:get_info(AcId),
            MatchRef = erlang:send_after(1000, self(), race_2_match),
            SubStage = ?KF_1VN_STATE_MATCH,
            SubEdTime = OpTime+MatchTime,
            State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime, match_time=MatchTime, battle_time=BattleTime, match_turn=0, match_ref=MatchRef};
        ?KF_1VN_FREE ->
            util:cancel_timer(State#state.match_ref),
            SubStage = ?KF_1VN_STATE_END,
            SubEdTime = EdTime,
            State#state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sub_edtime=SubEdTime, match_time=0, battle_time=0, match_turn=0};
        _ ->
            SubStage = State#state.sub_stage,
            SubEdTime = EdTime,
            State#state{sub_edtime=SubEdTime}
    end,
    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, stage_change, [Stage, 1, EdTime, SubStage, SubEdTime]),
    {noreply, State1};


%% 获取等待场景banner
do_handle_cast({get_banner, _Node, Id}, State) ->
%%    ?PRINT("get_banner ~p~n", [{_Node, Id}]),
    #state{sign_list=SignList} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        #kf_1vN_role_sign{area=Area} ->
            send_banner(Area, Id, State);
        _ ->
            skip
    end,
    {noreply, State};


%% 离开场景
do_handle_cast({quit, Node, Id, CopyId, QuitType, Hp, HpLim}, State) ->
    % ?PRINT("quit ~w~n", [Id]),
    #state{sign_list=SignList, stage=Stage, sub_stage=SubStage, role_m=RoleM, race_2_m=Race2M, match_turn=MatchTurn} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false ->
            lib_kf_1vN:quit_to_main_scene(Node, Id),
            {noreply, State};
        #kf_1vN_role_sign{area=Area} ->
            case maps:get(Area, RoleM, false) of
                false ->
                    lib_kf_1vN:quit_to_main_scene(Node, Id),
                    {noreply, State};
                Roles ->
                    case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
                        false ->
                            lib_kf_1vN:quit_to_main_scene(Node, Id),
                            {noreply, State};
                        #kf_1vN_role{scene_pool_id=ScenePoolId, race_2_side=Race2Side, race_2_battle_id=Race2BattleId, watch_battle_id=WatchBattleId} = Role ->
%%                             ?PRINT("quit ~w~n", [{Id, Race2Side, Race2BattleId}]),
                            IsPid = is_pid(CopyId),
                            if
                                % 在战场中退出(可能处于匹配状态中)
                                QuitType == 1 andalso IsPid == true andalso Race2BattleId > 0 ->
                                    CopyId ! {quit, Node, Id, Role#kf_1vN_role.scene_pool_id, QuitType, Hp, HpLim},
                                    {noreply, State};
                                Race2Side == ?SIDE_DEF andalso Stage == ?KF_1VN_RACE_2 andalso Race2BattleId > 0 andalso SubStage /= ?KF_1VN_STATE_FIGHT ->
%%                                    %% 擂主在竞猜时间离开，则判定输
%%                                    Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{race_2_lose=1, enter=0}),
%%                                    lib_kf_1vN:quit_to_main_scene(Node, Id),
%%                                    race_2_pk_result(Race2BattleId, 0, Area, Id, Role#kf_1vN_role.combat_power), %% 单场比赛结束
%%
%%                                    Race2 = maps:get(Area, Race2M),
%%                                    #kf_1vN_race_2{match_list=MatchList} = Race2,
%%                                    MatchList1 = case lists:keyfind(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
%%                                        #kf_1vN_race_2_match_info{challengers=Challengers, battle_win=0} = MatchInfo->
%%                                            case data_kf_1vN:get_race_2_award(2, MatchTurn) of
%%                                                {ChallengerWinRewards, _} -> skip;
%%                                                _ -> ChallengerWinRewards = []
%%                                            end,
%%                                            Title = utext:get(318),
%%                                            Content = utext:get(320, [MatchTurn]),
%%                                            [mod_clusters_center:apply_cast(EC#kf_1vN_role_pk.server_id, lib_mail_api, send_sys_mail, [[EC#kf_1vN_role_pk.id], Title, Content, ChallengerWinRewards])
%%                                                ||EC <- Challengers, EC#kf_1vN_role_pk.is_dead==0, EC#kf_1vN_role_pk.type==?KF_1VN_C_TYPE_PLAYER],
%%                                            lists:keyreplace(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList, MatchInfo#kf_1vN_race_2_match_info{battle_win=2});
%%                                        _ ->
%%                                            MatchList
%%                                    end,
%%
%%                                    {noreply, State#state{role_m=RoleM#{Area:=Roles1}, race_2_m=Race2M#{Area:=Race2#kf_1vN_race_2{match_list=MatchList1}}}};
                                    lib_kf_1vN:quit_to_main_scene(Node, Id),
                                    Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{enter=0}),
                                    {noreply, State#state{role_m=RoleM#{Area:=Roles1}}};
                                Race2Side == ?SIDE_CHALLENGER andalso Stage == ?KF_1VN_RACE_2 andalso Race2BattleId > 0 andalso SubStage /= ?KF_1VN_STATE_FIGHT ->
                                    %% 挑战者在竞猜时间离开，则判定输
                                    Race2 = maps:get(Area, Race2M),
                                    #kf_1vN_race_2{match_list=MatchList} = Race2,
                                    QuitRole = Role#kf_1vN_role{enter=0},
                                    Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, QuitRole),
                                    lib_kf_1vN:quit_to_main_scene(Node, Id),
                                    {MatchList1, LastRoles} = case lists:keyfind(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of

                                        #kf_1vN_race_2_match_info{def_role=#kf_1vN_role_pk{id=DefId, server_id=DefSerId, server_num=DefSerNum,
                                                name=DefName, combat_power=DefCombatPower}, challengers=Challengers, battle_win=0} = MatchInfo ->

                                            ChallengersLen = length([1|| E<- Challengers, E#kf_1vN_role_pk.is_dead==0]),
                                            {Challengers1, TmpRoles, BattleWin} = case lists:keyfind(Id, #kf_1vN_role_pk.id, Challengers) of
                                                #kf_1vN_role_pk{is_dead=0} = KfRolePk when ChallengersLen == 1 ->
                                                    %% 最后一个挑战者离开，擂主直接胜利
                                                    Roles2 = case lists:keyfind(DefId, #kf_1vN_role.id, Roles1) of
                                                        false -> Roles1;
                                                        DefRole ->  lists:keyreplace(DefId, #kf_1vN_role.id, Roles1, DefRole#kf_1vN_role{race_2_turn=MatchTurn})
                                                    end,
                                                    race_2_pk_result(Race2BattleId, 1, Area, DefId, DefCombatPower, 1000, 1000, 0), %% 单场比赛结束,擂主血量设置为1000,挑战者剩余人数为0

                                                    case data_kf_1vN:get_race_2_award(?SIDE_DEF, MatchTurn) of
                                                        {DefWinRewards, _} -> skip;
                                                        _ -> DefWinRewards = []
                                                    end,
                                                    Title = utext:get(318),
                                                    Content = utext:get(319, [MatchTurn]),
                                                    mod_clusters_center:apply_cast(DefSerId, lib_mail_api, send_sys_mail, [[DefId], Title, Content, DefWinRewards]),
                                                    lib_log_api:log_kf_1vn_race_2(Area, MatchTurn, Race2BattleId, DefId, DefSerId, DefSerNum, DefName, DefCombatPower, 1, 1, 4, 0),

                                                    {lists:keyreplace(Id, #kf_1vN_role_pk.id, Challengers, KfRolePk#kf_1vN_role_pk{is_dead=2}), Roles2, 1};

                                                #kf_1vN_role_pk{is_dead=0} = KfRolePk ->
                                                    {lists:keyreplace(Id, #kf_1vN_role_pk.id, Challengers, KfRolePk#kf_1vN_role_pk{is_dead=2}), Roles1, 0};
                                                _ ->
                                                    {Challengers, Roles1, 0}
                                            end,
                                            {lists:keyreplace(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList, MatchInfo#kf_1vN_race_2_match_info{challengers=Challengers1, battle_win=BattleWin}), TmpRoles};

                                        _ ->
                                            {MatchList, Roles1}
                                    end,
                                    {noreply, State#state{role_m=RoleM#{Area:=LastRoles}, race_2_m=Race2M#{Area:=Race2#kf_1vN_race_2{match_list=MatchList1}}}};
                                WatchBattleId > 0 ->
%%                                    ?PRINT("WATCH OUT ~w~n", [Id]),
                                    Race2 = maps:get(Area, Race2M),
                                    #kf_1vN_race_2{match_list=MatchList} = Race2,
                                    Enter = case QuitType of
                                        1 -> Role#kf_1vN_role.enter;
                                        _ -> 0
                                    end,
                                    Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{watch_battle_id=0, enter=Enter}),
                                    Race1PreScene = data_kf_1vN_m:get_config(race_1_pre_scene),
                                    {PreX, PreY} = lib_kf_1vN:pre_scene_xy(),
                                    mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, Race1PreScene, ScenePoolId, 0, PreX, PreY, false, [{ghost,0},{group,0}]]),
                                    send_banner(Area, Id, State),
                                    case lists:keyfind(WatchBattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
                                        false -> {noreply, State};
                                        #kf_1vN_race_2_match_info{watch_num=WatchNum, watch_ids=WatchIds} = MatchInfo ->
                                            MatchInfo1 = MatchInfo#kf_1vN_race_2_match_info{watch_num=max(0, WatchNum-1), watch_ids=lists:keydelete(Id, 2, WatchIds)},
                                            MatchList1 = lists:keyreplace(WatchBattleId, #kf_1vN_race_2_match_info.battle_id, MatchList, MatchInfo1),
                                            {noreply, State#state{role_m=RoleM#{Area:=Roles1}, race_2_m=Race2M#{Area:=Race2#kf_1vN_race_2{match_list=MatchList1}}}}
                                    end;
                                true ->
                                    RoleM1 = case is_pid(CopyId) of
                                        true  ->
                                            CopyId ! {quit, Node, Id, Role#kf_1vN_role.scene_pool_id, QuitType, Hp, HpLim},
                                            case QuitType of
                                                1 -> RoleM;
                                                _ ->
                                                    Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{enter=0}),
                                                    RoleM#{Area:=Roles1}
                                            end;
                                        false ->
                                            lib_kf_1vN:quit_to_main_scene(Node, Id),
                                            Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{enter=0}),
                                            RoleM#{Area:=Roles1}
                                    end,
                                    {noreply, State#state{role_m=RoleM1}}
                            end
                    end
            end
    end;


%% 更新玩家数据
do_handle_cast({update_role, Area, Id, KeyList}, State) ->
%%    ?PRINT("update_role ~w~n", [{Id, KeyList}]),
    #state{role_m=RoleM} = State,
    Roles = maps:get(Area, RoleM),
    case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
        false ->
            {noreply, State};
        KfRole ->
            KfRoleN = update_role_dt(KeyList, KfRole),
            RolesN = lists:keyreplace(Id, #kf_1vN_role.id, Roles, KfRoleN),
            {noreply, State#state{role_m=RoleM#{Area:=RolesN}}}
    end;

%% 退出pk场景，发送banner信息
do_handle_cast({exit_pk, Area, Id}, State) ->
    send_banner(Area, Id, State),
    {noreply, State};

do_handle_cast({race_2_pk_result, BattleId, DefIsWin, Area, Id, CombatPower, Hp, HpLim, LiveNum}, State) ->
    #state{sign_list=SignList, role_m=RoleM, race_2_m=Race2M, match_turn=MatchTurn, bet_time=BetTime, match_ref=OldMatchRef, sub_stage = SubStage} = State,
    #kf_1vN_race_2{def_list=DefList, challenger_list=ChallengerList, match_list=MatchList, bet_m=BetM} = Race2 = maps:get(Area, Race2M),
    case DefIsWin of
        1 ->
            BattleWin = 1,
            DefList1 = DefList,
            ChallengerList1 = ChallengerList;
        _ ->
            BattleWin = 2,
            DefList1 = lists:keydelete(Id, 1, DefList),
            ChallengerList1 = [{Id, CombatPower}|ChallengerList]
    end,

    Roles = maps:get(Area, RoleM),

    %% 更改1vn战斗状态
    {MatchList1, NewRoles} = case lists:keyfind(BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
        false -> {MatchList, Roles};
        #kf_1vN_race_2_match_info{watch_ids=WatchIds} = MatchInfo ->
            Race1PreScene = data_kf_1vN_m:get_config(race_1_pre_scene),
            {PreX, PreY} = lib_kf_1vN:pre_scene_xy(),
            Roles1 = lists:foldl(fun({EServerId, EId}, RoleTmps) ->
                mod_clusters_center:apply_cast(EServerId, lib_scene, player_change_scene,
                    [EId, Race1PreScene, rand_scene_pool_id(State#state.scene_pool_m, Area), 0, PreX, PreY, false, [{ghost,0}]]) ,
                case lists:keyfind(EId, #kf_1vN_role.id, RoleTmps) of
                    false -> RoleTmps;
                    R -> lists:keystore(EId, #kf_1vN_role.id, RoleTmps, R#kf_1vN_role{watch_battle_id = 0})
                end
                end, Roles, WatchIds),
            MatchListDel = lists:keyreplace(BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList,
                MatchInfo#kf_1vN_race_2_match_info{
                    status = ?KF_1VN_RACE_2_MATCH_STATUS_END, battle_win=BattleWin, hp=Hp, hp_lim=HpLim, live_num=LiveNum, watch_num=0, watch_ids=[]
                    }),
            {MatchListDel, Roles1}
    end,
    {ok, BinData} = pt_621:write(62135, [BattleId, BattleWin]),
    lib_kf_1vN:send_all_enter(NewRoles, BinData),
    %% 发放押注奖励
%%    ?PRINT("race_2_pk_result ~w~n", [{ BattleId, DefIsWin, Area, Id, CombatPower}]),
    case maps:get(BattleId, BetM, false) of
        false -> skip;
        BetList ->
            % Ratio = data_kf_1vN:get_ratio(MatchTurn),
            handle_bet_list(BetList, SignList, MatchTurn, BattleWin, Hp, HpLim, LiveNum, BattleId, BetTime)
    end,

    %case DefList1 of
    %    [] -> erlang:send_after(5000, self() ! {ac_end, Area};
    %    _  -> skip
    %end,
    NewRace2M = Race2M#{Area=>Race2#kf_1vN_race_2{def_list=DefList1, challenger_list=ChallengerList1, match_list=MatchList1}},
    %战斗状态下是否全部结束,是的话进入匹配
    F = fun(_TmpArea, TmpRace2, IsAllEnd) ->
        #kf_1vN_race_2{match_list=TmpMatchList} = TmpRace2,
        IsHaveNoEnd = lists:keymember(?KF_1VN_RACE_2_MATCH_STATUS_NO, #kf_1vN_race_2_match_info.status, TmpMatchList),
        % 是否都结束
        IsAllEnd andalso IsHaveNoEnd == false
    end,
    case SubStage == ?KF_1VN_STATE_FIGHT andalso maps:fold(F, true, NewRace2M) of
        true -> MatchRef = util:send_after(OldMatchRef, 1000, self(), race_2_match);
        false -> MatchRef = OldMatchRef
    end,
    {noreply, State#state{race_2_m = NewRace2M, match_ref = MatchRef, role_m = maps:put(Area, NewRoles, RoleM)}};

%% 获取押注（匹配）列表
do_handle_cast({get_bet_list, Node, Id}, State) ->
    #state{sub_stage=SubStage, sign_list=SignList, race_2_m=Race2M, match_turn=Turn} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false -> skip;
        #kf_1vN_role_sign{area=Area, bet_list=RoleBetList} ->
            case maps:get(Area, Race2M, false) of
                false -> skip;
                #kf_1vN_race_2{def_list=DefList, match_list=MatchList} ->
                    F = fun(
                            #kf_1vN_race_2_match_info{
                                battle_id=TmpBattleId, status=BStatus, battle_win=BattleWin, hp=Hp, hp_lim=HpLim, live_num=LiveNum, def_role=DefRole,
                                challengers=Challengers}
                            , TmpResult) ->
                        case lists:keyfind(TmpBattleId, 1, RoleBetList) of
                            false -> IsBet = 0, BetR = 0;
                            {_BattleId, OptNo} ->
                                IsBet = 1,
                                BetR = calc_bet_result(Turn, BattleWin, Hp, HpLim, LiveNum, OptNo)
                                % BetR = if
                                %     BattleWin > 0 andalso BattleWin == BetSide -> 2; %% 猜对
                                %     BattleWin > 0 -> 1; %% 猜错
                                %     true -> 0
                                % end
                        end,
%%                            ?PRINT("bet STATUS ~w~n", [{TmpBattleId, BattleWin, BetSide, BetR, BStatus}]),
                        BetStatus = case SubStage of
                            ?KF_1VN_STATE_MATCH -> 0;
                            ?KF_1VN_STATE_BET when BStatus == ?KF_1VN_RACE_2_MATCH_STATUS_END -> 2;
                            ?KF_1VN_STATE_BET -> 0;
                            ?KF_1VN_STATE_FIGHT when BStatus == ?KF_1VN_RACE_2_MATCH_STATUS_END -> 2;
                            ?KF_1VN_STATE_FIGHT -> 1;
                            _ -> 2
                        end,
                        BattleResult = case SubStage of
                            ?KF_1VN_STATE_FIGHT -> BattleWin;
                            _ -> 0
                        end,
                        %?PRINT("BATTLE STATUS ~w~n", [{TmpBattleId, BStatus, BetStatus}]),
                        ChallengersSendL = [
                            {E#kf_1vN_role_pk.id, E#kf_1vN_role_pk.platform, E#kf_1vN_role_pk.server_num, E#kf_1vN_role_pk.server_name,
                                E#kf_1vN_role_pk.name, E#kf_1vN_role_pk.career, E#kf_1vN_role_pk.turn, E#kf_1vN_role_pk.sex, E#kf_1vN_role_pk.lv,
                                E#kf_1vN_role_pk.picture, E#kf_1vN_role_pk.picture_ver, E#kf_1vN_role_pk.combat_power
                            } || E <- Challengers],
                        [{TmpBattleId, BetStatus, DefRole#kf_1vN_role.id, DefRole#kf_1vN_role.platform, DefRole#kf_1vN_role.server_num,
                            DefRole#kf_1vN_role.server_name, DefRole#kf_1vN_role.figure#figure.name,
                            DefRole#kf_1vN_role.figure#figure.career, DefRole#kf_1vN_role.figure#figure.turn, DefRole#kf_1vN_role.figure#figure.sex,
                            DefRole#kf_1vN_role.figure#figure.lv,
                            DefRole#kf_1vN_role.figure#figure.picture, DefRole#kf_1vN_role.figure#figure.picture_ver,
                            DefRole#kf_1vN_role.combat_power, ChallengersSendL, BattleResult, IsBet, BetR}|TmpResult]
                    end,
                    BetList = lists:foldl(F, [], MatchList),
                    % ?PRINT("bet MATCH LIST ~p~n", [{Area, length(BetList), length(MatchList), BattleId}]),
                    {ok, BinData} = pt_621:write(62117, [BetList, length(DefList), length(RoleBetList)]),
                    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData])
            end
    end,
    {noreply, State};

%% 押注
do_handle_cast({bet_battle, Node, ServerId, Id, RoleName, ClientTurn, BattleId, OptNo, CostType}, State) ->
    #state{sub_stage=SubStage, sign_list=SignList, race_2_m=Race2M, role_m=RoleM, match_turn=Turn, bet_time=BetTime} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false -> CheckSign = {false, ?ERRCODE(err621_no_sign)};
        #kf_1vN_role_sign{area=Area, bet_list=RoleBetList} = RoleSign ->
            IsBetCount = length(RoleBetList) < data_kf_1vN:get_value(?KF_1VN_CFG_BET_MAX_COUNT),
            IsHadBet = lists:keymember(BattleId, 1, RoleBetList),
            % 检查场次战斗等等
            Roles = maps:get(Area, RoleM),
            CheckSign0 = case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
                false -> {false, ?ERRCODE(err621_no_enter)};
                % #kf_1vN_role{race_2_battle_id=BattleId} -> {false, ?ERRCODE(err621_no_bet_self)}; %% 不能押注自己那场
                _ ->
                    case maps:get(Area, Race2M) of
                        #kf_1vN_race_2{match_list=MatchList, bet_m=BetM} = Race2 ->
                            case lists:keyfind(BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
                                false -> {false, ?ERRCODE(err621_not_battle)};
                                #kf_1vN_race_2_match_info{status = ?KF_1VN_RACE_2_MATCH_STATUS_END} -> {false, ?ERRCODE(err621_battle_is_end)};
                                MatchInfo -> {true, RoleSign, Area, BetM, Race2, MatchInfo}
                            end;
                        _ -> {false, ?ERRCODE(err621_no_battle)}
                    end
            end,
            case data_kf_1vN:get_bet(Turn) of
                #base_kf_1vn_bet{opt_list = OptList} -> IsRightOpt = lists:keymember(OptNo, 1, OptList);
                _ -> IsRightOpt = false
            end,
            CheckSign = if
                SubStage =/= ?KF_1VN_STATE_BET -> {false, ?ERRCODE(err621_not_bet_stage)};
                IsBetCount == false -> {false, ?ERRCODE(err621_max_bet_count)};
                IsHadBet -> {false, ?ERRCODE(err621_had_bet_this_battle)};
                ClientTurn =/= Turn -> {false, ?ERRCODE(err621_bet_turn_error)};
                IsRightOpt == false -> {false, ?ERRCODE(err621_bet_opt_error)};
                true -> CheckSign0
            end
    end,
    Result = case CheckSign of
        {false, ErrCode0} -> {false, ErrCode0};
        {true, #kf_1vN_role_sign{bet_list=RoleBetListAfCk} = RoleSignAfCk, AreaAfCk, BetMAfCk, Race2AfCk, MatchInfoAfCk} ->
            %?PRINT("bet_battle ~w~n", [IsWin]),
            BetList = maps:get(BattleId, BetMAfCk, []),
            % BetSide = case IsWin of
            %     1 -> 1;
            %     _ -> 2
            % end,
            % 每个战场id只能投注一次
            NewBetM = case lists:keyfind(Id, 2, BetList) of
                false ->
                    CostKvList = data_kf_1vN:get_cost_list(Turn),
                    case lists:keyfind(CostType, 1, CostKvList) of
                        false -> Cost = [];
                        {_CostType, Cost, _WinReward, _LoseReward} -> ok
                    end,
                    mod_clusters_center:apply_cast(Node, lib_player, update_player_info, [Id, [{cost, {Cost, kf_1vn_bet, ""}}]]),
                    lib_log_api:log_kf_1vn_bet(Id, RoleName, Turn, BattleId, OptNo, Cost, utime:unixtime()),
                    BetMAfCk#{BattleId => [{ServerId, Id, OptNo, CostType}|BetList]};
                _ -> BetMAfCk
            end,
            NewRoleBetListAfCk = lists:keystore(BattleId, 1, RoleBetListAfCk, {BattleId, OptNo}),
            Bet = lib_kf_1vN:trans_to_bet(MatchInfoAfCk#kf_1vN_race_2_match_info.def_role, Id, BattleId, BetTime, Turn, CostType, OptNo),
            mod_clusters_center:apply_cast(Node, mod_kf_1vN_local, add_bet, [Bet]),
            {true
                , Race2M#{AreaAfCk => Race2AfCk#kf_1vN_race_2{bet_m=NewBetM}}
                , lists:keyreplace(Id, #kf_1vN_role_sign.id, SignList, RoleSignAfCk#kf_1vN_role_sign{server_id=ServerId, bet_list=NewRoleBetListAfCk})
                }
    end,
    case Result of
        {true, Race2M1, SignList1} ->
            %?MYLOG("lzh_1vn", "62118 send success ~p ~n ", [?SUCCESS]),
            {ok, BinData} = pt_621:write(62118, [?SUCCESS, Turn, BattleId]),
            mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
            {noreply, State#state{race_2_m=Race2M1, sign_list=SignList1}};
        {false, ErrCode} ->
            %?MYLOG("lzh_1vn", "62118 send errcode ~p ~n ", [ErrCode]),
            {ok, BinData} = pt_621:write(62118, [ErrCode, Turn, BattleId]),
            mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
            {noreply, State}
    end;

do_handle_cast({get_race_2_rank_top, Node, Id}, State) ->
    #state{race_1_rank_m=Race1RankM, sign_list=SignList} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false -> skip;
        #kf_1vN_role_sign{area=Area} ->
            case maps:get(Area, Race1RankM, false) of
                [#kf_1vN_score_rank{name=TopScoreName} | _] = ScoreRank ->
                    MyRank = case lists:keyfind(Id, #kf_1vN_score_rank.id, ScoreRank) of
                        #kf_1vN_score_rank{rank=TmpRank} -> TmpRank;
                        _ -> 0
                    end;
                _ -> TopScoreName = "", MyRank=0
            end,
            {ok, BinData} = pt_621:write(62119, [MyRank, TopScoreName]),
            mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData])
    end,
    {noreply, State};


do_handle_cast({watch, Node, ServerId, Id, BattleId}, State) when State#state.stage == ?KF_1VN_RACE_2 ->
    #state{sub_stage=SubStage, sign_list=SignList, role_m=RoleM, race_2_m=Race2M} = State,
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        false -> skip;
        #kf_1vN_role_sign{area=Area} ->
            Roles = maps:get(Area, RoleM, []),
            Result = case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
                false -> {false, ?ERRCODE(err621_no_enter)};
                #kf_1vN_role{race_2_battle_id=Race2BattleId} when Race2BattleId > 0 -> {false, ?ERRCODE(err621_has_battle)};
                KfRole ->
                    #kf_1vN_race_2{match_list=MatchList} = Race2 = maps:get(Area, Race2M),
                    case lists:keyfind(BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
                        #kf_1vN_race_2_match_info{status = ?KF_1VN_RACE_2_MATCH_STATUS_END} -> {false, ?ERRCODE(err621_battle_is_end)};
                        #kf_1vN_race_2_match_info{watch_num = WatchNum} when WatchNum >= ?WATCH_MAX_NUM -> {false, ?ERRCODE(err621_watch_max_num)};
                        #kf_1vN_race_2_match_info{scene_pool_id = ScenePoolId, copy_id=CopyId, watch_num = WatchNum, watch_ids=WatchIds} = MatchInfo when SubStage == ?KF_1VN_STATE_FIGHT ->
                            SceneId = data_kf_1vN_m:get_config(race_2_scene),
                            {DefX, DefY} = data_kf_1vN:get_value(?KF_1VN_CFG_DEF_XY),
                            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, SceneId, ScenePoolId, CopyId, DefX, DefY, false, [{ghost, 1}]]),
                            NewMatchInfo = MatchInfo#kf_1vN_race_2_match_info{watch_num=WatchNum+1, watch_ids=[{ServerId, Id}|WatchIds]},
                            NewMatchList = lists:keyreplace(BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList, NewMatchInfo),
                            Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, KfRole#kf_1vN_role{watch_battle_id=BattleId}),
                            mod_kf_1vN_pk:get_watch_info(ServerId, Id, CopyId),
                            TmpState = State#state{role_m=RoleM#{Area:=Roles1}, race_2_m=Race2M#{Area:=Race2#kf_1vN_race_2{match_list=NewMatchList}}},
                            {true, TmpState};
                        _ ->
                            {false, ?ERRCODE(err621_no_battle)}
                    end
            end,
            case Result of
                {false, ErrCode} ->
                    {ok, BinData} = pt_621:write(62121, [ErrCode]),
                    mod_clusters_center:apply_cast(Node, lib_server_send, send_to_uid, [Id, BinData]),
                    {noreply, State};
                {true, NewState} ->
                    {noreply, NewState}
            end
    end;

do_handle_cast({print}, State) ->
    ?PRINT("role_m:~p ~n", [State#state.role_m]),
    ?PRINT("race_1_rank_m:~p ~n", [State#state.race_1_rank_m]),
    ?PRINT("race_2_m:~p ~n", [State#state.race_2_m]),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?ERR("Handle unkown msg[~p]~n", [_Msg]),
    {noreply, State}.

handle_info(Info, State) ->
%%    ?MYLOG("lzh1vn", "handle_info Info ~p ~n", [Info]),
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle info[~p] error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(add_exp, State) ->
    #state{role_m=RoleM, exp_ref=OldExpRef} = State,
    util:cancel_timer(OldExpRef),
    F = fun(_Area, Roles) ->
            add_exp(Roles, [])
    end,
    RoleM1 = maps:map(F, RoleM),
    ExpRef = erlang:send_after(?EXP_ADD_TIME, self(), add_exp),
    {noreply, State#state{role_m=RoleM1, exp_ref=ExpRef}};

do_handle_info(match, #state{stage=Stage} = State) when Stage /= ?KF_1VN_FREE ->
    #state{edtime=EdTime, role_m=RoleM, race_1_rank_m=Race1RankM, max_scene_pool=_MaxScenePool, scene_pool_m=ScenePoolM,
        match_time=MatchTime, battle_time=BattleTime, match_turn=MatchTurn, match_ref=OldMatchRef, max_power = MaxPower, ser_info_list=SerInfoList} = State,

    Now = utime:unixtime(),
    LoadingTime = data_kf_1vN_m:get_config(loading_time),
    case Now + BattleTime + 2 > EdTime of
        true  ->
            util:cancel_timer(OldMatchRef),
%%            ?PRINT("---- Race 1 MATCH FIN ~n", []),
            F = fun(_Area, Roles) ->
                {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn, EdTime, ?KF_1VN_STATE_END, EdTime]),
                lib_kf_1vN:send_all_enter(Roles, BinData)
            end,
            maps:map(F, RoleM),
            % 再推一次
            F2 = fun(Area, Roles, TmpRace1ShortRankM) ->
                Rank = sort_score_rank(Roles),
                ShortRank = lists:sublist(Rank, 100),
                TmpRace1ShortRankM#{Area=>ShortRank}
            end,
            Race1ShortRankM = maps:fold(F2, #{}, RoleM),
            mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, set_race_1_rank, [Race1ShortRankM], 50),
            {noreply, State#state{sub_stage=?KF_1VN_STATE_END, sub_edtime = EdTime}};
        false ->
%%            ?PRINT("---- Race 1 MATCH ~n", []),
            Rac1Max = data_kf_1vN_m:get_config(race_1_max_times),
            SubEndTime = Now + MatchTime,
            F = fun(Area, Roles, [TmpRoleM, TmpRace1RankM, TmpRace1ShortRankM]) ->
                Rank = sort_score_rank(Roles),
                ShortRank = lists:sublist(Rank, 100),
                {MatchRoles, LeftRoles} = race_1_match(Roles, SerInfoList),
                send_to_battle(MatchRoles, BattleTime, Stage, Now, LoadingTime, Area, ScenePoolM, MaxPower),
                {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn+1, EdTime, ?KF_1VN_STATE_MATCH, SubEndTime]),
                lib_kf_1vN:send_all_enter(Roles, BinData),
                {ok, BinData1} = pt_621:write(62132, [?ERRCODE(err621_not_match_yet), []]),
                lib_kf_1vN:send_all_enter([R || #kf_1vN_role{race_1_times = Times, pk = 0} = R <- LeftRoles, Times < Rac1Max], BinData1),
                RealMatchRoles = [R || R <- MatchRoles, is_record(R, kf_1vN_role)],
                [TmpRoleM#{Area:=LeftRoles++RealMatchRoles}, TmpRace1RankM#{Area=>Rank}, TmpRace1ShortRankM#{Area=>ShortRank}]
            end,
            [RoleM1, Race1RankM1, Race1ShortRankM] = maps:fold(F, [RoleM,Race1RankM,#{}], RoleM),
            MatchRef = erlang:send_after(MatchTime*1000, self(), match),
            mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, set_race_1_rank, [Race1ShortRankM], 50),
            {noreply, State#state{role_m=RoleM1, race_1_rank_m=Race1RankM1, last_match_time=Now, match_turn=MatchTurn+1, match_ref=MatchRef, sub_edtime = SubEndTime}}
    end;

do_handle_info(race_2_match, #state{stage=Stage} = State) when Stage/=?KF_1VN_FREE ->
    #state{
        sign_list=SignList, edtime=EdTime, role_m=RoleM, race_2_m=Race2M,
        match_time=MatchTime, match_turn=OMatchTurn, max_scene_pool=_MaxScenePool,
        scene_pool_m=ScenePoolM, ser_info_list=SerInfoList
    } = State,
    Now = utime:unixtime(),
    AllGroups = data_kf_1vN:get_all_groups(),
    MatchTurn = OMatchTurn+1,
    SignList1 = [E#kf_1vN_role_sign{bet_list=[]}||E<-SignList],
%%    ?PRINT("---- Race2MATCH --- ~n", []),
    case data_kf_1vN:get_stage_args(MatchTurn) of
        #kf_1vN_race_2_match{hard=Hard, c_num=ChallengerNum} -> %when MatchTurn < 2 ->
            HardList = create_race_2_hard_list(Hard, ChallengerNum, lists:last(AllGroups)),
%%            ?PRINT("---- HardList --- ~w~n", [HardList]),

            F = fun(Area, Race2, [TmpRace2M, TmpRoleM]) ->
                ORoles = maps:get(Area, TmpRoleM, []),
                Roles = [KfRole#kf_1vN_role{race_2_bet_id=0, race_2_battle_id=0, watch_battle_id=0}|| KfRole <-ORoles],
                case Roles of
                    [] -> [TmpRace2M, TmpRoleM];
                    _  ->
                        #kf_1vN_race_2{def_list=DefList, challenger_list=ChallengerList, battle_id=OBattleId, ac_end_type = AcEndType} = Race2,
                        case DefList of
                            [] when AcEndType == ?KF_1VN_RACE_2_AC_END_TYPE_NO ->
                                self() ! {ac_end, Area},
                                [TmpRace2M#{Area=>Race2#kf_1vN_race_2{match_list=[], bet_m=#{}, ac_end_type = ?KF_1VN_RACE_2_AC_END_TYPE_READY}}, TmpRoleM];
                            [] ->
                                [TmpRace2M#{Area=>Race2#kf_1vN_race_2{match_list=[], bet_m=#{}}}, TmpRoleM];
                            _  ->
                                DefAveAttr = calc_def_average_attr(DefList, #attr{}, 1),
                                {DefRank, ChallenageRank} = sort_race_2_rank(Roles, [], []),
                                ShortDefRank = lists:sublist(DefRank, 100),
                                ShortChallenageRank = lists:sublist(ChallenageRank, 100),
                                mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, update_race_2_rank, [Area, ShortDefRank, ShortChallenageRank], 50),
                                {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn, EdTime, ?KF_1VN_STATE_MATCH, Now+MatchTime]),
                                lib_kf_1vN:send_all_enter(Roles, BinData),

                                SortCL = sort_challenger_list_by_power(ChallengerList),
                                HardM = divide_group(SortCL),
                                {MatchList, NewBattleId, RolesN, DefListN, ChallengerListN}
                                    = race_2_match(DefList, Roles, HardM, HardList, DefAveAttr, Area, 1, OBattleId, ScenePoolM, SerInfoList, DefList, ChallengerList, []),
%%                                ?PRINT("MatchList ~n~p~n", [MatchList]),
%%                                ?PRINT("HardM ~p~n", [HardM]),
%%                                ?PRINT("SortCL ~p~n", [SortCL]),
                                [TmpRace2M#{Area=>Race2#kf_1vN_race_2{match_list=MatchList, battle_id=NewBattleId, bet_m=#{}, def_rank=ShortDefRank, def_list=DefListN, challenger_list=ChallengerListN}}, TmpRoleM#{Area=>RolesN}]
                        end
                end
            end,
            [Race2MN, RoleM1] = maps:fold(F, [Race2M, RoleM], Race2M),
            %Ref = case data_kf_1vN:get_stage_args(MatchTurn+1) of
            %    #kf_1vN_race_2_match{} ->
            Ref = erlang:send_after(MatchTime*1000+500, self(), race_2_bet),
            %    _ ->
            %        self() ! {ac_end, all},
            %        undefined
            %end,
            {noreply, State#state{sub_stage=?KF_1VN_STATE_MATCH, sign_list=SignList1, role_m=RoleM1, race_2_m = Race2MN, last_match_time=Now, match_turn=MatchTurn, match_ref=Ref, sub_edtime = Now + MatchTime}};
        _ -> %% MatchTrun没有配置，则认为是结束
            self() ! {ac_end, all},
            {noreply, State#state{sign_list=SignList1}}
    end;

do_handle_info(race_2_bet, #state{stage=Stage} = State) when Stage/=?KF_1VN_FREE ->
    #state{stage=Stage, edtime=EdTime, role_m=RoleM, match_turn=MatchTurn, race_2_m=Race2M} = State,
    BetTime = data_kf_1vN:get_value(?KF_1VN_CFG_BET_TIME), % data_kf_1vN_m:get_config(bet_time),
    Now = utime:unixtime(),
    SubEndTime = Now + BetTime,
%%    ?PRINT("---- race_2_bet --- ~n", []),
     F = fun(Area, _Race2) ->
            Roles = maps:get(Area, RoleM, []),
            {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn, EdTime, ?KF_1VN_STATE_BET, SubEndTime]),
            lib_kf_1vN:send_all_enter(Roles, BinData),
            TvBin = lib_chat:make_tv(?MOD_KF_1VN, 5, []),
            lib_kf_1vN:send_all_enter(Roles, TvBin)
    end,
    maps:map(F, Race2M),

    Ref = erlang:send_after(BetTime*1000+500, self(), race_2_send_battle),
    {noreply, State#state{sub_stage=?KF_1VN_STATE_BET, match_ref=Ref, sub_edtime = SubEndTime}};

do_handle_info(race_2_send_battle, #state{stage=Stage} = OldState) when Stage/=?KF_1VN_FREE ->
    State = race_2_side_def_quit(OldState),
    #state{stage=Stage, edtime=EdTime, role_m=RoleM, race_2_m=Race2M, match_turn=MatchTurn, battle_time=BattleTime, max_power = MaxPower} = State,
    Now = utime:unixtime(),
    LoadingTime = data_kf_1vN_m:get_config(loading_time),
    SubEndTime = Now+LoadingTime+BattleTime,
%%    ?PRINT("---- race_2_send_battle --- ~n", []),
    F = fun(Area, Race2) ->
            Roles = maps:get(Area, RoleM, []),
            {ok, BinData} = pt_621:write(62101, [Stage, MatchTurn, EdTime, ?KF_1VN_STATE_FIGHT, SubEndTime]),
            lib_kf_1vN:send_all_enter(Roles, BinData),
            #kf_1vN_race_2{match_list=MatchList} = Race2,
            MatchList1 = send_to_battle_race_2(MatchList, BattleTime, Stage, Now, LoadingTime, MatchTurn, [], MaxPower),
            Race2#kf_1vN_race_2{match_list=MatchList1}
    end,

    Race2M1 = maps:map(F, Race2M),
    Ref = erlang:send_after((LoadingTime+BattleTime)*1000+500, self(), race_2_match),
    {noreply, State#state{sub_stage=?KF_1VN_STATE_FIGHT, match_ref=Ref, race_2_m=Race2M1, sub_edtime = SubEndTime}};

do_handle_info({ac_end, Area}, State) ->
    #state{stage=_Stage, area_list=AreaList, race_2_m=Race2M, role_m=RoleM, match_ref=MatchRef, exp_ref=ExpRef} = State,
    % ?MYLOG("hjhacend", "Area:~p AreaList:~p ~n", [Area, AreaList]),
    case AreaList of
        [] -> {noreply, State};
        _ ->
            IsAllEnd = case Area of
                all -> true;
                _ -> case lists:delete(Area, AreaList) of
                        [] -> true;
                        AreaList1 -> {false, AreaList1}
                    end
            end,
            F2 = fun(#kf_1vN_def_rank{name=Name, rank=Rank}, List) ->
                TvBin = lib_chat:make_tv(?MOD_KF_1VN, 9, [Name, Rank]),
                [TvBin|List]
            end,
            case IsAllEnd of
                {false, LeftAreaList} ->
%%                    ?PRINT("---- ac end area ~w --- ~n", [Area]),
                    Roles = maps:get(Area, RoleM, []),
                    {DefRank, ChallenageRank} = sort_race_2_rank(Roles, [], []),
                    ShortDefRank = lists:sublist(DefRank, 100),
                    ShortChallenageRank = lists:sublist(ChallenageRank, 100),
                    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, update_race_2_rank, [Area, ShortDefRank, ShortChallenageRank], 50),
                    % 发送传闻,
                    BinDataL = lists:foldl(F2, [], lists:sublist(DefRank, 3)),
                    ?IF(BinDataL == [], skip, mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, send_area_msg, [Area, list_to_binary(lists:reverse(BinDataL))], 50)),
                    send_race_2_def_award(DefRank),
                    case maps:get(Area, Race2M, false) of
                        #kf_1vN_race_2{ac_end_type = ?KF_1VN_RACE_2_AC_END_TYPE_RESULT} = Race2 ->
                            ?MYLOG("lzh1vnerror", "Area:~p, AreaList:~p, Race2:~p ShortDefRank:~p ~n", [Area, AreaList, Race2, ShortDefRank]);
                        _ ->
                            skip
                    end,
                    Race2M1 = Race2M#{Area=>#kf_1vN_race_2{def_rank=ShortDefRank, ac_end_type=?KF_1VN_RACE_2_AC_END_TYPE_RESULT}},
                    lib_kf_1vN:db_save_def_rank(ShortDefRank, Area),

                    {noreply, State#state{area_list=LeftAreaList, race_2_m=Race2M1}};
                true ->
                    NextStage = ?KF_1VN_END,
                    NextSubStage = ?KF_1VN_STATE_END,
                    Now = utime:unixtime(),
                    EdTime = Now+60,
                    util:cancel_timer(MatchRef),
                    util:cancel_timer(ExpRef),
                    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, stage_change, [NextStage, 1, EdTime, NextSubStage, EdTime]),

%%                    ?PRINT("---- ac end all --- ~n", []),
                    F = fun(TmpArea, Roles, TmpRace2M) ->
%%                            ?PRINT("---- ac end all area --- ~w ~n", [{TmpArea, AreaList}]),
                        case lists:member(TmpArea, AreaList) of
                            true ->
                                {DefRank, ChallenageRank} = sort_race_2_rank(Roles, [], []),
                                ShortDefRank = lists:sublist(DefRank, 100),
                                ShortChallenageRank = lists:sublist(ChallenageRank, 100),
                                mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, update_race_2_rank, [TmpArea, ShortDefRank, ShortChallenageRank], 50),
                                % 发送传闻,
                                BinDataL = lists:foldl(F2, [], lists:sublist(DefRank, 3)),
                                ?IF(BinDataL == [], skip, mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, send_area_msg, [TmpArea, list_to_binary(lists:reverse(BinDataL))], 50)),
                                send_race_2_def_award(DefRank),
                                case maps:get(TmpArea, TmpRace2M, false) of
                                    #kf_1vN_race_2{ac_end_type = ?KF_1VN_RACE_2_AC_END_TYPE_RESULT} = Race2 ->
                                        ?MYLOG("lzh1vnerror", "Area:~p, AreaList:~p, Race2:~p ShortDefRank:~p ~n", [Area, AreaList, Race2, ShortDefRank]);
                                    _ ->
                                        skip
                                end,
                                lib_kf_1vN:db_save_def_rank(ShortDefRank, TmpArea),
                                TmpRace2M#{TmpArea =>#kf_1vN_race_2{def_rank=ShortDefRank, ac_end_type=?KF_1VN_RACE_2_AC_END_TYPE_RESULT}};
                            false ->
                                TmpRace2M
                        end
                    end,
                    Race2M1 = maps:fold(F, #{}, RoleM),

                    erlang:send_after(60000, self(), ac_stop),

                    {noreply, State#state{stage=NextStage, sub_stage=NextSubStage, race_2_m=Race2M1}}
            end
    end;

do_handle_info(ac_stop, State) ->
    #state{role_m=RoleM, race_2_m=Race2M, race_1_rank_m=Race1RankM} = State,
    mod_kf_1vN_mgr:ac_end(), %% 告诉管理进程活动结束
    NextStage = ?KF_1VN_FREE,
    NextSubStage = ?KF_1VN_STATE_WAIT,
    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, stage_change, [NextStage, 1, 0, NextSubStage, 0]),
    %% 踢出玩家
    F = fun(_Area, Roles) ->
        [lib_kf_1vN:quit_to_main_scene(E#kf_1vN_role.server_id, E#kf_1vN_role.id) || E <- Roles, E#kf_1vN_role.enter =/= 0]
    end,
    maps:map(F, RoleM),
    lib_kf_1vN:db_clean_sign_center(),
    F2 = fun(Area, ScoreRank) ->
        ShortScoreRank = lists:sublist(ScoreRank, 100),
        lib_kf_1vN:db_save_kf_1vn_score_rank(ShortScoreRank, Area),
        ShortScoreRank
    end,
    ShortRace1RankM = maps:map(F2, Race1RankM),
    {noreply, #state{stage=NextStage, sub_stage=NextSubStage, race_2_m=Race2M, race_1_rank_m=ShortRace1RankM}};

do_handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~p]~n", [_Info]),
    {noreply, State}.

divide_group(SortChallengerList) ->
    CLLen = length(SortChallengerList),
    HardList = data_kf_1vN:get_all_groups(),
    F = fun(Hard, [GroupList, Sum]) ->
            #kf_1vN_group{height=Height} = data_kf_1vN:get_group(Hard),
            [ [{Hard, Height}|GroupList], Sum+Height ]
    end,
    [GroupL, HeightSum] = lists:foldl(F, [[], 0], HardList),
    divide_group_roles(GroupL, HeightSum, SortChallengerList, CLLen, #{}, 1).

divide_group_roles([{Hard, GHeight}|T], HeightSum, SortChallengerList, CLLen, HardM, AccNum) ->
    SubNum  = round(GHeight*CLLen/HeightSum),
    RList   = case AccNum > CLLen of
        true  -> [];
        false -> lists:sublist(SortChallengerList, AccNum, SubNum)
    end,
    HardM1  = HardM#{Hard => [Id || {Id, _} <- RList]},
    divide_group_roles(T, HeightSum, SortChallengerList, CLLen, HardM1, AccNum+SubNum);
divide_group_roles([], _HeightSum, _SortChallengerList, _CLLen, HardM, _AccNum) -> HardM.


terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 划分玩家区域
cut_area(SignList) ->
    F = fun(#kf_1vN_role_sign{lv=Lv}=H, KvList) ->
        AreaId = data_kf_1vN:get_area(Lv),
        NewAreaId = ?IF(AreaId > 0, AreaId, 1),
        case lists:keyfind(NewAreaId, 1, KvList) of
            false -> Area = [];
            {_AreaId, Area} -> ok
        end,
        lists:keyreplace(NewAreaId, 1, KvList, {NewAreaId, [H#kf_1vN_role_sign{area=NewAreaId}|Area]})
    end,
    KvList = [{AreaId, []}||AreaId<-data_kf_1vN:get_area_list()],
    NewKvList = lists:foldl(F, KvList, SignList),
    L = [Area||{_AreaId, Area}<-NewKvList],
    MinNum = data_kf_1vN:get_value(?KF_1VN_CFG_AREA_MIN_NUM),
    R = merge_area(L, MinNum, 1, [], []),
%%    ?MYLOG("lzh1vn", "SignList:~p KvList:~p NewKvList:~p R:~p ~n", [SignList, KvList, NewKvList, R]),
    R.

merge_area([H1, H2|T], MinNum, Index, Result, AreaList) ->
    case length(H1) < MinNum of
        true  ->
            Title = utext:get(323),
            F = fun(RoleSign) ->
                    Content = utext:get(324, [Index, Index+1]),
                    mod_clusters_center:apply_cast(RoleSign#kf_1vN_role_sign.server_id, lib_mail_api, send_sys_mail, [[RoleSign#kf_1vN_role_sign.id], Title, Content, []]),
                    RoleSign#kf_1vN_role_sign{area=Index+1}
            end,
            H1N = [F(E) || E <- H1],
            merge_area([H1N++H2|T], MinNum, Index+1, Result, AreaList);
        false -> merge_area([H2|T], MinNum, Index+1, H1++Result, [Index|AreaList])
    end;
merge_area([[]], _MinNum, _Index, Result, AreaList) -> {Result, AreaList};
merge_area([H], _MinNum, Index, Result, AreaList) -> {H++Result, [Index|AreaList]};
merge_area(_, _, _Index, Result, AreaList) -> {Result, AreaList}.

change_local_area([#kf_1vN_role_sign{server_id=ServerId, id=Id, area=Area}|T], SignAreaM) ->
    SignInfos =  maps:get(ServerId, SignAreaM, []),
    change_local_area(T, SignAreaM#{ServerId => [{Id, Area}|SignInfos]});
change_local_area([], SignAreaM) ->
    F = fun(ServerId, SignInfos) ->
            %?PRINT("SignInfos ~w~n", [SignInfos]),
            mod_clusters_center:apply_cast(ServerId, mod_kf_1vN_local, sign_info, [SignInfos])
    end,
    maps:map(F, SignAreaM).

%% 资格赛匹配
race_1_match(Roles, SerInfoL) ->
    Rac1Max = data_kf_1vN_m:get_config(race_1_max_times),
    F = fun(R) ->
        R#kf_1vN_role.enter==1 andalso R#kf_1vN_role.pk == 0 andalso R#kf_1vN_role.race_1_times < Rac1Max
    end,
    {WaitingRoles, Left} = lists:partition(F, Roles),
    {Result1, RestRoles} = race_1_match_sucker(WaitingRoles, SerInfoL),
    {Result2, LeftRoles} = race_1_match_normal(RestRoles, SerInfoL),
    {Result1++Result2, Left++LeftRoles}.

%% 先匹配遭遇连败的玩家
race_1_match_sucker(Roles, SerInfoL) ->
    % 对连败玩家分堆
    LoseProtect = data_kf_1vN_m:get_config(lose_streak_protect),
    F = fun(#kf_1vN_role{lose_streak = LoseStreak}) -> LoseStreak >= LoseProtect end,
    {SuckerRoles, NormalRoles} = lists:partition(F, Roles),
    % 按战力排序,让高战力的尽量匹配高战力并达到复用匹配池
    SortSuckers = lists:reverse(lists:keysort(#kf_1vN_role.combat_power, SuckerRoles)),
    SortNormals = lists:reverse(lists:keysort(#kf_1vN_role.combat_power, NormalRoles)),
    race_1_match_sucker(SortSuckers, SortNormals, SerInfoL, [], []).

race_1_match_sucker([], RestRoles, _, Left, Result) -> {Result, Left++RestRoles};
race_1_match_sucker([#kf_1vN_role{combat_power = CP1} = Sucker | T], NormalRoles, SerInfoL, Left, Result) ->
    Factor = data_kf_1vN_m:get_config(match_protect_cp_factor),
    F = fun(#kf_1vN_role{combat_power = CP2}) -> CP1 * Factor >= CP2 end,
    {Pool, GoodRoles} = lists:partition(F, NormalRoles),
    case Pool of
        [] -> % 已经没有战力更低的人了,匹配机器人
            Robot = lib_kf_1vN:trans_to_pk_robot(Sucker, SerInfoL),
            NSucker = Sucker#kf_1vN_role{pk = 1, race_1_match = 0},
            race_1_match_sucker(T, [], SerInfoL, Left++GoodRoles, [NSucker, Robot | Result]);
        [Opponent | RestRoles] ->
            NSucker = Sucker#kf_1vN_role{pk = 1, race_1_match = 0},
            NOpponent = Opponent#kf_1vN_role{pk = 1, race_1_match = 0},
            race_1_match_sucker(T, RestRoles, SerInfoL, Left++GoodRoles, [NSucker, NOpponent | Result])
    end.

%% 普通玩家匹配
race_1_match_normal(Roles, SerInfoList) ->
    race_1_match_normal(Roles, [], [], SerInfoList).

race_1_match_normal([H1, H2|T], Result, Left, SerInfoList) ->
    #kf_1vN_role{race_1_match=R1M1, race_1_seed=Race1Seed1, combat_power=CP1} = H1,
    case race_1_match_get_competitor([H2|T], CP1, R1M1, Race1Seed1, 1, 8, [], []) of %% 往后帅选8个
        false when R1M1 > ?RACE_1_MATCH_COUNT ->
            Robot = lib_kf_1vN:trans_to_pk_robot(H1, SerInfoList),
            H1N = H1#kf_1vN_role{pk=1, race_1_match=0},
            race_1_match_normal([H2|T], [H1N, Robot|Result], Left, SerInfoList);
        false ->
            H1N = H1#kf_1vN_role{race_1_match=R1M1+1},
            race_1_match_normal([H2|T], Result, [H1N|Left], SerInfoList);
        {true, Ctor, LeftT} ->
            H1N = H1#kf_1vN_role{pk=1, race_1_match=0},
            CtorN = Ctor#kf_1vN_role{pk=1, race_1_match=0},
            race_1_match_normal(LeftT, [H1N, CtorN|Result], Left, SerInfoList)
    end;
race_1_match_normal([#kf_1vN_role{race_1_match=Old, race_1_times = T}=H], Result, Left, SerInfoList) ->
    if
        Old > ?RACE_1_MATCH_COUNT ->
            Robot = lib_kf_1vN:trans_to_pk_robot(H, SerInfoList),
            HN = H#kf_1vN_role{pk=1, race_1_times=T, race_1_match=0},
            {[HN, Robot|Result], Left};
        true ->
            {Result, [H#kf_1vN_role{race_1_match=Old+1}|Left]}
    end;
race_1_match_normal(_, Result, Left, _) -> {Result, Left}.

%% 获取战力值为CP1的匹配对手
race_1_match_get_competitor([], _CP1, _Race1Match1, _Race1Seed1, _Num, _MaxNum, Result, BadResult) ->
     case ulists:list_shuffle(Result) of
        [] -> false;
        [Ctor1|UnChoose] -> {true, Ctor1, UnChoose++BadResult}
    end;
race_1_match_get_competitor(Ctors, CP1, Race1Match1, Race1Seed1, MaxNum, MaxNum, Result, BadResult) ->
    race_1_match_get_competitor([], CP1, Race1Match1, Race1Seed1, MaxNum, MaxNum, Result, BadResult++Ctors);
race_1_match_get_competitor([Ctor|T], CP1, Race1Match1, Race1Seed1, Num, MaxNum, Result, BadResult) ->
    #kf_1vN_role{race_1_match=_Race1Match2, race_1_seed=Race1Seed2, combat_power=CP2} = Ctor,
    CPGap = abs(CP1 - CP2),
    Race1Ratio1 = data_kf_1vN_m:get_race_1_match_args(Race1Match1),
    %?PRINT("race_1_match_get_competitor ============ ~w~n", [{Race1Seed1, Race1Seed2, Race1Match1}]),
    if
        Race1Seed1 == 1 andalso Race1Seed2 == 1 andalso Race1Match1 < 10 -> race_1_match_get_competitor(T, CP1, Race1Match1, Race1Seed1, Num, MaxNum, Result, [Ctor|BadResult]);
        CPGap > CP1 * Race1Ratio1 -> race_1_match_get_competitor(T, CP1, Race1Match1, Race1Seed1, Num+1, MaxNum, Result, [Ctor|BadResult]);
        true -> race_1_match_get_competitor(T, CP1, Race1Match1, Race1Seed1, Num+1, MaxNum, [Ctor|Result], BadResult)
    end.
    % race_1_match_get_competitor(T, CP1, Race1Match1, Race1Seed1, Num+1, MaxNum, [Ctor|Result], BadResult).

%% 擂台赛匹配
race_2_match([{DefId, _}|T], Roles, HardM, HardList, Attr, Area, RobotId, BattleId, ScenePoolM, SerInfoList, DefList, ChallengerList, MatchL) ->
    case lists:keyfind(DefId, #kf_1vN_role.id, Roles) of
        #kf_1vN_role{server_num=_DefServerNum, enter=1} = DefRole ->
            {HardM1, Challengers, NewRobotId, RolesC} = race_2_match_challenger(HardList, HardM, Roles, Attr, Area, DefRole, SerInfoList, RobotId, BattleId, []),
            % PKScenePoolId = urand:rand(0, MaxScenePool),
            PKScenePoolId = rand_scene_pool_id(ScenePoolM, Area),
            MathInfo = #kf_1vN_race_2_match_info{battle_id=BattleId, scene_pool_id=PKScenePoolId, def_role=DefRole, challengers = Challengers},
            Roles1 = lists:keyreplace(DefId, #kf_1vN_role.id, RolesC, DefRole#kf_1vN_role{race_2_battle_id=BattleId}),
            race_2_match(T, Roles1, HardM1, HardList, Attr, Area, NewRobotId, BattleId+1, ScenePoolM, SerInfoList, DefList, ChallengerList, [MathInfo|MatchL]);
        #kf_1vN_role{enter=0, combat_power=DefCombatPower} = DefRole ->
            Roles1 = lists:keyreplace(DefId, #kf_1vN_role.id, Roles, DefRole#kf_1vN_role{race_2_lose=1}),
            race_2_match(T, Roles1, HardM, HardList, Attr, Area, RobotId, BattleId, ScenePoolM, SerInfoList, lists:keydelete(DefId, 1, DefList), [{DefId, DefCombatPower}|ChallengerList], MatchL);
        _ ->
            race_2_match(T, Roles, HardM, HardList, Attr, Area, RobotId, BattleId, ScenePoolM, SerInfoList, lists:keydelete(DefId, 1, DefList), ChallengerList, MatchL)
    end;
race_2_match([], Roles, _HardM, _HardList, _Attr, _Area, _RobotId, BattleId, _ScenePoolM, _SerInfoList, DefList, ChallengerList, MatchL) -> {MatchL, BattleId, Roles, DefList, ChallengerList}.

%% 擂台赛选出挑战者
race_2_match_challenger([Hard|T], HardM, Roles, Attr, Area, DefRole, SerInfoList, RobotId, BattleId, Result) ->
    {Result1, HardM1, Roles1} = case maps:get(Hard, HardM, false) of
        false -> { [lib_kf_1vN:create_robot_pk(Hard, Attr, Area, RobotId, DefRole, SerInfoList)|Result], HardM, Roles};
        []  ->   { [lib_kf_1vN:create_robot_pk(Hard, Attr, Area, RobotId, DefRole, SerInfoList)|Result], HardM, Roles};
        Ids ->
            case race_2_select_enter_challenger(Ids, Roles, Area, BattleId) of
                {ChallengerPk, LeftIds, TmpRoles} -> {[ChallengerPk|Result], HardM#{Hard=>LeftIds}, TmpRoles};
                _ ->
                    { [lib_kf_1vN:create_robot_pk(Hard, Attr, Area, RobotId, DefRole, SerInfoList)|Result], HardM, Roles}
            end
    end,
    race_2_match_challenger(T, HardM1, Roles1, Attr, Area, DefRole, SerInfoList, RobotId+1, BattleId, Result1);
race_2_match_challenger([], HardM, Roles, _Attr, _Area, _DefRole, _SerInfoList, RobotId, _BattleId, Result) -> {HardM, Result, RobotId, Roles}.

race_2_select_enter_challenger([], _, _, _) -> false;
race_2_select_enter_challenger(Ids, Roles, Area, BattleId) ->
    [Id|T] = ulists:list_shuffle(Ids),
    case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
        #kf_1vN_role{enter=1} = R ->
            TmpRoles = lists:keyreplace(Id, #kf_1vN_role.id, Roles, R#kf_1vN_role{race_2_battle_id=BattleId}),
            { lib_kf_1vN:trans_to_pk_role(R, Area), lists:delete(Id, Ids), TmpRoles};
        _ ->
            race_2_select_enter_challenger(T, Roles, Area, BattleId)
    end.

%% 传送到战斗场景
send_to_battle([PlayerA, PlayerB|T], BattleTime, Stage, Now, LoadingTime, Area, ScenePoolM, MaxPower) ->
    SideA = lib_kf_1vN:trans_to_pk_role(PlayerA),
    SideB = lib_kf_1vN:trans_to_pk_role(PlayerB),
    % PKScenePoolId = urand:rand(0, MaxScenePool),
    PKScenePoolId = rand_scene_pool_id(ScenePoolM, Area),
    mod_kf_1vN_pk:start_link([SideA, [SideB], BattleTime, Stage, 0, 0, PKScenePoolId, MaxPower]),
    % {ok, BinData} = pt_621:write(62105, [
    %         [
    %             to_62105_battle(SideA),
    %             to_62105_battle(SideB)
    %         ],
    %         Now+LoadingTime, Now+LoadingTime+BattleTime
    %     ]),
    % [mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]) || #kf_1vN_role{server_id = SerId, id = Id} <- [PlayerA, PlayerB]],
    send_to_battle(T, BattleTime, Stage, Now, LoadingTime, Area, ScenePoolM, MaxPower);
send_to_battle([], _, _, _, _, _, _, _) -> skip.

to_62105_battle(
        #kf_1vN_role_pk{id = Id, platform=Platform, server_num=ServerNum, server_name = SerName, name = Name, career = Career, combat_power = Power,
            win = Win, race_1_times = RaceTimes, sex = Sex, picture = Picture, picture_ver = PictureVer, lv = Lv}) ->
    {Id, Platform, ServerNum, SerName, Name, Career, Power, Win, RaceTimes - Win - 1, Sex, Picture, PictureVer, Lv}.


send_to_battle_race_2(
        [#kf_1vN_race_2_match_info{battle_id=BattleId, scene_pool_id=ScenePoolId, def_role=DefRole, challengers=ChallengerList, status=?KF_1VN_RACE_2_MATCH_STATUS_NO}=H|T],
        BattleTime, Stage, Now, LoadingTime, MatchTurn, Result, MaxPower) ->
    SideA = lib_kf_1vN:trans_to_pk_role(DefRole, DefRole#kf_1vN_role.area),

    {ok, Pid} = mod_kf_1vN_pk:start_link([SideA, ChallengerList, BattleTime, Stage, MatchTurn, BattleId, ScenePoolId, MaxPower]),
    send_to_battle_race_2(T, BattleTime, Stage, Now, LoadingTime, MatchTurn, [H#kf_1vN_race_2_match_info{copy_id=Pid}|Result], MaxPower);
send_to_battle_race_2([H|T], BattleTime, Stage, Now, LoadingTime, MatchTurn, Result, MaxPower) -> send_to_battle_race_2(T, BattleTime, Stage, Now, LoadingTime, MatchTurn, [H|Result], MaxPower);
send_to_battle_race_2([], _, _, _, _, _, Result, _) -> Result.


update_role_dt([H|T], KfRole) ->
    KfRoleN = case H of
        {win, Value} -> KfRole#kf_1vN_role{win=Value};
        {win_streak, Value} -> KfRole#kf_1vN_role{win_streak=Value};
        {lose_streak, Value} -> KfRole#kf_1vN_role{lose_streak=Value};
        {score, Value} -> KfRole#kf_1vN_role{score=Value};
        {pk, Value} -> KfRole#kf_1vN_role{pk=Value};
        {pk_time, Value} -> KfRole#kf_1vN_role{pk_time=Value};
        {race_1_times, Value} -> KfRole#kf_1vN_role{race_1_times = Value};
        {race_2_lose, Value} -> KfRole#kf_1vN_role{race_2_lose=Value};
        {race_2_turn, Value} ->
            mod_clusters_center:apply_cast(KfRole#kf_1vN_role.server_id, lib_kf_1vN, update_player_1vn, [KfRole#kf_1vN_role.id, 1, Value]),
            KfRole#kf_1vN_role{race_2_turn=Value};
        {race_2_time, Value} -> KfRole#kf_1vN_role{race_2_time=Value};
        {hp, Value} -> KfRole#kf_1vN_role{hp=Value};
        {hp_lim, Value} -> KfRole#kf_1vN_role{hp_lim=Value};
        _ -> KfRole
    end,
    update_role_dt(T, KfRoleN);
update_role_dt(_, KfRole) -> KfRole.

%% 发送场景banner
send_race_2_banner(State) ->
    #state{role_m=RoleM} = State,
    F = fun(_Area, Roles) ->
            lists:map(fun(#kf_1vN_role{id=Id, server_id=SerId, score=Score, enter=Enter, exp=Exp, race_2_side=Race2Side}) ->
                        case Enter of
                            1 ->
                                {ok, BinData} = pt_621:write(62111, [Score, Exp, Race2Side]),
                                mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]);
                            _ -> skip
                        end
                end, Roles)
    end,
    maps:map(F, RoleM),
    ok.

%% 发送场景banner
send_banner(Area, Id, State) ->
    #state{stage=Stage, optime=OpTime, edtime=EdTime, role_m=RoleM, match_time=MatchTime, last_match_time=LastMatchTime, def_num_m=DefNumM} = State,
    Race1MaxTimes = data_kf_1vN_m:get_config(race_1_max_times),

    KfRole = case maps:get(Area, RoleM, false) of
        false -> false;
        Roles ->
            case lists:keyfind(Id, #kf_1vN_role.id, Roles) of
                false -> false;
                TmpV  -> TmpV
            end
    end,

    DefNum = maps:get(Area, DefNumM, 0),

    case Stage of
        ?KF_1VN_RACE_1_PRE when KfRole /= false ->
            {ok, BinData} = pt_621:write(62104, [Race1MaxTimes, 0, EdTime, 0, 0, KfRole#kf_1vN_role.exp, DefNum]),
            mod_clusters_center:apply_cast(KfRole#kf_1vN_role.server_id, lib_server_send, send_to_uid, [Id, BinData]);
        ?KF_1VN_RACE_1 when KfRole /= false ->
            #kf_1vN_role{server_id=SerId, race_1_times=Race1Times, score=Score, win=Win, exp=Exp} = KfRole,
            {ok, BinData} = pt_621:write(62104, [max(0, Race1MaxTimes-Race1Times), Score, max(OpTime, LastMatchTime)+MatchTime, Win, Race1Times-Win, Exp, DefNum]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]);
        ?KF_1VN_RACE_2_PRE when KfRole /= false ->
            #kf_1vN_role{server_id=SerId, score=Score, race_2_side=Race2Side, exp=Exp, race_1_times=Race1Times, win=Win} = KfRole,
            {ok, BinData} = pt_621:write(62111, [Score, Exp, Race2Side]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]),
            {ok, BinData2} = pt_621:write(62104, [max(0, Race1MaxTimes-Race1Times), Score, max(OpTime, LastMatchTime)+MatchTime, Win, Race1Times-Win, Exp, DefNum]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData2]);
        ?KF_1VN_RACE_2 when KfRole /= false ->
            #kf_1vN_role{server_id=SerId, score=Score, race_2_side=Race2Side, exp=Exp} = KfRole,
            IsDef = case Race2Side of
                ?SIDE_DEF -> 1;
                _ -> 0
            end,
            {ok, BinData} = pt_621:write(62111, [Score, Exp, IsDef]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]);
        _ -> skip
    end.

%% 积分排序
sort_score_rank(Roles) ->
%%    RankRoles = sort_roles_by_score([E || E <- Roles]),
    RankRoles = sort_roles_by_score(Roles),
    TopName = case RankRoles of
        [] -> "";
        [H|_] -> H#kf_1vN_role.figure#figure.name
    end,
    F1 = fun(Role, [Result, Rank]) ->
            #kf_1vN_role{
                id=Id, server_id=SerId, platform=Platform, server_num=SerNum, figure=Figure, server_name = SerName,
                combat_power=CombatPower, n_combat_power = NCombatPower, score=Score, win=Win, race_1_times=Race1Times} = Role,

            {ok, BinData} = pt_621:write(62119, [Rank, TopName]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]),
            case Rank > 100 of
                true ->
                    [Result, Rank+1];
                false ->
                    [ [#kf_1vN_score_rank{
                            rank=Rank, id = Id, server_id=SerId, platform=Platform, server_num=SerNum, server_name = SerName,
                            name=Figure#figure.name, guild_name=Figure#figure.guild_name, vip=Figure#figure.vip,
                            score=Score, win=Win, lose=Race1Times-Win, combat_power = CombatPower, n_combat_power = NCombatPower,
                            career=Figure#figure.career, lv=Figure#figure.lv
                      }|Result], Rank+1]
            end
    end,
    [Ranks, _] = lists:foldl(F1, [[], 1], RankRoles),
    lists:reverse(Ranks).

sort_challenger_list_by_power(ChallengerList) ->
    F = fun({_, CombatPower1}, {_, CombatPower2}) ->
            CombatPower1 >= CombatPower2
    end,
    lists:sort(F, ChallengerList).

sort_roles_by_score(Roles) ->
    F = fun(#kf_1vN_role{score=Score1, combat_power=CombatPower1}, #kf_1vN_role{score=Score2, combat_power=CombatPower2}) ->
            Score1 > Score2 orelse (Score1 == Score2 andalso CombatPower1 >= CombatPower2)
    end,
    lists:sort(F, Roles).

send_race_1_reward([#kf_1vN_role{server_id=SerId, id=Id, score=Score}|T], DefNum, Rank) ->
    Awards =  data_kf_1vN:get_score_rank_reward(1, Rank),
    IsDef = case Rank > DefNum of
        true  -> 0;
        false -> 1
    end,
    {ok, BinData} = pt_621:write(62109, [IsDef, Rank, Score, Awards]),
    mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData]),
    case Awards of
        [] -> skip;
        _  ->
            Title = utext:get(312),
            Content = utext:get(313, [Rank]),
            % Produce = #produce{type=kf_1vn_race_1_score_rank, title=Title, content=Content, off_title=Title, off_content=Content, show_tips=1, reward=Awards},
            % mod_clusters_center:apply_cast(SerId, lib_goods_api, send_reward_with_mail, [Id, Produce])
            mod_clusters_center:apply_cast(SerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, Awards])
    end,
    send_race_1_reward(T, DefNum, Rank+1);
send_race_1_reward([_|T], DefNum, Rank) -> send_race_1_reward(T, DefNum, Rank+1);
send_race_1_reward([], _, _) -> ok.

%% 创建挑战赛难度列表
create_race_2_hard_list(Hard, ChallengerNum, LastGroup) ->
    BaseL = lists:duplicate(ChallengerNum, 1),
    case Hard =< ChallengerNum*LastGroup of %% 这里预防策划配置填错导致的死循环
        true  -> race_2_list_add_hard(BaseL, ChallengerNum, Hard, LastGroup, []);
        false -> BaseL
    end.

race_2_list_add_hard([H|T], Sum, MaxSum, MaxRand, ResultList) ->
    Rand = urand:rand(0, MaxRand-H),
    %?PRINT("RAND ~w~n", [{H, Rand, Sum, MaxSum, MaxRand, ResultList}]),
    case Rand + Sum >= MaxSum of
        true  -> [H+MaxSum-Sum|T] ++ ResultList;
        false -> race_2_list_add_hard(T, Sum+Rand, MaxSum, MaxRand, [H+Rand|ResultList])
    end;
race_2_list_add_hard([], _Sum, MaxSum, MaxRand, Result) ->
    Sum = lists:sum(Result),
    race_2_list_add_hard(Result, Sum, MaxSum, MaxRand, []).

calc_def_average_attr([{_, Attr}|T], AttrSum, Len) ->
    AttrSum1 = lib_player_attr:add_attr(record, [Attr, AttrSum]),
    calc_def_average_attr(T, AttrSum1, Len+1);
calc_def_average_attr([], AttrSum, Len) ->
    #attr{hp=Hp,  att=Att, def=Def, hit=Hit, dodge=Dodge, crit=Crit, ten=Ten, wreck=Wreck %% , resist=Resist,
%%        crit_add_num=CirtAddNum, crit_del_num=CritDelNum,
%%        hurt_add_num=HurtAddNum, hurt_del_num=HurtDelNum,
%%        demon_suck_blood = DemonSuckBlood
    } = AttrSum,
    #attr{hp=round(Hp/Len), att=round(Att/Len), def=round(Def/Len), hit=round(Hit/Len),
        dodge=round(Dodge/Len), crit=round(Crit/Len), ten=round(Ten/Len), wreck=round(Wreck/Len)
%%        , resist=round(Resist/Len),
%%        crit_add_num=round(CirtAddNum/Len), crit_del_num=round(CritDelNum/Len),
%%        hurt_add_num=round(HurtAddNum/Len), hurt_del_num=round(HurtDelNum/Len),
%%        demon_suck_blood =round(DemonSuckBlood/Len)
    }.


sort_race_2_rank([H|T], DefRank, ChallengerRank) ->
    #kf_1vN_role{
        id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, figure=#figure{name=Name, guild_name=GName, vip=VipLv, career=Career, lv = Lv},
        combat_power=CombatPower, n_combat_power = NCombatPower, server_name = ServerName,
        race_2_side=Race2Side, race_2_lose=Race2Lose, race_2_turn=Race2Turn, race_2_time=Race2Time, score=Score, enter=Enter, hp=Hp, hp_lim=HpLim} = H,
    [DefRank1, ChallengerRank1] = case Race2Side of
        ?SIDE_DEF ->
            [[#kf_1vN_def_rank{id=Id, server_id=ServerId, platform=Platform, server_num=ServerNum, name=Name, guild_name=GName, vip=VipLv,
                combat_power=CombatPower, n_combat_power = NCombatPower, career=Career, server_name = ServerName,
                score=Score, race_2_lose=Race2Lose, race_2_turn=Race2Turn, race_2_time=Race2Time, enter=Enter, lv=Lv, hp=Hp, hp_lim=HpLim}|DefRank], ChallengerRank];
        ?SIDE_CHALLENGER -> [DefRank,
            [#kf_1vN_challenger_rank{id=Id, server_id=ServerId, server_num=ServerNum, name=Name, guild_name=GName, vip=VipLv,
                combat_power=CombatPower, n_combat_power = NCombatPower, career=Career, score=Score, enter=Enter}|ChallengerRank]];
        _ -> [DefRank, ChallengerRank]
    end,
    sort_race_2_rank(T, DefRank1, ChallengerRank1);
sort_race_2_rank([],  DefRank, ChallengerRank) ->
    {sort_def_rank(DefRank), sort_challenger_rank(ChallengerRank)}.

sort_def_rank(DefRank) ->
    F = fun(#kf_1vN_def_rank{race_2_turn=Race2Turn1, race_2_time=Race2Time1, combat_power=CombatPower1, race_2_lose=Race2Lose1},
            #kf_1vN_def_rank{race_2_turn=Race2Turn2, race_2_time=Race2Time2, combat_power=CombatPower2, race_2_lose=Race2Lose2}) ->
            if
                Race2Turn1 > Race2Turn2 -> true;
                Race2Turn1 == Race2Turn2 andalso Race2Lose1 < Race2Lose2 -> true;
                Race2Turn1 == Race2Turn2 andalso Race2Lose1 == Race2Lose2 andalso Race2Lose1 == 1 andalso Race2Time1 > Race2Time2 -> true;
                Race2Turn1 == Race2Turn2 andalso Race2Lose1 == Race2Lose2 andalso Race2Lose1 == 0 andalso Race2Time1 < Race2Time2 -> true;
                Race2Turn1 == Race2Turn2 andalso Race2Lose1 == Race2Lose2 andalso Race2Time1 == Race2Time2 andalso CombatPower1 >= CombatPower2 -> true;
                true -> false
            end
    end,
    set_race_2_rank_num(lists:sort(F, DefRank), 1, []).
sort_challenger_rank(ChallengerRank) ->
    F = fun(#kf_1vN_challenger_rank{score=Score1}, #kf_1vN_challenger_rank{score=Score2}) ->
            Score1 >= Score2
    end,
    set_race_2_rank_num(lists:sort(F, ChallengerRank), 1, []).

set_race_2_rank_num([H|T], Rank, Result) ->
    Result1 = case H of
        #kf_1vN_def_rank{} -> [H#kf_1vN_def_rank{rank=Rank}|Result];
        #kf_1vN_challenger_rank{} -> [H#kf_1vN_challenger_rank{rank=Rank}|Result];
        _ -> Result
    end,
    set_race_2_rank_num(T, Rank+1, Result1);
set_race_2_rank_num([], _, Result) -> lists:reverse(Result).

% 不用邮件发奖励
% handle_bet_list([{ServerId, Id, OptNo, _BetCostType}|T], Ratio, DefIsWin, BattleId, BetTime) ->
%     % Title   = utext:get(316),
%     % Content = utext:get(317),
%     % BGold = round(data_kf_1vN_m:get_bet_cost(BetType) * Ratio),

%     % mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, [{?TYPE_BGOLD, 0, BGold}]]),
%     mod_clusters_center:apply_cast(ServerId, mod_kf_1vN_local, set_bet_battle_result, [Id, BattleId, BetTime, DefIsWin]),
%     {ok, BinData} = pt_621:write(62123, [BattleId, DefIsWin, 1]),
%     mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]),
%     handle_bet_list(T, Ratio, DefIsWin, BattleId, BetTime);
% handle_bet_list([{ServerId, Id, _, _BetCostType}|T], Ratio, DefIsWin, BattleId, BetTime) ->
%     % Title   = utext:get(314),
%     % Content = utext:get(315),

%     % mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, []]),
%     mod_clusters_center:apply_cast(ServerId, mod_kf_1vN_local, set_bet_battle_result, [Id, BattleId, BetTime, DefIsWin]),
%     {ok, BinData} = pt_621:write(62123, [BattleId, DefIsWin, 2]),
%     mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]),
%     handle_bet_list(T, Ratio, DefIsWin, BattleId, BetTime);

handle_bet_list([{ServerId, Id, OptNo, BetCostType}|T], SignList, MatchTurn, BattleResult, Hp, HpLim, LiveNum, BattleId, BetTime) ->
    BetResult = calc_bet_result(MatchTurn, BattleResult, Hp, HpLim, LiveNum, OptNo),
    mod_clusters_center:apply_cast(ServerId, mod_kf_1vN_local, set_bet_battle_result, [Id, BattleId, BetTime, BattleResult, BetResult]),
    case lists:keyfind(Id, #kf_1vN_role_sign.id, SignList) of
        #kf_1vN_role_sign{name = RoleName} -> ok;
        _ -> RoleName = ""
    end,
    lib_log_api:log_kf_1vn_bet_result(Id, RoleName, MatchTurn, BattleId, BetTime, BattleResult, Hp, HpLim, LiveNum, BetCostType, OptNo, BetResult),
    {ok, BinData} = pt_621:write(62123, [BattleId, BattleResult, BetResult]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]),
    handle_bet_list(T, SignList, MatchTurn, BattleResult, Hp, HpLim, LiveNum, BattleId, BetTime);
handle_bet_list([], _, _, _, _, _, _, _, _) -> ok.

send_race_2_def_award(DefRank) ->
%%    ?PRINT("send_race_2_def_award ~w~n", [length(DefRank)]),

    %% 发放擂主奖励界面
    FDef = fun(#kf_1vN_def_rank{server_id=ServerId, id=Id, score=Score, enter=Enter, race_2_turn=Race2Turn, race_2_lose=Race2Lose}, TmpRank) ->

            DefAwards = data_kf_1vN:get_score_rank_reward(2, TmpRank),
            case DefAwards of
                [] -> skip;
                _ ->
                    Title = utext:get(321),
                    Content = utext:get(322, [TmpRank]),
                    mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, DefAwards])
            end,
            case Enter of
                1 ->
                    case Race2Lose == 0 of
                        true -> Turn = Race2Turn;
                        false -> Turn = Race2Turn-1
                    end,
                    {ok, BinData} = pt_621:write(62120, [TmpRank, Score, DefAwards, Turn]),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]);
                _ -> skip
            end,
            TmpRank+1
    end,
    lists:foldl(FDef, 1, DefRank),
    ok.

add_exp([#kf_1vN_role{server_id=SerId, id=Id, figure=#figure{lv=Lv}, exp=OldExp, enter=Enter}=H|T], Result) when Enter==1 ->
    case data_kf_1vN:get_exp(Lv) of
        0 ->
            NewExp = OldExp;
        ExpAdd ->
            mod_clusters_center:apply_cast(SerId, lib_player, update_player_info, [Id, [{add_exp, ExpAdd}]]),
            NewExp = OldExp+ExpAdd,
            {ok, BinData} = pt_621:write(62122, [NewExp]),
            mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [Id, BinData])
    end,
    add_exp(T, [H#kf_1vN_role{exp=NewExp}|Result]);
add_exp([H|T], Result) -> add_exp(T, [H|Result]);
add_exp(_, Result) -> Result.


calc_def_num([AreaId|T], SignList, DefNumM, SeedNumM) ->
    Num = length([1 || E <- SignList, E#kf_1vN_role_sign.area==AreaId]),
    [DefNum, SeedNum] = data_kf_1vN:get_def_num(Num),
    calc_def_num(T, SignList, DefNumM#{AreaId => DefNum}, SeedNumM#{AreaId => SeedNum});
calc_def_num([], _SignList, DefNumM, SeedNumM) -> {DefNumM, SeedNumM}.


set_seed_role_sign([AreaId|T], SignList, SeedNumM) ->
    F = fun(#kf_1vN_role_sign{area=TmpAreaId}) ->
            AreaId == TmpAreaId
    end,
    {AreaSList, NoAreaL} = lists:splitwith(F, SignList),
    SeedNum = maps:get(AreaId, SeedNumM, 0),
    SortSignList = sort_sign_list(AreaSList),
    SetSeedAreaSList = set_seed(SortSignList, 1, SeedNum, []),
    set_seed_role_sign(T, SetSeedAreaSList++NoAreaL, SeedNumM);
set_seed_role_sign([], SignList, _) -> SignList.

sort_sign_list(SignList) ->
    F = fun(#kf_1vN_role_sign{combat_power=CP1}, #kf_1vN_role_sign{combat_power=CP2}) ->
            CP1 >= CP2
    end,
    lists:sort(F, SignList).

set_seed([H|T]=SignList, Index, SeedNum, Result) ->
    case Index > SeedNum of
        true  -> Result++SignList;
        false ->
            set_seed(T, Index+1, SeedNum, [H#kf_1vN_role_sign{race_1_seed=1}|Result])
    end;
set_seed([], _, _, Result) -> Result.

init_sorted_sign_list(SignList) ->
    L = lists:sublist(lists:reverse(lists:keysort(#kf_1vN_role_sign.combat_power, SignList)), 100),
    [{Id, Name, ServerName, Power} || #kf_1vN_role_sign{id = Id, name = Name, server_name = ServerName, combat_power = Power} <- L].

%% 赛区场景进程id划分 {赛区*10, 最大赛区(赛区*10, 赛区*10+9)}
make_scene_pool_m(SignList) ->
    F = fun(#kf_1vN_role_sign{area = Area}, KvList) ->
        case lists:keyfind(Area, 1, KvList) of
            false -> [{Area, 1}|KvList];
            {Area, Num} -> lists:keyreplace(Area, 1, KvList, {Area, Num+1})
        end
    end,
    List = lists:foldl(F, [], SignList),
    F2 = fun({Area, Num}, PoolM) ->
        Min = Area*10,
        MaxRange = min(9, Num div 100),
        maps:put(Area, {Min, Min+MaxRange}, PoolM)
    end,
    lists:foldl(F2, #{}, List).

%% 随机出场景id
rand_scene_pool_id(PoolM, Area) ->
    {Min, Max} = maps:get(Area, PoolM),
    urand:rand(Min, Max).

%% 服信息列表 [{Platform, ServerNum, ServerName},...]
make_ser_info_list(SignList) ->
    F = fun(#kf_1vN_role_sign{platform=Platform, server_num=ServerNum, server_name=ServerName}) ->
        {Platform, ServerNum, ServerName}
    end,
    lists:usort(lists:map(F, SignList)).

%% 守擂者退出
race_2_side_def_quit(State) ->
    #state{role_m=RoleM} = State,
    RoleList = lists:flatten(maps:values(RoleM)),
    race_2_side_def_quit_help(RoleList, State).

race_2_side_def_quit_help([], State) -> State;
race_2_side_def_quit_help([Role|T], State) ->
    #state{stage=Stage, role_m=RoleM, race_2_m=Race2M, match_turn=MatchTurn} = State,
    #kf_1vN_role{id=Id, area=Area, race_2_side=Race2Side, race_2_battle_id=Race2BattleId, enter=Enter, race_2_lose=Race2Lose} = Role,
    Roles = maps:get(Area, RoleM),
    if
        Race2Side == ?SIDE_DEF andalso Stage == ?KF_1VN_RACE_2 andalso Race2BattleId > 0 andalso Enter == 0 andalso Race2Lose == 0 ->
            % 擂主在开始战斗还没回来，则判定输
            Roles1 = lists:keyreplace(Id, #kf_1vN_role.id, Roles, Role#kf_1vN_role{race_2_lose=1}),
            % lib_kf_1vN:quit_to_main_scene(Node, Id),
            % race_2_pk_result(Race2BattleId, 0, Area, Id, Role#kf_1vN_role.combat_power), %% 单场比赛结束
            % ?MYLOG("lzh1vndefquit", "Id:~p ~n", [Id]),
            Race2 = maps:get(Area, Race2M),
            #kf_1vN_race_2{match_list=MatchList} = Race2,
            MatchList1 = case lists:keyfind(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList) of
                #kf_1vN_race_2_match_info{challengers=Challengers, battle_win=0} = MatchInfo->
                    case data_kf_1vN:get_race_2_award(2, MatchTurn) of
                        {ChallengerWinRewards, _} -> skip;
                        _ -> ChallengerWinRewards = []
                    end,
                    Title = utext:get(318),
                    Content = utext:get(320, [MatchTurn]),
                    [mod_clusters_center:apply_cast(EC#kf_1vN_role_pk.server_id, lib_mail_api, send_sys_mail, [[EC#kf_1vN_role_pk.id], Title, Content, ChallengerWinRewards])
                        ||EC <- Challengers, EC#kf_1vN_role_pk.is_dead==0, EC#kf_1vN_role_pk.type==?KF_1VN_C_TYPE_PLAYER],
                    lists:keyreplace(Race2BattleId, #kf_1vN_race_2_match_info.battle_id, MatchList, MatchInfo#kf_1vN_race_2_match_info{battle_win=2});
                _ ->
                    MatchList
            end,
            % {TmpRoleM#{Area:=Roles1}, Race2M#{Area:=Race2#kf_1vN_race_2{match_list=MatchList1}}};
            StateAfQuit = State#state{role_m=RoleM#{Area:=Roles1}, race_2_m=Race2M#{Area:=Race2#kf_1vN_race_2{match_list=MatchList1}}},
            case data_kf_1vN:get_stage_args(MatchTurn) of
                #kf_1vN_race_2_match{c_num=CNum} -> ok;
                _ -> CNum=2
            end,
            {noreply, StateAfResult} = do_handle_cast({race_2_pk_result, Race2BattleId, 0, Area, Id, Role#kf_1vN_role.combat_power, 0, 0, CNum}, StateAfQuit),
            StateAfResult;
        true ->
            StateAfResult = State
    end,
    race_2_side_def_quit_help(T, StateAfResult).

%% 计算竞猜结果
%% return 0 未有结果 1 猜错 2 猜对
calc_bet_result(Turn, BattleWin, Hp, HpLim, LiveNum, OptNo) ->
    case data_kf_1vN:get_bet(Turn) of
        % 未结算
        _ when BattleWin == 0 -> 0;
        #base_kf_1vn_bet{type = ?KF_1VN_BET_TYPE_WINLOSE, opt_list = OptList} ->
            case lists:keyfind(OptNo, 1, OptList) of
                {OptNo, BattleWin} -> 2;
                {_OptNo, _OptResult} -> 1;
                _ -> 0
            end;
        #base_kf_1vn_bet{type = ?KF_1VN_BET_TYPE_HP, opt_list = OptList} ->
            case BattleWin == 1 of
                true -> NHp = Hp, NHpLim = max(HpLim, 1);
                false -> NHp = 0, NHpLim = max(HpLim, 1)
            end,
            HpRatio = trunc(NHp/NHpLim*100),
            case lists:keyfind(OptNo, 1, OptList) of
                {OptNo, Min, Max} when HpRatio >= Min, HpRatio =< Max -> 2;
                {_OptNo, _Min, _Max} -> 1;
                _ -> 0
            end;
        #base_kf_1vn_bet{type = ?KF_1VN_BET_TYPE_LIVENUM, opt_list = OptList} ->
            case lists:keyfind(OptNo, 1, OptList) of
                {OptNo, Min, Max} when LiveNum >= Min, LiveNum =< Max -> 2;
                {_OptNo, _Min, _Max} -> 1;
                _ -> 0
            end;
        _ ->
            0
    end.

%% 通知所有服
sync_state_to_all(State) ->
    #state{stage=Stage, sub_stage=SubStage, optime=OpTime, edtime=EdTime, sign_num=SignNum, def_num_m=DefNumM, race_2_m=Race2M, race_1_rank_m=Race1RankM} = State,
    F = fun(Area, Race2, TmpDefRankM) ->
            TmpDefRankM#{Area => Race2#kf_1vN_race_2.def_rank}
    end,
    DefRankM = maps:fold(F, #{}, Race2M),
    F2 = fun(_Area, ScoreRank) -> lists:sublist(ScoreRank, 100) end,
    ShortRace1RankM = maps:map(F2, Race1RankM),
    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, sync_state, [[Stage, SubStage, OpTime, EdTime, SignNum, DefNumM, DefRankM, ShortRace1RankM]]),
    ok.