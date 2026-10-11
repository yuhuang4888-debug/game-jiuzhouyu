% %% ---------------------------------------------------------------------------
% %% @doc mod_level_draw_reward
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(mod_level_draw_reward).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("figure.hrl").
%%-----------------------------

act_start(ActInfo) ->
    gen_server:cast(?MODULE, {act_start, ActInfo}).

act_end(ActInfo) ->
    gen_server:cast(?MODULE, {act_end, ActInfo}).

send_level_draw_info(RoleId, Sid, Cmd, Type, SubType) ->
    gen_server:cast(?MODULE, {send_level_draw_info, RoleId, Sid, Cmd, Type, SubType}).

gm_send_reward(SubType) ->
    gen_server:cast(?MODULE, {gm_send_reward, SubType}).

gm_clear(SubType) ->
    gen_server:cast(?MODULE, {gm_clear, SubType}).

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


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({act_start, ActInfo}, State) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    OldLevelDraw = maps:get(SubType, State, #level_draw{subtype = SubType}),
    LevelDraw = new_level_draw(Type, SubType, OldLevelDraw),
    ?PRINT("act start LevelDraw ~p ~n", [LevelDraw]),
    NewState = maps:put(SubType, LevelDraw, State),
    erase({?MODULE, source}),
    {noreply, NewState};

do_handle_cast({act_end, ActInfo}, State) ->
    #act_info{key = {_Type, SubType}} = ActInfo,
    NewState = maps:remove(SubType, State),
    db:execute(io_lib:format(<<"delete from level_draw_winner where subtype=~p">>, [SubType])),
    erase({?MODULE, source}),
    {noreply, NewState};

do_handle_cast({send_level_draw_info, SelfRoleId, Sid, Cmd, Type, SubType}, State) ->
    #level_draw{draw_time = DrawTime, participant = Participant} = maps:get(SubType, State, #level_draw{subtype = SubType}),
    F = fun({RoleId, IsWinner}, List) ->
        case IsWinner == 1 of
            true ->
                Figure = lib_role:get_role_figure(RoleId),
                [{RoleId, Figure}|List];
            _ ->
                List
        end
    end,
    RoleList = lists:foldl(F, [], Participant),
    {_, IsWinner} = ulists:keyfind(SelfRoleId, 1, Participant, {SelfRoleId, 2}),
    lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?SUCCESS, Type, SubType, DrawTime, IsWinner, RoleList]),
    ?PRINT("send_level_draw_info ~p~n", [{DrawTime, IsWinner, length(RoleList)}]),
    {noreply, State};

do_handle_cast({gm_send_reward, SubType}, State) ->
    NowTime = utime:unixtime(),
    case check_open_source(SubType) of
        true ->
            #level_draw{draw_time = DrawTime, participant = Participant, ref = OldRef} = OldLevelDraw = maps:get(SubType, State, #level_draw{subtype = SubType}),
            case NowTime =< DrawTime andalso Participant == [] of
                true ->
                    util:cancel_timer(OldRef),
                    NewLevelDraw = draw_reward(OldLevelDraw, State),
                    ?PRINT("gm_send_reward NewLevelDraw ~p ~n", [NewLevelDraw]),
                    NewState = maps:put(SubType, NewLevelDraw, State);
                _ ->
                    NewState = State
            end,
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

do_handle_cast({gm_clear, SubType}, State) ->
    NowTime = utime:unixtime(),
    #level_draw{draw_time = DrawTime, ref = OldRef} = OldLevelDraw = maps:get(SubType, State, #level_draw{subtype = SubType}),
    case NowTime =< DrawTime of
        true ->
            db:execute(io_lib:format(<<"delete from level_draw_winner where subtype=~p">>, [SubType])),
            util:cancel_timer(OldRef),
            NotifyTime = DrawTime - 300,  %% 预告时间
            Duration = ?IF(NotifyTime =< NowTime, DrawTime - NowTime, NotifyTime - NowTime),
            Ref = util:send_after([], Duration*1000, self(), {draw_reward, SubType}),
            NewLevelDraw = OldLevelDraw#level_draw{participant = [], ref = Ref},
            ?PRINT("gm_clear NewLevelDraw ~p ~n", [NewLevelDraw]),
            NewState = maps:put(SubType, NewLevelDraw, State);
        _ ->
            NewState = State
    end,
    {noreply, NewState};


