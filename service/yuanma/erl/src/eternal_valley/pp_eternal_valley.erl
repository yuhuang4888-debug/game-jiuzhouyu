%%-----------------------------------------------------------------------------
%% @Module  :       pp_eternal_valley
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-12
%% @Description:    永恒碑谷（契约之书）
%%-----------------------------------------------------------------------------
-module(pp_eternal_valley).

-include("server.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("figure.hrl").

-export([handle/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = lib_module:get_open_lv(?MOD_ETERNAL_VALLEY, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 碑谷列表
do_handle(_Cmd = 42401, Player, _) ->
    #player_status{id = RoldId, eternal_valley = RoleEternalValley} = Player,
    lib_eternal_valley:send_chapter_list(RoldId, RoleEternalValley);

%% 碑谷信息
do_handle(_Cmd = 42402, Player, [Chapter]) ->
    #player_status{id = RoldId, eternal_valley = RoleEternalValley} = Player,
    lib_eternal_valley:send_chapter_info(RoldId, RoleEternalValley, Chapter);

%% 领取阶段奖励
do_handle(_Cmd = 42404, Player, [Chapter, Stage]) ->
%%    ?PRINT("42404 Chapter, Stage ~p   ~p~n",[Chapter, Stage]),
    lib_eternal_valley:receive_stage_reward(Player, Chapter, Stage);

do_handle(_Cmd, _Player, _Data) ->
    {error, "pp_eternal_valley no match~n"}.







