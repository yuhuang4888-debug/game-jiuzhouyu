%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_custom_act_sys_mail.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-11-25
%%% @modified
%%% @description    定制活动 - 系统邮件(活动期间内系统按规则自动发放邮件)
%%% ------------------------------------------------------------------------------------------------
-module(lib_custom_act_sys_mail).

-include("common.hrl").
-include("custom_act.hrl").
-include("daily.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("rec_event.hrl").
-include("server.hrl").

-export([
    handle_event/2,
    daily_trigger/1,
    daily_trigger_ps/2
]).

% -compile(export_all).

%%% ====================================== exported functions ======================================

%% 玩家登录事件
%% @return {ok, #player_status{}}
handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    SubTypeIds = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_SYS_MAIL),
    PS1 = daily_trigger_ps(PS, SubTypeIds),
    {ok, PS1}.

%% 每日零点/四点触发
daily_trigger(ActInfo) ->
    #act_info{key = {_, SubType}} = ActInfo,
    lib_player:apply_cast_all_online(?APPLY_CAST_SAVE, ?MODULE, daily_trigger_ps, [[SubType]]).

%% @return #player_status{}
daily_trigger_ps(PS, SubTypeIds) ->
    lists:foldl(fun daily_trigger_one/2, PS, SubTypeIds).

%% 处理触发单个活动子类型
%% @return #player_status{}
daily_trigger_one(SubType, PS) ->
    CustomActCfg = lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_SYS_MAIL, SubType),
    case check_sys_mail_conditions(PS, CustomActCfg) of
        {true, Title, Content, GradeId, Attachment} ->
            NowTime = utime:unixtime(),
            PS1 = save_last_mail_time(PS, SubType, NowTime),
            mod_mail_queue:add(?MOD_AC_CUSTOM, [PS#player_status.id], Title, Content, Attachment),
            lib_log_api:log_custom_act_reward(PS1, ?CUSTOM_ACT_TYPE_SYS_MAIL, SubType, GradeId, Attachment),
            PS1;
        _ ->
            PS
    end.

%%% ======================================== inner functions =======================================

%% 获取最新邮件发送时间
get_last_mail_time(PS, SubType) ->
    #player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,

    Key = {?CUSTOM_ACT_TYPE_SYS_MAIL, SubType},
    case maps:get(Key, DataMap, false) of
        #custom_act_data{data = Data} when is_record(Data, custom_act_sys_mail) ->
            #custom_act_sys_mail{last_mail_time = LastMailTime} = Data;
        _ ->
            LastMailTime = 0
    end,
    LastMailTime.

%% 更新最新邮件发送时间
%% @return #player_status{}
save_last_mail_time(PS, SubType, LastMailTime) ->
    #player_status{id = RoleId, status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,

    Key = {?CUSTOM_ACT_TYPE_SYS_MAIL, SubType},
    #custom_act_data{data = Data} = CustomActData = maps:get(Key, DataMap,
        #custom_act_data{id = Key, type = ?CUSTOM_ACT_TYPE_SYS_MAIL, subtype = SubType, data = #custom_act_sys_mail{}}),
    Data1 = Data#custom_act_sys_mail{last_mail_time = LastMailTime},
    CustomActData1 = CustomActData#custom_act_data{data = Data1},
    DataMap1 = DataMap#{Key => CustomActData1},
    StatusCustomAct1 = StatusCustomAct#status_custom_act{data_map = DataMap1},
    lib_custom_act:db_save_custom_act_data(RoleId, CustomActData1),

    PS#player_status{status_custom_act = StatusCustomAct1}.

%% 获取系统邮件附件(奖励)
get_sys_mail_attachment(PS, SubType, GradeId) ->
    ActInfo = lib_custom_act_util:get_custom_act_open_info(?CUSTOM_ACT_TYPE_SYS_MAIL, SubType),
    RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_SYS_MAIL, SubType, GradeId),
    RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg),
    RewardList.

%% 检查是否满足发放邮件的条件
%% @return {true, Title, Content, GradeId, Attachment} | {false, ErrCode}
check_sys_mail_conditions(PS, CustomActCfg) ->
    #custom_act_cfg{subtype = SubType, clear_type = ResetType, condition = Condition} = CustomActCfg,
    Condition1 = [{reset_type, ResetType} | Condition],
    case check_list(Condition1, [PS, SubType]) of
        true ->
            {_, TitleId, ContentId} = ulists:keyfind(mail, 1, Condition, {mail, 0, 0}), % 默认为空标题内容邮件
            {Title, Content} = {utext:get(TitleId), utext:get(ContentId)},
            {_, GradeId} = ulists:keyfind(grade_id, 1, Condition, {grade_id, 0}),
            Attachment = get_sys_mail_attachment(PS, SubType, GradeId),
            {true, Title, Content, GradeId, Attachment};
        _ ->
            {false, ?FAIL}
    end.

%% 条件列表检查
%% @return true | {false, ErrCode}
check_list([], [_PS, _SubType]) -> true;
check_list([H|T], [PS, SubType]) ->
    case check(H, [PS, SubType]) of
        true -> check_list(T, [PS, SubType]);
        _    -> {false, ?FAIL}
    end.

check({min_lv, MinLv}, [PS, _]) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    Lv >= MinLv;

check({source_list, SourceList}, [PS, _]) ->
    #player_status{source = Source} = PS,
    Source1 = list_to_atom(util:make_sure_list(Source)),
    lists:member(Source1, SourceList);

check({reset_type, ?CUSTOM_ACT_CLEAR_NULL}, [PS, SubType]) -> % 活动期间是否有发放过
    LastMailTime = get_last_mail_time(PS, SubType),
    LastMailTime == 0; % 未发放过

check({reset_type, ?CUSTOM_ACT_CLEAR_ZERO}, [PS, SubType]) ->
    LastMailTime = get_last_mail_time(PS, SubType),
    not utime:is_today(LastMailTime); % 今天未发放过;

check({reset_type, ?CUSTOM_ACT_CLEAR_FOUR}, [PS, SubType]) ->
    LastMailTime = get_last_mail_time(PS, SubType),
    not utime:is_logic_same_day(LastMailTime); % 当前逻辑天未发放过;

check({grade_id, GradeId}, [PS, SubType]) ->
    case lib_custom_act_check:check_receive_reward(PS, ?CUSTOM_ACT_TYPE_SYS_MAIL, SubType, GradeId) of
        {true, _ActInfo, _NewReceiveTimes, _RewardList, _RewardCfg} -> true;
        _ -> false
    end;

check(_, _) ->
    true.