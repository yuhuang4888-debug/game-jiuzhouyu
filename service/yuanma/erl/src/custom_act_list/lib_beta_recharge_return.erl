%% ---------------------------------------------------------------------------
%% @doc lib_beta_recharge_return.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-28
%% @deprecated 封测充值返还
%% ---------------------------------------------------------------------------
-module(lib_beta_recharge_return).
-compile(export_all).

-include("server.hrl").
-include("beta_recharge_return.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("daily.hrl").

%% 充值
handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = CallBackData}) ->
    case CallBackData of
        #callback_recharge_data{gold = Gold, recharge_product = Product} ->
            RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
            IsTrigger = RealGold > 0 andalso is_can_record(Player),
            case IsTrigger of
                true ->
                    #player_status{id = RoleId, accid = Accid, accname = Accname, beta_recharge_return = StatusReturn, server_id = ServerId} = Player,
                    TotalGold = lib_recharge_data:get_total(RoleId),
                    #status_beta_recharge_return{gold = OldGold} = StatusReturn,
                    NewStatusReturn = StatusReturn#status_beta_recharge_return{gold = OldGold + Gold},
                    NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
                    db_role_beta_recharge_return_replace(Accid, Accname, NewStatusReturn),
                    mod_clusters_node:apply_cast(?MODULE, request_center_record, [ServerId, RoleId, Accid, Accname, TotalGold, Gold]),
                    send_info(NewPlayer),
                    {ok, NewPlayer};
                false ->
                    {ok, Player}
            end;
        _ ->
            {ok, Player}
    end;

handle_event(Player, _Ec) ->
    ?ERR("unkown event_callback:~p", [_Ec]),
    {ok, Player}.

%% 登录初始化
login(Player) ->
    #player_status{id = RoleId, accid = Accid, accname = Accname, server_id = ServerId} = Player,
    case db_role_beta_recharge_return_select(Accid, Accname) of
        [SyncRoleId, Gold, DaysUtime, LoginDays] ->
            StatusReturn = #status_beta_recharge_return{role_id = SyncRoleId, gold = Gold, days_utime = DaysUtime, login_days = LoginDays};
        _ ->
            StatusReturn = #status_beta_recharge_return{}
    end,
    NewPlayer = Player#player_status{beta_recharge_return = StatusReturn},
    case is_can_ask_reward_data(NewPlayer) of
        true ->
            % ?MYLOG("hjhbeta", "is_can_ask_reward_data:~p ~n", [is_can_ask_reward_data(NewPlayer)]),
            mod_clusters_node:apply_cast(?MODULE, request_center_get, [Accid, Accname, RoleId, ServerId]);
        false ->
            TotalGold = lib_recharge_data:get_total(RoleId),
            case is_can_record(NewPlayer) of
                true -> mod_clusters_node:apply_cast(?MODULE, request_center_record, [ServerId, RoleId, Accid, Accname, TotalGold, 0]);
                false -> skip
            end
    end,
    PlayerAfDays = update_login_days(NewPlayer),
    PlayerAfDays.

%% 登出
logout(Player) ->
    Player.
% #player_status{id = RoleId, accid = Accid, accname = Accname, beta_recharge_return = StatusReturn} = Player,
% case is_can_record(Player) of
%     true ->
%         TotalGold = lib_recharge_data:get_total(RoleId),
%         NewStatusReturn = StatusReturn#status_beta_recharge_return{gold = TotalGold},
%         NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
%         db_role_beta_recharge_return_replace(RoleId, NewStatusReturn),
%         mod_clusters_node:apply_cast(?MODULE, request_center_record, [Accid, Accname, TotalGold]),
%         NewPlayer;
%     false ->
%         Player
% end.

