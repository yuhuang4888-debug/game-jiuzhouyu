%%-----------------------------------------------------------------------------
%% @Module  :       lib_eudemons.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-24
%% @Description:    幻兽
%%-----------------------------------------------------------------------------

-module (lib_eudemons).
-include ("eudemons.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("def_module.hrl").
-include ("predefine.hrl").
-include ("errcode.hrl").
-include ("common.hrl").
-include ("server.hrl").
-include ("def_event.hrl").
-include ("rec_event.hrl").
-include ("figure.hrl").
-include ("attr.hrl").

-export ([
    calc_equip_dynamic_attr/2
    ,make_goods_other/2
    % ,update_strength/1
    ,init_data/1
    ,init_data/2
    ,item_data_for_send/1
    ,check_equip/2
    % ,save_eudemons_equips/4
    ,update_status/4
    ,calc_eudemons_status_attr/1
    ,save_eudemons_state/3
    ,check_strength/1
    ,check_strength/6
    ,calc_strength/2
    ,calc_strength/3
    ,calc_strength_new/4
    ,refresh_with_strength/4
    ,update_skill_change/2
    ,cal_equip_rating/2
    ,dress_on_equips/2
    ,takeoff_equips/1
    ,takeoff_equips/2
    ,change_goods_other/1
    ,calc_material_exp/1
    ,format_other_data/1
    ,calc_over_all_rating/1
    ,handle_event/2
    ,calc_equip_stren/5
    ,calc_equip_stren/4
    ,gm_repalce_equip/0
    ,gm_get_role_attr/1
    ,gm_get_role_attr/2
    ,gm_repaire_data/0
    ,gm_repaire_data/1
    ,gm_eudemons_compensate/0
    ]).

gm_repalce_equip() ->
    OldGtypeIds = data_eudemons:get_all_old_id(),
    Fun = fun(OldGtypeId) ->
        case data_eudemons:get_new_id(OldGtypeId) of
            NewGtypeId when is_integer(NewGtypeId) andalso NewGtypeId =/= OldGtypeId ->
                case data_eudemons:get_equip_attr(NewGtypeId) of
                    #base_eudemons_equip_attr{blue_attr = BlueAttr,bule_count = BlueCount,purple_attr = PurpleAttr,
                            purple_count = PurpleCount,orange_attr = OrangeAttr,orange_count = OrangeCount,red_attr = RedAttr,red_count = RedCount} ->

                        ExtraAttr = calc_dynamic_attr([{RedAttr, RedCount, ?RED}, {OrangeAttr, OrangeCount, ?ORANGE},
                                {PurpleAttr, PurpleCount, ?PURPLE}, {BlueAttr, BlueCount, ?BLUE}], []),

                        ExtraAttrS = util:term_to_string(ExtraAttr),
                        db:execute(io_lib:format("update `goods_high` set goods_id = ~p where goods_id = ~p ", [NewGtypeId, OldGtypeId])),
                        db:execute(io_lib:format("update `goods_low` set gtype_id = ~p, extra_attr = '~s'  where gtype_id = ~p ", [NewGtypeId, ExtraAttrS, OldGtypeId]));
                    _ ->
                        ?ERR("MISS CONFIG WHILE gm_repalce_equip OldGtypeId:~p,NewGtypeId:~p ~n",[OldGtypeId,NewGtypeId])
                end;
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, OldGtypeIds).

gm_get_role_attr(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_eudemons, gm_get_role_attr, [RoleId]).

gm_get_role_attr(PS, _) ->
    #player_status{eudemons = EudemonsStatus} = PS,
    #eudemons_status{eudemons_list = Items, total_attr = TotalAttr} = EudemonsStatus,
    F = fun
        (#eudemons_item{state = State, id = Id, equip_attr = EquipAttr}, Acc) ->
            if
                State =:= ?EUDEMONS_STATE_FIGHT ->
                    #base_eudemons_item{base_att = BaseAttr, skill_ids = SkillIds} = data_eudemons:get_item(Id),
                    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_EUDEMONS, SkillIds),
                    [{Id, BaseAttr, SkillAttr, EquipAttr}|Acc];
                true ->
                    Acc
            end
    end,
    List = lists:foldl(F, [], Items),
    ?INFO("EudemonsAttr:~p~n, Items:~p~n",[lists:keysort(1, TotalAttr), List]),
    {ok, PS}.

gm_repaire_data() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_eudemons, gm_repaire_data, []) || E <- OnlineRoles].

