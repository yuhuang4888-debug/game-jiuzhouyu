%%%-----------------------------------
%%% @Module  : lib_chat
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.22
%%% @Description: 聊天
%%%-----------------------------------
-module(lib_chat).

%% 聊天
-export([
        send_text_msg/6,
        send_msg/6,
        get_chat_vip_count/2,
        get_chat_count_daily/1,
        check_talk_text_condition/5,
        check_talk_condition/4,
        check_talk_args/2,
        check_talk_lim/4,
        get_ignore_msg/1,
        get_time/1,
        put_time/2,
        send_world_channel_left_count/1,
        send_error_code/2
        ]).

%% 传闻
-export([send_TV/4, make_tv/3, make_tv/6]).

-export([
         update_sys_notice_4_houtai/0,
         forbid_chat_4_houtai/2,
         release_chat_4_houtai/1,
         forbid_chat/3,
         release_chat/2,
         get_talk_lim/1,
         be_lim_talk/1,
         chat_too_frequently/2,
         send_sys_msg/2,
         is_chat_forbid/1,
         forbid_chat_db/4,
         log_forbid_chat/3       %% 禁言日志
        ]).

-export([clear_talk_reported_count/1]).

-export([send_zone_chat_info/2]).

-compile(export_all).

-include("unite.hrl").
-include("server.hrl").
-include("chat.hrl").
-include("figure.hrl").
-include("team.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("3v3.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("def_vip.hrl").
-include("goods.hrl").
-include("partner.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("revelation_equip.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("attr.hrl").
-include("def_fun.hrl").
-include("record.hrl").
-include("predefine.hrl").

%% ----------------------------------------------------------------
%% 事件
%% ----------------------------------------------------------------

handle_event(#player_status{online = Online} = PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    %% 机器人聊天
    case Online == ?ONLINE_ON of
        true -> send_robot_chat_info(PS, [lv]);
        false -> skip
    end,
    {ok, PS};
handle_event(PS, #event_callback{}) ->
    {ok, PS}.

%% ----------------------------------------------------------------
%% 接口
%% ----------------------------------------------------------------

%% -----------------------------------------------------------------
%% @desc   假人聊天登录初始化（同一账号下角色只触发一次假人聊天）
%% @param  PS
%% @return PS
%% -----------------------------------------------------------------
login(PS) ->
    #player_status{id = RoleId, accid = Accid, accname = AccName} = PS,
    RoleList = lib_login:get_role_list(Accid, AccName),
    [{LvRoleId, MaxLv}, {_DayRoleId, MaxTime}] = get_max_role(RoleList),
    TypeList = get_update_type_list(RoleId, MaxLv, LvRoleId, MaxTime),
    F = fun(Type) ->
        Count = mod_counter:get_count(RoleId, ?MOD_CHAT, ?MOD_CHAT_ROBOT, Type),
        Count =:= 0 andalso mod_counter:increment(RoleId, ?MOD_CHAT, ?MOD_CHAT_ROBOT, Type)
        end,
    lists:foreach(F, TypeList),
    PS.

%% -----------------------------------------------------------------
%% @desc   获得角色最大等级和登出时间
%% @param  RoleList      同一账号下所有角色
%% @return [{LvRoleId, MaxLv}, {_DayRoleId, MaxTime}]
%% -----------------------------------------------------------------
get_max_role(RoleList) ->
    F = fun(Role, [TempLvRole, TempTimeRole]) ->
        {_TempRoleId, TempLv} = TempLvRole,
        {_DayRoleId, TempTime} = TempTimeRole,
        [RoleId, _Status, Figure, _TodayLoginRewardId] = Role,
        #figure{lv = Lv} = Figure,
        Time = lib_role:get_role_offline_timestamp(RoleId),
        NewLvRole = ?IF(Lv >= TempLv, {RoleId, Lv}, TempLvRole),
        NewDayRole = ?IF(Time >= TempTime, {RoleId, Time}, TempTimeRole),
        [NewLvRole, NewDayRole]
        end,
    lists:foldl(F, [{0, 0},{0, 0}], RoleList).

%% -----------------------------------------------------------------
%% @desc   获得已触发的类型
%% @param  RoleId     角色Id
%% @param  MaxLv      最大角色的等级
%% @param  LvRoleId   最大等级角色Id
%% @param  MaxTime    最大的登出时间
%% @return [Type,...]
%% -----------------------------------------------------------------
get_update_type_list(RoleId, MaxLv, LvRoleId, MaxTime) ->
    TypeList = data_robot_chat:get_type_list(),
    F = fun(Type, TempTypeList) ->
        Conditions = data_robot_chat:get_type_cond(Type),
        {open_day, OpenDay} = ulists:keyfind(open_day, 1, Conditions, {open_day, 0}),
        {lv, Lv} = ulists:keyfind(lv, 1, Conditions, {lv, 0}),
        ServerDay = util:get_open_day(),
        ServerTime = util:get_open_time(),
        if
            length(Conditions) =:= 1 andalso OpenDay =/= 0 ->
                Time = lib_role:get_role_offline_timestamp(RoleId),
                ?IF(ServerDay >= OpenDay andalso utime:is_same_day(ServerTime, MaxTime)
                    andalso Time < MaxTime, [Type | TempTypeList], TempTypeList);
            LvRoleId =:= RoleId -> TempTypeList;
            true ->  ?IF(MaxLv >= Lv andalso ServerDay >= OpenDay, [Type | TempTypeList], TempTypeList)
        end
        end,
    lists:foldl(F, [], TypeList).

% 11001 世界聊
make_record(chat_11001, [Channel, ChatContent, SenderServerNum, CServerMsg, SenderServerId, SenderServerName, Province, City, SenderId, SenderFigure,
        MsgSend, Args, ArgsResult, Utime]) ->
    make_chat(Channel, ChatContent, SenderServerNum, CServerMsg, SenderServerId, SenderServerName, SenderId, SenderFigure, 0, #figure{},
        MsgSend, Args, ArgsResult, Utime, 0, 0, Province, City, 0);
% 11002 私聊
make_record(chat_11002, [Channel, ChatContent, SenderServerNum, SenderServerId, SenderServerName, SenderId, SenderFigure, ReceiveId, ReceiveFigure,
        MsgSend, Args, ArgsResult, Utime]) ->
    make_chat(Channel, ChatContent, SenderServerNum, <<>>, SenderServerId, SenderServerName, SenderId, SenderFigure, ReceiveId, ReceiveFigure,
        MsgSend, Args, ArgsResult, Utime, 0, 0, "", "", 0);
% 11003 语音
make_record(chat_11003, [Channel, ChatContent, SenderServerNum, SenderServerId, SenderServerName, SenderId, SenderFigure, ReceiveId, ReceiveFigure,
        MsgSend, Args, ArgsResult, Utime, Voiceid, VoiceTime]) ->
    make_chat(Channel, ChatContent, SenderServerNum, <<>>, SenderServerId, SenderServerName, SenderId, SenderFigure, ReceiveId, ReceiveFigure,
        MsgSend, Args, ArgsResult, Utime, Voiceid, VoiceTime, "", "", 0);
% 11029 喇叭
make_record(chat_11029, [Channel, ChatContent, SenderServerNum, SenderServerId, SenderServerName, Province, City, HornType, SenderId, SenderFigure,
        MsgSend, Args, ArgsResult, Utime]) ->
    make_chat(Channel, ChatContent, SenderServerNum, <<>>, SenderServerId, SenderServerName, SenderId, SenderFigure, 0, #figure{},
        MsgSend, Args, ArgsResult, Utime, 0, 0, Province, City, HornType).

make_chat(Channel, ChatContent, SenderServerNum, CServerMsg, SenderServerId, SenderServerName, SenderId, SenderFigure, ReceiveId, ReceiveFigure,
        MsgSend, Args, ArgsResult, Utime, Voiceid, VoiceTime, Province, City, HornType) ->
    #chat{
        channel = Channel
        , chat_content = ChatContent
        , sender_server_num = SenderServerNum
        , sender_c_server_msg = CServerMsg
        , sender_id = SenderId
        , sender_figure = SenderFigure
        , sender_server_id = SenderServerId
        , sender_server_name = SenderServerName
        , receive_id = ReceiveId
        , receive_figure = ReceiveFigure
        , msg_send = MsgSend
        , args = Args
        , args_result = ArgsResult
        , utime = Utime
        , voice_id = Voiceid
        , voice_time = VoiceTime
        , province = Province
        , city = City
        , horn_type = HornType
    }.

%% 发送语音文字
send_voice_text(Status, Channel, ReceiveId, ClientAutoId, VoiceTextData) ->
    {ok, BinData} = pt_110:write(11013, [Channel, ClientAutoId, VoiceTextData]),
    send_msg_on_direct(Status, Channel, ReceiveId, BinData).

%% 直接发送消息
send_msg_on_direct(Status, Channel, ReceiveId, BinData) ->
    #player_status{id = Id, figure = Figure, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId,
                   sid = Sid, team=#status_team{team_id=TeamId}, x = X, y = Y, guild = Guild, team_3v3 = Team3v3
%%                    battle_attr = #battle_attr{group = Group}
        } = Status,
    #figure{career = _Career} = Figure,
    Team3v3Id = case Team3v3 of
                    #role_3v3_new{team_id = TeamId1} ->
                        TeamId1;
                    _ ->
                        0
                end,
    case Channel of
        ?CHAT_CHANNEL_WORLD -> lib_server_send:send_to_all(BinData);
        %% 只有文字有气泡
        ?CHAT_CHANNEL_HORN -> skip;
        ?CHAT_CHANNEL_NEARBY -> lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData);
        %% ?CHAT_CHANNEL_GROUP -> lib_server_send:send_to_scene_group(Scene, ScenePoolId, CopyId, Group, BinData);
        ?CHAT_CHANNEL_GUILD when Guild#status_guild.id > 0 -> lib_server_send:send_to_guild(Guild#status_guild.id, BinData);
        ?CHAT_CHANNEL_TEAM when TeamId > 0 -> lib_team_api:send_to_team(TeamId, BinData);
        ?CHAT_CHANNEL_3V3_TEAM when Team3v3Id > 0 ->
            mod_clusters_node:apply_cast(mod_3v3_center, send_chat_to_team, [TeamId, Id, BinData]);
        ?CHAT_CHANNEL_PRIVATE ->
            lib_server_send:send_to_sid(Sid, BinData),
            lib_server_send:send_to_uid(ReceiveId, BinData);
        ?CHAT_CHANNEL_RELA ->
            lib_server_send:send_to_sid(Sid, BinData),
            lib_server_send:send_to_rela(Id, BinData);
        %% ?CHAT_CHANNEL_CAREER -> lib_server_send:send_to_career(Career, BinData);
%%        ?CHAT_CHANNEL_3V3_TEAM ->
%%            lib_3v3_api:send_to_3v3_team(Id, BinData);
        _ -> lib_server_send:send_to_sid(Sid, BinData)
    end.

%% ----------------------------------------------------------------
%% pp_chat 聊天
%% ----------------------------------------------------------------

%% 系统绕过检查模拟玩家发送文字信息(11001协议)
send_msg_by_server(RoleId, Channel, ReceiveId, Msg, Args) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, send_msg_by_server, [Channel, ReceiveId, Msg, Args]);

