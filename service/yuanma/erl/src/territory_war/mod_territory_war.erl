% %% ---------------------------------------------------------------------------
% %% @doc mod_territory_war
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(mod_territory_war).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("territory_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("guild.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("buff.hrl").
-include("predefine.hrl").
%%-----------------------------

%% 分组信息同步
sync_zone_group(_InfoList) -> 
    mod_zone_mgr:kf_terri_war_init().
    %gen_server:cast(?MODULE, {sync_zone_group, InfoList}).

%%%%%%%% 跨服调用的接口
reset_territory(AllZones) ->
    gen_server:cast(?MODULE, {reset_territory, AllZones}).

%% 服务器连接跨服
center_connected(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {center_connected, [ServerId, MergeSerIds]}).

async_guild_to_center(ServerId, TerriGuildList) ->
    gen_server:cast(?MODULE, {async_guild_to_center, ServerId, TerriGuildList}).

war_fight_end(Group, WarId, Winner) ->
    gen_server:cast(?MODULE, {war_fight_end, Group, WarId, Winner}).

handle_terri_war_winner(Group) ->
    gen_server:cast(?MODULE, {handle_terri_war_winner, Group}).

%% 创建战场
% start_create_war() ->
%     gen_server:cast(?MODULE, {start_create_war}).

%% 向游戏服获取参赛公会信息
async_divide_server_info_local(TerriServer) ->
    gen_server:cast(?MODULE, {async_divide_server_info_local, TerriServer}).

% sync_server_mode_local(TerriServer) ->
%     gen_server:cast(?MODULE, {sync_server_mode_local, TerriServer}).

% async_war_state_local(Msg) ->
%     gen_server:cast(?MODULE, {async_war_state_local, Msg}).

sync_server_data_local(Round, WarState, ReadyTime, StartTime, EndTime, TerriServer, MergeServerList) ->
    gen_server:cast(?MODULE, {sync_server_data_local, Round, WarState, ReadyTime, StartTime, EndTime, TerriServer, MergeServerList}).

sync_merge_server_data_local(Round, WarState, StartTime, EndTime, ServerId, MergeTerriServer) ->
    gen_server:cast(?MODULE, {sync_merge_server_data_local, Round, WarState, StartTime, EndTime, ServerId, MergeTerriServer}).

refresh_consecutive_win_local(DateId, TerriGroup) ->
    gen_server:cast(?MODULE, {refresh_consecutive_win_local, DateId, TerriGroup}).

sync_history_data_local(DateId, TerriGroup) ->
    gen_server:cast(?MODULE, {sync_history_data_local, DateId, TerriGroup}).

start_round_language(Round, Type) ->
    gen_server:cast(?MODULE, {start_round_language, Round, Type}).

%%% 进入战场
enter_war(TerriRole) ->
    gen_server:cast(?MODULE, {enter_war, TerriRole}).

leave_war(Msg) ->
    gen_server:cast(?MODULE, {leave_war, Msg}).

%% 选择领地
choose_terri_id(Msg) ->
    gen_server:cast(?MODULE, {choose_terri_id, Msg}).

%%% send_msg
send_territory_war_state(Msg) ->
    gen_server:cast(?MODULE, {send_territory_war_state, Msg}).

send_round_time_info(Msg) ->
    gen_server:cast(?MODULE, {send_round_time_info, Msg}).

send_territory_war_list(Msg) ->
    gen_server:cast(?MODULE, {send_territory_war_list, Msg}).

send_server_divide_info(Msg) ->
    gen_server:cast(?MODULE, {send_server_divide_info, Msg}).

send_territory_war_show(Msg) ->
    gen_server:cast(?MODULE, {send_territory_war_show, Msg}).

guild_qualification(Msg) ->
    gen_server:cast(?MODULE, {guild_qualification, Msg}).

is_qualification_call(RoleId, GuildId) ->
    gen_server:call(?MODULE, {is_qualification_call, RoleId, GuildId}, 1000).

allocate_reward(Msg) ->
    gen_server:cast(?MODULE, {allocate_reward, Msg}).

role_login(RoleId, GuildId) ->  
    gen_server:cast(?MODULE, {role_login, RoleId, GuildId}).

change_chief(GuildId, OldChiefId, ChiefId, Name) ->  
    gen_server:cast(?MODULE, {change_chief, GuildId, OldChiefId, ChiefId, Name}).

is_winner(GuildId) ->
    gen_server:call(?MODULE, {is_winner, GuildId}, 3000).

check_open(GuildId) ->
    gen_server:call(?MODULE, {check_open, GuildId}, 3000).

timer_check() ->
    gen_server:cast(?MODULE, {timer_check}).

gm_start(ReadyTimeGap, StartTimeGap) ->
    gen_server:cast(?MODULE, {gm_start, ReadyTimeGap, StartTimeGap}).

gm_start_2(StartTime, ReadyTime) ->
    gen_server:cast(?MODULE, {gm_start_2, StartTime, ReadyTime}).

%% cast and call
apply_cast(Fun, Msg) ->
    gen_server:cast(?MODULE, {apply_cast, Fun, Msg}).

apply_call(Fun, Msg) ->
    gen_server:call(?MODULE, {apply_call, Fun, Msg}, 3000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    IsCls = ?IF(util:is_cls(), 1, 0),
    State1 = #terri_state{is_cls = IsCls},
    State = lib_territory_war_mod:init(State1),
    %?PRINT("mod_territory_war init ~p~n", [State]),
    {ok, State}.

%% ====================
%% hanle_call
%% ==================== 
do_handle_call({is_winner, GuildId}, _From, State) ->
    #terri_state{consecutive_win = ConsecutiveWin} = State,
    Reply = ?IF(GuildId == ConsecutiveWin#consecutive_win.winner andalso GuildId > 0, true, false), 
    {reply, Reply, State};

do_handle_call({check_open, GuildId}, _From, State) ->
    #terri_state{
        war_state = WarState, is_cls = IsCls, 
        server_map = ServerMap, guild_map = GuildMap
    } = State,
    if
        WarState == ?WAR_STATE_END orelse WarState == 0 -> Reply = false;
        true ->
            case lib_territory_war_data:get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) of 
                none -> Reply = false;
                _ ->
                    Reply = true
            end
    end,
    {reply, Reply, State};

do_handle_call({is_qualification_call, _RoleId, GuildId}, _From, State) ->
    #terri_state{qualify_guilds = QualifyList} = State,
    ?PRINT("QualifyList ~p ~n", [QualifyList]),
    Reply = lists:member(GuildId, QualifyList),
    {reply, Reply, State};

do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ==================== 
do_handle_cast({sync_zone_group, InfoList}, State) ->
    case State#terri_state.is_init of
        0 ->
            NewState = lib_territory_war_mod:init_center(State, InfoList);
        _ ->
            NewState = lib_territory_war_mod:sync_zone_group(State, InfoList)
    end,
    {noreply, NewState};

do_handle_cast({reset_territory, AllZones}, State) ->
    ?PRINT("reset_territory do start ~p~n", [start]),
    F = fun(ZoneBase, {Map, List}) ->
        #zone_base{
            server_id = ServerId, zone = ZoneId, time = OpenTime     
            , server_num = ServerNum, server_name = ServerName, world_lv = Wlv     
        } = ZoneBase,
        TerriServer = lib_territory_war_data:make(terri_server, [ServerId, ServerNum, ServerName, ZoneId, OpenTime, Wlv, 0, 0]),
        {maps:put(ServerId, TerriServer, Map), [ZoneId|lists:delete(ZoneId, List)]}
    end,
    {ServerMap, AllZoneId} = lists:foldl(F, {#{}, []}, AllZones),
    State2 = State#terri_state{
        acc_war_id = 0, acc_group = 0, round = 0,
        server_map = ServerMap, guild_map = #{}, group_map = #{}
    },
    % 分区再mod_zone_mod进程统一且同步
    NewState = lib_territory_war_mod:reset_territory(State2, AllZoneId),
    {noreply, NewState};

do_handle_cast({gm_start, ReadyTimeGap, StartTimeGap}, State) ->
    ?PRINT("gm_start init ~p~n", [start]),
    %util:cancel_timer(OldRefState), util:cancel_timer(OldRefStage),
    NowTime = utime:unixtime(),
    StartTime = NowTime + StartTimeGap,
    ReadyTime = NowTime + ReadyTimeGap,
    mod_clusters_center:apply_to_all_node(?MODULE, gm_start_2, [StartTime, ReadyTime]),
    mod_territory_war:gm_start_2(StartTime, ReadyTime),
    {noreply, State};

do_handle_cast({center_connected, ServerInfo}, State) ->
    NewState = lib_territory_war_mod:center_connected(State, ServerInfo),
    {noreply, NewState};

do_handle_cast({async_guild_to_center, ServerId, TerriGuildList}, State) ->
    NewState = lib_territory_war_mod:async_guild_to_center(State, ServerId, TerriGuildList),
    {noreply, NewState};

do_handle_cast({war_fight_end, Group, WarId, Winner}, State) ->
    NewState = lib_territory_war_mod:war_fight_end(State, Group, WarId, Winner),
    {noreply, NewState};

do_handle_cast({handle_terri_war_winner, Group}, State) ->
    NewState = lib_territory_war_mod:handle_terri_war_winner(State, Group),
    {noreply, NewState};

% do_handle_cast({start_create_war}, State) ->
%     #terri_state{is_cls = IsCls} = State,
%     case IsCls of 
%         1 ->
%             NewState = lib_territory_war_mod:start_create_war(State);
%         _ ->
%             case lib_territory_war_data:fight_in_local(State) of 
%                 true ->
%                     NewState = lib_territory_war_mod:start_create_war(State);
%                 _ ->
%                     NewState = State
%             end
%     end,
%     {noreply, NewState};

%% 跨服中心分服后游戏服的初始化
% do_handle_cast({sync_server_mode_local, TerriServer}, State) ->
%     ?PRINT("sync_server_mode_local start ~n", []),
%     #terri_state{server_map = _ServerMap} = State,
%     #terri_server{server_id = ServerId, mode = _Mode, group = Group} = TerriServer,
%     NewServerMap = maps:put(ServerId, TerriServer, #{}),
%     FDb = fun() ->
%         lib_territory_war_data:db_clear_local_territory_server(),
%         lib_territory_war_data:db_batch_replace_local_terri_server(NewServerMap),
%         ok
%     end,
%     case catch db:transaction(FDb) of 
%         ok ->
%             ?PRINT("sync_server_mode_local end ~n", []),
%             %?MYLOG("lxl_war", "divide_server_info_local NewServerMap: ~p~n, NewGuildMap: ~p~n", [NewServerMap, NewGuildMap]),
%             NewState = State#terri_state{
%                 acc_group = Group, server_map = NewServerMap
%             },
%             {noreply, NewState};
%         _Err ->
%             ?ERR("sync_server_mode_local:~p~n", [_Err]),
%             {noreply, State}
%     end;

%% 跨服中心分服后游戏服的初始化
do_handle_cast({async_divide_server_info_local, TerriServer}, State) ->
    #terri_state{start_time = StartTime, server_map = _ServerMap, guild_map = OldGuildMap} = State,
    #terri_server{server_id = ServerId, server_num = ServerNum, mode = Mode, group = Group} = TerriServer,
    GuildNum = lib_territory_war_data:get_guild_num_by_mode(Mode),
    GuildList = mod_guild:get_top_guild(GuildNum),
    F = fun(Guild, {Map, List, List2}) ->
        #guild{id = GuildId, name = GuildName} = Guild,
        case maps:get(GuildId, OldGuildMap, 0) of 
            #terri_guild{win_num = WinNum} -> ChooseTerritoryId = 0;
            _ -> ChooseTerritoryId = 0, WinNum = 0
        end,
        TerriGuild = lib_territory_war_data:make(terri_guild, [GuildId, GuildName, ServerId, ServerNum, ChooseTerritoryId, WinNum]),
        {maps:put(GuildId, TerriGuild, Map), [GuildId|List], [TerriGuild|List2]}
    end,
    {NewGuildMap, GuildIdList, SyncGuildList} = lists:foldl(F, {#{}, [], []}, GuildList),
    %?PRINT("async_divide_server_info_local GuildIdList ~p ~n", [GuildIdList]),
    NewServerMap = maps:put(ServerId, TerriServer#terri_server{guild_list = GuildIdList}, #{}),
    FDb = fun() ->
        lib_territory_war_data:db_clear_local_territory_server(),
        lib_territory_war_data:db_clear_local_territory_guild(),
        lib_territory_war_data:db_batch_replace_local_terri_server(NewServerMap),
        lib_territory_war_data:db_batch_replace_local_terri_guild(NewGuildMap),
        ok
    end,
    case catch db:transaction(FDb) of 
        ok ->
            %?PRINT("async_divide_server_info_local end ~n", []), 
            %?MYLOG("lxl_war", "divide_server_info_local NewServerMap: ~p~n, NewGuildMap: ~p~n", [NewServerMap, NewGuildMap]),
            NewStateTmp = State#terri_state{
                acc_group = Group, server_map = NewServerMap, guild_map = NewGuildMap, group_map = #{}
            },
            NowTime = utime:unixtime(),
            case StartTime > NowTime of 
                true -> NewStartTime = StartTime;
                _ -> 
                    NewStartTime = lib_territory_war:check_start_war_local(NowTime)
            end,
            %?PRINT("async_divide_server_info_local StartTime ~p ~n", [{StartTime, NewStartTime}]),
            case NewStartTime > NowTime of 
                true ->
                    Mode =/= ?MODE_NUM_1 andalso mod_clusters_node:apply_cast(?MODULE, async_guild_to_center, [ServerId, SyncGuildList]),
                    {_,{StartH, StartM, _}} = utime:unixtime_to_localtime(NewStartTime),
                    StartTimeString = io_lib:format("~2..0w:~2..0w", [StartH, StartM]),
                    NoticeTitle = utext:get(5060014),
                    NoticeContent = utext:get(5060015, [StartTimeString]),
                    NewState = NewStateTmp#terri_state{qualify_guilds = GuildIdList},
                    [mod_guild:send_guild_mail_by_guild_id(GuildId, NoticeTitle, NoticeContent, [], []) ||GuildId <- GuildIdList];
                _ ->
                    NewState = NewStateTmp
            end,
            {noreply, NewState};
        _Err ->
            ?ERR("async_divide_server_info_local:~p~n", [_Err]),
            {noreply, State}
    end;
    
% do_handle_cast({async_war_state_local, Msg}, State) ->
%     OpenDayLimit = lib_territory_war:open_day_limit(),
%     case OpenDayLimit == not_open of 
%         false ->
%             [WarState, ReadyTime, StartTime, EndTime] = Msg,
%             ?PRINT("async_war_state_local : ~p~n", [Msg]),
%             State1 = State#terri_state{war_state = WarState, ready_time = ReadyTime, start_time = StartTime, end_time = EndTime},
%             case WarState of 
%                 ?WAR_STATE_PRE_READY ->
%                     #terri_state{ref_state = OldRefState, ref_stage = OldRefStage} = State1,
%                     util:cancel_timer(OldRefState), util:cancel_timer(OldRefStage),
%                     NewState = State1#terri_state{round_start_time = 0, round_end_time = 0, ref_state = none, ref_stage = none};
%                 ?WAR_STATE_READY ->
%                     %%发传闻
%                     lib_chat:send_TV({all_guild}, ?MOD_TERRITORY_WAR, ?TERRI_WAR_LANGUAGE_1, []),
%                     case lib_territory_war_data:fight_in_local(State1) of 
%                         true ->
%                             #terri_state{server_map = ServerMap, guild_map = GuildMap} = State1,
%                             {NewAccWarId, GroupMap} = lib_territory_war_mod:create_group_war(1, ServerMap, GuildMap),
%                             ?PRINT("war_state_local GroupMap ~p~n", [GroupMap]),
%                             NewState = State1#terri_state{acc_war_id = NewAccWarId, group_map = GroupMap};
%                         _ ->
%                             NewState = State1
%                     end;
%                 ?WAR_STATE_START ->
%                     case lib_territory_war_data:fight_in_local(State1) of 
%                         true ->
%                             NewState = lib_territory_war_mod:start_round_fight(?WAR_ROUND_1, State1);
%                         _ ->
%                             NewState = State1
%                     end;
%                 ?WAR_STATE_END ->
%                     NewState = State1;
%                 _ ->
%                     NewState = State1
%             end,
%             {ok, Bin} = pt_506:write(50600, [WarState, ReadyTime, StartTime, EndTime]),
%             lib_server_send:send_to_all(Bin),
%             {noreply, NewState};
%         _ ->
%             {noreply, State}
%     end;

do_handle_cast({sync_server_data_local, _Round, WarState, _ReadyTime, _StartTime, _EndTime, TerriServer, MergeServerList}, State) ->
    State1 = State#terri_state{sync_state = 1},
    #terri_state{server_map = ServerMap, guild_map = _GuildMap} = State1,
    #terri_server{server_id = ServerId, mode = ModeNum} = TerriServer,
    case maps:get(ServerId, ServerMap, 0) of 
        #terri_server{mode = OldModeNum} when OldModeNum == ModeNum -> %% 分服模式一样
            NeedUpMainServer = false;
        _ -> NeedUpMainServer = true
    end,
    ?PRINT("sync_server_data_local  NeedUpMainServer ~p~n", [NeedUpMainServer]),
    if
        WarState == 0 orelse WarState == ?WAR_STATE_END -> %% 活动没开或结束
            case NeedUpMainServer of 
                true -> %% 更新服务器分服模式
                    ?PRINT("sync_server_data_local update server mode ~n", []),
                    mod_territory_war:async_divide_server_info_local(TerriServer);
                _ ->
                    skip
            end, 
            NewState = State1;
        WarState == ?WAR_STATE_PRE_READY -> %% 准备前阶段
            case NeedUpMainServer == true orelse length(MergeServerList) > 0 of 
                true -> %% 服务器模式更改或者进行了合服，对主服重新进行一次初始化流程
                    ?PRINT("sync_server_data_local need divide init ~n", []),
                    mod_territory_war:async_divide_server_info_local(TerriServer);
                _ ->
                    skip
            end,
            NewState = State1;
        true -> %% 活动处于开启阶段，一般情况不会出现，先不做处理
            %% 
            NewState = State1
    end,
    {noreply, NewState};

do_handle_cast({sync_merge_server_data_local, Round, WarState, StartTime, EndTime, _ServerId, MergeTerriServer}, State) ->
    State1 = State#terri_state{round = Round, war_state = WarState, start_time = StartTime, end_time = EndTime},
    #terri_state{server_map = ServerMap, guild_map = GuildMap} = State1,
    #terri_server{server_id = MergeServerId, server_num = MergeSerNum, guild_list = GuildIdList} = MergeTerriServer,
    case maps:get(MergeServerId, ServerMap, 0) of 
        #terri_server{} -> %% 已经有记录数据，不需要做其他处理
            NewState = State1;
        _ -> %% 没有数据，加载数据
            GuildList = mod_guild:get_guild_by_id(GuildIdList),
            F = fun(Guild, {Map, List}) ->
                #guild{id = GuildId, name = GuildName} = Guild,
                case maps:get(GuildId, GuildMap, 0) of 
                    #terri_guild{choose_terri_id = ChooseTerritoryId, win_num = WinNum} -> skip;
                    _ -> ChooseTerritoryId = 0, WinNum = 0
                end,
                TerriGuild = lib_territory_war_data:make(terri_guild, [GuildId, GuildName, MergeServerId, MergeSerNum, ChooseTerritoryId, WinNum]),
                {maps:put(GuildId, TerriGuild, Map), [TerriGuild|List]}
            end,
            {NewGuildMap, AddGuildList} = lists:foldl(F, {GuildMap, []}, GuildList),
            NewServerMap = maps:put(MergeServerId, MergeTerriServer, ServerMap),
            lib_territory_war_data:db_replace_local_terri_server(MergeTerriServer),
            lib_territory_war_data:db_replace_local_terri_guild_list(AddGuildList),
            NewState = State1#terri_state{server_map = NewServerMap, guild_map = NewGuildMap}
    end,
    {noreply, NewState};

do_handle_cast({refresh_consecutive_win_local, DateId, TerriGroup}, State) ->
    ?PRINT("refresh_consecutive_win_local DateId :~p~n", [DateId]),
    HisGroupMap = maps:put(TerriGroup#terri_group.group_id, TerriGroup, #{}),
    NewHistory = [{DateId, HisGroupMap}],
    State1 = State#terri_state{war_state = ?WAR_STATE_END, start_time = 0, end_time = 0, history = NewHistory},
    %% 处理本服的连胜/终止连胜信息
    State2 = handle_local_consecutive_win(State1, DateId, TerriGroup),
    %% 更新本服公会的胜利场数
    NewState = update_local_guild_win_num(State2, DateId, TerriGroup),
    %% 一系列db
    F = fun() ->
        lib_territory_war_data:truncate_local_history_data(),
        lib_territory_war_data:truncate_local_history_warlist(),
        lib_territory_war_data:truncate_local_consecutive_win(),
        lib_territory_war_data:insert_local_history_group_batch(DateId, HisGroupMap),
        %% 汇总warlist
        F1 = fun(Group, #terri_group{war_list = WarList}, List) ->
            List1 = [
                [DateId, Group, WarId, Round, TerritoryId, AGuildId, AServerId, AServerNum, util:fix_sql_str(AGuildName), BGuildId, BServerId, BServerNum, util:fix_sql_str(BGuildName), Winner]
                || #terri_war{
                        war_id=WarId, round=Round, territory_id=TerritoryId, a_guild=AGuildId, a_server=AServerId, a_server_num=AServerNum, a_guild_name=AGuildName,
                        b_guild=BGuildId, b_server=BServerId, b_server_num=BServerNum, b_guild_name=BGuildName, winner=Winner
                    } <- WarList
                ],
            List1 ++ List
        end,
        DBList = maps:fold(F1, [], HisGroupMap),
        lib_territory_war_data:insert_local_history_warlist_batch(DBList),
        %% 更新连胜信息
        lib_territory_war_data:insert_local_consecutive_win(NewState#terri_state.consecutive_win),
        %% 更新公会guild的胜利场数
        lib_territory_war_data:db_reset_local_guild_all(),
        lib_territory_war_data:db_update_local_guild_win_num(TerriGroup#terri_group.winner_guild, TerriGroup#terri_group.win_num),
        ok
    end,
    case db:transaction(F) of 
        ok ->
            %%
            %?MYLOG("lxl_war", "refresh_consecutive_win_local ~p~n, ~p~n", [NewState#terri_state.history, NewState#terri_state.consecutive_win]),
            ?PRINT("refresh_consecutive_win_local Win :~p~n", [NewState#terri_state.consecutive_win]),
            {noreply, NewState}; 
        _Err ->
            ?ERR("refresh_consecutive_win_local Err:~p, TerriGroup:~p ~n", [_Err, TerriGroup]),
            {noreply, State}
    end;

do_handle_cast({sync_history_data_local, DateId, TerriGroup}, State) ->
    #terri_state{history = History} = State,
    case lists:keyfind(DateId, 1, History) of 
        false ->
            ?PRINT("sync_history_data_local refresh  ~n", []),
            mod_territory_war:refresh_consecutive_win_local(DateId, TerriGroup),
            {noreply, State};
        _ -> %% 已存在，不再记录
            ?PRINT("sync_history_data_local exist  ~n", []),
            {noreply, State}
    end;

do_handle_cast({start_round_language, Round, Type}, State) ->
    case State#terri_state.war_state == ?WAR_STATE_START of
        true ->
            case Type of 
                0 ->
                    lib_chat:send_TV({all}, ?MOD_TERRITORY_WAR, ?TERRI_WAR_LANGUAGE_12, [Round]);
                _ -> %% 
                    case lib_territory_war_data:fight_in_local(State) of 
                        true -> skip;
                        _ ->
                            lib_chat:send_TV({all}, ?MOD_TERRITORY_WAR, ?TERRI_WAR_LANGUAGE_12, [Round])
                    end
            end;
        _ ->
            skip
    end,
    {noreply, State};
    
do_handle_cast({enter_war, TerriRole}, State) ->
    #terri_state{
        war_state = WarState, is_cls = IsCls, start_time = StartTime, 
        server_map = ServerMap, guild_map = GuildMap, group_map = GroupMap
    } = State,
    #tfight_role{sid = Sid, node = Node, guild_id = GuildId, enter_time = EnterTime} = TerriRole,
    if
        WarState == ?WAR_STATE_END -> 
            ErrCode = ?ERRCODE(err506_war_end);
        WarState =/= ?WAR_STATE_START ->
            ErrCode = ?ERRCODE(err506_war_not_start);
        EnterTime >= StartTime ->
            case lib_territory_war_data:get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) of 
                {ok, TerriServer} ->
                    #terri_server{group = Group} = TerriServer,
                    #terri_group{group_round = GroupRound, war_list = WarList} = maps:get(Group, GroupMap, #terri_group{}),
                    %#terri_guild{win_num = WinNum} = maps:get(GuildId, GuildMap),
                    %?PRINT("50603  WarList ~p~n",[WarList]),
                    case lib_territory_war_data:find_war(WarList, GuildId, GroupRound) of 
                        #terri_war{a_guild = AGuildId, b_guild = BGuildId, winner = Winner, fight_pid = FightPid} when Winner == 0 andalso is_pid(FightPid) ->
                            #terri_guild{win_num = AWinNum} = maps:get(AGuildId, GuildMap, #terri_guild{}),
                            #terri_guild{win_num = BWinNum} = maps:get(BGuildId, GuildMap, #terri_guild{}),
                            {WinMoreGuild, LastWinNum} = ?IF(AWinNum > BWinNum, {AGuildId, AWinNum}, {BGuildId, BWinNum}),
                            if
                                LastWinNum >= 2 -> 
                                    case GuildId == WinMoreGuild of 
                                        true -> BuffId = 0;
                                        _ -> BuffId = lib_territory_war:get_role_buff(LastWinNum)
                                    end;
                                true -> BuffId = 0
                            end, 
                            mod_territory_war_fight:enter_fight(FightPid, [TerriRole, BuffId]),
                            ErrCode = ?SUCCESS;
                        #terri_war{winner = Winner} ->
                            case Winner == GuildId of 
                                true ->
                                    ErrCode = ?ERRCODE(err506_fight_end);
                                _ ->
                                    ErrCode = ?ERRCODE(err506_no_qualification_3)
                            end;
                        _ ->
                            ErrCode = ?ERRCODE(err506_no_qualification)
                    end;
                {cast_center, _} ->
                    ErrCode = none,
                    mod_clusters_node:apply_cast(?MODULE, enter_war, [TerriRole]);
                _ ->
                    ErrCode = ?ERRCODE(err506_no_qualification_2)
            end;
        true ->
            ErrCode = none
    end,
    ?PRINT("50603  ErrCode ~p~n",[ErrCode]),
    case is_integer(ErrCode) of
        true ->
            {ok, Bin} = pt_506:write(50603, [ErrCode, 1]),
            lib_server_send:send_to_sid(Node, Sid, Bin);
        _ ->
            skip
    end,
    {noreply, State};

do_handle_cast({leave_war, [RoleId, GuildId, Node]}, State) ->
    #terri_state{
        war_state = _WarState, is_cls = IsCls, start_time = StartTime, end_time = EndTime,
        server_map = ServerMap, guild_map = GuildMap, group_map = GroupMap
    } = State,
    NowTime = utime:unixtime(),
    if
        NowTime >= StartTime andalso NowTime < EndTime ->
            case lib_territory_war_data:get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) of 
                {ok, TerriServer} ->
                    #terri_server{group = Group} = TerriServer,
                    #terri_group{group_round = GroupRound, war_list = WarList} = maps:get(Group, GroupMap, #terri_group{}),
                    case lib_territory_war_data:find_war(WarList, GuildId, GroupRound) of 
                        #terri_war{fight_pid = FightPid} -> skip;
                        _ ->
                            FightPid = undefined
                    end,
                    case misc:is_process_alive(FightPid) of 
                        true -> mod_territory_war_fight:leave_war(FightPid, [RoleId, GuildId, Node]);
                        _ ->
                            lib_territory_war:apply_cast(IsCls, Node, lib_scene, player_change_default_scene, 
                                [RoleId, [{change_scene_hp_lim, 1}, {group, 0}, {action_free, ?ERRCODE(err506_in_battle)}]])
                    end;
                {cast_center, _} ->
                    mod_clusters_node:apply_cast(?MODULE, leave_war, [[RoleId, GuildId, Node]]);
                _ ->
                    lib_territory_war:apply_cast(IsCls, Node, lib_scene, player_change_default_scene, 
                                [RoleId, [{change_scene_hp_lim, 1}, {group, 0}, {action_free, ?ERRCODE(err506_in_battle)}]])
            end;
        true ->
            lib_territory_war:apply_cast(IsCls, Node, lib_scene, player_change_default_scene, 
                                [RoleId, [{change_scene_hp_lim, 1}, {group, 0}, {action_free, ?ERRCODE(err506_in_battle)}]])
    end,
    {noreply, State};

do_handle_cast({choose_terri_id, [RoleId, Sid, GuildId, TerritoryId, Node]}, State) ->
    #terri_state{
        war_state = WarState, is_cls = IsCls,
        server_map = ServerMap, guild_map = GuildMap
    } = State,
    if
        WarState == 0 -> ErrCode = ?ERRCODE(err506_war_not_start), NewState = State;
        WarState =/= ?WAR_STATE_PRE_READY -> ErrCode = ?ERRCODE(err506_choose_time_err), NewState = State;
        true ->
            case lib_territory_war_data:get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) of 
                {ok, TerriServer} ->
                    #terri_server{server_id = _ServerId, mode = ModeNum, group = Group} = TerriServer,
                    #terri_guild{choose_terri_id = ChooseTerritoryId} = TerriGuild = maps:get(GuildId, GuildMap),
                    StartRound = lib_territory_war_data:get_start_round_by_mode(ModeNum),
                    TerritoryIdList = data_territory_war:get_territory_id_list_by_round(StartRound),
                    case ChooseTerritoryId == 0 of 
                        true ->
                            case lists:member(TerritoryId, TerritoryIdList) of 
                                true ->
                                    GroupChooseList = lib_territory_war_data:get_group_choose_list(Group, ServerMap, GuildMap),
                                    HadChooseList = [GuildId1 ||{ChooseTerritoryId1, GuildId1, _, _, _} <- GroupChooseList, ChooseTerritoryId1 == TerritoryId],
                                    case length(HadChooseList) < 2 of 
                                        true ->
                                            ErrCode = ?SUCCESS,
                                            NewTerriGuild = TerriGuild#terri_guild{choose_terri_id = TerritoryId},
                                            NewGuildMap = maps:put(GuildId, NewTerriGuild, GuildMap),
                                            case IsCls of 
                                                1 -> lib_territory_war_data:db_update_guild_choose_terri_id(NewTerriGuild);
                                                _ -> lib_territory_war_data:db_update_local_guild_choose_terri_id(NewTerriGuild)
                                            end,
                                            ?PRINT("choose_terri_id NewTerriGuild : ~p~n", [NewTerriGuild]),
                                            %% 通知相关服的玩家，刷新对战列表
                                            {ok, Bin1} = pt_506:write(50626, [1]),
                                            [lib_territory_war:apply_cast(IsCls, GServerId, lib_server_send, send_to_all, [Bin1]) 
                                                ||{_, _, _, GServerId, _} <- GroupChooseList],
                                            NewState = State#terri_state{guild_map = NewGuildMap};
                                        _ ->
                                            ErrCode = ?ERRCODE(err506_had_be_choose), NewState = State 
                                    end;
                                _ ->
                                    ErrCode = ?ERRCODE(err506_choose_err_id), NewState = State 
                            end;
                        _ ->
                           ErrCode = ?ERRCODE(err506_had_choose), NewState = State 
                    end;
                {cast_center, _} ->
                    ErrCode = none, NewState = State,
                    mod_clusters_node:apply_cast(?MODULE, choose_terri_id, [[RoleId, Sid, GuildId, TerritoryId, Node]]);
                _ ->
                    ErrCode = ?ERRCODE(err506_no_qualification_2), NewState = State
            end  
    end,
    ?PRINT("choose_terri_id ErrCode : ~p~n", [ErrCode]),
    case is_integer(ErrCode) of 
        true ->
            {ok, Bin} = pt_506:write(50623, [ErrCode, TerritoryId]),
            lib_server_send:send_to_sid(Node, Sid, Bin);
        _ ->
            skip
    end,
    {noreply, NewState};

do_handle_cast({guild_qualification, [RoleId, Sid, GuildId, _ServerId, Node]}, State) ->
    #terri_state{
        war_state = WarState, is_cls = IsCls,
        server_map = ServerMap, guild_map = GuildMap, group_map = GroupMap
    } = State,
    if
        WarState == 0 orelse WarState == ?WAR_STATE_END -> Return = [0, 0];
        true ->
            case lib_territory_war_data:get_server_by_guild(IsCls, GuildId, GuildMap, ServerMap) of 
                {ok, TerriServer} ->
                    case maps:get(TerriServer#terri_server.group, GroupMap, 0) of 
                        #terri_group{war_list = WarList} ->
                            LoserList = [begin
                                ?IF(WinnerGuild == AGuildId, BGuildId, AGuildId) 
                            end||#terri_war{a_guild = AGuildId, b_guild = BGuildId, winner = WinnerGuild} <- WarList, WinnerGuild>0],
                            case lists:member(GuildId, LoserList) of 
                                true -> %% 已经输了
                                    Qualification = 0;
                                _ ->
                                    Qualification = 1
                            end;
                        _ ->
                            Qualification = 1
                    end,
                    #terri_guild{choose_terri_id = ChooseTerritoryId} = maps:get(GuildId, GuildMap),
                    IsChoose = ?IF(ChooseTerritoryId > 0, 1, 0),
                    Return = [Qualification, IsChoose];
                {cast_center, _} ->
                    Return = none,
                    mod_clusters_node:apply_cast(?MODULE, guild_qualification, [[RoleId, Sid, GuildId, _ServerId, Node]]);
                _ ->
                    Return = [0, 0]
            end  
    end,
    case is_list(Return) of 
        true ->
            handle_act_sign_up(Return, _ServerId, RoleId),
            {ok, Bin} = pt_506:write(50624, Return),
            lib_server_send:send_to_sid(Node, Sid, Bin);
        _ ->
            skip
    end,
    ?PRINT("guild_qualification Return:~p~n", [Return]),
    {noreply, State};

do_handle_cast({allocate_reward, [ChiefId, Sid, GuildId, GuildName, RoleId, RoleName]}, State) ->
    #terri_state{war_state = WarState, consecutive_win = ConsecutiveWin} = State,
    #consecutive_win{
        winner = Winner,                              
        last_server = LastServerId,             
        last_server_num = LastServerNum,          
        last_guild_name = LastGuildName,                     
        reward_type = RewardType,               
        reward_key = RewardKey,                 
        reward_owner = RewardOwner           
    } = ConsecutiveWin,
    if 
        WarState =/= ?WAR_STATE_END andalso WarState =/= 0 -> Errcode = ?ERRCODE(err506_war_is_openning), NewState = State;
        GuildId /= Winner -> Errcode = ?ERRCODE(err506_not_winner), NewState = State;
        RewardOwner /= 0 -> Errcode = ?ERRCODE(err506_reward_is_alloc), NewState = State;
        RewardType == 0 orelse RewardKey =< 1 -> Errcode = ?ERRCODE(err506_no_alloc_reward), NewState = State;
        true ->
            Errcode = ?SUCCESS,
            WorldLv = util:get_world_lv(),
            WinNum = ?IF(RewardKey > 49, 49, RewardKey),
            [WinReward, BreakReward] = data_territory_war:get_streak_reward(WorldLv, WinNum),
            Reward = ?IF(RewardType == 1, WinReward, BreakReward),
            lib_log_api:log_terri_war_allot_reward(GuildId, GuildName, RoleId, 1, RewardType, WinNum, Reward),
            case RewardType of 
                1 -> %% 连胜奖励
                    Title = utext:get(5060007),
                    Content = utext:get(5060008),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 连胜分配结果邮件
                    Title1 = utext:get(5060009),
                    Content1 = utext:get(5060010, [RewardKey, RoleName]),
                    mod_guild:send_guild_mail_by_guild_id(GuildId, Title1, Content1, [], [RoleId, ChiefId]);
                _ -> %% 终结奖励
                    Title = utext:get(5060003),
                    Content = utext:get(5060004),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    %% 终结分配结果邮件
                    SelfServerIdList = [config:get_server_id()] ++ config:get_merge_server_ids(),
                    IsOldWinnerSelfServer = lists:member(LastServerId, SelfServerIdList),
                    case IsOldWinnerSelfServer of 
                        true ->          
                            LastWinGuildName = list_to_binary([util:make_sure_binary(lists:concat(["S.", LastServerNum])), util:make_sure_binary(LastGuildName)]);
                        _ ->
                            LastWinGuildName = LastGuildName
                    end,
                    Title1 = utext:get(5060005),
                    Content1 = utext:get(5060006, [LastWinGuildName, RewardKey, RoleName]),
                    mod_guild:send_guild_mail_by_guild_id(GuildId, Title1, Content1, [], [RoleId, ChiefId])
            end,
            NewConsecutiveWin = ConsecutiveWin#consecutive_win{reward_owner = RoleId},
            lib_territory_war_data:update_reward_onwer(NewConsecutiveWin),
            NewState = State#terri_state{consecutive_win = NewConsecutiveWin}
    end,
    ?PRINT("allocate_reward == ~p~n", [Errcode]),
    {ok, Bin} = pt_506:write(50618, [Errcode]),
    lib_server_send:send_to_sid(Sid, Bin),
    {noreply, NewState};

do_handle_cast({send_territory_war_state, Sid}, State) ->
    #terri_state{war_state = WarState, ready_time = ReadyTime, start_time = StartTime, end_time = EndTime} = State,
    lib_server_send:send_to_sid(Sid, pt_506, 50600, [WarState, ReadyTime, StartTime, EndTime]),
    ?PRINT("send_territory_war_state:~p~n", [{WarState, ReadyTime, StartTime, EndTime}]),
    {noreply, State};


do_handle_cast({send_round_time_info, [ServerId, Node, RoleId, Sid]}, State) ->
    #terri_state{
        is_cls = IsCls, war_state = WarState, round = Round,
        round_start_time = RoundStartTime, round_end_time = RoundEndTime, server_map = ServerMap
    } = State,
    case WarState =/= ?WAR_STATE_START of 
        true ->
            {ok, Bin} = pt_506:write(50620, [0, 0, 0]),
            ?PRINT("send_round_time_info:~p~n", [{0, 0}]),
            lib_server_send:send_to_sid(Node, Sid, Bin);
        _ ->
            case maps:get(ServerId, ServerMap, 0) of 
                #terri_server{mode = Mode} ->
                    if
                        (IsCls == 0 andalso Mode == ?MODE_NUM_1) orelse IsCls == 1 ->
                            {ok, Bin} = pt_506:write(50620, [Round, RoundStartTime, RoundEndTime]),
                            ?PRINT("send_round_time_info:~p~n", [{Round, RoundStartTime, RoundEndTime}]),
                            lib_server_send:send_to_sid(Node, Sid, Bin);                         
                        true ->
                            mod_clusters_node:apply_cast(?MODULE, send_round_time_info, [[ServerId, Node, RoleId, Sid]])
                    end;
                _ ->
                    skip
            end
    end,
    {noreply, State};

do_handle_cast({send_territory_war_list, [ServerId, Node, RoleId, Sid]}, State) ->
    #terri_state{
        is_cls = IsCls, war_state = WarState, server_map = ServerMap, guild_map = GuildMap
    } = State,
    if
        WarState == ?WAR_STATE_START orelse WarState == ?WAR_STATE_READY orelse WarState == ?WAR_STATE_PRE_READY -> 
            case maps:get(ServerId, ServerMap, 0) of 
                #terri_server{mode = Mode, group = Group} ->
                    if
                        (IsCls == 0 andalso Mode == ?MODE_NUM_1) orelse IsCls == 1 ->
                            if
                                WarState == ?WAR_STATE_START orelse WarState == ?WAR_STATE_READY -> %% 发送当前的战场信息
                                    case lib_territory_war_data:get_terri_group_by_server_id(State, ServerId) of 
                                        #terri_group{war_list = WarList} -> skip;
                                        _ -> WarList = []
                                    end;
                                true -> %% 准备前阶段：发送各个公会自己选择的领地列表
                                    GroupChooseList = lib_territory_war_data:get_group_choose_list(Group, ServerMap, GuildMap),
                                    NewGroupChooseList = [{ChooseTerritoryId, GuildId, GuildName, GServerId, GServerNum} ||{ChooseTerritoryId, GuildId, GuildName, GServerId, GServerNum} <- GroupChooseList, ChooseTerritoryId > 0],
                                    WarList = make_tmp_fake_war_list(lists:keysort(1, NewGroupChooseList), [])
                            end,
                            send_territory_war_list(Node, Sid, WarList);
                        true ->
                            mod_clusters_node:apply_cast(?MODULE, send_territory_war_list, [[ServerId, Node, RoleId, Sid]])
                    end;
                _ ->
                    skip
            end;
        true -> %% 发送上一场的历史信息(历史信息同步到游戏服的)
            case lib_territory_war_data:get_history_terri_group_by_server_id(State, ServerId) of 
                #terri_group{war_list = WarList} -> skip;
                _ -> %% 没有历史记录，尝试去跨服获取一次历史信息
                    WarList = []
            end,
            send_territory_war_list(Node, Sid, WarList)
    end,
    {noreply, State};

do_handle_cast({send_server_divide_info, [ServerId, Node, RoleId, Sid]}, State) ->
    #terri_state{
        is_cls = IsCls, server_map = ServerMap
    } = State,
    case maps:get(ServerId, ServerMap, 0) of 
        #terri_server{mode = Mode, group = Group} ->
            if
                (IsCls == 0 andalso Mode == ?MODE_NUM_1) orelse IsCls == 1 ->
                    send_server_divide_info(Node, Sid, Mode, Group, ServerMap);
                true ->
                    mod_clusters_node:apply_cast(?MODULE, send_server_divide_info, [[ServerId, Node, RoleId, Sid]])
            end;
        _ -> %% 没有数据，显示单服模式
            ServerId = config:get_server_id(), ServerNum = config:get_server_num(), SerName = util:get_server_name(),
            Wlv = util:get_world_lv(),
            SendList = [{ServerId, ServerNum, SerName, Wlv}],
            {ok, Bin} = pt_506:write(50622, [?MODE_NUM_1, Wlv, SendList]),
            lib_server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

do_handle_cast({send_territory_war_show, [GuildId, CreateTime, RoleId, Sid]}, State) ->
    send_territory_war_show(State, GuildId, CreateTime, RoleId, Sid),
    {noreply, State};

do_handle_cast({role_login, RoleId, GuildId}, State) ->
    %?PRINT("role login === ~n", []),
    #terri_state{consecutive_win = #consecutive_win{winner = Winner}} = State,
    case Winner == GuildId of 
        true -> lib_territory_war:add_chief_buff(RoleId); 
        _ -> 
            %% 旧版会长buff有可能没清除，先在登录时清理一次buff，留几个版本后后面再删掉处理
            lib_goods_buff:remove_goods_buff_by_type(RoleId, ?BUFF_GWAR_DOMINATOR, ?HAND_OFFLINE)
    end,
    {noreply, State};

%% 换会长
do_handle_cast({change_chief, GuildId, OldChiefId, ChiefId, _Name}, State) ->
    #terri_state{war_state = WarState, consecutive_win = #consecutive_win{winner = Winner}} = State,
    case WarState == ?WAR_STATE_END orelse WarState == 0 of
        true->  
            case GuildId == Winner of 
                true ->
                    lib_territory_war:add_chief_buff(ChiefId),
                    lib_territory_war:delete_chief_buff(OldChiefId);
                _ -> ok
            end;
        false->
            skip
    end,
    {noreply, State};

%% 每天检查
do_handle_cast({timer_check}, State) ->
    #terri_state{is_cls = IsCls, ref_state = OldRefState, ref_stage = OldRefStage} = State,
    NowTime = utime:unixtime(),
    case IsCls of 
        1 -> %% 跨服
            {StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time(NowTime);
        _ -> %% 非跨服
           {StartTime, ReadyTime} = lib_territory_war_data:get_territory_war_time_local(NowTime)
    end, 
    ?PRINT("timer_check ### IsCls ~p ~n", [IsCls]),
    %?PRINT("timer_check ### ReadyTime ~p ~n", [ReadyTime]),
    %?PRINT("timer_check ### StartTime ~p ~n", [StartTime]),
    case NowTime < ReadyTime of 
        true -> %%活动开启
            RefState = util:send_after([], max(ReadyTime - NowTime, 1)*1000, self(), {war_ready}),
            case IsCls of 
                1 -> skip;
                _ ->
                    {ok, Bin} = pt_506:write(50600, [?WAR_STATE_PRE_READY, ReadyTime, StartTime, 0]),
                    lib_server_send:send_to_all(Bin)
            end,
            util:cancel_timer(OldRefState), util:cancel_timer(OldRefStage),
            NewState = State#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = ReadyTime, start_time = StartTime, end_time = 0, ref_state = RefState};
        _ -> %% 
            NewState = State#terri_state{war_state = 0, ready_time = 0, start_time = 0, end_time = 0}
    end,
    IsCls == 1 andalso mod_zone_mgr:kf_terri_war_init(),
    ?PRINT("timer_check ### end ~n", []),
    {noreply, NewState};

%% 秘籍
do_handle_cast({gm_start_2, StartTime, ReadyTime}, State) ->
    #terri_state{is_cls = IsCls, ref_state = OldRefState, ref_stage = OldRefStage} = State,
    NowTime = utime:unixtime(),
    case IsCls of 
        1 -> NewStartTime = StartTime, NewReadyTime = ReadyTime;
        _ ->
            OpenDay = util:get_open_day(),
            [_MultiModeOpenDay, OpenDaysSpec, OpenDays] = data_territory_war:get_cfg(?TERRI_KEY_14),
            [OpenDay1, OpenDay2] = OpenDays,
            case (OpenDay1 =< OpenDay andalso OpenDay =< OpenDay2) orelse lists:member(OpenDay, OpenDaysSpec) of 
                true -> NewStartTime = StartTime, NewReadyTime = ReadyTime;
                _ -> NewStartTime = 0, NewReadyTime = 0
            end
    end,
    ?PRINT("gm_start_2 : ~p~n", [{NewStartTime, NewReadyTime}]),
    case NowTime < NewReadyTime of 
        true -> %%活动开启
            RefState = util:send_after([], max(NewReadyTime - NowTime, 1)*1000, self(), {war_ready}),
            case IsCls of 
                1 -> skip;
                _ ->
                    {ok, Bin} = pt_506:write(50600, [?WAR_STATE_PRE_READY, NewReadyTime, NewStartTime, 0]),
                    lib_server_send:send_to_all(Bin)
            end,
            util:cancel_timer(OldRefState), util:cancel_timer(OldRefStage),
            NewState = State#terri_state{war_state = ?WAR_STATE_PRE_READY, ready_time = NewReadyTime, start_time = NewStartTime, end_time = 0, ref_state = RefState};
        _ -> %% 
            NewState = State#terri_state{war_state = 0, ready_time = 0, start_time = 0, end_time = 0}
    end,
    IsCls == 1 andalso mod_zone_mgr:kf_terri_war_init(),
    ?PRINT("gm_start_2 ### end ~n", []),
    {noreply, NewState};

do_handle_cast({apply_cast, Fun, Msg}, State) ->
    NewState = apply(lib_territory_war_mod, Fun, [State|Msg]),
    {noreply, NewState};
do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================

do_handle_info({async_divide_server_info}, State) ->
    lib_territory_war_mod:async_divide_server_info(State#terri_state.server_map, State#terri_state.start_time),
    {noreply, State};

do_handle_info({war_ready}, State) ->
    NewState = lib_territory_war_mod:war_ready(State),
    {noreply, NewState};

do_handle_info({war_start}, State) ->
    NewState = lib_territory_war_mod:war_start(State),
    {noreply, NewState};

do_handle_info({war_end}, State) ->
    NewState = lib_territory_war_mod:war_end(State),
    {noreply, NewState};

do_handle_info({next_round, NextRoundGapTime}, State) ->
    NewState = lib_territory_war_mod:next_round(State, NextRoundGapTime),
    {noreply, NewState};

do_handle_info({next_round_fight}, State) ->
    NewState = lib_territory_war_mod:next_round_fight(State),
    {noreply, NewState};

do_handle_info({store_history}, State) ->
    NewState = lib_territory_war_mod:store_history(State),
    {noreply, NewState};

do_handle_info({start_sync_server}, State) ->
    #terri_state{sync_state = SyncState} = State,
    case SyncState of 
        1 -> skip;
        _ ->
            ?PRINT("start_sync_server  start_sync_server  ~n", []),
            ServerId = config:get_server_id(), MergeSerIds = config:get_merge_server_ids(),
            mod_clusters_node:apply_cast(?MODULE, center_connected, [ServerId, MergeSerIds])
    end,
    {noreply, State};


do_handle_info(_Info, State) -> {noreply, State}.


send_territory_war_list(Node, Sid, WarList) ->
    SendList = lists:foldl(fun(TerriWar, List) ->
        #terri_war{
            territory_id = TerritoryId, a_guild = AGuildId, a_server = AServerId, a_server_num = AServerNum, a_guild_name = AGuildName,
            b_guild = BGuildId, b_server = BServerId, b_server_num = BServerNum, b_guild_name = BGuildName, winner = Winner
            } = TerriWar,
        [{TerritoryId, AGuildId, AGuildName, AServerId, AServerNum, BGuildId, BGuildName, BServerId, BServerNum, Winner}|List]
        end, [], WarList),

    {ok, Bin} = pt_506:write(50621, [SendList]),
    %?PRINT("send_territory_war_list:~p~n", [SendList]),
    lib_server_send:send_to_sid(Node, Sid, Bin).

send_server_divide_info(Node, Sid, Mode, Group, ServerMap) ->
    {SendList, TotalWlv} = maps:fold(fun(ServerId, #terri_server{server_num = ServerNum, server_name = SerName, world_lv = Wlv, group = SGroup}, {List, Acc}) ->
                case SGroup == Group of 
                    true ->    
                        {[{ServerId, ServerNum, SerName, Wlv}|List], Acc + Wlv};
                    _ ->
                        {List, Acc}
                end
        end, {[], 0}, ServerMap),

    Len = length(SendList),
    AvgWlv = ?IF(Len == 0, TotalWlv, round(TotalWlv/Len)),
    {ok, Bin} = pt_506:write(50622, [Mode, AvgWlv, SendList]),
    ?PRINT("send_server_divide_info:~p~n", [{Mode, AvgWlv, SendList}]),
    lib_server_send:send_to_sid(Node, Sid, Bin).

% 活动主界面请求排名
send_territory_war_show(State, GuildId, CreateTime, RoleId, Sid) ->
    #terri_state{consecutive_win = ConsecutiveWin} = State,
    #consecutive_win{
        winner = Winner,                     
        win_server = WinServerId,                        
        win_num = WinNum,                        
        reward_type = RewardType,               
        reward_key = RewardKey,                 
        reward_owner = RewardOwner,             
        date_id = _DateId
    } = ConsecutiveWin,
    Now = utime:unixtime(),
    NeedTime = data_territory_war:get_cfg(?TERRI_KEY_7),
    case GuildId == Winner andalso Winner > 0 andalso Now - CreateTime >= NeedTime of 
        true ->
            Count = mod_daily:get_count(RoleId, ?MOD_TERRITORY_WAR, 1),
            Res = ?IF(Count > 0, 3, 1);
        _ ->
            Res = 2 
    end,
    ?PRINT("send_territory_war_show ~p~n", [{Res, Winner, WinServerId, WinNum, RewardType, RewardKey, RewardOwner}]),
    {ok, BinData} = pt_506:write(50601, [Res, Winner, WinServerId, WinNum, RewardType, RewardKey, RewardOwner]), 
    lib_server_send:send_to_sid(Sid, BinData).

%% 构建临时的对战信息
make_tmp_fake_war_list([], Return) -> lists:reverse(Return);
make_tmp_fake_war_list([{ChooseTerritoryId1, GuildId1, GuildName1, ServerId1, ServerNum1}, {ChooseTerritoryId2, GuildId2, GuildName2, ServerId2, ServerNum2}|GroupChooseList], Return) ->
    case ChooseTerritoryId1 == ChooseTerritoryId2 of 
        true ->
            TerriWar = #terri_war{
                territory_id = ChooseTerritoryId1, a_guild = GuildId1, a_server = ServerId1, a_server_num = ServerNum1, a_guild_name = GuildName1,
                b_guild = GuildId2, b_server = ServerId2, b_server_num = ServerNum2, b_guild_name = GuildName2
            },
            make_tmp_fake_war_list(GroupChooseList, [TerriWar|Return]);
        _ ->
            TerriWar = #terri_war{
                territory_id = ChooseTerritoryId1, a_guild = GuildId1, a_server = ServerId1, a_server_num = ServerNum1, a_guild_name = GuildName1
            },
            make_tmp_fake_war_list([{ChooseTerritoryId2, GuildId2, GuildName2, ServerId2, ServerNum2}|GroupChooseList], [TerriWar|Return])
    end;
