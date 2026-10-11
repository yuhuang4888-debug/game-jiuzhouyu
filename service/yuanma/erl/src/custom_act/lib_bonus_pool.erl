%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_pool
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-09-17
%% @Description:    摇钱树
%%-----------------------------------------------------------------------------
-module(lib_bonus_pool).

-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

% -compile(export_all).
-export([
        login/1,
        init_data_lv_up/1,
        midnight_update_helper/3,
        midnight_update/3,
        send_reward_status/2,
        act_open/2,
        act_end/2,
        send_act_data/3,
        get_bonus/6,
        reset/4,
        act_open_helper/3,
        act_end_helper/3
    ]).

-record(bonus_pool,{
        total_times = 0,    %% 总抽奖次数
        rare_pool = [],     %% {Weight, Grade}
        act_data = [],      %% #rare_reward
        pool = [],          %% {Weight, Grade}
        reward_args = undefined %% #reward_param
    }).

-record(rare_reward,{
        grade = 0,          %% 档次
        draw_times = 0,     %% 抽奖次数
        luckey_value = 0,   %% 幸运值
        max_luckey_value = 0,%% 最大幸运值
        free_times = 0,     %% 剩余免费次数
        state = 0,          %% 状态
        stime = 0           %% 时间
    }).

% CREATE TABLE if not exists`bonus_pool` (
%   `role_id` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家id',
%   `type` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动类型',
%   `subtype` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '活动子类型',
%   `grade` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '档次',
%   `draw_times` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '抽奖次数',
%   `luckey_value` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '幸运值',
%   `free_times` SMALLINT(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '免费次数',
%   `state` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0未被抽中1抽中',
%   `stime` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '时间',
%   PRIMARY KEY (`role_id`, `type`, `subtype`, `grade`))
% ENGINE = InnoDB
% DEFAULT CHARACTER SET = utf8
% COMMENT = '许愿池';

-define(HAS_DRAW, 1).       %% 被抽中
-define(NOT_DRAW, 0).       %% 未被抽中

-define(SQL_SELECT, 
    <<"select `grade`, `draw_times`, `luckey_value`, `free_times`, `state`, `stime` from bonus_pool where `role_id` = ~p and `type` = ~p and `subtype` = ~p">>).

-define(SQL_REPLACE, <<"replace into `bonus_pool` (`role_id`, `type`, `subtype`, `grade`, `draw_times`, 
    `luckey_value`, `free_times`, `state`, `stime`) values (~p,~p,~p,~p,~p,~p,~p,~p,~p)">>).

-define(SQL_DELETE, <<"DELETE FROM `bonus_pool` WHERE `type` = ~p and `subtype` = ~p">>).

db_select(RoleId, Type, SubType) ->
    db:get_all(io_lib:format(?SQL_SELECT, [RoleId, Type, SubType])).

db_replace(RoleId, Type, SubType, Grade, DrawTimes, LuckeyValue, FreeTimes, State, Time) ->
    db:execute(io_lib:format(?SQL_REPLACE, [RoleId, Type, SubType, Grade, DrawTimes, LuckeyValue, FreeTimes, State, Time])).

db_delete(Type, SubType) ->
    db:execute(io_lib:format(?SQL_DELETE,[Type, SubType])).

get_condition_value(Key, Condition) ->
    case lists:keyfind(Key, 1, Condition) of
        {Key, Value} -> Value;
        _ -> 0
    end.

calc_default_pool(Type, SubType, ActCondition, NowTime) ->
    GradeList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun = fun(Grade, {Acc, Acc1, AccData}) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade) of
            #custom_act_reward_cfg{condition = Condition} -> 
                case lists:keyfind(add_weight, 1, Condition) of
                    {add_weight, AddWeightList} when is_list(AddWeightList) ->skip;
                    _ -> AddWeightList = []
                end,
                case get_condition_value(luckey_value, Condition) of
                    MaxLuckeyValue when is_integer(MaxLuckeyValue) andalso MaxLuckeyValue > 0 ->
                        Weight = get_condition_value(weight, Condition),
                        NewFreetimes = get_condition_value(free_times, ActCondition),
                        RareReward = #rare_reward{grade = Grade, draw_times = 0, luckey_value = 0, 
                                free_times = NewFreetimes, max_luckey_value = MaxLuckeyValue, state = ?NOT_DRAW, stime = NowTime},
                        {Acc, [{Weight, Grade, AddWeightList}|Acc1], [RareReward|AccData]};
                    _ ->
                        Weight = get_condition_value(weight, Condition),
                        {[{Weight, Grade, AddWeightList}|Acc], Acc1, AccData}
                end;
            _ -> 
                {Acc, Acc1, AccData}
        end
    end,
    lists:foldl(Fun, {[], [], []}, GradeList).

