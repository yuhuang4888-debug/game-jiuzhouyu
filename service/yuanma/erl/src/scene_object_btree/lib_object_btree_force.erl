%% ---------------------------------------------------------------------------
%% @doc lib_object_btree_force

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/8/2 0002
%% @deprecated  状态强制事件处理，比如被强制移动中，被嘲讽中# yy25d暂无强制事件的需求
%% ---------------------------------------------------------------------------
-module(lib_object_btree_force).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("scene_object_btree.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("def_fun.hrl").

%% ==========================================
%% 检查是否有强制事件影响行为
%% 1.检查是否强制移动中
%% 2.检查是否被嘲讽中
%% yy25d暂无该需求
common_check(State, BTree, _) -> {State, BTree#behavior_tree{force_status = []}}.

%% ==========================================
%% 执行强制事件  yy25d暂无该需求
do_force_event(State, StateName, BTree, _) ->
    {State, StateName, BTree}.

%% ==========================================
%% yy25d暂无该需求
handle_info(State, StateName, BTree, _Msg) ->
    {State, StateName, BTree}.

