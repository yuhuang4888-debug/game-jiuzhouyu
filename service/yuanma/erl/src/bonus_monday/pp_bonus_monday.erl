%%-----------------------------------------------------------------------------
%% @Module  :       pp_bonus_monday
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2019-4-26
%% @Description:    周一大奖
%%-----------------------------------------------------------------------------
-module(pp_bonus_monday).

-include("bonus_monday.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_fun.hrl").

-export([handle/3]).

handle(Cmd, Player, Args) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv, name = RoleName}, monday_bonus = MondayBonus} = Player,
    case data_monday_bonus:get_value(open_lv) of
        OpenLv when is_integer(OpenLv) -> skip;
        _ -> OpenLv = 0
    end,
    % ?PRINT("===========  NowTime:~p,Cmd:~p~n",[utime:unixtime(),Cmd]),
    if
        RoleLv >= OpenLv ->
            case MondayBonus of
                #monday_bonus_data{} = NewMondayBonus -> skip;
                _S when RoleLv >= OpenLv ->
                    SQL = io_lib:format(?SQL_SELECT_DATA, [RoleId]),
                    List = db:get_row(SQL),
                    case List of
                        [DrawTimes, TaskStateL, PoolL, TUtime] ->
                            TaskState = util:bitstring_to_term(TaskStateL),
                            Pool = util:bitstring_to_term(PoolL);
                        _ ->
                            TaskState = [],DrawTimes = 0, Pool = lib_bonus_monday:get_default_pool(), TUtime = 0
                    end,
                    List2 = db:get_all(io_lib:format(?SQL_PERSON_SELECT, [RoleId])),
                    Fun = fun([_, Type, GoodsPoolid, Utime, Picture, PictureVer, Creer], Acc) ->
                        [{RoleId, RoleName,Type,GoodsPoolid,Utime, Picture, PictureVer, Creer}|Acc]
                    end,
                    Record = lists:foldl(Fun, [], List2),
                    case data_monday_bonus:get_value(kf_log_num) of
                        LogNum when is_integer(LogNum) ->skip;
                        _ -> LogNum = 20
                    end,
                    SortRecord = lists:keysort(4, Record),
                    if
                        SortRecord =/= [] ->
                            [{_, _,_,_,Utime,_,_,_}|_] = SortRecord,
                            %% 清理多余数据
                            spawn(fun() -> db:execute(io_lib:format(?SQL_PERSON_DELETE, [Utime, RoleId])) end),
                            RealPersonLog = lists:sublist(SortRecord, LogNum);
                        true ->
                            RealPersonLog = SortRecord
                    end,
                    NewMondayBonus = #monday_bonus_data{draw_times = DrawTimes, now_pool = Pool, task_state = TaskState, 
                        record = RealPersonLog, utime = TUtime};
                _ ->
                    NewMondayBonus = MondayBonus
            end,
            do_handle(Cmd, Player#player_status{monday_bonus = NewMondayBonus}, Args);
        true ->
            {ok, Player}
            % lib_server_send:send_to_uid(_RoleId, pt_179, 17900, [?ERRCODE(err179_role_lv_limit)])
    end.

do_handle(17901, Player, [Pool]) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    case check_pool(Pool, Pool, RoleId) of
        true ->
            lib_server_send:send_to_uid(RoleId, pt_179, 17901, [Pool]), 
            NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{now_pool = Pool}};
        {false, Code} ->
            lib_server_send:send_to_uid(RoleId, pt_179, 17900, [Code]),
            NewPlayer = Player
    end,
    {ok, NewPlayer};

do_handle(17902, Player, []) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    case MondayBonus of
        #monday_bonus_data{record = PersonRecord} ->
            skip;
        _ ->
            PersonRecord = []
    end,
    lib_server_send:send_to_uid(RoleId, pt_179, 17902, [lists:reverse(PersonRecord)]),
    {ok, Player};

do_handle(17903, Player, []) ->
    #player_status{id = RoleId} = Player,
    case check_draw_time() of
        true ->
            % ?PRINT("true ~n",[]),
            case lib_bonus_monday:draw_reward(Player, ?MOD_BONUS_MONDAY) of
                {true, NewPlayer} -> skip;
                _ -> NewPlayer = Player
            end;
        _ ->
            % ?PRINT("false ~n",[]),
            lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_not_in_draw_time)]),
            NewPlayer = Player
    end,
    {ok, NewPlayer};

do_handle(17904, Player, []) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    #monday_bonus_data{task_state = TaskState} = MondayBonus,
    % ?PRINT("TaskState:~p,Pool:~w~n",[TaskState, Pool]),
    % ?PRINT("===========  NowTime:~p~n",[utime:unixtime()]),
    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [TaskState]),
    {ok, Player};

do_handle(17905, Player, []) ->
    #player_status{id = RoleId, server_id = ServerId} = Player,
    mod_kf_draw_record:cast_center([{'get_draw_log', ?MOD_BONUS_MONDAY, ?MOD_BONUS_MONDAY_FIRST, ServerId, RoleId}]),
    {ok, Player};

