%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%%  摇摇乐
%%% @end
%%% Created : 26. 十一月 2018 10:30
%%%-------------------------------------------------------------------
-module(lib_shake).
-author("whao").

%% API
-compile(export_all).

-include("server.hrl").
-include("chat.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("shake.hrl").
-include("custom_act.hrl").


%% 玩家登录
login(RoleId) ->
    AllSubType = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_SHAKE),
    AllShakeData = db_shake_select(RoleId),
    NewAllShakeData = [{SubTypeTmp1, DrawTimes1, ShakeRecStr1, TimeTmp1} || [SubTypeTmp1, DrawTimes1, ShakeRecStr1, TimeTmp1] <- AllShakeData],
    ?PRINT("AllShakeData, NewAllShakeData  :~p  ~p ~n",[AllShakeData, NewAllShakeData]),
    F = fun(SubTypeTmp, StShakeTmp) ->
        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_SHAKE, SubTypeTmp) of
            true ->
                case lists:keyfind(SubTypeTmp, 1, NewAllShakeData) of
                    {SubTypeTmp, DrawTimes, ShakeRecStr, TimeTmp} ->
                        ShakeRecord = util:bitstring_to_term(ShakeRecStr),
                        #status_shake{shake = OldShake} = StShakeTmp,
                        NewShake = maps:put(SubTypeTmp, #shake{draw_times = DrawTimes, shake_record = ShakeRecord, time = TimeTmp}, OldShake),
                        #status_shake{shake = NewShake};
                    _ ->
                        #status_shake{shake = OldShake} = StShakeTmp,
                        NewShake = maps:put(SubTypeTmp, #shake{draw_times = 0, shake_record = [], time = 0}, OldShake),
                        #status_shake{shake = NewShake}
                end;
            false ->
                #status_shake{shake = OldShake} = StShakeTmp,
                NewShake = maps:put(SubTypeTmp, #shake{draw_times = 0, shake_record = [], time = 0}, OldShake),
                #status_shake{shake = NewShake}
        end
        end,
    lists:foldl(F, #status_shake{}, AllSubType).


%% 摇摇乐抽奖
shake(Player, Type, SubType, Times, AutoBuy) ->
    #player_status{sid = Sid, id = _RoleId} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_SHAKE, SubType) of
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33186, [?ERRCODE(err331_act_closed), []]),
            Player;
        true -> % 活动开启
            About = [Type, SubType, Times],
            case get_custom_goods_list(Type, SubType) of
                skip ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33186, [?MISSING_CONFIG, []]),
                    Player;
                {Cost, TenCost, TVShow} ->
                    ShakeCost = % 配置的消耗
                    case Times of
                        1 -> Cost;
                        10 -> TenCost
                    end,
                    ShakeChangeCost = % 换算的消耗
                    case AutoBuy of
                        1 -> % 扣钻石
                            [{_, CostGoodsId, GoodsNum}] = ShakeCost,
                            #quick_buy_price{gold_price = GoldPrice} = data_quick_buy:get_quick_buy_price(CostGoodsId),
                            [{?TYPE_GOLD, 0, GoldPrice * GoodsNum}];
                        0 -> ShakeCost
                    end,
                    case lib_goods_api:cost_object_list_with_check(Player, ShakeChangeCost, shake, About) of
                        {false, ErrorCode, NewPlayer} ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33186, [ErrorCode, []]),
                            NewPlayer;
                        {true, NewPlayer} ->
                            {ok, NewPlayer1, GradeIdList} = do_draw(NewPlayer, Type, SubType, Times, ShakeChangeCost, AutoBuy, TVShow),
                            RewardInfoList = make_proto_shake_goods(Type, SubType, GradeIdList),
                            %%                          通知客户端的次数更新
                            pp_custom_act:handle(33187, NewPlayer1, [Type, SubType]),
                            %%                            ?PRINT("33186 RewardInfoList :~p~n ", [RewardInfoList]),
                            lib_server_send:send_to_sid(Sid, pt_331, 33186, [?SUCCESS, RewardInfoList]),
                            NewPlayer1
                    end
            end
    end.

%%  更新摇摇乐时间和次数
update_times_time(OldTimes, _OldTime) ->
    NowTime = utime:unixtime(),
    NowTimes = OldTimes,
%%        case OldTime =/= 0 andalso utime:is_same_day(OldTime, NowTime) of
%%            true -> OldTimes;
%%            false -> 0
%%        end,
    {NowTimes, NowTime}.

%% 抽奖
do_draw(Player, Type, SubType, DoTimes, TrueCost, AutoBuy, TVShow) ->
    #player_status{id = RoleId, status_shake = StatusShakeTmp} = Player,
    #status_shake{shake = ShakeTmp} = StatusShakeTmp,
    #shake{draw_times = OldTimes, shake_record = ShakeRecord, time = OldTime} =
        maps:get(SubType, ShakeTmp, #shake{draw_times = 0, shake_record = [], time = 0}),
    %%  更新摇摇乐时间和次数
    {NowTimes, NowTime} = update_times_time(OldTimes, OldTime),
    ShakeGoodsList = get_shake_goods_list(Type, SubType), % 奖励配置物品
    %%  获取新得的奖励 ,     玩家奖励的列表
    {NewGetRewards, NewRewardIdList} =
        draw_rewards(NowTimes + 1, ShakeGoodsList, DoTimes, ShakeRecord, []),
    NewDrawTimes = NowTimes + DoTimes,
    NewShake = #shake{draw_times = NewDrawTimes, shake_record = NewRewardIdList, time = NowTime},
    NewShakeTmp = maps:put(SubType, NewShake, ShakeTmp),
    NewStatuShake = StatusShakeTmp#status_shake{shake = NewShakeTmp},
    Player1 = Player#player_status{status_shake = NewStatuShake},
    %%  发放奖励
    SendReward = make_shake_goods(Type, SubType, NewGetRewards),
    Produce = #produce{type = shake, reward = SendReward, show_tips = ?SHOW_TIPS_0},
    NStatus = lib_goods_api:send_reward(Player1, Produce),
    %%  记录全服的日志
    mod_shake:shake_add_log(RoleId, Player#player_status.figure#figure.name, SendReward),

    db_shake_replace(RoleId, SubType, NewDrawTimes, NewRewardIdList, NowTime), % 回存数据库
    %%  传闻
    send_shake_tv(NewGetRewards, TVShow, Player#player_status.figure#figure.name, RoleId, SubType),
    %%  日志
    [GradeId | _] = NewGetRewards,
    lib_log_api:log_shake(RoleId, SubType, DoTimes, AutoBuy, TrueCost, GradeId, SendReward),
    {ok, NStatus, NewGetRewards}.


%% 抽奖
draw_rewards(_Times, _RandList, 0, RewardList, NewGetList) ->
    {NewGetList, RewardList};
draw_rewards(Times, RandList, DoTimes, RewardList, NewGetList) when DoTimes > 0 ->
    GoodsList = get_wheel_goods_list_by_times(RandList, RewardList, Times),
    RewardId = urand:rand_with_weight(GoodsList),
    NewNewGetList = [RewardId | NewGetList],
    NewRewardList = lists:usort([RewardId | RewardList]),
    draw_rewards(Times + 1, RandList, DoTimes - 1, NewRewardList, NewNewGetList).

%% ---------------------------------------------------------------------------
%% @doc 转盘奖励物品列表
-spec get_wheel_goods_list_by_times(RandList, RewardList, Times) -> Return when
    RandList :: [{RewardId, NeedTimes, NullTimes, Weight, WeightTemp}],
    RewardList :: [RewardId], %% 中奖记录
    Times :: integer(),
    Return :: [{Weight, RewardId}],
    RewardId :: integer(),
    NeedTimes :: integer(),
    NullTimes :: integer(),
    Weight :: integer(),
    WeightTemp :: integer().
%% ---------------------------------------------------------------------------
get_wheel_goods_list_by_times(RandList, RewardList, Times) ->
    Fun = fun({RewardId, NeedTimes, NullTimes, Weight, WeightTemp}, List) ->
        RewardInfo = {RewardId, NeedTimes, NullTimes, Weight, WeightTemp},
        NewList = append_reward_list(RewardInfo, RewardList, Times, List),
        NewList
          end,
    NewGoodsList = lists:foldl(Fun, [], RandList),
    NewGoodsList.

%% ---------------------------------------------------------------------------
%% @doc 根据记录和次数追加奖励配置
-spec append_reward_list(RewardInfo, GainList, Times, RewardList) -> Return when
    RewardInfo :: {RewardId, NeedTimes, NullTimes, Weight, WeightTemp},
    GainList :: [RewardId], %% 中奖记录
    Times :: integer(), %% 抽奖次数
    RewardList :: [{Weight, RewardId}],
    Return :: [{Weight, RewardId}],
    RewardId :: integer(),
    NeedTimes :: integer(), %% 入库次数
    NullTimes :: integer(), %% 加权次数
    Weight :: integer(), %% 基础权重
    WeightTemp :: integer().      %% 加权权重
%% ---------------------------------------------------------------------------
% 规则1：中过了，且在第二和第三个参数的范围之间，不算进列表中
% 规则2：没有中，且不满足第二个参数，不算进列表中
% 规则3：没有中，且在第二和第三个参数的范围之间，加入附加权重，算进列表中
% 规则4：不加附加权重，算进列表中，
append_reward_list(RewardInfo, GainList, Times, RewardList) ->
    case RewardInfo of
        {RewardId, NeedTimes, NullTimes, Weight, WeightTemp} ->
            case lists:member(RewardId, GainList) of
                true when Times >= NeedTimes andalso Times =< NullTimes ->
                    RewardList;
                false when Times < NeedTimes ->
                    RewardList;
                false when Times >= NeedTimes andalso Times =< NullTimes ->
                    [{Weight + WeightTemp, RewardId} | RewardList];
                _ ->
                    [{Weight, RewardId} | RewardList]
            end
    end.


%%----------------------------------
%%  获取消耗品  {Cost ,TenCost}
%%-----------------------------------
get_custom_goods_list(Type, SubType) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        [] -> skip;
        #custom_act_cfg{condition = Condition} ->
            {cost, Cost} = lists:keyfind(cost, 1, Condition),
            {ten_cost, TCost} = lists:keyfind(ten_cost, 1, Condition),
            {tv_show, TVShow} = lists:keyfind(tv_show, 1, Condition),
            {Cost, TCost, TVShow}
    end.

%% ---------------------------------------------------------------------------
%% @doc 转盘奖励物品列表
%% ---------------------------------------------------------------------------
get_shake_goods_list(Type, SubType) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun =
        fun(GradeId, GoodsList) ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{
                    condition = Condition, reward = _Reward} ->
                    case lists:keyfind(weigh_yyl, 1, Condition) of
                        {weigh_yyl, Times, NullTimes, Weight, WeightT} ->
                            [{GradeId, Times, NullTimes, Weight, WeightT} | GoodsList];
                        false ->
                            GoodsList
                    end;
                _ ->
                    GoodsList
            end
        end,
    GoodsList = lists:foldl(Fun, [], GradeIds),
    GoodsList.

%% ---------------------------------------------------------------------------
%% @doc 组装奖励物品列表
%% ---------------------------------------------------------------------------
make_shake_goods(Type, SubType, GradeIdList) ->
    Fun =
        fun(GradeId, GoodsList) ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{reward = Reward} ->
                    Reward ++ GoodsList;
                _ ->
                    GoodsList
            end
        end,
    GoodsList = lists:foldl(Fun, [], GradeIdList),
    GoodsList.


%% ---------------------------------------------------------------------------
%% @doc 组装协议奖励物品列表
%% ---------------------------------------------------------------------------
make_proto_shake_goods(Type, SubType, GradeIdList) ->
    Fun =
        fun(GradeId, GoodsList) ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{condition = Cond, reward = Reward} ->
                    case lists:keyfind(target, 1, Cond) of
                        {target, Tar} ->
                            [{GradeId, Tar, Reward} | GoodsList];
                        false ->
                            GoodsList
                    end;
                _ ->
                    GoodsList
            end
        end,
    GoodsList = lists:foldl(Fun, [], GradeIdList),
    GoodsList.

%%  传闻
send_shake_tv([], _TVShow, _, _, _) ->
    ok;
send_shake_tv([GradeId | Least], TVShow, RoleName, RoleId, SubType) ->
    case lists:member(GradeId, TVShow) of
        true ->
            #custom_act_reward_cfg{reward = [{_, GoodsId, _} | _]} = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_SHAKE, SubType, GradeId),
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 23, [RoleName, RoleId, GoodsId, ?CUSTOM_ACT_TYPE_SHAKE, SubType]);
        false ->
            skip
    end,
    send_shake_tv(Least, TVShow, RoleName, RoleId, SubType).


%% --------------------api -------------------------
%%  获取抽奖次数
get_draw_times(Player, SubType) ->
%%    NowTime = utime:unixtime(),
    #player_status{status_shake = StShake} = Player,
    #status_shake{shake = Shake} = StShake,
    #shake{draw_times = DrawTimes, time = _Time} = maps:get(SubType, Shake, #shake{time = 0, draw_times = 0}),
    DrawTimes.
%%    ?PRINT("get_draw_times Time ,DrawTimes  :~p  ~p~n",[Time, DrawTimes]),
%%    case Time =/= 0 andalso utime:is_same_day(NowTime, Time) of
%%        true -> DrawTimes;
%%        false -> 0
%%    end.

%% 获取最后的抽奖时间
get_draw_last_time(Player, SubType) ->
    #player_status{status_shake = StShake} = Player,
    #status_shake{shake = Shake} = StShake,
    #shake{time = Time} = maps:get(SubType, Shake, #shake{time = 0, draw_times = 0}),
    Time.

%% ---------------------------------- db函数 -----------------------------------

db_shake_select(RoleId) ->
    Sql = io_lib:format(?sql_select_shake, [RoleId]),
    db:get_all(Sql).

db_shake_replace(RoleId, SubType, DrawTimes, ShakeRec, Time) ->
    ShakeRecStr = util:term_to_bitstring(ShakeRec),
    Sql = io_lib:format(?sql_replace_shake, [RoleId, SubType, DrawTimes, ShakeRecStr, Time]),
    db:execute(Sql).

db_shake_delete(RoleId, SubType) ->
    Sql = io_lib:format(?sql_clear_shake, [RoleId, SubType]),
    db:execute(Sql).

db_shake_subtype_delete(SubType) ->
    Sql = io_lib:format(?sql_clear_subtype_shake, [SubType]),
    db:execute(Sql).
























