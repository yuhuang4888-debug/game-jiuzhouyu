%%%-----------------------------------
%%% @Module      : mod_c_sanctuary 跨服圣域
%%% @Author      : xlh
%%% @Email       : 1593315047@qq.com
%%% @Created     : 2018
%%% @Description : 跨服圣域管理进程
%%%-----------------------------------

-module(mod_c_sanctuary).

-behaviour(gen_server).

-include("cluster_sanctuary.hrl").
-include("common.hrl").
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

%% 本地调用跨服中心
-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

%% 进程功能接口
-export([
        midnight_update/2           %% 凌晨数据处理/更新
        ,mon_hurt/9                 %% 攻击boss拍卖产出处理
        ,mon_be_killed/9            %% 怪物被击杀数据处理
        ,init_after/4               %% 初始化
        ,update_add_zone/2          %% 服务器分区改变时数据处理（弃用）
        ,server_info_chage/2        %% 改变服务器开服天数/世界等级时重启活动
        ,zone_change/3              %% 服务器分区改变时数据处理
        ,center_connected/6         %% 本地连接跨服中心调用/合服后调用，更新本地数据更改内存服务器相关数据
        ,kill_player/7              %% 跨服圣域击杀敌方阵营玩家更新贡献值
        ,local_init/1               %% 本地管理进程数据初始化
        ,clear_user_mon_create/3    %% 生成怪物清理玩家
    ]).

%% 协议相关接口
-export([
        get_construction_info/4    %% 获取建筑信息（弃用，转移到本地进程处理） 
        ,get_rank_info/5            %% 获取boss伤害排名（弃用，转移到本地进程处理）
        ,get_info/3                 %% 客户端获取跨服圣域怪物数据（弃用，转移到本地进程处理）
        ,enter/5                    %% 进入场景
        ,reconect/4                 %% 重连
        ,exit/3                     %% 退出
        ,recieve_bl_reward/4        %% 领取建筑归属奖励
        ,get_mon_pk_log/5           %% 获取怪物击杀记录（弃用，转移到本地进程处理）
        ,get_act_opentime/2         %% 获取活动时间（弃用，转移到本地进程处理）
    ]).

%% 相关秘籍
-export([
        gm_start_act/0              %% 秘籍重启活动正常开启活动
        ,gm_start_ref/0             %% 秘籍开启活动，生成怪物
        ,gm_start_anger_ref/0       %% 所有玩家怒气清理
        ,gm_set_calc_battle_time/0  %% 重新分配对战服务器列表，重启活动
        ,gm_refresh_data/0          %% 更新所有服本地数据
        ,gm_refresh_data/1          %% 更新某个分区所有服本地数据
        ,gm_refresh_data/2          %% 更新某个分区所有服本地数据
        ,gm_add_point/3             %% 增加玩家贡献值（拍卖分红）
        ,clear_camp_record/0        %% 清除服务器阵营记录（服务器进入阵营模式后不清理记录无论开服几天都是阵营模式）
        ,calc_battle_info/0         %% 分配对战服务器列表
        ,act_start/0                %% 活动开始
        ,mon_create/0
        ,gm_clear_user/1            %% 手动设置活动状态
    ]).

%%=========================================================================
%% 接口函数
%%=========================================================================
calc_battle_info() ->
    cast_center([{'calc_battle_info'}]).

act_start() ->
    cast_center([{'act_start'}]).

gm_start_act() ->
    cast_center([{'gm_start_act'}]).

gm_set_calc_battle_time() ->
    cast_center([{'gm_set_calc_battle_time'}]).

gm_refresh_data() ->
    cast_center([{'gm_refresh_data'}]).

gm_refresh_data(ZoneId) ->
    cast_center([{'gm_refresh_data', ZoneId}]).

gm_refresh_data(ZoneId, ServerId) ->
    cast_center([{'gm_refresh_data', ZoneId, ServerId}]).

gm_add_point(ServerId, Scene, Point) ->
    cast_center([{'gm_add_point', ServerId, Scene, Point}]).

clear_camp_record() ->
    cast_center([{'clear_camp_record'}]).

get_act_opentime(RoleId, Node) ->
    cast_center([{'get_act_opentime', Node, RoleId}]).

