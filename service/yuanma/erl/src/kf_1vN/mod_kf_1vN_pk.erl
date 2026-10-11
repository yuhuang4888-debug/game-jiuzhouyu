%%%-----------------------------------
%%% @Module  : mod_kf_1vN_pk
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN pk管理进程
%%%-----------------------------------
-module(mod_kf_1vN_pk).

-include("common.hrl").
-include("kf_1vN.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("scene.hrl").
-include("career.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("jjc.hrl").
-include("mount.hrl").

%% API
-export([start_link/1, get_watch_info/3]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

-record(state, {
        stage = 0,
        area = 0,
        battle_id = 0,
        side_a = undefined, %% #kf_1vN_role_pk{}
        side_b_list = [], %% [#kf_1vN_role_pk{},...]
        battle_time = 0,
        loading_time = 0,
        is_end = 0,
        scene_id=0,
        scene_pool_id=0,
        match_turn = 0,
        start_time = 0,
        optime=0,
        ref = undefined,
        max_power = 10000000
    }).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

get_watch_info(ServerId, Id, CopyId) ->
    gen_server:cast(CopyId, {get_watch_info, ServerId, Id}).

init([SideA, SideBList, BattleTime, Stage, MatchTurn, BattleId, ScenePoolId, MaxPower]) ->
    Now = utime:unixtime(),
    LoadingTime = data_kf_1vN_m:get_config(loading_time),
    erlang:send_after(LoadingTime*1000+50, self(), start),

    %% 传入战场
    case Stage of
        ?KF_1VN_RACE_1 ->
            [{SideAX, SideAY}, BXYs|_] = data_kf_1vN:get_value(?KF_1VN_CFG_RACE_1_XY),
            SideBXYs = [BXYs],
            SceneId = data_kf_1vN_m:get_config(race_1_scene);
        _ ->
            {SideAX, SideAY} = data_kf_1vN:get_value(?KF_1VN_CFG_DEF_XY),
            SideBXYs = data_kf_1vN:get_value(?KF_1VN_CFG_CHALLENGER_XY),
            SceneId = data_kf_1vN_m:get_config(race_2_scene)
    end,
    ExtArgs
    = if
          % Stage =:= ?KF_1VN_RACE_2 -> [{passive_skill, {21000003, 1}}]; %% 加一个免控buff
          true -> []
      end,
    mod_clusters_center:apply_cast(SideA#kf_1vN_role_pk.server_id, lib_scene, player_change_scene, [SideA#kf_1vN_role_pk.id, SceneId, ScenePoolId, self(), SideAX, SideAY, false, [{group,1}|ExtArgs]]),
    InitSideBList = send_side_b(SideBList, SideBXYs, SideA#kf_1vN_role_pk.lv, SceneId, ScenePoolId, self(), LoadingTime, []),

    case Stage of
        ?KF_1VN_RACE_2 ->
            SendL = [{E#kf_1vN_role_pk.id, E#kf_1vN_role_pk.platform, E#kf_1vN_role_pk.server_num, E#kf_1vN_role_pk.server_name, E#kf_1vN_role_pk.name, E#kf_1vN_role_pk.career, E#kf_1vN_role_pk.turn, E#kf_1vN_role_pk.sex, E#kf_1vN_role_pk.picture, E#kf_1vN_role_pk.picture_ver, E#kf_1vN_role_pk.lv, E#kf_1vN_role_pk.combat_power} || E <- InitSideBList],
            {ok, BinData} = pt_621:write(62112, [
                    SideA#kf_1vN_role_pk.id, SideA#kf_1vN_role_pk.platform, SideA#kf_1vN_role_pk.server_num, SideA#kf_1vN_role_pk.server_name, SideA#kf_1vN_role_pk.name, SideA#kf_1vN_role_pk.career,
                    SideA#kf_1vN_role_pk.combat_power, SideA#kf_1vN_role_pk.win, SideA#kf_1vN_role_pk.race_1_times - SideA#kf_1vN_role_pk.win, SideA#kf_1vN_role_pk.sex, SideA#kf_1vN_role_pk.picture, SideA#kf_1vN_role_pk.picture_ver, SideA#kf_1vN_role_pk.lv,
                    SendL, Now+LoadingTime, Now+LoadingTime+BattleTime
                ]),

            [mod_clusters_center:apply_cast(E2#kf_1vN_role_pk.server_id, lib_server_send, send_to_uid, [E2#kf_1vN_role_pk.id, BinData]) || E2 <- [SideA|InitSideBList], E2#kf_1vN_role_pk.type == ?KF_1VN_C_TYPE_PLAYER];
        ?KF_1VN_RACE_1 ->
            [SideB|_] = InitSideBList,
            {ok, BinData} = pt_621:write(62105, [
                [
                    mod_kf_1vN:to_62105_battle(SideA),
                    mod_kf_1vN:to_62105_battle(SideB)
                ],
                Now+LoadingTime, Now+LoadingTime+BattleTime
            ]),
            [mod_clusters_center:apply_cast(E2#kf_1vN_role_pk.server_id, lib_server_send, send_to_uid, [E2#kf_1vN_role_pk.id, BinData]) || E2 <- [SideA|InitSideBList], E2#kf_1vN_role_pk.type == ?KF_1VN_C_TYPE_PLAYER];
        _ -> skip
    end,

    {ok, #state{stage=Stage, battle_id=BattleId, optime=Now, scene_id=SceneId, scene_pool_id=ScenePoolId, area=SideA#kf_1vN_role_pk.area, side_a=SideA, side_b_list=InitSideBList, battle_time=BattleTime, match_turn=MatchTurn, loading_time = LoadingTime, max_power = MaxPower}}.


handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {noreply, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("Handle call[~p] error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call(_Request, _State) ->
    ?ERR("do_handle_call unkown request[~p]~n", [_Request]),
    {ok, ok}.


handle_cast({get_watch_info, ServerId, Id}, State) ->
    BinData = pack_race_2_info(State),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]),
    {noreply, State};

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle cast[~p] error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast(_Msg, State) ->
    ?ERR("do_handle_cast unkown msg[~p]~n", [_Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, Reason, NewState} ->
            {stop, Reason, NewState};
        Err ->
            ?ERR("Handle info[~p] error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(start, State) ->
    #state{battle_time=BattleTime} = State,

    Ref = erlang:send_after(BattleTime*1000+50, self(), timeout),
    {noreply, State#state{ref=Ref, start_time=utime:unixtime()}};

do_handle_info({quit, Node, Id, ScenePoolId, QuitType, Hp, HpLim}, #state{stage=Stage, scene_id=SceneId, scene_pool_id=PkScenePoolId, side_a=SideA, side_b_list=SideBList, is_end=IsEnd} = State0) ->
    State = set_player_quit(Id, State0),
%%    ?PRINT("is_end ~w~n", [IsEnd]),
    if
        QuitType == 1 ->
            ReadyScene = data_kf_1vN_m:get_config(race_1_pre_scene),
            {PreX, PreY} = lib_kf_1vN:pre_scene_xy(),
            mod_clusters_center:apply_cast(Node, lib_scene, player_change_scene, [Id, ReadyScene, ScenePoolId, 0, PreX, PreY, false, [{group,0}, {change_scene_hp_lim,1}]]);
        true ->
            lib_kf_1vN:quit_to_main_scene(Node, Id)
    end ,
    case IsEnd of
        1 ->
            {noreply, State};
        _ ->
            Args = #{{hp,Id}=>{Hp,HpLim}},
            case Stage of
                ?KF_1VN_RACE_1 ->
                    #kf_1vN_role_pk{id=IdA} = SideA,
                    [#kf_1vN_role_pk{id=IdB}|_] = SideBList,
                    case Id == IdA of
                        true -> OtherId = IdB;
                        false -> OtherId = IdA
                    end,
                    case mod_scene_agent:apply_call(SceneId, PkScenePoolId, lib_scene_agent, get_user, [OtherId]) of
                        #ets_scene_user{battle_attr=#battle_attr{hp=OtherHp, hp_lim=OtherHpLim}} -> NewArgs = Args#{{hp,OtherId}=>{OtherHp,OtherHpLim}};
                        _ -> NewArgs = Args
                    end;
                ?KF_1VN_RACE_2 ->
                    #kf_1vN_role_pk{id=IdA} = SideA,
                    NewArgs =
                    case Id == IdA of
                        true -> Args;
                        false ->
                            case mod_scene_agent:apply_call(SceneId, PkScenePoolId, lib_scene_agent, get_user, [IdA]) of
                                #ets_scene_user{battle_attr=#battle_attr{hp=HpA, hp_lim=HpLimA}} -> Args#{{hp,IdA}=>{HpA,HpLimA}};
                                _ -> Args
                            end
                    end;
                _ ->
                    NewArgs = Args
            end,
            case pk_result(State, ?KF_1VN_C_TYPE_PLAYER, Id, 0, 3, NewArgs) of
                false -> {noreply, State};
                {false, NewSideBList} -> {noreply, State#state{side_b_list=NewSideBList}};
                true ->
                    util:cancel_timer(State#state.ref),
                    self() ! {battle_end, 3}, %% 直接退出
                    {noreply, State#state{is_end=1, ref = undefined}}
            end
    end;

do_handle_info({player_die, DieId}, State) ->
    #state{ref=Ref, scene_id=SceneId, scene_pool_id=ScenePoolId, stage=Stage, side_a=SideA, side_b_list=SideBList, is_end = IsEnd} = State,
    if
        IsEnd == 0 ->
%%            ?PRINT("player_die ~w~n", [DieId]),
            case Stage of
                ?KF_1VN_RACE_1 ->
                    #kf_1vN_role_pk{id=IdA} = SideA,
                    [#kf_1vN_role_pk{id=IdB}|_] = SideBList,
                    case DieId == IdA of
                        true -> OtherId = IdB;
                        false -> OtherId = IdA
                    end,
                    case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [OtherId]) of
                        #ets_scene_user{battle_attr=#battle_attr{hp=OtherHp, hp_lim=OtherHpLim}} -> Args = #{{hp,OtherId}=>{OtherHp,OtherHpLim}};
                        _ -> Args = #{}
                    end;
                ?KF_1VN_RACE_2 ->
                    #kf_1vN_role_pk{id=IdA} = SideA,
                    case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [IdA]) of
                        #ets_scene_user{battle_attr=#battle_attr{hp=HpA, hp_lim=HpLimA}} -> Args = #{{hp,IdA}=>{HpA,HpLimA}};
                        _ -> Args = #{}
                    end;
                _ ->
                    Args = #{}
            end,
            case pk_result(State, ?KF_1VN_C_TYPE_PLAYER, DieId, 0, 1, Args) of
                false -> {noreply, State};
                {false, NewSideBList} -> {noreply, State#state{side_b_list=NewSideBList}};
                true ->
                    util:cancel_timer(Ref),
                    erlang:send_after(5000, self(), {battle_end, 1}),
                    {noreply, State#state{is_end=1}}
            end;
        true ->
            {noreply, State}
    end;

do_handle_info({dummy_die, DieId}, State) ->
    #state{ref=Ref, scene_id=SceneId, scene_pool_id=ScenePoolId, side_a=SideA, is_end = IsEnd} = State,
    if
        IsEnd == 0 ->
%%            ?PRINT("dummy_die ~w~n", [DieId]),
            #kf_1vN_role_pk{id=IdA} = SideA,
            case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [IdA]) of
                #ets_scene_user{battle_attr=#battle_attr{hp=HpA, hp_lim=HpLimA}} -> Args = #{{hp,IdA}=>{HpA,HpLimA}};
                _ -> Args = #{}
            end,
            case pk_result(State, ?KF_1VN_C_TYPE_ROBOT, DieId, 0, 1, Args) of
                false -> {noreply, State};
                {false, SideBList} -> {noreply, State#state{side_b_list=SideBList}};
                true ->
                    util:cancel_timer(Ref),
                    erlang:send_after(5000, self(), {battle_end, 1}),
                    {noreply, State#state{is_end=1}}
            end;
        true ->
            {noreply, State}
    end;

do_handle_info(timeout, State) ->
%%    ?PRINT("Battle end ~p~n", [timeout]),
    #state{stage=Stage, scene_id=SceneId, scene_pool_id=ScenePoolId, side_a=SideA, side_b_list=SideBList, ref=Ref} = State,
    util:cancel_timer(Ref),

    case Stage of
        ?KF_1VN_RACE_1 ->
            #kf_1vN_role_pk{id=IdA, combat_power=CPA} = SideA,
            HpLeftRA = case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [IdA]) of
                #ets_scene_user{battle_attr=#battle_attr{hp=HpA, hp_lim=HpLimA}} -> HpA/max(1, HpLimA);
                _ -> HpA=0, HpLimA=0, 0
            end,
            [#kf_1vN_role_pk{id=IdB, type=TypeB, combat_power=CPB}|_] = SideBList,
            HpLeftRB = if
                TypeB == ?KF_1VN_C_TYPE_ROBOT ->
                    case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_object, [IdB]) of
                        #scene_object{battle_attr=#battle_attr{hp=HpB, hp_lim=HpLimB}} -> HpB/max(1, HpLimB);
                        _ -> HpB=0, HpLimB=0, 0
                    end;
                true ->
                    case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [IdB]) of
                        #ets_scene_user{battle_attr=#battle_attr{hp=HpB, hp_lim=HpLimB}} -> HpB/max(1, HpLimB);
                        _ -> HpB=0, HpLimB=0, 0
                    end
            end,

            DieId = if
                HpLeftRA > HpLeftRB -> IdB;
                HpLeftRA == HpLeftRB andalso CPA > CPB -> IdB;
                true -> IdA
            end,
            Args = #{{hp,IdA}=>{HpA,HpLimA}, {hp,IdB}=>{HpB,HpLimB}},
            case pk_result(State, ?KF_1VN_C_TYPE_PLAYER, DieId, 0, 2, Args) of
                false -> {noreply, State};
                {false, NewSideBList} -> {noreply, State#state{side_b_list=NewSideBList}};
                true ->
                    erlang:send_after(5000, self(), {battle_end, 1}),
                    {noreply, State#state{is_end=1}}
            end;
         ?KF_1VN_RACE_2 ->
            #kf_1vN_role_pk{id=IdA} = SideA,
            WinType = case mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_agent, get_user, [IdA]) of
                #ets_scene_user{battle_attr=#battle_attr{hp=HpA, hp_lim=HpLimA}} -> 1; %% 擂主还在场景中，直接胜利
                _ -> HpA=0, HpLimA=0, 2 %% 擂主不在场景中，直接失败
            end,
            Args = #{{hp,IdA}=>{HpA, HpLimA}},
            case pk_result(State, 0, 0, WinType, 2, Args) of
                false -> {noreply, State};
                {false, NewSideBList} -> {noreply, State#state{side_b_list=NewSideBList}};
                true ->
                    erlang:send_after(5000, self(), {battle_end, 1}),
                    {noreply, State#state{is_end=1}}
            end;
         _ ->
            erlang:send_after(5000, self(), {battle_end, 1}),
            {noreply, State#state{is_end=1}}
     end;

do_handle_info({battle_end, _EndType}, State) ->
%%    ?PRINT("Battle end ~p~n", [EndType]),
    #state{scene_id=SceneId, scene_pool_id=ScenePoolId, side_a=SideA, side_b_list=SideBList, ref=Ref} = State,
    util:cancel_timer(Ref),
    ReadyScene = data_kf_1vN_m:get_config(race_1_pre_scene),
    Now = utime:unixtime(),

    %% 传出战场
    F = fun(#kf_1vN_role_pk{type=Type, area=Area, server_id=SerId, id=Id, scene_pool_id=RolePoolId, is_quit = IsQuit}) ->
            case Type of
                ?KF_1VN_C_TYPE_PLAYER ->
                    if
                        IsQuit =/= true ->
                            {PreX, PreY} = lib_kf_1vN:pre_scene_xy(),
                            mod_clusters_center:apply_cast(SerId, lib_scene, player_change_scene, [Id, ReadyScene, RolePoolId, 0, PreX, PreY, false, [{group,0}, {change_scene_hp_lim,1},{delete_passive_skill, {21000003,1}}]]);
                        true ->
                            ok
                    end,
                    mod_kf_1vN:update_role(Area, Id, [{pk, 0}, {pk_time, Now}]),
                    mod_kf_1vN:exit_pk(Area, Id);
                _ ->
                    skip
            end
    end,
    lists:map(F, [SideA|SideBList]),
    lib_scene:clear_scene_room(SceneId, ScenePoolId, self()),

    {stop, normal, State};

do_handle_info({get_race_1_info, Node, Id}, #state{stage = ?KF_1VN_RACE_1} = State) ->
    #state{optime = Now, battle_time = BattleTime, side_a = SideA, side_b_list = [SideB|_], loading_time = LoadingTime} = State,
    {ok, BinData} = pt_621:write(62105, [
        [
            mod_kf_1vN:to_62105_battle(SideA),
            mod_kf_1vN:to_62105_battle(SideB)
        ],
        Now+LoadingTime, Now+LoadingTime+BattleTime
    ]),
    lib_server_send:send_to_uid(Node, Id, BinData),
    {noreply, State};

do_handle_info({get_race_2_info, Node, Id}, #state{stage = ?KF_1VN_RACE_2} = State) ->
    BinData = pack_race_2_info(State),
    lib_server_send:send_to_uid(Node, Id, BinData),
    {noreply, State};


do_handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~p]~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 处理B方的数据
send_side_b([#kf_1vN_role_pk{type=?KF_1VN_C_TYPE_ROBOT, area=Area, server_num=_SerNum, career=Career, attr=MonAttr, name=Name, sex = Sex}=H|T], [{Bx, By}|Txy], SideALv, SceneId, ScenePoolId, Room, LoadingTime, Result) ->
    EnterLv = data_kf_1vN:get_value(?KF_1VN_CFG_ENTER_LV),
    Lv = case Area of
        1 -> urand:rand(EnterLv,SideALv);
        _ ->
            MinLv = max(SideALv - 10, EnterLv),
            urand:rand(MinLv,SideALv)
    end,
    case data_jjc:get_jjc_value(?JJC_MAX_RANK) of
        [] -> Rank = 0;
        [MaxRank] -> Rank = urand:rand(1, MaxRank)
    end,
    % figure
    case data_jjc:get_jjc_robot(Rank) of
        [] -> Robot = #base_jjc_robot{};
        Robot -> ok
    end,
    #base_jjc_robot{rmount = RMount, rmate = RMate, rpet = RPet, rfly = RFly, rholyorgan = RHolyorgan} = Robot,
    MountKv = ?IF(RMount == [], [], [{?MOUNT_ID, urand:list_rand(RMount), 0}]),
    MateKv = ?IF(RMate == [], [], [{?MATE_ID, urand:list_rand(RMate), 0}]),
    PetKv = ?IF(RPet == [], [], [{?PET_ID, urand:list_rand(RPet), 0}]),
    FlyKv = ?IF(RFly == [], [], [{?FLY_ID, urand:list_rand(RFly), 0}]),
    HolyorganKv = case lists:keyfind(Career, 1, RHolyorgan) of
        {_, HolyorganL} when HolyorganL =/= [] -> [{?HOLYORGAN_ID, urand:list_rand(HolyorganL), 0}];
        _ -> []
    end,
    MountFigure = MountKv ++ MateKv ++ PetKv ++ FlyKv ++ HolyorganKv,
    Turn = 3,
    % Skill = data_skill:get_ids(Career, Sex),
    % Skill = [ {SkillId, 1} || SkillId <- lib_skill_api:get_career_skill_active_ids(Career, Sex, Turn) ],
    Skill = lib_skill_api:get_career_active_skill_default_lv_list(Career, Sex),
    Figure = #figure{name=Name, lv=Lv, career=Career, sex=Sex, lv_model=lib_player:get_model_list(Career, Sex, Turn, Lv), mount_figure = MountFigure, vip = 3},
    DieHandler = {lib_kf_1vN, dummy_die, []},
    Args = [{skill, Skill}, {group, 2}, {find_target, LoadingTime*1000+500},{die_handler, DieHandler},{warning_range, 3000}],
    BattleAttr = #battle_attr{hp=MonAttr#attr.hp, hp_lim=MonAttr#attr.hp, speed=?SPEED_VALUE, battle_speed=?SPEED_VALUE, attr=MonAttr#attr{speed=?SPEED_VALUE}},
    DummyId = lib_scene_object:sync_create_a_dummy(SceneId, ScenePoolId, Bx, By, Room, 1, Figure, BattleAttr, Args),
    send_side_b(T, Txy, SideALv, SceneId, ScenePoolId, Room, LoadingTime, [H#kf_1vN_role_pk{id=DummyId} |Result]);
send_side_b([#kf_1vN_role_pk{type=?KF_1VN_C_TYPE_PLAYER, id=Id, server_id=ServerId, is_dead=0}=H|T], [{Bx, By}|Txy], SideALv, SceneId, ScenePoolId, Room, LoadingTime, Result) ->
    mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [Id, SceneId, ScenePoolId, Room, Bx, By, false, [{group, 2}]]),
    send_side_b(T, Txy, SideALv, SceneId, ScenePoolId, Room, LoadingTime, [H |Result]);
send_side_b([H|T], Txy, SideALv, SceneId, ScenePoolId, Room, LoadingTime, Result) ->
    %mod_clusters_center:apply_cast(ServerId, lib_scene, player_change_scene, [Id, SceneId, ScenePoolId, Room, Bx, By, false, [{group, 2}]]),
    send_side_b(T, Txy, SideALv, SceneId, ScenePoolId, Room, LoadingTime, [H |Result]);
send_side_b([], _, _, _, _, _, _, Result) -> Result.

%%1.找到报名玩家中的历史最高战力作为最高战力，不管玩家是否有进场参赛
%%2.每场获胜方积分=（自己实际战力+对方实际战力）/最高战力*160
%%3.每场失败方积分=（自己实际战力+对方实际战力）/最高战力*100
%%4.每场积分四舍五入取整
calc_score(WinCP, LoseCP, _MaxPower) ->
%%    WinScore  = round(80 + math:sqrt(WinCP)*0.05+math:sqrt(LoseCP)*0.025),
%%    LoseScore = round(30 + math:sqrt(LoseCP)*0.02+math:sqrt(WinCP)*0.001),
    % WinScore = round((WinCP + LoseCP)/MaxPower*160) + 100,
    % LoseScore = round((WinCP + LoseCP)/MaxPower*100) + 100,
    WinScore = round(80 + math:sqrt(WinCP)*0.02 + math:sqrt(LoseCP) * 0.01),
    LoseScore = round(30 + math:sqrt(LoseCP)*0.005 + math:sqrt(WinCP)*0.0025),
    {WinScore, LoseScore}.

%% WinType: 0需判定 1擂主直接胜利 2擂主直接失败
%% EndType: 1击杀 2超时 3投降
%% Args #{{hp, Id}=>{Hp, HpLim}}
pk_result(State, Type, Id, WinType, EndType, Args) ->
    #state{battle_id=BattleId, stage=Stage, area=Area, side_a=SideA, side_b_list=SideBList, match_turn=MatchTurn, start_time=StartTime, max_power = _MaxPower} = State,
    #kf_1vN_role_pk{server_id=SerIdA, platform=PlatformA, server_num=SerNumA, area=AreaA, id=IdA, name=NameA, win=WinA, win_streak=WinStreakA, lose_streak=LoseStreakA,
        career=CareerA, sex=SexA, picture=PictureA, picture_ver=PictureVerA, lv=LvA, combat_power=CPA, score=ScoreA, race_1_times=Race1TimesA} = SideA, %% 擂主或者资格赛的A方

    case Stage of
        ?KF_1VN_RACE_1 ->
            Race1MaxTimes = data_kf_1vN_m:get_config(race_1_max_times),
            [#kf_1vN_role_pk{server_id=SerIdB, server_num=SerNumB, area=AreaB, id=IdB, win=WinB, win_streak=WinStreakB, lose_streak=LoseStreakB,
                name=NameB, combat_power=CPB, score=ScoreB, race_1_times=Race1TimesB, type=TypeB}=SideB|_] = SideBList,

            case Id of
                IdA -> % A输B赢
                    IsWinA = 0, IsWinB = 1,
                    {ScoreAddB, ScoreAddA} = calc_score(CPB, CPA, max(CPA, CPB)),
                    WinAN = WinA, WinBN = WinB+1,
                    WinStreakAN = 0, WinStreakBN = WinStreakB+1,
                    LoseStreakAN = LoseStreakA+1, LoseStreakBN = 0;
                _ -> % A赢B输
                    IsWinA = 1, IsWinB = 0,
                    {ScoreAddA, ScoreAddB} = calc_score(CPA, CPB, max(CPA, CPB)),
                    WinAN = WinA+1, WinBN = WinB,
                    WinStreakAN = WinStreakA+1, WinStreakBN = 0,
                    LoseStreakAN = 0, LoseStreakBN = LoseStreakB+1
            end,
            if
                WinStreakAN == 6 ->
                    TvBin = lib_chat:make_tv(?MOD_KF_1VN, 7, [NameA, WinStreakAN]),
                    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, send_area_msg, [Area, TvBin], 50);
                WinStreakBN == 6 andalso TypeB == ?KF_1VN_C_TYPE_PLAYER ->
                    TvBin = lib_chat:make_tv(?MOD_KF_1VN, 7, [NameB, WinStreakBN]),
                    mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, send_area_msg, [Area, TvBin], 50);
                true -> skip
            end,
            F = fun(TmpPk) ->
                #kf_1vN_role_pk{
                    id=TmpId, platform=TmpPlatform, server_num=TmpServerNum, name=TmpName, career=TmpCareer, sex=TmpSex,
                    picture=TmpPicture, picture_ver=TmpPictureVer, lv=TmpLv
                    } = TmpPk,
                {TmpHp, TmpHpLim} = maps:get({hp,TmpId}, Args, {0, 0}),
                {TmpId, TmpPlatform, TmpServerNum, TmpName, TmpCareer, TmpSex, TmpPicture, TmpPictureVer, TmpLv, TmpHp, TmpHpLim}
            end,
            BattleList = lists:map(F, [SideA, SideB]),
            IsTimeout = ?IF(EndType==2, 1, 0),
            {ok, BinDataA} = pt_621:write(62108, [IsWinA, ScoreA, ScoreAddA, max(0, Race1MaxTimes-Race1TimesA), IsTimeout, BattleList]),
            mod_clusters_center:apply_cast(SerIdA, lib_server_send, send_to_uid, [IdA, BinDataA]),
            {ok, BinDataB} = pt_621:write(62108, [IsWinB, ScoreB, ScoreAddB, max(0, Race1MaxTimes-Race1TimesB), IsTimeout, BattleList]),
            % 真实玩家才通知
            case TypeB == ?KF_1VN_C_TYPE_PLAYER of
                true -> mod_clusters_center:apply_cast(SerIdB, lib_server_send, send_to_uid, [IdB, BinDataB]);
                false -> skip
            end,

            mod_kf_1vN:update_role(AreaA, IdA, [{win, WinAN}, {win_streak, WinStreakAN}, {lose_streak, LoseStreakAN}, {score, ScoreA+ScoreAddA}, {race_1_times, Race1TimesA+1}]),
            mod_kf_1vN:update_role(AreaB, IdB, [{win, WinBN}, {win_streak, WinStreakBN}, {lose_streak, LoseStreakBN}, {score, ScoreB+ScoreAddB}, {race_1_times, Race1TimesB+1}]),
            case IsWinA of
                1 -> lib_log_api:log_kf_1vn_race_1(Area, IdA, SerIdA, SerNumA, NameA, CPA, ScoreAddA, IdB, SerIdB, SerNumB, NameB, CPB, ScoreAddB, EndType);
                _ -> lib_log_api:log_kf_1vn_race_1(Area, IdB, SerIdB, SerNumB, NameB, CPB, ScoreAddB, IdA, SerIdA, SerNumA, NameA, CPA, ScoreAddA, EndType)
            end,
            stop_battle(State),
            true;
        ?KF_1VN_RACE_2 ->
            ChallengerNum = length(SideBList),
            ChallengerLiveNum = length([1 || E <- SideBList, E#kf_1vN_role_pk.is_dead==0]),
            if
                WinType == 2 orelse Id == IdA -> %% 擂主失败
                    case data_kf_1vN:get_race_2_award(?SIDE_DEF, MatchTurn) of
                        {_, DefLoseRewards} -> skip;
                        _ -> DefLoseRewards = []
                    end,
                    {HpA, HpLimA} =  maps:get({hp,IdA}, Args, {0, 0}),
                    {ok, BinDataA} = pt_621:write(62113, [0, ChallengerLiveNum, ChallengerNum, IdA, PlatformA, SerNumA, NameA, CareerA, SexA, PictureA, PictureVerA, LvA, 0, HpLimA, DefLoseRewards]),
                    mod_clusters_center:apply_cast(SerIdA, lib_server_send, send_to_uid, [IdA, BinDataA]),
                    % DefProduce = #produce{type=kf_1vn_race_2, show_tips=1, reward=DefLoseRewards, title = utext:get(203), content = utext:get(204)},
                    % mod_clusters_center:apply_cast(SerIdA, lib_goods_api, send_reward_with_mail, [IdA, DefProduce]),
                    mod_clusters_center:apply_cast(SerIdA, lib_mail_api, send_sys_mail, [[IdA], utext:get(6210004, [ChallengerNum]), utext:get(6210006, [ChallengerNum]), DefLoseRewards]),

                    mod_kf_1vN:update_role(Area, IdA, [{race_2_lose, 1}, {race_2_turn, MatchTurn}, {race_2_time, utime:unixtime() - StartTime}, {hp, HpA}, {hp_lim, HpLimA}]),
                    %mod_kf_1vN:def_lose(Area, IdA, CPA),
                    mod_kf_1vN:race_2_pk_result(BattleId, 0, Area, IdA, CPA, 0, HpLimA, ChallengerLiveNum),
                    case data_kf_1vN:get_race_2_award(2, MatchTurn) of
                        {ChallengerWinAward, _} -> skip;
                        _ -> ChallengerWinAward = []
                    end,
                    {ok, BinDataB} = pt_621:write(62113, [1, ChallengerLiveNum, ChallengerNum, IdA, PlatformA, SerNumA, NameA, CareerA, SexA, PictureA, PictureVerA, LvA, 0, HpLimA, ChallengerWinAward]),
                    ChallengerProduce = #produce{type=kf_1vn_race_2, show_tips=1, reward=ChallengerWinAward, title = utext:get(6210007, [ChallengerNum]), content = utext:get(6210008, [ChallengerNum])},
                    lib_log_api:log_kf_1vn_race_2(AreaA, MatchTurn, BattleId, IdA, SerIdA, SerNumA, NameA, CPA, 1, 0, EndType, 1),
                    handle_side_b_result(SideBList, ChallengerProduce, BinDataB, AreaA, BattleId, MatchTurn, 1, EndType),
                    stop_battle(State),
                    true;
                true ->
                    Result = case WinType of
                        1 -> {true, SideBList};
                        _ ->
                            case is_side_b_dead(SideBList, Type, Id, ChallengerLiveNum) of
                                {true, Role} -> {true, lists:keyreplace(Role#kf_1vN_role_pk.id, #kf_1vN_role_pk.id, SideBList, Role)};
                                {false, Role} -> {false, lists:keyreplace(Role#kf_1vN_role_pk.id, #kf_1vN_role_pk.id, SideBList, Role)};
                                false -> false
                            end
                    end,
                    case Result of
                        false -> false;
                        {false, NewSideBList} -> {false, NewSideBList};
                        {true, NewSideBList} ->
                            case data_kf_1vN:get_stage_args(MatchTurn) of
                                #kf_1vN_race_2_match{c_num=CNum} -> ok;
                                _ -> CNum=2
                            end,
                            TvBin = lib_chat:make_tv(?MOD_KF_1VN, 8, [NameA, CNum]),
                            case MatchTurn > 2 of   %% 前两轮只发自己
                                true -> mod_clusters_center:apply_to_all_node(mod_kf_1vN_local, send_area_msg, [Area, TvBin], 50);
                                _ -> mod_clusters_center:apply_cast(SerIdA, lib_server_send, send_to_uid, [IdA, TvBin])
                            end,
                            % 直接判定胜利则取当前存活的挑战者数量,否则就是所有挑战者死亡
                            case WinType of
                                1 -> NewChallengerLiveNum = ChallengerLiveNum;
                                _ -> NewChallengerLiveNum = 0
                            end,
                            case data_kf_1vN:get_race_2_award(?SIDE_DEF, MatchTurn) of
                                {DefWinRewards, _} -> skip;
                                _ -> DefWinRewards = []
                            end,
                            % 保证有数值
                            {HpA, HpLimA} =  maps:get({hp,IdA}, Args, {500, 1000}),
                            {ok, BinDataA} = pt_621:write(62113, [1, NewChallengerLiveNum, ChallengerNum, IdA, PlatformA, SerNumA, NameA, CareerA, SexA, PictureA, PictureVerA, LvA, HpA, HpLimA, DefWinRewards]),
                            mod_clusters_center:apply_cast(SerIdA, lib_server_send, send_to_uid, [IdA, BinDataA]),
                            % DefProduce =  #produce{type=kf_1vn_race_2, show_tips=1, reward=DefWinRewards, title = utext:get(203), content = utext:get(204)},
                            % mod_clusters_center:apply_cast(SerIdA, lib_goods_api, send_reward_with_mail, [IdA, DefProduce]),
                            mod_clusters_center:apply_cast(SerIdA, lib_mail_api, send_sys_mail, [[IdA], utext:get(6210004, [ChallengerNum]), utext:get(6210005, [ChallengerNum]), DefWinRewards]),
                            mod_kf_1vN:update_role(Area, IdA, [{race_2_turn, MatchTurn}, {race_2_time, utime:unixtime() - StartTime}, {hp, HpA}, {hp_lim, HpLimA}]),

                            case data_kf_1vN:get_race_2_award(2, MatchTurn) of
                                {_, ChallengerLoseAward} -> skip;
                                _ -> ChallengerLoseAward = []
                            end,
                            {ok, BinDataB} = pt_621:write(62113, [0, NewChallengerLiveNum, ChallengerNum, IdA, PlatformA, SerNumA, NameA, CareerA, SexA, PictureA, PictureVerA, LvA, HpA, HpLimA, ChallengerLoseAward]),
                            ChallengerProduce = #produce{type=kf_1vn_race_2, show_tips=1, reward=ChallengerLoseAward, title = utext:get(6210009, [ChallengerNum]), content = utext:get(6210010, [ChallengerNum])},
                            lib_log_api:log_kf_1vn_race_2(AreaA, MatchTurn, BattleId, IdA, SerIdA, SerNumA, NameA, CPA, 1, 1, EndType, 0),
                            handle_side_b_result(NewSideBList, ChallengerProduce, BinDataB, AreaA, BattleId, MatchTurn, 0, EndType),

                            mod_kf_1vN:race_2_pk_result(BattleId, 1, Area, IdA, CPA, HpA, HpLimA, NewChallengerLiveNum),
                            stop_battle(State),
                            true
                    end
            end;
        _ -> false
    end.

handle_side_b_result([#kf_1vN_role_pk{type=?KF_1VN_C_TYPE_PLAYER, id=Id, server_id=ServerId, server_num=SerNum, name=Name, combat_power=CP, is_dead=IsDead}|T], Produce, BinData, Area, BattleId, MatchTurn, SidBWin, EndType) ->
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [Id, BinData]),
    % mod_clusters_center:apply_cast(ServerId, lib_goods_api, send_reward_with_mail, [Id, Produce]),
    #produce{title=Title, content=Content, reward=ChallengerReward} = Produce,
    mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[Id], Title, Content, ChallengerReward]),
    lib_log_api:log_kf_1vn_race_2(Area, MatchTurn, BattleId, Id, ServerId, SerNum, Name, CP, 0, SidBWin, EndType, IsDead),
    handle_side_b_result(T, Produce, BinData, Area, BattleId, MatchTurn, SidBWin, EndType);
handle_side_b_result([#kf_1vN_role_pk{name=Name, combat_power=CP, server_num=SerNum, is_dead=IsDead}|T], Produce, BinData, Area, BattleId, MatchTurn, SidBWin, EndType) ->
    lib_log_api:log_kf_1vn_race_2(Area, MatchTurn, BattleId, 0, 0, SerNum, Name, CP, 2, SidBWin, EndType, IsDead),
    handle_side_b_result(T, Produce, BinData, Area, BattleId, MatchTurn, SidBWin, EndType);
handle_side_b_result([], _, _, _, _, _, _, _) -> ok.


is_side_b_dead([#kf_1vN_role_pk{type=Type, id=Id, is_dead=0}=H|_], Type, Id, 1) ->
    {true, H#kf_1vN_role_pk{is_dead=1}};
is_side_b_dead([#kf_1vN_role_pk{type=Type, id=Id, is_dead=0}=H|_], Type, Id, _ChallengerLiveNum) ->
    {false, H#kf_1vN_role_pk{is_dead=1}};
is_side_b_dead([_|T], Type, Id, ChallengerLiveNum) -> is_side_b_dead(T, Type, Id, ChallengerLiveNum);
is_side_b_dead([], _Type, _Id, _ChallengerLiveNum) -> false.

set_player_quit(Id, #state{side_a = #kf_1vN_role_pk{id = Id} = SideA} = State) ->
    State#state{side_a = SideA#kf_1vN_role_pk{is_quit = true}};

set_player_quit(Id, #state{side_b_list = SideBList} = State) ->
    case lists:keyfind(Id, #kf_1vN_role_pk.id, SideBList) of
        #kf_1vN_role_pk{is_quit = false} = R ->
            SideBList1 = lists:keystore(Id, #kf_1vN_role_pk.id, SideBList, R#kf_1vN_role_pk{is_quit = true}),
            State#state{side_b_list = SideBList1};
        _ ->
            State
    end.

pack_race_2_info(State) ->
    #state{side_a=SideA, side_b_list=SideBList, optime=OpTime, battle_time=BattleTime, loading_time = LoadingTime} = State,

    SendL = [{E#kf_1vN_role_pk.id, E#kf_1vN_role_pk.platform, E#kf_1vN_role_pk.server_num, E#kf_1vN_role_pk.server_name, E#kf_1vN_role_pk.name, E#kf_1vN_role_pk.career, E#kf_1vN_role_pk.turn, E#kf_1vN_role_pk.sex, E#kf_1vN_role_pk.picture, E#kf_1vN_role_pk.picture_ver, E#kf_1vN_role_pk.lv, E#kf_1vN_role_pk.combat_power} || E <- SideBList],
    {ok, BinData} = pt_621:write(62112, [
            SideA#kf_1vN_role_pk.id, SideA#kf_1vN_role_pk.platform, SideA#kf_1vN_role_pk.server_num, SideA#kf_1vN_role_pk.server_name, SideA#kf_1vN_role_pk.name, SideA#kf_1vN_role_pk.career,
            SideA#kf_1vN_role_pk.combat_power, SideA#kf_1vN_role_pk.win, SideA#kf_1vN_role_pk.race_1_times - SideA#kf_1vN_role_pk.win, SideA#kf_1vN_role_pk.sex, SideA#kf_1vN_role_pk.picture, SideA#kf_1vN_role_pk.picture_ver, SideA#kf_1vN_role_pk.lv,
            SendL, OpTime+LoadingTime, OpTime+LoadingTime+BattleTime
        ]),
    BinData.

%% 停止战斗
stop_battle(#state{scene_id=SceneId, scene_pool_id=ScenePoolId}) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, clear_scene_object, [0, self(), 0]),
    ok.