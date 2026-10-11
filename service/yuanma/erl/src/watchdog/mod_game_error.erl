%% ---------------------------------------------------------------------------
%% @doc web版游戏错误日志
%% @author hek
%% @since  2018-5-17
%% @deprecated
%% @note 1.web版错误日志作为服务器本地txt错误日志的补充
%%       2.web版本通过后台查看汇总的各个服务器错误日志情况
%%       3.防止不必要的麻烦和潜在风险:?WEBERR/3:TXT版和Web版日志; ?ERR/2:TXT版日志
%% ---------------------------------------------------------------------------
-module(mod_game_error).

-include("common.hrl").
-include("php.hrl").
-include("def_fun.hrl").
-include("watchdog.hrl").
-include("game_error.hrl").
-include("figure.hrl").

%% API
-export([sys_error/5]).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SIGN_SYS,                1).            %% 类型：1系统
-define(SIGN_PLAYER,             2).            %% 类型：2玩家
-define(MAX_REASON_SIZE,      1000).            %% 单个错误日志最大尺度

-define(STATIS_DURATION,        60).            %% 统计时长(秒):1分钟10条
-define(DURATION_MAX_CNT,       10).            %% 统计时长内最大错误日志阀值：超过统计阀值，统计时长内不往web后台上传日志

-define(TOTAL_MAX_CNT,        1000).            %% 总计数量阀值：超过总阀值，关闭日志服务
-define(AUTO_RESUME_TIME,    30*60).            %% 超过阀值关闭服务后，自动恢复日志服务器时间(秒)

-define(IS_OPEN,                 1).            %% 日志开关

-define(KEY_ERROR_STATIS,   {?MODULE, error_statis}).   %% value {统计开始时间, 统计开始时间至当前数量}
-define(KEY_ERROR_TOTALCNT, {?MODULE, error_totalcnt}). %% value total_cnt::总计数量

%% 记录错误到管理后台
sys_error(0, Format, FormatArgs, Module, Line) ->
    case catch error(?SIGN_SYS, 0, Format, FormatArgs, Module, Line) of
        {'EXIT', R} -> ?ERR("sys_error:~p~n", [R]);
        _ -> ok
    end;
sys_error(PlayerInfo, Format, FormatArgs, Module, Line) when is_integer(PlayerInfo) orelse is_tuple(PlayerInfo)->
    case catch error(?SIGN_PLAYER, PlayerInfo, Format, FormatArgs, Module, Line) of
        {'EXIT', R} -> ?ERR("player_error:~p~n", [R]);
        _ -> ok
    end;
sys_error(_, _Format, _FormatArgs, _Module, _Line) ->
    ok.

error(Sign, SysOrPlayerInfo, Format, FormatArgs, Module, Line) ->
    case misc:is_process_alive(misc:whereis_name(local, ?MODULE)) of
        false ->
            ?ERR("mod_game_error:~p~n", [havenot_started]),
            ok;
        true ->
            case error_statis_normal() of
                false -> ok;
                true -> do_error(Sign, SysOrPlayerInfo, Format, FormatArgs, Module, Line)
            end
    end.

