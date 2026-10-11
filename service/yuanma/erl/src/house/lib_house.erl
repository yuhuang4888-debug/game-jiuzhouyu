%%%--------------------------------------
%%% @Module  : lib_house
%%% @Author  : huyihao
%%% @Created : 2018.05.17
%%% @Description:  家园
%%%--------------------------------------
-module(lib_house).

-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("attr.hrl").
-include("counter.hrl").
-include("house.hrl").
-include("rec_offline.hrl").

-export([
    house_login/1,
    check_own_house/3,
    count_house_attribute/1,
    check_open_block/1,
    into_house/8,
    init_furniture/5,
    check_buy_house/5,
    sql_house_info/1,
    sql_aa_info/1,
    update_house_info/5,
    update_ps_house_info/5,
    house_fail_return/4,
    get_role_furniture_list/1,
    get_both_final_furniture_list/5,
    get_house_point/1,
    check_upgrade_house/5,
    open_house_list/3,
    marriage_house/3,
    get_return_list/4,
    divorce_house/2,
    marriage_house_success/4,
    divorce_house_side/5,
    init_default_floor/2,
    check_into_house/1,
    reconnect/2,
    get_recommend_house_list/3,
    rhl_player_info/2,
    upgrade_inside_change/3,
    house_send_tv/2,
    handle_event/2,
    divorce_quit/1,
    get_player_house_info_db/1,
    send_gift_fail/2,
    get_gift_log/3,
    house_gift_send_tv/2,
    change_sql_add_server_id/0,
    get_return_list_merge/3
]).

house_login(Ps) ->
    #player_status{
        id = _RoleId,
        pid = _RolePid,
        off = _Off,
        figure = Figure
    } = Ps,
%%    case mod_house:get_home_id_lv(RoleId) of
%%        {HomeId, HouseLv, ChooseHouse} ->
%%            #house_lv_con{
%%                attr_list = HouseAttrList
%%            } = data_house:get_house_lv_con(HouseLv),
%%            case is_pid(RolePid) andalso misc:is_process_alive(RolePid) of
%%                true ->
%%                    GoodsStatus = lib_goods_do:get_goods_status();
%%                false ->
%%                    #status_off{
%%                        goods_status = GoodsStatus
%%                    } = Off
%%            end,
%%            FurnitureWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_FURNITURE, GoodsStatus#goods_status.dict),
%%            FurnitureAttrList = count_house_attribute(FurnitureWearList);
%%        _ ->
%%            HomeId = {0, 0},
%%            HouseLv = 0,
%%            ChooseHouse = {0, 0},
%%            FurnitureAttrList = [],
%%            HouseAttrList = []
%%    end,
    HomeId = {0, 0},
    HouseLv = 0,
    ChooseHouse = {0, 0},
    FurnitureAttrList = [],
    HouseAttrList = [],
    HouseStatus = #house_status{
        home_id = HomeId,
        house_lv = HouseLv,
        choose_house = ChooseHouse,
        furniture_attr = FurnitureAttrList,
        house_attr = HouseAttrList
    },
    NewFigure = Figure#figure{
        home_id = HomeId,
        house_lv = HouseLv
    },
    Ps#player_status{
        house = HouseStatus,
        figure = NewFigure
    }.

check_own_house([T|G], RoleId, OwnHouse) ->
    #house_info{
        role_id_1 = RoleId1,
        role_id_2 = RoleId2,
        lock = Lock
    } = T,
    case Lock of
        0 ->
            case RoleId of
                RoleId1 ->
                    T;
                RoleId2 ->
                    T;
                _ ->
                    check_own_house(G, RoleId, OwnHouse)
            end;
        _ ->
            check_own_house(G, RoleId, OwnHouse)
    end;
check_own_house([], _RoleId, OwnHouse) ->
    OwnHouse.

count_house_attribute(FurnitureWearList) ->
    F = fun(Furniture, TotalAttr1) ->
        #goods{
            goods_id = GoodsTypeId,
            num = GoodsNum
        } = Furniture,
        case data_house:get_house_furniture_con(GoodsTypeId) of
            [] ->
                TotalAttr1;
            #house_furniture_con{attr_list = AttrList1} ->
                AttrList = [{AttrType, AttrNum*GoodsNum}||{AttrType, AttrNum} <- AttrList1],
                [AttrList|TotalAttr1]
        end
    end,
    TotalAttr2 = lists:foldl(F, [], FurnitureWearList),
    ulists:kv_list_plus_extra(TotalAttr2).

