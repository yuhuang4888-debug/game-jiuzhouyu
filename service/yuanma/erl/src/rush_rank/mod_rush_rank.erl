%%%------------------------------------
%%% @Module  : mod_rush_rank
%%% @Author  :  xiaoxiang
%%% @Created :  2016-11-17
%%% @Description: 冲榜榜单
%%%------------------------------------
-module(mod_rush_rank).

-include("rush_rank.hrl").
-include("common.hrl").

-export([
	refresh_rush_rank_by_list/1
	, refresh_rush_rank/3
	, send_rank_list/5
]).

%% -export([
%%         reload/0
%%         , get_state/0
%%     ]).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-compile(export_all).

%% @param [{RankType, CommonRankRole}]
refresh_rush_rank_by_list(List) ->
	gen_server:cast({global, ?MODULE}, {'refresh_rush_rank_by_list', List}).

%% 根据类型刷新榜单
refresh_rush_rank(RankType, SubType, RushRole) ->
	gen_server:cast({global, ?MODULE}, {'refresh_rush_rank', RankType, SubType, RushRole}).

%% 发送榜单的数据
send_rank_list(RankType, SubType, RoleId, SelValue, IsShowCombat) ->
	gen_server:cast({global, ?MODULE}, {'send_rank_list', RankType, SubType, RoleId, SelValue, IsShowCombat}).

%% 发送目标奖励列表
send_goal_list(SubType, RoleId) ->
	gen_server:cast({global, ?MODULE}, {'send_goal_list', SubType, RoleId}).

%% 领取奖励
get_goal_reward(RoleId, RankType, SubType, Goal, SelValue) ->
	gen_server:cast({global, ?MODULE}, {'get_goal_reward', RoleId, RankType, SubType, Goal, SelValue}).

%% 每日结算榜单
day_clear(DelaySec) ->
	RandTime = urand:rand(1, 1000),
	spawn(fun() ->
		timer:sleep(RandTime), gen_server:cast({global, ?MODULE}, {'day_clear', DelaySec}) end).

gm_send_rewards(SubType) ->
	gen_server:cast({global, ?MODULE}, {'gm_send_rewards', SubType}).
%%更新整个排行榜的领取状态
update_rank_reward_status(RankType, SubType, RewardStatus) ->
	gen_server:cast({global, ?MODULE}, {'update_rank_reward_status', RankType, SubType, RewardStatus}).
%%未领取排行榜奖励的，通过邮件发送给玩家
send_reward_by_mail(RankId) ->
	gen_server:cast({global,  ?MODULE}, {'send_reward_by_mail', RankId}).
%%未领取目标奖励的，通过邮件发送给玩家
send_goal_reward_by_mail() ->
	gen_server:cast({global,  ?MODULE}, {'send_goal_reward_by_mail'}).
%%领取排行榜奖励
get_rank_reward(RoleId, RankType, SubType, RewardId, Career) ->
	gen_server:cast({global,  ?MODULE}, {'get_rank_reward', RoleId, RankType, SubType, RewardId,  Career}).
act_end() ->
	gen_server:cast({global,  ?MODULE}, {'act_end'}).
%% 重置玩家发送时间限制
role_refresh_send_time(RoleId) ->
	gen_server:cast({global,  ?MODULE}, {'role_refresh_send_time', RoleId}).

%% 移除冲榜榜单的指定用户
remove_role_in_rank(SubType, RankType, RoleIds) ->
	gen_server:cast({global,  ?MODULE}, {'remove_role_in_rank', SubType, RankType, RoleIds}).

%% 周卡培养现回退修正开服冲榜
gm_refresh_rush_rank(RankType, SubType, RushRole) ->
	gen_server:cast({global, ?MODULE}, {'gm_refresh_rush_rank', RankType, SubType, RushRole}).

apply_cast(M, F, A) ->
	gen_server:cast({global, ?MODULE}, {'apply_cast', M, F, A}).
%% ---------------------------------------------------------------------------
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------------
init([]) ->
	%% 清理旧数据
	State = lib_rush_rank_mod:init(),
	{ok, State}.
%%	NewState = lib_rush_rank_mod:clear_old_data(State),
%%	{ok, NewState}.