gm_repaire_data(PS) ->
    EudemonsStatus = init_data(PS#player_status.id),
    {ok, PS#player_status{eudemons = EudemonsStatus}}.

%% 因幻兽（蜃妖）基础属性调整进行补偿
gm_eudemons_compensate() ->
    % 补偿方案：[{幻兽id, 补偿物品列表},...]
    Compensation = [
        {1,[{0,16010001,1},{2,0,30}]},{2,[{0,16010001,1},{2,0,30}]},{3,[{0,16010002,1},{0,16010001,1},{2,0,30}]},{4,[{0,16010002,1},{0,16010001,1},{2,0,40}]},
        {5,[{0,16010002,1},{0,16010001,1},{2,0,40}]},{6,[{0,16010002,1},{0,16010001,1},{2,0,40}]},{7,[{0,16010002,1},{0,16010001,1},{2,0,40}]},{8,[{0,16010002,1},{0,16010001,2},{2,0,50}]},
        {9,[{0,16010002,1},{0,16010001,2},{2,0,50}]},{10,[{0,16010002,1},{0,16010001,2},{2,0,50}]},{11,[{0,16010002,1},{0,16010001,2},{2,0,60}]},{12,[{0,16010002,2},{0,16010001,2},{2,0,60}]},
        {13,[{0,16010002,2},{0,16010001,3},{2,0,60}]},{14,[{0,16010002,2},{0,16010001,3},{2,0,70}]},{15,[{0,16010003,1},{0,16010002,2},{2,0,70}]},{16,[{0,16010003,1},{0,16010002,2},{2,0,80}]},
        {17,[{0,16010003,1},{0,16010002,2},{2,0,80}]},{18,[{0,16010003,1},{0,16010002,3},{2,0,90}]},{19,[{0,16010003,1},{0,16010002,3},{2,0,90}]},{20,[{0,16010003,1},{0,16010002,3},{2,0,100}]},
        {21,[{0,16010003,1},{0,16010002,3},{2,0,100}]},{22,[{0,16010003,1},{0,16010002,3},{2,0,120}]},{23,[{0,16010003,1},{0,16010002,4},{2,0,120}]},{24,[{0,16010003,1},{0,16010002,4},{2,0,130}]},
        {25,[{0,16010003,1},{0,16010002,4},{2,0,130}]}
    ],

    % 根据玩家幻兽激活情况进行奖励汇总
    Sql = io_lib:format("select role_id, eudemons_id, state from eudemons", []),
    RoleL = db:get_all(Sql),
    F1 = fun
        ([_RoleId, _EudemonsId, ?EUDEMONS_STATE_SLEEP], AccM) ->
            AccM;
        ([RoleId, EudemonsId, _State], AccM) ->
            {_, EudemonsReward} = ulists:keyfind(EudemonsId, 1, Compensation, []),
            RewardL = maps:get(RoleId, AccM, []),
            maps:put(RoleId, RewardL ++ EudemonsReward, AccM)
    end,
    RoleRewardM = lists:foldl(F1, #{}, RoleL),

    % 发放奖励
    Title = <<"蜃妖调整补偿"/utf8>>,
    Content = <<"尊敬的阴阳师您好，根据您激活的蜃妖数量和种类，特为您献上对应补偿，请您查收，祝您游戏愉快"/utf8>>,
    F2 = fun({RoleId, RewardL0}) ->
        RewardL = lib_goods_api:make_reward_unique(RewardL0),
        mod_mail_queue:add(?MOD_EUDEMONS, [RoleId], Title, Content, RewardL)
    end,
    lists:foreach(F2, maps:to_list(RoleRewardM)),

    length(maps:keys(RoleRewardM)).

%% 物品生成时，计算物品的极品属性
calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOther) ->
    #ets_goods_type{goods_id = GoodsId} = GoodsTypeInfo,
    case data_eudemons:get_equip_attr(GoodsId) of
        #base_eudemons_equip_attr{blue_attr = BlueAttr,bule_count = BlueCount,purple_attr = PurpleAttr,purple_count = PurpleCount,orange_attr = OrangeAttr,orange_count = OrangeCount,red_attr = RedAttr,red_count = RedCount} ->
            ExtraAttr = calc_dynamic_attr([{RedAttr, RedCount, ?RED}, {OrangeAttr, OrangeCount, ?ORANGE}, {PurpleAttr, PurpleCount, ?PURPLE}, {BlueAttr, BlueCount, ?BLUE}], []),
            BaseRating = cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            GoodsOther#goods_other{rating = BaseRating, extra_attr = ExtraAttr};
        _ ->
            GoodsOther
    end.

calc_dynamic_attr([{AttrList, Count, Color}|T], Acc) ->
    Fun = fun({_, {TemAttrId,_}} = H, TemAcc) ->
        case lists:keyfind(TemAttrId, 2, Acc) of
            {_, TemAttrId, _} -> TemAcc;
            _ -> [H|TemAcc]
        end
    end,
    NewAttrList = lists:foldl(Fun, [], AttrList), %% 去掉重复的属性类型
    ChooseList = urand:list_rand_by_weight(NewAttrList, Count),
    Acc1 = [{Color, AttrId, AttrVal} || {AttrId, AttrVal} <- ChooseList],
    calc_dynamic_attr(T, Acc1 ++ Acc);

calc_dynamic_attr([], Acc) -> Acc.

%% 幻兽物品other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_EUDEMONS, other = Other}) ->
    #goods_other{stren = Strength, overflow_exp = Exp, optional_data = T} = Other,
    [?GOODS_OTHER_KEY_EUDEMONS_EXP, Strength, Exp|T];

format_other_data(_) -> [].

%% 幻兽物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [Strength, Exp|T]) ->
    Other#goods_other{stren = Strength, overflow_exp = Exp, optional_data = T}.

change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

