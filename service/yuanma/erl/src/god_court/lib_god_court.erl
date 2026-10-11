%% ---------------------------------------------------------------------------
%% @doc lib_god_court

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/28
%% @deprecated   神庭
%% ---------------------------------------------------------------------------
-module(lib_god_court).

%% API
-compile([export_all]).

-include("server.hrl").
-include("common.hrl").
-include("god_court.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("def_module.hrl").

login(Ps) ->
    #player_status{id = RoleId} = Ps,
    HouseStatus = init_house_status(RoleId),
    {CourtList, SumAttr} = init_court_list(RoleId),
    GodCourtStatus = #god_court_status{house_status = HouseStatus, god_court_list = CourtList, sum_attr = SumAttr},
    Ps#player_status{god_court_status = GodCourtStatus}.

init_house_status(RoleId) ->
    ResetTime = get_reset_time(),
    case db:get_row(io_lib:format(?sql_select_house, [RoleId])) of
        [Lv, Exp, SumNum, DailyNum, CrystalColor, GrandStatusStr, RTime] ->
            {DNum, GrandStatus} =
                case utime:unixtime() > RTime of
                    true ->
                        GrandS = [{Times, ?NO_GET}||Times <- ?DAILY_ORIGIN_TIMES],
                        db:execute(io_lib:format(?sql_save_god_house, [RoleId, Lv, Exp, SumNum, 0, CrystalColor, util:term_to_bitstring(GrandS), ResetTime])),
                        {0, GrandS};
                    _ ->
                        F = fun(TimesId, {Acc, IsSave}) ->
                            case lists:keyfind(TimesId, 1, Acc) of
                                false ->
                                    GetState = ?IF(DailyNum >= TimesId, ?CAN_GET, ?NO_GET),
                                    {lists:keystore(TimesId, 1, Acc, {TimesId, GetState}), IsSave orelse true};
                                _ -> {Acc, IsSave orelse false}
                            end end,
                        {GrandS, IsSaveN} = lists:foldl(F, {util:bitstring_to_term(GrandStatusStr), false}, ?DAILY_ORIGIN_TIMES),
                        IsSaveN andalso  db:execute(io_lib:format(?sql_save_god_house, [RoleId, Lv, Exp, SumNum, DailyNum, CrystalColor, util:term_to_bitstring(GrandS), RTime])),
                        {DailyNum, GrandS}
                end,
            ?PRINT("ResetTime = ~w, DNum =~w, GrandStatus =~w ~n",[ResetTime, DNum, GrandStatus]),
            #god_house_status{
                lv = Lv,
                exp = Exp,
                sum_num = SumNum,
                daily_num = DNum,
                crystal_color = CrystalColor,
                grand_status = GrandStatus,
                reset_time = ResetTime
            };
        _ ->
            GrandStatus = [{Times, ?NO_GET}||Times <- ?DAILY_ORIGIN_TIMES],
            db:execute(io_lib:format(?sql_save_god_house, [RoleId, 1, 0, 0, 0, 1, util:term_to_bitstring(GrandStatus), ResetTime])),
            #god_house_status{
                grand_status = GrandStatus
            }
    end.

init_court_list(RoleId) ->
    List = init_court_list_do(RoleId),
    Sql = io_lib:format(<<"select `court_id`, `pos`, `goods_id`, `equip_id`, `stage` from `role_god_court_equip` where `role_id` = ~p">>, [RoleId]),
    CourtEquipList = db:get_all(Sql),
    F = fun(CourtInfo, CAList) ->
        {CList, CAttr} = CAList,
        [CourtId, IsActive, Lv] = CourtInfo,
