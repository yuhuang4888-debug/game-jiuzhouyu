%%-----------------------------------------------------------------------------
%% @Module  :       mod_luckey_egg
%% @Author  :       
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-01
%% @Description:    
%%-----------------------------------------------------------------------------
-module(mod_luckey_egg).

-include("custom_act.hrl").
-include("smashed_egg.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("figure.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    send_act_info/2
    , send_act_luckey_info/2
    , receive_cumulate_reward/4
    , act_start/1
    , act_end/2
    , smashed_egg/6
    , daily_clear/1
    , check_smashed_egg/3
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = do_init(#luckey_state{}),
    %?PRINT("luckey init ~p~n", [State]),
    {ok, State}.

act_start(ActInfo) ->
    gen_server:cast(?MODULE, {'act_start', ActInfo}).

act_end(EndType, ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', EndType, ActInfo}).

send_act_info(ActInfo, RoleArgs) ->
    gen_server:cast(?MODULE, {'send_act_info', ActInfo, RoleArgs}).

send_act_luckey_info(ActInfo, RoleArgs) ->
    gen_server:cast(?MODULE, {'send_act_luckey_info', ActInfo, RoleArgs}).

check_smashed_egg(ActInfo, RoleArgs, Index) ->
    gen_server:call(?MODULE, {'check_smashed_egg', ActInfo, RoleArgs, Index}).

smashed_egg(ActInfo, RoleArgs, Index, AutoBuy, CostList, IsFree) ->
    gen_server:cast(?MODULE, {'smashed_egg', ActInfo, RoleArgs, Index, AutoBuy, CostList, IsFree}).

receive_cumulate_reward(ActInfo, RoleArgs, RewardCfg, RewardL) ->
    gen_server:cast(?MODULE, {'receive_cumulate_reward', ActInfo, RoleArgs, RewardCfg, RewardL}).

daily_clear(ActInfo) ->
    gen_server:cast(?MODULE, {'daily_clear', ActInfo}).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, luckey_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 获取活动界面信息
do_handle_cast({'act_start', ActInfo}, State) ->
    #luckey_state{luckey_map = LuckeyMap} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    case maps:get({Type, SubType}, LuckeyMap, 0) of 
        0 ->
            LuckeyInfo = get_act_luckey_info(ActInfo, LuckeyMap),
            NewLuckeyMap = update_act_luckey_info(LuckeyInfo, LuckeyMap),
            {ok, State#luckey_state{luckey_map = NewLuckeyMap}};
        _ ->
            {ok, State}
    end;

do_handle_cast({'act_end', EndType, #act_info{key = {Type, SubType}} = ActInfo}, State) ->
    db:execute(io_lib:format(?sql_delete_luckey_egg, [Type, SubType])),
    db:execute(io_lib:format(?sql_delete_luckey_info, [Type, SubType])),
    mod_custom_act_record:cast({remove_log, Type, SubType}),
    #luckey_state{role_map = RoleMap, luckey_map = LuckeyMap} = State,
    if  
        EndType == ?CUSTOM_ACT_STATUS_CLOSE orelse EndType == ?CUSTOM_ACT_STATUS_MANUAL_CLOSE ->
            spawn(fun() ->
                timer:sleep(2 * 1000),
                lib_smashed_egg:auto_send_unreceive_reward(maps:to_list(RoleMap), [ActInfo])
            end);
        true -> skip
    end,
    F = fun(_Key, RoleInfoL) ->
        [T|| T <- RoleInfoL, T#role_info.key =/= {Type, SubType}]
    end,
    NewRoleMap = maps:map(F, RoleMap),
    NewLuckeyMap = maps:remove({Type, SubType}, LuckeyMap),
    NewState = State#luckey_state{role_map = NewRoleMap, luckey_map = NewLuckeyMap},
    {ok, NewState}; 

%% 获取活动界面信息
do_handle_cast({'send_act_info', ActInfo, RoleArgs}, State) ->
    #luckey_state{role_map = RoleMap, luckey_map = _LuckeyMap} = State,
    [RoleId|_] = RoleArgs,
    #act_info{key = {Type, SubType}} = ActInfo,
    {RoleInfo, NewRoleMap} = get_act_role_info(ActInfo, RoleArgs, RoleMap),
    %LuckeyInfo = get_act_luckey_info(ActInfo, LuckeyMap),
    #luckey_role{
        free_times_use = FreeTimesUse,
        total_times_use = TotalTimesUse,
        cumulate_reward = CumulateReward
    } = RoleInfo,
    %ShowLuckeyVal = get_luckey_show_info(LuckeyInfo),
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, FreeTimes} = ulists:keyfind(free_times, 1, Conditions, {free_times, 3}),
    CumulateRewardState = get_cumulate_reward_state(ActInfo, RoleInfo, RoleArgs, CumulateReward),
    ConfigRewardList = get_config_reward_list(ActInfo),
    {ok, Bin} = pt_332:write(33205, [Type, SubType, max(0, FreeTimes-FreeTimesUse), TotalTimesUse, CumulateRewardState, ConfigRewardList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, State#luckey_state{role_map = NewRoleMap}};

%% 获取活动界面信息
do_handle_cast({'send_act_luckey_info', ActInfo, RoleArgs}, State) ->
    #luckey_state{luckey_map = LuckeyMap} = State,
    [RoleId|_] = RoleArgs,
    #act_info{key = {Type, SubType}} = ActInfo,
    LuckeyInfo = get_act_luckey_info(ActInfo, LuckeyMap),
    ShowLuckeyVal = get_luckey_show_info(LuckeyInfo),
    ?PRINT("send_act_luckey_info ~p~n", [ShowLuckeyVal]),
    {ok, Bin} = pt_332:write(33208, [Type, SubType, ShowLuckeyVal]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, State};

%% 获取活动界面信息
do_handle_cast({'smashed_egg', ActInfo, RoleArgs, Index, AutoBuy, CostList, IsFree}, State) ->
    #luckey_state{role_map = RoleMap, luckey_map = LuckeyMap} = State,
    [RoleId|_] = RoleArgs,
    #act_info{key = {Type, SubType}} = ActInfo,
    {RoleInfo, NewRoleMap} = get_act_role_info(ActInfo, RoleArgs, RoleMap),
    LuckeyInfo = get_act_luckey_info(ActInfo, LuckeyMap),
    {NewRoleInfo, NewLuckeyInfo, GradeList, RewardList} = smashed(RoleInfo, RoleArgs, LuckeyInfo, ActInfo, Index, IsFree),
    %% 日志
    lib_log_api:log_luckey_egg(RoleId, Type, SubType, NewRoleInfo#luckey_role.free_times_use, NewRoleInfo#luckey_role.total_times_use, Index, IsFree, AutoBuy, CostList, RewardList),
    [
        lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, R) || {GradeId, R} <- GradeList
    ],
    add_luckey_record(RoleArgs, ActInfo, GradeList),
    send_luckey_tv(RoleArgs, ActInfo, GradeList),
    Produce = #produce{type = luckey_egg, show_tips = 1, reward = RewardList},
    lib_goods_api:send_reward_by_id(Produce, RoleId),
    LastRoleMap = update_act_role_map(NewRoleInfo, NewRoleMap),
    LastLuckeyMap = update_act_luckey_info(NewLuckeyInfo, LuckeyMap),
    ShowLuckeyVal = get_luckey_show_info(NewLuckeyInfo),
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, FreeTimes} = ulists:keyfind(free_times, 1, Conditions, {free_times, 3}),
    lib_server_send:send_to_uid(
        RoleId, pt_332, 33206, 
        [?SUCCESS, Type, SubType, max(0, FreeTimes-NewRoleInfo#luckey_role.free_times_use), NewRoleInfo#luckey_role.total_times_use, ShowLuckeyVal, GradeList]
    ),
    {ok, State#luckey_state{role_map = LastRoleMap, luckey_map = LastLuckeyMap}};

%% 领取累计奖励
do_handle_cast({'receive_cumulate_reward', ActInfo, RoleArgs, RewardCfg, RewardL}, State) ->
    #luckey_state{role_map = RoleMap} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    [RoleId|_] = RoleArgs,
    #custom_act_reward_cfg{grade = GradeId, condition = Conditions} = RewardCfg,
    case lists:keyfind(total, 1, Conditions) of 
        {_, Times} ->
            {RoleInfo, NewRoleMap} = get_act_role_info(ActInfo, RoleArgs, RoleMap),
            #luckey_role{total_times_use = TotalTimesUse, cumulate_reward = CumulateReward} = RoleInfo,
            case TotalTimesUse < Times of 
                true ->
                    ErrCode = ?ERRCODE(err331_already_get_reward),
                    %CumulateRewardState = [],
                    RewardList = [],
                    NewState = State;
                _ ->
                    case lists:member(GradeId, CumulateReward) of 
                        true -> 
                            ErrCode = ?ERRCODE(err331_already_get_reward),
                            %CumulateRewardState = [],
                            RewardList = [],
                            NewState = State;
                        _ ->
                            ErrCode = ?SUCCESS,
                            NewCumulateReward = [GradeId|CumulateReward],
                            NewRoleInfo = RoleInfo#luckey_role{cumulate_reward = NewCumulateReward},
                            %CumulateRewardState = get_cumulate_reward_state(ActInfo, NewRoleInfo, RoleArgs, NewCumulateReward),  
                            RewardList = RewardL,
                            Produce = #produce{type = luckey_egg_cumulate_reward, show_tips = 1, reward = RewardList, remark = lists:concat(["luckey_egg_", Times])},
                            lib_goods_api:send_reward_by_id(Produce, RoleId),
                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList),
                            LastRoleMap = update_act_role_map(NewRoleInfo, NewRoleMap),
                            NewState = State#luckey_state{role_map = LastRoleMap}
                    end
            end;
        _ ->
            ErrCode = ?MISSING_CONFIG,
            %CumulateRewardState = [],
            RewardList = [],
            NewState = State
    end,
    lib_server_send:send_to_uid(RoleId, pt_332, 33207, [ErrCode, Type, SubType, GradeId, RewardList]),
    {ok, NewState};

do_handle_cast({'daily_clear', ActInfo}, State) ->
    #luckey_state{role_map = RoleMap} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    ?PRINT("daily_clear######### ~p~n", [start]),
    NowTime = utime:unixtime(),
    db:execute(io_lib:format(?sql_reset_luckey_egg, [util:term_to_string([]), NowTime, Type, SubType])),
    spawn(fun() ->
        timer:sleep(2 * 1000),
        auto_send_unreceive_reward(maps:to_list(RoleMap), [ActInfo])
    end),
    F1 = fun(RoleInfo) ->
        case RoleInfo#luckey_role.key of 
            {Type, SubType} ->
                RoleInfo#luckey_role{
                    free_times_use = 0,
                    total_times_use = 0,
                    cumulate_reward = [],
                    utime = NowTime
                };
            _ ->
                RoleInfo
        end
    end,
    F = fun(_RoleId, RoleInfoL) ->
        lists:map(F1, RoleInfoL)
    end,
    NewRoleMap = maps:map(F, RoleMap),
    NewState = State#luckey_state{role_map = NewRoleMap},
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, luckey_state)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.


do_handle_call({'check_smashed_egg', ActInfo, RoleArgs, Index}, State) ->
    #luckey_state{role_map = RoleMap} = State,
    #act_info{key = {Type, SubType}} = ActInfo,
    {RoleInfo, _NewRoleMap} = get_act_role_info(ActInfo, RoleArgs, RoleMap),
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, FreeTimes} = ulists:keyfind(free_times, 1, Conditions, {free_times, 3}),
    #luckey_role{
        free_times_use = FreeTimesUse,
        total_times_use = _TotalTimesUse
    } = RoleInfo,
    IsFree = ?IF(Index == 1 andalso FreeTimesUse < FreeTimes, true, false),
    case IsFree of 
        true -> 
            {ok, {ok, free}};
        _ ->
            Atom = ?IF(Index == 1, one_cost, ten_cost),
            {_, Cost} = ulists:keyfind(Atom, 1, Conditions, {Atom, []}),
            case Cost == [] of 
                true ->
                    {ok, {false, ?MISSING_CONFIG}};
                _ ->
                    {ok, {ok, Cost}}
            end
    end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


do_init(State) ->
    case db:get_all(?sql_select_luckey_egg) of 
        [] -> RoleMap = #{};
        List ->
            RoleMap = do_init_role(List, #{})
    end,
    case db:get_all(?sql_select_luckey_info) of 
        [] -> LuckeyMap = #{};
        List2 ->
            LuckeyMap = do_init_luckey_info(List2, #{})
    end,
    State#luckey_state{role_map = RoleMap, luckey_map = LuckeyMap}.

do_init_role([], RoleMap) -> RoleMap;
do_init_role([Val|List], RoleMap) ->
    [RoleId, Type, SubType, FreeTimesUse, TotalTimesUse, CumulateRewardB, SpTimesListB, UTime] = Val,
    RoleInfo = #luckey_role{
        key = {Type, SubType},              
        role_id = RoleId,                
        free_times_use = FreeTimesUse,
        total_times_use = TotalTimesUse,
        cumulate_reward = util:bitstring_to_term(CumulateRewardB),     
        sp_times_list = util:bitstring_to_term(SpTimesListB),     
        utime = UTime                 
    },
    RoleActList = maps:get(RoleId, RoleMap, []),
    do_init_role(List, maps:put(RoleId, [RoleInfo|RoleActList], RoleMap)).

do_init_luckey_info([], LuckeyMap) -> LuckeyMap;
do_init_luckey_info([Val|List], LuckeyMap) ->
    [Type, SubType, LuckeyVal, AddLuckeyTime, LastLuckeyVal, LastLuckeyTime] = Val,
    LuckeyInfo = #luckey_info{
        key = {Type, SubType},              
        luckey_val = LuckeyVal,                
        add_luckey_time = AddLuckeyTime,
        last_luckey_val = LastLuckeyVal,     
        last_luckey_time = LastLuckeyTime                 
    },
    do_init_luckey_info(List, maps:put({Type, SubType}, LuckeyInfo, LuckeyMap)).

%%------------------------------- 扭蛋
smashed(RoleInfo, RoleArgs, LuckeyInfo, ActInfo, SmashedTimes, IsFree) ->
    NowTime = utime:unixtime(),
    #act_info{key = {Type, SubType}} = ActInfo,
    LuckeyInfoAf = update_act_luckey_info_with_time(LuckeyInfo, NowTime),
    RareTimesGap = get_rare_times_gap(Type, SubType),
    F = fun(_I, {RoleInfo1, LuckeyInfo1, GradeList1, RewardList1}) ->
        {RoleInfo2, LuckeyInfo2, GradeId, Reward} = smashed_one(RoleInfo1, RoleArgs, LuckeyInfo1, ActInfo, NowTime, IsFree, RareTimesGap),
        {RoleInfo2, LuckeyInfo2, [{GradeId, Reward}|GradeList1], Reward ++ RewardList1}
    end,
    {NewRoleInfo, NewLuckeyInfo, GradeIdList, RewardList} = lists:foldl(F, {RoleInfo, LuckeyInfoAf, [], []}, lists:seq(1, SmashedTimes)),
    {NewRoleInfo, NewLuckeyInfo, GradeIdList, RewardList}.
    
smashed_one(RoleInfo, RoleArgs, LuckeyInfo, ActInfo, NowTime, IsFree, RareTimesGap) ->
    #act_info{key = {Type, SubType}, wlv = WLv} = ActInfo,
    [_RoleId, _RoleName, RoleLv, Sex, Career] = RoleArgs,
    #luckey_role{            
        free_times_use = FreeTimesUse,           
        total_times_use = TotalTimesUse,
        sp_times_list = SpTimesList        
    } = RoleInfo,
    RewardIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WLv, Career),
    NewTotalTimesUse = TotalTimesUse + 1,
    NewFreeTimesUse = ?IF(IsFree == 1, FreeTimesUse+1, FreeTimesUse),
    RareWeightAdd = get_rare_weight_add(Type, SubType, LuckeyInfo#luckey_info.luckey_val),
    {GradeId, RewardCfg} = smashed_one_core(Type, SubType, NewTotalTimesUse, RareWeightAdd, RareTimesGap, SpTimesList, RewardIdList),
    Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
    NewSpTimesList = update_sp_times_list(RewardCfg, RareTimesGap, SpTimesList),
    %?PRINT("smashed_one NewSpTimesList:~p~n", [NewSpTimesList]),
    case is_rare_reward(RewardCfg) of 
        true ->
            NewLuckeyInfo = reset_luckey_info(Type, SubType, NowTime, LuckeyInfo);
        _ -> 
            NewLuckeyInfo = LuckeyInfo#luckey_info{luckey_val = LuckeyInfo#luckey_info.luckey_val+1}
    end,
    NewRoleInfo = RoleInfo#luckey_role{
        free_times_use = NewFreeTimesUse, 
        total_times_use = NewTotalTimesUse,
        sp_times_list = NewSpTimesList,
        utime = NowTime
    },
    {NewRoleInfo, NewLuckeyInfo, GradeId, Reward}.

smashed_one_core(Type, SubType, TotalTimesUse, RareWeightAdd, RareTimesGap, SpTimesList, RewardIdList) ->
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                RareNo = get_rare_no(RewardCfg),
                CanRandReward = can_rank_reward_with_times(RareNo, SpTimesList, RareTimesGap),
                case CanRandReward of 
                    true ->
                        case lists:keyfind(luckey_egg, 1, Conditions) of 
                            {luckey_egg, Times1, Times2, Weight, WeightAdd} -> 
                                ExtraAddRatio = ?IF(RareNo == 1, 1 + (RareWeightAdd / 100), 1),
                                if
                                    TotalTimesUse >= Times2 -> [{round(Weight * ExtraAddRatio), GradeId}|Acc];
                                    true ->
                                        case TotalTimesUse >= Times1 of 
                                            true ->
                                                [{round((Weight+WeightAdd) * ExtraAddRatio), GradeId}|Acc];
                                            _ ->
                                                Acc
                                        end
                                end;
                            _ -> Acc
                        end;
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
    end,
    GradeWeightList = lists:foldl(F, [], RewardIdList),
    {_, FindGradeId} = util:find_ratio(GradeWeightList, 1),
    {FindGradeId, lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, FindGradeId)}.
%%------------------------------- 扭蛋 end

%% 抽取到珍惜奖励，重置幸运值信息
reset_luckey_info(Type, SubType, NowTime, LuckeyInfo) ->
    #luckey_info{
        luckey_val = LuckeyVal,
        add_luckey_time = _AddLuckeyTime,
        last_luckey_val = _LastLuckeyVal,
        last_luckey_time = LastLuckeyTime
    } = LuckeyInfo,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_AddLuckeyTimeGap, LuckeyMax} = get_act_luckey_increase_time(Type, SubType),
    {_, SHowTime} = ulists:keyfind(show_time, 1, Conditions, {show_time, 300}),
    case NowTime < LastLuckeyTime of 
        true -> %% 展示时间内，不更改幸运值的信息
            LuckeyInfo;
        _ ->
            #luckey_info{
                key = {Type, SubType},
                luckey_val = 0,
                add_luckey_time = NowTime,
                last_luckey_val = min(LuckeyVal, LuckeyMax),
                last_luckey_time = NowTime + SHowTime
            }
    end.

