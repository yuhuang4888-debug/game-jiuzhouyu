%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_normal.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-02-05
%% @Description:    普通副本
%%-----------------------------------------------------------------------------

-module (lib_dungeon_normal).

-export ([
    dunex_push_settlement/2
    ,dunex_get_send_reward/2
    ]).

%% 普通副本不推送结算
dunex_push_settlement(_, _) -> ok.

%% 普通副本没有奖励
dunex_get_send_reward(_, _) -> [].