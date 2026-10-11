%%-----------------------------------------------------------------------------
%% @Module  :       lib_bonus_treasure
%% @Author  :       xlh
%% @Email   :
%% @Created :       2019-09-17
%% @Description:    幸运鉴宝
%%-----------------------------------------------------------------------------
-module(lib_bonus_treasure).

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

-export([
    convert_data/3
    , convert_db_data/3
    , clear_data/2
    , clear_data/3

    , get_show_data/3
    , draw_reward/6
    , gm_reset_bonus_treasure/3
    ,calc_pool/4
    ,get_act_cfg/4
    ,calc_rare_times/5
    ]).

-record(role_treasure_data, {
        turn = 0            %% 轮数
    ,   draw_times = 0      %% 当前抽奖次数
    ,   rare_times = 0      %% 当轮必中稀有奖品次数
    ,   rare_log = []       %% 大奖记录
}).

% ?CUSTOM_ACT_TYPE_TREASURE_HUNT
make_record(Turn, DrawTimes, RareTimes, GradeList) ->
    #role_treasure_data{turn = Turn, draw_times = DrawTimes, rare_times = RareTimes, rare_log = GradeList}.

%% 数据库数据转化
convert_data(_Type, _SubType, Data)  ->
    case Data of
        [Turn, DrawTimes, RareTimes, GradeList|_] -> skip;
        _ -> Turn = 1, DrawTimes = 0, RareTimes = 0, GradeList = []
    end,
    make_record(Turn, DrawTimes, RareTimes, GradeList).

%% 内存数据转化存储入库
convert_db_data(_Type, _SubType, Data) ->
    case Data of
        #role_treasure_data{turn = Turn, draw_times = DrawTimes, rare_times = RareTimes, rare_log = GradeList} ->
            [Turn, DrawTimes, RareTimes, GradeList];
        _ -> []
    end.

clear_data(Type, SubType) ->
    %% 清除当天数据
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_bonus_treasure, clear_data, [Type, SubType]) || E <- OnlineRoles].

clear_data(Player, Type, SubType) -> %% 清除在线玩家数据
    % lib_custom_act:db_delete_custom_act_data(Player, Type, SubType),
    NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Player, Type, SubType),
    {ok, NewPlayer}.

