%%%--------------------------------------
%%% @Module  : lib_soul
%%% @Author  : huyihao
%%% @Created : 2017.11.14
%%% @Description:  聚魂
%%%--------------------------------------

-module(lib_soul).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("soul.hrl").
-include("def_module.hrl").
-include("hi_point.hrl").

-compile(export_all).
%%-export ([
%%    soul_login/2,
%%    count_soul_attribute/1,
%%    count_one_soul_attr/4,
%%    check_list/2,
%%    sql_soul/2,
%%    soul_wear/4,
%%    soul_level_up/5,
%%    get_soul_compose_level/2,
%%    add_soul_point/2,
%%    get_goods_soul_point/1,
%%    get_equip_att_ratio/2,
%%    send_new_soul_info/1
%%]).

%%  物品登陆
soul_login(RoleId, GoodsDict) ->
    ReSql = io_lib:format(?SelectSoulSql, [RoleId]),
    RuneEquipAttList = get_equip_att_ratio(RoleId, GoodsDict),
    case db:get_all(ReSql) of
        [] -> #soul{};
        [[_RoleId, SoulPoint] | _] ->
            GoodsNum = length(get_can_decompose_soul_goods(RoleId, GoodsDict)),
            % ?INFO("GoodsNum:~p~n", [GoodsNum]),
            case GoodsNum >= ?SOUL_LIMIT_2 of
                true -> 
                    RolePid = misc:get_player_process(RoleId),
                    start_soul_auto_decompose_timer(RolePid);
                false -> skip
            end,
            #soul{
                soul_point = SoulPoint,
                equip_add_ratio_attr = RuneEquipAttList
            }
    end.

start_soul_auto_decompose_timer(RolePid) ->
    case misc:is_process_alive(RolePid) of 
        false ->
            skip;
        _ ->
            case get(soul_decompose) of
                undefined ->
                    NewPid = spawn(fun() -> timer:sleep(2000), RolePid ! {'soul_auto_decompose'} end),
                    put(soul_decompose, NewPid);
                Pid ->
                    case is_process_alive(Pid) of 
                        false ->
                            NewPid = spawn(fun() -> timer:sleep(2000), RolePid ! {'soul_auto_decompose'} end),
                            put(soul_decompose, NewPid);
                        true ->
                            skip
                    end
            end
    end.


%% 计算穿在身上的聚魂总属性
count_soul_attribute(SoulWearList) ->
    F = fun(Soul, TotalAttr1) ->
        % #goods{
        %     other = #goods_other{
        %         extra_attr = ExtraAttr   % 扩展附加属性 支持{属性,值}
        %     }
        % } = Soul,
        SoulAttr = count_one_soul_attr(Soul),
        ulists:kv_list_plus_extra([TotalAttr1, SoulAttr])
    end,
    TotalAttr = lists:foldl(F, [], SoulWearList),
    TotalAttr.

%% 计算单个属性
count_one_soul_attr(Soul) ->
    #goods{
        color = Color,
        other = #goods_other{
            extra_attr = ExtraAttr   % 扩展附加属性 支持{属性,值}
        }
    } = Soul,
    AwakeLvList = get_awake_lv_list(Soul),
    F = fun({AttrId, AwakeLv}) ->
        case data_soul:get_soul_awake(Color, AttrId, AwakeLv) of
            [] -> [];
            #soul_awake_con{attr_list = AttrList} -> AttrList
        end
    end,
    AwakeAttrList = lib_player_attr:add_attr(list, lists:map(F, AwakeLvList)),
    util:combine_list(ExtraAttr++AwakeAttrList).

% %% 计算单个聚魂的附加属性
% count_one_soul_attr(SubType, Color, Level) ->
%     SoulAttrNumCon = data_soul:get_soul_attr_num_con(SubType, Level),
%     SoulAttrCoefficientCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
%     if
%         SoulAttrNumCon =:= [] orelse SoulAttrCoefficientCon =:= [] -> [];
%         true ->
%             AttrNumList = SoulAttrNumCon#soul_attr_num_con.attr_num_list,
%             AttrCoefficietList = SoulAttrCoefficientCon#soul_attr_coefficient_con.attr_coefficient_list,
%             F = fun({AttrId, AttrNum}, ExtraAttr1) ->
%                 case lists:keyfind(AttrId, 1, AttrCoefficietList) of
%                     false ->
%                         ExtraAttr1;
%                     {_AttrId, Coefficient} ->
%                         AttrInfo = {AttrId, round(AttrNum * Coefficient / 1000)},
%                         [AttrInfo | ExtraAttr1]
%                 end
%             end,
%             ExtraAttr = lists:foldl(F, [], AttrNumList),
%             ExtraAttr
%     end.

count_one_soul_extra_attr(SubType, Color, Level) ->
    SoulAttrNumCon = data_soul:get_soul_attr_num_con(SubType, Level),
    SoulAttrCoefficientCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
    if
        SoulAttrNumCon =:= [] orelse SoulAttrCoefficientCon =:= [] -> [];
        true ->
            AttrNumList = SoulAttrNumCon#soul_attr_num_con.attr_num_list,
            AttrCoefficietList = SoulAttrCoefficientCon#soul_attr_coefficient_con.attr_coefficient_list,
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

%% 存盘
sql_soul(Soul, RoleId) ->
    #soul{
        soul_point = SoulPoint      %% 聚魂经验
    } = Soul,
    ReSql = io_lib:format(?ReplaceSoulSql, [RoleId, SoulPoint]),
    db:execute(ReSql).

%% 镶嵌聚魂道具
soul_wear(Ps, GS, GoodsInfo, PosId) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_soul_wear(Ps, GS, GoodsInfo, PosId)
        end,
    case lib_goods_util:transaction(F) of
        {ok, NewGoodsId, OldGoodsId, NewGoodsTypeId, GoodsL, NewGS, NewPs1, OldGoodsInfo} ->
            lib_goods_do:set_goods_status(NewGS),
            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR), % 通知更新属性
            %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
            case is_record(OldGoodsInfo, goods) of
                true ->
                    lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [OldGoodsInfo#goods{num = 0}]);
                false ->
                    skip
            end,
            lib_goods_api:notify_client_num(NewGS#goods_status.player_id, [GoodsInfo#goods{num = 0}]),
            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL), % 通知更新物品信息
%%            lib_hi_point_api:hi_point_task_soul_set(NewGS, NewPs),
            {true, ?SUCCESS, NewGoodsId, OldGoodsId, NewGoodsTypeId, NewPs};
        Error ->
            ?ERR("soul error:~p", [Error]),
            {false, ?FAIL}
    end.

do_soul_wear(Ps, GS, GoodsInfo, PosId) ->
    #player_status{id = RoleId, goods = StatusGoods} = Ps,
    #goods{
        location = OriginalLocation,
        cell = OriginalCell
    } = GoodsInfo,
    #goods_status{
        dict = Dict,
        soul = Soul
    } = GS,
    OldGoodsInfo = lib_goods_util:get_goods_by_cell(RoleId, ?GOODS_LOC_SOUL, PosId, Dict), % 根据物品位置取物品
    case is_record(OldGoodsInfo, goods) of
        true ->
            [NewOldGoodsInfo, GS1] = lib_goods:change_goods_cell_and_use(OldGoodsInfo, OriginalLocation, OriginalCell, GS), % 卸下
            [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_SOUL, PosId, GS1), % 更改物品格子位置
            OldGoodsId = NewOldGoodsInfo#goods.id;
        false ->
            OldGoodsId = 0,
            [NewGoodsInfo, NewGS1] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_SOUL, PosId, GS)     % 更改物品格子位置
    end,
    #goods_status{dict = OldGoodsDict} = NewGS1,
    {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict), % 更新dict
    RuneEquipAttList = get_equip_att_ratio(RoleId, NewGoodsDict),
    %%    ?PRINT("RuneEquipAttList :~p~n",[RuneEquipAttList]),
    NewSoul = Soul#soul{equip_add_ratio_attr = RuneEquipAttList},
    NewGS = NewGS1#goods_status{
        dict = NewGoodsDict,
        soul = NewSoul
    },
    SoulWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, NewGoodsDict),
    lib_achievement_api:async_event(Ps#player_status.id, lib_achievement_api, soul_wear_event, SoulWearList),
    SoulAttr = lib_soul:count_soul_attribute(SoulWearList),
    NewStatusGoods = StatusGoods#status_goods{soul_attr = SoulAttr},
    NewPs = Ps#player_status{goods = NewStatusGoods},
    #goods{
        id = NewGoodsId,
        goods_id = NewGoodsTypeId,
        color = Color,
        level = Lv
    } = NewGoodsInfo,
    lib_log_api:log_soul_wear(RoleId, PosId, NewGoodsTypeId, Color, Lv), % 聚魂镶嵌日志
    {ok, NewGoodsId, OldGoodsId, NewGoodsTypeId, GoodsL, NewGS, NewPs, OldGoodsInfo}.

