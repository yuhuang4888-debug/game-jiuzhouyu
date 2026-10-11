%%%-----------------------------------
%%% @Module  : lib_server_send
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.18
%%% @Description: 发送消息
%%%-----------------------------------
-module(lib_server_send).
-include("scene.hrl").
-include("server.hrl").
-include("record.hrl").
-include("common.hrl").
-include("predefine.hrl").

-export([
        send_to_sid/2,
        send_to_sid/3,
        send_to_sid/4,
        send_to_uid/2,
        send_to_uid/3,
        send_to_uid/4,
        send_to_scene/3,
        send_to_scene/4,
        send_to_area_scene/6,
        send_to_role_area_scene/7,
        send_to_scene_group/5,
        send_to_local_all/1,
        send_to_all/1,
        send_to_all/3,
        send_to_guild/2,
        send_to_all_guild/1,
        send_to_team/2,
        send_to_realm/2,
        send_to_camp/2,
        send_to_career/2,
        send_to_rela/2,
        send_to_all_opened/2,
        send_to_scene_guild/4
    ]).


%%发送信息给指定sid玩家.
%%sid:发送进程组
%%Bin:二进制数据.
send_to_sid(Sid, Bin) ->
    %% rand_to_process_by_sid(Sid) ! {send, Bin}.
    Sid ! {send, Bin}.

%% 在指定的节点执行send_to_sid方法
send_to_sid(Node, Sid, Bin) ->
    case Node =/= none of
        true ->
            rpc:cast(Node, ?MODULE, send_to_sid, [Sid, Bin]);
        false ->
            send_to_sid(Sid, Bin)
    end.

%%发送信息给指定sid玩家.
%%sid:发送进程组, Mod:模块名字, Pro:协议号， Args:参数
send_to_sid(Sid, Mod, Pro, Args)->
    {ok, Bin} = Mod:write(Pro, Args),
    Sid ! {send, Bin}.

%%给id玩家信息
%%id：玩家id
%%Bin：二进制数据.
send_to_uid(Id, Bin) ->
    case rand_to_process_by_id(Id) of
        undefined -> skip;
        Pid -> Pid ! {send, Bin}
    end.

%% 在指定的节点执行send_to_uid方法
send_to_uid(Node, Id, Bin) ->
    case Node =/= none andalso Node =/= node() of
        true ->
            rpc:cast(Node, ?MODULE, send_to_uid, [Id, Bin]);
        false ->
            send_to_uid(Id, Bin)
    end.

%%给id玩家信息
%%id：玩家id, Mod:模块名字, Pro:协议号， Args:参数list,列表型
send_to_uid(Id, Mod, Pro, Args)->
    case rand_to_process_by_id(Id) of
        undefined ->
            skip;
        Pid ->
            {ok, Bin} = Mod:write(Pro, Args),
            Pid ! {send, Bin}
    end.

%%给（任意节点）的场景发送信息
%%Sid:场景id
%%CopyId:副本ID
%%Bin:二进制数据.
send_to_scene(Sid, PoolId, CopyId, Bin) ->
    mod_scene_agent:send_to_scene(Sid, PoolId, CopyId, Bin).

%%给（任意节点）的场景发送信息
%%Sid:场景id
%%Bin:二进制数据.
send_to_scene(Sid, PoolId, Bin) ->
    mod_scene_agent:send_to_scene(Sid, PoolId, Bin).

%%给（任意节点）场景区域(9宫格区域)发信息
%%Sid:场景ID
%%CopyId:副本ID
%%X,Y坐标
%%Bin:数据
send_to_area_scene(Sid, PoolId, CopyId, X, Y, Bin) ->
    case lib_scene:is_broadcast_scene(Sid) of
        true ->
            mod_scene_agent:send_to_scene(Sid, PoolId, CopyId, Bin);
        false ->
            mod_scene_agent:send_to_area_scene(Sid, PoolId, CopyId, X, Y, Bin)
    end.

%%给（任意节点）场景区域(9宫格区域)发信息[尽量以玩家为中心]
%%Sid:场景ID
%%CopyId:副本ID
%%X,Y坐标
%%Bin:数据
send_to_role_area_scene(RoleId, Sid, PoolId, CopyId, X, Y, Bin) ->
    case lib_scene:is_broadcast_scene(Sid) of
        true ->
            mod_scene_agent:send_to_scene(Sid, PoolId, CopyId, Bin);
        false ->
            mod_scene_agent:send_to_role_area_scene(RoleId, Sid, PoolId, CopyId, X, Y, Bin)
    end.

send_to_scene_group(Sid, PoolId, CopyId, Group, Bin) ->
    mod_scene_agent:send_to_scene_group(Sid, PoolId, CopyId, Group, Bin).

%% 给当前节点的玩家发信息
send_to_local_all(Bin) ->
    L = ets:match(?ETS_ONLINE, #ets_online{sid='$1', _='_'}),
    do_broadcast(L, Bin).

%% 给所有游戏节点的玩家发信息
send_to_all(Bin) ->
    mod_chat_agent:send_msg([{all, Bin}]).

%% 类型发送：发送消息
%% 需要告知客户端在公共线监听此协议包
send_to_all(Type, Value, Bin) ->
    mod_chat_agent:send_msg([{Type, Value, Bin}]).

send_to_all_opened(OpenDay, Bin) ->
    util:get_open_day() >= OpenDay andalso mod_chat_agent:send_msg([{all, Bin}]).

%% 对列表中的所有socket进行广播
do_broadcast(L, Bin) ->
    [send_to_sid(S, Bin) || [S] <- L].

%%帮派
send_to_guild(GuildId, Bin) ->
    case GuildId of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{guild, GuildId, Bin}])
    end.

%% 指定场景的帮派
send_to_scene_guild(SceneId, CopyId, GuildId, Bin) ->
    case SceneId == 0 orelse GuildId == 0 of
        true -> skip;
        _ -> mod_chat_agent:send_msg([{scene_guild, SceneId, CopyId, GuildId, Bin}])
    end.
    

%%所有帮派
send_to_all_guild(Bin) ->
    mod_chat_agent:send_msg([{all_guild, Bin}]).

%%阵营
send_to_realm(Realm, Bin) ->
    case Realm of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{realm, Realm, Bin}])
    end.

%%阵营
send_to_camp(Realm, Bin) ->
    case Realm of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{camp, Realm, Bin}])
    end.

%%队伍
send_to_team(TeamId, Bin) ->
    case TeamId of
        0 -> skip;
        _ -> lib_team_api:send_to_team(TeamId, Bin)
    end.

%% 职业
send_to_career(Career, Bin) ->
    case Career of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{career, Career, Bin}])
    end.

%% 发送好友(在线玩家使用)
%% @param Id 在线的玩家
send_to_rela(RoleId, BinData) ->
    Pid = misc:get_player_process(RoleId),
    case self() =:= Pid of
        true ->
            IdList = lib_relationship:get_friend_id_on_dict(RoleId),
            [send_to_uid(Id, BinData)||Id<-IdList];
        false ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST, ?NOT_HAND_OFFLINE, ?MODULE, send_to_rela, [RoleId, BinData])
    end.

rand_to_process_by_id(Id) ->
    misc:whereis_name(global, misc:player_send_process_name(Id)).