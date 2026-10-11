%%-----------------------------------------------------------------------------
%% @Module  :       pp_custom_act
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-05
%% @Description:    定制活动
%%-----------------------------------------------------------------------------
-module(pp_custom_act).

-include("server.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("kv.hrl").
-include("def_fun.hrl").
-include("smashed_egg.hrl").
-include("cloud_buy.hrl").
-include("goods.hrl").
-include("red_envelopes.hrl").
-include("predefine.hrl").
-include("treasure_evaluation.hrl").
-include("collect.hrl").

-export([handle/3]).

%% 获取活动列表
handle(Cmd = 33101, Player, _) ->
    ActList = lib_custom_act_util:get_custom_act_open_list(),
    PackList = lib_custom_act:pack_custom_act_list(ActList),
    {ok, BinData} = pt_331:write(Cmd, [PackList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 获取奖励领取状态(通用活动)
handle(_Cmd = 33104, Player, [Type, SubType]) ->
    lib_custom_act:reward_status(Player, Type, SubType);

%% 奖励领取(通用活动)
handle(_Cmd = 33105, Player, [Type, SubType, GradeId]) ->
    lib_custom_act:receive_reward(Player, Type, SubType, GradeId);

%% 某些特殊活动要限制今天总的兑换数量
handle(Cmd = 33106, Player, [Type, SubType, ModId, CounterId, GradeId]) ->
    if
        Type == ?CUSTOM_ACT_TYPE_COLWORD andalso ModId > 0 andalso CounterId > 0 ->
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],
                [{global_diff_day, 1}]);
        (Type == ?CUSTOM_ACT_TYPE_FEAST_SHOP orelse Type == ?CUSTOM_ACT_TYPE_BUY orelse
            Type == ?CUSTOM_ACT_TYPE_SHOP_REWARD orelse Type == ?CUSTOM_ACT_TYPE_RUSH_BUY) andalso ModId > 0 andalso CounterId > 0 ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{condition = RewardCondition} ->
                    case lists:keyfind(sp_gap_time, 1, RewardCondition) of
                        {_, Day} -> Day;
                        _ -> Day = 1
                    end;
                _ -> Day = 1
            end,
            [{_, ExchangeTime} | _] = mod_global_counter:get_count([{ModId, Type, CounterId}],
                [{global_diff_day, Day}]);
        true ->
            ExchangeTime = 0
    end,
    {ok, Bin} = pt_331:write(Cmd, [Type, SubType, ModId, CounterId, ExchangeTime, GradeId]),
    lib_server_send:send_to_sid(Player#player_status.sid, Bin);

handle(33107, #player_status{sid = Sid, id = RoleId}, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime = Stime, etime = Etime} ->
            case lib_custom_act_util:keyfind_act_condition(Type, SubType, money_types) of
                {money_types, List} ->
                    ResList
                        = [begin
                               case MoneyType of
                                   ?GOLD ->
                                       {?TYPE_GOLD, lib_consume_data:get_consume_gold_between(RoleId, Stime, Etime)};
                                   ?BGOLD ->
                                       {?TYPE_BGOLD, lib_consume_data:get_consume_bgold_between(RoleId, Stime, Etime)};
                                   ?COIN ->
                                       {?TYPE_COIN, lib_consume_data:get_consume_coin_between(RoleId, Stime, Etime)};
                                   _ ->
                                       {0, 0}
                               end
                           end || MoneyType <- List],
                    {ok, BinData} = pt_331:write(33107, [Type, SubType, ResList]),
                    lib_server_send:send_to_sid(Sid, BinData);
                _ ->
                    skip
            end;
        _ ->
            skip
    end;

%% 确认已经五星评价
handle(33110, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case data_key_value:get(?KEY_FIVE_STAR_LV_ID) of
        undefined ->
            Code = ?FAIL;
        FiveStarOpenLv ->
            case Lv >= FiveStarOpenLv of %% 五星评价开放等级
                false ->
                    Code = ?LEVEL_LIMIT;
                true ->
                    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_FIVE_STAR) of
                        [] ->
                            Code = ?ERRCODE(err331_act_closed);
                        [SubTypeInfo | _] ->
                            #act_info{
                                stime = StartTime,
                                etime = EndTime
                            } = SubTypeInfo,
                            FiveStarMarkNum = mod_counter:get_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_FIVE_STAR),
                            if
                                FiveStarMarkNum < StartTime ->
                                    Code = ?SUCCESS;
                                FiveStarMarkNum >= EndTime ->
                                    Code = ?SUCCESS;
                                true ->
                                    Code = ?ERRCODE(err331_fs_already_evaluate)
                            end
                    end
            end
    end,
    case Code =:= ?SUCCESS of
        true ->
            mod_counter:set_count(RoleId, ?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_FIVE_STAR, utime:unixtime());
        false ->
            skip
    end,
    {ok, Bin} = pt_331:write(33110, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 打开特惠商城
handle(33111, Ps, [_Type, SubType]) ->
    #player_status{
        id = RoleId
    } = Ps,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_LIMIT_BUY, SubType) of
        false ->
            {ok, Bin} = pt_331:write(33111, [?ERRCODE(err331_act_closed), []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_limit_buy:open_limit_buy(RoleId, SubType)
    end;

%% 众仙云购信息
handle(33112, Ps, [SubType]) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        figure = Figure,
        cloud_buy_list = CloudBuyDataList
    } = Ps,
    #figure{
        lv = Lv,
        vip = VipLv,
        vip_type = VipType
    } = Figure,
    % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, role_lv) of
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33112, [?MISSING_CONFIG, SubType, 0, 0, 0, 0, 0, [], [], 0, 0, 0]);
        {role_lv, CloudOpenLv} ->
            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf) of
                false ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33112, [?MISSING_CONFIG, SubType, 0, 0, 0, 0, 0, [], [], 0, 0, 0]);
                {if_kf, IfKf} ->
                    case Lv >= CloudOpenLv of
                        false ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33112, [?LEVEL_LIMIT, SubType, IfKf, 0, 0, 0, 0, [], [], 0, 0, 0]);
                        true ->
                            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
                                false ->
                                    lib_server_send:send_to_sid(Sid, pt_331, 33112, [?ERRCODE(err331_act_closed), SubType, IfKf, 0, 0, 0, 0, [], [], 0, 0, 0]);
                                true ->
                                    BuyData = lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList),
                                    case BuyData of
                                        #cloud_buy_status{stage_reward = StageReward} when is_list(StageReward)->skip;
                                        _E -> StageReward = []
                                    end,
                                    % lib_server_send:send_to_uid(RoleId, pt_331, 33116, [StageReward]),
                                    Node = mod_disperse:get_clusters_node(),
        %%                            VipLv = lib_vip_api:get_vip_lv(Ps), TODO:VIP临时改下
                                    % VipLv = 0,
                                    case IfKf of
                                        0 ->
                                            mod_cloud_buy_mgr:get_cur_award_info(Node, SubType, RoleId, 0, 0),
                                            mod_cloud_buy_mgr:get_info(Node, SubType, RoleId, Sid, VipLv, VipType, StageReward);
                                        _ ->
                                            mod_clusters_node:apply_cast(mod_cloud_buy_mgr, get_cur_award_info, [Node, SubType, RoleId, 0, 0]),
                                            mod_clusters_node:apply_cast(mod_cloud_buy_mgr, get_info, [Node, SubType, RoleId, Sid, VipLv, VipType, StageReward])
                                    end
                            end
                    end
            end
    end;

