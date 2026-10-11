%% ---------------------------------------------------------------------------
%% @doc lib_game.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-01-13
%% @deprecated 游戏基础相关
%% ---------------------------------------------------------------------------
-module(lib_game).
-compile(export_all).

-include("server.hrl").
-include("game.hrl").
-include("php.hrl").
-include("clusters.hrl").
-include("daily.hrl").
-include("common.hrl").
-include("def_module.hrl").

make_record(setting, [Type, Subtype, IsOpen]) ->
    #setting{
        key = {Type, Subtype}
        , type = Type
        , subtype = Subtype
        , is_open = IsOpen
    }.

login_setting(#player_status{id = RoleId} = Player) ->
    % 加载默认配置
    CfgList = [tuple_to_list(T)||T<-data_setting:get_values()],
    % 数据库
    SqlList = db_player_setting_select(RoleId),
    F = fun(T, Map) ->
        Setting = make_record(setting, T),
        maps:put(Setting#setting.key, Setting, Map)
    end,
    SettingMap = lists:foldl(F, maps:new(), CfgList++SqlList),
    StatusSetting = #status_setting{setting_map = SettingMap},
    Player#player_status{setting = StatusSetting}.

setting_is_open(Player, Type, Subtype) ->
    #player_status{setting = StatusSetting} = Player,
    #status_setting{setting_map = SettingMap} = StatusSetting,
    #setting{is_open = SettingValue} = maps:get({Type, Subtype}, SettingMap, #setting{is_open = 0}),
    SettingValue > 0.

db_player_setting_select(RoleId) ->
    Sql = io_lib:format(?sql_player_setting_select, [RoleId]),
    db:get_all(Sql).

db_player_setting_replace(RoleId, Setting) ->
    #setting{type = Type, subtype = Subtype, is_open = IsOpen} = Setting,
    Sql = io_lib:format(?sql_player_setting_replace, [RoleId, Type, Subtype, IsOpen]),
    db:execute(Sql).

%% 发送每个功能的分服情况
send_zone_mod(Player) ->
    #player_status{sid = Sid} = Player,
    case ets:lookup(ets_server_zone_mod, zone_mod) of
        [{zone_mod, ZoneModData}] ->
            BinData = lib_clusters_node_api:pack_10200(ZoneModData),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            skip
    end.

%% 获取开服合服时间
%% 注意:客户端记录上一次接受本协议时间，并根据当前接受本次协议时间来判断某些事件是否重新请求游戏数据
send_game_info(Player) ->
    OpenTime = util:get_open_time(),
    MergeTime = util:get_merge_time(),
    MergeStartTime = util:get_merge_day_start_time(),
    MergeCount = util:get_merge_count(),
    %% ServerLv = util:get_server_lv(),
    {ok, BinData} = pt_102:write(10201, [OpenTime, MergeTime, MergeStartTime, MergeCount, utime:longunixtime()]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 错误码发送
send_error(#player_status{sid = SId}, Code) ->
    send_error_to_sid(SId, Code);
send_error(SId, Code) when is_pid(SId) ->
    send_error_to_sid(SId, Code);
send_error(UId, Code) when is_integer(UId) ->
    send_error_to_uid(UId, Code).

send_error_to_sid(Sid, Code) ->
    {ok, BinData} = make_error_bin_data(Code),
    lib_server_send:send_to_sid(Sid, BinData).

send_error_to_uid(Uid, Code) ->
    {ok, BinData} = make_error_bin_data(Code),
    lib_server_send:send_to_uid(Uid, BinData).

make_error_bin_data(Code) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
    pt_102:write(10205, [ErrorCodeInt, ErrorCodeArgs]).

%% 错误码发送
send_error(#player_status{sid = SId}, Pt, Code) ->
    send_error_to_sid(SId, Pt, Code);
send_error(SId, Pt, Code) when is_pid(SId) ->
    send_error_to_sid(SId, Pt, Code);
send_error(UId, Pt, Code) when is_integer(UId) ->
    send_error_to_uid(UId, Pt, Code).

send_error_to_sid(Sid, Pt, Code) ->
    {ok, BinData} = make_error_bin_data(Pt, Code),
    lib_server_send:send_to_sid(Sid, BinData).

send_error_to_uid(Uid, Pt, Code) ->
    {ok, BinData} = make_error_bin_data(Pt, Code),
    lib_server_send:send_to_uid(Uid, BinData).

make_error_bin_data(Pt, Code) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
    pt_102:write(10206, [Pt, ErrorCodeInt, ErrorCodeArgs]).

%% 服启动日志
log_server_open(ServerStatus, ServerType, BeginTime) ->
    Node = node(),
    ServerId = config:get_server_id(),
    ServerNum = config:get_server_num(),
    Platform = config:get_platform(),
    EndTime = utime:unixtime(),
    CostTime = EndTime - BeginTime,
    lib_log_api:log_server_open(ServerStatus, ServerType, Node, ServerId, ServerNum, Platform, BeginTime, EndTime, CostTime),
    ok.

%% 抽取副本用到的设置
get_dungeon_role_setting(StatusSetting) ->
    #status_setting{setting_map = SettingMap} = StatusSetting,
    SettingType = ?SYS_SETTING,
    F = fun(K, V, FunSettingMap) ->
        if
            K =:= {SettingType, ?PICK_UP_BLUE} ->
                maps:put(K, V, FunSettingMap);
            K =:= {SettingType, ?PICK_UP_PURPLE} ->
                maps:put(K, V, FunSettingMap);
            K =:= {SettingType, ?PICK_UP_ORANGE} ->
                maps:put(K, V, FunSettingMap);
            true -> FunSettingMap
        end
    end,
    maps:fold(F, #{}, SettingMap).

%% 是否禁止聊天
is_ban_chat() ->
    case lib_vsn:is_cn() of
        true ->
            Now = utime:unixtime(),
            case data_key_value:get(8) of
                [{StartTime, EndTime}] ->
                    StartTime =< Now andalso Now =< EndTime;
                _ -> false
            end;
        _ ->
            false
    end.

is_ban_rename() ->
    case lib_vsn:is_cn() of
        true ->
            Now = utime:unixtime(),
            case data_key_value:get(9) of
                [{StartTime, EndTime}] ->
                    StartTime =< Now andalso Now =< EndTime;
                _ -> false
            end;
        _ ->
            false
    end.

%% ============================ Sys Game Fun ==============================
%% php输出端口情况
php_output_port() ->
    PortCount = erlang:system_info(port_count),
    PortLimit = erlang:system_info(port_limit),
    #{port_count => PortCount, port_limit => PortLimit, node => node()}.

%% 端口数量上报
report_port_limit() ->
    PortCount = erlang:system_info(port_count),
    PortLimit = erlang:system_info(port_limit),
    case PortCount >= PortLimit*0.8 of
        true ->
            report_send_mail(PortCount, PortLimit),
            report_to_feishu(PortCount, PortLimit);
        false ->
            skip
    end,
    ok.

-ifdef(DEV_SERVER).
monitor_midnight_timer() -> skip.
-else.
monitor_midnight_timer() ->
    monitor_timer(?TWELVE).
-endif.

-ifdef(DEV_SERVER).
monitor_4_timer() -> skip.
-else.
monitor_4_timer() ->
    monitor_timer(?FOUR).
-endif.

monitor_timer(Type) ->
    Sql = io_lib:format(<<"select `time` from `log_server_daily_clear` where log_type = ~p order by id desc limit 1">>, [Type]),
    IsSatisfy = util:get_open_day() >= 2,
    IsExecute =
        case db:get_row(Sql) of
            [LastExeTime] ->
                utime:is_same_day(LastExeTime, utime:unixtime());
            _ -> false
        end,
    if
        not IsSatisfy -> skip;
        IsExecute -> skip;
        true ->
            Content0 = io_lib:format(<<"异常信息:\r\n \t~p点定时器执行异常,请及时处理！！"/utf8>>, [Type]),
            Content = format_feishu_msg(Content0),
            report_to_feishu(Content)
    end.

%% 发邮件
report_send_mail(PortCount, PortLimit) ->
    % http://notice.suyougame.com/api/send/181?check_time=xxx&check_sign=xxx&gid=0&platform=xxx&server=xxx&num=xxx&max=xxx appkey = Z8OeN87ysiRZvNteFGirbIDrrAqG3x1k; check_time是当前秒级时间戳,gid固定为0 check_sign=md5(181+check_time+appkey);
    GUrl = "http://notice.suyougame.com/api/send/181?",
    AppKey = "Z8OeN87ysiRZvNteFGirbIDrrAqG3x1k",
    NowTime = utime:unixtime(),
    AuthStr = util:md5(lists:concat([181, NowTime, AppKey])),
    Platform = config:get_platform(),
    ServerNum = config:get_server_num(),
    UrlParms = mochiweb_util:urlencode([
        {check_time, NowTime}, {check_sign, AuthStr}, {gid, 0}, {platform, Platform},
        {server, ServerNum}, {num, PortCount}, {max, PortLimit}
    ]),
    Url = lists:concat([GUrl, UrlParms]),
    mod_php:request_get(Url, #php_request{}).

%% 发飞书
report_to_feishu(PortCount, PortLimit) ->
    Content0 = io_lib:format(<<"异常信息:\r\n \t端口数据异常！！端口限制为~p，现已达到~p,请及时处理！！"/utf8>>, [PortLimit, PortCount]),
    Content = format_feishu_msg(Content0),
    report_to_feishu(Content).
report_to_feishu(Content) ->
    % http://notice.suyougame.com/api/send/chats_msg/jzy?check_time=xxx&check_sign=xxx&gid=0&content=xxx&chats_mark=xxx  appkey = nZ7pGb39yY1ypkp5BTrbAO*sR0i%dL28; check_time是当前秒级时间戳,gid固定为0 check_sign=md5('chats_msg'+check_time+appkey);chats_msg是字符串;chats_mark是群聊标识
    GUrl = "http://notice.suyougame.com/api/send/chats_msg/jzy?",
    AppKey = "nZ7pGb39yY1ypkp5BTrbAO*sR0i%dL28",
    NowTime = utime:unixtime(),
    AuthStr = util:md5(lists:concat(['chats_msg', NowTime, AppKey])),
    ChatsMark = "exception_monitor",
    UrlParams = mochiweb_util:urlencode([
        {check_time, NowTime}, {check_sign, AuthStr}, {gid, 0},
        {content, Content}, {chats_mark, ChatsMark}
    ]),
    Url = lists:concat([GUrl, UrlParams]),
    mod_php:request_get(Url, #php_request{}).

format_feishu_msg(List) ->
    Begin = "========================================\r\n",
    End = "\r\n========================================",
    list_to_binary([Begin, get_server_info_msg()|List] ++ [End]).

get_server_info_msg() ->
    Platform = config:get_platform(),
    ServerNum = config:get_server_num(),
    ServerId = config:get_server_id(),
    Cls = case util:is_cls() of true -> <<"跨服"/utf8>> ; _ -> <<"非跨服"/utf8>> end,
    io_lib:format(<<"服务器信息：\r\n \t平台：~s，服编号：~p，服唯一ID：~p，节点：~s (~s) \r\n \r\n "/utf8>>,
        [Platform, ServerNum, ServerId, node(), Cls]).

