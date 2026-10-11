%%%--------------------------------------
%%% @Module  : lib_fashion
%%% @Author  : huyihao
%%% @Created : 2017.10.26
%%% @Description:  时装
%%%--------------------------------------

-module (lib_fashion).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("fashion.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("rec_offline.hrl").
-include("common_rank.hrl").

-export([
    fashion_login/1,                        %% 登陆初始化时装
    get_equip_fashion_list_ps/1,    %% 获取玩家穿戴时装列表(玩家进程) {装备部位, 模型id, 颜色id}
    get_equip_fashion_list/3,       %% 获取玩家穿戴时装列表db {装备部位, 模型id, 颜色id}
    count_fashion_attr/1,             %% 计算时装属性加成
    sql_fashion/2,
    fashion_add_upgrade_num/3,
    check_fashion_goods/1,
    get_fashion_combat_power/1,
    get_fashion_active_num/1,
    get_rand_fashion_model_list/2,
    active_fashion/5,
    active_fashion_all/1,
    star_up_fashion/6,
    upgrade_fashion_pos/4,
    sql_fashion_info/3,
    sql_fashion_base/2,
    unequip_fashion_weapon/1,
    count_fashion_power/3
    , get_real_power/3
    , calc_real_power/4
]).

fashion_login(RoleId) ->
    FashionPosIdList = data_fashion:get_pos_id_list(),
    ReSql = io_lib:format(?SelectFashionPosSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            FashionPosList = [#fashion_pos{pos_id = PosId} ||PosId <- FashionPosIdList];
        PosSqlList ->
            ReSql1 = io_lib:format(?SelectFashionInfoSql, [RoleId]),
            AllFashionSqlList = db:get_all(ReSql1),
            PosSqlTupleList = [list_to_tuple(Info)||Info <- PosSqlList],
            FashionPosList = [begin
                case lists:keyfind(PosId, 2, PosSqlTupleList) of
                    false ->
                        FashionPos1 = #fashion_pos{pos_id = PosId};
                    {_RoleId, _PosId, PosLv, PosUpgradeNum, WearFashionId, WearColorId} ->
                        case AllFashionSqlList of
                            [] ->
                                FashionInfoList = [];
                            _ ->
                                F = fun(Info1, FashionInfoList1) ->
                                    [_RoleId, PosId1, FashionId, ColorId, SColorList, FashionStarLv] = Info1,
                                    case PosId1 of
                                        PosId ->
                                            TemColorList = util:bitstring_to_term(SColorList),
                                            case TemColorList of
                                                [ColorId] -> ColorList = [{ColorId, FashionStarLv}];    % 兼容以前的旧数据
                                                _ -> ColorList = TemColorList
                                            end,
                                            FashionInfo = #fashion_info{
                                                pos_id = PosId,
                                                fashion_id = FashionId,
                                                color_id = ColorId,
                                                color_list = ColorList,
                                                fashion_star_lv = FashionStarLv
                                            },
                                            [FashionInfo|FashionInfoList1];
                                        _ ->
                                            FashionInfoList1
                                    end
                                end,
                                FashionInfoList = lists:foldl(F, [], AllFashionSqlList)
                        end,
                        FashionPos1 = #fashion_pos{
                            pos_id = PosId,
                            pos_lv = PosLv,
                            pos_upgrade_num = PosUpgradeNum,
                            wear_fashion_id = WearFashionId,
                            wear_color_id = WearColorId,
                            fashion_list = FashionInfoList
                        }
                end,
                FashionPos1
            end||PosId <- FashionPosIdList]
    end,
    FashionSuitList = lib_fashion_suit:login_fashion_suit(RoleId),
    #fashion{
        position_list = FashionPosList,
        suit_list = FashionSuitList
    }.

%% 获取穿戴时装列表(玩家进程)
get_equip_fashion_list_ps(PS) ->
    #player_status{figure = #figure{career = Career,sex = Sex}} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    F = fun(FashionPos, FashionModelList1) ->
        #fashion_pos{pos_id = PosId, wear_fashion_id = WearFashionId, wear_color_id = WearColorId} = FashionPos,
        FashionModelCon = data_fashion:get_fashion_model_con(PosId, WearFashionId, Career, Sex, 0),
        case FashionModelCon of
            [] ->
                FashionModelList1;
            _ ->
                #fashion_model_con{model_id = ModelId} = FashionModelCon,
                [{PosId, ModelId, WearColorId}|FashionModelList1]
        end
    end,
    FashionModelList = lists:foldl(F, [], PositionList),
    FashionModelList.

