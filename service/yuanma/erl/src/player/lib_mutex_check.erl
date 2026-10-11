%% ---------------------------------------------------------------------------
%% @doc lib_mutex_check.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-06-12
%% @deprecated 功能互斥禁止进入。
%% ---------------------------------------------------------------------------
-module(lib_mutex_check).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("errcode.hrl").
-include("guild.hrl").

%% 是否能被踢出公会
check_kick_out_guild(Player, _LevelId) ->
    PlayerId = Player#player_status.id,
    GuildId = Player#player_status.guild#status_guild.id,
    List = [
        {fun() -> mod_guild_feast_mgr:is_act_open() == false end, ?ERRCODE(err402_cant_quit_guild_when_act_open)},  %%公会晚宴
        %{fun() -> lib_guild_battle_api:can_guild_operating() == true end, ?ERRCODE(err402_cant_quit_guild_when_gwar_open)},
        {fun() -> lib_territory_war:can_guild_operating(GuildId) == true end, ?ERRCODE(err402_cant_quit_guild_when_gwar_open)},
        % {fun() -> mod_escort_local:judge_is_in_act_time() == false end, ?ERRCODE(err185_cant_quit_guild_when_act_open)},
        % {fun() -> mod_seacraft_local:judge_is_in_act_time() =/= true end, ?ERRCODE(err186_cant_quit_guild_when_act_open)},
        {fun() -> lib_guild_dun:can_guild_operating(PlayerId) == true end, ?ERRCODE(err400_cant_quit_guild_when_in_guild_dun)}
    ],
    util:check_list(List).

%% 是否主动退出公会
check_quit_guild(Player) ->
    PlayerId = Player#player_status.id,
    GuildId = Player#player_status.guild#status_guild.id,
    List = [
        {fun() -> mod_guild_feast_mgr:is_act_open() == false end, ?ERRCODE(err402_cant_quit_guild_when_act_open)},  %%公会晚宴
        %{fun() -> lib_guild_battle_api:can_guild_operating() == true end, ?ERRCODE(err402_cant_quit_guild_when_gwar_open)},
        {fun() -> lib_territory_war:can_guild_operating(GuildId) == true end, ?ERRCODE(err402_cant_quit_guild_when_gwar_open)},
        {fun() -> lib_guild_dun:can_guild_operating(PlayerId) == true end, ?ERRCODE(err400_cant_quit_guild_when_in_guild_dun)},
        % {fun() -> mod_escort_local:judge_is_in_act_time() == false end, ?ERRCODE(err185_cant_quit_guild_when_act_open)},
        % {fun() -> mod_seacraft_local:judge_is_in_act_time() =/= true end, ?ERRCODE(err186_cant_quit_guild_when_act_open)},
        {fun() -> lib_sanctuary:is_sanctuary_scene(Player#player_status.scene) == false end, ?ERRCODE(err400_cant_quit_guild_when_in_sanctuary)},
        {fun() -> lib_guild_assist:is_in_assist(Player) == false end, ?ERRCODE(err404_cant_quit_guild_when_in_assist)},
        {fun() -> lib_seacraft_daily:is_scene(Player#player_status.scene) == false end, ?ERRCODE(err187_cant_quit_guild_when_in_sea_daily)}
    ],
    util:check_list(List).

%% 是否转让会长
check_appoint_position(GuildId, ?POS_CHIEF)  ->
    List = [
        {fun() -> mod_guild_feast_mgr:is_act_open() == false end, ?ERRCODE(err402_cant_appoint_chief_when_act_open)},  %%公会晚宴
        %{fun() -> lib_guild_battle_api:can_guild_operating() == true end, ?ERRCODE(err402_cant_appoint_chief_when_gwar_open)}
        {fun() -> lib_territory_war:can_guild_operating(GuildId) == true end, ?ERRCODE(err402_cant_appoint_chief_when_gwar_open)}
        % {fun() -> mod_seacraft_local:judge_is_in_act_time() =/= true end, ?ERRCODE(err186_cant_appoint_chief_when_act_open)}
        % {
        %     fun() ->
        %         case catch mod_kf_guild_war_local:get_act_status() of
        %             0 -> true;
        %             _ -> false
        %         end
        %     end, ?ERRCODE(err437_cant_appoint_chief_when_kfwar_open)
        % }
    ],
    util:check_list(List);
check_appoint_position(_, _)  -> true.

%% 是否能主动解散公会
check_disband_guild(GuildId)  ->
    List = [
        % {
        %     fun() ->
        %         case catch mod_guild_boss:get_gboss_status(GuildId) of
        %             {false, _GBossR} -> true;
        %             _ -> false
        %         end
        %     end, ?ERRCODE(err402_cant_disband_when_gboss_open)
        % },
        % {
        %     fun() ->
        %         case catch mod_kf_guild_war_local:get_act_status() of
        %             0 -> true;
        %             _ -> false
        %         end
        %     end, ?ERRCODE(err437_cant_disband_when_kfgwar_open)
        % },
        {fun() -> mod_guild_feast_mgr:is_act_open() == false end, ?ERRCODE(err402_cant_disband_when_act_open)},  %%公会晚宴
        %{fun() -> lib_guild_battle_api:can_guild_operating() == true end, ?ERRCODE(err402_cant_disband_when_gwar_open)},  %%公会争霸开启期间
        {fun() -> lib_territory_war:can_guild_operating(GuildId) == true end, ?ERRCODE(err402_cant_disband_when_gwar_open)},
        % {fun() -> mod_escort_local:judge_is_in_act_time() == false end, ?ERRCODE(err185_disband_when_act_open)},
        % {fun() -> mod_seacraft_local:judge_can_disband(GuildId) =/= true end, ?ERRCODE(err186_cant_disband_when_act_open)},
        {fun() -> lib_territory_war:is_dominator_guild(GuildId) == false end, ?ERRCODE(err400_dominator_guild_can_not_disband)} %% 主宰公会不能解散，没有处理主宰公会解散的相关逻辑
        %{fun() -> lib_guild_battle_api:is_dominator_guild(GuildId) == false end, ?ERRCODE(err400_dominator_guild_can_not_disband)} %% 主宰公会不能解散，没有处理主宰公会解散的相关逻辑
    ],
    util:check_list(List).

