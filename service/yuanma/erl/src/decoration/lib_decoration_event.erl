%%%-------------------------------------------------------------------
%%% @author menglu
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 幻饰事件
%%% @end
%%% Created : 2021 10.18
%%%-------------------------------------------------------------------
-module(lib_decoration_event).
-include("decoration.hrl").
-include("common.hrl").
-include("server.hrl").

%% TODO 其他一些事件，用到后记得加到此文件中

-export([
        decoration_level_up/4       % 幻世强化升级事件
    ]).

%% PS: 强化后玩家属性
%% EquipPos: 幻世部位
%% StrenType: 强化类型  1 强化
%% Lv: 强化后等级
decoration_level_up(PS, _EquipPos, _StrenType, Lv) ->
    NewPs = lib_push_gift_api:decoration_level_up(PS, Lv),
    NewPs.