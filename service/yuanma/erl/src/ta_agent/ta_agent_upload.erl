%%% -------------------------------------------------------
%%% @author huangyongxing@yeah.net
%%% @doc
%%% TA分析系统服务端代理ta_agent中数据的封装、http请求管理等接口
%%% 本模块为ta_agent内部模块，外部功能系统不要调用本模块接口
%%% @end
%%% @since 2021-05-20
%%% -------------------------------------------------------
-module(ta_agent_upload).
-export([
        do_upload/5
        ,upload_all/5
        ,handle_response/1
        ,http_reply/1
    ]).

-include("common.hrl").

%% -------------------------------------------------------------------
%% 关于TA的Restful API接口
%% -------------------------------------------------------------------
%% Restful API 接口以 HTTP 的 POST 方法直接向 ThinkingAnalytics 后台传输数据
%% 有两种方式上报数据：
%% 1. form-data方式上报数据【数据写在requestBody中，有两个参数】
%%   私有化版本接口地址 - http://数据采集地址/sync_data
%%   a. 单条json数据
%%   参数 1：appid=项目的 APPID
%%   参数 2：data=JSON，UTF-8编码，需要urlencode
%%   b. 多条数据
%%   参数 1：appid=项目的 APPID
%%   参数 2：data_list=JSONArray，包含多条，UTF-8编码，需urlencode
%% 2. raw方式上报数据【数据写在requestBody中，是一个JSON对象】
%%   私有化版本接口地址 - http://数据采集地址/sync_json
%%   JSON数据包含两个字段：
%%   a. appid = 项目的 APPID
%%   b. data = JSON / JSONArray
%%   【注意，TA文档中未提及是否需要做urlencode，如果采用此方式需要与对方核实】
%% 注：如果添加debug=1参数，则为TA系统的调试模式，会返回出错信息，code为0表示正常。
%%     正式环境不要使用，应该性能会比较差（可能数据也不入库）
%% -------------------------------------------------------------------

%% 单次上报最大数量
-define(UPLOAD_COST_ONCE_MAX, 10).

%% -------------------------------------------------------------------
%% 重试管理相关参数
%% -------------------------------------------------------------------
%% 上报数据最大重试次数，超出则丢弃
-define(MAX_TRY_TIMES, 3).

-define(STATE_WAIT_REPONSE, 0).     % 等待响应状态
-define(STATE_GOT_REPONSE, 1).      % 已获得响应状态

-define(REQUEST_KEY(RequestId), {request, RequestId}).
%% -------------------------------------------------------------------

%% 发起请求后，数据缓存信息
-record(request_info, {
        id = 0
        ,body = <<>>
        ,state = ?STATE_WAIT_REPONSE
        ,try_times = 0
    }).

%% 进行数据上报，处理缓存池数据
%% -> NewCacheNormalQueue
do_upload(CacheNormalQueue, SyncUrl, Branch, Testing, AppId) ->
    {OutList, NewCacheNormalQueue} = out_data(CacheNormalQueue),
    do_upload_request(SyncUrl, Branch, Testing, AppId, OutList),
    NewCacheNormalQueue.

out_data(CacheNormalQueue) ->
    OldLen = queue:len(CacheNormalQueue),
    CostNum = min(OldLen, ?UPLOAD_COST_ONCE_MAX),
    if
        CostNum =< 0 ->
            {[], CacheNormalQueue};
        OldLen =< CostNum ->    % 全部消耗
            {queue:to_list(CacheNormalQueue), queue:new()};
        true ->
            {CostQueue, RestQueue} = queue:split(CostNum, CacheNormalQueue),
            {queue:to_list(CostQueue), RestQueue}
    end.

%% 连续上报所有数据（关服之用）
upload_all(CacheNormalQueue, SyncUrl, Branch, Testing, AppId) ->
    List = queue:to_list(CacheNormalQueue),
    upload_batch(List, SyncUrl, Branch, Testing, AppId).

upload_batch(List = [_|_], SyncUrl, Branch, Testing, AppId) ->
    {PreList, TailList} = ulists:split(?UPLOAD_COST_ONCE_MAX, List),
    do_upload_request(SyncUrl, Branch, Testing, AppId, PreList),
    upload_batch(TailList, SyncUrl, Branch, Testing, AppId);
