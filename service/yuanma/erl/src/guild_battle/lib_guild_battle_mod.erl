%%%--------------------------------------
%%% @Module  : lib_guild_battle_mod
%%% @Author  : zengzy 
%%% @Created : 2017-10-03
%%% @Description:  公会战（大乱斗）
%%%--------------------------------------
-module(lib_guild_battle_mod).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("guild_battle.hrl").
-include("guild.hrl").
-include("goods.hrl").
-include("language.hrl").
-include("activitycalen.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("relationship.hrl").
-include("buff.hrl").

-compile(export_all).

%%--------------------------------------- call -----------------------------

%%获取排行前N的公会
get_top_guilds(Rank, State) ->
    #guild_battle_state{rank_list=Guildlist} = State,
    SortList = lists:keysort(2,Guildlist),
    TmpList = lists:sublist(SortList, Rank),
    ReplyList = get_top_guilds_help(TmpList,[]),
    {reply, ReplyList, State}.

get_top_guilds_help([],Result) -> lists:reverse(Result);
get_top_guilds_help([{GuildId,Rank,GuildName,_ChiefId,_ChiefName,_Score,_PowerRank,_Own}|T], Result) ->
    get_top_guilds_help(T,[{Rank,GuildId,GuildName}|Result]).

%%--------------------------------------- cast -----------------------------
%% gm开启预告
gm_start_tip(State) ->
    util:send_after([],1*1000,self(),'start_battle'),
    %%发传闻
    lib_chat:send_TV({all_guild}, ?MOD_GUILD_BATTLE, ?GUILD_BATTLE_LANGUAGE_1, []),
    put({mod_guild_battle,start_tip},?START),
    %%先初始化战场
    {ok,Pid} = mod_guild_battle_fight:init(),
    NewState = State#guild_battle_state{room_pid = Pid},
    {noreply, NewState}.  

%%gm开启预告
gm_end_battle(State) ->
    #guild_battle_state{ref_end = Ref,room_pid = RoomPid} = State,
    util:cancel_timer(Ref),
    %%通知战场结束
    case is_pid(RoomPid) == true of 
        true ->
            mod_guild_battle_fight:end_fight(RoomPid);
        _ -> skip
    end,
    put({mod_guild_battle,start_tip},?NOT_START),
    %%关闭图标
    lib_activitycalen_api:success_end_activity(?MOD_GUILD_BATTLE),
    %% 告诉全部玩家活动开启
    {ok, Bin} = pt_505:write(50520, [?NOT_START]),
    lib_server_send:send_to_all(Bin),
    NewState = State#guild_battle_state{state = ?NOT_START, room_pid = none},
    {noreply, NewState}.

%% 检测开启活动
% timer_check(State)->
%     case data_activitycalen:get_ac(?MOD_GUILD_BATTLE,0,0) of
%         [] -> skip;
%         #base_ac{module=Module} = Data ->
%             case Module > 0 of
%                 true-> timer_check_help(State,Data);
%                 false->skip
%             end
%     end.

% timer_check_help(_State,Data) ->
%     %TodayMerge = util:get_merge_day(),%%当前合服第几天
%     %TodayOpen = util:get_open_day(),  %%当前开服第几天
%     OpenType = get({mod_guild_battle,start_tip}),
%     NowTime     = utime:unixtime(),
%     NowWeek     = utime:day_of_week(),
%     #base_ac{ week = Week, time_region = OpenTime } = Data,
%     if
%         %%合服或者开服第一天开
%         % OpenType=:=?NOT_START andalso (TodayMerge==1 orelse TodayOpen==1) ->
%         %     Res = check_time_to_start({NowTime,OpenType},OpenTime,false),
%         %     ?IF(
%         %         Res==true,
%         %         mod_guild_battle:start_tip(),
%         %         skip
%         %     );
%         OpenType =/= ?NOT_START -> skip;
%         Week =:= [] andalso OpenTime=:=[] -> skip;
%         Week =:= [] ->
%             Res = check_time_to_start({NowTime,OpenType},OpenTime,false),
%             ?IF(
%                 Res==true,
%                 mod_guild_battle:start_tip(),
%                 skip
%             );
%         Week =/= [] ->
%             case lists:member(NowWeek,Week) andalso check_time_to_start({NowTime,OpenType},OpenTime,false) of
%                 true->
%                      mod_guild_battle:start_tip();
%                 false->
%                     skip
%             end;            
%         true->
%             skip
%     end.

% %% 检测是否开启
% check_time_to_start(_,_,true) -> true;
% check_time_to_start(_,[],Result) -> Result;
% check_time_to_start({NowTime,OpenType},[{{STime,StartMinTime},{ETime,EndMinTime}}|T],Result) ->
%     StartTime = format_time(STime,StartMinTime)-?REF_START*60,
%     EndTime = format_time(ETime,EndMinTime),    
%     case NowTime>=StartTime andalso NowTime<EndTime andalso OpenType=:=?NOT_START of
%         true->
%             check_time_to_start(1,1,true);
%         false->
%             check_time_to_start({NowTime,OpenType},T,Result)
%     end.

% %% 转成当天时间戳
% format_time(H,M) ->
%     utime:unixdate() + H*3600+ M*60.

%% 初始化进程
init()->
    case util:get_merge_day() of
        1 -> %% 合服第一天合服要把连胜奖励和终结奖励发给所属公会，并把数据库数据删除
            do_init(merge);
        _ ->
            do_init(normal)
    end.

do_init(normal) ->
    case lib_guild_battle:db_guild_rank_select() of
        [] ->
            GuildRank = [];
        List ->
            GuildRank = guild_rank_help(List,[])
    end,
    case lib_guild_battle:db_role_rank_select() of
        [] ->
            RoleRank = [];
        RList ->
            RoleRank = [{RoleId,GuildId,Score,KillNum,Rank}||[RoleId,GuildId,Score,KillNum,Rank]<-RList]
    end,
    case lib_guild_battle:db_winner_select() of 
        [] -> Winner = 0, LastWinner = 0, WinNum = 0, RewardType = 0, RewardKey = 0, RewardOwner = 0;
        [Winner, LastWinner, WinNum, RewardType, RewardKey, RewardOwner] -> ok
    end,
    put({mod_guild_battle,start_tip},?NOT_START),
    _State = #guild_battle_state{
        state = ?NOT_START,
        winner = Winner,
        last_winner = LastWinner,
        win_num = WinNum,
        reward_type = RewardType,
        reward_key = RewardKey,
        reward_owner = RewardOwner,
        rank_list = GuildRank,
        rank_role = RoleRank
    };
