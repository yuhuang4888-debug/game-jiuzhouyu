%%%--------------------------------------
%%% @Module  : lib_liveness
%%% @Author  : xiaoxiang
%%% @Created : 2017-07-10
%%% @Description:  玩家活跃度形象
%%%--------------------------------------
-module(lib_liveness).
-export([

]).
-compile(export_all).
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("activitycalen.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("common.hrl").

%%----------------------------------------------------------------回调函数-------------------------------------------------------------------
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    OpenLv = lib_module:get_open_lv(?MOD_ACTIVITY, 1),
    if
        Lv < OpenLv -> {ok, PS};
        true ->
            NewPS = login_for_liveness_back(PS),
            lib_player_event:remove_listener(?EVENT_LV_UP, lib_liveness, handle_event),  %%去掉监听
            {ok, NewPS}
    end;
handle_event(PS, #event_callback{type_id = ?EVENT_PARTICIPATE_ACT, data = Data}) ->
	#act_data{act_id = ActId, act_sub = ActSub, num = Num} = Data,
	#player_status{figure = #figure{lv = Lv}} = PS,
	case lib_module:is_open(?MOD_ACTIVITY, 1, Lv) of
		true ->
			increase_ps_act_status(PS, {ActId, ActSub, Num});
		false -> {ok, PS}
	end;

handle_event(PS,  #event_callback{type_id = ?EVENT_MOUNT_LVUP}) ->
    lib_activitycalen_api:role_success_end_activity(PS, ?MOD_MOUNT,  1),
    {ok, PS};

handle_event(PS,  #event_callback{type_id = ?EVENT_FLY_LVUP}) ->
    lib_activitycalen_api:role_success_end_activity(PS, ?MOD_MOUNT,  3),
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.
%%----------------------------------------------------------------回调函数-------------------------------------------------------------------

increase_ps_act_status(PS, {?MOD_DUNGEON, _ActSub, Num}) ->
    Is = lib_activitycalen:is_materials_dungeon(?MOD_DUNGEON, _ActSub),
    if
        Is == true ->
            ActId  = ?MOD_DUNGEON,
            ActSub = ?DUNGEON_TYPE_MON_MATERIALS;
        true ->
            ActId  = ?MOD_DUNGEON,
            ActSub = _ActSub
    end,
    ActIds = data_activitycalen:get_live_key(),
    case lists:member({ActId, ActSub}, ActIds) of
        true -> increase_ps_act_status_do(PS, {ActId, ActSub, Num});
        false -> {ok, PS}
    end;
increase_ps_act_status(PS, {ActId, ActSub, Num}) ->
	ActIds = data_activitycalen:get_live_key(),
	case lists:member({ActId, ActSub}, ActIds) of
		true -> increase_ps_act_status_do(PS, {ActId, ActSub, Num});
		false -> {ok, PS}
	end.

increase_ps_act_status_do(PS, {ActId, ActSub, Num}) ->
	#player_status{id = RoleId, liveness_back = LiveNessBack} = PS,
	#liveness_back{res_act_map = ResActMap} = LiveNessBack,
	{NeedUpdateDb, NewResActMap} = update_today_res_act(PS, ResActMap, {ActId, ActSub, Num}),
	NewLiveNessBack = LiveNessBack#liveness_back{res_act_map = NewResActMap},
	case NeedUpdateDb of
		true -> db_update_liveness_back(RoleId, NewLiveNessBack);
		false -> skip
	end,
	NewPS = PS#player_status{liveness_back = NewLiveNessBack},
	{ok, NewPS}.

%%更新活跃度信息
update_today_res_act(_PS, ResActMap, {ActId, ActSub, Num}) ->
    Today = maps:get(?TODAY_LIVE, ResActMap, #{}),
    case maps:get({ActId, ActSub}, Today, none) of
        #res_act_live{lefttimes = LeftTimes, state = State} = ResAct when State == ?STATE_NOT_FIND_LIVE ->
            NewLeftTime = max(LeftTimes - Num, 0),
            NewState = ?IF(NewLeftTime == 0, ?STATE_FINISHED_LIVE, ?STATE_NOT_FIND_LIVE),
            NewResAct = ResAct#res_act_live{lefttimes = NewLeftTime, state = NewState},
            NewToday = maps:put({ActId, ActSub}, NewResAct, Today),
            {true, maps:put(?TODAY_LIVE, NewToday, ResActMap)};
        #res_act_live{} -> {false, ResActMap};
        none ->
            Limit = get_act_limit(ActId, ActSub),
            LeftTimes = max(Limit - Num, 0),
            State = ?IF(LeftTimes == 0, ?STATE_FINISHED_LIVE, ?STATE_NOT_FIND_LIVE),
            ResAct = #res_act_live{act_id = ActId, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State},
            NewToday = maps:put({ActId, ActSub}, ResAct, Today),
            {true, maps:put(?TODAY_LIVE, NewToday, ResActMap)}
    end.


login(RoleId) ->
    [Lv, Liveness, Id, DisplayStatus] = db_player_liveness_select(RoleId),
    Attr = case data_activitycalen:get_liveness(Lv) of
               #base_liveness_lv{attr = TmpAttr} -> TmpAttr;
               _ -> []
           end,
    FigureId = case data_activitycalen:get_liveness_active(Id) of
                   #base_liveness_active{figure_id = TmpFigure} -> TmpFigure;
                   _ -> 0
               end,
    AttrR = lib_player_attr:to_attr_record(Attr),
    Combat = lib_player:calc_all_power(AttrR),
    #st_liveness{lv = Lv, liveness = Liveness, id = Id, figure_id = FigureId, attr = Attr, combat = Combat, display_status = DisplayStatus}.

%%活跃度找回，初始化
login_for_liveness_back(PS) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    case lib_module:is_open(?MOD_ACTIVITY, 1, Lv) of  %%活跃度是否支持找回
        true ->
            ActIds = data_activitycalen:get_live_key(), %%获取所有的活跃度id
            {OldClearTime, ResActMap}
                = case db_select_res_act_list(RoleId) of
                [] ->
                    Today = init_today_res_act(PS, ActIds),
                    {get_today_clear_time(), maps:put(?TODAY_LIVE, Today, #{})};
                List ->
                    F = fun(Item, {_Time, Map}) ->
                        [ClearTime1, DayType, ActList_B] = Item,
                        ActList = util:bitstring_to_term(ActList_B),
                        ResActMap = make_res_act_map(DayType, PS, ActIds, ActList),
                        {ClearTime1, maps:put(DayType, ResActMap, Map)}
                    end,
                    lists:foldl(F, {NowTime, #{}}, List)
            end,
            LiveNessBack = update_res_act_login(PS, ResActMap, OldClearTime, NowTime),
            NewPS = PS#player_status{liveness_back = LiveNessBack},
            db_update_liveness_back(RoleId, LiveNessBack),
            NewPS;
        false ->
            lib_player_event:add_listener(?EVENT_LV_UP, lib_liveness, handle_event, []),
            PS#player_status{liveness_back  = #liveness_back{}}
    end.


get_liveness_figure_on_db(RoleId) ->
    [_, _, Id, DisplayStatus] = db_player_liveness_select(RoleId),
    case data_activitycalen:get_liveness_active(Id) of
        #base_liveness_active{figure_id = FigureId} -> skip;
        _ -> FigureId = 0
    end,
    FigureId * DisplayStatus.

%% 增加活跃度
add_liveness(Player, Value) ->
    #player_status{id = RoleId, st_liveness = StLiveness} = Player,
    case misc:is_process_alive(misc:get_player_process(RoleId)) of
        true ->
            #st_liveness{lv = Lv, liveness = Liveness} = StLiveness,
            NewStLiveness = StLiveness#st_liveness{liveness = Liveness + Value},
            NewPlayer = Player#player_status{st_liveness = NewStLiveness},
            db_player_liveness_replace(RoleId, NewStLiveness),
            %% 总活跃度满足升级 通知客户端更新用
            case data_activitycalen:get_liveness(Lv) of
                #base_liveness_lv{lv = Lv, liveness = UpLiveness} ->
                    case NewStLiveness#st_liveness.liveness >= UpLiveness of
                        true -> get_player_liveness(NewPlayer);
                        _ -> skip
                    end;
                _ -> skip
            end,
            %% 更新奖励状态 通知客户端
            Data = #callback_activity_live{activity_live = Liveness + Value, add_value = Value},
            lib_player_event:async_dispatch(RoleId, ?EVENT_ADD_LIVENESS, Data),
            refresh_live_reward(RoleId),
            %% 更新 每日活跃转盘 奖励状态
            lib_daily_turntable:refresh_daily_turntable_liveness(NewPlayer),
            lib_custom_act_api:refresh_supply_liveness(NewPlayer),
            {ok, NewPlayer};
        false ->
            F = fun() ->
                [Lv, Liveness, Id, DisplayStatus] = db_player_liveness_select(RoleId),
                db_player_liveness_replace(RoleId, #st_liveness{lv = Lv, id = Id, liveness = Liveness + Value, display_status = DisplayStatus})
                end,
            catch db:transaction(F),
            {ok, Player}
    end.

liveness_sum(Lv, Acc) when Lv < 1 -> Acc;
liveness_sum(Lv, Acc) ->
    Acc1 = case data_activitycalen:get_liveness(Lv) of
        #base_liveness_lv{liveness = UpLiveness} -> Acc+UpLiveness;
        _ -> Acc
    end,
    liveness_sum(Lv-1, Acc1).

%% 刷新奖励状态
refresh_live_reward(RoleId) ->
    Live = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    LiveMax = mod_daily:get_limit_by_type(?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    IdList = data_activitycalen:get_reward_id(),
    OldCountL = mod_daily:get_count(RoleId, [{?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id} || Id <- IdList]),
    OldList = [{Id, Value} || {{_, _, Id}, Value} <- OldCountL],
    F = fun({Id, OldVal}, TmL) ->
        case data_activitycalen:get_reward_config(Id) of
            #ac_reward{live = LiveLimit} ->
                case OldVal of
                    ?NOT_REWARD ->
                        case Live >= LiveLimit of
                            true ->
                                NewVal = ?HAVE_REWARD,
                                %% 置为已领状态
                                mod_daily:increment(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_REWARD, Id);
                            _ -> NewVal = ?NOT_REWARD
                        end;
                    _ -> NewVal = OldVal
                end,
                TmL ++ [{Id, NewVal}];
            _ -> TmL
        end
        end,
    NewList = lists:foldl(F, [], OldList),
    case OldList =/= NewList of
        true ->
            %% 通知客户端更新
            %?PRINT("~p~n", [NewList]),
            lib_server_send:send_to_uid(RoleId, pt_157, 15703, [Live, LiveMax, NewList]);
        _ -> skip
    end.

%% 查询玩家活跃度
get_player_liveness(Player) ->
    #player_status{id = RoleId, st_liveness = #st_liveness{lv = Lv, liveness = Liveness, id = Id, display_status = DisplayStatus}} = Player,
%%    ?DEBUG("Lv:~p, Liveness:~p, Id:~p, DisplayStatus:~p~n", [Lv, Liveness, Id, DisplayStatus]),
    lib_server_send:send_to_uid(RoleId, pt_157, 15709, [Lv, Liveness, Id, DisplayStatus]).

%% 活跃度升级
liveness_lv_up(Player) ->
    #player_status{id = RoleId, st_liveness = StLiveness, figure = _Figure} = Player,
    #st_liveness{lv = Lv, liveness = Liveness, id = _OldId} = StLiveness,
    case check_up(Lv, Liveness) of
        {true, NewLiveness} ->
            NewLv = Lv + 1,
            #base_liveness_lv{attr = Attr} = data_activitycalen:get_liveness(NewLv),
            AttrR = lib_player_attr:to_attr_record(Attr),
            Combat = lib_player:calc_all_power(AttrR),
            NewStLiveness = StLiveness#st_liveness{lv = NewLv, attr = Attr, combat = Combat, liveness = NewLiveness},

            % 注：因活跃度形象被龙珠所占用，故屏蔽形象更新
            % MaxId = get_max_liveness_id(Lv),
            % case data_activitycalen:get_liveness_active(MaxId + 1) of   %% 是否到下个活跃度形象的等级
            %     #base_liveness_active{lv = CfgLv, figure_id = NewFigureId} ->
            %         case NewLv == CfgLv of
            %             true ->
            %                 NewId = MaxId + 1,
            %                 LastStLiveness = NewStLiveness#st_liveness{id = NewId, figure_id = NewFigureId, display_status = 1},
            %                 NewPlayer = Player#player_status{st_liveness = LastStLiveness, figure = Figure#figure{liveness = NewFigureId}},
            %                 brocast_ps_attr(NewPlayer),
            %                 NewPlayer;
            %             _ ->
            %                 LastStLiveness = NewStLiveness,
            %                 NewPlayer = Player#player_status{st_liveness = LastStLiveness}
            %         end;
            %     _ ->
            %         LastStLiveness = NewStLiveness,
            %         NewPlayer = Player#player_status{st_liveness = LastStLiveness}
            % end,
            LastStLiveness = NewStLiveness,
            NewPlayer = Player#player_status{st_liveness = LastStLiveness},

            LastPlayerTmp = lib_player:count_player_attribute(NewPlayer),
            lib_player:send_attribute_change_notify(LastPlayerTmp, ?NOTIFY_ATTR),
            db_player_liveness_replace(RoleId, LastStLiveness),
            %% 日志
            lib_log_api:log_liveness_up(RoleId, Lv, Liveness - NewLiveness, NewLv),
            lib_task_api:activity_lv(Player, NewLv),
            {ok, LastPlayer} = lib_temple_awaken_api:trigger_active_lv(LastPlayerTmp, NewLv),
%%            ?DEBUG("NewLv:~p, NewLiveness:~p~n", [NewLv, NewLiveness]),
            lib_server_send:send_to_uid(RoleId, pt_157, 15710, [?SUCCESS, NewLv, NewLiveness]);
        {false, ErrCode} ->
%%            ?DEBUG("ErrCode:~p~n", [ErrCode]),
            LastPlayer = Player,
            lib_server_send:send_to_uid(RoleId, pt_157, 15700, [ErrCode])
    end,
    {ok, LastPlayer}.

% 更换活跃度形象
change_liveness_figure(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, st_liveness = StLiveness, figure = Figure} = Player,
    #st_liveness{lv = Lv, id = OldId, display_status = DisplayStatus} = StLiveness,
    case data_activitycalen:get_liveness_active(Id) of
        #base_liveness_active{lv = ActiveLv, figure_id = FigureId} -> skip;
        _ -> ActiveLv = 0, FigureId = 0
    end,
    if
        OldId == Id ->
%%            ?DEBUG("err157_same_figure_id~n" , []),
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err157_same_figure_id)]),
            NewPlayer = Player;
    %lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err157_figure_already)]);
        true ->
            case ActiveLv =< Lv of
                true ->
                    NewStLiveness = StLiveness#st_liveness{id = Id, figure_id = FigureId},
                    NewPlayer = Player#player_status{id = RoleId, st_liveness = NewStLiveness, figure = Figure#figure{liveness = FigureId * DisplayStatus}},
                    brocast_ps_attr(NewPlayer),   %%15712 广播给客户端，更换形象
                    % ----------db-----------
                    db_player_liveness_replace(RoleId, NewStLiveness),
%%                    ?DEBUG("Id:~p~n", [Id]),
                    lib_server_send:send_to_sid(Sid, pt_157, 15711, [?SUCCESS, Id]);
                false ->
%%                    ?DEBUG("Id:~p~n", [?ERRCODE(err157_8_live_lv_limit)]),
                    NewPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err157_8_live_lv_limit)])
            end
    end,
    {ok, NewPlayer}.

%% 显示/隐藏 活跃度形象
display_liveness_figure(Player, Type) ->
    #player_status{sid = Sid, id = RoleId, st_liveness = StLiveness, figure = Figure} = Player,
    #st_liveness{lv = Lv, figure_id = FigureId, display_status = DisplayStatus} = StLiveness,
    case data_activitycalen:get_active_ids() of
        [] ->
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err_config)]),
            {ok, Player};
        ActiveIds when is_list(ActiveIds) ->
            MinId = lists:min(ActiveIds),
            #base_liveness_active{lv = MinLv} = data_activitycalen:get_liveness_active(MinId),
            case Lv < MinLv of
                true ->
                    lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err157_8_live_lv_limit)]),
                    {ok, Player};
                false ->
                    if
                        Type =/= 0 andalso Type =/= 1 -> NewPlayer = Player;
                        Type == DisplayStatus -> NewPlayer = Player;
                        true ->
                            NewStLiveness = StLiveness#st_liveness{display_status = Type},
                            NewPlayer = Player#player_status{st_liveness = NewStLiveness, figure = Figure#figure{liveness = FigureId * Type}},
                            brocast_ps_attr(NewPlayer),
                            db_player_liveness_replace(RoleId, NewStLiveness),
