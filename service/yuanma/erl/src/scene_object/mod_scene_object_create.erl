%% ---------------------------------------------------------------------------
%% @doc mod_scene_object_create
%% @author ming_up@foxmail.com
%% @since  2017-02-06
%% @deprecated 场景对象生成
%% ---------------------------------------------------------------------------
-module(mod_scene_object_create).
-behaviour(gen_server).
-export([
         start_link/0, 
         create_object/10,
         create_object_cast/10,
         create_more_cast/5,
         get_new_id/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("scene.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("watchdog.hrl").

%% @spec create_object(ObjectType, ConfigId, Scene, X, Y, Type, CopyId, BroadCast, Arg) -> AutoId
%% 同步生成怪物
%% @param ObjectType: ?BATTLE_SIGN_MON | ?BATTLE_SIGN_PARTNER...
%% @param ConfigId 配置ID
%% @param Scene 场景ID
%% @param ScenePoolId 场景进程id
%% @param X 坐标
%% @param X 坐标
%% @param Type 战斗类型（0被动，1主动）
%% @param CopyId 房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%% @param BroadCast:生成的时候是否广播(0:不广播; 1:广播)
%% @param Arg:可变参数列表[Tuple1, Tuple2...]
%%             Tuple1 = {auto_lv, V} | {group, V} | {cruise_info, V} | 
%%                      {owner_id, OwnerId} | {mon_name, MonName} |  {color, MonColor} | {skip, V} | 
%%                      {crack, V}
%%@return AutoId 怪物自增ID，每个怪物唯一
%% @end
create_object(ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Arg) -> 
    gen_server:call(?MODULE, {create, [ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Arg]}).

%% @spec create_object_cast(ObjectType, ConfigId, Scene, X, Y, Type, CopyId, BroadCast, Arg) -> ok.
%% 异步创建怪物
%% @end
create_object_cast(ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Arg) -> 
    gen_server:cast(?MODULE, {create, [ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Arg]}),
    ok.

create_more_cast(Scene, ScenePoolId, CopyId, Broadcast, List) ->
    gen_server:cast(?MODULE, {create_more, [Scene, ScenePoolId, CopyId, Broadcast, List]}).

%% 获取一个场景对象的唯一id
get_new_id() -> 
    gen_server:call(?MODULE, get_new_id).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    State = #object_create_state{auto_id = 1001}, 
    {ok, State}.

%% 同步创建
handle_call({create, Args} , _FROM, State) ->
    AutoId = State#object_create_state.auto_id,
    create_a_scene_object(AutoId, Args),
    NewState = State#object_create_state{auto_id = AutoId + 1, cnt = State#object_create_state.cnt + 1},
    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_OBJECT_CNT, NewState#object_create_state.cnt),
    {reply, AutoId, NewState};

%% 获取一个新的唯一id
handle_call(get_new_id, _FROM, State) ->
    {reply, State#object_create_state.auto_id, State#object_create_state{auto_id = State#object_create_state.auto_id + 1}};

handle_call(_R , _FROM, State) ->
    {reply, State, State}.

%% 异步创建
handle_cast({create, Args}, State) ->
    create_a_scene_object(State#object_create_state.auto_id, Args),
    NewState = State#object_create_state{auto_id = State#object_create_state.auto_id + 1, cnt = State#object_create_state.cnt + 1},
    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_OBJECT_CNT, NewState#object_create_state.cnt),
    {noreply, NewState};
handle_cast({create_more, [Scene, ScenePoolId, CopyId, BroadCast, List]}, #object_create_state{auto_id = OldAutoId} = State) ->
    ArgsList = [[ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Arg] || [ObjectType, ConfigId, X, Y, Type, Arg] <- List],
    NewAutoId 
    = try 
        create_scene_objects(ArgsList, State#object_create_state.auto_id)
    catch 
        _:_ -> 
            State#object_create_state.auto_id + length(ArgsList)
    end,
    NewState = State#object_create_state{auto_id = NewAutoId, cnt = State#object_create_state.cnt + max(NewAutoId - OldAutoId, 0)},
    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_OBJECT_CNT, NewState#object_create_state.cnt),
    {noreply, NewState};

handle_cast(_R , State) ->
    {noreply, State}.

handle_info({'EXIT', _From, normal}, State)->
    NewState = State#object_create_state{cnt = max(State#object_create_state.cnt-1, 0)},
    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_OBJECT_CNT, NewState#object_create_state.cnt),
    {noreply, NewState};
handle_info({'EXIT', From, Reason}, State)->
    %% 怪物活动进程报错
    ?ERR("receive mod_mon_active(pid=~p) error info. reason: ~p~n", [From, Reason]),
    NewState = State#object_create_state{cnt = max(State#object_create_state.cnt-1, 0)},
    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_OBJECT_CNT, NewState#object_create_state.cnt),
    {noreply, NewState};

handle_info(_Reason, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

create_a_scene_object(AutoId, [ObjectType, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]) -> 
    case ObjectType of
        ?BATTLE_SIGN_MON ->
            mod_mon_active:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
        ?BATTLE_SIGN_PARTNER ->
            mod_partner_active:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
        ?BATTLE_SIGN_DUMMY ->
            %mod_dummy_active:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
            mod_btree_dummy:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
        ?BATTLE_SIGN_BTREE_MON ->
            mod_btree_mon:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
        % ?BATTLE_SIGN_TOTEM ->
        %     mod_totem_active:start([AutoId, ConfigId, Scene, ScenePoolId, X, Y, Type, Sid, BroadCast, Arg]);
        _ -> skip
    end.

create_scene_objects([Args|T], AutoId) ->
    create_a_scene_object(AutoId, Args),
    create_scene_objects(T, AutoId + 1);

create_scene_objects([], AutoId) -> AutoId.
