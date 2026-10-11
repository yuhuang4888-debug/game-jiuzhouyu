%% ---------------------------------------------------------------------------
%% @doc lib_recharge_limit

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/23
%% @deprecated  该功能提供给运营设置指定平台指定账号玩家的所有角色的充值
%%          计算不参与指定活动的充值榜单 （比如不让内玩的充值记录参与到头号玩家的充值榜单）
%% ---------------------------------------------------------------------------
-module(lib_recharge_limit).

%% API
-export([
    check_recharge_limit/2,
    check_recharge_limit_direct/2
]).

-include("server.hrl").
-include("recharge_limit.hrl").

check_recharge_limit(AccId, AccName) ->
    OpenDay = util:get_open_day(),
    {OpenDayD, OpenDayU} = data_recharge_limit:duration_opday(),
    if
        OpenDay >= OpenDayD andalso OpenDay =< OpenDayU ->
            Key = {AccId, AccName},
            case ets:lookup(?ETS_RECHARGE_LIMIT, Key) of
                [#ets_recharge_limit{}] ->
                    true;
                _Res ->
                    false
            end;
        true -> false
    end.

check_recharge_limit_direct(AccId, AccName) ->
    Key = {AccId, AccName},
    case ets:lookup(?ETS_RECHARGE_LIMIT, Key) of
        [#ets_recharge_limit{}] ->
            true;
        _Res ->
            false
    end.




