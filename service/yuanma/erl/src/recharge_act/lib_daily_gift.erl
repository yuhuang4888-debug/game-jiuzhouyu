%% ---------------------------------------------------------------------------
%% @doc    充值活动 每日礼包
%% @author liuxl
%% @since  2017-04-10
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_daily_gift).
-include ("server.hrl").
-include ("figure.hrl").
-include ("recharge_act.hrl").
-include ("rec_recharge.hrl").
-include ("def_cache.hrl").
-include ("def_recharge.hrl").
-include ("def_event.hrl").
-include ("goods.hrl").
-include ("language.hrl").
-include ("errcode.hrl").
-include ("common.hrl").
-include ("rec_event.hrl").
-include ("def_module.hrl").
-include ("def_vip.hrl").

-compile (export_all).

can_recharge(PS, ProductId) ->
	case catch mod_recharge_act:get_daily_gift_state(PS#player_status.id, ProductId) of
		{ok, ?DAILY_STATE_NOT_PURCHASE} -> true;
		_ -> {false, ?ERRCODE(err158_already_buy)}
	end.


%% 3点刷新可开放的每日礼包列表id
update_daily_gift_cache() ->
	CacheKey = ?CACHE_KEY(?CACHE_RECHARGE_DAILY_GIFT, {?PRODUCT_TYPE_DAILY_GIFT, daily_gift}),
	ProductIds = get_daily_gift_list(),
	mod_cache:put(CacheKey, ProductIds).

%% 获取玩家每日礼包的状态
get_daily_gift_state(PS) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	CacheKey = ?CACHE_KEY(?CACHE_RECHARGE_DAILY_GIFT, {?PRODUCT_TYPE_DAILY_GIFT, daily_gift}),
	Result = mod_cache:get(CacheKey),
	ProductIds = case Result of
		undefined ->
			GiftList = get_daily_gift_list(),
			mod_cache:put(CacheKey, GiftList),
			GiftList;
		Data -> Data
	end,
	ProductList = case catch mod_recharge_act:get_player_daily_gift(RoleId, ProductIds) of
		List when is_list(List) -> List;
		_Err -> []
	end,
	% ?PRINT("get_daily_gift_state ~p~n", [ProductList]),
	{ok, Bin} = pt_159:write(15951, [ProductList]),
	lib_server_send:send_to_sid(Sid, Bin),
	{ok, PS}.

%% 购买每日礼包检查
purchase_daily_gift(PS, ProductId) ->
	#player_status{figure = #figure{vip = Vip}} = PS,
	DailyGiftCfg = data_daily_gift:get_daily_gift(ProductId),
	case lib_recharge_check:check_product(ProductId) of
		{true, Product} when is_record(DailyGiftCfg, base_recharge_daily_gift) ->
			case Product#base_recharge_product.product_type of
				?PRODUCT_TYPE_DAILY_GIFT ->
					case DailyGiftCfg#base_recharge_daily_gift.level of
						1 -> CanPurchase = lib_vip:get_vip_privilege(Vip, ?MOD_RECHARGE_ACT, ?NBV_RECHARGE_GIFT_ONE);
						2 -> CanPurchase = lib_vip:get_vip_privilege(Vip, ?MOD_RECHARGE_ACT, ?NBV_RECHARGE_GIFT_THREE);
						3 -> CanPurchase = lib_vip:get_vip_privilege(Vip, ?MOD_RECHARGE_ACT, ?NBV_RECHARGE_GIFT_SIX);
						_ -> CanPurchase = 0
					end,
					case CanPurchase =/= 0 of
						true ->
							case catch mod_recharge_act:get_daily_gift_state(PS#player_status.id, ProductId) of
								{ok, ?DAILY_STATE_NOT_PURCHASE} -> {true, PS};
								{ok, _State} -> {false, ?ERRCODE(err159_daily_purchased), PS};
								_ -> {false, ?FAIL, PS}
							end;
						false -> {false, ?ERRCODE(err159_vip_not_enough), PS}
					end;
				_ -> {false, ?ERRCODE(err159_daily_type_err), PS}
			end;
		{true, _Product} -> {?ERRCODE(err159_daily_cfg_err), PS};
		{false, Res} -> {false, Res, PS}
	end.

%% 领取每日礼包
get_daily_gift(PS, ProductId) ->
	case catch mod_recharge_act:get_daily_gift_state(PS#player_status.id, ProductId) of
		{ok, State} -> get_daily_gift_do(PS, State, ProductId);
		_ -> {false, ?FAIL, PS}
	end.

get_daily_gift_do(PS, State, ProductId) ->
	if
		State == ?DAILY_STATE_NOT_PURCHASE -> {false, ?ERRCODE(err159_daily_not_purchase), PS};
		State == ?DAILY_STATE_GET -> {false, ?ERRCODE(err159_daily_is_get), PS};
		true -> get_daily_gift_core(PS, ProductId)
	end.

get_daily_gift_core(PS, ProductId) ->
	#base_recharge_daily_gift{reward = Gift} = data_daily_gift:get_daily_gift(ProductId),
	case check_daily_gift(PS, Gift) of
		{true, NewPS, GiveList} ->
			%NewPS = lib_goods_api:send_reward(PS, Reward, recharge_daily_gift, 0),
			F = fun(Item, List) ->
				case Item of
					{goods, Id, Num} -> [{?TYPE_GOODS, Id, Num}|List];
					{exp, Exp} -> [{?TYPE_EXP, 0, Exp}|List];
					{gold,Gold} -> [{?TYPE_GOLD, 0, Gold}|List];
					{coin,Coin} -> [{?TYPE_COIN, 0, Coin}|List];
					_ -> List
				end
			end,
			RewardList = lists:foldl(F, [], GiveList),
			lib_goods_api:send_tv_tip(PS#player_status.id, RewardList),
			mod_recharge_act:receive_daily_gift(NewPS#player_status.id, ProductId),
			{true, NewPS};
		{false, Res} -> {false, Res, PS}
	end.

%% 4点清楚玩家每日礼包
clear_daily_gift(DailyGift) ->
	F = fun(_K, V, Acc) ->
                #ps_daily{player_id = RoleId, product_id = ProductId, state = State} = V,
                if Acc rem 20 == 0 -> timer:sleep(100); true -> skip end,
                if
                    State =/= ?DAILY_STATE_NOT_GET -> Acc;
                    true ->
                        #base_recharge_daily_gift{reward = Reward} = data_daily_gift:get_daily_gift(ProductId),
                        Title = ?LAN_MSG(?DAILY_GIFT_TITLE),
                        Content = ?LAN_MSG(?DAILY_GIFT_CONTENT),
                        lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                        Acc+1
                end
        end,
    maps:fold(F, 1, DailyGift).

%% 事件处理
handle_event(PS,
    #event_callback{
        type_id = ?EVENT_RECHARGE,
        data    = #callback_recharge_data{
            recharge_product = #base_recharge_product{
                product_id   = ProductId,
                product_type = _Type,
                product_subtype = _SubType
            } = _Product,
            associate_ids = AssociateIds
        }}) ->
        %% ?PRINT("lib_daily_gift Type:~p, SubType:~p, ProductId:~p ~n", [Type, SubType, ProductId]),
        {ok, NewPS} = handle_product(PS, ProductId),
        {ok, LastPS} = lib_recharge:handle_associate_product(NewPS, AssociateIds),
        {ok, LastPS};
handle_event(PS, _) ->
    {ok, PS}.

handle_product(PS, ProductId) ->
    #base_recharge_product{
            product_type    = ProductType,
            product_subtype = ProductSubType
    } = lib_recharge_check:get_product(ProductId),
    do_handle_product(PS, ProductType, ProductSubType, ProductId).

%% 购买每日礼包
do_handle_product(PS, ?PRODUCT_TYPE_DAILY_GIFT, _SubType, ProductId) ->
	#player_status{id = RoleId} = PS,
    mod_recharge_act:purchase_daily_gift(RoleId, ProductId),
    log_daily_gift(RoleId, ProductId),
    get_daily_gift_state(PS),
    NewPS=lib_activitycalen_api:role_success_end_activity(PS, ?MOD_RECHARGE_ACT, ?MOD_RECHARGE_ACT_BUY_DAILY),
    {ok, NewPS};
do_handle_product(PS, _Type, _SubType, _ProductId) -> {ok, PS}.


get_daily_gift_list() ->
	ProductIds = data_daily_gift:get_daily_gift_ids(),
	F = fun(Id, List) ->
		case lib_recharge_check:check_product(Id) of
			{true, _Product} -> [Id|List];
			_ -> List
		end
	end,
	lists:foldl(F, [], ProductIds).


%% 数据库db函数
db_update_daily_gift(PSDaily) ->
	#ps_daily{player_id = RoleId, product_id = ProductId, state = State} = PSDaily,
	Sql = io_lib:format(?SQL_DAILY_GIFT_UPDATE, [RoleId, ProductId, State]),
	db:execute(Sql).


db_clear_daily_gift() ->
	Sql = io_lib:format(?SQL_DAILY_GIFT_CLEAR, []),
	db:execute(Sql).

check_daily_gift(PS, Gift) ->
	case Gift of
		[{?TYPE_GOODS, TypeId, Num}|_T] ->
			case lib_goods_do:fetch_gift(PS, TypeId, Num) of
				{ok, NewPS, _, GiveList} -> {true, NewPS, GiveList};
				{fail, ErrorCode} -> {false, ErrorCode}
			end;
		_ -> {false, ?ERRCODE(err159_daily_cfg_err)}
	end.


log_daily_gift(RoleId, ProductId) ->
	Now = utime:unixtime(),
	#base_recharge_daily_gift{level = Level, reward = Gift} = data_daily_gift:get_daily_gift(ProductId),
	ProductName = get_product_name(Level),
	F = fun(Item) ->
		case Item of
			{?TYPE_GOODS, TypeId, _Num} ->
				%?PRINT("log_daily_gift ~p~n", [ProductName]),
				lib_log_api:log_daily_gift(RoleId, ProductName, TypeId, Now);
			_ -> ok
		end
	end,
	lists:foreach(F, Gift).

get_product_name(Level) ->
	case Level of
		1 ->
			ulists:list_to_bin(data_language:get(?DAILY_GIFT_NAME1));
		2 ->
			ulists:list_to_bin(data_language:get(?DAILY_GIFT_NAME2));
		3 ->
			ulists:list_to_bin(data_language:get(?DAILY_GIFT_NAME3));
		_ -> <<"">>
	end.
