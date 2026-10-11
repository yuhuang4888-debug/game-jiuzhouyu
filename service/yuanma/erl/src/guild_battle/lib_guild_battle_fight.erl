%%%--------------------------------------
%%% @Module  : lib_guild_battle_fight
%%% @Author  : zengzy 
%%% @Created : 2017-10-03
%%% @Description:  公会战（大乱斗）
%%%--------------------------------------
-module(lib_guild_battle_fight).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild_battle.hrl").
-include("goods.hrl").
-include("language.hrl").
-include("activitycalen.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("relationship.hrl").

-compile(export_all).

%%初始化战场
init()->
    % 小怪直接放地图，不用功能创建
    % create_mon(),
    %% 地图刷小怪
    mod_scene_init:reload_scene_mon(?GUILD_BATTLE_ID,0,self(),1),
    %%据点创建
    OwnList = create_own_location(),
    #guild_battle_fight_state{own_list=OwnList}.

%%刷怪(小怪直接放地图，不用功能创建)
% create_mon()->
%     AutoIds = data_guild_battle:get_birth_and_mon_list(?MON_TYPE),
%     Args = [{group, ?GROUP_MON},{mod_args,?NORMAL_MON_TYPE}],
%     F = fun(Id)->
%         #birth_config{sub_type=_SubType,mon_id=MonId,location=Location} = data_guild_battle:get_birth_and_mon(Id),
%         common_create_mon(MonId,Args,Location,?MON_NUM,[])
%     end,
%     lists:map(F,AutoIds).

%%创建据点
create_own_location()->
    AutoIds = data_guild_battle:get_own_list(),
    F = fun(MonId,TList)->
        #base_guild_battle_own{type=Type,location=Location} = data_guild_battle:get_own(MonId),
        case Type == ?KING_TYPE of 
            true-> Args = [{group, ?GROUP_MON},{mod_args,?KING_MON_TYPE},{be_att_limit, []}];
            false-> Args = [{group, ?GROUP_MON},{mod_args,?OWN_MON_TYPE}]
        end,
        [AutoId] = common_create_mon(MonId,Args,Location,1,[]),
        Own = #own{id = AutoId, mon_id = MonId},
        [Own|TList]
    end,
    lists:foldl(F,[],AutoIds).

%%初始化公会
start(GuildList,EndTime,State) ->
    NewGuildList = init_guild_location(GuildList),
    RankRef = send_event_after([],?REF_TIME*1000,{broadcast_guild_rank}),
    OwnRef = send_event_after([],?REF_TIME*1000,{send_own_list}),
    LangRef = send_event_after([],?REF_LANGUAGE_TIME*1000,{send_language}),
    InOwnRef = send_event_after([], 3*1000, {in_own_add_score}),
    NewState = State#guild_battle_fight_state{end_time = EndTime, guild_list = NewGuildList, ref_rank = RankRef, ref_own = OwnRef, ref_lanuage = LangRef, ref_in_own = InOwnRef},
    %?PRINT("start NewState ~p~n", [NewState]),
    {noreply,NewState}.

%%分配公会出生点
init_guild_location(GuildList) ->
    AutoIds = data_guild_battle:get_birth_and_mon_list(?BIRTY_TYPE),
    Tids = lists:sort(AutoIds),
    %%前面已经按公会排名排了序
    F = fun({GuildId,GuildName,ChiefId},{TmpGList,TmpTList,TmpLen,TmpGroup})->
        Id = urand:list_rand(TmpTList),
        Guild = #guild_info{power_rank = TmpLen, group = TmpGroup, id=GuildId, name = GuildName, birth = Id, chief_id = ChiefId},
        case length(TmpTList) =< 1 of
            true-> {[Guild|TmpGList],Tids,TmpLen+1,TmpGroup+1};
            false-> {[Guild|TmpGList],lists:delete(Id,TmpTList),TmpLen+1,TmpGroup+1}
        end
    end,
    {LastGuildList,_,_,_} = lists:foldl(F,{[],Tids,1,10},GuildList),
    LastGuildList.

%%增加新公会
add_new_guild(GuildId,GuildName,ChiefId, State) ->
    #guild_battle_fight_state{guild_list = GuildList} = State,
    AutoIds = data_guild_battle:get_birth_and_mon_list(?BIRTY_TYPE),
    Id = urand:list_rand(AutoIds),
    Length = length(GuildList),
    NewGuild = #guild_info{power_rank = Length+1, group = Length+10+1, id=GuildId, name = GuildName, birth = Id, chief_id = ChiefId},
    NewGuildList = [NewGuild|GuildList],
    NewState = State#guild_battle_fight_state{guild_list = NewGuildList},
    {noreply,NewState}.

%%结束活动
end_fight(State) ->
    #guild_battle_fight_state{rank_list = GuildList, role_map = RoleMaps, own_list = OwnList} = State,
    SortGuildList = sort_guild_rank(GuildList,OwnList),
    SortRoleList = sort_role_rank(RoleMaps),
    %% 推送结束界面
    send_over_show(SortRoleList, SortGuildList),
    %% 推送全服公告
    case SortGuildList =/= [] of
        true->
            #guild_info{name=GuildName} = hd(SortGuildList),
            lib_chat:send_TV({all},?MOD_GUILD_BATTLE,?GUILD_BATTLE_LANGUAGE_9,[GuildName]);
        false->
            skip
    end, 
    Now = utime:unixtime(),
    %% 记录玩家积分日志
    %add_role_log(SortRoleList),
    %% 计算个人奖励并邮件发放
    F = fun(RoleId, Role, _Acc) ->
        %%兑换奖励
        case Role#role.is_leave == 0 of 
            true ->
                {_,Reward} = get_role_reward(Role),
                case Reward =/= [] of
                    true->
                        %%加日志
                        add_role_log(Role,Reward,Now),
                        %%发送邮件
                        Title = utext:get(5050013),
                        Content = utext:get(5050014),
                        lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                        1;                   
                    false-> 0
                end;
            _ -> 0
        end      
    end,
    maps:fold(F, 0, RoleMaps),
    %% 计算公会奖励
    %send_guild_reward(SortGuildList),
    %% 保存公会排名排行榜
    refresh_guild_rank(SortGuildList),
    %% 保存个人排行榜
    refresh_role_rank(SortRoleList),
    %% 清理场景的据点
    % OwnIds = data_guild_battle:get_own_list(),
    % lib_mon:clear_scene_mon_by_mids(?GUILD_BATTLE_ID,0,self(),1,OwnIds), 
    Pid = self(),
    spawn(fun() -> 
        leave_scene(RoleMaps),
        timer:sleep(5*1000),
        lib_scene:clear_scene_room(?GUILD_BATTLE_ID, 0, Pid)
    end),   
    {stop, normal, State}.

%%断线重连发送场景消息
relogin_send_info(Role, X, Y, BuffId, State) ->
    #guild_battle_fight_state{role_map = RoleMap, rank_list = GuildList} = State,
    #role{role_id = RoleId, sid = Sid, guild_id = GuildId, war_figure = WarFigure} = Role,
    OldRole = maps:get(RoleId, RoleMap, 0),
    %%推送场景信息
    %send_scene_info(NewRole,State),
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false -> NewState = State;
        _ when OldRole == 0 -> NewState = State;
        #guild_info{birth = Birth,own = Own}->
            NewRole = OldRole#role{sid = Sid, war_figure = WarFigure, is_leave = 0},
            #role{group = Group} = NewRole,
            CopyId = self(),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild_battle, change_scene, [Birth, Own, CopyId, X, Y, Group, BuffId, false]),
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            NewState = State#guild_battle_fight_state{role_map = NewRoleMap}
    end,
    {noreply, NewState}.

