%%%--------------------------------------
%%% @Module  : pp_soul
%%% @Author  : huyihao
%%% @Created : 2017.11.4
%%% @Description:  聚魂
%%%--------------------------------------

-module(pp_soul).

-export([handle/3]).
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("soul.hrl").
-include("def_module.hrl").
-include("attr.hrl").

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = lib_module:get_open_lv(?MOD_SOUL, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 打开聚魂界面
do_handle(17000, Ps, []) ->
%%    ?PRINT("17000 start ~n",[]),
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict,
        soul = Soul
    } = GS,
    SoulList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, Dict),  % 物品聚魂物品
    #soul{
        soul_point = SoulPoint      %% 聚魂经验
    } = Soul,
    PosList = data_soul:get_soul_pos_list(),  % 获取所有聚魂位置
    GoodsStatus = lib_goods_do:get_goods_status(),
    SendList =
        [begin
             SoulPosCon = data_soul:get_soul_pos_con(PosId),
             ConditionList = SoulPosCon#soul_pos_con.condition,  % 槽位等级条件
             IfOpen =
                 case lib_soul:check_list(ConditionList, Ps) of
                     true -> 1;
                     {false, _Res} -> 0
                 end,
             GoodsInfo = lists:keyfind(PosId, #goods.cell, SoulList),
             case IfOpen =:= 0 orelse GoodsInfo =:= false of
                 true ->
                     GoodsId = 0,
                     GoodsTypeId = 0,
                     Color = 0,
                     Level = 0,
                     AwakeAttrList = [],
                     AttrList = [];

                 false ->
                     #goods{
                         id = GoodsId,
                         goods_id = GoodsTypeId,
                         color = Color,
                         level = Level
                         % other = #goods_other{
                         %     extra_attr = AttrList
                         % }
                     } = GoodsInfo,
                    AttrList = lib_soul:count_one_soul_attr(GoodsInfo),
                    F = fun({AttrId, Num}) ->
                        AwakeLv = lib_soul:get_awake_lv(GoodsInfo, AttrId),
                        {AttrId, Num, AwakeLv}
                    end,
                    AwakeAttrList = lists:map(F, AttrList)
                    % AwakeAttrList = AttrList
             end,
%%            槽位Id,是否开启，物品id, 符文物品类型id,品质，等级，属性列表
%%             ?PRINT("=======================AttrList:~p~n", [AttrList]),
             NewAttrList =
                 case AttrList of
                     [{?EQUIP_STREN_ADD_RATIO, _}] = AttrListTmp ->
                         data_goods:count_stren_attribute(AttrListTmp, GoodsStatus);
                     [{?EQUIP_REFINE_ADD_RATIO, _}] = AttrListTmp ->
                         data_goods:count_refine_attribute(AttrListTmp, GoodsStatus);
                     AttrListTmp ->
                         AttrListTmp
                 end,
             NewAttrR = lib_player_attr:to_attr_record(NewAttrList),
             NewCombat = lib_player:calc_all_power(NewAttrR),
%%             ?PRINT("AttrList,NewCombat:~p   ~p~n", [AttrList, NewCombat]),

            {PosId, IfOpen, GoodsId, GoodsTypeId, Color, Level, AwakeAttrList, NewCombat}
        end || PosId <- PosList],
    {ok, Bin} = pt_170:write(17000, [SoulPoint, SendList]),
