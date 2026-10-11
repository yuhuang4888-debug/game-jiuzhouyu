%% ---------------------------------------------------------------------------
%% @doc lib_sanctuary_cluster

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(lib_sanctuary_cluster).

%% API In PS
-export([
      login/2
    , re_login/1
    , logout/1
    , enter/2
    , send_role_score_info/1
    , unlock_score_reward/1
    , quit/1
    , get_score_reward/2
    , get_die_tired/1
    , add_score/3
    , add_anger_kill_event/3
    , send_medal/3
    , clear_anger/1
    , send_bl_reward/3
    , role_out/2
]).

-export([
      role_add_score/2
    , role_add_anger_kill_event/3
    , role_send_medal/3
    , notify_clear_scene/2
    , clear_role_anger/0
    , send_act_end_tv/1
    , role_send_bl_reward/3
    , clear_role/2
]).

-export([
    kill_player/2,
    add_score_kill_player/3,
    notify_score_rank_list/2,
    get_role_sanctuary_rank_info/2,
    player_change_scene/2,
    do_player_change_scene/2,
    trigger_type_task/2,
    clear_round_score_after_mon_reborn/1,
    clear_kill_score/1,
    gm_clear_anger/1,
    gm_refresh_task/1,
    notify_role_in_scene/1,
    after_notify_role_in_scene/1,
    send_28411_bin_data/2,
    gm_add_score/2
]).

% pp_gm
-export([
    set_role_anger/2
]).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("boss.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("cluster_sanctuary.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("task.hrl").

%% -----------------------------------------------------------------
%% 登录
%% -----------------------------------------------------------------
login(RoleId, RoleLv) ->
    OpenDay = util:get_open_day(),
    OpenLv = data_cluster_sanctuary_m:get_san_value(open_lv),
    case data_cluster_sanctuary:get_type_by_openday(OpenDay) of
        SanType when is_integer(SanType), RoleLv >= OpenLv ->
            case db:get_row(io_lib:format(?SQL_SELECT_ROLE_INFO, [RoleId])) of
                [IsPay, Anger, Score, ClearTime, ScoreStatusStr, KillScoreL, IsTask] ->
                    ScoreStatus = util:bitstring_to_term(ScoreStatusStr),
                    StatusSanctuaryCluster =#status_sanctuary_cluster{
                        is_pay = IsPay, anger = Anger, score = Score, kill_score = util:bitstring_to_term(KillScoreL),
                        score_status = ScoreStatus, clear_time = ClearTime, is_task = IsTask
                    },
                    reset_score_and_pay(RoleId, StatusSanctuaryCluster);
                _ ->
                    NewClearTime = lib_sanctuary_cluster_util:get_clear_time(),
                    db:execute(io_lib:format(?SQL_REPLACE_ROLE_INFO, [RoleId, 0, 0, 0, NewClearTime, "[]", "[]", 0])),
                    #status_sanctuary_cluster{clear_time = NewClearTime}
            end;
        _ ->
            #status_sanctuary_cluster{}
    end.

reset_score_and_pay(RoleId, StatusSanctuaryCluster) ->
    NowTime = utime:unixtime(),
    case StatusSanctuaryCluster of
        #status_sanctuary_cluster{ clear_time = ClearTime } when NowTime >= ClearTime ->
            IsPay = 0, Score = 0, ScoreStatus = [],
            NewClearTime = lib_sanctuary_cluster_util:get_clear_time(),
            db:execute(io_lib:format(?SQL_RESET_SCORE_ROLE_INFO, [NewClearTime, RoleId])),
            StatusSanctuaryCluster#status_sanctuary_cluster{
                is_pay = IsPay, score = Score, score_status = ScoreStatus,
                clear_time = NewClearTime, kill_score = []
            };
        _ ->
            StatusSanctuaryCluster
    end.

%% -----------------------------------------------------------------
%% 重连
%% -----------------------------------------------------------------
re_login(Player) ->
    #player_status{id = RoleId} = Player,
    {KSign, KName, AttId} = lib_sanctuary_cluster_util:get_last_kill_msg(Player),
    lib_server_send:send_to_uid(RoleId, pt_200, 20013, [KSign, KName, 0, 0, 0, 0, AttId]),
    get_die_tired(Player),
    NewPlayer = lib_scene:change_relogin_scene(Player, []),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 登出