upload_batch([], _SyncUrl, _Branch, _Testing, _AppId) ->
    ok.

%% 上报数据：发起http请求
%% 这里采用form-data方式上报数据
%% 【
%% 根据官方curl示例，使用curl --data，
%% 所以这里POST提交数据的enctype编码格式，应还是
%% "application/x-www-form-urlencoded"，而非"multipart/form-data"
%% 】
do_upload_request(SyncUrl, Branch, Testing, AppId, UploadList = [_|_]) ->
    % 上传了列表数据，里面子元素没按原来注释中的要求，导致mochijson2:encode/1出错，上报数据队列堆积。
    % 增加数据encode出错检测
    DataElem =
    try
        case upload_data_conv(UploadList) of
            [Data] ->
                DataJsonStr = iolist_to_binary(mochijson2:encode(Data)),
                {data, DataJsonStr};
            DataList ->
                DataJsonStr = iolist_to_binary(mochijson2:encode(DataList)),
                {data_list, DataJsonStr}
        end
    catch
        _ErrorClass:_Error ->
            error
    end,
    case DataElem of
        error -> ignore;
        _ ->
            RequestData = case Testing of
                true  -> [{appid, AppId}, DataElem, {branch , Branch}];
                false -> [{appid, AppId}, DataElem]
            end,
            RequestBody = iolist_to_binary(mochiweb_util:urlencode(RequestData)),
            RequestId = do_request(SyncUrl, RequestBody),
            case RequestId =/= error of
                true  ->
                    RequestInfo = #request_info{
                        id = RequestId, body = RequestBody,
                        try_times = 1,
                        state = ?STATE_WAIT_REPONSE
                    },
                    put_request_info(RequestInfo);
                false ->
                    ignore
            end
    end;
do_upload_request(_SyncUrl, _Branch, _Testing, _AppId, []) ->
    ok.

%% TA事件上报requestBody生成接口

%% 数据格式转换
%% 【由于time为秒级，批量管理时，
%% 可能time有多条数据是相同的，所以采用缓存减少time的转换计算】
upload_data_conv(UploadDataList) ->
    upload_data_conv_2(UploadDataList, #{}).

upload_data_conv_2([UploadData | DataList], TimeMap) ->
    #{'$time' := Time} = UploadData,
    case TimeMap of
        #{Time := TimeStrBin} ->
            NewTimeMap = TimeMap;
        _ ->
            TimeStr = utime:unixtime_to_timestr(Time),
            TimeStrBin = unicode:characters_to_binary(TimeStr),
            NewTimeMap = TimeMap#{Time => TimeStrBin}
    end,
    DataMvTime = maps:remove('$time', UploadData),
    Data = DataMvTime#{'#time' => TimeStrBin},
    [Data | upload_data_conv_2(DataList, NewTimeMap)];
upload_data_conv_2([], _TimeMap) ->
    [].

%% -------------------------------------------------------------------
%% 对response数据进行检查，重试或清理数据
%% -------------------------------------------------------------------

handle_response(SyncUrl) ->
    Keys = erlang:get_keys(),
    handle_response_2(SyncUrl, Keys, []).

handle_response_2(SyncUrl, [Key = ?REQUEST_KEY(OldRequestId) | Keys], Acc) ->
    case erlang:get(Key) of
        RequestInfo = #request_info{try_times = TryTimes, state = State, body = RequestBody} ->
            if
                TryTimes > ?MAX_TRY_TIMES ->
                    erase_request_info(OldRequestId),
                    handle_response_2(SyncUrl, Keys, Acc);
                State =:= ?STATE_WAIT_REPONSE ->
                    handle_response_2(SyncUrl, Keys, [Key | Acc]);
                State =:= ?STATE_GOT_REPONSE ->
                    NewKey =
                    try
                        RequestId = do_request(SyncUrl, RequestBody),
                        case RequestId =/= error of
                            true  ->
                                case TryTimes >= ?MAX_TRY_TIMES of
                                    true  -> undefined;
                                    false ->
                                        NewRequestInfo = RequestInfo#request_info{
                                            id = RequestId,
                                            try_times = TryTimes + 1,
                                            state = ?STATE_WAIT_REPONSE
                                        },
                                        put_request_info(NewRequestInfo),
                                        ?REQUEST_KEY(RequestId)
                                end;
                            false ->
                                undefined
                        end
                    catch
                        % ?EXCEPTION(_ErrorClass, _Error, _Stacktrace) ->
                        %     undefined
                        _ErrorClass:_Error ->
                            undefined
                    end,
                    erase_request_info(OldRequestId),
                    handle_response_2(SyncUrl, Keys, [NewKey | Acc])
            end;
        _ ->
            erase_request_info(OldRequestId),
            handle_response_2(SyncUrl, Keys, Acc)
    end;
