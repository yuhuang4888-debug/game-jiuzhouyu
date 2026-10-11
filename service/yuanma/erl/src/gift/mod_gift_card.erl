%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created : 25 Jun 2018 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_gift_card).

%% API
-export([start_link/0, call_send_to_card_server/7, send_to_card_server/7]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-include("common.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").

-define(WAIT_REPONSE, 0).
-define(RECV_REPONSE, 1).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% call到礼包服务处理
call_send_to_card_server(Url, StrBody, RoleId, CardNo, T, C, Type) ->
    gen_server:call(?MODULE, {'call_send_to_card_server', Url, StrBody, RoleId, CardNo, T, C, Type}).

%% 到礼包服务处理
send_to_card_server(Url, StrBody, RoleId, CardNo, T, C, Type) ->
    gen_server:cast(?MODULE, {'send_to_card_server', Url, StrBody, RoleId, CardNo, T, C, Type}).

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
%% 发送给礼包卡服务器
do_handle_call({'call_send_to_card_server', Url, StrBody, RoleId, CardNo, T, C, Type}, _From, State) ->
    case catch httpc:request(post,
            {Url, [], "application/x-www-form-urlencoded", StrBody},
            [{timeout, 3000}],
            [{sync, true}]) of
        {ok, saved_to_file} ->
            ErrorCode = ?FAIL;
        {ok, Result} ->
            ErrorCode = do_send_res_goods_to_role(Result, RoleId, CardNo, T, C, Type);
        {error, Reason} ->
            ?ERR("do httpc request error : ~w", [Reason]),
            {ok, BinData} = pt_150:write(15087, [?FAIL, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            ErrorCode = ?FAIL;
        _Error ->
            ?ERR("do httpc request error : ~w", [_Error]),
            ErrorCode = ?FAIL
    end,
    Reply = case ErrorCode == ?ERRCODE(err150_card_ok_send) of
        true -> {ok, ?SUCCESS};
        false -> {false, ErrorCode}
    end,
    {reply, Reply, State};

do_handle_call(_Req, _From, State) ->
    ?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

%% 发送给礼包卡服务器
do_handle_cast({'send_to_card_server', Url, StrBody, RoleId, CardNo, T, C, Type}, State) ->
    case httpc:request(post,
        {Url, [], "application/x-www-form-urlencoded", StrBody},
        [{timeout, 3000}],
        [{sync, false}]) of
        {ok, RequestId} ->
            put_request_info(RequestId, ?WAIT_REPONSE, Url, RoleId, CardNo, T, C, Type),
            RequestId;
        Reason ->
            ?ERR("do httpc request error : ~w", [Reason]),
            {ok, BinData} = pt_150:write(15087, [?FAIL, []]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    ?PRINT("Msg:~p~n", [_Msg]),
    {noreply, State}.

do_handle_info({http, ReplyInfo}, State) ->
    % ?PRINT("http Code:~p ~n", [ReplyInfo]),
    http_reply(ReplyInfo),
    {noreply, State};

do_handle_info(_Info, State) ->
    ?PRINT("Info: ~p~n", [_Info]),
    {noreply, State}.

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
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, {error, _Reason}}) ->
    case erlang:get({card, RequestId}) of
        {RequestId, State, _Url, RoleId, CardNo, _T, _C} ->
            ?ERR("request_card_error:~p~n", [[RoleId, State, CardNo, _Reason]]),
            {ok, BinData} = pt_150:write(15087, [?FAIL]),
            lib_server_send:send_to_uid(RoleId, BinData);
        _ ->
            skip
    end,
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, Result}) ->
    %% 成功返回(有可能是返回失败的HTTP CODE，忽略结果)
    %% {_, _, Res} = Result,
    %% io:format("~p ~p Res:~ts~n", [?MODULE, ?LINE, Res]),
    send_res_goods_to_role(RequestId, Result),
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

%% 添加请求信息
put_request_info(RequestId, State, Url, RoleId, CardNo, T, C, Type) ->
    put({card, RequestId}, {RequestId, State, Url, RoleId, CardNo, T, C, Type}).

%% 清空请求信息
erase_request_info(RequestId) ->
    erase({card, RequestId}).

%% send_card_goods
send_res_goods_to_role(RequestId, Result) ->
%%  ?MYLOG("gift", "Result ~p~n", [Result]),
    case erlang:get({card, RequestId}) of
        {_RequestId, _State, _Url, RoleId, CardNo, T, C, Type} -> %% 找的到玩家的请求信息
            do_send_res_goods_to_role(Result, RoleId, CardNo, T, C, Type);
        _ ->
%%          ?MYLOG("gift", "Result ~p~n", [Result]),
            skip
    end.