unequip_fashion_weapon(PS) ->
    PosId = 2,
    #player_status{
        id = RoleId,
        sid = Sid,
        scene = SceneId,
        scene_pool_id = SPId,
        copy_id = CopyId,
        x = X,
        y = Y,
        figure = Figure
    } = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        fashion = Fashion
    } = GS,
    #fashion{
        position_list = PositionList
    } = Fashion,
    case lists:keyfind(PosId, #fashion_pos.pos_id, PositionList) of
        false -> PS;
        #fashion_pos{
            wear_fashion_id = WearFashionId,
            fashion_list = FashionList
        } = FashionPos when WearFashionId>0 ->
            case lists:keyfind(WearFashionId, #fashion_info.fashion_id, FashionList) of
                false ->
                    PS;
                _ ->
                    NewFashionPos = FashionPos#fashion_pos{
                        wear_fashion_id = 0,
                        wear_color_id = 0
                    },
                    lib_fashion:sql_fashion_base(NewFashionPos, RoleId),
                    NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
                    NewFashion = Fashion#fashion{
                        position_list = NewPositionList
                    },
                    NewGS = GS#goods_status{
                        fashion = NewFashion
                    },
                    lib_goods_do:set_goods_status(NewGS),
                    NewFashionModelList = lib_fashion:get_equip_fashion_list_ps(PS),
                    NewFigure = Figure#figure{
                        fashion_model = NewFashionModelList
                    },
                    NewPS = PS#player_status{
                        figure = NewFigure
                    },
                    %% 更新场景玩家时装
                    mod_scene_agent:update(NewPS, [{fashion_model, NewFashionModelList}]),
                    {ok, BinData} = pt_413:write(41311, [RoleId, NewFashionModelList]),
                    lib_server_send:send_to_area_scene(SceneId, SPId, CopyId,  X, Y, BinData),
                    {ok, Bin} = pt_413:write(41303, [1, PosId, WearFashionId]),
                    lib_server_send:send_to_sid(Sid, Bin),
                    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
                    lib_team_api:update_team_mb(NewPS, [{figure, NewFigure}]),
                    case NewFigure#figure.guild_id > 0 of
                        true -> mod_guild:update_guild_member_attr(RoleId, [{figure, NewFigure}]);
                        false -> skip
                    end,
                    NewPS
            end;
        _ ->
            PS
    end.


get_rand_fashion_model_list(Career, Sex) ->
    PosIdList = data_fashion:get_pos_id_list(),
    PosNum = urand:rand(0, length(PosIdList)),
    UsePosIdList = urand:get_rand_list(PosNum, PosIdList),
    get_rand_fashion_model_list_1(UsePosIdList, Career, Sex, []).

get_rand_fashion_model_list_1([T|G], Career, Sex, FashionModelList) ->
    FashionList = data_fashion:get_fashion_model_list(T, Career, Sex),
    FashionId = urand:list_rand(FashionList),
    FashionModelCon = data_fashion:get_fashion_model_con(T, FashionId, Career, Sex, 0),
    #fashion_model_con{
        model_id = ModelId
    } = FashionModelCon,
    ColorList = data_fashion:get_fashion_color_list(),
    ColorId = urand:list_rand(ColorList),
    NewFashionModelList = [{T, ModelId, ColorId}|FashionModelList],
    get_rand_fashion_model_list_1(G, Career, Sex, NewFashionModelList);
get_rand_fashion_model_list_1([], _Career, _Sex, FashionModelList) ->
    FashionModelList.

%% 获取玩家穿戴时装列表db
get_equip_fashion_list(RoleId, Career, Sex) ->
    ReSql = io_lib:format(?SelectFashionPosSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            FashionModelList = [];
        PosSqlList ->
            F = fun(Info, FashionModelList1) ->
                [_RoleId, PosId, _PosLv, _PosUpgradeNum, WearFashionId, WearColorId] = Info,
                FashionModelCon = data_fashion:get_fashion_model_con(PosId, WearFashionId, Career, Sex, WearColorId),
                case FashionModelCon of
                    [] ->
                        FashionModelList1;
                    _ ->
                        #fashion_model_con{model_id = ModelId} = FashionModelCon,
                        [{PosId, ModelId, WearColorId}|FashionModelList1]
                end
            end,
            FashionModelList = lists:foldl(F, [], PosSqlList)
    end,
    FashionModelList.

%% 计算时装带来的属性加成
count_fashion_attr(Fashion) ->
    #fashion{
        position_list = PositionList
    } = Fashion,
    % 汇总不同部位的属性
    F = fun(FashionPos, List) ->
        #fashion_pos{
            pos_id = PosId,
            pos_lv = PosLv,
            fashion_list = FashionList
        } = FashionPos,
        PosCon = data_fashion:get_fashion_pos_con(PosId, PosLv),
        case PosCon of
            [] ->
                List;
            _ ->
                #fashion_pos_con{attr_add_list = AttrAddList} = PosCon,
                % 汇总同一个部位不同时装的属性
                F1 = fun(FashionInfo, List1) ->
                    #fashion_info{fashion_id = FashionId, color_list = ColorList} = FashionInfo,
                    % 汇总同一件时装不同颜色的属性
                    F2 = fun({ColorId, StarLv}, ColorAttrL) ->
                        case ColorId of
                            0 ->
                                TFashionColorCon = data_fashion:get_fashion_con(PosId, FashionId, StarLv),
                                FashionColorCon = ?IF(TFashionColorCon == [], #fashion_con{}, TFashionColorCon),
                                AttrList = FashionColorCon#fashion_con.attr_list;
                            _ ->
                                TFashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, StarLv),
                                FashionColorCon = ?IF(TFashionColorCon == [], #fashion_color_con{}, TFashionColorCon),
                                AttrList = FashionColorCon#fashion_color_con.attr_list
                        end,
                        ulists:kv_list_plus_extra([ColorAttrL, AttrList])
                    end,
                    ColorAttrList = lists:foldl(F2, [], ColorList),
                    ulists:kv_list_plus_extra([List1, ColorAttrList])
                end,
                PosAttrList1 = lists:foldl(F1, [], FashionList),
                PosAttrList = [begin
                    case lists:keyfind(AttrId, 1, AttrAddList) of
                        false ->
                            {AttrId, AttrNum};
                        {_AttrId, AddPercent} ->
                            {AttrId, round(AttrNum*(1+AddPercent/100))}
                    end
                end||{AttrId, AttrNum} <- PosAttrList1],
                ulists:kv_list_plus_extra([List, PosAttrList])
        end
    end,
    TotalAttr = lists:foldl(F, [], PositionList),
    TotalAttr.

%% 时装sql
sql_fashion(FashionPos, RoleId) ->
    #fashion_pos{
        pos_id = PosId,
        pos_lv = PosLv,
        pos_upgrade_num = PosUpgradeNum,
        wear_fashion_id = WearFashionId,
        wear_color_id = WearColorId,
        fashion_list = FashionList
    } = FashionPos,
    % 更新装在穿的时装信息
    ReSql1 = io_lib:format(?ReplaceFashionPosSql, [RoleId, PosId, PosLv, PosUpgradeNum, WearFashionId, WearColorId]),
    db:execute(ReSql1),
    F = fun(FashionInfo, SqlStrList1) ->
        #fashion_info{
            fashion_id = FahsionId,
            color_id = ColorId,
            color_list = ColorList,
            fashion_star_lv = FashionStarLv
        } = FashionInfo, 
        SColorList = util:term_to_string(ColorList),
        SqlStr = io_lib:format("(~p, ~p, ~p, ~p, '~s', ~p)", [RoleId, PosId, FahsionId, ColorId, SColorList, FashionStarLv]),
        [SqlStr|SqlStrList1]
    end,
    SqlStrList = lists:foldl(F, [], FashionList),
    case SqlStrList of
        [] ->
            skip;
        _ ->
            SqlUseList = ulists:list_to_string(SqlStrList, ","),
            % 更新时装收集列表信息
            ReSql = io_lib:format(?ReplaceFahsionInfoAllSql, [SqlUseList]),
            db:execute(ReSql)
    end.

