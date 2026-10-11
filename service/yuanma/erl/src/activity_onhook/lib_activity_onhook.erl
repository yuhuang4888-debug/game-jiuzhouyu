% %% ---------------------------------------------------------------------------
% %% @doc lib_activity_onhook
% %% @author 
% %% @since  
% %% @deprecated  
% %% ---------------------------------------------------------------------------
-module(lib_activity_onhook).

-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("guild.hrl").
-include("activity_onhook.hrl").

%% 查看托管列表
send_activity_onhook_list(PS) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	mod_activity_onhook:send_activity_onhook_list(RoleId, Sid).

send_activity_onhook_record(PS) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	mod_activity_onhook:send_activity_onhook_record(RoleId, Sid).

%% 选择托管
select_module(PS, ModId, SubId) ->
	case is_onhook_open() of 
		true ->
			#player_status{id = RoleId, sid = Sid} = PS,
			case data_activity_onhook:get_module(ModId, SubId) of 
				#base_activity_onhook_module{condition = Condition} ->
					{_, LimitList} = ulists:keyfind(join, 1, Condition, {join, []}),
					case check_join_limit(LimitList, PS) of 
						true ->
							mod_activity_onhook:select_module(RoleId, ModId, SubId);
						{fail, ErrCode} ->
							lib_server_send:send_to_sid(Sid, pt_192, 19202, [ErrCode, ModId, SubId])
					end;
				_ ->
					lib_server_send:send_to_sid(Sid, pt_192, 19202, [?MISSING_CONFIG, ModId, SubId])
			end;
		_ ->
			ok
	end.

