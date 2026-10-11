%%-----------------------------------------------------------------------------
%% @Module  :       mod_limit_buy
%% @Author  :       huyihao
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-3-2
%% @Description:    特惠商城
%%-----------------------------------------------------------------------------
-module(mod_limit_buy).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("limit_buy.hrl").
-include("custom_act.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    limit_buy_check/3,
    add_grade_daily_num/3,
    open_limit_buy/2,
    day_clear/1,
    day_clear/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

limit_buy_check(SubType, GradeId, RoleId) ->
    gen_server:call(?MODULE, {limit_buy_check, SubType, GradeId, RoleId}).

add_grade_daily_num(SubType, GradeId, RoleId) ->
    gen_server:cast(?MODULE, {add_grade_daily_num, SubType, GradeId, RoleId}).

open_limit_buy(RoleId, SubType) ->
    gen_server:cast(?MODULE, {open_limit_buy, RoleId, SubType}).

day_clear(_Time) ->
    util:rand_time_to_delay(1000, mod_limit_buy, day_clear, []).

day_clear() ->
    gen_server:cast(?MODULE, {day_clear}).

init([]) ->
    case db:get_all(?SelectLimitBuyDailyNumALLSql) of
        [] ->
            State = #limit_buy_state{};
        LimitBuySqlList ->
            PlayerInfoList = db:get_all(?SelectLimitBuyDailyPlayerALLSql),
            UsePlayerList = [{{SubType, GradeId}, RoleId, PlayerNum}||[SubType, GradeId, RoleId, PlayerNum] <- PlayerInfoList],
            F = fun([SubType, GradeId, DailyGetNum], LimitBuyList1) ->
                PlayerNumList = [begin
                    {RoleId1, PlayerNum1}
                end||{{SubType1, GradeId1}, RoleId1, PlayerNum1} <- UsePlayerList, SubType1 =:= SubType andalso GradeId1 =:= GradeId],
                NewLimitBuyNumInfo = #limit_buy_num{
                    grade_id = GradeId,
                    grade_num = DailyGetNum,
                    player_num_list = PlayerNumList
                },
                case lists:keyfind(SubType, #limit_buy_info.subtype, LimitBuyList1) of
                    false ->
                        NewLimitBuyInfo = #limit_buy_info{
                            subtype = SubType,
                            grade_num_list = [NewLimitBuyNumInfo]
                        };
                    LimitBuyInfo ->
                        #limit_buy_info{
                            grade_num_list = GradeNumList1
                        } = LimitBuyInfo,
                        NewLimitBuyInfo = LimitBuyInfo#limit_buy_info{
                            grade_num_list = [NewLimitBuyNumInfo|GradeNumList1]
                        }
                end,
                [NewLimitBuyInfo|LimitBuyList1]
            end,
            LimitBuyList = lists:foldl(F, [], LimitBuySqlList),
            State = #limit_buy_state{
                limit_buy_list = LimitBuyList
            }
    end,
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

