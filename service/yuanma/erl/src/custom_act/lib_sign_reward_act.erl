%%-----------------------------------------------------------------------------
%% @Module  :       lib_sign_reward_act
%% @Author  :       xlh
%% @Email   :       1593315047@qq.com
%% @Created :       2020\06\23
%% @Description:    登陆有礼接口
%%-----------------------------------------------------------------------------
-module (lib_sign_reward_act).

-include ("common.hrl").
-include ("custom_act.hrl").
-include ("server.hrl").
-include ("def_fun.hrl").
-include ("language.hrl").
-include ("predefine.hrl").
-include ("figure.hrl").

-export([
    get_login_times/3
    ,send_unrecieve_signact_recharge/5
    ,midnight_refresh/3
    ,refresh_player_login_times/2
    ,login_for_sign_reward/1
    ,login_for_sign_reward/2
    ,update_role_recieve_times/5
    ,calc_need_send_reward/5
    ,sign_act_handle_recharge/3
]).

%% 从ps获取数据
get_login_times(Player, Type, SubType) ->
    #player_status{status_custom_act = #status_custom_act{data_map = DataMap}} = Player,
    case maps:get({Type, SubType}, DataMap, []) of
        #custom_act_data{data = Data} -> 
            {_, LoginTimes, _, RechargeList} = ulists:keyfind(sign, 1, Data, {sign, 0, 0, []});
        _ ->
            LoginTimes = 0, RechargeList = []
    end,
    {LoginTimes, RechargeList}.

%% 发送未领取奖励给玩家
send_unrecieve_signact_recharge(CalcType, Type, SubType, Wlv, StartTime) ->
    spawn(fun() ->
        SQL = io_lib:format(<<"select `player_id`, `data_list` from `custom_act_data` where `type`=~p and subtype = ~p">>, [Type, SubType]),
        List = db:get_all(SQL),
        Fun = fun([RoleId, DataStr], Acc) ->
            Data = util:bitstring_to_term(DataStr),
            case lists:keyfind(sign, 1, Data) of
                {_, LoginTimes, _, RechargeList} -> skip;
                {_, LoginTimes, _} -> RechargeList = [];
                _ -> LoginTimes = 0, RechargeList = []
            end,
            {TotalReward, GradeIdList} = calc_total_send_reward(CalcType, RoleId, Type, SubType, StartTime, Wlv, LoginTimes, RechargeList),
            if
                TotalReward =/= [] ->
                    lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, TotalReward),
                    Rewards = ulists:object_list_plus(TotalReward),
                    Title = ?LAN_MSG(?SIGN_REWARD_MAIL_TITLE),
                    Content = utext:get(?SIGN_REWARD_MAIL_CONTENT),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards);
                true ->
                    skip
            end,
            timer:sleep(1000),
            [{RoleId, GradeIdList}|Acc]
        end,
        RoleGradeList = lists:foldl(Fun, [], List),
        do_after_send_reward(CalcType, RoleGradeList, Type, SubType)
    end).

