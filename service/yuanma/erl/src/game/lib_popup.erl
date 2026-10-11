%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_popup.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2022-01-25
%%% @modified
%%% @description    功能弹窗库函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_popup).

% -include("common.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("popup.hrl").
-include("server.hrl").
-include("temple_awaken.hrl").

-export([login/1, popup_timeout/2, fin_temple_chapter/3]).

% -compile(export_all).

%%% ======================================= exported functions =====================================

%% 登录请求所有弹窗
%% @return #player_status{}
login(PS) ->
    PopupIds = data_popup:get_all_popup_ids(),
    init_popup_map(PopupIds, #{}, PS).

%% 定时触发模块弹窗
%% @return #player_status{}
popup_timeout(PS, PopupId) ->
    #player_status{sid = SId, popup = #popup{popup_map = PopupM}} = PS,
    send_popup(SId, PopupId),
    TRef = set_popup_timer(PopupId),
    PS#player_status{popup = #popup{popup_map = PopupM#{PopupId => TRef}}}.

%% 完成神殿觉醒阶段
%% @param ChapterInfo :: {章节id, 子章节id}
%% @return ok
fin_temple_chapter(#player_status{figure = #figure{lv = Lv}} = PS, StageList, {ChapterId, SubChapId} = ChapterInfo) ->
    F1 = fun(#stage_chapter_status{status = Status}) -> Status >= ?STAGE_COMPLETE end,
    F2 = fun(#stage_chapter_status{status = Status}) -> Status /= ?STAGE_GOT end,
    % 等级条件获取
    AllStage = data_temple_awaken:list_sub_chapter_stage(ChapterId, SubChapId),
    F = fun(Stage) ->
        #base_temple_awaken_stage{open_con = OpenCon} = data_temple_awaken:get_temple_awaken_stage(ChapterId, SubChapId, Stage),
        {_, N} = ulists:keyfind(lv, 1, OpenCon, {lv, 0}),
        N
    end,
    LvLim = lists:max(lists:map(F, AllStage)),
    % 全部任务完成, 至少有一项奖励未领取, 达到开放等级
    case {lists:all(F1, StageList), lists:any(F2, StageList), length(AllStage) == length(StageList), Lv > LvLim} of
        {true, true, true, true} ->
            #player_status{sid = SId} = PS,
            PopupIds = data_popup:get_popup_ids(?MOD_TEMPLE_AWAKEN, 0),
            cond_trigger_popup(PopupIds, SId, ?COND_TRIGGER_TEMPLE_TASK, ChapterInfo);
        _ ->
            skip
    end,
    ok.

%%% ======================================= private functions ======================================

%% 初始化弹窗信息映射
%% @return #player_status{}
init_popup_map([], PopupMap, PS) -> PS#player_status{popup = #popup{popup_map = PopupMap}};
init_popup_map([PopupId | T], AccM, PS) ->
    #player_status{sid = SId, login_time_before_last = LastLoginTime} = PS,
    #base_popup{
        login_trigger = LoginTrigger
    ,   cond_trigger = CondTrigger
    } = data_popup:get_base_popup(PopupId),
    NowTime = utime:unixtime(),
    % 登录触发处理
    case LoginTrigger of
        ?LOGIN_TRIGGER_FIRST ->
            case utime:is_same_date(NowTime, LastLoginTime) of
                true -> skip;
                false -> send_popup(SId, PopupId)
            end;
        ?LOGIN_TRIGGER_ANY -> send_popup(SId, PopupId);
        ?LOGIN_TRIGGER_COND -> login_trigger_cond(CondTrigger, PS)
    end,
    % 定时条件触发处理
    TRef = set_popup_timer(PopupId),
    init_popup_map(T, AccM#{PopupId => TRef}, PS).

%% 根据条件设置定时器
%% @return reference() | undefined
set_popup_timer(PopupId) ->
    #base_popup{
        cond_trigger = CondTrigger
    } = data_popup:get_base_popup(PopupId),
    case lists:keyfind(?COND_TRIGGER_INTERVAL, 1, CondTrigger) of
        {_, Interval} -> TRef = erlang:send_after(timer:seconds(Interval), self(), {'mod', ?MODULE, popup_timeout, [PopupId]});
        _ -> TRef = undefined
    end,
    TRef.

%% 触发条件弹窗
cond_trigger_popup([], _, _, _) -> skip;
cond_trigger_popup([PopupId | T], SId, CondType, CondInfo) ->
    #base_popup{
        cond_trigger = CondTrigger
    } = data_popup:get_base_popup(PopupId),
    {_, CondInfos} = ulists:keyfind(CondType, 1, CondTrigger, {0, []}),
    case lists:member(CondInfo, CondInfos) of
        true -> send_popup(SId, PopupId); % 默认只有一处触发弹窗,不作递归
        false -> cond_trigger_popup(T, SId, CondType, CondInfo)
    end.

%% 发送弹窗
send_popup(SId, PopupId) ->
    % ?PRINT("popup ~p~n", [PopupId]),
    lib_server_send:send_to_sid(SId, pt_102, 10211, [PopupId]).

%% 登录触发条件
login_trigger_cond([], _) -> skip;
login_trigger_cond([{?COND_TRIGGER_INTERVAL, _} | T], PS) -> login_trigger_cond(T, PS); % 固定时间间隔不处理
login_trigger_cond([{?COND_TRIGGER_TEMPLE_TASK, [{ChapterId, SubChapId} = ChapterInfo|_]} | T], PS) -> % 神殿觉醒条件触发检测
    #player_status{temple_awaken = TA} = PS,
    #status_temple_awaken{temple_awaken_map = Map} = TA,
    #chapter_status{sub_chapters = SubChapters} = maps:get(ChapterId, Map, #chapter_status{}),
    #sub_chapter_status{status = SubStatus, stage_lists = StageList} = ulists:keyfind(SubChapId, #sub_chapter_status.sub_chapter, SubChapters, #sub_chapter_status{status = ?SUBTEMPLE_LOCK}),
    SubStatus == ?SUBTEMPLE_PROCESS andalso fin_temple_chapter(PS, StageList, ChapterInfo), % 当前子章进行中并前往判断是否触发弹窗
    login_trigger_cond(T, PS);
login_trigger_cond([_ | T], PS) -> login_trigger_cond(T, PS).