do_init(merge) ->
    guild_battle_reset(),
    _State = #guild_battle_state{
        state = ?NOT_START
    }.

guild_battle_reset() ->
    %% 移除对应Buff
    lib_goods_buff:db_remove_goods_buff(?BUFF_GWAR_DOMINATOR),
    lib_guild_battle:db_guild_rank_delete(),
    lib_guild_battle:db_role_rank_delete(),
    lib_guild_battle:db_winner_delete().


%% 组合公会排名
guild_rank_help([],Result) -> Result;
guild_rank_help([[GuildId,Rank,_GuildName,ChiefId,Score,PowerRank,Own_B]|T],Result) ->
    Figure = lib_role:get_role_figure(ChiefId),
    ChiefName = Figure#figure.name,
    NGuildName = Figure#figure.guild_name,
    Own = util:bitstring_to_term(Own_B),
    NewResult = [{GuildId,Rank,NGuildName,ChiefId,ChiefName,Score,PowerRank,Own}|Result],
    guild_rank_help(T,NewResult).

%% 组合玩家排名
role_rank_help([],Result) -> Result;
role_rank_help([{RoleId, GuildId, Score, KillNum, Rank}|T],Result) ->
    Figure = lib_role:get_role_figure(RoleId),
    Name = Figure#figure.name,
    GuildName = Figure#figure.guild_name,
    NewResult = [{RoleId, Name, GuildId, GuildName, Score, KillNum, Rank}|Result],
    role_rank_help(T, NewResult);
