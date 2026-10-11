%% ---------------------------------------------------------------------------
%% @doc lib_skill_api
%% @author ming_up@foxmail.com
%% @since  2017-03-10
%% @deprecated 技能对外接口
%% ---------------------------------------------------------------------------
-module(lib_skill_api).

-include("common.hrl").
-include("predefine.hrl").
-include("skill.hrl").

-export([
        add_tmp_skill_list/3,   %% 增加一个临时技能
        add_tmp_skill_list/2,
        del_tmp_skill_list/2,   %% 移除一个临时技能
        add_buff/3,
        clean_buff/2,
        clean_buff/4,
        get_common_skill/0,
        get_career_all_skill_ids/2,
        get_career_skill_ids/2,
        get_career_active_skill_ids/2,
        get_career_active_skill_default_lv_list/2,
        get_career_active_skill_ids_with_rule/4,
        % get_career_skill_active_ids/3
        get_skill_attr2mod/2,
        divide_passive_skill/1,
        get_skill_max_lv/1,
        get_skill_name/2,
        get_skill_power/2,
        get_skill_power/1
        , add_energy/2
        , del_energy/2
        , set_energy/2
    ]).

%% 增加临时技能
add_tmp_skill_list(PlayerId, SkillId, SkillLv) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_skill, add_tmp_skill_list, [SkillId, SkillLv]).

%% 增加临时技能列表
add_tmp_skill_list(PlayerId, SkillList) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_skill, add_tmp_skill_list, [SkillList]).

%% 移除临时技能
%% @param SkillId 技能id | 技能列表
del_tmp_skill_list(PlayerId, SkillId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_skill, del_tmp_skill_list, [SkillId]).

%% 其他进程给玩家身上加buff
add_buff(PlayerId, SkillId, SkillLv)->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_skill_buff, add_buff, [SkillId, SkillLv]).

%% 移除某个技能的buff
%% param SkillId | [SkillId,....]
clean_buff(PlayerId, SkillId) ->
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_skill_buff, clean_buff, [SkillId]).

clean_buff(SceneId, ScenePoolId, PlayerId, SkillId) ->
    lib_skill_buff:clean_buff(SceneId, ScenePoolId, PlayerId, SkillId).

%% 获取配置中的通用技能
get_common_skill() ->
    data_skill:get_ids(?SKILL_CAREER_COMMON).

%% 获取职业专属技能id(不包括通用技能)
get_career_skill_ids(Career, Sex) ->
    data_skill:get_ids(Career, Sex).

%% 获取职业的所有技能id(职业专属+通用)
get_career_all_skill_ids(Career, Sex) ->
    data_skill:get_ids(Career, Sex) ++ get_common_skill().

%% 获取职业主动技能(主动技能、非副技能)
get_career_active_skill_ids(Career, Sex) ->
    SkillList = get_career_skill_ids(Career, Sex),
    F = fun({SkillId, Lv}) ->
        case data_skill:get(SkillId, Lv) of
            %% 主动技能，排除转生增强技能
            #skill{type = ?SKILL_TYPE_ACTIVE, is_combo = 0, lv_data = LvData} when LvData =/= [] -> true;
            _ -> false
        end
    end,
    lists:filter(F, SkillList).

%% 获取职业主动默认等级的技能(主动技能、非副技能)
get_career_active_skill_default_lv_list(Career, Sex) ->
    SkillList = get_career_skill_ids(Career, Sex),
    DefaultLv = ?DEFAULT_SKILL_LV,
    F = fun({SkillId, _Lv}, List) ->
        case data_skill:get(SkillId, DefaultLv) of
            %% 主动技能，排除转生增强技能
            #skill{type = ?SKILL_TYPE_ACTIVE, is_combo = 0, lv_data = LvData} when LvData =/= [] -> [{SkillId, DefaultLv}|List];
            _ -> List
        end
    end,
    lists:reverse(lists:foldl(F, [], SkillList)).

