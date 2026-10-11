-module(mod_kf_sanctum_local).
-behaviour(gen_server).

-include("kf_sanctum.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
%% API
-export([start_link/0]).

-export([
        update_info/2,
        get_act_time/1,
        get_act_join_num/2,
        enter/5,
        exit/3,
        get_mon_info/2,
        get_mon_hurt_rank/3,
        send_tv_to_act_user/2
        ,get_reborn_point/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

update_info(Type, Args) ->
    gen_server:cast(?MODULE, {'update_info', Type, Args}).

get_act_time(RoleId) ->
    gen_server:cast(?MODULE, {'get_act_time', RoleId}).

enter(ServerId, Node, RoleId, Scene, RoleScene) ->
    gen_server:cast(?MODULE, {'enter', ServerId, Node, RoleId, Scene, RoleScene}).

get_act_join_num(RoleId, ServerId) ->
    gen_server:cast(?MODULE, {'get_act_join_num', RoleId, ServerId}).

exit(ServerId, RoleId, Scene) ->
    gen_server:cast(?MODULE, {'exit', ServerId, RoleId, Scene}).

get_mon_info(RoleId, Scene) ->
    gen_server:cast(?MODULE, {'get_mon_info', RoleId, Scene}).

get_mon_hurt_rank(RoleId, Scene, MonId) ->
    gen_server:cast(?MODULE, {'get_mon_hurt_rank', RoleId, Scene, MonId}).

send_tv_to_act_user(TvId, TvArgs) ->
    gen_server:cast(?MODULE, {'send_tv_to_act_user', TvId, TvArgs}).

get_reborn_point() ->
    gen_server:call(?MODULE, {'get_reborn_point'}, 1000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = #sanctum_state{
        join_list = [],
        kf_join_list = [],
        act_start_time = 0,
        enter_time_limit = 0,
        scene_bl_server = [],
        act_end_time = 0,
        scene_info_list = [],
        reborn_point = {0, 0}
    },
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_kf_sanctum_local Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_sanctum_local Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_kf_sanctum_local Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call({'get_reborn_point'}, State) ->
    #sanctum_state{reborn_point = Point} = State,
    {reply, Point, State};

do_handle_call(_, State) -> {reply, ok, State}.

do_handle_cast({'send_tv_to_act_user', TvId, TvArgs}, State) ->
    #sanctum_state{join_list = JoinList} = State,
    Fun = fun({_, RoleIdL}, Acc) ->
        RoleIdL ++ Acc
    end,
    RoleIdList = lists:foldl(Fun, [], JoinList),
    lib_chat:send_TV({all_include, RoleIdList}, ?MOD_KF_SANCTUM, TvId, TvArgs),
    {noreply, State};

do_handle_cast({'update_info', time, [StartTime, EndTime, EnterTimeLimit, SceneInfoList]}, State) ->
    #sanctum_state{
        join_list = JoinList,
        scene_bl_server = OldSceneBlL,
        kf_join_list = KfJoinList
    } = State,
    if
        SceneInfoList == [] ->
            lib_activitycalen_api:success_end_activity(279, 1),
            NJoinList = [], BlServerIdL = [], NKfJoinList = [];
        true ->
            lib_activitycalen_api:success_start_activity(279, 1),
            NJoinList = JoinList, BlServerIdL = OldSceneBlL, NKfJoinList = KfJoinList
    end,
    NewState = State#sanctum_state{
        act_start_time = StartTime,
        enter_time_limit = EnterTimeLimit,
        act_end_time = EndTime,
        scene_info_list = SceneInfoList,
        scene_bl_server = BlServerIdL,
        join_list = NJoinList,
        kf_join_list = NKfJoinList
    },
    {noreply, NewState};
do_handle_cast({'update_info', mon_reborn, [{mon, Scene, Mon}]}, State) ->
    #sanctum_state{
        scene_info_list = SceneInfoList
    } = State,

    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
        #sanctum_scene_info{mon = Mons} = SanSceneInfo ->
            NewMons = lists:keystore(Mon#sanctum_mon_info.mon_id, #sanctum_mon_info.mon_id, Mons, Mon),
            NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{mon = NewMons},
            NewSceneInfoList = lists:keystore(Scene, #sanctum_scene_info.scene, SceneInfoList, NewSanSceneInfo);
        _ ->
            NewSceneInfoList = SceneInfoList
    end,
    NewState = State#sanctum_state{
        scene_info_list = NewSceneInfoList
    },
    {noreply, NewState};
do_handle_cast({'update_info', scene_bl, [UpdateList, BlServerIdL]}, State) ->
    #sanctum_state{
        scene_info_list = SceneInfoList
    } = State,
    case lists:keyfind(bl_server, 1, UpdateList) of
        {bl_server, Scene, BlserverId, BlServerName, BlServerNum} ->
            case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
                #sanctum_scene_info{mon = Mons} = SanSceneInfo ->
                    case lists:keyfind(mon, 1, UpdateList) of
                        {mon, _, Mon} ->
                            NewMons = lists:keystore(Mon#sanctum_mon_info.mon_id, #sanctum_mon_info.mon_id, Mons, Mon),
                            NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{
                                mon = NewMons, bl_server = BlserverId,
                                bl_server_name = BlServerName, bl_server_num = BlServerNum
                            };
                        _ ->
                           NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{
                                bl_server = BlserverId,
                                bl_server_name = BlServerName, bl_server_num = BlServerNum
                            }
                    end,
                    NewSceneInfoList = lists:keystore(Scene, #sanctum_scene_info.scene, SceneInfoList, NewSanSceneInfo);
                _ ->
                    NewSceneInfoList = SceneInfoList
            end;
        _ ->
            case lists:keyfind(mon, 1, UpdateList) of
                {mon, Scene, Mon} ->
                    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
                        #sanctum_scene_info{mon = Mons} = SanSceneInfo ->
                            NewMons = lists:keystore(Mon#sanctum_mon_info.mon_id, #sanctum_mon_info.mon_id, Mons, Mon),
                            NewSanSceneInfo = SanSceneInfo#sanctum_scene_info{mon = NewMons},
                            NewSceneInfoList = lists:keystore(Scene, #sanctum_scene_info.scene, SceneInfoList, NewSanSceneInfo);
                        _ ->
                            NewSceneInfoList = SceneInfoList
                    end;
                _ ->
                   NewSceneInfoList = SceneInfoList
            end
    end,
    NewState = State#sanctum_state{
        scene_bl_server = BlServerIdL,
        scene_info_list = NewSceneInfoList
    },
    {noreply, NewState};
do_handle_cast({'update_info', join, [Scene, RoleId, {X, Y}]}, State) ->
    #sanctum_state{
        kf_join_list = JoinList
    } = State,
    {_, UserList} = ulists:keyfind(Scene, 1, JoinList, {Scene, []}),
    NewJoinList = lists:keystore(Scene, 1, JoinList, {Scene, [RoleId|lists:delete(RoleId, UserList)]}),
    % ?PRINT("NewJoinList:~p~n",[NewJoinList]),
    NewState = State#sanctum_state{
        kf_join_list = NewJoinList
        ,reborn_point = {X, Y}
    },
    {noreply, NewState};
do_handle_cast({'update_info', join, [Scene, RoleId]}, State) ->
    #sanctum_state{
        kf_join_list = JoinList
    } = State,
    {_, UserList} = ulists:keyfind(Scene, 1, JoinList, {Scene, []}),
    NewUserList = lists:delete(RoleId, UserList),
    NewJoinList = lists:keystore(Scene, 1, JoinList, {Scene, NewUserList}),
    NewState = State#sanctum_state{
        kf_join_list = NewJoinList
    },
    {noreply, NewState};
