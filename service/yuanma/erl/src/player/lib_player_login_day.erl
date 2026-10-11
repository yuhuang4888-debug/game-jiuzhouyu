%% ---------------------------------------------------------------------------
%% @doc lib_player_login_day
%% @author liuxl
%% @since  
%% @deprecated  角色登陆天数统计
%% ---------------------------------------------------------------------------
-module(lib_player_login_day).
-compile(export_all).
-include("common.hrl").
-include("daily.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

login(PS, LoginType) ->
    #player_status{id = RoleId} = PS,
    Sql = usql:select(player_login_day, [login_days, days_utime, first_log_time, days_detail], [{id, RoleId}], 1),
    case db:get_row(Sql) of 
        [LoginDays, DaysUtime, FirstLogTime, LoginDaysDetail] -> ok;
        _ -> LoginDays = 0, DaysUtime = 0, FirstLogTime = 0, LoginDaysDetail = <<>>
    end,
    %?MYLOG("lxl", "login_days:~p~n", [{LoginDays, DaysUtime, FirstLogTime, LoginDaysDetail}]),
    LoginDaysStatus = #login_days_status{login_days = LoginDays, days_utime = DaysUtime, first_log_time = FirstLogTime, login_days_detail = LoginDaysDetail},
    NewPS = PS#player_status{login_days_status = LoginDaysStatus},
    case LoginType == ?ONHOOK_AGENT_LOGIN of 
        true -> NewPS;
        _ ->
            update_login_days(NewPS)
    end.

relogin(PS) ->
	update_login_days(PS).


get_player_login_days(PS) ->
	PS#player_status.login_days_status#login_days_status.login_days.

%% 获取时间段内的登录天数
%% StartTime：时间戳|{{年,月,日},{时,分,秒}}
%lib_player:apply_cast(4294967321, 2, lib_player_login_day, get_login_days_since_start_time, [utime:unixdate()-4*86400]).
get_login_days_since_start_time(PS, StartTime) ->
    get_login_days_since_start_time(PS, StartTime, utime:unixtime()).

get_login_days_since_start_time(PS, StartTime, EndTime) ->
    StartUnixDate = utime:unixdate(to_timestamp(StartTime)),
    EndUnixDate = utime:unixdate(to_timestamp(EndTime)),
    NowUnixDate = utime:unixdate(),
    #player_status{
        login_days_status = #login_days_status{login_days = LoginDays, first_log_time = FirstLogTime, login_days_detail = LoginDaysDetail}
    } = PS,
    if
        StartUnixDate =< FirstLogTime andalso EndUnixDate >= NowUnixDate -> 
            %?PRINT("get_login_days_since_start_time LoginDays : ~p~n", [LoginDays]),
            LoginDays;
        true ->
            Days = count_login_days_range_time(FirstLogTime, StartUnixDate, EndUnixDate, LoginDaysDetail),
            %?PRINT("get_login_days_since_start_time Days : ~p~n", [Days]),
            Days
    end.

%% 最近几天是否有登陆
is_recently_login(PS, Days) ->
    EndUnixDate = utime:unixdate(),
    StartUnixDate = EndUnixDate - Days*?ONE_DAY_SECONDS,
    case get_login_days_since_start_time(PS, StartUnixDate, EndUnixDate) > 0 of 
        true -> true; _ -> false
    end.


%% 每天触发
daily_timer(?TWELVE = Clock) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> 
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, daily_timer, [Clock]),
            timer:sleep(100)
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok;
daily_timer(_Clock) ->
    ok.

