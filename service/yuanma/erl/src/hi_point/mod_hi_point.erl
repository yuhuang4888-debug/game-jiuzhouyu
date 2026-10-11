%%-----------------------------------------------------------------------------
%% @Module  :       mod_hi_point
%% @Author  :       Fwx
%% @Created :       2018-03-16
%% @Description:    嗨点活动
%%-----------------------------------------------------------------------------
-module(mod_hi_point).

-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("hi_point.hrl").
-include("figure.hrl").
-include("role.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-include("predefine.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    act_info/3,
    receive_reward/4,
    send_reward_status/2,
    complete_task/6,
    check_role_status/2,
    sync_user_info/4,
    all_info/2,
    act_end/1,
    daily_push/0,
    custom_act_start/1,
    reload/1
]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    List = db:get_all(io_lib:format(?select_hi_points, [])),
    F = fun([RoleId, SubType, ModId, SubId, Type, Count, IsPlus, Utime], AccMap) ->
        RoleMap = maps:get(SubType, AccMap, #{}),
        {Stime, Etime} = lib_hi_point:get_stime_etime(RoleId, SubType),
        #role_info{points_list = PotL} = maps:get(RoleId, RoleMap, #role_info{}),
        ConType = util:bitstring_to_term(Type),
        NewPotL = [#hi_points{key = {ModId, SubId, ConType}, count = util:bitstring_to_term(Count), is_plus = IsPlus, utime = Utime} | PotL],
        NewRoleMap = maps:put(RoleId, lib_hi_point:cal_sum_point(#role_info{points_list = NewPotL, stime = Stime, etime = Etime}, SubType), RoleMap),
        maps:put(SubType, NewRoleMap, AccMap)
        end,
    ActMap = lists:foldl(F, #{}, List),
    List1 = db:get_all(io_lib:format(?select_hi_points_reward, [])),
    F1 = fun([RoleId, SubType, Grade, RewardStatus, _Utime], AccMap) ->
        RoleMap = maps:get(SubType, AccMap, #{}),
        RoleInfo = maps:get(RoleId, RoleMap, #role_info{}),
        NewRSL = [{Grade, RewardStatus} | RoleInfo#role_info.reward_status],
        NewRoleMap = maps:put(RoleId, RoleInfo#role_info{reward_status = NewRSL}, RoleMap),
        maps:put(SubType, NewRoleMap, AccMap)
         end,
    NewActMap = lists:foldl(F1, ActMap, List1),
    %?PRINT("~p~n", [NewActMap]),
    {ok, #act_state{act_maps = NewActMap}}.

reload(SubType) ->
    gen_server:cast(?MODULE, {'reload', SubType}).

%% 用户登陆之后同步数据
sync_user_info(SubType,RoleId, Lv, PoiList) ->
    gen_server:cast(?MODULE, {'sync_user_info', SubType, RoleId, Lv,  PoiList}).

all_info(RoleId, Lv) ->
    gen_server:cast(?MODULE, {'all_info', RoleId, Lv}).

act_info(SubType, RoleId, Lv) ->
    gen_server:cast(?MODULE, {'act_info', SubType, RoleId, Lv}).

send_reward_status(RoleId, #act_info{key = {_, SubType}}) ->
    gen_server:cast(?MODULE, {'send_reward_status', SubType, RoleId});
send_reward_status(RoleId, SubType) ->
    gen_server:cast(?MODULE, {'send_reward_status', SubType, RoleId}).

%% 升级调用，比较特殊
check_role_status(RoleId, Lv) ->
    gen_server:cast(?MODULE, {'check_role_status', RoleId, Lv}),
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_HI_POINT),
    F = fun(SubType) ->
        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT, SubType) of
            true ->
                ?IF(is_statisfied_open_act(Lv, SubType),
                    gen_server:cast(?MODULE, {'complete_task', [SubType, RoleId, ?MOD_LEVEL, ?SUB_ID, lv, 1]}),
                    skip);
            false -> skip
        end
        end,
    lists:foreach(F, SubList).

complete_task(RoleId, RoleLv, ModId, SubId, ConditionType, Count) ->
    ?IF(lib_hi_point:is_open_per_hi(RoleLv),
        gen_server:cast(?MODULE, {'complete_task', [RoleId, ModId, SubId, ConditionType, Count]}),
        skip),
    SubList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_HI_POINT),
    F = fun(SubType) ->
        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT, SubType) of
            true ->
                ?IF(is_statisfied_open_act(RoleLv, SubType),
                    gen_server:cast(?MODULE, {'complete_task', [SubType, RoleId, ModId, SubId, ConditionType, Count]}),
                    skip);
            false -> skip
        end
        end,
    lists:foreach(F, SubList).

receive_reward(RoleId, SubType, GradeId, Reward) when SubType == ?PERSON_SUBTYPE ->
    gen_server:cast(?MODULE, {'receive_reward', RoleId, SubType, GradeId, Reward});
receive_reward(RoleId, SubType, GradeId, Reward) ->
%%    ?PRINT("receive_reward SubType, GradeId, :~p~n",[[SubType, GradeId]]),
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_HI_POINT, SubType) of
        true -> gen_server:cast(?MODULE, {'receive_reward', RoleId, SubType, GradeId, Reward});
        false -> lib_hi_point:send_error_code(RoleId, ?FAIL)
    end.

%% 定制活动嗨点结束
act_end(ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', ActInfo}).

%% 走自己的推送 以后有可能会清空任务嗨点值。暂时走自己的推送
daily_push() ->
    gen_server:cast(?MODULE, 'daily_push').

custom_act_start(ActInfo) ->
    gen_server:cast(?MODULE, {'custom_act_start', ActInfo}).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'reload', _SType}, _State) ->
    List = db:get_all(io_lib:format(?select_hi_points, [])),
    F = fun([RoleId, SubType, ModId, SubId, Type, Count, IsPlus, Utime], AccMap) ->
        RoleMap = maps:get(SubType, AccMap, #{}),
        {Stime, Etime} = lib_hi_point:get_stime_etime(RoleId, SubType),
        #role_info{points_list = PotL} = maps:get(RoleId, RoleMap, #role_info{}),
        ConType = util:bitstring_to_term(Type),
        NewPotL = [#hi_points{key = {ModId, SubId, ConType}, count = util:bitstring_to_term(Count), is_plus = IsPlus, utime = Utime} | PotL],
        NewRoleMap = maps:put(RoleId, lib_hi_point:cal_sum_point(#role_info{points_list = NewPotL, stime = Stime, etime = Etime}, SubType), RoleMap),
        maps:put(SubType, NewRoleMap, AccMap)
        end,
    ActMap = lists:foldl(F, #{}, List),
    List1 = db:get_all(io_lib:format(?select_hi_points_reward, [])),
    F1 = fun([RoleId, SubType, Grade, RewardStatus, _Utime], AccMap) ->
        RoleMap = maps:get(SubType, AccMap, #{}),
        RoleInfo = maps:get(RoleId, RoleMap, #role_info{}),
        NewRSL = [{Grade, RewardStatus} | RoleInfo#role_info.reward_status],
        NewRoleMap = maps:put(RoleId, RoleInfo#role_info{reward_status = NewRSL}, RoleMap),
        maps:put(SubType, NewRoleMap, AccMap)
         end,
    NewActMap = lists:foldl(F1, ActMap, List1),
    ?PRINT("~p~n", [NewActMap]),
    {ok, #act_state{act_maps = NewActMap}};

do_handle_cast('daily_push', State) ->
    lib_hi_point:push_info(State),
    {ok,State};

do_handle_cast({'custom_act_start',  ActInfo}, #act_state{act_maps = ActMap} = State) ->
    #act_info{key = {Type, SubType}, etime = Etime, stime = Stime} = ActInfo,
    case maps:get(SubType, ActMap, false) of
        false ->
            OnlineList = ets:tab2list(?ETS_ONLINE),
            ActName = lib_custom_act_api:get_act_name(Type, SubType),
            FList = [{Type, SubType, ActName, Stime, Etime, lib_hi_point:get_show_id(SubType)}],
            F = fun(#ets_online{id = RoleId}, RMap) ->
                % 在线的玩家都完成一下登录任务
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_hi_point_api, hi_point_task_login, []),
                lib_server_send:send_to_uid(RoleId, pt_333, 33300, [FList]),
                maps:put(RoleId, #role_info{}, RMap)
                end,
            RoleMap = lists:foldl(F, #{}, OnlineList),
            NewActMap = maps:put(SubType, RoleMap, ActMap),
            {ok,State#act_state{act_maps = NewActMap}};
        _ -> {ok,State}
    end;

do_handle_cast({'act_end', #act_info{key = {?CUSTOM_ACT_TYPE_HI_POINT, SubType}}} , State) ->
    #act_state{act_maps = ActMap} = State,
    send_mail_reward(ActMap, SubType),
    NewActMap = maps:remove(SubType, ActMap),
    Sql1 = io_lib:format(?delete_hi_points, [SubType]),
    Sql2 = io_lib:format(?delete_hi_points_reward, [SubType]),
    db:execute(Sql1),
    db:execute(Sql2),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [
        lib_server_send:send_to_uid(RoleId, pt_331, 33103, [[{?CUSTOM_ACT_TYPE_HI_POINT, SubType}]])
        || #ets_online{id = RoleId} <- OnlineList
    ],
    {ok,State#act_state{act_maps = NewActMap}};

do_handle_cast({'all_info', RoleId, Lv}, State) ->
    lib_hi_point:send_all_info(State, RoleId, Lv),
    {ok,State};

do_handle_cast({'act_info', SubType, RoleId, Lv}, State) ->
    lib_hi_point:send_hi_info(State, SubType, RoleId, Lv),
    {ok, State};

do_handle_cast({'sync_user_info', SubType, RoleId, Lv, PoiList}, State) ->
%%    ?MYLOG("zhi", "tongbuzhong~n", []),
    NewState = lib_hi_point:sync_user_info(State, SubType, RoleId, Lv,PoiList),
    {ok, NewState};

do_handle_cast({'check_role_status', RoleId, Lv}, State) ->
    {ok, NewState} = lib_hi_point:check_role_status(State, RoleId, Lv),
%%    ?PRINT("@@@NewState ~p ~n~n", [NewState]),
    {ok, NewState};

do_handle_cast({'send_reward_status', ?PERSON_SUBTYPE, RoleId}, State) ->
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(?PERSON_SUBTYPE, ActMap, #{}),
    NewState = case maps:get(RoleId, RoleMap, false) of
        false -> State;
        #role_info{etime = ETime} = RoleInfo ->
            case ETime > utime:unixtime() of
                true -> lib_hi_point:deal_send_reward(State,?PERSON_SUBTYPE, RoleId, RoleInfo);
                false -> State
            end
    end,
    {ok, NewState};
do_handle_cast({'send_reward_status', SubType, RoleId}, State) ->
    #act_state{act_maps = ActMap} = State,
    RoleMap = maps:get(SubType, ActMap, #{}),
    NewState = case maps:get(RoleId, RoleMap, false) of
        false -> State;
        RoleInfo ->
            lib_hi_point:deal_send_reward(State,SubType, RoleId, RoleInfo)
    end,
    {ok, NewState};

do_handle_cast({'complete_task', Arg}, State) ->
    {ok, NewState} = lib_hi_point:complete_task(State, Arg),
%%    ?PRINT("@@@NewState ~p ~n~n", [NewState]),
    {ok, NewState};

do_handle_cast({'receive_reward', RoleId, SubType, GradeId, Reward}, State) ->
    NowTime = utime:unixtime(),
    #act_state{act_maps = ActMap} = State,
%%    ?MYLOG("zhi", "33304 State ~p ~n", [State]),
    RoleMap = maps:get(SubType, ActMap, #{}),
    case maps:get(RoleId, RoleMap, false) of
        #role_info{reward_status = StatusList} = RoleInfo ->
            case lists:keyfind(GradeId, 1, StatusList) of
                {_, ?ACT_REWARD_CAN_GET} ->
                    db:execute(io_lib:format(?replace_hi_points_reward, [RoleId, SubType, GradeId, ?ACT_REWARD_HAS_GET, NowTime])),
                    lib_goods_api:send_reward_by_id(Reward, hi_points, RoleId),
                    {ok, Data} = pt_333:write(33304,  [?CUSTOM_ACT_TYPE_HI_POINT, SubType, GradeId]),
                    lib_server_send:send_to_uid(RoleId, Data),
%%                    ?PRINT("data ~p ~n", [Data]),
%%                    lib_server_send:send_to_uid(RoleId, pt_333, 33304, [?CUSTOM_ACT_TYPE_HI_POINT, SubType, GradeId]),
                    NewStatusL = lists:keystore(GradeId, 1, StatusList, {GradeId, ?ACT_REWARD_HAS_GET}),
                    NewRoleInfo = RoleInfo#role_info{reward_status = NewStatusL, utime = NowTime},
                    NewRoleMap = maps:put(RoleId, NewRoleInfo, RoleMap),
                    NewActMap = maps:put(SubType, NewRoleMap, ActMap),
                    NewState = State#act_state{act_maps = NewActMap};
                _ -> NewState = State
            end;
        _ ->
            NewState = State
    end,
    {ok, NewState};

do_handle_cast({'gm_compensation_dungeon_times'}, _State) ->
    init([]);

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        _Err ->
            {noreply, State}
    end.

do_handle_info({'send_all_info', RoleId}, State) ->
    lib_hi_point:send_all_info(State, RoleId, 0),
    {ok, State};
do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        _Err ->
            {noreply, State}
    end.

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

is_statisfied_open_act(RoleLv, SubType) ->
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType),
    case lists:keyfind(role_lv, 1, Condition) of
        false -> true;
        {role_lv,LimitLv} ->
            if
                RoleLv >= LimitLv -> true;
                true -> false
            end
    end.

%% 邮件形式发送玩家未领取的奖励
send_mail_reward(ActMap, SubType) ->
    case maps:get(SubType, ActMap, false) of
        false -> skip;
        RoleMap ->
            maps:map(
                fun(RoleId, RoleInfo) ->
                    #role_info{reward_status = RewardStatus} = RoleInfo,
                    GradeIds = [GradeId || {GradeId, Status} <- RewardStatus, Status== ?ACT_REWARD_CAN_GET],
                    timer:sleep(20),
                    send_mail_reward_do(SubType, RoleId, GradeIds)
                end
            , RoleMap)
    end.

send_mail_reward_do(_SubType, _RoleId, []) -> skip;
send_mail_reward_do(SubType, RoleId, [GradeId|Other]) ->
    case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_HI_POINT, SubType, GradeId) of
        #custom_act_reward_cfg{} = RewardCfg ->
            Reward = RewardCfg#custom_act_reward_cfg.reward,
            lib_mail_api:send_sys_mail([RoleId], utext:get(3310016), utext:get(3310017), Reward);
        _ ->
            skip
    end,
    send_mail_reward_do(SubType, RoleId, Other).









