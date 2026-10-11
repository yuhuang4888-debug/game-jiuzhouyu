-module(lib_activation_draw).

% -compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_daily.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("activation_draw.hrl").

-export([
        send_act_info/3
        ,get_bonus/4
        ,get_activation_reward/4
        ,act_end/2
        ,day_clear/2
        ,handle_event/2
        ,four_clear/0
        ,four_clear/1
        ,zore_clear/0
        ,zore_clear/1
        ,get_stage_reward/3
    ]).

four_clear() ->
    % ?PRINT("~n============== Four~n",[]),
    Type = ?CUSTOM_ACT_TYPE_ACTIVATION,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType) ->
        mod_activation_draw:timer_clear(Type, SubType)
    end,
    lists:foreach(Fun, SubTypes),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_activation_draw, four_clear, []) || E <- OnlineRoles].

four_clear(Player) ->
    Type = ?CUSTOM_ACT_TYPE_ACTIVATION,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, Tem) ->
        {ok, NewTem} = send_act_info(Tem, Type, SubType),
        NewTem
    end,
    NewPlayer = lists:foldl(Fun, Player, SubTypes),
    {ok, NewPlayer}.

zore_clear() ->
    % ?PRINT("~n============== Zore~n",[]),
    Type = ?CUSTOM_ACT_TYPE_RECHARGE,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType) ->
        mod_activation_draw:timer_clear(Type, SubType)
    end,
    lists:foreach(Fun, SubTypes),
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_activation_draw, zore_clear, []) || E <- OnlineRoles].

zore_clear(Player) ->
    Type = ?CUSTOM_ACT_TYPE_RECHARGE,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, Tem) ->
        {ok, NewTem} = send_act_info(Tem, Type, SubType),
        NewTem
    end,
    NewPlayer = lists:foldl(Fun, Player, SubTypes),
    {ok, NewPlayer}.