%%                            ?DEBUG("Type:~p~n", [Type]),
                            lib_server_send:send_to_sid(Sid, pt_157, 15713, [?SUCCESS, Type])
                    end,
                    {ok, NewPlayer}
            end;
        _ ->
%%            ?DEBUG("Err:~p~n", [?ERRCODE(err_config)]),
            lib_server_send:send_to_sid(Sid, pt_157, 15700, [?ERRCODE(err_config)]),
            {ok, Player}
    end.


%% 广播给客户端
brocast_ps_attr(Player) -> %Player.
    #player_status{id = RoleId, scene = Sid, scene_pool_id = PoolId, copy_id = CopyId, x = X, y = Y, st_liveness = StLiveness} = Player,
    #st_liveness{figure_id = FigureId, display_status = _DisplayStatus} = StLiveness,  %%这display不起作用了，
    mod_scene_agent:update(Player, [{liveness, FigureId}]),
%%    ?DEBUG("~p~n", [{RoleId,  FigureId}]),
    {ok, BinData} = pt_157:write(15712, [RoleId, FigureId]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).

%% 检查是否能升级
check_up(Lv, Liveness) ->
    LvList = data_activitycalen:get_lv_list(),
    case catch lists:max(LvList) of
        Max when is_integer(Max) andalso Lv < Max ->
            %?PRINT("~p~n", [Lv]),
            case data_activitycalen:get_liveness(Lv) of
                #base_liveness_lv{liveness = Value} when Liveness >= Value -> {true, Liveness - Value};
                #base_liveness_lv{} -> {false, ?ERRCODE(err157_6_live_not_enough)};
                _ -> {false, ?ERRCODE(err_config)}
            end;
        Max when is_integer(Max) andalso Lv >= Max -> {false, ?ERRCODE(err157_7_max_lv)};
        _ -> {false, ?ERRCODE(err157_5_cfg_err)}
    end.



