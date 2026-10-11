% %% ---------------------------------------------------------------------------
% %% @doc mod_level_draw_reward
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(mod_activity_onhook).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("activity_onhook.hrl").
-include("goods.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
%%-----------------------------
%% 一些活动开始并不能进入活动，只是报名阶段，要等报名结束后，活动调用act_enter开启托管
-define(not_start_immediately(ModuleId, _SubId),
    ModuleId == ?MOD_DRUMWAR orelse ModuleId == ?MOD_TERRITORY_WAR orelse ModuleId == ?MOD_KF_1VN).

act_start(ModuleId, SubId) ->
    act_start(ModuleId, SubId, []).
act_start(ModuleId, SubId, Args) ->
    case lib_activity_onhook:is_onhook_open() andalso lists:member({ModuleId, SubId}, data_activity_onhook:get_all_onhook_act()) of
        true ->
            case ?not_start_immediately(ModuleId, SubId) of
                true -> ok;
                _ ->
                    gen_server:cast(?MODULE, {act_start, ModuleId, SubId, Args})
            end;
        _ -> ok
    end.

act_enter(ModuleId, SubId, Args) ->
    case lib_activity_onhook:is_onhook_open() andalso lists:member({ModuleId, SubId}, data_activity_onhook:get_all_onhook_act()) of
        true ->
            gen_server:cast(?MODULE, {act_start, ModuleId, SubId, Args});
        _ -> ok
    end.

act_end(ModuleId, SubId) ->
    case lists:member({ModuleId, SubId}, data_activity_onhook:get_all_onhook_act()) of
        true ->
            gen_server:cast(?MODULE, {act_end, ModuleId, SubId});
        _ -> ok
    end.

cancel_role_activity_onhook(RoleId, ModuleId, SubId, CancelCode) ->
    gen_server:cast(?MODULE, {cancel_role_activity_onhook, RoleId, ModuleId, SubId, CancelCode}).

activity_onhook_ok(RoleId, ModuleId, SubId) ->
    gen_server:cast(?MODULE, {activity_onhook_ok, RoleId, ModuleId, SubId}).

timer_del_coin() ->
    gen_server:cast(?MODULE, {timer_del_coin}).

week_handle() ->
    gen_server:cast(?MODULE, {week_handle}).

clear_record() ->
    gen_server:cast(?MODULE, {clear_record}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add_activity_value(RoleId, OldTodayValue, AddValue) ->
    lib_activity_onhook:is_onhook_open() andalso
        gen_server:cast(?MODULE, {add_activity_value, RoleId, OldTodayValue, AddValue}).

gm_add_activity_value(RoleId, AddValue) ->
    gen_server:cast(?MODULE, {gm_add_activity_value, RoleId, AddValue}).

exchange_onhook_coin(RoleId, ExchangeOnhookCoin) ->
    gen_server:cast(?MODULE, {exchange_onhook_coin, RoleId, ExchangeOnhookCoin}).

select_module(RoleId, ModId, SubId) ->
    gen_server:cast(?MODULE, {select_module, RoleId, ModId, SubId}).

cancel_select_module(RoleId, ModId, SubId) ->
    gen_server:cast(?MODULE, {cancel_select_module, RoleId, ModId, SubId}).

select_module_behaviour(RoleId, ModId, SubId, BehaviourId, Times) ->
    gen_server:cast(?MODULE, {select_module_behaviour, RoleId, ModId, SubId, BehaviourId, Times}).

cancel_select_module_behaviour(RoleId, ModId, SubId, BehaviourId) ->
    gen_server:cast(?MODULE, {cancel_select_module_behaviour, RoleId, ModId, SubId, BehaviourId}).

send_activity_onhook_list(RoleId, Sid) ->
    gen_server:cast(?MODULE, {send_activity_onhook_list, RoleId, Sid}).

send_activity_onhook_record(RoleId, Sid) ->
    gen_server:cast(?MODULE, {send_activity_onhook_record, RoleId, Sid}).



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
terminate(_Reason, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, OnhookRole, List) ->
        #activity_onhook_role{
            onhook_coin = OnhookCoin, exchange_left = ExchangeLeft, is_dirty_coin = IsDirtyCoin
        } = OnhookRole,
        %% 检查是否需要写托管币到数据库
        case IsDirtyCoin of
            1 ->
                [{RoleId, OnhookCoin, ExchangeLeft, NowTime}|List];
            _ ->
                List
        end
    end,
    DbCoinList = maps:fold(F, [], RoleMap),
    catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    %?PRINT("init State:~p~n", [State]),
    {ok, State}.

%% ====================
%% hanle_call
%% ====================


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({send_activity_onhook_list, RoleId, Sid}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_coin = OnhookCoin, onhook_module_list = OnhookModuleList} = OnhookRole,
    F = fun(OnhookModule, Acc) ->
        #onhook_module{module_id = ModId, sub_module = SubId, select_time = SelectTime, sub_behaviour_list = SubBehavourList} = OnhookModule,
        BehaviourList = [{BehaviourId, SelectTime1, Times1} ||#sub_behaviour{behaviour_id = BehaviourId, select_time = SelectTime1, times = Times1} <- SubBehavourList],
        [{ModId, SubId, SelectTime, BehaviourList}|Acc]
    end,
    SendList = lists:foldl(F, [], OnhookModuleList),
    DailyCoin = mod_daily:get_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_GET),
    lib_server_send:send_to_sid(Sid, pt_192, 19201, [DailyCoin, OnhookCoin, SendList]),
    ?PRINT("send_activity_onhook_list:~p~n", [{OnhookCoin, SendList}]),
    {noreply, State};

do_handle_cast({send_activity_onhook_record, RoleId, Sid}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_record_list = OnhookRecordList} = OnhookRole,
    F = fun(OnhookRecord, Acc) ->
        #onhook_record{module_id = ModId, sub_module = SubId, onhook_time = OnHookTime, result = Result, cost_coin = CostCoin, time = Time} = OnhookRecord,
        [{ModId, SubId, OnHookTime, Result, CostCoin, Time}|Acc]
    end,
    SendList = lists:foldl(F, [], OnhookRecordList),
    lib_server_send:send_to_sid(Sid, pt_192, 19206, [SendList]),
    ?PRINT("send_activity_onhook_record:~p~n", [SendList]),
    {noreply, State};

do_handle_cast({select_module, RoleId, ModId, SubId}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_module_list = OnhookModuleList} = OnhookRole,
    case lists:keyfind({ModId, SubId}, #onhook_module.key, OnhookModuleList) of
        false ->
            NowTime = utime:unixtime(),
            OnhookModule = make_onhook_module(ModId, SubId, NowTime),
            NewOnhookModuleList = [OnhookModule|OnhookModuleList],
            NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
            lib_activity_onhook:db_replace_onhook_modules(RoleId, OnhookModule),
            NewOnhookRole1 = save_onhook_coin(NewOnhookRole),
            %?PRINT("select_module NewOnhookRole:~p~n", [NewOnhookRole1]),
            NewRoleMap = maps:put(RoleId, NewOnhookRole1, RoleMap),
            %% 任务触发
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, finish_fake_client, [length(NewOnhookModuleList)]),
            %% 通知客户端
            lib_server_send:send_to_uid(RoleId, pt_192, 19202, [?SUCCESS, ModId, SubId]),
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        _ -> %% 已选择，不处理
            %% 通知客户端成功
            lib_server_send:send_to_uid(RoleId, pt_192, 19202, [?SUCCESS, ModId, SubId]),
            {noreply, State}
    end;

do_handle_cast({cancel_select_module, RoleId, ModId, SubId}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #activity_onhook_role{onhook_module_list = OnhookModuleList} = OnhookRole ->
            case lists:keyfind({ModId, SubId}, #onhook_module.key, OnhookModuleList) of
                #onhook_module{} ->
                    NewOnhookModuleList = lists:keydelete({ModId, SubId}, #onhook_module.key, OnhookModuleList),
                    NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
                    lib_activity_onhook:db_delete_onhook_modules(RoleId, ModId, SubId),
                    lib_activity_onhook:db_delete_onhook_modules_behaviour(RoleId, ModId, SubId),
                    NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap),
                    %?PRINT("cancel_select_module NewOnhookRole:~p~n", [NewOnhookRole]),
                    %% 通知客户端
                    lib_server_send:send_to_uid(RoleId, pt_192, 19203, [?SUCCESS, ModId, SubId]),
                    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
                _ ->
                    %% 通知客户端
                    lib_server_send:send_to_uid(RoleId, pt_192, 19203, [?SUCCESS, ModId, SubId]),
                    {noreply, State}
            end;
        _ -> %% 已选择，不处理
            %% 通知成功
            lib_server_send:send_to_uid(RoleId, pt_192, 19203, [?SUCCESS, ModId, SubId]),
            {noreply, State}
    end;

do_handle_cast({select_module_behaviour, RoleId, ModId, SubId, BehaviourId, Times}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_module_list = OnhookModuleList} = OnhookRole,
    case lists:keyfind({ModId, SubId}, #onhook_module.key, OnhookModuleList) of
        false ->
            NowTime = utime:unixtime(),
            OnhookModule = make_onhook_module(ModId, SubId, NowTime),
            SubBehaviour = make_onhook_module_behaviour(ModId, SubId, BehaviourId, NowTime, Times),
            NewOnhookModule = OnhookModule#onhook_module{sub_behaviour_list = [SubBehaviour]},
            NewOnhookModuleList = [NewOnhookModule|OnhookModuleList],
            NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
            lib_activity_onhook:db_replace_onhook_modules(RoleId, NewOnhookModule),
            lib_activity_onhook:db_replace_onhook_modules_behaviour(RoleId, ModId, SubId, BehaviourId, NowTime, Times),
            NewOnhookRole1 = save_onhook_coin(NewOnhookRole),
            NewRoleMap = maps:put(RoleId, NewOnhookRole1, RoleMap),
            %?PRINT("select_module_behaviour#1 NewOnhookRole:~p~n", [NewOnhookRole1]),
            %% 通知客户端
            lib_server_send:send_to_uid(RoleId, pt_192, 19204, [?SUCCESS, ModId, SubId, BehaviourId, Times]),
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        OnhookModule -> %%
            #onhook_module{sub_behaviour_list = SubBehaviourList} = OnhookModule,
            case lists:keyfind(BehaviourId, #sub_behaviour.behaviour_id, SubBehaviourList) of
                #sub_behaviour{select_time = OldSelectTime} when OldSelectTime > 0, ModId == ?MOD_GUILD_ACT ->
                    %% 通知客户端
                    lib_server_send:send_to_uid(RoleId, pt_192, 19204, [?SUCCESS, ModId, SubId, BehaviourId, Times]),
                     {noreply, State};
                _ ->
                    NowTime = utime:unixtime(),
                    SubBehaviour = make_onhook_module_behaviour(ModId, SubId, BehaviourId, NowTime, Times),
                    NewSubBehaviourList = lists:keystore(BehaviourId, #sub_behaviour.behaviour_id, SubBehaviourList, SubBehaviour),
                    NewOnhookModule = OnhookModule#onhook_module{sub_behaviour_list = NewSubBehaviourList},
                    lib_activity_onhook:db_replace_onhook_modules_behaviour(RoleId, ModId, SubId, BehaviourId, NowTime, Times),
                    NewOnhookModuleList = lists:keystore({ModId, SubId}, #onhook_module.key, OnhookModuleList, NewOnhookModule),
                    NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
                    NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap),
                    %?PRINT("select_module_behaviour#2 NewOnhookRole:~p~n", [NewOnhookRole]),
                    %% 通知客户端
                    lib_server_send:send_to_uid(RoleId, pt_192, 19204, [?SUCCESS, ModId, SubId, BehaviourId, Times]),
                    {noreply, State#activity_onhook_state{role_map = NewRoleMap}}
            end
    end;

do_handle_cast({cancel_select_module_behaviour, RoleId, ModId, SubId, BehaviourId}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #activity_onhook_role{onhook_module_list = OnhookModuleList} = OnhookRole ->
            case lists:keyfind({ModId, SubId}, #onhook_module.key, OnhookModuleList) of
                #onhook_module{sub_behaviour_list = SubBehaviourList} = OnhookModule ->
                    case lists:keyfind(BehaviourId, #sub_behaviour.behaviour_id, SubBehaviourList) of
                        #sub_behaviour{} ->
                            NewSubBehaviourList = lists:keydelete(BehaviourId, #sub_behaviour.behaviour_id, SubBehaviourList),
                            NewOnhookModule = OnhookModule#onhook_module{sub_behaviour_list = NewSubBehaviourList},
                            lib_activity_onhook:db_delete_onhook_modules_behaviour2(RoleId, ModId, SubId, BehaviourId),
                            NewOnhookModuleList = lists:keystore({ModId, SubId}, #onhook_module.key, OnhookModuleList, NewOnhookModule),
                            NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
                            NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap),
                            %?PRINT("cancel_select_module_behaviour NewOnhookRole:~p~n", [NewOnhookRole]),
                            %% 通知客户端
                            lib_server_send:send_to_uid(RoleId, pt_192, 19205, [?SUCCESS, ModId, SubId, BehaviourId]),
                            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
                        _ ->
                            %% 通知客户端
                            lib_server_send:send_to_uid(RoleId, pt_192, 19205, [?SUCCESS, ModId, SubId, BehaviourId]),
                            {noreply, State}
                    end;
                _ ->
                    %% 通知客户端
                    lib_server_send:send_to_uid(RoleId, pt_192, 19205, [?SUCCESS, ModId, SubId, BehaviourId]),
                    {noreply, State}
            end;
        _ -> %% 已选择，不处理
            %% 通知成功
            lib_server_send:send_to_uid(RoleId, pt_192, 19205, [?SUCCESS, ModId, SubId, BehaviourId]),
            {noreply, State}
    end;

do_handle_cast({clear_record}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    Timeout = utime:unixdate() - 7*?ONE_DAY_SECONDS,
    Fun = fun(#onhook_record{time = Time}) -> Time >= Timeout end,
    F = fun(RoleId, OnhookRole, {Map, List}) ->
        #activity_onhook_role{onhook_record_list = OnhookRecordList} = OnhookRole,
        {NewOnhookRecordList, Del} = lists:partition(Fun, OnhookRecordList),
        case Del =/= [] of
            true ->
                NewOnhookRole = OnhookRole#activity_onhook_role{onhook_record_list = NewOnhookRecordList},
                NewMap = maps:put(RoleId, NewOnhookRole, Map),
                {NewMap, Del++List};
            _ ->
                {Map, List}
        end
    end,
    {NewRoleMap, DelList} = maps:fold(F, {RoleMap, []}, RoleMap),
    case DelList =/= [] of
        true ->
            catch db:execute(io_lib:format("delete from role_activity_onhook_modules_record where time < ~p", [Timeout]));
        _ -> ok
    end,
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};


%% 周一重置
do_handle_cast({week_handle}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, OnhookRole, {Map, List, List2}) ->
        #activity_onhook_role{onhook_coin = OnHookCoin, exchange_left = ExchangeLeft, coin_utime = CoinUtime} = OnhookRole,
        case OnHookCoin > 50 of
            true ->
                NewOnHookCoin = 50,
                NewList = [{RoleId, NewOnHookCoin, ExchangeLeft, CoinUtime}|List],
                BGoldGet = round((OnHookCoin - 50) / 2),
                case BGoldGet > 0 of
                    true -> NewList2 = [{RoleId, BGoldGet}|List2]; _ -> NewList2 = List2
                end,
                NewOnhookRole = OnhookRole#activity_onhook_role{onhook_coin = NewOnHookCoin, coin_utime = NowTime},
                NewMap = maps:put(RoleId, NewOnhookRole, Map),
                {NewMap, NewList, NewList2};
            _ ->
                {Map, List, List2}
        end
    end,
    {NewRoleMap, DbCoinList, RoleRewardsSendList} = maps:fold(F, {RoleMap, [], []}, RoleMap),
    catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
    lib_activity_onhook:send_bgold_week_reset(RoleRewardsSendList),
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};


%% 增加托管值
do_handle_cast({exchange_onhook_coin, RoleId, ExchangeOnhookCoin}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_coin = OnHookCoin} = OnhookRole,
    case OnHookCoin >= ExchangeOnhookCoin of
        true ->
            BGoldGet = round(ExchangeOnhookCoin/2),
            Produce = #produce{type = exchange_onhook_coin, reward = [{?TYPE_BGOLD, 0, BGoldGet}], show_tips = ?SHOW_TIPS_1},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            NewOnHookCoin = OnHookCoin - ExchangeOnhookCoin,
            NewOnhookRole = OnhookRole#activity_onhook_role{onhook_coin = NewOnHookCoin, is_dirty_coin = 1},
            NewOnhookRole1 = save_onhook_coin(NewOnhookRole),
            NewRoleMap = maps:put(RoleId, NewOnhookRole1, RoleMap),
            %?PRINT("exchange_onhook_coin NewOnHookCoin:~p~n", [NewOnHookCoin]),
            lib_server_send:send_to_uid(RoleId, pt_192, 19207, [?SUCCESS, NewOnHookCoin, BGoldGet]),
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_192, 19207, [?ERRCODE(err192_onhook_coin_not_enough), 0, 0]),
            {noreply, State}
    end;

%% 增加托管值
do_handle_cast({add_activity_value, RoleId, OldTodayValue, AddValue}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    LivenessMax = lib_activity_onhook:get_max_value()*3,
    case OldTodayValue > LivenessMax of
        false -> %% 没超过每天最大值
            RealAdd = ?IF(AddValue+OldTodayValue > LivenessMax, LivenessMax-OldTodayValue, AddValue),
            OnhookRole = get_onhook_role(RoleId, RoleMap),
            #activity_onhook_role{onhook_coin = OnHookCoin, exchange_left = ExchangeLeft} = OnhookRole,
            AddCoin = (ExchangeLeft + RealAdd) div 3,
            mod_daily:plus_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_GET, AddCoin),
            NewExchangeLeft = (ExchangeLeft + RealAdd) rem 3,
            NewOnHookCoin = OnHookCoin + AddCoin,
            NewOnhookRole = OnhookRole#activity_onhook_role{onhook_coin = NewOnHookCoin, exchange_left = NewExchangeLeft, is_dirty_coin = 1},
            NewOnhookRole1 = save_onhook_coin(NewOnhookRole),
            NewRoleMap = maps:put(RoleId, NewOnhookRole1, RoleMap),
            DailyCoin = mod_daily:get_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_GET),
            lib_server_send:send_to_uid(RoleId, pt_192, 19208, [DailyCoin, NewOnHookCoin]),
            %?PRINT("add_activity_value {NewOnHookCoin, NewExchangeLeft}:~p~n", [{NewOnHookCoin, NewExchangeLeft}]),
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        _ ->
            {noreply, State}
    end;
%% gm增加托管值
do_handle_cast({gm_add_activity_value, RoleId, AddValue}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    OnhookRole = get_onhook_role(RoleId, RoleMap),
    #activity_onhook_role{onhook_coin = OnHookCoin} = OnhookRole,
    AddCoin = AddValue,
    NewOnHookCoin = OnHookCoin + AddCoin,
    NewOnhookRole = OnhookRole#activity_onhook_role{onhook_coin = NewOnHookCoin, is_dirty_coin = 1},
    NewOnhookRole1 = save_onhook_coin(NewOnhookRole),
    NewRoleMap = maps:put(RoleId, NewOnhookRole1, RoleMap),
    mod_daily:plus_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_GET, AddCoin),
    DailyCoin = mod_daily:get_count(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_GET),
    lib_server_send:send_to_uid(RoleId, pt_192, 19208, [DailyCoin, NewOnHookCoin]),
    %?PRINT("gm_add_activity_value NewOnHookCoin:~p~n", [NewOnHookCoin]),
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};

%% 每分钟扣除托管值
do_handle_cast({timer_del_coin}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, OnhookRole, {Map, List, List2, List3}) ->
        #activity_onhook_role{
            onhook_coin = OnhookCoin, exchange_left = ExchangeLeft,
            join_module = JoinModule, join_sub_module = JoinSubModule, onhook_state = OnhookState, onhook_start_time = OnhookStartTime,
            cost_coin = CostCoin, onhook_record_list = OnhookRecordList
        } = OnhookRole,
        case JoinModule > 0 andalso OnhookState == ?ACTIVITY_ONHOOK_START of
            true -> %% 活动挂机中，扣托管值
                case data_activity_onhook:get_module(JoinModule, JoinSubModule) of
                    #base_activity_onhook_module{cost_min = CostMin} ->
                        NewOnHookCoin = max(0, OnhookCoin - CostMin),
                        RealOnhookCoinCost = OnhookCoin - NewOnHookCoin,
                        NewCostCoin = CostCoin + RealOnhookCoinCost,
                        OnhookRole1 = OnhookRole#activity_onhook_role{onhook_coin = NewOnHookCoin, is_dirty_coin = 1, cost_coin = NewCostCoin},
                        case NewOnHookCoin == 0 of
                            true -> %% 托管值为0，结束挂机
                                %% 检查是否需要写托管币到数据库
                                OnhookRole2 = OnhookRole1#activity_onhook_role{is_dirty_coin = 0, coin_utime = NowTime},
                                %% 新的挂机记录
                                OnhookRecord = make_onhook_module_record(JoinModule, JoinSubModule, NowTime-OnhookStartTime, ?ERRCODE(err192_onhook_coin_not_enough), NewCostCoin, NowTime),
                                NewOnhookRole = OnhookRole2#activity_onhook_role{
                                    join_module = 0, join_sub_module = 0,
                                    onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0, cost_coin = 0,
                                    onhook_record_list = [OnhookRecord|OnhookRecordList]
                                },
                                lib_log_api:log_activity_onhook(RoleId, 2, JoinModule, JoinSubModule, ?ERRCODE(err192_onhook_coin_not_enough), NowTime-OnhookStartTime, NewCostCoin, NowTime),
                                NewList = [{RoleId, JoinModule, JoinSubModule}|List],
                                NewList2 = [{RoleId, 0, ExchangeLeft, NowTime}|List2],
                                NewList3 = [{RoleId, OnhookRecord}|List3];
                            _ ->
                                NewOnhookRole = OnhookRole1, NewList = List, NewList2 = List2, NewList3 = List3
                        end,
                        mod_daily:plus_count_offline(RoleId, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_CONSUME, RealOnhookCoinCost),
                        NewMap = maps:put(RoleId, NewOnhookRole, Map),
                        {NewMap, NewList, NewList2, NewList3};
                    _ ->
                        {Map, List, List2, List3}
                end;
            _ -> %%
                {Map, List, List2, List3}
        end
    end,
    {NewRoleMap, CancelOnhookRoleList, DbCoinList, DbRecordList} = maps:fold(F, {RoleMap, [], [], []}, RoleMap),
    CancelOnhookRoleList =/= [] andalso spawn(fun() -> lib_activity_onhook:end_activity_onhook(CancelOnhookRoleList, coin_out) end),
    catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
    catch lib_activity_onhook:db_replace_onhook_modules_record_batch(DbRecordList),
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};

do_handle_cast({act_start, ModuleId, SubId, Args}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, OnhookRole, {Map, List}) ->
        #activity_onhook_role{
            onhook_coin = OnHookCoin, join_module = JoinModule, join_sub_module = _JoinSubModule, onhook_state = OnhookState,
            onhook_start_time = OnhookStartTime, onhook_module_list = OnhookModuleList
        } = OnhookRole,
        case OnHookCoin > 0 andalso ( JoinModule == 0  orelse try_to_change_activity(OnhookState, OnhookStartTime, NowTime) ) of
            true ->
                case lists:keyfind({ModuleId, SubId}, #onhook_module.key, OnhookModuleList) of
                    #onhook_module{} = OnhoonModule ->
                        %% 检查一下玩家是否在线
                        case lib_player:get_player_info(RoleId, #player_status.online) of
                            false -> IsOnline = false;
                            OnlineFlag when OnlineFlag == ?ONLINE_ON -> IsOnline = true;
                            _ -> IsOnline = false
                        end,
                        case IsOnline of
                            false ->
                                NewOnhookRole = OnhookRole#activity_onhook_role{
                                    join_module = ModuleId, join_sub_module = SubId, cost_coin = 0,
                                    onhook_state = ?ACTIVITY_ONHOOK_READY, onhook_start_time = NowTime
                                },
                                NewMap = maps:put(RoleId, NewOnhookRole, Map),
                                {NewMap, [{RoleId, OnhoonModule}|List]};
                            _ -> %% 在线
                                {Map, List}
                        end;
                    _ -> %% 没选择
                        {Map, List}
                end;
            _ -> %% 已在其他活动挂机
                {Map, List}
        end
    end,
    {NewRoleMap, OnhookRoleList} = maps:fold(F, {RoleMap, []}, RoleMap),
    %?PRINT("act_start # OnhookRoleList:~p~n", [OnhookRoleList]),
    spawn(fun() ->
        timer:sleep(5000),
        lib_activity_onhook:start_activity_onhook(OnhookRoleList, ModuleId, SubId, Args) end),
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};

do_handle_cast({act_end, ModuleId, SubId}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    F = fun(RoleId, OnhookRole, {Map, List, List2, List3}) ->
        #activity_onhook_role{
            onhook_coin = OnhookCoin, exchange_left = ExchangeLeft, is_dirty_coin = IsDirtyCoin,
            join_module = JoinModule, join_sub_module = JoinSubModule, onhook_state = OnhookState,
            onhook_start_time = OnhookStartTime, cost_coin = CostCoin, onhook_record_list = OnhookRecordList
        } = OnhookRole,
        if
            JoinModule > 0 andalso JoinModule == ModuleId andalso JoinSubModule == SubId andalso OnhookState == ?ACTIVITY_ONHOOK_START ->
                %% 检查是否需要写托管币到数据库
                case IsDirtyCoin of
                    1 ->
                        OnhookRole1 = OnhookRole#activity_onhook_role{is_dirty_coin = 0, coin_utime = NowTime},
                        NewList2 = [{RoleId, OnhookCoin, ExchangeLeft, NowTime}|List2];
                    _ ->
                        OnhookRole1 = OnhookRole, NewList2 = List2
                end,
                %% 新的挂机记录
                OnhookRecord = make_onhook_module_record(ModuleId, SubId, NowTime-OnhookStartTime, 1, CostCoin, NowTime),
                NewOnhookRole = OnhookRole1#activity_onhook_role{
                    join_module = 0, join_sub_module = 0,
                    onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0, cost_coin = 0,
                    onhook_record_list = [OnhookRecord|OnhookRecordList]
                },
                lib_log_api:log_activity_onhook(RoleId, 2, ModuleId, SubId, 1, NowTime-OnhookStartTime, CostCoin, NowTime),
                NewMap = maps:put(RoleId, NewOnhookRole, Map),
                {NewMap, [{RoleId, ModuleId, SubId}|List], NewList2, [{RoleId, OnhookRecord}|List3]};
            JoinModule > 0 andalso JoinModule == ModuleId andalso JoinSubModule == SubId andalso OnhookState == ?ACTIVITY_ONHOOK_READY ->
                %% 活动结束，还处于准备状态，有可能已经处于挂机，状态没更改
                %% 托管币扣除
                case data_activity_onhook:get_module(JoinModule, JoinSubModule) of
                    #base_activity_onhook_module{cost_min = CostMin} -> ok;
                    _ -> CostMin = 1
                end,
                NewOnhookCoin = max(0, OnhookCoin - umath:floor(CostMin*(NowTime-OnhookStartTime)/60)),
                CostCoin1 = OnhookCoin - NewOnhookCoin,
                NewList2 = [{RoleId, NewOnhookCoin, ExchangeLeft, NowTime}|List2],
                %% 新的挂机记录
                OnhookRecord = make_onhook_module_record(ModuleId, SubId, NowTime-OnhookStartTime, 1, CostCoin1, NowTime),
                NewOnhookRole = OnhookRole#activity_onhook_role{
                    join_module = 0, join_sub_module = 0, onhook_coin = NewOnhookCoin, is_dirty_coin = 0, coin_utime = NowTime,
                    onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0, cost_coin = 0,
                    onhook_record_list = [OnhookRecord|OnhookRecordList]
                },
                lib_log_api:log_activity_onhook(RoleId, 3, ModuleId, SubId, 1, NowTime-OnhookStartTime, CostCoin1, NowTime),
                NewMap = maps:put(RoleId, NewOnhookRole, Map),
                {NewMap, [{RoleId, ModuleId, SubId}|List], NewList2, [{RoleId, OnhookRecord}|List3]};
            true -> %% 已在其他活动挂机
                {Map, List, List2, List3}
        end
    end,
    {NewRoleMap, CancelOnhookRoleList, DbCoinList, DbRecordList} = maps:fold(F, {RoleMap, [], [], []}, RoleMap),
    CancelOnhookRoleList =/= [] andalso spawn(fun() -> lib_activity_onhook:end_activity_onhook(CancelOnhookRoleList, act_end) end),
    %?PRINT("act_end #### CancelOnhookRoleList:~p~n", [CancelOnhookRoleList]),
    catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
    catch lib_activity_onhook:db_replace_onhook_modules_record_batch(DbRecordList),
    {noreply, State#activity_onhook_state{role_map = NewRoleMap}};


do_handle_cast({activity_onhook_ok, RoleId, ModuleId, SubId}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    case maps:get(RoleId, RoleMap, 0) of
        #activity_onhook_role{
            join_module = ModuleId, join_sub_module = SubId, onhook_state = ?ACTIVITY_ONHOOK_READY, onhook_module_list = OnhookModuleList
        } = OnhookRole ->
            NewOnhookRole = OnhookRole#activity_onhook_role{
                onhook_state = ?ACTIVITY_ONHOOK_START, onhook_start_time = NowTime
            },
            NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap),
            %?PRINT("activity_onhook_ok #### NewOnhookRole :~p~n", [NewOnhookRole]),
            lib_player_event:async_dispatch(RoleId, ?EVENT_FAKE_CLIENT, #callback_fake_client{module_id = ModuleId, sub_module = SubId}),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_task_api, finish_fake_client, [length(OnhookModuleList)]),
            lib_log_api:log_activity_onhook(RoleId, 1, ModuleId, SubId, 1, 0, 0, NowTime),
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        _ ->
            {noreply, State}
    end;


do_handle_cast({cancel_role_activity_onhook, RoleId, ModuleId, SubId, CancelCode}, State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    case maps:get(RoleId, RoleMap, 0) of
        #activity_onhook_role{
            onhook_coin = OnhookCoin, exchange_left = ExchangeLeft, is_dirty_coin = IsDirtyCoin,
            join_module = ModuleId, join_sub_module = SubId, onhook_start_time = OnhookStartTime, onhook_state = OnhookState,
            cost_coin = CostCoin, onhook_record_list = OnhookRecordList
        } = OnhookRole ->
            if
                OnhookState == ?ACTIVITY_ONHOOK_START andalso ModuleId > 0 -> %% 正在活动挂机中
                    %% 检查是否需要写托管币到数据库
                    case IsDirtyCoin of
                        1 ->
                            OnhookRole1 = OnhookRole#activity_onhook_role{is_dirty_coin = 0, coin_utime = NowTime},
                            DbCoinList = [{RoleId, OnhookCoin, ExchangeLeft, NowTime}];
                        _ ->
                            OnhookRole1 = OnhookRole, DbCoinList = []
                    end,
                    %% 新的挂机记录
                    case CostCoin > 0 of
                        true ->
                            OnhookRecord = make_onhook_module_record(ModuleId, SubId, NowTime-OnhookStartTime, CancelCode, CostCoin, NowTime),
                            NewOnhookRole = OnhookRole1#activity_onhook_role{
                                join_module = 0, join_sub_module = 0,
                                onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0, cost_coin = 0,
                                onhook_record_list = [OnhookRecord|OnhookRecordList]
                            },
                            lib_log_api:log_activity_onhook(RoleId, 2, ModuleId, SubId, CancelCode, NowTime-OnhookStartTime, CostCoin, NowTime),
                            catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
                            catch lib_activity_onhook:db_replace_onhook_modules_record_batch([{RoleId, OnhookRecord}]),
                            NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap);
                        _ ->
                            NewOnhookRole = OnhookRole1#activity_onhook_role{
                                join_module = 0, join_sub_module = 0,
                                onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0, cost_coin = 0
                            },
                            catch lib_activity_onhook:db_replace_replace_onhook_coin_batch(DbCoinList),
                            NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap)
                    end;
                OnhookState == ?ACTIVITY_ONHOOK_READY orelse OnhookState == ?ACTIVITY_ONHOOK_END -> %% 还未开始就结束,或者已经结束,不记录
                    lib_log_api:log_activity_onhook(RoleId, 1, ModuleId, SubId, CancelCode, 0, 0, NowTime),
                    NewOnhookRole = OnhookRole#activity_onhook_role{
                        join_module = 0, join_sub_module = 0, onhook_state = ?ACTIVITY_ONHOOK_END, onhook_start_time = 0
                    },
                    NewRoleMap = maps:put(RoleId, NewOnhookRole, RoleMap);
                true ->
                    NewRoleMap = RoleMap
            end,
            {noreply, State#activity_onhook_state{role_map = NewRoleMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info(_Info, State) -> {noreply, State}.

get_onhook_role(RoleId, RoleMap) ->
    case maps:get(RoleId, RoleMap, 0) of
        0 ->
            make_onhook_role(RoleId);
        Role -> Role
    end.


make_onhook_role(RoleId) ->
    #activity_onhook_role{
        role_id = RoleId
        , onhook_coin = 0      %% 初始50
        , coin_utime = utime:unixtime()
        , is_dirty_coin = 1
    }.

