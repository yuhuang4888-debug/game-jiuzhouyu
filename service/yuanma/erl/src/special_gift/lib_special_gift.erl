%%-----------------------------------------------------------------------------
%% @Module  :       lib_specail_gift
%% @Author  :       cxd
%% @Email   :       
%% @Created :       2020-5-13
%% @Description:    超值特惠礼包
%%-----------------------------------------------------------------------------
-module(lib_special_gift).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").

-compile([export_all]).


%% -------------------------- 界面相关 --------------------------
%% 奖励状态
send_reward_status(Player, ActInfo) ->
    #act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    %% 对于额外奖励，奖励状态要额外计算
    F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}], RewardCfg) of 
                    true ->
                        %% 计算奖励的领取状态
                        ReceiveTimes = count_receive_times(Type, SubType, GradeId, Player#player_status.status_custom_act#status_custom_act.reward_map),
                        Status = count_reward_status(Player, ActInfo, RewardCfg, ReceiveTimes),
                        ConditionStr = util:term_to_string(Condition),
                        RewardStr = util:term_to_string(Reward),
                        [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
        end,
    PackList = lists:foldl(F, [], GradeIds),
    % ?MYLOG("cxd_special", "PackList:~p", [PackList]),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData).


%% -------------------------- 领取奖励相关 --------------------------
%% 计算奖励获取次数
count_receive_times(Type, SubType, GradeId, RewardMap) ->
    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
        #reward_status{receive_times = ReceiveTimes} ->
            ReceiveTimes;
        _ -> 
            0
    end.

%% 计算奖励状态
count_reward_status(Player, ActInfo, #custom_act_reward_cfg{condition = Condition} = RewardCfg, ReceiveTimes) ->
    %% 额外奖励的可领取状态取决于当前子活动对应的档次奖励是否已经领取完毕
    case lists:keyfind(extra_reward, 1, Condition) of
        {extra_reward} -> %% 额外奖励领取状态
            count_extra_reward_status(Player, ActInfo, ReceiveTimes);
        _ -> 
            lib_custom_act:count_reward_status(Player, ActInfo, RewardCfg)
    end.

%% 计算额外奖励的获取状态
count_extra_reward_status(Player, ActInfo, ReceiveTimes) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(grade_ids, 1, Condition) of
                {grade_ids, GradeIds} when is_list(GradeIds) ->
                    check_all_grades_finish(Player, ActInfo, GradeIds, ReceiveTimes);
                _ ->
                    ?ERR("grade_ids cfg miss", []),
                    ?ACT_REWARD_HAS_GET
            end;
        _ ->
            ?ERR("act cfg miss", []),
            ?ACT_REWARD_HAS_GET
    end.

%% 检查所有的档次奖励是否领取
check_all_grades_finish(Player, ActInfo, [GradeId | GradeIds], ReceiveTimes) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case lib_custom_act_check:check_reward_receive_times(Player, ActInfo, RewardCfg) of
        false ->
            check_all_grades_finish(Player, ActInfo, GradeIds, ReceiveTimes);
        _ ->
            ?ACT_REWARD_CAN_NOT_GET
    end;
check_all_grades_finish(_Player, _ActInfo, [], ReceiveTimes) ->
    case ReceiveTimes == 0 of
        true ->
            ?ACT_REWARD_CAN_GET;
        false ->
            ?ACT_REWARD_HAS_GET
    end.
    
%% 检测消耗物品是否充足
check_cost_list(Ps, Condition) ->
    {cost_type, CostType} = ulists:keyfind(cost_type, 1, Condition, {cost_type, 0}),
    case lib_special_gift:get_cost_list(CostType, Condition) of
        {true, Cost} ->
            lib_goods_api:check_object_list(Ps, Cost);
        {false, ErrCode} ->
            {false, ErrCode}
    end.

%% 获取消耗列表
get_cost_list(CostType, Condition) ->
    case lists:keyfind(price, 1, Condition) of
        {price, _, Cost, _} ->
            case CostType of
                1 -> {true, [{?TYPE_GOLD, ?GOODS_ID_GOLD, Cost}]};
                2 -> {true, [{?TYPE_BGOLD, ?GOODS_ID_BGOLD, Cost}]};
                3 -> {true, []};
                4 -> {true, []};
                _ -> {false, ?MISSING_CONFIG}
            end;
        _ ->
            {false, ?MISSING_CONFIG}
    end.

%% 发送奖励
send_reward(#player_status{id = RoleId} = Player, Type, SubType, GradeId, RewardList) when is_record(Player, player_status) ->
    send_reward_help(RoleId, RewardList),
    lib_log_api:log_custom_act_reward(Player, Type, SubType, GradeId, RewardList);
send_reward(RoleId, Type, SubType, GradeId, RewardList) ->
    send_reward_help(RoleId, RewardList),
    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList).

send_reward_help(RoleId, RewardList) ->
    Produce = #produce{title = utext:get(3310083), content = utext:get(3310084), type = special_gift_act, reward = RewardList, show_tips = 1},
    lib_goods_api:send_reward_by_id(Produce, RoleId),
    ok.

%% 发送奖励后的触发
af_send_reward(Ps, Type, SubType, Condition) ->
    pp_custom_act:handle(33104, Ps, [Type, SubType]),
    RoleName = lib_player:get_wrap_role_name(Ps),
    lib_special_gift:send_tv(Condition, RoleName, Type, SubType).

%% 发送传闻
send_tv(Condition, RoleName, Type, SubType) -> 
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of 
        #custom_act_cfg{name = Name} -> 
            ok;
        _ ->
            ?ERR("act name cfg miss, Type:~p, SubTpye:~p", [Type, SubType]),
            Name = <<"">>
    end,
    case lists:keyfind(tv, 1, Condition) of
        {tv, IsSendTv} when IsSendTv == 1 ->
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 58, [RoleName, Name, Type, SubType]);
        _ ->
            skip
    end.


%% 充值购买礼包处理
handle_product(Player, ProductId) ->
    Type = ?CUSTOM_ACT_TYPE_SPECIAL_GIFT,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    SubTypeF = fun(SubType, SubTypeFPlayer) ->
        GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
        GradeF = fun(GradeId, GradeFPlayer) ->
            TmpGradeId = match_grade_id_with_product_id(Type, SubType, GradeId, ProductId),
            case GradeId == TmpGradeId of 
                true -> %% 找到了商品id对应的奖励id
                    recharge_send_reward(GradeFPlayer, Type, SubType, GradeId);
                _ ->
                    GradeFPlayer
            end
        end,
        lists:foldl(GradeF, SubTypeFPlayer, GradeIds)
    end,
    LastPlayer = lists:foldl(SubTypeF, Player, SubTypes),
    {ok, LastPlayer}.

%% 直购发放奖励
recharge_send_reward(Player, Type, SubType, GradeId) ->
    #player_status{id = RoleId, status_custom_act = #status_custom_act{reward_map = RewardMap}} = Player,
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    case check_recharge_send_reward(Type, SubType, RewardMap, RewardCfg) of 
        {true, NewReceiveTimes, ActInfo} ->
            #custom_act_reward_cfg{reward = RewardList, condition = RewardCondition} = RewardCfg,
            case lists:keyfind(cost_type, 1, RewardCondition) of 
                {cost_type, CostType} ->
                    if
                        CostType == 4 -> %% 小额礼包直购
                            Player1 = lib_custom_act:update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
                            lib_special_gift:send_reward(RoleId, Type, SubType, GradeId, RewardList),
                            lib_special_gift:af_send_reward(Player1, Type, SubType, RewardCondition),
                            Player1;
                        CostType == 3 -> %% 超值特惠rmb直购，直接发奖励
                            Player1 = lib_custom_act:update_receive_times(Player, Type, SubType, GradeId, NewReceiveTimes),
                            ReceiveTimes = lib_special_gift:count_receive_times(Type, SubType, GradeId, Player1#player_status.status_custom_act#status_custom_act.reward_map),
                            RewardStatus = lib_special_gift:count_reward_status(Player1, ActInfo, RewardCfg, ReceiveTimes),
                            case RewardStatus of
                                ?ACT_REWARD_CAN_GET ->
                                    lib_special_gift:db_replace_role_special_gift_extra_reward(RoleId, Type, SubType);
                                _ ->
                                    skip
                            end,
                            lib_special_gift:send_reward(RoleId, Type, SubType, GradeId, RewardList),
                            lib_special_gift:af_send_reward(Player1, Type, SubType, RewardCondition),
                            Player1;
                        true ->
                            Player
                    end;
                _ ->
                    Player
           end;         
        false ->
            Player
    end.

%% 检测直购发奖励
check_recharge_send_reward(Type, SubType, RewardMap, RewardCfg) when is_record(RewardCfg, custom_act_reward_cfg) ->
    #custom_act_reward_cfg{grade = GradeId, condition = Condition} = RewardCfg,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            stime = Stime,
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            case lists:keyfind(limit_buy, 1, Condition) of
                false -> false;
                {limit_buy, LimitBuyTimes} ->
                    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{utime = Utime, receive_times = ReceiveTimes} ->
                            case Utime >= Stime andalso Utime =< Etime andalso ReceiveTimes >= LimitBuyTimes of
                                true -> false;
                                false -> {true, ReceiveTimes + 1, ActInfo}
                            end;
                        _ -> {true, 1, ActInfo}
                    end
            end;
        _ ->
            false
    end;
check_recharge_send_reward(_, _, _, _) ->
    false.


%% 匹配配置了商品id的奖励
match_grade_id_with_product_id(Type, SubType, GradeId, ProductId) ->
    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
        #custom_act_reward_cfg{condition = Condition} ->
            case lists:keyfind(recharge_id, 1, Condition) of
                {recharge_id, ProductId} ->
                    GradeId;
                _ ->
                    0
            end;
        _ ->
            ?ERR("act cfg miss", []),
            0
    end.

    


%% -------------------------- 活动结束，清理相关 --------------------------
%% 活动0点清理
daily_clear(ActInfo) ->
    #act_info{key = {Type, SubType}} = ActInfo,
    Sql = io_lib:format(<<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>, [Type, SubType]),
    db:execute(Sql),
    act_end_reset(Type, SubType).

%% 活动结束
act_end(ActStatus, Type, SubType) ->
    case ActStatus of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lists:keyfind(extra_grade_id, 1, Condition) of
                false -> %% 普通类型活动要清理数据
                    Sql = io_lib:format(<<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>, [Type, SubType]),
                    db:execute(Sql),
                    act_end_reset(Type, SubType);
                {extra_grade_id, ExtraGradeId} -> %% 直购活动清理数据 + 结算
                    DbRoleIds = db_select_role_special_gift_extra_reward(Type, SubType),
                    if
                        DbRoleIds =:= [] ->
                            act_end_reset(Type, SubType);
                        is_list(DbRoleIds) andalso DbRoleIds =/= [] ->
                            #custom_act_reward_cfg{reward = RewardList} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, ExtraGradeId),
                            spawn(fun() -> act_end_send_reward(DbRoleIds, Type, SubType, RewardList, ExtraGradeId) end);
                        true ->
                            act_end_reset(Type, SubType)
                    end
            end;
        _ ->
            skip
    end.

%% 删除内存奖励数据
act_end_reset(Type, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_special_gift, act_end_reset_help, [Type, SubType]) || E <- OnlineRoles].

act_end_reset_help(Ps, Type, SubType) ->
    #player_status{status_custom_act = #status_custom_act{reward_map = RewardMap} = StatusCustomAct} = Ps,
    case lib_custom_act_util:get_act_reward_grade_list(Type, SubType) of
        GradeIds when is_list(GradeIds) ->
            Keys = [{Type, SubType, GradeId} || GradeId <- GradeIds],
            NewRewardMap = maps:without(Keys, RewardMap),
            Ps#player_status{status_custom_act = StatusCustomAct#status_custom_act{reward_map = NewRewardMap}};
        _ ->
            ?ERR("spcial gift act cfg miss", []),
            Ps
    end.

%% 活动结束发送额外奖励
act_end_send_reward(RoleIds, Type, SubType, RewardList, GradeId) ->
    Sql1 = io_lib:format(<<"delete from custom_act_receive_reward where type = ~p and subtype = ~p">>, [Type, SubType]),
    Sql2 = io_lib:format(<<"delete from role_special_gift_extra_reward where type = ~p and sub_type = ~p">>, [Type, SubType]),
    DbF = fun() ->
        db:execute(Sql1),
        db:execute(Sql2),
        ok
    end,
    case catch db:transaction(DbF) of
        ok ->
            F = fun(RoleId) ->
                lib_mail_api:send_sys_mail([RoleId], utext:get(3310083), utext:get(3310084), RewardList),
                Pid = misc:get_player_process(RoleId),
                case misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_special_gift, act_end_reset_help, [Type, SubType]);
                    _ ->
                        skip
                end,
                lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList)
            end,
            lists:foreach(F, RoleIds);
        Err ->
            ?ERR("special gift db error:~p", [Err]),
            skip
    end.

