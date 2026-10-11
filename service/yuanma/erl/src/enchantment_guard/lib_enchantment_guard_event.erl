%%%-----------------------------------
%%% @Module      : lib_enchantment_guard_event
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 09. 六月 2020 9:41
%%% @Description : 主线副本（结界守护） 事件
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_enchantment_guard_event).
-include("server.hrl").
-author("carlos").

%% API
-export([]).


%% -----------------------------------------------------------------
%% @desc     功能描述    玩家通关主线副本后事件处理
%% @param    参数        OldGate:旧通关关卡  NewGate:通关后关卡
%% @return   返回值     #player_status{}
%% @history  修改历史
%% -----------------------------------------------------------------
player_gate_change(PS, _OldGate, _NewGate) ->
	PS.