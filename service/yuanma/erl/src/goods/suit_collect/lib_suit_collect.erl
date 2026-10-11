%% ---------------------------------------------------------------------------
%% @doc 套装收集
%% @author lxl
%% @since  2020.3.13
%% @deprecated 套装收集活动
%% ---------------------------------------------------------------------------
-module(lib_suit_collect).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("equip_suit.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("skill.hrl").

-compile(export_all).

%% 登录处理
login(PS) ->
    case db_select_suit_clt_items(PS#player_status.id) of 
        [] -> PS#player_status{suit_collect = #suit_collect{}};
        DbList ->
            F = fun([SuitId, CurStage, PosListStr, IsFigure], {CltList, SuitCltFigure}) ->
                    NewCltList = [#suit_clt_item{suit_id = SuitId, cur_stage = CurStage, pos_list = util:bitstring_to_term(PosListStr)}|CltList],
                    NewSuitCltFigure = ?IF(SuitCltFigure =/= 0, SuitCltFigure, ?IF(IsFigure =/= 0, SuitId, 0)),
                    {NewCltList, NewSuitCltFigure}
                end,
            {CltList, SuitCltFigure} = lists:foldl(F, {[], 0}, DbList),
            SuitCollect = #suit_collect{clt_list = CltList},
            LastSuitCollect = count_suit_clt_attr(SuitCollect),
            Figure = PS#player_status.figure,
            NewFigure = Figure#figure{suit_clt_figure = SuitCltFigure},
            PS#player_status{suit_collect = LastSuitCollect, figure = NewFigure}
    end.

%% 15256
%% 登录时发送套装收集信息列表
%% 会对所有装备进行点亮检查
send_suit_clt_list(PS) ->
    % 取出所有正在穿戴的装备，分别执行auto_activate（针对更新该功能前就已穿戴的装备）
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GS,
    EquipList = lib_goods_util:get_goods_list(PS#player_status.id, ?GOODS_LOC_EQUIP, GoodsDict),
    NewPS = auto_activate(PS, EquipList, ?UPDATE),
    #player_status{sid = Sid, suit_collect = #suit_collect{clt_list = CltList}, figure = #figure{suit_clt_figure = SuitCltFigure}} = NewPS,
    F = fun(#suit_clt_item{suit_id = SuitId, cur_stage = CurStage, pos_list = PosList}, Acc) ->
            case CurStage =:= ?SUIT_CLT_MAX_STAGE of
                true    -> SendPosList = ?SUIT_CLT_ALL_POS;
                false   -> SendPosList = PosList
            end,
            [{SuitId, CurStage, SendPosList}|Acc]
        end,
    SendList = lists:foldl(F, [], CltList),
    lib_server_send:send_to_sid(Sid, pt_152, 15256, [SendList, SuitCltFigure]),
    {ok, NewPS}.

%% -----------------------------------------------------------------
%% @desc  激活套装收集 15257
%% @param PS  玩家信息
%% @param SuitId  套装Id
%% @param CltStage  阶段
%% @return {ok, NewPS, NeedEquipList} | {fail, Res}
%% -----------------------------------------------------------------
suit_collect(PS, SuitId, CltStage) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    GS = lib_goods_do:get_goods_status(),
    case check_active(PS, GS, SuitId, CltStage) of 
        {ok, TempPS, NeedEquipList} ->
            EquipPS = wear_bag_equip(TempPS, GS, SuitId, CltStage, NeedEquipList),
            %% 计算穿戴属性和技能战力
            CalPS = calc_suit_collect(SuitId, EquipPS),
            #player_status{suit_collect = #suit_collect{clt_list = CltList}} = CalPS,
            NewSuitCltItem = ulists:keyfind(SuitId, #suit_clt_item.suit_id, CltList, #suit_clt_item{suit_id = SuitId}),
            lib_player:send_attribute_change_notify(CalPS, ?NOTIFY_ATTR),
            send_suit_clt_tv(CalPS, SuitId, CltStage),
            lib_log_api:log_suit_clt(RoleId, RoleName, SuitId, CltStage),
            EventPS = lib_suit_collect_event:event(activate, [CalPS, SuitId, CltStage]),
            {ok, EventPS, NewSuitCltItem};
        {fail, Res} -> {fail, Res}
    end.

%% -----------------------------------------------------------------
%% @desc  检查是否能激活
%% @param PS  玩家信息
%% @param GS  物品记录
%% @param SuitId  套装Id
%% @param CltStage  阶段
%% @return {ok, NewPS, NeedEquipList}
%% -----------------------------------------------------------------
check_active(PS, GS, SuitId, CltStage) ->
    #player_status{id = _RoleId, suit_collect = #suit_collect{clt_list = CltList} = SuitCollect, figure = #figure{lv = Lv, career = Career, turn = _Turn}} = PS,
    SuitCltItem = #suit_clt_item{pos_list = PosList} = ulists:keyfind(SuitId, #suit_clt_item.suit_id, CltList, #suit_clt_item{suit_id = SuitId}),
    #goods_status{dict = GoodsDict} = GS,
    SuitCltCfg = data_suit_collect:get_suit_clt_cfg(SuitId, Career),
    StageList = data_suit_collect:get_stage_list(SuitId),
    IsValidStage = lists:member(CltStage, StageList),
    {IsValidEquip, NeedEquipList} = check_valid_stage(SuitId, CltStage, SuitCltItem, PosList, GoodsDict, PS, SuitCltCfg),
    if
        is_record(SuitCltCfg, base_suit_clt) == false orelse StageList == [] -> {fail, ?MISSING_CONFIG};
        IsValidStage == false orelse IsValidEquip == false -> {fail, ?ERRCODE(err152_equip_not_enough)};
        CltStage =< SuitCltItem#suit_clt_item.cur_stage -> {fail, ?ERRCODE(err152_suit_clt_is_active)};
        Lv < SuitCltCfg#base_suit_clt.open_lv -> {fail, ?LEVEL_LIMIT};
        true ->
            NewSuitCltItem = SuitCltItem#suit_clt_item{cur_stage = CltStage},
            NewCltList = lists:keystore(SuitId, #suit_clt_item.suit_id, CltList, NewSuitCltItem),
            NewSuitCollect = SuitCollect#suit_collect{clt_list = NewCltList},
            NewPS = PS#player_status{suit_collect = NewSuitCollect},
            {ok, NewPS, NeedEquipList}
    end.

%% -----------------------------------------------------------------
%% @desc  检查装备是否足够激活(前4套史诗特殊处理)
%% @param PS  玩家信息
%% @param SuitCltItem  物品记录
%% @param SuitId  套装Id
%% @param CltStage  阶段
%% @param PosList  已经激活的装备位置
%% @param ShowEquip  装备推荐
%% @return {false | true, NeedEquipList}
%% -----------------------------------------------------------------
check_valid_stage(SuitId, CltStage, SuitCltItem, PosList, GoodsDict, PS, SuitCltCfg) when
    SuitId =:= 1 orelse SuitId =:= 2 orelse SuitId =:= 3 orelse SuitId =:= 4 ->
    #base_suit_clt{show_equip = ShowEquip} = SuitCltCfg,
    F = fun({_Id1, GoodsId, _Id2}, TempAllChoosePos) ->
        #ets_goods_type{equip_type = Pos} = data_goods_type:get(GoodsId),
        lists:append(TempAllChoosePos, [Pos])
        end,
    %% 获得所有可以装备的位置
    AllChoosePos = lists:foldl(F, [], ShowEquip),
    CanChoosePos = AllChoosePos -- PosList,
    NeedEquipNum = CltStage - length(PosList),
    NeedEquipList = ?IF(NeedEquipNum =< 0, [], get_need_equip_list(PS, GoodsDict, CanChoosePos, NeedEquipNum, SuitCltCfg)),
    {length(SuitCltItem#suit_clt_item.pos_list) + length(NeedEquipList) >= CltStage, NeedEquipList};
check_valid_stage(_SuitId, CltStage, SuitCltItem, _PosList, _GoodsDict, _PS, _ShowEquip) -> {length(SuitCltItem#suit_clt_item.pos_list) >= CltStage, []}.

%% -----------------------------------------------------------------
%% @desc  计算玩家套装属性和技能
%% @param SuitCollect
%% @return #suit_collect{}
%% -----------------------------------------------------------------
count_suit_clt_attr(SuitCollect) ->
    #suit_collect{clt_list = CltList} = SuitCollect,
    FA = fun(SuitCleItem, {AttrListA, PassiveSkillsA, SkillPowerA}) ->
        #suit_clt_item{suit_id = SuitId, cur_stage = CurStage} = SuitCleItem,
        CfgStageList = data_suit_collect:get_stage_list(SuitId),
        FB = fun(CfgStage, {AttrListB, PassiveSkillsB, SkillPowerB}) ->
            if
                CfgStage > CurStage -> {AttrListB, PassiveSkillsB, SkillPowerB};
                true ->
                    #base_suit_clt_process{
                        attr = Attr,
                        skill_id = SkillId
                    } = data_suit_collect:get_suit_clt_process(SuitId, CfgStage),
                    NewAttrListA = lib_player_attr:add_attr(list, [Attr, AttrListB]),
                    {NewPassiveSkillsA, NewSkillPowerA} = count_skill_and_power(SkillId, PassiveSkillsB, SkillPowerB),
                    {NewAttrListA, NewPassiveSkillsA, NewSkillPowerA}
            end
             end,
        lists:foldl(FB, {AttrListA, PassiveSkillsA, SkillPowerA}, CfgStageList)
        end,
    {NewAttrList, NewPassiveSkills, NewSkillPower} = lists:foldl(FA, {[], [], 0}, CltList),
    SuitCollect#suit_collect{attr = NewAttrList, passive_skills = NewPassiveSkills, skill_power = NewSkillPower}.

%% 计算技能和战力
count_skill_and_power(SkillId, PassiveSkillsB, SkillPowerB) when SkillId =:= 0 -> {PassiveSkillsB, SkillPowerB};
count_skill_and_power(SkillId, PassiveSkillsB, SkillPowerB) ->
    #skill{
        type = ?SKILL_TYPE_PASSIVE,
        lv_data = LvData
    } = data_skill:get(SkillId, 1),
    #skill_lv{power = Power} = LvData,
    {[{SkillId, 1} | PassiveSkillsB], SkillPowerB + Power}.

%% 发送套装激活传闻（整套套装全部8件激活）
send_suit_clt_tv(PS, SuitId, ?SUIT_CLT_MAX_STAGE) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName, career = Career}} = PS,
    SuitCltCfg = data_suit_collect:get_suit_clt_cfg(SuitId, Career),
    SuitName = SuitCltCfg#base_suit_clt.name,
    lib_chat:send_TV({all}, ?MOD_EQUIP, 10, [RoleName, RoleId, SuitName]);
send_suit_clt_tv(_PS, _SuitId, _Stage) -> skip.

%% -----------------------------------------------------------------
%% @desc 穿戴装备自动点亮对应套装部位
%% @param EquipInfoList
%% @param Mode
%% @return #player_status{}
%% -----------------------------------------------------------------
auto_activate(PS, EquipInfoList, Mode) ->
    #player_status{
        id           = RoleId,
        sid          = Sid,
        suit_collect = SuitCollect,
        figure       = Figure
    } = PS,
    #figure{career = Career, suit_clt_figure = SuitCltFigure} = Figure,
    CfgSuitIdList = data_suit_collect:get_all_suit_id(Career),
    FA = fun(EquipInfo, SuitCollectA) ->
        #goods{equip_type = EquipPos} = EquipInfo,
        FB = fun(CfgSuitId, {SuitCollectB, ActivateList}) ->
            #suit_collect{clt_list = CltList} = SuitCollectB,
            SuitCltItem = ulists:keyfind(CfgSuitId, #suit_clt_item.suit_id, CltList, #suit_clt_item{suit_id = CfgSuitId}),
            SuitCltCfg = data_suit_collect:get_suit_clt_cfg(CfgSuitId, Career),
            #base_suit_clt{stage = EquipStage, star = EquipStar, color = EquipColor, show_equip = ShowEquip} = SuitCltCfg,
            IsReachCondition = is_reach_clt_condition([{equip_pos, ShowEquip, EquipInfo}, {stage, EquipStage, EquipInfo},
                {star, EquipStar, EquipInfo}, {color, EquipColor, EquipInfo}, {unbroken, EquipInfo}]),
            IsActivated = lists:member(EquipPos, SuitCltItem#suit_clt_item.pos_list),
            if
                %% 当前套装位置未点亮且符合点亮条件
                IsActivated =:= false andalso IsReachCondition ->
                    NewPosList = lists:append(SuitCltItem#suit_clt_item.pos_list, [EquipPos]),
                    NewSuitCltItem = SuitCltItem#suit_clt_item{pos_list = NewPosList},
                    NewCltList = lists:keystore(CfgSuitId, #suit_clt_item.suit_id, CltList, NewSuitCltItem),
                    NewSuitCollectC = SuitCollect#suit_collect{clt_list = NewCltList},
                    {NewSuitCollectC, [CfgSuitId | ActivateList]};
                true ->  {SuitCollectB, ActivateList}
            end
             end,
        %% 遍历配置套装列表
        {NewSuitCollectA, NewActivateList} = lists:foldl(FB, {SuitCollectA, []}, CfgSuitIdList),
        FC = fun(ActiveId, List) ->
            #suit_clt_item{cur_stage = CurStage, pos_list = PosList} =
                ulists:keyfind(ActiveId, #suit_clt_item.suit_id, NewSuitCollectA#suit_collect.clt_list, #suit_clt_item{suit_id = ActiveId}),
            IsFigure = ?IF(ActiveId == SuitCltFigure, ?WEAR, ?UNWEAR),
            [[RoleId, ActiveId, CurStage, util:term_to_bitstring(PosList), IsFigure] | List]
            end,
        %% 获得需要更新的套装信息列表
        UpdateList = lists:foldl(FC, [], NewActivateList),
        db_replace_suit_clt(UpdateList),
        Mode =:= ?SEND andalso lib_server_send:send_to_sid(Sid, pt_152, 15258, [NewActivateList, EquipPos]),
        NewSuitCollectA
        end,
    %% 遍历装备更新列表
    NewSuitCollect = lists:foldl(FA, SuitCollect, EquipInfoList),
    PS#player_status{suit_collect = NewSuitCollect}.

%% -----------------------------------------------------------------
%% @desc  穿上背包装备(前4套史诗特殊处理)
%% @param PS  玩家信息
%% @param GoodsStatus  物品记录
%% @param SuitId  套装Id
%% @param CltStage  阶段
%% @param NeedEquipList  需要更换的装备列表
%% @return PS
%% -----------------------------------------------------------------
wear_bag_equip(PS, GoodsStatus, SuitId, CltStage, NeedEquipList) when
    SuitId =:= 1 orelse SuitId =:= 2 orelse SuitId =:= 3 orelse SuitId =:= 4->
    #player_status{figure = #figure{career = Career}, suit_collect = #suit_collect{clt_list = CltList}} = PS,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    SuitCltCfg = data_suit_collect:get_suit_clt_cfg(SuitId, Career),
    #base_suit_clt{show_equip = ShowEquip} = SuitCltCfg,
    F = fun({_Id1, GoodsId, _Id2}, TempAllChoosePos) ->
        #ets_goods_type{subtype = Pos} = data_goods_type:get(GoodsId),
        lists:append(TempAllChoosePos, [Pos])
        end,
    %% 获得所有可以装备的位置
    AllChoosePos = lists:foldl(F, [], ShowEquip),
    %% 该套装的激活信息
    #suit_clt_item{pos_list = PosList} = ulists:keyfind(SuitId, #suit_clt_item.suit_id, CltList, #suit_clt_item{suit_id = SuitId}),
    %% 玩家身上
    AlreadyList = [X||X<-AllChoosePos,Y<-PosList,X=:=Y],
    case CltStage =< length(PosList) of
        true ->
            SumNeedEquipList = get_already_equip_list(AlreadyList, PS, GoodsDict, SuitCltCfg),
            foreach_handle(SumNeedEquipList, PS);
        false ->
            SumNeedEquipList = NeedEquipList ++ get_already_equip_list(AlreadyList, PS, GoodsDict, SuitCltCfg),
            foreach_handle(SumNeedEquipList, PS)
    end;
wear_bag_equip(PS, _GoodsStatus, _SuitId, _CltStage, _NeedEquipList) -> PS.

%% -----------------------------------------------------------------
%% @desc  计算激活装备后的战力
%% @param PS  玩家信息
%% @param SuitId  套装Id
%% @return PS
%% -----------------------------------------------------------------
calc_suit_collect(SuitId, PS) ->
    #player_status{id = RoleId, suit_collect = #suit_collect{clt_list = CltList} = SuitCollect} = PS,
    NewSuitCltItem = ulists:keyfind(SuitId, #suit_clt_item.suit_id, CltList, #suit_clt_item{suit_id = SuitId}),
    db_replace_suit_clt_item(RoleId, NewSuitCltItem),
    NewSuitCollect = count_suit_clt_attr(SuitCollect),
    NewPS = PS#player_status{suit_collect = NewSuitCollect},
    %% 加上套装的增益
    AfAttrPS = lib_player:count_player_attribute(NewPS),
    SceneArgs = [{battle_attr, NewPS#player_status.battle_attr}, {passive_skill, NewSuitCollect#suit_collect.passive_skills}],
    mod_scene_agent:update(NewPS, SceneArgs),
    AfAttrPS.

%% -----------------------------------------------------------------
%% @desc  穿戴更优的装备
%% @param PS  玩家信息
%% @param AlreadyList  玩家身上装备位置列表
%% @param GoodsDict  物品字典
%% @param SuitCltCfg  套装配置
%% @return
%% -----------------------------------------------------------------
get_already_equip_list(AlreadyList, PS, GoodsDict, SuitCltCfg) ->
    GoodsEquipList = lib_goods_util:get_equip_list(PS#player_status.id, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    GoodsBagList = lib_goods_util:get_equip_list(PS#player_status.id, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_BAG, GoodsDict),
    F = fun(Pos, TempNeedEquipList) ->
        GoodsEquip = lists:keyfind(Pos, #goods.equip_type, GoodsEquipList),
        %% 该类型可以选择的装备
        CanChooseEquipList = [Goods || Goods <-GoodsBagList, check_choose_equip(Goods, PS, Pos, SuitCltCfg)] ++ [GoodsEquip],
        %% 比较同类型最优的装备
        SortList = compare_equip(CanChooseEquipList),
        ExcellentEquip = hd(SortList),
        ?IF(ExcellentEquip#goods.id =:= GoodsEquip#goods.id, TempNeedEquipList, lists:append(TempNeedEquipList, [ExcellentEquip]))
        end,
    lists:foldl(F, [] ,AlreadyList).

%% -----------------------------------------------------------------
%% @desc  遍历执行穿戴装备
%% @param NeedEquipList  需要穿戴的装备列表
%% @return
%% -----------------------------------------------------------------
foreach_handle([], PS) -> PS;
foreach_handle([Goods | NeedEquipList], PS) ->
    case pp_equip:handle(15201, PS, [Goods#goods.id]) of
        {ok, equip, NewPS} -> foreach_handle(NeedEquipList, NewPS);
        {ok, PS} -> foreach_handle(NeedEquipList, PS)
    end.

%% -----------------------------------------------------------------
%% @desc  获得需要装备的装备列表
%% @param RoleId  玩家Id
%% @param GoodsDict  物品字典
%% @param CanChoosePos  可以选择的装备位置
%% @param NeedEquipNum  需要装备的装备数量
%% @return [#goods{},...]
%% -----------------------------------------------------------------
get_need_equip_list(PS, GoodsDict, CanChoosePos, NeedEquipNum, SuitCltCfg) ->
    GoodsList = lib_goods_util:get_equip_list(PS#player_status.id, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_BAG, GoodsDict),
    F = fun(Pos, TempNeedEquipList) ->
        %% 该类型可以选择的装备
        CanChooseEquipList = [Goods || Goods <-GoodsList, check_choose_equip(Goods, PS, Pos, SuitCltCfg)],
        %% 比较同类型最优的装备
        SortList = compare_equip(CanChooseEquipList),
        ?IF(SortList == [],TempNeedEquipList, lists:append(TempNeedEquipList, [hd(SortList)]))
        end,
    NeedEquipList = lists:foldl(F, [] ,CanChoosePos),
    %% 比较不同位置最优装备
    lists:sublist(compare_equip(NeedEquipList), NeedEquipNum).

%% -----------------------------------------------------------------
%% @desc  检查装备是否可以穿戴
%% @param Goods 物品记录
%% @param Pos 物品装备位置
%% @param SuitCltCfg 套装配置
%% @return
%% -----------------------------------------------------------------
check_choose_equip(Goods, PS, Pos, SuitCltCfg) ->
    #base_suit_clt{stage = EquipStage, star = EquipStar, color = EquipColor, show_equip = ShowEquip} = SuitCltCfg,
    GoodsStatus = lib_goods_do:get_goods_status(),
    IsSamePos = Goods#goods.equip_type =:= Pos,
    case lib_equip_check:equip(PS, GoodsStatus, Goods#goods.id) of
        {true, _GoodsInfo} ->
            IsReachCondition = is_reach_clt_condition([{equip_pos, ShowEquip, Goods}, {stage, EquipStage, Goods},
                {star, EquipStar, Goods}, {color, EquipColor, Goods}, {unbroken, Goods}]),
            IsReachCondition andalso IsSamePos;
        {false, _Res} -> false
    end.

%% -----------------------------------------------------------------
%% @desc  比较装备优劣
%% @param CompareList  需要比较的物品列表
%% @return [#goods{},...]
%% -----------------------------------------------------------------
compare_equip(CompareList) ->
    SortFun = fun(GoodsA, GoodsB) ->
        StageA = lib_equip_api:get_equip_stage(GoodsA),
        StageB = lib_equip_api:get_equip_stage(GoodsB),
        StarA = lib_equip_api:get_equip_star(GoodsA),
        StarB = lib_equip_api:get_equip_star(GoodsB),
        StageA >= StageB andalso StarA >= StarB andalso GoodsA#goods.color >= GoodsB#goods.color
              end,
    lists:sort(SortFun, CompareList).

is_reach_clt_condition([]) -> true;
is_reach_clt_condition([{equip_pos, ShowEquip, GoodsInfo}|L]) ->
    case lists:keymember(GoodsInfo#goods.equip_type, 1, ShowEquip) of 
        true -> is_reach_clt_condition(L);
        _ -> false
    end;
is_reach_clt_condition([{stage, EquipStage, GoodsInfo}|L]) ->
    Stage = lib_equip_api:get_equip_stage(GoodsInfo),
    case Stage >= EquipStage of 
        true -> is_reach_clt_condition(L);
        _ -> false
    end;
is_reach_clt_condition([{star, EquipStar, GoodsInfo}|L]) ->
    Star = lib_equip_api:get_equip_star(GoodsInfo),
    case Star >= EquipStar of 
        true -> is_reach_clt_condition(L);
        _ -> false
    end;
is_reach_clt_condition([{color, EquipColor, GoodsInfo}|L]) ->
    case GoodsInfo#goods.color >= EquipColor of 
        true -> is_reach_clt_condition(L);
        _ -> false
    end;
is_reach_clt_condition([{unbroken, GoodsInfo}|L]) ->
    case lib_equip:get_equip_class_type(GoodsInfo) of
        1 -> false;         % 分类1则为残破装备
        _ -> is_reach_clt_condition(L)
    end;
is_reach_clt_condition([_|_L]) -> false.

%% 15259
%% 穿戴/脱下 套装收集时装
wear_model(PS, SuitId, IsWear) ->
    #player_status{id = RoleId, suit_collect = #suit_collect{clt_list = CltList}, figure = #figure{suit_clt_figure = SuitCltFigure} = Figure} = PS,
    #suit_clt_item{cur_stage = Stage} = lists:keyfind(SuitId, #suit_clt_item.suit_id, CltList),
    CanOperated = ?IF(IsWear == ?WEAR, SuitId =/= SuitCltFigure, SuitId =:= SuitCltFigure),
    IsMaxStage = (Stage == ?SUIT_CLT_MAX_STAGE),
    if
        CanOperated == false andalso IsWear == ?WEAR -> {fail, ?ERRCODE(err152_fashion_weared)};
        CanOperated == false andalso IsWear == ?UNWEAR -> {fail, ?ERRCODE(err152_fashion_unweared)};
        IsMaxStage == false -> {fail, ?ERRCODE(err152_equip_not_enough)};
        true-> 
            NewSuitCltFigure = ?IF(IsWear == ?WEAR, SuitId, 0),
            db_update_suit_clt_figure(RoleId, SuitCltFigure, ?UNWEAR),
            db_update_suit_clt_figure(RoleId, NewSuitCltFigure, ?WEAR),         % 更新db
            NewFigure = Figure#figure{suit_clt_figure = NewSuitCltFigure},
            NewPS = PS#player_status{figure = NewFigure},                       % 更新玩家状态
            lib_suit_collect_event:event(IsWear, [NewPS, 1])                    % {ok, LastPS}  
    end.

%% 获取穿着的时装套装id
get_figure(RoleId) ->
    case db_select_suit_clt_figure(RoleId) of
        [] -> 0;
        [[SuitId]|_] -> SuitId
    end.

%% 外部gm秘籍
%% 对于已点亮4阶套装的玩家，自动点亮2阶和3阶套装
auto_activate_23() ->
    DbList = db:get_all(io_lib:format(<<"select role_id, suit_id, cur_stage, pos_list from suit_clt where suit_id <= 3">>, [])),
    F = fun([RoleId, SuitId, CurStage, PosListStr], {TList2, TList3, TList4}) ->
            case SuitId of
                % 2阶
                1 -> 
                    NewList2 = [{RoleId, SuitId, CurStage, util:bitstring_to_term(PosListStr)}|TList2],
                    NewList3 = TList3, NewList4 = TList4;
                % 3阶
                2 ->
                    NewList3 = [{RoleId, SuitId, CurStage, util:bitstring_to_term(PosListStr)}|TList3],
                    NewList2 = TList2, NewList4 = TList4;
                % 4阶
                3 ->
                    NewList4 = [{RoleId, SuitId, CurStage, util:bitstring_to_term(PosListStr)}|TList4],
                    NewList2 = TList2, NewList3 = TList3;
                _ -> 
                    NewList2 = TList2, NewList3 = TList3, NewList4 = TList4
            end,
            {NewList2, NewList3, NewList4}
        end,
    % 点亮2、3、4阶的套装列表信息
    {List2, List3, List4} = lists:foldl(F, {[], [], []}, DbList),
    UpdateF = 
        fun({RoleId, _SuitId, _Stage4, PosList}, {URoles, UList}) ->
            % 取出当前玩家的2阶套装点亮信息
            CurInfo2 = ulists:keyfind(RoleId, 1, List2, {}),
            case CurInfo2 of
                {} -> 
                    AppendList2 = PosList,
                    NewUList2 = [[RoleId, ?SUIT2, 0, util:term_to_bitstring(PosList), 0] | UList];
                {_, _, Stage2, CurPosList2} ->
                    AppendList2 = PosList -- CurPosList2,
                    NewUList2 = ?IF(AppendList2 =:= [], UList, [[RoleId, ?SUIT2, Stage2, util:term_to_bitstring(lists:append(CurPosList2, AppendList2)), 0] | UList])
            end,
            % 取出当前玩家的3阶套装点亮信息
            CurInfo3 = ulists:keyfind(RoleId, 1, List3, {}),
            case CurInfo3 of
                {} -> 
                    AppendList3 = PosList,
                    NewUList3 = [[RoleId, ?SUIT3, 0, util:term_to_bitstring(PosList), 0] | NewUList2];
                {_, _, Stage3, CurPosList3} ->
                    AppendList3 = PosList -- CurPosList3,
                    NewUList3 = ?IF(AppendList3 =:= [], NewUList2, [[RoleId, ?SUIT3, Stage3, util:term_to_bitstring(lists:append(CurPosList3, AppendList3)), 0] | NewUList2])
            end,
            if
                AppendList2 =:= [] andalso AppendList3 =:= [] -> NewURoles = URoles;
                true -> NewURoles = [RoleId | URoles]
            end,
            {NewURoles, NewUList3}
        end,
    {UpdateRoles, UpdateList} = lists:foldl(UpdateF, {[], []}, List4),
    Sql = usql:replace(suit_clt, [role_id, suit_id, cur_stage, pos_list, is_figure], UpdateList),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    broadcast_auto_activate_23(UpdateRoles).

broadcast_auto_activate_23(UpdateRoles) ->
    % 获取在线的玩家列表，逐个处理
    OnlineList = ets:tab2list(?ETS_ONLINE),
    OnlineIds = [RoleId || #ets_online{id = RoleId} <- OnlineList],
    F = fun(RoleId) ->
            case lists:member(RoleId, OnlineIds) of
                false -> skip;
                true -> lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_suit_collect_api, reload_suit_clt_info, [])
            end
        end,
    lists:foreach(F, UpdateRoles).

db_replace_suit_clt(UpdateList) ->
    Sql = usql:replace(suit_clt, [role_id, suit_id, cur_stage, pos_list, is_figure], UpdateList),
    Sql =/=[] andalso db:execute(Sql).

db_select_suit_clt_items(RoleId) ->
    db:get_all(io_lib:format(<<"select suit_id, cur_stage, pos_list, is_figure from suit_clt where role_id=~p">>, [RoleId])).

db_replace_suit_clt_item(RoleId, SuitCltItem) ->
    #suit_clt_item{suit_id = SuitId, cur_stage = CurStage, pos_list = PosList} = SuitCltItem,
    db:execute(io_lib:format(<<"replace into suit_clt set role_id=~p, suit_id=~p, cur_stage=~p, pos_list='~s' ">>, [RoleId, SuitId, CurStage, util:term_to_bitstring(PosList)])).

db_delete_suit_clt_item(RoleId) ->
    db:execute(io_lib:format(<<"delete from suit_clt where role_id=~p">>, [RoleId])).

db_update_suit_clt_figure(RoleId, SuitId, IsWear) when SuitId =/= 0 ->
    db:execute(io_lib:format(<<"update suit_clt set is_figure=~p where role_id=~p and suit_id=~p">>, [IsWear, RoleId, SuitId]));
db_update_suit_clt_figure(_RoleId, _SuitId, _IsWear) -> skip.

db_select_suit_clt_figure(RoleId) ->
    db:get_all(io_lib:format(<<"select suit_id from suit_clt where role_id=~p and is_figure = 1">>, [RoleId])).