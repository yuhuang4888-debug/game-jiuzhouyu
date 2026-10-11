%%%--------------------------------------
%%% @Module  : lib_rune
%%% @Author  : huyihao
%%% @Created : 2017.11.7
%%% @Description:  符文
%%%--------------------------------------

-module(lib_rune).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("rec_offline.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("rune.hrl").
-include("figure.hrl").


-compile(export_all).
%%-export([
%%	rune_login/2,
%%	count_rune_attribute/1,
%%	count_one_rune_attr/3,
%%	check_list/2,
%%	sql_rune/2,
%%	rune_wear/4,
%%	rune_level_up/5,
%%	get_rune_compose_level/2,
%%	add_rune_point/2,
%%	add_rune_chip/2,
%%	get_goods_rune_point/1,
%%	get_equip_att_ratio/2,
%%	send_new_rune_info/1,
%%	get_compose_Lv/2,
%%	get_decompose_exp/1,
%%	cal_attr_rating/1,
%%	get_all_rune_point/1,
%%	get_exp_ratio/1,
%%	is_attr_conflict/3,
%%	get_power/1
%%	,update_power/1
%%	,awake/4
%%]).

send_rune_info(Player) ->
    #player_status{ id = RoleId, original_attr = OriginalAttr, figure = #figure{ lv = _RoleLv } } = Player,
    #goods_status{ dict = Dict, rune = Rune } = lib_goods_do:get_goods_status(),
    RuneList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict),
    #rune{
        rune_point = RunePoint,     %% 符文经验
        rune_chip = RuneChip,       %% 符文碎片
        skill_lv = SkillLv,
        skill = SkillList
    } = Rune,
    PosList = data_rune:get_rune_pos_list(),
    Fun = fun(PosId) ->
        RunePosCon = data_rune:get_rune_pos_con(PosId),
        ConditionList = RunePosCon#rune_pos_con.condition,
        IsOpen = ?IF(lib_rune:check_list(ConditionList, Player), 1, 0),
        GoodsInfo = lists:keyfind(PosId, #goods.cell, RuneList),
        case IsOpen == 0 orelse GoodsInfo == false of
            true ->
                {PosId, IsOpen, 0, 0, 0, 0, []};
            false ->
                #goods{
                    id = GoodsId,
                    goods_id = GoodsTypeId,
                    subtype = _SubType,
                    color = _Color,
                    level = Level,
                    other = Other
                } = GoodsInfo,
                case data_goods_type:get(GoodsTypeId) of
                    #ets_goods_type{subtype = SubType, color = Color} ->
                        ok;
                    _ ->
                        SubType = _SubType,
                        Color = _Color
                end,
                #goods_other{optional_data = OptionalData} = Other,
                %%属性读配置
                _AttrList = lib_rune:count_one_rune_attr(SubType, Color, Level),
                F = fun({AttrId, Value}, AccList) ->
                    %% 查看该子类型的符文是否存在技能战力加成
                    case data_rune:get_wear_rune_skill(SubType) of
                        #wear_rune_skill{skill_id = SkillId} ->
                            SubTypeList = data_rune:get_all_sub_type(),
                            case lists:member(SubType, SubTypeList) of
                                true ->
                                    case lists:keyfind(SkillId, 1, SkillList) of
                                        {SkillId, AwakeSkillLevel} ->
                                            SkillPower = lib_skill_api:get_skill_power([{SkillId, AwakeSkillLevel}]),
                                            NextSkillPower = lib_skill_api:get_skill_power([{SkillId, AwakeSkillLevel + 1}]),
                                            NoNextSkill = NextSkillPower =< SkillPower;
                                        _ ->
                                            SkillPower = 0, NoNextSkill = false,
                                            NextSkillPower = lib_skill_api:get_skill_power([{SkillId, 1}])
                                    end;
                                _ ->
                                    SkillPower = 0, NextSkillPower = 0, NoNextSkill = false
                            end;
                        _ ->
                            SkillPower = 0, NextSkillPower = 0, NoNextSkill = false
                    end,
                    case lists:keyfind(AttrId, 1, OptionalData) of
                        {_, AwakeLv, AwakeExp} ->
                            % 计算当前的觉醒战力加成与下一级的觉醒战力加成
                            CurAwakeAttr = get_one_awake_attr_list(AttrId, AwakeLv, Color),
                            CurAwakePower = lib_player:calc_partial_power(Player, OriginalAttr, SkillPower, CurAwakeAttr),
                            NextAwakeAttrL = get_one_awake_attr_list(AttrId, AwakeLv + 1, Color),
                            case NextAwakeAttrL == [] orelse NoNextSkill of
                                true ->
                                    NextAwakePower = 0;
                                _ ->
                                    NextAwakePower = lib_player:calc_expact_power(Player, OriginalAttr, NextSkillPower, NextAwakeAttrL)
                            end,
                            [{AttrId, Value, AwakeLv, AwakeExp, NextAwakePower, CurAwakePower} | AccList];
                        _ ->
                            % 计算当前的觉醒战力加成与下一级的觉醒战力加成
                            CurAwakeAttr = get_one_awake_attr_list(AttrId, 0, Color),
                            CurAwakePower = lib_player:calc_partial_power(Player, OriginalAttr, SkillPower, CurAwakeAttr),
                            NextAwakeAttrL = get_one_awake_attr_list(AttrId, 1, Color),
                            case NextAwakeAttrL == [] orelse NoNextSkill of
                                true ->
                                    NextAwakePower = 0;
                                _ ->
                                    NextAwakePower = lib_player:calc_expact_power(Player, OriginalAttr, NextSkillPower, NextAwakeAttrL)
                            end,
                            [{AttrId, Value, 0, 0, NextAwakePower, CurAwakePower} | AccList]
                    end
                end,
                AttrList = lists:reverse(lists:foldl(F, [], _AttrList)),
                {PosId, IsOpen, GoodsId, GoodsTypeId, Color, Level, AttrList}
        end
    end,
    SendList = lists:map(Fun, PosList),
    RunePower = get_power2(Player),
    {ok, Bin} = pt_167:write(16700, [RunePoint, RuneChip, SkillLv, SendList, RunePower]),
    lib_server_send:send_to_uid(RoleId, Bin).

rune_login(RoleId, GoodsDict) ->
    ReSql = io_lib:format(?SelectRuneSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            #rune{};
        [[_RoleId, RunePoint, RuneChip, SkillLv, _] | _] ->
            %% 超过警戒值，开进程自动分解
            GoodsNum = length(lib_rune:get_can_decompose_rune_goods(RoleId, GoodsDict)),
            % ?INFO("GoodsNum:~p~n", [GoodsNum]),
            case GoodsNum >= ?RUNE_LIMIT_2 of
                true ->
                    RolePid = misc:get_player_process(RoleId),
                    start_rune_auto_decompose_timer(RolePid);
                false -> skip
            end,
            RuneEquipAttList = get_equip_att_ratio(RoleId, GoodsDict),
            AwakeSkillList = init_rune_awake_skill(RoleId, GoodsDict),
            SkillAttr = lib_skill:get_passive_skill_attr(AwakeSkillList),
            #rune{
                rune_point = RunePoint,
                rune_chip = RuneChip,
                equip_add_ratio_attr = RuneEquipAttList,
                skill_lv = SkillLv,
                skill = AwakeSkillList,
                skill_attr = SkillAttr
            }
    end.

%% 初始化穿戴符文的技能
init_rune_awake_skill(RoleId, GoodsDict) ->
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),
    SubTypeList = data_rune:get_all_sub_type(),
    F = fun(GoodsInfo, SkillS) ->
        #goods{subtype = SubType} = GoodsInfo,
        case lists:member(SubType, SubTypeList) of
            true ->
                AwakeList = lib_rune:get_awake_lv_list(GoodsInfo),
                #wear_rune_skill{skill_id = SkillId, attr_id = AttrId} = data_rune:get_wear_rune_skill(SubType),
                {AttrId, AwakeLV, _AwakeExp} = ulists:keyfind(AttrId, 1 , AwakeList, {AttrId, 0, 0}),
                lists:keystore(SkillId, 1, SkillS, {SkillId, AwakeLV + 1});
            _ ->
                SkillS
        end end,
    AwakeSkillList = lists:foldl(F, [], RuneWearList),
    AwakeSkillList.

start_rune_auto_decompose_timer(RolePid) ->
    case misc:is_process_alive(RolePid) of
        false ->
            skip;
        _ ->
            case get(rune_decompose) of
                undefined ->
                    NewPid = spawn(fun() -> timer:sleep(1000), RolePid ! {'rune_auto_decompose'} end),
                    put(rune_decompose, NewPid);
                Pid ->
                    case is_process_alive(Pid) of
                        false ->
                            NewPid = spawn(fun() -> timer:sleep(1000), RolePid ! {'rune_auto_decompose'} end),
                            put(rune_decompose, NewPid);
                        true ->
                            skip
                    end
            end
    end.


check_list([T | G], Ps) ->
    case check(T, Ps) of
        true ->
            check_list(G, Ps);
        false ->
            false
    end;
check_list([], _Ps) ->
    true.

check({rune_tower, Num}, Ps) ->
    % #player_status{dun_rune_level_unlock = TowerNum} = Ps,
    TowerNum = lib_dungeon_rune:get_dungeon_level(Ps),  %%获得爬塔层数
    TowerNum >= Num;

check(_, _Ps) ->
    true.

%% 计算穿在身上的符文总属性
count_rune_attribute(RuneWearList) ->
    F = fun(Rune, TotalAttr1) ->
        #goods{
            color = Color,
            subtype = SubType,
            level = Level
            , other = Other
        } = Rune,
        ExtraAttr = count_one_rune_attr(SubType, Color, Level),  %%数量不多，改为实时计算。
        AwakeAttr = get_awake_attr(Other, Color),
        Attr1 = ulists:kv_list_plus_extra([ExtraAttr, AwakeAttr]),
        ulists:kv_list_plus_extra([TotalAttr1, Attr1])
        end,
    TotalAttr = lists:foldl(F, [], RuneWearList),
    TotalAttr.

%% 计算单个符文属性
count_one_rune_attr(SubType, Color, Level) ->
    RuneAttrNumCon = data_rune:get_rune_attr_num_con(SubType, Level),  %%属性列表
    RuneAttrCoefficientCon = data_rune:get_rune_attr_coefficient_con(SubType, Color),
    if
        RuneAttrNumCon =:= [] ->
            [];
        RuneAttrCoefficientCon =:= [] ->
            [];
        true ->
            AttrNumList = RuneAttrNumCon#rune_attr_num_con.attr_num_list,
            AttrCoefficietList = RuneAttrCoefficientCon#rune_attr_coefficient_con.attr_coefficient_list,
            F = fun({AttrId, AttrNum}, ExtraAttr1) ->
                case lists:keyfind(AttrId, 1, AttrCoefficietList) of
                    false ->
                        ExtraAttr1;
                    {_AttrId, Coefficient} ->
                        AttrInfo = {AttrId, round(AttrNum * Coefficient / 1000)},
                        [AttrInfo | ExtraAttr1]
                end
                end,
            ExtraAttr = lists:foldl(F, [], AttrNumList),
            ExtraAttr
    end.

%% 同步数据库
sql_rune(Rune, RoleId) ->
    #rune{
        rune_point = RunePoint,     %% 符文经验
        rune_chip = RuneChip        %% 符文碎片
        , skill_lv = SkillLv
    } = Rune,
    ReSql = io_lib:format(?ReplaceRuneSql, [RoleId, RunePoint, RuneChip, SkillLv]),
    db:execute(ReSql).

