%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_war_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-08
%% @Description:    公会争霸api
%%-----------------------------------------------------------------------------
-module(lib_guild_war_api).

-include("guild_war.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("battle.hrl").

-export([
    login/2
    , is_gwar_scene/1
    , is_act_open/0
    , get_all_guild_ids/0
    , is_dominator_guild/1
    , is_dominator/1
    , can_guild_operating/0
    , attack_mon/1
    , kill_mon/2
    , kill_player/5
    , update_guild_info/2
    , disband_guild/1
    , clear_gwar_confirm_info/0
    ]).

%% 玩家登陆
%% 如果玩家是主宰公会会长要加上buff
login(GuildId, RoleId) ->
    mod_guild_war:role_login(GuildId, RoleId).

is_gwar_scene(SceneId) ->
    ActScene = data_guild_war:get_cfg(scene_id),
    SceneId == ActScene.

is_act_open() ->
    case catch mod_guild_war:get_act_status() of
        ActStatus when is_integer(ActStatus) ->
            ActStatus == ?ACT_STATUS_BATTLE orelse ActStatus == ?ACT_STATUS_REST;
        _Err ->
            ?ERR("get_act_status err:~p", [_Err]),
            false
    end.

get_all_guild_ids() ->
    case catch mod_guild_war:get_all_guild_ids() of
        GuildIds when is_list(GuildIds) ->
            GuildIds;
        _Err ->
            ?ERR("get_all_guild_ids err:~p", [_Err]),
            []
    end.

is_dominator_guild(GuildId) ->
    case catch mod_guild_war:is_dominator_guild(GuildId) of
        Res when is_boolean(Res) -> Res;
        _Err ->
            ?ERR("is_dominator_guild err:~p", [_Err]),
            error
    end.

is_dominator(RoleId) ->
    case catch mod_guild_war:get_dominator_info() of
        {_GuildId, _GuildName, ChiefId} -> ChiefId == RoleId;
        _Err ->
            ?ERR("is_dominator err:~p", [_Err]),
            error
    end.

can_guild_operating() ->
    case catch mod_guild_war:get_act_status() of
        ActStatus when is_integer(ActStatus) ->
            ActStatus == ?ACT_STATUS_CLOSE;
        _Err ->
            ?ERR("can_guild_operating err:~p", [_Err]),
            false
    end.

update_guild_info(GuildId, KeyValList) ->
    mod_guild_war:update_guild_info(GuildId, KeyValList).

disband_guild(GuildId) ->
    mod_guild_war:disband_guild(GuildId).

%% 这里传进来的是受击前的状态
attack_mon(Object) ->
    #scene_object{sign = Sign, scene = SceneId, copy_id = CopyId, mon = MonInfo} = Object,
    Alive = misc:is_process_alive(CopyId),
    IsGWarScene = is_gwar_scene(SceneId),
    case Sign == ?BATTLE_SIGN_MON andalso IsGWarScene andalso Alive of
        true ->
            #scene_mon{create_key = CreateKey} = MonInfo,
            case CreateKey of
                {guild_war, _CreateKeyId} ->
                    mod_guild_war_battle:attack_mon(CopyId, {'attack_mon', Object});
                _ -> skip
            end;
        false -> skip
    end.

kill_mon(Attacker, Object) ->
    #scene_object{sign = Sign, scene = SceneId, copy_id = CopyId, mon = MonInfo} = Object,
    Alive = misc:is_process_alive(CopyId),
    IsGWarScene = is_gwar_scene(SceneId),
    case Sign == ?BATTLE_SIGN_MON andalso IsGWarScene andalso Alive of
        true ->
            #scene_mon{create_key = CreateKey} = MonInfo,
            case CreateKey of
                {guild_war, _CreateKeyId} ->
                    mod_guild_war_battle:kill_mon(CopyId, {'kill_mon', Attacker, Object});
                _ -> skip
            end;
        false -> skip
    end.

kill_player(SceneId, CopyId, GuildId, RoleId, Attacker) ->
    #battle_return_atter{sign = AttackerSign, guild_id = AttackerGuildId, id = AttackerId, real_name = AttackerName} = Attacker,
    Alive = misc:is_process_alive(CopyId),
    IsGWarScene = is_gwar_scene(SceneId),
    case AttackerSign == ?BATTLE_SIGN_PLAYER andalso IsGWarScene andalso Alive of
        true ->
            mod_guild_war_battle:kill_player(CopyId, {'kill_player', GuildId, RoleId, AttackerGuildId, AttackerId, AttackerName});
        false -> skip
    end.

%% ------------------------------ 秘籍 -------------------------------------
clear_gwar_confirm_info() ->
    case catch mod_guild_war:get_act_status() of
        ActStatus when ActStatus == ?ACT_STATUS_CLOSE ->
            mod_guild_war:clear_gwar_confirm_info();
        _ ->
            false
    end.