%% 获取活动的玩家信息
get_act_role_info(ActInfo, RoleArgs, RoleMap) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    [RoleId|_] = RoleArgs,
    case maps:get(RoleId, RoleMap, 0) of 
        0 -> 
            NeedCreate = true, NewRoleInfo = none, NewRoleMap = none;
        RoleActList ->
            case lists:keyfind({Type, SubType}, #luckey_role.key, RoleActList) of 
                false -> 
                    NeedCreate = true, NewRoleInfo = none, NewRoleMap = none;
                #luckey_role{} = RoleInfo ->
                    NeedCreate = false, NewRoleInfo = RoleInfo, NewRoleMap = RoleMap
            end
    end,
    case NeedCreate of 
        false ->
            {NewRoleInfo, NewRoleMap};
        _ ->
            LastRoleInfo = create_role_act_info(ActInfo, RoleArgs),
            ORoleActList = maps:get(RoleId, RoleMap, []),
            LastRoleMap = maps:put(RoleId, [LastRoleInfo|ORoleActList], RoleMap),
            {LastRoleInfo, LastRoleMap}
    end.

%% 更新活动的玩家信息
update_act_role_map(RoleInfo, RoleMap) ->
    #luckey_role{key = {Type, SubType}, role_id = RoleId} = RoleInfo,
    RoleActList = maps:get(RoleId, RoleMap, []),
    NewRoleActList = lists:keystore({Type, SubType}, #luckey_role.key, RoleActList, RoleInfo),
    db_replace_act_role(RoleInfo),
    maps:put(RoleId, NewRoleActList, RoleMap).

%% 获取活动的幸运值信息
get_act_luckey_info(ActInfo, LuckeyMap) ->
    #act_info{key = {Type, SubType}, stime = STime} = ActInfo,
    case maps:get({Type, SubType}, LuckeyMap, 0) of 
        #luckey_info{} = LuckeyInfo -> LuckeyInfo;
        _ ->
            NowTime = utime:unixtime(),
            {AddLuckeyTime, LuckeyMax} = get_act_luckey_increase_time(Type, SubType),
            LuckeyVal = min(max(0, (NowTime - STime) div AddLuckeyTime), LuckeyMax),
            #luckey_info{
                key = {Type, SubType},
                luckey_val = LuckeyVal,
                add_luckey_time = NowTime
            }
    end.

%% 更新活动的幸运值信息
update_act_luckey_info(LuckeyInfo, LuckeyMap) ->
    #luckey_info{key = {Type, SubType}} = LuckeyInfo,
    db_replace_act_luckey_info(LuckeyInfo),
    maps:put({Type, SubType}, LuckeyInfo, LuckeyMap).

%% 新建一个新的活动玩家信息
create_role_act_info(ActInfo, RoleArgs) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    [RoleId|_] = RoleArgs,
    %#custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    %{_, FreeTimes} = ulists:keyfind(free_times, 1, Conditions, {free_times, 3}),
    #luckey_role{
        key = {Type, SubType},
        role_id = RoleId
    }.

