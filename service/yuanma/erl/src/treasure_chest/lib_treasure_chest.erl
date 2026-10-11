%%-----------------------------------------------------------------------------
%% @Module  :       lib_treasure_chest
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-25
%% @Description:    青云夺宝
%%-----------------------------------------------------------------------------
-module(lib_treasure_chest).

-include("treasure_chest.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("activitycalen.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").

-export([
    login/1
    , init_act/0
    , act_start/1
    , refresh_chest/1
    , refresh_chest/2
    , refresh_chest/3
    , refresh_chest_in_scene_pro/2
    , check_collect/3
    , collect_finish/2
    , collect_finish_in_player_pro/2
    , broadcast_act_info/1
    , get_default_copy_id/0
    , is_act_scene/1
    ]).

-export([
    gm_start/2
    ]).

gm_start(StartTime, EndTime) ->
    do_act_start(StartTime, EndTime).

login(RoleId) ->
    case db:get_row(io_lib:format(?sql_select_player_treasure_chest, [RoleId])) of
        [Times, ReceiveListBin, Etime] ->
            #player_treasure_chest{
                times = Times,
                receive_list = util:bitstring_to_term(ReceiveListBin),
                etime = Etime
            };
        _ ->
            #player_treasure_chest{}
    end.

init_act() ->
    case lib_activitycalen_api:get_first_enabled_ac_id(?MOD_TREASURE_CHEST, 0) of
        {ok, ActId} ->
            act_start(ActId);
        _ ->
            #status_treasure_chest{}
    end.

act_start(ActId) ->
    Act = data_activitycalen:get_ac(?MOD_TREASURE_CHEST, 0, ActId),
    #base_ac{time_region = TimeRegion} = Act,
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    Now = NowH * 60 + NowM,
    ZeroAclock = utime:unixdate(),
    case ulists:find(fun
        ({{SH, SM}, {EH, EM}}) ->
            SH * 60 + SM =< Now andalso Now =< EH * 60 + EM
    end, TimeRegion) of
        {ok, {{SH, SM}, {EH, EM}}} ->
            StartTime = ZeroAclock + SH * 3600 + SM * 60,
            EndTime = ZeroAclock + EH * 3600 + EM * 60,
            do_act_start(StartTime, EndTime);
        _ ->
            #status_treasure_chest{}
    end.

do_act_start(StartTime, EndTime) ->
    %% 通知活动日历
    NowTime = utime:unixtime(),
    lib_activitycalen_api:success_start_activity(?MOD_TREASURE_CHEST),
    EndDelay = max(EndTime - NowTime, 1),
    Ref = erlang:send_after(EndDelay * 1000, self(), 'act_end'),
    RefreshTime = data_treasure_chest:get_cfg(2),
    NoticeRefreshTime = data_treasure_chest:get_cfg(8),
    NoticeRef = erlang:send_after(max(RefreshTime - NoticeRefreshTime, 1) * 1000, self(), 'notice_refresh'),
    RefreshRef = erlang:send_after(RefreshTime * 1000, self(), 'refresh'),
    SceneId = data_treasure_chest:get_cfg(1),
    mod_scene_agent:apply_cast(SceneId, 0, lib_treasure_chest, refresh_chest_in_scene_pro, [[], EndTime]),
    State = #status_treasure_chest{
        status = ?ACT_STATUS_OPEN,
        stime = StartTime,
        etime = EndTime,
        ref = Ref,
        notice_ref = NoticeRef,
        refresh_ref = RefreshRef,
        refresh_time = NowTime + RefreshTime
    },
    lib_chat:send_TV({all}, ?MOD_TREASURE_CHEST, 3, []),
    broadcast_act_info(State),
    State.

refresh_chest(State) ->
    refresh_chest(State, []).

refresh_chest(State, CopyId) ->
    #status_treasure_chest{etime = Etime} = State,
    SceneId = data_treasure_chest:get_cfg(1),
    Args = [CopyId, Etime],
    mod_scene_agent:apply_cast(SceneId, 0, lib_treasure_chest, refresh_chest_in_scene_pro, Args).

refresh_chest(State, PoolId, CopyId) ->
    #status_treasure_chest{etime = Etime} = State,
    SceneId = data_treasure_chest:get_cfg(1),
    Args = [CopyId, Etime],
    mod_scene_agent:apply_cast(SceneId, PoolId, lib_treasure_chest, refresh_chest_in_scene_pro, Args).

