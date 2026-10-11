%%%-----------------------------------
%%% @Module  : misc
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.14
%%% @Description: 公共函数
%%%-----------------------------------
-module(misc).
-compile(export_all).
-include("common.hrl").

whereis_name(local, Atom) -> 
	erlang:whereis(Atom);

whereis_name(global, Atom) ->
	global:whereis_name(Atom).
 
register(local, Name, Pid) ->
	erlang:register(Name, Pid);

register(global, Name, Pid) ->
	global:re_register_name(Name, Pid).

unregister(local, Name) ->
	erlang:unregister(Name);

unregister(global, Name) ->
	global:unregister_name(Name).

is_process_alive(Pid) ->    
	try 
		if 
            is_pid(Pid) ->
     			case node(Pid) =:= node() of
                    true ->
                        erlang:is_process_alive(Pid);
                    false ->
                        case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
                            {badrpc, _Reason}  -> false;
                            Res -> Res
                        end
                end;
			true -> false
		end
	catch 
		_:_ -> false
	end.

%% 玩家进程名
player_process_name(PlayerId) ->
	list_to_atom(lists:concat([player_, PlayerId])).

%% 获取玩家进程
get_player_process(Id) ->
    misc:whereis_name(global, player_process_name(Id)).

 %% 玩家发送进程名
player_send_process_name(PlayerId) ->
    list_to_atom(lists:concat([mls_, PlayerId])).

 %% 场景管理进程名
scene_process_name(Sid, PoolId) ->
    list_to_atom(lists:concat([scene_, Sid, "_", PoolId])).

 %% 场景管理进程名
mark_process_name(Sid) ->
    list_to_atom(lists:concat([mark_, Sid])).

%% 日常次数进程名
daily_process_name(PlayerId) ->
    list_to_atom(lists:concat([daily_, PlayerId])).

%% 获取日常次数进程
get_daily_process(Id) ->
    misc:whereis_name(global, daily_process_name(Id)).

%% 周次数进程名
week_process_name(PlayerId) ->
    list_to_atom(lists:concat([week_, PlayerId])).
    
%% 获取周次数进程
get_week_process(Id) ->
    misc:whereis_name(global, week_process_name(Id)).

%% 终生次数进程名
counter_process_name(PlayerId) ->
    list_to_atom(lists:concat([counter_, PlayerId])).
    
%% 获取终生次数进程
get_counter_process(Id) ->
    misc:whereis_name(global, counter_process_name(Id)).

%% 自增id进程名
autoid_process_name(IdType) ->
    list_to_atom(lists:concat([auto_id_, IdType])).

%% 自增id进程名
autoid_extra_process_name(IdType) ->
    list_to_atom(lists:concat([auto_id_extra_, IdType])).

get_autoid_process(IdType) ->
    misc:whereis_name(global, autoid_process_name(IdType)).

get_autoid_extra_process(IdType) ->
    misc:whereis_name(global, autoid_extra_process_name(IdType)).    

get_child_count(Atom) ->
	case whereis_name(local, Atom) of
		undefined -> 
			0;
		_ ->
			[_,{active, ChildCount},_,_] = supervisor:count_children(Atom),
			ChildCount
	end.

pg2_get_members(Pg2_name) ->
    L = case pg2:get_members(Pg2_name) of 
            {error, _} ->
                timer:sleep(100),
                pg2:get_members(Pg2_name);
            Other when is_list(Other) ->
                Other
        end,
    if  not is_list(L) -> [];
        true -> lists:usort(L)
    end.

%% 获取全局pid
%% 代替gen_server:casr({global, ?MODULE}, ...).
get_global_pid(Module) ->
    whereis_name(global, Module).


%% 监控玩家进程
monitor_pid(Key, Event) ->
    T = utime:unixtime(),
    case get({monitor, Key}) of
        undefined ->
            put({monitor, Key}, {T, 1, [Event]});
        {T1, C1, _EventList}->
            case T - T1 > 0 of
                true ->
                    %put({monitor, Key}, {T, 1, [Event]});
                    put({monitor, Key}, {T, 1, []});
                false ->
                    %put({monitor, Key}, {T1, C1+1, [Event | EventList]})
                    put({monitor, Key}, {T1, C1+1, []})
            end,
            case C1 > 1000 of
                true ->
                    ?ERR("monitor_pid last_event:~p", [Event]),
                    ?ERR("monitor_pid event_list:~p", [_EventList]),
                    exit({unexpected_message, Event});
                false ->
                    skip
            end
    end.

%% 监控玩家进程
monitor_pid_special(Key, Event) ->
    T = utime:unixtime(),
    case get({monitor, Key}) of
        undefined ->
            put({monitor, Key}, {T, 1, [Event]});
        {T1, C1, _EventList}->
            case T - T1 > 0 of
                true ->
                    put({monitor, Key}, {T, 1, []});
                false ->
                    put({monitor, Key}, {T1, C1+1, []})
            end,
            LimitTime = case util:is_dev() of true -> 5000; _ -> 3000 end,
            case C1 > LimitTime of
                true ->
                    ?ERR("monitor_pid_special last_event:~p", [Event]),
                    ?ERR("monitor_pid_special event_list:~p", [_EventList]),
                    exit({unexpected_message, Event});
                false ->
                    skip
            end
    end.
