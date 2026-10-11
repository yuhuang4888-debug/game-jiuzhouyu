%% ---------------------------------------------------------------------------
%% @doc lib_nine_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-30
%% @deprecated 九魂圣殿接口
%% ---------------------------------------------------------------------------
-module(lib_nine_api).
-compile(export_all).

-include("scene.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("role_nine.hrl").


%% 假人死亡处理
object_die_handler(Object, _Klist, Atter, ?BATTLE_SIGN_PLAYER, _Args) ->
    #scene_object{scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId} = Object,
%%    IsBfScene = is_nine_bf_scene(SceneId),
%%    IsClsScene = is_nine_cls_scene(SceneId),
    #battle_return_atter{real_id = RealId, server_id = ServerId} = Atter,
    mod_nine_local:object_die(SceneId, RealId, ServerId, PoolId, CopyId),
    mod_nine_center:cast_mod({apply, object_die, [SceneId, RealId, ServerId, PoolId, CopyId]}),
%%    if
%%        IsBfScene -> mod_nine_local:object_die(SceneId, RealId, ServerId, PoolId, CopyId);
%%        IsClsScene -> mod_nine_center:cast_mod({apply, object_die, [SceneId, RealId, ServerId, PoolId, CopyId]});
%%        true -> skip
%%    end,
    ok;
object_die_handler(_Object, _, _Atter, _AttSign, _Args) ->
    ok.

% %% 假人死亡处理
% dummy_die_handler(Object, _Klist, Atter, ?BATTLE_SIGN_PLAYER, _Args) -> 
%     #scene_object{scene = SceneId} = Object,
%     IsBfScene = is_nine_bf_scene(SceneId),
%     IsClsScene = is_nine_cls_scene(SceneId),
%     #battle_return_atter{real_id = RealId, server_id = ServerId} = Atter,
%     if
%         IsBfScene -> mod_nine_local:dummy_die(SceneId, RealId, ServerId);
%         IsClsScene -> mod_nine_center:cast_mod({apply, dummy_die, [SceneId, RealId, ServerId]});
%         true -> skip
%     end,
%     ok;
% dummy_die_handler(_Object, _, _Atter, _AttSign, _Args) ->
%     ok.

% dummy_born_handler(revive, Object, [LayerId]) ->
%     #base_nine{mon_pos = MonPosL} = data_nine:get_nine(LayerId),
%     {X, Y} = urand:list_rand(MonPosL),
%     Object#scene_object{x = X, y = Y};
% dummy_born_handler(_, Object, _) ->
%     Object.

%% 采集秘宝
collect_flag(CollectorId, Minfo) ->
    #scene_object{scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId} = Minfo,
%%    IsBfScene = is_nine_bf_scene(SceneId),
%%    IsClsScene = is_nine_cls_scene(SceneId),
%%    if
%%        IsBfScene -> mod_nine_local:collect_flag(CollectorId, PoolId, CopyId);
%%        IsClsScene -> mod_nine_center:cast_mod({apply, collect_flag, [CollectorId, PoolId, CopyId]});
%%        true -> skip
%%    end,
    mod_nine_local:collect_flag(CollectorId,SceneId, PoolId, CopyId),
    mod_nine_center:cast_mod({apply, collect_flag, [CollectorId,SceneId, PoolId, CopyId]}),
    ok.

%% 玩家死亡
%% 死亡事件
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = DieId, scene = SceneId, figure = #figure{name = DName}, server_id = DServerId, copy_id = CopyId, scene_pool_id = PoolId}=Player,
    #{attersign := AtterSign, atter := Atter, hit := _HitList} = Data,
    #battle_return_atter{real_id = AtterId, real_name = Name, server_num = ServerNum} = Atter,
    % 被玩家打死有效
    case is_nine_scene(SceneId) of
        true ->
            case AtterSign == ?BATTLE_SIGN_PLAYER of
                true ->
                    mod_nine_local:kill_player(SceneId, ServerNum, AtterId, Name, DieId, DName, DServerId, PoolId, CopyId),
                    mod_nine_center:cast_center([{apply, kill_player, [SceneId, ServerNum, AtterId, Name, DieId, DName, DServerId, PoolId, CopyId]}]);
                false ->
                    skip
            end,
            {ok, Player};
        false ->
            {ok, Player}
    end;
handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = Type}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, scene = SceneId, server_id = ServerId, copy_id = CopyId}=Player,
    case is_nine_scene(SceneId) of
        true ->
            mod_nine_local:revive(RoleId, ServerId, Type, SceneId, CopyId),
            mod_nine_center:cast_center([{apply, revive, [RoleId, ServerId, Type, SceneId, CopyId]}]);
        false ->
            skip
    end,
    {ok, Player};
handle_event(Player, _EventCallback) ->
    {ok, Player}.

%%%% 是否九魂圣殿场景
is_nine_scene(SceneId) ->
    #ets_scene{type = Type} = data_scene:get(SceneId),
    Type == ?SCENE_TYPE_NINE.
%%
%%%% 九魂圣殿本服场景
%%is_nine_bf_scene(SceneId) ->
%%%%    SceneIdList = data_nine:get_nine_scene_list(),
%%%%    lists:member(SceneId, SceneIdList).
%%    false.
%%
%%%% 九魂圣殿跨服场景
%%is_nine_cls_scene(SceneId) ->
%%%%    SceneIdList = data_nine:get_nine_cls_scene_list(),
%%%%    lists:member(SceneId, SceneIdList).
%%    false.

gm_fake_join_nine(JoinNum) -> gm_fake_join_nine(JoinNum, 135, 0).
gm_fake_join_nine(JoinNum, Module, SubModule) ->
    NeedLv = ?NINE_KV_NEED_LV,
    Sql_player = io_lib:format("select w.id, n.accname from player_login as n left join player_low as w on w.id = n.id where w.lv > ~p", [NeedLv]),
    case db:get_all(Sql_player) of
        [] -> ok;
        Players ->
            F_clc = fun([Id, AccName], AccList) -> lists:keystore(AccName, 1, AccList, {AccName, Id}) end,
            JoinInfos = lists:sublist(lists:foldl(F_clc, [], Players), JoinNum),
            Now = utime:unixtime(),
            OnHookParams = [[RoleId, Module, SubModule, Now]||{_, RoleId} <-JoinInfos],
            Sql_onHook = usql:replace(role_activity_onhook_modules, [role_id, module_id,sub_module, select_time], OnHookParams),
            CoinParams = [[RoleId, 100, 0, Now]||{_, RoleId} <-JoinInfos],
            Sql_coin = usql:replace(role_activity_onhook_coin, [role_id, onhook_coin, exchange_left, coin_utime], CoinParams),
            Sql_onHook =/= [] andalso Sql_coin =/= [] andalso begin db:execute(Sql_onHook), db:execute(Sql_coin) end,
            lib_php_api:restart_process("{mod_activity_onhook, start_link, []}")
    end.
