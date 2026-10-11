%% ---------------------------------------------------------------------------
%% @doc lib_scene_mark
%% @author ming_up@foxmail.com
%% @since  2016-08-13
%% @deprecated  加载地图mark
%% ---------------------------------------------------------------------------
-module(lib_scene_mark).
-export([check_cfg/4, load_mark/2, mark_c2s/1, mark_s2c/1]).

-include("scene.hrl").

%% 配置检查是否存在mark
check_cfg(SceneId, X, Y, Type) -> 
    % MaskMod = list_to_atom(lists:concat(["data_mask_", SceneId])),
    case data_mask:get_mod(SceneId) of
        false -> false;
        MaskMod ->
            ClientType = MaskMod:get(X, Y),
            mark_to_type(ClientType) == Type
    end.

%% 客户端mark转化为服务端mark
mark_c2s(AreaMarkL) -> 
    F = fun({AreaId, ClientType}) -> 
        Type = case ClientType of
            1 -> ?SCENE_MASK_BLOCK;
            5 -> ?SCENE_MASK_SAFE;
            _ -> ?SCENE_MASK_NORMAL
        end,
        {AreaId, Type}
    end,
    lists:map(F, AreaMarkL).

%% 服务端mark转换为客户端mark
mark_s2c(AreaMarkL) -> 
    F = fun({AreaId, Type}) -> 
        ClientType = case Type of
            ?SCENE_MASK_BLOCK -> 1;
            ?SCENE_MASK_SAFE -> 5;
            ?SCENE_MASK_NORMAL -> 0
        end,
        {AreaId, ClientType}
    end,
    lists:map(F, AreaMarkL).

%% Retrun -> {AreaMaps, PosMaps}
load_mark(SceneId, Parent) -> 
    {AreaMaps, AreaPosMaps} = load_dynamicarea(data_dynamicarea:get(SceneId), #{}, #{}),
    case is_pid(Parent) of
        true  -> Parent ! {'scene_mark', AreaMaps, AreaPosMaps};
        false -> skip
    end,
    {AreaMaps, AreaPosMaps}.

% %% Retrun -> {AreaMaps, PosMaps}
% load_mark(SceneId, Parent) -> 
%     case data_scene:get(SceneId) of
%         [] -> {#{}, #{}};
%         #ets_scene{origin_type = OriginType} = SceneR -> 
%             case data_mask:get(SceneId) of
%                 "" -> {#{}, #{}};
%                 Mark ->
%                     case OriginType of
%                         % 0点在左上角
%                         ?MAP_ORIGIN_LU -> PosMaps = load_mark(Mark, 0, 0, OriginType, #{});
%                         % 0点在左下角
%                         ?MAP_ORIGIN_LD ->
%                             MaxY = max(0, util:ceil((SceneR#ets_scene.height-?WIDTH_UNIT) / ?WIDTH_UNIT)),
%                             PosMaps = load_mark(Mark, 0, MaxY, OriginType, #{})
%                     end,
%                     {AreaMaps, AreaPosMaps} = load_dynamicarea(data_dynamicarea:get(SceneId), #{}, PosMaps),
%                     case is_pid(Parent) of
%                         true  -> Parent ! {'scene_mark', AreaMaps, AreaPosMaps};
%                         false -> skip
%                     end,
%                     {AreaMaps, AreaPosMaps}
%             end
%     end.

% load_mark([], _, _, _, State) -> State;
% load_mark(_, _, Y, _, State) when Y < 0 -> State;
% load_mark([H|T], X, Y, OriginType, State) ->
%     case H of
%         10 -> % 等于\n
%             case OriginType of
%                 ?MAP_ORIGIN_LU -> load_mark(T, 0, Y+1, OriginType, State);
%                 ?MAP_ORIGIN_LD -> load_mark(T, 0, Y-1, OriginType, State)
%             end;
%         13 -> % 等于\r
%             load_mark(T, X, Y, OriginType, State);
%         44 -> % 等于,(客户端用不处理)
%             load_mark(T, X, Y, OriginType, State);
%         48 -> % 0 %% 可行走没有处理的
%             load_mark(T, X+1, Y, OriginType, State);
%         49 -> % 1 %% 不能行走
%             load_mark(T, X+1, Y, OriginType, State#{{X,Y} => ?SCENE_MASK_BLOCK});
%         50 -> % 2 %% 透明区
%             load_mark(T, X+1, Y, OriginType, State);
%         %52 -> % 4 %% 安全区的透明区域
%         %    load_mark(T, X+1, Y, MaxY, State#{{X,Y} => ?SCENE_MASK_SAFE});
%         53 -> % 5 %% 安全区
%             load_mark(T, X+1, Y, OriginType, State#{{X,Y} => ?SCENE_MASK_SAFE});
%         54 -> % 6 %% 跳跃，等于障碍
%             load_mark(T, X+1, Y, OriginType, State#{{X,Y} => ?SCENE_MASK_BLOCK}); 
%         56 -> % 8 %% 水面
%             load_mark(T, X+1, Y, OriginType, State);
%         58 -> % 等于:(客户端用不处理)
%             load_mark(T, X, Y, OriginType, State);
%         _ ->
%             load_mark(T, X+1, Y, OriginType, State) 
%     end.

%% 障碍区标识转为服务端类型
mark_to_type(1) -> ?SCENE_MASK_BLOCK;
mark_to_type(5) -> ?SCENE_MASK_SAFE;
mark_to_type(6) -> ?SCENE_MASK_BLOCK;
mark_to_type(_) -> ?SCENE_MASK_NORMAL.

%% 加载动态区域
load_dynamicarea([{AreaId, Mark, XYList}|T], AreaMaps, PosMaps) -> 
    F = fun(Key, {Maps1, Maps2}) -> 
        { Maps1#{AreaId => mark_to_type(Mark)}, Maps2#{Key => AreaId} }
    end,
    {AreaMaps1, PosMaps1} = lists:foldl(F, {AreaMaps, PosMaps}, XYList),
    load_dynamicarea(T, AreaMaps1, PosMaps1);
load_dynamicarea([], AreaMaps, PosMaps) -> 
    {AreaMaps, PosMaps}.