%% 镶嵌符文
rune_wear(Ps, GS, GoodsInfo, PosId) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),  %%为什么要start
        do_rune_wear(Ps, GS, GoodsInfo, PosId)
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsId, OldGoodsId, NewGoodsTypeId, GoodsL, NewGS, NewPs1, OldGoodsInfo, NewGoodsInfo} ->
            lib_goods_do:set_goods_status(NewGS),  %%重新设置goods_status
            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),  %%由于符文属性影响，重新计算人物属性
            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),     %%主动推送信息
            lib_common_rank_api:refresh_rank_by_rune(NewPs),
            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL), %%告诉客户端更新物品信息
            %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
            lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [GoodsInfo#goods{num = 0}]),  %%就是原来的位置的符文数量为0
            %%旧符文 通知客户端删除
            case OldGoodsInfo of
                [] ->  %%没有旧符文
                    ok;
                _ ->
                    lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [OldGoodsInfo#goods{num = 0}])
            end,
            {true, ?SUCCESS, NewGoodsId, OldGoodsId, NewGoodsTypeId, NewPs, NewGoodsInfo};
        Error ->
            ?ERR("rune error:~p", [Error]),
            {false, ?FAIL, Ps}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  镶嵌符文
%% @param    参数      Ps::#player_status{},
%%                    GS::goods_status{}
%%                    GoodsInfo::#goods{},
%%                    PosId::integer 孔位
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_rune_wear(Ps, GS, GoodsInfo, PosId) ->
    #player_status{
        id = RoleId,
        goods = StatusGoods
    } = Ps,
    #goods{
        location = OriginalLocation,
        cell = OriginalCell,
        subtype = SubType
    } = GoodsInfo,
    ?PRINT("do rune wear ~p~n", [{OriginalLocation, OriginalCell}]),
    #goods_status{
        dict = Dict,
        rune = Rune
    } = GS,
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_RUNE, PosId, Dict),  %%旧符文
    case is_record(OldGoodsInfo, goods) of
        true ->  %%存在旧符文
            [NewOldGoodsInfo, GS1] = lib_goods:change_goods_cell_and_use(OldGoodsInfo, OriginalLocation, OriginalCell, GS),  %%卸下
            [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_RUNE, PosId, GS1),  %%镶嵌
            OldGoodsId = NewOldGoodsInfo#goods.id;
        false -> %%不存在旧符文
            OldGoodsId = 0,
            [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_RUNE, PosId, GS)  %%镶嵌
    end,
    #goods_status{
        dict = OldGoodsDict
    } = NewGS1,
    {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),   %%做了一些操作，要更新dict
    RuneEquipAttList = get_equip_att_ratio(RoleId, NewGoodsDict),   %%计算符文对装备加成的百分比属性列表

    %% 查看该子类型的符文是否会修改技能
    SubTypeList = data_rune:get_all_sub_type(),
    case lists:member(SubType, SubTypeList) of
        true ->
            AwakeList = lib_rune:get_awake_lv_list(GoodsInfo),
            #wear_rune_skill{skill_id = SkillId, attr_id = AttrId} = data_rune:get_wear_rune_skill(SubType),
            {AttrId, AwakeLV, _AwakeExp} = ulists:keyfind(AttrId, 1 , AwakeList, {AttrId, 0, 0}),
            NewRuneSkill = lists:keystore(SkillId, 1, Rune#rune.skill, {SkillId, AwakeLV + 1});
        _ ->
            NewRuneSkill = Rune#rune.skill
    end,

    SkillAttr = lib_skill:get_passive_skill_attr(NewRuneSkill),
    NewRune = Rune#rune{                                            %%更新
        equip_add_ratio_attr = RuneEquipAttList                     %%这个字段不知道用来干嘛的
        , skill = NewRuneSkill
        , skill_attr = SkillAttr
    },
    NewGS = NewGS1#goods_status{                                    %%更新goods_status
        dict = NewGoodsDict,
        %null_cells = NewNullCells,
        rune = NewRune
    },
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, NewGoodsDict),  %%获得镶嵌中的符文列表
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),    %%总属性
    NewStatusGoods = StatusGoods#status_goods{
        rune_attr = RuneAttr                                   %%符文属性
    },
    NewPs = Ps#player_status{
        goods = NewStatusGoods
    },
    F = fun(TRune, {Acc, TemAcc}) ->
        #goods{level = Level, color = Color} = TRune,
        NewAcc = case lists:keyfind(Level, 1, Acc) of
                     {Level, Num} -> lists:keystore(Level, 1, Acc, {Level, Num + 1});
                     _ -> lists:keystore(Level, 1, Acc, {Level, 1})
                 end,
        NewTemAcc = case lists:keyfind(Color, 1, TemAcc) of
                        {Color, Nums} -> lists:keystore(Color, 1, TemAcc, {Color, Nums + 1});
                        _ -> lists:keystore(Color, 1, TemAcc, {Color, 1})
                    end,
        {NewAcc, NewTemAcc}
        end,
    {AchivList, AchivList1} = lists:foldl(F, {[], []}, RuneWearList),
    lib_achievement_api:async_event(RoleId, lib_achievement_api, rune_equip_event, {AchivList, AchivList1}),
    #goods{
        id = NewGoodsId,
        goods_id = NewGoodsTypeId,
        color = Color,
        level = Lv
    } = NewGoodsInfo,
    lib_log_api:log_rune_wear(RoleId, PosId, NewGoodsTypeId, Color, Lv),
    %%   新符文物品id, 旧符文id,   新符文物品类型id,物品更新列表 新GS   新PS,   旧符文物品Info
    {ok, NewGoodsId, OldGoodsId, NewGoodsTypeId, GoodsL, NewGS, NewPs, OldGoodsInfo, NewGoodsInfo}.  %%OldGoodsInfo 也返回，用于通知客户端。

%% 卸下符文
rune_unwear(Ps, GS, GoodsInfo, PosId) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_rune_unwear(Ps, GS, GoodsInfo, PosId)
    end,
    case lib_goods_util:transaction(F) of
        {ok, GoodsL, NewGS, NewPs1, UnWearGoodsInfo, UnwearGoodsId} ->
            lib_goods_do:set_goods_status(NewGS),
            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
            lib_common_rank_api:refresh_rank_by_rune(NewPs),
            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
            lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [GoodsInfo#goods{num = 0}]),
            {true, ?SUCCESS, UnWearGoodsInfo, UnwearGoodsId, NewPs};
        Error ->
            ?ERR("rune unwear error:~p~n", [Error]),
            {false, ?FAIL, Ps}
    end.

do_rune_unwear(Ps, GS, GoodsInfo, _PosId) ->
    #player_status{
        id = RoleId,
        goods = StatusGoods
    } = Ps,
    #goods{
        subtype = SubType
    } = GoodsInfo,
    #goods_status{
        dict = _Dict,
        rune = Rune
    } = GS,

    % 把符文移回符文背包
    UnwearGoodsId = GoodsInfo#goods.id,
    [UnwearGoodsInfo, NewGS1] = lib_goods:change_goods_cell_and_use(GoodsInfo, ?GOODS_LOC_RUNE_BAG, 0, GS),
    #goods_status{
        dict = OldGoodsDict
    } = NewGS1,
    {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),

    % 更新符文信息
    RuneEquipAttList = get_equip_att_ratio(RoleId, NewGoodsDict),
    SubTypeList = data_rune:get_all_sub_type(),
    case lists:member(SubType, SubTypeList) of
        true ->
            #wear_rune_skill{skill_id = SkillId} = data_rune:get_wear_rune_skill(SubType),
            NewRuneSkill = lists:keydelete(SkillId, 1, Rune#rune.skill);
        _ ->
            NewRuneSkill = Rune#rune.skill
    end,
    SkillAttr = lib_skill:get_passive_skill_attr(NewRuneSkill),
    NewRune = Rune#rune{
        equip_add_ratio_attr = RuneEquipAttList
        ,skill = NewRuneSkill
        ,skill_attr = SkillAttr
    },

    % 更新物品信息
    NewGS = NewGS1#goods_status{
        dict = NewGoodsDict,
        rune = NewRune
    },
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, NewGoodsDict),
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),
    NewStatusGoods = StatusGoods#status_goods{
        rune_attr = RuneAttr
    },
    NewPs = Ps#player_status{
        goods = NewStatusGoods
    },

    {ok, GoodsL, NewGS, NewPs, UnwearGoodsInfo, UnwearGoodsId}.


%% -----------------------------------------------------------------
%% @desc     功能描述  计算符文对装备加成的百分比属性列表
%% @param    参数
%% @return   返回值   [{attrId, attrNum}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_equip_att_ratio(RoleId, GoodsDict) ->
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),
    F = fun({AttrId, AttrNum}, RuneEquipAttList1) ->
        case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE) of
            false ->
                RuneEquipAttList1;
            true ->
                case lists:keyfind(AttrId, 1, RuneEquipAttList1) of
                    false ->
                        [{AttrId, AttrNum} | RuneEquipAttList1];
                    {_AttrId, OldAttrNum} ->
                        lists:keyreplace(AttrId, 1, RuneEquipAttList1, {AttrId, OldAttrNum + AttrNum})
                end
        end
        end,
    RuneEquipAttList = lists:foldl(F, [], RuneAttr),
    RuneEquipAttList.

rune_level_up(Ps, GS, GoodsInfo, NewRune, NeedRunePoint) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_rune_level_up(Ps, GS, GoodsInfo, NewRune, NeedRunePoint)
        end,
    case lib_goods_util:transaction(F) of
        {ok, Location, GoodsL, NewGS, NewPs1} ->
            lib_goods_do:set_goods_status(NewGS),
            case Location of
                ?GOODS_LOC_RUNE ->
                    #goods_status{dict = Dict} = NewGS,
                    RuneWearList = lib_goods_util:get_goods_list(Ps#player_status.id, ?GOODS_LOC_RUNE, Dict),
                    F1 = fun(TRune, {Acc, TemAcc}) ->
                        #goods{level = Level, color = Color} = TRune,
                        NewAcc = case lists:keyfind(Level, 1, Acc) of
                                     {Level, Num} -> lists:keystore(Level, 1, Acc, {Level, Num + 1});
                                     _ -> lists:keystore(Level, 1, Acc, {Level, 1})
                                 end,
                        NewTemAcc = case lists:keyfind(Color, 1, TemAcc) of
                                        {Color, Nums} -> lists:keystore(Color, 1, TemAcc, {Color, Nums + 1});
                                        _ -> lists:keystore(Color, 1, TemAcc, {Color, 1})
                                    end,
                        {NewAcc, NewTemAcc}
                    end,
                    {AchivList, AchivList1} = lists:foldl(F1, {[], []}, RuneWearList),
                    lib_achievement_api:async_event(Ps#player_status.id, lib_achievement_api, rune_equip_event, {AchivList, AchivList1}),
                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR);   %%通知玩家属性改变
                _ ->
                    NewPs = NewPs1
            end,
            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),       %%通知客户端更新列表
            {true, ?SUCCESS, NewPs};
        Error ->
            ?ERR("rune error:~p", [Error]),
            {false, ?FAIL, Ps}
    end.