%% 刷新在线玩家活动数据
refresh_player_login_times(Type, SubType) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [refresh_player_login_times(E#ets_online.id, Type, SubType) || E <- OnlineRoles].

%% 登陆加载数据/数据修复
login_for_sign_reward(Player) ->
    login_for_sign_reward(Player, ?NORMAL_LOGIN).

%% 登陆加载数据/数据修复
login_for_sign_reward(Player, LoginType) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}, online = _Online, source = Source, status_custom_act = StatusCustomAct} = Player,
    case is_record(StatusCustomAct, status_custom_act) of
        true -> #status_custom_act{data_map = DataMap} = StatusCustomAct;
        _ -> DataMap = #{}, StatusCustomAct = #status_custom_act{}
    end,
    OpenLv = lib_custom_act:get_open_lv(?CUSTOM_ACT_TYPE_SIGN_REWARD),
    if
        LoginType =/= ?ONHOOK_AGENT_LOGIN andalso _Online == ?ONLINE_ON andalso RoleLv >= OpenLv ->
            NowTime = utime:unixtime(),
            Type = ?CUSTOM_ACT_TYPE_SIGN_REWARD,
            SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
            Fun = fun(SubType, {Acc, TemPlayer}) ->
                #custom_act_cfg{clear_type = ClearType, condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
                {_, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, []}),
                AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
                IsMember = SourceList == [] orelse lists:member(AtomSource, SourceList),
                if
                    IsMember == true ->
                        case maps:get({Type, SubType}, DataMap, []) of
                            #custom_act_data{data = Data} = CustomActData1 -> 
                                case lists:keyfind(sign, 1, Data) of
                                    {_, LoginTimes, Utime, RechargeList} -> 
                                        CustomActData = CustomActData1, TemPlayer1 = TemPlayer;
                                    {_, LoginTimes, Utime} -> 
                                        Data1 = lists:keystore(sign, 1, Data, {sign, LoginTimes, Utime, []}),
                                        CustomActData = CustomActData1#custom_act_data{data = Data1},
                                        lib_custom_act:db_save_custom_act_data(RoleId, CustomActData),
                                        TemPlayer1 = lib_custom_act:save_act_data_to_player(TemPlayer, CustomActData),
                                        RechargeList = []; %% 修复旧数据
                                    _ -> 
                                        CustomActData = CustomActData1, TemPlayer1 = TemPlayer, 
                                        LoginTimes = 0, Utime = 0, RechargeList = []
                                end;
                            _ ->
                                Data = [{sign, LoginTimes = 0, Utime = 0, RechargeList = []}],
                                TemPlayer1 = TemPlayer,
                                CustomActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = Data}
                        end,
                        IsSameDay1 = calc_need_clear(ClearType, Utime, NowTime),
                        NewPlayer = if
                            IsSameDay1 == false ->
                                NewData = lists:keystore(sign, 1, Data, {sign, LoginTimes+1, NowTime, RechargeList}),
                                NewCustomActData = CustomActData#custom_act_data{data = NewData},
                                lib_custom_act:db_save_custom_act_data(RoleId, NewCustomActData),
                                lib_custom_act:save_act_data_to_player(TemPlayer1, NewCustomActData);
                            true ->
                                TemPlayer1
                        end,
                        {[{Type, SubType} | Acc], NewPlayer};
                    true ->
                        {Acc, TemPlayer}
                end
            end,
            lists:foldl(Fun, {[], Player}, SubTypes);
        true ->
            {[], Player}
    end.

%% 充值触发
sign_act_handle_recharge(Player, _Product, Gold) ->
    Type = ?CUSTOM_ACT_TYPE_SIGN_REWARD,
    #player_status{id = RoleId, source = Source, status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    SubTypes = lib_custom_act_api:get_open_subtype_ids(Type),
    Fun = fun(SubType, TemPlayer) ->
        #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
        #act_info{stime = StartTime} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
        {_, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, []}),
        AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
        IsMember = SourceList == [] orelse lists:member(AtomSource, SourceList),
        if
            IsMember == true ->
                case maps:get({Type, SubType}, DataMap, []) of
                    #custom_act_data{data = Data} = CustomActData -> 
                        {_, LoginTimes, Utime, RechargeList} = ulists:keyfind(sign, 1, Data, {sign, 0, 0, []});
                    _ ->
                        Data = [{sign, LoginTimes = 1, Utime = utime:unixtime(), RechargeList = []}],
                        CustomActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = Data}
                end,
                DiffDay = utime:diff_days(StartTime)+1,
                {_, OldNum} = ulists:keyfind(DiffDay, 1, RechargeList, {DiffDay, 0}),
                NewRechargeList = lists:keystore(DiffDay, 1, RechargeList, {DiffDay, Gold+OldNum}),
                NewData = lists:keystore(sign, 1, Data, {sign, LoginTimes, Utime, NewRechargeList}),
                NewCustomActData = CustomActData#custom_act_data{data = NewData},
                lib_custom_act:db_save_custom_act_data(RoleId, NewCustomActData),
                NewPlayer = lib_custom_act:save_act_data_to_player(TemPlayer, NewCustomActData),
                lib_custom_act:reward_status(NewPlayer, Type, SubType),
                NewPlayer;
            true ->
                TemPlayer
        end
    end,
    lists:foldl(Fun, Player, SubTypes).

