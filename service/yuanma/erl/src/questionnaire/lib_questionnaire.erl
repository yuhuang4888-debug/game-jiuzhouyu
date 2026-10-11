%% ---------------------------------------------------------------------------
%% @doc lib_questionnaire.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-12-09
%% @deprecated 问卷调查
%% ---------------------------------------------------------------------------
-module(lib_questionnaire).
-compile(export_all).

-include("server.hrl").
-include("questionnaire.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("common.hrl").

login(#player_status{id = RoleId} = Player) ->
    DbTypeList = db_role_questionnaire_select(RoleId),
    TypeList = lists:flatten(DbTypeList),
    StatusQuestionnaire = #status_questionnaire{type_list = TypeList},
    Player#player_status{questionnaire = StatusQuestionnaire}.

%% 完成问卷
finish(Player, QuestionType) ->
    case check_finish(Player, QuestionType) of
        {false, ErrCode} -> NewPlayer = Player;
        {true, {_Type, _SubType}} ->
            ErrCode = ?SUCCESS,
            #player_status{id = RoleId, questionnaire = StatusQuestionnaire} = Player,
            #status_questionnaire{type_list = TypeList} = StatusQuestionnaire,
            NewPlayer = Player#player_status{
                questionnaire = StatusQuestionnaire#status_questionnaire{type_list = [QuestionType|TypeList]}
                },
            db_role_questionnaire_replace(RoleId, QuestionType)
    end,
    {ok, BinData} = pt_332:write(33236, [ErrCode, QuestionType]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer}.

check_finish(Player, QuestionType) ->
    #player_status{questionnaire = StatusQuestionnaire, c_source = CSource} = Player,
    #status_questionnaire{type_list = TypeList} = StatusQuestionnaire,
    IsMember = lists:member(QuestionType, TypeList),
    {IsRight, {Type, SubType}} = is_right_question_type(QuestionType, CSource),
    if
        IsMember -> {false, ?ERRCODE(err332_question_had_finish)};
        IsRight == false -> {false, ?ERRCODE(err332_question_type_error)};
        true -> {true, {Type, SubType}}
    end.

%% 是否正确的问卷类型
is_right_question_type(QuestionType, Source) ->
    ActInfoL = lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_QUESTIONNAIRE),
    is_right_question_type_help(ActInfoL, [QuestionType, Source], {false, {0, 0}}).

is_right_question_type_help([], _, Result) -> Result;
is_right_question_type_help([#act_info{key = {Type, SubType}}|T], [QuestionType, Source], Result) ->
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    GIdL = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    F = fun(GradeId) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{condition = Condition} -> lists:member({questionnaire, QuestionType}, Condition);
            _ -> false
        end
    end,
    Source1 = erlang:list_to_atom(util:make_sure_list(Source)),
    {_, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, [Source1]}), % 渠道列表没配置，直接把当前渠道作为合法渠道
    case lists:any(F, GIdL) andalso lists:member(Source1, SourceList) of
        true -> {true, {Type, SubType}};
        false -> is_right_question_type_help(T, [QuestionType, Source], Result)
    end.

%% 是否完成
is_finish(Player, QuestionType) ->
    #player_status{questionnaire = StatusQuestionnaire} = Player,
    #status_questionnaire{type_list = TypeList} = StatusQuestionnaire,
    lists:member(QuestionType, TypeList).

%% 查询问卷调查的玩家信息
db_role_questionnaire_select(RoleId) ->
    Sql = io_lib:format(?sql_role_questionnaire_select, [RoleId]),
    db:get_all(Sql).

%% 插入问卷调查的玩家信息
db_role_questionnaire_replace(RoleId, QuestionType) ->
    Sql = io_lib:format(?sql_role_questionnaire_replace, [RoleId, QuestionType]),
    db:execute(Sql).