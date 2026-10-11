%%% ---------------------------------------------------------------------------
%%% @doc            lib_armour_check.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @since          2021-03-08
%%% @description    战甲数据检查
%%% ---------------------------------------------------------------------------
-module(lib_armour_check).

-include("armour.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("server.hrl").

-export([
    make_armour/4   % 战甲打造
]).

%% 战甲打造检查
%% @return ConsumeList :: [{Type, Id, Num}...] | {false, ErrCode}
make_armour(PS, Stage, Type, Pos) ->
    CheckList = [{is_stage_exist, Stage}, {is_type_exist, Stage, Type}, {is_pos_exist, Type, Pos},
                {lv, PS, Stage, Type}, {has_made_pre_stage, PS, Stage, Type, Pos}, 
                {has_not_made, PS, Stage, Type, Pos}, {is_enough_goods, PS, Stage, Type, Pos}],
    case check_list(CheckList) of
        true ->
            #base_armour_equipment{
                consume = ConsumeList
            } = data_armour:get_armour_equipment(Stage, Type, Pos),
            RealConsumeList = lib_armour:get_real_consume_goods(ConsumeList),
            RealConsumeList;
        {false, ErrCode} ->
            {false, ErrCode}
    end.

%%% ================================ 内部函数相关 ================================

%% 条件列表检查
check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        true -> check_list(T);
        {false, Res} -> {false, Res}
    end.

%% 战甲阶数
check({is_stage_exist, Stage}) ->
    AllStage = data_armour:get_all_stage(),
    case lists:member(Stage, AllStage) of
        true -> true;
        false -> 
            ?ERR("param error ~p~n", [Stage]),
            {false, ?ERRCODE(err144_param_error)}
    end;

%% 战甲类型
check({is_type_exist, Stage, Type}) ->
    AllType = data_armour:get_all_type(Stage),
    case lists:member(Type, AllType) of
        true -> true;
        false ->
            ?ERR("param error ~p~n", [{Stage, Type}]),
            {false, ?ERRCODE(err144_param_error)}
    end;

%% 战甲装备部位
check({is_pos_exist, Type, Pos}) ->
    AllPos = lib_armour:get_pos_list_by_type(Type),
    case lists:member(Pos, AllPos) of
        true -> true;
        false ->
            ?ERR("param error ~p~n", [{Type, Pos}]),
            {false, ?ERRCODE(err144_param_error)}
    end;

%% 玩家等级
check({lv, PS, Stage, Type}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    SuitCfg = data_armour:get_armour_suit(Stage, Type),
    case SuitCfg of
        #base_armour_suit{open_lv = OpenLv} ->
            case Lv >= OpenLv of
                true -> true;
                false ->
                    {false, ?ERRCODE(err144_lv_not_enough)}
            end;
        _ ->
            ?ERR("missing config ~p~n", [{Stage, Type}]),
            {false, ?ERRCODE(missing_config)}
    end;

%% 前置阶数
check({has_made_pre_stage, PS, Stage, Type, Pos}) ->
    #player_status{armour = Armour} = PS,
    #armour{armour_map = AMap} = Armour,
    EquipmentCfg = data_armour:get_armour_equipment(Stage, Type, Pos),
    case EquipmentCfg of
        #base_armour_equipment{pre_stage = 0} -> true;
        #base_armour_equipment{pre_stage = PreStage} ->
            ActPosL = maps:get({PreStage, Type}, AMap, []),
            case lists:member(Pos, ActPosL) of
                true -> true;
                false ->
                    {false, ?ERRCODE(err144_pre_stage_not_made)}
            end;
        _ ->
            ?ERR("missing config ~p~n", [{Stage, Type, Pos}]),
            {false, ?ERRCODE(missing_config)}
    end;

%% 当前阶数打造情况
check({has_not_made, PS, Stage, Type, Pos}) ->
    #player_status{armour = Armour} = PS,
    #armour{armour_map = AMap} = Armour,
    ActPosL = maps:get({Stage, Type}, AMap, []),
    case lists:member(Pos, ActPosL) of
        false -> true;
        true ->
            {false, ?ERRCODE(err144_pos_has_made)}
    end;

%% 打造物品消耗
check({is_enough_goods, PS, Stage, Type, Pos}) ->
    EquipmentCfg = data_armour:get_armour_equipment(Stage, Type, Pos),
    case EquipmentCfg of
        #base_armour_equipment{consume = ConsumeList} ->
            RealConsumeList = lib_armour:get_real_consume_goods(ConsumeList),
            case lib_goods_api:check_object_list(PS, RealConsumeList) of
                true -> true;
                {false, ErrCode} ->
                    {false, ErrCode}
            end;
        _ ->
            ?ERR("missing config ~p~n", [{Stage, Type, Pos}]),
            {false, ?ERRCODE(missing_config)}
    end.