%% 众仙云购-购买
handle(33113, Ps, [SubType, Count, IfAutoBuy]) when Count > 0 ->
    #player_status{
        id = RoleId,
        sid = Sid,
        platform = Platform,
        server_num = Server,
        figure = Figure,
        cloud_buy_list = CloudBuyDataList
    } = Ps,
    #figure{
        name = Name,
        lv = Lv,
        vip = VipLv,
        vip_type = VipType
    } = Figure,
    % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),
    case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, role_lv) of
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33113, [?MISSING_CONFIG, SubType, [], []]);
        {role_lv, CloudOpenLv} ->
            case Lv >= CloudOpenLv of
                false ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?LEVEL_LIMIT, SubType, [], []]);
                true ->
                    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
                        false ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33113, [?ERRCODE(err331_act_closed), SubType, [], []]);
                        true ->
                            Now = utime:unixtime(),
                            {_, EndTime} = lib_custom_act_util:get_act_time_range_by_type(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType),
                            Node = mod_disperse:get_clusters_node(),
                            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf) of
                                false ->
                                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?MISSING_CONFIG, SubType, [], []]);
                                {if_kf, IfKf} ->
                                    case lists:keyfind(SubType, #cloud_buy_status.subtype, CloudBuyDataList) of
                                        #cloud_buy_status{award_time = Time} when Now >= Time andalso Time + 60 * 60 * 24 > EndTime ->
                                            lib_server_send:send_to_sid(Sid, pt_331, 33113, [?ERRCODE(err331_cloud_buy_end), SubType, [], []]);
                                        #cloud_buy_status{big_award_id = BigAwardId, award_time = Time} when Time > Now ->
                                            case data_cloud_buy:get_reward_cfg(BigAwardId) of
                                                #big_award_cfg{cost = CostList} ->
                                                    Result = case IfAutoBuy of
                                                                 0 ->
                                                                     lib_goods_api:check_object_list(Ps, CostList);
                                                                 _ ->
                                                                     lib_goods_api:check_object_list_with_auto_buy(Ps, CostList)
                                                             end,
                                                    case Result of
                                                        true ->
        %%                                                    VipLv = lib_vip_api:get_vip_lv(Ps),    TODO:VIP临时改下
                                                            % VipLv =0,
                                                            Args = [Node, Platform, Server, RoleId, Name, Sid, Count, VipLv, VipType, IfAutoBuy],
                                                            case IfKf of
                                                                0 ->
                                                                    mod_cloud_buy_mgr:order(SubType, Node, Sid, Args);
                                                                _ ->
                                                                    mod_clusters_node:apply_cast(mod_cloud_buy_mgr, order, [SubType, Node, Sid, Args])
                                                            end;
                                                        {false, ErrCode} ->
                                                            lib_server_send:send_to_sid(Sid, pt_331, 33113, [ErrCode, SubType, [], []])
                                                    end;
                                                _ ->
                                                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?MISSING_CONFIG, SubType, [], []])
                                            end;
                                        UnInitual ->
                                            if
                                                is_record(UnInitual, cloud_buy_status) ->
                                                    % ReqTimes = UnInitual#cloud_buy_status.req_times rem 1,
                                                    CloudStatus = UnInitual;
                                                true ->
                                                    % ReqTimes = 0,
                                                    CloudStatus = #cloud_buy_status{
                                                        subtype = SubType
                                                    }
                                            end,
                                            % if
                                            %     ReqTimes =:= 0 ->
                                                    case IfKf of
                                                        0 ->
                                                            mod_cloud_buy_mgr:get_cur_award_info(Node, SubType, RoleId, Count, IfAutoBuy);
                                                        _ ->
                                                            mod_clusters_node:apply_cast(mod_cloud_buy_mgr, get_cur_award_info, [Node, SubType, RoleId, Count, IfAutoBuy])
                                                    end,
                                                    lib_server_send:send_to_sid(Sid, pt_331, 33113, [?ERRCODE(err331_reward_preparing), SubType, [], []]),
                                            %     true ->
                                            %         skip
                                            % end,
                                            NewCloudStatus = CloudStatus#cloud_buy_status{
                                                req_times = 0
                                            },
                                            {ok, Ps#player_status{cloud_buy_list = [NewCloudStatus | CloudBuyDataList]}}
                                    end
                            end
                    end
            end
    end;

%% 众仙云购-上期中奖名单
handle(33114, Ps, [SubType]) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
        false ->
            skip;
        true ->
            Node = mod_disperse:get_clusters_node(),
            case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, if_kf) of
                false ->
                    skip;
                {if_kf, IfKf} ->
                    case IfKf of
                        0 ->
                            mod_cloud_buy_mgr:get_last_lucky_orders(Node, SubType, Ps#player_status.sid);
                        _ ->
                            mod_clusters_node:apply_cast(mod_cloud_buy_mgr, get_last_lucky_orders, [Node, SubType, Ps#player_status.sid])
                    end
            end
    end;

%% 打开完美恋人
handle(33115, Ps, [SubType, Opr]) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        figure = Figure
    } = Ps,
    #figure{
        lover_role_id = LoverRoleId,
        lover_name = LoverName,
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_PERFECT_LOVER),
    case Lv >= OpenLv of
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33115, [?LEVEL_LIMIT, SubType, Opr, 0, []]);
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_PERFECT_LOVER, SubType) of
                true ->
                    case Opr == 1 of
                        true ->
                            mod_perfect_lover:open_perfect_lover(SubType, Opr, RoleId, LoverRoleId, LoverName);
                        _ ->
                            mod_perfect_lover:get_reward(SubType, Opr, RoleId)
                    end;
                false ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33115, [?ERRCODE(err331_act_closed), SubType, Opr, 0, []])
            end
    end;