role_rank_help([{RoleId, RoleName, GuildId, GuildName, Score, KillNum, Rank}|T], Result) ->
    NewResult = [{RoleId, RoleName, GuildId, GuildName, Score, KillNum, Rank}|Result],
    role_rank_help(T, NewResult).

% 活动主界面请求排名
send_guild_battle_show(GuildId,CreateTime,RoleId,Sid,State) ->
    #guild_battle_state{winner = Winner, win_num = WinNum, reward_type = RewardType, reward_key = RewardKey, reward_owner = RewardOwner, rank_list = GuildList} = State,
    Now = utime:unixtime(),
    NeedTime = ?DAILYREWARD_NEEDTIME,
    case lists:keyfind(Winner, 1, GuildList) of
        false -> ChiefId = 0, ChiefFigure = #figure{};
        {_GuildId, _Rank, _GuildName, ChiefId, _ChiefName, _Score, _PowerRank, _Own} -> ChiefFigure = lib_role:get_role_figure(ChiefId)
    end,
    case GuildId == Winner andalso Winner > 0 andalso Now - CreateTime >= NeedTime of 
        true ->
            Count = mod_daily:get_count(RoleId, ?MOD_GUILD_BATTLE, 1),
            Res = ?IF(Count > 0, 3, 1);
        _ ->
            Res = 2 
    end,
    %?PRINT("send_guild_battle_show ~p~n", [{Res, Winner, ChiefId, WinNum, RewardType, RewardOwner}]),
    {ok, BinData} = pt_505:write(50501, [Res, Winner, ChiefId, ChiefFigure, WinNum, RewardType, RewardKey, RewardOwner]), 
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply,State}.    

send_guild_battle_red_hot(GuildId, RoleId, Sid, Position, CreateTime, State) ->
    #guild_battle_state{winner = Winner, win_num = _WinNum, reward_type = RewardType, reward_owner = RewardOwner} = State,
    case GuildId == Winner andalso Winner > 0 of 
        true ->
            Now = utime:unixtime(),
            NeedTime = ?DAILYREWARD_NEEDTIME,
            Count = mod_daily:get_count(RoleId, ?MOD_GUILD_BATTLE, 1),
            Res = ?IF(Count == 0 andalso Now - CreateTime >= NeedTime, 1, 0),
            case Position == ?POS_CHIEF of 
                true ->
                    Res2 = ?IF(RewardOwner == 0 andalso RewardType > 0, 1, 0);
                _ ->
                    Res2 = 0
            end,
            {ok, Bin} = pt_505:write(50500, [[{1, Res}, {2, Res2}]]),
            lib_server_send:send_to_sid(Sid, Bin);
        _ ->
            {ok, Bin} = pt_505:write(50500, [[{1, 0}, {2, 0}]]),
            lib_server_send:send_to_sid(Sid, Bin)
    end,
    {noreply,State}.    

%% 玩家排行榜
send_role_rank(_RoleId, Sid, State) ->
    #guild_battle_state{state = StateType, rank_role=RankList} = State,   
    case StateType == ?NOT_START of
        true ->
            List = role_rank_help(RankList,[]),
            %?PRINT("~p~n",[List]),
            {ok, BinData} = pt_505:write(50514, [List]), 
            lib_server_send:send_to_sid(Sid, BinData),
            {noreply, State#guild_battle_state{rank_role = List}};
        _ ->
            {ok, BinData} = pt_505:write(50514, [[]]), 
            lib_server_send:send_to_sid(Sid, BinData),
            {noreply, State}
    end.

%% 公会排行榜
send_guild_rank(_RoleId, MyGuildId, Sid, State) ->
    #guild_battle_state{rank_list = GuildList} = State,   
    List = [ {GuildId, Rank, GuildName, Score, PowerRank, Own} || {GuildId, Rank, GuildName, _ChiefId, _ChiefName, Score, PowerRank, Own} <- GuildList],
    %?PRINT("send_guild_rank List ~p~n", [List]),
    {ok, BinData} = pt_505:write(50506, [MyGuildId, List]), 
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State}.

