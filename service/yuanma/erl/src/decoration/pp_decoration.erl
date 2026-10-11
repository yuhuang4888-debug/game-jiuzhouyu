%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%%  幻饰
%%% @end
%%% Created : 03. 十二月 2018 14:55
%%%-------------------------------------------------------------------
-module(pp_decoration).
-author("whao").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("decoration.hrl").
%% API
-compile(export_all).


%% 穿戴幻饰
handle(Cmd = 14901, #player_status{sid = Sid} = PS, [GoodsId]) ->
    case lib_decoration:equip(PS, GoodsId) of
        {true, Res, OldGoodsInfo, Cell, NewPs} ->
            OldGoodsId =
                case is_record(OldGoodsInfo, goods) of
                    true -> OldGoodsInfo#goods.id;
                    false -> 0
                end,
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, GoodsId, OldGoodsId, Cell]),
            {ok, SupVipPs} = lib_supreme_vip_api:decoration_equip(NewPs),
            {ok, TemplePs} = lib_temple_awaken_api:trigger_decoration_rate(SupVipPs),
            {ok, battle_attr, TemplePs};
        {false, Res} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
            Cell = GoodsInfo#goods.subtype,
            send_error(Sid, Res, [Cell])
    end;

%% 卸下幻饰
handle(Cmd = 14902, #player_status{sid = Sid} = PS, [GoodsId]) ->
    case lib_decoration:unequip(PS, GoodsId) of
        {true, Res, Cell, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, GoodsId, Cell]),
            {ok, battle_attr, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, GoodsId, 0])
    end;

