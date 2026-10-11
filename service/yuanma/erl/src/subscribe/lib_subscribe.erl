%% ---------------------------------------------------------------------------
%% @doc lib_subscribe.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-03-05
%% @deprecated 订阅
%% ---------------------------------------------------------------------------
-module(lib_subscribe).

-include("server.hrl").
-include("subscribe.hrl").
-include("predefine.hrl").
-include("common.hrl").

-export([format_unixtime_to_utf8/0, format_unixtime_to_utf8/1]).

%% 深海订阅例子
%% https://mixsdk.921.com/package/query/package_code/P0006365/type/send_subscribe_message?sh_uid=42985912&template_id=bc748bae8d6eab1ca65a4f786385b665&data[离线收益][value]=339208499&data[奖励内容][value]=奖励内容&data[通知日期][value]=通知日期

% -ifdef(DEV_SERVER).
% %% 配置
% get_url(?SUBSCRIBE_TYPE_SHENHAI) -> "https://mixsdk.921.com/package/query/package_code/P0006365/type/send_subscribe_message?";
% get_url(_) -> [].
% -else.
% %% 配置
% get_url(?SUBSCRIBE_TYPE_SHENHAI) -> "https://mixsdk.921.com/package/query/package_code/P0006365/type/send_subscribe_message?";
% get_url(_) -> [].
% -endif.

% %% 获取订阅
% get_subscribe_type(RoleId) ->
%     case db_role_subscribe_select(RoleId) of
%         [] -> 0;
%         [SubscribeType] -> SubscribeType
%     end.

% %% 登出
% logout(#player_status{accname = Accname, subscribe_type = SubscribeType} = Player, LogNorlOrErr, LastLogoutTime) ->
%     case lists:member(SubscribeType, ?SUBSCRIBE_TYPE_LIST) of
%         true -> mod_subscribe:set_subscribe_type(SubscribeType, Accname, LastLogoutTime);
%         false -> skip
%     end,
%     case LogNorlOrErr == ?LOGOUT_LOG_ONHOOK orelse LogNorlOrErr == ?LOGOUT_LOG_AGENT_ONHOOK of
%         true -> lib_subscribe_api:send_subscribe_of_onhook(Player);
%         false -> skip
%     end,
%     ok.

% %% 延迟登出
% delay_stop(#player_status{accname = Accname, subscribe_type = SubscribeType}, LastLogoutTime) ->
%     case lists:member(SubscribeType, ?SUBSCRIBE_TYPE_LIST) of
%         true -> mod_subscribe:set_subscribe_type(SubscribeType, Accname, LastLogoutTime);
%         false -> skip
%     end,
%     ok.

% get_template_id_by_subscribe_type(Type) ->
%     if
%         Type =:= ?SUBSCRIBE_TYPE_ACT ->
%             1;
%         true ->
%             0
%     end.

% get_subscribe_type_by_template_id(TemplateId) ->
%     if
%         TemplateId =:= 1 ->
%             ?SUBSCRIBE_TYPE_ACT;
%         true ->
%             ?SUBSCRIBE_TYPE_NONE
%     end.

%% 格式化输出时间
format_unixtime_to_utf8() -> format_unixtime_to_utf8(utime:unixtime()).
format_unixtime_to_utf8(UnixTime) ->
    {{Y,Month,D},{H,M,S}} = utime:unixtime_to_localtime(UnixTime),
    Time = lists:flatten(io_lib:format("~2..0w:~2..0w:~2..0w", [H, M, S])),
    Date = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w", [Y, Month, D])),
    Date ++ " " ++ Time.

% %% 获取订阅信息
% db_role_subscribe_select(RoleId) ->
%     Sql = io_lib:format(?sql_role_subscribe_select, [RoleId]),
%     db:get_row(Sql).

% db_role_subscribe_replace(RoleId, SubscribeType) ->
%     Sql = io_lib:format(?sql_role_subscribe_replace, [RoleId, SubscribeType]),
%     db:execute(Sql).

% db_role_subscribe_delete(RoleId) ->
%     Sql = io_lib:format(?sql_role_subscribe_delete, [RoleId]),
%     db:execute(Sql).
