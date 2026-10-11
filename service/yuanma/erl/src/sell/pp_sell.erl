%% ---------------------------------------------------------------------------
%% @doc 交易
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% @comment 注：物品模块已有交易锁定期字段，交易行暂未使用，暂时用作预留
%% ---------------------------------------------------------------------------
-module (pp_sell).

-include("server.hrl").
-include("rec_sell.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("def_module.hrl").

-export ([handle/3]).

handle(Cmd, PS, Data) ->
    #player_status{figure = Figure} = PS,
    OpenLv = data_sell:get_cfg(open_lv),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PS, Data);
        false -> skip
    end.

%% 商品大类各个子类商品出售数量
do_handle(_Cmd = 15101, PS, [Category]) ->
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    mod_sell:list_category_sell_num(ServerId, PlayerId, Category);

%% 商品小类下所有商品出售列表
do_handle(_Cmd = 15102, PS, [Category, SubCategory, Stage, Star, Color]) ->
    ?PRINT("15102 ~p~n", [{Category, SubCategory, Stage, Star, Color}]),
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    mod_sell:list_sub_category_sell_goods(ServerId, PlayerId, Category, SubCategory, Stage, Star, Color);

%% 筛选商品
do_handle(Cmd = 15103, PS, [Stage, Star, Color]) ->
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    mod_sell:filter_goods(Cmd, ServerId, PlayerId, [?FILTER_TYPE_STAGE_AND_STAR, Stage, Star, Color]);

%% 根据名字搜索商品
do_handle(Cmd = 15104, PS, [KeyWords]) when KeyWords =/= [] ->
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    mod_sell:filter_goods(Cmd, ServerId, PlayerId, [?FILTER_TYPE_KEY_WORDS, KeyWords]);

%% 商品上架界面信息
do_handle(Cmd = 15105, PS, [GoodsId, GTypeId]) ->
    #player_status{sid = Sid, id = PlayerId, server_id = ServerId} = PS,
    case data_goods_type:get(GTypeId) of
        #ets_goods_type{
            sell_category = SellCateGory,
            sell_subcategory = SellSubCateGory
        } when SellCateGory > 0 andalso SellSubCateGory > 0 ->
            mod_sell:send_sell_up_view_info(ServerId, PlayerId, GoodsId, GTypeId);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_151, Cmd, [?ERRCODE(err151_not_sell_category)])
    end;

%% 商品上架 限制上架协议的发送CD
do_handle(Cmd = 15106, PS, [GoodsId, GoodsNum, UnitPrice, IsShout]) when GoodsNum > 0 ->
    #player_status{sid = Sid, id = _PlayerId} = PS,
    IsVaildPrice = ?IF(is_integer(UnitPrice) andalso UnitPrice > 0 andalso UnitPrice =< 99999, true, false),
    case IsVaildPrice of
        true ->
            case lib_sell:sell_up(PS, GoodsId, GoodsNum, UnitPrice, IsShout) of
                {ok, ErrCode, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_151, Cmd, [ErrCode]),
                    lib_task_api:trading_putaway(PS, 1),
                    {ok, NewPS};
                {_, ErrCode, NewPS} ->
                    ?PRINT("sell up ErrCode :~p~n", [ErrCode]),
                    send_error_code(Sid, ErrCode),
                    {ok, NewPS};
                _ -> skip
            end;
        false -> skip
    end;