%% 时装sql
sql_fashion_info(FashionInfo, RoleId, PosId) ->
    #fashion_info{
        fashion_id = FahsionId,
        color_id = ColorId,
        color_list = ColorList,
        fashion_star_lv = FashionStarLv
    } = FashionInfo, 
    SColorList = util:term_to_string(ColorList),
    SqlStr = io_lib:format(?ReplaceFahsionInfoSql, [RoleId, PosId, FahsionId, ColorId, SColorList, FashionStarLv]),
    db:execute(SqlStr).

%% 时装sql
sql_fashion_base(FashionPos, RoleId) ->
    #fashion_pos{
        pos_id = PosId,
        pos_lv = PosLv,
        pos_upgrade_num = PosUpgradeNum,
        wear_fashion_id = WearFashionId,
        wear_color_id = WearColorId
    } = FashionPos,
    ReSql = io_lib:format(?ReplaceFashionPosSql, [RoleId, PosId, PosLv, PosUpgradeNum, WearFashionId, WearColorId]),
    db:execute(ReSql).

fashion_add_upgrade_num(_PosId, _Num, GS) -> GS.
    % #goods_status{
    %     player_id = RoleId,
    %     fashion = Fashion
    % } = GS,
    % #fashion{
    %     position_list = PositionList
    % } = Fashion,
    % case lists:keyfind(PosId, #fashion_pos.pos_id, PositionList) of
    %     false ->
    %         NewGS = GS;
    %     FashionPos ->
    %        #fashion_pos{
    %             pos_upgrade_num = PosUpgradeNum
    %         } = FashionPos,
    %         NewPosUpgradeNum = PosUpgradeNum + Num,
    %         NewFashionPos = FashionPos#fashion_pos{
    %             pos_upgrade_num = NewPosUpgradeNum
    %         },
    %         lib_fashion:sql_fashion(NewFashionPos, RoleId),
    %         NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
    %         NewFashion = Fashion#fashion{
    %             position_list = NewPositionList
    %         },
    %         NewGS = GS#goods_status{
    %             fashion = NewFashion
    %         },
    %         {ok, Bin} = pt_413:write(41307, [PosId, NewPosUpgradeNum]),
    %         lib_server_send:send_to_uid(RoleId, Bin)
    % end,
    % NewGS.

check_fashion_goods(GoodsInfo) ->
    #goods{
        goods_id = GoodsTypeId,
        subtype = PosId
    } = GoodsInfo,
    case data_fashion:get_pos_fashion_list(PosId) of
        [] ->
            {fail, ?ERRCODE(err_config)};
        FashionIdList ->
            case get_fashion_id(FashionIdList, PosId, GoodsTypeId) of
                false ->
                    {fail, ?ERRCODE(err_config)};
                FashionId ->
                    GS = lib_goods_do:get_goods_status(),
                    #goods_status{
                        fashion = Fashion
                    } = GS,
                    #fashion{
                        position_list = PositionList
                    } = Fashion,
                    case lists:keyfind(PosId, #fashion_pos.pos_id, PositionList) of
                        false ->
                            {fail, ?ERRCODE(err413_fashion_not_pos)};
                        FashionPos ->
                            #fashion_pos{
                                pos_lv = PosLv,
                                fashion_list = FashionList
                            } = FashionPos,
                            NewPosLv = PosLv + 1,
                            case data_fashion:get_fashion_pos_con(PosId, NewPosLv) of
                                [] ->
                                    {fail, ?ERRCODE(err413_fashion_max_lv)};
                                _ ->
                                    case lists:keyfind(FashionId, #fashion_info.fashion_id, FashionList) of
                                        false ->
                                            {fail, ?ERRCODE(err413_fashion_not_fashion)};
                                        FashionInfo ->
                                            #fashion_info{
                                                fashion_star_lv = FashionStarlv
                                            } = FashionInfo,
                                            NewFashionStarlv = FashionStarlv + 1,
                                            case data_fashion:get_fashion_con(PosId, FashionId, NewFashionStarlv) of
                                                [] ->
                                                    true;
                                                _ ->
                                                    {fail, ?ERRCODE(err413_fashion_not_max_star)}
                                            end
                                    end
                            end
                    end
            end
    end.