check_open_block(HouseList) ->
    F1 = fun(HouseInfo, HouseNumList1)->
        #house_info{
            home_id = {BlockId, _HouseId}
        } = HouseInfo,
        case lists:keyfind(BlockId, 1, HouseNumList1) of
            false ->
                [{BlockId, 1}|HouseNumList1];
            {_, HouseNum} ->
                lists:keyreplace(BlockId, 1, HouseNumList1, {BlockId, HouseNum+1})
        end
    end,
    HouseNumList2 = lists:foldl(F1, [], HouseList),
    BlockIdList = data_house:get_block_id_list(),
    F2 = fun(BlockId, {HouseNumList3, LessHouseNum1}) ->
        BlockHouseIdList = data_house:get_block_house_id_list(BlockId),
        AllNum = length(BlockHouseIdList),
        case lists:keyfind(BlockId, 1, HouseNumList3) of
            false ->
                #house_block_con{
                    open_num = OpenNum
                } = data_house:get_house_block_con(BlockId),
                case LessHouseNum1 =< OpenNum of
                    true ->
                        NewLessHouseNum1 = LessHouseNum1 + AllNum,
                        NewHouseNumList3 = [{BlockId, 0}|HouseNumList3];
                    false ->
                        NewLessHouseNum1 = LessHouseNum1,
                        NewHouseNumList3 = HouseNumList3
                end;
            {_, HouseNum} ->
                NewLessHouseNum1 = LessHouseNum1 + (AllNum-HouseNum),
                NewHouseNumList3 = HouseNumList3
        end,
        {NewHouseNumList3, NewLessHouseNum1}
    end,
    {HouseNumList, _LessHouseNum} = lists:foldl(F2, {HouseNumList2, 0}, BlockIdList),
    HouseNumList.

%% RoleId1 拥有者1的玩家id
%% SceneId 场景id
into_house(Ps, RoleId1, Name1, RoleId2, Name2, SceneId, BlockId, HouseId) ->
    #player_status{
        id = RoleId
    } = Ps,
    case lib_house:check_into_house(Ps) of
        true ->
            Code = ?SUCCESS,
            [X, Y] = lib_scene:get_born_xy(SceneId),
            NewPs = lib_scene:change_scene(Ps, SceneId, 0, RoleId1, X, Y, true, []);
        {false, Code} ->
            NewPs = Ps
    end,
    {ok, Bin} = pt_177:write(17704, [Code, BlockId, HouseId, RoleId1, Name1, RoleId2, Name2]),
    lib_server_send:send_to_uid(RoleId, Bin),
    NewPs.

init_furniture(Ps, RoleId, BlockId, HouseId, Type) ->
    #player_status{
        id = InitRoleId,
        figure = Figure,
        off = Off
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    case lib_player:is_online_global(InitRoleId) of
        false ->
            #status_off{
                goods_status = GoodsStaus
            } = Off;
        true ->
            GoodsStaus = lib_goods_do:get_goods_status()
    end,
    WearFurnitureList = get_role_furniture_list(GoodsStaus),
    Args1 = [BlockId, HouseId, InitRoleId, WearFurnitureList, Name],
    mod_house:init_furniture_success(RoleId, Args1, Type).

check_buy_house(RoleId, BlockId, HouseId, HouseList, AAList) ->
    case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
        false ->
            case lists:keyfind({BlockId, HouseId}, #aa_ask_info.home_id, HouseList) of
                false ->
                    case lists:keyfind(RoleId, #house_info.role_id_1, HouseList) of
                        false ->
                            case lists:keyfind(RoleId, #house_info.role_id_2, HouseList) of
                                false ->
                                    case lists:keyfind(RoleId, #aa_ask_info.ask_role_id, AAList) of
                                        false ->
                                            case lists:keyfind(RoleId, #aa_ask_info.answer_role_id, AAList) of
                                                false ->
                                                    true;
                                                _ ->
                                                    {false, ?ERRCODE(err177_house_be_asked_aa)}
                                            end;
                                        _ ->
                                            {false, ?ERRCODE(err177_house_asking_aa)}
                                    end;
                                _ ->
                                    {false, ?ERRCODE(err177_house_have)}
                            end;
                        _ ->
                            {false, ?ERRCODE(err177_house_have)}
                    end;
                _ ->
                    {false, ?ERRCODE(err177_house_have_order)}
            end;
        _ ->
            {false, ?ERRCODE(err177_house_house_exist)}
    end.

sql_house_info(HouseInfo) ->
    #house_info{
        home_id = {BlockId, HouseId},
        server_id = ServerId,
        role_id_1 = RoleId1,
        role_id_2 = RoleId2,
        lv = HouseLv,
        lock = Lock,
        marriage_start_lv = MarriageStartLv,
        choose_house = {ChooseBlockId, ChooseHouseId},
        inside_list = InsideList,
        cost_log = CostLog,
        text = Text,
        buy_time = BuyTime,
        popularity = Popularity
    } = HouseInfo,
    SCostLog = util:term_to_string(CostLog),
    SText = util:make_sure_binary(Text),
    SqlStr = io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, '~s', '~s', ~p, ~p)",
        [BlockId, HouseId, ServerId, RoleId1, RoleId2, HouseLv, Lock, MarriageStartLv, ChooseBlockId, ChooseHouseId, SCostLog, SText, BuyTime, Popularity]),
    ReSql1 = io_lib:format(?ReplaceHouseInfoAllSql, [SqlStr]),
    db:execute(ReSql1),
    SqlStrList = [begin
        #furniture_inside_info{
            loc_id = LocId,
            goods_id = GoodsId,
            goods_type_id = GoodsTypeId,
            x = X,
            y = Y,
            face = Face,
            map_id = MapId
        } = FurnitureInsideInfo,
        io_lib:format("(~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p, ~p)", [LocId, BlockId, HouseId, GoodsId, GoodsTypeId, X, Y, Face, MapId])
    end||FurnitureInsideInfo <- InsideList],
    case SqlStrList of
        [] ->
            skip;
        _ ->
            SqlList = ulists:list_to_string(SqlStrList, ","),
            ReSql2 = io_lib:format(?ReplaceHouseFurnitureLocAllSql, [SqlList]),
            db:execute(ReSql2)
    end.

sql_aa_info(AAInfo) ->
    #aa_ask_info{
        home_id = {BlockId, HouseId},
        server_id = ServerId,
        house_lv = HouseLv,
        ask_role_id = AskRoleId,
        answer_role_id = AnswerRoleId,
        ask_time = AskTime,
        type = Type,
        cost_key = CostKey,
        ask_cost_list = AskCostList,
        answer_cost_list = AnswerCostList
    } = AAInfo,
    SAskCostList = util:term_to_string(AskCostList),
    SAnswerCostList = util:term_to_string(AnswerCostList),
    ReSql = io_lib:format(?ReplaceHouseHouseAAInfoSql, [BlockId, HouseId, ServerId, HouseLv, AskRoleId, AnswerRoleId, AskTime, Type, CostKey, SAskCostList, SAnswerCostList]),
    db:execute(ReSql).