%% -----------------------------------------------------------------
logout(Player) ->
    #player_status{id = RoleId, scene = SceneId} = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} ->
            mod_sanctuary_cluster_local:quit(RoleId, SceneId);
        _ ->
            skip
    end.

%% -----------------------------------------------------------------
%% 进入场景
%% -----------------------------------------------------------------
enter(Player, SceneId) ->
    #player_status{id = RoleId, scene = OldSceneId} = Player,
    case lib_sanctuary_cluster_util:check_enter(Player, SceneId) of
        {false, ErrCode} ->
            lib_sanctuary_cluster_util:send_error(RoleId, ErrCode);
        true ->
            NeedOut = lib_boss:is_in_outside_scene(Player#player_status.scene),
            mod_sanctuary_cluster_local:enter(RoleId, SceneId, NeedOut, OldSceneId),
            NewPlayer = lib_player:soft_action_lock(Player, ?ERRCODE(err284_enter_cluster), 2),
            {ok, NewPlayer}
    end.

%% -----------------------------------------------------------------
%% 发送个人积分信息
%% -----------------------------------------------------------------
send_role_score_info(Player) ->
    #player_status{sanctuary_cluster = StatusSanCluster0, id = RoleId} = Player,
    StatusSanCluster = reset_score_and_pay(RoleId, StatusSanCluster0),
    #status_sanctuary_cluster{
        score = Score, score_status = ScoreStatus,
        is_pay = IsPay, anger = Anger
    } = StatusSanCluster,
    AllCfg = data_cluster_sanctuary:get_all_score_cfg(),
    ScoreLimit = data_cluster_sanctuary_m:get_san_value(unlock_score),
    Fun = fun(TemScore, Acc) ->
        [ScoreId] = data_cluster_sanctuary:get_id_by_score(TemScore),
        case lists:keyfind(ScoreId, 1, ScoreStatus) of
            {Id, State} -> [{data_cluster_sanctuary_m:get_score_by_id(Id), State}|Acc];
            _ ->
                if
                    Score >= TemScore, TemScore =< ScoreLimit ->
                        [{data_cluster_sanctuary_m:get_score_by_id(ScoreId), ?HAS_ACHIEVE}|Acc];
                    Score >= TemScore -> ?IF(IsPay == 1,
                        [{data_cluster_sanctuary_m:get_score_by_id(ScoreId), ?HAS_ACHIEVE}|Acc], Acc);
                    true ->  Acc
                end
        end
    end,
    SendL = lists:foldl(Fun, [], AllCfg),
    {ok, BinData} = pt_284:write(28405, [Score, IsPay, Anger, SendL]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% -----------------------------------------------------------------
%% 解锁积分奖励
%% -----------------------------------------------------------------
unlock_score_reward(Player) ->
    #player_status{sanctuary_cluster = StatusSanCluster, id = RoleId} = Player,
    case StatusSanCluster of
        #status_sanctuary_cluster{is_pay = 0} ->
            Cost = data_cluster_sanctuary_m:get_san_value(unlock_stage_reward),
            case lib_goods_api:cost_objects_with_auto_buy(Player, Cost, kf_sanctuary_satge, "") of
                {true, NewPlayer, _} ->
                    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{is_pay = 1},
                    db:execute(io_lib:format(?SQL_UPD_PAIED_ROLE_INFO, [1, RoleId])),
                    LastPlayer = NewPlayer#player_status{sanctuary_cluster = NStatusSanCluster},
                    send_role_score_info(LastPlayer),
                    {ok, LastPlayer};
                {false, Code, _} ->
                    lib_sanctuary_cluster_util:send_error(RoleId, Code)
            end;
        _ ->
            lib_sanctuary_cluster_util:send_error(RoleId, ?ERRCODE(has_unlocked))
    end.

%% -----------------------------------------------------------------
%% 退出场景
%% -----------------------------------------------------------------
quit(Player) ->
    #player_status{id = RoleId, scene = SceneId} = Player,
    case lib_player_check:check_list(Player, [action_free]) of
        true ->
            case data_scene:get(SceneId) of
                #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
                    NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100},
                        {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
                    mod_sanctuary_cluster_local:quit(RoleId, SceneId),
                    {ok, NewPlayer};
                _ ->
                    lib_sanctuary_cluster_util:send_error(RoleId, ?FAIL)
            end;
        {false, Errcode} ->
            lib_sanctuary_cluster_util:send_error(RoleId, Errcode)
    end .
    % case data_scene:get(SceneId) of
    %     #ets_scene{type = Type} when Type == ?SCENE_TYPE_KF_SANCTUARY ->
    %         NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100},
    %             {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
    %         mod_sanctuary_cluster_local:quit(RoleId, SceneId),
    %         {ok, NewPlayer};
    %     _ ->
    %         lib_sanctuary_cluster_util:send_error(RoleId, ?FAIL)
    % end.

%% -----------------------------------------------------------------
%% 领取积分奖励
%% -----------------------------------------------------------------
get_score_reward(Player, Score) ->
    #player_status{
        sanctuary_cluster = StatusSanCluster, figure = #figure{name = RoleName},
        id = RoleId, server_id = ServerId, server_num = ServerNum
    } = Player,
    #status_sanctuary_cluster{score_status = ScoreStatus, score = SelfScore, is_pay = IsPay} = StatusSanCluster,
    case data_cluster_sanctuary:get_id_by_score(Score) of
        _ when SelfScore < Score ->
            lib_sanctuary_cluster_util:send_error(RoleId, ?ERRCODE(not_achieve));
        [ScoreId] ->
            case lists:keyfind(ScoreId, 1, ScoreStatus) of
                false ->
                    NewScoreStatus = [{ScoreId, ?HAS_RECIEVE}|ScoreStatus],
                    #base_san_score{reward = Reward} = data_cluster_sanctuary:get_score_cfg(Score),
                    db:execute(io_lib:format(?SQL_UPD_SCORE_STATUS_ROLE_INFO, [util:term_to_string(NewScoreStatus), RoleId])),
                    lib_log_api:log_kf_score_reward(ServerId, ServerNum, RoleId, RoleName, Score, IsPay, Reward),
                    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{score_status = NewScoreStatus},
                    NewPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Reward, kf_sanctuary_score, 0),
                    {ok, BinData} = pt_284:write(28409, [Score, ?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, LastPlayer};
                _ ->
                    lib_sanctuary_cluster_util:send_error(RoleId, ?ERRCODE(has_recieve))
            end
    end.

%% -----------------------------------------------------------------
%% 查看死亡疲劳信息
%% -----------------------------------------------------------------
get_die_tired(Player) ->
    #player_status{sanctuary_cluster = StatusSanCluster, id = RoleId} = Player,
    #status_sanctuary_cluster{die_times = DieTimes} = StatusSanCluster,
    NowTime = utime:unixtime(),
    {CanReviveTime, MinTimes} = lib_sanctuary_cluster_util:calc_revive_time(DieTimes, NowTime),
    % 通知客户端下次复活时间及其他相关信息
    %% 玩家连续死亡间隔时间，在这个值内会被记录
    LogDieInterval = data_cluster_sanctuary_m:get_san_value(player_die_times),
    %% 死亡后多久复活成幽灵
    BTGhostSec = data_cluster_sanctuary_m:get_san_value(revive_point_gost),
    if
        DieTimes > MinTimes ->
            lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, CanReviveTime, NowTime + LogDieInterval, NowTime + BTGhostSec]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_284, 28415, [DieTimes, CanReviveTime, NowTime + LogDieInterval, 0])
    end.