get_show_data(Player, Type, SubType) ->
    #player_status{
        figure = #figure{lv = RoleLv}, id = RoleId,
        status_custom_act = StatusCustomAct
    } = Player,
    Res = check_before(Type, SubType, RoleLv),
    if
        Res == false -> skip;
        true ->
            #status_custom_act{data_map = DataMap} = StatusCustomAct,
            case maps:get({Type, SubType}, DataMap, []) of
                #custom_act_data{data = Data} when is_record(Data, role_treasure_data) ->
                    #role_treasure_data{turn = Turn, draw_times = DrawTimes, rare_log = GradeList} = Data;
                _ ->
                    Turn = 1, DrawTimes = 0, GradeList = []
            end,
            SendList = get_show_data_core(Type, SubType, RoleLv),
            % ?PRINT("Type, SubType, DrawTimes, Turn, GradeList~p~n",[[Type, SubType, DrawTimes, Turn, GradeList]]),
            {ok, Bin} = pt_332:write(33243, [Type, SubType, DrawTimes, Turn, GradeList, SendList]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end.

draw_reward(Player, Type, SubType, Times, AutoBuy, OldTurn) ->
    #player_status{
        figure = #figure{lv = RoleLv, name = RoleName},
        id = RoleId, status_custom_act = StatusCustomAct
    } = Player,
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    IsLvEnougth = lib_custom_act_task:check_lv(RoleLv, Type, SubType),
    % ?PRINT("IsOpen:~p, IsLvEnougth:~p~n",[IsOpen, IsLvEnougth]),
    if
        IsOpen == false ->
            Code = ?ERRCODE(err331_act_closed),
            {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPS = Player;
        IsLvEnougth == false ->
            Code = ?ERRCODE(err331_lv_not_enougth),
            {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPS = Player;
        true ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            #status_custom_act{data_map = DataMap} = StatusCustomAct,
            case maps:get({Type, SubType}, DataMap, []) of
                #custom_act_data{data = Data} = CustomData when is_record(Data, role_treasure_data) ->
                    #role_treasure_data{turn = Turn, draw_times = DrawTimes, rare_times = RareTimes, rare_log = GradeList} = Data;
                _ ->
                    Turn = 1, DrawTimes = 0, RareTimes = 0, GradeList = [],
                    Data = make_record(Turn, DrawTimes, RareTimes, GradeList),
                    CustomData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = Data}
            end,
            {Cost, AddValueOne, LuckyValList, RealDrawTimes} = get_act_cfg(Conditions, Times, DrawTimes, Turn),
            {_, MaxLuckyVal} = ulists:keyfind(Turn, 1, LuckyValList, {Turn, 0}),
            {NormalPool, RarePool} = calc_pool(Type, SubType, Turn, GradeList),
            if
                RarePool == [] ->
                    NewPS = Player, Code = ?ERRCODE(err331_rare_reward_is_null),
                    {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], DrawTimes, Turn, GradeList]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                RealDrawTimes =< 0 ->
                    NewPS = Player, Code = ?ERRCODE(err331_error_data),
                    {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], DrawTimes, Turn, GradeList]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                MaxLuckyVal =< 0 ->
                    NewPS = Player, Code = ?ERRCODE(err331_draw_times_limit),
                    {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], DrawTimes, Turn, GradeList]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                OldTurn =/= Turn ->
                    NewPS = Player;
                    % Code = ?ERRCODE(err331_error_data),
                    % {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], DrawTimes, Turn, GradeList]);
                true ->
                    NowLuckyVal = DrawTimes*AddValueOne,
                    case cost_something(Player, Cost, Type, AutoBuy) of
                        {true, NewPlayer, _NewCost} ->
                            % ?PRINT("Cost:~p, NowLuckyVal:~p~n",[Cost, NowLuckyVal]),
                            {NewTurn, NewDrawTimes, NewRareTimes, NewGradeList, NewLuckyVal, RewardCfgList} =
                            draw_reward_core(Type, SubType, Turn, DrawTimes, RareTimes, GradeList, RealDrawTimes, NowLuckyVal,
                                LuckyValList, MaxLuckyVal, AddValueOne, NormalPool, RarePool, []),
                            NewData = Data#role_treasure_data{
                                turn = NewTurn,
                                draw_times = NewDrawTimes,
                                rare_times = NewRareTimes,
                                rare_log = NewGradeList
                            },
                            NewCustomData = CustomData#custom_act_data{data = NewData},
                            lib_custom_act:db_save_custom_act_data(NewPlayer, NewCustomData),
                            NewDataMap = maps:put({Type, SubType}, NewCustomData, DataMap),
                            NewStatusCustomAct = StatusCustomAct#status_custom_act{data_map = NewDataMap},
                            {RewardList, GradeIdList} = handle_reward(NewPlayer, RoleName, RoleId, Type, SubType, RewardCfgList, [], []),
                            ProduceType = get_produce_type(Type),
                            Produce = #produce{type = ProduceType, subtype = Type, reward = RewardList, show_tips = ?SHOW_TIPS_4},
                            NewPlayer1 = NewPlayer#player_status{status_custom_act = NewStatusCustomAct},
                            NewPS = lib_goods_api:send_reward(NewPlayer1, Produce),
                            lib_log_api:log_custom_treasure(RoleId, RoleName, Type, SubType, NewTurn, NewDrawTimes, NewLuckyVal, RewardList, GradeIdList),
                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, RewardList),
                            ta_agent_fire:log_custom_treasure(NewPS, Type, SubType, NewTurn, NewDrawTimes, NewLuckyVal, GradeIdList),
                            {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, 1, GradeIdList, RewardList, NewDrawTimes, NewTurn, NewGradeList]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        {false, Code, NewPS} ->
                            {ok, Bin} = pt_332:write(33244, [Type, SubType, Times, AutoBuy, Code, [], [], DrawTimes, Turn, GradeList]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end
            end
    end,
    {ok, NewPS}.

draw_reward_core(_, _, Turn, DrawTimes, RareTimes, GradeList, 0, LuckyVal, _, _, _, _, _, RewardCfgList) -> % 抽奖结束
    {Turn, DrawTimes, RareTimes, GradeList, LuckyVal, RewardCfgList};
draw_reward_core(Type, SubType, Turn, DrawTimes, RareTimes, GradeList, Times, LuckyVal, LuckyValList, MaxLuckyVal, AddValueOne, _, RarePool, Acc) when LuckyVal+AddValueOne >= MaxLuckyVal; % 机制一：达到幸运值
                                                                                                                                                       DrawTimes+1 == RareTimes -> % 机制二：达到保底次数
    case urand:rand_with_weight(RarePool) of
        #custom_act_reward_cfg{grade = GradeId} = GradeCfg ->
            {GradeId, Num} = ulists:keyfind(GradeId, 1, GradeList, {GradeId, 0}),
            NewGradeList = lists:keystore(GradeId, 1, GradeList, {GradeId, Num+1}),
            NewAcc = [GradeCfg|Acc];
        _ -> %% 一般走不到这里
            ?ERR("Type:~p, SubType:~p, Turn:~p, DrawTimes:~p, LuckyVal:~p, GradeList:~p~n, RarePool:~p~n",
                [Type, SubType, Turn, DrawTimes, LuckyVal, GradeList, RarePool]),
            NewGradeList = GradeList, NewAcc = Acc
    end,
    {NewNormalPool, NewRarePool} = calc_pool(Type, SubType, Turn+1, NewGradeList),
    {_, MaxLuckyVal1} = ulists:keyfind(Turn+1, 1, LuckyValList, {Turn+1, 0}),
    draw_reward_core(Type, SubType, Turn+1, 0, 0, NewGradeList, Times-1, 0, LuckyValList, MaxLuckyVal1, AddValueOne,
        NewNormalPool, NewRarePool, NewAcc);
draw_reward_core(Type, SubType, Turn, DrawTimes, RareTimes, GradeList, Times, LuckyVal, LuckyValList, MaxLuckyVal, AddValueOne, NormalPool, RarePool, Acc) -> % 常规抽奖流程
    NowLuckyVal = LuckyVal + AddValueOne,
    GradeCfg = urand:rand_with_weight(NormalPool),
    #custom_act_reward_cfg{grade = GradeId, condition = Conditions} = GradeCfg,
    {_, RareWeight} = ulists:keyfind(rare, 1, Conditions, {rare, 0}),
    IsRare = ?IF(RareWeight > 0, true, false),
    NewAcc = [GradeCfg|Acc],
    if
        IsRare == true ->
            {GradeId, Num} = ulists:keyfind(GradeId, 1, GradeList, {GradeId, 0}),
            NewGradeList = lists:keystore(GradeId, 1, GradeList, {GradeId, Num+1}),
            {_, MaxLuckyVal1} = ulists:keyfind(Turn+1, 1, LuckyValList, {Turn+1, 0}),
            {NewNormalPool, NewRarePool} = calc_pool(Type, SubType, Turn+1, NewGradeList),
            draw_reward_core(Type, SubType, Turn+1, 0, 0, NewGradeList, Times-1, 0, LuckyValList, MaxLuckyVal1, AddValueOne,
                NewNormalPool, NewRarePool, NewAcc);
        true ->
            NewRareTimes = calc_rare_times(Type, SubType, Turn, DrawTimes+1, RareTimes), % 计算保底次数
            draw_reward_core(Type, SubType, Turn, DrawTimes+1, NewRareTimes, GradeList, Times-1,
                NowLuckyVal, LuckyValList, MaxLuckyVal, AddValueOne, NormalPool, RarePool, NewAcc)
    end.

handle_reward(_, _, _, _, _, [], RewardList, GradeIdList) -> {RewardList, GradeIdList};
handle_reward(Player, RoleName, RoleId, Type, SubType, [RewardCfg|RewardCfgList], RewardList, GradeIdList)
when is_record(RewardCfg, custom_act_reward_cfg) ->
    #custom_act_reward_cfg{grade = GradeId, condition = Conditions} = RewardCfg,
    ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
    case Reward of
        [{Gtype, GoodsTypeId, _GNum}|_] ->
            case lists:keyfind(tv, 1, Conditions) of
                {_, {ModuleId, Id}} ->
                    WrapperName = lib_player:get_wrap_role_name(Player),
                    mod_custom_act_record:cast({save_all_log_and_notice, RoleId, Type, SubType, WrapperName, Reward}),
                    RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
                    lib_chat:send_TV({all}, ModuleId, Id, [WrapperName, RoleId, RealGtypeId, Type, SubType]);
                _ ->
                    mod_custom_act_record:cast({save_role_log_and_notice, RoleId, Type, SubType, RoleName, Reward}),
                    skip
            end,
            handle_reward(Player, RoleName, RoleId, Type, SubType, RewardCfgList, Reward++RewardList, [GradeId|GradeIdList]);
        _ ->
            handle_reward(Player, RoleName, RoleId, Type, SubType, RewardCfgList, RewardList, [GradeId|GradeIdList])
    end;
handle_reward(Player, RoleName, RoleId, Type, SubType, [_|RewardCfgList], RewardList, GradeIdList) ->
    handle_reward(Player, RoleName, RoleId, Type, SubType, RewardCfgList, RewardList, GradeIdList).

%% -----------------------------------------------------------------
%% @desc 奖池计算(每个轮次至少要存在一个稀有奖品)
%% @param Type 活动大类
%% @param SubType 活动子类
%% @param Turn 轮次
%% @param GradeList 奖品记录
%% @return
%% -----------------------------------------------------------------
calc_pool(Type, SubType, Turn, GradeList) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F1 = fun(Grade, {Acc, Acc1}) ->
        #custom_act_reward_cfg{condition = Conditions} = GradeCfg =
        lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, Grade),
        {_, RareWeight} = ulists:keyfind(rare, 1, Conditions, {rare, 0}),
        {_, Count} = ulists:keyfind(Grade, 1, GradeList, {Grade, 0}),
        {_, NormalWeight, SpecialList} = ulists:keyfind(weight, 1, Conditions, {weight, 0, []}),
        {_NeedTurn, AddWeight} = ulists:keyfind(Turn, 1, SpecialList, {0, 0}),
        if
            RareWeight =/= 0 andalso Count == 0 ->
                NewAcc = [{NormalWeight+AddWeight, GradeCfg}|Acc],
                if
                    SpecialList =/= [] andalso AddWeight == 0 andalso NormalWeight == 0 ->
                        NewAcc1 = Acc1;
                    true ->
                        NewAcc1 = [{NormalWeight + AddWeight, GradeCfg}|Acc1]
                end;
            Count =/= 0 ->
                NewAcc = Acc,
                NewAcc1 = Acc1;
            true ->
                NewAcc = [{NormalWeight+AddWeight, GradeCfg}|Acc],
                NewAcc1 = Acc1
        end,
        {NewAcc, NewAcc1}
    end,
    lists:foldl(F1, {[], []}, GradeIdList).

