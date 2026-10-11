%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%% @desc :跨服圣域--本服数据管理进程
%%%-------------------------------------------------------------------
-module(mod_c_sanctuary_local).

-behaviour(gen_server).

-include("cluster_sanctuary.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("def_id_create.hrl").
-include("auction_module.hrl").
-include("rec_auction.hrl").
-include("language.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        get_act_opentime/1
        ,get_mon_pk_log/3
        ,get_info/2
        ,get_construction_info/3
        ,get_rank_info/4
        ,init_after/11
        ,update_state/2
        ,get_point_rank_info/1
        ,get_auction_produce_end_time/1
        ,auction_info/5
        ,role_auction_divident/2
        ,add_auction_role/2
        ,delay_auction/1
        ,send_msg_to_camp/2
        ,send_msg_to_other_server/5
    ]).

get_act_opentime(RoleId) ->
    gen_server:cast(?MODULE, {'get_act_opentime', RoleId}).

get_mon_pk_log(RoleId, Scene, MonId) ->
    gen_server:cast(?MODULE, {'get_mon_pk_log', RoleId, Scene, MonId}).

get_info(ServerId, RoleId) ->
    gen_server:cast(?MODULE, {'get_info', ServerId, RoleId}).

get_construction_info(ServerId, RoleId, Scene) ->
    gen_server:cast(?MODULE, {'get_construction_info', ServerId, RoleId, Scene}).

get_rank_info(ServerId, RoleId, Scene, MonId) ->
    gen_server:cast(?MODULE, {'get_rank_info', ServerId, RoleId, Scene, MonId}).

init_after(ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, AuctionBegTime) ->
    gen_server:cast(?MODULE, {'init_after', ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, AuctionBegTime}).

update_state(Type, Args) ->
    gen_server:cast(?MODULE, {'update_state', Type, Args}).

get_point_rank_info(RoleId) ->
    gen_server:cast(?MODULE, {'point_rank_info', RoleId}).

get_auction_produce_end_time(RoleId) ->
    gen_server:cast(?MODULE, {'peoduce_end_time', RoleId}).

add_auction_role(ProduceType, RoleIdList) ->
    gen_server:cast(?MODULE, {'add_auction_role', ProduceType, RoleIdList}).

delay_auction(AuctionEndTime) ->
    gen_server:cast(?MODULE, {'delay_auction', AuctionEndTime}).

%% List: [{玩家id,公会id,功能id,物品列表}]
%% 物品列表:[{钻石,0,数量},{搬钻,0，数量}]
role_auction_divident(AuthenticationId, List) ->
    gen_server:cast(?MODULE, {'role_auction_divident', AuthenticationId, List}).

auction_info(ProduceType, Produce, RoleIdList, StartTime, Source) ->
    gen_server:cast(?MODULE, {'send_auction_thing', ProduceType, Produce, RoleIdList, StartTime, Source}).

send_msg_to_camp(ServerId, BinData) ->
    gen_server:cast(?MODULE, {'send_msg_to_camp', ServerId, BinData}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ServerId = config:get_server_id(),
    Openday = util:get_open_day(),
    if
        Openday =< 1 ->
            InitRef = undefined;
        true ->
            InitRef = util:send_after(undefined, ?TIME_INIT * 1000, self(), {init_more}),
            spawn(fun() ->
                timer:sleep(5000),
                mod_c_sanctuary:local_init(ServerId)
            end)
    end,
    State = #sanctuary_state_local{
        san_list = []
        ,san_type = 0
        ,enemy_server = []
        ,begin_scene_list = []
        ,server_info = []
        ,join_map = #{}
        ,act_start_time = 0
        ,act_end_time = 0
        ,point_rank = []
        ,init_ref = InitRef
        ,auction_begin_time = 0},
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_c_sanctuary_local Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_c_sanctuary_local Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_c_sanctuary_local Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'get_act_opentime', RoleId}, State) ->
    NewState = get_act_opentime(State, RoleId),
    {noreply, NewState};

do_handle_cast({'get_info', ServerId, RoleId}, State) ->
    NewState = get_info(State, ServerId, RoleId),
    {noreply, NewState};

do_handle_cast({'get_construction_info', ServerId, RoleId, Scene}, State) ->
    NewState = get_construction_info(State, ServerId, RoleId, Scene),
    {noreply, NewState};

do_handle_cast({'get_rank_info', ServerId, RoleId, Scene, MonId}, State) ->
    NewState = get_rank_info(State, ServerId, RoleId, Scene, MonId),
    {noreply, NewState};

do_handle_cast({'get_mon_pk_log', RoleId, Scene, MonId}, State) ->
    NewState = get_mon_pk_log(State, RoleId, Scene, MonId),
    {noreply, NewState};

do_handle_cast({'init_after', ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, AuctionBegTime}, State) ->
    NewState = init_after(State, ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, AuctionBegTime),
    {noreply, NewState};

