%%% -------------------------------------------------------
%%% @author
%%% @doc
%%% date 2017-05-16
%%% 聊天监控代理
%%% 收集玩家的聊天信息，并向PHP聊天监控系统发送内容
%%% @end
%%% -------------------------------------------------------
-module(chat_monitor_agent).
-behaviour(gen_server).

%% API
-export([start_link/0 , role_chat/4, role_chat/5, reload/0]).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("server.hrl").
-include("chat.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("team.hrl").

-define(SERVER,   ?MODULE).
-define(CHECK_TIME, 10000).         % 检测重试及清理超时消息
-define(MAX_TRY_TIMES,  3).         % 重试次数限制

-define(STATE_WAIT_REPONSE, 0).     % 等待响应状态
-define(STATE_GOT_REPONSE,  1).     % 已获得响应状态

%% 缓存key
-define(CHAT_KEY(ReqId), {chat, ReqId}).
-define(URL_ID(ReqId),           ReqId).
-define(LOG_KEY(Id),         {log, Id}).

-define(SAVE_TIME, 60000).          % 写入聊天日志的时间
-define(SAVE_ONCE_NUM, 30).         % 单次写入DB最大数量

%% 远程监控

%% 查询中心存储的数据量信息
%% http://123.206.98.92:1220/?name=bfqs&opt=status&auth=Kiw861HbqsgPoqay27J

%% 分不同版本渠道监控:URL
%% sy
-define(SY_URL1, "http://123.206.98.92:9888/yy25dlaya/put?auth=Ks9maj2hXa"). % 旧的
-define(SY_URL2, "http://mqapi.suyougame.com/chat/jzy").
-define(SY_URL, [{1, ?SY_URL1}, {2, ?SY_URL2}]).
%% ml
-define(ML_URL, "http://gamechat.manlinggame.com/Log/Chat/20047").
%% sh
-define(SH_URL, "https://rh.diaigame.com/package/query/package_code/{1}/type/uploadChat").
%% Key
-define(M_KEY(X), 40435880 bxor (X rem 1000000)).
%% debug
-define(IS_DEBUG,   0).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

reload() ->
    gen_server:cast(?SERVER, {reload}).

%% 角色发送聊天内容
role_chat(Player, ChatType, Msg, ChatTime) ->
    role_chat(Player, ChatType, Msg, ChatTime, []).

-ifdef(DEV_SERVER).
role_chat(_, _, _, _, _) ->
    ignore.
-else.
%% ChatTime是毫秒
role_chat(Ps, ChatType, Msg, ChatTime, ToRoleInfo) when Msg =/= <<>> andalso Msg =/= "" ->
    Msg2 = re:replace(Msg, ["<#f_[0-9]{1,3}>", "|", "[[0-9]{10,13}]", "|", "<color@[1-9]><a@scene3.*</color>"], "", [global, {return, list}]),
    case Msg2 =/= <<>> andalso Msg2 =/= "" of
        true ->
            DefChatInfo = trans_to_chat_info(default, Ps, ChatType, Msg, ChatTime, ToRoleInfo),
            MlChatInfo = trans_to_chat_info("ml", Ps, ChatType, Msg, ChatTime, ToRoleInfo),
            gen_server:cast(?SERVER, {role_chat, DefChatInfo, MlChatInfo});
        _ ->
            ignore
    end;
role_chat(_, _, _, _, _) ->
    ignore.

%% 组织监控信息
%% sy, shenhai
trans_to_chat_info(default, Ps, Channel, Msg, ChatTime, ToRoleInfo) ->
    #player_status{id = RoleId, figure = Figure, source = Source,
        accname = AccName, ip = IP, sh_monitor_pkg = ShMonitorPkg,
        platform = Platform, server_id = SerId, server_name = SerName,
        scene = SceneId, combat_power = Power, team = Team,
        reg_server_id = RegServerId} = Ps,
    #figure{name = Name, lv = Lv, vip = Vip, career = Career,
        guild_id = GuildId, guild_name = GuildName} = Figure,
    #status_team{team_id = TeamId} = Team,
    % 发送信息玩家
    FromRole = #role_chat_info{
        accname = AccName, role_id = RoleId, name = Name,
        reg_server_id = RegServerId, platform = util:make_sure_binary(Platform),
        server_id = SerId, server_name = util:make_sure_binary(SerName),
        level = Lv, vip = Vip, career = Career, power = Power, address = util:make_sure_binary(IP),
        guild_id = GuildId, guild_name = GuildName, scene_id = SceneId,
        recharge = lib_recharge_data:get_total_rmb(RoleId),
        team_id = TeamId
    },
    % 聊天信息
    DefChatInfo = #chat_info{
        channel = Channel,
        source = util:make_sure_binary(Source),
        content = util:make_sure_binary(Msg),
        sh_monitor_pkg = ShMonitorPkg,
        time = round(ChatTime/1000),
        from_role = FromRole
    },
    case Channel of
        ?CHAT_CHANNEL_PRIVATE ->
            {ToRoleId, ToFigure} = ToRoleInfo,
            #figure{name = ToName, lv = ToLv, vip = ToVip, career = ToCareer,
                guild_id = ToGuildId, guild_name = ToGuildName} = ToFigure,
            % 私聊玩家
            ToRole = #role_chat_info{role_id = ToRoleId,
                name = ToName, level = ToLv, vip = ToVip, career = ToCareer,
                guild_id = ToGuildId, guild_name = ToGuildName},
            DefChatInfo#chat_info{to_role = ToRole};
        ?CHAT_CHANNEL_INFORM ->
            {ToRoleId, _ToFigure} = ToRoleInfo,
            DefChatInfo#chat_info{to_role = #role_chat_info{role_id = ToRoleId}};
        _ ->
            DefChatInfo#chat_info{to_role = #role_chat_info{}}
    end;
