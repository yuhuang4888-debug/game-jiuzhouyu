%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%% 决斗场
%%% @end
%%% Created : 02. 一月 2019 17:03
%%%-------------------------------------------------------------------
-module(lib_glad_battle).
-author("whao").


-compile(export_all).
%% API
-include("gladiator.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("mount.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("reincarnation.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("counter.hrl").
-include("role.hrl").
-include("server.hrl").


%% 初始化
init(ClsType) ->
    {ZoneMap, RoleMap} = init_zone_map(),
    %%    ?PRINT("ZoneMap  ~p,RoleMap  ~p~n", [ZoneMap, RoleMap]),
    #glad_state{state_type = ClsType, cls_type = ClsType, zone_map = ZoneMap, role_map = RoleMap}.

init_zone_map() ->
    List = db_role_glad_get(),
    F = fun(T, {Map, RMap}) ->
        GladRank = make_record(glad_rank, T),
        %%        ?PRINT("init_zone_map   GladRank:~p~n", [GladRank]),
        ZoneId = GladRank#glad_rank.zone_id,
        RoleId = GladRank#glad_rank.role_id,
        #glad_zone{ranks = Ranks} = Zone = maps:get(ZoneId, Map, #glad_zone{}),
        NewZone = Zone#glad_zone{ranks = [GladRank | Ranks]},

        NewZoneMap = maps:put(ZoneId, NewZone, Map),
        NewRoleMap = maps:put(RoleId, ZoneId, RMap),
        {NewZoneMap, NewRoleMap}
        end,
    {ZoneMap, RoleMap} = lists:foldl(F, {#{}, #{}}, List),
    NewZMap = rank_sort_zone_map(ZoneMap),
    {NewZMap, RoleMap}.

make_record(glad_rank, List) when is_list(List) ->
    [ZoneId, RoleId, ServerId, ServerName, ServerNum, CombatPower, Score, BinRewardList, FigureBin] = List,
    #glad_rank{
        zone_id = ZoneId,
        role_id = RoleId,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower,
        score = Score,
        stage_reward = util:bitstring_to_term(BinRewardList),
        figure = util:bitstring_to_term(FigureBin)
    };

make_record(new_glad_rank, Player) ->
    #player_status{
        id = RoleId, figure = #figure{name = Name, career = Career, sex = Sex, lv = Level, mount_figure = MountFigure, lv_model = LvMedal, fashion_model = FashionMedal},
        server_id = ServerId, server_name = ServerName, server_num = ServerNum, combat_power = CombatPower
    } = Player,
    NewMountFigure = [{TypeId, FigureId, Color} || {TypeId, FigureId, Color} <- MountFigure, FigureId =/= 0],
    #glad_rank{
        role_id = RoleId,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower,
        figure = #figure{sex = Sex, lv = Level, name = Name, career = Career, mount_figure = NewMountFigure, lv_model = LvMedal, fashion_model = FashionMedal}
    }.



%% 排序
sort_zone_map(ZoneMap) ->
    F = fun(_ZoneId, #glad_zone{ranks = Ranks} = Zone) ->
        NewRanks = sort_ranks(Ranks),
        Zone#glad_zone{ranks = NewRanks}
        end,
    maps:map(F, ZoneMap).


rank_sort_zone_map(ZoneMap) ->
    F = fun(_ZoneId, #glad_zone{ranks = Ranks} = Zone) ->
        NewRanks = sort_ranks(Ranks),
        RankList = lists:sublist(NewRanks, ?GALD_KV_MAX_RANK),
        Zone#glad_zone{ranks = NewRanks, rank_list = RankList}
        end,
    maps:map(F, ZoneMap).



sort_ranks(Ranks) ->
    NewRanks = compare_data(Ranks),
    NewRanks2 = compare_rank(NewRanks, 1, []),
    NewRanks2.

%% 排序 积分 击杀数
compare_data(Ranks) ->
    F = fun(A1, A2) ->
        A1#glad_rank.score > A2#glad_rank.score
        end,
    lists:sort(F, Ranks).

%% 排名赋值
compare_rank([], _, Ranks) -> lists:reverse(Ranks);
compare_rank([H | T], Rank, Ranks) ->
    compare_rank(T, Rank + 1, [H#glad_rank{rank = Rank} | Ranks]).



get_new_glad_rank(ZoneMap) ->
    F = fun(_ZoneId, #glad_zone{ranks = Ranks} = Zone) ->
        NewRanks = compare_data(Ranks),
        NewRanks1 = compare_rank_battle(NewRanks, 1, []),
        RankList = lists:sublist(NewRanks1, ?GALD_KV_MAX_RANK),
        Zone#glad_zone{ranks = NewRanks1, rank_list = RankList}
        end,
    maps:map(F, ZoneMap).

%% 排名 战力赋值
compare_rank_battle([], _, Ranks) -> lists:reverse(Ranks);
compare_rank_battle([H | T], Rank, Ranks) ->
    OldCombat = H#glad_rank.combat_power,
    Combat = case lib_role:get_role_show(H#glad_rank.role_id) of
                 #ets_role_show{combat_power = CombatTmp} -> CombatTmp;
                 _ -> OldCombat
             end,
    compare_rank_battle(T, Rank + 1, [H#glad_rank{rank = Rank, combat_power = Combat} | Ranks]).



%% 是否跨服活动(满足一定天数)
is_cls_open() ->
    false.
%%    OpenDay = util:get_open_day(),
%%    OpenDay >= ?GLAD_KV_CLS_OPEN_DAY.


do_act_start(#glad_state{status = Status} = State, _AcSub) when Status =/= ?GLAD_STATE_OPEN ->
    Stime = utime:unixtime(),
    Etime = utime:logic_week_start() + ?ONE_WEEK_SECONDS,
    do_act_start_help(State, Stime, Etime);

do_act_start(State, _AcSub) ->
    State.

do_act_start_help(State, Stime, Etime) ->
    #glad_state{state_type = StateType, ref = OldRef, rank_ref = OldRankRef
        %%        power_ref = OldPowerRef
    } = State,
    ?PRINT("Stime, Etime:~p ~p~n", [Stime, Etime]),
    Ref = util:send_after(OldRef, max(Etime - utime:unixtime(), 0) * 1000, self(), {'apply', act_end}),
    RankRef = util:send_after(OldRankRef, ?GLAD_KV_RANK_REFRESH_TIME * 1000, self(), {'apply', rank_ref}),
    %%    PowerRef = util:send_after(OldRankRef, 5 * 60 * 1000, self(), {'apply', power_ref}),

    case StateType == ?CLS_TYPE_GAME of
        true ->
            {ok, BinData} = pt_653:write(65300, [?GLAD_STATE_OPEN, Etime]),
            lib_server_send:send_to_all(BinData)
        %%            lib_activitycalen_api:success_start_activity(?MOD_GLADITOR)
        ;
        false ->
            Args = [{?CLS_TYPE_CENTER, ?GLAD_STATE_OPEN, Stime, Etime}],
            mod_clusters_center:apply_to_all_node(mod_glad_local, sync_data, [Args])
    end,
    State#glad_state{status = ?GLAD_STATE_OPEN, stime = Stime, etime = Etime, ref = Ref, rank_ref = RankRef
        %%        zone_map = #{}, role_map = #{},  power_ref = PowerRef
    }.


%% 榜单定时器[#glad_state.rank_ref]
rank_ref(#glad_state{status = Status} = State) when Status == ?GLAD_STATE_OPEN ->
    #glad_state{zone_map = ZoneMap, rank_ref = OldRef} = State,
    NewZoneMap = get_new_glad_rank(ZoneMap),
    Ref = util:send_after(OldRef, ?GLAD_KV_RANK_REFRESH_TIME * 1000, self(), {'apply', rank_ref}),
    NewState = State#glad_state{zone_map = NewZoneMap, rank_ref = Ref},
    {noreply, NewState};
rank_ref(State) ->
    {noreply, State}.


filter_score_map(ZoneMap) ->
    F = fun(_ZoneId, #glad_zone{ranks = Ranks} = Zone) ->
        NewRanks = compare_data(Ranks),
        NewRanks2 = new_compare_rank(NewRanks, 1, []),
        Zone#glad_zone{ranks = NewRanks2}
        end,
    maps:map(F, ZoneMap).

%% 排名赋值 和  发排行奖励
new_compare_rank([], _Rank, Ranks) -> lists:reverse(Ranks);
new_compare_rank([H | T], Rank, Ranks) ->
    StagRd = get_least_stage_reward(H),
    %%    ?PRINT("new_compare_rank Score:~p~n", [H#glad_rank.score]),
    case H#glad_rank.score >= ?GALD_KV_SCORE_ON_RANK of
        true ->
            #glad_rank_reward{rank_reward = RankReward} = data_gladiator:get_gladiator_rank_reward(Rank),
            new_compare_rank(T, Rank + 1, [H#glad_rank{rank = Rank, reward = RankReward, stage_reward = StagRd} | Ranks]);
        false ->
            new_compare_rank(T, Rank, [H#glad_rank{rank = 0, stage_reward = StagRd} | Ranks])
    end.

get_least_stage_reward(H) ->
    #glad_rank{score = Score, stage_reward = OldStageRd} = H,
    ServOpenDay = util:get_open_day() - 1, % 要求是这个配置相隔天数至少为一天
    F = fun(E) -> E =< ServOpenDay end,
    AllOpenday = data_gladiator:get_glad_all_stg_openday(),
    Openday = lists:max(lists:filter(F, AllOpenday)),

    AllScore = data_gladiator:get_glad_all_stg_reward(Openday), % 获取所有的阶段奖励
    F1 = fun(ScoreTmp, List) ->
        case Score >= ScoreTmp of
            true ->
                case lists:keyfind(ScoreTmp, 1, OldStageRd) of
                    {ScoreTmp, ?GLAD_HAD_REWARD} ->
                        List;
                    _ ->
                        #glad_stage_reward{stage_reward = StgRd} = data_gladiator:get_glad_stage_reward(Openday, ScoreTmp),
                        List ++ StgRd
                end;
            false ->
                List
        end
         end,
    lists:foldl(F1, [], AllScore).


%% 活动结束[定时器 #glad_state.ref]
act_end(State) ->
    #glad_state{cls_type = ClsType, role_map = _RoleMap, zone_map = ZoneMap, ref = OldRef, rank_ref = OldRankRef} = State,
    %%    ?PRINT("=======ClsType:~p~n", [ClsType]),
    % 定时器清理
    util:cancel_timer(OldRef),
    util:cancel_timer(OldRankRef),
    NewZoneMap = filter_score_map(ZoneMap),
    % 合并
    F = fun(_ZoneIdTmp, GladZoneTmp, List) ->
        case GladZoneTmp of
            #glad_zone{ranks = Ranks} ->
                List ++ Ranks;
            _ -> List
        end
        end,
    RoleRanks = maps:fold(F, [], NewZoneMap),
    spawn(fun() -> send_rank_reward(RoleRanks) end), % 发送排名奖励
    %%    spawn(fun() -> db_role_glad_batch(RoleRanks) end), % 批量存储
    % 清理玩家
    NewState = State#glad_state{status = ?GLAD_STATE_CLOSE, etime = 0, role_map = #{}, zone_map = #{}, battle_status_maps = #{}, ref = none, rank_ref = none},
    case ClsType == ?CLS_TYPE_GAME of
        true ->
            {ok, BinData} = pt_653:write(65300, [?GLAD_STATE_CLOSE, 0]),
            lib_server_send:send_to_all(BinData),
            lib_activitycalen_api:success_end_activity(?MOD_GLADITOR);
        false ->
            Args = [{?CLS_TYPE_GAME, ?GLAD_STATE_CLOSE, 0, 0}],
            mod_clusters_center:apply_to_all_node(mod_glad_local, sync_data, [Args])
    end,
    db_role_glad_truncate(),
    mod_glad_local:act_start(0),
    %%    ?PRINT("act_end~n",[]),
    {ok, NewState}.


%%  发送排名奖励
%%update_rank_reward(RoleMap) ->
%%    F = fun(_K, GladRank) ->
%%        #glad_rank{role_id = _RoleId, server_id = _ServerId, rank = RankNo} = GladRank,
%%        RankReward =
%%            case RankNo =< data_gladiator:get_max_rank_reward() of
%%                true ->
%%                    data_gladiator:get_glad_rank_reward(RankNo);
%%                false ->
%%                    []
%%            end,
%%        GladRank#glad_rank{reward = RankReward}
%%        end,
%%    maps:map(F, RoleMap).

%% 发送排名奖励
send_rank_reward([]) -> skip;
send_rank_reward([NineRank | T]) ->
    #glad_rank{role_id = RoleId, server_id = ServerId, score = Score, rank = RankNo, stage_reward = StageReward, reward = Reward} = NineRank,
    %%    ?PRINT("send_rank_reward  StageReward:~p Reward:~p~n ", [StageReward, Reward]),
    case Reward of
        [] ->
            dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, RankNo, [], StageReward]);
        Award ->
            dispatch_execute(ServerId, ?MODULE, add_award, [RoleId, RankNo, Award, StageReward]),
            lib_log_api:log_glad_rank(RoleId, RankNo, Score, Reward),
            %%     lib_log_api:log_glad_stage(RoleId, Score, StageReward),  % 补发阶段奖励日志
            timer:sleep(50)
    end,
    send_rank_reward(T).



%% 积分奖励
add_award(_RoleId, _RankNo, [], []) ->
    skip;
add_award(RoleId, RankNo, Award, StageReward) ->
    case Award of
        [] -> % 没有奖励的
            skip;
        _ ->
            lib_mail_api:send_sys_mail([RoleId], utext:get(335), utext:get(336, [RankNo]), Award)
    end,
    case StageReward of
        [] ->
            skip;
        _ ->
            lib_mail_api:send_sys_mail([RoleId], utext:get(337), utext:get(338), StageReward)
    end.



%% 同步数据
sync_data(#glad_state{status = Status, cls_type = ClsType} = State, Args) ->
    [{NClsType, NStatus, Stime, Etime}] = Args,
    case is_cls_open() of
        true ->
            case ClsType == ?CLS_TYPE_GAME andalso Status == ?GLAD_STATE_OPEN of
                true -> {ok, State};
                false ->
                    % 跨服处理
                    if
                        Status == ?GLAD_STATE_OPEN -> lib_activitycalen_api:success_start_activity(?MOD_GLADITOR);
                        Status == ?GLAD_STATE_CLOSE -> lib_activitycalen_api:success_end_activity(?MOD_GLADITOR);
                        true -> skip
                    end,
                    {ok, BinData} = pt_653:write(65300, [NStatus, Etime]),
                    lib_server_send:send_to_all(BinData),
                    NewState = State#glad_state{cls_type = NClsType, status = NStatus, stime = Stime, etime = Etime},
                    {ok, NewState}
            end;
        false ->
            {ok, State}
    end.


%% 筛选阶段奖励
filter_stage_reward(Score, StageReward) ->
    ServOpenDay = util:get_open_day(),
    F = fun(E) -> E =< ServOpenDay end,
    AllOpenday = data_gladiator:get_glad_all_stg_openday(),
    Openday = lists:max(lists:filter(F, AllOpenday)),
    AllScore = data_gladiator:get_glad_all_stg_reward(Openday), % 获取所有的阶段奖励
    case StageReward of
        [] ->
            F1 = fun(ScoreTmp, List) ->
                case Score >= ScoreTmp of
                    true -> [{1, ScoreTmp} | List];
                    false -> [{0, ScoreTmp} | List]
                end
                 end,
            lists:foldl(F1, [], AllScore);
        _ ->
            F1 = fun(ScoreTmp, List) ->
                case lists:keyfind(ScoreTmp, 1, StageReward) of
                    {ScoreTmp, 2} ->
                        [{2, ScoreTmp} | List];
                    _ ->
                        case Score >= ScoreTmp of
                            true -> [{1, ScoreTmp} | List];
                            false -> [{0, ScoreTmp} | List]
                        end
                end
                 end,
            lists:foldl(F1, [], AllScore)
    end.




%% 获得剩余的次数
%% @return {当前次数, 刷新时间}
get_challenge_num(RoleId) ->
    MaxNum = ?GLAD_KV_NUM_MAX, % 最大挑战次数
    ResumeTime = ?GLAD_KV_RESUME_TIME, % 挑战次数恢复时间
    {Count, RefreshTime} =
        case mod_counter:get(RoleId, ?MOD_GLADITOR, ?DEFAULT_SUB_MODULE, ?GLAD_CHALLENGE_NUM) of
            false ->
                {0, 0};
            #ets_counter{count = CountTmp, refresh_time = RefreshTimeTmp} ->
                {CountTmp, RefreshTimeTmp}
        end,
    NowTime = utime:unixtime(),
    Elapse = NowTime - RefreshTime,
    if
        Count >= MaxNum ->
            {Count, NowTime};
        Elapse < ResumeTime ->
            {Count, RefreshTime};
        true ->
            ResumeCount = Elapse div ResumeTime,
            Count2 = min(Count + ResumeCount, MaxNum),
            RefreshTime2 = RefreshTime + ResumeCount * ResumeTime,
            case Count2 >= MaxNum of
                true -> {Count2, NowTime};
                false -> {Count2, RefreshTime2}
            end
    end.



%% 根据配置随机对手列表
%% return  [#glad_image_role{}]
do_random_rival(_State, _GladZone, _Rank, RoleId, _MedalLv, _RoleCombat, _RoleLv, 0, ImageList) ->
    put({RoleId, fake_list}, ImageList),
    ImageList;
do_random_rival(State, GladZone, Rank, RoleId, MedalLv, RoleCombat, RoleLv, Num, ImageList) ->
    #glad_power_cfg{point_weight = PoWeight, point_power = PoPower} = data_gladiator:get_glad_power(MedalLv),
    RandScore = urand:rand_with_weight(PoWeight),
    {RandScore, PowerRange} = lists:keyfind(RandScore, 1, PoPower),
    {RandScore, VictoryReward} = lists:keyfind(RandScore, 1, ?GLAD_KV_VICTORY),
    RivalHonor = case lists:keyfind(?TYPE_CURRENCY, 1, VictoryReward) of
                     {?TYPE_CURRENCY, _, HonorNum} -> HonorNum;
                     _ -> 0
                 end,
    SameImageIds = [SameId || #glad_image_role{role_id = SameId} <- ImageList],
    InitImageRole = get_glad_image_role(GladZone, Rank, PowerRange, RoleCombat, RoleLv, RoleId, SameImageIds),
    ImageRole =
        InitImageRole#glad_image_role{
            score = RandScore,
            honor = RivalHonor},
    do_random_rival(State, GladZone, Rank, RoleId, MedalLv, RoleCombat, RoleLv, Num - 1, [ImageRole | ImageList]).

%% 根据战力获取对手  state 不存在则为机器人配置
% return  #glad_image_role{}
get_glad_image_role(GladZone, Rank, PowerRange, RoleCombat, RoleLv, RoleId, SameImageIds) ->
    #glad_zone{ranks = Ranks} = GladZone,
    ImageRole =
        case Rank of
            0 -> % 玩家没有上榜则生成机器人
                create_robot_image_role(PowerRange, RoleCombat, RoleLv);
            _ -> % 玩家上榜则在战力范围搜索玩家
                get_real_image_role(Ranks, Rank, PowerRange, RoleId, RoleCombat, RoleLv, SameImageIds)
        end,
    ImageRole.

%%  创建机器人形象和战力信息
create_robot_image_role(PowerRange, RoleCombat, RoleLv) ->
    {PowerLow, PowerHigh} = PowerRange,
    RandPower = urand:rand(round(PowerLow / 100 * RoleCombat), round(PowerHigh / 100 * RoleCombat)),
    Name = case data_gladiator:get_glad_all_name() of
               [] -> utext:get(182); %%"守卫";
               NameList -> urand:list_rand(NameList)
           end,
    {Career, Sex} = lib_career:rand_career_and_sex(),
    Turn = urand:list_rand(lists:seq(0, ?MAX_TURN)),
    Lv = urand:rand(max(1, RoleLv - 5), RoleLv + 5),
    LvModel = lib_player:get_model_list(Career, Sex, Turn, Lv),
    RobotCfg =
        case data_gladiator:get_glad_robot(Sex) of
            [] -> #glad_robot_cfg{};
            GladRobotCfg -> GladRobotCfg
        end,
    #glad_robot_cfg{
        weapon_m = RWeapon, % 武器模型
        mount_m = RMount, % 坐骑模型
        partner_m = RMate, % 伙伴模型
        wing_m = RFly              % 翅膀模型
    } = RobotCfg,
    WeaponKv = ?IF(RWeapon == [], [], [{?HOLYORGAN_ID, urand:list_rand(RWeapon), 0}]),
    MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount), 0}]),
    MateKv = ?IF(RMate == [], [], [{?MATE_ID, urand:list_rand(RMate), 0}]),
    FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly), 0}]),
    MountFigure = WeaponKv ++ MountKv ++ MateKv ++ FlyKv,
    Figure = #figure{
        name = Name,
        sex = Sex,
        turn = Turn,
        career = Career,
        lv = Lv,
        lv_model = LvModel,
        mount_figure = MountFigure},
    %%    ?PRINT("RandPower,get_hp(RandPower) :~p   ~p~n", [RandPower, get_hp(RandPower)]),
    #glad_image_role{
        role_id = 0,
        figure = Figure,
        combat = RandPower,
        hp = get_hp(RandPower)
    }.

%% 创建真人形象和战力信息
get_real_image_role(Ranks, RoleRank, PowerRange, SelfRoleId, RoleCombat, RoleLv, SameImageIds) ->
    {PowerLow, PowerHigh} = PowerRange,
    RealManList = [GladRankTmp || #glad_rank{role_id = RivalRoleId, combat_power = Power} = GladRankTmp <- Ranks, Power >= PowerLow, Power =< PowerHigh, SelfRoleId =/= RivalRoleId],
    RankLow = max(1, RoleRank - ?GLAD_SEARCH_RANGE), % 排行上限
    RankHigh = RoleRank + ?GLAD_SEARCH_RANGE, % 排行下限
    case urand:list_rand(RealManList) of
        #glad_rank{role_id = RoleIdTmp} = GRankTmp ->
            get_real_image_role_help(RoleIdTmp, PowerRange, RoleCombat, RoleLv, SameImageIds, GRankTmp);
        _ -> % 没有战力范围内的
            SearchRole = [GladRankTmp1 || #glad_rank{role_id = RivalIdTmp, rank = Rank1} = GladRankTmp1 <- Ranks, Rank1 =< RankHigh, Rank1 >= RankLow, RivalIdTmp =/= SelfRoleId],
            case SearchRole of
                [] ->
                    create_robot_image_role(PowerRange, RoleCombat, RoleLv);
                _ ->
                    #glad_rank{role_id = RoleId1} = GRankTmp = urand:list_rand(SearchRole),
                    get_real_image_role_help(RoleId1, PowerRange, RoleCombat, RoleLv, SameImageIds, GRankTmp)
            end
    end.

get_real_image_role_help(RoleIdTmp, PowerRange, RoleCombat, RoleLv, SameImageIds, GRankTmp) ->
    case lists:member(RoleIdTmp, SameImageIds) of
        true -> % 有重复的人
            create_robot_image_role(PowerRange, RoleCombat, RoleLv);
        false ->
            Power = GRankTmp#glad_rank.combat_power,
            NewFigure =
                case lib_role:get_role_show(GRankTmp#glad_rank.role_id) of
                    #ets_role_show{figure = Figure} -> Figure;
                    _ -> #figure{}
                end,
            #glad_image_role{
                role_id = RoleIdTmp,
                figure = NewFigure,
                combat = Power,
                hp = get_hp(Power)
            }
    end.



get_hp(RandPower) ->
    %%    ?PRINT("RandPower:~p   add  ~p~n", [RandPower, data_gladiator:get_glad_robot_attr(2)]),
    round(RandPower * data_gladiator:get_glad_robot_attr(2)).

%% 获取maps里角色信息 没有的话返回默认(Rank为0) 不处理maps
%% @return    #glad_rank{}
get_glad_rank(State, RoleId) ->
    #glad_state{role_map = RM, zone_map = ZM} = State,
    RR = case maps:get(RoleId, RM, false) of
             false ->
                 lib_glad:get_db_real_role(RoleId);
             ZoneId ->
                 case maps:get(ZoneId, ZM, false) of
                     false ->
                         lib_glad:get_db_real_role(RoleId);
                     #glad_zone{ranks = Ranks} ->
                         case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
                             false ->
                                 lib_glad:get_db_real_role(RoleId);
                             RRTmp ->
                                 RRTmp
                         end
                 end
         end,
    RR.

%% 获取并返回   #glad_zone{ranks }
get_role_state_rank(State, RoleId) ->
    #glad_state{role_map = RM, zone_map = ZM} = State,
    GladZone = case maps:get(RoleId, RM, false) of
                   false ->
                       #glad_zone{};
                   ZoneId ->
                       case maps:get(ZoneId, ZM, false) of
                           false ->
                               #glad_zone{};
                           #glad_zone{} = GladZoneTmp ->
                               GladZoneTmp
                       end
               end,
    GladZone.




jugde_get_stage_reward(State, Stage, RoleGladRank, ServerId) ->
    #glad_rank{role_id = RoleId, score = Score, stage_reward = StageReward} = RoleGladRank,
    case Score >= Stage of
        true -> % 可以领取
            ServerTime = util:get_open_day(), %  开服天数
            F = fun(E) -> E =< ServerTime end,
            AllOpenday = data_gladiator:get_glad_all_stg_openday(),
            Openday = lists:max(lists:filter(F, AllOpenday)),
            GoodsList = case data_gladiator:get_glad_stage_reward(Openday, Stage) of
                            #glad_stage_reward{stage_reward = StgReward} -> StgReward;
                            _ -> []
                        end,
            %% 更改领取奖励状态
            NewStageReward = lists:keystore(Stage, 1, StageReward, {Stage, ?GLAD_HAD_REWARD}),
            NewRealRole = RoleGladRank#glad_rank{stage_reward = NewStageReward},
            %% 更新state
            NewState = put_glad_rank(State, NewRealRole),
            %% 发奖励
            dispatch_execute(ServerId, ?MODULE, add_stage_award, [RoleId, GoodsList]),
            %% 领取阶段奖励日志
            lib_log_api:log_glad_stage(RoleId, Stage, GoodsList),
            {ok, BinData} = pt_653:write(65307, [Stage, ?SUCCESS]),
            send_to_uid(ServerId, RoleId, BinData),
            NewState;
        false ->
            {ok, BinData} = pt_653:write(65399, [?ERRCODE(err653_not_enough_score)]),
            send_to_uid(ServerId, RoleId, BinData),
            State
    end.

add_stage_award(RoleId, GoodsList) ->
    lib_goods_api:send_reward_by_id(GoodsList, glad_stage_reward, RoleId),
    ok.



%% 获取maps里排名信息 没有的话返回默认(Rank为0) 不处理maps
%% @return    #rank_role{}
%%get_rank_role(State, Rank) ->
%%    #glad_state{rank_maps = RM} = State,
%%    case maps:get(Rank, RM, false) of
%%        false ->
%%            RR = #rank_role{rank = Rank};
%%        RR ->
%%            skip
%%    end,
%%    RR.


%% 处理maps 和 数据库
put_glad_rank(State, RealRole) ->
    #glad_state{role_map = RM, zone_map = ZM} = State,
    #glad_rank{role_id = RoleId} = RealRole,
    case maps:get(RoleId, RM, false) of
        ZoneId when is_integer(ZoneId) ->
            case maps:get(ZoneId, ZM, false) of
                #glad_zone{ranks = Ranks} = GladZone ->
                    NewRank = lists:keystore(RoleId, #glad_rank.role_id, Ranks, RealRole),
                    db_update_role_glad(RealRole),
                    NewGladZone = GladZone#glad_zone{ranks = NewRank},
                    NewZoneMap = maps:put(ZoneId, NewGladZone, ZM),
                    State#glad_state{zone_map = NewZoneMap};
                _ ->
                    State
            end;
        _ ->
            State
    end.


%%  创建战场    一方战死或按跳过时再结算
create_glad_battle_help(State, ChallengeRole, Medal, #glad_rank{role_id = RoleId, server_id = ServerId} = GladRank, ZoneId) ->
    #glad_state{battle_status_maps = BStatusMaps, role_map = RoleMap, zone_map = ZoneMap} = State,
    #glad_challenge_role{
        role_id = RoleId,
        rival_id = RivalId,
        rival_combat = ChRivalCombat
    } = ChallengeRole,
    LastState =
        case get({RoleId, fake_list}) of
            FakeImageL when is_list(FakeImageL) ->
                case lists:keyfind(ChRivalCombat, #glad_image_role.combat, FakeImageL) of
                    ImageRole when is_record(ImageRole, glad_image_role) ->
                        #glad_image_role{figure = RivalFigure, combat = ImRivalCombat, score = Score} = ImageRole,
                        % 矫正战斗时的战力
                        NewCombat = round(ImRivalCombat * data_gladiator:get_glad_ratio(Medal)),
                        put({RoleId, glad_challenge_image}, ChallengeRole#glad_challenge_role{rival_figure = RivalFigure, rival_combat = NewCombat, score = Score}),
                        %%  修改状态
                        BStatusMaps1 = maps:put(RoleId, ?GLAD_BATTLE_STATUS, BStatusMaps),
                        {NewRoleMap, NewZoneMap} =
                            case maps:get(RoleId, RoleMap, false) of
                                false ->
                                    case maps:get(ZoneId, ZoneMap, false) of
                                        #glad_zone{ranks = Ranks} = GZone ->
                                            NewGZone = GZone#glad_zone{ranks = [GladRank | Ranks]},
                                            NewZoneMap1 = maps:put(ZoneId, NewGZone, ZoneMap),
                                            NewRoleMap1 = maps:put(RoleId, ZoneId, RoleMap),
                                            {NewRoleMap1, NewZoneMap1};
                                        _ ->
                                            GladZone = #glad_zone{zone_id = ZoneId, ranks = [GladRank]},
                                            NewZoneMap1 = maps:put(ZoneId, GladZone, ZoneMap),
                                            NewRoleMap1 = maps:put(RoleId, ZoneId, RoleMap),
                                            {NewRoleMap1, NewZoneMap1}
                                    end;
                                _ ->
                                    {RoleMap, ZoneMap}
                            end,
                        ?PRINT("create_glad_fake_battle~n", []),
                        dispatch_execute(ServerId, lib_glad, create_glad_fake_battle, [RoleId, RivalId, NewCombat, RivalFigure]),
                        State#glad_state{battle_status_maps = BStatusMaps1, role_map = NewRoleMap, zone_map = NewZoneMap};
                    false when RivalId == 0 ->
                        dispatch_execute(ServerId, lib_glad, break_action_lock, [RoleId, ?ERRCODE(err280_on_battle_state)]),
                        {ok, BinData} = pt_653:write(65399, [?ERRCODE(err653_not_find_robot)]),
                        send_to_uid(ServerId, RoleId, BinData),
                        State;
                    _ImageRole ->
                        dispatch_execute(ServerId, lib_glad, break_action_lock, [RoleId, ?ERRCODE(err280_on_battle_state)]),
                        State
                end;
            _ ->
                dispatch_execute(ServerId, lib_glad, break_action_lock, [RoleId, ?ERRCODE(err280_on_battle_state)]),
                State
        end,
    {ok, LastState}.


get_battle_win_state(State, GladChanRole) ->
    ?PRINT("get_battle_win_state  ~n", []),
    #glad_challenge_role{role_id = RoleId, rival_id = RivalId, score = AddScore,
        rival_rank = RivalRank, self_rank = SelfRank} = GladChanRole,
    Result = ?GLAD_WIN,
    LastRank = RivalRank,
    LastRivalRank = SelfRank,
    RR = get_glad_rank(State, RoleId),
    NewRR = RR#glad_rank{role_id = RoleId,
        %%        rank = RivalRank,
        score = RR#glad_rank.score + AddScore},
    State1 = put_glad_rank(State, NewRR),
    case RivalId == 0 of %% 如果对手是玩家，更换对手排名 更新挑战记录
        true ->
            LastState = State1;
        _ ->
            RivalRR = get_glad_rank(State1, RivalId),
            NewRivalRR = RivalRR#glad_rank{role_id = RivalId
                %%                , rank = SelfRank
            },
            LastState = put_glad_rank(State1, NewRivalRR)
    end,
    {Result, LastRank, LastRivalRank, LastState, NewRR}.


get_battle_lose_state(State, GladChanRole, Score) ->
    ?PRINT("get_battle_lose_state  ~n", []),
    #glad_challenge_role{role_id = RoleId, rival_rank = RivalRank, self_rank = SelfRank} = GladChanRole,
    Result = ?GLAD_FAIL,
    NewScoreNum =
        case Result of
            ?GLAD_FAIL ->
                {_Score, Reward} = lists:keyfind(Score, 1, ?GLAD_KV_LOSE),
                [{_, _, ScoreNum} | _] = Reward,
                ScoreNum;
            ?GLAD_WIN ->
                {_Score, Reward} = lists:keyfind(Score, 1, ?GLAD_KV_VICTORY),
                [{_, _, ScoreNum} | _] = Reward,
                ScoreNum
        end,
    LastRank = SelfRank,
    LastRivalRank = RivalRank,
    RR = get_glad_rank(State, RoleId),
    NewRR = RR#glad_rank{role_id = RoleId,
        %%        rank = RivalRank,
        score = RR#glad_rank.score + NewScoreNum},
    State1 = put_glad_rank(State, NewRR),
    LastState = put_glad_rank(State1, NewRR),
    {Result, LastRank, LastRivalRank, LastState, NewRR}.


%%  获取挑战次数信息
send_glad_get_challenge_num(RoleId, Figure) ->
    %% 根据vip等级的可购买次数
    MaxBuyNum = lib_vip_api:get_vip_privilege(?MOD_GLADITOR, 1, Figure#figure.vip_type, Figure#figure.vip),
    BuyNum = mod_daily:get_count(RoleId, ?MOD_GLADITOR, ?DEFAULT_SUB_MODULE, ?GLAD_BUY_NUM), % 购买次数
    {GladLeftNum, RefreshTime} = get_challenge_num(RoleId), % 当前次数, 刷新时间
    CanBuyNum = max(MaxBuyNum - BuyNum, 0), % 可购买次数
    %%    ?PRINT("GladLeftNum, RefreshTime, MaxBuyNum, CanBuyNum:~w~n", [[GladLeftNum, RefreshTime, MaxBuyNum, CanBuyNum]]),
    lib_server_send:send_to_uid(RoleId, pt_653, 65302, [?SUCCESS, GladLeftNum, RefreshTime, MaxBuyNum, CanBuyNum]),
    ok.



%% 是否本服执行
is_bf_execute(#glad_state{cls_type = ClsType, status = Status}) ->
    % 是否本服活动开启
    Bool1 = ClsType == ?CLS_TYPE_GAME andalso Status == ?GLAD_STATE_OPEN,
    % 没有达到跨服开启且没有活动
    Bool2 = is_cls_open() == false andalso Status =/= ?GLAD_STATE_OPEN,
    Bool1 orelse Bool2.



%% 派发执行
dispatch_execute(ServerId, M, F, A) ->
    case util:is_cls() of
        true -> mod_clusters_center:apply_cast(ServerId, M, F, A);
        false -> erlang:apply(M, F, A)
    end.



%% 跨服中心给玩家发协议
send_to_uid(ServerId, RoleId, BinData) ->
    case util:is_cls() of
        true -> mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
        false -> lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% --------------  local info --------------

%% 1 : @param Type 开启类型
gm_act_start(#glad_state{state_type = ?CLS_TYPE_GAME} = State, Type, Etime) ->
    case utime:unixtime() < Etime of
        true ->
            case Type == 0 of
                true -> NewState = do_act_start_help(State, utime:unixtime(), Etime);
                false ->
                    mod_glad_center:cast_center([{'apply', gm_act_start, [Type, Etime]}]),
                    NewState = State
            end;
        false ->
            NewState = State
    end,
    {noreply, NewState};
gm_act_start(State, _Type, Etime) ->
    NewState = do_act_start_help(State, utime:unixtime(), Etime),
    {noreply, NewState}.


%%  2: 秘籍关闭
gm_act_end(#glad_state{status = Status} = State) when Status =/= ?GLAD_STATE_OPEN -> {noreply, State};

gm_act_end(#glad_state{state_type = ?CLS_TYPE_GAME, cls_type = _ClsType} = State) ->
    case is_cls_open() of
        true ->
            mod_glad_center:cast_center([{'apply', act_end, []}]),
            ok;
        false ->
            act_end(State)
    end;
gm_act_end(State) ->
    act_end(State).

%%gm_act_end(#glad_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State) ->
%%    case ClsType == ?CLS_TYPE_GAME of
%%        true -> act_end(State);
%%        false -> {noreply, State}
%%    end;
%%gm_act_end(State) ->
%%    act_end(State).

%% 3： 活动开启
act_start(#glad_state{state_type = ?CLS_TYPE_GAME} = State, AcSub) ->
    case is_cls_open() of
        true ->
            mod_glad_center:cast_center([{'apply', act_start, [AcSub]}]),
            NewState = State;
        false ->
            NewState = do_act_start(State, AcSub)
    end,
    {ok, NewState};
act_start(State, AcSub) ->
    NewState = do_act_start(State, AcSub),
    {ok, NewState}.

%% 4: 获取状态
send_glad_info(State, RoleId) ->
    #glad_state{status = Status, etime = Etime} = State,
    %%    ?PRINT("Status :~p, Etime:~p~n", [Status, Etime]),
    lib_server_send:send_to_uid(RoleId, pt_653, 65300, [Status, Etime]),
    ok.

%%send_glad_info(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, ServerId) ->
%%    case is_bf_execute(State) of
%%        true ->
%%            send_glad_info_help(State, RoleId, ServerId);
%%        false ->
%%            ?PRINT("is_bf_execute~n",[]),
%%            mod_glad_center:cast_center([{'apply', send_glad_info, [RoleId, ServerId]}])
%%    end,
%%    ok;
%%send_glad_info(State, RoleId, ServerId) ->
%%    ?PRINT("send_glad_info~n",[]),
%%    send_glad_info_help(State, RoleId, ServerId).
%%
%%send_glad_info_help(State, RoleId, ServerId) ->
%%    #glad_state{status = Status, etime = Etime} = State,
%%    ?PRINT("Status, Etime :~p  ~p~n",[Status, Etime]),
%%    {ok, BinData} = pt_653:write(65300, [Status, Etime]),
%%    send_to_uid(ServerId, RoleId, BinData),
%%    ok.




%% 5 : 获得玩家信息
send_glad_role_info(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, ServerId) ->
    case is_bf_execute(State) of
        true ->
            send_glad_role_info_help(State, RoleId, ServerId);
        false ->
            mod_glad_center:cast_center([{'apply', send_glad_role_info, [RoleId, ServerId]}])
    end,
    ok;
send_glad_role_info(State, RoleId, ServerId) ->
    send_glad_role_info_help(State, RoleId, ServerId).


send_glad_role_info_help(State, RoleId, ServerId) ->
    #glad_state{role_map = RoleMap, zone_map = ZoneMap} = State,
    %%    ?PRINT("RoleId, RoleMap ~p  ~p~n",[RoleId, RoleMap]),
    {Rk, Cp, Sr, StgR} =
        case maps:get(RoleId, RoleMap, false) of
            ZoneId when is_integer(ZoneId) ->
                case maps:get(ZoneId, ZoneMap, false) of
                    #glad_zone{ranks = Ranks} ->
                        case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
                            #glad_rank{rank = Rank, combat_power = CombatPower, score = Score, stage_reward = StageReward} ->
                                %%                                ?PRINT("Rank, CombatPower, Score, StageReward:~p ~p ~p ~p~n",[Rank, CombatPower, Score, StageReward]),
                                {Rank, CombatPower, Score, StageReward};
                            _ ->
                                {0, 0, 0, []}
                        end;
                    _ ->
                        {0, 0, 0, []}
                end;
            _ ->
                {0, 0, 0, []}
        end,

    NewStgR = filter_stage_reward(Sr, StgR),
    NewRk =
        case Sr >= ?GALD_KV_SCORE_ON_RANK of
            true ->
                Rk;
            false ->
                0
        end,
    ?PRINT("RoleId, NewRk, Cp, Sr, NewStgR ~w~n", [[RoleId, NewRk, Cp, Sr, NewStgR]]),
    {ok, BinData} = pt_653:write(65301, [NewRk, Cp, Sr, NewStgR]),
    send_to_uid(ServerId, RoleId, BinData),
    ok.


%% 7: 随机对手
glad_random_rival_role(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, MedalLv, RoleCombat, RoleLv, ServerId) ->
    case is_bf_execute(State) of
        true ->
            random_rival_role_help(State, RoleId, MedalLv, RoleCombat, RoleLv, ServerId);
        false ->
            mod_glad_center:cast_center([{'apply', glad_random_rival_role, [RoleId, MedalLv, RoleCombat, RoleLv, ServerId]}])

    end,
    ok;

glad_random_rival_role(State, RoleId, MedalLv, RoleCombat, RoleLv, ServerId) ->
    %%    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    random_rival_role_help(State, RoleId, MedalLv, RoleCombat, RoleLv, ServerId).



random_rival_role_help(State, RoleId, MedalLv, RoleCombat, RoleLv, ServerId) ->
    #glad_rank{rank = Rank} = get_glad_rank(State, RoleId),
    GladZone = get_role_state_rank(State, RoleId),
    %% [#image_role]
    List = do_random_rival(State, GladZone, Rank, RoleId, MedalLv, RoleCombat, RoleLv, 3, []),
    F = fun(ImageRole, TempList) ->
        #glad_image_role{
            role_id = RivalId,
            figure = Figure,
            combat = RivalCombat,
            hp = Hp,
            score = Score,
            honor = Honor} = ImageRole,
        [{RivalId, Score, Honor, RivalCombat, Hp, Figure} | TempList]
        end,
    InfoList = lists:foldl(F, [], List),
    %%    ?PRINT("random InfoList:~p~n", [InfoList]),
    {ok, BinData} = pt_653:write(65303, [InfoList]),
    send_to_uid(ServerId, RoleId, BinData),
    ok.



%%   8： 领取阶段奖励  规则： 已经领取的肯定在数据库里面
get_stage_reward(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, Stage, ServerId) ->
    case is_bf_execute(State) of
        true ->
            get_stage_reward_help(State, RoleId, Stage, 0, ServerId);
        false ->
            mod_glad_center:cast_center([{'apply', get_stage_reward, [RoleId, Stage, ServerId]}]),
            ok
    end
;

get_stage_reward(State, RoleId, Stage, ServerId) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    get_stage_reward_help(State, RoleId, Stage, ZoneId, ServerId).


get_stage_reward_help(#glad_state{zone_map = ZoneMap} = State, RoleId, Stage, ZoneId, ServerId) ->
    NewState =
        case maps:get(ZoneId, ZoneMap, false) of
            #glad_zone{ranks = Ranks} ->
                case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
                    #glad_rank{stage_reward = StageReward} = GladRank ->
                        case lists:keyfind(Stage, 1, StageReward) of
                            {Stage, ?GLAD_HAD_REWARD} ->
                                {ok, BinData} = pt_653:write(65399, [?ERRCODE(err653_had_stage_reward)]),
                                send_to_uid(ServerId, RoleId, BinData),
                                State;
                            _ ->
                                jugde_get_stage_reward(State, Stage, GladRank, ServerId)
                        end;
                    _ ->
                        {ok, BinData} = pt_653:write(65399, [?ERRCODE(err653_cant_get_stage)]),
                        send_to_uid(ServerId, RoleId, BinData)
                end;
            _ ->
                {ok, BinData} = pt_653:write(65399, [?ERRCODE(err653_cant_get_stage)]),
                send_to_uid(ServerId, RoleId, BinData)
        end,
    {ok, NewState}.



%% 9: 创建战场
create_glad_battle(#glad_state{status = Status}, _ChallengeRole, _Medal, GladRank) when Status =/= ?GLAD_STATE_OPEN ->
    #glad_rank{role_id = RoleId, server_id = ServerId} = GladRank,
    {ok, BinData} = pt_653:write(65399, [?ERRCODE(err135_not_open)]),
    send_to_uid(ServerId, RoleId, BinData),
    ok;

create_glad_battle(#glad_state{state_type = ?CLS_TYPE_GAME, cls_type = ClsType} = State, ChallengeRole, Medal, GladRank) -> % 进程类型是游戏服
    case ClsType == ?CLS_TYPE_GAME of
        true ->
            {ok, NewState} = create_glad_battle_help(State, ChallengeRole, Medal, GladRank, 0);
        false ->
            NewState = State,
            mod_glad_center:cast_center([{'apply', create_glad_battle, [ChallengeRole, Medal, GladRank]}])
    end,
    {ok, NewState};

create_glad_battle(State, ChallengeRole, Medal, GladRank) -> % 进程类型是跨服
    #glad_rank{server_id = ServerId} = GladRank,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    {ok, NewState} = create_glad_battle_help(State, ChallengeRole, Medal, GladRank, ZoneId),
    {ok, NewState}.

%% 10 :结算
challenge_image_role_result(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, IsWin) ->
    case is_bf_execute(State) of
        true ->
            challenge_image_role_result_1(State, RoleId, IsWin);
        false ->
            mod_glad_center:cast_center([{'apply', challenge_image_role_result, [RoleId, IsWin]}]),
            ok
    end;
challenge_image_role_result(State, RoleId, IsWin) ->
    challenge_image_role_result_1(State, RoleId, IsWin).

%%  判断跳过
challenge_image_role_result_1(State, RoleId, IsWin) ->
    case IsWin of
        skip ->
            case get({RoleId, glad_challenge_image}) of
                #glad_challenge_role{rival_combat = RivalCombat, self_combat = SelCombat} ->
                    Win = SelCombat > RivalCombat,
                    challenge_image_role_result_help(State, RoleId, Win);
                _ ->
                    challenge_image_role_result_help(State, RoleId, true)
            end;
        _ ->
            challenge_image_role_result_help(State, RoleId, IsWin)
    end.



challenge_image_role_result_help(State, RoleId, IsWin) ->
    case get({RoleId, glad_challenge_image}) of
        #glad_challenge_role{role_id = RoleId, score = Score, rival_id = RivalId, rival_rank = RivalRank, self_rank = SelfRank} = GladChanRole ->
            if
                SelfRank == 0 orelse SelfRank > RivalRank -> %% 挑战之前未上榜的情况
                    {Result, LastRank, _LastRivalRank, LastState, NewRR} =
                        case IsWin of
                            true -> %% 战力大于对手 更换自己的排名 写入maps和数据库
                                get_battle_win_state(State, GladChanRole);
                            false -> %% 挑战失败 排名无变化
                                get_battle_lose_state(State, GladChanRole, Score)
                        end;
                SelfRank < RivalRank -> %% 挑战排名比自己低的情况 排名不变动 更新战斗记录
                    case IsWin of
                        true ->
                            Result = ?GLAD_WIN,
                            LastRank = SelfRank,
                            NewRR = get_glad_rank(State, RoleId),
                            OldScore = NewRR#glad_rank.score,
                            NewRank = NewRR#glad_rank{score = OldScore + Score},
                            LastState = put_glad_rank(State, NewRank);
                        false -> %% 挑战失败 排名无变化 如果对手是玩家 保存战斗记录
                            Result = ?GLAD_FAIL,
                            LastRank = SelfRank,
                            RR = get_glad_rank(State, RoleId),
                            NewScoreNum =
                                case Result of
                                    ?GLAD_FAIL ->
                                        {_Score, Reward} = lists:keyfind(Score, 1, ?GLAD_KV_LOSE),
                                        [{_, _, ScoreNum} | _] = Reward,
                                        ScoreNum;
                                    ?GLAD_WIN ->
                                        {_Score, Reward} = lists:keyfind(Score, 1, ?GLAD_KV_VICTORY),
                                        [{_, _, ScoreNum} | _] = Reward,
                                        ScoreNum
                                end,
                            NewRR = RR#glad_rank{role_id = RoleId,
                                %%                                rank = RivalRank,
                                score = RR#glad_rank.score + NewScoreNum},
                            LastState = put_glad_rank(State, NewRR)
                    end;
                true ->
                    Result = ?GLAD_FAIL,
                    LastRank = SelfRank,
                    NewRR = get_glad_rank(State, RoleId),
                    LastState = State
            end,
            %% 处理次数
            GladRank = get_glad_rank(State, RoleId),
            ServerId = GladRank#glad_rank.server_id,
            dispatch_execute(ServerId, lib_glad, handle_decrement_challenge_num, [RoleId]),
            %% 挑战奖励
            ChallReward =
                case Result of
                    ?GLAD_FAIL ->
                        {_ScoreTmp, RewardTmp} = lists:keyfind(Score, 1, ?GLAD_KV_LOSE),
                        RewardTmp;
                    ?GLAD_WIN ->
                        {_ScoreTmp, RewardTmp} = lists:keyfind(Score, 1, ?GLAD_KV_VICTORY),
                        RewardTmp
                end,
            %% 发奖励
            lib_goods_api:send_reward_by_id(ChallReward, glad_challenge_reward, RoleId),
            %% 日志
            lib_log_api:log_glad(RoleId, SelfRank, RivalId, RivalRank, Result, LastRank,ChallReward),
            % 数据库存储
%%            ?PRINT("(NewRR#glad_rank.server_name):~p~n",[NewRR#glad_rank.server_name]),
            Sql = io_lib:format(?SQL_REPLACE_ROLE_GLAD, [NewRR#glad_rank.zone_id, NewRR#glad_rank.role_id, NewRR#glad_rank.server_id,
                util:make_sure_binary(NewRR#glad_rank.server_name), NewRR#glad_rank.server_num, NewRR#glad_rank.combat_power, NewRR#glad_rank.score, util:term_to_bitstring(NewRR#glad_rank.stage_reward)]),
            db:execute(Sql),
            {ok, BinData} = pt_653:write(65305, [Result, ChallReward]),
            GladRank = get_glad_rank(State, RoleId),
            send_to_uid(ServerId, RoleId, BinData),
            LastState;
        _ -> LastState = State
    end,
    erase({RoleId, glad_challenge_image}),
    {ok, LastState}.

%% 11 ：设置状态
set_battle_status(State, RoleId, BattleStatus) ->
    #glad_state{battle_status_maps = BStatusMaps} = State,
    NewMaps = maps:put(RoleId, BattleStatus, BStatusMaps),
    NewState = State#glad_state{battle_status_maps = NewMaps},
    {ok, NewState}.



%% 12 ：获取排行榜
get_glad_rank_list(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, ServerId) ->
    case is_bf_execute(State) of
        true ->
            get_glad_rank_list_help(State, RoleId, ServerId, 0);
        false ->
            mod_glad_center:cast_center([{'apply', get_glad_rank_list, [RoleId, ServerId]}]),
            ok
    end;

get_glad_rank_list(State, RoleId, ServerId) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    get_glad_rank_list_help(State, RoleId, ServerId, ZoneId).


get_glad_rank_list_help(State, RoleId, ServerId, ZoneId) ->
    #glad_state{zone_map = ZoneMap} = State,
    case maps:get(ZoneId, ZoneMap, false) of
        #glad_zone{rank_list = SendRankList} ->
            F = fun(#glad_rank{rank = RankTmp, role_id = RoleIdTmp, score = ScoreTmp, server_num = ServerNumTmp}, List) ->
                case ScoreTmp >= ?GALD_KV_SCORE_ON_RANK of
                    true ->
                        Name =
                            case lib_role:get_role_show(RoleIdTmp) of
                                #ets_role_show{figure = Figure} ->
                                    Figure#figure.name;
                                _ -> " "
                            end,
                        [{RankTmp, RoleIdTmp, Name, ScoreTmp, ServerNumTmp} | List];
                    false -> List
                end
                end,
            InfoList = lists:foldl(F, [], SendRankList),
            ResInfoList = lists:reverse(InfoList),
%%            ?PRINT("get_glad_rank_list_help ======InfoList:~p~n", [InfoList]),
            {ok, BinData} = pt_653:write(65310, [?SUCCESS, ResInfoList]),
            send_to_uid(ServerId, RoleId, BinData);
        _ ->
            skip
    end,
    ok.

%% 13
gm_add_player_score(#glad_state{state_type = ?CLS_TYPE_GAME} = State, RoleId, Score, GladRank) ->
    case is_bf_execute(State) of
        true ->
            gm_add_player_score_help(State, RoleId, Score, GladRank);
        false ->
            mod_glad_center:cast_center([{'apply', gm_add_player_score, [RoleId, Score, GladRank]}]),
            ok
    end.

gm_add_player_score_help(State, RoleId, Score, RoleGladRank) ->
    #glad_state{role_map = RoleMap, zone_map = ZoneMap} = State,
    ZoneId = 0,
    NewState =
        case maps:get(ZoneId, ZoneMap, false) of
            #glad_zone{ranks = Ranks} = GladZone ->
                case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
                    GladRank when is_record(GladRank, glad_rank) ->
                        #glad_rank{score = OldScore} = GladRank,
                        %%                        ?PRINT("OldScore + Score :~p  ~p~n",[OldScore, Score]),
                        NewScore = OldScore + Score,
                        NewGladRank = GladRank#glad_rank{score = NewScore},
                        NewRanks = lists:keyreplace(RoleId, #glad_rank.role_id, Ranks, NewGladRank),
                        NewGladZone = GladZone#glad_zone{ranks = NewRanks},
                        NewZoneMap = maps:put(ZoneId, NewGladZone, ZoneMap),
                        State#glad_state{zone_map = NewZoneMap};
                    _ ->
                        %%                        ?PRINT("RoleId  Score  RoleGladRank :~p   ~p  ~p ~n",[RoleId ,Score, RoleGladRank]),
                        NewRoleGladRank = RoleGladRank#glad_rank{score = Score},
                        NewGZone = GladZone#glad_zone{ranks = [NewRoleGladRank | Ranks]},
                        NewZoneMap2 = maps:put(ZoneId, NewGZone, ZoneMap),
                        NewRoleMap2 = maps:put(RoleId, ZoneId, RoleMap),
                        State#glad_state{zone_map = NewZoneMap2, role_map = NewRoleMap2}
                end;
            _ ->
                NewRoleGladRank = RoleGladRank#glad_rank{score = Score},
                NewGladZone = #glad_zone{zone_id = ZoneId, ranks = [NewRoleGladRank]},
                NewZoneMap1 = maps:put(ZoneId, NewGladZone, ZoneMap),
                NewRoleMap1 = maps:put(RoleId, ZoneId, RoleMap),
                State#glad_state{zone_map = NewZoneMap1, role_map = NewRoleMap1}
        end,
    {ok, NewState}.


%%gm_add_player_score(State, RoleId, ServerId) ->
%%    ZoneId = lib_clusters_center_api:get_zone(ServerId),
%%    gm_add_player_score_help(State, RoleId, ServerId, ZoneId).

%% 14 修复决斗场玩家数据
gm_repair(State) ->
    #glad_state{zone_map = ZoneMap} = State,
    NewState =
        case maps:get(0, ZoneMap, false) of
            #glad_zone{ranks = Ranks} = GladZone when Ranks =/= [] ->
                Ranks1 = get_null_stage_reward(Ranks),
                LogGladRank = db:get_all(
                    io_lib:format(<<"select role_id, score from log_glad_stage where time >= ~p and time <= ~p ">>,
                        % [1548604800, utime:unixtime()]
                        [utime:unixdate() - 86400, utime:unixtime()]
                    )),
                NewRanks = gm_repair_help(LogGladRank, Ranks1),
                NewGladZone = GladZone#glad_zone{ranks = NewRanks},
                NewZoneMap = maps:put(0, NewGladZone, ZoneMap),
                State#glad_state{zone_map = NewZoneMap};
            _ -> State
        end,
    {ok, NewState}.


get_null_stage_reward(Ranks) ->
    F = fun(GladRankTmp, List) ->
        NewGladRank = GladRankTmp#glad_rank{stage_reward = []},
        [NewGladRank | List]
        end,
    lists:foldl(F, [], Ranks).

gm_repair_help([], Ranks) -> Ranks;
gm_repair_help([H | LogGlad], Ranks) ->
    [RoleId, LogStage] = H,
    case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
        #glad_rank{stage_reward = NowStageReward} = GladRank ->
            NewStReward = lists:keystore(LogStage, 1, NowStageReward, {LogStage, 2}),
            ?PRINT("RoleId, LogStage NewStReward:~p~n", [[RoleId, LogStage, NewStReward]]),
            NewGladRank = GladRank#glad_rank{stage_reward = NewStReward},
            NewRanks = lists:keyreplace(RoleId, #glad_rank.role_id, Ranks, NewGladRank),
            db_update_role_score_glad(NewGladRank),
            gm_repair_help(LogGlad, NewRanks);
        _ ->
            gm_repair_help(LogGlad, Ranks)
    end.


%%gm_repair(State) ->
%%    ?PRINT("gm_repair~n", []),
%%
%%    #glad_state{zone_map = ZoneMap} = State,
%%    NewState =
%%        case maps:get(0, ZoneMap, false) of
%%            #glad_zone{ranks = Ranks} = GladZone when Ranks =/= [] ->
%%                LogGladRank = db:get_all(
%%                    io_lib:format(<<"select role_id, score from log_glad_rank where time >= ~p and time <= ~p ">>,
%%                        [utime:unixdate()-3600,utime:unixtime()])),
%%                NewRanks = gm_repair_help(LogGladRank, Ranks),
%%                NewGladZone = GladZone#glad_zone{ranks = NewRanks},
%%                NewZoneMap = maps:put(0, NewGladZone, ZoneMap),
%%                State#glad_state{zone_map = NewZoneMap};
%%            _ -> State
%%        end,
%%    {ok, NewState}.
%%
%%gm_repair_help([], Ranks) -> Ranks;
%%gm_repair_help([H | LogGlad], Ranks) ->
%%    [RoleId, LogScore] = H,
%%    case lists:keyfind(RoleId, #glad_rank.role_id, Ranks) of
%%        #glad_rank{score = NowScore, stage_reward = NowStageReward} = GladRank when NowScore >= LogScore ->
%%            RepairScore = max(0, NowScore - LogScore),
%%            F = fun({StReTmp, StStateTmp}, StRewardTmp) ->
%%                case StReTmp >= RepairScore andalso StStateTmp == ?GLAD_HAD_REWARD of
%%                    true -> % 已经领过的高级阶段奖励
%%                        StRewardTmp;
%%                    false ->
%%                        [{StReTmp, StStateTmp} | StRewardTmp]
%%                end
%%                end,
%%            RepairStageReward = lists:foldl(F, [], NowStageReward),
%%            NewGladRank = GladRank#glad_rank{score = RepairScore, stage_reward = RepairStageReward},
%%            NewRanks = lists:keyreplace(RoleId, #glad_rank.role_id, Ranks, NewGladRank),
%%            db_update_role_score_glad(NewGladRank),
%%            gm_repair_help(LogGlad, NewRanks);
%%        _ ->
%%            gm_repair_help(LogGlad, Ranks)
%%    end.


%%----------------  SQL -----------------

%  更新奖励情况
db_update_role_glad(RealRole) ->
    #glad_rank{
        role_id = RoleId,
        stage_reward = StageReward
    } = RealRole,
    Sql = io_lib:format(?SQL_UPDATE_ROLE_GLAD, [util:term_to_bitstring(StageReward), RoleId]),
    db:execute(Sql).

%  更新奖励情况
db_update_role_score_glad(RealRole) ->
    #glad_rank{
        role_id = RoleId,
        score = Score,
        stage_reward = StageReward
    } = RealRole,
    Sql = io_lib:format(<<"update role_glad set stage_reward = '~s', score = ~p where role_id = ~p">>, [util:term_to_bitstring(StageReward), Score, RoleId]),
    db:execute(Sql).


%% 获取所有的玩家数据
db_role_glad_get() ->
    db:get_all(io_lib:format(?SQL_ROLE_GLAD_GET, [])).

%% 用id获取玩家数据
db_role_glad_get_by_id(RoleId) ->
    db:get_row(io_lib:format(?SQL_ROLE_GLAD_GET_BY_ID, [RoleId])).

%% 活动开始清空数据
db_role_glad_truncate() ->
    db:execute(io_lib:format(?SQL_ROLE_GLAD_TRUNCATE, [])).


%% 批量存储
db_role_glad_batch(Ranks) ->
    SubSQL = splice_sql(Ranks, []),
    case SubSQL == [] of
        true -> skip;
        false ->
            SQL = string:join(SubSQL, ", "),
            NSQL = io_lib:format(?SQL_ROLE_GLAD_BATCH, [SQL]),
            db:execute(NSQL)
    end,
    ok.

splice_sql([], UpdateSQL) ->
    UpdateSQL;
splice_sql([Rank | Rest], UpdateSQL) ->
    #glad_rank{
        zone_id = ZoneId,
        role_id = RoleId,
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower,
        score = Score
    } = Rank,
    %%    NameBin = util:fix_sql_str(Name),
    ServerNameBin = util:make_sure_binary(ServerName),
    SQL = io_lib:format(?SQL_ROLE_GLAD_VALUES, [ZoneId, RoleId, ServerId, ServerNameBin, ServerNum, CombatPower, Score]),
    splice_sql(Rest, [SQL | UpdateSQL]).




