%% @param Status :: #player_status{}
%%        Channel :: integer()
%%        ReceiveId :: integer()
%%        Msg :: string() | binary
%%        Args :: list()
send_msg_by_server(Status, Channel, ReceiveId, Msg, Args) ->
    % 协议参数
    #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName, id = Id, figure = Figure} = Status,
    NowTime = utime:unixtime(),
    {Province, City} = {"", ""},
    ArgsResult = lib_chat:check_talk_args(Status, Args),
    DoArgs = lib_chat:handle_chat_args(Args, Status),
    DoArgsStr = util:term_to_string(DoArgs),
    ChatContent = ?CHAT_CONTENT_TEXT,

    % 11001数据组装
    Msg1 = util:make_sure_list(Msg),
    PackDataRaw = [Channel, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, Msg1, DoArgsStr, ArgsResult, NowTime],
    {ok, NewBinData} = pt_110:write(11001, PackDataRaw),
    Chat = lib_chat:make_record(chat_11001, [Channel, ChatContent, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, Msg1,
                                DoArgsStr, ArgsResult, NowTime]),

    % 信息发送
    {ok, NewStatus} = lib_chat:send_text_msg(Status, ChatContent, Channel, ReceiveId, Chat, NewBinData),

    {ok, NewStatus}.

send_text_msg(Status, ChatContent, Channel, ReceiveId, Chat, BinData) ->
    send_msg(ChatContent, Channel, Status, ReceiveId, Chat, BinData).

%% 根据不同的聊天类型发送不同的消息(发送语音、图片、文本)
%% @param Chat #chat{}
%% @param BinData
%% @return
send_msg(ChatContent, Channel, Status, ReceiveId, Chat, BinData) ->
    #player_status{id = Id, sid = Sid} = Status,
    case check_send_msg(Status, Channel, ReceiveId) of
        true ->
            NewStatus = Status,
            do_send_msg(ChatContent, Channel, NewStatus, ReceiveId, Chat, BinData);
        {true, daily} ->
            NewStatus = Status,
            increment_chat_count(Channel, Id),
            do_send_msg(ChatContent, Channel, NewStatus, ReceiveId, Chat, BinData);
        {true, consume, Cost} ->
            case lib_goods_api:cost_objects_with_auto_buy(Status, Cost, chat, lists:concat([Channel])) of
                {true, NewStatus, _} -> do_send_msg(ChatContent, Channel, NewStatus, ReceiveId, Chat, BinData);
                {false, _ErrorCode, NewStatus} -> lib_server_send:send_to_sid(Sid, BinData)
            end;
        {false, ErrorCode} ->
            send_error_code(Sid, ErrorCode),
            NewStatus = Status;
        _ ->
            NewStatus = Status
    end,
    {ok, NewStatus}.

do_send_msg(ChatContent, Channel, Status, ReceiveId, Chat, BinData) ->
    #player_status{
        id = Id, figure = Figure, scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId, team_3v3 = Team3v3,
        sid = Sid, team=#status_team{team_id=TeamId}, x = _X, y = _Y, guild = Guild, server_id = ServerId
