%%%----------------------------------------------------------------------
%%% @Module  : mod_global_counter
%%% @Author  : hek
%%% @Created : 2016.10.18
%%% @Description: 全服次数记录器:不定时清除计数器，需要手动清理

%%% Usage:
%%% mod_global_counter:get_count(RoleId, ?PET, ?FREE_GROW_LV).
%%% mod_global_counter:increment(RoleId, ?PET, ?FREE_GROW_LV).
%%% ?PET::integer()，在后台及def_module.hrl中定义
%%% ?FREE_GROW_LV::integer()，在后台及def_counter.hrl中定义
%%%----------------------------------------------------------------------
-module(mod_global_counter).
-include("counter_global.hrl").
-include("server.hrl").
-include("common.hrl").
-include("record.hrl").
-compile(export_all).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 获取数量(根据参数)
get_count(Types, Args) when is_list(Types) ->
    gen_server:call(?MODULE, {get_count, [Types, Args]});

get_count(Module, Type) ->
    get_count(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

get_count(Module, SubModule, Type) ->
    gen_server:call(?MODULE, {get_count, [Module, SubModule, Type]}).

%% 加一操作
increment(Module, Type) ->
    increment(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

increment(Module, SubModule, Type) ->
    plus_count( Module, SubModule, Type, 1).

%% 减一操作
decrement( Module, Type) ->
    decrement( Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

decrement( Module, SubModule, Type) ->
    cut_count( Module, SubModule, Type, 1).

%% 获取整个记录器
get(Module, Type) ->
    get(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

get(Module, SubModule, Type) ->
    gen_server:call(?MODULE, {get, [ Module, SubModule, Type]}).

%% 判断未超过限制次数
%% @return true未超过|false超过
lessthan_limit(Module, Type) ->
    lessthan_limit(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

lessthan_limit(Module, SubModule, Type) ->
    gen_server:call(?MODULE, {lessthan_limit, [Module, SubModule, Type]}).

%% 设置数量
set_count(List) ->
    gen_server:call(?MODULE, {set_count, [List]}).

set_count(Module, Type, Count) ->
    set_count(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type, Count).

set_count(Module, SubModule, Type, Count) ->
    gen_server:call(?MODULE, {set_count, [Module, SubModule, Type, Count]}).

%% 获取刷新时间
get_refresh_time(Module, Type) ->
    get_refresh_time( Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

get_refresh_time(Module, SubModule, Type) ->
    gen_server:call(?MODULE, {get_refresh_time, [ Module, SubModule, Type]}).

%% 更新刷新时间
set_refresh_time(Module, Type) ->
    set_refresh_time( Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type).

set_refresh_time(Module, SubModule, Type) ->
    gen_server:call(?MODULE, {set_refresh_time, [ Module, SubModule, Type]}).

%% 追加数量
plus_count(Module, Type, Count) ->
    plus_count(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type, Count).

plus_count(Module, SubModule, Type, Count) ->
    gen_server:call(?MODULE, {plus_count, [ Module, SubModule, Type, Count]}).

%% 扣除数量
cut_count( Module, Type, Count) ->
    cut_count(Module, ?COUNTER_GLOBAL_DEFAULT_SUB_MODULE, Type, Count).

cut_count(Module, SubModule, Type, Count) ->
    gen_server:call(?MODULE, {cut_count, [ Module, SubModule, Type, Count]}).

save(GlobleCounter) ->
    gen_server:call(?MODULE, {save, [GlobleCounter]}).

clean()->
    gen_server:call(?MODULE, {clean, []}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    lib_global_counter:global_counter_init(),
    {ok, ?MODULE}.

%%停止任务进程
handle_cast(stop, Status) ->
    {stop, normal, Status};

%% cast数据调用
handle_cast({Fun, Arg}, Status) ->
    apply(lib_global_counter, Fun, Arg),
    {noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

%% call数据调用
handle_call({Fun, Arg} , _FROM, Status) ->
    {reply, apply(lib_global_counter, Fun, Arg), Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% 清理全服次数
gloabl_count_clean_all()->
    gen_server:cast(?MODULE, {clean, []}).
