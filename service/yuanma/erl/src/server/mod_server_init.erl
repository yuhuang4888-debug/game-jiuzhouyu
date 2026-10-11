%%%------------------------------------
%%% @Module  : mod_server_init
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.14
%%% @Description: 数据初始化
%%%------------------------------------
-module(mod_server_init).
-behaviour(gen_server).
-export([
         start_link/0,
         init_mysql/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("record.hrl").
-include("server.hrl").
-include("buff.hrl").
-include("race_act.hrl").
-include("scene.hrl").
-include("team.hrl").
-include("relationship.hrl").
-include("rec_offline.hrl").
-include("role.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("rec_mirror.hrl").
-include("fashion.hrl").
-include("chat.hrl").
-include("attr.hrl").
-include("custom_act.hrl").
-include("career.hrl").
-include("vip.hrl").

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) ->
    ok = check_config(),
    ok = init_ets(),
    ok = init_mysql(),
    ok = init_server_kv(),
    ok = lib_custom_act_dynamic_compile:dynamic_compile_cfg(),
    ok = lib_dynamic_compile_api:compile_all_cfg(),
    ok = mod_recharge_limit:init(), % 充值活动限制
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

%%初始ETS表
init_ets() ->
    ets:new(?ETS_NODE,             [{keypos, #node.id}, named_table, public, set]),            %% 节点
    ets:new(?ETS_SERVER_KV,        [{keypos, #server_kv.key}, named_table, public, set]),      %% 服务器键值kv
    ets:new(?ETS_SYS_NOTICE,       [named_table, public, set]),                                %% 系统公告
    ets:new(?ETS_CAREER_COUNT,     [named_table, public, set]),                                %% 职业选择
    ets:new(?ETS_ONLINE,           [{keypos, #ets_online.id}, named_table, public, set]),      %% 玩家在线数据
    ets:new(?ETS_SCENE_LINES,      [{keypos, #ets_scene_lines.scene}, named_table, public, duplicate_bag]), %% 场景线路
    ets:new(?ETS_BUFF,             [{keypos, #ets_buff.id}, named_table, public, set]),        %% 玩家buff
    ets:new(?ETS_TEAM,             [{keypos, #ets_team.team_id}, named_table, public, set]),   %% 队伍
    ets:new(?ETS_OFFLINE_ACCESS,   [{keypos, #ets_offline.id}, named_table, public, set]),     %% 离线玩家
    ets:new(?ETS_OFFLINE_PLAYER,   [{keypos, #player_status.id}, named_table, public, set]),   %% 离线访问
    ets:new(?ETS_ROLE_SHOW,        [{keypos, #ets_role_show.id}, named_table, public, set]),
    ets:new(?ETS_ROLE_FUNC_CHECK,  [{keypos, #ets_role_func_check.key_id}, named_table, public, set]), %% 功能定时检查
    ets:new(?ETS_CUSTOM_ACT,       [{keypos, #act_info.key}, named_table, public, set]),          %% 当前开启的定制活动
    ets:new(?ETS_VIP_CARD,         [{keypos, #ets_vip_card.key}, named_table, public, set]),      %% vip
    ets:new(?ETS_RACE_ACT,         [{keypos, #ets_race_act.type}, named_table, public, set]),     %%竞榜活动
    ets:new(?ETS_FUNC_GM_CLOSE,    [{keypos, #ets_func_gm_close.key}, named_table, public, set]), %%gm关闭活动
    ok.

%% 服务器常用键值
init_server_kv() ->
    lib_server_kv:load(),
    ok.

check_config() ->
    SerId = config:get_server_id(),
    MergeSerIds = config:get_merge_server_ids(),
    if
        is_integer(SerId) == false orelse SerId == 0 -> exit({server_id_err, SerId});
        is_list(MergeSerIds) == false -> exit({merge_server_ids_err, MergeSerIds});
        true -> skip
    end,
    case lists:member(SerId, MergeSerIds) of
        true  -> ok;
        false -> exit({server_id_not_in_merge, SerId, MergeSerIds})
    end.
