%% ---------------------------------------------------------------------------
%% @doc mod_mail_queue

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/1/22 0022
%% @desc    邮件发送队列
%% ---------------------------------------------------------------------------
-module(mod_mail_queue).

-behaviour(gen_server).

%% API
-export([
      start_link/0
    , add/5
    , add/6
    , add_no_delay/5
    , stop/0
]).

%% gen_server callbacks

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("mail.hrl").

-record(state, {
      mail_queue_map = #{}              % #{EventId => [#mail_queue{}]}
    , error_queue_map = #{}
    , error_ref = []
    , error_check_times = 0
}).

-record(mail_queue, {
      event_id = 0
    , ref = []
    , queue = {[], []}
}).

-record(mail_info, {
      role_ids = []
    , gap_ms = 200
    , title = []
    , content = []
    , attachment = []
}).

%% ===========================
%%  Function Need Export
%% ===========================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 添加发送邮件到队列
%% @param EventId 各自的事件ID绑定自身的邮件发送定时器，尽量不要和他人的冲突，否则可能后面添加的邮件发送延后比较大
%%              建议使用功能模块ID作为EventId(如果有子功能可以使用{功能ID, 子功能})
add(EventId, RoleIdL, Title, Content, CmAttachment) ->
    add(EventId, RoleIdL, Title, Content, CmAttachment, 200).

%% 添加发送邮件到队列
%% 如果没有当前事件ID的邮件队列，会延时1~10s后开始进行发送，每个邮件发送间隔是 GapMS
%% 如果已拥有当前事件ID的邮件队列，会直接添加到待发送的邮件队列里，前面的邮件发送完毕后，新的邮件按照间隔GapMS发送
add(EventId, RoleIdL, Title, Content, CmAttachment, GapMS) ->
    DelayMS = urand:rand(1, 10) * 1000,
    case misc:is_process_alive(whereis(mod_mail_queue)) of
        true ->
            gen_server:cast(?MODULE, {'add', EventId, RoleIdL, Title, Content, CmAttachment, DelayMS, GapMS});
        _ ->
            default_send_mail(RoleIdL, Title, Content, CmAttachment, DelayMS, GapMS)
    end.

%% 不会延时1~10s进行发送，直接根据200ms每封邮件进行发送
%% 同一EventId下，会把之前的发送完之后才会开始
add_no_delay(EventId, RoleIdL, Title, Content, CmAttachment) ->
    case misc:is_process_alive(whereis(mod_mail_queue)) of
        true ->
            gen_server:cast(?MODULE, {'add_no_delay', EventId, RoleIdL, Title, Content, CmAttachment, 200});
        _ ->
            default_send_mail(RoleIdL, Title, Content, CmAttachment, 0, 200)
    end.

% 停服前调用
% 直接写入sql
stop() ->
    gen_server:call(?MODULE, 'stop', 5000).

%% ===========================
%% gen_server callbacks temples
%% ===========================
init(Args) ->
    ?DO_INIT(Args).
handle_call(Request, From, State) ->
    ?DO_HANDLE_CALL(Request, From, State).
handle_cast(Msg, State) ->
    ?DO_HANDLE_CAST(Msg, State).
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State).
terminate(Reason, State) ->
    ?DO_TERMINATE(Reason, State).
code_change(OldVsn, State, Extra) ->
    ?DO_CODE_CHANGE(OldVsn, State, Extra).

%% =============================
%% gen_server callbacks
%% =============================

