%%%-----------------------------------
%%% @Module  : lib_unite_send
%%% @Author  : zhenghehe
%%% @Created : 2012.02.01
%%% @Description: 
%%%-----------------------------------
-module(lib_unite_send).
-compile(export_all).

%% 跨服调用send_to_uid
cluster_to_uid(Id, Bin) ->
    send_to_uid(Id, Bin).
%% mod_disperse:cast_to_unite(lib_unite_send, send_to_uid, [Id, Bin]).

%% 跨服调用send_to_uid
cluster_to_all(Bin) ->
    send_to_all(Bin).
%% mod_disperse:cast_to_unite(lib_unite_send, send_to_all, [Bin]).

%% ----------------------------------------------------------------------
%% @doc 可变参数发送信息 
-spec send_msg(MsgTypeValueList) -> ok when 
      MsgTypeValueList :: list().     %% 类型值组合的元组列表，元组类型
%% {uid, Id, Bin} | {all, Bin} | {all, MinLv, MaxLv, Bin}
%% {scene, SceneId, Bin} | {scene, SceneId, CopyId, Bin} | {guild, GuildId, Bin}
%% {realm, Realm, Bin} | {team, TeamId, Bin} | {group, Group, Bin}
%% ----------------------------------------------------------------------
send_msg(MsgTypeValueList) -> 
    mod_chat_agent:send_msg(MsgTypeValueList).

%%发送给某个id(只用于聊天服务器)
send_to_uid(Id, Bin) ->
    mod_chat_agent:send_msg([{uid, Id, Bin}]).

%% 世界
send_to_all(Bin) ->
    mod_chat_agent:send_msg([{all, Bin}]).

%% 按键值条件广播
send_to_all(Type, Value, Bin) ->
    mod_chat_agent:send_msg([{Type, Value, Bin}]).

%% 指定玩家
send_to_one(Id, Bin) -> send_to_uid(Id, Bin).

%% 给场景玩家发消息
send_to_scene(SceneId, Bin) ->
    mod_chat_agent:send_msg([{scene, SceneId, Bin}]).

%% 给场景某个房间的玩家发送消息
send_to_scene(SceneId, CopyId, Bin) ->
    mod_chat_agent:send_msg([{scene, SceneId, CopyId, Bin}]).

%%帮派
send_to_guild(GuildId, Bin) ->
    case GuildId of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{guild, GuildId, Bin}])
    end.

%%阵营
send_to_realm(Realm, Bin) ->
    case Realm of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{realm, Realm, Bin}])
    end.

%%新阵营
send_to_new_realm(Realm, Bin) ->
    case Realm of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{new_realm, Realm, Bin}])
    end.

%%队伍
send_to_team(TeamId, Bin) ->
    case TeamId of
        0 -> skip;
        _ -> mod_chat_agent:send_msg([{team, TeamId, Bin}])
    end.

%% 跨服3v3队伍
%% send_to_kf_3v3_team(Kf3v3TeamId, Bin) ->
%%     case Kf3v3TeamId of
%%         {0, "", 0} -> skip; % 默认值
%%         _ -> mod_chat_agent:send_msg([{kf_3v3_team, Kf3v3TeamId, Bin}])
%%     end. 

%% 分组聊天
send_to_group(Group, Bin) ->
    mod_chat_agent:send_msg([{group, Group, Bin}]).

%% 公开招募
send_to_open_call(Bin) ->
    mod_chat_agent:send_msg([{open_call, Bin}]).

%%发送信息给指定sid玩家.
send_to_sid(S, Bin) ->
    S ! {send, Bin}.

%% 发送信息给指定sid玩家
%% 1.send_to_sid主动抛错
%% 2.send_to_sid2允许容错
send_to_sid2(S, Bin) when is_pid(S)->
    send_to_sid(S, Bin);
send_to_sid2(_, _) -> skip.

%%发聊天系统信息
send_sys_msg(Sid, Msg) ->
    {ok, BinData} = pt_110:write(11020, Msg),
    send_to_sid(Sid, BinData).

%%%-----------------------------------------------------
%%% @doc 传闻发送,根据玩家的#talk_accept.tv来判断是否发给玩家
%%%-----------------------------------------------------

%% 世界
send_to_all_tv(Bin) ->
    mod_chat_agent:send_msg([{all, tv, Bin}]).

%%%-----------------------------------------------------
%%% @doc 聊天和传闻信息的发送,无视用户的消息屏蔽设置
%%%-----------------------------------------------------

%% 世界
send_to_all_unmask(Bin) ->
    mod_chat_agent:send_msg([{all, unmask, Bin}]).
