%% ---------------------------------------------------------------------------
%% @doc 装备模块
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------
-module(pp_equip).
-export([handle/3]).
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("equip_suit.hrl").

%% 穿戴装备
handle(Cmd = 15201, #player_status{sid = Sid} = PS, [GoodsId]) ->
    case lib_equip:equip(PS, GoodsId) of
        {true, Res, OldGoodsInfo, NewGoodsInfo, Cell, NewPS} ->
            OldGoodsId = case is_record(OldGoodsInfo, goods) of
                             true -> OldGoodsInfo#goods.id;
                             false -> 0
                         end,
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId, OldGoodsId, NewGoodsInfo#goods.goods_id, Cell]),
            {ok, equip, NewPS};
        {false, Res, NewPS} -> 
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;

%% 卸下装备
handle(Cmd = 15202, #player_status{sid = Sid} = PS, [GoodsId]) ->
    case lib_equip:unequip(PS, GoodsId) of
        {true, Res, NewGoodsInfo, Cell, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId, Cell]),
            {ok, NewPS2} = lib_player_event:dispatch(NewPS, ?EVENT_UNEQUIP, NewGoodsInfo),
            lib_common_rank_api:reflash_rank_by_equipment(NewPS2),
            {ok, equip, NewPS2};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;

%% 强化信息
handle(Cmd = 15204, #player_status{sid = Sid} = PS, [EquipPos]) ->
    {Res, Stren} = lib_equip:stren_info(PS, EquipPos),
    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, Stren]),
    ok;

%% 强化装备
handle(Cmd = 15205, #player_status{sid = Sid} = PS, [EquipPos, EquipType]) ->
    case lib_equip:stren(PS, EquipPos, EquipType) of
        {true, Res, InfoL, NewPS} ->        
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res,0, EquipType, InfoL]),
            {ok, equip, NewPS};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
            {ok, NewPS};
        {false, Res,ErrEquipPos, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res,ErrEquipPos, EquipType, [] ]),
            {ok, NewPS};
        Error->
            ?PRINT("error:~p~n",[Error]),
            {ok, PS}
    end;

%% 进阶装备
handle(Cmd = 15206, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [GoodsId]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 3),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:upgrade_stage(PS, GoodsId) of
                {true, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

%% 进阶属性预览
handle(Cmd = 15207, #player_status{sid = Sid, figure = #figure{lv = Rolelv}}, [GoodsId]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 3),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:upgrade_stage_preview(GoodsId) of
                {true, GTypeId, Rating, TotalRating, PreviewExtraAttr} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [GTypeId, Rating, TotalRating, PreviewExtraAttr]);
                {false, Res} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]);
                _ -> skip
            end;
        false ->
            skip
    end;

% 宝石镶嵌
handle(Cmd = 15208, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, StonePos, GoodsId]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 4),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:equip_stone(PS, EquipPos, StonePos, GoodsId) of
                {true, Res, GoodsTypeId, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, StonePos, GoodsTypeId]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, StonePos, 0]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)]),
            {ok, PS}   %%chenyiming
    end;

% 宝石拆除
handle(Cmd = 15209, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, StonePos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 4),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:unequip_stone(PS, EquipPos, StonePos) of
                {true, Res, NewPS} ->
                    lib_rush_rank_api:reflash_rank_by_stone_rush(NewPS),
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, StonePos]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% 宝石精炼信息
handle(Cmd = 15210, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 5),
    case Rolelv >= OpenLv of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{equip_stone_list = EquipStoneList} = GoodsStatus,
            case lists:keyfind(EquipPos, 1, EquipStoneList) of
                {EquipPos, PosStoneInfoR} ->
                    #equip_stone{refine_lv = RefineLv, exp = Exp} = PosStoneInfoR,
                    Attr = data_goods:do_count_stone_attribute(EquipPos, PosStoneInfoR);
                _ -> RefineLv = 0, Exp = 0, Attr = []
            end,
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [?SUCCESS, EquipPos, RefineLv, Exp, Attr]),
            {ok, PS};
        false -> skip
    end;

% 宝石精炼
handle(Cmd = 15211, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, GTypeId, OneKey]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 5),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:stone_refine(PS, EquipPos, GTypeId, OneKey) of
                {true, Res, IsUp, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, IsUp, OneKey]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% 开启洗炼属性槽
handle(Cmd = 15212, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, WashPos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 2),
    case Rolelv >= OpenLv of
        true ->
            ?PRINT("15212========~w~n",[[EquipPos, WashPos]]),
            case lib_equip:unlock_wash_pos(PS, EquipPos, WashPos) of
                {true, Res, WashPos, GoodsId, NewPS} ->
