%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2019, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2019 3:37
%%%-------------------------------------------------------------------
-module(lib_adventure_util).
-author("whao").


-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("adventure.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").

-compile(export_all).

%% 获取当前活动期数
get_act_stage() ->
    OpenList = lib_adventure_util:get_open(),
    case OpenList == [] of
        true -> 0;
        false ->
            Info = hd(OpenList),
            Info#adventure_info_cfg.stage
    end.


%%获取开启的活动
get_open() ->
    StageList = data_adventure:get_all_stage(),
    AllInfo = [data_adventure:get_adventure_info(Stage) || Stage <- StageList],
    get_open(AllInfo, []).

get_open([], List) ->
    List;
get_open([Info | T], List) ->
    case is_record(Info, adventure_info_cfg) of
        false -> get_open(T, List);
        true ->
            case is_open(Info) of
                false -> get_open(T, List);
                TimeList when is_list(TimeList) -> get_open(T, [Info | List]);
                _ -> get_open(T, List)
            end
    end.

%%  判断是否开启
is_open(Info) when is_record(Info, adventure_info_cfg) ->
    #adventure_info_cfg{
        open_day = OpenDay,
        merge_day = MergeDay,
        start_time = StartTime,
        end_time = EndTime
    } = Info,
    Condition = [
        {open_day, OpenDay},
        {merge_day, MergeDay},
        {act_time, StartTime, EndTime}
    ],
    case check_condition_list(Condition) of
        true -> [{StartTime, EndTime}];
        false -> false
    end;
is_open(_Info) -> false.




%%判断条件
check_condition_list([]) -> true;
check_condition_list([T | Condition]) ->
    case check_condition(T) of
        true -> check_condition_list(Condition);
        false -> false
    end.

check_condition({open_day, OpenDay}) ->
    case OpenDay of
        [OpenTime, CloseTime] ->
            SOpenDay = util:get_open_day(),
%%            ?PRINT("open_day SOpenDay :~p  ~p~n",[SOpenDay, SOpenDay >= OpenTime andalso SOpenDay =< CloseTime]),
            SOpenDay >= OpenTime andalso SOpenDay =< CloseTime;
        _ -> true
    end;
check_condition({merge_day, MergeDay}) ->
    case MergeDay of
        [OpenTime, CloseTime] ->
            SOpenDay = util:get_merge_day(),
%%            ?PRINT("merge_day SOpenDay~p  ~p~n",[SOpenDay, SOpenDay >= OpenTime andalso SOpenDay =< CloseTime]),
            SOpenDay >= OpenTime andalso SOpenDay =< CloseTime;
        _ -> true
    end;
check_condition({lack_day, LimitDays, OpenDay, StartTime}) ->
    Time = (OpenDay - 1) * 86400,
    OpenTime = util:get_open_time() + Time,
    LSTime = StartTime + LimitDays * 86400,
    OpenTime < LSTime;
check_condition({act_time, StartTime, EndTime}) ->
    Now = utime:unixtime(),
%%    ?PRINT("act_time   ~p~n",[Now >= StartTime andalso Now =< EndTime]),
    Now >= StartTime andalso Now =< EndTime;
check_condition(_) ->
    true.






%% ---------------------------------- db函数 -----------------------------------
db_adventure_select(RoleId) ->
    Sql = io_lib:format(?sql_adventure_select, [RoleId]),
    db:get_row(Sql).

db_adventure_replace(RoleId, Data) ->
    #status_adventure{
        stage = Stage,
        circle = Circle,
        location = Location,
        gain_list = GainLucky,
        shop_goods = ShopGoods,
        last_time = LastTime
    } = Data,
    GLucky = util:term_to_bitstring(GainLucky),
    NewShopGoods = util:term_to_bitstring(ShopGoods),
    Sql = io_lib:format(?sql_adventure_replace, [RoleId, Stage, Circle, Location, GLucky, NewShopGoods, LastTime]),
    db:execute(Sql).



