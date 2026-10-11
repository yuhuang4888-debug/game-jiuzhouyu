%% ---------------------------------------------------------------------------
%% @doc lib_constellation_forge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/4
%% @deprecated   星宿锻造（强化，进化，附魔，启灵
%% ---------------------------------------------------------------------------
-module(lib_constellation_forge).

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("constellation_forge.hrl").
-include("constellation_equip.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
%% API
-compile([export_all]).

login(RoleId, GoodsDict, Constellation) ->
    #constellation_status{constellation_list = ConstellationList} = Constellation,
    {ForgeList, SMasterList, EMasterList} = db_load_role_info(RoleId),
    NewConstellationList = [ load_forge_info(RoleId, GoodsDict, ConstellationItem, ForgeList, SMasterList, EMasterList)
        || ConstellationItem <- ConstellationList],
    Constellation#constellation_status{constellation_list = NewConstellationList}.

load_forge_info(RoleId, GoodsDict, ConstellationItem, ForgeList, SMasterList, EMasterList) when is_record(ConstellationItem, constellation_item) ->
    #constellation_item{id = EquipType, pos_equip = PosEquips} = ConstellationItem,
    NewPosEquips = trans_pos(PosEquips),
    NewEquipList = load_equip_list(ForgeList, RoleId, GoodsDict, EquipType, NewPosEquips, []),
%%    OldStrengthAttr = cal_forge_attr(NewEquipList, strength),
%%    OldEvolutionAttr = cal_forge_attr(NewEquipList, evolution),
%%    OldEnchantmentAttr = cal_forge_attr(NewEquipList, enchantment),
%%    OldSpiritAttr = cal_forge_attr(NewEquipList, spirit),
    {OldStrengthAttr, OldEvolutionAttr, OldEnchantmentAttr, OldSpiritAttr} = cal_forge_attr(NewEquipList, all),

    StrenMaster = get_strength_master(SMasterList, EquipType),
    EnchaMaster = get_enchantment_master(EMasterList, EquipType),
    {EMasterAttr, NewStrengthAttr, NewEvolutionAttr} =
        get_enchantment_master_attr(EnchaMaster, EquipType, 0, OldStrengthAttr, OldEvolutionAttr),
    NewConstellationItem = ConstellationItem#constellation_item{
        equip_list = NewEquipList,
        strength_attr = NewStrengthAttr,
        evolution_attr = NewEvolutionAttr,
        enchantment_attr = OldEnchantmentAttr,
        spirit_attr = OldSpiritAttr,
        strength_master = StrenMaster,
        strength_master_attr = get_strength_master_attr(StrenMaster, EquipType, 0),
        strength_buff = get_strength_buff(StrenMaster, EquipType, 0),
        strength_buff_attr = get_strength_buff_attr(StrenMaster, EquipType, 0),
        enchantment_master = EnchaMaster,
        enchantment_master_attr = EMasterAttr
    },
    NewConstellationItem;
load_forge_info(_RoleId, _, _,_,_,_) -> #constellation_item{}.

trans_pos(PosEquips) ->
    Poses = data_constellation_equip:get_all_pos(),
    [begin
         ulists:keyfind(Pos, 1, PosEquips, {Pos,0})
     end||Pos <- Poses].

load_equip_list(_ForgeList, _RoleId, _GoodsDict, _EquipType, [], ResList) -> ResList;
load_equip_list(ForgeList, RoleId, GoodsDict, EquipType, [{Pos, GoodsAutoId}|Other], ResList) ->
%%    {StrengthLv, EnchantmentLv, IsSpirit} = db_get_constellation_forge(RoleId, EquipType, Pos),
    {StrengthLv, EnchantmentLv, IsSpirit} = get_constellation_forge(ForgeList, EquipType, Pos),
    #base_constellation_strength{attr = StrengthAttr} =
        data_constellation_forge:get_strength_cfg(EquipType, Pos, StrengthLv),
    SpecialAttr = get_strength_special_attr(EquipType, Pos, StrengthLv, []),
    #base_constellation_enchantment{attr = EnchantmentAttr} =
        data_constellation_forge:get_enchantment_cfg(EquipType, Pos, EnchantmentLv),

    SpiritAttr = case IsSpirit of
        1 ->
            #base_constellation_spirit{attr = SpiritAtt} = data_constellation_forge:get_spirit_cfg(EquipType, Pos),
            SpiritAtt;
        _ -> []
    end,

    {EvolutionLv, EvolutionAttr} = load_evolution_info(RoleId, GoodsDict, EquipType, Pos, GoodsAutoId),
    Item = #constellation_forge{
        equip_id = GoodsAutoId,
        pos = Pos,
        strength_lv = StrengthLv,
        strength_attr = lib_player_attr:add_attr(list, [StrengthAttr, SpecialAttr]),
        evolution_lv = EvolutionLv,
        evolution_attr = EvolutionAttr,
        enchantment_lv = EnchantmentLv,
        enchantment_attr = EnchantmentAttr,
        is_spirit = IsSpirit,
        spirit_attr = SpiritAttr
    },
    load_equip_list(ForgeList, RoleId, GoodsDict, EquipType, Other, [Item|ResList]).

load_evolution_info(_RoleId, GoodsDict, EquipType, Pos, GoodsAutoId) ->
    GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
    case GoodsInfo of
        #goods{other = #goods_other{stren = EvolutionLv}} ->
            case data_constellation_forge:get_evolution_cfg(EquipType, Pos, EvolutionLv) of
                #base_constellation_evolution{attr = EvolutionAttr} -> {EvolutionLv, EvolutionAttr};
                _ -> {0, []}
            end ;
        _ -> {0, []}
    end .

get_strength_master_attr([], EquipType, RLv) ->
    sum_strength_master_attr(EquipType, RLv);
get_strength_master_attr([{Lv, Status}|Other], EquipType, RLv) ->
    case Status of
        ?MASTER_ACTIVED ->
            ?IF(Lv > RLv,
                get_strength_master_attr(Other, EquipType, Lv),
                get_strength_master_attr(Other, EquipType, RLv));
        _ -> get_strength_master_attr(Other, EquipType, RLv)
    end.

sum_strength_master_attr(EquipType, MaxLv) ->
    Lvs = data_constellation_forge:get_strength_master_lv(EquipType),
    F = fun(Lv, ResAttr) ->
        case Lv =< MaxLv of
            true ->
                #base_constellation_strength_master{attr = Attr} = data_constellation_forge:get_strength_master(EquipType, Lv),
                lib_player_attr:add_attr(list, [Attr, ResAttr]);
            _ -> ResAttr
        end
        end,
    lists:foldl(F, [], Lvs).

get_strength_buff(_, _, _) -> 0.
get_strength_buff_attr(_, _, _) -> [].

%% 需要计算百分比加成
get_enchantment_master_attr([], EquipType, RLv, OldStrengthAttr, OldEvolutionAttr) ->
    EnchantmentAttr = sum_enchantment_master_attr(EquipType, RLv),
    cal_percent_attr(EnchantmentAttr, OldStrengthAttr, OldEvolutionAttr);
get_enchantment_master_attr([{Lv, Status}|Other], EquipType, RLv, OldStrengthAttr, OldEvolutionAttr) ->
    case Status of
        ?MASTER_ACTIVED ->
            ?IF(Lv > RLv,
                get_enchantment_master_attr(Other, EquipType, Lv, OldStrengthAttr, OldEvolutionAttr),
                get_enchantment_master_attr(Other, EquipType, RLv, OldStrengthAttr, OldEvolutionAttr));
        _ -> get_enchantment_master_attr(Other, EquipType, RLv, OldStrengthAttr, OldEvolutionAttr)
    end.

