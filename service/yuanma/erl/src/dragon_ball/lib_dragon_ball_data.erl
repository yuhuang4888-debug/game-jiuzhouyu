%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_dragon_ball_data.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-10-31
%%% @modified
%%% @description    龙珠功能数据处理库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_dragon_ball_data).

-include("dragon_ball.hrl").
-include("errcode.hrl").

-export([]).

-compile(export_all).

%%% =========================================== make/load ==========================================

make_record(Type, Args) ->
    throw({'EXIT', {"make record error", {Type, Args}}}).

%%% ========================================= get/set/calc =========================================

%% 获取龙珠套装figure_id
get_dragon_figure_id(StatusDragonBall) ->
    #status_dragon_ball{figure_type = Type, figure_list = List} = StatusDragonBall,
    case lists:keyfind(Type, 1, List) of
        false -> FigureId = 0;
        {_, Lv} ->
            #base_dragon_ball_figure{id = FigureId} = data_dragon_ball:get_dragon_figure(Type, Lv)
    end,
    FigureId.

get_dragon_figure_id_db(RoleId) ->
    [_Statue, FigureType, FigureList, _NuclearBuy] = lib_dragon_ball_data:db_select_dragon_ball_statue(RoleId),
    get_dragon_figure_id(#status_dragon_ball{figure_type = FigureType, figure_list = FigureList}).

%% 是否能激活请求的套装
%% @return true | {false, ErrCode}
check_active_dragon_figure(StatusDragonBall, Type, Lv) ->
    DragonFigure = data_dragon_ball:get_dragon_figure(Type, Lv),
    #status_dragon_ball{figure_list = FigureList} = StatusDragonBall,
    {_, CurLv} = ulists:keyfind(Type, 1, FigureList, {Type, 0}),

    if
        not is_record(DragonFigure, base_dragon_ball_figure) -> {false, ?MISSING_CONFIG};
        CurLv >= Lv -> {false, ?ERRCODE(err143_had_active_figure)};
        true ->
            #base_dragon_ball_figure{conditions = Conditions} = DragonFigure,
            check_active_dragon_figure(Conditions, StatusDragonBall)
    end.

check_active_dragon_figure([], _) -> true;

check_active_dragon_figure([{pre, PreType, PreLv} | T], StatusDragonBall) ->
    #status_dragon_ball{figure_list = FigureList} = StatusDragonBall,
    {_, CurLv} = ulists:keyfind(PreType, 1, FigureList, {PreType, 0}),
    if
        CurLv < PreLv -> {false, ?ERRCODE(err143_last_figure_not_active)};
        true -> check_active_dragon_figure(T, StatusDragonBall)
    end;

check_active_dragon_figure([{dragon_ball, N, Lv} | T], StatusDragonBall) ->
    #status_dragon_ball{items = Items} = StatusDragonBall,
    MatchItems = [Item || {_, ItemLv, _} = Item <- Items, ItemLv >= Lv],
    case length(MatchItems) >= N of
        true -> check_active_dragon_figure(T, StatusDragonBall);
        false -> {false, ?ERRCODE(err143_figure_not_enough_balls)}
    end;

check_active_dragon_figure([_ | T], StatusDragonBall) ->
    check_active_dragon_figure(T, StatusDragonBall).

%%% ============================================== sql =============================================

sql(Func, Expr, Args) ->
    Sql = io_lib:format(Expr, Args),
    db:Func(Sql).

db_select_dragon_ball_statue(RoleId) ->
    case sql(get_row, ?sql_select_dragon_ball_statue, [RoleId]) of
        [] -> [?UNACTIVE, 0, [], []];
        [Statue, FigureType, FigureListBin, NuclearBuyBin] -> [Statue, FigureType, util:bitstring_to_term(FigureListBin), util:bitstring_to_term(NuclearBuyBin)]
    end.

db_replace_dragon_ball_statue(RoleId, DragonBall) ->
    #status_dragon_ball{
        statue = Statue,
        figure_type = FigureType,
        figure_list = FigureList,
        nuclear_buy = NuclearBuy
    } = DragonBall,
    FigureListBin = util:term_to_bitstring(FigureList),
    NuclearBuyBin = util:term_to_bitstring(NuclearBuy),
    sql(execute, ?sql_replace_dragon_ball_statue, [RoleId, Statue, FigureType, FigureListBin, NuclearBuyBin]).