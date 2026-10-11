%% ---------------------------------------------------------------------------
%% @doc mod_cycle_rank_local

%% @author  lianghaihui
%% @email   1457863678@qq.com
%% @since   2022/03/18
%% @desc    循环冲榜##游戏服进程
%% ---------------------------------------------------------------------------

-module(mod_cycle_rank_local).

-behaviour(gen_server).

%% API

-export([
      start_link/0
]).

%% gen_server callbacks
-export([
    init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3
]).

-export([
    get_open_cycle_rank/0,
    get_show_cycle_rank/0,
    over_player_cycle_rank_info/2,
    sync_cycle_rank_data_from_center/1,
    synch_cycle_rank_info/1,
    syn_cycle_rank_role/3,
    send_cycle_rank_list/1,
    send_show_rank_list/1,
    send_open_cycle_rank_info/1,
    send_player_cycle_rank_info/1,
    update_cycle_rank_list/1,
    update_cycle_rank_when_lv_up/1,
    calc_cycle_rank_score/2,
    role_refresh_send_time/1,
    change_role_name/2,
    apply_kf_new_data/0
]).

-export([
    get_state/0,
    cast_to_cluster/1,
    get_rank_and_last_score/0
]).
         
-include("common.hrl").
-include("def_gen_server.hrl").
-include("cycle_rank.hrl").

%% ===========================
%%  Function Need Export
%% ===========================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 玩家申请本游戏节点正在开启的活动
get_open_cycle_rank() ->
    gen_server:call(?MODULE, {get_open_cycle_rank}).

get_show_cycle_rank() ->
    gen_server:call(?MODULE, {get_show_cycle_rank}).

%% -----------------------------------------------------------------
%% @desc    功能描述 跨服 -> 游戏服 通知游戏节点某个活动进行结算了
%% -----------------------------------------------------------------
over_player_cycle_rank_info(Type, SubType) ->
    gen_server:cast(?MODULE, {over_player_cycle_rank_info, Type, SubType}).