% handle(_Cmd = 33117, Player, [SubType, BuyTimes]) ->
%     #player_status{
%         sid = Sid,
%         figure = Figure
%     } = Player,
%     #figure{
%         lv = Lv
%     } = Figure,
%     % CloudOpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_CLOUD_BUY),
%     case lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType, role_lv) of
%         false ->
%             lib_server_send:send_to_sid(Sid, pt_331, 33117, [?MISSING_CONFIG, BuyTimes]);
%         {role_lv, CloudOpenLv} ->
%             case Lv >= CloudOpenLv of
%                 false ->
%                     lib_server_send:send_to_sid(Sid, pt_331, 33117, [?LEVEL_LIMIT, BuyTimes]);
%                 true ->
%                     case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
%                         false ->
%                             lib_server_send:send_to_sid(Sid, pt_331, 33117, [?ERRCODE(err331_act_closed), BuyTimes]);
%                         true ->
%                             NewPlayer = lib_cloud_buy:get_stage_reward(Player, SubType, BuyTimes),
%                             {ok, NewPlayer}
%                     end
%             end
%     end;


%% 砸蛋界面信息
handle(_Cmd = 33120, Player, [Type, SubType]) ->
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{lv = RoleLv, name = RoleName, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career, RegTime],
    mod_smashed_egg:send_act_info(Type, SubType, RoleArgs);

%% 砸蛋刷新
handle(_Cmd = 33121, Player, [Type, SubType]) ->
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{lv = RoleLv, name = RoleName, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career, RegTime],
    case catch mod_smashed_egg:check_refresh_egg(Type, SubType, RoleArgs) of
        {ok, free} -> %% 免费刷新
            mod_smashed_egg:refresh_egg(Type, SubType, RoleArgs, 1);
        {ok, CostList} ->
            case lib_goods_api:cost_object_list_with_check(Player, CostList, smashed_egg_refresh, "") of
                {true, NewPlayer} ->
                    mod_smashed_egg:refresh_egg(Type, SubType, RoleArgs, 0);
                {false, ErrorCode, NewPlayer} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode])
            end,
            {ok, NewPlayer};
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode]);
        Err ->
            ?ERR("smashed_egg_refresh err:~p", [Err]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(system_busy)])
    end;

%% 砸蛋
handle(_Cmd = 33122, Player, [Type, SubType, Index, AutoBuy]) when Index >= 0, Index < 5 ->
    #player_status{id = RoleId, reg_time = RegTime, figure = #figure{name = RoleName, lv = RoleLv, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career, RegTime],
    SmashedType = ?IF(Index == 0, ?SMASHED_TYPE_ALL, ?SMASHED_TYPE_ONE),
    case catch mod_smashed_egg:check_smashed_egg(Type, SubType, RoleArgs, SmashedType, Index) of
        {ok, free} ->
            mod_smashed_egg:smashed_egg(Type, SubType, RoleArgs, SmashedType, Index, AutoBuy, [], 1);
        {ok, CostList} ->
            Res = case AutoBuy == 1 of
                      true ->
                          lib_goods_api:cost_objects_with_auto_buy(Player, CostList, smashed_egg, "");
                      false ->
                          case lib_goods_api:cost_object_list_with_check(Player, CostList, smashed_egg, "") of
                              {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                              Other -> Other
                          end
                  end,
            case Res of
                {true, NewPlayer, RealCostList} ->
                    mod_smashed_egg:smashed_egg(Type, SubType, RoleArgs, SmashedType, Index, AutoBuy, RealCostList, 0);
                {false, ErrorCode, NewPlayer} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33122, [ErrorCode, Type, SubType, 0, 0, []])
            end,
            {ok, NewPlayer};
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33122, [ErrorCode, Type, SubType, 0, 0, []]);
        Err ->
            ?ERR("smashed_egg err:~p", [Err]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33122, [?ERRCODE(system_busy), Type, SubType, 0, 0, []])
    end;

%% 领取累计奖励
handle(_Cmd = 33123, Player, [Type, SubType, GradeId]) ->
    #player_status{sid = Sid, id = RoleId, reg_time = RegTime, figure = #figure{name = RoleName, lv = RoleLv, sex = Sex, career = Career}} = Player,
    RoleArgs = [RoleId, RoleName, RoleLv, Sex, Career, RegTime],
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = WorldLv, etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                #custom_act_reward_cfg{} = RewardCfg ->
                    RewardL = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
                    case lib_goods_api:can_give_goods(Player, RewardL) of
                        true when Type == ?CUSTOM_ACT_TYPE_SMASHED_EGG ->
                            mod_smashed_egg:receive_cumulate_reward(Type, SubType, RoleArgs, WorldLv, RewardCfg, RewardL);
                        true ->
                            ok;
                        {false, ErrorCode} ->
                            lib_server_send:send_to_sid(Sid, pt_331, 33100, [ErrorCode])
                    end;
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err331_no_act_reward_cfg)])
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

%% 活动Boss信息
handle(_Cmd = 33126, Player, _) ->
    #player_status{id = RoleId} = Player,
    mod_act_boss:send_act_info(RoleId);

%% 立即前往
handle(_Cmd = 33127, Player, [SceneId]) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_ACT_BOSS) of
        true ->
            case Player#player_status.scene =/= SceneId of
                true ->
                    case lib_scene:check_enter_on_normal(Player, SceneId) of
                        {ok, _Scene, ChangeSceneX, ChangeSceneY} ->
                            case catch mod_act_boss:check_enter_scene(SceneId) of
                                ok ->
                                    NewPlayer = lib_scene:change_scene(Player, SceneId, 0, 0, ChangeSceneX, ChangeSceneY, false, false, 0, []),
                                    lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33127, [?SUCCESS]),
                                    {ok, NewPlayer};
                                {false, ErrorCode} ->
                                    lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [ErrorCode]);
                                _Err ->
                                    ?ERR("change to act boss scene err:~p", [_Err]),
                                    lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(system_busy)])
                            end;
                        {false, ErrorCode} ->
                            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [ErrorCode])
                    end;
                _ -> skip
            end;
        _ ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

