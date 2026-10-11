-module(mod_escort_local).
-behaviour(gen_server).

-include("escort.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("scene.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        % enter/5,
        local_init/11,              %% 数据更新
        send_first_guild_info/2     %% 获取排行榜第一公会数据
        ,send_rank_info/1           %% 获取公会排行榜
        ,send_escort_list/1         %% 获取护送列表
        ,send_role_rank/2           %% 获取公会内部排行榜
        ,send_scene_show_list/3     %% 获取某场景护送列表
        ,update_info/1              %% 跨服更新本地数据
        ,judge_guild_has_join/2     %% 判断公会是否召唤过水晶
        ,notify_guild/4             %% 通知所有公会成员
        ,judge_is_in_act_time/0     %% 是否在活动时间
        ,get_guild_escort_info/2    %% 获取公会护送数据
        ,get_guild_score_info/2     %% 获取公会积分
        ,get_act_time/1             %% 获取活动时间
        ,get_self_score_info/2      %% 获取个人掠夺积分

    ]).


%%=========================================================================
%% 接口函数
%%=========================================================================

%% -----------------------------------------------------------------
%% 本地数据初始化
%% -----------------------------------------------------------------
local_init(StartTime, EndTime, ServerIdList, ScoreRank, LocalGuildMon, LocalRoleRank, SendJoinList, SendFirst, SendEscortMap, GuildInfo, LocalRobMap) ->
    gen_server:cast(?MODULE, {'local_init', 
        StartTime, EndTime, ServerIdList, ScoreRank, LocalGuildMon, LocalRoleRank, SendJoinList, SendFirst, SendEscortMap, GuildInfo, LocalRobMap}).
%% -----------------------------------------------------------------
%% 更新本地数据
%% -----------------------------------------------------------------
update_info(Data) ->
    gen_server:cast(?MODULE, {'update_info', Data}).

%% -----------------------------------------------------------------
%% 排行榜第一数据
%% -----------------------------------------------------------------
send_first_guild_info(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'send_first_guild_info', RoleId, GuildId}).

%% -----------------------------------------------------------------
%% 排行榜
%% -----------------------------------------------------------------
send_rank_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_rank_info', RoleId}).

%% -----------------------------------------------------------------
%% 护送列表
%% -----------------------------------------------------------------
send_escort_list(RoleId) ->
    gen_server:cast(?MODULE, {'send_escort_list', RoleId}).

%% -----------------------------------------------------------------
%% 公会内部积分排行
%% -----------------------------------------------------------------
send_role_rank(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'send_role_rank', RoleId, GuildId}).

%% -----------------------------------------------------------------
%% 场景内护送列表
%% -----------------------------------------------------------------
send_scene_show_list(RoleId, GuildId, Scene) ->
    gen_server:cast(?MODULE, {'send_scene_show_list', RoleId, GuildId, Scene}).

%% -----------------------------------------------------------------
%% 判断是否召唤过水晶
%% -----------------------------------------------------------------
judge_guild_has_join(ServerId, GuildId) ->
    gen_server:call(?MODULE, {'judge_guild_has_join', ServerId, GuildId}).

%% -----------------------------------------------------------------
%% 计算是否在活动时间内
%% -----------------------------------------------------------------
judge_is_in_act_time() ->
    gen_server:call(?MODULE, {'judge_is_in_act_time'}).

%% -----------------------------------------------------------------
%% 通知公会玩家
%% -----------------------------------------------------------------
notify_guild(RoleId, GuildId, Notify, Scene) ->
    gen_server:cast(?MODULE, {'notify_guild', RoleId, GuildId, Notify, Scene}).

%% -----------------------------------------------------------------
%% 公会护送数据
%% -----------------------------------------------------------------
get_guild_escort_info(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'get_guild_escort_info', RoleId, GuildId}).

