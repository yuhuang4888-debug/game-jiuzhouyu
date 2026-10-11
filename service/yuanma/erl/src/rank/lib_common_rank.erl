%%%------------------------------------
%%% @Module  : lib_common_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(lib_common_rank).

-export([
    update_by_rank_type_list/2
    , refresh_common_rank/2
    , get_refresh_list_by_rank_type/2
]).

-include("server.hrl").
-include("common_rank.hrl").
-include("figure.hrl").
-include("flower.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("wing.hrl").
-include("talisman.hrl").
-include("godweapon.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("designation.hrl").
-include("role.hrl").
-include("predefine.hrl").
-include("marriage.hrl").
-include("def_fun.hrl").
-include("holy_ghost.hrl").
-include("jjc.hrl").
-include("dungeon.hrl").
-include("def_goods.hrl").

-compile(export_all).

%% record基础数据
make_record([RankType, Guild]) when RankType == ?RANK_TYPE_GUILD ->
    #guild{
        id = GuildId,
        name = GuildName,
        chief_id = ChairmanId,
        chief_name = ChairmanName,
        lv = Lv,
        member_num = MembersNum,
        combat_power = _Combat,
        combat_power_ten = CombatPowerTen
    } = Guild,
    Value = CombatPowerTen,
    %?PRINT("~p~n", [Value]),
    #common_rank_guild{
        guild_key = {RankType, GuildId},
        rank_type = RankType,
        guild_id = GuildId,
        guild_name = GuildName,
        chairman_id = ChairmanId,
        chairman_name = ChairmanName,
        lv = Lv,
        members_num = MembersNum,
        value = Value,
        time = utime:unixtime()
    };
% make_record([RankType, {{BlockId, HouseId}, RoleId1, RoleId2, AddPop}]) when RankType == ?RANK_TYPE_HOME ->
%     #common_rank_home{
%         home_key = {BlockId, HouseId},
%         block_id = BlockId,
%         house_id = HouseId,
%         role_id_1 = RoleId1,
%         role_id_2 = RoleId2,
%         lock = 0,
%         value = AddPop,
%         rank_type = RankType,
%         time = utime:unixtime()
%     };

%% record基础数据
% make_record([RankType, RoleId]) when RankType == ?RANK_TYPE_ACHIEVE andalso is_integer(RoleId) ->
%     #common_rank_role{
%         role_key = {RankType, RoleId},
%         rank_type = RankType,
%         role_id = RoleId,
%         value = lib_achievement:count_star(RoleId),
%         %second_value    = SecondValue,
%         time = utime:unixtime()
%     };

make_record([RankType, RoleId]) when RankType == ?RANK_TYPE_JJC andalso is_integer(RoleId) ->
    #real_role{rank = Rank} = lib_jjc:get_db_real_role(RoleId),
%%    {ok, #real_role{rank = Rank}} = mod_jjc:role_rank(RoleId),
    #common_rank_role{
        role_key = {RankType, RoleId},
        rank_type = RankType,
        role_id = RoleId,
        value = Rank,
        time = utime:unixtime()
    };

make_record([RankType, {RoleId, AddExp}]) when RankType == ?RANK_TYPE_AFK andalso is_integer(RoleId) ->
    #common_rank_role{
        role_key = {RankType, RoleId},
        rank_type = RankType,
        role_id = RoleId,
        value = AddExp,
        time = utime:unixtime()
    };

