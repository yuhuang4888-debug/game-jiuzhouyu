%%% -------------------------------------------------------------------
%%% @doc        lib_rush_package
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-01-22 16:31               
%%% @deprecated 冲榜特惠礼包
%%% -------------------------------------------------------------------

-module(lib_rush_package).

-include("server.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_module.hrl").

%% API
-export([act_end/1, send_reward_status/2, get_reward/4]).

%% -----------------------------------------------------------------
%% @desc  发送奖励状态
%% @param Player  玩家记录
%% @param ActInfo 活动信息
%% @return
%% -----------------------------------------------------------------
send_reward_status(Player, ActInfo) ->
    #player_status{status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{reward_map = RewardMap} = StatusCustomAct,
    #act_info{key = {Type, SubType}} = ActInfo,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    %% 对于额外奖励，奖励状态要额外计算
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } ->
                ConditionStr = util:term_to_string(Condition),
                RewardStr = util:term_to_string(Reward),
                #reward_status{receive_times = ReceiveTimes} = maps:get({Type, SubType, GradeId}, RewardMap, #reward_status{}),
                [{GradeId, Format, 1, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
            _ -> Acc
        end
        end,
    PackList = lists:foldl(F, [], GradeIds),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).

%% -----------------------------------------------------------------
%% @desc  购买特惠礼包
%% @param PS      玩家记录
%% @param Type    活动主类型
%% @param SubType 活动子类型
%% @param GradeId 礼包档次
%% @return {ok, PS}
%% -----------------------------------------------------------------
get_reward(PS, Type, SubType, GradeId) ->
    #player_status{status_custom_act = StatusCustomAct, figure = Figure, id = RoleId, sid = Sid} = PS,
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    #figure{vip = Vip, lv = RoleLv} = Figure,
    #status_custom_act{reward_map = RewardMap} = StatusCustomAct,
    {vipnumber, VipNumberList} = ulists:keyfind(vipnumber, 1, Condition, {vipnumber, []}),
    {discount, DiscountList} = ulists:keyfind(discount, 1, Condition, {discount, []}),
    {price, Price, PriceType} = ulists:keyfind(price, 1, Condition, {price, 0, 1}),
    {role_lv, CfgRoleLv} = ulists:keyfind(role_lv, 1, Condition, {role_lv, 99999}),
    {max_vip, MaxVip} = ulists:keyfind(max_vip, 1, Condition, {max_vip, 1}),
    #reward_status{receive_times = NowBuyTimes} = RewardStatus = maps:get({Type, SubType, GradeId}, RewardMap, #reward_status{}),
    CanBuyTimesA = ulists:keyfind(Vip, 1, VipNumberList, 0),
    CanBuyTimesB = ulists:keyfind(MaxVip, 1, VipNumberList, 0),
    CanBuyTimes = ?IF(CanBuyTimesA =:= 0, CanBuyTimesB, CanBuyTimesA),
    F = fun({BuyTimes, CfgDiscount}, Discount) -> ?IF(NowBuyTimes >= BuyTimes, CfgDiscount, Discount) end,
    NewDiscount = lists:foldl(F, 10, DiscountList),
    NewPrice = trunc(Price * (NewDiscount * 0.1)),
    Cost = {PriceType, 0, NewPrice},
    if
        RoleLv < CfgRoleLv -> send_error(Sid, ?ERRCODE(err331_lv_not_enougth)), {ok, PS};
        NowBuyTimes >= CanBuyTimes -> send_error(Sid, ?ERRCODE(err332_not_buy_count)), {ok, PS};
        true ->
            case lib_goods_api:cost_object_list_with_check(PS, [Cost], rush_special_package, ?CUSTOM_ACT_TYPE_RUSH_PACKAGE) of
                {true, PlayerA} ->
                    NewTimes = NowBuyTimes + 1,
                    NewRewardStatus = RewardStatus#reward_status{receive_times = NewTimes, utime = utime:unixtime(), login_times = 0},
                    db_save_reward_status(NewRewardStatus, RoleId, Type, SubType, GradeId, NowBuyTimes),
                    NewRewardMap = RewardMap#{{Type, SubType, GradeId} => NewRewardStatus},
                    PlayerB = PlayerA#player_status{status_custom_act = StatusCustomAct#status_custom_act{reward_map = NewRewardMap}},
                    NewPlayer = send_reward(Type, SubType, PlayerB, NewTimes, DiscountList),
                    lib_server_send:send_to_sid(Sid, pt_331, 33105, [?SUCCESS, Type, SubType, GradeId]),
                    {ok, NewPlayer};
                {false, ErrorCode, _PS} -> send_error(Sid, ErrorCode), {ok, PS}
            end
    end.

%% -----------------------------------------------------------------
%% @desc 发送礼包奖励
%% @param Type         活动主类型
%% @param SubType      活动子类型
%% @param PS           玩家记录
%% @param NewTimes     当前购买数量
%% @param DiscountList 打折配置列表
%% @return
%% -----------------------------------------------------------------
send_reward(Type, SubType, PS, NewTimes, DiscountList) ->
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, 1),
    #custom_act_reward_cfg{reward = Rewards, grade = Grade, condition = Condition} = RewardCfg,
    %% 发奖励
    Remark = lists:concat(["SubType:", SubType, "GradeId:", Grade]),
    Produce = #produce{type = rush_special_package, subtype = Type, remark = Remark, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    lib_log_api:log_custom_act_reward(PS#player_status.id, Type, SubType, Grade, Rewards),
    Name = lib_player:get_wrap_role_name(PS),
    {tv_id, TvId} = ulists:keyfind(tv_id, 1, Condition, 1),
    %% 发送节点传闻
    ulists:keyfind(NewTimes, 1, DiscountList, false) =/= false andalso
        lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, TvId, [Name, PS#player_status.id, NewTimes, Type, SubType]),
    lib_goods_api:send_reward(PS, Produce).

%% -----------------------------------------------------------------
%% @desc 更新奖励状态
%% @param RewardStatus 奖励状态记录
%% @param RoleId       角色Id
%% @param Type         活动主类型
%% @param SubType      活动子类型
%% @param GradeId      礼包档次
%% @param NowBuyTimes  现在的购买次数
%% @return
%% -----------------------------------------------------------------
db_save_reward_status(RewardStatus, RoleId, Type, SubType, GradeId, NowBuyTimes) ->
    #reward_status{receive_times = NewReceiveTimes, utime = NowTime, login_times = 0} = RewardStatus,
    SQL = ?IF(NowBuyTimes =:= 0,
        io_lib:format(?insert_custom_act_reward_receive, [RoleId, Type, SubType, GradeId, NewReceiveTimes, NowTime]),
        io_lib:format(?update_custom_act_reward_receive, [NewReceiveTimes, NowTime, RoleId, Type, SubType, GradeId])),
    db:execute(SQL).

%% -----------------------------------------------------------------
%% @desc 发送错误码
%% @return
%% -----------------------------------------------------------------
send_error(Sid, ErrorCode) ->
    {ok, Bin} = pt_331:write(33100, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, Bin).

%% -----------------------------------------------------------------
%% @desc 活动结束处理
%% @param
%% @return
%% -----------------------------------------------------------------
act_end(#act_info{key = {Type, SubType}}) ->
    Sql = io_lib:format(?DELETE_CUSTOM_ACT_REWARD_RECEIVE, [Type, SubType]),
    db:execute(Sql).