%% 开启预告
start_tip(State) ->
    %%发传闻
    lib_chat:send_TV({all_guild}, ?MOD_GUILD_BATTLE, ?GUILD_BATTLE_LANGUAGE_1, []),
    %%x分钟后开启活动定时器
    %util:send_after([],?REF_START*60*1000,self(),'start_battle'),
    %%先初始化战场
    {ok,Pid} = mod_guild_battle_fight:init(),
    put({mod_guild_battle,start_tip},?START),
    NewState = State#guild_battle_state{room_pid = Pid},
    {noreply, NewState}.

%% 开启活动
start_battle(State) ->
    #guild_battle_state{room_pid = Pid} = State,
    Now = utime:unixtime(),
    EndTime = Now+?ACT_TIME*60,
    GuildIds = get_guild_list(),
    GuildList = init_guild(GuildIds),
    Ref = util:send_after([],?ACT_TIME*60*1000,self(),'end_battle'),
    %%初始化战场公会
    ?PRINT("start_battle ~p~n", [{GuildIds, EndTime}]),
    mod_guild_battle_fight:start(Pid, GuildIds, EndTime),
    % 广播所有玩家 活动开始
    %lib_activitycalen_api:success_start_activity(?MOD_GUILD_BATTLE),
    %% 告诉全部玩家活动开启
    {ok, Bin} = pt_505:write(50520, [?START]),
    lib_server_send:send_to_all(Bin),
    NewState = State#guild_battle_state{
        state = ?START,
        ref_end = Ref,
        start_time = Now,
        end_time = EndTime,
        guild_list = GuildList,
        role_list = []
    },
    % ?PRINT("state:~p~n",[NewState]),
    {noreply, NewState}.

%% 公会默认全参加
init_guild(GuildIds)->
    F = fun({GuildId,_,_},TList)->
        [{GuildId,[]}|TList]
    end,
    _GuildList = lists:foldl(F,[],GuildIds).

%% 活动结束
end_battle(State) ->
    #guild_battle_state{room_pid = RoomPid, ref_end = ORefEnd} = State,
    util:cancel_timer(ORefEnd),
    ?PRINT("end_battle ~p~n", [RoomPid]),
    %%通知战场结束
    mod_guild_battle_fight:end_fight(RoomPid),
    put({mod_guild_battle,start_tip},?NOT_START),
    %% 告诉全部玩家活动开启
    {ok, Bin} = pt_505:write(50520, [?NOT_START]),
    lib_server_send:send_to_all(Bin),
    %%关闭图标
    lib_activitycalen_api:success_end_activity(?MOD_GUILD_BATTLE),
    NewState = State#guild_battle_state{state = ?NOT_START, room_pid = none, guild_list = [], role_list = []},
    {noreply, NewState}.