make_record([RankType, Player]) when is_record(Player, player_status) ->
    %% ?PRINT("~p~n", [RankType]),
    #player_status{id = Id, figure = #figure{lv = Lv, achiv_stage = AchivStage}, combat_power = Combat} = Player,
    % IsCareerType = is_exist(RankType, ?RANK_TYPE_CAREER_LIST),
    Value = case RankType of%?MOUNT_ID, ?MATE_ID, ?FLY_ID, ?ARTIFACT_ID, ?HOLYORGAN_ID, ?SPIRIT_ID, ?PET_ID
                ?RANK_TYPE_COMBAT ->
                    Combat;
                ?RANK_TYPE_LV ->
                    Lv;
                ?RANK_TYPE_MOUNT ->
                    get_combat_upgrade(?MOUNT_ID, Player);
                ?RANK_TYPE_FLYPET ->
                    get_combat_upgrade(?PET_ID, Player);
                ?RANK_TYPE_WING ->
                    get_combat_upgrade(?FLY_ID, Player);
                ?RANK_TYPE_MATE ->
                    get_combat_upgrade(?MATE_ID, Player);
                ?RANK_TYPE_SPIRIT ->
                    0;
                ?RANK_TYPE_AIRCRAFT ->
                    get_combat_upgrade(?ARTIFACT_ID, Player);
                ?RANK_TYPE_HOLYORGAN ->
                    get_combat_upgrade(?HOLYORGAN_ID, Player);
                ?RANK_TYPE_JUEWEI ->
                    % Player#player_status.figure#figure.juewei_lv;
                    % lib_achievement:count_star(Player#player_status.id);
                    AchivStage;
                ?RANK_TYPE_TOWER_DUN ->
                    lib_dungeon_tower:get_dungeon_level(Player, ?DUNGEON_TYPE_TOWER);
                ?RANK_TYPE_JJC  ->
                    #real_role{rank = Rank} = lib_jjc:get_db_real_role(Player#player_status.id),
%%                    {ok, #real_role{rank = Rank}} = mod_jjc:role_rank(Player#player_status.id),
                    Rank;
                ?RANK_TYPE_EQUIPMENT ->
                    lib_equip:get_all_equip_rating(Player);
                _ ->
                    Combat
            end,
    SecondValue = case RankType of
                      ?RANK_TYPE_MOUNT ->
                          lib_mount:get_status_stage(?MOUNT_ID, Player);
                      ?RANK_TYPE_FLYPET ->
                          lib_mount:get_status_stage(?PET_ID, Player);
                      ?RANK_TYPE_WING ->
                          lib_mount:get_status_stage(?FLY_ID, Player);
                      ?RANK_TYPE_MATE ->
                          lib_mount:get_status_stage(?MATE_ID, Player);
                      ?RANK_TYPE_AIRCRAFT ->
                          lib_mount:get_status_star(?ARTIFACT_ID, Player);
                      ?RANK_TYPE_HOLYORGAN ->
                          lib_mount:get_status_star(?HOLYORGAN_ID, Player);    
                      ?RANK_TYPE_SPIRIT ->
                          0;
                      ?RANK_TYPE_JUEWEI ->
                          lib_goods_api:get_currency(Player, ?GOODS_ID_ACHIEVE);         
                      _ -> 0
                  end,
    ThirdValue = case RankType of
                     ?RANK_TYPE_MOUNT ->
                          lib_mount:get_status_figure_id(?MOUNT_ID, Player);
                      ?RANK_TYPE_FLYPET ->
                          lib_mount:get_status_figure_id(?PET_ID, Player);
                      ?RANK_TYPE_WING ->
                          lib_mount:get_status_figure_id(?FLY_ID, Player);
                      ?RANK_TYPE_MATE ->
                          lib_mount:get_status_figure_id(?MATE_ID, Player);
                      ?RANK_TYPE_AIRCRAFT ->
                          lib_mount:get_status_figure_id(?ARTIFACT_ID, Player);
                      ?RANK_TYPE_HOLYORGAN ->
                          lib_mount:get_status_figure_id(?HOLYORGAN_ID, Player);   
                      ?RANK_TYPE_SPIRIT ->
                          0;       
                     _ -> 0
                 end,
    #common_rank_role{
        role_key = {RankType, Id},
        rank_type = RankType,
        role_id = Id,
        value = Value,
        second_value = SecondValue,
        third_value = ThirdValue,
        time = utime:unixtime()
    }.

%% 秘籍刷新 暂时只支持个人榜单
gm_refresh_rank(Player, RankType) ->
    CommonRank = get_common_rank(RankType, Player),
    mod_common_rank:gm_refresh_rank(RankType, CommonRank).

%% 榜单
refresh_common_rank(RankType, Info) ->
    case is_list(RankType) of
        true -> RankTypeList = RankType;
        false -> RankTypeList = [RankType]
    end,
    refresh_common_rank_by_rank_type_list(RankTypeList, Info),
    ok.

refresh_common_rank_by_rank_type_list(RankTypeList, Info) ->
    F = fun(RankType) -> get_refresh_list_by_rank_type(RankType, Info) end,
    DeepList = lists:map(F, RankTypeList),
    List = lists:flatten(DeepList),
    case List == [] of
        true -> skip;
        false -> mod_common_rank:refresh_common_rank_by_list(List)
    end,
    ok.

%% 获得可以刷新的榜单列表
get_refresh_list_by_rank_type(RankType, Info) ->
    case check(RankType, Info) of
        true ->
            CommonRank = get_common_rank(RankType, Info),
            [{RankType, CommonRank}];
        false ->
            []
    end.

%% 根据玩家信息更新玩家数据[达到战力要求才会刷新]
update_by_rank_type_list(RankTypeList, Player) ->
    F = fun(RankType) -> get_refresh_list_by_rank_type(RankType, Player) end,
    DeepList = lists:map(F, RankTypeList),
    List = lists:flatten(DeepList),
    case List == [] of
        true -> skip;
        false -> mod_common_rank:update_by_role_list(List)
    end,
    ok.

%% 过滤可以上榜的条件
check(_RankType, _Player) ->
    true.

%% check_rank_value_limit(RankType, Value) ->
%%     RankValueLimit = data_common_rank:get_config({rank_value_limit, RankType}),
%%     Value >= RankValueLimit.

%% 组装玩家的数据
get_common_rank(RankType, Info) ->
    CommonRank = make_record([RankType, Info]),
    CommonRank.

is_exist(_I, []) -> false;
is_exist(I, [H | T]) ->
    case I == H of
        true ->
            true;
        false ->
            is_exist(I, T)
    end.

get_rank_config(RankType) ->
    case is_exist(RankType, ?RANK_TYPE_CAREER_LIST) of
        true ->
            data_ranking:get_rank_config(?RANK_TYPE_CAREER);
        false ->
            data_ranking:get_rank_config(RankType)
    end.

%% 称号相关
get_title_id(RankType) ->
    case data_ranking:get_rank_config(RankType) of
        #rank_config{title_id = TitleId} -> TitleId;
        _ -> 0
    end.

%% 称号名字
get_title_name(RankType) ->
    case data_ranking:get_rank_config(RankType) of
        #rank_config{title_id = TitleId} ->
            case data_designation:get_by_id(TitleId) of
                #base_designation{name = Name} -> Name;
                _ -> <<>>
            end;
        _ -> <<>>
    end.

%% 榜单名字
get_rank_type_name(RankType) ->
    case data_ranking:get_rank_config(RankType) of
        #rank_config{rank_name = Name} -> Name;
        _ -> <<>>
    end.

%% 角色名字
get_id_name(RoleId) ->
    case lib_role:get_role_show(RoleId) of
        [] -> <<>>;
        #ets_role_show{figure = #figure{name = Name}} -> Name
    end.

get_charm_week_reward(Rank) ->
    IdList = data_ranking:get_reward_ids(),
    do_get_charm_week_reward(IdList, Rank).

do_get_charm_week_reward([], _) -> {[], []};
do_get_charm_week_reward([H | T], Rank) ->
    case data_ranking:get_reward(H) of
        #base_charm_week_reward{rank_min = Min, rank_max = Max, reward = Reward, fame_reward = ExReward} ->
            case Rank >= Min andalso Rank =< Max of
                true -> {Reward, ExReward};
                _ -> do_get_charm_week_reward(T, Rank)
            end;
        _ -> {[], []}
    end.

get_home_week_reward(Rank) ->
    IdList = data_ranking:get_home_reward_ids(),
    do_get_home_week_reward(IdList, Rank).

do_get_home_week_reward([], _) -> [];
do_get_home_week_reward([H | T], Rank) ->
    case data_ranking:get_home_reward(H) of
        #base_home_rank_reward{rank_min = Min, rank_max = Max, reward = Reward} ->
            case Rank >= Min andalso Rank =< Max of
                true -> Reward;
                _ -> do_get_home_week_reward(T, Rank)
            end;
        _ -> []
    end.

get_rank_type_by_sex(Sex) ->
    case Sex of
        ?MALE -> ?RANK_TYPE_CHARM_BOY;
        ?FEMALE -> ?RANK_TYPE_CHARM_GIRL
    end.

get_old_type_by_sex(Sex) ->
    case Sex of
        ?MALE -> ?RANK_TYPE_CHARM_GIRL;
        ?FEMALE -> ?RANK_TYPE_CHARM_BOY
    end.

get_combat_upgrade(TypeId, Player) ->%%获得进阶榜单上的战力
    #player_status{status_mount = StatusMount} = Player,
    StatusType = lists:keyfind(TypeId, #status_mount.type_id, StatusMount), 
    case StatusType =/= false of
        true ->
            StatusType#status_mount.combat;
        _ -> 0
    end.