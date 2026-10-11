%%% -------------------------------------------------------------------
%%% @doc        lib_draw_simulation                 
%%% @author     lwc                      
%%% @email      liuweichao@suyougame.com
%%% @since      2022-04-01 10:58               
%%% @deprecated 抽奖模拟逻辑层
%%% -------------------------------------------------------------------

-module(lib_draw_simulation).

-include("custom_act.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("bonus_draw.hrl").

%% API
-export([gm_draw_simulation/4]).

%% -----------------------------------------------------------------
%% @desc   幸运转盘
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE,
    RewardParam = get_reward_param(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {GradeState, ResultList} = draw_lucky_turntable(Type, SubType, RewardParam, 1, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   冲榜夺宝抽奖/摇钱树抽奖
%% @param  Type         主类型
%% @param  SubType      子类型
%% @param  MaxNum       抽奖次数
%% @param  SelectPool   自选奖池
%% @return [{GradeId,   Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(Type, SubType, MaxNum, _SelectPool) when Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE orelse Type =:= ?CUSTOM_ACT_TYPE_BONUS_TREE->
    {Pool, RarePool, MaxDoomedTimes} = lib_bonus_tree:get_pool(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    RewardParam = get_reward_param(Type, SubType),
    {GradeState, ResultList} = draw_bonus(0, 0, MaxDoomedTimes, Pool, RarePool, [], Type, SubType, RewardParam, MaxSimulationNum + 1, 1, MaxNum + 1, []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    %?MYLOG("lwcdraw","ResultList:~p~n",[ResultList]),
    F = fun({GradeId, DrawTimes, _Time}, List) -> [{GradeId, DrawTimes} | List] end,
    lists:foldl(F, [], GradeState);

%% -----------------------------------------------------------------
%% @desc   赛博夺宝
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_DRAW_REWARD, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_DRAW_REWARD,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    RewardParam = get_reward_param(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    Pool = lib_bonus_draw:calc_default_pool(Type, SubType, Conditions, 0),
    {GradeState, ResultList} = draw_cyber(Type, SubType, 0, Pool, 0, RewardParam, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   神圣召唤抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_HOLY_SUMMON,
    RewardParam = get_reward_param(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {GradeState, ResultList} = draw_holy_summon(Type, SubType, RewardParam, 0, 0, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   自选奖池抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW, _SubType, _MaxNum, []) -> [];
gm_draw_simulation(?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_COHOSE_REWARD_DRAW,
    SelectPool = util:string_to_term(_SelectPool),
    RealPool = lib_select_pool_draw:calc_real_pool(SelectPool, []),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    RewardParam = get_reward_param(Type, SubType),
    {GradeState, ResultList} = draw_simulation(Type, SubType, 0, RealPool, [], RewardParam, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   幸运探宝抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_LUCKEY_WHEEL, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_LUCKEY_WHEEL,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    RewardParam = get_reward_param(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {base_pool_reward, PoolReward} = ulists:keyfind(base_pool_reward, 1, Conditions, {base_pool_reward, [{1, 0, 3000}]}),
    {GradeState, ResultList} = draw_lucky_wheel(Type, SubType, 0, [], RewardParam, PoolReward, MaxNum, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   天命转盘抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_DESTINY_TURN, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_DESTINY_TURN,
    RewardParam = get_reward_param(Type, SubType),
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {GradeState, ResultList} = draw_destiny_turn(Type, SubType, 1, [], RewardParam, MaxSimulationNum + 1, 1, MaxNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   幸运鉴宝抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_TREASURE_HUNT, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_TREASURE_HUNT,
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {GradeState, ResultList} = draw_treasure_hunt(Type, SubType, 1, 0, [], 0, 1, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

%% -----------------------------------------------------------------
%% @desc   幸运扭蛋抽奖
%% @param  Type       主类型
%% @param  SubType    子类型
%% @param  MaxNum     抽奖次数
%% @param  SelectPool 自选奖池
%% @return [{GradeId, Times},...]
%% -----------------------------------------------------------------
gm_draw_simulation(?CUSTOM_ACT_TYPE_COMMON_DRAW, SubType, MaxNum, _SelectPool) ->
    Type = ?CUSTOM_ACT_TYPE_COMMON_DRAW,
    MaxSimulationNum = get_max_simulation_num(Type, SubType),
    {GradeState, ResultList} = draw_common(Type, SubType, [], 0, 0, MaxNum + 1, MaxSimulationNum + 1, [], []),
    lib_draw_simulation_sql:db_batch_replace_draw_simulation_info(lists:reverse(ResultList)),
    GradeState;

gm_draw_simulation(_Type, _SubType, _MaxNum, _SelectPool) -> [].

%% -----------------------------------------------------------------
%% @desc   幸运转盘抽奖
%% @param  Type             主类型
%% @param  SubType          子类型
%% @param  RewardParam      奖励参数
%% @param  Num              当前抽奖次数
%% @param  MaxNum           最大抽奖次数
%% @param  MaxSimulationNum 当前抽奖序号
%% @param  GradeState       抽奖奖励次数列表
%% @param  ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_lucky_turntable(_Type, _SubType, _RewardParam, MaxNum, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_lucky_turntable(Type, SubType, RewardParam, Num, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId) ->
        #custom_act_reward_cfg{condition = RConditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:keyfind(weight, 1, RConditions) of
            {weight, Weight} -> ok;
            _ -> Weight = 0
        end,
        case lists:keyfind(n_times, 1, RConditions) of
            {n_times, N} -> ok;
            _ -> N = 1
        end,
        {Weight, [RewardCfg, N]}
        end,
    WeightList = lists:map(F, Ids),
    [RewardCfg, NTimes] = urand:rand_with_weight(WeightList),
    [Hd|_] = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
    Rewards = lib_goods_util:goods_object_multiply_by([Hd], NTimes),
    #custom_act_reward_cfg{grade = GradeId} = RewardCfg,
    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
    NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Rewards), utime:unixtime()],
    draw_lucky_turntable(Type, SubType, RewardParam, Num + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]).

%% -----------------------------------------------------------------
%% @desc   冲榜夺宝抽奖/摇钱树
%% @param  AllTimes         所有抽奖
%% @param  DoomedTimes      必中次数
%% @param  MaxDoomedTimes   最大必中次数
%% @param  Pool             奖池
%% @param  RarePool         稀有奖池
%% @param  GradeState       抽奖奖励次数列表
%% @param  Type             主类型
%% @param  SubType          次类型
%% @param  RewardParam      奖励参数
%% @param  MaxSimulationNum 当前抽奖序号
%% @param  Num              当前抽奖次数
%% @param  MaxNum           最大抽奖次数
%% @param  ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_bonus(_AllTimes, _DoomedTimes, _MaxDoomedTimes, _Pool, _RarePool, GradeState, _Type, _SubType, _RewardParam, _MaxSimulationNum, MaxNum, MaxNum, ResultList) -> {GradeState, ResultList};
draw_bonus(AllTimes, DoomedTimes, MaxDoomedTimes, Pool, RarePool, GradeState, Type, SubType, RewardParam, MaxSimulationNum, Num, MaxNum, ResultList) ->
    {RealPool, NewDoomedTimes} = lib_bonus_tree:do_draw_core(Pool, RarePool, AllTimes, DoomedTimes + 1, MaxDoomedTimes),
    GradeId = urand:rand_with_weight(RealPool),
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    RareDoomed = lib_bonus_tree:get_conditions(rare_award, Conditions),
    case lib_bonus_tree:can_give_grade(Conditions, GradeId, GradeState, AllTimes) of
        true ->
            {DrawTimes, _Utime} = lib_bonus_tree:get_conditions_1(GradeId, GradeState),
            NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, DrawTimes + 1, utime:unixtime()}),
            RealDoomedTimes = ?IF(RareDoomed > 0, 0, NewDoomedTimes),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
            NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
            %?MYLOG("lwcdraw","NewResult:~p~n",[NewResult]),
            draw_bonus(AllTimes + 1, RealDoomedTimes, MaxDoomedTimes, Pool, RarePool, NewGradeState, Type, SubType, RewardParam, MaxSimulationNum, Num + 1, MaxNum, [NewResult | ResultList]);
        false -> draw_bonus(AllTimes, DoomedTimes, MaxDoomedTimes, Pool, RarePool, GradeState, Type, SubType, RewardParam, MaxSimulationNum, Num, MaxNum, ResultList)
    end.

%% -----------------------------------------------------------------
%% @desc  赛博夺宝
%% @param Type             主类型
%% @param SubType          子类型
%% @param Wave             波数
%% @param Pool             奖池
%% @param DrawTimes        抽奖次数
%% @param RewardParam      奖励参数
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_cyber(_Type, _SubType, _Wave, _Pool, MaxNum, _RewardParam, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_cyber(Type, SubType, Wave, Pool, DrawTimes, RewardParam, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    case lib_bonus_draw:calc_pool(Pool, Wave, Type, SubType) of
        {true, NewPoolA, NewWaveA} -> skip;
        _ -> NewPoolA = Pool, NewWaveA = Wave
    end,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    SpecialLength = lib_bonus_draw:get_conditions(special, ActConditions),
    TotalWeight = lib_bonus_draw:get_normal_pool_total_weight(Type, SubType, Wave),
    RealPool = lib_bonus_draw:do_draw_core(NewPoolA, NewWaveA, Type, SubType, DrawTimes + 1, TotalWeight, SpecialLength),
    {GradeCfg, _SortId} = urand:rand_with_weight(RealPool),
    case GradeCfg of
        #base_draw_pool{rare = ?RARE} -> NewGradeCfg = GradeCfg;
        _ -> NewGradeCfg = lib_bonus_draw:calc_normal_reward(Type, SubType, Wave, DrawTimes + 1)
    end,
    {NewWave, NewPool} = lib_bonus_draw:calc_pool(GradeCfg, Pool, Wave, Type, SubType),
    #base_draw_pool{grade = GradeId, reward_type = RewardType, reward = RewardCfg} = NewGradeCfg,
    Reward = lib_bonus_draw:calc_reward(Type, SubType, RewardType, RewardCfg),
    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
    NewResult = [MaxSimulationNum, DrawTimes, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
    draw_cyber(Type, SubType, NewWave, NewPool, DrawTimes + 1, RewardParam, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]).

%% -----------------------------------------------------------------
%% @desc 神圣召唤抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param RewardParam      奖励参数
%% @param RareDraw         稀有抽奖次数
%% @param DrawTimes        抽奖次数
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_holy_summon(_Type, _SubType, _RewardParam, _RareDraw, MaxNum, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_holy_summon(Type, SubType, RewardParam, RareDraw, DrawTimes, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    Pool = lib_holy_summon:get_pool(Type, SubType),
    RealPoolA = lib_holy_summon:do_draw_core(Pool, DrawTimes),
    GradeIdA = urand:rand_with_weight(RealPoolA),
    {GradeIdA, TimesA} = ulists:keyfind(GradeIdA, 1, GradeState, {GradeIdA, 0}),
    NewGradeStateA = lists:keystore(GradeIdA, 1, GradeState, {GradeIdA, TimesA + 1}),
    RewardCfgA = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeIdA),
    RewardA = lib_custom_act_util:count_act_reward(RewardParam, RewardCfgA),
    if
        GradeIdA =:= 13 ->
            RarePool = lib_holy_summon:get_rare_pool(Type, SubType),
            RealPool = lib_holy_summon:do_draw_core(RarePool, RareDraw),
            GradeId = urand:rand_with_weight(RealPool),
            RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
            {GradeId, Times} = ulists:keyfind(GradeId, 1, NewGradeStateA, {GradeId, 0}),
            NewGradeState = lists:keystore(GradeId, 1, NewGradeStateA, {GradeId, Times + 1}),
            NewResult = [MaxSimulationNum, DrawTimes, Type, SubType, GradeIdA, util:term_to_bitstring(Reward ++ RewardA), utime:unixtime()],
            draw_holy_summon(Type, SubType, RewardParam, RareDraw + 1, DrawTimes + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]);
        true ->
            NewResult = [MaxSimulationNum, DrawTimes, Type, SubType, GradeIdA, util:term_to_bitstring(RewardA), utime:unixtime()],
            draw_holy_summon(Type, SubType, RewardParam, RareDraw, DrawTimes + 1, MaxNum, MaxSimulationNum, NewGradeStateA, [NewResult | ResultList])
    end.

%% -----------------------------------------------------------------
%% @desc  自选奖池抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param DrawTimes        抽奖次数
%% @param Pool             奖池
%% @param Stage            阶段
%% @param RewardParam      奖励参数
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_simulation(_Type, _SubType, MaxNum, _Pool, _Stage, _RewardParam, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_simulation(Type, SubType, DrawTimes, Pool, Stage, RewardParam, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NewDrawTimes = DrawTimes + 1,
    Rare = lib_select_pool_draw:calc_rare(ActConditions, NewDrawTimes, Pool, []),
    RealPool = lib_select_pool_draw:calc_draw_pool(Type, SubType, Rare, Pool, NewDrawTimes),
    if
        length(RealPool) =:= 0 -> {GradeState, ResultList};
        true ->
            #custom_act_reward_cfg{grade = GradeId} = RewardCfg = urand:rand_with_weight(RealPool),
            {NewPool, NewStage} = lib_select_pool_draw:calc_data_after_draw(RewardCfg, Pool, Stage, NewDrawTimes),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
            {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
            NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
            NewResult = [MaxSimulationNum, NewDrawTimes, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
            draw_simulation(Type, SubType, NewDrawTimes, NewPool, NewStage, RewardParam, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList])
    end.

%% -----------------------------------------------------------------
%% @desc  幸运探宝抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param DrawTimes        抽奖次数
%% @param RoleCounterList  抽奖奖励次数列表
%% @param RewardParam      奖励参数
%% @param PoolReward       勾玉奖池
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       日志列表
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_lucky_wheel(_Type, _SubType, MaxNum, _RoleCounterList, _RewardParam, _PoolReward, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_lucky_wheel(Type, SubType, DrawTimes, RoleCounterList, RewardParam, PoolReward, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    {Pool, SpeList} = lib_luckey_wheel_mod:calc_pool(Type, SubType, DrawTimes + 1, RoleCounterList),
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    GradeId = urand:rand_with_weight(Pool),
    case lists:member(GradeId, SpeList) of
        true ->
            Now = utime:unixtime(),
            case lists:keyfind(GradeId, 1, RoleCounterList) of
                {_, Num, _} -> NewNum = Num+1;
                _ -> NewNum = 1
            end,
            NewRoleCounterList = lists:keystore(GradeId, 1, RoleCounterList, {GradeId, NewNum, Now});
        _ -> NewRoleCounterList = RoleCounterList
    end,
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
    AddPoolReward = lib_luckey_wheel_mod:calc_pool_reward(1, ActConditions),
    NewPoolRewardA = ulists:object_list_plus([AddPoolReward, PoolReward]),
    if
        Reward =:= [] ->
            NewReward = lib_luckey_wheel:calc_draw_pool_reward(Conditions, PoolReward),
            DeletePoolReward = ulists:object_list_plus([Reward, []]),
            NewPoolReward = lib_luckey_wheel_mod:object_list_minus([NewPoolRewardA, DeletePoolReward]);
        true -> NewReward = Reward, NewPoolReward = NewPoolRewardA
    end,
    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
    NewResult = [MaxSimulationNum, DrawTimes + 1, Type, SubType, GradeId, util:term_to_bitstring(NewReward), utime:unixtime()],
    draw_lucky_wheel(Type, SubType, DrawTimes + 1, NewRoleCounterList, RewardParam, NewPoolReward, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]).

%% -----------------------------------------------------------------
%% @desc  天命转盘抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param Turn             轮次
%% @param GetGrades        已抽取的奖励列表
%% @param RewardParam      奖励参数
%% @param MaxSimulationNum 当前抽奖序号
%% @param Num              抽奖次数
%% @param MaxNum           最大抽奖次数
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       抽奖日志
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_destiny_turn(_Type, _SubType, _Turn, _GetGrades, _RewardParam, _MaxSimulationNum, MaxNum, MaxNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_destiny_turn(Type, SubType, Turn, GetGrades, RewardParam, MaxSimulationNum, Num, MaxNum, GradeState, ResultList) ->
    Ids = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    WeightList =
        [begin
             RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
             #custom_act_reward_cfg{condition = Condition} = RewardCfg,
             {weight, Weight} = lists:keyfind(weight, 1, Condition),
             {Weight, RewardCfg}
         end || GradeId<-Ids, lib_destiny_turntable:check_is_reward_pool(Type, SubType, GradeId, GetGrades, Turn)],
    if
        length(WeightList) =:= 0 -> draw_destiny_turn(Type, SubType, 1, [], RewardParam, MaxSimulationNum, Num, MaxNum, GradeState, ResultList);
        true ->
            #custom_act_reward_cfg{grade = GradeId} = RewardCfg = urand:rand_with_weight(WeightList),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
            {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
            NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
            NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
            draw_destiny_turn(Type, SubType, Turn + 1, [GradeId | GetGrades], RewardParam, MaxSimulationNum, Num + 1, MaxNum, NewGradeState, [NewResult | ResultList])
    end.

%% -----------------------------------------------------------------
%% @desc  幸运鉴宝抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param Turn             轮次
%% @param RareTimes        稀有次数
%% @param GradeList        已抽取稀有奖励列表
%% @param DrawTimes        每轮的抽奖次数
%% @param Num              抽奖次数
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       抽奖日志
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_treasure_hunt(_Type, _SubType, _Turn, _RareTimes, _GradeList, _DrawTimes, MaxNum, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_treasure_hunt(Type, SubType, Turn, RareTimes, GradeList, DrawTimes, Num, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {NormalPool, RarePool} = lib_bonus_treasure:calc_pool(Type, SubType, Turn, GradeList),
    {_, AddValue} = ulists:keyfind(add_value, 1, Conditions, {add_value, 10}),
    {_, LuckyValList} = ulists:keyfind(luckyvalue, 1, Conditions, {luckyvalue, []}),
    {_, MaxLuckyVal} = ulists:keyfind(Turn, 1, LuckyValList, {Turn, 0}),
    NowLuckyVal = DrawTimes * AddValue + AddValue,
    if
        NowLuckyVal >= MaxLuckyVal orelse DrawTimes + 1 == RareTimes ->
            case urand:rand_with_weight(RarePool) of
                #custom_act_reward_cfg{grade = GradeId, reward = Reward} ->
                    {GradeId, NumA} = ulists:keyfind(GradeId, 1, GradeList, {GradeId, 0}),
                    NewGradeList = lists:keystore(GradeId, 1, GradeList, {GradeId, NumA + 1}),
                    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
                    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
                    NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
                    draw_treasure_hunt(Type, SubType, Turn + 1, 0, NewGradeList, 0, Num + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]);
                _ -> draw_treasure_hunt(Type, SubType, 1, 0, [], 0, Num, MaxNum, MaxSimulationNum, GradeState, ResultList)
            end;
        true ->
            GradeCfg = urand:rand_with_weight(NormalPool),
            #custom_act_reward_cfg{grade = GradeId, reward = Reward, condition = ConditionA} = GradeCfg,
            {_, RareWeight} = ulists:keyfind(rare, 1, ConditionA, {rare, 0}),
            case RareWeight > 0 of
                true ->
                    {GradeId, NumA} = ulists:keyfind(GradeId, 1, GradeList, {GradeId, 0}),
                    NewGradeList = lists:keystore(GradeId, 1, GradeList, {GradeId, NumA + 1}),
                    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
                    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
                    NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
                    draw_treasure_hunt(Type, SubType, Turn + 1, 0, NewGradeList, 0, Num + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]);
                false ->
                    %% 计算保底次数
                    NewRareTimes = lib_bonus_treasure:calc_rare_times(Type, SubType, Turn, DrawTimes + 1, RareTimes),
                    {GradeId, Times} = ulists:keyfind(GradeId, 1, GradeState, {GradeId, 0}),
                    NewGradeState = lists:keystore(GradeId, 1, GradeState, {GradeId, Times + 1}),
                    NewResult = [MaxSimulationNum, Num, Type, SubType, GradeId, util:term_to_bitstring(Reward), utime:unixtime()],
                    draw_treasure_hunt(Type, SubType, Turn, NewRareTimes, GradeList, DrawTimes + 1, Num + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList])
            end
    end.

%% -----------------------------------------------------------------
%% @desc  幸运扭蛋抽奖
%% @param Type             主类型
%% @param SubType          子类型
%% @param NiceList         已抽取奖励列表
%% @param LuckValue        幸运值
%% @param Num              抽奖数
%% @param MaxNum           最大抽奖次数
%% @param MaxSimulationNum 当前抽奖序号
%% @param GradeState       抽奖奖励次数列表
%% @param ResultList       抽奖日志
%% @return {GradeState, ResultList}
%% -----------------------------------------------------------------
draw_common(_Type, _SubType, _NiceList, _LuckValue, MaxNum, MaxNum, _MaxSimulationNum, GradeState, ResultList) -> {GradeState, ResultList};
draw_common(Type, SubType, NiceList, LuckValue, Num, MaxNum, MaxSimulationNum, GradeState, ResultList) ->
    #custom_act_cfg{condition = CfgCondition} = CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {max_luck, MaxLuck} = ulists:keyfind(max_luck, 1, CfgCondition, {max_luck, 0}),
    {per_luck, PerLuck} = ulists:keyfind(per_luck, 1, CfgCondition, {per_luck, 0}),
    IsBack = lib_common_draw:check_draw(CustomActCfg, is_back),
    IsClear = MaxLuck =/= 0,
    CurrentLuck = LuckValue + PerLuck,
    {DrawRewardPool, _, _} = lib_common_draw:load_all_reward(Type, SubType, [], NiceList),
    NewDrawRewardPool =
        if
            not IsBack ->
                [Item||{GradeId, _, _, _, _} = Item <-DrawRewardPool, not lists:member(GradeId, NiceList)];
            true -> DrawRewardPool
        end,
    IsMustNice = MaxLuck =/= 0 andalso CurrentLuck >= MaxLuck,
    CurrentTimes = Num + 1,
    F = fun({GradeId, IsNice, _, Reward, Condition}, GrandWeightList) ->
        {weight, WeightCon} = lists:keyfind(weight, 1, Condition),
        WeightVal = lib_common_draw:calc_weight_value(WeightCon, CurrentTimes, CurrentLuck),
        Item = {WeightVal, {GradeId, IsNice, Reward, Condition}},
        case IsMustNice of
            true -> ?IF(IsNice == 1, [Item|GrandWeightList], GrandWeightList);
            _ -> [Item | GrandWeightList]
        end
    end,
    WeightList = lists:foldl(F, [], NewDrawRewardPool),
    {GetGradeId, IsNice, GetReward, _ConditionA} = urand:rand_with_weight(WeightList),
    NewNiceList = ?IF(IsNice == 1 andalso IsBack, [GetGradeId|NiceList], NiceList),
    LastLuckVal = ?IF(IsNice == 1 andalso IsClear, 0, CurrentLuck),
    {GetGradeId, Times} = ulists:keyfind(GetGradeId, 1, GradeState, {GetGradeId, 0}),
    NewGradeState = lists:keystore(GetGradeId, 1, GradeState, {GetGradeId, Times + 1}),
    NewResult = [MaxSimulationNum, Num, Type, SubType, GetGradeId, util:term_to_bitstring(GetReward), utime:unixtime()],
    draw_common(Type, SubType, NewNiceList, LastLuckVal, Num + 1, MaxNum, MaxSimulationNum, NewGradeState, [NewResult | ResultList]).

%% -----------------------------------------------------------------
%% @desc  获得奖励参数
%% @param Type    主类型
%% @param SubType 子类型
%% @return #reward_param{}
%% -----------------------------------------------------------------
get_reward_param(Type, SubType) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, CfgRoleLv} = ulists:keyfind(role_lv, 1, Conditions, {role_lv, 1}),
    MaxLv = hd(data_exp:get_all_lv()),
    RoleLv = urand:rand(CfgRoleLv, MaxLv),
    WorldLv = util:get_world_lv(),
    Career = urand:list_rand(?CAREER_LIST),
    Sex = urand:list_rand([?MALE, ?FEMALE]),
    lib_custom_act:make_rwparam(RoleLv, Sex, WorldLv, Career).

%% -----------------------------------------------------------------
%% @desc  获得活动最大模拟序号
%% @param Type       主类型
%% @param SubType    子类型
%% @return MaxSimulationNum
%% -----------------------------------------------------------------
get_max_simulation_num(Type, SubType) ->
    case lib_draw_simulation_sql:db_get_max_simulation_num(Type, SubType) of
        [MaxSimulationNum] when is_integer(MaxSimulationNum) -> MaxSimulationNum;
        _ -> 0
    end.