%% 获取装备属性权重
get_equip_att_ratio(RoleId, GoodsDict) ->
    SoulWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, GoodsDict),
    SoulAttr = lib_soul:count_soul_attribute(SoulWearList),
    F = fun({AttrId, AttrNum}, SoulEquipAttList1) ->
        case lists:member(AttrId, ?EQUIP_ADD_RATIO_TYPE ++ ?LV_ADD_RATIO_TYPE ++ [?EQUIP_STREN_ADD_RATIO, ?EQUIP_REFINE_ADD_RATIO]) of
            false ->
                SoulEquipAttList1;
            true ->
                case lists:keyfind(AttrId, 1, SoulEquipAttList1) of
                    false ->
                        [{AttrId, AttrNum} | SoulEquipAttList1];
                    {_AttrId, OldAttrNum} ->
                        lists:keyreplace(AttrId, 1, SoulEquipAttList1, {AttrId, OldAttrNum + AttrNum})
                end
        end
        end,
    SoulEquipAttList = lists:foldl(F, [], SoulAttr),
    %%    ?PRINT("SoulWearList:~p,SoulAttr :~p SoulEquipAttList :~p~n", [SoulWearList, SoulAttr, SoulEquipAttList]),
    SoulEquipAttList.

%% 聚魂升级
soul_level_up(Ps, GS, GoodsInfo, NewSoul, NeedSoulPoint) ->
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        do_soul_level_up(Ps, GS, GoodsInfo, NewSoul, NeedSoulPoint)
        end,
    case lib_goods_util:transaction(F) of
        {ok, Location, GoodsL, NewGS, NewPs1} ->
            lib_goods_do:set_goods_status(NewGS),
            case Location of
                ?GOODS_LOC_SOUL ->
                    SoulWearList = lib_goods_util:get_goods_list(Ps#player_status.id, ?GOODS_LOC_SOUL, NewGS#goods_status.dict),
                    lib_achievement_api:async_event(Ps#player_status.id, lib_achievement_api, soul_level_event, SoulWearList),
                    {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
%%                    lib_hi_point_api:hi_point_task_soul_lv(NewGS, NewPs),
                    lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR);
                _ ->
                    NewPs = NewPs1
            end,
            lib_goods_api:notify_client(NewGS#goods_status.player_id, GoodsL),
            {true, ?SUCCESS, NewPs};
        Error ->
            ?ERR("soul error:~p", [Error]),
            {false, ?FAIL, Ps}
    end.

do_soul_level_up(Ps, GS, GoodsInfo, NewSoul1, NeedSoulPoint) ->
    #player_status{id = RoleId, goods = StatusGoods} = Ps,
    #goods{
        goods_id = GoodsTypeId,
        subtype = SubType,
        %%        cell = Cell,
        color = Color,
        level = Level,
        location = Location
    } = GoodsInfo,
    NewLevel = Level + 1,
    ExtraAttr = lib_soul:count_one_soul_extra_attr(SubType, Color, NewLevel),
    [_NewGoodsInfo, NewGS1] = lib_goods:change_goods_level_extra_attr(GoodsInfo, Location, NewLevel, ExtraAttr, GS),
    #goods_status{
        dict = OldGoodsDict
    } = NewGS1,
    {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    RuneEquipAttList = get_equip_att_ratio(RoleId, NewGoodsDict),
    NewSoul = NewSoul1#soul{
        equip_add_ratio_attr = RuneEquipAttList
    },
    sql_soul(NewSoul, RoleId),
    NewGS = NewGS1#goods_status{
        dict = NewGoodsDict,
        soul = NewSoul
    },
    case Location of
        ?GOODS_LOC_SOUL ->
            SoulWearList = lib_goods_util:get_goods_list(Ps#player_status.id, ?GOODS_LOC_SOUL, NewGoodsDict),
            SoulAttr = lib_soul:count_soul_attribute(SoulWearList),
            NewStatusGoods = StatusGoods#status_goods{
                soul_attr = SoulAttr
            },
            NewPs = Ps#player_status{
                goods = NewStatusGoods
            };
        _ ->
            NewPs = Ps
    end,
    lib_log_api:log_soul_level_up(RoleId, GoodsTypeId, Level, NewLevel, NeedSoulPoint),
    {ok, Location, GoodsL, NewGS, NewPs}.