calc_pool([], _, NewAcc) -> NewAcc;
calc_pool([#rare_reward{grade = Grade} = H|DefaultActData], ActData, Acc) ->
    case lists:keyfind(Grade, #rare_reward.grade, ActData) of
        #rare_reward{} = H1 -> NewAcc = [H1|Acc];
        _ -> NewAcc = [H|Acc]
    end,
    calc_pool(DefaultActData, ActData, NewAcc).

init_data_lv_up(Player) ->
    Type = ?CUSTOM_ACT_TYPE_BONUS_POOL,
    #player_status{id = RoleId, bonus_pool = OldMap, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, AccMap) ->
        #custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
        LimitRoleLv = get_condition_value(role_lv, ActCondition),
        if 
            LimitRoleLv == RoleLv ->
                BonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
                if 
                    BonusPool =/= [] ->
                        maps:put({Type, SubType}, BonusPool, AccMap);
                    true ->
                        AccMap
                end;
            true ->
                AccMap
        end
    end,
    NewMap = lists:foldl(Fun, OldMap, SubTypeList),
    Player#player_status{bonus_pool = NewMap}.

login(PS) ->
    Type = ?CUSTOM_ACT_TYPE_BONUS_POOL,
    #player_status{id = RoleId, bonus_pool = OldMap, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = PS,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, AccMap) ->
        BonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
        if 
            BonusPool =/= [] ->
                maps:put({Type, SubType}, BonusPool, AccMap);
            true ->
                AccMap
        end
    end,
    NewMap = lists:foldl(Fun, OldMap, SubTypeList),
    PS#player_status{bonus_pool = NewMap}.

init_data(RoleId, Type, SubType, RoleLv, Sex, Career) ->
    #custom_act_cfg{clear_type = ClearType, condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        false -> Wlv = util:get_world_lv();
        #act_info{wlv = Wlv} -> skip
    end,
    % ?PRINT("{Type, SubType}:~p,wlv:~p~nActCondition:~p~n",[{Type, SubType}, Wlv,ActCondition]),
    LimitRoleLv = get_condition_value(role_lv, ActCondition),
    case lists:keyfind(wlv, 1, ActCondition) of
        {_, [{Min, Max}|_]} when RoleLv >= LimitRoleLv andalso Wlv >= Min andalso Wlv =< Max -> 
            NowTime = utime:unixtime(),
            List = db_select(RoleId, Type, SubType),
            {NormalPool, RarePool, DefaultActData} = calc_default_pool(Type, SubType, ActCondition, NowTime),
            F1 = fun([Grade, ODraw_times, OLuckey_value, OFree_times, OState, OStime], {AccNum, AccData}) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade) of
                    #custom_act_reward_cfg{condition = Condition} -> 
                        MaxLuckeyValue = get_condition_value(luckey_value, Condition),
                        {Draw_times, Luckey_value, Free_times, State, Stime} = 
                            init_data_helper(RoleId, Type, SubType, Grade, ODraw_times, OLuckey_value, OFree_times, OState, OStime, ClearType, ActCondition, NowTime),
                        RareReward = #rare_reward{grade = Grade, draw_times = Draw_times, luckey_value = Luckey_value, 
                            free_times = Free_times, max_luckey_value = MaxLuckeyValue, state = State, stime = Stime},
                        {AccNum+Draw_times, [RareReward|AccData]};
                    _ -> 
                        {AccNum, AccData}
                end
            end,
            case db:get_row(io_lib:format(?select_player_act_args, [RoleId, Type, SubType])) of
                [ORoleLv, OWlv, OCareer, OSex] ->
                    RewardParam = #reward_param{player_lv = ORoleLv,wlv = OWlv,sex = OSex,career = OCareer};
                _ ->
                    db:execute(io_lib:format(?insert_player_act_args, [RoleId, Type, SubType, RoleLv, Wlv, Career, Sex])),
                    RewardParam = #reward_param{player_lv = RoleLv,wlv = Wlv,sex = Sex,career = Career}
            end,
            {TotalNum, ActData} = lists:foldl(F1, {0, []}, List),
            NewActData = calc_pool(DefaultActData, ActData, []),
            #bonus_pool{total_times = TotalNum, rare_pool = RarePool, act_data = NewActData, pool = NormalPool, reward_args = RewardParam};
        _ ->
            []
    end.
    

init_data_helper(RoleId, Type, SubType, Grade, Draw_times, Luckey_value, Free_times, State, Stime, ClearType, ActCondition, NowTime) ->
    if
        ClearType == ?CUSTOM_ACT_CLEAR_ZERO ->
            case utime:is_same_day(NowTime, Stime) of
                false ->
                    NewFreetimes = get_condition_value(free_times, ActCondition),
                    db_replace(RoleId, Type, SubType, Grade, 0, Luckey_value, NewFreetimes, State, NowTime),
                    {0, Luckey_value, NewFreetimes, State, NowTime};
                _ ->
                    {Draw_times, Luckey_value, Free_times, State, Stime}
            end;
        ClearType == ?CUSTOM_ACT_CLEAR_FOUR ->
            case utime_logic:is_logic_same_day(NowTime, Stime) of
                false ->
                    NewFreetimes = get_condition_value(free_times, ActCondition),
                    db_replace(RoleId, Type, SubType, Grade, 0, Luckey_value, NewFreetimes, State, NowTime),
                    {0, Luckey_value, NewFreetimes, State, NowTime};
                _ ->
                    {Draw_times, Luckey_value, Free_times, State, Stime}
            end;
        true ->
            {Draw_times, Luckey_value, Free_times, State, Stime}
    end.

%% 抽奖
get_bonus(Player, Type, SubType, Times, AutoBuy, RareGrade) when 
        Type =:= ?CUSTOM_ACT_TYPE_BONUS_POOL ->
    % #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    #player_status{id = RoleId, bonus_pool = Map, sid = Sid, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    if
        Times == 1 orelse Times == 10 ->
            case maps:get({Type, SubType}, Map, []) of
                #bonus_pool{rare_pool = RarePool, act_data = ActData} = BonusPool -> 
                    get_bonus_helper(Player, BonusPool, Type, SubType, Times, RareGrade, ActData, RarePool, AutoBuy);
                _ ->
                    BonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
                    case BonusPool of
                        #bonus_pool{rare_pool = RarePool, act_data = ActData} ->
                            get_bonus_helper(Player, BonusPool, Type, SubType, Times, RareGrade, ActData, RarePool, AutoBuy);
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33142, [Type, SubType, RareGrade, ?ERRCODE(err331_lv_not_enougth), [], 0,0,0])
                    end
            end;
        true ->
            lib_server_send:send_to_sid(Sid, pt_331, 33142, [Type, SubType, RareGrade, ?ERRCODE(data_error), [], 0,0,0])
    end;
