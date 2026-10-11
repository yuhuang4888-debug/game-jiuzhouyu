%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%         延迟发放奖励
%%% @end
%%% Created : 04. 8月 2022 16:58
%%%-------------------------------------------------------------------
-module(lib_delay_reward).

-include("server.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").

%% API
-export([
    login/1
    , set_delay_reward/3
    , send_delay_reward/2
    , handle_event/2
]).

-define(sql_delay_reward_select, <<"select proto_id, reward from role_delay_reward where role_id = ~p">>).
-define(sql_delay_reward_replace, <<"replace into role_delay_reward(role_id, proto_id, reward) values(~p, ~p, '~s')">>).
-define(sql_delay_reward_delete, <<"delete from role_delay_reward where role_id = ~p and proto_id = ~p">>).

login(Ps) ->
    #player_status{id = Id} = Ps,
    DdlayList = db:get_all(io_lib:format(?sql_delay_reward_select, [Id])),


    F = fun([ProtoId, RewardBin], Acc) ->
        [{ProtoId, undefined, util:bitstring_to_term(RewardBin)} | Acc]
        end,
    DdlayReward = lists:foldl(F, [], DdlayList),
    Ps#player_status{delay_reward = DdlayReward}.

handle_event(Ps, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    #player_status{delay_reward = DelayReward} = Ps,
    NewPs = foreach_send(DelayReward, Ps),
    {ok, NewPs};
handle_event(Player, _) ->
    {ok, Player}.

foreach_send([], Ps) -> Ps;
foreach_send([{ProtoId, _Ref, _Reward} | N], Ps) ->
    NewPs = send_delay_reward(Ps, ProtoId),
    foreach_send(N, NewPs).

%% 设置延迟奖励
set_delay_reward(Ps, ProtoId, Reward) ->
    #player_status{id = Id, delay_reward = DelayReward} = Ps,
    Ref = erlang:send_after(10000, self(), {'send_delay_reward', ProtoId}),
    {_, OldRef, OldReward} = ulists:keyfind(ProtoId, 1, DelayReward, {ProtoId, undefined,[]}),
    case OldRef of
        undefined -> skip;
        _ -> erlang:cancel_timer(OldRef)
    end,
    NewReward = OldReward ++ Reward,
    NewDelayReward = lists:keystore(ProtoId, 1, DelayReward, {ProtoId, Ref, NewReward}),
    db:execute(io_lib:format(?sql_delay_reward_replace, [Id, ProtoId, util:term_to_bitstring(NewReward)])),
    Ps#player_status{delay_reward = NewDelayReward}.

%% 发放延迟奖励
send_delay_reward(Ps, ProtoId) ->
    #player_status{id = Id, delay_reward = DelayReward} = Ps,
    case lists:keyfind(ProtoId, 1, DelayReward) of
        {_, OldRef, OldReward} ->
            case OldRef of
                undefined -> skip;
                _ -> erlang:cancel_timer(OldRef)
            end,
            Source = get_source_by_proto(ProtoId),
            db:execute(io_lib:format(?sql_delay_reward_delete, [Id, ProtoId])),
            SendPs = lib_goods_api:send_reward(Ps, OldReward, Source, 0),
            NewDelayReward = lists:keydelete(ProtoId, 1, DelayReward),
            NewPlayer = SendPs#player_status{delay_reward = NewDelayReward};
        _ -> NewPlayer = Ps
    end,
    NewPlayer.

get_source_by_proto(33262) -> act_wish_draw;
get_source_by_proto(_) -> act_wish_draw.