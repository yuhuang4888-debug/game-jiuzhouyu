%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------
-module(mod_kf_guild_war).

-behavious(gen_server).

-include("kf_guild_war.hrl").
-include("common.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    msg_local2center/1
    ]).

-export([
    send_act_info/2
    , send_seas_overview_info/3
    , send_seas_info/7
    , send_occupy_reward_info/4
    , receive_daily_reward/5
    , send_season_reward_info/2
    , send_seas_dominator_info/2
    , send_donate_view_info/5
    , send_declare_war_view_info/4
    , send_bid_view_info/4
    , declare_war/9
    , cancel_declare_war/8
    , enter_scene/6
    , island_battle_end/2
    , reset_season/0
    , role_login/3
    ]).

-export([
    gm_next/0
    , recheck_stage/0
    , clear_guild_info/1
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

msg_local2center(Msg) ->
    gen_server:cast(?MODULE, {'msg_local2center', Msg}).

send_act_info(Node, RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', Node, RoleId}).

send_seas_overview_info(Node, RoleId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'send_seas_overview_info', Node, RoleId, MergeSerIds}).

send_seas_info(Node, GuildId, RoleId, SeasType, SeasSubType, MergeSerIds, DailyRewardStatus) ->
    gen_server:cast(?MODULE, {'send_seas_info', Node, GuildId, RoleId, SeasType, SeasSubType, MergeSerIds, DailyRewardStatus}).

send_occupy_reward_info(Node, RoleId, MergeSerIds, DailyRewardStatus) ->
    gen_server:cast(?MODULE, {'send_occupy_reward_info', Node, RoleId, MergeSerIds, DailyRewardStatus}).

receive_daily_reward(Node, RoleId, GuildId, GuildPos, MergeSerIds) ->
    gen_server:cast(?MODULE, {'receive_daily_reward', Node, RoleId, GuildId, GuildPos, MergeSerIds}).

send_season_reward_info(Node, RoleId) ->
    gen_server:cast(?MODULE, {'send_season_reward_info', Node, RoleId}).

send_seas_dominator_info(Node, RoleId) ->
    gen_server:cast(?MODULE, {'send_seas_dominator_info', Node, RoleId}).

send_donate_view_info(Node, RoleId, QualificationIds, ResourceMap, DonateMap) ->
    gen_server:cast(?MODULE, {'send_donate_view_info', Node, RoleId, QualificationIds, ResourceMap, DonateMap}).

send_declare_war_view_info(Node, GuildId, RoleId, IslandId) ->
    gen_server:cast(?MODULE, {'send_declare_war_view_info', Node, GuildId, RoleId, IslandId}).

send_bid_view_info(Node, RoleId, IslandId, GuildFunds) ->
    gen_server:cast(?MODULE, {'send_bid_view_info', Node, RoleId, IslandId, GuildFunds}).

declare_war(Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid) ->
    gen_server:cast(?MODULE, {'declare_war', Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid}).

cancel_declare_war(Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId) ->
    gen_server:cast(?MODULE, {'cancel_declare_war', Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId}).

enter_scene(Node, SerId, SerName, GuildId, RoleId, Name) ->
    gen_server:cast(?MODULE, {'enter_scene', Node, SerId, SerName, GuildId, RoleId, Name}).

island_battle_end(IslandId, GuildList) ->
    gen_server:cast(?MODULE, {'island_battle_end', IslandId, GuildList}).

reset_season() ->
    gen_server:cast(?MODULE, {'reset_season'}).

role_login(Node, GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'role_login', Node, GuildId, RoleId}).

%% ---------------------- 秘籍 -----------------------
gm_next() ->
    gen_server:cast(?MODULE, {'gm_next'}).

recheck_stage() ->
    gen_server:cast(?MODULE, {'recheck_stage'}).

clear_guild_info(GuildId) ->
    gen_server:cast(?MODULE, {'clear_guild_info', GuildId}).
%% ---------------------- 秘籍 -----------------------

init([]) ->
    State = lib_kf_guild_war_mod:init(#kf_guild_war_state{}),
    NowTime = utime:unixtime(),
    {ActStatus, NextStatus, CountDownTime, Etime} = lib_kf_guild_war:check_stage(State, NowTime),
    NewState = State#kf_guild_war_state{status = ActStatus, etime = Etime},
    if
        ActStatus == ?ACT_STATUS_CLOSE andalso NextStatus == ?ACT_STATUS_APPOINT ->
            NewState1 = NewState,
            Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), {'appoint'});
        ActStatus == ?ACT_STATUS_APPOINT ->
            NewState1 = NewState,
            Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), {'confirm'});
        ActStatus == ?ACT_STATUS_CONFIRM ->
            NewState1 = lib_kf_guild_war_mod:confirm_group_in_init(NewState, NowTime),
            Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), {'battle'});
        true ->
            NewState1 = NewState,
            Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), {'check_stage'})
    end,
    LastState = NewState1#kf_guild_war_state{
        status = ActStatus,
        etime = Etime,
        ref = Ref
    },
    {ok, LastState}.

handle_cast(Msg, State) ->
    case catch mod_kf_guild_war_cast:handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch mod_kf_guild_war_info:handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

handle_call(Request, _From, State) ->
    case catch mod_kf_guild_war_call:handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