%% 跨服 -> 游戏服 同步某个类型的活动数据
synch_cycle_rank_info(Args) ->
    gen_server:cast(?MODULE, {synch_cycle_rank_info, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 跨服 -> 游戏服 更新榜单信息 当有玩家上榜时调用
%% -----------------------------------------------------------------
syn_cycle_rank_role(Type, SubType, AddRankRole) ->
    gen_server:cast(?MODULE, {syn_cycle_rank_role, Type, SubType, AddRankRole}).

%% -----------------------------------------------------------------
%% @desc    功能描述 跨服 -> 游戏服 更新所有循环冲榜相关数据到本游戏节点
%% -----------------------------------------------------------------
sync_cycle_rank_data_from_center(Args) ->
    gen_server:cast(?MODULE, {sync_cycle_rank_data_from_center, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 申请查看当天榜单
%% @param   参数   PlayerId 申请查看榜单的玩家Id
%% -----------------------------------------------------------------
send_cycle_rank_list(Args) ->
    gen_server:cast(?MODULE, {send_cycle_rank_list, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 申请查看昨日榜单
%% @param   参数   PlayerId 申请查看昨日榜单的玩家Id
%% -----------------------------------------------------------------
send_show_rank_list(Args) ->
    gen_server:cast(?MODULE, {send_show_rank_list, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 更新排行榜数据
%% @param   参数  Args = [Type, SubType, RankRole]
%% -----------------------------------------------------------------
update_cycle_rank_list(Args) ->
    gen_server:cast(?MODULE, {update_cycle_rank_list, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 玩家申请获取当前游戏服正在开启的活动信息
%% -----------------------------------------------------------------
send_open_cycle_rank_info(PlayerId) ->
    gen_server:cast(?MODULE, {send_open_cycle_rank_info, PlayerId}).

%% -----------------------------------------------------------------
%% @desc    功能描述 查看个人循环冲榜信息
%% @param   参数  Args:[PlayerId, Score, ShowReachId, ShowReachStatus, Type, SubType]
%% -----------------------------------------------------------------
send_player_cycle_rank_info(Args) ->
    gen_server:cast(?MODULE, {send_player_cycle_rank_info, Args}).

%% -----------------------------------------------------------------
%% @desc    功能描述 当玩家消耗物存在增加积分的消耗物时
%% @param   参数     玩家ID, 消耗物列表[{_, GoodsId, Num}]
%% @return  返回值 主要获取当前当前游戏正在开启的冲榜类型，然后cast回玩家
%% -----------------------------------------------------------------
calc_cycle_rank_score(PlayerId, Filter) ->
    gen_server:cast(?MODULE, {calc_cycle_rank_score, PlayerId, Filter}).

%% -----------------------------------------------------------------
%% @desc    功能描述 玩家登录时清除并重置玩家发送时间限制
%% @param   参数     玩家ID
%% -----------------------------------------------------------------
role_refresh_send_time(PlayerId) ->
    gen_server:cast(?MODULE, {role_refresh_send_time, PlayerId}).

%% -----------------------------------------------------------------
%% @desc    功能描述 当玩家升级时,符合条件时调用，会拿去玩家的积分去上榜
%% -----------------------------------------------------------------
update_cycle_rank_when_lv_up(PlayerId) ->
    gen_server:cast(?MODULE, {update_cycle_rank_when_lv_up, PlayerId}).

%% -----------------------------------------------------------------
%% @desc    功能描述 玩家修改昵称时，同步修改榜单上的数据
%% -----------------------------------------------------------------
change_role_name(PlayerId, PlayerName) ->
    gen_server:cast(?MODULE, {change_role_name, PlayerId, PlayerName}).

%% 获取开发的榜单和最后一名的积分
get_rank_and_last_score() ->
    gen_server:cast(?MODULE, {get_rank_and_last_score}).

%% game -> kf 申请同步跨服上最新的数据
apply_kf_new_data() ->
    gen_server:cast(?MODULE, {apply_kf_new_data}).

%% ==============================================================
%% Gm
%% =============================================================
get_state() ->
    gen_server:cast(?MODULE, {get_state}).


cast_to_cluster(Type) ->
    gen_server:cast(?MODULE, {cast_to_cluster, Type}).

%% ========================================================
%% gen_server callbacks temples
%% ========================================================
init([]) ->
    State = lib_cycle_rank_local_mod:init(),
    {ok, State}.


handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Data, NewState} ->
            {reply, Data, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

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

do_handle_call({get_open_cycle_rank}, State) ->
    Data = lib_cycle_rank_local_mod:get_open_cycle_rank(State),
    {reply, Data, State};

do_handle_call({get_show_cycle_rank}, State) ->
    Data = lib_cycle_rank_local_mod:get_show_cycle_rank(State),
    {reply, Data, State};

do_handle_call(_Request, _State) ->
    no_match.

%% 通知本服进行目标阶段奖励的结算
do_handle_cast({over_player_cycle_rank_info, Type, SubType}, State) ->
    lib_cycle_rank_local_mod:over_player_cycle_rank_info(Type, SubType, State),
    {noreply, State};

%% 更新排行榜
do_handle_cast({update_cycle_rank_list, Args}, State) ->
    NewState = lib_cycle_rank_local_mod:update_cycle_rank_list(Args, State),
    {noreply, NewState};

%% 跨服更新榜单后同步的数据
do_handle_cast({syn_cycle_rank_role, Type, SubType, AddRankRole}, State) ->
    case lib_cycle_rank_util:game_check_is_open(data_cycle_rank:get_cycle_rank_info(Type, SubType)) of
        true ->
            NewState = lib_cycle_rank_local_mod:syn_cycle_rank_role(Type, SubType, AddRankRole, State);
        _ ->
            NewState = State
    end,
    {noreply, NewState};

%% 获取榜单数据
do_handle_cast({send_cycle_rank_list, Args}, State) ->
    lib_cycle_rank_local_mod:send_cycle_rank_list(Args, State),
    {noreply, State};

%% 同步中心服的数据到本有些节点
do_handle_cast({sync_cycle_rank_data_from_center, Args}, State) ->
    NewState = lib_cycle_rank_local_mod:sync_cycle_rank_data_from_center(Args, State),
    {noreply, NewState};

%%
do_handle_cast({synch_cycle_rank_info, Args}, State) ->
    NewState = lib_cycle_rank_local_mod:synch_cycle_rank_info(Args, State),
    {noreply, NewState};

do_handle_cast({send_open_cycle_rank_info, PlayerId}, State) ->
    lib_cycle_rank_local_mod:send_open_cycle_rank_info(PlayerId, State),
    {noreply, State};

do_handle_cast({send_player_cycle_rank_info, Args}, State) ->
    lib_cycle_rank_local_mod:send_player_cycle_rank_info(Args, State),
    {noreply, State};

%% 获取前一个榜单的数据
do_handle_cast({send_show_rank_list, PlayerId}, State) ->
    lib_cycle_rank_local_mod:send_show_rank_list(PlayerId, State),
    {noreply, State};

do_handle_cast({calc_cycle_rank_score, PlayerId, GoodsList}, State) ->
    lib_cycle_rank_local_mod:calc_cycle_rank_score(PlayerId, GoodsList, State),
    {noreply, State};

do_handle_cast({role_refresh_send_time, RoleId}, State) ->
    #game_rank_status{ role_send_time_limit = AllRoleList } = State,
    F = fun(_, RoleMap) ->
        maps:remove(RoleId, RoleMap)
    end,
    NewMap = maps:map(F, AllRoleList),
    lib_cycle_rank_local_mod:role_refresh_send_time(State, RoleId),
    {noreply, State#game_rank_status{ role_send_time_limit = NewMap }};

do_handle_cast({cast_to_cluster, Type}, State) ->
    case Type of
        2 ->
            mod_clusters_node:apply_cast(mod_cycle_rank, get_state, []);
        3 ->
            mod_clusters_node:apply_cast(mod_cycle_rank, gm_refresh_ref, []);
        4 ->
            mod_clusters_node:apply_cast(mod_cycle_rank, gm_refresh, []);
        _ -> skip
    end,
    {noreply, State};

do_handle_cast({update_cycle_rank_when_lv_up, PlayerId}, State) ->
    lib_cycle_rank_local_mod:update_cycle_rank_when_lv_up(PlayerId, State),
    {noreply, State};

do_handle_cast({get_state}, State) ->
    ?MYLOG("lhh", "State:~p~n", [State]),
    {noreply, State};

do_handle_cast({change_role_name, PlayerId, PlayerName}, State) ->
    mod_clusters_node:apply_cast(mod_cycle_rank, change_role_name, [PlayerId, PlayerName]),
    {noreply, State};

do_handle_cast({get_rank_and_last_score}, State) ->
    lib_cycle_rank_local_mod:get_rank_and_last_score(State),
    {noreply, State};

do_handle_cast({apply_kf_new_data}, State) ->
    mod_clusters_node:apply_cast(mod_cycle_rank, sync_cycle_rank_data_to_node, [config:get_server_id()]),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% 目前所有数据同步都交给跨服中心主动派发
do_handle_info({check_daily_zero}, State) ->
    Ref = lib_cycle_rank_local_mod:check_ref([]),
    NewState = State#game_rank_status{ ref = Ref },
    {noreply, NewState};

do_handle_info(_Info, State) ->
    {noreply, State}.

do_terminate(_Reason, _State) ->
    ok.

do_code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
