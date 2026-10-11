%% ---------------------------------------------------------------------------
%% @doc lib_decoration_boss_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-14
%% @deprecated 幻饰boss的接口
%% ---------------------------------------------------------------------------
-module(lib_decoration_boss_api).
-compile(export_all).

-include("scene.hrl").
-include("decoration_boss.hrl").
-include("battle.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("drop.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("predefine.hrl").

%% 是否在幻饰boss场景
is_decoration_boss_scene(#player_status{scene = SceneId}) ->
    is_decoration_boss_scene(SceneId);
is_decoration_boss_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_DECORATION_BOSS} -> true;
        _ -> false
    end.

%% 是否普通boss场景
is_normal_boss_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_DECORATION_BOSS} -> 
            case is_sboss_scene(SceneId) of
                true -> false;
                false -> true
            end;
        _ -> 
            false
    end.

%% 击杀boss
kill_mon(Minfo, _Klist, Atter, _AtterSign, FirstAtter, _BLWhos, MonArgs) ->
    #scene_object{mon = Mon, scene = SceneId, scene_pool_id = ScenePoolId} = Minfo,
    #scene_mon{mid = MonId} = Mon,
    #battle_return_atter{server_id = ServerId} = Atter,
    % case FirstAttr of
    %     #mon_atter{id = FirstId} -> ok;
    %     _ -> FirstId = 0
    % end,
    case is_decoration_boss_scene(SceneId) of
        true ->
            case lib_scene:is_clusters_scene(SceneId) of
                true -> mod_decoration_boss_center:cast_mod({'kill_mon', ScenePoolId, MonArgs, FirstAtter});
                false -> 
                    mod_decoration_boss_local:kill_mon(MonArgs, FirstAtter),
                    mod_decoration_boss_center:cast_center([{'local_kill_mon', ServerId, MonId}])
            end;
        false ->
            skip
    end.

%% 伤害怪物
hurt_mon(Minfo, Atter, Hurt) ->
    #scene_object{mon = Mon, scene = SceneId, scene_pool_id = ScenePoolId} = Minfo,
    #scene_mon{mid = MonId} = Mon,
    #battle_return_atter{sign = Sign, id = RoleId, server_id = ServerId, server_num = ServerNum, server_name = ServerName, real_name = Name, mask_id = MaskId} = Atter,
    case is_decoration_boss_scene(SceneId) andalso Sign == ?BATTLE_SIGN_PLAYER of
        true ->
            WrapRoleName = lib_player:get_wrap_role_name(Name, [MaskId]),
            BossHurt = #decoration_boss_hurt{
                role_id = RoleId, name = WrapRoleName, server_id = ServerId, server_num = ServerNum, server_name = ServerName,
                hurt = Hurt, time = utime:unixtime()
                },
            case lib_scene:is_clusters_scene(SceneId) of
                true -> 
                    mod_decoration_boss_center:cast_mod({'hurt_mon', ScenePoolId, MonId, BossHurt});
                false -> 
                    mod_decoration_boss_local:hurt_mon(MonId, BossHurt)
            end;
        false ->
            skip
    end.

%% 玩家死亡
handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = #{atter := Killer}}) when is_record(Player, player_status) ->
    case is_decoration_boss_scene(Player) of
        true ->
            #player_status{id = RoleId, server_id = ServerId} = Player,
            mod_decoration_boss_local:player_die(RoleId, ServerId),
            lib_guild_assist:player_be_kill(Killer, Player),
            {ok, Player};
        false ->             
            {ok, Player}
    end;

%% 玩家复活
handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE}) when is_record(Player, player_status) ->
     case is_decoration_boss_scene(Player) of
        true -> 
            #player_status{id = RoleId, server_id = ServerId} = Player,
            mod_decoration_boss_local:revive(RoleId, ServerId),
            {ok, Player};
        false ->             
            {ok, Player}
    end;

