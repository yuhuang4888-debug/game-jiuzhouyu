%%% ----------------------------------------------------
%%% @Module:        mod_3v3_rank
%%% @Author:        zhl
%%% @Description:   跨服3v3排行榜
%%% @Created:       2017/07/07
%%% ----------------------------------------------------

-module(mod_3v3_rank).
-behaviour(gen_server).



-compile(export_all).
-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-export([
	start_link/0,                           %% 启动3v3排行榜
	replace_3v3_rank/0,                     %% 更新3v3排行榜数据
	refresh_3v3_rank/1,                     %% 刷新排行榜
	get_page_rank/1,                        %% 获取荣誉排行榜
	get_score_rank/0,
	get_score_rank/1,                       %% 获取天梯排行榜
	
	after_merge_fix/1,                      %% 合服校正
	get_my_tier/2,
	season_end/0,                           %% 赛季结算
	
	test/0
]).

-include("common.hrl").
-include("3v3.hrl").

-define(RANK_REFRESH_TIME, 0).


%% 刷新排行榜
refresh_3v3_rank(Args) ->
	gen_server:cast(?MODULE, {refresh_3v3_rank, Args}).

%% 获取荣誉排行榜
get_page_rank(Args) ->
	gen_server:cast(?MODULE, {get_page_rank, Args}).

%% 获取天梯排行榜
get_score_rank() ->
	?MODULE ! {get_score_rank}.

get_score_rank(Args) ->
	gen_server:cast(?MODULE, {get_score_rank, Args}).

%% 更新3v3排行榜数据 - 每次活动结束写入一次
replace_3v3_rank() ->
	?MODULE ! {replace_3v3_rank}.

%% 合服校正
after_merge_fix(Args) ->
	gen_server:cast(?MODULE, {after_merge_fix, Args}).

get_my_tier(Node, RoleId) ->
	gen_server:cast(?MODULE, {get_my_tier, Node, RoleId}).

%%赛季结算
season_end() ->
	gen_server:cast(?MODULE, {empty_3v3_rank}).


refresh_3v3_team(TeamRank) ->
	gen_server:cast(?MODULE, {refresh_3v3_team, TeamRank}).

%%改变名字，队长等 删除队伍等操作
refresh_3v3_team2(Args) ->
	gen_server:cast(?MODULE, {refresh_3v3_team2, Args}).


get_champion_data() ->
	gen_server:cast(?MODULE, {get_champion_data}).

%% 启动3v3排行榜
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).



test() -> ok.

