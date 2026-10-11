%% ---------------------------------------------------------------------------
%% @doc mod_cycle_rank

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##跨服进程
%% ---------------------------------------------------------------------------

-module(mod_cycle_rank).

-behaviour(gen_server).

%% API

-export([
      start_link/0
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

-compile(export_all).

-include("common.hrl").
-include("def_gen_server.hrl").
-include("cycle_rank.hrl").

%% ===========================
%%  Function Need Export
%% ===========================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 请求更新排行榜
update_cycle_rank_list(Args) ->
    gen_server:cast(?MODULE, {update_cycle_rank_list, Args}).

%% 同步数据到某个游戏节点
sync_cycle_rank_data_to_node(Node) ->
    gen_server:cast(?MODULE, {sync_cycle_rank_data_to_node, Node}).

%% 清除玩家变化发送通知的冷却时间
role_refresh_send_time(RoleId) ->
    gen_server:cast(?MODULE, {role_refresh_send_time, RoleId}).

%% 有游戏节点连上跨服时执行
center_connected(ServerId, Node, MergeServerIds, MergeDay) ->
    case MergeDay of
        1 ->
            %% 合服第一天, 需要执行服务器ID的修复
            gen_server:cast(?MODULE, {fix_merge_server_data, ServerId, Node, MergeServerIds});
        _ ->
            %% 不是合服第一天时候，表示不需要修复因为合服而导致榜单中玩家数据异常的问题
            gen_server:cast(?MODULE, {sync_cycle_rank_data_to_node, Node})
    end.
%% 存在玩家修改昵称时
change_role_name(PlayerId, PlayerName) ->
    gen_server:cast(?MODULE, {change_role_name, PlayerId, PlayerName}).

%% 每晚23点30分计算前中后三天的活动时间数据
calc_daily_act_info() ->
    gen_server:cast(?MODULE, {calc_daily_act_info}).
%% 秘籍重开当天的循环冲榜活动
gm_reopen_cycle_rank() ->
    gen_server:cast(?MODULE, {gm_reopen_cycle_rank}).

%% 秘籍重算定时器（确保因为20220818版本导致活动未开启的问题影响到下一天的活动开启）
gm_recalculate_timer() ->
    gen_server:cast(?MODULE, {gm_recalculate_timer}).

%% ==================================
%% Gm
%% ==================================
get_state() ->
    gen_server:cast(?MODULE, {get_state}).

gm_refresh() ->
    gen_server:cast(?MODULE, {gm_refresh}).

gm_close_act()->
    gen_server:cast(?MODULE, {gm_close_act}).

%%刷新定时器秘籍
gm_refresh_ref()->
    gen_server:cast(?MODULE, {gm_refresh_ref}).

%% 修改开服天数
gm_open_day() ->
    gen_server:cast(?MODULE, {gm_open_day}).


%% ===========================
%% gen_server callbacks temples
%% ===========================
init([]) ->
    do_init().

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
    
do_init() ->
    InitState = lib_cycle_rank_mod:init(),
    {ok, InitState}.

do_handle_call(_Request, _From, _State) ->
    no_match.

%% 更新榜单数据
do_handle_cast({update_cycle_rank_list, Args}, State) ->
    NewState = lib_cycle_rank_mod:update_cycle_rank_list(Args, State),
    {noreply, NewState};

%% 同步数据到每个游戏节点
do_handle_cast({sync_cycle_rank_data_to_node, Node}, State) ->
    lib_cycle_rank_mod:sync_cycle_rank_data_to_node(Node, State),
    {noreply, State};

do_handle_cast({get_state}, State) ->
    ?MYLOG("lhh", "~p", [State]),
    {noreply, State};

do_handle_cast({role_refresh_send_time, RoleId}, State) ->
    NewState = lib_cycle_rank_mod:role_refresh_send_time(RoleId, State),
    {noreply, NewState};

do_handle_cast({gm_refresh}, State)->
    NewState = lib_cycle_rank_mod:gm_refresh(State),
    {noreply, NewState};

do_handle_cast({gm_close_act}, State)->
    {noreply, NewState} = lib_cycle_rank_mod:close_show_act(State),
    lib_cycle_rank_mod:close_cycle_rank(NewState);

do_handle_cast({gm_refresh_ref}, _State)->
    NewState = lib_cycle_rank_mod:gm_refresh_ref(),
    {noreply, NewState};

do_handle_cast({gm_open_day}, _State) ->
    NewState = lib_cycle_rank_mod:gm_refresh_ref(),
    #cluster_rank_status{ opening_act = OpenActList, show_act_info = ShowActInfo, rank_list = RankList, all_cycle_rank = AllCycleRank } = NewState,
    Args = [OpenActList, ShowActInfo, RankList, AllCycleRank],
    mod_clusters_center:apply_to_all_node(mod_cycle_rank_local, sync_cycle_rank_data_from_center, [Args], 100),
    {noreply, NewState};

do_handle_cast({fix_merge_server_data, ServerId, Node, MergeServerIds}, State) ->
    NewState = lib_cycle_rank_mod:fix_merge_server_data(State, ServerId, Node, MergeServerIds),
    {noreply, NewState};
do_handle_cast({change_role_name, PlayerId, PlayerName}, State) ->
    NewState = lib_cycle_rank_mod:change_role_name(PlayerId, PlayerName, State),
    {noreply, NewState};

do_handle_cast({calc_daily_act_info}, State) ->
    NewState = lib_cycle_rank_mod:calc_daily_act_info(State),
    {noreply, NewState};
do_handle_cast({gm_reopen_cycle_rank}, State) ->
    NewState = lib_cycle_rank_mod:gm_reopen_cycle_rank(State),
    {noreply, NewState};

do_handle_cast({gm_recalculate_timer}, State) ->
    NewState = lib_cycle_rank_mod:gm_recalculate_timer(State),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.


%% ===================================
%% Info
%% ===================================

do_handle_info({open_cycle_rank}, State) ->
    lib_cycle_rank_mod:open_cycle_rank(State);

do_handle_info({close_cycle_rank}, State) ->
    lib_cycle_rank_mod:close_cycle_rank(State);

do_handle_info({close_show_act}, State) ->
    lib_cycle_rank_mod:close_show_act(State);

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
