%% ---------------------------------------------------------------------------
%% @doc lib_guild_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 帮派进程
%% ---------------------------------------------------------------------------
-module(lib_guild_mod).
-export([]).

-compile(export_all).

-include("guild.hrl").
-include("sql_guild.hrl").
-include("figure.hrl").
-include("errcode.hrl").

-include("common.hrl").
-include("role.hrl").
-include("chat.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("daily.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").

-include("guild_boss.hrl").
-include("designation.hrl").

make_record(sql_guild, [Id, Name, Tenet, Announce, ModifyTimes, ModifyTime, ChiefId, ChiefName, Lv, Realm,
        GFunds, GrowthVal, GActivity, DunScore, CreateTime, ApproveType, AutoApproveLv, AutoApprovePower, DisbandWarnningTime, CReName, CReNameTime]) ->
    RealAnnounce = case Announce == <<>> of
        true -> utext:get(4000003);
        false -> Announce
    end,
    #guild{
        id = Id
        , name = Name
        , name_upper = string:to_upper(util:make_sure_list(Name))
        , tenet = Tenet
        , announce = RealAnnounce
        , modify_times = ModifyTimes
        , modify_time = ModifyTime
        , chief_id = ChiefId
        , chief_name = ChiefName
        , lv = Lv
        , realm = Realm
        , gfunds = GFunds
        , growth_val = GrowthVal
        , gactivity = GActivity
        , dun_score = DunScore
        , create_time = CreateTime
        , approve_type = ApproveType
        , auto_approve_lv = AutoApproveLv
        , auto_approve_power = AutoApprovePower
        , disband_warnning_time = DisbandWarnningTime
        , c_rename = CReName
        , c_rename_time = CReNameTime
    };

make_record(sql_guild_member, [Id, GuildId, GuildName, Position, Donate, HistoricalDonate, DepotScore, CreateTime]) ->
    #guild_member{
        id = Id
        , guild_id = GuildId
        , guild_name = GuildName
        , position = Position
        , donate = Donate
        , historical_donate = HistoricalDonate
        , depot_score = DepotScore
        , create_time = CreateTime
    };

make_record(guild_member, [Id, GuildId, GuildName, Position, _Donate, CreateTime, Figure, OnlineFlag,
        LastLoginTime, LastLogoutTime, CombatPower, HCombatPower]) ->
    case db:get_row(io_lib:format(?sql_guild_member_select_by_role_id, [Id])) of
        [Donate, HistoricalDonate, DepotScore] -> ok; % 以前保留的数据
        _ -> {Donate, HistoricalDonate, DepotScore} = {0, 0, 0}
    end,
    #guild_member{
        id = Id
        , figure = Figure#figure{guild_id=GuildId, guild_name = GuildName}
        , guild_id = GuildId
        , guild_name = GuildName
        , position = Position
        , donate = Donate
        , historical_donate = HistoricalDonate
        , online_flag = OnlineFlag
        , last_login_time = LastLoginTime
        , last_logout_time = LastLogoutTime
        , combat_power = CombatPower
        , h_combat_power = HCombatPower
        , depot_score = DepotScore
        , create_time = CreateTime
    };

make_record(guild_apply, [RoleId, GuildId, CreateTime]) ->
    #guild_apply{
        key = {RoleId, GuildId}
        , role_id = RoleId
        , guild_id = GuildId
        , create_time = CreateTime
    };

make_record(guild_merge, [ApplyGId, TargetGId, MasterGId, Status, ApplyTime, AgreeTime]) ->
    #guild_merge{
        key = {ApplyGId, TargetGId},
        apply_gid = ApplyGId,
        target_gid = TargetGId,
        master_gid = MasterGId,
        status = Status,
        apply_time = ApplyTime,
        agree_time = AgreeTime
    }.

%% ----------------------------------------------------
%% 进程启动初始化
%% ----------------------------------------------------

%% 初始化
init() ->
    init_guild_and_member(),
    init_guild_apply(),
    init_guild_merge(),
    init_guild_depot(),
    init_guild_skill().

