%% ---------------------------------------------------------------------------
%% @doc mod_team_create
%% @author ming_up@foxmail.com
%% @since  2016-10-22
%% @deprecated mod_team_create 自动计数器
%% ---------------------------------------------------------------------------
-module(mod_team_create).
-behaviour(gen_server).

-include("common.hrl").
-include("errcode.hrl").
-export([start_link/0, get_new_id/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export ([
    create_team/5
    ,remove_created_team/3
    ,create_for_take_over/3
    ]).

-record(state, {
        auto_id=0           % 自增id
        , server_id=0       % 服id
        , tmp_teams = []    
    }).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_new_id() -> 
    gen_server:call(?MODULE, 'get_new_id').

create_team(Node, RoleId, CreateTime, RespondArgs, Args) ->
    gen_server:cast(?MODULE, {create_team, Node, RoleId, CreateTime, RespondArgs, Args}).

remove_created_team(TeamId, CreateTime, Result) ->
    gen_server:cast(?MODULE, {remove_created_team, TeamId, CreateTime, Result}).

create_for_take_over(Args, From, FailReturn) ->
    gen_server:cast(?MODULE, {create_for_take_over, Args, From, FailReturn}).

init([]) -> 
    %% process_flag(priority, high),
    AutoId = case config:get_cls_type() of
        ?NODE_CENTER -> 2;
        _ -> 1
    end,
    SerId = config:get_server_id(),
    {ok, #state{auto_id=AutoId, server_id=SerId}}.

handle_call('get_new_id' , _FROM, #state{auto_id=AutoId, server_id=SerId} = Status) ->
    TeamId = calc_new_id(AutoId, SerId),
    {reply, TeamId, Status#state{auto_id=AutoId+2}};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_cast({create_team, Node, RoleId, CreateTime, RespondArgs, Args}, Status) ->
    #state{auto_id = AutoId, server_id = SerId, tmp_teams = TmpTeams} = Status,
    TeamId = calc_new_id(AutoId, SerId),
    TeamArgs = [TeamId|Args],
    case catch mod_team:start(TeamArgs) of
        {ok, TeamPid} ->
            unode:apply(Node, lib_team, create_team_respond, [node(), RoleId, CreateTime, [TeamId, TeamPid, RespondArgs]]),
            {noreply, Status#state{auto_id = TeamId + 2, tmp_teams = [{TeamId, TeamPid, CreateTime}|TmpTeams]}};
        Error ->
            ?ERR("create_team ~p error ~p~n", [TeamArgs, Error]),
            unode:apply(Node, lib_team, create_team_respond, [node(), RoleId, CreateTime, fail]),
            {noreply, Status}
    end;

handle_cast({create_for_take_over, Args, From, FailReturn}, Status) ->
    #state{auto_id = AutoId, server_id = SerId} = Status,
    TeamId = calc_new_id(AutoId, SerId),
    TeamArgs = [TeamId|Args],
    case catch mod_team:start(TeamArgs) of
        {ok, _TeamPid} ->
            {noreply, Status#state{auto_id = TeamId + 2}};
        Error ->
            ?ERR("create_team ~p error ~p~n", [TeamArgs, Error]),
            From ! {ignore_waiting, {take_over_team_fail, FailReturn}},
            {noreply, Status}
     end;

handle_cast({remove_created_team, TeamId, CreateTime, Result}, Status) ->
    #state{tmp_teams = TmpTeams} = Status,
    case lists:keytake(TeamId, 1, TmpTeams) of
        {value, {TeamId, TeamPid, CreateTime}, OtherTeams} ->
            case Result =:= ?SUCCESS of
                true ->
                    ok;
                _ ->
                    mod_team:stop(TeamPid)
            end,
            {noreply, Status#state{tmp_teams = OtherTeams}};
        _ ->
            {noreply, Status}
    end;

handle_cast(_R , Status) ->
    {noreply, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% 计算队伍id
calc_new_id(AutoId, ServerId) ->
    <<TeamId:48>> = <<ServerId:16, AutoId:32>>,
    TeamId.