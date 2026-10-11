%% ---------------------------------------------------------------------------
%% @doc pp_guild.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 公会协议处理
%% ---------------------------------------------------------------------------
-module(pp_guild).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("sql_guild.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("guild_dun.hrl").
-include("boss.hrl").

%% 公会列表界面
handle(40001, Player, [GuildName, PageSize, PageNo]) ->
    mod_guild:search_guild_list(Player#player_status.id, GuildName, PageSize, PageNo);

%% 申请加入公会
handle(40002, Player, [GuildId]) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, sid = Sid, guild = GuildStatus, scene = Scene} = Player,
    #status_guild{id = MyGuildId} = GuildStatus,
    NeedLv = data_guild_m:get_config(apply_join_guild_lv),
    IsSanctuary = lib_sanctuary:is_sanctuary_scene(Scene),
    if
        MyGuildId > 0 -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_on_guild_not_to_apply));
        Lv < NeedLv -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_not_enough_lv_to_apply_join_guild));
        IsSanctuary == true -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_can_not_join_in_sanctuary));
        true ->
            RoleInfoMap = lib_guild:make_role_map(Player),
            mod_guild:apply_join_guild(RoleId, RoleInfoMap, GuildId)
    end;

%% 批量申请
handle(40003, Player, _) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, sid = Sid, guild = GuildStatus, scene = Scene} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    NeedLv = data_guild_m:get_config(apply_join_guild_lv),
    IsSanctuary = lib_sanctuary:is_sanctuary_scene(Scene),
    if
        GuildId > 0 -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_on_guild_not_to_apply));
        Lv < NeedLv -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_not_enough_lv_to_apply_join_guild));
        IsSanctuary == true -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_can_not_join_in_sanctuary));
        true ->
            RoleInfoMap = lib_guild:make_role_map(Player),
            mod_guild:apply_join_guild_multi(RoleId, RoleInfoMap)
    end;

%% 创建公会
handle(40004, Player, [CfgId, GuildName]) ->
    lib_guild:create_guild(Player, CfgId, GuildName);

%% 获取公会信息界面-基础信息
handle(40005, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId, create_time = JoinTime}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_GUILD, 1),
            LimTimes = lib_daily:get_count_limit(?MOD_GUILD, 1),
            SalaryStatus = case ReceiveTimes >= LimTimes of %% 四点刷新
                true -> 1;
                false -> 0
            end,
            mod_guild:send_guild_info(RoleId, GuildId, SalaryStatus, JoinTime)
    end;