get_bonus(Player, _, _, _, _, _) -> {ok, Player}.

get_bonus_helper(Player, BonusPool, Type, SubType, Times, RareGrade, ActData, RarePool, AutoBuy) ->
    case check_grade(RareGrade, ActData, RarePool) of
        {true, GradeReward} ->
            case get_cost(Type, SubType, Times, ActData, RareGrade) of
                {true, CostList} -> 
                    Res = if
                        CostList == [] ->
                            true;
                        AutoBuy == 1 ->
                            lib_goods_api:check_object_list_with_auto_buy(Player, CostList);
                        true ->
                            lib_goods_api:check_object_list(Player, CostList)
                    end,
                    case Res of
                        true ->
                            do_get_bonus(Player, BonusPool, Type, SubType, RareGrade, GradeReward, Times, AutoBuy);    
                        {false, Error} ->
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33142, [Type, SubType, RareGrade, Error, [], 0,0,0])
                    end;
                {false, ErrorCode} ->
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33142, [Type, SubType, RareGrade, ErrorCode, [], 0,0,0])
            end;
        {false, ErrorCode} ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33142, [Type, SubType, RareGrade, ErrorCode, [], 0,0,0])
    end.

do_get_bonus(Player, BonusPool, Type, SubType, RareGrade, GradeReward, Times, AutoBuy) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}, bonus_pool = Map} = Player,
    WrapRoleName = lib_player:get_wrap_role_name(Player),
    {NewBonusPool, GradeIds, CostTimes, NewGradeReward} = do_get_bonus_help(RoleId, BonusPool, Type, SubType, RareGrade, GradeReward, Times, [], 0),
    CostList = get_cost(Type, SubType, CostTimes),
    About = [Type, SubType, CostTimes],
    ConsumeType = get_consume_type(Type),
    Res = if
        Times == 1 andalso CostList == [] ->
            {true, Player, []};
        AutoBuy == 1 ->
            lib_goods_api:cost_objects_with_auto_buy(Player, CostList, ConsumeType, About);
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
                {true, TmpNewPlayer} ->
                    {true, TmpNewPlayer, CostList};
                Other ->
                    Other
            end
    end,
    case Res of
        {true, NewPlayer, Cost} ->
            {Rewards, ClientData} = handle_reward(GradeIds, Type, SubType, [], [], WrapRoleName, RoleId, BonusPool#bonus_pool.reward_args), %%传闻处理
            % ?PRINT("================ Rewards:~p,~p~n",[Rewards,BonusPool#bonus_pool.reward_args]),
            ProduceType = get_produce_type(Type),
            Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards, show_tips = ?SHOW_TIPS_0},
            NewPS = lib_goods_api:send_reward(NewPlayer, Produce),
            #rare_reward{draw_times = _DrawTimes, luckey_value = Luckey_value, free_times = Free_times, state = State, max_luckey_value = _MaxLuckeyValue, stime = Stime} = NewGradeReward,
            db_replace(RoleId, Type, SubType, RareGrade, _DrawTimes, Luckey_value, Free_times, State, Stime),
            lib_log_api:log_custom_act_reward(NewPlayer, Type, SubType, 0, Rewards),
            lib_log_api:log_bonus_pool(RoleId, RoleName, Type, SubType, CostTimes, Cost, Rewards),
            NewMap = maps:put({Type, SubType}, NewBonusPool, Map),
            lib_server_send:send_to_uid(RoleId, pt_331, 33142, [Type, SubType, RareGrade, 1, ClientData, Luckey_value, Free_times, State]),
            {ok, NewPS#player_status{bonus_pool = NewMap}};
        {false, Error, NewPlayer} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33142, [Type, SubType, RareGrade, Error, [], 0, 0, 0]),
            {ok, NewPlayer}
    end.


do_get_bonus_help(_, BonusPool, _, _, _, GradeReward, 0, GradeIds, CostTimes) -> {BonusPool,GradeIds,CostTimes,GradeReward};
do_get_bonus_help(RoleId, BonusPool, Type, SubType, RareGrade, GradeReward, Times, GradeIds, CostTimes) ->
    #bonus_pool{total_times = TotalNum, rare_pool = RarePool, act_data = ActData, pool = NormalPool} = BonusPool,
    #rare_reward{draw_times = _DrawTimes, luckey_value = Luckey_value, 
        free_times = Free_times, state = _State, stime = _Stime, max_luckey_value = MaxLuckeyValue} = GradeReward,

    NowTime = utime:unixtime(),
    
    {RealPool, NewLuckeyValue} = do_draw_core(NormalPool, RarePool, RareGrade, Luckey_value+1, MaxLuckeyValue),
    if
        is_list(RealPool) ->
            GradeId = urand:rand_with_weight(RealPool);  %%奖池里面的大奖id一定是有配置的
        true ->
            GradeId = RealPool
    end,
    #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    if
        Times == 1 andalso Free_times > 0 ->
            NewCostTimes = CostTimes,
            NewFreetimes = Free_times - 1;
        true ->
            NewCostTimes = CostTimes+1,
            NewFreetimes = Free_times
    end,
    case get_condition_value(luckey_value, Conditions) of
        0 -> 
            NewGradeReward = GradeReward#rare_reward{draw_times = _DrawTimes+1, luckey_value = NewLuckeyValue, free_times = NewFreetimes, stime = NowTime},
            NewActData = lists:keystore(RareGrade, #rare_reward.grade, ActData, NewGradeReward),
            do_get_bonus_help(RoleId, BonusPool#bonus_pool{total_times = TotalNum+1, act_data = NewActData}, Type, SubType, RareGrade, NewGradeReward, Times-1, [GradeId|GradeIds], NewCostTimes);
        _ -> 
            if
                NewLuckeyValue > MaxLuckeyValue ->
                    NLuckeyValue = 0;
                true ->
                    NLuckeyValue = NewLuckeyValue
            end,
            NewGradeReward = GradeReward#rare_reward{state = ?HAS_DRAW, draw_times = _DrawTimes+1, luckey_value = NLuckeyValue, free_times = NewFreetimes, stime = NowTime},
            NewActData = lists:keystore(RareGrade, #rare_reward.grade, ActData, NewGradeReward),
            {BonusPool#bonus_pool{total_times = TotalNum+1, act_data = NewActData}, [GradeId|GradeIds], NewCostTimes, NewGradeReward}
    end.

%% 奖池，{StartTimes, EndTimes, Weight, SpecialWeight} 在StartTimes 与 EndTimes 之间权重增加（Weight+SpecialWeight）
%% 若抽奖次数没达到StartTimes,该大奖不会入奖池， 抽奖次数大于EndTimes使用Weight来抽奖
do_draw_core(NormalPool, RarePool, RareGrade, LuckeyValue, MaxLuckeyValue) ->
    Elemt = lists:keyfind(RareGrade, 2, RarePool),
    if
        LuckeyValue > MaxLuckeyValue andalso RarePool =/= [] andalso MaxLuckeyValue > 0 ->
            {RareGrade, LuckeyValue};
        true ->
            Fun = fun({TemWeight, Grade, TemAddList}, Acc) ->
                F1 = fun({TMin, TMax, _}) ->
                    LuckeyValue >= TMin andalso LuckeyValue =< TMax
                end,
                case ulists:find(F1, TemAddList) of
                    {ok, {_, _, AddWeight}} ->
                        [{TemWeight+AddWeight, Grade}|Acc];
                    _ ->
                        [{TemWeight, Grade}|Acc]
                end
            end,
            RealPool = lists:foldl(Fun, [], [Elemt|NormalPool]),
            {RealPool, LuckeyValue}
    end.
    

%% 处理需要发传闻的奖励
handle_reward([], _, _, Rewards, ClientData,_,_, _) -> {Rewards, ClientData};
handle_reward([GradeId|GradeIds], Type, SubType, Rewards, ClientData, RoleName, RoleId, RewardArgs) ->  
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    Reward = lib_custom_act_util:count_act_reward(RewardArgs, RewardCfg),
    case Reward of
        [{Gtype, GoodsTypeId, GNum}|_] ->
            case get_condition_value(tv, Conditions) of
                {ModuleId, Id} -> 
                    % mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
                    RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
                    lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, RealGtypeId, GNum, Type, SubType]);
                _ -> 
                    skip
            end,
            LuckeyValue = get_condition_value(luckey_value, Conditions),
            IsRare = ?IF(LuckeyValue > 0, 1, 0),
            handle_reward(GradeIds, Type, SubType, Reward++Rewards, [{Reward, IsRare}|ClientData], RoleName, RoleId, RewardArgs);
        _ ->
            handle_reward(GradeIds, Type, SubType, Rewards, ClientData, RoleName, RoleId, RewardArgs)
    end.
    % mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),

reset(Player, Type, SubType, RareGrade) ->
    #player_status{id = RoleId, bonus_pool = Map, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    case maps:get({Type, SubType}, Map, []) of
        #bonus_pool{total_times = Total, act_data = ActData} = BonusPool -> 
            NewMap = reset_helper(Type, SubType, RareGrade, ActData, Map, RoleId, Total, BonusPool);
        _ ->
            BonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
            case BonusPool of
                #bonus_pool{total_times = Total, act_data = ActData} ->
                    NewMap = reset_helper(Type, SubType, RareGrade, ActData, Map, RoleId, Total, BonusPool);
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33144, [Type, SubType, RareGrade, ?ERRCODE(err331_lv_not_enougth), 0, 0,0,0]),
                    NewMap = Map
            end
    end,
    {ok, Player#player_status{bonus_pool = NewMap}}.

reset_helper(Type, SubType, RareGrade, ActData, Map, RoleId, Total, BonusPool) ->
    case lists:keyfind(RareGrade, #rare_reward.grade, ActData) of
        #rare_reward{draw_times = DrawTimes, state = ?HAS_DRAW, free_times = Freetimes, max_luckey_value = MaxLuckeyValue} = OldRareReward ->
            NowTime = utime:unixtime(),
            % #custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            % NewFreetimes = get_condition_value(free_times, ActCondition),
            NewGradeReward = OldRareReward#rare_reward{draw_times = 0, luckey_value = 0, state = ?NOT_DRAW, stime = NowTime, 
                max_luckey_value = MaxLuckeyValue},
            db_replace(RoleId, Type, SubType, RareGrade, 0, 0, Freetimes, ?NOT_DRAW, NowTime),
            NewTotal = Total - DrawTimes,
            NewActData = lists:keystore(RareGrade, #rare_reward.grade, ActData, NewGradeReward),
            lib_server_send:send_to_uid(RoleId, pt_331, 33144, [Type, SubType, RareGrade, 1, 0, Freetimes, ?NOT_DRAW, MaxLuckeyValue]),
            NewBonusPool = BonusPool#bonus_pool{total_times = NewTotal, act_data = NewActData};
        #rare_reward{} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33144, [Type, SubType, RareGrade, ?ERRCODE(err331_rare_reward_not_draw), 0, 0, 0, 0]),
            NewBonusPool = BonusPool;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33144, [Type, SubType, RareGrade, ?ERRCODE(data_error), 0, 0, 0, 0]),
            NewBonusPool = BonusPool
    end,
    maps:put({Type, SubType}, NewBonusPool, Map).

send_act_data(Player, Type, SubType) ->
    #player_status{id = RoleId, bonus_pool = Map, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    case maps:get({Type, SubType}, Map, []) of
        #bonus_pool{act_data = ActData, reward_args = RewardArgs} = BonusPool ->  
            NewMap = send_act_data_helper(Type, SubType, BonusPool, ActData, RewardArgs, Map, RoleId);
        _ ->
            NewBonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
            case NewBonusPool of
                #bonus_pool{act_data = ActData, reward_args = RewardArgs} = BonusPool -> 
                     NewMap = send_act_data_helper(Type, SubType, BonusPool, ActData, RewardArgs, Map, RoleId);
                _ -> NewMap = Map
            end
    end,
    {ok, Player#player_status{bonus_pool = NewMap}}.
 
send_act_data_helper(Type, SubType, BonusPool, ActData, RewardArgs, Map, RoleId) ->
    Fun = fun(#rare_reward{grade = Grade, luckey_value = LuckeyValue, free_times = Freetimes, state = State, max_luckey_value = MaxLuckeyValue}, Acc) ->
        [{Grade, LuckeyValue, Freetimes, State, MaxLuckeyValue}|Acc]
    end,
    SendList = lists:foldl(Fun, [], ActData),
    #reward_param{player_lv = _ActRoleLv, wlv = _ActWlv, sex = _ActSex, career = _ActCareer} = RewardArgs,
    % ?PRINT("===== {Type, SubType}:~p,SendList:~p~n",[{Type, SubType},SendList]),
    lib_server_send:send_to_uid(RoleId, pt_331, 33141, [Type, SubType, SendList]),
    maps:put({Type, SubType}, BonusPool, Map).

check_grade(Grade, ActData, RarePool) ->
    case lists:keyfind(Grade, 2, RarePool) of
        {_, _, _} -> 
            case lists:keyfind(Grade, #rare_reward.grade, ActData) of
                #rare_reward{grade = Grade, state = ?HAS_DRAW} ->
                    {false, ?ERRCODE(err331_rare_reward_has_draw)};
                #rare_reward{grade = Grade} = GradeReward ->
                    {true, GradeReward};
                _ ->
                    {false, ?ERRCODE(data_error)}
            end;
        _ ->
            {false, ?ERRCODE(data_error)}
    end.

midnight_update(Type, SubType, ClearType) ->
    #custom_act_cfg{clear_type = ClearTypeCfg} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    if
        ClearTypeCfg == ClearType ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pool, midnight_update_helper, [Type, SubType]) || E <- OnlineRoles];
        true ->
            skip
    end.
    
midnight_update_helper(Player, Type, SubType) ->
    #player_status{id = RoleId, bonus_pool = Map, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    #custom_act_cfg{clear_type = ClearType, condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NowTime = utime:unixtime(),
    case maps:get({Type, SubType}, Map, []) of
        #bonus_pool{act_data = ActData} = BonusPool ->
            Fun = fun(#rare_reward{grade = Grade, draw_times = ODraw_times, luckey_value = OLuckey_value, free_times = OFree_times, state = OState, stime = OStime} = RareReward, {Acc, AccSum}) ->
                {Draw_times, Luckey_value, Free_times, State, Stime} = 
                    init_data_helper(RoleId, Type, SubType, Grade, ODraw_times, OLuckey_value, OFree_times, OState, OStime, ClearType, ActCondition, NowTime),
                NewRareReward = RareReward#rare_reward{grade = Grade, draw_times = Draw_times, luckey_value = Luckey_value, free_times = Free_times, state = State, stime = Stime},
                {[NewRareReward|Acc], AccSum}
            end,
            {NewActData, Total} = lists:foldl(Fun, {[], 0}, ActData),
            NewBonusPool = BonusPool#bonus_pool{total_times = Total, act_data = NewActData},
            NewMap = maps:put({Type, SubType}, NewBonusPool, Map);
        _ ->
            NewBonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
            case NewBonusPool of
                #bonus_pool{} ->
                    NewMap = maps:put({Type, SubType}, NewBonusPool, Map);
                _ ->
                    NewMap = Map
            end
    end,
    {ok, Player#player_status{bonus_pool = NewMap}}.

act_end(Type, SubType) ->
    spawn(fun() ->
        db_delete(Type, SubType),
        db:execute(io_lib:format(?delete_player_act_args,[Type, SubType])),
        OnlineRoles = ets:tab2list(?ETS_ONLINE),
        [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pool, act_end_helper, [Type, SubType]) || E <- OnlineRoles]
        end).

act_end_helper(Player, Type, SubType) ->
    #player_status{bonus_pool = Map} = Player,
    NewMap = maps:remove({Type, SubType}, Map),
    {ok, Player#player_status{bonus_pool = NewMap}}.

act_open(Type, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    % ?PRINT("============== open {Type:~p, SubType:~p}~n",[Type, SubType]),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_pool, act_open_helper, [Type, SubType]) || E <- OnlineRoles].

act_open_helper(Player, Type, SubType) ->
    #player_status{id = RoleId, bonus_pool = Map, figure = #figure{lv = RoleLv, sex = Sex, career = Career}} = Player,
    % #custom_act_cfg{clear_type = ClearType, condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    % NowTime = utime:unixtime(),
    case maps:get({Type, SubType}, Map, []) of
        #bonus_pool{} ->
            NewMap = Map;
        _ ->
            NewBonusPool = init_data(RoleId, Type, SubType, RoleLv, Sex, Career),
            case NewBonusPool of
                #bonus_pool{} ->
                    NewMap = maps:put({Type, SubType}, NewBonusPool, Map);
                _ ->
                    NewMap = Map
            end
    end,
    {ok, Player#player_status{bonus_pool = NewMap}}.

get_cost(_, _, 0) -> [];
get_cost(Type, SubType, Times) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            case lists:keyfind(cost, 1, Conditions) of
                {cost, CostList} ->
                    Fun = fun({GType, GoodsTypeId, Num}, Acc) ->
                        [{GType, GoodsTypeId, Num*Times}|Acc]
                    end,
                    lists:foldl(Fun, [], CostList);
                _ -> 
                    []
            end;
        _ -> 
            []
    end.

get_cost(Type, SubType, Times, ActData, RareGrade) ->
    case lists:keyfind(RareGrade, #rare_reward.grade, ActData) of
        #rare_reward{free_times = Free_times} when Times == 1 andalso Free_times >= Times ->
            {true, []};
        _ ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = Conditions} ->
                    case lists:keyfind(cost, 1, Conditions) of
                        {cost, CostList} ->
                            Fun = fun({GType, GoodsTypeId, Num}, Acc) ->
                                [{GType, GoodsTypeId, Num*Times}|Acc]
                            end,
                            Cost = lists:foldl(Fun, [], CostList),
                            {true, Cost};
                        _ -> 
                            {false, ?MISSING_CONFIG}
                    end;
                _ -> 
                    {false, ?MISSING_CONFIG}
            end
    end.

%% 获得产出类型
get_produce_type(?CUSTOM_ACT_TYPE_BONUS_POOL) -> bonus_pool;
get_produce_type(_) -> unkown.

%% 获得消耗类型
get_consume_type(?CUSTOM_ACT_TYPE_BONUS_POOL) -> bonus_pool;
get_consume_type(_) -> unkown.

send_reward_status(Player, ActInfo) ->
    #act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    #custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lists:keyfind(wlv, 1, ActCondition) of
        {_, [{Min, Max}|_]} when Wlv >= Min andalso Wlv =< Max -> 
            GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                    #custom_act_reward_cfg{
                        name = Name,
                        desc = Desc,
                        condition = Condition,
                        format = Format,
                        reward = Reward
                    } ->
                        %% 计算奖励的领取状态
                        Status = ?ACT_REWARD_CAN_NOT_GET,
                        %% 计算奖励的已领取次数
                        ReceiveTimes = 0,
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ -> Acc
                end
                end,
            PackList = lists:foldl(F, [], GradeIds),
            SendList = lists:keysort(1, PackList);
        _ ->
            SendList = []
    end,
    {ok, BinData} = pt_331:write(33104, [Type, SubType, SendList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).