handle(33128, PS, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:send_info(PS, Type, SubType);
        _ ->
            ?PRINT(" =============== 33128 act_end ~n",[]),
            skip
    end;

handle(33129, PS, [Type, SubType, Pool]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:role_choose_pool(PS, Type, SubType, Pool);
        _ ->
            ?PRINT(" =============== 33129 act_end ~n",[]),
            skip
    end;

handle(33130, PS, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_lucky_turntable:send_act_info(PS, ActInfo);
        _ ->
            skip
    end;

handle(33131, PS, [Type, SubType]) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        ActInfo when is_record(ActInfo, act_info) ->
            lib_lucky_turntable:turntable(PS, ActInfo);
        _ ->
            skip
    end;

handle(33132, PS, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_lucky_turntable:send_turntable_records(PS#player_status.id, Type, SubType);
        _ ->
            skip
    end;

handle(33133, PS, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:reset_act(PS, Type, SubType);
        _ ->
            ?PRINT(" =============== 33133 act_end ~n",[]),
            skip
    end;

handle(33134, PS, [Type, SubType, AutoBuy]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:draw(PS, Type, SubType, AutoBuy);
        _ ->
            ?PRINT(" =============== 33134 act_end ~n",[]),
            skip
    end;

handle(33135, PS, [Type, SubType, GradeId]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:recieve_stage_reward(PS, Type, SubType, GradeId);
        _ ->
            ?PRINT(" =============== 33135 act_end ~n",[]),
            skip
    end;

%% 0元豪礼界面信息
handle(33136, Player, [SubType]) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    mod_login_return_reward:send_act_info(RoleId, RoleLv, SubType);

%% 0元豪礼购买
handle(33137, Player, [SubType, GradeId]) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}} = Player,
    case catch mod_login_return_reward:check_buy(RoleId, RoleLv, SubType, GradeId) of
        {ok, CostList, ActInfo, RewardCfg} ->
            RewardL = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
            case lib_goods_api:can_give_goods(Player, RewardL) of
                true ->
                    case CostList =/= [] of
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, CostList, login_return_reward_buy, "") of
                                {true, NewPlayer} ->
                                    mod_login_return_reward:buy(RoleId, RoleName, RoleLv, SubType, GradeId, CostList, RewardCfg, RewardL);
                                {false, ErrorCode, NewPlayer} ->
                                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode])
                            end;
                        _ ->
                            NewPlayer = Player,
                            mod_login_return_reward:buy(RoleId, RoleName, RoleLv, SubType, GradeId, CostList, RewardCfg, RewardL)
                    end,
                    {ok, NewPlayer};
                {false, ErrorCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode])
            end;
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode]);
        Err ->
            ?ERR("login_return_reward_check_buy err:~p", [Err]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(system_busy)])
    end;

%% 0元豪礼领取返利奖励
handle(33138, Player, [SubType, GradeId]) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    case catch mod_login_return_reward:check_receive_reward(RoleId, RoleLv, SubType, GradeId) of
        {ok, RewardL} ->
            case lib_goods_api:can_give_goods(Player, RewardL) of
                true ->
                    mod_login_return_reward:receive_reward(RoleId, RoleLv, SubType, GradeId, RewardL);
                {false, ErrorCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode])
            end;
        {false, ErrorCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrorCode]);
        Err ->
            ?ERR("login_return_reward_check_receive_reward err:~p", [Err]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(system_busy)])
    end;

handle(33139, PS, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_select_pool_draw:calc_rand_pool(PS, Type, SubType);
        _ ->
            ?PRINT(" =============== 33135 act_end ~n",[]),
            skip
    end;

%% 嗨点信息
handle(_Cmd = 33140, Player, [_SubType]) ->
    % case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT, SubType) of
    %     true ->
    %         mod_hi_point:act_info(SubType, Player#player_status.id, Player#player_status.figure#figure.lv);
    %     false ->
    %         lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    % end;
    {ok, Player};

handle(_Cmd = 33141, Player, [Type, SubType]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_bonus_pool:send_act_data(Player, Type, SubType);
        false ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

handle(_Cmd = 33142, Player, [Type, SubType, Grade, Times, AutoBuy]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_bonus_pool:get_bonus(Player, Type, SubType, Times, AutoBuy, Grade);
        false ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

%% 连续消费活动
handle(_Cmd = 33143, #player_status{sid = Sid, id = RoleId}, [SubType]) ->
    Type = ?CUSTOM_ACT_TYPE_CONTINUE_CONSUME,
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{stime = Stime, etime = Etime} ->
            GL = [GId || GId <- lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GId) of
                    #custom_act_reward_cfg{condition = Condition} ->
                        case lib_custom_act_check:check_act_condtion([type], Condition) of
                            [2] -> true;
                            _ -> false
                        end;
                    _ -> ?ERR("cfg err!~n", []), false
                end],
            case GL of
                [GradeId | _] ->
                    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
                    [GoldLim] = lib_custom_act_check:check_act_condtion([gold], Condition),
                    DayNum = lib_consume_data:get_consume_gold_between(RoleId, utime:standard_unixdate(), Etime),
                    F = fun
                            ({_, Gold}, Acc) when Gold >= GoldLim -> Acc + 1;
                            (_, Acc) -> Acc
                        end,
                    ContDay = lists:foldl(F, 0, lib_consume_data:get_consume_day_by_day(RoleId, ?GOLD, Stime, Etime)),
                    %?PRINT("~p~n", [[DayNum, ContDay]]),
                    lib_server_send:send_to_sid(Sid, pt_331, 33143, [DayNum, ContDay]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err_config)])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

handle(_Cmd = 33144, Player, [Type, SubType, Grade]) ->
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            lib_bonus_pool:reset(Player, Type, SubType, Grade);
        false ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

%% boss首杀信息
handle(_Cmd = 33145, PS, [SubType]) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType) of
        true ->
            mod_boss_first_blood:act_info(SubType, RoleId);
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33100, [?ERRCODE(err331_act_closed)])
    end;

