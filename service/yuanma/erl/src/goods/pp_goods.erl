%% ---------------------------------------------------------
%% Author:  xyj
%% Email:   156702030@qq.com
%% Created: 2011-12-13
%% Description: 物品操作
%% --------------------------------------------------------
-module(pp_goods).
-export([handle/3]).
-export([
    send_power_compare_list/3,
    send_power_compare_list/5,
    get_power_compare_from_other_server/5,
    send_equip_list/4
    , send_equip_list/6
    , get_equip_list_from_other_server/6
    , make_equip_list_pack/2

    , send_goods_info/3
    , send_goods_info/4
    , get_goods_info_from_other_server/5
    , make_goods_info_pack/3
    , pack_goods_list/1
    , pack_goods_list/4
    , make_self_goods_info_pack/1
    , send_bag_goods_list/3
    , get_count_attrlist_power/2
]).

-include("common.hrl").
-include("server.hrl").
-include("def_goods.hrl").
-include("sql_goods.hrl").
-include("goods.hrl").
-include("shop.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("gift.hrl").
-include("chat.hrl").
-include("marriage.hrl").
-include("rec_offline.hrl").
-include("def_fun.hrl").
-include("soul.hrl").
-include("mon_pic.hrl").
-include("mount.hrl").
-include("arbitrament.hrl").
-include("eudemons.hrl").
-include("medal.hrl").
-include("star_map.hrl").
-include("skill.hrl").
-include("guild.hrl").
-include("rec_dress_up.hrl").
-include("rec_baby.hrl").

%% 查询物品详细信息
handle(Cmd = 15000, PlayerStatus, [GoodsId]) ->
    Args = make_self_goods_info_pack(GoodsId),
    {ok, BinData} = pt_150:write(Cmd, Args),
    lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData);

%% 查看别人物品信息
handle(15001, PlayerStatus, [RoleId, GoodsId]) ->
    #player_status{id = Id, sid = Sid} = PlayerStatus,
    if
        Id =:= RoleId ->
            send_goods_info(PlayerStatus, Sid, GoodsId);
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, pp_goods, send_goods_info, [Sid, GoodsId])
    end;

%% 背包开启格子
handle(15002, Ps, [Pos, Num]) ->
    case lib_goods_do:expand_bag(Ps, Pos, Num) of
        {ok, AllNum, NewPs} -> Res = 1;
        {false, Res} -> NewPs = Ps, AllNum = 0
    end,
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15002, [Res, Pos, AllNum]),
    {ok, NewPs};

%% 物品背包移动
handle(15003, Ps, [GoodId, FromPos, ToPos]) ->
    {ResCode, NewPs} = lib_goods_do:change_pos(Ps, GoodId, FromPos, ToPos),
    lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15003, [ResCode]),
    {ok, NewPs};

%% 15004 整理背包 (新项目没有整理背包需求)
% handle(15004, Ps, [Pos])->
%     if
%         Pos == ?GOODS_LOC_STORAGE orelse Pos == ?GOODS_LOC_BAG ->
%             case lib_goods_do:order(Ps, Pos) of
%                 [1] -> handle(15010, Ps, [Pos]);
%                 ResCode ->
%                     lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15004, [ResCode])
%             end;
%         true ->
%             skip
%     end;

%% 15005 拆分 (新项目没有整理背包需求)
% handle(15005, Ps, [GoodsId, GoodsNum]) ->
%     ResCode = lib_goods_do:split(GoodsId, GoodsNum),
%     lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15005, [ResCode]);

%% 15006 物品续费 (新项目暂时没有整理背包需求)
% handle(15006, Ps, [GoodsId]) ->
%     [ResCode, NewPs, EndTime] = lib_goods_do:goods_renew(Ps, GoodsId),
%     lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15006, [ResCode, GoodsId, EndTime]),
%     {ok, NewPs};

% 特殊货币
handle(15008, PS, [CurrencyId]) ->
    lib_goods_api:send_update_currency(PS, CurrencyId);

