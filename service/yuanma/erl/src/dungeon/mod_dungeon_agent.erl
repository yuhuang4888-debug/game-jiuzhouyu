%% ---------------------------------------------------------------------------
%% @doc mod_dungeon_agenet.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本管理进程:处理玩家上下线回去副本
%% ---------------------------------------------------------------------------
-module(mod_dungeon_agent).
-export([
        get_dungeon_record/1
        , remove_dungeon_record/1
        , remove_dungeon_record/2
        , set_dungeon_record/1
    ]).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("dungeon.hrl").

%% 获取副本记录.
get_dungeon_record(RoleId)->
    gen_server:call(misc:get_global_pid(?MODULE), {'get_dungeon_record', RoleId}).

%% 设置副本记录.
set_dungeon_record(DungeonRecrod)->
    gen_server:cast(misc:get_global_pid(?MODULE), {'set_dungeon_record', DungeonRecrod}).

%% 移除副本记录
remove_dungeon_record(RoleId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'remove_dungeon_record', RoleId}).

%% 根据副本Pid,移除副本记录
remove_dungeon_record(RoleId, DunPid) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'remove_dungeon_record', RoleId, DunPid}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    erlang:send_after(30 * 1000, self(), 'check_dungeon_alive'),
    {ok, ?MODULE}.

%% 获取副本记录.
handle_call({'get_dungeon_record', RoleId}, _From, State) ->
    case get(RoleId) of
        undefined ->
            {reply, [], State};
        DungeonRecrod ->
            {reply, [DungeonRecrod], State}
    end;

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 设置副本记录.
handle_cast({'set_dungeon_record', DungeonRecrod}, State) ->
    put(DungeonRecrod#dungeon_record.role_id, DungeonRecrod),
    {noreply, State};

%% 移除副本记录
handle_cast({'remove_dungeon_record', RoleId}, State) ->
    erase(RoleId),
    {noreply, State};

%% 移除副本记录
handle_cast({'remove_dungeon_record', RoleId, DunPid}, State) ->
    case get(RoleId) of
        undefined ->
            {noreply, State};
        #dungeon_record{dun_pid = DunPid} ->
            erase(RoleId),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

handle_cast(Msg, State) ->
    catch ?ERR("mod_dungeon_agent:handle_cast not match: ~p", [Msg]),
    {noreply, State}.

%% 检测副本是否活着.
handle_info('check_dungeon_alive', State) ->
    %1.5分钟检测一次.
    erlang:send_after(5 * 60 * 1000, self(), 'check_dungeon_alive'),
    Time = utime:unixtime(),
    %2.定义检测副本存活函数.
    F = fun(DungeonRecrod) ->
        DunPid = DungeonRecrod#dungeon_record.dun_pid,
        RoleId = DungeonRecrod#dungeon_record.role_id,
        case is_pid(DunPid) andalso misc:is_process_alive(DunPid) of
            true ->
                case Time - DungeonRecrod#dungeon_record.end_time >= 300 of
                    true ->
                        mod_dungeon:close_dungeon(DunPid),
                        erase(RoleId);
                    false ->
                        skip
                end;               
            false ->
                erase(RoleId)
        end
    end, 
    %3.检测所有副本.
    AllRecord = get(),
    [F(DunRecord) || {Key, DunRecord} <- AllRecord, is_integer(Key)],
    {noreply, State};

handle_info(Info, State) ->
    catch ?ERR("mod_dungeon_agent:handle_info not match: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.