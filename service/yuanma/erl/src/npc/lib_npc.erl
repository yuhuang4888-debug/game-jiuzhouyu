%%%-----------------------------------
%%% @Module  : lib_npc
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.05
%%% @Description: npc
%%%-----------------------------------
-module(lib_npc).
-include("scene.hrl").
-include("task.hrl").
-include("server.hrl").
-include("common.hrl").
-export(
    [
        get_name_by_npc_id/1,
        get_data/1,
        get_scene_by_npc_id/1,
        is_near_npc/4,
        check_npc/5,
        get_scene_npc/1,
        get_scene_npc/2,
        send_scene_npc/2,
        send_npc_to_uid/5,
        get_npc_info_by_id/1,
        delete/1,
        new/7,
        load_role_npc_info/1,
        change_role_npc_info/3,
        update_role_npc_info/2
    ]
).

%% ---------------------------------------------------------------------------
%% @doc 动态创建一个npc
-spec new(NpcId, SceneId, CopyId, X, Y, BroadCast, Args) ->  Return when
    NpcId       :: integer(),       %% npcId
    SceneId     :: integer(),       %% 场景id
    CopyId      :: integer() | [],  %% 房间id
    X           :: integer(),       %% X轴像素坐标
    Y           :: integer(),       %% Y轴像素坐标
    BroadCast   :: 0 | 1,           %% 是否广播（0不广播，1广播）
    Args        :: list(),          %% 参数列表(预留)
    Return      :: ok | error.      %% 返回值
%% ---------------------------------------------------------------------------
new(NpcId, SceneId, CopyId, X, Y, BroadCast, _Args) -> 
    case data_npc:get(NpcId) of
        [] ->
            error;
        N ->
            NpcInfo = N#ets_npc{
                id = NpcId,
                x = X,
                y = Y,
                scene = SceneId,
                copy_id = CopyId
            },
            mod_scene_npc:insert(NpcInfo),
            case BroadCast of
                0 -> ok;
                1 -> 
                    %{ok, BinData} = pt_120:write(12014, [NpcInfo]),
                    %lib_server_send:send_to_scene(SceneId, CopyId, BinData),
                    ok
            end
    end.

%% 获取npc信息
get_npc_info_by_id(Id) ->
    case mod_scene_npc:lookup(Id) of
        [] -> [];
        Npc -> Npc
    end.

%% 删除npc信息
delete(Id) ->
    mod_scene_npc:delete(Id).

%% 获取指定场景的npc列表
%% 每次生成一份有点浪费内存，后续需改进
get_scene_npc(SceneId) ->
	mod_scene_npc:match(SceneId).

