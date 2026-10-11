%% ---------------------------------------------------------------------------
%% @doc pp_constellation_forge

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2019/11/4
%% @deprecated  星宿锻造协议
%% ---------------------------------------------------------------------------
-module(pp_constellation_forge).

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("constellation_forge.hrl").
-include("constellation_equip.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").

%% API
-compile([export_all]).

%% 强化界面
handle(23210, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?STRENGTH_LV of
        true ->
            lib_constellation_forge:strength_info(PS, TypeId);
        _ ->
            skip
    end,
    {ok, PS};

%% 强化
handle(23211, PS, [TypeId, Pos, Type]) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?STRENGTH_LV of
        true ->
            case lib_constellation_forge:strength(PS, TypeId, Pos, Type) of
                {true, NewPs} ->
                    {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23211, [ErroCode, TypeId, Pos, Type, 0, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23211, [?LEVEL_LIMIT, TypeId, Pos, Type, 0, 0]),
            {ok, PS}
    end;

%% 强化大师界面
handle(23212, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?STRENGTH_LV of
        true ->
            lib_constellation_forge:strength_master_info(PS, TypeId);
        _ ->
            skip
    end,
    {ok, PS};


%% 点亮强化大师
handle(23213, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?STRENGTH_LV of
        true ->
            case lib_constellation_forge:lighten_strength_master(PS, TypeId) of
                {true, NewPs} -> {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23213, [ErroCode, TypeId, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23213, [?LEVEL_LIMIT, TypeId, 0]),
            {ok, PS}
    end;

%% 进化界面
handle(23220, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?EVOLUTION_LV of
        true ->
            lib_constellation_forge:evolution_info(PS, TypeId);
        _ ->
            skip
    end,
    {ok, PS};

%% 进化
handle(23221, PS, [TypeId, EquipId, Pos, CostEquipList]) ->
    ?PRINT("@@@@@@@@@ ~p ~n", [CostEquipList]),
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?EVOLUTION_LV of
        true ->
            case lib_constellation_forge:evolution(PS, TypeId, EquipId, Pos, CostEquipList) of
                {true, NewPs} -> {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23211, [ErroCode, ?EVOLUTION_FAIL, TypeId, EquipId, Pos, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23211, [?LEVEL_LIMIT, ?EVOLUTION_FAIL, TypeId, EquipId, Pos, 0]),
            {ok, PS}
    end;

%% 附魔界面
handle(23230, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?ENCHANTMENT_LV of
        true ->
            lib_constellation_forge:enchantment_info(PS, TypeId);
        _ ->
            skip
    end,
    {ok, PS};

%% 附魔
handle(23231, PS, [TypeId, Pos, Type]) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?ENCHANTMENT_LV of
        true ->
            case lib_constellation_forge:enchantment(PS, TypeId, Pos, Type) of
                {true, NewPs} ->
                    {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23211, [ErroCode, TypeId, Pos, Type, 0, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23211, [?LEVEL_LIMIT, TypeId, Pos, Type, 0, 0]),
            {ok, PS}
    end;

%% 附魔大师界面
handle(23232, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?ENCHANTMENT_LV of
        true ->
            lib_constellation_forge:enchantment_master_info(PS, TypeId);
        _ ->
            skip
    end,
    {ok, PS};

%% 点亮附魔大师
handle(23233, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?ENCHANTMENT_LV of
        true ->
            case lib_constellation_forge:lighten_enchantment_master(PS, TypeId) of
                {true, NewPs} -> {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23233, [ErroCode, TypeId, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23233, [?LEVEL_LIMIT, TypeId, 0]),
            {ok, PS}
    end;

%% 启灵界面
handle(23240, PS, [TypeId]) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    case RoleLv >= ?SPIRIT_LV of
        true ->
            lib_constellation_forge:spirit_info(PS, TypeId);
        _ -> skip
    end,
    {ok, PS};

%% 启灵
handle(23241, PS, [TypeId, Pos]) ->
    #player_status{figure = #figure{lv = RoleLv}, id = RoleId} = PS,
    case RoleLv >= ?SPIRIT_LV of
        true ->
            case lib_constellation_forge:spirit(PS, TypeId, Pos) of
                {true, NewPs} -> {ok, battle_attr, NewPs};
                {false, ErroCode} ->
                    lib_server_send:send_to_uid(RoleId, pt_232, 23241, [ErroCode, TypeId, Pos, 0]),
                    {ok, PS}
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_232, 23241, [?LEVEL_LIMIT, TypeId, 0, 0]),
            {ok, PS}
    end;

handle(Cmd, PS, Args) ->
    ?ERR("protocol ~p, ~p nomatch ~n", [Cmd, Args]),
    ?PRINT("err ~p ~n", [Args]),
    {ok, PS}.