do_rune_level_up(Ps, GS, GoodsInfo, NewRune1, NeedRunePoint) ->
    #player_status{
        id = RoleId,
        goods = StatusGoods
    } = Ps,
    #goods{
        goods_id = GoodsTypeId,
        subtype = SubType,
        color = Color,
        level = Level,
        location = Location
    } = GoodsInfo,
    NewLevel = Level + 1,
    _ExtraAttr = lib_rune:count_one_rune_attr(SubType, Color, NewLevel),
    [_NewGoodsInfo, NewGS1] = lib_goods:change_goods_level_extra_attr(GoodsInfo, Location, NewLevel, [], GS), %%不需要储存属性
    #goods_status{
        dict = OldGoodsDict
    } = NewGS1,
    {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),    %%更新操作
    RuneEquipAttList = get_equip_att_ratio(RoleId, NewGoodsDict),    %%对装备的百分比属性
    NewRune = NewRune1#rune{
        equip_add_ratio_attr = RuneEquipAttList
    },
    lib_rune:sql_rune(NewRune, RoleId),
    NewGS = NewGS1#goods_status{
        dict = NewGoodsDict,
        rune = NewRune
    },
    case Location of
        ?GOODS_LOC_RUNE ->
            RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, NewGoodsDict),
            RuneAttr = lib_rune:count_rune_attribute(RuneWearList),
            NewStatusGoods = StatusGoods#status_goods{
                rune_attr = RuneAttr               %%更新属性
            },
            NewPs = Ps#player_status{
                goods = NewStatusGoods
            };
        _ ->
            NewPs = Ps
    end,
    lib_log_api:log_rune_level_up(RoleId, GoodsTypeId, Level, NewLevel, NeedRunePoint),
    {ok, Location, GoodsL, NewGS, NewPs}.

%% -----------------------------------------------------------------
%% @desc     功能描述    获取合成后的符文等级
%% @param    参数        ComposeGoodsCon::#ets_goods_type{},
%%                       UpdateGoodsList::[{Type, Goods_id, num}] 合成消耗的物品
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_rune_compose_level(ComposeGoodsCon, UpdateGoodsList) ->
%%	?DEBUG("compose:~p~n", [UpdateGoodsList]),
    #ets_goods_type{
        goods_id = NewGoodsTypeId,
        subtype = SubType,
        color = Color
    } = ComposeGoodsCon,
    F = fun(GoodsInfo, {TotalRunePoint1, LogGoodsList1, AccAwakeAttrList}) ->
        #goods{
            goods_id = GoodsTypeId,
            type = Type,
            level = Level1,
            other = Other
        } = GoodsInfo,
        case Type of
            ?GOODS_TYPE_RUNE ->
                RunePoint1 = get_goods_rune_point(GoodsInfo),  %%获取这个符文的经验
                {TotalRunePoint1 + RunePoint1, [{GoodsTypeId, Level1} | LogGoodsList1], Other#goods_other.optional_data ++ AccAwakeAttrList};
            _ ->
                {TotalRunePoint1, LogGoodsList1, AccAwakeAttrList}
        end
        end,
    %%获取消耗符文所有经验和消耗符文的等级和类型 {GoodTypeId,Level}
    {TotalRunePoint, LogGoodsList, AwakeAttrList} = lists:foldl(F, {0, [], []}, UpdateGoodsList),
    RuneAllLvList = data_rune:get_rune_all_lv(SubType),  %%获取这个子类型的所有符文等级
    {Level, LessRunePoint} = level_up_by_point(SubType, Color, TotalRunePoint, 1, length(RuneAllLvList)),
    GS = lib_goods_do:get_goods_status(),
    NewGS = add_rune_point(LessRunePoint, GS),   %%多余的符文经验还会加上给玩家，
    lib_goods_do:set_goods_status(NewGS),        %%这里GS改了，确定不用返回？.....确实不用放回，Ps是不存这个数据的，直接放在进程字典中
    lib_log_api:log_rune_compose(NewGS#goods_status.player_id, LogGoodsList, NewGoodsTypeId, Level, GS#goods_status.rune#rune.rune_point, NewGS#goods_status.rune#rune.rune_point),
    {Level, AwakeAttrList}.

%% -----------------------------------------------------------------
%% @desc     功能描述   根据经验获取能够升级的最高等级。
%% @param    参数
%%                      SubType::integer 子类型
%%                      Color::integer 品质
%%                      TotalRunePoint::integer  符文经验
%%                      Level::integer 当前等级
%%                      MaxLevel::integer  最大等级
%% @return   返回值     {Level, TotalRunePoint}    {能升级的最大等级, 升级后剩下的符文经验}
%% @history  修改历史
%% -----------------------------------------------------------------
level_up_by_point(_SubType, _Color, TotalRunePoint, MaxLevel, MaxLevel) ->
    {MaxLevel, TotalRunePoint};
level_up_by_point(SubType, Color, TotalRunePoint, Level, MaxLevel) ->
    NewLevel = Level + 1,
    RuneAttrNumCon = data_rune:get_rune_attr_num_con(SubType, NewLevel),
    RuneAttrCoefficientCon = data_rune:get_rune_attr_coefficient_con(SubType, Color),
    case RuneAttrNumCon =:= [] orelse RuneAttrCoefficientCon =:= [] of
        true ->
            {Level, TotalRunePoint};
        false ->
            RuneNum = RuneAttrNumCon#rune_attr_num_con.lv_up_num,  %%升级基础经验
            RuneCoefficient = RuneAttrCoefficientCon#rune_attr_coefficient_con.lv_up_coefficient,  %%升级系数
            RunePoint1 = round(RuneNum * RuneCoefficient / 1000),
            case TotalRunePoint >= RunePoint1 andalso RunePoint1 > 0 of
                true ->
                    level_up_by_point(SubType, Color, TotalRunePoint - RunePoint1, NewLevel, MaxLevel);
                false ->
                    {Level, TotalRunePoint}
            end
    end.


%%获取分解符文
get_goods_rune_point(GoodsInfo) ->
    #goods{
        subtype = SubType,
        color = Color,
        level = Level
    } = GoodsInfo,
    get_goods_rune_point_1(SubType, Color, Level, 0).

get_goods_rune_point_1(_SubType, _Color, 1, RunePoint) ->
    %%分解后的经验受系数影响
    DecomposeParam = case data_key_value:get(?decompose_key) of
                         undefined ->
                             1;
                         P ->
                             P
                     end,
    %%升级所需经验系数
    erlang:round(RunePoint * DecomposeParam);
get_goods_rune_point_1(SubType, Color, Level, RunePoint) ->
    case data_rune:get_rune_attr_num_con(SubType, Level) of
        #rune_attr_num_con{lv_up_num = RuneNum} ->
            RuneAttrCoefficientCon = data_rune:get_rune_attr_coefficient_con(SubType, Color),
%%			RuneNum = RuneAttrNumCon#rune_attr_num_con.lv_up_num,
            RuneCoefficient = RuneAttrCoefficientCon#rune_attr_coefficient_con.lv_up_coefficient,
            RunePoint1 = round(RuneNum * RuneCoefficient / 1000),
            get_goods_rune_point_1(SubType, Color, Level - 1, RunePoint + RunePoint1);
        _ ->
%%			?MYLOG("cym", "+9++++   ~p ~n", [{SubType, Color, Level - 1, RunePoint}]),
            get_goods_rune_point_1(SubType, Color, Level - 1, RunePoint)
    end.



%% -----------------------------------------------------------------
%% @desc     功能描述  增加符文经验
%% @param    参数     Num::integer  符文经验数量
%%                    GS::goods_status{}
%% @return   返回值    NewGS::goods_status{}
%% @history  修改历史
%% -----------------------------------------------------------------
add_rune_point(Num, GS) ->
    #goods_status{
        player_id = RoleId,
        rune = Rune
    } = GS,
    #rune{
        rune_point = RunePoint
    } = Rune,
    NewRune = Rune#rune{
        rune_point = RunePoint + Num
    },
%%	?DEBUG("OldPoint:~p, AddPoint:~p", [RunePoint, Num]),
    lib_rune:sql_rune(NewRune, RoleId),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_rune, send_new_rune_info, []),
    GS#goods_status{
        rune = NewRune
    }.
%% -----------------------------------------------------------------
%% @desc     功能描述  增加符文碎片
%% @param    参数     Num::integer  符文碎片数量
%%                    GS::goods_status{}
%% @return   返回值    NewGS::goods_status{}
%% @history  修改历史
%% -----------------------------------------------------------------
add_rune_chip(Num, GS) ->
    #goods_status{
        player_id = RoleId,
        rune = Rune
    } = GS,
    #rune{
        rune_chip = RuneChip
    } = Rune,
    NewRune = Rune#rune{
        rune_chip = RuneChip + Num
    },
    lib_rune:sql_rune(NewRune, RoleId),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_rune, send_new_rune_info, []),
    GS#goods_status{
        rune = NewRune
    }.
%% -----------------------------------------------------------------
%% @desc     功能描述  符文合成预览
%% @param    参数      RuleId::integer  规则Id ,
%%                     GoodIdList::lists [{goood_id}] 物品id列表
%% @return   返回值     {ok, Lv} | {false, Res}
%% @history  修改历史
%% -----------------------------------------------------------------
get_compose_Lv(RuleId, GoodIdList) ->
    case lib_rune_check:get_compose_lv(RuleId, GoodIdList) of
        true ->
            UpdateGoodsList = [lib_goods_api:get_goods_info(GoodId) || GoodId <- GoodIdList],
            #goods_compose_cfg{goods = Goods} = data_goods_compose:get_cfg(RuleId),  %%check   已经检查了，必定是这个record
            if
                Goods == [] ->
                    {false, ?MISSING_CONFIG};
                true ->
                    [{_Type, GId, _Num} | _] = Goods,
                    case data_goods_type:get(GId) of
                        [] ->
                            {false, ?MISSING_CONFIG};
                        GoodsType ->
                            Lv = get_rune_compose_level_for_preview(GoodsType, UpdateGoodsList),
                            {ok, Lv}
                    end
            end;
        {false, Res} ->
            {false, Res}
    end.


%% -----------------------------------------------------------------
%% @desc     功能描述  符文分解预览,获取分解后的总经验
%% @param    参数
%%                     GoodIdList::lists [{goood_id}] 物品id列表
%% @return   返回值     {ok, Exp,ResList} | {false, Res}
%% @history  修改历史
%% -----------------------------------------------------------------
get_decompose_exp(GoodIdList) ->
    case lib_rune_check:get_decompose_exp(GoodIdList) of
        true ->
            GoodsList = [lib_goods_api:get_goods_info(GoodId) || GoodId <- GoodIdList],
            F = fun(GoodInfo, {AccExp, AccResList}) ->
                #goods{goods_id = GTypeId} = GoodInfo,
                #goods_decompose_cfg{regular_mat = RegularMat} = data_goods_decompose:get(GTypeId),  %%必定有，检查过了
                {RegularExp, TempResList} = case RegularMat of
                                                [] ->
                                                    0;
                                                RegularMat ->
                                                    {_RegularExp, _TempResList} = get_regular_mat(RegularMat)
                                            end,
                TempExp = get_goods_rune_point(GoodInfo) + RegularExp,
                {AccExp + TempExp, AccResList ++ TempResList}
                end,
%%			?DEBUG("GoodsList:~p~n", [GoodsList]),
            {Exp, ResList} = lists:foldl(F, {0, []}, GoodsList),
            ComposeResList = ulists:object_list_plus([ResList, []]),
            {ok, Exp, ComposeResList};
        {false, Res} ->
            {false, Res}
    end.


send_new_rune_info(Ps) ->
    pp_rune:handle(16700, Ps, []).