update_house_info(RoleId, BlockId, HouseId, HouseLv, ChooseHouse) ->
    lib_role:update_role_show(RoleId, [{house, {BlockId, HouseId}, HouseLv}]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_house, update_ps_house_info, [BlockId, HouseId, HouseLv, ChooseHouse]).

update_ps_house_info(Ps, BlockId, HouseId, HouseLv, ChooseHouse) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = CopyId,
        house = HouseStatus,
        figure = Figure
    } = Ps,
    case BlockId of
        0 ->
            NewHouseStatus = HouseStatus#house_status{
                home_id = {0, 0},
                house_lv = 0,
                choose_house = {0, 0},
                furniture_attr = [],
                house_attr = []
            },
            NewFigure = Figure;
        _ ->
            #house_lv_con{
                attr_list = HouseAttrList
            } = data_house:get_house_lv_con(HouseLv),
            GoodsStatus = lib_goods_do:get_goods_status(),
            FurnitureWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_FURNITURE, GoodsStatus#goods_status.dict),
            FurnitureAttrList = count_house_attribute(FurnitureWearList),
            NewHouseStatus = HouseStatus#house_status{
                home_id = {BlockId, HouseId},
                house_lv = HouseLv,
                choose_house = ChooseHouse,
                furniture_attr = FurnitureAttrList,
                house_attr = HouseAttrList
            },
            NewFigure = Figure#figure{
                home_id = {BlockId, HouseId},
                house_lv = HouseLv
            }
    end,
    NewPs1 = Ps#player_status{
        house = NewHouseStatus,
        figure = NewFigure
    },
    lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
    %%通知场景
    mod_scene_agent:update(NewPs, [{house, {BlockId, HouseId, HouseLv}}]),
    {ok, Bin} = pt_177:write(17718, [RoleId, BlockId, HouseId, HouseLv]),
    lib_server_send:send_to_scene(SceneId, 0, CopyId, Bin),
    NewPs.

%% Type 1购房失败 2答应AA购买失败 3AA购买被拒 4超时 5升级失败 6答应AA升级房子失败返还
%% 7AA升级房子被拒返还 8AA升级房子超时返还
house_fail_return(RoleId, CostKey, CostList, Type) ->
    case Type of
        1 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_FAIL_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_FAIL_RETURN);
        2 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_AA_FAIL_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_FAIL_RETURN);
        3 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_AA_REFUSE_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_REFUSE_RETURN);
        4 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_AA_tIMEOUT_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_tIMEOUT_RETURN);
        5 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_UPGRADE_FAIL_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_UPGRADE_FAIL_RETURN);
        6 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_AA_UPGRADE_FAIL_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_UPGRADE_FAIL_RETURN);
        7 ->
            Title = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_UPGRADE_REFUSE_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_UPGRADE_REFUSE_RETURN);
        _ ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_AA_UPGRADE_tIMEOUT_RETURN),
            Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_AA_UPGRADE_tIMEOUT_RETURN)
    end,
    lib_consume_data:advance_payment_fail(RoleId, CostKey, []),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, CostList).

get_role_furniture_list(GoodsStatus) ->
    #goods_status{
        player_id = RoleId,
        dict = Dict
    } = GoodsStatus,
    FurnitureWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_FURNITURE, Dict),
    WearFurnitureList = [begin
        #goods{
            id = GoodsId1,
            goods_id = GoodsTypeId1,
            num = GoodsNum1
        } = Furniture,
        #furniture_info{
            role_id = RoleId,
            goods_id = GoodsId1,
            goods_type_id = GoodsTypeId1,
            goods_num = GoodsNum1
        }
    end||Furniture <- FurnitureWearList],
    WearFurnitureList.

