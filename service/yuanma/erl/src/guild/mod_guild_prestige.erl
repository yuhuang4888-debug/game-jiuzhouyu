% %% ---------------------------------------------------------------------------
% %% @doc mod_guild_prestige
% %% @author
% %% @since
% %% @deprecated
% %% ---------------------------------------------------------------------------
-module(mod_guild_prestige).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([

    ]).
-compile(export_all).
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("guild_prestige.hrl").
-include("goods.hrl").
-include("guild.hrl").
%%-----------------------------

add_prestige(Args) ->
    gen_server:cast(?MODULE, {add_prestige, Args}).

init_guild_member_prestige(Args) ->
    gen_server:cast(?MODULE, {init_guild_member_prestige, Args}).

%% 凌晨四点职位同步
sync_guild_job(Args) ->
    gen_server:cast(?MODULE, {sync_guild_job, Args}).

% 离开公会后不清空
leave_guild(_Args) -> skip.
    %gen_server:cast(?MODULE, {leave_guild, Args}).

join_guild(Args) ->
    gen_server:cast(?MODULE, {join_guild, Args}).

%% 没周一检查重置
week_reset() ->
    gen_server:cast(?MODULE, {week_reset}).

send_role_prestige(Args) ->
    gen_server:cast(?MODULE, {send_role_prestige, Args}).

send_today_prestige(Args) ->
    gen_server:cast(?MODULE, {send_today_prestige, Args}).

get_role_prestige(RoleId) ->
    gen_server:call(?MODULE, {get_role_prestige, RoleId}).

get_high_guild_title(RoleId) ->
    gen_server:call(?MODULE, {get_high_guild_title, RoleId}).

use_limit(RoleId, GoodsTypeId) ->
    case change_to_source(none, GoodsTypeId) of
        ?SOURCE_NOT_LIMIT -> ok;
        _ ->
            case catch gen_server:call(?MODULE, {use_limit, RoleId}) of
                {ok, LeftNum} -> {ok, LeftNum};
                {fail, Res} -> {fail, Res};
                _Err ->
                    ?ERR("use_limit err : ~p~n", [_Err]),
                    {fail, ?FAIL}
            end
    end.

gm_degrade(RoleId, Second) ->
    gen_server:cast(?MODULE, {gm_degrade, RoleId, Second}).

