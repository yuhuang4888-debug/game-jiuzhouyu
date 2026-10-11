%% ---------------------------------------------------------------------------
%% @doc lib_sanctuary_cluster_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_sanctuary_cluster_util).

%% API
-export([
      get_process_name/1             %% 获取跨服圣域活动进程名
    , get_process/1
    , calc_role_clear_time/1
    , calc_act_open_time/1
    , calc_next_mon_time/1
    , get_server_santype/1
    , get_scenes_by_santype/1
    , get_building_type_by_scene/1
    , create_mon_init/3
    , create_mon/5
    , send_error/2
    , send_error/3
    , send_data/3
    , check_enter/2
    , get_link_enter_scenes/1
    , get_last_kill_msg/1
    , calc_revive_time/2
    , get_revive_cost/0
    , is_in_sanctuary_scene/1
    , get_clear_time/0
    , sort_score_rank_map/1
    , make_sanctuary_kf_role_rank_info/2
    , db_save_role_rank_info_list/4
    , sort_score_rank_list/1
]).

-include("common.hrl").
-include("server.hrl").
-include("cluster_sanctuary.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("scene.hrl").

%% -----------------------------------------------------------------
%% 获取进程(名)
%% -----------------------------------------------------------------
get_process_name(ZoneId) ->
    list_to_atom(lists:concat([mod_sanctuary_cluster, "_", ZoneId])).

get_process(ZoneId) ->
    whereis(get_process_name(ZoneId)).

%% -----------------------------------------------------------------
%% 计算玩家怒气清理时间
%% -----------------------------------------------------------------
calc_role_clear_time(NowTime) ->
    [{SH, SM}] = data_cluster_sanctuary_m:get_san_value(clear_role_anger_time),
    NowDate = utime:unixdate(NowTime),
    {Date,_} = utime:unixtime_to_localtime(NowDate),
    ClearTime = utime:unixtime({Date, {SH, SM,0}}),
    if
        ClearTime < NowTime ->
            NClearTime = ClearTime + ?ONE_DAY_SECONDS;
        true ->
            NClearTime = ClearTime
    end,
    NClearTime.

%% -----------------------------------------------------------------
%% 计算活动时间
%% -----------------------------------------------------------------
calc_act_open_time(NowDate) ->
    [{open,{Hour,Minute}},{continue, {SH,SM}}] = data_cluster_sanctuary_m:get_san_value(open_time),
    BeginTime = NowDate + Hour*?ONE_HOUR_SECONDS + Minute*?ONE_MIN,
    EndTime = BeginTime + SH*?ONE_HOUR_SECONDS + SM*?ONE_MIN,
    {BeginTime, EndTime}.

%% -----------------------------------------------------------------
%% 计算下次怪物刷新时间
%% -----------------------------------------------------------------
calc_next_mon_time(NowTime) ->
    ReBornTimeL = data_cluster_sanctuary_m:get_san_value(reborn_time),
    {_D,{NowSH,NowSM, NowSS}} = utime:unixtime_to_localtime(NowTime),
    case ulists:find(fun({H, M}) -> (NowSH * 60 + NowSM) * 60 + NowSS < (H * 60 + M) * 60 end, ReBornTimeL) of
        {ok, {SH, SM}} ->
            NextMonTime = utime:unixtime({_D, {SH, SM,0}});
        _ ->
            [{SH, SM}|_] = ReBornTimeL,
            {D, _} = utime:unixtime_to_localtime(NowTime + ?ONE_DAY_SECONDS),
            NextMonTime = utime:unixtime({D, {SH, SM, 0}})
    end,
    NextMonTime.


%% -----------------------------------------------------------------
%% 获取当前模式
%% -----------------------------------------------------------------
get_server_santype(OpenDay) ->
    AllSanTypes = lists:reverse(data_cluster_sanctuary:get_all_santype()),
    F = fun(SanType) -> OpenDay >= data_cluster_sanctuary:get_type_by_openday(SanType) end,
    case ulists:find(F, AllSanTypes) of
        {ok, CurrentSanType} -> CurrentSanType;
        _ -> false
    end.

%% -----------------------------------------------------------------
%% 根据圣域模式获取相应的场景id
%% -----------------------------------------------------------------
get_scenes_by_santype(SanType) ->
    case data_cluster_sanctuary:get_san_type(SanType) of
        #base_san_type{san_num = [{3, SanScenes}],city_num = [{2, CityScenes}],village_num = [{1, VillScenes}]} ->
            SanScenes ++ CityScenes ++ VillScenes;
        _ ->
            ?ERR("ERR config Santype:~p, server SantypeList = [1,2,3]~n",[SanType]),
            []
    end.

%% -----------------------------------------------------------------
%% 根据场景ID获取建筑类型
%% -----------------------------------------------------------------
get_building_type_by_scene(SceneId) ->
    AllSceneType = data_cluster_sanctuary:get_all_scene_type(),
    TypeSceneL = [{SceneType, data_cluster_sanctuary:get_scene_ids(SceneType)}||SceneType<-AllSceneType],
    F = fun({_Type, SceneL}) -> lists:member(SceneId, SceneL) end,
    case ulists:find(F, TypeSceneL) of
        {ok, {SceneType, _}} ->
            case data_cluster_sanctuary:get_con_type(SceneType) of
                [BuildType] -> BuildType;
                _ -> 0
            end;
        _ -> 0
    end .

%% -----------------------------------------------------------------
%% 创建怪物
%% -----------------------------------------------------------------
create_mon(MonIdL, SceneId, PoolId, CopyId, WorldLv) ->
    create_mon(MonIdL, SceneId, PoolId, CopyId, WorldLv, []).

create_mon([], _SceneId, _PoolId, _CopyId, _WorldLv, MonStateL) -> MonStateL;
create_mon([MonId|T], SceneId, PoolId, CopyId, WorldLv, MonStateL) ->
    #base_san_mon{type = MonType, x = X, y = Y} = data_cluster_sanctuary:get_mon_cfg(MonId),
    lib_mon:sync_create_mon(MonId, SceneId, PoolId, X, Y, 0, CopyId, 1, [{auto_lv, WorldLv}, {type, MonType}]),
    MonState = #sanctuary_mon_state{mon_id = MonId, mon_type = MonType, mon_lv = WorldLv},
    create_mon(T, SceneId, PoolId, CopyId, WorldLv, [MonState|MonStateL]).

% 仅数据
create_mon_init(MonIdL, _WorldLv, _RebornTime) ->
    create_mon_init(MonIdL, _WorldLv, _RebornTime, []).
create_mon_init([], _WorldLv, _RebornTime, MonStateL) -> MonStateL;
create_mon_init([MonId|T], WorldLv, RebornTime, MonStateL) ->
    #base_san_mon{type = MonType} = data_cluster_sanctuary:get_mon_cfg(MonId),
    MonState = #sanctuary_mon_state{mon_id = MonId, mon_type = MonType, mon_lv = WorldLv, reborn_time = RebornTime},
    create_mon_init(T, WorldLv, RebornTime, [MonState|MonStateL]).

%% -----------------------------------------------------------------
%% 发送错误信息
%% -----------------------------------------------------------------
send_error(RoleId, Code) ->
    {ok, BinData} = pt_284:write(28414, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData).

send_error(ServerId, RoleId, Code) ->
    {ok, BinData} = pt_284:write(28414, [Code]),
    send_data(ServerId, RoleId, BinData).

send_data(ServerId, RoleId, BinData) ->
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]).

