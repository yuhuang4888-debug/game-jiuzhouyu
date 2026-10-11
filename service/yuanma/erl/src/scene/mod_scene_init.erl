%%%------------------------------------
%%% @Module  : mod_server_init
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.18
%%% @Description: 场景初始化
%%%------------------------------------
-module(mod_scene_init).
-behaviour(gen_server).

-export([
        start_link/0, start_new_scene/2, start_new_scene_cls/2, start_scene/2, update_scene/2,
        copy_a_outside_scene/4, load_scene_object/4, get_scene_num/0,
        close_scene/2, clear_scene/2, reload_scene_mon/4
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("record.hrl").
-include("scene.hrl").
-include("common.hrl").

%% 场景数据
-record(scene_state, {
          scene_pool = #{},     %% #{sid => #{pool_id => scene_pool_pid}}
          timer_ref = undefined
         }).

%% 十分钟
-define(DEL_TIME, 600).

%% 开启一个新场景
start_new_scene(Id, PoolId) ->
    case mod_disperse:node_id() of
        0  -> %% 跨服中心
            start_scene(Id, PoolId);
        10 -> %% 游戏线10
            start_scene(Id, PoolId);
        _ -> %% 其余线路
            List = [N || #node{id=10}=N <- mod_disperse:node_list()],
            case List of
                [Node|_] ->
                    case rpc:call(Node#node.node, ?MODULE, start_scene, [Id, PoolId]) of
                        ScenePid when is_pid(ScenePid) ->
                            ScenePid;
                        _ ->
                            undefined
                    end;
                [] -> undefined
            end
    end.

%% 负载均衡，分布式创建场景
start_new_scene_cls(Id, PoolId) ->
    F = fun(N) ->
                Num = rpc:call(N#node.node, mod_scene_init, get_scene_num, []),
                {N#node.node, Num}
        end,
    List = [F(N) || N <- mod_disperse:node_list(), N#node.id =:= 10],
    CurNode = mod_disperse:node_id(),
    case List =/= [] of
        true ->
            case lists:nth(1, lists:keysort(2, List)) of
                {Node, _} ->
                    case rpc:call(Node, mod_scene_init, start_scene, [Id, PoolId]) of
                        ScenePid when is_pid(ScenePid) -> ScenePid;
                        _ -> undefined
                    end;
                _ ->
                    %% 判断当前节点是否为游戏服
                    case CurNode >= 10 orelse CurNode =:= 0 of
                        true -> start_scene(Id, PoolId);
                        false -> undefined
                    end
            end;
        false ->
            %% 判断当前节点是否为游戏服
            case CurNode >= 10 orelse CurNode =:= 0 of
                true -> start_scene(Id, PoolId);
                false -> undefined
            end
    end.

start_scene(Id, PoolId) ->
    gen_server:call(?MODULE, {'start_scene', Id, PoolId}).

update_scene(Id, AttrList) ->
    gen_server:cast(?MODULE, {'update_scene', Id, AttrList}).

close_scene(Id, PoolId) ->
    gen_server:call(?MODULE, {'close_scene', Id, PoolId}).

clear_scene(Id, PoolId) ->
    gen_server:call(?MODULE, {'clear_scene', Id, PoolId}).

%% 获取场景个数
get_scene_num() ->
    gen_server:call(?MODULE, {'get_scene_num'}).

%% 新开启一个线路
copy_a_outside_scene(SceneId, PoolId, CopyId, Broadcast) ->
    gen_server:call(?MODULE, {'copy_a_outside_scene', SceneId, PoolId, CopyId, Broadcast}).

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    Line    = mod_disperse:node_id(),
    ClsType = config:get_cls_type(),
    case Line == 10 orelse ClsType == 1 of
        true -> spawn(fun() -> open_all_scene(ClsType) end);
        false -> skip
    end,
    %% 10分钟定时删除场景空房间
    %% TimerRef = erlang:send_after(?DEL_TIME*1000, self(), {'timer_to_delete_a_outside_scene'}),
    {ok, #scene_state{scene_pool = #{}}}.

%% call
%% 获取场景个数
handle_call({'get_scene_num'} , _FROM, Status) ->
    SceneNum = maps:fold(fun(_K, E, Num) -> maps:size(E) + Num end, 0, Status#scene_state.scene_pool),
    {reply, SceneNum, Status};

%% 开启新场景
handle_call({'start_scene', Id, PoolId} , _FROM, Status) ->
    #scene_state{scene_pool = AllScenePool} = Status,
    {OneScenePool, ScenePid}
        = case maps:find(Id, AllScenePool) of
              {ok, Pool} ->
                  case maps:find(PoolId, Pool) of
                      {ok, Pid} -> {Pool, Pid};
                      error -> {Pool, false}
                  end;
              error -> {#{}, false}
          end,
    case is_pid(ScenePid) andalso misc:is_process_alive(ScenePid) of
        true  -> {reply, ScenePid, Status};
        false ->
            case catch mod_scene_agent:start_scene(Id, PoolId) of
                Return when is_pid(Return) ->
                    spawn(fun() -> load_scene_object(Id, PoolId, 0, 0), ok end),
                    %% 单个场景的poolid的
                    NewOneScenePool = OneScenePool#{PoolId => Return},
                    NewAllScenePool = AllScenePool#{Id => NewOneScenePool},
                    {reply, Return, Status#scene_state{scene_pool = NewAllScenePool}};
                Other ->
                    ?ERR("mod_scene_init:start_scene id=~w, pool_id=~w, reason:~p~n", [Id, PoolId, Other]),
                    {reply, undefined, Status}
            end
    end;

%% 开启一个新线路
handle_call({'copy_a_outside_scene', SceneId, PoolId, CopyId, Broadcast}, _From, Status) ->
    case data_scene:get(SceneId) of
        #ets_scene{mon=Mon} = Scene->
            spawn(fun() ->
                          %% 先清理，后创建，确保怪物不会多份
                          lib_mon:clear_scene_mon(SceneId, PoolId, CopyId, Broadcast),
                          load_mon(Mon, Scene, PoolId, CopyId, Broadcast),
                          lib_scene_event:copy_a_outside_scene(SceneId, PoolId, CopyId)
                  end),
            Res = true;
        _ ->
            Res = false
    end,
    {reply, Res, Status};

handle_call({'close_scene', Id, PoolId} , _FROM, Status) ->
    mod_scene_agent:close_scene(Id, PoolId),
    NewStatus = case maps:find(Id, Status) of
                    error -> Status;
                    {ok, Pool} -> Status#{Id := maps:remove(PoolId, Pool)}
                end,
    {reply, ok, NewStatus};

handle_call({'clear_scene', Id, PoolId} , _FROM, Status) ->
    mod_scene_agent:clear_scene(Id, PoolId),
    {reply, ok, Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

%% 更新场景数据
handle_cast({'update_scene', SceneId, AttrList}, Status) ->
    #scene_state{scene_pool = AllScenePool} = Status,
    OneScenePool = maps:get(SceneId, AllScenePool, #{}),
    F = fun(PoolId, _PoolPid, Acc) ->
        mod_scene_agent:cast_to_scene(SceneId, PoolId, {'update_scene', AttrList}),
        Acc
    end,
    maps:fold(F, ok, OneScenePool),
    {noreply, Status};

%% cast
handle_cast(_R , Status) ->
    {noreply, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.


%% ================================= 方法  =================================

%% 开启所有场景
open_all_scene(ClsType) ->
    %% 优先初始化有npc的场景
    %% F2 = fun(Id1, Id2) ->
    %%    S1 = data_scene:get(Id1),
    %%    S2 = data_scene:get(Id2),
    %%    S1=/=[] andalso S2=/=[] andalso S1#ets_scene.npc>S2#ets_scene.npc andalso Id1=<Id2
    %% end,
    %% L = lists:usort(F2,  data_scene:get_id_list()),
    L = data_scene:get_id_list(), %% id头位已经区分场景类型，1为普通地图，优先加载
    F = fun(Id) ->
                case data_scene:get(Id) of
                    #ets_scene{cls_type=ClsType} ->
                        mod_scene_mark:start_link(Id),
                        mod_scene_agent:get_scene_pid(Id),
                        mod_scene_mark:load_mask(Id),
                        ok;
                    _ -> skip
                end,
                timer:sleep(1000)
        end,
    [ F(Id) || Id <-L ].

%% 场景初始化，加载场景静态信息
load_scene_object(SceneId, PoolId, CopyId, BroadCast) ->
    #ets_scene{id=Id, npc=Npc, mon=Mon} = Scene = data_scene:get(SceneId),
    load_npc(Npc, Id),
    load_mon(Mon, Scene, PoolId, CopyId, BroadCast),
    ok.

%% 加载NPC
load_npc([[NpcId, X, Y, Anima] | T], SceneId) ->
    case data_npc:get(NpcId) of
        #ets_npc{}=N -> mod_scene_npc:insert(N#ets_npc{id = NpcId, x = X, y = Y, scene = SceneId, anima=Anima});
        _  -> skip
    end,
    load_npc(T, SceneId);
load_npc([H|T], SceneId) ->
    ?ERR("scene npc format error scene_id=~p npc=~p~n", [SceneId, H]),
    load_npc(T, SceneId);
load_npc([], _) -> ok.

%% 加载怪物
load_mon([[MonId, X, Y, Type, Group] | T], #ets_scene{id=SceneId}=Scene, PoolId, CopyId, Broadcast) ->
    case data_mon:get(MonId) of
        #mon{kind=Kind, lv=Lv} ->
            case Scene of
                #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN -> skip;
                _ -> lib_mon:async_create_mon(MonId, SceneId, PoolId, X, Y, Type, CopyId, Broadcast, [{group, Group}])
            end,
            mod_scene_mon:insert(#ets_scene_mon{id = MonId, x = X, y = Y, scene = SceneId, kind = Kind, lv=Lv});
        _ -> skip
    end,
    load_mon(T, Scene, PoolId, CopyId, Broadcast);
load_mon([H|T], #ets_scene{id=SceneId}=Scene, PoolId, CopyId, Broadcast) ->
    ?ERR("scene mon format error scene_id=~p mon=~p~n", [SceneId, H]),
    load_mon(T, Scene, PoolId, CopyId, Broadcast);
load_mon([], _, _, _, _) -> ok.

%% 重新加载野外地图怪物
reload_scene_mon(SceneId, ScenePoolId, CopyId, BroadCast) ->
    lib_mon:clear_scene_mon(SceneId, ScenePoolId, CopyId, BroadCast),
    spawn(fun() -> reload_scene_mon_core(SceneId, ScenePoolId, CopyId, BroadCast) end).

reload_scene_mon_core(SceneId, ScenePoolId, CopyId, BroadCast) ->
    timer:sleep(10*1000),
    #ets_scene{mon=Mon} = Scene = data_scene:get(SceneId),
    load_mon(Mon, Scene, ScenePoolId, CopyId, BroadCast),
    ok.
