%%% ----------------------------------------------------
%%% @Module:        lib_god_equip
%%% @Author:        xlh
%%% @Description:   神装
%%% @Created:       2018/5/30
%%% ----------------------------------------------------
-module(lib_god_equip).

-include("god_equip.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_goods.hrl").

-export([
        get_god_equip_list/1,
        calc_god_equip_attr/3,
        calc_default_god_equiplevel/0,
        strength/2,
        replace_god_equip_level/2,
        do_after_lv_up/3,
        gm_reset_god_level/1,
        calc_god_equip_attr_core/3,
        calc_god_power/2,
        calc_stren_add_power/3
    ]).

get_god_equip_list(RoleId) ->
    List = db:get_all(io_lib:format(?SQL_SELECT_GOD_EQUIP, [RoleId])),
    Fun = fun([Pos, Level], Acc) ->
        lists:keystore(Pos, 1, Acc, {Pos, Level})
    end,
    lists:foldl(Fun, [], List).

calc_default_god_equiplevel() ->
    List = data_god_equip:get_all_pos(),
    Fun = fun(Pos, Acc) ->
        [{Pos, 0}|Acc]
    end,
    lists:foldl(Fun, [], List).

replace_god_equip_level(RoleId, Pos, Level) ->
    db:execute(io_lib:format(?SQL_UPDATE_GOD_EQUIP, [RoleId, Pos, Level])).

replace_god_equip_level(RoleId, GodEquipLevelList) ->
    Fun = fun({Pos, Level}) ->
        replace_god_equip_level(RoleId, Pos, Level)
    end,
    lists:foreach(Fun, GodEquipLevelList).