%% 根据当前时间，重新计算一下当前的幸运值
update_act_luckey_info_with_time(LuckeyInfo, NowTime) ->
    #luckey_info{key = {Type, Subtype}, luckey_val = LuckeyVal, add_luckey_time = AddLuckeyTime} = LuckeyInfo,
    {AddLuckeyTimeGap, LuckeyMax} = get_act_luckey_increase_time(Type, Subtype),
    NewLuckeyVal = min(LuckeyVal + (NowTime - AddLuckeyTime) div AddLuckeyTimeGap, LuckeyMax),
    LuckeyInfo#luckey_info{luckey_val = NewLuckeyVal, add_luckey_time = NowTime}.

%% 获取玩家的累积奖励领取状态
get_cumulate_reward_state(ActInfo, RoleInfo, RoleArgs, CumulateReward) ->
    #act_info{key = {Type, SubType}, wlv = WorldLv} = ActInfo,
    #luckey_role{total_times_use = TotalTimesUse} = RoleInfo,
    [_RoleId, _RoleName, RoleLv, Sex, Career] = RoleArgs,
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WorldLv, Career),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                case lists:keyfind(total, 1, Conditions) of 
                    {total, Times} -> 
                        Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                        case lists:member(GradeId, CumulateReward) of 
                            true -> ReceiveStatus = 2;
                            _ ->
                                ReceiveStatus = ?IF(TotalTimesUse>=Times, 1, 0)
                        end,
                        [{GradeId, Times, Reward, ReceiveStatus}|Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    lists:foldl(F, [], AllIds).

get_config_reward_list(ActInfo) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name, desc = Desc, condition = Conditions, format = Format, reward = Reward
            } ->
                case lists:keyfind(is_rare, 1, Conditions) of
                    {_, _} ->
                        ConditionStr = util:term_to_string(Conditions),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, 0, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ ->
                        Acc
                end;
            _ ->
                Acc
        end
    end,
    PackList = lists:foldl(F, [], AllIds),
    PackList.

