-module (pp_recharge).
-include("server.hrl").
-include("common.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("errcode.hrl").
% -include("def_id_create.hrl").
-export ([handle/3]).

%% 充值界面信息
handle(Cmd = 15800, #player_status{sid = Sid, recharge_status = RechargeStatus} = Player, []) ->
	% KeyList = data_recharge:get_recharge_return_keys(),
    KeyList = data_recharge:get_product_ids_by_type(?PRODUCT_TYPE_NORMAL, 1),
    KeyList2 = data_recharge:get_product_ids_by_type(?PRODUCT_TYPE_VERIFY, 1),
	F = fun(ProductId, Acc) ->
        IsSatisfy = lib_recharge:filter_condition(Player, ProductId),
        if
            not IsSatisfy -> Acc;
            ProductId == 0 orelse ProductId == 999 ->
                Acc;
            true ->
                ReturnType = lib_recharge_return:calc_return_state(RechargeStatus, ProductId),
                [{ProductId, ReturnType}|Acc]
        end
    end,
	PackList = lists:reverse(lists:foldl(F, [], KeyList++KeyList2)),
    ?PRINT("KeyList ~p ~n", [PackList]),
    lib_server_send:send_to_sid(Sid, pt_158, Cmd, [PackList]),
	ok;

%% 充值总额
handle(15803, #player_status{id = PlayerId, sid = Sid}, []) ->
    TotalGold = lib_recharge_api:get_total(PlayerId),
    lib_recharge:send_total_gold_info(Sid, TotalGold),
    ok;

% 直购币充值礼包|内玩使用
handle(15804, PS, [ProductId]) ->
    #player_status{id = RoleId} = PS,
    case lib_recharge_util:check_recharge_direct_coin(PS, ProductId) of
        {true, Cost, Product} ->
            case lib_goods_api:cost_object_list(PS, Cost, 'buy_gift', "") of
                {true, NewPS} ->
                    LastPS = lib_recharge:pay_by_goods2(NewPS, Product, Cost),
                    lib_server_send:send_to_uid(RoleId, pt_158, 15804, [?SUCCESS]),
                    {ok, LastPS};
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_158, 15804, [?FAIL])
            end;
        {false, Errcode} ->
            lib_server_send:send_to_uid(RoleId, pt_158, 15804, [Errcode])
    end;

% 充值秘籍
% 注：1.封测阶段不完全开放充值，充值时客户端不走SDK，直接请求服务端充值秘籍协议
%     2.秘籍充值情况下，屏蔽普通充值商品类型
% handle(Cmd = 15899, #player_status{sid = Sid} = PS, [ProductId]) ->
% 	NowTime = utime:unixtime(),
% 	Product = lib_recharge_check:get_product(ProductId),
%     #base_recharge_product{product_type = ProductType, money = Money} = Product,
%     CanRecharge = case ProductType of
%     	?PRODUCT_TYPE_NORMAL -> {false, ?ERRCODE(err158_not_open)};
%     	% ?PRODUCT_TYPE_FUND -> lib_recharge_act_api:can_recharge(PS, ProductId);
%     	?PRODUCT_TYPE_WELFARE -> lib_recharge_act_api:can_recharge(PS, ProductId);
%     	?PRODUCT_TYPE_DAILY_GIFT -> lib_daily_gift:can_recharge(PS, ProductId);
%     	_ -> {false, ?ERRCODE(err158_not_open)}
%     end,
%     Check = lib_recharge_check:check_product(ProductId),
%     case {CanRecharge, Check} of
%         {{false, Res}, _} -> lib_server_send:send_to_sid(Sid, pt_158, Cmd, [Res]);
%         {_, {false, Res}} -> lib_server_send:send_to_sid(Sid, pt_158, Cmd, [Res]);
%         {_, {true, _Product2}} ->
%       		% #player_status{id = PlayerId, accname = AccName, figure = #figure{lv = Lv, name = Name}} = PS,
% 		    % PayNo = mod_id_create:get_new_id(?CHARGE_PAY_NO_CREATE),
% 		    % SqlArgs = [1, PayNo, AccName, PlayerId, Name, ProductId, Money, Money * 10, NowTime, 0, Lv],
% 		    % db:execute(io_lib:format(?sql_pay_insert_gm, SqlArgs)),                    
% 		    % lib_recharge_api:nofity_pay(PlayerId),
% 		    %% 注: 以下为封测服（7.20-7.26）处理，不走服务端正常充值流程，直接触发相应商品
% 		    Gold = Money * 10,
% 		    lib_recharge_data:db_insert_recharge_log(PS, 1, ProductId, Money, Gold, NowTime),
% 		    {ok, LastPS} = lib_recharge:dispatch_event(PS, Money, Gold, Product),
%     		{ok, LastPS}
%     end;

handle(_Cmd, _PS, _Data) ->
    % ?PRINT("no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_recharge no match"}.