%% 断线重连
login(Role,X,Y,State) ->
    #role{role_id = RoleId, guild_id = GuildId} = Role,
    #guild_battle_state{state = StateType, room_pid = RoomPid, role_list = RoleList} = State,
    case StateType == ?START andalso misc:is_process_alive(RoomPid) of
        true->
            BuffId = get_role_buff(State, GuildId),
            NewRoleList = [RoleId|lists:delete(RoleId,RoleList)],
            mod_guild_battle_fight:relogin_send_info(RoomPid,Role,X,Y,BuffId);
        false-> 
            NewRoleList = RoleList,
            lib_scene:player_change_default_scene(RoleId, [])
    end,
    {noreply,State#guild_battle_state{role_list = NewRoleList}}.

%% 检测是否推送积分
% check_send_score(RoleId,State) ->
%     #guild_battle_state{state = StateType, room_pid = RoomPid, role_list = RoleList} = State,
%     IsEnter = lists:member(RoleId,RoleList),
%     case StateType == ?START andalso misc:is_process_alive(RoomPid) andalso IsEnter == true of
%         true->
%             mod_guild_battle_fight:send_score(RoomPid,RoleId);
%         false-> skip
%     end,
%     {noreply,State}.    

%% 新公会加入
add_new_guild(GuildId,GuildName,ChiefId,State) ->
    #guild_battle_state{guild_list = GuildList, state = StateType, room_pid = RoomPid} = State,
    case StateType == ?START of
        true->  
            NewGuildList = [{GuildId,[]}|GuildList],
            %%通知战场
            mod_guild_battle_fight:add_new_guild(RoomPid,GuildId,GuildName,ChiefId),
            NewState = State#guild_battle_state{guild_list = NewGuildList};
        false->
            NewState = State
    end,
    {noreply,NewState}.

role_login(RoleId, GuildId, State) ->
    %?PRINT("role login === ~n", []),
    #guild_battle_state{winner = Winner} = State,
    case Winner == GuildId of 
        true -> lib_guild_battle:add_chief_buff(RoleId); 
        _ -> ok
    end,
    {noreply, State}.

%% 换会长
change_chief(GuildId, ChiefId, Name, State) ->
    #guild_battle_state{rank_list = RankList, state = StateType, winner = Winner} = State,
    case StateType == ?NOT_START of
        true->  
            case lists:keyfind(GuildId,1,RankList) of
                false -> NewState = State;
                {GuildId,Rank,GuildName,OldChiefId,_OldChiefName,Score,PowerRank,Own} ->
                    case GuildId == Winner of 
                        true ->
                            lib_guild_battle:add_chief_buff(ChiefId),
                            lib_guild_battle:delete_chief_buff(OldChiefId);
                        _ -> ok
                    end,
                    Sql = io_lib:format(?sql_guild_rank_update_chief,[ChiefId,GuildId]),
                    db:execute(Sql),
                    NewRankList = lists:keyreplace(GuildId,1,RankList,{GuildId,Rank,GuildName,ChiefId,Name,Score,PowerRank,Own}),
                    NewState = State#guild_battle_state{rank_list=NewRankList}
            end;
        false->
            NewState = State
    end,
    {noreply,NewState}.    

%% 分配奖励
allocate_reward(ChiefId, GuildId, GuildName, RoleId, RoleName, State) ->
    #guild_battle_state{
        state = StateType, winner = Winner, last_winner = LastWinner, win_num = _WinNum, reward_type = RewardType, 
        reward_key = RewardKey, reward_owner = RewardOwner
    } = State,
    if 
        StateType =/= ?NOT_START -> Errcode = ?ERRCODE(err505_war_is_openning), NewState = State;
        GuildId /= Winner -> Errcode = ?ERRCODE(err505_not_winner), NewState = State;
        RewardOwner /= 0 -> Errcode = ?ERRCODE(err505_reward_is_alloc), NewState = State;
        RewardType == 0 orelse RewardKey =< 1 -> Errcode = ?ERRCODE(err505_no_alloc_reward), NewState = State;
        true ->
            Errcode = ?SUCCESS,
            WorldLv = util:get_world_lv(),
            WinNum = ?IF(RewardKey > 50, 50, RewardKey),
            [WinReward, BreakReward] = data_guild_battle:get_streak_reward(WorldLv, WinNum),
            Reward = ?IF(RewardType == 1, WinReward, BreakReward),
            lib_log_api:log_guild_war_allot_reward(GuildId, GuildName, RoleId, 1, RewardType, Reward),
            case RewardType of 
                1 -> %% 连胜奖励
                    Title = utext:get(5050007),
                    Content = utext:get(5050008),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 连胜分配结果邮件
                    Title1 = utext:get(5050009),
                    Content1 = utext:get(5050010, [RewardKey, RoleName]),
                    mod_guild:send_guild_mail_by_guild_id(GuildId, Title1, Content1, [], [RoleId, ChiefId]);
                _ -> %% 终结奖励
                    Title = utext:get(5050003),
                    Content = utext:get(5050004),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 终结分配结果邮件
                    LastWinnerName = mod_guild:get_guild_name(LastWinner),
                    Title1 = utext:get(5050005),
                    Content1 = utext:get(5050006, [LastWinnerName, RewardKey, RoleName]),
                    mod_guild:send_guild_mail_by_guild_id(GuildId, Title1, Content1, [], [RoleId, ChiefId])
            end,
            NewState = State#guild_battle_state{reward_owner = RoleId},
            lib_guild_battle:db_winner_replace(NewState)
    end,
    ?PRINT("allocate_reward == ~p~n", [Errcode]),
    {ok, Bin} = pt_505:write(50518, [Errcode]),
    lib_server_send:send_to_uid(ChiefId, Bin),
    {noreply, NewState}.

