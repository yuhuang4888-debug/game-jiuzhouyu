%%%------------------------------------
%%% @Module  : mod_scene_agent_info
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.05.18
%%% @Description: 场景管理info处理
%%%------------------------------------
-module(mod_scene_agent_info).
-include("scene.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("predefine.hrl").
-include("figure.hrl").

-export([handle_info/2]).

%% 挂机玩家连续技
handle_info({'combo', PlayerId, Args}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{online=?ONLINE_OFF_ONHOOK}=User ->
            lib_onhook_offline:combo(Args, User, State);
        _ -> skip
    end,
    {noreply, State};

%% 定时器返回
handle_info({timeout, TimeRef, {'timer_call_back', TimeoutEvl}}, State) ->
    case catch lib_scene_agent:timer_call_back(TimeRef, TimeoutEvl, State) of
        {'EXIT', Reason} ->
            ?ERR("scene_timer_call_back event:~p~n reason:~p~n", [TimeoutEvl, Reason]);
        _ -> skip
    end,
    {noreply, State};

%% 挂机循环
handle_info({'go_to_onhook_place', PlayerId}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{online = ?ONLINE_OFF_ONHOOK, team = Team, figure = _Figure}=User ->
            OOnhookRef = get({onhook_ref, PlayerId}),
            util:cancel_timer(OOnhookRef),
            if
                Team#status_team.team_id > 0 ->  skip;
                true ->
                    case get({onhook_count, PlayerId}) of
                        undefined ->
                            put({onhook_count, PlayerId}, {urand:rand(600, 1000), 1});
                        {LimitCount, Count} when Count < LimitCount ->
                            put({onhook_count, PlayerId}, {LimitCount, Count+1});
                        _->
                            lib_player:apply_cast(PlayerId, ?APPLY_CAST_SAVE, lib_onhook, create_onhook_team, []),
                            erase({onhook_count, PlayerId})
                    end
            end,
            OnhookRef = lib_onhook_offline:go_to_onhook_place(User, State),
            put({onhook_ref, PlayerId}, OnhookRef);
        % 离线状态触发战斗
        #ets_scene_user{online = ?ONLINE_OFF}=User ->
            OOnhookRef = get({onhook_ref, PlayerId}),
            util:cancel_timer(OOnhookRef),
            OnhookRef = lib_onhook_offline:go_to_onhook_place(User, State),
            put({onhook_ref, PlayerId}, OnhookRef);
        _Other ->
            erase({onhook_ref, PlayerId})
    end,
    {noreply, State};

%% 离线挂机死亡后10准备下线，防止玩家买活消息延迟
handle_info({'onhook_wait_for_stop', PlayerId}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{online = ?ONLINE_OFF_ONHOOK, battle_attr = BA}=User ->
            if
                BA#battle_attr.hp > 0 ->
                    OnhookRef = lib_onhook_offline:go_to_onhook_place(User, State),
                    put({onhook_ref, PlayerId}, OnhookRef);
                true -> %% 20s没有买活直接下线
                    erase({onhook_ref, PlayerId}),
                    mod_login:stop_player(PlayerId)
            end;
        _ ->
            erase({onhook_ref, PlayerId})
    end,
    {noreply, State};

%% 挂机循环
handle_info({'path_return', PlayerId, Path}, State) ->
    case lib_scene_agent:get_user(PlayerId) of
        #ets_scene_user{online=?ONLINE_OFF_ONHOOK}=User ->
            lib_onhook_offline:go_to_onhook_place(User#ets_scene_user{onhook_path=Path}, State);
        _ -> skip
    end,
    {noreply, State};

%% 监控不存在的怪物,清空内存数据,每个小时检查一次
handle_info('monitor', Status) ->
    %% 玩家处理
    AllUser = lib_scene_agent:get_scene_user(),
    F = fun(User) ->
                case misc:get_player_process(User#ets_scene_user.id) of
                    Pid when is_pid(Pid) -> skip;
                    _ -> lib_scene_agent:del_user({User#ets_scene_user.id, User#ets_scene_user.server_id})
                end
        end,
    [ F(User) || User <- AllUser],
    {noreply, Status};

%% mark存储
handle_info({'scene_mark', AreaMaps, PosMaps}, Status) ->
    put(scene_area, AreaMaps),
    put(scene_pos, PosMaps),
    {noreply, Status};

%% 特殊关闭场景进程
handle_info({'init_close_scene'}, Status) ->
    %% []代表清理所有房间怪物
    lib_scene_object_agent:clear_scene_object(?BATTLE_SIGN_MON, [], 1),
    {stop, normal, Status};

handle_info({timeout, TimeRef, {'add_mon_create_delay', CopyId, {M, F, A}}}, State) ->
    RefL = lib_scene_agent:get_mon_create_delay(CopyId),
    erlang:apply(M, F, A),
    lib_scene_agent:set_mon_create_delay(CopyId, lists:delete(TimeRef, RefL)),
    {noreply, State};

%% 
handle_info({fake_client, Mod, Method, Args}, State) ->
    erlang:apply(Mod, Method, Args++[State]),
    {noreply, State};

%% 默认匹配
handle_info(Info, Status) ->
    catch ?ERR("mod_scene_agent_info not match: ~p", [Info]),
    ?PRINT("~p ~p info_nomatch :~p~n", [?MODULE, ?LINE, [Info]]),
    {noreply, Status}.
