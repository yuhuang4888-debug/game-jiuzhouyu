%%%-----------------------------------
%%% @Module  : mod_kf_1vN_mgr
%%% @Email   : ming_up@foxmail.com
%%% @Created : 2018.1.24
%%% @Description: 跨服1vN(跨服中心)
%%%-----------------------------------
-module(mod_kf_1vN_mgr).

-include("common.hrl").
-include("record.hrl").
-include("kf_1vN.hrl").

%% API
-export([start_link/0, check_open/0, ac_end/0]).
-export([gm_start_1/3, gm_start_2/2, reset_sign_time/0]).

%% gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% 进程启动
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 检查是否开启活动
check_open() -> 
    gen_server:cast(?MODULE, check_open).

gm_start_1(SignTime, Race1PreTime, Race1Time) -> 
    gen_server:cast(?MODULE, {gm_start_1, SignTime, Race1PreTime, Race1Time}).

gm_start_2(Race2PreTime, Race2Time) -> 
    gen_server:cast(?MODULE, {gm_start_2, Race2PreTime, Race2Time}).

ac_end() -> 
    gen_server:cast(?MODULE, ac_end).

reset_sign_time() -> 
    gen_server:cast(?MODULE, reset_sign_time).

%% 初始化
init([]) ->
    AcIds    = data_kf_1vN:get_ac_ids(),
    Now      = utime:unixtime(),
    DateTime = utime:unixdate(Now),
    Week     = utime:day_of_week(Now),
    State = case check_is_open(AcIds, Week, DateTime, Now) of
        false -> 
             #kf_1vN_info{
                all_time = #kf_1vN_time{},
                stage = ?KF_1VN_FREE,
                state = ?KF_1VN_STATE_WAIT};
        {true, _} -> 
            #kf_1vN_info{
                all_time = #kf_1vN_time{},
                stage = ?KF_1VN_FREE,
                state = ?KF_1VN_STATE_WAIT}
    end,
    {ok, State}.