refresh_chest_in_scene_pro(CopyId, ActEtime) ->
    %% 移除没有处于采集状态的宝箱怪
    UsePointsMap = lib_scene_object_agent:clear_treasure_chest_object(CopyId),
    SceneId = data_treasure_chest:get_cfg(1),
    AllPoints = data_treasure_chest:get_cfg(4),
    GenRatio = data_treasure_chest:get_cfg(5),
    MonWeightList = data_treasure_chest:get_mon_list(),
    F = fun({TmpCopyId, TmpX, TmpY}) ->
        RandRatio = urand:rand(0, 100),
        case RandRatio < GenRatio of
            true ->
                MonId = urand:rand_with_weight(MonWeightList),
                case is_integer(MonId) of
                    true ->
                        Args = [{create_key, {treasure_chest, ActEtime}}],
                        lib_mon:async_create_mon(MonId, SceneId, 0, TmpX, TmpY, 0, TmpCopyId, 1, Args);
                    false -> skip
                end;
            false -> skip
        end
    end,
    F1 = fun({TmpCopyId, UsePointsL}) ->
        TmpL = [{TmpCopyId, TmpX, TmpY} || {TmpX, TmpY} <- (AllPoints -- UsePointsL)],
        lists:foreach(F, TmpL)
    end,
    lists:foreach(F1, maps:to_list(UsePointsMap)).

check_collect(SceneUser, Object, CollectType) when CollectType == 1 ->
    #ets_scene_user{figure = Figure, treasure_chest = TreasureChest} = SceneUser,
    #player_treasure_chest{times = Times, etime = Etime} = TreasureChest,
    #scene_object{mon = Mon} = Object,
    MonIds = data_treasure_chest:get_mids(),
    OpenLv = data_treasure_chest:get_cfg(6),
    case Mon of
        #scene_mon{mid = Mid, create_key = {treasure_chest, ActEtime}} ->
            case lists:member(Mid, MonIds) of
                true -> %% 青云夺宝的采集怪
                    case Figure#figure.lv >= OpenLv of
                        true ->
                            MaxCollectTimes = data_treasure_chest:get_cfg(7),
                            case Etime == ActEtime of
                                true -> RealTimes = Times;
                                false -> RealTimes = 0
                            end,
                            case RealTimes < MaxCollectTimes of
                                true -> true;
                                false -> 11
                            end;
                        false -> 12
                    end;
                false -> true
            end;
        _ -> true
    end;
check_collect(_SceneUser, _Object, _CollectType) -> true.

collect_finish(CollectorId, Minfo) when is_integer(CollectorId) ->
    case Minfo of
        #scene_object{mon=#scene_mon{create_key = {treasure_chest, ActEtime}}} ->
            lib_player:apply_cast(CollectorId, ?APPLY_CAST_SAVE, lib_treasure_chest, collect_finish_in_player_pro, [ActEtime]);
        _ -> skip
    end.

collect_finish_in_player_pro(PlayerStatus, ActEtime) ->
    #player_status{sid = Sid, id = RoleId, treasure_chest = TreasureChest} = PlayerStatus,
    #player_treasure_chest{times = Times, receive_list = ReceiveList, etime = Etime} = TreasureChest,
    case Etime == ActEtime of
        true ->
            RealTimes = Times,
            RealReceiveList = ReceiveList;
        false ->
            RealTimes = 0,
            RealReceiveList = []
    end,
    NewTimes = RealTimes + 1,

    %% 日志
    case data_treasure_chest:get_reward(NewTimes) of
        TimesReward when TimesReward =:= [] ->
            NewReceiveList = RealReceiveList;
        TimesReward ->
            lib_log_api:log_treasure_chest_reward(RoleId, NewTimes),
            NewReceiveList = [NewTimes|RealReceiveList]
    end,
    db:execute(io_lib:format(?sql_update_player_treasure_chest,
        [RoleId, NewTimes, util:term_to_string(NewReceiveList), ActEtime])),

    NewTreasureChest = TreasureChest#player_treasure_chest{times = NewTimes, receive_list = NewReceiveList, etime = ActEtime},

    case TimesReward =/= [] of
        true ->
            Produce = lib_goods_api:make_produce(treasure_chest, 0, utext:get(4140001, [NewTimes]), utext:get(4140001, [NewTimes]), TimesReward, 1),
            {ok, NewPlayerStatus} = lib_goods_api:send_reward_with_mail(PlayerStatus#player_status{treasure_chest = NewTreasureChest}, Produce);
        _ -> NewPlayerStatus = PlayerStatus#player_status{treasure_chest = NewTreasureChest}
    end,

    {ok, BinData} = pt_414:write(41401, [NewTimes, NewReceiveList]),
    lib_server_send:send_to_sid(Sid, BinData),

    mod_scene_agent:update(NewPlayerStatus, [{treasure_chest, NewTreasureChest}]),

    TipsBinData = lib_chat:make_tv(?MOD_TREASURE_CHEST, 1, [NewTimes, data_treasure_chest:get_cfg(7)]),
    lib_server_send:send_to_sid(Sid, TipsBinData),

    %% 增加活跃度
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_TREASURE_CHEST, 0),
    {ok, NewPlayerStatus}.

is_act_scene(SceneId) ->
    SceneId == data_treasure_chest:get_cfg(1).

get_default_copy_id() -> ?DEF_ACT_COPY_ID.

broadcast_act_info(State) ->
    #status_treasure_chest{status = Status, etime = Etime} = State,
    {ok, BinData} = pt_414:write(41404, [Status, Etime]),
    lib_server_send:send_to_all(BinData).

