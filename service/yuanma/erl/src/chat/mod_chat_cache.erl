%% ---------------------------------------------------------------------------
%% @doc mod_chat_cache.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-13
%% @deprecated 聊天缓存
%% ---------------------------------------------------------------------------
-module(mod_chat_cache).

-behaviour(gen_server).

-export([
    save_cache/5
    , save_cache/4
    , send_cache/4
    , send_cache/3
    , delete_cache/2
    , delete_guild_cache/1
    , delete_public_cache_with_uid/1
    , click_cache/3
    , update_chat_cache_state/2]).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("chat.hrl").
-include("def_fun.hrl").
-include("figure.hrl").

-define(PRIV_CACHE_MAX_LEN, 200).       % 私人聊天缓存的最大长度
-define(PRIV_CACHE_CLEAR_MAX_LEN, 400). % 私人聊天缓存清理的最大长度 ?PRIV_CACHE_CLEAR_MAX_LEN的值要大于?PRIV_CACHE_MAX_LEN 避免达到最大长度之后每次都要去掉之前的聊天记录
-define(PRIV_CACHE_SINGLE_LEN, 20).     % 私人聊天单人最大的长度

-define(MAX_CACNE_LEN, 20).             % 聊天长度

%% 使用进程字典保存数据
%% 进程字典每个CacheType保存的数据结构： [{RoleId, Unixtime, BinData}, ...]

-record(state, {
        priv_cache_map = #{} % 私聊离线缓存 在线的私聊不做缓存 客户端自己存cookie #{ReceiverId => #priv_cache{}}
    }).

-record(priv_cache, {
    len = 0,
    msg = []
    }).


%% 保存聊天的缓存(部分频道是需要在跨服执行,比如分区频道)
save_cache(CacheType=?CHAT_CHANNEL_ZONE, ServerId, SenderId, ReceiveId, Chat) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    save_cache({CacheType, ZoneId}, SenderId, ReceiveId, Chat).

save_cache(CacheType, SenderId, ReceiveId, Chat) ->
    case is_valid_cache_type(CacheType) of
        true -> gen_server:cast(?MODULE, {'save_cache', CacheType, SenderId, ReceiveId, Chat});
        false -> ignore
    end.

%% 发送聊天的缓存(部分频道是需要在跨服执行,比如分区频道)
send_cache(CacheType=?CHAT_CHANNEL_ZONE, ServerId, RoleId, Node) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    send_cache({CacheType, ZoneId}, RoleId, Node).

send_cache(CacheType, RoleId, Node) ->
    case is_valid_cache_type(CacheType) of
        true -> gen_server:cast(?MODULE, {'send_cache', CacheType, RoleId, Node});
        false -> ignore
    end.

%%--------------------------------------------------
%% 删除缓存
%% @param  CacheType  ?CHAT_CHANNEL_WORLD|?CHAT_CHANNEL_PRIVATE|{?CHAT_CHANNEL_GUILD, GuildId}
%% @param  SpecifyIds 指定要删除相关内容的玩家id列表,[]表示直接删除这个聊天频道的聊天缓存
%% @return            description
%%--------------------------------------------------
delete_cache(CacheType, SpecifyIds) ->
    case is_valid_cache_type(CacheType) of
        true  -> gen_server:cast(?MODULE, {'delete_cache', CacheType, SpecifyIds});
        false -> ignore
    end.

delete_guild_cache(GuildIds) ->
    [delete_cache({?CHAT_CHANNEL_GUILD, GuildId}, []) || GuildId <- GuildIds, GuildId > 0].

delete_priv_cache_by_sender_id(SenderIds) ->
    gen_server:cast(?MODULE, {'delete_priv_cache_by_sender_id', SenderIds}).

%% -----------------------------------------------------------------
%% @desc   更新聊天缓存玩家形象信息
%% @param  RoleId       玩家Id
%% @param  UseDressList 装扮列表
%% @return
%% -----------------------------------------------------------------
update_chat_cache_state(RoleId, UseDressList) ->
    gen_server:cast(?MODULE, {'update_chat_cache_state', RoleId, UseDressList}).

%% 删除聊天缓存里面指定玩家的数据
delete_public_cache_with_uid([]) -> ignore;
delete_public_cache_with_uid(RoleIdList) when is_list(RoleIdList) ->
    delete_cache(?CHAT_CHANNEL_WORLD, RoleIdList),
    IdListString = util:link_list(RoleIdList),
    SqlGetGuildInfoList = io_lib:format("SELECT p.id,IFNULL(g.guild_id,0) FROM player_login p LEFT JOIN guild_member g ON p.id = g.id WHERE p.id IN (~s)", [IdListString]),
    InfoList = db:get_all(SqlGetGuildInfoList),
    [
        delete_cache({?CHAT_CHANNEL_GUILD, GuildId}, [Id || [Id, GuildIdX] <- InfoList, GuildIdX =:= GuildId])
        || [_, GuildId] <- InfoList, GuildId > 0
    ],
    delete_priv_cache_by_sender_id(RoleIdList),
    ok;
