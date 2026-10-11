%%%------------------------------------
%%% @Module  : lib_common_rank_mod
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 通用榜单
%%%------------------------------------

-module(lib_common_rank_mod).


-export([
    init/0
    , refresh_common_rank/3
    , send_rank_list/7
]).

-compile(export_all).

-include("errcode.hrl").
-include("common_rank.hrl").
-include("common.hrl").
-include("record.hrl").
-include("relationship.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("def_module.hrl").
-include("sanctuary.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("wing.hrl").
-include("talisman.hrl").
-include("godweapon.hrl").
-include("def_fun.hrl").
-include("language.hrl").
-include("marriage.hrl").
-include("holy_ghost.hrl").
-include("predefine.hrl").
-include("chrono_rift.hrl").

make_record(common_rank_guild, [RankType, GuildId, GuildName_B, ChairmanId,
    ChairmanName_B, Lv, MembersNum, Value, SecondValue, ThirdValue, Time]) ->
    GuildName = util:make_sure_list(GuildName_B),
    ChairmanName = util:make_sure_list(ChairmanName_B),
    #common_rank_guild{
        guild_key     = {RankType, GuildId},
        rank_type     = RankType,
        guild_id      = GuildId,
        guild_name    = GuildName,
        chairman_id   = ChairmanId,
        chairman_name = ChairmanName,
        lv            = Lv,
        members_num   = MembersNum,
        value         = Value,
        second_value  = SecondValue,
        third_value   = ThirdValue,
        time          = Time
    };

make_record(common_rank_role, [RankType, RoleId, Value, SecondValue, ThirdValue, Time]) ->
    #common_rank_role{
        role_key      = {RankType, RoleId},
        rank_type     = RankType,
        role_id       = RoleId,
        value         = Value,
        display_value = Value,
        second_value  = SecondValue,
        third_value   = ThirdValue,
        time          = Time
    };

make_record(common_rank_home, [RankType, BlockId, HouseId, RoleId1, RoleId2, Lock, Value, SecValue, ThirValue, Time]) ->
    #common_rank_home{
        home_key     = {BlockId, HouseId},
        rank_type    = RankType,
        block_id     = BlockId,
        house_id     = HouseId,
        role_id_1    = RoleId1,
        role_id_2    = RoleId2,
        lock         = Lock,
        value        = Value,
        second_value = SecValue,
        third_value  = ThirValue,
        time         = Time
    }.

init() ->
    %% 个人榜单
    List = db_common_rank_role_select(),
    RoleList = [make_record(common_rank_role, T) || T <- List],
    RankMaps = get_standard_sort_rank_maps(common_rank_role, RoleList),
    RoleLimitList = clean_redundant_rank_data_from_db(RankMaps),
    %% 公会榜单
    List1 = db_common_rank_guild_select(),
    GuildList = [make_record(common_rank_guild, T) || T <- List1],
    GuildMaps = get_standard_sort_rank_maps(common_rank_guild, GuildList),
    GuildLimitList = clean_redundant_rank_data_from_db(GuildMaps),
    %% 家园榜单
    % List3 = db_common_rank_home_select(),
    RankLimit = maps:from_list(RoleLimitList ++ GuildLimitList),
    %% 点赞
    List2 = db_common_rank_praise_select(),
    F2 = fun([Id, PraiseNum]) -> {Id, PraiseNum} end,
    PraiseList = lists:map(F2, List2),
    PraiseMaps = maps:from_list(PraiseList),
    %% 第一公会id
    FirstGuildId = case util:get_merge_day() of
                       1 -> 0;          %% 合服的时候第一次 把所有公会称号清了再发
                       _ ->             %% 其他情况 次日还是这公会第一的话 不会清了再发
                           case maps:get(?RANK_TYPE_GUILD, GuildMaps, []) of
                               [] -> 0;
                               GuildL ->
                                   [No1CommonRankGuild | _] = GuildL,
                                   No1CommonRankGuild#common_rank_guild.guild_id
                           end
                   end,
    LoginTimeMap = db_init_login_time_map(RankMaps),
    %% 检查世界等级是否需要重新初始化
    lib_server_kv:reset_world_lv(RankMaps, LoginTimeMap),
    FirstRankList = lib_common_rank_gift:init_first_rank_list(),
    #common_rank_state{
        role_maps       = RankMaps,
        % value_maps      = ValueMaps,
        guild_maps      = GuildMaps,
        old_first_guild = FirstGuildId,
        rank_limit      = RankLimit,
        praise_maps     = PraiseMaps,
        first_rank_list = FirstRankList,
        last_login_time_map = LoginTimeMap
        % home_value_maps = HomeValueMaps,
        % home_rank_maps  = HomeRankMaps
    }.

