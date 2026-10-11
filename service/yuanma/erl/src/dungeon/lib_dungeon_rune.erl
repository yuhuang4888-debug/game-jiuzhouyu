%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_rune.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-06
%% @Description:    符文副本特殊逻辑
%%-----------------------------------------------------------------------------

-module (lib_dungeon_rune).
-include ("dungeon.hrl").
-include ("rec_event.hrl").
-include ("server.hrl").
-include ("predefine.hrl").
-include ("language.hrl").
-include ("common.hrl").
-include ("errcode.hrl").
-include ("def_module.hrl").
-include ("goods.hrl").
-include ("def_event.hrl").
-include ("def_fun.hrl").

-define(sql_select_dungeon_rune_daily_reward,
    <<"select `last_receive_time`, `update_time`, `store_list` from `role_dungeon_rune_daily_reward` where `role_id` = ~p limit 1">>).
-define(sql_replace_dungeon_rune_daily_reward,
    <<"replace into `role_dungeon_rune_daily_reward`(`role_id`, `last_receive_time`, `update_time`, `store_list`) values (~p, ~p, ~p, '~s')">>).

-export ([
    login/1
    ,handle_event/2
    ,get_dungeon_level/1
    % ,handle_daily_reward/1
    ,gm_reset_rune2/1
    ,gm_clear_rune_dun_enter_count_help/2
    ,send_status/1
    ,unlock_level/2
    ,send_last_daily_reward/1
    ,daily_clear/0
    ]).

-export ([
    dunex_calc_record_score/2
    ,dunex_update_dungeon_record/2
    ,enter_next_dungeon/2
    ,receive_daily_reward/1
    ]).

-export([gm_auto_unlock/0]).

%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
   #player_status{sid = SId} = PS,
   #callback_dungeon_succ{
       dun_id = _DunId, dun_type = DunType} = Data,
   Level = get_dungeon_level(PS),
   if
       % 符文本第一次通关时记录下更新时间
       DunType == ?DUNGEON_TYPE_RUNE2 andalso Level == 1 ->
            lib_server_send:send_to_sid(SId, pt_611, 61115, [1, 1]);
       true ->
           skip
   end,
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

login(Player) ->
    #player_status{id = RoleId} = Player,
    UnlockLevel = lib_counter:get_count(RoleId, ?MOD_DUNGEON, 10, 0),
    {LastReceiveTime, _UpdateTime, StoreList} = case db_select_daily_reward(RoleId) of
        [[LastReceiveTime1, UpdateTimeRaw, StoreListRaw]] ->
            {LastReceiveTime1, UpdateTimeRaw, util:bitstring_to_term(StoreListRaw)};
        _ -> {0, 0, []}
    end,
    DunRuneState = #dun_rune_daily_reward{last_receive_time = LastReceiveTime, store_list = StoreList},
    Player1 = Player#player_status{dun_rune_daily_reward = DunRuneState, dun_rune_level_unlock = UnlockLevel},
    Player2 = send_last_daily_reward(Player1),

    Player2.

get_dungeon_level(#player_status{dungeon_record = undefined} = Player) ->
    NewPlayer = lib_dungeon:load_dungeon_record(Player),
    % lib_player:apply_cast(Player#player_status.id, ?APPLY_CAST_SAVE, lib_dungeon, load_dungeon_record, []),
    get_dungeon_level(NewPlayer);

get_dungeon_level(Player) ->
    #player_status{dungeon_record = Rec} = Player,
    Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_RUNE2),
    lists:foldl(fun
        (Id, Acc) ->
            case maps:is_key(Id, Rec) of
                true ->
                    Acc + 1;
                _ ->
                    Acc
            end
    end, 0, Ids).

gm_reset_rune2(#player_status{id = RoleId} = Player) ->
    Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_RUNE2),
    IdsStr = ulists:list_to_string(Ids, ","),
    SQL = io_lib:format("DELETE FROM `dungeon_best_record` WHERE `player_id`=~p AND `dun_id` IN (~s)", [RoleId, IdsStr]),
    db:execute(SQL),
    List = [{{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Id}, 0} || Id <- Ids],
    mod_counter:set_count(RoleId, List),
    Player#player_status{dungeon_record = undefined}.


dunex_calc_record_score(_DunId, RecData) ->
    case lists:keyfind(?DUNGEON_REC_SCORE, 1, RecData) of
        {?DUNGEON_REC_SCORE, Score} ->
            Score;
        _ -> 0
    end.

dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = DunId,
        dun_type = DunType,
        pass_time = PassTime
    } = ResultData,
    if
        PassTime >= 0 ->
            case maps:get(DunId, Record, []) of
                [{?DUNGEON_REC_PASSTIME, OldPassTime}|_] when OldPassTime =< PassTime ->
                    PS;
                _ ->
                    Score = lib_dungeon:get_time_score(DunId, PassTime),
                    Data = [{?DUNGEON_REC_PASSTIME, PassTime}, {?DUNGEON_REC_SCORE, Score}],
                    NewRecord = maps:put(DunId, Data, Record),
                    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
                    NewPS = PS#player_status{dungeon_record = NewRecord},
                    Level = lib_dungeon_api:get_dungeon_level(NewPS, DunType),
                    lib_task_api:fin_dun_level(RoleId, DunType, Level),
                    lib_supreme_vip_api:fin_dun_level(RoleId, DunType, Level),
                    %% 推送勋章系统
                    pp_medal:handle(13401, NewPS, []),
                    NewPS
            end;
        true ->
            PS
    end.