make_onhook_module(ModId, SubId, NowTime) ->
    #onhook_module{
        key = {ModId, SubId}
        , module_id = ModId
        , sub_module = SubId
        , select_time = NowTime
    }.

make_onhook_module_behaviour(_ModId, _SubId, BehaviourId, NowTime, Times) ->
    #sub_behaviour{
        behaviour_id = BehaviourId, select_time = NowTime, times = Times
    }.

%%
make_onhook_module_record(ModuleId, SubId, OnhookTime, Result, CostCoin, NowTime) ->
    #onhook_record{
        module_id = ModuleId
        , sub_module = SubId
        , onhook_time = max(0, OnhookTime)
        , result = Result
        , cost_coin = CostCoin
        , time = NowTime
    }.


try_to_change_activity(OnhookState, OnhookStartTime, NowTime) ->
    (OnhookState == ?ACTIVITY_ONHOOK_READY andalso (NowTime - OnhookStartTime) > 1800)  %% 如果在准备状态持续30分钟以上，切换活动
    orelse OnhookState == ?ACTIVITY_ONHOOK_END .


init_do() ->
    State1 = init_onhook_coin(),
    State2 = init_onhook_activity(State1),
    State3 = init_onhook_behaviour(State2),
    init_onhook_record(State3).


init_onhook_coin() ->
    case lib_activity_onhook:db_select_onhook_coin_all() of
        [] -> #activity_onhook_state{};
        DbList ->
            F = fun([RoleId, OnHookCoin, ExchangeLeft, CoinUtime], Map) ->
                OnhookRole = #activity_onhook_role{
                    role_id = RoleId, onhook_coin = OnHookCoin, exchange_left = ExchangeLeft, coin_utime = CoinUtime
                },
                maps:put(RoleId, OnhookRole, Map)
            end,
            RoleMap = lists:foldl(F, #{}, DbList),
            #activity_onhook_state{role_map = RoleMap}
    end.

init_onhook_activity(State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    case lib_activity_onhook:db_select_onhook_modules_all() of
        [] -> State;
        DbList ->
            F = fun([RoleId, ModuleId, SubMod, SelectTime], Map) ->
                OnhookRole = maps:get(RoleId, Map, #activity_onhook_role{}),
                OnhookModule = make_onhook_module(ModuleId, SubMod, SelectTime),
                NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = [OnhookModule|OnhookRole#activity_onhook_role.onhook_module_list]},
                maps:put(RoleId, NewOnhookRole, Map)
            end,
            NewRoleMap = lists:foldl(F, RoleMap, DbList),
            State#activity_onhook_state{role_map = NewRoleMap}
    end.

init_onhook_behaviour(State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    case lib_activity_onhook:db_select_onhook_modules_behaviour_all() of
        [] -> State;
        DbList ->
            F = fun([RoleId, ModuleId, SubMod, BehaviourId, SelectTime, Times], Map) ->
                OnhookRole = maps:get(RoleId, Map, #activity_onhook_role{}),
                #activity_onhook_role{onhook_module_list = OnhookModuleList} = OnhookRole,
                case lists:keyfind({ModuleId, SubMod}, #onhook_module.key, OnhookModuleList) of
                    #onhook_module{sub_behaviour_list = SubBehaviourList} = OnhookModule ->
                        NewOnhookModule = OnhookModule#onhook_module{
                            sub_behaviour_list = [#sub_behaviour{behaviour_id = BehaviourId, select_time = SelectTime, times = Times}|SubBehaviourList]
                        },
                        NewOnhookModuleList = lists:keyreplace({ModuleId, SubMod}, #onhook_module.key, OnhookModuleList, NewOnhookModule),
                        NewOnhookRole = OnhookRole#activity_onhook_role{onhook_module_list = NewOnhookModuleList},
                        maps:put(RoleId, NewOnhookRole, Map);
                    _ -> Map
                end
            end,
            NewRoleMap = lists:foldl(F, RoleMap, DbList),
            State#activity_onhook_state{role_map = NewRoleMap}
    end.

init_onhook_record(State) ->
    #activity_onhook_state{role_map = RoleMap} = State,
    case lib_activity_onhook:db_select_onhook_modules_record_all() of
        [] -> State;
        DbList ->
            F = fun([RoleId, ModuleId, SubMod, OnHookTime, Result, CostCoin, Time], Map) ->
                OnhookRecord = make_onhook_module_record(ModuleId, SubMod, OnHookTime, Result, CostCoin, Time),
                OnhookRole = maps:get(RoleId, Map, #activity_onhook_role{}),
                #activity_onhook_role{onhook_record_list = OnhookRecordList} = OnhookRole,
                NewOnhookRole = OnhookRole#activity_onhook_role{onhook_record_list = [OnhookRecord|OnhookRecordList]},
                maps:put(RoleId, NewOnhookRole, Map)
            end,
            NewRoleMap = lists:foldl(F, RoleMap, DbList),
            State#activity_onhook_state{role_map = NewRoleMap}
    end.


save_onhook_coin(OnhookRole) ->
    #activity_onhook_role{
        role_id = RoleId
        , onhook_coin = OnhookCoin
        , coin_utime = CoinUtime
        , exchange_left = ExchangeLeft
        , is_dirty_coin = IsDirtyCoin
    } = OnhookRole,
    case IsDirtyCoin of
        0 -> OnhookRole;
        _ ->
            lib_activity_onhook:db_replace_replace_onhook_coin_batch([{RoleId, OnhookCoin, ExchangeLeft, CoinUtime}]),
            OnhookRole#activity_onhook_role{is_dirty_coin = 0}
    end.