%%    ?PRINT("17000 end SoulPoint:~p, SendList:~p ~n",[ SoulPoint, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 聚魂镶嵌
do_handle(17001, Ps, [PosId, GoodsId]) ->
%%    ?PRINT("17001 startPosId:~p, GoodsId:~p ~n",[PosId, GoodsId]),
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),  % 获取物品状态
    #goods_status{dict = Dict} = GS,
    SoulBagList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL_BAG, Dict),  % 获取聚魂背包位置
    SoulWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SOUL, Dict),     % 获取聚魂位置
    PosList = data_soul:get_soul_pos_list(),          % 获取聚魂的位置列表
    GoodsInfo = lists:keyfind(GoodsId, #goods.id, SoulBagList),
    IfPos = lists:member(PosId, PosList),
    if
        GoodsInfo =:= false ->
            Code = ?ERRCODE(err150_no_goods),   %% 物品不存在
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.type =/= ?GOODS_TYPE_SOUL ->
            Code = ?ERRCODE(err170_not_soul),   %% 该物品不是聚魂
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.location =:= ?GOODS_LOC_SOUL ->
            Code = ?ERRCODE(err170_have_wear),   %% 该聚魂已穿戴
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        GoodsInfo#goods.subtype =:= 99 ->
            Code = ?ERRCODE(err170_cant_wear),   %% 该符文碎片不能被镶嵌
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        IfPos =:= false ->
            Code = ?ERRCODE(err170_not_pos),   %% 没有该部位
            NewGoodsId = 0,
            OldGoodsId = 0,
            NewGoodsTypeId = 0,
            NewPs = Ps;
        true ->
            SoulPosCon = data_soul:get_soul_pos_con(PosId),  %获取聚魂槽位的配置
            #soul_pos_con{condition = ConditionList, type = PosType} = SoulPosCon,
            Code1 =
                case data_soul:get_soul_attr_coefficient_con(GoodsInfo#goods.subtype, GoodsInfo#goods.color) of
                    #soul_attr_coefficient_con{kind = Kind} when Kind == PosType -> 1;
                    _ -> 2   %% 聚魂物品槽位类型不正确
                end,
            case Code1 of
                1 ->
                    SubTypeGoods = lists:keyfind(GoodsInfo#goods.subtype, #goods.subtype, SoulWearList),
                    Code2 =
                        case SubTypeGoods of
                            false -> 1;    % 没有镶嵌聚魂
                            _ ->
                                case SubTypeGoods#goods.cell of
                                    PosId -> 1;     % 物品格子位置
                                    _ -> 2
                                end
                        end,
                    case Code2 of
                        1 ->
                            case lib_soul:check_list(ConditionList, Ps) of
                                {false, Code} ->
%%                                    Code = ?ERRCODE(err170_pos_not_active),   %% 该部位未激活
                                    NewGoodsId = 0,
                                    OldGoodsId = 0,
                                    NewGoodsTypeId = 0,
                                    NewPs = Ps;
                                true ->
                                    case lib_soul:soul_wear(Ps, GS, GoodsInfo, PosId) of
                                        {true, Code, NewGoodsId, OldGoodsId, NewGoodsTypeId, NewPs} ->
                                            skip;
                                        _ ->
                                            Code = ?FAIL,
                                            NewGoodsId = 0,
                                            OldGoodsId = 0,
                                            NewGoodsTypeId = 0,
                                            NewPs = Ps
                                    end
                            end;
                        2 ->
                            Code = ?ERRCODE(err170_have_subtype_wear),   %% 已经装备该子类型
                            NewGoodsId = 0,
                            OldGoodsId = 0,
                            NewGoodsTypeId = 0,
                            NewPs = Ps
                    end;
                2 ->
                    Code = ?ERRCODE(err170_pos_type_wrong),   %% 聚魂物品槽位类型不正确
                    NewGoodsId = 0,
                    OldGoodsId = 0,
                    NewGoodsTypeId = 0,
                    NewPs = Ps
            end
    end,

%%                                  返回码，槽位，穿上聚魂id, 脱下聚魂物品, 穿上的物品类型id
    {ok, Bin} = pt_170:write(17001, [Code, PosId, NewGoodsId, OldGoodsId, NewGoodsTypeId]),
    ?PRINT("17001 Code, PosId, NewGoodsId, OldGoodsId, NewGoodsTypeId:~w ~n", [[Code, PosId, NewGoodsId, OldGoodsId, NewGoodsTypeId]]),
    lib_server_send:send_to_uid(RoleId, Bin),
    lib_rush_rank_api:reflash_rank_by_soul_rush(NewPs),
    {ok, battle_attr, NewPs};

%% 聚魂升级
do_handle(17002, Ps, [GoodsId]) ->
    ?PRINT("17002 start GoodsId:~p ~n", [GoodsId]),
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{soul = Soul} = GS,
    #soul{
        soul_point = SoulPoint      %% 聚魂经验
    } = Soul,
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId),
    if
        GoodsInfo =:= [] ->
            Code = ?ERRCODE(err150_no_goods),   %% 物品不存在
            NewPs = Ps;
        GoodsInfo#goods.type =/= ?GOODS_TYPE_SOUL ->
            Code = ?ERRCODE(err170_not_soul),   %% 不是聚魂
            NewPs = Ps;
        true ->
            #goods{
                subtype = SubType,
                color = Color,
                level = Level
            } = GoodsInfo,
            NewLevel = Level + 1,
            NeedSoulNumCon = data_soul:get_soul_attr_num_con(SubType, NewLevel),
            NeedSoulCoefficientCon = data_soul:get_soul_attr_coefficient_con(SubType, Color),
            case NeedSoulNumCon =:= [] orelse NeedSoulCoefficientCon =:= [] of
                true ->
                    Code = ?ERRCODE(err170_level_max),   %% 已达上限
                    NewPs = Ps;
                false ->
                    NeedSoulNum = NeedSoulNumCon#soul_attr_num_con.lv_up_num,  % 经验值
                    NeedSoulCoefficient = NeedSoulCoefficientCon#soul_attr_coefficient_con.lv_up_coefficient, % 升级系数
                    NeedSoulPoint = round(NeedSoulNum * NeedSoulCoefficient / 1000),
                    case SoulPoint >= NeedSoulPoint of
                        false ->
                            Code = ?ERRCODE(err170_exp_not_enough),   %% 聚魂经验不足
                            NewPs = Ps;
                        true ->
                            NewSoulPoint = SoulPoint - NeedSoulPoint,
                            NewSoul = Soul#soul{soul_point = NewSoulPoint},
                            case lib_soul:soul_level_up(Ps, GS, GoodsInfo, NewSoul, NeedSoulPoint) of
                                {true, Code, NewPs} ->
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
    {ok, Bin} = pt_170:write(17002, [Code, GoodsId]),
    ?PRINT("17002 end Code:~p, GoodsId:~p ~n", [Code, GoodsId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    lib_rush_rank_api:reflash_rank_by_soul_rush(NewPs),
    {ok, battle_attr, NewPs};

%% 灵魂物品合成预览
do_handle(Cmd = 17003, Ps, [RuleId, GoodIdList]) ->
    ?PRINT("17003 start RuleId:~p, GoodIdList:~p ~n", [RuleId, GoodIdList]),
    case lib_soul:get_compose_Lv(RuleId, GoodIdList, Ps) of
        {ok, Lv} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_170, Cmd, [?SUCCESS, Lv]);
        {false, Res} ->
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_170, Cmd, [Res, 0])
    end;

