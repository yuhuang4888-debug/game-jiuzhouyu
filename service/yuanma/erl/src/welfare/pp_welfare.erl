-module(pp_welfare).

-export([handle/3,
    send_night_reward_status/1
]).

-include("version_upgradebag.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("rec_rush_giftbag.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("vip.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("checkin.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("counter.hrl").
-include("kv.hrl").
-include("welfare.hrl").
-include("goods.hrl").
%%---------------------------------------------------------------------------------
%%  冲级礼包
%%---------------------------------------------------------------------------------

%% 获取礼包状态
handle(41700, PS, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        rush_giftbag = RushGB
    } = PS,
    #rush_giftbag{
        giftbag_state = RushGBState
    } = RushGB,
    #figure{lv = RoleLv} = Figure,
    RefreshedStatus = lib_rush_giftbag:refresh_rush_status(RoleLv, RushGBState),
    FianlPS = PS#player_status{rush_giftbag = #rush_giftbag{giftbag_state = RefreshedStatus}},
    {ok, BinData} = pt_417:write(41700, [RefreshedStatus]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, FianlPS};

%% 领取等级礼包
handle(41701, PS, [BagLv]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        rush_giftbag = RushGB
    } = PS,
    #figure{
        lv = PlayerLv,
        sex = Sex
    } = Figure,
    #rush_giftbag{
        giftbag_state = RushGBState
    } = RushGB,
    {Res, NewPs, Rew} =
        case PlayerLv >= ?GiftBagOpenLv of
            false ->
                {?LEVEL_LIMIT, PS, []};
            true ->
                case data_rush_giftbag:get_giftbag_cfg(BagLv) of
                    [] ->
                        {?ERRCODE(err417_gift_not_exists), PS, []};
                    GiftCfg ->
                        #base_rush_giftbag{
                            bag_upperlimit = UpperLimit, % 礼包数量限制
                            bag_upperday = UpperDay, % 礼包领取最大天数
                            bag_gift_man = RewardsMan, % 男性礼包
                            bag_gift_woman = RewardsWoman, % 女性礼包
                            limit_gift_man = LimitMan, % 限量礼包
                            limit_gift_woman = LimitWoman   % 限量礼包
                        } = GiftCfg,
                        CheckList =
                            [{lv, BagLv, PlayerLv}, % 判断等级
                                {is_received, RushGBState, BagLv}, % 检查是否领取过
                                {reach_on_time, UpperDay} % 检查开服时间
%%                                {gift_send_out, BagLv, UpperLimit}, % 礼包是否已经派完
%%                                {space_enougth, PS, Rewards}
                            ], % 检查的顺序是优先本身的检查
                        case check_rush_giftbag(CheckList) of
                            true ->
                                NewRushGBState = lists:keystore(BagLv, 1, RushGBState, {BagLv, ?GIFTBAG_RECEIVED, 0, 0}),
                                ReceivePS = PS#player_status{rush_giftbag = RushGB#rush_giftbag{giftbag_state = NewRushGBState}},
                                Filter = fun({BLv, State, _, _}, L) ->
                                    if State =:= ?GIFTBAG_RECEIVED -> [{BLv, State} | L]; true -> L end end,
                                FilterRushState = lists:foldl(Filter, [], NewRushGBState),
                                update_rush_giftbag_db(ReceivePS, FilterRushState),
                                CurrNum = mod_global_counter:get_count(?MOD_WELFARE, ?RUSH_GIFTBAG, BagLv),
                                Rewards = % 奖励
                                case UpperLimit of % 没有配置就没有限量
                                    0 ->
                                        case Sex =:= ?MALE of
                                            true -> RewardsMan;
                                            false -> RewardsWoman
                                        end;
                                    UpLimit ->
                                        case CurrNum < UpLimit of   % 礼包是否已经派完
                                            true ->
                                                case Sex =:= ?MALE of
                                                    true -> RewardsMan ++ LimitMan;
                                                    false -> RewardsWoman ++ LimitWoman
                                                end;
                                            false ->
                                                case Sex =:= ?MALE of
                                                    true -> RewardsMan;
                                                    false -> RewardsWoman
                                                end
                                        end
                                end,
                                mod_global_counter:increment(?MOD_WELFARE, ?RUSH_GIFTBAG, BagLv),
                                RushNum = CurrNum + 1,
                                lib_log_api:log_rush_giftbag(RoleId, PlayerLv, Sex, BagLv, RushNum, Rewards),
                                ta_agent_fire:log_rush_giftbag(PS, [Sex, BagLv, RushNum]),
                                %% 发送奖励
                                NewPsTmp = lib_goods_api:send_reward(ReceivePS, Rewards, rush_giftbag, 0),
                                lib_goods_api:send_tv_tip(RoleId, Rewards),
                                lib_task_api:award_lv_gift(NewPsTmp, BagLv),
                                % 通知在线玩家数量变更
                                {ok, BinDataTmp} = pt_417:write(41717, [BagLv, RushNum]),
                                %% 通知全世界
                                lib_rush_giftbag:send_to_all_online(fun(Id) -> lib_server_send:send_to_uid(Id, BinDataTmp) end),
                                {?SUCCESS, NewPsTmp, Rewards};
                            {false, TempRes} ->
                                {TempRes, PS, []}
                        end
                end
        end,
    {ok, BinData} = pt_417:write(41701, [BagLv, Res, Rew]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};
