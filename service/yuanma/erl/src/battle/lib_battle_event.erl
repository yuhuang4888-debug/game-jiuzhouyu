%% ---------------------------------------------------------------------------
%% @doc lib_battle_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/11 0011
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_battle_event).

%% API 玩家进程
-export([
      handle_af_battle_success/2                %% 玩家进程战斗成功事件
]).

%% API 场景进程
-export([
     handle_af_use_skill_success/4               %% 使用技能成功后的处理
]).

-include("common.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("predefine.hrl").

%% =============================================== In Player Process =================================================
%% 玩家进程战斗成功事件
handle_af_battle_success(Status, SkillId) ->
    StatusAfGuildBattle = lib_territory_war:handle_af_battle_success(Status),
    StatusAfHolyBattleBattle = lib_holy_spirit_battlefield:handle_af_battle_success(StatusAfGuildBattle),
    #skill{career = Career} = data_skill:get(SkillId, 1),
    if
        Career == ?SKILL_CAREER_DEMONS ->
            lib_demons:use_demons_skill_succ(StatusAfHolyBattleBattle, SkillId);
        true ->
            StatusAfHolyBattleBattle
    end.

%% =============================================== In Scene Process =================================================
%% 使用技能成功后的处理
handle_af_use_skill_success(Aer, SkillId, SkillLv, CallBack) ->
    NewAer =
        case data_skill:get(SkillId, SkillLv) of
            #skill{} = SkillR -> handle_af_use_skill_success_help(Aer, SkillR);
            _ -> Aer
        end,
    %% 处理某些特殊技能使用成功后的后续逻辑
    lib_skill:handle_af_use_skill_success(CallBack),
    NewAer.

handle_af_use_skill_success_help(#ets_scene_user{id = RoleId} = Aer, #skill{career = ?SKILL_CAREER_SOUL_DUN, id = SkillId} = _SkillR) ->
    DelEnergy = lib_soul_dungeon:get_need_energy(SkillId),
    lib_skill_api:del_energy(RoleId, DelEnergy),
    #ets_scene_user{battle_attr = BA} = Aer,
    #battle_attr{energy = Energy} = BA,
%%    ?MYLOG("cym",  "Energy:~p DelEnergy:~p ~n", [Energy, DelEnergy]),
    Aer#ets_scene_user{battle_attr = BA#battle_attr{energy = max(Energy - DelEnergy, 0)}};
handle_af_use_skill_success_help(#ets_scene_user{id = RoleId, server_id = ServerId} = Aer, #skill{career = ?SKILL_CAREER_SPIRIT_BATTLE, id = SkillId} = _SkillR) ->
    DelEnergy = lib_holy_spirit_battlefield:get_need_energy(SkillId),
    lib_skill_api:del_energy(RoleId, DelEnergy),
    #ets_scene_user{battle_attr = BA} = Aer,
    #battle_attr{energy = Energy} = BA,
    %% 通知进程使用了技能
    lib_holy_spirit_battlefield:user_anger_skill(ServerId, RoleId),
    Aer#ets_scene_user{battle_attr = BA#battle_attr{energy = max(Energy - DelEnergy, 0)}};
handle_af_use_skill_success_help(Aer, _SkillR) ->
    Aer.

