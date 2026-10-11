%% ---------------------------------------------------------------------------
%% @doc mod_guild.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 帮派进程
%% ---------------------------------------------------------------------------
-module(mod_guild_call).
-export([handle_call/3]).

-include("guild.hrl").
-include("sql_guild.hrl").
-include("common.hrl").
-include("def_id_create.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").

handle_call({'apply_call', Moudle, Method, Args}, _From, State) ->
    Reply = apply(Moudle, Method, Args),
    {reply, Reply, State};

%% 创建公会
handle_call({'create_guild', Guild, GuildMember}, _From, State) ->
    Reply = case lib_guild_data:match_guild({name_upper, Guild#guild.name_upper}) of
        #{} ->
            #guild_member{id = RoleId, figure = Figure} = GuildMember,
            F = fun() ->
                GuildId = mod_id_create:get_new_id(?GUILD_ID_CREATE),
                NewGuild = Guild#guild{id = GuildId},
                lib_guild_data:db_guild_insert(NewGuild),
                % 清理请求
                lib_guild_data:db_guild_apply_delete_by_role_id(RoleId),
                % 公会成员加入
                NewGuildMember = GuildMember#guild_member{guild_id = GuildId, figure = Figure#figure{position = ?POS_CHIEF, guild_id = GuildId, guild_name = Guild#guild.name}},
                lib_guild_data:db_guild_member_replace(NewGuildMember),
                {ok, NewGuild, NewGuildMember}
            end,
            case catch db:transaction(F) of
                {ok, #guild{id = GuildId} = NewGuild, NewGuildMember} ->
                    lib_guild_data:update_guild(NewGuild),
                    lib_guild_data:add_guild_member(NewGuildMember),
                    lib_guild_data:delete_guild_apply_by_role_id(RoleId),
                    %lib_guild_data:sort_guild_by_level(),
                    lib_guild_api:create_guild(NewGuild, NewGuildMember),
                    NewGuild2 = lib_guild_data:get_guild_by_id(GuildId),
                    lib_guild_create_act:update_act_reward_status(NewGuild),
                    %% 日志
                    lib_log_api:log_guild(GuildId, Guild#guild.name, ?CREATE_GUILD, io_lib:format("role_id:~p", [RoleId])),
                    lib_guild_api:join_guild(?GEVENT_CREATE_GUILD, NewGuild2, NewGuildMember),
                    ?PRINT("create_guild ========= ~p~n", [succ]),
                    {ok, NewGuild2};
                Error ->
                    ?ERR("M:~p L:~p Error:~p", [?MODULE, ?LINE, Error]),
                    {false, ?FAIL}
            end;
        _ ->
            {false, ?ERRCODE(err400_guild_name_same_not_to_create)}
    end,
    {reply, Reply, State};

handle_call({'is_have_permission', RoleId, PermissionType}, _From, State) ->
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
    Reply = lists:member(PermissionType, PermissionList),
    {reply, Reply, State};

handle_call({'check_move_to_depot', RoleId, DonateList}, _From, State) ->
    GuildMember = lib_guild_data:get_guild_member_by_role_id(RoleId),
    ErrorCode = if
        is_record(GuildMember, guild_member) == false -> ?ERRCODE(err400_not_join_guild);
        true ->
            #guild_member{guild_id = GuildId} = GuildMember,
            GuildDepotMap = lib_guild_depot_data:get_depot_map(),
            GuildDepot = maps:get(GuildId, GuildDepotMap, #guild_depot{}),
            #guild_depot{depot_goods = DepotGoodsList} = GuildDepot,
            DepotGoodsDefMaxCell = data_guild_m:get_config(default_depot_cell),
            AddLen = lists:sum([Num || {_, Num} <- DonateList]),
            case length(DepotGoodsList) + AddLen =< DepotGoodsDefMaxCell of
                true -> ?SUCCESS;
                false -> ?ERRCODE(err401_not_in_depot)
            end
    end,
    {reply, ErrorCode, State};

handle_call({'get_guild_member_max_lv', RoleId}, _From, State) ->
    Guild = lib_guild_data:get_guild_by_role_id(RoleId),
    if
        is_record(Guild, guild) == false -> MaxLv = 0;
        true ->
            #guild{id = GuildId} = Guild,
            GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
            F = fun(_K, #guild_member{figure = #figure{lv = Lv} }, List) -> [Lv|List] end,
            LvList = maps:fold(F, [], GuildMemberMap),
            MaxLv = lists:max(LvList)
    end,
    {reply, MaxLv, State};

handle_call({'cost_gfunds', RoleId, CostGfunds}, _From, State) ->
     case lib_guild_data:get_guild_by_role_id(RoleId) of
        [] -> Reply = false;
        #guild{id = GuildId, gfunds = Gfunds} = Guild ->
            case Gfunds >= CostGfunds of
                true ->
                    NewGfunds = Gfunds - CostGfunds,
                    lib_guild_data:db_guild_update_gfunds(GuildId, NewGfunds),
                    NewGuild = Guild#guild{gfunds = NewGfunds},
                    lib_guild_data:update_guild(NewGuild),
                    Reply = true;
                false ->
                    Reply = false
            end
    end,
    {reply, Reply, State};

%% 学习公会技能
handle_call({'learn_skill', RoleId, SkillId, ExtraData}, _From, State) ->
    Reply = lib_guild_mod:learn_skill(RoleId, SkillId, ExtraData),
    {reply, Reply, State};

handle_call({'get_all_guild'}, _From, State) ->
    {reply, lib_guild_data:get_guild_map(), State};

handle_call({'get_top_guild', GuildNum}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildIdSort = lib_guild_data:get_sort_guild_id_list(),
    F = fun(GuildId, List) ->
        case maps:get(GuildId, GuildMap, 0) of
            #guild{} = Guild -> [Guild|List]; _ -> List
        end
    end,
    GuildListSort = lists:reverse(lists:foldl(F, [], GuildIdSort)),
    case length(GuildListSort) > GuildNum of
        true -> {Reply, _} = lists:split(GuildNum, GuildListSort);
        _ -> Reply = GuildListSort
    end,
    {reply, Reply, State};

handle_call({'get_guild_by_id', GuildIdList}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    F = fun(GuildId, List) ->
        case maps:get(GuildId, GuildMap, 0) of
            #guild{} = Guild -> [Guild|List]; _ -> List
        end
    end,
    GuildList = lists:foldl(F, [], GuildIdList),
    {reply, GuildList, State};

%% 获取公会人数
handle_call({'get_guild_member_num', GuildId}, _From, State) ->
     case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = 0;
        #guild{id = GuildId, member_num = MemberNum} -> Reply = MemberNum
    end,
    {reply, Reply, State};

%% 获取公会人数列表[{guild_id,member_num}]
handle_call({'get_guild_member_num_list'}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    List = maps:fold(fun(Guild, ListTmp) -> [{Guild#guild.id, Guild#guild.member_num}|ListTmp] end, [], GuildMap),
    {reply, List, State};

%% 获取指定排名的公会信息
handle_call({'get_specify_ranking_guild', Ranking}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    case GuildList =/= [] of
        true ->
            SortList = lib_guild_mod:sort(GuildList, #guild.combat_power, Ranking),
            GuildInfo = hd(lists:reverse(SortList));
        _ ->
            GuildInfo = no_guild
    end,
    {reply, GuildInfo, State};

%% 获取前几名的公会信息
handle_call({'get_some_top_ranking_guild', MinRanking}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    GuildList = maps:values(GuildMap),
    case GuildList =/= [] of
        true ->
            SortList = lib_guild_mod:sort(GuildList, #guild.combat_power, MinRanking);
        _ ->
            SortList = []
    end,
    {reply, SortList, State};

%% 获取公会资金
handle_call({'get_gfunds', GuildId}, _From, State) ->
     case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = 0;
        #guild{gfunds = Gfunds} -> Reply = Gfunds
    end,
    {reply, Reply, State};

handle_call({'get_guild_name', GuildId}, _From, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = "???";
        #guild{name = GuildName} -> Reply = GuildName
    end,
    {reply, Reply, State};

handle_call({'get_guild_chief', GuildId}, _From, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = 0;
        #guild{chief_id = ChiefId} -> Reply = ChiefId
    end,
    {reply, Reply, State};

%% 获取公会成员id列表
handle_call({'get_guild_member_id_list', GuildId}, _From, State) ->
     case lib_guild_data:get_all_role_in_guild(GuildId) of
        [] -> Reply = [];
        List -> Reply = List
    end,
    {reply, Reply, State};

handle_call({'get_guild_member_capacity', GuildId}, _From, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = 99;
        Guild ->
           #guild{lv = GuildLv} = Guild,
            MemberCapacity = data_guild_m:get_guild_member_capacity(GuildLv),
            % 圣域前三公会
            SanctuaryGuildList = lib_guild_data:get_sanctuary_top3_guild_list(),
            AddSanctuaryLimit = data_sanctuary:get_kv(add_guild_member_limit),
            case lists:member(GuildId, SanctuaryGuildList) of
                true -> NewMemberCapacity = MemberCapacity + AddSanctuaryLimit;
                _ -> NewMemberCapacity = MemberCapacity
            end,
            Reply = NewMemberCapacity
    end,
    {reply, Reply, State};

%% 获取平均等级
handle_call({'get_guild_average_lv', GuildId, Num}, _From, State) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        [] -> Reply = 500;
        _Guild ->
           GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
            F = fun(_K, #guild_member{figure = #figure{lv = Lv} }, List) -> [Lv|List] end,
            LvList = maps:fold(F, [], GuildMemberMap),
            NewLvList = lists:reverse(lists:sort(LvList)),
            case length(NewLvList) >= Num of
                true ->
                    {Pre, _Post} = lists:split(Num, NewLvList),
                    Reply = lists:sum(Pre) div Num;
                _ ->
                    Reply = lists:sum(NewLvList) div Num
            end
    end,
    {reply, Reply, State};

%% 获取平均等级
handle_call({'get_all_guild_average_lv', Num}, _From, State) ->
    GuildMap = lib_guild_data:get_guild_map(),
    F = fun(GuildId, _, List) ->
        GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
        F2 = fun(_K, #guild_member{figure = #figure{lv = Lv} }, List1) -> [Lv|List1] end,
        LvList = maps:fold(F2, [], GuildMemberMap),
        NewLvList = lists:reverse(lists:sort(LvList)),
        case length(NewLvList) >= Num of
            true ->
                {Pre, _Post} = lists:split(Num, NewLvList),
                AverageLv = lists:sum(Pre) div Num;
            _ ->
                AverageLv = lists:sum(NewLvList) div Num
        end,
        [{GuildId, AverageLv}|List]
    end,
    Reply = maps:fold(F, [], GuildMap),
    {reply, Reply, State};

%% ==================== 秘籍相关 ==================

%% GM修改公会公告
handle_call({'modify_announce_by_gm', GuildId, Announce}, _From, State) ->
    Len = data_guild_m:get_config(announce_len),
    CheckLength = util:check_length(Announce, Len),
    CheckKeyWord = lib_word:check_keyword_name(Announce),
    Reply = if
        GuildId =< 0 -> guild_not_exist;
        CheckLength == false -> announce_len_err;
        CheckKeyWord -> announce_key_word_err;
        true ->
            Guild = lib_guild_data:get_guild_by_id(GuildId),
            if
                is_record(Guild, guild) == false -> guild_not_exist;
                true ->
                    #guild{modify_times = ModifyTimes, chief_id = ChiefId} = Guild,
                    AnnounceBin = util:make_sure_binary(Announce),
                    Sql = io_lib:format(?sql_guild_update_announce_and_modify_times, [util:fix_sql_str(AnnounceBin), ModifyTimes, GuildId]),
                    db:execute(Sql),
                    NewGuild = Guild#guild{announce = AnnounceBin},
                    lib_guild_data:update_guild(NewGuild),
                    lib_mail:send_guild_mail([ChiefId], utext:get(4000020), utext:get(4000021), []),
                    ok
            end
    end,
    {reply, {ok, Reply}, State};

%% GM修改公会名字
handle_call({'modify_name_by_gm', GuildId, GuildName}, _From, State) ->
    Reply = if
        GuildId =< 0 -> guild_not_exist;
        true ->
            Guild = lib_guild_data:get_guild_by_id(GuildId),
            if
                is_record(Guild, guild) == false -> guild_not_exist;
                true ->
                    GuildNameBin = util:make_sure_binary(GuildName),
                    GuildNameBin0 = util:make_sure_binary(Guild#guild.name),
                    CheckList = [
                        % 校验字符串
                        {fun() -> GuildName =/= "" end, ?ERRCODE(err400_guild_name_null)},
                        {fun() -> GuildNameBin0 =/= GuildNameBin end, ?ERRCODE(err400_guild_name_same)},
                        {fun() -> util:check_length_without_code(GuildName, data_guild_m:get_config(guild_name_len)) == true end, ?ERRCODE(err400_guild_name_len)},
                        {fun() -> lib_word:check_keyword_name(GuildName) == false end, ?ERRCODE(err400_guild_name_sensitive)},
                        {fun() ->
                            NewGuildName = string:to_upper(util:make_sure_list(GuildName)),
                            GuildUpperMap = lib_guild_data:match_guild({name_upper, NewGuildName}),
                            is_map(GuildUpperMap) andalso GuildUpperMap == #{}
                        end, ?ERRCODE(err400_guild_name_repeat)}
                    ],
                    Res = util:check_list(CheckList),
                    if
                        Res =/= true -> Res;
                        true ->
                            F = fun() ->
                                SQL1 = io_lib:format("UPDATE `guild` SET `name` = '~s' WHERE `id` = ~p", [GuildName, GuildId]),
                                db:execute(SQL1),
                                SQL2 = io_lib:format("UPDATE `guild_member` SET `guild_name` = '~s' WHERE `guild_id` = ~p", [GuildName, GuildId]),
                                db:execute(SQL2),
                                ok
                            end,
                            case catch db:transaction(F) of
                                ok ->
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
                                    NewGuild = Guild#guild{name = GuildNameBin, name_upper = NameUpper},
                                    lib_guild_data:update_guild(NewGuild),
                                    lib_guild_data:set_guild_member_map(GuildId, NewGuildMemberMap),

                                    lib_log_api:log_rename_guild(GuildId, 0, Guild#guild.name, GuildNameBin, Guild#guild.c_rename),

                                    %% 只发给会长
                                    lib_mail:send_guild_mail(Guild#guild.chief_id, utext:get(4000018), utext:get(4000027), []),
                                    ok;
                                _Error -> fail
                            end
                    end
            end
    end,
    {reply, {ok, Reply}, State};

%% GM解散公会
handle_call({'disband_guild', DisbandType, GuildId}, _From, State) ->
    Reply = lib_guild_mod:disband_guild(DisbandType, GuildId),
    {reply, {ok, Reply}, State};

%% 默认匹配
handle_call(Event, _From, State) ->
    catch ?ERR("mod_guild_call:handle_call not match: ~p", [Event]),
    {reply, ok, State}.