%% 计算当前轮次保底出稀有奖励的抽奖次数
%% @param DrawTimes 已抽奖次数
%% @param ORareTimes 原保底次数
calc_rare_times(Type, SubType, Turn, DrawTimes, ORareTimes) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, RareTimesList} = ulists:keyfind(rare_times, 1, Conditions, {rare_times, []}),
    {_, MinTimes, MaxTimes} = ulists:keyfind(Turn, 1, RareTimesList, {Turn, 0, 0}),
    case DrawTimes+1 == MinTimes of
        true -> % 下次抽奖触发计算保底次数
            urand:list_rand(lists:seq(MinTimes, MaxTimes));
        false ->
            ORareTimes
    end.

cost_something(Player, Cost, Type, AutoBuy) ->
    ConsumeType = get_consume_type(Type),
    About = "",
    if
        Cost == [] ->
            {true, Player, Cost};
        AutoBuy == 1 orelse AutoBuy == 2 ->
            lib_goods_api:cost_objects_with_auto_buy(Player, Cost, ConsumeType, About);
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, ConsumeType, About) of
                {true, TmpNewPlayer} ->
                    {true, TmpNewPlayer, Cost};
                Other ->
                    Other
            end
    end.

get_act_cfg(Conditions, Times, DrawTimes, Turn) ->
    {_, Cost} = ulists:keyfind(cost, 1, Conditions, {cost, [{1,0,50}]}),
    {_, AddValue} = ulists:keyfind(add_value, 1, Conditions, {add_value, 10}),
    {_, LuckyValList} = ulists:keyfind(luckyvalue, 1, Conditions, {luckyvalue, []}),
    RealDrawTimes = calc_can_draw_times(Times, DrawTimes, Turn, AddValue, LuckyValList, 0),
    RealCost = calc_draw_cost(Cost, RealDrawTimes),
    {RealCost, AddValue, LuckyValList, RealDrawTimes}.