do_handle_cast({'update_state', Type, Args}, State) ->
    NewState = update_state(State, Type, Args),
    {noreply, NewState};

do_handle_cast({'point_rank_info', RoleId}, State) ->
    NewState = point_rank_info(State, RoleId),
    {noreply, NewState};

do_handle_cast({'peoduce_end_time', RoleId}, State) ->
    NewState = peoduce_end_time(State, RoleId),
    {noreply, NewState};

do_handle_cast({'send_auction_thing', ProduceType, Produce, RoleIdList, StartTime, Source}, State) ->
    NewState = send_auction_thing(State, ProduceType, Produce, RoleIdList, StartTime, Source),
    {noreply, NewState};

do_handle_cast({'role_auction_divident', AuthenticationId, List}, State) ->
    NewState = role_auction_divident(State, AuthenticationId, List),
    {noreply, NewState};

do_handle_cast({'add_auction_role', ProduceType, RoleIdList}, State) ->
    NewState = add_auction_role(State, ProduceType, RoleIdList),
    {noreply, NewState};

do_handle_cast({'delay_auction', AuctionEndTime}, State) ->
    NewState = delay_auction(State, AuctionEndTime),
    {noreply, NewState};

do_handle_cast({'send_msg_to_camp', ServerId, BinData}, State) ->
    NewState = send_msg_to_camp(State, ServerId, BinData),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    %?MYLOG("xlh_mod","do_handle_info, _Msg:~p~n", [_Msg]),
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({init_more}, State) ->
    #sanctuary_state_local{is_init = Init, init_ref = InitRef} = State,
    if
        Init == ?INIT_SUCCESS ->
            util:cancel_timer(InitRef),
            NewRef = undefined;
        true ->
            ServerId = config:get_server_id(),
            NewRef = util:send_after(undefined, ?TIME_INIT * 1000, self(), {init_more}),
            mod_c_sanctuary:local_init(ServerId)
    end,
    NewState = State#sanctuary_state_local{init_ref = NewRef},
    {noreply, NewState};