init_today_res_act(PS, ActIds) ->
    %WeekDay = get_today_weekday(),
    FilterActIds = filter_unopen_act(PS, ActIds, today),
    %?PRINT("init_today_res_act FilterActIds ~p ~n", [ActIds]),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit(Id, ActSub),  %%初始化当前的最大次数, 受vip特权值影响
        case Limit == 0 of
            true -> Map;
            _ ->
                ResAct = #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit, state = ?STATE_NOT_FIND_LIVE},
                maps:put({Id, ActSub}, ResAct, Map)
        end
    end,
    lists:foldl(F, #{}, FilterActIds).


%% 过滤今天没开启或者等级不足的活动的活动
filter_unopen_act(PS, ActIds, WeekDay) ->
    #player_status{id = _RoleId, figure = #figure{lv = _Lv, guild_id = _GuildId}} = PS,
    Now = utime:unixtime(),
    DataTime = case WeekDay of
        today ->
            utime:unixtime_to_localtime(Now);
        yesterday ->
            utime:unixtime_to_localtime(Now - ?ONE_DAY_SECONDS);
        byesterday ->
            utime:unixtime_to_localtime(Now - 2 * ?ONE_DAY_SECONDS);
        _ ->
            utime:unixtime_to_localtime(Now)
    end,
    %?PRINT("filter_unopen_act DataTime ~p ~n", [ActIds]),
    F = fun({Id, AcSub}, List) ->
        case lib_activitycalen_api:check_ac_start(PS, Id, AcSub, DataTime) of
            true ->
               [{Id, AcSub} | List];
            false -> List
        end
    end,
    lists:foldl(F, [], ActIds).


%% 获取活动活跃度最大找回次数
get_act_limit(ActId, ActSub) ->
    case data_activitycalen:get_live_config(ActId, ActSub) of
        #ac_liveness{max = Max} -> Max;
        _ ->
            Max = 0
    end,
    Max.


make_res_act_map(DayType, _PS, _ActIds, ActList) when DayType == ?TODAY_LIVE ->
    F = fun(H, Map) ->
        case H of
            {Id, ActSub, LeftTimes, State, BackTimes} ->
                Limit = get_act_limit(Id, ActSub),
                Act = #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State, backtimes = BackTimes},
                maps:put({Id, ActSub}, Act, Map);
            _ -> Map
        end
    end,
    lists:foldl(F, #{}, ActList);

make_res_act_map(_DayType, _PS, _ActIds, ActList) ->
    F = fun(H, Map) ->
        case H of
            {Id, ActSub, LeftTimes, State, BackTimes} ->
                Limit = get_act_limit(Id, ActSub),
                Act = #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, state = State, backtimes =  BackTimes},
                maps:put({Id, ActSub}, Act, Map);
            _ -> Map
        end
    end,
    lists:foldl(F, #{}, ActList).


update_res_act_login(PS, ResActMap, OldClearTime, NowTime) ->
    case NowTime - OldClearTime of
        DTime when DTime =< 1 -> #liveness_back{cleartime = OldClearTime, res_act_map = ResActMap};
        DTime ->   %%过期了
            NewResActMap = move_res_act_list(PS, DTime, ResActMap),  %%不是当天了，开始处理活跃度找回的逻辑
            NewClearTime = get_today_clear_time(),
            #liveness_back{cleartime = NewClearTime, res_act_map = NewResActMap}
    end.


move_res_act_list(PS, DTime, ResActMap) ->
    MoveTimes = 1 + (DTime div ?ONE_DAY_SECONDS),
    %?PRINT("move_res_act_list MoveTimes ~p~n", [MoveTimes]),
    ActIds = data_activitycalen:get_live_key(),
    if
        MoveTimes == 1 -> move_res_act_list_1(PS, ActIds, ResActMap);
        MoveTimes == 2 -> move_res_act_list_2(PS, ActIds, ResActMap);
        true -> move_res_act_list_more(PS, ActIds, ResActMap)
    end.

%% 登陆离上次离线跨一天
move_res_act_list_1(PS, ActIds, ResActMap) ->
    Yesterday = maps:get(?YESTERDAY_LIVE, ResActMap, #{}),
    F = fun(_K, V) ->
        V#res_act_live.state == ?STATE_NOT_FIND_LIVE
        end,
    F1 = fun({Id, ActSub}, ResAct, Map) ->
            NewResAct = ResAct#res_act_live{backtimes = ResAct#res_act_live.lefttimes},
            maps:put({Id, ActSub}, NewResAct, Map)
        end,
    BYesterday = maps:filter(F, Yesterday),  %%这里是昨天的数据，最大找回次数也在这里，保证昨天的是对的就行

    Today = maps:get(?TODAY_LIVE, ResActMap, #{}),
    %PreWeekDay = get_pre_weekday(),
    Today1 = correct_logout_act(PS, Today, ActIds, yesterday),
    NewYesterday = maps:filter(F, Today1),
    LastYesterday = maps:fold(F1, #{}, NewYesterday),  %%修正昨天可以找回次数最大次数 ，隔了一天，数据库的today就是昨天， 数据库的昨天就是前天
    NewToday = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY_LIVE, NewToday, #{}),
    ResActMap3 = maps:put(?YESTERDAY_LIVE, LastYesterday, ResActMap2),
    maps:put(?B_YESTERDAY_LIVE, BYesterday, ResActMap3).

%% 登陆离上次离线跨两天
move_res_act_list_2(PS, ActIds, ResActMap) ->
    F = fun(_K, V) -> V#res_act_live.state == ?STATE_NOT_FIND_LIVE end,
    Today = maps:get(?TODAY_LIVE, ResActMap, #{}),
    %PrePreWeekDay = get_pre_pre_weekday(),
    Today1 = correct_logout_act(PS, Today, ActIds, byesterday),
    F1 = fun({Id, ActSub}, ResAct, Map) ->
        NewResAct = ResAct#res_act_live{backtimes = ResAct#res_act_live.lefttimes},
        maps:put({Id, ActSub}, NewResAct, Map)
    end,
    BYesterday = maps:filter(F, Today1),
    LastBYesterday = maps:fold(F1, #{}, BYesterday),  %%修正最大找回次数
    NewToday = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY_LIVE, NewToday, #{}),
    Yesterday = init_res_act_yesterday(PS, ActIds),
    ResActMap3 = maps:put(?YESTERDAY_LIVE, Yesterday, ResActMap2),
    maps:put(?B_YESTERDAY_LIVE, LastBYesterday, ResActMap3).

%% 登陆离上次离线跨两天以上
move_res_act_list_more(PS, ActIds, _ResActMap) ->
    Today = init_today_res_act(PS, ActIds),
    ResActMap2 = maps:put(?TODAY_LIVE, Today, #{}),
    Yesterday = init_res_act_yesterday(PS, ActIds),
    ResActMap3 = maps:put(?YESTERDAY_LIVE, Yesterday, ResActMap2),
    BYesterday = init_res_act_b_yesterday(PS, ActIds),
    maps:put(?B_YESTERDAY_LIVE, BYesterday, ResActMap3).


%% 纠正奖励找回(由于下线没有补充数据)：
%% 例如：下线当天由20级升到30级，这个等级段新开了3个活动，然后下线，再次上线后，要将这个等级段的活动补充进record里面
correct_logout_act(PS, Today, ActIds, WeekDay) ->
    FilterActIds = filter_unopen_act(PS, ActIds, WeekDay),
    %%?PRINT("correct_logout_act FilterActIds ~p ~n", [{WeekDay, FilterActIds}]),
    F = fun({ActId, ActSub}, Map2) ->
        case maps:get({ActId, ActSub}, Map2, none) of
            #res_act_live{} -> Map2;
            _ ->
                Limit = get_act_limit(ActId, ActSub),     %%受vip特权值影响最大次数
                case Limit == 0 of
                    true -> Map2;
                    _ ->
                        ResAct = #res_act_live{act_id = ActId, act_sub = ActSub, lefttimes = Limit, max = Limit, state = ?STATE_NOT_FIND_LIVE},
                        maps:put({ActId, ActSub}, ResAct, Map2)
                end
        end
    end,
    lists:foldl(F, Today, FilterActIds).


init_res_act_yesterday(PS, ActIds) ->
    FilterActIds = filter_unopen_act(PS, ActIds, yesterday),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit(Id, ActSub),  %%初始化昨天最大次数
        case Limit == 0 of
            true -> Map;
            _ ->
                ResAct = #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit, state = ?STATE_NOT_FIND_LIVE, backtimes = Limit},
                maps:put({Id, ActSub}, ResAct, Map)
        end
    end,
    lists:foldl(F, #{}, FilterActIds).

init_res_act_b_yesterday(PS, ActIds) ->
    FilterActIds = filter_unopen_act(PS, ActIds, byesterday),
    F = fun({Id, ActSub}, Map) ->
        Limit = get_act_limit(Id, ActSub),  %%初始化前天的最大参与次数,受vip特权值影响
        case Limit == 0 of
            true -> Map;
            _ ->
                ResAct = #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = Limit, max = Limit, state = ?STATE_NOT_FIND_LIVE, backtimes = Limit},
                maps:put({Id, ActSub}, ResAct, Map)
        end
    end,
    lists:foldl(F, #{}, FilterActIds).

%% 获取凌晨4点时间戳  4 点
%% 4-24点 获取的是第二天的时间戳
%% 0-4点  获取当天时间戳
get_today_clear_time() ->
    {_, {H, _, _}} = calendar:local_time(),
    NowTime = utime:unixtime(),
    ZeroTime = utime:unixdate(NowTime),
    FourClock = ZeroTime + 4 * 3600,
    case H < 4 of
        true -> FourClock;
        false -> FourClock + ?ONE_DAY_SECONDS
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  获取活跃度找回信息     %%检查是否开启-> 读取信息->返回
%% @param    参数      Player::#player_status{}
%% @return   返回值    {ok, NewPS, ResList} | {false, Res},
%%                    ResList::list  [{act_id          :int32  // 活动id
%%                                     act_sub         :int16  // 子Id
%%                                     lefttimes       :int16  // 剩余次数
%%                                    }]
%% @history  修改历史
%% -----------------------------------------------------------------
report_res_act(PS) ->
    case  lib_liveness_check:report_res_act(PS) of
        true ->
            #player_status{liveness_back = #liveness_back{res_act_map = ResActMap}} = PS,
            Yesterday = maps:get(?YESTERDAY_LIVE, ResActMap, #{}),
            BYesterday = maps:get(?B_YESTERDAY_LIVE, ResActMap, #{}),
            F = fun(_K, V, List) ->
                #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, max = Limit, backtimes = BackTimes} = V,
                case Limit == 0 of
                    false ->
                        case lists:keyfind({Id, ActSub}, 1, List) of  %%看看有没有重复，重复的叠加
                            {{Id, ActSub}, OldLeftTimes, OldBackTimes} ->
                                lists:keystore({Id, ActSub}, 1, List, {{Id, ActSub}, OldLeftTimes + LeftTimes, OldBackTimes + BackTimes});
                            _ -> [{{Id, ActSub}, LeftTimes, BackTimes} | List]
                        end;
                    true -> List
                end
            end,
            List1 = maps:fold(F, [], Yesterday),  %%这个地层也是用lists:fold 去做的
            List2 = maps:fold(F, List1, BYesterday),
            List3 = [{Id, ActSub, LeftTimes, BackTimes1}
                || {{Id, ActSub}, LeftTimes, BackTimes1} <- List2],  %%次数为0的也不去掉LeftTimes /= 0
%%            ?DEBUG("ResActMap ~p~n", [ResActMap]),
%%            ?DEBUG("List3 ~p~n", [List3]),
            {ok, PS, List3};
        {false, Res} ->
            {false, Res}
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  找回活跃度    检查 -> 消耗->同步数据库 -> 发送奖励（修改活跃度）-> 修正Ps ->返回
%% @param    参数      TempPS::#player_status{}
%%                     ActId::integer  活动大类
%%                     SubId::integer  活动子类
%%                     Times::times  找回次数
%% @return   返回值    {ok, NewPs, {ActId, SubId, leftTime}} || {false, ErrCode}
%%                     leftTime::integer  剩余次数
%% @history  修改历史
%% -----------------------------------------------------------------
liveness_back(TempPS, ActId, SubId, Times)  ->
    case  lib_liveness_check:liveness_back(TempPS, ActId, SubId, Times) of
        true ->
            #ac_liveness{live = Live} =  data_activitycalen:get_live_config(ActId, SubId),

            Cost = [{?TYPE_BGOLD, 0 , Live * Times}],  %%先在的消耗是一个一个绑转一个活跃度的消耗
            case lib_goods_api:cost_object_list(TempPS, Cost, liveness_back, "cost_object_list") of  %%检查过消耗了
                {true,  PS} ->
                    #player_status{id = RoleId, liveness_back = LiveNessBack} = PS,
                    {NewLiveNessBack, LeftTimes} =   liveness_back_do_core(LiveNessBack,ActId, SubId, Times),  %%修改剩余次数,
                    db_update_liveness_back(RoleId, NewLiveNessBack), %同步数据库
%%	                ?DEBUG("Cost ~p, LeftTimes ~p~n NewLiveNessBack ~p~n", [Cost, LeftTimes, NewLiveNessBack]),
                    %%发送奖励，修改活跃度
                    {ok, NewPs} =add_liveness(PS,  Live * Times),
                    LastPs = NewPs#player_status{liveness_back = NewLiveNessBack},   %%修正Ps
                    {ok, LastPs, {ActId, SubId, LeftTimes}};  %%返回
                {false, ErrCode, _} ->
                    {false,  ErrCode}
            end;
        {false, ErrCode} ->
            {false, ErrCode}
    end.


%%活跃度找回
liveness_back_do_core(LiveNessBack, Id, ActSub, Times) ->
    #liveness_back{res_act_map = ResActMap} = LiveNessBack,
    Yesterday = maps:get(?YESTERDAY_LIVE, ResActMap, #{}),
    BYesterday = maps:get(?B_YESTERDAY_LIVE, ResActMap, #{}),
    YResAct = maps:get({Id, ActSub}, Yesterday, none),
    BYResAct = maps:get({Id, ActSub}, BYesterday, none),
    if
        is_record(BYResAct, res_act_live) == false ->   %%只扣昨天
            NewLeftTime = YResAct#res_act_live.lefttimes - Times,
            NewState = ?IF(NewLeftTime == 0, ?STATE_FIND_LIVE, ?STATE_NOT_FIND_LIVE),
            NewYResAct = YResAct#res_act_live{lefttimes = NewLeftTime, state = NewState},
            NewYesterday = maps:put({Id, ActSub}, NewYResAct, Yesterday),
            NewResActMap = maps:put(?YESTERDAY_LIVE, NewYesterday, ResActMap),
            {LiveNessBack#liveness_back{res_act_map = NewResActMap}, NewLeftTime};
        is_record(YResAct, res_act_live) == false ->   %%只扣前天
            NewLeftTime = BYResAct#res_act_live.lefttimes - Times,
            NewState = ?IF(NewLeftTime == 0, ?STATE_FIND_LIVE, ?STATE_NOT_FIND_LIVE),
            NewBYResAct = BYResAct#res_act_live{lefttimes = NewLeftTime, state = NewState},
            NewBYesterday = maps:put({Id, ActSub}, NewBYResAct, BYesterday),
            NewResActMap = maps:put(?B_YESTERDAY_LIVE, NewBYesterday, ResActMap),
            {LiveNessBack#liveness_back{res_act_map = NewResActMap}, NewLeftTime};
        true ->                                       %%优先扣前天
            LeftTimesY = YResAct#res_act_live.lefttimes,
            LeftTimesBY = BYResAct#res_act_live.lefttimes,
            {NewLeftTimesBY, NewLeftTimesY} = ?IF((LeftTimesBY - Times) >= 0, {LeftTimesBY - Times, LeftTimesY}, {0, LeftTimesY + LeftTimesBY - Times}),
            NewStateBY = ?IF(NewLeftTimesBY == 0, ?STATE_FIND_LIVE, ?STATE_NOT_FIND_LIVE),
            NewStateY = ?IF(NewLeftTimesY == 0, ?STATE_FIND_LIVE, ?STATE_NOT_FIND_LIVE),
            NewYResAct = YResAct#res_act_live{lefttimes = NewLeftTimesY, state = NewStateY},
            NewBYResAct = BYResAct#res_act_live{lefttimes = NewLeftTimesBY, state = NewStateBY},
            NewYesterday = maps:put({Id, ActSub}, NewYResAct, Yesterday),
            NewBYesterday = maps:put({Id, ActSub}, NewBYResAct, BYesterday),
            ResActMap1 = maps:put(?YESTERDAY_LIVE, NewYesterday, ResActMap),
            NewResActMap = maps:put(?B_YESTERDAY_LIVE, NewBYesterday, ResActMap1),
            {LiveNessBack#liveness_back{res_act_map = NewResActMap}, NewLeftTimesBY + NewLeftTimesY}
    end.




get_max_liveness_id(Lv) ->
    IdList = lists:reverse(data_activitycalen:get_active_ids()),    %%活跃度id，从到小，
    get_max_liveness_id(Lv, IdList).


get_max_liveness_id(_Lv, []) ->
    0;
get_max_liveness_id(Lv, [ Id | IdList]) ->
    case  data_activitycalen:get_liveness_active(Id) of
        #base_liveness_active{lv = CfgLv}  ->
            if
                Lv >= CfgLv ->
                    Id;
                true ->
                    get_max_liveness_id(Lv, IdList)
            end;
        _ ->
            0
    end.

%%领取活跃度
get_live(#player_status{id = RoleId} = Player, ActId, SubId) ->
    OldLive   = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%旧活跃度
    LiveLimit = mod_daily:get_limit_by_type(?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY), %%活跃度上限
    %%已经得到但是没有领取的活跃度
    AddLive   = mod_daily:get_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_NUM, ActId * ?AC_LIVE_ADD + SubId),
    #ac_liveness{name = AcName, live = Live} = data_activitycalen:get_live_config(ActId, SubId),
    if
        AddLive == 0 ->
            {false, ?ERRCODE(err157_not_have_get_live)};
        true ->
            case OldLive < LiveLimit of
                true ->
                    Add = min(AddLive, LiveLimit - OldLive),
                    NewLive = OldLive + Add,
                    mod_daily:plus_count(RoleId, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY, Add),
                    mod_daily:set_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_NUM, ActId * ?AC_LIVE_ADD + SubId, 0), %%得到的活跃度设置为0
                    mod_daily:plus_count(RoleId, ?MOD_ACTIVITY, ?MOD_ACTIVITY_LIVE_YET_GET_NUM, ActId * ?AC_LIVE_ADD + SubId, Add),
                    lib_log_api:log_activity_live(RoleId, ActId, SubId, util:make_sure_binary(AcName), Live, OldLive, NewLive, utime:unixtime()),
                    % 活跃事件派发
%%                    Data = #callback_activity_live{activity_live = NewLive},
%%                    lib_player_event:async_dispatch(RoleId, ?EVENT_ADD_LIVENESS, Data),
                    %% 更新ps的活跃度
                    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_liveness, add_liveness, [Add]);
                false ->
                    Add = 0
            end,
            {ok, Player, {ActId, SubId, Add}}
    end.


%%------------------------------------------------数据库db--------------------------------------------
db_player_liveness_select(RoleId) ->
    Sql = io_lib:format(?sql_player_liveness_select, [RoleId]),
    case db:get_row(Sql) of
        [] ->
            [0, 0, 0, 0];
        [Lv, Liveness, Id, DisplayStatus] ->
            [Lv, Liveness, Id, DisplayStatus]
    end.

db_player_liveness_replace(RoleId, StLiveness) ->
    #st_liveness{lv = Lv, liveness = Live, id = Id, display_status = DisplayStatus} = StLiveness,
    Sql = io_lib:format(?sql_player_liveness_replace, [RoleId, Lv, Live, Id, DisplayStatus]),
    db:execute(Sql).


db_select_res_act_list(RoleId) ->
    Sql = io_lib:format(<<"select  clear_time,  datetype,  act_list  from liveness_back   where  role_id = ~p">>, [RoleId]),
    db:get_all(Sql).


db_update_liveness_back(RoleId, LiveNessBack) ->
    #liveness_back{cleartime = ClearTime, res_act_map = ResActMap} = LiveNessBack,
    F = fun(DayType, V, List) ->
        F1 = fun(_K, ResAct, List1) ->
            #res_act_live{act_id = Id, act_sub = ActSub, lefttimes = LeftTimes, state = State, backtimes =  BackTimes} = ResAct,
            [{Id, ActSub, LeftTimes, State, BackTimes} | List1]
        end,
        DbActList = maps:fold(F1, [], V),
        [{DayType, DbActList} | List]
    end,
    ResActList = maps:fold(F, [], ResActMap),
    SqlValues = format_resource_back_values(RoleId, ClearTime, ResActList, [], 1),
    %?PRINT("update_resource_back ~p~n", [SqlValues]),
    Sql = "replace into `liveness_back` (role_id, clear_time, datetype, act_list) values" ++ SqlValues,
    db:execute(Sql).



format_resource_back_values(_, _, [], List, _) -> List;
format_resource_back_values(RoleId, ClearTime, [H | ResActList], List, Num) ->
    {DayType, ActList} = H,
    ActList_B = util:term_to_bitstring(ActList),
    Value = io_lib:format(<<"(~p, ~p, ~p, '~s') ">>, [RoleId, ClearTime, DayType, ActList_B]),
    if
        Num =:= 1 ->
            NewList = Value ++ List;
        true ->
            NewList = Value ++ "," ++ List
    end,
    format_resource_back_values(RoleId, ClearTime, ResActList, NewList, Num + 1).
%%------------------------------------------------数据库db--------------------------------------------