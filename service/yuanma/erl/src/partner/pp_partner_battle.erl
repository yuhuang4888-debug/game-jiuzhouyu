%% ---------------------------------------------------------------------------
%% @doc pp_partner_battle.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-20
%% @deprecated 伙伴战斗
%% ---------------------------------------------------------------------------
-module(pp_partner_battle).
-export([handle/3]).
-include("server.hrl").

% %% 伙伴出战列表
% handle(20101, Player, []) ->
%     #player_status{id = RoleId, scene = Scene, copy_id = CopyId} = Player,
%     IsDungeonScene = lib_scene:is_dungeon_scene(Scene),
%     IsWarGodScene  = lib_war_god_util:is_in_war_god_scene(Scene),
%     IsAdventureScene = lib_adventure_tour_util:is_in_adventure_scene(Scene),
%     IsHeroWarScene = lib_hero_war_api:in_hero_war_scene(Scene),
%     if
%         IsDungeonScene ->
%             case lib_dungeon:is_on_dungeon(Player) of
%                 true -> mod_dungeon:send_partner_list(CopyId, RoleId);
%                 false -> skip
%             end;
%         IsWarGodScene -> mod_war_god:send_partner_list(RoleId);
%         IsAdventureScene ->
%             mod_adventure_pk:send_partner_list(RoleId);
%         IsHeroWarScene ->
%             mod_hero_war:send_partner_list(RoleId);
%         true -> skip
%     end;

% %% 伙伴组切换
% handle(20102, Player, [PartnerGroup]) ->
%     #player_status{id = RoleId, scene = Scene, copy_id = CopyId, x = X, y = Y} = Player,
%     IsDungeonScene = lib_scene:is_dungeon_scene(Scene),
%     if
%         IsDungeonScene ->
%             case lib_dungeon:is_on_dungeon(Player) of
%                 true -> mod_dungeon:choose_partner_group(CopyId, RoleId, PartnerGroup, X, Y);
%                 false -> skip
%             end;
%         true -> skip
%     end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