do_init([]) ->
    {ok, #state{}}.

do_handle_call('stop', _From, State) ->
    {_, NewState} = do_handle_info('check_error_mail', State),
    #state{mail_queue_map = MailQueueMap, error_ref = ErrorRef} = NewState,
    util:cancel_timer(ErrorRef),
    F = fun({EventId, MailQueue}) ->
        #mail_queue{queue = MailInfoQueue, ref = Ref} = MailQueue,
        util:cancel_timer(Ref),
        [
            [
                lib_log_api:log_game_error(RoleId, 4, {EventId, RoleId, Title, Content, Attachment})
                ||RoleId<-RoleIdL
            ]||#mail_info{role_ids = RoleIdL, title = Title, content = Content, attachment = Attachment}<-queue:to_list(MailInfoQueue)
        ]
    end,
    lists:foreach(F, maps:to_list(MailQueueMap)),
    {reply, ok, #state{}};

do_handle_call(_Msg, _From, _State) ->
    no_match.

do_handle_cast({'add', EventId, RoleIdL, Title, Content, CmAttachment, DelayMS, GapMS}, State) ->
    #state{mail_queue_map = QueueMap} = State,
    case maps:get(EventId, QueueMap, false) of
        false ->
            Ref = util:send_after(undefined, DelayMS, self(), {'do_send', EventId}),
            MailInfo = #mail_info{role_ids = RoleIdL, gap_ms = GapMS, title = Title, content = Content, attachment = CmAttachment},
            NewMailQueue = #mail_queue{event_id = EventId, ref = Ref, queue = queue:in(MailInfo, {[], []})};
        MailQueue ->
            #mail_queue{queue = MailInfoQueue} = MailQueue,
            MailInfo = #mail_info{role_ids = RoleIdL, gap_ms = GapMS, title = Title, content = Content, attachment = CmAttachment},
            NewMailQueue = MailQueue#mail_queue{queue = queue:in(MailInfo, MailInfoQueue)}
    end,
    NewQueueMap = QueueMap#{EventId => NewMailQueue},
    NewState = State#state{mail_queue_map = NewQueueMap},
    {noreply, NewState};

do_handle_cast({'add_no_delay', EventId, RoleIdL, Title, Content, CmAttachment, GapMS}, State) ->
    #state{mail_queue_map = QueueMap} = State,
    case maps:get(EventId, QueueMap, false) of
        false ->
            MailInfo = #mail_info{role_ids = RoleIdL, gap_ms = GapMS, title = Title, content = Content, attachment = CmAttachment},
            NewMailQueue = #mail_queue{event_id = EventId, queue = queue:in(MailInfo, {[], []})},
            NewQueueMap = QueueMap#{EventId => NewMailQueue},
            NewState = State#state{mail_queue_map = NewQueueMap},
            do_handle_info({'do_send', EventId}, NewState);
        MailQueue ->
            #mail_queue{queue = MailInfoQueue} = MailQueue,
            MailInfo = #mail_info{role_ids = RoleIdL, gap_ms = GapMS, title = Title, content = Content, attachment = CmAttachment},
            NewMailQueue = MailQueue#mail_queue{queue = queue:in(MailInfo, MailInfoQueue)},
            NewQueueMap = QueueMap#{EventId => NewMailQueue},
            NewState = State#state{mail_queue_map = NewQueueMap},
            {noreply, NewState}
    end;

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info({'do_send', EventId}, State) ->
    #state{mail_queue_map = QueueMap, error_queue_map = ErrQueueMap, error_ref = ErrorRef} = State,
    case maps:get(EventId, QueueMap, false) of
        #mail_queue{queue = MailInfoQueue, ref = OldRef} = MailQueue ->
            util:cancel_timer(OldRef),
            case queue:out(MailInfoQueue) of
                {{value, MailInfo}, MailInfoQueueTmp} ->
                    #mail_info{role_ids = RoleIdL, title = Title, content = Content, attachment = Attachment, gap_ms = GapMS} = MailInfo,
                    case RoleIdL of
                        [Id|LastIdL] ->
                            %case catch ?PRINT("==== {[Id], Title, Content, Attachment} ~p ~n", [{[Id], Title, Content, Attachment}]) of
                            case catch lib_mail_api:send_sys_mail([Id], Title, Content, Attachment) of
                                {'EXIT', _} ->
                                    % 出现异常开启定时检测
                                    NewErrorRef = try_open_error_ref(ErrorRef),
                                    ErrorL = maps:get(EventId, ErrQueueMap, []),
                                    NewErrQueueMap = ErrQueueMap#{EventId => [{Id, Title, Content, Attachment}|ErrorL]};
                                _ ->
                                    NewErrorRef = ErrorRef,
                                    NewErrQueueMap = ErrQueueMap
                            end,
                            if
                                LastIdL == [] andalso MailInfoQueueTmp == {[], []} ->
                                    NewQueueMap = maps:remove(EventId, QueueMap);
                                LastIdL == [], MailInfoQueueTmp =/= {[], []} ->
                                    Ref = util:send_after(OldRef, GapMS, self(), {'do_send', EventId}),
                                    NewMailQueue = MailQueue#mail_queue{queue = MailInfoQueueTmp, ref = Ref},
                                    NewQueueMap = QueueMap#{EventId => NewMailQueue};
                                true ->
                                    Ref = util:send_after(OldRef, GapMS, self(), {'do_send', EventId}),
                                    NewMailInfo = MailInfo#mail_info{role_ids = LastIdL},
                                    NewMailQueue = MailQueue#mail_queue{queue = queue:in_r(NewMailInfo, MailInfoQueueTmp), ref = Ref},
                                    NewQueueMap = QueueMap#{EventId => NewMailQueue}
                            end,
                            NewState = State#state{mail_queue_map = NewQueueMap, error_queue_map = NewErrQueueMap, error_ref = NewErrorRef},
                            {noreply, NewState};
                        _ ->
                            NewMailQueue = MailQueue#mail_queue{queue = MailInfoQueueTmp},
                            NewQueueMap = QueueMap#{EventId => NewMailQueue},
                            do_handle_info({'do_send', EventId}, State#state{mail_queue_map = NewQueueMap})
                    end;
                _ ->
                    {noreply, State#state{mail_queue_map = maps:remove(EventId, QueueMap)}}
            end;
        _ -> {noreply, State}
    end;

do_handle_info('check_error_mail', State) ->
    #state{error_queue_map = ErrorQueueMap, error_ref = OldRef, error_check_times = Times} = State,
    case maps:size(ErrorQueueMap) of
        0 ->
            if
                Times > 10 ->
                    NewState = State#state{error_ref = [], error_check_times = 0};
                true ->
                    Ref = util:send_after(OldRef, ?ONE_HOUR_SECONDS * 1000, self(), 'check_error_mail'),
                    NewState = State#state{error_ref = Ref, error_check_times = Times + 1}
            end,
            {noreply, NewState};
        _ ->
            F = fun({EventId, MailInfo}) ->
                [begin
                     {Id, Title, Content, Attachment} = Item,
                     About = {EventId, Id, Title, Content, Attachment},
                     lib_log_api:log_game_error(Id, 4, About)
                 end||Item <- MailInfo]
            end,
            lists:foreach(F, maps:to_list(ErrorQueueMap)),
            report2feishu(),
            Ref = util:send_after(OldRef, ?ONE_HOUR_SECONDS * 1000, self(), 'check_error_mail'),
            LastState = State#state{error_queue_map = #{}, error_ref = Ref, error_check_times = 0},
            {noreply, LastState}
    end;

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ============================= Inner =============================
%% 默认发送邮件方式
default_send_mail(RoleIdL, Title, Content, CmAttachment, DelayMS, GapMS) ->
    spawn(
        fun() ->
            DelayMS =/= 0 andalso timer:sleep(DelayMS),
            [begin
                 lib_mail_api:send_sys_mail([RoleId], Title, Content, CmAttachment),
                 timer:sleep(GapMS)
             end||RoleId <- RoleIdL]
        end
    ).

try_open_error_ref(ErrorRef) ->
    % 出现异常开启定时检测
    case is_reference(ErrorRef) of
        true ->
            ErrorRef;
        _ ->
            report2feishu(),
            util:send_after(ErrorRef, ?ONE_HOUR_SECONDS * 1000, self(), 'check_error_mail')
    end.

report2feishu() ->
    Msg = lib_game:format_feishu_msg(io_lib:format(<<"异常信息:\r\n \t检测出邮件发送发生异常！！"/utf8>>, [])),
    lib_game:report_to_feishu(Msg).
