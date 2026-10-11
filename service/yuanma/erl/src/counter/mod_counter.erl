%%%----------------------------------------------------------------------
%%% @Module  : mod_counter
%%% @Author  : hek
%%% @Created : 2016.10.18
%%% @Description: 终生次数记录器

%%% Usage:
%%% mod_counter:get_count(RoleId, ?PET, ?FREE_GROW_LV).
%%% mod_counter:increment(RoleId, ?PET, ?FREE_GROW_LV).
%%% ?PET::integer()，在后台及def_module.hrl中定义
%%% ?FREE_GROW_LV::integer()，在后台及def_counter.hrl中定义
%%%----------------------------------------------------------------------
-module(mod_counter).
-include("counter.hrl").
-include("server.hrl").
-include("common.hrl").
-include("record.hrl").
-compile(export_all).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([]).
-define(get_module_pid(RoleId), misc:get_counter_process(RoleId)).

%% 委托调用
apply_cast(RoleId, Mod, Fun, Arg) ->
    gen_server:cast(?get_module_pid(RoleId), {apply_cast, [Mod, Fun, Arg]}).

%% 获取数量
%% @param Type [Type,...] | Type
get_count(RoleId, Module, Type) ->
    get_count(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

%% @param Type [Type,...] | Type
get_count(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get_count, [RoleId, Module, SubModule, Type]}).

get_count(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {get_count, [RoleId, List]}).

