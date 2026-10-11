%%%-----------------------------------
%%% @Module      : mod_midday_party
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 22. 四月 2019 14:07
%%% @Description : 文件摘要
%%%-----------------------------------
-module(mod_midday_party).
-author("chenyiming").

-include("common.hrl").
-include("midday_party.hrl").
-include("errcode.hrl").
-include("drop.hrl").
%% API
-compile(export_all).



-define(SERVER, ?MODULE).


%% API
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

act_start() ->
	gen_server:cast(?MODULE, {'act_start'}).

act_end() ->
	gen_server:cast(?MODULE, {'act_end'}).

enter(RoleId, RoleLv) ->
%%	?MYLOG("midday", "enter +++++++~n", []),
	gen_server:cast(?MODULE, {'enter', RoleId, RoleLv}).

count_exp(RoleId, ExpAdd) ->
	gen_server:cast(?MODULE, {'count_exp', RoleId, ExpAdd}).

get_exp(RoleId) ->
	gen_server:cast(?MODULE, {'get_exp', RoleId}).

quit(RoleId) ->
	gen_server:cast(?MODULE, {'quit', RoleId}).

mon_be_kill(KillId, MonArgs) ->
	#mon_args{scene = Scene} = MonArgs,
	case lib_midday_party:is_in_midday_party(Scene) of
		true ->
			gen_server:cast(?MODULE, {'mon_be_kill', KillId, MonArgs});
		_ ->
			skip
	end.

be_collected(CollectorId, MonArgs) ->
	#mon_args{scene = Scene} = MonArgs,
	case lib_midday_party:is_in_midday_party(Scene) of
		true ->
			gen_server:cast(?MODULE, {'be_collected', CollectorId, MonArgs});
		_ ->
			skip
	end.

get_mon_reborn_time(RoleId) ->
	gen_server:cast(?MODULE, {'get_mon_reborn_time', RoleId}).

get_end_time(RoleId) ->
	gen_server:cast(?MODULE, {'get_end_time', RoleId}).

gm_copy_num(Num) ->
	gen_server:cast(?MODULE, {'gm_copy_num', Num}).

gm_fake_join(Num) ->
	gen_server:cast(?MODULE, {'gm_fake_join', Num}).


%% private
init([]) ->
	{ok, #midday_party_state{}}.

handle_call(Msg, From, State) ->
	case catch do_handle_call(Msg, From, State) of
		{'EXIT', Error} ->
			?ERR("handle_call error: ~p~n Msg=~p~n", [Error, Msg]),
			{reply, error, State};
		Return ->
			Return
	end.

handle_cast(Msg, State) ->
	case catch do_handle_cast(Msg, State) of
		{'EXIT', Error} ->
			?ERR("handle_cast error: ~p~nMsg=~p~n", [Error, Msg]),
			{noreply, State};
		Return ->
			Return
	end.

handle_info(Info, State) ->
	case catch do_handle_info(Info, State) of
		{'EXIT', Error} ->
			?ERR("handle_info error: ~p~nInfo=~p~n", [Error, Info]),
			{noreply, State};
		Return ->
			Return
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

terminate(_Reason, _State) ->
	?ERR("~p is terminate:~p", [?MODULE, _Reason]),
	ok.

do_handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

do_handle_cast({'act_start'}, #midday_party_state{status = ?midday_party_close} = State) ->
	NewState = lib_midday_party:act_start(State),
	{noreply, NewState};

do_handle_cast({'act_end'}, State) ->
	NewState = lib_midday_party:act_end(State),
	{noreply, NewState};

do_handle_cast({'count_exp', RoleId, ExpAdd}, State) ->
	NewState = lib_midday_party:count_exp(State, RoleId, ExpAdd),
	{noreply, NewState};

do_handle_cast({'get_exp', RoleId}, State) ->
	lib_midday_party:get_exp(State, RoleId),
	{noreply, State};


do_handle_cast({'enter', RoleId, RoleLv}, #midday_party_state{status = Status} = State) ->
	if
		Status == ?midday_party_close ->
			lib_server_send:send_to_uid(RoleId, pt_285, 28501, [?ERRCODE(err285_act_closed)]),
			pp_midday_party:send_error(RoleId, ?ERRCODE(err285_act_closed)),
			NewState = State;
		true ->
			NewState = lib_midday_party:enter(State, RoleId, RoleLv)
	end,
	{noreply, NewState};

do_handle_cast({'quit', RoleId}, State) ->
	NewState = lib_midday_party:quit(State, RoleId),
	{noreply, NewState};

do_handle_cast({'mon_be_kill', KillId, MonArgs}, State) ->
	NewState = lib_midday_party:mon_be_kill(State, KillId, MonArgs),
	{noreply, NewState};

do_handle_cast({'be_collected', CollectorId, MonArgs}, State) ->
	NewState = lib_midday_party:be_collected(State, CollectorId, MonArgs),
	{noreply, NewState};

do_handle_cast({'get_mon_reborn_time', RoleId}, State) ->
	lib_midday_party:get_mon_reborn_time(State, RoleId),
	{noreply, State};

do_handle_cast({'get_end_time', RoleId}, #midday_party_state{end_time = Time, status = ?midday_party_open} = State) ->
	{ok, Bin} = pt_285:write(28506, [Time]),
	lib_server_send:send_to_uid(RoleId, Bin),
	{noreply, State};

do_handle_cast({'gm_copy_num', Num}, State) ->
	?MYLOG("cym", "Num ~p~n", [Num]),
	{noreply, State#midday_party_state{copy_max_num = Num}};

do_handle_cast({'gm_fake_join' ,Num}, State) ->
    NeedLv = data_midday_party:get_kv(lv_limit),
    Sql_player = io_lib:format("select w.id, n.accname from player_login as n left join player_low as w on w.id = n.id where w.lv > ~p", [NeedLv]),
    case db:get_all(Sql_player) of
        [] -> ok;
        Players ->
            F_clc = fun([Id, AccName], AccList) -> lists:keystore(AccName, 1, AccList, {AccName, Id}) end,
            JoinInfos = lists:sublist(lists:foldl(F_clc, [], Players), Num),
            Now = utime:unixtime(),
            OnHookParams = [[RoleId, 285, 1, Now]||{_, RoleId} <-JoinInfos],
            Sql_onHook = usql:replace(role_activity_onhook_modules, [role_id, module_id,sub_module, select_time], OnHookParams),
            CoinParams = [[RoleId, 100, 0, Now]||{_, RoleId} <-JoinInfos],
            Sql_coin = usql:replace(role_activity_onhook_coin, [role_id, onhook_coin, exchange_left, coin_utime], CoinParams),
            Sql_onHook =/= [] andalso Sql_coin =/= [] andalso begin db:execute(Sql_onHook), db:execute(Sql_coin) end,
            lib_php_api:restart_process("{mod_activity_onhook, start_link, []}")
    end,
	{noreply, State};
do_handle_cast(_Msg, State) ->
	{noreply, State}.



do_handle_info({send_exp}, #midday_party_state{status = ?midday_party_open} = State) ->
	lib_midday_party:send_exp(State),
	{noreply, State};

do_handle_info({box_refresh, RoleId, CopyId}, State) ->
	NewState = lib_midday_party:box_refresh(RoleId, State, CopyId),
	{noreply, NewState};

do_handle_info({time_out}, State) ->
	NewState = lib_midday_party:act_end(State),
	{noreply, NewState};

do_handle_info({'mon_reborn', CopyId}, State) ->
	lib_midday_party:create_box_mon(CopyId),
	{noreply, State};




do_handle_info(_Msg, State) ->
	{noreply, State}.