do_handle_info({send_mail_after_auction}, State) ->
    NewState = send_mail_after_auction(State),
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    %?MYLOG("xlh_mod","do_handle_info, _Msg:~p~n", [_Msg]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% 获取活动开启时间
%% -----------------------------------------------------------------
get_act_opentime(State, RoleId) ->
    #sanctuary_state_local{act_start_time = StartTime, act_end_time = EndTime} = State,
    {ok, BinData} = pt_284:write(28410, [StartTime, EndTime]),
    % ?PRINT("get_info 28410, StartTime:~p,EndTime:~p~n", [StartTime, EndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 跨服圣域数据
%% -----------------------------------------------------------------
get_info(State, _ServerId, RoleId) ->
    #sanctuary_state_local{
        server_info = ServerInfo, 
        san_type = Santype, 
        enemy_server = Serverids,
        begin_scene_list = DivideScene} = State,
    SendL = send_info_28400(Serverids, ServerInfo, DivideScene),
    {ok, BinData} = pt_284:write(28400, [Santype,SendL]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 建筑数据
%% -----------------------------------------------------------------
get_construction_info(State, ServerId, RoleId, Scene) ->
    #sanctuary_state_local{
        zone_id = ZoneId,
        san_list = SanList, 
        san_type = Santype, 
        enemy_server = Serverids, 
        begin_scene_list = BeginList,
        join_map = JoinMap} = State,
    [H|_] = Serverids,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    {Camp, _ServerList} = get_camp(ServerId, BeginList, {0, []}),
    Fun1 = fun(TemServerId, Sum) -> 
        JNum = maps:get({Camp, TemServerId, Scene}, JoinMap, 0),
        Sum + JNum
    end,
    JoinNum = lists:foldl(Fun1, 0, _ServerList),
    
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
        #c_cons_state{san_score = SanScore, cons_type = ConType, mon_state = Mons, 
                bl_server = BlCamp, pre_bl_server = PblCamp, role_recieve = RecieveList} -> SanScore;
        _ -> SanScore = #{}, Mons = [], BlCamp = 0,PblCamp=0,ConType = 0,RecieveList = []
    end,
    case lists:keyfind(RoleId, 1, RecieveList) of
        {RoleId, _Time} -> RecieveStatus = ?HAS_RECIEVE;
        _ -> 
            if
                BlCamp == Camp ->
                    RecieveStatus = ?HAS_ACHIEVE;
                true ->
                    RecieveStatus = ?NOT_ACHIEVE
            end
    end,
    List = maps:to_list(SanScore),
    Fun = fun({{TemCamp, _TScene}, Score}, Acc) ->
        [{TemCamp, Score}|Acc]
    end,
    SendL = lists:foldl(Fun, [], List),
    MonInfo = get_all_mon_info(Mons, []),
    % ?MYLOG("xlh","================= 28401:~p~n",[ConstructionsMap]),
    % ?MYLOG("xlh","================= 28401:~p~n",[{Constructions,Serverids}]),
    % ?MYLOG("xlh","================= 28401:~p~n",[{Scene,ConType,BlServer,Pblserver,SendL,RecieveStatus,JoinNum,MonInfo}]),
    {ok, BinData} = pt_284:write(28401, [Scene,ConType,BlCamp,PblCamp,SendL,RecieveStatus,JoinNum,MonInfo]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 伤害排名
%% -----------------------------------------------------------------
get_rank_info(State, _ServerId, RoleId, Scene, MonId) ->
    #sanctuary_state_local{
        zone_id = ZoneId,
        san_list = SanList, 
        san_type = Santype, 
        enemy_server = Serverids} = State,
    [H|_] = Serverids,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
        #c_cons_state{mon_state = Mons} -> skip;
        _ -> Mons = []
    end,
    case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
        #c_mon_state{rank_list = RankList} -> RankList;
        _ -> RankList = []
    end,
    case data_cluster_sanctuary:get_san_value(kill_log_num) of
        Num when is_integer(Num) -> skip;
        _ -> Num = 20
    end,
    RealSendL = lists:sublist(RankList, Num),
    {ok, BinData} = pt_284:write(28403, [MonId, RealSendL]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 击杀记录
%% -----------------------------------------------------------------
get_mon_pk_log(State, RoleId, Scene, MonId) ->
    #sanctuary_state_local{
        zone_id = ZoneId,
        san_list = SanList, 
        san_type = Santype, 
        enemy_server = Serverids} = State,
    [H|_] = Serverids,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} -> ConstructionsMap;
        _ -> ConstructionsMap = #{}
    end,
    Constructions = maps:get({ZoneId,H}, ConstructionsMap, []),
    case lists:keyfind(Scene, #c_cons_state.scene_id, Constructions) of
        #c_cons_state{mon_state = Mons} -> skip;
        _ -> Mons = []
    end,
    case lists:keyfind(MonId, #c_mon_state.mon_id, Mons) of
        #c_mon_state{kill_log = KillLog} -> KillLog;
        _ -> KillLog = []
    end,
    {ok, BinData} = pt_284:write(28412, [Scene, MonId, KillLog]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 初始化回调
%% -----------------------------------------------------------------
init_after(State, ZoneId, SanList, Santype, EnemyServerIds, BeginList, ServerInfo, BeginTime, EndTime, JoinMap, PointList, ProduceEndTime) ->
    OldRef = State#sanctuary_state_local.init_ref,
    util:cancel_timer(OldRef),
    NewList = lists:reverse(lists:keysort(6, PointList)),
    ServerId = config:get_server_id(),
    {_, ServerIds} = get_camp(ServerId, BeginList, {0, []}),
    Fun = fun({ServerNum, RoleId, Name, TemServerId, _KillPoint, _BossPoint, Total}, {Acc, Sum}) ->
        case lists:member(TemServerId, ServerIds) of
            true ->
                {[{Sum+1, ServerNum, RoleId, Name, Total}|Acc], Sum+1};
            _ ->
                {Acc, Sum}
        end
    end,
    {RankList, _} = lists:foldl(Fun, {[], 0}, NewList),
    State#sanctuary_state_local{
        zone_id = ZoneId
        ,is_init = ?INIT_SUCCESS
        ,init_ref = undefined
        ,san_list = SanList
        ,san_type = Santype
        ,enemy_server = EnemyServerIds
        ,server_info = ServerInfo
        ,begin_scene_list = BeginList
        ,act_start_time = BeginTime
        ,act_end_time = EndTime
        ,join_map = JoinMap
        ,point_rank = RankList
        ,auction_begin_time = ProduceEndTime}.

%% -----------------------------------------------------------------
%% 接受跨服中心数据
%% -----------------------------------------------------------------
update_state(State, time, [BeginTime, EndTime]) ->
    State#sanctuary_state_local{
        act_start_time = BeginTime
        ,act_end_time = EndTime};
update_state(State, server, [Santype, EnemyServerIds, ServerInfo, BeginList, ZoneId]) ->
    Type = all_lv,
    case data_cluster_sanctuary:get_san_value(open_lv) of
        LimitLv when is_integer(LimitLv) ->
            Value = {LimitLv, 999};
        _-> Value = {200, 999}
    end,
    SendL = send_info_28400(EnemyServerIds, ServerInfo, BeginList),
    % ?PRINT(" =========      28400:~p~n",[SendL]),
    {ok, BinData} = pt_284:write(28400, [Santype, SendL]),
    lib_server_send:send_to_all(Type, Value, BinData),
    % ServerId = config:get_server_id(),
    % {Camp, _} = get_camp(ServerId, BeginList, {0, []}),
    % lib_player:update_all_player([{camp, Camp}]),
    % db:execute(io_lib:format(?SQL_REPLACE_SANTYPE_CAMP, [ServerId, Camp])),
    State#sanctuary_state_local{
        san_type = Santype
        ,zone_id = ZoneId
        ,enemy_server = EnemyServerIds
        ,server_info = ServerInfo
        ,begin_scene_list = BeginList};
