%%-----------------------------------------------------------------------------
%% @Module  :       pp_custom_act_list
%% @Author  :       liuxl
%% @Email   :
%% @Created :
%% @Description:    其他一些定制活动
%%-----------------------------------------------------------------------------
-module(pp_custom_act_list).

-include("server.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("rush_rank.hrl").
-export([handle/3]).

%% ========================================== 神兵租借 (start)
%% 获取神兵租借界面信息
handle(33201, PS, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_HOLYORGAN_HIRE ->
    lib_custom_act_holyorgan_hire:get_hire_act_info(PS, Type, SubType);

%% 租借
handle(33202, #player_status{sid = Sid} = PS, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_HOLYORGAN_HIRE ->
    case lib_custom_act_holyorgan_hire:hire(PS, Type, SubType) of
    	{ok, NewPS, _HireInfo} ->
    		{ok, Bin} = pt_332:write(33202, [1]),
    		lib_server_send:send_to_sid(Sid, Bin),
    		lib_custom_act_holyorgan_hire:get_hire_act_info(NewPS, Type, SubType),
    		{ok, NewPS};
    	{false, Res, NewPS} ->
    		{ok, Bin} = pt_332:write(33202, [Res]),
    		lib_server_send:send_to_sid(Sid, Bin),
    		{ok, NewPS}
    end;
%% ========================================== 神兵租借 (end)

%% 跨服节日消费榜
handle(33203, #player_status{server_id = ServerId, id = RoleId} = PS, [])  ->
	mod_clusters_node:apply_cast(mod_feast_cost_rank_clusters, send_to_client, [RoleId, ServerId]),
	{ok, PS};

%% 节日消费排行榜
handle(33204, #player_status{id = RoleId, server_id = ServerId} = PS, [SubType]) ->
	lib_feast_cost_rank_clusters:send_reward_to_client(RoleId, SubType, ServerId),
	{ok, PS};


%% 惊喜砸蛋界面信息
handle(33205, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_EGG ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career],
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime, is_record(CustomActCfg, custom_act_cfg) ->
            mod_luckey_egg:send_act_info(ActInfo, RoleArgs);
        _ ->
            ok
    end;

%% 扭蛋
handle(33206, Player, [Type, SubType, Index, AutoBuy]) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_EGG andalso (Index == 1 orelse Index == 10) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career],
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime, is_record(CustomActCfg, custom_act_cfg) ->
           case catch mod_luckey_egg:check_smashed_egg(ActInfo, RoleArgs, Index) of
                {ok, free} ->
                    mod_luckey_egg:smashed_egg(ActInfo, RoleArgs, Index, AutoBuy, [], 1);
                {ok, CostList} ->
                    Res = case AutoBuy == 1 of
                              true ->
                                  lib_goods_api:cost_objects_with_auto_buy(Player, CostList, luckey_egg, "");
                              false ->
                                  case lib_goods_api:cost_object_list_with_check(Player, CostList, luckey_egg, "") of
                                      {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                                      Other -> Other
                                  end
                          end,
                    case Res of
                        {true, NewPlayer, RealCostList} ->
                            mod_luckey_egg:smashed_egg(ActInfo, RoleArgs, Index, AutoBuy, RealCostList, 0);
                        {false, ErrorCode, NewPlayer} ->
                            lib_server_send:send_to_uid(RoleId, pt_332, 33206, [ErrorCode, Type, SubType, 0, 0, 0, []])
                    end,
                    {ok, NewPlayer};
                {false, ErrorCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_332, 33206, [ErrorCode, Type, SubType, 0, 0, 0, []]);
                Err ->
                    ?ERR("smashed_egg err:~p", [Err]),
                    lib_server_send:send_to_uid(RoleId, pt_332, 33206, [?ERRCODE(system_busy), Type, SubType, 0, 0, 0, []])
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_332, 33206, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, 0, []])
    end;

%% 惊喜扭蛋领取累计奖励
handle(_Cmd = 33207, Player, [Type, SubType, GradeId]) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_EGG  ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{name = RoleName, lv = RoleLv, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career],
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime, is_record(CustomActCfg, custom_act_cfg) ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{} = RewardCfg ->
                    RewardL = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    case lib_goods_api:can_give_goods(Player, RewardL) of
                        true ->
                            mod_luckey_egg:receive_cumulate_reward(ActInfo, RoleArgs, RewardCfg, RewardL);
                        {false, ErrorCode} ->
                            lib_server_send:send_to_sid(Sid, pt_332, 33207, [ErrorCode, Type, SubType, GradeId, []])
                    end;
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_332, 33207, [?ERRCODE(err331_no_act_reward_cfg), Type, SubType, GradeId, []])
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_332, 33207, [?ERRCODE(err331_act_closed), Type, SubType, GradeId, []])
    end;

%% 惊喜砸蛋界面幸运值信息
handle(33208, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_LUCKEY_EGG ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career],
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime, is_record(CustomActCfg, custom_act_cfg) ->
            mod_luckey_egg:send_act_luckey_info(ActInfo, RoleArgs);
        _ ->
            ok
    end;

%% 每日补给的活跃度
handle(Cmd = 33209, #player_status{id = RoleId} = Player, []) ->
    Activity = mod_daily:get_count_offline(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_SUPPLY),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_332, Cmd, [Activity]);

%% 节日投资：投资列表
handle(Cmd = 33211, #player_status{sid = Sid} = Player, [Type, SubType]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            lib_festival_investment:send_festival_investment_list(Player, ActInfo);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_332, Cmd, [Type, SubType, []])
    end;

%% 节日投资：购买
handle(Cmd = 33212, #player_status{sid = Sid} = Player, [Type, SubType, Lv]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_festival_investment:buy(Player, ActInfo, Lv) of
                {ok, NewPlayer, LoginDays, RewardList} ->
                    lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?SUCCESS, Type, SubType, Lv, LoginDays, RewardList]),
                    {ok, NewPlayer};
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_332, Cmd, [Res, Type, SubType, Lv, 0, []])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?ERRCODE(err331_act_closed), Type, SubType, Lv, 0, []])
    end;

