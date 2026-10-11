%% ---------------------------------------------------------------------------
%% @doc lib_mon_pic_event

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/3/16
%% @deprecated  
%% ---------------------------------------------------------------------------
-module(lib_mon_pic_event).
-include("server.hrl").

%% API
-compile([export_all]).


active_event(Ps, AchivList, TotalLv, Quality, PicId) ->
    lib_achievement_api:async_event(Ps#player_status.id, lib_achievement_api, mon_pic_event, {AchivList, TotalLv}),
    lib_achievement_api:active_mon_pic(Ps, Quality),
    LastPS = lib_push_gift_api:mon_pic_active(Ps, Quality, PicId),
    lib_up_power:refresh_mon_pic(LastPS),
    LastPS.