get_rune_compose_level_for_preview(ComposeGoodsCon, UpdateGoodsList) ->
    #ets_goods_type{
        goods_id = _NewGoodsTypeId,
        subtype = SubType,
        color = Color
    } = ComposeGoodsCon,
    F = fun(GoodsInfo, {TotalRunePoint1, LogGoodsList1}) ->
        #goods{
            goods_id = GoodsTypeId,
            type = Type,
            level = Level1
        } = GoodsInfo,
        case Type of
            ?GOODS_TYPE_RUNE ->
                RunePoint1 = get_goods_rune_point(GoodsInfo),  %%获取这个符文的经验
                {TotalRunePoint1 + RunePoint1, [{GoodsTypeId, Level1} | LogGoodsList1]};
            _ ->
                {TotalRunePoint1, LogGoodsList1}
        end
        end,
    %%获取消耗符文所有经验和消耗符文的等级和类型 {GoodTypeId,Level}
    {TotalRunePoint, _LogGoodsList} = lists:foldl(F, {0, []}, UpdateGoodsList),
    RuneAllLvList = data_rune:get_rune_all_lv(SubType),  %%获取这个子类型的所有符文等级
    {Level, _LessRunePoint} = level_up_by_point(SubType, Color, TotalRunePoint, 1, length(RuneAllLvList)),
    Level.

%% -----------------------------------------------------------------
%% @desc     功能描述   将固定分解的奖励分类，分为经验和一般道具
%% @param    参数       RegularMat::lists     [Type,GoodsTypeId, num]
%% @return   返回值     {Exp, ResList}         {经验， 物品}
%% @history  修改历史
%% -----------------------------------------------------------------
get_regular_mat(RegularMat) ->
    get_regular_mat(RegularMat, {0, []}).

get_regular_mat([], {Exp, ResList}) ->
    {Exp, ResList};
get_regular_mat([{Type, GoodsTypeId, Num} | T], {Exp, ResList}) ->
    case Type of
        ?TYPE_RUNE ->
            get_regular_mat(T, {Exp + Num, ResList});
        _ ->
            get_regular_mat(T, {Exp, [{Type, GoodsTypeId, Num} | ResList]})
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述   获取总符文评分， 需要在玩家进程中调用
%% @param    参数       Ps::#player_status{}
%% @return   返回值     Power::integer  总战力
%% @history  修改历史
%% -----------------------------------------------------------------
get_all_rune_point(#player_status{id = RoleId} = _Ps) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GS,
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),  %%获得镶嵌中的符文列表
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),    %%总属性
    Point = cal_attr_rating(RuneAttr),
    Point.



%% -----------------------------------------------------------------
%% @desc     功能描述     计算符文属性评分
%% @param    参数         AttrList::lists    eg.[{3,50}]
%% @return   返回值       Rating::integer
%% @history  修改历史
%% -----------------------------------------------------------------
cal_attr_rating([]) -> 0;
cal_attr_rating(AttrList) ->
    F = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1), %%默认一阶
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 1), %%默认一阶
                RatingTmp + OneAttrRating * OneAttrVal;
            _ -> RatingTmp
        end
        end,
    Rating = lists:foldl(F, 0, AttrList),
    round(Rating).



get_exp_ratio(#player_status{goods = StatusGoods}) ->
    #status_goods{rune_attr = RuneAttr} = StatusGoods,
    case lists:keyfind(?EXP_ADD, 1, RuneAttr) of
        {_, ExpRatio} ->
            ExpRatio;
        _ ->
            0
    end.
%% -----------------------------------------------------------------
%% @desc     功能描述 符文属性有无冲突
%% @param    参数
%% @return   返回值  true | false
%% @history  修改历史
%% -----------------------------------------------------------------
is_attr_conflict(GoodsInfo, PosId, RuneWearList) ->
    List = [SubType || #goods{cell = Cell, goods_id = _WearGoodId, subtype = SubType} <- RuneWearList, Cell =/= PosId],
    F = fun(TempSubType, AccAttrList) ->
        case data_rune:get_rune_attr_num_con(TempSubType, 1) of
            #rune_attr_num_con{attr_num_list = Attr} ->
                IdList = get_attr_id_list(Attr),
                IdList ++ AccAttrList;
            _ ->
                AccAttrList
        end
        end,
    WearAttrIdList = lists:foldl(F, [], List),
    NewAttrIdList =
        case data_rune:get_rune_attr_num_con(GoodsInfo#goods.subtype, 1) of
            #rune_attr_num_con{attr_num_list = Attr} ->
                IdList = get_attr_id_list(Attr),
                IdList;
            _ ->
                []
        end,
    Res = WearAttrIdList -- (WearAttrIdList -- NewAttrIdList),
    if
        Res == [] ->  %%无交集
            false;
        true ->       %%属性有交集
            true
    end.


%%获取属性Id列表
get_attr_id_list(Attr) ->
    get_attr_id_list(Attr, []).

get_attr_id_list([], AccList) ->
    AccList;
get_attr_id_list([{OneAttrId, _OneAttrVal} | Attr], AccList) ->
    get_attr_id_list(Attr, [OneAttrId | AccList]);
get_attr_id_list([{_Color, OneAttrId, _OneAttrVal} | Attr], AccList) ->
    get_attr_id_list(Attr, [OneAttrId | AccList]);
get_attr_id_list([{_Color, OneAttrId, _OneAttrBaseVal, _OneAttrPlusInterval, _OneAttrPlus} | Attr], AccList) ->
    get_attr_id_list(Attr, [OneAttrId | AccList]).


get_power(PS) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{rune = Rune} = GS,
    #rune{power = Power} = Rune,
    if
        Power == 0 ->
            RunePower = get_power2(PS),
            NewRune = Rune#rune{power = RunePower},
            NewGS = GS#goods_status{rune = NewRune},
            lib_goods_do:set_goods_status(NewGS),
            RunePower;
        true ->
            Power
    end.

get_power2(PS) ->
    #player_status{id = PlayerId} = PS,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict, rune = Rune} = GS,
    RuneWearList = lib_goods_util:get_goods_list(PS#player_status.id, ?GOODS_LOC_RUNE, GoodsDict),  %%获得镶嵌中的符文列表
    RuneAttr = lib_rune:count_rune_attribute(RuneWearList),    %%总属性
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL}
        = data_goods:classify_euqip(EquipList),
    WeaponAttr = data_goods:count_goods_attribute(WeaponL),
    ArmorAttr = data_goods:count_goods_attribute(ArmorL),
    OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
    WeaponOtherAttr = data_goods:count_equip_base_other_attribute(WeaponL),
    ArmorOtherAttr = data_goods:count_equip_base_other_attribute(ArmorL),
    OrnamentOtherAttr = data_goods:count_equip_base_other_attribute(OrnamentL),
    RuneAddAttr = Rune#rune.equip_add_ratio_attr,
    RuneSkillAttr = Rune#rune.skill_attr,
    NewWeaponAttr = ulists:kv_list_plus_extra([RuneAddAttr, WeaponAttr, WeaponOtherAttr]),
    NewArmorAttr = ulists:kv_list_plus_extra([RuneAddAttr, ArmorAttr, ArmorOtherAttr]),
    NewOrnamentAttr = ulists:kv_list_plus_extra([RuneAttr, OrnamentAttr, OrnamentOtherAttr]),
    LastWeaponAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
    LastArmorAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
    LastOrnamentAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),
    LastAttr = util:combine_list(RuneAttr ++ LastWeaponAttr ++ LastArmorAttr ++ LastOrnamentAttr ++ RuneSkillAttr),
    lib_player:calc_partial_power(PS#player_status.original_attr, 0, LastAttr) + get_skill_power(PS).

update_power(PS) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{rune = Rune} = GS,
    Power = get_power2(PS),
    NewRune = Rune#rune{power = Power},
    NewGS = GS#goods_status{rune = NewRune},
    lib_goods_do:set_goods_status(NewGS),
    lib_train_act:rune_train_power_up(PS),
    Power.



%% 计算装备基础属性
%% 把其他系统附加的属性合并到基础属性中
count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, AttrL) ->
    ConvertMap = #{?WEAPON_ATT => ?ATT, ?WEAPON_WRECK => ?WRECK},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap);
count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, AttrL) ->
    ConvertMap = #{?ARMOR_HP => ?HP, ?ARMOR_DEF => ?DEF},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap);
count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, AttrL) ->
    ConvertMap = #{?ORNAMENT_ATT => ?ATT, ?ORNAMENT_WRECK => ?WRECK},
    do_count_euqip_base_attr_ex(AttrL, ConvertMap).

do_count_euqip_base_attr_ex(AttrL, ConvertMap) ->
    lists:foldl(
        fun({AttrId, Val}, AccL) ->
            case maps:get(AttrId, ConvertMap, false) of
                false -> AccL;
                ConvertId ->
                    case lists:keyfind(ConvertId, 1, AttrL) of
                        {ConvertId, PreVal} ->
                            lists:keystore(ConvertId, 1, AccL, {ConvertId, PreVal * (Val / ?RATIO_COEFFICIENT)});
                        _ -> AccL
                    end
            end
        end, [], AttrL).



%% 唤醒
%% @retutn {ok, Ps} | {false, ErrCode, Ps}
awake(Ps, GoodsId, AttrId, CostGoodsIdL) ->
%%	?MYLOG("rune", " GoodsId, AttrId ~p ~p~n", [GoodsId, AttrId]),
    case check_awake(Ps, GoodsId, AttrId, CostGoodsIdL) of
        {false, ErrCode} -> {false, ErrCode, Ps};
        {true, LessRuneExp, DelGoodsInfoL, OldAwakeLvList, NewRuneLevel, NewAwakeLv, NewGoodsInfo, NewAwakeExp, OldLv} ->
            % About = lists:concat(["AttrId:", AttrId]),
            % case lib_goods_api:cost_object_list_with_check(Ps, Cost, soul_awake, About) of
            %     {false, ErrCode, NewPs} -> {false, ErrCode, NewPs};
            %     {true, NewPs} -> do_awake(NewPs, Cost, OldAwakeLvList, NewAwakeLv, NewGoodsInfo)
            % end
%%			?MYLOG("cym", "NewAwakeLv ~p ~p~n", [NewAwakeLv, NewAwakeExp]),
            do_awake(Ps, LessRuneExp, DelGoodsInfoL, OldAwakeLvList, NewRuneLevel, NewAwakeLv, NewGoodsInfo, NewAwakeExp, OldLv, AttrId)
    end.



%% 获得指定属性的觉醒等级
%% @param GoodsInfo #goods{} | []
get_awake_lv(GoodsInfo, AttrId) ->
    AwakeList = get_awake_lv_list(GoodsInfo),
    case lists:keyfind(AttrId, 1, AwakeList) of
        false -> {0, 0};
        {AttrId, AwakeLv, Exp} ->
            {AwakeLv, Exp}
    end.