sum_enchantment_master_attr(EquipType, MaxLv) ->
    Lvs = data_constellation_forge:get_enchantment_master_lv(EquipType),
    F = fun(Lv, ResAttr) ->
        case Lv =< MaxLv of
            true ->
                #base_constellation_enchantment_master{attr = Attr} = data_constellation_forge:get_enchantment_master(EquipType, Lv),
                lib_player_attr:add_attr(list, [Attr, ResAttr]);
            _ -> ResAttr
        end
        end,
    lists:foldl(F, [], Lvs).

%% 根据附魔大师情况 获强化属性和进化属性 增幅百分比之后的属性
cal_percent_attr([], OldStrengthAttr, OldEvolutionAttr) -> {[], OldStrengthAttr, OldEvolutionAttr};
cal_percent_attr(Attr, OldStrengthAttr, OldEvolutionAttr) ->
    {_,Percent1} = ulists:keyfind(?STRENGTH_PERCENT_ATTR,1,Attr,{0,0}),
    NewStrengthAttr = [begin
                           case lists:member(AttrId, ?NEED_PERCENT_ATTRS) of
                               false -> {AttrId, AttVal};
                               true -> {AttrId, round(AttVal * (1 + Percent1 / 10000))}
                           end
                       end||{AttrId, AttVal} <- OldStrengthAttr],

    {_,Percent2} = ulists:keyfind(?EVOLUTION_PERCENT_ATTR,1,Attr,{0,0}),
    NewEvolutionAttr = [begin
                            case lists:member(AttrId1, ?NEED_PERCENT_ATTRS) of
                                false -> {AttrId1, AttVal1};
                                true ->
                                    {AttrId1, round(AttVal1 * (1 + Percent2 / 10000))}
                            end
                        end||{AttrId1, AttVal1} <- OldEvolutionAttr],
    {Attr, NewStrengthAttr, NewEvolutionAttr}.

