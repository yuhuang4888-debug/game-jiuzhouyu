%% ---------------------------------------------------------------------------
%% @doc    充值活动
%% @author xiaoxiang
%% @since  2017-04-06
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_recharge_act).
-include ("server.hrl").
-include ("rec_recharge.hrl").
-include ("def_recharge.hrl").
-include ("def_cache.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("predefine.hrl").
-include ("common.hrl").
-include ("language.hrl").
-include ("errcode.hrl").
-include ("counter.hrl").
-include ("def_module.hrl").
-include ("def_daily.hrl").
-include ("recharge_act.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("figure.hrl").
-include ("chat.hrl").
-include ("custom_act.hrl").
-compile (export_all).


daily_clear(Delay) ->
    spawn(fun() -> util:multiserver_delay(Delay, ?MODULE, daily_clear, []) end).

daily_clear() ->
    ok.
    % OnlineList = ets:tab2list(?ETS_ONLINE),
    % [begin
    %      lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, login, []),
    %      timer:sleep(20)
    %  end||RoleId<-OnlineList].

%% 充值活动登陆
login(Player) ->
    #player_status{id = RoleId} = Player,
    InitPlayer = Player#player_status{recharge_act_status = #recharge_act_status{}},
    %% 福利卡初始化
    ProductList = db_get_recharge(RoleId),
    WelFarePlayer = do_login(welfare, InitPlayer, ProductList),
    % GrowupPlayer = do_login(growup, WelFarePlayer, ProductList),
    CumulationPlayer = lib_recharge_cumulation:login(WelFarePlayer),
    CumulationPlayer.

repair_welfare(Player) ->
    #player_status{id = RoleId} = Player,
    ProductList = db_get_recharge(RoleId),
    do_login(welfare, Player, ProductList).

%% 查看福利卡
get_welfare(Player) ->
    #player_status{sid = Sid, recharge_act_status = RechargeActStatus} = Player,
    #recharge_act_status{welfare = List} = RechargeActStatus,
    Today = utime:unixdate(),
    CfgList = data_recharge_act:get_welfare_product(),
    Info = [begin
                #base_recharge_product{product_type=Type,product_subtype=SubType} = data_recharge:get_product(ProductId),
                case lists:keyfind(ProductId, #recharge_goods.product_id, List) of
                    #recharge_goods{product_id = ProductId, left_count = Num, time = GotTime} ->
                        State
                        = if
                            Num =< 0 ->  %% 未购买
                                0;
                            GotTime > Today -> %% 已领取
                                2;
                            true ->     %% 可领取
                                1
                        end;
                    _ ->
                        Num = 0, State = 0
                end,
                {Type, SubType, ProductId, State, Num}
            end|| ProductId <-CfgList],
    AvailableList = [Item || {_, _, ProductId, State, _} = Item <- Info, State > 0 orelse check_product(ProductId)],
    lib_server_send:send_to_sid(Sid, pt_159, 15901, [AvailableList]).
    % ?PRINT("Info:~p ~n", [Info]),
    % Player.

%% 领取福利卡福利
get_welfare_reward(Player, ProductId) ->
    #player_status{id = RoleId} = Player,
    Checkist = [product, buy, already, bag, send],
    case check(Player, ProductId, Checkist) of
        {true, NewPlayer} ->
            get_welfare(NewPlayer),
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_GET_WEAFARE_REWARD),
            Errcode = ?SUCCESS;
        {false, Errcode, NewPlayer} ->
            skip
    end,
                                                % ?PRINT("Errcode:~p ~n", [Errcode]),
    lib_server_send:send_to_uid(RoleId, pt_159, 15902, [Errcode]),
    NewPlayer.


%% 事件处理
handle_event(PS,
             #event_callback{
                type_id = ?EVENT_RECHARGE,
                data  = #callback_recharge_data{
                           recharge_product = #base_recharge_product{
                                                 product_id   = ProductId,
                                                 product_type = _Type,
                                                 product_subtype = _SubType
                                                } = _Product,
                           associate_ids = AssociateIds
                          }}) ->
    %% ?PRINT("Type:~p, SubType:~p, ProductId:~p ~n", [Type, SubType, ProductId]),
    {ok, NewPS} = handle_product(PS, ProductId),
    {ok, LastPS} = lib_recharge:handle_associate_product(NewPS, AssociateIds),
    {ok, LastPS};