%% 获得属性觉醒列表
get_awake_lv_list(#goods{type = Type}) when Type =/= ?GOODS_TYPE_RUNE -> [];
get_awake_lv_list(#goods{other = #goods_other{optional_data = OptionalData}} = _GoodsInfo) ->
    case is_list(OptionalData) of
        true -> OptionalData;
        false -> []
    end;
get_awake_lv_list(_) ->
    [].

check_awake(_Ps, GoodsId, AttrId, CostGoodsIdL) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    UsortCostGoodsIdL = lists:usort(CostGoodsIdL),
    IsMember = lists:member(GoodsId, UsortCostGoodsIdL),
    if
        GoodsInfo =:= [] -> {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.type =/= ?GOODS_TYPE_RUNE -> {false, ?ERRCODE(err167_not_rune)};
        IsMember -> {false, ?ERRCODE(err167_not_cost_self_to_awake)};
        true ->
            #goods{
                subtype = SubType,
                level = Level,
                color = Color,
                other = Other
            } = GoodsInfo,
            {AwakeLv, AwakeExp} = lib_rune:get_awake_lv(GoodsInfo, AttrId),
            MaxExp = get_max_exp(AwakeLv, AwakeExp),
            if
                Color < ?awake_color_limit ->
                    {false, ?ERRCODE(err167_awake_color_limit)};
                true ->
                    case check_awake_cost(GoodsInfo, AttrId, UsortCostGoodsIdL, [], 0, MaxExp) of
                        {false, ErrCode} ->
                            {false, ErrCode};
                        {true, DelGoodsInfoL, AddExp} ->
                            {NewAwakeLv, NewAwakeExp} = get_new_awake_lv_and_exp(AwakeLv, AwakeExp, AddExp),
                            AwakeLvList = lib_rune:get_awake_lv_list(GoodsInfo),
                            NewAwakeLvList = lists:keystore(AttrId, 1, AwakeLvList, {AttrId, NewAwakeLv, NewAwakeExp}),
                            % 经验
                            F = fun(GoodInfo, AccExp) ->
                                #goods{type = Type} = GoodInfo,
                                if
                                    Type == ?GOODS_TYPE_RUNE ->
                                        TempExp = get_goods_rune_point(GoodInfo),
                                        AccExp + TempExp;
                                    true ->
                                        AccExp
                                end
                                end,
                            DelGoodsL = [TmpGoodsInfo || {TmpGoodsInfo, _Num} <- DelGoodsInfoL],
                            RuneExp = lists:foldl(F, 0, DelGoodsL),
                            RuneAllLvList = data_rune:get_rune_all_lv(SubType),  %%获取这个子类型的所有符文等级
                            {NewRuneLevel, LessRuneExp} = level_up_by_point(SubType, Color, RuneExp, Level, length(RuneAllLvList)),
                            % 赋值
                            NewGoodsInfo = GoodsInfo#goods{level = NewRuneLevel,
                                other = Other#goods_other{optional_data = NewAwakeLvList}},
                            {true, LessRuneExp, DelGoodsInfoL, AwakeLvList, NewRuneLevel, NewAwakeLv, NewGoodsInfo, NewAwakeExp, Level}
                    end
            end
    end.



%% 获取消耗物品
check_awake_cost(_AwakeGoodsInfo, _AttrId, [], Result, AccExp, _MaxExp) -> {true, Result, AccExp};
check_awake_cost(AwakeGoodsInfo, AwakeAttrId, [GoodsId | T], Result, AccExp, MaxExp) ->
    case lib_goods_api:get_goods_info(GoodsId) of
        #goods{color = Color} = GoodsInfo ->
            AwakeLvList = [{AttrId, AwakeLv, Exp} || {AttrId, AwakeLv, Exp} <- lib_rune:get_awake_lv_list(GoodsInfo), AwakeLv > 0 orelse Exp > 0],
            IsSameAttrRune = is_same_attr_rune(AwakeGoodsInfo, GoodsInfo, AwakeAttrId),

            if
            % 觉醒不能消耗
                length(AwakeLvList) > 0 -> {false, ?ERRCODE(err167_not_cost_awake_rune)};
                Color < ?awake_color_limit ->
                    {false, ?ERRCODE(err167_awake_cost_color_limit)};
                IsSameAttrRune == false ->
                    {false, ?ERRCODE(err167_attr_different)};
                true ->
                    AddExp = data_rune:get_exp_by_color(Color),
                    if
                        AccExp + AddExp >= MaxExp ->  %%升满级了
                            {true, [{GoodsInfo, 1} | Result], AccExp + AddExp};
                        true ->
                            check_awake_cost(AwakeGoodsInfo, AwakeAttrId, T, [{GoodsInfo, 1} | Result], AccExp + AddExp, MaxExp)
                    end
            end;
        _ ->
            {false, ?ERRCODE(err150_no_goods)}
    end.

%%是否同属性吞噬
is_same_attr_rune(AwakeGoodsInfo, GoodsInfo, AwakeAttrId) ->
    #goods{subtype = AwakeSubType} = AwakeGoodsInfo,
    #goods{subtype = SubType} = GoodsInfo,
    IsSpecialRune = lists:member(AwakeSubType, [26, 27]),
%%	?MYLOG("rune", " AwakeSubType, AwakeSubType, AwakeAttrId ~p ~p ~p~n", [AwakeSubType, AwakeSubType, AwakeAttrId]),
    %%有两个特殊符文 todo  先不考虑
    case data_rune:get_rune_attr_coefficient_con(SubType, 1) of
        #rune_attr_coefficient_con{attr_coefficient_list = CfgAttrList} ->
            AttrLength = length(CfgAttrList),
            if
                AttrLength == 1 ->  %%单属性符文
                    [{CfgAttrId, _} | _] = CfgAttrList,
                    case data_rune:get_rune_attr_coefficient_con(AwakeSubType, 1) of
                        #rune_attr_coefficient_con{attr_coefficient_list = AwakeAttrList} ->
                            case lists:keyfind(AwakeAttrId, 1, AwakeAttrList) of
                                false ->
                                    false;
                                _ ->   %%只有相同的时候才能吞噬
                                    CfgAttrId == AwakeAttrId
                            end;
                        _ ->
                            false
                    end;
                IsSpecialRune == true andalso AwakeSubType == SubType ->
                    true;
                true ->  %%
                    false
            end;
        _ ->
            false
    end.


get_new_awake_lv_and_exp(OldAwakeLv, AwakeExp, AddExp) ->
    case data_rune:get_up_exp_by_lv(OldAwakeLv) of
        [] ->
            {OldAwakeLv, AddExp + AwakeExp};
        NeedExp ->
            if
                AddExp + AwakeExp >= NeedExp ->
                    get_new_awake_lv_and_exp(OldAwakeLv + 1, AddExp + AwakeExp - NeedExp, 0);
                true ->
                    {OldAwakeLv, AddExp + AwakeExp}
            end
    end.




%% 唤醒
do_awake(Ps, LessRuneExp, DelGoodsInfoL, OldAwakeLvList, NewRuneLevel, NewAwakeLv, NewGoodsInfo, NewExp, OldRuneLv, AttrId) ->
    #player_status{id = RoleId, goods = StatusGoods, original_attr = OriginalAttr, figure = #figure{ lv = _RoleLv }} = Ps,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{rune = Rune} = GoodsStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        % 删除物品
        {ok, GoodsStatusAfDel} = lib_goods:delete_goods_list(GoodsStatus, DelGoodsInfoL),
        % 更新物品数据
        change_goods_other(NewGoodsInfo),
        #goods{subtype = SubType, location = Location, level = _NewLevel, color = _Color} = NewGoodsInfo,
%%		ExtraAttr = lib_soul:count_one_soul_extra_attr(SubType, Color, NewLevel),
        [_NewGoodsInfo, GoodsStatusAfLv] = lib_goods:change_goods_level_extra_attr(NewGoodsInfo, Location, NewRuneLevel, [], GoodsStatusAfDel),
        lib_goods_api:notify_client(Ps, [NewGoodsInfo]),  %%更新背包信息
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(GoodsStatusAfLv#goods_status.dict),
        NewGoodsStatus = GoodsStatusAfLv#goods_status{dict = Dict},
        % 属性， 技能变化
        case NewGoodsInfo#goods.location of
            ?GOODS_LOC_RUNE ->
                RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict),
                RuneEquipAttList = get_equip_att_ratio(RoleId, Dict),

                %% 查看该子类型的符文是否会修改技能
                SubTypeList = data_rune:get_all_sub_type(),
                case lists:member(SubType, SubTypeList) of
                    true ->
                        #wear_rune_skill{skill_id = SkillId} = data_rune:get_wear_rune_skill(SubType),
                        NewRuneSkill = lists:keystore(SkillId, 1, Rune#rune.skill, {SkillId, NewAwakeLv + 1});
                    _ ->
                        NewRuneSkill = Rune#rune.skill
                end,
                SkillAttr = lib_skill:get_passive_skill_attr(NewRuneSkill),

                NewRune = Rune#rune{
                    equip_add_ratio_attr = RuneEquipAttList,
                    skill = NewRuneSkill,
                    skill_attr = SkillAttr
                },
                GoodsStatusAfEquip = NewGoodsStatus#goods_status{rune = NewRune},
                RuneAttr = count_rune_attribute(RuneWearList),
                NewStatusGoods = StatusGoods#status_goods{
                    rune_attr = RuneAttr               %%更新属性
                },
                PsAfGoods = Ps#player_status{
                    goods = NewStatusGoods
                };
            _ ->
                GoodsStatusAfEquip = NewGoodsStatus,
                PsAfGoods = Ps, NewRuneSkill = Rune#rune.skill
        end,
        {ok, PsAfGoods, GoodsStatusAfEquip, GoodsL, NewRuneSkill}
    end,
    case lib_goods_util:transaction(F) of
        {ok, PsAfGoods, NewGoodsStatus, GoodsL, NewSkillList} ->
            GoodsStatusAfAdd = add_rune_point(LessRuneExp, NewGoodsStatus),
            lib_goods_do:set_goods_status(GoodsStatusAfAdd),
            lib_goods_api:notify_client(RoleId, GoodsL),
            % 装备的聚魂要计算战力
            case NewGoodsInfo#goods.location of
                ?GOODS_LOC_RUNE ->
                    {ok, PsAfCount} = lib_goods_util:count_role_equip_attribute(PsAfGoods),
                    update_power(PsAfCount),
                    lib_rush_rank_api:flash_rank_by_rune_rush(PsAfCount),
                    %% 查看该子类型的符文是否会修改技能
                    SubTypeList = data_rune:get_all_sub_type(),
                    case lists:member(NewGoodsInfo#goods.subtype, SubTypeList) of
                        true ->
                            #goods_status{rune = #rune{skill = Skills}} = NewGoodsStatus,
                            mod_scene_agent:update(PsAfCount, [{passive_skill, Skills}, {battle_attr, PsAfCount#player_status.battle_attr}]);
                        _ ->
                            skip
                    end,
                    lib_player:send_attribute_change_notify(PsAfCount, ?NOTIFY_ATTR);   %%通知玩家属性改变
                _ ->
                    PsAfCount = PsAfGoods
            end,
            %% 扣除指定物品日志
            F1 = fun({TmpGoodsInfo, TmpNum}) ->
                #goods{id = TmpGoodsId, goods_id = TmpGoodsTypeId, level = TmpLevel} = TmpGoodsInfo,
%%				lib_log_api:log_throw(soul_awake, RoleId, TmpGoodsId, TmpGoodsTypeId, TmpNum, 0, 0),
                {TmpGoodsId, TmpGoodsTypeId, TmpLevel, TmpNum}
            end,
            CostInfoL = lists:map(F1, DelGoodsInfoL),
            #goods{id = GoodsId, goods_id = GoodsTypeId, subtype = SubType, level = NewLevel, other = _Other, color = Color} = NewGoodsInfo,
            AwakeLvList = get_awake_lv_list(NewGoodsInfo),
            lib_log_api:log_rune_awake(RoleId, GoodsId, GoodsTypeId, [], CostInfoL, OldAwakeLvList, AwakeLvList,
                OldRuneLv, NewLevel, GoodsStatus#goods_status.rune#rune.rune_point, GoodsStatusAfAdd#goods_status.rune#rune.rune_point),
            % 计算当前的觉醒战力加成与下一级的觉醒战力加成
            %% 查看该子类型的符文是否存在技能战力加成
            AllSubTypeList = data_rune:get_all_sub_type(),
            case lists:member(SubType, AllSubTypeList) of
                true ->
                    #wear_rune_skill{skill_id = SkillId} = data_rune:get_wear_rune_skill(SubType),
                    case lists:keyfind(SkillId, 1, NewSkillList) of
                        {SkillId, AwakeSkillLevel} ->
                            SkillPower = lib_skill_api:get_skill_power([{SkillId, AwakeSkillLevel}]),
                            NextSkillPower = lib_skill_api:get_skill_power([{SkillId, AwakeSkillLevel + 1}]),
                            NoNextSkill = NextSkillPower =< SkillPower;
                        _ ->
                            SkillPower = 0, NoNextSkill = false,
                            NextSkillPower = lib_skill_api:get_skill_power([{SkillId, 1}])
                    end;
                _ ->
                    SkillPower = 0, NextSkillPower = 0, NoNextSkill = false
            end,
            CurAwakeAttr = lib_rune:get_one_awake_attr_list(AttrId, NewAwakeLv, Color),
            CurAwakePower = lib_player:calc_partial_power(PsAfCount, PsAfCount#player_status.original_attr, SkillPower, CurAwakeAttr),
            NextAwakeAttrL = lib_rune:get_one_awake_attr_list(AttrId, NewAwakeLv + 1, Color),
            case NextAwakeAttrL == [] orelse NoNextSkill of
                true ->
                    NextAwakePower = 0;
                _ ->
                    NextAwakePower = lib_player:calc_expact_power(PsAfCount, OriginalAttr, NextSkillPower, NextAwakeAttrL)
            end,
            {ok, PsAfCount, NewAwakeLv, NewExp, NewRuneLevel, CurAwakePower, NextAwakePower};
        Error ->
            ?ERR("do_awake NewGoodsInfo:~p Error:~p~n", [NewGoodsInfo, Error]),
            {false, ?FAIL, Ps}
    end.



%% 符文other_data的保存格式
%% AwakeLvList : [{TypeId, Level, Exp},...]
format_other_data(#goods{type = ?GOODS_TYPE_RUNE, other = Other}) ->
    #goods_other{optional_data = AwakeLvList} = Other,
    [?GOODS_OTHER_KEY_RUNE, AwakeLvList];

format_other_data(_) ->
    [].

%% 聚魂物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [AwakeLvList | _]) ->
    Other#goods_other{optional_data = AwakeLvList}.

%% 更新 goods_other
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

%%good_other{}
get_awake_attr(Other, Color) ->
    #goods_other{optional_data = AwakeAttrList} = Other,
    F = fun({AttrId, AwakeLv, _Exp}, AttrList) ->
        case data_rune:get_awake_attr(Color, AttrId, AwakeLv) of
            [] ->
                AttrList;
            Res ->
                ulists:kv_list_plus_extra([AttrList, Res])
        end
    end,
    lists:foldl(F, [], AwakeAttrList).


%% 符文拆解
dismantle_awake(Ps, GoodsIdL) ->
    case split_dismantle_awake(Ps, GoodsIdL, {[], []}) of
        {false, ErrCode} -> {false, ErrCode, Ps};
        {SingleL, MultiL} ->
            % ?MYLOG("hjhsoul", "SingleL:~p MultiL:~p ~n", [SingleL, MultiL]),
            case do_dismantle_awake_for_single_attr(Ps, SingleL) of
                {false, SingleErrCode, PsAfSingle} -> {false, SingleErrCode, PsAfSingle};
                {ok, PsAfSingle, SingleGoodsL} ->
                    case do_dismantle_awake_for_multi_attr(PsAfSingle, MultiL) of
                        {false, MultiErrCode, PsAfMulti} -> {false, MultiErrCode, PsAfMulti};
                        {ok, PsAfMulti, MultiGoodsL} -> {ok, PsAfMulti, SingleGoodsL ++ MultiGoodsL}
                    end
            end
    end.


split_dismantle_awake(_Ps, [], {SingleL, MultiL}) -> {SingleL, MultiL};
split_dismantle_awake(Ps, [GoodsId | GoodsIdL], {SingleL, MultiL}) ->
    case check_dismantle_awake(Ps, GoodsId) of
        {false, ErrCode} -> {false, ErrCode};
        {true, single_attr, NewGoodsInfo, AwakeLvList, ReturnGoodsL} ->
            NewSingleL = [{NewGoodsInfo, AwakeLvList, ReturnGoodsL} | SingleL],
            split_dismantle_awake(Ps, GoodsIdL, {NewSingleL, MultiL});
        {true, multi_attr, DelGoodsInfo, DelAwakeLvList, ReturnGoodsL} ->
            NewMultiL = [{DelGoodsInfo, DelAwakeLvList, ReturnGoodsL} | MultiL],
            split_dismantle_awake(Ps, GoodsIdL, {SingleL, NewMultiL})
    end.


%% 检查聚魂拆解
%%  1:穿戴的不可以拆解
%%  2:觉醒一定要拆解
%%  3:双属性一定要拆解
check_dismantle_awake(Ps, GoodsId) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    if
        GoodsInfo =:= [] -> {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.type =/= ?GOODS_TYPE_RUNE -> {false, ?ERRCODE(err167_not_rune)};
        GoodsInfo#goods.location =:= ?GOODS_LOC_RUNE -> {false, ?ERRCODE(err167_have_wear)};
        true ->
            #goods{
                subtype = _SubType,
                color = _Color,
                level = _Level,
                other = _Other
            } = GoodsInfo,
            IsMulti = is_multi_attr_rune(GoodsInfo),
            if
                IsMulti == false ->
                    check_dismantle_awake_for_single_attr(Ps, GoodsInfo);
                IsMulti == true ->
                    check_dismantle_awake_for_multi_attr(Ps, GoodsInfo);
                true ->
                    {false, ?MISSING_CONFIG}
            end
%%			RuneAttrCoeCon = data_rune:get_rune_attr_coefficient_con(SubType, Level),
%%			if
%%				is_record(RuneAttrCoeCon, rune_attr_coefficient_con) == false -> {false, ?MISSING_CONFIG};
%%%%
%%%%				SoulAttrCoeCon#soul_attr_coefficient_con.attr_num == 1 -> check_dismantle_awake_for_single_attr(Ps, GoodsInfo);
%%%%				SoulAttrCoeCon#soul_attr_coefficient_con.attr_num > 1 -> check_dismantle_awake_for_multi_attr(Ps, GoodsInfo);
%%				true ->
%%					IsMulti = is_multi_attr_rune(GoodsInfo),
%%					if
%%						IsMulti == false ->
%%							check_dismantle_awake_for_single_attr(Ps, GoodsInfo);
%%						IsMulti == true ->
%%							check_dismantle_awake_for_multi_attr(Ps, GoodsInfo);
%%						true ->
%%							{false, ?MISSING_CONFIG}
%%					end
%%			end
    end.


%% 检查聚魂拆解(单属性)
%% 获得 原物品+觉醒拆除的物品
check_dismantle_awake_for_single_attr(_Ps, GoodsInfo) ->
    #goods{
        color = Color,
        other = Other
    } = GoodsInfo,
    AwakeLvList = [{AttrId, AwakeLv, Exp} || {AttrId, AwakeLv, Exp} <- get_awake_lv_list(GoodsInfo), AwakeLv > 0 orelse Exp > 0],
    if
        length(AwakeLvList) == 0 ->
            {false, ?ERRCODE(err167_no_awake_single_attr_not_to_dismantle)};
        true ->
            NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{optional_data = []}},
            F2 = fun({AttrId, AwakeLv, Exp}, ReturnGoodsL) ->
                AllExp = get_all_awake_exp(AwakeLv, Exp),
                SingleExp = data_rune:get_exp_by_color(?awake_color_limit),
                case data_rune:get_back_material(Color, AttrId, 1) of
                    [] ->
                        ReturnGoodsL;
                    BackMaterial ->
                        Num = util:floor(AllExp / SingleExp),
                        [{?TYPE_GOODS, BackMaterial, Num} | ReturnGoodsL]
                end
                 end,
            _ReturnGoodsL = lib_goods_api:make_reward_unique(lists:foldl(F2, [], AwakeLvList)),
            ReturnGoodsL = [{Type, GoodsId, Num} || {Type, GoodsId, Num} <- _ReturnGoodsL, Num > 0],
            {true, single_attr, NewGoodsInfo, AwakeLvList, ReturnGoodsL}
    end.

%% 处理符文拆解(单属性)
do_dismantle_awake_for_single_attr(Ps, []) -> {ok, Ps, []};
do_dismantle_awake_for_single_attr(Ps, SingleL) -> %NewGoodsInfo, AwakeLvList, ReturnGoodsL) ->
    #player_status{id = RoleId} = Ps,
    GoodsStatus = lib_goods_do:get_goods_status(),
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        % 更新数据库
        F2 = fun({TmpGoodsInfo, _, _}, TmpDict) ->
            change_goods_other(TmpGoodsInfo),
            DictAfDis = lib_goods_dict:append_dict({add, goods, TmpGoodsInfo}, TmpDict),
            DictAfDis
             end,
        DictAfDis = lists:foldl(F2, GoodsStatus#goods_status.dict, SingleL),
        % 更新内存
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(DictAfDis),
        NewGoodsStatus = GoodsStatus#goods_status{dict = Dict},
        {ok, NewGoodsStatus, GoodsL}
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsStatus, GoodsL} ->
            % 保存拆解后的物品
            lib_goods_do:set_goods_status(NewGoodsStatus),
            lib_goods_api:notify_client(RoleId, GoodsL),
            % 返还材料
            F3 = fun({#goods{id = GoodsId, goods_id = GoodsTypeId}, _AwakeLvList, ReturnGoodsL}, {SumReturnGoodsL, SingleGoodsL}) ->
                ClientReturnGoodsL = lib_goods_api:make_reward_unique([{?TYPE_GOODS, GoodsTypeId, 1}] ++ ReturnGoodsL),
                {ReturnGoodsL ++ SumReturnGoodsL, [{GoodsId, ClientReturnGoodsL} | SingleGoodsL]}
                 end,
            {SumReturnGoodsL, SingleGoodsL} = lists:foldl(F3, {[], []}, SingleL),
            CombineReturnGoodsL = lib_goods_api:make_reward_unique(SumReturnGoodsL),
            Produce = #produce{type = rune_dismantle_awake, reward = CombineReturnGoodsL},
            {ok, PsAfReward} = lib_goods_api:send_reward_with_mail(Ps, Produce),
            % 日志
            F4 = fun({TmpGoodsInfo, AwakeLvList, ReturnGoodsL}) ->
                #goods{id = GoodsId, goods_id = GoodsTypeId} = TmpGoodsInfo,
                lib_log_api:log_rune_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsL ++ [{?TYPE_GOODS, GoodsTypeId, 1}])
                 end,
            lists:foreach(F4, SingleL),
%%			?MYLOG("hjhsoul", "GoodsL:~p CombineReturnGoodsL:~p ~n", [GoodsL, CombineReturnGoodsL]),
            {ok, PsAfReward, SingleGoodsL};
        Error ->
            ?ERR("do_awake SingleL:~p Error:~p~n", [SingleL, Error]),
            {false, ?FAIL, Ps}
    end.

%% 检查聚魂拆解(多属性)
check_dismantle_awake_for_multi_attr(Ps, GoodsInfo) ->
    #goods{
        color = Color
    } = GoodsInfo,
    AwakeLvList = [{AttrId, AwakeLv, Exp} || {AttrId, AwakeLv, Exp} <- get_awake_lv_list(GoodsInfo), AwakeLv > 0 orelse Exp > 0],
    case lib_goods_check:count_decompose_reward(Ps, [{GoodsInfo, 1}], []) of
        {ok, DecomposeRewardList} -> CheckDecompose = true;
        {fail, ErrorCode} ->
            DecomposeRewardList = [],
            CheckDecompose = {false, ErrorCode}
    end,
    if
        CheckDecompose =/= true -> CheckDecompose;
        true ->
            F2 = fun({AttrId, AwakeLv, Exp}, ReturnGoodsL) ->
                AllExp = get_all_awake_exp(AwakeLv, Exp),
                SingleExp = data_rune:get_exp_by_color(?awake_color_limit),
                case data_rune:get_back_material(Color, AttrId, 1) of
                    [] ->
                        ReturnGoodsL;
                    BackMaterial ->
                        Num = util:floor(AllExp / SingleExp),
                        [{?TYPE_GOODS, BackMaterial, Num} | ReturnGoodsL]
                end
                 end,
            _ReturnGoodsL = lib_goods_api:make_reward_unique(lists:foldl(F2, DecomposeRewardList, AwakeLvList)),
            ReturnGoodsL = [{Type, GoodsId, Num} || {Type, GoodsId, Num} <- _ReturnGoodsL, Num > 0],
            {true, multi_attr, GoodsInfo, AwakeLvList, ReturnGoodsL}
    end.

%% 处理符文拆解(多属性)
do_dismantle_awake_for_multi_attr(Ps, []) -> {ok, Ps, []};
do_dismantle_awake_for_multi_attr(Ps, MultiL) -> %DelGoodsInfo, AwakeLvList, ReturnGoodsL) ->
    #player_status{id = RoleId} = Ps,
    F = fun({#goods{id = GoodsId}, _, _}) -> {GoodsId, 1} end,
    CostL = lists:map(F, MultiL),
    case lib_goods_api:delete_more_by_list(Ps, CostL, rune_dismantle_awake) of
        1 ->
            % 返还材料
            F2 = fun({#goods{id = GoodsId} = _GoodsInfo, _AwakeLvList, ReturnGoodsL}, {SumReturnGoodsL, MultiGoodsL}) ->
                % ?MYLOG("hjhsoul", "GoodsId:~p BinD:~p ReturnGoodsL:~p ~n", [GoodsInfo#goods.goods_id, GoodsInfo#goods.bind, ReturnGoodsL]),
                {ReturnGoodsL ++ SumReturnGoodsL, [{GoodsId, ReturnGoodsL} | MultiGoodsL]}
                 end,
            {SumReturnGoodsL, MultiGoodsL} = lists:foldl(F2, {[], []}, MultiL),
            CombineReturnGoodsL = lib_goods_api:make_reward_unique(SumReturnGoodsL),
            Produce = #produce{type = rune_dismantle_awake, reward = CombineReturnGoodsL},
            {ok, PsAfReward} = lib_goods_api:send_reward_with_mail(Ps, Produce),
            % 日志
            F3 = fun({TmpGoodsInfo, AwakeLvList, ReturnGoodsL}) ->
                #goods{id = GoodsId, goods_id = GoodsTypeId} = TmpGoodsInfo,
                lib_log_api:log_rune_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsL)
                 end,
            lists:foreach(F3, MultiL),
            {ok, PsAfReward, MultiGoodsL};
        ErrCode ->
            {false, ErrCode, Ps}
    end.

%% 检查是否能分解
check_goods_decompose_other(#goods{type = Type}) when Type =/= ?GOODS_TYPE_RUNE ->
    {fail, ?MISSING_CONFIG};
check_goods_decompose_other(#goods{location = ?GOODS_TYPE_RUNE} = _GoodsInfo) ->
    {fail, ?ERRCODE(err150_decompose_wear)};
check_goods_decompose_other(GoodsInfo) ->
%%	#goods{
%%		subtype = SubType,
%%		color = Color
%%	} = GoodsInfo,
%%	SoulAttrCoeCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
    AwakeLvList = [{AttrId, AwakeLv, Exp} || {AttrId, AwakeLv, Exp} <- get_awake_lv_list(GoodsInfo), AwakeLv > 0 orelse Exp > 0],
    IsMultiAttrRune = is_multi_attr_rune(GoodsInfo),
    if
    % 觉醒不能分解
        length(AwakeLvList) > 0 -> {fail, ?ERRCODE(err167_awake_not_to_decompose)};
    % 属性大于1不能分解  双属性符文不能分解
        IsMultiAttrRune > true ->
            {fail, ?ERRCODE(err167_multi_attr_num_not_to_decompose)};
        true -> true
    end.

%%计算觉醒一共用的经验
get_all_awake_exp(AwakeLv, Exp) ->
    get_all_awake_exp(AwakeLv, Exp, 0).

%%
get_all_awake_exp(Lv, Exp, AccExp) when Lv =< 0 ->
    Exp + AccExp;
get_all_awake_exp(Lv, Exp, AccExp) ->
    case data_rune:get_up_exp_by_lv(Lv - 1) of
        [] ->
            get_all_awake_exp(Lv - 1, 0, AccExp + Exp);
        NeedExp ->
            get_all_awake_exp(Lv - 1, 0, AccExp + NeedExp + Exp)
    end.


%% 是否多属性符文
is_multi_attr_rune(GoodsInfo) when is_record(GoodsInfo, goods) ->
    #goods{
        subtype = SubType
    } = GoodsInfo,
    IsSpecialRune = lists:member(SubType, [26, 27]),
    case data_rune:get_rune_attr_coefficient_con(SubType, 1) of
        #rune_attr_coefficient_con{attr_coefficient_list = AttrList} ->
            Length = length(AttrList),
            if
                IsSpecialRune == true ->  %% 特殊符文是算做单属性符文处理
                    false;
                Length > 1 ->
                    true;
                true ->
                    false
            end;
        _ ->
            {fail, ?MISSING_CONFIG}
    end;
is_multi_attr_rune(_GoodsInfo) ->
    {fail, ?MISSING_CONFIG}.




up_skill_lv(Ps) ->
    #player_status{
        id = RoleId
    } = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        rune = Rune
    } = GS,
    #rune{
        skill_lv = SkillLv
    } = Rune,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = GoodsDict
    } = GoodsStatus,
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GoodsDict),  %%获得镶嵌中的符文列表
    case data_rune:get_skill_conditon(?rune_skill_id, SkillLv + 1) of
        [] ->
            {false, ?ERRCODE(err167_max_skill_lv)};
        [{ColorLimit, Num, AwakeLv} | _] ->
            {ColorNum, AllAwakeLv} = get_color_num_and_awake_lv(ColorLimit, RuneWearList),
            if
                ColorNum >= Num andalso AllAwakeLv >= AwakeLv ->  %%满足条件
                    NewRune = Rune#rune{skill_lv = SkillLv + 1},
                    sql_rune(NewRune, RoleId),
                    NewGoodsStatus = GoodsStatus#goods_status{rune = NewRune},
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    mod_scene_agent:update(Ps, [{passive_skill, [{?rune_skill_id, SkillLv + 1}]}]),  %%更新被动技能
                    update_power(Ps),
                    NewPS = lib_player:count_player_attribute(Ps),
                    lib_rush_rank_api:flash_rank_by_rune_rush(NewPS),
                    lib_player:send_attribute_change_notify(NewPS, ?NOTIFY_ATTR),     %%主动推送信息
                    lib_log_api:log_rune_skill_up(RoleId, SkillLv, SkillLv + 1),
                    {ok, NewPS, SkillLv + 1};
                true ->
                    {false, ?ERRCODE(err167_can_not_up_rune_skill)}
            end
    end.


get_color_num_and_awake_lv(ColorLimit, GoodsList) when is_list(GoodsList) ->
    F = fun(Goods, {Num, AwakeLv}) ->
        #goods{
            color = Color
        } = Goods,
        if
            Color >= ColorLimit ->
                NewNum = Num + 1;
            true ->
                NewNum = Num
        end,
        TempAwakeLv = get_awake_all_lv(Goods),
        {NewNum, AwakeLv + TempAwakeLv}
        end,
    lists:foldl(F, {0, 0}, GoodsList).


get_awake_all_lv(Goods) ->
    #goods{
        other = Other
    } = Goods,
    #goods_other{optional_data = Data} = Other,
    F = fun({_Attr, Lv, _Exp}, AccLv) ->
        AccLv + Lv
        end,
    lists:foldl(F, 0, Data).