%% 初始公会和成员
init_guild_and_member() ->
    Sql = io_lib:format(?sql_guild_select_all, []),
    List = db:get_all(Sql),
    GuildMap = make_guild_map(List, #{}),
    NewGuildMap = init_member_and_make_guild(maps:to_list(GuildMap), GuildMap),
    lib_guild_data:save_guild_map(NewGuildMap).

%% 初始化公会Map
make_guild_map([], GuildMap) -> GuildMap;
make_guild_map([T|L], GuildMap) ->
    Guild = make_record(sql_guild, T),
    NewGuildMap = maps:put(Guild#guild.id, Guild, GuildMap),
    make_guild_map(L, NewGuildMap).

%% 初始化成员和组装Guild
init_member_and_make_guild([], GuildMap) -> GuildMap;
init_member_and_make_guild([{GuildId, Guild}|L], GuildMap) ->
    case init_guild_member(GuildId, Guild) of
        [] -> NewGuildMap = maps:remove(GuildId, GuildMap);
        GuildMemberList ->
            NowTime = utime:unixtime(),
            {MemberNum, CombatPower} = calc_guild_data_by_member_list(GuildMemberList, NowTime, {0, 0}),
            CombatPowerTen = lib_guild_util:count_guild_combat_power_ten(GuildMemberList, NowTime),
            %% 初始化声望
            mod_guild_prestige:init_guild_member_prestige([GuildId, [{MemberId, Position}||#guild_member{id = MemberId, position = Position} <- GuildMemberList]]),
            NewGuild = Guild#guild{
                member_num = MemberNum
                , combat_power = CombatPower
                , combat_power_ten = CombatPowerTen
                },
            NewGuildMap = maps:put(GuildId, NewGuild, GuildMap)
    end,
    init_member_and_make_guild(L, NewGuildMap).

%% 初始化成员
init_guild_member(GuildId, _Guild) ->
    Sql = io_lib:format(?sql_guild_member_select_by_guild_id, [GuildId]),
    List = db:get_all(Sql),
    F = fun([Id, GuildName, Position, Donate, HistoricalDonate, DepotScore, CreateTime]) ->
        GuildMemberTmp = make_record(sql_guild_member, [Id, GuildId, GuildName, Position, Donate, HistoricalDonate, DepotScore, CreateTime]),
        case lib_role:get_figure_on_db(Id) of
            [] -> Figure = #figure{};
            Figure -> ok
        end,
        [_OnlineFlag, LastLoginTime, LastLogoutTime, LastLogoutCombatPower, HCombatPower] = lib_role:get_role_show_other_info(Id),
        %% 如果玩家最后登录时间>最后登出时间,表示玩家没有正常登出,重置最后登出时间为最后登录时间
        RealLastLogoutTime = ?IF(LastLoginTime > LastLogoutTime, LastLoginTime, LastLogoutTime),
        GuildMember = GuildMemberTmp#guild_member{
            figure = Figure
            , online_flag = ?ONLINE_OFF
            , last_login_time = LastLoginTime
            , last_logout_time = RealLastLogoutTime
            , combat_power = LastLogoutCombatPower
            , h_combat_power = HCombatPower
            },
        lib_guild_data:update_guild_member(GuildMember),
        GuildMember
    end,
    GuildMemberList = lists:map(F, List),
    GuildMemberList.

%% 根据成员信息计算公会数据
calc_guild_data_by_member_list([], _NowTime, Result) -> Result;
calc_guild_data_by_member_list([GuildMember|T], NowTime, {MemberNum, SumCombatPower}) ->
    #guild_member{
        last_logout_time = LastLogoutTime,
        combat_power = CombatPower
        } = GuildMember,
    NewMemberNum = MemberNum + 1,
    NewSumCombatPower = case NowTime - LastLogoutTime < ?CAL_GUILD_POWER_VAILD_TIME of
        true -> SumCombatPower + CombatPower;
        false -> SumCombatPower
    end,
    calc_guild_data_by_member_list(T, NowTime, {NewMemberNum, NewSumCombatPower}).

%% ----------------------------------------------------
%% 其他初始化
%% ----------------------------------------------------

%% 初始化公会请求
init_guild_apply() ->
    Sql = io_lib:format(?sql_guild_apply_select, []),
    List = db:get_all(Sql),
    % 公会请求
    F = fun([RoleId, GuildId, CreateTime], Map) ->
        GuildApply = make_record(guild_apply, [RoleId, GuildId, CreateTime]),
        maps:put({RoleId, GuildId}, GuildApply, Map)
    end,
    Map = lists:foldl(F, maps:new(), List),
    put(?P_GUILD_APPLY, Map),
    % 公会的玩家id请求列表
    F2 = fun({RoleId, GuildId}, _Apply, TmpMap) ->
        MemberIdList = maps:get(GuildId, TmpMap, []),
        case lists:member(RoleId, MemberIdList) of
            false -> NewMeberIdList = [RoleId|MemberIdList];
            true -> NewMeberIdList = MemberIdList
        end,
        maps:put(GuildId, NewMeberIdList, TmpMap)
    end,
    ApplyGuildMap = maps:fold(F2, maps:new(), Map),
    put(?P_GUILD_APPLY_GUILD, ApplyGuildMap),
    Map.

%% 初始化公会合并
init_guild_merge() ->
    DbList = lib_guild_data:db_guild_merge_select(),
    GuildMerges = lists:foldl(fun init_guild_merge/2, [], DbList),
    lib_guild_data:set_guild_merges(GuildMerges),
    ok.

init_guild_merge(Args, AccL) ->
    GuildMerge = make_record(guild_merge, Args),
    [GuildMerge | AccL].

%% 初始化职位权限
%% 职位权限 Value:#{Pos = #{PermissionType=IsAllow} }
init_position_permission_map(GuildId) ->
    % 读配置初始化
    F = fun(Position, TmpMap) ->
        case data_guild:get_guild_pos_cfg(Position) of
            [] -> PermissionList = [];
            #guild_pos_cfg{permission_list = PermissionList} -> ok
        end,
        PermissionTypeMap = maps:get(Position, TmpMap, #{}),
        F2 = fun(PermissionType, TmpPermissionTypeMap) -> maps:put(PermissionType, ?IS_ALLOW_YES, TmpPermissionTypeMap) end,
        NewPermissionTypeMap = lists:foldl(F2, PermissionTypeMap, PermissionList),
        maps:put(Position, NewPermissionTypeMap, TmpMap)
    end,
    Map = lists:foldl(F, maps:new(), ?POS_LIST),
    % 数据库初始化
    Sql = io_lib:format(?sql_position_permission_select, [GuildId]),
    List = db:get_all(Sql),
    F3 = fun([Position, PermissionType, IsAllow], TmpMap) ->
        PermissionTypeMap = maps:get(Position, TmpMap, #{}),
        NewPermissionTypeMap = maps:put(PermissionType, IsAllow, PermissionTypeMap),
        maps:put(Position, NewPermissionTypeMap, TmpMap)
    end,
    NewMap = lists:foldl(F3, Map, List),
    put(?P_POS_PERMISSION(GuildId), NewMap),
    NewMap.

%% 初始化职位名字
%% 职位名字 Value:#{Pos = PositionName}
init_position_name_map(GuildId) ->
    % 读配置初始化
    F = fun(Position, TmpMap) ->
        case data_guild:get_guild_pos_cfg(Position) of
            [] -> PositionName = "";
            #guild_pos_cfg{name = PositionName} -> ok
        end,
        maps:put(Position, util:make_sure_binary(PositionName), TmpMap)
    end,
    Map = lists:foldl(F, maps:new(), ?POS_LIST),
    % 数据库初始化
    Sql = io_lib:format(?sql_position_name_select, [GuildId]),
    List = db:get_all(Sql),
    F2 = fun([Position, PositionName], TmpMap) -> maps:put(Position, util:make_sure_binary(PositionName), TmpMap) end,
    NewMap = lists:foldl(F2, Map, List),
    put(?P_POS_NAME(GuildId), NewMap),
    NewMap.

%% 初始化公会仓库
init_guild_depot() ->
    GuildMap = lib_guild_data:get_guild_map(),
    lib_guild_depot:init(maps:keys(GuildMap)).

%% 初始化公会技能
init_guild_skill() ->
    GuildMap = lib_guild_data:get_guild_map(),
    lib_guild_skill:init(maps:keys(GuildMap)).

%% ----------------------------------------------------
%% 操作
%% ----------------------------------------------------

%% 申请加入公会
apply_join_guild(RoleId, RoleInfoMap, GuildId) ->
    % ApplyType 0:无;1:审批中;2:自动加入
    case check_apply_join_guild(RoleId, RoleInfoMap, GuildId) of
        {false, ErrorCode} -> ApplyType = 0;
        {true, add_guild_apply} ->
            ErrorCode = ?SUCCESS, ApplyType = 1,
            lib_guild_data:add_guild_apply_on_db_and_p(RoleId, GuildId),
            send_guild_apply_red_point(GuildId);
        {true, auto_join, Guild, Position} ->
            case auto_join(RoleId, RoleInfoMap, Guild, Position) of
                {false, ErrorCode} -> ApplyType = 0;
                {ok, _GuildMember} -> ErrorCode = ?SUCCESS, ApplyType = 2
            end
    end,
    ?PRINT("apply_join_guild ~p~n", [ErrorCode]),
    {ok, BinData} = pt_400:write(40002, [ErrorCode, GuildId, ApplyType]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 检查申请加入公会
check_apply_join_guild(RoleId, RoleInfoMap, GuildId) when is_integer(GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    check_apply_join_guild(RoleId, RoleInfoMap, Guild);
check_apply_join_guild(RoleId, RoleInfoMap, Guild) when is_record(Guild, guild) ->
    #guild{id = GuildId} = Guild,
    IsOnGuild = is_on_guild(RoleId),
    IsApply = is_apply(RoleId, GuildId),
    if
        IsOnGuild -> {false, ?ERRCODE(err400_on_guild_not_to_apply)};
        IsApply -> {false, ?ERRCODE(err400_is_apply_this_guild)};
        true ->
            #guild{
                lv = GuildLv, approve_type = ApproveType, auto_approve_lv = AutoApproveLv,
                auto_approve_power = AutoApprovePower, member_num = MemberNum, realm = GuildRealm
                } = Guild,
            #{figure:=Figure, combat_power:=CombatPower} = RoleInfoMap,
            #figure{lv = Lv, realm = _Realm} = Figure,
            MemberCapacity = data_guild_m:get_guild_member_capacity(GuildLv),
            ApplyMemberIdList = lib_guild_data:get_guild_apply_member_id_lsit_by_guild_id(GuildId),
            LenLimit = data_guild_m:get_config(guild_apply_len_limit),
            SanctuaryGuildList = lib_guild_data:get_sanctuary_top3_guild_list(),
            IsSanctuaryGuild = lists:member(GuildId, SanctuaryGuildList),
            AddSanctuaryLimit = data_sanctuary:get_kv(add_guild_member_limit),
            if
                % Realm =/= GuildRealm -> {false, ?ERRCODE(err400_apply_realm_not_same)};
                % 是否已经满人
                MemberNum >= MemberCapacity andalso IsSanctuaryGuild == false -> {false, ?ERRCODE(err400_member_enough)};
                % 是否已经满人
                MemberNum >= MemberCapacity + AddSanctuaryLimit andalso IsSanctuaryGuild == true -> {false, ?ERRCODE(err400_member_enough)};
                % 判断申请列表是否足够人
                ApproveType == ?APPROVE_TYPE_MANUAL andalso length(ApplyMemberIdList) >= LenLimit -> {false, ?ERRCODE(err400_guild_apply_len_limit)};
                Lv < AutoApproveLv orelse CombatPower < AutoApprovePower -> {false, ?ERRCODE(err400_apply_condition_err)};
                ApproveType == ?APPROVE_TYPE_MANUAL -> {true, add_guild_apply};
                % 是否符合自动加入
                ApproveType == ?APPROVE_TYPE_AUTO andalso Lv >= AutoApproveLv andalso CombatPower >= AutoApprovePower ->
                    {true, auto_join, Guild, ?POS_NORMAIL};
                true -> {false, ?ERRCODE(err400_refuse_apply)}
            end
    end;
check_apply_join_guild(_, _, _) -> {false, ?ERRCODE(err400_this_guild_not_exist_to_apply)}.

%% 自动加入
auto_join(RoleId, RoleInfoMap, GuildId, Position) when is_integer(GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    auto_join(RoleId, RoleInfoMap, Guild, Position);
auto_join(RoleId, RoleInfoMap, Guild, Position) when is_record(Guild, guild) ->
    #guild{id = GuildId, chief_id = ChiefId, name = GuildName, member_num = _MemberNum, disband_warnning_time = _DisbandWarnningTime} = Guild,
    #{
        figure:=Figure, combat_power:=CombatPower, hcombat_power:=HCombatPower, last_login_time:=LastLoginTime,
        online_flag:=OnlineFlag, last_logout_time:=LastLogoutTime
    } = RoleInfoMap,
    Donate = 0, CreateTime = utime:unixtime(),
    GuildMember = make_record(guild_member, [RoleId, GuildId, GuildName, Position, Donate, CreateTime,
            Figure, OnlineFlag, LastLoginTime, LastLogoutTime, CombatPower, HCombatPower]),
    F = fun() ->
        lib_guild_data:db_guild_apply_delete_by_role_id(RoleId),
        lib_guild_data:db_guild_member_replace(GuildMember),
        %% 如果公会存在解散警告且公会人数达到解除警告要求要清除警告时间
        % case DisbandWarnningTime > 0 andalso MemberNum + 1 >= ?AUTO_DISBAND_NEED_NUM of
        %     true ->
        %         db:execute(io_lib:format(?sql_guild_update_disband_warnning_time, [0, GuildId]));
        %     false -> skip
        % end,
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            ChiefMember = lib_guild_data:get_guild_member(GuildId, ChiefId),
            lib_guild_data:add_guild_member(GuildMember),
            lib_guild_data:delete_guild_apply_by_role_id(RoleId),
            NewGuild = lib_guild_data:get_guild_by_id(GuildId),
            lib_guild_api:join_guild(?GEVENT_JOIN_GUILD, NewGuild, ChiefMember, GuildMember),
            lib_guild_create_act:update_act_reward_status(NewGuild),
            ?PRINT("auto_join ~p~n", [succ]),
            {ok, GuildMember};
        _Error ->
            ?ERR("_Error: ~p ~n",[_Error]),
            {false, ?FAIL}
    end;
auto_join(_, _, _, _) -> {false, ?FAIL}.

%% 是否在公会
is_on_guild(RoleId) ->
    case get(?P_MEMBER_GUILD_ID) of
        undefined -> MemberGuildIdMap = maps:new();
        MemberGuildIdMap -> ok
    end,
    maps:is_key(RoleId, MemberGuildIdMap).

%% 是否申请过本公会
is_apply(RoleId, GuildId) ->
    case lib_guild_data:get_guild_apply(RoleId, GuildId) of
        #guild_apply{} -> true;
        _ -> false
    end.

%% 海投简历
apply_join_guild_multi(RoleId, RoleInfoMap) ->
    GuildMap = lib_guild_data:get_guild_map(),
    case filter_apply_join_guild(maps:values(GuildMap), RoleId, RoleInfoMap, [], []) of
        {add_guild_apply, FilterList, ErrList} ->
            GuildId = 0, ApplyType = 1,
            ExcludeList = [?ERRCODE(err400_apply_condition_err), ?ERRCODE(err400_member_enough), ?ERRCODE(err400_guild_apply_len_limit)],
            NewErrList = [ErrCode || ErrCode <- ErrList, lists:member(ErrCode, ExcludeList) == false],
            case FilterList == [] andalso NewErrList == [] of
                true -> Code = ?ERRCODE(err400_onekey_apply_condition_err);
                _ -> Code = ?SUCCESS
            end,
            % Len = data_guild_m:get_config(guild_apply_multi_len),
            % SubFilterList = lists:sublist(FilterList, Len),
            [lib_guild_data:add_guild_apply_on_db_and_p(RoleId, TmpGuildId)||TmpGuildId<-FilterList],
            [send_guild_apply_red_point(TmpGuildId)||TmpGuildId<-FilterList];
        {auto_join, Guild, Position} ->
            Code = ?SUCCESS,
            GuildId = Guild#guild.id,
            ApplyType = 2,
            auto_join(RoleId, RoleInfoMap, Guild, Position)
    end,
    {ok, BinData} = pt_400:write(40003, [Code, GuildId, ApplyType]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 筛选能请求加入的公会
filter_apply_join_guild([], _RoleId, _RoleInfoMap, Result, ErrList) -> {add_guild_apply, Result, ErrList};
filter_apply_join_guild([Guild|L], RoleId, RoleInfoMap, Result, ErrList) ->
    case check_apply_join_guild(RoleId, RoleInfoMap, Guild) of
        {false, _ErrorCode} ->
            filter_apply_join_guild(L, RoleId, RoleInfoMap, Result, [_ErrorCode|ErrList]);
        {true, add_guild_apply} -> filter_apply_join_guild(L, RoleId, RoleInfoMap, [Guild#guild.id|Result], ErrList);
        {true, auto_join, Guild, Position} -> {auto_join, Guild, Position}
    end.

%% 审批公会请求
%% @param Type 0拒绝;1允许
approve_guild_apply(RoleId, ApplyRoleId, ApplyRoleInfoMap, Type) ->
    case check_approve_guild_apply(RoleId, ApplyRoleId) of
        {false, ErrorCode} -> skip;
        {true, #guild{id = GuildId} = Guild} ->
            case Type == 0 of
                true ->
                    ErrorCode = ?SUCCESS,
                    lib_guild_data:delete_guild_apply_by_key_on_db_and_p(ApplyRoleId, GuildId);
                false ->
                    case agree_guild_apply(ApplyRoleId, ApplyRoleInfoMap, Guild) of
                        {ok, ErrorCode} ->
                            % 推送当前公会成员列表给操作者
                            mod_guild:send_guild_member_short_info(RoleId, GuildId, 0, 0, 0, 0);
                        {false, ErrorCode} -> skip
                    end
            end,
            broadcast_guild_apply_list(GuildId)
    end,
    {ok, BinData} = pt_400:write(40009, [ErrorCode, Type, ApplyRoleId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

check_approve_guild_apply(RoleId, ApplyRoleId) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_approver_not_on_guild)};
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_approver_not_on_guild)};
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            PermissionList = get_position_permission_list(GuildId, Position),
            IsApprove = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
            GuildApply = lib_guild_data:get_guild_apply(ApplyRoleId, GuildId),
            if
                is_record(GuildApply, guild_apply) == false -> {false, ?ERRCODE(err400_not_guild_apply)};
                IsApprove == false -> {false, ?ERRCODE(err400_not_permission_to_approve)};
                true -> {true, Guild}
            end
    end.

%% 同意公会请求
agree_guild_apply(RoleId, RoleInfoMap, Guild) ->
    case check_agree_guild_apply(Guild, RoleId, RoleInfoMap) of
        {false, ErrorCode} -> {false, ErrorCode};
        {true, Position} -> agree_guild_apply(RoleId, RoleInfoMap, Guild, Position)
    end.

agree_guild_apply(RoleId, RoleInfoMap, Guild, Position) ->
    #guild{id = GuildId, chief_id = ChiefId, name = GuildName, member_num = _MemberNum, disband_warnning_time = _DisbandWarnningTime} = Guild,
    #{figure:=Figure, combat_power:=CombatPower, hcombat_power:=HCombatPower, last_login_time:=LastLoginTime, online_flag:=OnlineFlag, last_logout_time:=LastLogoutTime} = RoleInfoMap,
    Donate = 0, CreateTime = utime:unixtime(),
    GuildMember = make_record(guild_member, [RoleId, GuildId, GuildName, Position, Donate, CreateTime,
        Figure, OnlineFlag, LastLoginTime, LastLogoutTime, CombatPower, HCombatPower]),
    F = fun() ->
        lib_guild_data:db_guild_apply_delete_by_role_id(RoleId),
        lib_guild_data:db_guild_member_replace(GuildMember),
        %% 如果公会存在解散警告且公会人数达到解除警告要求要清除警告时间
        % case DisbandWarnningTime > 0 andalso MemberNum + 1 >= ?AUTO_DISBAND_NEED_NUM of
        %     true ->
        %         db:execute(io_lib:format(?sql_guild_update_disband_warnning_time, [0, GuildId]));
        %     false -> skip
        % end,
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            ChiefMember = lib_guild_data:get_guild_member(GuildId, ChiefId),
            lib_guild_data:add_guild_member(GuildMember),
            lib_guild_data:delete_guild_apply_by_role_id(RoleId),
            NewGuild = lib_guild_data:get_guild_by_id(GuildId),
            lib_guild_create_act:update_act_reward_status(NewGuild),
            lib_guild_api:join_guild(?GEVENT_JOIN_GUILD, NewGuild, ChiefMember, GuildMember),
            {ok, ?SUCCESS};
        _Error ->
            ?ERR("_Error: ~p ~n",[_Error]),
            {false, ?FAIL}
    end.

check_agree_guild_apply(Guild, RoleId, _RoleInfoMap) ->
    #guild{id = GuildId, lv = GuildLv, member_num = MemberNum} = Guild,
    MemberCapacity = data_guild_m:get_guild_member_capacity(GuildLv),
    SanctuaryGuildList = lib_guild_data:get_sanctuary_top3_guild_list(),
    IsSanctuaryGuild = lists:member(GuildId, SanctuaryGuildList),
    AddSanctuaryLimit = data_sanctuary:get_kv(add_guild_member_limit),
    case (IsSanctuaryGuild == false andalso MemberNum >= MemberCapacity) orelse (IsSanctuaryGuild == true andalso MemberNum >= MemberCapacity+AddSanctuaryLimit) of
        true ->
            {false, ?ERRCODE(err400_member_enough)};
        false ->
            case is_on_guild(RoleId) of
                false ->
                    {true, ?POS_NORMAIL};
                _ ->
                    {false, ?ERRCODE(err400_other_have_guild_not_to_join)}
            end
    end.

%% 全部批准入会
approve_all_guild_apply_on_this_guild(RoleId) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_approver_not_on_guild);
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_approver_not_on_guild);
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            PermissionList = get_position_permission_list(GuildId, Position),
            IsApprove = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
            if
                IsApprove == false -> ErrorCode = ?ERRCODE(err400_no_permission);
                true ->
                    ErrorCode = ?SUCCESS,
                    % Sql = io_lib:format(?sql_guild_apply_delete_by_guild_id, [GuildId]),
                    % db:execute(Sql),
                    % lib_guild_data:delete_guild_apply_by_guild_id(GuildId),
                    ApplyRoleIdList = lib_guild_data:get_guild_apply_member_id_lsit_by_guild_id(GuildId),
                    case ApplyRoleIdList =/= [] of
                        true ->
                            approve_guild_apply_list(ApplyRoleIdList, RoleId),
                            % 广播新的申请列表
                            broadcast_guild_apply_list(GuildId),
                            % 推送当前公会成员列表给操作者
                            mod_guild:send_guild_member_short_info(RoleId, GuildId, 0, 0, 0, 0);
                            % send_guild_apply_red_point(GuildId);
                        false -> skip
                    end
            end
    end,
    {ok, BinData} = pt_400:write(40016, [ErrorCode, 1]),
    lib_server_send:send_to_uid(RoleId, BinData).

approve_guild_apply_list([], _RoleId) -> skip;
approve_guild_apply_list([ApplyRoleId|L], RoleId) ->
    case check_approve_guild_apply(RoleId, ApplyRoleId) of
        {false, _ErrorCode} -> skip;
        {delete} -> skip;
        {true, Guild} ->
            case lib_role:get_role_show(ApplyRoleId) of
                [] -> skip;
                RoleShow ->
                    ApplyRoleInfoMap = lib_guild:make_role_map(RoleShow),
                    _ErrorCode = agree_guild_apply(ApplyRoleId, ApplyRoleInfoMap, Guild)
                    % case ErrorCode == ?SUCCESS of
                    %     true ->
                    %         {ok, BinData} = pt_400:write(40011, [ErrorCode, ApplyRoleId]),
                    %         lib_server_send:send_to_uid(RoleId, BinData);
                    %     false -> skip
                    % end
            end
    end,
    approve_guild_apply_list(L, RoleId).

%% 广播刷新公会申请请求(目的为消除红点)
broadcast_guild_apply_list(GuildId) ->
    ApplyList = lib_guild_mod:get_guild_apply_list(GuildId),
    Mbs = lib_guild_data:get_guild_member_by_permission([?PERMISSION_APPROVE_APPLY], GuildId),
    [lib_server_send:send_to_uid(RoleId, pt_400, 40008, [ApplyList]) || #guild_member{id = RoleId} <- Mbs].

%% 发送个人权限列表
send_role_permission_list(RoleId) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> PermissionList = [];
        is_record(GuildMember, guild_member) == false -> PermissionList = [];
        true ->
            #guild{id = GuildId} = Guild,
            #guild_member{position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position)
    end,
    {ok, BinData} = pt_400:write(40021, [PermissionList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 任命职位
appoint_position(RoleId, AppointeeId, TargetPosition) ->
    if
        TargetPosition == ?POS_CHIEF ->
            appoint_position_to_chief(RoleId, AppointeeId);
        true ->
            appoint_position_to_other(RoleId, AppointeeId, TargetPosition)
    end.

appoint_position_to_chief(RoleId, AppointeeId) ->
    case check_bulk_appoint_position_to_chief(RoleId, AppointeeId) of
        {false, ErrorCode} -> ok;
        {ok, Guild, ApGuildMember, ChiefMember} ->
            ErrorCode = bulk_appoint_position_to_chief_done(Guild, ApGuildMember, ChiefMember, ?MANUAL_APPOINT)
    end,
    {ok, BinData} = pt_400:write(40013, [ErrorCode, AppointeeId, ?POS_CHIEF]),
    lib_server_send:send_to_uid(RoleId, BinData).

check_bulk_appoint_position_to_chief(RoleId, AppointeeId) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ApGuildMember = lib_guild_data:get_guild_member_by_role_id(AppointeeId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_appoint)};
        is_record(ApGuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_appointed)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        GuildMember#guild_member.guild_id =/= ApGuildMember#guild_member.guild_id ->
            {false, ?ERRCODE(err400_not_same_guild_to_appoint)};
        true ->
            #guild_member{position = Position} = GuildMember,
            #guild{chief_id = ChiefId} = Guild,
            if
                % 只有会长能任命
                Position =/= ?POS_CHIEF -> {false, ?ERRCODE(err400_not_allow_appoint)};
                % 不能重复任命会长
                ChiefId == AppointeeId -> {false, ?ERRCODE(err400_not_allow_appoint_again)};
                true -> {ok, Guild, ApGuildMember, GuildMember}
            end
    end.

%% 任命会长
bulk_appoint_position_to_chief_done(Guild, ApGuildMember, ChiefMember, AppointType) ->
    #guild{id = GuildId, chief_id = ChiefId} = Guild,
    % 新会长职位
    #guild_member{id = ApRoleId, figure = ApFigure} = ApGuildMember,
    #figure{name = ApName} = ApFigure,
    NewApPosition = ?POS_CHIEF,
    % 旧会长职位
    NewChiefPosition = ?POS_NORMAIL,
    F = fun() ->
        Sql = io_lib:format(?sql_guild_update_chief, [ApRoleId, util:make_sure_binary(ApName), GuildId]),
        db:execute(Sql),
        lib_guild_data:db_guild_member_update_position(ApRoleId, NewApPosition),
        lib_guild_data:db_guild_member_update_position(ChiefId, NewChiefPosition),
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            ErrorCode = ?SUCCESS,
            NewApGuildMember = ApGuildMember#guild_member{position = NewApPosition, figure = ApFigure#figure{position = NewApPosition}},
            lib_guild_data:update_guild_member(NewApGuildMember),
            CheifFigure = ChiefMember#guild_member.figure,
            NewChiefMember = ChiefMember#guild_member{position = NewChiefPosition, figure = CheifFigure#figure{position = NewChiefPosition}},
            lib_guild_data:update_guild_member(NewChiefMember),
            NewGuild = Guild#guild{chief_id = ApRoleId, chief_name = ApName},
            lib_guild_data:update_guild(NewGuild),
            lib_guild_create_act:update_act_reward_status(NewGuild),
            % 推送当前公会成员列表给任命者
            mod_guild:send_guild_member_short_info(ChiefId, GuildId, 0, 0, 0, 0),
            % 接口
            lib_guild_api:change_guild_member(?GEVENT_APPOINT_POSITION_TO_CHIEF, [NewGuild, ChiefMember, ApGuildMember, NewApGuildMember, AppointType]),
            lib_guild_api:change_guild_member(?GEVENT_BECOME_NORAML_AF_APPOINT_OTHER_TO_CHIEF, [NewGuild, ChiefMember, NewChiefMember]);
        _Error ->
            ?ERR("_Error: ~p ~n",[_Error]),
            ErrorCode = ?FAIL
    end,
    ErrorCode.

appoint_position_to_other(RoleId, AppointeeId, TargetPosition) ->
    case check_appoint_position_to_other(RoleId, AppointeeId, TargetPosition) of
        {false, ErrorCode} -> ok;
        {ok, GuildMember, ApGuildMember} ->
            ErrorCode = ?SUCCESS,
            do_appoint_position_to_other(GuildMember, ApGuildMember, TargetPosition)
    end,
    {ok, BinData} = pt_400:write(40013, [ErrorCode, AppointeeId, TargetPosition]),
    lib_server_send:send_to_uid(RoleId, BinData).

check_appoint_position_to_other(RoleId, AppointeeId, TargetPosition) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ApGuildMember = lib_guild_data:get_guild_member_by_role_id(AppointeeId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    RightPositionList = ?BE_APPOINT_POS_LIST,
    IsRightPosition = lists:member(TargetPosition, RightPositionList),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_appoint)};
        is_record(ApGuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_appointed)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        GuildMember#guild_member.guild_id =/= ApGuildMember#guild_member.guild_id ->
            {false, ?ERRCODE(err400_not_same_guild_to_appoint)};
        IsRightPosition == false -> {false, ?ERRCODE(err400_not_allow_appoint)};
        ApGuildMember#guild_member.position == TargetPosition -> {false, ?ERRCODE(err400_not_allow_appoint_again)};
        true ->
            #guild{id = GuildId, lv = _GuildLv} = Guild,
            PositionNumList = get_position_num_list(GuildId),
            case lists:keyfind(TargetPosition, 1, PositionNumList) of
                false -> TargetPositionNum = 0;
                {TargetPosition, TargetPositionNum} -> ok
            end,
            MaxNum = data_guild_m:get_position_max_num(TargetPosition),
            #guild_member{position = Position} = GuildMember,
            PositionNo = data_guild_m:get_position_no(Position),
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsEnableAppoint = lists:member(?PERMISSION_APPOINT_POS, PermissionList),
            % IsEnableAppoint = data_guild_m:is_enable_appoint_position(Position),
            #guild_member{position = ApPosition} = ApGuildMember,
            ApPositionNo = data_guild_m:get_position_no(ApPosition),
            if
                % 只有部分职位可以允许任命职位
                IsEnableAppoint == false -> {false, ?ERRCODE(err400_not_allow_appoint)};
                TargetPosition =/= ?POS_NORMAIL andalso TargetPositionNum >= MaxNum ->
                    {false, ?ERRCODE(err400_this_position_full)};
                % 只能操作低于自己职位的
                PositionNo =< ApPositionNo andalso Position =/= ?POS_CHIEF ->
                    {false, ?ERRCODE(err400_not_allow_appoint)};
                true -> {ok, GuildMember, ApGuildMember}
            end
    end.

%% 普通职位转换
do_appoint_position_to_other(OperatorGuildMember, ApGuildMember, TargetPosition) ->
    #guild_member{id = ApRoleId, guild_id = GuildId, figure = ApFigure} = ApGuildMember,
    lib_guild_data:db_guild_member_update_position(ApRoleId, TargetPosition),
    NewApGuildMember = ApGuildMember#guild_member{position = TargetPosition, figure = ApFigure#figure{position = TargetPosition}},
    lib_guild_data:update_guild_member(NewApGuildMember),
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    % 推送当前公会成员列表给任命者
    mod_guild:send_guild_member_short_info(OperatorGuildMember#guild_member.id, GuildId, 0, 0, 0, 0),
    lib_guild_api:change_guild_member(?GEVENT_APPOINT_POSITION_TO_OTHER,
        [Guild, OperatorGuildMember, ApGuildMember, NewApGuildMember]),
    lib_guild_create_act:update_act_reward_status(Guild),
    ok.

%% 自动任命为会长
auto_appoint_to_chief(DelaySec) ->
    GuildMap = lib_guild_data:get_guild_map(),
    spawn(fun() ->
        timer:sleep(DelaySec),
        F = fun(_K, Guild, _Acc) ->
            util:multiserver_delay(0.5, mod_guild, auto_appoint_to_chief_by_guild_id, [Guild#guild.id]),
            ok
        end,
        maps:fold(F, [], GuildMap)
    end),
    ok.

auto_appoint_to_chief_by_guild_id(GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    ChiefGuildMember = lib_guild_data:get_chief(GuildId),
    TimeAfChiefLeave = data_guild_m:get_config(auto_to_chief_af_chief_leave_time),
    if
        is_record(Guild, guild) == false -> skip;
        is_record(ChiefGuildMember, guild_member) == false -> do_auto_appoint_to_chief_by_guild_id(Guild);
        true ->
            #guild_member{last_logout_time = LastLogoutTime, online_flag = OnlineFlag} = ChiefGuildMember,
            Unixtime = utime:unixtime(),
            if
                LastLogoutTime == 0 orelse Unixtime - LastLogoutTime < TimeAfChiefLeave orelse OnlineFlag == 1 -> skip;
                true -> do_auto_appoint_to_chief_by_guild_id(Guild)
            end
    end.

do_auto_appoint_to_chief_by_guild_id(Guild) ->
    #guild{id = GuildId, chief_id = ChiefId} = Guild,
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    Time = data_guild_m:get_config(auto_to_chief_max_offline_time_lim),
    Unixtime = utime:unixtime(),
    F = fun(_K, GuildMember, List) ->
        #guild_member{position = Position, last_logout_time = LastLogoutTime, online_flag = OnlineFlag} = GuildMember,
        case Position =/= ?POS_CHIEF andalso (Unixtime - LastLogoutTime < Time orelse OnlineFlag == 1 ) of
            true -> [GuildMember|List];
            false -> List
        end
    end,
    GuildMemberList = maps:fold(F, [], GuildMemberMap),
    F2 = fun(GuildMemberA, GuildMemberB) ->
        #guild_member{position = PositionA, historical_donate = HistoricalDonateA} = GuildMemberA,
        #guild_member{position = PositionB, historical_donate = HistoricalDonateB} = GuildMemberB,
        NoA = data_guild_m:get_position_no(PositionA),
        NoB = data_guild_m:get_position_no(PositionB),
        case NoA == NoB of
            true -> HistoricalDonateA > HistoricalDonateB;
            false -> NoA > NoB
        end
    end,
    SortGuildMemberList = lists:sort(F2, GuildMemberList),
    ChiefGuildMember = lib_guild_data:get_guild_member_by_role_id(ChiefId),
    if
        is_record(ChiefGuildMember, guild_member) == false -> skip;
        SortGuildMemberList == [] ->
            skip;
        true ->
            ApGuildMember = hd(SortGuildMemberList),
            bulk_appoint_position_to_chief_done(Guild, ApGuildMember, ChiefGuildMember, ?AUTO_APPOINT)
    end.

%% 研究技能
research_skill(RoleId, SkillId) ->
    case lib_guild_skill:check_research_skill(RoleId, SkillId) of
        {false, ErrorCode} ->
            {ok, BinData} = pt_400:write(40000, [ErrorCode]),
            lib_server_send:send_to_uid(RoleId, BinData);
        {ok, Guild, ResearchCfg} ->
            #guild_skill_research_cfg{research_cost = ResearchCost} = ResearchCfg,
            case catch lib_guild_skill:research_cost(ResearchCost, RoleId, Guild) of
                {ok, NewGuild} ->
                    lib_guild_data:update_guild(NewGuild),
                    {ok, PreResearchLv, NewResearchLv} = lib_guild_skill_data:upgrade_skill_lv(Guild#guild.id, SkillId),
                    %% 日志
                    lib_log_api:log_guild_skill(NewGuild#guild.id, NewGuild#guild.name, RoleId, 1, SkillId, ResearchCost, PreResearchLv, NewResearchLv),
                    {ok, BinData} = pt_400:write(40041, [1, SkillId, NewResearchLv, NewGuild#guild.gfunds]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                Err ->
                    {ok, BinData} = pt_400:write(40000, [?FAIL]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    ?ERR("research_skill err:~p~n", [Err])
            end
    end.

%% 学习公会技能
learn_skill(RoleId, SkillId, ExtraData) ->
    case lib_guild_skill:check_learn_skill(RoleId, SkillId, ExtraData) of
        {false, ErrorCode} -> {false, ErrorCode};
        {ok, GuildMember, ResearchCfg} ->
            #guild_skill_research_cfg{learn_cost = LearnCost} = ResearchCfg,
            case catch lib_guild_skill:learn_cost(LearnCost, GuildMember) of
                {ok, NewGuildMember} ->
                    lib_guild_data:update_guild_member(NewGuildMember),
                    {ok, LearnCost, NewGuildMember#guild_member.donate};
                Err ->
                    ?ERR("learn_skill err:~p~n", [Err]),
                    {false, ?FAIL}
            end
    end.

%% 增加公会资金
add_gfunds(RoleId, GuildId, AddGfunds, Type) when is_integer(GuildId), AddGfunds > 0 ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        Guild when is_record(Guild, guild) ->
            NewGuild = add_gfunds(RoleId, Guild, AddGfunds, Type),
            lib_guild_data:update_guild(NewGuild);
        _ -> skip
    end;
add_gfunds(RoleId, Guild, AddGfunds, Type) when is_record(Guild, guild), AddGfunds > 0 ->
    #guild{id = GuildId, gfunds = OldGfunds, chief_id = ChiefId} = Guild,
    NewGfunds = OldGfunds + AddGfunds,
    lib_guild_data:db_guild_update_gfunds(GuildId, NewGfunds),
    case RoleId > 0 of
        true ->
            lib_chat:send_TV({player, RoleId}, ?MOD_GUILD, 9, [AddGfunds]);
        _ -> skip
    end,
    case Type of
        kf_gwar_return_gfunds_in_confirm -> %% 跨服公会战宣战失败返还要发邮件通知
            lib_mail_api:send_sys_mail([ChiefId], utext:get(4370005), utext:get(4370006), []);
        _ -> skip
    end,
    %% 日志
    lib_log_api:log_produce_gfunds(RoleId, GuildId, Type, AddGfunds, NewGfunds, utime:unixtime()),
    NewGuild = Guild#guild{gfunds = NewGfunds},
    {_, LastGuild} = upgrade_guild_core(NewGuild),
    LastGuild;
add_gfunds(_, _, _, _) -> skip.

add_gactivity(RoleId, GuildId, GActivity, Type) when is_integer(GuildId), GActivity > 0  ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        Guild when is_record(Guild, guild) ->
            NewGuild = add_gactivity(RoleId, Guild, GActivity, Type),
            lib_guild_data:update_guild(NewGuild);
        _ -> skip
    end;
add_gactivity(_RoleId, Guild, GActivity, _Type) when is_record(Guild, guild), GActivity > 0 ->
    #guild{id = GuildId, gactivity = OldGActivity} = Guild,
    NewGActivity = OldGActivity + GActivity,
    Sql = io_lib:format(?sql_guild_update_gactivity, [NewGActivity, GuildId]),
    db:execute(Sql),
    NewGuild = Guild#guild{gactivity = NewGActivity},
    NewGuild;
add_gactivity(_, _, _, _) -> skip.

add_guild_dun_score(RoleId, GuildId, DunScore, Type) when is_integer(GuildId), DunScore > 0  ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        Guild when is_record(Guild, guild) ->
            NewGuild = add_guild_dun_score(RoleId, Guild, DunScore, Type),
            lib_guild_data:update_guild(NewGuild);
        _ -> skip
    end;
add_guild_dun_score(_RoleId, Guild, DunScore, _Type) when is_record(Guild, guild), DunScore > 0 ->
    #guild{id = GuildId, dun_score = OldDunScore} = Guild,
    NewDunScore = OldDunScore + DunScore,
    Sql = io_lib:format(?sql_guild_update_guild_dun_score, [NewDunScore, GuildId]),
    db:execute(Sql),
    NewGuild = Guild#guild{dun_score = NewDunScore},
    NewGuild;
add_guild_dun_score(_, _, _, _) -> skip.

%% 消耗公会资金
cost_gfunds(RoleId, Guild, CostGfunds, Type) when is_record(Guild, guild), CostGfunds > 0 ->
    #guild{id = GuildId, gfunds = OldGfunds} = Guild,
    NewGfunds = max(0, OldGfunds - CostGfunds),
    lib_guild_data:db_guild_update_gfunds(GuildId, NewGfunds),
    %% 日志
    lib_log_api:log_consume_gfunds(RoleId, GuildId, Type, CostGfunds, NewGfunds, utime:unixtime()),
    NewGuild = Guild#guild{gfunds = NewGfunds},
    NewGuild.

%% 增加公会贡献
add_donate(RoleId, AddDonate, ProduceType, Extra) when is_integer(RoleId), AddDonate > 0 ->
    case lib_guild_data:get_guild_member_by_role_id(RoleId) of
        GuildMember when is_record(GuildMember, guild_member) ->
            NewGuildMember = add_donate(GuildMember, AddDonate, ProduceType, Extra),
            lib_guild_data:update_guild_member(NewGuildMember);
        [] -> skip
    end;
%% 增加公会贡献(这个接口不会保存内存数据需要在外部调用保存接口)
add_donate(GuildMember, AddDonate, ProduceType, Extra) when is_record(GuildMember, guild_member), AddDonate > 0 ->
    #guild_member{
        id = RoleId, guild_id = _GuildId,
        donate = Donate, historical_donate = HistoricalDonate
    } = GuildMember,
    NewDonate = Donate + AddDonate,
    NewHistoricalDonate = HistoricalDonate + AddDonate,
    db:execute(io_lib:format(?sql_guild_member_update_donate, [NewDonate, NewHistoricalDonate, RoleId])),
    %% 日志
    lib_log_api:log_produce_gdonate(RoleId, ProduceType, AddDonate, NewDonate, NewHistoricalDonate, Extra),
    NewGuildMember = GuildMember#guild_member{donate = NewDonate, historical_donate = NewHistoricalDonate},
    lib_chat:send_TV({player, RoleId}, ?MOD_GUILD, 8, [AddDonate]),
    lib_server_send:send_to_uid(RoleId, pt_400, 40039, [NewDonate]),
    NewGuildMember;
add_donate(_, _, _, _) -> skip.

cost_donate(GuildMember, CostDonate, ConsumeType, Extra) when is_record(GuildMember, guild_member), CostDonate > 0 ->
    #guild_member{
        id = RoleId, guild_id = _GuildId,
        donate = Donate, historical_donate = HistoricalDonate} = GuildMember,
    NewDonate = max(Donate - CostDonate, 0),
    db:execute(io_lib:format(?sql_guild_member_update_donate, [NewDonate, HistoricalDonate, RoleId])),
    %% 日志
    lib_log_api:log_consume_gdonate(RoleId, ConsumeType, CostDonate, NewDonate, Extra),
    GuildMember#guild_member{donate = NewDonate}.

%% 增加贡献成长值
add_growth(RoleId, GuildId, AddGrowth, ProduceType, Extra) when is_integer(GuildId), AddGrowth > 0 ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        Guild when is_record(Guild, guild) ->
            NewGuild = add_growth(RoleId, Guild, AddGrowth, ProduceType, Extra),
            lib_guild_data:update_guild(NewGuild);
        _ -> skip
    end;
add_growth(RoleId, Guild, AddGrowth, ProduceType, _Extra) when is_record(Guild, guild), AddGrowth > 0 ->
    #guild{id = GuildId, growth_val = OldGrowthVal} = Guild,
    NewGrowthVal = OldGrowthVal + AddGrowth,
    db:execute(io_lib:format(?sql_guild_update_growth_val, [NewGrowthVal, GuildId])),
    %% 日志
    lib_log_api:log_produce_growth(GuildId, RoleId, ProduceType, AddGrowth, NewGrowthVal),
    lib_chat:send_TV({player, RoleId}, ?MOD_GUILD, 11, [AddGrowth]),
    NewGuild = Guild#guild{growth_val = NewGrowthVal},
    %% 推送小红点
    send_guild_upgrade_red_point(GuildId),
    NewGuild;
add_growth(_, _, _, _, _) -> skip.

%% 消耗成长值
cost_growth(RoleId, Guild, ConsumeType, CostGrowth, Extra) when is_record(Guild, guild), CostGrowth > 0 ->
    #guild{id = GuildId, growth_val = OldGrowthVal} = Guild,
    NewGrowthVal = max(0, OldGrowthVal - CostGrowth),
    db:execute(io_lib:format(?sql_guild_update_growth_val, [NewGrowthVal, GuildId])),
    %% 日志
    lib_log_api:log_consume_growth(GuildId, RoleId, ConsumeType, CostGrowth, NewGrowthVal, Extra),
    NewGuild = Guild#guild{growth_val = NewGrowthVal},
    NewGuild.

%% 发送公会申请的小红点
send_guild_apply_red_point(GuildId) ->
    send_guild_apply_red_point(GuildId, []).

send_guild_apply_red_point(GuildId, FilterRoleIdList) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) ->
            #guild{id = GuildId} = Guild,
            GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
            F = fun(_K, GuildMember, List) ->
                #guild_member{id = TmpRoleId, position = Position} = GuildMember,
                PermissionList = get_position_permission_list(GuildId, Position),
                IsAllowModify = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
                case IsAllowModify of
                    true -> [TmpRoleId|List];
                    false -> List
                end
            end,
            List = maps:fold(F, [], GuildMemberMap),
            NewList = List -- FilterRoleIdList,
            [send_red_point(TmpRoleId, ?RED_POINT_GUILD_APPLY)||TmpRoleId<-NewList];
        true ->
            skip
    end.

send_guild_upgrade_red_point(GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) ->
            #guild{lv = GuildLv, growth_val = GrowthVal} = Guild,
                LvCfg = data_guild:get_guild_lv_cfg(GuildLv),
                NextLvCfg = data_guild:get_guild_lv_cfg(GuildLv + 1),
                if
                    is_record(LvCfg, guild_lv_cfg) == false -> skip;
                    is_record(NextLvCfg, guild_lv_cfg) == false -> skip;
                    true ->
                        #guild_lv_cfg{growth_val_limit = GrowthValLimit} = LvCfg,
                        case GrowthVal >= GrowthValLimit of
                            true ->
                                GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                                F = fun(GuildMember) ->
                                    #guild_member{id = TmpRoleId, position = Position} = GuildMember,
                                    PermissionList = get_position_permission_list(GuildId, Position),
                                    IsAllowModify = lists:member(?PERMISSION_UPGRADE_GUILD, PermissionList),
                                    case IsAllowModify of
                                        true ->
                                            send_red_point(TmpRoleId, ?RED_POINT_GUILD_UPGRADE);
                                        false -> skip
                                    end
                                end,
                                lists:foreach(F, maps:values(GuildMemberMap));
                            _ -> skip
                        end
                end;
        true -> skip
    end.

%% 发送小红点
send_red_point(RoleId, ?RED_POINT_GUILD_APPLY = Type) ->
    send_red_point(RoleId, Type, 1);
send_red_point(RoleId, ?RED_POINT_GUILD_UPGRADE = Type) ->
    send_red_point(RoleId, Type, 0);
send_red_point(_, _) -> ok.

send_red_point(RoleId, ?RED_POINT_GUILD_APPLY = Type, Num) ->
    {ok, BinData} = pt_110:write(11016, [?MOD_GUILD, Type, Num]),
    lib_server_send:send_to_uid(RoleId, BinData);
send_red_point(RoleId, ?RED_POINT_GUILD_UPGRADE = Type, Num) ->
    {ok, BinData} = pt_110:write(11016, [?MOD_GUILD, Type, Num]),
    lib_server_send:send_to_uid(RoleId, BinData);
send_red_point(_, _, _) -> ok.

%% 日常清理
day_clear(?FOUR, _DelaySec) -> ok;
day_clear(?TWELVE, _DelaySec) ->
    %% 注意顺序
    NowTime = utime:unixtime(),
    NowWeek = utime:day_of_week(NowTime),
    case NowWeek of
        1 -> %% 周一重置
            db:execute(?sql_guild_reset_announce_modify_times);
        _ -> skip
    end,
    %% 每日零点清理公会活跃度和公会积分
    db:execute(?sql_guild_reset_activity),
    %% 清理过期的公会申请
    clear_expired_apply(NowTime),
    %% 重新公会公告的免费修改次数
    GuildMap = lib_guild_data:get_guild_map(),
    F = fun(GuildId, Guild, OGuildMap) ->
        %Guild = lib_guild_data:get_guild_by_id(GuildId),
        NewModifyTimes = case NowWeek of
            1 -> 0;
            _ -> Guild#guild.modify_times
        end,
        LastGuild = Guild#guild{modify_times = NewModifyTimes, gactivity = 0, dun_score = 0},
        maps:put(GuildId, LastGuild, OGuildMap)
        %% 刷新榜单
        %% lib_common_rank_api:reflash_rank_by_guild(LastGuild),
        %lib_guild_data:update_guild(LastGuild)
    end,
    NewGuildMap = maps:fold(F, GuildMap, GuildMap),
    lib_guild_data:save_guild_map(NewGuildMap),
    %% 检测是否需要解散帮派
    check_auto_disband_guild(),
    %% 自动任命为会长，延时N秒等自动解散公会的逻辑处理完
    check_auto_appoint_chief(),
    ok;
day_clear(_Clock, _DelaySec) ->
    ok.

check_auto_appoint_chief() ->
    spawn(fun() ->
        util:multiserver_delay(60, mod_guild, auto_appoint_to_chief, [1000])
    end).

clear_expired_apply(NowTime) ->
    ExpiredCreateTime = NowTime - ?APPLY_EXPIRED_TIME,
    db:execute(io_lib:format(?sql_guild_apply_delete_by_create_time, [ExpiredCreateTime])),
    lib_guild_data:clear_expired_apply(ExpiredCreateTime).

check_auto_disband_guild() ->
    GuildMap = lib_guild_data:get_guild_map(),
    %% ?ERR("All GuildIds In Division:~p", [AllGuildIdsInGwar]),
    WinnerGuild = mod_guild_battle:get_battle_winner(),
    spawn(fun() ->
        F2 = fun(GuildId, _Guild, _GuildAcc) ->
            case WinnerGuild == GuildId of
                false ->
                    %% 睡眠发送
                    util:multiserver_delay(0.5, mod_guild, check_auto_disband_guild, [GuildId]);
                true -> skip
            end
        end,
        maps:fold(F2, ok, GuildMap)
    end),
    ok.

%% 检测是否需要自动解散公会(并存储数据库)
check_auto_disband_guild(GuildId) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> skip;
        #guild{} = Guild ->
            NowTime = utime:unixtime(),
            case is_need_disband_guild(Guild, NowTime) of
                {true, DisbandType} -> disband_guild(DisbandType, Guild);
                % auto_disband_warnning -> %% 公会人数少于5人 进入解散倒计时
                %     lib_guild_data:update_guild(Guild#guild{disband_warnning_time = NowTime}),
                %     Sql = io_lib:format(?sql_guild_update_disband_warnning_time, [NowTime, GuildId]),
                %     db:execute(Sql),
                %     mod_guild:send_guild_mail_by_guild_id(GuildId, utext:get(4000023), utext:get(4000024), [], []);
                false -> skip
            end
    end,
    ok.

%% 是否需要解散公会
is_need_disband_guild(Guild, NowTime) ->
    #guild{id = GuildId, member_num = _MemberNum, disband_warnning_time = _DisbandWarnningTime} = Guild,
    % if
    %     %% 时间有延迟，加多N分钟确保自动解散公会成功
    %     DisbandWarnningTime > 0 andalso (NowTime + 10 * 60) - DisbandWarnningTime >= ?AUTO_DISBAND_AF_WARNNING ->
    %         {true, ?DISBAND_REASON_MEMBER_NUM};
    %     MemberNum < ?AUTO_DISBAND_NEED_NUM ->
    %         auto_disband_warnning;
    %     true ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    GuildMembers = maps:values(GuildMemberMap),
    is_members_offline_time_out(GuildMembers, NowTime, ?AUTO_DISBAND_OFFLINE_TIME).
    % end.

%% 是否公会所有成员都离线都超过了解散时间
-ifdef(DEV_SERVER).
%% 开发服不
is_members_offline_time_out(_,_,_) -> false.
-else.
is_members_offline_time_out([], _, _) -> {true, ?DISBAND_REASON_ACTIVITY};
is_members_offline_time_out([Member|Members], NowTime, Timeout) ->
    #guild_member{last_logout_time = LastLogoutTime, online_flag = OnLineFlag} = Member,
    case (NowTime - LastLogoutTime >= Timeout) andalso OnLineFlag == 0 of
        true ->
            is_members_offline_time_out(Members, NowTime, Timeout);
        false -> false
    end.
-endif.

%% 解散公会
disband_guild(DisbandType, GuildId) when is_integer(GuildId) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> skip;
        Guild -> disband_guild(DisbandType, Guild)
    end;
disband_guild(DisbandType, Guild) ->
    #guild{id = GuildId, name = GuildName} = Guild,
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    RoleIdList = maps:keys(GuildMemberMap),
    FirRankDesignationId = lib_common_rank_api:get_guild_title_id(),
    NowTime = utime:unixtime(),
    %?MYLOG("zh_guild", "disband_guild GuildId ~p ~n", [GuildId]),
    %% 数据库的清理都放到事务里面去
    F = fun() ->
        % 清理公会
        Sql = io_lib:format(?sql_guild_delete_by_guild_id, [GuildId]),
        db:execute(Sql),
        % 清理公会成员
        Sql2 =
        case DisbandType of
            ?DISBAND_REASON_GUILD_MERGE -> io_lib:format(?sql_guild_member_clear_by_guild_merge, [GuildId]);
            _ -> io_lib:format(?sql_guild_member_clear_by_guild_id, [GuildId])
        end,
        db:execute(Sql2),
        % 清理公会申请
        Sql3 = io_lib:format(?sql_guild_apply_delete_by_guild_id, [GuildId]),
        db:execute(Sql3),
        % 清理职位名称
        Sql4 = io_lib:format(?sql_position_name_delete_by_guild_id, [GuildId]),
        db:execute(Sql4),
        % 清理权限
        Sql5 = io_lib:format(?sql_position_permission_by_guild_id, [GuildId]),
        db:execute(Sql5),
        %% 清理公会仓库
        Sql6 = io_lib:format(?sql_delete_guild_depot_by_guild_id, [GuildId]),
        db:execute(Sql6),
        %% 清理公会Boss
        Sql7 = io_lib:format(?sql_delete_guild_boos_by_guild_id, [GuildId]),
        db:execute(Sql7),
        %% 清理公会技能
        Sql8 = io_lib:format(?sql_delete_guild_skill_by_guild_id, [GuildId]),
        db:execute(Sql8),
        %% 清理公会合并
        Sql9 = io_lib:format(?sql_guild_merge_delete2, [GuildId, GuildId]),
        db:execute(Sql9),
        %% 移除第一公会称号
        case FirRankDesignationId > 0 of
            true ->
                Sql9 = io_lib:format(?SQL_DSGT_UPDATE_ETIME, [NowTime, NowTime, FirRankDesignationId, util:link_list(RoleIdList)]),
                db:execute(Sql9);
            false -> skip
        end,
        ok
    end,
    case catch db:transaction(F) of
        ok ->
            ChiefGuildMember = lib_guild_data:get_chief(GuildId),
            lib_guild_data:delete_guild(GuildId),
            lib_guild_data:delete_guild_member_by_guild_id(GuildId, RoleIdList),
            lib_guild_data:delete_guild_apply_by_guild_id(GuildId),
            lib_guild_data:delete_position_name(GuildId),
            lib_guild_data:delete_position_permission(GuildId),
            lib_guild_data:delete_donate_log_list(GuildId),
            lib_guild_data:delete_guild_merge(GuildId),
            lib_guild_data:sort_guild_by_level(),

            %% 其他公会关联功能的清理 这里只做内存的清理
            lib_guild_depot_data:delete_depot_by_guild_id(GuildId),
            mod_chat_cache:delete_guild_cache([GuildId]),
            lib_guild_skill:delete_skill_by_guild_id(GuildId),

            %% 移除第一公会称号
            spawn(fun() ->
                F1 = fun(TRoleId) ->
                    lib_designation_api:cancel_dsgt_online(TRoleId, FirRankDesignationId)
                end,
                lists:foreach(F1, RoleIdList)
            end),

            GuildMemberList = maps:values(GuildMemberMap),
            spawn(fun()->
                timer:sleep(urand:rand(100, 10000)),
                send_disband_guild_mail(GuildMemberList, Guild, DisbandType)
            end),
            %% 日志
            lib_log_api:log_guild(GuildId, GuildName, DisbandType, ""),
            lib_guild_api:disband_guild(Guild, ChiefGuildMember, GuildMemberList),
            ok;
        _Error ->
            ?ERR("_Error: ~p~n",[_Error]),
            fail
    end.

%% 发送解散公会的邮件
send_disband_guild_mail([], _Guild, _DisbandType) -> skip;
send_disband_guild_mail([#guild_member{id = RoleId}|T], Guild, DisbandType) ->
    case DisbandType of
        ?DISBAND_REASON_ACTIVITY ->
            lib_mail_api:send_guild_mail([RoleId], utext:get(4000015), utext:get(4000016), []);
        ?DISBAND_REASON_MEMBER_NUM ->
            lib_mail_api:send_guild_mail([RoleId], utext:get(4000015), utext:get(4000017), []);
        ?DISBAND_REASON_GM ->
            lib_mail_api:send_guild_mail([RoleId], utext:get(4000015), utext:get(4000022), []);
        _ -> skip
    end,
    timer:sleep(100),
    send_disband_guild_mail(T, Guild, DisbandType).

%% 更新公会成员属性(职位等关联性强的赋值要额外写,不能简单赋值)
update_member_and_guild_attr(RoleId, AttrList) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> skip;
        is_record(GuildMember, guild_member) == false -> skip;
        true ->
            NewGuildMember = do_update_guild_member_attr(AttrList, GuildMember),
            lib_guild_data:update_guild_member(NewGuildMember),
            NewGuild = do_update_guild_by_member_attr(AttrList, NewGuildMember, Guild),
            lib_guild_data:update_guild(NewGuild)
    end,
    ok.

do_update_guild_member_attr([], GuildMember) -> GuildMember;
do_update_guild_member_attr([T|L], GuildMember) ->
    #guild_member{figure = Figure} = GuildMember,
    case T of
        {name, Name} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{name = Name}};
        {lv, Lv} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{lv = Lv}};
        {picture, Picture} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{picture = Picture}};
        {picture_ver, PictureVer} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{picture_ver = PictureVer}};
        {vip, Vip} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{vip = Vip}};
        {title, Title} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{title = Title}};
        {online_flag, OnlineFlag} -> NewGuildMember = GuildMember#guild_member{online_flag = OnlineFlag};
        {last_login_time, LastLoginTime} -> NewGuildMember = GuildMember#guild_member{last_login_time = LastLoginTime};
        {last_logout_time, LastLogoutTime} ->
            NewGuildMember = GuildMember#guild_member{last_logout_time = LastLogoutTime};
        {h_combat_power, HCombatPower} -> NewGuildMember = GuildMember#guild_member{h_combat_power = HCombatPower};
        {turn, Turn} -> NewGuildMember = GuildMember#guild_member{figure = Figure#figure{turn = Turn}};
        {figure, NewFigure} -> NewGuildMember = GuildMember#guild_member{figure = NewFigure};
        _ ->
            % ?ERR("ignore attr:~p~n", [T]),
            NewGuildMember = GuildMember
    end,
    do_update_guild_member_attr(L, NewGuildMember).

do_update_guild_by_member_attr([], _GuildMember, Guild) -> Guild;
do_update_guild_by_member_attr([T|L], GuildMember, Guild) ->
    #guild_member{id = RoleId} = GuildMember,
    #guild{id = GuildId, chief_id = ChiefId} = Guild,
    case T of
        {name, Name} ->
            case RoleId == ChiefId of
                true ->
                    db:execute(io_lib:format(?sql_guild_update_chief, [ChiefId, Name, GuildId])),
                    NewGuild = Guild#guild{chief_name = Name};
                false ->
                    NewGuild = Guild
            end;
        _ ->
            NewGuild = Guild
    end,
    do_update_guild_by_member_attr(L, GuildMember, NewGuild).

%% 更新公会成员属性
update_guild(RoleId, AttrList) ->
    case lib_guild_data:get_guild_member_by_role_id(RoleId) of
        [] -> skip;
        GuildMember ->
            NewGuildMember = do_update_guild_member_attr(AttrList, GuildMember),
            lib_guild_data:update_guild_member(NewGuildMember)
    end,
    ok.

%% ----------------------------------------------------
%% 公用
%% ----------------------------------------------------

%% 获得职位列表
get_position_num_list(GuildId) ->
    Map = lib_guild_data:get_guild_member_map(GuildId),
    F = fun(_K, GuildMember, List) ->
        #guild_member{position = Position} = GuildMember,
        case lists:keyfind(Position, 1, List) of
            false -> [{Position, 1}|List];
            {Position, Num} -> lists:keystore(Position, 1, List, {Position, Num+1})
        end
    end,
    maps:fold(F, [], Map).

%% 获得权限列表
get_position_permission_list(GuildId, Position) ->
    F = fun(PermissionType, IsAllow, List) ->
        case IsAllow == ?IS_ALLOW_NO of
            true -> List;
            false -> [PermissionType|List]
        end
    end,
    PosPermissionMap = lib_guild_data:get_position_permission_map(GuildId),
    PermissionTypeMap = maps:get(Position, PosPermissionMap, #{}),
    maps:fold(F, [], PermissionTypeMap).

%% 是否会长
is_chief(#guild_member{position = Position}) ->
    Position == ?POS_CHIEF.

%% 获取公会活跃人数
get_active_member_num(GuildId) ->
    NowTime = utime:unixtime(),
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    ActiveMembers = maps:filter(fun(_, Member) ->
        #guild_member{last_logout_time = LastLogoutTime} = Member,
        NowTime - LastLogoutTime < ?CAL_GUILD_POWER_VAILD_TIME
    end, GuildMemberMap),
    maps:size(ActiveMembers).

%% 获取公会申请列表(40008协议格式)
%% @return [{玩家id, 形象, 战力},...]
get_guild_apply_list(GuildId) ->
    GuildApplyMap = lib_guild_data:get_guild_apply_map_by_guild_id(GuildId),
    GuildApplyList = maps:values(GuildApplyMap),
    GuildApplyListSort = lists:keysort(#guild_apply.create_time, GuildApplyList),
    F = fun(#guild_apply{role_id = TmpRoleId}) ->
        case lib_role:get_role_show(TmpRoleId) of
            [] -> Figure = #figure{}, CombatPower = 0;
            #ets_role_show{figure = Figure, combat_power = CombatPower} -> ok
        end,
        {TmpRoleId, Figure, CombatPower}
    end,
    lists:map(F, GuildApplyListSort).

%%--------------------------------------------------
%% 对[#guild{}]类型列表排序
%% @param  List    [#guild{}]
%% @param  SortKey 用于排序的字段
%% @param  Len     排序的长度
%% @return         description
%%--------------------------------------------------
sort(List, SortKey, Len) ->
    SortList = lists:keysort(SortKey, List),
    lists:sublist(lists:reverse(SortList), Len).

%% ----------------------------------------------------
%% 公会捐献
%% ----------------------------------------------------
%%----------- 捐献界面
send_donate_info(RoleId, SelfGiftStatusList, DonateTimes) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_modify_approve)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            #guild{gactivity = GActivity} = Guild,
            #guild_member{guild_id = GuildId} = GuildMember,
            DonateLogList = lib_guild_data:get_donate_log_list(GuildId),
            %% 协议
            %?PRINT("send_donate_info == ~p~n", [GActivity]),
            % ?PRINT("send_donate_info == ~p~n", [DonateLogList]),
            {ok, Bin} = pt_400:write(40023, [GActivity, DonateTimes, SelfGiftStatusList, DonateLogList]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end.

%%----------- 捐献
guild_donate(RoleId, DonateCfg, DonateTimes, Times, PlayerArgs) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    {RoleName} = PlayerArgs,
    if
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_not_on_guild_to_modify_approve)};
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            #base_guild_donate{donate_type = DonateType, donate_reward = DonateReward} = DonateCfg,
            {DonateAdd, GfundsAdd, GuildActiveAdd} = calc_donate_reward(DonateReward, Times),
            %?PRINT("guild_donate  ~p~n", [{DonateAdd, GfundsAdd, GuildActiveAdd}]),
            #guild_member{donate = Donate, historical_donate = HistoricalDonate} = GuildMember,
            #guild{id = GuildId, gfunds = GFunds, gactivity = GActivity} = Guild,
            NewDonate = Donate + DonateAdd, NewHistoricalDonate = HistoricalDonate + DonateAdd,
            NewGfunds = GFunds + GfundsAdd, NewGActivity = GActivity + GuildActiveAdd,
            F = fun() ->
                Sql = io_lib:format(?sql_guild_member_update_donate, [NewDonate, NewHistoricalDonate, RoleId]),
                db:execute(Sql),
                Sql1 = io_lib:format(?sql_guild_update_gfunds_activity, [NewGfunds, NewGActivity, GuildId]),
                db:execute(Sql1),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    %% 日志
                    lib_log_api:log_produce_gfunds(RoleId, GuildId, role_donate, GfundsAdd, NewGfunds, utime:unixtime()),
                    lib_log_api:log_produce_gdonate(RoleId, role_donate, DonateAdd, NewDonate, NewHistoricalDonate, ""),
                    % %% 成就
                    % lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_achievement_api, guild_donate_event, [DonateTimes+Times]),
                    %?PRINT("guild_donate succ ~n", []),
                    ErrorCode = ?SUCCESS,
                    NewGuildMember = GuildMember#guild_member{donate = NewDonate, historical_donate = NewHistoricalDonate},
                    lib_guild_data:update_guild_member(NewGuildMember),
                    NewGuild = Guild#guild{gfunds = NewGfunds, gactivity = NewGActivity},
                    {_, LastGuild} = upgrade_guild_core(NewGuild),
                    lib_guild_data:update_guild(LastGuild),
                    %% 更新捐献记录
                    DonateId = lib_guild_depot_data:get_donate_record_new_id(),
                    NewDonateRecord = {DonateId, RoleId, RoleName, DonateType, Times, DonateAdd, GfundsAdd, GuildActiveAdd, utime:unixtime()},
                    DonateLogList = lib_guild_data:get_donate_log_list(GuildId),
                    NewDonateLogList = update_guild_donate_list(DonateLogList, NewDonateRecord),
                    lib_guild_data:update_donate_log_list(GuildId, NewDonateLogList),
                    %% 协议更新信息
                    {ok, Bin} = pt_400:write(40024, [ErrorCode, DonateType, DonateTimes+Times, NewDonate, NewHistoricalDonate, NewGfunds, NewGActivity]),
                    {ok, BinDonateLog} = pt_400:write(40026, [[NewDonateRecord]]),
                    lib_server_send:send_to_uid(RoleId, <<Bin/binary, BinDonateLog/binary>>),
                    {ok, BinActivity} = pt_400:write(40028, [NewGActivity]),
                    lib_server_send:send_to_guild(GuildId, BinActivity);
                _Error ->
                    ?ERR("_Error: ~p ~n",[_Error]),
                    ?FAIL
            end
    end.

get_guild_activity(GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            #guild{gactivity = GActivity} = Guild,
            {ok, GActivity}
    end.

send_guild_activity(RoleId, GuildId) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_guild_not_exist)};
        true ->
            #guild{gactivity = GActivity} = Guild,
            {ok, Bin} = pt_400:write(40028, [GActivity]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end.

calc_donate_reward(DonateReward, Times) ->
    F = fun(Item, {DonateAdd, GFundsAdd, GActivityAdd}) ->
        case Item of
            {?TYPE_GDONATE, 0, Donate} -> {DonateAdd+Donate*Times, GFundsAdd, GActivityAdd};
            {?TYPE_GFUNDS, 0, GFunds} -> {DonateAdd, GFundsAdd+GFunds*Times, GActivityAdd};
            {?TYPE_GUILD_ACTIVITY, 0, GActiv} -> {DonateAdd, GFundsAdd, GActivityAdd+GActiv*Times};
            _ -> {DonateAdd, GFundsAdd, GActivityAdd}
        end
    end,
    {NewDonateAdd, NewGFundsAdd, NewGActivityAdd} = lists:foldl(F, {0, 0, 0}, DonateReward),
    {NewDonateAdd, NewGFundsAdd, NewGActivityAdd}.

update_guild_donate_list(DonateLogList, NewDonateRecord) ->
    case length(DonateLogList) >= ?DONATE_RECORD_MAX_LEN of
        true ->
            NewDonateLogList = lists:sublist([NewDonateRecord|DonateLogList], ?DONATE_RECORD_MAX_LEN);
        _ ->
            NewDonateLogList = [NewDonateRecord|DonateLogList]
    end,
    NewDonateLogList.

upgrade_guild_core(Guild) ->
    #guild{id = GuildId, lv = GuildLv, gfunds = GuildFunds} = Guild,
    {NewGuildLv, NewGuildFunds} = upgrade_guild_helper(GuildLv, GuildFunds),
    case NewGuildLv =/= GuildLv of
        true ->
            Sql = io_lib:format(?sql_guild_update_lv_and_funds, [NewGuildLv, NewGuildFunds, GuildId]),
            db:execute(Sql),
            %% 日志
            CostGFunds = max(0, GuildFunds-NewGuildFunds),
            lib_log_api:log_consume_growth(GuildId, 0, upgrade_guild, CostGFunds, NewGuildFunds, {new_guild_lv, NewGuildLv}),
            NewGuild = Guild#guild{lv = NewGuildLv, gfunds = NewGuildFunds},
            lib_guild_data:sort_guild_by_level(),
            GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
            lib_guild_create_act:update_act_reward_status(NewGuild),
            {ok, Bin} = pt_400:write(40018, [1]),
            F2 = fun(_Key, TmpGuildMember, _Acc) ->
                lib_server_send:send_to_uid(TmpGuildMember#guild_member.id, Bin),
                lib_guild_api:change_guild_member(?GEVENT_UPGRADE_GUILD, [TmpGuildMember, NewGuildLv])
            end,
            maps:fold(F2, [], GuildMemberMap),
            {?SUCCESS, NewGuild};
        _ ->
            {?ERRCODE(err400_not_satisfy_upgrade_guild_condition), Guild}
    end.

upgrade_guild_helper(GuildLv, GuildFunds) ->
    LvCfg = data_guild:get_guild_lv_cfg(GuildLv),
    NextLvCfg = data_guild:get_guild_lv_cfg(GuildLv + 1),
    if
        is_record(LvCfg, guild_lv_cfg) == false ->
            {GuildLv, GuildFunds};
        is_record(NextLvCfg, guild_lv_cfg) == false ->
            {GuildLv, GuildFunds};
        true ->
            #guild_lv_cfg{growth_val_limit = GrowthValLimit} = LvCfg,
            case GuildFunds >= GrowthValLimit of
                true ->
                    upgrade_guild_helper(GuildLv+1, GuildFunds-GrowthValLimit);
                _ ->
                    {GuildLv, GuildFunds}
            end
    end.

refres_prestige_and_title(GuildMember, NewPrestige, AddNum) ->
    PrestigeTitleId = lib_guild_data:get_prestige_title_id(NewPrestige),
    OldPrestigeTitleId = lib_guild_data:get_prestige_title_id(NewPrestige-AddNum),
    case PrestigeTitleId > OldPrestigeTitleId of
        true -> %% 公会广播
            TitleName = data_guild:get_title_name(PrestigeTitleId),
            #figure{name = RoleName} = GuildMember#guild_member.figure,
            lib_chat:send_TV({guild, GuildMember#guild_member.guild_id}, ?MOD_GUILD, 14, [RoleName, util:make_sure_binary(TitleName)]);
        _ -> skip
    end,
    GuildMember#guild_member{prestige = NewPrestige, prestige_title = PrestigeTitleId}.

%% 发送招募列表
send_recruit_list(RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    F = fun(_, GuildMember, List) ->
        #guild_member{id = TmpRoleId, figure = #figure{lv = Lv} = Figure, online_flag = OnlineFlag, combat_power = CombatPower} = GuildMember,
        case TmpRoleId =/= RoleId andalso Lv >= DunLv andalso OnlineFlag == ?ONLINE_ON of
            true ->
                case lib_role:get_role_show(TmpRoleId) of
                    #ets_role_show{dun_daily_map = #{EquipCountType := Count}, team_id = TeamId} when Count < MaxCount andalso TeamId == 0 ->
                        [{{Count, CombatPower}, {TmpRoleId, Figure, Count, MaxCount, CombatPower} }|List];
                    _ ->
                        List
                end;
            false ->
                List
        end
    end,
    List = maps:fold(F, [], GuildMemberMap),
    F2 = fun({{CountA, CombatPowerA}, _}, {{CountB, CombatPowerB}, _}) ->
        if
            CountA == CountB -> CombatPowerA >= CombatPowerB;
            true -> CountA < CountB
        end
    end,
    SortList = lists:sort(F2, List),
    RecruitList = [T||{_SortKey, T}<-SortList],
    {ok, BinData} = pt_240:write(24060, [2, DunId, RecruitList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.


%% 发送3v3招募列表
send_recruit_3v3_list(RoleId, GuildId) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    F = fun(_, GuildMember, List) ->
        #guild_member{id = TmpRoleId, figure = #figure{lv = Lv} = Figure, online_flag = OnlineFlag, combat_power = CombatPower} = GuildMember,
        case TmpRoleId =/= RoleId andalso OnlineFlag == ?ONLINE_ON of
            true ->
%%                ?MYLOG("3v3", "65065 RoleId ~p~n ", [RoleId]),
                case lib_role:get_role_show(TmpRoleId) of
                    #ets_role_show{team_3v3_id = Team3v3Id} when Team3v3Id == 0 ->
                        [{CombatPower, {TmpRoleId, Figure#figure.name, Figure#figure.picture, Figure#figure.picture_ver, Figure#figure.career, Lv, CombatPower} }|List];
                    _ ->
                        List
                end;
            false ->
                List
        end
        end,
    List = maps:fold(F, [], GuildMemberMap),
%%    ?MYLOG("3v3", "65065 1 ~p~n ", [GuildMemberMap]),
%%    ?MYLOG("3v3", "65065 1 ~p~n ", [List]),
    F2 = fun({CombatPowerA, _}, {CombatPowerB, _}) ->
        CombatPowerA >= CombatPowerB
         end,
    SortList = lists:sort(F2, List),
    RecruitList = [T||{_SortKey, T}<-SortList],
%%    ?MYLOG("3v3", "65065 RecruitList +++++ ~p~n ", [RecruitList]),
    {ok, BinData} = pt_650:write(65065, [1, RecruitList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 队员招募列表
send_recruit_list(RoleId, GuildId) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    F = fun(_, GuildMember, List) ->
        #guild_member{id = TmpRoleId, figure = Figure, online_flag = OnlineFlag, combat_power = CombatPower} = GuildMember,
        case TmpRoleId =/= RoleId andalso OnlineFlag == ?ONLINE_ON of
            true ->
                case lib_role:get_role_show(TmpRoleId) of
                    #ets_role_show{team_id = TeamId} when TeamId == 0 ->
                        [{TmpRoleId, Figure, CombatPower}|List];
                    _ ->
                        List
                end;
            false ->
                List
        end
    end,
    List = maps:fold(F, [], GuildMemberMap),
    {ok, BinData} = pt_240:write(24061, [2, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 响应公会合并申请
response_guild_merge(_RoleId, ?GUILD_MERGE_OP_AGREE, ApplyGuild, TargetGuild) ->
    #guild{id = ApplyGId} = ApplyGuild,
    #guild{id = TargetGId} = TargetGuild,
    MergeReq = lib_guild_data:get_guild_merge_key({ApplyGId, TargetGId}),

    % 修改合并状态和同意时间,保存到内存和数据库
    NowTime = utime:unixtime(),
    NewMergeReq = MergeReq#guild_merge{status = ?GUILD_MERGE_AGREED, agree_time = NowTime},
    % lib_guild_data:set_guild_merge(NewMergeReq), % 后面删除一并保存
    lib_guild_data:db_guild_merge_update_status(NewMergeReq),

    % 删除双方涉及的其它合并请求
    GuildMergeL = lib_guild_data:get_guild_merges(),
    F = fun(Req) ->
        #guild_merge{apply_gid = GId1, target_gid = GId2} = Req,
        GId1 /= ApplyGId andalso GId2 /= ApplyGId
        andalso
        GId1 /= TargetGId andalso GId2 /= TargetGId
    end,
    NewGuildMergeL = [ NewMergeReq | lists:filter(F, GuildMergeL) ],
    lib_guild_data:set_guild_merges(NewGuildMergeL),

    % 邮件参数
    MasterGId = MergeReq#guild_merge.master_gid,
    {MasterGuild, ViceGuild} = ?IF(ApplyGId == MasterGId, {ApplyGuild, TargetGuild}, {TargetGuild, ApplyGuild}),
    #guild{id = MasterId, name = MasterName} = MasterGuild,
    #guild{id = ViceId, name = ViceName} = ViceGuild,
    MergeTime = lib_guild_util:calc_guild_merge_time(NewMergeReq),
    TimeFormat = utime:unixtime_to_timestr(MergeTime),

    % 主公会邮件
    MasterMbs = maps:values(lib_guild_data:get_guild_member_map(MasterId)),
    MasterMbIds = [Id || #guild_member{id = Id} <- MasterMbs],
    Title1 = utext:get(4000030),
    Content1 = utext:get(4000031, [ViceName, TimeFormat]),
    mod_mail_queue:add(?MOD_GUILD, MasterMbIds, Title1, Content1, []),

    % 副公会邮件
    ViceMbs = maps:values(lib_guild_data:get_guild_member_map(ViceId)),
    ViceMbsIds = [Id || #guild_member{id = Id} <- ViceMbs],
    Title2 = utext:get(4000030),
    Content2 = utext:get(4000032, [TimeFormat, MasterName]),
    mod_mail_queue:add(?MOD_GUILD, ViceMbsIds, Title2, Content2, []),

    ok;

response_guild_merge(_RoleId, ?GUILD_MERGE_OP_REFUSE, ApplyGuild, TargetGuild) ->
    #guild{id = ApplyGId, chief_id = ApplyChiefId} = ApplyGuild,
    #guild{id = TargetGId, name = TargetName} = TargetGuild,
    MergeReq = lib_guild_data:get_guild_merge_key({ApplyGId, TargetGId}),

    % 删除合并请求数据
    lib_guild_data:delete_guild_merge(MergeReq),
    lib_guild_data:db_guild_merge_delete(MergeReq),

    % 发送邮件给申请公会会长
    Title = utext:get(4000030),
    Content = utext:get(4000033, [TargetName]),
    mod_mail_queue:add(?MOD_GUILD, [ApplyChiefId], Title, Content, []),

    ok.

%% 自动同意处理
auto_agree_guild_merge(#guild_merge{apply_time = ApplyTime, status = ?GUILD_MERGE_REQUEST} = MergeReq) ->
    NowTime = utime:unixtime(),
    AutoAgreeTime = data_guild_m:get_config(guild_merge_auto_agree),

    case ApplyTime + AutoAgreeTime =< NowTime of
        true ->
            NewMergeReq = MergeReq#guild_merge{agree_time = ApplyTime + AutoAgreeTime},
            lib_guild_data:db_guild_merge_update_status(NewMergeReq),
            lib_guild_data:set_guild_merge(NewMergeReq);
        false ->
            skip
    end.

%% 公会合并
guild_merge(MergeReq) ->
    #guild_merge{
        apply_gid = ApplyGId,
        target_gid = TargetGId,
        master_gid = MasterGId
    } = MergeReq,
    ApplyGuild = lib_guild_data:get_guild_by_id(ApplyGId),
    TargetGuild = lib_guild_data:get_guild_by_id(TargetGId),

    % 区分主副公会
    {MasterGuild, ViceGuild} = ?IF(ApplyGId == MasterGId, {ApplyGuild, TargetGuild}, {TargetGuild, ApplyGuild}),
    #guild{chief_id = MasterChiefId, name = MasterName} = MasterGuild,
    #guild{id = ViceGId, chief_id = _ViceChiefId, name = ViceName} = ViceGuild,

    % 公会仓库物品转移
    GuildDepotMap = lib_guild_depot_data:get_depot_map(),
    MasterGuildDepot = maps:get(MasterGId, GuildDepotMap, #guild_depot{}),
    ViceGuildDepot = maps:get(ViceGId, GuildDepotMap, #guild_depot{}),
    #guild_depot{depot_goods = MasterDepotGoodsList} = MasterGuildDepot,
    #guild_depot{depot_goods = ViceDepotGoodsList} = ViceGuildDepot,
    MasterDepotGoodsList1 = [DepotGoods#depot_goods{guild_id = MasterGId} || DepotGoods <- ViceDepotGoodsList],
    MasterDepotGoodsList2 = MasterDepotGoodsList ++ MasterDepotGoodsList1,
    MasterGuildDepot1 = MasterGuildDepot#guild_depot{depot_goods = MasterDepotGoodsList2},
    lib_guild_depot_data:save_guild_depot(MasterGId, MasterGuildDepot1),
    lib_guild_depot_data:db_guild_depot_goods_delete(ViceDepotGoodsList),
    lib_guild_depot_data:db_guild_depot_goods_insert(MasterDepotGoodsList1),

    % 踢掉主公会中的不活跃玩家
    MasterUnactiveMbs = lib_guild_util:get_unactive_members(MasterGuild),
    [
        begin
            UnactiveMb = lib_guild_data:get_guild_member_by_role_id(UnactiveId),
            lib_guild_data:delete_guild_member_on_db_and_p(UnactiveMb),
            lib_guild_api:quit_guild(?GEVENT_KICK_OUT, MasterGuild, UnactiveMb)
        end
     || #guild_member{id = UnactiveId} <- MasterUnactiveMbs
    ],

    % 解散副公会并把活跃玩家加入到主公会
    ViceActiveMbs = lib_guild_util:get_active_members(ViceGuild),
    ViceMbsIds = [Id || #guild_member{id = Id} <- ViceActiveMbs],
    ok = lib_guild_mod:disband_guild(?DISBAND_REASON_GUILD_MERGE, ViceGId),
    [
        begin
            case lib_role:get_role_show(ViceMbId) of
                [] -> skip;
                RoleShow ->
                    ViceMbRoleInfoM = lib_guild:make_role_map(RoleShow),
                    agree_guild_apply(ViceMbId, ViceMbRoleInfoM, MasterGuild, ?POS_NORMAIL)
            end
        end
     || ViceMbId <- ViceMbsIds
    ],

    % % 删除合并请求数据 - 解散公会的操作时一并删除
    % lib_guild_data:delete_guild_merge(MergeReq),
    % lib_guild_data:db_guild_merge_delete(MergeReq),

    % 会长邮件
    Title1 = utext:get(4000030),
    Content1 = utext:get(4000034, [ViceName]),
    mod_mail_queue:add(?MOD_GUILD, [MasterChiefId], Title1, Content1, []),

    % 被合并成员邮件
    Title2 = utext:get(4000030),
    Content2 = utext:get(4000035, [MasterName]),
    mod_mail_queue:add(?MOD_GUILD, ViceMbsIds, Title2, Content2, []),

    ok.

%% 是否可以申请
check_apply_guild_merge(RoleId, ApplyGuild, TargetGuild) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    #guild{id = ApplyGId} = ApplyGuild,
    #guild{id = TargetGId} = TargetGuild,
    CheckList = [
        % 是否是合法公会
        {
            fun() ->
                is_record(ApplyGuild, guild)
                andalso
                is_record(TargetGuild, guild)
            end,
            ?FAIL
        },
        % 是否达到配置开服时间
        {
            fun() ->
                MergeOpDay = data_guild_m:get_config(guild_merge_open_day),
                util:get_open_day() >= MergeOpDay
            end,
            ?FAIL
        },
        % 是否有权限
        {
            fun() ->
                LegalMembers = lib_guild_data:get_guild_member_by_permission([?PERMISSION_MERGE_GUILD], ApplyGId),
                lists:keymember(RoleId, #guild_member.id, LegalMembers)
            end,
            ?FAIL
        },
        % 本公会是否已经有申请合并公会
        {
            fun() ->
                not lists:keymember(ApplyGId, #guild_merge.apply_gid, GuildMergeL)
            end,
            ?ERRCODE(err400_merge_requested_other)
        },
        % 本公会是否已经有同意其它公会合并的申请
        {
            fun() ->
                not lib_guild_util:is_in_merge(ApplyGId)
            end,
            ?ERRCODE(err400_merge_agree_other)
        },
        % 目标公会是否有对己方进行申请合并
        {
            fun() ->
                not lists:keymember({TargetGId, ApplyGId}, #guild_merge.key, GuildMergeL)
            end,
            ?ERRCODE(err400_merge_target_guild_applied)
        },
        % 目标公会是否已经有同意其它公会合并的申请
        {
            fun() ->
                not lib_guild_util:is_in_merge(TargetGId)
            end,
            ?ERRCODE(err400_merge_agree_other)
        },
        % 是否达到合并要求
        {
            fun() ->
                lib_guild_util:can_guild_merge(ApplyGuild, TargetGuild) == ?GUILD_MERGE_ALLOW
            end,
            ?ERRCODE(err400_merge_over_capacity)
        }
    ],
    util:check_list(CheckList).

%% 是否可以响应
%% 注:因为当本公会请求或被请求与其它公会合并且同意时,就会删除掉公会其它相关的合并请求,故在此不检测
check_response_guild_merge(RoleId, OpType, ApplyGuild, TargetGuild) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    #guild{id = ApplyGId} = ApplyGuild,
    #guild{id = TargetGId} = TargetGuild,

    CheckList = [
        % 是否是合法公会
        {
            fun() ->
                is_record(ApplyGuild, guild)
                andalso
                is_record(TargetGuild, guild)
            end,
            ?FAIL
        },
        % 是否达到配置开服时间
        {
            fun() ->
                MergeOpDay = data_guild_m:get_config(guild_merge_open_day),
                util:get_open_day() >= MergeOpDay
            end,
            ?FAIL
        },
        % 是否有权限
        {
            fun() ->
                LegalMembers = lib_guild_data:get_guild_member_by_permission([?PERMISSION_MERGE_GUILD], TargetGId),
                lists:keymember(RoleId, #guild_member.id, LegalMembers)
            end,
            ?FAIL
        },
        % 是否合法操作
        {
            fun() ->
                OpType == ?GUILD_MERGE_OP_AGREE orelse OpType == ?GUILD_MERGE_OP_REFUSE
            end,
            ?FAIL
        },
        % 申请是否存在且处于待处理状态
        {
            fun() ->
                MergeReq = lists:keyfind({ApplyGId, TargetGId}, #guild_merge.key, GuildMergeL),
                is_record(MergeReq, guild_merge) andalso lib_guild_util:can_guild_merge_operate(MergeReq)
            end,
            ?ERRCODE(err400_merge_req_not_exist)
        },
        % 对方公会是否已经有同意其它公会合并的申请
        {
            fun() ->
                not lib_guild_util:is_in_merge(ApplyGId)
            end,
            ?ERRCODE(err400_merge_agree_other)
        }
    ],
    util:check_list(CheckList).