%% -----------------------------------------------------------------
%% 杀怪添加积分
%% -----------------------------------------------------------------
add_score(Player, SceneId, AddScore) ->
    #player_status{sanctuary_cluster = StatusSanCluster0, id = RoleId} = Player,
    StatusSanCluster = reset_score_and_pay(RoleId, StatusSanCluster0),
    #status_sanctuary_cluster{
        score = OScore, kill_score = KillScoreL, anger = Anger
    } = StatusSanCluster,

    NScore = AddScore + OScore,
    {SceneId, OPerSonScore, OKillScore, OldKillNum} = ulists:keyfind(SceneId, 1, KillScoreL, {SceneId, 0, 0, 0}),
    NewPerSonScore = OPerSonScore + AddScore,
    NewKillScoreL = lists:keystore(SceneId, 1, KillScoreL, {SceneId, NewPerSonScore, OKillScore, OldKillNum}),

    Fun = fun({_SceneId, NewPerSonScore2, OKillScore2, _OldKillNum}, AccSum) ->
        AccSum + NewPerSonScore2 + OKillScore2
    end,
    SumScore = lists:foldl(Fun, 0, NewKillScoreL),

    db:execute(io_lib:format(?SQL_UPD_AFTER_KILL_SCORE_ROLE_INFO, [NScore, util:term_to_bitstring(NewKillScoreL), Anger, RoleId])),
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{score = NScore, kill_score = NewKillScoreL},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    %% 积分任务
    lib_task_api:kf_sanctuary_add_score(NPlayer,  SumScore),
    send_role_score_info(NPlayer),
    {ok, NPlayer}.