%% 获取公会信息界面-成员列表
handle(40006, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false -> mod_guild:send_guild_member_short_info(RoleId, GuildId, 0, 0, 0, 0)
    end;

%% 主动退出公会
handle(40007, #player_status{sid = Sid} = Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            case lib_mutex_check:check_quit_guild(Player) of
                {false, ErrorCode} -> lib_server_send:send_to_sid(Sid, pt_400, 40007, [ErrorCode]);
                true -> mod_guild:quit_guild(RoleId)
            end
    end;

%% 申请列表
handle(40008, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false -> mod_guild:send_guild_apply_list(RoleId, GuildId)
    end;

%% 审批加入公会的玩家
handle(40009, Player, [ApplyRoleId, Type]) ->
    #player_status{id = RoleId} = Player,
    case lib_role:get_role_show(ApplyRoleId) of
        [] -> skip;
        RoleShow ->
            ApplyRoleInfoMap = lib_guild:make_role_map(RoleShow),
            mod_guild:approve_guild_apply(RoleId, ApplyRoleId, ApplyRoleInfoMap, Type)
    end;

%% 审批设置界面
handle(40010, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false -> mod_guild:send_approve_setting_view(RoleId, GuildId)
    end;

%% 设置审批
handle(40011, Player, [ApproveType, AutoApproveLv, AutoApprovePower]) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    IsArrpoveTypeRight = lists:member(ApproveType, [?APPROVE_TYPE_AUTO, ?APPROVE_TYPE_MANUAL]),
    if
        IsArrpoveTypeRight == false -> ErrorCode = ?ERRCODE(err400_approve_type_error);
        GuildId =< 0 -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_approve);
        AutoApproveLv < 0 orelse AutoApproveLv > ?MAX_SMALLINT -> ErrorCode = ?ERRCODE(err400_auto_approve_lv_error);
        AutoApprovePower < 0 orelse AutoApprovePower > ?MAX_INT -> ErrorCode = ?ERRCODE(err400_auto_approve_power_error);
        true ->
            ErrorCode = nothing,
            mod_guild:setting_approve(RoleId, ApproveType, AutoApproveLv, AutoApprovePower)
    end,
    case ErrorCode == nothing of
        true -> skip;
        false ->
            {ok, BinData} = pt_400:write(40011, [ErrorCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

%% 编辑公告
handle(40012, Player, [SaveType, Announce]) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}, figure = #figure{lv = Lv}} = Player,
    Len = data_guild_m:get_config(announce_len),
    CheckLength = util:check_length_without_code(Announce, Len),
    %CheckKeyWord = lib_word:check_keyword_name(Announce),
    NewAnnounce = lib_word:filter_text(Announce, Lv),
    IsBanRename = lib_game:is_ban_rename(),
    if
        IsBanRename -> ErrorCode = ?ERRCODE(err400_update_announce_system);
        GuildId =< 0 -> ErrorCode = ?ERRCODE(err400_not_on_guild_to_modify_announce);
        CheckLength == false -> ErrorCode = ?ERRCODE(err400_announce_len);
        %CheckKeyWord -> ErrorCode = ?ERRCODE(err400_announce_sensitive);
        true ->
            ErrorCode = nothing,
            mod_guild:modify_announce(RoleId, SaveType, NewAnnounce)
    end,
    case ErrorCode == nothing of
        true -> skip;
        false ->
            {ok, BinData} = pt_400:write(40012, [ErrorCode]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

%% 任命职位
handle(40013, Player, [AppointeeId, Position]) ->
    #player_status{sid = Sid, id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            case lib_mutex_check:check_appoint_position(GuildId, Position) of
                {false, ErrorCode} -> lib_server_send:send_to_sid(Sid, pt_400, 40000, [ErrorCode]);
                true ->  mod_guild:appoint_position(RoleId, AppointeeId, Position)
            end
    end;

%% 踢出公会
handle(40014, #player_status{sid = Sid} = Player, [LeaveId]) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            case lib_mutex_check:check_kick_out_guild(Player, LeaveId) of
                {false, ErrorCode} -> lib_server_send:send_to_sid(Sid, pt_400, 40014, [ErrorCode, LeaveId]);
                true -> mod_guild:kick_out_guild(RoleId, LeaveId)
            end
    end;

%% 玩家的公会信息
handle(40015, Player, []) ->
    lib_guild:send_info(Player);

%% 全部同意/拒绝入会
handle(40016, Player, [Type]) when Type == 1 orelse Type == 2 ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            case Type == 1 of
                true ->
                    mod_guild:approve_all_guild_apply_on_this_guild(RoleId);
                false ->
                    mod_guild:clean_all_guild_apply_on_this_guild(RoleId)
            end;
        false -> skip
    end;

%% 解散公会
handle(40027, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}, scene = Scene} = Player,
    case GuildId =/= 0 of
        true ->
            IsSanctuary = lib_sanctuary:is_sanctuary_scene(Scene),
            if
                IsSanctuary == true ->
                    {ok, Bin} = pt_400:write(40027, [?ERRCODE(err400_cant_disband_guild_when_in_sanctuary)]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    skip;
                true ->
                    mod_guild:chief_disband_guild(RoleId)
            end;
        false -> skip
    end;

%% 调戏玩家
handle(40029, Player, [MemberId]) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = Figure} = Player,
    case GuildId =/= 0 of
        true when RoleId =/= MemberId ->
            case lib_role:get_role_figure(MemberId) of
                #figure{guild_id = GuildId, name = Name} ->
                    L = data_guild:get_welcome_ids(?GUILD_MEMBER_MSG_WELCOME),
                    case ulists:list_shuffle(L) of
                        [] -> skip;
                        [Id|_] ->
                            Content1 = data_guild:get_welcome_string(Id),
                            Content = uio:format(Content1, [Name]),
                            lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_GUILD, 12, [Content])
                    end;
                _R -> skip
            end;
        true ->
            {ok, Bin} = pt_400:write(40000, [?ERRCODE(err400_dont_kid_myself)]),
            lib_server_send:send_to_sid(Sid, Bin);
        false -> skip
    end;

%% 声望信息
handle(40030, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            mod_guild_prestige:send_role_prestige([RoleId, Sid]);
        false -> skip
    end;
%% 今日声望信息
handle(40031, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            mod_guild_prestige:send_today_prestige([RoleId, Sid]);
        false -> skip
    end;

%% 提升公会等级
handle(40018, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            mod_guild:upgrade_guild(RoleId);
        false -> skip
    end;

%% 公告编辑界面
handle(40019, Player, []) ->
    #player_status{sid = Sid, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            mod_guild:send_announce_view_info(Sid, GuildId);
        false -> skip
    end;

%% 领取工资
handle(40020, Player, []) ->
    #player_status{sid = Sid, id = RoleId, guild = GuildStatus, figure = Figure} = Player,
    #status_guild{id = GuildId} = GuildStatus,
    #figure{name = _RoleName} = Figure,
    case GuildId =/= 0 of
        true ->
            ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_GUILD, 1),
            LimTimes = lib_daily:get_count_limit(?MOD_GUILD, 1),
            case ReceiveTimes < LimTimes of
                true ->
                    case catch mod_guild_prestige:get_role_prestige(RoleId) of
                        {ok, AllPrestige} ->
                            PrestigeTitleId = lib_guild_data:get_prestige_title_id(AllPrestige),
                            Salary = data_guild:get_title_reward(PrestigeTitleId),
                            case lib_goods_api:can_give_goods(Player, Salary) of
                                true ->
                                    lib_log_api:log_guild_daily_gift(RoleId, Salary),
                                    ErrorCode = ?SUCCESS,
                                    mod_daily:increment(RoleId, ?MOD_GUILD, 1),
                                    NewPlayer = lib_goods_api:send_reward(Player, Salary, receive_guild_salary, 0),

                                    % 玩家角度发送传闻
                                    TvIdList = data_guild:get_welcome_ids(?GUILD_MEMBER_MSG_DAILY_TITLE_REWARD),
                                    TvId = urand:list_rand(TvIdList),
                                    Content = data_guild:get_welcome_string(TvId),
                                    Content1 = uio:format(Content, []),
                                    lib_chat:send_TV({guild, GuildId}, RoleId, Figure, ?MOD_GUILD, 15, [Content1]);
                                {false, ErrorCode} ->
                                    NewPlayer = Player
                            end;
                        _Err ->
                            ErrorCode = ?ERRCODE(system_busy),
                            NewPlayer = Player
                    end;
                false ->
                    ErrorCode = ?ERRCODE(err400_has_receive_salary),
                    NewPlayer = Player
            end;
        false ->
            ErrorCode = ?ERRCODE(err400_not_join_guild),
            NewPlayer = Player
    end,
    {ok, BinData} = pt_400:write(40020, [ErrorCode]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer};

%% 玩家拥有的权限列表
handle(40021, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false -> mod_guild:send_role_permission_list(RoleId)
    end;

%% 捐献界面
handle(40023, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId =/= 0 of
        true ->
            _DonateTypeList = data_guild:get_donate_type_list(),
            DonateTimes = mod_daily:get_count(RoleId, ?MOD_GUILD, 2),
            GiftIdList = data_guild:get_activity_gift_id_list(),
            SelfGiftStatusList = mod_daily:get_count(RoleId, ?MOD_GUILD, 2, GiftIdList),
            ?PRINT("40023 == ~p~n", [{DonateTimes, SelfGiftStatusList}]),
            mod_guild:apply_cast(lib_guild_mod, send_donate_info, [RoleId, SelfGiftStatusList, DonateTimes]);
        false ->
            ok
    end;

%% 公会捐献
% handle(40024, Player, [DonateType, Times]) ->
%     #player_status{id = RoleId, sid = Sid, figure = #figure{name = RoleName}, guild = #status_guild{id = GuildId}} = Player,
%     case GuildId =/= 0 of
%         true ->
%             case data_guild:get_donate_by_type(DonateType) of
%                 #base_guild_donate{donate_cost = DonateCost} = DonateCfg ->
%                     DonateTimesMax = data_guild_m:get_config(donate_total_times),
%                     DonateTimes = mod_daily:get_count(RoleId, ?MOD_GUILD, 2),
%                     ?PRINT("40024 == DonateTimes ~p~n", [DonateTimes]),
%                     case DonateTimes + Times > DonateTimesMax of
%                         false ->
%                             RealCost = [ {Type, Id, Num*Times} || {Type, Id, Num} <- DonateCost],
%                             case lib_goods_api:cost_object_list_with_check(Player, RealCost, role_donate, "") of
%                                 {true, Player1} ->
%                                     ErrorCode = none,
%                                     PlayerArgs = {RoleName},
%                                     mod_guild:apply_cast(lib_guild_mod, guild_donate, [RoleId, DonateCfg, DonateTimes, Times, PlayerArgs]),
%                                     mod_daily:set_count(RoleId, ?MOD_GUILD, 2, DonateTimes + Times),
%                                     %% 成就
%                                     lib_achievement_api:guild_donate_event(Player1, DonateTimes + Times),
%                                     NewPlayer = lib_activitycalen_api:role_success_end_activity(Player1, ?MOD_GUILD, 1, Times);
%                                 {false, Res, _} ->
%                                     ErrorCode = Res,
%                                     NewPlayer = Player
%                             end;
%                         _ ->
%                             ErrorCode = ?ERRCODE(err400_donate_max),
%                             NewPlayer = Player
%                     end;
%                 _ ->
%                     ErrorCode = ?ERRCODE(err400_not_config),
%                     NewPlayer = Player
%             end;
%         false ->
%             ErrorCode = ?ERRCODE(err400_not_join_guild),
%             NewPlayer = Player
%     end,
%     case ErrorCode =/= none of
%         true ->
%             {ok, BinData} = pt_400:write(40024, [ErrorCode, DonateType, 0, 0, 0, 0, 0]),
%             lib_server_send:send_to_sid(Sid, BinData),
%             {ok, NewPlayer};
%         _ ->
%             {ok, NewPlayer}
%     end;

%% 领取活跃度礼包
% handle(40025, Player, [Id]) ->
%     #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}} = Player,
%     case GuildId =/= 0 of
%         true ->
%             %DonateTypeList = data_guild:get_donate_type_list(),
%             GonateTimes = mod_daily:get_count(RoleId, ?MOD_GUILD, 2),
%             %GonateTimes = lists:sum([ Times || {_, Times} <- SelfDonateList]),
%             ActivityGift = data_guild:get_activity_gift(Id),
%             if
%                 GonateTimes == 0 -> ErrorCode = ?ERRCODE(err400_not_donate_today), NewPlayer = Player;
%                 is_record(ActivityGift, base_guild_activity_gift) == false -> ErrorCode = ?MISSING_CONFIG, NewPlayer = Player;
%                 true ->
%                     GiftIdList = data_guild:get_activity_gift_id_list(),
%                     SelfGiftStatusList = mod_daily:get_count(RoleId, ?MOD_GUILD, 2, GiftIdList),
%                     case lists:keyfind(Id, 1, SelfGiftStatusList) of
%                         false -> ErrorCode = ?MISSING_CONFIG, NewPlayer = Player;
%                         {Id, 1} -> ErrorCode = ?ERRCODE(err400_already_get_daily_gift), NewPlayer = Player;
%                         _ ->
%                             #base_guild_activity_gift{activity = ActivityNeed, reward = Reward} = ActivityGift,
%                             case catch mod_guild:apply_call(lib_guild_mod, get_guild_activity, [GuildId], 2000) of
%                                 {ok, GActivity} when GActivity>=ActivityNeed ->
%                                     lib_log_api:log_guild_donate_gift(RoleId, Id, Reward),
%                                     ?PRINT("40025 == GActivity ~p~n", [GActivity]),
%                                     ErrorCode = ?SUCCESS,
%                                     mod_daily:increment(RoleId, ?MOD_GUILD, 2, Id),
%                                     Produce = #produce{type = get_activity_gift, reward = Reward, show_tips = 3},
%                                     {_, NewPlayer} = lib_goods_api:send_reward_with_mail(Player, Produce);
%                                 {ok, _} ->
%                                     ErrorCode = ?ERRCODE(err400_activity_not_enough), NewPlayer = Player;
%                                 _Err ->
%                                     ?ERR("get activity gift err : ~p~n", [_Err]),
%                                     ErrorCode = ?FAIL, NewPlayer = Player
%                             end
%                     end
%             end;
%         false ->
%             ErrorCode = ?ERRCODE(err400_not_join_guild),
%             NewPlayer = Player
%     end,
%     ?PRINT("40025 == ErrorCode ~p~n", [ErrorCode]),
%     {ok, BinData} = pt_400:write(40025, [ErrorCode, Id]),
%     lib_server_send:send_to_sid(Sid, BinData),
%     {ok, NewPlayer};

%% 查看公会活跃度
handle(40028, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            mod_guild:apply_cast(lib_guild_mod, send_guild_activity, [RoleId, GuildId])
    end;

%% 公会技能列表
handle(40040, Player, [SkillType]) ->
    #player_status{
        id = RoleId, guild = #status_guild{id = GuildId}, figure = #figure{ lv = RoleLv },
        guild_skill = PlayerGSkill, original_attr = OriginalAttr
    } = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            #status_guild_skill{gskill_map = PlayerGSkillMap} = PlayerGSkill,
            mod_guild:send_guild_skill_list(RoleId, GuildId, PlayerGSkillMap, SkillType, OriginalAttr, RoleLv)
    end;

%% 研究公会技能
% handle(40041, Player, [SkillId]) ->
%     #player_status{sid = Sid, id = RoleId, guild = #status_guild{id = GuildId}} = Player,
%     case GuildId == 0 of
%         true -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_not_join_guild));
%         false -> mod_guild:research_skill(RoleId, SkillId)
%     end;

%% 学习公会技能
handle(40042, Player, [SkillId]) ->
    #player_status{
        sid = Sid, id = RoleId, figure = Figure,
        guild = #status_guild{id = GuildId}, guild_skill = PlayerGSkill
    } = Player,
    #figure{lv = RoleLv} = Figure,
    case GuildId == 0 of
        true -> lib_guild:send_error_code(Sid, ?ERRCODE(err400_not_join_guild));
        false ->
            #status_guild_skill{gskill_map = PlayerGSkillMap} = PlayerGSkill,
            Args = #{role_lv => RoleLv, player_gskill_map => PlayerGSkillMap},
            case catch mod_guild:learn_skill(RoleId, SkillId, Args) of
                {ok, LearnCost, RemainDonate} ->
                    lib_guild_skill:learn_skill(Player, SkillId, LearnCost, RemainDonate);
                {false, ErrorCode} ->
                    lib_guild:send_error_code(Sid, ErrorCode);
                _ ->
                    lib_guild:send_error_code(Sid, ?ERRCODE(system_busy))
            end
    end;

%% 公会改名
handle(40043, Player, [Name]) when is_list(Name) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            mod_guild:check_rename_guild(GuildId, RoleId, [Name])
    end;

%% 公会是否可免费改名
handle(40044, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId == 0 of
        true -> skip;
        false ->
            mod_guild:check_rename_guild_free(GuildId, RoleId)
    end;

%% 公会探索界面信息
handle(40050, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = #figure{name = RoleName}} = Player,
    case lib_guild:check_guild_dun_open(Player) of
        {false, Res} -> _Errcode = Res;
        true ->
            _Errcode = none,
            GiftIdList = data_guild_dun:get_score_gift_id_list(),
            GiftStatusList = mod_daily:get_count(RoleId, ?MOD_GUILD, 3, GiftIdList),
            mod_guild_dun_mgr:apply_cast({mod, get_role_challenge_info, [RoleId, Sid, GuildId, RoleName, GiftStatusList]})
    end,
    ok;

%% 领取积分礼包
handle(40051, Player, [Id]) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = #figure{name = RoleName}} = Player,
    case GuildId =/= 0 of
        true ->
            ScoreGift = data_guild_dun:get_dun_score_gift(Id),
            if
                is_record(ScoreGift, base_guild_dun_score_reward) == false -> ErrorCode = ?MISSING_CONFIG, NewPlayer = Player;
                true ->
                    GiftIdList = data_guild_dun:get_score_gift_id_list(),
                    SelfGiftStatusList = mod_daily:get_count(RoleId, ?MOD_GUILD, 3, GiftIdList),
                    case lists:keyfind(Id, 1, SelfGiftStatusList) of
                        false -> ErrorCode = ?MISSING_CONFIG, NewPlayer = Player;
                        {Id, 1} -> ErrorCode = ?ERRCODE(err400_already_get_score_gift), NewPlayer = Player;
                        _ ->
                            #base_guild_dun_score_reward{score = ScoreNeed, reward = Reward} = ScoreGift,
                            RoleScoreLimit = data_guild_m:get_config(dun_score_reward_need),
                            case catch mod_guild_dun_mgr:apply_call({mod, get_guild_and_role_score, [RoleId, GuildId, RoleName]}, 2000) of
                                {ok, DunScore, RoleScore} when DunScore>=ScoreNeed, RoleScore>=RoleScoreLimit ->
                                    ?PRINT("40051 == DunScore ~p~n", [DunScore]),
                                    ErrorCode = ?SUCCESS,
                                    mod_daily:increment(RoleId, ?MOD_GUILD, 3, Id),
                                    Produce = #produce{type = guild_score_gift, reward = Reward, show_tips = 3},
                                    {_, NewPlayer} = lib_goods_api:send_reward_with_mail(Player, Produce);
                                {ok, DunScore, _} ->
                                    ErrorCode = ?IF(DunScore >= ScoreNeed, ?ERRCODE(err400_dun_role_score_not_enough), ?ERRCODE(err400_dun_score_not_enough)),
                                    NewPlayer = Player;
                                _Err ->
                                    ?ERR("get activity gift err : ~p~n", [_Err]),
                                    ErrorCode = ?FAIL, NewPlayer = Player
                            end
                    end
            end;
        false ->
            ErrorCode = ?ERRCODE(err400_not_join_guild),
            NewPlayer = Player
    end,
    ?PRINT("40051 == ErrorCode ~p~n", [ErrorCode]),
    {ok, BinData} = pt_400:write(40051, [ErrorCode, Id]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer};

handle(40052, Player, []) ->
    lib_guild_dun:send_guild_dun_endtime(Player);

handle(40053, Player, [Door]) ->
    #player_status{id = _RoleId, sid = Sid} = Player,
    case lib_guild:check_guild_dun_open(Player) of
        {false, Res} -> Errcode = Res;
        true ->
            Errcode = lib_guild_dun:enter_challenge(Player, Door)
    end,
    case Errcode /= none of
        true ->
            {ok, Bin} = pt_400:write(40053, [Errcode, Door]),
            lib_server_send:send_to_sid(Sid, Bin);
        _ ->
            ok
    end;

handle(40054, Player, []) ->
    lib_guild_dun:leave_challenge(Player);

handle(40056, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = #figure{name = RoleName}} = Player,
    case lib_guild:check_guild_dun_open(Player) of
        {false, _Res} -> ok;
        true ->
            mod_guild_dun_mgr:apply_cast({mod, send_member_challenge_list, [RoleId, Sid, GuildId, RoleName]})
    end;

handle(40057, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = Figure} = Player,
    case lib_guild:check_guild_dun_open(Player) of
        {false, _Res} -> ok;
        true ->
            mod_guild_dun_mgr:apply_cast({mod, notify_guild_member, [RoleId, Sid, GuildId, Figure]})
    end;

handle(40058, Player, []) ->
    #player_status{id = RoleId, sid = Sid, guild = #status_guild{id = GuildId}, figure = #figure{name = RoleName}} = Player,
    case lib_guild:check_guild_dun_open(Player) of
        {false, _Res} -> ok;
        true ->
            mod_guild_dun_mgr:apply_cast({mod, get_notify_record_list, [RoleId, Sid, GuildId, RoleName]})
    end;

handle(40060, Player, []) ->
    #player_status{id = RoleId, scene = SceneId, x = X, y = Y, guild = #status_guild{id = GuildId}, figure = Figure} = Player,
    case GuildId > 0 of
        false -> ok;
        true ->
            #figure{name = RoleName, lv = RoleLv, career = RoleCareer, sex = RoleSex, picture = RolePic, picture_ver = RolePicVer} = Figure,
            case data_scene:get(SceneId) of
                #ets_scene{type = ?SCENE_TYPE_NEW_OUTSIDE_BOSS} -> %% 世界boss
                    BossType = ?BOSS_TYPE_NEW_OUTSIDE,
                    [{BossId, Layer}|_] = data_boss:get_boss_by_scene(BossType, SceneId),
                    Find = ok;
                #ets_scene{type = ?SCENE_TYPE_ABYSS_BOSS} -> %% boss之家
                    BossType = ?BOSS_TYPE_ABYSS,
                    [{BossId, Layer}|_] = data_boss:get_boss_by_scene(BossType, SceneId),
                    Find = ok;
                #ets_scene{type = ?SCENE_TYPE_SANCTUARY} -> %% 圣域boss
                    BossType = ?BOSS_TYPE_SANCTUARY,
                    SanctuaryId = lib_sanctuary_mod:get_sanctuary_id_by_scene_id(SceneId),
                    BossId = SanctuaryId,
                    Layer = 0,
                    Find = ok;
                #ets_scene{type = ?SCENE_TYPE_EUDEMONS_BOSS} -> %% 圣兽领
                    BossType = ?BOSS_TYPE_PHANTOM,
                    {BossId, Layer} = lib_eudemons_land:get_one_bossid_and_layer(SceneId),
                    Find = ok;
                _ ->
                    Find = false, BossId = 0, Layer = 0, BossType = 0
            end,
            case Find of
                ok ->
                    BossTypeName = data_boss:get_boss_type_name(BossType),
                    {ok, Bin} = pt_400:write(40060, [RoleId, RoleName, RoleLv, RoleCareer, RoleSex, RolePic, RolePicVer, BossType, BossTypeName, BossId, Layer, SceneId, X, Y]),
                    lib_server_send:send_to_guild(GuildId, Bin);
                _ ->
                    ok
            end
    end;

handle(40061, Player, []) ->
    #player_status{id = RoleId, guild = #status_guild{id = GuildId}} = Player,
    case GuildId of
        0 -> skip;
        _ ->
            mod_guild:send_guild_merge_requests(RoleId, GuildId)
    end;

handle(40062, Player, [TargetGId]) ->
    #player_status{id = RoleId, guild = #status_guild{id = ApplyGId}} = Player,
    case ApplyGId of
        0 -> skip;
        _ ->
            mod_guild:apply_guild_merge(RoleId, ApplyGId, TargetGId)
    end;

handle(40063, Player, [OpType, ApplyGId]) ->
    #player_status{id = RoleId, guild = #status_guild{id = TargetGId}} = Player,
    case TargetGId of
        0 -> skip;
        _ ->
            mod_guild:response_guild_merge(RoleId, OpType, ApplyGId, TargetGId)
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
