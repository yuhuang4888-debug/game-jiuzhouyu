%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 幻兽之域
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(mod_eudemons_land_zone_local).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-include("common.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("eudemons_zone.hrl").
-include("chat.hrl").

-record(eudemons_zone_local, {
		zone_id = 0,
		status = 0,
		reset_etime = 0,
        next_reset_time = 0,         %% 下次洗牌时间戳
        server_list = []     		 %% 同区域的服务器
        }).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

reset_start(ResetETime) ->
    gen_server:cast(?MODULE, {'reset_start', ResetETime}).

in_reset(ResetETime) ->
	gen_server:cast(?MODULE, {'in_reset', ResetETime}).

reset_end(ZoneId, NextResetTime, ServerList) ->
	gen_server:cast(?MODULE, {'reset_end', ZoneId, NextResetTime, ServerList}).

sync_server_data(ZoneId, NextResetTime, ServerList) ->
	gen_server:cast(?MODULE, {'sync_server_data', ZoneId, NextResetTime, ServerList}).

get_same_zone_servers(Sid) ->	
	gen_server:cast(?MODULE, {'get_same_zone_servers', Sid}).

send_eudemons_zone_chat_info(ServerId, RoleId) ->
	gen_server:cast(?MODULE, {'send_eudemons_zone_chat_info', ServerId, RoleId}).

show_state() ->
	gen_server:cast(?MODULE, {'show_state'}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
	State = #eudemons_zone_local{},
    {ok, State}.

handle_call(Req, From, State) ->
    case catch do_handle_call(Req, From, State) of
        {reply, Res, NewState} ->
            {reply, Res, NewState};
        Res ->
            ?ERR("Eudemons zone local Call Error:~p~n", [[Req, Res]]),
            {reply, error, State}

    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons zone local Cast Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Eudemons zone local Info Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


do_handle_call(_Req, _From, State)->
    %?PRINT("_Req:~p~n", [_Req]),
    {reply, ok, State}.

do_handle_cast({'reset_start', ResetETime}, _State)->
    ?PRINT("reset_start ~p~n", [ResetETime]),
    State = #eudemons_zone_local{status = 2, reset_etime = ResetETime},
    %mod_eudemons_land_local:in_reset(ResetETime),
    %broadcast_zone_chat_state(State),
    %% 同步游戏服基本信息到跨服
    lib_eudemons_zone_api:get_server_info_local(),
    {noreply, State};

do_handle_cast({'in_reset', ResetETime}, _State)->
    ?PRINT("in_reset ~p~n", [ResetETime]),
    State = #eudemons_zone_local{status = 2, reset_etime = ResetETime},
    mod_eudemons_land_local:in_reset(ResetETime),
    broadcast_zone_chat_state(State),
    {noreply, State};

do_handle_cast({'reset_end', ZoneId, NextResetTime, ServerList}, State)->
    %?PRINT("reset_end ~p~n", [ServerList]),
    NewState = State#eudemons_zone_local{
    	zone_id = ZoneId, status = 1, reset_etime = 0, next_reset_time = NextResetTime, 
    	server_list = ServerList
    },
    broadcast_zone_chat_state(NewState),
    {noreply, NewState};

do_handle_cast({'sync_server_data', ZoneId, NextResetTime, ServerList}, State)->
    %?PRINT("sync_server_data ~p~n", [ServerList]),
    NewState = State#eudemons_zone_local{
    	zone_id = ZoneId, status = 1, reset_etime = 0, next_reset_time = NextResetTime, 
    	server_list = ServerList
    },
    {noreply, NewState};

do_handle_cast({'get_same_zone_servers', Sid}, State)->
    #eudemons_zone_local{next_reset_time = NextResetTime, server_list = ServerList} = State,
    %?PRINT("get_same_zone_servers ~p~n", [ServerList]),
    List = 
    	[ {ServerId, ZoneId, ServerNum, ServerName, OpTime} || 
    	#eudemons_server{server_id = ServerId, zone_id = ZoneId, server_num = ServerNum, server_name = ServerName, optime = OpTime} <- ServerList],
    lib_server_send:send_to_sid(Sid, pt_470, 47011, [NextResetTime, List]),
    {noreply, State};

do_handle_cast({'send_eudemons_zone_chat_info', _ServerId, _RoleId}, State)->
    % #eudemons_zone_local{status = Status, reset_etime = ResetETime, server_list = ServerList} = State,
    % IsOpen = get_zone_chat_state(Status, ResetETime, ServerList),
    % ?PRINT("send_eudemons_zone_chat_info ~p~n", [IsOpen]),
    % lib_server_send:send_to_uid(RoleId, pt_110, 11024, [IsOpen]),
    {noreply, State};

do_handle_cast({'show_state'}, State)->
    ?PRINT("show_state ~p~n", [State]),
    {noreply, State};

do_handle_cast(Msg, State)->
    ?ERR(" No Match:~w~n", [Msg]),
    {noreply, State}.

do_handle_info(_Info, State) ->
    ?ERR(" No Match:~w~n", [_Info]),
    {noreply, State}.


%% ================================= private fun =================================

get_zone_chat_state(_Status, _ResetETime, _ServerList) ->
	% case Status == 2 andalso utime:unixtime() < ResetETime of 
 %    	true -> IsOpen = 2;
 %    	_ ->
 %    		L = [ 1 || #eudemons_server{optime = OpTime} <- ServerList, util:check_open_day_2(?CHAT_OPEN_DAY_EUDEMONS_ZONE, OpTime)],
 %    		case length(L) >= ?CHAT_ZONE_SEVER_NUM of 
 %    			true -> IsOpen = 1;
 %    			_ -> IsOpen = 0
 %    		end
 %    end,
 %    IsOpen.
    0.

%% 广播跨服聊天状态
broadcast_zone_chat_state(_State) -> ok.
	% case util:get_open_day() < ?CHAT_OPEN_DAY_EUDEMONS_ZONE of 
	% 	true -> IsOpen = 0;
	% 	_ ->
	% 		#eudemons_zone_local{status = Status, reset_etime = ResetETime, server_list = ServerList} = State,
	% 		IsOpen = get_zone_chat_state(Status, ResetETime, ServerList)
	% end,
	% {ok, Bin} = pt_110:write(11024, [IsOpen]),
	% lib_server_send:send_to_all(Bin).