gm_add_score(Player, AddScore) ->
    #player_status{sanctuary_cluster = StatusSanCluster0, id = RoleId} = Player,
    StatusSanCluster = reset_score_and_pay(RoleId, StatusSanCluster0),
    #status_sanctuary_cluster{score = OScore} = StatusSanCluster,
    NScore = AddScore + OScore,
    db:execute(io_lib:format(?SQL_UPD_SCORE_ROLE_INFO, [NScore, RoleId])),
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{score = NScore},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    send_role_score_info(NPlayer),
    {ok, NPlayer}.

%% -----------------------------------------------------------------
%% 击杀敌对服的玩家增加积分
%% -----------------------------------------------------------------
add_score_kill_player(Player, SceneId, KillAddPoint) ->
    #player_status{sanctuary_cluster = StatusSanCluster0, id = RoleId} = Player,
    StatusSanCluster = reset_score_and_pay(RoleId, StatusSanCluster0),
    #status_sanctuary_cluster{
        kill_score = KillScoreL, score = OScore, anger = OldAnger
    } = StatusSanCluster,
    {RewardL, AddAnger} = data_cluster_sanctuary_m:get_san_value(kill_player_reward_and_anger),

    {SceneId, OPerSonScore, OKillScore, OldKillNum} = ulists:keyfind(SceneId, 1, KillScoreL, {SceneId, 0, 0, 0}),
    NewKillScore = OKillScore + KillAddPoint,
    NewKillNum = OldKillNum + 1,
    NewKillScoreL = lists:keystore(SceneId, 1, KillScoreL, {SceneId, OPerSonScore, NewKillScore, NewKillNum}),
    MaxAnger = data_cluster_sanctuary_m:get_san_value(anger_limit),
    NAnger = min(AddAnger + OldAnger, MaxAnger),

    db:execute(io_lib:format(?SQL_UPD_AFTER_KILL_SCORE_ROLE_INFO, [OScore, util:term_to_bitstring(NewKillScoreL), NAnger, RoleId])),
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{kill_score = NewKillScoreL, score = OScore, anger = NAnger},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    UqRewardL = lib_goods_api:make_reward_unique(RewardL),
    Produce = #produce{type = sanctuary_kill_player_reward, reward = UqRewardL, show_tips = ?SHOW_TIPS_0 },
    NewPlayer2 = lib_goods_api:send_reward(NPlayer, Produce),
    %% 通知场景怒气值变化
    lib_boss:try_to_updata_senen_data(NewPlayer2, ?BOSS_TYPE_KF_SANCTUARY),
    send_role_score_info(NewPlayer2),
    %% 击杀任务
    lib_task_api:kf_sanctuary_kill_player(NewPlayer2),
    {ok, NewPlayer2}.

