%%%-----------------------------------
%%% @Module  : lib_daily
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.08
%%% @Description: 每天记录器
%%%-----------------------------------
-module(lib_daily).

-include("daily.hrl").
-include("common.hrl").
-export([
         online/1,
         get/4,
         get_all/2,
         get_count/2,
         get_count/4,
         set_count/2,
         set_count/5,
         plus_count/2,
         plus_count/5,
         cut_count/5,
         new/1,
         get_refresh_time/4,
         set_refresh_time/4,
         lessthan_limit/4,
         get_count_limit/2,
         get_count_limit/3,
         is_clear/4,
         update_count_db/7,
         get_count_and_other_from_db/4,
         get_count_and_refresh_time_from_db/4,
         get_config/3,
         apply_cast/3
        ]).

%% 上线操作
online(RoleId) ->
    reload(RoleId).

%% 获取整个记录器
get(RoleId, Module, SubModule, Type) ->
    {Res, Clock} = get_clock(Module, SubModule, Type),
    if
        Res=/= true ->
            #ets_daily{id={Module, SubModule, Type}, count = 99999};
        Clock==?TWELVE ->
            Data = get_all(RoleId, ?TWELVE),
            lists:keyfind({Module, SubModule, Type}, #ets_daily.id, Data);
        true ->
            Data = get_all(RoleId, ?FOUR),
            lists:keyfind({Module, SubModule, Type}, #ets_daily.id, Data)
    end.

%% 取玩家的整个记录
get_all(RoleId, ?TWELVE) ->
    Data =  get(?DAILY_KEY(?TWELVE)),
    case Data =:= undefined of
        true -> TwelveData = reload(RoleId, ?TWELVE);
        false -> TwelveData = Data
    end,
    TwelveData;
get_all(RoleId, ?FOUR) ->
    Data =  get(?DAILY_KEY(?FOUR)),
    case Data =:= undefined of
        true -> FourData = reload(RoleId, ?FOUR);
        false -> FourData = Data
    end,
    FourData.

%% 获取数量
get_count(RoleId, List) ->
    lists:map(
      fun({Module, SubModule, Type} = Id) ->
              Count = get_count(RoleId, Module, SubModule, Type),
              {Id, Count}
      end, List).

get_count(RoleId, Module, SubModule, TypeList) when is_list(TypeList) ->
    F = fun(Type, Acc) -> Acc ++ [{Type, get_count(RoleId, Module, SubModule, Type)}] end,
    lists:foldl(F, [], TypeList);

%% 获取数量
get_count(RoleId, Module, SubModule, Type) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_daily.count
    end.

%% 设置数量
set_count(RoleId, List) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, {FOUR, TWELVE}) ->
            Daily
            = case lib_daily:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_daily{count = Count}
            end,
            case get_clock(Module, SubModule, Type) of
                {_Res, ?TWELVE} ->
                    {FOUR, [Daily|TWELVE]};
                _ ->
                    {[Daily|FOUR], TWELVE}
            end
    end,
    {FourData, TwelveData} = lists:foldl(F, {[], []}, List),
    do_save_batch(RoleId, FourData, ?FOUR),
    do_save_batch(RoleId, TwelveData, ?TWELVE).

set_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_daily{count = Count})
    end.

%% 追加数量
plus_count(RoleId, List) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, {FOUR, TWELVE}) ->
            Daily
            = case lib_daily:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_daily{count = RD#ets_daily.count + Count}
            end,
            case get_clock(Module, SubModule, Type) of
                {_Res, ?TWELVE} ->
                    {FOUR, [Daily|TWELVE]};
                _ ->
                    {[Daily|FOUR], TWELVE}
            end
    end,
    {FourData, TwelveData} = lists:foldl(F, {[], []}, List),
    do_save_batch(RoleId, FourData, ?FOUR),
    do_save_batch(RoleId, TwelveData, ?TWELVE).

%% 追加数量
plus_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count, ?DEFAULT_OTHER]));
        RD -> save(RoleId, RD#ets_daily{count = RD#ets_daily.count + Count})
    end.

%% 扣除数量
cut_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type,  Count, ?DEFAULT_OTHER]));
        RD -> save(RoleId, RD#ets_daily{count = RD#ets_daily.count - Count})
    end.

%% 获取刷新时间
get_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_daily.refresh_time
    end.

%% 更新刷新时间
set_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_daily:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, 0]));
        RD -> save(RoleId, RD)
    end.

new([Module, SubModule, Type, Count]) ->
    new([Module, SubModule, Type, Count, ?DEFAULT_OTHER]);
new([Module, SubModule, Type, Count, Other]) ->
    #ets_daily{
       id              = {Module, SubModule, Type}
              ,count          = Count
              ,other          = Other
              ,refresh_time   = 0
      }.

