%% ---------------------------------------------------------------------------
%% @doc mod_invite.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-14
%% @deprecated 邀请
%% ---------------------------------------------------------------------------
-module(mod_invite).
-export([]).

-compile(export_all).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("invite.hrl").

-define(MOD_STATE, invite_state).

%% 设置新的邀请者
set_new_inivtee(InviteeId) ->
    gen_server:cast({global, ?MODULE}, {apply, set_new_inivtee, [InviteeId]}).

%% 上传被邀请者信息到php
upload_inivtee_info(InviteeId, Args) ->
    gen_server:cast({global, ?MODULE}, {apply, upload_inivtee_info, [InviteeId, Args]}).

%% 上传被邀请者充值信息到php
upload_inivtee_recharge(InviteeId, Args) ->
    gen_server:cast({global, ?MODULE}, {apply, upload_inivtee_recharge, [InviteeId, Args]}).

%% 更新邀请信息
update_invite_state(RoleId, LvList, IsInvitee, RoleList, RechargeList) ->
    gen_server:cast({global, ?MODULE}, {apply, update_invite_state, [RoleId, LvList, IsInvitee, RoleList, RechargeList]}).

%% -----------------------------------------------------------------
%% 玩家请求
%% -----------------------------------------------------------------

%% 奖励领取
receive_reward(RoleId, Type, RewardId) ->
    gen_server:cast({global, ?MODULE}, {apply, receive_reward, [RoleId, Type, RewardId]}).

%% 帮助信息界面
send_help_info(RoleId) ->
    gen_server:cast({global, ?MODULE}, {apply, send_help_info, [RoleId]}).

%% 升级信息界面
send_lv_info(RoleId) ->
    gen_server:cast({global, ?MODULE}, {apply, send_lv_info, [RoleId]}).

%% 等级奖励位置领取
receive_lv_reward_pos(RoleId, Lv, Pos) ->
    gen_server:cast({global, ?MODULE}, {apply, receive_lv_reward_pos, [RoleId, Lv, Pos]}).

%% 等级奖励一次性领取信息
send_lv_reward_once_info(RoleId, Lv) ->
    gen_server:cast({global, ?MODULE}, {apply, send_lv_reward_once_info, [RoleId, Lv]}).

%% 等级奖励一次性领取
receive_lv_reward_once(RoleId, Lv) ->
    gen_server:cast({global, ?MODULE}, {apply, receive_lv_reward_once, [RoleId, Lv]}).

%% 红包领取信息
send_red_packet_list(RoleId) ->
    gen_server:cast({global, ?MODULE}, {apply, send_red_packet_list, [RoleId]}).

%% 红包领取
receive_red_packet(RoleId, InviteeId) ->
    gen_server:cast({global, ?MODULE}, {apply, receive_red_packet, [RoleId, InviteeId]}).

%% 获得状态
print() ->
    gen_server:call({global, ?MODULE}, {'print'}).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    State = lib_invite_mod:init(),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("~p call error: ~p, Reason=~p~n", [?MODULE, Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p cast error: ~p, Reason:=~p~n", [?MODULE, Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        ok -> {noreply, State};
        {ok, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        {noreply, NewState} when is_record(NewState, ?MOD_STATE) -> {noreply, NewState};
        Reason ->
            ?ERR("~p info error: ~p, Reason:=~p~n", [?MODULE, Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------
%% handle_call
%% --------------------------------------------------------------------------

do_handle_call({'get_state'}, _From, State) ->
    ?INFO("get_state:~p~n", [State]),
    {reply, State, State};

do_handle_call({'print'}, _From, State) ->
    ?INFO("State:~p~n", [State]),
    {reply, State, State};

do_handle_call(_Request, _From, State) ->
    ?ERR("do_handle_call no match _Info:~p ~n",[_Request]),
    {reply, no_match, State}.

%% --------------------------------------------------------------------------
%% handle_cast
%% --------------------------------------------------------------------------

do_handle_cast({'apply', F}, State) ->
    erlang:apply(lib_invite_mod, F, [State]);

do_handle_cast({'apply', F, Args}, State) ->
    erlang:apply(lib_invite_mod, F, [State|Args]);

do_handle_cast(_Msg, State) -> 
    ?ERR("do_handle_cast no match _Msg:~p ~n",[_Msg]),
    {noreply, State}.

%% -----------------------------------------------------------------
%% hanle_info
%% -----------------------------------------------------------------

do_handle_info({'apply', F}, State) ->
    erlang:apply(lib_invite_mod, F, [State]);

do_handle_info({'apply', F, Args}, State) ->
    erlang:apply(lib_invite_mod, F, [State|Args]);

do_handle_info(_Info, State) -> 
    ?ERR("do_handle_info no match _Info:~p ~n",[_Info]),
    {noreply, State}.
