%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_war
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-04
%% @Description:    公会争霸
%%-----------------------------------------------------------------------------
-module(mod_guild_war).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("guild_war.hrl").

-export([start_link/0]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

-export([
    get_act_status/0
    , get_all_guild_ids/0
    , is_dominator_guild/1
    , get_dominator_info/0
    , send_act_info/1
    , send_gwar_view_info/1
    , enter_scene/3
    , exit_scene/2
    , sync_guild_list/1
    , update_guild_info/2
    , disband_guild/1
    , send_dominator_info/3
    , send_streak_reward_info/1
    , send_break_reward_info/1
    , allot_reward/5
    , receive_salary_paul/3
    , sync_battle_result/3
    , role_login/2
    ]).

-export([
    gm_confirm/0
    , gm_start/0
    , gm_test/0
    , gm_reset/1
    , clear_gwar_confirm_info/0
    ]).

start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).

callback_mode()->
    handle_event_function.

init([]) ->
    case catch lib_guild_war_mod:init() of
        {ok, State} ->
            NowTime = utime:unixtime(),
            {StateName, ActStatus, CountDownTime, Etime} = lib_guild_war:get_next_time(NowTime),
            if
                ActStatus == ?ACT_STATUS_CONFIRM ->
                    %% 进程启动时候处于确认阶段但是数据库没有D赛区的公会需要重新去公会进程拿一遍
                    lib_guild_war_mod:repair_division_map(),
                    LastStateName = StateName,
                    LastActStatus = ActStatus;
                true ->
                    LastStateName = StateName,
                    LastActStatus = ActStatus
            end,
            Ref = erlang:send_after(CountDownTime * 1000, self(), 'time_out'),
            LastState = State#status_guild_war{
                status = LastActStatus,
                etime = Etime,
                ref = Ref},
            {ok, LastStateName, LastState};
        {stop, Reason} ->
            ?ERR("guild war init err:~p", [Reason]),
            {stop, Reason};
        Reason ->
            ?ERR("guild war init err:~p", [Reason]),
            {stop, Reason}
    end.

get_act_status() ->
    gen_statem:call(?MODULE, 'act_status').

get_all_guild_ids() ->
    gen_statem:call(?MODULE, 'get_all_guild_ids').

is_dominator_guild(GuildId) ->
    gen_statem:call(?MODULE, {'is_dominator_guild', GuildId}, 1000).

get_dominator_info() ->
    gen_statem:call(?MODULE, {'get_dominator_info'}, 1000).

send_act_info(RoleId) ->
    gen_statem:cast(?MODULE, {'send_act_info', RoleId}).

send_gwar_view_info(RoleId) ->
    gen_statem:cast(?MODULE, {'send_gwar_view_info', RoleId}).

enter_scene(GuildId, RoleId, JoinGuildTime) ->
    gen_statem:cast(?MODULE, {'enter_scene', GuildId, RoleId, JoinGuildTime}).

exit_scene(GuildId, RoleId) ->
    gen_statem:cast(?MODULE, {'exit_scene', GuildId, RoleId}).

sync_guild_list(GuildList) ->
    gen_statem:cast(?MODULE, {'sync_guild_list', GuildList}).

update_guild_info(GuildId, KeyValList) ->
    gen_statem:cast(?MODULE, {'update_guild_info', GuildId, KeyValList}).

disband_guild(GuildId) ->
    gen_statem:cast(?MODULE, {'disband_guild', GuildId}).

sync_battle_result(Division, RoomId, WinGuildId) ->
    gen_statem:cast(?MODULE, {'sync_battle_result', Division, RoomId, WinGuildId}).

send_dominator_info(RoleId, GuildId, JoinGuildTime) ->
    gen_statem:cast(?MODULE, {'send_dominator_info', RoleId, GuildId, JoinGuildTime}).

send_streak_reward_info(RoleId) ->
    gen_statem:cast(?MODULE, {'send_streak_reward_info', RoleId}).

send_break_reward_info(RoleId) ->
    gen_statem:cast(?MODULE, {'send_break_reward_info', RoleId}).

allot_reward(RoleId, GuildId, Type, SpecifyId, Extra) ->
    gen_statem:cast(?MODULE, {'allot_reward', RoleId, GuildId, Type, SpecifyId, Extra}).

receive_salary_paul(RoleId, GuildId, SalaryPaulReward) ->
    gen_statem:cast(?MODULE, {'receive_salary_paul', RoleId, GuildId, SalaryPaulReward}).

role_login(GuildId, RoleId) ->
    gen_statem:cast(?MODULE, {'role_login', GuildId, RoleId}).

gm_test() ->
    gen_statem:cast(?MODULE, {'test'}).

gm_confirm() ->
    ?MODULE ! 'gm_confirm'.

gm_start() ->
    ?MODULE ! 'gm_start'.

gm_reset(RoleId) ->
    gen_statem:cast(?MODULE, {'gm_reset'}),
    send_act_info(RoleId).

clear_gwar_confirm_info() ->
    gen_statem:call(?MODULE, {'clear_gwar_confirm_info'}, 1000).

handle_event(Type = {call, _From}, Msg, StateName, State) ->
    case catch mod_guild_war_call:handle_event(Type, Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_event_error:~p~n", [[Type, Msg, StateName, _R]]),
            {keep_state, State};
        Reply -> Reply
    end;

handle_event(cast, Msg, StateName, State) ->
    case catch mod_guild_war_cast:handle_event(Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_event_error:~p~n", [[Msg, StateName, _R]]),
            {keep_state, State};
        Reply -> Reply
    end;

handle_event(info, Msg, StateName, State) ->
    case catch mod_guild_war_info:handle_event(Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_event_error:~p~n", [[Msg, StateName, _R]]),
            {keep_state, State};
        Reply -> Reply
    end.

terminate(_Reason, _StateName, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.