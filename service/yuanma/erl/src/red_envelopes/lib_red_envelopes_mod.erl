%%-----------------------------------------------------------------------------
%% @Module  :       lib_red_envelopes_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    红包(通用框架)
%%-----------------------------------------------------------------------------
-module(lib_red_envelopes_mod).

-include("red_envelopes.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("def_id_create.hrl").

-export([
    init/0
    , make_record/2
    , send_split_num_info/6
    , send_red_envelopes/6
    , add_red_envelopes/1
    , open_red_envelopes/4
    , daily_clear_red_envelopes/0
    , add_expired_log/2
    , join_guild/2
    , quit_guild/2
    , disband_guild/1
    ]).

make_record(sql_red_envelopes, [Id, Type, OwnershipType, OwnershipId, OwnerId, Status, Money, SplitNum, Extra, Stime, Ctime, Msg, Others]) ->
    #red_envelopes{
        id = Id, type = Type, ownership_type = OwnershipType, ownership_id = OwnershipId,
        owner_id = OwnerId, status = Status, money = Money,
        split_num = SplitNum, extra = Extra, stime = Stime, ctime = Ctime, msg = Msg, others = util:bitstring_to_term(Others)
    };
make_record(red_envelopes, [Id, Type, OwnershipType, OwnershipId, OwnerId, Status, Money, SplitNum, Extra, Stime, Ctime, Msg, Others]) ->
    #red_envelopes{
        id = Id, type = Type, ownership_type = OwnershipType, ownership_id = OwnershipId,
        owner_id = OwnerId, status = Status, money = Money,
        split_num = SplitNum, extra = Extra, stime = Stime, ctime = Ctime, msg = Msg, others = Others
    };
make_record(sql_recipients, [RoleId, RedEnvelopesId, Money, Time]) ->
    #recipients_record{
        role_id = RoleId, red_envelopes_id = RedEnvelopesId,
        money = Money, time = Time
    };
make_record(obtain_record, [AutoId, RoleId, RoleName, CfgId, Time]) ->
    #obtain_record{
        id = AutoId, role_id = RoleId, role_name = RoleName,
        cfg_id = CfgId, time = Time
    }.

