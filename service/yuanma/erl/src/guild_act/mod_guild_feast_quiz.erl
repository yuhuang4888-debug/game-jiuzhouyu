%%-----------------------------------------------------------------------------
%% @Module  :       mod_guild_feast_quiz
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-11-02
%% @Description:    公会宴会活动-答题
%%-----------------------------------------------------------------------------
-module(mod_guild_feast_quiz).

-include("guild_feast.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("chat.hrl").

-export([start/2]).
-export([init/1, callback_mode/0, handle_event/4, terminate/3, code_change/4]).

-export([
    send_quiz_info/2
    , answer/7
    , enter_scene/3
    , stop/1
    , set_topic_time/1
    , add_role_point/5
]).

start(GuildId, TopicList) ->
    gen_statem:start_link(?MODULE, [GuildId, TopicList], []).

callback_mode() ->
    handle_event_function.

init([GuildId, TopicList]) ->
    State = init_topics(GuildId, TopicList),
    NewState = sel_topic(State),
    {ok, answer, NewState}.

send_quiz_info(Pid, RoleId) ->
    gen_statem:cast(Pid, {'send_quiz_info', RoleId}).

set_topic_time(QuizPid) ->
    gen_statem:cast(QuizPid, {'set_topic_time'}).

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数     AnswerType::integer() 答题类型 1: 选择题 2:简答题
%%                    RoleId::integer() 玩家id，
%%                    RoleName::string() 玩家名字
%%                    GuildId::integer()   公会Id
%%                    Answer:: integer()|string()   答案
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
answer(Pid, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName) ->
    gen_statem:call(Pid, {'answer', RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName}).

stop(Pid) ->
    gen_statem:cast(Pid, 'stop').

enter_scene(Pid, RoleId, GuildId) ->
    gen_statem:cast(Pid, {'enter_scene', RoleId, GuildId}).

handle_event(Type, Msg, StateName, State) ->
    case catch do_handle_event(Type, Msg, StateName, State) of
        {'EXIT', _R} ->
            ?ERR("handle_exit_error:~p~n", [[Type, Msg, StateName, _R]]),
            {keep_state, State};
        Reply ->
            Reply
    end.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, Status, _Extra) ->
    {ok, StateName, Status}.


%%根据公会id，初始化出题的id列表
init_topics(GuildId, TopicList) ->
    #status_quiz{guild_id = GuildId, tlist = TopicList}.