cancel_select_module(PS, ModId, SubId) ->
	mod_activity_onhook:cancel_select_module(PS#player_status.id, ModId, SubId).

select_module_behaviour(PS, ModId, SubId, BehaviourId, Times) ->
	case is_onhook_open() of
		true ->
			#player_status{id = RoleId, sid = Sid} = PS,
			case data_activity_onhook:get_module(ModId, SubId) of
				#base_activity_onhook_module{condition = Condition} ->
					{_, LimitList} = ulists:keyfind(join, 1, Condition, {join, []}),
					case check_join_limit(LimitList, PS) of
						true ->
							case data_activity_onhook:get_module_bahaviour(ModId, SubId, BehaviourId) of
								#base_activity_onhook_module_behaviour{} ->
									mod_activity_onhook:select_module_behaviour(RoleId, ModId, SubId, BehaviourId, Times);
								_ ->
									lib_server_send:send_to_sid(Sid, pt_192, 19204, [?MISSING_CONFIG, ModId, SubId, BehaviourId, Times])
							end;
						{fail, ErrCode} ->
							lib_server_send:send_to_sid(Sid, pt_192, 19204, [ErrCode, ModId, SubId, BehaviourId, Times])
					end;
				_ ->
					lib_server_send:send_to_sid(Sid, pt_192, 19204, [?MISSING_CONFIG, ModId, SubId, BehaviourId, Times])
			end;
		_ ->
			ok
	end.

cancel_select_module_behaviour(PS, ModId, SubId, BehaviourId) ->
	mod_activity_onhook:cancel_select_module_behaviour(PS#player_status.id, ModId, SubId, BehaviourId).

check_join_limit([], _PS) -> true;
check_join_limit([{lv, Value}|LimitList], PS) ->
	case PS#player_status.figure#figure.lv >= Value of 
		true -> check_join_limit(LimitList, PS);
		_ -> {fail, ?LEVEL_LIMIT}
	end;
check_join_limit([{vip, Value}|LimitList], PS) ->
	case PS#player_status.figure#figure.vip >= Value of 
		true -> check_join_limit(LimitList, PS);
		_ -> {fail, ?VIP_LIMIT}
	end;
check_join_limit([{guild, _}|LimitList], PS) ->
	case PS#player_status.guild#status_guild.id >= 0 of 
		true -> check_join_limit(LimitList, PS);
		_ -> {fail, ?ERRCODE(err403_join_a_guild)}
	end;
check_join_limit([_|_LimitList], PS) ->
	check_join_limit(_LimitList, PS).


send_bgold_week_reset(RoleRewardsSendList) ->
	spawn(fun() ->
		Title = utext:get(1920003),
		F = fun({RoleId, BGold}) ->
			Content = utext:get(1920004, [BGold]),
			lib_mail_api:send_sys_mail([RoleId], Title, Content, [{?TYPE_BGOLD, 0, BGold}]),
			timer:sleep(100)
		end,
		lists:foreach(F, RoleRewardsSendList)
	end),
	ok.

exchange_onhook_coin(PS, ExchangeOnhookCoin) ->
	is_onhook_open() andalso mod_activity_onhook:exchange_onhook_coin(PS#player_status.id, ExchangeOnhookCoin).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 挂机逻辑
%% 这个函数是另开进程处理的，玩家之间sleep一下
start_activity_onhook(OnhookRoleList, ModuleId, SubMod, Args) ->
	F = fun({RoleId, OnhoonModule}) ->
		case check_enter_qualification(RoleId, ModuleId, SubMod, Args) of 
			true ->
				lib_fake_client:start_fake_client(RoleId, OnhoonModule),
				timer:sleep(500);
			_ -> %% 通知取消挂机
				mod_activity_onhook:cancel_role_activity_onhook(RoleId, ModuleId, SubMod, ?ERRCODE(err192_no_qualification))
		end
	end,
	lists:foreach(F, OnhookRoleList).

check_enter_qualification(RoleId, ?MOD_DRUMWAR, _, SignRoleList) ->
	case lists:member(RoleId, SignRoleList) of 
		true -> true; _ -> false
	end;
check_enter_qualification(RoleId, ?MOD_TERRITORY_WAR, _, GuildIdList) ->
	#figure{guild_id = GuildId} = lib_role:get_role_figure(RoleId), 
	case lists:member(GuildId, GuildIdList) of 
		true -> true; _ -> false
	end;
check_enter_qualification(RoleId, ?MOD_KF_1VN, _, SignRoleList) ->
	case lists:member(RoleId, SignRoleList) of 
		true -> true; _ -> false
	end;
check_enter_qualification(_, _, _, _) ->
	true.

%% 结束挂机
end_activity_onhook(CancelOnhookRoleList, Msg) ->
	F = fun({RoleId, _ModuleId, _SubMod}) ->
		lib_fake_client:close_fake_client(RoleId, Msg),
		timer:sleep(200)
	end,
	lists:foreach(F, CancelOnhookRoleList).

prase_activity_behaviour(ModuleId, SubMod, BehaviourId) ->
	case data_activity_onhook:get_module_bahaviour(ModuleId, SubMod, BehaviourId) of 
		#base_activity_onhook_module_behaviour{behaviour_list = BehaviourList} ->
			BehaviourList;
		_ ->
			[]
	end.

is_onhook_open() ->
	case data_key_value:get(1920001) of 
		Day when is_integer(Day) ->
			util:get_open_day() >= Day;
		_ -> true
	end.

get_max_value() ->
	case data_key_value:get(1920002) of
		Value when is_integer(Value) -> Value;
		_ -> 66
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% db
db_select_onhook_coin_all() ->
	db:get_all(?sql_select_onhook_coin_all).

db_replace_replace_onhook_coin_batch([]) -> ok;
db_replace_replace_onhook_coin_batch(List) ->
	F = fun({RoleId, OnhookCoin, ExchangeLeft, CoinUtime}, Acc) ->
		Values = io_lib:format(?sql_values_onhook_coin, [RoleId, OnhookCoin, ExchangeLeft, CoinUtime]),
		case Acc == [] of
			true -> Values;
			_ -> Values ++ "," ++ Acc
		end
	end,
	ValuesStr = lists:foldl(F, "", List),
	db:execute(io_lib:format(?sql_batch_replace_onhook_coin, [ValuesStr])).

db_select_onhook_modules_all() ->
	db:get_all(?sql_select_onhook_modules_all).

db_replace_onhook_modules(RoleId, OnhoonModule) ->
	#onhook_module{module_id = ModId, sub_module = SubMod, select_time = SelectTime} = OnhoonModule,
	db:execute(io_lib:format(?sql_replace_onhook_modules, [RoleId, ModId, SubMod, SelectTime])).

db_select_onhook_modules_behaviour_all() ->
	db:get_all(?sql_select_onhook_modules_behaviour_all).

db_replace_onhook_modules_behaviour(RoleId, ModId, SubMod, BehaviourId, SelectTime, Times) ->
	db:execute(io_lib:format(?sql_replace_onhook_modules_behaviour, [RoleId, ModId, SubMod, BehaviourId, SelectTime, Times])).


db_select_onhook_modules_record_all() ->
	db:get_all(?sql_select_onhook_modules_record).

db_replace_onhook_modules_record(RoleId, ModId, SubMod, OnhookTime, Result, CostCoin, NowTime) ->
	db:execute(io_lib:format(?sql_replace_onhook_modules_record, [RoleId, ModId, SubMod, OnhookTime, Result, CostCoin, NowTime])).

db_replace_onhook_modules_record_batch([]) -> ok;
db_replace_onhook_modules_record_batch(List) ->
	F = fun({RoleId, OnhookRecord}, Acc) ->
		#onhook_record{
			module_id = ModId, sub_module = SubMod, onhook_time = OnhookTime, result = Result        
        	, cost_coin = CostCoin, time = NowTime
        } = OnhookRecord,
		Values = io_lib:format(?sql_values_onhook_record, [RoleId, ModId, SubMod, OnhookTime, Result, CostCoin, NowTime]),
		case Acc == [] of
			true -> Values;
			_ -> Values ++ "," ++ Acc
		end
	end,
	ValuesStr = lists:foldl(F, "", List),
	%?MYLOG("lxl_activity", "db_replace_onhook_modules_record_batch: ~s ~n", [ValuesStr]),
	db:execute(io_lib:format(?sql_batch_replace_onhook_modules_record, [ValuesStr])).



db_delete_onhook_modules(RoleId, ModId, SubId) ->
	db:execute(io_lib:format(?sql_delete_onhook_modules, [RoleId, ModId, SubId])).

db_delete_onhook_modules_behaviour(RoleId, ModId, SubId) ->
	db:execute(io_lib:format(?sql_delete_onhook_modules_bahaviour, [RoleId, ModId, SubId])).

db_delete_onhook_modules_behaviour2(RoleId, ModId, SubId, BehaviourId) ->
	db:execute(io_lib:format(?sql_delete_onhook_modules_bahaviour2, [RoleId, ModId, SubId, BehaviourId])).