%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_war_info
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-06
%% @Description:
%%-----------------------------------------------------------------------------
-module(mod_guild_war_info).

-include("guild_war.hrl").
-include("common.hrl").

-export([handle_event/3]).

handle_event('time_out', close, State) ->
    #status_guild_war{ref = ORef} = State,
    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    {StateName, ActStatus, CountDownTime, Etime} = lib_guild_war:get_next_time(NowTime),
    if
        ActStatus == ?ACT_STATUS_CONFIRM -> %% 确认期确定各赛区参加公会的信息
            mod_guild:sync_guild_list_to_gwar();
        true -> skip
    end,
    Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), 'time_out'),
    NewState = State#status_guild_war{
        status = ActStatus,
        etime = Etime,
        ref = Ref
    },
    {next_state, StateName, NewState};

handle_event('time_out', OldStateName, State) when OldStateName == confirm orelse OldStateName == rest ->
    #status_guild_war{index_map = IndexMap} = State,
    JoinGuildNum = maps:size(IndexMap),
    case OldStateName == confirm andalso JoinGuildNum == 0 of
        true -> %% 如果没有公会参加跳过这届公会争霸
            NowTime = utime:unixtime(),
            Unixdate = utime:unixdate(),
            Ref = erlang:send_after((Unixdate + 86400 - NowTime) * 1000 + 1, self(), 'time_out'),
            NewStateName = close,
            NewState = State#status_guild_war{
                status = ?ACT_STATUS_CLOSE,
                etime = Unixdate + 86400,
                ref = Ref
            };
        false ->
            case OldStateName == confirm of
                true ->
                    erase("battle_round");
                false -> skip
            end,
            NewStateName = battle,
            % ?ERR("OldStateName:~p BattleRound:~p", [OldStateName, lib_guild_war:get_battle_round()]),
            NewState = lib_guild_war_mod:start_battle(State)
    end,
    {next_state, NewStateName, NewState};

handle_event('time_out', battle, State) ->
    #status_guild_war{
        ref = ORef,
        index_map = IndexMap,
        room_map = GWarRoomMap
    } = State,
    util:cancel_timer(ORef),
    NowTime = utime:unixtime(),
    Unixdate = utime:unixdate(NowTime),
    TotalRounds = data_guild_war:get_cfg(total_rounds),
    BattleRound = lib_guild_war:get_battle_round(),
    case BattleRound < TotalRounds of
        true ->
            ActStatus = ?ACT_STATUS_REST,
            StateName = rest,
            CountDownTime = data_guild_war:get_cfg(rest_time),
            Etime = NowTime + CountDownTime,
            lib_guild_war_mod:send_act_tv(?TV_TYPE_BATTLE_END, [IndexMap]),
            NewState = State;
        false ->
            ActStatus = ?ACT_STATUS_CLOSE,
            StateName = close,
            CountDownTime = Unixdate + 86401 - NowTime,
            Etime = Unixdate + 86401,
            case lib_guild_war_mod:is_sync_battle_result_finish(GWarRoomMap) of
                true ->
                    NewState = lib_guild_war_mod:act_end(State);
                false -> %% 有房间的战斗结果还没同步完成不处理结算
                    NewState = State
            end
    end,
    % ?ERR("BattleEnd NextState:~p", [StateName]),
    Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), 'time_out'),
    LastState = NewState#status_guild_war{
        status = ActStatus,
        etime = Etime,
        ref = Ref
    },
    lib_guild_war_mod:broadcast_act_info(LastState),
    {next_state, StateName, LastState};

handle_event('gm_confirm', _, State) ->
    #status_guild_war{ref = ORef} = State,
    util:cancel_timer(ORef),

    mod_guild:sync_guild_list_to_gwar(),

    ConfirmTime = data_guild_war:get_cfg(confirm_time),
    OpenTime = data_guild_war:get_cfg(open_time),
    RealConfirmTime = lib_guild_war:format_time(ConfirmTime),
    RealOpenTime = lib_guild_war:format_time(OpenTime),
    CountDownTime = max(1, RealOpenTime - RealConfirmTime),

    Ref = erlang:send_after(CountDownTime * 1000 + 1, self(), 'time_out'),

    NowTime = utime:unixtime(),

    NewState = State#status_guild_war{
        status = ?ACT_STATUS_CONFIRM,
        etime = NowTime + CountDownTime,
        ref = Ref
    },
    {next_state, confirm, NewState};

handle_event('gm_start', _, State) ->
    erase("battle_round"),

    LastState = lib_guild_war_mod:start_battle(State),

    {next_state, battle, LastState};

handle_event(_Msg, _StateName, State) ->
    ?ERR("no match :~p~n", [[ _Msg, _StateName]]),
    {keep_state, State}.