%% -----------------------------------------------------------------
%% 添加怒气值与杀怪事件触发
%% -----------------------------------------------------------------
add_anger_kill_event(Player, AddAnger, AngerLogArgs) ->
    [SceneId,BuildType,MonId,MonType] = AngerLogArgs,
    #player_status{sanctuary_cluster = StatusSanCluster, id = RoleId, figure = #figure{name = RoleName}} = Player,
    #status_sanctuary_cluster{anger = OAnger} = StatusSanCluster,
    MaxAnger = data_cluster_sanctuary_m:get_san_value(anger_limit),
    NAnger = min(AddAnger + OAnger, MaxAnger),
    db:execute(io_lib:format(?SQL_UPD_ANGER_ROLE_INFO, [NAnger, RoleId])),
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{anger = NAnger},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_boss_event, []),
    {ok, LastPlayer0} = lib_temple_awaken_api:trigger_sanctuary_boss(NPlayer),
    {ok, LastPlayer1} = lib_eternal_valley_api:sanctuary_boss(LastPlayer0),
    CallBackData = #callback_boss_kill{boss_type = ?BOSS_TYPE_KF_SANCTUARY, boss_id = MonId},
    {ok, LastPlayer} = lib_player_event:dispatch(LastPlayer1, ?EVENT_BOSS_KILL, CallBackData),
    %% 通知场景怒气值变化
    lib_boss:try_to_updata_senen_data(LastPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    lib_contract_challenge_api:kill_c_sanctuary_boss(RoleId),
    lib_log_api:log_kf_san_kill_log(RoleId, RoleName, SceneId, BuildType, MonId, MonType, OAnger, NAnger),
    send_role_score_info(LastPlayer),
    {ok, LastPlayer}.

%% -----------------------------------------------------------------
%% 发送勋章奖励
%% -----------------------------------------------------------------
send_medal(Player, MedalR, LogArgs) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, server_id = ServerId, server_num = ServerNum} = Player,
    [SceneId, MonId] = LogArgs,
    Produce = #produce{type = kf_sanctuary_hurt_rank, reward = MedalR},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    [{_, _, AddMedal}|_] = MedalR,
    lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_score_event, AddMedal),
    lib_log_api:log_kf_san_medal(ServerId, ServerNum, RoleId, RoleName, SceneId, MonId, MedalR),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 清空怒气值
%% -----------------------------------------------------------------
clear_anger(Player) ->
    #player_status{sanctuary_cluster = StatusSanCluster, id = RoleId} = Player,
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{anger = 0},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    % 二次写入防止极限情况（清空sql刚执行瞬间，玩家添加了怒气）
    db:execute(io_lib:format(?SQL_UPD_ANGER_ROLE_INFO, [0, RoleId])),
    lib_boss:try_to_updata_senen_data(NPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    send_role_score_info(NPlayer),
    {ok, NPlayer}.

%% -----------------------------------------------------------------
%% 获取归属奖励
%% -----------------------------------------------------------------
send_bl_reward(Player, Reward, RewardArgs) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, server_id = ServerId, server_num = ServerNum} = Player,
    [SanType, SceneId, BuildIngType, BlSerId] = RewardArgs,
    Produce = #produce{type = kf_sanctuary_con_bl, reward = Reward},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    lib_log_api:log_kf_san_construction_reward(SanType, SceneId, BuildIngType, BlSerId, ServerId,
        ServerNum, RoleId, RoleName, Reward),
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 玩家被踢出
%% -----------------------------------------------------------------
role_out(Player, SceneId) ->
    case Player of
        #player_status{scene = SceneId} ->
            NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{group, 0}, {change_scene_hp_lim, 100},
                {collect_checker, undefined}, {pk, {?PK_PEACE, true}}]),
            {ok, NewPlayer};
        _ ->
            {ok, Player}
    end.

%% -----------------------------------------------------------------
%% 杀怪添加积分|游戏服执行
%% -----------------------------------------------------------------
role_add_score([], _SceneId) -> ok;
role_add_score([{RoleId, AddScore}|H], SceneId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, add_score, [SceneId, AddScore]),
    role_add_score(H, SceneId).

%% -----------------------------------------------------------------
%% 添加怒气值与杀怪时间触发
%% -----------------------------------------------------------------
role_add_anger_kill_event(RoleIdL, Anger, AngerLogArgs) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, add_anger_kill_event, [Anger, AngerLogArgs])||RoleId <- RoleIdL].

