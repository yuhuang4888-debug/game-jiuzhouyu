%%-----------------------------------------------------------------------------
%% @Module  :       mod_smashed_egg
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-03-01
%% @Description:    砸蛋
%%-----------------------------------------------------------------------------
-module(mod_smashed_egg).

-include("custom_act.hrl").
-include("smashed_egg.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("goods.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    send_act_info/3
    , refresh_egg/4
    , smashed_egg/8
    , receive_cumulate_reward/6
    , update_online_time/3
    , act_end/2
    , daily_clear/1
    , check_refresh_egg/3
    , check_smashed_egg/5
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = lib_smashed_egg:init(#act_state{}),
    {ok, State}.

send_act_info(Type, SubType, RoleArgs) ->
    gen_server:cast(?MODULE, {'send_act_info', Type, SubType, RoleArgs}).

refresh_egg(Type, SubType, RoleArgs, IsFree) ->
    gen_server:cast(?MODULE, {'refresh_egg', Type, SubType, RoleArgs, IsFree}).

smashed_egg(Type, SubType, RoleArgs, SmashedType, Index, AutoBuy, RealCostList, IsFree) ->
    gen_server:cast(?MODULE, {'smashed_egg', Type, SubType, RoleArgs, SmashedType, Index, AutoBuy, RealCostList, IsFree}).

receive_cumulate_reward(Type, SubType, RoleArgs, WorldLv, RewardCfg, RewardL) ->
    gen_server:cast(?MODULE, {'receive_cumulate_reward', Type, SubType, RoleArgs, WorldLv, RewardCfg, RewardL}).

%% 玩家每次下线的时候会更新累计的在线时间
update_online_time(RoleId, OnlineFlag, LastLoginTime) ->
    case OnlineFlag of
        ?ONLINE_ON ->
            gen_server:cast(?MODULE, {'update_online_time', RoleId, LastLoginTime});
        _ -> skip
    end.

act_end(EndType, ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', EndType, ActInfo}).

daily_clear(ActInfo) ->
    gen_server:cast(?MODULE, {'daily_clear', ActInfo}).

%% 检查刷新金蛋
check_refresh_egg(Type, SubType, RoleArgs) ->
    gen_server:call(?MODULE, {'check_refresh_egg', Type, SubType, RoleArgs}).

%% 检查砸金蛋
check_smashed_egg(Type, SubType, RoleArgs, SmashedType, Index) ->
    gen_server:call(?MODULE, {'check_smashed_egg', Type, SubType, RoleArgs, SmashedType, Index}).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 获取活动界面信息
do_handle_cast({'send_act_info', Type, SubType, RoleArgs}, State) ->
    [RoleId, _RoleName, RoleLv, _RoleSex, _RoleCareer, _RegTime] = RoleArgs,
    NowTime = utime:unixtime(),
    case lib_smashed_egg:check_act(Type, SubType, RoleLv, NowTime) of
        {true, #act_info{wlv = WorldLv} = ActInfo, _ConditionArgs} ->
            #act_state{role_map = RoleMap, record_map = RecordMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            RoleInfo = lib_smashed_egg:get_act_role_info(ActInfo, RoleInfoL, RoleArgs),
            #role_info{
                eggs = EggsList,
                smashed_start = SmashedStart,
                refresh_times = RefreshTimes,
                free_smashed_times = FreeSmashedTimes,
                smashed_times = SmashedTimes,
                cumulate_reward = CumulateReward,
                show_ids = ShowIds
            } = RoleInfo,
            RecordList = maps:get({Type, SubType}, RecordMap, []),
            PackShowL = lib_smashed_egg:pack_show_list(ShowIds),
            PackEggsL = lib_smashed_egg:pack_eggs_list(EggsList),
            PackRecordL = lib_smashed_egg:pack_record_list(RecordList),
            PackCumulateRewardL = lib_smashed_egg:pack_cumulate_reward_list(Type, SubType, RoleArgs, WorldLv, SmashedTimes, CumulateReward),
            %?PRINT("PackEggsL ~p~n", [PackEggsL]),
            %?PRINT("base info start:~p, free_times:~p, all_times:~p, refresh_times:~p ~n", 
            %    [utime:unixtime_to_localtime(SmashedStart), FreeSmashedTimes, SmashedTimes, RefreshTimes]),
            {ok, BinData} = pt_331:write(33120, [Type, SubType, SmashedStart, FreeSmashedTimes, SmashedTimes, RefreshTimes, PackShowL, PackEggsL, PackRecordL, PackCumulateRewardL]),
            lib_server_send:send_to_uid(RoleId, BinData),
            NewRoleInfoL = [RoleInfo|lists:keydelete({Type, SubType}, #role_info.key, RoleInfoL)],
            NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
            NewState = State#act_state{role_map = NewRoleMap};
        {false, ErrCode} ->
            %?PRINT("ErrCode ~p~n", [ErrCode]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]),
            NewState = State;
        _ ->
            NewState = State
    end,
    {ok, NewState};

%% 刷新金蛋
do_handle_cast({'refresh_egg', Type, SubType, RoleArgs, IsFree}, State) ->
    NowTime = utime:unixtime(),
    [RoleId, _RoleName, Lv, _Sex, _Career, _RegTime] = RoleArgs,
    case lib_smashed_egg:check_act(Type, SubType, Lv, NowTime) of
        {true, #act_info{}=ActInfo, _ConditionArgs} ->
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            RoleInfo = lib_smashed_egg:get_act_role_info(ActInfo, RoleInfoL, RoleArgs),
            #role_info{
                refresh_times = RefreshTimes
            } = RoleInfo,
            NewRefreshTimes = ?IF(IsFree == 1, RefreshTimes, RefreshTimes + 1),
            EggList = lib_smashed_egg:init_egg_list(Type, SubType),
            NewRoleInfo = RoleInfo#role_info{refresh_times = NewRefreshTimes, eggs = EggList, utime = NowTime},
            lib_smashed_egg:save_role_info(NewRoleInfo),
            lib_server_send:send_to_uid(RoleId, pt_331, 33121, [?SUCCESS, Type, SubType]),
            NewRoleInfoL = [NewRoleInfo|lists:keydelete({Type, SubType}, #role_info.key, RoleInfoL)],
            NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
            NewState = State#act_state{role_map = NewRoleMap};
        false ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_act_closed)]),
            NewState = State
    end,
    {_, LastState} = do_handle_cast({'send_act_info', Type, SubType, RoleArgs}, NewState),
    {ok, LastState};

%% 砸蛋
do_handle_cast({'smashed_egg', Type, SubType, RoleArgs, SmashedType, Index, AutoBuy, RealCostList, IsFree}, State) ->
    NowTime = utime:unixtime(),
    [RoleId, RoleName, _Lv, _Sex, _Career, _RegTime] = RoleArgs,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = WorldLv, etime = Etime}=ActInfo when NowTime < Etime ->
            #act_state{role_map = RoleMap, record_map = RecordMap} = State,
            _RecordL = maps:get({Type, SubType}, RecordMap, []),
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            RoleInfo = lib_smashed_egg:get_act_role_info(ActInfo, RoleInfoL, RoleArgs),
            {NewRoleInfo, _AddRecordList, RewardL, SmashedResultL, TVList} = 
                lib_smashed_egg:smashed_egg(Type, SubType, RoleInfo, RoleArgs, WorldLv, Index, IsFree),
            %?PRINT("smashed_egg SmashedResultL ~p~n", [SmashedResultL]),
            lib_smashed_egg:save_role_info(NewRoleInfo),
            NewRoleInfoL = [NewRoleInfo|lists:keydelete({Type, SubType}, #role_info.key, RoleInfoL)],
            NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
            NewRecordL = [],%lists:sublist(AddRecordList++RecordL, ?RECORD_LEN),
            NewRecordMap = maps:put({Type, SubType}, NewRecordL, RecordMap),
            lib_server_send:send_to_uid(RoleId, pt_331, 33122, [?SUCCESS, Type, SubType, NewRoleInfo#role_info.free_smashed_times, NewRoleInfo#role_info.smashed_times, SmashedResultL]),
            %% 日志
            lib_log_api:log_smashed_egg(RoleId, SmashedType, NewRoleInfo#role_info.smashed_times - RoleInfo#role_info.smashed_times, Index, IsFree, AutoBuy, RealCostList, RewardL),
            ta_agent_fire:log_smashed_egg(RoleId, [SmashedType, NewRoleInfo#role_info.smashed_times - RoleInfo#role_info.smashed_times, Index, IsFree, AutoBuy]),
            [
                lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, R) || {GradeId, R} <- TVList
            ],
            %% 发传闻
            lib_smashed_egg:send_tv(TVList, Type, SubType, RoleId, RoleName),
            Produce = #produce{type = smashed_egg, title = utext:get(3310008), content = utext:get(204), show_tips = 1, reward = RewardL, remark = "smashed_egg"},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            % lib_goods_api:send_reward_by_id(RewardL, smashed_egg, 0, RoleId, 1),
            NewState = State#act_state{role_map = NewRoleMap, record_map = NewRecordMap};
        false ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33122, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, []]),
            NewState = State
    end,
    {ok, NewState};

%% 领取累计奖励
do_handle_cast({'receive_cumulate_reward', Type, SubType, RoleArgs, _WorldLv, RewardCfg, RewardL}, State) ->
    NowTime = utime:unixtime(),
    [RoleId|_] = RoleArgs,
    #custom_act_reward_cfg{grade = GradeId, condition = Conditions} = RewardCfg,
    case lists:keyfind(crazy_egg, 1, Conditions) of 
        {crazy_egg, total, Times} ->
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            case lists:keyfind({Type, SubType}, #role_info.key, RoleInfoL) of
                #role_info{
                    smashed_times = SmashedTimes,
                    cumulate_reward = CumulateRewardL
                } = RoleInfo when SmashedTimes >= Times ->
                    case lists:member(GradeId, CumulateRewardL) of
                        false ->
                            NewCumulateRewardL = [GradeId|CumulateRewardL],
                            NewRoleInfo = RoleInfo#role_info{
                                cumulate_reward = NewCumulateRewardL,
                                utime = NowTime
                            },
                            %?PRINT("cumulate_reward NewCumulateRewardL ~p~n", [{GradeId, NewCumulateRewardL, RewardL}]),
                            lib_smashed_egg:save_role_info(NewRoleInfo),
                            %% 奖励领取日志
                            lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardL),
                            NewRoleInfoL = [NewRoleInfo|lists:keydelete({Type, SubType}, #role_info.key, RoleInfoL)],
                            NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
                            %PackCumulateRewardL = lib_smashed_egg:pack_cumulate_reward_list(Type, SubType, RoleArgs, WorldLv, SmashedTimes, NewCumulateRewardL),
                            lib_server_send:send_to_uid(RoleId, pt_331, 33123, [?SUCCESS, Type, SubType, [{GradeId, Times, RewardL, 2}]]),
                            Produce = #produce{type = smashed_egg_cumulate_reward, show_tips = 1, reward = RewardL, remark = lists:concat(["smashed_egg_", Times])},
                            lib_goods_api:send_reward_by_id(Produce, RoleId),
                            NewState = State#act_state{role_map = NewRoleMap};
                        _ ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_already_get_reward)]),
                            NewState = State
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_act_can_not_get)]),
                    NewState = State
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?MISSING_CONFIG]),
            NewState = State
    end,
    {ok, NewState};