%% 幸运抽奖 界面
handle(33213, #player_status{sid = Sid} = Player, [Type, SubType]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} when NowTime < Etime ->
            lib_luckey_wheel:send_act_info(Player, Type, SubType);
        _ ->
            ?PRINT("================ ~n",[]),
            lib_server_send:send_to_sid(Sid, pt_332, 33213, [Type, SubType, [], ?ERRCODE(err331_act_closed)])
    end;

%% 幸运抽奖 抽奖
handle(33214, Player, [Type, SubType, Times, AutoBuy]) ->
    lib_luckey_wheel:get_bonus(Player, Type, SubType, Times, AutoBuy);

%% vip特惠礼包：设置折扣
handle(Cmd = 33215, #player_status{sid = Sid} = Player, [Type, SubType, RewardId]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_custom_act_vip_gift:set_discount(Player, ActInfo, RewardId) of
                {ok, NewPlayer, NowCost} ->
                    lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?SUCCESS, Type, SubType, RewardId, NowCost]),
                    {ok, NewPlayer};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_332, Cmd, [Res, Type, SubType, RewardId, []]),
                    {ok, NewPS}
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?ERRCODE(err331_act_closed), Type, SubType, RewardId, []])
    end;

%% 封测充值返还
handle(33216, Player, []) ->
    lib_beta_recharge_return:send_info(Player);

%% 等级活跃抽奖界面信息
handle(Cmd = 33217, Player, [Type, SubType]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} when NowTime < Etime ->
            mod_level_draw_reward:send_level_draw_info(RoleId, Sid, Cmd, Type, SubType);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_332, Cmd, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, []])
    end;

%% 活跃转盘界面信息
handle(33218, Player, [Type, SubType]) ->
    lib_activation_draw:send_act_info(Player, Type, SubType);

%% 活跃转盘领取活跃度奖励
handle(33219, Player, [Type, SubType, Id]) ->
    lib_activation_draw:get_activation_reward(Player, Type, SubType, Id);

%% 活跃转盘抽奖
handle(33220, Player, [Type, SubType, Times]) ->
    lib_activation_draw:get_bonus(Player, Type, SubType, Times);

%% 神圣召唤
handle(33221, Player, [Type, SubType]) ->
    lib_holy_summon:info(Player, Type, SubType);