get_mon_pk_log(ServerId, Node, RoleId, Scene, MonId) ->
    cast_center([{'get_mon_pk_log', ServerId, Node, RoleId, Scene, MonId}]).

get_info(ServerId, Node, RoleId) ->
    cast_center([{'get_info', ServerId, Node, RoleId}]).

get_construction_info(ServerId, Node, RoleId, Scene) ->
    cast_center([{'get_construction_info', ServerId, Node, RoleId, Scene}]).

get_rank_info(ServerId, Node, RoleId, Scene, MonId) ->
    cast_center([{'get_rank_info', ServerId, Node, RoleId, Scene, MonId}]).

recieve_bl_reward(RoleId, Node, ServerId, Scene) ->
    cast_center([{'recieve_bl_reward', RoleId, ServerId, Node, Scene}]).

enter(ServerId, Node, RoleId, Scene, NeedOut) ->
    cast_center([{'enter', ServerId, Node, RoleId, Scene, NeedOut}]).

reconect(ServerId, RoleId, Scene, Args) ->
    cast_center([{'reconect', ServerId, RoleId, Scene, Args}]).

exit(ServerId, RoleId, Scene) ->
    cast_center([{'exit', ServerId, RoleId, Scene}]).

mon_be_killed(BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName) ->
    cast_center([{'mon_be_killed', BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName}]).

local_init(ServerId) ->
    cast_center([{'local_init', ServerId}]).

kill_player(SceneId, CopyId, AttrServerId, AttrServerNum, AttrRoleId, AttrName, HitIdList) ->
    cast_center([{'kill_player', SceneId, CopyId, AttrServerId, AttrServerNum, AttrRoleId, AttrName, HitIdList}]).

gm_clear_user(ServerId) ->
    cast_center([{'gm_clear_user', ServerId}]).

mon_create() ->
    cast_center([{'mon_create'}]).

%%=========================================================================
%% 接口函数
%%=========================================================================

%%本地->跨服中心 
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

%% 跨服中心调用
midnight_update(ServersInfo, Z2SMap) ->
    gen_server:cast(?MODULE, {'midnight_update', ServersInfo, Z2SMap}).

server_info_chage(ServerId, Args) ->
    gen_server:cast(?MODULE, {'server_info_chage', ServerId, Args}).

zone_change(ServerId, OldZone, NewZone) ->
    if
        OldZone =/= NewZone ->
            gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone});
        true ->
            skip
    end.
    
center_connected(ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds) ->
    OpenDay = lib_c_sanctuary_mod:get_open_day(OpTime),
    if
        OpenDay =< 1 ->
            skip;
        true ->
            gen_server:cast(?MODULE, {'center_connected', ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds})
    end.

update_add_zone(ServersInfo, Z2SMap) ->
    gen_server:cast(?MODULE, {'update_add_zone', ServersInfo, Z2SMap}).

gm_start_ref() ->
    gen_server:cast(?MODULE, gm_start_ref).

gm_start_anger_ref() ->
    gen_server:cast(?MODULE, gm_start_anger_ref).

clear_user_mon_create(ServerUserList, Scene, Type) ->
    gen_server:cast(?MODULE, {'clear_user_mon_create', ServerUserList, Scene, Type}).

mon_hurt(Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt) ->
    gen_server:cast(?MODULE, {'mon_hurt', Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt}).

