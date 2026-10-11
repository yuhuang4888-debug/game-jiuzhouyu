%%---------------------------------------------------------------------------
%% @doc:        lib_first_day_benefits
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-5月-30. 15:03
%% @deprecated: 首日福利礼包
%%---------------------------------------------------------------------------
-module(lib_first_day_benefits).

%% API
-export([
    send_reward_status/3,
    get_benefits_rewards/4,
    act_end/2
]).

-include("common.hrl").
-include("def_fun.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("goods.hrl").

%% 发送状态信息
send_reward_status(Player, ActType, SubType) ->
    #player_status{ id = PlayerId, reg_time = RegTime, source = Source } = Player,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(ActType, SubType),
    {source_list, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, []}),
    AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
    %% ?INFO("AtomSource:~p", [AtomSource]),
    case lists:member(AtomSource, SourceList) orelse SourceList == [] of
        true ->
            ActData = get_custom_act_data(Player, ActType, SubType),
            NowSec = utime:unixtime(),
            GradeIds = data_custom_act:get_reward_grade_list(ActType, SubType),
            Fun = fun(GradeId, AccL) ->
                case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
                    #custom_act_reward_cfg{
                        condition = ConditionL, name = Name, desc = Desc,
                        format = Format, reward = Reward
                    } ->
                        case lists:member(GradeId, ActData) of
                            true ->
                                ReceiveTimes = 1,
                                CanGetTime = 0,
                                RewardState = ?ACT_REWARD_HAS_GET;
                            false ->
                                ReceiveTimes = 0,
                                CanGetTime = calc_can_get_time(ConditionL, RegTime),
                                RewardState = ?IF(NowSec >= CanGetTime, ?ACT_REWARD_CAN_GET, ?ACT_REWARD_CAN_NOT_GET)
                        end,
                        NewConditionL = lists:keystore(benefits_time, 1, ConditionL, {benefits_time, CanGetTime}),
                        ConditionStr = util:term_to_string(NewConditionL),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, RewardState, ReceiveTimes, Name, Desc, ConditionStr, RewardStr}|AccL];
                    _ ->
                        AccL
                end
                  end,
            SendList = lists:foldl(Fun, [], GradeIds),
            {ok, BinData} = pt_331:write(33104, [ActType, SubType, SendList]),
            lib_server_send:send_to_uid(PlayerId, BinData);
        _ ->
            skip
    end.

%% 领取奖励
get_benefits_rewards(Player, ActType, SubType, GradeId) ->
    #player_status{ id = PlayerId, reg_time = RegTime, source = Source } = Player,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(ActType, SubType),
    {source_list, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, []}),
    AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
    case lists:member(AtomSource, SourceList) orelse SourceList == [] of
        true ->
            Data = get_custom_act_data(Player, ActType, SubType),
            case check_get_benefits_rewards(Data, ActType, SubType, GradeId, RegTime) of
                {ok, RewardList} ->
                    ActData = #custom_act_data{ id = {ActType, SubType}, type = ActType, subtype = SubType, data = [GradeId|Data]},
                    lib_custom_act:db_save_custom_act_data(PlayerId, ActData),
                    NewPlayer = lib_custom_act:save_act_data_to_player(Player, ActData),
                    Product = #produce{type = first_day_benefits, subtype = SubType, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                    LastPlayer = lib_goods_api:send_reward(NewPlayer, Product),
                    {ok, Bin} = pt_331:write(33105, [?SUCCESS, ActType, SubType, GradeId]),
                    lib_server_send:send_to_uid(PlayerId, Bin);
                {error, Code} ->
                    {ok, Bin} = pt_331:write(33105, [Code, ActType, SubType, GradeId]),
                    lib_server_send:send_to_uid(PlayerId, Bin),
                    LastPlayer = Player
            end,
            {ok, LastPlayer};
        _ ->
            Code = ?ERRCODE(err331_act_closed),
            {ok, Bin} = pt_331:write(33105, [Code, ActType, SubType, GradeId]),
            lib_server_send:send_to_uid(PlayerId, Bin),
            {ok, Player}
    end.

check_get_benefits_rewards(ActData, ActType, SubType, GradeId, RegTime) ->
    case lib_custom_act_util:get_act_reward_cfg_info(ActType, SubType, GradeId) of
        #custom_act_reward_cfg{ condition = ConditionL, reward = RewardList } ->
            case lists:member(GradeId, ActData) of
                true ->  
                    {error, ?ERRCODE(err331_already_get_reward)};
                false ->
                    CanGetTime = calc_can_get_time(ConditionL, RegTime),
                    NowSec = utime:unixtime(),
                    if
                        NowSec < CanGetTime ->
                            {error, ?ERRCODE(err331_stage_not_achieve)};
                        true ->
                            {ok, RewardList}
                    end
             end;       
        _ ->
            {error, ?ERRCODE(err331_no_act_reward_cfg)}
    end.    

%% 计算可领取的时间
calc_can_get_time(ConditionL, RegTime) ->
    {benefits_time, CfgTime} = ulists:keyfind(benefits_time, 1, ConditionL, {benefits_time, 0}),
    RegZeroTime = utime:unixdate(RegTime),
    BaseTime = RegZeroTime + CfgTime,
    ?IF(RegTime < BaseTime, BaseTime, BaseTime + ?ONE_DAY_SECONDS).

%% 活动结束
act_end(Type, SubType) ->
    lib_custom_act:db_delete_custom_act_data(Type, SubType).


get_custom_act_data(Player, ActType, SubType) ->
    case lib_custom_act:act_data(Player, ActType, SubType) of
        #custom_act_data{ data = Data } ->
            Data;
        _ ->
            []
    end.