save(RoleId, RoleDaily) ->
    {ModuleId, SubModuleId, TypeId} = RoleDaily#ets_daily.id,
    {_Res, Clock} = get_clock(ModuleId, SubModuleId, TypeId),
    if
        Clock==?TWELVE ->
            do_save(RoleId, RoleDaily, ?TWELVE);
        true ->
            do_save(RoleId, RoleDaily, ?FOUR)
    end.

do_save(RoleId, RoleDaily, ?TWELVE) ->
    NowTime = utime:unixtime(),
    NewRoleDaily = RoleDaily#ets_daily{refresh_time=NowTime},
    {ModuleId, SubModuleId, TypeId} = NewRoleDaily#ets_daily.id,
    Data = get_all(RoleId, ?TWELVE),
    Data1 = lists:keydelete(NewRoleDaily#ets_daily.id, #ets_daily.id, Data) ++ [NewRoleDaily],
    put(?DAILY_KEY(?TWELVE), Data1),
    db:execute(io_lib:format(?sql_daily_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, NewRoleDaily#ets_daily.count,
                                                   util:term_to_bitstring(NewRoleDaily#ets_daily.other), NowTime]));

do_save(RoleId, RoleDaily, ?FOUR) ->
    NowTime = utime:unixtime(),
    NewRoleDaily = RoleDaily#ets_daily{refresh_time=NowTime},
    {ModuleId, SubModuleId, TypeId} = NewRoleDaily#ets_daily.id,
    Data = get_all(RoleId, ?FOUR),
    Data1 = lists:keydelete(NewRoleDaily#ets_daily.id, #ets_daily.id, Data) ++ [NewRoleDaily],
    put(?DAILY_KEY(?FOUR), Data1),
    db:execute(io_lib:format(?sql_daily_four_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, NewRoleDaily#ets_daily.count,
                                                        util:term_to_bitstring(NewRoleDaily#ets_daily.other), NowTime])).

%% 同时保存多个记录
do_save_batch(_RoleId, [], _) -> ok;
do_save_batch(RoleId, DailyList, ?TWELVE) ->
    NowTime = utime:unixtime(),
    F = fun
        (#ets_daily{id = Id}) ->
            lists:keyfind(Id, #ets_daily.id, DailyList) =:= false
    end,
    Data = get_all(RoleId, ?TWELVE),
    Data1 = DailyList ++ lists:filter(F, Data),
    put(?DAILY_KEY(?TWELVE), Data1),
    ValueStr = ulists:list_to_string([io_lib:format("(~p,~p,~p,~p,~p, '~s', ~p)", [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), NowTime]) || #ets_daily{id = {ModuleId, SubModuleId, TypeId}, count = Count, other = Other} <- DailyList], ","),
    SQL = io_lib:format(?sql_daily_role_upd_batch, [ValueStr]),
    db:execute(SQL);

do_save_batch(RoleId, DailyList, ?FOUR) ->
    NowTime = utime:unixtime(),
    F = fun
        (#ets_daily{id = Id}) ->
            lists:keyfind(Id, #ets_daily.id, DailyList) =:= false
    end,
    Data = get_all(RoleId, ?FOUR),
    Data1 = DailyList ++ lists:filter(F, Data),
    put(?DAILY_KEY(?FOUR), Data1),
    ValueStr = ulists:list_to_string([io_lib:format("(~p,~p,~p,~p,~p, '~s', ~p)", [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), NowTime]) || #ets_daily{id = {ModuleId, SubModuleId, TypeId}, count = Count, other = Other} <- DailyList], ","),
    SQL = io_lib:format(?sql_daily_four_role_upd_batch, [ValueStr]),
    db:execute(SQL).

%% 所有数据重载
reload(RoleId) ->
    erase(?DAILY_KEY(?TWELVE)),
    List1 = db:get_all(io_lib:format(?sql_daily_role_sel_all, [RoleId])),
    D1 = to_dict(List1, []),
    put(?DAILY_KEY(?TWELVE), D1),

    erase(?DAILY_KEY(?FOUR)),
    List2 = db:get_all(io_lib:format(?sql_daily_four_role_sel_all, [RoleId])),
    D2 = to_dict(List2, []),
    put(?DAILY_KEY(?FOUR), D2),
    {D1, D2}.

reload(RoleId, Clock) ->
    case Clock of
        ?TWELVE ->
            erase(?DAILY_KEY(?TWELVE)),
            List1 = db:get_all(io_lib:format(?sql_daily_role_sel_all, [RoleId])),
            D1 = to_dict(List1, []),
            put(?DAILY_KEY(?TWELVE), D1),
            D1;
        ?FOUR ->
            erase(?DAILY_KEY(?FOUR)),
            List2 = db:get_all(io_lib:format(?sql_daily_four_role_sel_all, [RoleId])),
            D2 = to_dict(List2, []),
            put(?DAILY_KEY(?FOUR), D2),
            D2;
        _ -> []
    end.

%% 获取次数上限
get_count_limit(Module, Type) ->
    get_count_limit(Module, ?DEFAULT_SUB_MODULE, Type).

%% 获取次数上限
get_count_limit(Module, SubModule, Type) ->
    case get_config(Module, SubModule, Type) of
        [] -> 0;
        #base_daily{limit = Limit} -> Limit
    end.

%% 未超过限制次数
%% @return [{type, boolean}]
lessthan_limit(RoleId, Module, SubModule, TypeList) when is_list(TypeList) ->
    F = fun(Type, Acc) -> Acc ++ [{Type, lessthan_limit(RoleId, Module, SubModule, Type)}] end,
    lists:foldl(F, [], TypeList);

%% 未超过限制次数
%% @return true未超过|false超过
lessthan_limit(RoleId, Module, SubModule, Type) ->
    %% 后台缺失配置的情况下，直接返回超过次数
    Limit = get_count_limit(Module, SubModule, Type),
    Count = case lib_daily:get(RoleId, Module, SubModule, Type) of
                false -> 0;
                RD -> RD#ets_daily.count
            end,
    Count<Limit.

%% 是否清理
is_clear(Clock, ModuleId, SubModuleId, TypeId) ->
    case get_config(ModuleId, SubModuleId, TypeId) of
        #base_daily{clock = Clock} -> true;
        _ -> false
    end.

update_count_db(RoleId, ModuleId, SubModuleId, TypeId, Count, Other, Time) ->
    case get_config(ModuleId, SubModuleId, TypeId) of
        #base_daily{clock = ?TWELVE} ->
            db:execute(io_lib:format(?sql_daily_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), Time]));
        #base_daily{clock = ?FOUR} ->
            db:execute(io_lib:format(?sql_daily_four_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), Time]));
        _ -> error
    end.

%% 获取次数，扩展数据
%% @return {0, 0}
get_count_and_other_from_db(RoleId, ModuleId, SubModuleId, TypeId) ->
    {Count, _Time, Other} = get_count_info_from_db(RoleId, ModuleId, SubModuleId, TypeId),
    {Count, Other}.

%% 获取次数，刷新时间
%% @return {0, 0}
get_count_and_refresh_time_from_db(RoleId, ModuleId, SubModuleId, TypeId) ->
    {Count, Time, _Other} = get_count_info_from_db(RoleId, ModuleId, SubModuleId, TypeId),
    {Count, Time}.

get_count_info_from_db(RoleId, ModuleId, SubModuleId, TypeId) ->
    case get_config(ModuleId, SubModuleId, TypeId) of
        #base_daily{clock = ?TWELVE} ->
            Sql = io_lib:format(?sql_daily_role_sel, [RoleId, ModuleId, SubModuleId, TypeId]),
            case db:get_row(Sql) of
                [] -> {0, 0, []};
                [Count, RefreshTime, Other] -> {Count, RefreshTime, util:bitstring_to_term(Other)}
            end;
        #base_daily{clock = ?FOUR} ->
            Sql = io_lib:format(?sql_daily_four_role_sel, [RoleId, ModuleId, SubModuleId, TypeId]),
            case db:get_row(Sql) of
                [] -> {0, 0, []};
                [Count, RefreshTime, Other] -> {Count, RefreshTime, util:bitstring_to_term(Other)}
            end;
        _ -> {0, 0, []}
    end.

%% ------------------------- local function -------------------------
to_dict([], D) -> D;
to_dict([[Module, SubModule, Type, Count, Other, Time] | T], D) ->
    to_dict(T, [#ets_daily{id = {Module, SubModule, Type}, count = Count,
                           other = util:bitstring_to_term(Other), refresh_time = Time}|D]).

get_clock(Module, SubModule, Type) ->
    Config = get_config(Module, SubModule, Type),
    case Config of
        [] ->
            {error, ?FOUR};
        #base_daily{clock = Clock} when Clock==?TWELVE orelse Clock==?FOUR->
            {true, Clock};
        #base_daily{clock = Clock} ->
            ?ERR(">>>>> important >>>>> clock config error:~p~n", [{Module, SubModule, Type, Clock}]),
            {error, ?FOUR}
    end.

get_config(Module, SubModule, Type) ->
    case SubModule ==?DEFAULT_SUB_MODULE of
        true -> Config = data_daily:get_id(Module, Type);
        false -> Config = data_daily_extra:get_id(Module, SubModule)
    end,
    case Config of
        [] ->
            tool:back_trace_to_file(),
            ?ERR(">>>>> important >>>>> missing config:~p~n", [{Module, SubModule, Type}]);
        _ -> skip
    end,
    Config.

apply_cast(Mod, Fun, Args) ->
    case catch Mod:Fun(Args) of
        {'EXIT', Error} ->
            ?ERR("~p~n", [Error]);
        _ ->
            ok
    end.