%% 重连
relogin(#player_status{id = RoleId, accid = Accid, accname = Accname, server_id = ServerId} = Player) ->
    case is_can_record(Player) of
        true ->
            TotalGold = lib_recharge_data:get_total(RoleId),
            mod_clusters_node:apply_cast(?MODULE, request_center_record, [ServerId, RoleId, Accid, Accname, TotalGold, 0]);
        false ->
            skip
    end,
    PlayerAfDays = update_login_days(Player),
    PlayerAfDays.

%% 更新天数
update_login_days(Player) ->
    case get_return_info(Player) of
        false -> Player;
        {true, ReturnList} ->
            MaxLoginDays = lists:max([Day||{Day, _Ratio}<-ReturnList]),
            #player_status{id = RoleId, accid = Accid, accname = Accname, beta_recharge_return = StatusReturn} = Player,
            #status_beta_recharge_return{gold = Gold, login_days = LoginDays, days_utime = DaysUtime} = StatusReturn,
            IsToday = utime:is_today(DaysUtime),
            % ?PRINT("111111 IsToday:~p ~n", [IsToday]),
            if
                IsToday -> Player;
                LoginDays >= MaxLoginDays -> Player;
                true ->
                    NowDate = utime:unixdate(),
                    NewLoginDays = LoginDays + 1,
                    NewStatusReturn = StatusReturn#status_beta_recharge_return{login_days = NewLoginDays, days_utime = NowDate},
                    db_role_beta_recharge_return_replace(Accid, Accname, NewStatusReturn),
                    case lists:keyfind(NewLoginDays, 1, ReturnList) of
                        {_, Ratio} when is_number(Ratio) ->
                            ReturnGold = umath:ceil(Gold * Ratio),
                            Reward = [{?TYPE_GOLD, 0, ReturnGold}, {?TYPE_BGOLD, 0, ReturnGold}],
                            lib_mail_api:send_sys_mail([RoleId], utext:get(3320003), utext:get(3320004, [MaxLoginDays, NewLoginDays]), Reward);
                        _ ->
                            skip
                    end,
                    NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
                    case NewLoginDays == 1 of
                        true -> PlayerAfVip = lib_vip:add_vip_exp(NewPlayer, Gold);
                        false -> PlayerAfVip = NewPlayer
                    end,
                    PlayerAfVip
            end
    end.

%% 获取返还的信息
get_return_info(Player) ->
    #player_status{id = RoleId, source = Source, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{role_id = SyncRoleId, gold = Gold} = StatusReturn,
    % 1.有钻石
    % 2.必须是同步的角色
    % 3.记录活动关闭,发奖的开启
    case Gold == 0 orelse RoleId =/= SyncRoleId of
        true -> false;
        false ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BETA_RECORD) of
                true -> false;
                false ->
                    case lib_custom_act_util:keyfind_act_condition2(?CUSTOM_ACT_TYPE_BETA_REWARD, [source_list, recharge_return]) of
                        [SourceList, ReturnList] when ReturnList =/= [] ->
                            case lists:member(make_source(Source), SourceList) of
                                true -> {true, ReturnList};
                                false -> false
                            end;
                        _ ->
                            false
                    end
            end
    end.

make_source(Source) ->
    list_to_atom(util:make_sure_list(Source)).

%% 封测充值返还
send_info(Player) ->
    #player_status{sid = Sid, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{gold = Gold, login_days = LoginDays} = StatusReturn,
    {ok, BinData} = pt_332:write(33216, [Gold, Gold, LoginDays]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 是否奖励
is_can_ask_reward_data(Player) ->
    #player_status{source = Source, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{role_id = SyncRoleId} = StatusReturn,
    % 同步后不请求
    % 记录数据要关闭,发奖励的要开启
    case SyncRoleId > 0 of
        true -> false;
        false ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BETA_RECORD) of
                true -> false;
                false ->
                    Type = ?CUSTOM_ACT_TYPE_BETA_REWARD,
                    case lib_custom_act_api:get_open_subtype_ids(Type) of
                        [SubType|_] ->
                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, source_list) of
                                {source_list, SourceList} -> lists:member(make_source(Source), SourceList);
                                _ -> false
                            end;
                        _ ->
                            false
                    end
            end
    end.

%% 是否能记录
is_can_record(Player) ->
    #player_status{source = Source, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{role_id = SyncRoleId} = StatusReturn,
    % 同步后不记录
    % 记录数据要开启,发奖励的要关闭
    case SyncRoleId > 0 of
        true -> false;
        false ->
            case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BETA_REWARD) of
                true -> false;
                false ->
                    Type = ?CUSTOM_ACT_TYPE_BETA_RECORD,
                    case lib_custom_act_api:get_open_subtype_ids(Type) of
                        [SubType|_] ->
                            % ?MYLOG("hjhbeta", "Source:~p ~n", [make_source(Source)]),
                            case lib_custom_act_util:keyfind_act_condition(Type, SubType, source_list) of
                                {source_list, SourceList} ->
                                    % ?MYLOG("hjhbeta", "Source:~p SourceList:~p ~n", [lists:member(make_source(Source), SourceList), SourceList]),
                                    lists:member(make_source(Source), SourceList);
                                _ -> false
                            end;
                        _ ->
                            false
                    end
            end
    end.

