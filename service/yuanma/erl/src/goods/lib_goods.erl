%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-14
%% Description: 物品信息
%% --------------------------------------------------------
-module(lib_goods).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("drop.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("language.hrl").
-include("errcode.hrl").
-include("equip_suit.hrl").
-include("def_fun.hrl").

%% ---------------------------------------------------------------------------
%% @doc 上线初始化物品进程数据
-spec login(PlayerId, ArgsList) ->  Return when
    PlayerId    :: integer(),
    ArgsList    :: list(), %%
    Return      :: {#goods_status{}, #status_goods{}}.  %% state记录
%% ---------------------------------------------------------------------------
%% 登录/重连/重新加载 都会调用
%% 注意:如果功能有对物品数据第二次初始化,登录/重连/重新加载 都要处理,尽量在本函数初始化完
login(PlayerId, [PlayerLv, VipType, VipLv, CellNum, StorageNum]) ->
    NullDict    = dict:new(),
    {GoodsDict, TimeoutGoods} = lib_goods_init:init_goods_online(PlayerId, NullDict),
    %NullCellsMap = lib_goods_init:init_null_cells_list(CellNum, GoodsDict),
    NumCells = lib_goods_init:init_num_cells_map(PlayerLv, VipType, VipLv, CellNum, StorageNum, GoodsDict),
    GiftList    = lib_goods_util:get_gift_got_list(PlayerId),

    EquipList   = lib_goods_util:get_equip_list(PlayerId, GoodsDict),
    EquipLocation = lib_goods_util:get_equip_location(EquipList),
    EquipStrenList   = lib_goods_util:get_stren_list(PlayerId, EquipList),
    EquipRefineList = lib_goods_util:get_refine_list(PlayerId, EquipList),
    EquipStoneList   = lib_goods_util:get_stone_list(PlayerId),
    EquipWashMap   = lib_goods_util:get_wash_map(PlayerId),
    EquipSuitList = lib_equip:get_initual_suit(PlayerId),
    EquipSuitStates = lib_equip:calc_suit_state(EquipSuitList),
    EquipCastingSpiritL = lib_goods_util:get_casting_spirit_list(PlayerId, EquipList),
    EquipSpirit = lib_goods_util:get_equip_spirit(PlayerId),
    EquipAwakeningL = lib_goods_util:get_euqip_awakening(PlayerId),
    EquipSkillL = lib_goods_util:get_euqip_skill(PlayerId),
    Fashion = lib_fashion:fashion_login(PlayerId),
    Rune = lib_rune:rune_login(PlayerId, GoodsDict),
    Soul = lib_soul:soul_login(PlayerId, GoodsDict),
    Ring = lib_marriage:ring_login(PlayerId),
    PetEquipPosList = lib_pet:pet_euip_pos_list_login(PlayerId),
    MountEquipPosList = lib_mount_equip:figure_euip_pos_list_login(PlayerId, 1),
    MateEquipPosList = lib_mount_equip:figure_euip_pos_list_login(PlayerId, 2),

    RecFusion = lib_goods_util:get_bag_fusion(PlayerId),

    DecEquip = lib_goods_util:get_dec_equip_list(PlayerId, GoodsDict),
    DecLevelList = lib_goods_util:get_dec_level_list(PlayerId, DecEquip),

    SealEquip = lib_goods_util:get_seal_equip_list(PlayerId, GoodsDict),
    SealLeveList = lib_goods_util:get_seal_level_list(PlayerId, SealEquip),

    DraconicEquip = lib_goods_util:get_draconic_equip_list(PlayerId, GoodsDict),
    DraconicLeveList = lib_goods_util:get_draconic_level_list(PlayerId, DraconicEquip),

    GodEquipLevelList = lib_god_equip:get_god_equip_list(PlayerId),

    RevelationEquipList   = lib_goods_util:get_revelation_equip_list(PlayerId, GoodsDict),
    RevelationEquipLocation = lib_goods_util:get_equip_location(RevelationEquipList),
    EquipRefinementList = lib_equip_refinement:get_equip_refinement_list(PlayerId),
    GoodsStatus = #goods_status{
        player_id               = PlayerId,
        player_lv               = PlayerLv,
        num_cells               = NumCells,
        gift_list               = GiftList,
        dict                    = GoodsDict,
        timeout_goods           = TimeoutGoods,
        equip_location          = EquipLocation,
        equip_stren_list        = EquipStrenList,
        equip_refine_list       = EquipRefineList,
        equip_stone_list        = EquipStoneList,
        fashion                 = Fashion,
        rune                    = Rune,
        soul                    = Soul,
        ring                    = Ring,
        equip_suit_list         = EquipSuitList,
        equip_suit_state        = EquipSuitStates,
        equip_wash_map          = EquipWashMap,
        equip_casting_spirit    = EquipCastingSpiritL,
        equip_spirit            = EquipSpirit,
        equip_awakening_list    = EquipAwakeningL,
        equip_skill_list        = EquipSkillL,
        pet_equip_pos_list      = PetEquipPosList,
        mount_equip_pos_list    = MountEquipPosList,
        mate_equip_pos_list     = MateEquipPosList,
        rec_fusion              = RecFusion,
        dec_level_list          = DecLevelList,
        seal_stren_list         = SealLeveList,
        draconic_stren_list     = DraconicLeveList,
        god_equip_list          = GodEquipLevelList,
        revelation_equip_location = RevelationEquipLocation,
        equip_refinement = EquipRefinementList
    },

    %% 初始化装备评分，强化等级信息
    {GoodsStatus1, NewEquipList} = lib_goods_util:init_equip_other_info(GoodsStatus, EquipList),

    StrenAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_STREN),
    StoneAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_STONE),
    StarAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_STAR),
    RefineAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_REFINE),
    StageAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_STAGE),
    ColorAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_COLOR),
    RedEquipAwardList = lib_equip:get_12_equip_award_from_list(GoodsStatus1, NewEquipList, ?WHOLE_AWARD_RED_EQUIP),
    %% 初始化圣印评分，强化等级信息
    GoodsStatus2 = lib_goods_util:init_seal_other_info(GoodsStatus1, SealEquip, SealLeveList),
    %% 初始化圣印评分，强化等级信息
    GoodsStatus3 = lib_goods_util:init_draconic_other_info(GoodsStatus2, DraconicEquip, DraconicLeveList),
    %% 初始化幻饰评分，强化等级信息
    DecorGoodsStatus = lib_goods_util:init_dec_other_info(GoodsStatus3, DecEquip, DecLevelList),

    [{?WHOLE_AWARD_STREN, StrenWholeLv}, {?WHOLE_AWARD_STONE, StoneWholeLv} | _]
        = lib_equip:init_manual_whole_award(PlayerId),

    NewGoodsStatus = DecorGoodsStatus#goods_status{
        stren_award_list    = StrenAwardList,
        stren_whole_lv      = StrenWholeLv,
        stone_award_list    = StoneAwardList,
        stone_whole_lv      = StoneWholeLv,
        star_award_list     = StarAwardList,
        refine_award_list   = RefineAwardList,
        stage_award_list    = StageAwardList,
        color_award_list    = ColorAwardList,
        red_equip_award_list = RedEquipAwardList
    },
    %% 装备加成属性没有放到GoodsStatus里面的都需要加载，计算装备总属性
    {_, EquipAttrSpecialList} = lib_dragon_equip:calc_equip_special_attr(PlayerId, GoodsDict),
    SkillTalentList = lib_skill:get_all_talent_skill(PlayerId),
    %% 初始化#player_status.goods
    {TotalAttr, EquipSkillPower, SpecialAttrMap} = lib_goods_util:count_equip_attribute(PlayerId, PlayerLv, SkillTalentList, EquipAttrSpecialList, NewGoodsStatus),
    %% 初始化时装属性
    FashionAttr = lib_fashion:count_fashion_attr(Fashion),
    RuneWearList = lib_goods_util:get_goods_list(PlayerId, ?GOODS_LOC_RUNE, GoodsDict),
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),
%%  穿戴的聚魂属性
    SoulWearList = lib_goods_util:get_goods_list(PlayerId, ?GOODS_LOC_SOUL, GoodsDict),
    SoulAttr = lib_soul:count_soul_attribute(SoulWearList),
    RingAttr = lib_marriage:count_ring_attribute(Ring),
    BagFusionAttr = lib_goods_util:get_bag_fusion_attr(RecFusion),
    LastGoodsStatus = NewGoodsStatus#goods_status{
        equip_special_attr = SpecialAttrMap
    },
    SuitAttr = lib_equip:calc_suit_attr(EquipSuitStates),
    RevelationEquipAttr = lib_revelation_equip:count_attribute(RevelationEquipList),
    {RevelationEquipSuitAttr, _} = lib_revelation_equip:count_suit_attribute(RevelationEquipList),
    EquipRefinementAttr = lib_equip_refinement:count_equip_refinement_attr(LastGoodsStatus),
    StatusGoods = #status_goods{
        equip_attribute     = TotalAttr,
        equip_skill_power   = EquipSkillPower,
        equip_suit_attr     = SuitAttr,
        fashion_attr        = FashionAttr,
        rune_attr           = RuneAttr,
        soul_attr           = SoulAttr,
        ring_attr           = RingAttr,
        bag_fusion_attr     = BagFusionAttr,
        revelation_equip_attr = RevelationEquipAttr
        ,revelation_equip_suit_attr = RevelationEquipSuitAttr
        , equip_refinement_attr = EquipRefinementAttr
    },
    %% Return
    %?PRINT("init goods ================= ~p~n", [NumCells]),
    {LastGoodsStatus, StatusGoods}.

%% 物品重新加载
reload_goods(Player) ->
    #player_status{id = RoleId, figure = Figure, cell_num = CellNum, storage_num = StorageNum, online = Online} = Player,
    #figure{lv = Lv, vip_type = VipType, vip = VipLv, career = Career} = Figure,
    {GoodsStatus, StatusGoods} = lib_goods:login(RoleId, [Lv, VipType, VipLv, CellNum, StorageNum]),
    lib_goods_do:init_data(GoodsStatus, Career),
    NewPlayer = Player#player_status{goods = StatusGoods},
    %% 通知客户端刷新
    case Online == ?ONLINE_ON of
        true ->
            {ok, BinData} = pt_150:write(15030, []),
            lib_server_send:send_to_uid(RoleId, BinData);
        false ->
            skip
    end,
    {ok, NewPlayer}.

%% ---------------------------------------------------------------------------
%% @doc 下线移除相关数据
%% ---------------------------------------------------------------------------
%% logout(_PlayerId) ->
%%     ok.

is_cache(Location) ->
    lists:member(Location, ?GOODS_LOC_CACHE).