% do_handle_cast({'update_online_time', RoleId, LastLoginTime}, State) ->
%     OpenActInfoL = lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_SMASHED_EGG),
%     NowTime = utime:unixtime(),
%     F = fun(T, TmpState) ->
%         case T of
%             #act_info{key = {Type, SubType}, wlv = WorldLv, stime = Stime, etime = _Etime} ->
%                 #act_state{role_map = RoleMap} = State,
%                 RoleInfoL = maps:get(RoleId, RoleMap, []),
%                 case lists:keyfind({Type, SubType}, #role_info.key, RoleInfoL) of
%                     #role_info{
%                         online_time = OnlineTime,
%                         lfree_smashed_time = LastFreeSmashedTime
%                     } = RoleInfo ->
%                         NeedUpdate = true,
%                         RealOnlineTime = max(0, OnlineTime + NowTime - max(max(Stime, LastLoginTime), LastFreeSmashedTime));
%                     _ ->
%                         NeedUpdate = false,
%                         RoleInfo = lib_smashed_egg:make_role_info(Type, SubType, RoleId, WorldLv, NowTime),
%                         RealOnlineTime = max(0, NowTime - max(Stime, LastLoginTime))
%                 end,
%                 NewRoleInfo = RoleInfo#role_info{
%                     online_time = RealOnlineTime,
%                     utime = NowTime
%                 },
%                 case NeedUpdate of
%                     true ->
%                         lib_smashed_egg:save_role_info(NewRoleInfo);
%                     _ -> skip
%                 end,
%                 NewRoleInfoL = [NewRoleInfo|lists:keydelete({Type, SubType}, #role_info.key, RoleInfoL)],
%                 NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
%                 State#act_state{role_map = NewRoleMap};
%             _ -> TmpState
%         end
%     end,
%     NewState = lists:foldl(F, State, OpenActInfoL),
%     {ok, NewState};

do_handle_cast({'act_end', EndType, #act_info{key = {Type, SubType}} = ActInfo}, State) ->
    db:execute(io_lib:format(?sql_delete_smashed_egg, [SubType])),
    #act_state{role_map = RoleMap, record_map = RecordMap} = State,
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
    NewRecordMap = maps:remove({Type, SubType}, RecordMap),
    NewState = State#act_state{role_map = NewRoleMap, record_map = NewRecordMap},
    {ok, NewState};

do_handle_cast({'daily_clear', ActInfo}, State) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, clear_count_type) of 
        {clear_count_type, all} ->
            NowTime = utime:unixtime(),
            SmashedStart = utime:unixdate(NowTime),
            db:execute(io_lib:format(?sql_reset_smashed_egg, [SmashedStart, util:term_to_string([]), util:term_to_string([]), util:term_to_string([]), NowTime, SubType])),
            #act_state{role_map = RoleMap} = State,
            spawn(fun() ->
                timer:sleep(2 * 1000),
                lib_smashed_egg:auto_send_unreceive_reward(maps:to_list(RoleMap), [ActInfo])
            end),
            F1 = fun(RoleInfo) ->
                case RoleInfo#role_info.key of 
                    {?CUSTOM_ACT_TYPE_SMASHED_EGG, SubType} ->
                        RoleInfo#role_info{
                            smashed_start = SmashedStart,
                            refresh_times = 0,
                            free_smashed_times = 0,
                            smashed_times = 0,
                            eggs = [],
                            cumulate_reward = [],
                            gain_list = [],
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
            NewState = State#act_state{role_map = NewRoleMap},
            {ok, NewState};
        {clear_count_type, free_times} ->
            NowTime = utime:unixtime(),
            SmashedStart = utime:unixdate(NowTime),
            db:execute(io_lib:format(<<"update player_smashed_egg set smashed_start = ~p, free_smashed_times = 0 where subtype = ~p">>, [SmashedStart, SubType])),
            #act_state{role_map = RoleMap} = State,
            F1 = fun(RoleInfo) ->
                case RoleInfo#role_info.key of 
                    {?CUSTOM_ACT_TYPE_SMASHED_EGG, SubType} ->
                        RoleInfo#role_info{
                            smashed_start = SmashedStart,
                            free_smashed_times = 0
                        };
                    _ ->
                        RoleInfo
                end
            end,
            F = fun(_RoleId, RoleInfoL) ->
                lists:map(F1, RoleInfoL)
            end,
            NewRoleMap = maps:map(F, RoleMap),
            NewState = State#act_state{role_map = NewRoleMap},
            {ok, NewState};
        _ ->
            {ok, State}
    end;

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state)->
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

%% 检查刷新金蛋
do_handle_call({'check_refresh_egg', Type, SubType, RoleArgs}, State) ->
    NowTime = utime:unixtime(),
    [RoleId, _RoleName, Lv, _Sex, _Career, _RegTime] = RoleArgs,
    case lib_smashed_egg:check_act(Type, SubType, Lv, NowTime) of
        {true, ActInfo, _ConditionArgs} ->
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            RoleInfo = lib_smashed_egg:get_act_role_info(ActInfo, RoleInfoL, RoleArgs),
            #role_info{refresh_times = RefreshTimes, eggs = EggList} = RoleInfo,
            ExistNotSmashed = length([ 1 || #egg_info{status = Status} <- EggList, Status == ?NOT_SMASHED]) > 0,
            if
                ExistNotSmashed == false -> %% 不存在未开启的蛋，可以免费刷新
                    {ok, {ok, free}};
                true -> %% 要扣费刷新
                    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                        #custom_act_cfg{
                            condition = Condition
                        } ->
                            case lib_custom_act_check:check_act_condtion([refreshstart_gold, refreshincrease], Condition) of
                                [StartGold, IncreaseGold] ->
                                    Gold = StartGold + RefreshTimes*IncreaseGold,
                                    {ok, {ok, [{?TYPE_GOLD, 0, Gold}]}};
                                _ -> {ok, {false, ?ERRCODE(err_config)}}
                            end;
                        _ -> {ok, {false, ?ERRCODE(err_config)}}
                    end
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

%% 砸蛋检查
do_handle_call({'check_smashed_egg', Type, SubType, RoleArgs, SmashedType, Index}, State) ->
    NowTime = utime:unixtime(),
    [RoleId, _RoleName, Lv, _Sex, _Career, _RegTime] = RoleArgs,
    case lib_smashed_egg:check_act(Type, SubType, Lv, NowTime) of
        {true, ActInfo, [FreeTime, FreeTimes, FreeMax]} ->
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            RoleInfo = lib_smashed_egg:get_act_role_info(ActInfo, RoleInfoL, RoleArgs),
            #role_info{
                eggs = EggsL,
                smashed_start = SmashedStart,
                free_smashed_times = FreeSmashedTimes
            } = RoleInfo,
            case SmashedType of
                ?SMASHED_TYPE_ALL ->
                    F = fun(#egg_info{status = EggStatus}, AccNum) ->
                        case EggStatus of
                            ?NOT_SMASHED -> AccNum + 1;
                            _ -> AccNum
                        end
                    end,
                    SmashedEggNum = lists:foldl(F, 0, EggsL),
                    IsSmashed = ?IF(SmashedEggNum > 0, 0, 1);
                _ ->
                    IsSmashed = case lists:keyfind(Index, #egg_info.id, EggsL) of
                        #egg_info{status = ?HAS_SMASHED} -> 1;
                        _ -> 0
                    end,
                    SmashedEggNum = 1
            end,
            if
                IsSmashed == 1 -> {ok, {false, ?ERRCODE(err331_egg_has_smashed)}};
                SmashedType =/= ?SMASHED_TYPE_ALL -> %% 单个砸蛋
                    if
                        FreeSmashedTimes < FreeTimes -> {ok, {ok, free}};
                        true ->
                            NextFreeSmashedTime = SmashedStart + (FreeSmashedTimes+1-FreeTimes)*FreeTime,
                            case NowTime >= NextFreeSmashedTime andalso FreeSmashedTimes < FreeMax of 
                                true -> {ok, {ok, free}};
                                _ -> 
                                    Cost = lib_smashed_egg:get_smashed_egg_cost(Type, SubType),
                                    {ok, {ok, Cost}}
                            end
                    end;    
                true ->
                    Cost1 = lib_smashed_egg:get_smashed_egg_cost(Type, SubType),
                    Cost = [ {GType, GId, GNum*SmashedEggNum} || {GType, GId, GNum} <- Cost1],
                    {ok, {ok, Cost}}
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