make_tmp_fake_war_list([{ChooseTerritoryId1, GuildId1, GuildName1, ServerId1, ServerNum1}], Return) ->
    TerriWar = #terri_war{
        territory_id = ChooseTerritoryId1, a_guild = GuildId1, a_server = ServerId1, a_server_num = ServerNum1, a_guild_name = GuildName1
    },
    make_tmp_fake_war_list([], [TerriWar|Return]).

%% 处理连胜信息
handle_local_consecutive_win(State, DateId, TerriGroup) ->
    #terri_state{consecutive_win = ConsecutiveWin} = State,
    #terri_group{winner_guild = WinnerGuild, winner_server = WinnerServerId, win_num = WinNum, war_list = WarList} = TerriGroup,
    #consecutive_win{
        winner = OldWinner, win_server = OldWinServerId, win_server_num = OldWinServerNum, win_guild_name = OldWinGuildName, win_num = OldWinNum
    } = ConsecutiveWin,
    SelfServerIdList = [config:get_server_id()] ++ config:get_merge_server_ids(),
    IsNewWinnerSelfServer = lists:member(WinnerServerId, SelfServerIdList),
    IsOldWinnerSelfServer = lists:member(OldWinServerId, SelfServerIdList),
    case [TerriWar ||#terri_war{round = WRound}=TerriWar <- WarList, WRound == ?WAR_ROUND_3] of 
        [#terri_war{a_guild=_AGuildId, a_guild_name=AGuildName, a_server_num=AServerNum, b_guild=BGuildId, b_guild_name=BGuildName, b_server_num=BServerNum}|_] ->
            {WinGuildName, WinServerNum} = ?IF(WinnerGuild == BGuildId, {BGuildName, BServerNum}, {AGuildName, AServerNum});
        _ -> 
            WinGuildName = <<>>, WinServerNum = 0
    end,
    case WinnerGuild > 0 of 
        true ->
            %% 连胜奖励和终结奖励
            case OldWinner == WinnerGuild orelse OldWinner == 0 orelse WinNum > 1 of 
                true -> %% 连胜
                    NewWinner = WinnerGuild, NewWinServerId = WinnerServerId, NewWinServerNum = WinServerNum, NewWinGuildName = WinGuildName, NewWinNum = WinNum, 
                    LastWinner = OldWinner, LastWinServerId = WinnerServerId, LastWinServerNum = WinServerNum, LastWinGuildName = WinGuildName,
                    NewRewardType = 1, NewRewardKey = NewWinNum;
                _ -> %% 终结
                    IsOldWinnerSelfServer == true andalso lib_territory_war:delete_guild_chief_buff(OldWinner),
                    NewWinner = WinnerGuild, NewWinServerId = WinnerServerId, NewWinServerNum = WinServerNum, NewWinGuildName = WinGuildName, NewWinNum = WinNum, 
                    LastWinner = OldWinner, LastWinServerId = OldWinServerId, LastWinServerNum = OldWinServerNum, LastWinGuildName = OldWinGuildName,
                    {NewRewardType, NewRewardKey} = ?IF(OldWinNum >= 2, {2, OldWinNum}, {1, WinNum})         
            end,
            case IsNewWinnerSelfServer of 
                true ->
                    lib_territory_war:add_guild_chief_buff(WinnerGuild),
                    GuildMemberList = mod_guild:get_guild_member_id_list(WinnerGuild),
                    lib_achievement_api:guild_battle_win_achievement(GuildMemberList),
                    %% 公会争霸运营活动
                    mod_custom_act_gwar:guild_war_end(WinnerGuild, utime:unixtime()),
                    %% 终结胜利成就
                    ?IF(OldWinNum >= 2 andalso NewRewardType == 2, lib_achievement_api:guild_battle_break_win(GuildMemberList), ok);
                _ ->
                    skip
            end,
            NewConsecutiveWin = #consecutive_win{
                winner = NewWinner,                     
                win_server = NewWinServerId,  
                win_server_num = NewWinServerNum,               
                win_guild_name = NewWinGuildName,         
                win_num = NewWinNum,                    
                last_winner = LastWinner,            
                last_server = LastWinServerId, 
                last_server_num = LastWinServerNum,             
                last_guild_name = LastWinGuildName,      
                reward_type = NewRewardType,               
                reward_key = NewRewardKey,                 
                reward_owner = 0,             
                date_id = DateId
            },
            State#terri_state{consecutive_win = NewConsecutiveWin};
        _ -> 
            %% 没有胜者，清楚旧霸主的buff
            case OldWinner > 0 andalso IsOldWinnerSelfServer == true of 
                true -> lib_territory_war:delete_guild_chief_buff(OldWinner);
                _ -> skip
            end,
            NewConsecutiveWin = #consecutive_win{},
            State#terri_state{consecutive_win = NewConsecutiveWin}
    end.

%% 更新本服各个公会的胜场数
update_local_guild_win_num(State, _DateId, TerriGroup) ->
    #terri_state{guild_map = GuildMap} = State,
    #terri_group{winner_guild = WinnerGuild, win_num = WinNum} = TerriGroup,
    F = fun(_GuildId, TerriGuild) ->
        case TerriGuild#terri_guild.guild_id == WinnerGuild of 
            true -> TerriGuild#terri_guild{win_num = WinNum};
            _ -> TerriGuild#terri_guild{win_num = 0}
        end
    end,
    NewGuildMap = maps:map(F, GuildMap),
    State#terri_state{guild_map = NewGuildMap}.




handle_act_sign_up([Qualification, _], ServerId, RoleId) ->
    case util:is_cls() of
        true ->
%%            ?MYLOG("sign", "Status check_guild_war           ~n", [ ]),
            mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast,
                [RoleId, ?APPLY_CAST_SAVE, lib_act_sign_up, update_guild_war, [Qualification]]);
        _ ->
%%            ?MYLOG("sign", "Status check_guild_war           ~n", [ ]),
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_act_sign_up, update_guild_war, [Qualification])
    end.