get_both_final_furniture_list([T|G], FurnitureList1, FurnitureList2, BlockId, HouseId) ->
    #furniture_inside_info{
        loc_id = LocId,
        goods_id = GoodsId,
        goods_type_id = GoodsTypeId
    } = T,
    case lists:keyfind(GoodsId, #furniture_info.goods_id, FurnitureList1) of
        false ->
            case lists:keyfind(GoodsId, #furniture_info.goods_id, FurnitureList2) of
                false ->
                    case GoodsTypeId =:= ?DefaultFloorGoodsTypeId of
                        true ->
                            get_both_final_furniture_list(G, FurnitureList1, FurnitureList2, BlockId, HouseId);
                        false ->
                            ReSql = io_lib:format(?DeleteHouseFurnitureLocSql, [LocId]),
                            db:execute(ReSql),
                            get_both_final_furniture_list(G, FurnitureList1, FurnitureList2, BlockId, HouseId)
                    end;
                FurnitureInfo ->
                    #furniture_info{
                        put_num = PutNum
                    } = FurnitureInfo,
                    NewFurnitureInfo = FurnitureInfo#furniture_info{
                        put_num = PutNum+1
                    },
                    NewFurnitureList2 = lists:keyreplace(GoodsId, #furniture_info.goods_id, FurnitureList2, NewFurnitureInfo),
                    get_both_final_furniture_list(G, FurnitureList1, NewFurnitureList2, BlockId, HouseId)
            end;
        FurnitureInfo ->
            #furniture_info{
                put_num = PutNum
            } = FurnitureInfo,
            NewFurnitureInfo = FurnitureInfo#furniture_info{
                put_num = PutNum+1
            },
            NewFurnitureList1 = lists:keyreplace(GoodsId, #furniture_info.goods_id, FurnitureList1, NewFurnitureInfo),
            get_both_final_furniture_list(G, NewFurnitureList1, FurnitureList2, BlockId, HouseId)
    end;
get_both_final_furniture_list([], FurnitureList1, FurnitureList2, _BlockId, _HouseId) ->
    {FurnitureList1, FurnitureList2}.

get_house_point(HouseInfo) ->
    #house_info{
        lv = HouseLv,
        furniture_list_1 = FurnitureList1,
        furniture_list_2 = FurnitureList2
    } = HouseInfo,
    AllFurnitureList = FurnitureList1 ++ FurnitureList2,
    #house_lv_con{
        point = LvPoint
    } = data_house:get_house_lv_con(HouseLv),
    F = fun(FurnitureInfo, HousePoint1) ->
        #furniture_info{
            goods_type_id = GoodsTypeId,
            goods_num = GoodsNum
        } = FurnitureInfo,
        #house_furniture_con{
            point = FurniturePoint
        } = data_house:get_house_furniture_con(GoodsTypeId),
        HousePoint1 + FurniturePoint*GoodsNum
    end,
    HousePoint = LvPoint + lists:foldl(F, 0, AllFurnitureList),
    HousePoint.

check_upgrade_house(RoleId, BlockId, HouseId, HouseList, AAList) ->
    case lists:keyfind({BlockId, HouseId}, #aa_ask_info.home_id, AAList) of
        false ->
            case lists:keyfind({BlockId, HouseId}, #house_info.home_id, HouseList) of
                false ->
                    {false, ?ERRCODE(err177_house_none)};
                HouseInfo ->
                    #house_info{
                        role_id_1 = RoleId1,
                        role_id_2 = RoleId2,
                        lv = HouseLv
                    } = HouseInfo,
                    case lists:member(RoleId, [RoleId1, RoleId2]) of
                        false ->
                            {false, ?ERRCODE(err177_house_not_own)};
                        true ->
                            HouseLvList = data_house:get_house_lv_list(),
                            HouseLvMax = lists:max(HouseLvList),
                            case HouseLv < HouseLvMax of
                                false ->
                                    {false, ?ERRCODE(err177_house_lv_max)};
                                true ->
                                    #house_lv_con{
                                        need_point = NeedPoint
                                    } = data_house:get_house_lv_con(HouseLv+1),
                                    HousePoint = get_house_point(HouseInfo),
                                    case HousePoint >= NeedPoint of
                                        false ->
                                            {false, ?ERRCODE(err177_house_point_not_enough)};
                                        true ->
                                            true
                                    end
                            end
                    end
            end;
        _ ->
            {false, ?ERRCODE(err177_house_upgrade_aa)}
    end.

