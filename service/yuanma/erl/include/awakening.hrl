%%-----------------------------------------------------------------------------
%% @Module  :       awakening
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-08
%% @Description:    天命觉醒
%%-----------------------------------------------------------------------------

-define(AWAKENING_LV, 370).%% 天命等级

-record(awakening_cell_cfg, {
    id = 0,
    task_id = 0,
    name = "",
    pre_id = 0,
    next_id = 0,
    attr = [],
    priority_consume = [],
    exp_consume = 0
    }).

-record(awakening, {
    role_id = 0,
    active_ids = [],
    max_active_id = 0,  % 最大激活,为了计算掉落
    attr = []
    }).

-define(sql_select_role_awakening, <<"select cell_id from awakening where role_id = ~p">>).
-define(sql_insert_role_awakening, <<"insert into awakening (role_id, cell_id) values (~p, ~p)">>).