do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info({draw_reward, SubType}, State) ->
    NowTime = utime:unixtime(),
    #level_draw{draw_time = DrawTime, ref = OldRef} = OldLevelDraw = maps:get(SubType, State, #level_draw{subtype = SubType}),
    case check_open_source(SubType) of
        true ->
            case NowTime < DrawTime of
                true -> %% 传闻预告
                    Ref = util:send_after(OldRef, (DrawTime - NowTime) * 1000, self(), {draw_reward, SubType}),
                    %% 发通知预告传闻
                    send_notify_tv(SubType, DrawTime),
                    NewLevelDraw = OldLevelDraw#level_draw{ref = Ref},
                    {noreply, maps:put(SubType, NewLevelDraw, State)};
                _ -> %% 抽奖
                    case DrawTime > 0 of
                        true -> %% 抽奖
                            NewLevelDraw = draw_reward(OldLevelDraw, State),
                            ?PRINT("draw_reward NewLevelDraw ~p ~n", [NewLevelDraw]),
                            {noreply, maps:put(SubType, NewLevelDraw, State)};
                        _ ->
                            {noreply, State}
                    end
            end;
        _ ->
            {noreply, State}
    end;

do_handle_info(_Info, State) -> {noreply, State}.

init_do() ->
    case db:get_all(io_lib:format(<<"select role_id, subtype, is_winner from level_draw_winner">>, [])) of
        [] -> #{};
        DbList ->
            F = fun([RoleId, SubType, IsWinner], Map) ->
                OldLevelDraw = maps:get(SubType, Map, #level_draw{subtype = SubType}),
                NewLevelDraw = OldLevelDraw#level_draw{participant = [{RoleId, IsWinner}|OldLevelDraw#level_draw.participant]},
                maps:put(SubType, NewLevelDraw, Map)
            end,
            lists:foldl(F, #{}, DbList)
    end.

new_level_draw(Type, SubType, OldLevelDraw) ->
    NowTime = utime:unixtime(),
    #level_draw{draw_time = DrawTime, ref = OldRef, participant = Participant} =  OldLevelDraw,
    NewDrawTime = get_draw_time(Type, SubType),
    ?PRINT("new_level_draw DrawTime ~p ~n", [{DrawTime, NewDrawTime}]),
    case DrawTime =/= NewDrawTime of
        true ->
            util:cancel_timer(OldRef),
            NotifyTime = NewDrawTime - 300,  %% 预告时间
            case NowTime < NewDrawTime andalso Participant == [] of
                true ->
                    Duration = ?IF(NotifyTime =< NowTime, NewDrawTime - NowTime, NotifyTime - NowTime),
                    Ref = util:send_after([], Duration*1000, self(), {draw_reward, SubType});
                _ ->
                    Ref = none
            end,
            NewLevelDraw = #level_draw{subtype = SubType, draw_time = NewDrawTime, participant = Participant, ref = Ref},
            NewLevelDraw;
        _ ->
            OldLevelDraw
    end.

get_draw_time(Type, SubType) ->
    case lib_custom_act_util:keyfind_act_condition(Type, SubType, type) of
        {type, 2} ->
            utime:unixdate() + 73800;
        _ ->
            case lib_custom_act_util:keyfind_act_condition(Type, SubType, draw_time) of
                {draw_time, NeedOpenDay, DrawTime} when is_integer(NeedOpenDay) ->
                    Openday = util:get_open_day(),
                    DeviationDay = NeedOpenDay - Openday,
                    DeviationTime = DeviationDay * ?ONE_DAY_SECONDS,
                    StartTime = utime:unixdate() + DrawTime,
                    StartTime + DeviationTime;
                {draw_time, {Y, M, D}, DrawTime} ->
                    StartTime = utime:unixtime({{Y, M, D}, {0, 0, 0}}),
                    StartTime + DrawTime;
                _ ->
                    0
            end
    end.

draw_reward(LevelDraw, _State) ->
    case LevelDraw#level_draw.participant =/= [] of
        true -> LevelDraw;
        _ ->
            #level_draw{subtype = SubType} = LevelDraw,
            %% 获取所有符合条件要求的玩家列表
            RoleList = get_satisfy_role(SubType),
            case RoleList of
                [] -> LevelDraw;
                _ ->
                    FDb = fun() ->
                        F = fun(RoleId, List) ->
                            RechargeRmb = lib_recharge_data:get_total_rmb(RoleId),
                            [{RoleId, RechargeRmb}|List]
                        end,
                        ReturnList = lists:foldl(F, [], RoleList),
                        {ok, ReturnList}
                    end,
                    case catch db:transaction(FDb) of
                        {ok, RechargeRoleList} -> ok;
                        _Err ->
                            ?ERR("draw_reward db err : ~p~n", [_Err]),
                            RechargeRoleList = [{RoleId, 0} || RoleId <- RoleList]
                    end,
                    ?PRINT("draw_reward RechargeRoleList ~p ~n", [RechargeRoleList]),
                    WinnerList = draw_reward_do(SubType, RechargeRoleList),
                    Participant = lists:foldl(fun(RoleId, List) ->
                        case lists:member(RoleId, WinnerList) of
                            true -> [{RoleId, 1}|List];
                            _ -> [{RoleId, 0}|List]
                        end
                    end, [], RoleList),
                    db_replace_level_draw_winner(SubType, Participant),
                    %% 发奖励
                    send_reward(WinnerList, SubType),
                    %% 发传闻
                    send_reward_tv(SubType, WinnerList),
                    LevelDraw#level_draw{participant = Participant, ref = none}
            end
    end.

draw_reward_do(SubType, RechargeRoleList) ->
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType, recharge_area) of
        {recharge_area, RechargeArea} ->
            MaxNum = lists:sum([Num||{_RechargeVal, Num} <- RechargeArea]);
        _ ->
            MaxNum = 3,
            RechargeArea = [{0, MaxNum}]
    end,
    SortRechargeRoleList = lists:reverse(lists:keysort(2, RechargeRoleList)), % 按充值金额由大到小排序
    SortRechargeArea = lists:reverse(lists:keysort(1, RechargeArea)), % 按配置金额由大到小排序
    WinnerList = draw_reward_core(MaxNum, SortRechargeArea, SortRechargeRoleList, [], []),
    ?PRINT("draw_reward_do WinnerList ~p ~n", [WinnerList]),
    WinnerList.

draw_reward_core(_MaxNum, _, [], [], Return) ->
    Return;
draw_reward_core(_MaxNum, [], _, _, Return) ->
    Return;
draw_reward_core(MaxNum, RechargeArea, [], LeftRoleList, Return) ->
    draw_reward_core(MaxNum, RechargeArea, LeftRoleList, [], Return);
draw_reward_core(MaxNum, [{RechargeVal, Num}|RechargeArea], SortRechargeRoleList, LeftRoleList, Return) ->
    F = fun({_RoleId, Gold}) -> Gold >= RechargeVal end,
    {Satisfying, NotSatisfying} = lists:partition(F, SortRechargeRoleList),
    case length(Satisfying) >= Num of
        true ->
            {Pre, Left} = lists:split(Num, ulists:list_shuffle(Satisfying)),
            NewReturn = [RoleId ||{RoleId, _Gold} <- Pre] ++ Return,
            draw_reward_core(MaxNum, RechargeArea, NotSatisfying, Left ++ LeftRoleList, NewReturn);
        _ ->
            NewReturn = [RoleId||{RoleId, _Gold} <- Satisfying] ++ Return,
            LeftNum = Num - length(Satisfying),
            case RechargeArea of
                [{NextRechargeVal, NextNum}|NextRechargeArea] ->
                    draw_reward_core(MaxNum, [{NextRechargeVal, NextNum+LeftNum}|NextRechargeArea], NotSatisfying, LeftRoleList, NewReturn);
                _ ->
                    % 有剩余名额时,优先从符合最低充值条件的玩家中选取获奖者,其次从剩余不符合条件的玩家选取
                    case length(LeftRoleList) >= LeftNum of
                        true -> draw_reward_core(MaxNum, [{0, LeftNum}], LeftRoleList, [], NewReturn);
                        false ->
                            NewReturn2 = NewReturn ++ LeftRoleList,
                            LeftNum2 = min(LeftNum - length(LeftRoleList), length(NotSatisfying)),  % 防止死循环
                            draw_reward_core(MaxNum, [{0, LeftNum2}], NotSatisfying, [], NewReturn2)
                    end
            end
    end.

db_replace_level_draw_winner(SubType, Participant) ->
    Sql = usql:replace(level_draw_winner, [role_id, subtype, is_winner], [[RoleId, SubType, IsWinner] || {RoleId, IsWinner} <- Participant]),
    db:execute(Sql).

get_satisfy_role(SubType) ->
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType, draw_con) of
        {draw_con, level, NeedLv} ->
            OnLineRoleList = mod_chat_agent:get_real_online_player([lv]),
            SatisfyRoleList = [RoleId ||{RoleId, [RoleLv]} <- OnLineRoleList, RoleLv >= NeedLv],
            ?PRINT("get_satisfy_role#1 :~p~n", [SatisfyRoleList]),
            SatisfyRoleList;
        {draw_con, activity, NeedActivity} ->
            OnLineRoleList = mod_chat_agent:get_real_online_player([]),
            F = fun({RoleId, _}, List) ->
                Activity = mod_daily:get_count_offline(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
                ?IF(Activity >= NeedActivity, [RoleId|List], List)
            end,
            SatisfyRoleList = lists:foldl(F, [], OnLineRoleList),
            ?PRINT("get_satisfy_role#2 :~p~n", [SatisfyRoleList]),
            SatisfyRoleList;
        _ ->
            []
    end.

send_reward(WinnerList, SubType) ->
    ActType = ?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD,
    ActName = lib_custom_act_api:get_act_name(ActType, SubType),
    case lib_custom_act_util:keyfind_act_condition(ActType, SubType, reward) of
        {reward, RewardList} ->
            ok;
        _ ->
            RewardList = []
    end,
    Title = utext:get(3320005, [util:make_sure_binary(ActName)]),
    Content = utext:get(3320006, [util:make_sure_binary(ActName)]),
    lib_mail_api:send_sys_mail(WinnerList, Title, Content, RewardList),
    F = fun(RoleId) ->
        lib_log_api:log_custom_act_reward(RoleId, ActType, SubType, 0, RewardList)
    end,
    lists:foreach(F, WinnerList).

send_reward_tv(SubType, WinnerList) ->
    ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType),
    F = fun(RoleId, List) ->
        #figure{name = RoleName} = lib_role:get_role_figure(RoleId),
        [RoleName|List]
    end,
    RoleNameList = lists:foldl(F, [], WinnerList),
    RoleNameString = util:link_list(RoleNameList),
    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM_OTHER, 2, [RoleNameString, util:make_sure_binary(ActName)]).

