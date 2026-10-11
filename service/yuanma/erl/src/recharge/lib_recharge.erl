%% ---------------------------------------------------------------------------
%% @doc    充值系统
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_recharge).
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
-include("figure.hrl").
-include("def_fun.hrl").
-export ([
        login/1,
        send_total_gold_info/2,     %% 发送总充值数
        pay/1,                      %% 充值入账游戏服务器
        pay_by_goods/3,             %% 使用物品充值
        pay_by_goods2/3,            %% 使用物品充值礼包
        notify_handle_all_orders/0, %% 通知处理一批待处理的充值订单
        dispatch_event/6            %% 派发充值内部事件
        , gm_send_product/1
    ]).

-export ([
        handle_associate_product/2  %% 处理充值关联商品
    ]).

-export([
    handle_event/2                  %% vip升级事件
    ,filter_condition/2             %% 条件过滤
]).

login(PS) ->
    RechargeStatistic = #role_recharge_statistic{total_money = lib_recharge_data:get_total_rmb(PS#player_status.id)},
    PS#player_status{recharge_statistic = RechargeStatistic}.

%% 发送总充值数
send_total_gold_info(Sid, TotalGold) ->
    lib_server_send:send_to_sid(Sid, pt_158, 15803, [TotalGold]),
    ok.

%%%---------------------------------------------------------------------------
%%% 新增充值商品步骤：
%%% 1. 实现新商品充值入账逻辑处理，即往lib_recharge:do_pay/2添加新分支
%%% 2. 添加关联商品处理模块名，即往lib_recharge:get_associate_module/1添加新分支
%%% 3. 实现新商品充值事件回调模块，参考lib_recharge_product_example
%%% End
%%%---------------------------------------------------------------------------


%% 充值入账游戏服务器
%% 触发情况
%% 1.充值入账php后台后，调用游戏服务器接口
%% 2.定时器每分钟会调用一次该接口

%% 注:pay/1,pay_by_goods/3必须同时修改
pay(PS) ->
    #player_status{id = PlayerId} = PS,
    %% 取出玩家所有充值待处理记录
    case catch lib_recharge_data:get_my_all_recharge(PlayerId) of
        [] ->
            {ok, PS};
        PayList when is_list(PayList) ->
            NewPS = pay(PS, PayList),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end.

%% 实现充值
pay(PS, []) -> PS;
pay(PS, [[_Id, _Type, _ProductId, _Money, _Gold, _Ctime, undefined]|PayList]) -> pay(PS, PayList);
pay(PS, [[Id, _Type, ProductId, Money, Gold, _Ctime, PayNo]|PayList]) when is_integer(Gold) ->
    %% 时间取当前时间
    Ctime = utime:unixtime(),
    NewPS = do_pay(PS, [Id, _Type, ProductId, Money, Gold, Ctime, PayNo]),
    pay(NewPS, PayList);
pay(PS, [_T|PayList]) ->
    ?ERR("do recharge error, Error = ~p~n", [_T]),
    pay(PS, PayList).

