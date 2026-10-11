-module(mod_luckey_wheel_local).

-behaviour(gen_server).

-include("common.hrl").
-include("custom_act.hrl").
-include("luckey_wheel.hrl").
-include("errcode.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        act_open/3,
        act_end/2,
        clear_data/2,
        send_record/3
        ,draw_reward/8
        ,init_after/1
        ,update_data/2
        ,get_pool_reward/3
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_open(Type, SubType, Endtime) ->
    gen_server:cast(?MODULE, {'act_open', Type, SubType, Endtime}).

act_end(Type, SubType) ->
    gen_server:cast(?MODULE, {'act_end', Type, SubType}).

clear_data(Type, SubType) ->
    gen_server:cast(?MODULE, {'clear_data', Type, SubType}).

draw_reward(Type, SubType, Server, ServerNum, RoleId, RoleName, Times, Autobuy) ->
    gen_server:call(?MODULE, {'draw_reward', Type, SubType, Server, ServerNum, RoleId, RoleName, Times, Autobuy}).

send_record(Type, SubType, RoleId) ->
    gen_server:cast(?MODULE, {'send_record', Type, SubType, RoleId}).

init_after(SendMap) ->
    gen_server:cast(?MODULE, {'init_after', SendMap}).

update_data(SendActData, RecordList) ->
    gen_server:cast(?MODULE, {'update_data', SendActData, RecordList}).

get_pool_reward(Type, SubType, RoleId) ->
    gen_server:cast(?MODULE, {'get_pool_reward', Type, SubType, RoleId}).

init([]) ->
    TypeList = [?CUSTOM_ACT_TYPE_LUCKEY_WHEEL],
    Fun = fun(Type, {ActMap, RecordMap, ActList}) ->
        SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
        Fun2 = fun(SubType, {Map1, Map2, AccList}) ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            IsKF = lib_luckey_wheel_mod:get_conditions(is_kf, Conditions),
            if
                IsKF == 1 ->
                    {Map1, Map2, [{Type, SubType}|AccList]};
                true ->
                    {ActData, RecordList} = lib_luckey_wheel_mod:init_helper(Type, SubType),
                    NewList = lib_luckey_wheel_mod:handle_record(RecordList),
                    {maps:put({Type, SubType}, ActData, Map1), maps:put({Type, SubType}, NewList, Map2), AccList}
            end
        end,
        lists:foldl(Fun2, {ActMap, RecordMap, ActList}, SubTypes)
    end,
    {AMap, RMap, RequestList} = lists:foldl(Fun, {#{},#{}, []}, TypeList),
    RequestList =/= [] andalso mod_luckey_wheel_kf:cast_center([{'local_init', config:get_server_id(), RequestList}]),
    {ok, #local_wheel_state{act_data = AMap, record = RMap}}.

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

do_handle_cast({'init_after', SendMap}, State) ->
    List = maps:to_list(SendMap),
    #local_wheel_state{act_data = AMap, record = RMap} = State,
    Fun = fun
        ({{Type, SubType}, {SendActData, RecordList}}, {ActMap, RecordMap}) when SendActData =/= [] ->
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    DataList = db:get_all(io_lib:format(?SELECT_ROLR_DATA, [Type, SubType])),
                    RoleData = [{RoleId, DrawTimes}||[RoleId, DrawTimes] <- DataList],
                    ActData = SendActData#act_data{role_data = RoleData},
                    {maps:put({Type, SubType}, ActData, ActMap), maps:put({Type, SubType}, RecordList, RecordMap)};
                _ ->
                    {ActMap, RecordMap}
            end;
        (_, {ActMap, RecordMap}) -> {ActMap, RecordMap}
    end,
    {NewActMap, NewRecordMap} = lists:foldl(Fun, {AMap, RMap}, List),
    {noreply, State#local_wheel_state{act_data = NewActMap, record = NewRecordMap}};

do_handle_cast({'act_open', Type, SubType, Endtime}, State) ->
    % ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    % #act_info{wlv = WLv} = ActInfo,
    #local_wheel_state{act_data = AMap} = State,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    IsKF = lib_luckey_wheel_mod:get_conditions(is_kf, Conditions),
    % Now = utime:unixtime(),
    if
        IsKF == 1 ->
            case maps:get({Type, SubType}, AMap, []) of
                [] ->
                    mod_luckey_wheel_kf:cast_center([{'act_open', Type, SubType, config:get_server_id(), Endtime}]);
                _ ->
                    skip
            end,
            ActMap = AMap;
        true ->
            case maps:get({Type, SubType}, AMap, []) of
                [] ->
                    case lists:keyfind(base_pool_reward, 1, Conditions) of
                        {_, PoolReward} -> skip;
                        _ -> PoolReward = [{1, 0, 3000}]
                    end,
                    db:execute(io_lib:format(?UPDATE_ACT_DATA, [Type, SubType, util:term_to_string(PoolReward), 0])),
                    ActData = #act_data{key = {Type, SubType}, pool_reward = PoolReward,
                        draw_times = 0, role_data = []};
                ActData ->
                    ActData
            end,
            ActMap = maps:put({Type, SubType}, ActData, AMap)
    end,
    {noreply, State#local_wheel_state{act_data = ActMap}};

do_handle_cast({'update_data', #act_data{key = {Type, SubType}, pool_reward = PoolReward, draw_times = DrawTimes} = SendActData, RecordList}, State) ->
    #local_wheel_state{act_data = AMap, record = RMap} = State,
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            case maps:get({Type, SubType}, AMap, []) of
                #act_data{role_data = RoleData} -> skip;
                _ -> RoleData = []
            end,
            ActData = SendActData#act_data{role_data = RoleData},
            db:execute(io_lib:format(?UPDATE_ACT_DATA, [Type, SubType, util:term_to_string(PoolReward), DrawTimes])),
            ActMap = maps:put({Type, SubType}, ActData, AMap),
            #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            IsKF = lib_luckey_wheel_mod:get_conditions(is_kf, ActConditions),
            Fun = fun(#wheel_record{
                        role_id = RoleId,
                        server_num = ServerNum,
                        role_name = RoleName,
                        reward = Reward}, Acc) ->
                if
                    IsKF == 1 ->
                        % Name = lists:concat(["S", util:term_to_string(ServerNum), ".", util:term_to_string(RoleName)]);
                        Name = uio:format("S{1}.{2}", [ServerNum, RoleName]);
                    true ->
                        Name = RoleName
                end,
                [{RoleId, Name, Reward}|Acc]
            end,
            SendList = lists:foldl(Fun, [], RecordList),
            {ok, BinData} = pt_331:write(33197, [Type, SubType, SendList, []]),
            MinLv = lib_luckey_wheel_mod:get_conditions(role_lv, ActConditions),
            lib_server_send:send_to_all(all_lv, {MinLv, 9999}, BinData),
            {ok, BinData1} = pt_332:write(33213, [Type, SubType, PoolReward, ?SUCCESS]),
            lib_server_send:send_to_all(all_lv, {MinLv, 9999}, BinData1),
            RecordMap = maps:put({Type, SubType}, RecordList, RMap);
        _ ->
            ActMap = AMap, RecordMap = RMap
    end,
    {noreply, State#local_wheel_state{act_data = ActMap, record = RecordMap}};

do_handle_cast({'act_end', Type, SubType}, State) ->
    #local_wheel_state{act_data = AMap, record = RMap} = State,
    ActMap = maps:remove({Type, SubType}, AMap),
    RecordMap = maps:remove({Type, SubType}, RMap),
    db:execute(io_lib:format(?DELETE_ROLE_DATA, [Type, SubType])),
    db:execute(io_lib:format(?DELETE_ACT_DATA, [Type, SubType])),
    db:execute(io_lib:format(?DELETE_ACT_GRADE_DATA, [Type, SubType])),
    case lib_custom_act_api:get_open_subtype_ids(Type) of
        [] ->
            db:execute(io_lib:format(?TRUNCATE_ACT_RECORD, []));
        _ ->
            db:execute(io_lib:format(?DELETE_ACT_RECORD, [Type, SubType]))
    end,
    NewState = State#local_wheel_state{act_data = ActMap, record = RecordMap},
    {noreply, NewState};

do_handle_cast({'clear_data', Type, SubType}, State) ->
    #local_wheel_state{act_data = AMap, record = RMap} = State,
    case maps:get({Type, SubType}, AMap, []) of
        [] ->
            NewState = State;
        #act_data{} = ActData ->
            db:execute(io_lib:format(?DELETE_ROLE_DATA, [Type, SubType])),
            ActMap = maps:put({Type, SubType}, ActData#act_data{role_data = []}, AMap),
            NewState = State#local_wheel_state{act_data = ActMap, record = RMap}
    end,
    {noreply, NewState};

do_handle_cast({'send_record', Type, SubType, RoleId}, State) ->
    #local_wheel_state{record = RMap} = State,
    RecordList = maps:get({Type, SubType}, RMap, []),
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    IsKF = lib_luckey_wheel_mod:get_conditions(is_kf, ActConditions),
    Fun = fun(#wheel_record{
                role_id = TemRoleId,
                server_num = ServerNum,
                role_name = RoleName,
                reward = Reward}, Acc) ->
        if
            IsKF == 1 ->
                % Name = lists:concat(["S", util:term_to_string(ServerNum), ".", util:term_to_string(RoleName)]);
                Name = uio:format("S{1}.{2}", [ServerNum, RoleName]);
            true ->
                Name = RoleName
        end,
        [{TemRoleId, Name, Reward}|Acc]
    end,
    SendList = lists:foldl(Fun, [], RecordList),
    {ok, BinData} = pt_331:write(33197, [Type, SubType, SendList, []]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_pool_reward', Type, SubType, RoleId}, State) ->
    #local_wheel_state{act_data = AMap} = State,
    case maps:get({Type, SubType}, AMap, []) of
        [] ->
            {ok, BinData} = pt_332:write(33213, [Type, SubType, [], ?ERRCODE(err331_act_closed)]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State};
        #act_data{pool_reward = []} = Data ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lists:keyfind(base_pool_reward, 1, Conditions) of
                {_, PoolReward} -> skip;
                _ -> PoolReward = [{1, 0, 3000}]
            end,
            {ok, BinData} = pt_332:write(33213, [Type, SubType, PoolReward, ?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State#local_wheel_state{act_data = AMap#{{Type, SubType} => Data#act_data{pool_reward = PoolReward}}}};
        #act_data{pool_reward = PoolReward} ->
            {ok, BinData} = pt_332:write(33213, [Type, SubType, PoolReward, ?SUCCESS]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State}
    end;

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call({'draw_reward', Type, SubType, Server, ServerNum, RoleId, RoleName, Times, _Autobuy}, State) ->
    #local_wheel_state{act_data = AMap, record = RecordMap} = State,
    case maps:get({Type, SubType}, AMap, []) of
        [] ->
            Reply = ?ERRCODE(err331_act_closed),
            NewState = State;
        #act_data{role_data = RoleData, pool_reward = PoolReward, draw_times = DrawTimes, role_counter = CounterMap} = ActData ->
            case lists:keyfind(RoleId, 1, RoleData) of
                {_, RoleDrawTimes} -> skip;
                _ -> RoleDrawTimes = 0
            end,
            CounterList = maps:get({Type, SubType}, CounterMap, []),
            case lists:keyfind(RoleId, 1, CounterList) of
                {_, RoleCounterList} -> skip;
                _ -> RoleCounterList = []
            end,
            {NewDrawTimes, NewRoleDrawTimes, NewRoleClist, NewGradeIdList} = lib_luckey_wheel_mod:do_draw_reward(Type, SubType, RoleId, DrawTimes, RoleDrawTimes, Times, RoleCounterList, []),
            NewRoleData = lists:keystore(RoleId, 1, RoleData, {RoleId, NewRoleDrawTimes}),
            db:execute(io_lib:format(?UPDATE_ROLE_DATA, [Type, SubType, RoleId, RoleDrawTimes])),
            #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            AddPoolReward = lib_luckey_wheel_mod:calc_pool_reward(Times, ActConditions),
            NewCounterList = lists:keystore(RoleId, 1, CounterList, {RoleId, NewRoleClist}),
            NewCountMap = maps:put({Type, SubType}, NewCounterList, CounterMap),
            NPoolReward = ulists:object_list_plus([AddPoolReward, PoolReward]),
            IsKF = lib_luckey_wheel_mod:get_conditions(is_kf, ActConditions),
            RecordList = maps:get({Type, SubType}, RecordMap, []),
            {NewRecordList, AddRecordL, DeletePool} = lib_luckey_wheel_mod:handle_draw_grade(Type, SubType, PoolReward, IsKF, RoleId, RoleName, Server, ServerNum, NewGradeIdList, RecordList, [], []),
            NewPoolReward0 = lib_luckey_wheel_mod:object_list_minus([NPoolReward, DeletePool]),
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lists:keyfind(base_pool_reward, 1, Conditions) of
                _ when NewPoolReward0 =/= [] -> NewPoolReward = NewPoolReward0;
                {_, NewPoolReward} -> skip;
                _ -> NewPoolReward = [{1, 0, 3000}]
            end,
            NewList = lib_luckey_wheel_mod:handle_record(NewRecordList),
            if
                IsKF == 1 ->
                    mod_luckey_wheel_kf:cast_center([{'update_data_after_draw', Type, SubType, Times, AddPoolReward, AddRecordL, DeletePool}]);
                true ->
                    Fun = fun(#wheel_record{
                            role_id = TemRoleId,
                            role_name = TemRoleName,
                            reward = Reward}, Acc) ->
                        [{TemRoleId, TemRoleName, Reward}|Acc]
                    end,
                    SendList = lists:foldl(Fun, [], NewRecordList),
                    {ok, BinData} = pt_331:write(33197, [Type, SubType, SendList, []]),
                    MinLv = lib_luckey_wheel_mod:get_conditions(role_lv, ActConditions),
                    lib_server_send:send_to_all(all_lv, {MinLv, 9999}, BinData),
                    {ok, BinData1} = pt_332:write(33213, [Type, SubType, NewPoolReward, ?SUCCESS]),
                    lib_server_send:send_to_all(all_lv, {MinLv, 9999}, BinData1),
                    db:execute(io_lib:format(?UPDATE_ACT_DATA, [Type, SubType, util:term_to_string(NewPoolReward), NewDrawTimes]))
            end,
            NewActData = ActData#act_data{
                role_data = NewRoleData,
                pool_reward = NewPoolReward,
                draw_times = NewDrawTimes,
                role_counter = NewCountMap},
            Reply = {ok, PoolReward, NewGradeIdList},
            NewState = State#local_wheel_state{act_data = maps:put({Type, SubType}, NewActData, AMap), record = maps:put({Type, SubType}, NewList, RecordMap)}
    end,
    {reply, Reply, NewState};

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

