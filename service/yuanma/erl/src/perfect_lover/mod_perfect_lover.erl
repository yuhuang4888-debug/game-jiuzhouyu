%%%--------------------------------------
%%% @Module  : mod_perfect_lover
%%% @Author  : huyihao
%%% @Created : 2018.03.15
%%% @Description:  完美情人
%%%--------------------------------------
-module(mod_perfect_lover).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("custom_act.hrl").
-include("perfect_lover.hrl").
-include("predefine.hrl").
-include("language.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([act_start/1, act_close/1, add_wedding_times/3, open_perfect_lover/5, get_reward/3]).

-export([
    ]).
 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_start(ActSubType) ->
    gen_server:cast(?MODULE, {act_start, ActSubType}).

act_close(ActSubType) ->
    gen_server:cast(?MODULE, {act_close, ActSubType}).

add_wedding_times(RoleIdM, RoleIdW, WeddingType) ->
    gen_server:cast(?MODULE, {add_wedding_times, RoleIdM, RoleIdW, WeddingType}).

open_perfect_lover(SubType, Opr, RoleId, LoverRoleId, LoverName) ->
    gen_server:cast(?MODULE, {open_perfect_lover, SubType, Opr, RoleId, LoverRoleId, LoverName}).

get_reward(SubType, Opr, RoleId) ->
    gen_server:cast(?MODULE, {get_reward, SubType, Opr, RoleId}).

init([]) ->
    case lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_PERFECT_LOVER) of
        [] ->
            ActSubType = 0,
            WeddingTimesList = [],
            WeddingLogList = [],
            db:execute(?DeletePerfectLoverAllSql);
        [ActSubType|_] ->
            case db:get_all(?SelectPerfectLoverAllSql) of
                [] ->
                    WeddingTimesList = [],
                    WeddingLogList = [];
                PerfectLoverSqlList ->
                    F = fun(PLSqlInfo, {WeddingTimesList1, WeddingLogList1}) ->
                        [RoleIdM, RoleIdW, WeddingType, _Time] = PLSqlInfo,
                        {_IfRewardM, WeddingTimesList2} = lib_perfect_lover:update_perfect_times_info(RoleIdM, RoleIdW, WeddingType, WeddingTimesList1),
                        {_IfRewardW, WeddingTimesList3} = lib_perfect_lover:update_perfect_times_info(RoleIdW, RoleIdM, WeddingType, WeddingTimesList2),
                        % if
                        %     IfRewardM =:= true andalso IfRewardW =:= true ->
                        %         WeddingLogList2 = [{RoleIdM, RoleIdW, Time}|WeddingLogList1];
                        %     IfRewardM =:= true ->
                        %         WeddingLogList2 = [{RoleIdM, RoleIdW, Time}|WeddingLogList1];
                        %     IfRewardW =:= true ->
                        %         WeddingLogList2 = [{RoleIdM, RoleIdW, Time}|WeddingLogList1];
                        %     true ->
                        %         WeddingLogList2 = WeddingLogList1
                        % end,
                        WeddingLogList2 = WeddingLogList1,
                        {WeddingTimesList3, WeddingLogList2}
                    end,
                    {WeddingTimesList, WeddingLogList} = lists:foldl(F, {[], []}, PerfectLoverSqlList)
            end
    end,
    State = #perfect_lover_state{
        act_subtype = ActSubType,
        wedding_times_list = WeddingTimesList,
        wedding_log_list = WeddingLogList
    },
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State}
    end.

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

do_handle_cast({act_start, ActSubType}, State) ->
    #perfect_lover_state{
        act_subtype = ActSubType1
    } = State,
    case ActSubType1 of
        0 ->
            NewState = #perfect_lover_state{
                act_subtype = ActSubType
            };
        _ ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_cast({act_close, ActSubType}, State) ->
    #perfect_lover_state{
        act_subtype = ActSubType1
    } = State,
    case ActSubType of
        ActSubType1 ->
            NewState = #perfect_lover_state{},
            lib_counter:db_clear(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER, [ActSubType]),
            db:execute(?DeletePerfectLoverAllSql);
        _ ->
            NewState = State
    end,
    {noreply, NewState};