do_handle_cast({'update_info', _, _}, State) ->
    {noreply, State};

do_handle_cast({'get_act_time', RoleId}, State) ->
    #sanctum_state{
        act_start_time = StartTime,
        enter_time_limit = EnterTimeLimit,
        act_end_time = EndTime
    } = State,
    {ok, BinData} = pt_279:write(27900, [StartTime, EnterTimeLimit, EndTime]),
    % ?MYLOG("xlh_sanctum","27900 ==== StartTime:~p, EnterTimeLimit:~p, EndTime:~p~n",[StartTime, EnterTimeLimit, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_act_join_num', RoleId, ServerId}, State) ->
    #sanctum_state{
        join_list = JoinList,
        kf_join_list = KfJoinList,
        scene_bl_server = BlServerIdL
    } = State,
    SceneList = data_sanctum:get_all_scene(),
    CanEnter = case lists:member(ServerId, BlServerIdL) of
        true ->
            1;
        _ ->
            0
    end,
    Fun = fun(Scene, Acc) ->
        case lists:keyfind(Scene, 1, JoinList) of
            {_, RoleIdList} ->
                JoinNum = erlang:length(RoleIdList);
            _ -> JoinNum = 0
        end,
        case lists:keyfind(Scene, 1, KfJoinList) of
            {_, KfRoleIdList} ->
                KfJoinNum = erlang:length(KfRoleIdList);
            _ -> KfJoinNum = 0
        end,
        [{Scene, JoinNum, KfJoinNum}|Acc]
    end,
    SendList = lists:foldl(Fun, [], SceneList),
    % ?PRINT("SendList:~p~n",[SendList]),
    {ok, BinData} = pt_279:write(27901, [CanEnter, SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'enter', ServerId, Node, RoleId, Scene, RoleScene}, State) ->
    #sanctum_state{
        act_start_time = StartTime,
        enter_time_limit = EnterTimeLimit,
        act_end_time = EndTime,
        join_list = JoinList,
        scene_bl_server = BlServerIdL,
        kf_join_list = KfJoinList
    } = State,
    NowTime = utime:unixtime(),
    IsInActScene = lib_kf_sanctum:is_in_kf_sanctum(RoleScene),
    case lists:keyfind(Scene, 1, KfJoinList) of
        {_, UserList} ->
            skip;
        _ ->
            UserList = []
    end,
    SceneUserNum = erlang:length(UserList),
    IsSceneUserEnougth = case data_sanctum:get_value(enter_scene_player_limit) of
        LimitNum when is_integer(LimitNum) andalso LimitNum > 0 andalso SceneUserNum < LimitNum -> true;
        _ -> false
    end,
    CanEnterSpecialScene = case data_sanctum:get_scene_type(Scene) of
        [?SCENE_TYPE_SPECIAL_SAN] when IsInActScene == true ->
            case lists:member(ServerId, BlServerIdL) of
                true ->
                    true;
                _ ->
                    false
            end;
        _ -> false
    end,
    ?PRINT("BlServerIdL:~p, CanEnterSpecialScene:~p~n",[BlServerIdL, CanEnterSpecialScene]),
    if
        %% 永恒圣殿内场景互相切换
        CanEnterSpecialScene == true andalso StartTime =< NowTime andalso EndTime > NowTime andalso IsSceneUserEnougth == true ->
            case lists:keyfind(Scene, 1, JoinList) of
                {_, UserL} ->
                    skip;
                _ ->
                    UserL = []
            end,
            NewJoinList = lists:keystore(Scene, 1, JoinList, {Scene, [RoleId|lists:delete(RoleId, UserL)]}),
            lib_task_api:enter_sanctum(RoleId),
            lib_supreme_vip_api:enter_sanctum(RoleId),
            lib_activitycalen_api:role_success_end_activity(RoleId, 279, 1),
            mod_kf_sanctum:enter(ServerId, Node, RoleId, Scene, RoleScene),
            IsInActScene == true andalso mod_kf_sanctum_local:exit(ServerId, RoleId, RoleScene);
        StartTime =< NowTime andalso NowTime =< EnterTimeLimit andalso IsSceneUserEnougth == true ->
            case data_sanctum:get_scene_type(Scene) of
                [?SCENE_TYPE_SPECIAL_SAN] ->
                    {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_get_normal_scence_bl)]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    NewJoinList = JoinList;
                _ ->
                    case lists:keyfind(Scene, 1, JoinList) of
                        {_, UserL} ->
                            skip;
                        _ ->
                            UserL = []
                    end,
                    NewJoinList = lists:keystore(Scene, 1, JoinList, {Scene, [RoleId|lists:delete(RoleId, UserL)]}),
                    lib_task_api:enter_sanctum(RoleId),
                    lib_supreme_vip_api:enter_sanctum(RoleId),
                    lib_activitycalen_api:role_success_end_activity(RoleId, 279, 1),
                    mod_kf_sanctum:enter(ServerId, Node, RoleId, Scene, RoleScene),
                    IsInActScene == true andalso mod_kf_sanctum_local:exit(ServerId, RoleId, RoleScene)
            end;
        CanEnterSpecialScene == false ->
            case data_sanctum:get_scene_type(Scene) of
                [?SCENE_TYPE_SPECIAL_SAN] when IsInActScene == true ->
                    {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_get_normal_scence_bl)]);
                _ when StartTime > NowTime ->
                    {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_not_open)]);
                _ ->
                    {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_enter_limit)])
            end,
            lib_server_send:send_to_uid(RoleId, BinData),
            NewJoinList = JoinList;
        IsSceneUserEnougth == false ->
            {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_scene_user_limit)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewJoinList = JoinList;
        StartTime > NowTime orelse StartTime == 0 ->
            {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_not_open)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewJoinList = JoinList;
        NowTime > EnterTimeLimit andalso NowTime =< EndTime ->
            {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_enter_limit)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewJoinList = JoinList;
        true ->
            {ok, BinData} = pt_279:write(27902, [?ERRCODE(err279_act_end)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewJoinList = JoinList
    end,
    {noreply, State#sanctum_state{join_list = NewJoinList}};

do_handle_cast({'exit', ServerId, RoleId, Scene}, State) ->
    #sanctum_state{
        join_list = JoinList,
        kf_join_list = KfJoinList
    } = State,
    case lists:keyfind(Scene, 1, JoinList) of
        {_, UserList} ->
            skip;
        _ ->
            UserList = []
    end,
    NewUserList = lists:delete(RoleId, UserList),
    NewJoinList = lists:keystore(Scene, 1, JoinList, {Scene, NewUserList}),
    case lists:keyfind(Scene, 1, KfJoinList) of
        {_, UserL} ->
            skip;
        _ ->
            UserL = []
    end,
    NewUserL = lists:delete(RoleId, UserL),
    NewKfJoinList = lists:keystore(Scene, 1, KfJoinList, {Scene, NewUserL}),
    mod_kf_sanctum:exit(ServerId, RoleId, Scene),
    {noreply, State#sanctum_state{join_list = NewJoinList, kf_join_list = NewKfJoinList}};

do_handle_cast({'get_mon_info', RoleId, Scene}, State) ->
    #sanctum_state{scene_info_list = SceneInfoList} = State,
    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
        #sanctum_scene_info{mon = MonList, bl_server = Blserver, bl_server_num = BlserverNum, bl_server_name = BlserverName} ->
            Fun = fun(#sanctum_mon_info{mon_id = MonId, sanctum_mon_type = SanMontype, mon_lv = MonLv, reborn_time = ReBornTime}, Acc) ->
                if
                    SanMontype == ?SANMONTYPE_BOSS ->
                        [{MonId, MonLv, SanMontype, Blserver, BlserverName, BlserverNum, ReBornTime}|Acc];
                    true ->
                        [{MonId, MonLv, SanMontype, 0, <<>>, 0, ReBornTime}|Acc]
                end
            end,
            SendList = lists:foldl(Fun, [], MonList);
        _ ->
            SendList = []
    end,
    {ok, BinData} = pt_279:write(27904, [Scene, SendList]),
    % ?MYLOG("sanctum","27904 ==== SendList:~p~n",[SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_mon_hurt_rank', RoleId, Scene, MonId}, State) ->
    #sanctum_state{scene_info_list = SceneInfoList} = State,
    case lists:keyfind(Scene, #sanctum_scene_info.scene, SceneInfoList) of
        #sanctum_scene_info{mon = MonList} ->
            case lists:keyfind(MonId, #sanctum_mon_info.mon_id, MonList) of
                #sanctum_mon_info{rank_list = RankList} ->
                    SendList = lib_kf_sanctum:handle_rank_list(RankList);
                _ -> SendList = []
            end;
        _ ->
            SendList = []
    end,
    {ok, BinData} = pt_279:write(27905, [Scene, MonId, SendList]),
    % ?MYLOG("xlh_sanctum","27905 ==== SendList:~p~n",[SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast(_, State) -> {noreply, State}.

do_handle_info(_, State) -> {noreply, State}.