gm_reset_god_level(NewPS) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GodLevelList = lib_god_equip:calc_default_god_equiplevel(),
    NewGoodsStatus = GoodsStatus#goods_status{god_equip_list = GodLevelList},
    lib_goods_do:set_goods_status(NewGoodsStatus),
    lib_god_equip:replace_god_equip_level(NewPS#player_status.id, GodLevelList),
    {ok, LastPS} = lib_goods_util:count_role_equip_attribute(NewPS),
    Power = lib_god_equip:calc_god_power(LastPS, NewGoodsStatus),
    lib_server_send:send_to_uid(NewPS#player_status.id, pt_152, 15217, [Power, GodLevelList]),
    LastPS.

%% 玩家进程执行
do_after_lv_up(Player, Rolelv, RoleId) ->
    case data_god_equip:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) andalso Rolelv == OpenLv ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{god_equip_list = GodLevelList} = GoodsStatus,
            if
                GodLevelList == [] ->
                    NewGodLevelList = lib_god_equip:calc_default_god_equiplevel(),
                    NewGoodsStatus = GoodsStatus#goods_status{god_equip_list = NewGodLevelList},
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    lib_god_equip:replace_god_equip_level(RoleId, NewGodLevelList);
                true ->
                    NewGoodsStatus = GoodsStatus,
                    NewGodLevelList = GodLevelList
            end,
            Power = lib_god_equip:calc_god_power(Player, NewGoodsStatus),
            lib_server_send:send_to_uid(RoleId, pt_152, 15217, [Power, NewGodLevelList]);
        _ ->
            skip
    end.

calc_god_equip_attr([], _, Acc) -> Acc;
calc_god_equip_attr([Goods|T], GodEquipLevelList, Acc) when is_record(Goods, goods) ->
    Stage = lib_equip_api:get_equip_stage(Goods),
    NewAcc = case lists:keyfind(Goods#goods.equip_type, 1, GodEquipLevelList) of
        {Pos, Level} ->
            case data_god_equip:get_god_equip_level(Pos, Level) of
                #base_god_equip_level{extra_attr = ExtraAddPersent} when is_integer(ExtraAddPersent) ->
                    Min = data_god_equip:get_god_equip_limit(Pos),
                    Max = data_god_equip:get_max_stage_limit(Level),
                    if
                        Stage >= Min andalso Stage =< Max ->
                            RealExtraAddPersent = ExtraAddPersent;
                        true ->
                            RealExtraAddPersent = 0
                    end,
                    % {Persent, _ExtraPersent, AddAttrList} = calc_real_percent(Pos, Level, 0, 0, []),
                    {Persent, AddAttrList} = calc_real_percent(Pos, Level),
                    % Persent = 0, ExtraPersent = 0,
                    GoodsTypeInfo = data_goods_type:get(Goods#goods.goods_id),
                    BaseAttrList = GoodsTypeInfo#ets_goods_type.base_attrlist,
                    EquipExtraAttrList = lib_equip:get_equip_other_attr(Goods#goods.goods_id),
                    % ?PRINT(Pos == 1, "===== Persent:~p BaseAttrList:~p~n, ExtraPersent:~p,EquipExtraAttrList:~p~n",[Persent,BaseAttrList, ExtraPersent,EquipExtraAttrList]),
                    BaseAttr = calc_god_equip_attr_core(Persent, BaseAttrList, Acc),
                    EquipExtraAttr = calc_god_equip_attr_core(RealExtraAddPersent, EquipExtraAttrList, BaseAttr),
                    % ?PRINT(Pos == 1, "===== Acc:~p BaseAttr:~p, EquipExtraAttr:~p~n",[Acc,BaseAttr, EquipExtraAttr]),
                    kv_list_add(AddAttrList, EquipExtraAttr);
                    % EquipExtraAttr++AddAttrList;
                _ -> 
                    Acc
            end;
        _ ->
            Acc
    end,
    calc_god_equip_attr(T, GodEquipLevelList, NewAcc);
calc_god_equip_attr([_|T], GodEquipLevelList, Acc) ->
    calc_god_equip_attr(T, GodEquipLevelList, Acc).

calc_god_equip_attr_core(Persent, AttrList, AccList) when Persent =/= 0 ->
    Fun = fun({AttrId, Value}, Acc) ->
        NewValue = umath:ceil(Value * Persent div 10000),
        case lists:keyfind(AttrId, 1, Acc) of
            {AttrId, OldValue} ->
                lists:keystore(AttrId, 1, Acc, {AttrId, NewValue+OldValue});
            _ ->
                lists:keystore(AttrId, 1, Acc, {AttrId, NewValue})
        end
    end,
    lists:foldl(Fun, AccList, AttrList);
calc_god_equip_attr_core(_, _, AccList) -> AccList.


kv_list_add(AttrList, AccList) ->
    Fun = fun({AttrId, Value}, Acc) ->
        case lists:keyfind(AttrId, 1, Acc) of
            {AttrId, OldValue} ->
                lists:keystore(AttrId, 1, Acc, {AttrId, Value+OldValue});
            _ ->
                lists:keystore(AttrId, 1, Acc, {AttrId, Value})
        end
    end,
    lists:foldl(Fun, AccList, AttrList).

calc_god_power(Player, GoodsStatus) ->
    #player_status{id = PlayerId, original_attr = SumOAttr} = Player,
    #goods_status{dict = Dict, god_equip_list = GodEquipLevelList} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),
    GodEquipStarAttr = calc_god_equip_attr(EquipList, GodEquipLevelList, []),
    Power = lib_player:calc_partial_power(SumOAttr, 0, GodEquipStarAttr),
    % ?PRINT("============= GodEquipStarAttr:~p~n",[GodEquipStarAttr]),
    Power.

calc_stren_add_power(Player, GoodsStatus, Pos) ->
    #player_status{id = PlayerId, original_attr = SumOAttr} = Player,
    #goods_status{dict = Dict, god_equip_list = GodEquipLevelList} = GoodsStatus,
    EquipList = lib_goods_util:get_equip_list(PlayerId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, Dict),

    case strength_check(Player, Pos, GoodsStatus, EquipList) of
        {true, _, _, NewLevel} ->
            GodEquipStarAttr = calc_god_equip_attr(EquipList, GodEquipLevelList, []),
            NewList = lists:keystore(Pos, 1, GodEquipLevelList, {Pos, NewLevel}),
            NewGodEquipStarAttr = calc_god_equip_attr(EquipList, NewList, []),

            % OldPower = lib_player:calc_partial_power(SumOAttr, 0, GodEquipStarAttr),
            % OldPower1 = lib_player:calc_expact_power(SumOAttr, 0, NewGodEquipStarAttr),
            % ?PRINT("============= OldPower:~p,OldPower1:~p~n",[OldPower,OldPower1]),
            % OldPower1 - OldPower;
            AddAttr = calc_add_attr(GodEquipStarAttr, NewGodEquipStarAttr),
            NewPower = lib_player:calc_expact_power(SumOAttr, 0, AddAttr),
            % ?PRINT("============= GodEquipStarAttr:~p~n,NewGodEquipStarAttr:~p~n",[GodEquipStarAttr,NewGodEquipStarAttr]),
            % ?PRINT("============= NewPower:~p,AddAttr:~p~n",[NewPower,AddAttr]),
            NewPower;
        {false, ErrorCode} ->
            % ?PRINT("======================= ERRCODE:~p~n",[ErrorCode]),
            {false, ErrorCode, Player}
    end.

calc_add_attr(GodEquipStarAttr, NewGodEquipStarAttr) ->

    Fun = fun({Key, Value}, Acc) ->
        case lists:keyfind(Key, 1, GodEquipStarAttr) of
            {_, OldValue} -> lists:keystore(Key, 1, Acc, {Key, max(0, Value - OldValue)});
            _ -> Acc
        end
    end,
    lists:foldl(Fun, NewGodEquipStarAttr, NewGodEquipStarAttr).

calc_real_percent(Pos, Level) ->
    case data_god_equip:get_god_equip_level(Pos, Level) of
        #base_god_equip_level{base_attr_add = BaseAttrAdd} ->
            case lists:keyfind(?BASE_ATTR, 1, BaseAttrAdd) of
                {_, Persent} -> Persent;
                _ -> Persent = 0
            end,
            case lists:keyfind(attr, 1, BaseAttrAdd) of
                {attr, AttrList} ->
                    NewAcc = AttrList;
                _ ->
                    NewAcc = []
            end,
            {Persent, NewAcc};
        _ -> 
            {0, []}
    end.

% calc_real_percent(_Pos, 0, Tem, ExTem, Acc) -> {Tem, ExTem, Acc};
% calc_real_percent(Pos, Level, Tem, ExTem, Acc) ->
%     case data_god_equip:get_god_equip_level(Pos, Level) of
%         #base_god_equip_level{base_attr_add = BaseAttrAdd} ->
%             case lists:keyfind(?BASE_ATTR, 1, BaseAttrAdd) of
%                 {_, Persent} -> Persent;
%                 _ -> Persent = 0
%             end,
%             case lists:keyfind(?EXTRA_ATTR, 1, BaseAttrAdd) of
%                 {_, ExtraPersent} -> ExtraPersent;
%                 _ -> ExtraPersent = 0
%             end,
%             case lists:keyfind(attr, 1, BaseAttrAdd) of
%                 {attr, AttrList} ->
%                     NewAcc = AttrList ++ Acc;
%                 _ ->
%                     NewAcc = Acc
%             end,
%             NewTem = Tem + Persent, 
%             NewExTem = ExTem + ExtraPersent;
%         _ -> 
%             NewTem = Tem,
%             NewExTem = ExTem,
%             NewAcc = Acc
%     end,
%     calc_real_percent(Pos, Level - 1, NewTem, NewExTem, NewAcc).


strength_check(PS, Pos, GoodsStatus, EquipList) ->
    #goods_status{
        god_equip_list = GodEquipLevelList
    } = GoodsStatus,
    case lists:keyfind(Pos, 1, GodEquipLevelList) of
        {Pos, OldLevel} -> skip;
        _ -> OldLevel = 1
    end,
    NewLevel = OldLevel + 1,
    OpenLv = case data_god_equip:get_value(open_lv) of
        OpenLvCfg when is_integer(OpenLvCfg) -> OpenLvCfg;
        _ -> 0
    end,
    case lists:keyfind(Pos, #goods.equip_type, EquipList) of
        #goods{color = Color} = Goods -> Goods;
        _ -> Goods = 0, Color = 999
    end,
    LimitCfg = data_god_equip:get_pos_limit(Pos),
    StageLimit = case lists:keyfind(stage, 1, LimitCfg) of
                    {stage, StageC} -> StageC;
                    _ -> 999
                end,
    StarLimit = case lists:keyfind(star, 1, LimitCfg) of
                    {star, StarC} -> StarC;
                    _ -> 999
                end,
    ColorLimit = case lists:keyfind(color, 1, LimitCfg) of
                    {color, ColorC} -> ColorC;
                    _ -> 999
                end,            
    Stage = lib_equip_api:get_equip_stage(Goods),
    Star = lib_equip_api:get_equip_star(Goods),
    CanBeStren = if
        Stage >= StageLimit andalso Star >= StarLimit andalso Color >= ColorLimit ->
            true;
        true ->
            false
    end,
    LvCfg = data_god_equip:get_god_equip_level(Pos, OldLevel),
    NextLvCfg = data_god_equip:get_god_equip_level(Pos, NewLevel),
    if
        PS#player_status.figure#figure.lv < OpenLv -> {false, ?ERRCODE(lv_limit)};
        is_record(Goods, goods) == false ->{false, ?ERRCODE(err152_not_equip_anything)};
        CanBeStren == false -> {false, {?ERRCODE(err152_equip_stage_star_limit), [StageLimit, StarLimit]}};
        is_record(LvCfg, base_god_equip_level) == false  ->
            {false, ?ERRCODE(missing_config)};
        is_record(NextLvCfg, base_god_equip_level) == false ->
            {false, ?ERRCODE(err152_god_equip_max_lv)};
        true ->
            #base_god_equip_level{cost = Cost} = LvCfg,
            % ?PRINT(" =================== Cost:~p~n",[Cost]),
            {true, Cost, OldLevel, NewLevel}
    end.

strength(PS, Pos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsDict = GoodsStatus#goods_status.dict,
    EquipList = lib_goods_util:get_equip_list(PS#player_status.id, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, GoodsDict),
    case strength_check(PS, Pos, GoodsStatus, EquipList) of
        {true, Cost, OldLevel, NewLevel} ->
            case lib_goods_api:check_object_list(PS, Cost) of
                true ->
                    do_strength(PS, GoodsStatus, Cost, Pos, OldLevel, NewLevel);
                {false, ErrorCode} ->
                    {false, ErrorCode, PS}
            end;
        {false, ErrorCode} ->
            {false, ErrorCode, PS}
    end.

do_strength(PS, GoodsStatus, Cost, Pos, OldLv, NewLv) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    About = lists:concat([Pos, NewLv]),
    CostRes = case lib_goods_api:cost_object_list(PS, Cost, god_equip_strength, About) of
        {true, NewPS1} ->
            NewStatus = lib_goods_do:get_goods_status(),
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                
                #goods_status{
                    dict = OldGoodsDict,
                    god_equip_list = GodEquipLevelList
                } = NewStatus,

                lib_goods_util:update_spirit(RoleId, NewLv),
                replace_god_equip_level(PS#player_status.id, Pos, NewLv),
                NewGodEquipLevelList = lists:keystore(Pos, 1, GodEquipLevelList, {Pos, NewLv}),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                LastStatus = NewStatus#goods_status{
                    dict = Dict,
                     god_equip_list = NewGodEquipLevelList
                },
                {ok, LastStatus, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, LastStatus, GoodsL} ->
                    {ok, LastStatus, GoodsL, NewPS1};
                _ ->
                    {false, GoodsStatus, NewPS1}
            end;
        {false, Res, NewPS1} ->
            {error, Res, NewPS1}
    end,
    case CostRes of
        {ok, NewGoodsStatus, UpdateGoodsList, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            %% 日志
            lib_log_api:log_god_equip_level(RoleId, RoleName, Pos, OldLv, NewLv, Cost),
            EquipList = lib_goods_util:get_equip_list(RoleId, ?GOODS_TYPE_EQUIP, ?GOODS_LOC_EQUIP, NewGoodsStatus#goods_status.dict),
            case lists:keyfind(Pos, #goods.equip_type, EquipList) of
                #goods{goods_id = GtypeId} -> 
                    #ets_goods_type{goods_name = GoodsName} = data_goods_type:get(GtypeId);
                _ -> GtypeId = 0, GoodsName = <<>>
            end,
            case data_god_equip:get_god_all_name(NewLv) of
                [] -> AllLevelName = <<>>;
                AllLevelName -> skip
            end,
            case data_god_equip:get_god_name(NewLv) of
                [] -> LevelName = <<>>;
                LevelName -> skip
            end,
            lib_chat:send_TV({all}, ?MOD_EQUIP, 8, [RoleName, RoleId, GtypeId, 
                util:make_sure_binary(AllLevelName), util:make_sure_binary(GoodsName), util:make_sure_binary(LevelName)]),
            lib_goods_api:notify_client_num(NewPS#player_status.id, UpdateGoodsList),
            {ok, CountPS} = lib_goods_util:count_role_equip_attribute(NewPS),
            {ok, LastPS} = lib_supreme_vip_api:god_equip(CountPS),
            {true, ?SUCCESS, LastPS, NewLv};
        {false, NewGoodsStatus, NewPS} ->
            lib_goods_do:set_goods_status(NewGoodsStatus),
            Title = utext:get(1500013),Content = utext:get(1500014),
            lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost),
            {false, ?FAIL, NewPS};
        Error ->
            ?ERR("upgrade_spirit error:~p", [Error]),
            {false, ?FAIL, PS}
    end.