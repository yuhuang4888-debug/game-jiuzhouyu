%% ---------------------------------------------------------------------------
%% @doc 拍卖行服务进程
%% @author lxl
%% @since  2021-3-3
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(mod_player_info_report).
-behaviour(gen_server).
-include("common.hrl").
-include("php.hrl").


%% API
-export([start_link/0]).
-export([
        add_report/2
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(time_tick, 3000). %% 

-record (state, {
    ref = none
    , power_infos = []
    , level_infos = []
    , chat_infos = []
}).



start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

add_report(Type, Data) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {add_report, Type, Data}).


do_call(_Request, _From, State) ->
    {reply, ok, State}.

do_cast(stop, State) ->
    {stop, normal, State};

do_cast({add_report, Type, Data}, State) ->
    case Type of 
        power ->
            PowerInfos = State#state.power_infos,
            NewState = State#state{power_infos = [Data|PowerInfos]};
        level ->
            LevelInfos = State#state.level_infos,
            NewState = State#state{level_infos = [Data|LevelInfos]};
        chat ->
            ChatInfos = State#state.chat_infos,
            NewState = State#state{chat_infos = [Data|ChatInfos]}
    end,
    %?PRINT("add_report:~p~n", [NewState]),
    {noreply, NewState};


do_cast(_Msg, State) ->
    {noreply, State}.

do_info({report, ReportMsg}, State) ->
    %?PRINT("report msg: ~p~n", [ReportMsg]),
    {NextReport, NextTime} = get_next_report(ReportMsg),
    Ref = util:send_after(State#state.ref, NextTime, self(), {report, NextReport}),
    State1 = report_info(ReportMsg, State),
    NewState = State1#state{ref = Ref},
    {noreply, NewState};


do_info(_Info, State) ->
    {noreply, State}.   

%% --------------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------------
init(_Args) ->
    Ref = util:send_after([], ?time_tick, self(), {report, power}),
    State = #state{
        ref = Ref
    },
    ?PRINT("report init ~n", []),
    {ok, State}.

%% --------------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch do_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n", [Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_cast(Msg, State) ->
    case catch do_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------------
handle_info(Info, State) ->
    case catch do_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n", [Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

%% --------------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------------
terminate(_Reason, _State) ->
    report_last(_State),
    ok.

%% --------------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------------


get_next_report(ReportMsg) ->
    case ReportMsg of 
        power -> {level, 1000};
        level -> {chat, 1000};
        chat -> {power, ?time_tick}
    end.

report_info(power, State) ->
    PowerInfos = lists:reverse(State#state.power_infos),
    case PowerInfos of 
        [] -> State;
        _ ->
            NowTime = utime:unixtime(),
            AuthStr = lib_player_info_report:calc_auth(NowTime),
            case length(PowerInfos) >= 500 of 
                true ->
                    {List, Left} = lists:split(500, PowerInfos);
                _ ->
                    List = PowerInfos,
                    Left = []
            end,
            JsonPostData = iolist_to_binary(mochijson2:encode(List)),
            PostData = [
                {method, 'game.powerReport'}, {time, NowTime}, 
                {cp_id, lib_player_info_report:get_game_id()}, 
                {data, JsonPostData}, {sign, AuthStr}
            ],
            StrBody = mochiweb_util:urlencode(PostData),
            % ?PRINT("List:~p~n", [List]),
            % ?PRINT("JsonPostData:~s~n", [JsonPostData]),
            % ?PRINT("StrBody:~s~n", [StrBody]),
            %?MYLOG("lxl", "body:~s~n", [StrBody]),
            mod_php:request(lib_player_info_report:get_url(), StrBody, 
                #php_request{mfa = {lib_player_info_report, reply_request_role_report, [power]}}),
            State#state{power_infos = lists:reverse(Left)}
    end;
report_info(level, State) ->
    LevelInfos = lists:reverse(State#state.level_infos),
    case LevelInfos of 
        [] -> State;
        _ ->
            NowTime = utime:unixtime(),
            AuthStr = lib_player_info_report:calc_auth(NowTime),
            case length(LevelInfos) >= 500 of 
                true ->
                    {List, Left} = lists:split(500, LevelInfos);
                _ ->
                    List = LevelInfos,
                    Left = []
            end,
            JsonPostData = iolist_to_binary(mochijson2:encode(List)),
            PostData = [
                {method, 'game.levelReport'}, {time, NowTime}, 
                {cp_id, lib_player_info_report:get_game_id()}, 
                {data, JsonPostData}, {sign, AuthStr}
            ],
            StrBody = mochiweb_util:urlencode(PostData),
            % ?PRINT("List:~p~n", [List]),
            % ?PRINT("JsonPostData:~s~n", [JsonPostData]),
            % ?PRINT("StrBody:~s~n", [StrBody]),
            % ?MYLOG("lxl", "body:~s~n", [StrBody]),
            mod_php:request(lib_player_info_report:get_url(), StrBody, 
                #php_request{mfa = {lib_player_info_report, reply_request_role_report, [level]}}),
            State#state{level_infos = lists:reverse(Left)}
    end;
report_info(chat, State) ->
    ChatInfos = lists:reverse(State#state.chat_infos),
    case ChatInfos of 
        [] -> State;
        _ ->
            NowTime = utime:unixtime(),
            AuthStr = lib_player_info_report:calc_auth(NowTime),
            case length(ChatInfos) >= 500 of 
                true ->
                    {List, Left} = lists:split(500, ChatInfos);
                _ ->
                    List = ChatInfos,
                    Left = []
            end,
            JsonPostData = iolist_to_binary(mochijson2:encode(List)),
            PostData = [
                {method, 'game.chatReport'}, {time, NowTime}, 
                {cp_id, lib_player_info_report:get_game_id()}, 
                {data, JsonPostData}, {sign, AuthStr}
            ],
            StrBody = mochiweb_util:urlencode(PostData),
            % ?PRINT("List:~p~n", [List]),
            % ?PRINT("JsonPostData:~s~n", [JsonPostData]),
            % ?PRINT("StrBody:~s~n", [StrBody]),
            %?MYLOG("lxl", "body:~s~n", [StrBody]),
            mod_php:request(lib_player_info_report:get_url(), StrBody, 
                #php_request{mfa = {lib_player_info_report, reply_request_role_report, [chat]}}),
            State#state{chat_infos = lists:reverse(Left)}
    end.

report_last(State) ->
    #state{power_infos = PowerInfos, level_infos = LevelInfos, chat_infos = ChatInfos} = State,
    case PowerInfos =/= [] orelse LevelInfos =/= [] orelse ChatInfos =/= [] of 
        true ->
            State1 = report_info(power, State),
            State2 = report_info(level, State1),
            State3 = report_info(chat, State2),
            report_last(State3);
        _ ->
            ok
    end.