%% ml
trans_to_chat_info("ml", Ps, Channel, Msg, ChatTime, ToRoleInfo) ->
    DefChatInfo = trans_to_chat_info(default, Ps, Channel, Msg, ChatTime, ToRoleInfo),
    DefChatInfo#chat_info{time = ChatTime};
%% 容错
trans_to_chat_info(Platform, Ps, Channel, Msg, ChatTime, ToRoleInfo) ->
    trans_to_chat_info(Platform, Ps, Channel, Msg, ChatTime, ToRoleInfo).

-endif.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    LogToMonitor =  lib_vsn:is_chat_monitor(),
    Database = unicode:characters_to_binary(config:get_mysql(db_name)),
    {ok, #monitor_state{database = Database, log_to_monitor = LogToMonitor}}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast({reload}, State) ->
    NewState = State#monitor_state{log_to_monitor = lib_vsn:is_chat_monitor()},
    {noreply, NewState};

%% 远程记录聊天记录
handle_cast({role_chat, DefChatInfo, MlChatInfo}, State) ->
    #monitor_state{timer_check = TimerCheck, database = Database,
                   log_to_monitor = LogToMonitor, timer_log = TimerLog, log_id = LogId} = State,
    case LogToMonitor of
        true  ->
            try
                Platform = config:get_platform(),
                % ?PRINT("Chat platform ~p~n", [Platform]),
                send_to_monitor_all(Platform, Database, DefChatInfo, MlChatInfo)
            catch _:_ ->
                    ?ERR("chat info ~w,~n ~w,~n ~p", [DefChatInfo, MlChatInfo, erlang:get_stacktrace()]),
                    ignore
            end;
        false ->
            ignore
    end,

    %% 定时器检查请求是否返回
    case is_reference(TimerCheck) orelse (not LogToMonitor) of
        true  -> NewTimerCheck =  TimerCheck;
        false -> NewTimerCheck =  erlang:start_timer(?CHECK_TIME, self(), timer_check)
    end,

    %% 定时器检查是否因为丢失写如本地数据库
    case is_reference(TimerLog) of
        true  -> NewTimerLog =  TimerLog;
        false -> NewTimerLog =  erlang:start_timer(?SAVE_TIME, self(), timer_log)
    end,

    %% 日志id
    case LogId + 1 > 10000000 of
        true  -> NewLogId =  1;
        false -> NewLogId =  LogId + 1
    end,
    %% 优先记录sy聊天
    log_chat_cache(NewLogId, DefChatInfo),
    {noreply, State#monitor_state{timer_check = NewTimerCheck, timer_log = NewTimerLog, log_id = NewLogId}};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({http, ReplyInfo}, State) ->
    ?MYLOG("chat", "ReplyInfo:~p ~n", [ReplyInfo]),
    http_reply(ReplyInfo),
    {noreply, State};

%% 检查是否需要重新请求
handle_info({timeout, TimerCheck, timer_check}, State = #monitor_state{timer_check = TimerCheck}) ->
    CheckRet = monitor_timer_check(),
    case CheckRet of
        [] ->
            {noreply, State#monitor_state{timer_check = undefined}};
        _ ->
            NewTimerCheck = erlang:start_timer(?CHECK_TIME, self(), timer_check),
            {noreply, State#monitor_state{timer_check = NewTimerCheck}}
    end;

handle_info({timeout, TimerLog, timer_log}, State = #monitor_state{timer_log = TimerLog}) ->
    save_log(),
    {noreply, State#monitor_state{timer_log = undefined}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    save_log(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 聊天监控触发
send_to_monitor_all("mlly", Database, DefChatInfo, MlChatInfo)->
    send_to_monitor_ml(?ML_URL, Database, MlChatInfo),
    send_to_monitor_sy(?SY_URL, Database, DefChatInfo);
send_to_monitor_all("ml", Database, DefChatInfo, MlChatInfo)->
    send_to_monitor_ml(?ML_URL, Database, MlChatInfo),
    send_to_monitor_sy(?SY_URL, Database, DefChatInfo);
send_to_monitor_all("shenhai", Database, DefChatInfo, _MlChatInfo) ->
    #chat_info{sh_monitor_pkg = ShMonitorPkg} = DefChatInfo,
    case ShMonitorPkg of
        undefined -> skip;
        _ ->
            Url = uio:format(?SH_URL, [ShMonitorPkg]),
            % ?PRINT("shenhai chat monitor url:~p~n", [Url]),
            send_to_monitor_sh(Url, Database, DefChatInfo)
    end,
    send_to_monitor_sy(?SY_URL, Database, DefChatInfo);
%% 其他情况都是sy监控
send_to_monitor_all(_, Database, DefChatInfo, _MlChatInfo) ->
    %% send_to_monitor_ml(?ML_URL, Database, _MlChatInfo),
    send_to_monitor_sy(?SY_URL, Database, DefChatInfo).

%% ================================= manling版本监控 =================================
get_chat_channel_data(#chat_info{channel = Channel, from_role = FromRole, to_role = ToRole}) ->
    if
        Channel =:= ?CHAT_CHANNEL_WORLD ->
            <<"世界"/utf8>>;
        Channel =:= ?CHAT_CHANNEL_GUILD ->
            #role_chat_info{guild_id = GId, guild_name = GName} = FromRole,
            uio:format("{1}_{2}_{3}", [<<"公会"/utf8>>, GId, GName]);
        Channel =:= ?CHAT_CHANNEL_PRIVATE ->
            #role_chat_info{role_id = CId, name = CName} = ToRole,
            uio:format("{1}_{2}_{3}", [<<"私聊"/utf8>>, CId, CName]);
        true -> %% 默认场景
            #role_chat_info{scene_id = SceneId} = FromRole,
            uio:format("{1}_{2}", [<<"场景"/utf8>>, SceneId])
    end.

%% 发送监控请求
send_to_monitor_ml(Url, _Database, ChatInfo) ->
    #chat_info{
       content = Content, time = ChatTime, from_role = FromRole
    } = ChatInfo,
    #role_chat_info{
        accname = AccName, role_id = RoleId, name = RoleName,
        server_id = ServerId, server_name = ServerName,
        level = RoleLv, vip = Vip, address = Ip, recharge = Recharge
    } = FromRole,
    %% 地址参数固定为get传输
    %% 数据内容固定以POST方式传输（不带参数名，直接整个内容体POST）
    %% 必须先调用iolist_to_binary，将iolist转换一遍（扁平化）
    %% 否则mochiweb_util:quote_plus/1时，碰到list的元素为list时会匹配报错
    %% JsonPostData = iolist_to_binary(mochijson2:encode(PostData)),
    ChatChannelData = get_chat_channel_data(ChatInfo),
    PostData =[{vcode, ?M_KEY(ChatTime)}, {debug, ?IS_DEBUG},
               {userId, AccName}, {level, RoleLv},
               {roleId, RoleId}, {roleName, RoleName},
               {serverName, ServerName}, {serverId, ServerId},
               {vipLevel, Vip}, {recharge, round(Recharge)}, {chatTime, ChatTime},
               {chatTo, util:make_sure_binary(ChatChannelData)}, {ip, Ip}, {content, Content}],
    EncodeParams = mochiweb_util:urlencode(PostData),
    case do_request(Url, EncodeParams) of
        error -> ok;
        RequestId ->
            put_request_info(RequestId, 1, 1, ?STATE_WAIT_REPONSE, ChatTime, EncodeParams, Url),
            ok
    end.

%% ================================= suyou版本监控 =================================
gen_ext_data(#chat_info{channel = Channel, from_role = FromRole, to_role = ToRole}) ->
    if
        Channel =:= ?CHAT_CHANNEL_SCENE ->
            #role_chat_info{scene_id = SceneId} = FromRole,
            [{<<"scene">>, SceneId}];
        Channel =:= ?CHAT_CHANNEL_GUILD ->
            #role_chat_info{guild_id = GId, guild_name = GName} = FromRole,
            [{<<"guild_id">>, GId}, {<<"guild_name">>, GName}];
        Channel =:= ?CHAT_CHANNEL_PRIVATE ->
            #role_chat_info{role_id = ToId, name = ToName} = ToRole,
            [{<<"chat_uid">>, ToId}, {<<"chat_uname">>, ToName}];
        Channel =:= ?CHAT_CHANNEL_TEAM ->
            #role_chat_info{team_id = TeamId} = FromRole,
            [{<<"team_id">>, TeamId}];
        true ->
            []
    end.

send_to_monitor_sy([], _Database, _ChatInfo) -> ok;
send_to_monitor_sy([{1, Url} | Urls], Database, ChatInfo) ->
    #chat_info{
        channel = Channel, source = Source, content = Content, time = ChatTime,
        from_role = FromRole
    } = ChatInfo,
    #role_chat_info{
        accname = AccName, role_id = RoleId, name = RoleName, level = RoleLevel,
        vip = Vip, server_id = ServerId, reg_server_id = RegServerId, address = Address
    } = FromRole,
    %% 玩家基础信息
    BaseRoleData = [{<<"accname">>, AccName}, {<<"lv">>, RoleLevel}, {<<"vip">>, Vip},
                    {<<"time">>,ChatTime}, {<<"srvid">>, ServerId}, {<<"rsrvid">>, RegServerId}],
    ExtList  = gen_ext_data(ChatInfo),
    RoleData = BaseRoleData ++ ExtList,
    PostData = [{<<"source">>, Source},      {<<"role_id">>, RoleId},
                {<<"role_name">>, RoleName}, {<<"role_data">>, RoleData},
                {<<"type">>, Channel},      {<<"content">>, Content},
                {<<"server_db">>, Database}, {<<"ip">>, Address}],
    %% 地址参数固定为get传输
    %% 数据内容固定以POST方式传输（不带参数名，直接整个内容体POST）
    %% 必须先调用iolist_to_binary，将iolist转换一遍（扁平化）
    %% 否则mochiweb_util:quote_plus/1时，碰到list的元素为list时会匹配报错
    JsonPostData = iolist_to_binary(mochijson2:encode(PostData)),
    EncodeParams = lists:concat(["data=", mochiweb_util:quote_plus(JsonPostData)]),
    case do_request(Url, EncodeParams) of
        error -> ok;
        RequestId ->
            put_request_info(RequestId, 1, 1, ?STATE_WAIT_REPONSE, ChatTime, EncodeParams, Url),
            ok
    end,
    send_to_monitor_sy(Urls, Database, ChatInfo);
send_to_monitor_sy([{2, Url} | Urls], Database, ChatInfo) ->
    #chat_info{
        channel = Channel, source = Source, content = Content,
        time = _Time, from_role = FromRole, to_role = ToRole
    } = ChatInfo,
    #role_chat_info{
        accname = AccName, role_id = RoleId, name = Name,
        reg_server_id = RegServerId, level = Lv, vip = Vip,
        career = Career, power = Power, address = Ip,
        guild_id = GuildId, guild_name = GuildName
    } = FromRole,
    NowTime = utime:unixtime(),
    DateTime = utime:unixtime_to_localtime(NowTime),
    Date = utime:get_datetime_string(DateTime),
    SecretKey = "13D3D98D3A51DB4A1411EBFE2C2A31D4",
    Sign = util:md5(lists:concat([NowTime, SecretKey])),
    FromData = [{guild_id, GuildId}, {guild_name,  util:make_sure_binary(GuildName)}],
    JsonFromData = iolist_to_binary(mochijson2:encode(FromData)),
    PostData = [{channel, Channel}, {dbName, Database}, {source, Source},
        {content, util:make_sure_binary(Content)}, {regServerId, RegServerId},
        {fromUserId, util:make_sure_binary(AccName)}, {fromRoleId, RoleId},
        {fromRoleName, Name}, {fromLevel, Lv}, {fromVip, Vip}, {fromPower, Power},
        {fromCareer, Career}, {fromRoleData, JsonFromData},
        {date, util:make_sure_binary(Date)}, {time, NowTime}, {ip, Ip}, {sign, Sign}],
    NewPostData =
        case Channel of
            ?CHAT_CHANNEL_PRIVATE ->
                #role_chat_info{role_id = ToRoleId, name = ToName, level = ToLv,
                    vip = ToVip, career = ToCareer, power = ToPower,
                    guild_id = ToGuildId, guild_name = ToGuildName} = ToRole,
                ToData = util:term_to_string([{guild_id, ToGuildId}, {guild_name, ToGuildName}]),
                JsonToData = iolist_to_binary(mochijson2:encode(ToData)),
                [{toRoleId, ToRoleId}, {toRoleName, ToName}, {toLevel, ToLv},
                    {toVip, ToVip}, {toPower, ToPower}, {toCareer, ToCareer},
                    {toRoleData, JsonToData} | PostData];
            _ ->
                PostData
        end,
    % NewUrl = lists:concat([Url, ?GAME]),
    EncodeParams = mochiweb_util:urlencode(NewPostData),
    case do_request(Url, EncodeParams) of
        error -> ok;
        RequestId ->
            put_request_info(RequestId, 1, 1, ?STATE_WAIT_REPONSE, NowTime, EncodeParams, Url), ok
    end,
    send_to_monitor_sy(Urls, Database, ChatInfo).

%% ================================= shenhai版本监控 =================================

%% 发送监控请求
send_to_monitor_sh(Url, _Database, ChatInfo) ->
    #chat_info{
        channel = Channel, content = Content, time = ChatTime,
        from_role = FromRole, to_role = ToRole
    } = ChatInfo,
    #role_chat_info{
        role_id = RoleId, name = RoleName
    } = FromRole,
    #role_chat_info{
        role_id = ToRoleId, name = ToRoleName
    } = ToRole,
    %% 地址参数固定为get传输
    %% 数据内容固定以POST方式传输（不带参数名，直接整个内容体POST）
    %% 必须先调用iolist_to_binary，将iolist转换一遍（扁平化）
    %% 否则mochiweb_util:quote_plus/1时，碰到list的元素为list时会匹配报错
    %% JsonPostData = iolist_to_binary(mochijson2:encode(PostData)),
    PostData =[{from_uid, RoleId}, {from_role_name, RoleName},
               {type, Channel}, {to_uid, ToRoleId}, {to_role_name, ToRoleName},
               {content, Content}, {time, ChatTime}],
    EncodeParams = mochiweb_util:urlencode(PostData),
    case do_request(Url, EncodeParams) of
        error -> ok;
        RequestId ->
            put_request_info(RequestId, 1, 1, ?STATE_WAIT_REPONSE, ChatTime, EncodeParams, Url),
            ok
    end.