send_notify_tv(SubType, DrawTime) ->
    ActName = lib_custom_act_api:get_act_name(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType),
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType, reward) of
        {reward, [{_, GoodsTypeId, _}|_]} ->
            GoodsName = data_goods_type:get_name(GoodsTypeId);
        _ ->
            GoodsName = <<>>
    end,
    {_,{_NowH, NowM, _}} = utime:unixtime_to_localtime(utime:unixtime()),
    {_,{StartH, StartM, _}} = utime:unixtime_to_localtime(DrawTime),
    DiffM = max(0, StartM - NowM),
    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM_OTHER, 3, [util:make_sure_binary(ActName), StartH, StartM, DiffM, util:make_sure_binary(GoodsName)]).

%%%%%%%%%%%%%%%% 渠道开启
check_open_source(SubType) ->
    SourceList = get_source_list(),
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_LEVEL_DRAW_REWARD, SubType, source_list) of
        {source_list, OpenSourceList} ->
            case [1 || Source <- OpenSourceList, lists:member(Source, SourceList)] == [] of
                true -> false;
                _ -> true
            end;
        _ ->
            true % 不配置该字段表示不对渠道进行验证
    end.

get_source_list() ->
    case get({?MODULE, source}) of
        SourceList when is_list(SourceList) andalso length(SourceList) > 0 ->
            SourceList;
        _ ->
            case db:get_all(<<"select distinct source from player_login">>) of
                [] -> [];
                DbList ->
                    SourceList = [list_to_atom(util:make_sure_list(Source)) || [Source] <- DbList],
                    put({?MODULE, source}, SourceList),
                    SourceList
            end
    end.