handle_event(Player, #event_callback{type_id = ?EVENT_ADD_LIVENESS}) when is_record(Player, player_status) ->
    #player_status{source = Source, id = RoleId} = Player,
    Liveness = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度
    Type = ?CUSTOM_ACT_TYPE_ACTIVATION,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType) ->
        #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
        MaxActivation = get_value(activation, ActConditions, 0),
        SourceList = get_value(source_list, ActConditions, []),
        AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
        IsMember = lists:member(AtomSource, SourceList) orelse SourceList == [],
        if
            IsMember == true andalso MaxActivation >= Liveness ->
                mod_activation_draw:update_role_activation_state(Type, SubType, RoleId, Liveness, ActConditions);
            true ->
                skip
        end
    end,
    lists:foreach(Fun, SubTypes),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) when is_record(Player, player_status) ->
    #player_status{source = Source, id = RoleId} = Player,
    case CallBackData of
        #callback_recharge_data{money = Money} when  Money > 0 ->
            Type = ?CUSTOM_ACT_TYPE_RECHARGE,
            SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
            Fun = fun(SubType) ->
                #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                SourceList = get_value(source_list, ActConditions, []),
                AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
                IsMember = lists:member(AtomSource, SourceList) orelse SourceList == [],
                if
                    IsMember == true ->
                        mod_daily:plus_count(Player#player_status.id, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE, Money),
                        TodayMoney = mod_daily:get_count(Player#player_status.id, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE),
                        mod_activation_draw:update_role_activation_state(Type, SubType, RoleId, TodayMoney, ActConditions);
                    true ->
                        skip
                end
            end,
            lists:foreach(Fun, SubTypes);
        _ ->
            skip
    end,
    {ok, Player};

handle_event(PS, #event_callback{}) ->
    {ok, PS}.

send_act_info(Player, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            SourceList = get_value(source_list, ActConditions, []),
            AtomSource = erlang:list_to_atom(util:make_sure_list(Player#player_status.source)),
            IsMember = lists:member(AtomSource, SourceList),
            if
                IsMember == true orelse SourceList == [] ->
                    RoleData = get_role_data(Player#player_status.id, Type),
                    % ?PRINT("Activation:~p~n",[RoleData]),
                    mod_activation_draw:get_log(Type, SubType, Player#player_status.id, RoleData);
                true ->
                    lib_server_send:send_to_uid(Player#player_status.id, pt_332, 33218, [Type, SubType, 0, [], []])
            end;
        false -> 
            lib_server_send:send_to_uid(Player#player_status.id, pt_332, 33218, [Type, SubType, 0, [], []])
    end,
    {ok, Player}.

get_bonus(Player, Type, SubType, Times) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    SourceList = get_value(source_list, ActConditions, []),
    AtomSource = erlang:list_to_atom(util:make_sure_list(Player#player_status.source)),
    IsMember = lists:member(AtomSource, SourceList) orelse SourceList == [],
    if
        IsMember == true andalso (Times == 1 orelse Times == 10) ->
            #player_status{sid = Sid, id = RoleId, figure = #figure{name = _RoleName}, server_id = _Server, server_num = _ServerNum} = Player,
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    case get_cost(Type, SubType, Times) of
                        {true, CostList} -> 
                            About = [Type, SubType, Times],
                            ConsumeType = get_consume_type(Type),
                            Res = case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
                                    {true, TmpNewPlayer} ->
                                        {true, TmpNewPlayer, CostList};
                                    Other ->
                                        Other
                                end,
                            ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
                            #act_info{
                                stime = STime,
                                etime = ETime
                            } = ActInfo,
                            RechargeNum = lib_recharge_data:get_my_recharge_rmb_between(RoleId, STime, ETime),
                            case Res of
                                {true, NewPlayer, Cost} ->
                                    case mod_activation_draw:draw_reward(Type, SubType, RoleId, Times, RechargeNum) of
                                        {ok, GradeIdList} ->
                                            {ok, NewPS, SendList} = do_get_bonus(NewPlayer, Type, SubType, Cost, GradeIdList),
                                            % ?PRINT("======== SendList:~p~n",[SendList]),
                                            lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?SUCCESS, SendList]),
                                            {ok, NewPS};        
                                        _Error ->
                                            % ?PRINT("======== _Error:~p~n",[_Error]),
                                            Title = utext:get(3310064),Content = utext:get(3310065),
                                            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost),
                                            lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?ERRCODE(system_busy), []])
                                    end;
                                {false, Error, _NewPlayer} ->
                                    % ?PRINT("======== Error:~p~n",[Error]),
                                    lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, Error, []])
                            end;
                        {false, ErrorCode} ->
                            % ?PRINT("======== ErrorCode:~p~n",[ErrorCode]),
                            lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ErrorCode, []])
                    end;
                false -> 
                    % ?PRINT("======== ErrorCode:~p~n",[err331_act_closed]),
                    lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?ERRCODE(err331_act_closed), []])
            end;
        true ->
            ErrorCode = if 
                IsMember == false ->
                    ?ERRCODE(err331_act_closed);
                true ->
                    ?ERRCODE(data_error)
            end,
            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33220, [Type, SubType, ErrorCode, []])
    end.
% %% 抽奖
% get_bonus(Player, Type, SubType, _Times) ->
%     #player_status{sid = Sid, id = RoleId, figure = #figure{name = _RoleName}, server_id = _Server, server_num = _ServerNum} = Player,
%     case lib_custom_act_api:is_open_act(Type, SubType) of
%         true ->
%             case get_cost(Type, SubType) of
%                 {true, CostList} -> 
%                     About = [Type, SubType, _Times],
%                     ConsumeType = get_consume_type(Type),
%                     Res = case lib_goods_api:cost_object_list_with_check(Player, CostList, ConsumeType, About) of
%                             {true, TmpNewPlayer} ->
%                                 {true, TmpNewPlayer, CostList};
%                             Other ->
%                                 Other
%                         end,
%                     case Res of
%                         {true, NewPlayer, Cost} ->
%                             case mod_activation_draw:draw_reward(Type, SubType, RoleId) of
%                                 {ok, GradeId} ->
%                                     {ok, NewPS, SendList} = do_get_bonus(NewPlayer, Type, SubType, Cost, [GradeId]),
%                                     lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?SUCCESS, SendList]),
%                                     {ok, NewPS};        
%                                 _Error ->
%                                     Title = utext:get(3310064),Content = utext:get(3310065),
%                                     lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost),
%                                     lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?ERRCODE(system_busy), []])
%                             end;
%                         {false, Error, _NewPlayer} ->
%                             lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, Error, []])
%                     end;
%                 {false, ErrorCode} ->
%                     lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ErrorCode, []])
%             end;
%         false -> 
%             lib_server_send:send_to_sid(Sid, pt_332, 33220, [Type, SubType, ?ERRCODE(err331_act_closed), []])
%     end.