%% 获取数量
%% 在线时：  同get_count一样
%% 不在线时：不在线则直接读取db
%% @param Type [Type,...] | Type
get_count_offline(RoleId, Module, Type) ->
    get_count_offline(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

%% 获取数量
%% 在线时：  同get_count一样
%% 不在线时：不在线则直接读取db
get_count_offline(RoleId, Module, SubModule, Type) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true -> get_count(RoleId, Module, SubModule, Type);
        _  ->
            lib_counter:get_count_from_db(RoleId, Module, SubModule, Type)
    end.

%% 加一操作
increment(RoleId, Module, Type) ->
    increment(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

increment(RoleId, Module, SubModule, Type) ->
    plus_count(RoleId, Module, SubModule, Type, 1).

%% 加一操作
%% 在线时：  同increment一样
%% 不在线时：不在线则直接修改db
increment_offline(RoleId, Module, Type) ->
    increment_offline(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

%% 加一操作
%% 在线时：  同increment一样
%% 不在线时：不在线则直接修改db
increment_offline(RoleId, Module, SubModule, Type) ->
    plus_count_offline(RoleId, Module, SubModule, Type, 1).

%% 减一操作
decrement(RoleId, Module, Type) ->
    decrement(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

decrement(RoleId, Module, SubModule, Type) ->
    cut_count(RoleId, Module, SubModule, Type, 1).

%% 下线操作
stop(Pid) ->
    gen_server:cast(Pid, stop).

%% 获取整个记录器
get(RoleId, Module, Type) ->
    get(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

get(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get, [RoleId, Module, SubModule, Type]}).

%% 取玩家的整个记录
get_all(RoleId) ->
    gen_server:call(?get_module_pid(RoleId), {get_all, [RoleId]}).

%% 判断未超过限制次数
%% @return true未超过|false超过
lessthan_limit(RoleId, Module, Type) ->
    lessthan_limit(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

lessthan_limit(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {lessthan_limit, [RoleId, Module, SubModule, Type]}).

%% 获取限制
get_limit_by_type(Module, Type) ->
    case data_counter:get_id(Module, Type) of
        #base_counter{limit = Limit} -> Limit;
        _ -> 0
    end.

get_limit_by_sub_module(Module, SubModule) ->
    case data_counter_extra:get_id(Module, SubModule) of
        #base_counter{limit = Limit} -> Limit;
        _ -> 0
    end.

%% 设置数量
set_count(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {set_count, [RoleId, List]}).

%% 设置数量
set_count(RoleId, Module, Type, Count) ->
    set_count(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type, Count).

set_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(?get_module_pid(RoleId), {set_count, [RoleId, Module, SubModule, Type, Count]}).

set_count(RoleId, Module, SubModule, Type, Count, RefreshTime) ->
    gen_server:call(?get_module_pid(RoleId), {set_count, [RoleId, Module, SubModule, Type, Count, RefreshTime]}).

%% 设置数量，不在线则处理离线
set_count_offline(RoleId,  Module, SubModule, Type, Count) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true -> set_count(RoleId, Module, SubModule, Type, Count);
        _  ->
            Time = utime:unixtime(),
            F = fun() ->
                {_OldCount, Other} = lib_counter:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                lib_counter:update_count_db(RoleId, Module, SubModule, Type, Count, Other, Time),
                ok
            end,
            case catch db:transaction(F) of
                ok -> ok;
                Error ->
                    ?ERR("set_count_offline:~p~n", [Error]),
                    error
            end
    end.

%% 获取刷新时间
get_refresh_time(RoleId, Module, Type) ->
    get_refresh_time(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

get_refresh_time(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get_refresh_time, [RoleId, Module, SubModule, Type]}).

%% 获取扩展数据
get_other_data(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get_other_data, [RoleId, Module, SubModule, Type]}).

%% 更新刷新时间
set_refresh_time(RoleId, Module, Type) ->
    set_refresh_time(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

set_refresh_time(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {set_refresh_time, [RoleId, Module, SubModule, Type]}).

%% 获得次数和刷新时间
get_count_and_refresh_time(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {get_count_and_refresh_time, [RoleId, List]}).

%% 追加数量
plus_count(RoleId, Module, Type, Count) ->
    plus_count(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type, Count).

%% 追加数量，不在线则处理离线
plus_count_offline(RoleId,  Module, SubModule, Type, Count) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true -> plus_count(RoleId, Module, SubModule, Type, Count);
        _  ->
            Time = utime:unixtime(),
            F = fun() ->
                {OldCount, Other} = lib_counter:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                lib_counter:update_count_db(RoleId, Module, SubModule, Type, Count + OldCount, Other, Time),
                ok
            end,
            case catch db:transaction(F) of
                ok -> ok;
                Error ->
                    ?ERR("plus_count_offline:~p~n", [Error]),
                    error
            end
    end.

plus_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(?get_module_pid(RoleId), {plus_count, [RoleId, Module, SubModule, Type, Count]}).

plus_count(RoleId, TypeList) ->
    gen_server:call(?get_module_pid(RoleId), {plus_count, [RoleId, TypeList]}).

%% 扣除数量
cut_count(RoleId, Module, Type, Count) ->
    cut_count(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type, Count).

cut_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(?get_module_pid(RoleId), {cut_count, [RoleId, Module, SubModule, Type, Count]}).

%% 清理数量
%% @param List [Type,...]
clear(RoleId, Module, SubModule, List) ->
    gen_server:call(?get_module_pid(RoleId), {clear, [RoleId, Module, SubModule, List]}).

save(RoleId, RoleDaily) ->
    gen_server:call(?get_module_pid(RoleId), {save, [RoleId, RoleDaily]}).

start_link(RoleId) ->
    gen_server:start_link(?MODULE, [RoleId], []).

init([RoleId]) ->
    lib_counter:online(RoleId),
    misc:register(global, misc:counter_process_name(RoleId), self()),
    {ok, ?MODULE}.

%%停止任务进程
handle_cast(stop, Status) ->
    {stop, normal, Status};

%% cast数据调用
handle_cast({Fun, Arg}, Status) ->
    apply(lib_counter, Fun, Arg),
    {noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

%% call数据调用
handle_call({Fun, Arg} , _FROM, Status) ->
    {reply, apply(lib_counter, Fun, Arg), Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% 清除某玩家的指定周常(只能用于在线玩家)
counter_clear_role_one(RoleId, Module, Type) ->
    counter_clear_role_one(RoleId, Module, ?COUNTER_DEFAULT_SUB_MODULE, Type).

counter_clear_role_one(RoleId, Module, SubModule, Type) ->
    mod_week:set_count(RoleId, Module, SubModule, Type, 0).
