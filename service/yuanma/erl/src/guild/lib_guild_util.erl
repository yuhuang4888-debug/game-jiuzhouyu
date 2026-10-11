%% ---------------------------------------------------------------------------
%% @doc lib_guild_util.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 辅助函数
%% ---------------------------------------------------------------------------
-module(lib_guild_util).
-export([
        is_need_refresh/1
    ]).

-include("guild.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("def_fun.hrl").

-compile(export_all).

%% 是否需要刷新(三点判断)
is_need_refresh(RefreshTime) ->
    T1 = utime:unixdate() + 10800,
    T2 = utime:unixdate() - 75600,
    NowTime = utime:unixtime(),
    case NowTime < T1 of
        true -> RefreshTime < T2;
        false -> RefreshTime < T1
    end.

%% 记录公会成员日志
log_guild_member(#guild{id = GuildId, name = GuildName}, EventType, EventParam) ->
    {NewRoleId, NewEventParam} = case EventType of
        ?GLOG_CREATE ->
            [#guild_member{id = RoleId, figure = #figure{name = RoleName}} = GuildMember] = EventParam,
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        ?GLOG_JOIN ->
            [#guild_member{id = RoleId, figure = #figure{name = RoleName}} = GuildMember] = EventParam,
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        ?GLOG_KICK_OUT ->
            [#guild_member{id = RoleId, figure = #figure{name = RoleName}} = GuildMember] = EventParam,
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        ?GLOG_POS_CHANGE ->
            [OldGuildMember, GuildMember] = EventParam,
            #guild_member{id = RoleId, figure = #figure{name = RoleName}} = OldGuildMember,
            OldPositionList = get_pos_str(OldGuildMember),
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, OldPositionList, ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        % LeaderGuildMember :: #guild_member{} | []
        ?GLOG_DISBAND ->
            [LeaderGuildMember] = EventParam,
            case LeaderGuildMember of
                [] -> {0, ""};
                #guild_member{id = RoleId, figure = #figure{name = RoleName}} ->
                    PositionList = get_pos_str(LeaderGuildMember),
                    Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, PositionList]),
                    {RoleId, Str}
            end;
        ?GLOG_QUIT ->
            [#guild_member{id = RoleId, figure = #figure{name = RoleName}} = GuildMember] = EventParam,
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        ?GLOG_AUTO_CHIEF ->
            [OldGuildMember, GuildMember] = EventParam,
            #guild_member{id = RoleId, figure = #figure{name = RoleName}} = OldGuildMember,
            OldPositionList = get_pos_str(OldGuildMember),
            PositionList = get_pos_str(GuildMember),
            Str = lists:concat([uio:thing_to_string(RoleName), ?SEPARATOR_STRING, OldPositionList, ?SEPARATOR_STRING, PositionList]),
            {RoleId, Str};
        _ ->
            ""
    end,
    lib_log_api:log_guild_member(GuildId, GuildName, EventType, NewRoleId, NewEventParam, utime:unixtime()),
    ok.

%% 获得职位的字符串
get_pos_str(GuildMember) ->
    #guild_member{position = Position} = GuildMember,
    PositionName = get_pos_name(Position),
    lists:concat(["(", uio:thing_to_string(PositionName), ")"]).

%% 获得职位名字
get_pos_name(Position) ->
    case data_guild:get_guild_pos_cfg(Position) of
        [] -> "null";
        #guild_pos_cfg{name = Name} -> util:make_sure_binary(Name)
    end.

%% 计算公会战力
count_guild_combat_power(GuildId, NowTime) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    F2 = fun(#guild_member{online_flag = OnlineFlag, last_logout_time = LastLogoutTime, combat_power = CombatPower, h_combat_power = HCombatPower}, Acc2) ->
        RealCountPower = ?IF(CombatPower > 0, CombatPower, HCombatPower),
        %% 离线时间超过一定时间的成员不参与公会战力计算
        case OnlineFlag == ?ONLINE_ON orelse NowTime - LastLogoutTime < ?CAL_GUILD_POWER_VAILD_TIME of
            true -> Acc2 + RealCountPower;
            false -> Acc2
        end
    end,
    lists:foldl(F2, 0, maps:values(GuildMemberMap)).

count_guild_combat_power_ten(GuildId, _NowTime) when is_integer(GuildId) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    MemberList = maps:values(GuildMemberMap),
    count_guild_combat_power_ten(MemberList, _NowTime);

count_guild_combat_power_ten(MemberList, _NowTime) ->
    case length(MemberList) > 10 of
        true ->
            MemberList1 = lists:reverse(lists:keysort(#guild_member.combat_power, MemberList)),
            MemberList2 = lists:sublist(MemberList1, 10);
        _ -> MemberList2 = MemberList
    end,
    F2 = fun(#guild_member{combat_power = CombatPower}, Acc2) ->
        Acc2 + CombatPower
    end,
    CombatPowerTotalTen = lists:foldl(F2, 0, MemberList2),
    round(CombatPowerTotalTen div 10).

%% 计算两个公会的合并状态
calc_guild_merge_status(Guild, _) when not is_record(Guild, guild) -> ?GUILD_MERGE_NONE;

calc_guild_merge_status(Guild, Guild) -> ?GUILD_MERGE_SELF;

calc_guild_merge_status(RoleGuild, Guild) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    #guild{
        id = GId1
    } = RoleGuild,
    #guild{
        id = GId2
    } = Guild,

    % 申请状态
    case lists:keyfind({GId1, GId2}, #guild_merge.key, GuildMergeL) of
        #guild_merge{status = Status} -> skip; % ?GUILD_MERGE_REQUEST | ?GUILD_MERGE_AGREED
        _ -> Status = -1
    end,

    case Status of
        -1 ->
            can_guild_merge(RoleGuild, Guild);
        _ ->
            Status
    end.

%% 判断两个公会是否能合并
%% @return ?GUILD_MERGE_ALLOW | ?GUILD_MERGE_NOT_ALLOW
can_guild_merge(Guild1, Guild2) ->
    MasterGuild = get_merge_master_guild(Guild1, Guild2),
    MasterCap = calc_guild_capacity(MasterGuild),
    {N1, N2} = {calc_active_member_num(Guild1), calc_active_member_num(Guild2)},
    case N1 + N2 =< MasterCap of
        true -> ?GUILD_MERGE_ALLOW;
        false -> ?GUILD_MERGE_NOT_ALLOW
    end.

%% 判断某个/某些请求是否可以操作(处于待处理阶段或不存在请求)
%% @return boolean()
can_guild_merge_operate(GuildMerges) when is_list(GuildMerges) ->
    lists:all(fun(GuildMerge) -> can_guild_merge_operate(GuildMerge) end, GuildMerges);
can_guild_merge_operate(GuildMerge) ->
    not is_record(GuildMerge, guild_merge) orelse GuildMerge#guild_merge.status /= ?GUILD_MERGE_AGREED.

%% 计算活跃成员数量
calc_active_member_num(Guild) ->
    length(get_active_members(Guild)).

%% 计算公会成员容量
calc_guild_capacity(Guild) ->
    #guild{id = GuildId, lv = GuildLv} = Guild,

    % 圣域前三公会
    SanctuaryGuildList = lib_guild_data:get_sanctuary_top3_guild_list(),
    AddSanctuaryLimit = data_sanctuary:get_kv(add_guild_member_limit),

    MemberCapacity = data_guild_m:get_guild_member_capacity(GuildLv),
    IsSanctuaryGuild = lists:member(GuildId, SanctuaryGuildList),
    ?IF(IsSanctuaryGuild, MemberCapacity + AddSanctuaryLimit, MemberCapacity).

%% 判断公会合并中公会2相对于公会1的主副关系
calc_guild_merge_rel(Guild, _) when not is_record(Guild, guild) -> ?GUILD_MERGE_REL_NONE;

calc_guild_merge_rel(Guild1, Guild2) ->
    case get_merge_master_guild(Guild1, Guild2) of
        Guild1 -> ?GUILD_MERGE_REL_VICE;
        Guild2 -> ?GUILD_MERGE_REL_MASTER
    end.

%% 计算当前合并请求的具体合并时间
calc_guild_merge_time(#guild_merge{status = ?GUILD_MERGE_REQUEST} = MergeReq) ->
    #guild_merge{apply_time = ApplyTime} = MergeReq,
    AutoAgreeTime = ApplyTime + ?ONE_DAY_SECONDS,
    calc_guild_merge_time(AutoAgreeTime);

calc_guild_merge_time(#guild_merge{status = ?GUILD_MERGE_AGREED} = MergeReq) ->
    #guild_merge{agree_time = AgreeTime} = MergeReq,
    calc_guild_merge_time(AgreeTime);

calc_guild_merge_time(AgreeTime) ->
    MergeT = data_guild_m:get_config(guild_merge_time),
    NextUnixTime = utime:get_next_unixdate(AgreeTime),
    NextUnixTime + MergeT.

%% 获取公会合并中的主公会
get_merge_master_guild(Guild1, Guild2) ->
    #guild{lv = GuildLv1, gfunds = GuildExp1} = Guild1,
    #guild{lv = GuildLv2, gfunds = GuildExp2} = Guild2,

    if
        GuildLv1 > GuildLv2 -> Guild1;
        GuildLv1 == GuildLv2, GuildExp1 > GuildExp2 -> Guild1;
        true -> Guild2
    end.

%% 获取公会合并中的主副公会
%% @return {主公会, 副公会}
get_merge_master_vice_guild(Guild1, Guild2) ->
    case get_merge_master_guild(Guild1, Guild2) of
        Guild1 -> {Guild1, Guild2};
        _ -> {Guild2, Guild1}
    end.

%% 获取公会中的活跃成员
get_active_members(Guild) ->
    % 获取公会成员列表
    #guild{id = GuildId} =Guild,
    Mbs = maps:values(lib_guild_data:get_guild_member_map(GuildId)),

    % 计算允许的最早登出时间
    LoginDay = data_guild_m:get_config(guild_merge_login_day), % LoginDay天内登陆过的玩家属于活跃玩家
    NowTime = utime:unixtime(),
    StartTime = NowTime - LoginDay * ?ONE_DAY_SECONDS,

    % 过滤出活跃玩家
    F = fun(Mb) ->
        #guild_member{
            online_flag = OnlineFlag,
            last_login_time = LastLoginTime,
            last_logout_time = LastLogoutTime
        } = Mb,
        OnlineFlag == ?ONLINE_ON
        orelse
        LastLoginTime > StartTime
        orelse
        LastLogoutTime > StartTime
    end,
    lists:filter(F, Mbs).

%% 获取公会中的不活跃成员
get_unactive_members(Guild) ->
    #guild{id = GuildId} =Guild,
    Mbs = maps:values(lib_guild_data:get_guild_member_map(GuildId)),

    ActiveMbs = get_active_members(Guild),
    Mbs -- ActiveMbs.

%% 判断公会是否在合并流程中(作为请求方或者目标方已同意合并请求但未到合并时间)
%% @return boolean()
is_in_merge(GuildId) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    MergeReqs = [ Req
     || #guild_merge{apply_gid = GId1, target_gid = GId2} = Req <- GuildMergeL,
        GId1 == GuildId orelse GId2 == GuildId
    ],
    not can_guild_merge_operate(MergeReqs). % 不可进行操作即在合并流程中