%% ============ 内部接口 =================================
refresh_player_login_times(RoleId, Type, SubType) ->
    spawn(fun() ->
        Time = urand:rand(100,900),
        timer:sleep(Time), %% 延时15s左右确保活动已开启！
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_sign_reward_act, midnight_refresh, [Type, SubType]) end).

midnight_refresh(Player, Type, SubType) ->
    NowTime = utime:unixtime(),
    #player_status{figure = #figure{lv = RoleLv}} = Player,
    OpenLv = lib_custom_act:get_open_lv(Type),
    if
        OpenLv =< RoleLv ->
            NewPS = do_midnight_refresh(Player, Type, SubType, NowTime);
        true ->
            NewPS = Player
    end,
    {ok, NewPS}.

do_midnight_refresh(Player, Type, SubType, NowTime) ->
    #player_status{id = RoleId, source = Source, status_custom_act = StatusCustomAct} = Player,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    #custom_act_cfg{condition = ActConditions} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    {_, SourceList} = ulists:keyfind(source_list, 1, ActConditions, {source_list, []}),
    AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
    #act_info{stime = StartTime} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    IsMember = SourceList == [] orelse lists:member(AtomSource, SourceList),
    if
        IsMember == true ->
            case maps:get({Type, SubType}, DataMap, []) of
                #custom_act_data{data = Data} = CustomActData -> 
                    {_, LoginTimes, Utime, RechargeList} = ulists:keyfind(sign, 1, Data, {sign, 0, 0, []});
                _ ->
                    Data = [{sign, LoginTimes = 0, Utime = 0, RechargeList = []}],
                    CustomActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = Data}
            end,
            IsSameDay = utime:is_same_day(Utime, NowTime),
            NewPlayer = if
                IsSameDay == false ->
                    DiffDay = utime:diff_days(StartTime)+1,
                    NewRechargeList = lists:keystore(DiffDay, 1, RechargeList, {DiffDay, 0}),
                    NewData = lists:keystore(sign, 1, Data, {sign, LoginTimes+1, NowTime, NewRechargeList}),
                    NewCustomActData = CustomActData#custom_act_data{data = NewData},
                    lib_custom_act:db_save_custom_act_data(RoleId, NewCustomActData),
                    lib_custom_act:save_act_data_to_player(Player, NewCustomActData);
                true ->
                    Player
            end,
            lib_custom_act:reward_status(NewPlayer, Type, SubType),
            NewPlayer;
        true ->
            Player
    end.


do_after_send_reward(midnight, RoleGradeList, Type, SubType) ->
    NowTime = utime:unixtime(),
    Fun = fun({RoleId, GradeIdList}, Acc) ->
        case misc:get_player_process(RoleId) of
            Pid when is_pid(Pid) ->  
                lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, 
                    lib_sign_reward_act, update_role_recieve_times, [Type, SubType, GradeIdList, NowTime]
                );
            _ -> 
                skip
        end,
        [[RoleId, Type, SubType, GradeId, 1, NowTime] || GradeId <- GradeIdList] ++ Acc
    end,
    DbList = lists:foldl(Fun, [], RoleGradeList),
    DbList =/= [] andalso db:execute(
        usql:replace(custom_act_receive_reward, [role_id, type, subtype, grade, receive_times, utime], DbList)
    );
do_after_send_reward(_, _, Type, SubType) -> %% 活动结束清理所有数据
    db:execute(io_lib:format(?SQL_DELETE_CUSTOM_ACT_DATA_1, [Type, SubType])).


