%%%-----------------------------------
%%% @Module  : lib_counter
%%% @Author  : hek
%%% @Created : 2016.10.18
%%% @Description: 终生次数记录器
%%%-----------------------------------
-module(lib_counter).

-include("counter.hrl").
-include("common.hrl").
-export(
    [
        online/1,
        get/4,
        get_all/1,
        get_count/2,
        get_count/4,
        set_count/2,
        set_count/5,
        set_count/6,
        plus_count/2,
        plus_count/5,
        cut_count/5,
        new/1,
        get_refresh_time/4,
        set_refresh_time/4,
        get_count_and_refresh_time/2,
        lessthan_limit/4,
        get_count_limit/2,
        get_count_limit/3,
        update_count_db/7,
        get_count_and_other_from_db/4,
        get_count_and_refresh_time_from_db/4,
        get_count_info_from_db/4,
        get_count_from_db/4,
        apply_cast/3
        , clear/4
        , db_clear/4
        , db_clear/3
        , get_other_data/4
    ]
).

%% 上线操作
online(RoleId) ->
    reload(RoleId).

%% 获取整个记录器
get(RoleId, Module, SubModule, Type) ->
    {Res, ModuleId, TypeId} = get_id(Module, SubModule, Type),
    if
        Res=/=true ->
            #ets_counter{id={ModuleId, SubModule, TypeId}, count = 99999};
        true ->
            Data = get_all(RoleId),
            lists:keyfind({ModuleId, SubModule, TypeId}, #ets_counter.id, Data)
    end.

%% 取玩家的整个记录
get_all(RoleId) ->
    Data =  get(?COUNTER_KEY),
    case Data =:= undefined of
        true -> reload(RoleId);
        false -> Data
    end.

%% 获取数量
get_count(RoleId, List) ->
    lists:map(
      fun({Module, SubModule, Type} = Id) ->
              Count = get_count(RoleId, Module, SubModule, Type),
              {Id, Count}
      end, List).

%% 获取数量
get_count(RoleId, Module, SubModule, TypeList) when is_list(TypeList) ->
    % F = fun(Type, Acc) -> Acc ++ [{Type, get_count(RoleId, Module, SubModule, Type)}] end,
    [{Type, get_count(RoleId, Module, SubModule, Type)} || Type <- TypeList];
    % lists:foldl(F, [], TypeList);

%% 获取数量
get_count(RoleId, Module, SubModule, Type) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_counter.count
    end.

%% 设置数量
set_count(RoleId, List) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, L) when is_integer(Count) ->
            D
            = case lib_counter:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_counter{count = Count}
            end,
            [D|L];
        ({ {Module, SubModule, Type}, {Count, Other}}, L) ->
            D
            = case lib_counter:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count, Other]);
                RD ->
                    RD#ets_counter{count = Count, other = Other}
            end,
            [D|L]
    end,
    CounterList = lists:foldl(F, [], List),
    save_batch(RoleId, CounterList).

%% 设置数量
set_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_counter{count = Count})
    end.

%% 设置数量
set_count(RoleId, Module, SubModule, Type, Count, RefreshTime) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]), RefreshTime);
        RD -> save(RoleId, RD#ets_counter{count = Count}, RefreshTime)
    end.

%% 追加数量
plus_count(RoleId, List) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, L) ->
            D
            = case lib_counter:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_counter{count = Count + RD#ets_counter.count}
            end,
            [D|L]
    end,
    CounterList = lists:foldl(F, [], List),
    save_batch(RoleId, CounterList).

%% 追加数量
plus_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_counter{count = RD#ets_counter.count + Count})
    end.

%% 扣除数量
cut_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, Type, Count]));
        RD -> save(RoleId, RD#ets_counter{count = RD#ets_counter.count - Count})
    end.

%% 获取刷新时间
get_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_counter.refresh_time
    end.

%% 更新刷新时间
set_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, 0]));
        RD -> save(RoleId, RD)
    end.

