%%%-------------------------------------------------------------------
%%% @author luzhiheng
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Feb 2020 7:12 PM
%%%-------------------------------------------------------------------
-module(pp_seacraft_extra).
-author("luzhiheng").

%% API
-export([do_handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("seacraft.hrl").

%% 海域信息2.0
do_handle(18650, Ps, []) ->
    mod_seacraft_local:get_seacraft_info(Ps),
    {ok, Ps};

%% 特权列表
do_handle(18651, Ps, []) ->
    mod_seacraft_local:get_privilege_list(Ps),
    {ok, Ps};

%% 操作特权
do_handle(18652, Ps, [PriviId, Option]) ->
    #player_status{id = RoleId, guild = #status_guild{realm = Camp}} = Ps,
    SerId = config:get_server_id(),
    mod_kf_seacraft:option_privilege(SerId, RoleId, Camp, PriviId, Option),
    {ok, Ps};

%% 功勋
do_handle(18653, Ps, []) ->
    #player_status{id = RoleId, figure = #figure{exploit = Exploit}} = Ps,
    #base_sea_exploit{military_id = MId} = lib_seacraft_extra:get_base_exploit(Exploit),
    {ok, BinData} = pt_186:write(18653, [MId, Exploit]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, Ps};

%% 内政界面
do_handle(18654, Ps, [PageSize, PageNum]) ->
    mod_seacraft_local:send_member_info(Ps, PageSize, PageNum),
    {ok, Ps};

%% 势力分布
do_handle(18655, Ps, []) ->
    mod_seacraft_local:get_power_distribution(Ps),
    {ok, Ps};

do_handle(_Cmd, Ps, _Data) ->
    {ok, Ps}.
