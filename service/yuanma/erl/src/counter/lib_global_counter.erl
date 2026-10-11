%%%-----------------------------------
%%% @Module  : lib_global_counter
%%% @Author  : hek
%%% @Created : 2016.10.18
%%% @Description: 全服次数记录器(合服重置，跟玩家没有关系)
%%%-----------------------------------
-module(lib_global_counter).

-include("counter_global.hrl").
-include("common.hrl").
-include("def_module.hrl").

-export([
         global_counter_init/0,
         get/3,
         get_all/0,
         get_count/2,
         get_count/3,
         set_count/1,
         set_count/4,
         plus_count/4,
         cut_count/4,
         clean/0,
         new/1,
         get_refresh_time/3,
         set_refresh_time/3,
         lessthan_limit/3,
         get_count_limit/3,
         update_count_db/7,
         get_count_and_other_from_db/3,
         get_count_and_refresh_time_from_db/3,
         get_count_info_from_db/3
        ]).

%% 特殊的掉落获取次数:会更新第一次计数时间
%% mod_global_counter:get_count([{150,1,38040001}], [{global_diff_day, 7}]).


%% 操作
global_counter_init() ->
    reload().

%% 获取整个记录器
get(ModuleId, SubModule, TypeId) ->
    {Res, ModuleId, TypeId} = get_id(ModuleId, SubModule, TypeId),
    if
        Res=/=true ->
            #ets_global_counter{id={ModuleId, SubModule, TypeId}, count = 99999};
        true ->
            Data = get_all(),
            lists:keyfind({ModuleId, SubModule, TypeId}, #ets_global_counter.id, Data)
    end.

%% 获取整个记录
get_all() ->
    Data =  get(?COUNTER_GLOBAL_KEY),
    case Data =:= undefined of
        true -> reload();
        false -> Data
    end.

%% 特殊参数获取数量
get_count(List, [{global_diff_day, LimitDay}|_]) ->
    NowTime = utime:unixtime(),
    Fun = fun({Module, SubModule, Type} = Id) ->
                  Count1 = case lib_global_counter:get(Module, SubModule, Type) of
                               false -> 0;
                               #ets_global_counter{first_time = FirstTime, count = Count} = RD ->
                                   if
                                       FirstTime + LimitDay*?ONE_DAY_SECONDS > NowTime -> Count;
                                       true ->
                                           NewFirstTime = get_first_time_by_mod_and_submod(Module, SubModule, Type),
                                           NewRD = RD#ets_global_counter{first_time = NewFirstTime, count = 0},
                                           save(NewRD),
                                           0
                                   end
                           end,
                  {Id, Count1}
          end,
    [Fun(Id) || Id <- List];

%% 正常获取数量
get_count(List, _Args) ->
    lists:map(fun({Module, SubModule, Type} = Id) ->
                      Count = get_count(Module, SubModule, Type),
                      {Id, Count}
              end, List).

%% 同一个功能类型下批量的获取数量
get_count(Module, SubModule, TypeList) when is_list(TypeList) ->
    F = fun(Type, Acc) -> [{Type, get_count(Module, SubModule, Type)}] ++ Acc  end,
    lists:foldl(F, [], TypeList);

%% 获取一个类型的数量
get_count(Module, SubModule, Type) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> 0;
        RD-> RD#ets_global_counter.count
    end.
    
%% 设置数量
set_count(List)->
    lists:foreach(
      fun({{Module, SubModule, Type} = _Id, Count}) ->
              set_count(Module, SubModule, Type, Count)
      end, List).

set_count(Module, SubModule, Type, Count) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> save(new([Module, SubModule, Type, Count]));
        RD -> save(RD#ets_global_counter{count = Count})
    end.

%% 追加数量
plus_count(Module, SubModule, Type, Count) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> save(new([Module, SubModule, Type, Count]));
        RD -> save(RD#ets_global_counter{count = RD#ets_global_counter.count + Count})
    end.

%% 扣除数量
cut_count(Module, SubModule, Type, Count) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> save(new([Module, Type, Count]));
        RD -> save(RD#ets_global_counter{count = RD#ets_global_counter.count - Count})
    end.

%% 获取刷新时间
get_refresh_time(Module, SubModule, Type) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> 0;
        RD -> RD#ets_global_counter.refresh_time
    end.

%% 更新刷新时间
set_refresh_time(Module, SubModule, Type) ->
    case lib_global_counter:get(Module, SubModule, Type) of
        false -> save(new([Module, SubModule, Type, 0]));
        RD -> save(RD)
    end.

%% 清理全部
clean()->
    catch db:execute(<<"truncate table `counter_global`">>),
    reload().

new([Module, SubModule, Type, Count]) ->
    new([Module, SubModule, Type, Count, ?COUNTER_GLOBAL_DEFAULT_OTHER]);
new([Module, SubModule, Type, Count, Other]) ->
    %% 全服计数器没有刷新定时器
    %% 根据模块和子模块来判断时候刷新
    RefreshTime = utime:unixtime(),
    FirstTime = get_first_time_by_mod_and_submod(Module, SubModule, Type),
    #ets_global_counter{
       id             = {Module, SubModule, Type},
       count          = Count ,
       other          = Other,
       refresh_time   = RefreshTime,
       first_time     = FirstTime            %% 默认取当天的0点时间
      }.

save(GlobalCounter) ->
    NowTime = utime:unixtime(),
    NewGlobalCounter = GlobalCounter#ets_global_counter{refresh_time=NowTime},
    #ets_global_counter{id = {ModuleId, SubModuleId, TypeId} = Id, count = Count, other = Other, first_time = FirstTime} = NewGlobalCounter,
    Data = get_all(),
    Data1 = [NewGlobalCounter| lists:keydelete(Id, #ets_global_counter.id, Data)],
    put(?COUNTER_GLOBAL_KEY, Data1),
    db:execute(io_lib:format(?sql_counter_global_upd, [ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), NowTime, FirstTime])).

%% 所有数据重载
reload() ->
    erase(?COUNTER_GLOBAL_KEY),
    List = db:get_all(?sql_counter_global_sel_all),
    D = to_dict(List, []),
    put(?COUNTER_GLOBAL_KEY, D),
    D.

%% 获取次数上限
get_count_limit(Module, SubModule, Type) ->
    case get_config(Module, SubModule, Type) of
        [] -> 0;
        #base_global_counter{limit = Limit} -> Limit
    end.

%% 未超过限制次数
%% @return [{type, boolean}]
lessthan_limit(Module, SubModule, TypeList) when is_list(TypeList) ->
    F = fun(Type, Acc) -> Acc ++ [{Type, lessthan_limit(Module, SubModule, Type)}] end,
    lists:foldl(F, [], TypeList);

%% 未超过限制次数
%% @return true未超过|false超过
lessthan_limit(Module, SubModule, Type) ->
    %% 后台缺失配置的情况下，直接返回超过次数
    Limit = get_count_limit(Module, SubModule, Type),
    Count = case lib_counter:get(Module, SubModule, Type) of
                false -> 0;
                RD -> RD#ets_global_counter.count
            end,
    Count<Limit.

%% 直接操作数据库，适合在玩家不在线的时候调用
update_count_db(ModuleId, SubModuleId, TypeId, Count, Other, Time, FirstTime) ->
    db:execute(io_lib:format(?sql_counter_global_upd, [ModuleId, SubModuleId, TypeId, Count, util:term_to_bitstring(Other), Time, FirstTime])).

%% 获取次数，扩展数据
%% @return {0, 0}
get_count_and_other_from_db(ModuleId, SubModuleId, TypeId) ->
    {Count, _Time, Other, _FTime} = get_count_info_from_db(ModuleId, SubModuleId, TypeId),
    {Count, Other}.

%% 获取次数，刷新时间
%% @return {0, 0}
get_count_and_refresh_time_from_db(ModuleId, SubModuleId, TypeId) ->
    {Count, Time, _Other, _FirstTime} = get_count_info_from_db(ModuleId, SubModuleId, TypeId),
    {Count, Time}.

get_count_info_from_db(ModuleId, SubModuleId, TypeId) ->
    case get_config(ModuleId, SubModuleId, TypeId) of
        #base_global_counter{} ->
            Sql = io_lib:format(?sql_counter_global_sel, [ModuleId, SubModuleId, TypeId]),
            case db:get_row(Sql) of
                [] -> {0, 0, [], 0};
                [Count, RefreshTime, Other, FTime] -> {Count, RefreshTime, util:bitstring_to_term(Other), FTime}
            end;
        _ -> {0, 0, [], 0}
    end.

%% ================================= private fun =================================
to_dict([], D) -> D;
to_dict([[Module, SubModule, Type, Count, Other, Time, FTime] | T], D) ->
    to_dict(T, [#ets_global_counter{id             = {Module, SubModule, Type},
                                    count          = Count,
                                    other          = util:bitstring_to_term(Other),
                                    refresh_time   = Time,
                                    first_time     = FTime
                                   }|D]).

get_id(Module, SubModule, Type) ->
    Config = get_config(Module, SubModule, Type),
    case Config of
        [] -> {error, Module, Type};
        #base_global_counter{} -> {true, Module, Type}
    end.

get_config(Module, SubModule, Type) ->
    case SubModule == ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE of
        true -> Config = data_global_counter:get_global_id(Module, Type);
        false -> Config = data_global_counter_extra:get_global_id(Module, SubModule)
    end,
    case Config of
        [] -> ?ERR(">>>>> important >>>>> missing config:~p~n", [{Module, SubModule, Type}]);
        _ -> skip
    end,
    Config.

%% 因为全服计数器没有刷新机制：通过代码判断

%% 集字活动的兑换第一次时间(全部当天0点时间)
get_first_time_by_mod_and_submod(?MOD_GOODS, ?MOD_GOODS_DROP, _Type)->
    utime:unixdate();
get_first_time_by_mod_and_submod(?MOD_AC_CUSTOM, ?MOD_AC_CUSTOM_COLWORD, _Type)->
    utime:unixdate();
get_first_time_by_mod_and_submod(?MOD_AC_CUSTOM, ?MOD_AC_CUSTOM_FEAST_SHOP, _Type)->
    utime:unixdate();
get_first_time_by_mod_and_submod(?MOD_AC_CUSTOM, ?MOD_AC_CUSTOM_BUY, _Type)->
    utime:unixdate();
get_first_time_by_mod_and_submod(?MOD_AC_CUSTOM, ?MOD_AC_CUSTOM_RUSH_BUY, _Type)->
    utime:unixdate();
get_first_time_by_mod_and_submod(_Module, _SubModule, _Type)->
    0.
    
