%%%------------------------------------
%%% @Module  : mod_chat_agent
%%% @Author  : xyao
%%% @Created : 2012.07.25
%%% @Description: 聊天管理
%%%------------------------------------
-module(mod_chat_agent).
-behaviour(gen_server).
-export([start_link/0,
         get_online_num/0,
         send_msg/1,
         insert/1,
         lookup/1,
         match/3,
         match/2,
         update/2,
         delete/1,
         get_online_player/0,    %% 获得在线玩家
         get_real_online_player/1, %% 获取真实在线的玩家
         handle_event/2,
         handle_event/1,
         repair_online_num/0     %% 修复在线人数统计
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("unite.hrl").
-include("chat.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("server.hrl").
-include("common.hrl").

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

get_online_num()->
    gen_server:call(misc:get_global_pid(?MODULE), {get_online_num, all}).

get_online_player() ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_online_player}).

get_real_online_player(ReturnFormatList) ->
    gen_server:call(misc:get_global_pid(?MODULE), {get_real_online_player, ReturnFormatList}).

repair_online_num()->
    gen_server:cast(misc:get_global_pid(?MODULE), {repair_online_num}).

%% ----------------------------------------------------------------------
%% @doc 发送不同类型的消息
-spec send_msg(MsgTypeValueList) -> ok when
      MsgTypeValueList :: list().     %% 类型值组合的元组列表，元组类型
%% {uid, Id, Bin} | {all, Bin} | {all, tv, Bin} | {all, unmask, Bin}
%% {all, MinLv, MaxLv, Bin} | {open_call, Bin} |
%% {scene, SceneId, Bin} | {scene, SceneId, CopyId, Bin} | {guild, GuildId, Bin}
%% {realm, Realm, Bin} | {new_realm, NewRealm, Bin} | {team, TeamId, Bin} | {group, Group, Bin}
%% {career, Career, Bin} | {all_turn, MinTurn, MaxTurn, Bin}
%% ----------------------------------------------------------------------
send_msg(MsgTypeValueList) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {send_msg, MsgTypeValueList}).

%% 插入数据
insert(EtsUnite) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {insert, EtsUnite}).

%% ----------------------------------------------------------------------
%% @doc 更新操作
-spec update(Id, AttrKeyValueList) -> ok when
      Id               :: integer(),  %% 玩家id
      AttrKeyValueList :: list().     %% 即 [{Key1, Value1}, {..}],
%%  Key = name|gm|vip|scene|copy_id|team_id
%%        |sex|realm|career|guild_id|guild_name
%%        |guild_position|group|lv|image|appointment
%%        |combat_power|talk_accept|picture|picture_ver
%% ----------------------------------------------------------------------
update(Id, AttrKeyValueList) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {update, Id, AttrKeyValueList}).

%% 删除数据
delete(Id) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {delete, Id}).

%% 查找数据
lookup(Id) ->
    gen_server:call(misc:get_global_pid(?MODULE), {lookup, Id}).

%% 多条件查找
%%　返回值由使用者自己定义
match(Type, Info, ResultForm) ->
    gen_server:call(misc:get_global_pid(?MODULE), {match, Type, Info, ResultForm}).

match(Type, Info) ->
    gen_server:call(misc:get_global_pid(?MODULE), {match, Type, Info, all}).

handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    %% 更新公共线的等级信息
    mod_chat_agent:update(PS#player_status.id, [{lv, PS#player_status.figure#figure.lv}]),
    {ok, PS};
handle_event(PS, #event_callback{}) ->
    {ok, PS}.

handle_event(#event_callback{type_id = ?EVENT_PICTURE_CHANGE, data = EventData}) ->
    #callback_picture{role_id = RoleId, picture = Picture, picture_ver = PictureVer} = EventData,
    mod_chat_agent:update(RoleId, [{picture, Picture}, {picture_ver, PictureVer}]),
    ok;
handle_event(#event_callback{}) ->
    ok.

%% 初始化
init([]) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Req Error:~p~n", [[Req, Res]]),
            {reply, ok, State}
    end.




handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Msg Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.



handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ================================= private fun =================================
%% call
%% 返回真是在线玩家和离线挂机玩家人数 {OnlineNum, OnhookNum}
do_handle_call({get_online_num, all}, _From, State) ->
    case get(online_num) of
        undefined -> OnlineNum = 0;
        OnlineNum -> skip
    end,
    case get(onhook_online_num) of
        undefined -> OnhookNum = 0;
        OnhookNum -> skip
    end,
    {reply, {OnlineNum, OnhookNum}, State};

%% 获得在线玩家
do_handle_call({get_online_player}, _From, State) ->
    Data = get(),
    Reply = [Player || {_, Player} <- Data, is_record(Player, ets_unite)],
    {reply, Reply, State};

%% 获取真实在线玩家信息
do_handle_call({get_real_online_player, ReturnFormatList}, _From, State) ->
    Data = get(),
    F = fun({_, Player}, List) ->
        case is_record(Player, ets_unite) andalso Player#ets_unite.online == ?ONLINE_ON of 
            true ->
                ReturnData = get_return_data(Player, ReturnFormatList),
                [{Player#ets_unite.id, ReturnData}|List];
            _ ->
                List
        end
    end,
    Reply = lists:foldl(F, [], Data),
    {reply, Reply, State};

%% 查找数据
do_handle_call({lookup, Id}, _From, State) ->
    Data1 = case get(Id) of
                undefined -> [];
                Data -> [Data]
            end,
    {reply, Data1, State};

%% 多条件查找
%%  返回值由使用者自己定义
do_handle_call({match, Type, Info, ResultForm}, _From, State) ->
    Data = do_match(Type, Info, ResultForm),
    {reply, Data, State};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% cast
%% 插入聊天进程
do_handle_cast({insert, EtsUnite}, State) ->
    case get(EtsUnite#ets_unite.id) of
        undefined ->
            put(EtsUnite#ets_unite.id, EtsUnite),
            %% 记录在线人数
            update_role_num(?ONLINE_OFF, EtsUnite#ets_unite.online);
        #ets_unite{online = Online} ->
            % if 
            %     %% 挂机=>在线
            %     Online == ?ONLINE_OFF_ONHOOK ->
            %         %% 离线挂机人数-1,在线人数+1
            %         change_online_onhook(-1),
            %         increasement_online_num();
            %     true -> %% 其他情况,默认应该是不加在线人数
            %         skip
            % end,
            update_role_num(Online, EtsUnite#ets_unite.online),
            put(EtsUnite#ets_unite.id, EtsUnite)
    end,
    {noreply, State};

%% 更新进程字典
do_handle_cast({update, Id, AttrKeyValueList}, State) ->
    case get(Id) of
        undefined ->
            skip;
        Data ->
            NewData = do_update(AttrKeyValueList, Data, Id),
            put(Id, NewData)
    end,
    {noreply, State};

%% 玩家下线操作时触发
do_handle_cast({delete, Id}, State) ->
    case get(Id) of
        undefined -> skip;
        EtsUnite ->
            erase(Id),
            update_role_num(EtsUnite#ets_unite.online, ?ONLINE_OFF)
            % if 
            %     %% 判断是否已经触发过减在线人数
            %     EtsUnite#ets_unite.online == ?ONLINE_OFF_ONHOOK -> %% 离线挂机人数-1
            %         change_online_onhook(-1);
            %     true -> %% 其他情况不处理清理(真实玩家数量的减少随着在线状态更改，这里不处理)
            %         %reduce_online_num()
            %         skip
            % end
    end,
    {noreply, State};

%% 发送不同类型的消息
do_handle_cast({send_msg, MsgTypeValueList}, State) ->
    do_send_msg(MsgTypeValueList),
    {noreply, State};

%% 修复在线人数
do_handle_cast({repair_online_num}, State)->
    Data = get(),
    RoleInfo = [Player || {_, Player} <- Data, is_record(Player, ets_unite)],
    F = fun(#ets_unite{online = Online}, {OnlineNum, OnhookNum})->
        if 
            Online == ?ONLINE_OFF_ONHOOK -> {OnlineNum, OnhookNum+1};
            true -> {OnlineNum+1, OnhookNum}
        end
    end,
    {OnlineCount, OnlineOnhookCount} = lists:foldl(F, {0, 0}, RoleInfo),
    put(online_num, OnlineCount),
    put(onhook_online_num, OnlineOnhookCount),
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

%% info
do_handle_info(_Info, State)->
    ?PRINT("Info: ~p~n", [_Info]),
    {noreply, State}.

%% ================================= private fun =================================
%% 内部函数:查询
do_match(Type, Info, ResultForm) ->
    %% 获取所有的数据
    Data = get(),
    %% 查找
    case Type of
        match_name ->   %% 根据名字查找玩家信息
            [PlayerName] = Info,
            F = fun
                    ({_K, #ets_unite{figure = Figure}}) ->
                           Figure#figure.name =:= util:make_sure_list(PlayerName);
                (_) ->
                           false
                   end,
    D = lists:filter(F, Data),
    case D of
        [{_, Player}] -> [util:record_return_form(Player, ResultForm)];
        _ -> []
    end
end.

increasement_online_num() ->
    case get(online_num) of
        undefined -> put(online_num, 1);
        Num -> put(online_num, Num+1)
    end.

reduce_online_num() ->
    case get(online_num) of
        undefined -> skip;
        Num -> put(online_num, max(0, Num-1))
    end.

%% 记录离线挂机人数
change_online_onhook(N)->
    case get(onhook_online_num) of
        undefined -> put(onhook_online_num, max(0, N));
        Num -> put(onhook_online_num, max(Num+N, 0))
    end.

%% 更新数据
do_update([], Data, _Id) -> Data;
do_update([T|L], #ets_unite{figure = Figure}=Data, Id) ->
    case T of
        {lv, Lv} -> NewData = Data#ets_unite{figure = Figure#figure{lv = Lv} };
        {picture, Picture} -> NewData = Data#ets_unite{figure = Figure#figure{picture = Picture} };
        {picture_ver, PictureVer} -> NewData = Data#ets_unite{figure = Figure#figure{picture_ver = PictureVer} };
        {guild_id, GuildId} -> NewData = Data#ets_unite{figure = Figure#figure{guild_id = GuildId}};
        {guild_name, GuildName} -> NewData = Data#ets_unite{figure = Figure#figure{guild_name = GuildName}};
        {camp, Camp} -> NewData = Data#ets_unite{figure = Figure#figure{camp = Camp}};
        {scene, SceneId} -> NewData = Data#ets_unite{scene = SceneId};
        {scene_pool_id, ScenePoolId} -> NewData = Data#ets_unite{scene_pool_id = ScenePoolId};
        {copy_id, CopyId} -> NewData = Data#ets_unite{copy_id = CopyId};
        {online, Online} -> NewData = Data#ets_unite{online = Online};
        {online_flag, Online} ->
            if 
                Data#ets_unite.online == Online -> NewData = Data;
                true ->
                    update_role_num(Data#ets_unite.online, Online),
                    NewData = Data#ets_unite{online = Online}
            end;
        {online_flag, Online, OldOnline} ->
            %% 玩家重连的情况下判断:玩家是否进入了离线挂机情况
            % if 
            %     Online == ?ONLINE_ON andalso OldOnline == ?ONLINE_OFF_ONHOOK ->
            %         %% 在线人数+1
            %         increasement_online_num(),
            %         %% 离线挂机人数-1
            %         change_online_onhook(-1),
            %         NewData =  Data#ets_unite{online = Online};
            %     true ->
            %         NewData = Data#ets_unite{online = Online}
            % end;
            update_role_num(OldOnline, Online),
            NewData = Data#ets_unite{online = Online};
        {sid, Sid} ->
            NewData = Data#ets_unite{sid = Sid};
        _  -> NewData = Data
    end,
    do_update(L, NewData, Id).

get_return_data(Player, ReturnFormatList) ->
    get_return_data(Player, ReturnFormatList, []).

get_return_data(_Player, [], ReturnList) ->
    lists:reverse(ReturnList);
get_return_data(Player, [Item|ReturnFormatList], ReturnList) ->
    case Item of 
        lv ->
            RoleLv = Player#ets_unite.figure#figure.lv,
            get_return_data(Player, ReturnFormatList, [RoleLv|ReturnList]);
        _ ->
            get_return_data(Player, ReturnFormatList, ReturnList)
    end.


do_send_msg([]) -> ok;
do_send_msg([H|T]) ->
    case H of
        {all, Bin} ->
            Data = get(),
            F = fun(Player) ->
                        lib_server_send:send_to_sid(Player#ets_unite.sid, Bin)
                end,
            [F(Player) || {_, Player} <- Data, is_record(Player, ets_unite)];
        %% 广播
        {all, tv, Bin} ->
            Data = get(),
            F = fun(Player) ->
                        lib_server_send:send_to_sid(Player#ets_unite.sid, Bin)
                end,
            [F(Player) || {_, Player} <- Data, is_record(Player, ets_unite)];
        %% 无视玩家的消息屏蔽设置发送数据
        {all, unmask, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, is_record(Player, ets_unite)];
        %% 等级段发送
        {all_lv, {MinLv, MaxLv}, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) ||
                {_, Player} <- Data, Player#ets_unite.figure#figure.lv >= MinLv, Player#ets_unite.figure#figure.lv =< MaxLv];
        %% 转生段发送
        {all_turn, {MinTurn, MaxTurn}, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) ||
                {_, Player} <- Data, Player#ets_unite.figure#figure.turn >= MinTurn, Player#ets_unite.figure#figure.turn =< MaxTurn];
        %% 单个排除
        {all_exclude, RoleIds, Bin} when is_integer(RoleIds)->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.id /= RoleIds];
        {all_exclude, RoleIds, Bin} ->
            Data = get(),
            %% 备注 ets表里不光有#ets_unite{}，还会有些进程的其他数据所以需要判断下：is_record(Player, ets_unite)
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, is_record(Player, ets_unite) andalso lists:member(Player#ets_unite.id, RoleIds) == false];
        %% 指定部分玩家id
        {all_include, RoleIds, Bin} ->
            Data = get(),
            %% 备注 ets表里不光有#ets_unite{}，还会有些进程的其他数据所以需要判断下：is_record(Player, ets_unite)
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, is_record(Player, ets_unite) andalso lists:member(Player#ets_unite.id, RoleIds)];
        {scene, SceneId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.scene == SceneId];
        {scene, SceneId, CopyId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.scene == SceneId, Player#ets_unite.copy_id == CopyId];
        {guild, GuildId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.figure#figure.guild_id == GuildId];
        {realm, Realm, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.figure#figure.realm == Realm];
        {camp, Realm, Bin} ->
            Data = get(),
            NeedLv = data_seacraft:get_value(open_lv),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.figure#figure.camp == Realm, Player#ets_unite.figure#figure.lv >= NeedLv];
        {team, TeamId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.team_id == TeamId];
        {group, Group, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.group == Group];
        {career, Career, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.figure#figure.career == Career];
        {all_guild, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, Player#ets_unite.figure#figure.guild_id > 0];
        {specify_uids, UIds, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, lists:member(Player#ets_unite.id, UIds)]; 
        {kf_1vn_area, RoleIds, _AreaId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, is_record(Player, ets_unite),
                lists:member(Player#ets_unite.id, RoleIds) == false];% AreaId == data_kf_1vN:get_area(Player#ets_unite.figure#figure.lv)];
        {scene_guild, SceneId, CopyId, GuildId, Bin} ->
            Data = get(),
            [lib_server_send:send_to_sid(Player#ets_unite.sid, Bin) || {_, Player} <- Data, is_record(Player, ets_unite),
                Player#ets_unite.scene == SceneId, Player#ets_unite.copy_id == CopyId, Player#ets_unite.figure#figure.guild_id == GuildId];
        _ -> ok
    end,
    do_send_msg(T).

update_role_num(OldOnline, Online) ->
    if 
        %% 在线=>挂机
        OldOnline == ?ONLINE_ON andalso Online == ?ONLINE_OFF_ONHOOK ->
            %% 在线人数-1
            reduce_online_num(),
            %% 离线挂机人数+1
            change_online_onhook(1);
        %% 在线=>离线
        OldOnline == ?ONLINE_ON andalso Online == ?ONLINE_OFF ->
            %% 在线人数-1
            reduce_online_num();
        %% 离线=>在线
        OldOnline == ?ONLINE_OFF andalso Online == ?ONLINE_ON ->
            %% 在线人数+1
            increasement_online_num();
        %% 挂机=>离线
        OldOnline == ?ONLINE_OFF_ONHOOK andalso Online == ?ONLINE_OFF ->
            %% 离线挂机人数-1
            change_online_onhook(-1);
        %% 挂机=>在线
        OldOnline == ?ONLINE_OFF_ONHOOK andalso Online == ?ONLINE_ON ->
            %% 在线人数+1
            increasement_online_num(),
            %% 离线挂机人数-1
            change_online_onhook(-1);
        true -> 
            skip
    end.