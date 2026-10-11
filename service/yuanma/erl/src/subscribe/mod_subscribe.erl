%% ---------------------------------------------------------------------------
%% @doc mod_subscribe.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-05
%% @deprecated 订阅进程
%% ---------------------------------------------------------------------------
-module(mod_subscribe).

-compile(export_all).

-include("common.hrl").
-include("def_gen_server.hrl").

%% 玩家登录
login(ActType, AccName, RoleId) ->
    gen_server:cast(?MODULE, {'apply_cast', login, [ActType, AccName, RoleId]}).

%% 玩家登出
logout(ActType, AccName, RoleId, Args) ->
    gen_server:cast(?MODULE, {'apply_cast', logout, [ActType, AccName, RoleId, Args]}).

%% 设置
set_subscribe_type(SubscribeType, Accname, LastLogoutTime) ->
    gen_server:cast(?MODULE, {'apply_cast', set_subscribe_type, [SubscribeType, Accname, LastLogoutTime]}).

%% 移除订阅
remove_subscribe(SubscribeType, Accname) ->
    gen_server:cast(?MODULE, {'apply_cast', remove_subscribe, [SubscribeType, Accname]}).

%% 发送活动开启通知
send_subscribe_of_act(ActType, StartTime, EndTime) ->
    gen_server:cast(?MODULE, {'apply_cast', send_subscribe_act, [ActType, StartTime, EndTime]}).

%% 订阅某推送
subscribe(TemplateInfo, ShUid, RoleId) ->
    gen_server:cast(?MODULE, {'apply_cast', subscribe, [TemplateInfo, ShUid, RoleId]}).

%% 取消订阅某推送
cancel_subscribe(TemplateId, ShUid) ->
    gen_server:cast(?MODULE, {'apply_cast', cancel_subscribe, [TemplateId, ShUid]}).
%% 发送订阅状态
send_subscribe_status(RoleId, AccName, TemIdL) ->
    gen_server:cast(?MODULE, {'apply_cast', send_subscribe_status, [RoleId, AccName, TemIdL]}).

%% 秘籍：清空微信订阅
clear_subscribe(TemplateId) ->
    gen_server:cast(?MODULE, {'apply_cast', clear_subscribe, [TemplateId]}).

%% 输出state
gm_print_state() ->
    gen_server:cast(?MODULE, {'gm_print_state'}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

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

do_init([]) ->
    {ok, State} = lib_subscribe_mod:init(),
    {ok, State}.

do_handle_call(_Request, _From, _State) ->
    no_match.

do_handle_cast({'apply_cast', F, A}, State) ->
    NewState = apply(lib_subscribe_mod, F, [State|A]),
    {noreply, NewState};

do_handle_cast({'gm_print_state'}, State) ->
    ?INFO("State:~p ~n", [State]),
    ?PRINT("State:~p ~n", [State]),
    {noreply, State};

do_handle_cast(_Msg, _State) ->
    no_match.

do_handle_info({'onhook_timeout', TempId, ShUid}, State) ->
    NewState = lib_subscribe_mod:send_subscribe_act(State, TempId, ShUid, utime:unixtime()),
    {noreply, NewState};

do_handle_info(_Info, _State) ->
    no_match.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.