%% http请求
do_request(Url, EncodeParams) ->
    case httpc:request(post,
                       {Url, [], "application/x-www-form-urlencoded", EncodeParams},
                       [{timeout, 3000}], %% httpotion
                       [{sync, false}])   %% option
    of
        {ok, RequestId} ->
            ?PRINT("httpc ~p~n", [RequestId]),
            RequestId;
        {error, Reason} ->
            ?ERR("do httpc request error : ~w", [Reason]),
            error
    end.

%% 处理http回应
%% {http,      ReplyInfo}, ReplyInfo:
%% {RequestId, saved_to_file}
%% {RequestId, {error, Reason}}
%% {RequestId, Result}
%% {RequestId, stream_start, Headers}
%% {RequestId, stream_start, Headers, HandlerPid}
%% {RequestId, stream, BinBodyPart}
%% {RequestId, stream_end, Headers}
http_reply({RequestId, saved_to_file}) ->
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, {error, _Reason}}) ->
    case erlang:get(?CHAT_KEY(RequestId)) of
        undefined ->
            ignore;
        {TryTimes, _State, ChatTime, EncodeParams, Url} when TryTimes < ?MAX_TRY_TIMES ->
            UrlId = erlang:get(?URL_ID(RequestId)),
            put_request_info(RequestId, UrlId, TryTimes, ?STATE_GOT_REPONSE, ChatTime, EncodeParams, Url),
            ignore;
        _ ->
            erase_request_info(RequestId)
    end;