%% 请求跨服中心获取数据
request_center_get(Accid, Accname, RoleId, ServerId) ->
    % ?MYLOG("hjhbeta", "is_can_ask_reward_data:~p ~n", [111111111]),
    case db_beta_recharge_return_select(Accid, Accname) of
        [0, Gold] ->
            db_beta_recharge_return_replace(Accid, Accname, RoleId, Gold),
            mod_clusters_center:apply_cast(ServerId, ?MODULE, back_local_get, [Accid, Accname, RoleId, RoleId, Gold]);
        [SyncRoleId, Gold] ->
            mod_clusters_center:apply_cast(ServerId, ?MODULE, back_local_get, [Accid, Accname, RoleId, SyncRoleId, Gold]);
        _ ->
            mod_clusters_center:apply_cast(ServerId, ?MODULE, back_local_get, [Accid, Accname, RoleId, RoleId, 0])
    end,
    ok.

%% 返回本地请求的数据
back_local_get(Accid, Accname, RoleId, SyncRoleId, Gold) when is_integer(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case is_pid(Pid) andalso misc:is_process_alive(Pid) of
        true -> lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, back_local_get, [SyncRoleId, Gold]);
        false ->
            case db_role_beta_recharge_return_select(Accid, Accname) of
                [SyncRoleId0, _Gold, _DaysUtime, _LoginDays] when SyncRoleId0 > 0 -> skip;
                [0, Gold, DaysUtime, LoginDays] ->
                    StatusReturn = #status_beta_recharge_return{role_id = RoleId, gold = Gold, days_utime = DaysUtime, login_days = LoginDays},
                    db_role_beta_recharge_return_replace(Accid, Accname, StatusReturn);
                _ ->
                    StatusReturn = #status_beta_recharge_return{role_id = RoleId, gold = Gold},
                    db_role_beta_recharge_return_replace(Accid, Accname, StatusReturn)
            end,
            ok
    end.

back_local_get(Player, SyncRoleId, Gold) ->
    #player_status{accid = Accid, accname = Accname, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{role_id = OldSyncRoleId} = StatusReturn,
    % 没有同步,
    case OldSyncRoleId > 0 of
        true ->
            {ok, Player};
        false ->
            NewStatusReturn = StatusReturn#status_beta_recharge_return{role_id = SyncRoleId, gold = Gold},
            db_role_beta_recharge_return_replace(Accid, Accname, NewStatusReturn),
            NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
            PlayerAfDays = update_login_days(NewPlayer),
            {ok, PlayerAfDays}
    end.

%% 请求跨服中心记录(如果被同步过不处理)
%% @param TotalGold 本服最高
request_center_record(ServerId, RoleId, Accid, Accname, TotalGold, Gold) ->
    case db_beta_recharge_return_select(Accid, Accname) of
        [SyncRoleId, _OldGold] when SyncRoleId > 0 -> skip;
        [0, OldGold] ->
            % 因为有可能是不同服,所以要汇总
            SumGold = Gold + OldGold,
            MaxGold = max(TotalGold, SumGold),
            case MaxGold > 0 of
                true -> db_beta_recharge_return_replace(Accid, Accname, 0, MaxGold);
                false -> skip
            end,
            mod_clusters_center:apply_cast(ServerId, ?MODULE, back_local_record, [RoleId, MaxGold]);
        _ ->
            MaxGold = max(TotalGold, Gold),
            case MaxGold > 0 of
                true -> db_beta_recharge_return_replace(Accid, Accname, 0, MaxGold);
                false -> skip
            end,
            mod_clusters_center:apply_cast(ServerId, ?MODULE, back_local_record, [RoleId, MaxGold])
    end,
    ok.

back_local_record(RoleId, Gold) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, back_local_record, [Gold]),
    ok;
back_local_record(Player, Gold) ->
    #player_status{accid = Accid, accname = Accname, beta_recharge_return = StatusReturn} = Player,
    #status_beta_recharge_return{gold = OldGold} = StatusReturn,
    case Gold =/= OldGold of
        true ->
            NewStatusReturn = StatusReturn#status_beta_recharge_return{gold = Gold},
            db_role_beta_recharge_return_replace(Accid, Accname, NewStatusReturn),
            NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
            send_info(NewPlayer);
        false ->
            NewPlayer = Player
    end,
    {ok, NewPlayer}.

%% 每天触发
daily_timer(?TWELVE = Clock) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() ->
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_beta_recharge_return, daily_timer, [Clock])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok;
daily_timer(_Clock) ->
    ok.