%%        EquipList = init_equip_list(RoleId, CourtId),
        EquipList = get_equip_list(CourtEquipList, CourtId),
        CourtItem = #god_court_item{court_id = CourtId,is_active = IsActive, lv = Lv, equip_list = EquipList},
        NewItem = cal_attr_power2(CourtItem),
        {[NewItem|CList], NewItem#god_court_item.sum_attr ++ CAttr}
        end,
    {CourtList, SumAttr} = lists:foldl(F, {[], []}, List),
    CourtIds = data_god_court:get_court_ids(),
    %% 有待优化
    NewCourtList =
        [begin
             GodItem = #god_court_item{equip_list = EquipList} = ulists:keyfind(CourtId, #god_court_item.court_id, CourtList, #god_court_item{court_id = CourtId}),
             case EquipList of
                 [] ->
                     #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
                     Poss = ?GOD_POS_LIST ++ [CorePos],
                     NewEquipList = [{Pos, 0, 0, 0}||Pos <- Poss];
                 _ -> NewEquipList = EquipList
             end,
             GodItem#god_court_item{equip_list = NewEquipList}
         end||CourtId <- CourtIds],
    {NewCourtList, SumAttr}.

init_court_list_do(RoleId) ->
    case db:get_all(io_lib:format(?sql_select_court, [RoleId])) of
        [] ->
            CourtIds = data_god_court:get_court_ids(),
            [[CourtId, 0, 0]||CourtId<-CourtIds];
        Return -> Return
    end.

init_equip_list(RoleId, CourtId) ->
    List = init_equip_list_do(RoleId, CourtId),
    [{Pos, GoodsId, EquipId, Stage}||[Pos, GoodsId, EquipId, Stage] <- List].

init_equip_list_do(RoleId, CourtId) ->
    case db:get_all(io_lib:format(?sql_select_court_equip, [RoleId, CourtId])) of
        [] ->
            #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
            Poss = ?GOD_POS_LIST ++ [CorePos],
            [[Pos, 0, 0, 0]||Pos <- Poss];
        Return ->
            Return
    end.

%% 清理日常升橙状态
daily_clear() ->
    case utime:day_of_week() of
        1 ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            ResetTime = get_reset_time(),
            [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_god_court, reset_house, [ResetTime])||#ets_online{id = RoleId} <- OnlineRoles];
        _ -> skip
    end.

%% 清理日常升橙状态（用户进程执行）
reset_house(Ps, ResetTime) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId} = Ps,
    #god_court_status{house_status = HouseStatus} = GodCourtStatus,
    GrandStatus = [{Times, ?NO_GET}||Times <- ?DAILY_ORIGIN_TIMES],
    NewHouseStatus = HouseStatus#god_house_status{grand_status = GrandStatus, reset_time = ResetTime, daily_num = 0},
    #god_house_status{
        sum_num = SumNum,
        crystal_color = CrystalColor,
        lv = Lv,
        exp = Exp
    } = NewHouseStatus,
    LvList = data_god_court:get_house_reward_lvs(),
    {RewardLv, RewardPool} = get_reward_pool(SumNum, LvList),
    send_mail_reward(RoleId, HouseStatus#god_house_status.grand_status, RewardPool),
    save_god_house(RoleId, NewHouseStatus),
    {ok, BinData} = pt_233:write(23306, [RewardLv, SumNum, CrystalColor, 0, Lv, Exp, GrandStatus]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewGodCourtStatus = GodCourtStatus#god_court_status{house_status = NewHouseStatus},
    Ps#player_status{god_court_status = NewGodCourtStatus}.

%% 发送未领取的邮件
send_mail_reward(RoleId, GrandStatus, RewardPool) ->
    Rewards =
        [begin
             WeightList = [{Weight, {GoodsType, GoodsId, GoodsNum}}||{GoodsType, GoodsId, GoodsNum, Weight} <- RewardPool],
             case urand:rand_with_weight(WeightList) of
                 {_,_,_} = Reward ->
                     [Reward];
                 _ ->
                     ?ERR("weight reward err ~p ~n", [WeightList]),
                     []
             end
         end||{_Times, Status}<-GrandStatus, Status == ?CAN_GET],
    ?IF(Rewards == [], skip,
        lib_mail_api:send_sys_mail([RoleId], utext:get(2330001), utext:get(2330002), lists:append(Rewards))),
    ok.

%% gm添加装备
gm_add_court_equip(Ps) ->
    EquipIds = data_god_court:get_all_equip(),
    Reward = [{?TYPE_GOODS, GoodsTypeId, 1}||GoodsTypeId <- EquipIds],
    ?IF(Reward == [], skip,
        lib_goods_api:send_reward_by_id(Reward, gm, Ps#player_status.id)).

%% gm清空神庭
gm_clear_status(Ps) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    [begin
        [begin
             GoodsInfo = lib_goods_util:get_goods(EquipId, Dict),
             lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]),
             lib_goods_util:delete_goods(EquipId)
         end||{_,_,EquipId,_}<-EquipList, EquipId =/= 0]
    end||#god_court_item{equip_list = EquipList} <- CourtList],
    NewCourtList =
        [begin
             #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
             Poss = ?GOD_POS_LIST ++ [CorePos],
             EquipList = [begin
                              save_court_item_equip(RoleId, CourtId, Pos, 0, 0, 0),
                              {Pos, 0, 0, 0}
                          end||Pos <- Poss],
             NewItem = #god_court_item{court_id = CourtId, equip_list = EquipList},
             save_court_item(RoleId, NewItem),
             NewItem
         end||CourtId <- data_god_court:get_court_ids()],
    NewHouseStatus = #god_house_status{grand_status = [{Times, ?NO_GET}||Times <- ?DAILY_ORIGIN_TIMES], reset_time = get_reset_time()},
    save_god_house(RoleId, NewHouseStatus),
    NewGodCourtStatus = GodCourtStatus#god_court_status{sum_attr = [], house_status = NewHouseStatus, god_court_list = NewCourtList},
    NewPs = Ps#player_status{god_court_status = NewGodCourtStatus},
    LastPlayer = lib_player:count_player_attribute(NewPs),
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    LastPlayer.

%% 修改神之所状态
gm_change_house_status(Ps, OriginTimes, Lv) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId} = Ps,
    #god_court_status{house_status = HouseStatus} = GodCourtStatus,
    NewHouseStatus = HouseStatus#god_house_status{lv = Lv, daily_num = OriginTimes, sum_num = OriginTimes, exp = 0},
    save_god_house(RoleId, NewHouseStatus),
    NewGodCourtStatus = GodCourtStatus#god_court_status{house_status = NewHouseStatus},
    NewPs = Ps#player_status{god_court_status = NewGodCourtStatus},
    pp_god_court:handle(23306, NewPs, []),
    NewPs.

%% 使用自身核心合成高级核心
%% @params TargetGoodsInfo 被合成的旧核心
%% @params 产生的新核心物品唯一id
compose_equip_core(Ps, TargetGoodsInfo, NewTargetGoodsId)->
    #player_status{god_court_status = GodCourtStatus, id = RoleId, figure = #figure{name = RoleName}} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods(NewTargetGoodsId, GoodsDict),
    #goods{subtype = SubType, other = #goods_other{skill_id = CourtId}} = TargetGoodsInfo,
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        false -> Ps;
        #god_court_item{equip_list = EquipList} = CourtItem ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                NewGoodsInfo = take_on_equip(GoodsInfo, CourtId),
                [_NewGoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(NewGoodsInfo, ?GOODS_LOC_GOD_COURT_EQUIP, 0, GoodsStatus),
                #goods_status{dict = NewDictTmp} = GoodsStatus2,
                {NewDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewDictTmp),
                NewGoodsStatus = GoodsStatus2#goods_status{dict = NewDict},
                {true, NewGoodsStatus, GoodsL}
                end,
            case lib_goods_util:transaction(F) of
                {true, NewGoodsStatus, GoodsL} ->
                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]),
                    lib_goods_api:notify_client(Ps, GoodsL),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    {Pos, _, _, Stage} = ulists:keyfind(SubType, 1, EquipList, {SubType, 0, 0, 0}),
                    NewEquipList = lists:keystore(SubType, 1, EquipList, {Pos, GoodsInfo#goods.goods_id, GoodsInfo#goods.id, Stage}),
                    NewCourtItemTmp2 = CourtItem#god_court_item{equip_list = NewEquipList},

                    save_court_item_equip(RoleId, CourtId, Pos, GoodsInfo#goods.goods_id, GoodsInfo#goods.id, Stage),
                    NewCourtItem = cal_attr_power2(NewCourtItemTmp2),
                    NewCourtList = lists:keystore(CourtId, #god_court_item.court_id, CourtList, NewCourtItem),
                    NewGodCourtStatusTmp = GodCourtStatus#god_court_status{god_court_list = NewCourtList},
                    NewGodCourtStatus = cal_attr_power1(NewGodCourtStatusTmp),
                    NewPs = Ps#player_status{god_court_status = NewGodCourtStatus},
                    %% 使魔触发
                    PSDemons = lib_demons_api:god_court_equip(NewPs),

                    LastPlayer = lib_player:count_player_attribute(PSDemons),
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),

                    {ok, BinData} = pt_233:write(23303, [?SUCCESS, CourtId, Pos, GoodsInfo#goods.goods_id]),
                    lib_server_send:send_to_uid(Ps#player_status.id, BinData),
                    pp_god_court:send_23310(LastPlayer, CourtId),

                    mod_scene_agent:update(LastPlayer, [{battle_attr, LastPlayer#player_status.battle_attr}]),
                    CourtName = data_god_court:get_name_by_core(Pos),
                    ?IF(GoodsInfo#goods.color == ?PINK,
                        lib_chat:send_TV({all}, ?MOD_GOODS, 25, [RoleName, RoleId, CourtName, GoodsInfo#goods.goods_id]),
                        skip),

                    LastPlayer;
                _Res ->
                    ?ERR("god_court core compose err ~p ~n", [_Res]),
                    Ps
            end
    end.

%% 物品升成时计算评分
cal_goods_rating(EtsGoodsType) when is_record(EtsGoodsType, ets_goods_type) ->
    #ets_goods_type{goods_id = GoodTypeId} = EtsGoodsType,
    case data_god_court:get_equip(GoodTypeId) of
        #base_god_court_equip{base_attr = BaseAttr, rare_attr = RareAttr, brilliant_attr = BrilliantAttr} ->
            F = fun({AttrId, AttrVal}, SumRating) ->
                OneAttrRating = data_attr:get_attr_base_rating(AttrId, 10),
                SumRating + OneAttrRating * AttrVal
                end,
            lists:foldl(F, 0, BaseAttr ++ RareAttr ++ BrilliantAttr);
        _ -> 0
    end.
%% 物品升成时计算评分
create_goods_other(GoodsInfo) when is_record(GoodsInfo, goods) ->
    #goods{goods_id = GoodTypeId, other = Other} = GoodsInfo,
    case data_god_court:get_equip(GoodTypeId) of
        #base_god_court_equip{base_attr = BaseAttr, rare_attr = RareAttr, brilliant_attr = BrilliantAttr} ->
            F = fun({AttrId, AttrVal}, SumRating) ->
                OneAttrRating = data_attr:get_attr_base_rating(AttrId, 10),
                SumRating + OneAttrRating * AttrVal
                end,
            Rating = lists:foldl(F, 0, BaseAttr ++ RareAttr ++ BrilliantAttr),
            Other#goods_other{rating = round(Rating)};
        _ -> Other
    end.

%% =======================解锁神庭=======================
unlock_court(Ps, CourtId) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId} = Ps,
    #god_court_status{god_court_list = CourtList, house_status = HouseStatus} = GodCourtStatus,
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        #god_court_item{is_active = ?IS_ACTIVE} -> {false, ?ERRCODE(err233_had_active)};
        #god_court_item{} = OldItem ->
            case data_god_court:get_court(CourtId) of
                [] -> {false, ?ERRCODE(err233_no_cfg)};
                #base_god_court{condition = Condition} ->
                    {god_house, NeedLv} = lists:keyfind(god_house, 1, Condition),
                    case HouseStatus#god_house_status.lv < NeedLv of
                        true -> {false, ?ERRCODE(err233_lv_limit)};
                        false ->
                            NewGodCourtItemTmp = OldItem#god_court_item{is_active = ?IS_ACTIVE},
                            NewGodCourtItem = cal_attr_power2(NewGodCourtItemTmp),
                            NewCourtList = lists:keystore(CourtId, #god_court_item.court_id, CourtList, NewGodCourtItem),
                            NewGodCourtStatusTmp = GodCourtStatus#god_court_status{god_court_list = NewCourtList},
                            NewGodCourtStatus = cal_attr_power1(NewGodCourtStatusTmp),
                            NewPs = Ps#player_status{god_court_status = NewGodCourtStatus},
                            save_court_item(RoleId, NewGodCourtItem),
                            LastPlayer = lib_player:count_player_attribute(NewPs),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                            {true, LastPlayer}
                    end
            end;
        _ -> {false, ?FAIL}
    end.

%% =======================装备神庭=======================
equip(Ps, GoodsStatus, CourtId, Pos, EquipId) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    case check_equip(GoodsStatus, CourtId, Pos, EquipId, CourtList) of
        {true, NewCourtItemTmp, GoodsInfo, OldGoodsInfo, IsReplace, EquipInfo} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                NewGoodsInfo = take_on_equip(GoodsInfo, CourtId),
                NewGoodsStatusTmp =
                    case IsReplace of
                        true ->
                            OldGoodsInfo1 = take_off_equip(OldGoodsInfo),
                            [_OldGoodsInfo2, GoodsStatus1] = lib_goods:change_goods_cell(OldGoodsInfo1, ?GOODS_LOC_GOD_COURT, 0, GoodsStatus),
                            [_NewGoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(NewGoodsInfo, ?GOODS_LOC_GOD_COURT_EQUIP, 0, GoodsStatus1),
                            GoodsStatus2;
                        false ->
                            [_NewGoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(NewGoodsInfo, ?GOODS_LOC_GOD_COURT_EQUIP, 0, GoodsStatus),
                            GoodsStatus2
                    end,
                {NewCourtItemTmp2, NewGoodsStatusTmp2, TakeOffCore} = after_equip(NewCourtItemTmp, NewGoodsStatusTmp, EquipId, Pos),
                #goods_status{dict = NewDictTmp} = NewGoodsStatusTmp2,
                {NewDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewDictTmp),
                NewGoodsStatus = NewGoodsStatusTmp2#goods_status{dict = NewDict},
                {true, GoodsL, NewGoodsStatus, NewCourtItemTmp2, TakeOffCore}
                end,
            case lib_goods_util:transaction(F) of
                {true, GoodsL, NewGoodsStatus, NewCourtItemTmp2, TakeOffCore} ->
                    ?IF(IsReplace, lib_goods_api:notify_client_num(RoleId, [OldGoodsInfo#goods{num=0}]), skip),
                    ?IF(TakeOffCore == [], skip,
                        begin
                            save_task_off_core(RoleId, NewCourtItemTmp2),
                            lib_goods_api:notify_client_num(RoleId, [TakeOffCore#goods{num=0}])
                        end),
                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]),
                    lib_goods_api:notify_client(Ps, GoodsL),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    {_, GoodsId, _, Stage} = EquipInfo,
                    save_court_item_equip(RoleId, CourtId, Pos, GoodsId, EquipId, Stage),
                    NewCourtItem = cal_attr_power2(NewCourtItemTmp2),
                    NewCourtList = lists:keystore(CourtId, #god_court_item.court_id, CourtList, NewCourtItem),
                    NewGodCourtStatusTmp = GodCourtStatus#god_court_status{god_court_list = NewCourtList},
                    NewGodCourtStatus = cal_attr_power1(NewGodCourtStatusTmp),
                    NewPs = Ps#player_status{god_court_status = NewGodCourtStatus},
                    %% 使魔触发
                    PSDemons = lib_demons_api:god_court_equip(NewPs),
                    LastPlayer = lib_player:count_player_attribute(PSDemons),
%%                    ?PRINT("Attr ~p ~n", [NewGodCourtStatus#god_court_status.sum_attr]),
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                    {true, LastPlayer};
                _Res ->
                    ?ERR("equip error ~p ~n", [_Res]),
                    {false, ?FAIL}
            end;
        Return -> Return
    end.

check_equip(GoodStatus, CourtId, Pos, EquipId, CourtList) ->
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        #god_court_item{is_active = ?IS_ACTIVE} = CourtItem ->
            #goods_status{dict = Dict} = GoodStatus,
            case lib_goods_util:get_goods(EquipId, Dict) of
                #goods{type = ?GOODS_TYPE_GOD_COURT, location = ?GOODS_LOC_GOD_COURT, subtype = SubType, goods_id = GoodsTypeId} = GoodsInfo ->
                    case check_equip_pos(Dict, CourtId, CourtItem, Pos, SubType) of
                        true ->
                            #god_court_item{equip_list = EquipList} = CourtItem,
                            {NewEquipList, OldGoodsInfo, Stage, IsReplace} = before_equip(Dict, Pos, EquipId, GoodsTypeId, EquipList),
                            NewCourtItem = CourtItem#god_court_item{equip_list = NewEquipList},
                            {true, NewCourtItem, GoodsInfo, OldGoodsInfo, IsReplace, {Pos, GoodsTypeId, EquipId, Stage}};
                        Return -> Return
                    end;
                _Res ->
                    ?PRINT("@@@Res :~p ~n", [_Res]),
                    {false, ?FAIL}
            end;
        _ -> {false, ?ERRCODE(err233_no_active)}
    end.

%% 脱装备
take_off_equip(GoodsInfo) when is_record(GoodsInfo, goods) ->
    #goods{other = Other} = GoodsInfo,
    NewGoodsInfo = GoodsInfo#goods{location = ?GOODS_LOC_GOD_COURT, other = Other#goods_other{skill_id = 0}},
    change_goods_other(NewGoodsInfo),
    NewGoodsInfo.

%% 穿装备
take_on_equip(GoodsInfo, CourtId) when is_record(GoodsInfo, goods) ->
    #goods{other = Other} = GoodsInfo,
    NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{skill_id = CourtId}, location = ?GOODS_LOC_GOD_COURT_EQUIP},
    change_goods_other(NewGoodsInfo),
    NewGoodsInfo.

%% 物品other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_GOD_COURT, other = Other}) ->
    #goods_other{skill_id = CourtId, optional_data = T} = Other,
    [?GOODS_OTHER_KEY_GOD_COURT, CourtId|T];

format_other_data(_) -> [].

%% 物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [CourtId|T]) ->
    Other#goods_other{skill_id = CourtId, optional_data = T}.

%% 更新物品信息
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

%% ============================================================
%% 检查装备的部位是否符合
%% 检查物品子类型时候能装备在对应的槽位
%% 如果是核心槽位的话，查看核心槽位是否对应（每个神庭的核心槽位不一致）
%% 装备核心时，还要判断其余纹章是否装备橙色（只有其他部位都是橙色才能装核心）
%% ============================================================
check_equip_pos(Dict, CourtId, CourtItem, Pos, SubType) ->
    case lists:keyfind(Pos, 1, ?POS_LIMIT) of
        {_, SubType} ->
            CorePosList = data_god_court:get_core_pos(),
            case lists:member(Pos, CorePosList) of
                true ->
                    #god_court_item{equip_list = EquipList} = CourtItem,
                    #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
                    case CorePos == Pos of
                        true -> check_all_origin(Dict, CorePos, EquipList);
                        _ -> {false, ?ERRCODE(err233_pos)}
                    end;
                false ->  true
            end;
        _ -> {false, ?ERRCODE(err233_pos)}
    end.

%% 检查装备是否都是达到橙色
check_all_origin(_Dict,_CorePos, []) -> true;
check_all_origin(Dict, CorePos, [{Pos,_,EquipId,_}|EquipList]) ->
    if
        CorePos == Pos -> check_all_origin(Dict, CorePos, EquipList);
        true ->
            case lib_goods_util:get_goods(EquipId, Dict) of
                #goods{color = Color} when Color >= 4 ->
                    check_all_origin(Dict, CorePos, EquipList);
                _Res ->
                    {false, ?ERRCODE(err233_pos_equip_origin)}
            end
    end.

%% ==================================================
%% 获取新的EquipList 和 修改物品状态
%% return {NewEquipList, 脱下前的物品信息, 装备阶数, IsReplace(是否有脱下装备)}
%% ==================================================
before_equip(Dict, Pos, EquipId, GoodsTypeId, EquipList) ->
    case lists:keyfind(Pos, 1, EquipList) of
        false ->
            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsTypeId, EquipId, 0}),
            {NewEquipList, [], 0, false};
        {_,_,GoodsAutoId,Stage} ->
            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsTypeId, EquipId, Stage}),
            case lib_goods_util:get_goods(GoodsAutoId, Dict) of
                #goods{} = TakeOffGoods ->
                    {NewEquipList, TakeOffGoods, Stage, true};
                _ -> {NewEquipList, [], 0, false}
            end
    end.

%% ====================================================
%% 穿戴装备之后判断是否需要卸下核心
%% 穿低阶替换高阶装备有可能会触发， 意义不大
%% @param EquipId 要的装备id
%% @return {NewCourtItem, NewGoodsStatus, TakeOffCore}
%% ====================================================
after_equip(CourtItem, GoodsStatus, EquipId, Pos) ->
    #god_court_item{equip_list = EquipList, court_id = CourtId} = CourtItem,
    #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
    if
       CorePos == Pos -> {CourtItem, GoodsStatus, []};
       true ->
           case ulists:keyfind(CorePos, 1, EquipList, {CorePos,0,0,0}) of
               {_,_,0,_} -> {CourtItem, GoodsStatus, []}; %% 无核心，跳过脱衣操作
               {_,_,GoodsId,Stage} ->
                   #goods_status{dict = GoodsDict} = GoodsStatus,
                   #goods{color = Color} = lib_goods_util:get_goods(EquipId, GoodsDict),
                   case Color >= 4 of
                       true -> %% 装备的装备橙色以上跳过
                           {CourtItem, GoodsStatus, []};
                       false -> %% 脱核心
                           TakeOffCore = lib_goods_util:get_goods(GoodsId, GoodsDict),
                           TakeOffCore1 = take_off_equip(TakeOffCore),
                           [_, GoodsStatus2] = lib_goods:change_goods_cell(TakeOffCore1, ?GOODS_LOC_GOD_COURT, 0, GoodsStatus),
                           NewEquipList = lists:keystore(CorePos, 1, EquipList, {CorePos, 0,0,Stage}),
                           NewCourtItem = CourtItem#god_court_item{equip_list = NewEquipList},
                           {NewCourtItem, GoodsStatus2, TakeOffCore}
                   end
           end
    end.

%% 保存被脱下的核心状态
save_task_off_core(RoleId, NewCourtItem) ->
    #god_court_item{court_id = CourtId, equip_list = EquipList} = NewCourtItem,
    #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
    case lists:keyfind(CorePos, 1, EquipList) of
        {CorePos, 0,0,Stage} ->
            save_court_item_equip(RoleId, CourtId, CorePos, 0, 0, Stage);
        _ -> skip
    end.

%% =======================神庭装备升阶=======================
stage_up(Ps, CourtId, Pos) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId, figure = #figure{name = Name}} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        #god_court_item{is_active = ?IS_ACTIVE} = CourtItem ->
            case check_stage_up(Ps, CourtItem, Pos) of
                {true, NewCourtItemTmp, Cost, EquipInfo} ->
                    case lib_goods_api:cost_object_list_with_check(Ps, Cost, god_court, "") of
                        {true, NewPsTmp} ->
                            {_, GoodsId, EquipId, NewStage} = EquipInfo,
                            save_court_item_equip(RoleId, CourtId, Pos, GoodsId, EquipId, NewStage),
                            lib_log_api:log_god_court_equip_stage(RoleId, Name,CourtId, Pos, NewStage - 1, NewStage, Cost),
                            NewCourtItem = cal_attr_power2(NewCourtItemTmp),
                            send_to_tv(RoleId, Name, NewCourtItem, NewCourtItemTmp), %% 发送传闻
                            NewCourtList = lists:keystore(CourtId, #god_court_item.court_id, CourtList, NewCourtItem),
                            NewGodCourtStatusTmp = GodCourtStatus#god_court_status{god_court_list = NewCourtList},
                            NewGodCourtStatus = cal_attr_power1(NewGodCourtStatusTmp),
                            NewPs = NewPsTmp#player_status{god_court_status = NewGodCourtStatus},
                            LastPlayer = lib_player:count_player_attribute(NewPs),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                            {true, LastPlayer, NewStage};
                        {false, ErrCode, _NPs} -> {false, ErrCode}
                    end;
                Return -> Return
            end;
        #god_court_item{} -> {false, ?ERRCODE(err233_no_active)};
        _ -> {false, ?FAIL}
    end.

check_stage_up(Ps, CourtItem, Pos) ->
    #god_court_item{equip_list = EquipList} = CourtItem,
    case lists:keyfind(Pos, 1, EquipList) of
        {_Pos, 0, 0, _Stage} -> {false, ?FAIL};
        {Pos, GoodsId, EquipId, Stage} ->
            case data_god_court:get_equip_stage(Stage) of
                #base_god_court_equip_stage{cost = []} -> {false, ?ERRCODE(err233_max_stage)};
                #base_god_court_equip_stage{cost = Cost} ->
                    case lib_goods_api:check_object_list(Ps, Cost) of
                        true ->
                            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsId, EquipId, Stage + 1}),
                            NewCourtItem = CourtItem#god_court_item{equip_list = NewEquipList},
                            {true, NewCourtItem, Cost, {Pos, GoodsId, EquipId, Stage + 1}};
                        Return -> Return
                    end;
                _ -> {false, ?ERRCODE(err233_no_cfg)}
            end
    end.

%% 判断套装状态是否增强
%% 发传闻
send_to_tv(RoleId, Name, NewCourtItem, OldCourtItem) ->
    #god_court_item{suit_list = NewSuitList, court_id = CourtId} = NewCourtItem,
    #god_court_item{suit_list = OldSuitList} = OldCourtItem,
    if
        NewSuitList == OldSuitList -> skip;
        true ->
            [begin
                 case lists:member({Stage, Num}, OldSuitList) of
                     true -> skip;  %% 当前套装没变，不发
                     false ->
                         #base_god_court_equip_stage{suit_attr = SuitAttr} = data_god_court:get_equip_stage(Stage),
                         case lists:keyfind(Stage, 1, OldSuitList) of
                             {_, OldNum} when OldNum >= Num -> skip; %% 这级阶数变少了也不发
                             _ ->   %% 阶数变多了或者新出的
                                 case lists:keyfind(Num, 1, SuitAttr) of
                                     false -> skip; %% 升阶了，但是没达到激活条件不发
                                     _ -> %% 发发发
                                         #base_god_court{name = CourtName} = data_god_court:get_court(CourtId),
                                         ?PRINT("send tv  ~p ~n", [1]),
                                         lib_chat:send_TV({all}, ?MOD_GOD_COURT, 1, [Name, RoleId, CourtName, Stage, Num])
                                 end
                         end
                 end
             end||{Stage, Num}<-NewSuitList]
    end.

%% =======================神庭升级=======================
lv_up(Ps, CourtId) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId, figure = #figure{name = Name}} = Ps,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    case check_lv_up(Ps, CourtId, CourtList) of
        {true, NewCourtItemTmp, Cost, NewLv} ->
            case lib_goods_api:cost_object_list_with_check(Ps, Cost, god_court, "") of
                {true, NewPsTmp} ->
                    NewCourtItem = cal_attr_power2(NewCourtItemTmp),
                    save_court_item(RoleId, NewCourtItem),
                    lib_log_api:log_god_court_strength(RoleId, Name, CourtId, NewLv - 1, NewLv, Cost),
                    NewCourtList = lists:keystore(CourtId, #god_court_item.court_id, CourtList, NewCourtItem),
                    NewGodCourtStatusTmp = GodCourtStatus#god_court_status{god_court_list = NewCourtList},
                    NewGodCourtStatus = cal_attr_power1(NewGodCourtStatusTmp),
                    NewPs = NewPsTmp#player_status{god_court_status = NewGodCourtStatus},
                    LastPlayer = lib_player:count_player_attribute(NewPs),
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                    {true, LastPlayer, NewLv};
                {false, ErrCode, _NPs} -> {false, ErrCode}
            end;
        Return -> Return
    end.

check_lv_up(Ps, CourtId, CourtList) ->
    case lists:keyfind(CourtId, #god_court_item.court_id, CourtList) of
        #god_court_item{is_active = ?IS_ACTIVE, lv = OldLv} = CourtItem ->
            case data_god_court:get_court_strength(OldLv) of
                #base_god_court_strength{cost = []} -> {false, ?ERRCODE(err233_max_lv)};
                #base_god_court_strength{cost = Cost} ->
                    case lib_goods_api:check_object_list(Ps, Cost) of
                        true ->
                            NewLv = OldLv + 1,
                            {true, CourtItem#god_court_item{lv = NewLv}, Cost, NewLv};
                        Return -> Return
                    end;
                _ -> {false, ?FAIL}
            end;
        #god_court_item{} -> {false, ?ERRCODE(err233_no_active)};
        _ -> {false, ?FAIL}
    end.

%% =======================水晶升橙=======================
house_up_origin(Ps) ->
    #player_status{god_court_status = GodCourtStatus, id = RoleId, figure = #figure{name = Name}} = Ps,
    #god_court_status{house_status = HouseStatus} = GodCourtStatus,
    case check_house_up(Ps, HouseStatus) of
        {true, Cost, NewHouseStatus} ->
            case lib_goods_api:cost_object_list_with_check(Ps, Cost, god_house_crytal , "") of
                {true, NewPs} ->
                    save_god_house(RoleId, NewHouseStatus),
                    lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_GOD_COURT, 2,1),
                    #god_house_status{sum_num = SumNum, daily_num = DailyNum} = NewHouseStatus,
                    lib_log_api:log_god_house_origin(RoleId, Name, HouseStatus#god_house_status.crystal_color, Cost, DailyNum, SumNum),
                    NewCourtStatus = GodCourtStatus#god_court_status{house_status = NewHouseStatus},
                    LastPlayer = NewPs#player_status{god_court_status = NewCourtStatus},
                    {true, LastPlayer};
                {false, ErrCode, _NPs} -> {false, ErrCode}
            end;
        Return -> Return
    end .

check_house_up(Ps, HouseStatus) ->
    #god_house_status{
        sum_num = OldSunNum,
        daily_num = OldDailyNum,
        crystal_color = OldColor,
        grand_status = OldGrandStatus
    } = HouseStatus,
    case data_god_court:get_house_crystal(OldColor) of
        #base_god_house_crystal{origin_cost = []} ->
            {false,?IF(OldColor == 4,?ERRCODE(err_233_had_origin), ?ERRCODE(err_233_max_color))};
        #base_god_house_crystal{origin_cost = Cost} ->
            case lib_goods_api:check_object_list(Ps, Cost) of
                true ->
                    NewGrandStatus = flush_grand_status(OldGrandStatus, OldDailyNum + 1),
                    NewHouseStatus = HouseStatus#god_house_status{
                        sum_num = OldSunNum + 1,
                        daily_num = OldDailyNum + 1,
                        crystal_color = ?ORIGIN_COLOR,
                        grand_status = NewGrandStatus
                    },
                    {true, Cost, NewHouseStatus};
                Return -> Return
            end;
        _ -> {false, ?FAIL}
    end.

%% 刷新水晶状态
flush_grand_status(GrandStatus, DailyNum) ->
    [begin
         case Status == ?NO_GET andalso DailyNum >= Times of
             true -> {Times, ?CAN_GET};
             _ -> {Times, Status}
         end
     end||{Times, Status}<-GrandStatus].

%% =======================开水晶啊开水晶=======================
open_crystal(Ps) ->
    #player_status{god_court_status = CourtStatus, id = RoleId, figure = #figure{name = Name}} = Ps,
    #god_court_status{house_status = HouseStatus} = CourtStatus,
    #god_house_status{lv = OldLv, exp = OldExp, crystal_color = OldColor} = HouseStatus,
    case check_open_crystal(Ps, HouseStatus) of
        {true, NewHouseStatus, Rewards, Cost} ->
            case lib_goods_api:cost_object_list_with_check(Ps, Cost, god_house_crytal, "") of
                {true, NewPs} ->
                    NewCourtStatus = CourtStatus#god_court_status{house_status = NewHouseStatus},
                    ?IF(OldColor >= ?ORIGIN_COLOR,
                        lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_GOD_COURT, 1,1),
                        skip),
                    save_god_house(RoleId, NewHouseStatus),
                    %% 记录抽奖次数
                    ?IF(OldColor == ?ORIGIN_COLOR, mod_daily:increment(RoleId, ?MOD_GOD_COURT, 1), skip),
                    #god_house_status{lv = NowLv, exp = NowExp, crystal_color = NowColor} = NewHouseStatus,
                    lib_log_api:log_god_house_crystal(RoleId, Name, OldColor, NowColor, OldLv, OldExp, NowLv, NowExp, Cost, Rewards),
                    lib_goods_api:send_reward_by_id(Rewards, god_house_crytal, RoleId),
                    LastPs = NewPs#player_status{god_court_status = NewCourtStatus},
                    {true, LastPs, NewHouseStatus, Rewards};
                {false, ErrCode, _NPs} -> {false, ErrCode}
            end;
        Return -> Return
    end.

check_open_crystal(Ps, HouseStatus) ->
    #god_house_status{lv = OldLv,exp = OldExp, crystal_color = OldColor} = HouseStatus,
    case lib_goods_api:check_object_list(Ps, ?CRYSTAL_COST) of
        true ->
            case data_god_court:get_house_crystal(OldColor) of
                #base_god_house_crystal{exp = AddExp, weight = Weight, must_reward = MustReward, random_reward = RandReward, random_reward2 = RandReward2} ->
                    {NewLv, NewExp} = cal_new_lv_exp(OldLv, OldExp, AddExp),
                    %% 某个奖池每天前n次开橙色水晶走特殊kv定制的奖池
                    Num = mod_daily:get_count(Ps#player_status.id, ?MOD_GOD_COURT, 1),
                    RandReward1 = ?IF(Num < ?SPECIAL_OPEN_TIMES andalso OldColor == ?ORIGIN_COLOR,
                        ?SPECIAL_OPEN_REWARDS, RandReward),

                    Reward = cal_crystal_reward(MustReward, RandReward1, RandReward2),
                    WeightList = [{Wg, Atom}||{Atom, Wg} <- Weight],
                    NewColor =
                        case urand:rand_with_weight(WeightList) of
                            up -> OldColor + 1;
                            down -> OldColor -1;
                            _ ->
                                ?ERR("weight reward err ~p ~n", [WeightList]),
                                OldColor
                        end,
                    NewHouseStatus = HouseStatus#god_house_status{lv = NewLv, exp = NewExp, crystal_color = NewColor},
                    {true, NewHouseStatus, Reward, ?CRYSTAL_COST};
                _ -> {false, ?FAIL}
            end;
        Return -> Return
    end.

%% 添加的经验 调整神之所经验等级
%% return {NewLv, NewExp}
cal_new_lv_exp(OldLv, OldExp, AddExp) ->
    case data_god_court:get_house_lv(OldLv + 1) of
        #base_god_house_lv{exp = NeedExp} ->
            ?IF(AddExp + OldExp >= NeedExp,
                {OldLv + 1, AddExp + OldExp - NeedExp},
                {OldLv, OldExp + AddExp});
        _ -> {OldLv, OldExp + AddExp}
    end.

%% 计算获取水晶奖励
cal_crystal_reward(MustReward, RandReward, RandReward2) ->
    WeightList =
        [{Weight, {GoodsType,GoodsId,GoodsNum}} ||
            {GoodsType,GoodsId,GoodsNum,Weight} <- RandReward],
    WeightList2 =
        [{Weight, {GoodsType,GoodsId,GoodsNum}} ||
            {GoodsType,GoodsId,GoodsNum,Weight} <- RandReward2],
    Reward1 =
        case urand:rand_with_weight(WeightList) of
            {_,_,_} = Reward -> [Reward];
            _ ->
                ?ERR("weight reward err ~p ~n", [WeightList]),
                []
        end,
    Reward2 =
        case urand:rand_with_weight(WeightList2) of
            {_,_,_} = Rewardd -> [Rewardd];
            _ ->
                ?ERR("weight reward err ~p ~n", [WeightList2]),
                []
        end,
    MustReward ++ Reward1 ++ Reward2.

%% =======================领取每日升橙累计奖励=======================
get_grand_origin_reward(Ps, Times) ->
    #player_status{god_court_status = CourtStatus, id = RoleId, figure = #figure{name = Name}} = Ps,
    #god_court_status{house_status = HouseStatus} = CourtStatus,
    #god_house_status{grand_status = GrandStatus, sum_num = SumNum, daily_num = DailyNum} = HouseStatus,
    case lists:keyfind(Times, 1, GrandStatus) of
        {_, ?NO_GET} -> {false, ?ERRCODE(err233_no_condition)};
        {_, ?HAD_GET} -> {false, ?ERRCODE(err233_had_get)};
        {_, ?CAN_GET} ->
            LvList = data_god_court:get_house_reward_lvs(),
            {RewardLv, RewardPool} = get_reward_pool(SumNum, LvList),
            WeightList = [{Weight, {GoodsType, GoodsId, GoodsNum}}||{GoodsType, GoodsId, GoodsNum, Weight} <- RewardPool],
            case urand:rand_with_weight(WeightList) of
                {_,_,_} = Reward ->
                    NewGrandStatus = lists:keystore(Times, 1, GrandStatus, {Times, ?HAD_GET}),
                    NewHouseStatus = HouseStatus#god_house_status{grand_status = NewGrandStatus},
                    NewCourtStatus = CourtStatus#god_court_status{house_status = NewHouseStatus},
                    NewPs = Ps#player_status{god_court_status = NewCourtStatus},
                    save_god_house(RoleId, NewHouseStatus),
                    lib_log_api:log_god_house_reward(RoleId, Name, Times, DailyNum, RewardLv, Reward),
                    lib_goods_api:send_reward_by_id([Reward], god_house_crytal, RoleId),
                    {true, NewPs, [Reward]};
                _ ->
                    ?ERR("weight reward err ~p ~n", [WeightList]),
                    {false, ?FAIL}
            end;
        _ -> {false, ?ERRCODE(err233_no_reward)}
    end.

%% 根据生橙总次数获取奖励池
get_reward_pool(_SumNum, [LastLv]) -> %% 保证超过配置最大次数也有奖励
    #base_god_house_reward{reweard_pool = RewardPool} = data_god_court:get_house_reward(LastLv),
    {LastLv, RewardPool};
get_reward_pool(SumNum, [Lv|T]) ->
    #base_god_house_reward{
        down_num = DwNum,
        up_num = UpNum,
        reweard_pool = RewardPool} = data_god_court:get_house_reward(Lv),
    case SumNum >= DwNum andalso SumNum =< UpNum of
        true -> {Lv,RewardPool};
        false -> get_reward_pool(SumNum, T)
    end.

%% ====================================================
%%   属性战力汇总计算(高频调用)
%% ====================================================
cal_attr_power1(GodCourtStatus) when is_record(GodCourtStatus, god_court_status) ->
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    F = fun(#god_court_item{sum_attr = ItemAttr}, SumAttr) ->
            lib_player_attr:add_attr(list, [ItemAttr, SumAttr])
        end,
    Attr = lists:foldl(F, [], CourtList),
    GodCourtStatus#god_court_status{sum_attr = Attr}.
cal_attr_power2(CourtItem) when is_record(CourtItem, god_court_item) ->
    #god_court_item{
        lv = Lv,
        equip_list = EquipList,
        is_active = IsActive
    } = CourtItem,
    case IsActive of
        ?IS_ACTIVE ->
            StrengthAttr = case data_god_court:get_court_strength(Lv) of
                               #base_god_court_strength{attr = StrengthAtt} -> StrengthAtt;
                               _ -> []
                           end,
            {SuitList, SuitAttr, StageAttr, {StageExtraBaseAttr, EquipAttr}} = cal_stage_status(EquipList),
            SumAttr = StrengthAttr ++ SuitAttr ++ StageAttr ++ EquipAttr,
            BrilliantExtraBaseAttr = cal_special_attr_percent(EquipAttr),
%%          ?PRINT("SuitList, ~p ~n SuitAttr ~p ~n StageAttr ~p ~n StageExtraBaseAttr ~p ~n", [SuitList, SuitAttr,StageAttr,StageExtraBaseAttr]),
%%          ?MYLOG("zh_god", "StageExtraBaseAttr ~p ~n StrengthAttr ~p ~n SuitAttr ~p ~n StageAttr ~p ~n EquipAttr ~p ~n BrilliantExtraBaseAttr ~p ~n ",
%%          [StageExtraBaseAttr, StrengthAttr, SuitAttr, StageAttr, EquipAttr,BrilliantExtraBaseAttr]),
            CourtItem#god_court_item{
                lv_attr = StrengthAttr,
                equip_attr = EquipAttr,
                stage_attr = StageAttr,
                sum_attr = SumAttr ++ StageExtraBaseAttr ++ BrilliantExtraBaseAttr,
                suit_list = SuitList
            };
        _ -> CourtItem
    end.


%% ==================================================================
%%   装备列表属性汇总，每次装备变动需要调用,登陆加载也需调用
%%   @return {套装状态, 套装提供的属性加成, 升阶总属性加成, {升阶带来的装备额外基础属性,装备属性加成}}
%% ==================================================================
cal_stage_status(EquipList) ->
    F = fun({_Pos, GoodsId, _EquipId, Stage}, {Map, GrandAttr, {GrandExtraAttr, GrandAttr2}}) ->
        FA = fun(StageA, MapA) ->
            Num = maps:get(StageA, MapA, 0),
            maps:put(StageA, Num + 1, MapA)
        end,
        NewMap = lists:foldl(FA, Map, lists:seq(1, Stage)),
        AddAttr = case data_god_court:get_equip_stage(Stage) of
                      #base_god_court_equip_stage{attr = AttrPos} ->
%%                          ulists:keyfind(Pos, 1, AttrPos, []);
                          AttrPos;
                      _ -> []
                  end,
        {ExtraAddAttr, AddAttr2} = case data_god_court:get_equip(GoodsId) of
                       #base_god_court_equip{base_attr = BAttr, rare_attr = RAttr, brilliant_attr = BrAttr} ->
                           ExtraBAttr = get_stage_extra_attr(BAttr, AddAttr),
                           {ExtraBAttr, lib_player_attr:add_attr(list, [BAttr, RAttr, BrAttr])};
                       _ -> {[],[]}
                   end,
        {NewMap, lib_player_attr:add_attr(list,[AddAttr,GrandAttr]), {lib_player_attr:add_attr(list,[ExtraAddAttr, GrandExtraAttr]), lib_player_attr:add_attr(list,[AddAttr2,GrandAttr2])}}
        end,
    {StageMap, StageAttr, EquipAttr} = lists:foldl(F, {#{}, [], {[], []}}, EquipList),
    HighestMap = cale_highest_suit_by_stage(StageMap),
    %% 套装属性计算
    F2 = fun(Stage, Num, {SuitList, SuitAttr}) ->
        case data_god_court:get_equip_stage(Stage) of
            #base_god_court_equip_stage{suit_attr = []} ->
                {SuitList, SuitAttr};
            #base_god_court_equip_stage{suit_attr = SAttrs} ->
                {SuitListTmp, SuitAttrTmp} = cal_suit_list_core(Stage, Num, SAttrs, HighestMap, {[],[]}),
                {SuitList ++ SuitListTmp, lib_player_attr:add_attr(list,[SuitAttr, SuitAttrTmp])};
            _Res ->
                {SuitList, SuitAttr}
        end
        end,
    {LastSuitList, LastSuitAttr} = maps:fold(F2, {[], []}, StageMap),
    {LastSuitList, LastSuitAttr, StageAttr, EquipAttr}.

cal_suit_list_core(_Stage, _Num, [], _HighestMap, {List, Attr}) -> {List, Attr};
cal_suit_list_core(Stage, Num, [StageAttr|T], HighestMap, {List, Attr}) ->
    {NeedNum, AddAttr} = StageAttr,
    MaxStage = maps:get(NeedNum, HighestMap, 0),
    if
        NeedNum =< Num ->
            NewAttr = ?IF(MaxStage =:= Stage, Attr ++ AddAttr, Attr),
            cal_suit_list_core(Stage, Num, T, HighestMap, {lists:keystore(Stage, 1, List, {Stage, Num}), NewAttr});
        true -> cal_suit_list_core(Stage, Num, T, HighestMap, {List, Attr})
    end.

cale_highest_suit_by_stage(StageMap) ->
    F = fun(Stage, Num, HighestMap) ->
        if
            Num >= 3 andalso Num < 5 ->
                StageA = maps:get(3, HighestMap, 0),
                ?IF(Stage > StageA, maps:put(3, Stage, HighestMap), HighestMap);
            Num >= 5 andalso Num < 8 ->
                StageA = maps:get(3, HighestMap, 0),
                NewHighestMapA = ?IF(Stage > StageA, maps:put(3, Stage, HighestMap), HighestMap),
                StageB = maps:get(5, NewHighestMapA, 0),
                ?IF(Stage > StageB, maps:put(5, Stage, NewHighestMapA), NewHighestMapA);
            Num =:= 8 ->
                StageA = maps:get(3, HighestMap, 0),
                NewHighestMapA = ?IF(Stage > StageA, maps:put(3, Stage, HighestMap), HighestMap),
                StageB = maps:get(5, NewHighestMapA, 0),
                NewHighestMapB = ?IF(Stage > StageB, maps:put(5, Stage, NewHighestMapA), NewHighestMapA),
                StageC = maps:get(8, NewHighestMapB, 0),
                ?IF(Stage > StageC, maps:put(8, Stage, NewHighestMapB), NewHighestMapB);
            true -> HighestMap
        end
    end,
    maps:fold(F, #{}, StageMap).

%% ====================================================
%% 根据升阶属性的特殊属性，计算额外的装备基础属性(万分比)
%% ====================================================
get_stage_extra_attr(BaseAttr, StageAttr) ->
    case lists:filter(fun({SAttrId, _}) -> lists:member(SAttrId, ?STAGE_SPECIAL_ATTR_LIST) end, StageAttr) of
        [] -> [];
        [{_, PercentValue}] ->
            lists:map(fun({AttrId, AttrVal}) ->
                        {AttrId, round(PercentValue / 10000 * AttrVal)}
                    end,BaseAttr)
    end.

%% ====================================================
%% 根据装备总汇的特殊属性，计算出额外属性
%% ====================================================
cal_special_attr_percent(EquipAttr) ->
    BrilliantAttrList = lists:filter(fun({AttrId, _}) -> lists:member(AttrId, ?BRILLIANT_ATTR_LIST) end, EquipAttr),
    F = fun({SpeAttrId, SpeAttrVal}, ExtraList) ->
            case SpeAttrId of
                ?COURT_ATTR_ATT_327 ->
                    get_special_extra_attr(EquipAttr, ?ATT, SpeAttrVal) ++ ExtraList;
                ?COURT_ATTR_HP_328 ->
                    get_special_extra_attr(EquipAttr, ?HP, SpeAttrVal) ++ ExtraList;
                ?COURT_ATTR_WRECK_329 ->
                    get_special_extra_attr(EquipAttr, ?WRECK, SpeAttrVal) ++ ExtraList;
                ?COURT_ATTR_DEF_330 ->
                    get_special_extra_attr(EquipAttr, ?DEF, SpeAttrVal) ++ ExtraList;
                _ -> ExtraList
            end
        end,
    lists:foldl(F, [], BrilliantAttrList).

get_special_extra_attr(EquipAttr, AttrId, Percent) ->
    case lists:keyfind(AttrId, 1, EquipAttr) of
        false -> [];
        {_, Val} -> [{AttrId, round(Percent / 10000 * Val)}]
    end.

%% ================================
%% 获取要重置的凌晨4点时间
%% ================================
get_reset_time() ->
    Now = utime:unixtime(),
    ZeroTime = utime:unixdate(Now), %% 今天凌晨
    FourClock = ZeroTime + 4*3600, %% 今天4点
    Week = utime:day_of_week(),
    TomorrowDayFourClock = FourClock + (8 - Week)  * ?ONE_DAY_SECONDS,  %% 明天4点
    ?IF(Now > FourClock, TomorrowDayFourClock, FourClock).


%% ====================================================
%%   Database Function
%% ====================================================
save_court_item(RoleId, GodCourtItem) ->
    #god_court_item{
        court_id = CourtId,
        is_active = IsActive,
        lv = Lv
    } = GodCourtItem,
    save_court_item(RoleId, CourtId, IsActive, Lv).
save_court_item(RoleId, CourtId, IsActive, Lv) ->
    Sql = io_lib:format(?sql_save_court_item, [RoleId, CourtId, IsActive, Lv]),
%%    ?MYLOG("zh_god", "sql_save_court_item : '~s' ~n", [Sql]),
    db:execute(Sql).

save_court_item_equip(RoleId, CourtId, Pos, GoodsId, EquipId, Stage) ->
    Sql = io_lib:format(?sql_save_court_item_equip, [RoleId, CourtId, Pos, GoodsId, EquipId, Stage]),
%%    ?MYLOG("zh_god", "save_court_item_equip : '~s' ~n", [Sql]),
    db:execute(Sql).

save_god_house(RoleId, HouseStatus) ->
    #god_house_status{
        lv = Lv,
        exp = Exp,
        sum_num = SumNum,
        daily_num = DailyNum,
        crystal_color = Color,
        grand_status = GrandStatus,
        reset_time = ResetTime
    } = HouseStatus,
    Sql = io_lib:format(?sql_save_god_house, [RoleId, Lv, Exp, SumNum, DailyNum, Color, util:term_to_bitstring(GrandStatus), ResetTime]),
%%    ?MYLOG("zh_god", "save_god_house : '~s' ~n", [Sql]),
    db:execute(Sql).

%%============== 优化 ==================
get_equip_list(CourtEquipList_, CourtId) ->
    CourtEquipList = [{Pos, GoodsId, EquipId, Stage}||[CourtId_, Pos, GoodsId, EquipId, Stage]<-CourtEquipList_, CourtId_ == CourtId],
    if
        CourtEquipList =/= [] -> CourtEquipList;
        true ->
            #base_god_court{core_pos = CorePos} = data_god_court:get_court(CourtId),
            Poss = ?GOD_POS_LIST ++ [CorePos],
            [{Pos, 0, 0, 0}||Pos <- Poss]
    end.

get_equip_by_color(PS, Color) ->
    #player_status{god_court_status = GodCourtStatus} = PS,
    #god_court_status{god_court_list = CourtList} = GodCourtStatus,
    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
    F = fun(#god_court_item{equip_list = EquipList, is_active = IsActive}, Acc) ->
        case IsActive == ?IS_ACTIVE of 
            true ->
                F2 = fun({_,_,EquipId,_}, Acc2) ->
                    GoodsInfo = lib_goods_util:get_goods(EquipId, Dict),
                    case GoodsInfo of 
                        #goods{color = Color1} when Color1 >= Color -> [GoodsInfo|Acc2];
                        _ -> Acc2
                    end
                end,
                lists:foldl(F2, Acc, EquipList);
            _ ->
                Acc
        end
    end,
    lists:foldl(F, [], CourtList).
    