%%                   battle_attr = #battle_attr{group = Group}
    } = Status,
    #figure{career = _Career} = Figure,
    Team3v3Id = case Team3v3 of
        #role_3v3_new{team_id = TeamId1} ->
            TeamId1;
        _ ->
            0
    end,
    %% 触发成就
    lib_achievement_api:async_event(Id, lib_achievement_api, chat_event, 1),
    case Channel of
        ?CHAT_CHANNEL_WORLD ->
            case ChatContent == ?CHAT_CONTENT_TEXT of
                true ->
                    %% 触发成就
                    lib_achievement_api:async_event(Id, lib_achievement_api, chat_world_event, 1),
                    lib_player_event:async_dispatch(Id, ?EVENT_CHAT_WORLD_TEXT);
                false -> skip
            end,
            %% send_world_channel_left_count(Status),
            mod_chat_cache:save_cache(Channel, Id, ReceiveId, Chat),
            lib_server_send:send_to_all(BinData);
        %% 只有文字有气泡（喇叭）
        ?CHAT_CHANNEL_HORN ->
            lib_player_event:async_dispatch(Id, ?EVENT_CHAT_HORN),
            case ChatContent == ?CHAT_CONTENT_TEXT of
                true -> mod_chat_bugle:put(#bugle{role_id = Id, show_time = ?CHAT_HORN_SHOW_TIME, send_type = ReceiveId, msg = Chat});
                false -> skip
            end;
        ?CHAT_CHANNEL_NEARBY ->
            lib_server_send:send_to_scene(Scene, ScenePoolId, CopyId, BinData);
            % lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData);
        ?CHAT_CHANNEL_GUILD when Guild#status_guild.id > 0 ->
            mod_chat_cache:save_cache({Channel, Guild#status_guild.id}, Id, ReceiveId, Chat),
            lib_server_send:send_to_guild(Guild#status_guild.id, BinData);
        ?CHAT_CHANNEL_REPLY when Guild#status_guild.id > 0 ->
%%            mod_chat_cache:save_cache({Channel, Guild#status_guild.id}, Id, ReceiveId, Chat),
            lib_server_send:send_to_guild(Guild#status_guild.id, BinData);
        ?CHAT_CHANNEL_TEAM when TeamId > 0 -> lib_team_api:send_to_team(TeamId, BinData);
        ?CHAT_CHANNEL_3V3_TEAM when Team3v3Id > 0 ->
            mod_clusters_node:apply_cast(mod_3v3_center, send_chat_to_team, [TeamId, Id, BinData]);
        ?CHAT_CHANNEL_PRIVATE ->
            lib_server_send:send_to_sid(Sid, BinData),
            case mod_chat_agent:lookup(ReceiveId) of
                [#ets_unite{online = ?ONLINE_ON}] -> IsRealOnline = 1;
                _ -> IsRealOnline = 0
            end,
            %% 黑名单不发送
            % IsBlack1 = lib_relationship:is_black(Id, ReceiveId),
            % IsBlack2 = lib_relationship:is_black(ReceiveId, Id),
            %% 好友才能私聊
            IsFriend = lib_relationship:is_friend_on_dict(Id, ReceiveId),
            case IsFriend == false of
                true ->
                    case lib_relationship:is_black(ReceiveId, Id) of
                        true -> lib_server_send:send_to_sid(Sid, pt_110, 11000, [?ERRCODE(err140_in_another_blacklist_to_do_sth)]);
                        false -> lib_server_send:send_to_sid(Sid, pt_110, 11000, [?ERRCODE(err140_6_not_friend)])
                    end;
                false ->
                    if
                        IsRealOnline == 1 ->
                            mod_chat_cache:save_cache(Channel, Id, ReceiveId, Chat),
                            %% 触发成就
                            lib_achievement_api:async_event(Id, lib_achievement_api, chat_private_event, 1),
                            lib_server_send:send_to_uid(ReceiveId, BinData);
                        ChatContent == ?CHAT_CONTENT_TEXT orelse ChatContent == ?CHAT_CONTENT_VOICE ->
                            case lib_player:is_id_exists(ReceiveId) of
                                true -> mod_chat_cache:save_cache(Channel, Id, ReceiveId, Chat);
                                false -> skip
                            end;
                        true ->
                            lib_server_send:send_to_sid(Sid, pt_110, 11000, [?ERRCODE(err140_14_not_online)])
                    end,
                    lib_player_event:dispatch(Status, ?EVENT_CHAT_PRIVATE, ReceiveId)
            end;
        ?CHAT_CHANNEL_RELA ->
            lib_server_send:send_to_sid(Sid, BinData),
            lib_server_send:send_to_rela(Id, BinData);
        ?CHAT_CHANNEL_WAIT_TEAM ->
            lib_server_send:send_to_all(all_lv, {?CHAT_LV_TEAM, 65535}, BinData);
        ?CHAT_CHANNEL_SCENE ->
            lib_server_send:send_to_scene(Scene, ScenePoolId, CopyId, BinData);
        ?CHAT_CHANNEL_WORLD_KF ->
            mod_clusters_node:apply_cast(mod_clusters_center, apply_to_all_node, [lib_server_send, send_to_all, [all_lv, {?CHAT_LV_WORLD_KF, 65535}, BinData], 10]);
        % ?CHAT_CHANNEL_REPLY -> lib_server_send:send_to_scene(Scene, ScenePoolId, BinData);
        % ?CHAT_CHANNEL_CAMP ->
        %     mod_c_sanctuary_local:send_msg_to_camp(ServerId, BinData);
        ?CHAT_CHANNEL_SEA ->
            mod_seacraft_local:send_msg_to_sea(Sid, Id, Guild#status_guild.realm, BinData);
        ?CHAT_CHANNEL_SAME_CITY ->
            Opday = util:get_open_day(),
            case Opday >= 7 of
                true ->
                    mod_clusters_node:apply_cast(mod_clusters_center, apply_to_all_node, [lib_server_send, send_to_all, [all_lv, {?CHAT_LV_SAME_CITY, 65535}, BinData], 10]);
                _ ->
                    lib_server_send:send_to_all(BinData)
            end;
        ?CHAT_CHANNEL_ZONE -> mod_clusters_node:apply_cast(?MODULE, do_send_msg_center, [Channel, [ServerId, Id, ReceiveId, Chat, BinData]]);
        ?CHAT_CHANNEL_NG ->
            mod_night_ghost_kf:cast_center({'send_chat_msg', Channel, [ServerId, Id, ReceiveId, Chat, BinData]});
        _ -> lib_server_send:send_to_sid(Sid, BinData)
    end.

%% 调用到跨服,减少多次调用
do_send_msg_center(Channel = ?CHAT_CHANNEL_ZONE, [ServerId, Id, ReceiveId, Chat, BinData]) ->
    mod_zone_mgr:chat_by_server_id(ServerId, BinData),
    mod_chat_cache:save_cache(Channel, ServerId, Id, ReceiveId, Chat);
do_send_msg_center(_Channel, _Args) ->
    ok.

%% 检查是否能发送(次数,)
%% true | {true, daily}(消耗日常次数) | {true, consume, Consume}(消耗物品) | {false, ErrorCode}
check_send_msg(Status, Channel, ReceiveId) when
      Channel == ?CHAT_CHANNEL_HORN ->
    #player_status{id = _Id, figure = Figure} = Status,
    #figure{vip = _Vip, gm = GM} = Figure,
    if
        GM == 1 -> true;
        %% ChatCount > Count -> {true, daily};
        true ->
            case get_cost(Channel, ReceiveId) of
                [] -> {true, consume, []};
                Cost ->
                    case lib_goods_api:check_object_list_with_auto_buy(Status, Cost) of
                        {false, ErrorCode} -> {false, ErrorCode};
                        true -> {true, consume, Cost}
                    end
            end
    end;
check_send_msg(_Status, _Channel, _ReceiveId) ->
    true.

%% 获得聊天的vip次数
get_chat_vip_count(Channel, Vip) ->
    Nbv = case Channel of
              ?CHAT_CHANNEL_WORLD -> ?NBV_CHANNEL_WORLD;
              _ -> 0
          end,
    lib_vip:get_vip_privilege(Vip, ?MOD_CHAT, Nbv).

%% 获得聊天次数日常
get_chat_count_daily(Channel) ->
    case Channel of
        ?CHAT_CHANNEL_WORLD -> ?DAILY_CHAT_WORLD;
        _ -> 0
    end.

%% 聊天消耗
get_cost(?CHAT_CHANNEL_HORN, ReceiveId) ->
    List = data_horn:get_value(cost_goods),
    case lists:keyfind(ReceiveId, 1, List) of
        {_, Cost} when is_list(Cost) -> Cost;
        _ -> []
    end;
get_cost(_Channel, _ReceiveId) -> [].

%% 增加聊天日常次数
increment_chat_count(Channel, Id) ->
    case get_chat_count_daily(Channel) of
        0 -> skip;
        DailyId -> mod_daily:increment(Id, ?MOD_CHAT, DailyId)
    end.

%% 检查是否能聊文字
check_talk_text_condition(Status, Channel, TkTime, Ticket, Data) ->
    case check_talk_condition(Status, Channel, TkTime, Ticket) of
        true ->
            Len = get_len(Channel),
            case util:check_length(Data, Len) of
                true -> true;
                false -> {fail, ?ERRCODE(err110_max_msg_length)}
            end;
        ErrorRes ->
            ErrorRes
    end.

%% 检查是否能聊天(语音、图片、文本通用判断)
%% 检查是否能聊天(语音、图片、文本通用判断)
check_talk_condition(Status, Channel, _TkTime, _Ticket) ->
    #player_status{figure = Figure = #figure{vip = Vip}} = Status,
    #figure{gm = GM} = Figure,
    Now = utime:unixtime(),
    Time = get_time(Channel),       %% 上次发言时间
    CD   = get_cd(Vip, Channel),    %% 各种聊天的cd限制
    IsOpen = lists:member(Channel, ?CHAT_CHANNEL_OPEN_LIST),
    NeedLv = get_lv(Channel),
    if
        GM == 1 -> true;
        Figure#figure.lv < NeedLv -> {fail, ?ERRCODE(err110_lv_limit)}; %% 等级不够
        IsOpen == false -> {fail, ?ERRCODE(err110_unknow_channel)};     %% 未知频道
        Now - Time < CD ->
            if
                Channel == ?CHAT_CHANNEL_REPLY -> {fail, ?ERRCODE(empty_error)}; % 策划要求答题频道不弹此错误码，所以给一个空的错误码
                true -> {fail, {?ERRCODE(err110_channel_cd_not_enough), [util:term_to_string(CD)]}} %% cd未到
            end;
        true ->
            true
    end.

%%获取上次发言时间
get_time(Channel) ->
    case get({chat_channel, Channel}) of
        undefined -> 0;
        Time -> Time
    end.

%% 获取不同类型的cd时间
get_cd(_Vip, Channel) ->
    case Channel of
        ?CHAT_CHANNEL_WORLD     -> ?CHAT_GAP_WORLD;
        ?CHAT_CHANNEL_HORN      -> ?CHAT_GAP_HORN;
        ?CHAT_CHANNEL_NEARBY    -> ?CHAT_GAP_NEARBY;
        ?CHAT_CHANNEL_GUILD     -> ?CHAT_GAP_GUILD;
        ?CHAT_CHANNEL_TEAM      -> ?CHAT_GAP_TEAM;
        ?CHAT_CHANNEL_PRIVATE   -> ?CHAT_GAP_PRIVATE;
        ?CHAT_CHANNEL_RELA      -> ?CHAT_GAP_RELA;
        ?CHAT_CHANNEL_WAIT_TEAM -> ?CHAT_GAP_WAIT_TEAM;
        ?CHAT_CHANNEL_SCENE     -> ?CHAT_GAP_SCENE;
        ?CHAT_CHANNEL_WORLD_KF  -> ?CHAT_GAP_WORLD_KF;
        ?CHAT_CHANNEL_3V3_TEAM  -> ?CHAT_GAP_3V3_TEAM;
        ?CHAT_CHANNEL_REPLY     -> ?CHAT_GAP_REPLY;
        ?CHAT_CHANNEL_ZONE      -> ?CHAT_GAP_ZONE;
        ?CHAT_CHANNEL_CAMP      -> ?CHAT_GAP_CAMP;
        _                       -> ?CHAT_GAP_DEFAULT
    end.

%% 聊天等级
get_lv(Channel) ->
    case Channel of
        ?CHAT_CHANNEL_WORLD     -> ?CHAT_LV_WORLD;
        ?CHAT_CHANNEL_HORN      -> ?CHAT_LV_HORN;
        ?CHAT_CHANNEL_NEARBY    -> ?CHAT_LV_NEARBY;
        ?CHAT_CHANNEL_GUILD     -> ?CHAT_LV_GUILD;
        ?CHAT_CHANNEL_TEAM      -> ?CHAT_LV_TEAM;
        ?CHAT_CHANNEL_PRIVATE   -> ?CHAT_LV_PRIVATE;
        ?CHAT_CHANNEL_RELA      -> ?CHAT_LV_RELA;
        ?CHAT_CHANNEL_SCENE     -> ?CHAT_LV_SCENE;
        ?CHAT_CHANNEL_WORLD_KF  -> ?CHAT_LV_WORLD_KF;
        ?CHAT_CHANNEL_ZONE      -> ?CHAT_LV_ZONE;
        ?CHAT_CHANNEL_CAMP      -> ?CHAT_LV_CAMP;
        _                       -> ?CHAT_LV_DEFAULT
    end.

%% 长度
get_len(Channel) ->
    case Channel of
        _   -> ?CHAT_LEN_DEFAULT
    end.

%% 检查聊天参数[比如装备展示等需要做验证或者过滤]
%% Args:
%%  {goods, GoodsTypeId(物品类型id), GoodsId(物品唯一id)}:校验物品
%%  {partner, PartnerId(伙伴id), PartnerAutoId(伙伴唯一id)}:校验伙伴
%% @return 0:无参数 1:有参数校验正常 2:有参数校验失败
check_talk_args(_Status, []) -> ?CHAT_ARGS_RESULT_NO;
check_talk_args(Status, Args) -> check_talk_args_help(Args, Status).

check_talk_args_help([], _Status) -> ?CHAT_ARGS_RESULT_PASS;
check_talk_args_help([{goods, GoodsTypeId, GoodsId}|L], Status) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods_info(GoodsId, GoodsStatus#goods_status.dict),
    case is_record(GoodsInfo, goods) of
        true when GoodsInfo#goods.player_id == GoodsStatus#goods_status.player_id andalso GoodsInfo#goods.goods_id == GoodsTypeId ->
            check_talk_args_help(L, Status);
        false ->
            ?CHAT_ARGS_RESULT_NO_PASS
    end;
check_talk_args_help([{ng_boss_broadcast, _, _, _}|L], Status) ->
    check_talk_args_help(L, Status);
check_talk_args_help(_Args, _Status) ->
    ?CHAT_ARGS_RESULT_NO_PASS.

%% 检查禁言（true:禁言，false:允许说话）- 注意:校验为禁言后把信息发给自己
check_talk_lim(Status, Channel, _TkTime, _Ticket) ->
    #player_status{
       id = Id,
       talk_lim = TalkLim,
       talk_lim_time = TalkLimTime
      } = Status,
    Now = utime:unixtime(),
    case Now < TalkLimTime of %% 是否被禁言
        true  ->
            put_time(Channel, Now),
            true;
        false when TalkLim == 1 ->
            release_chat([Id], ?TALK_RELEASE_TYPE_2),
            put_time(Channel, Now),
            false;
        false ->
            put_time(Channel, Now),
            false
    end.

%% 判断是否可忽略信息信息(坐标、物品、表情)
%% @return {match, string() | binary(), mp()} | nomatch
get_ignore_msg(Msg) ->
    IgnoreMPList = lib_server_kv:get_server_kv(?SKV_IGNORE_WORD_MP),
    F = fun
        (MP, nomatch) ->
            case re:run(Msg, MP, [global, {capture, all, list}]) of
                {match, MatchMsg} -> {match, MatchMsg, MP};
                nomatch -> nomatch
            end;
        (_, Match) -> Match
    end,
    lists:foldl(F, nomatch, IgnoreMPList).

%% 写入当前发言时间
put_time(Channel, Time) -> put({chat_channel, Channel}, Time).

%% 发送世界频道聊天剩余的次数
send_world_channel_left_count(Status) ->
    #player_status{id = RoleId, figure = #figure{vip = Vip} } = Status,
    VipCount = lib_chat:get_chat_vip_count(?CHAT_CHANNEL_WORLD, Vip),
    DailyId = lib_chat:get_chat_count_daily(?CHAT_CHANNEL_WORLD),
    Count = mod_daily:get_count(RoleId, ?MOD_CHAT, DailyId),
    LeftCount = max(VipCount - Count, 0),
    {ok, BinData} = pt_110:write(11011, [LeftCount]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData).

%% 发送小红点
send_red_point(Status, ModuleId, Type) ->
    if
        ModuleId == ?MOD_GUILD ->
            #player_status{id = RoleId, guild = #status_guild{id = GuildId} } = Status,
            case GuildId > 0 of
                true -> mod_guild:send_red_point(GuildId, RoleId, Type);
                false -> skip
            end;
        true -> skip
    end.

%% 发送错误码
send_error_code(Sid, ErrorCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_110:write(11000, [ErrorCodeInt, ErrorCodeArgs]),
    lib_server_send:send_to_sid(Sid, BinData).

%% ----------------------------------------------------------------
%% 假人聊天触发
%% ----------------------------------------------------------------

%% 发送聊天
send_robot_chat_info(Status) ->
    send_robot_chat_info(Status, [open_day, lv]),
    ok.

send_robot_chat_info(#player_status{id = RoleId} = Status, CondTypeL) ->
    F = fun(CondType, List) ->
        L = get_robot_type_list(Status, CondType),
        L ++ List
    end,
    case lists:foldl(F, [], lists:reverse(CondTypeL)) of
        [Type|_] ->
            % ?MYLOG("hjhchat", "send_robot_chat_info RoleId:~p Type:~p ~n", [RoleId, Type]),
            {ok, BinData} = pt_110:write(11064, [Type]),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData),
            mod_counter:increment(RoleId, ?MOD_CHAT, ?MOD_CHAT_ROBOT, Type);
        _ ->
            skip
    end,
    ok.

%% 条件类型
get_robot_type_list(#player_status{id = RoleId} = Status, CondType) ->
    F = fun(Type) ->
        Cond = data_robot_chat:get_type_cond(Type),
        lists:keymember(CondType, 1, Cond)
    end,
    TypeList = lists:filter(F, data_robot_chat:get_type_list()),
    case TypeList == [] of
        true -> [];
        false ->
            List = [{?MOD_CHAT, ?MOD_CHAT_ROBOT, Type}||Type<-TypeList],
            CountL = mod_counter:get_count(RoleId, List),
            F2 = fun({{_, _, Type}, Count}, L) ->
                case Count == 0 of
                    true -> ?IF(check_robot_chat_cond(data_robot_chat:get_type_cond(Type), Status), [Type|L], L);
                    false -> L
                end
            end,
            lists:reverse(lists:foldl(F2, [], CountL))
    end.

check_robot_chat_cond([], _Status) -> true;
check_robot_chat_cond([{lv, Lv}|T], #player_status{figure = #figure{lv = Lv}} = Status) -> check_robot_chat_cond(T, Status);
check_robot_chat_cond([{open_day, Opday}|T], Status) ->
    case Opday == util:get_open_day() of
        true -> check_robot_chat_cond(T, Status);
        false -> false
    end;
check_robot_chat_cond(_, _Status) ->
    false.

%% ----------------------------------------------------------------
%% 系统动态消息
%% ----------------------------------------------------------------

%% 发送传闻、电视、服务端消息。(读取 data_language:get/2 配置)
%% @param BroadcastRange 广播方式：
%%          {scene, SceneId, ScenePoolId, CopyId}   场景ID、场景进程id、副本ID
%%          {scene, SceneId, ScenePoolId}           场景ID、场景进程id
%%          {guild, GuildId}                        公会 ID
%%          {all_guild}                             所有的公会
%%          {realm, Realm}                          阵营值(国家)
%%          {team, TeamId}                          队伍传闻
%%          {player, PlayerId}                      玩家自己
%%          {all}                                   世界传闻(默认传闻)
%% @param ModuleId（后台配置）      模块id          data_language:get/2 的第一个参数
%% @param Id（后台配置）            传闻id          data_language:get/2 的第二个参数
%% @param Msg 内容（后台配置）      [param1,param2,...]
send_TV(BroadcastRange, ModuleId, Id, Msg) ->
    BinData = make_tv(ModuleId, Id, Msg),
    case BroadcastRange of
        {scene, SceneId, ScenePoolId, CopyId} -> lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData);
        {scene, SceneId, ScenePoolId} -> lib_server_send:send_to_scene(SceneId, ScenePoolId, BinData);
        {guild, GuildId} -> lib_server_send:send_to_guild(GuildId, BinData);
        {all_guild} -> lib_server_send:send_to_all_guild(BinData);
        {realm, Realm} -> lib_server_send:send_to_realm(Realm, BinData);
        {camp, Camp} -> lib_server_send:send_to_camp(Camp, BinData);
        {team, TeamId} -> lib_server_send:send_to_team(TeamId, BinData);
        {player, PlayerId} -> lib_server_send:send_to_uid(PlayerId, BinData);
        {all} -> lib_server_send:send_to_all(BinData);
        {all_exclude, RoleIds} -> lib_server_send:send_to_all(all_exclude, RoleIds, BinData);
        {all_lv, MinLv, MaxLv} -> lib_server_send:send_to_all(all_lv, {MinLv, MaxLv}, BinData);
        {all_turn, MinTurn, MaxTurn} -> lib_server_send:send_to_all(all_turn, {MinTurn, MaxTurn}, BinData);
        {all_openday, OpenDay} -> lib_server_send:send_to_all_opened(OpenDay, BinData);
        {scene_guild, SceneId, CopyId, GuildId} -> lib_server_send:send_to_scene_guild(SceneId, CopyId, GuildId, BinData);
        _-> lib_server_send:send_to_all(BinData)
    end.

%% 制作传闻协议包
make_tv(ModuleId, Id, Msg) ->
    MsgList = util:link_list_client(Msg),
    {ok, BinData} = pt_110:write(11015, [ModuleId, Id, MsgList]),
    BinData.

%% 发送玩家传闻、电视、服务端消息。(读取 data_language 配置)
%% @param BroadcastRange 广播方式：
%%          {scene, SceneId, ScenePoolId, CopyId}   场景ID、场景进程id、副本ID
%%          {scene, SceneId, ScenePoolId}           场景ID、场景进程id
%%          {guild, GuildId}                        公会 ID
%%          {realm, Realm}                          阵营值(国家)
%%          {team, TeamId}                          队伍传闻
%%          {all}                                   世界传闻(默认传闻)
%% @param Figure #figure{} 需要显示的玩家figure
%% @param ModuleId（后台配置）      模块id
%% @param Id（后台配置）            传闻id
%% @param Msg 内容（后台配置）      [param1,param2,...]
send_TV(BroadcastRange, RoleId, Figure, ModuleId, Id, Msg) ->
    SerId = config:get_server_id(),
    BinData = make_tv(SerId, RoleId, Figure, ModuleId, Id, Msg),
    case BroadcastRange of
        {scene, SceneId, ScenePoolId, CopyId} -> lib_server_send:send_to_scene(SceneId, ScenePoolId, CopyId, BinData);
        {scene, SceneId, ScenePoolId} -> lib_server_send:send_to_scene(SceneId, ScenePoolId, BinData);
        {guild, GuildId} -> lib_server_send:send_to_guild(GuildId, BinData);
        {realm, Realm} -> lib_server_send:send_to_realm(Realm, BinData);
        {team, TeamId} -> lib_server_send:send_to_team(TeamId, BinData);
        {player, PlayerId} -> lib_server_send:send_to_uid(PlayerId, BinData);
        {all} -> lib_server_send:send_to_all(BinData);
        _-> lib_server_send:send_to_all(BinData)
    end.

%% 制作传闻协议包
make_tv(SerId, RoleId, Figure, ModuleId, Id, Msg) ->
    MsgList = util:link_list_client(Msg),
    {ok, BinData} = pt_110:write(11018, [SerId, RoleId, Figure, ModuleId, Id, MsgList]),
    BinData.

%% 发送频道的错误码
%% send_channel_error_code() ->
%%     {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
%%       {ok, BinData} = pt_110:write(11017, [?CHAT_WINDOW_ONLY, ErrorCodeInt, ErrorCodeArgs]),

%% ----------------------------------------------------------------
%% 聊天公用函数
%% ----------------------------------------------------------------

%% 记录1分钟内玩家聊天内容
%% @Content 聊天内容
%% @return [IsSame, NewPlayer]
%%  IsSame 0:不相同 1:相同
record_content(Player, Content) ->
    Now  = utime:unixtime(),
    case Player#player_status.chat of
        #status_chat{prev_record_time = PreTime, record_content = RecordContent} = Chat ->
            case (Now - PreTime) > ?CHAT_CACHE_TIME_DELETE of
                true ->
                    NewChat = #status_chat{prev_record_time = Now, record_content = [Content]},
                    NewPlayer = Player#player_status{chat = NewChat},
                    [?CHAT_CONTENT_SAME_NO, NewPlayer];
                false ->
                    %% 限制记录数量为10条,控制占用内存量
                    NewRecordContent = lists:sublist([Content | RecordContent], 10),
                    NewChat = Chat#status_chat{record_content = NewRecordContent},
                    NewPlayer = Player#player_status{chat = NewChat},
                    %% 取得过去聊天相同信息的数量
                    Num = count_num(RecordContent, Content, 0),
                    %% 取得过去聊天最新的一条信息
                    FirstContent = lists:sublist(RecordContent, 1),
                    %% 跟上一条信息是否相同，过去聊天跟当前信息相同大于两条，返回的IsSmae=1
                    case lists:member(Content, FirstContent) orelse Num >= 2 of
                        true -> [?CHAT_CONTENT_SAME_YES, NewPlayer];
                        false -> [?CHAT_CONTENT_SAME_NO, NewPlayer]
                    end
            end;
        _ ->
            NewChat = #status_chat{prev_record_time = Now, record_content = [Content]},
            NewPlayer = Player#player_status{chat = NewChat},
            [?CHAT_CONTENT_SAME_NO, NewPlayer]
    end.

%% 统计聊天内容出现次数
count_num([],  _Content, Num) -> Num;
count_num([Content|T], Content, Num) -> count_num(T, Content, Num+1);
count_num([_|T], Content, Num) -> count_num(T, Content, Num).

%% ----------------------------------------------------------------
%% 禁言处理
%% ----------------------------------------------------------------

%% 系统公告
update_sys_notice_4_houtai() ->
    update_sys_notice(),
    ok.

%% 更新系统公告
update_sys_notice() ->
    Now = utime:unixtime(),
    Q = io_lib:format(<<"select `open_day`,`merge_day`,`source`,`type`,`color`,`content`,`url`,`num`,`span`,`start_time`,`end_time`,`status` from notice where `end_time` > ~p and status = 1">>, [Now]),
    Result = case db:get_all(Q) of
        [] -> [];
        List -> List
    end,
    ets:insert(?ETS_SYS_NOTICE, {sys_notice, Result}),
    NewResult = [list_to_tuple(T)||[OpenL, MergeL|T] <- Result, check_notice({util:bitstring_to_term(OpenL), util:bitstring_to_term(MergeL)}, [open_day, merge_day])],
    {ok, BinData} = pt_110:write(11050, [NewResult]),
    lib_unite_send:send_to_all(BinData),
    ok.

chat_11050_help(Sid) ->
    Now = utime:unixtime(),
    case ets:lookup(?ETS_SYS_NOTICE, sys_notice) of
        [] ->
            Q = io_lib:format(<<"select `open_day`,`merge_day`,`source`,`type`,`color`, `content`, `url`, `num`,`span`,`start_time`,`end_time`,`status` from notice where `end_time` > ~p and status = 1">>, [Now]),
            case db:get_all(Q) of
                [] -> Result = [];
                List -> Result = List
            end,
            ets:insert(?ETS_SYS_NOTICE, {sys_notice, Result});
        [{sys_notice, List}] ->
            Result = [ [OpenD, MergeD, Source, Type, Color, Content, Url, Num, Span, Start, End, Status] || [OpenD, MergeD, Source, Type, Color, Content, Url, Num, Span, Start, End, Status|_] <- List, End > Now, Status == 1]
    end,
    NewResult = [list_to_tuple(T)||[OpenL, MergeL|T] <- Result, check_notice({util:bitstring_to_term(OpenL), util:bitstring_to_term(MergeL)}, [open_day, merge_day])],
    {ok, BinData} = pt_110:write(11050, [NewResult]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

check_notice(_Info, []) -> true;
check_notice(Info, [H|T]) ->
    case do_check_notice(Info, H) of
        true  -> check_notice(Info, T);
        _ -> false
    end;
check_notice(_, _) -> false.

do_check_notice({OpenLim,_}, open_day) ->
    Now = util:get_open_day(),
    case OpenLim of
        [] -> true;
        OpenLim when is_list(OpenLim) ->
            CheckL = [1||{Start, End} <- OpenLim, Now >= Start, Now =< End],
            CheckL =/= [];
        _ -> false
    end;
do_check_notice({_,MergeLim}, merge_day) ->
    Now = util:get_merge_day(),
    case MergeLim of
        [] -> true;
        MergeLim when is_list(MergeLim) ->
            CheckL = [1||{Start, End} <- MergeLim, Now >= Start, Now =< End],
            CheckL =/= [];
        _ -> false
    end;
do_check_notice(_, _) -> false.


%% 禁言
%% @param RoleIdList [id1,id2,...]
forbid_chat_4_houtai(RoleIdList, LimitTime) ->
    forbid_chat(RoleIdList, LimitTime, ?TALK_LIMIT_TYPE_1).

%% 禁言
%% @param RoleIdList [id1,id2,...]
%% @param TalkLimitType ?TALK_LIMIT_TYPE_1,... 见chat.hrl
forbid_chat(RoleIdList, LimitTime, TalkLimitType) ->
    TalkLimTime = case LimitTime of
                      0 -> ?TALK_LIMIT_TIME_0;
                      1 -> ?TALK_LIMIT_TIME_1;
                      2 -> ?TALK_LIMIT_TIME_2;
                      3 -> ?TALK_LIMIT_TIME_3;
                      4 -> ?TALK_LIMIT_TIME_4;
                      5 -> ?TALK_LIMIT_TIME_5;
                      6 -> ?TALK_LIMIT_TIME_6;
                      7 -> ?TALK_LIMIT_TIME_7;
                      8 -> ?TALK_LIMIT_TIME_8;
                      9 -> ?TALK_LIMIT_TIME_9
                  end,
    Time = utime:unixtime()+TalkLimTime,
    lists:foreach(fun(RoleId) ->
                          case mod_chat_agent:lookup(RoleId) of
                              [] ->
                                  log_forbid_chat(RoleId, TalkLimitType, TalkLimTime),
                                  forbid_chat_db(RoleId, 1, TalkLimitType, Time);
                              [_Player] ->
                                  log_forbid_chat(RoleId, TalkLimitType, TalkLimTime),
                                  lib_player:update_player_info(RoleId, [{talk_lim, 1}, {talk_lim_time, Time}]),
                                  forbid_chat_db(RoleId, 1, TalkLimitType, Time)
                          end
                  end, RoleIdList),
    del_all_msg(RoleIdList),
    1.

%% 释放禁言
%% @param RoleIdList [id1,id2,...]
release_chat_4_houtai(RoleIdList) ->
    release_chat(RoleIdList, ?TALK_RELEASE_TYPE_1).

%% 释放禁言
%% @param RoleIdList [id1,id2,...]
%% @param Type 解禁类型 1 gm或管理员手动解禁 2自动解禁
release_chat(RoleIdList, Type) ->
    Time = utime:unixtime(),
    lists:foreach(fun(RoleId) ->
                          %%检查目标玩家是否在线
                          case mod_chat_agent:lookup(RoleId) of
                              [] ->
                                  log_realese_chat(RoleId, Type),
                                  clear_talk_reported_count(RoleId),
                                  forbid_chat_db(RoleId, 0, 0, Time);
                              [_Player] ->
                                  log_realese_chat(RoleId, Type),
                                  lib_player:update_player_info(RoleId, [{talk_lim, 0}, {talk_lim_time, Time}]),
                                  clear_talk_reported_count(RoleId),
                                  forbid_chat_db(RoleId, 0, 0, Time)
                          end
                  end, RoleIdList),
    1.

%% 设置禁言
%% @param TalkLimit 0:没有禁言 1:禁言
%% @param TalkLimitType 1 gm或指导员禁言 2违反规则自动禁言A  3违反规则自动禁言B  4被举报次数过多禁言 5世界发言次数限制
%% @param TalkLimitTime
forbid_chat_db(RoleId, TalkLimit, TalkLimitType, TalkLimitTime)->
    db:execute(io_lib:format(?SQL_UPDATE_TALK_LIM, [TalkLimit, TalkLimitType, TalkLimitTime, RoleId])),
    ok.

%% 获取禁言信息
get_talk_lim(Id) ->
    db:get_row(io_lib:format(?SQL_SELECT_TALK_LIM, [Id])).

%% 被禁言通知
be_lim_talk(Status) ->
    Talk_lim_time = Status#player_status.talk_lim_time,
    Time = utime:unixtime(),
    Release_after = Talk_lim_time - Time, %%release_after秒后释放禁言
    {ok, BinData} = pt_110:write(11042, Release_after),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    ok.

%% 玩家是否被禁言
is_chat_forbid(Id) ->
    case mod_chat_agent:lookup(Id) of
        [] ->
            [Talk_lim, _, _] = get_talk_lim(Id),
            case Talk_lim of
                1 -> true;
                _ -> false
            end;
        [Player] ->
            case Player#ets_unite.talk_lim of
                1 -> true;
                _ -> false
            end
    end.

%% 清空聊天举报次数(每次解放禁言的时候重置)
clear_talk_reported_count(Id) ->
    SQL = io_lib:format("update `player_login` set `talk_reported_count` = 0 where `id` = ~p", [Id]),
    db:execute(SQL).

%% 禁言日志
log_forbid_chat(Id, Type, LimitTime) ->
    Info = data_chat_m:get_forbid_type(Type, [LimitTime div 60]),
    IsAdmin = data_chat_m:is_admin_forbid(Type),
    NowTime = utime:unixtime(),
    lib_log_api:log_ban(3, erlang:integer_to_list(Id), Info, NowTime, IsAdmin).

%% 禁言解除日志
log_realese_chat(Id, Type) ->
    Info = data_chat_m:get_release_type(Type),
    IsAdmin = data_chat_m:is_admin_forbid(Type),
    NowTime = utime:unixtime(),
    lib_log_api:log_ban(4, erlang:integer_to_list(Id), Info, NowTime, IsAdmin).

%% 发言过频通知
chat_too_frequently(_Id, Sid) ->
    {ok, BinData} = pt_110:write(11014, []),
    lib_server_send:send_to_sid(Sid, BinData).


%% 通知客户端清理玩家聊天数据
del_all_msg(RoleIdList) ->
    mod_chat_cache:delete_public_cache_with_uid(RoleIdList),
    {ok, BinData} = pt_110:write(11046, [RoleIdList]),
    lib_server_send:send_to_all(BinData),
    ok.

%% 发聊天系统信息
send_sys_msg(Sid, Msg) ->
    {ok, BinData} = pt_110:write(11020, Msg),
    lib_server_send:send_to_scene(Sid, BinData).

%% 玩家聊天时间线
update_role_chat_time_line(?CHAT_CHANNEL_WORLD = Channel, NowTime, [RoleId, RoleName, RoleLv, RoleVipLv]) when RoleLv =< 200 ->
    case get(?CHAT_TIME_LINE) of
        TVal when not is_map(TVal) -> Val = #{};
        TVal -> Val = TVal
    end,
    ChatTimeLineL = maps:get(Channel, Val, []),
    LimCd = 300,
    F = fun(Time, {TSum, TAcc}) ->
        case NowTime - Time =< LimCd of
            true ->
                {TSum + 1, [Time|TAcc]};
            _ -> {TSum, TAcc}
        end
    end,
    {Sum, NewChatTimeLineL} = lists:foldl(F, {0, []}, [NowTime|ChatTimeLineL]),
    put(?CHAT_TIME_LINE, maps:put(Channel, NewChatTimeLineL, Val)),
    % ?ERR("Sum:~p", [Sum]),
    %% 5分钟内，世界发送聊天总条数超过33条（包括语音和文字都算1条），自动禁言3年，如果误杀，让客服手动解除
    %% 繁体：次数调大到60
    IsTw = lib_vsn:is_tw(),
    IsJp = lib_vsn:is_jp(),
    SumLim = if
        IsTw -> 60;
        RoleLv >= 60 andalso RoleLv =< 80 -> 14;
        RoleLv >= 81 andalso RoleLv =< 90 -> 18;
        RoleLv >= 91 andalso RoleLv =< 100 -> 23;
        RoleLv >= 101 andalso RoleLv =< 120 -> 26;
        RoleLv >= 121 andalso RoleLv =< 200 -> 31;
        true -> 33
    end,
    case (IsJp == false) andalso Sum >= SumLim of
        true ->
            Platform = config:get_platform(),
            SerId = config:get_server_id(),
            SerName = util:get_server_name(),
            lib_log_api:log_auto_forbid_chat(Platform, SerId, SerName, RoleId, RoleName, RoleLv, RoleVipLv,
                "5分钟内，世界发送聊天总条数超过33条（包括语音和文字都算1条），自动禁言3年，如果误杀，让客服手动解除", utime:unixtime()),
            forbid_chat([RoleId], 9, ?TALK_LIMIT_TYPE_5);
        _ -> skip
    end;
update_role_chat_time_line(?CHAT_CHANNEL_PRIVATE = Channel, NowTime, [RoleId, RoleName, RoleLv, RoleVipLv, ReceiveId, ReceiveVipLv]) when RoleLv =< 200, RoleVipLv < 2 ->
    case get(?CHAT_TIME_LINE) of
        TVal when not is_map(TVal) -> Val = #{};
        TVal -> Val = TVal
    end,
    ChatTimeLineL = maps:get(Channel, Val, []),
    LimCd = 300,
    NewChatTimeLineL = [{TmpReceiveId,TmpReceiveVipLv, TmpTime} || {TmpReceiveId, TmpReceiveVipLv, TmpTime} <- ChatTimeLineL, NowTime - TmpTime =< LimCd],
    case lists:keyfind(ReceiveId, 1, NewChatTimeLineL) of
        false ->
            LastChatTimeLineL = [{ReceiveId, ReceiveVipLv, NowTime}|NewChatTimeLineL];
        _ ->
            LastChatTimeLineL = NewChatTimeLineL
    end,
    put(?CHAT_TIME_LINE, maps:put(Channel, LastChatTimeLineL, Val)),
    F = fun({_, TmpReceiveVipLv, _}, {TmpSum, TmpVipNum}) ->
        case TmpReceiveVipLv > 0 of
            true ->
                {TmpSum + 1, TmpVipNum + 1};
            _ ->
                {TmpSum + 1, TmpVipNum}
        end
    end,
    {Sum, SumVipNum} = lists:foldl(F, {0, 0}, LastChatTimeLineL),
    %% 繁体
    IsTw = lib_vsn:is_tw(),
    IsJp = lib_vsn:is_jp(),
    {SumLim, SumVipLim} = if
        IsTw -> {10, 6};
        true -> {5, 3}
    end,
    %% 5分钟内，连续向超过3个不同充值玩家或者5个任意玩家，发起私聊，禁言一周
    case (IsJp == false) andalso (Sum >= SumLim orelse SumVipNum >= SumVipLim) of
        true ->
            Platform = config:get_platform(),
            SerId = config:get_server_id(),
            SerName = util:get_server_name(),
            lib_log_api:log_auto_forbid_chat(Platform, SerId, SerName, RoleId, RoleName, RoleLv, RoleVipLv,
                "5分钟内，连续向超过3个不同充值玩家或者5个任意玩家，发起私聊，禁言一周", utime:unixtime()),
            forbid_chat([RoleId], 8, ?TALK_LIMIT_TYPE_6);
        _ -> skip
    end;
update_role_chat_time_line(_, _, _) -> skip.

%% 含有敏感词进行禁言
sensitive_word_forbid(RoleId, Msg) ->
    case lib_word:check_keyword_name(Msg) of
        true -> %% 含有敏感词
            forbid_chat([RoleId], 8, ?TALK_LIMIT_TYPE_7);
        _ ->
            skip
    end.

%% 是否开启小跨服聊天
send_zone_chat_info(_ServerId, RoleId) ->
    case util:get_open_day() >= ?CHAT_OPEN_DAY_ZONE of
        true ->
            {ok, BinData} = pt_110:write(11023, [1]),
            lib_server_send:send_to_uid(RoleId, BinData);
            %mod_zone_mgr:cast_center([{send_zone_chat_info, ServerId, RoleId}]);
        false ->
            {ok, BinData} = pt_110:write(11023, [0]),
            lib_server_send:send_to_uid(RoleId, BinData)
    end.

%% 上传物品数据到跨服
add_goods_info_list(#player_status{id = RoleId}, Channel, IdList) ->
    IsRightChannel = lists:member(Channel, [?CHAT_CHANNEL_ZONE, ?CHAT_CHANNEL_WORLD_KF]),
    UniqueIdList = util:ulist(IdList),
    if
        % 判断是否能上传
        IsRightChannel == false -> ErrorCode = ?ERRCODE(err110_can_not_add_goods_to_kf_chat);
        true ->
            ErrorCode = ?SUCCESS,
            GoodsStatus = lib_goods_do:get_goods_status(),
            F = fun(GoodsId, List) ->
                [_RoleId, _GoodsId, TypeId|_] = InfoPack = pp_goods:make_goods_info_pack(RoleId, GoodsStatus, GoodsId),
                {ok, GoodsBinData} = pt_150:write(15001, InfoPack),
                case TypeId == 0 of
                    true -> List;
                    false -> [{GoodsId, GoodsBinData}|List]
                end
            end,
            BinDataL = lists:foldl(F, [], UniqueIdList),
            mod_clusters_node:apply_cast(mod_kf_chat, add_goods_info_list, [Channel, BinDataL])
    end,
    % ?PRINT("Channel:~p, RoleId:~p IdList:~p ErrorCode:~p ~n", [Channel, RoleId, IdList, ErrorCode]),
    {ok, BinData} = pt_110:write(11025, [ErrorCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 发送消息
gm_send_to_all(Player, MsgSend) ->
    #player_status{server_num = ServerNum, c_server_msg = CServerMsg,  server_id = SerId, server_name = ServerName, id = Id, figure = Figure} = Player,
    PackData = [?CHAT_CHANNEL_WORLD, ServerNum, CServerMsg, SerId, ServerName, "测试省", "测试城市",
        Id, Figure, MsgSend, util:term_to_string([]), ?CHAT_ARGS_RESULT_NO, utime:unixtime()],
    {ok, BinData} = pt_110:write(11001, PackData),
    lib_server_send:send_to_all(BinData),
    ok.


%%对聊天信息参数进行一些特殊处理
%%return Args | [{revelation_suit, goodsTypeId(类型id),  GoodsAutoId(唯一id), 数量}]
handle_chat_args(Args, PS) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    SuitList = lib_revelation_equip:get_suit_msg_all(PS),
    F = fun(Arg, AccList) ->
            case Arg of
                {goods, GoodsTypeId, GoodsId} ->
                    case lib_goods_util:get_goods_info(GoodsId, GoodsStatus#goods_status.dict) of
                        #goods{type = ?GOODS_TYPE_REVELATION} ->  %%天启装备特殊处理
                            case data_revelation_equip:get_equip(GoodsTypeId) of
                                #revelation_equip_cfg{star = Star} ->
                                    case lists:keyfind(Star, 1, SuitList) of
                                        {Star, Num} ->
                                            [{revelation_suit, GoodsTypeId,  GoodsId, Num} | AccList];
                                        _ ->
                                            [{revelation_suit, GoodsTypeId,  GoodsId, 0} | AccList]
                                    end;
                                _ ->
                                    [Arg | AccList]
                            end;
                        _ ->
                            [Arg | AccList]
                    end;
                {ng_boss_broadcast, Channel, SceneId, BossUId} ->
                    mod_night_ghost_local:boss_broadcast_reward(PS#player_status.id, Channel, SceneId, BossUId),
                    [Arg | AccList];
                _ ->
                    [Arg | AccList]
            end
        end,
    lists:reverse(lists:foldl(F, [], Args)).
