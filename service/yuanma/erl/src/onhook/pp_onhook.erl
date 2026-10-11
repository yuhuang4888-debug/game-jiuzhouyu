%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 11 Sep 2017 by root <root@localhost.localdomain>

-module(pp_onhook).

-export([handle/3]).

-include("common.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("rec_onhook.hrl").
-include("errcode.hrl").

%% 离线挂机规则2 

%% 离线挂机触发[5秒触发一次]
handle(13211, Player, []) ->
    lib_afk:trigger(Player);

%% 离线挂机登录信息
handle(13212, Player, []) ->
    lib_afk:send_login_info(Player);

%% 离线挂机赎回
handle(13213, Player, [Count]) ->
    lib_afk:back(Player, Count);

%% 离线挂机信息
handle(13214, Player, []) ->
    lib_afk:send_info(Player);

%% 升级的经验效率
handle(13215, Player, []) ->
    lib_afk:send_exp_effect_info(Player);

%% 领取挂机奖励
handle(13216, Player, []) ->
    lib_afk:receive_afk_reward(Player);

%% 经验加成信息
handle(13217, Player, []) ->
    lib_afk:send_exp_addition_info(Player);

handle(_Cmd, _Ps, _Data) ->
    ok.