open_house_list(RoleId, BlockId, SendInfoList) ->
    SendList = [begin
        {BlockId, HouseId, RoleId1, RoleId2, HouseLv, Lock, BuyTime, Text, IfChoose} = SendInfo1,
        Ps1 = lib_offline_api:get_player_info(RoleId1, all),
        #player_status{
            figure = Figure1
        } = Ps1,
        #figure{
            name = Name1
        } = Figure1,
        case RoleId2 of
            0 ->
                Name2 = "";
            _ ->
                Ps2 = lib_offline_api:get_player_info(RoleId2, all),
                #player_status{
                    figure = Figure2
                } = Ps2,
                #figure{
                    name = Name2
                } = Figure2
        end,
        {BlockId, HouseId, RoleId1, Name1, RoleId2, Name2, HouseLv, Lock, BuyTime, Text, IfChoose} end
    ||SendInfo1 <- SendInfoList],
    {ok, Bin} = pt_177:write(17703, [?SUCCESS, BlockId, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin).
    
marriage_house(HouseInfo1, HouseInfo2, HouseList) ->
    #house_info{
        role_id_1 = RoleId1,
        name_1 = Name1,
        home_id = {BlockId1, HouseId1},
        furniture_list_1 = FurnitureList11,
        lv = HouseLv1
    } = HouseInfo1,
    #house_info{
        role_id_1 = RoleId2,
        name_1 = Name2,
        home_id = {BlockId2, HouseId2},
        lv = HouseLv2,
        furniture_list_1 = FurnitureList12
    } = HouseInfo2,
    NewHouseInfo1 = HouseInfo1#house_info{
        role_id_2 = RoleId2,
        name_2 = Name2,
        marriage_start_lv = HouseLv1,
        furniture_list_2 = FurnitureList12,
        choose_house = {BlockId2, HouseId2}
    },
    lib_house:sql_house_info(NewHouseInfo1),
    NewHouseInfo2 = HouseInfo2#house_info{
        role_id_2 = RoleId1,
        name_2 = Name1,
        lock = 1,
        marriage_start_lv = HouseLv2,
        furniture_list_2 = FurnitureList11,
        choose_house = {BlockId1, HouseId1}
    },
    lib_house:sql_house_info(NewHouseInfo2),
    NewHouseList1 = lists:keyreplace(RoleId1, #house_info.role_id_1, HouseList, NewHouseInfo1),
    NewHouseList = lists:keyreplace(RoleId2, #house_info.role_id_1, NewHouseList1, NewHouseInfo2),
    #house_info{
        home_id = {NewBlockId, NewHouseId},
        lv = HouseLv,
        choose_house = ChooseHouse
    } = NewHouseInfo1,
    update_house_info(RoleId1, NewBlockId, NewHouseId, HouseLv, ChooseHouse),
    update_house_info(RoleId2, NewBlockId, NewHouseId, HouseLv, ChooseHouse),
    lib_common_rank_api:home_role_change({BlockId1, HouseId1}, RoleId1, RoleId2),
    lib_common_rank_api:home_role_change({BlockId2, HouseId2}, RoleId2, RoleId1),
    lib_common_rank_api:remove_rank_home({BlockId2, HouseId2}),
    lib_log_api:log_house_choose(RoleId1, RoleId2, BlockId1, HouseId1, HouseLv1, 1, 0),
    NewHouseList.

get_return_list([T|G], RoleId1, RoleId1ReturnList, RoleId2ReturnList) ->
    {HouseLv, RoleIdList} = T,
    #house_lv_con{
        cost_list = CostList
    } = data_house:get_house_lv_con(HouseLv),
    case length(RoleIdList) of
        1 ->
            case lists:member(RoleId1, RoleIdList) of
                false ->
                    get_return_list(G, RoleId1, RoleId1ReturnList, RoleId2ReturnList++CostList);
                true ->
                    get_return_list(G, RoleId1, RoleId1ReturnList++CostList, RoleId2ReturnList)
            end;
        _ ->
            CostList1 = [{GoodsType, GoodsTypeId, round(GoodsNum/2)}||{GoodsType, GoodsTypeId, GoodsNum} <- CostList],
            get_return_list(G, RoleId1, RoleId1ReturnList++CostList1, RoleId2ReturnList++CostList1)
    end;
get_return_list([], _RoleId1, RoleId1ReturnList, RoleId2ReturnList) ->
    {RoleId1ReturnList, RoleId2ReturnList}.