handle_response_2(SyncUrl, [_OtherDataKey | Keys], Acc) ->
    handle_response_2(SyncUrl, Keys, Acc);
handle_response_2(_SyncUrl, [], Acc) ->
    Acc.

%% -------------------------------------------------------------------
%% request数据进程字典操作
%% -------------------------------------------------------------------

put_request_info(RequestInfo) ->
    #request_info{id = RequestId} = RequestInfo,
    Key = ?REQUEST_KEY(RequestId),
    erlang:put(Key, RequestInfo).

erase_request_info(RequestId) ->
    erlang:erase(?REQUEST_KEY(RequestId)).

%% -------------------------------------------------------------------
%% request http回应处理
%% -------------------------------------------------------------------

%% 处理http回应
% {http, ReplyInfo}, ReplyInfo:
% {RequestId, saved_to_file}
% {RequestId, {error, Reason}}
% {RequestId, Result}
% {RequestId, stream_start, Headers}
% {RequestId, stream_start, Headers, HandlerPid}
% {RequestId, stream, BinBodyPart}
% {RequestId, stream_end, Headers}
http_reply({RequestId, saved_to_file}) ->
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, {error, _Reason}}) ->
    % ?INFO_TTY("error: ~p", [_Reason]),
    case erlang:get(?REQUEST_KEY(RequestId)) of
        undefined ->
            ignore;
        RequestInfo = #request_info{try_times = TryTimes} when TryTimes < ?MAX_TRY_TIMES ->
            NewRequestInfo = RequestInfo#request_info{state = ?STATE_GOT_REPONSE},
            put_request_info(NewRequestInfo),
            ignore;
        _ ->
            erase_request_info(RequestId)
    end;
http_reply({RequestId, _Result}) ->
    % ?INFO_TTY("\nget RequestId [~w]\nResult:~tp", [RequestId, _Result]),
    %% 成功返回(有可能是返回失败的HTTP CODE，忽略结果)
    erase_request_info(RequestId),
    ok;
http_reply({RequestId, _, _}) ->
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, _, _, _}) ->
    erase_request_info(RequestId),
    ignore;
http_reply(_) ->
    ignore.

%% -------------------------------------------------------------------
%% 异步发起http request
%% -------------------------------------------------------------------
do_request(Url, RequestBody) ->
    UrlStr = util:make_sure_list(Url),
    % ?INFO("do request, url:~p, url_str:~p, requestBody:~p", [Url, UrlStr, RequestBody]),
    % ?INFO("do request, url:~p, requestBody:~p", [Url, RequestBody]),
    % 对于https访问，如果web服务器使用没有在CA机构注册的自定义ssl证书，
    % 需要在https客户端（erlang端），添加对应客户端证书，才能做ssl验证。
    % 否则只能使用 {ssl,[{verify,verify_none}]} 参数跳过证书验证，失去使用https的意义。
    % case httpc:request(post,
    %         {Url, [], "application/x-www-form-urlencoded", RequestBody},
    %         [{timeout, 5000}, {ssl,[{verify,verify_none}]}],
    %         [{sync, false}]
    %     ) of
    case httpc:request(post,
            {UrlStr, [], "application/x-www-form-urlencoded", RequestBody},
            [{timeout, 10000}],
            [{sync, false}]) of
        {ok, RequestId} ->
            RequestId;
        {error, Reason} ->
            ?ERR("do httpc request error: ~w", [Reason]),
            error
    end.

