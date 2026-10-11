%% ---------------------------------------------------------------------------
%% @doc lib_wx.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-09-23
%% @deprecated 微信平台需求
%% ---------------------------------------------------------------------------
-module(lib_wx).
-compile(export_all).

-include("afk.hrl").
-include("server.hrl").
-include("wx.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("language.hrl").

%% 加载微信分享信息
load_status_wx_share(RoleId) ->
    case db_role_wx_share_select(RoleId) of
        [] -> #status_wx_share{};
        [Count, Utime] -> #status_wx_share{count = Count, utime = Utime}
    end.

%% 发送微信分享信息
send_wx_share_info(#player_status{sid = Sid} = Player) ->
    #status_wx_share{count = Count} = get_status_wx_share(Player, utime:unixtime()),
    {ok, BinData} = pt_113:write(11301, [Count]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 分享奖励领取
receive_wx_share_reward(#player_status{id = RoleId, sid = Sid} = Player) ->
    NowTime = utime:unixtime(),
    case check_receive_wx_share_reward(Player, NowTime) of
        {false, ErrCode} -> NewPlayer = Player;
        {true, #status_wx_share{count = Count} = StatusWxShare, Reward} ->
            ErrCode = ?SUCCESS,
            NewCount = Count+1,
            NewStatusWxShare = StatusWxShare#status_wx_share{count = NewCount, utime = NowTime},
            db_role_wx_share_replace(RoleId, NewStatusWxShare),
            lib_log_api:log_role_wx_share(RoleId, NewCount, Reward),
            PlayerAfSave = Player#player_status{wx_share = NewStatusWxShare},
            Produce = #produce{type = wx_share, reward = Reward},
            NewPlayer = lib_goods_api:send_reward(PlayerAfSave, Produce),
            send_wx_share_info(NewPlayer)
    end,
    ?PRINT("ErrCode:~p ~n", [ErrCode]),
    {ok, BinData} = pt_113:write(11302, [ErrCode]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

check_receive_wx_share_reward(Player, NowTime) ->
    #player_status{source = _Source} = Player,
    #status_wx_share{count = Count} = StatusWxShare = get_status_wx_share(Player, NowTime),
    MaxCount = ?WX_KV_SHARE_DAY_COUNT,
    % 客户端限制,服务端不限制
    % IsSource = lists:member(make_source(Source), ?WX_KV_SHARE_SOURCE_LIST),
    Reward = ?WX_KV_SHARE_REWARD,
    if
        Count >= MaxCount -> {false, ?ERRCODE(err113_wx_share_count_max)};
        % IsSource == false -> {false, ?ERRCODE(err113_wx_share_source_not_right)};
        Reward == [] -> {false, ?MISSING_CONFIG};
        true -> {true, StatusWxShare, Reward}
    end.

make_source(Source) ->
    list_to_atom(util:make_sure_list(Source)).

%% 获取分享信息[根据时间判断次数]
get_status_wx_share(Player, Unixtime) ->
    #player_status{wx_share = StatusWxShare} = Player,
    #status_wx_share{utime = Utime} = StatusWxShare,
    case utime:is_same_day(Unixtime, Utime) of
        true -> StatusWxShare;
        false -> StatusWxShare#status_wx_share{count = 0}
    end.

%% 触发分享
touch_wx_share(Player) ->
    #player_status{id = RoleId, source = _Source} = Player,
    % 客户端限制,服务端不限制
    % IsSource = lists:member(make_source(Source), ?WX_KV_SHARE_SOURCE_LIST),
    if
        % IsSource == false -> skip;
        true -> lib_log_api:log_role_wx_share_touch(RoleId)
    end,
    lib_grow_welfare_api:share_game(Player).


%% 查询幻饰boss的玩家信息
db_role_wx_share_select(RoleId) ->
    Sql = io_lib:format(?sql_role_wx_share_select, [RoleId]),
    db:get_row(Sql).

%% 插入幻饰boss的玩家信息
db_role_wx_share_replace(RoleId, StatusWxShare) ->
    #status_wx_share{count = Count, utime = Utime} = StatusWxShare,
    Sql = io_lib:format(?sql_role_wx_share_replace, [RoleId, Count, Utime]),
    db:execute(Sql).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 微信收藏
opr_wx_collect(Player, Opr) ->
    case Opr of
        1 ->
            send_wx_collect_state(Player, Opr);
        2 ->
            wx_collect(Player, Opr);
        3 ->
            receive_wx_collect_reward(Player, Opr);
        _ ->
            {ok, Player}
    end.

send_wx_collect_state(Player, Opr) ->
    #player_status{id = RoleId, sid = Sid, source = Source} = Player,
    case lists:member(make_source(Source), ?WX_KV_COLLECT_SOURCE_LIST) of
        true ->
            case mod_counter:get_count(RoleId, ?MOD_WX, 1) of
                0 -> CollectState = 0;
                1 -> CollectState = 1;
                _ -> CollectState = 2
            end;
        _ ->
            CollectState = 0
    end,
    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?SUCCESS, Opr, CollectState]).

wx_collect(Player, Opr) ->
    #player_status{id = RoleId, sid = Sid, source = Source} = Player,
    case lists:member(make_source(Source), ?WX_KV_COLLECT_SOURCE_LIST) of
        true ->
            case mod_counter:get_count(RoleId, ?MOD_WX, 1) of
                0 ->
                    mod_counter:set_count(RoleId, ?MOD_WX, 1, 1),
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?SUCCESS, Opr, 1]);
                1 ->
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_already_collect), Opr, 0]);
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_receive_wx_collect_reward), Opr, 0])
            end;
        _ ->
           lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_wx_can_not_collect), Opr, 0])
    end.

receive_wx_collect_reward(Player, Opr) ->
    #player_status{id = RoleId, sid = Sid, source = Source} = Player,
    case lists:member(make_source(Source), ?WX_KV_COLLECT_SOURCE_LIST) of
        true ->
            case mod_counter:get_count(RoleId, ?MOD_WX, 1) of
                0 ->
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_wx_not_collect), Opr, 0]);
                1 ->
                    mod_counter:set_count(RoleId, ?MOD_WX, 1, 2),
                    RewardList = ?WX_KV_COLLECT_REWARD,
                    Produce = #produce{show_tips = ?SHOW_TIPS_4, type = wx_collect, reward = RewardList},
                    NewPlayer = lib_goods_api:send_reward(Player, Produce),
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?SUCCESS, Opr, 2]),
                    {ok, NewPlayer};
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_receive_wx_collect_reward), Opr, 0])
            end;
        _ ->
           lib_server_send:send_to_sid(Sid, pt_113, 11303, [?ERRCODE(err113_wx_not_collect), Opr, 0])
    end.

%% 微信订阅消息
wx_subscribe(#player_status{accname = AccName, id = RoleId}, [TempId, PackageCode]) ->
    lib_subscribe_api:subscribe([TempId, PackageCode], AccName, RoleId).

%% 是否微端登录判断
is_micro(Player, IsMicro) ->
    #player_status{id = RoleId} = Player,
    ?PRINT("IsMicro ~p ~n", [IsMicro]),
    case IsMicro of
        1 ->
            MicroLoginCount = mod_counter:get_count(RoleId, ?MOD_WX, 2),
            if
                MicroLoginCount >= 1 -> skip;
                true ->
                    Title = utext:get(1130001),
                    Content = utext:get(1130002),
                    Reward = ?WX_KV_MICRO_LOGIN_REWARD,
                    mod_counter:increment(RoleId, ?MOD_WX, 2),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward)
            end;
        _ -> skip
    end.
