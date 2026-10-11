%% ---------------------------------------------------------------------------
%% @doc pp_activity_onhook.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 活动托管
%% ---------------------------------------------------------------------------
-module(pp_activity_onhook).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 已选的托管列表
handle(19201, PS, []) ->
    lib_activity_onhook:send_activity_onhook_list(PS);

%% 
handle(19202, PS, [ModId, SubId]) ->
    lib_activity_onhook:select_module(PS, ModId, SubId);

%% 
handle(19203, PS, [ModId, SubId]) ->
    lib_activity_onhook:cancel_select_module(PS, ModId, SubId);

%%
handle(19204, PS, [ModId, SubId, BehaviourId, Times]) ->
    lib_activity_onhook:select_module_behaviour(PS, ModId, SubId, BehaviourId, Times);

%% 
handle(19205, PS, [ModId, SubId, BehaviourId]) ->
    lib_activity_onhook:cancel_select_module_behaviour(PS, ModId, SubId, BehaviourId);

%% 托管记录列表
handle(19206, PS, []) ->
    lib_activity_onhook:send_activity_onhook_record(PS);


%% 托管币兑换
handle(19207, PS, [ExchangeOnhookCoin]) when ExchangeOnhookCoin>0 ->
    lib_activity_onhook:exchange_onhook_coin(PS, ExchangeOnhookCoin);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.