init([]) ->
	process_flag(trap_exit, true),
	ets:new(?ETS_RANK_DATA, [named_table, {keypos, #kf_3v3_team_rank_data.team_id}, {read_concurrency, true}]),
%%    NowSec = utime:get_seconds_from_midnight(),
%%    erlang:send_after((86400 - NowSec) * 1000, self(), {empty_3v3_rank}), %% 每周六清空一次排行榜
	RankData = lib_3v3_rank:load_3v3_rank(),
	case RankData of
		[] -> skip;
		_ -> ets:insert(?ETS_RANK_DATA, RankData)
	end,
	{ok, {}}.

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast(Request, State) ->
	try
		do_handle_cast(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.

handle_info(Request, State) ->
	try
		do_handle_info(Request, State)
	catch
		throw:{error, _Reason} ->
			{noreply, State};
		throw:_ ->
			{noreply, State};
		_:Error ->
			?ERR("handle call exception~n"
			"error:~p~n"
			"state:~p~n"
			"stack:~p", [Error, State, erlang:get_stacktrace()]),
			{noreply, State}
	end.

terminate(_Reason, _State) ->
	lib_3v3_rank:replace_3v3_rank(),
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


do_handle_cast({get_champion_data}, State) ->
	List = ets:tab2list(?ETS_RANK_DATA),
%%    ?MYLOG("cym", "List ~p~n", [List]),
	RankData = lib_3v3_rank:sort_rank(List),
	NRankData = lists:sublist(RankData, 16),  %% 16强
	mod_3v3_champion:update_champion_data(NRankData),
	{noreply, State};


do_handle_cast({refresh_3v3_team, Args}, State) ->
%%    NowTime = utime:unixtime(),
%%    LastRefreshTime
%%        = case get(rank_3v3_last_refresh_time) of
%%              undefined ->
%%                  put(rank_3v3_last_refresh_time, NowTime),
%%                  NowTime;
%%              Time ->
%%                  Time
%%          end,
%%    ?MYLOG("rank", "Args ~p~n", [Args]),
	{ok, KeyValueList} = lib_3v3_rank:refresh_3v3_rank(Args, []),
%%    ?MYLOG("rank", "KeyValueList ~p~n", [KeyValueList]),
	update_to_ets(KeyValueList),
	notice_local_team_rank(),
	{noreply, State};


do_handle_cast({refresh_3v3_team2, Args}, State) ->
%%    ?MYLOG("3v3_rank", "refresh_3v3_team2 ~p~n", [Args]),
	RankTeamData = ets:tab2list(?ETS_RANK_DATA),
	case Args of
		{delete, TeamId} ->
			Sql = io_lib:format(?SQL_DELETE_3V3_RANK_ONE, [TeamId]),
			db:execute(Sql),
			KeyValueList = [{delete_by_id, ?ETS_RANK_DATA, TeamId}];
		{update_name, TeamId, TeamName} ->
			case lists:keyfind(TeamId, #kf_3v3_team_rank_data.team_id, RankTeamData) of
				#kf_3v3_team_rank_data{} = OldTeam ->
					NewTeam = OldTeam#kf_3v3_team_rank_data{team_name = TeamName},
					lib_3v3_rank:replace_3v3_rank([NewTeam]),
					KeyValueList = [{update, ?ETS_RANK_DATA, NewTeam}];
				_ ->
					KeyValueList = []
			end;
		{update_leader_id, TeamId, RoleId, RoleName} ->
			case lists:keyfind(TeamId, #kf_3v3_team_rank_data.team_id, RankTeamData) of
				#kf_3v3_team_rank_data{} = OldTeam ->
					NewTeam = OldTeam#kf_3v3_team_rank_data{leader_id = RoleId, leader_name = RoleName},
					lib_3v3_rank:replace_3v3_rank([NewTeam]),
					KeyValueList = [{update, ?ETS_RANK_DATA, NewTeam}];
				_ ->
					KeyValueList = []
			end;
		_ ->
			KeyValueList = []
	end,
%%    ?MYLOG("3v3_rank", "KeyValueList ~p~n", [KeyValueList]),
	update_to_ets(KeyValueList),
	{noreply, State};
%%    if
%%        NowTime - LastRefreshTime > ?RANK_REFRESH_TIME ->
%%            do_handle_info({get_score_rank}, State);
%%        true ->
%%            {noreply, State}
%%    end ;

%%%% 刷新排行榜 废弃
%%do_handle_cast({refresh_3v3_rank, [#kf_3v3_rank_data{} | _] = Args}, State) ->
%%%%    ?MYLOG("3v32", "Args ~p~n", [Args]),
%%    NowTime = utime:unixtime(),
%%    LastRefreshTime
%%    = case get(rank_3v3_last_refresh_time) of
%%          undefined ->
%%              put(rank_3v3_last_refresh_time, NowTime),
%%              NowTime;
%%          Time ->
%%              Time
%%      end,
%%    {ok, KeyValueList} = lib_3v3_rank:refresh_3v3_rank(Args, []),
%%    update_to_ets(KeyValueList),
%%    if
%%        NowTime - LastRefreshTime > ?RANK_REFRESH_TIME ->
%%            do_handle_info({get_score_rank}, State);
%%        true ->
%%            {noreply, State}
%%    end ;
%%do_handle_cast({refresh_3v3_rank, Args}, State) ->
%%    {ok, KeyValueList} = lib_3v3_rank:refresh_3v3_rank(Args),
%%    update_to_ets(KeyValueList),
%%    {noreply, State};



%% 获取荣誉排行榜
do_handle_cast({get_page_rank, [Page, ServerId, RoleID]}, State) ->
	% case ets:match_object(?ETS_RANK_DATA, #kf_3v3_rank_data{platform = Platform,
	%   server_num = ServerNum, role_id = RoleID, _ = '_'})
	% of
	%   [#kf_3v3_rank_data{role_id = RoleID}] -> ok;
	%   _ -> RoleID = false
	% end,
	{NewPage, RankID, RankList} = lib_3v3_rank:get_page_rank([Page, RoleID]),
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_page_rank, [[RoleID, NewPage, RankID, RankList]]),
	{noreply, State};

do_handle_cast({get_my_tier, Node, RoleId}, State) ->
	case ets:select(?ETS_RANK_DATA, [{#kf_3v3_rank_data{role_id = RoleId, _ = '_', tier = '$1', star = '$2'}, [], ['$$']}]) of
		[[Tier, Star]] ->
			mod_clusters_center:apply_cast(Node, lib_3v3_local, get_tier_respond, [RoleId, Tier, Star]);
		_ ->
			skip
	end,
	{noreply, State};

%% 获取天梯排行榜
do_handle_cast({get_score_rank, [ServerId, RoleSid]}, State) ->
	ScoreRank = lib_3v3_rank:get_score_rank(),
%%    ?MYLOG("3v3_rank", "ScoreRank ~p~n", [ScoreRank]),
	mod_clusters_center:apply_cast(ServerId, lib_3v3_local, send_score_rank, [[RoleSid, ScoreRank]]),
	{noreply, State};

%% 合服校正
do_handle_cast({after_merge_fix, Args}, State) ->
	RankData = lib_3v3_rank:after_merge_fix(Args),
	ets:insert(?ETS_RANK_DATA, RankData),
	{noreply, State};

%% 赛季结算
do_handle_cast({empty_3v3_rank}, State) ->
%%	Now = utime:unixtime(),
%%	SeasonEndTime = lib_3v3_api:get_season_end_time(Now - 100),  %%昨天的赛季结算时间
	IsTimeClear = lib_3v3_api:is_time_to_clear(),
	if
		IsTimeClear -> %% 赛季结算后的第二天
			lib_3v3_rank:empty_3v3_rank(), %%发送奖励并清空赛季榜
			mod_clusters_center:apply_to_all_node(mod_3v3_local, send_score_rank, [[]]),
			ets:delete_all_objects(?ETS_RANK_DATA);
		true -> skip
	end,
	{noreply, State};


%% gm赛季结算
do_handle_cast({gm_empty_3v3_rank}, State) ->
	lib_3v3_rank:empty_3v3_rank(), %%发送奖励并清空赛季榜
	mod_clusters_center:apply_to_all_node(mod_3v3_local, send_score_rank, [[]]),
	ets:delete_all_objects(?ETS_RANK_DATA),
	{noreply, State};

do_handle_cast(_Request, State) ->
	{noreply, State}.

%% 更新3v3排行榜数据
do_handle_info({replace_3v3_rank}, State) ->
	NowSec = utime:get_seconds_from_midnight(),
	case lib_3v3_center:load_act_time() of
		{_, EdTime} -> %% 每次活动结束写入数据一次
			erlang:send_after((EdTime - NowSec) * 1000, self(), {replace_3v3_rank});
		_ -> skip
	end,
	lib_3v3_rank:replace_3v3_rank(),
	erlang:send_after(200000, self(), {get_score_rank}), %% 活动后20分钟推送天梯排行榜
	{noreply, State};

%%do_handle_info({get_score_rank}, State) ->
%%    ScoreRank = lib_3v3_rank:get_score_rank(),
%%    ?MYLOG("3v3", "ScoreRank ~p~n", [ScoreRank]),
%%    mod_clusters_center:apply_to_all_node(mod_3v3_local, send_score_rank, [ScoreRank]),
%%    put(rank_3v3_last_refresh_time, utime:unixtime()),
%%    {noreply, State};

%% 每月清空一次数据库
do_handle_info({empty_3v3_rank}, State) ->
%%	Now = utime:unixtime(),
	IsTimeClear = lib_3v3_api:is_time_to_clear(),
	if
		IsTimeClear == true -> %% 赛季结算后的第二天凌晨
			lib_3v3_rank:empty_3v3_rank(), %%发送奖励并清空赛季榜
			mod_clusters_center:apply_to_all_node(mod_3v3_local, send_score_rank, [[]]),
			ets:delete_all_objects(?ETS_RANK_DATA);
		true -> skip
	end,
	{noreply, State};
%%%%    DayOfWeek = utime:day_of_week(utime:unixtime() - 100), %% 确保时间是零点前
%%    D = utime:day_of_month(utime:unixtime() + 100),
%%    erlang:send_after(86400 * 1000, self(), {empty_3v3_rank}), %%
%%    if
%%        D == 16 -> %% 每月1号结算
%%            lib_3v3_rank:empty_3v3_rank(), %%发送奖励并清空赛季榜
%%            mod_clusters_center:apply_to_all_node(mod_3v3_local, send_score_rank, [[]]),
%%            ets:delete_all_objects(?ETS_RANK_DATA);
%%        true -> skip
%%    end,
%%    {noreply, State};

do_handle_info({test}, State) ->
	% RankList = ets:tab2list(?ETS_RANK_DATA),
	% io:format("-----{test}-----~p~n", [RankList]),
	RankData = lib_3v3_rank:merge_test(),
	lib_3v3_rank:replace_3v3_rank(RankData),
	{noreply, State};

do_handle_info(_Request, State) ->
	{noreply, State}.

%% 更新ets
%% @desc : 注意，这个方法只有mod_3v3_local这个进程才能使用
update_to_ets(KeyValueList) ->
	F = fun({Type, Tab, Obejct}) ->
		case Type of
			update -> ets:insert(Tab, Obejct);
			delete -> ets:delete_object(Tab, Obejct);
			delete_by_id -> ets:delete(Tab, Obejct);
			_ -> skip
		end
	    end,
	lists:foreach(F, KeyValueList).

notice_local_team_rank() ->
	RankData = lib_3v3_rank:sort_rank(ets:tab2list(?ETS_RANK_DATA)),
	F1 = fun(#kf_3v3_team_rank_data{server_name = ServerName, server_num = ServerNum, power = Power,
		team_id = TeamId, leader_id = LeaderId, leader_name = LeaderName,
		team_name = TeamName, star = Star, tier = _Tier, server_id = ServerId}, {PreRank, List}) ->
		if
			PreRank + 1 < ?team_rank_length -> %% 未上榜
				mod_3v3_team:update_rank(TeamId, PreRank + 1);
%%				mod_clusters_center:apply_cast(ServerId, mod_3v3_team, update_rank, [TeamId, PreRank + 1]);
			true ->
				mod_3v3_team:update_rank(TeamId, 0)
%%				mod_clusters_center:apply_cast(ServerId, mod_3v3_team, update_rank, [TeamId, 0])
		end,
		{PreRank + 1, [{TeamId, PreRank + 1, LeaderId, LeaderName, ServerNum, ServerName, TeamName, Power, Star} | List]}
	     end,
	{_, ResList} = lists:foldl(F1, {0, []}, RankData),
	ResList.


%% 秘籍 ，清除赛季数据
gm_clear_season_date() ->
	gen_server:cast(?MODULE, {gm_empty_3v3_rank}),
	mod_clusters_center:apply_to_all_node(mod_3v3_team, season_end, []).