divorce_house(HouseInfo, HouseList) ->
    % #house_info{
    %     home_id = {BlockId, HouseId},
    %     server_id = ServerId,
    %     role_id_1 = RoleId1,
    %     furniture_list_1 = FurnitureList1,
    %     inside_list = InsideList,
    %     cost_log = CostLogList,
    %     marriage_start_lv = MarriageStartLv,
    %     lock = OldLock
    % } = HouseInfo,
    % {RoleId1ReturnList, RoleId2ReturnList} = get_return_list(CostLogList, RoleId1, [], []),
    % case MarriageStartLv of
    %     0 ->
    %         NewHouseList = lists:delete(HouseInfo, HouseList),
    %         ReSql1 = io_lib:format(?DeleteHouseInfoSql, [BlockId, HouseId, ServerId]),
    %         db:execute(ReSql1),
    %         lib_common_rank_api:delete_home({BlockId, HouseId}),
    %         {{0, 0, 0}, RoleId1ReturnList, RoleId2ReturnList, NewHouseList, false};
    %     _ ->
    %         NewInsideList = [InsideInfo||InsideInfo <- InsideList, begin
    %             #furniture_inside_info{
    %                 goods_type_id = GoodsTypeId
    %             } = InsideInfo,
    %             #ets_goods_type{subtype = SubType} = data_goods_type:get(GoodsTypeId),
    %             SubType =:= ?GOODS_FURNITURE_STYPE_FLOOR
    %         end],
    %         NewFurnitureList1 = [begin
    %             #furniture_info{
    %                 goods_type_id = GoodsTypeId1,
    %                 put_num = PutNum1
    %             } = FurnitureInfo1,
    %             #ets_goods_type{subtype = SubType1} = data_goods_type:get(GoodsTypeId1),
    %             case SubType1 =:= ?GOODS_FURNITURE_STYPE_FLOOR of
    %                 true ->
    %                     FurnitureInfo1#furniture_info{
    %                         put_num = PutNum1
    %                     };
    %                 false ->
    %                     FurnitureInfo1#furniture_info{
    %                         put_num = 0
    %                     }
    %             end
    %         end||FurnitureInfo1 <- FurnitureList1],
    %         NewHouseInfo = HouseInfo#house_info{
    %             name_2 = "",
    %             role_id_2 = 0,
    %             furniture_list_1 = NewFurnitureList1,
    %             furniture_list_2 = [],
    %             inside_list = NewInsideList,
    %             cost_log = [],
    %             choose_house = {0, 0},
    %             lv = MarriageStartLv,
    %             lock = 0
    %         },
    %         sql_house_info(NewHouseInfo),
    %         NewHouseList = lists:keyreplace(RoleId1, #house_info.role_id_1, HouseList, NewHouseInfo),
    %         case OldLock of
    %             0 ->
    %                 lib_common_rank_api:home_role_change({BlockId, HouseId}, RoleId1, 0);
    %             _ ->
    %                 lib_common_rank_api:home_rerank({BlockId, HouseId}),
    %                 lib_common_rank_api:home_role_change({BlockId, HouseId}, RoleId1, 0)
    %         end,
    %         {{BlockId, HouseId, MarriageStartLv}, RoleId1ReturnList, RoleId2ReturnList, NewHouseList, NewHouseInfo}
    % end.
    {{0, 0, 0}, [], [], [], false}.

%% Type: 1单方有房 2两方有房
marriage_house_success(Ps, RoleIdM, RoleIdW, Type) ->
    #player_status{
        figure = Figure
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    case Type of
        1 ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_MARRIAGE_SIDE_HAVE),
            Content = utext:get(?LAN_CONTENT_HOUSE_MARRIAGE_SIDE_HAVE, [Name]);
        _ ->
            Title = ?LAN_MSG(?LAN_TITLE_HOUSE_MARRIAGE_BOTH_HAVE),
            Content = utext:get(?LAN_CONTENT_HOUSE_MARRIAGE_BOTH_HAVE, [Name])
    end,
    lib_mail_api:send_sys_mail([RoleIdM, RoleIdW], Title, Content, []).

divorce_house_side(Ps, RoleId1, RoleId2, RoleId1ReturnList, RoleId2ReturnList) ->
    #player_status{
        figure = Figure
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    Title = ?LAN_MSG(?LAN_TITLE_HOUSE_DIVORCE_SIDE_HAVE),
    Content = utext:get(?LAN_CONTENT_HOUS_DIVORCEE_SIDE_HAVE, [Name]),
    lib_mail_api:send_sys_mail([RoleId1], Title, Content, RoleId1ReturnList),
    lib_mail_api:send_sys_mail([RoleId2], Title, Content, RoleId2ReturnList).

init_default_floor(RoleId, InsideList) ->
    % FloorList = [InsideInfo||InsideInfo <- InsideList,begin
    %     #furniture_inside_info{
    %         goods_type_id = GoodsTypeId1
    %     } = InsideInfo,
    %     #ets_goods_type{subtype = SubType1} = data_goods_type:get(GoodsTypeId1),
    %     SubType1 =:= ?GOODS_FURNITURE_STYPE_FLOOR
    % end],
    % case FloorList of
    %     [] ->
    %         NewFloorInside = #furniture_inside_info{
    %             goods_type_id = ?DefaultFloorGoodsTypeId
    %         },
    %         InsideList1 = [NewFloorInside|InsideList];
    %     _ ->
    %         InsideList1 = InsideList
    % end,
    % case lists:keyfind(?DefaultFloorGoodsTypeId, #furniture_inside_info.goods_type_id, InsideList1) of
    %     false ->
    %         PutNum = 0;
    %     _ ->
    %         PutNum = 1
    % end,
    DefaultFloor = #furniture_info{
        role_id = RoleId,
        goods_id = 0,
        goods_type_id = ?DefaultFloorGoodsTypeId,
        goods_num = 1
    },
    {DefaultFloor, InsideList}.

check_into_house(Ps) ->
    #player_status{
        scene = SceneId
    } = Ps,
    SceneIdList = data_house:get_house_scene_list(),
    case lists:member(SceneId, SceneIdList) of
        false ->
            lib_player_check:check_all(Ps);
        true ->
            true
    end.

reconnect(Ps, _LoginType) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        copy_id = CopyId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    SceneIdList = data_house:get_house_scene_list(),
    case lists:member(SceneId, SceneIdList) of
        true ->
            mod_house:house_reconnect(RoleId, Lv, CopyId),
            {ok, Ps};
        false ->
            {next, Ps}
    end.