%% ---------------------------------------------------------------------------
%% handle_call({'reload'}, _From, _State) ->
%%     State = lib_common_rank_mod:init(),
%%     {reply, ok, State};
%% handle_call({'state'}, _From, State) ->
%%     % ?ERR1("~p state:~p~n", [?MODULE, State]),
%%     {reply, State, State};
handle_call(_Request, _From, State) ->
	%% ?ERR1("Handle unkown request[~w]~n", [_Request]),
	Reply = ok,
	{reply, Reply, State}.

%% ---------------------------------------------------------------------------
handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{ok, NewState} ->
			{noreply, NewState};
		Err ->
			%% util:errlog("~p ~p Msg:~p Cast_Error:~p ~n", [?MODULE, ?LINE, Msg, Err]),
			?ERR("Msg:~p Cast_Error:~p~n", [Msg, Err]),
			{noreply, State}
	end.

do_handle_cast({'refresh_rush_rank_by_list', List}, State) ->
	lib_rush_rank_mod:refresh_rush_rank_by_list(State, List);
do_handle_cast({'refresh_rush_rank', RankType, SubType, RushRole}, State) ->
	lib_rush_rank_mod:refresh_rush_rank(State, RankType, SubType, RushRole);
do_handle_cast({'send_rank_list', RankType, SubType, RoleId, SelValue, IsShowCombat}, State) ->
	lib_rush_rank_mod:send_rank_list(State, RankType, SubType, RoleId, SelValue, IsShowCombat),
	{ok, State};
do_handle_cast({'send_goal_list', SubType, RoleId}, State) ->
	lib_rush_rank_mod:send_goal_list(State, SubType, RoleId),
	{ok, State};
do_handle_cast({'get_goal_reward', RoleId, RankType, SubType, Goal, SelValue}, State) ->
	lib_rush_rank_mod:get_goal_reward(State, RoleId, RankType, SubType, Goal, SelValue);
do_handle_cast({'day_clear', DelaySec}, State) ->
	lib_rush_rank_mod:day_clear(DelaySec, State);
do_handle_cast({'gm_send_rewards', SubType}, State) ->
	lib_rush_rank_mod:gm_send_rewards(State, SubType),
	{ok, State};
do_handle_cast({'update_rank_reward_status', RankType, SubType, RewardStatus}, State) ->
	lib_rush_rank_mod:update_rank_reward_status(State, RankType, SubType, RewardStatus);
do_handle_cast({'send_reward_by_mail', RankId}, State) ->
	lib_rush_rank_mod:send_reward_by_mail(State, RankId);

do_handle_cast({'send_goal_reward_by_mail'}, State) ->
	lib_rush_rank_mod:send_goal_reward_by_mail(State);

do_handle_cast({'get_rank_reward', RoleId, RankType, SubType, RewardId, Career}, State) ->
	lib_rush_rank_mod:get_rank_reward(State, RoleId, RankType, SubType, RewardId, Career);

do_handle_cast({'act_end'}, State) ->
	lib_rush_rank_mod:act_end(State);

do_handle_cast({'role_refresh_send_time', RoleId}, State) -> 
	lib_rush_rank_mod:role_refresh_send_time(State, RoleId);

do_handle_cast({'remove_role_in_rank', SubType, RankType, RoleIds}, State) ->
	lib_rush_rank_mod:remove_role_in_rank(State, SubType, RankType, RoleIds);

do_handle_cast({'gm_refresh_rush_rank', RankType, SubType, RushRole}, State) ->
	lib_rush_rank_mod:gm_refresh_rush_rank(State, RankType, SubType, RushRole);

do_handle_cast({'apply_cast', M, F, A}, State) ->
	lib_rush_rank_mod:apply_cast(State, M, F, A);

do_handle_cast(_Msg, State) ->
	%% ?ERR1("Handle unkown msg[~w]~n", [_Msg]),
	{ok, State}.

%% ---------------------------------------------------------------------------
handle_info(_Info, State) ->
	?ERR("Handle unkown info[~w]~n", [_Info]),
	{noreply, State}.


%% ---------------------------------------------------------------------------
terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

%% ---------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
