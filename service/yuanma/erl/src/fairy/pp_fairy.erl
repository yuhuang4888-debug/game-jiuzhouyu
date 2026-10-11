%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 精灵
%%% @end
%%% Created : 07. 十二月 2018 17:10
%%%-------------------------------------------------------------------
-module(pp_fairy).
-author("whao").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("fairy.hrl").
%% API
-compile(export_all).


%% 精灵信息
handle(Cmd = 14801, #player_status{sid = Sid, fairy = Fairy}, []) ->
    #fairy{battle_id = BattleId, fairy_list = FairyList} = Fairy,
    FairyFigure = [{FairyId, Stage, Level} || #fairy_sub{fairy_id = FairyId, stage = Stage, level = Level} <- FairyList],
    lib_server_send:send_to_sid(Sid, pt_148, Cmd, [?SUCCESS, BattleId, FairyFigure]);

%% 单个精灵信息
handle(Cmd = 14802, #player_status{sid = Sid, fairy = Fairy, original_attr = OriginAttr} = PS, [FairyId]) ->
%%    ?PRINT("14802 FairyId:~p~n", [FairyId]),
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false ->
            %lib_server_send:send_to_sid(Sid, pt_148, 14800, [?FAIL]);
            {ok, PS};
        FairyIdFigure ->
            #fairy_sub{fairy_id = FairyId, stage = Stage, level = Level, exp = Exp, combat = _Combat, skill_list = SkillList, attr_list = AttrList} = FairyIdFigure,
            NewCombat = lib_fairy:get_combat(OriginAttr, FairyId, Stage, Level, partial),
            lib_server_send:send_to_sid(Sid, pt_148, Cmd, [?SUCCESS, FairyId, Stage, Level, Exp, NewCombat, SkillList, AttrList])
    end;

%% 精灵升阶
handle(_Cmd = 14803, PS, [FairyId]) ->
%%    ?PRINT("14803 FairyId:~p~n", [FairyId]),
    NewPS = lib_fairy:stage_up(PS, FairyId),
    {ok, battle_attr, NewPS};

%% 精灵升级
handle(14804, #player_status{sid = Sid} = PS, [FairyId]) ->
    case lib_fairy:level_up(PS, FairyId) of
        {ok, NewPS} ->
%%            FairyStage = lib_fairy:get_fairy_stage(NewPS, FairyId),
%%            FairyAttr = lib_fairy:get_fairy_stage(NewPS, FairyId),
%%            Exp = lib_fairy:get_fairy_exp(NewPS, FairyId),
%%            lib_server_send:send_to_sid(Sid, pt_148, 14804, [?SUCCESS, FairyId, FairyStage, Exp, FairyAttr]),
            {ok, battle_attr, NewPS};
        {false, Res} ->
            lib_server_send:send_to_sid(Sid, pt_148, 14800, [Res]);
        Error ->
            ?PRINT("error:~p~n", [Error]),
            {ok, battle_attr, PS}
    end;

%% 精灵幻化
handle(Cmd = 14805, PS, [FairyId]) ->
    #player_status{sid = Sid, id = RoleId, fairy = Fairy} = PS,
    #fairy{battle_id = BattleId, fairy_list = FairyList} = Fairy,
    AllFairyIds = data_fairy:get_all_fairy_id(),
    case lists:member(FairyId, AllFairyIds) of
        true ->
            case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
                false ->
                    lib_server_send:send_to_sid(Sid, pt_148, Cmd, [?ERRCODE(err148_fairy_not_active), BattleId]);
                _ ->
                    NewFairy = Fairy#fairy{battle_id = FairyId},
                    NewPlayer = PS#player_status{fairy = NewFairy},
                    lib_fairy:sql_update_fairy_battle_id(FairyId, RoleId),
                    Player1 = lib_fairy:broadcast_to_scene(FairyId, NewPlayer),
                    lib_server_send:send_to_sid(Sid, pt_148, Cmd, [?SUCCESS, FairyId]),
                    {ok, Player1}
            end;
        false ->
            lib_server_send:send_to_sid(Sid, pt_148, Cmd, [?ERRCODE(err148_not_exist_fairy), BattleId])
    end;

handle(14807, PS, [FairyId]) ->
    lib_fairy:get_no_active_info(PS, FairyId);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.