%%进入
enter(Role, BuffId, State) ->
    #guild_battle_fight_state{guild_list = GuildList, rank_list = RankList, role_map = RoleMap, own_list = OwnList} = State,
    #role{role_id = RoleId, sid = Sid, guild_id = GuildId, war_figure = WarFigure} = Role,
    case lists:keyfind(GuildId,#guild_info.id, GuildList) of
        false-> NewState = State;
        #guild_info{birth = Birth, group = Group} = Guild ->
            OldRole = maps:get(RoleId, RoleMap, 0),
            NewRole = ?IF(OldRole == 0, Role#role{group = Group}, OldRole#role{sid = Sid, war_figure = WarFigure, is_leave = 0}),
            if
                OldRole == 0 ->
                    %% 触发成就
                    lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_war_join_event, 1);
                true ->
                    skip
            end,
            case lists:keyfind(GuildId, #guild_info.id, RankList) of
                false -> 
                    Own = [],
                    enter_scene(RoleId, BuffId, Group, Birth, Own, ?BIRTY_TYPE),
                    RoleList = [RoleId],
                    NewGuild = Guild#guild_info{role_list = RoleList},
                    NewRankList = sort_guild_rank([NewGuild|RankList],OwnList);
                #guild_info{own = Own, role_list = RoleList} = RankGuild->
                    ?IF(
                        Own == [],
                        enter_scene(RoleId, BuffId, Group, Birth, [], ?BIRTY_TYPE),
                        enter_scene(RoleId, BuffId, Group, Birth, Own, ?OWN_MON_TYPE)
                    ),
                    IsExits = lists:member(RoleId,RoleList),
                    %%把玩家id存起来
                    NewGuild = ?IF(
                        IsExits,
                        RankGuild,
                        RankGuild#guild_info{role_list = [RoleId|RoleList]}
                    ),
                    NewRankList = lists:keyreplace(GuildId, #guild_info.id, RankList, NewGuild)
            end,
            TmpState = State#guild_battle_fight_state{rank_list = NewRankList},
            %send_scene_info(NewRole, TmpState),
            NewRoleMap = maps:put(RoleId, NewRole, RoleMap),
            %?PRINT("enter NewRankList : ~p~n", [NewRankList]),
            NewState = TmpState#guild_battle_fight_state{role_map = NewRoleMap}
    end,
    {noreply, NewState}.

%%退出
quit(RoleId,State)->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    Role = maps:get(RoleId,RoleMap,[]),
    case Role =/= [] of
        true->
            %NewIdList = [Role|lists:keydelete(RoleId,#role.role_id,IdList)],
            %%兑换奖励
            {StageList,RewardList} = get_role_reward(Role),
            #role{got_reward = OldReward} = Role,
            NewReward = OldReward ++ StageList,
            %%保存退出玩家信息
            %%mod_guild_battle:save_leave_role(Role#role{got_reward=NewReward}),
            leave_scene(#{RoleId => Role}),
            NewRoleMap = maps:put(RoleId, Role#role{got_reward = NewReward, is_leave = 1}, RoleMap),
            case RewardList =/= [] of
                true->
                    %%加日志
                    add_role_log(Role,RewardList,utime:unixtime()),
                    %发送邮件
                    Title = utext:get(5050013),
                    Content = utext:get(5050014),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);                
                false-> 
                    ok
            end,
            ?PRINT("quit RoleId : ~p~n", [RoleId]),
            NewState = State#guild_battle_fight_state{role_map = NewRoleMap};
        false->
            NewState = State
    end,
    {noreply,NewState}.

%%切换场景
enter_scene(RoleId, BuffId, Group, Birth, Own, Type) when Type == ?BIRTY_TYPE ->
    ?PRINT("~p~n",[Birth]),
    #base_guild_battle_birth{location = Location} = data_guild_battle:get_birth_and_mon(Birth),
    [{Xmin,Xmax},{Ymin,Ymax}] = Location,
    X = urand:rand(Xmin,Xmax),
    Y = urand:rand(Ymin,Ymax),
    CopyId = self(),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild_battle, change_scene, [Birth, Own, CopyId, X, Y, Group, BuffId, true]);
enter_scene(RoleId, BuffId, Group, Birth, Own, Type) when Type == ?OWN_MON_TYPE ->
    %?PRINT("~p~n",[Own]),
    Id = urand:list_rand(Own),
    #base_guild_battle_own{location=[{X,Y}]} = data_guild_battle:get_own(Id),
    CopyId = self(),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_guild_battle, change_scene, [Birth, Own, CopyId, X, Y, Group, BuffId, true]);
enter_scene(_,_,_,_,_,_)->
    skip.

leave_scene(RoleMaps) ->
    F = fun(RoleId, #role{is_leave = IsLeave}, {Acc, List}) ->
        case IsLeave == 0 of 
            true ->
                AccTmp = Acc+1, ListTmp = [RoleId|List],
                case AccTmp >= 20 of 
                    true ->
                        lib_guild_battle:change_to_main(ListTmp),
                        timer:sleep(500),
                        {0, []};
                    _ ->
                        {AccTmp, ListTmp}
                end; 
            _ -> {Acc, List}
        end
    end,
    {_, LeftList} = maps:fold(F, {0, []}, RoleMaps),
    lib_guild_battle:change_to_main(LeftList).

%%发送玩家积分
send_score(State, [RoleId]) ->    
    #guild_battle_fight_state{role_map = RoleMap} = State,
    Role = maps:get(RoleId,RoleMap,#role{}),
    send_role_score(Role),
    {noreply,State}.

%% 领取奖励
send_stage_reward(StageId, RoleId,State) ->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    Role = maps:get(RoleId,RoleMap,[]),
    case Role =/= [] of
        true->
            #role{sid = _Sid, score = Score, got_reward = RewardList} = Role,
            [{NeedScore,Reward}] = get_role_reward_cfg(StageId), 
            case lists:member(StageId,RewardList) of
                true-> 
                    send_to_all(50509, #{RoleId => Role}, [?ERRCODE(err505_has_got),StageId]), 
                    NewRole = Role;
                false->
                    case Score>= NeedScore of
                        true-> 
                            %?PRINT("send_stage_reward  succ ~n", []),
                            %%加日志
                            add_role_log(Role,Reward,utime:unixtime()),
                            Produce = #produce{type=guild_battle,reward=Reward,show_tips=3},
                            %%发送奖励
                            lib_goods_api:send_reward_by_id(Produce,RoleId),
                            send_to_all(50509, #{RoleId => Role}, [?SUCCESS,StageId]), %加提示
                            NewRole = Role#role{got_reward = [StageId|RewardList]};                      
                        false-> 
                            send_to_all(50509, #{RoleId => Role}, [?ERRCODE(err505_condition_not_enough),StageId]), 
                            NewRole = Role
                    end
            end,  
            NewRoleMap = maps:put(RoleId,NewRole,RoleMap),
            NewState = State#guild_battle_fight_state{role_map = NewRoleMap};                    
        false->
            NewState = State
    end,
    {noreply,NewState}.    

send_role_rank(State, [RoleId, Sid]) ->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    #role{score = _MyScore, total_kill_num = _MyKillNum} = maps:get(RoleId, RoleMap, #role{}),
    case get({?MODULE, role_rank}) of 
        {Time, InfoList} when NowTime =< Time+1 -> ok;
        _ ->
            F = fun(Id, #role{name=RoleName, guild_id = GuildId, guild_name=GuildName, score=Score, total_kill_num=TotalKillNum, role_rank = RoleRank}, List) ->
                case Score >0 orelse TotalKillNum > 0 of 
                    true -> [{Id, RoleName, GuildId, GuildName, Score, TotalKillNum, RoleRank}|List];
                    _ -> List
                end
            end,
            InfoList = maps:fold(F, [], RoleMap),
            put({?MODULE, role_rank}, {NowTime, InfoList})
    end,
    %?PRINT("send_role_rank : ~p~n", [InfoList]),
    {ok, Bin} = pt_505:write(50514, [InfoList]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, State}.

convene_guild_member(State, [GuildId, RoleId, MonId]) ->
    #guild_battle_fight_state{role_map = RoleMap, rank_list = GuildList, own_list = OwnList} = State,
    case lists:keyfind(GuildId, #guild_info.id, GuildList) of 
        #guild_info{role_list = RoleIdList} ->
            case lists:keyfind(MonId, #own.mon_id, OwnList) of 
                #own{} ->
                    {ok, Bin} = pt_505:write(50517, [MonId]),
                    F = fun(RoleId1) ->
                        case RoleId1 == RoleId of 
                            true -> ok;
                            _ ->
                                case maps:get(RoleId1, RoleMap, 0) of 
                                    #role{sid = Sid, is_leave = 0} ->
                                        lib_server_send:send_to_sid(Sid, Bin);
                                    _ -> ok
                                end
                        end
                    end,
                    lists:foreach(F, RoleIdList);
                _ -> ok
            end;
        _ -> ok
    end,
    {noreply, State}.

%%使用战场技能
use_battle_skill(RoleId,State) ->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    Role = maps:get(RoleId,RoleMap,[]),
    case Role == [] of
        true-> Errcode = ?FAIL,NewState = State;
        false->
            #role{resource = Resource} = Role,
            case Resource >= ?SKILL_REDUCE of
                true->
                    Errcode = ?SUCCESS,
                    NewResocue = Resource - ?SKILL_REDUCE,
                    NewRole = Role#role{resource = NewResocue},
                    NewRoleMap = maps:put(RoleId,NewRole,RoleMap),
                    NewState = State#guild_battle_fight_state{role_map = NewRoleMap};
                false-> 
                    Errcode = ?ERRCODE(err505_resource_not_enough), 
                    NewState = State
            end
    end,
    %?PRINT("errcode is~p~n",[Errcode]),
    send_to_all(50510, #{RoleId => Role}, [Errcode]),
    {noreply,NewState}.

%%怪物死亡处理
kill_mon(MonInfo, AtterId, State) -> 
    #guild_battle_fight_state{role_map = RoleMap} = State,
    #scene_object{mon=Mon, mod_args=Type} = MonInfo,    
    #scene_mon{mid=MonId} = Mon,    
    Role = maps:get(AtterId,RoleMap,[]),
    case Role == [] of
        true-> NewState = State;
        false->
            #role{guild_id = GuildId, resource = OldResource, group = Group} = Role,
            if
                Type == ?OWN_MON_TYPE ->
                    FirstScore = data_guild_battle:get_score_info(?OWN_MON_TYPE),
                    TmpState = own_add_score(State,GuildId,FirstScore),
                    NewState = own_change_belong(TmpState,MonId,GuildId,Group);
                Type == ?KING_MON_TYPE ->
                    FirstScore = data_guild_battle:get_score_info(?KING_MON_TYPE),
                    TmpState = own_add_score(State,GuildId,FirstScore),
                    NewState = own_change_belong(TmpState,MonId,GuildId,Group);
                true ->
                    AddScore = data_guild_battle:get_score_info(?NORMAL_MON_TYPE),
                    NewResource = OldResource + 0,%?KILL_MON_RESOURCE,
                    LastResource = NewResource,%?IF(NewResource>=?SKILL_REDUCE,?SKILL_REDUCE,NewResource),
                    TmpRole = Role#role{resource = LastResource},
                    NewRole = add_score(TmpRole,AddScore),
                    NewRoleMap = maps:put(AtterId,NewRole,RoleMap),
                    TmpState = own_add_guild_score(State,GuildId,AddScore),
                    NewState = TmpState#guild_battle_fight_state{role_map = NewRoleMap}
            end
    end,
    {noreply,NewState}.

%%玩家死亡处理
kill_player(AtterId, RoleId, State) ->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    Role = maps:get(AtterId,RoleMap,[]),
    case Role == [] of
        true-> NewState = State;
        false ->
            %% 更新被杀者信息
            DieRole = maps:get(RoleId,RoleMap,#role{}),
            #role{role_id = DieId, name=DieName,be_kill_num = BeKillNum} = DieRole,
            %%判断是否存在该玩家并重置杀人数
            RoleMapTmp = ?IF(DieId == RoleId, maps:put(RoleId,DieRole#role{kill_num = 0,be_kill_num = BeKillNum+1},RoleMap), RoleMap),
            AddScore = data_guild_battle:get_score_info(?PLAYER_TYPE),
            #role{guild_id = GuildId, name = Name, kill_num = KillNum,total_kill_num = TotalNum } = Role,
            TmpRole = Role#role{kill_num = KillNum +1,total_kill_num = TotalNum +1},
            NewRole = add_score(TmpRole,AddScore),
            NewRoleMap = maps:put(AtterId, NewRole, RoleMapTmp),
            %% 连杀广播
            broadcast_killer_info(NewRole, NewRoleMap),
            %%判断发送杀人传闻
            % MaxNum = lists:max(?KILL_PLAYER_NUM),
            % case KillNum +1 > MaxNum  of 
            %     true-> send_TV(NewRoleMap,?GUILD_BATTLE_LANGUAGE_4,[Name]);
            %     false-> 
            %         ?IF(
            %             lists:member(KillNum +1,?KILL_PLAYER_NUM),
            %             send_TV(NewRoleMap,?GUILD_BATTLE_LANGUAGE_3,[Name,KillNum +1]),
            %             ok
            %         )
            % end,       
            %%判断是否第一滴血
            case get({mod_guild_battle_fight,first_kill}) of
                true-> skip;
                _ -> 
                    put({mod_guild_battle_fight,first_kill},true),
                    %%发送第一滴血传闻
                    send_TV(NewRoleMap,?GUILD_BATTLE_LANGUAGE_10,[Name,DieName])
            end,
            TmpState = own_add_guild_score(State,GuildId,AddScore),
            NewState = TmpState#guild_battle_fight_state{role_map = NewRoleMap}
    end,
    {noreply,NewState}.

broadcast_killer_info(Role, RoleMap) ->
    #role{role_id = RoleId, name = RoleName, war_figure = WarFigure, kill_num = KillNum} = Role,
    #war_figure{sex = Sex, realm = Realm, career = Career, lv = Lv, picture = Picture, picture_ver = PictureVer} = WarFigure,
    case KillNum >= ?KILL_PLAYER_LIMIT of 
        true ->
            send_to_all(50519, RoleMap, [RoleId, RoleName, Sex, Realm, Career, Lv, Picture, PictureVer, KillNum]);
        _ ->
            ok
    end.

%% 
hurt_mon_change(MonInfo, AtterId,State) ->
    #guild_battle_fight_state{own_list = OwnList, role_map = RoleMap} = State,
    #scene_object{battle_attr = #battle_attr{hp = Hp, hp_lim=HpLim}, mon = #scene_mon{mid = MonId},mod_args=Type} = MonInfo,
    %增加造成伤害玩家积分
    AddScore = ?IF(
        Type == ?OWN_MON_TYPE,
        data_guild_battle:get_score_info(?HURT_OWN_TYPE),
        data_guild_battle:get_score_info(?HURT_KING_TYPE)
    ),   
    case maps:get(AtterId,RoleMap,[]) of
        []-> NewState = State;
        #role{guild_id = GuildId} = Role ->
            NewRole = add_score(Role,AddScore),
            NewMap = maps:put(AtterId,NewRole,RoleMap),
            TState = own_add_guild_score(State,GuildId,AddScore),
            NewState = TState#guild_battle_fight_state{role_map = NewMap}
    end,
    case lists:keyfind(MonId,#own.mon_id,OwnList) of
        false-> LastState = NewState;
        #own{} = Own ->
            NewOwn = Own#own{hp=Hp,hp_lim = HpLim},
            NewOwnList = lists:keyreplace(MonId,#own.mon_id,OwnList,NewOwn),
            LastState = NewState#guild_battle_fight_state{own_list = NewOwnList}
    end,
    %%增加据点血量变化标志
    put({mod_guild_battle_fight,own_change},true),
    {noreply,LastState}.

%%检测增加据点工会积分
check_own_add_guild_score(GuildId,MonId,State) ->
    #guild_battle_fight_state{own_list = OwnList} = State,
    case lists:keyfind(MonId,#own.mon_id,OwnList) of
        false-> NewState = State;
        #own{guild_id = TmpGuildId, ref = ORef} = Own ->
            #base_guild_battle_own{guild_add_score = AddScore} = data_guild_battle:get_own(MonId),
            %%判断是否还属于该工会的归属权
            NewState = case TmpGuildId == GuildId of
                true->
                    Ref = util:send_after(ORef, ?OWN_ADD_TIME*1000, self(), {own_add_guild_score,GuildId,MonId}),
                    NewOwnList = lists:keyreplace(MonId, #own.mon_id, OwnList, Own#own{ref = Ref}),
                    own_add_guild_score(State#guild_battle_fight_state{own_list = NewOwnList}, GuildId, AddScore);
                false->
                    State
            end
    end,
    {noreply,NewState}.

%%检查是否推送公会排名
broadcast_guild_rank(State) ->
    #guild_battle_fight_state{role_map = RoleMap, ref_rank = RankRef, rank_list = GuildList, own_list = OwnList} = State,
    %%判断是否要推送
    case get({mod_guild_battle_fight,guild_change}) of
        true->
            put({mod_guild_battle_fight,guild_change},false),
            NewGuildList = sort_guild_rank(GuildList,OwnList),
            %%推送排名
            send_guild_rank_to_all(RoleMap,NewGuildList,[]);
        _-> NewGuildList = GuildList
    end,
    NewRef = send_event_after(RankRef,?REF_TIME*1000,{broadcast_guild_rank}),
    NewState = State#guild_battle_fight_state{ref_rank = NewRef, rank_list = NewGuildList},
    {noreply,NewState}.

%%检查是否推送据点列表
check_send_own_list(State) ->
    #guild_battle_fight_state{role_map = RoleMap, ref_own = OwnRef, rank_list = GuildList, own_list = OwnList} = State,
    %%判断是否要推送
    case get({mod_guild_battle_fight,own_change}) of
        true->
            put({mod_guild_battle_fight,own_change},false),
            %%推送据点列表
            send_own_list_do(RoleMap,OwnList,GuildList);
        _-> ok
    end,
    NewRef = send_event_after(OwnRef,?REF_TIME*1000,{send_own_list}),
    NewState = State#guild_battle_fight_state{ref_own = NewRef},
    {noreply,NewState}.

%%发送场景循环传闻
send_language(State) ->
    #guild_battle_fight_state{role_map = RoleMap, ref_lanuage = LangRef, language = Language} = State,
    if
        Language == 0  -> NewLanguage = ?GUILD_BATTLE_LANGUAGE_5;
        Language == ?GUILD_BATTLE_LANGUAGE_5 -> NewLanguage = ?GUILD_BATTLE_LANGUAGE_6;
        Language == ?GUILD_BATTLE_LANGUAGE_6 -> NewLanguage = ?GUILD_BATTLE_LANGUAGE_7;
        Language == ?GUILD_BATTLE_LANGUAGE_7 -> NewLanguage = ?GUILD_BATTLE_LANGUAGE_5;
        %Language == ?GUILD_BATTLE_LANGUAGE_8 -> NewLanguage = ?GUILD_BATTLE_LANGUAGE_5;
        true -> NewLanguage = Language
    end,
    send_TV(RoleMap,NewLanguage,[]),
    NewLangRef = send_event_after(LangRef,?REF_LANGUAGE_TIME*1000,{send_language}),
    NewState = State#guild_battle_fight_state{ref_lanuage = NewLangRef, language = NewLanguage},
    {noreply,NewState}.

%%据点参战加积分
in_own_add_score(State) ->
    #guild_battle_fight_state{in_own = InList,ref_in_own = Ref} = State,
    Now = utime:unixtime(),
    F = fun({{Id,MonId},InTime},TState)->
        case Now - InTime >= ?OWN_ADD_TIME of
            true-> 
                own_join_add_score(Id,MonId,Now,TState);
            false->
                TState
        end
    end,
    TmpState = lists:foldl(F,State,InList),
    %%每S执行一次
    NewRef = send_event_after(Ref, 3*1000, {in_own_add_score}),
    NewState = TmpState#guild_battle_fight_state{ref_in_own = NewRef},
    {noreply,NewState}.

%进入退出据点
step_own_change(RoleId, MonId, Type, State) ->
    NewState = ?IF(
        Type == 1,
        step_in_own(RoleId, MonId,State),
        step_out_own(RoleId, MonId,State)
    ),
    {noreply,NewState}.

%%进入据点
step_in_own(RoleId, MonId,State) ->
    #guild_battle_fight_state{role_map = RoleMap, in_own = InList, own_list = OwnList} = State,
    Key = {RoleId,MonId},
    IsExits = lists:keyfind(Key,1,InList),
    Now = utime:unixtime(),
    Role = maps:get(RoleId,RoleMap,[]),
    case Role =/= [] andalso IsExits == false of
        true->
            #role{guild_id = _GuildId} = Role,
            case lists:keyfind(MonId,#own.mon_id,OwnList) of
                false-> NewState = State;
                #own{guild_id = _Guild} -> %%去除判断
                    % case Guild == GuildId of
                    %     true->
                            NewInList = [{Key,Now}|InList],
                            %?PRINT("step_in_own NewInList  ~p~n",[NewInList]),
                            NewState = State#guild_battle_fight_state{in_own = NewInList}
                    %     false-> NewState = State
                    % end
            end;
        false -> NewState = State
    end,
    NewState.

%%步出据点
step_out_own(RoleId, MonId,State) ->
    #guild_battle_fight_state{in_own = InList} = State,
    Key = {RoleId,MonId},
    NewInList = lists:keydelete(Key,1,InList),
    %?PRINT("step_out_own NewInList  ~p~n",[NewInList]),
    State#guild_battle_fight_state{in_own = NewInList}.

%%据点归属权变更
own_change_belong(State,MonId,GuildId,Group) ->
    #guild_battle_fight_state{role_map = RoleMap, rank_list = GuildList,own_list = OwnList} = State,
    case lists:keyfind(MonId,#own.mon_id,OwnList) of
        false-> 
            OldGuildId = 0, 
            NewOwnList = OwnList, 
            LastGuildList = GuildList, 
            NewState = State;
        #own{guild_id = OldGuildId} ->
            NewOwnList = create_new_own(MonId, GuildId, OwnList, Group),
            %%移除归属权
            NewGuildList = ?IF(OldGuildId>0,own_change_remove_belong(OldGuildId,GuildList,MonId),GuildList),
            %%增加归属权
            LastGuildList = own_change_add_belong(RoleMap,GuildId,NewGuildList,MonId,OldGuildId),
            NewState = State#guild_battle_fight_state{own_list = NewOwnList,rank_list = LastGuildList}
    end,
    %%切换玩家ps的复活点
    spawn(fun()-> change_revive(LastGuildList,MonId,GuildId,OldGuildId) end),
    %%推送据点列表信息
    send_own_list_do(RoleMap,NewOwnList,GuildList),
    update_king_mon_att_limit(NewState),
    %?PRINT("own_change_belong ~p~n", [NewOwnList]),
    NewState.

%%添加据点归属权
own_change_add_belong(RoleMap,GuildId,GuildList,MonId,OldGuildId) ->
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false-> NewGuildList = GuildList,GuildName = <<>>;
        #guild_info{name=GuildName,own=OldOwn} = Guild-> 
            NewGuild = Guild#guild_info{own=[MonId|lists:delete(MonId,OldOwn)]},
            % ?INFO("~p~n",[NewGuild]),
            NewGuildList = lists:keyreplace(GuildId,#guild_info.id,GuildList,NewGuild)
    end,
    #mon{name=MonName} = data_mon:get(MonId),
    send_to_all(50513, RoleMap, [MonId, GuildId]),
    %%判断是否第一占领
    case OldGuildId > 0 of
        true-> 
            %%发送传闻
            send_TV(RoleMap,?GUILD_BATTLE_LANGUAGE_2,[GuildName,MonName]);
        _ -> 
            %%发送第一占领传闻
            send_TV(RoleMap,?GUILD_BATTLE_LANGUAGE_11,[GuildName,MonName])
    end,
    NewGuildList.

%%移除据点归属权
own_change_remove_belong(GuildId,GuildList,MonId) ->  
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false-> NewGuildList = GuildList;
        #guild_info{own=OldOwn} = Guild-> 
            NewGuild = Guild#guild_info{own=lists:delete(MonId,OldOwn)},
            % ?INFO("~p~n",[NewGuild]),
            NewGuildList = lists:keyreplace(GuildId,#guild_info.id,GuildList,NewGuild)
    end,  
    NewGuildList.

update_king_mon_att_limit(State) ->
    #guild_battle_fight_state{rank_list = GuildList, own_list = OwnList} = State,
    F = fun(#guild_info{id=GuildId, own=GuildCamp}, List) ->
        case GuildCamp =/= [] of 
            true -> [GuildId|List];
            _ -> List
        end
    end,
    BeAttLimit = lists:foldl(F, [], GuildList),
    F1 = fun(#own{id = AId, mon_id = MonId}) ->
            #base_guild_battle_own{type = Type} = data_guild_battle:get_own(MonId),
            case Type == ?KING_TYPE of 
                true-> lib_scene_object:change_attr_by_ids(?GUILD_BATTLE_ID, 0, [AId], [{be_att_limit, BeAttLimit}]);
                false-> ok
            end
    end,
    lists:foreach(F1, OwnList).

%%修改玩家复活点
change_revive(GuildList,MonId,GuildId,OldGuildId) ->
    #base_guild_battle_own{type = Type} = data_guild_battle:get_own(MonId),
    case Type == ?KING_TYPE of
        true-> ok;
        false->
            %%修改新占据公会的玩家复活点
            change_role_revive(GuildList,GuildId),
            %%修改旧占据公会的玩家复活点
            change_role_revive(GuildList,OldGuildId)           
    end.

change_role_revive(GuildList,GuildId) when GuildId >0 ->
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false -> skip;
        #guild_info{birth = Birth, own = Own, role_list = RoleList}->
            [
                lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, lib_guild_battle, change_ps_revive, [Birth,Own])
                ||
                Id<-RoleList
            ]
    end;
change_role_revive(_GuildList,_GuildId) ->
    skip.

%%据点参站加积分
own_join_add_score(RoleId, MonId, Now, State) ->
    #guild_battle_fight_state{role_map = RoleMap, in_own = InList, own_list = OwnList} = State,
    Role = maps:get(RoleId,RoleMap,[]),
    Key = {RoleId,MonId},
    %?PRINT("own_join_add_score ~p~n",[InList]),
    case lists:keyfind(MonId,#own.mon_id,OwnList) of
        false-> 
            NewState = State;
        #own{guild_id = _Gid} ->
            case is_record(Role,role) of
                true->
                    #role{guild_id = GuildId} = Role,
                    % case GuildId == Gid of
                    %     true-> 
                            NewList = lists:keyreplace(Key,1,InList,{Key,Now}),
                            #base_guild_battle_own{role_add_score = AddScore} = data_guild_battle:get_own(MonId),
                            NewRole = add_score(Role,AddScore),
                            NewRoleMap = maps:put(RoleId,NewRole,RoleMap),
                            TmpState = own_add_guild_score(State,GuildId,AddScore),
                            NewState = TmpState#guild_battle_fight_state{in_own = NewList, role_map = NewRoleMap};
                    %     false-> 
                    %         %%移除出进入收益区
                    %         NewList = lists:keydelete(Key,1,InList),
                    %         NewState = State#guild_battle_fight_state{in_own = NewList}
                    % end;
                false-> 
                    %%移除出进入收益区
                    NewList = lists:keydelete(Key,1,InList),
                    NewState = State#guild_battle_fight_state{in_own = NewList}
            end
    end,
    NewState.

%%增加据点个人第一占领积分
own_add_score(State,GuildId,FirstScore) ->
    #guild_battle_fight_state{rank_list = GuildList} = State,
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false-> NewState = State;
        #guild_info{role_list = RoleList}->
            F = fun(Id,{TmpState,Num})->
                #guild_battle_fight_state{role_map = TmpMap} = TmpState,
                case maps:get(Id,TmpMap,[]) of
                    #role{is_leave = 0} = Role ->
                        NewRole = add_score(Role,FirstScore),
                        NewRoleMap = maps:put(Id,NewRole,TmpMap),
                        {TmpState#guild_battle_fight_state{role_map = NewRoleMap},Num+1};
                    _ -> {TmpState,Num}
                end
            end,
            {TState,AddNums} = lists:foldl(F,{State,0},RoleList),
            %%增加公会积分
            NewState = own_add_guild_score(TState,GuildId,AddNums*FirstScore)
    end,    
    NewState.

%%增加据点工会积分
own_add_guild_score(State,GuildId,AddScore) ->
    #guild_battle_fight_state{rank_list = GuildList} = State,
    case lists:keyfind(GuildId,#guild_info.id,GuildList) of
        false-> NewState = State;
        #guild_info{score = Score} = Guild->
            NewScore = Score + AddScore,
            NewGuild = Guild#guild_info{score = NewScore},
            %?PRINT("own_add_guild_score ~p~n",[NewGuild#guild_info.score]),
            %%增加积分变化标志
            put({mod_guild_battle_fight,guild_change},true),
            NewGuildList = lists:keyreplace(GuildId,#guild_info.id,GuildList,NewGuild),
            NewState = State#guild_battle_fight_state{rank_list = NewGuildList}
    end,    
    NewState.    

%% 增加积分
add_score(Role, AddScore)->
    #role{score = Score, got_reward = GotReward, has_send = HasSend} = Role,
    StageList = data_guild_battle:get_all_role_reward(),
    TmpList = StageList -- GotReward,
    LeftList = lists:sort(TmpList -- HasSend),
    NewScore = Score + AddScore,
    TmpRole = Role#role{score = NewScore},
    %%推送积分
    send_role_score(TmpRole),
    case LeftList == [] of
        true-> NewHasSend = HasSend;
        false->
            NextStage = hd(LeftList),
            [{NeedScore,_Reward}] = get_role_reward_cfg(NextStage),
            case NewScore >= NeedScore of
                true->  
                    send_reward_list(TmpRole),
                    NewHasSend = [NextStage|HasSend];
                false-> NewHasSend = HasSend
            end
    end,
    %?PRINT("add_score~p~n",[TmpRole#role.score]),
    TmpRole#role{has_send = NewHasSend}.

%%获取个人积分奖励
get_role_reward(Role)->
    #role{score = Score,got_reward = RewardList} = Role,
    List = data_guild_battle:get_all_role_reward(),
    F = fun(StageId,{TList,RList})->
            [{NeedScore,Reward}] = get_role_reward_cfg(StageId),
            case lists:member(StageId,RewardList) of
                true-> {TList,RList};
                false->
                    ?IF(
                        Score >= NeedScore,
                        {[StageId|TList], RList++Reward},
                        {TList,RList}
                    )
            end
    end,
    {StageList,Rewards} = lists:foldl(F,{[],[]},List),
    {StageList,Rewards}.

%% 计算公会奖励
% send_guild_reward(SortList) ->
%     List = data_guild_battle:get_all_guild_reward(),
%     Now = utime:unixtime(),
%     F = fun(I)->
%             [Reward] = data_guild_battle:get_guild_reward(I),
%             case lists:keyfind(I,#guild_info.rank,SortList) of
%                 false-> ok;
%                 #guild_info{id = GuildId,rank = Rank,role_list = RoleList} ->
%                     %%加日志
%                     add_rank_log(RoleList,GuildId,Reward,Now),
%                     %%发送邮件
%                     Title = utext:get(266),
%                     Content = uio:format(?LAN_MSG(267), [Rank]),
%                     lib_mail_api:send_sys_mail(RoleList, Title, Content, Reward),
%                     lib_guild_battle_mod:change_ps_status(RoleList,Now)              
%             end
%     end,
%     lists:map(F,List).

%% 获取个人积分奖励配置
get_role_reward_cfg(StageId) -> 
    data_guild_battle:get_role_reward(StageId).

%% 结束保存公会排名
refresh_guild_rank(GuildList)->
    Now = utime:unixtime(),
    List = refresh_guild_rank_help(GuildList,Now,[]),
    mod_guild_battle:refresh_guild_rank(List).

refresh_guild_rank_help([],_Now,Result) -> Result;
refresh_guild_rank_help([#guild_info{id = GuildId,rank=Rank,name=GuildName,score=Score,power_rank = PowerRank, chief_id=ChiefId, own=Own, role_list = RoleList}|T],Now,Result) ->
    Length = length(RoleList),
    lib_log_api:log_guild_battle(GuildId,Length,Score,Rank,Now),
    Figure = lib_role:get_role_figure(ChiefId),
    ChiefName = Figure#figure.name,
    refresh_guild_rank_help(T,Now,[{GuildId,Rank,GuildName,ChiefId,ChiefName,Score,PowerRank,Own}|Result]).

%% 结束保存玩家杀人排名
refresh_role_rank(SortRoleList) ->
    RoleInfoList = [ {RoleId, RoleName, GuildId, GuildName, Score, KillNum, Rank} || #role{role_id = RoleId, name = RoleName, guild_id = GuildId, guild_name = GuildName, score = Score, role_rank = Rank, total_kill_num = KillNum} <- SortRoleList],
    % NewList = refresh_role_rank_help(SortRoleList),
    % %%过滤被杀数为0的
    % BeKillList = [Role||Role<-List,Role#role.be_kill_num>0],
    % case lists:keysort(#role.be_kill_num,BeKillList) of
    %     [] -> LastRole = [];
    %     TmpList ->
    %         LastRole = lists:last(TmpList)
    % end,
    % %%被杀最多次发称号奖励
    % case is_record(LastRole,role) of
    %     true-> 
    %         Title = utext:get(298),
    %         Content = utext:get(299),
    %         lib_mail_api:send_sys_mail([LastRole#role.role_id], Title, Content, ?LAST_REWARD);
    %     false-> skip
    % end,
    mod_guild_battle:refresh_role_rank(RoleInfoList).

% refresh_role_rank_help([],_Rank,Result) -> Result;
% refresh_role_rank_help([#role{role_id=RoleId,total_kill_num=KillNum}|T],Rank,Result) ->
%     case data_guild_battle:get_designation_reward(Rank) of
%         [] -> false;
%         [Designation] ->
%             %%发送称号奖励邮件
%             Title = utext:get(296),
%             Content = utext:get(297, [KillNum,Rank]),
%             lib_mail_api:send_sys_mail([RoleId], Title, Content, Designation)
%     end,
%     refresh_role_rank_help(T,Rank-1,[{Rank,RoleId,KillNum}|Result]).

%%创建新据点
create_new_own(MonId, GuildId, OwnList, Group)->
    case lists:keyfind(MonId,#own.mon_id,OwnList) of
        false-> NewOwnList = OwnList;
        #own{ref = ORef} ->
            Ref = util:send_after(ORef, ?OWN_ADD_TIME*1000, self(), {own_add_guild_score, GuildId, MonId}),
            #base_guild_battle_own{type = Type,location=Location} = data_guild_battle:get_own(MonId),
            case Type == ?KING_TYPE of 
                true-> Args = [{group, Group},{mod_args,?KING_MON_TYPE},{be_att_limit, []}];
                false-> Args = [{group, Group},{mod_args,?OWN_MON_TYPE}]
            end,
            [AutoId] = common_create_mon(MonId,Args,Location,1,[]),
            NewOwn = #own{id = AutoId, mon_id = MonId,guild_id = GuildId, ref = Ref},
            NewOwnList = lists:keyreplace(MonId, #own.mon_id, OwnList, NewOwn)
    end,
    NewOwnList.

%%创建怪物
common_create_mon(_MonId,_Args,_Location,0,Result) ->  Result;
common_create_mon(MonId,Args,Location,Num,Result) ->
    {X,Y} = urand:list_rand(Location),
    AutoId = lib_mon:sync_create_mon(MonId,?GUILD_BATTLE_ID,0,X,Y,0,self(),1,Args),
    common_create_mon(MonId,Args,Location,Num-1,[AutoId|Result]).

%%公会排名排序
sort_guild_rank(GuildList,OwnList) ->
    [KingId] = data_guild_battle:get_own_type(?KING_TYPE),
    %%判断王者是否被占领
    case lists:keyfind(KingId,#own.mon_id,OwnList) of
        false ->
            sort_rank(GuildList);
        #own{guild_id = GuildId} ->
            case GuildId > 0 of
                true->
                    sort_rank_with_own(GuildList,GuildId);
                false-> 
                    sort_rank(GuildList)             
            end
    end.

sort_guild_rank_help([],_Rank,Result) -> Result;
sort_guild_rank_help([Guild|T],Rank,Result) ->
    sort_guild_rank_help(T,Rank-1,[Guild#guild_info{rank=Rank}|Result]).

%%按积分，按战力排名排（防止都为0）
keysort_rank(List) ->
    F = fun(GuildA,GuildB)->
        if
            GuildA#guild_info.score < GuildB#guild_info.score -> true;
            GuildA#guild_info.score > GuildB#guild_info.score -> false;
            GuildA#guild_info.power_rank > GuildB#guild_info.power_rank -> true;
            true ->
                false
        end
    end,
    Result = lists:sort(F,List),
    Result.

%%无据点排序
sort_rank(List) ->
    Length = length(List),
    TmpGuildList = keysort_rank(List),
    % TmpGuildList = lists:keysort(#guild_info.score,List),
    sort_guild_rank_help(TmpGuildList,Length,[]).

%%有据点排序
sort_rank_with_own(List,GuildId) ->
    Length = length(List),
    case lists:keyfind(GuildId,#guild_info.id,List) of
        false-> List;
        #guild_info{} = Info->
            TmpList = lists:keydelete(GuildId,#guild_info.id,List),
            % SortList = lists:keysort(#guild_info.score,TmpList),
            SortList = keysort_rank(TmpList),
            LastSortList = sort_guild_rank_help(SortList,Length,[]),
            NewInfo = Info#guild_info{rank = 1},
            [NewInfo|LastSortList]
    end.

%% 玩家排名
sort_role_rank(RoleMaps) ->
    RoleList = maps:values(RoleMaps),
    SortRoleList = keysort_role_rank(RoleList),
    sort_role_rank_helper(SortRoleList, 1, []).

sort_role_rank_helper([], _Rank, List) -> lists:reverse(List);
sort_role_rank_helper([Role|SortRoleList], Rank, List) ->
    sort_role_rank_helper(SortRoleList, Rank+1, [Role#role{role_rank = Rank}|List]).

keysort_role_rank(List)->
    F = fun(RoleA,RoleB)->
        if
            RoleA#role.total_kill_num > RoleB#role.total_kill_num -> true;
            RoleA#role.total_kill_num < RoleB#role.total_kill_num -> false;
            RoleA#role.score > RoleB#role.score -> true;
            true ->
                false
        end
    end,
    Result = lists:sort(F,List),
    Result.

%%发送场景信息
% send_scene_info(Role,State)->
%     #guild_battle_fight_state{end_time = EndTime, rank_list = GuildList, own_list = OwnList} = State,
%     #role{role_id = RoleId, guild_id = _GuildId} = Role,
%     %%发送剩余时间
%     send_to_all(50504, #{RoleId => Role}, [EndTime]),
%     %%发送个人积分
%     % send_role_score(Role),
%     %%发送奖励列表
%     send_reward_list(Role),
%     %%发送公会排名
%     send_guild_rank_do(Role,GuildList),
%     %%发送据点列表
%     send_own_list_do(#{RoleId => Role}, OwnList, GuildList).

send_war_endtime(State, [Sid]) ->
    #guild_battle_fight_state{end_time = EndTime} = State,
    {ok, Bin} = pt_505:write(50504, [EndTime]),
    ?PRINT("war end_time ~p~n", [EndTime]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, State}.

%%发送个人积分
send_role_score(Role) ->
    #role{role_id = RoleId, score = Score, resource = Resource} = Role,
    send_to_all(50512, #{RoleId => Role},[Score,Resource]).

%%发送奖励列表
send_reward_list(State, [RoleId]) ->
    #guild_battle_fight_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of 
        #role{is_leave = 0} = Role -> send_reward_list(Role);
        _ -> ok
    end,
    {noreply, State}.

%%发送奖励列表
send_reward_list(Role) ->
    #role{role_id = RoleId, score = Score, got_reward = RewardList} = Role,
    List = data_guild_battle:get_all_role_reward(),
    F = fun(StageId,TList)->
        [{NeedScore,_}] = get_role_reward_cfg(StageId),
        case lists:member(StageId,RewardList) of
            true-> [{StageId,NeedScore,3}|TList];
            false->
                ?IF(
                    Score >= NeedScore,
                    [{StageId,NeedScore,2}|TList],
                    [{StageId,NeedScore,1}|TList]
                )
        end
    end,
    SendList = lists:foldl(F,[],List),
    ?PRINT("send_reward_list ~p~n", [SendList]),
    send_to_all(50505, #{RoleId => Role}, [SendList]).

%%发送公会排名
send_guild_rank(State, [RoleId]) ->
    #guild_battle_fight_state{role_map = RoleMap, rank_list = GuildList} = State,
    case maps:get(RoleId, RoleMap, []) of 
        [] -> ok;
        Role ->
            send_guild_rank_do(Role, GuildList)
    end,
    {noreply, State}.

%%发送公会排名
send_guild_rank_do(Role,GuildList) ->
    SendList = send_guild_rank_help(GuildList,[]),
    send_guild_rank_core(Role, SendList).

send_guild_rank_help([],Result) -> Result;
send_guild_rank_help([#guild_info{id = GuildId,rank=Rank,name=GuildName,score=Score,power_rank=PowerRank,own=Own}|T],Result) ->
    send_guild_rank_help(T,[{GuildId,Rank,GuildName,Score,PowerRank,Own}|Result]).

send_guild_rank_core(Role, SendList) ->
    #role{sid = Sid, guild_id = GuildId} = Role,
    %?PRINT("send_guild_rank : ~p~n", [SendList]),
    {ok, Bin} = pt_505:write(50506, [GuildId, SendList]),
    lib_server_send:send_to_sid(Sid, Bin).

send_own_list(State, [RoleId]) ->
    #guild_battle_fight_state{role_map = RoleMap, rank_list = GuildList, own_list = OwnList} = State,
    case maps:get(RoleId, RoleMap, []) of 
        [] -> ok;
        Role ->
            send_own_list_do(#{RoleId => Role}, OwnList, GuildList)
    end,
    {noreply, State}.

%%发送据点列表50407
send_own_list_do(RoleMap, OwnList, GuildList)->
    F = fun(#own{mon_id=MonId,hp=Hp,hp_lim=HpLim,guild_id=GuildId},TList)->
        %%获取占领公会名字
        case GuildId >0 of
            true-> 
                case lists:keyfind(GuildId,#guild_info.id,GuildList) of
                    false-> Type = 1,GuildName = <<>>;
                    #guild_info{name=GuildName} -> Type = 2
                end;
            false-> Type = 1,GuildName = <<>>
        end,
        [{Type,GuildId,GuildName,MonId,Hp,HpLim}|TList]
    end,
    SendList = lists:foldl(F,[],OwnList),
    %?PRINT("send_own_list : ~p~n", [SendList]),
    send_to_all(50507, RoleMap, [SendList]). 

%%定时发送自己公会排名给场景所有人
send_guild_rank_to_all(RoleMap, GuildList, _Result) ->
    F = fun(_, Role, _Acc) ->
        case Role of 
            #role{sid = Sid, guild_id = GuildId, is_leave = 0} ->
                case lists:keyfind(GuildId, #guild_info.id, GuildList) of 
                    #guild_info{score = Score, rank = Rank} ->
                        {ok, Bin} = pt_505:write(50516, [GuildId, Rank, Score]),
                        lib_server_send:send_to_sid(Sid, Bin);
                    _ -> ok
                end,
                _Acc;
            _ -> _Acc
        end
    end,
    maps:fold(F, 0, RoleMap).

%% 推送结束界面
send_over_show(RoleList, GuildList) ->
    SendList = send_guild_rank_help(GuildList,[]),
    F = fun(Role) ->
        #role{sid = Sid, score = Score, guild_id = GuildId, role_rank = RoleRank, is_leave = IsLeave} = Role,
        case IsLeave == 0 of 
            true ->
                {ok, Bin} = pt_505:write(50511, [GuildId, Score, RoleRank, SendList]),
                lib_server_send:send_to_sid(Sid, Bin);
            _ -> ok
        end
    end,
    lists:foreach(F, RoleList).    

%%发送传闻
send_TV(RoleMaps, Type, Msg) ->
    BinData = lib_chat:make_tv(?MOD_GUILD_BATTLE, Type, Msg),
    F = fun(_, Role, Acc) ->
        case Role of 
            #role{sid = Sid, is_leave = 0} -> 
                lib_server_send:send_to_sid(Sid, BinData);
            _ -> ok
        end,
        Acc
    end,
    maps:fold(F, 0, RoleMaps).

%% 发送给所有玩家
send_to_all(Cmd, RoleMap, Args) ->
    {ok, BinData} = pt_505:write(Cmd, Args),
    F = fun(_, Role, Acc) ->
        case Role of 
            #role{sid = Sid, is_leave = 0} -> 
                lib_server_send:send_to_sid(Sid, BinData);
            _ -> ok
        end,
        Acc
    end,
    maps:fold(F, 0, RoleMap).

%% 发送定时事件
send_event_after(OldRef, Time, Event) ->
    util:cancel_timer(OldRef),
    erlang:send_after(Time,self(),Event).

% add_role_log(RoleList) ->
%     NowTime = utime:unixtime(),
%     F = fun(Role, LogList) ->
%         %%兑换奖励
%         #role{role_id = RoleId, guild_id = GuildId, score = Score, got_reward = RewardList} = Role,
%         {StageList, Reward} = get_role_reward(Role),
%         case Reward =/= [] of
%             true->
%                 %%发送邮件
%                 Title = utext:get(268),
%                 Content = utext:get(269),
%                 lib_mail_api:send_sys_mail([Role#role.role_id], Title, Content, Reward),
%                 [[RoleId, GuildId, Score, util:term_to_bitstring(RewardList++StageList), NowTime]|LogList];                   
%             false-> [[RoleId, GuildId, Score, util:term_to_bitstring(RewardList), NowTime]|LogList]
%         end          
%     end,
%     RoleLogList = lists:foldl(F, [], RoleList),
%     lib_log_api:log_guild_battle_role(RoleLogList).

%%加个人积分奖励日志
add_role_log(Role,Reward,Now) ->
    #role{role_id = RoleId, guild_id = GuildId, score=Score, got_reward = GotReward} = Role,
    F = fun(StageId,TReward)->
        [{_,Ward}] = get_role_reward_cfg(StageId),
        Ward ++ TReward
    end,
    TotalReward = lists:foldl(F,Reward,GotReward),
    lib_log_api:log_guild_battle_role(RoleId,GuildId,Score,TotalReward,Now).

%%加公会积分奖励日志
add_rank_log([],_GuildId,_Reward,_Now) -> ok;
add_rank_log([RoleId|T],GuildId,Reward,Now) ->
    lib_log_api:log_guild_battle_rank(RoleId,GuildId,Reward,Now),
    add_rank_log(T,GuildId,Reward,Now).