do_pay(PS, [_Id, _Type, ProductId, Money, Gold, _Ctime, PayNo]= Args) ->
    NowTime = utime:unixtime(),
    Product = lib_recharge_check:get_product(ProductId),
    #base_recharge_product{product_type = ProductType} = Product,
    case ProductType of
        %% 普通充值
        ?PRODUCT_TYPE_NORMAL ->
            NewPS = do_pay_common(PS, ProductType, NowTime, Args),
            do_pay_help(normal, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
        %% ?PRODUCT_TYPE_FUND ->
        %%     NewPS = do_pay_common(PS, NowTime, Args),
        %%     do_pay_help(growup, NewPS, [Money, Gold, PayNo, NowTime, Product]);
        ?PRODUCT_TYPE_WELFARE ->
            NewPS = do_pay_common(PS, ProductType, NowTime, Args),
            PayHelpType = lib_recharge_util:welfare_recharge(),
            do_pay_help(PayHelpType, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
        ?PRODUCT_TYPE_DAILY_GIFT ->
            NewPS = do_pay_common(PS, ProductType, NowTime, Args),
            do_pay_help(daily_gift, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
        ?PRODUCT_TYPE_GIFT ->
            NewPS = do_pay_common(PS, ProductType, NowTime, Args),
            PayHelpType = lib_recharge_util:gift_recharge(ProductId),
            do_pay_help(PayHelpType, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
        ?PRODUCT_TYPE_DIRECT_GIFT ->
            NewPS = do_pay_common(PS, ProductType, NowTime, Args),
            do_pay_help(gift, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
        ?PRODUCT_TYPE_VERIFY ->
            % 审核服才能充值
            case lib_recharge_util:verify_recharge_support() of
                true ->
                    NewPS = do_pay_common(PS, ProductType, NowTime, Args),
                    do_pay_help(normal, NewPS, [Money, Gold, PayNo, NowTime, Product, PS#player_status.is_pay]);
                _ ->
                    ?ERR("unkown product_type:~p~n", [{ProductType, ProductId, Money, Gold}]),
                    PS
            end;
        _ ->
            ?ERR("unkown product_type:~p~n", [{ProductType, ProductId, Money, Gold}]),
            PS
    end.

do_pay_common(PS, ProductType, NewLastPayTime, [Id, _Type, ProductId, Money, Gold0, Ctime, _PayNo]) ->
    #player_status{id = PlayerId, accid = AccId, accname = AccName, sid = Sid} = PS,
    %% !!!! 修改充值记录状态为已经处理
    lib_recharge_data:finish_recharge(Id),
    Gold = lib_recharge_util:special_recharge_gold(ProductId, ProductType, Gold0),
    %% 充值日志-复制charge表的信息
    %% ProductType == ?PRODUCT_TYPE_DIRECT_GIFT 时 Gold 日志记录成0，本设定于20220223郑恒思与lzh对接
    RealGetGold = ?IF(ProductType == ?PRODUCT_TYPE_DIRECT_GIFT, 0, Gold),
    lib_recharge_data:db_insert_recharge_log(PS, 1, ProductId, Money, Gold, RealGetGold, Ctime),
    lib_recharge_data:update_total_rmb(PlayerId, Money),
    lib_recharge_data:update_daily_recharge(PlayerId, NewLastPayTime, Gold, Money),
    send_recharge_notify(Sid),
    %% 更新充值总额
    if
        Gold > 0 ->
            OldRechargeMoney = lib_recharge_data:get_total(PlayerId),
            NewRechargeMoney = OldRechargeMoney + Gold,
            send_total_gold_info(Sid, NewRechargeMoney),
            lib_recharge_data:update_total_recharge(PlayerId, NewRechargeMoney),
            %% 更新更新同账号的总充值金额
            lib_recharge_data:db_update_acc_total_charge(AccId, AccName, Gold);
        true ->
            ok
    end,
    lib_recharge_data:db_update_player_last_pay_time(PlayerId, NewLastPayTime),
    % 更新统计数据
    UpStatisticPS = update_statistic_with_recharge(PS, Money, NewLastPayTime),
    UpStatisticPS#player_status{is_pay = true, last_pay_time=NewLastPayTime}.

do_pay_help(normal, PS, [Money, Gold, PayNo, _NewLastPayTime, Product, IsPay]) ->
    #player_status{id = PlayerId} = PS,
    %% 增加元宝
    LogAbout  = lists:concat(["PayNo : ", binary_to_list(PayNo)]),
    NewPS = lib_goods_util:add_money(PS, Gold, ?GOLD, recharge, LogAbout),
    %% 发邮件
    send_pay_mail(PlayerId, Gold),
    %% 派发充值事件
    AssociateIds = get_associate_ids(Product),
    CallBackData = #callback_recharge_data{pay_no = PayNo, is_pay = IsPay, recharge_product = Product, associate_ids = AssociateIds, money = Money, gold = Gold},
    {ok, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_RECHARGE, CallBackData),
    lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_MONEY),
    LastPS;
% do_pay_help(growup, PS, [Money, Gold, _PayNo, _NewLastPayTime, Product]) ->
%     %% 派发充值事件
%     {ok, LastPS} = dispatch_event(PS, Money, Gold, Product),
%     LastPS;
do_pay_help(welfare, PS, [Money, _Gold, PayNo, _NewLastPayTime, Product, IsPay]) ->
    %% 派发充值事件
    {ok, LastPS} = dispatch_event(PS, Money, 0, Product, PayNo, IsPay),
    LastPS;
do_pay_help(daily_gift, PS, [Money, Gold, _PayNo, _NewLastPayTime, Product, IsPay]) ->
    %% 派发充值事件
    {ok, LastPS} = dispatch_event(PS, Money, Gold, Product, _PayNo, IsPay),
    LastPS;
do_pay_help(gift, PS, [Money, Gold, _PayNo, _NewLastPayTime, Product, IsPay]) ->
    %% 派发充值事件
    {ok, LastPS} = dispatch_event(PS, Money, Gold, Product, _PayNo, IsPay),
    LastPS;
do_pay_help(_Args1, _PS, _Args3) ->
    ?ERR("err158_product_type_error:~p,~p~n", [_Args1, _Args3]),
    {fail, ?ERRCODE(err158_product_type_error)}.

%% 派发充值事件
%% %% ！注：有些活动类型不受商品控制条件影响的不能使用 此公用充值派发事件。
%%          需要另外独立写，如：充值返利中终生首次返利不受商品控制条件影响
dispatch_event(PS, Money, Gold, Product, PayNo, IsPay) ->
    case lib_recharge_check:check_product(Product) of
        {true, _Product} ->
            AssociateIds = get_associate_ids(Product),
            CallBackData = #callback_recharge_data{
                recharge_product = Product, associate_ids = AssociateIds,
                pay_no = PayNo, money = Money, gold = Gold, is_pay = IsPay
            },
            {ok, NewPS} = lib_player_event:dispatch(PS, ?EVENT_RECHARGE, CallBackData),
            {ok, NewPS};
        Result ->
            ProductId = Product#base_recharge_product.product_id,
            ?ERR("check_product:~p,~p,~p~n", [ProductId, Money, Result]),
            {ok, PS}
    end.

%% 使用物品充值
pay_by_goods(PS, Product, GoodsId) when is_record(PS, player_status) ->
    #base_recharge_product{
       product_id      = ProductId,
       money           = Money,
       product_type    = ProductType
      } = Product,
    case ProductType of
        %% 普通充值
        ?PRODUCT_TYPE_NORMAL ->
            Gold  = round(Money*10),
            pay_by_goods_common(PS, [ProductId, Money, Gold]),
            do_pay_by_goods(normal, PS, [Money, Gold, Product, GoodsId]);
        %% ?PRODUCT_TYPE_FUND ->
        %%     pay_by_goods_common(PS, [ProductId, Money, Gold]),
        %%     do_pay_by_goods(growup, PS, [Money, Gold, Product, GoodsId]);
        ?PRODUCT_TYPE_WELFARE ->
            pay_by_goods_common(PS, [ProductId, Money, 0]),
            do_pay_by_goods(welfare, PS, [Money, 0, Product, GoodsId]);
        ?PRODUCT_TYPE_DAILY_GIFT ->
            Gold  = round(Money*10),
            pay_by_goods_common(PS, [ProductId, Money, Gold]),
            do_pay_by_goods(daily_gift, PS, [Money, Gold, Product, GoodsId]);
        _ -> {fail, ?ERRCODE(err158_product_type_error)}
    end.

%% 使用物品充值
pay_by_goods2(PS, Product, _Cost) when is_record(PS, player_status) ->
    #base_recharge_product{
        product_id      = ProductId,
        money           = Money,
        product_type    = ProductType
    } = Product,
    Gold  = round(Money*10),
    pay_by_goods_common2(PS, [ProductId, ProductType, Money, Gold]),
    %% 派发充值事件 跟 gift 充值一样
    {ok, LastPS} = dispatch_event(PS, Money, Gold, Product, "0", PS#player_status.is_pay),
    LastPS.

pay_by_goods_common(PS, [ProductId, Money, Gold]) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, accid = AccId, accname = AccName, sid = Sid} = PS,
    %% 充值日志
    lib_recharge_data:db_insert_recharge_log(PS, 2, ProductId, Money, Gold, Gold, NowTime),

    lib_recharge_data:update_daily_recharge(PlayerId, NowTime, Gold, Money),
    send_recharge_notify(Sid),
    %% 更新充值总额
    if
        Gold > 0 ->
            OldRechargeMoney = lib_recharge_data:get_total(PlayerId),
            NewRechargeMoney = OldRechargeMoney + Gold,
            send_total_gold_info(Sid, NewRechargeMoney),
            lib_recharge_data:update_total_recharge(PlayerId, NewRechargeMoney),
            %% 更新更新同账号的总充值金额
            lib_recharge_data:db_update_acc_total_charge(AccId, AccName, Gold);
        true ->
            ok
    end,
    ok.

pay_by_goods_common2(PS, [ProductId, ProductType, Money, Gold0]) ->
    NowTime = utime:unixtime(),
    #player_status{id = PlayerId, accid = AccId, accname = AccName, sid = Sid} = PS,
    Gold = lib_recharge_util:special_recharge_gold(ProductId, ProductType, Gold0),
    %% 充值日志-复制charge表的信息
    RealGetGold = ?IF(ProductType == ?PRODUCT_TYPE_DIRECT_GIFT, 0, Gold),
    %% 充值日志
    lib_recharge_data:db_insert_recharge_log(PS, 3, ProductId, Money, Gold, RealGetGold, NowTime),

    lib_recharge_data:update_daily_recharge(PlayerId, NowTime, Gold, Money),
    send_recharge_notify(Sid),
    %% 更新充值总额
    if
        Gold > 0 ->
            OldRechargeMoney = lib_recharge_data:get_total(PlayerId),
            NewRechargeMoney = OldRechargeMoney + Gold,
            send_total_gold_info(Sid, NewRechargeMoney),
            lib_recharge_data:update_total_recharge(PlayerId, NewRechargeMoney),
            %% 更新更新同账号的总充值金额
            lib_recharge_data:db_update_acc_total_charge(AccId, AccName, Gold);
        true ->
            ok
    end,
    ok.

%% 使用物品：普通充值
%% 走充值逻辑，但不涉及影响游戏收入统计，流水统计
do_pay_by_goods(normal, PS, [Money, Gold, Product, GoodsId]) ->
    #player_status{id=PlayerId, is_pay = IsPay} = PS,
    %% 增加元宝
    #base_recharge_product{product_id = ProductId} = Product,
    LogAbout  = ulists:concat(["GoodsId : ", GoodsId, ",", "ProductId : ", ProductId]),
    NewPS = lib_goods_util:add_money(PS, Gold, ?GOLD, recharge_card, LogAbout),
    %% 充值邮件
    send_pay_mail(PlayerId, Gold),

    %% 派发充值事件
    AssociateIds = get_associate_ids(Product),
    CallBackData = #callback_recharge_data{
        pay_no = "0", is_pay = IsPay, recharge_product = Product,
        associate_ids = AssociateIds, money = Money, gold = Gold
    },
    {ok, LastPS} = lib_player_event:dispatch(NewPS, ?EVENT_RECHARGE, CallBackData),
    lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_MONEY),
    LastPS;
% do_pay_by_goods(growup, PS, [Money, Gold, Product, _GoodsId]) ->
%     %% 派发充值事件
%     {ok, LastPS} = dispatch_event(PS, Money, Gold, Product),
%     LastPS;
do_pay_by_goods(welfare, PS, [Money, Gold, Product, _GoodsId]) ->
    %% 派发充值事件
    {ok, LastPS} = dispatch_event(PS, Money, Gold, Product, "0", PS#player_status.is_pay),
    LastPS;
do_pay_by_goods(daily_gift, PS, [Money, Gold, Product, _GoodsId]) ->
    %% 派发充值事件
    {ok, LastPS} = dispatch_event(PS, Money, Gold, Product, "0", PS#player_status.is_pay),
    LastPS;
do_pay_by_goods(_Args1, _PS, _Args3) ->
    ?ERR("err158_product_type_error:~p,~p~n", [_Args1, _Args3]),
    {fail, ?ERRCODE(err158_product_type_error)}.

%% 充值邮件
send_pay_mail(PlayerId, Gold) ->
    {{Y, M, D}, {H, N, _S}} = utime:unixtime_to_localtime(utime:unixtime()),
    Title   = ?LAN_MSG(?LAN_TITLE_RECHAEGE),
    Content = uio:format(?LAN_MSG(?LAN_CONTENT_RECHAEGE), [Y, M, D, H, N, Gold]),
    lib_mail_api:send_sys_mail([PlayerId], Title, Content, []),
    ok.

%% 通知处理一批待处理的充值订单，准备入账游戏服务器
notify_handle_all_orders() ->
    spawn(fun() -> do_notify_handle_all_orders() end),
    ok.

do_notify_handle_all_orders() ->
    case catch lib_recharge_data:get_all_recharge() of
        [] -> skip;
        List when is_list(List) ->
            F = fun([_Id, PlayerId, _CTime], PlayerIdList) ->
                        case lists:member(PlayerId, PlayerIdList) of
                            true -> PlayerIdList;
                            _ -> [PlayerId | PlayerIdList]
                        end
                end,
            PlayerIdList = lists:foldl(F, [], List),
            notify_handle_player_order_helper(PlayerIdList, 0);
        _ ->
            skip
    end.

%% 处理每个玩家订单
%% 玩家在线：发到该玩家进程，让玩家再从充值表拿出来处理
notify_handle_player_order_helper([], _I) -> ok;
notify_handle_player_order_helper([PlayerId|T], I) ->
    case I rem 10 of
        0 -> timer:sleep(500);
        _ -> skip
    end,
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_recharge, pay, []),
    notify_handle_player_order_helper(T, I+1).

send_recharge_notify(Sid) ->
    lib_server_send:send_to_sid(Sid, pt_158, 15802, []),
    ok.

%% ---------------------------------------------------------------------------
%% 关联商品处理部分
%% ---------------------------------------------------------------------------

%% 获取关联商品处理模块
get_associate_module(ProductType) ->
    case ProductType of
        %% 普通充值(含充值返利)
        ?PRODUCT_TYPE_NORMAL -> lib_recharge_return;
        %% ?PRODUCT_TYPE_FUND ->   lib_recharge_act;
        ?PRODUCT_TYPE_WELFARE-> lib_recharge_act;
        ?PRODUCT_TYPE_DAILY_GIFT-> lib_daily_gift;
        ?PRODUCT_TYPE_FIRST_GIFT-> lib_recharge_first;
        _ -> none
    end.

%% 获取关联商品id列表  注：不包含当前使用自身
%% @return [{product_type, product_id|...]
get_associate_ids(Product) ->
    case Product of
        #base_recharge_product{
           product_id     = ProductId, associate_list = AssociateList} ->
            get_associate_ids_helper(AssociateList, [], ProductId);
        _ -> []
    end.

%% ExcludeId :: 需要排除的商品Id, 即不包含当前使用自身
get_associate_ids_helper([], ResList, _ExcludeId) -> ResList;
get_associate_ids_helper([{ProductType, ProductSubType}|T], ResList, ExcludeId) ->
    IdList = data_recharge:get_product_ids_by_type(ProductType, ProductSubType),
    NewResList = [{ProductType, Id}||Id<-IdList, Id =/= ExcludeId] ++ ResList,
    get_associate_ids_helper(T, NewResList, ExcludeId).

%% 处理充值关联商品
%% @return{ok, #player_status{}}
handle_associate_product(PS, []) -> {ok, PS};
handle_associate_product(PS, [{ProductType, ProductId}|T]) ->
    %% 活动类型对应的模块
    case get_associate_module(ProductType) of
        none ->
            ?ERR("handle_associate_product:~p~n", [ProductType]),
            handle_associate_product(PS, T);
        Module ->
            case catch Module:handle_product(PS, ProductId) of
                {ok, NewPS} when is_record(NewPS, player_status) ->
                    handle_associate_product(NewPS, T);
                Error ->
                    ?ERR("handle_associate_product:~p~n", [Error]),
                    handle_associate_product(PS, T)
            end
    end.

%% ---------------------------------------------------------------------------
%% @doc 充值数据统计
%% ---------------------------------------------------------------------------
%% 充值的时候刷新统计数据
update_statistic_with_recharge(Player, Money, LastPayTime) ->
    #player_status{recharge_statistic = RechargeStatistic} = Player,
    #role_recharge_statistic{total_money = TotalMoney} = RechargeStatistic,
    NewTotalMoney = TotalMoney + Money,
    NewRechargeStatistic =
        RechargeStatistic#role_recharge_statistic{
            total_money = NewTotalMoney
        },
    NewTotalMoney =/= TotalMoney andalso ta_agent_fire:total_pay_amount(Player, LastPayTime, NewTotalMoney),
    Player#player_status{recharge_statistic = NewRechargeStatistic}.

%%  ==========================外文充值特殊需求============================
%% 事件回调
handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) ->
    IsCn = lib_vsn:is_cn(),
    case IsCn of
        true -> skip;
        _ -> pp_recharge:handle(15800, Player, [])
    end,
    {ok, Player};
handle_event(Player, _) ->
    {ok, Player}.

%% 显示过滤
filter_condition(Player, ProductId) ->
    IsCn = lib_vsn:is_cn(),
    case data_recharge:get_product(ProductId) of
        _ when IsCn -> true;
        #base_recharge_product{show_condition = ShowCondition} ->
            check_show_condition(Player, ShowCondition);
        _ -> false
    end.

check_show_condition(_Ps, []) -> true;
check_show_condition(Ps, [{vip, NeedVip}|T]) ->
    #player_status{figure = #figure{vip = Vip}} = Ps,
    case Vip >= NeedVip of
        true -> check_show_condition(Ps, T);
        _ -> false
    end;
check_show_condition(_Ps, _) ->
    false.


gm_send_product(EndTime) ->
    Sql = io_lib:format("select player_id, gold, time from recharge_log where product_id=0 and time < ~p", [EndTime]),
    case db:get_all(Sql) of
        [] -> ok;
        DbList ->
            spawn(fun() ->
                Title = ?LAN_MSG(?LAN_TITLE_RECHAEGE),
                F = fun([PlayerId, Gold, Time]) ->
                    {{Y, M, D}, {H, N, _S}} = utime:unixtime_to_localtime(Time),
                    Content = uio:format(?LAN_MSG(?LAN_CONTENT_RECHAEGE), [Y, M, D, H, N, Gold]),
                    lib_mail_api:send_sys_mail([PlayerId], Title, Content, [{?TYPE_GOLD, 0, Gold}]),
                    timer:sleep(100)
                end,
                lists:foreach(F, DbList)
            end),
            ok
    end.