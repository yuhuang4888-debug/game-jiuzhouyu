%%%--------------------------------------
%%% @Module  : pp_rune
%%% @Author  : huyihao
%%% @Created : 2017.11.7
%%% @Description:  符文
%%%--------------------------------------

-module(pp_rune).

-export([handle/3]).
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("attr.hrl").
-include("rune.hrl").
-include("def_fun.hrl").


%% 打开符文界面
handle(16700, Ps, []) ->
    lib_rune:send_rune_info(Ps);

%% 符文镶嵌
handle(16701, Ps, [PosId, GoodsId]) ->
    #player_status{
        id = RoleId, original_attr = _OriginalAttr, figure = #figure{ lv = _RoleLv }
    } = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict
    } = GS,
    RuneBagList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE_BAG, Dict),
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict),
    PosList = data_rune:get_rune_pos_list(),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, RuneBagList),
    IfPos = lists:member(PosId, PosList),
    if   %%有空就写个check吧
        GoodsInfo =:= false ->
            Code = ?ERRCODE(err150_no_goods),   %% 物品不存在
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.type =/= ?GOODS_TYPE_RUNE ->
            Code = ?ERRCODE(err167_not_rune),   %% 该物品不是符文
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.location =:= ?GOODS_LOC_RUNE ->
            Code = ?ERRCODE(err167_have_wear),   %% 该符文已穿戴
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.subtype =:= 99 ->
            Code = ?ERRCODE(err167_cant_wear),   %% 该符文不能被镶嵌
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        IfPos =:= false ->
            Code = ?ERRCODE(err167_not_pos),   %% 没有该部位
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        true ->
            IsAttrConflict = lib_rune:is_attr_conflict(GoodsInfo, PosId, RuneWearList),
            if
                IsAttrConflict == true ->
                    Code = ?ERRCODE(err167_attr_conflict),   %% 没有该部位
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps;
                true ->
                    SubTypeGoods = lists:keyfind(GoodsInfo#goods.subtype, #goods.subtype, RuneWearList),  %%根据子类型来找穿戴符文中相应的符文
                    case SubTypeGoods of   %%未穿戴此种符文
                        false ->
                            Code1 = 1;
                        _ ->
                            case SubTypeGoods#goods.cell of
                                PosId ->     %%替换的符文的孔位和客户端提供孔位对的上
                                    Code1 = 1;
                                _ ->
                                    Code1 = 2
                            end
                    end,
                    case Code1 of
                        1 ->
                            RunePosCon = data_rune:get_rune_pos_con(PosId),
                            ConditionList = RunePosCon#rune_pos_con.condition,   %%孔位开启条件,镶嵌条件
                            case lib_rune:check_list(ConditionList, Ps) of       %%检查孔位是否开启
                                false ->
                                    Code = ?ERRCODE(err167_pos_not_active),   %% 该部位未激活
                                    NewGoodsId = 0,
                                    OldGoodsId = 0,
                                    NewGoodsTypeId = 0,
                                    NewPs = Ps;
                                true ->
                                    case lib_rune_check:others_check(ConditionList, GoodsInfo, Ps) of
                                        {false, ErrorCode} ->
                                            Code = ErrorCode,
                                            NewGoodsId = 0,
                                            OldGoodsId = 0,
                                            NewGoodsTypeId = 0,
                                            NewPs = Ps;
                                        true ->
                                            case lib_rune:rune_wear(Ps, GS, GoodsInfo, PosId) of   %%镶嵌符文
                                                {true, Code, NewGoodsId, OldGoodsId, NewGoodsTypeId, NewPs, _NewGoodsInfo} ->
                                                    GSNew = lib_goods_do:get_goods_status(),
                                                    RuneWearListNew = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GSNew#goods_status.dict),
                                                    lib_task_api:rune_num(NewPs, length(RuneWearListNew)), %% 镶嵌符文数量
                                                    lib_task_api:rune_lv(NewPs, [ TmpG#goods.level || TmpG <- RuneWearListNew ]),
                                                    %% 查看该子类型的符文是否会修改技能
                                                    SubTypeList = data_rune:get_all_sub_type(),
                                                    case lists:member(GoodsInfo#goods.subtype, SubTypeList) of
                                                        true ->
                                                            #goods_status{rune = #rune{skill = Skills}} = GSNew,
                                                            mod_scene_agent:update(NewPs, [{passive_skill, Skills}, {battle_attr, NewPs#player_status.battle_attr}]);
                                                        _ ->
                                                            skip
                                                    end,
                                                    lib_rune:update_power(NewPs),
                                                    lib_rush_rank_api:flash_rank_by_rune_rush(NewPs),
                                                    skip;
                                                {false, Code} ->
                                                    NewGoodsId = 0,
                                                    OldGoodsId = 0,
                                                    NewGoodsTypeId = 0,
                                                    NewPs = Ps;
                                                _ ->
                                                    Code = ?FAIL,  %% 未知错误
                                                    NewGoodsId = 0,
                                                    OldGoodsId = 0,
                                                    NewGoodsTypeId = 0,
                                                    NewPs = Ps
                                            end
                                    end
                            end;
                        _ ->
                            Code = ?ERRCODE(err167_subtype_have_wear),   %% 已经装备该子类型
                            NewGoodsId = 0,
                            OldGoodsId = 0,
                            NewGoodsTypeId = 0,
                            NewPs = Ps
                    end
            end
    end,
    {ok, Bin} = pt_167:write(16701, [Code, PosId, NewGoodsId, OldGoodsId, NewGoodsTypeId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

%% 符文升级
handle(16702, Ps, [GoodsId]) ->
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{rune = Rune} = GS,
    #rune{rune_point = RunePoint } = Rune, %% 符文经验}
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    if  %%有空就写个check吧
        GoodsInfo =:= [] ->
            Code = ?ERRCODE(err150_no_goods),   %% 物品不存在
            NewPs = Ps;
        GoodsInfo#goods.type =/= ?GOODS_TYPE_RUNE ->
            Code = ?ERRCODE(err167_not_rune),   %% 不是符文
            NewPs = Ps;
        true ->
            #goods{
                subtype = SubType,
                color = Color,
                level = Level
            } = GoodsInfo,
            NewLevel = Level + 1,
            NeedRuneNumCon = data_rune:get_rune_attr_num_con(SubType, NewLevel),
            NeedRuneCoefficientCon = data_rune:get_rune_attr_coefficient_con(SubType, Color),
            case NeedRuneNumCon =:= [] orelse NeedRuneCoefficientCon =:= [] of
                true ->
                    Code = ?ERRCODE(err167_level_max),   %% 已达上限
                    NewPs = Ps;
                false ->
                    NeedRuneNum = NeedRuneNumCon#rune_attr_num_con.lv_up_num,
                    NeedRuneCoefficient = NeedRuneCoefficientCon#rune_attr_coefficient_con.lv_up_coefficient,
                    NeedRunePoint = round(NeedRuneNum * NeedRuneCoefficient / 1000),  %%(升级基础经验 * 升级系数 / 1000) =  升级所需经验
                    case RunePoint >= NeedRunePoint of
                        false ->
                            Code = ?ERRCODE(err167_exp_not_enough),   %% 符文经验不足
                            NewPs = Ps;
                        true ->
                            NewRunePoint = RunePoint - NeedRunePoint,   %%消耗
                            NewRune = Rune#rune{
                                rune_point = NewRunePoint
                            },
                            case lib_rune:rune_level_up(Ps, GS, GoodsInfo, NewRune, NeedRunePoint) of
                                {true, Code, NewPs} ->
                                    GSNew = lib_goods_do:get_goods_status(),
                                    RuneWearListNew = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, GSNew#goods_status.dict),
                                    lib_task_api:rune_num(NewPs, length(RuneWearListNew)), %% 镶嵌符文数量
                                    lib_task_api:rune_lv(NewPs, [ TmpG#goods.level || TmpG <- RuneWearListNew]),
                                    lib_rune:update_power(NewPs),
                                    lib_rush_rank_api:flash_rank_by_rune_rush(NewPs),
                                    skip;
                                {false, Code, NewPs} ->
                                    skip;
                                _ ->
                                    Code = ?FAIL,
                                    NewPs = Ps
                            end
                    end
            end
    end,
    %%增加符文经验
    #goods_status{
        rune = LastRune
    } = lib_goods_do:get_goods_status(),
    #rune{rune_point = LastRunePoint} = LastRune,
    {ok, Bin} = pt_167:write(16702, [Code, LastRunePoint, GoodsId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

%% 符文兑换
handle(16703, Ps, [Id, Num]) ->
    #player_status{
        id = RoleId
    } = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        rune = Rune
    } = GS,
    #rune{
        rune_chip = RuneChip      %% 符文碎片
    } = Rune,
    ExchangeCon = data_rune:get_rune_exchange_con(Id),
    if
        ExchangeCon =:= [] ->
            Code = ?MISSING_CONFIG,   %% 配置不存在
            NewPs = Ps;
        true ->
            #rune_exchange_con{
                goods_list = GoodsList,
                rune_chip_num = CostChipNum,
                condition = ConditionList
            } = ExchangeCon,
            AllCostChipNum = CostChipNum * Num,
            AllGoodsList = [begin
                                {GoodsType, GoodsTypeId, GoodsNum * Num}
                            end || {GoodsType, GoodsTypeId, GoodsNum} <- GoodsList],
            IfOpen = lib_rune:check_list(ConditionList, Ps),
            if
                IfOpen =:= false ->
                    Code = ?ERRCODE(err167_exchange_not_open),   %% 该物品未开启
                    NewPs = Ps;
                RuneChip < AllCostChipNum ->
                    Code = ?ERRCODE(err167_runechip_not_enough),   %% 碎片不足
                    NewPs = Ps;
                true ->
                    case lib_goods_api:can_give_goods(Ps, AllGoodsList) of  %%检查背包是否已满,是否有必要
                        {false, ErrorCode} ->
                            Code = ErrorCode,   %% 背包满
                            NewPs = Ps;
                        true ->
                            Code = ?SUCCESS,
                            NewRuneChip = RuneChip - AllCostChipNum,
                            NewRune = Rune#rune{
                                rune_chip = NewRuneChip
                            },
                            lib_rune:sql_rune(NewRune, RoleId),
                            NewGS = GS#goods_status{
                                rune = NewRune
                            },
                            lib_goods_do:set_goods_status(NewGS),
                            Produce = #produce{type = rune_exchange, subtype = 0, reward = AllGoodsList, remark = "rune_exchange"},
                            {ok, NewPs} = lib_goods_api:send_reward_with_mail(Ps, Produce),
                            lib_log_api:log_rune_exchange(RoleId, RuneChip, NewRuneChip, GoodsList)
                    end
            end
    end,
    LastGS = lib_goods_do:get_goods_status(),
    #goods_status{
        rune = LastRune
    } = LastGS,
    #rune{
        rune_chip = LastRuneChip      %% 符文碎片
    } = LastRune,
    {ok, Bin} = pt_167:write(16703, [Code, LastRuneChip, Id, Num]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 16704现在改为推送解锁层数而不是实际通关层数
handle(16704, Ps, []) ->
    RuneDungeonLv = lib_dungeon_rune:get_dungeon_level(Ps),
    {ok, Bin} = pt_167:write(16704, [RuneDungeonLv]),
    lib_server_send:send_to_uid(Ps#player_status.id, Bin);

%% -----------------------------------------------------------------
%% @desc     功能描述  符文合成预览
%% @param    参数      RuleId::integer  规则Id ,
%%                     GoodIdList::lists [{goood_id}] 物品id列表
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle(Cmd = 16705, Ps, [RuleId, GoodIdList]) ->
    case lib_rune:get_compose_Lv(RuleId, GoodIdList) of
        {ok, Lv} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_167, Cmd, [?SUCCESS, Lv]);
        {false, Res} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_167, Cmd, [Res, 0])
    end;


%% -----------------------------------------------------------------
%% @desc     功能描述  符文分解预览
%% @param    参数      GoodIdList::lists  物品id列表 ,
%%
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle(Cmd = 16706, Ps, [GoodIdList]) ->
    case lib_rune:get_decompose_exp(GoodIdList) of
        {ok, Exp, ResList} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_167, Cmd, [?SUCCESS, Exp, ResList]);
        {false, Res} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_167, Cmd, [Res, 0, []])
    end;


