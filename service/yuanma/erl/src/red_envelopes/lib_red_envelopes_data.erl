%%-----------------------------------------------------------------------------
%% @Module  :       lib_red_envelopes_data
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-09-20
%% @Description:    红包data管理(通用框架)
%%-----------------------------------------------------------------------------
-module(lib_red_envelopes_data).

-include("figure.hrl").
-include("red_envelopes.hrl").
-include("common.hrl").
-include("def_module.hrl").

-compile([export_all]).

%% 获得红包Maps
get_red_envelopes_map() -> get(?P_RED_ENVELOPES).

%% 保存红包Maps
save_red_envelopes_map(RedEnvelopesMap) -> put(?P_RED_ENVELOPES, RedEnvelopesMap).

% %% 获得红包领取记录Maps
% get_recipients_map() -> get(?P_RED_ENVELOPES_RECIPIENTS).

% %% 保存红包领取记录Maps
% save_recipients_map(RecipientsMap) -> put(?P_RED_ENVELOPES_RECIPIENTS, RecipientsMap).


%% 获得未发送红包列表
get_red_envelopes_nosend() -> get(?P_RED_ENVELOPES_NOSEND).

%% 保存红包Maps
save_red_envelopes_nosend(RedEnvelopesNosend) -> put(?P_RED_ENVELOPES_NOSEND, RedEnvelopesNosend).