%% 记录错误日志
do_error(Sign, SysOrPlayerInfo, Format, FormatArgs, Module, Line) ->
    ErrorTime  = utime:unixtime(),
    ServerNode = erlang:node(),
    ServerVer  = config:get_server_version(),
    Platform   = config:get_platform(),
    ServerId   = config:get_server_id(),
    ClsType    = case config:get_cls_type() of 0 -> game_node; _ -> center_node end,
    ExtraInfo = ulists:concat(["version:", ServerVer, ",", "platform:", Platform, ",",
                               "server_id:", ServerId, ",", "cls_type:", ClsType]),
    ExtraFormat = util:pack_format_str(true, Format, Module, Line, calendar:local_time()),
    ErrorReason = iolist_to_binary(io_lib:format(ExtraFormat, FormatArgs)),
    case check_is_send_error(ErrorReason) of
        false ->
            ?PRINT("pp_gm error:~p~n", [ok]),
            ok;
        _ ->
            ReasonSize = erlang:external_size(ErrorReason),
            {NewErrorReason, NewErrorReasonFormat} =
            case ReasonSize > ?MAX_REASON_SIZE of  %% 控制错误日志尺度
                false ->
                    {ErrorReason, ulists:concat(["## ~p error:~n", "## reason for error:~n ~p~n"])};
                true ->
                    SubB  = erlang:binary_part(ErrorReason, 0, ?MAX_REASON_SIZE),
                    {SubB, ulists:concat(["## ~p error:~n", "## reason for error:~n ~p~n"])}
            end,
            ErrType = exception,
            LastErrorReason = io_lib:format(NewErrorReasonFormat, [ErrType, NewErrorReason]),
            AddError = #{time => ErrorTime, server => ServerNode, info => util:make_sure_binary(ExtraInfo),
                         sign => Sign, player_id => SysOrPlayerInfo, error_reason => util:make_sure_binary(LastErrorReason)},
            gen_server:cast(?MODULE, {add_error, AddError}),
            ok
    end.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ================================= call back =================================
