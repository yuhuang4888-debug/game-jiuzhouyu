%%-----------------------------------------------------------------------------
%% @Module  :       mod_treasure_chest
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-25
%% @Description:    青云夺宝
%%-----------------------------------------------------------------------------
-module(mod_treasure_chest).

-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("treasure_chest.hrl").

-behaviour (gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    act_start/1,
    send_act_info/1,
    get_act_etime/0,
    refresh_chest_by_auto_line/2            %% 场景开启新线路的时候自动初始化宝箱
    ]).

-export([
    gm_start/1
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_start(ActId) ->
    gen_server:cast(?MODULE, {'act_start', ActId}).

send_act_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId}).

refresh_chest_by_auto_line(PoolId, CopyId) ->
    gen_server:cast(?MODULE, {'refresh_chest_by_auto_line', PoolId, CopyId}).

gm_start(Duration) ->
    gen_server:cast(?MODULE, {'gm_start', Duration}).

get_act_etime() ->
    gen_server:call(?MODULE, {'get_act_etime'}).

init([]) ->
    State = lib_treasure_chest:init_act(),
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, status_treasure_chest)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 活动开始
do_handle_cast({'act_start', ActId}, State) ->
    #status_treasure_chest{stime = Stime, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case NowTime >= Stime andalso NowTime =< Etime of
        true ->
            NewState = State;
        false ->
            NewState = lib_treasure_chest:act_start(ActId)
    end,
    {ok, NewState};

%% 发送活动信息
do_handle_cast({'send_act_info', RoleId}, State) ->
    #status_treasure_chest{status = Status, etime = Etime} = State,
    {ok, BinData} = pt_414:write(41404, [Status, Etime]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'refresh_chest_by_auto_line', PoolId, CopyId}, State) ->
    #status_treasure_chest{status = Status, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case Status == ?ACT_STATUS_OPEN andalso Etime > NowTime of
        true ->
            lib_treasure_chest:refresh_chest(State, PoolId, CopyId);
        false ->
            skip
    end,
    {ok, State};

%% GM开始活动
do_handle_cast({'gm_start', Duration}, State) ->
    #status_treasure_chest{stime = Stime, etime = Etime} = State,
    NowTime = utime:unixtime(),
    case NowTime >= Stime andalso NowTime =< Etime of
        true ->
            NewState = State;
        false ->
            NewState = lib_treasure_chest:gm_start(NowTime, NowTime + Duration)
    end,
    {ok, NewState};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, status_treasure_chest)->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

%% 提示刷新宝箱
do_handle_info('notice_refresh', State) ->
    #status_treasure_chest{notice_ref = NoticeRef, refresh_time = RefreshTime} = State,
    util:cancel_timer(NoticeRef),
    {ok, BinData} = pt_414:write(41402, [RefreshTime]),
    SceneId = data_treasure_chest:get_cfg(1),
    lib_server_send:send_to_scene(SceneId, 0, BinData),
    NewState = State#status_treasure_chest{notice_ref = []},
    {ok, NewState};

%% 刷新宝箱
do_handle_info('refresh', State) ->
    #status_treasure_chest{refresh_ref = OldRefreshRef} = State,
    util:cancel_timer(OldRefreshRef),
    NowTime = utime:unixtime(),
    RefreshTime = data_treasure_chest:get_cfg(2),
    NoticeRefreshTime = data_treasure_chest:get_cfg(8),
    NoticeRef = erlang:send_after(max(RefreshTime - NoticeRefreshTime, 1) * 1000, self(), 'notice_refresh'),
    RefreshRef = erlang:send_after(max(RefreshTime, 1) * 1000, self(), 'refresh'),
    lib_treasure_chest:refresh_chest(State),
    NewState = State#status_treasure_chest{notice_ref = NoticeRef, refresh_ref = RefreshRef, refresh_time = NowTime + RefreshTime},
    {ok, NewState};

%% 活动结束
do_handle_info('act_end', State) ->
    #status_treasure_chest{
        ref = Ref,
        notice_ref = NoticeRef,
        refresh_ref = RefreshRef
    } = State,
    util:cancel_timer(Ref),
    util:cancel_timer(NoticeRef),
    util:cancel_timer(RefreshRef),
    SceneId = data_treasure_chest:get_cfg(1),
    MonIds = data_treasure_chest:get_mids(),
    lib_mon:clear_scene_mon_by_mids(SceneId, 0, [], 1, MonIds),
    lib_activitycalen_api:success_end_activity(?MOD_TREASURE_CHEST),
    NewState = State#status_treasure_chest{
        status = ?ACT_STATUS_CLOSE,
        stime = 0,
        etime = 0,
        ref = [],
        notice_ref = [],
        refresh_ref = []
    },
    lib_chat:send_TV({all}, ?MOD_TREASURE_CHEST, 4, []),
    lib_treasure_chest:broadcast_act_info(NewState),
    {ok, NewState};

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'get_act_etime'}, State) ->
    #status_treasure_chest{status = ActStatus, etime = Etime} = State,
    case ActStatus == ?ACT_STATUS_CLOSE of
        true ->
            {ok, 0};
        false ->
            {ok, Etime}
    end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.