calc_draw_cost(Cost, Times) ->
    [{Type, GtypeId, Num*Times} || {Type, GtypeId, Num} <- Cost].

calc_can_draw_times(Times, DrawTimes, Turn, AddValue, LuckyValList, Acc) ->
    {_, MaxLuckyVal} = ulists:keyfind(Turn+1, 1, LuckyValList, {Turn, 0}),
    LuckyVal = (DrawTimes+Times)*AddValue,
    if
        MaxLuckyVal == 0 orelse LuckyVal =< MaxLuckyVal ->
            Times+Acc;
        true ->
            Tem = max((MaxLuckyVal - DrawTimes*AddValue) div AddValue, 0),
            calc_can_draw_times(Times - Tem, 0, Turn+1, AddValue, LuckyValList, Tem+Acc)
    end.


check_before(Type, SubType, RoleLv) ->
    IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
    IsLvEnougth = lib_custom_act_task:check_lv(RoleLv, Type, SubType),
    IsOpen == true andalso IsLvEnougth == true.

get_produce_type(?CUSTOM_ACT_TYPE_TREASURE_HUNT) -> custom_treasure;
get_produce_type(_) -> unkown.

get_consume_type(?CUSTOM_ACT_TYPE_TREASURE_HUNT) -> custom_treasure;
get_consume_type(_) -> unkown.

get_show_data_core(Type, SubType, RoleLv) ->
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Wlv = util:get_world_lv(),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}], RewardCfg) of
                    true ->
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
        end,
    lists:foldl(F, [], GradeIds).

gm_reset_bonus_treasure(Player, Type, SubType) ->
    clear_data(Player, Type, SubType).