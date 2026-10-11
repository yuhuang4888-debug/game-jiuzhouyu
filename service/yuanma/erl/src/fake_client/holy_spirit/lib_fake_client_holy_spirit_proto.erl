%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_holy_spirit_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 圣灵战场挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_holy_spirit_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(21802, PS, [Code]) ->
	lib_fake_client_holy_spirit:enter_activity_result(PS, Code);

%% 
handle_proto(21809, PS, [_RoleName, _RoleId, _Lv, _Power, _PictureId, _Picture, Anger, _ServerId, _Career, _Turn]) ->
	lib_fake_client_holy_spirit:update_anger(PS, Anger);

%% 战塔信息
handle_proto(21813, PS, [MonList]) ->
	lib_fake_client_holy_spirit:mon_list(PS, MonList);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.