%% -----------------------------------------------------------------
%% 检查进入
%% -----------------------------------------------------------------
check_enter(Player, SceneId) ->
    #player_status{scene = CurrentSceneId} = Player,
    case lib_player_check:check_list(Player, [action_free]) of
        true ->
            ?IF(CurrentSceneId == SceneId, {false, ?ERRCODE(already_in_scene)}, true);
        _ErrInfo ->
            _ErrInfo
    end.

%% -----------------------------------------------------------------
%% 根据场景ID 获取其可以进入的场景
%% -----------------------------------------------------------------
get_link_enter_scenes(SceneId) ->
    List = get_link_enter_scenes2(SceneId),
    lists:flatten(List).
get_link_enter_scenes2(SceneId) ->
    % 圣域配型不处理
    case get_building_type_by_scene(SceneId) of
        ?CONS_TYPE_3 -> [];
        _ ->
            case data_cluster_sanctuary:get_can_enter_scenes(SceneId) of
                [] -> [];
                SceneL ->
                    SceneL ++ [get_link_enter_scenes2(SId)||SId<-SceneL]
            end
    end.

%% -----------------------------------------------------------------
%% 上次击杀信息
%% -----------------------------------------------------------------
get_last_kill_msg(Player) ->
    #player_status{last_be_kill = Kill} = Player,
    {sign, Sign} = ulists:keyfind(sign, 1, Kill, {sign, 1}),
    {name, Name} = ulists:keyfind(name, 1, Kill, {name, utext:get(181)}),
    {id, AttId} = ulists:keyfind(id, 1, Kill, {id, 0}),
    {Sign, Name, AttId}.


%% -----------------------------------------------------------------
%% 计算复活时间
%% -----------------------------------------------------------------
calc_revive_time(DieTimes, NowTime) ->
    [{min_times, MinTimes},{special, SpecialList},{extra, WaitTime}] = data_cluster_sanctuary_m:get_san_value(die_wait_time),
    % 计算出可以复活的时间
    CanReviveTime =
        if
            DieTimes < MinTimes -> NowTime;
            true ->
                case lists:keyfind(DieTimes, 1, SpecialList) of
                    {DieTimes, WaitTime1} ->
                        NowTime + WaitTime1;
                    _ ->
                        NowTime + WaitTime
                end
        end,
    {CanReviveTime, MinTimes}.

