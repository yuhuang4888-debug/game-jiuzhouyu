%%-----------------------------------------------------------------------------
%% @Module  :       perfect_lover
%% @Author  :       huyihao
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-03-15
%% @Description:    完美恋人
%%-----------------------------------------------------------------------------
 
-record(perfect_lover_state, {
    act_subtype = 0,
    wedding_times_list = [],
    wedding_log_list = []       %% {男方玩家id, 女方玩家id, 时间}
}).

-record(wedding_times_info, {
    role_id = 0,
    lover_list = []
}).

-record(wedding_times_lover_info, {
    role_id = 0,
    lover_role_id = 0,
    times_list = []             %% {婚礼类型, 举行次数}
}).

-define(SelectPerfectLoverAllSql, 
    <<"SELECT `role_id_m`, `role_id_w`, `wedding_type`, `time` FROM `perfect_lover_times`">>).

-define(DeletePerfectLoverAllSql,
    <<"TRUNCATE TABLE `perfect_lover_times`">>).

-define(InsertPerfectLoverSql,
    <<"INSERT INTO `perfect_lover_times`(`role_id_m`, `role_id_w`, `wedding_type`, `time`) VALUES(~p, ~p, ~p, ~p)">>).