% 所有的特殊货币
handle(15009, PS, []) ->
    List = maps:to_list(PS#player_status.currency_map),
    {ok, BinData} = pt_150:write(15009, [List]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);

%% 查看物品列表
handle(15010, PlayerStatus, [Pos]) ->
    send_bag_goods_list(PlayerStatus, Pos, client);

%% 查询别人身上装备列表
handle(15011, #player_status{id = RoleId}, [RoleId]) -> ok;
handle(15011, PlayerStatus, [RoleId]) ->
    #player_status{id = SelfRoleId, sid = Sid, figure = Figure} = PlayerStatus,
    #figure{name = Name} = Figure,
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, pp_goods, send_equip_list, [Sid, Name, SelfRoleId]);

%% 查看跨服玩家信息
handle(15012, #player_status{id = RoleId}, [_ServerId, RoleId]) -> ok;
handle(15012, #player_status{id = ToRoleId, figure = #figure{name = ToName}, server_id = ToServerId} = PlayerStatus, [ServerId, RoleId]) ->
    % ?PRINT("send_equip_list ServerId:~p RoleId:~p ~n", [ServerId, RoleId]),
    case lists:member(ServerId, config:get_merge_server_ids()) of
        true -> pp_goods:handle(15011, PlayerStatus, [RoleId]);
        false ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(pp_goods, get_equip_list_from_other_server, [ServerId, RoleId, Node, ToRoleId, ToName, ToServerId])
    end;

%% 查看跨服玩家的物品信息
handle(15013, #player_status{id = RoleId}, [_ServerId, RoleId, _GoodsId]) -> ok;
handle(15013, #player_status{id = ToRoleId} = PlayerStatus, [ServerId, RoleId, GoodsId]) ->
    case lists:member(ServerId, config:get_merge_server_ids()) of
        true -> pp_goods:handle(15001, PlayerStatus, [RoleId, GoodsId]);
        false ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(pp_goods, get_goods_info_from_other_server, [ServerId, RoleId, Node, ToRoleId, GoodsId])
    end;

%% 查询别人身上装备列表
handle(15014, #player_status{id = RoleId}, [RoleId]) -> ok;
handle(15014, PlayerStatus, [RoleId]) ->
    %%    #player_status{id = _SelfRoleId, sid = Sid, figure = Figure} = PlayerStatus,
    %%    #figure{name = _Name} = Figure,
    GoodsStatus = lib_goods_do:get_goods_status(),
    PowerCompareSelf = get_mod_power(PlayerStatus, GoodsStatus),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, pp_goods, send_power_compare_list, [PlayerStatus#player_status.id, PowerCompareSelf]);


%% 查看跨服玩家信息
handle(15015, #player_status{id = RoleId}, [_ServerId, RoleId]) -> ok;
handle(15015, PlayerStatus, [ServerId, RoleId]) ->
    case lists:member(ServerId, config:get_merge_server_ids()) of
        true -> pp_goods:handle(15014, PlayerStatus, [RoleId]);
        false ->
            Node = mod_disperse:get_clusters_node(),
            GoodsStatus = lib_goods_do:get_goods_status(),
            PowerCompareSelf = get_mod_power(PlayerStatus, GoodsStatus),
            mod_clusters_node:apply_cast(pp_goods, get_power_compare_from_other_server, [ServerId, RoleId, Node, PlayerStatus#player_status.id, PowerCompareSelf])
    end;



%% 物品分解
handle(15019, _PlayerStatus, [[]]) -> skip;
handle(15019, PlayerStatus, [GoodsList]) ->
    NewGoodsList = [{Id, Num} || {Id, Num}<-GoodsList, Id>0],
    case lib_goods_do:goods_decompose(PlayerStatus, NewGoodsList) of
        [Res, NewPlayerStatus, RewardList] ->
            {ok, BinData} = pt_150:write(15019, [Res, RewardList]),
            %?PRINT("15019 RewardList ~p~n", [RewardList]),
            lib_server_send:send_to_uid(NewPlayerStatus#player_status.id, BinData),
            {ok, NewPlayerStatus};
        Err ->
            ?ERR("goods_decompose error:~p~n", [Err])
    end;

%% 物品合成
handle(15020, PlayerStatus, [RuleId, RegularGList, SpecifyGList]) ->
    case lib_goods_do:goods_compose(PlayerStatus, RuleId, RegularGList, SpecifyGList) of
        [Res, IsSpecial, NewPlayerStatus, ComposeGoodsId] ->
            {ok, BinData} = pt_150:write(15020, [Res, IsSpecial, RuleId, ComposeGoodsId]),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
            {ok, NewPlayerStatus};
        Err ->
            ?ERR("goods_compose error:~p~n", [Err])
    end;

%% 物品出售
handle(15021, PlayerStatus, [GoodsList]) ->
    %% 出售列表去重，防止玩家发协议重复数据
    NewGoodsList = lists:usort(GoodsList),
    case lib_goods_do:sell_goods(PlayerStatus, 0, NewGoodsList) of
        [Res, NewPlayerStatus, TypeIdList] ->
            {ok, BinData} = pt_150:write(15021, [Res, TypeIdList]),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
            {ok, NewPlayerStatus};
        Err ->
            ?ERR("sell_goods error:~p~n", [Err])
    end;

%% 物品兑换
handle(15022, PlayerStatus, [ExchangeRuleId, ExchangeTimes]) when ExchangeTimes > 0 ->
    RealExchangeTimes = round(ExchangeTimes),
    case lib_goods_check:check_goods_exchange(PlayerStatus, ExchangeRuleId, RealExchangeTimes) of
        {ok, ExchangeRule, RealCostList, RealObtainList} ->
            lib_goods_exchange:exchange(PlayerStatus, ExchangeRule, RealExchangeTimes, RealCostList, RealObtainList);
        {fail, ErrCode} ->
            {ok, BinData} = pt_150:write(15022, [ErrCode, ExchangeRuleId, 0]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData)
    end;

%% 物品子位置更改，如 神装移入保护箱
handle(15023, PlayerStatus, [GoodsId]) ->
    case lib_goods_do:change_goods_sub_location(PlayerStatus, GoodsId) of
        {true, NPS, NewGoodsInfo} ->
            #goods{location = Location, sub_location = SubLocation} = NewGoodsInfo,
            {ok, BinData} = pt_150:write(15023, [1, GoodsId, Location, SubLocation]),
            lib_server_send:send_to_sid(NPS#player_status.sid, BinData),
            {ok, NPS};
        {false, Res} ->
            {ok, BinData} = pt_150:write(15023, [Res, GoodsId, 0, 0]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData)
    end;

%% 查看背包熔炼信息
handle(15024, PlayerStatus, []) ->
    #goods_status{rec_fusion = RecFusion} = lib_goods_do:get_goods_status(),
    case RecFusion of
        #rec_fusion{lv = Lv, exp = Exp} -> ok;
        _ -> Lv = 0, Exp = 0
    end,
    {ok, Bin} = pt_150:write(15024, [Lv, Exp]),
    lib_server_send:send_to_sid(PlayerStatus#player_status.sid, Bin);

%% 背包熔炼
%% 备注 lib_onhook:onhook_auto_devour_equips 函数直接使用本协议
%% 备注 lib_goods_do:goods_fusion_slient 修改注意要改到这里,静默熔炼
handle(15025, PlayerStatus, [GoodsList]) ->
    case lib_goods_do:goods_fusion(PlayerStatus, GoodsList) of
        {true, NewPlayerStatus, ExpList, NewRecFusion} ->
            #rec_fusion{lv = Lv, exp = Exp} = NewRecFusion,
            {ok, BinData} = pt_150:write(15025, [1, ExpList]),
            {ok, Bin} = pt_150:write(15024, [Lv, Exp]),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, Bin),
            lib_task_api:fusion_equip(NewPlayerStatus, Lv),
            lib_activitycalen_api:role_success_end_activity(PlayerStatus#player_status.id, ?MOD_GOODS, 0),
            {ok, NewPlayerStatus};
        {fail, Res} ->
            {ok, BinData} = pt_150:write(15025, [Res, []]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData),
            ok
    end;

%% 物品兑换列表
handle(15026, PlayerStatus, [Type]) ->
    lib_goods_exchange:send_info(PlayerStatus, Type);

%% 过期物品列表
handle(15027, #player_status{sid = Sid}=PS, [Opr]) ->
    case Opr of
        1 -> %% 查看
            GoodsStatus = lib_goods_do:get_goods_status(),
            TimeoutGoods = GoodsStatus#goods_status.timeout_goods,
            TimeoutGoods =/= [] andalso lib_server_send:send_to_sid(Sid, pt_150, 15027, [Opr, TimeoutGoods]),
            ok;
        2 ->
            lib_goods_do:reclaim_timeout_goods(PS);
        _ ->
            ok
    end;

%% 物品合成(非指定)
handle(15028, PlayerStatus, [RuleId, CombineNum, RegularList, IrRegularList]) ->
    case lib_goods_do:goods_compose_simple(PlayerStatus, RuleId, CombineNum, RegularList, IrRegularList) of
        [Res, NewPlayerStatus, Rewards] ->
            {ok, BinData} = pt_150:write(15028, [Res, RuleId, Rewards]),
            lib_server_send:send_to_sid(NewPlayerStatus#player_status.sid, BinData),
            {ok, NewPlayerStatus};
        Err ->
            ?ERR("goods_compose error:~p~n", [Err])
    end;

%% 使用物品
handle(15050, PlayerStatus, [GoodsId, Num]) ->
    case lib_goods_do:use_goods(PlayerStatus, GoodsId, Num) of
        [NewPlayerStatus, Res, GoodsInfo, NewNum, GoodsList] ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Res),
            {ok, BinData} = pt_150:write(15050, [ErrorCodeInt, ErrorCodeArgs, GoodsId, GoodsInfo#goods.goods_id, NewNum, 0, Num, GoodsList]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData),
            {ok, NewPlayerStatus};
        [use_designtion_goods, NewPlayerStatus, _Coin, _GoodsInfo, _NewNum, _GoodsList] ->
            {ok, NewPlayerStatus};
        _Reason ->
            ?ERR("handle 15050 error:~p", [_Reason])
    end;

%% 拾取掉落
handle(15053, Ps, [DropId]) ->
    IsCluster = lib_scene:is_clusters_scene(Ps#player_status.scene),
    case DropId rem 2 of %% 偶数为跨服掉落
        0 when IsCluster ->
            PsArgs = lib_drop:trans_to_ps_args(Ps, ?NODE_CENTER),
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_drop, manual_drop_pickup, [Node, DropId, PsArgs]);
        _ ->
            PsArgs = lib_drop:trans_to_ps_args(Ps, ?NODE_GAME),
            mod_drop:manual_drop_pickup(none, DropId, PsArgs)
    end;

%% 获取物品buff列表
handle(15055, PlayerStatus, []) ->
    lib_goods_buff:send_buff_notice(PlayerStatus);

%% 等级礼包的等级信息
handle(15083, Ps, [GoodsId, GoodsTypeId]) ->
    GiftLevel = lib_gift_new:get_gift_level(Ps, GoodsId, GoodsTypeId),
    {ok, Bin} = pt_150:write(15083, [GoodsId, GoodsTypeId, GiftLevel]),
    lib_server_send:send_to_sid(Ps#player_status.sid, Bin);

%% 礼包每日使用次数
handle(15084, Ps, [GoodsId]) ->
    {UseCount, TotalCount, FreezeEndtime} = lib_gift_new:get_count_gift_info(Ps, GoodsId),
    %?PRINT("15084 ~p~n", [{UseCount, TotalCount, FreezeEndtime}]),
    {ok, Bin} = pt_150:write(15084, [GoodsId, UseCount, TotalCount, FreezeEndtime]),
    lib_server_send:send_to_sid(Ps#player_status.sid, Bin);

%% 礼包每日使用次数
handle(15085, Ps, [GoodsTypeId]) ->
    case data_gift:get(GoodsTypeId) of
        #ets_gift{condition = Condition} ->
            case lists:keyfind(count, 1, Condition) of
                false -> skip;
                {count, _Count} ->
                    UseCount = mod_daily:get_count(Ps#player_status.id, ?MOD_GOODS, ?MOD_GOODS_GIFT, GoodsTypeId),
                    lib_server_send:send_to_sid(Ps#player_status.sid, pt_150, 15085, [GoodsTypeId, UseCount])
            end;
        _ ->
            skip
    end;

%% 领取自选宝箱的物品内容
%% GoodsId:物品唯一id; Num:使用的数量
handle(15086, PlayerStatus, [GoodsId, SeqList]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_gift_check:check_use_optional_gift(PlayerStatus, GoodsStatus, GoodsId, SeqList) of
        {fail, ErrCode} ->
            {ok, BinData} = pt_150:write(15086, [ErrCode]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData);
        {ok, GoodsInfo, OptionalGift, GoodsList, Num} ->
            case lib_gift_new:use_optional_gift(PlayerStatus, GoodsStatus, GoodsInfo, OptionalGift, GoodsList, Num) of
                {ok, Code, NewPs} ->
                    {ok, BinData} = pt_150:write(15086, [Code]),
                    lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData),
                    {ok, NewPs};
                {fail, Code, _Reason} ->
                    ?ERR("handle 15086 error:~p", [_Reason]),
                    {ok, BinData} = pt_150:write(15086, [Code]),
                    lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData),
                    {ok, PlayerStatus}
            end
    end;

%% 领取礼包卡奖励
handle(15087, PlayerStatus, [CardNo]) ->
    CardNo1 = re:replace(CardNo, "\"", "", [{return, list}, global]),
    CardNo2 = re:replace(CardNo1, "\'", "", [{return, list}, global]),
    case lib_gift_card:trigger_card(PlayerStatus, CardNo2) of
        %% {ok, NewPs} -> {ok, NewPs};
        {false, Code} ->
            ta_agent_fire:gift_card(PlayerStatus, [CardNo, "", 0, false, Code]),
            {ok, BinData} = pt_150:write(15087, [Code, []]),
            lib_server_send:send_to_sid(PlayerStatus#player_status.sid, BinData);
        _ ->
            ok
    end;

%% 物品预览战力
handle(15089, PlayerStatus, [GoodsTypeId]) ->
    lib_goods_do:send_goods_expect_power(PlayerStatus, GoodsTypeId);

%% 物品测试协议
% handle(15099, PlayerStatus, [RewardList]) ->
%     lib_goods_api:send_reward_with_mail(PlayerStatus, #produce{reward = RewardList});

handle(_Cmd, _Status, _Data) ->
    ?PRINT("pp_goods no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_goods no match"}.

%%% ----------------------------- export function -----------------------------

% %% 查看装备列表和一生一世信息(玩家进程)
% send_equip_list(Ps, Sid) ->
%     #player_status{
%         id = RoleId,
%         marriage = MarriageStatus,
%         off = Off
%     } = Ps,
%     #marriage_status{
%         marriage_life = MarriageLife
%     } = MarriageStatus,
%     #marriage_life{
%         stage = Stage,
%         heart = Heart
%     } = MarriageLife,
%     AttrList = lib_marriage:get_marriage_life_attr(Ps),
%     Attr = lib_player_attr:add_attr(record, [AttrList]),
%     CombatPower = lib_player:calc_all_power(Attr),
%     MarriageLifeList = [{Stage, Heart, CombatPower}],
%     case Off#status_off.goods_status of
%         undefined -> %% 在线
%             GoodsStatus = lib_goods_do:get_goods_status();
%         GoodsStatus -> %% 离线
%             skip
%     end,
%     EquipListPack = make_equip_list_pack(RoleId, GoodsStatus),
%     {ok, BinData} = pt_150:write(15011, [?SUCCESS, RoleId, EquipListPack, MarriageLifeList]),
%     lib_server_send:send_to_sid(Sid, BinData),
%     ok.

% make_equip_list_pack(RoleId, GoodsStatus) ->
%     Dict = GoodsStatus#goods_status.dict,
%     EquipList = lib_goods_util:get_equip_list(RoleId, Dict),
%     F = fun(GoodsInfo) ->
%         #goods{id = GoodsId, goods_id = TypeId, cell = Cell, color = Color} = GoodsInfo,
%         Stren = lib_goods_do:get_info_stren(GoodsStatus, GoodsInfo),
%         {GoodsId, TypeId, Cell, Color, Stren}
%     end,
%     lists:map(F, EquipList).


%% 本服战力对比
send_power_compare_list(#player_status{server_id = ServerId} = Ps, SelfRoleId, SelfPowerList) ->
    BinData = make_power_compare_bindata(Ps, ServerId, SelfPowerList),
    lib_server_send:send_to_uid(SelfRoleId, BinData),
    ok.


get_power_compare_from_other_server(ServerId, RoleId, Node, SelfRoleId, SelfPowerList) ->
    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, send_power_compare_list, [ServerId, Node, SelfRoleId, SelfPowerList]]).

%% 跨服查看
send_power_compare_list(Ps, ServerId, Node, SelfRoleId, SelfPowerList) ->
    BinData = make_power_compare_bindata(Ps, ServerId, SelfPowerList),
    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, SelfRoleId, BinData]).


make_power_compare_bindata(Ps, ServerId, SelfPowerList) ->
    #player_status{id = RoleId, off = Off} = Ps,
    GoodsStatus =
        case Off#status_off.goods_status of
            undefined -> %% 在线
                lib_goods_do:get_goods_status();
            GdStatus -> %% 离线
                GdStatus
        end,
    OtherPowerList = get_mod_power(Ps, GoodsStatus),
    %% ?MYLOG("lwcpower","{ServerId, RoleId, OtherPowerList, SelfPowerList}:~p~n",[{ServerId, RoleId, OtherPowerList, SelfPowerList}]),
    {ok, BinData} = pt_150:write(15014, [ServerId, RoleId, OtherPowerList, SelfPowerList]),
    BinData.


%% 查看各个模块的战力
get_mod_power(Ps, GoodsStatus) ->
    #player_status{
        id = RoleId,
        mon_pic = MonPic,
        arbitrament_status = ArbitramentStatus,
        eudemons = EudemonsStatu,
        goods = Goods,
        medal = Medal,
        star_map_status = StarStatus,
        status_achievement = AchieveStatus,
        skill = Skill,
        figure = #figure{lv = RoleLv},
        guild_skill = GuidSkill,
        dress_up = DressUp,
        status_baby = StatuBaby,
        original_attr = OriginalAttr,
        god = StatusGod
    } = Ps,
    #goods_status{
        %%        soul = Soul,
        dict = GoodsDict,
        fashion = Fashion,
        mount_equip_pos_list = MountEquipPos,
        mate_equip_pos_list = MateEquipPos,
        ring = Ring} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL, ?EQUIP_TYPE_SPECIAL := _SpecialL} = data_goods:classify_euqip(EquipList),
    WeaponAttr = data_goods:count_goods_attribute(WeaponL),
    ArmorAttr = data_goods:count_goods_attribute(ArmorL),
    OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),




    %%    %% 聚魂装备百分比加成  pt_15014_[4294967439]
    %%    SoulAddAttr = Soul#soul.equip_add_ratio_attr,
    %%    %% 已穿戴装备强化属性
    %%    StrenAttribute = data_goods:count_stren_attribute(SoulAddAttr, GoodsStatus),
    %%    %% 已穿戴装备精炼属性
    %%    RefineAttribute = data_goods:count_refine_attribute(SoulAddAttr, GoodsStatus),
    %%    %% 装备的洗炼属性
    %%    EquipWashAttr = data_goods:count_wash_attribute(GoodsStatus),
    %%-----------------------------------------------------------------
    %% 装备属性
    EquipAttr =
        case is_map(Goods#status_goods.equip_attribute) orelse is_record(Goods#status_goods.equip_attribute, attr) of
            true ->
                lib_player_attr:to_kv_list(Goods#status_goods.equip_attribute);
            false ->
                Goods#status_goods.equip_attribute
        end,
    FigureEquipAttr = lib_mount_equip:get_figure_equip_attr(RoleId, MountEquipPos, MateEquipPos, GoodsDict),
    StoneAttribute = data_goods:count_stone_attribute(GoodsStatus),
    LastEquipAttr = ulists:kv_list_minus_extra([EquipAttr, FigureEquipAttr, StoneAttribute]), % 去掉不计算在装备评分里属性
    EquipPower = get_count_attrlist_power([LastEquipAttr], RoleLv),
    %%-----------------------------------------------------------------
    %%  套装属性
    EquipSuitAttr = Goods#status_goods.equip_suit_attr,
    EquipSuitPower = get_count_attrlist_power([EquipSuitAttr], RoleLv),
    %%-----------------------------------------------------------------
    %% 宝石属性[所有已穿戴装备镶嵌的宝石属性]
    StonPower = lib_player:calc_partial_power(OriginalAttr, 0, StoneAttribute),
    % StonPower = get_count_attrlist_power([StoneAttribute], RoleLv),
    %%-----------------------------------------------------------------
    %% 符文属性
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),
    %% 图鉴属性
    MonPicAttr = MonPic#status_mon_pic.attr,
%%    %%  穿戴的聚魂（源力）属性
%%    SoulWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, GoodsDict),
    %% 幻灵属性
    EudemonsAttr = EudemonsStatu#eudemons_status.total_attr,
    RunePower = get_count_attrlist_power_sp([RuneAttr, MonPicAttr, EudemonsAttr], RoleLv,[WeaponAttr, ArmorAttr, OrnamentAttr]),
    %%-----------------------------------------------------------------
    %% 技能战力
    SkillPower = Skill#status_skill.skill_power,
    % 成就属性
    AchievmentAttr = lib_achievement_api:get_all_attr(AchieveStatus),
    % 勋章属性
    MedalAttr = Medal#medal.add_attr,
    % 星座属性
    StarMapAttr = StarStatus#star_map_status.attr,
    % 属性药水
    AttrMedicamentAttr = lib_attr_medicament:get_attr(Ps),
    % 人物基础属性
    LvAttr = lib_player:base_lv_attr(RoleLv),
    %% 帮派技能属性
    #status_guild_skill{attr = GuildSkillAttr} = GuidSkill,
    %% 等级基础属性
    LvAddAttr = lib_player_attr:count_lv_attr(LvAttr, [RuneAttr, GuildSkillAttr, Skill#status_skill.skill_attr]),
    %% 人物属性
    PlayerPower = SkillPower + get_count_attr_power(AchievmentAttr ++ MedalAttr ++ StarMapAttr ++ AttrMedicamentAttr ++ LvAddAttr, RoleLv),
    %%-----------------------------------------------------------------
    %%  初始化时装属性
    FashionAttr = lib_fashion:count_fashion_attr(Fashion),
    %% 装扮
    DressUpAttr = DressUp#status_dress_up.attr,
    FashionPower = get_count_attr_power(FashionAttr ++ DressUpAttr, RoleLv),
    %% 外形战力
    #player_status{status_mount = StatuMount} = Ps,
    FigurePow = get_mount_power(RoleId, StatuMount, GoodsStatus, RoleLv),
    %% 圣裁属性
    ArbitramentAttr =
        case is_map(ArbitramentStatus#arbitrament_status.attr_list) orelse is_record(ArbitramentStatus#arbitrament_status.attr_list, attr) of
            true ->
                lib_player_attr:to_kv_list(ArbitramentStatus#arbitrament_status.attr_list);
            false ->
                ArbitramentStatus#arbitrament_status.attr_list
        end,
    ArbitramentPower = get_count_attrlist_power([ArbitramentAttr], RoleLv),
    %%-----------------------------------------------------------------
    %% 契灵
    CompanionPower = lib_companion_util:get_all_companion_real_power(Ps),
    %% 圣印
    SealAttr = lib_seal:get_total_attr(Ps),
    SealPower = get_count_attrlist_power([SealAttr], RoleLv),
    %%-----------------------------------------------------------------
    %%-----------------------------------------------------------------
    % %% 龙语 %%需要打开屏蔽
    % DraconicAttr = lib_draconic:get_total_attr(Ps),
    % DraconicPower = get_count_attrlist_power([DraconicAttr], RoleLv),
    %%-----------------------------------------------------------------
    %% 戒指
    RingAttr = lib_marriage:count_ring_attribute(Ring),
    RingAttr1 = lib_marriage:get_marriage_life_attr(Ps),
    RingPower = get_count_attrlist_power([RingAttr ++ RingAttr1], RoleLv),
    %% 宝宝
    #status_baby{total_power = BabyPower} = StatuBaby,
    %% 降神
    GodPower = lib_god:get_all_god_power(StatusGod, OriginalAttr),
    %% 使魔
    DemonsPower = lib_demons_util:count_all_demons_power(Ps),

    %% =================================================
    %% 客户端是按照服务端发过去的列表来顺序读取的
    %% 但是！！界面的展示可以不是按照发过去的顺序展示
    %% 建议每次在末尾加

    % 三个一行，注释好，方便查看代码
    % EquipPower(装备)、EquipSuitPower(套装)、StonPower(宝石)
    % RunePower(符文、图鉴、幻灵)、PlayerPower(人物)、FashionPower(时装)
    % ArbitramentPower(圣裁)、FigurePow(坐骑、精灵、翅膀、圣器、神兵)、CompanionPower(契灵)
    % SealPower(圣印)、RingPower(戒指)、BabyPower(宝宝)
    % GodPower(降神)、DemonsPower(使魔)
    %% =================================================
    EquipPower ++ EquipSuitPower ++ [StonPower]
    ++ RunePower ++ [PlayerPower] ++ [FashionPower]
    ++ ArbitramentPower ++ FigurePow ++ [CompanionPower]
    ++ SealPower ++ RingPower ++ [BabyPower]
    ++ [GodPower] ++ [DemonsPower].

%% 计算属性总战力( 评分 )
get_count_attr_power(TotalList, RoleLv) ->
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                case lists:member(OneAttrId, ?LV_ADD_RATIO_TYPE) of
                    true ->
                        OneAttrRating = data_attr:get_attr_base_rating_help(OneAttrId, RoleLv, OneAttrVal),
                        RatingTmp + OneAttrRating;
                    false ->
                        OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                        RatingTmp + OneAttrRating * OneAttrVal
                end;

            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力 改为 阶数 * 200
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                RatingTmp + OneAttrRating;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, TotalList),
    round(Rating).

%% 计算属性总战力( 评分 )
get_count_attrlist_power(TotalList, RoleLv) ->
    F = fun(Attr, PowerTmp) ->
        NewCombat = get_count_attr_power(Attr, RoleLv),
        [NewCombat | PowerTmp]
        end,
    PowerList = lists:foldl(F, [], TotalList),
    lists:reverse(PowerList).

% 计算坐骑的评分 ( 不含坐骑装备 )
get_mount_power(_RoleId, StatuMount, _GoodsStatus, _RoleLv) ->
    Fun =
        fun(TypeId, PowList) ->
            StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatuMount),
            Power =
                case StatusType =/= false of
                    true ->
                        #status_mount{combat = Combat} = StatusType,
                        Combat;
                    false -> 0
                end,
            [Power | PowList]
        end,
    PowerList = lists:foldl(Fun, [], ?APPERENCE),
    lists:reverse(PowerList).

%% 计算属性总战力( 评分 )
get_count_attrlist_power_sp(TotalList, RoleLv, [WeaponAttr, ArmorAttr, OrnamentAttr]) ->
    F = fun(Attr, PowerTmp) ->
        NewCombat = get_count_attr_power_sp(Attr, RoleLv, [WeaponAttr, ArmorAttr, OrnamentAttr]),
        [NewCombat | PowerTmp]
        end,
    PowerList = lists:foldl(F, [], TotalList),
    lists:reverse(PowerList).




%% 计算属性总战力( 评分 )
get_count_attr_power_sp(TotalList, RoleLv, [WeaponAttr, ArmorAttr, OrnamentAttr]) ->
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                case lists:member(OneAttrId, ?EQUIP_ADD_RATIO_TYPE) of
                    true ->
                        OneAttrRating = data_attr:get_attr_base_rating_equip(OneAttrId, OneAttrVal, [WeaponAttr, ArmorAttr, OrnamentAttr]),
                        RatingTmp + OneAttrRating;
                    false ->
                        case lists:member(OneAttrId, ?LV_ADD_RATIO_TYPE) of
                            true ->
                                OneAttrRating = data_attr:get_attr_base_rating_help(OneAttrId, RoleLv, OneAttrVal),
                                RatingTmp + OneAttrRating;
                            false ->
                                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                                RatingTmp + OneAttrRating * OneAttrVal
                        end
                end;

            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力 改为 阶数 * 200
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1),
                RatingTmp + OneAttrRating;
            _ ->
                RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, TotalList),
    round(Rating).



















%% 本服
send_equip_list(#player_status{server_id = ServerId} = Ps, Sid, ToName, ToId) ->
    BinData = make_equip_list_bindata(Ps, ServerId, ToName, ToId, ServerId),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 跨服查看
send_equip_list(Ps, ServerId, Node, ToId, ToName, ToServerId) ->
    BinData = make_equip_list_bindata(Ps, ServerId, ToName, ToId, ToServerId),
    % ?PRINT("send_equip_list ToId:~p ~n", [ToId]),
    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, ToId, BinData]).

get_equip_list_from_other_server(ServerId, RoleId, Node, ToId, ToName, ToServerId) ->
    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, send_equip_list, [ServerId, Node, ToId, ToName, ToServerId]]).

make_equip_list_bindata(Ps, ServerId, ToName, ToId, ToServerId) ->
    #player_status{
        id = RoleId,
        server_num = ServerNum,
        combat_power = Combat,
        figure = Figure,
        status_achievement = NewStarRewardL,
        off = Off
    } = Ps,
    NowTime = utime:unixtime(),
    AchvStage = lib_achievement_api:get_cur_stage_offline(NewStarRewardL),
    case Off#status_off.goods_status of
        undefined -> %% 在线
            PreTime = case erlang:get(get_player_info) of
                          Val when is_integer(Val) -> Val;
                          _ -> 0
                      end,
            if
                is_integer(PreTime) andalso (NowTime - PreTime >= 30) ->
                    erlang:put(get_player_info, NowTime),
                    LanguageId = urand:list_rand([9, 10, 11, 12, 13]), %% 语言配置额外中的消息id
                    lib_chat:send_TV({player, RoleId}, ?MOD_GOODS, LanguageId, [ToName, ToId, ToServerId]);
                true ->
                    skip
            end,
            GoodsStatus = lib_goods_do:get_goods_status();
        GoodsStatus -> %% 离线
            skip
    end,
    EquipListPack = make_equip_list_pack(RoleId, GoodsStatus),
    {ok, BinData} = pt_150:write(15011, [ServerId, ServerNum, RoleId, Combat, AchvStage, Figure, EquipListPack]),
    BinData.

make_equip_list_pack(RoleId, GoodsStatus) -> %% 打包被查看玩家装备信息
    Dict = GoodsStatus#goods_status.dict,
    GodEquipLevelList = GoodsStatus#goods_status.god_equip_list,
    EquipList = lib_goods_util:get_equip_list(RoleId, Dict),
    F = fun(GoodsInfo) ->
        #goods{id = GoodsId, equip_type = Pos, goods_id = TypeId, cell = Cell, color = Color, level = Level} = GoodsInfo,
        case lists:keyfind(Pos, 1, GodEquipLevelList) of
            {_, GodEquipLevel} -> skip;
            _ -> GodEquipLevel = 0
        end,
        Stren = lib_goods_do:get_info_stren(GoodsStatus, GoodsInfo),
        Stage = lib_equip:get_equip_stage(TypeId),
        Star = lib_equip:get_equip_star(TypeId),
        {GoodsId, TypeId, Cell, Color, Stren, Star, Stage, Level, GodEquipLevel}
        end,
    lists:map(F, EquipList).





%% 查看物品详细数据(玩家进程)
send_goods_info(Ps, Sid, GoodsId) ->
    BinData = make_goods_info_bindata(Ps, GoodsId),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 查看物品详细数据
send_goods_info(Ps, Node, ToId, GoodsId) ->
    BinData = make_goods_info_bindata(Ps, GoodsId),
    % ?PRINT("send_goods_info GoodsId:~p ~n", [GoodsId]),
    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, ToId, BinData]),
    ok.

get_goods_info_from_other_server(ServerId, RoleId, Node, ToId, GoodsId) ->
    mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ?MODULE, send_goods_info, [Node, ToId, GoodsId]]).

make_goods_info_bindata(Ps, GoodsId) ->
    #player_status{
        id = RoleId,
        off = Off
    } = Ps,
    case Off#status_off.goods_status of
        undefined -> %% 在线
            GoodsStatus = lib_goods_do:get_goods_status();
        GoodsStatus -> %% 离线
            skip
    end,
    InfoPack = make_goods_info_pack(RoleId, GoodsStatus, GoodsId),
    {ok, BinData} = pt_150:write(15001, InfoPack),
    BinData.

%% 15001 打包
make_goods_info_pack(RoleId, GoodsStatus, GoodsId) ->
    [
        _GoodsStatus, GoodsInfo, Stren, Rating, OverallRating,
        Division, _WashRating, Addition, StoneList,
        MagicList, ExtraAttr, WashAttr, SuitList,
        CSpiritStage, CSpiritLv, AwakeningLv, EquipSkillId, EquipSkillLv, MountEquipSkill, MountEquipSkillLv,
        PetEquipStage, PetEquipStar, AwakeLvList, RefinementLv
    ] = lib_goods_do:info(GoodsStatus, GoodsId),
    #goods{
        goods_id = TypeId, equip_type = EquipType, sub_location = SubLocation, cell = Cell, num = Num, bind = Bind,
        trade = Trade, sell = Sell, expire_time = ExpireTime, color = Color, level = Level
    } = GoodsInfo,
    {SellType, SellPrice} = data_goods:get_goods_sell_price(TypeId),
    CombatPower = 0,
    [RoleId, GoodsId, TypeId, SubLocation, Cell, Num, Bind,
        Trade, Sell, Color, ExpireTime, CombatPower,
        EquipType, SellType, SellPrice, Stren, Rating,
        OverallRating, Division, Addition, StoneList,
        MagicList, ExtraAttr, WashAttr, SuitList,
        CSpiritStage, CSpiritLv, AwakeningLv, EquipSkillId, EquipSkillLv, MountEquipSkill, MountEquipSkillLv,
        PetEquipStage, PetEquipStar, Level, AwakeLvList, RefinementLv
    ].

%%--------------------------------------------------
%% 打包玩家自己的物品信息 15000协议用
%% @param  GoodsArgs GoodsId|#goods{}
%% @return           description
%%--------------------------------------------------
make_self_goods_info_pack(GoodsArgs) when is_integer(GoodsArgs) orelse is_record(GoodsArgs, goods) ->
    [
        _GoodsStatus, GoodsInfo, Stren, Rating, OverallRating,
        Division, WashRating, Addition, StoneList,
        MagicList, ExtraAttr, WashAttr, SuitList,
        CSpiritStage, CSpiritLv, AwakeningLv, EquipSkillId, EquipSkillLv, MountEquipSkill, MountEquipSkillLv,
        PetEquipStage, PetEquipStar, AwakeLvList, RefinementLv
    ] = lib_goods_do:info(GoodsArgs),
    GoodsId = ?IF(is_record(GoodsArgs, goods), GoodsArgs#goods.id, GoodsArgs),
    #goods{
        goods_id = TypeId, equip_type = EquipType, sub_location = SubLocation, cell = Cell, num = Num, bind = Bind,
        trade = Trade, sell = Sell, expire_time = ExpireTime, color = Color, level = Level,
        other = #goods_other{overflow_exp = OExp}
    } = GoodsInfo,
    {SellPriceType, SellPrice} = data_goods:get_goods_sell_price(TypeId),
    CombatPower = 0,
    [GoodsId, TypeId, SubLocation, Cell, Num, Bind, Trade, Sell, Color,
        ExpireTime, CombatPower, EquipType, SellPriceType, SellPrice,
        Stren, OExp, Rating, OverallRating,
        Division, WashRating, Addition, StoneList, MagicList,
        ExtraAttr, WashAttr, SuitList,
        CSpiritStage, CSpiritLv, AwakeningLv, EquipSkillId, EquipSkillLv, MountEquipSkill, MountEquipSkillLv,
        PetEquipStage, PetEquipStar, Level, AwakeLvList, RefinementLv].

%% 15010、15017 协议打包
pack_goods_list(GoodsList) ->
    F = fun(GoodsInfo, AccList) when is_record(GoodsInfo, goods) =:= true
        andalso is_integer(GoodsInfo#goods.id) =:= true ->
        #goods{
            id = GoodsId, goods_id = TypeId, sub_location = SubLocation, cell = Cell, num = Num, bind = Bind, level = Level,
            trade = Trade, sell = Sell, isdrop = IsDrop, expire_time = ExpireTime, color = Color, location = Location, type = Type
        } = GoodsInfo,
        Power = 0,
        case lib_goods_util:load_goods_other(GoodsInfo) of
            true ->
                Stren = GoodsInfo#goods.other#goods_other.stren,
                Addition = data_attr:unified_format_addition_attr(GoodsInfo#goods.other#goods_other.addition, Type),
                Rating = GoodsInfo#goods.other#goods_other.rating,
                OverallRating = lib_equip:cal_equip_overall_rating(Location, GoodsInfo),
                ExtraAttr = data_attr:unified_format_extra_attr(GoodsInfo#goods.other#goods_other.extra_attr, []),
                {EquipStage, EquipStar} = calc_equip_stage_star(GoodsInfo#goods.other#goods_other.optional_data),
                {SkillId, SkillLv} = get_goods_skill(GoodsInfo),
                AwakeLvList = lib_goods_do:get_info_awake_lv_list(GoodsInfo);
            false ->
                Stren = 0, Addition = [], Rating = 0, OverallRating = 0, ExtraAttr = [], EquipStage = 0, EquipStar = 0,
                SkillId = 0, SkillLv = 0, AwakeLvList = []
        end,
        Elem = {
            GoodsId, TypeId, SubLocation, Cell, Num, Bind, Trade, Sell, IsDrop, Color, ExpireTime,
            Power, Stren, Level, Rating, OverallRating, Addition, ExtraAttr, EquipStage, EquipStar,
            SkillId, SkillLv, AwakeLvList},
        [Elem | AccList];
        (_GoodsInfo, AccList) -> AccList
        end,
    lists:foldl(F, [], GoodsList).

pack_goods_list(Player, GoodsStatus, GoodsList, ResType) ->
    F = fun(GoodsInfo, AccList) when is_record(GoodsInfo, goods) =:= true
        andalso is_integer(GoodsInfo#goods.id) =:= true ->
        #goods{
            id = GoodsId, goods_id = TypeId, sub_location = SubLocation, cell = Cell, num = Num, bind = Bind, level = Level,
            trade = Trade, sell = Sell, isdrop = IsDrop, expire_time = ExpireTime, color = Color, location = Location, type = Type
        } = GoodsInfo,
        if
            Type == ?GOODS_TYPE_DRAGON_EQUIP ->
                Power= lib_dragon:calc_one_equip_add_power(TypeId, Level, Player, GoodsStatus),
                NextLevel = Level + 1,
                case data_dragon:get_star_and_lv(NextLevel) of
                    {_, _Star} ->
                        NextPower = lib_dragon:calc_one_equip_add_power(TypeId, NextLevel, Player, GoodsStatus);
                    _ ->
                        NextPower = 0
                end;
            true ->
                Power = 0, NextPower = 0
        end,
        case lib_goods_util:load_goods_other(GoodsInfo) of
            true ->
                Stren = GoodsInfo#goods.other#goods_other.stren,
                Addition = data_attr:unified_format_addition_attr(GoodsInfo#goods.other#goods_other.addition, Type),
                Rating = GoodsInfo#goods.other#goods_other.rating,
                OverallRating = lib_equip:cal_equip_overall_rating(Location, GoodsInfo),
                ExtraAttr = data_attr:unified_format_extra_attr(GoodsInfo#goods.other#goods_other.extra_attr, []),
                {EquipStage, EquipStar} = calc_equip_stage_star(GoodsInfo#goods.other#goods_other.optional_data),
                {SkillId, SkillLv} = get_goods_skill(GoodsInfo),
                AwakeLvList = lib_goods_do:get_info_awake_lv_list(GoodsInfo);
            false ->
                Stren = 0, Addition = [], Rating = 0, OverallRating = 0, ExtraAttr = [], EquipStage = 0, EquipStar = 0,
                SkillId = 0, SkillLv = 0, AwakeLvList = []
        end,
        case ResType of
            dragon ->
                Elem = {
                    GoodsId, TypeId, SubLocation, Cell, Num, Bind, Trade, Sell, IsDrop, Color, ExpireTime,
                    Power, Stren, Level, Rating, OverallRating, Addition, ExtraAttr, EquipStage, EquipStar,
                    SkillId, SkillLv, AwakeLvList, NextPower};
            _ ->
                Elem = {
                    GoodsId, TypeId, SubLocation, Cell, Num, Bind, Trade, Sell, IsDrop, Color, ExpireTime,
                    Power, Stren, Level, Rating, OverallRating, Addition, ExtraAttr, EquipStage, EquipStar,
                    SkillId, SkillLv, AwakeLvList}
        end,
        %%        ?PRINT(" ------- -- - - - -ExtraAttr:~p~n",[ExtraAttr]),
        [Elem | AccList];
        (_GoodsInfo, AccList) -> AccList
    end,
    lists:foldl(F, [], GoodsList).

send_bag_goods_list(PlayerStatus, Pos, From) ->
    #player_status{
        id = RoleId, sid = Sid
    } = PlayerStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    {NewPos, ExtendCellGold} = if
                                   Pos =< 0 ->
                                       {?GOODS_LOC_EQUIP, 0};
                                   Pos =:= ?GOODS_LOC_BAG ->
                                       {Pos, 0};
    % Pos =:= ?GOODS_LOC_EQUIP_BAG ->
    %     {Pos, 0};
    % Pos =:= ?GOODS_LOC_GOD_EQUIP_BAG ->
    %     {Pos, 40};
                                   true ->
                                       {Pos, 0}
                               end,
    {UseNum, MaxCellNum} = lib_goods_util:get_bag_cell_num(GoodsStatus, NewPos),
    Dict = GoodsStatus#goods_status.dict,
    GoodsList1 = lib_goods_util:get_goods_list(RoleId, NewPos, Dict),
    case NewPos of
        ?GOODS_LOC_RUNE_BAG ->
            GoodsLen = length(GoodsList1),
            case GoodsLen > 4000 andalso From == client of
                true -> %% 先截取4000个，登陆后会触发服务端自动分解，分解完会再调用这个函数刷新符文背包
                    GoodsListSort = lists:reverse(lists:keysort(#goods.color, GoodsList1)),  %% 符文排序
                    GoodsList = lists:sublist(GoodsListSort, 4000);
                _ -> GoodsList = GoodsList1
            end;
        ?GOODS_LOC_SOUL_BAG ->
            GoodsLen = length(GoodsList1),
            case GoodsLen > 4000 andalso From == client of
                true ->
                    GoodsListSort = lists:reverse(lists:keysort(#goods.color, GoodsList1)),  %% 源力排序
                    GoodsList = lists:sublist(GoodsListSort, 4000);
                _ -> GoodsList = GoodsList1
            end;
        _ -> GoodsList = GoodsList1
    end,
    GoodsListPack = pack_goods_list(PlayerStatus, GoodsStatus, GoodsList, normal),
    {ok, BinData} = pt_150:write(15010, [NewPos, UseNum, MaxCellNum, ExtendCellGold, GoodsListPack]),
    lib_server_send:send_to_sid(Sid, BinData).


%%% ----------------------------- local function -----------------------------
calc_equip_stage_star(OptionData) ->
    case OptionData of
        [?GOODS_OTHER_KEY_MOUNT_EQUIP, PEStage, PEStar] ->
            {PEStage, PEStar};
        [?GOODS_OTHER_KEY_MATE_EQUIP, PEStage, PEStar] ->
            {PEStage, PEStar};
        _ ->
            {0, 0}
    end.

get_goods_skill(GoodsInfo) ->
    #goods{type = Type, other = GoodsOther} = GoodsInfo,
    case Type of
        ?GOODS_TYPE_BABY_EQUIP ->
            {GoodsOther#goods_other.skill_id, 1};
        ?GOODS_TYPE_GOD_COURT ->
            {GoodsOther#goods_other.skill_id, 1};
        _ ->
            {0, 0}
    end.