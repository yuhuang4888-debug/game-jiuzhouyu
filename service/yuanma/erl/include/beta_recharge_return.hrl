%% ---------------------------------------------------------------------------
%% @doc beta_recharge_return.hrl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-28
%% @deprecated 封测充值返还
%% ---------------------------------------------------------------------------

%% 封测返还
-record(status_beta_recharge_return, {
        role_id = 0         % 命中的玩家id##大于0就是同步了
        , gold = 0          % 充值
        , days_utime = 0    % 登录天数的更新时间
        , login_days = 0    % 登录天数
}).

-define(sql_role_beta_recharge_return_select, <<"SELECT role_id, gold, days_utime, login_days FROM role_beta_recharge_return WHERE accid = ~p and accname = '~s'">>).
-define(sql_role_beta_recharge_return_replace, <<"REPLACE INTO role_beta_recharge_return(accid, accname, role_id, gold, days_utime, login_days) VALUES(~p, '~s', ~p, ~p, ~p, ~p)">>).

-define(sql_beta_recharge_return_select, <<"SELECT role_id, gold FROM beta_recharge_return WHERE accid = ~p and accname = '~s'">>).
-define(sql_beta_recharge_return_replace, <<"REPLACE INTO beta_recharge_return(accid, accname, role_id, gold, time) VALUES(~p, '~s', ~p, ~p, ~p)">>).