%%                    ?PRINT("15212 [Res, GoodsId, WashPos] :~w~n",[[Res, GoodsId, WashPos]]),
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId, WashPos]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    ?PRINT("15200  res: ~p~n",[Res]),
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS};
                _ -> {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% 洗炼装备  0：普通洗练 1：紫色保底（现改为橙色及以上） 2：红色保底 3：橙色保底
handle(Cmd = 15213, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, LockAttrList, RatioPlus]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 2),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:equip_wash(PS, EquipPos, LockAttrList, RatioPlus) of
                {true, Res, GoodsId, WashUpdatePos, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId, WashUpdatePos]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, 0, []]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [?ERRCODE(lv_limit), 0, []])
    end;

%% 获取洗练免费次数
handle(Cmd = 15214, #player_status{sid = Sid,id = RoleId, figure = #figure{lv = Rolelv}} , []) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 2),
    case Rolelv >= OpenLv of
        true ->
            UseTimes= mod_daily:get_count(RoleId, ?MOD_EQUIP, ?FREE_COUNT_ID),
            FreeTimes = max(0,(?FREE_TIMES-UseTimes)),
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [FreeTimes]);
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% 升段
handle(Cmd = 15252, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, AutoBuy]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 2),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:upgrade_division(PS, EquipPos, AutoBuy) of
                {true, Res, GoodsId, _NewDivision, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsId]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS};
                _ ->
                    {ok, PS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% 宝石升级
handle(Cmd = 15215, #player_status{sid = Sid} = PS, [EquipPos, StonePos, IsOneKey]) ->
    case lib_equip:upgrade_stone_on_equip(PS, EquipPos, StonePos, IsOneKey) of
        {true, NewPS, NewStoneId} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [1, EquipPos, StonePos, NewStoneId]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, StonePos, 0]),
            {ok, PS}
    end;

% 宝石合成
handle(Cmd = 15216, #player_status{sid = Sid} = PS, [GoodsTypeId, IsOneKey]) ->
    case lib_equip:combine_stone(PS, GoodsTypeId, IsOneKey) of
        {true, NewPS} ->
            lib_rush_rank_api:reflash_rank_by_stone_rush(NewPS),
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [1, GoodsTypeId, IsOneKey]),
            {ok, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, GoodsTypeId, IsOneKey]),
            {ok, PS}
    end;

handle(Cmd = 15217, #player_status{id = RoleId, sid = Sid, figure = #figure{lv = Rolelv}} = PS, []) ->
    case data_god_equip:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) andalso Rolelv >= OpenLv ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{god_equip_list = GodLevelList} = GoodsStatus,
            if
                GodLevelList == [] ->
                    NewGodLevelList = lib_god_equip:calc_default_god_equiplevel(),
                    NewGoodsStatus = GoodsStatus#goods_status{god_equip_list = NewGodLevelList},
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    Power = lib_god_equip:calc_god_power(PS, NewGoodsStatus),
                    lib_god_equip:replace_god_equip_level(RoleId, NewGodLevelList);
                true ->
                    NewGodLevelList = GodLevelList,
                    Power = lib_god_equip:calc_god_power(PS, GoodsStatus)
            end,

            % ?PRINT("========= Power:~p~n",[Power]),
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Power, NewGodLevelList]);
        _ ->
            skip
    end,
    {ok, PS};

handle(Cmd = 15218, #player_status{sid = Sid} = PS, [Pos]) ->
    % ?PRINT("========= ~n",[]),
    case lib_god_equip:strength(PS, Pos) of
        {true, ErrorCode, LastPS, _NewLv} ->skip;
        {false, ErrorCode, LastPS} ->skip;
        _ -> ErrorCode = ?FAIL, LastPS = PS
    end,
    % ?PRINT("========= ErrorCode:~p~n",[ErrorCode]),
    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [ErrorCode]),
    {ok, LastPS};

handle(Cmd = 15219, #player_status{sid = Sid} = PS, [Pos]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_god_equip:calc_stren_add_power(PS, GoodsStatus, Pos) of
        AddPower when is_integer(AddPower) ->
            % ?PRINT("========= AddPower:~p~n",[AddPower]),
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [AddPower]);
        _ ->skip
    end,
    {ok, PS};

%% 套装信息
handle(15220, PS, []) ->
    SuitInfoSend = lib_equip:suit_info(),
    {ok, Bin} = pt_152:write(15220, [SuitInfoSend]),
    lib_server_send:send_to_sid(PS#player_status.sid, Bin);

%% 套装打造
handle(15221, #player_status{id = _RoleId, sid = Sid} = PS, [Lv, EquipPos]) ->
    Type = lib_equip:get_suit_type(EquipPos),
    case Type of
        ?ACCESSORY ->
            Return = lib_equip:make_suit(PS, Lv, EquipPos);
        _ ->
            Return = lib_equip:new_make_suit_rule(PS, Lv, EquipPos)
    end,
    case Return of
        {true, NewPS, _NewGoodsStatus, _Lv, SLv, NewSuitInfo} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15221, [EquipPos, Lv, SLv, NewSuitInfo]),
            {ok, equip, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]);
        _ ->
            ok
    end;

