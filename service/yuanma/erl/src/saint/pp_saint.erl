%%%--------------------------------------
%%% @Module  : pp_saint
%%% @Author  : fwx
%%% @Created : 2018.6.13
%%% @Description:  圣者殿
%%%--------------------------------------

-module(pp_saint).

-export([handle/3]).
-export([send_error/2, send_error/3, send/4]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("saint.hrl").
-include("attr.hrl").
-include("def_fun.hrl").

handle(Cmd, Player, Data) ->
    #player_status{sid = Sid, figure = #figure{lv = RoleLv}} = Player,
    case lib_module:is_open(?MOD_SAINT, 1, RoleLv) of
        true ->
            do_handle(Cmd, Player, Data);
        false ->
            send_error(Sid, ?ERRCODE(lv_limit))
    end.

%% 圣者殿详细信息
do_handle(Cmd = 60701, #player_status{sid = Sid, role_saint = RoleSaint}, []) ->
    case mod_clusters_node:get_link_state() of
        0 ->
            lib_server_send:send_to_sid(Sid, pt_607, Cmd, [0, []]);
        _ ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_saint, get_saint_info, [Node, RoleSaint])
    end;

%% 进入圣者殿大厅
do_handle(_Cmd = 60702, #player_status{sid = Sid, scene = Scene, role_saint = RoleSaint} = Player, [StoneId]) ->
    ReadyScene = ?READY_SCENE,
    case data_saint:get_stone(StoneId) of
        [] ->
            send_error(Sid, ?ERRCODE(err_config));
        _ when Scene == ReadyScene ->
            send_error(Sid, ?ERRCODE(err120_already_in_scene));
        _ ->
            case lib_player_check:check_all(Player) of
                {false, Code} ->
                    send_error(Sid, Code);
                true->
                    case check_enter_saint(Player, StoneId) of
                        {false, Code} ->
                            send_error(Sid, Code);
                        true ->
                            %% 进入圣者殿大厅
                            Node = mod_disperse:get_clusters_node(),
                            mod_clusters_node:apply_cast(mod_saint, enter_saint, [Node, RoleSaint, StoneId])
                    end
            end
    end;

%% 挑战次数
do_handle(_Cmd = 60703, #player_status{id = RoleId, sid = Sid}, []) ->
    UseCount = mod_daily:get_count(RoleId, ?MOD_SAINT, 1),
    MaxCount = mod_daily:get_limit_by_type(?MOD_SAINT, 1),
    lib_server_send:send_to_sid(Sid, pt_607, 60703, [max(0, MaxCount - UseCount), MaxCount]);

%% 挑战
do_handle(_Cmd = 60704, Player, [StoneId]) ->
    #player_status{
        id = RoleId,
        sid = Sid,
        scene = Scene,
        role_saint = RoleSaint,
        server_name = ServerName,
        figure = Figure,
        combat_power = Combat,
        battle_attr = #battle_attr{attr = Attr},
        quickbar = QuickBar
        } = Player,
    RoleData = #role_data{
        server_name = ServerName,
        role_id = RoleId,
        figure = Figure,
        combat = Combat,
        skills = [ {Id, 1} || {_, Type, Id, _} <- QuickBar, Type =:= 2 ],
        attr = Attr
    },
    UseCount = mod_daily:get_count(RoleId, ?MOD_SAINT, 1),
    MaxCount = mod_daily:get_limit_by_type(?MOD_SAINT, 1),
    ReadyScene = ?READY_SCENE,
    case data_saint:get_stone(StoneId) of
        [] -> send_error(Sid, ?ERRCODE(err_config));
        _ when Scene =/= ReadyScene -> skip;
        %_ when UseCount >= MaxCount -> send_error(Sid, ?ERRCODE(err607_not_enter_times));
        _ ->
            Node = mod_disperse:get_clusters_node(),
            %% 前3次发奖励
            IsReward = ?IF(UseCount >= MaxCount, 0, 1),
            mod_clusters_node:apply_cast(mod_saint, challenge_saint, [Node, RoleSaint, StoneId, RoleData, IsReward])
    end;

%% 我要属性
do_handle(60705, #player_status{sid = Sid, id = _RoleId, scene = _Scene, battle_field = BattleField, figure = Figure}, [IsWant]) ->
    case BattleField of
        #{mod_lib := lib_saint_battle, pid := BattlePid} ->
            %Node = mod_disperse:get_clusters_node(),
                mod_clusters_node:apply_cast(mod_battle_field, apply_cast, [BattlePid, lib_saint_battle, want_attr, [IsWant, Figure#figure.name]]);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_607, 60705, [IsWant])
    end;

%% 鼓舞信息
do_handle(60706, #player_status{id = _RoleId, scene = _Scene, battle_field = BattleField} = _Player, []) ->
    case BattleField of
        #{mod_lib := lib_saint_battle, pid := BattlePid} ->
            %Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_battle_field, apply_cast, [BattlePid, lib_saint_battle, send_inspire_list, []]);
        _ -> skip
    end;

%%%% 鼓舞
do_handle(60707, #player_status{sid = Sid, scene = _Scene, battle_field = BattleField, role_saint = RoleSaint, figure = Figure} = Player, [InspireId]) ->
    case BattleField of
        #{mod_lib := lib_saint_battle, pid := BattlePid} ->
            #role_saint{inspire_times = InsNumL} = RoleSaint,
            InsNum = case lists:keyfind(InspireId, 1, InsNumL) of
                         {_, Num} -> Num;
                         _ -> 0
                     end,
            %Node = mod_disperse:get_clusters_node(),
            case data_saint:get_inspire(InspireId) of
                #base_saint_inspire{type = Type, price = Price, num_limit = NumLimit} when InsNum < NumLimit ->
                    Cost = [{Type, 0, Price}],
                    case lib_goods_api:cost_object_list_with_check(Player, Cost, saint_inspire, "") of
                        {true, NewPlayer} ->
                            mod_clusters_node:apply_cast(mod_battle_field, apply_cast, [BattlePid, lib_saint_battle, inspire, [InspireId, InsNum, Figure#figure.name]]),
                            NewInsNumL = lists:keystore(InspireId, 1, InsNumL, {InspireId, InsNum + 1}),
                            {ok, NewPlayer#player_status{role_saint = RoleSaint#role_saint{inspire_times = NewInsNumL}}};
                        {false, ErrorCode, _NewPlayer} ->
                            send_error(Sid, ErrorCode)
                    end;
                #base_saint_inspire{} ->
                    send_error(Sid, ?ERRCODE(err607_inspire_num_limit));
                _ ->
                    send_error(Sid, ?ERRCODE(err_config))
            end;
        _ -> skip
    end;

%% 离开圣者殿大厅
do_handle(60708, #player_status{sid = Sid, id = RoleId, server_id = ServerId, scene = Scene}, []) ->
    case Scene =:= ?READY_SCENE of
        false -> skip;
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_saint, leave_saint, [Node, RoleId, ServerId]),
            lib_server_send:send_to_sid(Sid, pt_607, 60708, [?SUCCESS])
    end;

%% 离开圣者殿战斗场景
do_handle(60709, #player_status{sid = Sid, id = RoleId, server_id = _ServerId, scene = Scene, battle_field = BattleField}, []) ->
    case Scene =:= ?FIGHT_SCENE of
        false -> skip;
        true ->
            case BattleField of
                #{mod_lib := lib_saint_battle, pid := BattlePid} ->
                    _Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_battle_field, player_quit, [BattlePid, RoleId, []]),
                    lib_server_send:send_to_sid(Sid, pt_607, 60709, [?SUCCESS]);
                _ ->
                    skip
            end
    end;

%% 挑战记录信息
do_handle(60711, #player_status{role_saint = RoleSaint}, [SaintId]) ->
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_saint, get_saint_challenge_record, [Node, RoleSaint, SaintId]);


do_handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

check_enter_saint(#player_status{id = _RoleId}, _StoneId) ->
%%    UseCount = mod_daily:get_count(RoleId, ?MOD_SAINT, 1),
%%    MaxCount = mod_daily:get_limit_by_type(?MOD_SAINT, 1),
%%    case UseCount >= MaxCount of
%%        true ->
%%            {false, ?ERRCODE(err607_not_enter_times)};
%%        _ ->
%%            true
%%    end.
    true.

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_607:write(60700, [CodeInt, CodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData).

send_error(Node, RoleId, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, Bin} = pt_607:write(60700, [CodeInt, CodeArgs]),
    lib_clusters_center:send_to_uid(Node, RoleId, Bin).

send(Node, RoleId, Cmd, Args) ->
    {ok, Bin} = pt_607:write(Cmd, Args),
    lib_clusters_center:send_to_uid(Node, RoleId, Bin).

