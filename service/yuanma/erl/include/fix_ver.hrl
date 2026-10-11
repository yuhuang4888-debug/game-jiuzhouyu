%%%-------------------------------------------------------------------
%%% @author suyougame
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 7月 2022 9:29
%%%-------------------------------------------------------------------
-author("suyougame").

-define(current_patch_key,      1).      %% 当前补丁版本id的key

-define(current_patch_id,       0).      %% 初始化补丁id（可以用来控制新开服的无需进行旧补丁）

-record(fix_state, {
    current_patch_id = 0
}).

-define(sql_fix_ver_select, <<"select value from fix_var_kv where `key` = ~p">>).
-define(sql_fix_ver_replace, <<"replace into fix_var_kv(`key`, `value`) values(~p, '~s')">>).