%% 套装还原
handle(15222, #player_status{sid = Sid} = PS, [Lv, EquipPos]) ->
    Type = lib_equip:get_suit_type(EquipPos),
    case Type of
        ?ACCESSORY ->
            Return = lib_equip:restore_suit(PS, Lv, EquipPos);
        _ ->
            Return = lib_equip:new_restore_suit(PS, Lv, EquipPos)
    end,
    case Return of
        {true, NewPS, NewLv, SLv, RewardListSendNew, NewSuitInfo} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15222, [EquipPos, NewLv, SLv, RewardListSendNew, NewSuitInfo]),
            {ok, equip, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]);
        _ ->
            ok
    end;

%% 套装还原奖励预览
handle(15223, #player_status{sid = Sid} = PS, [Lv, EquipPos]) ->
    Type = lib_equip:get_suit_type(EquipPos),
    case Type of
        ?ACCESSORY ->
            Return = lib_equip:restore_suit_preview(PS, Lv, EquipPos);
        _ ->
            Return = lib_equip:new_restore_suit_preview(PS, Lv, EquipPos)
    end,
    case Return of
        {true, RewardListSendNew} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15223, [EquipPos, Lv, RewardListSendNew]),
            ok;
        _ ->
            ok
    end;


%% 铸灵信息
handle(Cmd = 15230, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, _) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    case Rolelv >= OpenLv of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{equip_casting_spirit = CastingSpiritL} = GoodsStatus,
            GPTScore = lib_dungeon_evil:get_history_max_score(PS),
            PackList = [{TPos, TStage, TLv} || #equip_casting_spirit{pos = TPos, stage = TStage, lv = TLv} <- CastingSpiritL],
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [GPTScore, PackList]);
        false ->
            skip
    end;

%% 铸灵
handle(Cmd = 15231, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:casting_spirit(PS, EquipPos) of
                {true, Res, NewPS, NewStage, NewLv} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, NewStage, NewLv]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

%% 护灵信息
handle(Cmd = 15232, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = _PS, _) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    case Rolelv >= OpenLv of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            #goods_status{equip_spirit = EquipSpirit} = GoodsStatus,
            #equip_spirit{lv = Lv} = EquipSpirit,
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Lv]);
        false ->
            skip
    end;

%% 护灵
handle(Cmd = 15233, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, _) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 8),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:upgrade_spirit(PS) of
                {true, Res, NewPS, NewLv} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, NewLv]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

