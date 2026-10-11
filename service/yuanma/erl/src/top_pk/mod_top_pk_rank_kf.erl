%%-----------------------------------------------------------------------------
%% @Module  :       mod_top_pk_rank_kf.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-12-12
%% @Description:    巅峰竞技跨服排行榜
%%-----------------------------------------------------------------------------

-module (mod_top_pk_rank_kf).
-include ("common.hrl").
-include("goods.hrl").
-include ("top_pk.hrl").
-behaviour (gen_server).
%%-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
%%-export ([
%%    start_link/0
%%    , get_ranks/1
%%    , get_ranks/2
%%    , update/2
%%]).

-compile(export_all).
-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_ranks(Node) ->
    gen_server:cast(?SERVER, {get_ranks, Node}).

get_ranks(Node, RoleId, ServerId, OpenDay) ->
    gen_server:cast(?SERVER, {get_ranks, Node, RoleId, ServerId, OpenDay}).


update(RankRole, Node) ->
    gen_server:cast(?SERVER, {update, RankRole, Node}).

gm_update_rank_server_id(RoleId, ServerId, Count) ->
    gen_server:cast(?SERVER, {gm_update_rank_server_id, RoleId, ServerId, Count}).

monthly_clear_ranks() ->
    gen_server:cast(?SERVER, {monthly_clear_ranks}).



%% private
init([]) ->
    check_monthly_clear(),
    {ok, load()}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, undefined) ->
    handle_cast(Msg, load());

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
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

do_handle_cast({get_ranks, Node}, RankList) ->
    mod_clusters_center:apply_cast(Node, mod_top_pk_rank, set_ranks, [RankList]),
    {noreply, RankList};

do_handle_cast({get_ranks, Node, RoleId, ServerId, OpenDay}, RankList) ->
    send_rank_list(Node, RoleId, RankList, ServerId, OpenDay),
    {noreply, RankList};

do_handle_cast({update, RankRole, _GetRanksNode}, RankList) ->
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
    lib_top_pk:save_rank_role(RankRole),
    {noreply, FinalList};

do_handle_cast({gm_update_rank_server_id, RoleId, ServerId, Count}, RankList) ->
    case lists:keyfind(RoleId, #rank_role.role_id, RankList) of
        #rank_role{} = Role ->
            NewRole = Role#rank_role{server_id = ServerId, match_count = Count},
            NewRankList = lists:keystore(RoleId, #rank_role.role_id, RankList, NewRole);
        _ ->
            NewRankList = RankList
    end,
    Sql = io_lib:format(<<"update top_pk_rank_kf set server_id = ~p, match_count = ~p where role_id = ~p">>, [ServerId, Count, RoleId]),
    db:execute(Sql),
    {noreply, NewRankList};

do_handle_cast({monthly_clear_ranks}, State) ->
    %% 发送赛季奖励
%%    ?MYLOG("cym", "State ~p~n", [State]),
    spawn(fun() ->send_month_end_rank_reward(State, 1) end),
    db:execute("TRUNCATE TABLE `top_pk_rank_kf`"),
    check_monthly_clear(),
    case State of
        [_|_] ->
            {noreply, []};
        _ ->
            {noreply, State}
    end;

do_handle_cast(_Msg, State) ->
    {noreply, State}.
do_handle_info(monthly_clear_ranks, State) ->
    %% 发送赛季奖励
%%    ?MYLOG("cym", "State ~p~n", [State]),
    send_month_end_rank_reward(State, 1),
    db:execute("TRUNCATE TABLE `top_pk_rank_kf`"),
    check_monthly_clear(),
    case State of
        [_|_] ->
            {noreply, []};
        _ ->
            {noreply, State}
    end;

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% internal
load() ->
    {MonthStartTime, _} = utime:get_month_unixtime_range(),
    SQL = io_lib:format("SELECT `role_id`, `role_name`, `career`, `power`, `platform`, `server`, `grade_num`, `star_num`, `rank_lv`, `point`, `server_id`, `match_count` FROM `top_pk_rank_kf` WHERE `time` >= ~p ORDER BY `rank_lv` DESC, `point` DESC, `power` DESC LIMIT ~p",
        [MonthStartTime, ?RANK_NUM_MAX]),
    All = db:get_all(SQL),
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





%% 赛季清除
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
    case data_top_pk:get_end_reward(Rank) of
        [] ->
            ok;
        Reward ->
            %%log
	        if
		        MatchCount >= LimitCount ->
			        lib_log_api:log_top_pk_season_reward(ServerId, RoleId, RoleName, Rank, Reward),
			        Title   = utext:get(?season_reward_title),
			        Content = utext:get(?season_reward_content, [Rank]),
			        mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail,
				        [[RoleId], Title, Content, Reward]);
		        true ->
                    Title   = utext:get(?season_reward_title),
                    Content = utext:get(2810003),
                    mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail,
                        [[RoleId], Title, Content, []])
	        end
    end,
    send_month_end_rank_reward(T, Rank + 1).


send_rank_list(Node, SendRoleId, _List, _MyServerId, _OpenDay) ->
    List = lists:sublist(_List, ?rank_show_num_max),
%%    ?MYLOG("cym", "MyServerId ~p~n", [MyServerId]),
%%    {MinDay, MaxDay} = data_top_pk:get_kv(local_match_day,default),
%%    ?MYLOG("cym", "OpenDay ~p~n", [OpenDay]),
%%    ?MYLOG("cym", "List ~p~n", [List]),
%%    if
%%        OpenDay >= MinDay andalso OpenDay =< MaxDay ->
%%            Data = [{RoleId, RoleName, Career, Power, GuildName, Platform, Server, RankLv, Point} ||
%%                #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, guild_name = GuildName,
%%                    platform = Platform, server = Server, rank_lv = RankLv, point = Point} <- List, MyServerId == Server];
%%        true ->
%%            Data = [{RoleId, RoleName, Career, Power, GuildName, Platform, Server, RankLv, Point} ||
%%                #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, guild_name = GuildName,
%%                    platform = Platform, server = Server, rank_lv = RankLv, point = Point} <- List]
%%    end,
    Data = [{RoleId, RoleName, Career, Power, GuildName, Platform, Server, RankLv, Point} ||
        #rank_role{role_id = RoleId, role_name = RoleName, career = Career, power = Power, guild_name = GuildName,
            platform = Platform, server = Server, rank_lv = RankLv, point = Point} <- List],
%%    ?MYLOG("cym", "kf RankList ~p~n", [Data]),
    {ok, BinData} = pt_281:write(28115, [Data]),
    lib_server_send:send_to_uid(Node, SendRoleId, BinData).