get_fashion_id([T|G], PosId, GoodsTypeId) ->
    FashionCon = data_fashion:get_fashion_con(PosId, T, 1),
    #fashion_con{
        active_cost = ActiveCost
    } = FashionCon,
    case lists:keyfind(GoodsTypeId, 2, ActiveCost) of
        false ->
            get_fashion_id(G, PosId, GoodsTypeId);
        _ ->
            T
    end;
get_fashion_id([], _PosId, _GoodsTypeId) ->
    false.

get_fashion_combat_power(PS) ->
    #player_status{
        goods = StatusGoods
    } = PS,
    #status_goods{
        fashion_attr = FashionAttrList
    } = StatusGoods,
    case FashionAttrList of
        [] ->
            0;
        _ ->
            FashionAttr = lib_player_attr:to_attr_record(FashionAttrList),
            FashionCombatPower = lib_player:calc_all_power(FashionAttr),
            FashionCombatPower
    end.

get_fashion_active_num(PS) ->
    #player_status{
        pid = Pid,
        off = Off
    } = PS,
    case misc:is_process_alive(Pid) of
        true ->
            GS = lib_goods_do:get_goods_status();
        false ->
            #status_off{
                goods_status = GS
            } = Off
    end,
    #goods_status{
        fashion = Fashion
    } = GS,
    #fashion{
        position_list = PositionList
    } = Fashion,
    F = fun(PositionInfo, ActiveNum1) ->
        #fashion_pos{
            fashion_list = FashionList
        } = PositionInfo,
        AddNum = length(FashionList),
        ActiveNum1 + AddNum
    end,
    ActiveNum = lists:foldl(F, 0, PositionList),
    ActiveNum.

