%%-----------------------------------------------------------------------------
%% @Module  :       lib_saint_battle.erl
%% @Author  :       Fwx
%% @Email   :       421307471@qq.com
%% @Created :       2018-6-15
%% @Description:    圣者殿战斗
%%-----------------------------------------------------------------------------

-module(lib_saint_battle).
-include("battle_field.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("saint.hrl").
-include("buff.hrl").
-include("def_module.hrl").
-include("figure.hrl").

%% 行为接口
-export([
    %% 战场进程
    init/2
    , player_enter/3
    , player_quit/3
    , player_logout/3
    , player_disconnect/3
    , player_finish_change_scene/3
    , player_die/3
    , player_revive/3
    , player_reconnect/3
    %% 玩家进程
    , evt_out_of_battle/2
    % % ,mon_hp_change/3
    , mon_die/3
    , terminate/2
]).

%% 其它接口
-export([
    saint_die_handler/5,
    want_attr/2,
    send_inspire_list/2,
    inspire/2,
    battle_time_out/2,
    adjudge_battle/2,
    get_scene_obj_hp/2,
    time_check_buff/2
]).

init(State, Args) ->
    SaintX = data_saint:get_cfg(fight_scene_saint_x),
    SaintY = data_saint:get_cfg(fight_scene_saint_y),
    SceneId = data_saint:get_cfg(fight_scene),
    case Args of
        [RoleNode, RoleId, ServerId, SaintId, SaintRoleId, SaintInitData, IsReward] ->
            RoleMap = #{RoleId => #battle_role{key = RoleId}},
            case SaintRoleId of
                0 ->  %% 石像
                    SaintServerName = <<>>,
                    SaintFigure = #figure{},
                    SaintArgs = [{die_handler, {?MODULE, saint_die_handler, [State#battle_state.self]}}],
                    Id = lib_scene_object:sync_create_object(?BATTLE_SIGN_MON, SaintId, SceneId, 0, SaintX, SaintY, 1, RoleId, 1, SaintArgs);
                _ ->    %% 玩家假人
                    [SaintServerName, SaintFigure, SaintAttr, SaintSkills] = SaintInitData,
                    SaintArgs = [{figure, SaintFigure}, {battle_attr, #battle_attr{hp = SaintAttr#attr.hp, hp_lim = SaintAttr#attr.hp, attr = SaintAttr}}, {skill, SaintSkills},
                        {die_handler, {?MODULE, saint_die_handler, [State#battle_state.self]}}, {group, 2}, {warning_range, 600}],
                    Id = lib_scene_object:sync_create_object(?BATTLE_SIGN_DUMMY, 0, SceneId, 0, SaintX, SaintY, 1, RoleId, 1, SaintArgs)
            end,
            Data = #{saint => #{data => SaintInitData, id => Id},
                node => RoleNode, saint_id => SaintId, server_id => ServerId,
                saint_role_id => SaintRoleId, saint_role_name => SaintFigure#figure.name, saint_server_name => SaintServerName,
                is_reward => IsReward},
            NewState = State#battle_state{cur_scene = SceneId, scene_pool_id = 0, copy_id = RoleId, roles = RoleMap, data = Data};
        _ ->
            NewState = State
    end,
    {ok, NewState}.

player_enter(RoleKey, Args, State) ->
    #battle_state{roles = RoleMap} = State,
    case maps:find(RoleKey, RoleMap) of
        {ok, #battle_role{out_info = OutInfo, in_info = InInfo} = Role} ->
            [OSceneId, OPoolId, OCopyId, X, Y, Hp, HpLim] = Args,
            NewOutInfo
                = OutInfo#{
                scene => OSceneId,
                scene_pool_id => OPoolId,
                copy_id => OCopyId,
                x => X,
                y => Y,
                hp => max(1, Hp),
                hp_lim => HpLim,
                scene_args => []
            },
            if
                Hp > 0 ->
                    InSceneArgs = [{hp_lim, HpLim}, {hp, HpLim}, {group, 1}];
                true ->
                    InSceneArgs = [{change_scene_hp, 1}, {group, 1}]
            end,
            {ok, Role#battle_role{out_info = NewOutInfo, in_info = InInfo#{scene_args => InSceneArgs}}, State};
        _ ->
            skip
    end.

%%
player_quit(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false} = State) ->
    %?PRINT("player_quit res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, data = D} = State,
    NewState = handle_result(State#battle_state{data = D#{res => 0}}),
    Role = maps:get(RoleKey, RoleMap),
    {ok, Role, NewState};
player_quit(_Role, _Args, _State) -> skip.

%% 掉线
player_logout(#battle_role{key = RoleKey} = Role, Args,
    #battle_state{is_end = false, data = #{node := Node, server_id := ServerId}} = State) ->
    %?PRINT("player_logout res = ~p~n", [ok]),
    mod_saint:logout_saint(Node, RoleKey, ServerId),
    player_quit(Role, Args, State);
player_logout(_Role, _Args, _State) -> skip.

%% 断开客户端
player_disconnect(Role, Args, State) ->
    %?PRINT("player_disconnect res = ~p~n", [ok]),
    player_quit(Role, Args, State).

%% 重连
player_reconnect(_, _, _) ->
    skip.

player_die(#battle_role{key = RoleKey}, _Args, #battle_state{is_end = false, data = D} = State) ->
    %?PRINT("player_die res = ~p~n", [ok]),
    #battle_state{roles = RoleMap} = State,
    NewState = handle_result(State#battle_state{data = D#{res => 0}}),
    Role = maps:get(RoleKey, RoleMap),
    #battle_role{out_info = #{hp := Hp} = OutInfo} = Role,
    SceneAttr = maps:get(scene_args, OutInfo, []),
    ReviveSceneAttr
        = case lists:keyfind(change_scene_hp, 1, SceneAttr) of
              false ->
                  [{change_scene_hp, Hp} | SceneAttr];
              _ ->
                  SceneAttr
          end,
    {ok, NewState#battle_state{roles = RoleMap#{RoleKey => Role#battle_role{out_info = OutInfo#{scene_args => ReviveSceneAttr}}}}};
player_die(_Role, _Args, _State) ->
    skip.

player_revive(_Role, _Args, _State) ->
    skip.

player_finish_change_scene(Role, _Args, State) ->
    % ?PRINT("player_finish_change_scene res = ~p~n", [ok]),
    #battle_state{roles = RoleMap, self = Self, data = #{node := RoleNode, saint_id := SaintId}, cur_scene = _SceneId, scene_pool_id = _ScenePoolId} = State,
    RoleList = maps:to_list(RoleMap),
    case lists:all(fun
                       ({_key, R}) ->
                           R#battle_role.state =:= ?ROLE_STATE_IN orelse R#battle_role.key =:= Role#battle_role.key
                   end, RoleList) of
        true ->
            erlang:send_after(1000, Self, {apply, ?MODULE, time_check_buff, []}),
            {ok, Bin} = pt_607:write(60704, [SaintId, AttrId = lib_saint:get_turntable_id()]),
            lib_clusters_center:send_to_uid(RoleNode, Role#battle_role.key, Bin),
            put(turn_attr, AttrId);
        _ ->
            skip
    end,
    {ok, Role, State}.

mon_die(_MonKey, _Args, #battle_state{is_end = false, data = D} = State) ->
    %?PRINT("mon die :~p~n", [ok]),
    NewState = handle_result(State#battle_state{data = D#{res => 1}}),
    {ok, NewState};
mon_die(_, _, _) -> skip.

handle_result(#battle_state{roles = RoleMap, self = Self,
    data = #{res := Res, node := Node, saint_id := SaintId, server_id := ServerId,
        saint_role_id := SaintRoleId, saint_role_name := SaintRoleName, saint_server_name := SaintServerName,
        is_reward := IsReward}} = State) ->
    %?PRINT("handle result~n", []),
    [{RoleId, _}] = maps:to_list(RoleMap),
    erlang:send_after(1000, Self, stop),
    % mod_battle_field:stop(Self),
    %pp_saint:send(Node, RoleId, 60710, [Res]),
    mod_saint:apply_cast(mod_saint, calc_result, [Node, RoleId, ServerId, SaintId, SaintRoleId, SaintRoleName, SaintServerName, Res, IsReward]),
    %% 移除buff
    BuffList = [?BUFF_SAINT_TURN, ?BUFF_SAINT_1, ?BUFF_SAINT_2],
    F = fun(BuffType) ->
        mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
            [RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_goods_buff, remove_buff, [BuffType]])
        end,
    lists:map(F, BuffList),
    %% 移除玩家身上的鼓舞次数
    mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
        [RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_saint, remove_inspire_times, []]),
    State#battle_state{is_end = true};
handle_result(_State) ->
    %?PRINT("handle void~n", []),
    _State.

evt_out_of_battle(Player, _Reason) ->
    %?PRINT("evt_out_of_battle res = ~p~n", [ok]),
    #player_status{sid = Sid} = Player,
    %% 通知客户端结束
    lib_server_send:send_to_sid(Sid, pt_607, 60709, [?SUCCESS]),
    Player.

terminate(_Reason, State) ->
    #battle_state{data = _Data, cur_scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId} = State,
    lib_scene:clear_scene_room(SceneId, ScenePoolId, CopyId).

saint_die_handler(#scene_object{id = Id}, _Klist, _Atter, _AtterSign, [BattleFieldPid]) ->
    mod_battle_field:mon_die(BattleFieldPid, Id, []).

want_attr(#battle_state{data = #{node := Node, saint_id := SaintId}, self = Self, roles = RoleMap} = _State, [IsWant, RoleName]) ->
    NowTime = utime:unixtime(),
    case maps:to_list(RoleMap) of
        [{RoleId, _}] ->
            case get(already_turn) of
                undefined ->
                    case get(turn_attr) of
                        undefined ->
                            pp_saint:send_error(Node, RoleId, ?FAIL);
                        AttrId ->
                            case data_saint:get_turntable(AttrId) of
                                #base_saint_turntable{attr = AttrPlus} ->
                                    EffList = [{attr, AttrPlus}],
                                    %%加buff
                                    case IsWant =:= 1 of
                                        true ->
                                            lib_log_api:log_kf_saint_fight(SaintId, RoleId, RoleName, AttrId, 0, 0),
                                            mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
                                                [RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_goods_buff, add_buff,
                                                    [?BUFF_SAINT_TURN, EffList, NowTime + 9999]]),
                                            pp_saint:send(Node, RoleId, 60706, [AttrId, [], NowTime + ?BATTLE_TIME]);
                                        false ->
                                            lib_log_api:log_kf_saint_fight(SaintId, RoleId, RoleName, 0, 0, 0),
                                            pp_saint:send(Node, RoleId, 60706, [0, [], NowTime + ?BATTLE_TIME]),
                                            erase(turn_attr)
                                    end,

                                    pp_saint:send(Node, RoleId, 60705, [IsWant]),
                                    erlang:send_after((?BATTLE_TIME + 1) * 1000, Self, {apply, ?MODULE, battle_time_out, []}),
                                    %% 标识已选择转盘
                                    put(already_turn, 1),
                                    todo;
                                _ ->
                                    ?ERR("saint config err ~n", []),
                                    skip
                            end
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

send_inspire_list(#battle_state{data = #{node := Node} = Data, roles = RoleMap} = State, []) ->
    case maps:to_list(RoleMap) of
        [{RoleId, _}] ->
            case get(inspire_list) of
                undefined -> InspireList = [];
                InspireList -> skip
            end,
            case get(turn_attr) of
                undefined -> TurnAttrId = 0;
                TurnAttrId -> skip
            end,
            case Data of
                #{battle_end_time := EndTime} -> skip;
                _ -> EndTime = 0
            end,
            {ok, BinData} = pt_607:write(60706, [TurnAttrId, InspireList, EndTime]),
            lib_saint:apply_cast(Node, lib_server_send, send_to_uid, [RoleId, BinData]);
        _ ->
            skip
    end,
    {ok, State}.

%% 战斗超时
battle_time_out(#battle_state{is_end = false} = State, []) ->
    #battle_state{cur_scene = SceneId, scene_pool_id = ScenePoolId, roles = RoleMap, self = Self} = State,
    case maps:to_list(RoleMap) of
        [{_, _}] ->
            #battle_state{data = #{saint := #{id := Id}}} = State,
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, ?MODULE, get_scene_obj_hp, [Self, Id]);
        _ ->
            ok
    end;
battle_time_out(_State, _) -> ok.

get_scene_obj_hp(ReqPid, MonObjectId) ->
    case lib_scene_object_agent:get_object(MonObjectId) of
        #scene_object{battle_attr = #battle_attr{hp = Hp}} ->
            case Hp >= 0 of
                true ->
                    Res = 0;
                _ ->
                    Res = 1
            end;
        _ ->
            Res = 1
    end,
    mod_battle_field:apply_cast(ReqPid, ?MODULE, adjudge_battle, Res).

%% 时间结束判断输赢
adjudge_battle(#battle_state{is_end = false} = State, Res) ->
    % ?PRINT("adjudge_battle res = ~p~n", [ok]),
    #battle_state{roles = _RoleMap, data = D} = State,
    %[{RoleId, _} | _] = maps:to_list(RoleMap),
    %?PRINT("~p~n", [Res]),
    handle_result(State#battle_state{data = D#{res => Res}});

adjudge_battle(_, _) ->
    ok.

inspire(#battle_state{is_end = false, data = #{node := Node, saint_id := SaintId}, roles = RoleMap}, [InspireId, InspireNum, RoleName]) ->
    NowTime = utime:unixtime(),
    case maps:to_list(RoleMap) of
        [{RoleId, _}] ->
            case data_saint:get_inspire(InspireId) of
                #base_saint_inspire{effect = CfgEffect} ->
                    case lists:keyfind(time, 1, CfgEffect) of
                        {time, CfgTime} ->
                            case lists:keyfind(attr, 1, CfgEffect) of
                                {attr, EffList} ->
                                    case get(inspire_list) of
                                        undefined ->
                                            NewTime = NowTime + CfgTime,
                                            NewEffNum = 1,
                                            InspireL = [];
                                        InspireL ->
                                            case lists:keyfind(InspireId, 1, InspireL) of
                                                false ->
                                                    NewTime = NowTime + CfgTime,
                                                    NewEffNum = 1;
                                                {_, OldEffNum, OldTime}  ->
                                                    NewTime = OldTime,
                                                    NewEffNum = OldEffNum + 1
                                            end
                                    end,
                                    lib_log_api:log_kf_saint_fight(SaintId, RoleId, RoleName, ?IF(get(turn_attr) =:= undefined, 0, get(turn_attr)), InspireId, InspireNum),
                                    mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
                                        [RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_goods_buff, add_buff,
                                            [?MOD_SAINT * 100 + InspireId, [{attr, [{AttrId, AttrVal * NewEffNum} ||{AttrId, AttrVal}  <- EffList ]}], NewTime]]),
                                    pp_saint:send(Node, RoleId, 60707, [InspireId, NewEffNum, NewTime]),
                                    NewInspireL = lists:keystore(InspireId, 1, InspireL, {InspireId, NewEffNum, NewTime}),
                                    put(inspire_list, NewInspireL);
                                _ ->
                                    skip
                            end;
                        _ ->
                            skip
                    end;
                _ ->
                    skip
            end;
        _ ->
            skip
    end;
inspire(_, _) -> ok.


time_check_buff(#battle_state{is_end = false, data = #{node := Node}, roles = RoleMap, self = Self}, []) ->
    NowTime = utime:unixtime(),
    case maps:to_list(RoleMap) of
        [{RoleId, _}] ->
            case get(inspire_list) of
                undefined ->
                    skip;
                InspireL ->
                    F = fun
                            (Id, _, Time) when NowTime >= Time ->
                                NewInspireL = lists:keydelete(Id, 1, InspireL),
                                put(inspire_list, NewInspireL),
                                mod_clusters_center:apply_cast(Node, lib_player, apply_cast,
                                    [RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_goods_buff, remove_buff, [?MOD_SAINT * 100 + Id]]);
                            (_, _, _) ->
                                skip
                        end,
                    [F(Id, Num, Time) || {Id, Num, Time} <- InspireL]
            end;
        _ -> skip
    end,
    erlang:send_after(1000, Self, {apply, ?MODULE, time_check_buff, []});
time_check_buff(_, _) -> ok.