%% -----------------------------------------------------------------
%% 击杀玩家添加积分，怒气、并发放击杀玩家的奖励
%% -----------------------------------------------------------------
kill_player([], _SceneId) -> ok;
kill_player([{RoleId, AddPoint}|Tail], SceneId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, add_score_kill_player, [SceneId, AddPoint]),
    kill_player(Tail, SceneId).

%% -----------------------------------------------------------------
%% 发送勋章奖励
%% -----------------------------------------------------------------
role_send_medal(RoleIdL, MedalR, LogArgs) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, send_medal, [MedalR, LogArgs])||RoleId <- RoleIdL].

%% -----------------------------------------------------------------
%% 通知玩家将要被清出场景
%% -----------------------------------------------------------------
notify_clear_scene(RoleIds, OutSec) ->
    OutTime = utime:unixtime() + OutSec,
    [lib_server_send:send_to_uid(RoleId, pt_284, 28417, [OutTime])|| RoleId <- RoleIds].

%% -----------------------------------------------------------------
%% 通知玩家积分排行
%% -----------------------------------------------------------------
notify_score_rank_list(RoleIds, BinData) ->
    [lib_server_send:send_to_uid(RoleId, BinData)|| RoleId <- RoleIds].

%% -----------------------------------------------------------------
%% 清空所有玩家怒气值
%% -----------------------------------------------------------------
clear_role_anger() ->
    % NowTime = utime:unixtime(),
    % 直接更新sql
    % db:execute(io_lib:format(?SQL_CLEAR_ANGER_ROLE_INFO, [NowTime])),
    db:execute(<<"update sanctuary_kf_role set anger = 0">>),
    % 对在线玩家操作
    [lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, clear_anger, [])||#ets_online{pid = Pid}<-ets:tab2list(?ETS_ONLINE)],
    ok.

%% -----------------------------------------------------------------
%% 通知玩家活动快关了
%% -----------------------------------------------------------------
send_act_end_tv(RemainMin) ->
    LimitLv =  data_cluster_sanctuary:get_san_value(open_lv),
    lib_chat:send_TV({all_lv, LimitLv, 9999}, ?MOD_C_SANCTUARY, 3, [RemainMin]).

%% -----------------------------------------------------------------
%% 归属奖励
%% -----------------------------------------------------------------
role_send_bl_reward(RoleId, Reward, RewardArgs) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, send_bl_reward, [Reward, RewardArgs]).

%% -----------------------------------------------------------------
%% 清理玩家
%% -----------------------------------------------------------------
clear_role(RoleIdL, SceneId) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary_cluster, role_out, [SceneId])||RoleId <- RoleIdL].


%% -----------------------------------------------------------------
%% pp_gm 设置玩家怒气值
%% -----------------------------------------------------------------
set_role_anger(Player, Anger) ->
    #player_status{sanctuary_cluster = StatusSanCluster, id = RoleId} = Player,
    MaxAnger = data_cluster_sanctuary_m:get_san_value(anger_limit),
    NAnger = min(Anger, MaxAnger),
    db:execute(io_lib:format(?SQL_UPD_ANGER_ROLE_INFO, [NAnger, RoleId])),
    NStatusSanCluster = StatusSanCluster#status_sanctuary_cluster{anger = NAnger},
    NPlayer = Player#player_status{sanctuary_cluster = NStatusSanCluster},
    %% 通知场景怒气值变化
    lib_boss:try_to_updata_senen_data(NPlayer, ?BOSS_TYPE_KF_SANCTUARY),
    send_role_score_info(NPlayer),
    {ok, NPlayer}.

get_role_sanctuary_rank_info(Player, SceneId) ->
    #player_status{id = RoleId, sanctuary_cluster = SanctuaryStatus} = Player,
    #status_sanctuary_cluster{ kill_score = KillScoreL} = SanctuaryStatus,
    {SceneId, PersonScore, KillScore, _KillNum} = ulists:keyfind(SceneId, 1, KillScoreL, {SceneId, 0, 0, 0}),
    mod_sanctuary_cluster_local:get_role_sanctuary_rank_info(RoleId, SceneId, PersonScore, KillScore).