%% 进入
enter(Role,State) ->
    #guild_battle_state{
        guild_list = GuildList, role_list = RoleList, room_pid = RoomPid
    } = State,
    #role{role_id = RoleId, sid = Sid, guild_id = GuildId} = Role,
    case length(RoleList) >= ?FIGHT_TOP_NUM of
        true->
            %%场景参加人数满
            Errcode = ?ERRCODE(err505_ac_enough_role),
            NewState = State;
        false->
            case lists:keyfind(GuildId,1,GuildList) of
                false-> Errcode = ?FAIL,NewState = State;
                {_,List} -> 
                    case length(List) >= ?GUILD_TOP_NUM of
                        true-> 
                            %%公会参加人数满
                            Errcode = ?ERRCODE(err505_guild_enough_role),
                            NewState = State;
                        false->
                            Errcode = ?SUCCESS,
                            %%添加零时技能
                            %%lib_skill_api:add_tmp_skill_list(RoleId,?SKILL_ID,1),
                            %NewRole = get_leave_info(Role,LeaveRole),
                            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_GUILD_BATTLE,  0), %%通知活动日历参与了活动
                            BuffId = get_role_buff(State, GuildId),
                            mod_guild_battle_fight:enter(RoomPid, Role, BuffId),
                            NewRoleList = [RoleId|RoleList],
                            NewGuildList = lists:keyreplace(GuildId,1,GuildList,{GuildId,[RoleId|List]}),
                            NewState = State#guild_battle_state{guild_list = NewGuildList, role_list = NewRoleList}
                    end
            end
    end,
    ?PRINT("errcode ~p~n",[Errcode]),
    {ok, Bin} = pt_505:write(50503, [Errcode, 1]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, NewState}.

%% 退出
quit(Role,State) ->
    #guild_battle_state{ state = StateType,guild_list = GuildList, role_list = RoleList, room_pid = RoomPid} = State,
    #role{role_id = RoleId, guild_id = GuildId} = Role,
    case misc:is_process_alive(RoomPid) andalso StateType == ?START of
        true->
            mod_guild_battle_fight:quit(RoomPid,RoleId),
            NewRoleList = lists:delete(RoleId,RoleList),
            case lists:keyfind(GuildId,1,GuildList) of
                false-> NewGuildList = GuildList;
                {_,List}->
                    NewList = lists:delete(RoleId,List),
                    NewGuildList = lists:keyreplace(GuildId,1,GuildList,{GuildId,NewList})
            end,
            NewState = State#guild_battle_state{guild_list = NewGuildList, role_list = NewRoleList};
        false-> NewState = State
    end,
    {noreply, NewState}.

%% 保存玩家退出信息
save_leave_role(Role,State) ->
    #guild_battle_state{leave_role = LeaveRole} = State,
    #role{role_id = RoleId} = Role,
    case lists:keyfind(RoleId,1,LeaveRole) of
        {RoleId,_TmpRole}->
            NewLeaveRole = lists:keyreplace(RoleId,1,LeaveRole,{RoleId,Role});
        false->
            NewLeaveRole = [{RoleId,Role}|LeaveRole]
    end,
    NewState = State#guild_battle_state{leave_role = NewLeaveRole},
    {noreply,NewState}.

%% 保存公会排名
refresh_guild_rank(RankList,State) ->
    %% 更新并发放公会奖励(连胜，霸主，终结连胜)
    NewState = update_and_send_guild_reward(State, RankList),
    %%更新新排行榜
    spawn(fun()-> 
        %%删除旧排行榜
        lib_guild_battle:db_guild_rank_delete(),
        lib_guild_battle:db_insert_guild_rank(RankList),
        mod_daily:daily_clear_module(?MOD_GUILD_BATTLE, 1)
        %send_red_hot_to_guild(NewState)
    end),
    {noreply,NewState}.

