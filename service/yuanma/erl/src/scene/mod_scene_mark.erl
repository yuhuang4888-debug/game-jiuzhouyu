%%%------------------------------------
%%% @Module  : mod_scene_mark
%%% @Author  : xyao
%%% @email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description: 场景mark管理
%%%------------------------------------
-module(mod_scene_mark).
-behaviour(gen_server).
-include("scene.hrl").

-export([
        start_link/1,
        get_mark_pid/1,
        load_mask/1,
        is_pos/5,
        filter_blocked/5,
        change_area_mark/3,
        find_path/7
    ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link(SceneId) ->
    gen_server:start(?MODULE, [SceneId], []).

%% 加载mask
load_mask(SceneId) ->
    case get_mark_pid(SceneId) of
        undefined ->
            false;
        Pid ->
            gen_server:cast(Pid, {load_mask, SceneId})
    end.

%% 如果检查普通点,则先检查动态区域(只有普通点才有动态区域)
is_pos(SceneId, CopyId, X, Y, Type = ?SCENE_MASK_NORMAL) ->
    case data_dynamicarea:get(SceneId) of
        % 不存在动态区域,直接判断配置
        [] -> lib_scene_mark:check_cfg(SceneId, X, Y, Type);
        _  -> is_pos_help(SceneId, CopyId, X, Y, Type)
    end;
is_pos(SceneId, CopyId, X, Y, Type) -> 
    case lib_scene_mark:check_cfg(SceneId, X, Y, Type) of 
        true -> true;
        false -> 
            case data_dynamicarea:get(SceneId) of
                % 不存在动态区域直接返回false
                [] -> false; 
                _  -> is_pos_help(SceneId, CopyId, X, Y, Type)
            end
    end.

is_pos_help(SceneId, CopyId, X, Y, Type) ->
    case get(scene_pos) of
        M when is_map(M) ->
            case maps:get({X, Y}, M, false) of
                false -> false;
                AreaId -> 
                    CopyAreaMaps = get({scene_area, CopyId}),
                    case is_map(CopyAreaMaps) andalso maps:is_key(AreaId, CopyAreaMaps) of
                        false -> AreaMaps = get(scene_area), maps:get(AreaId, AreaMaps, false) =:= Type;
                        _ -> maps:get(AreaId, CopyAreaMaps, false) =:= Type
                    end
            end;
        _ ->
            case get_mark_pid(SceneId) of
                undefined -> false;
                Pid ->
                    case catch gen:call(Pid, '$gen_call', {is_pos, SceneId, CopyId, X, Y, Type}, 2000) of
                        {ok, Bool} -> Bool;
                        _ -> false
                    end
            end
    end.

%% 过滤掉障碍点坐标，返回剩余的坐标
filter_blocked(SceneId, CopyId, Type, XYs, DropLen) ->
    case get(scene_pos) of
        M when is_map(M) -> calc_filter_blocked(XYs, SceneId, M, CopyId, Type, DropLen, 0, []);
        _ ->
            case get_mark_pid(SceneId) of
                undefined ->
                    false;
                Pid ->
                    case catch gen:call(Pid, '$gen_call', {filter_blocked, SceneId, CopyId, Type, XYs, DropLen}, 5000) of
                        {ok, ReturnL} -> ReturnL;
                        _ -> XYs
                    end
            end
    end.

%% 修改动态区域，请使用lib_scene:change_area_mark/4接口
change_area_mark(SceneId, CopyId, AreaMarkL) ->
    case get_mark_pid(SceneId) of
        undefined ->
            false;
        Pid ->
            gen_server:cast(Pid, {change_area_mark, CopyId, AreaMarkL})
    end.

%% 获取A*寻路路径
find_path(SceneId, X, Y, TX, TY, Id, RequestPid) ->
    case get_mark_pid(SceneId) of
        undefined -> false;
        Pid -> gen_server:cast(Pid, {find_path, SceneId, X, Y, TX, TY, Id, RequestPid})
    end.

init([SceneId]) ->
    MarkProcessName = misc:mark_process_name(SceneId),
    misc:register(local, MarkProcessName, self()),
    {ok, SceneId}.

handle_call({is_pos, CopyId, Key, Type}, _From, State) ->
    PosMaps = get(scene_pos),
    Reply = case maps:get(Key, PosMaps, false) of
        false -> false;
        Type  -> true;
        AreaId ->
            case get({scene_area, CopyId}) of
                AreaMaps when is_map(AreaMaps) -> maps:get(AreaId, AreaMaps, false) =:= Type;
                _ -> AreaMaps = get(scene_area), maps:get(AreaId, AreaMaps, false) =:= Type
            end
    end,
    {reply, Reply, State};

handle_call({filter_blocked, SceneId, CopyId, Type, XYs, DropLen}, _From, State) ->
    PosMaps = get(scene_pos),
    RL = calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, 0, []),
    {reply, RL, State};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({load_mask, SceneId}, State) ->
    {AreaMaps, PosMaps} = lib_scene_mark:load_mark(SceneId, 0),
    put(scene_pos, PosMaps),
    put(scene_area, AreaMaps),
    {noreply, State};

handle_cast({change_area_mark, CopyId, AreaMarkL}, State) ->
    lib_scene_agent:change_area_mark(CopyId, AreaMarkL),
    {noreply, State};

handle_cast({find_path, SceneId, X, Y, TX, TY, Id, RequestPid}, State) ->
    Path = lib_scene_path:find_path(SceneId, X, Y, TX, TY),
    RequestPid ! {'path_return', Id, Path},
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

get_mark_pid(Id) ->
    case get({get_mark_pid, Id}) of
        undefined ->
            MarkProcessName = misc:mark_process_name(Id),
            MarkPid =  misc:whereis_name(local, MarkProcessName),
            case is_pid(MarkPid) of
                true ->
                    put({get_mark_pid, Id}, MarkPid),
                    MarkPid;
                false ->
                    undefined
            end;
        MarkPid ->
            MarkPid
    end.

%% 排除某一个类型
calc_filter_blocked(_XYs, _SceneId, _PosMaps, _CopyId, _Type, DropLen, DropLen, ReturnL) -> ReturnL;
calc_filter_blocked([], _SceneId, _PosMaps, _CopyId, _Type, _DropLen, _Count, ReturnL) -> ReturnL;
calc_filter_blocked([{X, Y}|XYs], SceneId, PosMaps, CopyId, Type, DropLen, Count, ReturnL) ->
    case maps:get({X, Y}, PosMaps, false) of
        false ->
            case lib_scene_mark:check_cfg(SceneId, X, Y, Type) of
                true -> calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, Count, ReturnL);
                false -> calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, Count+1, [{X, Y}|ReturnL])
            end;
        Type ->
            calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, Count, ReturnL);
        AreaId ->
            %% 有动态区域则查询动态区域现在的属性
            CopyAreaMaps = get({scene_area, CopyId}),
            TMaps = case is_map(CopyAreaMaps) andalso maps:is_key(AreaId, CopyAreaMaps) of
                false ->  get(scene_area);
                _ -> CopyAreaMaps
            end,
            case maps:get(AreaId, TMaps, false) =:= Type of
                true ->  calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, Count, ReturnL);
                false -> calc_filter_blocked(XYs, SceneId, PosMaps, CopyId, Type, DropLen, Count+1,  [{X, Y}|ReturnL])
            end

    end.
