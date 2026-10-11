-module(mod_luckey_wheel_kf).

-behaviour(gen_server).

-include("common.hrl").
-include("luckey_wheel.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

%================================================================
%%本地->跨服中心 
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

%================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    erlang:send_after(100, self(), {'init_state'}),
    {ok, #kf_wheel_state{kf_act_data = #{}, kf_record = #{}}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'local_init', ServerId, ActList}, State) ->
    #kf_wheel_state{kf_act_data = ActMap, kf_record = RecordMap} = State,
    Fun = fun({Type, SubType}, Map) ->
        SendActData = case maps:get({Type, SubType}, ActMap, []) of
            [] ->
                [];
            #kf_act_data{pool_reward = PoolReward, draw_times = DrawTimes} ->
                #act_data{key = {Type, SubType}, pool_reward = PoolReward, draw_times = DrawTimes, role_data = []}
        end,
        RecordList = maps:get({Type, SubType}, RecordMap, []),
        maps:put({Type, SubType}, {SendActData, RecordList}, Map)
    end,
    SendMap = lists:foldl(Fun, #{}, ActList),
    mod_clusters_center:apply_cast(ServerId, mod_luckey_wheel_local, init_after, [SendMap]),
    {noreply, State};

do_handle_cast({'act_open', Type, SubType, ServerId, Endtime}, State) ->
    #kf_wheel_state{kf_act_data = ActMap, kf_record = RecordMap} = State,
    Now = utime:unixtime(),
    case maps:get({Type, SubType}, ActMap, []) of
        [] ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = Conditions, clear_type = _ClearType} ->
                    case lists:keyfind(base_pool_reward, 1, Conditions) of
                        {_, PoolReward} -> skip;
                        _ -> PoolReward = [{1, 0, 3000}]
                    end,
                    EndRef = erlang:send_after(max((Endtime - Now)*1000, 5000), self(), {'act_end', Type, SubType}),
                    ActData = #kf_act_data{key = {Type, SubType}, pool_reward = PoolReward, draw_times = 0,
                        end_time = Endtime, end_ref = EndRef},
                    SendActData = #act_data{key = {Type, SubType}, pool_reward = PoolReward, draw_times = 0, role_data = []},
                    db:execute(io_lib:format(?UPDATE_ACT_DATA_KF, [Type, SubType, util:term_to_string(PoolReward), 0, Endtime])),
                    RecordList = maps:get({Type, SubType}, RecordMap, []),
                    mod_clusters_center:apply_to_all_node(mod_luckey_wheel_local, update_data, [SendActData, RecordList]),
                    NewMap = maps:put({Type, SubType}, ActData, ActMap);
                _ ->
                    NewMap = ActMap
            end;
        #kf_act_data{pool_reward = PoolReward, draw_times = DrawTimes} ->
            SendActData = #act_data{key = {Type, SubType}, pool_reward = PoolReward, draw_times = DrawTimes, role_data = []},
            RecordList = maps:get({Type, SubType}, RecordMap, []),
            mod_clusters_center:apply_cast(ServerId, mod_luckey_wheel_local, update_data, [SendActData, RecordList]),
            NewMap = ActMap
    end,
    {noreply, State#kf_wheel_state{kf_act_data = NewMap}};

do_handle_cast({'update_data_after_draw', Type, SubType, Times, AddPoolReward, AddRecordL, DeletePool}, State) ->
    #kf_wheel_state{kf_act_data = ActMap, kf_record = RecordMap} = State,
    case maps:get({Type, SubType}, ActMap, []) of
        [] ->
            NewActMap = ActMap,
            NewRecordMap = RecordMap,
            ?ERR("lost act data: Type:~p, SubType:~p~n",[Type, SubType]);
        #kf_act_data{pool_reward = PoolReward, draw_times = DrawTimes, end_time = Endtime} = Actdata ->
            NPoolReward = ulists:object_list_plus([AddPoolReward, PoolReward]),
            NewPoolReward = lib_luckey_wheel_mod:object_list_minus([NPoolReward, DeletePool]),
            ?PRINT("NewPoolReward:~p~n",[NewPoolReward]),
            NewActData = Actdata#kf_act_data{pool_reward = NewPoolReward, draw_times = DrawTimes+Times},
            RecordList = maps:get({Type, SubType}, RecordMap, []),
            db:execute(io_lib:format(?UPDATE_ACT_DATA_KF, [Type, SubType, util:term_to_string(NewPoolReward), DrawTimes+Times, Endtime])),
            NewList = lib_luckey_wheel_mod:handle_record(RecordList++AddRecordL),
            save_record(AddRecordL),
            SendActData = #act_data{key = {Type, SubType}, pool_reward = NewPoolReward, draw_times = DrawTimes+Times},
            mod_clusters_center:apply_to_all_node(mod_luckey_wheel_local, update_data, [SendActData, NewList]),
            NewActMap = maps:put({Type, SubType}, NewActData, ActMap),
            NewRecordMap = maps:put({Type, SubType}, NewList, RecordMap)
    end,
    {noreply, State#kf_wheel_state{kf_act_data = NewActMap, kf_record = NewRecordMap}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'init_state'}, State) ->
    {ActMap, RecordMap} = init_helper(),
    {noreply, State#kf_wheel_state{kf_act_data = ActMap, kf_record = RecordMap}};

do_handle_info({'act_end', Type, SubType}, State) ->
    #kf_wheel_state{kf_act_data = AMap, kf_record = RMap} = State,
    case maps:get({Type, SubType}, AMap, []) of
        [] ->
            NewState = State;
        #kf_act_data{end_ref = Ref} ->
            util:cancel_timer(Ref),
            ActMap = maps:remove({Type, SubType}, AMap),
            RecordMap = maps:remove({Type, SubType}, RMap),
            db:execute(io_lib:format(?DELETE_ACT_DATA_KF, [Type, SubType])),
            case maps:size(ActMap) == 0 of
                true ->
                    db:execute(io_lib:format(?TRUNCATE_ACT_RECORD_KF, []));
                _ ->
                    db:execute(io_lib:format(?DELETE_ACT_RECORD_KF, [Type, SubType]))
            end,
            NewState = State#kf_wheel_state{kf_act_data = ActMap, kf_record = RecordMap}
    end,
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    {noreply, State}.

init_helper() ->
    List1 = db:get_all(io_lib:format(?SELECT_ACT_DATA_KF, [])),
    Now = utime:unixtime(),
    Fun = fun([Type, SubType, PoolReward, DrawTimes, Endtime], Map) ->
        if
            Endtime > Now ->
                EndRef = erlang:send_after((Endtime - Now)*1000, self(), {'act_end', Type, SubType}),
                ActData = #kf_act_data{key = {Type, SubType}, pool_reward = util:bitstring_to_term(PoolReward), 
                    draw_times = DrawTimes, end_time = Endtime, end_ref = EndRef},
                maps:put({Type, SubType}, ActData, Map);
            true ->
                db:execute(io_lib:format(?DELETE_ACT_DATA_KF, [Type, SubType])),
                db:execute(io_lib:format(?DELETE_ACT_RECORD_KF, [Type, SubType])),
                Map
        end
    end,
    ActMap = lists:foldl(Fun, #{}, List1),
    List2 = db:get_all(io_lib:format(?SELECT_ACT_RECORD_KF, [])),
    Fun2 = fun([Server, ServerNum, Type, SubType, RoleId, RoleName, Reward, Stime], Map2) ->
        RecordList = maps:get({Type, SubType}, Map2, []),
        Record = #wheel_record{
            key = {Type, SubType},
            server = Server,
            server_num = ServerNum,
            role_id = RoleId,
            role_name = RoleName,
            reward = util:bitstring_to_term(Reward),
            stime = Stime},
        maps:put({Type, SubType}, [Record|RecordList], #{})
    end,
    RecordMap = lists:foldl(Fun2, #{}, List2),
    Fun3 = fun(_, V) ->
        lib_luckey_wheel_mod:handle_record(V)
    end,
    NewRecordMap = maps:map(Fun3, RecordMap),
    {ActMap, NewRecordMap}.

save_record([]) -> ok;
save_record([#wheel_record{
            key = {Type, SubType},
            server = Server,
            server_num = ServerNum,
            role_id = RoleId,
            role_name = RoleName,
            reward = Reward,
            stime = Stime}|AddRecordL]) ->
    db:execute(io_lib:format(?UPDATE_ACT_RECORD_KF, [Server, ServerNum, Type, SubType, RoleId, RoleName, util:term_to_string(Reward), Stime])),
    save_record(AddRecordL);
save_record([_|AddRecordL]) -> save_record(AddRecordL).