%==============================login_end========================================
%% 强化界面
strength_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
%%    StrengthList = get_equip_status_list(ConstellationList, EquipType, strength),
%%    {_, NextMasterLv} = cal_strength_master(ConstellationList, EquipType),
    #constellation_item{equip_list = EquipList, enchantment_master_attr = EnchantMasterAttr} =
        get_constellation_item(ConstellationList, EquipType),
    StrengthList = [{EquipId, Pos, Lv} ||#constellation_forge{equip_id = EquipId, pos = Pos, strength_lv = Lv} <- EquipList],
    {_, AddPercent} = ulists:keyfind(?STRENGTH_PERCENT_ATTR, 1, EnchantMasterAttr, {?STRENGTH_PERCENT_ATTR, 0}),
    PercentStatus = round((10000 + AddPercent)/100),
    {NextMasterLv, IsMax} = cal_strength_status(ConstellationList, EquipType),
    lib_server_send:send_to_uid(RoleId, pt_232, 23210, [?SUCCESS, EquipType, NextMasterLv, IsMax, PercentStatus, StrengthList]),
    ok.

%% 强化
strength(PS, EquipType, Pos, Type) ->
    #player_status{constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    StrengthList = get_equip_status_list(ConstellationList, EquipType, strength),
    case lists:keyfind(Pos, 2, StrengthList) of
        {_EquipId, Pos, OldLv} ->
            case check_strength(PS, EquipType, Pos, OldLv) of
                {true, NexLv, Cost} ->
                    strength_done(PS, EquipType, Pos, Type, NexLv, Cost);
                {false, ErrorCode} -> {false, ErrorCode}
            end;
        false -> {false, ?FAIL}
    end.

%% 强化大师界面
strength_master_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    MasterList = case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        #constellation_item{strength_master = Master} -> Master;
        _ -> []
    end,
    ?PRINT("@@@@@@@MasterList ~p ~n", [MasterList]),
    lib_server_send:send_to_uid(RoleId, pt_232, 23212, [?SUCCESS, EquipType, MasterList]),
    ok.

%% 点亮强化大师
lighten_strength_master(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    {_NewConstellationItem, MasterList} =
        case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
            #constellation_item{strength_master = Master} = ConstellationItem ->
                {ConstellationItem, Master};
            _ ->
                {#constellation_item{}, []}
        end,
    case lighten_strength_master_do(RoleId, Name, ConstellationStatus, EquipType, MasterList) of
        {true, NewConstellationStatus, ResLv, LastItem} ->
            NewPlayer = PS#player_status{constellation = NewConstellationStatus},
            LastPlayer = change_attr(NewPlayer, LastItem),
            ?PRINT("@@@@@@@@@@@@ ~p ~n", [[?SUCCESS, EquipType, ResLv]]),
            #base_constellation_page{normal_name = NormalName} = data_constellation_equip:get_page_info(EquipType),
            lib_chat:send_TV({all}, ?MOD_CONSTELLATION, 3, [Name, RoleId, NormalName, ResLv]),
            lib_server_send:send_to_uid(RoleId, pt_232, 23213, [?SUCCESS, EquipType, ResLv]),
            {true, LastPlayer};
        {false, Errcode} -> {false, Errcode}
    end.

%% 进化界面
evolution_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    EvolutionList = get_equip_status_list(ConstellationList, EquipType, evolution),
    lib_server_send:send_to_uid(RoleId, pt_232, 23220, [?SUCCESS, EquipType, EvolutionList]),
    ok.

%% 进化
evolution(PS, EquipType, EquipId, Pos, CostEquipIdList) ->
    ?PRINT("@@@@@@@CostEquipIdList ~p ~n", [CostEquipIdList]),
    GoodsStatus = lib_goods_do:get_goods_status(),
    case check_evolution(PS, GoodsStatus, EquipType, EquipId, Pos, CostEquipIdList) of
        {true, CurrentLv, Cost, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum} ->
            evolution_done(PS, EquipType, CurrentLv, Pos, Cost, CostEquipIdList, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum);
        {false, Errcode} -> {false, Errcode}
    end.

%% 附魔界面
enchantment_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    EnchantmentList = get_equip_status_list(ConstellationList, EquipType, enchantment),
%%    {_, NextMasterLv} = cal_enchantment_master(ConstellationList, EquipType),
    {NextMasterLv, IsMax} = cal_enchantment_status(ConstellationList, EquipType),
    lib_server_send:send_to_uid(RoleId, pt_232, 23230, [?SUCCESS, EquipType, NextMasterLv, IsMax, EnchantmentList]),
    ok.

%% 附魔
%% @params Type 当材料不足是否消耗钻石购买消耗物 0否 1是
enchantment(PS, EquipType, Pos, Type) ->
    #player_status{constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    EnchantmentList = get_equip_status_list(ConstellationList, EquipType, enchantment),
    case lists:keyfind(Pos, 2, EnchantmentList) of
        {_EquipId, Pos, OldLv} ->
            case check_enchantment(PS, EquipType, Pos, OldLv, Type) of
                {true, NexLv, Cost} ->
                    enchantment_done(PS, EquipType, Pos, Type, NexLv, Cost);
                {false, ErrorCode} -> {false, ErrorCode}
            end;
        false -> {false, ?FAIL}
    end.

%% 附魔大师界面
enchantment_master_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    MasterList = case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
                     #constellation_item{enchantment_master = Master} -> Master;
                     _ -> []
                 end,
    ?PRINT("@@@@@@@MasterList ~p ~n", [MasterList]),
    lib_server_send:send_to_uid(RoleId, pt_232, 23232, [?SUCCESS, EquipType, MasterList]),
    ok.

%% 点亮附魔大师
lighten_enchantment_master(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    {_NewConstellationItem, MasterList} =
        case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
            #constellation_item{enchantment_master = Master} = ConstellationItem -> {ConstellationItem, Master};
            _ -> {#constellation_item{}, []}
        end,
    case lighten_enchantment_master_do(RoleId, Name, ConstellationStatus, EquipType, MasterList) of
        {true, NewConstellationStatus, ResLv, LastItem} ->
            NewPlayer = PS#player_status{constellation = NewConstellationStatus},
            LastPlayer = change_attr(NewPlayer, LastItem),
            #base_constellation_page{normal_name = NormalName} = data_constellation_equip:get_page_info(EquipType),
            lib_chat:send_TV({all}, ?MOD_CONSTELLATION, 4, [Name, RoleId, NormalName, ResLv]),
            ?PRINT("@@@@@@@@@@@@ ~p ~n", [[?SUCCESS, EquipType, ResLv]]),
            lib_server_send:send_to_uid(RoleId, pt_232, 23233, [?SUCCESS, EquipType, ResLv]),
            %% 进化改变强化显示的百分比加成 需要推送客户端变化
            strength_info(LastPlayer, EquipType),
            {true, LastPlayer};
        {false, Errcode} -> {false, Errcode}
    end.

%% 启灵界面
spirit_info(PS, EquipType) ->
    #player_status{id = RoleId, constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    SpiritList = get_equip_status_list(ConstellationList, EquipType, spirit),
    lib_server_send:send_to_uid(RoleId, pt_232, 23240, [?SUCCESS, EquipType, SpiritList]),
    ok.

%% 启灵
spirit(PS, EquipType, Pos) ->
    #player_status{constellation = ConstellationStatus, id = RoleId, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    SpiritList = get_equip_status_list(ConstellationList, EquipType, spirit),
    ?PRINT("@@Pos ~p", [Pos]),
    case lists:keyfind(Pos, 2, SpiritList) of
        {_EquipId, Pos, ?IS_SPIRIT} -> {false, ?ERRCODE(err232_no_cfg)};
        {_EquipId, Pos, ?NO_SPIRIT} ->
            case data_constellation_forge:get_spirit_cfg(EquipType, Pos) of
                #base_constellation_spirit{cost = Cost, attr = NewAttr} ->
                    case lib_goods_api:cost_object_list_with_check(PS, Cost, constellation_forge, "") of
                        {true, NewPlayerTmp} ->
                            #constellation_item{equip_list = EquipList, pos_equip = PosEquips} = ConstellationItem = get_constellation_item(ConstellationList, EquipType),
                            ConstellationForge = lists:keyfind(Pos, #constellation_forge.pos, EquipList),
                            NewConstellationForge = ConstellationForge#constellation_forge{is_spirit = ?IS_SPIRIT, spirit_attr = NewAttr},
                            NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
                            SpiritAttr = cal_forge_attr(NewEquipList, spirit),
                            NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, spirit_attr = SpiritAttr},
                            NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
                            NewConstellationStatus = ConstellationStatus#constellation_status{constellation_list = NewConstellationList},
                            NewPlayer = NewPlayerTmp#player_status{constellation = NewConstellationStatus},
                            lib_server_send:send_to_uid(RoleId, pt_232, 23241, [?SUCCESS, EquipType, Pos, ?IS_SPIRIT]),
                            lib_log_api:log_constellation_forge(RoleId, Name, EquipType, Pos, ?SPIRIT_OP, 0, 0, Cost),
                            case lists:keyfind(Pos, 1, PosEquips) of
                                {Pos, EquipId} ->
                                    #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
                                    case lib_goods_util:get_goods(EquipId, Dict) of
                                        #goods{goods_id = GoodsId, id = GoodsAutoId} ->
                                            lib_chat:send_TV({all}, ?MOD_CONSTELLATION, 5, [Name, RoleId, GoodsId, GoodsAutoId, RoleId]);
                                        _ -> skip
                                    end;
                                _ -> skip
                            end,
                            save_constellation_forge(RoleId, EquipType, NewConstellationForge),
                            LastPlayer = change_attr(NewPlayer, NewConstellationItem),
                            {true, LastPlayer};
                        {false, ErrorCode} -> {false, ErrorCode}
                    end;
                _ -> {false, ?ERRCODE(no_cfg)}
            end;
        _ ->
            {false, ?FAIL}
    end.

%% 秘籍清空锻造状态
gm_clear_forge(PS) ->
    #player_status{constellation = ConstellationStatus, id = RoleId} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    NewConstellationList =
        [begin
             #constellation_item{id = EquipType, equip_list = EquipList} = ConstellationItem,
             NewEquipList = [begin
                                 EquipForge#constellation_forge{
                                     strength_lv = 0,         %强化等级
                                     strength_attr = [],      %强化属性
                                     enchantment_lv = 0,      %附魔等级
                                     enchantment_attr = [],   %附魔属性
                                     is_spirit = 0,           %是否启灵
                                     spirit_attr = []         %启灵属性
                                 }
                             end||EquipForge <- EquipList],
             db_clear_forge_info(RoleId, EquipType),
             ConstellationItem#constellation_item{
                 equip_list = NewEquipList,
                 strength_attr = [],
                 enchantment_attr = [],
                 spirit_attr = [],
                 strength_master = [],
                 strength_master_attr = [],
                 enchantment_master = [],
                 enchantment_master_attr = []
             }
         end||ConstellationItem<-ConstellationList],
    NewConstellationStatus = ConstellationStatus #constellation_status{constellation_list = NewConstellationList},
    PS#player_status{constellation = NewConstellationStatus}.

%%========================================================================================================
%% 返回{下一强化大会等级，该等级是否最大等级}
%% 当前点亮到 +3 等级了，显示 +5 ，就算能点亮到+11 或者不能点亮到 +5
cal_strength_status(ConstellationList, EquipType) ->
    #constellation_item{strength_master = StrengthMaster} = ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}),
    MasterLvs = data_constellation_forge:get_strength_master_lv(EquipType),
    F = fun({L, S}, Res) ->
        case S of
            ?MASTER_ACTIVED -> [{L, S}|Res];
            _ -> Res
        end
        end,
    ActiveStrengthMaster = lists:foldl(F, [], StrengthMaster),
    case ActiveStrengthMaster of
        [] ->
            [MinLv|_] = MasterLvs,
            {MinLv,0};
        [{Lv, _}|_] -> get_next_lv(MasterLvs, Lv)
    end.
cal_enchantment_status(ConstellationList, EquipType) ->
    #constellation_item{enchantment_master = EnchantmentMaster} = ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}),
    MasterLvs = data_constellation_forge:get_enchantment_master_lv(EquipType),
    F = fun({L, S}, Res) ->
        case S of
            ?MASTER_ACTIVED -> [{L, S}|Res];
            _ -> Res
        end
        end,
    ActiveEnchantmentMaster = lists:foldl(F, [], EnchantmentMaster),
    case ActiveEnchantmentMaster of
        [] ->
            [MinLv|_] = MasterLvs,
            {MinLv,0};
        [{Lv, _}|_] -> get_next_lv(MasterLvs, Lv)
    end.

get_next_lv([], CurrentLv) -> {CurrentLv, 1};
get_next_lv([Lv|Other], CurrentLv) ->
    case CurrentLv == Lv of
        true ->
            case Other of
                [] -> {CurrentLv, 1};
                [NextLv|_] -> {NextLv, 0}
            end ;
        false -> get_next_lv(Other, CurrentLv)
    end.

check_strength(PS, EquipType, Pos, OldLv) ->
    case data_constellation_forge:get_strength_cfg(EquipType, Pos, OldLv) of
        #base_constellation_strength{cost = Cost} ->
            case Cost of
                [] -> {false, ?ERRCODE(err232_strength_max)};
                _ ->
                    case lib_goods_api:check_object_list(PS, Cost) of
                        true -> {true, OldLv + 1, Cost};
                        {false, ErrorCode} -> {false, ErrorCode}
                    end
            end;
        _ -> {false, ?ERRCODE(err232_no_cfg)}
    end.

strength_done(PS, EquipType, Pos, Type, NexLv, Cost) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, figure = #figure{name = Name}} = PS,
    case lib_goods_api:cost_object_list_with_check(PS, Cost, constellation_forge, "") of
        {true, NewPlayerTmp} ->
            #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
            #constellation_item{equip_list = EquipList} = ConstellationItem = get_constellation_item(ConstellationList, EquipType),
            ConstellationForge = lists:keyfind(Pos, #constellation_forge.pos, EquipList),
            #base_constellation_strength{attr = Attr} = data_constellation_forge:get_strength_cfg(EquipType, Pos, NexLv),
            SpecialAttr = get_strength_special_attr(EquipType, Pos, NexLv, []),
            NewConstellationForge = ConstellationForge#constellation_forge{strength_lv = NexLv, strength_attr = Attr ++ SpecialAttr},
            NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
            StrengthAttr = cal_forge_attr(NewEquipList, strength),
            NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, strength_attr = StrengthAttr},
            NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
            NewConstellationStatusTmp =  ConstellationStatus#constellation_status{constellation_list = NewConstellationList},
            {NewConstellationStatus,NewEudemonsItem, Atom} = strength_callback(RoleId, NewConstellationStatusTmp, EquipType),
            {NewConstellationStatus1, NewEudemonsItem1} = strength_evolution_callback(NewConstellationStatus, NewEudemonsItem, EquipType),
            NewPlayerTmp2 = NewPlayerTmp#player_status{constellation = NewConstellationStatus1},
            lib_log_api:log_constellation_forge(RoleId, Name, EquipType, Pos, ?STRENGTH_OP, NexLv - 1, NexLv, Cost),
            save_constellation_forge(RoleId, EquipType, NewConstellationForge),
            LastPlayer = change_attr(NewPlayerTmp2, NewEudemonsItem1),
            Buff = 100,
            %% 需要重新算强化大师和属性加成发送给客户端
            ?PRINT("@@@@@ ~p ~n", [[?SUCCESS, EquipType, Pos, Type, Buff, NexLv]]),
            lib_server_send:send_to_uid(RoleId, pt_232, 23211, [?SUCCESS, EquipType, Pos, Type, Buff, NexLv]),
            %% 判断强化大师状态是否改变，改变推送信息
            ?IF(Atom == change, strength_master_info(LastPlayer, EquipType), skip),
            LastPlayer1 = lib_demons_api:constellation_forge_lv(LastPlayer),
            {true, LastPlayer1};
        {false, ErrorCode} -> {false, ErrorCode}
    end.

lighten_strength_master_do(RoleId,RoleName, ConstellationStatus, EquipType, MasterList) ->
    ?PRINT("@@MasterList ~p ~n", [MasterList]),
    case lists:keyfind(?MASTER_ACTIVE, 2, MasterList) of
        false -> {false, ?ERRCODE(err232_strength_master_no)};
        _ ->
            NewMaster =
                [?IF(Status == ?MASTER_ACTIVE, {Lv, ?MASTER_ACTIVED}, Master)
                    ||{Lv, Status} = Master <- MasterList],
            F = fun({_, Status1}) -> Status1 == ?MASTER_ACTIVED end,
            [{MaxLv, _}|_] = lists:reverse(lists:filter(F, NewMaster)),
            #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
            Item = get_constellation_item(ConstellationList, EquipType),
            MasterAttr = sum_strength_master_attr(EquipType, MaxLv),
            NewItem = Item#constellation_item{strength_master = NewMaster, strength_master_attr = MasterAttr},
            EquipStatus = [{Pos, SLv}||#constellation_forge{pos = Pos, strength_lv = SLv} <- NewItem#constellation_item.equip_list],
            lib_log_api:log_constellation_master(RoleId, RoleName, EquipType, 1, MaxLv, EquipStatus, MasterAttr),
            db_update_strength_master_all(RoleId, EquipType, NewMaster),
            NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewItem),
            {true, ConstellationStatus#constellation_status{constellation_list = NewConstellationList}, MaxLv, NewItem}
    end.


check_evolution(PS, GoodsStatus, EquipType, EquipId, Pos, CostEquipIdList) ->
    #player_status{constellation = ConstellationStatus} = PS,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    #constellation_item{pos_equip = PosEquip, is_active = _IsActive} = ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}),
    {Pos, GoodsId} = ulists:keyfind(Pos, 1, PosEquip, {Pos, 0}),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsDict),
    case GoodsInfo of
        #goods{id = EquipId, other = GoodsOther} ->
            case length(GoodsOther#goods_other.addition) >= ?EVOLUTION_PERCENT_NEED_NUM of
                true ->
                    #goods_other{stren = Lv, addition = OldAttr, refine = OldStarNum} = GoodsOther,
                    case data_constellation_forge:get_evolution_cfg(EquipType, Pos, Lv) of
                        #base_constellation_evolution{cost = []} -> {false, ?ERRCODE(err232_evolution_max)};
                        #base_constellation_evolution{cost = Cost, rate = Rate, ev_point = EvPoint} ->
                            case cal_addition_rate(GoodsDict, CostEquipIdList, Rate, EvPoint) of
                                {true, AdditionRate} ->
                                    case lib_goods_api:check_object_list(PS, Cost) of
                                        true ->
                                            NextEvolutionCfg = data_constellation_forge:get_evolution_cfg(EquipType, Pos, Lv + 1),
                                            {StarNum, PerfectAttr} = get_start_perfect_attr(OldAttr, EquipType, Pos),
                                            NewGoodsInfo = GoodsInfo#goods{other = GoodsOther#goods_other{stren = Lv + 1, addition = PerfectAttr ++ OldAttr, refine = StarNum + OldStarNum}},
                                            {true, Lv, Cost, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum};
                                        {false, ErrorCode} ->
                                            {false, ErrorCode}
                                    end;
                                {false, ErrorCode1} ->
                                    {false, ErrorCode1}
                            end;
                        _ ->{false, ?ERRCODE(err232_no_cfg)}
                    end;
                false -> {false, ?ERRCODE(err232_evolution_color)}
            end;
        _ ->
            {false, ?ERRCODE(err232_no_dress)}
    end.


%% 计算额外成功率
%% params Rate 基础成功率
%% params EvPoint 达到百分百成功率所需的装备点数
cal_addition_rate(GoodsDict, CostEquipIdList, Rate, EvPoint) ->
    F1 = fun(EquipId1, {Flag1, NewEquipList}) ->
        case lib_goods_util:get_goods(EquipId1, GoodsDict) of
            #goods{goods_id = GoodsId} -> {Flag1 andalso true, [{EquipId1, GoodsId}|NewEquipList]};
            _ -> {Flag1 andalso false, []}
        end
    end,
    case lists:foldl(F1, {true, []}, CostEquipIdList) of
        {true, TureEquipIdList} ->
            F = fun({_AutoId, EquipId}, {Flag, AddPoint}) ->
                case data_constellation_equip:get_equip_info(EquipId) of
                    #base_constellation_equip{compose_info = 0} ->
                        {Flag andalso false, 0};
                    #base_constellation_equip{compose_info = Point} ->
                        {Flag andalso true, AddPoint + Point};
                    _ -> {Flag andalso false, 0}
                end
            end,
            case lists:foldl(F, {true, 0}, TureEquipIdList) of
                {true, SumPoint} ->
                    SurRate = 10000 - Rate,
                    ResRate = ?IF(SumPoint >= EvPoint, SurRate,(SumPoint/EvPoint) * SurRate),
                    {true, round(ResRate)};
                {false, _} -> {false, ?ERRCODE(err232_evolution_euqip_point)}
            end;
        {false, _} -> {false, ?GOODS_NOT_ENOUGH}
    end.

get_start_perfect_attr(OldAttr, EquipType, Pos) ->
    case data_constellation_forge:get_evolution_pool(EquipType, Pos) of
        [] -> {0, []};
        EvolutionPool ->
            #base_constellation_evolution_pool{attr_pool = AttrPool} = EvolutionPool,
            F = fun({AId, _, _,_,_,_}, ResList) ->
                    lists:keydelete(AId, 1, ResList)
                end,
            NewAttrPool = lists:foldl(F,AttrPool, OldAttr),
            WeightList = [begin
                              case Item of
                                  {AttrId, AttrVal, AttrColor, Star, Weight} -> {Weight, {AttrId, AttrVal, 0,0, AttrColor, Star}};
                                  {AttrId, AttrVal, AttrColor, Star, Weight, Level, PerAdd} -> {Weight, {AttrId, AttrVal, Level, PerAdd, AttrColor, Star}}
                              end
                          end|| Item <- NewAttrPool],
            case urand:rand_with_weight(WeightList) of
                {_, _,_,_, _, RStar} = Res -> {RStar, [Res]};
                _ -> {0, []}
            end
    end.

evolution_done(PS, EquipType, CurrentLv, Pos, Cost, [], Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum) ->
    evolution_done_help(PS, EquipType, CurrentLv, Pos, Cost, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum);
evolution_done(PS, EquipType, CurrentLv, Pos, Cost, CostEquipIdList, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum) ->
    case lib_goods_api:delete_more_by_list(PS, [{AutoId,1}||AutoId<-CostEquipIdList], constellation_forge) of
        1 ->
            evolution_done_help(PS, EquipType, CurrentLv, Pos, Cost, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum);
        Err ->
            ?ERR("evolution_done occor a error ~p ~n", [Err]),
            {false, ?FAIL}
    end.

evolution_done_help(PS, EquipType, CurrentLv, Pos, Cost, Rate, AdditionRate, NextEvolutionCfg, NewGoodsInfo, PerfectAttr, StarNum) ->
    #player_status{id = RoleId, figure = #figure{name = Name}} = PS,
    #goods{id = GoodsId, goods_id = GId} = NewGoodsInfo,
    case lib_goods_api:cost_object_list_with_check(PS, Cost, constellation_forge, "") of
        {true, NewPlayerTmp} ->
            % ?MYLOG("zh_xingxiu", "Rate ~p, AdditionRate ~p~n",[Rate, AdditionRate]),
            case urand:rand(1,10000) =< (Rate + AdditionRate) of
                true -> %% 进化成功
                    NewPlayer = evolution_done_core(NewPlayerTmp, EquipType, Pos, NextEvolutionCfg,NewGoodsInfo, StarNum),
                    lib_log_api:log_constellation_evolution(RoleId, Name, ?EVOLUTION_SUCCESS, GoodsId, GId, EquipType, CurrentLv, CurrentLv + 1, Cost, PerfectAttr),
                    %?PRINT("@@@ ~p ~n", [[?SUCCESS, ?EVOLUTION_SUCCESS, EquipType, GoodsId, Pos, CurrentLv]]),
                    [{PerAttrId, _,_,_, _, _}|_] = PerfectAttr,
                    lib_server_send:send_to_uid(RoleId, pt_232, 23221, [?SUCCESS, ?EVOLUTION_SUCCESS, EquipType, GoodsId, Pos, CurrentLv + 1, PerAttrId]),
                    {true, NewPlayer};
                false -> %% 进化失败
                    lib_log_api:log_constellation_evolution(RoleId, Name, ?EVOLUTION_FAIL, GoodsId, GId, EquipType, CurrentLv, CurrentLv, Cost, []),
                    %?PRINT("@@@ ~p ~n", [[?SUCCESS, ?EVOLUTION_FAIL, EquipType, GoodsId, Pos, CurrentLv]]),
                    lib_server_send:send_to_uid(RoleId, pt_232, 23221, [?SUCCESS, ?EVOLUTION_FAIL, EquipType, GoodsId, Pos, CurrentLv, 0]),
                    {true, NewPlayerTmp}
            end;
        {false, Errcode, _} ->
            ?PRINT("@@@ ~p ~n", [Cost]),
            {false, Errcode}
    end.

evolution_done_core(PS, EquipType, Pos, NewEvolutionCfg, NewGoodsInfo, StarNum) ->
    #player_status{constellation = ConstellationStatus, figure = #figure{lv = RoleLv, name = Name}, id = RoleId} = PS,

    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodDict = GoodsStatus#goods_status.dict,
    NewDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, GoodDict),
    NewGoodsStatus = GoodsStatus#goods_status{dict = NewDict},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    lib_constellation_equip:change_goods_other(NewGoodsInfo),
    lib_goods_api:notify_client(PS, [NewGoodsInfo]), % 通知更新物品信息

    #goods{id = EquipId, goods_id= GoodsId} = NewGoodsInfo,

    #base_constellation_evolution{attr = Attr, lv = Lv} = NewEvolutionCfg,
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    ConstellationItem = ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}),
    #constellation_item{equip_list = EquipList} = ConstellationItem,
    ConstellationForge = ulists:keyfind(Pos, #constellation_forge.pos, EquipList, #constellation_forge{}),
    NewConstellationForge = ConstellationForge#constellation_forge{equip_id = EquipId, evolution_attr = Attr, evolution_lv = Lv},

    NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
    EvolutionAttr = cal_forge_attr(NewEquipList, evolution),
    NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, evolution_attr = EvolutionAttr},
    NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
    NewConstellationStatus = ConstellationStatus#constellation_status{constellation_list = NewConstellationList},

    {NewConstellationStatus1, NewConstellationItem1} = strength_evolution_callback(NewConstellationStatus, NewConstellationItem, EquipType),

    LastConstellationStatus = lib_constellation_equip:update_status_other_mod(RoleId, NewConstellationStatus1, RoleLv, NewConstellationItem1, NewDict),
%%    PS#player_status{constellation = LastConstellationStatus}.
    ?IF(StarNum == 0, skip, begin
                                #attr_star{star_level = StarLevel, max_level = MaxLevel, star = NewStar} = LastConstellationStatus#constellation_status.attr_star,
                                lib_log_api:log_constellation_star(RoleId, Name, 2, NewStar, StarLevel, StarLevel, MaxLevel),
                                lib_constellation_equip:notify_client_star(LastConstellationStatus#constellation_status.attr_star, RoleId),
                                ok
                            end),

    %传闻
    lib_chat:send_TV({all}, ?MOD_CONSTELLATION, 2, [Name, RoleId, GoodsId, EquipId, RoleId, Lv]),

    change_attr(PS#player_status{constellation = LastConstellationStatus}, NewConstellationItem1).

check_enchantment(PS, EquipType, Pos, OldLv, Type) ->
    case data_constellation_forge:get_enchantment_cfg(EquipType, Pos, OldLv) of
        #base_constellation_enchantment{cost = Cost} ->
            case Cost of
                [] -> {false, ?ERRCODE(err232_enchantment_max)};
                _ ->
                    case lib_goods_api:check_object_list(PS, Cost) of
                        true -> {true, OldLv + 1, Cost};
                        {false, ErrorCode} ->
                            case Type of
                                ?AUTO_BUY -> check_auto_buy_cost(Cost, OldLv + 1, ErrorCode);
                                _ -> {false, ErrorCode}
                            end
                    end
            end;
        _ -> {false, ?ERRCODE(err232_no_cfg)}
    end.

check_auto_buy_cost(Cost, Lv, ErrorCode)->
    case ErrorCode == ?GOODS_NOT_ENOUGH of
        true ->
            case lib_goods_api:calc_auto_buy_list(Cost) of
                {ok, NewCost} ->
                    {true, Lv, NewCost};
                _A -> {false, ErrorCode}
            end;
        _ -> {false, ErrorCode}
    end.


enchantment_done(PS, EquipType, Pos, Type, NexLv, Cost) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, figure = #figure{name = Name}} = PS,
    case lib_goods_api:cost_object_list_with_check(PS, Cost, constellation_forge, "") of
        {true, NewPlayerTmp} ->
            #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
            #constellation_item{equip_list = EquipList} = ConstellationItem = get_constellation_item(ConstellationList, EquipType),
            ConstellationForge = lists:keyfind(Pos, #constellation_forge.pos, EquipList),
            #base_constellation_enchantment{attr = Attr} = data_constellation_forge:get_enchantment_cfg(EquipType, Pos, NexLv),
            NewConstellationForge = ConstellationForge#constellation_forge{enchantment_lv = NexLv, enchantment_attr = Attr},
            NewEquipList = lists:keystore(Pos, #constellation_forge.pos, EquipList, NewConstellationForge),
            EnchantmentAttr = cal_forge_attr(NewEquipList, enchantment),
            NewConstellationItem = ConstellationItem#constellation_item{equip_list = NewEquipList, enchantment_attr = EnchantmentAttr},
            NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
            NewConstellationStatusTmp =  ConstellationStatus#constellation_status{constellation_list = NewConstellationList},
            {NewConstellationStatus,NewEudemonsItem, Atom} = enchantment_callback(RoleId, NewConstellationStatusTmp, EquipType),
            NewPlayerTmp2 = NewPlayerTmp#player_status{constellation = NewConstellationStatus},

            LastPlayer = change_attr(NewPlayerTmp2, NewEudemonsItem),

            lib_log_api:log_constellation_forge(RoleId, Name, EquipType, Pos, ?ENCHANTMENT_OP, NexLv - 1, NexLv, Cost),
            save_constellation_forge(RoleId, EquipType, NewConstellationForge),
            %% 需要重新算fumo大师和属性加成发送给客户端
            ?PRINT("@@@@@@ ~p ~n", [[?SUCCESS, EquipType, Pos, Type, NexLv]]),
            lib_server_send:send_to_uid(RoleId, pt_232, 23231, [?SUCCESS, EquipType, Pos, Type, NexLv]),
            ?IF(Atom == change, enchantment_master_info(LastPlayer, EquipType), skip),
            {true, LastPlayer};
        {false, ErrorCode, _} -> {false, ErrorCode}
    end.

lighten_enchantment_master_do(RoleId, RoleName, ConstellationStatus, EquipType, MasterList) ->
    case lists:keyfind(?MASTER_ACTIVE, 2, MasterList) of
        false -> {false, ?ERRCODE(err232_enchantment_master_no)};
        _ ->
            NewMaster =
                [?IF(Status == ?MASTER_ACTIVE, {Lv, ?MASTER_ACTIVED}, Master)
                    ||{Lv, Status} = Master <- MasterList],
            F = fun({_, Status1}) -> Status1 == ?MASTER_ACTIVED end,
            [{MaxLv, _}|_] = lists:reverse(lists:filter(F, NewMaster)),
            #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
            Item = ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}),
            #constellation_item{equip_list = EquipList} = Item,
            MasterAttr = sum_enchantment_master_attr(EquipType, MaxLv),
            OldStrengthAttr = cal_forge_attr(EquipList, strength),
            OldEvolutionAttr = cal_forge_attr(EquipList, evolution),
            {NewMasterAttr, NewStrengthAttr, NewEvolutionAttr} = cal_percent_attr(MasterAttr, OldStrengthAttr, OldEvolutionAttr),
            NewItem = Item#constellation_item{
                strength_attr = NewStrengthAttr,
                evolution_attr = NewEvolutionAttr,
                enchantment_master = NewMaster,
                enchantment_master_attr = NewMasterAttr
            },
            EquipStatus = [{Pos, SLv}||#constellation_forge{pos = Pos, enchantment_lv = SLv} <- NewItem#constellation_item.equip_list],
            lib_log_api:log_constellation_master(RoleId, RoleName, EquipType, 2, MaxLv, EquipStatus, MasterAttr),
            db_update_enchantment_master_all(RoleId, EquipType, NewMaster),
            NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewItem),

            {true, ConstellationStatus#constellation_status{constellation_list = NewConstellationList}, MaxLv, NewItem}
    end.

%% 强化和进化成功的回调（百分比加成的存在需要调用）
strength_evolution_callback(ConstellationStatus, ConstellationItem, EquipType) ->
    #constellation_status{constellation_list = ItemList} = ConstellationStatus,
    #constellation_item{id = EquipType, equip_list = NewEquipList, enchantment_master = EnchaMaster} = ConstellationItem,
    OldStrengthAttr = cal_forge_attr(NewEquipList, strength),
    OldEvolutionAttr = cal_forge_attr(NewEquipList, evolution),
    {_, NewStrengthAttr, NewEvolutionAttr} =
        get_enchantment_master_attr(EnchaMaster, EquipType, 0, OldStrengthAttr, OldEvolutionAttr),
    NewItem = ConstellationItem#constellation_item{
        strength_attr = NewStrengthAttr,
        evolution_attr = NewEvolutionAttr
    },
    NewItemList = lists:keystore(EquipType, #constellation_item.id, ItemList, NewItem),
    {ConstellationStatus#constellation_status{constellation_list = NewItemList}, NewItem}.


%% 强化成功调用
strength_callback(RoleId, ConstellationStatus, EquipType) ->
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    {CurrentLv, _NextLv} = cal_strength_master(ConstellationList, EquipType),
    #constellation_item{strength_master = StrengthMaster} = ConstellationItem = get_constellation_item(ConstellationList, EquipType),
    if
        CurrentLv == 0 ->
            {ConstellationStatus, ConstellationItem, nochange};
        true ->
            NewStrengthMaster = case lists:keyfind(CurrentLv, 1, StrengthMaster) of
                                    {CurrentLv, ?MASTER_ACTIVED} -> StrengthMaster;
                                    _ ->
                                        lists:keystore(CurrentLv, 1, StrengthMaster, {CurrentLv, ?MASTER_ACTIVE})
                                end,
            #constellation_item{strength_master = OldStrengthMaster} = ConstellationItem,
            case OldStrengthMaster == NewStrengthMaster of %% 判断强化大师状态是否改变
                true -> {ConstellationStatus, ConstellationItem, nochange};
                false ->
                    NewConstellationItem = ConstellationItem#constellation_item{
                        strength_master = NewStrengthMaster
                    },
                    NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
                    db_update_strength_master_all(RoleId, EquipType, NewStrengthMaster),
                    {ConstellationStatus#constellation_status{constellation_list = NewConstellationList}, NewConstellationItem, change}
            end
    end.

%% 附魔成功调用
enchantment_callback(RoleId, ConstellationStatus, EquipType) ->
    #constellation_status{constellation_list = ConstellationList} = ConstellationStatus,
    {CurrentLv, _NextLv} = cal_enchantment_master(ConstellationList, EquipType),
    #constellation_item{enchantment_master = EnchantmentMaster} = ConstellationItem = get_constellation_item(ConstellationList, EquipType),
    if
        CurrentLv == 0 ->
            {ConstellationStatus,ConstellationItem, nochange};
        true ->
            NewEnchantmentMaster = case lists:keyfind(CurrentLv, 1, EnchantmentMaster) of
                                       {CurrentLv, ?MASTER_ACTIVED} -> EnchantmentMaster;
                                       _ ->
                                           lists:keystore(CurrentLv, 1, EnchantmentMaster, {CurrentLv, ?MASTER_ACTIVE})
                                   end,
            #constellation_item{enchantment_master = OldEnchantmentMaster} = ConstellationItem,
            case OldEnchantmentMaster==NewEnchantmentMaster of
                true -> {ConstellationStatus, ConstellationItem, nochange};
                false ->
                    NewConstellationItem = ConstellationItem#constellation_item{
                        enchantment_master = NewEnchantmentMaster
                    },
                    NewConstellationList = lists:keystore(EquipType, #constellation_item.id, ConstellationList, NewConstellationItem),
                    db_update_enchantment_master_all(RoleId, EquipType, NewEnchantmentMaster),
                    {ConstellationStatus#constellation_status{constellation_list = NewConstellationList},NewConstellationItem, change}
            end
    end.

%% 每次改变属性都需要调用该函数，通知客户端更新战力，修改状态
change_attr(Ps, ConstellationItem) ->
    #player_status{figure = #figure{lv = RoleLv}, constellation = ConstellationStatus} = Ps,
    #goods_status{dict = GoodsDict} = lib_goods_do:get_goods_status(),
    NewConstellationStatusTmp = lib_constellation_equip:update_status_other_mod(Ps#player_status.id, ConstellationStatus, RoleLv, ConstellationItem, GoodsDict),
    LastPlayerTmp = lib_player:count_player_attribute(Ps#player_status{constellation = NewConstellationStatusTmp}),
    LastConstellationStatus = lib_constellation_equip:calc_partial_power(NewConstellationStatusTmp, LastPlayerTmp#player_status.original_attr),
    LastPlayer = LastPlayerTmp#player_status{constellation = LastConstellationStatus},
    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
    LastPlayer.


%=================================private func=====================================

get_strength_special_attr(_EquipType, _Pos, 0, Attr) -> Attr;
get_strength_special_attr(EquipType, Pos, Lv, Attr) ->
    case data_constellation_forge:get_strength_cfg(EquipType, Pos, Lv) of
        #base_constellation_strength{special_attr = []} ->
            get_strength_special_attr(EquipType, Pos, Lv-1,Attr);
        #base_constellation_strength{special_attr = SpecialAttr} ->
            get_strength_special_attr(EquipType, Pos, Lv-1,SpecialAttr++Attr);
        _ ->
            get_strength_special_attr(EquipType, Pos, Lv-1,Attr)
    end.


cal_forge_attr(EquipList, strength) ->
    F = fun(#constellation_forge{strength_attr = Attr}, SumAttr) ->
        Attr ++ SumAttr
        end,
    lists:foldl(F, [], EquipList);
cal_forge_attr(EquipList, evolution) ->
    F = fun(#constellation_forge{evolution_attr = Attr}, SumAttr) ->
        Attr ++ SumAttr
        end,
    lists:foldl(F, [], EquipList);
cal_forge_attr(EquipList, enchantment) ->
    F = fun(#constellation_forge{enchantment_attr = Attr}, SumAttr) ->
        Attr ++ SumAttr
        end,
    lists:foldl(F, [], EquipList);
cal_forge_attr(EquipList, spirit) ->
    F = fun(#constellation_forge{spirit_attr = Attr}, SumAttr) ->
        Attr ++ SumAttr
        end,
    lists:foldl(F, [], EquipList);
cal_forge_attr(EquipList, all) ->
    F = fun(#constellation_forge{strength_attr = StrAttr, evolution_attr = EvoAttr, enchantment_attr = EnAttr, spirit_attr = SpAttr}, {Acc1, Acc2, Acc3, Acc4}) ->
        {StrAttr ++ Acc1, EvoAttr ++ Acc2, EnAttr ++ Acc3, SpAttr ++ Acc4}
        end,
    lists:foldl(F, {[],[],[],[]}, EquipList);
cal_forge_attr(_, _) -> [].

%% 计算强化大师状态
%% 返回强化大师等级和下一强化大师等级(当前等级是最高的情况下，下一等级返回0)
cal_strength_master(ConstellationList, EquipType) ->
    %%获取强化大师配置
    MasterConfigs = [
        begin
            data_constellation_forge:get_strength_master(EquipType, MasterLv)
        end
        ||MasterLv <- data_constellation_forge:get_strength_master_lv(EquipType)
    ],
    StrengthList = get_equip_status_list(ConstellationList, EquipType, strength),
    cal_strength_master_core(MasterConfigs, StrengthList, {0, 0}).

%% 返回当前强化等级和下一强化大师等级
cal_strength_master_core([], _StrengthList, {CurrentLv, _NextLv}) -> {CurrentLv, CurrentLv};
cal_strength_master_core([MasterConfig|Other], StrengthList, {ResLv, _NextLv}) ->
    #base_constellation_strength_master{satisfy_status = SatisfyStatus, lv = MasterLv} = MasterConfig,
    F = fun({Pos, Lv}, Flag) ->
            case lists:keyfind(Pos, 2, StrengthList) of
                {_, Pos, SLv} ->
                    Flag andalso ?IF(SLv >= Lv, true, false);
                _ -> false
            end
        end,
    %% 判断是否满足当前强化大师需要
    case lists:foldl(F, true, SatisfyStatus) of
        false -> {ResLv, MasterLv};
        true -> cal_strength_master_core(Other, StrengthList, {MasterLv, MasterLv})
    end.


%% 计算附魔大师状态，每次升级之后调用
%% 返回附魔大师等级和下一附魔大师等级
cal_enchantment_master(ConstellationList, EquipType) ->
    MasterConfigs = [
        begin
            data_constellation_forge:get_enchantment_master(EquipType, MasterLv)
        end
        ||MasterLv <- data_constellation_forge:get_enchantment_master_lv(EquipType)
    ],
    StrengthList = get_equip_status_list(ConstellationList, EquipType, enchantment),
    cal_enchantment_master_core(MasterConfigs, StrengthList, {0, 0}).

%% 返回当前附魔等级和下一附魔大师等级
cal_enchantment_master_core([], _StrengthList, Res) -> Res;
cal_enchantment_master_core([MasterConfig|Other], StrengthList, {ResLv, _NextLv}) ->
    #base_constellation_enchantment_master{satisfy_status = SatisfyStatus, lv = MasterLv} = MasterConfig,
    F = fun({Pos, Lv}, Flag) ->
        case lists:keyfind(Pos, 2, StrengthList) of
            {_, Pos, SLv} ->
                Flag andalso ?IF(SLv >= Lv, true, false);
            _ -> false
        end
        end,
    %% 判断是否满足当前强化大师需要
    case lists:foldl(F, true, SatisfyStatus) of
        false -> {ResLv, MasterLv};
        true -> cal_enchantment_master_core(Other, StrengthList, {MasterLv, MasterLv})
    end.

get_constellation_item(ConstellationList, EquipType) ->
    ulists:keyfind(EquipType, #constellation_item.id, ConstellationList, #constellation_item{}).

get_equip_status_list(ConstellationList, EquipType, strength) ->
    case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        #constellation_item{equip_list = EquipList} ->
            [{EquipId, Pos, Lv} ||#constellation_forge{equip_id = EquipId, pos = Pos, strength_lv = Lv} <- EquipList];
        _ -> []
    end;
get_equip_status_list(ConstellationList, EquipType, evolution) ->
    case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        #constellation_item{equip_list = EquipList} ->
            #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
            [begin
                 case lib_goods_util:get_goods(EquipId, Dict) of
                     #goods{other = #goods_other{addition = AdditionAttr}} -> {EquipId, Pos, Lv, length(AdditionAttr)};
                     _ -> {EquipId, Pos, Lv, 0}
                 end
             end||#constellation_forge{equip_id = EquipId, pos = Pos, evolution_lv = Lv} <- EquipList];
        _ -> []
    end;
get_equip_status_list(ConstellationList, EquipType, enchantment) ->
    case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        #constellation_item{equip_list = EquipList} ->
            [{EquipId, Pos, Lv} ||#constellation_forge{equip_id = EquipId, pos = Pos, enchantment_lv = Lv} <- EquipList];
        _ -> []
    end;
get_equip_status_list(ConstellationList, EquipType, spirit) ->
    case lists:keyfind(EquipType, #constellation_item.id, ConstellationList) of
        #constellation_item{equip_list = EquipList} ->
            [{EquipId, Pos, IsSpirit} ||#constellation_forge{equip_id = EquipId, pos = Pos, is_spirit = IsSpirit} <- EquipList];
        _ -> []
    end;
get_equip_status_list(_ConstellationList, _EquipType, _) ->
    [].

%%=============================================db===============================================%%
db_get_constellation_forge(RoleId, EquipType, Pos) ->
    Sql = io_lib:format(<<"select `strength_lv`, `enchantment_lv`, `is_spirit` from `player_constellation_forge` where `role_id` = ~p and `equip_type` = ~p and `pos` = ~p">>, [RoleId, EquipType, Pos]),
    case db:get_row(Sql) of
        [StrengthLv, EnchantmentLv, IsSpirit] -> {StrengthLv, EnchantmentLv, IsSpirit};
        _ ->
            db_insert_forge(RoleId, EquipType, Pos),
            {0,0,0}
    end.

db_get_strength_master(RoleId, EquipType) ->
    Sql = io_lib:format(<<"select `lv`, `status` from `player_constellation_strength_master` where `role_id` = ~p and `equip_type` = ~p">>, [RoleId, EquipType]),
    db:get_all(Sql).

db_get_enchantment_master(RoleId, EquipType) ->
    Sql = io_lib:format(<<"select `lv`, `status` from `player_constellation_enchantment_master` where `role_id` = ~p and `equip_type` = ~p">>, [RoleId, EquipType]),
    db:get_all(Sql).

db_update_strength_master_all(RoleId, EquipType, MasterList) ->
    [begin
%%         timer:sleep(20),
         db_update_strength_master(RoleId, EquipType, Lv, Status)
     end ||{Lv, Status} <- MasterList].

db_update_enchantment_master_all(RoleId, EquipType, MasterList) ->
    [begin
%%         timer:sleep(20),
         db_update_enchantment_master(RoleId, EquipType, Lv, Status)
     end||{Lv, Status} <- MasterList].

db_update_strength_master(RoleId, EquipType, Lv, Status) ->
    Sql = io_lib:format(<<"replace into player_constellation_strength_master (`role_id`, `equip_type`, `lv`, `status`) values (~p, ~p, ~p, ~p)">>,
        [RoleId, EquipType, Lv, Status]),
    db:execute(Sql).

db_update_enchantment_master(RoleId, EquipType, Lv, Status) ->
    Sql = io_lib:format(<<"replace into player_constellation_enchantment_master (`role_id`, `equip_type`, `lv`, `status`) values (~p, ~p, ~p, ~p)">>,
        [RoleId, EquipType, Lv, Status]),
    db:execute(Sql).

save_constellation_forge(RoleId, EquipType, ConstellationForge) ->
    #constellation_forge{
        pos = Pos, strength_lv = SLv,
        enchantment_lv = ELv, is_spirit = IsSpirit
    } = ConstellationForge,
    Sql = io_lib:format(<<"replace into player_constellation_forge (`role_id`,`equip_type`,`pos`,`strength_lv`
    ,`enchantment_lv`,`is_spirit`) values (~p, ~p, ~p, ~p, ~p, ~p)">>, [RoleId, EquipType, Pos, SLv, ELv, IsSpirit]),
    db:execute(Sql).

db_insert_forge(RoleId, EquipType, Pos) ->
    Sql = io_lib:format(<<"insert into player_constellation_forge (`role_id`, `equip_type`, `pos`) values (~p , ~p, ~p)">>,
        [RoleId, EquipType, Pos]),
    db:execute(Sql).

db_clear_forge_info(RoleId, EquipType) ->
    Sql = io_lib:format(<<"delete from player_constellation_forge where `role_id` = ~p and `equip_type` = ~p">>,
        [RoleId, EquipType]),
    db:execute(Sql),
    Sql1 = io_lib:format(<<"delete from player_constellation_strength_master where `role_id` = ~p and `equip_type` = ~p">>,
        [RoleId, EquipType]),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"delete from player_constellation_enchantment_master where `role_id` = ~p and `equip_type` = ~p">>,
        [RoleId, EquipType]),
    db:execute(Sql2).

%%===============优化================%

%% 初始化时将所有数据查询出，存进进程字典
db_load_role_info(RoleId) ->
    Sql = io_lib:format(<<"select `equip_type`, `pos`, `strength_lv`, `enchantment_lv`, `is_spirit` from `player_constellation_forge` where `role_id` = ~p">>, [RoleId]),
    ForgeList_ = db:get_all(Sql),
    ForgeList = [{{EquipType, Pos}, StrengthLv, EnchantmentLv, IsSpirit}||[EquipType, Pos, StrengthLv, EnchantmentLv, IsSpirit]<-ForgeList_],
    Sql1 = io_lib:format(<<"select `equip_type`, `lv`, `status` from `player_constellation_strength_master` where `role_id` = ~p ">>, [RoleId]),
    SMasterList_ = db:get_all(Sql1),
    SMasterList = [{EquipType, Lv, Status}||[EquipType, Lv, Status]<-SMasterList_],
    Sql2 = io_lib:format(<<"select `equip_type`, `lv`, `status` from `player_constellation_enchantment_master` where `role_id` = ~p ">>, [RoleId]),
    EMasterList_ = db:get_all(Sql2),
    EMasterList = [{EquipType, Lv, Status}||[EquipType, Lv, Status]<-EMasterList_],
    {ForgeList, SMasterList, EMasterList}.


%% 与进程字典获取锻造信息
get_constellation_forge(ForgeList, EquipType, Pos) ->
    case lists:keyfind({EquipType, Pos}, 1, ForgeList) of
        {_, StrengthLv, EnchantmentLv, IsSpirit}
            -> {StrengthLv, EnchantmentLv, IsSpirit};
        _ -> {0,0,0}
    end.

get_strength_master(SMasterList, EquipType) ->
    [{Lv, Status}||{EquipType_, Lv, Status}<-SMasterList, EquipType == EquipType_].

get_enchantment_master(EMasterList, EquipType) ->
    [{Lv, Status}||{EquipType_, Lv, Status}<-EMasterList, EquipType == EquipType_].

%% 穿戴成功后重新计算进化等属性
after_dress_on_evolution_callback(ConstellationItem, EquipType) ->
    #constellation_item{id = EquipType, equip_list = NewEquipList, enchantment_master = EnchaMaster} = ConstellationItem,
    OldStrengthAttr = cal_forge_attr(NewEquipList, strength),
    OldEvolutionAttr = cal_forge_attr(NewEquipList, evolution),
    {_, NewStrengthAttr, NewEvolutionAttr} =
        get_enchantment_master_attr(EnchaMaster, EquipType, 0, OldStrengthAttr, OldEvolutionAttr),
    ConstellationItem#constellation_item{
        strength_attr = NewStrengthAttr,
        evolution_attr = NewEvolutionAttr
    }.