handle_event(PS, _) ->
    {ok, PS}.

%% ---------------------sql--------------------------------
db_get_recharge(RoleId) ->
    Sql = io_lib:format(<<"select `product_id`, `time`, `left_count` from `recharge_act` where role_id = ~p">>, [RoleId]),
    db:get_all(Sql).

db_replace_recharge(RoleId, ProductId, GotTime, LeftCount) ->
    % Now = utime:unixtime(),
    Sql = io_lib:format(<<"replace into  `recharge_act` (`role_id`, `product_id`, `time`, `left_count`) values(~p, ~p, ~p, ~p)">>, [RoleId, ProductId, GotTime, LeftCount]),
    db:execute(Sql).

%% ----------------------------login---------------------------------
check_product(ProductId) ->
    case lib_recharge_check:check_product(ProductId) of
        {true, _} ->
            true;
        _ ->
            false
    end.

%% 福利卡login
do_login(welfare, Player, ProductList) ->
    #player_status{recharge_act_status = RechargeActStatus} = Player,
    LastList = [#recharge_goods{product_id = ProductId, time = Time, left_count = LeftCount }||[ProductId, Time, LeftCount]<-ProductList],
    %% ?PRINT("LastList:~p ~n", [LastList]),
    case is_record(RechargeActStatus, recharge_act_status) of
        true ->
            NewRechargeActStatus = RechargeActStatus#recharge_act_status{welfare = LastList};
        _ ->
            NewRechargeActStatus = #recharge_act_status{welfare = LastList}
    end,
    Player#player_status{recharge_act_status = NewRechargeActStatus};


% %% 基金login
% do_login(growup, Player, ProductList) ->
%     #player_status{recharge_act_status = RechargeActStatus} = Player,
%     AliveProduct = [{ProductId, Time}||[ProductId, Time]<-ProductList],
%     AllProductList = data_recharge_act:get_all_growup(),
%     NewList = [case lists:keyfind(ProductId, 1, AliveProduct) of
%                    {ProductId, Time} ->
%                        #recharge_goods{
%                           product_id = ProductId,
%                           start_time = Time,
%                           state = 1
%                          };
%                    _ ->
%                        #recharge_goods{
%                           product_id = ProductId,
%                           start_time = 0,
%                           state = 0
%                          }
%                end||ProductId<-AllProductList, check_product(ProductId)],