%% 获得红包获得记录Maps
get_obtain_record_map() ->
    case get(?P_RED_ENVELOPES_RECORD) of
        undefined ->
            Val = #{},
            save_obtain_record_map(#{}),
            Val;
        Val -> Val
    end.

%% 保存红包领取记录Maps
save_obtain_record_map(ObtainRecordMap) ->
    put(?P_RED_ENVELOPES_RECORD, ObtainRecordMap).

%% 根据归属获取红包列表
get_red_envelopes_list(OwnershipType, OwnershipId) ->
    RedEnvelopesMap = get_red_envelopes_map(),
    TypeRedEnvelopesMap = maps:get(OwnershipType, RedEnvelopesMap, #{}),
    maps:get(OwnershipId, TypeRedEnvelopesMap, []).

get_obtain_record_list(OwnershipType, OwnershipId) ->
    ObtainRecordMap = get_obtain_record_map(),
    TypeObtainRecordMap = maps:get(OwnershipType, ObtainRecordMap, #{}),
    maps:get(OwnershipId, TypeObtainRecordMap, []).

%% 根据红包id获取红包(不推荐使用)
get_red_envelopes_by_id(RedEnvelopesId) ->
    RedEnvelopesMap = get_red_envelopes_map(),
    List = maps:fold(fun(_Key, Val, AccList) ->
        AccList ++ maps:values(Val)
    end, [], RedEnvelopesMap),
    lists:keyfind(RedEnvelopesId, #red_envelopes.id, lists:flatten(List)).

get_red_envelopes(OwnershipType, OwnershipId, RedEnvelopesId) ->
    RedEnvelopesMap = get_red_envelopes_map(),
    Map = maps:get(OwnershipType, RedEnvelopesMap, #{}),
    List = maps:get(OwnershipId, Map, []),
    lists:keyfind(RedEnvelopesId, #red_envelopes.id, List).

%% 红包获得记录的最新id 不进数据库在自己进程维护就行
get_obtain_record_new_id() ->
    case get("obtain_record_last_id") of
        undefined ->
            LastId = 1,
            put("obtain_record_last_id", LastId),
            LastId;
        LastId ->
            put("obtain_record_last_id", LastId + 1),
            LastId + 1
    end.

get_times_limit(Type, CfgId) ->
    case Type of
        ?MOD_RED_ENVELOPES_TRIGGER ->
            case data_red_envelopes:get(CfgId) of
                #red_envelopes_cfg{trigger_times = TimesLim} ->
                    TimesLim;
                _ -> 0
            end;
        ?MOD_RED_ENVELOPES_GOODS ->
            case data_red_envelopes:get_goods_cfg(CfgId) of
                #red_envelopes_goods_cfg{times_lim = TimesLim} ->
                    TimesLim;
                _ -> 0
            end;
        _ -> 0
    end.

%% Map里增加新的红包
add_red_envelopes(RedEnvelopes) ->
    #red_envelopes{
        ownership_type = OwnershipType, ownership_id = OwnershipId
    } = RedEnvelopes,
    RedEnvelopesMap = get_red_envelopes_map(),
    OneTypeMap = maps:get(OwnershipType, RedEnvelopesMap, #{}),
    List = maps:get(OwnershipId, OneTypeMap, []),
    NewOneTypeMap = maps:put(OwnershipId, [RedEnvelopes|List], OneTypeMap),
    NewRedEnvelopesMap = maps:put(OwnershipType, NewOneTypeMap, RedEnvelopesMap),
    save_red_envelopes_map(NewRedEnvelopesMap).

%% 增加红包获得记录
add_obtain_record(RedEnvelopes) ->
    #red_envelopes{
        ownership_type = OwnershipType, owner_id = OwnerId,
        ownership_id = OwnershipId, extra = Extra
    } = RedEnvelopes,
    #figure{name = OwnerName} = lib_role:get_role_figure(OwnerId),
    Nowtime = utime:unixtime(),
    AutoId = get_obtain_record_new_id(),
    AddRecord = lib_red_envelopes_mod:make_record(obtain_record, [AutoId, OwnerId, OwnerName, Extra, Nowtime]),
    ObtainRecordMap = get_obtain_record_map(),
    OneTypeMap = maps:get(OwnershipType, ObtainRecordMap, #{}),
    List = maps:get(OwnershipId, OneTypeMap, []),
    NewOneTypeMap = maps:put(OwnershipId, lists:sublist([AddRecord|List], ?OBTAIN_RECORD_LEN), OneTypeMap),
    NewObtainRecordMap = maps:put(OwnershipType, NewOneTypeMap, ObtainRecordMap),
    save_obtain_record_map(NewObtainRecordMap).

del_obtain_record(OwnershipType, OwnershipId) ->
    ObtainRecordMap = get_obtain_record_map(),
    OneTypeMap = maps:get(OwnershipType, ObtainRecordMap, #{}),
    NewOneTypeMap = maps:without([OwnershipId], OneTypeMap),
    NewObtainRecordMap = maps:put(OwnershipType, NewOneTypeMap, ObtainRecordMap),
    save_obtain_record_map(NewObtainRecordMap).

%% 未发送列表
add_nosend_red_envelopes(RedEnvelopes) ->
    #red_envelopes{
        id= Id, owner_id = OwnerId, ownership_type = _OwnershipType, ownership_id = _OwnershipId
    } = RedEnvelopes,
    NoSendMap = get_red_envelopes_nosend(),
    NoSendList = maps:get(OwnerId, NoSendMap, []),
    NewNoSendMap = maps:put(OwnerId, [Id|NoSendList], NoSendMap),
    ?PRINT("add_nosend_red_envelopes ~p~n", [NewNoSendMap]),
    save_red_envelopes_nosend(NewNoSendMap).

delete_nosend_red_envelopes(RedEnvelopes) ->
    #red_envelopes{
        id= Id, owner_id = OwnerId
    } = RedEnvelopes,
    NoSendMap = get_red_envelopes_nosend(),
    NoSendList = maps:get(OwnerId, NoSendMap, []),
    NewNoSendList = lists:delete(Id, NoSendList),
    NewNoSendMap = maps:put(OwnerId, NewNoSendList, NoSendMap),
    ?PRINT("delete_nosend_red_envelopes ~p~n", [NewNoSendMap]),
    save_red_envelopes_nosend(NewNoSendMap).

clear_expired_nosend([]) -> ok;
clear_expired_nosend(ExpiredNoSend) ->
    NoSendMap = get_red_envelopes_nosend(),
    F = fun({OwnerId, Id}, TmpMap) ->
        NoSendList = maps:get(OwnerId, TmpMap, []),
        NewNoSendList = lists:delete(Id, NoSendList),
        maps:put(OwnerId, NewNoSendList, TmpMap)
    end,
    NewNoSendMap = lists:foldl(F, NoSendMap, ExpiredNoSend),
    save_red_envelopes_nosend(NewNoSendMap).

change_ownership_id([], GuildRedEnvelopesMap, _NewOwnerShipId) -> GuildRedEnvelopesMap;
change_ownership_id(RedEnvelopesList, GuildRedEnvelopesMap, NewOwnerShipId) ->
    NewRedEnvelopesList = [RedEnvelopes#red_envelopes{ownership_id=NewOwnerShipId} ||#red_envelopes{} = RedEnvelopes <- RedEnvelopesList],
    List = maps:get(NewOwnerShipId, GuildRedEnvelopesMap, []),
    maps:put(NewOwnerShipId, NewRedEnvelopesList++List, GuildRedEnvelopesMap).

db_insert_red_envelopes(RedEnvelopes) ->
    #red_envelopes{
        id = Id, type = Type, ownership_type = OwnershipType, ownership_id = OwnershipId,
        owner_id = OwnerId, status = Status, money = Money,
        split_num = SplitNum, extra = Extra, stime = Stime, ctime = Ctime, msg = Msg, others = Others
    } = RedEnvelopes,
    db:execute(io_lib:format(?sql_insert_red_envelopes,
        [Id, Type, OwnershipType, OwnershipId, OwnerId, Status, Money, SplitNum, Extra, Stime, Ctime, Msg, util:term_to_bitstring(Others)])).

db_delete_red_envelopes_by_ids(DelList) ->
    DelResEnvelopesIds = [Id ||#red_envelopes{id = Id} <- DelList],
    case DelResEnvelopesIds == [] of 
        true -> ok;
        _ ->
            Sql = io_lib:format(?sql_del_red_envelopes_by_ids, [ulists:list_to_string(DelResEnvelopesIds, ",")]),
            db:execute(Sql)
    end.

db_update_red_envelopes_ownership(RedEnvelopesList, NewOwnerShipId) ->
    EnvelopesIds = [Id ||#red_envelopes{id = Id} <- RedEnvelopesList],
    case EnvelopesIds == [] of 
        true -> ok;
        _ ->
            Sql = io_lib:format(?sql_update_red_envelopes_ownership, [NewOwnerShipId, ulists:list_to_string(EnvelopesIds, ",")]),
            db:execute(Sql)
    end.

db_delete_red_envelopes_record_by_ownership_id(OwnershipId) ->
    Sql = io_lib:format(?sql_del_red_envelopes_record_by_ownership_id, [OwnershipId]),
    db:execute(Sql).