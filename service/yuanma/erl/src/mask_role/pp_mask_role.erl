%% ---------------------------------------------------------------------------
%% @doc pp_mask_role.erl
%% @author  lxl
%% @email   
%% @since   
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(pp_mask_role).

-include("mask_role.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

-export([
		handle/3
	]).


handle(51101, PS, []) ->
    lib_mask_role:send_mask_info(PS);

handle(51102, PS, []) ->
    lib_mask_role:cancel_mask(PS);

handle(_Comd, _PS, _Data) ->
    {error, "pp_mask_role no match~n"}.