get_activation_reward(Player, Type, SubType, Id) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    SourceList = get_value(source_list, ActConditions, []),
    AtomSource = erlang:list_to_atom(util:make_sure_list(Player#player_status.source)),
    IsMember = lists:member(AtomSource, SourceList) orelse SourceList == [],
    case lib_custom_act_api:is_open_act(Type, SubType) andalso IsMember == true of
        true ->
            #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            % Activation = mod_daily:get_count(Player#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
            case mod_activation_draw:get_role_activation_state(Type, SubType, Player#player_status.id, Id) of
                {ok, State, StateList} when State =< 1 -> %% 已达成未领取
                    case get_stage_reward(Type, Id, ActConditions) of
                        [] ->
                            % ?PRINT("======== MISSING_CONFIG:~n",[]),
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, [Type, SubType, ?MISSING_CONFIG, []]);
                        Reward ->
                            ProduceType = get_stage_produce_type(Type),
                            Produce = #produce{type = ProduceType, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
                            NewStateList = lists:keystore(Id, 1, StateList, {Id, 2}),
                            % ?PRINT("======== 1:~p~n",[1]),
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, [Type, SubType, NewStateList, ?SUCCESS, Reward]),
                            NewPlayer = lib_goods_api:send_reward(Player, Produce),
                            {ok, NewPlayer}
                    end;
                {ok, State, _} when State == 2 -> %% 已领取
                    % ?PRINT("======== err331_already_get_reward:~n",[]),
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, 
                        [Type, SubType, ?ERRCODE(err331_already_get_reward), []]);
                _ ->
                    % ?PRINT("======== err331_can_not_recieve:~n",[]),
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, 
                        [Type, SubType, ?ERRCODE(err331_can_not_recieve), []])
            end;
            %     true ->
            %         ?PRINT("======== err331_act_activation_not_enougth:~n",[]),
            %         lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, 
            %                 [Type, SubType, ?ERRCODE(err331_act_activation_not_enougth), []])
            % end;
        _ ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33219, [Type, SubType, ?ERRCODE(err331_act_closed), []])
    end.

act_end(Type, SubType) ->
    mod_custom_act_record:cast({remove_log, Type, SubType}),
    mod_activation_draw_kf:cast_center([{remove_log, config:get_server_id(), Type, SubType}]),
    mod_activation_draw:act_end(Type, SubType).

day_clear(Type, SubType) ->
    mod_activation_draw:day_clear(Type, SubType).

do_get_bonus(Player, Type, SubType, _CostList, [GradeId]) ->
    {Rewards, SendList} = handle_reward(Player, [GradeId], Type, SubType, [], []), %%传闻处理
    ProduceType = get_produce_type(Type),
    Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    lib_log_api:log_custom_act_reward(NewPlayer, Type, SubType, GradeId, Rewards),
    {ok, NewPlayer, SendList};
do_get_bonus(Player, Type, SubType, _CostList, GradeIdList) when is_list(GradeIdList) ->
    #player_status{id = RoleId} = Player,
    {Rewards, SendList} = handle_reward(Player, GradeIdList, Type, SubType, [], []), %%传闻处理
    ProduceType = get_produce_type(Type),
    Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    ta_agent_fire:log_custom_act_reward(NewPlayer, [Type, SubType, GradeIdList]),
    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards),
    {ok, NewPlayer, SendList};
do_get_bonus(Player, _, _, _, _) -> {ok, Player, []}.
    

