%% ---------------------------------------------------------------------------
%% @doc lib_recharge_rebate_act.erl

%% @author  cxd
%% @email 
%% @since  
%% @deprecated 充值大回馈(多倍充值)
%% ---------------------------------------------------------------------------
-module(lib_recharge_rebate_act).

-compile(export_all).

-include("server.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("language.hrl").
-include("recharge_act.hrl").
-include("predefine.hrl").
-include("def_recharge.hrl").
-include("rec_recharge.hrl").



%% 充值
handle_recharge(Player, Product, Gold) ->
    IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
    if
        IsTrigger -> %% 只要常规充值才会触发
            Type = ?CUSTOM_ACT_TYPE_RECHARGE_REBATE,
            SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
            F = fun(SubType, TmpPlayer) ->
                CustomActData = get_recharge_rebate(TmpPlayer, Type, SubType),
                handle_recharge_do(TmpPlayer, CustomActData, Gold)
            end,
            lists:foldl(F, Player, SubTypeList);
        true ->
            Player
    end.

handle_recharge_do(Player, CustomActData, Gold) ->
    #custom_act_data{type = Type, subtype = SubType, data = ActData} = CustomActData,
    #custom_act_cfg{condition = Condition} = data_custom_act:get_act_info(Type, SubType),
    #recharge_rebate{rebate_times = RebateTimes} = ActData,
    case lists:keyfind(threshold, 1, Condition) of 
        {_, Threshold} when Gold=<Threshold andalso RebateTimes>0 ->
            case lists:keyfind(rebate_ratio, 1, Condition) of 
                {_, Ratio} -> ok; _ -> Ratio = 0
            end,
            case lists:keyfind(gold_type, 1, Condition) of 
                {_, gold} -> 
                    Reward = [{?TYPE_GOLD, 0, umath:ceil(Gold*Ratio/100)}];
                _ -> 
                    Reward = [{?TYPE_BGOLD, 0, umath:ceil(Gold*Ratio/100)}]
            end,
            %% 邮件
            lib_mail_api:send_sys_mail([Player#player_status.id], utext:get(3310097), utext:get(3310098), Reward),
            NActData = ActData#recharge_rebate{rebate_times = RebateTimes-1, utime = utime:unixtime()},
            NCustomActData = CustomActData#custom_act_data{data = NActData},
            lib_custom_act:db_save_custom_act_data(Player, NCustomActData),
            #player_status{status_custom_act = CustomAct} = Player,
            DataMap = CustomAct#status_custom_act.data_map,
            NewDataMap = maps:put({Type, SubType}, NCustomActData, DataMap),
            NewCustomAct = CustomAct#status_custom_act{data_map = NewDataMap},
            NewPlayer = Player#player_status{status_custom_act = NewCustomAct},
            send_recharge_rebate_info(NewPlayer, NCustomActData),
            NewPlayer;
        _ ->
            Player
    end.
    
%% 界面数据
send_recharge_rebate_info(Player, CustomActData) ->
    #custom_act_data{type = Type, subtype = SubType, data = ActData} = CustomActData,
    #recharge_rebate{rebate_times = RebateTimes} = ActData,
    % ?PRINT("rebate_info ~p~n", [RebateTimes]),
    {ok, Bin} = pt_332:write(33247, [Type, SubType, RebateTimes]),
    lib_server_send:send_to_sid(Player#player_status.sid, Bin).

%%  获取充值返利信息
get_recharge_rebate(Player, Type, SubType) ->
    #player_status{status_custom_act = CustomAct} = Player,
    #status_custom_act{data_map = DataMap} = CustomAct,
    Key = {Type, SubType},
    #custom_act_cfg{clear_type=ClearRule} = Act = data_custom_act:get_act_info(Type, SubType),
    case maps:get(Key, DataMap, []) of
        Data = #custom_act_data{data = #recharge_rebate{utime=UTime}} -> 
            case ClearRule == 2 of %% 0点清理
                true ->
                    case utime:is_today(UTime) of 
                        true ->
                            Data;
                        _ -> get_recharge_rebate_new(Player, Act)
                    end;
                _ ->
                    Data
            end;
        _ -> 
            get_recharge_rebate_new(Player, Act)
    end.

get_recharge_rebate_new(_Player, Act) ->
    #custom_act_cfg{type = Type, subtype = SubType, condition = Condition} = Act,
    case lists:keyfind(rebate_times, 1, Condition) of 
        {rebate_times, RebateTimes} -> ok;
        _ -> RebateTimes = 0
    end,
    ActData = #recharge_rebate{rebate_times = RebateTimes, utime = utime:unixtime()},   
    #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = ActData}.

%% 清理数据
clear_data(Type, SubType) ->
    %% 清除数据库
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_recharge_rebate_act, clear_data, [Type, SubType]) || E <- OnlineRoles].

clear_data(Player, Type, SubType) -> %% 清除在线玩家数据，保持数据同步
    NewPlayer = lib_custom_act:delete_act_data_to_player_without_db(Player, Type, SubType),
    {ok, NewPlayer}.