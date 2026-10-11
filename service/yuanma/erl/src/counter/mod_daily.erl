%%%----------------------------------------------------------------------
%%% @Module  : mod_daily
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.08
%%% @Description: 每天记录器

%%% Modified: 18/10/2016 by hekai <1472524632@qq.com>
%%% Note: 重构记录器，记录器id由功能模块id跟type类型id唯一确定
%%%       功能模块跟type类型在后台配置注册使用
%%% Usage:
%%% mod_daily:get_count(RoleId, ?PET, ?FREE_GROW_LV).
%%% mod_daily:increment(RoleId, ?PET, ?FREE_GROW_LV).
%%% ?PET::integer()，在后台及def_module.hrl中定义
%%% ?FREE_GROW_LV::integer()，在后台及def_daily.hrl中定义
%%%----------------------------------------------------------------------
-module(mod_daily).
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").
-include("record.hrl").
-compile(export_all).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([]).
-define(get_module_pid(RoleId), misc:get_daily_process(RoleId)).


%% 委托调用
apply_cast(RoleId, Mod, Fun, Arg) ->
    gen_server:cast(?get_module_pid(RoleId), {apply_cast, [Mod, Fun, Arg]}).

%% 获取数量
%% Module:: integer()
%% Type  :: integer()|| [integer()]
get_count(RoleId, Module, Type) ->
    get_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

%% 获取数量
%% Module    :: integer() 功能id
%% SubModule :: integer() 功能子id
%% Type      :: integer()|| [integer()] 次数id类型
get_count(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get_count, [RoleId, Module, SubModule, Type]}).

%% 获取数量
%% RoleId    :: integer() 玩家id
%% List      :: [{Module::integer(), SubModule::integer(), Type::integer()}]
%% @return   :: [{ {Module::integer(), SubModule::integer(), Type::integer()}, Count::integer()}]
get_count(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {get_count, [RoleId, List]}).

%% 获取数量
%% RoleId    :: integer() 玩家id
%% List      :: [{Module::integer(), SubModule::integer(), Type::integer()}]
%% @return   :: [{ {Module::integer(), SubModule::integer(), Type::integer()}, Count::integer()}]
get_count_offline(RoleId, List) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true -> get_count(RoleId, List);
        _  ->
            lists:map(
            fun({Module, SubModule, Type} = Id) ->
                {Count, _Other} = lib_daily:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                {Id, Count}
            end,
            List)
    end.