%% 定制活动奖励能领取的是否全部领取
custom_act_reward_is_all_deactive(ActInfo, Player) ->
	#act_info{key = {Type, SubType}, wlv = Wlv} = ActInfo,
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType), 
	F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
            } = RewardCfg ->
                RoleLv = Player#player_status.figure#figure.lv,
                case lib_custom_act_check:check_reward_in_wlv(Type, SubType, [{wlv, Wlv}, {role_lv, RoleLv}], RewardCfg) of 
                    true ->
                        %% 计算奖励的领取状态
                        ReceiveTimes = count_receive_times(Type, SubType, GradeId, Player#player_status.status_custom_act#status_custom_act.reward_map),
                        Status = count_reward_status(Player, ActInfo, RewardCfg, ReceiveTimes),
						[ Status =/= 0 andalso Status =/= 1 | Acc ];     % 是否处于可领取状态
                    _ ->
                        [true | Acc] 
                end;
            _ -> [true | Acc] 
        end
        end,
	not lists:member(false, lists:foldl(F, [], GradeIds)).


%% -------------------------- 秘籍相关 --------------------------
%% 重置秘籍
gm_reset_reward(Player, SubType) ->
    Sql1 = io_lib:format(<<"truncate table role_special_gift_extra_reward">>, []),
    Sql2 = io_lib:format(<<"delete from custom_act_receive_reward where type = 98">>, []),
    F = fun() ->
        db:execute(Sql1),
        db:execute(Sql2)
    end,
    db:transaction(F),
    NewPs = Player#player_status{status_custom_act = #status_custom_act{reward_map = #{}}},
    pp_custom_act:handle(33104, NewPs, [98, SubType]),
    NewPs.


%% -------------------------- db相关 --------------------------
%% 查询未领取额外奖励记录
db_select_role_special_gift_extra_reward(Type, SubType) ->
    Sql = io_lib:format(<<"select role_id from role_special_gift_extra_reward where type = ~p and sub_type = ~p">>, [Type, SubType]),
    db:get_all(Sql).

%% 插入未领取额外奖励记录
db_replace_role_special_gift_extra_reward(RoleId, Type, SubType) ->
    Sql = io_lib:format(<<"replace into role_special_gift_extra_reward values(~p, ~p, ~p)">>, [RoleId, Type, SubType]),
    db:execute(Sql).

%% 删除额外奖励领取记录
db_delete_role_special_gift_extra_reward(RoleId, Type, SubType) ->
    Sql = io_lib:format(<<"delete from role_special_gift_extra_reward where role_id = ~p and type = ~p and sub_type = ~p">>, [RoleId, Type, SubType]),
    db:execute(Sql).