%% ---------------------------------------------------------------------------
%% @doc lib_scene_path
%% @author ming_up@foxmail.com
%% @since  2017-05-18
%% @deprecated  A*寻路, 在mod_scene_mark进程下执行
%% ---------------------------------------------------------------------------
-module(lib_scene_path).

-export([find_path/5]).

-include("scene.hrl").
-include("common.hrl").
-record(point, {xy,g,h,f,last_point}).

find_path(SceneId, OXpx, OYpx, TXpx, TYpx) -> 
    {TX, TY} = lib_scene_calc:pixel_to_logic_coordinate(TXpx, TYpx),
    {OX, OY} = lib_scene_calc:pixel_to_logic_coordinate(OXpx, OYpx),
    case (TX==OX andalso TY==OY) orelse lib_scene:is_blocked_logic(SceneId, 0, TX, TY) of
        true  -> false;
        false -> 
            SceneR = data_scene:get(SceneId),

            Xmax = max(0, util:ceil((SceneR#ets_scene.height-?LENGTH_UNIT) / ?LENGTH_UNIT)),
            Ymax = max(0, util:ceil((SceneR#ets_scene.height-?WIDTH_UNIT) / ?WIDTH_UNIT)), 

            Start = #point{xy= {OX,OY}, g = 0, h = 0, f = 0, last_point=false},  
            OpenList = [Start],
            Closes = #{}, 
            case find(OpenList, Closes, SceneId, TX, TY, Xmax, Ymax, 0) of
                error -> ?PRINT("========= find_path too long scene_id:~w, start:~w, end:~w~n", [SceneId, {OXpx, OYpx},{TXpx, TYpx}]), false;
                false -> false;
                Res -> ?PRINT("find path sucess ~n", []), Res
            end
    end.

find([], _Closes, _Scene, _Xed, _Yed, _Xmax, _Ymax, _N) -> false;
find(_OpenList, _Closes, _Scene, _Xed, _Yed, _Xmax, _Ymax, N) when N > 10000 -> error;
find(OpenList, Closes, Scene, Xed, Yed, Xmax, Ymax, N) ->  
    {MinPoint, OpenList1} = get_min_from_openl(OpenList), 
    case MinPoint#point.xy == {Xed, Yed} of 
        true  -> get_whole_path(MinPoint, Closes, [], 1);
        false -> 
            {OpenList2, Closes1} = check_around(Scene, OpenList1, Closes, MinPoint, Xed, Yed, Xmax, Ymax, point_dir(MinPoint#point.xy) ),
            find(OpenList2, Closes1#{MinPoint#point.xy=>MinPoint}, Scene, Xed, Yed, Xmax, Ymax, N+1)  
    end.  

get_min_from_openl(OpenList) ->  
    Point = get_min_from_openl_helper(infinity, false, OpenList),
    NewOpenList = lists:delete(Point, OpenList),  
    {Point, NewOpenList}.
get_min_from_openl_helper(_MinValue, MinPoint, []) -> MinPoint;  
get_min_from_openl_helper(MinValue, MinPoint, [Point | RestList]) ->  
    case Point#point.f < MinValue of 
        true  -> get_min_from_openl_helper(Point#point.f, Point, RestList);  
        false -> get_min_from_openl_helper(MinValue, MinPoint, RestList)  
    end.

check_around(_Scene, OpenList, Closes, _MinPoint, _Xed, _Yed, _Xmax, _Ymax, []) -> {OpenList, Closes};  
check_around(Scene, OpenList, Closes, MinPoint, Xed, Yed, Xmax, Ymax, [{X, Y}=H | Rest]) ->  
    case X > Xmax orelse Y > Ymax orelse lib_scene:is_blocked_logic(Scene, 0, X, Y) of
        true -> check_around(Scene, OpenList, Closes, MinPoint, Xed, Yed, Xmax, Ymax, Rest);  
        false ->  
            CurPoint    = make_point(MinPoint, X, Y, Xed, Yed),
            OpenPoint   = lists:keyfind({X,Y}, #point.xy, OpenList),
            ClosePoint  = maps:get(H, Closes, false),
            if 
                OpenPoint =:= false andalso ClosePoint =:= false -> 
                    OpenList1  = [CurPoint|OpenList],
                    Closes1 = Closes;
                OpenPoint#point.g > CurPoint#point.g -> %% 在open集合中并且集合g值比经过MinPoint后的g值大，则当前点的last_point要重新指向MinPoint
                    OpenList1  = lists:keyreplace({X,Y}, #point.xy, OpenList, CurPoint),
                    Closes1 = Closes;
                ClosePoint#point.g > CurPoint#point.g -> %% 同理，此点要重新评估
                    OpenList1  = [CurPoint|OpenList],
                    Closes1 = maps:remove(ClosePoint#point.xy, Closes);
                true -> 
                    OpenList1  = OpenList,  
                    Closes1 = Closes
            end,
            check_around(Scene, OpenList1, Closes1, MinPoint, Xed, Yed, Xmax, Ymax, Rest)  
    end.
 
make_point(#point{xy={Xp, Yp}, g=Gp}, X, Y, Xed, Yed) ->  
    V = case Xp == X orelse Yp == Y of  
        true  -> 10;
        false -> 14
    end,
    G = Gp + V,
    H = 10*(abs(X-Xed) + abs(Y-Yed)),
    F = G + H, 
    #point{xy={X, Y}, g=G, h=H, f=F, last_point={Xp, Yp}}.    

point_dir({X, Y}) -> 
    [
        {X-1, Y},
        {X-1, Y+1},
        {X,   Y+1},
        {X+1, Y+1},
        {X+1, Y},
        {X+1, Y-1},
        {X,   Y-1},
        {X-1, Y-1}
    ].

%% 获取整个路径
get_whole_path(false, _Closes, Path, _Count) -> Path;
get_whole_path(#point{xy={X,Y}, last_point=LPoint}, Closes, Path, Count) when Count rem 2 == 0  ->  
    {Xpx, Ypx} = lib_scene_calc:logic_to_pixel_coordinate(X,Y),
    get_whole_path(maps:get(LPoint, Closes, false), Closes, [{Xpx, Ypx} | Path], Count+1);
get_whole_path(#point{last_point=LPoint}, Closes, Path, Count) -> 
    get_whole_path(maps:get(LPoint, Closes, false), Closes, Path, Count+1).