%% -----------------------------------------------------------------
%% 公会积分数据
%% -----------------------------------------------------------------
get_guild_score_info(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'get_guild_score_info', RoleId, GuildId}).

%% -----------------------------------------------------------------
%% 获取活动时间
%% -----------------------------------------------------------------
get_act_time(RoleId) ->
    gen_server:cast(?MODULE, {'get_act_time', RoleId}).

%% -----------------------------------------------------------------
%% 个人积分数据
%% -----------------------------------------------------------------
get_self_score_info(RoleId, GuildId) ->
    gen_server:cast(?MODULE, {'get_self_score_info', RoleId, GuildId}).
%%=========================================================================
%% 回调函数
%%=========================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    mod_escort_kf:local_init(config:get_server_id()),
    {ok, #local_escort_state{}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

% do_handle_cast({'enter', ServerId, GuildId, RoleId, Scene, NeedOut}, State) ->
%     mod_escort_kf:enter_scene(ServerId, GuildId, RoleId, Scene, NeedOut),
%     {noreply, State}.

% do_handle_cast({'exit', ServerId, RoleId, Scene, GuildId}, State) ->
%     mod_escort_kf:exit(ServerId, GuildId),
%     {noreply, State}.

do_handle_cast({'local_init', StartTime, EndTime, ServerIdList, ScoreRank, LocalGuildMon, LocalRoleRank, SendJoinList, SendFirst, SendEscortMap, GuildInfo, LocalRobMap}, State) ->
    NewState = State#local_escort_state{
        start_time = StartTime,
        end_time = EndTime,
        first_guild = SendFirst,
        server_id_list = ServerIdList,
        score_rank = sort_score_rank(ScoreRank),
        role_rank = LocalRoleRank,
        guild_mon = LocalGuildMon,
        join_list = SendJoinList,
        escort_map = SendEscortMap,
        guild_info = GuildInfo,
        rob_map = LocalRobMap},
    {noreply, NewState};

do_handle_cast({'update_info', Data}, State) ->
    NewState = update_info_core(Data, State),
    {noreply, NewState};