update_state(State, san, [SanList]) ->
    State#sanctuary_state_local{san_list = SanList};
update_state(State, san_data, [{construction, H, Santype, Scene, Construction}]) when is_record(Construction, c_cons_state) ->
    #sanctuary_state_local{zone_id = ZoneId, san_list = SanList} = State,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San ->
            ConstructionList = maps:get({ZoneId,H}, ConstructionsMap, []),
            #c_cons_state{mon_state = [Mon|_]} = Construction,
            case lists:keyfind(Scene, #c_cons_state.scene_id, ConstructionList) of
                #c_cons_state{mon_state = OldMons} when is_record(Mon, c_mon_state) ->
                    #c_mon_state{mon_id = Monid} = Mon,
                    NewMons = lists:keystore(Monid, #c_mon_state.mon_id, OldMons, Mon),
                    NewCon = Construction#c_cons_state{mon_state = NewMons},
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, ConstructionList, NewCon),
                    NewSan = San#c_san_state{cons_state = maps:put({ZoneId, H}, NewCons, ConstructionsMap)},
                    % ?MYLOG("xlh_san","Mon:~p~n",[Mon]),
                    NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan);
                _ ->
                    NewSanList = SanList
            end;
        _ ->
            NewSanList = SanList
    end,
    State#sanctuary_state_local{san_list = NewSanList};
update_state(State, san_data, [{role_recieve, H, Santype, Scene, [{RoleId, Time}|_]}]) ->
    #sanctuary_state_local{zone_id = ZoneId, san_list = SanList} = State,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San ->
            ConstructionList = maps:get({ZoneId,H}, ConstructionsMap, []),
            case lists:keyfind(Scene, #c_cons_state.scene_id, ConstructionList) of
                #c_cons_state{role_recieve = RecieveList} = Construction ->
                    NewRecieveList = lists:keystore(RoleId, 1, RecieveList, {RoleId, Time}),
                    NewCon = Construction#c_cons_state{role_recieve = NewRecieveList},
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, ConstructionList, NewCon),
                    NewSan = San#c_san_state{cons_state = maps:put({ZoneId, H}, NewCons, ConstructionsMap)},
                    NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan);
                _ ->
                    NewSanList = SanList
            end;
        _ ->
            NewSanList = SanList
    end,
    State#sanctuary_state_local{san_list = NewSanList};
