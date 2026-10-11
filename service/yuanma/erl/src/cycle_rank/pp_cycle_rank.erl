%% ---------------------------------------------------------------------------
%% @doc pp_cycle_rank

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##路由模块
%% ---------------------------------------------------------------------------

-module(pp_cycle_rank).

%% API

-export([
    handle/3
]).


-include("common.hrl").
-include("server.hrl").


%%  获取正在开启的活动
handle(22700, Player, []) ->
    lib_cycle_rank:send_open_cycle_rank_info(Player);

%%  界面信息
handle(22701, Player, [Type, Subtype]) ->
    case lib_cycle_rank:is_in_open_seven_day() of
        true ->
            skip;
        _ ->
            lib_cycle_rank:send_player_cycle_rank_info(Player, Type, Subtype)
    end;

%%  榜单信息
handle(22702, Player, [Type, Subtype]) ->
    case lib_cycle_rank:is_in_open_seven_day() of
        true ->
            skip;
        _ ->
            lib_cycle_rank:send_cycle_rank_list(Player, Type, Subtype)
    end;

%%  查看昨日榜单信息
handle(22703, Player, []) ->
    case lib_cycle_rank:is_in_open_seven_day() of
        true ->
            skip;
        _ ->
            lib_cycle_rank:send_show_time_list(Player)
    end;

%%  领取阶段奖励
handle(22704, Player, [Type, Subtype, RewardId]) ->
    case lib_cycle_rank:is_in_open_seven_day() of
        true ->
            NewPs = Player;
        _ ->
            NewPs = lib_cycle_rank:get_reach_reward(Player, Type, Subtype, RewardId)
    end,
    {ok, NewPs};

handle(22705, Player, []) ->
    % 登录的时候客户端请求，这个时候清一下时间间隔先
    case lib_cycle_rank:is_in_open_seven_day() of
        true ->
            skip;
        _ ->
            mod_cycle_rank_local:role_refresh_send_time(Player#player_status.id)
    end;

handle(_Cmd, _Player, _Data) ->
    ?PRINT("route occur not match error, CMD ~p, Args ~p ~n", [_Cmd, _Data]).

