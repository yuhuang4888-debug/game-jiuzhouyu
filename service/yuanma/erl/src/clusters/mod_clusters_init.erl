%%%------------------------------------
%%% @Module  : mod_clusters_init
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.25
%%% @Description: 集群数据初始化(跨服中心和跨服连接节点(0线)都会执行)
%%%------------------------------------
-module(mod_clusters_init).
-behaviour(gen_server).
-export([
         start_link/0,
         init_mysql/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("clusters.hrl").
-include("scene.hrl").
-include("record.hrl").
-include("team.hrl").
-include("custom_act.hrl").

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
    ok = init_ets(),
    ok = init_mysql(),
    %% ok = db_upgrade:execute(),
    ok = lib_custom_act_dynamic_compile:dynamic_compile_cfg(),
    %% ok = lib_custom_act_util:init_ets_switch(),
    %% ok = lib_custom_act_util:init_ets_cfg(),
    {ok, ?MODULE}.

handle_cast(_R , Status) ->
    {noreply, Status}.

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% ================== 私有函数 =================
%% mysql数据库连接初始化
init_mysql() ->
    [DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns] = config:get_mysql(),
    db:start(DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DBConns),
    ok.

%% 初始ETS表
init_ets() ->
    ets:new(?ETS_NODE, [{keypos, #node.id}, named_table, public, set]),                 %% 节点
    ets:new(?ETS_SCENE, [{keypos, #ets_scene.id}, named_table, public, set]),           %% 用户场景信息
    ets:new(?ETS_SERVER_KV, [{keypos,#server_kv.key}, named_table, public, set]),      %% 服务器key-value信息
    ets:new(?ROUTE, [{keypos, #route.server_id}, named_table, public, set]),
    ets:new(?ETS_TEAM, [{keypos, #ets_team.team_id}, named_table, public, set]),
    ets:new(?ETS_SCENE_LINES, [{keypos, #ets_scene_lines.scene}, named_table, public, duplicate_bag]),
    ets:new(?ETS_CUSTOM_ACT, [{keypos, #act_info.key}, named_table, public, set]),      %% 当前开启的定制活动
    %% 开关
    %% ets:new(?ETS_SWITCH, [named_table, public, set, {keypos, #ets_switch.id}]),
    %% 定制活动直接读配置
    %% ets:new(?ETS_EXTRA_CUSTOM_ACT_CONFIG, [named_table, public, set, {keypos, #ets_extra_custom_act_config.id}]),
    %% 定制活动额外配置的优化
    %% ets:new(?ETS_CUSTOM_ACT_CFG, [named_table, public, set, {keypos, #ets_cfg.id}]),
    %% ets:new(?ETS_CUSTOM_ACT_SUBTYPE_BY_TYPE, [named_table, public, set, {keypos, #ets_cfg.id}]),
    %% ets:new(?ETS_CUSTOM_ACT_REWARD_CFG, [named_table, public, set, {keypos, #ets_cfg.id}]),
    %% ets:new(?ETS_CUSTOM_ACT_REWARD_IDS, [named_table, public, set, {keypos, #ets_cfg.id}]),
    %% ets:new(?ETS_CFG_KEYS, [named_table, public, set, {keypos, #ets_cfg.id}]),
    ok.