%% 获取数量
%% 在线时：  同get_count一样
%% 不在线时：不在线则直接读取db
get_count_offline(RoleId, Module, Type) ->
    get_count_offline(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

%% 获取数量
%% 在线时：  同get_count一样
%% 不在线时：不在线则直接读取db
get_count_offline(RoleId, Module, SubModule, Type) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true -> get_count(RoleId, Module, SubModule, Type);
        _  ->
            {Count, _Other} = lib_daily:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
            Count
    end.

%% 加一操作
increment(RoleId, Module, Type) ->
    increment(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

%% 加一操作
increment(RoleId, Module, SubModule, Type) ->
    plus_count(RoleId, Module, SubModule, Type, 1).

%% 加一操作
%% 在线时：  同increment一样
%% 不在线时：不在线则直接修改db
increment_offline(RoleId, Module, Type) ->
    increment_offline(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

%% 加一操作
%% 在线时：  同increment一样
%% 不在线时：不在线则直接修改db
increment_offline(RoleId, Module, SubModule, Type) ->
    plus_count_offline(RoleId, Module, SubModule, Type, 1).

%% 减一操作
decrement(RoleId, Module, Type) ->
    decrement(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

decrement(RoleId, Module, SubModule, Type) ->
    cut_count(RoleId, Module, SubModule, Type, 1).

%% 减一操作
%% 在线时：  同decrement一样
%% 不在线时：不在线则直接修改db
decrement_offline(RoleId, Module, Type) ->
    decrement(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

decrement_offline(RoleId, Module, SubModule, Type) ->
    cut_count_offline(RoleId, Module, SubModule, Type, 1).

%% 下线操作
stop(Pid) ->
    gen_server:cast(Pid, stop).

%% 获取整个记录器
get(RoleId, Module, Type) ->
    get(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

get(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get, [RoleId, Module, SubModule, Type]}).

%% 取玩家的整个记录
get_all(RoleId) ->
    get_all(RoleId, ?TWELVE).

get_all(RoleId, Clock) ->
    gen_server:call(?get_module_pid(RoleId), {get_all, [RoleId, Clock]}).

%% 判断未超过限制次数
%% @return true未超过|false超过
lessthan_limit(RoleId, Module, Type) ->
    lessthan_limit(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

lessthan_limit(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {lessthan_limit, [RoleId, Module, SubModule, Type]}).

%% 获取限制
get_limit_by_type(Module, Type) ->
    case data_daily:get_id(Module, Type) of
        #base_daily{limit = Limit} -> Limit;
        _ -> 0
    end.

get_limit_by_sub_module(Module, SubModule) ->
    case data_daily_extra:get_id(Module, SubModule) of
        #base_daily{limit = Limit} -> Limit;
        _ -> 0
    end.

%% 设置数量
set_count(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {set_count, [RoleId, List]}).

set_count(RoleId, Module, Type, Count) ->
    set_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

set_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(?get_module_pid(RoleId), {set_count, [RoleId, Module, SubModule, Type, Count]}).

set_count_offline(RoleId, Module, Type, Count) ->
    set_count_offline(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

set_count_offline(RoleId, Module, SubModule, Type, Count) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            set_count(RoleId, Module, SubModule, Type, Count);
        _  ->
            Time = utime:unixtime(),
            F = fun() ->
                        {_, Other} = lib_daily:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                        lib_daily:update_count_db(RoleId, Module, SubModule, Type, Count, Other, Time),
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
    get_refresh_time(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

get_refresh_time(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {get_refresh_time, [RoleId, Module, SubModule, Type]}).

%% 更新刷新时间
set_refresh_time(RoleId, Module, Type) ->
    set_refresh_time(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

set_refresh_time(RoleId, Module, SubModule, Type) ->
    gen_server:call(?get_module_pid(RoleId), {set_refresh_time, [RoleId, Module, SubModule, Type]}).

%% 追加数量
plus_count(RoleId, Module, Type, Count) ->
    plus_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

%% 追加数量，不在线则处理离线
plus_count_offline(RoleId, Module, Type, Count) ->
    plus_count_offline(RoleId,  Module, ?DEFAULT_SUB_MODULE, Type, Count).

plus_count_offline(RoleId, Module, SubModule, Type, Count) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            plus_count(RoleId, Module, SubModule, Type, Count);
        _  ->
            Time = utime:unixtime(),
            F = fun() ->
                        {OldCount, Other} = lib_daily:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                        lib_daily:update_count_db(RoleId, Module, SubModule, Type, Count + OldCount, Other, Time),
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

plus_count(RoleId, List) ->
    gen_server:call(?get_module_pid(RoleId), {plus_count, [RoleId, List]}).

%% 扣除数量
cut_count(RoleId, Module, Type, Count) ->
    cut_count(RoleId, Module, ?DEFAULT_SUB_MODULE, Type, Count).

cut_count(RoleId, Module, SubModule, Type, Count) ->
    gen_server:call(?get_module_pid(RoleId), {cut_count, [RoleId, Module, SubModule, Type, Count]}).

%% 追加数量，不在线则处理离线
cut_count_offline(RoleId, Module, Type, Count) ->
    cut_count_offline(RoleId,  Module, ?DEFAULT_SUB_MODULE, Type, Count).

cut_count_offline(RoleId, Module, SubModule, Type, Count) ->
    Pid = ?get_module_pid(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            cut_count(RoleId, Module, SubModule, Type, Count);
        _  ->
            Time = utime:unixtime(),
            F = fun() ->
                        {OldCount, Other} = lib_daily:get_count_and_other_from_db(RoleId, Module, SubModule, Type),
                        lib_daily:update_count_db(RoleId, Module, SubModule, Type, OldCount - Count, Other, Time),
                        ok
                end,
            case catch db:transaction(F) of
                ok -> ok;
                Error ->
                    ?ERR("plus_count_offline:~p~n", [Error]),
                    error
            end
    end.

save(RoleId, RoleDaily) ->
    gen_server:call(?get_module_pid(RoleId), {save, [RoleId, RoleDaily]}).

start_link(RoleId) ->
    gen_server:start_link(?MODULE, [RoleId], []).

%% 重新加载日常
reload_daily(RoleId)->
    gen_server:cast(?get_module_pid(RoleId), {reload_daily, RoleId}).

init([RoleId]) ->
    lib_daily:online(RoleId),
    misc:register(global, misc:daily_process_name(RoleId), self()),
    {ok, ?MODULE}.

%%每日清空缓存
handle_cast({daily_clear, ?TWELVE, RoleId}, Status) ->
    D = erase(?DAILY_KEY(?TWELVE)),
    UnixTime = utime:unixdate(),
    NeedDelete = need_delete_again(D, UnixTime),
    if
        NeedDelete ->
            db:execute(io_lib:format(?sql_daily_role_clear, [RoleId]));
        true -> ok
    end,
    %?PRINT("NeedDelete:~p, D:~p~n", [NeedDelete, D]),
    {noreply, Status};
handle_cast({daily_clear, ?FOUR, RoleId}, Status) ->
    D = erase(?DAILY_KEY(?FOUR)),
    FourUnixTime = utime:unixdate() + 4*?ONE_HOUR_SECONDS,
    NeedDelete = need_delete_again(D, FourUnixTime),
    if
        NeedDelete ->
            db:execute(io_lib:format(?sql_daily_four_role_clear, [RoleId]));
        true -> ok
    end,
    %?PRINT("NeedDelete:~p, D:~p~n", [NeedDelete, D]),
    {noreply, Status};

%% 重连的时候重新加载日常
handle_cast({reload_daily, RoleId}, Status)->
    erase(?DAILY_KEY(?FOUR)),
    erase(?DAILY_KEY(?TWELVE)),
    lib_counter:online(RoleId),
    {noreply, Status};

%%停止任务进程
handle_cast(stop, Status) ->
    {stop, normal, Status};

%% cast数据调用
handle_cast({Fun, Arg}, Status) ->
    apply(lib_daily, Fun, Arg),
    {noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

%% call数据调用
handle_call({Fun, Arg} , _FROM, Status) ->
    {reply, apply(lib_daily, Fun, Arg), Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% 每天数据清除
daily_clear(Time, _DelaySec) ->
    daily_clear(Time).

%% 每天数据清除
daily_clear(?TWELVE) ->
    catch db:execute(io_lib:format(?sql_daily_clear, [])),
    %% 通知线路更新
    Server = mod_disperse:node_list(),
    F = fun(S) ->
                rpc:cast(S#node.node, mod_daily, daily_clear_ref, [?TWELVE])
        end,
    [F(S) || S <- Server];
daily_clear(?FOUR) ->
    catch db:execute(io_lib:format(?sql_daily_four_clear, [])),
    %%通知线路更新
    Server = mod_disperse:node_list(),
    F = fun(S) ->
                rpc:cast(S#node.node, mod_daily, daily_clear_ref, [?FOUR])
        end,
    [F(S) || S <- Server].

midday_clear() ->
    Data = ets:tab2list(?ETS_ONLINE),
    [gen_server:cast(D#ets_online.pid, {'refresh_and_clear_midday'}) || D <- Data],
    ok.

%% 清除每个游戏线内所有玩家的Daily数据
daily_clear_ref(?TWELVE) ->
    Data = ets:tab2list(?ETS_ONLINE),
    [gen_server:cast(D#ets_online.pid, {'refresh_and_clear_daily', ?TWELVE}) || D <- Data],
    ok;
daily_clear_ref(?FOUR) ->
    Data = ets:tab2list(?ETS_ONLINE),
    [gen_server:cast(D#ets_online.pid, {'refresh_and_clear_daily', ?FOUR}) || D <- Data],
    ok.

%% 后台使用,清除所有人的日常
daily_clear_all_houtai() ->
    mod_disperse:cast_to_unite(mod_daily, daily_clear, []),
    mod_disperse:cast_to_unite(mod_daily_dict, daily_clear, []).

%% 清除某玩家的指定日常(只能用于在线玩家)
daily_clear_role_one(RoleId, Module, Type) ->
    daily_clear_role_one(RoleId, Module, ?DEFAULT_SUB_MODULE, Type).

daily_clear_role_one(RoleId, Module, SubModule, Type) ->
    mod_daily_dict:set_count(RoleId, Module, SubModule, Type, 0),
    mod_daily:set_count(RoleId, Module, SubModule, Type, 0).

%% 清除某玩家的所有日常(只能用于在线玩家)
daily_clear_role_all(RoleId, ?TWELVE) ->
    catch db:execute(io_lib:format(?sql_daily_role_clear, [RoleId])),
    DailyPid = ?get_module_pid(RoleId),
    gen_server:cast(DailyPid, {daily_clear, ?TWELVE, RoleId});
daily_clear_role_all(RoleId, ?FOUR) ->
    catch db:execute(io_lib:format(?sql_daily_four_role_clear, [RoleId])),
    DailyPid = ?get_module_pid(RoleId),
    gen_server:cast(DailyPid, {daily_clear, ?FOUR, RoleId});
daily_clear_role_all(RoleId, Clock) ->
    ?ERR("error clock args:~p~n", [{RoleId, Clock}]),
    error.

%% 清除指定模块日常次数
daily_clear_module(Module, Type) ->
    daily_clear_module(Module, ?DEFAULT_SUB_MODULE, Type).

daily_clear_module(Module, SubModule, Type) ->
    case lib_daily:get_config(Module, SubModule, Type) of
        #base_daily{clock = Clock} when Clock==?TWELVE orelse Clock==?FOUR->
            spawn(fun() -> daily_clear_module_core(Module, SubModule, Type, Clock) end);
        _ ->
            ?ERR("error Module, SubModule, Type args:~p~n", [{Module, SubModule, Type}])
    end.

daily_clear_module_core(Module, SubModule, Type, ?TWELVE) ->
    NowTime = utime:unixtime(),
    Sql = io_lib:format(<<"update `counter_daily_twelve` set `count` = 0, `refresh_time` = ~p WHERE `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>,
                        [NowTime, Module, SubModule, Type]),
    db:execute(Sql),
    timer:sleep(300),
    daily_clear_module_online(Module, SubModule, Type);

daily_clear_module_core(Module, SubModule, Type, ?FOUR) ->
    NowTime = utime:unixtime(),
    Sql = io_lib:format(<<"update `counter_daily_four` set `count` = 0, `refresh_time` = ~p WHERE `module` = ~p AND `sub_module` = ~p AND `type` = ~p">>,
                        [NowTime, Module, SubModule, Type]),
    db:execute(Sql),
    timer:sleep(300),
    daily_clear_module_online(Module, SubModule, Type).

daily_clear_module_online(Module, SubModule, Type) ->
    %%通知线路更新
    Server = mod_disperse:node_list(),
    F = fun(S) ->
                rpc:cast(S#node.node, mod_daily, daily_clear_module_online_core, [Module, SubModule, Type])
        end,
    [F(S) || S <- Server].

daily_clear_module_online_core(Module, SubModule, Type) ->
    Data = ets:tab2list(?ETS_ONLINE),
    OnlineIdList = [D#ets_online.id|| D <- Data],
    spawn(fun() -> daily_clear_module_online_core(OnlineIdList, Module, SubModule, Type, 1) end),
    ok.

daily_clear_module_online_core([], Module, SubModule, Type, _AccNum) ->
    ?INFO("daily_clear_module_online success:~p~n", [{Module, SubModule, Type}]),
    ok;
daily_clear_module_online_core([RoleId|T], Module, SubModule, Type, AccNum) ->
    case AccNum rem 30 of
        0 -> timer:sleep(200);
        _ -> skip
    end,
    case catch mod_daily:set_count(RoleId, Module, SubModule, Type, 0) of
        Res when is_integer(Res) -> ok;
        Error -> ?ERR("daily_clear_module_online:~p~n", [Error])
    end,
    daily_clear_module_online_core(T, Module, SubModule, Type, AccNum+1).

need_delete_again(undefined, _UnixTime) -> false;
need_delete_again([], _UnixTime) -> false;
need_delete_again([#ets_daily{refresh_time = RefreshTime}|D], UnixTime) ->
    case RefreshTime > UnixTime of
        true -> true;
        _ -> need_delete_again(D, UnixTime)
    end.