%     %% ?PRINT("NewList:~p ~n", [NewList]),
%     F = fun([ProductId, Time], TempList) ->
%                 case data_recharge:get_product(ProductId) of
%                     %% #base_recharge_product{product_type = ?PRODUCT_TYPE_FUND} ->
%                     %%    RechargeGoods = #recharge_goods{
%                     %%        product_id = ProductId,
%                     %%        start_time = Time,
%                     %%        state = 1
%                     %%    },
%                     %%    lists:keystore(ProductId, #recharge_goods.product_id, TempList, RechargeGoods);
%                     _ ->
%                         TempList
%                 end
%         end,
%     LastList = lists:foldl(F, NewList, ProductList),
%     %% ?PRINT("LastList:~p ~n", [LastList]),
%     case is_record(RechargeActStatus, recharge_act_status) of
%         true ->
%             NewRechargeActStatus = RechargeActStatus#recharge_act_status{growup = LastList};
%         _ ->
%             NewRechargeActStatus = #recharge_act_status{growup = LastList}
%     end,
%     NewPlayer = Player#player_status{recharge_act_status = NewRechargeActStatus},
%     NewPlayer;

do_login(_, Player, _) -> Player.

%% can_recharge(Player, ProductId, ?PRODUCT_TYPE_FUND) ->
%%     #player_status{recharge_act_status = RechargeActStatus} = Player,
%%     #recharge_act_status{growup = Growup} = RechargeActStatus,
%%     case lists:keyfind(ProductId, #recharge_goods.product_id, Growup) of
%%         #recharge_goods{state=1} ->
%%             {false, ?ERRCODE(err158_already_buy)};
%%         _ ->
%%             true
%%     end;

can_recharge(Player, ProductId, ?PRODUCT_TYPE_WELFARE) ->
    #player_status{recharge_act_status = RechargeActStatus} = Player,
    #recharge_act_status{welfare = Wealfare} = RechargeActStatus,
    case lists:keyfind(ProductId, #recharge_goods.product_id, Wealfare) of
        #recharge_goods{left_count = LeftCount} when LeftCount > 0 ->
            {false, ?ERRCODE(err158_already_buy)};
        _ ->
            true
    end;

can_recharge(_,_,_) ->
    {false, ?ERRCODE(err158_product_type_error)}.

%%------------------------check----------------------------------------
check(Player, _Args, []) -> {true, Player};
check(Player, Args, [H|T]) ->
    case do_check(Player, Args, H) of
        {true, NewPlayer} ->
            check(NewPlayer, Args, T);
        {false, ErrCode, NewPlayer} ->
            %% ?PRINT("H:~p ~n", [H]),
            {false, ErrCode, NewPlayer}
    end.
%% check 福利卡是否存在配置
do_check(Player, ProductId, product) ->
    IdList = data_recharge_act:get_welfare_product(),
    case lists:member(ProductId, IdList) of
        true ->
            {true, Player};
        false ->
            {false, ?ERRCODE(err159_1_not_welfare), Player}
    end;

do_check(Player, ProductId, buy) ->
    #player_status{recharge_act_status = RechargeActStatus} = Player,
    #recharge_act_status{welfare = Welfare} = RechargeActStatus,
    case lists:keyfind(ProductId, #recharge_goods.product_id, Welfare) of
        #recharge_goods{left_count = LeftCount} when LeftCount > 0 ->
            {true, Player};
        _ ->
            {false, ?ERRCODE(err159_3_not_buy), Player}
    end;


%% check 福利卡是否已领取过
do_check(Player, ProductId, already) ->
    #player_status{recharge_act_status = RechargeActStatus} = Player,
    #recharge_act_status{welfare = Welfare} = RechargeActStatus,
    Today = utime:unixdate(),
    case lists:keyfind(ProductId, #recharge_goods.product_id, Welfare) of
        #recharge_goods{time = GotTime} when GotTime < Today ->
            {true, Player};
        _ ->
            {false, ?ERRCODE(err159_4_already_get), Player}
    end;
%% check 福利卡是否已领取过
% do_check(Player, ProductId, already) ->
%     #player_status{id=RoleId} = Player,
%     % Count = mod_daily:get_count(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_WEAFARE, ProductId),
%     case Count < 1 of
%         true ->
%             {true, Player};
%         _ ->
%             {false, ?ERRCODE(err159_4_already_get), Player}
%     end;
%% check 背包
do_check(Player, ProductId, bag) ->
    #recharge_welfare{reward = Reward} = data_recharge_act:get_welfare(ProductId),
    % Goods = [{TypeId, Num}||{Type, TypeId, Num}<-Reward, Type == ?TYPE_GOODS],
    case lib_goods_api:can_give_goods(Player, Reward) of
        true ->
            {true, Player};
        {false, ErrorCode} ->
            {false, ErrorCode, Player}
    end;

do_check(Player, ProductId, send) ->
    #player_status{id=RoleId, recharge_act_status = RechargeActStatus} = Player,
    #recharge_act_status{welfare = Welfare} = RechargeActStatus,
    #recharge_goods{left_count = Count} = RechargeGoods=lists:keyfind(ProductId, #recharge_goods.product_id, Welfare),
    Now = utime:unixtime(),
    NewCount = Count - 1,
    NewRechargeGoods = RechargeGoods#recharge_goods{left_count = NewCount, time = Now},
    NewWelfare = lists:keystore(ProductId, #recharge_goods.product_id, Welfare, NewRechargeGoods),
    TmpPlayer = Player#player_status{recharge_act_status = RechargeActStatus#recharge_act_status{welfare = NewWelfare}},
    #base_recharge_product{product_subtype=SubType} = data_recharge:get_product(ProductId),
    #recharge_welfare{reward = Reward,double_week = DoubleWeek} = data_recharge_act:get_welfare(ProductId),
    Week = utime:day_of_week(),
    case is_list(DoubleWeek) andalso lists:member(Week, DoubleWeek) of
        true ->
            Value = 2;
        _ ->
            Value = 1
    end,
    RewardList = [{T,TI,N*Value}||{T,TI,N}<-Reward],
                                                % send_tv(1, [RoleId, RewardList]),
    lib_goods_api:send_tv_tip(RoleId, RewardList),
    db_replace_recharge(RoleId, ProductId, Now, NewCount),
    Title = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),
    Content = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),
    {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(TmpPlayer, #produce{title = Title, content = Content, type = walfare_reward, reward = RewardList, show_tips = 1}),
    GoldNum = lists:sum([Nu||{Ty, _TyId, Nu}<-RewardList, Ty==?TYPE_BGOLD]),
    lib_log_api:log_welfare(RoleId, SubType, GoldNum, 2, NewCount, Now),
    ta_agent_fire:log_welfare(NewPlayer, [SubType, GoldNum, 2, NewCount]),
    % mod_daily:increment(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_WEAFARE, ProductId),
    {true, NewPlayer};
                                                % [growup_product, growup_already, growup_bag, growup_send]

% do_check(Player, {ProductId, _Rank}, growup_product) ->
%     #player_status{recharge_act_status = RechargeActStatus} = Player,
%     #recharge_act_status{growup = Growup} = RechargeActStatus,
% %     case lists:keyfind(ProductId, #recharge_goods.product_id, Growup)of
% %         #recharge_goods{state = 1} ->
% %             {true, Player};
% %         _ ->
% %             {false, ?ERRCODE(err159_3_not_buy), Player}
% %     end;

% % do_check(Player, {ProductId, Rank}, growup_already) ->
% %     #player_status{id=RoleId} = Player,
% %                                                 % #recharge_goods{num = NumList} = lists:keyfind(ProductId, #recharge_goods.product_id, Growup),
% %     Count = mod_daily:get_count(RoleId, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_GROWUP, ProductId*1000+Rank),
% %     case Count<1 of
% %         true ->
% %             {true, Player};
% %         _R ->
% %             %% ?PRINT("_R:~p ~n", [_R]),
% %             {false, ?ERRCODE(err159_4_already_get), Player}
% %     end;

% do_check(Player, {ProductId, Rank}, growup_request) ->
%     #player_status{figure = #figure{lv = RoleLv, vip = Vip}} = Player,
%     #recharge_growup{request = Request} = data_recharge_act:get_growup(ProductId, Rank),
%     F = fun({Type, Lv}, Bool) ->
%                 case Type of
%                     1 ->
%                         case RoleLv>=Lv of
%                             true ->
%                                 Bool;
%                             _ ->
%                                 false
%                         end;
%                     _ ->
%                         case Vip>=Lv of
%                             true ->
%                                 Bool;
%                             _ ->
%                                 false
%                         end
%                 end
%         end,
%     case lists:foldl(F, true, Request) of
%         true ->
%             {true, Player};
%         _ ->
%             {false, ?ERRCODE(err159_6_not), Player}
%     end;

% %% check 背包
% do_check(Player, {ProductId, Rank}, growup_bag) ->
%     #recharge_growup{reward = Reward} = data_recharge_act:get_growup(ProductId, Rank),
%                                                 % Goods = [{TypeId, Num}||{Type, TypeId, Num}<-Reward, Type == ?TYPE_GOODS],
%     case lib_goods_api:can_give_goods(Player, Reward) of
%         true ->
%             {true, Player};
%         _ ->
%             {false, ?ERRCODE(err159_5_bag_not_enough), Player}
%     end;

% do_check(Player, {ProductId, Rank}, growup_send) ->
%     #player_status{id=RoleId, figure=#figure{lv=Lv}, recharge_act_status = RechargeActStatus} = Player,
%     #recharge_act_status{growup = Growup} = RechargeActStatus,

%     #recharge_goods{start_time=StartTime} = lists:keyfind(ProductId, #recharge_goods.product_id, Growup),
%     #base_recharge_product{product_subtype=SubType} = data_recharge:get_product(ProductId),

%     #recharge_growup{reward = Reward} = data_recharge_act:get_growup(ProductId, Rank),
%     mod_counter:increment(Player#player_status.id, ?MOD_RECHARGE_ACT,?MOD_RECHARGE_ACT_GROWUP, ProductId*1000+Rank),
%     Title = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),
%     Content = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),

%     {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(Player, #produce{title = Title, content = Content, type = walfare_reward, reward = Reward, show_tips = 1}),

%     [lib_log_api:log_growup(RoleId, SubType, Lv, Num, utime:unixtime(), StartTime)||{_,_,Num}<-Reward],
%     {true, NewPlayer};

do_check(Player, _Args, _R) ->
    %% ?PRINT("do_check _Args:~p, _R:~p ~n", [_Args, _R]),
    {false, ?FAIL, Player}.

%% ------------------------do_handle_event------------------------------------
%%
handle_product(PS, ProductId) ->
    #base_recharge_product{
       product_type    = ProductType,
       product_subtype = ProductSubType
      } = lib_recharge_check:get_product(ProductId),
    NewPS = pre_handle_product(PS, ProductType, ProductSubType, ProductId),
    %NewPS = do_handle_product(PS, ProductType, ProductSubType, ProductId),
    {ok, NewPS}.

%% 购买成长基金
%% do_handle_product(PS, ?PRODUCT_TYPE_FUND, SubType, ProductId) ->
%%     #player_status{id = RoleId, recharge_act_status = RechargeActStatus, figure=#figure{lv=Lv}} = PS,
%%     #recharge_act_status{growup = Growup} = RechargeActStatus,
%%     Now = utime:unixtime(),

%%     RechargeGoods = #recharge_goods{product_id = ProductId,start_time = Now,state = 1},
%%     case lib_recharge_check:check_product(ProductId) of
%%         {true,_} ->
%%             case lists:keyfind(ProductId, #recharge_goods.product_id, Growup) of
%%                 #recharge_goods{state = 0} ->
%%                     db_replace_recharge(RoleId, ProductId),
%%                     lib_log_api:log_growup(RoleId, SubType, Lv, 0, 0, Now),
%%                     NewGrowup = lists:keystore(ProductId, #recharge_goods.product_id, Growup, RechargeGoods);
%%                 #recharge_goods{end_time=OldEndTime} when OldEndTime < Now->
%%                     db_replace_recharge(RoleId, ProductId),
%%                     lib_log_api:log_growup(RoleId, SubType, Lv, 0, 0, Now),
%%                     NewGrowup = lists:keystore(ProductId, #recharge_goods.product_id, Growup, RechargeGoods);
%%                 #recharge_goods{} ->
%%                     NewGrowup = Growup,
%%                     ?ERR("already buy growup Type:~p, SubType:~p, OldProductId:~p, ProductId:~p  ~n", [?PRODUCT_TYPE_FUND, SubType, ProductId, ProductId])
%%             end;
%%         _R ->
%%             NewGrowup = Growup,
%%             ?ERR("check fail growup Type:~p, SubType:~p,  ProductId:~p _R:~p ~n", [?PRODUCT_TYPE_FUND, SubType,  ProductId, _R])
%%     end,
%%     NewRechargeActStatus = RechargeActStatus#recharge_act_status{growup = NewGrowup},
%%     NewPs = PS#player_status{recharge_act_status = NewRechargeActStatus},
%%     get_growup(NewPs);

pre_handle_product(PS, ProductType, ProductSubType, ProductId) ->
    NewProductType = lib_recharge_api:change_recharge_type(ProductId, ProductType),
    do_handle_product(PS, NewProductType, ProductSubType, ProductId).
    
%% 普通充值
do_handle_product(PS, ?PRODUCT_TYPE_NORMAL, _, ProductId) ->
    #player_status{accid = AccId, accname = AccName} = PS,
    lib_recharge_cumulation:update(PS),
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_7_RECHARGE) of
        [_|_] = ReActs ->
            [pp_recharge_act:handle(15957, PS, [Type7, SubType7, STime]) || #act_info{key = {Type7, SubType7}, stime = STime} <- ReActs];
        _ ->
            ok
    end,
    pp_recharge_act:handle(15959, PS, []),
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_RECHARGE_GIFT) of
        [_|_] = ReActsGift ->
            [pp_recharge_act:handle(15958, PS, [GiftAct, GiftActSub]) || #act_info{key = {GiftAct, GiftActSub}} <- ReActsGift];
        _ ->
            ok
    end,
%%    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_HI_POINT) of
%%        [_|_] = HPActs ->
%%            [  mod_hi_point:refresh_recharge(PS#player_status.id, HActSub, lib_recharge_data:get_my_recharge_between(PS#player_status.id, HSTime, HETime))
%%                || #act_info{key = {_, HActSub}, stime = HSTime, etime = HETime} <- HPActs ];
%%        _ ->
%%            ok
%%    end,
    % case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_LUCKY_TURNTABLE) of
    %     [_|_] = LuckActs ->
    %         lib_lucky_turntable:send_act_infos(PS, LuckActs);
    %     _ ->
    %         ok
    % end,
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_RECHARGE_RANK) of
        [_|_] = RRActs ->
            IsLimit = lib_recharge_limit:check_recharge_limit_direct(AccId, AccName),
            [ not IsLimit andalso lib_consume_rank_act:refresh_recharge(RSubType, PS, lib_recharge_data:get_my_recharge_between(PS#player_status.id, RSTime, RETime))
                ||  #act_info{key = {_, RSubType}, stime = RSTime, etime = RETime} <- RRActs];
        _ ->
            ok
    end,
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_RECHARGE_CONSUME) of
        [_|_] = RCActs ->
            [pp_custom_act:handle(33164, PS, [SubType])
                ||  #act_info{key = {_, SubType}} <- RCActs];
        _ ->
            ok
    end,
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE) of
        [_|_] = TempRCActs ->
            [lib_player:apply_cast(PS#player_status.id, ?APPLY_CAST_SAVE, lib_festival_recharge, refresh_recharge, [SubType])
                ||  #act_info{key = {_, SubType}} <- TempRCActs];
        _ ->
            ok
    end,
    case lib_custom_act_api:get_open_custom_act_infos(?CUSTOM_ACT_TYPE_OVERSEAS_RECHARGE) of
        [_|_] = OsActL ->
            [pp_recharge_act:handle(15958, PS, [OsAct, OsActSub]) || #act_info{key = {OsAct, OsActSub}} <- OsActL];
        _ ->
            ok
    end,
    lib_recharge_one:refresh_recharge(PS, ProductId);

%% 礼包充值
do_handle_product(PS, ?PRODUCT_TYPE_GIFT, _SubType, ProductId) ->
    LevelPS1 = lib_level_act:refresh_recharge(PS, ProductId),
    {ok, SpecialPs} = lib_special_gift:handle_product(LevelPS1, ProductId),
    lib_recharge_one:refresh_recharge(SpecialPs, ProductId);
%% 购买福利卡
do_handle_product(PS, ?PRODUCT_TYPE_WELFARE, SubType, ProductId) ->
    #player_status{id = RoleId, recharge_act_status = RechargeActStatus} = PS,
    #recharge_act_status{welfare = Welfare} = RechargeActStatus,
    #recharge_welfare{days = Days, buy_reward = BuyReward} = data_recharge_act:get_welfare(ProductId),
    Now = utime:unixtime(),
    % EndTime = utime:unixdate(Now)+(Days+1)*24*3600,
    % RechargeGoods = #recharge_goods{product_id = ProductId,left_count = Days},
    case lib_recharge_check:check_product(ProductId) of
        {true, _} ->
            case lists:keyfind(ProductId, #recharge_goods.product_id, Welfare) of
                #recharge_goods{left_count = LeftCount} ->
                    NewCount = LeftCount + Days,
                    GotTime = 0;
                _ ->
                    NewCount = Days,
                    GotTime = 0
                % #recharge_goods{left_count=0}->
                %     db_replace_recharge(RoleId, ProductId, Now, EndTime),
                %     lib_log_api:log_welfare(RoleId, SubType, 0, 0, utime:unixtime(), utime:unixtime()),
                %     NewWelfare = lists:keystore(ProductId, #recharge_goods.product_id, Welfare, RechargeGoods);
                % #recharge_goods{end_time = OldEndTime} ->
                %     NewWelfare = Welfare,
                %     ?ERR("already buy welfare Type:~p, SubType:~p, OldProductId:~p, ProductId:~p  ~n", [?PRODUCT_TYPE_WELFARE, SubType, ProductId, ProductId])
            end,
            db_replace_recharge(RoleId, ProductId, GotTime, NewCount),
            lib_log_api:log_welfare(RoleId, SubType, 0, 1, NewCount, Now),
            ta_agent_fire:log_welfare(PS, [SubType, 0, 1, NewCount]),
            RechargeGoods = #recharge_goods{product_id = ProductId,left_count = NewCount, time = GotTime},
            NewWelfare = lists:keystore(ProductId, #recharge_goods.product_id, Welfare, RechargeGoods),
            NewRechargeActStatus = RechargeActStatus#recharge_act_status{welfare = NewWelfare},
            NewPs = PS#player_status{recharge_act_status = NewRechargeActStatus},
            get_welfare(NewPs),
            case BuyReward of
                [] ->
                    NewPs;
                _ ->
                    Title = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),
                    Content = ?LAN_MSG(?LAN_TITLE_RECHAEGE_REWARD),
                    Produce = #produce{title = Title, content = Content, type = walfare_reward, reward = BuyReward},
                    {ok, NewPlayer} = lib_goods_api:send_reward_with_mail(NewPs, Produce),

                    [begin
                         {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({?ERRCODE(err339_14_buy_success),[GoldNum]}),
                         {ok, Bin}=pt_110:write(11017, [?FLOAT_TEXT_ONLY, ErrorCodeInt, ErrorCodeArgs]),
                         lib_server_send:send_to_uid(RoleId, Bin)
                     end||{?TYPE_GOLD, _, GoldNum}<-BuyReward],
                    NewPlayer
            end;
        _R ->
            ?ERR("check fail welfare Type:~p, SubType:~p,  ProductId:~p _R:~p ~n", [?PRODUCT_TYPE_WELFARE, SubType,  ProductId, _R]),
            PS
    end;

do_handle_product(PS, _Type, _SubType, _ProductId) -> PS.

gm_repair_7day_recharge_act() ->
    ok.
    % case lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_7_RECHARGE, 1) of
    %     #act_info{etime = Etime, stime = Stime} ->
    %         SQL = io_lib:format("select role_id, grade from custom_act_receive_reward where type = ~p AND subtype = 1 AND utime >= ~p AND utime < ~p", [?CUSTOM_ACT_TYPE_7_RECHARGE, Stime, Etime]),
    %         All = db:get_all(SQL),
    %         RoleGroups = lists:foldl(fun
    %             ([RoleId, GradeId], Acc) ->
    %                 case lists:keyfind(RoleId, 1, Acc) of
    %                     {RoleId, GradeList} ->
    %                         lists:keystore(RoleId, 1, Acc, {RoleId, [GradeId|GradeList]});
    %                     _ ->
    %                         [{RoleId, [GradeId]}|Acc]
    %                 end
    %         end, [], All),
    %         send_gm_rewards(RoleGroups);
    %     _ ->
    %         skip
    % end.

% send_gm_rewards([{RoleId, GradeList}|T]) ->
%     case lib_goods_api:make_reward_unique(lists:flatten([gm_rewards(GradeId) || GradeId <- GradeList])) of
%         [] ->
%             ?ERR("7day_gm_rewards nothing role_id = ~p, grade_ids = ~p~n", [RoleId, GradeList]);
%         RewardList ->
%             Title = "开服累充补偿",
%             Content = "亲爱的骑士大人，公主阁下决定提高开服累充的奖励力度，经查阅资料确认，可以给您补发以下奖励，敬请查收！",
%             lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
%             ?ERR("7day_gm_rewards done role_id = ~p, grade_ids = ~p~n", [RoleId, GradeList])
%     end,
%     send_gm_rewards(T);

% send_gm_rewards([]) -> ok.

    

% gm_rewards(1) ->
%     [{0,12010006,1},{0,26010002,1}];
% gm_rewards(2) ->
%     [{0,12030006,1},{0,32020001,3}];
% gm_rewards(3) ->
%     [{0,12020006,1},{0,26250002,1}];
% gm_rewards(4) ->
%     [{0,20030001,1},{0,32020001,5}];
% gm_rewards(5) ->
%     [{0,12010006,1},{0,32020002,5}];
% gm_rewards(6) ->
%     [{0,24030001,1},{0,32020002,8}];
% gm_rewards(7) ->
%     [{0,20030002,1},{0,26020003,1}];
% gm_rewards(8) ->
%     [{0,24030002,1},{0,32020002,10}];
% gm_rewards(9) ->
%     [{0,12030006,1},{0,26030003,1}];
% gm_rewards(10) ->
%     [{0,12020006,1},{0,26250004,1}];
% gm_rewards(_) -> [].



gm_send_daily_recharge_reward(Title, Content, StartTime, EndTime, GoldLimit, Reward) ->
    Sql = io_lib:format(<<"select  player_id , sum(gold) sum_gold  from   recharge_log  where  time >= ~p  and   time  <= ~p  GROUP BY  player_id  HAVING sum_gold >=  ~p">>,
        [StartTime, EndTime, GoldLimit]),
    RoleList1 = db:get_all(Sql),
%%    ?MYLOG("cym", "Title '~s', Content '~s' ~n", [Title, Content]),
%%    ?PRINT("RoleList1 ~p", [RoleList1]),
    RoleList2 = [RoleId || [RoleId, _] <- RoleList1],
    case RoleList2 of
        [] ->
            ok;
        _ ->
            lib_mail_api:send_sys_mail(RoleList2, util:make_sure_list(Title), util:make_sure_list(Content), util:string_to_term(Reward))
    end.

    


