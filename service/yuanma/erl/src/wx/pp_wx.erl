%% ---------------------------------------------------------------------------
%% @doc pp_wx.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-09-23
%% @deprecated 微信平台需求
%% ---------------------------------------------------------------------------
-module(pp_wx).
-export([handle/3]).
-include("common.hrl").
-include("server.hrl").
-include("wx.hrl").

handle(11301, Player, []) ->
    lib_wx:send_wx_share_info(Player);

handle(11302, Player, []) ->
    lib_wx:receive_wx_share_reward(Player);

%% 微信收藏(只有微信平台)
handle(11303, Player, [Opr]) ->
    lib_wx:opr_wx_collect(Player, Opr);

handle(11304, Player, []) ->
    lib_wx:touch_wx_share(Player);

%% 微信订阅消息
handle(11305, Player, [TempId, PackageCode]) ->
    lib_wx:wx_subscribe(Player, [TempId, PackageCode]);

%% 查询订阅状态
handle(11306, Player, [TemIdL]) ->
    #player_status{id = RoleId, accname = AccName} = Player,
    mod_subscribe:send_subscribe_status(RoleId, AccName, TemIdL);

%% 订阅开关状态
handle(11307, Player, []) ->
    {ok, BinData} = pt_113:write(11307, [?WX_KV_SUBSCRIBE_CHANGER]),
    lib_server_send:send_to_uid(Player#player_status.id, BinData);

%% 渠道信息
handle(11308, Player, [IsMicro]) ->
    lib_wx:is_micro(Player, IsMicro);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.