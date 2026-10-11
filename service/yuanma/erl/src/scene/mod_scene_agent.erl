%%%------------------------------------
%%% @Module  : mod_scene_agent
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.15
%%% @Description: 场景管理
%%%------------------------------------
-module(mod_scene_agent).
-behaviour(gen_server).
-export([
         start_scene/2,
         get_scene_pid/1,
         get_scene_pid/2,
         send_to_scene/4,
         send_to_scene/3,
         send_to_area_scene/6,
         send_to_role_area_scene/7,
         send_to_scene_group/5,
         join/1,
         leave/1,
         vaild_leave/1,
         revive/1,
         revive_to_target/1,
         player_die/3,
         move/8,
         update/2,
         update/4,
         get_scene_num/2,
         get_scene_area_all/5,
         get_player_skill/3,
         get_player_attr/3,
         send_scene_info_to_uid/6,
         dispatch_dungeon_event/4,
         send_number_info/4,
         send_user_info/4,
         add_mon_create_delay/5,
         send_dynamic_eff/5,
         send_object_buff_list/5,
         send_role_assist_info/5,
         update_skill_passive_share/6,
         close_scene/2,
         clear_scene/2,
         clear_scene/3,
         apply_call/5,
         apply_call_with_state/5,
         apply_cast/5,
         apply_cast_with_state/5,
         load_scene/1,
         handle_event/2,
         call_to_scene/3,
         cast_to_scene/3,
         sync_scene_user_num/4,
         get_outside_online_user/5,
         get_boss_hp_show/4
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("server.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("title.hrl").
-include("designation.hrl").
-include("mount.hrl").
-include("skill.hrl").
-include("pet.hrl").
-include("wing.hrl").
-include("talisman.hrl").
-include("eudemons.hrl").
-include("eudemons_land.hrl").
-include("marriage.hrl").
-include("husong.hrl").
-include("holy_ghost.hrl").
-include("kf_guild_war.hrl").
-include("battle.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("rec_onhook.hrl").
-include("attr.hrl").

%% 通过场景调用函数 - call -> false|Res
apply_call(Sid, PoolId, Module, Method, Args) ->
    call_to_scene(Sid, PoolId, {'apply_call', Module, Method, Args}).
apply_call_with_state(Sid, PoolId, Module, Method, Args) ->
    call_to_scene(Sid, PoolId, {'apply_call_with_state', Module, Method, Args}).

%% 通过场景调用函数 - cast
apply_cast(Sid, PoolId, Module, Method, Args) ->
    cast_to_scene(Sid, PoolId, {'apply_cast', Module, Method, Args}).

%% 通过场景调用函数 - cast
%% 调用Method时，最后会带有state参数
apply_cast_with_state(Sid, PoolId, Module, Method, Args) ->
    cast_to_scene(Sid, PoolId, {'apply_cast_with_state', Module, Method, Args}).

%% 给场景所有玩家发送信息
send_to_scene(Sid, PoolId, CopyId, Bin) ->
    cast_to_scene(Sid, PoolId, {'send_to_scene', CopyId, Bin}).

%% 给场景所有玩家发送信息
send_to_scene(Sid, PoolId, Bin) ->
    cast_to_scene(Sid, PoolId, {'send_to_scene', Bin}).

%% 给场景九宫格玩家发送信息
send_to_area_scene(Sid, PoolId, CopyId, X, Y, Bin) ->
    cast_to_scene(Sid, PoolId, {'send_to_area_scene', CopyId, X, Y, Bin}).

%% 给场景九宫格玩家发送信息[尽量以玩家为中心]
send_to_role_area_scene(RoleId, Sid, PoolId, CopyId, X, Y, Bin) ->
    cast_to_scene(Sid, PoolId, {'send_to_role_area_scene', RoleId, CopyId, X, Y, Bin}).

%% 给同阵营的人发消息
send_to_scene_group(Sid, PoolId, CopyId, Group, Bin) ->
    cast_to_scene(Sid, PoolId, {'send_to_scene_group', CopyId, Group, Bin}).

%% 玩家加入场景
trans_join_data(PS) when is_record(PS, player_status)->
    Node = case data_scene:get(PS#player_status.scene) of
        [] -> none;
        #ets_scene{cls_type=?SCENE_CLS_TYPE_CENTER} -> mod_disperse:get_clusters_node();
        _ -> none
    end,
    CampId = case lib_seacraft_daily:is_scene(PS#player_status.scene) of
        true -> lib_seacraft_extra_api:get_camp_id(PS);
        _ -> PS#player_status.camp_id
    end,
    #status_skill{skill_list = SkillList} = PS#player_status.skill,
    %% 测试debug输出
    PsServerId = if
        PS#player_status.server_id == 0 ->
            ?ERR("debug_server_id:~p~n", [[PS#player_status.id, 0, PS#player_status.server_name]]),
            config:get_server_id();
        true ->
            PS#player_status.server_id
    end,
    %% ?PRINT("*******PS#player_status.figure:~p~n",[PS#player_status.figure#figure.mount_figure]),
    % ?PRINT("lib_boss_api:make_boss_tired_map(PS):~p ~n", [lib_boss_api:make_boss_tired_map(PS)]),
    #battle_attr{sec_attr = SecAttr} = BA = PS#player_status.battle_attr,
    #ets_scene_user{
        id = PS#player_status.id,
        platform = PS#player_status.platform,
        server_num = PS#player_status.server_num,
        server_name = PS#player_status.server_name,
        node = Node,
        server_id = PsServerId,
        figure = PS#player_status.figure,
        battle_attr = BA#battle_attr{total_sec_attr = SecAttr},
        pid = PS#player_status.pid,
        sid = PS#player_status.sid,
        team = PS#player_status.team,
        scene = PS#player_status.scene,
        scene_pool_id = PS#player_status.scene_pool_id,
        copy_id = PS#player_status.copy_id,
        x = PS#player_status.x,
        y = PS#player_status.y,
        skill_list = SkillList,
        skill_passive = lib_skill:get_skill_passive(PS),
        onhook_sxy = PS#player_status.onhook#status_onhook.onhook_sxy,
        follow_target_xy = PS#player_status.follow_target_xy,
        online = PS#player_status.online,
        pet_passive_skill = PS#player_status.status_pet#status_pet.passive_skills,
        pet_battle_attr = PS#player_status.status_pet#status_pet.battle_attr,
        quickbar = lib_skill:make_scene_quickbar(PS),
        boss_tired = PS#player_status.boss_tired,
        temple_boss_tired = PS#player_status.temple_boss_tired,
        phantom_tired = PS#player_status.phantom_tired,
        marriage_type = PS#player_status.marriage#marriage_status.type,             %% 婚姻状态：0单身 1恋爱 2已婚
        lover_role_id = PS#player_status.marriage#marriage_status.lover_role_id,    %% 伴侣玩家id
        eudemons_boss_tired = PS#player_status.phantom_tired,
        eudemons_cl_info = PS#player_status.eudemons_boss#eudemons_boss.cl_boss_info,
        treasure_chest = PS#player_status.treasure_chest,
        baby_battle_attr = PS#player_status.baby#baby_status.battle_attr,
        talisman_battle_attr = PS#player_status.status_talisman#status_talisman.battle_attr,
        holyghost_battle_attr = PS#player_status.holy_ghost#status_holy_ghost.battle_attr,
        mate_role_id = PS#player_status.mate_role_id,
        hide_type = PS#player_status.scene_hide_type,
        bl_who = PS#player_status.bl_who,
        in_sea = PS#player_status.status_kf_guild_war#status_kf_guild_war.in_sea,
        ship_id = PS#player_status.status_kf_guild_war#status_kf_guild_war.ship_id,
        fairyland_tired = lib_boss_api:get_fairyboss_tired(PS#player_status.id),
        train_object = PS#player_status.train_object,
        dun_type = PS#player_status.dungeon#status_dungeon.dun_type,
        boss_tired_map = lib_boss_api:make_boss_tired_map(PS),
        world_lv = util:get_world_lv(),
        mod_level = lib_scene:get_mod_level(PS),
        camp_id = CampId,
        assist_id = lib_guild_assist:get_assist_id(PS),
        del_hp_each_time = PS#player_status.del_hp_each_time,
        halo_privilege = lib_hero_halo:get_scene_privilege_state(PS)
    }.

join(PS) ->
    EtsSceneUser = trans_join_data(PS),
    cast_to_scene(EtsSceneUser#ets_scene_user.scene, EtsSceneUser#ets_scene_user.scene_pool_id, {'join', EtsSceneUser}).

%% 12002加载场景
load_scene(PS) ->
    EtsSceneUser = trans_join_data(PS),
    cast_to_scene(EtsSceneUser#ets_scene_user.scene, EtsSceneUser#ets_scene_user.scene_pool_id, {'load_scene', EtsSceneUser}).

%% 玩家离开场景
leave(PS) ->
    cast_to_scene(PS#player_status.scene, PS#player_status.scene_pool_id, {'leave', PS#player_status.copy_id, PS#player_status.id}).

%% 玩家校验离开场景
vaild_leave(PS) ->
    cast_to_scene(PS#player_status.scene, PS#player_status.scene_pool_id, {'vaild_leave',
        PS#player_status.copy_id, PS#player_status.x, PS#player_status.y, PS#player_status.id}).

%% 玩家原地复活
revive(PS)->
    cast_to_scene(PS#player_status.scene, PS#player_status.scene_pool_id, {'revive', PS#player_status.copy_id, PS#player_status.id}).

%% 非原地复活
revive_to_target(PS) ->
    cast_to_scene(PS#player_status.scene, PS#player_status.scene_pool_id, {'revive_to_target', PS#player_status.copy_id, PS#player_status.id}).

%% 玩家被击杀
player_die(PS, AtterSign, AtterId) ->
    cast_to_scene(PS#player_status.scene, PS#player_status.scene_pool_id, {'player_die', PS#player_status.copy_id, PS#player_status.id, AtterSign, AtterId}).

%%移动
move(X, Y, BX, BY, F, FX, FY, PS) ->
    #player_status{id=Id, scene=SceneId, scene_pool_id=PoolId, copy_id=CopyId, x=OX, y=OY}=PS,
    cast_to_scene(SceneId, PoolId, {'move', [CopyId, X, Y, F, OX, OY, BX, BY, FX, FY, Id]}).

%%获取指定场景人数
get_scene_num(Sid, PoolId) ->
    call_to_scene(Sid, PoolId, {'scene_num'}).

%% 获取当前九宫格的玩家与怪物（技能秘籍使用）
get_scene_area_all(Sid, PoolId, X, Y, CopyId) ->
    call_to_scene(Sid, PoolId, {'scene_area_all', X, Y, CopyId}).

get_player_skill(Sid, PoolId, RoleId) ->
    call_to_scene(Sid, PoolId, {'get_player_skill', RoleId}).

get_player_attr(Sid, PoolId, RoleId) ->
    call_to_scene(Sid, PoolId, {'get_player_attr', RoleId}).

%%给指定用户发送场景信息
send_scene_info_to_uid(Key, Sid, PoolId, CopyId, X, Y) ->
    cast_to_scene(Sid, PoolId, {'send_scene_info_to_uid', Key, CopyId, X, Y}).

%% 派发副本事件
dispatch_dungeon_event(Sid, PoolId, RoleId, EventTypeId) ->
    cast_to_scene(Sid, PoolId, {'dispatch_dungeon_event', RoleId, EventTypeId}).

%% 发送场景人数
send_number_info(SceneId, ScenePoolId, CopyId, Sid) ->
    cast_to_scene(SceneId, ScenePoolId, {'send_number_info', CopyId, Sid}).

%% 发送场景人物简要信息
send_user_info(SceneId, ScenePoolId, CopyId, Sid) ->
    cast_to_scene(SceneId, ScenePoolId, {'send_user_info', CopyId, Sid}).

%% 延迟创建怪物
add_mon_create_delay(SceneId, ScenePoolId, CopyId, Time, MFA) ->
    cast_to_scene(SceneId, ScenePoolId, {'add_mon_create_delay', CopyId, Time, MFA}).

%% 发送场景特效改变
send_dynamic_eff(SceneId, ScenePoolId, CopyId, Sid, Node) ->
    cast_to_scene(SceneId, ScenePoolId, {'send_dynamic_eff', SceneId, CopyId, Sid, Node}).

%% 查询对象的buff列表
send_object_buff_list(SceneId, ScenePoolId, Node, RoleId, IdList) ->
    cast_to_scene(SceneId, ScenePoolId, {'send_object_buff_list', Node, RoleId, IdList}).

%% 关闭指定的场景
close_scene(Sid, PoolId) ->
    cast_to_scene(Sid, PoolId, {'close_scene'}),
    erase({get_scene_pid, Sid, PoolId}).

%% 清理所有场景数据
clear_scene(Sid, PoolId) ->
    cast_to_scene(Sid, PoolId, {'clear_scene'}).

%% 清理指定场景的房间数据(怪物):通用清理房间
clear_scene(Sid, PoolId, CopyId) ->
    lib_mon:clear_scene_mon(Sid, PoolId, CopyId, 1).

%% 更新场景数据
update(#player_status{scene = SceneId, scene_pool_id=PoolId, id = Id}, KeyValueList) ->
    cast_to_scene(SceneId, PoolId, {'update', Id, KeyValueList}).

update(SceneId, PoolId, Id, KeyValueList) ->
    cast_to_scene(SceneId, PoolId, {'update', Id, KeyValueList}).

%% 主城和野外同步场景房间人数
sync_scene_user_num(SceneId, PoolId, CopyId, Value)->
    cast_to_scene(SceneId, PoolId, {'sync_scene_user_num', SceneId, PoolId, CopyId, Value}).

%% 获取野外挂机在线玩家
get_outside_online_user(SceneId, PoolId, CopyId, RoleId, Sid) ->
    cast_to_scene(SceneId, PoolId, {'get_outside_online_user', RoleId, CopyId, Sid}).

get_boss_hp_show(SceneId, PoolId, CopyId, Sid) ->
    cast_to_scene(SceneId, PoolId, {'send_scene_boss_hp', SceneId, CopyId, Sid}).

%% 玩家进入场景的辅助信息
send_role_assist_info(SceneId, PoolId, Node, RoleId, ShareSkillL) ->
    cast_to_scene(SceneId, PoolId, {'send_role_assist_info', Node, RoleId, ShareSkillL}).

update_skill_passive_share(SceneId, PoolId, Node, RoleId, MyShareSkillL, SceneShareSkillL) ->
    cast_to_scene(SceneId, PoolId, {'update_skill_passive_share', Node, RoleId, MyShareSkillL, SceneShareSkillL}).

handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    %% 更新场景服务器
    mod_scene_agent:update(PS, [{lv, PS#player_status.figure#figure.lv}, {battle_attr, PS#player_status.battle_attr}]),
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_PLAYER_DIE, data = #{attersign := Sign, atter := Atter}}) ->
    player_die(PS, Sign, Atter#battle_return_atter.id),
    {ok, PS};
handle_event(PS, #event_callback{}) ->
    {ok, PS}.

%% call场景 -> false|Res
call_to_scene(SceneId, PoolId, Msg) ->
    case get_scene_pid(SceneId, PoolId) of
        undefined ->
            ?ERR("call_to_scene(~w, ~w) undefined, msg=~p ", [SceneId, PoolId, Msg]),
            false;
        clusters ->
            ?ERR("call_to_cluster_scene(~w, ~w) not allow, msg=~p ", [SceneId, PoolId, Msg]),
            false;
        %% mod_clusters_node:apply_call(?MODULE, call_to_scene, [SceneId, PoolId, Msg]);
        Pid ->
            case catch gen_server:call(Pid, Msg) of
                {'EXIT', _}=Error ->
                    ?ERR("call_to_scene(~w, ~w) error=~p", [SceneId, PoolId, Error]),
                    false;
                Res -> Res
            end
    end.

cast_to_scene(SceneId, PoolId, Msg) ->
    case get_scene_pid(SceneId, PoolId) of
        undefined ->
            ?ERR("cast_to_scene(~w, ~w) pid undefined, msg=~p ", [SceneId, PoolId, Msg]),
            tool:back_trace_to_file(),
            false;
        clusters ->
            mod_clusters_node:apply_cast(?MODULE, cast_to_scene, [SceneId, PoolId, Msg]);
        Pid ->
            gen_server:cast(Pid, Msg)
    end.

%% 启动
start_link(Scene, PoolId) ->
    gen_server:start_link(?MODULE, [Scene, PoolId], []).

%% Num:场景代理进程个数
%% WorkerId:进行标示
%% Scene:场景配置
init([Scene, PoolId]) ->
    process_flag(trap_exit, true),
    process_flag(priority, high),
    %% erlang:process_flag(min_heap_size, 1024*1024),
    SceneProcessName = misc:scene_process_name(Scene#ets_scene.id, PoolId),
    set_process_pid(SceneProcessName),
    put(scene_area, #{}),
    put(scene_pos, #{}),
    put(scene_id, Scene#ets_scene.id),
    put(scene_origin_type, Scene#ets_scene.origin_type),
    Pid = self(),
    spawn(fun () -> timer:sleep(2000), lib_scene_mark:load_mark(Scene#ets_scene.id, Pid) end),
    %% mod_scene:add_node_scene(Scene#ets_scene.id),
    %% mod_scene:copy_scene(Scene#ets_scene.id, 0),
    mod_scene_monitor:start_link(Scene#ets_scene.id),
    %% catch ?ERR("=============mod_scene_agent(~w, ~w) is creat at node ~w ============", [Scene#ets_scene.id, PoolId, node()]),
    {ok, Scene#ets_scene{npc=[], mon=[], jump=[], requirement=[], pool_id=PoolId}}.

handle_cast(R , State) ->
    case catch mod_scene_agent_cast:handle_cast(R, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, Normal, NewState} ->
            {stop, Normal, NewState};
        Reason ->
            ?ERR("mod_scene_agent_cast error: ~p, Reason:=~p~n",[R, Reason]),
            {noreply, State}
    end.

handle_call(R, From, State) ->
    case catch mod_scene_agent_call:handle_call(R , From, State) of
        {reply, NewFrom, NewState} ->
            {reply, NewFrom, NewState};
        Reason ->
            ?ERR("mod_scene_agent_call error: ~p, Reason=~p~n",[R, Reason]),
            {reply, error, State}
    end.

handle_info(R, State) ->
    case catch mod_scene_agent_info:handle_info(R, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        {stop, Normal, NewState} ->
            {stop, Normal, NewState};
        Reason ->
            ?ERR("mod_scene_agent_info error: ~p, Reason:=~p~n",[R, Reason]),
            {noreply, State}
    end.

terminate(_R, State) ->
    del_process_pid(misc:scene_process_name(State#ets_scene.id, State#ets_scene.pool_id)),
    %%?ERR("mod_scene_agent is terminate, id is (~w, ~w), res:~p", [State#ets_scene.id, State#ets_scene.pool_id, R]),
    {ok, State}.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.

%% ================== 私有函数 =================
%% 启动场景模块
start_scene(Id, PoolId) ->
    case data_scene:get(Id) of
        []    -> undefined;
        Scene ->
            {ok, NewScenePid} = start_link(Scene, PoolId),
            NewScenePid
    end.

get_scene_pid_global(Id, PoolId) ->
    SceneProcessName = misc:scene_process_name(Id, PoolId),
    ScenePid = case get_process_pid(SceneProcessName) of
                   Pid when is_pid(Pid) ->
                       case misc:is_process_alive(Pid) of
                           true  -> Pid;
                           false ->
                               exit(Pid, kill),
                               del_process_pid(SceneProcessName),
                               mod_scene_init:start_new_scene(Id, PoolId)
                       end;
                   _ -> mod_scene_init:start_new_scene(Id, PoolId)
               end,
    case is_pid(ScenePid) of
        true ->
            put({get_scene_pid, Id, PoolId}, ScenePid),
            ScenePid;
        false ->
            undefined
    end.

%% 动态加载某个场景
get_scene_pid(Id) -> get_scene_pid(Id, 0).
get_scene_pid(Id, PoolId) ->
    case get({get_scene_pid, Id, PoolId}) of
        ScenePid when is_pid(ScenePid) ->
            case erlang:is_process_alive(ScenePid) of
                true ->
                    ScenePid;
                _ ->  %% 如果要使用close_scene接口，需要重新检查进程是否还存在
                    case data_scene:get(Id) of
                        #ets_scene{cls_type=?SCENE_CLS_TYPE_CENTER} ->
                            case config:get_cls_type() of
                                1 -> get_scene_pid_global(Id, PoolId);
                                _ -> clusters
                            end;
                        #ets_scene{} -> get_scene_pid_global(Id, PoolId);
                        _ -> undefined
                    end
            end;
        undefined ->
            case data_scene:get(Id) of
                #ets_scene{cls_type=?SCENE_CLS_TYPE_CENTER} ->
                    case config:get_cls_type() of
                        1 -> get_scene_pid_global(Id, PoolId);
                        _ -> clusters
                    end;
                #ets_scene{} -> get_scene_pid_global(Id, PoolId);
                _ -> undefined
            end
    end.

%% 获取进程pid
get_process_pid(ProcessName) ->
    case config:get_cls_type() of
        1 ->
            %% 跨服中心启动
            misc:whereis_name(local, ProcessName);
        _ ->
            %% 跨服节点启动
            misc:whereis_name(global, ProcessName)
    end.

%% 获取进程pid
set_process_pid(ProcessName) ->
    case config:get_cls_type() of
        1 ->
            %% 跨服中心启动
            misc:register(local, ProcessName, self());
        _ ->
            %% 跨服节点启动
            misc:register(global, ProcessName, self())
    end.

del_process_pid(ProcessName) ->
    case config:get_cls_type() of
        1 ->
            %% 跨服中心启动
            misc:unregister(local, ProcessName);
        _ ->
            %% 跨服节点启动
            misc:unregister(global, ProcessName)
    end.
