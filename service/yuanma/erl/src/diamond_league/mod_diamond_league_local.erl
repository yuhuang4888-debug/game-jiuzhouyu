%%-----------------------------------------------------------------------------
%% @Module  :       mod_diamond_league_local.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-04-18
%% @Description:    星战联盟本服缓存
%%-----------------------------------------------------------------------------
-module (mod_diamond_league_local).
-include ("common.hrl").
-include ("diamond_league.hrl").
-include ("errcode.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,setup_state/4
    ,update_state/4
    , update_min_power/1
    ,get_league_info/1
    ,get_state_info/1
    ,mark_role_never_apply/1
    ,mark_player_applied/2
    ,mark_player_lose/2
    ,get_apply_info/2
    ,player_enter/1
    ,get_history/2
    ,get_history_respond/2
    ,update_role_power/2
    ,update_role_power_res/3
    ,get_apply_list/1
    ,set_apply_list/1
]).

-record (state, {
    cycle_index = 0,
    state_id = 0,
    start_time = 0,
    end_time = 0,
    min_power = 0,
    role_list = [],
    history = #{},
    global_apply_list = undefined
    }).

-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

update_min_power(MinPower) ->
    gen_server:cast(?SERVER, {update_min_power, MinPower}).

setup_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {setup_state, CycleIndex, StateId, StartTime, EndTime}).

update_state(CycleIndex, StateId, StartTime, EndTime) ->
    gen_server:cast(?SERVER, {update_state, CycleIndex, StateId, StartTime, EndTime}).

get_league_info(RoleId) ->
    gen_server:cast(?SERVER, {get_league_info, RoleId}).

get_state_info(RoleId) ->
    gen_server:cast(?SERVER, {get_state_info, RoleId}).

mark_role_never_apply(RoleId) ->
    gen_server:cast(?SERVER, {mark_role_never_apply, RoleId}).

get_apply_info(RoleId, MyPower) ->
    gen_server:cast(?SERVER, {get_apply_info, RoleId, MyPower}).

mark_player_applied(RoleId, Index) ->
    gen_server:cast(?SERVER, {mark_player_applied, RoleId, Index}).

mark_player_lose(RoleId, Round) ->
    gen_server:cast(?SERVER, {mark_player_lose, RoleId, Round}).

player_enter(RoleId) ->
    gen_server:cast(?SERVER, {player_enter, RoleId}).

get_history(RoleId, CycleIndex) ->
    gen_server:cast(?SERVER, {get_history, RoleId, CycleIndex}).

get_history_respond(CycleIndex, Data) ->
    gen_server:cast(?SERVER, {get_history_respond, CycleIndex, Data}).

update_role_power(RoleId, Power) ->
    gen_server:cast(?SERVER, {update_role_power, RoleId, Power}).

update_role_power_res(RoleId, Power, Index) ->
    gen_server:cast(?SERVER, {update_role_power_res, RoleId, Power, Index}).

get_apply_list(RoleId) ->
    gen_server:cast(?SERVER, {get_apply_list, RoleId}).

set_apply_list(List) ->
    gen_server:cast(?SERVER, {set_apply_list, List}).

