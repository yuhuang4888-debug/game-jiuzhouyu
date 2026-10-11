%%-----------------------------------------------------------------------------
%% @Module  :       mod_eudemons_attack.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-03-05
%% @Description:    幻兽入侵活动
%%-----------------------------------------------------------------------------

-module (mod_eudemons_attack).
-include ("common.hrl").
-include ("custom_act.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-include ("eudemons_act.hrl").
-include ("scene.hrl").
-include ("def_module.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,get_act_info/1
    ,player_enter/2
    ,upload_battle_result/4
    ,get_battle_result/1
    ,gm_start/1
    ,act_start/2
    ,act_end/2
]).

-define (STAGE_CLOSED, 0).  %% 活动未开启
-define (STAGE_OPEN, 1).    %% 活动开启
-define (STAGE_IDLE, 2).    %% 活动开启着，但是目前不在战场开启时间段

-define (END_NO, 0).
-define (END_YES, 1).

-define (MAX_ROOM_NUM, 100).
-define (BEFORE_NOTIFY_TIME, 300000). %% 开始前的预告时间ms

-record (state, {
    stime = 0,                      %% 活动开始时间
    etime = 0,                      %% 活动结束时间
    act_info = 0,                   %% 活动信息
    room_auto_id = 1,               %% 房间号自增id
    daily_open_time_ranges = [],    %% 活动开启时间段
    stage_stime = 0,                %% 阶段开始时间
    stage_etime = 0,                %% 阶段结束时间
    cur_stage = ?STAGE_CLOSED,      %% 阶段状态 
    role_list = [],                 %% 玩家列表
    rooms = [],                     %% 房间列表
    timer_ref = undefined,          %% 阶段心跳引用
    enter_lv = 1                    %% 进入等级
    }).

-record (state_role, {
    id,                             %% 玩家id
    room_id,                        %% 所在房间id
    finished = false                %% 是否已完成
    }).

-record (room, {
    id,                             %% 房间id
    pid,                            %% 房间所在战场进程pid
    num = 0,                        %% 房间人数
    max_num = 0,                    %% 房间最大人数
    is_end = ?END_NO,               %% 是否已结束
    rank_list = [],                 %% 伤害排行列表
    killer_id = 0,                  %% 击杀boss的玩家id
    boss_hp = 0                     %% Boss的血量
    }).



-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_act_info(RoleId) ->
    gen_server:cast(?SERVER, {get_act_info, RoleId}).

player_enter(RoleId, RoleLv) ->
    gen_server:cast(?SERVER, {player_enter, RoleId, RoleLv}).

%% 每个战场结束的时候把结算信息发到这里
upload_battle_result(BattlePid, BossHp, KillerId, HurtList) ->
    gen_server:cast(?SERVER, {upload_battle_result, BattlePid, BossHp, KillerId, HurtList}).

%% 获取战况
get_battle_result(RoleId) ->
    gen_server:cast(?SERVER, {get_battle_result, RoleId}).

gm_start(Time) ->
    gen_server:cast(?SERVER, {gm_start, Time}).

act_start(Type, SubType) ->
    gen_server:cast(?SERVER, {act_start, Type, SubType}).

act_end(Type, SubType) ->
    gen_server:cast(?SERVER, {act_end, Type, SubType}).

