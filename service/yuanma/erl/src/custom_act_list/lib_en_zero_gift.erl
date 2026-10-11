%% ---------------------------------------------------------------------------
%% @doc lib_en_zero_gift.erl

%% @author  cxd
%% @since  2020-02-15
%% @deprecated 英文版0元礼包
%% ---------------------------------------------------------------------------
-module(lib_en_zero_gift).
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("goods.hrl").
-include("mail.hrl").



%% 充值购买礼包时间处理
handle_event(PS,
             #event_callback{
                type_id = ?EVENT_RECHARGE,
                data  = #callback_recharge_data{recharge_product = #base_recharge_product{
                                                 product_id = ProductId}}}) ->
    NewPS = handle_product(PS, ProductId),
    {ok, NewPS};
handle_event(PS, _) ->
    {ok, PS}.

%% 充值购买更新数据，发送奖励邮件
handle_product(#player_status{id = 
    _RoleId, figure = #figure{lv = RoleLv}, status_custom_act = #status_custom_act{reward_map = RewardMap}} = Player, ProductId) ->
    Type = ?CUSTOM_ACT_TYPE_EN_ZERO_GIFT,
    SubIds = lib_custom_act_api:get_open_subtype_ids(Type),
    OpenDay = util:get_open_day(),
    %% 根据商品id获取子类型
    {IsOpen, SubType, Condition} = get_subtype_with_productid(SubIds, ProductId),
    CheckLv =   case lists:keyfind(role_lv, 1, Condition) of
                    {role_lv, RoleLvLimit} when RoleLv >= RoleLvLimit ->
                        true;
                    _ ->
                        false 
                end,
    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    GradeId = get_grade_id_with_condition(GradeIds, Condition),
    HasReceive =    case maps:get({Type, SubType, GradeId}, RewardMap, []) of
                        #reward_status{receive_times = ReceiveTimes} when ReceiveTimes > 0 ->
                            true;
                        _ ->
                            false
                    end,
    BaseRewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
    if
        IsOpen == false orelse CheckLv == false orelse OpenDay > 7 ->
            Player;
        is_record(BaseRewardCfg, custom_act_reward_cfg) == false ->
            Player;
        HasReceive == true ->
            Player;
        true ->
            %% 3d改需求，服务端什么都不发
            % #custom_act_reward_cfg{reward = Reward} = BaseRewardCfg,
            % %% 更新领取次数
            % NewPlayer = lib_custom_act:update_receive_times(Player, Type, SubType, GradeId, 1),
            % %% 发送奖励
            % lib_mail:send_sys_mail([RoleId], data_language:get(3310091), data_language:get(3310092), Reward),
            % %% 记录日志
            % lib_log_api:log_en_zero_gift(RoleId, 1),
            Player
    end.


%% 根据活动ProductId获得对应的子类型id
get_subtype_with_productid([SubId|SubIds], ProductId) ->
    case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_EN_ZERO_GIFT, SubId) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(recharge, 1, Condition) of
                {recharge, ProductId} ->
                    {true, SubId, Condition};
                _ ->
                    get_subtype_with_productid(SubIds, ProductId)
            end;
        _ ->
            ?ERR("condition cfg miss~n", []),
            {false, 0, []}
    end;
get_subtype_with_productid([], _ProductId) ->
    {false, 0, []}.

%% 根据商品id获取奖励档次id
get_grade_id_with_condition([GradeId|GradeIds], Condition) ->
    case lists:keyfind(grade_id, 1, Condition) of
        {grade_id, GradeId} ->
            GradeId;
        _ ->
            get_grade_id_with_condition(GradeIds, Condition)
    end;
get_grade_id_with_condition([], _Condition) ->
    0.