%% 获得次数和刷新时间
get_count_and_refresh_time(RoleId, List) ->
    lists:map(fun({Module, SubModule, Type} = Id) ->
        Count = get_count(RoleId, Module, SubModule, Type),
        RefreshTime = get_refresh_time(RoleId, Module, SubModule, Type),
        {Id, Count, RefreshTime}
    end, List).

get_other_data(RoleId, Module, SubModule, Type) ->
    case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> [];
        RD -> RD#ets_counter.other
    end.

%% 清理记录
clear(RoleId, Module, SubModule, TypeList) ->
    db_clear(RoleId, Module, SubModule, TypeList),
    CounterList = [{Module, SubModule, Type}||Type<-TypeList],
    F = fun
        (#ets_counter{id = Id}) ->
            lists:member(Id, CounterList) =:= false
    end,
    Data = get_all(RoleId),
    Data1 = lists:filter(F, Data),
    put(?COUNTER_KEY, Data1),
    ok.

new([Module, SubModule, Type, Count]) ->
    new([Module, SubModule, Type, Count, ?COUNTER_DEFAULT_OTHER]);
new([Module, SubModule, Type, Count, Other]) ->
    #ets_counter{
        id              = {Module, SubModule, Type}
        ,count          = Count
        ,other          = Other
        ,refresh_time   = 0
    }.

save(RoleId, RoleDaily) ->
    NowTime = utime:unixtime(),
    save(RoleId, RoleDaily, NowTime).