sel_topic(State) ->
    #status_quiz{guild_id = GuildId, tlist = TList, ref = OldRef, no = No} = State,
    case TList of
        [Id | L] ->
            case data_guild_feast:get_question_cfg(Id) of
                #gfeast_question_cfg{id = Id, topic_type = Type, right = Right, question = Content, right_answer = Answer} ->
                    NowTime = utime:unixtime(),
                    TopicVaildTime = lib_guild_feast:get_question_vaild_time(Type),   %%题目有效时间
                    Etime = NowTime + TopicVaildTime,  %%题目的结束时间
                    util:cancel_timer(OldRef),  %%取消定时器
                    Ref = erlang:send_after(TopicVaildTime * 1000, self(), 'time_out'),  %%结束时间到达后，发送time_out信息
                    %% 推送给客户端题目更新了
                    Args = [?QUIZ_STATUS_ANSWER, Etime, No + 1, Id],  %%只要发题目给客户端，让客户端自己读取吧
                    {ok, BinData} = pt_402:write(40217, Args),   %%打包的时候，也会判断是否是二级制
                    SceneId = data_guild_feast:get_cfg(scene_id),  %%场景id
                    lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, GuildId, BinData),
                    State#status_quiz{
                        status = ?QUIZ_STATUS_ANSWER,  %% 状态是答题中
                        etime = Etime,                 %% 当前题目结束时间
                        tlist = L,                     %% 剩下的题目
                        tid = Id,                      %% 当前题目的id
                        content = Content,             %% 题目描述
                        answer = Answer,               %% 题目文本答案
                        ref = Ref                      %% 定时器
                        , no1_name = undefine          %% 第一名
                        , no = No + 1                  %% 题号
                        , right_answer = Right         %% 选择题正确答案
                        , type = Type                  %% 题目类型
                    };
                _ ->
                    State
            end;
        _ ->
            State
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述
%% @param    参数     AnswerType::integer() 答题类型 1: 选择题 2:简答题
%%                    RoleId::integer() 玩家id，
%%                    RoleName::string() 玩家名字
%%                    GuildId::integer()   公会Id
%%                    Answer:: integer()|string()   答案
%% @return   返回值   {1, #gfeast_rank_role{}} | {0, 发送的字符串是否和答案内容匹配(true | false)}
%% @history  修改历史
%% -----------------------------------------------------------------
%% 选择题
do_handle_event({call, From}, {'answer', RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName}, answer, #status_quiz{type = 1} = State) ->
    #status_quiz{answer = RightAnswer, right_answer = Right, no = TopicNo, role_list = RList, tid = Tid} = State,
    Now = utime:unixtime(),
    % 选择题时，系统自动发送对应选项到答题频道
    case is_integer(RoleAnswer) andalso RoleAnswer >= 1 andalso RoleAnswer =< 4 of
        true ->
            #gfeast_question_cfg{answer1 = Answer1, answer2 = Answer2, answer3 = Answer3, answer4 = Answer4} = data_guild_feast:get_question_cfg(Tid),
            AnswerList = [Answer1, Answer2, Answer3, Answer4],
            SysMsg = lists:nth(RoleAnswer, AnswerList),
            lib_chat:send_msg_by_server(RoleId, ?CHAT_CHANNEL_REPLY, 0, SysMsg, []);
        false ->
            skip
    end,
    % 答题判断
    IsSame = RoleAnswer == Right,
    RoleAnsInfo = lists:keyfind(RoleId, #gfeast_rank_role.role_id, RList),
    {SerId, SerNum} = {config:get_server_id(), config:get_server_num()},
    AnsInfo = #gfeast_rank_role{
        role_id = RoleId, role_name = RoleName, guild_id = GuildId,
        server_id = SerId, server_num = SerNum, time = Now
    },
    case {IsSame, RoleAnsInfo} of
        {true, false} -> % 首次答对题,先记录下玩家答题时的信息,每题倒计时结束后统一总分排名
            IsKf = lib_guild_feast:is_kf(),
            if
                IsKf ->
                    mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, answer,
                        [config:get_server_id(), config:get_server_num(), TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName]),
                    NewState = State#status_quiz{
                        rank = 1,
                        role_list = [AnsInfo | RList]
                    };
                true ->
                    NewState = State#status_quiz{
                        rank = 1,
                        role_list = [AnsInfo | RList]
                    }
            end,
            lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_quiz_event, 1),
            {next_state, answer, NewState, [{reply, From, {1, AnsInfo}}]};
        {true, _} ->
            {next_state, answer, State, [{reply, From, {0, RoleAnsInfo}}]}; % 选择题只能答一次,再次回答当错误
        _ ->
            case is_integer(RoleAnswer) of
                true ->
                    Res = false,
                    NewState = State#status_quiz{role_list = [AnsInfo | RList]};
                false ->
                    Res = ulists:is_same_string(RoleAnswer, RightAnswer),
                    NewState = State
            end,
            {next_state, answer, NewState, [{reply, From, {0, Res}}]}
    end;

