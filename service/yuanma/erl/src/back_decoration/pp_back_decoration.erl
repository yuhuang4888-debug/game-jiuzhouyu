%% ---------------------------------------------------------------------------
%% @doc pp_decoration

%% @author  lzh
%% @email  	lu13824949032@gmail.com
%% @since  
%% @deprecated 背饰
%% ---------------------------------------------------------------------------

-module(pp_back_decoration).
-include ("common.hrl").
-include ("server.hrl").
-include ("errcode.hrl").
-include ("back_decoration.hrl").
-include ("predefine.hrl").
-include("figure.hrl").

-export([handle/3]).

handle(Cmd, Player, Args) ->
	do_handle(Cmd, Player, Args).


%%获取背饰列表
do_handle(14101, Player, []) ->
	lib_back_decoration:get_decoration_list(Player);

%%背饰详情
do_handle(14102, Player, [DecorationID]) ->
	lib_back_decoration:get_detail_decoration(Player, DecorationID);

%%幻化
do_handle(14103, Player, [DecorationID, Stage]) ->
	#player_status{sid = Sid} = Player,
	case lib_back_decoration:illusion_decoration(Player, DecorationID, Stage) of 
		{true, NewPlayer} ->ErrorCode = ?SUCCESS;
		{false, ErrorCode, NewPlayer} -> skip
	end,
	{ok, BinData} = pt_141:write(14103, [ErrorCode, DecorationID, Stage]),
	lib_server_send:send_to_sid(Sid, BinData),
	{ok, NewPlayer};

%%激活
do_handle(14104, Player, [DecorationID]) ->
	#player_status{sid = Sid} = Player,
	case lib_back_decoration:active_decoration(Player, DecorationID) of 
		{true, NewPlayer} ->ErrorCode = ?SUCCESS;
		{false, ErrorCode, NewPlayer} -> skip
	end,
	{ok, BinData} = pt_141:write(14104, [ErrorCode, DecorationID]),
	lib_server_send:send_to_sid(Sid, BinData),
	{ok, NewPlayer};

%%升阶
do_handle(14105, Player, [DecorationID]) ->
	#player_status{sid = Sid} = Player,
	case lib_back_decoration:upgrade_stage(Player, DecorationID) of 
		{true, NewPlayer} ->skip;%% 升级成功详情在函数里面返回给了客户端
		{false, ErrorCode, NewPlayer} ->
			{ok, BinData} = pt_141:write(14105, [ErrorCode, DecorationID, 0, 0, [], [], 0]),
			lib_server_send:send_to_sid(Sid, BinData)
	end,
	{ok, NewPlayer};

%%未激活的背饰情况
do_handle(14106, Player, [DecorationID]) ->
	lib_back_decoration:get_default_decoration(Player, DecorationID);

do_handle(_Cmd, Player, _) ->
	{ok, Player}.