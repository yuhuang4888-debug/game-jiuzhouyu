%% ---------------------------------------------------------------------------
%% @doc pp_sanctuary_cluster

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/9/3 0003
%% @desc  
%% ---------------------------------------------------------------------------
-module(pp_sanctuary_cluster).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").

-export([
    handle/3
]).

handle(Cmd, Player, Args) ->
    #player_status{id = _RoleId, figure = #figure{lv = Lv}} = Player,
    LimitLv = data_cluster_sanctuary_m:get_san_value(open_lv),
    OpenDay = util:get_open_day(),
    if
        OpenDay =< 1 -> skip;
        Lv >= LimitLv -> do_handle(Cmd, Player, Args);
        true ->
            skip
            %% lib_sanctuary_cluster_util:send_error(RoleId, ?ERRCODE(lv_limit))
    end.

%% 界面数据
do_handle(28400, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:send_normal_info(RoleId);

%% 建筑信息
do_handle(28401, Player, [SceneId]) when SceneId =/= 0 ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:send_building_info(RoleId, SceneId);

%% BOSS伤害排名信息
%% 怪物死了玩家到了怪物附近，客户端会请求一次，实时的伤害排名客户端根据场景那边协议获取
do_handle(28403, Player, [SceneId, MonId]) ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:send_boss_hurt_rank(RoleId, SceneId, MonId);

%% 进入
do_handle(28404, Player, [SceneId]) when SceneId =/= 0 ->
    lib_sanctuary_cluster:enter(Player, SceneId);

%% 获取个人积分
do_handle(28405, Player, []) ->
    lib_sanctuary_cluster:send_role_score_info(Player);

%% 解锁奖励
do_handle(28406, Player, []) ->
    lib_sanctuary_cluster:unlock_score_reward(Player);

%% 退出
do_handle(28407, Player, []) ->
    lib_sanctuary_cluster:quit(Player);

%% 领取归属奖励
do_handle(28408, Player, [SceneId]) ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:get_bl_reward(RoleId, SceneId);

%% 领取个人积分奖励
do_handle(28409, Player, [Score]) ->
    lib_sanctuary_cluster:get_score_reward(Player, Score);

% 获取活动时间
do_handle(28410, Player, []) ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:send_act_time(RoleId);

% 获取击杀记录
do_handle(28412, Player, [SceneId, MonId]) ->
    #player_status{id = RoleId} = Player,
    mod_sanctuary_cluster_local:send_kill_log(RoleId, SceneId, MonId);

do_handle(28415, Player, []) ->
    lib_sanctuary_cluster:get_die_tired(Player);

do_handle(28420, _Player, _) ->
    skip;

do_handle(28422, Player, [SceneId]) when SceneId =/= 0  ->
    lib_sanctuary_cluster:get_role_sanctuary_rank_info(Player, SceneId);

do_handle(Cmd, _Player, Data) ->
    ?PRINT("===ERR ROUTE CMD ~p, Data ~p ~n", [Cmd, Data]).