%% boss首杀领取奖励
handle(_Cmd = 33146, PS, [SubType, Grade, BossId]) ->
    #player_status{id = RoleId} = PS,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType) of
        true ->
            case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_BOSS_FIRST_BLOOD, SubType, Grade) of
                #custom_act_reward_cfg{condition = Condition, reward = RewardL} when RewardL =/= [] ->
                    case lists:keyfind(boss_id, 1, Condition) of
                        {_, BossId} ->
                            case lib_goods_api:can_give_goods(PS, RewardL) of
                                true ->
                                    mod_boss_first_blood:receive_reward(RoleId, SubType, BossId, RewardL);
                                {false, ErrorCode} -> lib_custom_act:send_error_code(RoleId, ErrorCode)
                            end;
                        _ -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err_config))
                    end;
                _ -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err_config))
            end;
        false -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 超值礼包时间戳
handle(_Cmd = 33148, PS, [SubType]) ->
    #player_status{id = RoleId, sid = Sid, overflow_gift = Maps} = PS,
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG, SubType) of
        #act_info{stime = _STime} ->
            LvTime = maps:get(SubType, Maps, 0),
            lib_server_send:send_to_sid(Sid, pt_331, 33148, [SubType, LvTime]);
        _ -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 精品特卖时间戳
handle(_Cmd = 33149, PS, [SubType]) ->
    #player_status{id = RoleId, sid = Sid, spec_sell_act = Maps} = PS,
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_SPEC_SELL, SubType) of
        #act_info{stime = _STime} ->
            LvTime = maps:get(SubType, Maps, 0),
            lib_server_send:send_to_sid(Sid, pt_331, 33149, [SubType, LvTime]);
        _ -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 购买烟花
handle(_Cmd = 33151, Player, [SubType, Num]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, SubType) of
        true ->
            case lib_fireworks_act:buy_fireworks(Player, Num) of
                {true, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_331, 33151, [?SUCCESS]);
                {Res, NewPS} ->
                    lib_custom_act:send_error_code(RoleId, Res)
            end,
            {ok, NewPS};
        false ->
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 烟花配置世界等级
handle(_Cmd = 33152, Player, [SubType]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, SubType) of
        true ->
            case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_ACT_FIREWORKS, SubType) of
                false -> lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed));
                #act_info{wlv = Wlv} ->
                    CfgWlv = lib_fireworks_act:get_cfg_wlv(data_fireworks_act:get_wlv_list(), Wlv),
                    lib_server_send:send_to_sid(Sid, pt_331, 33152, [CfgWlv])
            end;
        false ->
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 每日转盘抽奖
handle(_Cmd = 33153, Player, [SubType, Type]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
        true ->
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
                #custom_act_cfg{condition = Condition} ->
                    NeedNum = ?IF(Type == 0, 1, 10),
                    case lib_goods_api:get_cell_num(Player) >= NeedNum of
                        true ->
                            [OpenLv] = lib_custom_act_check:check_act_condtion([role_lv], Condition),
                            case Lv >= OpenLv of
                                true ->
                                    lib_daily_turntable:turn(SubType, Player, Type);
                                false ->
                                    lib_server_send:send_to_uid(RoleId, pt_331, 33153, [?ERRCODE(lv_limit), SubType, Type, []])
                            end;
                        false ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33153, [?ERRCODE(err150_no_cell), SubType, Type, []])
                    end
            end;
        false ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33153, [?ERRCODE(err331_act_closed), SubType, Type, []])
    end;

%% 每日转盘抽奖记录
handle(_Cmd = 33154, Player, [SubType]) ->
    #player_status{id = RoleId} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_DAILY_TURNTABLE, SubType) of
        true ->
            mod_daily_turntable:send_records(RoleId, SubType);
        false ->
            lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 活动红包雨界面
handle(_Cmd = 33155, Player, [SubType]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType) of
        true ->
            mod_red_envelopes_rain:send_red_envelopes_rain([SubType, RoleId, Sid]);
        false ->
            lib_server_send:send_to_sid(Sid, pt_331, 33155, [SubType, 0, 0, 0, 0,[]])
            %lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
    end;

%% 活动红包雨奖励列表
% handle(_Cmd = 33156, Player, [SubType, Wave]) ->
%     #player_status{id = RoleId, sid = Sid} = Player,
%     case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType) of
%         true ->
%             mod_red_envelopes_rain:send_red_envelopes_rain_reward_view([SubType, Wave, RoleId, Sid]);
%         false ->
%             lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
%     end;

%% 抢红包
handle(_Cmd = 33157, Player, [SubType]) ->
    #player_status{sid = Sid} = Player,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN, SubType) of
        #act_info{wlv = Wlv, etime = Etime} when NowTime < Etime ->
            RerReceiver = lib_red_envelopes_rain:make_envelopes_receiver(Player),
            mod_red_envelopes_rain:receive_red_envelopes([SubType, Sid, Wlv, RerReceiver]);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_331, 33157, [?ERRCODE(err331_act_closed), SubType, 0, []])
    end;

%% 打开红包
% handle(33158, Player, [_SubType, RedEnvelopesId]) ->
%     #player_status{id = RoleId} = Player,
%     case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RED_ENVELOPES_RAIN) of
%         true ->
%             mod_red_envelopes:open_red_envelopes(?ACT_RED_ENVELOPES, 0, RoleId, RedEnvelopesId);
%         false ->
%             lib_custom_act:send_error_code(RoleId, ?ERRCODE(err331_act_closed))
%     end;