get_recommend_house_list([T|G], RoleId, RecommendHouseList) ->
    #house_info{
        home_id = {BlockId, HouseId},
        lv = HouseLv,
        role_id_1 = RoleId1,
        role_id_2 = RoleId2,
        lock = Lock
    } = T,
    IfOwn = lists:member(RoleId, [RoleId1, RoleId2]),
    if
        IfOwn =:= true ->
            get_recommend_house_list(G, RoleId, RecommendHouseList);
        Lock =:= 1 ->
            get_recommend_house_list(G, RoleId, RecommendHouseList);
        true ->
            RecommendInfo = {BlockId, HouseId, HouseLv, RoleId1},
            NewRecommendHouseList = [RecommendInfo|RecommendHouseList],
            case length(NewRecommendHouseList) >= ?RecommendListLen of
                true ->
                    NewRecommendHouseList;
                false ->
                    get_recommend_house_list(G, RoleId, NewRecommendHouseList)
            end
    end;
get_recommend_house_list([], _RoleId, RecommendHouseList) ->
    RecommendHouseList.

rhl_player_info(RecommendList, RoleId) ->
    F = fun(RecommendInfo, SendList1) ->
        {BlockId, HouseId, HouseLv, RoleId1} = RecommendInfo,
        Ps1 = lib_offline_api:get_player_info(RoleId1, all),
        #player_status{
            figure = Figure
        } = Ps1,
        #figure{
            name = Name,
            career = Career,
            sex = Sex,
            turn = Turn,
            lv = Lv
        } = Figure,
        SendInfo = {RoleId1, Name, Career, Sex, Turn, Lv, BlockId, HouseId, HouseLv},
        [SendInfo|SendList1]
    end,
    SendList = lists:foldl(F, [], RecommendList),
    {ok, Bin} = pt_177:write(17722, [?SUCCESS, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin).

upgrade_inside_change(FurnitureList1, FurnitureList2, InsideList) ->
    % F1 = fun(FurnitureInfo, NewFurnitureList) ->
    %     #furniture_info{
    %         goods_type_id = GoodsTypeId
    %     } = FurnitureInfo,
    %     #house_furniture_con{
    %         furniture_type = FurnitureType
    %     } = data_house:get_house_furniture_con(GoodsTypeId),
    %     NewFurnitureInfo = case FurnitureType =:= ?GOODS_FURNITURE_STYPE_FLOOR of
    %         false ->
    %             FurnitureInfo#furniture_info{
    %                 put_num = 0
    %             };
    %         true ->
    %             FurnitureInfo
    %     end,
    %     [NewFurnitureInfo|NewFurnitureList]
    % end,
    % NewFurnitureList1 = lists:foldl(F1, [], FurnitureList1),
    % NewFurnitureList2 = lists:foldl(F1, [], FurnitureList2),
    % F2 = fun(InsideInfo, NewInsideList1) ->
    %     #furniture_inside_info{
    %         goods_type_id = GoodsTypeId
    %     } = InsideInfo,
    %     #house_furniture_con{
    %         furniture_type = FurnitureType
    %     } = data_house:get_house_furniture_con(GoodsTypeId),
    %     case FurnitureType =:= ?GOODS_FURNITURE_STYPE_FLOOR of
    %         false ->
    %             NewInsideList1;
    %         true ->
    %             [InsideInfo|NewInsideList1]
    %     end
    % end,
    % NewInsideList = lists:foldl(F2, [], InsideList),
    % {NewFurnitureList1, NewFurnitureList2, NewInsideList}.
    {FurnitureList1, FurnitureList2, InsideList}.

house_send_tv(TypeId, Args) ->
    case TypeId of
        1 ->
            [[RoleId1], BlockId] = Args,
            #house_block_con{
                block_name = BlockName
            } = data_house:get_house_block_con(BlockId),
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            lib_chat:send_TV({all}, ?MOD_HOUSE, 1, [Name1, BlockName]);
        2 ->
            [[RoleId1, RoleId2], BlockId] = Args,
            #house_block_con{
                block_name = BlockName
            } = data_house:get_house_block_con(BlockId),
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            Ps2 = lib_offline_api:get_player_info(RoleId2, all),
            #player_status{
                figure = Figure2
            } = Ps2,
            #figure{
                name = Name2
            } = Figure2,
            lib_chat:send_TV({all}, ?MOD_HOUSE, 2, [Name1, Name2, BlockName]);
        3 ->
            [[RoleId1], HouseLv] = Args,
            #house_lv_con{
                house_name = HouseName
            } = data_house:get_house_lv_con(HouseLv),
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            lib_chat:send_TV({all}, ?MOD_HOUSE, 3, [Name1, HouseName]);
        _ ->
            [[RoleId1, RoleId2], HouseLv] = Args,
            #house_lv_con{
                house_name = HouseName
            } = data_house:get_house_lv_con(HouseLv),
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            Ps2 = lib_offline_api:get_player_info(RoleId2, all),
            #player_status{
                figure = Figure2
            } = Ps2,
            #figure{
                name = Name2
            } = Figure2,
            lib_chat:send_TV({all}, ?MOD_HOUSE, 4, [Name1, Name2, HouseName])
    end.

handle_event(Ps, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Ps, player_status) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        house = HouseStatus
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    #house_status{
        home_id = {BlockId, HouseId}
    } = HouseStatus,
    case BlockId of
        0 ->
            skip;
        _ ->
            mod_house:update_name(RoleId, Name, BlockId, HouseId)
    end,
    {ok, Ps};

handle_event(Ps, _) ->
    {ok, Ps}.

