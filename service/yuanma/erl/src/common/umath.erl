%% ---------------------------------------------------------------------------
%% @doc umake
%% @author ming_up@foxmail.com
%% @since  2016-09-09
%% @deprecated 数学运算 TODO nif化
%% ---------------------------------------------------------------------------
-module(umath).

-export([
         distance/2                 %% 平面上两点距离
        , distance_pow/2            %% 平面上两点距离平方
        , try_round_on_equal/1      %% 相等情况下,取整
        , degree_to_radian/1        %% 角度转换为弧度
        , radian_to_degree/1        %% 弧度转换为角度
        , radian_to_360degree/1     %% 弧度转换为360度
        , get_distance/4            %% 通过经纬度坐标获取地表距离
        , rand_point_in_circle/4    %% 在圆上随机选取一点
        ]).

-export([
    ceil/1, floor/1
]).


%% ---------------------------------------------------------------------------
%% @doc 计算两个经纬度的距离
-spec get_distance(RawLng1, RawLat1, RawLng2, RawLat2) -> Result when
      RawLng1     :: integer(),       %% 经度1 * 1000,未处理
      RawLat1     :: integer(),       %% 纬度1 * 1000,未处理
      RawLng2     :: integer(),       %% 经度2 * 1000,未处理
      RawLat2     :: integer(),       %% 纬度2 * 1000,未处理
      Result      :: integer().       %% 距离(米)
%% @end
%% ---------------------------------------------------------------------------
get_distance(RawLng1, RawLat1, RawLng2, RawLat2) ->
    %% io:format("~n=uti:~p==",[[RawLat1, RawLng1, RawLat2, RawLng2]]),
    Lat1 = RawLat1 / 1000,
    Lng1 = RawLng1 / 1000,
    Lat2 = RawLat2 / 1000,
    Lng2 = RawLng2 / 1000,
    Rad = fun(D) -> D * math:pi() / 180.0 end,
    EARTH_RADIUS = 6378.137,
    RadLat1 = Rad(Lat1),
    RadLat2 = Rad(Lat2),
    A = RadLat1 - RadLat2,
    B = Rad(Lng1) - Rad(Lng2),
    S = 2 * math:asin(math:sqrt(math:pow(math:sin(A/2), 2) + 
                                    math:cos(RadLat1) * math:cos(RadLat2) * math:pow(math:sin(B/2), 2))),
    NewS = S * EARTH_RADIUS,
    NewS1 = round(NewS * 10000) / 10000,
    round(NewS1 * 1000).

%% ---------------------------------------------------------------------------
%% @doc 获得圆内随机一点的坐标 
-spec rand_point_in_circle(CenterX, CenterY, Radius, Type) -> {X, Y} when
      CenterX     :: integer(),       %% 圆心坐标X
      CenterY     :: integer(),       %% 圆心坐标Y
      Radius      :: integer(),       %% 圆半径
      Type        :: integer(),       %% 类型:1圆内随机一点|2圆边随机一点
      X           :: integer(),       %% 坐标X
      Y           :: integer().       %% 坐标Y
%% ---------------------------------------------------------------------------
rand_point_in_circle(CenterX, CenterY, Radius, Type) ->
    %% 随机半径
    if
        Type==1 ->
            RandRadius = urand:rand(0, Radius);
        true ->
            RandRadius = Radius
    end,
    %% 随机角度
    RandAngle = urand:rand(0, 360),
    Pi = math:pi(),
    AngleAsNum = (2 * Pi / 360) * RandAngle,

    X = util:floor( CenterX + RandRadius * math:cos(AngleAsNum) ),
    Y = util:floor( CenterY + RandRadius * math:sin(AngleAsNum) ),
    %% Distance = (CenterX - X) * (CenterX - X) + (CenterY - Y) * (CenterY - Y),
    %% D = math:sqrt(Distance),
    %% {X, Y, D},
    {X, Y}.

%% 平面坐标亮点距离
distance({X1, Y1}, {X2, Y2}) -> 
    %util:ceil( math:sqrt(math:pow(X1-X2, 2) + math:pow(Y1-Y2, 2)) ).
    util:ceil( math:sqrt(math:pow(X1-X2, 2) + 4 * math:pow(Y1-Y2, 2)) ).

%% 平面坐标亮点距离平方
distance_pow({X1, Y1}, {X2, Y2}) ->
    % math:pow(X1-X2, 2) + math:pow(Y1-Y2, 2).
    math:pow(X1-X2, 2) + 4 * math:pow(Y1-Y2, 2).

%% 相等情况下,取整
try_round_on_equal(X) ->
    RoundX = round(X),
    case RoundX == X of
        true -> RoundX;
        false -> X
    end.

%% 角度转换为弧度
degree_to_radian(Degree) -> 
    math:pi()*(Degree/180).

%% 弧度转换为角度
radian_to_degree(Radian) -> 
    Radian*180/math:pi().

%% 弧度转换为0-360度
radian_to_360degree(Radian) -> 
    D = Radian*180/math:pi(),
    case D < 0 of 
        true  -> util:floor(D+360);
        false -> util:floor(D) 
    end.


%%向上取整
ceil(N) ->
    T = trunc(N),
    case N == T of
        true  -> T;
        false -> 1 + T
    end.

%%向下取整
floor(X) ->
    T = trunc(X),
    case (X < T) of
        true -> T - 1;
        _ -> T
    end.
