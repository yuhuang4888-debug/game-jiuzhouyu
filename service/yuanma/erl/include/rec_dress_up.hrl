%%%---------------------------------------------------------------------
%%% 个性装扮相关record定义
%%%---------------------------------------------------------------------

-define(DRESS_UP_BUBBLE,    1).           %% 气泡
-define(DRESS_UP_FRAME,     2).           %% 相框
-define(DRESS_UP_PICTURE,   5).           %% 头像

-define(TURN_PICTURE_KEY_1,   1).           %% 转生头像对应列表的键
-define(TURN_PICTURE_KEY_2,   2).           %% 默认头像初始化等级

-define(DRESS_ISUSING, 1).              %%装扮正在使用
-define(DRESS_UNUSING, 0).              %%装扮未被使用

-record(status_dress_up,
    {
        dress_list = [],                %%激活数据 [DressId=>{DressType, DressLv, IsUsed, DressExp}]
        attr = [],                      %%属性
        skill = []
    }).

-record(dress,
    {
        type = 0,                       
        active_list = [],               %%已激活的列表 [{id, level, time}]
        use_id = 0
    }).

%% ------------------------- base相关宏定义 --------------------------

%%装扮激活升星
-record(base_dress_act_rising,
    {
        dress_id = 0,                   %%裝扮id
        dress_star_lv = 0,              %%装扮星级
        dress_type = 0,                 %%裝扮類型
        dress_name = "",                %%裝扮名称
        dress_desc = "",                %%装扮描述
        dress_consume_id = 0,           %%消耗材料id
        dress_acti_exp = 0,             %%单个材料提供升星经验
        dress_starup_exp = 0,           %%装扮升星经验
        dress_starup_attr = []          %%当前属性
    }).

%%图鉴升级
-record(base_dress_illustration,
    {
        illu_lv = 0,                    %%图鉴等级
        illu_lvup_exp = 0,              %%图鉴升级经验
        illu_lvup_sttr =[]              %%图鉴升级属性
    }).

%%图鉴材料
-record(base_dress_illustration_mat,
    {
        illu_debris_id = 0,             %%物品id
        illu_exp = 0                    %%图鉴经验
    }).


%%装扮新
-record(base_dress_up_cfg,
    {
        type = 0,                       %%裝扮类型
        id = 0,                         %%id
        name = "",                      %%名字
        level = 0,                      %%等级
        cost = [],                      %%升级消耗
        attr = [],                      %%属性
        skill = 0,                       %%技能
        condition = [],                    %% 激活条件
        screen = []                     %% 职业筛选条件
    }).

%% ====================== role_dress_up 表操作 ======================
-define(sql_dress_up_select, <<"select dress_id, dress_lv, dress_type, is_used, time from role_dress_up where role_id = ~p ">>).
-define(sql_dress_up_replace, <<"replace into role_dress_up(role_id, dress_id, dress_lv, dress_type, is_used, time) values(~p,~p,~p,~p,~p,~p) ">>).
-define(sql_dress_up_update, <<"update role_dress_up set is_used = ~p where role_id = ~p and dress_id = ~p and dress_type = ~p ">>).

%% ====================== dress_up_enabled 表操作 ======================
-define(sql_dress_up_enabled_select, <<"select dress_id, dress_lv, dress_type, is_used, dress_exp from dress_up_enabled where player_id = ~p ">>).
-define(sql_dress_up_replace_enabled, <<"replace into dress_up_enabled(player_id, dress_id, dress_lv, dress_type, time, is_used, dress_exp) values(~p,~p,~p,~p,~p,~p,~p) ">>).
-define(sql_dress_up_update_enabled, <<"update dress_up_enabled set is_used = ~p, time = ~p where player_id = ~p and dress_id = ~p ">>).

%% ====================== dress_up_illustration_enable 表操作 ======================
-define(sql_dress_up_illu_select, <<"select illu_lv,illu_curr_exp from dress_up_illustration_enable where player_id = ~p ">>).
-define(sql_dress_up_replace_illu, <<"replace into dress_up_illustration_enable(player_id,illu_lv,illu_curr_exp) values(~p,~p,~p)">>).