%% 计算和操作聚魂分解(会记录日志的)
%% @return {level}
% get_soul_compose_level(ComposeGoodsCon, UpdateGoodsList) ->
calc_and_do_soul_compose(ComposeGoodsCon, UpdateGoodsList) ->
    #ets_goods_type{
        goods_id = NewGoodsTypeId,
        subtype = SubType,
        color = Color
    } = ComposeGoodsCon,
    F = fun(GoodsInfo, {TotalSoulPoint1, LogGoodsList1, SumAwakeLvList}) ->
        #goods{
            goods_id = GoodsTypeId, % 物品id
            type = Type, % 物品类型
            level = Level1              % 物品等级
        } = GoodsInfo,
        AwakeLvList = get_awake_lv_list(GoodsInfo),
        case Type of
            ?GOODS_TYPE_SOUL ->
                SoulPoint1 = get_goods_soul_point(GoodsInfo),
                {TotalSoulPoint1 + SoulPoint1, [{GoodsTypeId, Level1, AwakeLvList} | LogGoodsList1], AwakeLvList++SumAwakeLvList};
            _ ->
                {TotalSoulPoint1, LogGoodsList1, SumAwakeLvList}
        end
    end,
    {TotalSoulPoint, LogGoodsList, AwakeLvList} = lists:foldl(F, {0, [], []}, UpdateGoodsList),
    SoulAllLvList = data_soul:get_soul_all_lv(SubType),
    {Level, LessSoulPoint} = level_up_by_point(SubType, Color, TotalSoulPoint, 1, length(SoulAllLvList)),
    GS = lib_goods_do:get_goods_status(),
    NewGS = add_soul_point(LessSoulPoint, GS),
    lib_goods_do:set_goods_status(NewGS),
    CombineAwakeLvList = util:combine_list(AwakeLvList),
    lib_log_api:log_soul_compose(NewGS#goods_status.player_id, LogGoodsList, NewGoodsTypeId, Level, CombineAwakeLvList, 
        GS#goods_status.soul#soul.soul_point, NewGS#goods_status.soul#soul.soul_point),
    {Level, AwakeLvList}.

level_up_by_point(_SubType, _Color, TotalSoulPoint, MaxLevel, MaxLevel) ->
    {MaxLevel, TotalSoulPoint};
level_up_by_point(SubType, Color, TotalSoulPoint, Level, MaxLevel) ->
    NewLevel = Level + 1,
    SoulAttrNumCon = data_soul:get_soul_attr_num_con(SubType, NewLevel),
    SoulAttrCoefficientCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
    case SoulAttrNumCon =:= [] orelse SoulAttrCoefficientCon =:= [] of
        true ->
            {Level, TotalSoulPoint};
        false ->
            SoulNum = SoulAttrNumCon#soul_attr_num_con.lv_up_num,
            SoulCoefficient = SoulAttrCoefficientCon#soul_attr_coefficient_con.lv_up_coefficient,
            %%          聚魂点数公式 = 升级经验值 * 升级系数 / 1000
            SoulPoint1 = round(SoulNum * SoulCoefficient / 1000),
            case TotalSoulPoint >= SoulPoint1 andalso SoulPoint1 > 0 of
                true ->
                    level_up_by_point(SubType, Color, TotalSoulPoint - SoulPoint1, NewLevel, MaxLevel);
                false ->
                    {Level, TotalSoulPoint}
            end
    end.

%% 获取物品的聚魂经验
get_goods_soul_point(GoodsInfo) ->
    #goods{
        subtype = SubType,
        color = Color,
        level = Level
    } = GoodsInfo,
    get_goods_soul_point_1(SubType, Color, Level, 0).

get_goods_soul_point_1(_SubType, _Color, 1, SoulPoint) ->
    SoulPoint;
get_goods_soul_point_1(SubType, Color, Level, SoulPoint) ->
    SoulAttrNumCon = data_soul:get_soul_attr_num_con(SubType, Level),
    SoulAttrCoefficientCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
    SoulNum = SoulAttrNumCon#soul_attr_num_con.lv_up_num,
    SoulCoefficient = SoulAttrCoefficientCon#soul_attr_coefficient_con.lv_up_coefficient,
    %%  聚魂点数公式 = 升级经验值 * 升级系数 / 1000
    SoulPoint1 = round(SoulNum * SoulCoefficient / 1000),
    get_goods_soul_point_1(SubType, Color, Level - 1, SoulPoint + SoulPoint1).

add_soul_point(Num, GS) ->
    #goods_status{player_id = RoleId, soul = Soul} = GS,
    #soul{soul_point = SoulPoint} = Soul,
    NewSoul = Soul#soul{
        soul_point = SoulPoint + Num
    },
    sql_soul(NewSoul, RoleId),
    %%   增加经验值更新客户端数据
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_soul, send_new_soul_info, []), % 不处理在线情况
    GS#goods_status{soul = NewSoul}.

send_new_soul_info(Ps) ->
    pp_soul:handle(17005, Ps, []).


%% -----------------------------------------------------------------
%% @desc     功能描述  聚魂合成预览
%% @param    参数      RuleId::integer  规则Id ,
%%                     GoodIdList::lists [{goood_id}] 物品id列表
%% @return   返回值     {ok, Lv} | {false, Res}
%% -----------------------------------------------------------------
get_compose_Lv(RuleId, GoodIdList, Ps) ->
    case get_compose_lv_check(RuleId, GoodIdList, Ps) of
        true ->
            UpdateGoodsList = [lib_goods_api:get_goods_info(GoodId) || GoodId <- GoodIdList],
            #goods_compose_cfg{goods = Goods} = data_goods_compose:get_cfg(RuleId), %%check   已经检查了，必定是这个record
            if
                Goods == [] ->
                    {false, ?MISSING_CONFIG};
                true ->
                    [{_Type, GId, _Num} | _] = Goods,
                    case data_goods_type:get(GId) of
                        [] ->
                            {false, ?MISSING_CONFIG};
                        GoodsType ->
                            Lv = get_soul_compose_level_preview(GoodsType, UpdateGoodsList),
                            {ok, Lv}
                    end
            end;
        {false, Res} ->
            {false, Res}
    end.

%% 聚魂预览等级
get_soul_compose_level_preview(ComposeGoodsCon, UpdateGoodsList) ->
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
            ?GOODS_TYPE_SOUL ->
                RunePoint1 = get_goods_soul_point(GoodsInfo), %%获取这个符文的经验
                {TotalRunePoint1 + RunePoint1, [{GoodsTypeId, Level1} | LogGoodsList1]};
            _ ->
                {TotalRunePoint1, LogGoodsList1}
        end
        end,
    %%获取消耗聚魂所有经验和消耗符文的等级和类型 {GoodTypeId,Level}
    {TotalRunePoint, _LogGoodsList} = lists:foldl(F, {0, []}, UpdateGoodsList),
    SoulAllLvList = data_soul:get_soul_all_lv(SubType), %%获取这个子类型的所有聚魂等级
    {Level, _LessRunePoint} = level_up_by_point(SubType, Color, TotalRunePoint, 1, length(SoulAllLvList)),
    Level.


%% -----------------------------------------------------------------
%% @desc     功能描述  符文分解预览,获取分解后的总经验
%% @param    参数
%%                     GoodIdList::lists [{goood_id}] 物品id列表
%% @return   返回值     {ok, Exp,ResList} | {false, Res}
%% -----------------------------------------------------------------
get_decompose_exp(GoodIdList, Ps) ->
    case get_decompose_exp_check(GoodIdList, Ps) of
        true ->
            GoodsList = [lib_goods_api:get_goods_info(GoodId) || GoodId <- GoodIdList],
            F = fun(GoodInfo, {AccExp, AccResList}) ->
                #goods{goods_id = GTypeId} = GoodInfo,
                #goods_decompose_cfg{regular_mat = RegularMat} = data_goods_decompose:get(GTypeId), %%必定有，检查过了
                {RegularExp, TempResList} =
                    case RegularMat of
                        [] -> 0;
                        RegularMat ->
                            {_RegularExp, _TempResList} = get_regular_mat(RegularMat)
                    end,
                TempExp = get_goods_soul_point(GoodInfo) + RegularExp,
                {AccExp + TempExp, AccResList ++ TempResList}
                end,
            {Exp, ResList} = lists:foldl(F, {0, []}, GoodsList),
            ComposeResList = ulists:object_list_plus([ResList, []]),
            {ok, Exp, ComposeResList};
        {false, Res} ->
            {false, Res}
    end.


%% 检查合成的条件
get_compose_lv_check(RuleId, GoodIdList, Ps) ->
    CheckList = [
        {check_rule, RuleId}         %%检查配置
        , {check_goods, GoodIdList}   %%检查
    ],
    check_list(CheckList, Ps).