% %% 指定交易
% do_handle(Cmd = 15107, PS, [SpecifyId, GoodsId, GoodsNum, UnitPrice]) when GoodsNum > 0 ->
%     #player_status{sid = Sid, id = PlayerId, figure = Figure} = PS,
%     IsVaildPrice = ?IF(is_integer(UnitPrice) andalso UnitPrice > 0 andalso UnitPrice =< 99999, true, false),
%     SpecifySellNeedVipLv = data_sell:get_cfg(specify_sell_need_vip_lv),
%     if
%         SpecifyId == PlayerId -> skip;
%         IsVaildPrice == false -> skip;
%         Figure#figure.vip < SpecifySellNeedVipLv ->
%             send_error_code(Sid, ?ERRCODE(err151_vip_lv_not_enough));
%         true ->
%             case lib_relationship:is_friend_on_dict(PlayerId, SpecifyId) of
%                 true ->
%                     case lib_role:get_role_show(SpecifyId) of
%                         #ets_role_show{figure = SpecifyRoleFigure} ->
%                             OpenLv = data_sell:get_cfg(open_lv),
%                             case SpecifyRoleFigure#figure.lv >= OpenLv of
%                                 true ->
%                                     case lib_sell:sell_up(PS, GoodsId, GoodsNum, UnitPrice, SpecifyId) of
%                                         {ok, ErrCode} ->
%                                             %% 上架成功了给对方推送小红点
%                                             {ok, BinData} = pt_151:write(15113, [1]),
%                                             lib_server_send:send_to_uid(SpecifyId, BinData),
%                                             lib_server_send:send_to_sid(Sid, pt_151, Cmd, [ErrCode]);
%                                         {_, ErrCode} ->
%                                             send_error_code(Sid, ErrCode);
%                                         _ -> skip
%                                     end;
%                                 false ->
%                                     send_error_code(Sid, ?ERRCODE(err151_specify_role_lv_not_enough))
%                             end;
%                         _ ->
%                             send_error_code(Sid, ?ERRCODE(err140_3_role_no_exist))
%                     end;
%                 false ->
%                     send_error_code(Sid, ?ERRCODE(err140_6_not_friend))
%             end
%     end;

%% 商品下架
do_handle(Cmd = 15108, PS, [SellType, Id, GTypeId, GoodsNum]) when (SellType == 1) andalso GoodsNum > 0 ->
    #player_status{sid = Sid, id = _PlayerId} = PS,
    case lib_sell:sell_down(PS, SellType, Id, GTypeId, GoodsNum) of
        {ok, Res, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_151, Cmd, [Res]),
            {ok, NewPS};
        {fail, Res} -> lib_server_send:send_to_sid(Sid, pt_151, Cmd, [Res])
    end;

%% 获取玩家上架中的物品
do_handle(_Cmd = 15109, PS, _) ->
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    mod_sell:send_on_sell_goods_list(ServerId, PlayerId);

%% 获取指定交易列表
% do_handle(_Cmd = 15110, PS, _) ->
%     #player_status{id = PlayerId} = PS,
%     mod_sell:send_specify_sell_list(PlayerId);

%% 购买商品
do_handle(Cmd = 15111, PS, [SellType, Id, Type, SubType, SellerId, GTypeId, GoodsNum, UnitPrice]) when SellType == 1 ->
    ?PRINT("15111  ~p~n", [{Type, SubType}]),
    #player_status{sid = Sid, id = PlayerId} = PS,
    case GoodsNum > 0 of
        true ->
            case lib_sell:pay_sell(PS, SellType, Id, SellerId, GTypeId, GoodsNum ,UnitPrice) of
                {ok, SellGoods, NewPS, RemainTimes} ->
                    %?PRINT("15111 SellGoods ~p~n", [SellGoods]),
                    case SellGoods of
                        #sell_goods{category = Category, sub_category = SubCategory} ->
                            skip;
                        #sell_goods_kf{category = Category, sub_category = SubCategory} ->
                            skip
                    end,
                    %% 提示
                    lib_chat:send_TV({player, PlayerId}, ?MOD_SELL, 1, [RemainTimes]),
                    lib_server_send:send_to_sid(Sid, pt_151, Cmd, [?SUCCESS, SellType, Id, Category, SubCategory]),
                    {ok, NewPS};
                {fail, Res} ->
                    ?PRINT("15111 ~p~n", [Res]),
                    lib_server_send:send_to_sid(Sid, pt_151, Cmd, [Res, SellType, Id, Type, SubType]);
                _ -> skip
            end;
        false -> skip
    end;

%% 交易记录
do_handle(_Cmd = 15112, PS, _) ->
    #player_status{id = PlayerId, server_id = ServerId} = PS,
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
    if
        IsKfOpen >= 1 ->
%%            ?PRINT("++++++++++++++++~n", []),
            mod_clusters_node:apply_cast(mod_kf_sell, send_sell_record, [ServerId, PlayerId]);
        true ->
            mod_sell:send_sell_record(PlayerId)
    end;