init() ->
    RedEnvelopesList = db:get_all(io_lib:format(?sql_select_red_envelopes, [])),
    RecipientsList = db:get_all(io_lib:format(?sql_select_recipients_record, [])),
    NowTime = utime:unixtime(),
    RecipientsMap = init_recipients_map(RecipientsList, #{}),
    {RedEnvelopesMap, NoSendMap, ExpiredList} = init_red_envelopes_map(RedEnvelopesList, NowTime, RecipientsMap, #{}, #{}, []),
    lib_red_envelopes_data:save_red_envelopes_map(RedEnvelopesMap),
    lib_red_envelopes_data:save_red_envelopes_nosend(NoSendMap),
    handle_expire_red_envelopes(ExpiredList),
    ok.

init_red_envelopes_map([], _NowTime, _RecipientsMap, RedEnvelopesMap, NoSendMap, ExpiredList) -> 
    {RedEnvelopesMap, NoSendMap, ExpiredList};
init_red_envelopes_map([T|RList], NowTime, RecipientsMap, RedEnvelopesMap, NoSendMap, ExpiredList) ->
    RedEnvelopes = make_record(sql_red_envelopes, T),
    #red_envelopes{
        id = RedEnvelopesId,
        ownership_type = OwnershipType,
        ownership_id = OwnershipId,
        owner_id = OwnerId,
        status = Status
    } = RedEnvelopes,
    case lib_red_envelopes:is_vaild_red_envelopes(RedEnvelopes, NowTime) of
        true ->
            OneTypeMap = maps:get(OwnershipType, RedEnvelopesMap, #{}),
            List = maps:get(OwnershipId, OneTypeMap, []),
            RecipientsList = maps:get(RedEnvelopesId, RecipientsMap, []),
            NewRedEnvelopes = RedEnvelopes#red_envelopes{recipients_num = length(RecipientsList), recipients_lists = RecipientsList},
            NewList = lists:reverse([NewRedEnvelopes|List]),
            NewOneTypeMap = maps:put(OwnershipId, NewList, OneTypeMap),
            NewRedEnvelopesMap = maps:put(OwnershipType, NewOneTypeMap, RedEnvelopesMap),
            case Status == ?NO_SEND of 
                true ->
                    NoSendList = maps:get(OwnerId, NoSendMap, []),
                    NewNoSendMap = maps:put(OwnerId, [RedEnvelopesId|NoSendList], NoSendMap);
                _ ->
                    NewNoSendMap = NoSendMap
            end,
            init_red_envelopes_map(RList, NowTime, RecipientsMap, NewRedEnvelopesMap, NewNoSendMap, ExpiredList);
        false -> %% 已经过期的不加载
            RecipientsList = maps:get(RedEnvelopesId, RecipientsMap, []),
            NewRedEnvelopes = RedEnvelopes#red_envelopes{recipients_num = length(RecipientsList), recipients_lists = RecipientsList},
            init_red_envelopes_map(RList, NowTime, RecipientsMap, RedEnvelopesMap, NoSendMap, [NewRedEnvelopes|ExpiredList])
    end.

%% 初始化红包领取Map
init_recipients_map([], RecipientsMap) -> RecipientsMap;
init_recipients_map([T|List], RecipientsMap) ->
    Recipients = make_record(sql_recipients, T),
    #recipients_record{red_envelopes_id = RedEnvelopesId} = Recipients,
    RecipientsList = maps:get(RedEnvelopesId, RecipientsMap, []),
    NewRecipientsMap = maps:put(RedEnvelopesId, [Recipients|RecipientsList], RecipientsMap),
    init_recipients_map(List, NewRecipientsMap).

%% 发送红包拆分界面信息
send_split_num_info(OwnershipType, OwnershipId, _OwnershipLv, RoleId, Classify, Extra) ->
    if
        Classify == ?SYSTEM_RED_ENVELOPES ->
            case lib_red_envelopes_data:get_red_envelopes(OwnershipType, OwnershipId, Extra) of
                #red_envelopes{extra = CfgId} -> skip;
                _ -> CfgId = 0
            end;
        Classify == ?GOODS_RED_ENVELOPES -> CfgId = Extra;
        true -> CfgId = 0
    end,
    if
        Classify =:= ?GOODS_RED_ENVELOPES -> %% 道具红包才会限制每日使用数量
            TimesLimit = 1,
            Count = mod_daily:get_count(RoleId, ?MOD_RED_ENVELOPES, ?MOD_RED_ENVELOPES_GOODS, CfgId),
            TotalTimes = lib_red_envelopes_data:get_times_limit(?MOD_RED_ENVELOPES_GOODS, CfgId),
            RemainTimes = max(0, TotalTimes - Count);
        true ->
            TimesLimit = 0, RemainTimes = 0, TotalTimes = 0
    end,
    DefSplitNum = if
        Classify =:= ?SYSTEM_RED_ENVELOPES ->
            case data_red_envelopes:get(CfgId) of
                #red_envelopes_cfg{money = Money} -> Money;
                _ -> ?RED_ENVELOPES_MIN_SPLIT_NUM
            end;
        Classify =:= ?GOODS_RED_ENVELOPES ->
            case data_red_envelopes:get_goods_cfg(CfgId) of
                #red_envelopes_goods_cfg{money = Money} -> Money;
                _ -> ?RED_ENVELOPES_MIN_SPLIT_NUM
            end;
        true -> ?RED_ENVELOPES_MIN_SPLIT_NUM
    end,
    MemberNum = case OwnershipType of
        ?GUILD_RED_ENVELOPES ->
            case catch mod_guild:get_guild_member_num(OwnershipId) of
                GuildMemberNum when is_integer(GuildMemberNum) -> GuildMemberNum;
                _ -> ?RED_ENVELOPES_MIN_SPLIT_NUM
            end;
            % data_guild_m:get_guild_member_capacity(OwnershipLv);
        _ -> ?RED_ENVELOPES_MIN_SPLIT_NUM
    end,
    {ok, BinData} = pt_339:write(33903, [TimesLimit, RemainTimes, TotalTimes, max(?RED_ENVELOPES_MIN_SPLIT_NUM, min(DefSplitNum, MemberNum))]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 发送红包 类型是道具或者Vip红包的不走这里
send_red_envelopes(OwnershipType, OwnershipId, _OwnershipLv, RoleId, RedEnvelopesId, SplitNum) ->
    NowTime = utime:unixtime(),
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    OneTypeMap = maps:get(OwnershipType, RedEnvelopesMap, #{}),
    RedEnvelopesList = maps:get(OwnershipId, OneTypeMap, []),
    RedEnvelopes = lists:keyfind(RedEnvelopesId, #red_envelopes.id, RedEnvelopesList),
    IsVaildRedEnvelopes = lib_red_envelopes:is_vaild_red_envelopes(RedEnvelopes, NowTime),
    ErrCode = if
        IsVaildRedEnvelopes == false -> ?ERRCODE(err339_not_exist);
        RedEnvelopes#red_envelopes.owner_id =/= RoleId -> ?ERRCODE(err339_not_owner);
        OwnershipType == ?GUILD_RED_ENVELOPES andalso OwnershipId =< 0 -> ?ERRCODE(err339_not_join_guild);
        RedEnvelopes#red_envelopes.status == ?HAS_SEND -> ?ERRCODE(err339_cannot_send_again);
        true ->
            Cfg = data_red_envelopes:get(RedEnvelopes#red_envelopes.extra),
            if
                is_record(Cfg, red_envelopes_cfg) == false -> ?ERRCODE(missing_config);
                true ->
                    #red_envelopes_cfg{money = Money, min_num = MinSplitNum} = Cfg,
                    MemberNum = case OwnershipType == ?GUILD_RED_ENVELOPES of
                        true -> mod_guild:get_guild_member_capacity(OwnershipId);
                        false -> 9999999999
                    end,
                    if
                        SplitNum > MemberNum orelse SplitNum > Money -> ?ERRCODE(err339_split_max_num_err);
                        SplitNum < MinSplitNum -> ?ERRCODE(err339_split_min_num_err);
                        true ->
                            db:execute(io_lib:format(?sql_update_red_envelopes_status_and_split_num,
                                [?HAS_SEND, SplitNum, NowTime, RedEnvelopesId])),
                            NewRedEnvelopes = RedEnvelopes#red_envelopes{status = ?HAS_SEND, split_num = SplitNum, stime = NowTime},
                            NewRedEnvelopesList = lists:keystore(RedEnvelopesId, #red_envelopes.id, RedEnvelopesList, NewRedEnvelopes),
                            NewOneTypeMap = maps:put(OwnershipId, NewRedEnvelopesList, OneTypeMap),
                            NewRedEnvelopesMap = maps:put(OwnershipType, NewOneTypeMap, RedEnvelopesMap),
                            lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap),
                            lib_red_envelopes_data:delete_nosend_red_envelopes(NewRedEnvelopes),
                            %% 日志
                            LogExtraArgs = [{money, Money}, {split_num, SplitNum}],
                            lib_log_api:log_red_envelopes(RedEnvelopesId, OwnershipType, OwnershipId, RedEnvelopes#red_envelopes.owner_id, ?HAS_SEND, RedEnvelopes#red_envelopes.type, LogExtraArgs),
                            case lists:member(RedEnvelopes#red_envelopes.type, ?NOT_RECORD_TYPES) of
                                true -> skip;
                                false ->
                                    lib_red_envelopes_data:add_obtain_record(NewRedEnvelopes)
                            end,
                            %% 推送新的红包给客户端
                            PackList = lib_red_envelopes:pack_red_envelopes_list(RoleId, [NewRedEnvelopes]),
                            {ok, UpdateBinData} = pt_339:write(33907, [PackList]),
                            lib_server_send:send_to_uid(RoleId, UpdateBinData),
                            lib_red_envelopes:notify_client(?NEW_RED_ENVELOPES, NewRedEnvelopes),
                            ?SUCCESS
                    end
            end
    end,
    ?PRINT("ErrCode ~p~n", [ErrCode]),
    {ok, BinData} = pt_339:write(33904, [ErrCode]),
    lib_server_send:send_to_uid(RoleId, BinData).

%% 增加新的红包
add_red_envelopes(Args) ->
    [Type, OwnershipType, OwnershipId, OwnerId, Status, Money, SplitNum, Extra, Msg, ExtraArgs] = Args,
    NowTime = utime:unixtime(),
    Stime = case Status of
        ?NO_SEND -> 0;
        _ -> NowTime
    end,
    AutoId = mod_id_create:get_new_id(?RED_ENVELOPES_ID_CREATE),
    Others = lib_red_envelopes:get_red_envelopes_others_data(Type, OwnershipType, OwnershipId, OwnerId, ExtraArgs),
    RedEnvelopes = lib_red_envelopes_mod:make_record(red_envelopes,
        [AutoId, Type, OwnershipType, OwnershipId, OwnerId, Status, Money, SplitNum, Extra, Stime, NowTime, Msg, Others]),
    lib_red_envelopes_data:db_insert_red_envelopes(RedEnvelopes),

    %% 日志
    LogExtraArgs = ?IF(Status == ?HAS_SEND, [{money, Money}, {split_num, SplitNum}], [{money, Money}]),
    lib_log_api:log_red_envelopes(AutoId, OwnershipType, OwnershipId, OwnerId, Status, Type, LogExtraArgs),
    ?PRINT("add_red_envelopes ~p~n", [RedEnvelopes]),
    lib_red_envelopes_data:add_red_envelopes(RedEnvelopes),
    % case lists:member(Type, ?NOT_RECORD_TYPES) of
    %     true -> skip;
    %     false ->
    %         lib_red_envelopes_data:add_obtain_record(RedEnvelopes)
    % end,
    case lists:member(OwnershipType, ?RECORD_OWNERSHIP_NOSEND) == true andalso Status == ?NO_SEND of 
        false -> skip;
        true ->
            lib_red_envelopes_data:add_nosend_red_envelopes(RedEnvelopes)
    end,
    case Type of
        ?RED_ENVELOPES_TYPE_VIP_PLAYER_SEND ->
            %% 推送新的红包给客户端
            PackList = lib_red_envelopes:pack_red_envelopes_list(OwnerId, [RedEnvelopes]),
            {ok, BinData} = pt_339:write(33907, [PackList]),
            lib_server_send:send_to_uid(OwnerId, BinData);
        _ -> skip
    end,
    %% 通知客户端有新的红包
    lib_red_envelopes:notify_client(?NEW_RED_ENVELOPES, RedEnvelopes).

%% 打开红包
open_red_envelopes(OwnershipType, OwnershipId, RoleId, RedEnvelopesId) ->
    NowTime = utime:unixtime(),
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    OneTypeMap = maps:get(OwnershipType, RedEnvelopesMap, #{}),
    RedEnvelopesList = maps:get(OwnershipId, OneTypeMap, []),
    RedEnvelopes = lists:keyfind(RedEnvelopesId, #red_envelopes.id, RedEnvelopesList),
    IsVaildRedEnvelopes = lib_red_envelopes:is_vaild_red_envelopes(RedEnvelopes, NowTime),
    if
        IsVaildRedEnvelopes == false ->
            lib_red_envelopes:send_error_code_by_uid(RoleId, ?ERRCODE(err339_not_exist));
        true ->
            #red_envelopes{
                owner_id = OwnerId, status = Status, stime = Stime,
                recipients_lists = RecipientsList, type = Type, extra = Extra
            } = RedEnvelopes,
            #figure{
                name = OwnerName, career = OwnerCareer, sex = OwnerSex, turn = OwnerTurn,
                picture = OwnerPic, picture_ver = OwnerPicVer
            } = lib_role:get_role_figure(OwnerId),
            DelAfSendTime = ?DEL_AF_SEND_TIME,
            if
                Status == ?NO_SEND ->
                    lib_red_envelopes:send_error_code_by_uid(RoleId, ?ERRCODE(err339_not_send));
                Status == ?EXPIRED orelse (Status == ?HAS_SEND andalso Stime =< NowTime - DelAfSendTime) ->
                    lib_red_envelopes:send_error_code_by_uid(RoleId, ?ERRCODE(err339_has_expired));
                true ->
                    CanOpen = lib_red_envelopes:check_open_red_envelopes_others(RedEnvelopes, RoleId),
                    RecipientsRecord = lists:keyfind(RoleId, #recipients_record.role_id, RecipientsList),
                    Res = if
                        is_record(RecipientsRecord, recipients_record) == true ->
                            {ok, RecipientsRecord#recipients_record.money, RedEnvelopes};
                        Status == ?END ->
                            {ok, 0, RedEnvelopes};
                        true -> %% 未领取
                            case CanOpen =/= true of 
                                true -> CanOpen;
                                _ ->
                                    receive_red_envelopes(RoleId, RedEnvelopes, NowTime)
                            end
                    end,
                    case Res of
                        {ok, ObtainMoney, NewRedEnvelopes} ->
                            ?PRINT("open_red_envelopes ~p~n", [ObtainMoney]),
                            ?PRINT("open_red_envelopes ~p~n", [NewRedEnvelopes]),
                            NewRedEnvelopesList = lists:keystore(RedEnvelopesId, #red_envelopes.id, RedEnvelopesList, NewRedEnvelopes),
                            NewOneTypeMap = maps:put(OwnershipId, NewRedEnvelopesList, OneTypeMap),
                            NewRedEnvelopesMap = maps:put(OwnershipType, NewOneTypeMap, RedEnvelopesMap),
                            lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap),
                            PackList = lib_red_envelopes:pack_recipients_record(NewRedEnvelopes#red_envelopes.recipients_lists),
                            case OwnershipType of
                                ?ACT_RED_ENVELOPES -> %% 定制活动红包返回自己的协议
                                    {ok, BinData} = pt_331:write(33158, [RedEnvelopesId, OwnerId, OwnerName, OwnerCareer, OwnerSex, OwnerTurn, OwnerPic, OwnerPicVer,
                                        NewRedEnvelopes#red_envelopes.status, ObtainMoney, NewRedEnvelopes#red_envelopes.split_num,
                                        NewRedEnvelopes#red_envelopes.recipients_num, NewRedEnvelopes#red_envelopes.money, Type, Extra, PackList]);
                                _ ->
                                    {ok, BinData} = pt_339:write(33902, [RedEnvelopesId, OwnerId, OwnerName, OwnerCareer, OwnerSex, OwnerTurn, OwnerPic, OwnerPicVer,
                                        NewRedEnvelopes#red_envelopes.status, ObtainMoney, NewRedEnvelopes#red_envelopes.split_num,
                                        NewRedEnvelopes#red_envelopes.recipients_num, NewRedEnvelopes#red_envelopes.money, Type, Extra, PackList])
                            end,
                            case NewRedEnvelopes#red_envelopes.status == ?END andalso Status =/= NewRedEnvelopes#red_envelopes.status of 
                                true ->
                                    {ok, Bin33908} = pt_339:write(33908, [RedEnvelopesId]),
                                    lib_server_send:send_to_guild(OwnershipId, Bin33908);
                                _ -> skip
                            end,
                            lib_server_send:send_to_uid(RoleId, BinData);
                        {false, ErrCode} ->
                            lib_red_envelopes:send_error_code_by_uid(RoleId, ErrCode);
                        _ -> skip
                    end
            end
    end.

%% 领取红包
receive_red_envelopes(RoleId, RedEnvelopes, NowTime) ->
    #red_envelopes{
        id = RedEnvelopesId,
        type = Type,
        ownership_type = OwnershipType,
        ownership_id = OwnershipId,
        owner_id = OwnerId,
        status = ?HAS_SEND,
        split_num = SplitNum,
        recipients_num = RecipientsNum,
        recipients_lists = RecipientsList,
        extra = Extra,
        stime = Stime
    } = RedEnvelopes,
    Classify = lib_red_envelopes:get_red_envelopes_classify(Type),
    MoneyType = lib_red_envelopes:count_money_type(Classify, Extra),
    ObtainMoney = lib_red_envelopes:count_obtain_money(RedEnvelopes),
    F = fun() ->
        db:execute(io_lib:format(?sql_insert_recipients_record,
            [RoleId, RedEnvelopesId, OwnershipId, ObtainMoney, Stime, NowTime])),
        %% 如果红包领完了要更新状态
        NewStatus = case RecipientsNum + 1 == SplitNum of
            true ->
                db:execute(io_lib:format(?sql_update_red_envelopes_status, [?END, Stime, RedEnvelopesId])),
                %% 日志
                lib_log_api:log_red_envelopes(RedEnvelopesId, OwnershipType, OwnershipId, OwnerId, ?END, Type, []),
                ?END;
            false -> ?HAS_SEND
        end,
        {ok, NewStatus}
    end,
    case catch db:transaction(F) of
        {ok, NewStatus} ->
            AddRecipientsRecord = make_record(sql_recipients,
                [RoleId, RedEnvelopesId, ObtainMoney, NowTime]),
            NewRecipientsList = [AddRecipientsRecord|RecipientsList],
            %% 红包领取日志
            lib_log_api:log_red_envelopes_recipients(RoleId, RedEnvelopesId, [{MoneyType, 0, ObtainMoney}]),
            lib_goods_api:send_reward_by_id([{MoneyType, ObtainMoney}], red_envelopes, RoleId),
            NewRedEnvelopes = RedEnvelopes#red_envelopes{
                status = NewStatus, recipients_num = RecipientsNum + 1, recipients_lists = NewRecipientsList},
            {ok, ObtainMoney, NewRedEnvelopes};
        _Err ->
            ?ERR("receive red envelopes err:~p", [_Err]),
            {false, ?ERRCODE(system_busy)}
    end.

disband_guild(GuildId) ->
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    GuildRedEnvelopesMap = maps:get(?GUILD_RED_ENVELOPES, RedEnvelopesMap, #{}),
    RedEnvelopesList = maps:get(GuildId, GuildRedEnvelopesMap, []),
    F = fun(#red_envelopes{status = Status}) -> Status == ?NO_SEND end,
    {NoSendRedEnvelopes, DelList} = lists:partition(F, RedEnvelopesList),
    NewOwnerShipId = 0,
    Fun = fun() ->
        %% 删除已经发送了的红包
        lib_red_envelopes_data:db_delete_red_envelopes_by_ids(DelList),
        %% 更改归属
        lib_red_envelopes_data:db_update_red_envelopes_ownership(NoSendRedEnvelopes, NewOwnerShipId),
        %% 删除红包领取记录
        lib_red_envelopes_data:db_delete_red_envelopes_record_by_ownership_id(GuildId),
        ok
    end,
    case catch db:transaction(Fun) of
        ok ->
            GuildRedEnvelopesMap1 = maps:remove(GuildId, GuildRedEnvelopesMap),
            NewGuildRedEnvelopesMap = lib_red_envelopes_data:change_ownership_id(NoSendRedEnvelopes, GuildRedEnvelopesMap1, NewOwnerShipId),
            spawn(fun() ->
                lib_red_envelopes_mod:add_expired_log(DelList, [{disband_guild, GuildId}])
            end),
            NewRedEnvelopesMap = maps:put(?GUILD_RED_ENVELOPES, NewGuildRedEnvelopesMap, RedEnvelopesMap),
            lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap),
            lib_red_envelopes_data:del_obtain_record(?GUILD_RED_ENVELOPES, GuildId),
            [lib_red_envelopes_data:add_nosend_red_envelopes(RedEnvelopes#red_envelopes{ownership_id = NewOwnerShipId}) ||RedEnvelopes <- NoSendRedEnvelopes];
        _Err ->
            ?ERR("disband_guild err: ~p~n", [_Err]),
            ok
    end.

quit_guild(RoleId, GuildId) ->
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    GuildRedEnvelopesMap = maps:get(?GUILD_RED_ENVELOPES, RedEnvelopesMap, #{}),
    RedEnvelopesList = maps:get(GuildId, GuildRedEnvelopesMap, []),
    F = fun(#red_envelopes{owner_id = OwnerId, status = Status}) -> OwnerId == RoleId andalso Status == ?NO_SEND end,
    {NoSendRedEnvelopes, NewRedEnvelopesList} = lists:partition(F, RedEnvelopesList),
    NewOwnerShipId = 0,
    Fun = fun() ->
        %% 更改归属
        lib_red_envelopes_data:db_update_red_envelopes_ownership(NoSendRedEnvelopes, NewOwnerShipId),
        ok
    end,
    case catch db:transaction(Fun) of
        ok ->
            GuildRedEnvelopesMap1 = maps:put(GuildId, NewRedEnvelopesList, GuildRedEnvelopesMap),
            NewGuildRedEnvelopesMap = lib_red_envelopes_data:change_ownership_id(NoSendRedEnvelopes, GuildRedEnvelopesMap1, NewOwnerShipId),
            NewRedEnvelopesMap = maps:put(?GUILD_RED_ENVELOPES, NewGuildRedEnvelopesMap, RedEnvelopesMap),
            lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap);
        _Err ->
            ?ERR("quit_guild err: ~p~n", [_Err]),
            ok
    end.

join_guild(RoleId, GuildId) ->
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    NoSendMap = lib_red_envelopes_data:get_red_envelopes_nosend(),
    case maps:get(RoleId, NoSendMap, []) of 
        [] -> ok;
        _NoSendList ->
            OldOwnerShipId = 0, NewOwnerShipId = GuildId,
            GuildRedEnvelopesMap = maps:get(?GUILD_RED_ENVELOPES, RedEnvelopesMap, #{}),
            RedEnvelopesList = maps:get(OldOwnerShipId, GuildRedEnvelopesMap, []),
            F = fun(#red_envelopes{owner_id = OwnerId, status = Status}) -> OwnerId == RoleId andalso Status == ?NO_SEND end,
            {NoSendRedEnvelopes, NewRedEnvelopesList} = lists:partition(F, RedEnvelopesList),
            Fun = fun() ->
                %% 更改归属
                lib_red_envelopes_data:db_update_red_envelopes_ownership(NoSendRedEnvelopes, NewOwnerShipId),
                ok
            end,
            case catch db:transaction(Fun) of
                ok ->
                    GuildRedEnvelopesMap1 = maps:put(OldOwnerShipId, NewRedEnvelopesList, GuildRedEnvelopesMap),
                    NewGuildRedEnvelopesMap = lib_red_envelopes_data:change_ownership_id(NoSendRedEnvelopes, GuildRedEnvelopesMap1, NewOwnerShipId),
                    NewRedEnvelopesMap = maps:put(?GUILD_RED_ENVELOPES, NewGuildRedEnvelopesMap, RedEnvelopesMap),
                    [lib_red_envelopes:notify_client(?NEW_RED_ENVELOPES, RedEnvelopes#red_envelopes{ownership_id = NewOwnerShipId}) || RedEnvelopes <- NoSendRedEnvelopes],
                    lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap);
                _Err ->
                    ?ERR("join_guild err: ~p~n", [_Err]),
                    ok
            end
    end.

%% 日常清理红包数据
daily_clear_red_envelopes() ->
    NowTime = utime:unixtime(),
    ExpiredStime = NowTime - ?DEL_AF_SEND_TIME,
    AutoSendAFCtime = NowTime - ?AUTO_SEND_AF_TIME,
    db:execute(io_lib:format(?sql_del_red_envelopes_by_stime, [ExpiredStime])),
    db:execute(io_lib:format(?sql_del_nosend_red_envelopes_by_ctime, [AutoSendAFCtime])),
    %% 清理过期的红包领取记录
    db:execute(io_lib:format(?sql_del_red_envelopes_recipients_record_by_stime, [ExpiredStime])),
    RedEnvelopesMap = lib_red_envelopes_data:get_red_envelopes_map(),
    F = fun() ->
        %% 设置一个通知客户端新红包的缓存
        put("notify_client_cache", []),
        put("expired_list", []),
        put("expired_nosend", []),
        F1 = fun(OwnershipId, Val, {Counter, TmpMap}) ->
            {NewCounter, List} = auto_send_red_envelopes(Val, NowTime, ExpiredStime, AutoSendAFCtime, Counter, []),
            NewTmpMap = maps:put(OwnershipId, List, TmpMap),
            {NewCounter, NewTmpMap}
        end,
        F2 = fun(OwnershipType, Val, {Counter, TmpMap}) ->
            {NewCounter, NewVal} = maps:fold(F1, {Counter, #{}}, Val),
            NewTmpMap = maps:put(OwnershipType, NewVal, TmpMap),
            {NewCounter, NewTmpMap}
        end,
        {_, NewRedEnvelopesMap} = maps:fold(F2, {1, #{}}, RedEnvelopesMap),
        ExpiredList = erase("expired_list"),
        CacheList = erase("notify_client_cache"),
        ExpiredNoSend = erase("expired_nosend"),
        {ok, ExpiredList, CacheList, ExpiredNoSend, NewRedEnvelopesMap}
    end,
    case catch db:transaction(F) of
        {ok, ExpiredList, CacheList, ExpiredNoSend, NewRedEnvelopesMap} ->
            lib_red_envelopes_data:save_red_envelopes_map(NewRedEnvelopesMap),
            lib_red_envelopes_data:clear_expired_nosend(ExpiredNoSend),
            %% 在新的子进程处理 避免阻塞主进程
            spawn(fun() ->
                handle_expire_red_envelopes(ExpiredList),
                add_expired_log(ExpiredList, [{expired}]),
                do_af_auto_send_red_envelopes(CacheList, 1)
            end);
        Err ->
            ?ERR("red envelopes daily clear err:~p", [Err])
    end.

auto_send_red_envelopes([], _NowTime, _ExpiredStime, _AutoSendAFCtime, Counter, ResultL) -> {Counter, ResultL};
auto_send_red_envelopes([OneVal|L], NowTime, ExpiredStime, AutoSendAFCtime, Counter, ResultL) ->
    case OneVal of
        #red_envelopes{
            id = Id, ownership_type = _OwnershipType, ownership_id = _OwnershipId,
            status = Status, money = _Money, owner_id = OwnerId,
            stime = Stime, ctime = Ctime
        } ->
            if
                Status =/= ?NO_SEND andalso Stime =< ExpiredStime -> %% 已发送并且过期的要删除
                    ExpiredList = get("expired_list"),
                    put("expired_list", [OneVal|ExpiredList]),
                    auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter, ResultL);
                Status == ?NO_SEND andalso Ctime =< AutoSendAFCtime -> %% 没发送的红包过期，直接删除
                    ExpiredNoSend = get("expired_nosend"),
                    put("expired_nosend", [{OwnerId, Id}|ExpiredNoSend]),
                    auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter, ResultL);
                %% 暂时不用自动发送红包
                % OwnershipType == ?GUILD_RED_ENVELOPES
                % andalso OwnershipId > 0
                % andalso Status == ?NO_SEND
                % andalso Ctime =< AutoSendAFCtime -> %% 目前只有公会的红包在超过指定时间未发送会自动发送
                %     case catch mod_guild:get_guild_member_num(OwnershipId) of
                %         MemberNum when is_integer(MemberNum) andalso MemberNum > 0 ->
                %             SplitNum = ?IF(MemberNum > Money, Money, MemberNum),
                %             db:execute(io_lib:format(?sql_update_red_envelopes_status_and_split_num,
                %                 [?HAS_SEND, SplitNum, NowTime, Id])),
                %             NewOneVal = OneVal#red_envelopes{status = ?HAS_SEND, split_num = SplitNum, stime = NowTime},
                %             CacheList = get("notify_client_cache"),
                %             put("notify_client_cache", [NewOneVal|CacheList]),
                %             case Counter rem 20 of
                %                 0 -> timer:sleep(50);
                %                 _ -> skip
                %             end,
                %             auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter + 1, [NewOneVal|ResultL]);
                    %     _ -> auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter, [OneVal|ResultL])
                    % end;
                true ->
                    auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter, [OneVal|ResultL])
            end;
        _ -> auto_send_red_envelopes(L, NowTime, ExpiredStime, AutoSendAFCtime, Counter, ResultL)
    end.

%% 红包自动发送之后的相关操作
do_af_auto_send_red_envelopes([], _) -> ok;
do_af_auto_send_red_envelopes([T|L], Counter) ->
    case T of
        #red_envelopes{
            id = RedEnvelopesId, type = Type, money = Money, split_num = SplitNum,
            ownership_type = OwnershipType, ownership_id = OwnershipId, owner_id = OwnerId
        } ->
            case Counter rem 10 of
                0 -> timer:sleep(100);
                _ -> skip
            end,
            lib_red_envelopes:notify_client(?NEW_RED_ENVELOPES, T),
            %% 日志
            lib_log_api:log_red_envelopes(RedEnvelopesId, OwnershipType, OwnershipId, OwnerId, ?HAS_SEND, Type, [{auto_send}, {money, Money}, {split_num, SplitNum}]),
            do_af_auto_send_red_envelopes(L, Counter + 1);
        _ ->
            do_af_auto_send_red_envelopes(L, Counter)
    end.

%% 添加红包过期被删除的日志
add_expired_log([], _) -> ok;
add_expired_log([T|L], Args) ->
    case T of
        #red_envelopes{
            id = RedEnvelopesId, type = Type, status = Status,
            ownership_type = OwnershipType, ownership_id = OwnershipId, owner_id = OwnerId
        } ->
            %% 日志
            lib_log_api:log_red_envelopes(RedEnvelopesId, OwnershipType, OwnershipId, OwnerId, ?EXPIRED, Type, [{pre_status, Status}|Args]),
            add_expired_log(L, Args);
        _ -> add_expired_log(L, Args)
    end.

handle_expire_red_envelopes([]) -> ok;
handle_expire_red_envelopes([RedEnvelopes|ExpiredList]) ->
    #red_envelopes{
        type = Type, status = Status, owner_id = OwnerId, money = Money, recipients_lists = RecipientsList
    } = RedEnvelopes,
    case Type == ?RED_ENVELOPES_TYPE_VIP_PLAYER_SEND andalso Status =/= ?END of 
        true ->
            F = fun(T, MoneyTmp) ->
                MoneyTmp + T#recipients_record.money
            end,
            HasReceiveMoney = lists:foldl(F, 0, RecipientsList),
            LeftMoney = max(0, round(Money - HasReceiveMoney)),
            Title = utext:get(3390001),
            Content = utext:get(3390002),
            LeftMoney > 0 andalso lib_mail_api:send_sys_mail([OwnerId], Title, Content, [{?TYPE_GOLD, 0, LeftMoney}]),
            handle_expire_red_envelopes(ExpiredList);
        _ ->
            handle_expire_red_envelopes(ExpiredList)
    end.

