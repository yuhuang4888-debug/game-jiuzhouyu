%%%-----------------------------------
%%% @Module  : lib_week
%%% @Author  : HHL
%%% @Email   : 1942007864@qq.com
%%% @Created : 2014.07.17
%%% @Description: 每周记录器
%%%-----------------------------------
-module(lib_week).

-include("week.hrl").
-include("common.hrl").
-export([
         online/1,
         get/4,
         get_all/1,
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
         update_count_db/7,
         lessthan_limit/4,
         get_count_limit/2,
         get_count_limit/3,
         get_count_and_other_from_db/4,
         get_count_and_refresh_time_from_db/4,
         get_count_info_from_db/4,
         apply_cast/3
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
            #ets_week{id={ModuleId, SubModule, TypeId}, count = 99999};
        true ->
            Data = get_all(RoleId),
            lists:keyfind({ModuleId, SubModule, TypeId}, #ets_week.id, Data)
    end.

%% 取玩家的整个记录
get_all(RoleId) ->
    Data =  get(?WEEK_KEY),
    case Data =:= undefined of
        true -> reload(RoleId);
        false -> Data
    end.

%% 获取列表计数
get_count(RoleId, TypeList) when is_list(TypeList) ->
    F = fun({Module, SubModule, Type}=Id, Acc) -> 
                [{Id, get_count(RoleId, Module, SubModule, Type)}|Acc] 
        end,
    lists:foldl(F, [], TypeList).

%% 获取数量
get_count(RoleId, Module, SubModule, TypeList) when is_list(TypeList) ->
    [{Type, get_count(RoleId, Module, SubModule, Type)} || Type <- TypeList];

%% 获取数量
get_count(RoleId, Module, SubModule, Type) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_week.count
    end.

%% 设置数量
set_count(RoleId, TypeList) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, L) ->
            D
            = case lib_week:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_week{count = Count}
            end,
            [D|L]
    end,
    CounterList = lists:foldl(F, [], TypeList),
    save_batch(RoleId, CounterList).


set_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_week{count = Count})
    end.

plus_count(RoleId, TypeList) ->
    F = fun
        ({ {Module, SubModule, Type}, Count}, L) ->
            D
            = case lib_week:get(RoleId, Module, SubModule, Type) of
                false ->
                    new([Module, SubModule, Type, Count]);
                RD ->
                    RD#ets_week{count = Count + RD#ets_week.count}
            end,
            [D|L]
    end,
    CounterList = lists:foldl(F, [], TypeList),
    save_batch(RoleId, CounterList).


%% 追加数量
plus_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_week{count = RD#ets_week.count + Count})
    end.

%% 扣除数量
cut_count(RoleId, Module, SubModule, Type, Count) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, Count]));
        RD -> save(RoleId, RD#ets_week{count = RD#ets_week.count - Count})
    end.

%% 获取刷新时间
get_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_week.refresh_time
    end.

%% 更新刷新时间
set_refresh_time(RoleId, Module, SubModule, Type) ->
    case lib_week:get(RoleId, Module, SubModule, Type) of
        false -> save(RoleId, new([Module, SubModule, Type, 0]));
        RD -> save(RoleId, RD)
    end.

new([Module, SubModule, Type, Count]) ->
    new([Module, SubModule, Type, Count, ?DEFAULT_OTHER]);
new([Module, SubModule, Type, Count, Other]) ->
    #ets_week{
       id              = {Module, SubModule, Type}
             ,count          = Count
             ,other          = Other
             ,refresh_time   = 0
      }.

save(RoleId, RoleDaily) ->
    NowTime = utime:unixtime(),
    NewRoleDaily = RoleDaily#ets_week{refresh_time=NowTime},
    {ModuleId, SubModuleId, TypeId} = NewRoleDaily#ets_week.id,
    Data = get_all(RoleId),
    Data1 = lists:keydelete(NewRoleDaily#ets_week.id, #ets_week.id, Data) ++ [NewRoleDaily],
    put(?WEEK_KEY, Data1),
    db:execute(io_lib:format(?sql_week_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, NewRoleDaily#ets_week.count,
                                                  util:term_to_bitstring(NewRoleDaily#ets_week.other), NowTime])).

save_batch(_RoleId, []) -> ok;
save_batch(RoleId, CounterList) ->
    NowTime = utime:unixtime(),
    F = fun
        (#ets_week{id = Id}) ->
            lists:keyfind(Id, #ets_week.id, CounterList) =:= false
    end,
    Data = get_all(RoleId),
    Data1 = CounterList ++ lists:filter(F, Data),
    put(?WEEK_KEY, Data1),
    ValueStr = ulists:list_to_string([io_lib:format("(~p,~p,~p,~p,~p, '~s', ~p)", [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), NowTime]) || #ets_week{id = {ModuleId, SubModuleId, TypeId}, count = Count, other = Other} <- CounterList], ","),
    SQL = io_lib:format(?sql_week_role_upd_beach, [ValueStr]),
    db:execute(SQL).

%% 所有数据重载
reload(RoleId) ->
    erase(?WEEK_KEY),
    List = db:get_all(io_lib:format(?sql_week_role_sel_all, [RoleId])),
    D = to_dict(List, []),
    put(?WEEK_KEY, D),
    D.

%% 获取次数上限
get_count_limit(Module, Type) ->
    get_count_limit(Module, ?DEFAULT_SUB_MODULE, Type).

%% 获取次数上限
get_count_limit(Module, SubModule, Type) ->
    case get_config(Module, SubModule, Type) of
        [] -> 0;
        #base_week{limit = Limit} -> Limit
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
    Count = case lib_week:get(RoleId, Module, SubModule, Type) of
                false -> 0;
                RD -> RD#ets_week.count
            end,
    Count<Limit.

%% 直接操作数据库，适合在玩家不在线的时候调用
update_count_db(RoleId, ModuleId, SubModuleId, TypeId, Count, Other, Time) ->
    db:execute(io_lib:format(?sql_week_role_upd, [RoleId, ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), Time])).

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
        #base_week{} ->
            Sql = io_lib:format(?sql_week_role_sel, [RoleId, ModuleId, SubModuleId, TypeId]),
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
    to_dict(T, D ++ [#ets_week{id             = {Module, SubModule, Type},
                               count          = Count,
                               other          = util:bitstring_to_term(Other),
                               refresh_time   = Time
                              }]).

get_id(Module, SubModule, Type) ->
    Config = get_config(Module, SubModule, Type),
    case Config of
        [] ->
            {error, Module, Type};
        #base_week{} ->
            {true, Module, Type}
    end.

get_config(Module, SubModule, Type) ->
    case SubModule ==?DEFAULT_SUB_MODULE of
        true -> Config = data_week:get_id(Module, Type);
        false -> Config = data_week_extra:get_id(Module, SubModule)
    end,
    case Config of
        [] ->
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