%% 41304
%% 激活时装（颜色id为0，激活其它颜色走41301）
active_fashion(FashionCon, PS, PosId, FashionId, FashionPos) ->
    #player_status{id = RoleId, goods = StatusGoods} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    #fashion_con{active_cost = ActiveCost} = FashionCon,
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    GoodsTypeList = ulists:object_list_plus([ActiveCost]),
    GoodsTypeIds = [GoodsTypeId || {_, GoodsTypeId, _} <- GoodsTypeList],
    NewGoodsTypeList = [{GoodsTypeId, Num} || {_, GoodsTypeId, Num} <- GoodsTypeList],
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GS, [{gid_in, GoodsTypeIds}]),
    case lib_goods_check:check_delete_type_list(GS, NewGoodsTypeList) of
        {fail} -> 
            {?ERRCODE(goods_not_enough), PS};
        {ok} ->
            Fun = fun() ->
                ok = lib_goods_dict:start_dict(),
                %% 扣除物品
                F = fun lib_goods:delete_type_list_goods/2,
                case lib_goods_check:list_handle(F, GoodsStatusBfTrans, GoodsTypeList) of
                    {ok, NewStatus} ->
                        #fashion_info{color_list = ColorList} =
                            FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{fashion_star_lv = 1}),

                        %% FashionModelCon = data_fashion:get_fashion_model_con(PosId, FashionId, Career, Sex, 0),
                        % ColorId = FashionModelCon#fashion_model_con.color_id,
                        NewFashionInfo = FashionInfo#fashion_info{
                            pos_id = PosId,
                            fashion_id = FashionId,
                            color_list = [{0, 1} | ColorList]  % 初始颜色0-星数/阶数1
                        },
                        NewFashionList = [NewFashionInfo|FashionList],
                        NewFashionPos = FashionPos#fashion_pos{  wear_color_id = 0, fashion_list = NewFashionList},
                        %% 更新时装数据
                        lib_fashion:sql_fashion(NewFashionPos, RoleId),
                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                        NewStatus2 = NewStatus#goods_status{dict = Dict},
                        {ok, NewStatus2, GoodsL, NewFashionPos};
                    _ ->
                        {error, ?ERRCODE(goods_not_enough)}
                end
            end,
            case lib_goods_util:transaction(Fun) of
                {ok, NewGS, NewGoodsL, NewFashionPos2} ->
                    % 更新内存时装数据
                    NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos2),
                    NewFashion = Fashion#fashion{position_list = NewPositionList},
                    NewGS2 = NewGS#goods_status{fashion = NewFashion},
                    LastGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewGS2, GoodsStatusBfTrans, GS),
                    lib_goods_do:set_goods_status(LastGoodsStatus),
                    % 通知客户端变更物品信息
                    lib_goods_api:notify_client_num(RoleId, NewGoodsL),
                    % 触发成就
                    trigger_achv(active_fashion, [RoleId, erlang:length(NewFashionPos2#fashion_pos.fashion_list)]),
                    % 计算属性战力
                    LastPS = count_fashion_power(NewFashion, StatusGoods, PS),
                    % 记录日志
                    Fun2 = fun({GoodsTypeId, DeleteNum}) ->
                        lib_log_api:log_throw(fashion_active, RoleId, 0, GoodsTypeId, DeleteNum, 0, 0)
                    end,
                    [Fun2(OneDel) || OneDel <- NewGoodsTypeList],
                    lib_log_api:log_fashion_star(RoleId, PosId, FashionId, 1, 0, 1, ActiveCost),
                    {ok, NewPS} = lib_fashion_event:event(activate, [LastPS, PosId]),   % 更新场景玩家时装
                    lib_fashion_suit:update_conform_num(NewPS, ?SUIT_POST_FASHION, PosId, FashionId),
                    {?SUCCESS, NewPS};
                {error, Code} ->
                    {Code, PS}
            end
    end.

%% 41306
%% 升星时装
star_up_fashion(PosId, FashionId, ColorId, NewFashionStarlv, PS, FashionPos) ->
    #player_status{id = RoleId, goods = StatusGoods} = PS,
    #fashion_pos{fashion_list = FashionList} = FashionPos,
    FashionInfo = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
    #fashion_info{color_list = ColorList} = FashionInfo,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case ColorId of
        0 ->
            FashionCon = data_fashion:get_fashion_con(PosId, FashionId, NewFashionStarlv),
            #fashion_con{star_cost = StarCost} = FashionCon;
        _ ->
            FashionCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, NewFashionStarlv),
            #fashion_color_con{star_cost = StarCost} = FashionCon
    end,
    GoodsTypeList = ulists:object_list_plus([StarCost]),
    GoodsTypeIds = [GoodsTypeId || {_, GoodsTypeId, _} <- GoodsTypeList],
    NewGoodsTypeList = [{GoodsTypeId, Num} || {_, GoodsTypeId, Num} <- GoodsTypeList],
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GS, [{gid_in, GoodsTypeIds}]),
    case lib_goods_check:check_delete_type_list(GS, NewGoodsTypeList) of
        {fail} -> 
            {?ERRCODE(goods_not_enough), PS};
        {ok} ->
            Fun = fun() ->
                ok = lib_goods_dict:start_dict(),
                %% 扣除物品
                F = fun lib_goods:delete_type_list_goods/2,
                case lib_goods_check:list_handle(F, GoodsStatusBfTrans, GoodsTypeList) of
                    {ok, NewStatus} ->
                        NewColorList = lists:keyreplace(ColorId, 1, ColorList, {ColorId, NewFashionStarlv}),
                        NewFashionInfo = FashionInfo#fashion_info{fashion_star_lv = NewFashionStarlv, color_list = NewColorList},
                        lib_fashion:sql_fashion_info(NewFashionInfo, RoleId, PosId),
                        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
                        NewStatus2 = NewStatus#goods_status{dict = Dict},
                        {ok, NewStatus2, GoodsL, NewFashionInfo};
                    _ ->
                        {error, ?ERRCODE(goods_not_enough)}
                end
            end,
            case lib_goods_util:transaction(Fun) of
                {ok, NewGS, NewGoodsL, NewFashionInfo2} ->
                    %% 更新内存数据
                    NewFashionList = lists:keyreplace(FashionId, #fashion_info.fashion_id, FashionList, NewFashionInfo2),
                    % TemFashionList = lists:delete(FashionInfo, FashionList),
                    % NewFashionList = [TemFashionList|NewFashionInfo2],
                    NewFashionPos = FashionPos#fashion_pos{fashion_list = NewFashionList},
                    NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
                    NewFashion = Fashion#fashion{position_list = NewPositionList},
                    NewGS2 = NewGS#goods_status{fashion = NewFashion},
                    LastGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewGS2, GoodsStatusBfTrans, GS),
                    lib_goods_do:set_goods_status(LastGoodsStatus),
                    %% 通知客户端
                    lib_goods_api:notify_client_num(RoleId, NewGoodsL),
                    %% 触发成就
                    trigger_achv(star_up_fashion, [RoleId, NewFashionList]),
                    %% 计算属性战力
                    LastPS = count_fashion_power(NewFashion, StatusGoods, PS),
                    %% 记录日志
                    Fun3 = fun({GoodsTypeId, DeleteNum}) ->
                        lib_log_api:log_throw(fashion_star, RoleId, 0, GoodsTypeId, DeleteNum, 0, 0)
                    end,
                    [Fun3(OneDel) || OneDel <- NewGoodsTypeList],
                    lib_log_api:log_fashion_star(RoleId, PosId, FashionId, 2, NewFashionStarlv - 1, NewFashionStarlv, StarCost),
                    {?SUCCESS, LastPS};
                {error, Code} ->
                    {Code, PS}
            end
    end.


%% 触发成就
trigger_achv(active_fashion, [RoleId, PosFashionNum]) -> %% 时装激活
    lib_achievement_api:async_event(RoleId, lib_achievement_api, fasion_active_event, PosFashionNum);
trigger_achv(star_up_fashion, [RoleId, NewFashionList]) ->  %% 时装升星
    Fun2 = fun(#fashion_info{fashion_star_lv = TemLv}, Acc) ->
        case lists:keyfind(TemLv, 1, Acc) of
            {TemLv, Num} ->lists:keystore(TemLv,1,Acc,{TemLv, Num+1});
            _ ->lists:keystore(TemLv,1,Acc,{TemLv, 1})
        end
    end,
    AchivList = lists:foldl(Fun2, [], NewFashionList),
    lib_achievement_api:async_event(RoleId, lib_achievement_api, fasion_star_event, AchivList);
trigger_achv(_, _) ->  
    skip.

%% 计算属性战力
count_fashion_power(NewFashion, StatusGoods, PS) ->
    FashionAttr = lib_fashion:count_fashion_attr(NewFashion),
    NewStatusGoods = StatusGoods#status_goods{
        fashion_attr = FashionAttr
    },
    NewPS = PS#player_status{goods = NewStatusGoods},
    lib_fashion_suit:event_update_attr(NewPS),
    LastPS = lib_player:count_player_attribute(NewPS),
    lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
    %% 更新场景玩家属性
    mod_scene_agent:update(LastPS, [{battle_attr, LastPS#player_status.battle_attr}]),
    LastPS.


active_fashion_all(PS) ->
    #player_status{id = RoleId, goods = StatusGoods, figure = Figure} = PS,
    #figure{career = Career, sex = Sex} = Figure,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    F = fun(PosInfo, NewPositionList1) ->
        #fashion_pos{pos_id = PosId, fashion_list = FashionList} = PosInfo,
        FashionIdList = data_fashion:get_pos_fashion_list(PosId),
        F1 = fun(FashionId, NewFashionList1) ->
            case lists:keyfind(FashionId, #fashion_info.fashion_id, NewFashionList1) of
                false ->
                    FashionModelCon = data_fashion:get_fashion_model_con(PosId, FashionId, Career, Sex, 0),
                    ColorId = FashionModelCon#fashion_model_con.color_id,
                    TColorList = data_fashion:get_fashion_color_list(),
                    F2 = fun(Color, LastColorList) ->
                        case lists:keyfind(Color, 1, LastColorList) of
                            false -> [LastColorList|{Color, 1}];
                            _ -> LastColorList
                        end
                    end,
                    ColorList = lists:foldl(F2, [{0, 1}], TColorList),
                    NewFashionInfo = #fashion_info{
                        pos_id = PosId,
                        fashion_id = FashionId,
                        color_id = ColorId,
                        color_list = ColorList
                    },
                    {ok, Bin} = pt_413:write(41304, [?SUCCESS, PosId, FashionId]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    [NewFashionInfo|NewFashionList1];
                _ ->
                    NewFashionList1
            end
        end,
        NewFashionList = lists:foldl(F1, FashionList, FashionIdList),
        NewPosInfo = PosInfo#fashion_pos{
            fashion_list = NewFashionList
        },
        lib_fashion:sql_fashion(NewPosInfo, RoleId),
        [NewPosInfo|NewPositionList1]
    end,
    NewPositionList = lists:foldl(F, [], PositionList),
    NewFashion = Fashion#fashion{
        position_list = NewPositionList
    },
    NewGS = GS#goods_status{
        fashion = NewFashion
    },
    lib_goods_do:set_goods_status(NewGS),
    FashionAttr = lib_fashion:count_fashion_attr(NewFashion),
    NewStatusGoods = StatusGoods#status_goods{
        fashion_attr = FashionAttr
    },
    NewPS1 = PS#player_status{
        goods = NewStatusGoods
    },
    NewPS = lib_player:count_player_attribute(NewPS1),
    lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),
    % lib_common_rank_api:refresh_common_rank(NewPS, ?RANK_TYPE_FASHION),
    NewPS.

