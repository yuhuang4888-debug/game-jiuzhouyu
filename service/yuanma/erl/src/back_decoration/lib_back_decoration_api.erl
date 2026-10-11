%% ---------------------------------------------------------------------------
%% @doc lib_back_decoration_api

%% @author  lzh
%% @email  lu13824949032@gmail.com
%% @since  
%% @deprecated 背饰对外函数
%% ---------------------------------------------------------------------------
-module(lib_back_decoration_api).
-include ("common.hrl").
-include ("errcode.hrl").
-include ("back_decoration.hrl").
-include ("predefine.hrl").
-include ("def_fun.hrl").
-include ("server.hrl").
-export ([cancel_back_decoration_illusion/1]).

%%当幻化翅膀的时候调用该函数，取消背饰幻化状态,返回{ok, NewPlayer}
cancel_back_decoration_illusion(Player) ->
	case lib_back_decoration:cancel_illusion(Player) of
		{ok, NewPlayer} -> NewPlayer;
		_ -> Player
	end.