%% 打开幸运鉴宝
handle(33160, Ps, [SubType]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        te_status = TEStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_TREASURE_EVALUATION),
    LuckyNumMax = mod_daily:get_limit_by_sub_module(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_TREASURE_EVALUATION),
    LuckyNum = lib_treasure_evaluation:get_te_lucky_num(SubType, TEStatus),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT;
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
                false ->
                    Code = ?ERRCODE(err331_act_closed);
                true ->
                    Code = ?SUCCESS
            end
    end,
    {ok, Bin} = pt_331:write(33160, [Code, SubType, LuckyNum, LuckyNumMax]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 开始幸运鉴宝
handle(33161, Ps, [SubType, Type]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        te_status = TEStatus
    } = Ps,
    #figure{
        name = Name,
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_TREASURE_EVALUATION),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            NewLuckyNum = 0,
            RewardIdList = [],
            NewPs = Ps;
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType) of
                false ->
                    Code = ?ERRCODE(err331_act_closed),
                    NewLuckyNum = 0,
                    RewardIdList = [],
                    NewPs = Ps;
                true ->
                    case lib_goods_api:get_cell_num(Ps) > 0 of
                        false ->
                            Code = ?ERRCODE(err401_bag_cell_not_enough),
                            NewLuckyNum = 0,
                            RewardIdList = [],
                            NewPs = Ps;
                        true ->
                            case Type of
                                1 ->
                                    CostList = ?TeCostListOnce,
                                    Times = 1;
                                _ ->
                                    CostList = ?TeCostListTen,
                                    Times = 10
                            end,
                            LuckyNumMax = mod_daily:get_limit_by_sub_module(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_TREASURE_EVALUATION),
                            OldLuckyNum = lib_treasure_evaluation:get_te_lucky_num(SubType, TEStatus),
                            {main_reward_id, MainRewardId} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_TREASURE_EVALUATION, SubType, main_reward_id),
                            RewardWeightList = data_treasure_evaluation:get_te_weight_list(MainRewardId),
                            MainRewardCon = data_treasure_evaluation:get_te_main_reward_con(MainRewardId),
                            #te_main_reward_con{
                                big_reward_id = BigRewardId
                            } = MainRewardCon,
                            BigRewardWeightCon = data_treasure_evaluation:get_te_weight_con(MainRewardId, BigRewardId),
                            #te_reward_weight_con{
                                goods_list = BigGoodsList
                            } = BigRewardWeightCon,
                            F = fun(_No, {RewardIdList1, RewardList1, LuckNum1}) ->
                                case LuckNum1 >= LuckyNumMax of
                                    true ->
                                        [RewardTuple | _] = BigGoodsList,
                                        {[BigRewardId | RewardIdList1], [RewardTuple | RewardList1], 0};
                                    false ->
                                        RewardConId = urand:rand_with_weight(RewardWeightList),
                                        RewardWeightCon = data_treasure_evaluation:get_te_weight_con(MainRewardId, RewardConId),
                                        #te_reward_weight_con{
                                            goods_list = GoodsList
                                        } = RewardWeightCon,
                                        [RewardTuple | _] = GoodsList,
                                        case RewardConId of
                                            BigRewardId ->
                                                NewLuckNum2 = 0;
                                            _ ->
                                                NewLuckNum2 = LuckNum1 + ?AddLuckNum
                                        end,
                                        {[RewardConId | RewardIdList1], [RewardTuple | RewardList1], NewLuckNum2}
                                end
                                end,
                            {RewardIdList, RewardList, NewLuckyNum} = lists:foldl(F, {[], [], OldLuckyNum}, lists:seq(1, Times)),
                            case lib_goods_api:can_give_goods(Ps, RewardList) of
                                {false, _ErrorCode} ->
                                    Code = ?ERRCODE(err401_bag_cell_not_enough),
                                    NewPs = Ps;
                                true ->
                                    case lib_goods_api:cost_objects_with_auto_buy(Ps, CostList, treasure_evaluation, "") of
                                        {true, NewPs1, _} ->
                                            Code = ?SUCCESS,
                                            [begin
                                                 case RewardConId of
                                                     BigRewardId ->
                                                         [{_GoodsType, BigGoodsTypeId, BigGoodsNum} | _] = BigGoodsList,
                                                         GoodsColor = data_goods:get_goods_color(BigGoodsTypeId),
                                                         lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 10, [Name, RoleId, GoodsColor, BigGoodsTypeId, BigGoodsNum]);
                                                     _ ->
                                                         skip
                                                 end
                                             end || RewardConId <- RewardIdList],
                                            NewPs2 = lib_goods_api:send_reward(NewPs1, RewardList, treasure_evaluation, 0),
                                            NewPs = lib_treasure_evaluation:set_lucky_num(NewPs2, NewLuckyNum, SubType),
                                            SCostList = util:term_to_string(CostList),
                                            SRewardList = util:term_to_string(RewardList),
                                            lib_log_api:log_treasure_evaluation(RoleId, Type, OldLuckyNum, NewLuckyNum, SCostList, SRewardList),
                                            ta_agent_fire:log_treasure_evaluation(NewPs, Type, OldLuckyNum, NewLuckyNum);
                                        {false, Code, NewPs} ->
                                            skip
                                    end
                            end
                    end
            end
    end,
    {ok, Bin} = pt_331:write(33161, [Code, SubType, Type, NewLuckyNum, RewardIdList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 打开收集活动
handle(33162, Ps, [SubType]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_COLLECT),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_331:write(33162, [?LEVEL_LIMIT, SubType, 0, 0, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_COLLECT, SubType) of
                false ->
                    {ok, Bin} = pt_331:write(33162, [?ERRCODE(err331_act_closed), SubType, 0, 0, 0, 0, []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    mod_collect:open_collect(SubType, RoleId)
            end
    end;

%% 提交收集活动
handle(33163, Ps, [SubType, PutType]) ->
    #player_status{
        id = RoleId,
        mark = Mark,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_COLLECT),
    case Lv >= OpenLv of
        false ->
            NewPs = Ps,
            {ok, Bin} = pt_331:write(33163, [?LEVEL_LIMIT, SubType, PutType, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_COLLECT, SubType) of
                false ->
                    NewPs = Ps,
                    {ok, Bin} = pt_331:write(33163, [?ERRCODE(err331_act_closed), SubType, PutType, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    case lib_goods_api:get_cell_num(Ps) > 0 of
                        false ->
                            NewPs = Ps,
                            {ok, Bin} = pt_331:write(33163, [?ERRCODE(err401_bag_cell_not_enough), SubType, PutType, 0, 0]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        true ->
                            case PutType of
                                1 ->
                                    {put_money_list, CostList} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_COLLECT, SubType, put_money_list);
                                _ ->
                                    {put_goods_list, CostList} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_COLLECT, SubType, put_goods_list)
                            end,
                            case lib_goods_api:cost_object_list_with_check(Ps, CostList, collect_put, io_lib:format("~p", [SubType])) of
                                {true, NewPs} ->
                                    mod_collect:collect_put(SubType, PutType, RoleId, Mark);
                                {false, Code, NewPs} ->
                                    {ok, Bin} = pt_331:write(33163, [Code, SubType, PutType, 0, 0]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end
                    end
            end
    end,
    {ok, NewPs};

handle(33164, Ps, [SubType]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_RECHARGE_CONSUME),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            RechargeNum = 0,
            ConsumeNum = 0;
        true ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_RECHARGE_CONSUME, SubType) of
                false ->
                    Code = ?ERRCODE(err331_act_closed),
                    RechargeNum = 0,
                    ConsumeNum = 0;
                true ->
                    Code = ?SUCCESS,
                    {money_type, MoneyType} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_RECHARGE_CONSUME, SubType, money_type),
                    ActInfo = lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_RECHARGE_CONSUME, SubType),
                    #act_info{
                        stime = STime,
                        etime = ETime
                    } = ActInfo,
                    RechargeNum = lib_recharge_data:get_my_recharge_between(RoleId, STime, ETime),
                    ConsumeNum = lib_consume_data:get_consume_between(RoleId, MoneyType, STime, ETime)
            end
    end,
    {ok, Bin} = pt_331:write(33164, [Code, SubType, RechargeNum, ConsumeNum]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 赛博夺宝 界面
handle(_Cmd = 33165, Player, [Type, SubType]) ->
    case lib_bonus_draw:check_role_lv(Type, SubType, Player#player_status.figure#figure.lv) of
        true ->
            lib_bonus_draw:send_info(Player, Type, SubType);

        _ ->
            skip
    end;

%% 赛博夺宝 阶段奖励
handle(_Cmd = 33166, Player, [Type, SubType, Stage, GradeId, BuyType]) ->
    case lib_bonus_draw:check_role_lv(Type, SubType, Player#player_status.figure#figure.lv) of
        true ->
            lib_bonus_draw:stage_reward_get(Player, Type, SubType, Stage, GradeId, BuyType);
        {false, Code} ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33166, [Code, Type, SubType, Stage, GradeId, [], BuyType])
    end;

%% 赛博夺宝 抽奖
handle(_Cmd = 33167, Player, [Type, SubType, Times, AutoBuy]) ->
    case lib_bonus_draw:check_role_lv(Type, SubType, Player#player_status.figure#figure.lv) of
        true ->
            lib_bonus_draw:get_bonus(Player, Type, SubType, Times, AutoBuy);
        {false, Code} ->
            lib_server_send:send_to_sid(Player#player_status.sid, pt_331, 33167, [Code, Type, SubType, 0, 0, []])
    end;

handle(_Cmd = 33168, Player, [Type, SubType, GradeId]) ->
    lib_bonus_tree:shop_exchange(Type, SubType, GradeId, Player);

%% 实名认证成功
handle(_Cmd = 33169, Player, []) ->
    Type = ?CUSTOM_ACT_TYPE_NAME_VERIFICATION,
    SubtypeList = lib_custom_act_util:get_subtype_list(Type),
    F = fun(Subtype, PlayerTmp) ->
        ActData = #custom_act_data{id = {Type, Subtype}, type = Type, subtype = Subtype, data = [{1,1}]},
        PlayerTmp1 = lib_custom_act:save_act_data_to_player(PlayerTmp, ActData),
        PlayerTmp1
    end,
    NewPlayer = lists:foldl(F, Player, SubtypeList),
    {ok, NewPlayer};

%% 祈愿抽奖
handle(33176, Player, [Type, Subtype, Times, AutoBuy]) ->
    % ?MYLOG("xlh","========== 33176: ~p~n",[{Type, Subtype, Times, AutoBuy}]),
    NewPlayer = lib_bonus_pray:do_pray(Player, Type, Subtype, Times, AutoBuy),
    {ok, NewPlayer};

%% 祈愿界面信息
handle(33177, Player, [Type, Subtype]) ->
    % ?MYLOG("xlh","========== 33177: ~p~n",[{Type, Subtype}]),
    NewPlayer = lib_bonus_pray:send_pray_info(Player, Type, Subtype),
    {ok, NewPlayer};

handle(33178, Player, [Type, Subtype, GradeId]) ->
    % ?MYLOG("xlh","========== 33177: ~p~n",[{Type, Subtype}]),
    NewPlayer = lib_bonus_pray:get_stage_reward(Player, Type, Subtype, GradeId),
    {ok, NewPlayer};

%% 奖励领取（兑换多份奖励）
handle(_Cmd = 33179, Player, [Type, SubType, GradeId, Num]) ->
    if
        is_integer(Num) andalso Num > 0 ->
            lib_custom_act:receive_reward(Player, Type, SubType, GradeId, Num);
        true ->
            {ok, BinData} = pt_331:write(33100, [?ERRCODE(err331_error_send_data)]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;


%% 幸运翻牌界面信息
handle(_Cmd = 33180, Player, [Type, SubType]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    mod_lucky_flop:send_act_info(Type, SubType, RoleId, RoleLv);

%% 幸运翻牌刷新奖励
handle(_Cmd = 33181, Player, [Type, SubType, AutoBuy]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv} = Figure,
    case catch mod_lucky_flop:check_refresh(Type, SubType, RoleId, RoleLv) of
        {ok, free} ->
            NewPlayer = Player,
            mod_lucky_flop:refresh(Type, SubType, RoleId, []);
        {ok, CostList} ->
            Res = case AutoBuy == 1 of
                      true ->
                          lib_goods_api:cost_objects_with_auto_buy(Player, CostList, lucky_flop_refresh, "");
                      false ->
                          case lib_goods_api:cost_object_list_with_check(Player, CostList, lucky_flop_refresh, "") of
                              {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                              Other -> Other
                          end
                  end,
            case Res of
                {true, NewPlayer, RealCostList} ->
                    mod_lucky_flop:refresh(Type, SubType, RoleId, RealCostList);
                {false, ErrCode, NewPlayer} ->
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode])
            end;
        {false, ErrCode} ->
            NewPlayer = Player,
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]);
        _Err ->
            ?ERR("_Err>>>>>>:~p", [_Err]),
            NewPlayer = Player,
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(system_busy)])
    end,
    {ok, NewPlayer};

%% 幸运翻牌翻牌
handle(_Cmd = 33182, Player, [Type, SubType, Pos, AutoBuy]) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv, name = RoleName} = Figure,
    case lib_goods_api:get_cell_num(Player) > 0 of
        true ->
            case catch mod_lucky_flop:check_flop(Type, SubType, RoleId, RoleLv, Pos) of
                {ok, free} ->
                    NewPlayer = Player,
                    mod_lucky_flop:flop(Type, SubType, RoleId, Pos, []);
                {ok, CostList} ->
                    Res = case AutoBuy == 1 of
                              true ->
                                  lib_goods_api:cost_objects_with_auto_buy(Player, CostList, lucky_flop_cost, "");
                              false ->
                                  case lib_goods_api:cost_object_list_with_check(Player, CostList, lucky_flop_cost, "") of
                                      {true, TmpNewPlayer} -> {true, TmpNewPlayer, CostList};
                                      Other -> Other
                                  end
                          end,
                    case Res of
                        {true, NewPlayer, RealCostList} ->
                            mod_lucky_flop:flop(Type, SubType, RoleId, RoleName, Pos, RealCostList);
                        {false, ErrCode, NewPlayer} ->
                            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode])
                    end;
                {false, ErrCode} ->
                    NewPlayer = Player,
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]);
                _Err ->
                    ?ERR("_Err>>>>>>:~p", [_Err]),
                    NewPlayer = Player,
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(system_busy)])
            end;
        false ->
            NewPlayer = Player,
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err150_no_cell)])
    end,
    {ok, NewPlayer};

