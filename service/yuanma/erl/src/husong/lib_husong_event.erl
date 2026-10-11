%% ---------------------------------------------------------------------------
%% @doc lib_husong_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/5/8
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_husong_event).

%% API
-compile([export_all]).

-include("def_module.hrl").
-include("husong.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("figure.hrl").

start_husong(Ps) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Ps,
    mod_daily:increment(RoleId, ?MOD_HUSONG, ?HuSongDailyId), % 每日护送次数增加
    lib_hi_point_api:hi_point_task_husong(RoleId, Lv),
    lib_achievement_api:husong_event(Ps, []),
    lib_task_api:fin_husong(Ps, 1),
    lib_baby_api:fin_husong(Ps),
    lib_eternal_valley_api:async_trigger(RoleId, [{husong, 1}]),
    lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_HUSONG, ?MOD_SUB_HUSONG_ANGEL),
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_supreme_vip_api, fin_husong, [1]).

