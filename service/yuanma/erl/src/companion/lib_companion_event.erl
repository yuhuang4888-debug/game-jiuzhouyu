%% ---------------------------------------------------------------------------
%% @doc lib_companion_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/4
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_companion_event).

-include("up_power_rank.hrl").
-include("server.hrl").
-include("common.hrl").
-include("companion.hrl").
-include("figure.hrl").
-include("skill.hrl").
-include("errcode.hrl").

%% API
-compile([export_all]).

-define(XX, 5).

ac() ->
    T = utime:longunixtime(),
    if
        0 + ?XX*1000 - 500 > T  -> error;
        true -> ok
    end.

combat_change(Ps) ->
    _Combat = lib_companion_util:get_companion_status_power(Ps),
    lib_up_power:refresh_rush_rank_pre(Ps, ?up_power_partner),
    Ps.

stage_upgrade(Ps, CompanionId) ->
    NewPs = lib_push_gift_api:partner_stage_up(Ps, CompanionId),
    NewPs.
    

active_event(Ps, CompanionId) ->
	NewPs = lib_push_gift_api:partner_active(Ps, CompanionId),
    lib_supreme_vip_api:active_companion(Ps#player_status.id),
    {ok, TemplePs} = lib_temple_awaken_api:trigger_active_companion(NewPs, CompanionId),
    TemplePs.

fight_companion(PS, CompanionId, OldStatusCompanion, SceneTrainObj) ->
    #player_status{id = RoleId, status_companion = NewStatusCompanion} = PS,
    %% 广播场景
    FigureId = lib_companion_util:get_figure_id(CompanionId),
    lib_server_send:send_to_uid(RoleId, pt_142, 14203, [?SUCCESS, CompanionId, FigureId]),
    %% 主动14201协议推送
    pp_companion:do_handle(14201, PS, [CompanionId]),
    %% 处理技能CD
    OldSkillId = lib_companion_util:get_active_skill(OldStatusCompanion#status_companion.fight_id),
    NewSkillId = lib_companion_util:get_active_skill(CompanionId),
    F = fun({SkillId, SkillLv}) -> #skill{type = SType} = data_skill:get(SkillId, SkillLv), SType == ?SKILL_TYPE_PASSIVE end,
    DeletePassSkill = lists:filter(F, OldStatusCompanion#status_companion.skill_list),
    ADDPassSkill = lists:filter(F, NewStatusCompanion#status_companion.skill_list),
    SceneUpdArgs = [
        {delete_passive_skill, DeletePassSkill},
        {passive_skill, ADDPassSkill},
        {companion_skill_cd, {OldSkillId, NewSkillId}},
        {battle_attr, PS#player_status.battle_attr},
        {scene_train_object, SceneTrainObj}
    ],
    mod_scene_agent:update(PS, SceneUpdArgs).