http_reply({RequestId, _Result}) ->
    %% 成功返回(有可能是返回失败的HTTP CODE，忽略结果)
    %% {_, _, Res} = _Result,
    %% io:format("~p ~p Res:~ts~n", [?MODULE, ?LINE, Res]),
    erase_request_info(RequestId),
    ok;
http_reply({RequestId, _, _}) ->
    erase_request_info(RequestId),
    ignore;
http_reply({RequestId, _, _, _}) ->
    erase_request_info(RequestId),
    ignore;
http_reply(_) ->
    ignore.

%% 放进请求次数
put_request_info(RequestId, UrlId, TryTimes, State, ChatTime, EncodeParams, Url) ->
    erlang:put(?CHAT_KEY(RequestId), {TryTimes, State, ChatTime, EncodeParams, Url}),
    erlang:put(?URL_ID(RequestId), UrlId).

erase_request_info(RequestId) ->
    erlang:erase(?CHAT_KEY(RequestId)),
    erlang:erase(?URL_ID(RequestId)).

%% 记录聊天数据到缓存，等待定期写入数据库
log_chat_cache(LogId, ChatInfo) ->
    erlang:put(?LOG_KEY(LogId), ChatInfo).

save_log() ->
    Keys = erlang:get_keys(),
    check_save_log(Keys, []).

