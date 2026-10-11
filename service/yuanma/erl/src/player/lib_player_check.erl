%%-----------------------------------------------------------------------------
%% @Module  :       lib_player_check.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-20
%% @Description:    条件检查
%%-----------------------------------------------------------------------------
-module (lib_player_check).
-include ("errcode.hrl").
-include ("scene.hrl").
-include ("server.hrl").
-include ("attr.hrl").
-include ("husong.hrl").

-export ([check_all/1, check_list/2, check/2]).

%% return true | {false, Code}
check_all(Player) ->
    check_list(Player, [alive, safe_scene, action_free, is_transferable]).

%% return true | {false, Code}
check_list(Player, [H|T]) ->
    case check(Player, H) of
        true ->
            check_list(Player, T);
        Error ->
            Error
    end;

check_list(_Player, []) -> true.


check(Player, {'and', List}) ->
    check_list(Player, List);

check(Player, {'or', List}) ->
    case lists:any(fun
        (H) ->
            case check(Player, H) of
                true ->
                    true;
                _ ->
                    false
            end
    end, List) of
        false ->
            check(Player, hd(List));
        true ->
            true
    end;


check(Player, not_on_dungeon) ->
    case lib_dungeon:is_on_dungeon(Player) of
        true ->
            {false, ?ERRCODE(err610_had_on_dungeon)};
        _ ->
            true
    end;

check(Player, safe_scene) ->
    #player_status{scene = SceneId} = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} ->
            if
                Type =:= ?SCENE_TYPE_NORMAL; Type =:= ?SCENE_TYPE_OUTSIDE;
                Type =:= ?SCENE_TYPE_BEINGS_GATE; Type == ?SCENE_TYPE_NIGHT_GHOST ->
                    true;
                true ->
                    {false, ?ERRCODE(cannot_transferable_scene)}
            end;
        _ ->
            true
    end;

check(Player, action_free) ->
    #player_status{action_lock = LockInfo} = Player,
    case LockInfo of
        free ->
            true;
        {Time, Lock} ->
            NowTime = utime:unixtime(),
            if
                NowTime < Time ->
                    {false, Lock};
                true ->
                    true
            end;
        _ ->
            {false, LockInfo}
    end;

check(Player, is_transferable) ->
    case lib_scene:is_transferable(Player) of
        {true, 1} ->
            true;
        {false, Code} ->
            {false, Code};
        _ ->
            {false, ?ERRCODE(err120_cannot_transfer_scene)}
    end;

check(Player, alive) ->
    #player_status{battle_attr = #battle_attr{hp = Hp}} = Player,
    if
        Hp > 0 ->
            true;
        true ->
            {false, ?ERRCODE(player_die)}
    end;

check(Player, in_husong) ->
    #player_status{husong = #husong{start_time = StartTime}} = Player,
    if
        StartTime > 0 ->
            {false, ?ERRCODE(err500_husong_start)};
        true ->
            true
    end;

check(_Player, {is_gm_stop, Mod, SubMod}) ->
    case lib_gm_stop:check_gm_close_act(Mod, SubMod) of
        true -> true;
        _ -> {false, ?ERR_GM_STOP}
    end;

check(_Player, _) -> {false, ?FAIL}.