% %% 掉落
% handle_event(#player_status{id = RoleId} = Player, #event_callback{type_id = ?EVENT_GOODS_DROP, data = Data}) ->
%     #callback_goods_drop{mon_args = MonArgs, goods_list = GoodsList, up_goods_list = UpGoodsL} = Data,
%     #mon_args{mid = BossId, scene = ObjectScene} = MonArgs,
%     case is_normal_boss_scene(ObjectScene) of
%         true ->
%             IsBelong = 1,
%             SeeRewardL = lib_goods_api:make_see_reward_list(GoodsList, UpGoodsL),
%             {ok, BinData} = pt_471:write(47113, [IsBelong, [{?REWARD_SOURCE_DROP, SeeRewardL}]]),
%             lib_server_send:send_to_sid(Player#player_status.sid, BinData),
%             add_drop_log(Player, MonArgs, SeeRewardL, UpGoodsL),
%             lib_log_api:log_decoration_boss_reward(RoleId, ?DECORATION_BOSS_ENTER_TYPE_NORMAL, BossId, IsBelong, GoodsList);
%         false ->
%             skip
%     end,
%     {ok, Player};

handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 是否特殊boss
is_sboss_id(SBossId) ->
    SBossId == ?DECORATION_BOSS_KV_SBOSS_ID.

%% 是否掠夺BOss
is_plunder_boss(BossId) ->
    case data_decoration_boss:get_boss(BossId) of
        #base_decoration_boss{boss_type = ?BOSS_TYPE_PLUNDER} -> true;
        _ -> false
    end.

%% 是否共享BOss
is_share_boss(BossId) ->
    case data_decoration_boss:get_boss(BossId) of
        #base_decoration_boss{boss_type = ?BOSS_TYPE_SHARE} -> true;
        _ -> false
    end.

%% 是否特殊boss场景
is_sboss_scene(SceneId) ->
    SceneId == ?DECORATION_BOSS_KV_SBOSS_SCENE.

%% 是否禁止掉落
is_stop_drop(SceneId) ->
    % is_sboss_scene(SceneId).
    is_decoration_boss_scene(SceneId).

%% 掉落日志
add_drop_log(Player, MonArgs, SeeRewardL, UpGoodsL) ->
    #player_status{id = RoleId, server_id = ServerId, server_num = ServerNum} = Player,
    #mon_args{mid = BossId} = MonArgs,
    F = fun({_Type, GoodsTypeId, Num, Id}, L) -> 
        case lists:keyfind(Id, #goods.id, UpGoodsL) of
            #goods{other = #goods_other{rating = Rating, extra_attr = OExtraAttr}} ->
                ExtraAttr = data_attr:unified_format_extra_attr(OExtraAttr, []);
            _ -> 
                Rating = 0, ExtraAttr = []
        end,
        case lists:member(GoodsTypeId, ?DECORATION_BOSS_KV_DROP_LOG_LIST) of % orelse GoodsTypeId > 0 of 
            true -> [{GoodsTypeId, Num, Rating, ExtraAttr}|L];
            false -> L
        end
    end,
    GoodsInfoL = lists:reverse(lists:foldl(F, [], SeeRewardL)),
    WrapperName = lib_player:get_wrap_role_name(Player),
    case GoodsInfoL of
        [] -> skip;
        _ -> mod_decoration_boss_center:cast_center([{'add_drop_log', RoleId, ServerId, ServerNum, WrapperName, BossId, GoodsInfoL}])
    end,
    ok.

can_enter_decoration_boss(PS, BossId, EnterType, EnterSubType) ->
    lib_decoration_boss:check_enter_boss(PS, BossId, EnterType, EnterSubType).

cancel_boss_assist(RoleId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, cancel_boss_assist, []);
cancel_boss_assist(PS) ->
    case is_decoration_boss_scene(PS) of
        false -> PS;
        true ->
            pp_decoration_boss:handle(47103, PS, [])
    end.