%% 现在改为手动领取
% handle_daily_reward(Player) ->
%     #player_status{login_time_before_last = LastLoginTime, last_login_time = ThisLoginTime, id = RoleId} = Player,
%     if
%         LastLoginTime > 0 ->
%             %% 判断最新的登录时间是不是最新的一天（防止玩家跨零点在线，并且最近登录时间和上上次登录时间的时间刚好相差 >= 1天，导致的奖励多发）
%             IsSameDay = utime:is_same_day(utime:unixtime(), ThisLoginTime),
%             case utime:diff_days(ThisLoginTime, LastLoginTime) of
%                 Days when Days > 0 andalso IsSameDay ->
%                     #player_status{dungeon_record = Rec} = NewPlayer = lib_dungeon:load_dungeon_record(Player),
%                     Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_RUNE2),
%                     Num = lists:foldl(fun
%                         (Id, Acc) ->
%                             case maps:is_key(Id, Rec) of
%                                 true ->
%                                     Acc + 1;
%                                 _ ->
%                                     Acc
%                             end
%                     end, 0, Ids),
%                     if
%                         Num > 0 ->
%                             RealDays = min(Days, ?RUNE_DAILY_REWARD_MAX_NUM),
%                             case data_dungeon_special:get_rune_daily_reward(Num) of
%                                 [] ->
%                                     skip;
%                                 RewardList ->
%                                     TotalList = lib_goods_util:goods_object_multiply_by(RewardList, RealDays),
%                                     Title = utext:get(?LAN_TITLE_DUN_RUNE_DAILY_REWARD),
%                                     Content = utext:get(?LAN_CONTENT_DUN_RUNE_DAILY_REWARD),
%                                     lib_mail_api:send_sys_mail([RoleId], Title, Content, TotalList)
%                             end;
%                         true ->
%                             ok
%                     end,
%                     {ok, NewPlayer};
%                 _ ->
%                     {ok, Player}
%             end;
%         true ->
%             {ok, Player}
%     end.

enter_next_dungeon(#player_status{id = RoleId, sid = Sid} = Player, DunId) ->
    case lib_dungeon_api:get_next_dungeon_id(DunId) of
        0 ->
            {ok, BinData} = pt_610:write(61000, [?ERRCODE(err610_is_final_dun), ""]),
            lib_server_send:send_to_sid(Sid, BinData);
        NextId ->
            case lib_dungeon:is_on_dungeon(Player) of
                true ->
                    case Player of
                        #player_status{copy_id = CopyId, dungeon = #status_dungeon{dun_id = DunId}} ->
                            Args = lib_dungeon:get_start_dun_args(Player, data_dungeon:get(NextId)),
                            mod_dungeon:enter_next_dungeon(CopyId, RoleId, Args);
                        _ ->
                            skip
                    end;
                _ ->
                    lib_dungeon:enter_dungeon(Player, NextId)
            end
    end.

% buy_count_done(Player, DunId, VipBuyCount, Count) ->
%     VipRightType = ?MOD_DUNGEON_BUY * 1000000 + ?DUNGEON_TYPE_RUNE,

gm_clear_rune_dun_enter_count_help(#player_status{id = RoleId, dungeon_record = DR} = Ps, DunId) ->
    mod_counter:set_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId, 0),
    mod_counter:set_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId, 0),
    NewDR = maps:remove(DunId, DR),
    SQL = io_lib:format("DELETE FROM `dungeon_best_record` WHERE `player_id`=~p AND `dun_id` = ~p", [RoleId, DunId]),
    db:execute(SQL),
    Ps#player_status{dungeon_record = NewDR}.


