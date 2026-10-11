%%%-----------------------------------
%%% @Module      : lib_sanctuary
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 08. 三月 2019 9:38
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_sanctuary).
-author("chenyiming").

-include("predefine.hrl").
-include("guild.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("sanctuary.hrl").
-include("battle.hrl").
-include("rec_event.hrl").
-include("designation.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("common_rank.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("attr.hrl").
-include("boss.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("figure.hrl").

%% API
-compile(export_all).


re_login(PS, _LoginType) ->
    #player_status{scene = SceneId, status_boss = #status_boss{boss_map = BossMap}, id = RoleId,
        sanctuary_role_in_ps = _RoleSanctuary} = PS,
    IsSanctuaryScene = is_sanctuary_scene(SceneId),
    RoleSanctuary = ?IF(_RoleSanctuary == undefined, #sanctuary_role_in_ps{}, _RoleSanctuary),
    if
        IsSanctuaryScene == true ->
            case maps:get(?BOSS_TYPE_SANCTUARY, BossMap, []) of
                TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
                    #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
                _ ->
                    DieTime = 0, DieTimes = 0
            end,
            NowTime = utime:unixtime(),
            {RebornTime, MinTimes} = count_die_wait_time(DieTimes, DieTime),
%%			?MYLOG("cym", "RebornTime ~p  MinTimes ~p  NowTime ~p ~n", [RebornTime, MinTimes, NowTime]),
            #player_status{battle_attr = BA} = PS,
            #battle_attr{hp = Hp} = BA,
%%			?MYLOG("cym", "Hp ~p~n", [Hp]),
%%			#ets_scene{x = X, y = Y} = data_scene:get(SceneId),
            FatigueBuffTime = lib_sanctuary_mod:get_fatigue_buff_time(),
            ReviveGhostTime = lib_sanctuary_mod:get_revive_ghost_time(),
            %% 取消复活定时器
            #sanctuary_role_in_ps{reborn_ref = OldRef} = RoleSanctuary,
            util:cancel_timer(OldRef),
            %%通知客户端复活信息
            if
                Hp =< 0 ->
                    NewPlayer = lib_scene:change_relogin_scene(PS, []),
                    {Sign, KillerName} = get_last_kill_msg(PS),
                    ?MYLOG("cym", "Sign, KillerName ~p~n", [{Sign, KillerName}]),
                    {ok, Bin0} = pt_200:write(20013, [Sign, KillerName, 0, 0, 0, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin0),
                    if
                        DieTimes > MinTimes ->
                            ?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, DieTime + FatigueBuffTime, DieTime + ReviveGhostTime}]),
                            lib_server_send:send_to_uid(RoleId, pt_283, 28308, [DieTimes, RebornTime, DieTime + FatigueBuffTime, DieTime + ReviveGhostTime]);
                        true ->
                            ?MYLOG("cym", "die msg ~p~n", [{DieTimes, RebornTime, NowTime + FatigueBuffTime, 0}]),
                            lib_server_send:send_to_uid(RoleId, pt_283, 28308, [DieTimes, RebornTime, DieTime + FatigueBuffTime, 0])
                    end,
                    {ok, NewPlayer};
                true ->
                    NewPlayer = lib_scene:change_relogin_scene(PS, [{change_scene_hp_lim, 100}, {ghost, 0}]),
                    {ok, NewPlayer}
%%				true ->
%%					mod_sanctuary:quit(PS#player_status.id),
%%					NewPlayer = lib_scene:change_default_scene(PS, [{change_scene_hp_lim, 100}, {ghost, 0}, {pk, {?PK_PEACE, true}}]),
%%					{ok, NewPlayer}
            end;
        true ->
            {next, PS}
    end.

login(PS) ->
    Sql = io_lib:format(?sql_select_sanctuary_role_msg, [PS#player_status.id]),
    Res = db:get_row(Sql),
%%	?MYLOG("cym", "get_row Id ~p,  Res ~p~n", [PS#player_status.id, Res]),
    case Res of
        [GuildRank, PersonRank] ->
            SanctuaryRoleMsg = #sanctuary_role_in_ps{guild_rank = GuildRank, person_rank = PersonRank},
            PS#player_status{sanctuary_role_in_ps = SanctuaryRoleMsg};
        _ ->
            PS
    end.


%%转换圣域pk模式， 通过动态换组来实现
change_pk_mod(_RoleId, ?PK_FORCE, _Guild, SceneId) ->
    OnSanctuary = is_sanctuary_scene(SceneId),
    if
        OnSanctuary == true ->
            put(?sanctuary_pk, ?PK_FORCE);
%%			case Guild of 不用分组
%%				#guild{id = GuildId} ->
%%					mod_server_cast:set_data([{group, GuildId}], RoleId);
%%				_ ->
%%					ok
%%			end;
        true ->
            ok
    end;
change_pk_mod(_RoleId, ?PK_ALL, _Guild, SceneId) ->
    OnSanctuary = is_sanctuary_scene(SceneId),
    if
        OnSanctuary == true ->
            put(?sanctuary_pk, ?PK_ALL);
%%			mod_server_cast:set_data([{group, 0}], RoleId);
        true ->
            ok
    end;
change_pk_mod(_RoleId, ?PK_PEACE, _Guild, SceneId) ->
    OnSanctuary = is_sanctuary_scene(SceneId),
    if
        OnSanctuary == true ->
            put(?sanctuary_pk, ?PK_PEACE);
        true ->
            ok
    end;
change_pk_mod(_RoleId, ?PK_GUILD, _Guild, SceneId) ->
    OnSanctuary = is_sanctuary_scene(SceneId),
    if
        OnSanctuary == true ->
            put(?sanctuary_pk, ?PK_GUILD);
        true ->
            ok
    end;
change_pk_mod(_RoleId, _, _Guild, _SceneId) ->
    ok.


is_sanctuary_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} ->
            Type == ?SCENE_TYPE_SANCTUARY;
        _ ->
            false
    end.

boss_be_kill(MonInfo, SceneId, RoleId, KillList, GuildId, RoleName, X, Y, ScenePoolId) ->
    IsSanctuaryScene = is_sanctuary_scene(SceneId),
    if
        IsSanctuaryScene == false ->
            skip;
        true ->
            %%处理归属奖和参与奖
            hand_reward(RoleId, KillList),
            case data_sanctuary:get_sanctuary_id_by_scene(SceneId) of
                [] ->
                    skip;
                SanctuaryId ->
                    #scene_mon{mid = MonCfgId} = MonInfo,
                    case data_boss:get_boss_cfg(MonCfgId) of
                        #boss_cfg{sign = 1} ->  %%和平怪才增加怒气
                            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_sanctuary, boss_be_kill_in_scene, [X, Y, MonCfgId, KillList]);
%%							[lib_player:apply_cast(RoleId1, ?APPLY_CAST_SAVE, lib_sanctuary, add_sanctuary_boss_tired, [])
%%								|| #mon_atter{id = RoleId1} <- KillList];
                        _ ->
                            skip
                    end,
                    mod_sanctuary:boss_be_kill(SanctuaryId, RoleId, MonInfo, KillList, GuildId, RoleName)
            end
    end.

boss_be_kill_in_scene(MonX, MonY, MonCfgId, KillList) ->
    case data_mon:get(MonCfgId) of
        #mon{warning_range = Range} ->
            [   begin
                    case lib_scene_agent:get_user(RoleId) of
                        #ets_scene_user{x = X, y = Y} ->
                            Length2 = (MonX - X) * (MonX - X) + (MonY - Y) * (MonY - Y),
                            if
                                Length2 =< Range * Range ->%% 在警戒范围内
                                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, add_sanctuary_boss_tired, []);
                                true ->
                                    ok
                            end;
                        _ ->
                            ok
                    end
                end
                || #mon_atter{id = RoleId} <- KillList];
        _ ->
            ok
    end.

%% 发送固定奖励
send_kill_reward(MonInfo, KillList, SanctuaryId) when is_record(MonInfo, scene_mon) ->
    %%  要判断范围
    #scene_mon{mid = MonId} = MonInfo,
    Reward = get_boss_kill_sanctuary_medal_reward(SanctuaryId, MonId),
%%	?MYLOG("cym", "Reward ~p KillList ~p ~n", [Reward, KillList]),
    Produce = #produce{type = sanctuary_kill_reward, reward = Reward, show_tips = ?SHOW_TIPS_3},
    [begin
         lib_log_api:log_sanctuary_kill(RoleId, MonId, 0, Reward),
         lib_achievement_api:async_event(RoleId, lib_achievement_api, sanctuary_boss_event, []),
         lib_temple_awaken_api:trigger_sanctuary_boss(RoleId),
         lib_goods_api:send_reward_with_mail(RoleId, Produce)
     end || #mon_atter{id = RoleId} <- KillList].



handle_event(Player, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = Data}) when is_record(Player, player_status) ->
    #player_status{id = DieId, scene = SceneId, guild = Guild, figure = #figure{name = DieName}, x = X, y = Y} = Player,
    #status_guild{id = DieGuildId} = Guild,
    #{attersign := AtterSign, atter := Atter, hit := HitList} = Data,
    #battle_return_atter{real_id = AtterId, real_name = AtterName, guild_id = AtterGuildId} = Atter,
    HitRoleList = [HitId || #hit{id = HitId} <- HitList],%{[HitId, _HitPlatform, _HitServerNum], _} <- HitList],
    case is_sanctuary_scene(SceneId) of
        true ->
            case AtterSign of
                ?BATTLE_SIGN_PLAYER ->
                    mod_sanctuary:player_be_kill(DieId, DieName, DieGuildId, AtterId, AtterName, AtterGuildId, SceneId, X, Y, HitRoleList);
                ?BATTLE_SIGN_MON ->
                    mod_sanctuary:player_be_kill(DieId, DieName, DieGuildId, 0, "", 0, SceneId, X, Y, HitRoleList);
                false ->
                    skip
            end,
            {ok, Player};
        false ->
            {ok, Player}
    end;


handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = F, id = RoleId} = Player,
    #figure{lv = Lv} = F,
    Count = mod_counter:get_count(RoleId, ?MOD_SANCTUARY, ?sanctuary_remind_first),
    LimitLv = data_sanctuary:get_kv(limit_lv),
    if
        Lv < LimitLv ->
            skip;
        Count >= 1 ->
            skip;
        true ->
            mod_counter:increment_offline(RoleId, ?MOD_SANCTUARY, ?sanctuary_remind_first),
            remind_by_mon_type_list(RoleId, [?sanctuary_mon_type_guard, ?sanctuary_mon_type_elite, ?sanctuary_mon_type_boss])
    end,
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_JOIN_GUILD, data = GuildId}) ->
%%	?MYLOG("cym", "EVENT_JOIN_GUILD+++++++++++~n", []),
    mod_sanctuary:join_guild(Player#player_status.id, GuildId),
    {ok, Player};

handle_event(Player, #event_callback{type_id = ?EVENT_GUILD_DISBAND, data = LeaveGuildId}) ->
%%	?MYLOG("cym", "EVENT_GUILD_DISBAND+++++++++++~n", []),
    mod_sanctuary:quit_guild(Player#player_status.id, LeaveGuildId),
    RoleSanctuary = #sanctuary_role_in_ps{},
    db_save_sanctuary_msg_in_ps(Player#player_status.id, RoleSanctuary),
    {ok, Player#player_status{sanctuary_role_in_ps = RoleSanctuary}};


handle_event(Player, #event_callback{type_id = ?EVENT_GUILD_QUIT, data = [LeaveGuildId, _LeaveDonate]}) ->
    mod_sanctuary:quit_guild(Player#player_status.id, LeaveGuildId),
    RoleSanctuary = #sanctuary_role_in_ps{},
    db_save_sanctuary_msg_in_ps(Player#player_status.id, RoleSanctuary),
    {ok, Player#player_status{sanctuary_role_in_ps = RoleSanctuary}}.

%% 发送助攻奖励
send_kill_player_reward(PS, Produce, AttackGuildId, DieId) ->
    #player_status{guild = Guild, id = RoleId, scene = SceneId} = PS,
    #status_guild{id = MyGuildId} = Guild,
    InSanctuary = is_sanctuary_scene(SceneId),
    if
        MyGuildId == AttackGuildId andalso InSanctuary == true -> %% 同一个公会， 且在圣域场景中， 则发送奖励
            %%日志
            lib_log_api:log_sanctuary_kill(RoleId, 0, DieId, Produce#produce.reward),
            lib_goods_api:send_reward_with_mail(RoleId, Produce);
        true ->
            skip
    end,
    PS.

%% 依据死亡次数以及当前时间计算死亡等待时间
count_die_wait_time(DieTimes, NowTime) ->
    case data_sanctuary:get_kv(die_wait_time) of
        [{min_times, MinTimes}, {special, SpecialList}, {extra, WaitTime}] ->
%%			?MYLOG("cym", "die NowTime ~p~n", [NowTime]),
            RebornTime = if
                             DieTimes =< MinTimes ->
                                 NowTime;
                             true ->
                                 case lists:keyfind(DieTimes, 1, SpecialList) of
                                     {DieTimes, WaitTime1} ->
                                         NowTime + WaitTime1;
                                     _ ->
                                         NowTime + WaitTime
                                 end
                         end,
            RebornTime;
        _ ->
%%			?MYLOG("cym", "die NowTime ~p~n", [NowTime]),
            MinTimes = 0, RebornTime = NowTime
    end,
    {RebornTime, MinTimes}.

logout(Ps) ->
%%	?MYLOG("cym", "logout   ~n", []),
    mod_sanctuary:quit(Ps#player_status.id).


%% -----------------------------------------------------------------
%% @desc     功能描述 公会进程中  圣域的个人排行榜结算
%% @param    参数     DesignationMap::旧的称号信息  {SanctuaryId, Belong} => [#sanctuary_designation{}]
%%                    BelongSanctuaryList::[{SanctuaryId, Belong}]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_result_guild_person_rank(DesignationMap, BelongSanctuaryList) ->
  	%% ?MYLOG("cym", "DesignationMap ~p   BelongSanctuaryList ~p~n", [DesignationMap, BelongSanctuaryList]),
    DesignationList = lists:flatten(maps:values(DesignationMap)), %%扁平化列表
    {LastDesignationList, ResMap, NotChangeDesignationMap} = do_result_guild_person_rank_help(DesignationList, BelongSanctuaryList, #{}, #{}),
    %%ResMap 新的称号信息
    mod_sanctuary:update_designation(ResMap),  %% 更新称号信息
    mod_sanctuary:update_not_change_designation(NotChangeDesignationMap),  %% 更新称号排行榜信息，不是立即更新那种
    %%剩下来的称号列表 没有被替换掉，需要删除该称号
    %%更新玩家公会内排行榜信息
    update_guild_person_rank_msg(DesignationList),
    %%都是失去的称号，不是称号变更
    %% 失去称号的在此细分，公会失去圣域领地归属时区分邮件内容
    del_designation(LastDesignationList, ?sanctuary_designation_lost_belong).


%%更新排行榜信息到玩家信息里
update_guild_person_rank_msg(DesignationList) ->
    Map = lib_guild_data:get_guild_map(),
    GuildIdList = maps:keys(Map),
    update_guild_person_rank_msg(GuildIdList, DesignationList).


update_guild_person_rank_msg([], _DesignationList) ->
    ok;
update_guild_person_rank_msg([Id | GuildIdList], DesignationList) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.combat_power >= GuildMemberB#guild_member.combat_power
              end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(Id),
    GuildMemberList = maps:values(GuildMemberMap),
    %%除去称号的战斗力
    NewMemberList = remove_sanctuary_designation_power(GuildMemberList, DesignationList),
    SortList = lists:sort(SortFun, NewMemberList),
    update_guild_person_rank_msg_help(SortList, 0),
    update_guild_person_rank_msg(GuildIdList, DesignationList).

update_guild_person_rank_msg_help([], _PreRank) ->
    [];
update_guild_person_rank_msg_help([H | SortList], PreRank) ->
    #guild_member{id = PlayerId} = H,
    case misc:get_player_process(PlayerId) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE,
                        lib_sanctuary, update_sanctuary_guild_person_rank, [PreRank + 1]);
                false ->
                    ?ERR("update_guild_person_rank_msg_help not found player process, RoleId:~p~n", [PlayerId])
            end;
        _ ->
            %%离线处理
            Sql = io_lib:format(?sql_select_sanctuary_role_msg, [PlayerId]),
            Res = db:get_row(Sql),
            case Res of
                [GuildRank, _PersonRank] ->
                    SanctuaryRoleMsg = #sanctuary_role_in_ps{guild_rank = GuildRank, person_rank = PreRank + 1};
                _ ->
                    SanctuaryRoleMsg = #sanctuary_role_in_ps{person_rank = PreRank + 1}
            end,
            db_save_sanctuary_msg_in_ps(PlayerId, SanctuaryRoleMsg)
    end,
    update_guild_person_rank_msg_help(SortList, PreRank + 1).


%%	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_sanctuary, update_sanctuary_guild_rank, [GuildId, Rank],

do_result_guild_person_rank_help(LastDesignationList, [], ResMap, NotChangeDesignationMap) ->
    {LastDesignationList, ResMap, NotChangeDesignationMap};
do_result_guild_person_rank_help(DesignationList, [{SanctuaryId, Belong} | BelongSanctuaryList], ResMap, NotChangeDesignationMap) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.combat_power >= GuildMemberB#guild_member.combat_power
    end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(Belong),
    GuildMemberList = maps:values(GuildMemberMap),
    %%除去称号的战斗力
    NewMemberList = remove_sanctuary_designation_power(GuildMemberList, DesignationList),
    SortList = lists:sort(SortFun, NewMemberList),
    %%发送称号
    %%{旧称号列表(没有被替换的玩家), 新的称号列表, }
    {LastDesignationList, NewDesignationList} = give_designation(SortList, SanctuaryId, DesignationList),
    NewResMap = maps:put({SanctuaryId, Belong}, NewDesignationList, ResMap),
    NewNotChangeDesignationList = get_not_change_designation_map(SortList, NewDesignationList, []),
    NewNotChangeDesignationMap = maps:put(SanctuaryId, NewNotChangeDesignationList, NotChangeDesignationMap),
    do_result_guild_person_rank_help(LastDesignationList, BelongSanctuaryList, NewResMap, NewNotChangeDesignationMap).


%%除去圣域称号的战斗力
remove_sanctuary_designation_power(GuildMemberList, DesignationList) ->
    remove_sanctuary_designation_power(GuildMemberList, DesignationList, []).

remove_sanctuary_designation_power([], _DesignationList, Acc) ->
    Acc;
remove_sanctuary_designation_power([H | GuildMemberList], DesignationList, Acc) ->
    #guild_member{id = RoleId, combat_power = OldPower} = H,
    case lists:keyfind(RoleId, #sanctuary_designation.role_id, DesignationList) of  %%去除称号的战力
        #sanctuary_designation{designation = DesId} ->
            DesignationPower = get_designation_power(DesId),
            NewH = H#guild_member{combat_power = max(0, OldPower - DesignationPower)},
            remove_sanctuary_designation_power(GuildMemberList, DesignationList, [NewH | Acc]);
        _ ->
            remove_sanctuary_designation_power(GuildMemberList, DesignationList, [H | Acc])
    end.


%%获得称号的战力
get_designation_power(DesId) ->
    case data_designation:get_by_id(DesId) of
        #base_designation{attr_list = Attr} ->
            lib_player:calc_all_power(Attr);
        _ ->
            0
    end.


%%获得称号的名称
get_designation_name(DesId) ->
    case data_designation:get_by_id(DesId) of
        #base_designation{name = Name} ->
            Name;
        _ ->
            <<>>
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  发送称号  删除或者添加称号 =》 发送邮件
%% @param    参数      SortList::[#guild_member{}]排行榜
%%                     SanctuaryId::integer()  圣域id
%%                     DesignationList::[#sanctuary_designation{}] 圣域称号
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
give_designation(SortList, SanctuaryId, DesignationList) ->
    give_designation(SortList, SanctuaryId, DesignationList, [], 0).


give_designation([], _SanctuaryId, LastDesignationList, NewDesignationList, _PreRank) ->
    {LastDesignationList, NewDesignationList};
give_designation([H | SortList], SanctuaryId, LastDesignationList, DesignationList, PreRank) ->
    Rank = PreRank + 1,
    #guild_member{id = RoleId, guild_id = GuildId} = H,
    %%旧称号
    OldDesignationId = get_designation_id_with_list(RoleId, LastDesignationList),
    case data_sanctuary:get_designation_by_rank(SanctuaryId, Rank) of
        [] -> %%没有称号
            NewDesignationList = DesignationList,
            lib_sanctuary:change_designation(RoleId, 0, OldDesignationId, Rank, GuildId);
        DesId ->
            %%新的称号列表
            NewDesignationList = [#sanctuary_designation{role_id = RoleId, designation = DesId, rank = Rank, guild_id = GuildId
            } | DesignationList],
            lib_sanctuary:change_designation(RoleId, DesId, OldDesignationId, Rank, GuildId)
    end,
    %%新的剩余列表
    NewLastDesignationList = lists:keydelete(RoleId, #sanctuary_designation.role_id, LastDesignationList),
    give_designation(SortList, SanctuaryId, NewLastDesignationList, NewDesignationList, Rank).

get_designation_id_with_list(RoleId, LastDesignationList) ->
    case lists:keyfind(RoleId, #sanctuary_designation.role_id, LastDesignationList) of
        #sanctuary_designation{designation = Id} ->
            Id;
        _ ->
            0
    end.


%% 即没有老的称号，也没有旧的称号,不用做
change_designation(_RoleId, 0, 0, _Rank, _GuildId) ->
    skip;

%% 没有新的称号，只有老的称号=>删除老称号
change_designation(RoleId, 0, OldDesignationId, Rank, GuildId) ->
    del_designation([#sanctuary_designation{role_id = RoleId, designation = OldDesignationId, rank = Rank, guild_id = GuildId}],
        ?sanctuary_designation_lost);

%% 有新的称号，没有老的称号 =>添加新的称号
change_designation(RoleId, DesignationId, 0, Rank, _GuildId) ->
    add_designation(RoleId, DesignationId, 1, Rank);

%%称号一致, 什么都不干
change_designation(_RoleId, DesignationId, DesignationId, _Rank, _GuildId) ->
    ok;
%%	add_designation(RoleId, DesignationId, 2, Rank);

%%称号不一致，一封获得
change_designation(RoleId, DesignationId, OldDesignationId, Rank, GuildId) ->
    del_designation([#sanctuary_designation{role_id = RoleId, designation = OldDesignationId, rank = Rank, guild_id = GuildId}],
        ?sanctuary_designation_change),
    add_designation(RoleId, DesignationId, 1, Rank).
%% -----------------------------------------------------------------
%% @desc     功能描述  添加称号
%% @param    参数     Type::integer()  1::发送邮件也发送称号 2:只是发送邮件
%% @return   返回值    无
%% @history  修改历史
%% -----------------------------------------------------------------
add_designation(RoleId, DesignationId, 2, Rank) ->
    send_got_designation_mail(RoleId, DesignationId, Rank);
add_designation(RoleId, DesignationId, _, Rank) ->
    lib_designation_api:active_dsgt_common(RoleId, DesignationId),
    send_got_designation_mail(RoleId, DesignationId, Rank).

send_got_designation_mail(RoleId, DesignationId, Rank) ->
    DesName = get_designation_name(DesignationId),
    Title = utext:get(2830005),
    Content = utext:get(2830006, [Rank, DesName]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []).

%% -----------------------------------------------------------------
%% @desc     功能描述   去掉称号
%% @param    参数       DesignationList::[#sanctuary_designation{}]
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
del_designation([], _Type) ->
    skip;
del_designation([H | DesignationList], Type) ->
    #sanctuary_designation{role_id = RoleId, designation = DesId, rank = Rank, guild_id = GuildId} = H,
    lib_designation_api:remove_dsgt(RoleId, DesId),
    %%发送邮件
    LastRank = get_my_guild_rank(RoleId, GuildId, Rank),
    case LastRank of
        0 -> %% 公会没有这号人
            skip;
        LastRank1 ->
            case Type of
                ?sanctuary_designation_lost ->
                    DesName = get_designation_name(DesId),
                    Title = utext:get(2830003),
                    Content = utext:get(2830004, [LastRank1, DesName]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, []);
                ?sanctuary_designation_lost_belong ->
                    DesName = get_designation_name(DesId),
                    Title = utext:get(2830003),
                    Content = utext:get(2830012, [DesName]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, []);
                _ ->
                    ok
            end
    end,
    del_designation(DesignationList, Type).


%%获得公会内的排行
get_my_guild_rank(RoleId, GuildId, 0) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.combat_power >= GuildMemberB#guild_member.combat_power
              end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    GuildMemberList = maps:values(GuildMemberMap),
    %%除去称号的战斗力
    SortList = lists:sort(SortFun, GuildMemberList),
    get_my_guild_rank_help(RoleId, SortList, 0);
get_my_guild_rank(_RoleId, _GuildId, Rank) ->
    Rank.

get_my_guild_rank_help(_RoleId, [], _PreRank) -> %%公会中没有这个玩家
    0;
get_my_guild_rank_help(RoleId, [H | SortList], PreRank) ->
    #guild_member{id = RoleId1} = H,
    if
        RoleId == RoleId1 ->
            PreRank + 1;
        true ->
            get_my_guild_rank_help(RoleId, SortList, PreRank + 1)
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  公会进程中
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_guild_rank_info_with_guild_id(RoleId, GuildId, DesignationMap) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.combat_power >= GuildMemberB#guild_member.combat_power
              end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    GuildMemberList = maps:values(GuildMemberMap),
    DesignationList = lists:flatten(maps:values(DesignationMap)), %%扁平化列表
    NewMemberList = remove_sanctuary_designation_power(GuildMemberList, DesignationList), %%去掉战力的列表
    SortList = lists:sort(SortFun, NewMemberList),
    PackList = pack_for_guild_rank(SortList, DesignationList),
    case lists:keyfind(RoleId, 1, PackList) of
        {RoleId, Rank, _Picture, _Picture_ver, _Career, _RoleName, Power, _DesId} ->
            MyRank = Rank,
            MyPower = Power;
        _ ->
            MyRank = 0,
            MyPower = 0
    end,
    PackList1 = [{RoleId1, Rank1, Picture1, PictureVer1, Career1, RoleName1, Power1, DesId1} ||
        {RoleId1, Rank1, Picture1, PictureVer1, Career1, RoleName1, Power1, DesId1} <- PackList],
    {ok, Bin} = pt_283:write(28310, [MyRank, MyPower, PackList1]),
    lib_server_send:send_to_uid(RoleId, Bin).

pack_for_guild_rank(SortList, DesignationList) ->
    pack_for_guild_rank(SortList, DesignationList, 0, []).


pack_for_guild_rank([], _DesignationList, _PreRank, AccList) ->
    lists:reverse(AccList);
pack_for_guild_rank([H | SortList], DesignationList, PreRank, AccList) ->
    #guild_member{figure = F, combat_power = Power, id = RoleId} = H,
    RoleName = F#figure.name,
    DesId = get_designation_id_with_list(RoleId, DesignationList),
    Rank = PreRank + 1,
    pack_for_guild_rank(SortList, DesignationList, Rank,
        [{RoleId, Rank, F#figure.picture, F#figure.picture_ver, F#figure.career, RoleName, Power, DesId} | AccList]).


get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId, BelongGuild, DesignationMap) ->
    SortFun = fun(GuildMemberA, GuildMemberB) ->
        GuildMemberA#guild_member.combat_power >= GuildMemberB#guild_member.combat_power
              end,
    GuildMemberMap = lib_guild_data:get_guild_member_map(BelongGuild),
    GuildMemberList = maps:values(GuildMemberMap),
    SortList = lists:sort(SortFun, GuildMemberList),
    DesignationList = lists:flatten(maps:values(DesignationMap)), %%扁平化列表
    PackList = pack_for_guild_rank2(SortList, DesignationList),
    ?MYLOG("cym", "SanctuaryId ~p~nPackList ~p~n", [SanctuaryId, PackList]),
    {ok, Bin} = pt_283:write(28312, [SanctuaryId, PackList]),
    lib_server_send:send_to_uid(RoleId, Bin).

pack_for_guild_rank2(SortList, DesignationList) ->
    pack_for_guild_rank2(SortList, DesignationList, 0, []).

pack_for_guild_rank2([], _DesignationList, _PreRank, AccList) ->
    lists:reverse(AccList);
pack_for_guild_rank2([H | SortList], DesignationList, PreRank, AccList) ->
    #guild_member{figure = F, combat_power = Power, id = RoleId} = H,
    RoleName = F#figure.name,
    DesId = get_designation_id_with_list(RoleId, DesignationList),
    Rank = PreRank + 1,
    pack_for_guild_rank2(SortList, DesignationList, Rank,
        [{Rank, RoleName, Power, DesId} | AccList]).


%%是否永久结束了
get_status() ->
    {_MinDay, MaxDay} = data_sanctuary:get_kv(open_day),
    OpenDay = util:get_open_day(),
    OpenTime = util:get_open_time(),
    _CfgTime = data_sanctuary:get_kv(open_time),
    CfgOpenTime = utime:unixtime({_CfgTime, {0, 0, 0}}),
%%	?MYLOG("cym", "OpenTime ~p~n", [OpenTime]),
    if
        OpenTime < CfgOpenTime ->   %%开服天数在这之前的全部永久结束
            ?sanctuary_yet_over;
        OpenDay > MaxDay ->
            ?sanctuary_yet_over;
        OpenDay == MaxDay ->
            SubIdList = data_activitycalen:get_ac_sub(?MOD_SANCTUARY, 1),
            EndTime = lib_sanctuary_mod:get_last_day_end_time(lists:max(SubIdList)),
            Now = utime:unixtime() + 2, %%加多2秒，用于防止刚好压点
            if
                Now >= EndTime ->
                    ?sanctuary_yet_over;
                true ->
                    ?sanctuary_close
            end;
        true ->
            ?sanctuary_close
    end.
%%被伤害提醒
mon_be_hurt_remind(RoleId, SanctuaryId, MonId, BelongGuildId) ->
    case misc:get_player_process(RoleId) of
        Pid when is_pid(Pid) ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, mon_be_hurt_remind_in_ps, [SanctuaryId, MonId, BelongGuildId]);
        _ -> %%离线就不处理了
            skip
    end.
%%怪物被伤害提醒
mon_be_hurt_remind_in_ps(Ps, SanctuaryId, MonId, BelongGuildId) ->
    #player_status{guild = Guild} = Ps,
    #status_guild{id = GuildId} = Guild,
    if
        GuildId =/= 0 andalso GuildId == BelongGuildId -> %% 己方圣域的怪物才行
            {ok, Bin} = pt_283:write(28313, [SanctuaryId, MonId]),
            lib_server_send:send_to_uid(Ps#player_status.id, Bin);
        true ->
            ok
    end,
    Ps.


default_sanctuary_list() ->
    [[Id, 0, 0, <<>>] || Id <- ?sanctuary_id_list].


%%因为退出公会所以失去称号
remove_designation_when_quit_guild(RoleId, DesId) ->
    Title = utext:get(2830003),
    DesName = get_designation_name(DesId),
    Content = utext:get(2830007, [DesName]),
    lib_mail_api:send_sys_mail([RoleId], Title, Content, []),
    lib_designation_api:remove_dsgt(RoleId, DesId).

get_not_change_designation_map(_SortList, [], AccList) ->
    lists:reverse(AccList);
get_not_change_designation_map(SortList, [H | DesignationList], AccList) ->
    #sanctuary_designation{role_id = RoleId, designation = DesId, rank = Rank, guild_id = GuildId} = H,
    case lists:keyfind(RoleId, #guild_member.id, SortList) of
        #guild_member{combat_power = Power, figure = F} ->
            Des = #sanctuary_not_change_designation{role_id = RoleId, designation = DesId,
                rank = Rank, guild_id = GuildId, power = Power, role_name = F#figure.name};
        _ ->
            Des = #sanctuary_not_change_designation{role_id = RoleId, designation = DesId, rank = Rank, guild_id = GuildId}
    end,
    get_not_change_designation_map(SortList, DesignationList, [Des | AccList]).



remind_by_mon_type_list(_RoleId, []) ->
    skip;
remind_by_mon_type_list(RoleId, [H | List]) ->
    remind_by_mon_type(RoleId, H),
    remind_by_mon_type_list(RoleId, List).

remind_by_mon_type(RoleId, MonType) ->
    remind_by_mon_type(RoleId, MonType, ?sanctuary_id_list).

remind_by_mon_type(_RoleId, _MonType, []) ->
    skip;
remind_by_mon_type(RoleId, MonType, [SanctuaryId | List]) ->
    case data_sanctuary:get_mon_list_by_sanctuary_and_type(SanctuaryId, MonType) of
        [] ->
            ok;
        MonList ->
            mod_sanctuary:remind(RoleId, SanctuaryId, MonList)
    end,
    remind_by_mon_type(RoleId, MonType, List).


remind_in_ps(PS, SanctuaryId, MonCfgId, BelongGuildId) ->
    #player_status{guild = Guild, id = RoleId} = PS,
    #status_guild{id = MyGuildId} = Guild,
%%	?MYLOG("cym", "RoleId ~p MyGuildId ~p BelongGuildId ~p~n", [RoleId, MyGuildId, BelongGuildId]),
    if
        BelongGuildId == 0 orelse (MyGuildId =/= BelongGuildId) -> %%只有不同圣域的才会通知
            {ok, Bin} = pt_283:write(28307, [SanctuaryId, MonCfgId]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            skip
    end,
    PS.

day_clear() ->
%%	?MYLOG("cym", "day_clear ++++++++++++++++++++++", []),
    OpenDay = util:get_open_day(),
    ClearDay = data_sanctuary:get_kv(sanctuary_clear_day),
    if
        OpenDay == ClearDay ->
            OnlineRoles = ets:tab2list(?ETS_ONLINE),
            [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_sanctuary, clear_sanctuary_clear, []) || E <- OnlineRoles],
            Sql = io_lib:format(?sql_clear_sanctuary_medal, [?GOODS_ID_MEDAL]),
            db:execute(Sql);
        true ->
            ok
    end.


clear_sanctuary_clear(Ps) ->
    SanctuaryMedalNum = lib_goods_api:get_currency(Ps, ?GOODS_ID_MEDAL),
    if
        SanctuaryMedalNum =< 0 ->
            Ps;
        true ->
            Cost = [{?TYPE_CURRENCY, ?GOODS_ID_MEDAL, SanctuaryMedalNum}],
            case lib_goods_api:cost_object_list_with_check(Ps, Cost, sanctuary_clear_medal, "") of
                {true, NewPs} ->
                    NewPs;
                true ->
                    Ps
            end
    end.


%%通知公会的玩家，圣域结算结果
send_to_guild_member_sanctuary_settlement([]) ->
    ok;
send_to_guild_member_sanctuary_settlement([H | RankList]) ->
    #common_rank_guild{guild_id = GuildId, rank = Rank} = H,
    mod_guild:send_to_guild_member_sanctuary_settlement(GuildId, Rank),
    send_to_guild_member_sanctuary_settlement(RankList).

%%公会进程中
send_to_guild_member_sanctuary_settlement(GuildId, Rank) ->
    GuildMemberMap = lib_guild_data:get_guild_member_map(GuildId),
    GuildMemberList = maps:values(GuildMemberMap),  %% [#guild_member]
    F = fun(#guild_member{id = PlayerId}) ->
        case misc:get_player_process(PlayerId) of
            Pid when is_pid(Pid) ->
                case misc:is_process_alive(Pid) of
                    true ->
                        lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE,
                            lib_sanctuary, update_sanctuary_guild_rank, [GuildId, Rank]);
                    false ->
                        ?ERR("send_to_guild_member_sanctuary_settlement not found player process, RoleId:~p~n", [PlayerId])
                end;
            _ ->
                %%离线处理
                Sql = io_lib:format(?sql_select_sanctuary_role_msg, [PlayerId]),
                Res = db:get_row(Sql),
                case Res of
                    [_GuildRank, PersonRank] ->
                        SanctuaryRoleMsg = #sanctuary_role_in_ps{guild_rank = Rank, person_rank = PersonRank};
                    _ ->
                        SanctuaryRoleMsg = #sanctuary_role_in_ps{guild_rank = Rank}
                end,
                db_save_sanctuary_msg_in_ps(PlayerId, SanctuaryRoleMsg)
        end
        end,
    lists:foreach(F, GuildMemberList).

%%更新公会排行榜信息到玩家信息上
update_sanctuary_guild_rank(Ps, _GuildId, Rank) ->
%%	?MYLOG("cym", "RoleId ~p Rank ~p  _GuildId ~p ~n", [Ps#player_status.id, Rank, _GuildId]),
    #player_status{sanctuary_role_in_ps = RoleSanctuary} = Ps,
%%	?MYLOG("cym", "RoleSanctuary ~p~n", [RoleSanctuary]),
    case RoleSanctuary of
        #sanctuary_role_in_ps{} ->
            NewRoleSanctuary = RoleSanctuary#sanctuary_role_in_ps{guild_rank = Rank};
        _ ->
            NewRoleSanctuary = #sanctuary_role_in_ps{guild_rank = Rank}
    end,
%%	?MYLOG("cym", "Id ~p   NewRoleSanctuary ~p~n", [Ps#player_status.id, NewRoleSanctuary]),
    db_save_sanctuary_msg_in_ps(Ps#player_status.id, NewRoleSanctuary),
    Ps#player_status{sanctuary_role_in_ps = NewRoleSanctuary}.

update_sanctuary_guild_person_rank(Ps, Rank) ->
    #player_status{sanctuary_role_in_ps = RoleSanctuary} = Ps,
    case RoleSanctuary of
        #sanctuary_role_in_ps{} ->
            NewRoleSanctuary = RoleSanctuary#sanctuary_role_in_ps{person_rank = Rank};
        _ ->
            NewRoleSanctuary = #sanctuary_role_in_ps{person_rank = Rank}
    end,
    db_save_sanctuary_msg_in_ps(Ps#player_status.id, NewRoleSanctuary),
    Ps#player_status{sanctuary_role_in_ps = NewRoleSanctuary}.

%%============================================================db=======================================
%% 圣域信息同步数据库
db_save_sanctuary_msg(State) ->
    #sanctuary_state{sanctuary_map = Map} = State,
    SanctuaryList = maps:values(Map),
    [db_save_sanctuary_msg_help(X) || X <- SanctuaryList].

db_save_sanctuary_msg_help(Sanctuary) ->
    #sanctuary_msg{sanctuary_id = Id, point = Point, belong = BelongGuildId, belong_name = BelongName} = Sanctuary,
    Sql = io_lib:format(?sql_replace_into_sanctuary_msg, [Id, Point, BelongGuildId, BelongName]),
    db:execute(Sql).

%%击杀记录同步数据库
db_save_mon_kill_log(KillLog, MonCfgId) ->
    #sanctuary_kill_log{is_show = IsShow, role_id = RoleId, diff_point = Point, time = Time, role_name = RoleName} = KillLog,
    Sql = io_lib:format(?sql_replace_into_sanctuary_mon_kill_log, [MonCfgId, RoleId, RoleName, IsShow, Point, Time]),
    db:execute(Sql).

%%关注列表
db_save_mon_remind_list(BossId, LastRemindList) ->
    Sql = io_lib:format(?sql_replace_into_sanctuary_mon_remind, [BossId, util:term_to_bitstring(LastRemindList)]),
    db:execute(Sql).


%%称号
db_save_designation_msg(DesignationMap) ->
    %% 删除所有称号
    Sql1 = io_lib:format(?delete_sanctuary_designation, []),
    db:execute(Sql1),
    DesList = maps:to_list(DesignationMap),
%%	?MYLOG("cym", "DesList ~p~n", [DesList]),
    [db_save_designation_msg_help(X) || X <- DesList].

db_save_designation_msg_help({{SanctuaryId, GuildId}, List}) ->
    [db_save_designation_msg_help(SanctuaryId, GuildId, X) || X <- List].

db_save_designation_msg_help(SanctuaryId, GuildId, Designation) ->
    #sanctuary_designation{role_id = RoleId, designation = DesId} = Designation,
    Sql1 = io_lib:format(?sql_replace_into_sanctuary_designation, [SanctuaryId, GuildId, RoleId, DesId]),
    db:execute(Sql1).



init_sanctuary_map_from_db() ->
    Sql1 = io_lib:format(?sql_select_sanctuary_msg, []),
    List = db:get_all(Sql1),
    init_sanctuary_map_from_db(List).


init_sanctuary_map_from_db([]) ->
    init_sanctuary_map_from_db(default_sanctuary_list(), #{});
init_sanctuary_map_from_db(List) ->
    init_sanctuary_map_from_db(List, #{}).


init_sanctuary_map_from_db([], Map) ->
    Map;
init_sanctuary_map_from_db([[SanctuaryId, Point, Belong, BelongName] | List], Map) ->
    MonList = init_mon_list_from_db(SanctuaryId),
    Sanctuary = #sanctuary_msg{sanctuary_id = SanctuaryId, point = Point, belong = Belong, belong_name = BelongName, mon_msg = MonList},
    NewMap = maps:put(SanctuaryId, Sanctuary, Map),
    init_sanctuary_map_from_db(List, NewMap).


init_mon_list_from_db(SanctuaryId) ->
    MonIdList = data_sanctuary:get_mon_list_by_sanctuary(SanctuaryId),
    [init_mon_from_db(MonId) || MonId <- MonIdList].


init_mon_from_db(MonId) ->
    RemindList = init_remind_list_from_db(MonId),
    KillLogList = init_kill_log_list_from_db(MonId),
    MonMsg = #sanctuary_mon_msg{cfg_id = MonId, remind_list = RemindList, kill_log = KillLogList, status = ?sanctuary_mon_dead},
    MonMsg.

init_remind_list_from_db(MonId) ->
    Sql = io_lib:format(?sql_select_sanctuary_remind_list, [MonId]),
    case db:get_row(Sql) of
        [] ->
            [];
        [RoleList] ->
            case util:bitstring_to_term(RoleList) of
                undefined ->
                    [];
                V ->
                    V
            end
    end.

init_kill_log_list_from_db(MonId) ->
    Sql = io_lib:format(?sql_select_kill_log_list, [MonId, ?sanctuary_kill_log_len]),
    List = db:get_all(Sql),
    [init_kill_log_list_from_db_help(X) || X <- List].

init_kill_log_list_from_db_help([RoleId, RoleName, IsShow, Point, Time]) ->
    #sanctuary_kill_log{role_id = RoleId, role_name = RoleName, is_show = IsShow, diff_point = Point, time = Time}.


init_designation_from_db() ->
    Sql = io_lib:format(?sql_select_designation_sanctuary_id_guild_id, []),
    List = db:get_all(Sql),
    ?IF(List == [], #{}, init_designation_from_db(List, #{})).



init_designation_from_db([], Map) ->
    Map;
init_designation_from_db([[SanctuaryId, GuildId] | List], Map) ->
    Sql = io_lib:format(?sql_select_designation, [SanctuaryId, GuildId]),
    DbList = db:get_all(Sql),
    List1 = [#sanctuary_designation{role_id = RoleId, designation = DesId, guild_id = GuildId} || [RoleId, DesId] <- DbList],
    NewMap = maps:put({SanctuaryId, GuildId}, List1, Map),
    init_designation_from_db(List, NewMap).


db_save_last_time_designation(NotChangeDesignationMap) when is_map(NotChangeDesignationMap) ->
    List = maps:to_list(NotChangeDesignationMap),
    Sql = io_lib:format(?delete_sanctuary_last_time_designation, []),
    db:execute(Sql),
    [db_save_last_time_designation(X) || X <- List];

db_save_last_time_designation({SanctuaryId, List}) ->
    db_save_last_time_designation(SanctuaryId, List).

db_save_last_time_designation(_SanctuaryId, []) ->
    ok;
db_save_last_time_designation(SanctuaryId, [H | List]) ->
    #sanctuary_not_change_designation{guild_id = GuildId, role_id = RoleId,
        role_name = RoleName, power = Power, designation = DesId} = H,
    Sql = io_lib:format(?sql_replace_into_last_time_designation, [SanctuaryId, GuildId, RoleId, RoleName, Power, DesId]),
    db:execute(Sql),
    db_save_last_time_designation(SanctuaryId, List).

init_last_time_designation_from_db() ->
    init_last_time_designation_from_db(?sanctuary_id_list, #{}).

init_last_time_designation_from_db([], Map) ->
    Map;
init_last_time_designation_from_db([Id | List], Map) ->
    Sql = io_lib:format(?sql_select_last_time_designation, [Id]),
    DbList = db:get_all(Sql),
    DesList = [#sanctuary_not_change_designation{guild_id = GuildId, role_id = RoleId, role_name = RoleName, power = Power, designation = DesignationId} ||
        [GuildId, RoleId, RoleName, Power, DesignationId] <- DbList],
    F = fun(#sanctuary_not_change_designation{power = P1}, #sanctuary_not_change_designation{power = P2}) ->
        P1 >= P2
        end,
    DesList2 = lists:sort(F, DesList),
    F2 = fun(Item, {Rank, AccList}) ->
        {Rank + 1, [Item#sanctuary_not_change_designation{rank = Rank + 1} | AccList]}
         end,

    {_, DesList3} = lists:foldl(F2, {0, []}, DesList2),

    ?PRINT("ResList ~p~n", [DesList3]),
    NewMap = maps:put(Id, lists:reverse(DesList3), Map),
    init_last_time_designation_from_db(List, NewMap).


db_save_sanctuary_msg_in_ps(RoleId, RoleSanctuary) ->
    #sanctuary_role_in_ps{guild_rank = GuildRank, person_rank = PersonRank} = RoleSanctuary,
    Sql = io_lib:format(?sql_replace_into_sanctuary_role_msg_in_ps, [RoleId, GuildRank, PersonRank]),
    db:execute(Sql).

db_save_last_guild_rank(RankList) ->
    Sql = io_lib:format(?sql_delete_from_last_guild_rank, []),
    db:execute(Sql),
    db_save_last_guild_rank_help(RankList).


db_save_last_guild_rank_help([]) ->
    ok;
db_save_last_guild_rank_help([H | RankList]) ->
    #last_guild_rank{rank = Rank, guild_id = GuildId} = H,
    Sql = io_lib:format(?sql_replace_into_last_guild_rank, [GuildId, Rank]),
    db:execute(Sql),
    db_save_last_guild_rank_help(RankList).


get_last_guild_list_from_db() ->
    Sql = io_lib:format(?sql_select_last_guild_rank, []),
    DBList = db:get_all(Sql),
    List = [#last_guild_rank{guild_id = GuildId, rank = Rank} || [GuildId, Rank] <- DBList],
    List.

%%============================================================db=======================================


get_boss_kill_sanctuary_medal_reward(SanctuaryId, MonId) ->
    SanctuaryMedalList = data_sanctuary:get_kv(kill_reward),
    case data_sanctuary:get_mon_type(SanctuaryId, MonId) of
        [] ->
            [];
        Type ->
            if
                Type =< ?sanctuary_mon_type_boss ->
                    case lists:keyfind(Type, 1, SanctuaryMedalList) of
                        {Type, Value} ->
                            [{?TYPE_CURRENCY, ?GOODS_ID_MEDAL, Value}];
                        _ ->
                            []
                    end;
                true ->
                    []
            end
    end.


change_mod(Status, Type) ->
    case lib_player:change_pkstatus(Status, Type) of
        false ->
            {ok, Status};
        {ok, #player_status{id = RoleId, scene = SceneId, pk_map = PkMap, guild = Guild} = NewStatus} ->
            % 场景编辑器有问题,先在代码上写死判断
            IsNeedScene = lib_boss:is_in_forbdden_boss(SceneId) orelse lib_boss:is_in_fairy_boss(SceneId),
            lib_sanctuary:change_pk_mod(RoleId, Type, Guild, SceneId),
            case data_scene:get(SceneId) of
                #ets_scene{is_stay_pk_status = IsStay} when IsStay == 1 orelse IsNeedScene ->
                    NewPkMap = maps:put(SceneId, Type, PkMap),
                    % lib_player_record:db_role_pk_status_replace(RoleId, SceneId, Type),
                    {ok, NewStatus#player_status{pk_map = NewPkMap}};
                _ ->
                    {ok, NewStatus}
            end
    end.


guild_member_af_disband_guild(GuildMember) ->
    #guild_member{id = RoleId, guild_id = LeaveGuildId} = GuildMember,
    mod_sanctuary:quit_guild(RoleId, LeaveGuildId),
    RoleSanctuary = #sanctuary_role_in_ps{},
    db_save_sanctuary_msg_in_ps(RoleId, RoleSanctuary),
    ok.

%%修正称号信息
get_right_send_designation_list(List) ->
    SanctuaryList = data_sanctuary:get_designation_list(),
    SanctuaryStatus = lib_sanctuary:get_status(),
    F = fun({Id, Order, Endtime}, AccList) ->
        case lists:member(Id, SanctuaryList) of
            true ->
                if
                    SanctuaryStatus == ?sanctuary_yet_over ->
                        [{Id, Order, Endtime} | AccList];
                    true ->
                        [{Id, Order, 1} | AccList]
                end;
            _ ->
                [{Id, Order, Endtime} | AccList]
        end
        end,
    NewList = lists:foldl(F, [], List),
    lists:reverse(NewList).


clear_all() ->
    Sql1 = io_lib:format(?delete_sanctuary_designation, []),  %%圣域称号
    Sql2 = io_lib:format(?delete_sanctuary_last_time_designation, []),  %%上一次称号信息
    Sql3 = io_lib:format(?sql_delete_from_last_guild_rank, []),  %%上一次公会排名
    Sql4 = io_lib:format(?sql_delete_sanctuary_msg, []),  %%圣域信息
    Sql5 = io_lib:format(?sql_delete_designation, []),  %%称号表的圣域称号
    Sql6 = io_lib:format(?sql_delete_sanctuary_mon_kill_log, []),  %%击杀记录
    Sql7 = io_lib:format(?sql_delete_sanctuary_role_in_ps, []),  %%圣域个人信息
    db:execute(Sql1),
    db:execute(Sql2),
    db:execute(Sql3),
    db:execute(Sql4),
    db:execute(Sql5),
    db:execute(Sql7),
    db:execute(Sql6).


update_sanctuary_designation() ->
    Sql = "select   role_id, designation_id from  sanctuary_designation",
    List = db:get_all(Sql),
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_sanctuary, update_sanctuary_designation, [DesId])
        || [RoleId, DesId] <- List].


update_sanctuary_designation(PS, DesId) ->
    case lib_designation_api:is_dsgt_active(PS, DesId) of
        true ->
            ok;
        false ->
            lib_designation_api:active_dsgt_common(PS#player_status.id, DesId)
    end,
    PS.

%%延迟登出
delay_stop(PS) ->
    #player_status{scene = SceneId, battle_attr = BA, status_boss = #status_boss{boss_map = BossMap},
        sanctuary_role_in_ps = _RoleSanctuary} = PS,
    case _RoleSanctuary of
        #sanctuary_role_in_ps{} = RoleSanctuary ->
            ok;
        _ ->
            RoleSanctuary = #sanctuary_role_in_ps{}
    end,
    #battle_attr{hp = Hp} = BA,
    IsSanctuaryScene = is_sanctuary_scene(SceneId),
    case maps:get(?BOSS_TYPE_SANCTUARY, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
        _ ->
            DieTime = 0, DieTimes = 0
    end,
    NowTime = utime:unixtime(),
    {RebornTime, _MinTimes} = count_die_wait_time(DieTimes, DieTime),
    SanctuaryRebornTime = get_reborn_time_after_die_time_limit(DieTimes),
%%	?MYLOG("cym", "RebornTime ~p NowTime ~p~n", [RebornTime, NowTime]),
    if
        IsSanctuaryScene == true ->
            ReviveGhostTime = lib_sanctuary_mod:get_revive_ghost_time(), %%幽灵时间
            if
                Hp =< 0 ->  %%血量为0则让他定时复活
                    RebornRef = util:send_after([], max(min(RebornTime + SanctuaryRebornTime - NowTime,
                        DieTime + ReviveGhostTime - NowTime) * 1000, 500),
                        self(), {'mod', lib_sanctuary, sanctuary_reborn, []}),
                    NewPlayer = PS#player_status{sanctuary_role_in_ps = RoleSanctuary#sanctuary_role_in_ps{reborn_ref = RebornRef}};
                true ->
                    NewPlayer = PS
            end;
        true ->
            NewPlayer = PS
    end,
    NewPlayer.

sanctuary_reborn(Ps) ->
    #player_status{sanctuary_role_in_ps = RoleSanctuary} = Ps,
    #sanctuary_role_in_ps{reborn_ref = OldRef} = RoleSanctuary,
    util:cancel_timer(OldRef),
    #player_status{scene = SceneId, battle_attr = BA, status_boss = #status_boss{boss_map = BossMap}} = Ps,
    IsSanctuaryScene = is_sanctuary_scene(SceneId),
    case maps:get(?BOSS_TYPE_SANCTUARY, BossMap, []) of
        TemRoleBoss when is_record(TemRoleBoss, role_boss) ->
            #role_boss{die_time = DieTime, die_times = DieTimes} = TemRoleBoss;
        _ ->
            DieTime = 0, DieTimes = 0
    end,
    NowTime = utime:unixtime(),
    {RebornTime, _MinTimes} = count_die_wait_time(DieTimes, DieTime),
%%	FatigueBuffTime = lib_sanctuary_mod:get_fatigue_buff_time(), %%疲劳时间
    _ReviveGhostTime = lib_sanctuary_mod:get_revive_ghost_time(), %%幽灵时间
    SanctuaryRebornTime = get_reborn_time_after_die_time_limit(DieTimes),%%死亡限制时间戳后的倒计时
    #battle_attr{hp = Hp} = BA,
    if
        IsSanctuaryScene == true ->
            #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
            GhostAbsTime = abs(RebornTime + SanctuaryRebornTime - NowTime),
            if
                Hp =< 0 ->  %%血量为0则，让他复活到出生点
                    if
                        GhostAbsTime >= 1 -> %%不在自动复活时间点
%%							?MYLOG("cym", "ghost  ~n", []),
                            SanctuaryRebornRef = util:send_after([], max((RebornTime + SanctuaryRebornTime - NowTime) * 1000, 500), self(), %%下一次复活
                                {'mod', lib_sanctuary, sanctuary_reborn, []}),
                            Player1 = Ps#player_status{sanctuary_role_in_ps = RoleSanctuary#sanctuary_role_in_ps{reborn_ref = SanctuaryRebornRef}},
                            NewPlayer = lib_scene:change_relogin_scene(Player1#player_status{x = X, y = Y}, [{hp, 0}]);
                        true -> %% 直接复活
%%							?MYLOG("cym", "reborn  NowTime ~p ~n", [NowTime]),
                            NewPlayer = lib_scene:change_relogin_scene(Ps#player_status{x = X, y = Y}, [{change_scene_hp_lim, 100}, {ghost, 0}])
                    end;
                true ->
                    NewPlayer = Ps
            end;
        true ->
            NewPlayer = Ps
    end,
    NewPlayer.


%% 发送积分通知客户端
send_point_to_client(0, _GuildId, _KillList, _RoleId) ->
    ok;
send_point_to_client(_DiffPoint, 0, _KillList, _RoleId) ->
    ok;
send_point_to_client(DiffPoint, GuildId, KillList, _RoleId) ->
    [lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sanctuary, send_point_to_client_help, [DiffPoint, GuildId])
        || #mon_atter{id = RoleId} <- KillList].

send_point_to_client_help(Ps, DiffPoint, GuildId) ->
    #player_status{guild = Guild, id = RoleId} = Ps,
    #status_guild{id = MyGuildId} = Guild,
    if
        MyGuildId == 0 orelse MyGuildId =/= GuildId ->
            skip;
        true ->
            {ok, Bin} = pt_283:write(28317, [DiffPoint]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end,
    Ps.


get_last_kill_msg(PS) ->
    #player_status{last_be_kill = Kill} = PS,
    case lists:keyfind(sign, 1, Kill) of
        {sign, Sign} ->
            ok;
        _ ->
            Sign = 1
    end,
    case lists:keyfind(name, 1, Kill) of
        {name, Name} ->
            ok;
        _ ->
            Name = utext:get(181) %%"野怪"
    end,
    {Sign, Name}.

get_reborn_time_after_die_time_limit(DieTimes) ->
    List = data_sanctuary:get_kv(reborn_time_after_die_time_limit),%%死亡限制时间戳后的倒计时
    get_reborn_time_after_die_time_limit_help(List, DieTimes).


get_reborn_time_after_die_time_limit_help([], _DieTimes) ->
    0;
get_reborn_time_after_die_time_limit_help([{Count, Time} | T], DieTimes) ->
    if
        DieTimes =< Count ->
            Time;
        true ->
            get_reborn_time_after_die_time_limit_help(T, DieTimes)
    end.


add_sanctuary_boss_tired(#player_status{id = RoleId, scene = Scene} = PS) ->
    IsInSanctuary = is_sanctuary_scene(Scene),
    if
        IsInSanctuary == false ->
            ok;
        true ->
            mod_daily:plus_count_offline(RoleId, ?MOD_SANCTUARY, ?sanctuary_boss_tired_daily_id, ?sanctuary_boss_tired_add),
            %% 通知客户端疲劳值
            BossTired = mod_daily:get_count_offline(RoleId, ?MOD_SANCTUARY, ?sanctuary_boss_tired_daily_id),
            {ok, Bin} = pt_283:write(28318, [BossTired]),
            {ok, Bin1} = pt_283:write(28319, [?sanctuary_boss_tired_add]),
            lib_server_send:send_to_uid(RoleId, Bin),
            lib_server_send:send_to_uid(RoleId, Bin1),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_boss, try_to_updata_senen_data, [?BOSS_TYPE_SANCTUARY])
    end,
    PS.

%% -----------------------------------------------------------------
%% @desc     功能描述  参与奖励和归属奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
hand_reward(_RoleId, KillList) ->
    SortFun = fun(A, B) ->
        A#mon_atter.hurt >= B#mon_atter.hurt
              end,
    SortList = lists:sort(SortFun, KillList),
    [H | T] = SortList,
    #mon_atter{id = RoleId} = H,
    BelongReward = get_belong_reward(),
    ParticipantReward = get_participant_reward(),
%%	?MYLOG("cym", "BelongReward ~p~n", [BelongReward]),
%%	lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = BelongReward, type = sanctuary_belong_reward}),
    Title1 = utext:get(2830008),
    Content1 = utext:get(2830009),
    ?IF(BelongReward =/= [], lib_mail_api:send_sys_mail([RoleId], Title1, Content1, BelongReward), ok),
    Limit = data_sanctuary:get_kv(participant_reward_limit),
%%	sanctuary_participant_reward
    [begin
         Count = mod_daily:get_count_offline(TempRoleId, ?MOD_SANCTUARY, 4), %%获得归属奖励次数，
         if
             Count < Limit ->
%%				lib_goods_api:send_reward_with_mail(TempRoleId,
%%					#produce{reward = ParticipantReward, type = sanctuary_participant_reward}),
                 Title2 = utext:get(2830010),
                 Content2 = utext:get(2830011, [Count + 1, Limit - Count - 1]),
                 ?IF(ParticipantReward =/= [],
                     lib_mail_api:send_sys_mail([TempRoleId], Title2, Content2, ParticipantReward), ok),
                 mod_daily:increment_offline(TempRoleId, ?MOD_SANCTUARY, 4);
             true ->
                 ok
         end
     end
        ||
        #mon_atter{id = TempRoleId} <- T].

get_belong_reward() ->
    Reward = data_sanctuary:get_kv(belonger_reward),
    if
        Reward == [] ->
            [];
        true ->
            {Res, _W} = util:find_ratio(Reward, 2),
            Res
    end.


get_participant_reward() ->
    Reward = data_sanctuary:get_kv(participant_reward),
    if
        Reward == [] ->
            [];
        true ->
            {Res, _W} = util:find_ratio(Reward, 2),
            Res
    end.