%% 获取珍惜次数间隔
get_rare_times_gap(Type, SubType) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, GapList} = ulists:keyfind(rare_gap, 1, Conditions, {rare_gap, []}),
    GapList.

%% 获取展示幸运值
get_luckey_show_info(LuckeyInfo) ->
    #luckey_info{
        key = {Type, Subtype},
        luckey_val = LuckeyVal, add_luckey_time = AddLuckeyTime, 
        last_luckey_val = LastLuckeyVal, last_luckey_time = LastLuckeyTime
    } = LuckeyInfo,
    NowTime = utime:unixtime(),
    {AddLuckeyTimeGap, LuckeyMax} = get_act_luckey_increase_time(Type, Subtype),
    case NowTime < LastLuckeyTime of 
        true -> LastLuckeyVal;
        _ ->
           min(LuckeyVal +  max(0, (NowTime - AddLuckeyTime) div AddLuckeyTimeGap), LuckeyMax)
    end.

%% 获取幸运值加成比
get_rare_weight_add(Type, SubType, LuckeyVal) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_AddLuckeyTimeGap, LuckeyMax} = get_act_luckey_increase_time(Type, SubType),
    NewLuckeyVal = min(LuckeyVal, LuckeyMax),
    {_, LuckeyRation} = ulists:keyfind(luckey_ratio, 1, Conditions, {luckey_ratio, [{1, 1000, 100}]}),
    Pred = fun({Num1, Num2, _Ratio}) -> ?IF(NewLuckeyVal >= Num1 andalso NewLuckeyVal =< Num2, true, false) end,
    case ulists:find(Pred, LuckeyRation) of 
        {ok, {_, _, Ration}} ->
            Ration;
        _ -> 
            100
    end.

