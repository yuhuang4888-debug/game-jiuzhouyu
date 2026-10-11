%% ---------------------------------------------------------------------------
%% @doc role.hrl

%% @author hjh
%% @since  2016-12-06
%% @deprecated 角色信息
%% ---------------------------------------------------------------------------

%% -define(ETS_ROLE_MAJOR, ets_role_major).
-define(ETS_ROLE_SHOW, ets_role_show).

%% 角色信息(操作只能在进程,数据重要,保证唯一性)
%% -record(ets_role_major, {id}).

%% 角色信息展示(数据不重要,不能过于频繁)
%% 只能在进程中更新数据
-record(ets_role_show, {
        id = 0
        , figure = undefined
        , online_flag = 0
        , last_login_time = 0
        , last_logout_time = 0
        , combat_power = 0
        , f_combat_power = 0      % 当天首次登录的战力
        , h_combat_power = 0
        , dun_daily_map = #{}     % 需要缓存的副本日常次数##Key:DunId/DunType Value:次数
        , team_id = 0             % 队伍id
        , team_3v3_id = 0             % 队伍id
    }).

%% 获取玩家展示的信息
-define(sql_role_show_other_info, <<"
    select
        pl.online_flag, pl.last_login_time, pl.last_logout_time, ps.last_combat_power, ph.hightest_combat_power
    from player_login as pl left join player_high as ph on pl.id = ph.id left join player_state as ps on pl.id = ps.id WHERE pl.id = ~p">>).

%% 获取最后退出游戏时候玩家战力
-define(sql_role_last_logout_power, <<"select last_combat_power from player_state where id = ~p">>).

%% ------------------------------------------------
%% @doc 查看角色信息
%% ------------------------------------------------
