%%---------------------------------------------------------------------------
%% @doc:        lib_dungeon_limit_tower
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-3月-11. 14:52
%% @deprecated: 单人副本 - 限时爬塔
%%---------------------------------------------------------------------------
-module(lib_dungeon_limit_tower).

-include("common.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("server.hrl").
-include("def_module.hrl").
-include("counter_global.hrl").
-include("errcode.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("team.hrl").
-include("figure.hrl").

%% API
-export([
    login/1,
    daily_check/0,
    daily_check/1,
    send_panel_info/1,
    get_big_reward/2
]).

-export([
    dunex_check_extra/2,
    handle_event/2
]).

-export([
    get_data/1,
    reset_limit_tower_data/1,
    set_pass_success_all/2,
    gm_change_open_day/1,
    gm_settleAccounts/1
]).

login(Ps) ->
    #player_status{ id = PlayerId } = Ps,
    case get_data_from_db(PlayerId) of
        [Round, OverTime, PassList, RewardMode] ->
            FixPassList = util:bitstring_to_term(PassList),
            LimitTower = make_record(Round, OverTime, FixPassList, RewardMode),
            LastLimitTower = check_is_expire(PlayerId, LimitTower);
        _ ->
            LastLimitTower = update_limit_data(PlayerId, none)
    end,
    Ps#player_status{ limit_tower = LastLimitTower }.

%% 轮次迭代
update_limit_data(PlayerId, CurRound) ->
    AllRound = data_dungeon:get_all_limit_tower_round(),
    OpenDay = util:get_open_day(),
    Predicate = fun(Round, AccL) ->
        #base_limit_tower_round{
            begin_day = BeginDay,
            over_day = OverDay
        } = data_dungeon:get_limit_tower_round_info(Round),
        case OpenDay >= BeginDay andalso OpenDay =< OverDay of
            true ->
                [{Round, OverDay}|AccL];
            false ->
                AccL
        end
    end,
    Filter = lists:foldl(Predicate, [], AllRound),
    case Filter of
        [] ->
            NewRound = 0,   %% 无合适的轮数配置，表示活动关闭，相应数据具设为0
            NewOverTime = 0;
        _ ->
            {NewRound, OverDay} = lists:min(Filter),    %% 有多轮时间重叠时，取轮数最小的
            NewOverTime = util:get_open_time() + OverDay * 86400
    end,
    case NewRound == CurRound of
        true ->
            skip;
        false ->
            %% 更新数据库
            db:execute(io_lib:format(?SQL_UPDATE_LIMIT_POWER_DATA, [PlayerId, NewRound, NewOverTime, util:term_to_string([]), 0]))
    end,
    #status_limit_tower{ round = NewRound, over_time = NewOverTime }.

get_data_from_db(PlayerId) ->
    Sql = io_lib:format(?SQL_SELECT_LIMIT_TOWER_DATA, [PlayerId]),
    db:get_row(Sql).

make_record(Round, OverTime, PassList, RewardMode) ->
    #status_limit_tower{
        round = Round,
        over_time = OverTime,
        pass_id = PassList,
        reward_mode = RewardMode
    }.

%% 检测玩家身上的数据是否已过期，是否需要补发关卡大奖，同时执行轮次迭代
check_is_expire(PlayerId, LimitTower) ->
    #status_limit_tower{ round = Round, over_time = OverTime} = LimitTower,
    NowSec = utime:unixtime(),
    case NowSec >= OverTime of
        true ->
            ?IF(Round == 0, skip, send_big_reward_by_email(PlayerId, LimitTower)),
            update_limit_data(PlayerId, Round);
        _ ->
            LimitTower
    end.

send_big_reward_by_email(PlayerId, LimitTower) when is_integer(PlayerId) ->
    #status_limit_tower{ round = Round, reward_mode = RewardMode } = LimitTower,
    case data_dungeon:get_limit_tower_round_info(Round) of
        #base_limit_tower_round{big_reward = Reward, name = Name } ->
            case RewardMode == 1 of
                true ->
                    lib_mail_api:send_sys_mail([PlayerId], utext:get(6103605, [util:make_sure_binary(Name)]), utext:get(6103606, [util:make_sure_binary(Name)]), Reward);
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

%% 每日检测判断是否需要更新轮次，补发奖励
daily_check() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        [begin
             timer:sleep(500),
             lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_dungeon_limit_tower, daily_check, [])
         end || E <- OnlineRoles]
          end).

daily_check(Ps) ->
    #player_status{ id = PlayerId, limit_tower = LimitTower } = Ps,
    NewLimitTower = check_is_expire(PlayerId, LimitTower),
    NewPs = Ps#player_status{ limit_tower = NewLimitTower },
    send_panel_info(NewPs),
    {ok, NewPs}.