%% 怪物刷新时候通知玩家清除上一轮的积分数据
clear_round_score_after_mon_reborn([SendType, LimitInfo, BinData]) ->
    db:execute(io_lib:format(?SQL_UPDATE_DATA_AFTER_MON_REBORN, [])),
    db:execute(io_lib:format("delete from task_bag where type = ~p", [?TASK_TYPE_SANCTUARY_KF])),
    Data = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(D#ets_online.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, ?MODULE, clear_kill_score, []) || D <- Data],
    lib_server_send:send_to_all(SendType, LimitInfo, BinData).

clear_kill_score(Player) ->
    #player_status{sanctuary_cluster = SanctuaryCluster, tid = TaskPid } = Player,
    case SanctuaryCluster of
        #status_sanctuary_cluster{ }  ->
            NewSanctuaryCluster = SanctuaryCluster#status_sanctuary_cluster{ kill_score = [], is_task = 0},
            Player#player_status{ sanctuary_cluster = NewSanctuaryCluster };
        _ ->
            Player
    end.

player_change_scene(PlayerId, ChangeSceneArgs) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_sanctuary_cluster, do_player_change_scene, [ChangeSceneArgs]).

do_player_change_scene(Player, ChangeSceneArgs) ->
    [RoleId, EnterSceneId, ZoneId, GroupId, NeedOut, OtherList] = ChangeSceneArgs,
    #player_status{ id = PlayerId, sanctuary_cluster = SanctuaryCluster  } = Player,
    case SanctuaryCluster of
        #status_sanctuary_cluster{ is_task = IsTask } -> ok;
        _ -> IsTask = 0
    end,
    {ok, BinData} = pt_284:write(28404, [?SUCCESS, IsTask]),
    lib_server_send:send_to_uid(PlayerId, BinData),
    lib_scene:player_change_scene(RoleId, EnterSceneId, ZoneId, GroupId, NeedOut, OtherList).

%% 接取任务
trigger_type_task(Ps, TaskType) ->
    #player_status{tid = Tid, sanctuary_cluster = SanctuaryCluster, id = PlayerId } = Ps,
    case SanctuaryCluster of
        #status_sanctuary_cluster{ is_task = IsTask } when IsTask == 0 ->  %% 0表示未接到任务
            mod_task:clear_kf_sanctuary_task(Tid),
            mod_task:trigger_type_task(Tid, TaskType, lib_task_api:ps2task_args(Ps)),
            NewSanctuaryCluster = SanctuaryCluster#status_sanctuary_cluster{ is_task = 1 },
            db:execute(io_lib:format(?SQL_UPDATE_TASK_STATUS, [1, PlayerId])),  
            Ps#player_status{ sanctuary_cluster = NewSanctuaryCluster };
        _ ->
            Ps
    end.

gm_refresh_task(Player) ->
    #player_status{ sanctuary_cluster = SanctuaryCluster } = Player,
    case SanctuaryCluster of
        #status_sanctuary_cluster{} ->
            NewPlayer = clear_player_task(Player, SanctuaryCluster),
            trigger_type_task(NewPlayer, ?TASK_TYPE_SANCTUARY_KF);
        _ ->
            Player
    end.

clear_player_task(Player, SanctuaryCluster) ->
    NewSanctuaryCluster = SanctuaryCluster#status_sanctuary_cluster{ is_task = 0 },
    Player#player_status{ sanctuary_cluster = NewSanctuaryCluster }.

notify_role_in_scene(SceneIds) ->
    spawn(fun() ->
        [begin
             lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, ?MODULE, after_notify_role_in_scene, [])
         end || RoleId <- SceneIds
        ]
    end).

after_notify_role_in_scene(Player) ->
    trigger_type_task(Player, ?TASK_TYPE_SANCTUARY_KF).

gm_clear_anger(Player) ->
    #player_status{ sanctuary_cluster = SanctuaryCluster } = Player,
    case SanctuaryCluster of
        #status_sanctuary_cluster{} ->
            NewSanctuaryCluster = SanctuaryCluster#status_sanctuary_cluster{ anger = 0},
            Player#player_status{ sanctuary_cluster = NewSanctuaryCluster };
        _ ->
            Player
    end.

send_28411_bin_data(SceneRoleIds, SendData) ->
    [lib_server_send:send_to_uid(RoleId, SendData) || RoleId <- SceneRoleIds].