%%---------------------------------------------------------------------
%% @doc 背包拖动物品
%% -spec(GoodsStatus, GoodsInfo, OldCell, NewCell) -> {ok, NewStatus3, [NewGoodsInfo1, NewGoodsInfo2]}
%% when
%%      OldCell         :: integer() 物品所在格子
%%      NewCell         :: integer() 要移到的位置
%%      NewGoodsInfo1   :: #goods{}  移动后OldCell格子上的物品
%%      NewGoodsInfo2   :: #goods{}  移动后NewCell格子上的物品
%% @end
%%----------------------------------------------------------------------
drag_goods(GoodsStatus, GoodsInfo, OldCell, NewCell) ->
    GoodsInfo2 = lib_goods_util:get_goods_by_cell(GoodsStatus#goods_status.player_id, GoodsInfo#goods.bag_location, NewCell, GoodsStatus#goods_status.dict),
    GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
    % 最大叠加数
    Max = GoodsTypeInfo#ets_goods_type.max_overlap,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        case is_record(GoodsInfo2, goods) of
        %%新位置没有物品
            false ->
                [NewGoodsInfo2, NewStatus1] = change_goods_cell(GoodsInfo, GoodsInfo#goods.bag_location, NewCell, GoodsStatus),   %%修改物品位置
                NewStatus = NewStatus1,
                Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                NewStatus2 = NewStatus#goods_status{dict = Dict},
                {ok, NewStatus2, [#goods{}, NewGoodsInfo2]};
        %%新位置有相同类型物品
            true when Max > 1 andalso GoodsInfo2#goods.goods_id =:= GoodsInfo#goods.goods_id
                andalso GoodsInfo2#goods.bind =:= GoodsInfo#goods.bind
                andalso GoodsInfo2#goods.expire_time =:= GoodsInfo#goods.expire_time ->
                [GoodsNum2,_, GoodsStatus1, _] = update_overlap_goods(GoodsInfo2, [GoodsInfo#goods.num, Max, GoodsStatus, #{}]),    %%更新物品数量
                case GoodsNum2 > 0 of
                    true -> %合不完,还有剩下的,更新两物品的属性
                        [NewGoodsInfo1, NewGoodsStatus] = change_goods_num(GoodsInfo, GoodsNum2, GoodsStatus1),
                        NewGoodsInfo2 = GoodsInfo2#goods{num = (GoodsInfo2#goods.num + GoodsInfo#goods.num - GoodsNum2)},
                        Dict = lib_goods_dict:handle_dict(NewGoodsStatus#goods_status.dict),
                        NewGoodsStatus2 = NewGoodsStatus#goods_status{dict=Dict},
                        {ok, NewGoodsStatus2, [NewGoodsInfo1, NewGoodsInfo2]};
                    false -> %拖完
                        NewStatus = delete_goods(GoodsInfo, GoodsStatus), %删除原来物品
                        NewGoodsInfo2 = GoodsInfo2#goods{num = (GoodsInfo2#goods.num + GoodsInfo#goods.num)},
                        Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
                        NewGoodsStatus2 = NewStatus#goods_status{dict=Dict},
                        {ok, NewGoodsStatus2, [#goods{id = GoodsInfo#goods.id}, NewGoodsInfo2]}
                end;
        %%新位置有物品
            true ->
                %调换位置
                [NewGoodsInfo2, NewStatus1] = change_goods_cell(GoodsInfo, GoodsInfo#goods.bag_location, NewCell, GoodsStatus),
                [NewGoodsInfo1, NewStatus2] = change_goods_cell(GoodsInfo2, GoodsInfo#goods.bag_location, OldCell, NewStatus1),
                Dict = lib_goods_dict:handle_dict(NewStatus2#goods_status.dict),
                NewStatus3 = NewStatus2#goods_status{dict = Dict},
                {ok, NewStatus3, [NewGoodsInfo1, NewGoodsInfo2]}
        end
    end,
    lib_goods_util:transaction(F).

%%--------------------------------------------------------
%% 整理背包
%% param: Num :: integer() 格子位置，开始传1
%%        OldGoodsInfo :: #goods{}  上一个物品, 开始传{}
%% @end
%%--------------------------------------------------------
clean_bag(GoodsInfo, [Num, OldGoodsInfo, GoodsStatus, Pos]) ->
    case is_record(OldGoodsInfo, goods) of
        %% 与上一格子物品类型相同
        true when GoodsInfo#goods.goods_id =:= OldGoodsInfo#goods.goods_id
                  andalso GoodsInfo#goods.bind =:= OldGoodsInfo#goods.bind
                  andalso GoodsInfo#goods.expire_time =:= OldGoodsInfo#goods.expire_time ->
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            case GoodsTypeInfo#ets_goods_type.max_overlap > 1 of
                %% 可叠加
                true ->
                    %% 达到最大上限的剩余数量
                    [NewGoodsNum, _, _, NewGoodsStatus, _]
                        = update_overlap_goods(OldGoodsInfo, [GoodsInfo#goods.num, GoodsTypeInfo#ets_goods_type.max_overlap, GoodsInfo, GoodsStatus, #{}]),
                    case NewGoodsNum > 0 of
                        %% 还有剩余
                        true ->
                            [NewGoodsInfo, NewStatus]
                                = case GoodsInfo#goods.cell =/= Num orelse GoodsInfo#goods.num =/= NewGoodsNum of
                                      true ->
                                          change_goods_cell_and_num(GoodsInfo, Pos, Num, NewGoodsNum, NewGoodsStatus);
                                      false -> %% 第一次
                                          [GoodsInfo, NewGoodsStatus]
                                  end,
                            [Num+1, NewGoodsInfo, NewStatus, Pos];
                        %% 没有剩余
                        false ->
                            NewStatus = delete_goods(GoodsInfo, NewGoodsStatus),
                            NewGoodsNum1 = OldGoodsInfo#goods.num + GoodsInfo#goods.num,
                            NewOldGoodsInfo = OldGoodsInfo#goods{num = NewGoodsNum1},
                            [Num, NewOldGoodsInfo, NewStatus, Pos]
                    end;
                %% 不可叠加
                false ->
                    [NewGoodsInfo, NewStatus]
                        = case GoodsInfo#goods.cell =/= Num of
                              true ->
                                  change_goods_cell(GoodsInfo, Pos, Num, GoodsStatus);
                              false ->
                                  [GoodsInfo, GoodsStatus]
                          end,
                    [Num+1, NewGoodsInfo, NewStatus, Pos]
            end;
        %% 与上一格子类型不同
        true ->
            [NewGoodsInfo, NewStatus]
                = case GoodsInfo#goods.cell =/= Num of
                      true ->
                          change_goods_cell(GoodsInfo, Pos, Num, GoodsStatus);
                      false ->
                          [GoodsInfo, GoodsStatus]
                  end,
            [Num+1, NewGoodsInfo, NewStatus, Pos];
        false ->
            [NewGoodsInfo, NewStatus]
                = case GoodsInfo#goods.cell =/= Num of
                      true ->
                          change_goods_cell(GoodsInfo, Pos, Num, GoodsStatus);
                      false ->
                          [GoodsInfo, GoodsStatus]
                  end,
            [Num+1, NewGoodsInfo, NewStatus, Pos]
    end.

%%-----------------------------------------------------------
%% 拣取地上掉落包的物品
%%-----------------------------------------------------------
%% drop_choose(PlayerStatus, Status, DropThingTypeInfo, DropId, NowCell, NeedCell) ->
%%     case mod_drop:get_drop(DropId) of
%%         {} ->
%%             {fail, ?ERRCODE(err150_no_drop)};
%%         DropInfo ->
%%             mod_drop:delete_drop(DropId),
%%             case DropThingTypeInfo of
%%                 {coin, Num} ->
%%                     NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, Num, ?COIN, mon_drop, ""),
%%                     {ok, NewPlayerStatus, Status, coin, Num};
%%                 {goods, GoodsTypeInfo} ->
%%                     NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
%%                     F = fun() ->
%%                                 ok = lib_goods_dict:start_dict(),
%%                                 case DropInfo#ets_drop.goods_id of
%%                                     ?GOODS_ID_COIN ->
%%                                         NewGoodsInfo = NewInfo,
%%                                         NewPlayerStatus = lib_goods_util:add_money(PlayerStatus, DropInfo#ets_drop.num, ?COIN, mon_drop, ""),
%%                                         NewStatus = Status;
%%                                     _ when NowCell>=NeedCell ->
%%                                         NewPlayerStatus = PlayerStatus,
%%                                         Bind = ?IF(DropInfo#ets_drop.bind > 0, ?BIND, GoodsTypeInfo#ets_goods_type.bind),
%%                                         Trade = ?IF(Bind > 0, ?CANNOT_TRADE, ?CAN_TRADE),
%%                                         NewGoodsInfo = NewInfo#goods{player_id = Status#goods_status.player_id,
%%                                                                      num = DropInfo#ets_drop.num, bind=Bind, trade=Trade},
%%                                         {ok, {NewStatus, _}} = add_goods_base(Status, GoodsTypeInfo, DropInfo#ets_drop.num, NewGoodsInfo);
%%                                     %% 背包格子不足，发邮件附件
%%                                     _ ->
%%                                         send_drop_choose_mail(PlayerStatus#player_status.id, DropInfo, GoodsTypeInfo),
%%                                         NewGoodsInfo    = NewInfo,
%%                                         NewPlayerStatus = PlayerStatus,
%%                                         NewStatus = Status
%%                                 end,
%%                                 %% 记录日志
%%                                 if  DropInfo#ets_drop.mon_id > 0 andalso NowCell>=NeedCell ->
%%                                         lib_log_api:log_goods(mon_drop, DropInfo#ets_drop.mon_id, NewGoodsInfo#goods.goods_id,
%%                                                               NewGoodsInfo#goods.num, NewGoodsInfo#goods.player_id, "");
%%                                     true ->
%%                                         skip
%%                                 end,
%%                                 {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
%%                                 lib_goods_api:notify_client(NewPlayerStatus, GoodsL),
%%                                 NewStatus2 = NewStatus#goods_status{dict = Dict},
%%                                 {ok, NewPlayerStatus, NewStatus2, NewGoodsInfo, GoodsL}
%%                         end,
%%                     lib_goods_util:transaction(F)
%%             end
%%     end.

%% %% 拾取掉落的时候，背包格子不足，发邮件附件
%% send_drop_choose_mail(PlayerId, DropInfo, GoodsTypeInfo) ->
%%     Title   = ?LAN_MSG(?LAN_TITLE_DROP),
%%     Content = uio:format(?LAN_MSG(?LAN_CONTENT_DROP), [DropInfo#ets_drop.mon_name, GoodsTypeInfo#ets_goods_type.goods_name, DropInfo#ets_drop.num]),
%%     lib_mail_api:send_sys_mail([PlayerId], Title, Content, [{?TYPE_GOODS, DropInfo#ets_drop.goods_id, DropInfo#ets_drop.num}]),
%%     ok.

%%---------------------------------------------------
%% 拆分物品
%%---------------------------------------------------
split(GoodsStatus, GoodsInfo, GoodsNum) ->
    F = fun() ->
            ok = lib_goods_dict:start_dict(),
            NewNum = GoodsInfo#goods.num - GoodsNum,
            [_, NewGoodsStatus] = change_goods_num(GoodsInfo, NewNum, GoodsStatus),
            NewInfo = GoodsInfo#goods{id = 0, cell = 0, num = GoodsNum},
            [_NewGoodsInfo, NewStatus1] = add_goods(NewInfo, NewGoodsStatus),
            NewStatus = lib_goods_util:occupy_num_cells(NewStatus1, GoodsInfo#goods.location),
            {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
            NewStatus2 = NewStatus#goods_status{dict = Dict},
            {ok, NewStatus2, UpGoods}
        end,
    lib_goods_util:transaction(F).

%%---------------------------------------------------
%% 物品续费
%%---------------------------------------------------
%% goods_renew(Ps, GoodsStatus, GoodsInfo, PriceType, Cost, RenewTime)->
%%     F = fun() ->
%%                 ok = lib_goods_dict:start_dict(),
%%                 #ets_goods_type{goods_name = GName} = data_goods_type:get(GoodsInfo#goods.goods_id),
%%                 NewPs = lib_goods_util:cost_money(Ps, Cost, PriceType, goods_renew, [GName]),
%%                 EndTime = utime:unixtime() + RenewTime,
%%                 NewGoodsInfo = lib_goods_util:change_goods_expire_time(GoodsInfo, EndTime),
%%                 _Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
%%                 {Dict, _UpGoods} = lib_goods_dict:handle_dict_and_notify(_Dict),
%%                 {ok, NewPs, GoodsStatus#goods_status{dict = Dict}, EndTime, NewGoodsInfo}
%%         end,
%%     lib_goods_util:transaction(F).
% goods_renew(GoodsStatus, GoodsInfo, PsMoney, RenewTime)->
%     EndTime = utime:unixtime() + RenewTime,
%     F = fun() ->
%                 ok = lib_goods_dict:start_dict(),
%                 #ets_goods_type{goods_name = GName} = data_goods_type:get(GoodsInfo#goods.goods_id),
%                 NewPsMoney = lib_goods_util:new_cost_money(PsMoney, [GName]),
%                 NewGoodsInfo = lib_goods_util:change_goods_expire_time(GoodsInfo, EndTime),
%                 _Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
%                 {Dict, _UpGoods} = lib_goods_dict:handle_dict_and_notify(_Dict),
%                 {ok, NewPsMoney, GoodsStatus#goods_status{dict = Dict}, EndTime, NewGoodsInfo}
%         end,
%     lib_goods_util:transaction(F).

%%--------------------------------------------------
%% 把物品从A背包移动到B背包
%% @param  GoodsStatus #goods_status{}
%% @param  GoodsInfo   #goods{}
%% @param  ToLoc       B背包位置
%% @return             {ok, #goods_status{}}|{fail, 2, #goods_status{}} 2:背包格子不足
%%--------------------------------------------------
move_a2b({GoodsInfo, ToLoc}, GoodsStatus) ->
    move_a2b({GoodsInfo, ToLoc, GoodsInfo#goods.num}, GoodsStatus);
move_a2b({GoodsInfo, ToLoc, MoveNum}, GoodsStatus) ->
    case data_goods_type:get(GoodsInfo#goods.goods_id) of
        [] -> %% 物品不存在
            throw({error, {GoodsInfo#goods.goods_id, not_found}});
        #ets_goods_type{max_overlap = MaxOverlap} = GoodsTypeInfo ->
            #goods{goods_id = GoodsTypeId, bind = Bind} = GoodsInfo,
            #goods_status{player_id = PlayerId, dict = Dict} = GoodsStatus,
            GoodsList = lib_goods_util:get_type_goods_list(PlayerId, GoodsTypeId, Bind, ToLoc, Dict),
            CellNum = lib_storage_util:get_null_cell_num(GoodsList, GoodsInfo, MaxOverlap, MoveNum),
            HaveCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ToLoc),
            case HaveCellNum < CellNum of
                true -> % 背包格子不足
                   throw({error, {cell_num, not_enough}});
                false ->
                    move_goods_base(GoodsStatus, GoodsTypeInfo, MoveNum, GoodsInfo, GoodsList, ToLoc)
            end
    end.

%%---------------------------------------------------
%% 计算物品合成成功概率
%% 外部进行判断了才调这个接口 这里面不做判断
%%---------------------------------------------------
count_compose_ratio(ComposeCfg, SpecifyGIdList) ->
    #goods_compose_cfg{
       ratio_type = RatioType,
       ratio = Ratio
    } = ComposeCfg,
    case RatioType of
        ?COMPOSE_RATIO_REGULAR -> Ratio;
        ?COMPOSE_RATIO_IRREGULAR ->
            count_irregular_ratio(Ratio, length(SpecifyGIdList), 0);
        _ -> 0
    end.

%% 计算非固定的合成概率
count_irregular_ratio([], _, Result) -> Result;
count_irregular_ratio([{Num, Ratio}|L], GListLen, Result) ->
    case GListLen >= Num of
        true ->
            count_irregular_ratio(L, GListLen, Ratio);
        false ->
            count_irregular_ratio(L, GListLen, Result)
    end;
count_irregular_ratio(_, _GListLen, Result) -> Result.

goods_compose_cost(PsMoney, GoodsStatus, CostObjectList, CostGoodsList) ->
    case lib_goods_util:lightly_cost_object_list(PsMoney, CostObjectList, goods_compose, "", GoodsStatus) of
        {true, NewGoodsStatus, NewPsMoney} ->
            %% 扣除指定物品
            {ok, NewGoodsStatus1} = lib_goods:delete_goods_list(NewGoodsStatus, CostGoodsList),
            {ok, NewGoodsStatus1, NewPsMoney};
        {false, Res, _NewGoodsStatus, _NewPsMoney} -> %% 失败直接抛异常，终止事务
            throw({error, {not_enough, Res}})
    end.

log_goods_compose_cost(RoleId, ComposeCfg, IsSucc, CostSpecifyGInfoList, CostRegularGInfoList) ->
    #goods_compose_cfg{id = RuleId, cost = CostMoney, goods = SuccRewards, fail_goods = FailRewards} = ComposeCfg,
    %% 扣除指定物品日志
    F = fun({TmpGoodsInfo, TmpNum}) ->
        #goods{id = GoodsId, goods_id = GoodsTypeId, bind = Bind} = TmpGoodsInfo,
        lib_log_api:log_throw(goods_compose, RoleId, GoodsId, GoodsTypeId, TmpNum, 0, 0),
        GTypeBind = ?IF(Bind == ?BIND, ?TYPE_BIND_GOODS, ?TYPE_GOODS),
        {GTypeBind, GoodsTypeId, TmpNum}
    end,
    LogSpecifyArgs = [F(OneDel) || OneDel <- CostSpecifyGInfoList],
    LogRegularArgs = [F(OneDel) || OneDel <- CostRegularGInfoList],
    %% 合成日志
    case IsSucc of
        true ->
            lib_log_api:log_goods_compose(RoleId, RuleId, LogSpecifyArgs, LogRegularArgs, CostMoney, 1, SuccRewards);
        _ ->
            lib_log_api:log_goods_compose(RoleId, RuleId, LogSpecifyArgs, LogRegularArgs, CostMoney, 0, FailRewards)
    end.

goods_compose(PlayerStatus, GoodsStatus, SpecifyGIdList, ComposeCfg, ComposeGBind, SuccessRatio, CostRegularGInfoList, CostSpecifyGInfoList) ->
    #player_status{id = RoleId} = PlayerStatus,
    #goods_compose_cfg{type = _ComposeType, cost = CostMoney, goods = SuccRewards} = ComposeCfg,
    CostGoodsList = CostSpecifyGInfoList++CostRegularGInfoList,
    CostObjectList = lib_goods_api:make_reward_unique(CostMoney),
    PsMoney = lib_player_record:trans_to_ps_money(PlayerStatus, goods_compose),
    FilterConditions = [{id_in, [Id||{#goods{id=Id}, _} <- CostGoodsList]}, {gid_in, [GoodsTypeId||{?TYPE_GOODS, GoodsTypeId, _} <- CostObjectList]}],
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions),
    F = fun() ->
        %% 先扣除钱和通用的固定材料
        ok = lib_goods_dict:start_dict(),
        {ok, NewGoodsStatus, NewPsMoney} = goods_compose_cost(PsMoney, GoodsStatusBfTrans, CostObjectList, CostGoodsList),
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
        NewGoodsStatus2 = NewGoodsStatus#goods_status{dict = Dict},
        {ok, ?SUCCESS, NewGoodsStatus2, NewPsMoney, GoodsL}
    end,
    case catch lib_goods_util:transaction(F) of
        {ok, ErrCode, NewStatus, NewPsMoney, GoodsL} ->
            LastStatus = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
            lib_goods_do:set_goods_status(LastStatus),
            lib_goods_api:notify_client_num(RoleId, GoodsL),
            NewPS = lib_player_record:update_ps_money_op(PlayerStatus, PsMoney, NewPsMoney),
            %% 合成是否成功
            IsSucc = urand:rand(1, 10000) =< SuccessRatio,
            log_goods_compose_cost(RoleId, ComposeCfg, IsSucc, CostSpecifyGInfoList, CostRegularGInfoList),
            case IsSucc of
                true ->
                    %% 叠加的物品只能改绑定属性 设置其他属性不会发物品
                    AttrList = lib_goods_util:count_goods_compose_attr(NewPS, ComposeCfg, SpecifyGIdList, GoodsL),
                    LastAttrList = [{bind, ComposeGBind}|AttrList],
                    ComposeGoodsList = [{goods_attr, TmpGTypeId, TmpGNum, LastAttrList}
                        || {?TYPE_GOODS, TmpGTypeId, TmpGNum} <- SuccRewards];
                _ ->
                    ComposeGoodsList = []
            end,
            {ok, ErrCode, NewPS, IsSucc, ComposeGoodsList};
        {db_error, {error, {not_enough, Res}}} ->
            {false, Res, PlayerStatus};
        _Err ->
            {false, ?FAIL, PlayerStatus}
    end.

goods_compose_special(SpecialType, PlayerStatus, GoodsStatus, ComposeCfg, ComposeGBind, CostRegularGInfoList, CostSpecifyGInfoList, CostNormalMat, TargetGoodsInfo) ->
    #player_status{id = RoleId, figure = Figure} = PlayerStatus,
    #figure{vip = RoleVip, vip_type = VipType} = Figure,
    #goods_compose_cfg{cost = CostMoney, goods = [{_, TargetGoodsTypeId, 1}]} = ComposeCfg,
    CostGoodsList = CostNormalMat,
    CostObjectList = lib_goods_api:make_reward_unique(CostMoney),
    PsMoney = lib_player_record:trans_to_ps_money(PlayerStatus, goods_compose),
    FilterConditions = [
        {id_in, [Id||{#goods{id=Id}, _} <- CostSpecifyGInfoList++CostRegularGInfoList]},
        {gid_in, [GoodsTypeId||{?TYPE_GOODS, GoodsTypeId, _} <- CostObjectList]}
    ],
    GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, FilterConditions),
    F = fun() ->
        %% 先扣除钱和通用的固定材料
        ok = lib_goods_dict:start_dict(),
        {ok, NewGoodsStatus, NewPsMoney} = goods_compose_cost(PsMoney, GoodsStatusBfTrans, CostObjectList, CostGoodsList),
        %% 处理穿在身上的作为合成材料的戒指和手镯，替换装备
        NewTargetGoodsInfo = replace_equip(TargetGoodsInfo, TargetGoodsTypeId, [{bind, ComposeGBind}]),
        {NewGoodsStatus1, LastTargetGoodsInfo, ReturnArgs} = post_handle_replace_equip(SpecialType, NewTargetGoodsInfo, NewGoodsStatus, {VipType, RoleVip}),
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus1#goods_status.dict),
        NewGoodsStatus2 = NewGoodsStatus1#goods_status{
            dict = Dict
        },
        {ok, ?SUCCESS, NewGoodsStatus2, NewPsMoney, GoodsL, LastTargetGoodsInfo, ReturnArgs}
    end,
    case lib_goods_util:transaction(F) of
        {ok, ErrCode, NewStatus, NewPsMoney, GoodsL, LastTargetGoodsInfo, ReturnArgs} ->
            NewStatus1 = lib_goods_util:restore_goods_status_out_transaction(NewStatus, GoodsStatusBfTrans, GoodsStatus),
            if
                SpecialType == ?GOODS_COMPOSE_SPECIAL_1 ->
                    LastStatus = lib_equip:recalc_12_equip_reward(NewStatus1, TargetGoodsInfo, LastTargetGoodsInfo);
                true ->
                    LastStatus = NewStatus1
            end,
            lib_goods_do:set_goods_status(LastStatus),
            %% 更新客户端缓存
            lib_goods_api:notify_client_num(RoleId, [TargetGoodsInfo#goods{num = 0}|lists:keydelete(TargetGoodsInfo#goods.id, #goods.id, GoodsL)]),
            lib_goods_api:notify_client(RoleId, [LastTargetGoodsInfo]),
            lib_goods_api:update_client_goods_info([LastTargetGoodsInfo]),
            NewPS = lib_player_record:update_ps_money_op(PlayerStatus, PsMoney, NewPsMoney),
            log_goods_compose_cost(RoleId, ComposeCfg, true, CostSpecifyGInfoList, CostRegularGInfoList),
            {ok, ErrCode, LastStatus, NewPS, LastTargetGoodsInfo, ReturnArgs};
        {db_error, {error, {not_enough, Res}}} ->
            {false, Res, PlayerStatus};
        _Err ->
            ?ERR("goods_compose_special _Err : ~p~n", [_Err]),
            {false, ?FAIL, PlayerStatus}
    end.

replace_equip(OriginalGoodsInfo, TargetGoodsTypeId, AttrList) ->
    #goods{id = GoodsId, other = OldGoodsOthers} = OriginalGoodsInfo,
    #goods_other{extra_attr = OldExtraAttr} = OldGoodsOthers,
    #ets_goods_type{
        type = Type,
        level = NewLv,
        color = NewColor,
        suit_id = NewSuitId,
        bind = OrignialBind,
        addition = NewAddition
    } = TargetGoodsTypeInfo = data_goods_type:get(TargetGoodsTypeId),
    {NewPriceType, NewPrice} = data_goods:get_goods_buy_price(TargetGoodsTypeId),
    {_, Bind} = ulists:keyfind(bind, 1, AttrList, {bind, OrignialBind}),
    if
        Type == ?GOODS_TYPE_EQUIP -> %% 戒指升阶，要继承属性
            NewExtraAttr = lib_equip:gen_equip_extra_attr_by_types(TargetGoodsTypeInfo, OldExtraAttr),
            Rating = lib_equip:cal_equip_rating(TargetGoodsTypeInfo, NewExtraAttr),
            NewGoodsOther = OldGoodsOthers#goods_other{extra_attr = NewExtraAttr, rating = Rating};
        Type == ?GOODS_TYPE_SEAL ->
            NewGoodsOther = lib_seal:calc_equip_dynamic_attr(TargetGoodsTypeInfo, OldGoodsOthers);
        Type == ?GOODS_TYPE_DRACONIC ->
            NewGoodsOther = lib_draconic:calc_equip_dynamic_attr(TargetGoodsTypeInfo, OldGoodsOthers);
        Type == ?GOODS_TYPE_GOD_COURT ->
            NewGoodsOther = lib_god_court:create_goods_other(OriginalGoodsInfo#goods{goods_id=TargetGoodsTypeId});
        Type == ?GOODS_TYPE_REVELATION ->
            NewGoodsOther = lib_revelation_equip:gen_equip_dynamic_attr(TargetGoodsTypeInfo, OldGoodsOthers);
        true ->
            NewGoodsOther = OldGoodsOthers
    end,
    Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
        [NewPriceType, NewPrice, GoodsId]),
    db:execute(Sql),
    Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, color = ~p, bind = ~p, addition = '~s', extra_attr = '~s' where gid = ~p">>,
        [TargetGoodsTypeId, NewLv, NewColor, Bind, util:term_to_string(NewAddition), util:term_to_string(NewGoodsOther#goods_other.extra_attr), GoodsId]),
    db:execute(Sql1),
    Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
        [TargetGoodsTypeId, GoodsId]),
    db:execute(Sql2),

    NewGoodsOther1 = NewGoodsOther#goods_other{
        suit_id = NewSuitId,
        addition= NewAddition
    },
    NewTargetGoodsInfo = OriginalGoodsInfo#goods{
        goods_id = TargetGoodsTypeId,
        price_type = NewPriceType,
        price = NewPrice,
        bind = Bind,
        level = NewLv,
        color = NewColor,
        other = NewGoodsOther1
    },
    NewTargetGoodsInfo.

post_handle_replace_equip(?GOODS_COMPOSE_SPECIAL_1, NewTargetGoodsInfo, GoodsStatus, InArgs) ->
    {VipType, RoleVip} = InArgs,
    EquipPos = data_goods:get_equip_cell(NewTargetGoodsInfo#goods.equip_type),
    %% 替换装备需要转换强化等级
    NewStrenLv = data_goods:get_equip_real_stren_level(GoodsStatus, NewTargetGoodsInfo),
    %% 替换精炼 等级
    NewRefineLv = data_goods:get_equip_real_refine_level(GoodsStatus, NewTargetGoodsInfo),
    LastTargetGoodsInfo = NewTargetGoodsInfo#goods{other = NewTargetGoodsInfo#goods.other#goods_other{stren = NewStrenLv, refine = NewRefineLv}},
    %% 检查是否需要卸下宝石
    {NewGoodsStatus, RemoveStoneL, RStonesL} = lib_equip:unload_stones(VipType, RoleVip, GoodsStatus, EquipPos, ?UNLOAD_STONE_TYPE_REPLACE_EQUIP),
    NewGoodsStatus1 = lib_goods:change_goods(LastTargetGoodsInfo, ?GOODS_LOC_EQUIP, NewGoodsStatus),
    ReturnGoodsL = [{stone_list, RStonesL}],
    ReturnArgs = #{remove_stone => RemoveStoneL, return_goods => ReturnGoodsL},
    {NewGoodsStatus1, LastTargetGoodsInfo, ReturnArgs};
post_handle_replace_equip(SpecialType, NewTargetGoodsInfo, GoodsStatus, _InArgs) when
        SpecialType == ?GOODS_COMPOSE_SPECIAL_2 orelse
        SpecialType == ?GOODS_COMPOSE_SPECIAL_3  orelse
        SpecialType == ?GOODS_COMPOSE_SPECIAL_6 ->
    NewGoodsStatus1 = lib_goods:change_goods(NewTargetGoodsInfo, NewTargetGoodsInfo#goods.location, GoodsStatus),
    {NewGoodsStatus1, NewTargetGoodsInfo, #{}};
post_handle_replace_equip(?GOODS_COMPOSE_SPECIAL_4, NewTargetGoodsInfo, GoodsStatus, _InArgs) ->
    #goods_status{seal_stren_list = SealStrenList} = GoodsStatus,
    #goods{subtype = Pos, other = Other} = NewTargetGoodsInfo,
    {_, StrenLevel} = ulists:keyfind(Pos, 1, SealStrenList, {Pos, 0}),
    LastTargetGoodsInfo = NewTargetGoodsInfo#goods{other = Other#goods_other{stren = StrenLevel}},
    NewGoodsStatus1 = lib_goods:change_goods(LastTargetGoodsInfo, LastTargetGoodsInfo#goods.location, GoodsStatus),
    {NewGoodsStatus1, LastTargetGoodsInfo, #{}};
post_handle_replace_equip(?GOODS_COMPOSE_SPECIAL_5, NewTargetGoodsInfo, GoodsStatus, _InArgs) ->
    #goods_status{draconic_stren_list = DraconicStrenList} = GoodsStatus,
    #goods{subtype = Pos, other = Other} = NewTargetGoodsInfo,
    {_, StrenLevel} = ulists:keyfind(Pos, 1, DraconicStrenList, {Pos, 0}),
    LastTargetGoodsInfo = NewTargetGoodsInfo#goods{other = Other#goods_other{stren = StrenLevel}},
    NewGoodsStatus1 = lib_goods:change_goods(LastTargetGoodsInfo, LastTargetGoodsInfo#goods.location, GoodsStatus),
    {NewGoodsStatus1, LastTargetGoodsInfo, #{}};
post_handle_replace_equip(_, _NewTargetGoodsInfo, GoodsStatus, _InArgs) ->
    {GoodsStatus, #{}}.

%%--------------------------------------------------
%% 出售物品
%% @param  PlayerStatus #player_status{}
%% @param  Status       #goods_status{}
%% @param  MomeyList    [{MoneyType,MoneyId,Num}...]|[[{MoneyType,MoneyId,Num}]...]
%% @param  GoodsList    [{#goods{},Num}...]|[[{#goods{},Num}]...]
%% @return              {ok, NewPlayerStatus, NewStatus} | Error
%%--------------------------------------------------
sell_goods(PlayerStatus, Status, MomeyList, GoodsList) ->
    F = fun() ->
            ok = lib_goods_dict:start_dict(),
            case GoodsList of
                [{_, _}|_] ->
                    {ok, NewStatus} = lib_goods:delete_goods_list(Status, GoodsList);
                _ ->
                    F1 = fun(OneSellL, {ok, TmpStatus}) ->
                        lib_goods:delete_goods_list(TmpStatus, OneSellL)
                    end,
                    {ok, NewStatus} = lists:foldl(F1, {ok, Status}, GoodsList)
            end,
            {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewStatus#goods_status.dict),
            NewStatus2 = NewStatus#goods_status{dict = Dict},
            {GoodsTypeList, RealMomeyList} = log_sell_goods(GoodsList, MomeyList, PlayerStatus#player_status.id, [], []),
            {ok, NewStatus2, GoodsL, GoodsTypeList, RealMomeyList}
        end,
    lib_goods_util:transaction(F).

make_log_sell_goods_args(GoodsList) ->
    F = fun({GoodsInfo, GoodsNum}, {TmpGTypeL, TmpGoodsIdL}) ->
        {[{GoodsInfo#goods.goods_id, GoodsNum}|TmpGTypeL], [{GoodsInfo#goods.id, GoodsNum}|TmpGoodsIdL]}
    end,
    lists:foldl(F, {[], []}, GoodsList).

log_sell_goods([{_, _}|_] = GoodsList, MomeyList, RoleId, _, _) ->
    {GoodsTypeList, GoodsIdList} = make_log_sell_goods_args(GoodsList),
    lib_log_api:log_goods_sell(RoleId, GoodsTypeList, GoodsIdList, MomeyList),
    {GoodsTypeList, MomeyList};
log_sell_goods([], _, _, GoodsTypeList, MomeyList) -> {GoodsTypeList, MomeyList};
log_sell_goods([OneSellL|GoodsList], [OneSellMoneyL|SellMoneyL], RoleId, GoodsTypeList, MomeyList) ->
    {TGoodsTypeList, TGoodsIdList} = make_log_sell_goods_args(OneSellL),
    lib_log_api:log_goods_sell(RoleId, TGoodsTypeList, TGoodsIdList, OneSellMoneyL),
    F = fun({MoneyType, MoneyId, MoneyNum}, Acc) ->
        case lists:keyfind(MoneyType, 1, Acc) of
            {MoneyType, MoneyId, PreNum} ->
                [{MoneyType, MoneyId, PreNum + MoneyNum}|lists:keydelete(MoneyType, 1, Acc)];
            _ ->
                [{MoneyType, MoneyId, MoneyNum}|Acc]
        end
    end,
    NewMomeyList = lists:foldl(F, MomeyList, OneSellMoneyL),
    F1 = fun({GTypeId, GoodsNum}, Acc) ->
        case lists:keyfind(GTypeId, 1, Acc) of
            {GTypeId, PreNum} ->
                [{GTypeId, PreNum + GoodsNum}|lists:keydelete(GTypeId, 1, Acc)];
            _ ->
                [{GTypeId, GoodsNum}|Acc]
        end
    end,
    NewGoodsTypeList = lists:foldl(F1, GoodsTypeList, TGoodsTypeList),
    log_sell_goods(GoodsList, SellMoneyL, RoleId, NewGoodsTypeList, NewMomeyList).

expand_bag(GoodsStatus, Pos, NewCellMaxNum) ->
    #goods_status{player_id = RoleId, num_cells = NumCells} = GoodsStatus,
    {UseNum, _} = maps:get(Pos, NumCells),
    NewNumCells = maps:put(Pos, {UseNum, NewCellMaxNum}, NumCells),
    lib_storage_util:expand_bag(RoleId, Pos, NewCellMaxNum),
    NewGoodsStatus = GoodsStatus#goods_status{num_cells = NewNumCells},
    NewGoodsStatus.

%%--------------------------------------------------
%% 把物品从A背包移动到B背包, 能叠加的物品会自动叠加起来
%% 这个接口不要在外部直接调用！！！！！！
%% @param  GoodsStatus   #goods_status{}    物品进程状态
%% @param  GoodsTypeInfo #ets_goods_type{}  物品类型记录
%% @param  MoveNum       integer()          需要移动的物品数量
%% @param  GoodsInfo     #goods{}           A背包当前物品的物品记录
%% @param  GoodsList     List [#goods{}]    B背包里面同类型物品列表
%% @param  ToLocation    integer()          A背包Location
%% @return               {ok, #goods_status{}}
%%--------------------------------------------------
move_goods_base(GoodsStatus, GoodsTypeInfo, MoveNum, GoodsInfo, GoodsList, ToLocation) ->
    case GoodsTypeInfo#ets_goods_type.max_overlap > 1 of
        true -> %% 可叠加的物品
            case MoveNum >= GoodsInfo#goods.num of
                true -> %% 该物品全部移动到B背包, 要删除A背包的原物品
                    NewGoodsStatus = delete_goods(GoodsInfo, GoodsStatus);
                _ -> %% 只移动了部分物品到B背包, 要更新A背包原物品的数量信息
                    NewNum = GoodsInfo#goods.num - MoveNum,
                    [_, NewGoodsStatus] = change_goods_num(GoodsInfo, NewNum, GoodsStatus)
            end,
            %% 更新原有的可叠加物品
            [GoodsNum1,_, _, NewGoodsStatus1, RewardResult] = lists:foldl(fun update_overlap_goods/2, [MoveNum, GoodsTypeInfo#ets_goods_type.max_overlap, GoodsInfo, NewGoodsStatus, #{}], GoodsList),
            %% 添加新的可叠加物品
            [NewGoodsStatus2,_,_,_,NewRewardResult] = lib_goods_util:deeploop(fun add_overlap_goods/2, GoodsNum1,
                [NewGoodsStatus1, GoodsInfo, ToLocation, GoodsTypeInfo#ets_goods_type.max_overlap, RewardResult]),
            {ok, NewGoodsStatus2, NewRewardResult};
        false -> %% 不能叠加的物品直接改变原物品的Location
            #goods{location = _OldLoc, cell = _OldCell} = GoodsInfo,
            [_NewGoodsInfo, NewGoodsStatus] = change_goods_cell(GoodsInfo, ToLocation, 0, GoodsStatus),
            {ok, NewGoodsStatus, #{?REWARD_RESULT_SUCC => [{?TYPE_GOODS, GoodsInfo#goods.goods_id, GoodsInfo#goods.num}]}}
    end.

%%--------------------------------------
%% give_goods
%% return: {ok, NewGoodsStatus}
%%--------------------------------------
give_goods(Item, #goods_status{} = GoodsStatus) ->
    {ok, {NewGoodsStatus, _}} = give_goods(Item, {GoodsStatus, #{}}),
    {ok, NewGoodsStatus};

%%--------------------------------------
%% give_goods
%% return: {ok, {NewGoodsStatus, RewardResult}}
%%           RewardResult: 奖励结果  ?REWARD_RESULT_SUCC => ObjectList 发送成功
%%                                   ?REWARD_RESULT_IGNOR => ObjectList 被忽略的物品(一般是装备, 装备背包不足时直接丢弃)
%%--------------------------------------
%% 赠送物品
give_goods({info, GoodsInfo}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsInfo#goods.goods_id) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsInfo#goods.goods_id, not_found}});
        #ets_goods_type{bag_location = BagLocation, max_overlap = _MaxOverlap} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsInfo#goods.num) of
                        {true, GoodsList} ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsInfo#goods.num, GoodsInfo, GoodsList, RewardResult);
                        %% 背包格子不足
                        false ->
                            throw({error, {cell_num, not_enough}})
                    end;
                false -> throw({error, {GoodsInfo#goods.goods_id, bag_location_fail}})
            end
    end;
give_goods({GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult}) ->
    give_goods({goods, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult});

give_goods({?TYPE_GOODS, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult}) ->
    give_goods({goods, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult});

give_goods({?TYPE_GOODS, GoodsTypeId, GoodsNum, Bind}, {GoodsStatus, RewardResult}) ->
    give_goods({goods, GoodsTypeId, GoodsNum, Bind}, {GoodsStatus, RewardResult});

give_goods({?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult}) ->
    give_goods({goods, GoodsTypeId, GoodsNum, ?BIND}, {GoodsStatus, RewardResult});

give_goods({?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, DyAttrList}, {GoodsStatus, RewardResult}) ->
    give_goods({goods_attr, GoodsTypeId, GoodsNum, DyAttrList}, {GoodsStatus, RewardResult});

give_goods({goods, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{bind = Bind} ->
            give_goods({goods, GoodsTypeId, GoodsNum, Bind}, {GoodsStatus, RewardResult})
    end;

give_goods({goods, GoodsTypeId, GoodsNum, Bind}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{type = ?GOODS_TYPE_GIFT} ->
            AttrList = [{role_lv, GoodsStatus#goods_status.player_lv}, {open_day, 1}, {bind, Bind}],
            give_goods({goods_attr, GoodsTypeId, GoodsNum, AttrList}, {GoodsStatus, RewardResult});
        #ets_goods_type{bag_location = BagLocation, max_overlap = _MaxOverlap} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    Info = lib_goods_util:get_new_goods(GoodsTypeInfo),
                    NewBind = ?IF(Bind == ?UNBIND, ?UNBIND, ?IF(Bind == ?BIND, ?BIND, Info#goods.bind)),
                    GoodsInfo = Info#goods{bind = NewBind},
                    case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsNum) of
                        {true, GoodsList} ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult);
                        %% 背包格子不足
                        false ->
                            throw({error, {cell_num, not_enough}})
                    end;
                false -> throw({error, {GoodsTypeId, bag_location_fail}})
            end
    end;
%%  --------------------------------------------------------------------------------------------------
%%  【注】！！！
%%  其它新增的give_goods不能像本方法一样直接调用动态属性赋值：lib_goods_util:get_new_goods/2
%%  本方法中设置的动态属性bind,expire_time,lock_time例外，因为lib_goods_util:can_overlap_same_cell/2
%%  可以区分基础属性是否相同，是否可以叠加在同一个格子
%%  --------------------------------------------------------------------------------------------------
give_goods({goods, GoodsTypeId, GoodsNum, Bind, ExpireTime, LockTime}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{bag_location = BagLocation, max_overlap = _MaxOverlap} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    ExtraArgs = [{bind, Bind}, {expire_time, ExpireTime}, {lock_time, LockTime}],
                    GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo, ExtraArgs),
                    case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsNum) of
                        {true, GoodsList} ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult);
                        %% 背包格子不足
                        false ->
                            throw({error, {cell_num, not_enough}})
                    end;
                false -> throw({error, {GoodsTypeId, bag_location_fail}})
            end
    end;

%% 物品添加含有动态属性赋值的参数DyAttrList
%% 【注】：对于可以叠加的物品，不外开放动态属性设置 绑定属性允许设置
give_goods({goods_attr, GoodsTypeId, GoodsNum, DyAttrList}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{
            bind = _Bind,
            bag_location = BagLocation,
            max_overlap = MaxOverlap
        } = GoodsTypeInfo ->
            % case DyAttrList of
            %     [{bind, _Bind}] -> OnlyBindArgs = true;
            %     [] -> OnlyBindArgs = true;
            %     _ -> OnlyBindArgs = false
            % end,
            NotOverlapArgs = length([1 ||{K, _V} <- DyAttrList, lists:member(K, [bind, role_lv, rune_lv, open_day]) == false]) > 0,
            case MaxOverlap > 1 andalso NotOverlapArgs of
                true -> %% 叠加类型的物品不能动态赋予绑定属性之外的其他属性！！！！！！！！！
                    throw({error, {GoodsTypeId, cannot_overlap}});
                false ->
                    case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                        true ->
                            GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo, DyAttrList),
                            case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsNum) of
                                {true, GoodsList} ->
                                    add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult);
                                %% 背包格子不足
                                false ->
                                    throw({error, {cell_num, not_enough}})
                            end;
                        false -> throw({error, {GoodsTypeId, bag_location_fail}})
                    end
            end
    end;

give_goods({goods_other, GoodsTypeId, GoodsNum, Stren, Exp}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{bag_location = BagLocation} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
                    GoodsInfo = NewInfo#goods{other = NewInfo#goods.other#goods_other{stren=Stren, overflow_exp = Exp}},
                    case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsNum) of
                        {true, GoodsList} ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult);
                        %% 背包格子不足
                        false ->
                            throw({error, {cell_num, not_enough}})
                    end;
                false -> throw({error, {GoodsTypeId, bag_location_fail}})
            end
    end;

give_goods({equip, GoodsTypeId, _Stars, Stren}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
    %% 物品不存在
        [] ->
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{bag_location = BagLocation} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    NewInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
                    Limit = NewInfo#goods.level,
                    NewStren = min(Stren, Limit),
                    GoodsInfo = NewInfo#goods{other = NewInfo#goods.other#goods_other{stren=NewStren}},
                    {UsedCellNum, MaxCellNum} = lib_goods_util:get_bag_cell_num(GoodsStatus, BagLocation),
                    case MaxCellNum =/= 0 andalso UsedCellNum >= MaxCellNum of
                        % 背包格子不足
                        true ->
                            NRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_IGNOR, GoodsTypeId, 1, RewardResult),
                            {ok, GoodsStatus, NRewardResult};
                        false ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, 1, GoodsInfo, [], RewardResult)
                    end;
                false -> throw({error, {GoodsTypeId, bag_location_fail}})
            end
    end;

%% 发物品到指定背包
give_goods({location, BagLocation, GoodsTypeId, GoodsNum}, {GoodsStatus, RewardResult}) ->
    case data_goods_type:get(GoodsTypeId) of
        [] -> %% 物品不存在
            throw({error, {GoodsTypeId, not_found}});
        #ets_goods_type{max_overlap = _MaxOverlap} = GoodsTypeInfo ->
            case lists:member(BagLocation, ?GOODS_LOC_BAG_TYPES) of
                true ->
                    GoodsInfo = lib_goods_util:get_new_goods(GoodsTypeInfo),
                    case give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo#ets_goods_type{bag_location = BagLocation}, GoodsNum) of
                        {true, GoodsList} ->
                            add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, BagLocation, RewardResult);
                        %% 背包格子不足
                        false ->
                            throw({error, {cell_num, not_enough}})
                    end;
                false -> throw({error, {GoodsTypeId, bag_location_fail}})
            end
    end.

give_goods_cell_check(GoodsStatus, GoodsInfo, GoodsTypeInfo, GoodsNum) ->
    #ets_goods_type{bag_location = BagLocation, type = _Type} = GoodsTypeInfo,
    GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsInfo#goods.goods_id,
        GoodsInfo#goods.bind, BagLocation, GoodsStatus#goods_status.dict),
    CellNum = lib_storage_util:get_null_cell_num(GoodsList, GoodsInfo, GoodsTypeInfo#ets_goods_type.max_overlap, GoodsNum),
    {UsedCellNum, MaxCellNum} = lib_goods_util:get_bag_cell_num(GoodsStatus, BagLocation),
    case
        MaxCellNum == 0 orelse                                 %% 背包没容量限制
        (UsedCellNum + CellNum) =< MaxCellNum             %% 背包容量充足
    of
        true -> {true, GoodsList};
        _ -> false
    end.

%%------------------------------------------------------------------------------------------------
%% @doc 增加物品
%% -spec add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo) -> {ok, NewGoodsStatus}
%% GoodsStatus | NewGoodsStatus         :: #goods_status{}      物品进程状态
%% GoodsTypeInfo                        :: #ets_goods_type{}    物品类型记录
%% GoodsNum                             :: integer()            物品数量
%% GoodsInfo                            :: #goods{}             物品记录
%% @end
%%-----------------------------------------------------------------------------------------------
add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo) ->
    add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, #{}).

add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, RewardResult) ->
    case GoodsTypeInfo#ets_goods_type.max_overlap > 1 of
        true ->
            List = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeInfo#ets_goods_type.goods_id, GoodsInfo#goods.bind, GoodsTypeInfo#ets_goods_type.bag_location, GoodsStatus#goods_status.dict),
            GoodsList = lib_goods_util:sort(List, cell);
        false ->
            GoodsList = []
    end,
    add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult).

%%------------------------------------------------------------------------------------------------
%% @doc 增加物品
%% -spec add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, DyAttrList) -> {ok, NewGoodsStatus}
%% GoodsStatus | NewGoodsStatus         :: #goods_status{}  物品进程状态
%% GoodsTypeInfo                        :: #ets_goods_type{} 物品类型记录
%% GoodsNum                             :: integer()         物品数量
%% GoodsInfo                            :: #goods{}         物品记录
%% GoodsList                            :: List [#goods{}]  同类型物品列表
%% DyAttrList                           :: List [{K, V}...] 该物品的动态属性:只有不可叠加的物品才能有唯一的动态属性
%% @end
%%-----------------------------------------------------------------------------------------------
add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, RewardResult) ->
    add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, GoodsTypeInfo#ets_goods_type.bag_location, RewardResult).

%% 这个接口不要在外部直接调用！！！！！！
add_goods_base(GoodsStatus, GoodsTypeInfo, GoodsNum, GoodsInfo, GoodsList, BagLocation, RewardResult) ->
    %% 插入物品记录
    case GoodsTypeInfo#ets_goods_type.max_overlap > 1 of
        true ->
            %% 更新原有的可叠加物品
            [GoodsNum2,_, _, NewGoodsStatus, NewRewardResult] = lists:foldl(fun update_overlap_goods/2,
                [GoodsNum, GoodsTypeInfo#ets_goods_type.max_overlap, GoodsInfo, GoodsStatus, RewardResult], GoodsList),
            %% 添加新的可叠加物品
            [NewGoodsStatus2,_,_,_, NewRewardResult2] = lib_goods_util:deeploop(fun add_overlap_goods/2, GoodsNum2,
                [NewGoodsStatus, GoodsInfo, BagLocation, GoodsTypeInfo#ets_goods_type.max_overlap, NewRewardResult]);
        false ->
            AllNums = lists:seq(1, GoodsNum),
            [NewGoodsStatus2,_,_, NewRewardResult2] = lists:foldl(fun add_nonlap_goods/2, [GoodsStatus, GoodsInfo, BagLocation, RewardResult], AllNums)
    end,
    {ok, {NewGoodsStatus2, NewRewardResult2}}.

%%----------------------------------------------------------------------------------------
%% @doc 添加新的可叠加物品,该接口如果背包没有空格，就会不处理
%% -spec add_overlap_goods(Num, [GoodsStatus, GoodsInfo, Location, MaxOverlap]) ->
%%              [NewNum, [NewGoodsStatus, GoodsInfo, Location, MaxOverlap]].
%% Num | NewNum                 :: integer()        要添加的物品数量 | 超过最大叠加数的数量
%% GoodsStatus | NewGoodsStatus :: #goods_status{}  物品进程状态
%% GoodsInfo                    :: #goods{}         物品记录
%% Location                     :: integer()        位置
%% MaxOverlap                   :: integer()        最大叠加数
%% @end
%%--------------------------------------------------------------------------------------------
add_overlap_goods(Num, [GoodsStatus, GoodsInfo, Location, MaxOverlap, RewardResult]) ->
    case Num > MaxOverlap of
        true ->
            NewNum = Num - MaxOverlap,
            OldNum = MaxOverlap;
        false ->
            NewNum = 0,
            OldNum = Num
    end,
    HadCellNum = lib_goods_util:bag_had_cell_num(GoodsStatus#goods_status.num_cells, Location),
    case OldNum > 0 of
        true when HadCellNum == true ->
            GoodsStatus1 = lib_goods_util:occupy_num_cells(GoodsStatus, Location),
            GoodsInfo1 = GoodsInfo#goods{player_id=GoodsStatus#goods_status.player_id, location=Location, cell=0, num=OldNum},
            [_, NewGoodsStatus] = add_goods(GoodsInfo1, GoodsStatus1),
            NewRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_SUCC, GoodsInfo#goods.goods_id, OldNum, RewardResult);
        true -> %% 背包不足，记录一下
            %GoodsInfo1 = GoodsInfo#goods{player_id=GoodsStatus#goods_status.player_id, location=Location, num=OldNum},
            NewRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_IGNOR, GoodsInfo#goods.goods_id, OldNum, RewardResult),
            NewGoodsStatus = GoodsStatus;
        _ ->
            NewGoodsStatus = GoodsStatus, NewRewardResult = RewardResult
    end,
    [NewNum, [NewGoodsStatus, GoodsInfo, Location, MaxOverlap, NewRewardResult]].

%% 添加新的不可叠加物品
add_nonlap_goods(_, [GoodsStatus, GoodsInfo, Location, RewardResult]) ->
    HadCellNum = lib_goods_util:bag_had_cell_num(GoodsStatus#goods_status.num_cells, Location),
    case HadCellNum of
        true ->
            %% 先屏蔽，等其他模块需要时再开放
            NewGoodsOther = new_goods_other(GoodsInfo),
            GoodsStatus1 = lib_goods_util:occupy_num_cells(GoodsStatus, Location),
            GoodsInfo1 = GoodsInfo#goods{
                player_id = GoodsStatus#goods_status.player_id,
                location = Location,
                cell = 0,
                num = 1,
                other = NewGoodsOther},
            [NewGoodsInfo, NewGoodsStatus] = add_goods(GoodsInfo1, GoodsStatus1),
            NewRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_SUCC, NewGoodsInfo#goods.goods_id, 1, RewardResult);
        false ->
            GoodsInfo1 = GoodsInfo#goods{player_id = GoodsStatus#goods_status.player_id,location = Location,num = 1},
            NewGoodsStatus = GoodsStatus,
            NewRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_IGNOR, GoodsInfo1#goods.goods_id, 1, RewardResult)
    end,
    %?PRINT("add_nonlap_goods num_cells ~p~n", [NewGoodsStatus#goods_status.num_cells]),
    [NewGoodsStatus, GoodsInfo, Location, NewRewardResult].

%%------------------------------------------------------------------------------------------------
%% @doc 更新原有的可叠加物品
%% -spec update_overlap_goods(GoodsInfo, [Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]) -> [NewNum, Max, AddGoodsInfo, NewGoodsStatus, NewRewardResult]
%% GoodsInfo                   :: #goods{}  物品记录
%% Num | NewNum                :: integer() 要增加的物品数量|超过最大叠加数后剩余的数量
%% Max                         :: integer() 最大叠加数
%% GoodsStatus|NewGoodsStatus  :: #goods_status{} 物品状态
%% @end
%%-------------------------------------------------------------------------------------------------

%% 第一次是直接返回
update_overlap_goods(GoodsInfo, [Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]) when Num> 0 ->
    case lib_goods_util:can_overlap_same_cell(GoodsInfo, AddGoodsInfo) of
        true ->
            do_update_overlap_goods(GoodsInfo, [Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]);
        _ ->
            [Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]
    end;
update_overlap_goods(_GoodsInfo, [_Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]) ->
    [0, Max, AddGoodsInfo, GoodsStatus, RewardResult].

%%
do_update_overlap_goods(GoodsInfo, [Num, Max, AddGoodsInfo, GoodsStatus, RewardResult]) ->
    case Num > 0 of
        true when GoodsInfo#goods.num =/= Max andalso Max > 0 ->
            case Num + GoodsInfo#goods.num > Max of
                true -> %%超出最大数量
                    NewNum = Num + GoodsInfo#goods.num - Max,
                    OldNum = Max;
                false ->
                    OldNum = Num + GoodsInfo#goods.num,
                    NewNum = 0
            end,
            [_, NewGoodsStatus] = change_goods_num(GoodsInfo, OldNum, GoodsStatus),
            NewRewardResult = lib_goods_util:update_reward_result(?REWARD_RESULT_SUCC, GoodsInfo#goods.goods_id, OldNum - GoodsInfo#goods.num, RewardResult);
        true ->
            NewGoodsStatus  = GoodsStatus,
            NewRewardResult = RewardResult,
            NewNum = Num;
        false ->
            NewGoodsStatus  = GoodsStatus,
            NewRewardResult = RewardResult,
            NewNum = 0
    end,
    [NewNum, Max, AddGoodsInfo, NewGoodsStatus, NewRewardResult].

%%------------------------------------------------------------------------------
%% @doc 添加新物品信息
%% -spec dd_goods(GoodsInfo, GoodsStatus) -> [NewGoodsInfo, NewGoodsStatus]
%% GoodsStatus | NewGoodsStatus         :: #goods_status{}  物品进程状态
%% GoodsInfo | NewGoodsInfo             :: #goods{}         物品记录
%% @end
%%------------------------------------------------------------------------------
add_goods(GoodsInfo, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:add_goods(GoodsInfo),
    case is_cache (NewGoodsInfo#goods.location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            NewStatus = GoodsStatus
    end,
    [NewGoodsInfo, NewStatus].

%%----------------------------------------------------------------
%% 删除物品列表
%% @spec delete_goods_list(GoodsStatus, GoodsList) -> {ok, NewStatus} | Error
%% GoodsList: [{GoodsInfo, DelNum}]
%%----------------------------------------------------------------
delete_goods_list(GoodsStatus, GoodsList) ->
    F = fun({GoodsInfo, GoodsNum}, Status1) ->
        [Status2, _] = delete_one(GoodsInfo, [Status1, GoodsNum]),
        Status2
    end,
    NewStatus = lists:foldl(F, GoodsStatus, GoodsList),
    {ok, NewStatus}.

%%----------------------------------------------------------------
%% 删除一类物品
%% @spec delete_type_goods(GoodsTypeId, GoodsStatus) -> {ok, NewStatus} | not_enough
%% GoodsTypeId: 物品配置id
%%----------------------------------------------------------------
delete_type_goods(GoodsTypeId, GoodsStatus) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{bag_location = BagLocation} ->
            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, BagLocation, GoodsStatus#goods_status.dict),
            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
            delete_more(GoodsStatus, GoodsList, TotalNum);
        _ ->
            ?ERR("delete_type_goods err: goods_type_id = ~p err_config", [GoodsTypeId]),
            not_enough
    end.

%%----------------------------------------------------------------
%% 删除一类物品的指定数量
%% @spec delete_type_list_goods({GoodsTypeId,GoodsNum}, GoodsStatus) -> {ok, NewStatus} | not_enough
%% GoodsTypeId: 物品配置id
%%----------------------------------------------------------------
delete_type_list_goods({?TYPE_GOODS, GoodsTypeId, GoodsNum}, GoodsStatus) ->
    delete_type_list_goods({GoodsTypeId, GoodsNum}, GoodsStatus);
delete_type_list_goods({?TYPE_GOODS, GoodsTypeId, GoodsNum, _Bind}, GoodsStatus) ->
    delete_type_list_goods({GoodsTypeId, GoodsNum}, GoodsStatus);
delete_type_list_goods({?TYPE_BIND_GOODS, GoodsTypeId, GoodsNum}, GoodsStatus) ->
    delete_type_list_goods({GoodsTypeId, GoodsNum}, GoodsStatus);
delete_type_list_goods({?TYPE_ATTR_GOODS, GoodsTypeId, GoodsNum, _AttrList}, GoodsStatus) ->
    delete_type_list_goods({GoodsTypeId, GoodsNum}, GoodsStatus);
delete_type_list_goods({GoodsTypeId, GoodsNum}, GoodsStatus) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{bag_location = BagLocation} ->
            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, BagLocation, GoodsStatus#goods_status.dict),
            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
            case TotalNum >= GoodsNum of
                true ->
                    delete_more(GoodsStatus, GoodsList, GoodsNum);
                false ->
                    not_enough
            end;
        _ ->
            ?ERR("delete_type_list_goods err: goods_type_id = ~p err_config", [GoodsTypeId]),
            not_enough
    end.

%%-------------------------------------------------------------------------------------------
%% @doc 删除多个物品
%% -spec delete_more(Status, GoodsList, GoodsNum ) -> {ok, NewStatus}
%% GoodsStatus|NewGoodsStatus       :: #goods_status{}  物品进程状态
%% GoodsList                        :: [#goods{}]         物品记录
%% GoodsNum | NewNum                :: integer()        物品要删除数量
%% @end
%%-------------------------------------------------------------------------------------------
delete_more(Status, GoodsList, GoodsNum) ->
    GoodsList1 = lib_goods_util:sort(GoodsList, bind_num),
    [NewStatus, _] = lists:foldl(fun delete_one/2, [Status, GoodsNum], GoodsList1),
    {ok, NewStatus}.

%%-------------------------------------------------------------------------------------------
%% @doc 删除物品，在同一个物品上删除指定数量，如果不够则全部删除，并且返回剩余要删除的物品数量
%% -spec delete_one(GoodsInfo, [GoodsStatus, GoodsNum]) -> [NewGoodsStatus, NewNum]
%% GoodsInfo                        :: #goods{}         物品记录
%% GoodsStatus|NewGoodsStatus       :: #goods_status{}  物品进程状态
%% GoodsNum | NewNum                :: integer()        物品要删除数量 | 还待删除的物品数量
%% @end
%%-------------------------------------------------------------------------------------------
delete_one(GoodsInfo, [GoodsStatus, GoodsNum]) ->
    if GoodsNum > 0 andalso GoodsInfo#goods.id > 0 ->
        case GoodsInfo#goods.num > GoodsNum of
            true ->
                NewNum = GoodsInfo#goods.num - GoodsNum,
                [_NewGoodsInfo, NewStatus] = change_goods_num(GoodsInfo, NewNum, GoodsStatus),
                [NewStatus, 0];
            false ->
                NewNum = GoodsNum - GoodsInfo#goods.num,
                NewStatus = delete_goods(GoodsInfo, GoodsStatus),
                [NewStatus, NewNum]
        end;
        true ->
            [GoodsStatus, GoodsNum]
    end;

delete_one(GoodsInfo, [GoodsStatus, GoodsNum, DelList]) ->
    if GoodsNum > 0 andalso GoodsInfo#goods.id > 0 ->
            case GoodsInfo#goods.num > GoodsNum of
                true ->
                    NewNum = GoodsInfo#goods.num - GoodsNum,
                    [_NewGoodsInfo, NewStatus] = lib_goods:change_goods_num(GoodsInfo, NewNum, GoodsStatus),
                    [NewStatus, 0, [{GoodsInfo,GoodsNum}|DelList]];
                false ->
                    NewNum = GoodsNum - GoodsInfo#goods.num,
                    NewStatus = lib_goods:delete_goods(GoodsInfo, GoodsStatus),
                    [NewStatus, NewNum, [{GoodsInfo,GoodsInfo#goods.num}|DelList]]
            end;
        true ->
            [GoodsStatus, GoodsNum, DelList]
    end.

delete_one(GoodsStatus, GoodsInfo, GoodsNum) ->
    case GoodsInfo#goods.num > GoodsNum of
        true when GoodsNum > 0 ->
            NewNum = GoodsInfo#goods.num - GoodsNum,
            [_NewGoodsInfo, NewGoodsStatus] = change_goods_num(GoodsInfo, NewNum, GoodsStatus),
            {ok, NewGoodsStatus, 0};
        _ ->
            NewNum = case GoodsNum > GoodsInfo#goods.num of
                         true -> GoodsNum - GoodsInfo#goods.num;
                         false -> 0
                     end,
            NewStatus = delete_goods(GoodsInfo, GoodsStatus),
            {ok, NewStatus, NewNum}
    end.

%%------------------------------------------------------------------------------------
%% @doc 删除物品，
%% -spec delete_goods(GoodsInfo, GoodsStatus) -> NewGoodsStatus
%% GoodsInfo                            :: #goods{}         物品记录
%% GoodsStatus | NewGoodsStatus         :: #goods_status{}  物品进程状态
%% @end
%% ------------------------------------------------------------------------------------
delete_goods(GoodsInfo, GoodsStatus) ->
    NewStatus = delete_goods2(GoodsInfo, GoodsStatus),
    %% 该格子物品全部删除，释放出一个空格子
    #goods{location = Location, cell = _Cell} = GoodsInfo,
    case lists:member(Location, ?GOODS_LOC_BAG_TYPES) of
        true ->
            lib_goods_util:release_num_cells(NewStatus, Location);
        false ->
            NewStatus
    end.
delete_goods2(GoodsInfo, GoodsStatus) ->
    lib_goods_util:delete_goods(GoodsInfo#goods.id),
    case is_cache(GoodsInfo#goods.location) of
        true ->
            Dict = lib_goods_dict:append_dict({del, goods, GoodsInfo#goods.id}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            Dict = lib_goods_dict:append_dict({del, goods, GoodsInfo#goods.id}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict}
    end,
    NewStatus.

%%---------------------------------------------------------------------
%% 更改物品格子位置和使用数量
%%---------------------------------------------------------------------
change_goods_cell_and_use(GoodsInfo, Location, Cell, #goods_status{dict=OGoodDict} = GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_cell_and_use(GoodsInfo, Location, Cell),
    NewStatus =
        case is_cache(Location) of
            true ->
                Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, OGoodDict),
                GoodsStatus#goods_status{dict = Dict};
            false ->
                case is_cache(GoodsInfo#goods.location) of
                    true ->
                        Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id}, OGoodDict),
                        GoodsStatus#goods_status{dict = Dict};
                    false ->
                        GoodsStatus
                end
        end,
    NewStatus1 = lib_goods_util:release_num_cells(NewStatus, GoodsInfo#goods.location),
    LastStatus = lib_goods_util:occupy_num_cells(NewStatus1, Location),
    [NewGoodsInfo, LastStatus].

%%-------------------------------------------------------------------------------------
%% @doc 更改物品数量
%% -spec change_goods_num(GoodsInfo, Num, GoodsStatus) -> [NewGoodsInfo, NewGoodsStatus]
%% GoodsInfo | NewGoodsInfo     :: #goods{}         物品记录
%% Num                          :: integer()        新数量
%% GoodsStatus | NewGoodsStatus :: #goods_status{}  新的物品进程状态
%% @end
%% ------------------------------------------------------------------------------------
change_goods_num(GoodsInfo, Num, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_num(GoodsInfo, Num),
    case is_cache(NewGoodsInfo#goods.location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            case dict:is_key(GoodsInfo#goods.id, GoodsStatus#goods_status.dict) of
                true ->
                    Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
                    NewStatus = GoodsStatus#goods_status{dict = Dict};
                false ->
                    NewStatus = GoodsStatus
            end
    end,
    [NewGoodsInfo, NewStatus].

%%----------------------------------------------------------
%% 更改物品格子位置
%%----------------------------------------------------------
change_goods_cell(GoodsInfo, Location, Cell, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_cell(GoodsInfo, Location, Cell),
    NewStatus = case is_cache(Location) of
                    true ->
                        Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
                        GoodsStatus#goods_status{dict = Dict};
                    false ->
                        case is_cache(GoodsInfo#goods.location) of
                            true ->
                                Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id},GoodsStatus#goods_status.dict),
                                GoodsStatus#goods_status{dict = Dict};
                            false ->
                                GoodsStatus
                        end
                end,
    NewStatus1 = lib_goods_util:release_num_cells(NewStatus, GoodsInfo#goods.location),
    LastStatus = lib_goods_util:occupy_num_cells(NewStatus1, Location),
    [NewGoodsInfo, LastStatus].

%%----------------------------------------------------------
%% 更改物品子位置
%%----------------------------------------------------------
change_goods_sub_location(GoodsInfo, Location, SubLocation, Cell, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_sub_location(GoodsInfo, Location, SubLocation, Cell),
    NewStatus = case is_cache(Location) of
                    true ->
                        Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
                        GoodsStatus#goods_status{dict = Dict};
                    false ->
                        GoodsStatus
                end,
    NewStatus1 = lib_goods_util:release_num_cells(NewStatus, GoodsInfo#goods.location),
    LastStatus = lib_goods_util:occupy_num_cells(NewStatus1, Location),
    [NewGoodsInfo, LastStatus].

%%----------------------------------------------
%% 更改物品格子位置和数量
%%----------------------------------------------
change_goods_cell_and_num(GoodsInfo, Location, Cell, Num, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_cell_and_num(GoodsInfo, Location, Cell, Num),
    case is_cache(Location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            case is_cache(GoodsInfo#goods.location) of
                true ->
                    Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id},GoodsStatus#goods_status.dict),
                    NewStatus = GoodsStatus#goods_status{dict = Dict};
                false ->
                    NewStatus = GoodsStatus
            end
    end,
    NewStatus1 = lib_goods_util:release_num_cells(NewStatus, GoodsInfo#goods.location),
    LastStatus = lib_goods_util:occupy_num_cells(NewStatus1, Location),
    [NewGoodsInfo,LastStatus].

%%----------------------------------------------
%% 更改物品等级
%%----------------------------------------------
change_goods_level_extra_attr(GoodsInfo, Location, Level, ExtraAttr, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_level_extra_attr(GoodsInfo, Level, ExtraAttr),
    case is_cache(Location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            case is_cache(GoodsInfo#goods.location) of
                true ->
                    Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id},GoodsStatus#goods_status.dict),
                    NewStatus = GoodsStatus#goods_status{dict = Dict};
                false ->
                    NewStatus = GoodsStatus
            end
    end,
    [NewGoodsInfo, NewStatus].

change_goods_player(GoodsInfo, PlayerId, Location, Cell, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_player(GoodsInfo, PlayerId, Location, Cell),
    case is_cache(Location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
            NewStatus = GoodsStatus#goods_status{dict = Dict};
        false ->
            case is_cache(GoodsInfo#goods.location) of
                true ->
                    Dict = lib_goods_dict:append_dict({del, goods, NewGoodsInfo#goods.id},GoodsStatus#goods_status.dict),
                    NewStatus = GoodsStatus#goods_status{dict = Dict};
                false ->
                    NewStatus = GoodsStatus
            end
    end,
    [NewGoodsInfo,NewStatus].

change_goods(GoodsInfo, Location, GoodsStatus) ->
    case is_cache(Location) of
        true ->
            Dict = lib_goods_dict:append_dict({add, goods, GoodsInfo}, GoodsStatus#goods_status.dict),
            GoodsStatus#goods_status{dict = Dict};
        false ->
            case is_cache(GoodsInfo#goods.location) of
                true ->
                    Dict = lib_goods_dict:append_dict({del, goods, GoodsInfo#goods.id},GoodsStatus#goods_status.dict),
                    GoodsStatus#goods_status{dict = Dict};
                false ->
                    GoodsStatus
            end
    end.

%%----------------------------------------------------------
%% 更改物品格子位置
%%----------------------------------------------------------
change_goods_skill_id(GoodsInfo, SkillId, GoodsStatus) ->
    NewGoodsInfo = lib_goods_util:change_goods_skill_id(GoodsInfo, SkillId),
    NewStatus = case is_cache(GoodsInfo#goods.location) of
                    true ->
                        Dict = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatus#goods_status.dict),
                        GoodsStatus#goods_status{dict = Dict};
                    false ->
                        GoodsStatus
                end,
    [NewGoodsInfo, NewStatus].

%% 绑定物品
bind_goods(GoodsInfo) ->
    Sql = io_lib:format(?SQL_GOODS_UPDATE_BIND, [?BIND, ?CANNOT_TRADE, GoodsInfo#goods.id]),
    db:execute(Sql),
    GoodsInfo#goods{bind = ?BIND, trade = ?CANNOT_TRADE}.


check_goods_num([], _) ->
    {ok, 1};
check_goods_num([{GoodsTypeId, GoodsNum}|H], GoodsStatus) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{bag_location = BagLocation} ->
            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, BagLocation, GoodsStatus#goods_status.dict),
            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
            case TotalNum >= GoodsNum of
                true ->
                    check_goods_num(H, GoodsStatus);
                false ->
                    not_enough
            end;
        _ ->
            ?ERR("check_goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
            not_enough
    end.

check_bind_goods_num([], _) -> {ok, 1};
check_bind_goods_num([{GoodsTypeId, GoodsNum}|H], GoodsStatus) ->
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{bag_location = BagLocation} ->
            GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, ?BIND, BagLocation, GoodsStatus#goods_status.dict),
            TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
            case TotalNum >= GoodsNum of
                true ->
                    check_bind_goods_num(H, GoodsStatus);
                false ->
                    not_enough
            end;
        _ ->
            ?ERR("check_bind_goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
            not_enough
    end.

%%--------------------------------------------------
%% 检查物品是否可以加入到背包，能不能加入完全取决于背包格子数
%% @param  GoodsStatus   description
%% @param  GoodsTypeList GoodsTypeList
%% @return               {false, ErrorCode} | true
%%--------------------------------------------------
can_give_goods(GoodsStatus, GoodsTypeList) ->
    #goods_status{player_id = PlayerId} = GoodsStatus,
    NeedNumList = lib_storage_util:get_need_cell_num(PlayerId, GoodsStatus, GoodsTypeList),
    Res = do_can_give_goods(NeedNumList, GoodsStatus),
    Res.

do_can_give_goods([], _GoodsStatus) -> true;
do_can_give_goods([{Location, NeedNum}|L], GoodsStatus) ->
    IsLimitBagType = lists:member(Location, ?GOODS_LOC_BAG_LIMIT_TYPES),
    case IsLimitBagType of
        true ->
            NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, Location),
            case NullCellNum >= NeedNum of
                true -> do_can_give_goods(L, GoodsStatus);
                _ -> {false, data_goods:get_no_cell_errcode(Location)}
            end;
        _ ->
            do_can_give_goods(L, GoodsStatus)
    end.

can_give_goods(GoodsStatus, GoodsTypeList, LocLimitL) ->
    #goods_status{player_id = PlayerId} = GoodsStatus,
    NeedNumList = lib_storage_util:get_need_cell_num(PlayerId, GoodsStatus, GoodsTypeList),
    Res = do_can_give_goods(NeedNumList, GoodsStatus, LocLimitL),
    Res.

do_can_give_goods([], _GoodsStatus, _LocLimitL) -> true;
do_can_give_goods([{Location, NeedNum}|L], GoodsStatus, LocLimitL) ->
    IsLimitBagType = lists:member(Location, LocLimitL),
    case IsLimitBagType of
        true ->
            NullCellNum = lib_goods_util:get_null_cell_num(GoodsStatus, Location),
            case NullCellNum >= NeedNum of
                true -> do_can_give_goods(L, GoodsStatus, LocLimitL);
                _ -> {false, data_goods:get_no_cell_errcode(Location)}
            end;
        _ ->
            do_can_give_goods(L, GoodsStatus, LocLimitL)
    end.

%% 拆分可发送和不可发送的道具
spilt_send_able_goods(GoodsStatus, GoodsTypeList) ->
    #goods_status{player_id = PlayerId, num_cells = NumCells} = GoodsStatus,
    LocationNumList = lib_storage_util:get_same_goods_cell_num(PlayerId, GoodsStatus, GoodsTypeList),
    LocationAvailableList = [{Location, MaxNum-UseNum}||{Location, {UseNum, MaxNum}} <- maps:to_list(NumCells), MaxNum>0],
    %% 按照占用格子数先排序
    SortLocationNumList = lists:reverse(lists:keysort(2, LocationNumList)),
    spilt_send_able_goods(SortLocationNumList, LocationAvailableList, [], []).


spilt_send_able_goods([], _, SendAbleList, CantSendList) -> {SendAbleList, CantSendList};
spilt_send_able_goods([{Location, NeedCellNum, NumPerCell, ObjectList}|L], LocationAvailableList, SendAbleList, CantSendList) ->
    IsLimitBagType = lists:member(Location, ?GOODS_LOC_BAG_LIMIT_TYPES),
    case IsLimitBagType of
        true ->
            {_, LeftCellNum} = ulists:keyfind(Location, 1, LocationAvailableList, {Location, 0}),
            case NeedCellNum =< LeftCellNum of
                true ->
                    NewLocationAvailableList = lists:keystore(Location, 1, LocationAvailableList, {Location, LeftCellNum-NeedCellNum}),
                    spilt_send_able_goods(L, NewLocationAvailableList, SendAbleList++ObjectList, CantSendList);
                _ ->
                    NewLocationAvailableList = lists:keystore(Location, 1, LocationAvailableList, {Location, 0}),
                    SpiltNum = LeftCellNum*NumPerCell,
                    {L1, L2} = lib_goods_util:spilt_object_list_by_num(ObjectList, SpiltNum),
                    spilt_send_able_goods(L, NewLocationAvailableList, SendAbleList++L1, CantSendList++L2)
            end;
        _ ->
            spilt_send_able_goods(L, LocationAvailableList, SendAbleList++ObjectList, CantSendList)
    end.

%%--------------------------------------------------
%% goods => reward_list
%%--------------------------------------------------
conver_goods_to_reward(GoodsInfoList) ->
    F = fun(Goods, L) ->
        Reward = conver_goods_to_reward_helper(Goods),
        Reward ++ L
    end,
    lists:foldl(F, [], GoodsInfoList).

conver_goods_to_reward_helper(Goods) ->
    #goods{
        goods_id = GoodsTypeId, num = Num, expire_time = ExpireTime, type = Type, subtype = SubType, bind = Bind, other = Other
    } = Goods,
    if
        Type == ?GOODS_TYPE_OBJECT ->
            case SubType of
                ?GOODS_SUBTYPE_GOLD -> [{?TYPE_GOLD, 0, Num}];
                ?GOODS_SUBTYPE_BGOLD -> [{?TYPE_BGOLD, 0, Num}];
                ?GOODS_SUBTYPE_COIN -> [{?TYPE_COIN, 0, Num}];
                ?GOODS_SUBTYPE_EXP -> [{?TYPE_EXP, 0, Num}];
                _ -> []
            end;
        true ->
            AttrList = [{bind, Bind}],
            AttrList1 = ?IF(ExpireTime == 0, AttrList, [{expire_time, ExpireTime}|AttrList]),
            AttrList2 = ?IF(Other#goods_other.extra_attr == [], AttrList1, [{extra_attr, Other#goods_other.extra_attr}|AttrList1]),
            AttrList3 = ?IF(Other#goods_other.optional_data == [], AttrList2, [{optional_data, Other#goods_other.optional_data}|AttrList2]),
            LastAttrList = ?IF(Other#goods_other.addition == [], AttrList3, [{addition, Other#goods_other.addition}|AttrList3]),
            case length(AttrList) == 1 of
                true -> %% 只有绑定属性，
                    [{?TYPE_GOODS, GoodsTypeId, Num, Bind}]; %% ?TYPE_GOODS object_list_plus_extra函数才会进行叠加
                _ ->
                    [{?TYPE_ATTR_GOODS, GoodsTypeId, Num, LastAttrList}]
            end
    end.


new_goods_other(GoodsInfo) ->
    NewGoodsOther = case GoodsInfo#goods.type of
        ?GOODS_TYPE_EQUIP -> %% 装备需要生成随机属性，如果原来的装备已经有属性则不用重新生成
            EquipNum = data_goods:get_config(equip_num),
            EquipType = GoodsInfo#goods.equip_type,
            ExtraAttr = GoodsInfo#goods.other#goods_other.extra_attr,
            case EquipType > 0 andalso EquipType =< EquipNum of
                true ->
                    GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                    case ExtraAttr == [] of
                        true ->
                            lib_equip:gen_equip_other_attr(GoodsTypeInfo, GoodsInfo#goods.other);
                        false ->
                            BaseRating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr),
                            GoodsInfo#goods.other#goods_other{rating = BaseRating}
                    end;
                false -> GoodsInfo#goods.other
            end;
        ?GOODS_TYPE_DECORATION ->  % 幻饰
            ExtraAttr = GoodsInfo#goods.other#goods_other.extra_attr,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            case ExtraAttr == [] of
                true ->
                    ExtraAttr1 = lib_decoration:gen_equip_extra_attr(GoodsTypeInfo, []),
                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr1),
                    GoodsInfo#goods.other#goods_other{rating = BaseRating, extra_attr = ExtraAttr1};
                false ->
                    BaseRating = lib_equip:cal_equip_rating(GoodsTypeInfo, ExtraAttr),
                    GoodsInfo#goods.other#goods_other{rating = BaseRating}
            end;
%                 ?GOODS_TYPE_SOUL -> %% 符文根据配置生成属性
%                     #goods{
%                         subtype = SubTypeR,
% %%                        cell = Cell,
%                         color = ColorR,
%                         level = LevelR,
%                         other = GoodsOtherR
%                     } = GoodsInfo,
%                     ExtraAttr = lib_soul:count_one_soul_extra_attr(SubTypeR, ColorR, LevelR),
%                     GoodsOtherR#goods_other{extra_attr = ExtraAttr};
        ?GOODS_TYPE_SOUL -> %% 符文根据配置生成属性
            #goods{
                subtype = SubTypeR,
%%                        cell = Cell,
                color = ColorR,
                level = LevelR,
                other = GoodsOtherR
            } = GoodsInfo,
            ExtraAttr = lib_soul:count_one_soul_extra_attr(SubTypeR, ColorR, LevelR),
            GoodsOtherR#goods_other{extra_attr = ExtraAttr};
        ?GOODS_TYPE_SEAL ->
            #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_seal:calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_DRACONIC ->
             #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_draconic:calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_EUDEMONS ->
            #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_eudemons:calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_CONSTELLATION ->
            #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_constellation_equip:calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_BABY_EQUIP ->
            #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_baby:gen_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_REVELATION ->
            #goods{other = GoodsOtherR} = GoodsInfo,
            GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
            lib_revelation_equip:gen_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
%                     #goods{other = GoodsOtherR} = GoodsInfo,
%                     GoodsTypeInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
%                     lib_revelation_equip:gen_equip_dynamic_attr(GoodsTypeInfo, GoodsOtherR);
        ?GOODS_TYPE_MOUNT_EQUIP ->
            lib_mount_equip:pet_equip_new_goods(GoodsInfo, 1);
        ?GOODS_TYPE_MATE_EQUIP ->
            lib_mount_equip:pet_equip_new_goods(GoodsInfo, 2);
        ?GOODS_TYPE_GOD_COURT ->
            lib_god_court:create_goods_other(GoodsInfo);
        _ ->
            GoodsInfo#goods.other
    end,
    NewGoodsOther.


gm_cost_goods(StartTime, EndTime, ProductTypeIdStr, GoodsListStr) ->
    GoodsList = ulists:kv_list_plus_extra([[], util:string_to_term(GoodsListStr)]),
    ProductTypeIdList = [_ID || _ID <- util:string_to_term(ProductTypeIdStr), is_integer(_ID)],
    GoodsTypeIdList = [_GTypeId ||{_GTypeId, _} <- GoodsList],
    %?PRINT("gm ProductTypeIdList ~p~n", [ProductTypeIdList]),
    %% 获取产出
    GoodsIdStrList = gm_cost_goods_format_goods_id_list(GoodsTypeIdList, []),
    ProductTypeStr = ulists:list_to_string(ProductTypeIdList, ","),
    GetStr = "select goods_id, goods_num, player_id from log_goods where time>=~p and time<~p and type in (~s) and goods_id in (~s)",
    FunGet = fun(GoodsIdStr, Acc) ->
        SqlGet = io_lib:format(GetStr, [StartTime, EndTime, ProductTypeStr, GoodsIdStr]),
        DbList = db:get_all(SqlGet),
        DbList ++ Acc
    end,
    DbGoodsList = lists:foldl(FunGet, [], GoodsIdStrList),
    %% 根据玩家id，物品id分组
    FunGroup = fun([GoodsId, Num, PlayerId], M) ->
        PlayerGoodsM = maps:get(PlayerId, M, #{}),
        OldNum = maps:get(GoodsId, PlayerGoodsM, 0),
        maps:put(PlayerId, maps:put(GoodsId, OldNum+Num, PlayerGoodsM), M)
    end,
    DataMap = lists:foldl(FunGroup, #{}, DbGoodsList),
    %% 计算每个玩家要扣的道具列表
    FunCalc = fun(PlayerId, PlayerGoodsM, Acc) ->
        FunCalc2 = fun({GoodsId, NumCfg}, Acc2) ->
            NumGet = maps:get(GoodsId, PlayerGoodsM, 0),
            case NumGet>NumCfg of
                true ->
                    {_, OldList} = ulists:keyfind(PlayerId, 1, Acc2, {PlayerId, []}),
                    NewAcc2 = lists:keystore(PlayerId, 1, Acc2, {PlayerId, [{GoodsId, NumGet-NumCfg}|OldList]}),
                    NewAcc2;
                _ ->
                    Acc2
            end
        end,
        lists:foldl(FunCalc2, Acc, GoodsList)
    end,
    PlayerDeleteList = maps:fold(FunCalc, [], DataMap),
    %?PRINT("gm PlayerDeleteList ~p~n", [PlayerDeleteList]),
    spawn(fun() -> gm_cost_goods_core(PlayerDeleteList, 1) end).


gm_cost_goods_format_goods_id_list([], Return) -> Return;
gm_cost_goods_format_goods_id_list(GoodsTypeIdList, Return) ->
    case length(GoodsTypeIdList) >= 100 of
        true ->
            {PreList, LeftList} = lists:split(100, GoodsTypeIdList),
            NewReturn = [ulists:list_to_string(PreList, ",")|Return],
            gm_cost_goods_format_goods_id_list(LeftList, NewReturn);
        _ ->
            [ulists:list_to_string(GoodsTypeIdList, ",")|Return]
    end.

gm_cost_goods_core([], _Cnt) -> ok;
gm_cost_goods_core([{PlayerId, DelGoodsList}|PlayerDeleteList], Cnt) ->
    case Cnt rem 5 == 0 of
        true -> timer:sleep(300);
        _ -> ok
    end,
    case lib_player:get_alive_pid(PlayerId) of
        false ->
            Sql = io_lib:format(
                <<"select gid, goods_id, num from goods_high where pid = ~p and goods_id in (~s) and (location = 4 or location = 5)">>,
                [PlayerId, ulists:list_to_string([TmpId || {TmpId, _} <- DelGoodsList], ",")]),
            DbList = db:get_all(Sql),
            F = fun({DelGoodsId, DelNum}, Acc) ->
                {AccAdd, _} =
                    lists:foldl(fun([GId, GTypeId, Num], {Acc2, CostNum}) ->
                        case GTypeId == DelGoodsId andalso CostNum > 0 of
                            true ->
                                ?IF(Num > CostNum,
                                    {[{update_num, {GId, GTypeId, Num-CostNum, CostNum}}|Acc2], 0},
                                    {[{delete, {GId, GTypeId, Num}}|Acc2], CostNum-Num});
                            _ -> {Acc2, CostNum}
                        end
                    end, {[], DelNum}, DbList),
                AccAdd ++ Acc
            end,
            OpList = lists:foldl(F, [], DelGoodsList),
            %?PRINT("gm OpList ~p~n", [{PlayerId, OpList}]),
            F2 = fun() ->
                lists:foreach(
                    fun(Op) ->
                        case Op of
                            {update_num, {GId, GTypeId, Num, DelNum}} ->
                                lib_storage_util:change_storage_num(GId, Num),
                                lib_log_api:log_throw(gm_cost, PlayerId, 0, GTypeId, DelNum, 0, 0);
                            {delete, {GId, GTypeId, DelNum}} ->
                                lib_goods_util:delete_goods(GId),
                                lib_log_api:log_throw(gm_cost, PlayerId, 0, GTypeId, DelNum, 0, 0)
                        end
                    end, OpList)
            end,
            catch lib_goods_util:transaction(F2),
            gm_cost_goods_core(PlayerDeleteList, Cnt+1);
        Pid ->
            lib_player:apply_cast(Pid, ?APPLY_CAST_SAVE, ?MODULE, gm_cost_goods_online, [DelGoodsList]),
            gm_cost_goods_core(PlayerDeleteList, Cnt+1)
    end.

gm_cost_goods_online(PS, DelGoodsList) ->
    case  lib_goods_api:get_goods_num(PS, [GTypeId ||{GTypeId, _} <- DelGoodsList]) of
        [] -> {ok, PS};
        GoodsList ->
            CostList = lists:foldl(fun({GTypeId, DelNum}, Acc) ->
                case lists:keyfind(GTypeId, 1, GoodsList) of
                    {GTypeId, Num} when Num >= DelNum -> [{?TYPE_GOODS, GTypeId, DelNum}|Acc];
                    {GTypeId, Num} when Num > 0 -> [{?TYPE_GOODS, GTypeId, Num}|Acc];
                    _ -> Acc
                end
            end, [], DelGoodsList),
            %?PRINT("gm online  ~p~n", [CostList]),
            case lib_goods_api:cost_object_list_with_check(PS, CostList, gm_cost, "") of
                {true, NewPS} ->
                    {ok, NewPS};
                {false, _ErrorCode, _} ->
                    {ok, PS}
            end
    end.

%%------------------------------------------------- 暂时没有用的函数

%% 删除一类物品的指定数量
%% @spec delete_type_list_as_much_as_possible({GoodsTypeId,GoodsNum}, {GoodsStatus, RealDelGoodsList|[] })
%%          -> {ok, NewGoodsStatus, RealDelGoodsList} | Error
% delete_type_list_as_much_as_possible({GoodsTypeId, GoodsNum}, {GoodsStatus, RealDelGoodsList}) ->
%     case data_goods_type:get(GoodsTypeId) of
%         #ets_goods_type{bag_location = BagLocation} ->
%             GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsTypeId, BagLocation, GoodsStatus#goods_status.dict),
%             TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
%             DelNum = case TotalNum >= GoodsNum of
%                          true  -> GoodsNum;
%                          false -> TotalNum
%                      end,
%             case catch delete_more(GoodsStatus, GoodsList, DelNum) of
%                 {ok, GoodsStatus} ->
%                     NewRealDelGoodsList = [{GoodsTypeId, DelNum}|RealDelGoodsList],
%                     {ok, {GoodsStatus, NewRealDelGoodsList}};
%                 Reason ->
%                     catch ?ERR("lib_goods:delete_type_list_as_much_as_possible/2 ERROR: del goods error, goods_type_id=~p, reason = ~p~n", [GoodsTypeId, Reason]),
%                     {ok, {GoodsStatus, RealDelGoodsList}}
%             end;
%         _ ->
%             ?ERR("delete_type_list_as_much_as_possible err: goods_type_id=~p err_config", [GoodsTypeId]),
%             {ok, {GoodsStatus, RealDelGoodsList}}
%     end.

%% 扩展帮派仓库
% extend_guild(PlayerStatus, GoodsStatus, GoldNum, GoodsNum, GoodsTypeList) ->
%     GoodsList = lib_goods_util:sort(GoodsTypeList, cell),
%     F = fun() ->
%         ok = lib_goods_dict:start_dict(),
%         NewPlayerStatus = lib_goods_util:cost_money(PlayerStatus, GoldNum, gold, goods_extend_guild),
%         %% 日志
%         lib_log_api:log_consume(goods_extend_guild, gold, PlayerStatus, NewPlayerStatus, ""),
%         [NewStatus, _] = lists:foldl(fun delete_one/2, [GoodsStatus, GoodsNum], GoodsList),
%         Dict = lib_goods_dict:handle_dict(NewStatus#goods_status.dict),
%         NewStatus2 = NewStatus#goods_status{dict = Dict},
%         {ok, NewPlayerStatus, NewStatus2}
%     end,
%     lib_goods_util:transaction(F).


%%------------------------------------------------------
%% @doc 扩展背包
%% -spec expand_bag(PlayerStatus, GoodsStatus, Type, Num, Gold) -> {ok, NewPlayerStatus, NewGoodsStatus}
%% when
%%      PlayerStatus|NewPlayerStatus :: #player_status{}    玩家记录
%%      GoodsStatus|NewGoodsStatus   :: #goods_status{}     物品进程状态
%%      Type                         :: integer()           背包|仓库
%%      Num                          :: integer()           格子数
%%      Gold                         :: integer()           元宝数
%% @end
%%---------------------------------------------------------
%% expand_bag(Ps, Gs, Pos, Num, GoodsList, Gold, DelNum) ->
%%     F = fun() ->
%%                 if
%%                     Gold =< 0 -> PS = Ps;
%%                     true ->
%%                         if
%%                             Pos == ?GOODS_LOC_BAG ->
%%                                 PS = lib_goods_util:cost_money(Ps, Gold, gold, extend_bag, ["extend_bag"]);
%%                             true ->
%%                                 PS = lib_goods_util:cost_money(Ps, Gold, gold, extend_bag, ["extend_storage"])
%%                         end
%%                 end,
%%                 if
%%                     GoodsList == [] -> {GS = Gs, UpGoods = []};
%%                     true ->
%%                         ok = lib_goods_dict:start_dict(),
%%                         {ok, GS1} = delete_more(Gs, GoodsList, DelNum),
%%                         %% {ok, GS1} = lib_goods:delete_goods_list(Gs, GoodsList),
%%                         {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(GS1#goods_status.dict),
%%                         GS = GS1#goods_status{dict = Dict}
%%                 end,

%%                 case Pos of
%%                     ?GOODS_LOC_BAG ->
%%                         NewPs = lib_goods_util:extend_bag(PS, Num),
%%                         NullCells = lists:seq((Ps#player_status.cell_num+1), NewPs#player_status.cell_num),
%%                         NewNullCellsMap = lib_goods_util:add_null_cell(Gs#goods_status.null_cells, Pos, NullCells),
%%                         NewGs = GS#goods_status{null_cells = NewNullCellsMap},
%%                         {ok, NewPs, NewGs, UpGoods};
%%                     _->
%%                         NewPs = lib_storage_util:extend_storage(PS, Num),
%%                         {ok, NewPs, GS, UpGoods}
%%                 end
%%         end,
%%     lib_goods_util:transaction(F).
% expand_bag(Gs, Pos, AddCellNum, GoodsList, DelNum, RoleArgs) ->
%     {PsMoney, NowCellNum} = RoleArgs,
%     F = fun() ->
%                 About    = ?IF(Pos == ?GOODS_LOC_BAG, "extend_bag", "extend_storage"),
%                 NPsMoney = ?IF(PsMoney#ps_money.cost =< 0, PsMoney,
%                                lib_goods_util:new_cost_money(PsMoney, About)),
%                 if
%                     GoodsList == [] -> {GS = Gs, UpGoods = []};
%                     true ->
%                         ok = lib_goods_dict:start_dict(),
%                         {ok, GS1} = delete_more(Gs, GoodsList, DelNum),
%                         {Dict, UpGoods} = lib_goods_dict:handle_dict_and_notify(GS1#goods_status.dict),
%                         GS = GS1#goods_status{dict = Dict}
%                 end,
%                 if
%                     Pos == ?GOODS_LOC_BAG ->
%                         AllCellNum = lib_goods_util:extend_bag(PsMoney#ps_money.id, NowCellNum, AddCellNum),
%                         NewGs = lib_goods_util:expand_num_cells(Gs, Pos, AllCellNum),
%                         {ok, NPsMoney, AllCellNum, NewGs, UpGoods};
%                     true ->
%                         AllCellNum = lib_storage_util:extend_storage(PsMoney#ps_money.id, NowCellNum, AddCellNum),
%                         {ok, NPsMoney, AllCellNum, GS, UpGoods}
%                 end
%         end,
%     lib_goods_util:transaction(F).