%% 发送通关信息等
send_panel_info(Ps) ->
    #player_status{ limit_tower = LimitTower, id = PlayerId } = Ps,
    case LimitTower of
        #status_limit_tower{ pass_id = PassList, reward_mode = RewardMode, over_time = OverTime, round = Round } ->
            Args = [Round, OverTime, RewardMode, PassList];
        _ ->
            Args = [0, 0, 0, []]
    end,
    pack(PlayerId, 61117, Args).

pack(PlayerId, Cmd, Args) ->
    {ok, Bin} = pt_611:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, Bin).

%% 手动领取大奖
get_big_reward(Ps, Round) ->
    Cmd = 61118,
    #player_status{ limit_tower = LimitTower, id = PlayerId, figure = #figure{ name = PlayerName } } = Ps,
    case LimitTower of
        #status_limit_tower{ round = CurRound, over_time = OverTime, pass_id = PassList, reward_mode = RewardMode } ->
            case catch check_can_get_reward(Round, PassList, CurRound, OverTime, RewardMode) of
                {ok, RewardList, RoundName} ->
                    NewLimitTower = LimitTower#status_limit_tower{ reward_mode = 2 },
                    db:execute(io_lib:format(?SQL_UPDATE_LIMIT_TOWER_REWARD, [2, PlayerId])),
                    NewPlayer = Ps#player_status{ limit_tower = NewLimitTower },
                    Produce = #produce{type = limit_tower_big_reward, reward = RewardList, show_tips = ?SHOW_TIPS_1},
                    NewPs = lib_goods_api:send_reward(NewPlayer, Produce),
                    %% Fun = fun(PassId) -> mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, PassId, 1) end,
                    %% lists:foreach(Fun, PassList),
                    lib_chat:send_TV({all}, ?MOD_DUNGEON, 11, [util:make_sure_binary(PlayerName), util:make_sure_binary(RoundName)]),
                    pack(PlayerId, Cmd, [?SUCCESS]);
                {error, ErrorMsg} ->
                    NewPs = Ps,
                    pack(PlayerId, Cmd, [?ERRCODE(ErrorMsg)])
            end;
        _ ->
            NewPs = Ps,
            pack(PlayerId, Cmd, [?LEVEL_LIMIT])
    end,
    {ok, NewPs}.

check_can_get_reward(Round, PassList, CurRound, OverTime, RewardMode) ->
    NowSec = utime:unixtime(),
    if
        CurRound =/= Round orelse NowSec >= OverTime ->
            {error, err610_limit_tower_round_over};
        RewardMode == 2 ->
            {error, reward_is_got};
        true ->
            case data_dungeon:get_limit_tower_round_info(Round) of
                #base_limit_tower_round{ dup_list = DupList, big_reward = Reward, name = Name } ->
                    case RewardMode == 1 orelse lists:subtract(DupList, PassList) of
                        true ->
                            {ok, Reward, Name};
                        _ ->
                            {error, err610_not_pass_all_dup}
                    end;
                _ ->
                    {error, missing_config}
            end
    end.


