%%%------------------------------------
%%% @Module  : lib_relationship_api
%%% @Author  :  xiaoxiang
%%% @Created :  2016-12-14
%%% @Description: 社交api
%%%------------------------------------

-module(lib_relationship_api).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("relationship.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("def_vip.hrl").
-include("team.hrl").

-export([
        handle_event/2
        , get_rela_and_intimacy_online/2    %% 获得ID列表的关系和亲密度 在线 玩家自身进程才能获得
        , get_rela_and_intimacy/2           %% 获得ID列表的关系和亲密度 离线要查询数据库，慎用
        , get_rela_and_intimacy_offline/2   %% 获得ID列表的关系和亲密度 离线
        , send_rela_view_info/3
        , event_trigger/1                   %% 触发增加好友亲密度
        , get_friend_num/1                  %% 获得好友数量
        , trigger_intimacy/1
        , add_firend_directly/2
    ]).

handle_event(Player, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = OnlineFlag}) when is_record(Player, player_status) ->
    #player_status{id = RoleId, figure = Figure, online = OldOnlineFlag} = Player,
    if
        OnlineFlag == ?ONLINE_ON ->
            lib_relationship:role_change_online_status(RoleId, Figure, OnlineFlag);
        OldOnlineFlag == ?ONLINE_ON andalso OnlineFlag == ?ONLINE_OFF ->
            lib_relationship:role_change_online_status(RoleId, Figure, OnlineFlag);
        true -> skip
    end,
    {ok, Player};
handle_event(Player, #event_callback{type_id = ?EVENT_CHAT_PRIVATE, data = PrivateChatUid}) when is_record(Player, player_status) ->
    #player_status{id = RoleId} = Player,
    lib_relationship:update_last_ctime_each_one(RoleId, PrivateChatUid, utime:unixtime()),
    {ok, Player};
handle_event(Player, #event_callback{}) ->
    {ok, Player}.

get_rela_and_intimacy_online(RoleId, IdList) ->
    lib_relationship:get_rela_and_intimacy_online(RoleId, IdList).

get_rela_and_intimacy(RoleId, IdList) ->
    lib_relationship:get_rela_and_intimacy(RoleId, IdList).

get_rela_and_intimacy_offline(RoleId, IdList) ->
    lib_relationship:get_rela_and_intimacy_offline(RoleId, IdList).

%% 触发增加双方亲密度
event_trigger({kill_mon, Mid, MonKind, BossType, BLWhos}) ->
    case data_rela:get_intimacy_obtain_cfg(?INTIMACY_TYPE_MON) of
        #intimacy_obtain_cfg{intimacy = Intimacy, trigger_obj = ObjList} when is_list(ObjList) ->
            case lists:member({MonKind, BossType}, ObjList) of
                true ->
                    F = fun(T, Map) ->
                        case T of
                            #mon_atter{node = Node, team_id = TeamId, id = RoleId} ->
                                TeamMap = maps:get(Node, Map, #{}),
                                RoleL = maps:get(TeamId, TeamMap, []),
                                NewTeamMap = maps:put(TeamId, [RoleId|RoleL], TeamMap),
                                maps:put(Node, NewTeamMap, Map);
                            _ -> Map
                        end
                    end,
                    Map = lists:foldl(F, #{}, BLWhos),
                    List = maps:to_list(Map),
                    IsCls = util:is_cls(),
                    F1 = fun({Node, TeamMap}) ->
                        case IsCls of
                            true ->
                                mod_clusters_center:apply_cast(Node, lib_relationship_api, trigger_intimacy, [{kill_mon, Mid, TeamMap, Intimacy}]);
                            false ->
                                trigger_intimacy({kill_mon, Mid, TeamMap, Intimacy})
                        end
                    end,
                    lists:foreach(F1, List);
                _ -> skip
            end;
        _ -> skip
    end;
event_trigger({pass_dun, DunId, TeamMap}) ->
    case data_rela:get_intimacy_obtain_cfg(?INTIMACY_TYPE_DUN) of
        #intimacy_obtain_cfg{intimacy = Intimacy, trigger_obj = ObjList} when is_list(ObjList) ->
            case lists:member(DunId, ObjList) of
                true ->
                    trigger_intimacy({pass_dun, DunId, TeamMap, Intimacy});
                _ -> skip
            end;
        _ -> skip
    end;
event_trigger(_) -> skip.

trigger_intimacy({kill_mon, Mid, TeamMap, Intimacy}) ->
    TeamRoleL = maps:values(TeamMap),
    ExtraMsg = [{kill_mon, Mid}],
    F = fun(RoleL) ->
        lib_relationship:trigger_intimacy_add(RoleL, Intimacy, ?INTIMACY_TYPE_MON, 0, ExtraMsg)
    end,
    lists:foreach(F, TeamRoleL);
trigger_intimacy({pass_dun, DunId, TeamMap, Intimacy}) ->
    TeamRoleL = maps:values(TeamMap),
    ExtraMsg = [{pass_dun, DunId}],
    F = fun(RoleL) ->
        lib_relationship:trigger_intimacy_add(RoleL, Intimacy, ?INTIMACY_TYPE_DUN, 0, ExtraMsg)
    end,
    lists:foreach(F, TeamRoleL);
trigger_intimacy(_) -> skip.

%%--------------------------------------------------
%% 发送玩家交互面板信息(被请求信息的玩家进程)
%% 点击人物头像弹出的那个
%% @param  Player   被请求PS
%% @param  RelaType 请求者与自己的关系类型
%% @return          description
%%--------------------------------------------------
send_rela_view_info(Player, RequesterId, RelaType) ->
    #player_status{id = RoleId, figure = Figure, team = StatusTeam} = Player,
    #status_team{team_id = TeamId} = StatusTeam,
    {ok, BinData} = pt_140:write(14010, [?SUCCESS, RoleId, Figure, RelaType, TeamId]),
    lib_server_send:send_to_uid(RequesterId, BinData).

%% 获得好友数量
get_friend_num(RoleId) ->
    length(lib_relationship:get_friend_on_dict(RoleId)).

%% 不走申请流程直接加好友
%% RoleId:请求者id，BeAskId:被请求角色id
add_firend_directly(RoleId, BeAskId) ->
    case RoleId =/= BeAskId of 
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_relationship, do_add_firend_directly, [RoleId, BeAskId]);
        false ->
            skip
    end.


