%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_night_ghost_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行数据相关
%%% ------------------------------------------------------------------------------------------------
-module(lib_night_ghost_data).

-include("clusters.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("night_ghost.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").

-export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================

%% 获取本服昨日活跃值
%% @return [服id, 昨日活跃值]
get_liveness_local() ->
    case {util:get_open_day(), db_server_activity_local_get()} of
        {1, _} -> [0, ?NG_LIVENESS_DAY1]; % 开服第一天默认值
        {_, []} -> [0, 0];
        {_, Res} -> Res
    end.

%% 获取所有服昨日活跃值
%% @return [[服id, 昨日活跃值],...]
get_liveness_cls() ->
    db_server_activity_cls_get().

%% 获取指定服的活跃度之和
%% @param SerList :: [#zone_base{},...]
%%        LivenessL :: [[服id, 昨日活跃值],...]
%% @return integer()
get_liveness(SerList, LivenessL) ->
    NLivenessL = [{SerId, Liveness} || [SerId, Liveness] <- LivenessL],
    F = fun(#zone_base{server_id = SerId}, Acc) ->
        {_, Liveness} = ulists:keyfind(SerId, 1, NLivenessL, {0, 0}),
        Acc + Liveness
    end,
    lists:foldl(F, 0, SerList).

%% 获取服务器列表的平均世界等级
get_avg_wlv([]) -> 0;
get_avg_wlv(SerList) ->
    F = fun(#zone_base{world_lv = Wlv}, Acc) -> Acc + Wlv end,
    SumWlv = lists:foldl(F, 0, SerList),
    SumWlv div length(SerList).

%% 获取应该生成的boss数量
%% @return integer()
get_boss_num([], _) ->
    0;
get_boss_num([{{Min, Max}, N} | _], Liveness) when Liveness >= Min, Liveness =< Max ->
    N;
get_boss_num([_ | T], Liveness) ->
    get_boss_num(T, Liveness).

%% 获取活动结束时间
get_act_etime(ActInfo) when is_record(ActInfo, act_info) ->
    ActInfo#act_info.etime;
get_act_etime(_) ->
    0.

%% 计算伤害排名
%% @param Klist :: [#mon_atter{},...] boss攻击者列表
%% @return [#rank_info{},...]
calc_rank_list(Klist) ->
    HurtList = lists:foldl(fun calc_hurt_list/2, [], Klist),
    SortF = fun(#rank_info{hurt = Hurt1}, #rank_info{hurt = Hurt2}) -> Hurt1 > Hurt2 end,
    SortList = lists:sort(SortF, HurtList),
    RankF = fun(RankInfo, {Rank, AccL}) -> {Rank+1, [RankInfo#rank_info{rank = Rank} | AccL]} end,
    {_, RankList} = lists:foldl(RankF, {1, []}, SortList),
    RankList.

%% 构造伤害列表
calc_hurt_list(#mon_atter{id = RoleId, team_id = 0, hurt = Hurt} = Atter, HurtList) -> % 没组队,单人参与
    RankInfo = #rank_info{
        key = {?NG_ROLE, RoleId},
        sign = ?NG_ROLE,
        id = RoleId,
        role_list = [Atter],
        hurt = Hurt
    },
    [RankInfo | HurtList];
calc_hurt_list(#mon_atter{team_id = TeamId, hurt = Hurt} = Atter, HurtList) -> % 组队形式
    case lists:keyfind({?NG_TEAM, TeamId}, #rank_info.key, HurtList) of
        #rank_info{role_list = RoleList, hurt = TeamHurt} = RankInfo ->
            NRankInfo = RankInfo#rank_info{
                role_list = [Atter | RoleList],
                hurt = TeamHurt + Hurt
            },
            lists:keyreplace({?NG_TEAM, TeamId}, #rank_info.key, HurtList, NRankInfo);
        _ ->
            RankInfo = #rank_info{
                key = {?NG_TEAM, TeamId},
                sign = ?NG_TEAM,
                id = TeamId,
                role_list = [Atter],
                hurt = Hurt
            },
            [RankInfo | HurtList]
    end.

%% 根据活动信息创建需要的定时器
%% @return #act_info{} | undefined
create_ref(#act_info{etime = ETime} = ActInfo) when ETime > 0 ->
    NowTime = utime:unixtime(),
    EndRef = erlang:send_after(timer:seconds(ETime - NowTime), self(), {'act_end'}),
    BossRef = erlang:send_after(timer:seconds(?NG_LEFT_BOSS_TV), self(), {'left_boss'}),
    CdRef = erlang:send_after(timer:seconds(ETime - NowTime - ?NG_COUNTDOWN_TV), self(), {'countdown'}),

    ActInfo#act_info{
        end_ref = EndRef,
        boss_ref = BossRef,
        cd_ref = CdRef
    };
create_ref(_) -> undefined.

%% 清理定时器
clear_ref(ActInfo) when is_record(ActInfo, act_info) ->
    #act_info{
        end_ref = EndRef,
        boss_ref = BossRef,
        cd_ref = CdRef
    } = ActInfo,

    util:cancel_timer(EndRef),
    util:cancel_timer(BossRef),
    util:cancel_timer(CdRef);
clear_ref(_) -> skip.

%% 打包协议数据
pack_20602(SceneInfoM) ->
    SceneIds = maps:keys(SceneInfoM),
    F = fun(SceneId, {AccL, AccM}) ->
        {SceneRawInfo, SceneBin} = pack_20602(SceneId, SceneInfoM),
        {SceneRawInfo ++ AccL, AccM#{SceneId => SceneBin}}
    end,
    {InfoList, BinMap} = lists:foldl(F, {[], #{}}, SceneIds),
    {ok, AllBin} = pt_206:write(20602, [InfoList]), % 所有场景的信息打包
    NBinMap = maps:merge(BinMap, #{0 => AllBin}),
    {InfoList, NBinMap}.

pack_20602(SceneId, SceneInfoM) ->
    #scene_info{boss_info = BossList} = maps:get(SceneId, SceneInfoM, #scene_info{}),
    BossIds = [BossId || #boss_info{boss_id = BossId, is_alive = true} <- BossList],
    Num = length(BossIds),
    {ok, SceneBin} = pt_206:write(20602, [[{SceneId, Num, BossIds}]]), % 单个场景的信息打包
    {[{SceneId, Num, BossIds}], SceneBin}.

%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).

db_server_activity_local_get() ->
    Sql = <<"
        select server_id, yesterday
        from beings_gate_activity
        where server_id = ~p
    ">>,
    sql(get_row, Sql, [config:get_server_id()]).

db_server_activity_cls_get() ->
    Sql = <<"
        select server_id, yesterday
        from beings_gate_activity_cls
    ">>,
    sql(get_all, Sql, []).