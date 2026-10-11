% %% ---------------------------------------------------------------------------
% %% @doc mod_kf_cloud_buy
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_kf_cloud_buy).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("kf_cloud_buy.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("clusters.hrl").
%%-----------------------------

send_cld_act_info(Args) ->
    gen_server:cast(?MODULE, {send_cld_act_info, Args}).

send_cld_act_tv_records(Args) ->
    gen_server:cast(?MODULE, {send_cld_act_tv_records, Args}).

send_cld_act_big_records(Args) ->
    gen_server:cast(?MODULE, {send_cld_act_big_records, Args}).

get_stage_reward(Args) ->
    gen_server:cast(?MODULE, {get_stage_reward, Args}).

timer_check() ->
    gen_server:cast(?MODULE, {timer_check}).

% check_draw_rewards(Args) ->
%     gen_server:call(?MODULE, {check_draw_rewards, Args}).

draw_rewards(Args) ->
    gen_server:call(?MODULE, {draw_rewards, Args}).

gm_reset_act(Type, SubType) ->
    gen_server:cast(?MODULE, {gm_reset_act, Type, SubType}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
% do_handle_call({check_draw_rewards, Args}, _From, State) ->
%     #kf_cld_buy_state{act_list = ActList} = State,
%     [Type, SubType, Times, RoleId, _Name, ServerId, _ServerNum] = Args,
%     NowTime = utime:unixtime(),
%     case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
%         #cld_buy_act{buy_endtime = BuyEndTime, role_map = RoleMap} = CldBuyAct when NowTime < BuyEndTime -> 
%             {CldZone, NewCldBuyAct, NewActList} = get_cld_zone(Type, SubType, RoleId, ServerId, CldBuyAct, ActList, RoleMap),
%             NewState = State#kf_cld_buy_state{act_list = NewActList},
%             GradeId = get_current_grade_id(NowTime, CldZone, NewCldBuyAct), 
%             case check_draw_count(RoleId, CldZone, RoleMap, GradeId, Times, NowTime) of 
%                 {ok, SelfCount} ->
%                     Reply = {ok, GradeId, SelfCount};
%                 {false, Res} ->
%                     Reply = {false, Res}
%             end;
%         #cld_buy_act{} ->
%             NewState = State,
%             Reply = {false, ?ERRCODE(err512_end_buy)};
%         _ ->
%             NewState = State,
%             Reply = {false, ?ERRCODE(err512_act_close)}
%     end,
%     {reply, Reply, NewState};

do_handle_call({draw_rewards, Args}, _From, State) ->
    #kf_cld_buy_state{act_list = ActList} = State,
    [Type, SubType, Times, RoleId, Name, ServerId, ServerNum, InRestriction, VipCountLimit, MoneyArgs] = Args,
    NowTime = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{buy_endtime = BuyEndTime, role_map = RoleMap} = CldBuyAct when NowTime < BuyEndTime -> 
            {CldZone, NewCldBuyAct, NewActList} = get_cld_zone(Type, SubType, RoleId, ServerId, CldBuyAct, ActList, RoleMap),
            #cld_zone{zone_id = ZoneId, wlv = Wlv, big_rewards = BigRewards, tv_records = TvRecords} = CldZone,
            GradeId = get_current_grade_id(NowTime, CldZone, NewCldBuyAct), 
            case check_draw_count(RoleId, CldZone, RoleMap, GradeId, Times, NowTime) of 
                {ok, SelfCount} when InRestriction == true andalso (SelfCount+Times) > VipCountLimit ->
                    NewState = State,
                    Reply = {false, ?ERRCODE(err512_no_times_in_restriction)};
                {ok, SelfCount} ->
                    case lib_kf_cloud_buy:check_grade_cost(MoneyArgs, GradeId, Times) of 
                        {ok, CostList} ->
                            case maps:get(RoleId, RoleMap, 0) of 
                                #cld_buy_role{} = CldBuyRole -> skip;
                                _ ->
                                    StageRewards = create_new_stage_rewards(Type, Wlv),
                                    CldBuyRole = lib_kf_cloud_buy:make(cld_buy_role, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, [], 0, StageRewards]),
                                    lib_kf_cloud_buy:db_replace_cld_buy_role(CldBuyRole)
                            end,
                            %% 更新玩家信息
                            #cld_buy_role{big_rewards_count = OldBigRewardsCount, total_count = OldSelfTotalCount} = CldBuyRole,
                            NewSelfCount = SelfCount + Times,
                            NewSelfTotalCount = OldSelfTotalCount + Times,
                            NewBigRewardsCount = lists:keystore(GradeId, 1, OldBigRewardsCount, {GradeId, NewSelfCount}),
                            NewCldBuyRole = CldBuyRole#cld_buy_role{big_rewards_count = NewBigRewardsCount, total_count = NewSelfTotalCount},
                            NewRoleMap = maps:put(RoleId, NewCldBuyRole, RoleMap),
                            %% 更新活动信息
                            %% 如果购买次数已用完，进行抽奖
                            {_, GradeSt, GradeCount} = lists:keyfind(GradeId, 1, BigRewards),
                            NewGradeCount = GradeCount+Times,
                            MaxCount = lib_kf_cloud_buy:get_grade_max_count(GradeId),
                            case NewGradeCount >= MaxCount of 
                                true -> %% 一秒后进行大奖抽奖
                                    util:send_after([], 1000, self(), {draw_big_reward, Type, SubType, ZoneId, GradeId});
                                _ ->
                                    skip
                            end,
                            NewBigRewards = lists:keyreplace(GradeId, 1, BigRewards, {GradeId, GradeSt, NewGradeCount}),
                            %% 记录tv_records
                            RewardResult = lib_kf_cloud_buy:get_grade_reward(GradeId, SelfCount, Times),
                            RewardList = lists:flatten([Rewards ||{_, Rewards} <- RewardResult]),
                            NewTvRecords = update_tv_records(RewardResult, Type, SubType, RoleId, Name, ServerId, ServerNum, ZoneId, NowTime, TvRecords),
                            NewCldZone = CldZone#cld_zone{big_rewards = NewBigRewards, tv_records = NewTvRecords},
                            lib_kf_cloud_buy:db_update_cld_buy_role_big_rewards(RoleId, Type, SubType, NewBigRewardsCount, NewSelfTotalCount),
                            lib_kf_cloud_buy:db_update_cld_zone_big_rewards(ZoneId, Type, SubType, NewBigRewards),
                            lib_log_api:log_kf_cloud_buy_reward(RoleId, ServerId, Name, Type, SubType, GradeId, Times, NewSelfCount, NewGradeCount, RewardList),
                            NewZoneList = lists:keystore(ZoneId, #cld_zone.zone_id, NewCldBuyAct#cld_buy_act.zone_list, NewCldZone),
                            LastCldBuyAct = NewCldBuyAct#cld_buy_act{zone_list = NewZoneList, role_map = NewRoleMap},
                            LastActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, NewActList, LastCldBuyAct),
                            NewState = State#kf_cld_buy_state{act_list = LastActList},
                            %% 广播大奖最新数量
                            {ok, Bin} = pt_512:write(51209, [Type, SubType, GradeId, NewGradeCount]),
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_server_send, send_to_all, [Bin]),
                            Reply = {ok, GradeId, NewGradeCount, NewSelfCount, NewSelfTotalCount, RewardList, CostList};
                        {false, Res} ->
                            NewState = State,
                            Reply = {false, Res}
                    end;
                {false, Res} ->
                    NewState = State,
                    Reply = {false, Res}
            end;
        #cld_buy_act{} ->
            NewState = State,
            Reply = {false, ?ERRCODE(err512_end_buy)};
        _ ->
            NewState = State,
            Reply = {false, ?ERRCODE(err512_act_close)}
    end,
    {reply, Reply, NewState};


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({send_cld_act_info, [Type, SubType, RoleId, Sid, ServerId, Node]}, State) -> 
    #kf_cld_buy_state{act_list = ActList} = State,
    NowTime = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{role_map = RoleMap} = CldBuyAct ->
            {CldZone, NewCldBuyAct, NewActList} = get_cld_zone(Type, SubType, RoleId, ServerId, CldBuyAct, ActList, RoleMap),
            GradeId = get_current_grade_id(NowTime, CldZone, NewCldBuyAct),
            #cld_zone{big_rewards = BigRewards} = CldZone,
            {_, _GradeSt, GradeCount} = ulists:keyfind(GradeId, 1, BigRewards, {GradeId, 0, 0}),
            case maps:get(RoleId, RoleMap, 0) of 
                #cld_buy_role{big_rewards_count = BigRewardsCount, total_count = SelfTotalCount, stage_rewards = StageRewards} ->
                    {_, SelfCount} = ulists:keyfind(GradeId, 1, BigRewardsCount, {GradeId, 0});
                _ ->
                    SelfCount = 0,
                    SelfTotalCount = 0,
                    StageRewards = create_new_stage_rewards(Type, CldZone#cld_zone.wlv)
            end,
            {ok, Bin} = pt_512:write(51202, [?SUCCESS, Type, SubType, GradeId, GradeCount, SelfCount, SelfTotalCount, StageRewards]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            ?PRINT("send_cld_act_info GradeId : ~p~n", [GradeId]),
            ?PRINT("send_cld_act_info {GradeCount, SelfCount, SelfTotalCount} : ~p~n", [{GradeCount, SelfCount, SelfTotalCount}]),
            NewState = State#kf_cld_buy_state{act_list = NewActList},
            {noreply, NewState};
        _ ->
            {ok, Bin} = pt_512:write(51202, [?ERRCODE(err512_act_close), Type, SubType, 0, 0, 0, 0, []]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            {noreply, State}
    end;

do_handle_cast({send_cld_act_tv_records, [Type, SubType, StartPos, EndPos, RoleId, Sid, ServerId, Node]}, State) -> 
    #kf_cld_buy_state{act_list = ActList} = State,
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{role_map = RoleMap} = CldBuyAct ->
            {CldZone, _NewCldBuyAct, NewActList} = get_cld_zone(Type, SubType, RoleId, ServerId, CldBuyAct, ActList, RoleMap),
            #cld_zone{tv_records = TvRecords} = CldZone,
            {RealStartPos, RealEndPos, IsEnd, FormatTvRecords} = format_tv_records(StartPos, EndPos, TvRecords),
            %?PRINT("send_cld_act_info {RealStartPos, RealEndPos} : ~p~n", [{RealStartPos, RealEndPos}]),
            %?PRINT("send_cld_act_info FormatTvRecords : ~p~n", [FormatTvRecords]),
            {ok, Bin} = pt_512:write(51203, [Type, SubType, RealStartPos, RealEndPos, IsEnd, FormatTvRecords]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            NewState = State#kf_cld_buy_state{act_list = NewActList},
            {noreply, NewState};
        _ ->
            {ok, Bin} = pt_512:write(51203, [Type, SubType, 0, 0, []]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            {noreply, State}
    end;

do_handle_cast({send_cld_act_big_records, [Type, SubType, SelfRoleId, Sid, SelfServerId, Node]}, State) -> 
    #kf_cld_buy_state{act_list = ActList} = State,
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{role_map = RoleMap} = CldBuyAct ->
            {CldZone, _NewCldBuyAct, NewActList} = get_cld_zone(Type, SubType, SelfRoleId, SelfServerId, CldBuyAct, ActList, RoleMap),
            #cld_zone{big_rewards_records = BigRewardRecords} = CldZone,
            FormatBigRewardRecords = [{RoleId, Name, ServerId, ServerNum, GradeId, Count, Time}|| 
                    #big_rewards_record{
                        role_id = RoleId, name = Name, server_id = ServerId
                        , server_num = ServerNum, grade_id = GradeId, count = Count, time = Time} <- BigRewardRecords],
            {ok, Bin} = pt_512:write(51204, [Type, SubType, FormatBigRewardRecords]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            NewState = State#kf_cld_buy_state{act_list = NewActList},
            ?PRINT("send_cld_act_big_records FormatBigRewardRecords : ~p~n", [FormatBigRewardRecords]),
            {noreply, NewState};
        _ ->
            {ok, Bin} = pt_512:write(51204, [Type, SubType, []]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            {noreply, State}
    end;

do_handle_cast({get_stage_reward, [Type, SubType, StageCount, RoleId, Sid, _ServerId, Node]}, State) -> 
    #kf_cld_buy_state{act_list = ActList} = State,
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{role_map = RoleMap} = CldBuyAct ->
            case maps:get(RoleId, RoleMap, 0) of 
                #cld_buy_role{name = Name, total_count = SelfTotalCount, stage_rewards = StageRewards} = CldBuyRole ->
                    case SelfTotalCount >= StageCount of 
                        true ->
                            case lists:keyfind(StageCount, 1, StageRewards) of 
                                {_, Wlv, StageSt} when StageSt == 0 ->
                                    Code = ?SUCCESS,
                                    NewStageReward = lists:keyreplace(StageCount, 1, StageRewards, {StageCount, Wlv, 1}),
                                    lib_kf_cloud_buy:db_update_cld_buy_role_stage_rewards(RoleId, Type, SubType, NewStageReward),
                                    NewCldBuyRole = CldBuyRole#cld_buy_role{stage_rewards = NewStageReward},
                                    NewRoleMap = maps:put(RoleId, NewCldBuyRole, RoleMap),
                                    NewCldBuyAct = CldBuyAct#cld_buy_act{role_map = NewRoleMap},
                                    NewActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct),
                                    Rewards = lib_kf_cloud_buy:get_stage_reward_list(Type, StageCount, Wlv),
                                    lib_log_api:log_kf_cloud_buy_stage_reward(RoleId, Name, Type, SubType, StageCount, Wlv, Rewards),
                                    NewState = State#kf_cld_buy_state{act_list = NewActList};
                                {_, _, _} ->
                                    Code = ?ERRCODE(err512_stage_reward_got),
                                    Rewards = [],
                                    NewState = State;
                                _ ->
                                    Code = ?ERRCODE(err512_stage_count_err),
                                    Rewards = [],
                                    NewState = State
                            end;
                        _ ->
                            Code = ?ERRCODE(err512_stage_count_less),
                            Rewards = [],
                            NewState = State
                    end;
                _ ->
                    Code = ?ERRCODE(err512_no_draw_reward),
                    Rewards = [],
                    NewState = State
            end,
            ?PRINT("get_stage_reward : ~p~n", [{Code, StageCount, RoleId, Rewards}]),
            mod_clusters_center:apply_cast(Node, lib_kf_cloud_buy, get_stage_reward_result, [Code, Type, SubType, StageCount, RoleId, Rewards]),
            {noreply, NewState};
        _ ->
            {ok, Bin} = pt_512:write(51206, [?ERRCODE(err512_act_close), Type, SubType, StageCount, []]),
            lib_server_send:send_to_sid(Node, Sid, Bin),
            {noreply, State}
    end;

do_handle_cast({timer_check}, State) ->  
    #kf_cld_buy_state{act_list = ActList} = State,
    NowTime = utime:unixtime(),
    NewActList = timer_check(ActList, NowTime),
    NewState = State#kf_cld_buy_state{act_list = NewActList},
    case length(ActList) > 0 andalso length(NewActList) == 0 of 
        true -> %% 全部活动都关闭了，truncate一下记录表
            lib_kf_cloud_buy:db_truncate_tv_records();
        _ -> skip
    end,
    {noreply, NewState};

do_handle_cast({gm_reset_act, Type, SubType}, State) ->  
    #kf_cld_buy_state{act_list = ActList} = State,
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{} = CldBuyAct ->
            {NewCldBuyAct, _} = reset_act_do(CldBuyAct, [], 4),
            NewActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct),
            {noreply, State#kf_cld_buy_state{act_list = NewActList}};
        _ ->
            {noreply, State}
    end;
    
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info({load_reward_record, OpenTypeList}, State) ->
    #kf_cld_buy_state{act_list = ActList, ref = OldRef} = State,
    case OpenTypeList of 
        [] -> {noreply, State};
        [{Type, SubType}|Left] ->
            NewActList = init_reward_record(Type, SubType, ActList),
            Ref = util:send_after(OldRef, 20000, self(), {load_reward_record, Left}),
            {noreply, State#kf_cld_buy_state{act_list = NewActList, ref = Ref}}
    end;

do_handle_info({end_buy, Type, SubType}, State) ->
    #kf_cld_buy_state{act_list = ActList} = State,
    NowTime = utime:unixtime(),
    %% 结束购买，全服推一下协议刷新
    mod_clusters_center:apply_to_all_node(lib_kf_cloud_buy, end_buy, []),
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{zone_list = ZoneList, role_map = RoleMap} = CldBuyAct -> 
            F = fun(CldZone, List) ->
                GradeId = get_current_grade_id(NowTime, CldZone, CldBuyAct),
                NewCldZone = draw_big_reward(GradeId, CldZone, RoleMap, NowTime),
                [NewCldZone|List]
            end,
            NewZoneList = lists:foldl(F, [], ZoneList),
            NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList},
            NewActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct),
            {noreply, State#kf_cld_buy_state{act_list = NewActList}};
        _ ->
            {noreply, State} 
    end;
    
do_handle_info({draw_big_reward, Type, SubType, ZoneId, GradeId}, State) ->
    #kf_cld_buy_state{act_list = ActList} = State,
    NowTime = utime:unixtime(),
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{buy_endtime = BuyEndTime, zone_list = ZoneList, role_map = RoleMap} = CldBuyAct -> 
            case lists:keyfind(ZoneId, #cld_zone.zone_id, ZoneList) of 
                #cld_zone{} = CldZone ->
                    %% 抽取大奖
                    NewCldZone = draw_big_reward(GradeId, CldZone, RoleMap, NowTime),
                    %% 是否开启下一轮
                    case NowTime < BuyEndTime of 
                        true -> %% 还没结束购买，刷新下一轮
                            {EnterNextLoop, LastCldZone, LastRoleMap} = refresh_next_loop(NewCldZone, RoleMap);
                        _ ->
                            LastCldZone = NewCldZone,
                            LastRoleMap = RoleMap,
                            EnterNextLoop = false
                    end,
                    NewZoneList = lists:keyreplace(ZoneId, #cld_zone.zone_id, ZoneList, LastCldZone),
                    NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList, role_map = LastRoleMap},
                    NewActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct),
                    %% 通知游戏服刷新轮次
                    case EnterNextLoop == true of 
                        true ->
                            NextGradeId = get_current_grade_id(NowTime, LastCldZone, NewCldBuyAct),
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_kf_cloud_buy, broadcast_next_loop, [Type, SubType, NextGradeId, 0, 0]);
                        _ ->
                            skip
                    end,
                    {noreply, State#kf_cld_buy_state{act_list = NewActList}};
                _ ->
                    {noreply, State}
            end;
        _ ->
            {noreply, State} 
    end;

do_handle_info(_Info, State) -> {noreply, State}.


init_do() ->
    ActList = init_act_list(),
    ActListAfRole = init_act_role(ActList),
    ActListAfZone = init_zone_data(ActListAfRole),
    ActListAfBigReward = init_big_reward_record(ActListAfZone),
    LoadTypeList = [{Type, SubType} ||#cld_buy_act{key = {Type, SubType}} <- ActListAfBigReward],
    Ref = util:send_after([], 60000, self(), {load_reward_record, LoadTypeList}),
    #kf_cld_buy_state{
        act_list = ActListAfBigReward
        , ref = Ref
    }.

init_act_list() ->
    case lib_kf_cloud_buy:db_select_cloud_buy_act() of 
        [] -> ActList = [];
        DbList ->
            F = fun([Type1, SubType1, StartTime1, EndTime1], Acc) ->
                [#cld_buy_act{key = {Type1, SubType1}, type = Type1, subtype = SubType1, start_time = StartTime1, end_time = EndTime1}|Acc]
            end,
            ActList = lists:foldl(F, [], DbList)
    end,
    NowTime = utime:unixtime(),
    OpenActList = lib_kf_cloud_buy:get_openning_cloud_act(NowTime),
    %% 先检查，关闭过期活动
    {ActListAfClose, CloseTypeList} = get_close_act(OpenActList, ActList),
    clear_old_data_list(CloseTypeList),
    %% 检查新活动开启
    F2 = fun({Type, SubType, StartTime, EndTime}, {Acc, AccDbList}) ->
        {NeedDb, NewCldBuyAct} = refresh_act(Type, SubType, StartTime, EndTime, NowTime, ActListAfClose),
        {[NewCldBuyAct|Acc], ?IF(NeedDb, [NewCldBuyAct|AccDbList], AccDbList)}
    end,
    {NewActList, DbActList} = lists:foldl(F2, {[], []}, OpenActList),
    lib_kf_cloud_buy:db_replace_cloud_buy_act(DbActList),
    NewActList.

init_act_role(ActList) ->
    case lib_kf_cloud_buy:db_select_cld_buy_role() of 
        [] -> ActList;
        DbList ->
            F = fun([RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, BigRewardsCount, TotalCount, StageRewards], Acc) ->
                CldBuyRole = lib_kf_cloud_buy:make(cld_buy_role, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, util:bitstring_to_term(BigRewardsCount), TotalCount, util:bitstring_to_term(StageRewards)]),
                {_, OldMap} = ulists:keyfind({Type, SubType}, 1, Acc, {{Type, SubType}, #{}}),
                NewRoleMap = maps:put(RoleId, CldBuyRole, OldMap),
                lists:keystore({Type, SubType}, 1, Acc, {{Type, SubType}, NewRoleMap})
            end,
            ActRoleList = lists:foldl(F, [], DbList),
            F2 = fun({{Type, SubType}, RoleMap}, OldActList) ->
                case lists:keyfind({Type, SubType}, #cld_buy_act.key, OldActList) of 
                    #cld_buy_act{} = CldBuyAct ->
                        NewCldBuyAct = CldBuyAct#cld_buy_act{role_map = RoleMap},
                        lists:keyreplace({Type, SubType}, #cld_buy_act.key, OldActList, NewCldBuyAct);
                    _ ->
                        ?INFO("init_act_role clear role : ~p~n", [{Type, SubType}]),
                        lib_kf_cloud_buy:db_clear_cld_buy_role(Type, SubType),
                        OldActList
                end
            end,
            lists:foldl(F2, ActList, ActRoleList)
    end.

init_zone_data(ActList) ->
    case lib_kf_cloud_buy:db_select_cld_zone() of 
        [] -> ActList;
        DbList ->
            F = fun([ZoneId, Type, SubType, Wlv, Loop, BigRewards], Acc) ->
                CldZone = lib_kf_cloud_buy:make(cld_zone, [ZoneId, Type, SubType, Wlv, Loop, util:bitstring_to_term(BigRewards)]),
                {_, OldList} = ulists:keyfind({Type, SubType}, 1, Acc, {{Type, SubType}, []}),
                lists:keystore({Type, SubType}, 1, Acc, {{Type, SubType}, [CldZone|OldList]})
            end,
            ActZoneList = lists:foldl(F, [], DbList),
            F2 = fun({{Type, SubType}, ZoneList}, OldActList) ->
                case lists:keyfind({Type, SubType}, #cld_buy_act.key, OldActList) of 
                    #cld_buy_act{} = CldBuyAct ->
                        NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = ZoneList},
                        lists:keyreplace({Type, SubType}, #cld_buy_act.key, OldActList, NewCldBuyAct);
                    _ ->
                        ?INFO("init_zone_data clear zone : ~p~n", [{Type, SubType}]),
                        lib_kf_cloud_buy:db_clear_cld_zone(Type, SubType),
                        OldActList
                end
            end,
            lists:foldl(F2, ActList, ActZoneList)
    end.

init_big_reward_record(ActList) ->
    case lib_kf_cloud_buy:db_select_big_reward_record() of 
        [] -> ActList;
        DbList ->
            F = fun([RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, GradeId, Count, Time], Acc) ->
                BigRewardRecord = lib_kf_cloud_buy:make(big_rewards_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, GradeId, Count, Time]),
                {_, OldList} = ulists:keyfind({Type, SubType}, 1, Acc, {{Type, SubType}, []}),
                lists:keystore({Type, SubType}, 1, Acc, {{Type, SubType}, [BigRewardRecord|OldList]})
            end,
            ActBigRewardRecordList = lists:foldl(F, [], DbList),
            F2 = fun({{Type, SubType}, List}, OldActList) ->
                case lists:keyfind({Type, SubType}, #cld_buy_act.key, OldActList) of 
                    #cld_buy_act{zone_list = ZoneList} = CldBuyAct ->
                        F3 = fun(#cld_zone{zone_id = ZoneId} = CldZone, AccZoneList) ->
                            ListInZone = [BigRewardRecord ||BigRewardRecord <- List, BigRewardRecord#big_rewards_record.zone_id == ZoneId],
                            [CldZone#cld_zone{big_rewards_records = ListInZone}|AccZoneList]
                        end,
                        NewZoneList = lists:foldl(F3, [], ZoneList),
                        NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList},
                        lists:keyreplace({Type, SubType}, #cld_buy_act.key, OldActList, NewCldBuyAct);
                    _ ->
                        ?INFO("init_big_reward_record clear : ~p~n", [{Type, SubType}]),
                        lib_kf_cloud_buy:db_clear_big_reward_record(Type, SubType),
                        OldActList
                end
            end,
            lists:foldl(F2, ActList, ActBigRewardRecordList)
    end.

init_reward_record(Type, SubType, ActList) ->
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{zone_list = ZoneList} = CldBuyAct ->  
            case lib_kf_cloud_buy:db_select_cld_buy_tv_record(Type, SubType) of 
                [] -> ActList;
                DbList ->
                    F = fun([RoleId, ZoneId, Name, ServerId, ServerNum, Rewards, Time], AccMap) ->
                        TvRecord = lib_kf_cloud_buy:make(tv_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, util:bitstring_to_term(Rewards), Time]),
                        OldList = maps:get(ZoneId, AccMap, []),
                        maps:put(ZoneId, [TvRecord|OldList], AccMap)
                    end,
                    TvRecordMap = lists:foldl(F, #{}, DbList),
                    F2 = fun(#cld_zone{zone_id = ZoneId} = CldZone, AccZoneList) ->
                        ZoneTvRecordList = maps:get(ZoneId, TvRecordMap, []),
                        case length(ZoneTvRecordList) > ?CLD_TV_RECORD_LEN of 
                            true -> 
                                {NewZoneTvRecordList, Left} = lists:split(?CLD_TV_RECORD_LEN, ZoneTvRecordList),
                                [#tv_record{time = ExpireTime}|_] = Left,
                                lib_kf_cloud_buy:db_clear_cld_buy_tv_record(Type, SubType, ExpireTime);
                            _ ->
                                NewZoneTvRecordList = ZoneTvRecordList
                        end,
                        [CldZone#cld_zone{tv_records = NewZoneTvRecordList}|AccZoneList]
                    end,
                    NewZoneList = lists:foldl(F2, [], ZoneList),
                    NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList},
                    lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct)
            end; 
        _ ->
            lib_kf_cloud_buy:db_clear_cld_buy_tv_record(Type, SubType),
            ActList 
    end.

timer_check(ActList, NowTime) ->
    ?PRINT("timer_check ######## start : ~n", []),
    OpenActList = lib_kf_cloud_buy:get_openning_cloud_act(NowTime),
    {_, {H, _M, _S}} = utime:unixtime_to_localtime(NowTime),
    %% 先检查，关闭过期活动
    {ActListAfClose, CloseTypeList} = get_close_act(OpenActList, ActList),
    CloseTypeList =/= [] andalso spawn(fun() -> clear_old_data_list(CloseTypeList) end),
    [send_stage_reward_with_reset(lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList)) ||{Type, SubType} <- CloseTypeList],
    %% 检查新活动开启
    F = fun({Type, SubType, StartTime, EndTime}, {Acc, AccDbList}) ->
        {NeedDb, NewCldBuyAct} = refresh_act(Type, SubType, StartTime, EndTime, NowTime, ActListAfClose),
        {[NewCldBuyAct|Acc], ?IF(NeedDb, [NewCldBuyAct|AccDbList], AccDbList)}
    end,
    {NewActList, DbActList} = lists:foldl(F, {[], []}, OpenActList),
    lib_kf_cloud_buy:db_replace_cloud_buy_act(DbActList),
    %% 检查活动重置
    LastActList = reset_act_list(NewActList, H),
    LastActList.

refresh_act(Type, SubType, StartTime, EndTime, NowTime, ActList) ->
    {BuyEndTime, ResetTime} = lib_kf_cloud_buy:get_reset_and_buy_endtime(Type, SubType, StartTime, EndTime, NowTime),
    %?PRINT("refresh_act BuyEndTime : ~p~n", [utime:unixtime_to_localtime(BuyEndTime)]),
    %?PRINT("refresh_act ResetTime : ~p~n", [utime:unixtime_to_localtime(ResetTime)]),
    case lists:keyfind({Type, SubType}, #cld_buy_act.key, ActList) of 
        #cld_buy_act{start_time = OldStartTime, end_time = OldEndTime, buy_endtime = OldBuyEndTime, ref = OldRef} = CldBuyAct -> %% 活动继续开启
            case BuyEndTime == OldBuyEndTime andalso is_reference(OldRef) of 
                true -> 
                    Ref = OldRef;
                _ ->
                    case BuyEndTime > NowTime of 
                        true ->
                            Ref = util:send_after(OldRef, (BuyEndTime - NowTime)*1000, self(), {end_buy, Type, SubType});
                        _ ->
                            Ref = []
                    end
            end,
            case OldStartTime == StartTime andalso OldEndTime == EndTime of 
                true ->
                    NewCldBuyAct = CldBuyAct#cld_buy_act{buy_endtime = BuyEndTime, reset_time = ResetTime, ref = Ref},
                    NeedDb = false;
                _ -> %% 更新活动的最新开始时间和结束时间
                    NewCldBuyAct = CldBuyAct#cld_buy_act{start_time = StartTime, end_time = EndTime, buy_endtime = BuyEndTime, reset_time = ResetTime, ref = Ref},
                    lib_log_api:log_kf_cloud_buy_act_start(Type, SubType, 2, StartTime, EndTime),
                    NeedDb = true
            end,
            {NeedDb, NewCldBuyAct};
        _ -> %% 开启新活动
            NewCldBuyAct = create_new_act(Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime),
            lib_log_api:log_kf_cloud_buy_act_start(Type, SubType, 1, StartTime, EndTime),
            {true, NewCldBuyAct}
    end.

reset_act_list(ActList, Hour) ->
    F = fun(CldBuyAct, {Acc, AllZones}) ->
        {NewCldBuyAct, NewAllZones} = reset_act_do(CldBuyAct, AllZones, Hour),
        {[NewCldBuyAct|Acc], NewAllZones}
    end,
    {NewActList, _} = lists:foldl(F, {[], []}, ActList),
    NewActList.

reset_act_do(CldBuyAct, AllZones, Hour) ->
    #cld_buy_act{key = {Type, SubType}, zone_list = ZoneList, role_map = RoleMap} = CldBuyAct,
    ResetType = lib_kf_cloud_buy:get_cld_buy_reset_type(Type, SubType),
    case (ResetType == 1 andalso Hour == 0) orelse (ResetType == 2 andalso Hour == 4) of 
        true -> %% 重置活动
            NewAllZones = ?IF(AllZones == [], get_all_zone(), AllZones),
            NewZoneList = reset_zone_list(Type, SubType, NewAllZones),
            %% 清除旧数据
            DelZoneIds = [OldZoneId ||#cld_zone{zone_id = OldZoneId} <- ZoneList, lists:keymember(OldZoneId, #cld_zone.zone_id, NewZoneList)==false],
            lib_kf_cloud_buy:db_replace_cld_zone_list(NewZoneList),
            lib_kf_cloud_buy:db_clear_cld_zone(Type, SubType, DelZoneIds),
            NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList, role_map = #{}},
            lib_log_api:log_kf_cloud_buy_act_reset(Type, SubType, [{ZoneId, BigRewards} ||#cld_zone{zone_id = ZoneId, big_rewards = BigRewards} <- NewZoneList]),
            %% 找出没领的阶段奖励的玩家列表
            send_stage_reward_with_reset(CldBuyAct),
            %% 清理数据
            spawn(fun() -> 
                lib_kf_cloud_buy:db_clear_cld_buy_tv_record(Type, SubType),
                case maps:size(RoleMap) > 0 of 
                    true -> 
                        lib_kf_cloud_buy:db_clear_cld_buy_role(Type, SubType);
                    _ -> skip
                end,
                %% 通知全服，活动重置
                notify_local_act_reset(NewCldBuyAct)
            end),
            %?PRINT("reset_act_do NewCldBuyAct:~p~n", [NewCldBuyAct]),
            {NewCldBuyAct, NewAllZones};
        _ ->
            {CldBuyAct, AllZones}
    end.

get_all_zone() ->
    AllZones = mod_zone_mgr:get_all_zone(),
    F = fun(ZoneBase, Map) ->
        #zone_base{zone = ZoneId, world_lv = Wlv} = ZoneBase,
        OldList = maps:get(ZoneId, Map, []),
        maps:put(ZoneId, [Wlv|OldList], Map)
    end,
    Var = lists:foldl(F, #{}, AllZones),
    maps:fold(fun(ZoneId, WlvList, Acc) ->
        AvgWlv = ?IF(WlvList == [], 1, lists:sum(WlvList) div length(WlvList)),
        [{ZoneId, AvgWlv}|Acc]
    end, [], Var).

get_stage_reward_not_receive(RoleMap) ->
    F = fun(_, CldBuyRole, Map) ->
        #cld_buy_role{role_id = RoleId, server_id = ServerId, total_count = TotalCount, stage_rewards = StageRewards} = CldBuyRole,
        case [{StageCount, Wlv} ||{StageCount, Wlv, StageSt} <- StageRewards, StageSt == 0 andalso TotalCount>=StageCount] of 
            [] -> Map;
            List ->
                Old = maps:get(ServerId, Map, []),
                maps:put(ServerId, [{RoleId, List}|Old], Map)
        end
    end,
    maps:fold(F, #{}, RoleMap).

reset_zone_list(Type, SubType, AllZones) ->
    F = fun({ZoneId, AvgWlv}, Acc) ->
        BigRewardIdList = lib_kf_cloud_buy:get_big_reward_list(Type, SubType, AvgWlv),
        BigRewards = [{GradeId, 0, 0} || GradeId <- BigRewardIdList],
        CldZone = lib_kf_cloud_buy:make(cld_zone, [ZoneId, Type, SubType, AvgWlv, 1, BigRewards]),
        [CldZone|Acc]
    end,
    lists:foldl(F, [], AllZones).
    
get_close_act(OpenActList, ActList) ->
    F = fun(CldBuyAct, {List1, List2}) ->
        #cld_buy_act{key = {Type, SubType}, start_time = OldStartTime, end_time = OldEndTime, ref = Ref} = CldBuyAct,
        case [Item ||{Type1, SubType1, _, _} = Item <- OpenActList, Type1 == Type, SubType1 == SubType] of 
            [{Type, SubType, StartTime, _EndTime}] ->
                case StartTime < OldEndTime of 
                    true -> %% 新的开始时间小于旧的结束时间，认为是开启
                        {[CldBuyAct|List1], List2};
                    _ -> %% 活动关闭
                        util:cancel_timer(Ref),
                        lib_log_api:log_kf_cloud_buy_act_start(Type, SubType, 3, OldStartTime, OldEndTime),
                        {List1, [{Type, SubType}|List2]}
                end;
            _ ->
                util:cancel_timer(Ref),
                lib_log_api:log_kf_cloud_buy_act_start(Type, SubType, 3, OldStartTime, OldEndTime),
                {List1, [{Type, SubType}|List2]}
        end
    end,
    {NewActList, CloseTypeList} = lists:foldl(F, {[], []}, ActList),
    {NewActList, CloseTypeList}.

create_new_act(Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime) ->
    NowTime = utime:unixtime(),
    case BuyEndTime > NowTime of 
        true ->
            Ref = util:send_after([], (BuyEndTime - NowTime)*1000, self(), {end_buy, Type, SubType});
        _ ->
            Ref = []
    end,
    #cld_buy_act{
        key = {Type, SubType}
        , type = Type
        , subtype = SubType
        , start_time = StartTime
        , end_time = EndTime
        , reset_time = BuyEndTime
        , buy_endtime = ResetTime
        , ref = Ref
    }.

create_new_stage_rewards(Type, Wlv) ->
    CountList = data_kf_cloud_buy:get_stage_count_list(Type),
    F = fun(StageCount, Acc) ->
        [{StageCount, Wlv, 0}|Acc]
    end,
    StageRewards = lists:foldl(F, [], CountList),
    StageRewards.

clear_old_data_list(CloseTypeList) ->
    [clear_old_data(Type, SubType) ||{Type, SubType} <- CloseTypeList],
    ok.

clear_old_data(Type, SubType) ->
    lib_kf_cloud_buy:db_clear_cld_zone(Type, SubType),
    lib_kf_cloud_buy:db_clear_big_reward_record(Type, SubType),
    lib_kf_cloud_buy:db_clear_cld_buy_role(Type, SubType),
    lib_kf_cloud_buy:db_clear_cld_buy_tv_record(Type, SubType),
    ok.

get_current_grade_id(_NowTime, CldZone, _CldBuyAct) ->
    #cld_zone{loop = Loop, big_rewards = BigRewards} = CldZone,
    get_current_grade_id_do(BigRewards, Loop, 1).
    %#cld_buy_act{reset_time = ResetTime, buy_endtime = BuyEndTime} = CldBuyAct,
    % if
    %     NowTime < BuyEndTime -> %% 取第一个没结算的大奖
    %         case [GradeId || {GradeId, GradeSt, _} <- BigRewards, GradeSt == 0] of
    %             [Id|_] -> Id;
    %             _ -> %% 取最后一个
    %                 get_last_grade_id(BigRewards) 
    %         end;
    %     NowTime >= BuyEndTime andalso NowTime < BuyEndTime -> %% 取最后一个已经结算的大奖
    %         case lists:reverse([GradeId || {GradeId, GradeSt, _} <- BigRewards, GradeSt == 1]) of
    %             [Id|_] -> Id;
    %             _ -> %%
    %                 get_last_grade_id(BigRewards)
    %         end;
    %     true -> %% 其他情况，取最后一个没结算的大奖
    %         case lists:reverse([GradeId || {GradeId, GradeSt, _} <- BigRewards, GradeSt == 0]) of
    %             [Id|_] -> Id;
    %             _ -> %%
    %                 get_last_grade_id(BigRewards)
    %         end
    % end.

% get_last_grade_id(BigRewards) ->
%     case lists:reverse(BigRewards) of 
%         [{GradeId, _GradeSt, _}|_] -> GradeId;
%         _ -> 0
%     end.
get_current_grade_id_do([], _, _) -> 0;
get_current_grade_id_do([{GradeId, _GradeSt, _}|BigRewards], Loop, Acc) ->
    case Loop == Acc of 
        true -> GradeId;
        _ -> get_current_grade_id_do(BigRewards, Loop, Acc+1)
    end.

get_role_zone_id(RoleId, ServerId, RoleMap) ->
    case maps:get(RoleId, RoleMap, 0) of 
        #cld_buy_role{zone_id = ZoneId} when ZoneId > 0 -> skip;
        _ -> ZoneId = lib_clusters_center_api:get_zone(ServerId)
    end,
    ZoneId.

get_cld_zone(Type, SubType, RoleId, ServerId, CldBuyAct, ActList, RoleMap) ->
    ZoneId = get_role_zone_id(RoleId, ServerId, RoleMap),
    #cld_buy_act{zone_list = ZoneList} = CldBuyAct,
    case get_cld_zone_do(Type, SubType, ZoneId, ZoneList) of 
        {1, CldZone, _NewZoneList} ->
            {CldZone, CldBuyAct, ActList};
        {2, CldZone, NewZoneList} ->
            NewCldBuyAct = CldBuyAct#cld_buy_act{zone_list = NewZoneList},
            NewActList = lists:keyreplace({Type, SubType}, #cld_buy_act.key, ActList, NewCldBuyAct),
            {CldZone, NewCldBuyAct, NewActList}
    end.

get_cld_zone_do(Type, SubType, ZoneId, ZoneList) ->
    case lists:keyfind(ZoneId, #cld_zone.zone_id, ZoneList) of 
        #cld_zone{} = CldZone -> {1, CldZone, ZoneList};
        _ ->
            ServerList = mod_zone_mgr:get_zone_server(ZoneId),
            WlvList = [SWlv ||#zone_base{world_lv = SWlv} <- ServerList],
            AvgWlv = ?IF(WlvList == [], 1, lists:sum(WlvList) div length(WlvList)),
            BigRewardIdList = lib_kf_cloud_buy:get_big_reward_list(Type, SubType, AvgWlv),
            BigRewards = [{GradeId, 0, 0} || GradeId <- BigRewardIdList],
            NewCldZone = lib_kf_cloud_buy:make(cld_zone, [ZoneId, Type, SubType, AvgWlv, 1, BigRewards]),
            lib_kf_cloud_buy:db_replace_cld_zone(NewCldZone),
            {2, NewCldZone, [NewCldZone|ZoneList]}
    end.

format_tv_records(StartPos, EndPos, TvRecords) ->
    Len = EndPos - StartPos + 1,
    case length(TvRecords) > (StartPos-1) of 
        true ->
            {_Pre, Left} = lists:split(StartPos-1, TvRecords),
            format_tv_records_do(Left, StartPos, Len, 0, []);
        _ ->
            format_tv_records_do(TvRecords, 1, Len, 0, [])
    end.

format_tv_records_do([], StartPos, _Len, Acc, Return) ->
    {StartPos, StartPos+Acc-1, 1, Return};
format_tv_records_do(TvRecords, StartPos, Len, Acc, Return) when Acc >= Len ->
    case length(TvRecords) > 0 of 
        true ->
            {StartPos, StartPos+Acc-1, 0, Return};
        _ ->
            {StartPos, StartPos+Acc-1, 1, Return}
    end;
format_tv_records_do([TvRecord|TvRecords], StartPos, Len, Acc, Return) ->
    #tv_record{
        role_id = RoleId, 
        name = Name, 
        server_id = ServerId, 
        server_num = ServerNum, 
        rewards = Rewards, 
        time = Time
    } = TvRecord,
    format_tv_records_do(TvRecords, StartPos, Len, Acc+1, [{RoleId, Name, ServerId, ServerNum, Rewards, Time}|Return]).

check_draw_count(RoleId, CldZone, RoleMap, GradeId, Times, _NowTime) ->
    #cld_zone{big_rewards = BigRewards} = CldZone,
    MaxCount = lib_kf_cloud_buy:get_grade_max_count(GradeId),
    case lists:keyfind(GradeId, 1, BigRewards) of 
        {_, GradeSt, GradeCount} ->
            if
                GradeSt =/= 0 -> {false, ?ERRCODE(err512_grade_end)};
                GradeCount+Times > MaxCount -> {false, ?ERRCODE(err512_no_grade_times)};
                true ->
                    case maps:get(RoleId, RoleMap, 0) of 
                        #cld_buy_role{big_rewards_count = BigRewardsCount} -> skip;
                        _ -> BigRewardsCount = []
                    end,
                    {_, SelfCount} = ulists:keyfind(GradeId, 1, BigRewardsCount, {GradeId, 0}),
                    {ok, SelfCount}
            end;
        _ ->
            {false, ?ERRCODE(err512_no_such_grade)}
    end.

draw_big_reward(GradeId, CldZone, RoleMap, NowTime) ->
    #cld_zone{type = Type, subtype = SubType, zone_id = ZoneId, big_rewards = BigRewards, big_rewards_records = BigRewardRecords} = CldZone,
    MaxCount = lib_kf_cloud_buy:get_grade_max_count(GradeId),
    case lists:keyfind(GradeId, 1, BigRewards) of 
        {_, GradeSt, GradeCount} when GradeSt == 0 ->
            WeightList = get_take_part_role(ZoneId, GradeId, GradeCount, MaxCount, RoleMap),
            {RoleId, Count} = util:find_ratio(WeightList, 2),
            NewBigRewards = lists:keyreplace(GradeId, 1, BigRewards, {GradeId, 1, GradeCount}),
            lib_kf_cloud_buy:db_update_cld_zone_big_rewards(ZoneId, Type, SubType, NewBigRewards),
            case RoleId > 0 of 
                true ->
                    #cld_buy_role{name = Name, server_id = ServerId, server_num = ServerNum} = maps:get(RoleId, RoleMap),
                    BigRewardsRecord = lib_kf_cloud_buy:make(big_rewards_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, GradeId, Count, NowTime]),
                    lib_kf_cloud_buy:db_relace_big_reward_record(BigRewardsRecord),
                    %% 发送奖励
                    Rewards = lib_kf_cloud_buy:get_grade_big_reward(GradeId),
                    mod_clusters_center:apply_cast(ServerId, lib_kf_cloud_buy, send_big_reward_to_role, [RoleId, Type, SubType, GradeId, Rewards]),
                    %% 全服传闻
                    case Rewards of 
                        [{?TYPE_GOODS, GTypeId, GNum}|_] ->
                            BinData = lib_chat:make_tv(?MODULE_CLOUD_BUY, 1, [Name, GTypeId, GNum]),
                            mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_server_send, send_to_all, [BinData]);
                        _ ->
                            skip
                    end,
                    NewBigRewardsRecords = [BigRewardsRecord|BigRewardRecords];
                _ -> %% 没有得奖，也记录一下
                    BigRewardsRecord = lib_kf_cloud_buy:make(big_rewards_record, [0, Type, SubType, ZoneId, "", 0, 0, GradeId, 0, NowTime]),
                    lib_kf_cloud_buy:db_relace_big_reward_record(BigRewardsRecord),
                    NewBigRewardsRecords = [BigRewardsRecord|BigRewardRecords]
            end,
            CldZone#cld_zone{big_rewards = NewBigRewards, big_rewards_records = NewBigRewardsRecords};
        _ ->
            CldZone
    end.

refresh_next_loop(CldZone, RoleMap) ->
    #cld_zone{zone_id = ZoneId, type = Type, subtype = SubType, wlv = AvgWlv, loop = Loop, big_rewards = BigRewards} = CldZone,
    MaxLoop = length(BigRewards),
    NextLoop = Loop+1,
    case NextLoop > MaxLoop of 
        true -> %% 重新从第一轮开始
            LastNextLoop = 1,
            BigRewardIdList = lib_kf_cloud_buy:get_big_reward_list(Type, SubType, AvgWlv),
            NewBigRewards = [{GradeId, 0, 0} || GradeId <- BigRewardIdList],
            {NewRoleMap, UpRoleIdList} = reset_role_big_rewards(ZoneId, RoleMap),
            NewCldZone = CldZone#cld_zone{loop = LastNextLoop, big_rewards = NewBigRewards},
            ?PRINT("refresh_next_loop: ~p~n", [{LastNextLoop, NewBigRewards}]),
            spawn(fun() ->
                lib_kf_cloud_buy:db_update_cld_zone_big_rewards_and_loop(ZoneId, Type, SubType, NewBigRewards, LastNextLoop),
                lib_kf_cloud_buy:db_update_cld_buy_role_big_rewards_batch(Type, SubType, UpRoleIdList, [])
            end),
            ok;
        _ ->
            NewCldZone = CldZone#cld_zone{loop = NextLoop},
            NewRoleMap = RoleMap,
            ?PRINT("refresh_next_loop: ~p~n", [NextLoop]),
            spawn(fun() ->
                lib_kf_cloud_buy:db_update_cld_zone_loop(ZoneId, Type, SubType, NextLoop)
            end),
            ok
    end,
    {true, NewCldZone, NewRoleMap}.

reset_role_big_rewards(ZoneId, RoleMap) ->
    F = fun(_, #cld_buy_role{role_id = RoleId, zone_id = ZoneId1}=CldBuyRole, {AccMap, AccList}) ->
        case ZoneId1 == ZoneId of 
            true ->
                NewAccMap = maps:put(RoleId, CldBuyRole#cld_buy_role{big_rewards_count = []}, AccMap),
                NewAccList = [RoleId|AccList],
                {NewAccMap, NewAccList};
            _ ->
                {AccMap, AccList}
        end
    end,
    {NewRoleMap, UpRoleIdList} = maps:fold(F, {RoleMap, []}, RoleMap),
    {NewRoleMap, UpRoleIdList}.

get_take_part_role(ZoneId, GradeId, GradeCount, MaxCount, RoleMap) when GradeCount > 0 ->
    F = fun(_, #cld_buy_role{role_id = RoleId, zone_id = ZoneId1, big_rewards_count = BigRewardsCount}, {Acc, AccCount}) ->
        case ZoneId1 == ZoneId of 
            true ->
                {_, Count} = ulists:keyfind(GradeId, 1, BigRewardsCount, {GradeId, 0}),
                ?IF(Count>0, {[{RoleId, Count}|Acc], AccCount+Count}, {Acc, AccCount});
            _ ->
                {Acc, AccCount}
        end
    end,
    {WeightList, AccCount} = maps:fold(F, {[], 0}, RoleMap),
    NewWeightList = ?IF(AccCount >= MaxCount, WeightList, [{0, MaxCount-AccCount}|WeightList]),
    NewWeightList;
get_take_part_role(_ZoneId, _GradeId, _GradeCount, MaxCount, _RoleMap) ->
    [{0, MaxCount}].

update_tv_records(RewardResult, Type, SubType, RoleId, Name, ServerId, ServerNum, ZoneId, NowTime, TvRecords) ->
    F = fun({_RewardId, Rewards}, {List, List2}) ->
        TvRecord = lib_kf_cloud_buy:make(tv_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, Rewards, NowTime]),
        {[TvRecord|List], [TvRecord|List2]}
    end,
    {NewTvRecords, DbList} = lists:foldl(F, {TvRecords, []}, RewardResult),
    case length(NewTvRecords) > ?CLD_TV_RECORD_LEN of 
        true ->
            {LastTvRecords, _} = lists:split(?CLD_TV_RECORD_LEN, NewTvRecords);
        _ -> 
            LastTvRecords = NewTvRecords
    end,
    spawn(fun() -> 
        lib_kf_cloud_buy:db_replace_cld_buy_tv_record(DbList),
        {RealStartPos, RealEndPos, IsEnd, FormatTvRecords} = format_tv_records(1, 10, LastTvRecords),
        {ok, Bin} = pt_512:write(51203, [Type, SubType, RealStartPos, RealEndPos, IsEnd, FormatTvRecords]),
        mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin])
    end),
    LastTvRecords.

notify_local_act_reset(CldBuyAct) ->
    #cld_buy_act{
        key = {Type, SubType}, start_time = StartTime, end_time = EndTime, buy_endtime = BuyEndTime, reset_time = ResetTime,
        zone_list = ZoneList
    } = CldBuyAct,
    NowTime = utime:unixtime(),
    F = fun(CldZone) ->
        #cld_zone{zone_id = ZoneId, wlv = Wlv} = CldZone,
        GradeId = get_current_grade_id(NowTime, CldZone, CldBuyAct),
        StageRewards = create_new_stage_rewards(Type, Wlv),
        Args = [Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime, GradeId, 0, 0, 0, StageRewards],
        mod_zone_mgr:apply_cast_to_zone(?ZONE_TYPE_1, ZoneId, lib_kf_cloud_buy, act_reset, Args),
        timer:sleep(300)
    end,
    lists:foreach(F, ZoneList).


send_stage_reward_with_reset(CldBuyAct) when is_record(CldBuyAct, cld_buy_act) ->
    #cld_buy_act{key = {Type, SubType}, role_map = RoleMap} = CldBuyAct,
    NotReceiverMap = get_stage_reward_not_receive(RoleMap),
    spawn(fun() ->
        F = fun(ServerId, RoleList, Acc) ->
            Acc rem 5 == 0 andalso timer:sleep(300),
            mod_clusters_center:apply_cast(ServerId, lib_kf_cloud_buy, send_stage_reward_with_reset, [Type, SubType, RoleList]),
            Acc + 1
        end,
        maps:fold(F, 1, NotReceiverMap)
    end),
    ok;
send_stage_reward_with_reset(_CldBuyAct) ->
    ok.