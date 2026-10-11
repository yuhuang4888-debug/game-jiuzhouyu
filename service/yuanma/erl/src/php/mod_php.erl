%% ---------------------------------------------------------------------------
%% @doc mod_php.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-14
%% @deprecated php对接
%% ---------------------------------------------------------------------------
-module(mod_php).
-export([]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).

-include("common.hrl").
-include("php.hrl").

%% 请求php
request(Url, StrBody, PhpRequest) ->
    gen_server:cast(?MODULE, {'request', Url, StrBody, PhpRequest}).

%% 请求php
request(Url, ContentType, StrBody, PhpRequest) ->
    gen_server:cast(?MODULE, {'request', Url, ContentType, StrBody, PhpRequest}).

%% 请求
request_get(Url, PhpRequest) ->
    gen_server:cast(?MODULE, {'request_get', Url, PhpRequest}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Req Error:~p~n", [[Req, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% call
%%%===================================================================
do_handle_call(_Req, _From, State) ->
    ?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%%%===================================================================
%%% cast
%%%===================================================================

%% post请求服务器
do_handle_cast({'request', Url, StrBody, PhpRequest}, State) ->
    case httpc:request(post,
        {Url, [], "application/x-www-form-urlencoded", StrBody},
        [{timeout, 3000}],
        [{sync, false}]) of
        {ok, RequestId} ->
            put_request(RequestId, PhpRequest),
            RequestId;
        Reason ->
            ?ERR("do httpc request error : ~w", [Reason])
    end,
    {noreply, State};

%% post请求服务器
do_handle_cast({'request', Url, ContentType, StrBody, PhpRequest}, State) ->
    case httpc:request(post,
        {Url, [], ContentType, StrBody},
        [{timeout, 3000}],
        [{sync, false}]) of
        {ok, RequestId} ->
            put_request(RequestId, PhpRequest),
            RequestId;
        Reason ->
            ?ERR("do httpc request error : ~w", [Reason])
    end,
    {noreply, State};

do_handle_cast({'request_get', Url, PhpRequest}, State) ->
    case httpc:request(get,
        {Url, []},
        [{timeout, 3000}],
        [{sync, false}]) of
        {ok, RequestId} ->
            % ?MYLOG("phphttp", "Url:~p PhpRequest:~p RequestId:~p ~n", [Url, PhpRequest, RequestId]),
            put_request(RequestId, PhpRequest),
            RequestId;
        Reason ->
            ?ERR("do httpc request_get error : ~w", [Reason])
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?MYLOG("phphttp", "Msg:~p~n", [_Msg]),
    {noreply, State}.

%%%===================================================================
%%% info
%%%===================================================================

do_handle_info({http, ReplyInfo}, State) ->
    % ?MYLOG("phphttp", "ReplyInfo:~p ~n", [ReplyInfo]),
    http_reply(ReplyInfo),
    {noreply, State};

do_handle_info(_Info, State) ->
    % ?MYLOG("phphttp", "Info: ~p~n", [_Info]),
    {noreply, State}.

%%%===================================================================
%%% other
%%%===================================================================

%% 处理http回应
%% {http,      ReplyInfo}, ReplyInfo:
%% {RequestId, saved_to_file}
%% {RequestId, {error, Reason}}
%% {RequestId, Result}
%% {RequestId, stream_start, Headers}
%% {RequestId, stream_start, Headers, HandlerPid}
%% {RequestId, stream, BinBodyPart}
%% {RequestId, stream_end, Headers}
http_reply({RequestId, saved_to_file}) ->
    erase_request(RequestId),
    ignore;
http_reply({RequestId, {error, _Reason}}) ->
    erase_request(RequestId),
    ignore;
http_reply({RequestId, Result}) ->
    %% 成功返回(有可能是返回失败的HTTP CODE，忽略结果)
    %% {_, _, Res} = Result,
    %% io:format("~p ~p Res:~ts~n", [?MODULE, ?LINE, Res]),
    http_reply_success(RequestId, Result),
    erase_request(RequestId),
    ok;
http_reply({RequestId, _, _}) ->
    erase_request(RequestId),
    ignore;
http_reply({RequestId, _, _, _}) ->
    erase_request(RequestId),
    ignore;
http_reply(_) ->
    ignore.

%% 处理http返回成功的状态
http_reply_success(RequestId, Result) ->
    case get_request(RequestId) of
        #php_request{mfa = Mfa} = Request ->
            {_, _, JsonData} = Result,
            % ?MYLOG("hjh", "Request:~p ~n", [Request]),
            % ?MYLOG("hjh_data", "Request:~p JsonData:~p ~n", [Request, JsonData]),
            case Mfa of
                {M, F, A} -> 
                    case catch erlang:apply(M, F, [Request, JsonData|A]) of
                        {'EXIT', Error} ->
                            ?ERR("http_reply_success RequestId:~p Request:~p Result:~p ~n", 
                                [RequestId, Request, Result]),
                            ?ERR("http_reply_success Error:~p ~n", 
                                [Error]);
                        _ ->
                            skip
                    end;
                _ -> 
                    skip
            end,
            ok;
        _ ->
            skip
    end,
    ok.

%% 获得请求信息
get_request(RequestId) ->
    erlang:get(?PHP_REQUEST(RequestId)).

%% 添加请求信息
put_request(RequestId, PhpRequest) ->
    put(?PHP_REQUEST(RequestId), PhpRequest#php_request{request_id = RequestId}).

%% 清空请求信息
erase_request(RequestId) ->
    erase(?PHP_REQUEST(RequestId)).