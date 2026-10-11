%%%--------------------------------------
%%% @Module  : lib_vip_api
%%% @Author  : xiaoxiang 
%%% @Created : 2017-03-20
%%% @Description:  vip 
%%%--------------------------------------
-module(lib_vip_api).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("relationship.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").

handle_event(#player_status{vip = #role_vip{vip_card_list = CardList}} = Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
    %% 消耗钻石加vip经验，排除的消耗类型列表
    IgnoreTypeList = [pay_sell, pay_tax, advance_payment, seek_goods, red_envelopes, buy_vip_up, pay_auction], % lib_consume_data  IGNORE_CONSUME_TYPES
    #callback_money_cost{cost = Gold, money_type = MoneyType, consume_type = CosumeType} = Data,
    case CosumeType of 
        {NewConsumeType, _} -> ok;
        _ -> NewConsumeType = CosumeType
    end,
    case MoneyType of
        ?GOLD ->
            case lists:member(NewConsumeType, IgnoreTypeList) of
                false when Gold > 0 ->
                    VipType = lib_vip:get_vip_type(CardList),
                    IsTempCard =  lib_vip:is_temp_card(CardList),
                    case VipType =/= 0 andalso IsTempCard == false of
                        true ->
                            NewPlayer = lib_vip:cost_money(Player, Gold),
                            {ok, NewPlayer};
                        false ->
                            {ok, Player}
                    end;
                _ ->
                    {ok, Player}
            end;
        _ -> {ok, Player}
    end;

handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE,
    data = #callback_recharge_data{
        recharge_product = #base_recharge_product{product_id = ProductId}
    }}) ->
    case data_recharge:get_product_vip_exp(ProductId) of
        [AddExp] when is_integer(AddExp) ->
            NewPlayer = lib_vip:buy_product(Player, AddExp);
        _ ->
            NewPlayer = Player
    end,
    {ok, NewPlayer};

handle_event(Player, #event_callback{}) ->
    {ok, Player}.


%%---------------------------------------------------
%% 获取特权值
%% @ModuleId 模块id
%% @SubModId 子模块id
%% @VipType  vip类型
%% @VipLv    vip等级
%%---------------------------------------------------
get_vip_privilege(ModuleId, SubModId, VipType, VipLv) ->
    case data_vip:data_num_by_vip_info(ModuleId, SubModId) of
        #data_num_by_vip_info{num_type = NumType} when NumType == ?SP_NUM_TYPE ->
            data_vip:get_num_by_vip(ModuleId, SubModId, 99, VipLv);
        _ ->
            case VipType of
                0 -> % 没有等级限制
                    data_vip:get_num_by_vip_defualt(ModuleId, SubModId);
                _ ->
                    data_vip:get_num_by_vip(ModuleId, SubModId, 99, VipLv)
            end
    end.

get_vip_privilege(#player_status{figure = #figure{vip = VipLv, vip_type = VipType}}, ModuleId, SubModId) ->
    get_vip_privilege(ModuleId, SubModId, VipType, VipLv).

get_num_by_vip_defualt(ModuleId, SubModId) ->
    data_vip:get_num_by_vip_defualt(ModuleId, SubModId).

%% 判断玩家是否在线，然后增加经验值
add_exp_by_gold(RoleId, Gold) ->
    case Gold > 0 of
        true ->
            Pid = misc:get_player_process(RoleId),
            case is_pid(Pid) andalso misc:is_process_alive(Pid) of
                true ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_vip, cost_money, [Gold]);
                _ -> % 离线的情况
                    AddVipExp = Gold,
                    RoleVip = lib_vip:login(RoleId),
                    MaxVipLv = lib_vip:get_vip_lv_max(), % 获取vip最高等级
                    OldVipLv = RoleVip#role_vip.vip_lv,
                    OldVipExp = RoleVip#role_vip.vip_exp,
                    case AddVipExp > 0 of
                        true when OldVipLv < MaxVipLv ->
                            NowTime = utime:unixtime(),
                            NewVipExp = OldVipExp + Gold,
                            lib_log_api:log_vip_exp(RoleId, 3, 0, Gold, OldVipLv, OldVipExp, OldVipLv, NewVipExp, NowTime);
                        %% vip等级已达上限或者AddVipExp为0
                        _ -> skip
                    end
            end;
        false -> skip
    end.