%% 添加抽奖记录
add_luckey_record(RoleArgs, ActInfo, GradeList) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    [RoleId, RoleName|_] = RoleArgs,
    F = fun({GradeId, Reward}, List) ->
        RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        RareNo = get_rare_no(RewardCfg),
        ?IF(RareNo > 0, Reward++List, List)
    end,
    RecordGoods = lists:foldl(F, [], GradeList),
    length(RecordGoods) > 0 andalso mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, RecordGoods}).

%% 发送传闻
send_luckey_tv(RoleArgs, ActInfo, GradeList) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    [RoleId, RoleName|_] = RoleArgs,
    F = fun({GradeId, Reward}) ->
        #custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:keyfind(tv, 1, Conditions) of 
            {tv, {Mod, TvId}} ->
                F1 = fun({GType, GTypeId, _Num}) ->
                    GType == ?TYPE_GOODS andalso 
                        lib_chat:send_TV({all}, Mod, TvId, [RoleName, RoleId, GTypeId, Type, SubType])
                end,
                lists:foreach(F1, Reward);
            _ ->
                skip
        end
    end,
    lists:foreach(F, GradeList).

%% 获取活动配置的幸运值增加时间间隔
get_act_luckey_increase_time(Type, SubType) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, LuckeyTime} = ulists:keyfind(luckey_increase, 1, Conditions, {luckey_increase, 60}),
    {_, LuckeyMax} = ulists:keyfind(luckey_max, 1, Conditions, {luckey_max, 500}),
    {LuckeyTime, LuckeyMax}.

