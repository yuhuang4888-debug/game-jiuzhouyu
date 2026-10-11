%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%% 网页请求服务:没有进程状态，请求返回后直接处理
%%% @end
%%% Created : 25 Jun 2018 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_http_server).

%% API
-export([
    start_link/0,
    do_http_request/4,
    do_http_request/5,
    do_http_request_mutiple/5,
    do_http_request_mutiple/6
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2,
    handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("errcode.hrl").

%% 结果返回状态
-define(WAIT_REPONSE, 0).     %% 等待返回
-define(RECV_REPONSE, 1).     %% 接受返回

%% 服务请求数据
-record(request, {
    type = 0,                 %% 请求类型:1:礼包卡;2:充值回归返利
    state = 0,                %% 请求状态:WAIT_REPONSE|RECV_REPONSE
    retry = 0,                %% 重操作次数:失败重新操作次数
    url = undefined,          %% url
    post_data = undefined,    %% post参数
    req_time = 0,             %% 请求时间
    req_data = undefined      %% 请求数据
}).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 请求http服务:默认是post
do_http_request(Type, Url, PostData, TypeArgs) ->
    do_http_request(Type, Url, post, PostData, TypeArgs).

%% 传方法的请求 post|get
do_http_request(Type, Url, Method, PostData, TypeArgs) ->
    gen_server:cast(?MODULE, {'do_http_request', Type, Url, Method, PostData, TypeArgs}).

%% 多个URLS请求
%% IsContinue默认是true
%% true:如果url请求失败，是继续往下请求剩余的urls。
%% false:上一个请求正确并返回正确处理结果后才继续请求,继续请求的操作在对应的功能逻辑处理。
%% 如果返回失败或者请求失败则马上中断，不请求剩下的urls。
do_http_request_mutiple(Type, Urls, Method, PostData, TypeArgs) ->
    gen_server:cast(?MODULE, {'do_http_request_mutiple', Type, Urls, Method, PostData, TypeArgs, true}).

do_http_request_mutiple(Type, Urls, Method, PostData, TypeArgs, IsContinue) ->
    gen_server:cast(?MODULE, {'do_http_request_mutiple', Type, Urls, Method, PostData, TypeArgs, IsContinue}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
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
            ?PRINT("Msg Error:~p~n", [[Msg, Res]]),
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
%%% Internal functions
%%%===================================================================
do_handle_call(_Req, _From, State) ->
    ?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%% post请求
do_handle_cast({'do_http_request', Type, Url, Method, PostData, TypeArgs}, State)
    when Method =:= get; Method =:= post ->
    RqTuple = get_http_request_tuple(Method, Url, PostData),
    case httpc:request(Method,
        RqTuple,
        [{timeout, 3000}],
        [{sync, false}])
    of
        {ok, ReqId} ->
            put_request_info(Type, ReqId, Url, PostData, TypeArgs),
            ReqId;
        Reason ->
            do_http_request_error(Type, Url, TypeArgs, Reason)
    end,
    {noreply, State};

%% 多个urls请求
do_handle_cast({'do_http_request_mutiple', Type, Urls, Method, PostData, TypeArgs, IsContinue}, State)
    when Method =:= get; Method =:= post ->
    case Urls of
        [] -> skip;
        [URL | TURLs] ->
            RealUrl = get_real_url(Type, URL),
            RqTuple = get_http_request_tuple(Method, RealUrl, PostData),
            case httpc:request(Method,
                RqTuple,
                [{timeout, 3000}],
                [{sync, false}])
            of
                {ok, ReqId} ->
                    put_request_info(Type, ReqId, RealUrl, PostData, TypeArgs ++ [TURLs]),
                    ReqId;
                Reason ->
                    do_http_request_error(Type, RealUrl, TypeArgs, Reason),
                    if
                        IsContinue ->
                            mod_http_server:do_http_request_mutiple(
                                Type, TURLs, Method, PostData, TypeArgs, IsContinue);
                        true ->
                            skip
                    end
            end
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?PRINT("Msg:~p~n", [_Msg]),
    {noreply, State}.

do_handle_info({http, ReplyInfo}, State) ->
    %% ?PRINT("ReplyInfo:~p~n", [ReplyInfo]),
    http_reply(ReplyInfo),
    {noreply, State};

do_handle_info(_Info, State) ->
    ?PRINT("Info: ~p~n", [_Info]),
    {noreply, State}.

%% 处理http回应
%% {http,  ReplyInfo}
%% ReplyInfo:
%% {ReqId, saved_to_file}
%% {ReqId, {error, Reason}}
%% {ReqId, Result}
%% {ReqId, stream_start, Headers}
%% {ReqId, stream_start, Headers, HandlerPid}
%% {ReqId, stream, BinBodyPart}
%% {ReqId, stream_end, Headers}
http_reply({ReqId, saved_to_file}) ->
    erase_request_info(ReqId),
    ignore;
http_reply({ReqId, {error, Reason}}) ->
    do_http_reply_error(ReqId, Reason),
    erase_request_info(ReqId),
    ignore;
http_reply({ReqId, Result}) ->
    do_http_reply_result(ReqId, Result),
    erase_request_info(ReqId),
    ok;
http_reply({ReqId, _, _}) ->
    erase_request_info(ReqId),
    ignore;
http_reply({ReqId, _, _, _}) ->
    erase_request_info(ReqId),
    ignore;
http_reply(_) ->
    ignore.

%% 保存请求信息
put_request_info(Type, ReqId, Url, PostData, TypeArgs) ->
    put_request_info(Type, ReqId, Url, 0, PostData, TypeArgs).

put_request_info(Type, ReqId, Url, Retry, PostData, TypeArgs) ->
    NowTime = utime:unixtime(),
    Req = #request{type = Type, state = ?WAIT_REPONSE,
        retry = Retry, url = Url, post_data = PostData,
        req_time = NowTime, req_data = TypeArgs},
    put(ReqId, Req).

%% 清空请求信息
erase_request_info(ReqId) ->
    erase(ReqId).

%% 错误处理
do_http_reply_error(ReqId, Reason) ->
    case erlang:get(ReqId) of
        %% 礼包请求
        #request{type = ?HTTP_REQ_GIFT_CARD, req_time = ReqTime, req_data = ReqData} ->
            [RoleId, CardNo|_] = ReqData,
            ?ERR("request_card_error:~p~n", [[RoleId, CardNo, ReqTime, Reason]]),
            {ok, BinData} = pt_150:write(15087, [?FAIL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        %% 返利
        #request{type = ?HTTP_REQ_COME_BACK, req_time = ReqTime, req_data = ReqData} ->
            ?ERR("request_comeback_error:~p~n", [[ReqData, ReqTime, Reason]]);
        %% 屏蔽词列表
        #request{type = ?HTTP_REQ_WORDS_LIST, retry = Retry,
            url = Url, post_data = PostData, req_time = ReqTime, req_data = ReqData} ->
            if
                Retry >= 2 -> %% 请求3次就放弃
                    ?ERR("ReqId,Retry, Url, ReqData, ReqTime, Reason:~p~n",
                        [[ReqId, Retry, Url, ReqData, ReqTime, Reason]]),
                    ?PRINT("ReqId,Retry, Url, ReqData, ReqTime, Reason:~p~n",
                        [[ReqId, Retry, Url, ReqData, ReqTime, Reason]]),
                    [OpType|_] = ReqData, %% 如果是初始化请求失败就初始化本地屏蔽词
                    if 
                        OpType == ?WORD_GET_ALL -> spawn(mod_word, update_local_filter_word, []); 
                        true -> skip 
                    end;
                true ->
                    retry_request_http(?HTTP_REQ_WORDS_LIST, Retry+1, Url, get, PostData, ReqData)
            end;
        %% 屏蔽词内容
        #request{type = ?HTTP_REQ_WORDS_GET, retry = Retry,
            url = Url, post_data = PostData, req_time = ReqTime, req_data = ReqData} ->
            if
                Retry >= 2 -> %% 请求3次就放弃
                    ?ERR("ReqId,Retry, Url, ReqData, ReqTime, Reason:~p~n",
                        [[ReqId, Retry, Url, ReqData, ReqTime, Reason]]),
                    ?PRINT("ReqId,Retry, Url, ReqData, ReqTime, Reason:~p~n",
                        [[ReqId, Retry, Url, ReqData, ReqTime, Reason]]),
                    skip;
                true ->
                    retry_request_http(?HTTP_REQ_WORDS_GET, Retry+1, Url, get, PostData, ReqData)
            end;
        _ ->
            skip
    end,
    ok.

%% 结果处理
do_http_reply_result(ReqId, Result) ->
    case erlang:get(ReqId) of
        #request{type = ?HTTP_REQ_GIFT_CARD, req_data = ReqData} -> %% 礼包请求
            lib_gift_card:do_gift_card_result(ReqData, Result);
        #request{type = ?HTTP_REQ_COME_BACK, req_data = ReqData} -> %% 回归返利
            lib_come_back:do_come_back_result(ReqData, Result);
        #request{type = ?HTTP_REQ_WORDS_LIST, req_data = ReqData} -> %% 屏蔽词列表
            lib_word:do_remote_words_list_result(ReqData, Result);
        #request{type = ?HTTP_REQ_WORDS_GET, req_data = ReqData} -> %% 屏蔽词列表
            lib_word:do_remote_words_get_result(ReqData, Result);
        _ ->
            skip
    end,
    ok.

%% 失败后再次请求
retry_request_http(Type, Retry, Url, Method, PostData, TypeArgs) ->
    RqTuple = get_http_request_tuple(Method, Url, PostData),
    case httpc:request(Method,
        RqTuple,
        [{timeout, 3000}],
        [{sync, false}])
    of
        {ok, ReqId} ->
            put_request_info(Type, ReqId, Url, Retry, PostData, TypeArgs),
            ReqId;
        Reason ->
            ?ERR("do httpc request error : ~w", [Reason]),
            ?PRINT("do httpc request error : ~w", [Reason])
    end.

%% 不同的方法请求的格式是不一样的
get_http_request_tuple(post, Url, PostData)->
    {Url, [], "application/x-www-form-urlencoded", PostData};
get_http_request_tuple(get, Url, _PostData) ->
    {Url, []}.

%% 获取具体的请求链接
get_real_url(?HTTP_REQ_WORDS_GET, URL) ->
    NowTime = utime:longunixtime(),
    lists:concat([URL, "?t=", NowTime]);
get_real_url(_, URL) ->
    URL.

%% 请求错误处理
do_http_request_error(?HTTP_REQ_GIFT_CARD = Type, _Url, TypeArgs, Reason) ->
    ?ERR("do httpc request error:~p~n", [[Type, Reason]]),
    ?PRINT("do httpc request error:~p~n", [[Type, Reason]]),
    [RoleId | _] = TypeArgs,
    {ok, BinData} = pt_150:write(15087, [?FAIL]),
    lib_server_send:send_to_uid(RoleId, BinData);
do_http_request_error(?HTTP_REQ_WORDS_LIST = Type, Url, TypeArgs, Reason) ->
    case TypeArgs of
        [?WORD_GET_ALL|_] -> %% 链接远端屏蔽词失败，初始化本地屏蔽词
            ?ERR("do httpc request error:~p~n", [[Type, Url, TypeArgs, Reason]]),
            ?PRINT("do httpc request error:~p~n", [[Type, Url, TypeArgs, Reason]]),
            spawn(mod_word, update_local_filter_word, []);
        _ ->
            ?ERR("do httpc request error:~p~n", [[Type, Url, TypeArgs, Reason]]),
            ?PRINT("do httpc request error:~p~n", [[Type, Url, TypeArgs, Reason]])
    end;
do_http_request_error(Type, Url, _TypeArgs, Reason) ->
    ?ERR("do httpc request error:~p~n", [[Type, Url, Reason]]),
    ?PRINT("do httpc request error:~p~n", [[Type, Url, Reason]]),
    ok.