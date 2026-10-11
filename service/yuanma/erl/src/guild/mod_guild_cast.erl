%% ---------------------------------------------------------------------------
%% @doc mod_guild_cast.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 帮派进程Cast
%% ---------------------------------------------------------------------------
-module(mod_guild_cast).
-export([handle_cast/2]).

-include("guild.hrl").
-include("sql_guild.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("chat.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_fun.hrl").
-include("rename.hrl").
-include("designation.hrl").

%% cast
handle_cast({'apply_cast', Moudle, Method, Args}, State) ->
    apply(Moudle, Method, Args),
    {noreply, State};

%% 搜索公会列表
handle_cast({'search_guild_list', RoleId, GuildName, PageSize, PageNo}, State) ->
    % 搜索出条件
    if
        GuildName == "" ->
            GuildMap = lib_guild_data:get_guild_map(),
            GuildIdSort = lib_guild_data:get_sort_guild_id_list(),
            F = fun(GuildId, List) ->
                case maps:get(GuildId, GuildMap, 0) of
                    #guild{} = Guild -> [Guild|List]; _ -> List
                end
            end,
            GuildListSort = lists:reverse(lists:foldl(F, [], GuildIdSort));
        true ->
            GuildMap = lib_guild_data:match_guild({guild_name_fuzzy, GuildName}),
            GuildList = [Guild||{_Key, Guild}<-maps:to_list(GuildMap)],
            % 战力排序
            F = fun(GuildA, GuildB) ->
                #guild{lv = GuildLvA} = GuildA, #guild{lv = GuildLvB} = GuildB,
                GuildLvA > GuildLvB
            end,
            GuildListSort = lists:sort(F, GuildList)
    end,
    case GuildListSort =/= [] of
        true ->
            GuildListLen = length(GuildListSort),
            % 获得分页
            {PageTotal, StartPos, ThisPageSize} = util:calc_page_cache(GuildListLen, PageSize, PageNo),

            GuildListSortSub = lists:sublist(GuildListSort, StartPos, ThisPageSize),
            SendList = lib_guild_data:pack_guild_list(GuildListSortSub, RoleId),

            {ok, BinData} = pt_400:write(40001, [PageTotal, PageNo, SendList]),
            lib_server_send:send_to_uid(RoleId, BinData);
        false ->
            % case GuildName =/= "" of
            %     true ->
            %         {ok, BinData} = pt_400:write(40000, [?ERRCODE(err400_not_find_guild)]),
            %         lib_server_send:send_to_uid(RoleId, BinData);
            %     false -> skip
            % end,
            {ok, BinData1} = pt_400:write(40001, [0, 0, []]),
            lib_server_send:send_to_uid(RoleId, BinData1)
    end,
    {noreply, State};

%% 申请加入公会
handle_cast({'apply_join_guild', RoleId, RoleInfoMap, GuildId}, State) ->
    lib_guild_mod:apply_join_guild(RoleId, RoleInfoMap, GuildId),
    {noreply, State};

%% 海投简历
handle_cast({'apply_join_guild_multi', RoleId, RoleInfoMap}, State) ->
    lib_guild_mod:apply_join_guild_multi(RoleId, RoleInfoMap),
    {noreply, State};

%%  获取公会信息界面-基础信息
handle_cast({'send_guild_info', RoleId, GuildId, SalaryStatus, JoinTime}, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> skip;
        Guild ->
           #guild{name = GuildName, chief_id = _ChiefId, chief_name = _ChiefName,
            announce = Announce, gfunds = Gfunds, growth_val = GrowthVal, lv = GuildLv,
            member_num = MemberNum, gactivity = GActivity, combat_power_ten = CPT,
            disband_warnning_time = DisbandWarnningTime, division = Division
            } = Guild,
            OnlineFlag = 1,
            GuildMemberMap = lib_guild_data:match_guild_member({online_flag, GuildId, OnlineFlag}),
            OnlineNum = maps:size(GuildMemberMap),
            MemberCapacity = data_guild_m:get_guild_member_capacity(GuildLv),
            % 圣域前三公会
            SanctuaryGuildList = lib_guild_data:get_sanctuary_top3_guild_list(),
            AddSanctuaryLimit = data_sanctuary:get_kv(add_guild_member_limit),
            case lists:member(GuildId, SanctuaryGuildList) of
                true -> NewMemberCapacity = MemberCapacity + AddSanctuaryLimit;
                _ -> NewMemberCapacity = MemberCapacity
            end,
            PositionMemberMap = lib_guild_data:match_guild_member({specify_positions, GuildId, [?POS_CHIEF, ?POS_DUPTY_CHIEF]}),
            PositionMemberList = [{TmpPosition, TmpRoleId, TmpFigure#figure{position = TmpPosition} } || #guild_member{position = TmpPosition, id = TmpRoleId, figure = TmpFigure} <- maps:values(PositionMemberMap)],
            IsInMerge = ?IF(lib_guild_util:is_in_merge(GuildId), 1, 0),
            %?PRINT("send_guild_info ~p~n", [PositionMemberList]),
            {ok, BinData} = pt_400:write(40005, [GuildId, GuildName, Announce, PositionMemberList, GuildLv, Gfunds,
                GrowthVal, GActivity, MemberNum, NewMemberCapacity, CPT, OnlineNum, DisbandWarnningTime, SalaryStatus, Division, JoinTime, IsInMerge]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

%% 获取公会信息界面-成员列表
handle_cast({'send_guild_member_short_info', RoleId, GuildId, SortType, SortFlag, MemberType, SpecialType}, State) ->
    GuildMemberList = lib_guild_data:search_guild_member(GuildId, RoleId, SortType, SortFlag, MemberType, SpecialType),
    % Len = length(GuildMemberList),
    % % 获得分页
    % {PageTotal, StartPos, ThisPageSize} = lib_guild_util:calc_page_cache(Len, PageSize, PageNo),
    % GuildMemberListSub = lists:sublist(GuildMemberList, StartPos, ThisPageSize),
    NowTime = utime:unixtime(),
    F = fun(#guild_member{
            id = TmpRoleId, figure = Figure, position = Position, historical_donate = _HistoricalDonate, prestige_title = PrestigeTitleId,
            combat_power = CombatPower, online_flag = OnlineFlag, last_logout_time = LastLogoutTime, create_time = CreateTime}) ->
        case CombatPower == 0 of
            true -> %% 战力为0去缓存拿一遍
                LastCombatPower = lib_role:get_role_combat_power(TmpRoleId);
            false ->
                LastCombatPower = CombatPower
        end,
        OfflineTime = ?IF(OnlineFlag == ?ONLINE_ON, 0, NowTime - LastLogoutTime),
        {TmpRoleId, Figure, Position, PrestigeTitleId, LastCombatPower, OnlineFlag, OfflineTime, CreateTime}
    end,
    List = lists:map(F, GuildMemberList),
    {ok, BinData} = pt_400:write(40006, [List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 退出公会
handle_cast({'quit_guild', RoleId}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_quit);
        is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_quit);
        true ->
            #guild_member{position = Position} = GuildMember,
            #guild{id = GuildId, member_num = _MemberNum} = Guild,
            if
                Position == ?POS_CHIEF ->
                    ErrorCode = ?ERRCODE(err400_chief_not_to_quit);
                % Position == ?POS_CHIEF andalso MemberNum == 1 ->
                %     case lib_mutex_check:check_disband_guild(GuildId) of
                %         true ->
                %             %% 如果公会只剩会长一人可以退出公会并且公会即时解散
                %             case lib_guild_mod:disband_guild(?DISBAND_REASON_CHIEF_QUIT, GuildId) of
                %                 ok -> ErrorCode = ?SUCCESS;
                %                 _ -> ErrorCode = ?FAIL
                %             end;
                %         {false, ErrorCode} -> skip
                %     end;
                true ->
                    ErrorCode = ?SUCCESS,
                    lib_guild_data:delete_guild_member_on_db_and_p(GuildMember),
                    NewGuild = lib_guild_data:get_guild_by_id(GuildId),
                    lib_guild_api:quit_guild(?GEVENT_QUIT, NewGuild, GuildMember)
            end
    end,
    {ok, BinData} = pt_400:write(40007, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 会长主动解散公会
handle_cast({'chief_disband_guild', RoleId}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_quit);
        is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_quit);
        true ->
            #guild_member{position = Position} = GuildMember,
            #guild{id = GuildId} = Guild,
            if
                Position =/= ?POS_CHIEF ->
                    ErrorCode = ?ERRCODE(err400_chief_not_to_disband);
                true ->
                    case lib_mutex_check:check_disband_guild(GuildId) of
                        true ->
                            case lib_guild_mod:disband_guild(?DISBAND_REASON_CHIEF_DISBAND, GuildId) of
                                ok -> ErrorCode = ?SUCCESS;
                                _ -> ErrorCode = ?FAIL
                            end;
                        {false, ErrorCode} -> skip
                    end
            end
    end,
    ?PRINT("chief_disband_guild ~p~n", [ErrorCode]),
    {ok, Bin} = pt_400:write(40027, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

%% 申请列表
handle_cast({'send_guild_apply_list', RoleId, GuildId}, State) ->
    ApplyList = lib_guild_mod:get_guild_apply_list(GuildId),
    {ok, BinData} = pt_400:write(40008, [ApplyList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 审批公会请求
handle_cast({'approve_guild_apply', RoleId, ApplyRoleId, ApplyRoleInfoMap, Type}, State) ->
    lib_guild_mod:approve_guild_apply(RoleId, ApplyRoleId, ApplyRoleInfoMap, Type),
    {noreply, State};

%% 审批设置界面
handle_cast({'send_approve_setting_view', RoleId, GuildId}, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> skip;
        Guild ->
            #guild{approve_type = ApproveType, auto_approve_lv = AutoApproveLv, auto_approve_power = AutoApprovePower} = Guild,
            {ok, BinData} = pt_400:write(40010, [ApproveType, AutoApproveLv, AutoApprovePower]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

%% 设置审批
handle_cast({'setting_approve', RoleId, ApproveType, AutoApproveLv, AutoApprovePower}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_approve_setting);
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsAllowModify = lists:member(?PERMISSION_APPROVE_SETTING, PermissionList),
            Guild = lib_guild_data:get_guild_by_id(GuildId),
            if
                is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_approve_setting);
                IsAllowModify == false -> ErrorCode = ?ERRCODE(err400_no_permission);
                true ->
                    ?PRINT("setting_approve succ ~p~n", [{ApproveType, AutoApproveLv, AutoApprovePower}]),
                    ErrorCode = ?SUCCESS,
                    Sql = io_lib:format(?sql_guild_update_approve, [ApproveType, AutoApproveLv, AutoApprovePower, GuildId]),
                    db:execute(Sql),
                    NewGuild = Guild#guild{approve_type = ApproveType, auto_approve_lv = AutoApproveLv, auto_approve_power = AutoApprovePower},
                    lib_guild_data:update_guild(NewGuild)
            end
    end,
    {ok, BinData} = pt_400:write(40011, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 公告编辑界面
handle_cast({'send_announce_view_info', Sid, GuildId}, State) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) == false ->
            lib_guild:send_error_code(Sid, ?ERRCODE(err400_not_on_guild_to_modify_announce));
        true ->
            #guild{modify_times = ModifyTimes} = Guild,
            FreeModifyTimes = data_guild_m:get_config(free_modify_times),
            {ok, BinData} = pt_400:write(40019, [max(0, FreeModifyTimes - ModifyTimes), FreeModifyTimes]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};

handle_cast({'modify_announce_by_gm', GuildId, Announce}, State) ->
    Len = data_guild_m:get_config(announce_len),
    CheckLength = util:check_length(Announce, Len),
    CheckKeyWord = lib_word:check_keyword_name(Announce),
    if
        GuildId =< 0 -> skip;
        CheckLength == false -> skip;
        CheckKeyWord -> skip;
        true ->
            Guild = lib_guild_data:get_guild_by_id(GuildId),
            if
                is_record(Guild, guild) == false ->
                    ?ERR("guild not exist:~p", [GuildId]);
                true ->
                    #guild{modify_times = ModifyTimes, chief_id = ChiefId} = Guild,
                    AnnounceBin = util:make_sure_binary(Announce),
                    Sql = io_lib:format(?sql_guild_update_announce_and_modify_times, [util:fix_sql_str(AnnounceBin), ModifyTimes, GuildId]),
                    db:execute(Sql),
                    NewGuild = Guild#guild{announce = AnnounceBin},
                    lib_guild_data:update_guild(NewGuild),
                    lib_mail:send_guild_mail([ChiefId], utext:get(4000020), utext:get(4000021), [])
            end
    end,
    {noreply, State};

%% 编辑公告
handle_cast({'modify_announce', RoleId, SaveType, Announce}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_announce);
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsAllowModify = lists:member(?PERMISSION_MODIFY_TENET_AND_ANNOUNCE, PermissionList),
            Guild = lib_guild_data:get_guild_by_id(GuildId),
            NowTime = utime:unixtime(),
            if
                is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_announce);
                IsAllowModify == false -> ErrorCode = ?ERRCODE(err400_not_permission_to_modify_announce);
                Guild#guild.lv < 4 -> ErrorCode = ?ERRCODE(err400_guild_level_not_enough);
                true ->
                    IsSameDay = utime:is_same_day(NowTime, Guild#guild.modify_time),
                    if
                        IsSameDay == true -> ErrorCode = ?ERRCODE(err400_announce_times);
                        true ->
                            IsForbidGm = lib_guild:db_announce_forbid_by_gm(GuildId),
                            if
                                IsForbidGm -> ErrorCode = ?ERRCODE(err400_announce_forbid_gm);
                                true ->
                                    #guild{modify_times = ModifyTimes} = Guild,
                                    % FreeModifyTimes = data_guild_m:get_config(free_modify_times),
                                    % ErrorCode = case ModifyTimes >= FreeModifyTimes of
                                    %     true ->
                                    %         Cost = data_guild_m:get_config(modify_announce_cost_gold),
                                    %         case catch lib_player:apply_call(RoleId, ?APPLY_CALL_SAVE, lib_goods_api, cost_money, [[{?TYPE_GOLD, 0, Cost}], modify_announce, ""], 2000) of
                                    %             1 -> ?SUCCESS;
                                    %             0 -> ?ERRCODE(gold_not_enough);
                                    %             Err -> ?ERR("modify announce cost gold err:~p", [Err]), ?FAIL
                                    %         end;
                                    %     false -> ?SUCCESS
                                    % end,
                                    ErrorCode = ?SUCCESS,
                                    case ErrorCode == ?SUCCESS of
                                        true ->
                                            NewModifyTimes = ModifyTimes + 1,
                                            AnnounceBin = util:make_sure_binary(Announce),
                                            Sql = io_lib:format(?sql_guild_update_announce_and_modify_times_and_time, [util:fix_sql_str(AnnounceBin), NewModifyTimes, NowTime, GuildId]),
                                            db:execute(Sql),
                                            NewGuild = Guild#guild{announce = AnnounceBin, modify_times = NewModifyTimes, modify_time = NowTime},
                                            lib_guild_data:update_guild(NewGuild),
                                            case SaveType == 2 of
                                                true ->
                                                    %% 给公会成员发邮件
                                                    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                                                    RoleIdList = maps:keys(GuildMemberMap),
                                                    lib_mail:send_guild_mail(RoleIdList, utext:get(4000005), Announce, []);
                                                false -> skip
                                            end;
                                        false -> skip
                                    end
                            end
                    end
            end
    end,
    {ok, BinData} = pt_400:write(40012, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 任命职位
handle_cast({'appoint_position', RoleId, AppointeeId, Position}, State) ->
    lib_guild_mod:appoint_position(RoleId, AppointeeId, Position),
    {noreply, State};

%% 踢出公会
handle_cast({'kick_out_guild', RoleId, LeaveId}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    LeaveGuildMember = lib_guild_data:get_guild_member_by_role_id(LeaveId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_kick);
        is_record(LeaveGuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_kicked);
        GuildMember#guild_member.guild_id =/= LeaveGuildMember#guild_member.guild_id ->
            ErrorCode = ?ERRCODE(err400_not_same_guild_to_kick);
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            #guild_member{position = LeavePosition} = LeaveGuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsAllowKick = lists:member(?PERMISSION_FIRE_MEMBER, PermissionList),
            PositionNo = data_guild_m:get_position_no(Position),
            LeavePositionNo = data_guild_m:get_position_no(LeavePosition),
            if
                IsAllowKick == false -> ErrorCode = ?ERRCODE(err400_not_permission_to_kick);
                % LeavePosition == ?POS_CHIEF -> ErrorCode = ?ERRCODE(err400_this_position_can_not_kick_member);
                PositionNo =< LeavePositionNo -> ErrorCode = ?ERRCODE(err400_this_position_can_not_kick_member);
                true ->
                    ErrorCode = ?SUCCESS,
                    lib_guild_data:delete_guild_member_on_db_and_p(LeaveGuildMember),
                    Guild = lib_guild_data:get_guild_by_id(GuildId),
                    lib_guild_api:quit_guild(?GEVENT_KICK_OUT, Guild, LeaveGuildMember),
                    % 推送当前公会成员列表给任命者
                    mod_guild:send_guild_member_short_info(RoleId, GuildId, 0, 0, 0, 0)
            end
    end,
    {ok, BinData} = pt_400:write(40014, [ErrorCode, LeaveId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 清空申请列表
handle_cast({'clean_all_guild_apply_on_this_guild', RoleId}, State) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_clean_apply);
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_clean_apply);
        true ->
            #guild{id = GuildId} = Guild,
            % 权限
            #guild_member{position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsAllow = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
            if
                IsAllow == false -> ErrorCode = ?ERRCODE(err400_no_permission);
                true ->
                    ErrorCode = ?SUCCESS,
                    Sql = io_lib:format(?sql_guild_apply_delete_by_guild_id, [GuildId]),
                    db:execute(Sql),
                    lib_guild_data:delete_guild_apply_by_guild_id(GuildId),
                    lib_guild_mod:broadcast_guild_apply_list(GuildId)
                    % lib_guild_mod:send_guild_apply_red_point(GuildId)
            end
    end,
    {ok, BinData} = pt_400:write(40016, [ErrorCode, 2]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 全部批准入会
handle_cast({'approve_all_guild_apply_on_this_guild', RoleId}, State) ->
    lib_guild_mod:approve_all_guild_apply_on_this_guild(RoleId),
    {noreply, State};

%% 升级公会
handle_cast({'upgrade_guild', RoleId}, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> ErrorCode = ?ERRCODE(err400_guild_not_exist);
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            case lib_guild_data:get_guild_by_id(GuildId) of
                #guild{} = Guild ->
                    PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
                    IsAllowModify = lists:member(?PERMISSION_UPGRADE_GUILD, PermissionList),
                    if
                        IsAllowModify == false -> ErrorCode = ?ERRCODE(err400_no_permission);
                        true ->
                            {ErrorCode, NewGuild} = lib_guild_mod:upgrade_guild_core(Guild),
                            lib_guild_data:update_guild(NewGuild)
                    end;
                _ ->
                    ErrorCode = ?ERRCODE(err400_guild_not_exist)
            end
    end,
    {ok, BinData} = pt_400:write(40018, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

%% 增加公会资金
handle_cast({'add_gfunds', RoleId, GuildId, AddGfunds, Type}, State) ->
    lib_guild_mod:add_gfunds(RoleId, GuildId, AddGfunds, Type),
    {noreply, State};

%% 增加贡献
handle_cast({'add_donate', RoleId, AddDonate, ProduceType, Extra}, State) ->
    lib_guild_mod:add_donate(RoleId, AddDonate, ProduceType, Extra),
    {noreply, State};

%% 增加贡献成长值
handle_cast({'add_growth', RoleId, GuildId, AddGrowth, ProduceType, Extra}, State) ->
    lib_guild_mod:add_growth(RoleId, GuildId, AddGrowth, ProduceType, Extra),
    {noreply, State};

%% 增加公会活跃度
handle_cast({'add_gactivity', RoleId, GuildId, GActivity, Type}, State) ->
    lib_guild_mod:add_gactivity(RoleId, GuildId, GActivity, Type),
    {noreply, State};

%% 增加公会副本积分
handle_cast({'add_guild_dun_score', RoleId, GuildId, DunScore, Type}, State) ->
    lib_guild_mod:add_guild_dun_score(RoleId, GuildId, DunScore, Type),
    {noreply, State};

%% 自动任命为会长
handle_cast({'auto_appoint_to_chief', DelaySec}, State) ->
    lib_guild_mod:auto_appoint_to_chief(DelaySec),
    {noreply, State};

handle_cast({'auto_appoint_to_chief_by_guild_id', GuildId}, State) ->
    lib_guild_mod:auto_appoint_to_chief_by_guild_id(GuildId),
    {noreply, State};

%% 更新公会成员属性
handle_cast({'update_guild_member_attr', RoleId, AttrList}, State) ->
    lib_guild_mod:update_member_and_guild_attr(RoleId, AttrList),
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> skip;
        is_record(GuildMember, guild_member) == false -> skip;
        true ->
            lib_guild_api:guild_af_update_member_attr(Guild, GuildMember, AttrList)
    end,
    {noreply, State};

%% 发送公会邮件
handle_cast({'send_guild_mail_by_role_id', RoleId, Title, Content, CmAttachment, ExcludeIdList}, State) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> skip;
        true ->
            GuildMemberMap = lib_guild_data:get_guild_member_map(Guild#guild.id),
            RoleIdList = maps:keys(GuildMemberMap) -- ExcludeIdList,
            lib_mail:send_guild_mail(RoleIdList, Title, Content, CmAttachment)
    end,
    {noreply, State};

%% 发送公会邮件
handle_cast({'send_guild_mail_by_guild_id', GuildId, Title, Content, CmAttachment, ExcludeIdList}, State) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) == false -> skip;
        true ->
            GuildMemberMap = lib_guild_data:get_guild_member_map(Guild#guild.id),
            RoleIdList = maps:keys(GuildMemberMap) -- ExcludeIdList,
            lib_mail:send_guild_mail(RoleIdList, Title, Content, CmAttachment)
    end,
    {noreply, State};

%% 玩家拥有的权限列表
handle_cast({'send_role_permission_list', RoleId}, State) ->
    lib_guild_mod:send_role_permission_list(RoleId),
    {noreply, State};

%% 红点信息
handle_cast({'send_red_point', GuildId, RoleId, Type}, State) ->
    if
        Type == ?RED_POINT_GUILD_APPLY ->
            GuildMember = lib_guild_data:get_guild_member(GuildId, RoleId),
            GuildApplyMap = lib_guild_data:get_guild_apply_map_by_guild_id(GuildId),
            GuildApplySize = maps:size(GuildApplyMap),
            #guild_member{position = Position} = GuildMember,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            IsAllowModify = lists:member(?PERMISSION_APPROVE_APPLY, PermissionList),
            case IsAllowModify of
                true ->
                    lib_guild_mod:send_red_point(RoleId, Type, GuildApplySize);
                false -> skip
            end;
        true -> skip
    end,
    {noreply, State};

%% 解散公会
handle_cast({'disband_guild', DisbandType, GuildId}, State) ->
    lib_guild_mod:disband_guild(DisbandType, GuildId),
    {noreply, State};

handle_cast({'apply_cast_guild_member', GuildId, MemberType, Module, Method, Args}, State) ->
    GuildMemberList = lib_guild_data:search_guild_member(GuildId, 0, 0, 0, MemberType, 0),
    F = fun(#guild_member{id = PlayerId}) -> lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, Module, Method, Args) end,
    lists:foreach(F, GuildMemberList),
    {noreply, State};

%% 清理
handle_cast({'day_clear', Clock, DelaySec}, State) ->
    lib_guild_mod:day_clear(Clock, DelaySec),
    {noreply, State};

%% 更新公会的创建时间
handle_cast({'update_guild_create_time', GuildId, CreateTime}, State) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    if
        is_record(Guild, guild) == false -> skip;
        true ->
            Sql = io_lib:format(?sql_guild_update_create_time, [CreateTime, GuildId]),
            db:execute(Sql),
            lib_guild_data:update_guild(Guild#guild{create_time = CreateTime})
    end,
    {noreply, State};

% %% 定制活动定时奖励发放
% handle_cast({'ac_custom_timer_reward', ModuleSub, AcSub, GuildRankList}, State) ->
%     F = fun({GuildId, Rank}, TmpMap) ->
%         GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
%         F = fun(RoleId, #guild_member{position = Position, create_time = CreateTime}, TmpList) ->
%             [{RoleId, Position, CreateTime}|TmpList]
%         end,
%         RoleInfoList = maps:fold(F, [], GuildMemberMap),
%         TmpMap#{Rank=>RoleInfoList}
%     end,
%     Map = lists:foldl(F, #{}, GuildRankList),
%     spawn(lib_ac_custom_reward, ac_custom_timer_reward, [ModuleSub, AcSub, Map]),
%     {noreply, State};

%% 更新玩家的战力
handle_cast({'update_guild_member_power', RoleId, CombatPower}, State) ->
    % Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    if
        is_record(GuildMember, guild_member) == false -> skip;
        true ->
            #guild_member{h_combat_power = OldHCombatPower} = GuildMember,
            HCombatPower = max(CombatPower, OldHCombatPower),
            NewGuildMember = GuildMember#guild_member{combat_power = CombatPower, h_combat_power = HCombatPower},
            lib_guild_data:update_guild_member(NewGuildMember)
            % #guild{combat_power = GuildCombatPower} = Guild,
            % NewGuild = Guild#guild{combat_power = max(GuildCombatPower+CombatPower-OldCombatPower, 0)},
            % lib_guild_data:update_guild(NewGuild)
    end,
    {noreply, State};

%% 检测是否需要解散帮派
handle_cast({'check_auto_disband_guild', GuildId}, State) ->
    lib_guild_mod:check_auto_disband_guild(GuildId),
    {noreply, State};

%% 更新公会的战力值
handle_cast({'count_guild_combat_power'}, State) ->
    NowTime = utime:unixtime(),
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    F = fun(TGuild) ->
        #guild{id = GuildId} = TGuild,
        SumCombatPower = lib_guild_util:count_guild_combat_power(GuildId, NowTime),
        CombatPowerTen = lib_guild_util:count_guild_combat_power_ten(GuildId, NowTime),

        LastGuild = TGuild#guild{combat_power = SumCombatPower, combat_power_ten = CombatPowerTen},
        lib_guild_api:guild_power_change(LastGuild),
        %% 刷新榜单
        lib_common_rank_api:reflash_rank_by_guild(LastGuild),

        lib_guild_data:update_guild(LastGuild)
    end,
    lists:foreach(F, GuildList),
    lib_guild_data:sort_guild_by_level(),
    {noreply, State};

%% =====================================
%% 公会仓库相关cast
%% =====================================
handle_cast({'send_guild_depot_info', RoleId, GuildId}, State) ->
    lib_guild_depot_mod:send_guild_depot_info(RoleId, GuildId),
    {noreply, State};

handle_cast({'send_auto_destroy_setting', RoleId}, State) ->
    lib_guild_depot_mod:send_auto_destroy_setting(RoleId),
    {noreply, State};

handle_cast({'add_to_depot', RoleId, RoleName, GoodsInfo, Num}, State) ->
    lib_guild_depot_mod:add_to_depot(RoleId, RoleName, GoodsInfo, Num),
    {noreply, State};

handle_cast({'add_to_depot', RoleId, RoleName, GoodsInfoL}, State) ->
    lib_guild_depot_mod:add_to_depot(RoleId, RoleName, GoodsInfoL),
    {noreply, State};

handle_cast({'exchange_depot_goods', RoleId, RoleName, DepotGoodsId, GoodsTypeId, Num}, State) ->
    DepotExpGoodsId = ?DEPOT_EXP_GOODS_ID,
    case {DepotGoodsId, GoodsTypeId} of
        {?GUILD_DEPOT_TASK_EQUIP, _} -> % 兑换任务
            lib_guild_depot_mod:exchange_excg_task_goods(RoleId, RoleName, GoodsTypeId, Num);
        {_, DepotExpGoodsId} -> % 经验物品
            lib_guild_depot_mod:exchange_special_goods(RoleId, RoleName, GoodsTypeId, Num);
        _ ->
            lib_guild_depot_mod:exchange_depot_goods(RoleId, RoleName, DepotGoodsId, Num)
    end,
    {noreply, State};

handle_cast({'destory_depot_goods', RoleId, RoleName, OpType, Args}, State) ->
    lib_guild_depot_mod:destory_depot_goods(RoleId, RoleName, OpType, Args),
    {noreply, State};

%% =====================================
%% 公会技能相关cast
%% =====================================
handle_cast({'send_guild_skill_list', RoleId, GuildId, PlayerGSkillMap, SkillType, OriginalAttr, RoleLv}, State) ->
    case lib_guild_data:get_guild_member(GuildId, RoleId) of
        #guild_member{donate = Donate} -> skip;
        _ -> Donate = 0
    end,
    GuildSkillList = lib_guild_skill_data:get_guild_skill_list(GuildId),
    PackSkillList = lib_guild_skill:pack_guild_skill_list(SkillType, PlayerGSkillMap, GuildSkillList, OriginalAttr, RoleLv),
    {ok, BinData} = pt_400:write(40040, [Donate, PackSkillList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

handle_cast({'research_skill', RoleId, SkillId}, State) ->
    lib_guild_mod:research_skill(RoleId, SkillId),
    {noreply, State};

%% =====================================
%% 公会晚宴相关cast
%% =====================================
handle_cast({'give_gfeast_red_envelopes', GuildId, RankNo, RedEnvelopesCfgId}, State) ->
    case lib_guild_data:get_chief(GuildId) of
        #guild_member{id = ChiefId, guild_name = GuildName} ->
            lib_red_envelopes:give_gfeast_red_envelopes(GuildId, GuildName, ChiefId, RankNo, RedEnvelopesCfgId);
        _ -> skip
    end,
    {noreply, State};

%% =====================================
%% 公会战相关cast
%% =====================================
handle_cast({'sync_guild_list_to_gwar'}, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    mod_guild_war:sync_guild_list(maps:values(GuildMap)),
    {noreply, State};

handle_cast({'update_guild_division', DivisionIndexMap}, State) ->
    case maps:size(DivisionIndexMap) > 0 of
        true ->
            GuildMap = lib_guild_data:get_guild_map(),
            F = fun(GuildId, Guild) ->
                Division = maps:get(GuildId, DivisionIndexMap, 0),
                Guild#guild{division = Division}
            end,
            NewGuildMap = maps:map(F, GuildMap),
            lib_guild_data:save_guild_map(NewGuildMap);
        false -> skip
    end,
    {noreply, State};

%% =====================================
%% 公会榜单结算逻辑
%% =====================================
handle_cast({'send_guild_rank_reward', PreFirGuildId, CurFirGuildId, DesignationId}, State) ->
    case PreFirGuildId > 0 of
        true ->
            PreFirGuildMIds = lib_guild_data:get_all_role_in_guild(PreFirGuildId);
        false ->
            PreFirGuildMIds = lib_guild_data:get_all_role_in_guild()
    end,
    %% 移除上一次的第一名公会成员称号
    case (PreFirGuildId == 0 orelse PreFirGuildId =/= CurFirGuildId) andalso PreFirGuildMIds =/= [] of
        true ->
            NowTime = utime:unixtime(),
            Sql = io_lib:format(?SQL_DSGT_UPDATE_ETIME, [NowTime, NowTime, DesignationId, util:link_list(PreFirGuildMIds)]),
            db:execute(Sql),
            F = fun(TRoleId) ->
                lib_designation_api:cancel_dsgt_online(TRoleId, DesignationId)
            end,
            lists:foreach(F, PreFirGuildMIds);
        false -> skip
    end,
    CurFirGuildMIds = lib_guild_data:get_all_role_in_guild(CurFirGuildId),
    F1 = fun(TRoleId, AccNum) ->
            case AccNum rem 20 of
                0 -> timer:sleep(100);
                _ -> skip
            end,
            lib_designation_api:active_dsgt_common(TRoleId, DesignationId),
            AccNum + 1
    end,
    spawn(fun() -> lists:foldl(F1, 1, CurFirGuildMIds) end),
    {noreply, State};

handle_cast({check_rename_guild, GuildId, RoleId, [GuildName|_]}, State) ->
    Guild = lib_guild_data:get_guild_by_id(GuildId),
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    IsBanRename = lib_game:is_ban_rename(),
    Res
    = if
        is_record(Guild, guild) == false -> {false, ?ERRCODE(err400_approver_not_on_guild)};
        is_record(GuildMember, guild_member) == false -> {false, ?ERRCODE(err400_approver_not_on_guild)};
        IsBanRename -> {false, ?ERRCODE(err426_update_rename_system)};
        true ->
            #guild_member{guild_id = GuildId, position = Position} = GuildMember,
            #guild{name = GuildName0, c_rename_time = LastRenameTime} = Guild,
            PermissionList = lib_guild_mod:get_position_permission_list(GuildId, Position),
            GuildNameBin0 = util:make_sure_binary(GuildName0),
            GuildNameBin = util:make_sure_binary(GuildName),
            CheckList = [
                % 校验字符串
                {fun() -> GuildName =/= "" end, ?ERRCODE(err400_guild_name_null)},
                {fun() -> GuildNameBin0 =/= GuildNameBin end, ?ERRCODE(err400_guild_name_same)},
                {fun() -> util:check_length_without_code(GuildName, data_guild_m:get_config(guild_name_len)) == true end, ?ERRCODE(err400_guild_name_len)},
                {fun() -> lib_word:check_keyword_name(GuildName) == false end, ?ERRCODE(err400_guild_name_sensitive)},
                {fun() -> lists:member(?PERMISSION_RENAME, PermissionList) end, ?ERRCODE(err400_no_permission)},
                {fun() -> utime:unixtime() - LastRenameTime > data_guild:get_cfg(rename_interval) end, ?ERRCODE(err400_rename_frequent)},
                {fun() ->
                    NewGuildName = string:to_upper(util:make_sure_list(GuildName)),
                    GuildUpperMap = lib_guild_data:match_guild({name_upper, NewGuildName}),
                    is_map(GuildUpperMap) andalso GuildUpperMap == #{}
                end, ?ERRCODE(err400_guild_name_repeat)}
            ],
            util:check_list(CheckList)
    end,
    case Res of
        {false, ErrorCode} ->
            {ok, BinData} = pt_400:write(40000, [ErrorCode]),
            lib_server_send:send_to_uid(RoleId, BinData);
        true ->
            Cost
            = if
                Guild#guild.c_rename =:= 1 ->
                    [];
                true ->
                    data_guild:get_cfg(rename_cost_goods) % [{priority, GoodsList},...]
            end,
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild, check_rename_guild_pass, [Cost, GuildId, GuildName])
    end,
    {noreply, State};

handle_cast({rename_guild, GuildId, RoleId, [GuildName, Cost|_]}, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        Guild when is_record(Guild, guild) ->
            case lib_guild_data:get_guild_member_by_role_id(RoleId) of
                Me when is_record(Me, guild_member) ->
                    F = fun
                        () ->
                            lib_guild_data:db_guild_update_name(GuildId, GuildName),
                            ok
                    end,
                    case catch db:transaction(F) of
                        ok ->
                            GuildNameBin = util:make_sure_binary(GuildName),
                            GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                            NewGuildMemberMap = maps:map(fun
                                (_, GuildMember) ->
                                    if
                                        is_record(GuildMember, guild_member) ->
                                            if
                                                GuildMember#guild_member.online_flag =:= ?ONLINE_ON ->
                                                    lib_player:apply_cast(GuildMember#guild_member.id, ?APPLY_CAST_STATUS, lib_guild, update_guild_name, [GuildId, GuildNameBin]);
                                                true ->
                                                    skip
                                            end,
                                            GuildMember#guild_member{guild_name = GuildNameBin};
                                        true ->
                                            GuildMember
                                    end
                            end, GuildMemberMap),
                            NameUpper = string:to_upper(util:make_sure_list(GuildName)),
                            NewGuild = Guild#guild{name = GuildNameBin, name_upper = NameUpper, c_rename = 0, c_rename_time = utime:unixtime()},
                            lib_guild_data:update_guild(NewGuild),
                            lib_guild_data:set_guild_member_map(GuildId, NewGuildMemberMap),
                            lib_log_api:log_rename_guild(GuildId, RoleId, Guild#guild.name, GuildNameBin, Guild#guild.c_rename),
                            {ok, BinData} = pt_400:write(40043, [?SUCCESS, GuildName]),
                            lib_server_send:send_to_uid(RoleId, BinData),
                            RoleIdList = maps:keys(GuildMemberMap),
                            lib_mail:send_guild_mail(RoleIdList, utext:get(4000018), utext:get(4000019, [GuildNameBin]), []),
                            lib_chat:send_TV({all}, ?MOD_GUILD, 10, [Guild#guild.name, GuildNameBin]),
                            mod_seacraft_local:change_guild_info(config:get_server_id(), Guild#guild.realm, [{name, GuildId, GuildNameBin}]),
                            ok;
                        _Error ->
                            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild, rename_guild_fail, [Cost, ?FAIL])
                    end;
                _ ->
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild, rename_guild_fail, [Cost, ?ERRCODE(err400_no_permission)])
            end;
        _ ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild, rename_guild_fail, [Cost, ?ERRCODE(err400_guild_not_exist)])
    end,
    {noreply, State};

handle_cast({check_rename_guild_free, GuildId, RoleId}, State) ->
    % 获取是否有免费机会和上次改名时间
    case lib_guild_data:get_guild_by_id(GuildId) of
        #guild{c_rename = 1, c_rename_time = LastRenameTime} ->
            Free = ?FREE;
        #guild{c_rename_time = LastRenameTime} ->
            Free = ?NOT_FREE;
        _ ->
            LastRenameTime = 0,
            Free = ?NOT_FREE
    end,
    % 计算下次可改名时间倒计时
    NowTime = utime:unixtime(),
    RenameInterval = data_guild:get_cfg(rename_interval),
    case LastRenameTime + RenameInterval =< NowTime of
        true ->
            NextRenameTime = 0;
        false ->
            NextRenameTime = LastRenameTime + RenameInterval - NowTime
    end,
    {ok, BinData} = pt_400:write(40044, [Free, NextRenameTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

handle_cast({'send_seas_dominator_info', Node, RoleId, GuildId}, State) ->
    PositionMemberMap = lib_guild_data:match_guild_member({specify_positions, GuildId, [?POS_CHIEF, ?POS_DUPTY_CHIEF]}),
    F = fun(GuildMember, Acc) ->
        case GuildMember of
            #guild_member{
                id = TmpRoleId, position = TmpPosition, figure = TmpFigure
            } ->
                case TmpPosition of
                    ?POS_CHIEF ->
                        #figure{marriage_type = MarriageType, lover_role_id = LoverRoleId} = lib_role:get_role_figure(TmpRoleId),
                        case MarriageType == 2 andalso LoverRoleId > 0 of
                            true ->
                                LoverFigure = lib_role:get_role_figure(LoverRoleId),
                                [{3, LoverFigure}, {TmpPosition, TmpFigure}|Acc];
                            _ ->
                                [{TmpPosition, TmpFigure}|Acc]
                        end;
                    _ ->
                        [{TmpPosition, TmpFigure}|Acc]
                end;
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], maps:values(PositionMemberMap)),
    {ok, BinData} = pt_437:write(43730, [PackList]),
    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, RoleId, BinData]),
    {noreply, State};

handle_cast({'send_chief_figure_info', Node, RoleId, GuildId, ArgsMap}, State) ->
    ChiefGuildMember = lib_guild_data:get_chief(GuildId),
    case ChiefGuildMember of
        #guild_member{
            id = ChiefId,
            figure = Figure
        } ->
            #{ser_id := SerId, mod_id := ModId} = ArgsMap,
            {ok, BinData} = pt_130:write(13014, [SerId, GuildId, ModId, ChiefId, Figure]),
            case Node =/= none of
                true ->
                    mod_clusters_node:apply_cast(lib_server_send, send_to_uid, [Node, RoleId, BinData]);
                _ ->
                    lib_server_send:send_to_uid(RoleId, BinData)
            end;
        _ -> skip
    end,
    {noreply, State};

%%圣域的个人排行榜结算
handle_cast({'do_result_guild_person_rank', DesignationMap, BelongSanctuaryList}, State) ->
    lib_sanctuary:do_result_guild_person_rank(DesignationMap, BelongSanctuaryList),
    {noreply, State};

%%圣域的个人排行榜结算
handle_cast({'get_guild_rank_info_with_guild_id', RoleId, GuildId, DesignationMap}, State) ->
	lib_sanctuary:get_guild_rank_info_with_guild_id(RoleId, GuildId, DesignationMap),
	{noreply, State};

handle_cast({'get_guild_rank_info_with_sanctuary_id', RoleId, SanctuaryId, BelongGuild, DesignationMap}, State) ->
	lib_sanctuary:get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId, BelongGuild, DesignationMap),
	{noreply, State};
handle_cast({'send_to_guild_member_sanctuary_settlement', GuildId, Rank}, State) ->
    lib_sanctuary:send_to_guild_member_sanctuary_settlement(GuildId, Rank),
    {noreply, State};

%% 更新圣域公会前三名
handle_cast({'update_sanctuary_top3_guild_list', GuildIdList}, State) ->
    lib_guild_data:update_sanctuary_top3_guild_list(GuildIdList),
    {noreply, State};

%% 公会晚宴召唤巨龙
handle_cast({'summon_guild_feast_dragon', MonId, GuildId, RoleId}, State) ->
    Lv = lib_guild_data:get_top_avg_lv(GuildId, ?guild_feast_top_num),
    lib_guild_feast:do_summon_dragon(GuildId, Lv, MonId, RoleId),
    {noreply, State};

%% 发送招募列表
handle_cast({'send_recruit_list', RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount}, State) ->
    lib_guild_mod:send_recruit_list(RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount),
    {noreply, State};

%% 队员招募列表
handle_cast({'send_recruit_list', RoleId, GuildId}, State) ->
    lib_guild_mod:send_recruit_list(RoleId, GuildId),
    {noreply, State};

%% 队员招募列表
handle_cast({'send_recruit_3v3_list', RoleId, GuildId}, State) ->
    lib_guild_mod:send_recruit_3v3_list(RoleId, GuildId),
    {noreply, State};

handle_cast({'get_guild_rank_info', CopyId}, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildIdSort = lib_guild_data:get_sort_guild_id_list(),
    F = fun(GuildId, {List, Rank}) ->
        case maps:get(GuildId, GuildMap, 0) of
            #guild{} = _Guild -> {[{GuildId, Rank}|List], Rank+1}; _ -> {List, Rank}
        end
    end,
    {GuildListSort, _} = lists:foldl(F, {[], 1}, GuildIdSort),
    mod_territory_treasure:calc_guild_auction(lists:reverse(GuildListSort), CopyId),
    {noreply, State};

handle_cast({'add_role_prestige', RoleId, NewPrestige, AddNum}, State) ->
    case lib_guild_data:get_guild_member_by_role_id(RoleId) of
        GuildMember when is_record(GuildMember, guild_member) ->
            %% 声望头衔升级，广播
            NewGuildMember = lib_guild_mod:refres_prestige_and_title(GuildMember, NewPrestige, AddNum),
            lib_guild_data:update_guild_member(NewGuildMember);
        [] -> skip
    end,
    {noreply, State};

handle_cast({'sync_position_prestige'}, State) ->
    %% 职位同步
    GuildMap = lib_guild_data:get_guild_map(),
    Fun = fun({GuildId, _Guild}) ->
        GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
        MemberIdList = [{MemberId, Position}||{MemberId, #guild_member{position = Position}}<-maps:to_list(GuildMemberMap)],
        mod_guild_prestige:sync_guild_job(MemberIdList)
     end,
    lists:foreach(Fun, maps:to_list(GuildMap)),
    {noreply, State};

handle_cast({'update_members_prestige', GuildId, PrestigeList}, State) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    F = fun({RoleId, Prestige}, Map) ->
        case maps:get(RoleId, Map, 0) of
            GuildMember when is_record(GuildMember, guild_member) ->
                PrestigeTitleId = lib_guild_data:get_prestige_title_id(Prestige),
                NewGuildMember = GuildMember#guild_member{prestige = Prestige, prestige_title = PrestigeTitleId},
                maps:put(RoleId, NewGuildMember, Map);
            _ ->
                Map
        end
    end,
    NewGuildMemberMap = lists:foldl(F, GuildMemberMap, PrestigeList),
    lib_guild_data:set_guild_member_map(GuildId, NewGuildMemberMap),
    {noreply, State};

%% 更新公会阵营
handle_cast({'update_guild_realm', GuildCampList}, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    F = fun(TGuild) ->
        #guild{id = GuildId, realm = OldRealm} = TGuild,
        Realm = lib_seacraft:get_guild_realm(GuildId, GuildCampList),
        if
            OldRealm =/= Realm ->
                Sql = io_lib:format(?sql_guild_update_realm, [Realm, GuildId]),
                db:execute(Sql),
                GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                spawn(fun() ->
                    [lib_player:apply_cast(GuildMember#guild_member.id, ?APPLY_CAST_STATUS, lib_guild, update_guild_realm, [Realm])
                        ||GuildMember<-maps:values(GuildMemberMap), GuildMember#guild_member.online_flag =:= ?ONLINE_ON]
                      end),
                lib_guild_data:update_guild(TGuild#guild{realm = Realm});
            true ->
                skip
        end
    end,
    lists:foreach(F, GuildList),
    {noreply, State};

%% 更新公会阵营
%% 在同步工会成员数据
handle_cast({'update_guild_realm', Realm, OldRealm, GuildId}, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        #guild{id = GuildId, realm = OldRealm, name = GuildName} = Guild ->
            ServerId = config:get_server_id(),
            case Realm of
                0 -> %% 退出海域
                    mod_kf_seacraft:after_exit_camp(ServerId, OldRealm, GuildId);
                _ -> %% 加入海域，同步成员数据
                    MemberMap = lib_guild_data:get_guild_member_map(GuildId),
                    F = fun(_, GuildMember, GrandSendList) ->
                        RId = GuildMember#guild_member.id,
                        #figure{
                            vip = Vip, name = RName, lv = Lv, exploit = Exploit
                        } = GuildMember#guild_member.figure,
                        CombatPower = GuildMember#guild_member.combat_power,
                        [{RId, Vip, Lv, RName, Exploit, CombatPower}|GrandSendList]
                        end,
                    AllMemberInfos = maps:fold(F, [], MemberMap),
                    mod_kf_seacraft:auto_join_add_member(ServerId, Realm, GuildId, GuildName, AllMemberInfos)
            end,
            if
                OldRealm =/= Realm ->
                    Sql = io_lib:format(?sql_guild_update_realm, [Realm, GuildId]),
                    db:execute(Sql),
                    lib_guild_data:update_guild(Guild#guild{realm = Realm}),
                    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
                    spawn(fun() ->
                        [lib_player:apply_cast(GuildMember#guild_member.id, ?APPLY_CAST_STATUS, lib_guild, update_guild_realm, [Realm])
                            ||GuildMember<-maps:values(GuildMemberMap), GuildMember#guild_member.online_flag =:= ?ONLINE_ON]
                          end);
                true -> skip
            end;
        _ -> skip
    end,
    {noreply, State};

handle_cast({'join_sea_camp', Args}, State) ->
    {ServerId, ServerNum, GuildId, GuildName, RoleId, RoleName, Camp, RoleLv, Power, Picture, PictureVer} = Args,
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] ->
            {ok, BinData} = pt_186:write(18619, [?ERRCODE(err186_error_data)]),
            lib_server_send:send_to_uid(RoleId, BinData);
        #guild{member_num = GuildUserNum, combat_power_ten = GuildPower} ->
%%            MemberMap = lib_guild_data:get_guild_member_map(GuildId),
%%            AllMemberInfos =
%%                [begin
%%                     RId = GuildMember#guild_member.id,
%%                     #figure{
%%                         vip = Vip, name = RName, lv = Lv, exploit = Exploit
%%                     } = GuildMember#guild_member.figure,
%%                     CombatPower = GuildMember#guild_member.combat_power,
%%                     {RId, Vip, Lv, RName, Exploit, CombatPower}
%%                 end||GuildMember <- maps:values(MemberMap)],
            AllMemberInfos = [],
            SendArgs = [ServerId, ServerNum, GuildId, GuildName, GuildPower, RoleId, RoleName, GuildUserNum, Camp, RoleLv, Power, Picture, PictureVer, AllMemberInfos],
            mod_kf_seacraft:join_camp(SendArgs)
    end,
    {noreply, State};

handle_cast({'get_guild_member', GuildNum, LimitLv}, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildIdSort = lib_guild_data:get_sort_guild_id_list(),
    F = fun(GuildId, List) ->
        case maps:get(GuildId, GuildMap, 0) of
            #guild{realm = Realm} when Realm > 0 ->
                MemberMap = lib_guild_data:get_guild_member_map(GuildId),
                F1 = fun
                    (#guild_member{id = RId, figure = #figure{lv = Lv}}, Acc) when Lv >= LimitLv ->
                        [RId|Acc];
                    (_, Acc) -> Acc
                end,
                RoleIdList = lists:foldl(F1, [], maps:values(MemberMap)),
                [{GuildId, Realm, RoleIdList}|List];
             _ -> List
        end
    end,
    GuildIdListSort = lists:reverse(lists:foldl(F, [], GuildIdSort)),
    case length(GuildIdListSort) > GuildNum of
        true -> {Reply, _} = lists:split(GuildNum, GuildIdListSort);
        _ -> Reply = GuildIdListSort
    end,
    mod_seacraft_local:gm_send_reward(Reply),
    {noreply, State};

handle_cast({'gm_flush_member_info'}, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    [begin
         MemberMap = lib_guild_data:get_guild_member_map(GuildId),
         AllMemberInfos =
             [begin
                  RId = GuildMember#guild_member.id,
                  #figure{
                      vip = Vip, name = RName, lv = Lv, exploit = Exploit
                  } = GuildMember#guild_member.figure,
                  CombatPower = GuildMember#guild_member.combat_power,
                  {RId, Vip, Lv, RName, Exploit, CombatPower}
              end||GuildMember <- maps:values(MemberMap)],
         mod_kf_seacraft:gm_flush_sync_members(config:get_server_id(), Camp, GuildId, GuildName,  AllMemberInfos)
     end||#guild{id = GuildId, name = GuildName, realm = Camp}<-GuildList, Camp =/= 0],
    {noreply, State};


handle_cast({'gm_set_chief', GuildId, RoleId}, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        #guild{chief_id = RoleId} ->
            {noreply, State};
        #guild{chief_id = ChiefId} = Guild ->
            GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
            OldChief = maps:get(ChiefId, GuildMemberMap, false),
            MemberInfo = maps:get(RoleId, GuildMemberMap, false),
            if
                OldChief == false orelse MemberInfo == false ->
                    {noreply, State};
                true ->
                    lib_guild_mod:bulk_appoint_position_to_chief_done(Guild, MemberInfo, OldChief, ?MANUAL_APPOINT),
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

%% 公会合并请求列表
handle_cast({send_guild_merge_requests, RoleId, GuildId}, State) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    ApplyGIds = [ ApplyGId || #guild_merge{apply_gid = ApplyGId, target_gid = TargetGId} <- GuildMergeL, TargetGId == GuildId ],
    ApplyGuilds = [ lib_guild_data:get_guild_by_id(GId) || GId <- ApplyGIds ],

    SendList = lib_guild_data:pack_guild_list(ApplyGuilds, RoleId),
    lib_server_send:send_to_uid(RoleId, pt_400, 40061, [SendList]),

    {noreply, State};

%% 公会合并申请
handle_cast({apply_guild_merge, RoleId, ApplyGId, TargetGId}, State) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),
    ApplyGuild = lib_guild_data:get_guild_by_id(ApplyGId),
    TargetGuild = lib_guild_data:get_guild_by_id(TargetGId),

    case lib_guild_mod:check_apply_guild_merge(RoleId, ApplyGuild, TargetGuild) of
        true ->
            % 构造合并请求
            MasterGuild = lib_guild_util:get_merge_master_guild(ApplyGuild, TargetGuild),
            GuildMerge = #guild_merge{
                key = {ApplyGId, TargetGId},
                apply_gid = ApplyGId,
                target_gid = TargetGId,
                master_gid = MasterGuild#guild.id,
                status = ?GUILD_MERGE_REQUEST,
                apply_time = utime:unixtime()
            },

            % 保存合并请求
            lib_guild_data:db_guild_merge_insert(GuildMerge),
            lib_guild_data:set_guild_merges([ GuildMerge | GuildMergeL ]),

            % 通知目标公会会长
            TargetChiefId = TargetGuild#guild.chief_id,
            mod_guild:send_guild_merge_requests(TargetChiefId, TargetGId),

            lib_server_send:send_to_uid(RoleId, pt_400, 40062, [?SUCCESS, TargetGId]);
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_400, 40062, [ErrCode, TargetGId])
    end,

    {noreply, State};

%% 响应公会合并申请
handle_cast({response_guild_merge, RoleId, OpType, ApplyGId, TargetGId}, State) ->
    ApplyGuild = lib_guild_data:get_guild_by_id(ApplyGId),
    TargetGuild = lib_guild_data:get_guild_by_id(TargetGId),

    case lib_guild_mod:check_response_guild_merge(RoleId, OpType, ApplyGuild, TargetGuild) of
        true ->
            % MergeReq = lib_guild_data:get_guild_merge_key({ApplyGId, TargetGId}),
            lib_guild_mod:response_guild_merge(RoleId, OpType, ApplyGuild, TargetGuild),
            lib_server_send:send_to_uid(RoleId, pt_400, 40063, [?SUCCESS, ApplyGId]);
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_400, 40063, [ErrCode, ApplyGId])
    end,

    {noreply, State};

%% 公会合并
handle_cast({'guild_merge'}, State) ->
    NowTime = utime:unixtime(),
    GuildMergeL = lib_guild_data:get_guild_merges(),

    F = fun(GuildMerge) ->
        case lib_guild_util:calc_guild_merge_time(GuildMerge) =< NowTime of
            true ->
                case catch lib_guild_mod:guild_merge(GuildMerge) of % 不能让部分有问题的请求影响其它正常合并
                    {'EXIT', Reason} -> ?ERR("guild merge error: ~p~n", [Reason]);
                    _ -> ok
                end;
            false ->
                lib_guild_mod:auto_agree_guild_merge(GuildMerge) % 对还在请求状态中申请时间超过配置时间的申请进行自动同意处理
        end
    end,
    lists:map(F, GuildMergeL),

    {noreply, State};

handle_cast({'gm_guild_merge'}, State) ->
    GuildMergeL = lib_guild_data:get_guild_merges(),

    F = fun(GuildMerge) ->
        case GuildMerge#guild_merge.status of
            ?GUILD_MERGE_AGREED ->
                lib_guild_mod:guild_merge(GuildMerge);
            _ ->
                skip
        end
    end,
    lists:map(F, GuildMergeL),

    {noreply, State};

%% 清理公会合并
handle_cast({'gm_clear_guild_merge'}, State) ->
    lib_guild_data:set_guild_merges([]),

    Sql = io_lib:format("truncate table guild_merge", []),
    db:execute(Sql),

    {noreply, State};

%% 清理公会合并(申请时间在Timestamp前)
handle_cast({'gm_clear_guild_merge', Timestamp}, State) ->
    ApplyL = lib_guild_data:get_guild_merges(),

    {RemoveL, ReserveL} = lists:partition(fun(#guild_merge{apply_time = T}) -> T =< Timestamp end, ApplyL),

    [lib_guild_data:db_guild_merge_delete(Apply) || Apply <- RemoveL],
    lib_guild_data:set_guild_merges(ReserveL),

    {noreply, State};

handle_cast({'get_guild_member_join_wedding', Args}, State) ->
    [PlayerId, GuildId, NoInviteList|_] = Args,
    GuildMemberList = lib_guild_data:search_guild_member(GuildId, PlayerId, 0, 0, 0, 0),
    Fun = fun(#guild_member{ id = TemPlayerId, figure = TemPlayerFigure, combat_power = TemCombatPower}, GuildMemberL) ->
        #figure{ name = TemPlayerName, lv = TemPlayerLv } = TemPlayerFigure,
        case lists:member(TemPlayerId, NoInviteList) orelse TemPlayerLv < 130 of
            true ->
                GuildMemberL;
            false ->
                [{TemPlayerId, TemPlayerName, TemCombatPower}|GuildMemberL]
        end
    end,
    FilterGuildMembers = lists:foldl(Fun, [], GuildMemberList),
    lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, lib_marriage, do_one_invite_role, [FilterGuildMembers]),
    {noreply, State};

%% 默认匹配
handle_cast(Event, State) ->
    catch ?ERR("mod_guild_cast:handle_cast not match: ~p", [Event]),
    {noreply, State}.