%% 未领取的奖励自动领取
auto_send_unreceive_reward([], _) -> skip;
auto_send_unreceive_reward([{RoleId, RoleInfoL}|L], ActInfoL) ->
    F = fun(T, Acc) ->
        case T of
            #luckey_role{key = Key, role_id = RoleId, total_times_use = TotalTimesUse, cumulate_reward = CumulateRewardL} ->
                case lists:keyfind(Key, #act_info.key, ActInfoL) of
                    #act_info{key = {Type, SubType}, wlv = WorldLv} ->
                        #figure{career = Career, sex = Sex, lv = RoleLv} = lib_role:get_role_figure(RoleId),
                        RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WorldLv, Career),
                        RewardL = filter_unreceive_reward(Type, SubType, RewardParam, TotalTimesUse, CumulateRewardL),
                        RewardL ++ Acc;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    AllRewardL = lists:foldl(F, [], RoleInfoL),
    %?PRINT("auto_send_unreceive_reward ~p~n", [{RoleId, AllRewardL}]),
    case AllRewardL =/= [] of
        true ->
            LastAllRewardL = ulists:object_list_plus(AllRewardL),
            lib_mail_api:send_sys_mail([RoleId], utext:get(3310055), utext:get(3310007), LastAllRewardL),
            timer:sleep(100);
        false -> skip
    end,
    auto_send_unreceive_reward(L, ActInfoL).