%% ================  进去副本时，合法性的判断 ===================
dunex_check_extra(Player, #dungeon{ id = DupId }) ->
    case catch do_dunex_check_extra(Player, DupId) of
        ok -> true;
        {error, Code} ->
            {false, Code}
    end.

do_dunex_check_extra(Player, DupId) ->
    case Player#player_status.limit_tower of
        #status_limit_tower{ round = CurRound,  over_time = OverTime, pass_id = PassList} ->
            NowSec = utime:unixtime(),
            #base_limit_tower_round{ dup_list = DupList } = data_dungeon:get_limit_tower_round_info(CurRound),
            Filter = [DupId2 || DupId2 <- DupList, DupId2 < DupId],
            ChekDupId = ?IF(Filter == [], hd(DupList), lists:max(Filter)),
            Flag = lists:member(DupId, DupList),
            if
                OverTime =< NowSec ->
                    {error, ?ERRCODE(err610_limit_tower_not_update)};
                not Flag ->
                    {error, ?ERRCODE(err610_dungeon_count_cfg_error)};
                PassList == [] ->
                    case ChekDupId == DupId of
                        true -> ok;
                        _ -> {error, ?ERRCODE(err610_not_pass_first_dup)}
                    end;
                true ->
                    case lists:member(ChekDupId, PassList) of
                        true -> ok;
                        _ -> {error, ?ERRCODE(err610_not_pass_last_dup)}
                    end
            end;
        _ ->
            {error, ?LEVEL_LIMIT}
    end.

%% 通过后更新已通关的数据
handle_event(Ps, #event_callback{ type_id = ?EVENT_DUNGEON_SUCCESS, data = Data }) ->
    #player_status{limit_tower = LimitTower, id = PlayerId } = Ps,
    #callback_dungeon_succ{dun_id = DunId, dun_type = DunType } = Data,
    case DunType of
        ?DUNGEON_TYPE_LIMIT_TOWER ->
            NewLimitTower = update_limit_tower_data(PlayerId, LimitTower, DunId),
            LastPs = Ps#player_status{ limit_tower = NewLimitTower },
            send_panel_info(LastPs);
        _ ->
            LastPs = Ps
    end,
    {ok, LastPs};
handle_event(Ps, _) ->
    {ok, Ps}.

%% 更新通过的关卡
update_limit_tower_data(PlayerId, LimitTower, DunId) ->
    case LimitTower of
        #status_limit_tower{ round = Round, pass_id = PassList, reward_mode = RewardMode } ->
            NewPassList = ?IF( lists:member(DunId, PassList), PassList, [DunId|PassList]),
            %% 更新大奖状态
            #base_limit_tower_round{ dup_list = DupList } = data_dungeon:get_limit_tower_round_info(Round),
            CheckFirst = lists:subtract(DupList, NewPassList),
            NewRewardMode = ?IF(CheckFirst == [] andalso RewardMode == 0, 1, RewardMode),
            db:execute(io_lib:format(?SQL_UPDATE_LIMIT_TOWER_PASS_LIST, [util:term_to_string(NewPassList), NewRewardMode, PlayerId])),
            LimitTower#status_limit_tower{ pass_id = NewPassList, reward_mode = NewRewardMode };
        _ ->
            LimitTower
    end.

%% ===========================================
%% GM
%% ===========================================

%% 重置当前轮通关信息
reset_limit_tower_data(Ps) ->
    #player_status{ limit_tower = LimitTower, id = PlayerId } = Ps,
    case LimitTower of
        #status_limit_tower{ pass_id = PassList } ->
            NewLimitTower = update_limit_data(PlayerId, 0),
            NewPs = Ps#player_status{ limit_tower = NewLimitTower },
            Fun = fun(PassId) -> mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, PassId, 0) end,
            lists:foreach(Fun, PassList),
            send_panel_info(NewPs),
            NewPs;
        _ ->
            Ps
    end.

set_pass_success_all(Ps, Round) ->
    #player_status{ limit_tower = LimitTower, id = PlayerId } = Ps,
    case LimitTower of
        #status_limit_tower{ over_time = OverTime } ->
            #base_limit_tower_round{ dup_list = PassList } = data_dungeon:get_limit_tower_round_info(Round),
            NewLimitTower = LimitTower#status_limit_tower{ round = Round, reward_mode = 1, pass_id = PassList },
            NewPs = Ps#player_status{ limit_tower = NewLimitTower },
            Fun = fun(PassId) -> mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, PassId, 1) end,
            lists:foreach(Fun, PassList),
            db:execute(io_lib:format(?SQL_UPDATE_LIMIT_POWER_DATA, [PlayerId, Round, OverTime, util:term_to_string(PassList), 1])),
            send_panel_info(NewPs),
            NewPs;
        _ ->
            Ps
    end.

gm_change_open_day(Ps0) ->
    #player_status{id = PlayerId } = Ps0,
    Ps = reset_limit_tower_data(Ps0),
    NewLimitTower = update_limit_data(PlayerId, none),
    NewPs = Ps#player_status{ limit_tower = NewLimitTower },
    send_panel_info(NewPs),
    {ok, NewPs}.

gm_settleAccounts(Ps) ->
    #player_status{ limit_tower = LimitTower, id = PlayerId} = Ps,
    #status_limit_tower{ pass_id = PassList, round = Round} = LimitTower,
    ?IF(Round == 0, skip, send_big_reward_by_email(PlayerId, LimitTower)),
    Fun = fun(PassId) -> mod_counter:set_count(PlayerId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, PassId, 1) end,
    ?IF(Round == 0, skip, lists:foreach(Fun, PassList)),
    NewLimitTower = update_limit_data(PlayerId, none),
    NewPs = Ps#player_status{ limit_tower = NewLimitTower },
    send_panel_info(NewPs),
    {ok, NewPs}.

get_data(Ps) ->
    LimitTower = Ps#player_status.limit_tower,
    case LimitTower of
        #status_limit_tower{ } ->
            LimitTower;
        _ -> skip
    end.