%% 幻饰进阶
handle(14903, #player_status{sid = Sid} = PS, [GoodsId]) ->
%%    ?PRINT("14903 GoodsId:~p~n", [GoodsId]),
    case lib_decoration:stage_up(PS, GoodsId) of
        {true, _Res, NewPS} ->
            {ok, SupVipPs} = lib_supreme_vip_api:decoration_equip(NewPS),
            {ok, TemplePs} = lib_temple_awaken_api:trigger_decoration_rate(SupVipPs),
            {ok, battle_attr, TemplePs};
        {false, Res, NewPS} ->
            send_error(Sid, Res, []),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;

%% 强化信息
handle(Cmd = 14904, #player_status{sid = Sid, decoration = Dec} = PS, [Cell]) ->
%%    ?PRINT("14904 Cell:~p~n", [Cell]),
    Lev = lib_decoration:get_dec_show_level(Cell, PS),
    Point =
        case lists:keyfind(Cell, 1, Dec#decoration.pos_goods) of
            false -> 0;
            {Cell, GoodsId} ->
                GoodsStatus = lib_goods_do:get_goods_status(),
                GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
                GoodsTypeId = GoodsInfo#goods.goods_id,
                LevelInfo = data_goods_type:get(GoodsTypeId),
                #dec_level_cfg{attr = LAttr} = data_decoration:get_dec_level(Cell, Lev),
                lib_decoration:cal_level_rating(LevelInfo, LAttr)
        end,
%%    ?PRINT("14904 ?SUCCESS, Cell, Lev Point:~w~n", [[?SUCCESS, Cell, Lev, Point]]),
    lib_server_send:send_to_sid(Sid, pt_149, Cmd, [?SUCCESS, Cell, Lev, Point]),
    ok;

%% 幻饰强化 (绑定部位)
handle(Cmd = 14905, #player_status{sid = Sid, decoration = Dec} = PS, [EquipPos, EquipType]) ->
    case lib_decoration:stren(PS, EquipPos, EquipType) of
        {true, Res, NewLevel, NewPS} ->
            Point =
                case lists:keyfind(EquipPos, 1, Dec#decoration.pos_goods) of
                    false -> 0;
                    {EquipPos, GoodsId} ->
                        GoodsStatus = lib_goods_do:get_goods_status(),
                        GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
                        GoodsTypeId = GoodsInfo#goods.goods_id,
                        LevelInfo = data_goods_type:get(GoodsTypeId),
                        #dec_level_cfg{attr = LAttr} = data_decoration:get_dec_level(EquipPos, NewLevel),
                        lib_decoration:cal_level_rating(LevelInfo, LAttr)
                end,
            EquipList = [{EquipPos, NewLevel, Point}],
%%            ?PRINT("EquipPos, NewLevel, Point~w~n",[[EquipPos, NewLevel, Point]]),
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, 0, EquipType, EquipList]),
            {ok, equip, NewPS};
        {false, Res, ErrEquipPos, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, ErrEquipPos, EquipType, []]),
            {ok, NewPS};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [Res, 0, EquipType, []]),
            {ok, NewPS};
        _Error ->
            {ok, PS}
    end;

%% 幻化的进阶属性预览
handle(Cmd = 14906, #player_status{sid = Sid}, [GoodsId]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods{goods_id = OldGoodsTypeId, other = OldGoodsOther} = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    DecAllGoods = data_decoration:get_all_dec_goods(),
    IsDecGoods = lists:member(OldGoodsTypeId, DecAllGoods),
    #dec_stage_cfg{new_goods_id = NewGoodsTypeId} = data_decoration:get_dec_stage(OldGoodsTypeId),
    IsGoodsTypeId = NewGoodsTypeId > 0,
    if
        not IsGoodsTypeId ->
            skip;
        not IsDecGoods -> 
            send_error(Sid, ?ERRCODE(err149_err_dec), []);
        true ->
            NewGoodsTypeInfo = data_goods_type:get(NewGoodsTypeId),
            NewExtraAttr = lib_decoration:gen_equip_extra_attr_by_types(NewGoodsTypeInfo, OldGoodsOther#goods_other.extra_attr),
            PackAttrList = data_attr:unified_format_extra_attr(NewExtraAttr, []),
            Rating = lib_equip_api:cal_equip_rating(NewGoodsTypeInfo, NewExtraAttr),
%%            ?PRINT("GoodsId:~p, Rating:~p, PackAttrList:~p~n",[GoodsId, Rating, PackAttrList]),
            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [GoodsId, Rating, PackAttrList])
    end;

%% 幻化的分解属性预览
handle(Cmd = 14907, #player_status{sid = Sid}, [GoodsId]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods{goods_id = OldGoodsTypeId, other = OldGoodsOther} = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    DecAllGoods = data_decoration:get_all_dec_goods(),
    case lists:member(OldGoodsTypeId, DecAllGoods) of
        true ->
            case data_goods_decompose:get(OldGoodsTypeId) of
                #goods_decompose_cfg{regular_mat = RegularMat} ->
                    [{_GoodsTmpType, GoodsTmpIds, _GoodsTmpNum} | _] = RegularMat,
                    NewGoodsTypeId =
                        case lists:member(GoodsTmpIds, DecAllGoods) of
                            true -> GoodsTmpIds;
                            false -> 0
                        end,
                    case NewGoodsTypeId == 0 of
                        true ->
                            lib_server_send:send_to_sid(Sid, pt_149, 14900, [?ERRCODE(err149_err_dec)]);
                        false ->
                            NewGoodsTypeInfo = data_goods_type:get(NewGoodsTypeId),
                            NewExtraAttr = lib_decoration:gen_equip_extra_attr_by_types(NewGoodsTypeInfo, OldGoodsOther#goods_other.extra_attr),
                            PackAttrList = data_attr:unified_format_extra_attr(NewExtraAttr, []),
                            Rating = lib_equip_api:cal_equip_rating(NewGoodsTypeInfo, NewExtraAttr),
                            lib_server_send:send_to_sid(Sid, pt_149, Cmd, [GoodsId, Rating, PackAttrList])
                    end;
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_149, 14900, [?ERRCODE(err149_err_dec)])
            end;
        false ->
            send_error(Sid, ?ERRCODE(err149_err_dec), [])
    end;

%% 返回解锁部位列表
handle(Cmd = 14908, Ps, []) ->
    #player_status{sid = Sid, decoration = #decoration{unlock_cell_list = UnlockCellList}} = Ps,
    lib_server_send:send_to_sid(Sid, pt_149, Cmd, [UnlockCellList]);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

%% 公共错误码协议发送
send_error(Sid, Code, Args) ->
    {CodeInt, CoedeArgs} = parse_error_code(Code, Args),
    lib_server_send:send_to_sid(Sid, pt_149, 14900, [CodeInt, CoedeArgs]).

parse_error_code(Code, [Cell | _]) when Code == 1490007 -> %% err149_cell_lock_limit
    NeedStage = data_decoration:get_unlock_stage(Cell),
    LanId = case Cell of
                1 -> 4710005;
                2 -> 4710006;
                3 -> 4710007;
                4 -> 4710008;
                5 -> 4710009;
                _ -> 4710010
            end,
    LocName = data_language:get(LanId),
    util:parse_error_code({Code, [LocName, NeedStage]});
parse_error_code(Code, _) ->
    util:parse_error_code(Code).