do_handle_cast({'send_first_guild_info', RoleId, GuildId}, State) -> 
    #local_escort_state{first_guild = SendFirst, guild_mon = LocalGuildMon, escort_map = SendEscortMap, rob_map = LocalRobMap} = State,
    case SendFirst of
        {FServerId, FServerNum, FGuildId, FGuildName} -> skip;
        _ -> FServerId = 0, FServerNum = 0, FGuildId = 0, FGuildName = ""
    end,

    ServerId = config:get_server_id(),
    case maps:get({ServerId, GuildId}, LocalGuildMon, []) of
        {MonAutoId, _MonType, _MonLv, _Escort, _Scene, _X, _Y, _, _} -> 
            List = maps:get(MonAutoId, SendEscortMap, []),
            case lists:keyfind(RoleId, 2, List) of
                {_ServerId, RoleId, _Position, _RoleName, SumTime, _BeginEscortTime} -> EscortTime = SumTime;
                _ -> EscortTime = 0
            end;
        [] -> EscortTime = 0
    end,

    RobTimes = maps:get({ServerId, RoleId}, LocalRobMap, 0),
    % ?PRINT("GuildInfo:~p~n",[State#local_escort_state.guild_info]),
    % ?PRINT("SendData:~p~n", [{FServerId, FServerNum, FGuildId, FGuildName, RobTimes, EscortTime}]),
    {ok, BinData} = pt_185:write(18501, [FServerId, FServerNum, FGuildId, FGuildName, RobTimes, EscortTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'send_rank_info', RoleId}, State) ->
    #local_escort_state{score_rank = SendList} = State,  % {ServerNum, ServerId, GuildName, GuildId, Score, Rank}
    RealSendList = lists:sublist(lists:keysort(6, SendList), 3),
    {ok, BinData} = pt_185:write(18505, [RealSendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'send_escort_list', RoleId}, State) ->
    #local_escort_state{guild_mon = GuildMon, guild_info = GuildInfo} = State,  % {ServerId, GuildId}, {MonAutoId, _MonType, ?NOT_ESCORT, Scene}
    SendList = calc_send_mon(GuildMon, GuildInfo),
    % ?PRINT("SendList:~p~n",[SendList]),
    {ok, BinData} = pt_185:write(18506, [SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'send_role_rank', RoleId, GuildId}, State) ->
    #local_escort_state{role_rank = LocalRoleRank, guild_mon = LocalGuildMon} = State,
    ServerId = config:get_server_id(),
    UnSortList = maps:get({ServerId, GuildId}, LocalRoleRank, []),
    SortList = lists:reverse(lists:keysort(4, UnSortList)),
    Fun = fun({TRoleId, Position, Name, RobScore, _EscortScore}, {Acc, Rank}) when RobScore > 0 -> %% 掠夺积分大于零才发给客户端
        {[{Position, Name, TRoleId, RobScore, Rank}|Acc], Rank+1};
        (_, Acc) -> Acc
    end,
    {SendRank, _} = lists:foldl(Fun, {[], 1}, SortList),
    case maps:get({ServerId, GuildId}, LocalGuildMon, []) of
        {_MonAutoId, MonType, MonLv, Res, _Scene, _X, _Y, Hp, _HpMax} -> 
            if
                Res >= ?RES_FAIL ->
                    MonId = lib_escort:get_mon_id(MonType),
                    HpPercent = lib_escort:get_mon_hp_percent(MonId, Hp, MonLv),
                    #base_escort_reward{score = Score} = data_escort:get_escort_reward(MonType, HpPercent);
                true -> 
                    Score = 0
            end,
            {ok, BinData} = pt_185:write(18507, [SendRank, Res, MonType, Score]);
        _ ->
            {ok, BinData} = pt_185:write(18507, [SendRank, 0, 0, 0])
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};
            
do_handle_cast({'send_scene_show_list', RoleId, _GuildId, Scene}, State) ->
    #local_escort_state{guild_mon = LocalGuildMon, guild_info = GuildInfo} = State,
    SendList = calc_send_mon(LocalGuildMon, GuildInfo, Scene),
    % RoleId == 4294967306 andalso ?PRINT("SendList:~p~n",[SendList]),
    {ok, BinData} = pt_185:write(18508, [SendList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'notify_guild', RoleId, GuildId, Notify, Scene}, State) ->
    if
        Notify == 1 ->
            MsgId = 4,
            Args = get_tv_args(Scene),
            lib_chat:send_TV({guild, GuildId}, ?MOD_ESCORT, MsgId, Args);
        Notify == 2 ->
            MsgId = 2, 
            lib_chat:send_TV({guild, GuildId}, ?MOD_ESCORT, MsgId, []);
        true ->
            Code = ?ERRCODE(data_error),
            {ok, BinData} = pt_185:write(18500, [Code]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast({'get_guild_escort_info', RoleId, GuildId}, State) ->
    #local_escort_state{guild_mon = GuildMon} = State,
    BinData = send_18510(GuildId, GuildMon),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_guild_score_info', RoleId, GuildId}, State) ->
    #local_escort_state{score_rank = ScoreRank} = State,  % {ServerId, ServerNum, GuildId, GuildName, Score, Rank}
    case lists:keyfind(GuildId, 4, ScoreRank) of
        {_, _, _, _, Score, Rank} -> 
            {ok, BinData} = pt_185:write(18511, [Score, Rank]);
        _ -> 
            {ok, BinData} = pt_185:write(18511, [0,0])
    end,
    % ?PRINT("GuildId:~p,ScoreRank:~p~n",[GuildId, ScoreRank]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_act_time', RoleId}, State) ->
    #local_escort_state{start_time = StartTime, end_time = EndTime} = State,
    {ok, BinData} = pt_185:write(18512, [StartTime, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast({'get_self_score_info', RoleId, GuildId}, State) ->
    #local_escort_state{guild_mon = LocalGuildMon, role_rank = LocalRoleRank, escort_map = SendEscortMap, rob_map = LocalRobMap} = State,
    ServerId = config:get_server_id(),
    UnSortList = maps:get({ServerId, GuildId}, LocalRoleRank, []),
    case lists:keyfind(RoleId, 1, UnSortList) of
        {_, _, _, RobScore, _} -> skip;
        _ -> RobScore = 0
    end,

    case maps:get({ServerId, GuildId}, LocalGuildMon, []) of
        {MonAutoId, _MonType, _MonLv, _Escort, _Scene, _X, _Y, _, _} -> 
            List = maps:get(MonAutoId, SendEscortMap, []),
            case lists:keyfind(RoleId, 2, List) of
                {_ServerId, RoleId, _Position, _RoleName, SumTime, _BeginEscortTime} -> EscortTime = SumTime;
                _ -> EscortTime = 0
            end;
        [] -> EscortTime = 0
    end,
    RobTimes = maps:get({ServerId, RoleId}, LocalRobMap, 0),
    % ?PRINT("=============== RobTimes:~p~n",[RobTimes]),
    {ok, BinData} = pt_185:write(18513, [RobScore, RobTimes, EscortTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call({'judge_guild_has_join', ServerId, GuildId}, State) ->
    #local_escort_state{guild_mon = GuildMon} = State,
    case maps:get({ServerId, GuildId}, GuildMon, []) of
        [] -> Reply = false;
        _ -> Reply = true
    end,
    {reply, Reply, State};

do_handle_call({'judge_is_in_act_time'}, State) ->
    #local_escort_state{start_time = StartTime, end_time = EndTime} = State,
    Nowtime = utime:unixtime(),
    if
        Nowtime >= StartTime andalso Nowtime < EndTime ->
            Reply = true;
        true ->
            Reply = false 
    end,
    {reply, Reply, State};

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

update_info_core([{time, StartTime, EndTime}|T], State) ->
    NewState = State#local_escort_state{start_time = StartTime, end_time = EndTime},
    update_info_core(T, NewState);
update_info_core([{first, SendFirst}|T], State) ->
    NewState = State#local_escort_state{first_guild = SendFirst},
    update_info_core(T, NewState);
update_info_core([{clear}|T], State) -> %% 活动结束清理所有数据
    NewState = State#local_escort_state{
        server_id_list = [],
        score_rank = [],
        role_rank = #{},
        guild_mon = #{},
        join_list = [],
        escort_map = #{},
        guild_info = [],
        rob_map = #{}},
    update_info_core(T, NewState);
update_info_core([{server, ServerIdList}|T], State) ->
    NewState = State#local_escort_state{server_id_list = ServerIdList},
    update_info_core(T, NewState);
update_info_core([{join, SendJoinList}|T], State) ->
    NewState = State#local_escort_state{join_list = SendJoinList},
    update_info_core(T, NewState);
update_info_core([{mon, LocalGuildMon, SceneId, CopyId, GuildId}|T], State) ->
    GuildInfo = State#local_escort_state.guild_info,
    NewState = State#local_escort_state{guild_mon = LocalGuildMon},
    SendList = calc_send_mon(LocalGuildMon, State#local_escort_state.guild_info),
    {ok, BinData} = pt_185:write(18506, [SendList]),
    lib_server_send:send_to_scene(SceneId, 0, CopyId, BinData),
    Bin = send_18510(GuildId, LocalGuildMon),
    lib_server_send:send_to_scene_guild(SceneId, CopyId, GuildId, Bin),

    SendMonList = calc_send_mon(LocalGuildMon, GuildInfo, SceneId),
    % ?PRINT("SendMonList:~p~n",[GuildInfo]),
    {ok, Bin1} = pt_185:write(18508, [SendMonList]),
    lib_server_send:send_to_scene(SceneId, 0, CopyId, Bin1),
    update_info_core(T, NewState);
update_info_core([{mon_move, Scene, CopyId, LocalGuildMon}|T], State) ->
    GuildInfo = State#local_escort_state.guild_info,
    NewState = State#local_escort_state{guild_mon = LocalGuildMon},
    SendList = calc_send_mon(LocalGuildMon, GuildInfo, Scene),
    {ok, BinData} = pt_185:write(18508, [SendList]),
    % ?PRINT("SendMonList:~p~n",[GuildInfo]),
    mod_chat_agent:send_msg([{scene, Scene, CopyId, BinData}]),
    update_info_core(T, NewState);
update_info_core([{role_rank, LocalRoleRank}|T], State) ->
    #local_escort_state{rob_map = LocalRobMap, guild_mon = LocalGuildMon, escort_map = SendEscortMap} = State,
    send_18513(LocalRoleRank, LocalRobMap, LocalGuildMon, SendEscortMap),
    NewState = State#local_escort_state{role_rank = LocalRoleRank},
    update_info_core(T, NewState);
update_info_core([{rank, ScoreRank, SceneId, CopyId}|T], State) ->
    RankList = sort_score_rank(ScoreRank),
    % ?PRINT("RankList:~p,SceneId:~p, CopyId:~p~n",[RankList, SceneId, CopyId]),
    send_18511(RankList, SceneId, CopyId),
    NewState = State#local_escort_state{score_rank = RankList},
    update_info_core(T, NewState);
update_info_core([{escort, SendEscortMap}|T], State) ->
    NewState = State#local_escort_state{escort_map = SendEscortMap},
    update_info_core(T, NewState);
update_info_core([{guild_info, GuildInfo}|T], State) ->
    NewState = State#local_escort_state{guild_info = GuildInfo},
    update_info_core(T, NewState);
update_info_core([{rob, LocalRobMap}|T], State) ->
    NewState = State#local_escort_state{rob_map = LocalRobMap},
    % ?PRINT("LocalRobMap:~p~n",[LocalRobMap]),
    update_info_core(T, NewState);
update_info_core(_, State) -> State.

%% -----------------------------------------------------------------
%% 组装怪物数据给客户端
%% -----------------------------------------------------------------
calc_send_mon(GuildMon, GuildInfo) ->
    %% 筛选护送中的数据
    Fun = fun({{ServerId, GuildId}, {_MonAutoId, MonType, _MonLv, _Escort, Scene, _, _, _, _}}, Acc) when _Escort =< ?RES_ESCORT -> %{ServerId, [{ServerNum, GuildId, GuildName}]}
        {ServerId, List} = ulists:keyfind(ServerId, 1, GuildInfo, {ServerId, []}),
        case lists:keyfind(GuildId, 2, List) of
            {ServerNum, _, GuildName} -> skip;
            _ -> ServerNum = 0, GuildName = ""
        end,
        [{ServerNum, ServerId, GuildName, GuildId, MonType, Scene}|Acc];
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, [], maps:to_list(GuildMon)).

%% -----------------------------------------------------------------
%% 组装怪物数据给客户端
%% -----------------------------------------------------------------
calc_send_mon(GuildMon, GuildInfo, Scene) ->
    Fun = fun %% 所有护送中的数据
        ({{ServerId, GuildId}, {MonAutoId, MonType, _MonLv, _Escort, TemScene, _X, _Y, Hp, HpMax}}, Acc) when TemScene == Scene andalso _Escort =< ?RES_ESCORT -> %{ServerId, [{ServerNum, GuildId, GuildName}]}
            {ServerId, List} = ulists:keyfind(ServerId, 1, GuildInfo, {ServerId, []}),
            case lists:keyfind(GuildId, 2, List) of
                {ServerNum, _, GuildName} -> skip;
                _ -> ServerNum = 0, GuildName = ""
            end,
            [{ServerNum, ServerId, GuildName, GuildId, MonType, MonAutoId, _X, _Y, Scene, Hp, HpMax}|Acc];
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, [], maps:to_list(GuildMon)).

%% -----------------------------------------------------------------
%% 组装传闻参数
%% -----------------------------------------------------------------
get_tv_args(Scene) ->
    case data_scene:get(Scene) of
        #ets_scene{name = SceneName} -> skip;
        _ -> SceneName = <<>>
    end,
    [SceneName].

%% -----------------------------------------------------------------
%% 积分排行榜
%% -----------------------------------------------------------------
sort_score_rank(ScoreRank) ->
    SortRank = lib_escort:sort_score_rank(ScoreRank),
    Fun = fun({ServerNum, ServerId, GuildName, GuildId, Score, _}, {Acc, Rank}) ->
        {[{ServerNum, ServerId, GuildName, GuildId, Score, Rank}|Acc], Rank+1}
    end,
    {UnsortSend, _} = lists:foldl(Fun, {[], 1}, SortRank),
    lists:reverse(UnsortSend).

%% -----------------------------------------------------------------
%% 发送18513协议给客户端
%% -----------------------------------------------------------------
send_18513(LocalRoleRank, LocalRobMap, LocalGuildMon, SendEscortMap) ->
    List = maps:to_list(LocalRoleRank),
    Fun = fun({{ServerId, GuildId}, UnSortList}) ->
        F1 = fun({RoleId, _Position, _RoleName, RobScore, _EscortScore}) ->
            case maps:get({ServerId, GuildId}, LocalGuildMon, []) of
                {MonAutoId, _MonType, _MonLv, _Escort, _Scene, _X, _Y, _, _} -> 
                    EscortList = maps:get(MonAutoId, SendEscortMap, []),
                    case lists:keyfind(RoleId, 2, EscortList) of
                        {_ServerId, RoleId, _Position, _RoleName, SumTime, _BeginEscortTime} -> EscortTime = SumTime;
                        _ -> EscortTime = 0
                    end;
                [] -> EscortTime = 0
            end,
            RobTimes = maps:get({ServerId, RoleId}, LocalRobMap, 0),
            % ?PRINT("=============== RobTimes:~p~n",[RobTimes]),
            {ok, BinData} = pt_185:write(18513, [RobScore, RobTimes, EscortTime]),
            lib_server_send:send_to_uid(RoleId, BinData)
        end,
        lists:foreach(F1, UnSortList)
    end,
    lists:foreach(Fun, List).

%% -----------------------------------------------------------------
%% 发送18511协议给客户端
%% -----------------------------------------------------------------
send_18511(ScoreRank, SceneId, CopyId) ->
    Fun = fun({_, _, _, GuildId, Score, Rank}) ->
        {ok, BinData} = pt_185:write(18511, [Score, Rank]),
        lib_server_send:send_to_scene_guild(SceneId, CopyId, GuildId, BinData) %% 发送给某公会所有在某场景的玩家
    end,
    lists:foreach(Fun, ScoreRank).

%% -----------------------------------------------------------------
%% 计算要发送的18510协议数据
%% -----------------------------------------------------------------
send_18510(GuildId, GuildMon) ->
    ServerId = config:get_server_id(),
    case maps:get({ServerId, GuildId}, GuildMon, []) of
        {_MonAutoId, MonType, _MonLv, _Escort, _Scene, _X, _Y, _, _} -> 
            % ?PRINT("Res 18510 ========== MonType:~p, _Escort:~p~n",[MonType, _Escort]),
            {ok, BinData} = pt_185:write(18510, [MonType, _Escort]);
        _ -> 
            {ok, BinData} = pt_185:write(18510, [0, 0])
    end,
    BinData.