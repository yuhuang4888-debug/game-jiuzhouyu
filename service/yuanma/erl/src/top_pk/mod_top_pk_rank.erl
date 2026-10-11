%%-----------------------------------------------------------------------------
%% @Module  :       mod_top_pk_rank.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-11
%% @Description:    巅峰竞技排行榜
%%-----------------------------------------------------------------------------

-module (mod_top_pk_rank).
-include ("common.hrl").
-include ("top_pk.hrl").
-include ("server.hrl").
-include ("predefine.hrl").
-include ("skill.hrl").
-include ("attr.hrl").
-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,get_ranks/1
    ,update/1
%%    ,sync_rank_role/1
    ,set_ranks/1
    ,day_tiger/0
%%    ,choose_a_fake_man_and_battle/4
    ,reset/0
	,monthly_clear_ranks/0
]).

-define (SERVER, ?MODULE).

-record (state, {
    rank_list = [],
    req_list = [],
    is_setup = 0,  %% 设置好了为true 其它为请求次数
    is_local = true        %% 是否本服排行榜 boolean()
    ,local_total_list = undefined
    }).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_ranks(RoleId) ->
    gen_server:cast(?SERVER, {get_ranks, RoleId}).

update(RankRole) ->
    gen_server:cast(?SERVER, {update, RankRole}).

%%sync_rank_role(RankRole) ->
%%    gen_server:cast(?SERVER, {sync_rank_role, RankRole}).

set_ranks(RankList) ->
    gen_server:cast(?SERVER, {set_ranks, RankList}).

monthly_clear_ranks() ->
    gen_server:cast(?SERVER, {monthly_clear_ranks}).

%%choose_a_fake_man_and_battle(RoleKey, GradeNum, RankLv, Power) ->
%%    gen_server:cast(?SERVER, {choose_a_fake_man_and_battle, RoleKey, GradeNum, RankLv, Power}).

day_tiger() ->
    {_, MaxOpenDay} = data_top_pk:get_kv(local_match_day,default),
    OpenDay = util:get_open_day(),
    if
        OpenDay == MaxOpenDay + 1 ->  %% 如果是刚好进入跨服模式，需要结算本服的数据
            monthly_clear_ranks();
        true ->
            skip
    end.

reset() ->
    gen_server:cast(?SERVER, reset).

%% private
init([]) ->
    % NowOpenDay = util:get_open_day(),
    % LocalDayNum = data_top_pk:get_kv(default, local_serv_day),
    % IsLocal = NowOpenDay =< LocalDayNum,
%%    check_monthly_clear(),
    RankList = load(),
    {ok, #state{rank_list = RankList}}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.



handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
	    NewState when  is_record(NewState, state) ->
		    {noreply, NewState};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
		NewState when  is_record(NewState, state) ->
			{noreply, NewState};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

do_handle_cast({get_ranks, MyRoleId}, State) ->
    #state{rank_list = ListTemp} = State,
    List = lists:sublist(ListTemp, ?rank_show_num_max),
    Data = [{RoleId, RoleName, Career, Power, GuildName, Platform, Server, RankLv, Point} ||
        #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, guild_name = GuildName,
            platform = Platform, server = Server, rank_lv = RankLv, point = Point} <- List],
%%	?PRINT("data ~p~n", [Data]),
	?PRINT("data ~p~n", [State]),
    {ok, BinData} = pt_281:write(28115, [Data]),
    lib_server_send:send_to_uid(MyRoleId, BinData),
	{noreply, State};


do_handle_cast({monthly_clear_ranks}, State) ->
	%% 发送赛季奖励