%% 检查分解条件
get_decompose_exp_check(GoodIdList, Ps) ->
    CheckList = [
        {check_goods, GoodIdList}   %%检查
        , {check_config, GoodIdList} %%检查分解规则
    ],
    check_list(CheckList, Ps).

%%-------------------- check list -------------------------
check_list([], _Ps) -> true;
check_list([T | G], Ps) ->
    case check(T, Ps) of
        true ->
            check_list(G, Ps);
        {false, Res} ->
            {false, Res}
    end.

%% 检查等级是否满足
check({lv, NeedLv}, Ps) ->
    Lv = Ps#player_status.figure#figure.lv,
    case Lv >= NeedLv of
        true -> true;
        false -> {false, ?ERRCODE(err170_pos_not_active)}
    end;

%% 检查规则
check({check_rule, RuleId}, _Ps) ->
    ComposeCfg = data_goods_compose:get_cfg(RuleId),
    if
        is_record(ComposeCfg, goods_compose_cfg) =:= false ->
            {false, ?ERRCODE(missing_config)};
        true ->
            true
    end;

%% 检查物品是否存在
check({check_goods, GoodIdList}, _Ps) ->
    case get_goods_list(GoodIdList) of
        true -> true;
        false -> {false, ?ERRCODE(err170_goods_fail)}  %%物品不存在,或者不是符文
    end;

%% 检查物品分解
check({check_config, GoodIdList}, _Ps) ->
    case get_decompose_config(GoodIdList) of
        true -> true;
        false -> {false, ?MISSING_CONFIG}  %%分解缺失配置
    end;

check(_, _Ps) ->
    true.


%%--------------------  check interal ----------------------

%% -----------------------------------------------------------------
%% @desc     功能描述   将固定分解的奖励分类，分为经验和一般道具
%% @param    参数       RegularMat::lists     [Type,GoodsTypeId, num]
%% @return   返回值     {Exp, ResList}         {经验， 物品}
%% -----------------------------------------------------------------
get_regular_mat(RegularMat) ->
    get_regular_mat(RegularMat, {0, []}).

get_regular_mat([], {Exp, ResList}) ->
    {Exp, ResList};
get_regular_mat([{Type, GoodsTypeId, Num} | T], {Exp, ResList}) ->
    case Type of
        ?TYPE_SOUL ->
            get_regular_mat(T, {Exp + Num, ResList});
        _ ->
            get_regular_mat(T, {Exp, [{Type, GoodsTypeId, Num} | ResList]})
    end.



get_goods_list([]) -> true;
get_goods_list([H | T]) ->
    case lib_goods_api:get_goods_info(H) of
        [] ->
            ?PRINT("--------------null~n", []),
            false;
        GoodsInfo ->
            #goods{type = Type} = GoodsInfo,
            case Type of
                ?GOODS_TYPE_SOUL -> get_goods_list(T);
                _ ->
                    ?PRINT("Type:~p~n", [Type]),
                    false
            end
    end.

get_decompose_config([]) -> true;
get_decompose_config([H | T]) ->
    case lib_goods_api:get_goods_info(H) of
        [] -> false;
        #goods{goods_id = Id} ->
            case data_goods_decompose:get(Id) of
                [] -> false;
                _ -> get_decompose_config(T)
            end
    end.

