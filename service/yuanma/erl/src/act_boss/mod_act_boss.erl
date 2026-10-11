%%-----------------------------------------------------------------------------
%% @Module  :       mod_act_boss
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-05
%% @Description:    活动Boss
%%-----------------------------------------------------------------------------
-module(mod_act_boss).

-include("custom_act.hrl").
-include("act_boss.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("scene.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    act_start/2,
    act_end/3,
    send_act_info/1,
    kill_boss/4,
    check_enter_scene/1,
    count_3day_avg_online_num/0,
    is_act_boss/1
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = check(#act_state{}, true),
    {ok, State}.

send_act_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId}).

kill_boss(RoleId, RoleName, BossName, SceneId) ->
    gen_server:cast(?MODULE, {'kill_boss', RoleId, RoleName, BossName, SceneId}).

act_start(Type, SubType) ->
    gen_server:cast(?MODULE, {'act_start', Type, SubType}).

act_end(EndType, Type, SubType) ->
    gen_server:cast(?MODULE, {'act_end', EndType, Type, SubType}).

check_enter_scene(SceneId) ->
    gen_server:call(?MODULE, {'check_enter_scene', SceneId}, 1000).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 获取活动界面信息
do_handle_cast({'send_act_info', RoleId}, State) ->
    #act_state{status = Status, stage_etime = StageEtime, boss_list = BossList} = State,
    PackBossList = pack_boss_list(BossList),
    lib_server_send:send_to_uid(RoleId, pt_331, 33126, [Status, StageEtime, PackBossList]),
    {ok, State};

%% 击杀Boss
do_handle_cast({'kill_boss', RoleId, RoleName, BossName, SceneId}, State) ->
    #act_state{status = Status, stage_etime = StageEtime, boss_list = BossList} = State,
    case Status of
        ?ACT_STATUS_BOSS_BORN ->
            case lists:keyfind(SceneId, #boss_status.scene_id, BossList) of
                BossStatus when is_record(BossStatus, boss_status) ->
                    NewRemainNum = max(0, BossStatus#boss_status.remain_num - 1),
                    NewBossStatus = BossStatus#boss_status{remain_num = NewRemainNum},
                    NewBossList = lists:keystore(SceneId, #boss_status.scene_id, BossList, NewBossStatus),
                    %% 统计Boss数量
                    F = fun(T, Acc) ->
                        case T of
                            #boss_status{remain_num = TmpRemainNum} -> Acc + TmpRemainNum;
                            _ -> Acc
                        end
                    end,
                    TotalRemainNum = lists:foldl(F, 0, NewBossList),
                    %% 击杀传闻
                    SceneName = lib_scene:get_scene_name(SceneId),
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 7, [RoleName, RoleId, SceneName, BossName, TotalRemainNum]),
                    %% 推送给客户端
                    PackBossList = pack_boss_list(NewBossList),
                    {ok, BinData} = pt_331:write(33126, [Status, StageEtime, PackBossList]),
                    lib_server_send:send_to_all(BinData),
                    NewState = State#act_state{boss_list = NewBossList};
                _ -> NewState = State
            end;
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'act_start', _Type, _SubType}, State) ->
    #act_state{ref = Ref, status = Status} = State,
    case Status of
        ?ACT_STATUS_CLOSE ->
            util:cancel_timer(Ref),
            NewState = check(State, false);
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'act_end', _EndType, Type, SubType}, State) ->
    #act_state{ref = Ref, status = Status} = State,
    case Status of
        ?ACT_STATUS_CLOSE -> NewState = State;
        _ ->
            util:cancel_timer(Ref),
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = Condition} ->
                    CheckList = [boss_id],
                    case lib_custom_act_check:check_act_condtion(CheckList, Condition) of
                        [BossId] ->
                            SceneIds = data_act_boss:get_scene_ids(),
                            F = fun(SceneId) ->
                                lib_mon:clear_scene_mon_by_mids(SceneId, 0, 0, 1, [BossId])
                            end,
                            lists:foreach(F, SceneIds),
                            NewState = #act_state{status = ?ACT_STATUS_CLOSE, stage_etime = 0, boss_list = []};
                        _ ->
                            NewState = #act_state{status = ?ACT_STATUS_CLOSE}
                    end;
                _ ->
                    NewState = #act_state{status = ?ACT_STATUS_CLOSE}
            end
    end,
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info('time_out', State) ->
    #act_state{ref = Ref} = State,
    util:cancel_timer(Ref),
    NewState = check(State, false),
    {ok, NewState};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