%% 灵魂分解预览
do_handle(Cmd = 17004, Ps, [GoodIdList]) ->
    ?PRINT("17004 start  GoodIdList:~p ~n", [GoodIdList]),
    case lib_soul:get_decompose_exp(GoodIdList, Ps) of
        {ok, Exp, ResList} ->
            ?PRINT("17004 end  Exp:~p, ResList:~p ~n", [Exp, ResList]),
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_170, Cmd, [?SUCCESS, Exp, ResList]);
        {false, Res} ->
            ?PRINT("17004 end  Res:~p ~n", [Res]),
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_170, Cmd, [Res, 0, []])
    end;

%% 聚魂经验
do_handle(Cmd = 17005, Ps, []) ->
    ?PRINT("17005 start   ~n", []),
    #player_status{sid = Sid} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{soul = Soul} = GS,
    #soul{
        soul_point = SoulPoint      %% 聚魂经验
    } = Soul,
    lib_server_send:send_to_sid(Sid, pt_170, Cmd, [SoulPoint]);

%% 聚魂觉醒
do_handle(Cmd = 17006, #player_status{sid = Sid} = Ps, [GoodsId, AttrId, CostGoodsIdL]) ->
    % ?MYLOG("hjhsoul", "17006 GoodsId:~p, AttrId:~p CostGoodsIdL:~p ~n", [GoodsId, AttrId, CostGoodsIdL]),
    case lib_soul:awake(Ps, GoodsId, AttrId, CostGoodsIdL) of
        {false, ErrCode, NewPs} ->
            % ?MYLOG("hjhsoul", "17006 ErrCode:~p ~n", [ErrCode]) ,
            lib_server_send:send_to_sid(Sid, pt_170, Cmd, [ErrCode, GoodsId, AttrId, 0, 0]),
            lib_rush_rank_api:reflash_rank_by_soul_rush(NewPs),
            {ok, NewPs};
        {ok, NewPs, AwakeLv, Level} ->
            % ?MYLOG("hjhsoul", "17006 ErrCode:~p ~n", [?SUCCESS]) ,
            lib_server_send:send_to_sid(Sid, pt_170, Cmd, [?SUCCESS, GoodsId, AttrId, AwakeLv, Level]),
            {ok, NewPs}
    end;

%% 聚魂拆解
do_handle(Cmd = 17007, #player_status{sid = Sid} = Ps, [GoodsIdL]) ->
    UsortGoodsIdL = lists:usort(GoodsIdL),
    case lib_soul:dismantle_awake(Ps, UsortGoodsIdL) of
        {false, ErrCode, NewPs} -> 
            % ?MYLOG("hjhsoul", "17006 ErrCode:~p ~n", [ErrCode]),
            GoodsRewardL = [{GoodsId, []}||GoodsId<-UsortGoodsIdL],
            lib_server_send:send_to_sid(Sid, pt_170, Cmd, [ErrCode, GoodsRewardL]),
            {ok, NewPs};
        {ok, NewPs, GoodsRewardL} ->
            % ?MYLOG("hjhsoul", "17006 ErrCode:~p ~n", [GoodsRewardL]) ,
            lib_server_send:send_to_sid(Sid, pt_170, Cmd, [?SUCCESS, GoodsRewardL]),
            {ok, NewPs}
    end;

do_handle(_Cmd, Ps, []) ->
    ?PRINT("170xx   ~p~n", [_Cmd]),
    ?MYLOG("hjhsoul", "170xx:~p ~n", [_Cmd]),
    {ok, Ps}.