handle_call(_Request, _From, State) ->
    ?ERR("Handle unkown request[~p]~n", [_Request]),
    Reply = ok,
    {reply, Reply, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle msg[~p] error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast(check_open, State) ->
    #kf_1vN_info{stage=Stage} = State,
    %?PRINT("check open ~w~n", [Stage]),
    case Stage of
        ?KF_1VN_FREE -> 
            AcIds = data_kf_1vN:get_ac_ids(),
            Now = utime:unixtime(),
            DateTime = utime:unixdate(Now),
            Week = utime:day_of_week(Now),
            case check_is_open(AcIds, Week, DateTime, Now) of
                false -> {noreply, State};
                {true, AcR} -> 
                    State1 = init_state(AcR, DateTime, State),
                    self() ! {stage_change, ?KF_1VN_SIGN},
                    {noreply, State1#kf_1vN_info{stage=?KF_1VN_SIGN}}
            end;
        _ -> {noreply, State}
    end;

do_handle_cast({gm_start_1, SignTime, Race1PreTime, Race1Time}, State) ->
    % ?PRINT("gm_start_1 ~w~n", [{SignTime, Race1PreTime, Race1Time}]),
    #kf_1vN_info{ref=ORef} = State,
    util:cancel_timer(ORef),
    Now = utime:unixtime(),
    Kf1vNTime = #kf_1vN_time{
        sign_start=Now,
        race_1_pre_start=Now+SignTime, 
        race_1_start=Now+SignTime+Race1PreTime,
        race_1_end=Now+SignTime+Race1PreTime+Race1Time,
        race_2_pre_start=Now+SignTime+Race1PreTime+Race1Time+30,
        race_2_start=Now+SignTime+Race1PreTime+Race1Time+30+30,
        race_2_end=Now+SignTime+Race1PreTime+Race1Time+30+30+300
    },
    mod_kf_1vN:gm_start_1(),
    ?MYLOG("lzh1vn", "gm_start_1 SignTime:~p Race1PreTime:~p, Race1Time:~p ~n", [SignTime, Race1PreTime, Race1Time]),
    Ref = erlang:send_after(50, self(), {stage_change, ?KF_1VN_SIGN}),
    {noreply, State#kf_1vN_info{ac_id=1, all_time=Kf1vNTime, ref=Ref}};

do_handle_cast({gm_start_2, Race2PreTime, Race2Time}, State) ->
%%    ?PRINT("gm_start_2 ~w~n", [{Race2PreTime, Race2Time}]),
    #kf_1vN_info{all_time=Kf1vNTime, ref=Ref} = State,
    util:cancel_timer(Ref),
    Now = utime:unixtime(),
    Kf1vNTime1 = Kf1vNTime#kf_1vN_time{
        race_2_pre_start=Now,
        race_2_start=Now+Race2PreTime,
        race_2_end=Now+Race2PreTime+Race2Time
    },
    ?MYLOG("lzh1vn", "gm_start_2 Race2PreTime:~p, Race2Time:~p ~n", [Race2PreTime, Race2Time]),
    Ref1 = erlang:send_after(50, self(), {stage_change, ?KF_1VN_RACE_2_PRE}),
    {noreply, State#kf_1vN_info{ac_id=1, all_time=Kf1vNTime1, ref=Ref1}};

do_handle_cast(ac_end, State) ->
    #kf_1vN_info{ref=Ref} = State,
    util:cancel_timer(Ref),
    % mod_kf_1vN_auction:auction_start( 300 ),
    %%两天之后的0点开始
    Day2ZeroTime = utime:get_diff_day_standard_unixdate(2, 1),  %% 2天后的0点
    mod_kf_1vN_auction:auction_start(Day2ZeroTime - utime:unixtime()),
    {noreply, #kf_1vN_info{ac_id=1, stage=?KF_1VN_FREE, state=?KF_1VN_STATE_WAIT}};

do_handle_cast(reset_sign_time, State) -> 
    #kf_1vN_info{all_time=#kf_1vN_time{race_1_pre_start=Race1PreStart}, ref=Ref} = State,
    Now = utime:unixtime(),
    case Now < Race1PreStart of
        true -> 
            util:cancel_timer(Ref),
            Ref1 = erlang:send_after((Race1PreStart-Now)*1000, self(), {stage_change, ?KF_1VN_RACE_1_PRE}),
            {noreply, State#kf_1vN_info{ref=Ref1}};
        false -> skip
    end;

do_handle_cast(_Msg, State) ->
    ?ERR("Handle unkown msg[~p]~n", [_Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("Handle info[~p] error:~w~n", [Info, Err]),
            {noreply, State} 
    end.

%% 阶段转换
do_handle_info({stage_change, Stage}, State) ->
    % ?PRINT("stage_change ~w~n", [Stage]),
    #kf_1vN_info{ac_id=AcId} = State,
    #kf_1vN_time{sign_start=_SignStart, race_1_pre_start=Race1PreStart, race_1_start=Race1Start, race_1_end=Race1End,
        race_2_pre_start=_Race2PreStart, race_2_start=Race2Start, race_2_end=Race2End
    } = State#kf_1vN_info.all_time,
    
    Now = utime:unixtime(),
    Next = case Stage of
        ?KF_1VN_SIGN        -> {?KF_1VN_RACE_1_PRE, Race1PreStart-Now};
        ?KF_1VN_RACE_1_PRE  -> {?KF_1VN_RACE_1, Race1Start-Now};
        ?KF_1VN_RACE_1      -> {?KF_1VN_RACE_2_PRE, Race1End-Now};
        ?KF_1VN_RACE_2_PRE  -> {?KF_1VN_RACE_2, Race2Start-Now};
        ?KF_1VN_RACE_2      -> {?KF_1VN_FREE, Race2End-Now};
        %% ?KF_1VN_FREE 不处理，由mod_kf_1vN比赛结束后通知
        _ -> false
    end,
    case Next of
        {NextStage, TimeSec} -> 
            Now = utime:unixtime(),
            mod_kf_1vN:stage_change(Stage, Now, Now+TimeSec, AcId),
            % ?PRINT("NEXT ~w~n", [{Stage, NextStage, TimeSec}]),
            Ref1 = erlang:send_after(TimeSec*1000, self(), {stage_change, NextStage}),
            {noreply, State#kf_1vN_info{stage=Stage, ref=Ref1}};
        _ -> 
            {noreply, State}
    end;

do_handle_info(_Info, State) ->
    ?ERR("Handle unkown info[~p]~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

check_is_open([Id|T], Week, DateTime, Now) -> 
    case data_kf_1vN:get_info(Id) of
        #kf_1vN_time_cfg{open_week=OpenWeekL, signtime={Hour, Min}, optime={OpHour, OpMin}} = AcR -> 
            case lists:member(Week, OpenWeekL) of
                true -> 
                    SignBegin = DateTime+Hour*3600+Min*60,
                    OpTime = DateTime+OpHour*3600+OpMin*60,
                    if
                        Now >= SignBegin andalso Now < OpTime -> {true, AcR}; %% @return
                        true -> check_is_open(T, Week, DateTime, Now)
                    end;
                false -> check_is_open(T, Week, DateTime, Now)
            end;
        _ -> check_is_open(T, Week, DateTime, Now)
    end;
check_is_open(_, _, _, _) -> false.


init_state(AcR, DateTime, State) -> 
    #kf_1vN_time_cfg{id=AcId, signtime = {SHour, SMin}, optime = {OHour, OMin}, 
        race_1_pre = Race1PreTime, race_1 = Race1Time, 
        race_2_pre = Race2PreTime, race_2 = Race2Time} = AcR,
    SignStart = DateTime+SHour*3600+SMin*60,
    OpTime = DateTime+OHour*3600+OMin*60,
%%    ?PRINT("init_state ~w~n", [{SignStart, OpTime}]),
    AllTime = #kf_1vN_time{
        sign_start=SignStart,
        race_1_pre_start=OpTime, 
        race_1_start=OpTime+Race1PreTime,
        race_1_end=OpTime+Race1PreTime+Race1Time,
        race_2_pre_start=OpTime+Race1PreTime+Race1Time,
        race_2_start=OpTime+Race1PreTime+Race1Time+Race2PreTime,
        race_2_end=OpTime+Race1PreTime+Race1Time+Race2PreTime+Race2Time
    },
    State#kf_1vN_info{ac_id=AcId, all_time=AllTime}.