%% 神圣召唤
handle(33222, Player, [Type, SubType]) ->
    lib_holy_summon:draw_special_reward(Player, Type, SubType);

%% 活动首杀
handle(33223, Player, [Type, SubType]) ->
%%	?MYLOG("cym", "~p~n", [{Type, SubType}]),
    #player_status{id = RoleId} = Player,
    mod_first_kill:get_info(RoleId, Type, SubType);

handle(33224, Player, [Type, SubType, IsNext]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_fortune_cat:send_act_info(Player, ActInfo, IsNext);
        _ ->
            skip
    end;

handle(33225, Player, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_fortune_cat:turntable(Player, ActInfo);
        _ ->
            lib_server_send:send_to_uid(Player#player_status.id, pt_332, 33225, [?ERRCODE(err331_act_close),Type, SubType, 0, 0]),
            skip
    end;

handle(33226, Player, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_fortune_cat:send_turntable_records(Player#player_status.id, Type, SubType);
        _ ->
            skip
    end;

handle(33227, Player, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_kf_group_buy:send_gpbuy_info(Player, Type, SubType);
        _ ->
            skip
    end;

handle(33228, Player, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_kf_group_buy:send_gpbuy_records(Player, Type, SubType);
        _ ->
            skip
    end;

handle(33229, Player, [Type, SubType, GpGoodsId, PurchaseType]) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = Wlv, etime = Etime} = ActInfo when NowTime < Etime ->
            #custom_act_cfg{start_time = StartTime} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            case lib_custom_act_check:check_reward_in_wlv(Type, SubType, Wlv, GpGoodsId) of
                true ->
                    case PurchaseType of
                        1 ->
                            case lib_kf_group_buy:check_in_buy_day(Type, SubType, StartTime, NowTime) of
                                true ->
                                    Return = lib_kf_group_buy:purchase_gp_goods_first(Player, Type, SubType, GpGoodsId);
                                _ ->
                                    Return = {false, ?ERRCODE(err332_not_in_first_time)}
                            end;
                        _ ->
                            case lib_kf_group_buy:check_in_buy_day(Type, SubType, StartTime, NowTime) of
                                false ->
                                    Return = lib_kf_group_buy:purchase_gp_goods_tail(Player, ActInfo, GpGoodsId);
                                _ ->
                                    Return = {false, ?ERRCODE(err332_not_in_tail_time)}
                            end
                    end,
                    case Return of
                        {ok, NewPS, BuyCount, BuyNum, RewardList} ->
                            ?PRINT("purchase_gp_goods#Return:~p~n", [{BuyCount, BuyNum, RewardList}]),
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33229, [?SUCCESS, Type, SubType, GpGoodsId, PurchaseType, BuyCount, BuyNum, RewardList]),
                            {ok, NewPS};
                        {false, Code} ->
                            ?PRINT("purchase_gp_goods#Code:~p~n", [Code]),
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33229, [Code, Type, SubType, GpGoodsId, PurchaseType, 0, 0, []])
                    end;
                {false, Code} ->
                    lib_server_send:send_to_sid(Player#player_status.sid, pt_332, 33229, [Code, Type, SubType, GpGoodsId, PurchaseType, 0, 0, []])
            end;
        _ ->
            skip
    end;

handle(33231, Player, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
            {money, MoneyType} = ulists:keyfind(money, 1, Conditions, {money, 0}),
            Score = lib_goods_api:get_currency(Player, MoneyType),
            lib_server_send:send_to_uid(Player#player_status.id, pt_332, 33231, [Type, SubType, Score]);
        _ ->
            skip
    end;

%% 契约挑战信息
handle(33232, Player, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            mod_contract_challenge:send_act_info(Player#player_status.id, SubType);
        _Info ->
            skip
    end;

%% 领取契约点
handle(33233, Player, [Type, SubType, ItemId]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            mod_contract_challenge:get_point_reward(Player#player_status.id, SubType, ItemId);
        _ ->
            skip
    end;

%% 完成问卷调查
handle(33236, Player, [QuestionType]) ->
    lib_questionnaire:finish(Player, QuestionType);


%% 天命转盘
handle(33238, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_DESTINY_TURN ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_destiny_turntable:send_act_info(Player, ActInfo);
        _ ->
            skip
    end;

%% 天命转盘开抽
handle(33240, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_DESTINY_TURN ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_destiny_turntable:turntable(Player, ActInfo);
        _ ->
            skip
    end;

%% 幸运寻宝界面
handle(33241, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_TASK_REWARD ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_custom_act_task:get_act_info(Player, Type, SubType);
        _ ->
            skip
    end;

%% 幸运鉴宝界面
handle(33243, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_bonus_treasure:get_show_data(Player, Type, SubType);
        _ ->
            skip
    end;

%% 幸运鉴宝抽奖
handle(33244, Player, [Type, SubType, Times, AutoBuy, Turn]) when Type == ?CUSTOM_ACT_TYPE_TREASURE_HUNT ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_bonus_treasure:draw_reward(Player, Type, SubType, Times, AutoBuy, Turn);
        _ ->
            skip
    end;

handle(33245, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_COMMON_DRAW ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_common_draw:send_info(Player, Type, SubType);
        _ ->
            skip
    end;

handle(33246, Player, [Type, SubType, Times, AutoBuy, LunceField]) when Type == ?CUSTOM_ACT_TYPE_COMMON_DRAW ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_common_draw:do_draw(Player, Type, SubType, Times, AutoBuy, LunceField);
        _ ->
            skip
    end;

%% 多倍充值界面
handle(33247, Player, [Type, SubType]) when Type == ?CUSTOM_ACT_TYPE_RECHARGE_REBATE ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            CustomActData = lib_recharge_rebate_act:get_recharge_rebate(Player, Type, SubType),
            lib_recharge_rebate_act:send_recharge_rebate_info(Player, CustomActData);
        _ ->
            skip
    end;

%% 冲级礼包
handle(33248, Player, [])  ->
    #player_status{status_custom_act = CustomAct,id = RoleId} = Player,
    {ok, Bin} = pt_332:write(33248, [0, 0]),
    case CustomAct of
        #status_custom_act{data_map = Data} ->
            case maps:get({?CUSTOM_ACT_TYPE_LV_GIFT, 1}, Data, []) of
                #custom_act_data{data = DataList} ->
                    Time1 =
                        case lists:keyfind(min_lv, 1, DataList) of
                            {min_lv, V1} ->
                                V1;
                            _ ->
                                0
                        end,
                    Time2 =
                        case lists:keyfind(max_lv, 1, DataList) of
                            {max_lv, V2} ->
                                V2;
                            _ ->
                                0
                        end,
                    {ok, Bin1} = pt_332:write(33248, [Time1, Time2]),
                    lib_server_send:send_to_uid(RoleId, Bin1);
                _ ->
                    lib_server_send:send_to_uid(RoleId, Bin)
            end;
        _ -> %% 容错
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

handle(33249, Player, []) ->
    #player_status{id = RoleId} = Player,
    %% 泰文特殊处理， 赶时间未处理配置写死，后面可处理
    Count = mod_counter:get_count(RoleId, 332, 33249),
    case ?GAME_VER of
        _ when Count =/= 0 -> skip;
        ?GAME_VER_TH ->
            Title = <<"รางวัลระบบ"/utf8>>,
            Content = <<"ขอบคุณสำหรับการตอบรับ ขอให้สนุกกับเกมนะจ๊ะ!"/utf8>>,
            Reward = [{0,16020001,10},{0,38070001,1},{0,32010101,1}],
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            mod_counter:set_count(RoleId, 332, 33249, 1),
            lib_server_send:send_to_uid(RoleId, pt_332, 33249, [?SUCCESS]);
        ?GAME_VER_RU ->
            Title = <<"Система наград"/utf8>>,
            Content = <<"Спасибо за ваш интерес к игре, мы отправляем вам небольшую награду, желаем вам приятной игры!"/utf8>>,
            Reward = [{100,16020001,5},{100,17020001,5},{2,0,50}],
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            mod_counter:set_count(RoleId, 332, 33249, 1),
            lib_server_send:send_to_uid(RoleId, pt_332, 33249, [?SUCCESS]);
        _ -> skip
    end;

handle(33250, Player, [Type, SubType]) ->
    #player_status{id = RoleId, status_custom_act = StatusCustom} = Player,
    #status_custom_act{data_map = Map} = StatusCustom,
    #custom_act_data{data = DataList} = maps:get({Type, SubType}, Map, #custom_act_data{}),
    {ok, Bin1} = pt_331:write(33100, [?MISSING_CONFIG]),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} ->
            case lists:keyfind(cd, 1, Condition) of
                {_, CdTime} ->
                    PackList = [{GradeId, Time + CdTime} || {GradeId, _, Time } <- DataList],
                    {ok, Bin} = pt_332:write(33250, [Type, SubType, PackList]),
                    ?PRINT("PackList ~p~n", [PackList]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    lib_server_send:send_to_uid(RoleId, Bin1)
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, Bin1)
    end;

handle(33251, Player, []) ->
    % 登录的时候客户端请求，这个时候清一下时间间隔先
    mod_rush_rank:role_refresh_send_time(Player#player_status.id),
    NowOpenDay = util:get_open_day(),
    OpenTime = util:get_open_time(),
    RankList = data_rush_rank:get_id_list(),
    F = fun(RankId) ->
        #base_rush_rank{start_day = StartDay, clear_day = ClearDay, open_start_time = OpenStartTime,
            open_end_time = OpenEndTime} = data_rush_rank:get_rush_rank_cfg(RankId),
        NowOpenDay >= StartDay andalso NowOpenDay < ClearDay andalso OpenStartTime =< OpenTime andalso OpenTime >= OpenEndTime
    end,
    [lib_rush_rank_api:refresh_rush_rank(Player, RankId) || RankId <- RankList, F(RankId)],
    skip;

%% 冲榜夺宝界面信息
handle(33252, PS, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
    #player_status{id = RoleId, server_id = ServerId, figure = #figure{lv = RoleLv}} = PS,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, LimitLv} = ulists:keyfind(role_lv, 1, Conditions, 9999),
    RoleLv >= LimitLv andalso lib_custom_act_api:is_open_act(Type, SubType) andalso mod_rush_treasure_kf:cast_center([{send_rush_info, ServerId, RoleId, Type, SubType}]);

%% 冲榜夺宝榜单信息
handle(33253, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
    #player_status{server_id = ServerId, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, LimitLv} = ulists:keyfind(role_lv, 1, Conditions, 9999),
    RoleLv >= LimitLv andalso lib_custom_act_api:is_open_act(Type, SubType) andalso mod_rush_treasure_kf:cast_center([{get_rush_type_rank, Type, SubType,RoleId, ServerId, ServerId}]);

%% 领取冲榜夺宝阶段奖励
handle(33254, Player, [Type, SubType, RewardId]) when Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE ->
    #player_status{server_id = ServerId, id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    #custom_act_cfg{condition = Conditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {role_lv, LimitLv} = ulists:keyfind(role_lv, 1, Conditions, 9999),
    RoleLv >= LimitLv andalso lib_custom_act_api:is_open_act(Type, SubType) andalso mod_rush_treasure_kf:cast_center([{get_rush_stage_reward, ServerId, RoleId, Type, SubType, RewardId}]);

%% 红包返利信息
handle(33255, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_envelope_rebate:send_act_info(Player, ActInfo);
        _ ->
            skip
    end;

%% 红包返利提现
handle(33256, Player, [Type, SubType, WithDrawType, PackageCode, TokenId]) when Type =:= ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_envelope_rebate:envelope_withdrawal(Player, ActInfo, WithDrawType, PackageCode, TokenId);
        _ ->
            skip
    end;

%% 获取全民狂欢任务进度
handle(33258, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_THE_CARNIVAL ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_custom_the_carnival:send_task_process(Player, Type, SubType);
        _ ->
            skip
    end;

handle(33259, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_RECHARGE_POLITE ->
    lib_custom_act_recharge_polite:send_reward_status(Player, Type, SubType);

handle(33260, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_WISH_DRAW ->
    lib_custom_act_wish_draw:send_wish_draw_info(Player, Type, SubType);

handle(33261, Player, [ProtoId]) ->
    mod_msg_cache_queue:send_queue(Player#player_status.id, ProtoId),
    NewPs = lib_delay_reward:send_delay_reward(Player, ProtoId),
    {ok, NewPs};

handle(33262, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_WISH_DRAW ->
    case lib_custom_act_wish_draw:start_draw(Player, Type, SubType) of
        {true, NewPs} -> {ok, NewPs};
        {false, ErrCode} ->
            #wish_draw_act{turn = Turn, times = Times} = lib_custom_act_wish_draw:get_wish_draw_data(Player, Type, SubType),
            {ok, BinData} = pt_332:write(33262, [Type, SubType, 0, Turn, Times, ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        _ ->
             skip
    end;

handle(33263, Player, [Type, SubType]) when Type =:= ?CUSTOM_ACT_TYPE_WISH_DRAW ->
    case lib_custom_act_wish_draw:get_free_gift(Player, Type, SubType) of
        {ok, NewPs} -> {ok, NewPs};
        {false, ErrCode} ->
            {ok, BinData} = pt_332:write(33263, [Type, SubType, ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;


%% 获取活动奖励配置
handle(33264, Player, [Type, SubType]) ->
    #player_status{sid = SId, figure = #figure{lv = Lv}} = Player,
    OpDay = util:get_open_day(),

    CondF = fun(Cond) ->
        case Cond of
            {lv, NeedLv} -> Lv >= NeedLv;
            {role_lv, NeedLv} -> Lv >= NeedLv;
            {open_day, OpDayRange} -> ulists:is_in_range(OpDayRange, OpDay) /= false;
            _ -> true
        end
    end,
    F = fun(GradeId, AccL) ->
        #custom_act_reward_cfg{
            condition = Condition,
            format = Format,
            reward = Reward
        } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        case lists:all(CondF, Condition) of
            true -> [{GradeId, Format, util:term_to_string(Reward)} | AccL];
            false -> AccL
        end
    end,
    RewardList = lists:foldl(F, [], lib_custom_act_util:get_act_reward_grade_list(Type, SubType)),

    lib_server_send:send_to_sid(SId, pt_332, 33264, [Type, SubType, RewardList]);

%% 外形直购活动勾玉礼包购买
handle(33265, Player, [Type, SubType, GradeId]) when Type =:= ?CUSTOM_ACT_TYPE_FIGURE_BUY ->
    case lib_figure_buy_act:buy_other_grade(Player, Type, SubType, GradeId) of
        {ok, NewPs} -> {ok, NewPs};
        {false, ErrCode} ->
            {ok, BinData} = pt_332:write(33265, [Type, SubType, ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

%% 一元充值活动勾玉礼包购买
handle(33265, Player, [Type, SubType, GradeId]) when Type =:= ?CUSTOM_ACT_RECHARGE_ONE ->
    case lib_recharge_one:buy_other_grade(Player, Type, SubType, GradeId) of
        {ok, NewPs} -> {ok, NewPs};
        {false, ErrCode} ->
            {ok, BinData} = pt_332:write(33265, [Type, SubType, ErrCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

%% 物品期望战力计算
handle(33266, Player, [Type, SubType,GoodsId]) ->
    #player_status{original_attr = OriginAttr} = Player,
    case data_goods_type:get(GoodsId) of
        #ets_goods_type{base_attrlist = BaseAttr} ->
            Power = lib_player:calc_expact_power(OriginAttr, 0, BaseAttr);
        _ -> Power = 0
    end,
    {ok, BinData} = pt_332:write(33266, [Type, SubType,Power, ?SUCCESS]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 跨服团购喊话
handle(33267, Player, [Type, SubType, GradeId]) ->
    #player_status{ id = PlayerId } = Player,
    case lib_kf_group_buy:check_group_buy_shout(Type, SubType, GradeId) of
        {ok, CfgCdTime} ->
            Args = [Type, SubType, PlayerId, config:get_server_id(), GradeId, CfgCdTime],
            %% Args = [88, 1, 4294968670, 1, 1, 60].
            mod_clusters_node:apply_cast(mod_kf_group_buy, group_buy_shout, [Args]);
        {error, Code} ->
            {ok, BinData} = pt_332:write(33267, [Code, Type, SubType, 0]),
            lib_server_send:send_to_uid(PlayerId, BinData)
    end;

handle(_Cmd, _Player, _Data) ->
    ?ERR("pp_custom_act no match ~p~n",[_Cmd]),
    {ok, _Player}.