%% 获得标准排序Maps(被截取了长度) Key:RankType Value:[#common_rank_role{}]
get_standard_sort_rank_maps(common_rank_role, RoleList) ->
    MapsKeyList = get_sort_rank_maps(common_rank_role, RoleList),
    F = fun({RankType, RankList}) ->
        #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
        NewRankList0 = lists:sublist(RankList, MaxRankLen),
        case RankType ==?RANK_TYPE_JJC of
            true ->
                NewRankList = [RankRole || RankRole <- NewRankList0, RankRole#common_rank_role.value =< Limit andalso RankRole#common_rank_role.value >0];
            false->
                NewRankList = [RankRole || RankRole <- NewRankList0, RankRole#common_rank_role.value >= Limit]
        end,
        {RankType, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewMaps = maps:from_list(NewKeyList),
    NewMaps;

get_standard_sort_rank_maps(common_rank_guild, RoleList) ->
    MapsKeyList = get_sort_rank_maps(common_rank_guild, RoleList),
    F = fun({RankType, RankList}) ->
        #rank_config{rank_max = MaxRankLen} = lib_common_rank:get_rank_config(RankType),
        %% MaxRankLen = data_common_rank:get_config({max_rank_len, RankType}),
        NewRankList = lists:sublist(RankList, MaxRankLen),
        {RankType, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewMaps = maps:from_list(NewKeyList),
    NewMaps;

get_standard_sort_rank_maps(common_rank_home, RoleList) ->
    MapsKeyList = get_sort_rank_maps(common_rank_home, RoleList),
    F = fun({RankType, RankList}) ->
        #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
        NewRankList0 = lists:sublist(RankList, MaxRankLen),
        NewRankList = [RankRole || RankRole <- NewRankList0, RankRole#common_rank_home.value >= Limit],
        {RankType, NewRankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewMaps = maps:from_list(NewKeyList),
    NewMaps.

%% 分类到Maps,然后对Maps的Value排序 Key:RankType Value:[#common_rank_role{}]
get_sort_rank_maps(common_rank_role, RoleList) ->
    F = fun(#common_rank_role{rank_type = RankType} = RankRole, Maps) ->
        case maps:get(RankType, Maps, false) of
            false -> NewList = [RankRole];
            List -> NewList = [RankRole | List]
        end,
        maps:put(RankType, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), RoleList),
    NewKeyList = sort_rank_maps(Maps),
    NewKeyList;

get_sort_rank_maps(common_rank_guild, GuildList) ->
    F = fun(#common_rank_guild{rank_type = RankType} = RankGuild, Maps) ->
        case maps:get(RankType, Maps, false) of
            false -> NewList = [RankGuild];
            List -> NewList = [RankGuild | List]
        end,
        maps:put(RankType, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), GuildList),
    NewKeyList = sort_rank_maps(Maps),
    NewKeyList;

get_sort_rank_maps(common_rank_home, RoleList) ->
    F = fun(#common_rank_home{rank_type = RankType} = RankRole, Maps) ->
        case maps:get(RankType, Maps, false) of
            false -> NewList = [RankRole];
            List -> NewList = [RankRole | List]
        end,
        maps:put(RankType, NewList, Maps)
        end,
    Maps = lists:foldl(F, maps:new(), RoleList),
    NewKeyList = sort_home_rank_maps(Maps),
    NewKeyList.

%% 对Maps的Value排序
sort_rank_maps(Maps) ->
    MapsKeyList = maps:to_list(Maps),
    F = fun({Key, List}) ->
        case Key =/= ?RANK_TYPE_JJC andalso Key =/= ?RANK_TYPE_JUEWEI of
            true ->
                RankList = sort_rank_list(List);
            false ->
                % ?PRINT("Key:~p~n",[Key]),
                RankList = sort_rank_list(List, Key)
        end,
        % ?PRINT("RankList:~p~n",[RankList]),
        {Key, RankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewKeyList.

sort_home_rank_maps(Maps) ->
    MapsKeyList = maps:to_list(Maps),
    F = fun({Key, List}) ->
        RankList = sort_home_rank_list(List),
        {Key, RankList}
        end,
    NewKeyList = lists:map(F, MapsKeyList),
    NewKeyList.

sort_rank_list(List) ->
    F = fun(A, B) ->
        if
            is_record(A, common_rank_role) ->
                if
                    A#common_rank_role.value > B#common_rank_role.value -> true;
                    A#common_rank_role.value == B#common_rank_role.value ->
                        A#common_rank_role.time =< B#common_rank_role.time;
                    true -> false
                end;
            is_record(A, common_rank_guild) ->
                if
                    A#common_rank_guild.value > B#common_rank_guild.value -> true;
                    A#common_rank_guild.value == B#common_rank_guild.value ->
                        A#common_rank_guild.time =< B#common_rank_guild.time;
                    true -> false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),

    F1 = fun(Member, {TempList, Value}) ->
        if
            is_record(Member, common_rank_role) ->
                NewMember = Member#common_rank_role{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            is_record(Member, common_rank_guild) ->
                NewMember = Member#common_rank_guild{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            true ->
                {TempList, Value}
        end

         end,
    {TmpRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    lists:reverse(TmpRankList).

sort_rank_list(List, RankType) when RankType == ?RANK_TYPE_JJC->
    F = fun(A, B) ->
        if
            is_record(A, common_rank_role) ->
                if
                    A#common_rank_role.value < B#common_rank_role.value andalso A#common_rank_role.value > 0->
                        true;
                    A#common_rank_role.value == B#common_rank_role.value ->
                        A#common_rank_role.time =< B#common_rank_role.time;
                    true ->
                        false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),
    sort_rank_list_helper(NewList);

sort_rank_list(List, RankType) when RankType == ?RANK_TYPE_JUEWEI ->
    F = fun(A, B) ->
        if
            is_record(A, common_rank_role) ->
                if
                    A#common_rank_role.value > B#common_rank_role.value -> true;
                    A#common_rank_role.value == B#common_rank_role.value ->
                        A#common_rank_role.second_value =< B#common_rank_role.second_value;
                    true -> false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),
    sort_rank_list_helper(NewList).

sort_rank_list_helper(NewList) ->
    F1 = fun(Member, {TempList, Value}) ->
        if
            is_record(Member, common_rank_role) ->
                NewMember = Member#common_rank_role{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            true ->
                {TempList, Value}
        end
        end,
    {TmpRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    lists:reverse(TmpRankList).

sort_home_rank_list(List) ->
    F = fun(A, B) ->

        if
            A#common_rank_home.value > B#common_rank_home.value -> true;
            A#common_rank_home.value == B#common_rank_home.value ->
                A#common_rank_home.time =< B#common_rank_home.time;
            true -> false
        end
        end,
    NewList = lists:sort(F, [Home || #common_rank_home{lock = 0} = Home <- List]),
    %?PRINT("~p~n", [NewList]),
    F1 = fun(Member, {TempList, Value}) ->
        NewMember = Member#common_rank_home{rank = Value},
        NewTempList = [NewMember | TempList],
        {NewTempList, Value + 1}
         end,
    {TmpRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    %?PRINT("~p~n", [TmpRankList]),
    lists:reverse(TmpRankList).

sort_display_list(List) ->
    F = fun(A, B) ->
        if
            is_record(A, common_rank_role) ->
                if
                    A#common_rank_role.display_value > B#common_rank_role.display_value -> true;
                    A#common_rank_role.display_value == B#common_rank_role.display_value ->
                        A#common_rank_role.time =< B#common_rank_role.time;
                    true -> false
                end;
            true ->
                false
        end
        end,
    NewList = lists:sort(F, List),
    F1 = fun(Member, {TempList, Value}) ->
        if
            is_record(Member, common_rank_role) ->
                NewMember = Member#common_rank_role{rank = Value},
                NewTempList = [NewMember | TempList],
                {NewTempList, Value + 1};
            true ->
                {TempList, Value}
        end

         end,
    {TmpRankList, _} = lists:foldl(F1, {[], 1}, NewList),
    lists:reverse(TmpRankList).


%% 清理数据库的冗余数据,防止数据过多
clean_redundant_rank_data_from_db(RankMaps) ->
    MapsKeyList = maps:to_list(RankMaps),
    F = fun({RankType, []}) ->
        #rank_config{rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
        {RankType, Limit};
        ({RankType, RankList}) ->
            #rank_config{rank_limit = Limit, rank_max = RankMax} = lib_common_rank:get_rank_config(RankType),
            case length(RankList) >= RankMax of
                true ->
                    RankLast = lists:last(RankList),
                    case RankType of
                        ?RANK_TYPE_GUILD ->
                            #common_rank_guild{value = Value} = RankLast;
                        % ?RANK_TYPE_CHARM_BOY ->
                        %     #common_rank_role{value = Value} = RankLast;
                        % ?RANK_TYPE_CHARM_GIRL ->
                        %     #common_rank_role{value = Value} = RankLast;
                        % ?RANK_TYPE_HOME ->
                        %     #common_rank_role{value = Value} = RankLast;
                        _ ->
                            #common_rank_role{value = Value} = RankLast,
                            db_common_rank_delete_by_value(RankType, Value)
                    end,
                    {RankType, max(Value, Limit)};
                false ->
                    {RankType, Limit}
            end
        end,
    lists:map(F, MapsKeyList).

%% @param [{RankType, CommonRankRole}]
refresh_common_rank_by_list(State, List) ->
    F = fun({RankType, CommonRank}, TmpState) ->
        {ok, NewTmpState} = refresh_common_rank(TmpState, RankType, CommonRank),
        NewTmpState
        end,
    NewState = lists:foldl(F, State, List),
    {ok, NewState}.

%% 解散公会
disband_guild(State, GuildId, RankTypeList) ->
    F = fun(RankType, TempState) ->
        {ok, NewTmpState} = disband_guild_help(TempState, RankType, GuildId),
        NewTmpState
        end,
    NewState = lists:foldl(F, State, RankTypeList),
    {ok, NewState}.

disband_guild_help(State, RankType, GuildId) ->
    #common_rank_state{guild_maps = GuildMaps} = State,
    RankList = maps:get(RankType, GuildMaps, []),
    case lists:keyfind({RankType, GuildId}, #common_rank_guild.guild_key, RankList) of
        #common_rank_guild{} ->
            NewRankList = lists:keydelete({RankType, GuildId}, #common_rank_guild.guild_key, RankList),
            db_common_rank_delete_by_id(RankType, GuildId),
            NewRankList2 = sort_rank_list(NewRankList);
        false ->
            NewRankList2 = RankList
    end,
    NewGuildMaps = maps:put(RankType, NewRankList2, GuildMaps),
    {ok, State#common_rank_state{guild_maps = NewGuildMaps}}.

%% 家园上锁
% remove_rank_home(State, HomeId) ->
%     %?PRINT("~p~n", [HomeId]),
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps} = State,
%     RoleList = maps:get(?RANK_TYPE_HOME, RoleMaps, []),
%     %?PRINT("~p~n", [RoleList]),
%     RankList = maps:get(?RANK_TYPE_HOME, RankMaps, []),
%     case lists:keyfind(HomeId, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{} = Home ->
%             NewRoleList2 = lists:keystore(HomeId, #common_rank_home.home_key, RoleList, NewHome = Home#common_rank_home{lock = 1}),
%             NewRankList = lists:keystore(HomeId, #common_rank_home.home_key, RankList, NewHome),
%             db_common_rank_home_save(NewHome),
%             NewRankList2 = sort_home_rank_list(NewRankList);
%         false ->
%             NewRankList2 = RankList,
%             NewRoleList2 = RoleList
%     end,
%     NewRankMaps = maps:put(?RANK_TYPE_HOME, NewRankList2, RankMaps),
%     NewRoleMaps = maps:put(?RANK_TYPE_HOME, NewRoleList2, RoleMaps),
%     {ok, State#common_rank_state{home_value_maps = NewRoleMaps, home_rank_maps = NewRankMaps}}.

% delete_home(State, {BlockId, HouseId} = HomeId) ->
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps} = State,
%     RoleList = maps:get(?RANK_TYPE_HOME, RoleMaps, []),
%     RankList = maps:get(?RANK_TYPE_HOME, RankMaps, []),
%     case lists:keyfind(HomeId, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{} ->
%             NewRoleList2 = lists:keydelete(HomeId, #common_rank_home.home_key, RoleList),
%             NewRankList = lists:keydelete(HomeId, #common_rank_home.home_key, RankList),
%             db_common_rank_delete_by_id(?RANK_TYPE_HOME, BlockId, HouseId),
%             NewRankList2 = sort_home_rank_list(NewRankList);
%         false ->
%             NewRankList2 = RankList,
%             NewRoleList2 = RoleList
%     end,
%     NewRankMaps = maps:put(?RANK_TYPE_HOME, NewRankList2, RankMaps),
%     NewRoleMaps = maps:put(?RANK_TYPE_HOME, NewRoleList2, RoleMaps),
%     {ok, State#common_rank_state{home_rank_maps = NewRankMaps, home_value_maps = NewRoleMaps}}.

% home_role_change(State, HomeId, RoleId1, RoleId2) ->
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps} = State,
%     RoleList = maps:get(?RANK_TYPE_HOME, RoleMaps, []),
%     RankList = maps:get(?RANK_TYPE_HOME, RankMaps, []),
%     case lists:keyfind(HomeId, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{} = Home ->
%             NewRoleList2 = lists:keystore(HomeId, #common_rank_home.home_key, RoleList, NewHome = Home#common_rank_home{role_id_1 = RoleId1, role_id_2 = RoleId2}),
%             NewRankList = lists:keystore(HomeId, #common_rank_home.home_key, RankList, NewHome),
%             db_common_rank_home_save(NewHome),
%             NewRankList2 = sort_home_rank_list(NewRankList);
%         false ->
%             NewRankList2 = RankList,
%             NewRoleList2 = RoleList
%     end,
%     NewRankMaps = maps:put(?RANK_TYPE_HOME, NewRankList2, RankMaps),
%     NewRoleMaps = maps:put(?RANK_TYPE_HOME, NewRoleList2, RoleMaps),
%     {ok, State#common_rank_state{home_rank_maps = NewRankMaps, home_value_maps = NewRoleMaps}}.

% home_rerank(State, HomeId) ->
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps} = State,
%     RoleList = maps:get(?RANK_TYPE_HOME, RoleMaps, []),
%     RankList = maps:get(?RANK_TYPE_HOME, RankMaps, []),
%     case lists:keyfind(HomeId, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{} = Home ->
%             NewRoleList2 = lists:keystore(HomeId, #common_rank_home.home_key, RoleList, NewHome = Home#common_rank_home{lock = 0}),
%             NewRankList = lists:keystore(HomeId, #common_rank_home.home_key, RankList, NewHome),
%             db_common_rank_home_save(NewHome),
%             NewRankList2 = sort_home_rank_list(NewRankList);
%         false ->
%             NewRankList2 = RankList,
%             NewRoleList2 = RoleList
%     end,
%     NewRankMaps = maps:put(?RANK_TYPE_HOME, NewRankList2, RankMaps),
%     NewRoleMaps = maps:put(?RANK_TYPE_HOME, NewRoleList2, RoleMaps),
%     {ok, State#common_rank_state{home_value_maps = NewRoleMaps, home_rank_maps = NewRankMaps}}.

%% 同步公会榜单
% sync_guild_rank(State) ->
%     #common_rank_state{guild_maps = GuildMaps} = State,
%     GuildList = maps:get(?RANK_TYPE_GUILD, GuildMaps, []),
%     F = fun(#common_rank_guild{guild_id=GuildId}=CommonRankGuild, TempState) ->
%                 {Value, Lv} = db_guild_reputation_select(GuildId),
%                 ChairmanId = db_guild_leader_select(GuildId),
%                 case lib_role:get_role_show(ChairmanId) of
%                     #ets_role_show{figure = #figure{name=Name}} ->ok;
%                     _ -> Name = <<>>
%                 end,
%                 NewCommonRankGuild = CommonRankGuild#common_rank_guild{lv=Lv, value=Value, chairman_id = ChairmanId, chairman_name=Name},
%                 {ok, NewState} = refresh_common_rank(TempState, ?RANK_TYPE_GUILD, NewCommonRankGuild),
%                 NewState;
%            (_, TempState) ->
%                 TempState
%         end,
%     {ok, lists:foldl(F, State, GuildList)}.

%% 更新平均等级
refresh_average_lv_20(State) ->
    #common_rank_state{role_maps = RankMaps, last_login_time_map = LoginTimeMap} = State,
    lib_server_kv:reset_world_lv(RankMaps, LoginTimeMap),
    util:cast_event_to_players({'refresh_average_lv_20'}),
    {ok, State}.

%% 刷新服战力
refresh_server_combat_power_10(State) ->
    CombatPower = lib_common_rank_mod:get_all_combat(State, ?RANK_TYPE_COMBAT, 1, 10),
    mod_clusters_node:apply_cast(lib_clusters_center_api, update, [config:get_server_id(), [{combat_power, CombatPower}]]),
    {ok, State}.

gm_refresh_rank(State, RankType, CommonRankRole) ->
    #common_rank_state{role_maps = RankMaps, rank_limit = RankLimit} = State,
    RankList = maps:get(RankType, RankMaps, []),
    {NewRankList, NewRankLimit} = do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit, false),
    NewRankMaps = maps:put(RankType, NewRankList, RankMaps),
    NewState = State#common_rank_state{role_maps = NewRankMaps, rank_limit = NewRankLimit},
    {ok, NewState}.

%% 刷新榜单
refresh_common_rank(State, RankType, CommonRankGuild) when RankType == ?RANK_TYPE_GUILD ->
    #common_rank_state{guild_maps = GuildMaps, rank_limit = RankLimit} = State,
    RankList = maps:get(RankType, GuildMaps, []),
    {NewRankList, NewRankLimit} = do_refresh_common_rank_help(RankList, RankType, CommonRankGuild, RankLimit),
    NewRankMaps = maps:put(RankType, NewRankList, GuildMaps),
    NewState = State#common_rank_state{guild_maps = NewRankMaps, rank_limit = NewRankLimit},
    {ok, NewState};

% refresh_common_rank(State, RankType, {RoleId, CharmPlus}) when RankType == ?RANK_TYPE_CHARM_BOY orelse RankType == ?RANK_TYPE_CHARM_GIRL ->
%     #common_rank_state{value_maps = RoleMaps, role_maps = RankMaps, rank_limit = RankLimit} = State,
%     RankList = maps:get(RankType, RankMaps, []),
%     RoleList = maps:get(RankType, RoleMaps, []),
%     case lists:keyfind({RankType, RoleId}, #common_rank_role.role_key, RoleList) of
%         #common_rank_role{value = OldValue} = OldRole ->
%             NewRole = OldRole#common_rank_role{value = OldValue + CharmPlus, time = utime:unixtime()};
%         _ ->
%             NewRole = #common_rank_role{role_key = {RankType, RoleId}, rank_type = RankType, role_id = RoleId, value = CharmPlus, time = utime:unixtime()}
%     end,
%     NewRoleList = lists:keystore({RankType, RoleId}, #common_rank_role.role_key, RoleList, NewRole),
%     NewRoleMaps = maps:put(RankType, NewRoleList, RoleMaps),
%     {NewRankList, NewRankLimit} = do_refresh_common_rank_help(RankList, RankType, NewRole, RankLimit),
%     NewRankMaps = maps:put(RankType, NewRankList, RankMaps),
%     NewState = State#common_rank_state{role_maps = NewRankMaps, value_maps = NewRoleMaps, rank_limit = NewRankLimit},
%     db_common_rank_role_save(NewRole),
%     {ok, NewState};

% refresh_common_rank(State, RankType, HomeRole) when RankType == ?RANK_TYPE_HOME ->
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps, rank_limit = RankLimit} = State,
%     RankList = maps:get(RankType, RankMaps, []),
%     RoleList = maps:get(RankType, RoleMaps, []),
%     case lists:keyfind(HomeRole#common_rank_home.home_key, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{value = OldValue} = OldRole ->
%             NewRole = OldRole#common_rank_home{value = OldValue + HomeRole#common_rank_home.value, time = utime:unixtime()};
%         _ ->
%             NewRole = HomeRole
%     end,
%     NewRoleList = lists:keystore(HomeRole#common_rank_home.home_key, #common_rank_home.home_key, RoleList, NewRole),
%     NewRoleMaps = maps:put(RankType, NewRoleList, RoleMaps),
%     {NewRankList, NewRankLimit} = do_refresh_common_rank_help(RankList, RankType, NewRole, RankLimit),
%     NewRankMaps = maps:put(RankType, NewRankList, RankMaps),
%     NewState = State#common_rank_state{home_rank_maps = NewRankMaps, home_value_maps = NewRoleMaps, rank_limit = NewRankLimit},
%     db_common_rank_home_save(NewRole),
%     {ok, NewState};

refresh_common_rank(State, RankType, CommonRankRole) ->
    #common_rank_state{role_maps = RankMaps, rank_limit = RankLimit} = State,
    RankList = maps:get(RankType, RankMaps, []),
    {NewRankList, NewRankLimit} = do_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit),
    NewRankMaps = maps:put(RankType, NewRankList, RankMaps),
    NewState = State#common_rank_state{role_maps = NewRankMaps, rank_limit = NewRankLimit},
    {ok, NewState}.


%% 先判断list中是否存在key和value都相等的玩家，存在则跟新数据，不存在则将其进行队列排序：将其与队
%% 尾比较，若小于队尾并且队列长度大于最长长度，则丢弃，否则将其加入队列，排序并保证队列长度为最大
%% 队列长度，发送数据的时候，先截取显示长度，再判断是否满足limit，满足条件的才加入发送队列。
%% 时刻保证，排序之后队列和数据库保存的数据为整个服的前N，然后在这之中选择发送、
do_refresh_common_rank_help(RankList, RankType, CommonRankGuild, RankLimit) when RankType == ?RANK_TYPE_GUILD ->
    #common_rank_guild{guild_key = GuildKey, value = Value} = CommonRankGuild,
    #rank_config{} = lib_common_rank:get_rank_config(RankType),
    case lists:keyfind(GuildKey, #common_rank_guild.guild_key, RankList) of
        #common_rank_guild{value = Value, time = Time, rank = Rank} = OldRankGuild ->
            NewGuild = CommonRankGuild#common_rank_guild{time = Time, rank = Rank},
            case NewGuild =/= OldRankGuild of
                true ->
                    db_common_rank_guild_save(NewGuild),
                    NewList = lists:keystore(GuildKey, #common_rank_guild.guild_key, RankList, NewGuild);
                _ ->
                    NewList = RankList
            end,
            {NewList, RankLimit};
        _ ->
            do_refresh_common_rank_help2(RankList, RankType, CommonRankGuild, RankLimit)
    end;

% do_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit) when RankType == ?RANK_TYPE_HOME ->
%     #common_rank_home{home_key = RoleKey, value = Value} = CommonRankRole,
%     case lists:keyfind(RoleKey, #common_rank_home.home_key, RankList) of
%         #common_rank_home{value = Value, time = OldTime, rank = Rank} = OldRankRole ->
%             NewRole = CommonRankRole#common_rank_home{time = OldTime, rank = Rank},  %% 时间为排序值更新时间 如果值没改变就用回之前的
%             case NewRole =/= OldRankRole of   %% 保留值改了的时候更新
%                 true ->
%                     db_common_rank_home_save(NewRole),
%                     NewList = lists:keystore(RoleKey, #common_rank_home.home_key, RankList, NewRole);
%                 _ ->
%                     NewList = RankList
%             end,
%             {NewList, RankLimit};
%         _ ->
%             do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit)
%     end;

do_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit) when RankType == ?RANK_TYPE_AFK ->
    do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit);

do_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit) ->
    #common_rank_role{role_key = RoleKey, value = Value} = CommonRankRole,
    case lists:keyfind(RoleKey, #common_rank_role.role_key, RankList) of
        #common_rank_role{value = Value, time = OldTime, rank = Rank, display_value = DisValue} = OldRankRole ->
            NewRole = CommonRankRole#common_rank_role{time = OldTime, rank = Rank, display_value = DisValue},  %% 时间为排序值更新时间 如果值没改变就用回之前的
            case NewRole =/= OldRankRole of   %% 保留值改了的时候更新
                true ->
                    db_common_rank_role_save(NewRole),
                    NewList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList, NewRole);
                _ ->
                    NewList = RankList
            end,
            {NewList, RankLimit};
        _ ->
            do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit)
    end.

do_refresh_common_rank_help2(RankList, RankType, CommonRankGuild, RankLimit) when RankType == ?RANK_TYPE_GUILD ->
    #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
    Temp = maps:get(RankType, RankLimit, Limit),
    LastValue = max(Temp, Limit),
    %% ?PRINT("LastValue:~p RankList:~p ~n", [LastValue, RankList]),
    case RankList == [] of
        true ->
            if
                CommonRankGuild#common_rank_guild.value >= LastValue ->
                    db_common_rank_guild_save(CommonRankGuild),
                    NewRankList2 = [CommonRankGuild#common_rank_guild{rank = 1}],
                    {NewRankList2, RankLimit};
                true ->
                    NewRankList2 = [],
                    {NewRankList2, RankLimit}
            end;
        false ->
            IsExistKey = lists:keymember(CommonRankGuild#common_rank_guild.guild_key, #common_rank_guild.guild_key, RankList),
            %% Len = length(RankList),
            #common_rank_guild{guild_key = GuildKey, value = Value} = CommonRankGuild,
            %% 是否需要排序
            case Value < LastValue andalso (not IsExistKey) of
                true ->
                    NewRankList2 = RankList,
                    {NewRankList2, RankLimit};
                false ->
                    %% 内存和数据库存储
                    NewRankList = lists:keystore(GuildKey, #common_rank_guild.guild_key, RankList, CommonRankGuild),
                    db_common_rank_guild_save(CommonRankGuild),
                    %% 排序
                    NewRankList2 = sort_rank_list(NewRankList),
                    NewLen = length(NewRankList2),
                    case NewLen > MaxRankLen of
                        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
                        false -> LeftRankList = []
                    end,
                    %% 清理冗余数据,这样修改插入数据效率会提高
                    F = fun(#common_rank_guild{guild_id = TmpGuildId}) ->
                        db_common_rank_delete_by_id(RankType, TmpGuildId) end,
                    lists:foreach(F, LeftRankList),
                    %% 返回数据
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
%%                    ?MYLOG("cym", "NewRankList2 ~p~n , LastList ~p~n", [NewRankList2, LastList]),
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            LastRankGuild = lists:last(LastList),
                            #common_rank_guild{value = TempLastValue} = LastRankGuild,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
                    {LastList, NewRankLimit}
            end
    end;

% do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) when RankType =:= ?RANK_TYPE_HOME ->
%     #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
%     Temp = maps:get(RankType, RankLimit, Limit),
%     LastValue = max(Temp, Limit),
%     %% ?PRINT("LastValue:~p RankList:~p ~n", [LastValue, RankList]),
%     case RankList == [] of
%         true ->
%             if
%                 CommonRankRole#common_rank_home.value >= LastValue ->
%                     db_common_rank_home_save(CommonRankRole),
%                     NewRankList2 = [CommonRankRole#common_rank_home{rank = 1}],
%                     {NewRankList2, RankLimit};
%                 true ->
%                     NewRankList2 = [],
%                     {NewRankList2, RankLimit}
%             end;
%         false ->
%             IsExistKey = lists:keymember(CommonRankRole#common_rank_home.home_key, #common_rank_home.home_key, RankList),
%             %% Len = length(RankList),
%             #common_rank_home{home_key = HomeKey, value = Value} = CommonRankRole,
%             %% 是否需要排序
%             case Value < LastValue andalso (not IsExistKey) of
%                 true ->
%                     NewRankList2 = RankList,
%                     {NewRankList2, RankLimit};
%                 false ->
%                     %% 内存和数据库存储
%                     NewRankList = lists:keystore(HomeKey, #common_rank_home.home_key, RankList, CommonRankRole),
%                     db_common_rank_home_save(CommonRankRole),
%                     %% 排序
%                     NewRankList2 = sort_home_rank_list(NewRankList),
%                     NewLen = length(NewRankList2),
%                     case NewLen > MaxRankLen of
%                         true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
%                         false -> LeftRankList = []
%                     end,
% %%                    %% 清理冗余数据,这样修改插入数据效率会提高
% %%                    F = fun(#common_rank_guild{guild_id = TmpGuildId}) ->
% %%                        db_common_rank_delete_by_id(RankType, TmpGuildId) end,
% %%                    lists:foreach(F, LeftRankList),
%                     %% 返回数据
%                     LastList = lists:sublist(NewRankList2, MaxRankLen),
%                     case LeftRankList of
%                         [] ->
%                             NewLastValue = LastValue;
%                         _ ->
%                             LastRankGuild = lists:last(LastList),
%                             #common_rank_home{value = TempLastValue} = LastRankGuild,
%                             NewLastValue = max(TempLastValue, LastValue)
%                     end,
%                     NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
%                     {LastList, NewRankLimit}
%             end
%     end;

do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) when RankType == ?RANK_TYPE_JJC->
    #common_rank_role{role_id = RoleId, role_key = RoleKey, value = Value} = CommonRankRole,
    #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
    Temp = maps:get(RankType, RankLimit, Limit),
    LastValue = min(Temp, Limit),
    case RankList == [] of
        true ->
            if
                Value =< LastValue andalso Value > 0 ->
                    db_common_rank_role_save(CommonRankRole),
                    {[CommonRankRole], RankLimit};
                true -> {[], RankLimit}
            end;
        false ->
            %% 是否需要插入数据
            if
                Value > 0 andalso Value < LastValue  ->
                %% 内存和数据库存储
                    NewRankList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList,
                            CommonRankRole#common_rank_role{display_value = Value}),
                    db_common_rank_role_save(CommonRankRole),
                    %% 排序
                    NewRankList2 = sort_rank_list(NewRankList, RankType),
                    NewLen = length(NewRankList2),
                    case NewLen > MaxRankLen of
                        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
                        false -> LeftRankList = []
                    end,
                    %% 清理冗余数据,这样修改插入数据效率会提高
                    F = fun(#common_rank_role{role_id = TmpRoleId}) ->
                        db_common_rank_delete_by_id(RankType, TmpRoleId) end,
                    lists:foreach(F, LeftRankList),
                    %% 返回数据
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            LastRank = lists:last(LastList),
                            #common_rank_role{value = TempLastValue} = LastRank,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
                    if
                        LastList == [] ->
                            skip;
                        true ->
                            send_designation(RankType, RankList, LastList)
                    end,
                    {LastList, NewRankLimit};
                Value == 0 ->
                    NewRankList = lists:keydelete(RoleKey, #common_rank_role.role_key, RankList),
                    NewRankList2 = sort_rank_list(NewRankList, RankType),
                    db_common_rank_delete_by_id(RankType, RoleId),
                    NewLen = length(NewRankList2),
                    case NewLen > MaxRankLen of
                        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
                        false -> LeftRankList = []
                    end,
                    %% 清理冗余数据,这样修改插入数据效率会提高
                    F = fun(#common_rank_role{role_id = TmpRoleId}) ->
                        db_common_rank_delete_by_id(RankType, TmpRoleId) end,
                    lists:foreach(F, LeftRankList),
                    %% 返回数据
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            LastRank = lists:last(LastList),
                            #common_rank_role{value = TempLastValue} = LastRank,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
                    if
                        LastList == [] ->
                            skip;
                        true ->
                            send_designation(RankType, RankList, LastList)
                    end,
                    {LastList, NewRankLimit};
                true ->
                    {RankList, RankLimit}
            end
    end;
do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) when RankType == ?RANK_TYPE_COMBAT
            orelse RankType == ?RANK_TYPE_JUEWEI ->
    #common_rank_role{role_key = RoleKey, value = Value} = CommonRankRole,
    #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
    Temp = maps:get(RankType, RankLimit, Limit),
    LastValue = max(Temp, Limit),
    case RankList == [] of
        true ->
            if
                Value >= LastValue ->
                    db_common_rank_role_save(CommonRankRole),
                    {[CommonRankRole], RankLimit};
                true -> {[], RankLimit}
            end;
        false ->
            IsExistKey = lists:keymember(RoleKey, #common_rank_role.role_key, RankList),
            %% 是否需要插入数据
            case Value < LastValue andalso (not IsExistKey) of
                true -> {RankList, RankLimit};
                false ->
                    NewRankList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList,
                            CommonRankRole#common_rank_role{display_value = Value}),
                    db_common_rank_role_save(CommonRankRole),
                    NewRankList2 = sort_rank_list(NewRankList),
                    NewLen = length(NewRankList2),
                    case NewLen > MaxRankLen of
                        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
                        false -> LeftRankList = []
                    end,
                    %% 清理冗余数据,这样修改插入数据效率会提高
                    F = fun(#common_rank_role{role_id = TmpRoleId}) ->
                        db_common_rank_delete_by_id(RankType, TmpRoleId) end,
                    lists:foreach(F, LeftRankList),
                    %% 返回数据
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            LastRank = lists:last(LastList),
                            #common_rank_role{value = TempLastValue} = LastRank,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    case lists:keyfind(RoleKey, #common_rank_role.role_key, LastList) of
                        false ->
                            skip;
                        #common_rank_role{role_id = RoleId, rank = Rank} ->
                            if
                                RankType == ?RANK_TYPE_COMBAT ->
                                    lib_achievement_api:async_event(RoleId, lib_achievement_api, participate_combat_event, Rank);
                                true ->
                                    skip
                            end
                    end,
                    if
                        LastList == [] ->
                            skip;
                        true ->
                            send_designation(RankType, RankList, LastList)
                    end,
                    NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
                    {LastList, NewRankLimit}
            end
    end;


do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) when RankType == ?RANK_TYPE_AFK ->
    #common_rank_role{role_key = RoleKey, value = Value} = CommonRankRole,
    #rank_config{rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
    db_common_rank_role_save(CommonRankRole),
    case RankList == [] of
        true ->
            ?IF(Value >= Limit, {[CommonRankRole], RankLimit}, {[], RankLimit});
        false ->
            IsExistKey = lists:keymember(RoleKey, #common_rank_role.role_key, RankList),
            case Value < Limit andalso (not IsExistKey) of
                true -> {RankList, RankLimit};
                false ->
                    case lists:keyfind(RoleKey, #common_rank_role.role_key, RankList) of
                        false ->
                            NewRankList = [CommonRankRole | RankList];
                        #common_rank_role{rank = Rank} ->
                            NewRankList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList,
                                CommonRankRole#common_rank_role{rank = Rank, display_value = Value})
                    end,
                    {NewRankList, RankLimit}

            end
    end;
do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) ->
    do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit, true).

%% IsOldValueAffect true|false ，为了取消历史最大值限制
do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit, IsOldValueAffect) ->
    #common_rank_role{role_key = RoleKey, value = Value} = CommonRankRole,
    #rank_config{rank_max = MaxRankLen, rank_limit = Limit} = lib_common_rank:get_rank_config(RankType),
    Temp = maps:get(RankType, RankLimit, Limit),
    LastValue = max(Temp, Limit),
    case RankList == [] of
        true ->
            if
                Value >= LastValue ->
                    db_common_rank_role_save(CommonRankRole),
                    {[CommonRankRole], RankLimit};
                true -> {[], RankLimit}
            end;
        false ->
            IsExistKey = lists:keymember(RoleKey, #common_rank_role.role_key, RankList),
            %% 是否需要插入数据
            case Value < LastValue andalso (not IsExistKey) of
                true -> {RankList, RankLimit};
                false ->
                    %% 内存和数据库存储
                    case lists:keyfind(RoleKey, #common_rank_role.role_key, RankList) of
                        false ->
                            NewRankList = [CommonRankRole#common_rank_role{display_value = Value} | RankList],
                            db_common_rank_role_save(CommonRankRole);
                        #common_rank_role{rank = _Rank, display_value = _DisValue, value = _OldValue}  %% 精灵翅膀不会按历史最高
                            when RankType == ?RANK_TYPE_SPIRIT ->
                            NewRankList = [];
                            % db_common_rank_role_save(CommonRankRole);
                        #common_rank_role{rank = Rank, display_value = _DisValue, value = OldValue} ->
                            case IsOldValueAffect andalso Value =< OldValue of  %% 历史最高
                                true ->
                                    NewRankList = RankList;
                                false ->
                                    NewRankList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList,
                                        CommonRankRole#common_rank_role{rank = Rank, display_value = Value}),
                                    db_common_rank_role_save(CommonRankRole)
                            end
                    end,

                    NewRankList2 = sort_rank_list(NewRankList),
                    NewLen = length(NewRankList2),
                    case NewLen > MaxRankLen of
                        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList2);
                        false -> LeftRankList = []
                    end,
                    %% 清理冗余数据,这样修改插入数据效率会提高
                    F = fun(#common_rank_role{role_id = TmpRoleId}) ->
                        db_common_rank_delete_by_id(RankType, TmpRoleId) end,
                    lists:foreach(F, LeftRankList),
                    %% 返回数据
                    LastList = lists:sublist(NewRankList2, MaxRankLen),
                    case LeftRankList of
                        [] ->
                            NewLastValue = LastValue;
                        _ ->
                            LastRank = lists:last(LastList),
                            #common_rank_role{value = TempLastValue} = LastRank,
                            NewLastValue = max(TempLastValue, LastValue)
                    end,
                    if
                        LastList == [] ->
                            skip;
                        true ->
                            send_designation(RankType, RankList, LastList)
                    end,
                    NewRankLimit = maps:put(RankType, NewLastValue, RankLimit),
                    {LastList, NewRankLimit}



                    % {NewRankList, RankLimit}
            end
    end.

%% 发送榜单列表
send_rank_list(State, RankType, Start, Len, RoleId, GuildId, _SelSecondVal) when RankType == ?RANK_TYPE_GUILD ->
    #common_rank_state{guild_maps = RankMaps, praise_maps = PraiseMaps} = State,
    RankList = maps:get(RankType, RankMaps, []),
    %?PRINT("Guild RankList:~p ~n", [RankList]),
    Sum = length(RankList),
    case Start > Sum orelse Start =< 0 orelse Len =< 0 of
        true ->
            if
                Sum == 0 ->
                    {ok, BinData} = pt_221:write(22102, [RankType, Start, Len, 0, 0, []]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                true -> skip
            end;
        _ ->
            SubRankList = lists:sublist(RankList, Start, Len),
            F = fun(#common_rank_guild{
                guild_id      = TmpGuildId,
                guild_name    = GuildName,
                chairman_id   = ChairmanId,
                chairman_name = ChairmanName,
                lv            = Lv,
                members_num   = MembersNum,
                value         = Value,
                rank          = Rank
            }) ->
                PraiseNum = maps:get(ChairmanId, PraiseMaps, 0),
                case lib_role:get_role_show(ChairmanId) of
                    [] -> Figure = #figure{}, SelCombat = 0;
                    #ets_role_show{figure = Figure, combat_power = SelCombat} -> skip
                end,
                {TmpGuildId, GuildName, ChairmanId, ChairmanName, PraiseNum, Lv, MembersNum, Figure, SelCombat, Value, Rank}
                end,
            SendList = lists:map(F, SubRankList),
            % ?PRINT("~n M:~p L:~p guild RankType:~p List:~p ~n", [?MODULE, ?LINE, RankType, List]),
            case lists:keyfind({RankType, GuildId}, #common_rank_guild.guild_key, RankList) of
                #common_rank_guild{rank = GuildRank} ->
                    skip;
                _ ->
                    GuildRank = 0
            end,
%%            ?PRINT("RankType:~p, GuildRank:~p, Sum:~p, SendList:~p ~n", [RankType, GuildRank, Sum, SendList]),
            {ok, BinData} = pt_221:write(22102, [RankType, Start, Len, GuildRank, Sum, SendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end;

% send_rank_list(State, RankType, Start, Len, RoleId, HomeId, SelSecondVal) when RankType =:= ?RANK_TYPE_HOME ->
%     %?PRINT("RankList:~p ~n", [RankType]),
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps, praise_maps = PraiseMaps} = State,
%     %?PRINT("~p~n", [RankMaps]),
%     RoleList = maps:get(RankType, RoleMaps, []),
%     TmpRankL = maps:get(RankType, RankMaps, []),
%     RankList = [RankRole || RankRole <- TmpRankL, RankRole#common_rank_home.rank =/= 0],
%     case lists:keyfind(HomeId, #common_rank_home.home_key, RoleList) of
%         #common_rank_home{value = SelValue} -> skip;
%         _ -> SelValue = 0
%     end,
%     Sum = length(RankList),
%     %?PRINT("~p~n", [Sum]),
%     case Start > Sum orelse Start =< 0 orelse Len =< 0 of
%         true ->
%             if
%                 Sum == 0 ->
%                     lib_server_send:send_to_uid(RoleId, pt_221, 22101, [RankType, 0, SelValue, SelSecondVal, 0, []]);
%                 true -> skip
%             end;
%         _ ->
%             SubRankList = lists:sublist(RankList, Start, Len),
%             F = fun(#common_rank_home{role_id_1 = RoleId1, role_id_2 = RoleId2, value = Value, rank = Rank}) ->
%                 case lib_role:get_role_show(RoleId1) of
%                     [] -> TmpFigure1 = #figure{}, SelCombat = 0;
%                     #ets_role_show{figure = TmpFigure1, combat_power = SelCombat} -> skip
%                 end,
%                 case lib_role:get_role_show(RoleId2) of
%                     [] -> TmpFigure2 = #figure{};
%                     #ets_role_show{figure = TmpFigure2} -> skip
%                 end,
%                 Figure = TmpFigure1#figure{name = util:link_list([TmpFigure1#figure.name, TmpFigure2#figure.name], ulists:thing_to_list(ulists:list_to_bin(",")))},
%                 PraiseNum = maps:get(RoleId1, PraiseMaps, 0),
%                 {RoleId1, PraiseNum, Figure, SelCombat, Value, 0, 0, Rank}
%                 end,
%             case lists:keyfind(HomeId, #common_rank_home.home_key, RankList) of
%                 #common_rank_home{rank = RoleRank} -> skip;
%                 _ -> RoleRank = 0
%             end,
%             SendList = lists:map(F, SubRankList),
%             %?PRINT("~p~n", [SendList]),
%             {ok, BinData} = pt_221:write(22101, [RankType, RoleRank, SelValue, SelSecondVal, Sum, SendList]),
%             lib_server_send:send_to_uid(RoleId, BinData)
%     end;

% %% 魅力周榜整合
% send_rank_list(State, RankType, Start, Len, RoleId, _SelValue, SelSecondVal) when RankType =:= ?RANK_TYPE_CHARM ->
%     %?PRINT("RankList:~p ~n", [RankType]),
%     #common_rank_state{value_maps = RoleMaps, role_maps = RankMaps, praise_maps = PraiseMaps} = State,
%     ManRankL = maps:get(?RANK_TYPE_CHARM_BOY, RankMaps, []),
%     GirlRankL = maps:get(?RANK_TYPE_CHARM_GIRL, RankMaps, []),
%     ManRoleL = maps:get(?RANK_TYPE_CHARM_BOY, RoleMaps, []),
%     GirlRoleL = maps:get(?RANK_TYPE_CHARM_GIRL, RoleMaps, []),
%     case lists:keyfind(RoleId, #common_rank_role.role_id, ManRoleL ++ GirlRoleL) of
%         #common_rank_role{value = SelValue} -> skip;
%         _ -> SelValue = 0
%     end,
%     RankList = sort_display_list(ManRankL ++ GirlRankL),
%     Sum = length(RankList),
%     case Start > Sum orelse Start =< 0 orelse Len =< 0 of
%         true ->
%             if
%                 Sum == 0 ->
%                     lib_server_send:send_to_uid(RoleId, pt_221, 22101, [RankType, 0, SelValue, SelSecondVal, 0, []]);
%                 true -> skip
%             end;
%         _ ->
%             SubRankList = lists:sublist(RankList, Start, Len),
%             F = fun(#common_rank_role{role_id = TmpRoleId, display_value = Value, second_value = SecondValue, third_value = ThirdValue, rank = Rank}) ->
%                 case lib_role:get_role_show(TmpRoleId) of
%                     [] -> Figure = #figure{}, SelCombat = 0;
%                     #ets_role_show{figure = Figure, combat_power = SelCombat} -> skip
%                 end,
%                 PraiseNum = maps:get(TmpRoleId, PraiseMaps, 0),
%                 %?PRINT("~p~n", [Value]),
%                 {TmpRoleId, PraiseNum, Figure, SelCombat, Value, SecondValue, ThirdValue, Rank}
%                 end,
%             SendList = lists:map(F, SubRankList),
%             case lists:keyfind(RoleId, #common_rank_role.role_id, RankList) of
%                 #common_rank_role{rank = RoleRank, display_value = LastSelValue} -> skip;
%                 _ -> RoleRank = 0, LastSelValue = SelValue
%             end,
%             {ok, BinData} = pt_221:write(22101, [RankType, RoleRank, LastSelValue, SelSecondVal, Sum, SendList]),
%             lib_server_send:send_to_uid(RoleId, BinData)
%     end;

%% -----------------------------------------------------------------
%% @desc 发送榜单信息
%% @param State  通用榜单的进程记录
%% @param RankType  榜单类型
%% @param Start  开始排名
%% @param Len  榜单长度
%% @param SelValue  请求者的值
%% @param SelSecondVal
%% @return
%% -----------------------------------------------------------------
send_rank_list(State, RankType, Start, Len, RoleId, SelValue, SelSecondVal) ->
    #common_rank_state{value_maps = _RoleMaps, role_maps = RankMaps, praise_maps = PraiseMaps} = State,
    TmpRankL = maps:get(RankType, RankMaps, []),
    RankList = [RankRole || RankRole <- TmpRankL, RankRole#common_rank_role.rank =/= 0],
    #common_rank_role{rank = RoleRank, display_value = NewSelValue} = ulists:keyfind({RankType, RoleId},
        #common_rank_role.role_key, RankList, #common_rank_role{display_value = SelValue}),
    Sum = length(RankList),
    %% 请求多少封装多少
    F1 = fun(N, Result) -> {ok, Result ++ [{0, 0, #figure{}, 0, 0, 0, 0, N}]} end,
    if
        Start =< 0 orelse Len =< 0 -> skip;
        Start > Sum ->
            {ok, SendList} = util:for(Start, Start+Len-1, F1, []),
            lib_server_send:send_to_uid(RoleId, pt_221, 22101, [RankType, Start, Len, RoleRank, SelValue, SelSecondVal, Len, SendList]);
        true ->
            SubRankList = lists:sublist(RankList, Start, Len),
            F = fun(#common_rank_role{role_id = TmpRoleId, display_value = Value, second_value = SecondValue, third_value = ThirdValue, rank = Rank}) ->
                case lib_role:get_role_show(TmpRoleId) of
                    [] -> Figure = #figure{}, SelCombat = 0;
                    #ets_role_show{figure = Figure, combat_power = SelCombat} -> skip
                end,
                PraiseNum = maps:get(TmpRoleId, PraiseMaps, 0),
                case RankType of
                    ?RANK_TYPE_MOUNT ->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_FLYPET->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_WING  ->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_MATE  ->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_SPIRIT->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_AIRCRAFT->
                        SpecFigureId = ThirdValue;
                    ?RANK_TYPE_HOLYORGAN->
                        SpecFigureId = ThirdValue;
                    _ -> SpecFigureId = 0
                end,
                {TmpRoleId, PraiseNum, Figure, SelCombat, Value, SecondValue, SpecFigureId, Rank}
                end,
            SendList = lists:map(F, SubRankList),
            {ok, OtherSendList} = util:for(Start+Sum, Start+Len-1, F1, []),
            {ok, BinData} = pt_221:write(22101, [RankType, Start, Len, RoleRank, NewSelValue, SelSecondVal, Len, SendList ++ OtherSendList]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

% timer_common_rank(RankType, State) when RankType == ?RANK_TYPE_GUILD ->
%     #common_rank_state{guild_maps = RankMaps, rank_limit = RankLimit, old_first_guild = OldGuildId} = State,
%     #rank_config{rank_max = MaxRankLen} = lib_common_rank:get_rank_config(RankType),
%     RankList = maps:get(RankType, RankMaps, []),
%     NewRankList = sort_rank_list(RankList),
%     NewLen = length(NewRankList),
%     case NewLen > MaxRankLen of
%         true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList);
%         false -> LeftRankList = []
%     end,
%     %% 清理冗余数据,这样修改插入数据效率会提高
%     F = fun(#common_rank_guild{guild_id = TmpGuildId}) -> db_common_rank_delete_by_id(RankType, TmpGuildId) end,
%     lists:foreach(F, LeftRankList),
%     %% 返回数据
%     NewRankList2 = lists:sublist(NewRankList, MaxRankLen),
%     case NewRankList2 of
%         [] ->
%             #rank_config{rank_limit = Value} = lib_common_rank:get_rank_config(RankType);
%         _ ->
%             LastRankGuild = lists:last(NewRankList2),
%             #common_rank_guild{value = Value} = LastRankGuild
%     end,
%     NewLimitMaps = maps:put(RankType, Value, RankLimit),
%     NewRankMaps = maps:put(RankType, NewRankList2, RankMaps),
%     %%日志
%     NewGuildId = do_log_guild(NewRankMaps, OldGuildId),
%     NewState = State#common_rank_state{guild_maps = NewRankMaps, rank_limit = NewLimitMaps, old_first_guild = NewGuildId},
%     {ok, NewState};
%% 定时排序 称号
timer_common_rank(RankType, State) ->
    #common_rank_state{role_maps = RankMaps,
                       rank_limit = LimitMaps} = State,
    #rank_config{rank_max = MaxRankLen, rank_limit = CfgLimit} = lib_common_rank:get_rank_config(RankType),
    RankList = maps:get(RankType, RankMaps, []),
    NewRankList = case RankType == ?RANK_TYPE_JJC orelse RankType == ?RANK_TYPE_JUEWEI of
        false ->
            sort_rank_list(RankList);
        true ->
            sort_rank_list(RankList, RankType)
    end,
    % NewRankList = sort_rank_list(RankList),
    % ?PRINT("RankType:~p ,NewRankList:~p~n",[RankType,NewRankList]),
    case length(NewRankList) > MaxRankLen andalso MaxRankLen =/= 0 of
        true -> LeftRankList = lists:nthtail(MaxRankLen, NewRankList);
        false -> LeftRankList = []
    end,
    %% 清理冗余数据,这样修改插入数据效率会提高
    % spawn(fun() -> [db_common_rank_delete_by_id(RankType, TmpRoleId) || #common_rank_role{rank_type = TmpType, role_id = TmpRoleId} <- LeftRankList
        %,TmpType =/= ?RANK_TYPE_CHARM_BOY andalso TmpType =/= ?RANK_TYPE_CHARM_GIRL] end),
    case RankType of
        ?RANK_TYPE_AFK ->   %% 挂机排行榜特殊处理下
            DeleteIds = [TmpRoleId||#common_rank_role{role_id = TmpRoleId} <- LeftRankList],
            case DeleteIds of
                [] -> skip;
                _ ->
                    Sql1 = list_to_binary("delete from `common_rank_role` " ++ usql:condition({player_id, in, DeleteIds}) ++ " and `rank_type` = ~p"),
                    Sql = io_lib:format(Sql1, [RankType]),
                    db:execute(Sql)
            end;
        _ ->
            spawn(fun() -> [db_common_rank_delete_by_id(RankType, TmpRoleId) || #common_rank_role{role_id = TmpRoleId} <- LeftRankList
            ] end)
    end,
    %% 返回数据
    TmpList = lists:sublist(NewRankList, MaxRankLen),
    LastList = [RankRole#common_rank_role{display_value = RankRole#common_rank_role.value} || RankRole <- TmpList],
    %%激活称号 (除了公会）
    case LastList of
        [] -> skip;
        _ ->
            if
                RankType =/= ?RANK_TYPE_GUILD andalso RankType =/= ?RANK_TYPE_COMBAT andalso RankType =/= ?RANK_TYPE_JUEWEI-> %%战力榜实时刷新称号不在这里激活
                    send_designation(RankType, RankList, LastList);
                true -> skip
            end
    end,
    case LeftRankList of
        [] -> NewLastValue = CfgLimit;
        _ ->
            LastRankRole = lists:last(LastList),
            #common_rank_role{value = NewLastValue} = LastRankRole
    end,
    NewLimitMaps = maps:put(RankType, max(CfgLimit, NewLastValue), LimitMaps),
    NewRankMaps = maps:put(RankType, LastList, RankMaps),
    NewState = State#common_rank_state{role_maps = NewRankMaps, rank_limit = NewLimitMaps},
    {ok, NewState}.

%% 每天定时结算奖励
day_clear(DelaySec, State) ->
    #common_rank_state{
        role_maps       = RankMaps
        % guild_maps      = GuildMaps,
        % old_first_guild = OldGuildId
        % home_rank_maps  = HomeRankMaps
    } = State,
    % %%公会榜  公会榜已被剥离！！
    % case lib_common_rank:get_title_id(?RANK_TYPE_GUILD) of
    %     0 ->
    %         % ?ERR("guild rank can not find title id!~n", []),
    %         NewGuildId = OldGuildId;
    %     GuildDstId ->
    %         case maps:get(?RANK_TYPE_GUILD, GuildMaps, []) of
    %             [] -> NewGuildId = 0;
    %             [No1CommonRankGuild | TmpList] ->
    %                 #common_rank_guild{guild_id = NewGuildId, guild_name = No1GuildName, value = No1GuildValue} = No1CommonRankGuild,
    %                 lib_chat:send_TV({all}, ?MOD_RANK, 2, [No1GuildName, GuildDstId]),
    %                 case TmpList of
    %                     [] -> lib_log_api:log_common_rank_guild(NewGuildId, 1, No1GuildValue, 0, 0);
    %                     [No2CommonRankGuild | _] ->
    %                         #common_rank_guild{guild_id = No2GuildId, value = No2GuildValue} = No2CommonRankGuild,
    %                         lib_log_api:log_common_rank_guild(NewGuildId, 1, No1GuildValue, No2GuildId, No2GuildValue)
    %                 end
    %         end,
    %         spawn(fun() ->
    %             util:multiserver_delay(DelaySec, mod_guild, send_guild_rank_reward, [OldGuildId, NewGuildId, GuildDstId])
    %               end)
    % end,
    %% 进阶榜：
    spawn(fun() ->
        util:multiserver_delay(DelaySec, lib_common_rank_mod, send_advanced_reward, [RankMaps])
          end),
    % %% 魅力周榜
    % case is_send_charm_reward() of
    %     true ->
    %         spawn(fun() ->
    %             util:multiserver_delay(DelaySec, lib_common_rank_mod, send_charm_reward, [RankMaps])
    %               end),
    %         TmpState = clear_charm_week_data(State);
    %     false -> TmpState = State
    % end,
    % %% 家园人气周榜
    % case is_send_home_reward() of
    %     true ->
    %         spawn(fun() ->
    %             util:multiserver_delay(DelaySec, lib_common_rank_mod, send_home_reward, [HomeRankMaps])
    %               end),
    %         TmpState2 = clear_home_week_data(TmpState);
    %     false -> TmpState2 = State
    % end,
    % % 更新state
    % NewState = TmpState2#common_rank_state{old_first_guild = NewGuildId},
    % NewState = State#common_rank_state{old_first_guild = NewGuildId},
    {ok, State}.

%% 转性别后更新性别相关榜单
change_rank_by_type(State, RoleId, OldType, RankType) ->
    #common_rank_state{value_maps = RoleMaps, role_maps = RankMaps} = State,
    DelRoleL = maps:get(OldType, RoleMaps, []),
    AddRoleL = maps:get(RankType, RoleMaps, []),
    DelRankL = maps:get(OldType, RankMaps, []),
    AddRankL = maps:get(RankType, RankMaps, []),
    case lists:keyfind({OldType, RoleId}, #common_rank_role.role_key, DelRoleL) of
        false -> NewDelRoleL = DelRoleL, NewAddRoleL = AddRoleL;
        DelRole ->
            NewDelRoleL = lists:keydelete({OldType, RoleId}, #common_rank_role.role_key, DelRoleL),
            db_common_rank_delete_by_id(OldType, RoleId),
            NewAddRoleL = lists:keystore({RankType, RoleId}, #common_rank_role.role_key, AddRoleL,
                DelRole#common_rank_role{role_key = {RankType, RoleId}, rank_type = RankType}),
            db_common_rank_role_save(DelRole#common_rank_role{rank_type = RankType})
    end,
    case lists:keyfind({OldType, RoleId}, #common_rank_role.role_key, DelRankL) of
        false -> NewDelRankL = DelRankL, NewAddRankL = AddRankL;
        DelRankRole ->
            TmpDelRankL = lists:keydelete({OldType, RoleId}, #common_rank_role.role_key, DelRankL),
            TmpAddRankL = lists:keystore({RankType, RoleId}, #common_rank_role.role_key, AddRankL,
            DelRankRole#common_rank_role{role_key = {RankType, RoleId}, rank_type = RankType, rank = 0}),
            case RankType =/= ?RANK_TYPE_JJC andalso RankType =/= ?RANK_TYPE_JUEWEI of
                true ->
                    SortDelRankL = sort_rank_list(TmpDelRankL),
                    SortAddRankL = sort_rank_list(TmpAddRankL);
                false ->
                    SortDelRankL = sort_rank_list(TmpDelRankL, RankType),
                    SortAddRankL = sort_rank_list(TmpAddRankL, RankType)
            end,
            % SortDelRankL = sort_rank_list(TmpDelRankL),
            % SortAddRankL = sort_rank_list(TmpAddRankL),
            % 同步显示值
            NewDelRankL = [TmpRole#common_rank_role{display_value = TmpRole#common_rank_role.value} || TmpRole <- SortDelRankL],
            NewAddRankL = [TmpRole#common_rank_role{display_value = TmpRole#common_rank_role.value} || TmpRole <- SortAddRankL]
    end,
    NewRoleMaps1 = maps:put(OldType, NewDelRoleL, RoleMaps),
    NewRoleMaps2 = maps:put(RankType, NewAddRoleL, NewRoleMaps1),
    NewRankMaps1 = maps:put(OldType, NewDelRankL, RankMaps),
    NewRankMaps2 = maps:put(RankType, NewAddRankL, NewRankMaps1),
    {ok, State#common_rank_state{value_maps = NewRoleMaps2, role_maps = NewRankMaps2}}.

apply_cast(State, M, F, A) ->
    M:F(State, A).

to_be_strong_info(State, SelId, SelFigure, SelCombat) ->
    #common_rank_state{role_maps = RankMaps} = State,
    case RankList = maps:get(?RANK_TYPE_COMBAT, RankMaps, []) of
        [] ->
            lib_server_send:send_to_uid(SelId, pt_221, 22105, [SelId, SelFigure, SelCombat]);
        _ ->
            case lists:keyfind(SelId, #common_rank_role.role_id, RankList) of
                #common_rank_role{rank = 1} ->
                    Combat = SelCombat, RoleId = SelId;
                #common_rank_role{rank = Rank} ->
                    case lists:keyfind(Rank - 1, #common_rank_role.rank, RankList) of
                        #common_rank_role{display_value = Combat, role_id = RoleId} -> skip;
                        _ -> Combat = SelCombat, RoleId = SelId
                    end;
                _ ->
                    #common_rank_role{display_value = Combat, role_id = RoleId} = lists:last(RankList)
            end,
            case lib_role:get_role_show(RoleId) of
                [] -> Figure = #figure{};
                #ets_role_show{figure = Figure} -> skip
            end,
            lib_server_send:send_to_uid(SelId, pt_221, 22105, [RoleId, Figure, Combat])
    end,
    {ok, State}.


%%------------------------inside fun-------------------%%

%% 发送进阶榜称号
send_advanced_reward(RankMaps) ->
    OpenLv = lib_module:get_open_lv(?MOD_RANK, 1),
    F = fun(RankType) ->
        DstId = lib_common_rank:get_title_id(RankType),
        RankList = maps:get(RankType, RankMaps, []),
        %IsSendCharm = is_send_charm_reward(),
        if
            DstId == 0 orelse RankList == [] -> skip;
            true ->
                case lists:keyfind(1, #common_rank_role.rank, RankList) of
                    #common_rank_role{role_id = No1RoleId, value = No1Value} ->
                        case lib_role:get_role_show(No1RoleId) of
                            [] -> ?ERR("common rank can not find the role info:~p~n", [[No1RoleId, RankType]]), skip;
                            #ets_role_show{figure = #figure{name = Name, lv = RoleLv}} when RoleLv >= OpenLv ->
                                lib_designation_api:active_dsgt_common(No1RoleId, DstId),
                                RankName = lib_common_rank:get_rank_type_name(RankType),
                                TitleName = lib_common_rank:get_title_name(RankType),
                                lib_chat:send_TV({all}, ?MOD_RANK, 1, [Name, RankName, TitleName]),
                                %% 日志
                                case lists:keyfind(2, #common_rank_role.rank, RankList) of
                                    false -> lib_log_api:log_common_rank_role(No1RoleId, RankType, 1, No1Value, 0, 0);
                                    #common_rank_role{role_id = No2RoleId, value = No2Value} ->
                                        lib_log_api:log_common_rank_role(No1RoleId, RankType, 1, No1Value, No2RoleId, No2Value)
                                end;
                            _ -> skip
                        end;
                    false -> ?ERR("ranklist not sort.~n", []), skip
                end
        end
        end,
    [F(X) || X <- ?RANK_TYPE_ADVANCED].

% is_send_charm_reward() ->
%     WeekDay = utime:day_of_week(),
%     OpenDay = util:get_open_day(),
%     MergeDay = util:get_merge_day(),
%     if
%         WeekDay =/= 1 -> false;
%         OpenDay =< 1 + 7 - 4 + 1 -> false;       %% 开服或合服时间 在周四或之后的话 下周不结算 下下周才结算
%         MergeDay =< 1 + 7 - 4 + 1 andalso MergeDay =/= 0 -> false;
%         true -> true
%     end.

% is_send_home_reward() ->
%     WeekDay = utime:day_of_week(),
%     OpenDay = util:get_open_day(),
%     MergeDay = util:get_merge_day(),
%     if
%         WeekDay =/= 1 -> false;
%         OpenDay =< 1 + 7 - 4 + 1 -> false;       %% 开服或合服时间 在周四或之后的话 下周不结算 下下周才结算
%         MergeDay =< 1 + 7 - 4 + 1 andalso MergeDay =/= 0 -> false;
%         true -> true
%     end.

% %% 发送魅力周榜奖励
% send_charm_reward(RankMaps) ->
%     %% 魅力榜合并处理
%     %% 称号
%     OpenLv = lib_module:get_open_lv(?MOD_RANK, 1),
%     ManRankL = maps:get(?RANK_TYPE_CHARM_BOY, RankMaps, []),
%     GirlRankL = maps:get(?RANK_TYPE_CHARM_GIRL, RankMaps, []),
%     RankList = sort_display_list(ManRankL ++ GirlRankL),
%     %RankList = [RankRole || RankRole <- TmpList, RankRole#common_rank_role.rank =/= 0],
%     case lists:keyfind(1, #common_rank_role.rank, RankList) of
%         #common_rank_role{role_id = No1RoleId, value = No1Value} ->
%             case lib_role:get_role_show(No1RoleId) of
%                 [] -> ?ERR("common rank can not find the role info:~p~n", [[No1RoleId]]), skip;
%                 #ets_role_show{figure = #figure{name = Name, lv = RoleLv, sex = Sex}} when RoleLv >= OpenLv ->
%                     case Sex of
%                         ?MALE ->
%                             RankType = ?RANK_TYPE_CHARM_BOY;
%                         ?FEMALE ->
%                             RankType = ?RANK_TYPE_CHARM_GIRL
%                     end,
%                     DstId = lib_common_rank:get_title_id(RankType),
%                     lib_designation_api:active_dsgt_common(No1RoleId, DstId),
%                     RankName = lib_common_rank:get_rank_type_name(?RANK_TYPE_CHARM),
%                     TitleName = lib_common_rank:get_title_name(RankType),
%                     lib_chat:send_TV({all}, ?MOD_RANK, 1, [Name, RankName, TitleName]),
%                     %% 日志
%                     case lists:keyfind(2, #common_rank_role.rank, RankList) of
%                         false -> lib_log_api:log_common_rank_role(No1RoleId, ?RANK_TYPE_CHARM, 1, No1Value, 0, 0);
%                         #common_rank_role{role_id = No2RoleId, value = No2Value} ->
%                             lib_log_api:log_common_rank_role(No1RoleId, ?RANK_TYPE_CHARM, 1, No1Value, No2RoleId, No2Value)
%                     end;
%                 _ -> skip
%             end;
%         false -> ?ERR("ranklist not sort.~n", []), skip
%     end,
%     %% 名誉奖励
%     [do_send_charm_reward_help(RankRole) || RankRole <- RankList].


% do_send_charm_reward_help(#common_rank_role{role_id = RoleId, rank = Rank}) ->
%     {RoleReward, ExReward} = lib_common_rank:get_charm_week_reward(Rank),
%     case RoleReward of
%         [] -> skip;
%         _ ->

%             Title = utext:get(2210001), Content = uio:format(?LAN_MSG(2210002), [Rank]),
%             %% 个人奖励
%             lib_mail_api:send_sys_mail([RoleId], Title, Content, RoleReward),
%             %% 额外奖励
%             case ExReward of
%                 [] -> skip;
%                 _ ->
%                     case lib_role:get_role_show(RoleId) of
%                         #ets_role_show{figure = #figure{name = Name}} -> skip;
%                         _ -> Name = ""
%                     end,
%                     mod_guild:send_guild_mail_by_role_id(RoleId, utext:get(2210005), uio:format(?LAN_MSG(2210006), [Name, Rank]), ExReward, [])
%             end
%     end.

% %% 家园奖励
% send_home_reward(RankMaps) ->
%     do_send_home_reward(?RANK_TYPE_HOME, RankMaps).

% do_send_home_reward(RankType, RankMaps) ->
%     TmpList = maps:get(RankType, RankMaps, []),
%     %%?PRINT("~p~n", [TmpList]),
%     RankList = [RankRole || RankRole <- TmpList, RankRole#common_rank_home.rank =/= 0],
%     if
%         RankList == [] -> skip;
%         true ->
%             [do_send_home_reward_help(RankType, RankRole) || RankRole <- RankList]
%     end.

% do_send_home_reward_help(RankType, #common_rank_home{role_id_1 = RoleId1, role_id_2 = RoleId2, rank = Rank, value = Value}) ->
%     RoleReward = lib_common_rank:get_home_week_reward(Rank),
%     case RoleReward of
%         [] -> skip;
%         _ ->
%             Title = utext:get(2210007), Content = uio:format(?LAN_MSG(2210008), [Rank]),
%             %% 个人奖励
%             lib_mail_api:send_sys_mail([RoleId1, RoleId2], Title, Content, RoleReward),
%             lib_log_api:log_common_rank_role(RoleId1, RankType, Rank, Value, RoleId2, Value)
%     end.

% clear_charm_week_data(State) ->
%     #common_rank_state{value_maps = RoleMaps, role_maps = RankMaps, rank_limit = LimMaps} = State,
%     NewRankMaps0 = maps:remove(?RANK_TYPE_CHARM_BOY, RankMaps),
%     NewRankMaps = maps:remove(?RANK_TYPE_CHARM_GIRL, NewRankMaps0),
%     NewRoleMaps0 = maps:remove(?RANK_TYPE_CHARM_BOY, RoleMaps),
%     NewRoleMaps = maps:remove(?RANK_TYPE_CHARM_GIRL, NewRoleMaps0),
%     NewLimMaps0 = maps:remove(?RANK_TYPE_CHARM_BOY, LimMaps),
%     NewLimMaps = maps:remove(?RANK_TYPE_CHARM_GIRL, NewLimMaps0),
%     db:execute(io_lib:format(?sql_common_rank_role_delete_by_rank_type, [?RANK_TYPE_CHARM_BOY, ?RANK_TYPE_CHARM_GIRL])),
%     State#common_rank_state{value_maps = NewRoleMaps, role_maps = NewRankMaps, rank_limit = NewLimMaps}.

% clear_home_week_data(State) ->
%     #common_rank_state{home_value_maps = RoleMaps, home_rank_maps = RankMaps, rank_limit = LimMaps} = State,
%     NewRankMaps = maps:remove(?RANK_TYPE_HOME, RankMaps),
%     NewRoleMaps = maps:remove(?RANK_TYPE_HOME, RoleMaps),
%     NewLimMaps = maps:remove(?RANK_TYPE_HOME, LimMaps),
%     db:execute(io_lib:format(?sql_common_rank_home_delete_by_rank_type, [?RANK_TYPE_HOME])),
%     State#common_rank_state{home_value_maps = NewRoleMaps, home_rank_maps = NewRankMaps, rank_limit = NewLimMaps}.

%% 点赞
rank_praise(State, RoleId, OtRoleId) ->
    %?PRINT("~p,~p~n", [RoleId, OtRoleId]),
    #common_rank_state{praise_maps = PraiseMaps} = State,
    OldNum = maps:get(OtRoleId, PraiseMaps, 0),
    %?PRINT("OldNum:~p,RoleId:~p, OtRoleId:~p~n",[OldNum, RoleId, OtRoleId]),
    NewNum = OldNum + 1,
    NewMaps = maps:put(OtRoleId, NewNum, PraiseMaps),
    NewState = State#common_rank_state{praise_maps = NewMaps},
    db_common_rank_praise_save(OtRoleId, NewNum),
    {ok, BinData} = pt_221:write(22104, [?SUCCESS, NewNum]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewState}.

send_designation(RankType, RankList, NewList) ->
    [No1CommonRR | TmpLastList] = NewList, % 新的首位
    #common_rank_role{role_id = No1RoleId, value = No1Value} = No1CommonRR,
    case lists:keyfind(1, #common_rank_role.rank, RankList) of
        #common_rank_role{role_id = No1RoleId} ->
            skip;  % 首位没更改
        _ ->
            case lib_common_rank:get_title_id(RankType) of
                0 -> skip;
                _ ->
                    lib_designation_api:active_dsgt_common(No1RoleId, lib_common_rank:get_title_id(RankType)),
                    lib_chat:send_TV({all}, ?MOD_RANK, 1,
                        [lib_common_rank:get_id_name(No1RoleId), lib_common_rank:get_rank_type_name(RankType), lib_common_rank:get_title_name(RankType)])
            end,
            case TmpLastList of
                [] ->
                    lib_log_api:log_common_rank_role(No1RoleId, RankType, 1, No1Value, 0, 0);
                _ ->
                    [#common_rank_role{role_id = No2RoleId, value = No2Value} | _] = TmpLastList,
                    lib_log_api:log_common_rank_role(No1RoleId, RankType, 1, No1Value, No2RoleId, No2Value)
            end
    end.
do_log_guild(GuildMaps, OldGuildId)->
    case maps:get(?RANK_TYPE_GUILD, GuildMaps, []) of
        [] -> NewGuildId = 0;
        [No1CommonRankGuild | TmpList] ->
            #common_rank_guild{guild_id = NewGuildId, guild_name = No1GuildName, value = No1GuildValue} = No1CommonRankGuild,
            if
                NewGuildId =/= OldGuildId ->
                    case lib_common_rank:get_title_id(?RANK_TYPE_GUILD) of
                        0 -> skip;
                        GuildDstId ->
                            lib_chat:send_TV({all}, ?MOD_RANK, 2, [No1GuildName, GuildDstId])
                    end,
                    case TmpList of
                        [] ->
                            lib_log_api:log_common_rank_guild(NewGuildId, 1, No1GuildValue, 0, 0);
                        [No2CommonRankGuild | _] ->
                            #common_rank_guild{guild_id = No2GuildId, value = No2GuildValue} = No2CommonRankGuild,
                            %?PRINT("NewGuildId:~p, No1GuildValue:~p ,No2GuildValue:~p~n",[NewGuildId,No1GuildValue,No2GuildValue]),
                            lib_log_api:log_common_rank_guild(NewGuildId, 1, No1GuildValue, No2GuildId, No2GuildValue)
                    end;
                true ->
                    skip
            end
    end,
    NewGuildId.

get_all_combat(State, RankType, Start, Len) ->
    #common_rank_state{role_maps = RankMaps} = State,
    TmpRankL = maps:get(RankType, RankMaps, []),
    RankList = [RankRole || RankRole <- TmpRankL, RankRole#common_rank_role.rank =/= 0],
    Sum = length(RankList),
    Combat = case Start > Sum orelse Start =< 0 orelse Len =< 0 of
        true ->
            if
                Sum == 0 -> 0;
                true -> ?ERR("Wrong Arg : Start:~p, Len:~p~n",[Start, Len]), 0
            end;
        _ ->
           SubRankList = lists:sublist(RankList, Start, Len),
            F = fun(#common_rank_role{display_value = Value}, Acc) ->
                Value + Acc
            end,
            SumCombat = lists:foldl(F, 0, SubRankList),
            SumCombat
    end,
    Combat.

%%-----------------------db------------------------------%%
db_common_rank_role_select() ->
    Sql = io_lib:format(?sql_common_rank_role_select, []),
    db:get_all(Sql).

db_common_rank_guild_select() ->
    Sql = io_lib:format(?sql_common_rank_guild_select, []),
    db:get_all(Sql).

db_common_rank_home_select() ->
    Sql = io_lib:format(?sql_common_rank_home_select, []),
    db:get_all(Sql).

db_common_rank_praise_select() ->
    Sql = io_lib:format(?sql_common_rank_praise_select, []),
    db:get_all(Sql).

db_common_rank_guild_save(RankRole) ->
    #common_rank_guild{
        rank_type     = RankType,
        guild_id      = GuildId,
        guild_name    = GuildName,
        chairman_id   = ChairmanId,
        chairman_name = ChairmanName,
        lv            = Lv,
        members_num   = MembersNum,
        value         = Value,
        second_value  = SecondValue,
        third_value   = ThirdValue,
        time          = Time
    } = RankRole,
    GuildName_B = util:make_sure_binary(GuildName),
    ChairmanName_B = util:make_sure_binary(ChairmanName),
    Sql = io_lib:format(?sql_common_rank_guild_save,
        [RankType, GuildId, GuildName_B, ChairmanId, ChairmanName_B, Lv, MembersNum, Value, SecondValue, ThirdValue, Time]),
    db:execute(Sql).

db_common_rank_role_save(RankRole) ->
    #common_rank_role{
        rank_type    = RankType,
        role_id      = RoleId,
        value        = Value,
        second_value = SecondValue,
        third_value  = ThirdValue,
        time         = Time
    } = RankRole,
    Sql = io_lib:format(?sql_common_rank_role_save,
        [RankType, RoleId, Value, SecondValue, ThirdValue, Time]),
    db:execute(Sql).

db_common_rank_home_save(RankRole) ->
    #common_rank_home{
        rank_type    = RankType,
        block_id     = BlockId,
        house_id     = HouseId,
        role_id_1    = RoleId1,
        role_id_2    = RoleId2,
        lock         = Lock,
        value        = Value,
        second_value = SecondValue,
        third_value  = ThirdValue,
        time         = Time
    } = RankRole,
    Sql = io_lib:format(?sql_common_rank_home_save,
        [RankType, BlockId, HouseId, RoleId1, RoleId2, Lock, Value, SecondValue, ThirdValue, Time]),
    db:execute(Sql).

db_common_rank_praise_save(RoleId, Num) ->
    Sql = io_lib:format(?sql_common_rank_praise_save,
        [RoleId, Num]),
    db:execute(Sql).

% db_common_rank_delete_by_id(RankType, BlockId, HouseId) when RankType == ?RANK_TYPE_HOME ->
%     Sql = io_lib:format(?sql_common_rank_home_delete, [RankType, BlockId, HouseId]),
%     db:execute(Sql).
db_common_rank_delete_by_id(RankType, GuildId) when RankType == ?RANK_TYPE_GUILD ->
    Sql = io_lib:format(?sql_common_rank_guild_delete_by_guild_id, [RankType, GuildId]),
    db:execute(Sql);
db_common_rank_delete_by_id(RankType, RoleId) ->
    Sql = io_lib:format(?sql_common_rank_role_delete_by_role_id, [RankType, RoleId]),
    db:execute(Sql).


db_common_rank_delete_by_value(RankType, Value) when RankType == ?RANK_TYPE_GUILD ->
    Sql = io_lib:format(?sql_common_rank_guild_delete_by_value, [RankType, Value]),
    db:execute(Sql);
db_common_rank_delete_by_value(RankType, Value) ->
    Sql = io_lib:format(?sql_common_rank_role_delete_by_value, [RankType, Value]),
    db:execute(Sql).

db_init_login_time_map(RankMaps) ->
    F = fun(RankType, AccMap) ->
        CommonRoleL = maps:get(RankType, RankMaps, []),
        RoleIdL = [RoleId||#common_rank_role{role_id = RoleId}<-CommonRoleL],
        case RoleIdL of
            [] -> AccMap;
            _ ->
                Sql = io_lib:format(<<"select id, last_login_time from player_login ~s">>, [usql:condition({id, in, RoleIdL})]),
                lists:foldl(fun([RoleId, LastLoginTime], Map) -> Map#{{RankType, RoleId} => LastLoginTime} end, AccMap, db:get_all(Sql))
        end
    end,
    lists:foldl(F, #{}, ?LOGIN_TIME_RANK_TYPE_LIST).

%% 更新平均等级
%% update_average_lv(RankList) ->
%%     List=[Value||#common_rank_role{value=Value, rank=Rank}<-RankList,Rank=<?WORLD_LV_LEN],
%%     Len = length(List),
%%     case Len>0 of
%%         true -> Lv=lists:sum(List) div Len;
%%         _ -> Lv = 1
%%     end,
%%     ets:insert(?ETS_SERVER_AVERAGE_LV, {lv, Lv}).

%% db_guild_reputation_select(GuildId) ->
%%     Sql = io_lib:format(<<"select `reputation`, `lv` from `guild` where id=~p">>, [GuildId]),
%%     case db:get_row(Sql) of
%%         [Value, Lv] -> {Value, Lv};
%%         _ -> {0,0}
%%     end.

%% db_guild_leader_select(GuildId) ->
%%     Sql = io_lib:format(<<"select `id` from `guild_member` where guild_id=~p and sec_position=8">>, [GuildId]),
%%     case db:get_one(Sql) of
%%         Value when is_integer(Value) -> Value;
%%         _ -> 0
%%     end.

%% 圣域用的公会排行榜
send_guild_rank_list_for_sanctuary(RoleId, GuildId, State) ->
    #common_rank_state{guild_maps = RankMaps} = State,
    RankList = maps:get(?RANK_TYPE_GUILD, RankMaps, []),
    Start = 1,
    Len = ?sanctuary_guild_rank_len,
    Sum = length(RankList),
    case Start > Sum orelse Start =< 0 orelse Len =< 0 of
        true ->
            % ?MYLOG("cym", "Sum:~p ~n", [Sum]),
            if
                Sum == 0 ->
                    {ok, BinData} = pt_283:write(28302, [0, []]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                true -> skip
            end;
        _ ->
            SubRankList = lists:sublist(RankList, Start, Len),
            F = fun(#common_rank_guild{
                guild_id      = TmpGuildId,
                guild_name    = GuildName,
                chairman_id   = _ChairmanId,
                chairman_name = ChairmanName,
                lv            = Lv,
                members_num   = MembersNum,
                value         = Value,
                rank          = Rank
            }) ->
                LimitNum = get_guild_limit_num_by_lv(Lv),
                {TmpGuildId, GuildName, ChairmanName, Rank, MembersNum, LimitNum, Value}
            end,
            SendList = lists:map(F, SubRankList),
            % ?PRINT("~n M:~p L:~p guild RankType:~p List:~p ~n", [?MODULE, ?LINE, RankType, List]),
            case lists:keyfind({?RANK_TYPE_GUILD, GuildId}, #common_rank_guild.guild_key, RankList) of
                #common_rank_guild{rank = GuildRank, value = MyGuildAvgPower} ->
                    skip;
                _ ->
                    MyGuildAvgPower = 0,
                    GuildRank = 0
            end,
            mod_sanctuary:send_guild_rank_list_for_sanctuary(RoleId, GuildRank, MyGuildAvgPower, SendList)
%%            ?MYLOG("cym", "GuildRank:~p, MyGuildAvgPower ~p ~n SendList:~p ~n",
%%                [GuildRank, MyGuildAvgPower, SendList]),
%%            {ok, BinData} = pt_283:write(28302, [GuildRank, MyGuildAvgPower, SendList]),
%%            lib_server_send:send_to_uid(RoleId, BinData)
    end.
%%获得公会成员上限
get_guild_limit_num_by_lv(Lv) ->
    case data_guild:get_guild_lv_cfg(Lv) of
        #guild_lv_cfg{member_capacity = LimitNum} ->
            LimitNum;
        _ ->
            0
    end.

%% 发送排行榜信息给圣域进程
sanctuary_do_result(State) ->
    #common_rank_state{guild_maps = RankMaps} = State,
    RankList = maps:get(?RANK_TYPE_GUILD, RankMaps, []),
    NewRankList = [#last_guild_rank{guild_id = GuildId, rank = Rank1} || #common_rank_guild{guild_id = GuildId, rank = Rank1} <- RankList],
    mod_sanctuary:update_last_guild_rank(NewRankList),
    lib_sanctuary:send_to_guild_member_sanctuary_settlement(RankList),
    Start = 1,
    Len = ?sanctuary_guild_rank_result_len,
    Sum = length(RankList),
    case Start > Sum orelse Start =< 0 orelse Len =< 0 of
        true ->
            mod_sanctuary:do_result_with_guild_with_msg([]);
        _ ->
            SubRankList = lists:sublist(RankList, Start, Len),
            GuildList = [{GuildId, GuildName}  || #common_rank_guild{guild_id = GuildId, guild_name = GuildName}<- SubRankList],
            % ?MYLOG("cym", "GuildIdList ~p ~n", [GuildList]),
            mod_sanctuary:do_result_with_guild_with_msg(GuildList)
    end.

%%合服结算
merge_sanctuary_do_result(State) ->
    #common_rank_state{guild_maps = RankMaps} = State,
    RankList = maps:get(?RANK_TYPE_GUILD, RankMaps, []),
    NewRankList = [#last_guild_rank{guild_id = GuildId, rank = Rank1} || #common_rank_guild{guild_id = GuildId, rank = Rank1} <- RankList],
    mod_sanctuary:update_last_guild_rank(NewRankList),
%%    lib_sanctuary:send_to_guild_member_sanctuary_settlement(RankList),
    Start = 1,
    Len = ?sanctuary_guild_rank_result_len,
    Sum = length(RankList),
    case Start > Sum orelse Start =< 0 orelse Len =< 0 of
        true ->
            mod_sanctuary:merge_sanctuary_do_result([]);
        _ ->
            SubRankList = lists:sublist(RankList, Start, Len),
            GuildList = [{GuildId, GuildName}  || #common_rank_guild{guild_id = GuildId, guild_name = GuildName}<- SubRankList],
            % ?MYLOG("cym", "GuildIdList ~p ~n", [GuildList]),
            mod_sanctuary:merge_sanctuary_do_result(GuildList)
    end.



%% 增加争夺值
add_scramble_value(State, RoleId, RoleName, CastleId, AddValue, _AllValue, _TodayValue, Mod, SubMod, Count, NewCount) ->
    #common_rank_state{role_maps = Map} = State,
    RoleList  = maps:get(?RANK_TYPE_COMBAT, Map, []),
    case lists:keyfind({?RANK_TYPE_COMBAT, RoleId}, #common_rank_role.role_key, RoleList) of
        #common_rank_role{rank = Rank} when Rank > 0 ->
            LastValue = lib_chrono_rift:get_scramble_value_with_ratio(AddValue, Rank),
%%            ?MYLOG("chrono", "LastValue ~p~n", [LastValue]),
            %%log
            Ratio = data_chrono_rift:get_rank_ratio(Rank),
%%            lib_log_api:log_chrono_rift_act(RoleId, Mod, SubMod, Count, AddValue, TodayValue, AllValue, Ratio),
			Role = #castle_role_msg{
				role_id = RoleId
				, role_name = RoleName
				, castle_id = CastleId
				, server_name = util:get_server_name()
				, server_id = config:get_server_id()
				, server_num = config:get_server_num()
				, is_occupy = 1
			},
%%			?MYLOG("chrono", "Role ~p~n", [Role]),
			mod_clusters_node:apply_cast(mod_kf_chrono_rift, add_scramble_value, [Role, CastleId, LastValue, AddValue, Mod, SubMod, Count, NewCount, Ratio]);
		_ ->
            Role = #castle_role_msg{
                role_id = RoleId
                , role_name = RoleName
                , castle_id = CastleId
                , server_name = util:get_server_name()
                , server_id = config:get_server_id()
                , server_num = config:get_server_num()
                , is_occupy = 1
            },
            mod_clusters_node:apply_cast(mod_kf_chrono_rift, add_scramble_value,
                [Role, CastleId, 0, AddValue, Mod, SubMod, Count, NewCount, 0])
	end.

%% -----------------------------------------------------------------
%% @desc 周卡培养现回退修正排行榜
%% @param
%% @return
%% -----------------------------------------------------------------
gm_correct_common_rank_formal(State, List) ->
    F = fun({RankType, CommonRank}, TmpState) ->
        {ok, NewTmpState} = gm_refresh_common_rank(TmpState, RankType, CommonRank),
        NewTmpState
        end,
    NewState = lists:foldl(F, State, List),
    {ok, NewState}.

gm_refresh_common_rank(State, RankType, CommonRankRole) ->
    #common_rank_state{role_maps = RankMaps, rank_limit = RankLimit} = State,
    RankList = maps:get(RankType, RankMaps, []),
    {NewRankList, NewRankLimit} = do_gm_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit),
    NewRankMaps = maps:put(RankType, NewRankList, RankMaps),
    NewState = State#common_rank_state{role_maps = NewRankMaps, rank_limit = NewRankLimit},
    {ok, NewState}.

do_gm_refresh_common_rank_help(RankList, RankType, CommonRankRole, RankLimit) ->
    #common_rank_role{role_key = RoleKey, value = Value} = CommonRankRole,
    case lists:keyfind(RoleKey, #common_rank_role.role_key, RankList) of
        #common_rank_role{value = Value, time = OldTime, rank = Rank, display_value = DisValue} = OldRankRole ->
            NewRole = CommonRankRole#common_rank_role{time = OldTime, rank = Rank, display_value = DisValue},  %% 时间为排序值更新时间 如果值没改变就用回之前的
            case NewRole =/= OldRankRole of   %% 保留值改了的时候更新
                true ->
                    db_common_rank_role_save(NewRole),
                    NewList = lists:keystore(RoleKey, #common_rank_role.role_key, RankList, NewRole);
                _ ->
                    NewList = RankList
            end,
            {NewList, RankLimit};
        _ ->
            do_gm_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit)
    end.

do_gm_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit) ->
    do_refresh_common_rank_help2(RankList, RankType, CommonRankRole, RankLimit, false).

common_rank_snapshot(State) ->
    #common_rank_state{ role_maps = RankMaps} = State,
    NowSec = utime:unixtime(),
    spawn(fun() ->
        timer:sleep(urand:rand(5000, 10000)),
        do_common_rank_snapshot(RankMaps, NowSec)
    end).

%% 零点快照
do_common_rank_snapshot(RankMaps, NowSec) ->
    DealRankList = lists:flatten([maps:get(RankType, RankMaps, [])||RankType <- [?RANK_TYPE_COMBAT, ?RANK_TYPE_LV]]),
    [begin
         lib_log_api:log_midnight_common_rank([RoleId, "", RankType, Rank, FirstValue, SecondValue, ThirdValue, NowSec]),
         timer:sleep(100)
     end || #common_rank_role{
        rank_type = RankType, rank = Rank, role_id = RoleId, value = FirstValue,
        second_value = SecondValue, third_value = ThirdValue
    } <- DealRankList, Rank > 0],
    %%  ta上报
    F_ta = fun(#common_rank_role{rank_type = RankType, role_id = RoleId, rank = Rank}) ->
        timer:sleep(1000),
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ta_agent_fire, ta_rank, [[RankType, Rank, NowSec]])
    end,
    lists:foreach(F_ta, DealRankList).