%% 符文觉醒
handle(Cmd = 16707, #player_status{sid = Sid, id = _RoleId} = Ps, [GoodsId, AttrId, CostGoodsIdL]) ->
    if
        CostGoodsIdL == [] ->
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [?FAIL, GoodsId, AttrId, 0, 0, 0]);
        true ->
            case lib_rune:awake(Ps, GoodsId, AttrId, CostGoodsIdL) of
                {false, ErrCode, NewPs} ->
                    lib_server_send:send_to_sid(Sid, pt_167, Cmd, [ErrCode, GoodsId, AttrId, 0, 0, 0]),
					%%通知场景
                    {ok, NewPs};
                {ok, NewPs, AwakeLv, AwakeExp, RuneLv, CurPower, NextPower} ->
                    lib_server_send:send_to_sid(Sid, pt_167, Cmd, [?SUCCESS, GoodsId, AttrId, RuneLv, AwakeLv, AwakeExp, NextPower, CurPower]),
                    %%通知场景
                    {ok, battle_attr, NewPs}
            end
    end;


%% 符文拆解
handle(Cmd = 16708, #player_status{sid = Sid} = Ps, [GoodsIdL]) ->
    UsortGoodsIdL = lists:usort(GoodsIdL),
    case lib_rune:dismantle_awake(Ps, UsortGoodsIdL) of
        {false, ErrCode, NewPs} ->
            ?MYLOG("cym", "16708 ErrCode:~p ~n", [ErrCode]) ,
            GoodsRewardL = [{GoodsId, []}||GoodsId<-UsortGoodsIdL],
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [ErrCode, GoodsRewardL]),
            {ok, NewPs};
        {ok, NewPs, GoodsRewardL} ->
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [?SUCCESS, GoodsRewardL]),
            {ok, NewPs}
    end;


