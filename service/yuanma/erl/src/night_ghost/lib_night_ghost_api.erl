%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_night_ghost_api.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-04-01
%%% @modified
%%% @description    百鬼夜行api
%%% ------------------------------------------------------------------------------------------------
-module(lib_night_ghost_api).

-include("battle.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("night_ghost.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("team.hrl").

-export([boss_be_killed/5, send_team_reward/3, send_reward/3, send_tv/2]).

-export([
    log_night_ghost_boss/4, log_night_ghost_rank/5, log_night_ghost_killer/5,
    log_night_ghost_reward/4
]).

% -compile(export_all).

%% boss被击杀
boss_be_killed(IsCls, Minfo, Klist, Atter, AtterSign) when IsCls -> % 跨服boss
    lib_night_ghost:is_night_ghost_scene(Minfo#scene_object.scene) andalso
    mod_night_ghost_kf:boss_be_killed(Minfo, Klist, Atter, AtterSign);

boss_be_killed(_, Minfo, Klist, Atter, AtterSign) -> % 本服boss
    lib_night_ghost:is_night_ghost_scene(Minfo#scene_object.scene) andalso
    mod_night_ghost_local:boss_be_killed(Minfo, Klist, Atter, AtterSign).

%% 按队伍发放奖励
send_team_reward(#team{cls_type = ?NODE_GAME, member = Mbs} = Team, Type, Rank) -> % 本服模式
    RoleIds = [Id || #mb{id = Id} <- Mbs, Id /= 0],
    send_reward(Type, RoleIds, Rank),
    Team;
send_team_reward(#team{cls_type = ?NODE_CENTER, member = Mbs} = Team, Type, Rank) -> % 跨服模式
    [
        mod_clusters_center:apply_cast(SerId, ?MODULE, send_reward, [Type, [RoleId], Rank])
     || #mb{id = RoleId, server_id = SerId} <- Mbs, RoleId /= 0
    ],
    Team.

%% 本服执行发放奖励具体操作
send_reward(?NG_REWARD_TYPE_BC_BOSS = Type, RoleIds, SerMod) ->
    {_, RewardList} = ulists:keyfind(SerMod, 1, ?NG_BC_BOSS_REWARD, []),
    log_night_ghost_reward(RoleIds, Type, 0, RewardList),
    Produce = #produce{type = 'night_ghost', reward = RewardList, show_tips = ?SHOW_TIPS_1},
    [
        begin
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            lib_night_ghost:send_msg(RoleId, ?ERRCODE(err206_ng_boss_bc_reward_msg))
        end
     || RoleId <- RoleIds
    ];

send_reward(Type, RoleIds, Rank) ->
    {Title, Content} =
    case Type of
        ?NG_REWARD_TYPE_RANK ->
            {utext:get(2060001), utext:get(2060002, [Rank])};
        ?NG_REWARD_TYPE_KILLER ->
            {utext:get(2060003), utext:get(2060004)}
    end,
    OpDay = util:get_open_day(),
    RewardList = data_night_ghost:get_ng_reward(Type, Rank, OpDay),
    log_night_ghost_reward(RoleIds, Type, Rank, RewardList),
    mod_mail_queue:add(?MOD_NIGHT_GHOST, RoleIds, Title, Content, RewardList).

%% 本服发送传闻
send_tv('act_start', _) -> % 活动开始
    lib_chat:send_TV({all}, 206, 1, []);

send_tv('boss_be_killed', [RoleName, BossId]) -> % boss被击杀
    #mon{name = BossName} = data_mon:get(BossId),
    lib_chat:send_TV({all}, 206, 2, [RoleName, BossName]);

send_tv('left_boss', [_, 0]) -> skip;
send_tv('left_boss', [SceneId, Num]) -> % 剩余boss数量
    #ets_scene{name = SceneName} = data_scene:get(SceneId),
    lib_chat:send_TV({all}, 206, 3, [SceneName, Num]);

send_tv('countdown', [LeftSec]) -> % 活动结束倒计时
    LefMin = LeftSec div 60,
    lib_chat:send_TV({all}, 206, 4, [LefMin]);

send_tv('act_end', _) -> % 活动结束
    lib_chat:send_TV({all}, 206, 5, []);

send_tv(_, _) -> skip.

%% boss生成、死亡日志
log_night_ghost_boss(ZoneId, GroupId, SceneId, BossList) ->
    [
        begin
            Type = ?IF(IsAlive, ?NG_BOSS_BORN, ?NG_BOSS_DEAD),
            lib_log_api:log_night_ghost_boss(ZoneId, GroupId, SceneId, BossId, X, Y, Type)
        end
     || #boss_info{boss_id = BossId, x = X, y = Y, is_alive = IsAlive} <- BossList
    ],
    ok.

%% 伤害排名日志
log_night_ghost_rank(ZoneId, GroupId, SceneId, BossId, RankList) ->
    [
        begin
            #rank_info{
                rank = Rank,
                key = {Sign, Id},
                role_list = RoleList,
                hurt = Hurt
            } = RankInfo,
            [
                lib_log_api:log_night_ghost_rank(ZoneId, GroupId, SceneId, BossId, Sign, Id, SerId, RoleId, Rank, Hurt)
             || #mon_atter{server_id = SerId, id = RoleId} <- RoleList
            ]
        end
     || RankInfo <- RankList
    ],
    ok.

%% 尾刀日志
log_night_ghost_killer(ZoneId, GroupId, SceneId, BossId, Killer) ->
    #battle_return_atter{
        server_id = SerId, server_num = _SerNum,
        real_id = RoleId, team_id = TeamId
    } = Killer,
    lib_log_api:log_night_ghost_killer(ZoneId, GroupId, SceneId, BossId, SerId, TeamId, RoleId),
    ok.

%% 奖励日志(本服)
log_night_ghost_reward(RoleIds, Type, Rank, RewardList) ->
    [lib_log_api:log_night_ghost_reward(RoleId, Type, Rank, RewardList) || RoleId <- RoleIds],
    ok.