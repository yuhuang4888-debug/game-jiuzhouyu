%% ---------------------------------------------------------------------------
%% @doc lib_nine.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿
%% ---------------------------------------------------------------------------
-module(lib_nine).
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("role_nine.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("attr.hrl").

make_record(nine_rank, Player) ->
    #player_status{
        id = RoleId, figure = #figure{name = Name, career = Career}, server_id = ServerId,
        server_name = ServerName, server_num = ServerNum, combat_power = CombatPower
        } = Player,
    #nine_rank{
        role_id = RoleId,
        name = Name,
        career = Career, 
        server_id = ServerId,
        server_name = ServerName,
        server_num = ServerNum,
        combat_power = CombatPower,
        world_lv = util:get_world_lv()
        }.

%% 参战
apply_war(Player) ->
    apply_war(Player, 1).  %% 进入的时候 取之前进入层数，这里的1 会被覆盖

apply_war(Player, LayerId) -> 
    #player_status{figure = #figure{lv = Lv}} = Player,
    NeedLv = ?NINE_KV_NEED_LV,
    if
        Lv < NeedLv -> {false, ?ERRCODE(err402_no_enough_lv_join)}; 
        true ->
            case lib_player_check:check_list(Player, [action_free, is_transferable]) of
                {false, ErrCode} -> {false, ErrCode};
                true -> 
                    NineRank = make_record(nine_rank, Player),
                    mod_nine_local:apply_war(NineRank, LayerId, enter),
                    {ok, Player}
            end
    end.

%% 离开
quit(Player) ->
    #player_status{id = RoleId, server_id = ServerId, scene = SceneId} = Player,
    IsNineScene = lib_nine_api:is_nine_scene(SceneId),
    if
        IsNineScene == false -> NewPlayer = Player;
        true ->
            mod_nine_local:quit(RoleId, ServerId, SceneId),
            mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId, SceneId]}]),
            NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{change_scene_hp_lim,1}, {action_free, ?ERRCODE(err135_can_not_change_scene_in_nine)}])
    end,
    {ok, BinData} = pt_135:write(13505, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPlayer}.

%% 延迟登出
delay_stop(Player) ->
    #player_status{id = RoleId, server_id = ServerId, scene = SceneId} = Player,
    IsNineScene = lib_nine_api:is_nine_scene(SceneId),
    if
        IsNineScene == false -> NewPlayer = Player;
        true ->
            mod_nine_local:quit(RoleId, ServerId, SceneId),
            mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId, SceneId]}]),
            NewPlayer = lib_scene:change_scene(Player, 0, 0, 0, 0, 0, true, [{load_scene_auto, 0}, {change_scene_hp_lim,1}, {action_free, ?ERRCODE(err135_can_not_change_scene_in_nine)}])
    end,
    NewPlayer.

%% 登出
logout(Player) ->
    #player_status{id = RoleId, server_id = ServerId, scene = SceneId} = Player,
    mod_nine_local:quit(RoleId, ServerId, SceneId),
    mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId, SceneId]}]).

%%    IsNineScene = lib_nine_api:is_nine_scene(SceneId),
%%    if
%%        IsNineScene == false -> skip;
%%        true ->
%%            case lib_nine_api:is_nine_bf_scene(SceneId) of
%%                true -> mod_nine_local:quit(RoleId, ServerId, SceneId);
%%                false -> mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId, SceneId]}])
%%            end
%%    end.

%% 重连
% re_login(Player, ?RE_LOGIN) ->
%     #player_status{id = RoleId, server_id = ServerId, scene = SceneId} = Player,
%     IsNineScene = lib_nine_api:is_nine_scene(SceneId),
%     if
%         IsNineScene == false -> {next, Player};
%         true ->
%             case lib_nine_api:is_nine_bf_scene(SceneId) of
%                 true -> mod_nine_local:quit(RoleId, ServerId);
%                 false -> mod_nine_center:cast_center([{apply, quit, [RoleId, ServerId]}])
%             end,
%             {ok, Player}
%     end;
re_login(Player, _) ->
    {next, Player}.

%% 检查复活
check_revive(Player, Type) ->
    #player_status{scene = SceneId} = Player,
    IsOnNineScene = lib_nine_api:is_nine_scene(SceneId),
    case IsOnNineScene of
        true -> 
            TypeList = [?REVIVE_NINE_GOLD, ?REVIVE_NINE],
            case lists:member(Type, TypeList) of
                true -> true;
                false -> {false, 10}
            end;
        false ->
            true
    end.


get_revive_kv(Status) ->
    #player_status{nine_battle = NineBattle, battle_attr = BA} = Status,
    #battle_attr{hp_lim=HpLim} = BA,
	case NineBattle of
		#nine_battle{mod = Mod, layer_id = LayerId} ->
			ok;
		_ ->
			Mod = 1,
			LayerId = 1
	end,
    #base_nine{is_drop = IsDrop, drop_rate = DropRate} = data_nine:get_nine(Mod, LayerId),
    case IsDrop == 1 of
        true -> NewDropRate = DropRate;
        false -> NewDropRate = 0
    end,
    case  urand:rand(1, ?RATIO_COEFFICIENT) =< NewDropRate of
        true ->
	        {false, max(LayerId - 1, 1)};
        false ->
            #base_nine{born_pos = BornPosL} = data_nine:get_nine(Mod, LayerId),
            % 切场景
            {X, Y} = urand:list_rand(BornPosL),
            KeyValueList = [
                {group, 0}
                ,{hp, HpLim}
                ,{x,X}, {y,Y}
            ],
            {true, KeyValueList}
    end.
    