%% 检查进入Boss场景
do_handle_call({'check_enter_scene', SceneId}, State) ->
    #act_state{status = Status, stage_etime = StageEtime, boss_list = BossList} = State,
    NowTime = utime:unixtime(),
    Reply = if
        Status == ?ACT_STATUS_BOSS_BORN andalso NowTime < StageEtime ->
            case lists:keyfind(SceneId, #boss_status.scene_id, BossList) of
                #boss_status{remain_num = RemainNum} when RemainNum > 0 -> ok;
                #boss_status{} -> {false, ?ERRCODE(err331_act_boss_scene_no_boss)};
                _ -> {false, ?FAIL}
            end;
        true -> {false, ?ERRCODE(err331_act_boss_scene_no_boss)}
    end,
    {ok, Reply};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

check(State, IsInit) ->
    case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_ACT_BOSS) of
        [#act_info{key = {?CUSTOM_ACT_TYPE_ACT_BOSS, SubType}, etime = _Etime}|_] -> %% 多个活动Boss同时开启,只取活动类型最小的生效
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_ACT_BOSS, SubType) of
                #custom_act_cfg{name = ActName, condition = Condition} ->
                    CheckList = [time_points, num_lim, single_scene_max_num, boss_id],
                    case lib_custom_act_check:check_act_condtion(CheckList, Condition) of
                        [TimesPoints, NumLim, SingleSceneNumLim, BossId] ->
                            NowTime = utime:unixtime(),
                            UnixDate = utime:unixdate(),
                            {ActStatus, StageEtime} = check_time(format_time(TimesPoints), NowTime - UnixDate),
                            Ref = erlang:send_after((StageEtime - (NowTime - UnixDate)) * 1000, self(), 'time_out'),
                            if
                                ActStatus == ?ACT_STATUS_WAIT_NEXT orelse ActStatus == ?ACT_STATUS_ALL_KILL ->
                                    case State#act_state.boss_list =/= [] of
                                        true ->
                                            case IsInit of
                                                false ->
                                                    spawn(fun() -> log_act_boss(State) end),
                                                    BossList = [],
                                                    AvgOnlineNum = 0,
                                                    SceneIds = data_act_boss:get_scene_ids(),
                                                    F = fun(SceneId) ->
                                                        lib_mon:clear_scene_mon_by_mids(SceneId, 0, 0, 1, [BossId])
                                                    end,
                                                    lists:foreach(F, SceneIds),
                                                    %% 活动结束传闻
                                                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 6, [ActName]);
                                                true -> AvgOnlineNum = 0, BossList = []
                                            end;
                                        _ -> AvgOnlineNum = 0, BossList = []
                                    end;
                                ActStatus == ?ACT_STATUS_BOSS_BORN ->
                                    AvgOnlineNum = count_3day_avg_online_num(),
                                    BossList = init_boss(NumLim, SingleSceneNumLim, BossId, AvgOnlineNum),
                                    %% 推送给客户端
                                    PackBossList = pack_boss_list(BossList),
                                    {ok, BinData} = pt_331:write(33126, [ActStatus, StageEtime + UnixDate, PackBossList]),
                                    lib_server_send:send_to_all(BinData),
                                    %% 活动开启传闻
                                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 5, [ActName]);
                                true ->
                                    AvgOnlineNum = 0,
                                    BossList = []
                            end,
                            State#act_state{status = ActStatus, stage_etime = StageEtime + UnixDate, ref = Ref, avg_online_num = AvgOnlineNum, boss_list = BossList};
                        _ ->
                            #act_state{status = ?ACT_STATUS_CLOSE}
                    end;
                _ ->
                    #act_state{status = ?ACT_STATUS_CLOSE}
            end;
        _ ->
            #act_state{status = ?ACT_STATUS_CLOSE}
    end.

