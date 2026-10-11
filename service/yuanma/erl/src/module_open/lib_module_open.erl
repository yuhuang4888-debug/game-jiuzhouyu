% %%%===================================================================
% %%% @author lxl
% %%% @doc 功能开放预告
% %%% @end
% %%% @update by 
% %%%===================================================================
-module(lib_module_open).
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-compile(export_all).

login(PS) ->
	case db:get_row(io_lib:format(<<"select `open_list` from `module_open` where role_id=~p ">>, [PS#player_status.id])) of 
		[] -> 
			%% 没有数据，可能是旧号，做一次修正数据
			init_do(PS);
		[OpenListB] ->
			%?PRINT("login:~p ~n", [util:bitstring_to_term(OpenListB)]),
			NPS = PS#player_status{open_module_list = util:bitstring_to_term(OpenListB)},
			init_do(NPS)
	end.

init_do(PS) ->
	#player_status{figure = #figure{lv = Lv, turn = Turn}, last_task_id = LastTaskId, open_module_list = OldOpenList} = PS,
	AllModIds = data_module_open:get_all(),
	NAllModIds = [Id || Id <- AllModIds, lists:keymember(Id, 1, OldOpenList) == false],
	F = fun(Id, L) ->
			case data_module_open:get_module_open(Id) of 
	    		[{Cond, _}] ->
	    			case satisfy_condition(lv, Lv, Cond) orelse satisfy_condition(turn, Turn, Cond) of
	    				true ->
	    					[{Id, 0}|L];
	    				_ ->
	    					case lists:keyfind(task, 1, Cond) of 
	    						{task, TaskId} when TaskId =< LastTaskId ->
	    							[{Id, 0}|L];
	    						_ -> L
	    					end				
	    			end;
	    		_ -> L
	    	end
	end,
	NewOpenModList = lists:foldl(F, OldOpenList, lists:sort(NAllModIds)),
	%?PRINT("NewOpenModList:~p ~n", [NewOpenModList]),
	PS#player_status{open_module_list = NewOpenModList}.

get_module_open_id_list(PS) ->
	#player_status{open_module_list = OpenModList} = PS,
	[Id ||{Id, _} <- OpenModList].


refresh_midnight() ->
	OpenDay = util:get_open_day(),
	AllModIds = data_module_open:get_all(),
	Exist = exist_open_day_module(lists:reverse(AllModIds), OpenDay),
	?PRINT("refresh_midnight Exist:~p ~n", [Exist]),
	case Exist == false of 
		true -> ok;
		_ -> 
			OnlineRoles = ets:tab2list(?ETS_ONLINE),
			[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, refresh_midnight, []) || E <- OnlineRoles],
			ok
	end.

refresh_midnight(PS) ->
	NewPS = init_do(PS),
	get_open_module_list(NewPS),
	LastPS = module_open_event(PS, NewPS),
	{ok, LastPS}.

%% 玩家等级
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = #figure{lv = PlayerLv}} = PS,
    NPS = handle_open_module_id(PS, PlayerLv, lv),
    LastPS = module_open_event(PS, NPS),
    {ok, LastPS};
handle_event(PS, #event_callback{type_id = ?EVENT_TURN_UP}) ->
	#player_status{figure = #figure{turn = Turn}} = PS,
	NPS = handle_open_module_id(PS, Turn, turn),
	LastPS = module_open_event(PS, NPS),
	{ok, LastPS};
handle_event(PS, _) ->
    {ok, PS}.

fin_task(PS, TaskId) ->
	NPS = handle_open_module_id(PS, TaskId, task),
	LastPS = module_open_event(PS, NPS),
	LastPS.

handle_open_module_id(PS, Value, Type) ->
	#player_status{id = RoleId, open_module_list = OpenModList} = PS,
    AllModIds = data_module_open:get_all(),
    NotOpenModIds = [Id || Id <- AllModIds, lists:keymember(Id, 1, OpenModList) == false],
    F = fun(Id, L) ->
    	case data_module_open:get_module_open(Id) of 
    		[{Cond, _}] ->
    			case satisfy_condition(Type, Value, Cond) of 
    				true ->
    					[{Id, 0}|L];
    				_ ->
    					L
    			end;
    		_ -> L
    	end
    end,
    ActivList = lists:foldl(F, [], lists:sort(NotOpenModIds)),
    %?PRINT("ActivList:~p ~n", [ActivList]),
    case ActivList =/= [] of 
    	true ->
    		% MaxSortId = get_max_sort_id([Id || {Id, _} <- ActivList]),
    		% NewActivList = get_all_active_id_under_sort_id(MaxSortId, NotOpenModIds),
    		NewActivList = ActivList,
    		%?PRINT("NewActivList:~p ~n", [NewActivList]),
    		NewOpenModList = NewActivList ++ OpenModList,
    		%Info = [Id || {Id, _} <- NewActivList],
    		%lib_server_send:send_to_sid(Sid, pt_138, 13802, [Info]),
    		%%db
    		Sql = usql:replace(module_open, [role_id, open_list], [[RoleId, util:term_to_bitstring(NewOpenModList)]]),
    		db:execute(Sql),
    		%?PRINT("Type:~p ,NewOpenModList:~p ~n", [Type, NewOpenModList]),
    		NPS = PS#player_status{open_module_list = NewOpenModList},
    		get_open_module_list(NPS),
    		NPS;
    	_ -> NPS = PS
    end,
    NPS.

satisfy_condition(task, Value, Cond) ->
	case lists:keyfind(task, 1, Cond) of 
		{task, NeedVal} when Value==NeedVal ->
			satisfy_openday(Cond);
		_ -> false
	end;
satisfy_condition(Type, Value, Cond) ->
	case lists:keyfind(Type, 1, Cond) of 
		{Type, NeedVal} when Value>=NeedVal ->
			satisfy_openday(Cond);
		_ -> false
	end.

satisfy_openday(Cond) ->
	case lists:keyfind(open_day, 1, Cond) of 
		{_, NeedDay} ->
			OpenDay = util:get_open_day(),
			OpenDay >= NeedDay;
		_ -> true
	end.

exist_open_day_module([], _OpenDay) -> false;
exist_open_day_module([Id|AllModIds], OpenDay) ->
	case data_module_open:get_module_open(Id) of 
		[{Cond, _}] ->
			case lists:keyfind(open_day, 1, Cond) of 
				{_, NeedDay} when OpenDay == NeedDay ->
					true;
				_ ->
					exist_open_day_module(AllModIds, OpenDay)
			end;
		_ -> exist_open_day_module(AllModIds, OpenDay)
	end.

get_max_sort_id(IdList) ->
	SortSeqList = [data_module_open:get_module_seq(Id) || Id <- IdList],
	case SortSeqList of 
		[] -> 0;
		_ -> lists:max(SortSeqList)
	end.
	
get_all_active_id_under_sort_id(MaxSortId, NotOpenModIds) ->
	F = fun(Id, List) ->
		SeqId = data_module_open:get_module_seq(Id),
		case SeqId =< MaxSortId of true -> [{Id, 0}|List]; _ -> List end
	end,
	lists:foldl(F, [], NotOpenModIds).

get_open_module_list(PS) ->
	#player_status{sid = Sid, open_module_list = OpenModList} = PS,
	{ok, Bin} = pt_138:write(13800, [OpenModList]),
	lib_server_send:send_to_sid(Sid, Bin).

finish_open_module(PS, Id, NewState1) ->
	#player_status{id = RoleId, open_module_list = OpenModList} = PS,
	case lists:keyfind(Id, 1, OpenModList) of 
		{Id, 2} -> {false, ?ERRCODE(err138_had_reward)};
		{Id, _OldState} ->
			case data_module_open:get_module_open(Id) of 
				[{_, RewardList}] -> 
					%OpenModList1 = handle_conflict_module(RoleId, Id, OpenModList),
					NewState = ?IF(NewState1 == 1, 1, 2),
					NewOpenModList = [{Id, NewState}|lists:keydelete(Id, 1, OpenModList)],
					%% db
					Sql = usql:replace(module_open, [role_id, open_list], [[RoleId, util:term_to_bitstring(NewOpenModList)]]),
    				db:execute(Sql),
    			% 	SortSeq = data_module_open:get_module_seq(Id),
    			% 	AllModIds = data_module_open:get_all_2(),
    			% 	case length([1 || {I, Seq} <- AllModIds, Seq < SortSeq, lists:keyfind(I, 1, NewOpenModList) == false]) > 0 of 
    			% 		true -> %% 存在之前没打成条件的，通过邮件发奖励
    			% 			%?PRINT("finish_open_module send mail:~p ~n", [Id]),
    			% 			Title = data_module_open:get_open_mail_title(Id),
							% Content = data_module_open:get_open_mail_content(Id),
							% lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
    			% 			PS1 = PS;
    			% 		_ ->
    				case NewState == 2 of 
    					true ->
							Produce = #produce{type = open_module, reward = RewardList, show_tips = 3},
							PS1 = lib_goods_api:send_reward(PS, Produce);
						_ ->
							PS1 = PS
					end,
					% end,
					%?PRINT("finish_open_module NewOpenModList:~p ~n", [NewOpenModList]),
					NPS = PS1#player_status{open_module_list = NewOpenModList},
					get_open_module_list(NPS),
					{true, NPS};
				_ -> {false, ?MISSING_CONFIG}
			end;
		_ -> {false, ?ERRCODE(err138_not_open)}
	end.

handle_conflict_module(RoleId, Id, OpenModList) ->
	NotRewardList = [Id1 ||{Id1, S1} <- OpenModList, Id1 =/= Id, S1 == 0],
	F = fun(Id1, L) ->
		case data_module_open:get_module_open(Id1) of 
			[{_, RewardList}] -> 
				Title = data_module_open:get_open_mail_title(Id1),
				Content = data_module_open:get_open_mail_content(Id1),
				lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
				[{Id1, 1}|lists:keydelete(Id1, 1, L)];
			_ ->
				L
		end
	end,
	lists:foldl(F, OpenModList, NotRewardList).


%% 功能开放事件
module_open_event(PS, NPS) ->
	OldOpenList = PS#player_status.open_module_list,
	NewOpenList = NPS#player_status.open_module_list,
	AddList = [Id ||{Id, _} <- NewOpenList, lists:keymember(Id, 1, OldOpenList) == false],
	module_open_event_event(NPS, AddList).

module_open_event_event(NPS, []) -> NPS;
module_open_event_event(NPS, [Id|AddList]) ->
	NNPS = lib_push_gift_api:module_open(NPS, Id),
	module_open_event_event(NNPS, AddList).