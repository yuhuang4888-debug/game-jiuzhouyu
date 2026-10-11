%% ---------------------------------------------------------------------------
%% @doc subscribe.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-05
%% @deprecated 订阅
%% ---------------------------------------------------------------------------

% %% 订阅类型
% -define(SUBSCRIBE_TYPE_NONE,    0).
% -define(SUBSCRIBE_TYPE_SHENHAI, 1).        % 深海 之前的挂机订阅
% -define(SUBSCRIBE_TYPE_ACT,     2).        % 活动开启订阅

% %% 订阅类型列表
% -define(SUBSCRIBE_TYPE_LIST, [
%         ?SUBSCRIBE_TYPE_SHENHAI,
%         ?SUBSCRIBE_TYPE_ACT
%     ]).

%% 订阅state
-record(subscribe_state, {
    subscribe_map = #{}         % 订阅map #{模块Id => [#subscribe_act{},...]}
}).

% %% 订阅
% -record(subscribe, {
%         accname = ""                % 名字
%         , last_logout_time = 0      % 上次登出
%     }).

%% 活动开启订阅
-record(subscribe_act, {
    sh_uid = ""     % 深海uid(平台账号)
,   template_id     % 模板id
,   package_code    % 包代码
,   role_id         % 玩家id
,   onhook_tref     % 离线挂机模块计时器
}).

% %% 数据库
% -define(sql_role_subscribe_select, <<"select subscribe_type from role_subscribe where role_id = ~p">>).
% -define(sql_role_subscribe_replace, <<"replace into role_subscribe(role_id, subscribe_type) values(~p, ~p)">>).
% -define(sql_role_subscribe_delete, <<"delete from role_subscribe where role_id = ~p">>).
% -define(sql_role_subscribe_select_all, <<"
%     select
%         rs.subscribe_type, pl.accname, pl.last_logout_time from role_subscribe as rs, player_login as pl
%     where rs.role_id = pl.id">>).