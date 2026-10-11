%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_skill
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-25
%% @Description:    公会技能
%%-----------------------------------------------------------------------------
-module(lib_guild_skill).

-include("guild.hrl").
-include("sql_guild.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("figure.hrl").

-export([
    init/1
    , login/1
    , check_research_skill/2
    , check_learn_skill/3
    , research_cost/3
    , learn_cost/2
    , pack_guild_skill_list/5
    , check_research_condition/3
    , learn_skill/4
    , delete_skill_by_guild_id/1
    ]).

make_record(guild_skill, [GuildId, SkillId, ResearchLv]) ->
    #guild_skill{
        guild_id = GuildId, skill_id = SkillId, research_lv = ResearchLv
    }.

login(RoleId) ->
    case db:get_all(io_lib:format(?sql_player_guild_skill_select, [RoleId])) of
        [] -> #status_guild_skill{};
        List ->
            GSkillMap = lists:foldl(fun([SkillId, SkillLv], TmpMap) ->
                maps:put(SkillId, SkillLv, TmpMap)
            end, #{}, List),
            AttrList = count_skill_attr(GSkillMap),
            #status_guild_skill{attr = AttrList, gskill_map = GSkillMap}
    end.

init(GuildIds) ->
    Sql = io_lib:format(?sql_guild_skill_select, []),
    List = db:get_all(Sql),
    GuildSkillMap = make_guild_skill_map(List, GuildIds, #{}),
    lib_guild_skill_data:save_skill_map(GuildSkillMap).

make_guild_skill_map([], _GuildIds, GuildSkillMap) -> GuildSkillMap;
make_guild_skill_map([T|L], GuildIds, GuildSkillMap) ->
    GuildSkill = make_record(guild_skill, T),
    #guild_skill{guild_id = GuildId} = GuildSkill,
    case GuildIds == [] orelse lists:member(GuildId, GuildIds) of
        true ->
            GuildSkillList = maps:get(GuildId, GuildSkillMap, []),
            NewGuildSkillMap = maps:put(GuildId, [GuildSkill|GuildSkillList], GuildSkillMap);
        _ -> NewGuildSkillMap = GuildSkillMap
    end,
    make_guild_skill_map(L, GuildIds, NewGuildSkillMap).

%% 计算公会技能加的属性
count_skill_attr(PlayerGSkillMap) ->
    F = fun(SkillId, SkillLv, AccList) ->
        case data_guild_skill:get_research_cfg(SkillId, SkillLv) of
            #guild_skill_research_cfg{attr_list = AttrList} ->
                AttrList ++ AccList;
            _ -> AccList
        end
    end,
    AttrList = maps:fold(F, [], PlayerGSkillMap),
    lib_player_attr:partial_attr_convert(AttrList).

%% 检测研究条件
check_research_condition(Guild, SkillId, ResearchLv) ->
    %SkillCfg = data_skill:get(SkillId, ResearchLv),
    GSkillCfg = data_guild_skill:get(SkillId),
    ResearchCfg = data_guild_skill:get_research_cfg(SkillId, ResearchLv),
    if
        %is_record(SkillCfg, skill) == false -> {false, ?ERRCODE(missing_config)};
        is_record(GSkillCfg, guild_skill_cfg) == false -> {false, ?ERRCODE(missing_config)};
        is_record(ResearchCfg, guild_skill_research_cfg) == false -> {false, ?ERRCODE(err400_max_research_lv)};
        Guild#guild.lv < GSkillCfg#guild_skill_cfg.unlock_lv -> {false, ?ERRCODE(err400_gskill_locked)};
        true ->
            case check_list(ResearchCfg#guild_skill_research_cfg.research_condition ++ ResearchCfg#guild_skill_research_cfg.research_cost, Guild) of
                {false, ErrorCode} -> {false, ErrorCode};
                ok -> {ok, ResearchCfg}
            end
    end.

check_research_skill(RoleId, SkillId) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_join_guild)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            #guild{id = GuildId} = Guild,
            #guild_member{position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsHasPermission = lists:member(?PERMISSION_RESEARCH_SKILLS, PermissionList),
            if
                IsHasPermission == false -> {false, ?ERRCODE(err400_not_peimission_research)};
                true ->
                    GuildSkillList = lib_guild_skill_data:get_guild_skill_list(Guild#guild.id),
                    ResearchLv = case lists:keyfind(SkillId, #guild_skill.skill_id, GuildSkillList) of
                        #guild_skill{research_lv = TmpLv} -> TmpLv;
                        _ -> ?DEFAULT_GSKILL_RESEARCH_LV
                    end,
                    case check_research_condition(Guild, SkillId, ResearchLv + 1) of
                        {false, ErrorCode} -> {false, ErrorCode};
                        {ok, ResearchCfg} -> {ok, Guild, ResearchCfg}
                    end
            end
    end.

%% 扣除研究消耗
research_cost([], _, Guild) -> {ok, Guild};
research_cost([{funds, CostFunds}|L], RoleId, Guild) ->
    NewGuild = lib_guild_mod:cost_gfunds(RoleId, Guild, CostFunds, gskill_research_cost),
    research_cost(L, RoleId, NewGuild).

%% 检测学习条件
check_learn_condition(Guild, GuildMember, SkillId, ExtraData) ->
    PlayerGSkillMap = maps:get(player_gskill_map, ExtraData, #{}),
    %RoleLv = maps:get(role_lv, ExtraData, 1),
    LearnLv = maps:get(SkillId, PlayerGSkillMap, 0),
    %GuildSkillList = lib_guild_skill_data:get_guild_skill_list(Guild#guild.id),
    % ResearchLv = case lists:keyfind(SkillId, #guild_skill.skill_id, GuildSkillList) of
    %     #guild_skill{research_lv = TmpLv1} -> TmpLv1;
    %     _ -> ?DEFAULT_GSKILL_RESEARCH_LV
    % end,
    %SkillCfg = data_skill:get(SkillId, LearnLv + 1),
    GSkillCfg = data_guild_skill:get(SkillId),
    ResearchCfg = data_guild_skill:get_research_cfg(SkillId, LearnLv + 1),
    if
        %is_record(SkillCfg, skill) == false -> {false, ?ERRCODE(missing_config)};
        is_record(GSkillCfg, guild_skill_cfg) == false -> {false, ?ERRCODE(missing_config)};
        Guild#guild.lv < GSkillCfg#guild_skill_cfg.unlock_lv -> {false, ?ERRCODE(err400_gskill_locked)};
        %LearnLv >= ResearchLv -> {false, ?ERRCODE(err400_research_lv_limit)};
        is_record(ResearchCfg, guild_skill_research_cfg) == false -> {false, ?ERRCODE(err400_max_research_lv)};
        true ->
            case check_list(ResearchCfg#guild_skill_research_cfg.learn_condition ++ ResearchCfg#guild_skill_research_cfg.learn_cost, [ExtraData, GuildMember]) of
                {false, ErrorCode} -> {false, ErrorCode};
                ok -> {ok, ResearchCfg}
            end
    end.

check_learn_skill(RoleId, SkillId, ExtraData) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_join_guild)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            case check_learn_condition(Guild, GuildMember, SkillId, ExtraData) of
                {false, ErrorCode} -> {false, ErrorCode};
                {ok, ResearchCfg} -> {ok, GuildMember, ResearchCfg}
            end
    end.

%% 扣除学习技能消耗
learn_cost([], GuildMember) -> {ok, GuildMember};
learn_cost([{guild_donate, CostDonate}|L], GuildMember) ->
    NewGuildMember = lib_guild_mod:cost_donate(GuildMember, CostDonate, gskill_learn_cost, []),
    learn_cost(L, NewGuildMember).

learn_skill(Player, SkillId, LearnCost, NewGDonate) ->
    #player_status{
        id = RoleId, guild = #status_guild{id = GuildId, name = GuildName}, guild_skill = PlayerGSkill,
        original_attr = OriginalAttr, figure = #figure{lv = RoleLV}
    } = Player,
    #status_guild_skill{gskill_map = PlayerGSkillMap} = PlayerGSkill,
    LearnLv = maps:get(SkillId, PlayerGSkillMap, 0),
    NewLearnLv = LearnLv + 1,
    db:execute(io_lib:format(?sql_update_player_guild_skill_lv, [RoleId, SkillId, NewLearnLv])),
    %% 日志
    lib_log_api:log_guild_skill(GuildId, GuildName, RoleId, 2, SkillId, LearnCost, LearnLv, NewLearnLv),
    NewPlayerGSkillMap = maps:put(SkillId, NewLearnLv, PlayerGSkillMap),
    NewAttrList = count_skill_attr(NewPlayerGSkillMap),
    NewPlayerGSkill = PlayerGSkill#status_guild_skill{attr = NewAttrList, gskill_map = NewPlayerGSkillMap},
    case data_guild_skill:get_research_cfg(SkillId, NewLearnLv) of
        #guild_skill_research_cfg{attr_list = AttrList} -> ok;
        _ -> AttrList = []
    end,
    case data_guild_skill:get_research_cfg(SkillId, NewLearnLv + 1) of
        #guild_skill_research_cfg{attr_list = NextAttrList} -> ok;
        _ -> NextAttrList = []
    end,
    CurPower = lib_player:calc_partial_power(RoleLV, OriginalAttr, 0, AttrList),
    NextPower = lib_player:calc_expact_power(RoleLV, OriginalAttr, 0, NextAttrList),
    {ok, BinData} = pt_400:write(40042, [?SUCCESS, SkillId, NewLearnLv, NewGDonate, CurPower, NextPower]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewPlayer = lib_player:count_player_attribute(Player#player_status{guild_skill = NewPlayerGSkill}),
    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
    {ok, battle_attr, NewPlayer}.

delete_skill_by_guild_id(GuildId) ->
    GuildSkillMap = lib_guild_skill_data:get_skill_map(),
    NewGuildSkillMap = maps:remove(GuildId, GuildSkillMap),
    lib_guild_skill_data:save_skill_map(NewGuildSkillMap).

%% 打包技能列表
pack_guild_skill_list(SkillType, PlayerGSkillMap, GuildSkillList, OriginalAttr, RoleLv) ->
    AllSkillIds = data_guild_skill:get_all_ids(),
    F = fun(SkillId, AccList) ->
        case data_guild_skill:get(SkillId) of
            #guild_skill_cfg{type = SkillType} ->
                case lists:keyfind(SkillId, #guild_skill.skill_id, GuildSkillList) of
                    #guild_skill{
                        research_lv = ResearchLv
                    } -> skip;
                    _ -> ResearchLv = ?DEFAULT_GSKILL_RESEARCH_LV
                end,
                LearnLv = maps:get(SkillId, PlayerGSkillMap, 0),
                case data_guild_skill:get_research_cfg(SkillId, LearnLv) of
                    #guild_skill_research_cfg{attr_list = AttrList} -> ok;
                    _ -> AttrList = []
                end,
                case data_guild_skill:get_research_cfg(SkillId, LearnLv + 1) of
                    #guild_skill_research_cfg{attr_list = NextAttrList} -> ok;
                    _ -> NextAttrList = []
                end,
                CurPower = lib_player:calc_partial_power(RoleLv, OriginalAttr, 0, AttrList),
                NextPower = lib_player:calc_expact_power(RoleLv, OriginalAttr, 0, NextAttrList),
                [{SkillId, LearnLv, ResearchLv, CurPower, NextPower}|AccList];
            _ -> AccList
        end
    end,
    lists:foldl(F, [], AllSkillIds).

check_list([], _Data) -> ok;
check_list([H|L], Data) ->
    case check(H, Data) of
        true ->
            check_list(L, Data);
        {false, ErrorCode} -> {false, ErrorCode}
    end.

check({guild_lv, NeedLv}, Guild) ->
    case Guild#guild.lv >= NeedLv of
        true -> true;
        false -> {false, ?ERRCODE(err400_guild_lv_not_satisfy_research)}
    end;
check({funds, NeedFunds}, Guild) when NeedFunds > 0 ->
    case Guild#guild.gfunds >= NeedFunds of
        true -> true;
        false -> {false, ?ERRCODE(err400_gfunds_not_enough)}
    end;
check({role_lv, NeedLv}, [RoleDataMap, _GuildMember]) ->
    RoleLv = maps:get(role_lv, RoleDataMap, 0),
    case RoleLv >= NeedLv of
        true -> true;
        false -> {false, ?ERRCODE(err400_role_lv_not_satisfy_learn)}
    end;
check({guild_donate, NeedDonate}, [_RoleDataMap, GuildMember]) when NeedDonate > 0 ->
    #guild_member{donate = Donate} = GuildMember,
    case Donate >= NeedDonate of
        true -> true;
        false -> {false, ?ERRCODE(err400_gdonate_not_satisfy_learn)}
    end;
check(_, _) -> {false, ?ERRCODE(err_config)}.



