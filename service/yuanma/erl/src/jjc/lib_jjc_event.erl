%% ---------------------------------------------------------------------------
%% @doc lib_jjc_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/5/20
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_jjc_event).

%% API
-compile([export_all]).

-include("def_module.hrl").

finish_battle(RoleId, Lv, ChallengeTimes) ->
    %% 日常活跃度
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_JJC, 0, ChallengeTimes),
    %% 活动狂欢值
    lib_hi_point_api:hi_point_task_jjc(RoleId, Lv, ChallengeTimes),
    lib_eternal_valley_api:async_trigger(RoleId, [{jjc, ChallengeTimes}]),
    lib_task_api:join_jjc(RoleId, ChallengeTimes),
    lib_baby_api:join_jjc(RoleId, ChallengeTimes).
