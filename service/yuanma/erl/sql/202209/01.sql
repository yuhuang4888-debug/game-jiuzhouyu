alter table role_questionnaire drop primary key;
alter table role_questionnaire add primary key (role_id, question_type);