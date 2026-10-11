%%%------------------------------------
%%% @Module     : mod_online
%%% @Author     : huangyongxing
%%% @Email      : huangyongxing@yeah.net
%%% @Created    : 2010.10.28
%%% @Description: 在线人数统计服务
%%%------------------------------------
-module(mod_online).
-behaviour(gen_server).
%% API
-export([start_link/0, check_scheduler_change/1, log_online_num/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("clusters.hrl").
-include("watchdog.hrl").

-define(LOG_INTERVAL,   30000).                 %% 统计时间间隔1分钟
-define(MAX_TURN,           2).                 %% 统计多少轮写一次数据库

-record(state, {
          pid = undefined,                      %% 专门处理在线数据更新的子进程Pid
          turn = 0,
          timer = undefined,
          cluster_type = 0,
          schedulers_online = 0,                %% 当前设置调度器数量
          schedulers = 0,                       %% 最大调度器数量
          online_before_change = 0              %% 上次调整调度器数量时的在线数
         }).

%%%===================================================================
%%% API
%%%===================================================================

%% 启动服务
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 检查调整调度器数量(测试命令，传递的可能是非真实在线数)
check_scheduler_change(OnlineNum) ->
    gen_server:cast(?MODULE, {check_scheduler_change, OnlineNum}).

%% 记录在线人数
log_online_num()->
    ?MODULE ! 'log_online'.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init(_) ->
    process_flag(trap_exit, true),
    Pid         = spawn(fun loop_server/0),
    Ref         = erlang:start_timer(?LOG_INTERVAL, self(), 'log_online_timer'),
    %% 根据节点类型设置
    ClsType = config:get_cls_type(),
    %% 系统调度器个数
    Schedulers  = erlang:system_info(schedulers),
    case ClsType of
        ?NODE_GAME ->
            {OnlineNum, OnlineOnhook} = mod_chat_agent:get_online_num(),
            TotalOnline = OnlineNum + OnlineOnhook,
            %% 根据人数设置调度器个数
            SchedulersOnline = calc_schedulers_match(TotalOnline, Schedulers),
            erlang:system_flag(schedulers_online, SchedulersOnline),
            skip;
        _ ->
            erlang:system_flag(schedulers_online, erlang:min(8, Schedulers))
    end,
    State = #state{pid = Pid, turn = 0, timer = Ref, cluster_type = ClsType,
                   schedulers_online = erlang:system_info(schedulers_online),
                   schedulers = Schedulers},
    {ok, State}.

%% 游戏节点检查调度修改
handle_cast({check_scheduler_change, OnlineNum},
            #state{cluster_type = ?NODE_GAME, schedulers_online = SchedulersOnline,
                   schedulers = Schedulers, online_before_change = OnlineBeforeChange} = State) ->
    {NewSchedulersOnline, NewOnlineBeforeChange} =
        schedulers_change(OnlineNum, OnlineBeforeChange, SchedulersOnline, Schedulers),
    {noreply, State#state{schedulers_online = NewSchedulersOnline,
                          online_before_change = NewOnlineBeforeChange}};

%% 其他节点忽略
handle_cast({check_scheduler_change, _OnlineNum}, State) ->
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 定时器超时
handle_info({timeout, Ref, 'log_online_timer'},
            State = #state{pid = Pid, turn = Turn, timer = Ref}) ->
    NewPid = case is_process_alive(Pid) of
                 true  -> Pid;
                 false -> spawn(fun loop_server/0)
             end,
    %% 第几轮
    NewTurn = if Turn > ?MAX_TURN -> 0; true -> Turn + 1 end,
    %% 发送消息给在线人数统计进程
    NewPid ! {log_online, NewTurn},
    NewTimer = erlang:start_timer(?LOG_INTERVAL, self(), 'log_online_timer'),
    NewState = State#state{pid = NewPid, turn = NewTurn, timer = NewTimer},
    case NewTurn == 0 of
        true  -> %% 暂时与记录在线的处理时机一致，待调整
            if
                State#state.cluster_type =/= ?NODE_GAME ->
                    {noreply, NewState};
                true ->
                    {OnlineNum, OnlineOnhook} = mod_chat_agent:get_online_num(),
                    TotalOnline = OnlineNum + OnlineOnhook,
                    lib_watchdog_api:add_monitor(?WATCHDOG_ONLINE_PLAYER_CNT, OnlineNum),
                    handle_cast({check_scheduler_change, TotalOnline}, NewState)
            end;
        false ->
            {noreply, NewState}
    end;

%% 命令通知统计
handle_info('log_online', State) ->
    Pid = State#state.pid,
    case is_process_alive(Pid) of
        true ->
            NewPid = Pid;
        false ->
            NewPid = spawn(fun loop_server/0)
    end,
    NewPid ! {log_online, 0},
    NewState = #state{pid = NewPid},
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 等待统计在线人数
loop_server() ->
    receive
        {log_online, Turn} ->
            catch lib_online:log_online(Turn),
            loop_server();
        _ ->
            loop_server()
    end.

%% 调度器数量检测修改
schedulers_change(OnlineNum, OnlineBeforeChange, SchedulersOnline, Schedulers) ->
    NewSchedulersOnline = calc_schedulers_match(OnlineNum, Schedulers),
    if
        NewSchedulersOnline =:= SchedulersOnline ->
            {SchedulersOnline, OnlineBeforeChange};
        abs(OnlineNum - OnlineBeforeChange) >= 20 ->
            %% 变化超过20人在线，才处理，避免在线数在临界线上下波动时频繁切换调度器数量
            ?ERR("schedulers online change [~w => ~w], online change [~w => ~w], total [~w]",
                  [SchedulersOnline, NewSchedulersOnline, OnlineBeforeChange, OnlineNum, Schedulers]
                 ),
            erlang:system_flag(schedulers_online, NewSchedulersOnline),
            {NewSchedulersOnline, OnlineNum};
        true ->
            {SchedulersOnline, OnlineBeforeChange}
    end.

%% 计算人数对应的cpu个数
calc_schedulers_match(OnlineNum, Schedulers) ->
    erlang:min(
      if
          OnlineNum =<  200  -> 2;
          OnlineNum =<  400  -> 3;
          OnlineNum =<  1000 -> 4;
          true               -> 8   %% 最多给8个
      end,
      Schedulers).