daily_timer(#player_status{online = ?ONLINE_ON} = PS, ?TWELVE) -> 
    NewPS = update_login_days(PS),
    %?PRINT("daily_timer #################### ~n", []),
    LastPS = dispatch_login_days_change(NewPS),
    {ok, LastPS};
daily_timer(PS, _Clock) -> 
    {ok, PS}.

%% 秘籍更新累积天数，往前加数据
pp_gm_update_login_day(PS) ->
    #player_status{id = RoleId, login_days_status = LoginDaysStatus} = PS,
    #login_days_status{login_days = LoginDays, days_utime = DaysUtime, first_log_time = FirstLogTime, login_days_detail = LoginDaysDetail} = LoginDaysStatus,
    NewFirstLogTime = FirstLogTime - ?ONE_DAY_SECONDS,
    NewLoginDays = LoginDays + 1,
    NewLoginDaysDetail = list_to_binary([<<3:4, 1:4>>, LoginDaysDetail]),
    Sql = usql:replace(player_login_day, [id, login_days, days_utime, first_log_time, days_detail], [[RoleId, NewLoginDays, DaysUtime, NewFirstLogTime, NewLoginDaysDetail]]),
    db:execute(Sql),
    NewLoginDaysStatus = LoginDaysStatus#login_days_status{login_days = NewLoginDays, first_log_time = NewFirstLogTime, login_days_detail = NewLoginDaysDetail},
	PS1 = PS#player_status{login_days_status = NewLoginDaysStatus},
	%?PRINT("pp_gm_update_login_day :~p~n", [{NewLoginDays, NewLoginDaysDetail}]),
    %% 秘籍更新，通知其他模块
    NewPS = dispatch_login_days_change(PS1),
	NewPS.

dispatch_login_days_change(PS) ->
    lib_task_api:update_login_days(PS, get_player_login_days(PS)),
    LastPS0 = lib_push_gift_api:update_login_days(PS),
    {ok, LastPS1} = lib_grow_welfare_api:login_day(LastPS0),
    LastPS = lib_envelope_rebate:login_day(LastPS1),
    LastPS.

update_login_days(PS) ->
    #player_status{id = RoleId, login_days_status = LoginDaysStatus} = PS,
    #login_days_status{login_days = LoginDays, days_utime = DaysUtime, first_log_time = FirstLogTime, login_days_detail = LoginDaysDetail} = LoginDaysStatus,
    NowDate = utime:unixdate(),
    DiffDays = ?IF(DaysUtime == 0, 1, utime:diff_days(DaysUtime, NowDate)),
    if
        DiffDays == 0 -> PS;
        true ->
            NewLoginDays = LoginDays + 1,
            NewDayUtime = NowDate,
            NewFirstLogTime = ?IF(FirstLogTime == 0, NowDate, FirstLogTime),
            NewLoginDaysDetail = update_login_days_details(DiffDays, LoginDaysDetail),
            Sql = usql:replace(player_login_day, [id, login_days, days_utime, first_log_time, days_detail], [[RoleId, NewLoginDays, NowDate, NewFirstLogTime, NewLoginDaysDetail]]),
            db:execute(Sql),
            %?PRINT("update_login_days :~p~n", [{NewLoginDays, NewLoginDaysDetail}]),
            NewLoginDaysStatus = LoginDaysStatus#login_days_status{login_days = NewLoginDays, days_utime = NewDayUtime, first_log_time = NewFirstLogTime, login_days_detail = NewLoginDaysDetail},
            PS#player_status{login_days_status = NewLoginDaysStatus}
    end.

%% 连续登陆
%% detail: 标志3对应的ascii码 "1,2,3,4,5,6,7,8,9"
%%         标志6对应的ascii码 "a,b,c,d,e...."
update_login_days_details(1, LoginDaysDetail) ->
    ByteSize = byte_size(LoginDaysDetail),
    case ByteSize == 0 of 
        true -> NewLoginDaysDetail = <<3:4, 1:4>>;
        _ ->
            HeadSize = ByteSize - 1,
            <<Head:HeadSize/binary, Tail/binary>> = LoginDaysDetail,
            case Tail of 
                <<3:4, Days:4>> when Days < 9 -> 
                    NewLoginDaysDetail = list_to_binary([Head, <<3:4, (Days+1):4>>]);
                _ -> 
                    NewLoginDaysDetail = list_to_binary([LoginDaysDetail, <<3:4, 1:4>>])
            end
    end,
    NewLoginDaysDetail;
%% 隔了N-1天重新登录
update_login_days_details(N, LoginDaysDetail) ->
    LogoutDays = N - 1, 
    Cnt = umath:ceil(LogoutDays/9),
    F = fun(_, {LeftLogoutDays, Acc}) ->
        if
            LeftLogoutDays == 0 -> {LeftLogoutDays, Acc};
            LeftLogoutDays >= 9 -> {LeftLogoutDays-9, [<<6:4,9:4>>|Acc]};
            true -> {0, [<<6:4,LeftLogoutDays:4>>|Acc]}
        end
    end,
    {_, BinList} = lists:foldl(F, {LogoutDays, []}, lists:seq(1, Cnt)),
    NewBinList = lists:reverse([<<3:4,1:4>>|BinList]),
    NewLoginDaysDetail = list_to_binary([LoginDaysDetail|NewBinList]),
    NewLoginDaysDetail.

count_login_days_range_time(FirstLogTime, StartUnixDate, EndUnixDate, LoginDaysDetail) ->
    StartIndex = (StartUnixDate - FirstLogTime) div ?ONE_DAY_SECONDS,
    EndIndex = (EndUnixDate - FirstLogTime) div ?ONE_DAY_SECONDS,
    count_login_days_range_time_helper(0, StartIndex, EndIndex, LoginDaysDetail, 0).


count_login_days_range_time_helper(CurIndex, StartIndex, EndIndex, LoginDaysDetail, Days) ->
    case LoginDaysDetail of 
        <<6:4, LogoutDays:4, LeftLoginDaysDetail/binary>> -> 
            NewCurIndex = CurIndex + LogoutDays,
            count_login_days_range_time_helper(NewCurIndex, StartIndex, EndIndex, LeftLoginDaysDetail, Days);
        <<3:4, LoginDays:4, LeftLoginDaysDetail/binary>> -> 
            NewCurIndex = CurIndex + LoginDays,
            %% 计算两区间交集数
            RangeMin = max(CurIndex, StartIndex),
            RangeMax = min(NewCurIndex, EndIndex+1),
            AddDays = max(0, RangeMax - RangeMin),
            if
                EndIndex < CurIndex -> %% 1:已超过查询结束条件 返回天数
                    Days + AddDays;
                true -> 
                    count_login_days_range_time_helper(NewCurIndex, StartIndex, EndIndex, LeftLoginDaysDetail, Days+AddDays)
            end;
        <<>> ->
            Days
    end.


to_timestamp(Time) when is_integer(Time) -> Time;
to_timestamp({{_Y, _M, _D}, {_H, _Min, _Sec}} = Time) ->
    utime:unixtime(Time);
to_timestamp(_) ->
    throw({error, err_timestamp}).

