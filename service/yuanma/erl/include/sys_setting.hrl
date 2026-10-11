%% ---------------------------------------------------------------------------
%% @doc 系统设置头文件.
%% @author zhaoyu
%% @since  2014-07-17
%% ---------------------------------------------------------------------------

-ifndef(SYS_SETTING_HRL).
-define(SYS_SETTING_HRL, ok).
-define(SYS_SETTING_SELECT, <<"SELECT `setting` from `player_sys_setting` where `player_id`=~p LIMIT 1">>).
-define(SYS_SETTING_REPLACE_INTO, <<"REPLACE INTO `player_sys_setting` (`player_id`, `setting`) values (~p, ~p)">>).


-define(TRUE, 1).
-define(FALSE, 0).


%% 系统设置结构 Ps:修改这个record的时候要修改lib_sys_setting:type_to_setting_type()
-record(sys_setting, {
        reject_team = ?FALSE          %% 拒绝组队邀请
        ,reject_chat = ?FALSE         %% 拒绝陌生私聊
        ,reject_friend = ?FALSE       %% 拒绝好友申请
    }
).

-endif.                               %% SYS_SETTING_HRL