%% 获取指定场景的npc列表，包括动态npc
get_scene_npc(SceneId, NpcInfo) -> 
    F = fun(Npc, Result) -> 
            case lists:keyfind(Npc#ets_npc.id, 1, NpcInfo) of
                false -> [{Npc#ets_npc.id, Npc#ets_npc.show, Npc#ets_npc.scene, Npc#ets_npc.x, Npc#ets_npc.y, Npc#ets_npc.anima}|Result];
                _ -> Result
            end
        end,
    lists:foldl(F, [], get_scene_npc(SceneId)) ++ [E||{_, _, EScene, _, _, _}=E <- NpcInfo, SceneId==EScene].

%% 发送场景NPC
send_scene_npc(PS, SceneId) ->
    #player_status{id = Id, sid = Sid, npc_info = NpcInfo} = PS,
    NewNpcInfo = [E||{_, _, EScene, _, _, _}=E <- NpcInfo, SceneId==EScene],
    Node = mod_disperse:get_clusters_node(),
    case lib_scene:is_clusters_scene(SceneId) of
        true ->
            mod_clusters_node:apply_cast(mod_scene_npc, apply_cast, [?MODULE, send_npc_to_uid, [Id, Node, Sid, SceneId, []]]);
        false -> 
            mod_scene_npc:apply_cast(?MODULE, send_npc_to_uid, [Id, Node, Sid, SceneId, NewNpcInfo])
    end.

%% 发送场景NPC给玩家
send_npc_to_uid(_Id, Node, Sid, SceneId, NpcInfo) ->
    Data = get(),
    Data1 = [ V || {_K, V} <-Data, V#ets_npc.scene =:= SceneId],
    F = fun(Npc, Result) -> 
        case lists:keyfind(Npc#ets_npc.id, 1, NpcInfo) of
            false -> [{Npc#ets_npc.id, Npc#ets_npc.show, Npc#ets_npc.scene, Npc#ets_npc.x, Npc#ets_npc.y, Npc#ets_npc.anima}|Result];
            _ -> Result
        end
    end,
    PackNpcList = lists:foldl(F, [], Data1) ++ NpcInfo,
    {ok, BinData} = pt_121:write(12100, [SceneId, PackNpcList]),
    lib_server_send:send_to_sid(Node, Sid, BinData),
    ok.

%% 获取npc名称用npc数据库id
get_name_by_npc_id(NpcId)->
    case data_npc:get(NpcId) of
        [] -> <<"">>;
        Npc -> Npc#ets_npc.name
    end.

%% 获取信息
get_data(NpcId) ->
    case data_npc:get(NpcId) of
        [] -> ok;
        Npc -> Npc
    end.

%% 获取NPC当前场景信息
get_scene_by_npc_id(NpcId) ->
    case mod_scene_npc:lookup(NpcId) of
        [] -> [];
        Data -> [Data#ets_npc.scene, Data#ets_npc.x, Data#ets_npc.y, Data#ets_npc.sname]
    end.

%% 根据NPC资源ID检查是否在NPC附近
is_near_npc(NpcId, PlayerScene, PlayerX, PlayerY) ->
    case get_scene_by_npc_id(NpcId) of
        [] -> false;
        [Scene, X, Y, _SceneName] ->
            (Scene =:= PlayerScene
                andalso abs(X - PlayerX) =< 300
                andalso abs(Y - PlayerY) =< 300 )
    end.

%% 根据NPC唯一ID检查是否在NPC附近
check_npc(NpcId, _NpcTypeId, PlayerScene, PlayerX, PlayerY) ->
    case mod_scene_npc:lookup(NpcId) of
        %% NPC不存在
        [] -> {fail, 1};
        Npc -> 
            case ( Npc#ets_npc.scene =:= PlayerScene andalso abs(Npc#ets_npc.x - PlayerX) =< 300
                    andalso abs(Npc#ets_npc.y - PlayerY) =< 300 ) of
                %% NPC不在附近
                false -> {fail, 3};
                true -> ok
            end
    end.

%% 加载玩家的NPC动态信息
load_role_npc_info(RoleId) ->
    RoleNpcList = db:get_all(io_lib:format("select `npc_id`, `is_show`,`scene_id`,`X`,`Y`,`args` from player_npc where id=~w", [RoleId])),
    [{NpcId,IsShow,SceneId,X,Y,util:bitstring_to_term(ArgBin)} || [NpcId,IsShow,SceneId,X,Y,ArgBin] <- RoleNpcList].

%% 更新npcshow
change_role_npc_info(RoleId, NpcInfo, ChangeNpcShowList) ->
    F = fun(Elem, TmpNpcInfo) ->
            case Elem of
                {NpcId, IsShow, SceneId, X, Y, Args} ->
                    Sql = io_lib:format(<<"replace into player_npc set `id`=~p,`npc_id`=~p, `is_show`=~p,`scene_id`=~p,`X`=~p,`Y`=~p,`args`='~s'">>,
                        [RoleId, NpcId, IsShow, SceneId, X, Y, util:term_to_bitstring(Args)]),
                    case lists:keyfind(NpcId, 1, TmpNpcInfo) of
                        {NpcId, IsShow, SceneId, X, Y, Args} -> TmpNpcInfo;
                        {_, _State, _IsShow, _X, _Y, _Args} ->
                            db:execute(Sql),
                            lists:keyreplace(NpcId, 1, TmpNpcInfo, Elem);  
                        _ ->
                            db:execute(Sql),
                            [Elem | TmpNpcInfo]
                    end;
                _ ->
                    TmpNpcInfo
            end
    end,
    NewNpcInfo = lists:foldl(F, NpcInfo, ChangeNpcShowList),
    {ok, BinData} = pt_121:write(12103, [ChangeNpcShowList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    NewNpcInfo.

update_role_npc_info(PlayerStatus, NpcInfo) -> 
    {ok, PlayerStatus#player_status{npc_info = NpcInfo}}.