update_state(State, san_data, [{mons, H, Santype, Scene, Mon}]) when is_record(Mon, c_mon_state) ->
    #sanctuary_state_local{zone_id = ZoneId, san_list = SanList} = State,
    case lists:keyfind(Santype, #c_san_state.san_type, SanList) of
        #c_san_state{cons_state = ConstructionsMap} = San ->
            ConstructionList = maps:get({ZoneId,H}, ConstructionsMap, []),
            case lists:keyfind(Scene, #c_cons_state.scene_id, ConstructionList) of
                #c_cons_state{mon_state = OldMons} = Construction ->
                    #c_mon_state{mon_id = Monid} = Mon,
                    NewMons = lists:keystore(Monid, #c_mon_state.mon_id, OldMons, Mon),
                    NewCon = Construction#c_cons_state{mon_state = NewMons},
                    NewCons = lists:keystore(Scene, #c_cons_state.scene_id, ConstructionList, NewCon),
                    NewSan = San#c_san_state{cons_state = maps:put({ZoneId, H}, NewCons, ConstructionsMap)},
                    NewSanList = lists:keystore(Santype, #c_san_state.san_type, SanList, NewSan);
                _ ->
                    NewSanList = SanList
            end;
        _ ->
            NewSanList = SanList
    end,
    State#sanctuary_state_local{san_list = NewSanList};
update_state(State, san_data, _Data) ->
    % ?MYLOG("xlh_san","Data:~p~n",[Data]),
    State;
update_state(State, join, [JoinMap]) ->
    State#sanctuary_state_local{join_map = JoinMap};
update_state(State, point, [PointList]) ->
    % ?PRINT("PointList:~p~n",[PointList]),
    NewList = lists:reverse(lists:keysort(6, PointList)),
    ServerId = config:get_server_id(),
    {_, ServerIds} = get_camp(ServerId, State#sanctuary_state_local.begin_scene_list, {0, []}),
    Fun = fun({ServerNum, RoleId, Name, TemServerId, _KillPoint, _BossPoint, Total}, {Acc, Sum}) ->
        case lists:member(TemServerId, ServerIds) of
            true ->
                {[{Sum+1, ServerNum, RoleId, Name, Total}|Acc], Sum+1};
            _ ->
                {Acc, Sum}
        end
    end,
    {RankList, _} = lists:foldl(Fun, {[], 0}, NewList),

    State#sanctuary_state_local{point_rank = RankList};
update_state(State, auction_time, [ProduceEndTime]) ->
    #sanctuary_state_local{auction_end_ref = OldRef} = State,
    util:cancel_timer(OldRef),
    State#sanctuary_state_local{auction_begin_time = ProduceEndTime, role_auction = [], auction_info = [], auction_end_ref = undefined};
update_state(State, server_info, {ServerId, _, _, _, _} = Turple) ->
    #sanctuary_state_local{
        server_info = ServerInfo, san_type = Santype,
        enemy_server = EnemyServerIds, begin_scene_list = BeginList
    } = State,
    NewServerInfo = lists:keystore(ServerId, 1, ServerInfo, Turple),
    SendL = send_info_28400(EnemyServerIds, NewServerInfo, BeginList),
    Type = all_lv,
    case data_cluster_sanctuary:get_san_value(open_lv) of
        LimitLv when is_integer(LimitLv) ->
            Value = {LimitLv, 999};
        _-> Value = {200, 999}
    end,
    {ok, BinData} = pt_284:write(28400, [Santype, SendL]),
    lib_server_send:send_to_all(Type, Value, BinData),
    State#sanctuary_state_local{server_info = NewServerInfo};
update_state(State, _T, _A) -> ?ERR("mod_c_sanctuary_local _T:~p,_A:~p~n", [_T, _A]),State.

%% -----------------------------------------------------------------
%% 阵营聊天
%% -----------------------------------------------------------------
send_msg_to_camp(State, ServerId, BinData) ->
    #sanctuary_state_local{begin_scene_list = BeginList} = State,
    {_, ServerIds} = get_camp(ServerId, BeginList, {0, []}),
    % ?PRINT("Serverids:~p~n",[ServerIds]),
    Type = all_lv,
    case data_cluster_sanctuary:get_san_value(open_lv) of
        LimitLv when is_integer(LimitLv) ->
            Value = {LimitLv, 999};
        _-> Value = {200, 999}
    end,
    mod_clusters_node:apply_cast(?MODULE, send_msg_to_other_server, [ServerIds, ServerId, Type, Value, BinData]),
    lib_server_send:send_to_all(Type, Value, BinData),
    State.

%% -----------------------------------------------------------------
%% 贡献排行榜
%% -----------------------------------------------------------------
point_rank_info(State, RoleId) ->
    #sanctuary_state_local{point_rank = RankList} = State,
    case lists:keyfind(RoleId, 3, RankList) of
        {R, _, _, _, Val} -> 
            if
                Val == 0 ->
                    Rank = 0,Value = 0;
                true ->
                    Rank = R,Value = Val
            end;
        _ -> Rank = 0,Value = 0
    end,
    Fun = fun({TRank, ServerNum, TRoleId, Name, Total}, Acc) ->
        if
            Total == 0 ->
                Acc;
            true ->
                [{TRank, ServerNum, TRoleId, Name, Total}|Acc]
        end
    end,
    NewList = lists:foldl(Fun, [], RankList),
    {ok, BinData} = pt_284:write(28419, [Rank, Value, NewList]),
    % ?PRINT("Rank,:~p,~p~n",[Rank, RankList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 产出截止时间
%% -----------------------------------------------------------------
peoduce_end_time(State, RoleId) ->
    #sanctuary_state_local{auction_begin_time = ProduceEndTime} = State,
    {ok, BinData} = pt_284:write(28420, [ProduceEndTime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    State.

%% -----------------------------------------------------------------
%% 增加分红玩家
%% -----------------------------------------------------------------
add_auction_role(State, ProduceType, RoleIdList) ->
    #sanctuary_state_local{auction_info = AuctionInfo} = State,
    case lists:keyfind(ProduceType, 1, AuctionInfo) of
        {ProduceType, AuthenticationId, RoleIdL, Num} ->
            NewRoleIdList = lists:foldl(
                fun(RoleId, Acc) -> 
                    case lists:member(RoleId, RoleIdL) of
                        false -> [RoleId|Acc];
                        _ -> Acc
                    end
                end, [], RoleIdList),
            NewRoleIdL = RoleIdL ++ NewRoleIdList,
            if
                NewRoleIdList == [] ->
                    NewAuctionInfo = AuctionInfo;
                true ->
                    InAuctionPlayerList = [{AuthenticationId, PlayerId, 0, ?AUCTION_MOD_C_SANCTUARY}||PlayerId <- RoleIdList],
                    lib_act_join_api:add_authentication_player(InAuctionPlayerList),
                    NewAuctionInfo = lists:keystore(ProduceType, 1, AuctionInfo, {ProduceType, AuthenticationId, NewRoleIdL, Num})
            end;
        _ ->
            if
                RoleIdList == [] ->
                    NewAuctionInfo = AuctionInfo;
                true ->
                    AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
                    InAuctionPlayerList = [{AuthenticationId, PlayerId, 0, ?AUCTION_MOD_C_SANCTUARY}||PlayerId <- RoleIdList],
                    lib_act_join_api:add_authentication_player(InAuctionPlayerList),
                    NewAuctionInfo = lists:keystore(ProduceType, 1, AuctionInfo, {ProduceType, AuthenticationId, RoleIdList, 1})
            end
    end,
    %?PRINT("========== NewAuctionInfo:~p~n",[NewAuctionInfo]),
    State#sanctuary_state_local{auction_info = NewAuctionInfo}.

%% -----------------------------------------------------------------
%% 开始拍卖
%% -----------------------------------------------------------------
send_auction_thing(State, ProduceType, Produce, RoleIdList, StartTime, Source) ->
    #sanctuary_state_local{auction_info = AuctionInfo, auction_end_ref = Ref} = State,
    NowTime = utime:unixtime(),
    Wlv = util:get_world_lv(),
    Fun = fun({AuctionId, Num}, {Acc, Acc1, Acc2}) ->
        case data_auction:get_goods(AuctionId, Wlv) of
            #base_auction_goods{gtype_id = GtypeId, goods_num = GoodsNum, base_price = Price, gold_type = GoldType} ->
                Fun = fun(_, TemAcc) ->
                    [{GtypeId, GoodsNum, GoldType, Price}|TemAcc]
                end,
                NewAcc1 = lists:foldl(Fun, Acc1, lists:seq(1, Num)),
                {[{AuctionId, Num}|Acc], NewAcc1, [{0, GtypeId, Num*GoodsNum}|Acc2]};
            _ ->
                {Acc, Acc1, Acc2}
        end
    end,
    {NewList, GtypeIdL, LogList} = lists:foldl(Fun, {[], [], []}, Produce),
    lib_log_api:log_cluster_auction_produce(ProduceType, Source, LogList, RoleIdList),
    case lists:keyfind(ProduceType, 1, AuctionInfo) of
        {ProduceType, AuthenticationId, RoleIdL, Num} ->
            NewRoleIdList = lists:foldl(
                fun(RoleId, Acc) -> 
                    case lists:member(RoleId, RoleIdL) of
                        false -> [RoleId|Acc];
                        _ -> Acc
                    end
                end, [], RoleIdList),
            NewRoleIdL = RoleIdL++NewRoleIdList,
            NewAuctionInfo = lists:keystore(ProduceType, 1, AuctionInfo, {ProduceType, AuthenticationId, NewRoleIdL, Num+1});
        _ ->
            NewRoleIdL = RoleIdList,
            AuthenticationId = mod_id_create:get_new_id(?AUTHENTICATION_ID_CREATE),
            NewAuctionInfo = lists:keystore(ProduceType, 1, AuctionInfo, {ProduceType, AuthenticationId, NewRoleIdL, 1})
    end,
    {ok, BinData} = pt_284:write(28418, [ProduceType, erlang:length(NewRoleIdL), GtypeIdL]),
    lib_server_send:send_to_all(all_include, NewRoleIdL, BinData),
    
    InAuctionPlayerList = [{AuthenticationId, PlayerId, 0, ?AUCTION_MOD_C_SANCTUARY}||PlayerId <- RoleIdList],
    lib_act_join_api:add_authentication_player(InAuctionPlayerList),
    lib_auction_api:start_world_auction(?AUCTION_MOD_C_SANCTUARY, AuthenticationId, StartTime, NewList),
    % ?PRINT("======= InAuctionPlayerList:~p,NewRoleIdList:~p,RoleIdList:~p~n",[InAuctionPlayerList,NewRoleIdList,RoleIdList]),
    if
        Ref == undefined ->
            AddTime = data_auction:get_world_auction_duration(?AUCTION_MOD_C_SANCTUARY),
            NewRef = erlang:send_after(max(StartTime+AddTime+6 - NowTime, 5)*1000, self(), {send_mail_after_auction});
        true ->
            NewRef = Ref
    end,
    State#sanctuary_state_local{auction_info = NewAuctionInfo, auction_end_ref = NewRef}.

%% -----------------------------------------------------------------
%% 拍卖延时
%% -----------------------------------------------------------------
delay_auction(State, AuctionEndTime) ->
    #sanctuary_state_local{auction_end_ref = OldRef} = State,
    util:cancel_timer(OldRef),
    Time = AuctionEndTime - utime:unixtime(),
    NewRef = erlang:send_after(max(Time+6, 5)*1000, self(), {send_mail_after_auction}),
    State#sanctuary_state_local{auction_end_ref = NewRef}.

%% -----------------------------------------------------------------
%% 接受拍卖场分红数据
%% -----------------------------------------------------------------
%% List: [{玩家id,公会id,功能id,物品列表}]
%% 物品列表:[{钻石,0,数量},{搬钻,0，数量}]
role_auction_divident(State, AuthenticationId, List) ->
    % ?PRINT("========== List:~p~n",[List]),
    #sanctuary_state_local{auction_info = AuctionInfo, role_auction = RoleAuction} = State,
    NewRoleAuction = case lists:keyfind(AuthenticationId, 2, AuctionInfo) of
        {ProduceType, _, _, _} ->
            case lists:keyfind(ProduceType, 1, RoleAuction) of
                {ProduceType, RoleGoodsList, RecieveNum} ->
                    NewRoleGoodsList = calc_role_goods(RoleGoodsList, List),
                    lists:keystore(ProduceType, 1, RoleAuction, {ProduceType, NewRoleGoodsList, RecieveNum+1});
                _ ->
                    NewRoleGoodsList = calc_role_goods([], List),
                    lists:keystore(ProduceType, 1, RoleAuction, {ProduceType, NewRoleGoodsList, 1})
            end;
        _ ->
            RoleAuction
    end,
    State#sanctuary_state_local{role_auction = NewRoleAuction}.

%% -----------------------------------------------------------------
%% 邮件发放分红
%% -----------------------------------------------------------------
send_mail_after_auction(State) ->
    #sanctuary_state_local{auction_begin_time = ProduceEndTime, auction_info = AuctionInfo, 
        role_auction = RoleAuction, auction_end_ref = OldRef, point_rank = RankList, server_info = ServerInfo
        ,begin_scene_list = BeginList} = State,
    util:cancel_timer(OldRef),
    NowTime = utime:unixtime(),
    F1 = fun({PlayerId, GoodsList}, Acc) ->
        case lists:keyfind(?GOODS_SUBTYPE_GOLD, 1, GoodsList) of
            {_, _, GoldNum} -> skip;
            _ -> GoldNum = 0
        end,
        case lists:keyfind(?GOODS_SUBTYPE_BGOLD, 1, GoodsList) of
            {_, _, BGoldNum} -> skip;
            _ -> BGoldNum = 0
        end,
        [[PlayerId, ?AUCTION_MOD_C_SANCTUARY, GoldNum, BGoldNum, NowTime]|Acc]
    end,
    Fun = fun({ProduceType, _, _, Num}) ->
        case lists:keyfind(ProduceType, 1, RoleAuction) of
            {ProduceType, RoleGoodsList, TemNum} when TemNum >= Num ->
                BonusLogList = lists:foldl(F1, [], RoleGoodsList),
                mod_auction:add_bonus_log(BonusLogList),
                send_mail(ProduceType, RoleGoodsList);
            {ProduceType, RoleGoodsList, _TemNum} ->
                BonusLogList = lists:foldl(F1, [], RoleGoodsList),
                mod_auction:add_bonus_log(BonusLogList),
                % ?ERR("ProduceType:~p, Num:~p, TemNum:~p~n",[ProduceType, Num, TemNum]),
                send_mail(ProduceType, RoleGoodsList);
            _ ->
                skip
        end
    end,
    lists:foreach(Fun, AuctionInfo),
    Type = all_lv,
    case data_cluster_sanctuary:get_san_value(open_lv) of
        LimitLv when is_integer(LimitLv) ->
            Value = {LimitLv, 999};
        _-> Value = {200, 999}
    end,
    {ok, BinData} = pt_284:write(28420, [ProduceEndTime]),
    lib_server_send:send_to_all(Type, Value, BinData),
    do_log(BeginList, ServerInfo, RankList),
    State#sanctuary_state_local{auction_end_ref = undefined}.

%% -----------------------------------------------------------------
%% 贡献排行榜写入日志，邮件通知未获得分红玩家
%% -----------------------------------------------------------------
do_log(BeginList, ServerInfo, RankList) ->
    {_, ServerIds} = get_camp(config:get_server_id(), BeginList, {0, []}),
    PointLimit = calc_point_limit(ServerIds, ServerInfo),
    SelfNum = config:get_server_num(),
    F2 = fun({_, ServerNum, TRoleId, Name, Total}) ->
        if
            Total < PointLimit andalso SelfNum == ServerNum ->
                Title   = ?LAN_MSG(2840001),
                Content = uio:format(?LAN_MSG(2840002), [PointLimit]),
                lib_mail_api:send_sys_mail([TRoleId], Title, Content, []);
            true ->
                skip
        end,
        lib_log_api:log_cluster_point_rank(TRoleId, Name, ServerNum, Total)
    end,
    lists:foreach(F2, RankList).

%% -----------------------------------------------------------------
%% 发邮件
%% -----------------------------------------------------------------
send_mail(ProduceType, RoleGoodsList) ->
    if
        ProduceType == 0 ->
            TitleId = 28401, ContentId = 28402;
        true ->
            TitleId = 28403, ContentId = 28404
    end,
    % ?PRINT("========== RoleGoodsList:~p~n",[RoleGoodsList]),
    Title   = ?LAN_MSG(TitleId),
    Content = ?LAN_MSG(ContentId),
    F = fun({PlayerId, GoodsList}, Acc) ->
        case Acc rem 20 of
            0 -> timer:sleep(300);
            _ -> skip
        end,
        % ?PRINT("========== PlayerId:~p~n",[PlayerId]),
        lib_mail_api:send_sys_mail([PlayerId], Title, Content, GoodsList),
        Acc + 1
    end,
    lists:foldl(F, 1, RoleGoodsList).

%% -----------------------------------------------------------------
%% 获取怪物信息
%% -----------------------------------------------------------------
get_all_mon_info([], Acc) -> Acc;
get_all_mon_info([M|T], Acc) ->
    #c_mon_state{mon_id = Monid,reborn_time = RebornTime,mon_type = MonType, mon_lv = MonLv} = M,
    NewAcc = [{Monid,MonType,MonLv,RebornTime}|Acc],
    get_all_mon_info(T, NewAcc).

%% -----------------------------------------------------------------
%% 玩家分红组装
%% -----------------------------------------------------------------
calc_role_goods(RoleGoodsList, List) ->
    Fun = 
        fun([RoleId, _, ?AUCTION_MOD_C_SANCTUARY, GoodsL], Acc) ->
            case lists:keyfind(RoleId, 1, Acc) of
                {RoleId, Glist} ->
                    lists:keystore(RoleId, 1, Acc, {RoleId, ulists:object_list_plus_extra(GoodsL++Glist)});
                _ ->
                    lists:keystore(RoleId, 1, Acc, {RoleId, GoodsL})
            end;
        (_, Acc) -> Acc
    end,
    lists:foldl(Fun, RoleGoodsList, List).

%% -----------------------------------------------------------------
%% 组装数据给玩家
%% -----------------------------------------------------------------
send_info_28400(Serverids, ServerInfo, DivideScene) ->
    % ?PRINT("Serverids:~p,DivideScene:~p~n", [Serverids,DivideScene]),
    Fun = fun(TemServerId, Acc) ->
        case lists:keyfind(TemServerId, 1, ServerInfo) of
            {TemServerId, OpenTime, _WorldLv, ServerNum, ServerName} ->
                OpenDay = lib_c_sanctuary_mod:get_open_day(OpenTime);
            _ ->
                OpenDay = 0,ServerNum = 0, ServerName = <<>>
        end,
        F1 = fun
            ({TemSIdList, Scene}, Acc1) ->
                case lists:member(TemServerId, TemSIdList) of
                    true -> 
                        [{TemServerId, ServerNum, ServerName, OpenDay, Scene}|Acc1];
                    _ ->
                        Acc1
                end
        end,
        lists:foldl(F1, Acc, DivideScene)  
        % case lists:keyfind(TemServerId, 1, DivideScene) of
        %     {TemServerId, Scene} ->
        %         [{TemServerId, ServerNum, ServerName, OpenDay, Scene}|Acc];
        %     _ -> Acc
        % end
    end,
    lists:foldl(Fun, [], Serverids).

get_camp(_ServerId, [], {TemPoint, TServerIdL}) -> {TemPoint, TServerIdL};
get_camp(ServerId, [{TServerIdL, TemPoint}|BeginList], Acc) ->
    case lists:member(ServerId, TServerIdL) of
        true ->
            get_camp(ServerId, [], {TemPoint, lists:flatten(TServerIdL)});
        _ ->
            get_camp(ServerId, BeginList, Acc)
    end.

calc_point_limit(ServerIdList, ServerInfo) ->
    Fun = fun(ServerId, {Sum, Num}) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {ServerId, _, TWorldLv,_,_} -> skip;
            _ -> TWorldLv = 0
        end,
        {TWorldLv + Sum, Num + 1}
    end,
    {SumLv, Total} = lists:foldl(Fun, {0,0}, ServerIdList),
    WorldLv = if
        Total == 0 ->
            0;
        true ->
            SumLv div Total
    end,
    Fun1 = fun({Min, Max, _}) ->
        WorldLv >= Min andalso WorldLv =< Max
    end,
    PointLimitL = data_cluster_sanctuary:get_san_value(auction_point_limit),
    case ulists:find(Fun1, PointLimitL) of
        {ok, {_,_, PointLimit}} ->
            PointLimit;
        _ ->
            1
    end.

send_msg_to_other_server(ServerIds, ServerId, Type, Value, BinData) ->
    [mod_clusters_center:apply_cast(TemServerId, lib_server_send, send_to_all, [Type, Value, BinData]) || 
            TemServerId <- ServerIds, ServerId =/= TemServerId].
