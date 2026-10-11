-module(lib_luckey_wheel).

-compile(export_all).

-include("common.hrl").
-include("server.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").

send_act_info(Player, Type, SubType) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            mod_luckey_wheel_local:get_pool_reward(Type, SubType, Player#player_status.id);
        false -> 
            lib_server_send:send_to_uid(Player#player_status.id, pt_332, 33213, [Type, SubType, [], ?ERRCODE(err331_act_closed)])
    end,
    {ok, Player}.
%% 抽奖
get_bonus(Player, Type, SubType, Times, AutoBuy) ->
    #player_status{sid = Sid, id = RoleId, server_id = Server, server_num = ServerNum} = Player,
    if
        Times == 1 orelse Times == 10 orelse Times == 50 ->
            case lib_custom_act_api:is_open_act(Type, SubType) of
                true ->
                    case get_cost(Type, SubType, Times) of
                        {true, CostList} -> 
                            About = [Type, SubType, Times],
                            ConsumeType = get_consume_type(Type),
                            {PlayerA, RealCostList} = get_real_cost_list(Player, Type, SubType, CostList, ConsumeType, About),
                            [{_, _, RealNum}] = RealCostList,
                            Res = if
                                RealNum =:= 0 -> {true, PlayerA, CostList};
                                true ->
                                    case lib_goods_api:cost_objects_with_auto_buy(PlayerA, RealCostList, ConsumeType, About) of
                                        {true, TmpNewPlayer, _ObjectList} ->
                                            {true, TmpNewPlayer, CostList};
                                        Other -> Other
                                    end
                            end,
                            WrapperName = lib_player:get_wrap_role_name(Player),
                            case Res of
                                {true, NewPlayer, Cost} ->
                                    case mod_luckey_wheel_local:draw_reward(Type, SubType, Server, ServerNum, RoleId, WrapperName, Times, AutoBuy) of
                                        {ok, PoolReward, GradeIds} ->
                                            {ok, NewPS, SendList} = do_get_bonus(NewPlayer, Type, SubType, Cost, Times, AutoBuy, PoolReward, GradeIds),
                                            NewSendList = lists:reverse(SendList),
                                            lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, ?SUCCESS, NewSendList]),
                                            {ok, NewPS};        
                                        _Error ->
                                            Title = utext:get(3310064),Content = utext:get(3310065),
                                            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost),
                                            lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, ?ERRCODE(system_busy), []])
                                    end;
                                {false, Error, _NewPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, Error, []])
                            end;
                        {false, ErrorCode} ->
                            lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, ErrorCode, []])
                    end;
                false -> 
                    lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, ?ERRCODE(err331_act_closed), []])
            end;
        true ->
            lib_server_send:send_to_sid(Sid, pt_332, 33214, [Type, SubType, ?ERRCODE(err331_error_data), []])
    end.

get_real_cost_list(Player, Type, SubType, CostList, ConsumeType, About) ->
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    case lists:keyfind(time_limit_goods_id, 1, Conditions) of
        false -> {Player, CostList};
        {time_limit_goods_id, TimeLimitGoodsId} ->
            [{_, BagNum}] = lib_goods_do:goods_num([TimeLimitGoodsId]),
            [{GoodsType, GoodsId, Num}] = CostList,
            {NewNum, CostNum} = ?IF(Num > BagNum, {Num - BagNum, BagNum}, {0, Num}),
            case lib_goods_api:cost_object_list_with_check(Player, [{?TYPE_GOODS, TimeLimitGoodsId, CostNum}], ConsumeType, About) of
                {true, NewPlayer} ->
                    NewCostList = [{GoodsType, GoodsId, NewNum}],
                    {NewPlayer, NewCostList};
                _Other -> {Player, CostList}
            end
    end.

do_get_bonus(Player, Type, SubType, _CostList, _Times, _AutoBuy, PoolReward, GradeIds) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Player,
    {Rewards, SendList} = handle_reward(Player, GradeIds, Type, SubType, [], RoleName, RoleId, PoolReward, []), %%传闻处理
    ProduceType = get_produce_type(Type),
    Produce = #produce{type = ProduceType, subtype = Type, reward = Rewards, show_tips = ?SHOW_TIPS_0},
    NewPlayer = lib_goods_api:send_reward(Player, Produce),
    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards),
    {ok, NewPlayer, SendList}.
    

%% 处理需要发传闻的奖励
handle_reward(_Player, [], _, _, Rewards,_,_,_,SendList) -> {Rewards, SendList};
handle_reward(Player, [GradeId|GradeIds], Type, SubType, Rewards, RoleName, RoleId, PoolReward, SendList) -> 
    #figure{lv = Lv, sex = Sex, career = Career} = Player#player_status.figure,
    #custom_act_reward_cfg{condition = Conditions, reward = CfgReward} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId), 
    if
        CfgReward == [] ->
            Reward = calc_draw_pool_reward(Conditions, PoolReward);
        true ->
            #act_info{wlv = Wlv} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
            RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
            Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg)

            % ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
            % Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg)
    end,
    case Reward of
        [{_Gtype, _GoodsTypeId, _GNum}|_] ->
            % case lists:keyfind(tv, 1, Conditions) of
            %     {_, {ModuleId, Id}} -> 
            %         RealGtypeId = lib_custom_act_util:get_real_goodstypeid(GoodsTypeId, Gtype),
            %         lib_chat:send_TV({all}, ModuleId, Id, [RoleName, RoleId, RealGtypeId, Type, SubType]);
            %     _ -> 
            %         skip
            % end,
            Rare = lib_luckey_wheel_mod:get_conditions(rare, Conditions),
            handle_reward(Player, GradeIds, Type, SubType, Reward++Rewards, RoleName, RoleId, PoolReward, [{GradeId, Reward, Rare}|SendList]);
        _ ->
            handle_reward(Player, GradeIds, Type, SubType, Rewards, RoleName, RoleId, PoolReward, SendList)
    end.

get_cost(Type, SubType, Times) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Conditions} ->
            if
                Times =:= 1 ->
                    case lists:keyfind(one_cost, 1, Conditions) of
                        {one_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                Times =:= 10 ->
                    case lists:keyfind(ten_cost, 1, Conditions) of
                        {ten_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                Times =:= 50 ->
                    case lists:keyfind(fifty_cost, 1, Conditions) of
                        {fifty_cost, Cost} ->{true, Cost};
                        _ -> {false, ?MISSING_CONFIG}
                    end;
                true -> {false, ?ERRCODE(err331_error_data)}
            end;
        _ -> 
            {false, ?MISSING_CONFIG}
    end.

%% 获得产出类型
get_produce_type(?CUSTOM_ACT_TYPE_LUCKEY_WHEEL) -> luckey_wheel;
get_produce_type(_) -> unkown.

%% 获得消耗类型
get_consume_type(?CUSTOM_ACT_TYPE_LUCKEY_WHEEL) -> luckey_wheel;
get_consume_type(_) -> unkown.

calc_draw_pool_reward(RewardConditions, PoolReward) ->
    case lists:keyfind(reward, 1, RewardConditions) of
        {reward, Percent} -> 
            Fun = fun({Type, Gtype, Num}, Acc) ->
                [{Type, Gtype, (Num*Percent) div 100}|Acc]
            end,
            lists:foldl(Fun, [], PoolReward);
        _ -> 
            []
    end.