save(RoleId, RoleDaily, RefreshTime) ->
    NewRoleDaily = RoleDaily#ets_counter{refresh_time=RefreshTime},
    {ModuleId, SubModuleId, TypeId} = NewRoleDaily#ets_counter.id,
    Data = get_all(RoleId),
    Data1 = lists:keydelete(NewRoleDaily#ets_counter.id, #ets_counter.id, Data) ++ [NewRoleDaily],
    put(?COUNTER_KEY, Data1),
    db:execute(io_lib:format(?sql_counter_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, NewRoleDaily#ets_counter.count, 
        util:term_to_bitstring(NewRoleDaily#ets_counter.other), RefreshTime])).

save_batch(_RoleId, []) -> ok;
save_batch(RoleId, CounterList) ->
    NowTime = utime:unixtime(),
    F = fun
        (#ets_counter{id = Id}) ->
            lists:keyfind(Id, #ets_counter.id, CounterList) =:= false
    end,
    Data = get_all(RoleId),
    Data1 = CounterList ++ lists:filter(F, Data),
    put(?COUNTER_KEY, Data1),
    ValueStr = ulists:list_to_string([io_lib:format("(~p,~p,~p,~p,~p, '~s', ~p)", [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), NowTime]) || #ets_counter{id = {ModuleId, SubModuleId, TypeId}, count = Count, other = Other} <- CounterList], ","),
    SQL = io_lib:format(?sql_counter_role_upd_batch, [ValueStr]),
    db:execute(SQL).

%% 清理
db_clear(_RoleId, _Module, _SubModule, []) -> ok;
db_clear(RoleId, Module, SubModule, TypeList) ->
    F = fun(Key, String) -> 
        case String of
            "" -> io_lib:format("~w", [Key]);
            _ -> io_lib:format("~ts, ~w", [String, Key])
        end
    end,
    DelStr = lists:foldl(F, "", TypeList),
    SQL = io_lib:format(?sql_counter_role_clear_by_role_and_type_list, [RoleId, Module, SubModule, DelStr]),
    db:execute(SQL).

db_clear(_Module, _SubModule, []) -> ok;
db_clear(Module, SubModule, TypeList) ->
    F = fun(Key, String) -> 
        case String of
            "" -> io_lib:format("~w", [Key]);
            _ -> io_lib:format("~ts, ~w", [String, Key])
        end
    end,
    DelStr = lists:foldl(F, "", TypeList),
    SQL = io_lib:format(?sql_counter_role_clear_by_type_list, [Module, SubModule, DelStr]),
    db:execute(SQL).

%% 所有数据重载
reload(RoleId) ->
    erase(?COUNTER_KEY),
    List = db:get_all(io_lib:format(?sql_counter_role_sel_all, [RoleId])),
    D = to_dict(List, []),
    put(?COUNTER_KEY, D),
    D.

%% 获取次数上限
get_count_limit(Module, Type) ->
    get_count_limit(Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

get_count_limit(Module, SubModule, Type) ->
    case get_config(Module, SubModule, Type) of
        [] -> 0;
        #base_counter{limit = Limit} -> Limit
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
    Count = case lib_counter:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_counter.count
    end,
    Count<Limit.

%% 直接操作数据库，适合在玩家不在线的时候调用
update_count_db(RoleId, ModuleId, SubModuleId, TypeId, Count, Other, Time) ->
    db:execute(io_lib:format(?sql_counter_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), Time])).

%% 获取次数
%% @return Count|[{TypeId, Count}]
get_count_from_db(RoleId, ModuleId, SubModuleId, TypeIds) when is_list(TypeIds) ->
    do_get_count_from_db(RoleId, ModuleId, SubModuleId, TypeIds);
get_count_from_db(RoleId, ModuleId, SubModuleId, TypeId) ->
    case do_get_count_from_db(RoleId, ModuleId, SubModuleId, [TypeId]) of
        [{TypeId, Count}] -> Count;
        _ -> 0
    end.

do_get_count_from_db(RoleId, ModuleId, SubModuleId, TypeIds) ->
    F = fun(T, {Acc1, Acc2}) ->
        case get_config(ModuleId, SubModuleId, T) of
            #base_counter{} -> {Acc1, [T|Acc2]};
            _ -> {[{T, 0}|Acc1], [T|Acc2]}
        end
    end,
    {CounterList, SelL} = lists:foldl(F, {[], []}, TypeIds),
    List1 = case SelL =/= [] of
        true ->
            Sql = io_lib:format(?sql_counter_role_sel_count, [RoleId, ModuleId, SubModuleId, util:link_list(SelL)]),
            List = db:get_all(Sql),
            [{TType, TCount} || [TType, TCount] <- List];
        false -> []
    end,
    F1 = fun(Key) ->
        case lists:keyfind(Key, 1, List1) of
            {Key, Val} ->
                {Key, Val};
            _ ->
                {Key, 0}
        end
    end,
    List2 = lists:map(F1, SelL),
    CounterList ++ List2.

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
        #base_counter{} ->
            Sql = io_lib:format(?sql_counter_role_sel, [RoleId, ModuleId, SubModuleId, TypeId]),
            case db:get_row(Sql) of
                [] -> {0, 0, []};
                [Count, RefreshTime, Other] -> {Count, RefreshTime, util:bitstring_to_term(Other)}
            end;
        _ -> {0, 0, []}
    end.

%% ------------------------- local function -------------------------
to_dict([], D) ->
    D;
to_dict([[Module, SubModule, Type, Count, Other, Time] | T], D) ->
    to_dict(T, D ++ [#ets_counter{
            id              = {Module, SubModule, Type}
            ,count          = Count
            ,other          = util:bitstring_to_term(Other)
            ,refresh_time   = Time
        }]).

get_id(Module, SubModule, Type) ->
    Config = get_config(Module, SubModule, Type),
    case Config of
        [] ->
            {error, Module, Type};
        #base_counter{} ->
            {true, Module, Type}
    end.

get_config(Module, SubModule, Type) ->
    case SubModule ==?COUNTER_DEFAULT_SUB_MODULE of
        true -> Config = data_counter:get_id(Module, Type);
        false -> Config = data_counter_extra:get_id(Module, SubModule)
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