filter_unreceive_reward(Type, SubType, RewardParam, TotalTimesUse, CumulateRewardL) ->
    AllIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
            #custom_act_reward_cfg{condition = Conditions} = RewardCfg -> 
                case lists:keyfind(total, 1, Conditions) of 
                    {total, Times} -> 
                        case lists:member(GradeId, CumulateRewardL) of 
                            true -> Acc;
                            _ ->
                                Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                                ?IF(TotalTimesUse>=Times, [Reward|Acc], Acc)
                        end;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    lists:foldl(F, [], AllIds).

%% 是否是珍惜奖励
is_rare_reward(RewardCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg,
    {_, IsRare} = ulists:keyfind(is_rare, 1, Conditions, {is_rare, 0}),
    IsRare == 1.

get_rare_no(RewardCfg) ->
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg,
    {_, IsRare} = ulists:keyfind(is_rare, 1, Conditions, {is_rare, 0}),
    IsRare.

%% 判断次数间隔是否满足
can_rank_reward_with_times(RareNo, SpTimesList, RareTimesGap) ->
    case lists:keyfind(RareNo, 1, RareTimesGap) of 
        false -> true;
        {RareNo, TimesGap} ->
            case lists:keyfind(RareNo, 1, SpTimesList) of 
                false -> true;
                {RareNo, CdTimes} ->
                    CdTimes >= TimesGap
            end
    end.

%% 更新间隔次数信息
update_sp_times_list(RewardCfg, RareTimesGap, SpTimesList) ->
    RareNo = get_rare_no(RewardCfg),
    case lists:keyfind(RareNo, 1, RareTimesGap) of 
        false -> %% 没有间隔次数限制，其他次数+1
            [{RareNo1, CdTimes+1} || {RareNo1, CdTimes} <- SpTimesList];
        _ ->
            SpTimesList1 = lists:keystore(RareNo, 1, SpTimesList, {RareNo, 0}), %% 对应次数置0
            [begin 
                case RareNo1 == RareNo of 
                    true -> {RareNo1, CdTimes};
                    _ -> {RareNo1, CdTimes+1}
                end
            end
            ||{RareNo1, CdTimes} <- SpTimesList1] %% 其他次数+1
    end.

%%-------------------- db
db_replace_act_role(RoleInfo) ->
    #luckey_role{
        key = {Type, Subtype},
        role_id = RoleId, 
        free_times_use = FreeTimesUse,
        total_times_use = TotalTimesUse,
        cumulate_reward = CumulateReward, 
        sp_times_list = SpTimesList,
        utime = UTime
    } = RoleInfo,
    Sql = io_lib:format(?sql_replace_luckey_egg, [RoleId, Type, Subtype, FreeTimesUse, TotalTimesUse, util:term_to_string(CumulateReward), util:term_to_string(SpTimesList), UTime]),
    db:execute(Sql).

db_replace_act_luckey_info(LuckeyInfo) ->
    #luckey_info{
        key = {Type, Subtype},
        luckey_val = LuckeyVal,
        add_luckey_time = AddLuckeyTime,
        last_luckey_val = LastLuckeyVal,
        last_luckey_time = LastLuckeyTime
    } = LuckeyInfo,
    Sql = io_lib:format(?sql_replace_luckey_info, [Type, Subtype, LuckeyVal, AddLuckeyTime, LastLuckeyVal, LastLuckeyTime]),
    db:execute(Sql).