%% 处理需要发传闻的奖励
handle_reward(_, [], _, _, Rewards, SendList) -> {Rewards, SendList};
handle_reward(Player, [GradeId|T], Type, SubType, Rewards, SendList)-> 
    #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum} = Player,
    #figure{lv = Lv, sex = Sex, career = Career, name = RoleName} = Player#player_status.figure,
    #custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId), 
    #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
    Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
    case Reward of
        [{_Gtype, _GoodsTypeId, _GNum}|_] ->
            Rare = get_value(rare, Conditions, 0),
            case lists:keyfind(tv, 1, Conditions) of
                {_, {ModuleId, Id}} -> 
                    RealGtypeId = lib_custom_act_util:get_real_goodstypeid(_GoodsTypeId, _Gtype),
                    if
                        Rare == 3 ->
                            Args = [RoleName, RoleId, RealGtypeId, _GNum, Type, SubType],
                            TvArgs = [{all}, ModuleId, Id, Args],
                            mod_activation_draw_kf:cast_center([{send_tv, TvArgs, Type, SubType}]);
                        true ->
                            lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, RealGtypeId, _GNum, Type, SubType])
                    end;
                _ -> 
                    skip
            end,
            % Activation = mod_daily:get_count(Player#player_status.id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
            mod_activation_draw:save_log(Type, SubType, GradeId, RoleId, RoleName, Reward),
            OpenDay = util:get_open_day(),
            % ?PRINT("======== Rare:~p~n",[Rare]),
            if
                Rare >= 1 ->
                    if
                        OpenDay > 1 ->
                            mod_activation_draw_kf:cast_center([{save_log_and_notice, ServerId, ServerNum, RoleId, Type, SubType, RoleName, Reward}]);
                        true ->
                            mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward})
                    end;
                true ->    
                    skip
            end,
            handle_reward(Player, T, Type, SubType, Rewards++Reward, [{GradeId, Reward, Rare}|SendList]);
        _ ->
            handle_reward(Player, T, Type, SubType, Rewards, SendList)
    end.

% get_cost(Type, SubType) ->
%     case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
%         #custom_act_cfg{condition = Conditions} ->
%             case lists:keyfind(cost, 1, Conditions) of
%                 {cost, Cost} ->{true, Cost};
%                 _ -> {false, ?MISSING_CONFIG}
%             end;
%         _ -> 
%             {false, ?MISSING_CONFIG}
%     end.

get_cost(Type, SubType, Times) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            case lists:keyfind(cost, 1, Conditions) of
                {cost, Cost} ->
                    Fun = fun({T, G, Num}, Acc) ->
                        [{T, G, Num*Times}|Acc]
                    end,
                    RealCost = lists:foldl(Fun, [], Cost),
                    {true, RealCost};
                _ -> {false, ?MISSING_CONFIG}
            end;
        _ -> 
            {false, ?MISSING_CONFIG}
    end.

%% 获得产出类型
get_produce_type(?CUSTOM_ACT_TYPE_ACTIVATION) -> activation_draw;
get_produce_type(?CUSTOM_ACT_TYPE_RECHARGE) -> recharge_draw;
get_produce_type(_) -> unkown.

%% 获得消耗类型
get_consume_type(?CUSTOM_ACT_TYPE_ACTIVATION) -> activation_draw;
get_consume_type(?CUSTOM_ACT_TYPE_RECHARGE) -> recharge_draw;
get_consume_type(_) -> unkown.

get_stage_produce_type(?CUSTOM_ACT_TYPE_ACTIVATION) -> activation_reward;
get_stage_produce_type(?CUSTOM_ACT_TYPE_RECHARGE) -> recharge_reward;
get_stage_produce_type(_) -> unkown.

get_stage_reward(?CUSTOM_ACT_TYPE_ACTIVATION, _Id, Conditions) ->
    case lists:keyfind(activation_reward, 1, Conditions) of
        {_, Reward} -> Reward;
        _ -> []
    end;
get_stage_reward(?CUSTOM_ACT_TYPE_RECHARGE, Id, Conditions) ->
    case lists:keyfind(recharge_reward, 1, Conditions) of
        {_, StageList} -> 
            get_value(Id, StageList, []);
        _ -> []
    end;
get_stage_reward(_,_,_) -> [].

get_role_data(RoleId, ?CUSTOM_ACT_TYPE_ACTIVATION) ->
    mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY);
get_role_data(RoleId, ?CUSTOM_ACT_TYPE_RECHARGE) ->
    mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE);
get_role_data(_, _) -> 0.

get_value(Key, List, Default) ->
    case lists:keyfind(Key, 1, List) of
        {Key, Value} -> Value;
        _ -> Default
    end.
        
