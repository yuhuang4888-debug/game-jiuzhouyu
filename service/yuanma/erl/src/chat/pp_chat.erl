%%%--------------------------------------
%%% @Module  : pp_chat
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.05.06
%%% @Description:  聊天功能
%%%                内容驱动，内容可以推送到任意频道
%%%--------------------------------------
-module(pp_chat).
-export([handle/3]).

-include("server.hrl").
-include("chat.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("role.hrl").
-include("def_vip.hrl").
-include("def_event.hrl").
-include("errcode.hrl").
-include("guild.hrl").


-define(VOICE_MAX_SIZE, 95030).       %% 语音信息最大数 65535*1.5
-define(PICTURE_MAX_SIZE, 204800).    %% 图片最大大小   200K

%% 文字信息
handle(11001, Status, [Channel, Province, City, ReceiveId, Msg, ArgsStr, TkTime, Ticket]) when is_list(Msg), is_list(ArgsStr) ->
    #player_status{server_num = ServerNum, c_server_msg = CServerMsg, server_id = SerId, server_name = ServerName, id = Id, figure = Figure, sid = Sid, guild = GuildStatus, scene =  SceneId} = Status,
    #figure{gm = GM, lv = Lv, name = Name} = Figure,
    IsAr = lib_vsn:is_ar(),
    IsBanChat = lib_game:is_ban_chat(),
    %% 检查是否能聊天
    case lib_chat:check_talk_text_condition(Status, Channel, TkTime, Ticket, Msg) of
        _ when IsBanChat andalso Channel =/= ?CHAT_CHANNEL_REPLY ->
            lib_chat:send_error_code(Sid, ?ERRCODE(err110_update_chat_system));
        {fail, ErrorCode} -> lib_chat:send_error_code(Sid, ErrorCode);
        true ->
            [Count, Status1]  = lib_chat:record_content(Status, Msg),
            if
                Count == 1 ->
                    lib_chat:send_error_code(Sid, ?ERRCODE(err110_content_repeat)),
                    {ok, Status1};
                true ->
                    MsgSend = case GM == 1 of
                        true ->
                            lib_word:filter_text_gm(Msg);
                        _ ->
                            RePattern = ["|", "\\*", "|", "%", "|", "&", "|", [194,160]],  %% %% [194,160] 是客户端对空格的特殊转义
                            MsgRe = re:replace(Msg, RePattern, "", [global, {return, list}]),
                            % 毛**泽**东,过滤中间符号的字符串(操作后的字符串:毛泽东),如果还有敏感词则用处理后的字符串再次屏蔽
                            case mod_word:word_is_sensitive(MsgRe) of
                                true -> lib_word:filter_text(MsgRe, Lv);
                                false -> lib_word:filter_text(Msg, Lv)
                            end
                    end,
                    TempNewArgs = case util:string_to_term(ArgsStr) of
                        undefined -> [];
                        Args -> Args
                    end,
                    %% 参数检测
                    ArgsResult = lib_chat:check_talk_args(Status, TempNewArgs),
                    %%TempNewArgs 参数特殊处理
                    DoArgs = lib_chat:handle_chat_args(TempNewArgs, Status),
                    %% 检查聊天禁言
                    IsTalkLim = lib_chat:check_talk_lim(Status, Channel, TkTime, Ticket),

                    NowTime = utime:unixtime(),
                    ChatContent = ?CHAT_CONTENT_TEXT,
                    DoArgsStr = util:term_to_string(DoArgs),
                    case Channel of
                        ?CHAT_CHANNEL_PRIVATE ->
                            case lib_role:get_role_show(ReceiveId) of
                                [] -> ReceiveFigure = #figure{};
                                #ets_role_show{figure = ReceiveFigure} -> ok
                            end,
                            _ReveivName = ReceiveFigure#figure.name,
                            ChatTimeLineArgs = [Id, Name, Lv, Figure#figure.vip, ReceiveId, ReceiveFigure#figure.vip],
                            ChatTimeLineArgs2 = [Id, Name, Lv, Figure#figure.vip, ReceiveId, ReceiveFigure#figure.vip, ReceiveFigure#figure.lv],
                            PackData = [Channel, ServerNum, SerId, ServerName, [{Id, Figure}, {ReceiveId, ReceiveFigure}], MsgSend, DoArgsStr, ArgsResult, NowTime],
                            {ok, BinData} = pt_110:write(11002, PackData),
                            % 聊天信息
                            Chat = lib_chat:make_record(chat_11002, [Channel, ChatContent, ServerNum, SerId, ServerName, Id, Figure, ReceiveId, ReceiveFigure,
                                MsgSend, DoArgsStr, ArgsResult, NowTime]);
                        ?CHAT_CHANNEL_HORN ->
                            ChatTimeLineArgs = [Id, Name, Lv, Figure#figure.vip],
                            ChatTimeLineArgs2 = [Id, Name, Lv, Figure#figure.vip],
                            _ReveivName = <<>>,
                            PackData = [Channel, ServerNum, SerId, ServerName, Province, City, ReceiveId, Id, Figure, MsgSend, DoArgsStr, ArgsResult, NowTime],
                            {ok, BinData} = pt_110:write(11029, PackData),
                            % 聊天信息
                            Chat = lib_chat:make_record(chat_11029, [Channel, ChatContent, ServerNum, SerId, ServerName, Province, City, ReceiveId, Id, Figure,
                                MsgSend, DoArgsStr, ArgsResult, NowTime]);
                        _ ->
                            ChatTimeLineArgs = [Id, Name, Lv, Figure#figure.vip],
                            ChatTimeLineArgs2 = [Id, Name, Lv, Figure#figure.vip],
                            _ReveivName = <<>>,
                            PackData = [Channel, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, MsgSend, DoArgsStr, ArgsResult, NowTime],
                            {ok, BinData} = pt_110:write(11001, PackData),
                            % 聊天信息
                            Chat = lib_chat:make_record(chat_11001, [Channel, ChatContent, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, MsgSend,
                                DoArgsStr, ArgsResult, NowTime])
                    end,
                    if
                        IsTalkLim ->
                            %% 答题频道特殊处理, 答案对了，则不屏蔽，答案错了，屏蔽
                            if
                                Channel == ?CHAT_CHANNEL_REPLY ->
                                    ActScene = data_guild_feast:get_cfg(scene_id),
                                    case SceneId == ActScene  of   %%  lib_guild_feast:is_open() andalso
                                        true ->
                                            IsAnswer = mod_guild_feast_mgr:quiz_answer(Id, Name,  Status#player_status.figure, GuildStatus#status_guild.id,  GuildStatus#status_guild.name, {Msg, MsgSend}, 2),
                                            case IsAnswer of
                                                {0, false} ->
                                                    lib_server_send:send_to_sid(Sid, BinData);
                                                _ ->
                                                    PackDataRaw = [Channel, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, Msg, DoArgsStr, ArgsResult, NowTime],
                                                    {ok, NewBinData} = pt_110:write(11001, PackDataRaw),
                                                    {ok, NewStatus} = lib_chat:send_text_msg(Status, ChatContent, Channel, ReceiveId, Chat, NewBinData),
                                                    chat_monitor_agent:role_chat(Status, Channel, Msg, utime:longunixtime(), []),
                                                    lib_player_info_report:chat_report(Status, Channel, Msg, utime:longunixtime(),
                                                        [{chat_to_id, ReceiveId}, {chat_to_name, _ReveivName}], ChatTimeLineArgs2),
                                                    if
                                                        IsAr -> %% 中东特殊需求，只针对屏蔽词进行屏蔽
                                                            catch lib_chat:sensitive_word_forbid(Id, Msg);
                                                        true ->
                                                            catch lib_chat:update_role_chat_time_line(Channel, NowTime, ChatTimeLineArgs)
                                                    end,
                                                    {ok, NewStatus}
                                            end;
                                        false ->
                                            lib_server_send:send_to_sid(Sid, BinData)
                                    end;
                                true ->
                                    lib_server_send:send_to_sid(Sid, BinData)
                            end;
                        GM == 1 -> lib_chat:send_msg(ChatContent, Channel, Status, ReceiveId, Chat, BinData);
                        true ->
                            case Channel == ?CHAT_CHANNEL_REPLY of
                                true ->
                                    ActScene = data_guild_feast:get_cfg(scene_id),
                                    case SceneId == ActScene  of   %%  lib_guild_feast:is_open() andalso
                                        true ->
                                            IsAnswer = mod_guild_feast_mgr:quiz_answer(Id, Name,  Status#player_status.figure, GuildStatus#status_guild.id,  GuildStatus#status_guild.name, {Msg, MsgSend}, 2),
                                            if
                                                IsAnswer == {0, false} -> NewBinData = BinData;
                                                true ->
                                                    PackDataRaw = [Channel, ServerNum, CServerMsg, SerId, ServerName, Province, City, Id, Figure, Msg, DoArgsStr, ArgsResult, NowTime],
                                                    {ok, NewBinData} = pt_110:write(11001, PackDataRaw)
                                            end;
                                        false ->
                                            NewBinData = BinData
                                    end;
                                false ->
                                    NewBinData = BinData
                            end,
                            {ok, NewStatus} = lib_chat:send_text_msg(Status, ChatContent, Channel, ReceiveId, Chat, NewBinData),
                            if
                                %% 特定的频道不用监控
                                Channel == ?CHAT_CHANNEL_WAIT_TEAM -> skip;
                                true ->
                                    ToRoleInfo = get_to_role_info(Channel, ReceiveId),
                                    chat_monitor_agent:role_chat(Status, Channel, Msg, utime:longunixtime(), ToRoleInfo),
                                    lib_player_info_report:chat_report(Status, Channel, Msg, utime:longunixtime(),
                                        [{chat_to_id, ReceiveId}, {chat_to_name, _ReveivName}], ChatTimeLineArgs2)
                            end,
                            if
                                IsAr -> %% 中东特殊需求，只针对屏蔽词进行屏蔽
                                    catch lib_chat:sensitive_word_forbid(Id, Msg);
                                true ->
                                    catch lib_chat:update_role_chat_time_line(Channel, NowTime, ChatTimeLineArgs)
                            end,
                            {ok, NewStatus}
                    end
            end
    end;

%% 发送语音聊天
handle(11003, Status, [Channel, ReceiveId, VoiceMsgTime, TkTime, Ticket, DataSend, VoiceText, ClientAutoId, IsEnd]) ->
    #player_status{
        server_num = ServerNum,
        server_id = SerId,
        server_name = ServerName,
        id    = Id,
        figure = Figure,
        sid = Sid,
        client_ver = ClientVer
    } = Status,
    #figure{lv = Lv, name = Name} = Figure,
    IsAr = lib_vsn:is_ar(),
    IsBanChat = lib_game:is_ban_chat(),
    IsCanSend = case IsEnd == 1 of
        true ->
            case lib_chat:check_talk_condition(Status, Channel, TkTime, Ticket) of
                _ when IsBanChat -> lib_chat:send_error_code(Sid, ?ERRCODE(err110_update_chat_system));
                {fail, ErrorCode} -> lib_chat:send_error_code(Sid, ErrorCode);
                true ->
                    case lib_chat:check_send_msg(Status, Channel, ReceiveId) of
                        {false, ErrorCode} -> lib_chat:send_error_code(Sid, ErrorCode);
                        _ -> true
                    end
            end;
        false -> true
    end,
    case IsEnd of
        0 -> %% 语音还没有传送完毕, 先存储一部分到玩家进程，等待下一部分
            {NewDataSend, NewVoiceText}
                = case get(process_dict_voice_data) of
                      undefined ->
                          {DataSend, list_to_binary(VoiceText)};
                      {LastSendData, LastVoiceText} ->
                          {list_to_binary([LastSendData, DataSend]), list_to_binary([LastVoiceText, VoiceText])}
                  end,
            case byte_size(NewDataSend) > ?VOICE_MAX_SIZE orelse byte_size(NewVoiceText) > ?VOICE_MAX_SIZE of
                true -> %% 语音已经超过限制
                    erase(process_dict_voice_data),
                    ok;
                false ->
                    put(process_dict_voice_data, {NewDataSend, NewVoiceText}),
                    %% 告诉客户端语音分部传送成功,可以传下一分部了
                    {ok, BinData} = pt_110:write(11012, [1]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        1 when IsCanSend==true ->  %% 语音传送完毕
            case get(process_dict_voice_data) of
                undefined ->
                    FinDataSend     = DataSend,
                    FinVoiceText    = VoiceText;
                {LastSendData, LastVoiceText} ->
                    FinDataSend     = list_to_binary([LastSendData,  DataSend]),
                    FinVoiceText    = list_to_binary([LastVoiceText, VoiceText])
            end,

            erase(process_dict_voice_data),
            %% ?INFO("process_dict_voice_data 1 FinDataSend:~p ~n", [byte_size(FinDataSend)]),
            mod_chat_voice:send_voice(Id, ClientAutoId, FinDataSend, FinVoiceText),
            lib_player_event:async_dispatch(Id, ?EVENT_CHAT_VOICE),
            NowTime = utime:unixtime(),
            ArgsResult = ?CHAT_ARGS_RESULT_NO,
            ArgsStr = util:term_to_string([]),
            ChatContent = ?CHAT_CONTENT_VOICE,
            case Channel == ?CHAT_CHANNEL_PRIVATE andalso ReceiveId > 0 of
                true ->
                    case lib_role:get_role_show(ReceiveId) of
                        [] -> ReceiveFigure = #figure{};
                        #ets_role_show{figure = ReceiveFigure} -> ok
                    end,
                    _ReveivName = ReceiveFigure#figure.name,
                    ChatTimeLineArgs = [Id, Name, Lv, Figure#figure.vip, ReceiveId, ReceiveFigure#figure.vip],
                    ChatTimeLineArgs2 = [Id, Name, Lv, Figure#figure.vip, ReceiveId, ReceiveFigure#figure.vip, ReceiveFigure#figure.lv],
                    PlayerList = [{Id, Figure}, {ReceiveId, ReceiveFigure}],
                    % 聊天信息
                    Chat = lib_chat:make_record(chat_11003, [Channel, ChatContent, ServerNum, SerId, ServerName, Id, Figure,
                        ReceiveId, ReceiveFigure, FinVoiceText, ArgsStr, ArgsResult, NowTime, ClientAutoId, VoiceMsgTime]);
                false ->
                    _ReveivName = <<>>,
                    ChatTimeLineArgs = [Id, Name, Lv, Figure#figure.vip],
                    ChatTimeLineArgs2 = [Id, Name, Lv, Figure#figure.vip],
                    PlayerList = [{Id, Figure}],
                    % 聊天信息
                    Chat = lib_chat:make_record(chat_11003, [Channel, ChatContent, ServerNum, SerId, ServerName, Id, Figure,
                        0, #figure{}, FinVoiceText, ArgsStr, ArgsResult, NowTime, ClientAutoId, VoiceMsgTime])
            end,
            List = [Channel, ServerNum, SerId, ServerName, PlayerList, ClientVer, ClientAutoId, ReceiveId, FinVoiceText, VoiceMsgTime, NowTime],
            {ok, BinData} = pt_110:write(11003, List),
            case lib_chat:check_talk_lim(Status, Channel, TkTime, Ticket) of
                true -> lib_server_send:send_to_sid(Sid, BinData);
                false ->
                    if
                        IsAr ->  %% 中东特殊需求，只针对屏蔽词进行屏蔽
                            skip;
                        true ->
                            catch lib_chat:update_role_chat_time_line(Channel, NowTime, ChatTimeLineArgs)
                    end,
                    lib_chat:send_msg(ChatContent, Channel, Status, ReceiveId, Chat, BinData),
                    %% 聊天监控
                    ToRoleInfo = get_to_role_info(Channel, ReceiveId),
                    chat_monitor_agent:role_chat(Status, Channel, FinVoiceText, utime:longunixtime(), ToRoleInfo),
                    lib_player_info_report:chat_report(Status, Channel, FinVoiceText, utime:longunixtime(),
                                        [{chat_to_id, ReceiveId}, {chat_to_name, _ReveivName}], ChatTimeLineArgs2)
            end;
        _ ->
            erase(process_dict_voice_data),
            ok
    end;

%% 获取语音信息
handle(11004, Status, [ClientAutoId, PlayerId, TkTime, Ticket]) ->
    #player_status{sid=Sid} = Status,
    case util:check_char_encrypt(PlayerId, TkTime, Ticket) of
        false -> skip;
        true -> mod_chat_voice:get_voice_data(PlayerId, ClientAutoId, Sid)
    end;

%% 上传语音翻译文字信息
handle(11005, Status, [Channel, ReceiveId, ClientAutoId, VoiceTextData]) ->
    #player_status{id=Id, sid=Sid} = Status,
    mod_chat_voice:send_voice_text(Id, ClientAutoId, Sid, VoiceTextData),
    lib_chat:send_voice_text(Status, Channel, ReceiveId, ClientAutoId, VoiceTextData),
    ok;

%% 获取语音文字内容
handle(11006, Status, [ClientAutoId, PlayerId]) ->
    #player_status{id=_Id, sid=Sid} = Status,
    mod_chat_voice:get_voice_text_data(PlayerId, ClientAutoId, Sid),
    ok;

%% 私聊缓存
handle(11010, Status, [Channel]) ->
    #player_status{id = RoleId, server_id = ServerId, guild = GuildStatus} = Status,
    #status_guild{id = GuildId} = GuildStatus,
    OpenDay = util:get_open_day(),
    if
        Channel == ?CHAT_CHANNEL_WORLD ->
            mod_chat_cache:send_cache(Channel, RoleId, node());
        Channel == ?CHAT_CHANNEL_GUILD andalso GuildId > 0 ->
            mod_chat_cache:send_cache({Channel, GuildId}, RoleId, node());
        Channel == ?CHAT_CHANNEL_PRIVATE ->
            mod_chat_cache:send_cache(Channel, RoleId, node());
        % 大于1天才能获取
        Channel == ?CHAT_CHANNEL_ZONE andalso OpenDay > 1 ->
            mod_clusters_node:apply_cast(mod_chat_cache, send_cache, [Channel, ServerId, RoleId, node()]);
        Channel == ?CHAT_CHANNEL_NG ->
            mod_chat_cache:send_cache(Channel, RoleId, node());
        true ->
            skip
    end;

%% 世界聊天的次数
handle(11011, Status, []) ->
    lib_chat:send_world_channel_left_count(Status);

%% 小红点
handle(11016, Status, [ModuleId, Type]) ->
    lib_chat:send_red_point(Status, ModuleId, Type);

%% 帮派求助
handle(11022, Status, [BossType, KillId, KillName]) ->
    #player_status{id = RoleId, server_id = ServerId, scene = Scene, x = X, y = Y, figure = Figure} = Status,
    InBoss = lib_boss:is_in_all_boss(Scene),
    InEudemonsLand = lib_eudemons_land:is_in_eudemons_boss(Scene),
    if
        Figure#figure.guild_id == 0 -> skip;
        InBoss ->
            SceneName = lib_scene:get_scene_name(Scene),
            lib_chat:send_TV({guild, Figure#figure.guild_id}, ?MOD_BOSS, 4,
                             [Figure#figure.name, RoleId, SceneName, KillName, KillId, Scene, X, Y, BossType]);
        InEudemonsLand ->
            SceneName = lib_scene:get_scene_name(Scene),
            KServerId = if
                            KillId == 0 -> 0;
                            true -> mod_player_create:get_real_serid_by_id(KillId)
                        end,
            lib_chat:send_TV({guild, Figure#figure.guild_id}, ?MOD_EUDEMONS_BOSS, 4,
                             [Figure#figure.name, RoleId, ServerId, SceneName, KillName, KillId, KServerId, Scene, X, Y, BossType]);
        true ->
            skip
    end;

%% 是否开启小跨服聊天
handle(11023, Status, []) ->
    lib_chat:send_zone_chat_info(Status#player_status.server_id, Status#player_status.id);

%% 上传物品数据到跨服
handle(11025, Status, [Channel, IdList]) ->
    lib_chat:add_goods_info_list(Status, Channel, IdList);

%% 跨服查看物品
handle(11026, Status, [Channel, GoodsId]) ->
    mod_clusters_node:apply_cast(mod_kf_chat, send_goods_info, [node(), Status#player_status.id, Channel, GoodsId]);

%% 点击聊天缓存
handle(11027, Status, [Channel, ClickRoleId]) ->
    #player_status{id = RoleId} = Status,
    if
        Channel == ?CHAT_CHANNEL_PRIVATE ->
            mod_chat_cache:click_cache(Channel, RoleId, ClickRoleId);
        true ->
            skip
    end;

%% 查看私聊的玩家信息
handle(11028, Status, [RoleId]) ->
    #player_status{sid = Sid, id = MyRoleId} = Status,
    case lib_role:get_role_show(RoleId) of
        #ets_role_show{figure = Figure, combat_power = CombatPower, online_flag = OnlineFlag} ->
            [{_, _, Intimacy}] = lib_relationship_api:get_rela_and_intimacy_online(MyRoleId, [RoleId]),
            ?PRINT("RoleId:~p ~n", [{RoleId, Figure, CombatPower, OnlineFlag, Intimacy}]),
            {ok, BinData} = pt_110:write(11028, [?SUCCESS, RoleId, Figure, CombatPower, OnlineFlag, Intimacy]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            {ok, BinData} = pt_110:write(11028, [?FAIL, RoleId, #figure{}, 0, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 禁言
handle(11040, Status, [Uid, LimitTime]) ->
    case Status#player_status.figure#figure.gm of
        1-> %是GM
            Result = lib_chat:forbid_chat([Uid], LimitTime, 1);
        _-> %非GM
            Result = 0
    end,
    {ok, BinData} = pt_110:write(11040, [Result]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData);

%% 解除禁言
handle(11041, Status, [Uid]) ->
    case Status#player_status.figure#figure.gm of
        1-> %是GM
            Result = lib_chat:release_chat([Uid], 1);
        _-> %非GM
            Result = 0
    end,
    {ok, BinData} = pt_110:write(11041, [Result]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData);

%% 获取禁言信息
handle(11043, Status, [Uid]) ->
    case mod_chat_agent:lookup(Status#player_status.id) of
        [] ->
            ok;
        [_Player] ->
            [Talk_lim, _Talk_lim_time, _Talk_lim_right] = lib_chat:get_talk_lim(Uid),
            {ok, BinData} = pt_110:write(11043, Talk_lim),
            lib_server_send:send_to_sid(Status#player_status.sid, BinData)
    end;

%% 聊天举报
handle(11044, Status, [TargetId]) ->
    Now = utime:unixtime(),
    Time = lib_chat:get_time(?CHAT_CHANNEL_INFORM),
    IsAr = lib_vsn:is_ar(),
    case Now - Time < ?CHAT_GAP_INFORM of
        true ->
            skip;
        false ->
            case mod_chat_agent:lookup(Status#player_status.id) of
                [] ->
                    ok;
                [_Player] ->
                    lib_chat:put_time(?CHAT_CHANNEL_INFORM, Time),
                    %% 是否为好友，是的话返回true
                    Is_friends = lib_relationship:is_in_friend(Status#player_status.pid, Status#player_status.id, TargetId),
                    case Is_friends of
                        true -> ReturnCode = 2;
                        false ->
                            case lib_chat:is_pay(TargetId) of
                                true ->
                                    ReturnCode = 1;
                                false ->
                                    if
                                        IsAr -> %% 中东特殊需求，只针对屏蔽词进行屏蔽
                                            skip;
                                        true ->
                                    Count = mod_chat_forbid:inform_chat(Status#player_status.id, TargetId),
                                    case Count>?ALLOW_INFORM_NUM andalso lib_chat:is_chat_forbid(TargetId) =/=true of
                                        true -> lib_chat:forbid_chat([TargetId],2,4);
                                        false -> skip
                                            end
                                    end,
                                    ReturnCode = 1
                            end
                    end,
                    {ok, BinData} = pt_110:write(11044, [ReturnCode]),
                    lib_server_send:send_to_sid(Status#player_status.sid, BinData)
            end
    end;

%% 聊天举报
%% mod_server设置每2秒才能处理一次该协议
handle(11045, Status, [TargetId, TargetData]) when is_list(TargetData)->
    ESC_CHARS = ["'" , "|", "\""],    %% 影响SQL语句的非法字符
    NewTargetData1 = re:replace(TargetData, ESC_CHARS, "*", [global, {return, list}]),
    NewTargetData2 = case length(NewTargetData1) =< 300 of
                         true -> NewTargetData1;
                         false -> []
                     end,
    %% 防止在线多次举报同一个玩家
    case get(talk_report_list) of
        undefined -> TalkReportList = [];
        TalkReportList -> ok
    end,
    case mod_chat_agent:lookup(TargetId) of
        [] -> Res = 0;
        [_Player] ->
            IsReported = lists:member(TargetId, TalkReportList),
            case Status#player_status.id /= TargetId andalso IsReported == false of
                true ->
                    TargetData_Bin = list_to_binary(NewTargetData2),
                    SQL1 = io_lib:format(?SQL_TALK_REPORT, [Status#player_status.id, TargetId, TargetData_Bin]),
                    db:execute(SQL1),
                    SQL2 = io_lib:format(<<"update player_login set talk_reported_count = talk_reported_count + 1 where `id` = ~p">>,
                                         [TargetId]),
                    db:execute(SQL2),
                    NewTalkReportList = lists:sublist([TargetId|TalkReportList], 50),   %% 最多保留五十个id
                    put(talk_report_list, NewTalkReportList),
                    Res = 1;
                false -> Res = 0
            end
    end,
    {ok, BinData} = pt_110:write(11045, [Res]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData);

%% 发送公告
handle(11050, Status, []) ->
    lib_chat:chat_11050_help(Status#player_status.sid);

%% 假人聊天触发
handle(11064, Status, []) ->
    lib_chat:send_robot_chat_info(Status);

%% 聊天监控动态包编号
handle(11065, Status, [PkgCode]) ->
    NewStatus = Status#player_status{sh_monitor_pkg = PkgCode},
    {ok, BinData} = pt_110:write(11065, [?SUCCESS]),
    lib_server_send:send_to_sid(Status#player_status.sid, BinData),
    {ok, NewStatus};

%% 暂时不开启,开启要测试
% %% 发送图片
% handle(11082, Status, [Channel, ReceiveId, IsEnd, TkTime, Ticket, TinyPicture, RealPicture]) ->
%     #player_status{
%        id          = Id,
%        figure      = Figure,
%        sid         = Sid
%       } = Status,

%     case IsEnd of
%         0 -> %% 图片还没有传送完毕, 先存储一部分到玩家进程，等待下一部分
%             {NewTinyPicture, NewRealPicture}
%                 = case get(process_dict_picture_data) of
%                       undefined ->
%                           {TinyPicture, RealPicture};
%                       {PreTinyPicture, PreRealPicture} ->
%                           {list_to_binary([PreTinyPicture, TinyPicture]), list_to_binary([PreRealPicture, RealPicture])}
%                   end,

%             case byte_size(NewTinyPicture) > ?PICTURE_MAX_SIZE orelse byte_size(NewRealPicture) > ?PICTURE_MAX_SIZE of
%                 true -> %% 图片已经超过限制
%                     erase(process_dict_picture_data),
%                     ok;
%                 false ->
%                     put(process_dict_picture_data, {NewTinyPicture, NewRealPicture}),
%                     %% 告诉客户端图片分部传送成功,可以传下一分部了
%                     {ok, BinData} = pt_110:write(11083, 1),
%                     lib_server_send:send_to_sid(Sid, BinData)
%             end;

%         1 ->  %% 图片传送完毕
%             case get(process_dict_picture_data) of
%                 undefined ->
%                     FinTinyPicture = TinyPicture,
%                     FinRealPicture = RealPicture;
%                 {PreTinyPicture, PreRealPicture} ->
%                     FinTinyPicture = list_to_binary([PreTinyPicture, TinyPicture]),
%                     FinRealPicture = list_to_binary([PreRealPicture, RealPicture])
%             end,

%             erase(process_dict_picture_data),

%             case lib_chat:check_talk_condition(Status, Channel, TkTime, Ticket) of
%                 {fail, _ErrorCode} -> skip;
%                 true  ->
%                     TmpAutoId = case get(process_dict_auto_picture_id) of
%                                     undefined -> mod_daily:get_count(Status#player_status.dailypid, Id, 7000202);
%                                     AutoId    -> AutoId
%                                 end,
%                     NewAutoId = case TmpAutoId >= 99 of
%                                     true  -> 1;
%                                     false -> TmpAutoId + 1
%                                 end,
%                     SaveAutoId = Id*100 + NewAutoId,
%                     put(process_dict_auto_picture_id, NewAutoId),
%                     Data = [Channel, Id, Figure, SaveAutoId, ReceiveId, FinTinyPicture],
%                     mod_chat_voice:send_picture(SaveAutoId, FinRealPicture),
%                     {ok, BinData} = pt_110:write(11082, Data),
%                     mod_daily:set_count(Status#player_status.dailypid, Id, 7000202, NewAutoId),
%                     case lib_chat:check_talk_lim(Status, Channel, TkTime, Ticket) of
%                         true  -> lib_server_send:send_to_sid(Sid, BinData);
%                         false -> lib_chat:send_msg(?CHAT_CONTENT_PICTURE, Channel, Status, ReceiveId, Data, BinData)
%                     end
%             end;
%         _ -> %% 容错,无视错误的标志位
%             skip
%     end;

% %% 获取图片内容
% handle(11083, Status, [AutoId, TkTime, Ticket]) ->
%     #player_status{id=Id, sid=Sid} = Status,
%     case util:check_char_encrypt(Id, TkTime, Ticket) of
%         false ->
%             skip;
%         true ->
%             mod_chat_voice:get_picture_data(AutoId, Sid)
%     end;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_chat no match"}.

%% ================================== private fun ==========================================

%% 获取聊天对象的形象信息
%% @return {ReceiveId, #figure{}}
get_to_role_info(?CHAT_CHANNEL_PRIVATE, ReceiveId) ->
    RecvFigure = lib_role:get_role_figure(ReceiveId),
    {ReceiveId, RecvFigure};
get_to_role_info(_, _ReceiveId) ->
    {0, #figure{}}.