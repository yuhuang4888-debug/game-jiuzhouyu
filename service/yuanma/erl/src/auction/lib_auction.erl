%% ---------------------------------------------------------------------------
%% @doc 拍卖行
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------

-module (lib_auction).
-include ("common.hrl").
-include ("rec_auction.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("predefine.hrl").
-include ("def_fun.hrl").
-include ("guild.hrl").
-export ([pay_auction/2]).

pay_auction(PS, {_Cmd, _AuctionType, _PlayerId, _ServerId, _Name, _GuildId, _GoodsId, PriceType, PriceList} = Args) ->
	CheckList  = [
		{correct_price, PriceType},
		{enough_money, PS, PriceList}
	],
	case checklist(CheckList) of
		true -> do_pay_auction(PS, Args);
		{false, Res} -> {false, Res}
	end.

do_pay_auction(PS, {_Cmd, AuctionType, _PlayerId, _ServerId, _Name, _GuildId, _GoodsId, _PriceType, PriceList}) ->
	Return = case AuctionType of 
		?AUCTION_KF_REALM ->
			#player_status{guild = #status_guild{id = GuildId, realm = Realm}} = PS,
			case GuildId > 0 andalso Realm > 0 of 
				true ->
					Args2 = {_Cmd, _PlayerId, _ServerId, _Name, Realm, _GoodsId, _PriceType, PriceList},
					mod_kf_auction:call_kf_auction(pay_auction, [Args2]);
				_ ->
					{false, ?ERRCODE(err154_error_realm_id)}
			end;
		_ ->
			Args2 = {_Cmd, _PlayerId, _ServerId, _Name, _GuildId, _GoodsId, _PriceType, PriceList},
			catch mod_auction:pay_auction(Args2)
	end,
	case Return of
		true -> 
			{_Res, NewPS} = lib_goods_api:cost_money(PS, PriceList, pay_auction, ""),			
			{true, NewPS};
		{false, Res} -> {false, Res};
		R ->
			?ERR("pay_auction error:~p", [R]),
			{false, ?FAIL}
	end.
                                                             
%% ---------------------------- check function %% ----------------------------
check({correct_price, PriceType}) ->
	CorrectType = lists:member(PriceType, [?PRICE_TYPE_AUCTION, ?PRICE_TYPE_ONE_PRICE, ?PRICE_TYPE_ADD_PRICE]),
	if
		CorrectType == false ->
			%% 非法竞价类型
			{false, ?ERRCODE(err154_error_pricetype)};
		true -> true
	end;

check({enough_money, PS, ObjectList}) ->
    case lib_goods_api:check_object_list(PS, ObjectList) of
    	true -> true;
    	{false, Res} -> {false, Res};
        _ -> {false, ?MONEY_NOT_ENOUGH}
    end;

check(_Type) ->
    {false, ?FAIL}.

checklist([]) -> true;
checklist([H|T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.