-define(SCENE_NUM, 4).
init_boss(NumLim, SingleSceneNumLim, BossId, AvgOnlineNum) ->
    WorldLv = util:get_world_lv(),
    BossNum = round(AvgOnlineNum / 4),
    RealBossNum = case BossNum < ?MIN_BOSS_NUM of
        true -> ?MIN_BOSS_NUM;
        false -> min(BossNum, NumLim)
    end,
    SceneIds = data_act_boss:get_scene_ids(),
    SceneIdsLen = length(SceneIds),
    Res = case SceneIdsLen >= ?SCENE_NUM of
        true ->
            FifthSceneId = lists:nth(?SCENE_NUM, SceneIds),
            case data_scene:get(FifthSceneId) of
                #ets_scene{requirement = RequirementL} ->
                    case lists:keyfind(lv, 1, RequirementL) of
                        {lv, [{_, EnterLvLim}|_]} when EnterLvLim >= WorldLv - 100 -> {true, lists:sublist(SceneIds, ?SCENE_NUM)};
                        _ -> {false, SceneIds}
                    end;
                _ -> {false, SceneIds}
            end;
        false -> {true, SceneIds}
    end,
    case Res of
        {false, CandidatesL} ->
            F = fun(SceneId) ->
                case data_scene:get(SceneId) of
                    #ets_scene{requirement = RequirementL1} ->
                        case lists:keyfind(lv, 1, RequirementL1) of
                            {lv, [{_, EnterLvLim1}|_]} when EnterLvLim1 =< WorldLv - 100 -> true;
                            false -> true;
                            {lv, []} -> true;
                            _ -> false
                        end;
                    _ -> false
                end
            end,
            NewCandidatesL = lists:filter(F, CandidatesL),
            VaildSceneIds = lists:sublist(lists:reverse(NewCandidatesL), ?SCENE_NUM);
        {true, VaildSceneIds} -> skip
    end,
    case VaildSceneIds =/= [] of
        true ->
            SceneNum = length(VaildSceneIds),
            BaseNum = RealBossNum div SceneNum,
            ExtraNum = RealBossNum rem SceneNum,
            case BaseNum >= SingleSceneNumLim of
                true ->
                    SpecialSceneBossNum = SingleSceneNumLim,
                    RealBaseBossNum = SingleSceneNumLim;
                false ->
                    SpecialSceneBossNum = min(BaseNum + 1, SingleSceneNumLim),
                    RealBaseBossNum = BaseNum
            end,
            SpecialSceneIds = urand:get_rand_list(ExtraNum, VaildSceneIds),
            BossList = do_init_boss(VaildSceneIds, RealBaseBossNum, SpecialSceneBossNum, SpecialSceneIds, BossId, WorldLv, []),
            BossList;
        _ -> []
    end.

