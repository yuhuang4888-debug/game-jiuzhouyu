%% ---------------------------------------------------------------------------
%% @doc lib_mail_api

%% @author hjh
%% @since  2016-11-18
%% @deprecated  邮件
%% ---------------------------------------------------------------------------

-module(lib_mail_api).

%% 游戏内部
-export([
        send_sys_mail/4
        , send_sys_mail_online_on_game/5
        , send_sys_mail_online_on_game/6
        , send_sys_mail_to_all_on_game/5
        , send_sys_mail_to_all_on_game/6
        , send_guild_mail/4
    ]).

%% php
-export([
        send_sys_mail/5
        , send_sys_mail_online/6
        , send_sys_mail_to_all/6
    ]).

-compile(export_all).

-include("mail.hrl").
-include("goods.hrl").

-include("common.hrl").

%% ---------------------------------------------------------------------------
%% @doc 发送系统邮件(PHP不能调用该函数)
-spec send_sys_mail(PlayerInfoList, Title, Content, CmAttachment) -> ok when
    PlayerInfoList      ::  list(), % 名字(string() | binary())列表、 角色Id列表
    Title               ::  list() | binary(),
    Content             ::  list() | binary(),
    CmAttachment        ::  list() | binary().  % {?TYPE_GOODS|?TYPE_GOOD|?TYPE_BGOLD|?TYPE_GCOIN, GoodsTypeId, Num}
                                                %

%%-----------------------------------------------------------------------------
send_sys_mail(PlayerInfoList, Title, Content, CmAttachment) ->
    lib_mail:send_sys_mail(PlayerInfoList, Title, Content, CmAttachment, ?SEND_LOG_TYPE_NO).

%% PHP调用需要把附件用 util:string_to_term/1 转化
%% @param CmAttachmentStr string() | "[]"
%% @param SendLogType 1:记录 0:不记录
send_sys_mail(PlayerInfoList, Title, Content, CmAttachmentStr, SendLogType) ->
    lib_mail:send_sys_mail(PlayerInfoList, Title, Content, util:string_to_term(CmAttachmentStr), SendLogType).

%% 根据条件发邮件给所有在线玩家(游戏内调用)
%% CmAttachment        ::  list() | binary().  % {?TYPE_GOODS|?TYPE_GOOD|?TYPE_BGOLD|?TYPE_GCOIN, GoodsTypeId, Num}
send_sys_mail_online_on_game(Title, Content, CmAttachment, Source, LevelLimit) ->
    send_sys_mail_online_on_game(Title, Content, CmAttachment, Source, LevelLimit, ?SEND_LOG_TYPE_NO).

%% CmAttachment        ::  list() | binary().  % {?TYPE_GOODS|?TYPE_GOOD|?TYPE_BGOLD|?TYPE_GCOIN, GoodsTypeId, Num}
send_sys_mail_online_on_game(Title, Content, CmAttachment, Source, LevelLimit, SendLogType) ->
    SourceBin = util:make_sure_binary(Source),
    case SourceBin =/= <<>> of
        true -> Sql = io_lib:format(?sql_role_id_by_source_and_onlineflag_and_lv, [SourceBin, 1, LevelLimit]);
        false -> Sql = io_lib:format(?sql_role_id_by_onlineflag_and_lv, [1, LevelLimit])
    end,
    case db:get_all(Sql) of
        [] ->
            ok;
        InfoList ->
            PlayerInfoList = lists:flatten(InfoList),
            lib_mail:send_sys_mail(PlayerInfoList, Title, Content, CmAttachment, SendLogType)
    end.

%% 根据条件发邮件给所有在线玩家(PHP调用)
%% @param CmAttachmentStr string() | "[]"
send_sys_mail_online(Title, Content, CmAttachmentStr, Source, LevelLimit, SendLogType) ->
    send_sys_mail_online_on_game(Title, Content, util:string_to_term(CmAttachmentStr), Source, LevelLimit, SendLogType).

%% 根据条件发邮件给所有玩家(游戏内调用)
%% CmAttachment        ::  list() | binary().  % {?TYPE_GOODS|?TYPE_GOOD|?TYPE_BGOLD|?TYPE_GCOIN, GoodsTypeId, Num}
send_sys_mail_to_all_on_game(Title, Content, CmAttachment, Source, LevelLimit) ->
    send_sys_mail_to_all_on_game(Title, Content, CmAttachment, Source, LevelLimit, ?SEND_LOG_TYPE_NO).

%% CmAttachment        ::  list() | binary().  % {?TYPE_GOODS|?TYPE_GOOD|?TYPE_BGOLD|?TYPE_GCOIN, GoodsTypeId, Num}
send_sys_mail_to_all_on_game(Title, Content, CmAttachment, Source, LevelLimit, SendLogType) ->
    SourceBin = util:make_sure_binary(Source),
    case SourceBin =/= <<>> of
        true-> Sql = io_lib:format(?sql_role_id_by_source_and_lv, [SourceBin, LevelLimit]);
        false -> Sql = io_lib:format(?sql_role_id_by_lv, [LevelLimit])
    end,
    case db:get_all(Sql) of
        [] -> ok;
        InfoList ->
            PlayerInfoList = lists:flatten(InfoList),
            lib_mail:send_sys_mail(PlayerInfoList, Title, Content, CmAttachment, SendLogType)
    end.

%% 根据条件发邮件给所有玩家(PHP调用)
%% @param CmAttachmentStr string() | "[]"
send_sys_mail_to_all(Title, Content, CmAttachmentStr, Source, LevelLimit, SendLogType) ->
    send_sys_mail_to_all_on_game(Title, Content, util:string_to_term(CmAttachmentStr), Source, LevelLimit, SendLogType).

%% 发送公会邮件
send_guild_mail(PlayerInfoList, Title, Content, CmAttachment) ->
    lib_mail:send_guild_mail(PlayerInfoList, Title, Content, CmAttachment).