do_repaire_data(RoleId, EquipGoodsList, GoodsStatus) ->
    %% 穿戴的物品，但是幻兽id数据不正确，自动脱下到背包
    TakeoffGoods = [TemGoodsInfo || #goods{other = #goods_other{optional_data = OData}} = TemGoodsInfo <- EquipGoodsList, OData == []],
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        F2 = fun
            (GoodsInfo, GoodsStatusAcc) ->
                [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_EUDEMONS_BAG, 0, GoodsStatusAcc),
                NewGoodsStatusAcc
        end,
        GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffGoods),
        #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
        {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
        NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
        {ok, GoodsL, NewGoodsStatus}
    end,
    case TakeoffGoods =/= [] andalso lib_goods_util:transaction(F) of
        {ok, GoodsL, NewGoodsStatus} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
            [lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]) || GoodsInfo <- TakeoffGoods],
            lib_goods_api:notify_client(RoleId, GoodsL),
            ?ERR("role_id:~p, TakeoffGoods:~p~n",[RoleId, TakeoffGoods]),
            NewGoodsStatus;
        _ ->
            GoodsStatus
    end.

%% 登陆初始化
%% 玩家在线/登陆时使用
init_data(RoleId) ->
    % #goods_status{dict = GoodsDict} = lib_goods_do:get_goods_status(),
    OGoodsStatus = lib_goods_do:get_goods_status(),
    SQL = io_lib:format("SELECT `eudemons_id`, `state` FROM `eudemons` WHERE `role_id` = ~p", [RoleId]),
    All = db:get_all(SQL),
    Ids = data_eudemons:get_all_items(),
    #goods_status{dict = OGoodsDict} = OGoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_EUDEMONS, OGoodsDict),
    %% 异常原因导致某些穿上去的装备没有归属幻兽，在这里做下特殊处理
    GoodsStatus = do_repaire_data(RoleId, EquipGoodsList, OGoodsStatus),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    Items = [
        begin
            case ulists:find(fun
                ([EudemonsId|_]) ->
                    EudemonsId =:= Id
            end, All) of
                {ok, [EuId, State]} ->
                    EquipList = calc_equip_list(EuId, EquipGoodsList),
                    Item = #eudemons_item{id = EuId, equip_list = EquipList, state = State},
                    refresh_item(RoleId, Item, GoodsDict);
                _ ->
                    EquipList = calc_equip_list(Id, EquipGoodsList),
                    refresh_item(RoleId, #eudemons_item{id = Id, equip_list = EquipList}, GoodsDict)
                    % #eudemons_item{id = Id}
            end
        end
    || Id <- Ids],
    %% 出战槽位数，初始值 + 终生数
    FightLocationCount = data_eudemons:get_cfg(default,fight_location) + mod_counter:get_count(RoleId, ?MOD_EUDEMONS, ?COUNTER_TYPE_EXTRA_LOCATION),
    PassiveSkills = calc_passive_skills(Items),
    EudemonsStatus = #eudemons_status{fight_location_count = FightLocationCount, eudemons_list = Items, passive_skills = PassiveSkills},
    %% 计算幻兽的所有属性
    calc_eudemons_status_attr(EudemonsStatus).

%% 初始化数据  %% 离线加载玩家数据
init_data(RoleId, GoodsStatus) ->
    SQL = io_lib:format("SELECT `eudemons_id`, `state` FROM `eudemons` WHERE `role_id` = ~p", [RoleId]),
    All = db:get_all(SQL),
    Ids = data_eudemons:get_all_items(),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_EUDEMONS, GoodsDict),
    Items = [
        begin
            case ulists:find(fun
                ([EudemonsId|_]) ->
                    EudemonsId =:= Id
            end, All) of
                {ok, [EuId, State]} ->
                    EquipList = calc_equip_list(EuId, EquipGoodsList),
                    Item = #eudemons_item{id = EuId, equip_list = EquipList, state = State},
                    refresh_item(RoleId, Item, GoodsDict);
                _ ->
                    EquipList = calc_equip_list(Id, EquipGoodsList),
                    refresh_item(RoleId, #eudemons_item{id = Id, equip_list = EquipList}, GoodsDict)
                    % #eudemons_item{id = Id}
            end
        end
    || Id <- Ids],
    FightLocationCount = 0, %%离线无法获得玩家该数据（出战数量未必等于拓展槽位的数量）
    PassiveSkills = calc_passive_skills(Items),
    EudemonsStatus = #eudemons_status{fight_location_count = FightLocationCount, eudemons_list = Items, passive_skills = PassiveSkills},
    calc_eudemons_status_attr(EudemonsStatus).

%% 计算单个幻灵的装备列表
calc_equip_list(EuId, EquipGoodsList) ->
    lists:foldl(fun
        (#goods{id = Id, other = #goods_other{optional_data = OData, stren = Strength, overflow_exp = Exp}, subtype = Pos}, Acc) ->
            case OData of
                [EuId] ->
                    [{Pos, Id, Strength, Exp}|Acc];
                _ ->
                    Acc
            end
    end, [], EquipGoodsList).

%% 获取被动技能列表
calc_passive_skills(Items) ->
    SkillList = lists:flatten([
        begin
            case data_eudemons:get_item(Id) of
                #base_eudemons_item{skill_ids = Skills} ->
                    Skills;
                _ ->
                    []
            end
        end || #eudemons_item{id = Id, state = ?EUDEMONS_STATE_FIGHT} <- Items
        ]),
    lib_skill_api:divide_passive_skill(SkillList).

%% 计算幻兽装备的属性
calc_equip_attr(EuId, [{Pos, GId, _,_}|T], GoodsDict, {Score, Acc}) ->
    case lib_goods_util:get_goods(GId, GoodsDict) of
        #goods{goods_id = GoodsTypeId, other = #goods_other{stren = Strength, extra_attr = ExtraAttr, rating = Rating}} ->
            BaseAttr
            = case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{base_attrlist = BAttr} ->
                    BAttr;
                _ ->
                    []
            end,
            StrenAttr
            = case data_eudemons:get_strength(Pos, Strength) of
                #base_eudemons_strength{attr = Attr} ->
                    Attr;
                _ ->
                    []
            end,
            DynamicAttr = [{AttrId, AttrVal} || {_, AttrId, AttrVal} <- ExtraAttr],
            Acc1 = lib_player_attr:add_attr(list, [BaseAttr, DynamicAttr, StrenAttr, Acc]),
            calc_equip_attr(EuId, T, GoodsDict, {Rating + Score, Acc1});
        _ ->
            calc_equip_attr(EuId, T, GoodsDict, {Score, Acc})
    end;

calc_equip_attr(_EuId, [], _, Acc) -> Acc.

%% 计算幻兽的所有属性
calc_eudemons_status_attr(EudemonsStatus) ->
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    F = fun
        (#eudemons_item{state = State, id = Id, equip_attr = EquipAttr}, {Acc, Acc1}) ->
            if
                State =:= ?EUDEMONS_STATE_FIGHT ->
                    #base_eudemons_item{base_att = BaseAttr, skill_ids = SkillIds} = data_eudemons:get_item(Id),
                    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_EUDEMONS, SkillIds),
                    {[BaseAttr, SkillAttr, EquipAttr|Acc],[BaseAttr, EquipAttr|Acc]};
                true ->
                    {Acc, Acc1}
            end
    end,
    {TemTotalAttr1,TotalAttr2} = lists:foldl(F, {[],[]}, Items),
    TotalAttr1 = ulists:kv_list_plus_extra(TemTotalAttr1),
    AttrList1 = ulists:kv_list_plus_extra(TotalAttr2),
    AllBaseAttr = lists:foldl(fun(KeyId, Acc) ->
        case lists:keyfind(KeyId, 1, AttrList1) of
            {KeyId, Value} -> [{KeyId, Value}|Acc];
            _ -> Acc
        end end, [], ?BASE_ATTR_LIST),
    TotalAttr = lib_player_attr:partial_attr_convert(TotalAttr1),
    EudemonsStatus#eudemons_status{total_attr = TotalAttr, all_base_attr = AllBaseAttr}.

item_data_for_send(#eudemons_item{id = Id, state = State, score = Score, equip_list = EquipList, equip_attr = EquipAttr}) ->
    {Id, State, Score, EquipList, EquipAttr}.

check_equip(EudemonsId, GoodsInfo) ->
    case data_eudemons:get_pos(EudemonsId, GoodsInfo#goods.subtype) of
        #base_eudemons_equip_pos{conditions = Conditions} ->
            do_check_equip(Conditions, GoodsInfo);
        _ ->
            {false, ?ERRCODE(err173_equip_error)}
    end.

do_check_equip([{color, X}|T], GoodsInfo) ->
    case data_goods_type:get(GoodsInfo#goods.goods_id) of
        #ets_goods_type{color = Value} when Value > X ->
            true;
        #ets_goods_type{color = Value} when Value == X ->
            do_check_equip(T, GoodsInfo);
        _ ->
            {false, ?ERRCODE(err173_equip_condition_error)}
    end;
do_check_equip([{star, X}|T], GoodsInfo) ->
    case data_eudemons:get_equip_attr(GoodsInfo#goods.goods_id) of
        #base_eudemons_equip_attr{star = Star} when Star >= X ->
            do_check_equip(T, GoodsInfo);
        _ ->
            {false, ?ERRCODE(err173_equip_condition_error)}
    end;
do_check_equip([_|_], _) ->
    {false, ?ERRCODE(config_error)};

do_check_equip([], _) -> true.

update_status(RoleId, EudemonsStatus, Item, GoodsDict) ->
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    OldItem = lists:keyfind(Item#eudemons_item.id, #eudemons_item.id, Items),
    NewItem = refresh_item(RoleId, Item, GoodsDict),
    NewItems = lists:keystore(Item#eudemons_item.id, #eudemons_item.id, Items, NewItem),
    NewEudemonsStatus = EudemonsStatus#eudemons_status{eudemons_list = NewItems},
    if
        OldItem#eudemons_item.state =:= ?EUDEMONS_STATE_FIGHT ->
            UpdqateEudemonsStatus = calc_eudemons_status_attr(NewEudemonsStatus),
            {true, UpdqateEudemonsStatus, NewItem};
        true ->
            {false, NewEudemonsStatus, NewItem}
    end.

%% 计算幻灵数据
refresh_item(_RoleId, Item, GoodsDict) ->
    #eudemons_item{id = EuId, equip_list = EquipList, state = State} = Item,
    {Score, EquipAttr} = calc_equip_attr(EuId, EquipList, GoodsDict, {0, []}),
    RealState
    = case length(data_eudemons:get_all_pos(EuId)) =:= length(EquipList) of
        true ->
            if
                State =:= ?EUDEMONS_STATE_FIGHT ->
                    ?EUDEMONS_STATE_FIGHT;
                true ->
                    ?EUDEMONS_STATE_ACTIVE
            end;
        _ ->
            ?EUDEMONS_STATE_SLEEP
    end,
    Power
    = case data_eudemons:get_item(EuId) of
        #base_eudemons_item{base_att = BaseAttr} ->
            lib_player:calc_all_power(lib_player_attr:add_attr(record, [BaseAttr]));
        _ ->
            0
    end,
    Item#eudemons_item{id = EuId, equip_list = EquipList, equip_attr = EquipAttr, state = RealState, score = Score + Power}.

calc_strength_new(GoodsInfo, Type, ExpAddCfg, CostNum) ->
    #goods{cell = Pos, other = #goods_other{stren = Strength, overflow_exp = Exp} = Other} = GoodsInfo,
    {NewExp, NewStren, CostExp} = calc_strength_core(Type, Pos, Exp, ExpAddCfg, Strength, CostNum, 0),
    {GoodsInfo#goods{other = Other#goods_other{stren = NewStren, overflow_exp = NewExp}}, NewExp, NewStren, CostExp}.

calc_strength_core(_Type, Pos, Exp, ExpAddCfg, Strength, 0, CostExp) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpCfg} when Exp >= ExpCfg ->
            calc_strength_core(_Type, Pos, Exp-ExpCfg, ExpAddCfg, Strength+1, 0, CostExp);
        _ ->
            {Exp, Strength, CostExp}
    end;
calc_strength_core(Type, Pos, Exp, ExpAddCfg, Strength, CostNum, CostExp) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpCfg} ->
            if
                Exp >= ExpCfg ->
                    calc_strength_core(Type, Pos, Exp - ExpCfg, ExpAddCfg, Strength + 1, CostNum, CostExp);
                Exp + ExpAddCfg >= ExpCfg ->
                    calc_strength_core(Type, Pos, Exp + ExpAddCfg - ExpCfg, ExpAddCfg, Strength + 1, CostNum-1, CostExp+ExpAddCfg);
                true ->
                    AddNum = umath:ceil((ExpCfg-Exp)/ExpAddCfg),
                    if
                        AddNum > CostNum ->
                            calc_strength_core(Type, Pos, CostNum*ExpAddCfg+Exp, ExpAddCfg, Strength, 0, CostExp+CostNum*ExpAddCfg);
                        true ->
                            calc_strength_core(Type, Pos, AddNum*ExpAddCfg+Exp-ExpCfg, ExpAddCfg, Strength + 1, CostNum-AddNum, CostExp+AddNum*ExpAddCfg)
                    end

            end;
        _ ->
            {Exp, Strength, CostExp}
    end.

calc_strength_new_cost_num(GoodsInfo, Type, ExpAddCfg) ->
    #goods{cell = Pos, other = #goods_other{stren = Strength, overflow_exp = Exp}} = GoodsInfo,
    {CostNum, NewStrength} = calc_strength_cost_num(Type, Pos, Exp, ExpAddCfg, Strength, 0, 0),
    if
        NewStrength > Strength ->
            CostNum;
        true ->
            {false, 0}
    end.

calc_strength_cost_num(0, _Pos, _Exp, _ExpAddCfg, _Strength, CostNum, _CostExp) ->
    {CostNum, _Strength};
calc_strength_cost_num(Type, Pos, Exp, ExpAddCfg, Strength, CostNum, CostExp) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpCfg} ->
            if
                Exp >= ExpCfg ->
                    calc_strength_cost_num(Type-1, Pos, Exp - ExpCfg, ExpAddCfg, Strength + 1, CostNum, CostExp);
                Exp + ExpAddCfg >= ExpCfg ->
                    calc_strength_cost_num(Type-1, Pos, Exp + ExpAddCfg - ExpCfg, ExpAddCfg, Strength + 1, CostNum+1, CostExp+ExpAddCfg);
                true ->
                    AddNum = umath:ceil((ExpCfg-Exp)/ExpAddCfg),
                    calc_strength_cost_num(Type-1, Pos, AddNum*ExpAddCfg+Exp-ExpCfg, ExpAddCfg, Strength + 1, CostNum+AddNum, CostExp+AddNum*ExpAddCfg)
            end;
        _ ->
            {CostNum, Strength}
    end.
calc_strength(GoodsTypeId, MaterialList) ->
    Exp = lists:sum([calc_material_exp(Exp, Strength, Pos) || #goods{other = #goods_other{stren = Strength, overflow_exp = Exp}, subtype = Pos} <- MaterialList]),
    case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{type = ?GOODS_TYPE_EUDEMONS, subtype = Pos} ->
            {NewStren, NewExp, _, _MaterialExp} = calc_strength(Pos, 0, Exp, [], 0, [], 0),
            {NewStren, NewExp};
        _ ->
            {0, 0}
    end.

calc_strength(GoodsInfo, MaterialList, IsDouble) ->
    #goods{cell = Pos, other = #goods_other{stren = Strength, overflow_exp = Exp} = Other} = GoodsInfo,
    SortMaterialList = lists:keysort(#goods.color, MaterialList),
    {NewStren, NewExp, CostMaterialList, MaterialExp}
    = calc_strength(Pos, Strength, Exp, SortMaterialList, IsDouble, [], 0),
    {GoodsInfo#goods{other = Other#goods_other{stren = NewStren, overflow_exp = NewExp}}, CostMaterialList, MaterialExp}.

calc_strength(Pos, Strength, Exp, [Material|T] = MaterialList, IsDouble, CostMaterialList, MaterialExpAcc) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpLimit} ->
            if
                ExpLimit =< Exp ->
                    calc_strength(Pos, Strength + 1, Exp - ExpLimit, MaterialList, IsDouble, CostMaterialList, MaterialExpAcc);
                true ->
                    MaterialExp = calc_material_exp(Material),
                    if
                        IsDouble =:= 1 ->
                            AddExp = MaterialExp * 2;
                        true ->
                            AddExp = MaterialExp
                    end,
                    if
                        ExpLimit =< Exp + AddExp ->
                            calc_strength(Pos, Strength + 1, Exp + AddExp - ExpLimit, T, IsDouble, [Material|CostMaterialList], MaterialExp + MaterialExpAcc);
                        true ->
                            calc_strength(Pos, Strength, Exp + AddExp, T, IsDouble, [Material|CostMaterialList], MaterialExp + MaterialExpAcc)
                    end
            end;
        _ ->
            {Strength, Exp, CostMaterialList, MaterialExpAcc}
    end;

calc_strength(Pos, Strength, Exp, [], IsDouble, CostMaterialList, MaterialExpAcc) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpLimit} ->
            if
                ExpLimit =< Exp ->
                    calc_strength(Pos, Strength + 1, Exp - ExpLimit, [], IsDouble, CostMaterialList, MaterialExpAcc);
                true ->
                    {Strength, Exp, CostMaterialList, MaterialExpAcc}
            end;
        _ ->
            {Strength, Exp, CostMaterialList, MaterialExpAcc}
    end.

%% 计算原材料提供的强化经验
calc_material_exp(#goods{type = ?GOODS_TYPE_EUDEMONS} = GoodsInfo) ->
    #goods{goods_id = GoodsTypeId,
            other = #goods_other{stren = Strength, overflow_exp = Exp},
            subtype = Pos
    } = GoodsInfo,
    BaseExp
    = case data_eudemons:get_equip_attr(GoodsTypeId) of
        #base_eudemons_equip_attr{base_exp = Value} ->
            Value;
        _ ->
            0
    end,
    calc_material_exp(BaseExp + Exp, Strength, Pos);

calc_material_exp(_) -> 0.

calc_material_exp(Exp0, Strength, Pos) when Strength > 0 ->
    case data_eudemons:get_strength(Pos, Strength) of
        #base_eudemons_strength{exp = ExpLimit} ->
            calc_material_exp(Exp0 + ExpLimit, Strength - 1, Pos);
        _ ->
            Exp0
    end;

calc_material_exp(Exp, _, _) -> Exp.

check_strength(GoodsInfo) ->
    if
        is_record(GoodsInfo, goods) =:= false ->
            ?ERRCODE(err150_no_goods);
        GoodsInfo#goods.location =/= ?GOODS_LOC_EUDEMONS ->
            ?FAIL;
        true ->
            #goods{other = #goods_other{stren = Strength}, cell = Pos} = GoodsInfo,
            case data_eudemons:get_strength(Pos, Strength + 1) of
                [] ->
                    ?ERRCODE(err173_strength_level_limit);
                _ ->
                    true
            end
    end.
check_strength(PS, GoodsInfo, CostGoodsInfo, Type, GoodsTypeId, ExpAddcfg) ->
    if
        is_record(GoodsInfo, goods) =:= false orelse is_record(CostGoodsInfo, goods) =:= false ->
            ?ERRCODE(err150_no_goods);
        GoodsInfo#goods.location =/= ?GOODS_LOC_EUDEMONS ->
            ?FAIL;
        is_integer(Type) == false ->
            ?ERRCODE(err173_error_type);
        true ->
            #goods{other = #goods_other{stren = Strength}, cell = Pos} = GoodsInfo,
            case data_eudemons:get_strength(Pos, Strength + 1) of
                [] ->
                    ?ERRCODE(err173_strength_level_limit);
                _ ->
                    CostNum = calc_strength_new_cost_num(GoodsInfo, Type, ExpAddcfg),
                    [{_, OwnNum}] = lib_goods_api:get_goods_num(PS, [GoodsTypeId]),
                    ?PRINT("CostNum:~p~n",[CostNum]),
                    case CostNum of
                        {false, 0} ->
                            ?ERRCODE(err173_strength_level_limit);
                        _ ->
                            if
                                CostNum =< OwnNum ->
                                    {true, CostNum};
                                true ->
                                    {true, OwnNum}
                            end
                    end

            end
    end.

refresh_with_strength(PS, NewGoodsInfo, GoodsInfo, GoodsDict) ->
    #goods{other = #goods_other{stren = Strength0}, cell = Pos, id = GoodsId} = GoodsInfo,
    #goods{other = #goods_other{stren = Strength1, overflow_exp = Exp1}} = NewGoodsInfo,
    if
        Strength1 =:= Strength0 ->
            {ok, PS};
        true ->
            #player_status{eudemons = EudemonsStatus} = PS,
            #eudemons_status{eudemons_list = Items} = EudemonsStatus,
            F = fun
                (#eudemons_item{equip_list = EquipList}) ->
                    case lists:keyfind(Pos, 1, EquipList) of
                        {_, GoodsId, _, _} ->
                            true;
                        _ ->
                            false
                    end
            end,
            case ulists:find(F, Items) of
                {ok, #eudemons_item{equip_list = EquipList} = Item} ->
                    NewEquipList = lists:keyreplace(Pos, 1, EquipList, {Pos, GoodsId, Strength1, Exp1}),
                    NewItem = Item#eudemons_item{equip_list = NewEquipList},
                    {FightChange, NewEudemonsStatus, RefreshItem} = update_status(PS#player_status.id, EudemonsStatus, NewItem, GoodsDict),
                    TmpPS = PS#player_status{eudemons = NewEudemonsStatus},
                    TotalStren = calc_total_dress_on_stren(Items, GoodsDict, 0),
                    {ok, NewPS} = lib_achievement_api:eudemons_equip_stren_event(TmpPS, TotalStren),
                    {FightChange, NewPS, RefreshItem};
                _ ->
                    {ok, PS}
            end
    end.

update_skill_change(PS, #eudemons_item{id = Id, state = State}) ->
    #player_status{eudemons = EudemonsStatus} = PS,
    case data_eudemons:get_item(Id) of
        #base_eudemons_item{skill_ids = Skills} ->
            case lib_skill_api:divide_passive_skill(Skills) of
                [] ->
                    PS;
                PassiveSkills ->
                    #eudemons_status{passive_skills = OldPassiveSkills} = EudemonsStatus,
                    if
                        State =:= ?EUDEMONS_STATE_FIGHT ->
                            NewPassiveSkills = PassiveSkills ++ OldPassiveSkills,
                            mod_scene_agent:update(PS, [{passive_skill, PassiveSkills}]);
                        true ->
                            NewPassiveSkills = OldPassiveSkills -- PassiveSkills,
                            mod_scene_agent:update(PS, [{delete_passive_skill, PassiveSkills}])
                    end,
                    NewEudemonsStatus = EudemonsStatus#eudemons_status{passive_skills = NewPassiveSkills},
                    PS#player_status{eudemons = NewEudemonsStatus}
            end;
        _ ->
            PS
    end.

%% 计算装备的评分
cal_equip_rating(GoodsTypeInfo, EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    #ets_goods_type{base_attrlist = BaseAttr, level = Level} = GoodsTypeInfo,
    Rating = lists:foldl(fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ -> RatingTmp
        end
    end, 0, BaseAttr ++ EquipExtraAttr),
    round(Rating);
cal_equip_rating(_, _) -> 0.

%% 计算装备强化的评分
cal_equip_stren_rating(GoodsTypeInfo, EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    #ets_goods_type{level = Level} = GoodsTypeInfo,
    Rating = lists:foldl(fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ -> RatingTmp
        end end, 0, EquipExtraAttr),
    round(Rating);
cal_equip_stren_rating(_, _) -> 0.

calc_over_all_rating(GoodsInfo) ->
    #goods_other{
        stren = Stren, rating = Rating
    } = GoodsInfo#goods.other,
    StrenPower = case data_eudemons:get_strength(GoodsInfo#goods.subtype, Stren) of
                    #base_eudemons_strength{attr = StrenAttr} ->
                        TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                        cal_equip_stren_rating(TempInfo, StrenAttr);
                    _ ->
                        0
                 end,
    Rating + StrenPower.

calc_total_dress_on_stren([#eudemons_item{equip_list = EquipList}|Items], GoodsDict, Acc) ->
    F = fun
        ({_, GoodsId, _, _}, X) ->
            case lib_goods_util:get_goods(GoodsId, GoodsDict) of
                #goods{other = #goods_other{stren = Strength}} ->
                    X + Strength;
                _ ->
                    X
            end
    end,
    Acc1 = lists:foldl(F, Acc, EquipList),
    calc_total_dress_on_stren(Items, GoodsDict, Acc1);

calc_total_dress_on_stren([], _, Acc) -> Acc.


% save_eudemons_equips(RoleId, EudemonsId, EquipList, EquipList0) ->
%     EquipListStr = util:term_to_string(EquipList),
%     SQL
%     = case EquipList of
%         [] ->
%             io_lib:format("DELETE FROM `eudemons` WHERE `role_id`=~p AND `eudemons_id`=~p", [RoleId, EudemonsId]);
%         _ when EquipList0 =:= [] ->
%             io_lib:format("INSERT INTO `eudemons`(`role_id`, `eudemons_id`, `equip_list`) VALUES(~p, ~p, '~s')", [RoleId, EudemonsId, EquipListStr]);
%         _ ->
%             io_lib:format("UPDATE `eudemons` SET `equip_list`='~s' WHERE `role_id`=~p AND `eudemons_id`=~p", [EquipListStr, RoleId, EudemonsId])
%     end,
%     db:execute(SQL).

save_eudemons_state(RoleId, EudemonsId, ?EUDEMONS_STATE_FIGHT) ->
    SQL = io_lib:format("INSERT INTO `eudemons`(`role_id`, `eudemons_id`, `state`) VALUES(~p, ~p, ~p)", [RoleId, EudemonsId, ?EUDEMONS_STATE_FIGHT]),
    db:execute(SQL);

save_eudemons_state(RoleId, EudemonsId, _) ->
    SQL = io_lib:format("DELETE FROM `eudemons` WHERE `role_id`=~p AND `eudemons_id`=~p", [RoleId, EudemonsId]),
    db:execute(SQL).

takeoff_equips(EquipGoodsList) ->
    [GoodsInfo#goods{other = Other#goods_other{optional_data = []}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].
takeoff_equips(Replace, EquipGoodsList) ->
    if
        Replace == 1 ->
            [GoodsInfo#goods{other = Other#goods_other{optional_data = [], stren = 0, overflow_exp = 0}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList];
        true ->
            takeoff_equips(EquipGoodsList)
    end.

dress_on_equips(#goods{other = Other} = GoodsInfo, EuId) ->
    GoodsInfo#goods{other = Other#goods_other{optional_data = [EuId]}}.
    % change_goods_other(GoodsInfo#goods{other = Other#goods_other{optional_data = [EuId]}}).

handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(PS, player_status) ->
    #player_status{eudemons = EudemonsStatus,id = RoleId, sid = Sid, figure = #figure{lv = Lv}} = PS,
    #eudemons_status{fight_location_count = FightLocationCount} = EudemonsStatus,
    % Limit = lib_counter:get_count_limit(?MOD_EUDEMONS, ?COUNTER_TYPE_EXTRA_LOCATION),
    DefaultCount = data_eudemons:get_cfg(default,fight_location),
    NextLocationCount = FightLocationCount - DefaultCount + 1,
    CfgList = data_eudemons:get_cfg(fight_location_cost, NextLocationCount),
    if
        is_list(CfgList) == true ->
            case lists:keyfind(lv, 1, CfgList) of
                {lv, LimitLv} ->
                    if
                        LimitLv =/= 0 andalso Lv >= LimitLv ->
                            mod_counter:increment_offline(RoleId, ?MOD_EUDEMONS, ?COUNTER_TYPE_EXTRA_LOCATION),
                            NewLocatinCount = FightLocationCount + 1,
                            {ok, BinData} = pt_173:write(17306, [NewLocatinCount]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            % {ok, AchvPlayer} = lib_achievement_api:eudemons_extend_event(PS, NewLocatinCount),
                            {ok, PS#player_status{eudemons = EudemonsStatus#eudemons_status{fight_location_count = NewLocatinCount}}};
                        true ->
                            {ok, PS}
                    end;
                _ ->
                    {ok, PS}
            end;
        true ->
            {ok, PS}
    end;
handle_event(PS, _) ->
    {ok, PS}.

calc_equip_stren(_, Stren, Exp, []) -> {Stren, Exp};
calc_equip_stren(Pos, Stren, Exp, [{OStren, OExp}|T]) ->
    {NewStren, NewExp} = calc_equip_stren(Pos, Stren, OStren, Exp, OExp),
    calc_equip_stren(Pos, NewStren, NewExp, T).

calc_equip_stren(Pos, Stren, OStren, Exp, OExp) ->
    OldTotalExp = calc_old_equip_exp(OStren, OExp, Pos),
    calc_equip_stren_core(Pos, OldTotalExp+Exp, Stren).

calc_equip_stren_core(Pos, Exp, Strength) ->
    case data_eudemons:get_strength(Pos, Strength + 1) of
        #base_eudemons_strength{exp = ExpCfg} ->
            if
                Exp >= ExpCfg ->
                    calc_equip_stren_core(Pos, Exp - ExpCfg, Strength + 1);
                true ->
                    {Strength, Exp}
            end;
        _ ->
            {Strength, Exp}
    end.
calc_old_equip_exp(0, OExp, _) -> OExp;
calc_old_equip_exp(OStren, OExp, Pos) ->
    case data_eudemons:get_strength(Pos, OStren) of
        #base_eudemons_strength{exp = ExpC} ->
            NewExp = OExp+ExpC;
        _ ->
            NewExp = OExp
    end,
    calc_old_equip_exp(OStren - 1, NewExp, Pos).