% %% 是否有指定交易
% do_handle(_Cmd = 15113, PS, _) ->
%     #player_status{id = PlayerId} = PS,
%     mod_sell:send_p2p_red_point(PlayerId);

%% 交易记录
do_handle(_Cmd = 15114, PS, _) ->
    #player_status{id = PlayerId, figure = #figure{vip_type = VipType, vip = VipLv}} = PS,
    lib_sell:send_role_sell_times(PlayerId, VipType, VipLv);

%% 发起求购
do_handle(Cmd = 15115, PS, [TypeId, GoodsNum, UnitPrice]) ->
    #player_status{sid = Sid, id = _PlayerId} = PS,
    case lib_sell:seek_goods(PS, TypeId, GoodsNum, UnitPrice) of
        {ok, Res, SeekGoods, NewPS} ->
            case SeekGoods of
                #seek_goods{id = Id, player_id = PlayerId, role_name = RoleName, time = Time} ->
                    skip;
                #seek_goods_kf{id = Id, player_id = PlayerId, role_name = RoleName, time = Time}->
                    skip
            end,
            ?PRINT("seek_goods ErrCode :~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_151, Cmd, [Res, Id, PlayerId, RoleName, TypeId, GoodsNum, UnitPrice, Time]),
            {ok, NewPS};
        {_, Res} ->
            ?PRINT("seek_goods Res :~p~n", [Res]),
            send_error_code(Sid, Res);
        _ -> skip
    end;

%% 撤销求购
do_handle(15116, PS, [Id]) ->
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
    if
        IsKfOpen >= 1 ->
            mod_clusters_node:apply_cast(mod_kf_sell, delete_seek, [{PS#player_status.server_id, PS#player_status.id, Id}]);
        true ->
            mod_sell:delete_seek({PS#player_status.id, Id})
    end;
    

%% 求购 出售
do_handle(Cmd = 15117, PS, [Id, BuyerId, GTypeId, GoodsNum, Price]) ->
    #player_status{sid = Sid, id = _PlayerId} = PS,
    case lib_sell:sell_seek_goods(PS, Id, BuyerId, GTypeId, GoodsNum, Price) of
        {ok, RemainNum, NewPS} ->
            ?PRINT("sell_seek_goods RemainNum :~p~n", [RemainNum]),
            lib_server_send:send_to_sid(Sid, pt_151, Cmd, [1, Id, RemainNum]),
            {ok, NewPS};
        {_, Res} ->
            ?PRINT("sell_seek_goods ErrCode :~p~n", [Res]),
            lib_server_send:send_to_sid(Sid, pt_151, Cmd, [Res, Id, GoodsNum]);
        _ -> skip
    end;

%% 求购列表
do_handle(Cmd = 15118, PS, [PageNo, PageSize]) ->
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
    if
        IsKfOpen >= 1 ->
            mod_clusters_node:apply_cast(mod_kf_sell, send_seek_list, [{PS#player_status.server_id,
                PS#player_status.id, Cmd, PageNo, PageSize}]);
        true ->
            mod_sell:send_seek_list({PS#player_status.id, Cmd, PageNo, PageSize})
    end;
   

%% 我的求购
do_handle(Cmd = 15119, PS, []) ->
    IsKfOpen = mod_global_counter:get_count(?MOD_SELL, ?GLOBAL_151_KF_IS_OPEN),
    if
        IsKfOpen >= 1 ->
            mod_clusters_node:apply_cast(mod_kf_sell, send_self_seek_list,
                [{PS#player_status.server_id, PS#player_status.id, Cmd}]);
        true ->
            mod_sell:send_self_seek_list({PS#player_status.id, Cmd})
    end;


%% 跨服信息
do_handle(_Cmd = 15121, PS, []) ->
    mod_sell:send_kf_msg(PS#player_status.id);

%% 主动喊话
do_handle(_Cmd = 15122, Ps, [SellId]) ->
    lib_sell:market_shout(Ps, SellId, 0);


do_handle(_Cmd, _PS, _Data) ->
    {error, "pp_sell no match"}.

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_151:write(15100, [ErrorCodeInt, ErrorCodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData).