do_init_boss([], _, _, _, _, _, Result) -> Result;
do_init_boss([SceneId|L], BaseBossNum, SpecialSceneBossNum, SpecialSceneIds, BossId, BossLv, Result) ->
    RealBossNum = case lists:member(SceneId, SpecialSceneIds) of
        true -> SpecialSceneBossNum;
        false -> BaseBossNum
    end,
    BornPointsL = data_act_boss:get_points(SceneId),
    RealBornPointsL = urand:get_rand_list(RealBossNum, BornPointsL),
    do_init_boss_core(RealBornPointsL, BossId, BossLv, SceneId),
    TotalNum = length(RealBornPointsL),
    NewResult = [#boss_status{scene_id = SceneId, remain_num = TotalNum, total_num = TotalNum}|Result],
    do_init_boss(L, BaseBossNum, SpecialSceneBossNum, SpecialSceneIds, BossId, BossLv, NewResult).

do_init_boss_core([], _BossId, _BossLv, _SceneId) -> ok;
do_init_boss_core([{X, Y}|L], BossId, BossLv, SceneId) ->
    lib_mon:async_create_mon(BossId, SceneId, 0, X, Y, 0, 0, 1, [{create_key, act_boss}, {lv, BossLv}]),
    do_init_boss_core(L, BossId, BossLv, SceneId).

format_time(TimesPoints) when is_list(TimesPoints) ->
    [{SH*3600+SM*60+SS,EH*3600+EM*60+ES}||{{SH, SM, SS}, {EH, EM, ES}} <- TimesPoints];
format_time(_) -> [].

check_time([], _) -> {?ACT_STATUS_ALL_KILL, 86401};
check_time([{Stime, Etime}|TimesL], NowTime) ->
    if
        NowTime >= Stime andalso NowTime < Etime ->
            {?ACT_STATUS_BOSS_BORN, Etime};
        NowTime < Stime ->
            {?ACT_STATUS_WAIT_NEXT, Stime};
        true ->
            check_time(TimesL, NowTime)
    end.

%% 计算三天平均在线人数
count_3day_avg_online_num() ->
    Etime = utime:get_logic_day_start_time(),
    Stime = Etime - 86400 * 3,
    List = db:get_all(io_lib:format(<<"select total from log_online where timestamp >= ~p and timestamp <= ~p">>, [Stime, Etime])),
    F = fun(T, {TmpNum, TmpSum}) ->
        case T of
            [OnlineNum] ->
                {TmpNum + 1, TmpSum + OnlineNum};
            _ ->
                {TmpNum, TmpSum}
        end
    end,
    {Num, Sum} = lists:foldl(F, {0, 0}, List),
    case Num > 0 of
        true ->
            round(Sum / Num);
        false -> 1
    end.

is_act_boss(MonId) ->
    case lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_ACT_BOSS) of
        [#act_info{key = {?CUSTOM_ACT_TYPE_ACT_BOSS, SubType}, etime = _Etime}|_] -> %% 多个活动Boss同时开启,只取活动类型最小的生效
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_ACT_BOSS, SubType) of
                #custom_act_cfg{condition = Condition} ->
                    CheckList = [boss_id],
                    case lib_custom_act_check:check_act_condtion(CheckList, Condition) of
                        [BossId] when BossId == MonId -> true;
                        _ -> false
                    end;
                _ -> false
            end;
        _ -> false
    end.

pack_boss_list(BossList) ->
    F = fun(T, Acc) ->
        case T of
            #boss_status{scene_id = SceneId, remain_num = RemainNum} ->
                [{SceneId, RemainNum}|Acc];
            _ -> Acc
        end
    end,
    lists:foldl(F, [], BossList).

log_act_boss(State) ->
    #act_state{avg_online_num = AvgOnlineNum, boss_list = BossList} = State,
    Platform = config:get_platform(),
    ServerNum = config:get_server_num(),
    F = fun(T, {TmpSum, TmpKillNum, Acc}) ->
        case T of
            #boss_status{scene_id = SceneId, remain_num = RemainNum, total_num = TotalNum} ->
                {TmpSum + TotalNum, TmpKillNum + (TotalNum - RemainNum), [{SceneId, RemainNum, TotalNum}|Acc]};
            _ -> {TmpSum, TmpKillNum, Acc}
        end
    end,
    {Sum, KillNum, BossListLogArgs} = lists:foldl(F, {0, 0, []}, BossList),
    lib_log_api:log_act_boss(Platform, ServerNum, AvgOnlineNum, Sum, KillNum, BossListLogArgs).