%% 清除掉进程字典数据，同时收集起来统一保存
check_save_log([Key = {log, _Id} | Keys], LogChatList) ->
    case erlang:erase(Key) of
        #chat_info{} = ChatInfo -> check_save_log(Keys, [ChatInfo | LogChatList]);
        _ -> check_save_log(Keys, LogChatList)
    end;
check_save_log([_Key | Keys], LogChatList) -> check_save_log(Keys, LogChatList);
check_save_log([], _LogChatList) -> %% do_save_log(LogChatList).
    ok.

%% do_save_log([]) -> ok;
%% do_save_log(DataList) ->
%%     {PreList, TailList} = util:split(?SAVE_ONCE_NUM, DataList),
%%     try
%%         do_save_log_data(PreList)
%%     catch _ExType:_ExPattern ->
%%             ?ERR("Save log_chat error:~w", [{_ExType, _ExPattern, erlang:get_stacktrace()}])
%%     end,
%%     do_save_log(TailList).

%% do_save_log_data(DataList) ->
%%     DataString = util:join_bitstring([fmt_data_string(Data) || Data <- DataList,
%%                                       is_record(Data, chat_info)], <<",">>),
%%     case DataString =:= <<>> of
%%         true  -> ok;
%%         false ->
%%             Sql = util:fmt_bin("INSERT INTO log_chat (`role_id`,`name`,`level`,`vip_level`,`address`,
%%                                 `type`,`scene_id`,`guild_id`,`guild_name`,`chat_to_id`,`chat_to_name`,
%%                                 `content`,`ctime`) VALUES ~ts", [DataString]),
%%             %% ?INFO("sql:~ts", [Sql]),
%%             db:execute(Sql)
%%     end.

