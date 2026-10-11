%% ---------------------------------------------------------------------------
%% @doc questionnaire.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-12-09
%% @deprecated 问卷调查
%% ---------------------------------------------------------------------------

-record(status_questionnaire, {
        type_list = []
    }).

-define(sql_role_questionnaire_select, <<"SELECT question_type FROM role_questionnaire WHERE role_id = ~p">>).
-define(sql_role_questionnaire_replace, <<"REPLACE INTO role_questionnaire(role_id, question_type) VALUES (~p, ~p)">>).