update_and_send_guild_reward(State, RankList) ->
    #guild_battle_state{winner = OldWinner, win_num = WinNum} = State,
    case lists:keyfind(1, 2, RankList) of 
        false -> Winner = 0, _GuildName = <<>>, ChiefId = 0;
        {GuildId, 1, _GuildName, ChiefId, _ChiefName, _Score, _PowerRank, _Own} -> Winner = GuildId
    end,
    NewState = case Winner > 0 of 
        true ->
            %% 霸主奖励
            [BattleReward, _] = lib_guild_battle:get_battle_reward(),
            Title = utext:get(5050001),
            Content = utext:get(5050002),
            lib_mail_api:send_sys_mail([ChiefId], Title, Content, BattleReward),
            GuildMemberList = mod_guild:get_guild_member_id_list(Winner),
            %% 连胜奖励和终结奖励
            case OldWinner == Winner of 
                true -> %% 连胜
                    NewWinner = Winner, LastWinner = Winner, NewWinNum = WinNum + 1, NewRewardType = 1, NewRewardKey = NewWinNum;
                _ when OldWinner == 0 -> %% 上次没有霸主
                    lib_guild_battle:add_chief_buff(ChiefId),
                    NewWinner = Winner, LastWinner = 0, NewWinNum = 1, NewRewardType = 0, NewRewardKey = 0;
                _ -> %% 终结
                    ?IF(WinNum >= 2, lib_achievement_api:guild_battle_break_win(GuildMemberList), ok),
                    lib_guild_battle:delete_guild_chief_buff(OldWinner),
                    lib_guild_battle:add_chief_buff(ChiefId),
                    {NewRewardType, NewRewardKey} = ?IF(WinNum >= 2, {2, WinNum}, {0, 0}),
                    NewWinner = Winner, LastWinner = OldWinner, NewWinNum = 1
            end,
            lib_achievement_api:guild_battle_win_achievement(GuildMemberList),
            %% 公会争霸运营活动
            mod_custom_act_gwar:guild_war_end(Winner, utime:unixtime()),
            State#guild_battle_state{winner = NewWinner, last_winner = LastWinner, win_num = NewWinNum, reward_type = NewRewardType, reward_key = NewRewardKey, reward_owner = 0, rank_list = RankList};
        _ -> 
            %% 没有胜者，清楚旧霸主的buff
            case OldWinner > 0 of 
                true -> lib_guild_battle:delete_guild_chief_buff(OldWinner);
                _ -> skip
            end,
            State#guild_battle_state{winner = 0, last_winner = 0, win_num = 0, reward_key = 0, reward_type = 0, reward_owner = 0, rank_list = RankList}
    end,
    %?PRINT("update_and_send_guild_reward ~p~n", [NewState]),
    lib_guild_battle:db_winner_replace(NewState),
    NewState.

send_red_hot_to_guild(State) ->
    #guild_battle_state{winner = Winner, win_num = _WinNum, reward_type = RewardType, rank_list = GuildList} = State,
    case lists:keyfind(Winner, 1, GuildList) of
        false -> ChiefId = 0;
        {_GuildId, _Rank, _GuildName, ChiefId, _ChiefName, _Score, _PowerRank, _Own} -> ok
    end,
    case Winner > 0 of 
        true ->
            {ok, Bin} = pt_505:write(50500, [[{1, 1}]]),
            lib_server_send:send_to_guild(Winner, Bin),
            RewardHotRed = ?IF(RewardType == 0, 0, 1),
            {ok, Bin2} = pt_505:write(50500, [[{1, 1}, {2, RewardHotRed}]]),
            lib_server_send:send_to_uid(ChiefId, Bin2);
        _ ->
            ok 
    end.

%% 保存玩家排名
refresh_role_rank(RankList,State) ->
    NewState = State#guild_battle_state{rank_role = RankList},
    %%更新新排行榜
    spawn(fun()-> 
        %%删除旧排行榜
        lib_guild_battle:db_role_rank_delete(),
        lib_guild_battle:db_insert_role_rank(RankList) 
    end),
    %% 发送个人排名奖励
    spawn(fun() ->
        send_role_rank_reward(RankList, 0)
    end),
    {noreply,NewState}.

