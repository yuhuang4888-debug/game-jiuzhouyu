%% ---------------------------------------------------------------------------
%% @doc 邮件推送记录
%% @author xiaoxiang
%% @since  2017-02-28
%% @deprecated 邮件推送
%% ---------------------------------------------------------------------------

-define(PUSHMAIL_LV,            1).     % 个人等级升到X级
-define(PUSHMAIL_OPENSERVER,    2).     % 开服天数
-define(PUSHMAIL_DUNGEON,       3).     % 通过副本ID
-define(PUSHMAIL_ARRIVETIME,    4).     % 到达某个具体时间
-define(PUSHMAIL_MARGE,         5).     % 合服

-define(PUSH_LIST, [?PUSHMAIL_LV, ?PUSHMAIL_OPENSERVER, ?PUSHMAIL_DUNGEON, ?PUSHMAIL_ARRIVETIME, ?PUSHMAIL_MARGE]).

-define(MAX_TIME, 4294967296 - 1).

-define(PUSH_LIMIT_LV, 1).
-define(PUSH_LIMIT_SEX, 2).
-define(PUSH_LIMIT_CAREER, 3).

-record(pushmail, {
        id = 0,         %% 触发id 1个人等级升到X级, 2开服天数, 3通过副本id, 4到达某个具体时间 
        value = 0,  
        time = 0,
        limit = [],
        title = "",
        msg = "",
        accessory = [],
        about = ""
    }).

-record(base_pushmail, {
    id = 0,
    time = [],      %% 时间
    open_day = 0,   %% 开服天数
    merge_day = 0,  %% 合服天数
    lv = 0,         %% 等级
    career = [],    %% 职业
    sex = [],       %% 性别
    dun = 0,        %% 副本ID
    other = [],     %% 其他 end_open_day 有效开服天数  end_time有效日期 end_marge_day有效合服天数
    title = "",     %% 邮件标题       
    msg = "",       %% 邮件内容
    accessory = [], %% 附件
    about = ""    
    }).

-record(status_pushmail, {
        push_list = []
    }).

-record(push_state, {
        time_ref = none,
        server_ref = none
    }).


-define(sql_select_his, <<"select mail from pushmail where role_id = ~p">>).

-define(sql_replace_his, <<"replace into pushmail (role_id, mail) values (~p, ~p)">>).