do_handle(17906, Player, [TaskId]) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    #monday_bonus_data{task_state = TaskState, draw_times = DrawTimes, now_pool = Pool, utime = Utime} = MondayBonus,
    case data_monday_bonus:get_task_info(TaskId) of
        #base_monday_bonus_task{reward = Reward} ->
            case lists:keyfind(TaskId, 1, TaskState) of
                {_, State} when State == ?HAS_ACHIEVE ->
                    ProduceType = lib_bonus_monday:get_produce_type(?MOD_BONUS_MONDAY),
                    Produce = #produce{type = ProduceType, reward = Reward, show_tips = ?SHOW_TIPS_0},
                    NewPs = lib_goods_api:send_reward(Player, Produce),
                    NewTaskState = lists:keystore(TaskId, 1, TaskState, {TaskId, ?HAS_RECIEVE}),
                    lib_server_send:send_to_uid(RoleId, pt_179, 17904, [NewTaskState]),
                    spawn(fun() -> db:execute(io_lib:format(?SQL_REPLACE_DATA, [RoleId, DrawTimes, 
                            util:term_to_string(NewTaskState), util:term_to_string(Pool), Utime])) end),
                    lib_server_send:send_to_uid(RoleId, pt_179, 17906, [1]),
                    NewPlayer = NewPs#player_status{monday_bonus = MondayBonus#monday_bonus_data{task_state = NewTaskState}};
                {_, State} when State == ?HAS_RECIEVE ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_has_recieve)]),
                    NewPlayer = Player;
                _ ->
                    lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_not_achieve)]),
                    NewPlayer = Player
            end;
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_179, 17900, [?ERRCODE(err179_miss_config)]),
            NewPlayer = Player
    end,
    {ok, NewPlayer};

do_handle(17907, Player, []) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    #monday_bonus_data{draw_times = DrawTimes} = MondayBonus,
    case check_draw_time() of
        true ->
            % ?PRINT("=========== 1 NowTime:~p~n",[utime:unixtime()]),
            lib_server_send:send_to_uid(RoleId, pt_179, 17907, [1, DrawTimes]);
        _ ->
            % ?PRINT("=========== 0 NowTime:~p~n",[utime:unixtime()]),
            lib_server_send:send_to_uid(RoleId, pt_179, 17907, [0, DrawTimes])
    end,
    {ok, Player};

do_handle(17908, Player, []) ->
    #player_status{id = RoleId, monday_bonus = MondayBonus} = Player,
    #monday_bonus_data{now_pool = Pool} = MondayBonus,
    case check_pool(Pool, Pool, Player#player_status.id) of
        true -> 
            NewPool = Pool,
            NewPlayer = Player;
        {false, _Code} ->
            NewPool = lib_bonus_monday:get_default_pool(),
            NewPlayer = Player#player_status{monday_bonus = MondayBonus#monday_bonus_data{now_pool = NewPool}}
    end,
    lib_server_send:send_to_uid(RoleId, pt_179, 17908, [NewPool]),
    {ok, NewPlayer};

do_handle(_,Player,_) -> {ok,Player}.


check_pool([], [], _RoleId) ->
    {false, ?ERRCODE(err179_pool_is_null)};
check_pool([], _Pool, _RoleId) ->
    true;
check_pool([{Type, Goods}|T], Pool, RoleId) ->
    case lists:keyfind(Type, 1, T) of
        {_, _} ->
            {false, ?ERRCODE(has_same_type)};
        _ ->
            case data_monday_bonus:get_bonus_type(Type) of
                #base_monday_bonus{choose_list = ChooseList, num = Num} ->
                    Length = erlang:length(Goods),
                    if
                        Length == Num ->
                            case check_pool_helper(Goods, Pool, RoleId, ChooseList) of
                                true ->
                                    check_pool(T, Pool, RoleId);
                                {false, Code} ->
                                    {false, Code}
                            end;
                        true ->
                            {false, ?ERRCODE(err179_type_length_error)}
                    end;
                _->
                    {false, ?ERRCODE(err179_miss_config)}
            end
    end.

check_draw_time() ->
    OpenDay = util:get_open_day(),
    Value = ?IF(OpenDay > data_monday_bonus:get_value(open_day), draw_time, before_draw_time),
    NowTime = utime:unixtime(),
    Day = utime:day_of_week(NowTime),
    {_,{NowSH,NowSM,_}} = utime:unixtime_to_localtime(NowTime),
    case data_monday_bonus:get_value(Value) of
        [{day, DayList},{time, TimeList}] ->
            case lists:member(Day, DayList) of
                true ->
                    Fun = fun({{Sh,Sm},{Eh,Em}}) ->
                        Sh*60+Sm =< NowSH*60+NowSM andalso NowSH*60+NowSM =< Eh*60+Em
                    end,
                    case ulists:find(Fun, TimeList) of
                        {ok,_} ->
                            true;
                        _ ->
                            false
                    end;
                _ ->
                    false
            end;
        % IsMember andalso InRange;
        _ ->
            false
    end.

check_pool_helper([], _Pool, _RoleId, _ChooseList) -> 
    true;
check_pool_helper([H|T], Pool, RoleId, ChooseList) ->
    case lists:member(H, ChooseList) of
        true ->
            check_pool_helper(T, Pool, RoleId, ChooseList);
        _ ->
            {false, ?ERRCODE(err179_error_goods_in_pool)}
    end.