update_role_recieve_times(Player, Type, SubType, GradeIdList, NowTime) ->
    StatusCustomAct = Player#player_status.status_custom_act,
    RewardMap = StatusCustomAct#status_custom_act.reward_map,
    if
        Type == ?CUSTOM_ACT_TYPE_SIGN_REWARD ->
            {LoginTimes, _} = get_login_times(Player, Type, SubType);
        true ->
            LoginTimes = 0
    end,
    
    Fun = fun(GradeId, AccMap) ->
        case maps:get({Type, SubType, GradeId}, AccMap, []) of
            RwStatus when is_record(RwStatus, reward_status) ->
                NewRwStatus = RwStatus#reward_status{receive_times = 1, utime = NowTime, login_times = LoginTimes};
            _ ->
                NewRwStatus = #reward_status{receive_times = 1, utime = NowTime, login_times = LoginTimes}
        end,
        AccMap#{{Type, SubType, GradeId} => NewRwStatus}
    end,
    NewRewardMap = lists:foldl(Fun, RewardMap, GradeIdList),
    {ok, Player#player_status{status_custom_act = StatusCustomAct#status_custom_act{reward_map = NewRewardMap}}}.

calc_total_send_reward(CalcType, RoleId, Type, SubType, StartTime, Wlv, LoginTimes, RechargeList) ->
    GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
    Fun1 = fun(GradeId, {Acc, Acc2}) ->
        CountList = db:get_row(io_lib:format(?select_custom_act_reward_receive_times, [RoleId, Type, SubType, GradeId])),
        timer:sleep(1000),
        case CountList of
            [Num] when is_integer(Num) andalso Num >= 1 ->
                {Acc, Acc2};
            _ ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                    #custom_act_reward_cfg{condition = Conditions} = RewardCfg ->
                        NeedSend = calc_need_send_reward(CalcType, Conditions, StartTime, LoginTimes, RechargeList),
                        if
                            NeedSend == true ->
                                [_, Sex, Lv, Career, _, _, _, _, _, _, _|_]
                                    = lib_player:get_player_low_data(RoleId),
                                RewardParam = lib_custom_act:make_rwparam(Lv, Sex, Wlv, Career),
                                Reward = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
                                {[Reward | Acc], [GradeId|Acc2]};
                            true ->
                                {Acc, Acc2}
                        end;
                    _ -> {Acc, Acc2}
                end
        end
    end,
    lists:foldl(Fun1, {[], []}, GradeIdList).


calc_need_send_reward(CalcType, Conditions, StartTime, LoginTimes, RechargeList) ->
    {_, SignCount} = ulists:keyfind(sign_count, 1, Conditions, {sign_count, 0}),
    {_, RechargeCount} = ulists:keyfind(recharge, 1, Conditions, {recharge, 0}),
    {_, LastDay} = ulists:keyfind(last_day, 1, Conditions, {last_day, 0}),
    {_, RechargeNum} = ulists:keyfind(LastDay, 1, RechargeList, {LastDay, 0}),
    calc_need_send_reward_helper(CalcType, StartTime, LastDay, RechargeCount, SignCount, RechargeNum, LoginTimes).

calc_need_send_reward_helper(midnight, StartTime, LastDay, RechargeCount, SignCount, RechargeNum, LoginTimes) ->
    IsSameDay = ?IF(LastDay =/= 0, utime:is_same_day(StartTime + LastDay*86400, utime:unixtime()), false),
    if
        RechargeCount =/= 0 andalso RechargeCount =< RechargeNum andalso IsSameDay == true ->
            NeedSend = true;
        RechargeCount =/= 0 andalso LastDay == 0 andalso 
        SignCount =< LoginTimes andalso RechargeCount =< RechargeNum ->
            NeedSend = true;
        true ->
            NeedSend = false
    end,
    NeedSend;
calc_need_send_reward_helper(_, StartTime, LastDay, RechargeCount, SignCount, RechargeNum, LoginTimes) ->
    IsSameDay = ?IF(LastDay =/= 0, utime:is_same_day(StartTime + (LastDay-1)*86400, utime:unixtime()), false),
    if
        RechargeCount == 0 andalso LastDay == 0 andalso SignCount =< LoginTimes ->
            NeedSend = true;
        RechargeCount =/= 0 andalso RechargeCount =< RechargeNum andalso IsSameDay == true ->
            NeedSend = true;
        RechargeCount =/= 0 andalso LastDay == 0 andalso 
        SignCount =< LoginTimes andalso RechargeCount =< RechargeNum ->
            NeedSend = true;
        true ->
            NeedSend = false
    end,  
    NeedSend.

calc_need_clear(ClearType, Utime, NowTime) ->
    case ClearType of
        ?CUSTOM_ACT_CLEAR_FOUR -> 
            utime_logic:is_logic_same_day(Utime, NowTime);
        _ ->
            utime:is_same_day(Utime, NowTime)
    end.