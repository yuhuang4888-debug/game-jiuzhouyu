%%%----------------------------------------------------------------------
%%% @Module  : mod_daily_dict
%%% @Author  : 
%%% @Created : 2010.09.26
%%% @Description: 每天记录器(只保存缓存,不会写入数据库)

%%% Modified: 18/10/2016 by hekai <1472524632@qq.com>
%%% Note: 重构记录器，记录器id由功能模块id跟type类型id唯一确定
%%%       功能模块跟type类型在后台配置注册使用
%%% Usage: 
%%% mod_daily_dict:get_count(RoleId, ?PET, ?FREE_GROW_LV).
%%% mod_daily_dict:increment(RoleId, ?PET, ?FREE_GROW_LV).
%%% ?PET::integer()，在后台及def_module.hrl中定义
%%% ?FREE_GROW_LV::integer()，在后台及def_daily.hrl中定义
%%%----------------------------------------------------------------------

-module(mod_daily_dict).
-include("daily.hrl").
-export([
    get_count/3,
    get_count/4,
    increment/3,
    increment/4,
    decrement/3,
    decrement/4,
	start_link/0,
	set_special_info/2,
	get_special_info/1,
	get/3,
    get/4,
	get_all/1,	
	set_count/4,
    set_count/5,
	plus_count/4,
    plus_count/5,
	cut_count/4,
	save/1,	
    daily_clear/1,
	daily_clear/0,
	get_refresh_time/3,		
	set_refresh_time/3,
    daily_clear_one/1
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 获取数量
get_count(RoleId, Module, Type) ->
    get_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

get_count(RoleId, Module, SubModule,Type) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_count, [RoleId, Module, SubModule, Type]}).

%% 加一操作
increment(RoleId, Module, Type) ->
    increment(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

increment(RoleId, Module, SubModule, Type) ->
    plus_count(RoleId, Module, SubModule, Type, 1).

%% 减一操作
decrement(RoleId, Module, Type) ->
    decrement(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

decrement(RoleId, Module, SubModule, Type) ->
    cut_count(RoleId, Module, SubModule, Type, 1).

%% 设置特殊值(无判断)
set_special_info(Key, Value) ->
	gen_server:call(misc:get_global_pid(?MODULE), {set_special_info, [Key, Value]}).

%% 获取特殊值(无判断)
get_special_info(Key) ->
	gen_server:call(misc:get_global_pid(?MODULE), {get_special_info, [Key]}).

%% 获取整个记录器
get(RoleId, Module, Type) ->
    get(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

get(RoleId, Module, SubModule, Type) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get, [RoleId, Module, SubModule, Type]}).

%% 取玩家的整个记录
get_all(RoleId) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_all, [RoleId]}).

%% 设置数量
set_count(RoleId, Module, Type, Count) ->
    set_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

set_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(misc:get_global_pid(?MODULE), {set_count, [RoleId, Module, SubModule, Type, Count]}).

%% 获取刷新时间
get_refresh_time(RoleId, Module, Type) ->
    get_refresh_time(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

get_refresh_time(RoleId, Module, SubModule, Type) ->
	gen_server:call(misc:get_global_pid(?MODULE), {get_refresh_time, [RoleId, Module, SubModule, Type]}).
   
%% 更新刷新时间
set_refresh_time(RoleId, Module, Type) ->
    set_refresh_time(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

set_refresh_time(RoleId, Module, SubModule, Type) ->
	gen_server:call(misc:get_global_pid(?MODULE), {set_refresh_time, [RoleId, Module, SubModule, Type]}).

%% 追加数量
plus_count(RoleId, Module, Type, Count) ->
    plus_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

plus_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(misc:get_global_pid(?MODULE), {plus_count, [RoleId, Module, SubModule, Type, Count]}).

%% 扣除数量
cut_count(RoleId, Module, Type, Count) ->
    cut_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

cut_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(misc:get_global_pid(?MODULE), {cut_count, [RoleId, Module, SubModule, Type, Count]}).

save(RoleDaily) ->
    gen_server:call(misc:get_global_pid(?MODULE), {save, [RoleDaily]}).
   
%% 每天数据清除
daily_clear(_DelaySec) ->
    daily_clear().

%% 每天数据清除
daily_clear() ->
    gen_server:cast(misc:get_global_pid(?MODULE), {daily_clear, []}).

daily_clear_one(RoleId)->
    gen_server:cast(misc:get_global_pid(?MODULE), {daily_clear_one, [RoleId]}).

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    {ok, ?MODULE}.

%% cast数据调用
handle_cast({Fun, Arg}, Status) ->
    apply(lib_daily_dict, Fun, Arg),
    {noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

%% call数据调用
handle_call({Fun, Arg} , _FROM, Status) ->
    {reply, apply(lib_daily_dict, Fun, Arg), Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.
