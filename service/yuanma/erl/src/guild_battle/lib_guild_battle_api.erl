%%%--------------------------------------
%%% @Module  : lib_guild_battle
%%% @Author  : liuxl 
%%% @Created : 2018-09-28
%%% @Description:  公会战（大乱斗）
%%%--------------------------------------
-module(lib_guild_battle_api).

-include("server.hrl").
-include("figure.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild_battle.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-compile(export_all).


% check_revive(Status, Type) ->
%     InBattleScene = is_gwar_scene(Status),
%     case Type == ?REVIVE_GUILD_BATTLE of 
%         true -> 
%             case InBattleScene of 
%                 true -> true;
%                 _ -> {false, 5}
%             end;
%         _ -> true
%     end.

handle_event(Player, #event_callback{type_id = ?EVENT_REVIVE, data = Type}) when is_record(Player, player_status) ->
    #player_status{id = _RoleId, guild_battle = GuildBattle} = Player,
    case Type == ?REVIVE_GUILD_BATTLE andalso is_gwar_scene(Player) of 
        true -> 
            ?PRINT("guild battle revive ~n", []),
            NewGuildBattle = GuildBattle#guild_battle_status{revive_state = 1},
            {ok, Player#player_status{guild_battle = NewGuildBattle}};
        _ -> {ok, Player}
    end;
handle_event(Player, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE}) when is_record(Player, player_status) ->
    #player_status{id = _RoleId, guild_battle = GuildBattle} = Player,
    case is_gwar_scene(Player) of 
        true -> 
            case GuildBattle of 
                #guild_battle_status{revive_state = ReviveState} when ReviveState == 1 ->
                    ?PRINT("add buff ~n", []),
                    {_, NewPlayer} = lib_skill_buff:add_buff(Player, 28000001, 1),
                    {ok, NewPlayer#player_status{guild_battle = GuildBattle#guild_battle_status{revive_state = 2}}};
                _ -> {ok, Player}
            end;
        _ -> {ok, Player}
    end;  
    
handle_event(Player, _EventCallback) ->
    {ok, Player}.

handle_af_battle_success(PS) -> PS.
    % case is_gwar_scene(PS) of 
    %     true ->
    %         #player_status{guild_battle = GuildBattle} = PS,
    %         case GuildBattle of 
    %             #guild_battle_status{revive_state = ReviveState} when ReviveState == 2 ->
    %                 {_, NPS} = lib_skill_buff:clean_buff(PS, 28000001),
    %                 ?PRINT("clean buff ~n", []),
    %                 NPS#player_status{guild_battle = GuildBattle#guild_battle_status{revive_state = 0}};
    %             _ -> PS
    %         end;
    %     _ -> PS
    % end.

%% 是否是公会战场景
is_gwar_scene(PS) ->
    #player_status{scene = SceneId,  copy_id = _CopyId} = PS,
    case SceneId == ?GUILD_BATTLE_ID of 
        true -> true;
        false -> false
    end.

%% 更新公会信息
update_guild_info(_GuildId, []) -> ok;
update_guild_info(GuildId, [Item|KeyValues]) ->
	update_guild_info_do(GuildId, Item),
	update_guild_info(GuildId, KeyValues).

% update_guild_info_do(GuildId, {chief_id, [RoleId, RoleName]}) ->
% 	mod_guild_battle:change_chief(GuildId, RoleId, RoleName);
update_guild_info_do(_GuildId, _Item) -> ok.

%% 根据活动是否处于开启状态，判断公会的一些操作
can_guild_operating() ->
	case catch mod_guild_battle:check_open() of
        true -> false;
        false -> true;
        _Err ->
            ?ERR("can_guild_operating err:~p", [_Err]),
            false
    end.

%% 是否是霸主公会
is_dominator_guild(GuildId) ->
	case catch mod_guild_battle:is_dominator_guild(GuildId) of
        true -> true;
        false -> false;
        _Err ->
            ?ERR("is_dominator_guild err:~p", [_Err]),
            true
    end.

%% 击杀怪物
kill_mon(Atter, MonInfo) ->
    #scene_object{scene = SceneId, copy_id=CopyId} = MonInfo,
    #battle_return_atter{id = AtterId} = Atter,
    case SceneId == ?GUILD_BATTLE_ID of
        true ->
            case misc:is_process_alive(CopyId) of
                true -> mod_guild_battle_fight:kill_mon(CopyId, MonInfo, AtterId);
                false -> skip
            end;
        _ ->
            skip
    end.

%% 砍据点
hurt_mon(Minfo, AtterId) ->
    #scene_object{scene = SceneId, copy_id=CopyId,mod_args=Type} = Minfo,
    case SceneId == ?GUILD_BATTLE_ID of
        true->
            case misc:is_process_alive(CopyId) andalso (Type==?OWN_MON_TYPE orelse Type==?KING_MON_TYPE) of
                true->
                    mod_guild_battle_fight:hurt_mon(CopyId, Minfo, AtterId);
                _->
                    skip
            end;
        false ->
                skip
    end.

%%杀死玩家
kill_player(Player, Atter) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId} = Player,
    #battle_return_atter{sign = AtterSign, id = AttId} = Atter,
    case SceneId == ?GUILD_BATTLE_ID andalso AtterSign == ?BATTLE_SIGN_PLAYER of
        true -> 
            case misc:is_process_alive(CopyId) of
                true -> 
                    Ref = util:send_after([], 17000, self(), {'mod', lib_guild_battle, revive_auto, []}),
                    put({guild_battle_revive_ref}, Ref),
                    mod_guild_battle_fight:kill_player(CopyId, AttId, RoleId);
                false -> skip
            end;
        _ -> skip
    end.

%% 通知创建新公会
create_guild(_NewGuild) -> ok.
    % #guild{id=GuildId,name=GuildName,chief_id=ChiefId} = NewGuild,
    % mod_guild_battle:add_new_guild(GuildId,GuildName,ChiefId).


count_guild_battle_attr(Player) ->
    #player_status{guild_battle = GuildBattle} = Player,
    case GuildBattle of 
        #guild_battle_status{buff_id = BuffId} -> 
            Attr = data_guild_battle:get_buff_attr(BuffId),
            Attr;
        _ -> []
    end.
    