%% 幸运翻牌展开卡牌
handle(_Cmd = 33183, Player, [Type, SubType]) ->
    #player_status{id = RoleId} = Player,
    mod_lucky_flop:set_open_status(Type, SubType, RoleId),
    {ok, Player};


%% 摇摇乐的抽奖
handle(_Cmd = 33186, Player, [Type, SubType, Times, AutoBuy]) when Type ==  ?CUSTOM_ACT_TYPE_SHAKE->
%%    ?PRINT("33186 Type, SubType, Times AutoBuy:~p   ~p   ~p  ~p~n",[Type, SubType, Times , AutoBuy]),
    case Times == 1 orelse Times == 10 of
         true ->
            NewPlayer = lib_shake:shake(Player, Type, SubType, Times, AutoBuy),
             {ok, NewPlayer};
        false -> {ok, Player}
    end;

%% 摇摇乐的抽奖次数
handle( Cmd = 33187, Player, [Type, SubType]) when Type ==  ?CUSTOM_ACT_TYPE_SHAKE->
    ShakeTimes = lib_shake:get_draw_times(Player, SubType),
%%    ?PRINT("33187 Type : ~p, SubType :~p Times :~p  ~n",[Type, SubType, ShakeTimes]),
    lib_server_send:send_to_sid(Player#player_status.sid, pt_331, Cmd, [?SUCCESS, ShakeTimes]);

%% 节日排行榜榜单
handle(33188, #player_status{id  =  RoleId}  =  Player,  [])  ->
    mod_feast_cost_rank:send_to_client(RoleId),
    {ok, Player};

%% 节日排行榜奖励
handle(33189,  #player_status{id = RoleId} =  Player,  [SubType])  ->
    lib_feast_cost_rank:send_reward_to_client(RoleId, SubType),
    {ok, Player};


%% 摇钱树界面
handle(33190, #player_status{id = RoleId, sid = Sid, figure = #figure{lv = RoleLv}} = _Player, [Type, SubType]) ->
    case lib_bonus_tree:check_role_lv(Type, SubType, RoleLv) of
        {false, Code} ->
            lib_server_send:send_to_sid(Sid, pt_331, 33190, [Type, SubType, Code, 0, 0, [], []]);
        _ ->
            lib_bonus_tree:send_list(_Player, Type, SubType, Sid, RoleId)
    end;

%% 神圣召唤抽奖
handle(33191,  #player_status{sid = Sid, figure = #figure{lv = RoleLv}} = Player, [?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, Times, AutoBuy]) ->
    % ?MYLOG("cym", "draw_reward~n", []),
    case lib_holy_summon:check_role_lv(?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, RoleLv) of
        {false, Code} ->
            lib_server_send:send_to_sid(Sid, pt_331, 33191, [Code, ?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, 0, 0, []]);
        _ ->
            lib_holy_summon:draw_reward(Player, ?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, Times, AutoBuy)
    end;


%% 摇钱树抽奖
handle(33191, Player, [Type, SubType, Times, AutoBuy]) ->
    #player_status{id = RoleId, server_id = ServerId, sid = Sid, figure = #figure{lv = RoleLv}} = Player,
    case lib_bonus_tree:check_role_lv(Type, SubType, RoleLv) of
        {false, Code} ->
            lib_server_send:send_to_sid(Sid, pt_331, 33191, [Code, Type, SubType, 0, 0, []]);
        _ ->
            ?IF(Type =:= ?CUSTOM_ACT_TYPE_RUSH_TREASURE,
                mod_rush_treasure_kf:cast_center([{rush_treasure_draw, ServerId, RoleId, Type, SubType, Times, AutoBuy}]),
                lib_bonus_tree:get_bonus(Player, Type, SubType, Times, AutoBuy))
    end;

%%摇钱树累计奖励领取
handle(33192, Player, [?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, GradeId]) ->
    lib_holy_summon:get_stage_reward(?CUSTOM_ACT_TYPE_HOLY_SUMMON, SubType, GradeId, Player);

%%摇钱树累计奖励领取
handle(33192, Player, [Type, SubType, GradeId]) ->
    lib_bonus_tree:get_stage_reward(Type, SubType, GradeId, Player);

%% 节日活跃界面
handle(33193, #player_status{id = RoleId}, [Type, SubType]) ->
    % ?MYLOG("hjhliveness", "Type:~p, SubType:~p ~n", [Type, SubType]),
    mod_custom_act_liveness:send_info(RoleId, Type, SubType);

%% 节日活跃提交
handle(33194, Player, [Type, SubType, CostType]) ->
    lib_custom_act_liveness:commit(Player, Type, SubType, CostType);

%% 节日活跃领取全服奖励
handle(33195, #player_status{id = RoleId}, [Type, SubType, GradeId]) ->
    mod_custom_act_liveness:receive_ser_reward(RoleId, Type, SubType, GradeId);

%% 记录
handle(33197, #player_status{id = RoleId}, [Type, SubType]) ->
    OpenDay = util:get_open_day(),
    if
        OpenDay > 1 andalso (Type == ?CUSTOM_ACT_TYPE_ACTIVATION orelse Type == ?CUSTOM_ACT_TYPE_RECHARGE) ->
            mod_activation_draw:get_record(Type, SubType, RoleId);
        true ->
            mod_custom_act_record:cast({send_record_info, RoleId, Type, SubType})
    end;

%% 记录摇摇乐的日志
handle(33198, #player_status{id = RoleId}, [Type, SubType]) ->
    mod_shake:get_shake_log(RoleId, Type, SubType);



handle(_Cmd, _Player, _Data) ->
    {error, "pp_custom_act no match~n"}.
