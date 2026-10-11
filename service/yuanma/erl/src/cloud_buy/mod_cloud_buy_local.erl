%%-----------------------------------------------------------------------------
%% @Module  :       mod_cloud_buy_local.erl
%% @Author  :       hyh
%% @Email   :       huyihao@suyougame.com
%% @Created :       2018-03-20
%% @Description:    众仙云购
%%-----------------------------------------------------------------------------

-module(mod_cloud_buy_local).

-include("common.hrl").
-include("cloud_buy.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").

-behaviour (gen_server).
-export ([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).
-export ([
    start_link/0
    ,send_award_tv/2
    ,send_unlimited_tv/1
    ,send_open_tv/1
]).

-define (SERVER, ?MODULE).
%% API
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


send_open_tv(SubType) ->
    gen_server:cast(?SERVER, {send_open_tv, SubType}).

send_award_tv(LuckyOrders, SubType) ->
    gen_server:cast(?SERVER, {send_award_tv, LuckyOrders, SubType}).

send_unlimited_tv(SubType) ->
    gen_server:cast(?SERVER, {send_unlimited_tv, SubType}).

%% private
init([]) ->
    {ok, []}.

handle_call(Msg, From, State) ->
    case catch do_handle_call(Msg, From, State) of
        {'EXIT', Error} ->
            ?ERR("handle_call error: ~p~nMsg=~p~n", [Error, Msg]),
            {reply, error, State};
        Return  ->
            Return
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {'EXIT', Error} ->
            ?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
            {noreply, State};
        Return  ->
            Return
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', Error} ->
            ?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
            {noreply, State};
        Return  ->
            Return
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

do_handle_call(_Msg, _From, State) ->
    {reply, ok, State}.



do_handle_cast({send_award_tv, LuckyOrders, SubType}, State) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
        true ->
            if
                LuckyOrders == [] ->
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 22, []);
                true ->
                    LastLuckyOrdersSendList = [begin
                        {BigAwardId, Time, Platform, Server, util:make_sure_binary(RoleName), RoleUnique, Count}
                    end || #cloud_order{big_award_id = BigAwardId, time = Time, platform = Platform, server = Server, customer_name = RoleName, 
                            customer_uid = RoleUnique, count = Count} <- LuckyOrders],
                    % ?PRINT("LastLuckyOrders:~p~n",[LastLuckyOrders]),
                    {ok, BinData} = pt_331:write(33114, [SubType, LastLuckyOrdersSendList]),
                    lib_server_send:send_to_all(BinData),
                    Formats = [begin
                        utext:get(3310001, [PlatForm, Serv, RoleName])
                    end|| #cloud_order{platform = PlatForm, server = Serv, customer_name = RoleName} <- LuckyOrders],
                    Msg = ulists:list_to_string(Formats, ","),
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 4, [Msg])
            end;
        false ->
            skip
    end,
    {noreply, State};

do_handle_cast({send_open_tv, SubType}, State) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
        true ->
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 26, []);
        false ->
            skip
    end,
    {noreply, State};

do_handle_cast({send_unlimited_tv, SubType}, State) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_CLOUD_BUY, SubType) of
        true ->
            lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 3, []);
        false ->
            skip
    end,
    {noreply, State};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_info(_Msg, State) ->
    {noreply, State}.

% %% internal
