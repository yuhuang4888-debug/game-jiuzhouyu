%%-----------------------------------------------------------------------------
%% @Module  :       pp_achievement
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-23
%% @Description:    成就
%%-----------------------------------------------------------------------------
-module(pp_achievement).

-include("server.hrl").
-include("def_module.hrl").
-include("figure.hrl").

-export([handle/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = lib_module:get_open_lv(?MOD_ACHIEVEMENT, 1),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 未领取奖励成就标签
do_handle(40900, PlayerStatus, _) ->
    #player_status{id = RoleId} = PlayerStatus,
    lib_achievement:send_tips_info(RoleId);

%% 成就总览
do_handle(40901, PlayerStatus, _) ->
    % #player_status{id = RoleId} = PlayerStatus,
    lib_achievement:send_achievement_summary(PlayerStatus);

%% 领取成就总览奖励
do_handle(40902, PlayerStatus, [Stage]) ->
    lib_achievement:receive_star_reward(PlayerStatus, Stage);

%% 获取成就列表
do_handle(40903, PlayerStatus, []) ->
    #player_status{id = RoleId} = PlayerStatus,
    lib_achievement:send_achievement_list(RoleId);

%% 领取成就奖励
do_handle(40905, PlayerStatus, [Id]) ->
    lib_achievement:receive_reward(PlayerStatus, Id);

%% 成就总成就点
do_handle(40906, PlayerStatus, []) ->
    lib_achievement:send_current_star(PlayerStatus);

%% 成就总览奖励更新
do_handle(40908, PlayerStatus, []) ->
    lib_achievement:send_achievement_type_state(PlayerStatus);

%% 成就分类总览
do_handle(40909, PlayerStatus, [Category]) ->
    #player_status{id = RoleId} = PlayerStatus,
    lib_achievement:send_achievement_all(RoleId, Category);

do_handle(_Cmd, _Player, _Data) ->
    {error, "pp_achievement no match~n"}.