%% fmt_data_string(#chat_info{
%%                    id = Id, name = Name, scene_id = SceneId, level = Level, vip = VipLevel, address = Address,
%%                    guild_id = GuildId, guild_name = GuildName, chat_to_id = ChatToId, chat_to_name = ChatToName,
%%                    content = Content, type = ChatType, time = ChatTime
%%                   }) ->
%%     util:fmt_bin("(~w,~ts,~w,~w,'~s',~w,~w,~w,~ts,~w,~ts,~ts,~w)",
%%                  [Id, mysql:encode(Name), Level, VipLevel, Address, ChatType, SceneId,
%%                   GuildId, mysql:encode(GuildName), ChatToId,
%%                   mysql:encode(ChatToName), mysql:encode(Content), ChatTime
%%                  ]).

%% 超时请求检查
monitor_timer_check() ->
    Keys = erlang:get_keys(),
    do_monitor_timer_check(Keys, []).

do_monitor_timer_check([Key = {chat, OldReuestId} | Keys], AccList) ->
    case erlang:get(Key) of
        {TryTimes, _State, _ChatTime, _EncodeParams, _Url} when  TryTimes > ?MAX_TRY_TIMES  ->
            erase_request_info(OldReuestId),
            do_monitor_timer_check(Keys, AccList);
        {_TryTimes, ?STATE_WAIT_REPONSE, _ChatTime, _EncodeParams, _Url} ->
            do_monitor_timer_check(Keys, [Key|AccList]);
        {TryTimes, ?STATE_GOT_REPONSE, ChatTime, EncodeParams, Url} ->
            UrlId = erlang:get(?URL_ID(OldReuestId)),
            NewKey =
                try
                    case do_request(Url, EncodeParams) of
                        error -> undefined;
                        RequestId ->
                            case TryTimes >= ?MAX_TRY_TIMES of
                                true  -> undefined;
                                false ->
                                    put_request_info(RequestId, UrlId, TryTimes+1,
                                                     ?STATE_WAIT_REPONSE, ChatTime, EncodeParams, Url),
                                    ?CHAT_KEY(RequestId)
                            end
                    end
                catch _:_ ->
                        ?ERR("do_check [~s] : ~p", [EncodeParams, erlang:get_stacktrace()]),
                        undefined
                end,
            erase_request_info(OldReuestId),
            do_monitor_timer_check(Keys, [NewKey|AccList]);
        _ ->
            erase_request_info(OldReuestId),
            do_monitor_timer_check(Keys, AccList)
    end;
do_monitor_timer_check([_ | Keys], AccList) ->
    do_monitor_timer_check(Keys, AccList);
do_monitor_timer_check([], AccList) ->
    AccList.
