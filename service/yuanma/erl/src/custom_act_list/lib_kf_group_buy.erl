%%%--------------------------------------
%%% @Module  : 
%%% @Author  : 
%%% @Created : 
%%% @Description:  跨服团购
%%%--------------------------------------
-module(lib_kf_group_buy).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").

check_act_open_extra(ActInfo, Stime) ->
    #act_info{key = {Type, SubType}, stime = StartTime} = ActInfo,
    check_in_buy_day(Type, SubType, StartTime, Stime).
    

send_gpbuy_info(PS, Type, SubType) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_group_buy, send_gpbuy_info, [[Type, SubType, RoleId, Sid, Node]]).

send_gpbuy_records(PS, Type, SubType) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_group_buy, send_gpbuy_records, [[Type, SubType, RoleId, Sid, Node]]).

purchase_gp_goods_first(PS, Type, SubType, GpGoodsId) ->
    #player_status{id = RoleId, sid = Sid, server_id = ServerId, server_num = ServerNum, figure = #figure{name = Name}} = PS,
    Node = mod_disperse:get_clusters_node(),
    case check_first_cost(PS, Type, SubType, GpGoodsId) of 
        {ok, CostList} -> 
            case get_gp_goods_max_buy_count(Type, SubType, GpGoodsId) of 
                {ok, MaxBuyCount} ->
                    Args = [Type, SubType, GpGoodsId, MaxBuyCount, RoleId, Name, ServerId, ServerNum, Sid, Node],
                    case catch mod_clusters_node:apply_call(mod_kf_group_buy, purchase_gp_goods_first, [Args]) of 
                        {ok, NewFirstCount, NewBuyNum} ->
                            case lib_goods_api:cost_object_list(PS, CostList, kf_group_buy, lists:concat([1, "_", GpGoodsId])) of 
                                {true, NewPS} ->
                                    %% 传闻
                                    #custom_act_reward_cfg{reward = [{_, GoodsTypeId, Num}|_]} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GpGoodsId),
                                    TvArgs = [Name, GoodsTypeId, Num],
                                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM_OTHER, 9, TvArgs),
                                    lib_log_api:log_custom_act_cost(RoleId, Type, SubType, CostList, [first_buy, GpGoodsId]),
                                    ?PRINT("purchase_gp_goods_first#succ:~p~n", [{NewFirstCount, NewBuyNum}]),
                                    {ok, NewPS, NewFirstCount, NewBuyNum, []};
                                {false, Res, _} ->
                                    ?ERR("purchase_gp_goods_first#2 Res: ~p~n", [{Res, CostList}]),
                                    {false, Res}
                            end;
                        {false, Res} -> {false, Res};
                        _Err ->
                            ?ERR("purchase_gp_goods_first#1 _Err:~p~n", [_Err]),
                            {false, ?ERRCODE(system_busy)}
                    end;
                {false, Res} ->
                    {false, Res}
            end;
        Return -> Return
    end.

purchase_gp_goods_tail(PS, ActInfo, GpGoodsId) ->
    #player_status{
        id = RoleId, gold = Gold, bgold = BGold
    } = PS,
    #act_info{key = {Type, SubType}} = ActInfo,
    MoneyArgs = [Gold, BGold],
    Args = [Type, SubType, GpGoodsId, RoleId, MoneyArgs],
    case catch mod_clusters_node:apply_call(mod_kf_group_buy, purchase_gp_goods_tail, [Args]) of 
        {ok, NewTailCount, BuyNum, CostList} ->
            case lib_goods_api:cost_object_list_with_check(PS, CostList, kf_group_buy, lists:concat([2, "_", GpGoodsId])) of 
                {true, PS1} ->
                    lib_log_api:log_custom_act_cost(RoleId, Type, SubType, CostList, [tail_buy, GpGoodsId]),
                    RewardList = get_group_buy_reward(PS, ActInfo, GpGoodsId),
                    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GpGoodsId, RewardList),
                    Produce = #produce{type = kf_group_buy, reward = RewardList, show_tips = ?SHOW_TIPS_3},
                    NewPS = lib_goods_api:send_reward(PS1, Produce),
                    ?PRINT("purchase_gp_goods_tail#succ:~p~n", [{NewTailCount, BuyNum, CostList}]),
                    {ok, NewPS, NewTailCount, BuyNum, RewardList};
                {false, Res, _} ->
                    ?ERR("purchase_gp_goods_tail#2 Res: ~p~n", [{Res, CostList}]),
                    {false, Res}
            end;
        {false, Res} -> {false, Res};
        _Err ->
            ?ERR("purchase_gp_goods_tail#1 _Err:~p~n", [_Err]),
            {false, ?ERRCODE(system_busy)}
    end.