init_after(ServersInfo, Z2SMap, ServerPowerL, init) ->
    gen_server:cast(?MODULE, {'init_after', ServersInfo, Z2SMap, ServerPowerL, init}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	State = lib_c_sanctuary_mod:init(),
	{ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("mod_c_sanctuary Msg Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_c_sanctuary Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("mod_c_sanctuary Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_cast({'mon_create'}, State) ->
    erlang:send_after(1000, self(), {'mon_create', timer}),
    {noreply, State};

do_handle_cast({'server_info_chage', ServerId, Args}, State) ->
    NewState = lib_c_sanctuary_mod:server_info_chage(State, ServerId, Args),
    {noreply, NewState};

do_handle_cast({'get_act_opentime', Node, RoleId}, State) ->
    NewState = lib_c_sanctuary_mod:get_act_opentime(State, Node, RoleId),
    {noreply, NewState};

do_handle_cast({'get_info', ServerId, Node, RoleId}, State) ->
    NewState = lib_c_sanctuary_mod:get_info(State, ServerId, Node, RoleId),
    {noreply, NewState};

do_handle_cast({'enter', ServerId, Node, RoleId, Scene, NeedOut}, State) ->
    NewState = lib_c_sanctuary_mod:enter(State, ServerId, Node, RoleId, Scene, NeedOut),
    {noreply, NewState};

do_handle_cast({'get_construction_info', ServerId, Node, RoleId, Scene}, State) ->
    NewState = lib_c_sanctuary_mod:get_construction_info(State, ServerId, Node, RoleId, Scene),
    {noreply, NewState};

do_handle_cast({'get_rank_info', ServerId, Node, RoleId, Scene, MonId}, State) ->
    NewState = lib_c_sanctuary_mod:get_rank_info(State, ServerId, Node, RoleId, Scene, MonId),
    {noreply, NewState};

do_handle_cast({'midnight_update', ServersInfo, Z2SMap}, State) ->
	NewState = lib_c_sanctuary_mod:midnight_update(State, ServersInfo, Z2SMap),
	{noreply, NewState};

do_handle_cast({'init_after', ServersInfo, Z2SMap, ServerPowerL, init}, State) ->
    NewState = lib_c_sanctuary_mod:init_after(State, ServersInfo, Z2SMap, ServerPowerL, init),
    {noreply, NewState};

do_handle_cast({'update_add_zone', ServersInfo, Z2SMap}, State) ->
    NewState = lib_c_sanctuary_mod:update_add_zone(State, ServersInfo, Z2SMap),
    {noreply, NewState};

do_handle_cast({'recieve_bl_reward', RoleId, ServerId, Node, Scene}, State) ->
    NewState = lib_c_sanctuary_mod:recieve_bl_reward(State, RoleId, ServerId, Node, Scene),
    {noreply, NewState};

do_handle_cast({'mon_hurt', Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt}, State) ->
    NewState = lib_c_sanctuary_mod:mon_hurt(State, Scene, PoolId, CopyId, ServerId, ServerNum, Monid, RoleId, Name, Hurt),
    {noreply, NewState};

do_handle_cast({'exit', ServerId, RoleId, Scene}, State) ->
    NewState = lib_c_sanctuary_mod:exit(State, ServerId, RoleId, Scene),
    {noreply, NewState};

do_handle_cast({'reconect', ServerId, RoleId, Scene, Args}, State) ->
    NewState = lib_c_sanctuary_mod:reconect(State, ServerId, RoleId, Scene, Args),
    {noreply, NewState};

do_handle_cast({'get_mon_pk_log', ServerId, Node, RoleId, Scene, MonId}, State) ->
    NewState = lib_c_sanctuary_mod:get_mon_pk_log(State, ServerId, Node, RoleId, Scene, MonId),
    {noreply, NewState};

do_handle_cast({'mon_be_killed', BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName}, State) ->
    NewState =lib_c_sanctuary_mod:mon_be_killed(State, BLWhos, Klist, SceneId, ScenePoolId, CopyId, ServerId, Mid, AtterId, AtterName),
    {noreply, NewState};

do_handle_cast({'gm_start_act'}, State) ->
    NewState = lib_c_sanctuary_mod:gm_start_act(State),
    {noreply, NewState};

do_handle_cast({'gm_refresh_data'}, State) ->
    NewState = lib_c_sanctuary_mod:gm_refresh_data(State),
    {noreply, NewState};

do_handle_cast({'gm_refresh_data', ZoneId}, State) ->
    NewState = lib_c_sanctuary_mod:gm_refresh_data(ZoneId, State),
    {noreply, NewState};

do_handle_cast({'gm_refresh_data', ZoneId, ServerId}, State) ->
    NewState = lib_c_sanctuary_mod:gm_refresh_data(ZoneId, ServerId, State),
    {noreply, NewState};

do_handle_cast({'gm_set_calc_battle_time'}, State) ->
    NewState = lib_c_sanctuary_mod:gm_set_calc_battle_time(State),
    {noreply, NewState};

do_handle_cast(gm_start_ref, State) ->
    NewState = lib_c_sanctuary_mod:gm_start_ref(State),
    {noreply, NewState};

do_handle_cast(gm_start_anger_ref, State) ->
    NewState = lib_c_sanctuary_mod:gm_start_anger_ref(State),
    {noreply, NewState};

do_handle_cast({'local_init', ServerId}, State) ->
    %?MYLOG("xlh","local_init ============= ~n",[]),
    NewState = lib_c_sanctuary_mod:local_init(State, ServerId),
    {noreply, NewState};

do_handle_cast({'clear_user_mon_create', ServerUserList, Scene, Type}, State) ->
    NewState = lib_c_sanctuary_mod:clear_user_mon_create(State, ServerUserList, Scene, Type),
    {noreply, NewState};

do_handle_cast({'zone_change', ServerId, OldZone, NewZone}, State) ->
    NewState = lib_c_sanctuary_mod:zone_change(State, ServerId, OldZone, NewZone),
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds}, State) ->
    NewState = lib_c_sanctuary_mod:center_connected(State, ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds),
    {noreply, NewState};

do_handle_cast({'kill_player', SceneId, CopyId, AttrServerId, AttrServerNum, AttrRoleId, AttrName, HitIdList}, State) ->
    NewState = lib_c_sanctuary_mod:kill_player(State, SceneId, CopyId, AttrServerId, AttrServerNum, AttrRoleId, AttrName, HitIdList),
    {noreply, NewState};

do_handle_cast({'gm_add_point', ServerId, Scene, Point}, State) ->
    NewState = lib_c_sanctuary_mod:gm_add_point(State, ServerId, Scene, Point),
    {noreply, NewState};

do_handle_cast({'clear_camp_record'}, State) ->
    NewState = lib_c_sanctuary_mod:clear_camp_record(State),
    {noreply, NewState};

do_handle_cast({'calc_battle_info'}, State) ->
    NewState = lib_c_sanctuary_mod:calc_battle_info(State),
    {noreply, NewState};

do_handle_cast({'act_start'}, State) ->
    NewState = lib_c_sanctuary_mod:act_start(State),
    {noreply, NewState};

do_handle_cast({'gm_clear_user', ServerId}, State) ->
    NewState = lib_c_sanctuary_mod:gm_clear_user(State, ServerId),
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    ?MYLOG("xlh_mod","do_handle_info, _Msg:~p~n", [_Msg]),
	{noreply, State}.

do_handle_call(_, State) ->
	{reply, ok, State}.

do_handle_info('calc_battle_info', State) ->
	NewState = lib_c_sanctuary_mod:calc_battle_info(State),
	{noreply, NewState};

do_handle_info('role_anger_clear', State) ->
    NewState = lib_c_sanctuary_mod:role_anger_clear(State),
    {noreply, NewState};

do_handle_info({'send_rank', Scene, PoolId, CopyId, RealSendL, Monid}, State) ->
    NewState = lib_c_sanctuary_mod:send_rank(Scene, PoolId, CopyId, RealSendL, Monid, State),
    {noreply, NewState};

do_handle_info(act_start, State) ->
    NewState = lib_c_sanctuary_mod:act_start(State),
    {noreply, NewState};

do_handle_info(act_end, State) ->
    NewState = lib_c_sanctuary_mod:act_end(State),
    {noreply, NewState};

do_handle_info({'mon_create', CreateType}, State) ->
    NewState = lib_c_sanctuary_mod:mon_create(State, CreateType),
    {noreply, NewState};

do_handle_info({'mon_create_peace', MonId, SceneId, CopyId}, State) ->
    NewState = lib_c_sanctuary_mod:mon_create_peace(State,  MonId, SceneId, CopyId),
    {noreply, NewState};

do_handle_info({'clear_scene_role', ZoneId, ServerId, Scene}, State) ->
    NewState = lib_c_sanctuary_mod:clear_scene_role(State, ZoneId, ServerId, Scene),
    {noreply, NewState};

do_handle_info({'tipes_act_end', CValue}, State) ->
    NewState = lib_c_sanctuary_mod:tipes_act_end(State, CValue),
    {noreply, NewState};

do_handle_info(_Msg, State) ->
    ?MYLOG("xlh_mod","do_handle_info, _Msg:~p~n", [_Msg]),
	{noreply, State}.