divorce_quit(Ps) ->
    #player_status{
        scene = SceneId,
        old_scene_info = OldSceneInfo,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    SceneIdList = data_house:get_house_scene_list(),
    case lists:member(SceneId, SceneIdList) of
        true ->
            case OldSceneInfo of
                undefined ->
                    [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                    OldScenePooldId = 0,
                    OldCopyId = 0;
                {OldScene1, OldScenePooldId1, OldCopyId1, OldX1, OldY1} ->
                    case lists:member(SceneId, SceneIdList) of
                        true ->
                            [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                            OldScenePooldId = 0,
                            OldCopyId = 0;
                        false ->
                            OldScene = OldScene1,
                            OldScenePooldId = OldScenePooldId1,
                            OldCopyId = OldCopyId1,
                            OldX = OldX1,
                            OldY = OldY1
                    end
            end,
            NewPs = lib_scene:change_scene(Ps, OldScene, OldScenePooldId, OldCopyId, OldX, OldY, false, [{collect_checker, undefined}]);
        false ->
            NewPs = Ps
    end,
    NewPs.

get_player_house_info_db(RoleId) ->
    ReSql = io_lib:format(?SelectHouseInfoSql, [RoleId, RoleId]),
    case db:get_all(ReSql) of
        [] ->
            {0, 0, 0, 0};
        InfoList ->
            get_player_house_info_db_1(InfoList)
    end.

get_player_house_info_db_1([T|G]) ->
    [BlockId, HouseId, ServerId, HouseLv, Lock] = T,
    case Lock of
        0 ->
            {BlockId, HouseId, ServerId, HouseLv};
        _ ->
            get_player_house_info_db_1(G)
    end;
get_player_house_info_db_1([]) ->
    {0, 0, 0, 0}.

send_gift_fail(ReturnList, RoleId) ->
    Title = ?LAN_MSG(?LAN_TITLE_HOUSE_GIFT_FAIL),
    Content = ?LAN_MSG(?LAN_CONTENT_HOUSE_GIFT_FAIL),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, ReturnList).

get_gift_log(RoleId, Popularity, SendList) ->
    NewSendlist = [begin
        {RoleId1, GiftId, WishWord, SendTime} = SendInfo,
        Ps1 = lib_offline_api:get_player_info(RoleId1, all),
        #player_status{
            figure = Figure1
        } = Ps1,
        #figure{
            name = Name1,
            career = Career1,
            sex = Sex1,
            turn = Turn1,
            lv = Lv1
        } = Figure1,
        {RoleId1, Name1, Career1, Sex1, Turn1, Lv1, GiftId, WishWord, SendTime}
    end||SendInfo <- SendList],
    {ok, Bin} = pt_177:write(17726, [?SUCCESS, Popularity, NewSendlist]),
    lib_server_send:send_to_uid(RoleId, Bin).

house_gift_send_tv(RoleId, Args) ->
    Ps = lib_offline_api:get_player_info(RoleId, all),
    #player_status{
        figure = Figure
    } = Ps,
    #figure{
        name = Name
    } = Figure,
    case length(Args) of
        2 ->
            [RoleId1, GoodsList] = Args,
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            GoodsStr = lib_goods_api:get_first_object_name(GoodsList),
            lib_chat:send_TV({all}, ?MOD_HOUSE, 5, [Name, Name1, GoodsStr]);
        _ ->
            [RoleId1, RoleId2, GoodsList] = Args,
            Ps1 = lib_offline_api:get_player_info(RoleId1, all),
            #player_status{
                figure = Figure1
            } = Ps1,
            #figure{
                name = Name1
            } = Figure1,
            Ps2 = lib_offline_api:get_player_info(RoleId2, all),
            #player_status{
                figure = Figure2
            } = Ps2,
            #figure{
                name = Name2
            } = Figure2,
            GoodsStr = lib_goods_api:get_first_object_name(GoodsList),
            lib_chat:send_TV({all}, ?MOD_HOUSE, 6, [Name, Name1, Name2, GoodsStr])
    end.

change_sql_add_server_id() ->
    ServerId = config:get_server_id(),
    ReSql1 = io_lib:format(<<"UPDATE `house_info` SET `server_id` = ~p WHERE `server_id` = 0">>, [ServerId]),
    db:execute(ReSql1),
    ReSql2 = io_lib:format(<<"UPDATE `house_aa_info` SET `server_id` = ~p WHERE `server_id` = 0">>, [ServerId]),
    db:execute(ReSql2).

get_return_list_merge(CostLogList, RoleId1, MarriageStartLv) ->
    {RoleId1ReturnList1, RoleId2ReturnList} = get_return_list(CostLogList, RoleId1, [], []),
    case MarriageStartLv of
        0 ->
            {RoleId1ReturnList1, RoleId2ReturnList};
        _ ->
            F = fun(HouseLv, ReturnList1) ->
                #house_lv_con{
                    cost_list = CostList
                } = data_house:get_house_lv_con(HouseLv),
                ReturnList1 ++ CostList
            end,
            RoleId1ReturnList = lists:foldl(F, RoleId1ReturnList1, lists:seq(1, MarriageStartLv)),
            {RoleId1ReturnList, RoleId2ReturnList}
    end.