send_role_rank_reward([], _) -> ok;
send_role_rank_reward(RankList, 10) ->
    timer:sleep(300),
    send_role_rank_reward(RankList, 0);
send_role_rank_reward([{RoleId, _RoleName, _GuildId, _GuildName, _Score, _KillNum, Rank}|RankList], Num) ->
    case data_guild_battle:get_role_rank_reward(Rank) of 
        [] -> ok;
        Reward ->
            Title = utext:get(5050011),
            Content = utext:get(5050012, [Rank]),
            %lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
            Produce = #produce{type = guild_battle, reward = Reward, off_title = Title, off_content = Content, remark = "rank_reward"},
            lib_goods_api:send_reward_with_mail(RoleId, Produce),
            send_role_rank_reward(RankList, Num+1)
    end.

%% 获取上次离开数据
get_leave_info(Role,LeaveRole) ->
    #role{role_id = Id} = Role,
    %%判断获取上次退出前的杀怪和领取奖励状态
    case lists:keyfind(Id,1,LeaveRole) of
        false -> NewRole = Role;
        {Id,TmpRole} -> 
            #role{score = Score, total_kill_num = TotalKillNum, kill_num = KillNum, be_kill_num = BeKillNum, got_reward = GotReward,resource = Resource} = TmpRole,
            NewRole = Role#role{score = Score, total_kill_num = TotalKillNum, kill_num = KillNum, be_kill_num = BeKillNum, got_reward = GotReward, resource = Resource}
    end,
    NewRole.

get_role_buff(State, GuildId) ->
    #guild_battle_state{
        winner = OldWinner, win_num = WinNum
    } = State,
    case OldWinner == GuildId of 
        true -> 0;
        _ ->
            data_guild_battle:get_buff_id(WinNum)
    end.

%%获取开启公会
get_guild_list() ->
    GuildMaps = mod_guild:get_all_guild(),
    NeedLv = 1,
    case is_map(GuildMaps) of
        true->
            TmpList = maps:values(GuildMaps),
            %%按公会排名排序
            FSort = fun(GuildA, GuildB) ->
                #guild{id = GuildIdA, lv = GuildLvA} = GuildA,
                #guild{id = GuildIdB, lv = GuildLvB} = GuildB,
                if
                    GuildLvA > GuildLvB -> true;
                    GuildLvA == GuildLvB -> GuildIdA < GuildIdB;
                    true -> false
                end
            end,
            TmpGuildList = lists:sort(FSort, TmpList),
            F = fun(#guild{id=GuildId, name = GuildName, lv=Lv, chief_id = ChiefId},List)->
                case Lv >= NeedLv of
                    true->
                        %%获取公会id
                        [{GuildId,GuildName,ChiefId}|List];
                    false->
                        List
                end 
            end,
            GuildIds = lists:foldl(F,[],TmpGuildList),
            lists:reverse(GuildIds);
        false->
            []
    end.    

%%更新ps领取状态
% change_ps_status(RoleList,Now) ->
%     spawn(
%         fun()->
%             [
%             begin
%                 lib_guild_battle:db_role_replace(Id,Now),
%                 lib_player:apply_cast(Id, ?APPLY_CAST_STATUS, ?MODULE, change_ps_status_help, [Now])
%             end
%             ||Id<-RoleList]
%         end
%     ).

% change_ps_status_help(PS,Now) ->
%     #player_status{id = RoleId} = PS,
%     GuildBattle = #guild_battle_status{daily_reward_time = Now},
%     %%通知去除领取奖励红点
%     lib_guild_battle_fight:send_to_all(50502,[RoleId],[1]),
%     PS#player_status{guild_battle = GuildBattle}.

%%发送公会传闻
send_guild_TV(GuildIds, Type, Msg) ->
    F = fun(GuildId)->
        lib_chat:send_TV({guild, GuildId},?MOD_GUILD_BATTLE,Type,Msg)
    end,
    lists:map(F,GuildIds).

%% 发送定时事件
send_event_after(OldRef, Time, Event) ->
    util:cancel_timer(OldRef),
    erlang:send_after(Time,self(),Event).