%% 根据获取职业主动技能以及对应的等级(主动技能、非副技能)
get_career_active_skill_ids_with_rule(Career, Sex, RoleLv, Turn) ->
    SkillList = get_career_skill_ids(Career, Sex),
    F = fun({SkillId, MaxLv}, List) -> 
        case get_career_active_skill_ids_with_rule_help(SkillId, MaxLv, RoleLv, Turn) of
            false -> List;
            {SkillId, SkillLv} -> [{SkillId, SkillLv}|List]
        end
    end,
    lists:reverse(lists:foldl(F, [], SkillList)).

get_career_active_skill_ids_with_rule_help(_SkillId, 0, _RoleLv, _Turn) -> false;
get_career_active_skill_ids_with_rule_help(SkillId, Lv, RoleLv, Turn) ->
    case data_skill:get(SkillId, Lv) of
        #skill{type = ?SKILL_TYPE_ACTIVE, is_combo = 0, lv_data = LvData} when LvData =/= [] ->
            case lists:keyfind(turn, 1, LvData#skill_lv.condition) of
                {turn, NeedTurn} when Turn < NeedTurn -> TurnBool = false;
                _ -> TurnBool = true
            end,
            case lists:keyfind(lv, 1, LvData#skill_lv.condition) of
                {lv, NeedLv} when RoleLv < NeedLv -> LvBool = false;
                _ -> LvBool = true
            end,
            case TurnBool andalso LvBool of
                true -> {SkillId, Lv};
                false -> get_career_active_skill_ids_with_rule_help(SkillId, Lv-1, RoleLv, Turn)
            end;
        _ ->
            get_career_active_skill_ids_with_rule_help(SkillId, Lv-1, RoleLv, Turn)
    end.

%% 获取技能对模块加成的被动属性列表
%% @param 第一参数 ModId | {ModId, SubModId} | 0
get_skill_attr2mod(ModId, SkillIds) when is_list(SkillIds) ->
    AttrL = lists:foldl(fun(T, AccL) ->
        TmpL = case T of
            {SkillId, SkillLv} ->
                get_skill_attr2mod(ModId, SkillId, SkillLv);
            SkillId ->
                get_skill_attr2mod(ModId, SkillId, 1)
        end,
        TmpL ++ AccL
    end, [], SkillIds),
    util:combine_list(AttrL).

get_skill_attr2mod(ModId, SkillId, Lv) ->
    lib_skill:get_skill_attr2mod(ModId, SkillId, Lv).

%% 分离出战斗计算的被动
divide_passive_skill([]) -> [];
divide_passive_skill(SkillIds) ->
    SkillLvList = lists:map(fun(Tmp) ->
                                    case Tmp of
                                        {TmpId, TmpLv} -> {TmpId, TmpLv};
                                        _ -> {Tmp, 1}
                                    end
                            end, SkillIds),
    lib_skill:divide_passive_skill(SkillLvList).

%% 获取
get_skill_max_lv(SkillId)->
    case data_skill:get(SkillId, 1) of
        [] -> 0;
        #skill{career = Career} ->
            SkillTypeList = data_skill:get_ids(Career),
            case lists:keyfind(SkillId, 1, SkillTypeList) of
                false -> 0;
                {_, MaxLv} -> MaxLv
            end
    end.

get_skill_name(SkillId, SkillLv) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{name = Name} ->
            util:make_sure_binary(Name);
        _ -> <<>>
    end.

get_skill_power(SkillId, SkillLv) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{lv_data=#skill_lv{power = Power}} ->
            Power;
        _ -> 0
    end.

%% 获得技能战力
get_skill_power(SkillList) ->
    lists:sum([get_skill_power(SkillId, SkillLv)||{SkillId, SkillLv}<-SkillList]).

%% 增加能量值到场景
add_energy(RoleId, AddEnergy) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_skill, add_energy, [AddEnergy]).

%% 减少能量值到场景
del_energy(RoleId, DelEnergy) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_skill, del_energy, [DelEnergy]).

%% 设置能量值到场景
set_energy(RoleId, Energy) -> 
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_skill, set_energy, [Energy]).