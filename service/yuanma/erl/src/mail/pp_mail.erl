%% ---------------------------------------------------------------------------
%% @doc pp_mail.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-01-13
%% @deprecated 邮件协议处理
%% ---------------------------------------------------------------------------
-module(pp_mail).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("mail.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("def_fun.hrl").

%% 获得邮件列表
%% 注意:其他地方有直接调用 handle(19001,..) , 如果返回值改成是 #player_status{} 则需要注意修改
handle(19001, #player_status{id = RoleId, sid = Sid}, []) ->
    MailList = lib_mail:get_sub_effect_mail_list(RoleId),
    F = fun(Mail) ->
        #mail{id = MailId, type = Type, state = State, title = Title, time = Time, effect_et = EffectEt} = Mail,
        IsAttach = lib_mail:is_attach(Mail),
        {MailId, Type, State, Title, IsAttach, Time, EffectEt}
    end,
    List = [F(T)||T<-MailList],
    {ok, BinData} = pt_190:write(19001, [List]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 获得邮件详细信息
handle(19002, #player_status{id = RoleId, sid = Sid}, [MailId]) ->
    case lib_mail:get_mail(RoleId, MailId) of
        {false, ErrorCode} ->
            lib_mail:send_error_code(Sid, ErrorCode);
        {ok, Mail} ->
            #mail{id = MailId, state = State, sname = SName, title = Title, content = Content, cm_attachment = CmAttachment, time = Time} = Mail,
            F = fun(T, Acc) ->
                case T of
                    {ObjectType, Id, Num} ->
                        [{ObjectType, Id, Num, []}|Acc];
                    {?TYPE_ATTR_GOODS, Id, Num, ExtraAttr} ->
                        case lists:keyfind(extra_attr, 1, ExtraAttr) of
                            {extra_attr, AttrList} ->
                                [{?TYPE_GOODS, Id, Num, data_attr:unified_format_extra_attr(AttrList, [])}|Acc];
                            _ -> [{?TYPE_GOODS, Id, Num, []}|Acc]
                        end;
                    _ -> Acc
                end
            end,
            NewCmAttachment = lists:foldl(F, [], CmAttachment),
            IsReceive = ?IF(State == ?MAIL_STATE_HAS_RECEIVE, 1, 0),
            {ok, BinData} = pt_190:write(19002, [MailId, SName, Title, Content, NewCmAttachment, Time, IsReceive]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 删除邮件
handle(19003, Player, [DelMailIds]) ->
    NewDelMailIds = lists:usort(DelMailIds),
    {Code, RealDelIds} = lib_mail:delete_mail_by_mail_ids(Player#player_status.id, NewDelMailIds),
    {ok, BinData} = pt_190:write(19003, [Code, RealDelIds]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 提取附件
handle(19005, Player, [MailIds]) ->
    NewMailIds = lists:usort(MailIds),
    lib_mail:extract_attachment_by_mail_ids(Player, NewMailIds);

%% 发送公会邮件
handle(19006, Player, [Title, Content]) ->
    case lib_mail:send_guild_mail_on_server(Player, Title, Content) of
        {false, ErrorCode} -> NewPlayer = Player;
        {ok, NewPlayer} -> ErrorCode = ?SUCCESS
    end,
    {ok, BinData} = pt_190:write(19006, [ErrorCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 获得邮件基本信息
handle(19007, #player_status{id = RoleId, sid = Sid}, [MailId]) ->
    case lib_mail:get_mail(RoleId, MailId) of
        {false, ErrorCode} ->
            lib_mail:send_error_code(Sid, ErrorCode);
        {ok, Mail} ->
            #mail{id = MailId, type = Type, state = State, title = Title, time = Time, effect_et = EffectEt} = Mail,
            IsAttach = lib_mail:is_attach(Mail),
            {ok, BinData} = pt_190:write(19007, [MailId, Type, State, Title, IsAttach, Time, EffectEt]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 邮件通知
handle(19008, Player, []) ->
    lib_mail:send_mail_notice(Player#player_status.id);

% %% 公会邮件发送次数
% handle(19009, Player, []) ->
%     SendGuildMailNum = mod_daily:get_count(Player#player_status.id, ?MOD_MAIL, ?DAILY_SEND_GUILD_MAIL),
%     Limit = mod_daily:get_limit_by_type(?MOD_MAIL, ?DAILY_SEND_GUILD_MAIL),
%     LeftNum = max(Limit - SendGuildMailNum, 0),
%     {ok, BinData} = pt_190:write(19009, [LeftNum]),
%     lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 处理玩家反馈信息
handle(19010, Player, [Content]) ->
    Unixtime = utime:unixtime(),
    % 200字
    CheckContentLen = util:check_length(Content, 400),
    case CheckContentLen == false of
        true ->
            {ok, BinData} = pt_190:write(19010, [?ERRCODE(err190_feedback_not_valid)]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
        false ->
            TimeS = get(send_to_feedback_time),
            Res = case TimeS =:= undefined orelse (TimeS + 30 < Unixtime) of
                true ->
                    NewContent = lib_mail:replace_illegal_word(Content),
                    #player_status{id = RoleId, figure = #figure{name = Name}, ip = Ip} = Player,
                    Server = atom_to_list(node()),
                    Sql = io_lib:format(?sql_feedback_insert, [RoleId, util:make_sure_binary(Name), util:make_sure_binary(NewContent), Unixtime, Ip, Server]),
                    db:execute(Sql),
                    put(send_to_feedback_time, Unixtime),
                    ?SUCCESS;
                false ->
                    ?ERRCODE(err190_on_feedback_cd)
            end,
            {ok, BinData} = pt_190:write(19010, [Res]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end;

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.