%% private
init([]) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_diamond_league_ctrl, get_cur_state, [Node]),
    {ok, #state{}}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({setup_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    case State of
        #state{state_id = StateId, start_time = StartTime, end_time = EndTime} ->
            {noreply, State};
        _ ->
            NewState = #state{state_id = StateId, start_time = StartTime, end_time = EndTime, cycle_index = CycleIndex},
            {noreply, NewState}
    end;

do_handle_cast({update_state, CycleIndex, StateId, StartTime, EndTime}, State) ->
    case State of
        #state{state_id = StateId, start_time = StartTime, end_time = EndTime} ->
            {noreply, State};
        _ ->
             if
                StateId =:= ?STATE_APPLY ->
                    RoleList = [];
                is_record(State, state) ->
                    RoleList = State#state.role_list;
                true ->
                    RoleList = []
            end,
            NewState = #state{state_id = StateId, start_time = StartTime, end_time = EndTime, cycle_index = CycleIndex, role_list = RoleList},
            brocast_update_state(NewState),
            {noreply, NewState}
    end;

do_handle_cast({get_state_info, RoleId}, State) ->
    #state{state_id = StateId, end_time = EndTime} = State,
    {ok, BinData} = pt_604:write(60401, [StateId, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({get_league_info, RoleId}, State) ->
    #state{cycle_index = CycleIndex0, role_list = RoleList, state_id = StateId} = State,
    CycleIndex = if StateId =:= ?STATE_CLOSED -> CycleIndex0; true -> CycleIndex0 - 1 end,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        #league_role{index = Index, round = Round, win = ?WIN_STATE_LOSE} ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex, Index, 1, Round]),
            lib_server_send:send_to_uid(RoleId, BinData);
        #league_role{index = Index} when Index == 0 orelse StateId =:= ?STATE_APPLY ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex, Index, 0, 0]),
            lib_server_send:send_to_uid(RoleId, BinData);
        #league_role{round = Round, index = Index} when Round > ?MELEE_ROUND_NUM + ?KING_ROUND_NUM ->
            {ok, BinData} = pt_604:write(60404, [CycleIndex, Index, 1, Round]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_league_info, [Node, RoleId])
    end,
    {noreply, State};

do_handle_cast({mark_role_never_apply, RoleId}, State) ->
    #state{role_list = RoleList} = State,
    Role = #league_role{role_id = RoleId, index = 0},
    NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, Role),
    {noreply, State#state{role_list = NewRoleList}};

do_handle_cast({get_apply_info, RoleId, MyPower}, State) ->
    #state{min_power = MinPower} = State,
    {ok, BinData} = pt_604:write(60402, [MyPower, MinPower]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({update_min_power, MinPower}, State) ->
    {noreply, State#state{min_power = MinPower}};

do_handle_cast({mark_player_applied, RoleId, Index}, State) ->
    #state{role_list = RoleList} = State,
    Role
    = case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            #league_role{role_id = RoleId, index = Index};
        R ->
            R#league_role{index = Index}
    end,
    NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, Role),
    {noreply, State#state{role_list = NewRoleList}};

do_handle_cast({player_enter, RoleId}, State) ->
    #state{state_id = StateId} = State,
    if
        StateId =:= ?STATE_ENTER ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, player_enter, [Node, RoleId, []]);
        true ->
            {ok, BinData} = pt_604:write(60400, [?ERRCODE(err604_not_enter_state), []]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({mark_player_lose, RoleId, Round}, State) ->
    #state{role_list = RoleList} = State,
    Role
    = case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        false ->
            #league_role{role_id = RoleId, win = ?WIN_STATE_LOSE, round = Round};
        R ->
            R#league_role{round = Round, win = ?WIN_STATE_LOSE}
    end,
    NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, Role),
    {noreply, State#state{role_list = NewRoleList}};

do_handle_cast({get_history, RoleId, CycleIndex}, State) ->
    #state{history = History} = State,
    case maps:find(CycleIndex, History) of
        {ok, {ok, BinData}} ->
            lib_server_send:send_to_uid(RoleId, BinData),
            {noreply, State};
        {ok, {waiting, RoleIds}} ->
            case length(RoleIds) rem 3 of
                0 ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_history, [Node, CycleIndex]);
                _ ->
                    skip
            end,
            case lists:member(RoleId, RoleIds) of
                true ->
                    {noreply, State};
                _ ->
                    NewHistory = History#{CycleIndex => {waiting, [RoleId|RoleIds]}},
                    {noreply, State#state{history = NewHistory}}
            end;
        _ ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_diamond_league_schedule, get_history, [Node, CycleIndex]),
            NewHistory = History#{CycleIndex => {waiting, [RoleId]}},
            {noreply, State#state{history = NewHistory}}
    end;

do_handle_cast({get_history_respond, CycleIndex, BinData}, State) ->
    #state{history = History} = State,
    case maps:find(CycleIndex, History) of
        {ok, {waiting, RoleIds}} ->
            [lib_server_send:send_to_uid(RoleId, BinData) || RoleId <- RoleIds];
        _ ->
            ok
    end,
    {noreply, State#state{history = History#{CycleIndex => {ok, BinData}}}};

do_handle_cast({update_role_power, RoleId, Power}, State) ->
    #state{state_id = StateId, role_list = RoleList, min_power = MinPower} = State,
    if
        StateId =:= ?STATE_APPLY ->
            case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
                #league_role{index = Index, power = OldPower} when Index > 0 andalso OldPower =< MinPower andalso Power > MinPower ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(lib_diamond_league_apply, update_role_power, [Node, RoleId, Power, Index]);
                _ ->
                    ok
            end;
        true ->
            ok
    end,
    {noreply, State};

do_handle_cast({update_role_power_res, RoleId, Power, Index}, State) ->
    #state{role_list = RoleList} = State,
    case lists:keyfind(RoleId, #league_role.role_id, RoleList) of
        Role when is_record(Role, league_role) ->
            NewRoleList = lists:keystore(RoleId, #league_role.role_id, RoleList, Role#league_role{index = Index, power = Power}),
            {noreply, State#state{role_list = NewRoleList}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({get_apply_list, RoleId}, State) ->
    if
        State#state.state_id =:= ?STATE_APPLY ->
            #state{global_apply_list = GlobalList} = State,
            ?PRINT("GlobalList = ~p~n", [GlobalList]),
            NowTime = utime:unixtime(),
            case GlobalList of
                {waiting, RoleList} ->
                    case lists:member(RoleId, RoleList) of
                        true ->
                            {noreply, State};
                        _ ->
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(lib_diamond_league_apply, get_apply_list, [Node]),
                            {noreply, State#state{global_apply_list = {waiting, [RoleId|RoleList]}}}
                    end;
                {Time, BinData} when NowTime < Time ->
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {noreply, State};
                _ ->
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(lib_diamond_league_apply, get_apply_list, [Node]),
                    {noreply, State#state{global_apply_list = {waiting, [RoleId]}}}
            end;
        true ->
            {noreply, State}
    end;

do_handle_cast({set_apply_list, List}, State) ->
    #state{global_apply_list = GlobalLost} = State,
    ReqRoles
    = case GlobalLost of
        {waiting, R} -> R;
        _ -> []
    end,
    FormatList = [{RoleId, Name, ServName, GuildName, Lv, Power} || #apply_role{role_id = RoleId, role_name = Name, server_name = ServName, lv = Lv, guild_name = GuildName, power = Power} <- List],
    {ok, BinData} = pt_604:write(60419, [FormatList]),
    Lenth = length(List),
    DelayReqTime
    = if
           Lenth > 20 -> 120;
          true -> 30
    end,
    [lib_server_send:send_to_uid(RoleId, BinData) || RoleId <- ReqRoles],
    {noreply, State#state{global_apply_list = {utime:unixtime() + DelayReqTime, BinData}}};


do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    % ?PRINT("State = ~p~n", [State]),
    {noreply, State}.

%% internal

brocast_update_state(State) ->
    #state{state_id = StateId, end_time = EndTime} = State,
    {ok, BinData} = pt_604:write(60401, [StateId, EndTime]),
    OpenLv = data_diamond_league:get_kv(?CFG_KEY_OPEN_LV),
    % ?PRINT("brocast_update_state ~p~n", [[StateId, EndTime, OpenLv]]),
    lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData).