%%-----------------------------------------------------------------------------
%% @Module  :       lib_flower
%% @Author  :       Czc
%% @Created :       2017-09-05
%% @Description:    鲜花系统
%%-----------------------------------------------------------------------------
-module(lib_flower).
-include("server.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("flower.hrl").
-include("role.hrl").
-include("relationship.hrl").
-include("language.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("def_id_create.hrl").
-include("chat.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("custom_act.hrl").
-export([
    login/1
    , send_gift/5
    , get_flower_gift_record/1
    , receive_flower_gift/6
    , get_fame_lv/1
    , thanks_flower/2
]).
-compile(export_all). 

make_record(flower_gift_record, [Id, RoleId, SenderId, SenderName, SSerId, SSerNum, GoodsId, GoodsNum, IsAnonymous, IsThanks, Time]) ->
    #flower_gift_record{
        id = Id, role_id = RoleId, sender_id = SenderId, sender_name = SenderName, sender_serid = SSerId, sender_sernum = SSerNum,
        goods_id = GoodsId, goods_num = GoodsNum, anonymous = IsAnonymous, is_thanks = IsThanks, time = Time
    }.

%% 登录
login(RoleId) ->
    %% 获取送礼记录
    get_flower_record_on_dict(RoleId),
    case db:get_row(io_lib:format(?sql_sel_role_flower_data, [RoleId])) of
        [] ->
            db:execute(io_lib:format(?sql_insert_flower, [RoleId, 0, 0, 0])),
            #flower{};
        [Charm, Fame, FlowerNum | _] ->
            FameAttr = get_fame_attr(Fame),
            #flower{charm = Charm, fame = Fame, attr = FameAttr, flower_num = FlowerNum}
    end.

%% 获取收到的礼物记录(玩家进程)
get_flower_record_on_dict(RoleId) ->
    case get(role_flower_record) of
        undefined ->
            FlowerRecordList = case get_flower_record_on_db(RoleId) of
                                   Data when Data =/= [] ->
                                       [make_record(flower_gift_record, OneData) || OneData <- Data];
                                   _ -> []
                               end,
            save_flower_record_on_dict(FlowerRecordList),
            FlowerRecordList;
        Val -> Val
    end.

get_flower_record_on_db(RoleId) ->
    db:get_all(io_lib:format(?sql_get_gift_record, [RoleId])).

%% 保存收到的礼物记录(进程)
save_flower_record_on_dict(FlowerRecord) ->
    put(role_flower_record, FlowerRecord).

%% 获取收礼记录
get_flower_gift_record(RoleId) ->
    RecordList = get_flower_record_on_dict(RoleId),
    ExpireTime = utime:unixtime() - ?RECORD_VAILD_TIME,
    pack_gift_record(RecordList, 0, ExpireTime, []).

pack_gift_record([], _RecordLen, _ExpireTime, AccL) -> AccL;
pack_gift_record(_, RecordLen, _ExpireTime, AccL) when RecordLen >= ?FLOWER_RECORD_NUM_LIMIT -> AccL;
pack_gift_record([T|L], RecordLen, ExpireTime, AccL) ->
    case T of
        #flower_gift_record{
            id = Id,
            sender_id = SenderId,
            sender_name = SenderName,
            sender_serid = SSerId,
            sender_sernum = SSerNum,
            goods_id = GoodsId,
            goods_num = GoodsNum,
            anonymous = IsAnonymous,
            is_thanks = IsThanks,
            time = Time
        } when Time > ExpireTime -> %% 过期的礼物记录不发给客户端
            NewRecordLen = RecordLen + 1,
            NewAccL = case IsAnonymous of
                0 ->
                    [{Id, SenderId, SenderName, SSerId, SSerNum, GoodsId, GoodsNum, IsAnonymous, IsThanks, Time}|AccL];
                _ ->
                    SenderNameAnonymous = data_language:get(?LAN_MYSTERY_MAN),
                    [{Id, SenderId, SenderNameAnonymous, GoodsId, IsAnonymous, IsThanks, Time}|AccL]
            end;
        _ ->
            NewRecordLen = RecordLen,
            NewAccL = AccL
    end,
    pack_gift_record(L, NewRecordLen, ExpireTime, NewAccL).

thanks_flower(Player, Id) ->
    #player_status{id = RoleId} = Player,
    RecordList = get_flower_record_on_dict(RoleId),
    case lists:keyfind(Id, #flower_gift_record.id, RecordList) of 
        #flower_gift_record{is_thanks = 0} = FlowerRecord ->
            Sql = io_lib:format(?sql_update_flower_thanks_record, [1, Id]),
            db:execute(Sql),
            NewFlowerRecord = FlowerRecord#flower_gift_record{is_thanks = 1},
            NewRecordList = lists:keystore(Id, #flower_gift_record.id, RecordList, NewFlowerRecord),
            save_flower_record_on_dict(NewRecordList),
            {1, Player};
        _ -> {1, Player}
    end.

%% 赠送礼物
send_gift(Player, ReceiverId, GoodsId, GoodsNum, IsAnonymous) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    #figure{lv = RoleLv, vip = VipLv, name = SenderName} = Figure,
    case data_flower:get_flower_gift_cfg(GoodsId) of
        #flower_gift_cfg{
            need_lv = NeedLv,
            need_vip = NeedVip,
            is_sell = IsSell
        } = GiftCfg when RoleLv >= NeedLv orelse VipLv >= NeedVip ->
            case lib_goods_api:cost_object_list(Player, [{?TYPE_GOODS, GoodsId, GoodsNum}], send_flower, "") of
                {true, NewPlayer} ->
                    %% 日志
                    IsFriend = case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
                        true -> 1;
                        _ -> 0
                    end,
                    lib_log_api:log_send_flower(RoleId, ReceiverId, [{?TYPE_GOODS, GoodsId, GoodsNum}], IsFriend),
                    NewPlayer1 = do_send_gift(NewPlayer, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                    receive_flower_gift(RoleId, SenderName, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                    {?SUCCESS, NewPlayer1};
                {false, _Res, NewPlayer} ->
                    case IsSell == 1 of
                        true ->
                            case data_goods:get_goods_buy_price(GoodsId) of
                                {0, 0} ->
                                    {?ERRCODE(err150_type_err), NewPlayer};
                                {PriceType, Price} ->
                                    NPrice = Price*GoodsNum,
                                    case lib_goods_api:cost_money(NewPlayer, [{PriceType, 0, NPrice}], send_flower, "") of
                                        {1, NewPlayer1} ->
                                            %% 日志
                                            IsFriend = case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
                                                true -> 1;
                                                _ -> 0
                                            end,
                                            lib_log_api:log_send_flower(RoleId, ReceiverId, [{PriceType, 0, NPrice}], IsFriend),
                                            NewPlayer2 = do_send_gift(NewPlayer1, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                                            receive_flower_gift(RoleId, SenderName, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                                            {?SUCCESS, NewPlayer2};
                                        {_Errcode, NewPlayer1} ->
                                            {?ERRCODE(gold_not_enough), NewPlayer1}
                                    end
                            end;
                        false -> %% 非出售道具 道具不足
                            {?ERRCODE(goods_not_enough), NewPlayer}
                    end
            end;
        _ ->
            {?ERRCODE(err223_dissatisfy_send_gift_condition), Player}
    end.

do_send_gift(Player, ReceiverId, GiftCfg, GoodsNum, IsAnonymous) ->
    #player_status{sid = _Sid, id = RoleId, server_id = ServerId, server_num = ServerNum, flower = RoleFlowerData, figure = Figure} = Player,
    #figure{name = RoleName} = Figure,
    #flower_gift_cfg{
        goods_id = GoodsId,
        effect_type = EffectType,
        effect = Effect,
        intimacy = IntimacyPlus1,
        fame = FamePlus1,
        charm = Charm,
        is_tv = IsTv
    } = GiftCfg,
    IntimacyPlus = IntimacyPlus1 * GoodsNum,
    FamePlus = FamePlus1 * GoodsNum,
    %% 更新双方亲密度
    lib_relationship:update_intimacy_each_one(RoleId, ReceiverId, IntimacyPlus, ?INTIMACY_TYPE_PRESENT, [{GoodsId, 1}]),
    %% 飘字提示
    % case lib_relationship:is_friend_on_dict(RoleId, ReceiverId) of
    %     true ->
    %         TipsBinData = lib_chat:make_tv(?MOD_FLOWER, 9, [FamePlus, IntimacyPlus]);
    %     false ->
    %         TipsBinData = lib_chat:make_tv(?MOD_FLOWER, 8, [FamePlus])
    % end,
    %lib_server_send:send_to_sid(Sid, TipsBinData),
    %% 告诉收花者收到花
    {ok, Bin} = pt_223:write(22304, [RoleId, Figure, ServerId, ServerNum, GoodsId, GoodsNum]),
    lib_server_send:send_to_uid(ReceiverId, Bin),
    %% 发送传闻
    case IsTv > 0 of
        true ->
            ReceiverName = case lib_role:get_role_show(ReceiverId) of
                               #ets_role_show{figure = ReceiverFigure} -> ReceiverFigure#figure.name;
                               _ -> "???"
                           end,
            #ets_goods_type{goods_name = GoodsName} = data_goods_type:get(GoodsId),
            case lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK) of 
                [ActSubType|_] ->
                    BinData = lib_chat:make_tv(?MOD_FLOWER, 10, [RoleName, GoodsId, GoodsNum, ReceiverName, Charm*GoodsNum, ?CUSTOM_ACT_TYPE_FLOWER_RANK, ActSubType]);
                _ ->
                    case IsAnonymous of
                        0 ->
                            BinData = lib_chat:make_tv(?MOD_FLOWER, 6, [RoleName, util:make_sure_binary(GoodsName), ReceiverName]);
                        _ ->
                            BinData = lib_chat:make_tv(?MOD_FLOWER, 7, [ReceiverName, GoodsName])
                    end
            end,
            case EffectType of 
                3 ->
                    lib_server_send:send_to_all(BinData);
                _ ->
                    lib_server_send:send_to_uid(RoleId, BinData),
                    lib_server_send:send_to_uid(ReceiverId, BinData)
            end;
        false -> skip
    end,
    %% 显示特效
    case EffectType of
        2 -> %% 双方特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_uid(RoleId, FXBinData),
            lib_server_send:send_to_uid(ReceiverId, FXBinData);
        3 -> %% 全服特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_all(FXBinData);
        _ -> skip
    end,
    NewFame = RoleFlowerData#flower.fame + FamePlus,
    db:execute(io_lib:format(?sql_update_fame, [NewFame, RoleId])),
    PreFameLv = get_fame_lv(RoleFlowerData#flower.fame),
    NewFameLv = get_fame_lv(NewFame),
    case PreFameLv =/= NewFameLv of
        true ->
            #fame_lv_cfg{attr = NewFameAttr} = data_flower:get_fame_lv_cfg(NewFameLv),
            NewPlayerTmp = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame, attr = NewFameAttr}},
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame}}
    end,
    %% 日志
    lib_log_api:log_fame(RoleId, RoleFlowerData#flower.fame, NewFame, [{goods, GoodsId, GoodsNum}]),
    %% 触发成就
    {ok, NewPlayerAfAchv} = lib_achievement_api:flower_send_event(NewPlayer, NewFameLv),
    {_, LastPlayer} = lib_player_event:dispatch(NewPlayerAfAchv, ?EVENT_SEND_FLOWER, #callback_flower{to_id=ReceiverId, goods_id=GoodsId, intimacy=IntimacyPlus, sender=true}),
    LastPlayer.

%% 玩家收到鲜花
receive_flower_gift(SenderId, SenderName, ReceiverId, GiftCfg, GoodsNum, IsAnonymous) when is_integer(SenderId) ->
    #flower_gift_cfg{
        goods_id = GoodsId,
        charm = CharmPlus1
    } = GiftCfg,
    CharmPlus = CharmPlus1 * GoodsNum,
    ReceiverPid = misc:get_player_process(ReceiverId),
    case misc:is_process_alive(ReceiverPid) of
        true -> %% 在线跳到玩家进程处理
            lib_player:apply_cast(ReceiverPid, ?APPLY_CAST_SAVE, lib_flower, receive_flower_gift, [SenderId, SenderName, GiftCfg, GoodsNum, IsAnonymous]);
        false -> %% 玩家不在线直接操作数据库
            ServerId = config:get_server_id(),
            ServerNum = config:get_server_num(),
            lib_flower_act_api:reflash_rank_by_flower(ReceiverId, CharmPlus),
            NewRecordId = case catch mod_id_create:get_new_id(?FLOWER_GIFT_RECORD_ID_CREATE) of
                AutoId when is_integer(AutoId) -> AutoId;
                _ -> 0
            end,
            F = fun() ->
                NewCharm = case db:get_row(io_lib:format(?sql_sel_role_flower_data, [ReceiverId])) of
                                [PreCharm | _] ->
                                    PreCharm + CharmPlus;
                                _ ->
                                    PreCharm = 0,
                                    CharmPlus
                           end,
                db:execute(io_lib:format(?sql_update_charm, [NewCharm, ReceiverId])),
                case NewRecordId > 0 of
                    true ->
                        db:execute(io_lib:format(?sql_insert_flower_gift_record, [NewRecordId, ReceiverId, SenderId, util:fix_sql_str(SenderName), ServerId, ServerNum, GoodsId, GoodsNum, IsAnonymous, 0, utime:unixtime()]));
                    _ -> skip
                end,
                %% 日志
                lib_log_api:log_charm(ReceiverId, PreCharm, NewCharm, [{goods, GoodsId, GoodsNum}]),
                ok
            end,
            case catch db:transaction(F) of
                ok -> ok;
                Err -> ?ERR("Send Flower Gift Err:~p~n", [Err])
            end
    end;
%% 收到鲜花礼物(收礼物玩家进程)
receive_flower_gift(Player, SenderId, SenderName, GiftCfg, GoodsNum, IsAnonymous) when is_record(Player, player_status) ->
    #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum, flower = RoleFlowerData} = Player,
    #flower_gift_cfg{
        goods_id = GoodsId,
        charm = CharmPlus1
    } = GiftCfg,
    UnixTime = utime:unixtime(),
    CharmPlus = CharmPlus1 * GoodsNum,
    ReceiveFlowerRecord = get_flower_record_on_dict(RoleId),
    NewRecordId = case catch mod_id_create:get_new_id(?FLOWER_GIFT_RECORD_ID_CREATE) of
        AutoId when is_integer(AutoId) -> AutoId;
        _ -> 0
    end,
    NewCharm = RoleFlowerData#flower.charm + CharmPlus,
    F = fun() ->
        db:execute(io_lib:format(?sql_update_charm, [NewCharm, RoleId])),
        case NewRecordId > 0 of
            true ->
                db:execute(io_lib:format(?sql_insert_flower_gift_record, [NewRecordId, RoleId, SenderId, util:fix_sql_str(SenderName), ServerId, ServerNum, GoodsId, GoodsNum, IsAnonymous, 0, UnixTime]));
            _ -> skip
        end,
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            OneRecord = make_record(flower_gift_record, [NewRecordId, RoleId, SenderId, SenderName, ServerId, ServerNum, GoodsId, GoodsNum, IsAnonymous, 0, UnixTime]),
            NewReceiveFlowerRecord = [OneRecord|ReceiveFlowerRecord],
            save_flower_record_on_dict(NewReceiveFlowerRecord),
            NewPlayer = Player#player_status{flower = RoleFlowerData#flower{charm = NewCharm}},
            %% 日志
            lib_log_api:log_charm(RoleId, RoleFlowerData#flower.charm, NewCharm, [{goods, GoodsId, GoodsNum}]),
            lib_flower_act_api:reflash_rank_by_flower(NewPlayer, CharmPlus),
            %% 触发成就
            {ok, LastPlayer} = lib_achievement_api:flower_get_event(NewPlayer, NewCharm),
            %% 通知客户端收到新的鲜花礼物提示
            {ok, TipsBin} = pt_110:write(11016, [?MOD_FLOWER, ?RED_POINT_RECEIVE_FLOWER_GIFT, 1]),
            lib_server_send:send_to_uid(RoleId, TipsBin),

            {ok, LastPlayer};
        Err ->
            ?ERR("Send Flower Gift Err:~p~n", [Err]),
            {ok, Player}
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 跨服送花
send_gift_kf(Player, ReceiverId, ReceiverSerId, GoodsId, GoodsNum, IsAnonymous) ->
    #player_status{id = RoleId, server_id = SerId, server_num = SerNum, figure = #figure{lv = RoleLv, vip = VipLv} = SenderFigure} = Player,
    case data_flower:get_flower_gift_cfg(GoodsId) of
        #flower_gift_cfg{need_lv = NeedLv, need_vip = NeedVip, is_sell = IsSell} = GiftCfg when RoleLv >= NeedLv orelse VipLv >= NeedVip ->
            case check_send_flower_kf(SerId, ReceiverSerId) of 
                true ->
                    ?PRINT("send_gift_kf ################# ~p~n", [start]),
                    case lib_goods_api:cost_object_list(Player, [{?TYPE_GOODS, GoodsId, GoodsNum}], send_flower, "") of
                        {true, NewPlayer} ->
                            %% 日志
                            IsFriend = 0,
                            lib_log_api:log_send_flower(RoleId, ReceiverId, [{?TYPE_GOODS, GoodsId, GoodsNum}], IsFriend),
                            NewPlayer1 = do_send_gift_kf(NewPlayer, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                            %CostList = [{?TYPE_GOODS, GoodsId, GoodsNum}],
                            %% 跨服送花 匿名的
                            mod_clusters_node:apply_cast(lib_flower, receive_flower_from_other_server, [RoleId, SenderFigure, SerId, SerNum, ReceiverId, ReceiverSerId, GiftCfg, GoodsNum]),
                            {?SUCCESS, NewPlayer1};
                        {false, _Res, NewPlayer} ->
                            case IsSell == 1 of
                                true ->
                                    case data_goods:get_goods_buy_price(GoodsId) of
                                        {0, 0} ->
                                            {?ERRCODE(err150_type_err), NewPlayer};
                                        {PriceType, Price} ->
                                            NPrice = Price*GoodsNum,
                                            case lib_goods_api:cost_money(NewPlayer, [{PriceType, 0, NPrice}], send_flower, "") of
                                                {1, NewPlayer1} ->
                                                    %% 日志
                                                    IsFriend = 0,
                                                    %CostList = [{PriceType, 0, NPrice}],
                                                    lib_log_api:log_send_flower(RoleId, ReceiverId, [{PriceType, 0, NPrice}], IsFriend),
                                                    NewPlayer2 = do_send_gift_kf(NewPlayer1, ReceiverId, GiftCfg, GoodsNum, IsAnonymous),
                                                    mod_clusters_node:apply_cast(lib_flower, receive_flower_from_other_server, [RoleId, SenderFigure, SerId, SerNum, ReceiverId, ReceiverSerId, GiftCfg, GoodsNum]),
                                                    {?SUCCESS, NewPlayer2};
                                                {_Errcode, NewPlayer1} ->
                                                    {?ERRCODE(gold_not_enough), NewPlayer1}
                                            end
                                    end;
                                false -> %% 非出售道具 道具不足
                                    {?ERRCODE(goods_not_enough), NewPlayer}
                            end
                    end;
                {false, Res} ->
                    {Res, Player};
                _Err ->
                    {?ERRCODE(system_busy), Player}
            end;
        _ ->
            {?MISSING_CONFIG, Player}
    end.

do_send_gift_kf(Player, ReceiverId, GiftCfg, GoodsNum, _IsAnonymous) ->
    ?PRINT("do_send_gift_kf ################# ~p~n", [start]),
    #player_status{sid = Sid, id = RoleId, flower = RoleFlowerData, figure = Figure} = Player,
    #figure{name = _RoleName} = Figure,
    #flower_gift_cfg{
        goods_id    = GoodsId,
        effect_type = EffectType,
        effect      = Effect,
        intimacy    = IntimacyPlus,
        fame        = FamePlus,
        is_tv       = _IsTv
    } = GiftCfg,
    NewFamePlus = FamePlus * GoodsNum,
    %% 飘字提示
    %TipsBinData = lib_chat:make_tv(?MOD_FLOWER, 8, [NewFamePlus])
    %lib_server_send:send_to_sid(Sid, TipsBinData),
    NewFame = RoleFlowerData#flower.fame + NewFamePlus,
    db:execute(io_lib:format(?sql_update_fame, [NewFame, RoleId])),
    PreFameLv = lib_flower:get_fame_lv(RoleFlowerData#flower.fame),
    NewFameLv = lib_flower:get_fame_lv(NewFame),
    %% 显示特效
    case EffectType of
        2 -> %% 双方特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_sid(Sid, FXBinData);
        3 -> %% 全服特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_all(FXBinData);
        _ -> skip
    end,
    case PreFameLv =/= NewFameLv of
        true ->
            #fame_lv_cfg{attr = NewFameAttr} = data_flower:get_fame_lv_cfg(NewFameLv),
            NewPlayerTmp = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame, attr = NewFameAttr}},
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player#player_status{flower = RoleFlowerData#flower{fame = NewFame}}
    end,
    %% 日志
    lib_log_api:log_fame(RoleId, RoleFlowerData#flower.fame, NewFame, [{goods, GoodsId, GoodsNum}]),
    %% 触发成就
    {ok, NewPlayerAfAchv} = lib_achievement_api:flower_send_event(NewPlayer, NewFame),
    {_, LastPlayer} = lib_player_event:dispatch(NewPlayerAfAchv, ?EVENT_SEND_FLOWER, #callback_flower{to_id=ReceiverId, goods_id=GoodsId, intimacy=IntimacyPlus, sender=true}),
    ?PRINT("do_send_gift_kf ################# end ~n", []),
    LastPlayer.

receive_flower_from_other_server(RoleId, SenderFigure, SerId, SerNum, ReceiverId, ReceiverSerId, GiftCfg, GoodsNum) ->
    mod_clusters_center:apply_cast(ReceiverSerId, lib_flower, receive_flower_gift_kf, [RoleId, SenderFigure, SerId, SerNum, ReceiverId, GiftCfg, GoodsNum]).

handle_kf_send_flower_succ(?CUSTOM_ACT_TYPE_FLOWER_RANK, SenderId, SName, SSerId, SSerNum, ReceiverId, RName, RSerId, RSerNum, GiftCfg, GoodsNum) ->
    Type = ?CUSTOM_ACT_TYPE_FLOWER_RANK,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FLOWER_RANK),
    case SubTypeList of 
        [SubType|_] ->
            mod_clusters_node:apply_cast(lib_flower, handle_kf_send_flower_succ, [Type, SubType, SenderId, SName, SSerId, SSerNum, ReceiverId, RName, RSerId, RSerNum, GiftCfg, GoodsNum]);
        _ -> ok
    end;
handle_kf_send_flower_succ(_, _SenderId, _SName, _SSerId, _SSerNum, _ReceiverId, _RName, _RSerId, _RSerNum, _GiftCfg, _GoodsNum) ->
    ok.

handle_kf_send_flower_succ(ActType, ActSubType, _SenderId, SName, SSerId, SSerNum, _ReceiverId, RName, _RSerId, RSerNum, GiftCfg, GoodsNum) ->
    #flower_gift_cfg{
        goods_id    = GoodsId,
        charm = Charm,
        is_tv       = IsTv
    } = GiftCfg,
    %% 发送全部节点传闻
    case IsTv > 0 of
        true ->
            ZoneId = lib_clusters_center_api:get_zone(SSerId),
            Bin = lib_chat:make_tv(?MOD_FLOWER, 9, [SSerNum, SName, GoodsId, GoodsNum, RSerNum, RName, Charm*GoodsNum, ActType, ActSubType]),
            ?PRINT("handle_kf_send_flower_succ  ################# tv :~p~n", [ZoneId]),
            mod_zone_mgr:apply_cast_to_zone(1, ZoneId, lib_server_send, send_to_all, [Bin]);
        _ -> skip
    end.

%% 玩家收到鲜花
receive_flower_gift_kf(SenderId, SenderFigure, SSerId, SSerNum, ReceiverId, GiftCfg, GoodsNum) when is_integer(SenderId) ->
    #flower_gift_cfg{
        goods_id = GoodsId,
        charm = CharmPlus1
    } = GiftCfg,
    #figure{name = SName} = SenderFigure,
    CharmPlus = CharmPlus1 * GoodsNum,
    RSerId = config:get_server_id(),
    RSerNum = config:get_server_num(),
    ReceiverPid = misc:get_player_process(ReceiverId),
    case misc:is_process_alive(ReceiverPid) of
        true -> %% 在线跳到玩家进程处理
            lib_player:apply_cast(ReceiverPid, ?APPLY_CAST_SAVE, lib_flower, receive_flower_gift_kf, [SenderId, SenderFigure, SSerId, SSerNum, GiftCfg, GoodsNum]);
        false -> %% 玩家不在线直接操作数据库
            case lib_role:get_role_show(ReceiverId) of 
                #ets_role_show{figure = Figure} ->
                    ?PRINT("receive_flower_gift_kf off ################# start ~n", []),
                    #figure{name = RName} = Figure,
                    lib_flower_act_api:reflash_rank_by_flower(ReceiverId, CharmPlus),
                    NewRecordId = case catch mod_id_create:get_new_id(?FLOWER_GIFT_RECORD_ID_CREATE) of
                                      AutoId when is_integer(AutoId) -> AutoId;
                                      _ -> 0
                                  end,
                    handle_kf_send_flower_succ(?CUSTOM_ACT_TYPE_FLOWER_RANK, SenderId, SName, SSerId, SSerNum, ReceiverId, RName, RSerId, RSerNum, GiftCfg, GoodsNum),
                    F = fun() ->
                        NewCharm = case db:get_row(io_lib:format(?sql_sel_role_flower_data, [ReceiverId])) of
                                       [PreCharm | _] -> PreCharm + CharmPlus;
                                       _ -> PreCharm = 0, CharmPlus
                                   end,
                        db:execute(io_lib:format(?sql_update_charm, [NewCharm, ReceiverId])),
                        case NewRecordId > 0 of
                            true ->
                                db:execute(io_lib:format(?sql_insert_flower_gift_record, [NewRecordId, ReceiverId, SenderId, util:fix_sql_str(SName), SSerId, SSerNum, GoodsId, GoodsNum, 0, 0, utime:unixtime()]));
                            _ -> skip
                        end,
                        lib_log_api:log_flower_act_send_kf(SenderId, SName, SSerId, ReceiverId, RName, RSerId, PreCharm, NewCharm, GoodsId),
                        %% 日志
                        lib_log_api:log_charm(ReceiverId, PreCharm, NewCharm, [{goods, GoodsId, GoodsNum}]),
                        ok
                    end,
                    case catch db:transaction(F) of
                        ok -> ?PRINT("receive_flower_gift_kf off  ################# end ~n", []), ok;
                        Err -> ?ERR("Send Flower Gift Err:~p~n", [Err])
                    end;
                _ ->
                    lib_log_api:log_flower_act_send_kf(SenderId, SName, SSerId, ReceiverId, "", RSerId, 0, 0, GoodsId),
                    ok
            end
    end;

%% 收到鲜花礼物(收礼物玩家进程)
receive_flower_gift_kf(Player, SenderId, SenderFigure, SSerId, SSerNum, GiftCfg, GoodsNum) when is_record(Player, player_status) ->
    ?PRINT("receive_flower_gift_kf online ################# start ~n", []),
    #player_status{id = RoleId, sid = Sid, server_id = RSerId, server_num = RSerNum, figure = #figure{name = RName}, flower = RoleFlowerData} = Player,
    #flower_gift_cfg{
        goods_id = GoodsId,
        effect_type = EffectType,
        effect      = Effect,
        charm = CharmPlus1
    } = GiftCfg,
    #figure{name = SName} = SenderFigure,
    UnixTime = utime:unixtime(),
    CharmPlus = CharmPlus1 * GoodsNum,
    ReceiveFlowerRecord = get_flower_record_on_dict(RoleId),
    NewRecordId = case catch mod_id_create:get_new_id(?FLOWER_GIFT_RECORD_ID_CREATE) of
                      AutoId when is_integer(AutoId) -> AutoId;
                      _ -> 0
                  end,
    NewCharm = RoleFlowerData#flower.charm + CharmPlus,
    %% 显示特效
    case EffectType of
        2 -> %% 双方特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_sid(Sid, FXBinData);
        3 -> %% 全服特效
            {ok, FXBinData} = pt_110:write(11063, [Effect]),
            lib_server_send:send_to_all(FXBinData);
        _ -> skip
    end,
    %% 告诉收花者收到花
    {ok, Bin} = pt_223:write(22304, [SenderId, SenderFigure, SSerId, SSerNum, GoodsId, GoodsNum]),
    lib_server_send:send_to_sid(Sid, Bin),
    %% 刷新榜单
    lib_flower_act_api:reflash_rank_by_flower(Player, CharmPlus),
    %% 送花成功处理
    handle_kf_send_flower_succ(?CUSTOM_ACT_TYPE_FLOWER_RANK, SenderId, SName, SSerId, SSerNum, RoleId, RName, RSerId, RSerNum, GiftCfg, GoodsNum),
    F = fun() ->
        db:execute(io_lib:format(?sql_update_charm, [NewCharm, RoleId])),
        case NewRecordId > 0 of
            true ->
                db:execute(io_lib:format(?sql_insert_flower_gift_record, [NewRecordId, RoleId, SenderId, util:fix_sql_str(SName), SSerId, SSerNum, GoodsId, GoodsNum, 0, 0, UnixTime]));
            _ -> skip
        end,
        ok
        end,
    case catch db:transaction(F) of
        ok ->
            OneRecord = make_record(flower_gift_record, [NewRecordId, RoleId, SenderId, SName, SSerId, SSerNum, GoodsId, GoodsNum, 0, 0, UnixTime]),
            NewReceiveFlowerRecord = [OneRecord|ReceiveFlowerRecord],
            save_flower_record_on_dict(NewReceiveFlowerRecord),
            NewPlayer = Player#player_status{flower = RoleFlowerData#flower{charm = NewCharm}},
            %% 日志
            lib_log_api:log_charm(RoleId, RoleFlowerData#flower.charm, NewCharm, [{goods, GoodsId, GoodsNum}]),
            lib_log_api:log_flower_act_send_kf(SenderId, SName, SSerId, RoleId, RName, RSerId, RoleFlowerData#flower.charm, NewCharm, GiftCfg#flower_gift_cfg.goods_id),
            %% 触发成就
            {ok, LastPlayer} = lib_achievement_api:flower_get_event(NewPlayer, NewCharm),
            %% 通知客户端收到新的鲜花礼物提示
            {ok, TipsBin} = pt_110:write(11016, [?MOD_FLOWER, ?RED_POINT_RECEIVE_FLOWER_GIFT, 1]),
            lib_server_send:send_to_sid(Sid, TipsBin),
            ?PRINT("receive_flower_gift_kf online  ################# end ~n", []), 
            {ok, LastPlayer};
        Err ->
            ?ERR("Send Flower Gift Err:~p~n", [Err]),
            {ok, Player}
    end.


get_fame_lv(Fame) ->
    %% 这里获取到的ids列表是根据所需名誉降序排列的
    AllIds = data_flower:get_fame_lv_cfg_ids(),
    do_get_fame_lv(AllIds, Fame).

do_get_fame_lv([], _) -> 0;
do_get_fame_lv([Id | Ids], Fame) ->
    case data_flower:get_fame_lv_cfg(Id) of
        #fame_lv_cfg{fame = NeedFame} when Fame >= NeedFame -> Id;
        _ -> do_get_fame_lv(Ids, Fame)
    end.

get_fame_attr(Fame) ->
    case get_fame_lv(Fame) of
        Lv when Lv > 0 ->
            #fame_lv_cfg{attr = Attr} = data_flower:get_fame_lv_cfg(Lv),
            Attr;
        _ -> []
    end.

daily_timer(DelaySec) ->
    spawn(fun() ->
        util:multiserver_delay(DelaySec, lib_flower, clear, [])
    end).

clear() ->
    %% 清理过期的收礼记录
    ClearTime = utime:unixtime() - ?RECORD_VAILD_TIME,
    db:execute(io_lib:format(?sql_del_gift_record_out_time, [ClearTime])).

check_send_flower_kf(SenderSerId, ReceiverSerId) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FLOWER_RANK) of 
        true ->
            mod_clusters_node:apply_call(lib_flower_act, check_send_flower, [SenderSerId, ReceiverSerId]);
        _ ->
            {false, ?ERRCODE(err331_act_closed)}
    end.