do_handle_event({call, From}, {'answer', RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName}, answer, #status_quiz{type = 2} = State) ->
    #status_quiz{answer = RightAnswer, no = TopicNo, role_list = RList} = State,
    Now = utime:unixtime(),
    %% 去掉空格如果是中文版
    case lib_vsn:is_cn() orelse lib_vsn:is_jp() of
        true ->
            RePattern = [[194,160]],  %% [194,160] 是客户端对空格的特殊转义
            RoleAnswerNew = re:replace(RoleAnswer, RePattern, "", [global, {return, list}]);
        _ ->
            RoleAnswerNew = RoleAnswer
    end,
    IsSame = ulists:is_same_string(RoleAnswerNew, RightAnswer),  %%是否同一个字符串
    % 答题判断
    RoleAnsInfo = lists:keyfind(RoleId, #gfeast_rank_role.role_id, RList),
    {SerId, SerNum} = {config:get_server_id(), config:get_server_num()},
    AnsInfo = #gfeast_rank_role{
        role_id = RoleId, role_name = RoleName, guild_id = GuildId,
        server_id = SerId, server_num = SerNum, time = Now
    },
    case {IsSame, RoleAnsInfo} of
        {true, false} -> % 首次答对题,先记录下玩家答题时的信息,每题倒计时结束后统一总分排名
            IsKf = lib_guild_feast:is_kf(),
            if
                IsKf ->
                    mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, answer,
                        [config:get_server_id(), config:get_server_num(), TopicNo, RoleId, RoleName, RoleAnswer, AnswerType, GuildId, GuildName]),
                    NewState = State#status_quiz{
                        rank = 1,
                        role_list = [AnsInfo | RList]
                    };
                true ->
                    NewState = State#status_quiz{
                        rank = 1,
                        role_list = [AnsInfo | RList]
                    }
            end,
            lib_achievement_api:async_event(RoleId, lib_achievement_api, guild_quiz_event, 1),
            {next_state, answer, NewState, [{reply, From, {1, AnsInfo}}]};
        {true, _} ->
            {next_state, answer, State, [{reply, From, {1, RoleAnsInfo}}]};
        _ ->
            {next_state, answer, State, [{reply, From, {0, false}}]}
    end;



do_handle_event(cast, {'send_quiz_info', RoleId}, _StateName, State) ->
    #status_quiz{
        status = Status,
        etime = Etime,
        tid = Id,
        no = No,
        content = _Content
    } = State,
    Args = [Status, Etime, No, Id],
    {ok, BinData} = pt_402:write(40217, Args),
    lib_server_send:send_to_uid(RoleId, BinData),
    {keep_state, State};


do_handle_event(cast, {'set_topic_time'}, _StateName, State) ->
    #status_quiz{
        status = _Status,
        etime = EndTime,
        tid = _Id,
        no = _No,
        ref = OldRef,
        content = _Content
    } = State,
    Now = utime:unixtime(),
    Time = EndTime - Now,
    if
        Time > ?min_quiz_time -> %% 大于5秒则重新计算时间
            NewEndTime = Now + ?min_quiz_time,
            Ref = util:send_after(OldRef, ?min_quiz_time * 1000, self(), 'time_out');
        true ->
            NewEndTime = EndTime,
            Ref = OldRef
    end,
    %% todo   通知时间
    {keep_state, State#status_quiz{etime = NewEndTime, ref = Ref}};

do_handle_event(cast, 'stop', _, State) ->
    #status_quiz{ref = OldRef} = State,
    util:cancel_timer(OldRef),
    {stop, normal, State};


%% -----------------------------------------------------------------
%% @desc     功能描述  题目自然结束， 计算奖励(有没有连对奖励) - 发送奖励 ->判断是否最后一题，设置定时器刷新题目，进入等待状态-->
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_handle_event(info, 'time_out', answer, #status_quiz{guild_id = _GuildId, rank = _Rank} = State) ->
    %%计算奖励
    %%发送奖励
    %%判断是否最后一题
    #status_quiz{tlist = Tlist, no = TopicNo, tid = _Id, answer = RightAnswer, guild_id = GuildId,
        guild_point_list = _GuildPointList} = State,
    IsKf = lib_guild_feast:is_kf(),
    SceneId = data_guild_feast:get_cfg(scene_id),
    % 本题积分结算
    case IsKf of
        true ->
            SerId = config:get_server_id(),
            mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, refresh_quiz_rank, [SerId, TopicNo, RightAnswer]);
        false ->
            mod_guild_feast_mgr:refresh_quiz_rank(TopicNo, RightAnswer)
    end,
    State1 = State#status_quiz{role_list = []},
    % 下一题状态
    case Tlist of
        [] ->
            if
                IsKf ->
                    NewState = State1#status_quiz{status = ?QUIZ_STATUS_WAIT, no = 0};
                true ->
                    NewState = State1#status_quiz{status = ?QUIZ_STATUS_WAIT, no = 0}  %%不刷新题目了
            end,
            Args = [?QUIZ_STATUS_ANSWER, 0, 0, 0],  %%只要发题目给客户端，让客户端自己读取吧
            {ok, BinData} = pt_402:write(40217, Args),   %%打包的时候，也会判断是否是二级制
            lib_server_send:send_to_scene(SceneId, ?DEF_SCENE_PID, GuildId, BinData),
            {next_state, overtime, NewState};  %%答题结束了
        _ ->
            erlang:send(self(), 'refresh_topic'),
            NewState = State1#status_quiz{ref = [], status = ?QUIZ_STATUS_WAIT, rank = 0, role_list = []},
            {next_state, wait, NewState}
    end;