%% 检查特殊属性
check_other_special_attr(SoulAttrCoeCon, SubTypeGoods, SoulWearList) ->
    SoulSpecialAttrId =
        case SoulAttrCoeCon#soul_attr_coefficient_con.attr_coefficient_list of
            [{Attr1, _}, _] ->
                case lists:member(Attr1, ?LV_ADD_RATIO_TYPE) of
                    true -> Attr1;
                    false -> skip
                end;
            _ -> skip
        end,
    SoulListExpectAttr =
    case SubTypeGoods of
        false ->  % 没有同类型
            [];
        _ ->
            DeleteSoulWear = lists:keydelete(SubTypeGoods#goods.subtype, #goods.subtype, SoulWearList),
            count_soul_attribute(DeleteSoulWear)
    end,
    case lists:keyfind(SoulSpecialAttrId, 1, SoulListExpectAttr) of
        false ->        % 其他部位没有该属性
            true;
        _ ->
            false
    end.

%% 聚魂other_data的保存格式
%% AwakeLvList : [{TypeId, Level},...]
format_other_data(#goods{type = ?GOODS_TYPE_SOUL, other = Other}) ->
    #goods_other{optional_data = AwakeLvList} = Other,
    [?GOODS_OTHER_KEY_SOUL, AwakeLvList];

format_other_data(_) ->
    [].

%% 聚魂物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [AwakeLvList|_]) ->
    Other#goods_other{optional_data = AwakeLvList}.

%% 更新 goods_other
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

%% 唤醒
%% @retutn {ok, Ps} | {false, ErrCode, Ps}
awake(Ps, GoodsId, AttrId, CostGoodsIdL) ->
    case check_awake(Ps, GoodsId, AttrId, CostGoodsIdL) of
        {false, ErrCode} -> {false, ErrCode, Ps};
        {true, Cost, DelGoodsInfoL, OldAwakeLvList, OldLevel, NewAwakeLv, NewGoodsInfo, LessSoulPoint} ->
            % About = lists:concat(["AttrId:", AttrId]),
            % case lib_goods_api:cost_object_list_with_check(Ps, Cost, soul_awake, About) of
            %     {false, ErrCode, NewPs} -> {false, ErrCode, NewPs};
            %     {true, NewPs} -> do_awake(NewPs, Cost, OldAwakeLvList, NewAwakeLv, NewGoodsInfo)
            % end
            do_awake(Ps, Cost, DelGoodsInfoL, OldAwakeLvList, OldLevel, NewAwakeLv, NewGoodsInfo, LessSoulPoint)
    end.

check_awake(_Ps, GoodsId, AttrId, CostGoodsIdL) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    UsortCostGoodsIdL = lists:usort(CostGoodsIdL),
    IsMember = lists:member(GoodsId, UsortCostGoodsIdL),
    if
        GoodsInfo =:= [] -> {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.type =/= ?GOODS_TYPE_SOUL -> {false, ?ERRCODE(err170_not_soul)};
        IsMember -> {false, ?ERRCODE(err170_not_cost_self_to_awake)};
        true ->
            #goods{
                subtype = SubType,
                level = Level,
                color = Color,
                other = Other
            } = GoodsInfo,
            AwakeLv = get_awake_lv(GoodsInfo, AttrId),
            NewAwakeLv = AwakeLv + 1,
            SoulNumConCfg = data_soul:get_soul_attr_num_con(SubType, Level),
            AwakeCfg = data_soul:get_soul_awake(Color, AttrId, NewAwakeLv),
            % ?MYLOG("hjhsoul", "SubType:~p, Level:~p SoulNumConCfg:~p ~n", [SubType, Level, SoulNumConCfg]),
            % ?MYLOG("hjhsoul", "Color:~p, AttrId:~p, NewAwakeLv:~p AwakeCfg:~p ~n", [Color, AttrId, NewAwakeLv, AwakeCfg]),
            case is_record(SoulNumConCfg, soul_attr_num_con) andalso is_record(AwakeCfg, soul_awake_con) of
                true -> 
                    % 是否有配置
                    CfgBool = true,
                    #soul_attr_num_con{attr_num_list = AttrNumList} = SoulNumConCfg,
                    #soul_awake_con{attr_list = AwakeAttrL} = AwakeCfg,
                    % 唤醒的属性是否存在
                    IsAttrCfg = lists:keymember(AttrId, 1, AttrNumList) andalso lists:keymember(AttrId, 1, AwakeAttrL);
                false ->
                    CfgBool = false,
                    IsAttrCfg = false   
            end,
            ?MYLOG("hjhsoul", "CfgBool:~p IsAttrCfg:~p ~n", [CfgBool, IsAttrCfg]),
            if
                CfgBool == false -> {false, ?MISSING_CONFIG};
                % 唤醒的属性是否存在
                IsAttrCfg == false -> {false, ?MISSING_CONFIG};
                true -> 
                    #soul_awake_con{cost = Cost} = AwakeCfg,
                    case check_awake_cost(UsortCostGoodsIdL, Cost, []) of
                        {false, ErrCode} -> 
                            ?MYLOG("hjhsoul", "ErrCode:~p UsortCostGoodsIdL:~p Cost:~p ~n", [ErrCode, UsortCostGoodsIdL, Cost]), 
                            {false, ErrCode};
                        {true, DelGoodsInfoL} ->
                            ?MYLOG("hjhsoul", "DelGoodsInfoL:~p ~n", [[{GoodsTypeId, Num}||{#goods{goods_id = GoodsTypeId}, Num}<-DelGoodsInfoL]]),
                            AwakeLvList = get_awake_lv_list(GoodsInfo),
                            NewAwakeLvList = lists:keystore(AttrId, 1, AwakeLvList, {AttrId, NewAwakeLv}),
                            % 源力经验
                            F = fun(TmpGoodsInfo, TotalSoulPoint) ->
                                #goods{
                                    type = Type
                                } = TmpGoodsInfo,
                                case Type of
                                    ?GOODS_TYPE_SOUL ->
                                        SoulPoint1 = get_goods_soul_point(TmpGoodsInfo),
                                        TotalSoulPoint + SoulPoint1;
                                    _ ->
                                        TotalSoulPoint
                                end
                            end,
                            DelGoodsL = [TmpGoodsInfo||{TmpGoodsInfo, _Num}<-DelGoodsInfoL],
                            TotalSoulPoint = lists:foldl(F, 0, [GoodsInfo|DelGoodsL]),
                            SoulAllLvList = data_soul:get_soul_all_lv(SubType),
                            {NewLevel, LessSoulPoint} = level_up_by_point(SubType, Color, TotalSoulPoint, 1, length(SoulAllLvList)),
                            % 赋值
                            NewGoodsInfo = GoodsInfo#goods{level = NewLevel, other = Other#goods_other{optional_data = NewAwakeLvList}},
                            {true, Cost, DelGoodsInfoL, AwakeLvList, Level, NewAwakeLv, NewGoodsInfo, LessSoulPoint}
                    end
            end
    end.

%% 获取消耗物品
check_awake_cost([], [], Result) -> {true, Result};
check_awake_cost([], _Cost, _Result) -> {false, ?GOODS_NOT_ENOUGH};
check_awake_cost([GoodsId|T], Cost, Result) ->
    case lib_goods_api:get_goods_info(GoodsId) of
        #goods{goods_id = GoodsTypeId, num = Num} = GoodsInfo ->
            AwakeLvList = [{AttrId, AwakeLv}||{AttrId, AwakeLv}<-get_awake_lv_list(GoodsInfo), AwakeLv>0],
            if
                % 觉醒不能消耗
                length(AwakeLvList) > 0 -> {false, ?ERRCODE(err170_not_cost_awake_soul)};
                true ->
                    ?MYLOG("hjhsoul", "GoodsId:~p GoodsTypeId:~p Cost:~p ~n", [GoodsId, GoodsTypeId, Cost]), 
                    case lists:keyfind(GoodsTypeId, 2, Cost) of
                        false -> {false, ?MISSING_CONFIG};
                        {Type, GoodsTypeId, LeftNum} when LeftNum >= Num ->
                            NewResult = [{GoodsInfo, Num}|Result],
                            NewLeftNum = LeftNum - Num,
                            NewCost = ?IF(LeftNum==Num, 
                                lists:keydelete(GoodsTypeId, 2, Cost), 
                                lists:keyreplace(GoodsTypeId, 2, Cost, {Type, GoodsTypeId, NewLeftNum})),
                            check_awake_cost(T, NewCost, NewResult);
                        {_Type, GoodsTypeId, LeftNum} when LeftNum < Num ->
                            NewResult = [{GoodsInfo, LeftNum}|Result],
                            NewCost = lists:keydelete(GoodsTypeId, 2, Cost), 
                            check_awake_cost(T, NewCost, NewResult)
                    end
            end;
        _ ->
            {false, ?ERRCODE(err150_no_goods)}
    end.

%% 唤醒
do_awake(Ps, Cost, DelGoodsInfoL, OldAwakeLvList, OldLevel, NewAwakeLv, NewGoodsInfo, LessSoulPoint) ->
    #player_status{id = RoleId, goods = StatusGoods} = Ps,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{soul = Soul} = GoodsStatus,
    F = fun() ->
        ok = lib_goods_dict:start_dict(),
        % 删除物品
        {ok, GoodsStatusAfDel} = lib_goods:delete_goods_list(GoodsStatus, DelGoodsInfoL),
        % 更新物品数据
        change_goods_other(NewGoodsInfo),
        % DictAfUp = lib_goods_dict:append_dict({add, goods, NewGoodsInfo}, GoodsStatusAfDel#goods_status.dict),
        % % 通知
        % {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(DictAfUp),
        % 更新等级
        #goods{subtype = SubType, location = Location, level = NewLevel, color = Color} = NewGoodsInfo,
        ExtraAttr = lib_soul:count_one_soul_extra_attr(SubType, Color, NewLevel),
        [_NewGoodsInfo, GoodsStatusAfLv] = lib_goods:change_goods_level_extra_attr(NewGoodsInfo, Location, NewLevel, ExtraAttr, GoodsStatusAfDel),
        {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(GoodsStatusAfLv#goods_status.dict),
        NewGoodsStatus = GoodsStatusAfLv#goods_status{dict = Dict},
        % 属性变化
        case NewGoodsInfo#goods.location of
            ?GOODS_LOC_SOUL ->
                % 装备百分比
                RuneEquipAttList = get_equip_att_ratio(RoleId, Dict),
                NewSoul = Soul#soul{
                    equip_add_ratio_attr = RuneEquipAttList
                },
                GoodsStatusAfEquip = NewGoodsStatus#goods_status{soul = NewSoul},
                % 属性计算
                SoulWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, Dict),
                SoulAttr = lib_soul:count_soul_attribute(SoulWearList),
                NewStatusGoods = StatusGoods#status_goods{
                    soul_attr = SoulAttr
                },
                PsAfGoods = Ps#player_status{
                    goods = NewStatusGoods
                };
            _ ->
                GoodsStatusAfEquip = NewGoodsStatus,
                PsAfGoods = Ps
        end,
        {ok, PsAfGoods, GoodsStatusAfEquip, GoodsL}
    end,
    case lib_goods_util:transaction(F) of
        {ok, PsAfGoods, NewGoodsStatus, GoodsL} ->
            % 增加聚魂经验
            GoodsStatusAfAdd = add_soul_point(LessSoulPoint, NewGoodsStatus),
            lib_goods_do:set_goods_status(GoodsStatusAfAdd),
            lib_goods_api:notify_client(RoleId, GoodsL),
            ?MYLOG("hjhsoul", "NewGoodsInfo:~p GoodsL:~p ~n", [NewGoodsInfo, GoodsL]),
            % 装备的聚魂要计算战力
            case NewGoodsInfo#goods.location of
                ?GOODS_LOC_SOUL ->
                    {ok, PsAfCount} = lib_goods_util:count_role_equip_attribute(PsAfGoods),
                    lib_player:send_attribute_change_notify(PsAfCount, ?NOTIFY_ATTR);
                _ ->
                    PsAfCount = PsAfGoods
            end,
            %% 扣除指定物品日志
            F1 = fun({TmpGoodsInfo, TmpNum}) ->
                #goods{id = TmpGoodsId, goods_id = TmpGoodsTypeId, level = TmpLevel} = TmpGoodsInfo,
                lib_log_api:log_throw(soul_awake, RoleId, TmpGoodsId, TmpGoodsTypeId, TmpNum, 0, 0),
                {TmpGoodsId, TmpGoodsTypeId, TmpLevel, TmpNum}
            end,
            CostInfoL = lists:map(F1, DelGoodsInfoL),
            #goods{id = GoodsId, goods_id = GoodsTypeId, level = NewLevel} = NewGoodsInfo,
            AwakeLvList = get_awake_lv_list(NewGoodsInfo),
            lib_log_api:log_soul_awake(RoleId, GoodsId, GoodsTypeId, Cost, CostInfoL, OldAwakeLvList, AwakeLvList,
                OldLevel, NewLevel, GoodsStatus#goods_status.soul#soul.soul_point, GoodsStatusAfAdd#goods_status.soul#soul.soul_point),
            {ok, PsAfCount, NewAwakeLv, NewLevel};
        Error ->
            ?ERR("do_awake NewGoodsInfo:~p Error:~p~n", [NewGoodsInfo, Error]),
            {false, ?FAIL, Ps}
    end.

%% 获得属性觉醒列表
get_awake_lv_list(#goods{type = Type}) when Type =/= ?GOODS_TYPE_SOUL -> [];
get_awake_lv_list(#goods{other = #goods_other{optional_data = OptionalData}} = _GoodsInfo) ->
    case is_list(OptionalData) of
        true -> OptionalData;
        false -> []
    end;
get_awake_lv_list(_) ->
    [].

%% 获得指定属性的觉醒等级
%% @param GoodsInfo #goods{} | []
get_awake_lv(GoodsInfo, AttrId) ->
    AwakeList = get_awake_lv_list(GoodsInfo),
    case lists:keyfind(AttrId, 1, AwakeList) of
        false -> 0;
        {AttrId, AwakeLv} -> AwakeLv
    end.

%% 聚魂拆解
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
                        {ok, PsAfMulti, MultiGoodsL} -> {ok, PsAfMulti, SingleGoodsL++MultiGoodsL}
                    end
            end
    end.
    % case check_dismantle_awake(Ps, GoodsId) of
    %     {false, ErrCode} -> {false, ErrCode, Ps};
    %     {true, single_attr, NewGoodsInfo, AwakeLvList, ReturnGoodsL} -> do_dismantle_awake_for_single_attr(Ps, NewGoodsInfo, AwakeLvList, ReturnGoodsL);
    %     {true, multi_attr, DelGoodsInfo, AwakeLvList, ReturnGoodsL} -> do_dismantle_awake_for_multi_attr(Ps, DelGoodsInfo, AwakeLvList, ReturnGoodsL)
    % end.

split_dismantle_awake(_Ps, [], {SingleL, MultiL}) -> {SingleL, MultiL};
split_dismantle_awake(Ps, [GoodsId|GoodsIdL], {SingleL, MultiL}) ->
    case check_dismantle_awake(Ps, GoodsId) of
        {false, ErrCode} -> {false, ErrCode};
        {true, single_attr, NewGoodsInfo, AwakeLvList, ReturnGoodsL} ->
            NewSingleL = [{NewGoodsInfo, AwakeLvList, ReturnGoodsL}|SingleL],
            split_dismantle_awake(Ps, GoodsIdL, {NewSingleL, MultiL});
        {true, multi_attr, DelGoodsInfo, DelAwakeLvList, ReturnGoodsL} ->
            NewMultiL = [{DelGoodsInfo, DelAwakeLvList, ReturnGoodsL}|MultiL],
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
        GoodsInfo#goods.type =/= ?GOODS_TYPE_SOUL -> {false, ?ERRCODE(err170_not_soul)};
        GoodsInfo#goods.location =:= ?GOODS_LOC_SOUL -> {false, ?ERRCODE(err170_have_wear)};
        true ->
            #goods{
                subtype = SubType,
                color = Color
            } = GoodsInfo,
            SoulAttrCoeCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
            if
                is_record(SoulAttrCoeCon, soul_attr_coefficient_con) == false -> {false, ?MISSING_CONFIG};
                SoulAttrCoeCon#soul_attr_coefficient_con.attr_num == 1 -> check_dismantle_awake_for_single_attr(Ps, GoodsInfo);
                SoulAttrCoeCon#soul_attr_coefficient_con.attr_num > 1 -> check_dismantle_awake_for_multi_attr(Ps, GoodsInfo);
                true -> {false, ?MISSING_CONFIG}
            end
    end.

%% 检查聚魂拆解(单属性)
%% 获得 原物品+觉醒拆除的物品
check_dismantle_awake_for_single_attr(_Ps, GoodsInfo) ->
    #goods{
        color = Color,
        other = Other
    } = GoodsInfo,
    AwakeLvList = [{AttrId, AwakeLv}||{AttrId, AwakeLv}<-get_awake_lv_list(GoodsInfo), AwakeLv>0],
    F = fun({AttrId, AwakeLv}) -> is_record(data_soul:get_soul_awake(Color, AttrId, AwakeLv), soul_awake_con) end,
    IsAllHadCfg = lists:all(F, AwakeLvList),
    if
        length(AwakeLvList) == 0 -> {false, ?ERRCODE(err170_no_awake_single_attr_not_to_dismantle)};
        IsAllHadCfg == false -> {false, ?MISSING_CONFIG};
        true -> 
            NewGoodsInfo = GoodsInfo#goods{other = Other#goods_other{optional_data = []}},
            F2 = fun({AttrId, AwakeLv}, ReturnGoodsL) ->
                #soul_awake_con{back_cost = BackCost} = data_soul:get_soul_awake(Color, AttrId, AwakeLv),
                BackCost ++ ReturnGoodsL
            end,
            ReturnGoodsL = lib_goods_api:make_reward_unique(lists:foldl(F2, [], AwakeLvList)),
            {true, single_attr, NewGoodsInfo, AwakeLvList, ReturnGoodsL}
    end.

%% 处理聚魂拆解(单属性)
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
                ClientReturnGoodsL = lib_goods_api:make_reward_unique([{?TYPE_GOODS, GoodsTypeId, 1}]++ReturnGoodsL),
                {ReturnGoodsL ++ SumReturnGoodsL, [{GoodsId, ClientReturnGoodsL}|SingleGoodsL]}
            end,
            {SumReturnGoodsL, SingleGoodsL} = lists:foldl(F3, {[], []}, SingleL), 
            CombineReturnGoodsL = lib_goods_api:make_reward_unique(SumReturnGoodsL),
            Produce = #produce{type = soul_dismantle_awake, reward = CombineReturnGoodsL},
            {ok, PsAfReward} = lib_goods_api:send_reward_with_mail(Ps, Produce),
            % 日志
            F4 = fun({TmpGoodsInfo, AwakeLvList, ReturnGoodsL}) ->
                #goods{id = GoodsId, goods_id = GoodsTypeId} = TmpGoodsInfo,
                lib_log_api:log_soul_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsL++[{?TYPE_GOODS, GoodsTypeId, 1}])
            end,
            lists:foreach(F4, SingleL),
            % ?MYLOG("hjhsoul", "GoodsL:~p CombineReturnGoodsL:~p ~n", [GoodsL, CombineReturnGoodsL]),
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
    AwakeLvList = [{AttrId, AwakeLv}||{AttrId, AwakeLv}<-get_awake_lv_list(GoodsInfo), AwakeLv>0],
    F = fun({AttrId, AwakeLv}) -> is_record(data_soul:get_soul_awake(Color, AttrId, AwakeLv), soul_awake_con) end,
    IsAllHadCfg = lists:all(F, AwakeLvList),
    case lib_goods_check:count_decompose_reward(Ps, [{GoodsInfo, 1}], []) of
        {ok, DecomposeRewardList} -> CheckDecompose = true;
        {fail, ErrorCode} -> 
            DecomposeRewardList = [],
            CheckDecompose = {false, ErrorCode}
    end,
    if
        IsAllHadCfg == false -> {false, ?MISSING_CONFIG};
        CheckDecompose =/= true -> CheckDecompose;
        true -> 
            F2 = fun({AttrId, AwakeLv}, ReturnGoodsL) ->
                #soul_awake_con{back_cost = BackCost} = data_soul:get_soul_awake(Color, AttrId, AwakeLv),
                BackCost ++ ReturnGoodsL
            end,
            ReturnGoodsL = lib_goods_api:make_reward_unique(lists:foldl(F2, DecomposeRewardList, AwakeLvList)),
            {true, multi_attr, GoodsInfo, AwakeLvList, ReturnGoodsL}
    end.

%% 处理聚魂拆解(多属性)
do_dismantle_awake_for_multi_attr(Ps, []) -> {ok, Ps, []};
do_dismantle_awake_for_multi_attr(Ps, MultiL) -> %DelGoodsInfo, AwakeLvList, ReturnGoodsL) ->
    #player_status{id = RoleId} = Ps,
    F = fun({#goods{id = GoodsId}, _, _}) -> {GoodsId, 1} end,
    CostL = lists:map(F, MultiL),
    case lib_goods_api:delete_more_by_list(Ps, CostL, soul_dismantle_awake) of
        1 ->
            % 返还材料
            F2 = fun({#goods{id = GoodsId}=GoodsInfo, _AwakeLvList, ReturnGoodsL}, {SumReturnGoodsL, MultiGoodsL}) ->
                ?MYLOG("hjhsoul", "GoodsId:~p BinD:~p ReturnGoodsL:~p ~n", [GoodsInfo#goods.goods_id, GoodsInfo#goods.bind, ReturnGoodsL]), 
                {ReturnGoodsL ++ SumReturnGoodsL, [{GoodsId, ReturnGoodsL}|MultiGoodsL]}
            end,
            {SumReturnGoodsL, MultiGoodsL} = lists:foldl(F2, {[], []}, MultiL), 
            CombineReturnGoodsL = lib_goods_api:make_reward_unique(SumReturnGoodsL),
            Produce = #produce{type = soul_dismantle_awake, reward = CombineReturnGoodsL},
            {ok, PsAfReward} = lib_goods_api:send_reward_with_mail(Ps, Produce),
            % 日志
            F3 = fun({TmpGoodsInfo, AwakeLvList, ReturnGoodsL}) ->
                #goods{id = GoodsId, goods_id = GoodsTypeId} = TmpGoodsInfo,
                lib_log_api:log_soul_dismantle_awake(RoleId, GoodsId, GoodsTypeId, AwakeLvList, ReturnGoodsL)
            end,
            lists:foreach(F3, MultiL),
            {ok, PsAfReward, MultiGoodsL};
        ErrCode ->
            {false, ErrCode, Ps}
    end.

%% 检查是否能分解
check_goods_decompose_other(#goods{type = Type}) when Type =/= ?GOODS_TYPE_SOUL ->
    {fail, ?MISSING_CONFIG};
check_goods_decompose_other(#goods{location = ?GOODS_LOC_SOUL} = _GoodsInfo) ->
    {fail, ?ERRCODE(err150_decompose_wear)};
check_goods_decompose_other(GoodsInfo) ->
    #goods{
        subtype = SubType,
        color = Color
    } = GoodsInfo,
    SoulAttrCoeCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
    AwakeLvList = [{AttrId, AwakeLv}||{AttrId, AwakeLv}<-get_awake_lv_list(GoodsInfo), AwakeLv>0],
    if
        is_record(SoulAttrCoeCon, soul_attr_coefficient_con) == false -> {fail, ?MISSING_CONFIG};
        % 觉醒不能分解
        length(AwakeLvList) > 0 -> {fail, ?ERRCODE(err170_awake_not_to_decompose)};
        % 属性大于1不能分解
        SoulAttrCoeCon#soul_attr_coefficient_con.attr_num > 1 -> {fail, ?ERRCODE(err170_multi_attr_num_not_to_decompose)};
        true -> true
    end.


get_all_power(Player) ->
    #player_status{goods = StatusGoods, original_attr = AllAttr} = Player,
    #status_goods{soul_attr = Attr} = StatusGoods,
    lib_player:calc_partial_power(AllAttr, 0, Attr).




%% 分解多余源力
gm_compose(RoleId) ->
%%    ?PRINT("RoleId", [RoleId]),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_soul, gm_compose2, []).






gm_compose2(#player_status{pid = undefined} = PS) ->
    PS;
gm_compose2(PS) ->
    #player_status{id = RoleId} = PS,
    List  = [28990001, 28990002, 28990003, 28990004, 28990005],
    List2 = lib_goods_api:get_goods_num(PS, List),
    List3 = [{GoodsId, GoodsNum} || {GoodsId, GoodsNum} <- List2, GoodsNum > 0],
    List4 = [{0, GoodsId2, GoodsNum2} || {GoodsId2, GoodsNum2} <- List3],
    if
        List3 == [] ->
            PS;
        true ->
            F = fun({GoodsTypeId, Num}, AccList) ->
                case data_goods_decompose:get(GoodsTypeId) of
                    #goods_decompose_cfg{regular_mat = [{RewardType, RewardTypeId,  RewardNum}]} ->
                        [{RewardType, RewardTypeId,  RewardNum * Num} | AccList];
                    _ ->
                        AccList
                end
                end,
            Reward = lists:foldl(F, [], List3),
            case lib_goods_api:cost_object_list_with_check(PS, List4, gm_compose2, "") of
                {true, NewPS} ->
                    lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = gm_compose2}),
                    NewPS;
                _ ->
                    PS
            end
    end.
    

%% 获取源力的分解物品列表
get_can_decompose_soul_goods(RoleId, Dict) ->
    SoulGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL_BAG, Dict),
    %% 过滤掉双属性源力物品
    F = fun(Goods, Acc) ->
            #goods{subtype = SubType, level = Level} = Goods,
            case data_soul:get_soul_attr_num_con(SubType, Level) of
                #soul_attr_num_con{attr_num_list = AttrList} ->
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
    lists:foldl(F, [], SoulGoodsList).

%% 分离经验物品和装备物品
split_exp_and_equip_goods(login, OneAttrSoulGoodsList, ColorList) ->
    {ExpGoods, Count} = split_exp_goods(login, OneAttrSoulGoodsList, [], 0),
    case Count >= ?LOGIN_SOUL_DECOMPOSE_LENGTH of
        true ->
            NewExpGoods = lists:sublist(ExpGoods, ?LOGIN_SOUL_DECOMPOSE_LENGTH),
            NewExpGoods;
        false -> %% 没有超过获取装备列表充数
            EquipGoods = split_equip_goods(OneAttrSoulGoodsList, [], ColorList, ?LOGIN_SOUL_DECOMPOSE_LENGTH - Count),
            {ExpGoods, EquipGoods}
    end.
%% 分离经验物品和装备物品
split_exp_and_equip_goods(OneAttrSoulGoodsList, ColorList) ->
    {ExpGoods, Count} = split_exp_goods(OneAttrSoulGoodsList, [], 0),
    case Count >= ?SOUL_DECOMPOSE_LENGTH of
        true ->
            NewExpGoods = lists:sublist(ExpGoods, ?SOUL_DECOMPOSE_LENGTH),
            NewExpGoods;
        false -> %% 没有超过获取装备列表充数
            EquipGoods = split_equip_goods(OneAttrSoulGoodsList, [], ColorList, ?SOUL_DECOMPOSE_LENGTH - Count),
            {ExpGoods, EquipGoods}
    end.

%% 登录分离经验物品
split_exp_goods(login, [SoulGoods|OneAttrSoulGoodsList], ExpGoods, Count) when Count =< ?LOGIN_SOUL_DECOMPOSE_LENGTH ->
    #goods{subtype = SubType} = SoulGoods,
    case SubType == 99 of
        true ->
            split_exp_goods(OneAttrSoulGoodsList, [SoulGoods|ExpGoods], Count + 1);
        false ->
            split_exp_goods(OneAttrSoulGoodsList, ExpGoods, Count)
    end;
split_exp_goods(login, _, ExpGoods, Count) -> {ExpGoods,Count}.

%% 分离经验物品
split_exp_goods([SoulGoods|OneAttrSoulGoodsList], ExpGoods, Count) when Count =< ?SOUL_DECOMPOSE_LENGTH ->
    #goods{subtype = SubType} = SoulGoods,
    case SubType == 99 of
        true ->
            split_exp_goods(OneAttrSoulGoodsList, [SoulGoods|ExpGoods], Count + 1);
        false ->
            split_exp_goods(OneAttrSoulGoodsList, ExpGoods, Count)
    end;
split_exp_goods(_, ExpGoods, Count) -> {ExpGoods,Count}.

%% 分离装备物品
split_equip_goods([SoulGoods|OneAttrSoulGoodsList], EquipGoods, ColorList, LeftCount) when LeftCount > 0->
    #goods{subtype = SubType, color = Color} = SoulGoods,
    case SubType =/= 99 andalso lists:member(Color, ColorList) of
        true ->
            split_equip_goods(OneAttrSoulGoodsList, [SoulGoods|EquipGoods], ColorList, LeftCount - 1);
        false ->
            split_equip_goods(OneAttrSoulGoodsList, EquipGoods, ColorList, LeftCount)
    end;
split_equip_goods(_, EquipGoods, _, _) -> EquipGoods.


%% 获取源力分解列表
get_soul_decompose_list(login, OneAttrSoulGoodsList, ColorList, TakingSoulGoodsList) ->
    case split_exp_and_equip_goods(login, OneAttrSoulGoodsList, ColorList) of 
        {ExpGoodsList, EquipGoodsList} ->
            %% 获取同类符文里最高品质的符文id
            StrongestSoulIds = get_soul_strongest_equip_list(TakingSoulGoodsList, OneAttrSoulGoodsList), 
            %% 筛选过滤掉同种类别里最高品质的符文
            NewEquipGoodsList = get_soul_decompose_equip_list(EquipGoodsList, StrongestSoulIds, []),
            NewEquipGoodsList ++ [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0];
        ExpGoodsList ->
            [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0]
    end.

%% 获取源力分解列表
get_soul_decompose_list(OneAttrSoulGoodsList, ColorList, TakingSoulGoodsList) ->
    case split_exp_and_equip_goods(OneAttrSoulGoodsList, ColorList) of 
        {ExpGoodsList, EquipGoodsList} ->
            %% 获取同类符文里最高品质的符文id
            StrongestSoulIds = get_soul_strongest_equip_list(TakingSoulGoodsList, OneAttrSoulGoodsList), 
            %% 筛选过滤掉同种类别里最高品质的符文
            NewEquipGoodsList = get_soul_decompose_equip_list(EquipGoodsList, StrongestSoulIds, []),
            NewEquipGoodsList ++ [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0];
        ExpGoodsList ->
            [{Id, Num} || #goods{id = Id, num = Num} <- ExpGoodsList, Id > 0]
    end.

%% 筛选过滤掉同种类别里最高品质的符文
get_soul_decompose_equip_list([], _,  Result) -> Result;
get_soul_decompose_equip_list([#goods{id = GoodsId, num = Num}|DecomposeSoulGoodsList], StrongestSoulIds, Result) ->
    case lists:member(GoodsId, StrongestSoulIds) of
        true ->
            get_soul_decompose_equip_list(DecomposeSoulGoodsList, StrongestSoulIds, Result);
        false ->
            get_soul_decompose_equip_list(DecomposeSoulGoodsList,  StrongestSoulIds, [{GoodsId, Num} | Result])
    end.


%% 获取当前最高品质的源力Id列表
get_soul_strongest_equip_list(TakingSoulGoodsList, DecomposeSoulGoodsList) ->
    %% 初始化身上的装备为最高品质列表
    StrongestEquipL = [{StrongestSubType, StrongestColor, ?GOODS_LOC_SOUL} || #goods{subtype = StrongestSubType, color = StrongestColor} <- TakingSoulGoodsList],
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
    {_, StrongestEquipIdList} = lists:foldl(F, {StrongestEquipL, []}, DecomposeSoulGoodsList),
    [SoulId || {SoulSubType, SoulId} <- StrongestEquipIdList, SoulId > 0, SoulSubType =/= 99].


%% 发邮箱提醒
send_tips_by_email(RoleId) ->
    #errorcode_msg{about = Name} = data_errorcode_msg:get(1043), 
    #errorcode_msg{about = Material} = data_errorcode_msg:get(1046),
    Title = utext:get(1500009, [Name]),
    Content = utext:get(1500011, [Name, ?SOUL_LIMIT_2, Material, Name, Name]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []).








