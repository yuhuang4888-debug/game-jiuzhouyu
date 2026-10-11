%% ---------------------------------------------------------------------------
%% @doc lib_invite.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-01
%% @deprecated 邀请
%% ---------------------------------------------------------------------------

-module(lib_invite).
-compile([export_all]).

-include("server.hrl").
-include("figure.hrl").
-include("invite.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").

%% 登录
login(#player_status{id = RoleId, figure = #figure{lv = Lv}} = Player) ->
    case db_role_invite_select(RoleId) of
        [] -> StatusInvite = #status_invite{};
        [GetStatus, Count, LastCountTime, TotalCount, RewardListBin, LvListBin, PosListBin] ->
            RewardList = util:bitstring_to_term(RewardListBin),
            LvList = util:bitstring_to_term(LvListBin),
            PosList = util:bitstring_to_term(PosListBin),
            StatusInvite = #status_invite{
                get_status = GetStatus
                , count = Count
                , last_count_time = LastCountTime
                , total_count = TotalCount
                , reward_list = RewardList
                , lv_list = LvList
                , pos_list = PosList
            }
    end,
    RefreshTime = mod_daily:get_refresh_time(RoleId, ?MOD_INVITE, ?DAILY_INVITE_REQUEST_COUNT),
    NowTime = utime:unixtime(),
    % 1:大于间隔;2:大于下载数据等级
    case NowTime - RefreshTime > ?INVITE_KV_REQUEST_GAP andalso Lv >= ?INVITE_KV_REQUEST_MIN_LV of
        true ->
            lib_invite_api:request_update_invite_state(Player),
            mod_daily:increment(RoleId, ?MOD_INVITE, ?DAILY_INVITE_REQUEST_COUNT);
        false ->
            skip
    end,
    Player#player_status{invite = StatusInvite}.

