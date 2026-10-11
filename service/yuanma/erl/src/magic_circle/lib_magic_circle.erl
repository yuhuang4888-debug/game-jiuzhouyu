%%%-----------------------------------
%%% @Module      : lib_magic_circle
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 24. 十一月 2018 11:08
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_magic_circle).
-author("chenyiming").

%% API
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("def_goods.hrl").
-include("magic_circle.hrl").
%%获取基本信息
get_info(#player_status{magic_circle = MagicCircleList, id = RoleId}) ->
%%	?MYLOG("cym", "getInfo ~p~n", [MagicCircleList]),
	send_to_client(RoleId, MagicCircleList).

%% -----------------------------------------------------------------
%% @desc     功能描述  召唤魔法阵
%% @param    参数    Auto 是否自动购买  0 不自动  1  自动购买  MagicCircleLv::integer() 魔法阵等级
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
create_magic_circle(#player_status{magic_circle = MagicCircleList, id = RoleId} = Ps,
	MagicCircleLv, ?special_create_type, _Auto) ->
	%%检验是否开启中， 和免费体验flag
	case lists:keyfind(1, #magic_circle.lv, MagicCircleList) of
		#magic_circle{status = MagicCircleStatus, free_flag = FreeFlag} ->
			if
				FreeFlag == 0 ->   %%没有体验权限
					send_err_code(RoleId, ?ERRCODE(err216_not_have_free_times)),
					Ps;
				MagicCircleStatus == ?magic_circle_open ->   %%魔法阵已经开启
					send_err_code(RoleId, ?ERRCODE(err216_yet_open)),
					Ps;
				true ->  %%开启免费次数
					case data_magic_circle:get_magic_circle_by_lv(0, MagicCircleLv) of
						#data_magic_circle{last_day = LastDay} = DataMagicCircle ->
							mod_counter:plus_count(RoleId, ?MOD_MAGIC_CIRCLE, ?magic_circle_count_type, 1),
							LastPs = do_create_magic_circle(Ps, DataMagicCircle, ?special_create_type),
							EndTime = get_end_time(LastDay, ?special_create_type),  %%失效时间
							lib_log_api:log_magic_circle(RoleId, MagicCircleLv, [], 1, EndTime),
							LastPs;
						_ ->
							send_err_code(RoleId, ?MISSING_CONFIG),
							Ps
					end
			end;
		_ ->
			send_err_code(RoleId, ?ERRCODE(err216_not_have_free_times))
	end;

%% -----------------------------------------------------------------
%% @desc     功能描述  召唤魔法阵    1 检查开启等级-》 检查消耗 -》消耗 -》生成魔法阵(同步数据库) -》同步数据库 -》返回ps
%% @param    参数    Lv::integer() 魔法阵等级  1:初级魔法阵  2 高级魔法阵
%% @return   返回值  NewPs
%% @history  修改历史
%% -----------------------------------------------------------------
create_magic_circle(#player_status{figure = Figure, magic_circle = MagicCircleList, id = RoleId} = Ps, MagicCircleLv, Type, Auto) ->
	#figure{lv = Lv} = Figure,
	MagicCircle = case lists:keyfind(MagicCircleLv, #magic_circle.lv, MagicCircleList) of
		              #magic_circle{} = _M ->
			              _M;
		              _ ->
			              #magic_circle{}
	              end,
	#magic_circle{lv = OldMagicCircleLv, status = Status, free_flag = FreeFlag} = MagicCircle,
%%	OldMagcirCleLv = get_magic_lv(MagicCircle), %%两个魔法阵独立，不再有前置魔法阵的分别
%%	?MYLOG("cym", "OldMagcirCleLv ~p   MagicCircleLv  ~p ~n", [OldMagcirCleLv, MagicCircleLv]),
	IsConflict = is_conflict(MagicCircleList, MagicCircleLv),
	case data_magic_circle:get_magic_circle_by_lv(0, MagicCircleLv) of
		#data_magic_circle{lv = NeedLv} = DataMagicCircle ->
			Cost = get_right_cost(Auto, DataMagicCircle),
			if
				Lv < NeedLv ->
					send_err_code(RoleId, ?ERRCODE(err216_not_enough_lv)),
					Ps;
				Status == ?magic_circle_open andalso OldMagicCircleLv == MagicCircleLv ->
					send_err_code(RoleId, ?ERRCODE(err216_yet_open)),
					Ps;
				Status == ?magic_circle_open andalso FreeFlag == 2 ->
					send_err_code(RoleId, ?ERRCODE(err216_free_time)),
					Ps;
				IsConflict == true ->
					send_err_code(RoleId, ?ERRCODE(err216_have_higher)),
					Ps;
				true ->
					case Cost of
						[] ->
							send_err_code(RoleId, ?FAIL),
							Ps;
						_ ->
							case lib_goods_api:cost_object_list_with_check(Ps, Cost, magic_circle_cost, "") of
								{true, NewPs} ->
									case mod_counter:get_count(RoleId, ?MOD_ETERNAL_VALLEY, 1) of
										0 ->
											mod_counter:plus_count(RoleId, ?MOD_ETERNAL_VALLEY, 1, 1),
											{ok, Ps2} = lib_eternal_valley_api:trigger(NewPs, {active_magic});
										_ ->
											Ps2 = NewPs
									end,
									LastPs = do_create_magic_circle(Ps2, DataMagicCircle, Type),
									EndTime = get_end_time(DataMagicCircle#data_magic_circle.last_day, Type),  %%失效时间
									lib_log_api:log_magic_circle(RoleId, MagicCircleLv, Cost, 1, EndTime),
									LastPs;
								{false, Err, _} ->
									send_err_code(RoleId, Err),
									Ps
							end
					end
			end;
		_ ->
			send_err_code(RoleId, ?MISSING_CONFIG),
			Ps
	end.

%%
%%%%获取魔法阵等级
%%get_magic_lv(#magic_circle{lv = Lv, status = ?magic_circle_open, free_flag = Flag}) when Flag =/= 2 ->
%%	Lv;
%%get_magic_lv(_) ->
%%	0.

%%发送错误码
send_err_code(RoleId, Err) ->
	?MYLOG("cym", "Err ~p~n", [Err]),
	{ok, Bin} = pt_216:write(21600, [Err]),
	lib_server_send:send_to_uid(RoleId, Bin).

%% -----------------------------------------------------------------
%% @desc     功能描述   召唤魔法阵
%% @param    参数       Type:: integer  0: 普通召唤   1 特殊召唤   用于免费体验
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
do_create_magic_circle(#player_status{magic_circle = _OldMagicCircleList, id = RoleId, figure = F} = Ps,
	#data_magic_circle{last_day = LastDay, magic_circle_lv = MagicCircleLv,
		attr = AttrList, name = MagicCircleName}, Type) ->
	EndTime = get_end_time(LastDay, Type),  %%失效时间
	OldMagicCircleList = [X#magic_circle{show = 0} || X <- _OldMagicCircleList],  %%先将所有魔法阵都不幻化，后激活的幻化
	%%定时器
	Ref = erlang:send_after((EndTime - utime:unixtime()) * 1000, self(), {'mod', lib_magic_circle, time_out, [MagicCircleLv]}),
	NewFlag = case Type of  %% 免费体验标识
		          ?special_create_type ->
			          2;
		          _ ->
			          0
	          end,
	NewMagicCircle = #magic_circle{status = ?magic_circle_open, lv = MagicCircleLv,
		end_time = EndTime, attr = AttrList, ref = Ref, free_flag = NewFlag, show = 1},
	_NewMagicCircleList = lists:keystore(MagicCircleLv, #magic_circle.lv, OldMagicCircleList, NewMagicCircle),
	NewMagicCircleList = handle_magic_circle_list(_NewMagicCircleList, MagicCircleLv),
	NewPs = Ps#player_status{magic_circle = NewMagicCircleList},
%%	?MYLOG("cym", "NewMagicCircle ~p ~n", [NewMagicCircle]),
	%%同步数据库
	save_db(RoleId, NewMagicCircleList),
	%%计算属性
	_LastPs = lib_player:count_player_attribute(NewPs),
	lib_player:send_attribute_change_notify(_LastPs, ?NOTIFY_ATTR),
	%%通知客户端
	send_to_client(RoleId, NewMagicCircleList),
	{ok, Bin} = pt_216:write(21602, [?SUCCESS]),
	lib_server_send:send_to_uid(RoleId, Bin),
	%%传闻
	#figure{name = RoleName} = F,
	send_tv(RoleName, MagicCircleName, MagicCircleLv),
	MagicCircleFigureId = get_magic_circle_figure_id_by_lv(NewMagicCircleList),
	LastPs = _LastPs#player_status{figure = F#figure{magic_circle_figure = MagicCircleFigureId}},
	broadcast_to_scene(LastPs),  %%广播形象
	%%通知场景
	mod_scene_agent:update(LastPs, [{battle_attr, LastPs#player_status.battle_attr}]),
	%% %% 同步场景属性变化
	LastPs.

time_out(Ps, MagicCircleLv) ->
%%	?MYLOG("cym", "time_out ~n", []),
	#player_status{magic_circle = MagicCircleList, id = RoleId, figure = F} = Ps,
	MagicCircle =
		case lists:keyfind(MagicCircleLv, #magic_circle.lv, MagicCircleList) of
			#magic_circle{} = M ->
				M;
			_ ->
				#magic_circle{}
		end,
	#magic_circle{ref = Ref, end_time = EndTime} = MagicCircle,
	util:cancel_timer(Ref),
	NewMagicCircle = MagicCircle#magic_circle{show = 0, attr = [], status = ?magic_circle_close,
		ref = [], free_flag = 0, end_time = 0},
	NewMagicCircleList = lists:keystore(MagicCircleLv, #magic_circle.lv, MagicCircleList, NewMagicCircle),
	NewPs = Ps#player_status{magic_circle = NewMagicCircleList},
	%%计算属性
	LastPs = lib_player:count_player_attribute(NewPs),
	lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
	%%通知客户端
	send_expired_to_client(RoleId, NewMagicCircleList, [{?magic_circle_close, MagicCircleLv, 0, 0, 0}]),
	FigureId = get_magic_circle_figure_id_by_lv(NewMagicCircleList),
	LastPs1 = LastPs#player_status{figure = F#figure{magic_circle_figure = FigureId}},
	save_db(RoleId, NewMagicCircle),
	lib_log_api:log_magic_circle(RoleId, MagicCircleLv, [], 0, EndTime),
	broadcast_to_scene(LastPs1),
	%%通知场景
	mod_scene_agent:update(LastPs1, [{battle_attr, LastPs1#player_status.battle_attr}]),
	LastPs1.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取结束时间
%% @param    参数     Type:: integer  0: 普通召唤   1 特殊召唤   用于免费体验    LastDay持续天数
%% @return   返回值   integer()
%% @history  修改历史
%% -----------------------------------------------------------------

get_end_time(_LastDay, ?special_create_type) ->
	case data_magic_circle:get_value_by_key(free_time) of
		[Time] ->
			Time + utime:unixtime();
		_ ->
			utime:unixtime()
	end;
get_end_time(LastDay, ?common_create_type) ->
	86400 * LastDay + utime:unixtime().

%%通知客户端魔法阵状态
send_to_client(RoleId, []) ->
	{ok, Bin} = pt_216:write(21601, [[]]),
	lib_server_send:send_to_uid(RoleId, Bin);

send_to_client(RoleId, MagicCircleList) ->
	Res = lib_magic_circle_util:filter_no_expired(MagicCircleList),
	{ok, Bin} = pt_216:write(21601, [Res]),
	lib_server_send:send_to_uid(RoleId, Bin).

%% 守护过期通知客户端
send_expired_to_client(RoleId, MagicCircleList, ExpiredMagicCircle) ->
	Res = lib_magic_circle_util:filter_no_expired(MagicCircleList),
	NewRes = ExpiredMagicCircle ++ Res,
	{ok, Bin} = pt_216:write(21601, [NewRes]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%获取属性
get_attr(#player_status{magic_circle = Magic}) ->
	case Magic of
		undefined ->
			[];
		_ ->
			F = fun(#magic_circle{status = S, attr = Attr}, AccAttrList) ->
				if
					S == ?magic_circle_open ->
						AccAttrList ++ Attr;
					true ->
						AccAttrList
				end
			    end,
			lists:foldl(F, [], Magic)
	end.

%%同步数据库
save_db(_RoleId, undefined) ->
	ok;
save_db(_RoleId, []) ->
	ok;
save_db(_RoleId, [H | T] = List) when is_list(List) ->
	save_db(_RoleId, H),
	save_db(_RoleId, T);
save_db(RoleId, #magic_circle{lv = Lv, end_time = EndTime, attr = Attr, status = Status, free_flag = FreeFlag, show = Show}) ->
	NewAttr = util:term_to_string(Attr),
	Sql = io_lib:format(<<"REPLACE  into   role_magic_circle  VALUES(~p,   ~p,  ~p,  ~p,  ~p, ~p, ~p)">>,
		[RoleId, Status, Lv, EndTime, NewAttr, FreeFlag, Show]),
	db:execute(Sql).

login(#player_status{id = RoleId, figure = F} = Ps) ->
	Sql = io_lib:format(<<"select  status, lv , end_time,  attr , free_flag , `show`  from  role_magic_circle  where role_id =  ~p">>, [RoleId]),
	List = db:get_all(Sql),
	F1 = fun([Status, Lv, EndTime, DbAttr, FreeFlag, Show], AccList) ->
		NewAttr = util:bitstring_to_term(DbAttr),
		MagicCirCle = #magic_circle{lv = Lv, status = Status, end_time = EndTime, show = Show,
			attr = NewAttr, ref = [], free_flag = FreeFlag},
		lists:keystore(Lv, #magic_circle.lv, AccList, MagicCirCle)
	     end,
	NewMagicCircleList= lists:foldl(F1, [], List),
	MagicCirCleFigureId = get_magic_circle_figure_id_by_lv(NewMagicCircleList),
	save_db(RoleId, NewMagicCircleList),
	Ps#player_status{magic_circle = NewMagicCircleList, figure = F#figure{magic_circle_figure = MagicCirCleFigureId}}.

%%玩家升级回调事件
handle_event(#player_status{figure = _F, id = _RoleId} = Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
%%	#figure{lv = Lv} = F,
%%	case data_magic_circle:get_magic_circle_by_lv(0, 2) of
%%		#data_magic_circle{lv = LimitLv} ->
%%			if
%%				Lv == LimitLv ->
%%					?MYLOG("cym", "magiccircle Lv ~p~n", [2]),
%%					{ok, Bin} = pt_216:write(21603, [2]),
%%					lib_server_send:send_to_uid(RoleId, Bin);
%%				true ->
%%					ok
%%			end;
%%		_ ->
%%			ok
%%	end,
	{ok, Player}.

%%	case data_magic_circle:get_value_by_key(free_lv) of
%%		[] ->
%%			{ok, Player};
%%		[FreeLvList] ->
%%			case lists:keyfind(Lv, 1, FreeLvList) of
%%				false ->
%%					{ok, Player};
%%				{Lv, MagicCircleLv} ->  %%可以发送免费体验信息
%%					Count = mod_counter:get_count(RoleId, ?MOD_MAGIC_CIRCLE, ?magic_circle_count_type),
%%					Limit = mod_counter:get_limit_by_type(?MOD_MAGIC_CIRCLE, ?magic_circle_count_type),
%%%%					?MYLOG("cym",  "Count ~p  Limit ~p  MagicCircleStatus ~p ~n",  [Count, Limit, MagicCircleStatus]),
%%					case Count < Limit andalso MagicCircleStatus == ?magic_circle_close of
%%						true ->
%%%%							?MYLOG("cym",  "free_ex Lv ~p~n",  [MagicCircleLv]),
%%							{ok, Bin} = pt_216:write(21603, [MagicCircleLv]),
%%							lib_server_send:send_to_uid(RoleId, Bin),
%%							NewMagicCircle = MagicCircle#magic_circle{free_flag = 1, lv = MagicCircleLv},
%%							{ok, Player#player_status{magic_circle = NewMagicCircle}};
%%						false ->
%%							{ok, Player}
%%					end
%%			end
%%	end.

%%开启体验初级魔法阵
finish(#player_status{magic_circle = MagicCircleList, id = RoleId} = Player) ->
	MagicCircle =
		case lists:keyfind(1, #magic_circle.lv, MagicCircleList) of  %%初级魔法阵才有免费体验
			#magic_circle{} = M ->
				M;
			_ ->
				#magic_circle{}
		end,
	#magic_circle{status = MagicCircleStatus} = MagicCircle,
	Count = mod_counter:get_count(RoleId, ?MOD_MAGIC_CIRCLE, ?magic_circle_count_type),
	Limit = mod_counter:get_limit_by_type(?MOD_MAGIC_CIRCLE, ?magic_circle_count_type),
%%	?MYLOG("cym", "Count ~p  Limit ~p  MagicCircleStatus ~p ~n", [Count, Limit, MagicCircleStatus]),
	case Count < Limit andalso MagicCircleStatus == ?magic_circle_close of
		true ->
%%			?MYLOG("cym", "free_ex Lv ~p~n", [1]),
			{ok, Bin} = pt_216:write(21603, [1]),
			lib_server_send:send_to_uid(RoleId, Bin),
			NewMagicCircle = MagicCircle#magic_circle{free_flag = 1, lv = 1},
			NewMagicCircleList = lists:keystore(1, #magic_circle.lv, MagicCircleList, NewMagicCircle),
			save_db(RoleId, NewMagicCircleList),
			Player#player_status{magic_circle = NewMagicCircleList};
		false ->
			Player
	end.

%%离线处理
logout(#player_status{magic_circle = _MagicCircleList, id = _RoleId}) ->
	skip.
%%	MagicCircle =
%%		case lists:keyfind(1, #magic_circle.lv, MagicCircleList) of  %%初级魔法阵才有可能有免费体验
%%			#magic_circle{} = M ->
%%				M;
%%			_ ->
%%				#magic_circle{}
%%		end,
%%	#magic_circle{free_flag = FreeFlag, lv = MagicCircleLv, status = Status} = MagicCircle,
%%	case FreeFlag of
%%		1 ->
%%			case data_magic_circle:get_magic_circle_by_lv(0, MagicCircleLv) of
%%				#data_magic_circle{attr = AttrList} ->
%%					case Status of
%%						?magic_circle_close ->
%%%%							?MYLOG("cym", "logout free ex ~n", []),
%%							EndTime = get_end_time(0, ?special_create_type),      %%失效时间
%%							NewMagicCircle = #magic_circle{status = ?magic_circle_open, lv = MagicCircleLv,
%%								end_time = EndTime, attr = AttrList, ref = [], free_flag = 2, show = 1},
%%							%%同步数据库
%%							save_db(RoleId, NewMagicCircle);
%%						_ ->
%%							skip
%%					end;
%%				_ ->
%%					ok
%%			end;
%%		_ ->
%%			skip
%%	end.

delay_stop(#player_status{magic_circle = MagicCircleList, id = _RoleId} = PS) ->
	F = fun(MagicCirCle) ->
		#magic_circle{ref = Ref} = MagicCirCle,
		util:cancel_timer(Ref)
			end,
	lists:foreach(F, MagicCircleList),
	PS.

%%获取魔法阵的形象id
get_magic_circle_figure_id_by_lv(MagicCircleList) when is_list(MagicCircleList) ->
	F = fun(MagicCircle, Acc) ->
		#magic_circle{lv = Lv, status = Status, show = Show} = MagicCircle,
		if
			Status == ?magic_circle_open andalso Show == 1 ->
				Lv + Acc;
			true ->
				Acc
		end
	    end,
	Id = lists:foldl(F, 0, MagicCircleList),
	case Id of
		1 ->  %%调皮小鬼
			[FigureId] = data_magic_circle:get_value_by_key(high_magic_circle_id),
			FigureId;
		2 ->  %%蛋壳天使
			[FigureId] = data_magic_circle:get_value_by_key(low_magic_circle_id),
			FigureId;
		3 ->  %%调皮恶魔
			[FigureId] = data_magic_circle:get_value_by_key(naughty_devil_figure),
			FigureId;
		4 ->  %%守护天使
			[FigureId] = data_magic_circle:get_value_by_key(guardian_angel_figure),
			FigureId;
		_ ->
			0
	end.

%%广播
broadcast_to_scene(#player_status{figure = F, id = RoleId, x = X, y = Y,
	scene = Sid, scene_pool_id = PoolId, copy_id = CopyId}) ->
	#figure{magic_circle_figure = MagicCircleFigure} = F,
%%	?MYLOG("cym", "broadcast RoleId ~p MagicCircleFigure  ~p~n",  [RoleId, MagicCircleFigure]),
	{ok, Bin} = pt_216:write(21604, [RoleId, MagicCircleFigure]),
	lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, Bin).

get_free_flag(2) ->
	1;   %%1 标识正在体验
get_free_flag(_) ->
	0.

%% -----------------------------------------------------------------
%% @desc     功能描述  幻化
%% @param    参数     Show  0:不幻化  1：幻化
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
show_magic_circle(#player_status{magic_circle = _OldMagicCircleList, id = RoleId, figure = F} = Ps, MagicCircleLv, IsShow) ->
	MagicCircleList = [X#magic_circle{show = 0} || X <- _OldMagicCircleList],  %%先将所有魔法阵都不幻化，后激活的幻化
	MagicCircle =
		case lists:keyfind(MagicCircleLv, #magic_circle.lv, MagicCircleList) of
			#magic_circle{} = M ->
				M;
			_ ->
				#magic_circle{}
		end,
	#magic_circle{status = S} = MagicCircle,
	if
		S == ?magic_circle_close ->
			send_err_code(RoleId, ?ERRCODE(err216_show)),
			Ps;
		true ->
			NewMagicCircle = MagicCircle#magic_circle{show = IsShow},
			NewMagicCircleList = lists:keystore(MagicCircleLv, #magic_circle.lv, MagicCircleList, NewMagicCircle),
			save_db(RoleId, NewMagicCircleList),
			FigureId = get_magic_circle_figure_id_by_lv(NewMagicCircleList),
			NewPs = Ps#player_status{figure = F#figure{magic_circle_figure = FigureId}, magic_circle = NewMagicCircleList},
			broadcast_to_scene(NewPs),
			send_to_client(RoleId, NewMagicCircleList),%%通知客户端，
			NewPs
	end.
%%show_magic_circle(#player_status{magic_circle = MagicCircleList, id = RoleId, figure = F} = Ps, MagicCircleLv, 1) ->
%%%%	?MYLOG("cym",  "MagicCircle ~p~n",  [MagicCircle]),
%%	MagicCircle =
%%		case lists:keyfind(MagicCircleLv, #magic_circle.lv, MagicCircleList) of
%%			#magic_circle{} = M ->
%%				M;
%%			_ ->
%%				#magic_circle{}
%%		end,
%%	#magic_circle{show = Show, status = Status} = MagicCircle,
%%	if
%%		Show == 1 ->
%%			send_err_code(RoleId, ?ERRCODE(err216_show)),
%%			Ps;
%%		Status == ?magic_circle_close ->
%%			send_err_code(RoleId, ?ERRCODE(err216_show)),
%%			Ps;
%%		true ->
%%			NewMagicCircle = MagicCircle#magic_circle{show = 1},
%%			save_db(RoleId, NewMagicCircle),
%%			NewMagicCircleList = lists:keystore(MagicCircleLv, #magic_circle.lv, MagicCircleList, NewMagicCircle),
%%			FigureId = get_magic_circle_figure_id_by_lv(NewMagicCircleList),
%%			NewPs = Ps#player_status{figure = F#figure{magic_circle_figure = FigureId}, magic_circle = NewMagicCircleList},
%%			broadcast_to_scene(NewPs),
%%			send_to_client(RoleId, NewMagicCircleList),%%通知客户端，
%%			NewPs
%%	end.

get_exp_ratio_with_end_time(MagicCircleList) ->
	F = fun(#magic_circle{attr = Attr, end_time = EndTime}, {AccRatio, AccEndTime}) ->
		case lists:keyfind(?EXP_ADD, 1, Attr) of
			false ->
				{AccRatio, AccEndTime};
			{_, ExpRatio} ->
				{ExpRatio + AccRatio, max(EndTime, AccEndTime)}
		end
	end,
	lists:foldl(F, {0, 0}, MagicCircleList).

get_exp_ratio(MagicCircleList) ->
	F = fun(#magic_circle{attr = Attr}, Acc) ->
		case lists:keyfind(?EXP_ADD, 1, Attr) of
			false ->
				Acc;
			{_, ExpRatio} ->
				ExpRatio + Acc
		end
	    end,
	ExpRatio = lists:foldl(F, 0, MagicCircleList),
%%	?MYLOG("cym", "ExpRatio ~p~n", [ExpRatio]),
	ExpRatio.


get_right_cost(Auto, #data_magic_circle{cost = ListCost}) ->
	case lists:keyfind(Auto, 1, ListCost) of
		{_, Cost} ->
			Cost;
		_ ->
			[]
	end.

%% 是否冲突， 如果有永久的天使恶魔，是不能激活低阶的
is_conflict(MagicCircleList, MagicCircleLv) ->
	if
		MagicCircleLv > 2 ->  %% 如果是3 4 魔法阵，不需考虑
			false;
		true ->
			case lists:keyfind(MagicCircleLv + 2, #magic_circle.lv, MagicCircleList) of
				#magic_circle{status = ?magic_circle_open} ->
					true;
				_ ->
					false
			end
	end.

%% 处理激活永久
handle_magic_circle_list(MagicCircleList, MagicCircleLv) ->
	if
		MagicCircleLv > 2 ->
			case lists:keyfind(MagicCircleLv - 2, #magic_circle.lv, MagicCircleList) of
				#magic_circle{ref = Ref} = MagicCircle ->
					util:cancel_timer(Ref),
					NewMagicCircle = MagicCircle#magic_circle{status = ?magic_circle_close, end_time = 0, show = 0, ref = [], attr = []},
					lists:keystore(MagicCircleLv - 2, #magic_circle.lv, MagicCircleList, NewMagicCircle);
				_ ->
					MagicCircleList
			end;
		true ->
			MagicCircleList
	end.

check_goods_compose(PlayerStatus, GoodsStatus, RuleId, CombineNum, RegularList, IrRegularList) ->
	case lib_goods_check:check_compose_cfg(RuleId, PlayerStatus, [], []) of
		{ok, _ComposeCfg}
			when PlayerStatus#player_status.figure#figure.lv >= _ComposeCfg#goods_compose_cfg.role_lv andalso _ComposeCfg#goods_compose_cfg.type == ?COMPOSE_GOODS ->
			#goods_compose_cfg{
				condition = Condition,
				cost = CostList
			} = _ComposeCfg,
			ComposeCfg = check_compose_cfg(_ComposeCfg, PlayerStatus, RuleId),
%%			?MYLOG("compose", "RuleId~p~n", [RuleId]),
%%			?MYLOG("compose", "regularMat ~p, RegularList ~p~n", [ComposeCfg#goods_compose_cfg.regular_mat, RegularList]),
			case lib_goods_check:check_list(PlayerStatus, Condition) of
				true ->
					case lib_goods_api:check_object_list(PlayerStatus, CostList) of
						true ->
							lib_goods_check:check_goods_compose_simple_do(PlayerStatus, GoodsStatus, ComposeCfg, CombineNum, RegularList, IrRegularList);
						{false, ErrorCode} ->
							{fail, ErrorCode}
					end;
				{false, ErrorCode} ->
					{fail, ErrorCode}
			end;
		{ok, _ComposeCfg} ->
			{fail, ?ERRCODE(err150_not_satisfy_compose_lv)};
		{fail, ErrorCode} ->
			{fail, ErrorCode}
	end.

check_compose_cfg(ComposeCfg, PlayerStatus, 26021) -> %%守护天使合成
	%%是否激活了蛋壳天使
	Now = utime:unixtime(),
	#player_status{magic_circle = MagicCircle} = PlayerStatus,
	case lists:keyfind(?eggshell_angel, #magic_circle.lv, MagicCircle) of
		#magic_circle{status = ?magic_circle_open, end_time = Time} when Time > Now ->  %% 已经激活了蛋壳天使
			#goods_compose_cfg{regular_mat = RegularMat} = ComposeCfg,
%%			NewRegularMat = lists:keydelete(38040014, 2, RegularMat),  %% 去除蛋壳天使的消耗
			NewRegularMat = [[{Type, GoodsId, Num}] || [{Type, GoodsId, Num}] <- RegularMat, GoodsId =/= 38040014],  %% 去除调皮小鬼的消耗
			ComposeCfg#goods_compose_cfg{regular_mat = NewRegularMat};
		_ ->
			ComposeCfg
	end;
check_compose_cfg(ComposeCfg, PlayerStatus, 26011) -> %%恶魔合成
	%%是否激活了调皮小鬼
%%	?MYLOG("compose", "RuleId  ~p~n", [26011]),
	Now = utime:unixtime(),
	#player_status{magic_circle = MagicCircle} = PlayerStatus,
	case lists:keyfind(?naughty_imp, #magic_circle.lv, MagicCircle) of
		#magic_circle{status = ?magic_circle_open, end_time = Time} when Time > Now ->  %% 已经激活了蛋壳天使
			#goods_compose_cfg{regular_mat = RegularMat} = ComposeCfg,
			NewRegularMat = [[{Type, GoodsId, Num}] || [{Type, GoodsId, Num}] <- RegularMat, GoodsId =/= 38040013],  %% 去除调皮小鬼的消耗
			ComposeCfg#goods_compose_cfg{regular_mat = NewRegularMat};
		_ ->
			ComposeCfg
	end;
check_compose_cfg(ComposeCfg, _PlayerStatus, _26011) -> %%恶魔合成
	ComposeCfg.

send_tv(RoleName, MagicCircleName, Lv) ->
	if
		Lv > ?eggshell_angel ->
			lib_chat:send_TV({all}, ?MOD_MAGIC_CIRCLE, 2, [RoleName, ulists:list_to_bin(MagicCircleName)]);
		true ->
			lib_chat:send_TV({all}, ?MOD_MAGIC_CIRCLE, 1, [RoleName, ulists:list_to_bin(MagicCircleName)])
	end.

get_figure_on_db(RoleId) ->
	Sql = io_lib:format(<<"select  status, lv , end_time,  attr , free_flag , `show`  from  role_magic_circle  where role_id =  ~p">>, [RoleId]),
	List = db:get_all(Sql),
	F1 = fun([Status, Lv, EndTime, DbAttr, FreeFlag, Show], AccList) ->
		NewAttr = util:bitstring_to_term(DbAttr),
		%%检查有没有失效
		case EndTime > utime:unixtime() of
			true ->%%还有效
				MagicCirCle = #magic_circle{lv = Lv, status = Status, end_time = EndTime, show = Show,
					attr = NewAttr, free_flag = FreeFlag},
				lists:keystore(Lv, #magic_circle.lv, AccList, MagicCirCle);
			false ->  %%无效
				MagicCirCle = #magic_circle{lv = Lv, status = ?magic_circle_close, end_time = EndTime, show = 0,
					attr = [], ref = [], free_flag = FreeFlag},
				lists:keystore(Lv, #magic_circle.lv, AccList, MagicCirCle)
		end
	     end,
	NewMagicCircleList = lists:foldl(F1, [], List),
	get_magic_circle_figure_id_by_lv(NewMagicCircleList).

re_login(PS) ->
	#player_status{magic_circle = MagicCircle, id = RoleId} = PS,
	[if
		 Flag == 1 ->
			 {ok, Bin} = pt_216:write(21603, [1]),
			 lib_server_send:send_to_uid(RoleId, Bin);
		 true ->
			 skip
	 end ||#magic_circle{free_flag = Flag} <-MagicCircle].

%% 登录检查守护是否过期
login_check_expired(Player) ->
	#player_status{id = RoleId, magic_circle = MagicCircleList,figure = Figure} = Player,
	F = fun(MagicCirCle, {AccList, ExpiredList}) ->
		#magic_circle{lv = Lv, end_time = EndTime, free_flag = FreeFlag} = MagicCirCle,
		if
			FreeFlag == 1 ->
				{ok, Bin} = pt_216:write(21603, [1]),
				lib_server_send:send_to_uid(RoleId, Bin);
			true -> skip
		end,
		case EndTime > utime:unixtime() of
			true ->
				Ref = erlang:send_after(max((EndTime - utime:unixtime()) * 1000, 500), self(), {'mod', lib_magic_circle, time_out, [Lv]}),
				NewMagicCirCle = MagicCirCle#magic_circle{ref = Ref},
				{lists:keystore(Lv, #magic_circle.lv, AccList, NewMagicCirCle), ExpiredList};
			false ->
				if
					EndTime == 0 -> Expired = ExpiredList;
					true ->
						lib_log_api:log_magic_circle(RoleId, Lv, [], 0, EndTime),
						Expired = [{?magic_circle_close, Lv, 0, 0, 0} | ExpiredList]
				end,
				NewMagicCirCle = MagicCirCle#magic_circle{status = ?magic_circle_close, end_time = 0, show = 0, attr = [], ref = []},
				{lists:keystore(Lv, #magic_circle.lv, AccList, NewMagicCirCle), Expired}
		end
			end,
	{NewMagicCircleList, NewExpiredList} = lists:foldl(F, {[], []}, MagicCircleList),
	?IF(length(NewExpiredList) == 0, lib_magic_circle:send_to_client(RoleId, NewMagicCircleList),  lib_magic_circle:send_expired_to_client(RoleId, NewMagicCircleList, NewExpiredList)),
	MagicCirCleFigureId =  lib_magic_circle:get_magic_circle_figure_id_by_lv(NewMagicCircleList),
	lib_magic_circle:save_db(RoleId, NewMagicCircleList),
	Player#player_status{magic_circle = NewMagicCircleList, figure = Figure#figure{magic_circle_figure = MagicCirCleFigureId}}.




