%% ---------------------------------------------------------------------------
%% @doc lib_scene_object_path

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/10/19 0019
%% @desc    路径算法 A星算法 B星算法
%% ---------------------------------------------------------------------------
-module(lib_scene_object_path).

%% API
-export([
    get_next_point/7,
    a_star_point/8,
    a_star_path/8,
    b_star_point/8,
    b_star_path/8
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

-record(a_star_node, {
    loc = {0, 0},
    parent,
    g = 0,
    h = 0
}).

-define(DEPTH, 50).
-define(SQRT2, math:sqrt(2)).
% {X, Y, G}
-define(A_STAR_NEAR(X, Y),
    [
        {X+1, Y, 1},   {X,   Y+1, 1}, {X-1, Y, 1},   {X,   Y-1, 1},
        {X+1, Y+1, ?SQRT2}, {X-1, Y+1, ?SQRT2}, {X+1, Y-1, ?SQRT2}, {X-1, Y+1, ?SQRT2}
    ]).

-record(b_star_node, {
    loc = {0, 0},
    parent
}).

get_next_point(NowXpx, NowYpx, SceneId, CopyId, _AttArea, TargetXpx, TargetYpx) ->
    %% 转换坐标
    {NowXl, NowYl}       = lib_scene_calc:pixel_to_logic_coordinate(NowXpx, NowYpx),
    {TargetXl, TargetYl} = lib_scene_calc:pixel_to_logic_coordinate(TargetXpx, TargetYpx),
    %#ets_scene{width = WidthPx, height = HeightPx} = data_scene:get(SceneId),
    % {MaxXl, MaxYl} = lib_scene_calc:pixel_to_logic_coordinate(WidthPx, HeightPx),
    %% 计算下一个点
    % {NextXl, NextYl}     = a_star_point(NowXl, NowYl, SceneId, CopyId, TargetXl, TargetYl, MaxXl, MaxYl),
    % {NextXl, NextYl}     = b_star_point(NowXl, NowYl, SceneId, CopyId, TargetXl, TargetYl, MaxXl, MaxYl),
    {NextXl, NextYl}     = simple_a_star(NowXl, NowYl, SceneId, CopyId, TargetXl, TargetYl),
    lib_scene_calc:logic_to_pixel_coordinate(NextXl, NextYl).

%% ===============================================
%% A星算法 获取下一步移动的点
a_star_point(OX, OY, SceneId, CopyId, TX, TY, MaxXl, MaxYl) ->
    case a_star_path(OX, OY, SceneId, CopyId, TX, TY, MaxXl, MaxYl) of
        [{X, Y}|_] ->
            {X, Y};
        _ ->
            simple_a_star(OX, OY, SceneId, CopyId, TX, TY)
    end.

%% ===============================================
%% A星算法 获取移动路径
%% https://blog.csdn.net/hitwhylz/article/details/23089415
a_star_path(X, Y, SceneId, CopyId, TX, TY, MaxXl, MaxYl) ->
    BeginNode = #a_star_node{loc={X,Y}},
    CloseMap = #{{X, Y} => BeginNode},
    OpenLMap = add_open_list(SceneId, CopyId, BeginNode, TX, TY, MaxXl, MaxYl, CloseMap, #{}),
    get_a_star_path(SceneId, CopyId, TX, TY, MaxXl, MaxYl, OpenLMap, CloseMap, 1).

get_a_star_path(SceneId, CopyId, TX, TY, MaxXl, MaxYl, OpenLMap, CloseMap, Depth) ->
    case maps:is_key({TX, TY}, OpenLMap) of
        true -> get_a_star_path2(CloseMap, TX, TY);
        % 深度超过10不在继续（影响性能）
        _ when Depth > ?DEPTH -> simple_a_star;
        _ ->
            case sort_a_star_p(maps:values(OpenLMap)) of
                [Node = #a_star_node{loc = Loc}|_] ->
                    NewCloseMap = CloseMap#{Loc => Node},
                    NewOpenLMap = add_open_list(SceneId, CopyId, Node, TX, TY, MaxXl, MaxYl, NewCloseMap, maps:remove(Loc, OpenLMap)),
                    get_a_star_path(SceneId, CopyId, TX, TY, MaxXl, MaxYl, NewOpenLMap, NewCloseMap, Depth + 1);
                _ -> block
            end
    end.

add_open_list(SceneId, CopyId, PNode, TX, TY, MaxXl, MaxYl, CloseMap, OpenMap) ->
    #a_star_node{loc={X,Y}, g = PG} = PNode,
    F = fun({X0, Y0, G}, AccOpenMap) ->
        case maps:is_key({X0, Y0}, OpenMap) orelse maps:is_key({X0, Y0}, CloseMap) of
            _ when X0 =< MaxXl, Y0 =< MaxYl, X0 >= 0, Y0 >= 0 -> AccOpenMap;
            true -> AccOpenMap;
            _ ->
                case lib_scene:is_blocked_logic(SceneId, CopyId, X0, Y0) of
                % case is_blocked_logic(SceneId, CopyId, X0, Y0) of
                    true -> AccOpenMap;
                    _ ->
                        H = umath:distance({X0, Y0}, {TX, TY}),
                        SNode = #a_star_node{parent = {X,Y}, loc={X0, Y0}, g = PG + G, h = H},
                        AccOpenMap#{{X0, Y0} => SNode}
                end
        end
    end,
    lists:foldl(F, OpenMap, ?A_STAR_NEAR(X, Y)).

sort_a_star_p(OpenList) ->
    F = fun(#a_star_node{g =G1, h = H1}, #a_star_node{g =G2, h = H2}) ->
        G1 + H1 < G2 + H2
    end,
    lists:sort(F, OpenList).

% 第一轮获取OpenLMap是Target已在里面
get_a_star_path2([_], TX, TY) -> [{TX, TY}];
get_a_star_path2(CloseMap, TX, TY) ->
    case lists:reverse(lists:keysort(#a_star_node.g, maps:values(CloseMap))) of
        [_] -> [{TX, TY}];
        [Node|_] ->
            do_get_a_star_path2(TX, TY, CloseMap, Node, []);
        [] -> block
    end.

do_get_a_star_path2(_TX, _TY, _CloseMap, #a_star_node{parent = undefined}, Path) ->
    [Loc||#a_star_node{loc = Loc} <- Path];
do_get_a_star_path2(TX, TY, CloseMap, Node, Path) ->
    #a_star_node{parent = {X, Y}} = Node,
    case maps:get({X, Y}, CloseMap, false) of
        false -> block;
        NextNode ->
            do_get_a_star_path2(TX, TY, CloseMap, NextNode, [Node|Path])
    end.

%% ===============================================
%% A*算法
simple_a_star(X, Y, SceneId, CopyId, TX, TY) ->
    %% 周围8格子
    FirstP = {X+1, Y},
    FirstDis = math:pow(X - TX, 2) + math:pow(Y - TY, 2),
    OtherPList = [
        {X+1, Y},   {X,   Y+1}, {X-1, Y},   {X,   Y-1},
        {X+1, Y+1}, {X-1, Y+1}, {X+1, Y-1}, {X-1, Y+1}
    ],

    F = fun(P, {TmpP0, DisP0}) ->
        {PX, PY} = P,
        case lib_scene:is_blocked_logic(SceneId, CopyId, PX, PY) of
            false -> %非障碍点
                DisP = math:pow(PX - TX, 2) + math:pow(PY - TY, 2),
                case DisP < DisP0 of
                    true -> {P, DisP};
                    _    -> {TmpP0, DisP0}
                end;
            _ -> %% 障碍点过滤
                {TmpP0, DisP0}
        end
        end,
    {NP, _} = lists:foldl(F, {FirstP, FirstDis}, OtherPList),
    NP.


%% ===============================================
%% B星算法 获取下一步移动的点
b_star_point(OX, OY, SceneId, CopyId, TX, TY, MaxXl, MaxYl) ->
    case b_star_path(OX, OY, SceneId, CopyId, TX, TY, MaxXl, MaxYl) of
        [{X, Y}|_] -> {X, Y};
        _ -> block
    end.

%% ===============================================
%% B星算法 获取移动路径
%% https://blog.csdn.net/qinysong/article/details/83636069
b_star_path(X, Y, SceneId, CopyId, TX, TY, MaxXl, MaxYl) ->
    BeginNode = #b_star_node{loc = {X, Y}},
    HadRunMap = #{{X, Y} => BeginNode},
    BranchNodeL = [BeginNode],
    get_b_star_path(BranchNodeL, HadRunMap, SceneId, CopyId, TX, TY, MaxXl, MaxYl).

get_b_star_path([], _HadRunMap, _SceneId, _CopyId, _TX, _TY, _MaxXl, _MaxYl) -> block;
get_b_star_path(BranchNodeL, HadRunMap, SceneId, CopyId, TX, TY, MaxXl, MaxYl) ->
    case lists:keyfind({TX, TY}, #b_star_node.loc, BranchNodeL) of
        false ->
            F = fun(ParentNode, {AccL, AccMap}) ->
                #b_star_node{loc = ParentLoc = {PX, PY}} = ParentNode,
                case PX >= 0 andalso PX =< MaxXl andalso PY >= 0 andalso PY =< MaxYl of
                    true ->
                        BranchList = get_branch_point(ParentNode, AccMap, SceneId, CopyId, TX, TY),
                        {NewAccMap, NodeL} = get_branch_node(BranchList, ParentLoc, AccMap),
                        {NodeL, NewAccMap};
                    _ ->
                        {AccL, AccMap}
                end
            end,
            {NewBranchNodeL, NewHadRunMap} = lists:foldl(F, {[], HadRunMap}, BranchNodeL),
            get_b_star_path(NewBranchNodeL, NewHadRunMap, SceneId, CopyId, TX, TY, MaxXl, MaxYl);
        TargetNode ->
            get_b_star_path2(TargetNode, HadRunMap)
    end.

get_b_star_path2(TargetNode, HadRunMap) ->
    get_b_star_path2(TargetNode, HadRunMap, []).

get_b_star_path2(#b_star_node{parent = undefined}, _HadRunMap, Path) ->
    Path;
get_b_star_path2(#b_star_node{parent = Parent, loc = Loc}, HadRunMap, Path) ->
    case maps:get(Parent, HadRunMap, false) of
        false -> [];
        Node ->
            get_b_star_path2(Node, HadRunMap, [Loc|Path])
    end.

get_branch_node(PointL, Parent, HadRunMap) ->
    get_branch_node(PointL, Parent, HadRunMap, []).

get_branch_node([], _Parent, HadRunMap, NodeL) -> {HadRunMap, NodeL};
get_branch_node([{X, Y}|T], Parent, HadRunMap, NodeL) ->
    Node = #b_star_node{loc = {X, Y}, parent = Parent},
    get_branch_node(T, Parent, HadRunMap#{{X, Y} => Node}, [Node|NodeL]).

get_branch_point(#b_star_node{loc = {X, Y}}, HadRunMap, SceneId, CopyId, TX, TY) ->
    DirectionPointL = b_star_direction_point(X, Y, TX, TY),
    get_branch_point2(DirectionPointL, HadRunMap, SceneId, CopyId).

get_branch_point2([], _HadRunMap, _SceneId, _CopyId) -> [];
get_branch_point2([H|T], HadRunMap, SceneId, CopyId) ->
    case branch_filter(H, HadRunMap, SceneId, CopyId) of
        had_run -> [];
        [] ->  get_branch_point2(T, HadRunMap, SceneId, CopyId);
        Branch ->  Branch
    end.

branch_filter(List, HadRunMap, SceneId, CopyId) ->
    F = fun({PX, PY}, Acc) ->
        case maps:is_key({PX, PY}, HadRunMap) of
            true when Acc == [] -> had_run;
            true -> Acc;
            _ ->
                case lib_scene:is_blocked_logic(SceneId, CopyId, PX, PY) of
                    true -> Acc;
                    _ when is_list(Acc) -> [{PX, PY}|Acc];
                    _ -> [{PX, PY}]
                end
        end
    end,
    lists:foldl(F, [], List).
    %F_filter = fun({PX, PY}) ->
    %    %not (is_blocked_logic(SceneId, CopyId, PX, PY) orelse maps:is_key({PX, PY}, HadRunMap))
    %    not (lib_scene:is_blocked_logic(SceneId, CopyId, PX, PY) orelse maps:is_key({PX, PY}, HadRunMap))
    %end,
    %lists:filter(F_filter, List).

%% 获得方向优先级
%% B星算法是基于方向的分支
b_star_direction_point(X, Y, TX, TY) when X == TX, Y == TY ->
    [];
b_star_direction_point(X, Y, TX, TY) when X > TX, Y == TY ->
    [
        [{X - 1, Y}],
        [{X - 1, Y + 1}, {X - 1, Y - 1}],
        [{X, Y + 1}, {X, Y - 1}],
        [{X + 1, Y + 1}, {X + 1, Y - 1}],
        [{X + 1, Y}]
    ];
b_star_direction_point(X, Y, TX, TY) when X < TX, Y == TY ->
    [
        [{X + 1, Y}],
        [{X + 1, Y - 1}, {X + 1, Y + 1}],
        [{X, Y - 1}, {X, Y + 1}],
        [{X - 1, Y - 1}, {X - 1, Y + 1}],
        [{X - 1, Y}]
    ];
b_star_direction_point(X, Y, TX, TY) when X == TX, Y > TY ->
    [
        [{X, Y - 1}],
        [{X - 1, Y - 1}, {X + 1, Y - 1}],
        [{X - 1, Y}, {X + 1, Y}],
        [{X - 1, Y + 1}, {X + 1, Y + 1}],
        [{X, Y + 1}]
    ];
b_star_direction_point(X, Y, TX, TY) when X == TX, Y < TY ->
    [
        [{X, Y + 1}],
        [{X - 1, Y + 1}, {X + 1, Y + 1}],
        [{X - 1, Y}, {X + 1, Y}],
        [{X - 1, Y - 1}, {X + 1, Y - 1}],
        [{X, Y - 1}]
    ];
b_star_direction_point(X, Y, TX, TY) when X < TX, Y < TY ->
    [
        [{X + 1, Y + 1}],
        [{X + 1, Y}, {X, Y + 1}],
        [{X + 1, Y - 1}, {X - 1, Y + 1}],
        [{X, Y - 1}, {X - 1, Y}],
        [{X - 1, Y - 1}]
    ];
b_star_direction_point(X, Y, TX, TY) when X < TX, Y > TY ->
    [
        [{X + 1, Y - 1}],
        [{X, Y - 1}, {X + 1, Y}],
        [{X - 1, Y - 1}, {X + 1, Y + 1}],
        [{X - 1, Y}, {X, Y + 1}],
        [{X - 1, Y + 1}]
    ];
b_star_direction_point(X, Y, TX, TY) when X > TX, Y < TY ->
    [
        [{X - 1, Y + 1}],
        [{X - 1, Y}, {X, Y + 1}],
        [{X - 1, Y - 1}, {X + 1, Y + 1}],
        [{X, Y - 1}, {X + 1, Y}],
        [{X + 1, Y - 1}]
    ];
b_star_direction_point(X, Y, TX, TY) when X > TX, Y > TY ->
    [
        [{X - 1, Y - 1}],
        [{X - 1, Y}, {X, Y - 1}],
        [{X - 1, Y + 1}, {X + 1, Y - 1}],
        [{X, Y + 1}, {X + 1, Y}],
        [{X + 1, Y + 1}]
    ].


is_blocked_logic(_SceneId, _CopyId, X, Y) ->
    %BlockL = [{4,2}, {4,3}, {4,4}],
    %BlockL = [{4, 1}, {4,2}, {4,3}, {4,4},{4,5}],
    L = lists:seq(1, 20),
    BlockL = [{5 ,3}, {5, 4}, {5 ,5}, {6, 3}, {6, 5}, {7, 3}, {7, 4}, {7, 5}]
    ++ [{X1, 1}||X1<-L]
    ++ [{1, Y1}||Y1<-L]
    ++ [{X1, 20}||X1<-L]
    ++ [{20, Y1}||Y1<-L],
    % BlockL = [
    %     {4, 1}, {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6}, {4, 7},
    %     {10, 1}, {10, 2}, {10, 3}, {10, 4}, {10, 5}, {10, 6}, {10, 7},
    %     {5, 1}, {6, 1}, {8, 1},{9, 1},
    %     {6, 3}, {6, 4}, {6, 5},
    %     {7, 3}, {7, 5},
    %     {8, 3}, {8, 5},
    %     {5, 7}, {6, 7}, {7, 7}, {8, 7},{9, 7}
    % ],
    lists:member({X, Y}, BlockL).

%test() ->
%    a_star_point(6, 4, 0, 0, 6, 3).