%% 登出
logout(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    RefreshTime = mod_daily:get_refresh_time(RoleId, ?MOD_INVITE, ?DAILY_INVITE_UPLOAD_COUNT),
    NowTime = utime:unixtime(),
    MaxLv = ?INVITE_KV_UPLOAD_MAX_LV,
    Gap = ?INVITE_KV_UPLOAD_GAP,
    if
        Lv > MaxLv -> skip;
        NowTime - RefreshTime < Gap -> skip;
        true ->
            mod_daily:increment(RoleId, ?MOD_INVITE, ?DAILY_INVITE_UPLOAD_COUNT),
            lib_invite_api:upload_inivtee_info(Player)
    end.

%% 重连
relogin(#player_status{id = RoleId, figure = #figure{lv = Lv}} = Player) ->
    RefreshTime = mod_daily:get_refresh_time(RoleId, ?MOD_INVITE, ?DAILY_INVITE_REQUEST_COUNT),
    NowTime = utime:unixtime(),
    % 1:大于间隔;2:大于下载数据等级
    case NowTime - RefreshTime > ?INVITE_KV_REQUEST_GAP andalso Lv >= ?INVITE_KV_REQUEST_MIN_LV of
        true ->
            lib_invite_api:request_update_invite_state(Player),
            mod_daily:increment(RoleId, ?MOD_INVITE, ?DAILY_INVITE_REQUEST_COUNT);
        false ->
            skip
    end,
    Player.

%% 延迟登出
delay_stop(Player) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = Player,
    RefreshTime = mod_daily:get_refresh_time(RoleId, ?MOD_INVITE, ?DAILY_INVITE_UPLOAD_COUNT),
    NowTime = utime:unixtime(),
    MaxLv = ?INVITE_KV_UPLOAD_MAX_LV,
    Gap = ?INVITE_KV_UPLOAD_GAP,
    if
        Lv > MaxLv -> skip;
        NowTime - RefreshTime < Gap -> skip;
        true ->
            mod_daily:increment(RoleId, ?MOD_INVITE, ?DAILY_INVITE_UPLOAD_COUNT),
            lib_invite_api:upload_inivtee_info(Player)
    end,
    Player.

%% 发送信息
send_info(Player) ->
    #player_status{id = RoleId, invite = StatusInvite} = Player,
    #status_invite{count = Count, last_count_time = LastCountTime, total_count = TotalCount} = StatusInvite,
    CalcGetStatus = calc_get_status(Player),
    LeftCount = max(?INVITE_KV_BOX_MAX_NUM - Count, 0),
    RecoverTime = LastCountTime+LeftCount*?INVITE_KV_BOX_ADD_TIME,
    DailyCount = mod_daily:get_count(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT),
    RewardType = ?INVITE_REWARD_TYPE_BOX,
    F = fun(RewardId) ->
        RewardStatus = calc_reward_status(Player, RewardType, RewardId),
        {RewardId, RewardStatus}
    end,
    List = lists:map(F, data_invite:get_reward_id_list(RewardType)),
    {ok, BinData} = pt_340:write(34001, [CalcGetStatus, RecoverTime, DailyCount, TotalCount, List]),
    % ?PRINT("[CalcGetStatus, RecoverTime, DailyCount, TotalCount, List]:~w ~n", 
    %     [[CalcGetStatus, RecoverTime, DailyCount, TotalCount, List]]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 计算是否可领取
calc_get_status(Player) ->
    #player_status{id = RoleId, invite = #status_invite{get_status = GetStatus}} = Player,
    DailyCount = mod_daily:get_count(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT),
    case DailyCount >= ?INVITE_KV_BOX_DAILY_NUM of
        true -> ?INVITE_REWARD_CAN_NOT_GET;
        false -> GetStatus
    end.

%% 计算奖励是否领取
calc_reward_status(Player, Type, RewardId) ->
    calc_reward_status(Player, Type, RewardId, []).

%% 计算奖励
calc_reward_status(Player, Type, RewardId, LvList) ->
    #player_status{invite = StatusInvite} = Player,
    #status_invite{total_count = TotalCount, reward_list = RewardList} = StatusInvite,
    case lists:member({Type, RewardId}, RewardList) of
        true -> ?INVITE_REWARD_HAD_GET;
        false ->
            BaseReward = data_invite:get_reward(Type, RewardId),
            if
                is_record(BaseReward, base_invite_reward) == false -> ?INVITE_REWARD_CAN_NOT_GET;
                Type == ?INVITE_REWARD_TYPE_BOX ->
                    #base_invite_reward{num = NeedNum} = BaseReward,
                    case TotalCount >= NeedNum of
                        true -> ?INVITE_REWARD_CAN_GET;
                        false -> ?INVITE_REWARD_CAN_NOT_GET
                    end;
                Type == ?INVITE_REWARD_TYPE_WELFARE -> ?INVITE_REWARD_CAN_GET;
                Type == ?INVITE_REWARD_TYPE_LV -> 
                    #base_invite_reward{num = NeedNum} = BaseReward,
                    SumCount = lists:sum([Count||{Lv, Count}<-LvList, Lv>=?INVITE_KV_LV_OF_REWARD_TYPE_LV]),
                    case SumCount >= NeedNum of
                        true -> ?INVITE_REWARD_CAN_GET;
                        false -> ?INVITE_REWARD_CAN_NOT_GET
                    end;
                true -> ?INVITE_REWARD_CAN_NOT_GET
            end
    end.

%% 触发邀请
touch_invite(#player_status{id = RoleId, invite = StatusInvite} = Player) -> 
    case check_touch_invite(Player) of
        {false, ErrCode} -> send_error_code(RoleId, 34002, ErrCode);
        {true, NewCount, NewLastCountTime} ->
            lib_activitycalen_api:role_success_end_activity(RoleId, ?MOD_INVITE,  0),
            % 处理冷却时间
            case NewLastCountTime == 0 of
                true -> NewLastCountTime2 = utime:unixtime();
                false -> NewLastCountTime2 = NewLastCountTime
            end,
            % 允许领取
            NewStatusInvite = StatusInvite#status_invite{
                get_status = ?INVITE_REWARD_CAN_GET, count = NewCount - 1, last_count_time = NewLastCountTime2
                },
            db_role_invite_replace(RoleId, NewStatusInvite),
            NewPlayer = Player#player_status{invite = NewStatusInvite},
            {ok, BinData} = pt_340:write(34002, []),
            lib_server_send:send_to_uid(RoleId, BinData),
            % ?PRINT("34002:~w ~n", [[NewCount, NewLastCountTime]]),
            {ok, NewPlayer}
    end.

check_touch_invite(Player) ->
    #player_status{id = RoleId, invite = StatusInvite} = Player,
    #status_invite{get_status = GetStatus, count = Count, last_count_time = LastCountTime} = StatusInvite,
    MaxDailyNum = ?INVITE_KV_BOX_DAILY_NUM,
    DailyCount = mod_daily:get_count(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT),
    {NewCount, NewLastCountTime} = util:calc_recover_count(Count, LastCountTime, ?INVITE_KV_BOX_MAX_NUM, ?INVITE_KV_BOX_ADD_TIME),
    if
        DailyCount >= MaxDailyNum -> {false, ?ERRCODE(err340_not_enough_daily_num_to_touch)};
        GetStatus == ?INVITE_REWARD_CAN_GET -> {false, ?ERRCODE(err340_must_to_get_box_reward)};
        NewCount == 0 -> {false, ?ERRCODE(err340_touch_invite_on_cd)};
        true -> {true, NewCount, NewLastCountTime}
    end.

%% 宝箱奖励领取
receive_box_reward(#player_status{id = RoleId, invite = StatusInvite} = Player) -> 
    case check_receive_box_reward(Player) of
        {false, ErrCode} -> send_error_code(RoleId, 34003, ErrCode);
        {true, Reward, NewDailyCount} ->
            #status_invite{total_count = TotalCount} = StatusInvite,
            % 增加总次数
            case NewDailyCount =< ?INVITE_KV_CALC_TOTAL_DAILY_NUM of
                true -> NewTotalCount = TotalCount+1;
                false -> NewTotalCount = TotalCount
            end,
            NewStatusInvite = StatusInvite#status_invite{get_status = ?INVITE_REWARD_HAD_GET, total_count = NewTotalCount},
            db_role_invite_replace(RoleId, NewStatusInvite),
            mod_daily:increment(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT),
            NewPlayer = Player#player_status{invite = NewStatusInvite},
            Remark = lists:concat(["DailyCount:", NewDailyCount, ",TotalCount:", NewTotalCount]),
            Produce = #produce{type = invite_box, subtype = NewDailyCount, reward = Reward, remark = Remark, show_tips = ?SHOW_TIPS_3},
            RewardPlayer = lib_goods_api:send_reward(NewPlayer, Produce),
            lib_log_api:log_invite_box_reward(RoleId, NewDailyCount, NewTotalCount, Reward),
            {ok, BinData} = pt_340:write(34003, [NewDailyCount]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, RewardPlayer}
    end.

check_receive_box_reward(#player_status{id = RoleId} = Player) ->
    DailyCount = mod_daily:get_count(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT),
    case calc_get_status(Player) of
        ?INVITE_REWARD_CAN_NOT_GET -> {false, ?ERRCODE(err340_can_not_get)};
        ?INVITE_REWARD_HAD_GET -> {false, ?ERRCODE(err340_had_get)};
        ?INVITE_REWARD_CAN_GET -> 
            NewDailyCount = DailyCount+1,
            case data_invite:get_box_reward(NewDailyCount) of
                [] -> {false, ?MISSING_CONFIG};
                Reward -> {true, Reward, NewDailyCount}
            end
    end.

%% 领取奖励
receive_reward(Player, Type = ?INVITE_REWARD_TYPE_LV, RewardId) ->
    mod_invite:receive_reward(Player#player_status.id, Type, RewardId);
receive_reward(Player, Type, RewardId) ->
    receive_reward(Player, Type, RewardId, []).
    
receive_reward(#player_status{id = RoleId, invite = StatusInvite} = Player, Type, RewardId, LvList) ->
    case check_receive_reward(Player, Type, RewardId, LvList) of
        {false, ErrCode} -> send_error_code(RoleId, 34004, ErrCode);
        {true, Reward} ->
            #status_invite{reward_list = RewardList} = StatusInvite,
            NewStatusInvite = StatusInvite#status_invite{reward_list = [{Type, RewardId}|RewardList]},
            db_role_invite_replace(RoleId, NewStatusInvite),
            NewPlayer = Player#player_status{invite = NewStatusInvite},
            Remark = lists:concat(["Type:", Type, ",RewardId:", RewardId]),
            Produce = #produce{type = invite_reward, subtype = Type, reward = Reward, remark = Remark, show_tips = ?SHOW_TIPS_3},
            RewardPlayer = lib_goods_api:send_reward(NewPlayer, Produce),
            lib_log_api:log_invite_reward(RoleId, Type, RewardId, Reward),
            {ok, BinData} = pt_340:write(34004, [Type, RewardId]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, RewardPlayer}
    end.

check_receive_reward(Player, Type, RewardId, LvList) ->
    case calc_reward_status(Player, Type, RewardId, LvList) of
        ?INVITE_REWARD_CAN_NOT_GET -> {false, ?ERRCODE(err340_can_not_get)};
        ?INVITE_REWARD_HAD_GET -> {false, ?ERRCODE(err340_had_get)};
        ?INVITE_REWARD_CAN_GET -> 
            case data_invite:get_reward(Type, RewardId) of
                [] -> {false, ?MISSING_CONFIG};
                #base_invite_reward{reward = Reward} -> {true, Reward}
            end
    end.

%% 帮助信息界面
send_help_info(Player, LvList, RoleList) ->
    SumCount = lists:sum([Count||{Lv, Count}<-LvList, Lv>=?INVITE_KV_LV_OF_REWARD_TYPE_LV]),
    RewardType = ?INVITE_REWARD_TYPE_LV,
    F = fun(RewardId) ->
        RewardStatus = calc_reward_status(Player, RewardType, RewardId, LvList),
        {RewardId, RewardStatus}
    end,
    List = lists:map(F, data_invite:get_reward_id_list(RewardType)),
    F2 = fun(Role) ->
        #invitee_role{invitee_id = InviteeId, pos = Pos, name = Name, lv = Lv, career = Career} = Role,
        Status = calc_lv_reward_pos_status(Player, ?INVITE_KV_LV_REWARD_HELP_LV, Pos, RoleList),
        {InviteeId, Pos, Name, Lv, Career, Status}
    end,
    PosList = lists:map(F2, RoleList),
    {ok, BinData} = pt_340:write(34005, [SumCount, List, PosList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 等级奖励位置领取
calc_lv_reward_pos_status(Player, Lv, Pos, RoleList) ->
    #player_status{invite = StatusInvite} = Player,
    #status_invite{pos_list = PosList} = StatusInvite,
    case lists:member({Lv, Pos}, PosList) of
        true -> ?INVITE_REWARD_HAD_GET;
        false ->
            BaseReward = data_invite:get_lv_reward(Lv, Pos),
            Role = lists:keyfind(Pos, #invitee_role.pos, RoleList),
            case lists:keyfind(Lv, 1, ?INVITE_KV_LV_REWARD_LV_LIST) of
                {Lv, 0} -> IsCanGet = true;
                _ -> IsCanGet = false
            end,
            if
                BaseReward == [] -> ?INVITE_REWARD_CAN_NOT_GET;
                is_record(Role, invitee_role) == false -> ?INVITE_REWARD_CAN_NOT_GET;
                IsCanGet == false -> ?INVITE_REWARD_CAN_NOT_GET;
                true -> 
                    #invitee_role{lv = RoleLv} = Role,
                    case RoleLv >= Lv of
                        true -> ?INVITE_REWARD_CAN_GET;
                        false -> ?INVITE_REWARD_CAN_NOT_GET
                    end
            end
    end.

%% 升级信息界面
send_lv_info(Player, RoleList) ->
    F = fun(Role) ->
        #invitee_role{invitee_id = InviteeId, pos = Pos, name = Name, lv = Lv, career = Career} = Role,
        Status = calc_lv_reward_pos_status(Player, ?INVITE_KV_LV_REWARD_LV_UP_LV, Pos, RoleList),
        {InviteeId, Pos, Name, Lv, Career, Status}
    end,
    PosList = lists:map(F, RoleList),
    {ok, BinData} = pt_340:write(34006, [PosList]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 等级奖励位置领取
receive_lv_reward_pos(#player_status{id = RoleId, invite = StatusInvite} = Player, Lv, Pos, RoleList) ->
    case check_receive_lv_reward_pos(Player, Lv, Pos, RoleList) of
        {false, ErrCode} -> send_error_code(RoleId, 34007, ErrCode);
        {true, Reward} ->
            #status_invite{pos_list = PosList} = StatusInvite,
            NewStatusInvite = StatusInvite#status_invite{pos_list = [{Lv, Pos}|PosList]},
            db_role_invite_replace(RoleId, NewStatusInvite),
            NewPlayer = Player#player_status{invite = NewStatusInvite},
            Remark = lists:concat(["Lv:", Lv, ",Pos:", Pos]),
            Produce = #produce{type = invite_lv_reward_pos, subtype = Lv, reward = Reward, remark = Remark, show_tips = ?SHOW_TIPS_3},
            RewardPlayer = lib_goods_api:send_reward(NewPlayer, Produce),
            {ok, BinData} = pt_340:write(34007, [Lv, Pos]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, RewardPlayer}
    end.

check_receive_lv_reward_pos(Player, Lv, Pos, RoleList) ->
    case calc_lv_reward_pos_status(Player, Lv, Pos, RoleList) of
        ?INVITE_REWARD_CAN_NOT_GET -> {false, ?ERRCODE(err340_can_not_get)};
        ?INVITE_REWARD_HAD_GET -> {false, ?ERRCODE(err340_had_get)};
        ?INVITE_REWARD_CAN_GET -> 
            case data_invite:get_lv_reward(Lv, Pos) of
                [] -> {false, ?MISSING_CONFIG};
                Reward -> {true, Reward}
            end
    end.

%% 等级奖励一次性领取信息
send_lv_reward_once_info(Player, Lv, TotalCount) ->
    #player_status{invite = StatusInvite} = Player,
    #status_invite{lv_list = LvList} = StatusInvite,
    case lists:keyfind(Lv, 1, LvList) of
        false -> Count = 0;
        {Lv, Count} -> ok
    end,
    {_NewCount, Reward} = calc_lv_reward_once(Lv, Count, TotalCount),
    % ?MYLOG("hjhinvite", "Id:~p send_lv_reward_once_info Lv:~p TotalCount:~p ~n", [Player#player_status.id, Lv, TotalCount]),
    {ok, BinData} = pt_340:write(34008, [Lv, TotalCount, Reward]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.
 
calc_lv_reward_once(Lv, Count, TotalCount) ->
    LvList = data_invite:get_lv_reward(Lv),
    calc_lv_reward_once(LvList, Lv, Count, TotalCount, []).

calc_lv_reward_once([], _Lv, Count, _TotalCount, SumReward) -> {Count, lib_goods_api:make_reward_unique(SumReward)};
calc_lv_reward_once(_MaxList, _Lv, Count, TotalCount, SumReward) when Count >= TotalCount -> {Count, lib_goods_api:make_reward_unique(SumReward)};
calc_lv_reward_once([Max|T], Lv, Count, TotalCount, SumReward) ->
    case Count < Max of
        true -> 
            Reward = data_invite:get_lv_reward(Lv, Max),
            AddCount = min(Max, TotalCount) - Count,
            F = fun
                ({Type, GoodsTypeId, Num}) -> {Type, GoodsTypeId, Num*AddCount};
                (Tmp) -> Tmp
            end,
            NewReward = lists:map(F, Reward),
            NewCount = Count+AddCount, % 计算下一阶段的
            NewSumReward = NewReward++SumReward,
            calc_lv_reward_once(T, Lv, NewCount, TotalCount, NewSumReward);
        false ->
            {Count, lib_goods_api:make_reward_unique(SumReward)}
    end.

%% 等级奖励一次性领取
receive_lv_reward_once(#player_status{id = RoleId, invite = StatusInvite} = Player, Lv, TotalCount) ->
    case check_receive_lv_reward_once(Player, Lv, TotalCount) of
        {false, ErrCode} -> send_error_code(RoleId, 34009, ErrCode);
        {true, NewCount, Reward} ->
            #status_invite{lv_list = LvList} = StatusInvite,
            NewLvList = lists:keystore(Lv, 1, LvList, {Lv, NewCount}),
            NewStatusInvite = StatusInvite#status_invite{lv_list = NewLvList},
            db_role_invite_replace(RoleId, NewStatusInvite),
            NewPlayer = Player#player_status{invite = NewStatusInvite},
            Remark = lists:concat(["Lv:", Lv, ",NewCount:", NewCount]),
            Produce = #produce{type = invite_lv_reward_once, subtype = Lv, reward = Reward, remark = Remark, show_tips = ?SHOW_TIPS_3},
            RewardPlayer = lib_goods_api:send_reward(NewPlayer, Produce),
            {ok, BinData} = pt_340:write(34009, [Lv, Reward]),
            lib_server_send:send_to_uid(RoleId, BinData),
            {ok, RewardPlayer}
    end.

%% 等级奖励一次性领取
check_receive_lv_reward_once(Player, Lv, TotalCount) ->
    #player_status{invite = StatusInvite} = Player,
    #status_invite{lv_list = LvList} = StatusInvite,
    case lists:keyfind(Lv, 1, LvList) of
        false -> Count = 0;
        {Lv, Count} -> ok
    end,
    {NewCount, Reward} = calc_lv_reward_once(Lv, Count, TotalCount),
    case lists:keyfind(Lv, 1, ?INVITE_KV_LV_REWARD_LV_LIST) of
        {Lv, 1} -> IsCanGet = true;
        _ -> IsCanGet = false
    end,
    if
        Reward == [] -> {false, ?ERRCODE(err340_had_get)};
        IsCanGet == false -> {false, ?ERRCODE(err340_can_not_get)};
        true -> {true, NewCount, Reward}
    end.

%% 邀请奖励信息
send_reward_info(_Player, ?INVITE_REWARD_TYPE_LV) -> skip;
send_reward_info(#player_status{id = RoleId} = Player, Type) ->
    F = fun(RewardId) ->
        RewardStatus = calc_reward_status(Player, Type, RewardId),
        {RewardId, RewardStatus}
    end,
    List = lists:map(F, data_invite:get_reward_id_list(Type)),
    {ok, BinData} = pt_340:write(34012, [Type, List]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 错误码
send_error_code(RoleId, Pt, ErrCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrCode),
    {ok, BinData} = pt_340:write(34000, [Pt, ErrorCodeInt, ErrorCodeArgs]),
    lib_server_send:send_to_uid(RoleId, BinData),
    ok.

%% 清理日常和冷却时间
gm_clear_daily_and_cd(#player_status{id = RoleId, invite = StatusInvite} = Player) ->
    mod_daily:set_count(RoleId, ?MOD_INVITE, ?DAILY_INVITE_BOX_COUNT, 0),
    NewStatusInvite = StatusInvite#status_invite{get_status = ?INVITE_REWARD_CAN_NOT_GET, count = 0, last_count_time = 0},
    db_role_invite_replace(RoleId, NewStatusInvite),
    NewPlayer = Player#player_status{invite = NewStatusInvite},
    {ok, NewPlayer}.

%% 清理所有的记录
gm_clinvite(#player_status{id = RoleId} = Player) ->
    db_role_invite_replace(RoleId, #status_invite{}),
    NewPlayer = Player#player_status{invite = #status_invite{}},
    {ok, NewPlayer}.

%% -----------------------------------------------------------------
%% 数据库
%% -----------------------------------------------------------------

%% 获得邀请信息
db_role_invite_select(RoleId) ->
    Sql = io_lib:format(?sql_role_invite_select, [RoleId]),
    db:get_row(Sql).

%% 保存邀请信息
db_role_invite_replace(RoleId, StatusInvite) ->
    #status_invite{
        get_status = GetStatus
        , count = Count
        , last_count_time = LastCountTime
        , total_count = TotalCount
        , reward_list = RewardList
        , lv_list = LvList
        , pos_list = PosList
    } = StatusInvite,
    RewardListBin = util:term_to_bitstring(RewardList),
    LvListBin = util:term_to_bitstring(LvList),
    PosListBin = util:term_to_bitstring(PosList),
    Sql = io_lib:format(?sql_role_invite_replace, [RoleId, GetStatus, Count, LastCountTime, TotalCount, RewardListBin, LvListBin, PosListBin]),
    db:execute(Sql).