logout(Ps) ->
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),
    case GS of
        #goods_status{rune = Rune} ->
            #rune{
                rune_point = RunePoint,     %% 符文经验
                rune_chip = RuneChip        %% 符文碎片
                , skill_lv = SkillLv
                , skill = Skill
            } = Rune,
            ReSql = io_lib:format(?ReplaceRuneSkillSql, [RoleId, RunePoint, RuneChip, SkillLv, util:term_to_bitstring(Skill)]),
            db:execute(ReSql);
        _ -> skip
    end.

%% 获取符文技能属性
get_skill_attr(Ps) ->
    ReSql = io_lib:format(?SelectRuneSql, [Ps#player_status.id]),
    case db:get_all(ReSql) of
        [] ->
            [];
        [[_RoleId, _RunePoint, _RuneChip, _SkillLv, AwakeSkillBin] | _] ->
            %% 特殊符文觉醒技能战力
            SkillAttr = lib_skill:get_passive_skill_attr(util:bitstring_to_term(AwakeSkillBin)),
            SkillAttr
    end.

%%分离线和在线
get_skill_power(#player_status{pid = undefined, id = RoleId}) ->
    get_skill_power2(RoleId);
get_skill_power(PlayerStatus) ->
    GS = lib_goods_do:get_goods_status(),
    case GS of
        #goods_status{rune = Rune} ->
            #goods_status{rune = Rune} = GS,
            %% 特殊符文觉醒技能战力
            AwakeSkillPower = lib_skill_api:get_skill_power(Rune#rune.skill),
            %%符文技能战力
            case data_skill:get(?rune_skill_id, Rune#rune.skill_lv) of
                #skill{lv_data = LvData, career = ?SKILL_CAREER_RUNE} ->
                    case LvData of
                        #skill_lv{power = SkillPower} ->
                            ok;
                        _ ->
                            SkillPower = 0
                    end;
                _ ->
                    SkillPower = 0
            end,
            SkillPower + AwakeSkillPower;
        _ ->
            get_skill_power2(PlayerStatus#player_status.id)
    end.

get_skill_power2(RoleId) ->
    ReSql = io_lib:format(?SelectRuneSql, [RoleId]),
    case db:get_all(ReSql) of
        [] ->
            0;
        [[_RoleId, _RunePoint, _RuneChip, SkillLv, AwakeSkillBin] | _] ->
            %% 特殊符文觉醒技能战力
            AwakeSkillPower = lib_skill_api:get_skill_power(util:bitstring_to_term(AwakeSkillBin)),
            %%符文技能战力
            case data_skill:get(?rune_skill_id, SkillLv) of
                #skill{lv_data = LvData, career = ?SKILL_CAREER_RUNE} ->
                    case LvData of
                        #skill_lv{power = SkillPower} ->
                            ok;
                        _ ->
                            SkillPower = 0
                    end;
                _ ->
                    SkillPower = 0
            end,
            SkillPower + AwakeSkillPower
    end.

get_rune_passive_skill(#player_status{pid = Pid}) when is_pid(Pid) ->
    GS = lib_goods_do:get_goods_status(),
    #goods_status{rune = Rune} = GS,
    #rune{skill = Skills} = Rune,
    Fun = fun
              ({SkillId, SkillLv}) ->
                  case data_skill:get(SkillId, SkillLv) of
                      #skill{type = ?SKILL_TYPE_PASSIVE} -> true;
                      _ -> false
                  end;
              (_) -> false
          end,
    AwakeSkill = lists:filter(Fun, Skills),
    %%符文技能战力
    if
        Rune#rune.skill_lv > 0 ->
            [{?rune_skill_id, Rune#rune.skill_lv}] ++ AwakeSkill;
        true ->
            [] ++ AwakeSkill
    end;
get_rune_passive_skill(_) ->
    [].


get_max_exp(AwakeLv, AwakeExp) ->
    MaxLv = 6,
    UseExp = get_all_awake_exp(AwakeLv, AwakeExp),
    AllExp = get_all_awake_exp(MaxLv, 0),
    max(AllExp - UseExp, 0).

%% 获取单属性的符文物品
get_can_decompose_rune_goods(RoleId, Dict) ->
    %% 获取所有符文物品
    RuneGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE_BAG, Dict),
    %% 过滤掉双属性符文物品
    F = fun(Goods, Acc) ->
        #goods{subtype = SubType, level = Level} = Goods,
        case data_rune:get_rune_attr_num_con(SubType, Level) of
            #rune_attr_num_con{attr_num_list = AttrList} ->
                if
                    length(AttrList) >= 2 ->
                        Acc;
                    true ->
                        [Goods|Acc]
                end;
            _ ->
                [Goods|Acc]
        end
        end,
    lists:foldl(F, [], RuneGoodsList).

%% 分离经验物品和装备物品
split_exp_and_equip_goods(login, OneAttrRuneGoodsList, ColorList) ->
    {ExpGoods, Count} = split_exp_goods(login, OneAttrRuneGoodsList, [], 0),
    case Count >= ?LOGIN_RUNE_DECOMPOSE_LENGTH of
        true ->
            NewExpGoods = lists:sublist(ExpGoods, ?LOGIN_RUNE_DECOMPOSE_LENGTH),
            NewExpGoods;
        false -> %% 没有超过获取装备列表充数
            EquipGoods = split_equip_goods(OneAttrRuneGoodsList, [], ColorList, ?LOGIN_RUNE_DECOMPOSE_LENGTH - Count),
            {ExpGoods, EquipGoods}
    end.
split_exp_and_equip_goods(OneAttrRuneGoodsList, ColorList) ->
    {ExpGoods, Count} = split_exp_goods(OneAttrRuneGoodsList, [], 0),
    case Count >= ?RUNE_DECOMPOSE_LENGTH of
        true ->
            NewExpGoods = lists:sublist(ExpGoods, ?RUNE_DECOMPOSE_LENGTH),
            NewExpGoods;
        false -> %% 没有超过获取装备列表充数
            EquipGoods = split_equip_goods(OneAttrRuneGoodsList, [], ColorList, ?RUNE_DECOMPOSE_LENGTH - Count),
            {ExpGoods, EquipGoods}
    end.

%% 登录分离经验物品
split_exp_goods(login, [RuneGoods|OneAttrRuneGoodsList], ExpGoods, Count) when Count =< ?LOGIN_RUNE_DECOMPOSE_LENGTH ->
    #goods{subtype = SubType} = RuneGoods,
    %% 优先分解符文精华
    case SubType == 99 of
        true ->
            split_exp_goods(OneAttrRuneGoodsList, [RuneGoods|ExpGoods], Count + 1);
        false ->
            split_exp_goods(OneAttrRuneGoodsList, ExpGoods, Count)
    end;
split_exp_goods(login, _, ExpGoods, Count) -> {ExpGoods,Count}.

%% 分离经验物品
split_exp_goods([RuneGoods|OneAttrRuneGoodsList], ExpGoods, Count) when Count =< ?RUNE_DECOMPOSE_LENGTH ->
    #goods{subtype = SubType} = RuneGoods,
    %% 优先分解符文精华
    case SubType == 99 of
        true ->
            split_exp_goods(OneAttrRuneGoodsList, [RuneGoods|ExpGoods], Count + 1);
        false ->
            split_exp_goods(OneAttrRuneGoodsList, ExpGoods, Count)
    end;
split_exp_goods(_, ExpGoods, Count) -> {ExpGoods,Count}.

%% 分离装备物品
split_equip_goods([RuneGoods|OneAttrRuneGoodsList], EquipGoods, ColorList, LeftCount) when LeftCount > 0->
    #goods{subtype = SubType, color = Color} = RuneGoods,
    %% 优先分解符文精华
    case SubType =/= 99 andalso lists:member(Color, ColorList) of
        true ->
            split_equip_goods(OneAttrRuneGoodsList, [RuneGoods|EquipGoods], ColorList, LeftCount - 1);
        false ->
            split_equip_goods(OneAttrRuneGoodsList, EquipGoods, ColorList, LeftCount)
    end;
split_equip_goods(_, EquipGoods, _, _) -> EquipGoods.


%% 筛选过滤掉同种类别里最高品质的符文
get_rune_decompose_equip_list([], _,  Result) -> Result;
get_rune_decompose_equip_list([#goods{id = GoodsId, num = Num}|DecomposeRuneGoodsList], StrongestRuneIds, Result) ->
    case lists:member(GoodsId, StrongestRuneIds) of
        true ->
            get_rune_decompose_equip_list(DecomposeRuneGoodsList, StrongestRuneIds, Result);
        false ->
            get_rune_decompose_equip_list(DecomposeRuneGoodsList,  StrongestRuneIds, [{GoodsId, Num} | Result])
    end.

%% 获取当前最高品质的符文Id列表
get_rune_strongest_equip_list(TakingRuneGoodsList, DecomposeRuneGoodsList) ->
    %% 初始化身上的装备为最高品质列表
    StrongestEquipL = [{StrongestSubType, StrongestColor, ?GOODS_LOC_RUNE} || #goods{subtype = StrongestSubType, color = StrongestColor} <- TakingRuneGoodsList],
    F = fun(#goods{id = Id, subtype = SubType, color = Color, location = Location}, {Acc, Acc2}) ->
        case lists:keyfind(SubType, 1, Acc) of
            false -> %% 没找到，加入
                {[{SubType, Color, Location}|Acc], [{SubType, Id}|Acc2]};
            {_, StrongestColor2, _} -> %% 找到了，比较品质
                if
                    StrongestColor2 >= Color ->
                        {Acc, Acc2};
                    true ->
                        case lists:keyfind(SubType, 1, Acc2) of
                            false ->
                                {lists:keyreplace(SubType, 1, Acc, {SubType, Color, Location}), [{SubType, Id}|Acc2]};
                            _ ->
                                {lists:keyreplace(SubType, 1, Acc, {SubType, Color, Location}), lists:keyreplace(SubType, 1, Acc2, {SubType, Id})}
                        end

                end
        end
        end,
    {_, StrongestEquipIdList} = lists:foldl(F, {StrongestEquipL, []}, DecomposeRuneGoodsList),
    [RuneId || {RuneSubType, RuneId} <- StrongestEquipIdList, RuneId > 0, RuneSubType =/= 99].


%% 获取符文自动分解列表
get_rune_decompose_list(login, OneAttrRuneGoodsList, ColorList, TakingRuneGoodsList) ->
    case lib_rune:split_exp_and_equip_goods(login, OneAttrRuneGoodsList, ColorList) of
        {ExpGoodsList, EquipGoodsList} ->
            %% 获取同类符文里最高品质的符文id
            StrongestRuneIds = get_rune_strongest_equip_list(TakingRuneGoodsList, OneAttrRuneGoodsList),
            %% 筛选过滤掉同种类别里最高品质的符文
            NewEquipGoodsList = get_rune_decompose_equip_list(EquipGoodsList, StrongestRuneIds, []),
            NewEquipGoodsList ++ [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0];
        ExpGoodsList ->
            [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0]
    end.
%% 获取符文自动分解列表
get_rune_decompose_list(OneAttrRuneGoodsList, ColorList, TakingRuneGoodsList) ->
    case lib_rune:split_exp_and_equip_goods(OneAttrRuneGoodsList, ColorList) of
        {ExpGoodsList, EquipGoodsList} ->
            %% 获取同类符文里最高品质的符文id
            StrongestRuneIds = get_rune_strongest_equip_list(TakingRuneGoodsList, OneAttrRuneGoodsList),
            %% 筛选过滤掉同种类别里最高品质的符文
            NewEquipGoodsList = get_rune_decompose_equip_list(EquipGoodsList, StrongestRuneIds, []),
            NewEquipGoodsList ++ [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0];
        ExpGoodsList ->
            [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0]
    end.


%% 发邮箱提醒
send_tips_by_email(RoleId) ->
    #errorcode_msg{about = Name} = data_errorcode_msg:get(1043),
    #errorcode_msg{about = Material} = data_errorcode_msg:get(1044),
    Title = utext:get(1500009, [Name]),
    Content = utext:get(1500011, [Name, ?RUNE_LIMIT_2, Material, Name, Name]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []).

calc_next_awake_level_attr(Other, Color, SubType, Level) ->
    #goods_other{optional_data = OptionalData} = Other,
    BaseAttrList = lib_rune:count_one_rune_attr(SubType, Color, Level),
    F = fun({AttrId, Value}, AccList) ->
        case lists:keyfind(AttrId, 1, OptionalData) of
            {_, AwakeLv, AwakeExp} ->
                [{AttrId, Value, AwakeLv, AwakeExp} | AccList];
            _ ->
                [{AttrId, Value, 0, 0} | AccList]
        end
    end,
    TemAttrList = lists:reverse(lists:foldl(F, [], BaseAttrList)),
    Fun2 = fun({AttrId, _Value, AwakeLv, _Exp}, AttrList) ->
        case data_rune:get_awake_attr(Color, AttrId, AwakeLv + 1) of
            [] -> AttrList;
            Res ->
                ulists:kv_list_plus_extra([AttrList, Res])
        end
    end,
    lists:foldl(Fun2, [], TemAttrList).

%% 计算觉醒部分的防具等战力实际的加成
calc_equip_awake_attr(Player, AwakeAttrL) ->
    #player_status{id = PlayerId} = Player,
    Fun = fun({AttrId, Value}, {AccSpecialL, AccNormalL}) ->
        case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE) of
            true ->
                {[{AttrId, Value}|AccSpecialL], AccNormalL};
            false ->
                {AccSpecialL, [{AttrId, Value}|AccNormalL]}
        end
    end,
    {SpecialAttrL, NormalAttrL} = lists:foldl(Fun, {[], []}, AwakeAttrL),
    case SpecialAttrL of
        [] ->
            NormalAttrL;
        _ ->
            GS = lib_goods_do:get_goods_status(),
            #goods_status{dict = GoodsDict} = GS,
            EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
            #{?EQUIP_TYPE_WEAPON := WeaponL, ?EQUIP_TYPE_ARMOR := ArmorL, ?EQUIP_TYPE_ORNAMENT := OrnamentL} = data_goods:classify_euqip(EquipList),
            WeaponAttr = data_goods:count_goods_attribute(WeaponL),
            ArmorAttr = data_goods:count_goods_attribute(ArmorL),
            OrnamentAttr = data_goods:count_goods_attribute(OrnamentL),
            NewWeaponAttr = ulists:kv_list_plus_extra([AwakeAttrL, WeaponAttr]),
            NewArmorAttr = ulists:kv_list_plus_extra([AwakeAttrL, ArmorAttr]),
            NewOrnamentAttr = ulists:kv_list_plus_extra([AwakeAttrL, OrnamentAttr]),
            LastWeaponAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_WEAPON, NewWeaponAttr),
            LastArmorAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_ARMOR, NewArmorAttr),
            LastOrnamentAttr = count_euqip_base_attr_ex(?EQUIP_TYPE_ORNAMENT, NewOrnamentAttr),
            util:combine_list(LastWeaponAttr ++ LastArmorAttr ++ LastOrnamentAttr ++ NormalAttrL)
    end.


%% 获取某个属性的觉醒等级属性
get_one_awake_attr_list(AttrId, AwakeLevel, Color) ->
    case data_rune:get_awake_attr(Color, AttrId, AwakeLevel) of
        [] -> [];
        Res -> Res
    end.