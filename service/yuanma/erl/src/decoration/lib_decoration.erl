%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 幻饰
%%% @end
%%% Created : 03. 十二月 2018 14:55
%%%-------------------------------------------------------------------
-module(lib_decoration).
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
-include("predefine.hrl").
-include("attr.hrl").
%% API
-compile(export_all).

%% 玩家登陆
login(PS, GoodsStatus) ->
    #player_status{id = RoleId, figure = #figure{lv = PlayerLv}} = PS,
    EquipList = lib_goods_util:get_equip_list(null, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, GoodsStatus#goods_status.dict),
    DecBaseAttr = data_goods:count_goods_attribute(EquipList),
    DecAttr = data_goods:count_extra_attr(PlayerLv, EquipList),
    Dector =
        case db_level_select(RoleId) of
            [] ->
                PosGoods = [{Goods#goods.cell, Goods#goods.id} || Goods <- EquipList],
                TotalList = [DecBaseAttr, DecAttr],
                TotalAttribute = ulists:kv_list_plus_extra(TotalList),
                AttrRecord = to_attr_record(TotalAttribute),
                UnlockCellList = login_load_unlock_cell_list(RoleId),
                #decoration{pos_goods = PosGoods, attr = AttrRecord, unlock_cell_list = UnlockCellList};
            List ->
                LevList = [{Pos, Lev} || [Pos, Lev] <- List],
                PosGoods = [{Goods#goods.cell, Goods#goods.id} || Goods <- EquipList],
                %% 计算属性
                F1 = fun({Pos, _Level}, AttrTmp) ->
                    TureLevel =
                        case lists:keyfind(Pos, 1, PosGoods) of
                            false -> 0;
                            {Pos, GoodsId} ->
                                case lists:keyfind(Pos, 1, LevList) of
                                    {Pos, Level} ->
                                        GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
                                        GoodsTypeId = GoodsInfo#goods.goods_id,
                                        Stage = case data_decoration:get_dec_attr(GoodsTypeId) of
                                                    #dec_attr_cfg{stage = Stg} -> Stg;
                                                    _ -> 1
                                                end,
                                        DecLevMax = data_decoration:get_dec_level_max(Pos, Stage, GoodsInfo#goods.color),
                                        case is_record(DecLevMax, dec_level_max_cfg) of
                                            true ->
                                                case Level >= DecLevMax#dec_level_max_cfg.limit_level of
                                                    true -> DecLevMax#dec_level_max_cfg.limit_level;
                                                    false -> Level
                                                end;
                                            false -> 0
                                        end;
                                    false -> 0
                                end
                        end,
                    case data_decoration:get_dec_level(Pos, TureLevel) of
                        #dec_level_cfg{attr = LAttr} ->
                            AttrTmp ++ LAttr;
                        _ ->
                            AttrTmp
                    end
                     end,
                LevelAttr = lists:foldl(F1, [], LevList),
                TotalList = [DecBaseAttr, DecAttr, LevelAttr],
                TotalAttribute = ulists:kv_list_plus_extra(TotalList),
                AttrRecord = to_attr_record(TotalAttribute),
                UnlockCellList = login_load_unlock_cell_list(RoleId),
                #decoration{level_list = LevList, pos_goods = PosGoods, attr = AttrRecord, unlock_cell_list = UnlockCellList}
        end,
    PS#player_status{decoration = Dector}.

%% 登录加载已解锁的部位
login_load_unlock_cell_list(RoleId) ->
    case db_unlock_cell_select(RoleId) of 
        [[UnlockCellListStr] | _] -> 
            util:string_to_term(binary_to_list(UnlockCellListStr));
        _ -> 
            [1]
    end.

% ------------------------------- 穿戴装备  -------------------------------
equip(PS, GoodsId) ->
    #player_status{sid = Sid} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_decoration_check:equip(PS, GoodsStatus, GoodsId) of
        {true, GoodsInfo} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                do_equip_core(PS, GoodsStatus, GoodsInfo)
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, OldGoodsInfo, GoodsL, Cell, NewUnlockCellList} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                    lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, [GoodsInfo#goods{num = 0}]),
                    lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, GoodsL),
                    %% 计算属性
                    NewPS = update_pos_goods(PS, Cell, GoodsId),
                    NewDecoration = NewPS#player_status.decoration#decoration{unlock_cell_list = NewUnlockCellList},
                    BfCountPS = NewPS#player_status{decoration = NewDecoration},
                    LastPS = count_decoration_attr(BfCountPS),
                    lib_server_send:send_to_sid(Sid, pt_149, 14908, [NewUnlockCellList]),
                    {true, ?SUCCESS, OldGoodsInfo, Cell, LastPS};
                Error ->
                    ?ERR("equip error:~p", [Error]),
                    {false, ?FAIL}
            end;
        {false, Res} ->
            {false, Res}
    end.

do_equip_core(#player_status{id = PlayerId, decoration = #decoration{unlock_cell_list = UnlockCellList}} = PS, GoodsStatus, GoodsInfo) ->
    Location = ?GOODS_LOC_DECORATION, % 装备位置
    GoodDict = GoodsStatus#goods_status.dict,
    Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type), % 部位
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(PlayerId, Location, Cell, GoodDict), % 获取之前的物品信息
    {NewOldGoodsInfo, NewGoodsStatus} =
        case is_record(OldGoodsInfo, goods) of
            true -> %% 存在已装备的物品，则替换装备
                %%   替换时，两个装备的默认位置有可能不一样 卸下的装备要回来原来默认的背包位置。 start
                OriginalCell = 0, %% 卸下没有格子位置的概念，全部置为0
                GoodsTypeTemp = data_goods_type:get(OldGoodsInfo#goods.goods_id),
                OriginalLocation = GoodsTypeTemp#ets_goods_type.bag_location, %%  end
                #goods{other = OldOther} = OldGoodsInfo,
                OldGoodsInfoAfStren = OldGoodsInfo#goods{other = OldOther#goods_other{stren = 0}},
                [OldGoodsInfo2, GoodsStatus1] = lib_goods:change_goods_cell_and_use(OldGoodsInfoAfStren, OriginalLocation, OriginalCell, GoodsStatus), % 卸下
                #goods{goods_id = GoodsTypeId, color = Color, other = Other} = GoodsInfo,
                Level = get_dec_show_level(PS, Cell, GoodsTypeId, Color),
                GoodsInfoAfStren = GoodsInfo#goods{other = Other#goods_other{stren = Level}},
                [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(GoodsInfoAfStren, Location, Cell, GoodsStatus1), % 装上
                {OldGoodsInfo2, GoodsStatus2};
            false -> %% 不存在，直接穿戴
                #goods{goods_id = GoodsTypeId, color = Color, other = Other} = GoodsInfo,
                Level = get_dec_show_level(PS, Cell, GoodsTypeId, Color),
                GoodsInfoAfStren = GoodsInfo#goods{other = Other#goods_other{stren = Level}},
                [_GoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(GoodsInfoAfStren, Location, Cell, GoodsStatus),
                {OldGoodsInfo, GoodsStatus1}
        end,
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewStatus = NewGoodsStatus#goods_status{dict = GoodsDict},
    %% 解锁新部位
    NewUnlockCellList = unlock_cell(PlayerId, UnlockCellList, GoodsDict),
    {ok, NewStatus, NewOldGoodsInfo, GoodsL, Cell, NewUnlockCellList}.


%% ------------------------------- 卸载装备  -------------------------------
unequip(PS, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_decoration_check:unequip(GoodsStatus, GoodsId) of
        {true, GoodsInfo} ->
            F =
                fun() ->
                    ok = lib_goods_dict:start_dict(),
                    %% 背包位置用物品类型默认的位置 start
                    GoodsType = data_goods_type:get(GoodsInfo#goods.goods_id),
                    Location = GoodsType#ets_goods_type.bag_location, % 卸下装备
                    Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type), % 卸下的部位位置
                    [_NewGoodsInfo, GoodsStatus1] = lib_goods:change_goods_cell_and_use(GoodsInfo, Location, Cell, GoodsStatus),
                    #goods_status{dict = OldGoodsDict} = GoodsStatus1,
                    {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                    GoodsStatus2 = GoodsStatus1#goods_status{dict = Dict},
                    {ok, GoodsStatus2, GoodsL, Cell}
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, GoodsL, Cell} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, GoodsL),
                    %% 计算属性
                    PosGoods = PS#player_status.decoration#decoration.pos_goods,
                    NewPosGoods = lists:keydelete(Cell, 1, PosGoods),
                    NewDecoration = PS#player_status.decoration#decoration{pos_goods = NewPosGoods},
                    BfCountPS = PS#player_status{decoration = NewDecoration},
                    LastPS = count_decoration_attr(BfCountPS),
                    {true, ?SUCCESS, Cell, LastPS};
                Error ->
                    ?ERR("equip error:~p", [Error]),
                    {false, ?FAIL}
            end;
        {false, Res} -> {false, Res}
    end.


%% ------------------------------- 幻饰进阶  -------------------------------
%% 进阶装备直接更新旧装备的物品类型id 属性等字段
%% 要同时更新goods, goods_low, goods_high三张表
stage_up(#player_status{sid = Sid, id = RoleId} = PS, GoodsId) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
    #dec_stage_cfg{cost = Cost, new_goods_id = NewGoodsId} = data_decoration:get_dec_stage(GoodsInfo#goods.goods_id),
    case lib_decoration_check:stage_up(PS, GoodsStatus, GoodsId) of
        {true, EquipInfo} ->
            F =
                fun() ->
                    ok = lib_goods_dict:start_dict(),
                    case lib_goods_util:cost_object_list(PS, Cost, dec_stage_up, "", GoodsStatus) of
                        {true, NewStatus, NewPS} ->
                            {LastStatus, GoodsL, NewEquipInfo, NewUnlockCellList} = do_upgrade_stage_core(PS, NewStatus, EquipInfo, NewGoodsId),
                            {ok, LastStatus, GoodsL, NewPS, NewEquipInfo, NewUnlockCellList};
                        {false, Res, NewStatus, NewPS} ->
                            {error, Res, NewStatus, NewPS}
                    end
                end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, UpdateGoodsList, NewPS, NewEquipInfo, NewUnlockCellList} ->
                    %% 装备升阶日志
                    lib_log_api:log_decoration_stage_up(RoleId, EquipInfo#goods.id, EquipInfo#goods.goods_id, Cost, NewGoodsId),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    lib_goods_api:notify_client_num(NewGoodsStatus#goods_status.player_id, UpdateGoodsList),
                    lib_goods_api:notify_client(NewGoodsStatus#goods_status.player_id, UpdateGoodsList),
                    %% 计算属性
                    LastPS = update_pos_goods(NewPS, NewEquipInfo#goods.cell, NewEquipInfo#goods.id),
                    NewDecoration = LastPS#player_status.decoration#decoration{unlock_cell_list = NewUnlockCellList},
                    BfCountPS = LastPS#player_status{decoration = NewDecoration},
                    LastPS1 = count_decoration_attr(BfCountPS),             
                    lib_server_send:send_to_sid(Sid, pt_149, 14908, [NewUnlockCellList]),
                    #dec_attr_cfg{stage = NewStage} = data_decoration:get_dec_attr(NewGoodsId),
                    lib_server_send:send_to_sid(Sid, pt_149, 14903, [?SUCCESS, NewGoodsId, NewEquipInfo#goods.cell, NewStage]),
                    {true, ?SUCCESS, LastPS1};
                {error, Res, NewGoodsStatus, NewPS} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    {false, Res, NewPS};
                Error ->
                    ?ERR("decoration_upgrade_stage error:~p", [Error]),
                    {false, ?FAIL, PS}
            end;
        {false, Res} -> {false, Res, PS}
    end.

do_upgrade_stage_core(PS, GoodsStatus, EquipInfo, NewGTypeId) ->
    #player_status{id = PlayerId, decoration = #decoration{unlock_cell_list = UnlockCellList}} = PS,
    #goods{id = GoodsId, other = GoodsOther, cell = Cell} = EquipInfo,
    #ets_goods_type{
        level = NewLv,
        color = NewColor,
        addition = NewAddition} = NewGoodsTypeInfo = data_goods_type:get(NewGTypeId),
    {NewPriceType, NewPrice} = data_goods:get_goods_buy_price(NewGTypeId),
    NewExtraAttr = gen_equip_extra_attr_by_types(NewGoodsTypeInfo, GoodsOther#goods_other.extra_attr),
    Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
        [NewPriceType, NewPrice, GoodsId]),
    db:execute(Sql),
    Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, color = ~p, addition = '~s', extra_attr = '~s' where gid = ~p">>,
        [NewGTypeId, NewLv, NewColor, util:term_to_string(NewAddition), util:term_to_string(NewExtraAttr), GoodsId]),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
        [NewGTypeId, GoodsId]),
    db:execute(Sql2),
    NewStren = get_dec_show_level(PS, Cell, NewGTypeId, NewColor),
    NewGoodsOther = GoodsOther#goods_other{
        stren = NewStren,
        extra_attr = NewExtraAttr,
        rating = lib_equip_api:cal_equip_rating(NewGoodsTypeInfo, NewExtraAttr)
    },
    NewEquipInfo = EquipInfo#goods{
        goods_id = NewGTypeId,
        price_type = NewPriceType,
        price = NewPrice,
        level = NewLv,
        color = NewColor,
        other = NewGoodsOther
    },
    NewGoodsStatus = lib_goods:change_goods(NewEquipInfo, ?GOODS_LOC_DECORATION, GoodsStatus),
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewStatus = NewGoodsStatus#goods_status{dict = GoodsDict},
    %% 解锁新部位
    NewUnlockCellList = unlock_cell(PlayerId, UnlockCellList, GoodsDict),
    {NewStatus, GoodsL, NewEquipInfo, NewUnlockCellList}.


%%--------------------------------------------------
%% 根据已有的属性生成新的装备极品属性
%% @param  GoodsTypeInfo description
%% @param  OldExtraAttr  [{color,id,val}|{color,id,base_val,plus_interval,plus}]
%% @return               description
%%--------------------------------------------------
gen_equip_extra_attr_by_types(GoodsTypeInfo, OldExtraAttr) ->
    gen_equip_extra_attr(GoodsTypeInfo, lists:reverse(OldExtraAttr)).

%% 生成装备的极品属性
gen_equip_extra_attr(GoodsTypeInfo, OldExtraAttr) ->
    case data_decoration:get_dec_attr(GoodsTypeInfo#ets_goods_type.goods_id) of
        #dec_attr_cfg{color_attr = ColorAttr} ->
            NewColorAttr = lists:reverse(lists:keysort(1, ColorAttr)),
            AttrArgs = [{AttrNum, AttrVal} || {_Color, AttrNum, AttrVal} <- NewColorAttr], %%先生成高品质的
            NewAttr = lib_equip_api:gen_equip_extra_attr(AttrArgs, OldExtraAttr),
            NewAttr;
        _ ->
            []
    end.

%% 计算的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    GoodsType = GoodsTypeInfo#ets_goods_type.type,
    case GoodsType == ?GOODS_TYPE_DECORATION of
        true ->
            #ets_goods_type{goods_id = GTypeId, level = Level, base_attrlist = BaseAttr} = GoodsTypeInfo,
            #dec_attr_cfg{stage = Stage} = data_decoration:get_dec_attr(GTypeId),
            % ?MYLOG("hjhdecor", "GTypeId:~p, Stage:~p ~n", [GTypeId, Stage]),
            F = fun(OneExtraAttr, RatingTmp) ->
                case OneExtraAttr of
                    {OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, OneAttrVal} ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        RatingTmp + OneAttrRating * OneAttrVal;
                    {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                        %%chenyiming  成长属性公式 =  附属属性推算战力――成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                        GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                        RatingTmp + OneAttrRating * GrowthAttrRealVal;
                    _ ->
                        RatingTmp
                end
                end,
            Rating = lists:foldl(F, 0, BaseAttr ++ EquipExtraAttr),
            round(Rating);
        false ->
            0
    end;
cal_equip_rating(_, _) -> 0.


cal_level_rating(GoodsTypeInfo, Attr) ->
    #ets_goods_type{goods_id = GTypeId, level = Level, base_attrlist = BaseAttr} = GoodsTypeInfo,
    Stage = case data_decoration:get_dec_attr(GTypeId) of
                #dec_attr_cfg{stage = Stg} -> Stg;
                _ -> 1
            end,
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力――成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, Attr ++ BaseAttr),
    round(Rating).

%% 仅计算等级的属性加成
only_cal_level_rating(GoodsTypeInfo, Attr) ->
    #ets_goods_type{goods_id = GTypeId, level = Level} = GoodsTypeInfo,
    Stage = case data_decoration:get_dec_attr(GTypeId) of
                #dec_attr_cfg{stage = Stg} -> Stg;
                _ -> 1
            end,
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力――成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, Stage),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, Attr),
    round(Rating).


%% -----------------------------------------------------------------
%% @desc     功能描述  是否包含属性id
%% @param    参数      AttrResult::lists    [{_Color, _AttrId, _AttrVal} |  {_Color, _AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus} ]
%%                     GainAttr   tuple     {_Color, _AttrId, _AttrVal} |  {_Color, _AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus}
%% @return   返回值    Boolean
%% @history  修改历史
%% -----------------------------------------------------------------
is_include_attr(AttrResult, {_Color, AttrId, _AttrVal}) ->
    case lists:keyfind(AttrId, 2, AttrResult) of
        false ->
            false;
        _ ->
            true
    end;
is_include_attr(AttrResult, {_Color, AttrId, _AttrBaseVal, _AttrPlusInterval, _AttrPlus}) ->
    case lists:keyfind(AttrId, 2, AttrResult) of
        false ->
            false;
        _ ->
            true
    end;
is_include_attr(_, _) ->
    false.


%%------------------------ 强化幻饰 -------------------------
stren(PS, EquipPos, StrenType) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case StrenType of
        1 -> % 强化
            case lib_decoration_check:stren(PS, GoodsStatus, EquipPos) of
                {true, EquipInfo, Level, Cfg} ->
                    F = fun() ->
                        ok = lib_goods_dict:start_dict(),
                        do_stren_core(PS, GoodsStatus, EquipPos, EquipInfo, Level, Cfg)
                        end,
                    case lib_goods_util:transaction(F) of
                        {ok, NewGoodsStatus, UpdateGoodsList, NewLevel, NewPS} ->
                            PlayerId = PS#player_status.id,
                            Cost = Cfg#dec_level_cfg.cost,
                            %% 日志
                            lib_log_api:log_decoration_level_up(PlayerId, EquipPos, Cost, Level, NewLevel),
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client_num(PlayerId, UpdateGoodsList),
                            lib_goods_api:notify_client(PlayerId, UpdateGoodsList),
                            %% 属性更新
                            LastPS1 = count_decoration_attr(NewPS),

                            %% 触发幻饰强化事件
                            LastPS = lib_decoration_event:decoration_level_up(LastPS1, EquipPos, StrenType, NewLevel),
                            {true, ?SUCCESS, NewLevel, LastPS};
                        {error, Res, NewGoodsStatus, NewPS} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            {false, Res, NewPS};
                        Error ->
                            ?ERR("stren error:~p", [Error]),
                            {false, ?FAIL, PS}
                    end;
                {false, Res} ->
                    {false, Res, PS}
            end;
        _ ->
            {false, 0, PS}
    end.

do_stren_core(PS, GoodsStatus, EquipPos, EquipInfo, Level, Cfg) ->
    ObjectList = Cfg#dec_level_cfg.cost,
    #goods_status{dict = Dict} = GoodsStatus,
    #player_status{id = RoleId, decoration = Decoration} = PS,
    #decoration{level_list = LevelList} = Decoration,
    {NewDict, NewLevelList, NewLevel, RealCostList} =
        do_stren_core_helper(Dict, LevelList, EquipPos, EquipInfo, Level, ObjectList),
    NewGoodsStatus = GoodsStatus#goods_status{dict = NewDict},
    NewPS = PS#player_status{decoration = Decoration#decoration{level_list = NewLevelList}},
    case lib_goods_util:cost_object_list(NewPS, RealCostList, dec_level_up, "", NewGoodsStatus) of % 扣除物品
        {true, NewStatus, NewPS1} ->
            db_level_replace(RoleId, EquipPos, NewLevel),
            {LastDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
            NewStatus1 = NewStatus#goods_status{dict = LastDict},
            {ok, NewStatus1, GoodsL, NewLevel, NewPS1};
        {false, Res, NewStatus, NewPS1} ->
            {error, Res, NewStatus, NewPS1};
        Error ->
            ?ERR("equip error:~p", [Error])
    end.

do_stren_core_helper(Dict, LevelList, EquipPos, EquipInfo, Level, CostList) ->
    DecStage = data_decoration:get_dec_stage(EquipInfo#goods.goods_id),
    LevelMax = data_decoration:get_dec_level_max(EquipInfo#goods.location, DecStage, EquipInfo#goods.color),
    case Level < LevelMax of
        true ->
            case data_decoration:get_dec_level(EquipPos, Level + 1) of
                NextCfg when is_record(NextCfg, dec_level_cfg) ->
                    NewCost = CostList,
                    %% 更新这件装备的强化等级
                    EquipInfoOther = EquipInfo#goods.other,
                    NewEquipInfo = EquipInfo#goods{other = EquipInfoOther#goods_other{stren = Level + 1}},
                    NewDict = lib_goods_dict:append_dict({add, goods, NewEquipInfo}, Dict),
                    NewLev = Level + 1;
                _ -> %% 下一级配置不存在 当前阶满级
                    NewCost = [],
                    NewDict = Dict,
                    NewLev = Level
            end,
            NewLevelList = lists:keystore(EquipPos, 1, LevelList, {EquipPos, NewLev}),
            {NewDict, NewLevelList, NewLev, NewCost};
        false ->
            {Dict, LevelList, Level, []}
    end.


%% 获取强化等级
get_dec_level(PS, Cell) ->
    #player_status{decoration = Dec} = PS,
    #decoration{level_list = LevelList} = Dec,
    Level =
        case lists:keyfind(Cell, 1, LevelList) of
            false -> 0;
            {Cell, TmpLevel} -> TmpLevel

        end,
    Level.

get_dec_show_level(Cell, PS) ->
    #player_status{decoration = Decoration} = PS,
    #decoration{level_list = LevelList, pos_goods = PosGoods} = Decoration,
    case lists:keyfind(Cell, 1, PosGoods) of
        {Cell, GoodsId} when GoodsId > 0 ->
            case lists:keyfind(Cell, 1, LevelList) of
                {Cell, Level} ->
                    GoodsStatus = lib_goods_do:get_goods_status(),
                    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
                    GoodsTypeId = GoodsInfo#goods.goods_id,
                    Stage = case data_decoration:get_dec_attr(GoodsTypeId) of
                                #dec_attr_cfg{stage = Stg} -> Stg;
                                _ -> 1
                            end,
                    DecLevMax = data_decoration:get_dec_level_max(Cell, Stage, GoodsInfo#goods.color),
                    case is_record(DecLevMax, dec_level_max_cfg) of
                        true ->
                            case Level >= DecLevMax#dec_level_max_cfg.limit_level of
                                true -> DecLevMax#dec_level_max_cfg.limit_level;
                                false -> Level
                            end;
                        false -> 0
                    end;
                false -> 0
            end;
        _ -> 0
    end.

get_dec_show_level(PS, Cell, GoodsTypeId, Color) ->
    #player_status{decoration = Dec} = PS,
    #decoration{level_list = LevelList} = Dec,
    case lists:keyfind(Cell, 1, LevelList) of
        false -> 0;
        {Cell, Level} -> 
            Stage = case data_decoration:get_dec_attr(GoodsTypeId) of
                #dec_attr_cfg{stage = Stg} -> Stg;
                _ -> 1
            end,
            DecLevMax = data_decoration:get_dec_level_max(Cell, Stage, Color),
            case is_record(DecLevMax, dec_level_max_cfg) of
                true ->
                    case Level >= DecLevMax#dec_level_max_cfg.limit_level of
                        true -> DecLevMax#dec_level_max_cfg.limit_level;
                        false -> Level
                    end;
                false -> 
                    0
            end
    end.

%%%% 计算评分
%%get_dec_point() ->
%%


%% 获取身上幻饰所有的准确位置
%%get_dec_location(Dict) ->
%%    EquipList = lib_goods_util:get_equip_list(null, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, Dict),
%%    [{Goods#goods.cell, Goods#goods.id} || Goods <- EquipList].


%% 根据装备位置，获取装备信息
get_dec_by_location(PS, GoodsStatus, EquipPos) ->
    #player_status{decoration = #decoration{pos_goods = PosGoods}} = PS,
    case lists:keyfind(EquipPos, 1, PosGoods) of
        false ->
            [];
        {EquipPos, EquipId} ->
            lib_goods_util:get_goods(EquipId, GoodsStatus#goods_status.dict)
    end.

%% 更新幻饰的装备 PS
update_pos_goods(PS, Pos, GoodsId) ->
    #player_status{decoration = Dec} = PS,
    #decoration{pos_goods = PosGoods} = Dec,
    NewPosGoods = lists:keystore(Pos, 1, PosGoods, {Pos, GoodsId}),
    NewDec = Dec#decoration{pos_goods = NewPosGoods},
    PS#player_status{decoration = NewDec}.


%% 计算幻饰属性
count_decoration_attr(Player) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{decoration = Decoration, figure = #figure{lv = PlayerLv}} = Player,
    #decoration{level_list = LevelList} = Decoration,
    EquipList = lib_goods_util:get_equip_list(null, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, GoodsStatus#goods_status.dict),
    DecBaseAttr = data_goods:count_goods_attribute(EquipList),
    DecAttr = data_goods:count_extra_attr(PlayerLv, EquipList),
    F1 = fun({Pos, _Level}, AttrTmp) ->
        TureLevel = get_dec_show_level(Pos, Player),
        case data_decoration:get_dec_level(Pos, TureLevel) of
            #dec_level_cfg{attr = LAttr} ->
                AttrTmp ++ LAttr;
            _ ->
                AttrTmp
        end
         end,
    LevelAttr = lists:foldl(F1, [], LevelList),
    TotalList = [DecBaseAttr, DecAttr, LevelAttr],
%%    ?PRINT("=====EquipList :~p LevelList:~p DecAttr:~p LevelAttr:~p DecBaseAttr:~p~n", [EquipList, LevelList, DecAttr, LevelAttr, DecBaseAttr]),
    TotalAttribute = ulists:kv_list_plus_extra(TotalList),
    AttrRecord = to_attr_record(TotalAttribute),
    NewDecoration = Decoration#decoration{attr = AttrRecord},
    NewPlayer = Player#player_status{decoration = NewDecoration},
    NewPlayer1 = lib_player:count_player_attribute(NewPlayer),
    lib_player:send_attribute_change_notify(NewPlayer1, ?NOTIFY_ATTR),
    NewPlayer1.

to_attr_record([]) -> #attr{};
to_attr_record(TotalAttribute) ->
    lib_player_attr:add_attr(record, [TotalAttribute]).

%% 获得身上最大阶数
get_max_stage(#player_status{id = RoleId}) ->
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, Dict),
    F = fun(#goods{goods_id = GoodsTypeId}, MaxStage) ->
        case data_decoration:get_dec_attr(GoodsTypeId) of
            #dec_attr_cfg{stage = Stage} -> max(Stage, MaxStage);
            _ -> MaxStage
        end
    end,
    lists:foldl(F, 0, EquipList). 

%% 获得总评分
get_overall_rating(#player_status{id = RoleId}) ->
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, Dict),
    F = fun(GoodsInfo, SumRating) ->
        case lib_goods_util:load_goods_other(GoodsInfo) of
            true -> OverallRating = lib_equip:cal_equip_overall_rating(?GOODS_LOC_DECORATION, GoodsInfo);
            false -> OverallRating = 0
        end,
        SumRating + OverallRating
    end,
    lists:foldl(F, 0, EquipList). 

%% 解锁新部位
unlock_cell(PlayerId, UnlockCellList, Dict) ->
    %% 检测一下身上的总阶数是否到达解锁阶数
    TotalStage = get_total_stage(Dict),
    unlock_cell_help(PlayerId, UnlockCellList, TotalStage, []).

%% UnlockCellList:记录当前已解锁的部位列表
%% UnlockCells:记录操作之后会解锁部位列表，用于记录日志
unlock_cell_help(PlayerId, UnlockCellList, TotalStage, UnlockCells) -> 
    NextUnlockCell = get_next_unlock_cell(UnlockCellList),
    case data_decoration:get_unlock_stage(NextUnlockCell) of 
        UnLockStage when is_integer(UnLockStage) ->
            case TotalStage >= UnLockStage of 
                true -> %% 可以解锁当前部位
                    %% 解锁新部位
                    NewUnlockCellList = [NextUnlockCell | UnlockCellList],
                    NewUnlockCells = [NextUnlockCell | UnlockCells],
                    if
                        NextUnlockCell + 1 > ?TOTAL_CELL_NUM -> %% 解锁完了
                            db_unlock_cell_replace(PlayerId, util:term_to_string(NewUnlockCellList)),
                            lib_log_api:log_dec_unlock_cell(PlayerId, util:term_to_string(NewUnlockCells)),
                            NewUnlockCellList;
                        true ->
                            unlock_cell_help(PlayerId, NewUnlockCellList, TotalStage, NewUnlockCells)
                    end;
                false ->
                    if
                        UnlockCells =/= [] -> %% UnlockCells不为空则要写库
                            db_unlock_cell_replace(PlayerId, util:term_to_string(UnlockCellList)),
                            lib_log_api:log_dec_unlock_cell(PlayerId, util:term_to_string(UnlockCells));
                        true ->
                            skip
                    end,
                    UnlockCellList
            end;
        _ ->
            UnlockCellList
    end.

%% 获取当前身上装备的总阶数
get_total_stage(Dict) ->
    DecEquipList = lib_goods_util:get_equip_list(0, ?GOODS_TYPE_DECORATION, ?GOODS_LOC_DECORATION, Dict),
    F = fun(DecEqeuip, FunTotalStage) ->
        case data_decoration:get_dec_attr(DecEqeuip#goods.goods_id) of
            #dec_attr_cfg{stage = Stage} ->
                FunTotalStage + Stage;
            _ ->
                FunTotalStage
        end
    end,
    lists:foldl(F, 0, DecEquipList).

%% 获取下一个激活的部位
get_next_unlock_cell(UnlockCellList) ->
    lists:max(UnlockCellList) + 1.

%% ---------------------------------- 秘籍 -----------------------------------
gm_reset_stren(Ps) ->
    #player_status{id = RoleId, decoration = Decoration} = Ps,
    Sql = io_lib:format(<<"delete from decoration_level where player_id = ~p">>, [RoleId]),
    db:execute(Sql),
    NewDecoration = Decoration#decoration{level_list = []},
    NewPS = Ps#player_status{decoration = NewDecoration},
    LastPS = count_decoration_attr(NewPS),
    CellList = [1,2,3,4,5,6],
    [pp_decoration:handle(14904, LastPS, [Cell]) || Cell <- CellList],
    LastPS.

%% ---------------------------------- db函数 -----------------------------------

%% ---------------------------------- decoration_level 表操作 -----------------------------------
db_level_select(RoleId) ->
    Sql = io_lib:format(?SELET_DECORATION_LEVEL_LIST, [RoleId]),
    db:get_all(Sql).


db_level_replace(PlayerId, Pos, Level) ->
    Sql = io_lib:format(?REPLACE_DECORATION_LEVEL, [PlayerId, Pos, Level]),
    db:execute(Sql).

%% ---------------------------------- decoration_unlock_cell 表操作 -----------------------------------
db_unlock_cell_select(RoleId) ->
    Sql = io_lib:format(?SELECT_DECORATION_UNLOCK_CELL, [RoleId]),
    db:get_all(Sql).

db_unlock_cell_replace(PlayerId, UnlockCellList) ->
    Sql = io_lib:format(?REPLACE_DECORATION_UNLOCK_CELL, [PlayerId, UnlockCellList]),
    db:execute(Sql).