%%---------------------------------------------------------------------------------
%%  版本更新礼包
%%---------------------------------------------------------------------------------

%% 领取版本礼包
handle(41702, Ps, [VersionCode]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    {Code, NewPs} =
        case Lv >= ?VersionUpgradeBagOpenLv of
            false -> {?LEVEL_LIMIT, Ps};
            true ->
                case data_version_upgradebag:get_version_cfg(VersionCode) of
                    [] -> {?ERRCODE(err417_version_not_upgrade), Ps};
                    #base_version_upgradebag_reward{rewards = Rewards, starttime = StartTime, endtime = EndTime, state = VersionState} ->
                        RoleId = Ps#player_status.id,
                        CheckList = [{check_time_out, StartTime, EndTime}, {check_state, VersionState}, {check_has_received, RoleId, StartTime, EndTime}],
                        case check_code(CheckList) of
                            true ->
                                case lib_goods_api:can_give_goods(Ps, Rewards) of
                                    true ->
                                        update_db(RoleId, VersionCode, Rewards),
                                        NewPsTmp = lib_goods_api:send_reward(Ps, Rewards, version_upgradebag, 0),
                                        lib_goods_api:send_tv_tip(RoleId, Rewards),
                                        {?SUCCESS, NewPsTmp};
                                    {false, ErrorCode} -> {ErrorCode, Ps}
                                end;
                            {false, CodeTmp} -> {CodeTmp, Ps}
                        end
                end
        end,
    {ok, BinData} = pt_417:write(41702, [Code, VersionCode]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPs};

%%---------------------------------------------------------------------------------
%%  每日签到
%%---------------------------------------------------------------------------------
%% 推送每日签到状态
handle(41703, PlayerStatus, []) ->
    #player_status{
        sid = Sid,
        id = RoleId,
        figure = Figure,
        check_in = CheckInSt,
        reg_time = Regtime
    } = PlayerStatus,
    #figure{
        lv = Lv
    } = Figure,
    % Month = utime:get_month(),
    {Month, CurDay} = lib_checkin:get_open_server_date(Regtime),
    OpenLvCfg = lib_checkin:get_open_lv(),
    case Lv >= OpenLvCfg of
        false ->
            {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            CheckDay = mod_daily:get_count(RoleId, ?MOD_WELFARE, 6),
            case CheckInSt of
                #checkin_status{total_state = TotalState, daily_state = DailyState,
                    retroactive_times = RetroTimes, remain_times = RemainTimes}
                    when TotalState /= undefined, DailyState /= undefined ->
                    TotalCheckDays = lib_checkin:get_checkin_days(DailyState),
                    case data_checkin:get_checkin_type(PlayerStatus#player_status.figure#figure.lv, Month) of
                        [] ->
                            ?ERR("checkin cfg err: no such Month cfg exist!{Id, Month, CurDay}~p~n", [{PlayerStatus#player_status.id, Month, CurDay}]),
                            {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, RemainTimes, CheckDay]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        #base_checkin_type{daily_type = DailyType, total_type = TotalType} ->
                            % ?PRINT("DailyState:~p~n",[DailyState]),
%%                            ?MYLOG("cym", "DailyState ++++++++++++++++ ~p ~n", [DailyState]),
                            {ok, BinData} = pt_417:write(41703, [TotalCheckDays, TotalType, TotalState,
                                DailyState, DailyType, RetroTimes, CurDay, RemainTimes, CheckDay]),
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_417:write(41703, [0, 1, [], [], 1, 0, CurDay, 0, CheckDay]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end;

% % 领取每天签到的礼包
handle(41704, PlayerStatus, [Day, IsRetroActive]) ->
    #player_status{sid = Sid} = PlayerStatus,
    case lib_checkin:receive_gift(PlayerStatus, Day, IsRetroActive) of
        {true, NewPS, RewardL} ->
            % CheckState  = lib_checkin:get_daily_status(NewPS),
            % NewPSs = NewPS#player_status{check_in = CheckState},
            {ExtraR, Reward} = RewardL,
            % ?PRINT("Reward, ExtraR:~p~n",[{Reward, ExtraR}]),
            {ok, BinData} = pt_417:write(41704, [?SUCCESS, Reward, ExtraR]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPS1} = lib_player_event:dispatch(NewPS, ?EVENT_CHECK_IN),
            lib_task_api:award_daily(NewPS1, 1),
            % {ok, NewPs} = lib_achievement_api:check_in_event(NewPS1, []),
            {ok, NewPS1};
        {false, Res, NewPS} ->
            {ok, BinData} = pt_417:write(41704, [Res, [], []]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPS}
    end;

% % 领取累计签到的礼包
handle(41705, PlayerStatus, [TotalDays]) ->
    #player_status{sid = Sid} = PlayerStatus,
    case lib_checkin:receive_total_gift(PlayerStatus, TotalDays) of
        {true, NewPS, RewardL} ->
            {ok, BinData} = pt_417:write(41705, [?SUCCESS, RewardL]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPS};
        {false, Res, NewPS} ->
            {ok, BinData} = pt_417:write(41705, [Res, []]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, NewPS}
    end;

%% 版本礼包领取状态
handle(41706, Ps, [VersionCode]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    case Lv >= ?VersionUpgradeBagOpenLv of
        false ->
            Code = 0;
        true ->
            Code =
                case data_version_upgradebag:get_version_cfg(VersionCode) of
                    [] -> 0;
                    #base_version_upgradebag_reward{starttime = StartTime, endtime = EndTime, state = VersionState} ->
                        CheckList = [{check_time_out, StartTime, EndTime}, {check_state, VersionState}, {check_has_received, RoleId, StartTime, EndTime}],
                        case check_code(CheckList) of
                            true -> 1;
                            {false, Code1} ->
                                case Code1 =:= ?ERRCODE(err417_upgradebag_has_received) of
                                    true -> 2;
                                    false -> 0
                                end
                        end
                end
    end,
    {ok, BinData} = pt_417:write(41706, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData);


% ########### 下载礼包领取状态 ##############
handle(41707, PS, []) ->
    case data_key_value:get(?KEY_DOWNLOAD_GIFT) of
        [_ | _] = RewardList ->
            case mod_counter:get_count(PS#player_status.id, ?MOD_WELFARE, ?COUNT_ID_417_DOWNLOAD_FIGT) of
                0 ->
                    {ok, BinData} = pt_417:write(41707, [1, RewardList]);
                _ ->
                    {ok, BinData} = pt_417:write(41707, [2, RewardList])
            end;
        _ ->
            {ok, BinData} = pt_417:write(41707, [0, []])
    end,
    lib_server_send:send_to_sid(PS#player_status.sid, BinData);

% ########### 下载礼包领取 ##############
handle(41708, PS, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = PS,
    #figure{
        lv = Lv
    } = Figure,
    case data_key_value:get(?KEY_DOWNLOAD_GIFT_LV_ID) of
        undefined ->
            Code = ?FAIL,
            NewPS = PS;
        DownLoadGiftOpenLv ->
            case Lv >= DownLoadGiftOpenLv of
                false ->
                    Code = ?LEVEL_LIMIT,
                    NewPS = PS;
                true ->
                    case data_key_value:get(?KEY_DOWNLOAD_GIFT) of
                        [_ | _] = RewardList ->
                            case mod_counter:get_count(PS#player_status.id, ?MOD_WELFARE, ?COUNT_ID_417_DOWNLOAD_FIGT) of
                                0 ->
                                    case lib_goods_api:can_give_goods(PS, RewardList) of
                                        true ->
                                            Code = ?SUCCESS,
                                            mod_counter:set_count(PS#player_status.id, ?MOD_WELFARE, ?COUNT_ID_417_DOWNLOAD_FIGT, 1),
                                            NewPS = lib_goods_api:send_reward(PS, RewardList, down_load_gift, 0);
                                        {false, ErrorCode} ->
                                            Code = ErrorCode,
                                            NewPS = PS
                                    end;
                                _ ->
                                    Code = ?ERRCODE(reward_is_got),
                                    NewPS = PS
                            end;
                        _ ->
                            Code = ?FAIL,
                            NewPS = PS
                    end
            end
    end,
    {ok, BinData} = pt_417:write(41708, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPS};

%% 分享有礼状态
handle(41710, PS, []) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, status_share = StatusShare} = PS,
    NeedLv = lib_share:get_open_lv(),
    case RoleLv >= NeedLv of
        true ->
            lib_share:send_share_status(RoleId, StatusShare);
        false -> skip
    end;

%% 分享成功
handle(41711, PS, []) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, status_share = StatusShare} = PS,
    NeedLv = lib_share:get_open_lv(),
    case RoleLv >= NeedLv of
        true ->
            case catch lib_share:share_success(RoleId, StatusShare) of
                {ok, NewStatusShare} ->
                    {ok, PS#player_status{status_share = NewStatusShare}};
                Err ->
                    ?ERR("share err:~p", [Err])
            end;
        false -> skip
    end;

%% 分享有礼奖励领取
handle(41712, PS, []) ->
    #player_status{sid = Sid, figure = #figure{lv = RoleLv}} = PS,
    NeedLv = lib_share:get_open_lv(),
    case RoleLv >= NeedLv of
        true ->
            lib_share:receive_reward(PS);
        false ->
            {ok, BinData} = pt_417:write(41712, [?ERRCODE(lv_limit)]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 夜间福利领取状态
%% 0:不可领 1：可领 2：已领
handle(41713, PS, []) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    OpenLv = data_welfare:get_cfg(night_welfare_open_lv),
    case data_welfare:get_cfg(night_welfare_open_time) of
        [{SH, SM}, {EH, EM}] ->
            Time = utime:unixtime() - utime:unixdate(),
            if
                RoleLv < OpenLv -> State = 0;
                true ->
                    case mod_daily:get_count(RoleId, ?MOD_WELFARE, 3) of
                        0 ->
                            case Time =< EH * 3600 + EM * 60 andalso Time >= SH * 3600 + SM * 60 of
                                true -> State = 1;
                                _ -> State = 0
                            end;
                        1 -> State = 2
                    end
            end,
            lib_server_send:send_to_sid(Sid, pt_417, 41713, [?SUCCESS, State]);
        _ ->
            lib_server_send:send_to_sid(Sid, pt_417, 41713, [?MISSING_CONFIG, 0])
    end;

%% 夜间福利领取
handle(41714, PS, []) ->
    #player_status{sid = Sid, id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    OpenLv = data_welfare:get_cfg(night_welfare_open_lv),
    case data_welfare:get_cfg(night_welfare_open_time) of
        [{SH, SM}, {EH, EM}] ->
            Time = utime:unixtime() - utime:unixdate(),
            if
                RoleLv < OpenLv ->
                    Status = 0, Code = ?LEVEL_LIMIT,
                    NewPS = PS;
                true ->
                    case mod_daily:get_count(RoleId, ?MOD_WELFARE, 3) of
                        0 ->
                            case Time =< EH * 3600 + EM * 60 andalso Time >= SH * 3600 + SM * 60 of
                                true ->
                                    RewardList = get_night_welfare_reward(RoleLv),
                                    case lib_goods_api:can_give_goods(PS, RewardList) of
                                        true ->
                                            Status = 2, Code = ?SUCCESS,
                                            NewPS = lib_goods_api:send_reward(PS, RewardList, night_welfare, 0),
                                            mod_daily:increment(RoleId, ?MOD_WELFARE, 3);
                                        {false, ErrorCode} ->
                                            Status = 1, Code = ErrorCode,
                                            NewPS = PS
                                    end;
                                _ ->
                                    Status = 0, Code = ?ERRCODE(err417_night_welfare_not_reward),
                                    NewPS = PS
                            end;
                        _ ->
                            Status = 2, Code = ?ERRCODE(err417_night_welfare_already_reward),
                            NewPS = PS
                    end
            end;
        _ ->
            Status = 0, Code = ?MISSING_CONFIG,
            NewPS = PS
    end,
    lib_server_send:send_to_sid(Sid, pt_417, 41714, [Code, Status]),
    {ok, NewPS};

%% 在线福利界面
handle(41715, PS, []) ->
    OpenLv = case data_welfare:get_cfg(online_reward_open_lv) of
                 OpenLvCfg when is_integer(OpenLvCfg) -> OpenLvCfg;
                 _ -> 1
             end,
    RoleLv = PS#player_status.figure#figure.lv,
    if
        RoleLv >= OpenLv ->
            lib_online_reward:get_info(PS);
        true ->
            {ok, PS}
    end;


%% 在线福利领取
handle(41716, PS, [Id]) ->
    OpenLv = case data_welfare:get_cfg(online_reward_open_lv) of
                 OpenLvCfg when is_integer(OpenLvCfg) -> OpenLvCfg;
                 _ -> 1
             end,
    RoleLv = PS#player_status.figure#figure.lv,
    if
        RoleLv >= OpenLv ->
            NewPs = lib_online_reward:send_reward(PS, Id);
        true ->
            NewPs = PS
    end,
    {ok, NewPs};

handle(41718, PS, [Name, Number, Type]) ->
    lib_collec_info:do_get_reward(PS, Name, Number, Type);

handle(41719, PS, [Opr]) when Opr == 1 orelse Opr == 2 ->
    #player_status{id = RoleId, sid = Sid, source = Source} = PS,
    SourceList = data_xinyue_gift:get_kv(1),
    TestRoleList = data_xinyue_gift:get_kv(4),
    case TestRoleList == [] orelse lists:member(RoleId, TestRoleList) of 
        true ->
            case lists:member(list_to_atom(util:make_sure_list(Source)), SourceList) of 
                true ->
                    GiftSt = mod_daily:get_count(RoleId, ?MOD_WELFARE, 5),
                    RewardList = data_xinyue_gift:get_kv(2),
                    case Opr of 
                        1 ->
                            lib_server_send:send_to_sid(Sid, pt_417, 41719, [1, Opr, GiftSt, RewardList]);
                        2 ->
                            case GiftSt > 0 of 
                                true ->
                                    lib_server_send:send_to_sid(Sid, pt_417, 41719, [?ERRCODE(err417_has_received), Opr, GiftSt, []]);
                                _ ->
                                    Produce = #produce{type = xinyue_gift, reward = RewardList},
                                    NewPS = lib_goods_api:send_reward(PS, Produce),
                                    mod_daily:increment(RoleId, ?MOD_WELFARE, 5),
                                    lib_server_send:send_to_sid(Sid, pt_417, 41719, [1, Opr, 1, RewardList]),
                                    {ok, NewPS}
                            end
                    end;
                _ ->   
                    ok
            end;
        _ ->
            ok
    end;

handle(41719, PS, [Opr]) ->
    #player_status{sid = Sid, id = RoleId, reg_time = RegTime} = PS,
    case check_cfg() of
        {CfgTime, RewardList} when RegTime >= CfgTime ->
            % ?PRINT("==== RegTime:~p~n",[RegTime]),
            case Opr of
                3 ->
                    GiftSt = mod_counter:get_count(PS#player_status.id, ?MOD_WELFARE, 2),
                    Code = ?SUCCESS, NewPS = PS;
                4 ->
                    GiftSt = 1,
                    case mod_counter:get_count(PS#player_status.id, ?MOD_WELFARE, 2) of % COUNT_ID_417_NEW_PLAYER_GIF
                        0 ->
                            case lib_goods_api:can_give_goods(PS, RewardList) of
                                true ->
                                    Code = ?SUCCESS,
                                    mod_counter:set_count(PS#player_status.id, ?MOD_WELFARE, 2, 1),
                                    NewPS = lib_goods_api:send_reward(PS, RewardList, new_player_gift, 0);
                                {false, ErrorCode} ->
                                    Code = ErrorCode,
                                    NewPS = PS
                            end;
                        _ ->
                            Code = ?ERRCODE(reward_is_got),
                            NewPS = PS
                    end;
                _ ->
                    Code = ?FAIL, GiftSt = 0,
                    NewPS = PS
            end;
        {_, RewardList} ->
            GiftSt0 = mod_counter:get_count(PS#player_status.id, ?MOD_WELFARE, 2),
            % ?PRINT("==== GiftSt:~p~n",[GiftSt]),
            if
                GiftSt0 == 0 ->
                    mod_counter:set_count(PS#player_status.id, ?MOD_WELFARE, 2, 1),
                    {Title, Content} = get_mail_info(),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
                true ->
                    skip
            end,
            GiftSt = 1,
            Code = ?ERRCODE(reward_is_got), 
            NewPS = PS;
        _ ->
            Code = ?MISSING_CONFIG, GiftSt = 0,
            RewardList = [], NewPS = PS
    end,
    lib_server_send:send_to_sid(Sid, pt_417, 41719, [Code, Opr, GiftSt, RewardList]),
    {ok, NewPS};

%% 获取成长福利任务进度
handle(41720, PS, []) ->
    lib_grow_welfare:send_grow_welfare_process(PS),
    {ok, PS};

%% 成长福利任务领取
handle(41722, PS, [TaskId]) ->
    case lib_grow_welfare:receive_grow_welfare(PS, TaskId) of
        {false, Errcode} ->
            lib_server_send:send_to_uid(PS#player_status.id, pt_417, 41722, [Errcode, TaskId, 0]);
        {true, NewPS} ->
            lib_server_send:send_to_uid(PS#player_status.id, pt_417, 41722, [?SUCCESS, TaskId, ?GROW_WELFARE_HAD_RECEIVE]),
            {ok, NewPS}
    end;

%% 查询战力福利信息
handle(41723, Player, []) ->
    lib_combat_welfare:send_panel_info(Player),
    {ok, Player};

%% 战力福利抽奖
handle(41724, Player, []) ->
    NewPlayer = lib_combat_welfare:combat_welfare_draw(Player),
    {ok, NewPlayer};

handle(_Code, PS, _Arg) ->
    {ok, PS}.

check_cfg() ->
    case data_welfare:get_cfg(new_player_reward_time) of
        CfgTime when is_integer(CfgTime) andalso CfgTime > 0 ->
            case data_welfare:get_cfg(new_player_reward) of
                [{_, _, _}| _] = RewardList -> %% 限定奖励格式
                    {CfgTime, RewardList};
                _ ->
                    false
            end;
        _ ->
            false
    end.

update_rush_giftbag_db(PS, RushGBState) ->
    RushGBState_B = util:term_to_string(RushGBState),
    Sql = io_lib:format(?sql_replace_rush_giftbag, [PS#player_status.id, RushGBState_B]),
    db:execute(Sql).

check_rush_giftbag([]) -> true;
check_rush_giftbag([H | T]) ->
    case do_check_rush_giftbag(H) of
        true -> check_rush_giftbag(T);
        {false, Res} -> {false, Res}
    end.

%% 检查等级
do_check_rush_giftbag({lv, BagLv, PlayerLv}) ->
    case PlayerLv >= BagLv of
        true -> true;
        false -> {false, ?ERRCODE(err417_playerlv_not_valid)}
    end;

%% 检查是否领取过
do_check_rush_giftbag({is_received, RushGBStatus, BagLv}) ->
    case lists:keyfind(BagLv, 1, RushGBStatus) of
        {_, ?GIFTBAG_RECEIVED, _, _} -> {false, ?ERRCODE(err417_has_received)};
        {_, ?GIFTBAG_NOT_RECEIVED, _, _} -> true;
        {_, ?GIFTBAG_CAN_RECEIVE, _, _} -> true;
        _ -> {false, ?FAIL}
    end;

%% 检查开服时间
do_check_rush_giftbag({reach_on_time, UpperDay}) ->
    if
        UpperDay == 0 -> true;
        true ->
            Opday = util:get_open_day(),
            case Opday =< UpperDay of
                true -> true;
                false -> {false, ?ERRCODE(err417_out_of_time)}
            end
    end;

%% 礼包是否已经派完
%%do_check_rush_giftbag({gift_send_out, BagLv, UpperLimit}) ->
%%    if
%%        UpperLimit == 0 -> true;
%%        true ->
%%            CurrNum = lib_global_counter:get_count(?MOD_WELFARE, ?RUSH_GIFTBAG, BagLv),
%%            case CurrNum < UpperLimit of
%%                true -> true;
%%                false -> {false, ?ERRCODE(err417_gift_send_out)}
%%            end
%%    end;

%% 检查背包空间
do_check_rush_giftbag({space_enougth, PS, Rewards}) ->
    case lib_goods_api:can_give_goods(PS, Rewards) of
        true -> true;
        {false, ErrorCode} -> {false, ErrorCode}
    end;

do_check_rush_giftbag(_Arg) ->
    {false, ?ERRCODE(err417_bad_check)}.


%% 版本的更新礼包
update_db(RoleId, VersionCode, Rewards) ->
    Sql = io_lib:format("replace version_upgradebag(player_id, version_code, time) values (~p, ~p, ~p) ", [RoleId, VersionCode, utime:unixtime()]),
    lib_log_api:log_version_upgradebag(RoleId, VersionCode, Rewards),
    db:execute(Sql),
    true.

check_code(CheckList) ->
    case do_check_code(CheckList) of
        true -> true;
        {false, Res} -> {false, Res}
    end.

do_check_code([]) -> true;
do_check_code([H | T]) ->
    case check(H) of
        true -> do_check_code(T);
        {false, Res} -> {false, Res}
    end.

check({check_has_received, RoleId, StartTime, EndTime}) ->
    Sql = io_lib:format("select time from version_upgradebag where player_id = ~p", [RoleId]),
    case db:get_row(Sql) of
        [LastGetTime] ->
            case LastGetTime >= StartTime andalso LastGetTime < EndTime of
                true ->
                    {false, ?ERRCODE(err417_upgradebag_has_received)};
                false ->
                    true
            end;
        _ -> true
    end;

check({check_time_out, StartTime, EndTime}) ->
    NowTime = utime:unixtime(),
    case NowTime >= StartTime andalso NowTime < EndTime of
        true -> true;
        false -> {false, ?ERRCODE(err417_upgradebag_out_of_time)}
    end;

check({check_state, VersionState}) ->
    case VersionState of
        ?VERSION_USING -> true;
        ?VERSION_NOT_USING -> {false, ?ERRCODE(err417_version_not_using)}
    end;

check(_Other) ->
    {false, ?ERRCODE(err417_bad_check_type)}.

get_night_welfare_reward(Lv) ->
    IdList = data_welfare:get_reward_ids(),
    do_get_night_welfare_reward(Lv, IdList).

do_get_night_welfare_reward(_, []) -> [];
do_get_night_welfare_reward(Lv, [H | T]) ->
    case data_welfare:get_reward(H) of
        #base_welfare_night_reward{lv_region = [{MinLv, MaxLv}], reward = Reward} ->
            case Lv >= MinLv andalso Lv =< MaxLv of
                true ->
                    Reward;
                _ ->
                    do_get_night_welfare_reward(Lv, T)
            end;
        _ ->
            do_get_night_welfare_reward(Lv, T)
    end.

send_night_reward_status(Option) ->
    OpenLv = case data_welfare:get_cfg(night_welfare_open_lv) of
                 0 -> 65535;
                 Lv -> Lv
             end,
    case Option of
        add -> Status = 1;
        _ -> Status = 0
    end,
    {ok, Bin} = pt_417:write(41713, [?SUCCESS, Status]),
    lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, Bin).

get_mail_info() ->
    Title = utext:get(4170003),
    Content = utext:get(4170004),
    {Title, Content}.