do_send_res_goods_to_role(Result, RoleId, CardNo, T, C, Type) ->
    {_, _, Res} = Result,
    {ResCode, RewardList} = case catch mochijson2:decode(Res) of
        {'EXIT', _R} ->
            ?ERR("trigger card err:~p~n", [[Res, _R]]),
            {?FAIL, []};
        JsonTuple ->
            [Code] = lib_gift_card:extract_mochijson2([<<"ret">>], JsonTuple),
            % ?PRINT("send_res_goods_to_role CardNo:~p Code:~p ~n", [CardNo, Code]),
            case Code of
                0 -> %% 成功
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"gift_type">>], JsonTuple) of
                        [] ->
                            GiftType = "null";
                        [GiftTypeBin] ->
                            GiftType = binary_to_list(GiftTypeBin)
                    end,
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"gift_list">>], JsonTuple) of
                        [] ->
                            ?ERR("trigger card gift_list err:~p~n", []), GiftList = [];
                        [GiftBin] ->
                            case util:string_to_term(binary_to_list(GiftBin)) of
                                undefined ->
                                    ?ERR("trigger card gift_list err:~p~n", [GiftBin]),
                                    GiftList = [];
                                GiftList ->
                                    skip
                            end
                    end,
                    case lib_gift_card:extract_mochijson2([<<"data">>, <<"card_type">>], JsonTuple) of
                        [] -> CardType = 0;
                        [CardTypeBin] -> CardType = binary_to_integer(CardTypeBin)
                    end,
                    lib_log_api:log_gift_card_list(RoleId, CardNo, GiftType, GiftList),
                    %% 邮件内容
                    % {Title, Content} = if
                    %                     T == gift_card -> {utext:get(1020005), utext:get(1020006)};
                    %                     true -> {T, C}
                    %                 end,
                    % lib_mail_api:send_sys_mail([RoleId], Title, Content, GiftList),改为直接发送奖励
                    % lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = GiftList, type = gift_card}),
                    % {ok, _BinData} = pt_150:write(15087, [?ERRCODE(err150_card_ok_send), GiftList]),
                    % lib_server_send:send_to_uid(RoleId, _BinData),
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, ta_agent_fire, gift_card, [[CardNo, CardType, GiftType, true, 1]]),
                    {?ERRCODE(err150_card_ok_send), GiftList};
                4 -> %% 卡号不存在
                    {?ERRCODE(err150_gift_card_not_exist), []};
                5 -> %% 该渠道不能使用
                    {?ERRCODE(err150_gift_card_channel_can_not_use), []};
                7 -> %% 未到领取时间
                    {?ERRCODE(err150_gift_card_nobegin), []};
                8 -> %% 卡号已经过期
                    {?ERRCODE(err150_gift_card_overtime), []};
                9 -> %% 已经被使用
                    {?ERRCODE(err150_gift_card_has_trigger), []};
                10 -> %% 卡号使用次数不足
                    {?ERRCODE(err150_gift_card_use_count_not_enough), []};
                11 -> %% 您已经使用过同类型卡号
                    {?ERRCODE(err150_gift_card_has_use_same_card), []};
                12 -> %% 卡号长度不符合规则
                    {?ERRCODE(err150_gift_card_length_illegal), []};
                14 -> %% 充值金额不足
                    {?ERRCODE(err150_gift_card_racharge_not_enough), []};
                16 -> %% 等级不符合
                    {?ERRCODE(err150_lv_not_enough_gift), []};
                _ ->
%%                          io:format("~p ~p Args:~p~n", [?MODULE, ?LINE, [Code]]),
                    ?ERR("trigger card err:~p~n", [Code]),
                    {?FAIL, []}
            end
    end,
    % 是否成功触发
    case ResCode == ?ERRCODE(err150_card_ok_send) of
        true -> skip;
        false -> lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, ta_agent_fire, gift_card, [[CardNo, "", 0, false, ResCode]])
    end,
    case RewardList of
        [] -> 
            {ok, BinData} = pt_150:write(15087, [ResCode, []]),
            lib_server_send:send_to_uid(RoleId, BinData),
            skip;
        _ ->
            if
                Type == 1->  %% 1 直接发送
                    lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = RewardList, type = gift_card}),
                    {ok, BinData} = pt_150:write(15087, [ResCode, RewardList]),
                    lib_server_send:send_to_uid(RoleId, BinData);
                true ->  %% 2 发送奖励|
                    if
                        T == [] orelse  C == [] ->
                            Title = utext:get(1020009),
                            Content = utext:get(1020010);
                        true ->
                            Title = T,
                            Content = C
                    end,
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList)
            end  
    end,
    ResCode.