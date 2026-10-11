%%%------------------------------------
%%% @Module  : pp_flower_rank_act
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 活动榜单
%%%------------------------------------

-module(pp_flower_act).

-compile(export_all).

-include("def_module.hrl").
-include("flower_rank_act.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("flower.hrl").

%% 本服鲜花榜
handle(22401, Player, [RankType, SubType]) ->
   % ?PRINT(" 22401 RankType:~p~n", [RankType]),
    mod_flower_act_local:send_rank_list(RankType, SubType, Player#player_status.id);

%% 婚礼榜
handle(22402, Player, [RankType, SubType]) when RankType == ?RANK_TYPE_WEDDING -> 
   % ?PRINT(" 22401 RankType:~p~n", [RankType]),
    mod_flower_act_local:send_rank_list(RankType, SubType, Player#player_status.id);  

%% 跨服鲜花榜
handle(22403, Player, [RankType, SubType])  -> 
   % ?PRINT(" 22401 RankType:~p~n", [RankType]),
   #player_status{id = RoleId, server_id = ServerId} = Player,
   mod_kf_flower_act_local:send_rank_list(RankType, SubType, RoleId, ServerId);
   
% %% 跨服榜赠送鲜花
% handle(Cmd = 22404, Player, [RankType, SubType, ReceiverId, GoodsId, IsAnonymous]) ->
%     Node = mod_disperse:get_clusters_node(),
%     #player_status{id = RoleId, server_id = SerId, figure = #figure{name = SName, lv = RoleLv, vip = VipLv}} = Player,
%     %% 活动期间
%     case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FLOWER_RANK, SubType) of
%         true ->
%           {Code, LastPlayer} = case data_flower:get_flower_gift_cfg(GoodsId) of
%                                   #flower_gift_cfg{need_lv = NeedLv, need_vip = NeedVip, is_sell = IsSell} = GiftCfg when RoleLv >= NeedLv orelse VipLv >= NeedVip ->
%                                       case lib_goods_api:cost_object_list(Player, [{?TYPE_GOODS, GoodsId, 1}], send_flower, "") of
%                                           {true, NewPlayer} ->
%                                               %% 日志
%                                               IsFriend = case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
%                                                   true -> 1;
%                                                   _ -> 0
%                                               end,
%                                               lib_log_api:log_send_flower(RoleId, ReceiverId, [{?TYPE_GOODS, GoodsId, 1}], IsFriend),
%                                               NewPlayer1 = lib_flower_act:do_send_gift(NewPlayer, ReceiverId, GiftCfg, IsAnonymous),
%                                               %% 跨服送花 匿名的
%                                               mod_clusters_node:apply_cast(mod_kf_flower_act, receive_flower_gift, [Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, 1]),
%                                               {?SUCCESS, NewPlayer1};
%                                           {false, _Res, NewPlayer} ->
%                                               case IsSell == 1 of
%                                                   true ->
%                                                       case data_goods:get_goods_buy_price(GoodsId) of
%                                                           {0, 0} ->
%                                                               {?ERRCODE(err150_type_err), NewPlayer};
%                                                           {PriceType, Price} ->
%                                                               case lib_goods_api:cost_money(NewPlayer, [{PriceType, 0, Price}], send_flower, "") of
%                                                                   {1, NewPlayer1} ->
%                                                                       %% 日志
%                                                                       IsFriend = case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
%                                                                           true -> 1;
%                                                                           _ -> 0
%                                                                       end,
%                                                                       lib_log_api:log_send_flower(RoleId, ReceiverId, [{PriceType, 0, Price}], IsFriend),
%                                                                       NewPlayer2 = lib_flower_act:do_send_gift(NewPlayer1, ReceiverId, GiftCfg, IsAnonymous),
%                                                                        mod_clusters_node:apply_cast(mod_kf_flower_act, receive_flower_gift, [Node, RankType, SubType, RoleId, SName, SerId, ReceiverId, GiftCfg, 1]),
%                                                                       {?SUCCESS, NewPlayer2};
%                                                                   {_Errcode, NewPlayer1} ->
%                                                                       {?ERRCODE(gold_not_enough), NewPlayer1}
%                                                               end
%                                                       end;
%                                                   false -> %% 非出售道具 道具不足
%                                                       {?ERRCODE(goods_not_enough), NewPlayer}
%                                               end
%                                       end;
%                                   _ ->
%                                       {?ERRCODE(err223_dissatisfy_send_gift_condition), Player}
%                               end,
%           {ok, BinData} = pt_224:write(Cmd, [Code]),
%           lib_server_send:send_to_sid(Player#player_status.sid, BinData),
%           {ok, battle_attr, LastPlayer};
%         _ -> skip
%     end;

%% 活动排行
handle(22405, Player, [ActType, SubType]) ->
    #player_status{id = RoleId, sid = Sid} = Player,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(ActType, SubType) of
        #act_info{etime = Etime} when NowTime < Etime ->
            mod_consume_rank_act:send_rank_list(ActType, SubType, RoleId, Sid);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_224, 22405, [?ERRCODE(err331_act_closed), ActType, SubType, 0, 0, 0, 0, 0, 0, []])
    end;

handle(_Cmd, _Player, _Data) ->
    ?PRINT(" Data:~p ~n", [ _Data]),
    {error, "pp_common_rank no match~n"}.