delete_public_cache_with_uid(_) -> error.

%% 点击缓存
%% (1)标识已读
click_cache(Channel, RoleId, ClickRoleId) ->
    gen_server:cast(?MODULE, {'click_cache', Channel, RoleId, ClickRoleId}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    % process_flag(trap_exit, true),
    {ok, #state{}}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, _From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        _ ->
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        _ ->
            {noreply, State}
    end.

do_handle_call(_Request, _From, State)->
    {reply, ok, State}.

do_handle_info(_Info, State) ->
    {noreply, State}.

%% 保存私聊的缓存
do_handle_cast({'save_cache', ?CHAT_CHANNEL_PRIVATE, SenderId, ReceiveId, Chat}, State) ->
    StateAfSender = add_priv_cache(State, SenderId, ReceiveId, Chat, ?CAHT_CACHE_IS_READ_YES),
    StateAfReceive = add_priv_cache(StateAfSender, ReceiveId, SenderId, Chat, ?CAHT_CACHE_IS_READ_NO),
    {noreply, StateAfReceive};
do_handle_cast({'save_cache', CacheType, SenderId, _ReceiveId, Chat}, State) ->
    Unixtime = utime:unixtime(),
    case get(CacheType) of
        CacheList when is_list(CacheList) ->
            NewCacheList = lists:sublist([{SenderId, Unixtime, Chat} | CacheList], ?MAX_CACNE_LEN);
        _ ->
            NewCacheList = [{SenderId, Unixtime, Chat}]
    end,
    DeleteTime = Unixtime - ?CHAT_CACHE_TIME_DELETE,
    %% 过滤掉24小时前的聊天记录
    FilterFun = fun({_SenderId, ChatTime, _Chat} = I) ->
        ChatTime > DeleteTime
    end,
    LastCacheList = lists:filter(FilterFun, NewCacheList),
    put(CacheType, LastCacheList),
    {noreply, State};

%% 获得聊天的缓存
do_handle_cast({'send_cache', ?CHAT_CHANNEL_PRIVATE, RoleId, _Node}, State) ->
    #state{priv_cache_map = CacheMap} = State,
    Map = maps:get(RoleId, CacheMap, #{}),
    F = fun(_, TCache, Acc) ->
        #priv_cache{msg = TMsgL} = TCache,
        [TMsgL|Acc]
    end,
    AllMsgL = maps:fold(F, [], Map),
    MsgListFlatten = lists:flatten(AllMsgL),
    F1 = fun(#chat{
            channel = Channel, sender_server_num = SenderServerNum, sender_server_id = SenderSerId, sender_server_name = SenderServerName,
            sender_c_server_msg = SenderCServerMsg, sender_id = SenderId, sender_figure = SenderFigure,
            receive_id = ReceiveId, receive_figure = ReceiveFigure, msg_send = MsgSend,
            args = Args, args_result = ArgsResult, utime = Utime, is_read = IsRead, voice_id = VoiceId, voice_time = VoiceTime}) ->
        {Channel,
            [{SenderServerNum, SenderCServerMsg, SenderSerId, SenderServerName, SenderId, SenderFigure},
                {SenderServerNum, SenderCServerMsg, SenderSerId, SenderServerName, ReceiveId, ReceiveFigure}
            ],
            MsgSend, Args, ArgsResult, Utime, IsRead, VoiceId, VoiceTime}
    end,
    List = lists:map(F1, MsgListFlatten),
    {ok, BinData} = pt_110:write(11010, [List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    % NewCacheMap = maps:remove(RoleId, CacheMap),
    % NewState = State#state{priv_cache_map = NewCacheMap},
    {noreply, State};
do_handle_cast({'send_cache', CacheType, RoleId, Node}, State) ->
    case get(CacheType) of
        CacheList when is_list(CacheList) -> skip;
        _ -> CacheList = []
    end,
    %% 过滤掉24小时前的聊天记录
    Unixtime = utime:unixtime(),
    DeleteTime = Unixtime - ?CHAT_CACHE_TIME_DELETE,

    % NewCacheList = lists:keysort(2, CacheList),
    F = fun({_RoleId, _Time, MsgRecord}) ->
        #chat{
            channel = Channel
            , sender_server_num = SenderServerNum
            , sender_c_server_msg = SenderCServerMsg
            , sender_id = SenderId
            , sender_figure = SenderFigure
            , sender_server_id = SenderServerId
            , sender_server_name = SenderServerName
            , msg_send = MsgSend
            , args = Args
            , args_result = ArgsResult
            , utime = Utime
            , is_read = IsRead
            , voice_id = VoiceId
            , voice_time = VoiceTime
        } = MsgRecord,
        {Channel, [{SenderServerNum, SenderCServerMsg, SenderServerId, SenderServerName, SenderId, SenderFigure}], MsgSend, Args, ArgsResult, Utime, IsRead, VoiceId, VoiceTime}
    end,
    SendList = [F(T) || {_, ChatTime, _} = T <- CacheList, ChatTime > DeleteTime],
%%    ?MYLOG("zh_chat_cache", "send_cache CacheType:~p, RoleId:~p SendList:~p ~n", [CacheType, RoleId, SendList]),
    {ok, BinData} = pt_110:write(11010, [SendList]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State};

%% 删除聊天的缓存
do_handle_cast({'delete_cache', ?CHAT_CHANNEL_PRIVATE, RoleIdList}, #state{priv_cache_map = CacheMap} = State) ->
    NewCacheMap = maps:without(RoleIdList, CacheMap),
    NewState = State#state{priv_cache_map = NewCacheMap},
    {noreply, NewState};
do_handle_cast({'delete_cache', CacheType, SpecifyIds}, State) ->
    case is_list(SpecifyIds) andalso SpecifyIds =/= [] of
        true ->
            case get(CacheType) of
                CacheList when is_list(CacheList) ->
                    NewCacheList = [{SenderId, Time, MsgRecord} || {SenderId, Time, MsgRecord} <- CacheList, not lists:member(SenderId, SpecifyIds)],
                    put(CacheType, NewCacheList);
                _ ->
                    skip
            end;
        false -> erase(CacheType)
    end,
    {noreply, State};
do_handle_cast({'delete_priv_cache_by_sender_id', SenderIds}, #state{priv_cache_map = CacheMap} = State) ->
    F = fun(_RoleId, OneCacheMap) ->
        maps:without(SenderIds, OneCacheMap)
    end,
    NewCacheMap = maps:map(F, CacheMap),
    NewState = State#state{priv_cache_map = NewCacheMap},
    {noreply, NewState};

%% 点击私聊
do_handle_cast({'click_cache', ?CHAT_CHANNEL_PRIVATE, RoleId, ClickRoleId}, State) ->
    #state{priv_cache_map = CacheMap} = State,
    RoleMap = maps:get(RoleId, CacheMap, #{}),
    #priv_cache{msg = MsgList} = PrivCache = maps:get(ClickRoleId, RoleMap, #priv_cache{}),
    case MsgList == [] of
        true -> {noreply, State};
        false ->
            NewMsgList = [Msg#chat{is_read = ?CAHT_CACHE_IS_READ_YES}||Msg<-MsgList],
            NewPrivCache = PrivCache#priv_cache{msg = NewMsgList},
            NewRoleMap = maps:put(ClickRoleId, NewPrivCache, RoleMap),
            NewCacheMap = maps:put(RoleId, NewRoleMap, CacheMap),
            NewState = State#state{priv_cache_map = NewCacheMap},
            {noreply, NewState}
    end;

%% -----------------------------------------------------------------
%% @desc   更新聊天缓存玩家形象信息
%% @param  {'update_chat_cache_state',RoleId, UseDressList}
%% @param  State                              私聊缓存
%% @return
%% -----------------------------------------------------------------
do_handle_cast({'update_chat_cache_state',RoleId, UseDressList}, #state{priv_cache_map = CacheMap} = State) ->
    NewCacheMap = update_private_chat_state(RoleId, CacheMap, UseDressList),
    NewState = State#state{priv_cache_map = NewCacheMap},
    CacheTypeList = [?CHAT_CHANNEL_WORLD, ?CHAT_CHANNEL_GUILD, ?CHAT_CHANNEL_ZONE],
    [update_chat_cache_progress(CacheType, UseDressList, RoleId) || CacheType <- CacheTypeList],
    {noreply, NewState};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% -----------------------------------------------
%% 内部函数
%% -----------------------------------------------

is_valid_cache_type(CacheType) ->
    case CacheType of
        ?CHAT_CHANNEL_WORLD -> true;
        ?CHAT_CHANNEL_PRIVATE -> true;
        {?CHAT_CHANNEL_GUILD, GuildId} when GuildId > 0 -> true;
        {?CHAT_CHANNEL_ZONE, ZoneId} when ZoneId > 0 -> true;
        ?CHAT_CHANNEL_NG -> true;
        _ -> false
    end.

%% 增加私聊缓存
add_priv_cache(State, RoleId, OtherRoleId, Chat, IsRead) ->
    #state{priv_cache_map = CacheMap} = State,
    Map = maps:get(RoleId, CacheMap, #{}),
    #priv_cache{len = Len, msg = MsgList} = maps:get(OtherRoleId, Map, #priv_cache{}),
    NewMsgList = [Chat#chat{is_read=IsRead}|MsgList],
    NewLen = Len + 1,
    case NewLen > ?PRIV_CACHE_SINGLE_LEN of
        true ->
            LastLen = ?PRIV_CACHE_SINGLE_LEN,
            LastMsgList = lists:droplast(NewMsgList);
        false ->
            LastLen = NewLen,
            LastMsgList = NewMsgList
    end,
    NewMap = maps:put(OtherRoleId, #priv_cache{len = LastLen, msg = LastMsgList}, Map),
    % 清理过多的缓存
    F = fun(_, TCache, {Sum, Acc}) ->
        #priv_cache{len = TLen, msg = TMsgL} = TCache,
        {Sum + TLen, [TMsgL|Acc]}
    end,
    {TotalLen, AllMsgL} = maps:fold(F, {0, []}, NewMap),
    case TotalLen > ?PRIV_CACHE_CLEAR_MAX_LEN of
        true ->
            AllMsgListSort = lists:reverse(lists:keysort(#chat.utime, lists:flatten(AllMsgL))),
            AllMsgListSub = lists:sublist(AllMsgListSort, ?PRIV_CACHE_MAX_LEN),
            F2 = fun(#chat{sender_id = TmpSenderId} = TmpPrivMsg, TmpMap) ->
                #priv_cache{len = TmpLen, msg = TmpMsgList} = maps:get(TmpSenderId, TmpMap, #priv_cache{}),
                maps:put(TmpSenderId, #priv_cache{len = TmpLen + 1, msg = [TmpPrivMsg|TmpMsgList]}, TmpMap)
            end,
            LastMap = lists:foldr(F2, #{}, AllMsgListSub);
        false ->
            LastMap = NewMap
    end,
    NewCacheMap = CacheMap#{RoleId => LastMap},
    State#state{priv_cache_map = NewCacheMap}.

%% -----------------------------------------------------------------
%% @desc   更新私聊缓存玩家形象
%% @param  RoleId       玩家Id
%% @param  CacheMap     私聊缓存
%% @param  UseDressList 装扮列表
%% @return NewCacheMap
%% -----------------------------------------------------------------
update_private_chat_state(RoleId, CacheMap, UseDressList) ->
    Map = maps:get(RoleId, CacheMap, #{}),
    F = fun(OtherRoleId, TCache, Acc) ->
        #priv_cache{msg = TMsgL} = TCache,
        #chat{sender_figure = SenderFigure} = TMsgL,
        NewSenderFigure = SenderFigure#figure{dress_list = UseDressList},
        NewTMsgL = TMsgL#chat{sender_figure = NewSenderFigure},
        NewTCache = TCache#priv_cache{msg = NewTMsgL},
        maps:put(OtherRoleId, NewTCache, Acc)
        end,
    NewMap = maps:fold(F, #{}, Map),
    maps:put(RoleId, NewMap, CacheMap).

%% -----------------------------------------------------------------
%% @desc   更新其他聊天缓存玩家形象
%% @param  CacheType    缓存类型
%% @param  RoleId       玩家Id
%% @param  UseDressList 装扮列表
%% @return
%% -----------------------------------------------------------------
update_chat_cache_progress(CacheType, UseDressList, RoleId) ->
    case get(CacheType) of
        CacheList when is_list(CacheList) ->
            F = fun({TempRoleId, Time, MsgRecord}, TempCacheList) ->
                if
                    TempRoleId =/= RoleId -> NewMsgRecord = MsgRecord;
                    true ->
                        #chat{sender_figure = SenderFigure} = MsgRecord,
                        NewSenderFigure = SenderFigure#figure{dress_list = UseDressList},
                        NewMsgRecord = MsgRecord#chat{sender_figure = NewSenderFigure}
                end,
                TempCacheList ++ [{TempRoleId, Time, NewMsgRecord}]
                end,
            NewCacheList = lists:foldl(F, [], CacheList),
            put(CacheType, NewCacheList);
        _ -> skip
    end.