%% 领取每日奖励
receive_daily_reward(Player) ->
    #player_status{dun_rune_daily_reward = DailyRewardStatus, id = RoleId} = Player,
    #dun_rune_daily_reward{last_receive_time = LastReceiveTime} = DailyRewardStatus,
    NowTime = utime:unixtime(),
    Level = get_dungeon_level(Player),

    IsReceived = utime:diff_days(LastReceiveTime, NowTime) == 0,
    {Code, RewardList, LevelList} = if
        Level < 1 ->
            % 没有通关
            {?ERRCODE(err610_not_pass_rune), [], []};
        IsReceived ->
            % 已经领取
            {?ERRCODE(err610_had_receive_reward), [], []};
        true ->
            RewardLevelList = [Level],
            {Code1, RewardList1} = lists:foldl(fun calc_daily_reward_list/2, {?SUCCESS, []}, RewardLevelList),
            {Code1, RewardList1, RewardLevelList}
    end,
    case Code =/= ?SUCCESS of
        true ->
            {ok, Bin} = pt_611:write(61114, [Code, []]),
            lib_server_send:send_to_uid(RoleId, Bin),
            {ok, Player};
        false ->
            Produce = #produce{type = rune_dun_daily_reward, reward = RewardList},
            LastPlayer1 = lib_goods_api:send_reward(Player, Produce),
            % 改变上一次领取时间
            NewDunRuneState = #dun_rune_daily_reward{last_receive_time = NowTime},
            % 写数据库
            db_replace_daily_reward(RoleId, NewDunRuneState),
            % 日志记录
            lib_log_api:log_dungeon_rune_daily_reward(RoleId, Level, LevelList, RewardList),
            LastPlayer = LastPlayer1#player_status{dun_rune_daily_reward = NewDunRuneState},
            {ok, Bin} = pt_611:write(61114, [Code, RewardList]),
            lib_server_send:send_to_uid(RoleId, Bin),
            {ok, LastPlayer}
    end.

%% 根据符文塔层级计算奖励
%% @return {Code, RewardList}
calc_daily_reward_list(Level, {Code, RewardList}) ->
    case Code == ?SUCCESS of
        true ->
            F = fun({Type, GoodsTypeId, Num}, Acc) ->
                NewNum = case lists:keyfind(GoodsTypeId, 2, RewardList) of
                    {_, _, OldNum} ->
                        OldNum + Num;
                    _ ->
                        Num
                end,
                lists:keystore(GoodsTypeId, 2, Acc, {Type, GoodsTypeId, NewNum})
            end,
            {Code1, LevelReward} = get_daily_reward_list(Level),
            RewardList1 = lists:foldl(F, RewardList, LevelReward),
            {Code1, RewardList1};
        false ->
            {Code, []}
    end.

get_daily_reward_list(0) -> {?SUCCESS, []}; % 之前未通关天数会保存，进行过滤
get_daily_reward_list(Level) ->
    case data_dungeon_special:get_rune_daily_reward(Level) of
        [] ->
            ?ERR("config error, Run Level reward miss, level: ~p~n", [Level]),
            {?FAIL, []};
        RewardList ->
            {?SUCCESS, RewardList}
    end.

send_status(Player) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, dun_rune_level_unlock = UnlockLevel, dun_rune_daily_reward = RuneDailyReward} = Player,
    #dun_rune_daily_reward{last_receive_time = LastReceiveTime} = RuneDailyReward,
    Level = get_dungeon_level(Player),

    DailyState = case Level < 1 of
        true -> 0;
        false ->
            ?IF(utime:diff_days(NowTime, LastReceiveTime) > 0, 1, 2)
    end,
    {ok, BinData} = pt_611:write(61115, [DailyState, UnlockLevel]),
    lib_server_send:send_to_uid(RoleId, BinData).

daily_clear() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_STATUS, lib_dungeon_rune, send_last_daily_reward, [])|| E <- OnlineRoles].

