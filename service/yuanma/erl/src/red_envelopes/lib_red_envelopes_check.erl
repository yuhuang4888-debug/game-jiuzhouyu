%%-----------------------------------------------------------------------------
%% @Module  :       lib_red_envelopes_check
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-22
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_red_envelopes_check).

-include("server.hrl").
-include("figure.hrl").

-export([
    check_list/2
    ]).

check_list([], _Player) -> true;
check_list([H|T], Player) ->
    case check(H, Player) of
        true ->
            check_list(T, Player);
        _ -> false
    end.

check({fir_recharge}, Player) ->
    TodayRecharge = lib_recharge_api:get_today_pay_gold(Player#player_status.id),
    TodayRecharge > 0;
check({today_recharge, NeedRecharge}, Player) ->
    TodayRecharge = lib_recharge_api:get_today_pay_gold(Player#player_status.id),
    TodayRecharge >= NeedRecharge;
check({vip, NeedVipLv}, Player) ->
    #player_status{figure = Figure} = Player,
    Figure#figure.vip >= NeedVipLv;
check(_, _Player) -> false.