%% 符文拆解预览
handle(Cmd = 16709, #player_status{sid = Sid} = Ps, [GoodsIdL]) ->
    UsortGoodsIdL = lists:usort(GoodsIdL),
    case lib_rune:split_dismantle_awake(Ps, UsortGoodsIdL, {[], []}) of
        {false, ErrCode} ->
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [ErrCode, []]);
        {SingleL, MultiL} ->
            if
                SingleL == [] ->  %% 多属性的预览
                    ReturnList = [ReturnL  || {_, _, ReturnL} <- MultiL];
                true ->
                    F = fun({#goods{goods_id = GoodTypeId}, _, ReturnL}, AccList) ->
                        AccList ++  [{?TYPE_GOODS, GoodTypeId, 1}] ++ ReturnL
                        end,
                    ReturnList = lists:foldl(F, [], SingleL)
            end,
            NewReturnList = lists:flatten(ReturnList),
            LastList =
                lib_goods_api:make_reward_unique([{GoodsType, GoodsTypeId, Num} ||{GoodsType, GoodsTypeId, Num} <-NewReturnList, Num > 0]),
            lib_server_send:send_to_sid(Sid, pt_167, Cmd,
                [?SUCCESS, LastList])
    end;


%% 符文升级
handle(Cmd = 16710, #player_status{sid = Sid} = Ps, []) ->
    case lib_rune:up_skill_lv(Ps) of
        {ok, NewPS, NewLv} ->
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [?SUCCESS, NewLv]),
            {ok, NewPS};
        {false, Error} ->
            lib_server_send:send_to_sid(Sid, pt_167, Cmd, [Error, 0])
    end;

%% 符文卸下
handle(16711, Ps, [PosId, GoodsId]) ->
    #player_status{id = RoleId} = Ps,
    #goods_status{dict = Dict} = GS = lib_goods_do:get_goods_status(),
    RuneWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_RUNE, Dict),
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, RuneWearList), % 请求卸下的符文
    PosList = data_rune:get_rune_pos_list(),
    IsPos = lists:member(PosId, PosList),
    if
        not IsPos -> % 非法部位
            {Code, UnWearGoodsId, NewPs} = {?ERRCODE(err167_not_pos), 0, Ps};
        not is_record(GoodsInfo, goods) -> % 符文不存在
            {Code, UnWearGoodsId, NewPs} = {?ERRCODE(err150_no_goods), 0, Ps};
        true ->
            case lib_rune:rune_unwear(Ps, GS, GoodsInfo, PosId) of
                {true, Code, _UnWearGoodsInfo, UnWearGoodsId, NewPs} ->
                    GSNew = lib_goods_do:get_goods_status(),
                    SubTypeList = data_rune:get_all_sub_type(),
                    case lists:member(GoodsInfo#goods.subtype, SubTypeList) of
                        true ->
                            #goods_status{rune = #rune{skill = Skills}} = GSNew,
                            mod_scene_agent:update(NewPs, [{passive_skill, Skills}, {battle_attr, NewPs#player_status.battle_attr}]);
                        _ ->
                            skip
                    end,
                    lib_rune:update_power(NewPs),
                    lib_rush_rank_api:flash_rank_by_rune_rush(NewPs);
                {false, Code} ->
                    {UnWearGoodsId, NewPs} = {0, Ps};
                _ ->
                    {Code, UnWearGoodsId, NewPs} = {?FAIL, 0, Ps}
            end
    end,
    {ok, Bin} = pt_167:write(16711, [Code, PosId, UnWearGoodsId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, battle_attr, NewPs};

handle(_, Ps, []) ->
    ?PRINT("167xx   ~p~n", [413]),
    {ok, Ps}.
