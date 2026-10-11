%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_week_overview.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-07-22
%%% @modified
%%% @description    节日活动总览（周中、周末、节日活动）
%%% ------------------------------------------------------------------------------------------------
-module(lib_week_overview).

-include("common.hrl").
-include("custom_act.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("server.hrl").

-export([daily_refresh/0, send_reward_status/2, receive_reward/4]).

% -compile(export_all).

%%% ==================== exported functions ====================

%% 每日零点刷新
daily_refresh() ->
    OpSubtypeL = lib_custom_act_util:get_custom_act_open_list(),
    OpenTurnActL = [Act || #act_info{key = {Type, _}} = Act <- OpSubtypeL, Type == ?CUSTOM_ACT_TYPE_WEEK_OVERVIEW],
    lists:foreach(
    fun(ActInfo) ->
        spawn(
            fun() ->
                timer:sleep(2000), % 延迟2秒等待日计数器清理
                lib_player:apply_cast_all_online(?APPLY_CAST_STATUS, ?MODULE, send_reward_status, [ActInfo])
            end
        )
    end
    , OpenTurnActL).

%% 每日免费奖励信息
send_reward_status(Player, #act_info{key = {Type, SubType}, stime = STime}) ->
    #player_status{id = RoleId} = Player,
    StartDay = utime:diff_days(STime) + 1,

    GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId) ->
        #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
        {_, StartDaysRange} = ulists:keyfind(start_day, 1, Condition, {start_day, [{0, 0}]}),
        ulists:is_in_range(StartDaysRange, StartDay) /= false
    end,
    case ulists:find(F, GradeIds) of
        {ok, TodayGId} ->
            ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, TodayGId)),
            RewardStatus = ?IF(ReceiveTimes == 0, ?ACT_REWARD_CAN_GET, ?ACT_REWARD_HAS_GET),
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition1,
                format = Format,
                reward = Reward
            } = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, TodayGId),
            PackList = [{TodayGId, Format, RewardStatus, ReceiveTimes, Name, Desc, util:term_to_string(Condition1), util:term_to_string(Reward)}];
        _ ->
            PackList = []
    end,
    lib_server_send:send_to_uid(RoleId, pt_331, 33104, [Type, SubType, PackList]),
    ok.

%% 领取每日免费奖励
receive_reward(PS, Type, SubType, GradeId) ->
    #player_status{id = RoleId} = PS,

    CheckList = [
        {fun lib_custom_act_api:is_open_act/2, [Type, SubType]}, {fun is_lv_enough/3, [PS, Type, SubType]},
        {fun is_today_reward/3, [Type, SubType, GradeId]}, {fun has_not_received/4, [PS, Type, SubType, GradeId]}
    ],
    case check_list(CheckList) of
        true ->
            #custom_act_reward_cfg{reward = Reward} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = 'week_overview'}),
            mod_daily:increment(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, GradeId)),
            lib_log_api:log_custom_act_reward(PS, Type, SubType, GradeId, Reward),
            lib_server_send:send_to_uid(RoleId, pt_331, 33105, [?SUCCESS, Type, SubType, GradeId]);
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33105, [ErrCode, Type, SubType, GradeId])
    end.

%%% ==================== inner functions ====================

%% 条件列表检查
%% @return true | {false, ErrCode}
check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        true         -> check_list(T);
        {false, Res} -> {false, Res};    % {false, ?FAIL}都是非正常错误
        _            -> {false, ?FAIL}
    end.

check({Fun, Args}) when is_function(Fun) -> % 尽量每个条件采用单独函数
    apply(Fun, Args);

check(_) ->
    {false, ?FAIL}.

%% 等级是否足够
is_lv_enough(PS, Type, SubType) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    #custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, OpenLv} = ulists:keyfind(open_lv, 1, Condition, {open_lv, 0}),
    Lv >= OpenLv.

%% 是否为今天的奖励
is_today_reward(Type, SubType, GradeId) ->
    #act_info{stime = STime} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    #custom_act_reward_cfg{condition = Condition} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),

    StartDay = utime:diff_days(STime) + 1,
    {_, StartDaysRange} = ulists:keyfind(start_day, 1, Condition, {start_day, [{0, 0}]}),
    ulists:is_in_range(StartDaysRange, StartDay) /= false.

%% 今天是否有领取过
has_not_received(#player_status{id = RoleId}, Type, SubType, GradeId) ->
    ReceiveTimes = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, Type, ?CUSTOM_ACT_COUNTER_TYPE(SubType, GradeId)),
    ReceiveTimes == 0.
