%%-----------------------------------------------------
%% @module 冲级礼包
%% @create_by yxf
%% @create_date 20171121
%%-----------------------------------------------------
-module(lib_rush_giftbag).
-export([
    login/1,
    refresh_rush_status/2,
    rush_giftbag_lv_up/1,
    send_to_all_online/1
]).
-include("rec_rush_giftbag.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("common.hrl").

%% 登录
login(PS) ->
    case get_rgb_state_from_db(PS#player_status.id) of
        [] ->
            RefreshedData = refresh_rush_status(PS#player_status.figure#figure.lv, []),
            PS#player_status{rush_giftbag = #rush_giftbag{giftbag_state = RefreshedData}};
        [RushGB_B] ->
            RushGBData = util:bitstring_to_term(RushGB_B),
            F = fun({Glv, State}, L) -> [{Glv, State, 0, 0}|L] end,
            RushGBDataList = lists:foldl(F, [], RushGBData),
            RefreshedData = refresh_rush_status(PS#player_status.figure#figure.lv, RushGBDataList),
            PS#player_status{rush_giftbag = #rush_giftbag{giftbag_state = RefreshedData}}
    end.

%% 刷新礼包状态
refresh_rush_status(RoleLv, RushDbStatus) ->
    AllBagLv = data_rush_giftbag:get_all_giftbag_lv(),
    CounterList = [{?MOD_WELFARE, ?RUSH_GIFTBAG, Lv} || Lv <- AllBagLv],
    AllGiftCounts = mod_global_counter:get_count(CounterList, []),
    Opday = util:get_open_day(),
    OpTime = util:get_open_time(),
    F2 = fun({{_, _, GLv}, Count}, TL) ->
        case lists:keyfind(GLv, 1, RushDbStatus) of
            {GLv, ?GIFTBAG_RECEIVED, _, _} ->
                #base_rush_giftbag{bag_upperlimit = LimitCount} = data_rush_giftbag:get_giftbag_cfg(GLv),
                RemainCount = max(0, (LimitCount-Count)),
                [{GLv, ?GIFTBAG_RECEIVED, 0, RemainCount}|TL];    % 礼包已经领取
            _ ->
                case data_rush_giftbag:get_giftbag_cfg(GLv) of
                    #base_rush_giftbag{bag_upperlimit = LimitCount, bag_upperday = LimitDay} ->
                        EndTime = ?IF(LimitDay > 0, (OpTime + LimitDay *24 * 60 * 60), 0),
                        RemainCount = max(0, (LimitCount-Count)),
                        E = if
                            RoleLv < GLv -> {GLv, ?GIFTBAG_NOT_RECEIVED, EndTime, RemainCount};   % 等级不足
                            Opday > LimitDay andalso LimitDay /= 0 -> {GLv, ?GIFTBAG_TIME_OVER, 0, RemainCount}; % 时间超了
                            true ->  {GLv, ?GIFTBAG_CAN_RECEIVE, EndTime, RemainCount}
                        end,
                        [E|TL];
                    [] -> [{GLv, ?GIFTBAG_TIME_OVER, 0, 0}|TL]    % 没有配置
                end
        end
    end,
    NewState = lists:foldl(F2, [], AllGiftCounts),
    NewState.

%%  数据库取数据
get_rgb_state_from_db(PlayerId) ->
    Sql = io_lib:format(?sql_get_rush_giftbag, [PlayerId]),
    db:get_row(Sql).

%%  等级礼包判断
rush_giftbag_lv_up(Ps) ->
    Lv = Ps#player_status.figure#figure.lv,
    case data_rush_giftbag:get_giftbag_cfg(Lv) of
        [] ->
            NewPs = Ps;
        _ ->
            {ok, NewPs} = pp_welfare:handle(41700, Ps, [])
    end,
    NewPs.

%% 发送给所有在线玩家
send_to_all_online(F) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [F(Id) || #ets_online{id = Id} <- OnlineList].