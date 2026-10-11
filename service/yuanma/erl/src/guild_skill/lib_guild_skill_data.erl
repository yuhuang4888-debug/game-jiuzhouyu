%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_skill_data
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-26
%% @Description:
%%-----------------------------------------------------------------------------
-module(lib_guild_skill_data).

-include("guild.hrl").
-include("sql_guild.hrl").

-export([
    get_skill_map/0
    , save_skill_map/1
    , get_guild_skill_list/1
    , upgrade_skill_lv/2
    ]).

get_skill_map() ->
    case get(?P_GUILD_SKILL) of
        undefined ->
            lib_guild_skill:init([]),
            get(?P_GUILD_SKILL);
        Val -> Val
    end.

save_skill_map(SkillMap) ->
    put(?P_GUILD_SKILL, SkillMap).

get_guild_skill_list(GuildId) ->
    GuildSkillMap = get_skill_map(),
    maps:get(GuildId, GuildSkillMap, []).

%% 提升公会技能等级
upgrade_skill_lv(GuildId, SkillId) ->
    GuildSkillMap = get_skill_map(),
    SkillList = maps:get(GuildId, GuildSkillMap, []),
    NewSkill = case lists:keyfind(SkillId, #guild_skill.skill_id, SkillList) of
        #guild_skill{
            research_lv = ResearchLv
        } = Skill ->
            NewResearchLv = ResearchLv + 1,
            db:execute(io_lib:format(?sql_update_guild_skill_lv, [NewResearchLv, GuildId, SkillId])),
            Skill#guild_skill{research_lv = NewResearchLv};
        _ ->
            ResearchLv = ?DEFAULT_GSKILL_RESEARCH_LV,
            NewResearchLv = ?DEFAULT_GSKILL_RESEARCH_LV + 1,
            db:execute(io_lib:format(?sql_guild_skill_insert, [GuildId, SkillId, NewResearchLv])),
            #guild_skill{guild_id = GuildId, skill_id = SkillId, research_lv = NewResearchLv}
    end,
    NewSkillList = lists:keystore(SkillId, #guild_skill.skill_id, SkillList, NewSkill),
    NewGuildSkillMap = maps:put(GuildId, NewSkillList, GuildSkillMap),
    save_skill_map(NewGuildSkillMap),
    {ok, ResearchLv, NewResearchLv}.