compensate_first_buy(Type, SubType, ReturnList) ->
    spawn(fun() -> compensate_first_buy_delay(Type, SubType, ReturnList) end),
    ok.

compensate_first_buy_delay(Type, SubType, ReturnList) ->
    NowTime = utime:unixtime(),
    Title = utext:get(3320007),
    F = fun({RoleId, GradeList}, {Acc, List}) ->
        F2 = fun({GradeId, LeftCount}, {Acc2, List2}) ->
            Acc2 rem 10 == 0 andalso timer:sleep(500),
            #custom_act_reward_cfg{reward = [{_, GoodsTypeId, Num}|_]} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            #ets_goods_type{ goods_name = GoodsName} = data_goods_type:get(GoodsTypeId),
            Content = utext:get(3320008, [LeftCount, util:make_sure_binary(GoodsName), Num]),
            case get_first_buy_cost(Type, SubType, GradeId) of 
                {ok, FirstCost} -> RewardList = [{?TYPE_BGOLD, 0, FirstCost*LeftCount}];
                _ -> RewardList = [{?TYPE_BGOLD, 0, 10*LeftCount}]
            end,
            lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
            {Acc2+1, [[RoleId, Type, SubType, GradeId, util:term_to_bitstring(RewardList), NowTime]|List2]}
        end,
        lists:foldl(F2, {Acc, List}, GradeList)
    end,
    {_, LogList} = lists:foldl(F, {1, []}, ReturnList),
    lib_log_api:log_kf_group_buy_compensate(LogList).

check_in_buy_day(Type, SubType, StartTime, NowTime) ->
    BuyDay = get_act_buy_day(Type, SubType),
    case NowTime < (StartTime + BuyDay*?ONE_DAY_SECONDS) of 
        true -> true;
        _ -> false
    end.

get_act_buy_day(Type, SubType) ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, buy_day) of 
        {buy_day, BuyDay} -> BuyDay;
        _ -> 1
    end.

get_gp_goods_max_buy_count(Type, SubType, GpGoodsId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GpGoodsId) of 
        #custom_act_reward_cfg{condition = Condition} ->
            case lists:keyfind(buy_count, 1, Condition) of 
                {_, BuyCount} -> {ok, BuyCount};
                _ -> {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

get_group_buy_reward(PS, ActInfo, GpGoodsId) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GpGoodsId), 
    lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg).

get_first_buy_cost(Type, SubType, GpGoodsId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GpGoodsId) of 
        #custom_act_reward_cfg{condition = Condition} ->
            case lists:keyfind(cost, 1, Condition) of 
                {_, _, _, FirstCost} -> 
                    {ok, FirstCost};
                _ -> {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

get_tail_buy_cost(Type, SubType, GpGoodsId, BuyNum) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GpGoodsId) of 
        #custom_act_reward_cfg{condition = Condition} ->
            case lists:keyfind(discount, 1, Condition) of 
                {_, Discount} -> 
                    case lists:reverse(lists:keysort(1, [{NeedNum, Money} ||{NeedNum, Money} <- Discount, BuyNum >= NeedNum])) of 
                        [{_, TailCost}|_] ->
                            {_, _, _, FirstCost} = lists:keyfind(cost, 1, Condition),
                            CostList = [{?TYPE_GOLD, 0, TailCost - FirstCost}],
                            {ok, CostList};
                        _ ->
                            case lists:keyfind(cost, 1, Condition) of 
                                {_, _, InitCost, FirstCost} ->
                                    CostList = [{?TYPE_GOLD, 0, InitCost - FirstCost}],
                                    {ok, CostList};
                                _ ->
                                    {false, ?MISSING_CONFIG}
                            end
                    end;
                _ -> 
                    {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

check_first_cost(PS, Type, SubType, GpGoodsId) ->
    case get_first_buy_cost(Type, SubType, GpGoodsId) of 
        {ok, FirstCost} -> 
            CostList = [{?TYPE_GOLD, 0, FirstCost}],
            case lib_goods_api:check_object_list_with_auto_buy(PS, CostList) of 
                true -> 
                    {ok, CostList};
                Return -> Return
            end;
        _ -> {false, ?MISSING_CONFIG}
    end.

check_tail_cost(MoneyArgs, Type, SubType, GpGoodsId, BuyNum) ->
    case get_tail_buy_cost(Type, SubType, GpGoodsId, BuyNum) of 
        {ok, CostList} ->
            [Gold, BGold] = MoneyArgs,
            {GoldNeed, BGoldNeed} = split_cost(CostList),
            if
                Gold < GoldNeed -> {false, ?GOLD_NOT_ENOUGH};
                BGold < BGoldNeed andalso (BGold+Gold-GoldNeed < BGoldNeed) -> {false, ?BGOLD_NOT_ENOUGH};
                true -> {ok, CostList}
            end;
        Res -> Res
    end.
        
split_cost(CostList) ->
    F = fun({GType, _, Num}, {GoldNeed, BGoldNeed}) ->
        case GType of 
            ?TYPE_GOLD -> {GoldNeed+Num, BGoldNeed};
            ?TYPE_BGOLD -> {GoldNeed, BGoldNeed+Num}
        end
    end,
    lists:foldl(F, {0, 0}, CostList).

make(gp_goods, [GpGoodsId, FirstBuy, FirstBuyTime, TailBuy, TailBuyTime]) ->
    #gp_goods{
        gp_goods_id = GpGoodsId, first_buy = FirstBuy, first_buy_time = FirstBuyTime,
        tail_buy = TailBuy, tail_buy_time = TailBuyTime
    };