do_handle_call({limit_buy_check, SubType, GradeId, RoleId}, _From, State) ->
    #limit_buy_state{
        limit_buy_list = LimitBuyList
    } = State,
    GradeConInfo = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType, GradeId),
    #custom_act_reward_cfg{
        condition = ConditionList
    } = GradeConInfo,
    {limit, AllNum} = lists:keyfind(limit, 1, ConditionList),
    {self_limit, SelfAllNum} = lists:keyfind(self_limit, 1, ConditionList),
    case lists:keyfind(SubType, #limit_buy_info.subtype, LimitBuyList) of
        false ->
            AllLessNum = AllNum,
            PlayerLessNum = SelfAllNum;
        LimitBuyInfo ->
            #limit_buy_info{
                grade_num_list = GradeNumList
            } = LimitBuyInfo,
            case lists:keyfind(GradeId, #limit_buy_num.grade_id, GradeNumList) of
                false ->
                    AllLessNum = AllNum,
                    PlayerLessNum = SelfAllNum;
                LimitBuyNumInfo ->
                    #limit_buy_num{
                        grade_num = GradeNum,
                        player_num_list = PlayerNumList
                    } = LimitBuyNumInfo,
                    AllLessNum = max(0, (AllNum-GradeNum)),
                    case lists:keyfind(RoleId, 1, PlayerNumList) of
                        false ->
                            PlayerLessNum = SelfAllNum;
                        {_, PlayerNum} ->
                            PlayerLessNum = max(0, (SelfAllNum-PlayerNum))
                    end
            end
    end,
    if
        AllLessNum =< 0 ->
            Return = {false, ?ERRCODE(err331_limit_buy_daily_num_max)};
        PlayerLessNum =< 0 ->
            Return = {false, ?ERRCODE(err331_limit_buy_daily_player_max)};
        true ->
            Return = true
    end,
    {reply, Return, State};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Info, State) ->
    case catch do_handle_cast(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_cast({add_grade_daily_num, SubType, GradeId, RoleId}, State) ->
    #limit_buy_state{
        limit_buy_list = LimitBuyList
    } = State,
    case lists:keyfind(SubType, #limit_buy_info.subtype, LimitBuyList) of
        false ->
            NewGradeNum = 1,
            NewLimitBuyNumInfo = #limit_buy_num{
                grade_id = GradeId,
                grade_num = NewGradeNum,
                player_num_list = [{RoleId, NewGradeNum}]
            },
            NewGradeNumList = [NewLimitBuyNumInfo],
            NewLimitBuyInfo = #limit_buy_info{
                subtype = SubType,
                grade_num_list = NewGradeNumList
            };
        LimitBuyInfo ->
            #limit_buy_info{
                grade_num_list = GradeNumList
            } = LimitBuyInfo,
            case lists:keyfind(GradeId, #limit_buy_num.grade_id, GradeNumList) of
                false ->
                    NewGradeNum = 1,
                    NewLimitBuyNumInfo = #limit_buy_num{
                        grade_id = GradeId,
                        grade_num = NewGradeNum,
                        player_num_list = [{RoleId, NewGradeNum}]
                    },
                    NewGradeNumList = [NewLimitBuyNumInfo|GradeNumList];
                LimitBuyNumInfo ->
                    #limit_buy_num{
                        player_num_list = PlayerNumList,
                        grade_num = GradeNum
                    } = LimitBuyNumInfo,
                    NewGradeNum = GradeNum + 1,
                    case lists:keyfind(RoleId, 1, PlayerNumList) of
                        false ->
                            NewPlayerNumList = [{RoleId, 1}|PlayerNumList];
                        {_, PlayerNum} ->
                            NewPlayerNumList = lists:keyreplace(RoleId, 1, PlayerNumList, {RoleId, PlayerNum+1})
                    end,
                    NewLimitBuyNumInfo = LimitBuyNumInfo#limit_buy_num{
                        grade_num = NewGradeNum,
                        player_num_list = NewPlayerNumList
                    },
                    NewGradeNumList = lists:keyreplace(GradeId, #limit_buy_num.grade_id, GradeNumList, NewLimitBuyNumInfo)
            end,
            NewLimitBuyInfo = LimitBuyInfo#limit_buy_info{
                grade_num_list = NewGradeNumList
            }
    end,
    ReSql = io_lib:format(?ReplaceLimitBuyDailyNumSql, [SubType, GradeId, NewGradeNum]),
    db:execute(ReSql),
    F = fun(LimitBuyNumInfo1, PlayerNumSqlList1) ->
        #limit_buy_num{
            grade_id = GradeId1,
            player_num_list = PlayerNumList1
        } = LimitBuyNumInfo1,
        F1 = fun(PlayerInfo, PlayerNumSqlList2) ->
            {RoleId1, PlayerNum1} = PlayerInfo,
            SqlStr = io_lib:format("(~p, ~p, ~p, ~p)", [SubType, GradeId1, RoleId1, PlayerNum1]),
            [SqlStr|PlayerNumSqlList2]
        end,
        lists:foldl(F1, PlayerNumSqlList1, PlayerNumList1)
    end,
    PlayerNumSqlList = lists:foldl(F, [], NewGradeNumList),
    case PlayerNumSqlList of
        [] ->
            skip;
        _ ->
            SqlStrListStr = ulists:list_to_string(PlayerNumSqlList, ","),
            ReSql1 = io_lib:format(?ReplaceLimitBuyDailyPlayerAllSql, [SqlStrListStr]),
            db:execute(ReSql1)
    end,
    NewLimitBuyList = lists:keystore(SubType, #limit_buy_info.subtype, LimitBuyList, NewLimitBuyInfo),
    NewState = State#limit_buy_state{
        limit_buy_list = NewLimitBuyList
    },
    {noreply, NewState};

do_handle_cast({open_limit_buy, RoleId, SubType}, State) ->
    #limit_buy_state{
        limit_buy_list = LimitBuyList
    } = State,
    SubTypeInfo = lists:keyfind(SubType, #limit_buy_info.subtype, LimitBuyList),
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType),
    F = fun(GradeId, SendList1) ->
        GradeConInfo = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType, GradeId),
        #custom_act_reward_cfg{
            condition = ConditionList
        } = GradeConInfo,
        {limit, AllNum} = lists:keyfind(limit, 1, ConditionList),
        {self_limit, SelfAllNum} = lists:keyfind(self_limit, 1, ConditionList),
        {cost, CostList} = lists:keyfind(cost, 1, ConditionList),
        {discount, Discount} = lists:keyfind(discount, 1, ConditionList),
        [{CostGoodsType, _CostGoodsId, CostNum}|_] = CostList,
        case SubTypeInfo of
            false ->
                LessNum = AllNum,
                SelfLessNum = SelfAllNum;
            _ ->
                #limit_buy_info{
                    grade_num_list = GradeNumList
                } = SubTypeInfo,
                case lists:keyfind(GradeId, #limit_buy_num.grade_id, GradeNumList) of
                    false ->
                        LessNum = AllNum,
                        SelfLessNum = SelfAllNum;
                    LimitBuyNumInfo ->
                        #limit_buy_num{
                            grade_num = GradeNum,
                            player_num_list = PlayerNumList
                        } = LimitBuyNumInfo,
                        LessNum = max(0, (AllNum-GradeNum)),
                        case lists:keyfind(RoleId, 1, PlayerNumList) of
                            false ->
                                SelfLessNum = SelfAllNum;
                            {_, PlayerNum} ->
                                SelfLessNum = max(0, (SelfAllNum-PlayerNum))
                        end
                end
        end,
        [{GradeId, CostGoodsType, CostNum, Discount, LessNum, AllNum, SelfLessNum, SelfAllNum}|SendList1]
    end,
    SendList = lists:foldl(F, [], GradeIdList),
    {ok, Bin} = pt_331:write(33111, [?SUCCESS, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({day_clear}, State) ->
    NewState = State#limit_buy_state{
        limit_buy_list = []
    },
    db:execute(?DeleteLimitBuyDailyNumAllSql),
    db:execute(?DeleteLimitBuyDailyPlayerAllSql),
    {noreply, NewState};

do_handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