%% 41305
%% 位置升级
upgrade_fashion_pos(PS, GS, PosId, GoodsNumList) ->
    #player_status{id = RoleId} = PS,
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lists:keyfind(PosId, #fashion_pos.pos_id, PositionList) of
        false -> {fail, ?ERRCODE(err413_fashion_not_pos)};
        FashionPos ->
            #fashion_pos{pos_lv = PosLv, pos_upgrade_num = PosUpgradeNum} = FashionPos,
            case check_goods_base(PS, GS, PosId, GoodsNumList, []) of 
                {true, GoodsInfoList} ->
                    ExpAdd = get_upgrade_exp(PS, PosId, GoodsInfoList),
                    {NewPosLv, NewPosUpgradeNum} = calc_upgrade_lv(PosId, PosLv, PosUpgradeNum, ExpAdd),
                    case data_fashion:get_fashion_pos_con(PosId, NewPosLv) of 
                        [] ->{fail, ?ERRCODE(err413_fashion_max_lv)};
                        #fashion_pos_con{cost = 0} when NewPosLv == PosLv ->{fail, ?ERRCODE(err413_fashion_max_lv)};
                        _ ->
                            NewFashionPos = FashionPos#fashion_pos{pos_lv = NewPosLv, pos_upgrade_num = NewPosUpgradeNum},
                            GoodsTypeIds = [GoodsTypeId || {GoodsTypeId, _} <- GoodsNumList],
                            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GS, [{id_in, GoodsTypeIds}]),
                            F = fun() -> 
                                ok = lib_goods_dict:start_dict(),
                                {ok, GS1} = lib_goods:delete_goods_list(GoodsStatusBfTrans, GoodsInfoList),
                                sql_fashion_base(NewFashionPos, RoleId),
                                {NewDict, UpdateGoodsList} = lib_goods_dict:handle_dict_and_notify(GS1#goods_status.dict),
                                {ok, GS1#goods_status{dict = NewDict}, UpdateGoodsList}
                            end,
                            case lib_goods_util:transaction(F) of 
                                {ok, NewGS, UpdateGoodsList} ->
                                    %% 更新内存
                                    #fashion{position_list = PositionList} = Fashion,
                                    NewPositionList = lists:keystore(NewFashionPos#fashion_pos.pos_id, #fashion_pos.pos_id, PositionList, NewFashionPos),
                                    NewFashion = Fashion#fashion{position_list = NewPositionList},
                                    NewGS2 = NewGS#goods_status{fashion = NewFashion},
                                    LastGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewGS2, GoodsStatusBfTrans, GS),
                                    lib_goods_do:set_goods_status(LastGoodsStatus),
                                    %% 通知客户端
                                    lib_goods_api:notify_client_num(RoleId, UpdateGoodsList),
                                    %% 记录日志
                                    [
                                        lib_log_api:log_throw(upgrade_fashion_pos, RoleId, GoodsInfo#goods.id, GoodsInfo#goods.goods_id, Num, 0, 0)
                                        || {GoodsInfo, Num} <- GoodsInfoList
                                    ],
                                    CostList = [ {GoodsTypeId, Num} || {#goods{goods_id = GoodsTypeId}, Num} <- GoodsInfoList],
                                    lib_log_api:log_fashion_upgrade(RoleId, PosId, PosLv, PosUpgradeNum, NewPosLv, NewPosUpgradeNum, CostList),
                                    IsUpgrade = NewPosLv =/= PosLv,
                                    {ok, LastGoodsStatus, NewFashionPos, IsUpgrade};
                                _Err ->
                                    ?ERR("upgrade_fashion_pos err : ~p~n", [_Err]),
                                    {fail, ?FAIL}
                            end
                    end;
                {fail, Res} -> {fail, Res}
            end
    end.


get_upgrade_exp(PS, PosId, GoodsInfoList) ->
    #player_status{figure = Figure} = PS,
    #figure{career = Career, sex = Sex} = Figure,
    F = fun({#goods{goods_id = GoodsTypeId}, Num}, AccExp) ->
        case data_fashion:get_fashion_id(GoodsTypeId) of
            FashionId when is_integer(FashionId) ->
                #fashion_model_con{exp = Exp} = data_fashion:get_fashion_model_con(PosId, FashionId, Career, Sex, 0);
            _ -> Exp = 0

        end,
        AccExp + Exp * Num
    end,
    lists:foldl(F, 0, GoodsInfoList).

calc_upgrade_lv(PosId, PosLv, PosUpgradeNum, ExpAdd) ->
    case data_fashion:get_fashion_pos_con(PosId, PosLv) of
        [] -> {PosLv, PosUpgradeNum + ExpAdd};
        #fashion_pos_con{cost = 0} -> {PosLv, PosUpgradeNum + ExpAdd};
        #fashion_pos_con{cost = CostNum} ->
            case PosUpgradeNum + ExpAdd >= CostNum of 
                true ->     
                    case data_fashion:get_fashion_pos_con(PosId, PosLv+1) of
                        [] -> {PosLv, PosUpgradeNum + ExpAdd};
                        _ ->
                            calc_upgrade_lv(PosId, PosLv+1, 0, PosUpgradeNum + ExpAdd - CostNum)
                    end;
                _ -> {PosLv, PosUpgradeNum + ExpAdd}
            end
    end.

check_goods_base(_PS, _GS, _PosId, [], List) -> {true, List};
check_goods_base(PS, GS, PosId, [{GoodsId, Num}|GoodsNumList], List) ->
    case lib_goods_check:check_goods_normal(GS, GoodsId) of
        {ok, GoodsInfo} ->
            case GoodsInfo#goods.type == ?GOODS_TYPE_FASHION andalso GoodsInfo#goods.subtype == ?GOODS_FASHION_CLOTHES of
                false -> {fail, ?MISSING_CONFIG};
                _ ->
                    case GoodsInfo#goods.num >= Num of 
                        true -> check_goods_base(PS, GS, PosId, GoodsNumList, [{GoodsInfo, Num}|List]);
                        _ -> {fail, ?GOODS_NOT_ENOUGH}
                    end
            end;
        {fail, Res} -> {fail, Res}
    end.

get_real_power(PS, PosId, FashionId) ->
    #player_status{sid = Sid, original_attr = OriginAttr} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    #fashion_pos{fashion_list = FashionList, pos_lv = PosLv} = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    PosCon = data_fashion:get_fashion_pos_con(PosId, PosLv),
    #fashion_pos_con{attr_add_list = AttrAddList} = PosCon,
    #fashion_info{color_list = ColorList} = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
    ColorIds = data_fashion:get_fashion_color_list(),
    ColorListN =
        lists:foldl(fun(Id, Acc) ->
            case lists:keyfind(Id, 1, Acc) of
                false ->
                    lists:keystore(Id, 1, Acc, {Id, 0});
                _ -> Acc
            end end, ColorList, [0 | ColorIds]),
            % 汇总同一件时装不同颜色的属性
    F2 = fun({ColorId, StarLv}, {ColorAttrL, CPList}) ->
        {RstarLv, RNstarLv} = ?IF(StarLv == 0, {1, 0}, {StarLv, StarLv + 1}),
        case ColorId of
            0 ->
                TFashionColorCon = data_fashion:get_fashion_con(PosId, FashionId, RstarLv),
                FashionColorCon = ?IF(TFashionColorCon == [], #fashion_con{}, TFashionColorCon),
                AttrList = FashionColorCon#fashion_con.attr_list,
                NextTFashionColorCon = data_fashion:get_fashion_con(PosId, FashionId, RNstarLv),
                NextFashionColorCon = ?IF(NextTFashionColorCon == [], #fashion_con{}, NextTFashionColorCon),
                NextAttrList = NextFashionColorCon#fashion_con.attr_list;
            _ ->
                TFashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, RstarLv),
                FashionColorCon = ?IF(TFashionColorCon == [], #fashion_color_con{}, TFashionColorCon),
                AttrList = FashionColorCon#fashion_color_con.attr_list,
                NextTFashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, RNstarLv),
                NextFashionColorCon = ?IF(NextTFashionColorCon == [], #fashion_color_con{}, NextTFashionColorCon),
                NextAttrList = NextFashionColorCon#fashion_color_con.attr_list
        end,
        AddAttrList = calc_add_attr(AttrAddList, AttrList),
        NextAddAttrList = calc_add_attr(AttrAddList, NextAttrList),
        Power1 = lib_player:calc_partial_power(OriginAttr, 0, AddAttrList),
        AddPower = lib_player:calc_expact_power(OriginAttr, 0, lib_player_attr:minus_attr(record, [NextAddAttrList, AddAttrList])),
        {ulists:kv_list_plus_extra([ColorAttrL, AddAttrList]), [{ColorId, Power1, Power1 + AddPower} | CPList]}
    end,
    {_ColorAttrList, ColorPowerList} = lists:foldl(F2, {[], []}, ColorListN),
    {ok, BinData} = pt_413:write(41312, [PosId, FashionId, ColorPowerList]),
    lib_server_send:send_to_sid(Sid, BinData).

calc_add_attr(AttrAddList, AttrList) ->
    FinalAttr =
        [begin
             case lists:keyfind(AttrId, 1, AttrAddList) of
                 false ->
                     {AttrId, AttrNum};
                 {_AttrId, AddPercent} ->
                     {AttrId, round(AttrNum*(1+AddPercent/100))}
             end
         end||{AttrId, AttrNum} <- AttrList],
    FinalAttr.


%% 计算某个时装的战力
calc_real_power(PS, PosId, FashionId, GoodStatus) ->
    #player_status{sid = Sid, original_attr = OriginAttr} = PS,
    #goods_status{fashion = Fashion} = GoodStatus,
    #fashion{position_list = PositionList} = Fashion,
    #fashion_pos{fashion_list = FashionList, pos_lv = PosLv} = ulists:keyfind(PosId, #fashion_pos.pos_id, PositionList, #fashion_pos{}),
    PosCon = data_fashion:get_fashion_pos_con(PosId, PosLv),
    #fashion_pos_con{attr_add_list = AttrAddList} = PosCon,
    #fashion_info{fashion_id = FashionIdA, color_list = ColorList} = ulists:keyfind(FashionId, #fashion_info.fashion_id, FashionList, #fashion_info{}),
    if
        FashionIdA =:= 0 ->
            {PartialOPower, PartialOAttr} = lib_goods_do:get_goods_attr(FashionId),
            Power = lib_player:calc_expact_power(OriginAttr, PartialOPower, PartialOAttr);
        true ->
            % 汇总同一件时装不同颜色的属性
            F2 = fun({ColorId, StarLv}, ColorAttrL) ->
                case ColorId of
                    0 ->
                        TFashionColorCon = data_fashion:get_fashion_con(PosId, FashionId, StarLv),
                        FashionColorCon = ?IF(TFashionColorCon == [], #fashion_con{}, TFashionColorCon),
                        AttrList = FashionColorCon#fashion_con.attr_list;
                    _ ->
                        TFashionColorCon = data_fashion:get_fashion_color_con(PosId, FashionId, ColorId, StarLv),
                        FashionColorCon = ?IF(TFashionColorCon == [], #fashion_color_con{}, TFashionColorCon),
                        AttrList = FashionColorCon#fashion_color_con.attr_list
                end,
                ulists:kv_list_plus_extra([ColorAttrL, AttrList])
                 end,
            ColorAttrList = lists:foldl(F2, [], ColorList),
            PosAttrList = [begin
                               case lists:keyfind(AttrId, 1, AttrAddList) of
                                   false ->
                                       {AttrId, AttrNum};
                                   {_AttrId, AddPercent} ->
                                       {AttrId, round(AttrNum*(1+AddPercent/100))}
                               end
                           end||{AttrId, AttrNum} <- ColorAttrList],
            Power = lib_player:calc_partial_power(OriginAttr, 0, PosAttrList)
    end,
    Power.

% %% 根据时装id和颜色id获取玩家的对应时装信息
% get_fashion_info(FashionId, ColorId, FashionList) ->
%     [FashionInfo] = lists:filter(fun(Info) -> Info#fashion_info.fashion_id == FashionId andalso 
% 												Info#fashion_info.color_id == ColorId end, FashionList),
%     NewFashionInfo = ?IF(FashionInfo == [], #fashion_info{}, FashionInfo),                                
%     NewFashionInfo.                            