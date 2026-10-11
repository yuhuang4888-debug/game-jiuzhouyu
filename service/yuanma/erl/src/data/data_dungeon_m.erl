%% ---------------------------------------------------------------------------
%% @doc data_dungeon_m.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-03-13
%% @deprecated 副本手动配置
%% ---------------------------------------------------------------------------
-module(data_dungeon_m).
-export([
        get_config/1
        , get_partner_choice_cd/0
    ]).

-compile(export_all).

-include("dungeon.hrl").

%% 获得配置
get_config(T) ->
    case T of
        % 出生地偏移
        born_offset -> 100;
        % 强制登出时间(副本结束10秒之后退出副本)
        force_quit_time -> 10;
        % 遗忘之境基础加分
        %% oblivion_base_score -> 5;
        % 关卡切换时间
        level_change_time -> 6
    end.

%% 获得伙伴组选择的冷却时间
get_partner_choice_cd() -> 10.

%% 坐标点
get_xy(Pos, X, Y) when Pos == ?DUN_CREATE_PARTNER_POS_1 -> 
    [{X+200, Y+100}, {X-200, Y+100}, {X+100, Y+200}, {X-100, Y-200}];
get_xy(Pos, X, Y) when Pos == ?DUN_CREATE_PARTNER_POS_2 -> 
    [{X+200, Y-100}, {X-200, Y-100}, {X-100, Y+200}, {X+100, Y-200}];
get_xy(_Pos, _X, _Y) ->
    [].