%% 觉醒
handle(Cmd = 15241, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 9),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:awakening(PS, EquipPos) of
                {true, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos]),
                    {ok, equip, NewPS};
                {false, Res, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
                    {ok, NewPS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

% %% 唤魔信息
% handle(Cmd = 15242, #player_status{sid = Sid, id = RoleId, figure = #figure{lv = Rolelv}} = _PS, _) ->
%     OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
%     case Rolelv >= OpenLv of
%         true ->
%             GoodsStatus = lib_goods_do:get_goods_status(),
%             #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
%             EquipInfoL = lib_goods_util:get_equip_list(RoleId, GoodsStatus#goods_status.dict),
%             F = fun(#equip_skill{pos = Pos, skill_id = SkillId, skill_lv = Lv}) ->
%                 case lists:keyfind(Pos, #goods.cell, EquipInfoL) of
%                     EquipInfo when is_record(EquipInfo, goods) ->
%                         AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
%                         RealLv = min(Lv, AwakeningLv),
%                         {Pos, SkillId, RealLv};
%                     _ -> {Pos, SkillId, 0}
%                 end
%             end,
%             Data = lists:map(F, EquipSkillL),
%             lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Data]);
%         false ->
%             lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
%     end;

% %% 唤魔信息
% handle(Cmd = 15243, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = _PS, [EquipPos]) ->
%     OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
%     case Rolelv >= OpenLv of
%         true ->
%             GoodsStatus = lib_goods_do:get_goods_status(),
%             #goods_status{equip_skill_list = EquipSkillL} = GoodsStatus,
%             case lists:keyfind(EquipPos, #equip_skill.pos, EquipSkillL) of
%                 #equip_skill{skill_id = SkillId, skill_lv = Lv} ->
%                     EquipInfo = lib_equip:get_equip_by_location(GoodsStatus, EquipPos),
%                     AwakeningLv = lib_equip:count_awakening_lv(GoodsStatus, EquipInfo),
%                     RealLv = min(Lv, AwakeningLv);
%                 _ -> SkillId = 0, RealLv = 0
%             end,
%             lib_server_send:send_to_sid(Sid, pt_152, Cmd, [EquipPos, SkillId, RealLv]);
%         false ->
%             lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
%     end;

%% 唤魔技能操作
handle(Cmd = 15244, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos, Type, SkillId]) when Type == 1 orelse Type == 2 ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
    case Rolelv >= OpenLv of
        true ->
            Res = case Type of
                      1 ->
                          lib_equip:add_equip_skill(PS, EquipPos, SkillId);
                      _ ->
                          lib_equip:remove_equip_skill(PS, EquipPos)
                  end,
            case Res of
                {true, ErrorCode, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [ErrorCode, EquipPos, Type]),
                    {ok, equip, NewPS};
                {false, ErrorCode, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [ErrorCode]),
                    {ok, NewPS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

%% 唤魔技能升级
handle(Cmd = 15245, #player_status{sid = Sid, figure = #figure{lv = Rolelv}} = PS, [EquipPos]) ->
    OpenLv = lib_module:get_open_lv(?MOD_EQUIP, 10),
    case Rolelv >= OpenLv of
        true ->
            case lib_equip:upgrade_equip_skill(PS, EquipPos) of
                {true, ErrorCode, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [ErrorCode, EquipPos]),
                    {ok, equip, NewPS};
                {false, ErrorCode, NewPS} ->
                    lib_server_send:send_to_sid(Sid, pt_152, 15200, [ErrorCode]),
                    {ok, NewPS}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [?ERRCODE(lv_limit)])
    end;

%% 精炼信息
handle(Cmd = 15250, #player_status{sid = Sid}, [EquipPos]) ->
    {Res, Refine,RefineHigh} = lib_equip:refine_info(EquipPos),
    lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res, EquipPos, Refine, RefineHigh]),
    ok;

%% 精炼装备
handle(Cmd = 15251, #player_status{sid = Sid} = PS, [EquipPos, EquipType]) ->
    case lib_equip:refine(PS, EquipPos, EquipType) of
        {true, Res, InfoL, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res,0, EquipType, InfoL]),
            {ok, equip, NewPS};
        {false, Res,ErrEquipPos, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, Cmd, [Res,ErrEquipPos, EquipType, []]),
            {ok,NewPS};
        {false, Res, NewPS} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15200, [Res]),
            {ok, NewPS};
        _ ->
            {ok, PS}
    end;

%% 子功能战力值
handle(15254, #player_status{sid = Sid} = PS, [SubMod]) ->
    Power = lib_equip:get_equip_sub_mod_power(PS, SubMod),
    lib_server_send:send_to_sid(Sid, pt_152, 15254, [SubMod, Power]),
    ok;

%% 神炼
handle(15255, #player_status{sid = Sid} = PS, [GoodsId]) ->
    case lib_equip_refinement:promote(PS, GoodsId) of
        {ok, LastPS, GoodsId, NewRefineLv} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15255, [1, GoodsId, NewRefineLv]),
            {ok, LastPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_152, 15255, [Res, GoodsId, 0])
    end;

%% 套装收集信息
handle(15256, PS, []) ->
    lib_suit_collect:send_suit_clt_list(PS);

%% 套装收集激活
handle(15257, PS, [SuitId, CltStage]) ->
    case lib_suit_collect:suit_collect(PS, SuitId, CltStage) of 
        {ok, NewPS, SuitCltItem} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_152, 15257, [1, SuitId, CltStage, SuitCltItem#suit_clt_item.pos_list]),
            {ok, NewPS};
        {fail, Res} ->
            lib_server_send:send_to_sid(PS#player_status.sid, pt_152, 15257, [Res, SuitId, CltStage, []])
    end;

%% 穿戴/脱下 套装收集时装
handle(15259, PS, [SuitId, IsWear]) ->
    case lib_suit_collect:wear_model(PS, SuitId, IsWear) of
        {fail, ErrCode} ->
            Args = [ErrCode, SuitId, IsWear],
            NewPS = PS;
        {ok, NewPS} ->
            Args = [?SUCCESS, SuitId, IsWear]
    end,
    lib_server_send:send_to_sid(NewPS#player_status.sid, pt_152, 15259, Args),
    {ok, NewPS};

handle(15260, PS, [Type]) ->
    case lists:member(Type, ?MANUAL_WHOLE_AWARD_LIST) of
        true -> NewPS = lib_equip:manual_whole_award(PS, Type);
        _ -> NewPS = PS
    end,
    {ok, NewPS};

handle(15261, PS, []) ->
    lib_equip:list_manual_whole_award(PS);

handle(15262, Ps, [EquipPos, MakeType, Level]) ->
    lib_equip:send_suit_combat_info(Ps, EquipPos, MakeType, Level);

handle(_Cmd, _PS, _Data) ->
    ?ERR("no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_equip no match"}.

%% --------------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------------