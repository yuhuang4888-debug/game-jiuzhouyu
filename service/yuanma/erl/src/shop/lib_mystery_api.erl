%%%--------------------------------------
%%% @Module  : lib_mystery_api
%%% @Author  : zengzy 
%%% @Created : 2017-11-28
%%% @Description:  使魔系统
%%%--------------------------------------
-module(lib_mystery_api).
-compile(export_all).
-export([

]).

-include("server.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("shop.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").


%% ---------------------------------- 商店零点刷新 -----------------------------------

%%零点在线刷新ps(神秘商店)
daily_clear(0) ->
    spawn(fun() -> daily_clear_help() end);
daily_clear(_Other) ->
    ok.

daily_clear_help() ->
    Now = utime:unixtime(),
    Sql = io_lib:format("update `mystery_shop_role` set hit_num=~p,time=~p ", [0, Now]),
    db:execute(Sql),
    %%修改在线的祝福状态
    OnlineList = ets:tab2list(?ETS_ONLINE),
    [
        lib_player:apply_cast(PlayerId, ?APPLY_CAST_STATUS, ?MODULE, refresh_daily_status, [])
        || #ets_online{id = PlayerId} <- OnlineList
    ].

refresh_daily_status(PS) ->
    #player_status{id = _RoleId, mystery_shop = StatusFunc} = PS,
    Now = utime:unixtime(),
    #status_func{func_list = FuncList} = StatusFunc,
    NFuncList = refresh_func_list(FuncList, Now, []),
    NStatusFunc = StatusFunc#status_func{func_list = NFuncList},
    PS#player_status{mystery_shop = NStatusFunc}.

%% 清除当日累计的刷新次数
refresh_func_list([], _Now, List) -> List;
refresh_func_list([{Type, _, _} | T], Now, List) ->
    refresh_func_list(T, Now, [{Type, 0, Now} | List]).

%% ---------------------------------- 商店零点刷新end -----------------------------------

