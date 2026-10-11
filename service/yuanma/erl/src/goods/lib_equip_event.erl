%% ---------------------------------------------------------------------------
%% @doc 装备模块
%% @author lxl
%% @since  2020-3-9
%% @deprecated 装备模块事件触发
%% ---------------------------------------------------------------------------
-module(lib_equip_event).
-include("common.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("def_goods.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("equip_suit.hrl").

-compile(export_all).

%% 穿戴装备
dress_equip_event(PS, GoodsStatus, GoodsInfo) ->
    #goods{goods_id = GoodsTypeId, equip_type = EquipType, color = Color} = GoodsInfo,
    {ok, PSAfDispatch} = lib_player_event:dispatch(PS, ?EVENT_EQUIP, GoodsInfo),
    #goods_status{red_equip_award_list=RedEquipAwardList, dict = Dict} = lib_goods_do:get_goods_status(),
    EquipList = lib_goods_util:get_equip_list(PS#player_status.id, Dict),
    ReRedEquipAwardList = lib_equip:re_static_red_equip_award(RedEquipAwardList),
%%    %% 后续触发##
%%    %% 永恒碑谷
%%    EquipStage = lib_equip:get_equip_stage(GoodsTypeId),
%%    EquipStar = lib_equip:get_equip_star(GoodsTypeId),
%%    {ok, PSAfValley1} = lib_eternal_valley_api:trigger(PSAfDispatch, {equip, GoodsInfo#goods.cell, EquipStage, Color, EquipStar}),
%%    {ok, PSAfValley2} = lib_eternal_valley_api:trigger(PSAfValley1, {equip_ids, GoodsTypeId}),
    {ok, PSAfValley1} = lib_eternal_valley_api:trigger(PSAfDispatch, {wear_equip_status, EquipList}),
    {ok, PSAfSupVip} = lib_supreme_vip_api:wear_equip_event(PSAfValley1),
    {ok, TemplePs} = lib_temple_awaken_api:trigger_equip_status(PSAfSupVip, EquipList),
    %% 使魔
    DemonsPS = lib_demons_api:dress_equip(TemplePs),
    LastPS = DemonsPS,
	%% 触发任务
    lib_task_api:equip(LastPS, lib_equip_api:get_equip_task_info(LastPS#player_status.id)),
    lib_task_api:equip_stage(LastPS, GoodsStatus#goods_status.stage_award_list),
    lib_task_api:active_red_suit(LastPS, ReRedEquipAwardList),
    %% 刷新榜单
    lib_common_rank_api:reflash_rank_by_equipment(LastPS),
    %% 触发成就
    lib_achievement_api:wear_equip_event(LastPS, GoodsTypeId, EquipType, Color),

    lib_achievement_api:wear_equip_stage(LastPS, EquipList),
    LastPS.

%% 装备强化
equip_stren_event(PS, GS, EquipStrenInfo) ->
	#goods_status{stren_award_list = StrenAwardList} = GS,
	%% 触发成就
    TotalStrenLv = lib_equip:get_12_equip_award_sum_lv(StrenAwardList, ?WHOLE_AWARD_STREN),
    lib_achievement_api:equip_stren_event(PS, TotalStrenLv),
    %% 任务
    lib_task_api:stren_equip(PS, StrenAwardList),
    %% 每日强化活跃度
    lib_activitycalen_api:role_success_end_activity(PS#player_status.id, ?MOD_EQUIP, 1, length(EquipStrenInfo)),
    %% 更新冲榜榜单信息
    lib_rush_rank_api:reflash_rank_by_strengthen_rush(PS),
    {ok, SupvipPS} = lib_supreme_vip_api:equip_stren_event(PS, StrenAwardList),
    {ok, TemplePs} = lib_temple_awaken_api:trigger_strength_sum_lv(SupvipPS, StrenAwardList),
    TemplePs.
	
%% 装备精炼
equip_refine_event(PS, GS, _EquipRefineInfo) ->
	#goods_status{refine_award_list = RefineAwardList} = GS,
	% 触发成就
    TotalRefineLv = lib_equip:get_12_equip_award_sum_lv(RefineAwardList, ?WHOLE_AWARD_STREN),
    lib_achievement_api:equip_refine_event(PS, TotalRefineLv),
    % 触发任务
    lib_task_api:refine_equip(PS, RefineAwardList),
    %% 更新冲榜榜单信息
    lib_rush_rank_api:reflash_rank_by_strengthen_rush(PS),
    PS.

%% 套装打造
make_suit_event(PS, GS, _EquipPos, _Lv, _NewSLv) ->
    #goods_status{equip_suit_list = SuitList, equip_suit_state = EquipSuitState} = GS,
    SuitNumList = lib_equip:statistics_suit_num(SuitList),  % 套装级别和数量映射
    %% 永恒碑谷
%%    case Lv == ?EQUIP_SUIT_LV_EQUIP of
%%        true ->
%%            {ok, PSAfValley} = lib_eternal_valley_api:trigger(PS, {equip_suit, EquipPos, NewSLv});
%%        false ->
%%            PSAfValley = PS
%%    end,
    %% 榜单
    lib_rush_rank_api:reflash_rank_by_suit_rush(PS),
    %% 成就
    lib_achievement_api:make_equip_event(PS, SuitNumList),
    lib_achievement_api:async_event(PS#player_status.id, lib_achievement_api, suit_info_event, EquipSuitState),
    %% 任务
    lib_task_api:active_suit(PS, SuitNumList),
    %% 契约之书
    {ok, Ps1} = lib_eternal_valley_api:trigger(PS, {active_suit, SuitNumList}),
    {ok, TemplePs} = lib_temple_awaken_api:trigger_suit_status(Ps1, EquipSuitState),
    PSAfPushGift = lib_push_gift_api:equip_suit(TemplePs),
    {ok, PSAfWelfare} = lib_grow_welfare_api:make_equip_suit(PSAfPushGift, EquipSuitState),
    PSAfWelfare.

%% 穿戴宝石
equip_stone_event(PS, GoodsStatus) ->
    TotalStoneLv = lib_equip:get_12_equip_award_sum_lv(GoodsStatus#goods_status.stone_award_list, ?WHOLE_AWARD_STONE),
    %% 成就  
    lib_achievement_api:equip_stone_event(PS, TotalStoneLv),
    lib_achievement_api:equip_stone_lv_event(PS, GoodsStatus#goods_status.stone_award_list),
    %% 培养物战力活动
    lib_train_act:stone_train_power_up(PS),
    %% 任务
    lib_task_api:equip_stone_lv(PS, GoodsStatus#goods_status.stone_award_list),
    %% 榜单
    lib_rush_rank_api:reflash_rank_by_stone_rush(PS),
    PS.

%% 装备洗练
wash_equip_event(PS, _EquipPos, WashAttrList, NewEquipWashMap, IsUpgrade) ->
    %% 触发成就
    ColorNumList = lists:foldl(fun({_Pos, Color, _Id, _Val}, Acc) ->
        {_, PreNum} = ulists:keyfind(Color, 1, Acc, {Color, 0}),
        lists:keystore(Color, 1, Acc, {Color, PreNum + 1})
    end, [], WashAttrList),
    lib_achievement_api:equip_wash_event(PS, ColorNumList),
    {ok, PS1} = lib_grow_welfare_api:equip_wash(PS, 1),
    {ok, PS2} = lib_custom_the_carnival:equip_wash(PS1, 1),
    {ok, ResPs} = lib_eternal_valley_api:trigger(PS2, {wash_equip_status, NewEquipWashMap}),
    case IsUpgrade of
        true ->
            {ok, LastPSTmp} = lib_temple_awaken_api:trigger_wash_status(ResPs, NewEquipWashMap),
            LastPS = lib_push_gift_api:equip_wash_upgrade(LastPSTmp, _EquipPos);
        _ ->
            LastPS = ResPs
    end,
    LastPS.