%% -----------------------------------------------------------------
%% 获取复活消耗
%% -----------------------------------------------------------------
get_revive_cost() ->
    data_cluster_sanctuary_m:get_san_value(revive_cost).


%% -----------------------------------------------------------------
%% 是否在跨服圣域
%% -----------------------------------------------------------------
is_in_sanctuary_scene(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
            true;
        _ ->
            false
    end.

%% -----------------------------------------------------------------
%% 获取清理积分、购买锁 的时间, 每周一4点
%% -----------------------------------------------------------------
get_clear_time() ->
    NowTime = utime:unixtime(),
    DiffDay = utime:diff_day_of_week(1, NowTime),
    ClearTime = DiffDay * ?ONE_DAY_SECONDS + utime:unixdate(NowTime) + 4 * ?ONE_HOUR_SECONDS,
    if
        NowTime > ClearTime ->
            ClearTime + 7 * ?ONE_DAY_SECONDS;
        true ->
            ClearTime
    end.

sort_score_rank_map(RankMap) ->
    Fun = fun(_SerId, RankList) ->
        sort_score_rank_list(RankList)
    end,
    maps:map(Fun, RankMap).

%% 排行榜单
sort_score_rank_list(RankList) ->
    Fun = fun(RoleA, RoleB) ->
        if
            RoleA#sanctuary_kf_role_rank_info.score > RoleB#sanctuary_kf_role_rank_info.score -> true;          %% 积分排序
            RoleA#sanctuary_kf_role_rank_info.score < RoleB#sanctuary_kf_role_rank_info.score -> false;
            RoleA#sanctuary_kf_role_rank_info.kill_num > RoleB#sanctuary_kf_role_rank_info.kill_num -> true;    %% 击杀玩家排序
            RoleA#sanctuary_kf_role_rank_info.kill_num < RoleB#sanctuary_kf_role_rank_info.kill_num -> false;
            RoleA#sanctuary_kf_role_rank_info.last_time < RoleB#sanctuary_kf_role_rank_info.last_time -> true;  %% 入榜时间排序
            RoleA#sanctuary_kf_role_rank_info.last_time > RoleB#sanctuary_kf_role_rank_info.last_time -> false;
            RoleA#sanctuary_kf_role_rank_info.player_id < RoleB#sanctuary_kf_role_rank_info.player_id -> true;  %% 根据玩家ID排序
            true -> false
        end
    end,
    NewRankList = lists:sort(Fun, RankList),
    set_score_rank_list_ranking(NewRankList, 1, []).

set_score_rank_list_ranking([], _, List) ->
    List;
set_score_rank_list_ranking([RankRole|Tail], InitRanking, List) ->
    NewRankRole = RankRole#sanctuary_kf_role_rank_info{ rank = InitRanking },
    NewInitRanking = InitRanking + 1,
    set_score_rank_list_ranking(Tail, NewInitRanking, [NewRankRole|List]).

make_sanctuary_kf_role_rank_info([], AllRankRoleInfoL) ->
    AllRankRoleMap = ulists:group(1, AllRankRoleInfoL),
    Fun = fun(_Key, RankList) ->
        [RankInfo || {_, RankInfo} <-RankList]
    end,
    maps:map(Fun, AllRankRoleMap);
make_sanctuary_kf_role_rank_info([RoleInfo|Tail], AllRankRoleInfoL)  ->
    [PlayerId, GroupId, SceneId, PlayerName, ServerId, Score, KillNum, LastTime]= RoleInfo,
    RankRole = #sanctuary_kf_role_rank_info{
        player_id = PlayerId, player_name = PlayerName, server_id = ServerId,
        kill_num = KillNum, last_time = LastTime, score = Score
    },
    make_sanctuary_kf_role_rank_info(Tail, [{{GroupId, SceneId}, RankRole}|AllRankRoleInfoL]).

db_save_role_rank_info_list(RoleList, ZoneId, GroupId, SceneId) ->
    ValueStr = ulists:list_to_string(
        [io_lib:format("(~p, ~p, ~p, ~p, '~s', ~p, ~p, ~p, ~p)", [PlayerId, ZoneId, GroupId, SceneId, util:fix_sql_str(RoleName), ServerId, Score, KillNum, LastTime]) ||
            #sanctuary_kf_role_rank_info{player_id = PlayerId, player_name = RoleName, server_id = ServerId, score = Score, kill_num = KillNum, last_time = LastTime} <- RoleList], ","),
    SQL = io_lib:format(?sql_update_some_sanctuary_kf_role_rank_info, [ValueStr]),
    db:execute(SQL).