%% private
init([]) ->
    % process_flag(trap_exit, true),
    {ok, #state{timer_ref = erlang:start_timer(1000, self(), timer_check)}}.

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

do_handle_cast({get_act_info, RoleId}, State) ->
    #state{stage_etime = StageETime, cur_stage = CurStage, role_list = RoleList} = State,
    if
        CurStage =/= ?STAGE_CLOSED ->
            Finished
            = if
                CurStage =:= ?STAGE_OPEN ->
                    case lists:keyfind(RoleId, #state_role.id, RoleList) of
                        #state_role{finished = true} ->
                            1;
                        _ ->
                            0
                    end;
                true ->
                    0
            end,
            {ok, BinData} = pt_603:write(60301, [CurStage, StageETime, Finished]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            skip
    end,
    % ?ERR("60301 ~p~n", [[CurStage, StageETime, State#state.rooms]]),
    {noreply, State};

do_handle_cast({player_enter, RoleId, RoleLv}, State) ->
    #state{cur_stage = CurStage, role_list = RoleList, rooms = Rooms, act_info = ActInfo, stage_etime = StageETime, enter_lv = EnterLv, room_auto_id = AutoId} = State,
    if
        RoleLv < EnterLv ->
            {ok, BinData} = pt_603:write(60300, [?ERRCODE(lv_limit)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State};
        CurStage =:= ?STAGE_OPEN ->
            #act_info{key = {_, ActSubType}} = ActInfo,
            case lists:keyfind(RoleId, #state_role.id, RoleList) of
                #state_role{room_id = RoomId, finished = Finished} ->
                    if
                        Finished ->
                            {ok, BinData} = pt_603:write(60300, [?ERRCODE(err331_act_mission_complete)]),
                            lib_server_send:send_to_uid(RoleId, BinData);
                        true ->
                            case lists:keyfind(RoomId, #room.id, Rooms) of
                                #room{pid = BattlePid, is_end = IsEnd} ->
                                    if
                                        IsEnd ->
                                            {ok, BinData} = pt_603:write(60300, [?ERRCODE(err331_act_mission_complete)]),
                                            lib_server_send:send_to_uid(RoleId, BinData);
                                        true ->
                                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_eudemons_attack, player_enter_ready, [BattlePid, ActSubType])
                                    end;
                                _ ->
                                    {ok, BinData} = pt_603:write(60300, [?FAIL]),
                                    lib_server_send:send_to_uid(RoleId, BinData)
                            end
                    end,
                    {noreply, State};
                _ ->
                    {NewAutoId, Room} = select_a_room(Rooms, AutoId, StageETime, ActInfo),
                    #room{id = RoomId, num = Num, pid = BattlePid} = Room,
                    Role = #state_role{id = RoleId, room_id = Room#room.id},
                    NewRooms = lists:keystore(RoomId, #room.id, Rooms, Room#room{num = Num + 1}),
                    NewRoleList = [Role|RoleList],
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_eudemons_attack, player_enter_ready, [BattlePid, ActSubType]),
                    {noreply, State#state{role_list = NewRoleList, rooms = NewRooms, room_auto_id = NewAutoId}}
            end;
        CurStage =:= ?STAGE_IDLE ->
            {ok, BinData} = pt_603:write(60300, [?ERRCODE(err331_act_closed)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State};
        true ->
            {ok, BinData} = pt_603:write(60300, [?ERRCODE(err331_act_closed)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State}
    end;

do_handle_cast({upload_battle_result, BattlePid, BossHp, KillerId, HurtList}, State) ->
    #state{rooms = Rooms, role_list = RoleList} = State,
    case lists:keyfind(BattlePid, #room.pid, Rooms) of
        #room{is_end = ?END_NO, id = RoomId} = Room ->
            NewRoom = Room#room{killer_id = KillerId, boss_hp = BossHp, rank_list = HurtList, is_end = ?END_YES},
            NewRooms = lists:keystore(BattlePid, #room.pid, Rooms, NewRoom),
            NewRoleList = lists:map(fun
                (#state_role{room_id = RoleRoomId} = Role) when RoleRoomId =:= RoomId ->
                    Role#state_role{finished = true};
                (Role) ->
                    Role
            end, RoleList),
            {noreply, State#state{rooms = NewRooms, role_list = NewRoleList}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({get_battle_result, RoleId}, State) ->
    #state{rooms = Rooms, role_list = RoleList} = State,
    case lists:keyfind(RoleId, #state_role.id, RoleList) of
        #state_role{room_id = RoomId} ->
            case lists:keyfind(RoomId, #room.id, Rooms) of
                #room{killer_id = KillerId, boss_hp = BossHp, rank_list = HurtList} ->
                    Rank = ulists:find_index(fun(#hurt_rank_item{id = AerId}) -> AerId =:= RoleId end, HurtList),
                    MyHurt
                    = case lists:keyfind(RoleId, #hurt_rank_item.id, HurtList) of
                        #hurt_rank_item{hurt = Value} ->
                            Value;
                        _ ->
                            0
                    end;
                _ ->
                    Rank = 0, MyHurt = 0, HurtList = [], KillerId = 0, BossHp = 0
            end;
        _ ->
            Rank = 0, MyHurt = 0, HurtList = [], KillerId = 0, BossHp = 0
    end,
    FormatList = [{RId, Name, Career, Sex, Turn, Pic, Power, Hurt} || #hurt_rank_item{id = RId, name = Name, power = Power, hurt = Hurt, sex = Sex, career = Career, turn = Turn, pic = Pic} <- HurtList],
    {ok, BinData} = pt_603:write(60306, [BossHp, Rank, MyHurt, KillerId, FormatList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({gm_start, Time}, State) ->
    clear_old_state(State),
    % {time, TimeRanges} = lib_custom_act_util:keyfind_act_condition(Type, SubType, time),
    NowTime = utime:unixtime(),
    if 
        Time > 0 ->
            NowSeconds = NowTime - utime:unixdate(),
            OpenRange = [{NowSeconds, min(NowSeconds + Time, ?ONE_DAY_SECONDS)}],
            ETime = utime:unixdate() + ?ONE_DAY_SECONDS,
            FullRanges = calc_full_stage_range(OpenRange, 0, []),
            ActInfo = #act_info{key = {?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, 1}, stime = NowTime, etime = ETime, wlv = 99},
            NewState = setup_current_stage(#state{daily_open_time_ranges = FullRanges, enter_lv = 1, stime = NowTime, etime =  ETime, act_info = ActInfo}, NowTime),
            brocast_stage_info(NewState);
        true ->
            case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK) of
                [#act_info{key = {Type, SubType}, stime = Stime1, etime = Etime1} = ActInfo|_] ->
                    clear_old_state(State),
                    NewState = init_act(Type, SubType, #state{stime = Stime1, etime = Etime1, act_info = ActInfo}, NowTime);
                _ ->
                    NewState = #state{}
            end
    end,
    {noreply, NewState};

do_handle_cast({act_start, ?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, SubType}, State) ->
    % ?PRINT("act_start ~p~n", [lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, SubType)]),
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, SubType) of
        #act_info{stime = Stime, etime = Etime}  = ActInfo->
            NowTime = utime:unixtime(),
            clear_old_state(State),
            NewState = init_act(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, SubType, #state{stime = Stime, etime = Etime, act_info = ActInfo}, NowTime),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({act_end, ?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK, SubType}, #state{act_info = #act_info{key = {_, SubType}}} = State) ->
    % ?PRINT("act_end ~p~n", [lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType)]),
    clear_old_state(State),
    {noreply, #state{}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({timeout, Ref, timer_check}, #state{timer_ref = Ref} = State) ->
    NowTime = utime:unixtime(),
    #state{stime = Stime, etime = Etime} = State,
    if
        Stime =< NowTime andalso NowTime < Etime ->
            NewState = setup_current_stage(State, NowTime),
            brocast_stage_info(NewState),
            {noreply, NewState};
        true ->
            case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_EUDEMONS_ATTACK) of
                [#act_info{key = {Type, SubType}, stime = Stime1, etime = Etime1} = ActInfo|_] ->
                    clear_old_state(State),
                    NewState = init_act(Type, SubType, #state{stime = Stime1, etime = Etime1, act_info = ActInfo}, NowTime),
                    {noreply, NewState};
                _ ->
                    {noreply, #state{}}
            end
    end;

do_handle_info({notify_start, StageETime}, State) ->
    case State of
        #state{stage_etime = StageETime, enter_lv = Lv} ->
            lib_chat:send_TV({all}, ?MOD_EUDEMONS_ATTACK, 1, [Lv]);
        _ ->
            ok
    end,
    {noreply, State};

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal
clear_old_state(State) when is_record(State, state) ->
    util:cancel_timer(State#state.timer_ref),
    todo;

clear_old_state(_) -> ok.

init_act(Type, SubType, State, NowTime) ->
    {time, TimeRanges} = lib_custom_act_util:keyfind_act_condition(Type, SubType, time),
    {lv, EnterLv} = lib_custom_act_util:keyfind_act_condition(Type, SubType, lv),
    OpenRange = [{H1 * 3600 + M1 * 60, H2 * 3600 + M2 * 60} || {{H1,M1},{H2,M2}} <- TimeRanges],
    FullRanges = calc_full_stage_range(OpenRange, 0, []),
    setup_current_stage(State#state{daily_open_time_ranges = FullRanges, enter_lv = EnterLv}, NowTime).

setup_current_stage(State, NowTime) ->
    #state{daily_open_time_ranges = FullRanges, cur_stage = OldStage, etime = ActEndTime, act_info = #act_info{key = {_, ActId}}, enter_lv = Lv} = State,
    {CurStage, StageSTime, StageETime} = get_stage_info(FullRanges, NowTime, ActEndTime),
    Delay = max(1, StageETime - NowTime) * 1000,
    Ref = erlang:start_timer(Delay + 1, self(), timer_check),
    NewState = State#state{stage_etime = StageETime, stage_stime = StageSTime, cur_stage = CurStage, timer_ref = Ref},
    if
        OldStage =/= CurStage ->
            if
                CurStage =:= ?STAGE_OPEN ->
                    if
                        NowTime - StageSTime > 120 -> %% 开始时间和当前时间相差超过2分钟，则去日志里面读取已经完成的记录
                            {RoleList, RoomList} = load(StageSTime, StageETime, ActId),
                            RoomId 
                            = case [I || #room{id = I} <- RoomList] of
                                [] ->
                                    1;
                                List ->
                                    lists:max(List) + 1
                            end;
                        true ->
                            RoleList = [], RoomList = [], RoomId = 1
                    end,
                    lib_chat:send_TV({all}, ?MOD_EUDEMONS_ATTACK, 2, [Lv]),
                    NewState#state{role_list = RoleList, rooms = RoomList, room_auto_id = RoomId};
                CurStage =:= ?STAGE_IDLE ->
                    if 
                        Delay > ?BEFORE_NOTIFY_TIME ->
                            erlang:send_after(Delay - ?BEFORE_NOTIFY_TIME, self(), {notify_start, StageETime});
                        true ->
                            ok
                    end,
                    NewState;
                true ->
                    NewState
            end;
        true ->
            NewState
    end.

calc_full_stage_range([{S, E}|T], S, Acc) ->
    calc_full_stage_range(T, E, [{?STAGE_OPEN, S, E}|Acc]);

calc_full_stage_range([{S, E}|T], ES, Acc) ->
    calc_full_stage_range(T, E, [{?STAGE_OPEN, S, E},{?STAGE_IDLE, ES, S}|Acc]);

calc_full_stage_range([], ES, Acc) when ES < ?ONE_DAY_SECONDS -> 
    lists:reverse([{?STAGE_IDLE, ES, ?ONE_DAY_SECONDS}|Acc]);
calc_full_stage_range([], _, Acc) -> 
    lists:reverse(Acc).

select_a_room([#room{num = Num, max_num = Max, is_end = ?END_NO} = R|_], NewId, _, _) when Num < Max ->
    {NewId, R};
select_a_room([_|T], NewId, EndTime, ActInfo) ->
    select_a_room(T, NewId, EndTime, ActInfo);
select_a_room([], NewId, EndTime, ActInfo) ->
    Pid = mod_battle_field:start(lib_eudemons_attack_field, [NewId, EndTime + 10, ActInfo]),
    SceneId = data_eudemons_act:get_kv(?KV_SCENE),
    MaxNum
    = case data_scene_other:get(SceneId) of
        #ets_scene_other{room_max_people = Max} ->
            Max;
        _ ->
            ?MAX_ROOM_NUM
    end,
    {NewId + 1, #room{id = NewId, pid = Pid, is_end = ?END_NO, num = 0, max_num = MaxNum}}.

brocast_stage_info(#state{cur_stage = Stage, stage_etime = StageETime, enter_lv = EnterLv}) ->
    {ok, BinData} = pt_603:write(60301, [Stage, StageETime, 0]),
    lib_server_send:send_to_all(all_lv, {EnterLv, 65535}, BinData).

get_stage_info(StageRangeList, CheckTime, ActEndTime) ->
    ZeroTime = utime:unixdate(),
    Seconds = CheckTime - ZeroTime,
    case ulists:find(fun
        ({_, S, E}) ->
            S =< Seconds andalso Seconds < E
    end, StageRangeList) of
        {ok, {Stage, Stime, ETime}} when ETime + ZeroTime < ActEndTime ->
            if
                ETime =/= ?ONE_DAY_SECONDS -> %% 到了一天循环的尽头
                    {Stage, Stime + ZeroTime, ETime + ZeroTime};
                true ->
                    case lists:keyfind(0, 2, StageRangeList) of
                        {Stage, 0, NextETime} ->
                            {Stage, Stime + ZeroTime, ?ONE_DAY_SECONDS + NextETime + ZeroTime};
                        _ ->
                            {Stage, Stime + ZeroTime, ETime + ZeroTime}
                    end
            end;
        _ ->
            {?STAGE_CLOSED, 0, ZeroTime + ?ONE_DAY_SECONDS}
    end.

load(StageSTime, StageETime, ActId) ->
    SQL = io_lib:format("SELECT `role_id`, `room_id` FROM `log_eudemons_attack` WHERE `act_id` = ~p AND ~p <= `time` AND `time` < ~p", [ActId, StageSTime, StageETime]),
    All = db:get_all(SQL),
    RoleList = [#state_role{id = RoleId, room_id = RoomId, finished = true} || [RoleId, RoomId] <- All],
    RoomList = lists:foldl(fun
        (#state_role{room_id = RoomId}, Acc) ->
            case lists:keyfind(RoomId, #room.id, Acc) of
                #room{num = Num} = R ->
                    lists:keystore(RoomId, #room.id, Acc, R#room{num = Num + 1});
                _ ->
                    [#room{id = RoomId, num = 1, is_end = ?END_YES}|Acc]
            end
    end, [], RoleList),
    {RoleList, RoomList}.