%%    ?MYLOG("cym", "State ~p~n", [State]),
	spawn(fun() ->send_month_end_rank_reward(State#state.rank_list, 1) end),
	db:execute("TRUNCATE TABLE `top_pk_rank`"),
	check_monthly_clear(),
	%%  通知其他玩家 开启新赛季
	spawn(fun() ->
		timer:sleep(10 *1000),  %% 停止10 ，数据库密集执行
		CurSeasonId = lib_top_pk:get_cur_season_id(),
		GradeNum = 1,
		RankLv = 1,
		Point = 0,
		SerialFailCount = 0,
		SerialWinCount = 0,
		SeasonMatchCount = 0,
		SeasonWinCount = 0,
		SeasonRewardStatus = 0,
		DailyHonorValue = 0,
		YesterdayRankLv = 1,
		SQL = io_lib:format("UPDATE `top_pk_player_data` SET
                            `season_id` = ~p,
                            `grade_num` = ~p,
                            `rank_lv` = ~p,
                            `point` = ~p,
                            `serial_fail_count` = ~p,
                            `serial_win_count` = ~p,
                            `season_match_count` = ~p,
                            `season_win_count` = ~p,
	                        `season_reward_status` = ~p,
	                        `daily_honor_value` = ~p,
	                        `yesterday_rank_lv` = ~p",
			[CurSeasonId, GradeNum, RankLv, Point, SerialFailCount, SerialWinCount,
				SeasonMatchCount, SeasonWinCount, SeasonRewardStatus, DailyHonorValue, YesterdayRankLv]),
%%		?MYLOG("cym", "Sql ~s ~n", [SQL]),
		db:execute(SQL),
		OnlineList = ets:tab2list(?ETS_ONLINE),
		IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
		[  begin
			   timer:sleep(100),
			   lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_top_pk, new_season, [])
		   end
			||RoleId <- IdList]
	      end),
	{noreply, #state{}};

do_handle_cast({update, RankRole}, State) ->
    #state{rank_list = RankList} = State,
    #rank_role{role_id = Id} = RankRole,
    ListWithoutMe = lists:keydelete(Id, #rank_role.role_id, RankList),
    if
        RankRole#rank_role.rank_lv > 0  ->
            {_Rank, NewList} = ulists:sorted_insert(fun lib_top_pk:rank_sort_fun/2, RankRole, ListWithoutMe),
            Length = length(NewList),
            if
                Length =< ?RANK_NUM_MAX ->
                    FinalList = NewList;
                true ->
                    FinalList = lists:sublist(NewList, ?RANK_NUM_MAX)
            end;
        true ->
            FinalList = ListWithoutMe
    end,
%%	?PRINT("FinalList ~p~n", [FinalList]),
    lib_top_pk:save_rank_role_local(RankRole),
    State#state{rank_list = FinalList};
    

%%do_handle_cast({sync_rank_role, RankRole}, #state{is_local = false, is_setup = true} = State) ->
%%    #state{rank_list = RankList} = State,
%%    ListWithoutMe = lists:keydelete(RankRole#rank_role.role_id, #rank_role.role_id, RankList),
%%    if
%%        RankRole#rank_role.star_num > 0 orelse RankRole#rank_role.grade_num > 1 ->
%%            {_, NewList} = ulists:sorted_insert(fun lib_top_pk:rank_sort_fun/2, RankRole, ListWithoutMe),
%%            Length = length(NewList),
%%            if
%%                Length =< ?RANK_NUM_MAX ->
%%                    FinalList = NewList;
%%                true ->
%%                    FinalList = lists:sublist(NewList, ?RANK_NUM_MAX)
%%            end;
%%        true ->
%%            FinalList = ListWithoutMe
%%    end,
%%    {noreply, State#state{rank_list = FinalList}};

do_handle_cast({set_ranks, RankList}, #state{is_local = false} = State) ->
    #state{req_list = ReqList} = State,
    [send_rank_list(Sid, RankList, false) || Sid <- ReqList],
    {noreply, State#state{is_setup = true, req_list = [], rank_list = RankList}};

%%do_handle_cast({choose_a_fake_man_and_battle, _RoleKey, _GradeNum, _RankLv, _Power}, State) ->
%%    {noreply, State};
%%%%    暂时不用维护本服的排行榜
%%%%    #state{local_total_list = TotalList} = State,
%%%%    {_, RoleId} = RoleKey,
%%%%    case TotalList of
%%%%        undefined ->
%%%%            NewTotalList = load_local_total_list(),
%%%%            create_fake_battle(RoleKey, calc_someone_near_me(RoleId, GradeNum, StarNum, NewTotalList)),
%%%%            {noreply, State#state{local_total_list = NewTotalList}};
%%%%        _ ->
%%%%            create_fake_battle(RoleKey, calc_someone_near_me(RoleId, GradeNum, StarNum,TotalList)),
%%%%            {noreply, State}
%%%%    end;

do_handle_cast(reset, _) ->
    {noreply, #state{}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%%do_handle_info(monthly_clear_ranks, State) ->
%%    %% 发送赛季奖励
%%%%    ?MYLOG("cym", "State ~p~n", [State]),
%%    spawn(fun() ->
%%        send_month_end_rank_reward(State#state.rank_list, 1)
%%          end),
%%    db:execute("TRUNCATE TABLE `top_pk_rank`"),
%%    check_monthly_clear(),
%%    {noreply, #state{}};
do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal
    
send_rank_list(Sid, List, IsLocal) ->
    LocalType = if IsLocal -> 1; true -> 2 end,
    Data = [{RoleId, RoleName, Career, Power, GuildName, Platform, Server, GradeNum, StarNum} || #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, guild_name = GuildName, platform = Platform, server = Server, grade_num = GradeNum, star_num = StarNum} <- List],
    {ok, BinData} = pt_281:write(28115, [LocalType, Data]),
    lib_server_send:send_to_sid(Sid, BinData).

%% internal
load() ->
    {MonthStartTime, _} = utime:get_month_unixtime_range(),
    SQL = io_lib:format("SELECT `role_id`, `role_name`, `career`, `power`, `platform`, `server`, `grade_num`, `star_num`, `rank_lv`, `point`, `server_id`, `match_count` FROM `top_pk_rank` WHERE `time` >= ~p ORDER BY `rank_lv` DESC, `point` DESC, `power` DESC LIMIT ~p",
        [MonthStartTime, ?RANK_NUM_MAX]),
    All = db:get_all(SQL),
%%    if
%%        All =/= [] ->
%%            Ids = [Id || [Id|_] <- All],
%%            DeleteSQL = io_lib:format("DELETE FROM `top_pk_rank_kf` WHERE `role_id` NOT IN (~s)", [ulists:list_to_string(Ids, ",")]),
%%            db:execute(DeleteSQL);
%%        true ->
%%            ok
%%    end,
    init_rank_list(All, []).

init_rank_list([[RoleId, RoleName, Career, Power, Platform, Server, GradeNum, StarNum, RankLv, Point, ServerId, MatchCount]|T], Acc) ->
    init_rank_list(T, [#rank_role{
        role_id = RoleId,
        role_name = binary_to_list(RoleName),
        platform = binary_to_list(Platform),
        power = Power,
        server = Server,
        grade_num = GradeNum,
        star_num = StarNum,
        rank_lv = RankLv,
        point = Point,
        server_id = ServerId,
        match_count = MatchCount,
        career = Career}|Acc]);

init_rank_list([], Acc) -> lists:reverse(Acc).




check_monthly_clear() ->
    NowTime = utime:unixtime(),
    {_, MonthEndTime} = utime:get_month_unixtime_range(NowTime),
    erlang:send_after((MonthEndTime - NowTime + 5) * 1000, self(), monthly_clear_ranks).



%% 发送赛季奖励
send_month_end_rank_reward([], _Rank) ->
    ok;
send_month_end_rank_reward([H | T], Rank) ->
    timer:sleep(100),
    #rank_role{server_id = ServerId, role_id = RoleId, role_name = RoleName, match_count = MatchCount} = H,
    LimitCount = data_top_pk:get_kv(season_reward_condition, match_count),
%%	LimitCount = 0,
    case data_top_pk:get_end_local_reward(Rank) of
        [] ->
            ok;
        Reward ->
            %%log
            if
                MatchCount >= LimitCount ->
                    lib_log_api:log_top_pk_season_reward(ServerId, RoleId, RoleName, Rank, Reward),
                    Title   = utext:get(?season_reward_title),
                    Content = utext:get(?season_reward_content, [Rank]),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
                true ->
                    Title   = utext:get(?season_reward_title),
                    Content = utext:get(2810003),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, [])
            end
    end,
    send_month_end_rank_reward(T, Rank + 1).