daily_timer(#player_status{online = ?ONLINE_ON} = Player, ?TWELVE) ->
    PlayerAfDays = update_login_days(Player),
    % ?PRINT("111111 ~n", []),
    {ok, PlayerAfDays};
daily_timer(Player, _Clock) ->
    {ok, Player}.

%% 秘籍触发天数
gm_update_login_days(Player) ->
    #player_status{beta_recharge_return = StatusReturn} = Player,
    NewStatusReturn = StatusReturn#status_beta_recharge_return{days_utime = 0},
    NewPlayer = Player#player_status{beta_recharge_return = NewStatusReturn},
    update_login_days(NewPlayer).

db_role_beta_recharge_return_select(_Accid, Accname) ->
    Sql0 = <<"SELECT role_id, gold, days_utime, login_days FROM role_beta_recharge_return WHERE accname = '~s'">>,
    Sql = io_lib:format(Sql0, [Accname]),
    % Sql = io_lib:format(?sql_role_beta_recharge_return_select, [Accid, Accname]),
    db:get_row(Sql).

db_role_beta_recharge_return_replace(Accid, Accname, StatusReturn) ->
    #status_beta_recharge_return{role_id = RoleId, gold = Gold, days_utime = DaysUtime, login_days = LoginDays} = StatusReturn,
    % Sql0 = <<"update role_beta_recharge_return set role_id=~p, gold=~p, days_utime=~p, login_days=~p where accname='~s'">>,
    % Sql = io_lib:format(Sql0, [RoleId, Gold, DaysUtime, LoginDays, Accname]),
    Sql = io_lib:format(?sql_role_beta_recharge_return_replace, [Accid, Accname, RoleId, Gold, DaysUtime, LoginDays]),
    db:execute(Sql).

%% 跨服中的充值返还
db_beta_recharge_return_select(_Accid, Accname) ->
    Sql0 = <<"SELECT role_id, gold FROM beta_recharge_return WHERE accname = '~s'">>,
    Sql = io_lib:format(Sql0, [Accname]),
    % Sql = io_lib:format(?sql_beta_recharge_return_select, [Accid, Accname]),
    db:get_row(Sql).

db_beta_recharge_return_replace(Accid, Accname, RoleId, Gold) ->
    % Sql0 = <<"update beta_recharge_return set role_id=~p, gold=~p, time=~p where accname='~s'">>,
    % Sql = io_lib:format(Sql0, [RoleId, Gold, utime:unixtime(), Accname]),
    Sql = io_lib:format(?sql_beta_recharge_return_replace, [Accid, Accname, RoleId, Gold, utime:unixtime()]),
    db:execute(Sql).

%% 秘籍：推数据到跨服中心
gm_udpate_record(RoleList) ->
    spawn(fun() -> gm_udpate_record_help(RoleList) end).

gm_udpate_record_help(RoleList) ->
    F = fun([RoleId, Accid, Accname, Source], Count) ->
        case Count rem 10 == 0 of
            true ->
                timer:sleep(200);
            false -> skip
        end,
        case gm_is_can_record(Source) of
            true ->
                TotalGold = lib_recharge_data:get_total(RoleId),
                mod_clusters_node:apply_cast(?MODULE, request_center_record, [config:get_server_id(), RoleId, Accid, Accname, TotalGold, 0]),
                Count + 1;
            false -> Count
        end

        end,
    lists:foldl(F, 0, RoleList).

gm_is_can_record(Source) ->
    case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BETA_REWARD) of
        true -> false;
        false ->
            Type = ?CUSTOM_ACT_TYPE_BETA_RECORD,
            case lib_custom_act_api:get_open_subtype_ids(Type) of
                [SubType|_] ->
                    case lib_custom_act_util:keyfind_act_condition(Type, SubType, source_list) of
                        {source_list, SourceList} ->
                            lists:member(make_source(Source), SourceList);
                        _ -> false
                    end;
                _ -> false
            end
    end.

%% 修复在线玩家没收到奖励问题
gm_repair_online() ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
    F = fun(RoleId) ->
        lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_beta_recharge_return, login, [])
        end,
    lists:foreach(F, IdList).

gm_delete_role_beta_recharge_return(RoleIdLStr) ->
    RoleIdL = util:string_to_term(RoleIdLStr),
    Sql = "delete from role_beta_recharge_return" ++ usql:condition({role_id, in, RoleIdL}),
    db:execute(Sql),
    gm_repair_online().