init([]) ->
    {ok, #error_state{}}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_call error:~p~n~p~n", [Request, Reason]),
            {reply, error, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, true, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_cast error:~p~n~p~n", [Msg, Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Reason} ->
            ?ERR("handle_info error:~p~n~p~n", [Info, Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ================================= private fun =================================
do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 记录日志
do_handle_cast({add_error, AddError}, #error_state{is_overflow_close = false} = State) ->
    #error_state{resume_ref = ResumeRef} = State,
    TotalCNT = get(?KEY_ERROR_TOTALCNT),
    ErrorTotalCNT = ?IF(is_integer(TotalCNT), TotalCNT, 0),
    case {error_statis_normal(), error_totalcnt_normal()} of
        {true, true} ->
            Url = lib_vsn:get_server_log_url(),
            send_to_monitor(Url, AddError),
            lib_watchdog_api:add_monitor(?WATCHDOG_GAME_ERR_CNT, ErrorTotalCNT);
        _ -> skip
    end,
    %% 超过总计阀值，关闭服务并启动自动恢复计时器
    case ErrorTotalCNT >=?TOTAL_MAX_CNT andalso not is_reference(ResumeRef) of
        false ->
            {noreply, State};
        true ->
            Ref = erlang:start_timer(?AUTO_RESUME_TIME*1000, self(), resume),
            lib_watchdog_api:add_monitor(?WATCHDOG_GAME_ERR_OVERFLOW, 1),
            ?INFO("mod_game_error:close ~p~n", [do]),
            ?PRINT("mod_game_error:close ~p~n", [do]),
            {noreply, State#error_state{is_overflow_close = true, resume_ref = Ref}}
    end;

do_handle_cast({'add_error', _AddError}, State) ->
    {noreply, State};
do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({timeout, ResumeRef, resume}, State = #error_state{resume_ref = ResumeRef}) ->
    ?INFO("mod_game_error:resume ~p~n", [do]),
    ?PRINT("mod_game_error:resume ~p~n", [do]),
    erase(?KEY_ERROR_TOTALCNT),
    lib_watchdog_api:add_monitor(?WATCHDOG_GAME_ERR_OVERFLOW, 0),
    lib_watchdog_api:add_monitor(?WATCHDOG_GAME_ERR_RESUME_CNT, 1),
    NewState = State#error_state{is_overflow_close = false, resume_ref = []},
    {noreply, NewState};

do_handle_info({http, ReplyInfo}, State) ->
    http_reply(ReplyInfo),
    {noreply, State};

do_handle_info(_Info, State) ->
    {noreply, State}.

%% 时间统计
error_statis_normal() ->
    case ?IS_OPEN of
        0 -> false;
        1 ->
            case do_error_statis_normal() of
                skip -> false;
                Res -> put(?KEY_ERROR_STATIS, Res), true
            end
    end.

do_error_statis_normal()->
    case get(?KEY_ERROR_STATIS) of
        undefined ->
            {utime:unixtime(), 1};
        {BeginTime, CNT} when CNT < ?DURATION_MAX_CNT ->
            {BeginTime, CNT+1};
        {BeginTime, _CNT} ->
            NowTime = utime:unixtime(),
            if
                NowTime >= BeginTime + ?STATIS_DURATION -> {NowTime, 1};
                true -> skip
            end
    end.

%% 错误记录总数
error_totalcnt_normal() ->
    ErrorTotalCNT =
    case get(?KEY_ERROR_TOTALCNT) of
        undefined -> 1;
        TotalCNT when TotalCNT < ?TOTAL_MAX_CNT-> TotalCNT + 1;
        _ -> skip
    end,
    case ErrorTotalCNT of
        CNT when is_integer(CNT) -> put(?KEY_ERROR_TOTALCNT, CNT), true;
        _ -> false
    end.

%% 发送到监控系统
send_to_monitor(Url, AddError) ->
    #{time:=ErrorTime, server:=ServerNode, info:=ExtraInfo, sign:=Sign,
      player_id:=SysOrPlayerInfo, error_reason:=LastErrorReason} = AddError,
    NewUrl =
    case lib_vsn:is_sy_internal_devp() of
        true -> Url;
        false ->
            NowTime = utime:unixtime(),
            AuthStr = util:md5(lists:concat([?APPKEY, NowTime, "get_server_errors"])),
            lists:concat([Url, "time=", NowTime, "&game=", ?GAME, "&method=get_server_errors&sign=", AuthStr])
    end,
    case Sign of
        ?SIGN_PLAYER ->
            case SysOrPlayerInfo of
                {PlayerId, PlayerName} -> ok;
                PlayerId when PlayerId =/= 0 ->
                    PlayerName = lib_offline_api:get_role_show_info(PlayerId, nofigure, #figure.name);
                PlayerId ->
                    PlayerName = "sys_error"
            end;
        _ ->
            PlayerId = 0, PlayerName = "sys_error"
    end,
    NewPlayerName = util:make_sure_binary(PlayerName),
    PostData = [{<<"time">>, ErrorTime}, {<<"server">>, ServerNode},
                {<<"info">>, ExtraInfo}, {<<"sign">>, Sign}, {<<"player_id">>, PlayerId},
                {<<"player_name">>, NewPlayerName}, {<<"error_reason">>, LastErrorReason}],
    %% 否则mochiweb_util:quote_plus/1时，碰到list的元素为list时会匹配报错
    JsonPostData = iolist_to_binary(mochijson2:encode(PostData)),
    EncodeParams = mochiweb_util:quote_plus(JsonPostData),
    _RequestId = do_request(NewUrl, EncodeParams),
    ok.

%% http请求
do_request(Url, EncodeParams) ->
    case httpc:request(post,
                       {Url, [], "application/x-www-form-urlencoded", EncodeParams},
                       [{timeout, 3000}], %% httpotion
                       [{sync, false}])   %% option
    of
        {ok, RequestId} -> RequestId;
        {error, Reason} ->
            ?ERR("do httpc request error : ~p~n", [Reason]),
            error
    end.

%% 处理http回应
%% {RequestId, saved_to_file}
%% {RequestId, {error, Reason}}
%% {RequestId, Result}
%% {RequestId, stream_start, Headers}
%% {RequestId, stream_start, Headers, HandlerPid}
%% {RequestId, stream, BinBodyPart}
%% {RequestId, stream_end, Headers}
http_reply({_ReqId, saved_to_file})    -> ignore;
http_reply({_ReqId, {error, _Reason}}) -> ignore;
http_reply({_ReqId, {_, _, _Res}})     ->
    % ?PRINT("http_res res:~p~n", [_Res]),
    ignore;
http_reply({_ReqId, _, _})             -> ignore;
http_reply({_ReqId, _, _, _})          -> ignore;
http_reply(_)                          -> ignore.

%% 检查是不是
check_is_send_error(ErrorReason) ->
    case lib_vsn:is_sy_internal_devp() of
        false -> true;
        true ->
            case re:run(ErrorReason, "pp_gm") of
                {match, _} -> false;
                _ -> true
            end
    end.