make(gpbuy_role, [RoleId, Type, SubType, Name, ServerId, ServerNum, BuyList, EndTime]) ->
    #gpbuy_role{
        key = {RoleId, Type, SubType}, 
        role_id = RoleId,
        role_name = Name,
        server_id = ServerId,
        server_num = ServerNum,
        buy_list = BuyList,
        end_time = EndTime
    }.

db_select_group_buy_role() ->
    Sql = io_lib:format(<<"select role_id, type, subtype, name, server_id, server_num, end_time from gpbuy_role ">>, []),
    db:get_all(Sql).

db_replace_group_buy_role(GpBuyRole) ->
    #gpbuy_role{
        key = {RoleId, Type, SubType}
        , role_name = Name
        , server_id = ServerId
        , server_num = ServerNum 
        , end_time = EndTime 
    } = GpBuyRole,
    Sql = io_lib:format(<<"replace into gpbuy_role set role_id=~p, type=~p, subtype=~p, name='~s', server_id=~p, server_num=~p, end_time=~p">>, 
        [RoleId, Type, SubType, Name, ServerId, ServerNum, EndTime]),
    db:execute(Sql).

db_clear_group_buy_role(Type, SubType) ->
    db:execute(io_lib:format(<<"delete from gpbuy_role where type=~p and subtype=~p">>, [Type, SubType])).

db_select_group_buy_goods() ->
    Sql = io_lib:format(<<"select role_id, type, subtype, gp_goods_id, first_buy, first_buy_time, tail_buy, tail_buy_time from gpbuy_goods ">>, []),
    db:get_all(Sql).

db_replace_group_buy_goods(RoleId, Type, SubType, GpGoods) ->
    #gp_goods{
        gp_goods_id = GpGoodsId, first_buy = FirstBuy, first_buy_time = FirstBuyTime,
        tail_buy = TailBuy, tail_buy_time = TailBuyTime
    } = GpGoods,
    Sql = io_lib:format(<<"replace into gpbuy_goods set role_id=~p, type=~p, subtype=~p, gp_goods_id=~p, first_buy='~s', first_buy_time=~p, tail_buy='~s', tail_buy_time=~p ">>, 
        [RoleId, Type, SubType, GpGoodsId, util:term_to_bitstring(FirstBuy), FirstBuyTime, util:term_to_bitstring(TailBuy), TailBuyTime]),
    db:execute(Sql).

db_clear_group_buy_goods(Type, SubType) ->
    db:execute(io_lib:format(<<"delete from gpbuy_goods where type=~p and subtype=~p">>, [Type, SubType])).
%% 喊话的前期检测
check_group_buy_shout(Type, SubType, GradeId) ->
    NowSec = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = Wlv, etime = EndTime} when NowSec < EndTime ->
            %% 判断世界等级正确性
            IsInWlv = ?IF(lib_custom_act_check:check_reward_in_wlv(Type, SubType, Wlv, GradeId) == true, false, true),
            %% 判断是否处于预购、可以喊话的时间段
            #custom_act_cfg{start_time = StartTime, condition = ConditionL} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            IsCanShout = ?IF(lib_kf_group_buy:check_in_buy_day(Type, SubType, StartTime, NowSec) == true, false, true),
            if
                IsInWlv ->
                    {error, ?ERRCODE(err137_cfg_error)};
                IsCanShout ->
                    {error, ?ERRCODE(err332_not_in_first_time)};
                true ->
                    CfgCdTime = proplists:get_value(shout, ConditionL, 0),
                    case CfgCdTime > 0 of
                        true ->
                            {ok, CfgCdTime};
                        _ ->
                            {error, ?ERRCODE(err137_cfg_error)}
                    end
            end;
        _ ->
            {error, ?ERRCODE(err331_act_closed)}
    end.