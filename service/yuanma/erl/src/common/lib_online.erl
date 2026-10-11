%%------------------------------------
%%% @Module     : lib_online
%%% @Author     : huangyongxing
%%% @Email      : huangyongxing@yeah.net
%%% @Created    : 2010.10.28
%%% @Description: 在线人数统计
%%%------------------------------------
-module(lib_online).
-export([log_online/1,
         online_state/0,
         update_online_num/1,
         do_check_mem/0,
         do_process_gc/3,
         check_mem_helper/1,
         get_online_ids/0,
         apply_cast_to_onlines/3]).
-include("record.hrl").
-include("server.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

%% 执行GC的内存上限，超出则不执行，避免引发内存暴涨，被系统kill掉进程
-define(GC_MEM_LIMIT, 104857600).

%% 节点检点:数据库心跳+节点进程内存检查+记录在线人数
log_online(Turn) ->
    check_db(),
    check_mem(),
    %% 在线人数统计
    case config:get_cls_type() == ?NODE_GAME of
        false -> skip; %% 跨服节点不统计在线人数
        true ->
            F = fun(S) ->
                case rpc:call(S#node.node, lib_online, online_state, []) of
                    {badrpc, _R} -> [S#node.id, S#node.node, 0, S#node.state];
                    N -> [S#node.id, S#node.node, N, S#node.state]
                end
            end,
            ServerList = mod_disperse:node_list(),
            F1 = fun(Server1, Server2) -> hd(Server1) < hd(Server2) end,
            NewServerList = lists:usort(F1, [F(Server) || Server <- ServerList]),
            case lists:usort(F1, [F(Server) || Server <- ServerList]) of
                [] -> skip;
                NewServerList ->
                    update_all_num(NewServerList),
                    if
                        Turn =/= 0 -> skip;
                        true ->
                            Timestamp = utime:unixtime(),
                            NumList = [Num || [_, _, Num, _] <- NewServerList],
                            {OnlineTotal, OnlineOnhook} = mod_chat_agent:get_online_num(),
                            SQL = "insert into log_online (total, online, timestamp, onhook) values ('~w', '~w', '~w', '~w')",
                            Sql = io_lib:format(SQL, [OnlineTotal, NumList, Timestamp, OnlineOnhook]),
                            db:execute(Sql)
                    end
            end
    end.

%% 更新除聊天服务器外的所有服务器的ets_node表人数
update_all_num(ServerList) ->
    %% 更新gateway上的ets_node表
    update_online_num(ServerList),
    AllServerNodes = [Node || [_, Node, _, _] <- ServerList],
    rpc:eval_everywhere(AllServerNodes, lib_online, update_online_num, [ServerList]).

%% 更新本节点ets_node表人数
update_online_num(ServerList) ->
    F = fun([Id, _, Num, State]) ->
                ets:update_element(?ETS_NODE, Id, [{#node.num, Num}, {#node.state, State}])
        end,
    lists:foreach(fun(Server) -> F(Server) end, ServerList).

%% 在线状况
online_state() ->
    case ets:info(?ETS_ONLINE, size) of
        undefined -> 0;
        Num -> Num
    end.

%% 相当数据库心跳包
check_db() ->
    catch db:get_one("SELECT id FROM node LIMIT 1").

%% 检查内存消耗
%% 默认设置30分钟检查一次
%% 内存上限 524288000 (500*1024*1024 bytes) = 500M
%% -define(CHECK_MEM_LIM, 524288000).
%% 普通进程
%% 31457280 = 30M
%% 52428800 = 50M
-define(CHECK_MEM_LIM, 52428800).
check_mem() ->
    {_, {_H, I, S}} = erlang:localtime(),
    if
        (I == 10 orelse I == 40) andalso S =< 30->
            spawn(fun() -> lib_online:do_check_mem() end);
        true ->
            skip
    end.

%% 手动执行
do_check_mem() ->
    check_mem_helper(?CHECK_MEM_LIM).

check_mem_helper(MemLim) ->
    do_check_mem_helper(erlang:processes(), MemLim, 1).

do_check_mem_helper([], _MemLim, _GCCnt)-> ok;
do_check_mem_helper([Pid|Processes], MemLim, GCCnt) ->
    NewGCCnt = case is_pid(Pid) andalso is_process_alive(Pid) of
        false -> GCCnt;
        true -> do_process_gc(Pid, MemLim, GCCnt)
    end,
    do_check_mem_helper(Processes, MemLim, NewGCCnt).

%% 1、所有runing进程都GC、
%% 2、场景进程消息小于50，必然GC
do_process_gc(Pid, MemLim, GCCnt) ->
    case erlang:process_info(Pid, memory) of
        {memory, Mem} ->
            %% 写入日志记录
            List = [
                registered_name, current_function, initial_call,
                status, message_queue_len,
                total_heap_size, heap_size, stack_size, reductions
            ],
            ProcInfo = erlang:process_info(Pid, List),
            InitCall = get_proc_initial_call(Pid),
            ProcName =
            case ProcInfo of
                [{registered_name, []}      | _] -> proc_global_name(Pid);
                [{registered_name, RegName} | _] -> RegName;
                _ -> undefined
            end,
            Fmt = case ProcInfo of
                %% 兼容之前的清理规则:场景进程大于内存上限且消息队列少于50，进行GC
                [_, _, _, _, {message_queue_len, MessageLen} | _] when InitCall =:= {mod_scene_agent, init, 1} andalso Mem >= MemLim andalso MessageLen < 50 ->
                    NeedGC = true,
                    "process execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p";
                [_, _, _, _, {message_queue_len, MessageLen} | _] when MessageLen >= 10 ->
                    NeedGC = false,
                    %% 瞬时消息队列长度过长的进程不主动执行GC
                    "message_queue_len too long, is not readly to execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p";
                _ when InitCall =:= {mod_scene_agent, init, 1} ->
                    NeedGC = false,
                    %% 场景进程不主动执行GC，避免进程崩溃
                    "This is scene process, is not readly to execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p";
                [_, _, _, {status, _Status = running} | _] ->
                    NeedGC = false,
                    "This process running, is not readly to execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p";
                _ when Mem >= ?GC_MEM_LIMIT ->
                    %% 内存太大了，为防止ErlangVM被杀，权且放过，记录日志交由开发分析优化
                    NeedGC = false,
                    "This process cost too large memory, is not readly to execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p";
                _ ->
                    %% 其他进程尝试进行GC，减少内存占用
                    NeedGC = true,
                    "process execute GC (gc count:~w)~n"
                    "pid:~w,proc init call:~w,mem:~w,ProcName:~w~n"
                    "proc info:~p"
            end,
            ?IF(Mem >= MemLim, catch ?ERR(Fmt, [GCCnt, Pid, InitCall, Mem, ProcName, ProcInfo]), skip),
            case NeedGC of
                true  ->
                    %% 尤其老服可能存在明显的大量进程内存高，每处理N个做短暂延迟
                    case GCCnt rem 10 == 0 of
                        true  ->
                            %% 实际上，下方garbage_collect使用的是阻塞式的，应该不需要做gc间隔延迟，
                            %% 节点内存暴涨根源还在于进程内存占用不合理，
                            %% 可能数据结构或算法、甚至于方案设计有问题，需要针对性做分析优化
                            %% 但是基于历史原因也保留短暂的延迟，
                            %% 或许一定程度上有助于调度器内存的管理，降低出问题概率
                            timer:sleep(300);
                        false -> ignore
                    end,
                    erlang:garbage_collect(Pid),
                    GCCnt + 1;
                false ->
                    GCCnt
            end;
        _ ->
            GCCnt
    end.

% do_process_gc(Pid, MemLim)->
%     case erlang:process_info(Pid, memory) of
%         {memory, Mem} when Mem >= MemLim ->
%             %% 获取进程信息
%             List = [registered_name, current_function,  initial_call,
%                     status,          message_queue_len, total_heap_size,
%                     heap_size,       stack_size,        reductions],
%             ProcInfo = erlang:process_info(Pid, List),
%             {binary, Bins} = erlang:process_info(Pid, binary),
%             BMem = {binary_memory, recon_lib:binary_memory(Bins)},
%             InitCall = get_proc_initial_call(Pid),
%             RegName = case catch proplists:get_value(registered_name, ProcInfo, []) of
%                           {'EXIT', _} -> undefined;
%                           [] -> global:whereis_name(Pid);
%                           RegName1 -> RegName1
%                       end,
%             case catch proplists:get_value(message_queue_len, ProcInfo, 0) of
%                 MsgLen when MsgLen < 50 ->
%                     erlang:garbage_collect(Pid),
%                     NewMem = case erlang:process_info(Pid, memory) of
%                                  {memory, Mem1} -> Mem1;
%                                  _ -> undefined
%                              end,
%                     {binary, NBins} = erlang:process_info(Pid, binary),
%                     NewBMem = {binary_memory, recon_lib:binary_memory(NBins)},
%                     Fmt = "GC finish Pid:~w, RegName:~w, InitCall:~w, Mem:~w, NewMem:~w~n BMem:~w, NewBMem:~w  ProcessInfo:~p~n",
%                     catch ?ERR(Fmt, [Pid, RegName, InitCall, Mem, NewMem, BMem, NewBMem, ProcInfo]);
%                 _ ->
%                     Fmt = "GC unfinish msg long Pid:~w, RegName:~w, InitCall:~w, Mem:~w, BMem:~w~n  ProcessInfo:~p~n",
%                     catch ?ERR(Fmt, [Pid, RegName, InitCall, Mem, ProcInfo])
%             end;
%         _R ->
%             ok
%     end.

%% 获取进程通过global模块注册的名称
proc_global_name(Pid) when is_pid(Pid) ->
    case ets:lookup(global_pid_names, Pid) of
        [{_, GlobalName}] ->
            {global, GlobalName};
        _ -> undefined
    end.

%% 获取正在运行的函数
get_proc_initial_call(Pid) ->
    case erlang:process_info(Pid, dictionary) of
        {dictionary, Dictionary} ->
            case lists:keyfind('$initial_call', 1, Dictionary) of
                {_, MFA} -> MFA;
                _ -> undefined
            end;
        _ ->
            null
    end.

%% 获取在线的玩家id
get_online_ids()->
    [E#ets_online.id || E <- ets:tab2list(?ETS_ONLINE)].

apply_cast_to_onlines(M, F, A) ->
    [lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, M, F, A) || Id <- get_online_ids()].