gm_clear_record(RoleId) ->
    gen_server:cast(?MODULE, {gm_clear_record, RoleId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("handle_call Request: ~p, Reason=~p~n", [Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast Msg: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ====================
%% 初始化
%% ====================

init([]) ->
    State = init_do(),
    ?PRINT("init : ~p~n", [State]),
    {ok, State}.

%% ====================
%% hanle_call
%% ====================
do_handle_call({get_role_prestige, RoleId}, _From, State) ->
    #prestige_state{role_map = RoleMap} = State,
    #role_prestige{all_prestige = AllPrestige} = maps:get(RoleId, RoleMap, #role_prestige{role_id = RoleId}),
    Reply = {ok, AllPrestige},
    {reply, Reply, State};

do_handle_call({get_high_guild_title, RoleId}, _From, State) ->
    #prestige_state{role_map = RoleMap} = State,
    #role_prestige{high_title = HighTitle} = maps:get(RoleId, RoleMap, #role_prestige{role_id = RoleId}),
    Reply = {ok, HighTitle},
    {reply, Reply, State};

do_handle_call({use_limit, RoleId}, _From, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{job_id = JobId} = RolePrestige ->
            NowTime = utime:unixtime(),
            InitRolePrestige = init_role_records(RolePrestige),
            #role_prestige{prestige_records = PrestigeRecords} = InitRolePrestige,
            {_TodayGot, TodayGotLimit} = get_today_get(PrestigeRecords, NowTime),
            LimitMax = get_prestige_limit_max(JobId),
            case TodayGotLimit >= LimitMax of
                false -> Reply = {ok, LimitMax - TodayGotLimit};
                _ -> Reply = {fail, ?ERRCODE(err400_prestige_limit_today)}
            end;
        _ ->
            LimitMax = get_prestige_limit_max(3),
            Reply = {ok, LimitMax}
    end,
    {reply, Reply, State};


do_handle_call(_Request, _From, State) -> {reply, ok, State}.

%% ====================
%% hanle_cast
%% ====================
do_handle_cast({add_prestige, [RoleId, ProductType, GoodsTypeId, Num, UseGoodsId]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    OldRolePrestige = maps:get(RoleId, RoleMap, #role_prestige{role_id = RoleId, records_init = 1}),
    InitRolePrestige = init_role_records(OldRolePrestige),
    case check_add_prestige(InitRolePrestige, ProductType, GoodsTypeId, Num, UseGoodsId) of
        {ok, NewRolePrestige, RealAddNum} ->
            case RealAddNum < Num of
                true -> % 超出每日上限，通知客户端弹提示
                    ok;
                _ -> skip
            end,
            NowTime = utime:unixtime(),
            Produce = #produce{type = ProductType, reward = [{?TYPE_CURRENCY, GoodsTypeId, RealAddNum}]},
            lib_goods_api:send_reward_by_id(Produce, RoleId),
            #role_prestige{all_prestige = AllPrestige, prestige_records = PrestigeRecords, job_id = JobId} = NewRolePrestige,
            {TodayGot, TodayGotLimit} = get_today_get(PrestigeRecords, NowTime),
            lib_server_send:send_to_uid(RoleId, pt_400, 40031, [AllPrestige, TodayGot, TodayGotLimit]),
            PrestigeTitleId = lib_guild_data:get_prestige_title_id(AllPrestige),
            StartTime = utime_logic:logic_week_start(NowTime),
            GotList = [Got ||#prestige_data{prestige_got = Got, time = Time} <- PrestigeRecords, Time >= StartTime, Time =< NowTime],
            WeekGot = lists:sum(GotList),
            LimitMax = get_prestige_limit_max(JobId),
            lib_server_send:send_to_uid(RoleId, pt_400, 40030, [AllPrestige, PrestigeTitleId, WeekGot, LimitMax]),
            %% 更新公会成员
            mod_guild:add_role_prestige(RoleId, AllPrestige, RealAddNum),
            NewRoleMap = maps:put(RoleId, NewRolePrestige, RoleMap),
            NewState = State#prestige_state{role_map = NewRoleMap};
        _ -> % 超出上限
            NewRoleMap = maps:put(RoleId, InitRolePrestige, RoleMap),
            NewState = State#prestige_state{role_map = NewRoleMap}
    end,
    {noreply, NewState};

do_handle_cast({leave_guild, [?GEVENT_KICK_OUT | _]}, State) -> {noreply, State};
do_handle_cast({leave_guild, [?GEVENT_QUIT, RoleId, _GuildId]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{} = RolePrestige ->
            NewRolePrestige = RolePrestige#role_prestige{all_prestige = 0, prestige_records = []},
            NewRoleMap = maps:put(RoleId, NewRolePrestige, RoleMap),
            replace_role_prestige(NewRolePrestige),
            {noreply, State#prestige_state{role_map = NewRoleMap}};
        _ ->
            {noreply, State}
    end;

do_handle_cast({join_guild, [RoleId, _GuildId]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{all_prestige = AllPrestige} ->
            mod_guild:add_role_prestige(RoleId, AllPrestige, 0),
            {noreply, State};
        _ ->
            {noreply, State}
    end;

do_handle_cast({week_reset}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    StartTime = NowTime - ?ONE_WEEK_SECONDS,
    DegradeVal = get_degrade_val(),
    F = fun(RoleId, RolePrestige, Acc) ->
        InitRolePrestige = init_role_records(RolePrestige),
        #role_prestige{all_prestige = AllPrestige, prestige_records = PrestigeRecords} = InitRolePrestige,
        LastWeekGot = get_last_week_prestige(PrestigeRecords, StartTime, NowTime-1),
        case LastWeekGot < DegradeVal of
            true ->
                PrePrestige = get_pre_prestige(AllPrestige),
                PrestigeTitleId = lib_guild_data:get_prestige_title_id(PrePrestige),
                TitleId = lib_guild_data:get_prestige_title_id(AllPrestige),
                if
                    PrestigeTitleId =/= TitleId -> %% 降级发邮件
                        lib_log_api:log_degrade_guild_title(RoleId, LastWeekGot, AllPrestige, PrePrestige, NowTime),
                        TitleName = data_guild:get_title_name(PrestigeTitleId),
                        lib_mail_api:send_sys_mail([RoleId], utext:get(4000028), utext:get(4000029, [LastWeekGot, DegradeVal, util:make_sure_binary(TitleName)]), []),
                        mod_guild:add_role_prestige(RoleId, PrePrestige, 0),
                        update_role_prestige(RoleId, PrePrestige),
                        NewRolePrestige = InitRolePrestige#role_prestige{all_prestige = PrePrestige, prestige_records = []},
                        maps:put(RoleId, NewRolePrestige, Acc);
                    PrestigeTitleId == TitleId -> %% 已经降到最低级，清0， 不发邮件
                        lib_log_api:log_degrade_guild_title(RoleId, LastWeekGot, AllPrestige, PrePrestige, NowTime),
                        mod_guild:add_role_prestige(RoleId, PrePrestige, 0),
                        update_role_prestige(RoleId, PrePrestige),
                        NewRolePrestige = InitRolePrestige#role_prestige{all_prestige = PrePrestige, prestige_records = []},
                        maps:put(RoleId, NewRolePrestige, Acc);
                    true ->
                        NewRolePrestige = InitRolePrestige#role_prestige{prestige_records = []},
                        maps:put(RoleId, NewRolePrestige, Acc)
                end;
            _ ->
                NewRolePrestige = InitRolePrestige#role_prestige{prestige_records = []},
                maps:put(RoleId, NewRolePrestige, Acc)
        end
    end,
    NewRoleMap = maps:fold(F, RoleMap, RoleMap),
    delete_prestige_data(),
    {noreply, State#prestige_state{role_map = NewRoleMap}};

do_handle_cast({gm_degrade, RoleId, Second}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    NowTime = utime:unixtime(),
    StartTime = NowTime - Second,
    DegradeVal = get_degrade_val(),
    delete_prestige_data(),
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{} = RolePrestige ->
            #role_prestige{all_prestige = AllPrestige, prestige_records = PrestigeRecords} = RolePrestige,
            LastWeekGot = get_last_week_prestige(PrestigeRecords, StartTime, NowTime-1),
            case LastWeekGot < DegradeVal of
                true ->
                    PrePrestige = get_pre_prestige(AllPrestige),
                    case PrePrestige =/= AllPrestige of
                        true ->
                            lib_log_api:log_degrade_guild_title(RoleId, LastWeekGot, AllPrestige, PrePrestige, NowTime),
                            PrestigeTitleId = lib_guild_data:get_prestige_title_id(PrePrestige),
                            TitleName = data_guild:get_title_name(PrestigeTitleId),
                            lib_mail_api:send_sys_mail([RoleId], utext:get(4000028), utext:get(4000029, [LastWeekGot, DegradeVal, util:make_sure_binary(TitleName)]), []),
                            mod_guild:add_role_prestige(RoleId, PrePrestige, 0),
                            update_role_prestige(RoleId, PrePrestige),
                            NewRolePrestige = RolePrestige#role_prestige{all_prestige = PrePrestige, prestige_records = []},
                            NewRoleMap = maps:put(RoleId, NewRolePrestige, RoleMap);
                        _ ->
                            NewRoleMap = RoleMap
                    end;
                _ ->
                    NewRoleMap = RoleMap
            end;
        _ ->
            NewRoleMap = RoleMap
    end,
    {noreply, State#prestige_state{role_map = NewRoleMap}};

do_handle_cast({gm_clear_record, RoleId}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{all_prestige = AllPrestige} = RolePrestige ->
            db:execute(io_lib:format(<<"delete from role_presitge_data where role_id=~p">>, [RoleId])),
            NewRolePrestige = RolePrestige#role_prestige{prestige_records = []},
            lib_server_send:send_to_uid(RoleId, pt_400, 40031, [AllPrestige, 0, 0]),
            NewRoleMap = maps:put(RoleId, NewRolePrestige, RoleMap);
        _ ->
            NewRoleMap = RoleMap
    end,
    {noreply, State#prestige_state{role_map = NewRoleMap}};

do_handle_cast({init_guild_member_prestige, [GuildId, MemberIdList]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    F = fun({RoleId,JobId}, {Acc, AccRoleMap}) ->
        case maps:get(RoleId, AccRoleMap, 0) of
            #role_prestige{all_prestige = AllPrestige} = RolePretige ->
                NewRolePretige = RolePretige#role_prestige{job_id = JobId},
                {[{RoleId, AllPrestige}|Acc], maps:put(RoleId, NewRolePretige, AccRoleMap)};
            _ ->
                case lists:member(JobId, ?BE_APPOINT_POS_LIST) of
                    true ->
                        NewAccRoleMap = maps:put(RoleId, #role_prestige{job_id = JobId, role_id = RoleId, records_init = 1}, AccRoleMap),
                        {[{RoleId, 0}|Acc], NewAccRoleMap};
                    false -> {Acc, AccRoleMap}
                end
        end
    end,
    {ReturnList, NewRoleMap} = lists:foldl(F, {[], RoleMap}, MemberIdList),
    mod_guild:update_members_prestige(GuildId, ReturnList),
    {noreply, State#prestige_state{role_map = NewRoleMap}};

do_handle_cast({sync_guild_job, MemberIdList}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    F = fun({RoleId,JobId}, AccRoleMap) ->
        case maps:get(RoleId, AccRoleMap, 0) of
            #role_prestige{} = RolePretige ->
                NewRolePretige = RolePretige#role_prestige{job_id = JobId},
                maps:put(RoleId, NewRolePretige, AccRoleMap);
            _ ->
                case lists:member(JobId, ?BE_APPOINT_POS_LIST) of
                    true -> maps:put(RoleId, #role_prestige{job_id = JobId, role_id = RoleId, records_init = 1}, AccRoleMap);
                    false -> AccRoleMap
                end
        end
        end,
    NewRoleMap = lists:foldl(F, RoleMap, MemberIdList),
    {noreply, State#prestige_state{role_map = NewRoleMap}};

do_handle_cast({send_role_prestige, [RoleId, Sid]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{} = RolePrestige ->
            NowTime = utime:unixtime(),
            InitRolePrestige = init_role_records(RolePrestige),
            #role_prestige{all_prestige = AllPrestige, prestige_records = PrestigeRecords, job_id = JobId} = InitRolePrestige,
            PrestigeTitleId = lib_guild_data:get_prestige_title_id(AllPrestige),
            StartTime = utime_logic:logic_week_start(NowTime),
            GotList = [Got ||#prestige_data{prestige_got = Got, time = Time} <- PrestigeRecords, Time >= StartTime, Time =< NowTime],
            WeekGot = lists:sum(GotList),
            LimitMax = get_prestige_limit_max(JobId),
            ?PRINT("add_prestige WeekGot: ~p~n JobId ~p LimitMax ~p ~n", [{AllPrestige, WeekGot, PrestigeTitleId}, JobId, LimitMax]),
            lib_server_send:send_to_sid(Sid, pt_400, 40030, [AllPrestige, PrestigeTitleId, WeekGot, LimitMax]),
            NewRoleMap = maps:put(RoleId, InitRolePrestige, RoleMap),
            NewState = State#prestige_state{role_map = NewRoleMap},
            {noreply, NewState};
        _ ->
            PrestigeTitleId = lib_guild_data:get_prestige_title_id(0),
            lib_server_send:send_to_sid(Sid, pt_400, 40030, [0, PrestigeTitleId, 0, 2000]),
            {noreply, State}
    end;

do_handle_cast({send_today_prestige, [RoleId, Sid]}, State) ->
    #prestige_state{role_map = RoleMap} = State,
    case maps:get(RoleId, RoleMap, 0) of
        #role_prestige{} = RolePrestige ->
            NowTime = utime:unixtime(),
            InitRolePrestige = init_role_records(RolePrestige),
            #role_prestige{all_prestige = AllPrestige, prestige_records = PrestigeRecords} = InitRolePrestige,
            {TodayGot, TodayGotLimit} = get_today_get(PrestigeRecords, NowTime),
            lib_server_send:send_to_sid(Sid, pt_400, 40031, [AllPrestige, TodayGot, TodayGotLimit]);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_400, 40031, [0, 0, 0])
    end,
    {noreply, State};

do_handle_cast(_Msg, State) -> {noreply, State}.

%% ====================
%% hanle_info
%% ====================
do_handle_info(_Info, State) -> {noreply, State}.


init_do() ->
    case select_role_prestige() of
        [] -> #prestige_state{};
        DbList ->
            F = fun([RoleId, AllPrestige, HighTitle, OldGuild], Map) ->
                RolePrestige = make_record(role_prestige, [RoleId, AllPrestige, HighTitle, OldGuild]),
                maps:put(RoleId, RolePrestige, Map)
            end,
            RoleMap = lists:foldl(F, #{}, DbList),
            #prestige_state{role_map = RoleMap}
    end.

init_role_records(RolePrestige) ->
    #role_prestige{role_id = RoleId, records_init = RecordsInit} = RolePrestige,
    case RecordsInit == 0 of
        true ->
            case select_prestige_data(RoleId) of
                [] -> RolePrestige#role_prestige{records_init = 1};
                DbList ->
                    F = fun([PrestigeGot, GotSource, Time], Acc) ->
                        PrestigeData = make_record(prestige_data, [PrestigeGot, GotSource, Time]),
                        [PrestigeData|Acc]
                    end,
                    PrestigeRecords = lists:foldl(F, [], DbList),
                    RolePrestige#role_prestige{records_init = 1, prestige_records = PrestigeRecords}
            end;
        _ ->
            RolePrestige
    end.


make_record(role_prestige, [RoleId, AllPrestige, HighTitle, OldGuild]) ->
    #role_prestige{role_id = RoleId, all_prestige = AllPrestige, high_title = HighTitle, old_guild = OldGuild};
make_record(prestige_data, [PrestigeGot, GotSource, Time]) ->
    #prestige_data{prestige_got = PrestigeGot, got_source = GotSource, time = Time}.

%% check fun
check_add_prestige(RolePrestige, ProductType, _GoodsTypeId, Num, UseGoodsId) ->
    NowTime = utime:unixtime(),
    #role_prestige{role_id = RoleId, job_id = JobId, all_prestige = AllPrestige, high_title = OHighTitle, prestige_records = PrestigeRecords} = RolePrestige,
    GotSource = change_to_source(ProductType, UseGoodsId),
    case GotSource == ?SOURCE_LIMIT of
        true ->
            TodayGotLimit = get_today_got_limit(PrestigeRecords, NowTime),
            LimitMax = get_prestige_limit_max(JobId),
            case TodayGotLimit < LimitMax of
                true -> RealAddNum = min(Num, LimitMax - TodayGotLimit);
                _ -> RealAddNum = 0
            end;
        _ ->
            RealAddNum = Num
    end,
    case RealAddNum > 0 of
        true ->
            NewAllPrestige = AllPrestige + RealAddNum,
            TitleId = lib_guild_data:get_prestige_title_id(NewAllPrestige),
            NewHighTitle = ?IF(TitleId > OHighTitle, TitleId, OHighTitle),
            NewPrestigeData = make_record(prestige_data, [RealAddNum, GotSource, NowTime]),
            NewRolePrestige = RolePrestige#role_prestige{all_prestige = NewAllPrestige, high_title = NewHighTitle, prestige_records = [NewPrestigeData|PrestigeRecords]},
            replace_role_prestige(NewRolePrestige),
            replace_prestige_data(RoleId, NewPrestigeData),
            {ok, NewRolePrestige, RealAddNum};
        _ ->
            false
    end.

change_to_source(ProductType, UseGoodsId) ->
    case lists:member(UseGoodsId, data_guild_m:get_config(prestige_limit_goods)) of
        true -> ?SOURCE_LIMIT;
        _ ->
            case lists:member(ProductType, [guild_assist, task]) of
                true -> ?SOURCE_LIMIT;
                _ -> ?SOURCE_NOT_LIMIT
            end
    end.

get_prestige_limit_max(JobId) ->
    {_, Limit} = ulists:keyfind(JobId, 1, data_guild_m:get_config(prestige_day_max), {JobId, 2000}),
    Limit.
%%    data_guild_m:get_config(prestige_day_max).

get_degrade_val() -> data_guild_m:get_config(title_degrade_val).

get_today_got_limit(PrestigeRecords, NowTime) ->
    get_today_got_limit(PrestigeRecords, NowTime, 0).

get_today_got_limit([], _NowTime, Acc) -> Acc;
get_today_got_limit([#prestige_data{prestige_got = GotNum, got_source = GotSource, time = Time}|PrestigeRecords], NowTime, Acc) ->
    case GotSource == ?SOURCE_LIMIT of
        true ->
            case utime_logic:is_logic_same_day(NowTime, Time) of
                true ->
                    get_today_got_limit(PrestigeRecords, NowTime, Acc+GotNum);
                _ -> %% PrestigeRecords是按时间由小到大排序的, 一旦出现时间不满足，后续时间也不满足
                    Acc
            end;
        _ ->
            get_today_got_limit(PrestigeRecords, NowTime, Acc)
    end.

get_today_get(InitRolePrestige, NowTime) ->
    get_today_get(InitRolePrestige, NowTime, 0, 0).

get_today_get([], _NowTime, Acc, Acc1) -> {Acc, Acc1};
get_today_get([#prestige_data{prestige_got = GotNum, got_source = GotSource, time = Time}|PrestigeRecords], NowTime, Acc, Acc1) ->
    case utime_logic:is_logic_same_day(NowTime, Time) of
        true ->
            case GotSource == ?SOURCE_LIMIT of
                true ->
                    get_today_get(PrestigeRecords, NowTime, Acc, Acc1+GotNum);
                _ ->
                    get_today_get(PrestigeRecords, NowTime, Acc+GotNum, Acc1)
            end;
        _ ->
            get_today_get(PrestigeRecords, NowTime, Acc, Acc1)
    end.

get_last_week_prestige(PrestigeRecords, StartTime, EndTime) ->
    get_last_week_prestige(PrestigeRecords, StartTime, EndTime, 0).

get_last_week_prestige([], _StartTime, _EndTime, Acc) -> Acc;
get_last_week_prestige([#prestige_data{prestige_got = GotNum, time = Time}|PrestigeRecords], StartTime, EndTime, Acc) ->
    case Time >= StartTime andalso Time =< EndTime of
        true ->
            get_last_week_prestige(PrestigeRecords, StartTime, EndTime, Acc+GotNum);
        _ ->
            get_last_week_prestige(PrestigeRecords, StartTime, EndTime, Acc)
    end.

get_pre_prestige(Prestige) ->
    PrestigeList = data_guild:get_prestige_list(),
    get_pre_prestige(PrestigeList, Prestige).

get_pre_prestige([], _Prestige) -> 0;
get_pre_prestige([{_TitleId, NeedPrestige}|PrestigeList], Prestige) ->
    case Prestige >= NeedPrestige of
        true ->
            case PrestigeList of
                [{_, NeedPrestige2}|_] ->
                    NeedPrestige2;
                _ ->
                    NeedPrestige
            end;
        _ ->
            get_pre_prestige(PrestigeList, Prestige)
    end.


%% db
select_role_prestige() ->
    db:get_all(?SQL_PRESITGE_SELECT).

select_prestige_data(RoleId) ->
    db:get_all(io_lib:format(?SQL_PRESITGE_DATA, [RoleId])).

replace_role_prestige(RolePrestige) ->
    #role_prestige{role_id = RoleId, all_prestige = AllPrestige, high_title = HighTitle, old_guild = OldGuild} = RolePrestige,
    db:execute(io_lib:format(?SQL_PRESITGE_REPLACE, [RoleId, AllPrestige, HighTitle, OldGuild])).

replace_prestige_data(RoleId, PrestigeData) ->
    #prestige_data{prestige_got = PrestigeGot, got_source = GotSource, time = Time} = PrestigeData,
    db:execute(io_lib:format(?SQL_PRESITGE_DATA_REPLACE, [RoleId, PrestigeGot, GotSource, Time])).

update_role_high_title(RoleId, HighTitle) ->
    db:execute(io_lib:format(?SQL_PRESITGE_TITLE_UPDATE, [HighTitle, RoleId])).

update_role_prestige(RoleId, PrePrestige) ->
    db:execute(io_lib:format(?SQL_PRESITGE_UPDATE, [PrePrestige, RoleId])).

update_role_prestige_old_guild(RoleId, OldGuild) ->
    db:execute(io_lib:format(?SQL_PRESITGE_GUILD_UPDATE, [OldGuild, RoleId])).

delete_role_prestige(RoleId) ->
    db:execute(io_lib:format(?SQL_PRESITGE_DELETE, [RoleId])).

delete_prestige_data() ->
    db:execute(io_lib:format(?SQL_PRESITGE_DATA_DELETE, [])).
