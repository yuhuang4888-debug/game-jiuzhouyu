%% ---------------------------------------------------------------------------
%% @doc lib_guild_data.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 帮派进程数据处理:更新,删除,获取;部分外部函数
%% ---------------------------------------------------------------------------
-module(lib_guild_data).
-export([]).

-compile(export_all).

-include("def_fun.hrl").
-include("guild.hrl").
-include("sql_guild.hrl").
-include("figure.hrl").
-include("chat.hrl").
-include("common.hrl").

%% -----------------------------------------------------------------
%% 公会操作
%% -----------------------------------------------------------------

%% 获得公会Maps
get_guild_map() ->
    case get(?P_GUILD) of
        undefined -> #{};
        Val -> Val
    end.

%% 保存公会Maps
save_guild_map(GuildMap) -> put(?P_GUILD, GuildMap).

%% 更新公会
update_guild(#guild{id = GuildId} = Guild) ->
    GuildMap = get_guild_map(),
    NewGuildMap = maps:put(GuildId, Guild, GuildMap),
    save_guild_map(NewGuildMap),
    ok.

%% 删除公会
delete_guild(GuildId) ->
    GuildMap = get_guild_map(),
    NewGuildMap = maps:remove(GuildId, GuildMap),
    save_guild_map(NewGuildMap),
    ok.

%% 根据增加玩家,更新公会
update_guild_by_add_member(GuildMember) ->
    #guild_member{guild_id = GuildId} = GuildMember,
    case get_guild_by_id(GuildId) of
        [] -> skip;
        #guild{member_num = MemberNum, disband_warnning_time = _DisbandWarnningTime} = Guild ->
            %% 这里只处理内存的,db操作在前面的事务里面
            NewMemberNum = MemberNum + 1,
            NewDisbandWarnningTime = 0,
            % case DisbandWarnningTime > 0 andalso NewMemberNum >= ?AUTO_DISBAND_NEED_NUM of
            %     true ->
            %         %% 发送自动解散警告取消邮件
            %         mod_guild:send_guild_mail_by_guild_id(GuildId, utext:get(4000025), utext:get(4000026), [], []),
            %         NewDisbandWarnningTime = 0;
            %     false ->
            %         NewDisbandWarnningTime = DisbandWarnningTime
            % end,
            %% 重新计算公会战力
            NowTime = utime:unixtime(),
            SumCombatPower = lib_guild_util:count_guild_combat_power(GuildId, NowTime),
            CombatPowerTen = lib_guild_util:count_guild_combat_power_ten(GuildId, NowTime),
            NewGuild = Guild#guild{combat_power = SumCombatPower, combat_power_ten = CombatPowerTen, member_num = NewMemberNum, disband_warnning_time = NewDisbandWarnningTime},
            lib_guild_api:guild_power_change(NewGuild),
            update_guild(NewGuild)
    end.

%% 根据删除玩家,更新公会
update_guild_by_delete_member(GuildMember) ->
    #guild_member{guild_id = GuildId} = GuildMember,
    case get_guild_by_id(GuildId) of
        [] -> skip;
        #guild{member_num = MemberNum} = Guild ->
            NewMemberNum = MemberNum - 1,
            %% 重新计算公会战力
            NowTime = utime:unixtime(),
            SumCombatPower = lib_guild_util:count_guild_combat_power(GuildId, NowTime),
            CombatPowerTen = lib_guild_util:count_guild_combat_power_ten(GuildId, NowTime),
            NewGuild = Guild#guild{combat_power = SumCombatPower, combat_power_ten = CombatPowerTen, member_num = NewMemberNum},
            lib_guild_api:guild_power_change(NewGuild),
            update_guild(NewGuild)
    end.

%% 根据公会id获得公会
get_guild_by_id(GuildId) ->
    GuildMap = get_guild_map(),
    maps:get(GuildId, GuildMap, []).

%% 根据玩家id获得公会
get_guild_by_role_id(RoleId) ->
    case get(?P_MEMBER_GUILD_ID) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    case maps:get(RoleId, MemberGuildIdMap, []) of
        [] -> [];
        GuildId -> get_guild_by_id(GuildId)
    end.

%% 所有已经加入公会的玩家id
get_all_role_in_guild() ->
    case get(?P_MEMBER_GUILD_ID) of
        undefined -> [];
        MemberGuildIdMap ->
            maps:keys(MemberGuildIdMap)
    end.

%% 所有已经加入公会的玩家id
get_all_role_in_guild(GuildId) ->
    case get(?P_MEMBER_GUILD_ID) of
        undefined -> [];
        MemberGuildIdMap ->
            MemberGuildIdL = maps:to_list(MemberGuildIdMap),
            F = fun(T, Acc) ->
                case T of
                    {RoleId, GuildId} ->
                        [RoleId|Acc];
                    _ -> Acc
                end
            end,
            lists:foldl(F, [], MemberGuildIdL)
    end.

%% 根据公会id获得公会会长信息
get_guild_chief_info_by_id(GuildId) ->
    case get_chief(GuildId) of
        [] -> {0, ""};
        #guild_member{id = Id, figure = #figure{name = Name}} -> {Id, Name}
    end.

%% 匹配
%% @param Type 类型
%% @return #{} | #{..}
match_guild(Type) ->
    case Type of
        % 公会名字模糊搜索
        {guild_name_fuzzy, Name} ->
            GuildMap = get_guild_map(),
            NameStr = util:make_sure_list(Name),
            F = fun(_, Guild) ->
                case re:run(Guild#guild.name, NameStr, [{capture, none}]) of
                    match -> true;
                    _ -> false
                end
            end,
            maps:filter(F, GuildMap);
        % 根据大写名字匹配
        {name_upper, NameUpper} ->
            GuildMap = get_guild_map(),
            maps:filter(fun(_Key, Guild) -> Guild#guild.name_upper =:= NameUpper end, GuildMap);
        _ ->
            #{}
    end.

%% 提取公会信息(40001 & 40061)
pack_guild_list(GuildList, RoleId) ->
    % 申请表
    GuildApplyMap = lib_guild_data:get_guild_apply_map(),

    % 数据组装
    F = fun(Guild, AccL) ->
        #guild{
            id = GuildId, name = TmpGuildName, lv = GuildLv, gfunds = GuildExp,
            chief_id = ChiefId, chief_name = ChiefName, member_num = MemberNum,
            auto_approve_power = AutoApprovePower, combat_power_ten = CPT
        } = Guild,

        % 成员容量
        NewMemberCapacity = lib_guild_util:calc_guild_capacity(Guild),

        % 是否申请过
        IsApply = ?IF(maps:is_key({RoleId, GuildId}, GuildApplyMap), 1, 0),

        % 合并状态及主副状态
        RoleGuild = lib_guild_data:get_guild_by_role_id(RoleId),
        MergeStatus = lib_guild_util:calc_guild_merge_status(RoleGuild, Guild),
        MergeRel = lib_guild_util:calc_guild_merge_rel(RoleGuild, Guild),

        [{GuildId, TmpGuildName, GuildLv, GuildExp, ChiefId, ChiefName, MemberNum, NewMemberCapacity, IsApply, AutoApprovePower, CPT, MergeStatus, MergeRel} | AccL]
    end,
    lists:foldl(F, [], GuildList).

%% -----------------------------------------------------------------
%% 公会成员信息
%% -----------------------------------------------------------------

%% 获得公会成员
get_guild_member(GuildId, RoleId) ->
    GuildMemberMap = get_guild_member_map(GuildId),
    maps:get(RoleId, GuildMemberMap, []).

%% 获得公会成员
get_guild_member_by_role_id(RoleId) ->
    case get(?P_MEMBER_GUILD_ID) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    case maps:get(RoleId, MemberGuildIdMap, []) of
        [] -> [];
        GuildId -> get_guild_member(GuildId, RoleId)
    end.

%% 获得公会成员map
get_guild_member_map(GuildId) ->
    case get(?P_GUILD_MEMBER(GuildId)) of
        undefined -> GuildMemberMap = maps:new();
        GuildMemberMap -> ok
    end,
    GuildMemberMap.

set_guild_member_map(GuildId, GuildMemberMap) ->
    put(?P_GUILD_MEMBER(GuildId), GuildMemberMap).

%% 删除公会的所有成员
delete_guild_member_by_guild_id(GuildId, RoleIdList) ->
    erase(?P_GUILD_MEMBER(GuildId)),
    PMemberGuildIdKey = ?P_MEMBER_GUILD_ID,
    case get(PMemberGuildIdKey) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    NewMemberGuildIdMap = maps:without(RoleIdList, MemberGuildIdMap),
    put(PMemberGuildIdKey, NewMemberGuildIdMap),
    ok.

%% 更新公会成员
update_guild_member(GuildMember) ->
    #guild_member{id = MemberId, guild_id = GuildId} = GuildMember,
    PMemberGuildIdKey = ?P_MEMBER_GUILD_ID,
    case get(PMemberGuildIdKey) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    NewMemberGuildIdMap = maps:put(MemberId, GuildId, MemberGuildIdMap),
    put(PMemberGuildIdKey, NewMemberGuildIdMap),
    GuildMemberMap = get_guild_member_map(GuildId),
    NewGuildMemberMap = maps:put(MemberId, GuildMember, GuildMemberMap),
    put(?P_GUILD_MEMBER(GuildId), NewGuildMemberMap),
    ok.

add_guild_member(GuildMember) ->
    update_guild_member(GuildMember),
    % 触发增加成员
    update_guild_by_add_member(GuildMember),
    sort_guild_by_level(),
    ok.

delete_guild_member(GuildMember) ->
    #guild_member{id = MemberId, guild_id = GuildId} = GuildMember,
    % 成员和公会id的Maps
    PMemberGuildIdKey = ?P_MEMBER_GUILD_ID,
    case get(PMemberGuildIdKey) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    NewMemberGuildIdMap = maps:remove(MemberId, MemberGuildIdMap),
    put(PMemberGuildIdKey, NewMemberGuildIdMap),
    % 成员的处理
    GuildMemberMap = get_guild_member_map(GuildId),
    NewGuildMemberMap = maps:remove(MemberId, GuildMemberMap),
    put(?P_GUILD_MEMBER(GuildId), NewGuildMemberMap),
    ok.

%% 增加公会成员
add_guild_member_on_db_and_p(GuildMember) ->
    % 增加成员
    db_guild_member_replace(GuildMember),
    add_guild_member(GuildMember),
    GuildMember.

%% 删除公会成员
delete_guild_member_on_db_and_p(GuildMember) ->
    #guild_member{id = RoleId} = GuildMember,
    % 清理成员数据
    Sql = io_lib:format(?sql_guild_member_clear_by_role_id, [RoleId]),
    db:execute(Sql),
    delete_guild_member(GuildMember),
    update_guild_by_delete_member(GuildMember),
    sort_guild_by_level(),
    ok.

%% 匹配
%% @param Type 类型
%% @return #{} | #{..}
match_guild_member(Type) ->
    case Type of
        {online_flag, GuildId, OnlineFlag} ->
            GuildMemberMap = get_guild_member_map(GuildId),
            maps:filter(fun(_, GuildMember) -> GuildMember#guild_member.online_flag =:= OnlineFlag end, GuildMemberMap);
        {position, GuildId, Position} ->
            GuildMemberMap = get_guild_member_map(GuildId),
            maps:filter(fun(_, GuildMember) -> GuildMember#guild_member.position =:= Position end, GuildMemberMap);
        {specify_positions, GuildId, PositionL} ->
            GuildMemberMap = get_guild_member_map(GuildId),
            maps:filter(fun(_, GuildMember) -> lists:member(GuildMember#guild_member.position, PositionL) end, GuildMemberMap);
        _ -> #{}
    end.

%% 获得会长
get_chief(GuildId) ->
    Map = match_guild_member({position, GuildId, ?POS_CHIEF}),
    List = maps:values(Map),
    case List == [] of
        true -> [];
        false -> hd(List)
    end.

%%--------------------------------------------------
%% 搜索公会成员
%% @param  GuildId  公会Id
%% @param  RoleId   玩家id
%% @param  PageSize 分页大小
%% @param  PageNo   分页号
%% @param  SortType 排序类型 参考宏?sgm_
%% @param  SortFlag 0: 降序 1: 升序
%% @param  MemberType 0: 所有成员 1: 在线成员 2: 离线成员
%% @param  SpecailType 0: 正常 1：提取自己到最前面
%%--------------------------------------------------
search_guild_member(GuildId, RoleId, SortType, _SortFlag, MemberType, SpecailType) ->
    NowTime = utime:unixtime(),
    F = fun(GuildMemberA, GuildMemberB) ->
        case SortType of
            ?sgm_default ->
                %% 列表排列优先级：离线时间>职务>等级>贡献值>加入时间
                PosSortA = data_guild_m:get_position_sort(GuildMemberA#guild_member.position),
                PosSortB = data_guild_m:get_position_sort(GuildMemberB#guild_member.position),
                MemberAOfflineTime = case GuildMemberA#guild_member.online_flag == ?ONLINE_OFF of
                    true -> NowTime - GuildMemberA#guild_member.last_logout_time;
                    false -> 0
                end,
                MemberBOfflineTime = case GuildMemberB#guild_member.online_flag == ?ONLINE_OFF of
                    true -> NowTime - GuildMemberB#guild_member.last_logout_time;
                    false -> 0
                end,
                case MemberAOfflineTime == MemberBOfflineTime of
                    true ->
                        case PosSortA == PosSortB of
                            true ->
                                case GuildMemberA#guild_member.figure#figure.lv == GuildMemberB#guild_member.figure#figure.lv of
                                    true ->
                                        case GuildMemberA#guild_member.historical_donate == GuildMemberB#guild_member.historical_donate of
                                            true ->
                                                GuildMemberA#guild_member.create_time =< GuildMemberB#guild_member.create_time;
                                            false ->
                                                GuildMemberA#guild_member.historical_donate > GuildMemberB#guild_member.historical_donate
                                        end;
                                    false ->
                                        GuildMemberA#guild_member.figure#figure.lv > GuildMemberB#guild_member.figure#figure.lv
                                end;
                            false ->
                                PosSortA > PosSortB
                        end;
                    false -> MemberAOfflineTime < MemberBOfflineTime
                end;
            % ?sgm_lv ->
            %     case SortFlag == ?sort_flag_desc of
            %         true -> GuildMemberA#guild_member.figure#figure.lv >= GuildMemberB#guild_member.figure#figure.lv;
            %         false -> GuildMemberA#guild_member.figure#figure.lv =< GuildMemberB#guild_member.figure#figure.lv
            %     end;
            % ?sgm_guild_pos ->
            %     PosSortA = data_guild_m:get_max_position_sort(GuildMemberA#guild_member.position, GuildMemberA#guild_member.sec_position),
            %     PosSortB = data_guild_m:get_max_position_sort(GuildMemberB#guild_member.position, GuildMemberB#guild_member.sec_position),
            %     case SortFlag == ?sort_flag_desc of
            %         true -> PosSortA >= PosSortB;
            %         false -> PosSortA =< PosSortB
            %     end;
            % ?sgm_donate ->
            %     case SortFlag == ?sort_flag_desc of
            %         true -> GuildMemberA#guild_member.donate >= GuildMemberB#guild_member.donate;
            %         false -> GuildMemberA#guild_member.donate =< GuildMemberB#guild_member.donate
            %     end;
            % ?sgm_liveness ->
            %     case SortFlag == ?sort_flag_desc of
            %         true -> GuildMemberA#guild_member.liveness >= GuildMemberB#guild_member.liveness;
            %         false -> GuildMemberA#guild_member.liveness =< GuildMemberB#guild_member.liveness
            %     end;
            % ?sgm_online_pos_lv ->
            %     PosSortA = data_guild_m:get_max_position_sort(GuildMemberA#guild_member.position, GuildMemberA#guild_member.sec_position),
            %     PosSortB = data_guild_m:get_max_position_sort(GuildMemberB#guild_member.position, GuildMemberB#guild_member.sec_position),
            %     if
            %         GuildMemberA#guild_member.online_flag > GuildMemberB#guild_member.online_flag -> true;
            %         GuildMemberA#guild_member.online_flag < GuildMemberB#guild_member.online_flag -> false;
            %         PosSortA > PosSortB -> true;
            %         PosSortA < PosSortB -> false;
            %         true -> GuildMemberA#guild_member.figure#figure.lv >= GuildMemberB#guild_member.figure#figure.lv
            %     end;
            % ?sgm_pos_donate_lv_liveness ->
            %     PosSortA = data_guild_m:get_max_position_sort(GuildMemberA#guild_member.position, GuildMemberA#guild_member.sec_position),
            %     PosSortB = data_guild_m:get_max_position_sort(GuildMemberB#guild_member.position, GuildMemberB#guild_member.sec_position),
            %     if
            %         PosSortA > PosSortB -> true;
            %         PosSortA < PosSortB -> false;
            %         GuildMemberA#guild_member.donate > GuildMemberB#guild_member.donate -> true;
            %         GuildMemberA#guild_member.donate < GuildMemberB#guild_member.donate -> false;
            %         GuildMemberA#guild_member.figure#figure.lv > GuildMemberB#guild_member.figure#figure.lv -> true;
            %         GuildMemberA#guild_member.figure#figure.lv < GuildMemberB#guild_member.figure#figure.lv -> false;
            %         true -> GuildMemberA#guild_member.liveness >= GuildMemberB#guild_member.liveness
            %     end;
            % ?sgm_pos_lv_donate ->
            %     PosSortA = data_guild_m:get_max_position_sort(GuildMemberA#guild_member.position, GuildMemberA#guild_member.sec_position),
            %     PosSortB = data_guild_m:get_max_position_sort(GuildMemberB#guild_member.position, GuildMemberB#guild_member.sec_position),
            %     if
            %         PosSortA > PosSortB -> true;
            %         PosSortA < PosSortB -> false;
            %         GuildMemberA#guild_member.figure#figure.lv > GuildMemberB#guild_member.figure#figure.lv -> true;
            %         GuildMemberA#guild_member.figure#figure.lv < GuildMemberB#guild_member.figure#figure.lv -> false;
            %         true -> GuildMemberA#guild_member.donate >= GuildMemberB#guild_member.donate
            %     end;
            _ ->
                true
        end
    end,
    if
        MemberType == ?member_type_online orelse MemberType == ?member_type_logout ->
            case MemberType == ?member_type_online of
                true -> OnlineFlag = 1;
                false -> OnlineFlag = 0
            end,
            GuildMemberMap = match_guild_member({online_flag, GuildId, OnlineFlag});
        true ->
            GuildMemberMap = get_guild_member_map(GuildId)
    end,
    GuildMemberList = maps:values(GuildMemberMap),
    GuildMemberListAfSort = lists:sort(F, GuildMemberList),
    if
        SpecailType == ?s_special_type_normal -> GuildMemberListAfSort;
        true ->
            case lists:keyfind(RoleId, #guild_member.id, GuildMemberListAfSort) of
                false -> GuildMemberListAfSort;
                GuildMember ->
                    GuildMemberListAfdel = lists:keydelete(RoleId, #guild_member.id, GuildMemberListAfSort),
                    [GuildMember|GuildMemberListAfdel]
            end
    end.

%% -----------------------------------------------------------------
%% 公会申请
%% -----------------------------------------------------------------

%% 获得公会申请
get_guild_apply_map() ->
    case get(?P_GUILD_APPLY) of
        undefined ->
            GuildApplyMap = lib_guild_mod:init_guild_apply(),
            GuildApplyMap;
        GuildApplyMap ->
            GuildApplyMap
    end.

get_guild_apply_map_by_role_id(RoleId) ->
    GuildApplyMap = get_guild_apply_map(),
    F = fun(_K, #guild_apply{role_id = TmpRoleId}) -> TmpRoleId == RoleId end,
    maps:filter(F, GuildApplyMap).

get_guild_apply_map_by_guild_id(GuildId) ->
    GuildApplyMap = get_guild_apply_map(),
    F = fun(_K, #guild_apply{guild_id = TmpGuildId}) -> TmpGuildId == GuildId end,
    maps:filter(F, GuildApplyMap).

get_guild_apply(RoleId, GuildId) ->
    GuildApplyMap = get_guild_apply_map(),
    maps:get({RoleId, GuildId}, GuildApplyMap, []).

%% 更新公会申请
update_guild_apply(GuildApply) ->
    #guild_apply{role_id = RoleId, guild_id = GuildId} = GuildApply,
    % 公会请求
    GuildApplyMap = get_guild_apply_map(),
    NewGuildApplyMap = maps:put({RoleId, GuildId}, GuildApply, GuildApplyMap),
    put(?P_GUILD_APPLY, NewGuildApplyMap),
    % 公会的玩家id请求列表
    ApplyGuildMap = get_guild_apply_guild_map(),
    MemberIdList = maps:get(GuildId, ApplyGuildMap, []),
    case lists:member(RoleId, MemberIdList) of
        false -> NewMeberIdList = [RoleId|MemberIdList];
        true -> NewMeberIdList = MemberIdList
    end,
    NewApplyGuildMap = maps:put(GuildId, NewMeberIdList, ApplyGuildMap),
    put(?P_GUILD_APPLY_GUILD, NewApplyGuildMap),
    NewGuildApplyMap.

%% 增加公会申请列表
add_guild_apply_on_db_and_p(RoleId, GuildId) ->
    GuildApply = lib_guild_mod:make_record(guild_apply, [RoleId, GuildId, utime:unixtime()]),
    db_guild_apply_save(GuildApply),
    update_guild_apply(GuildApply).

%% 删除公会申请
delete_guild_apply_by_key_on_db_and_p(RoleId, GuildId) ->
    % 数据库清理
    Sql = io_lib:format(?sql_guild_apply_delete_by_key, [RoleId, GuildId]),
    db:execute(Sql),
    % 公会请求清理
    AllGuildApplyMap = get_guild_apply_map(),
    NewAllGuildApplyMap = maps:remove({RoleId, GuildId}, AllGuildApplyMap),
    put(?P_GUILD_APPLY, NewAllGuildApplyMap),
    % 公会的玩家id请求列表清理
    ApplyGuildMap = get_guild_apply_guild_map(),
    MemberIdList = get_guild_apply_member_id_lsit_by_guild_id(GuildId),
    NewMeberIdList = lists:delete(RoleId, MemberIdList),
    case NewMeberIdList == [] of
        true -> NewApplyGuildMap = maps:remove(GuildId, ApplyGuildMap);
        false -> NewApplyGuildMap = maps:put(GuildId, NewMeberIdList, ApplyGuildMap)
    end,
    put(?P_GUILD_APPLY_GUILD, NewApplyGuildMap),
    ok.

delete_guild_apply_by_role_id(RoleId) ->
    % 公会请求清理
    AllGuildApplyMap = get_guild_apply_map(),
    GuildApplyMap = get_guild_apply_map_by_role_id(RoleId),
    Keys = maps:keys(GuildApplyMap),
    NewAllGuildApplyMap = maps:without(Keys, AllGuildApplyMap),
    put(?P_GUILD_APPLY, NewAllGuildApplyMap),
    % 公会的玩家id请求列表清理
    ApplyGuildMap = get_guild_apply_guild_map(),
    F2 = fun({TmpRoleId, TmpGuildId}, TmpApplyGuildMap) ->
        MemberIdList = maps:get(TmpGuildId, TmpApplyGuildMap, []),
        NewMeberIdList = lists:delete(TmpRoleId, MemberIdList),
        case NewMeberIdList == [] of
            true ->
                %% 红点
                GuildMemberMap = lib_guild_data:get_guild_member_map(TmpGuildId),
                F = fun(_K, GuildMember, List) ->
                    #guild_member{id = MemberId, position = Position} = GuildMember,
                    PermissionList = lib_guild_mod:get_position_permission_list(TmpGuildId, Position),
                    IsAllowModify = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
                    case IsAllowModify of
                        true -> lib_guild_mod:send_red_point(MemberId, ?RED_POINT_GUILD_APPLY, 0);
                        false -> List
                    end
                end,
                maps:fold(F, [], GuildMemberMap),
                maps:remove(TmpGuildId, TmpApplyGuildMap);
            false -> maps:put(TmpGuildId, NewMeberIdList, TmpApplyGuildMap)
        end
    end,
    NewApplyGuildMap = lists:foldl(F2, ApplyGuildMap, Keys),
    put(?P_GUILD_APPLY_GUILD, NewApplyGuildMap),
    ok.

delete_guild_apply_by_guild_id(GuildId) ->
    % 公会请求清理
    AllGuildApplyMap = get_guild_apply_map(),
    GuildApplyMap = get_guild_apply_map_by_guild_id(GuildId),
    Keys = maps:keys(GuildApplyMap),
    NewAllGuildApplyMap = maps:without(Keys, AllGuildApplyMap),
    put(?P_GUILD_APPLY, NewAllGuildApplyMap),
    % 公会的玩家id请求列表清理
    ApplyGuildMap = get_guild_apply_guild_map(),
    NewApplyGuildMap = maps:remove(GuildId, ApplyGuildMap),
    put(?P_GUILD_APPLY_GUILD, NewApplyGuildMap),
    ok.

clear_expired_apply(ExpiredCreateTime) ->
    AllGuildApplyMap = get_guild_apply_map(),
    F = fun(_K, #guild_apply{create_time = CrteaTimeTmp}) -> CrteaTimeTmp =< ExpiredCreateTime end,
    ExpiredApplyMap = maps:filter(F, AllGuildApplyMap),
    Keys = maps:keys(ExpiredApplyMap),
    NewAllGuildApplyMap = maps:without(Keys, AllGuildApplyMap),
    put(?P_GUILD_APPLY, NewAllGuildApplyMap),
    ApplyGuildMap = get_guild_apply_guild_map(),
    F1 = fun({TmpRoleId, TmpGuildId}, TmpApplyGuildMap) ->
        MemberIdList = maps:get(TmpGuildId, TmpApplyGuildMap, []),
        NewMeberIdList = lists:delete(TmpRoleId, MemberIdList),
        case NewMeberIdList == [] of
            true -> maps:remove(TmpGuildId, TmpApplyGuildMap);
            false -> maps:put(TmpGuildId, NewMeberIdList, TmpApplyGuildMap)
        end
    end,
    NewApplyGuildMap = lists:foldl(F1, ApplyGuildMap, Keys),
    put(?P_GUILD_APPLY_GUILD, NewApplyGuildMap),
    ok.

%% 获得公会的玩家id请求列表
get_guild_apply_guild_map() ->
    case get(?P_GUILD_APPLY_GUILD) of
        undefined -> maps:new();
        ApplyGuildMap -> ApplyGuildMap
    end.

%% 根据公会id,获得申请中的玩家id列表
get_guild_apply_member_id_lsit_by_guild_id(GuildId) ->
    ApplyGuildMap = get_guild_apply_guild_map(),
    maps:get(GuildId, ApplyGuildMap, []).

%% -----------------------------------------------------------------
%% 公会职位名字
%% -----------------------------------------------------------------

get_position_name_map(GuildId) ->
    case get(?P_POS_NAME(GuildId)) of
        undefined -> lib_guild_mod:init_position_name_map(GuildId);
        PositionNameMap -> PositionNameMap
    end.

%% 清理
delete_position_name(GuildId) ->
    erase(?P_POS_NAME(GuildId)),
    ok.

update_position_name(GuildId, Position, PositionName) ->
    PositionNameMap = get_position_name_map(GuildId),
    NewPositionNameMap = maps:put(Position, PositionName, PositionNameMap),
    put(?P_POS_NAME(GuildId), NewPositionNameMap),
    NewPositionNameMap.

%% -----------------------------------------------------------------
%% 公会职位权限
%% -----------------------------------------------------------------

get_position_permission_map(GuildId) ->
    case get(?P_POS_PERMISSION(GuildId)) of
        undefined -> lib_guild_mod:init_position_permission_map(GuildId);
        PosPermissionMap -> PosPermissionMap
    end.

%% 清理
delete_position_permission(GuildId) ->
    erase(?P_POS_PERMISSION(GuildId)),
    ok.

update_position_permission(GuildId, Position, PermissionType, IsAllow) ->
    PosPermissionMap = get_position_permission_map(GuildId),
    PermissionTypeMap = maps:get(Position, PosPermissionMap, #{}),
    NewPermissionTypeMap = maps:put(PermissionType, IsAllow, PermissionTypeMap),
    NewPosPermissionMap = maps:put(Position, NewPermissionTypeMap, PosPermissionMap),
    put(?P_POS_PERMISSION(GuildId), NewPosPermissionMap),
    NewPosPermissionMap.

%% 根据职位权限获取成员列表
%% @param PermissionList :: [integer(),...]
%% @return MemberList :: [#guild_member{},...]
get_guild_member_by_permission([], _) -> [];
get_guild_member_by_permission(PermissionList, GuildId) ->
    GuildMembers = maps:values(get_guild_member_map(GuildId)),
    F = fun(#guild_member{position = Position} = Member, Acc) ->
        PList = lib_guild_mod:get_position_permission_list(GuildId, Position),
        case PermissionList -- PList of
            [] -> [Member | Acc];
            _  -> Acc
        end
    end,
    lists:foldl(F, [], GuildMembers).

%% -----------------------------------------------------------------
%% 捐献日志
%% -----------------------------------------------------------------

get_donate_log_list(GuildId) ->
    case get(?P_GUILD_DONATE_LOG(GuildId)) of
        undefined -> [];
        List -> List
    end.

%% 清理
delete_donate_log_list(GuildId) ->
    erase(?P_GUILD_DONATE_LOG(GuildId)),
    ok.

update_donate_log_list(GuildId, DonateLogList) ->
    put(?P_GUILD_DONATE_LOG(GuildId), DonateLogList),
    DonateLogList.

%% -----------------------------------------------------------------
%% 公会等级排序列表
%% -----------------------------------------------------------------
sort_guild_by_level() ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    % 战力排序
    F = fun(GuildA, GuildB) ->
        #guild{id = GuildIdA, lv = GuildLvA, combat_power_ten=CPTA} = GuildA,
        #guild{id = GuildIdB, lv = GuildLvB, combat_power_ten=CPTB} = GuildB,
        if
            CPTA >= CPTB -> true;
            CPTA == CPTB andalso GuildLvA > GuildLvB -> true;
            CPTA == CPTB andalso GuildLvA == GuildLvB -> GuildIdA < GuildIdB;
            true -> false
        end
    end,
    GuildListSort = lists:sort(F, GuildList),
    GuildIdSort = [ GuildId || #guild{id = GuildId} <- GuildListSort ],
    put(?P_GUILD_SORT, GuildIdSort),
    GuildIdSort.

get_sort_guild_id_list() ->
    case get(?P_GUILD_SORT) of
        List when length(List) > 0 -> List;
        _ ->
            sort_guild_by_level()
    end.

%% 圣域前三名公会id
update_sanctuary_top3_guild_list(GuildIdList) ->
    put(?P_SANCTUARY_GUILD, GuildIdList).

get_sanctuary_top3_guild_list() ->
    case get(?P_SANCTUARY_GUILD) of
        undefined -> [];
        GuildIdList -> GuildIdList
    end.
%% 前Length 的平均等级
get_top_avg_lv(GuildId, Length) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.figure#figure.lv >= GuildMemberB#guild_member.figure#figure.lv
    end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    GuildMemberList = maps:values(GuildMemberMap),
    %%除去称号的战斗力
    SortList = lists:sort(SortFun, GuildMemberList),
    F = fun(#guild_member{figure = Figure}, AccLv) ->
            AccLv + Figure#figure.lv
        end,
    NewList = lists:sublist(SortList, Length),
    AllLv = lists:foldl(F, 0, NewList),
    RightLength = length(NewList),
    if
        RightLength >= 1 ->
            round(AllLv / RightLength);
        true ->
            0
    end.

get_prestige_title_id(Prestige) ->
    PrestigeList = data_guild:get_prestige_list(), %% PrestigeList 已排序
    get_prestige_title_id(PrestigeList, Prestige).

get_prestige_title_id([], _Prestige) -> 0;
get_prestige_title_id([{TitleId, NeedPrestige}|PrestigeList], Prestige) ->
    case Prestige >= NeedPrestige of
        true ->
            TitleId;
        _ ->
            get_prestige_title_id(PrestigeList, Prestige)
    end.

%% -----------------------------------------------------------------
%% 公会合并
%% -----------------------------------------------------------------

get_guild_merges() ->
    case get(?P_GUILD_MERGE) of
        undefined -> [];
        Val -> Val
    end.

set_guild_merges(GuildMergeL) ->
    put(?P_GUILD_MERGE, GuildMergeL).

get_guild_merge_apply(GuildId) ->
    ApplyL = get_guild_merges(),
    lists:keyfind(GuildId, #guild_merge.apply_gid, ApplyL).

get_guild_merge_target(GuildId) ->
    ApplyL = get_guild_merges(),
    lists:keyfind(GuildId, #guild_merge.target_gid, ApplyL).

get_guild_merge_key(Key) ->
    ApplyL = get_guild_merges(),
    lists:keyfind(Key, #guild_merge.key, ApplyL).

set_guild_merge(#guild_merge{key = Key} = GuildMerge) ->
    ApplyL = get_guild_merges(),
    NewApplyL = lists:keystore(Key, #guild_merge.key, ApplyL, GuildMerge),
    set_guild_merges(NewApplyL).

delete_guild_merge(#guild_merge{key = Key}) ->
    ApplyL = get_guild_merges(),
    NewApplyL = lists:keydelete(Key, #guild_merge.key, ApplyL),
    set_guild_merges(NewApplyL);

delete_guild_merge(GuildId) when is_integer(GuildId) ->
    ApplyL = get_guild_merges(),
    NewApplyL = [
        Apply || #guild_merge{apply_gid = ApplyGId, target_gid = TargetGId} = Apply <- ApplyL,
        ApplyGId /= GuildId andalso TargetGId /= GuildId
    ],
    set_guild_merges(NewApplyL).

%% -----------------------------------------------------------------
%% 数据库操作
%% -----------------------------------------------------------------

db_guild_insert(Guild) ->
    #guild{
        id = Id
        , name = Name
        , tenet = Tenet
        , announce = Announce
        , chief_id = ChiefId
        , chief_name = ChiefName
        , lv = Lv
        , realm = Realm
        , create_time = CreateTime
        , approve_type = ApproveType
        , auto_approve_lv = AutoApproveLv
        , auto_approve_power = AutoApprovePower
        , disband_warnning_time = DisbandWarnningTime
    } = Guild,
    Sql = io_lib:format(?sql_guild_insert, [Id, util:fix_sql_str(Name), util:fix_sql_str(Tenet), util:fix_sql_str(util:make_sure_binary(Announce)),
        ChiefId, util:fix_sql_str(ChiefName), Lv, Realm, CreateTime, ApproveType,
        AutoApproveLv, AutoApprovePower, DisbandWarnningTime
    ]),
    db:execute(Sql).

%% 弃用，改用db_guild_member_replace/1
db_guild_member_insert(GuildMember) ->
    #guild_member{
        id = Id
        , guild_id = GuildId
        , guild_name = GuildName
        , position = Position
        , donate = Donate
        , create_time = CreateTime
    } = GuildMember,
    Sql = io_lib:format(?sql_guild_member_insert, [Id, GuildId, util:fix_sql_str(GuildName), Position,
        Donate, CreateTime]),
    db:execute(Sql).

db_guild_member_replace(GuildMember) ->
    #guild_member{
        id = Id
        ,guild_id = GuildId
        ,guild_name = GuildName
        ,position = Position
        ,donate = Donate
        ,historical_donate = HistoricalDonate
        ,depot_score = DepotScore
        ,create_time = CreateTime
    } = GuildMember,
    Sql = io_lib:format(?sql_guild_member_replace, [Id, GuildId, util:fix_sql_str(GuildName), Position, Donate, HistoricalDonate, DepotScore, CreateTime]),
    db:execute(Sql).

db_guild_apply_save(GuildApply) ->
    #guild_apply{role_id = RoleId, guild_id = GuildId, create_time = CreateTime} = GuildApply,
    Sql = io_lib:format(?sql_guild_apply_replace, [RoleId, GuildId, CreateTime]),
    db:execute(Sql).

db_guild_apply_delete_by_role_id(RoleId) ->
    Sql = io_lib:format(?sql_guild_apply_delete_by_role_id, [RoleId]),
    db:execute(Sql).

db_guild_member_update_position(RoleId, Position) ->
    Sql = io_lib:format(?sql_guild_member_update_position, [Position, RoleId]),
    db:execute(Sql).

db_guild_update_gfunds(GuildId, Gfunds) ->
    Sql = io_lib:format(?sql_guild_update_gfunds, [Gfunds, GuildId]),
    db:execute(Sql).

%% 修改这里要注意是否需要修改mod_guild_call:modify_name_by_gm
db_guild_update_name(GuildId, GuildName) ->
    SQL1 = io_lib:format("UPDATE `guild` SET `name` = '~s', `c_rename` = 0, `guild_c_rename_time` = ~p WHERE `id` = ~p", [GuildName, utime:unixtime(), GuildId]),
    db:execute(SQL1),
    SQL2 = io_lib:format("UPDATE `guild_member` SET `guild_name` = '~s' WHERE `guild_id` = ~p", [GuildName, GuildId]),
    db:execute(SQL2).

%%% guild_setting

db_guild_setting_update(GuildId, Type, Setting) ->
    SettingBin = util:term_to_bitstring(Setting),
    Sql = io_lib:format(?sql_guild_setting_replace, [GuildId, Type, SettingBin]),
    db:execute(Sql).

%%% guild_merge

%% @return [[申请公会id, 目标公会id, 主公会id, 申请状态, 申请时间, 同意时间],...]
db_guild_merge_select() ->
    Sql = io_lib:format(?sql_guild_merge_select, []),
    db:get_all(Sql).

db_guild_merge_insert(GuildMerge) ->
    #guild_merge{
        apply_gid = ApplyGId,
        target_gid = TargetGId,
        master_gid = MasterGId,
        status = Status,
        apply_time = ApplyTime
    } = GuildMerge,

    Sql = io_lib:format(?sql_guild_merge_insert, [ApplyGId, TargetGId, MasterGId, Status, ApplyTime]),
    db:execute(Sql).

db_guild_merge_delete(GuildMerge) ->
    #guild_merge{
        apply_gid = ApplyGId,
        target_gid = TargetGId
    } = GuildMerge,

    Sql = io_lib:format(?sql_guild_merge_delete, [ApplyGId, TargetGId]),
    db:execute(Sql).

db_guild_merge_update_status(GuildMerge) ->
    #guild_merge{
        key = {ApplyGId, TargetGId},
        status = Status,
        agree_time = AgreeTime
    } = GuildMerge,

    Sql = io_lib:format(?sql_guild_merge_update_status, [Status, AgreeTime, ApplyGId, TargetGId]),
    db:execute(Sql).