%% 邮件发放前面未领取的每日奖励
%% @return #player_status{}
send_last_daily_reward(Player) ->
    #player_status{id = RoleId, dun_rune_daily_reward = RuneDailyReward} = Player,
    #dun_rune_daily_reward{last_receive_time = LastReceiveTime, store_list = StoreList} = RuneDailyReward,
    LastDayTime = utime:unixdate() - 1, % 前一天时间作为最后领取时间以防卡当天每日奖励
    NowTime = utime:unixtime(),
    AfterDays = utime:diff_days(NowTime, LastReceiveTime),
    Level = get_dungeon_level(Player),

    case LastReceiveTime > 0 andalso AfterDays > 0 andalso Level > 0 of
        true ->
            StoreDays = length(StoreList),
            DiffDays = max(0, AfterDays - StoreDays - 1), % 剔除以往积压的和当天的
            SendListAdd = lists:duplicate(min(DiffDays, ?RUNE_DAILY_REWARD_MAX_NUM), Level),
            LevelList = lists:sublist(SendListAdd ++ StoreList, ?RUNE_DAILY_REWARD_MAX_NUM), % 兼容原版积压的奖励
            % 邮件发送奖励
            {Code, RewardList} = lists:foldl(fun calc_daily_reward_list/2, {?SUCCESS, []}, LevelList),
            case Code == ?SUCCESS andalso RewardList /= [] of
                true ->
                    mod_mail_queue:add_no_delay(?MOD_RUNE, [RoleId], utext:get(1670001), utext:get(1670002), RewardList),
                    lib_log_api:log_dungeon_rune_daily_reward(RoleId, Level, LevelList, RewardList),
                    NewDunRuneState = #dun_rune_daily_reward{last_receive_time = LastDayTime, store_list = []},
                    db_replace_daily_reward(RoleId, NewDunRuneState),
                    Player#player_status{dun_rune_daily_reward = NewDunRuneState};
                false ->
                    Player
            end;
        false ->
            Player
    end.


unlock_level(Player, Level) ->
    #player_status{id = RoleId, dun_rune_level_unlock = UnlockLevel} = Player,
    NowLevel = get_dungeon_level(Player),
    {NewLevel, {ok, BinData}} = case NowLevel >= Level andalso UnlockLevel < Level of
        true ->
            {Level, pt_611:write(61116, [?SUCCESS, Level])};
        false ->
            {UnlockLevel, pt_611:write(61116, [?ERRCODE(err610_rune_dun_level_limit), NowLevel])}
    end,
    lib_server_send:send_to_uid(RoleId, BinData),
    lib_counter:set_count(RoleId, ?MOD_DUNGEON, 10, 0, NewLevel),
    NewPlayer = Player#player_status{dun_rune_level_unlock = NewLevel},
    pp_rune:handle(16704, NewPlayer, []), % 客户端要求
    {ok, NewPlayer}.


db_select_daily_reward(RoleId) ->
    Sql = io_lib:format(?sql_select_dungeon_rune_daily_reward, [RoleId]),
    db:get_all(Sql).

db_replace_daily_reward(RoleId, DailyState) ->
    #dun_rune_daily_reward{last_receive_time = LastReceiveTime, update_time = UpdateTime, store_list = StoreList} = DailyState,
    Sql = io_lib:format(?sql_replace_dungeon_rune_daily_reward, [RoleId, LastReceiveTime, UpdateTime, util:term_to_bitstring(StoreList)]),
    db:execute(Sql).

gm_auto_unlock() ->
    NowTime = utime:unixtime(),
    Ids = data_dungeon:get_ids_by_type(?DUNGEON_TYPE_RUNE2),
    IdsStr = ulists:list_to_string(Ids, ","),
    % 获取所有打过符文副本的玩家数据
    Sql1 = io_lib:format("select player_id, count(*) from dungeon_best_record where dun_id in (~s) group by player_id", [IdsStr]),
    RoleInfos = db:get_all(Sql1),
    % 直接对计数器设值
    F = fun([RoleId, Level]) ->
        Sql2 = io_lib:format("replace into `counter` (`role_id`, `module`, `sub_module`, `type`, `count`, `other`, `refresh_time`)
                              VALUES (~p, ~p, ~p, ~p, ~p, '~s', ~p) ", [RoleId, ?MOD_DUNGEON, 10, 0, Level, util:term_to_bitstring([]), NowTime]), % 设值
        db:execute(Sql2)
    end,
    lists:foreach(F, RoleInfos),
    ok.