do_handle_event(info, 'refresh_topic', wait, State) ->
    NewState = sel_topic(State),
    {next_state, answer, NewState};

do_handle_event(info, {'send_quiz_rank', RoleId, GuildId}, _, State) ->
    #status_quiz{guild_point_list = GuildPointList, guild_role_map = RoleMap} = State,
    IsKf = lib_guild_feast:is_kf(),
    if
        IsKf == true ->
            RoleList = maps:get(GuildId, RoleMap, []),
            SortRoleList =
                if
                    RoleList == [] ->
                        [];
                    true ->
                        lib_guild_feast:sort_role_by_point(RoleList)
                end,
            PackRoleList = [{Rank2, Name2, Point2} || {_RoleId2, Name2, Point2, _Time2, Rank2} <- SortRoleList],
            PackRoleListLast = lists:sublist(PackRoleList, 3),
            mod_clusters_node:apply_cast(mod_kf_guild_feast_topic, send_quiz_rank, [config:get_server_id(), RoleId, GuildId, PackRoleListLast]);
        true ->
            lib_guild_feast:send_rank_to_client(GuildPointList, RoleMap, RoleId, GuildId)
    end,
    {keep_state, State};

do_handle_event(info, {'send_quiz_rank_by_guild', GuildId}, _Status, State) ->
    mod_guild_feast_mgr:send_quiz_rank_by_guild(GuildId),
    {keep_state, State};


do_handle_event(cast, {'enter_scene', _RoleId, GuildId}, StateName, State) ->
    case StateName of
        overtime ->
            skip;
        _ ->
            mod_guild_feast_mgr:send_quiz_rank_by_guild(GuildId)
    end,
    {keep_state, State};

do_handle_event({call, From}, _, StateName, State) ->
%%	?PRINT("++++++++++++ ~n", []),
    {next_state, StateName, State, [{reply, From, 0}]};

do_handle_event(_Type, _Msg, StateName, State) ->
    ?DEBUG("no match :~p~n", [[_Type, _Msg, StateName]]),
    {next_state, StateName, State}.

add_role_point(RoleId, RoleName, GuildId, Point, RoleMap) ->
    RoleList = maps:get(GuildId, RoleMap, []),
    case lists:keyfind(RoleId, 1, RoleList) of
        {_, _RoleName, OldPoint, _time} ->
            RoleListNew = lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, Point + OldPoint, utime:unixtime()});
        _ ->
            RoleListNew = lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, Point, utime:unixtime()})
    end,
    maps:put(GuildId, RoleListNew, RoleMap).

% add_guild_point(GuildId, Name, Point, GuildPointList) ->
% 	case lists:keyfind(GuildId, 1, GuildPointList) of
% 		{_, _Name, OldPoint, _Time} ->
% 			GuildPointListNew = lists:keystore(GuildId, 1, GuildPointList,
% 				{GuildId, Name, Point + OldPoint, utime:unixtime()}),
% 			{GuildPointListNew, {GuildId, Name, Point + OldPoint, utime:unixtime(),
% 				config:get_server_id(), config:get_server_num()}};
% 		_ ->
% 			GuildPointListNew = lists:keystore(GuildId, 1, GuildPointList, {GuildId, Name, Point, utime:unixtime()}),
% 			{GuildPointListNew, {GuildId, Name, Point, utime:unixtime(),
% 				config:get_server_id(), config:get_server_num()}}

% 	end.