do_handle_cast({add_wedding_times, RoleIdM, RoleIdW, WeddingType}, State) ->
    #perfect_lover_state{
        act_subtype = ActSubType,
        wedding_times_list = OldWeddingTimesList,
        wedding_log_list = _OldWeddingLogList
    } = State,
    case ActSubType of
        0 ->
            NewState = State;
        _ ->
            NowTime = utime:unixtime(),
            {_IfRewardM, NewWeddingTimesList1} = lib_perfect_lover:update_perfect_times_info(RoleIdM, RoleIdW, WeddingType, OldWeddingTimesList),
            {_IfRewardW, NewWeddingTimesList} = lib_perfect_lover:update_perfect_times_info(RoleIdW, RoleIdM, WeddingType, NewWeddingTimesList1),
            lib_perfect_lover:sql_perfect_lover(RoleIdM, RoleIdW, WeddingType, NowTime),
            %{reward, RewardList} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_PERFECT_LOVER, ActSubType, reward),
            % if
            %     IfRewardM =:= true andalso IfRewardW =:= true ->
            %         %NewWeddingLogList = [{RoleIdM, RoleIdW, NowTime}|OldWeddingLogList],
            %         lib_perfect_lover:pl_send_mail(RoleIdM, RoleIdW, RewardList),
            %         lib_perfect_lover:pl_send_mail(RoleIdW, RoleIdM, RewardList);
            %     IfRewardM =:= true ->
            %         %NewWeddingLogList = [{RoleIdM, RoleIdW, NowTime}|OldWeddingLogList],
            %         lib_perfect_lover:pl_send_mail(RoleIdM, RoleIdW, RewardList);
            %     IfRewardW =:= true ->
            %         %NewWeddingLogList = [{RoleIdM, RoleIdW, NowTime}|OldWeddingLogList],
            %         lib_perfect_lover:pl_send_mail(RoleIdW, RoleIdM, RewardList);
            %     true ->
            %         skip
            %         %NewWeddingLogList = OldWeddingLogList
            % end,
            State1 = State#perfect_lover_state{
                wedding_times_list = NewWeddingTimesList
            },
            {_, State2} = do_handle_cast({open_perfect_lover, ActSubType, 1, RoleIdM, RoleIdW, ""}, State1),
            {_, NewState} = do_handle_cast({open_perfect_lover, ActSubType, 1, RoleIdW, RoleIdM, ""}, State2)
    end,
    {noreply, NewState};

do_handle_cast({open_perfect_lover, SubType, Opr, RoleId, _LoverRoleId, _LoverName}, State) ->
    #perfect_lover_state{
        act_subtype = ActSubType,
        wedding_times_list = WeddingTimesList,
        wedding_log_list = _WeddingLogList
    } = State,
    case ActSubType of
        SubType ->
            case lists:keyfind(RoleId, #wedding_times_info.role_id, WeddingTimesList) of
                false ->
                    IfGetReward = 0,
                    WeddingTimesSendList = [];
                #wedding_times_info{lover_list = LoverList} ->
                    WeddingTypeList = data_marriage:get_wedding_type_list(),
                    WeddingTypeNum = length(WeddingTypeList),
                    case lib_perfect_lover:check_wedding_times(LoverList, WeddingTypeNum) of
                        true ->
                            case mod_counter:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType) > 0 of 
                                true ->
                                    IfGetReward = 2;
                                _ ->
                                    IfGetReward = 1
                            end;
                        false ->
                            IfGetReward = 0
                    end,
                    WeddingTimesSendList = ulists:kv_list_plus([TimesList || #wedding_times_lover_info{times_list = TimesList} <- LoverList])
            end,
            ?PRINT("open_perfect_lover : ~p~n", [WeddingTimesSendList]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33115, [1, SubType, Opr, IfGetReward, WeddingTimesSendList]);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33115, [?ERRCODE(err331_act_closed), SubType, Opr, 0, []])
    end,
    {noreply, State};

do_handle_cast({get_reward, SubType, Opr, RoleId}, State) ->
    #perfect_lover_state{
        act_subtype = ActSubType,
        wedding_times_list = WeddingTimesList
    } = State,
    case ActSubType of
        SubType ->
            case lists:keyfind(RoleId, #wedding_times_info.role_id, WeddingTimesList) of
                false ->
                    Canget = false,
                    WeddingTimesSendList = [];
                #wedding_times_info{lover_list = LoverList} ->
                    WeddingTypeList = data_marriage:get_wedding_type_list(),
                    WeddingTypeNum = length(WeddingTypeList),
                    case lib_perfect_lover:check_wedding_times(LoverList, WeddingTypeNum) of
                        true ->
                            Canget = true;
                        false ->
                            Canget = false
                    end,
                    WeddingTimesSendList = ulists:kv_list_plus([TimesList || #wedding_times_lover_info{times_list = TimesList} <- LoverList])
            end,
            case Canget of 
                true ->
                    case mod_counter:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType) > 0 of 
                        true ->
                            IsGetReward = true;
                        _ ->
                            IsGetReward = false
                    end,
                    case IsGetReward of 
                        true ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33115, [?ERRCODE(err331_already_get_reward), SubType, Opr, 0, []]);
                        _ ->
                            {reward, DsgtId} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType, reward),
                            DsgtId > 0 andalso lib_designation_api:active_dsgt_common(RoleId, DsgtId),  
                            lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType, 0, [DsgtId]),
                            mod_counter:increment(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType),
                            lib_server_send:send_to_uid(RoleId, pt_331, 33115, [1, SubType, Opr, 2, WeddingTimesSendList])                                 
                    end;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33115, [?ERRCODE(err331_act_can_not_get), SubType, Opr, 0, WeddingTimesSendList])
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33115, [?ERRCODE(err331_act_closed), SubType, Opr, 0, []])
    end,
    {noreply, State};

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