%% ---------------------------------------------------------------------------
%% @doc lib_beta_login
%% @author
%% @since  2019-08-30
%% @deprecated 封测登陆活动
%% ---------------------------------------------------------------------------
-module(lib_beta_login).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("common.hrl").

-define(SQL_SELECT_LOCAL_DATA,  <<"SELECT `id`,`old_lv`,`time` FROM `beta_login_local` WHERE `accid` = ~p AND `accname` = '~s'">>).
-define(SQL_REPLACE_LOCAL_DATA, <<"REPLACE INTO `beta_login_local`(`accid`,`accname`,`id`,`old_lv`,`time`) VALUES (~p,'~s',~p,~p,~p)">>).

-define(SQL_SELECT_CLUSTER_DATA,  <<"SELECT `award_state`, `old_lv`, `time` FROM `beta_login_cluster` WHERE `accid` = ~p AND `accname` = '~s'">>).
-define(SQL_UPDATE_CLUSTER_DATA,  <<"UPDATE beta_login_cluster SET `award_state` = 1, `server_id`=~p, `player_id`=~p, `time`=~p WHERE `accid` = ~p AND `accname`='~s'">>).
-define(SQL_REPLACE_CLUSTER_DATA, <<"REPLACE INTO `beta_login_cluster` (`accid`, `accname`, `award_state`, `old_lv`, `server_id`, `player_id`, `time`)
                VALUES (~p,'~s',~p,~p,~p,~p,~p)">>).


-define(KEY, beta_login).

-record(beta_data_loacal, {
    is_sync = 0,
    id = 0,
    old_lv = 0,
    time = 0
}).

-export([
    login/1,
    logout/1,
    update_player_info/2,
    act_end/2,
    act_end/3,
    set_center_data/2,
    request_beta_data/4,
    data_come_back/2,
    gm_compare/0
]).

login(PS) ->
    % ?PRINT("========= BetaData:~p~n",[PS#player_status.beta_data]),
    #player_status{accid = Accid, accname = AccName, beta_data = BetaData} = PS,
    case BetaData of
        #beta_data{data = DataMap} -> NewBetaData = BetaData;
        _ ->
            DataMap = #{},
            NewBetaData = #beta_data{data = DataMap}
    end,
    BetaLocal = case db:get_row(io_lib:format(?SQL_SELECT_LOCAL_DATA, [Accid, AccName])) of
                    [Id, OldLv, Time] ->
                        #beta_data_loacal{is_sync = 1, id = Id, old_lv = OldLv, time = Time};
                    _ ->
                        #beta_data_loacal{}
                end,
    NewMap = maps:put(?KEY, BetaLocal, DataMap),
    NewPS = PS#player_status{beta_data = NewBetaData#beta_data{data = NewMap}},
    get_reward_status(NewPS, ?CUSTOM_ACT_TYPE_BETA_REWARD, 1),
    NewPS.

logout(PS) ->
    % ?PRINT("============== logout~n",[]),
    IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_BETA_RECORD, 1),
    case IsOpen of
        true ->
            replace_center_data(PS, ?CUSTOM_ACT_TYPE_BETA_RECORD, 1);
        _ -> skip
    end,
    {ok, PS}.

replace_center_data(PS, Type, SubType) ->
    #player_status{id = RoleId, source = Source, accid = Accid, accname = AccName, figure = #figure{lv = RoleLv}} = PS,
    IsReferenceSource = judge_source(Type, SubType, Source),
    % ?PRINT("============== IsReferenceSource:~p,Source:~p~n",[IsReferenceSource, Source]),
    case IsReferenceSource of
        true ->
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_BETA_RECORD, 1) of
                #custom_act_cfg{condition = Condition} -> Condition;
                _ -> Condition = []
            end,
            case lists:keyfind(login_lv, 1, Condition) of
                {_, LoginLimitLv} when is_integer(LoginLimitLv) andalso RoleLv > LoginLimitLv ->
                    lib_log_api:log_beta_login_record(Accid, AccName, RoleId, RoleLv, Source),
                    mod_clusters_node:apply_cast(lib_beta_login, set_center_data, [replace, [Accid, AccName, RoleLv]]);
                _ -> skip
            end;
        _ -> skip
    end.

gm_compare() ->
    Type = ?CUSTOM_ACT_TYPE_BETA_RECORD, SubType = 1,
    case lib_custom_act_api:is_open_act(Type, SubType) of
        true ->
            List = db:get_all(io_lib:format(<<"select `id`, `accid`, `accname`, `source` from `player_login`">>, [])),
            lib_beta_recharge_return:gm_udpate_record(List),
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{condition = Condition} -> Condition;
                _ -> Condition = []
            end,
            case lists:keyfind(login_lv, 1, Condition) of
                {_, LoginLimitLv} when is_integer(LoginLimitLv) -> skip;
                _ -> LoginLimitLv = 9999
            end,
            Fun = fun([RoleId, Accid, AccName, Source], Acc) ->
                case judge_source(Type, SubType, Source) of
                    true ->
                        case db:get_row(io_lib:format(<<"select `lv` from `player_low` where id=~w  limit 1">>, [RoleId])) of
                            [RoleLv] when LoginLimitLv =< RoleLv ->
                                lib_log_api:log_beta_login_record(Accid, AccName, RoleId, RoleLv, Source),
                                case lists:keyfind({Accid, AccName}, 1, Acc) of
                                    {_, _, OldLv} when OldLv >= RoleLv -> Acc;
                                    _ ->
                                        lists:keystore({Accid, AccName}, 1, Acc, {{Accid, AccName}, RoleLv})
                                end;
                            _ ->  Acc
                        end;
                    _ -> Acc
                end
                  end,
            NeedUpdateList = lists:foldl(Fun, [], List),
            mod_clusters_node:apply_cast(lib_beta_login, set_center_data, [gm_replace, NeedUpdateList]);
        _ ->
            skip
    end,
    ok.



act_end(Type, SubType) when Type == ?CUSTOM_ACT_TYPE_BETA_RECORD ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_beta_login, act_end, [Type, SubType]) || E <- OnlineRoles];
act_end(_, _) -> skip.

act_end(PS, Type, SubType) ->
    replace_center_data(PS, Type, SubType),
    {ok, PS}.

%% 上传数据到跨服中心
set_center_data(OperationType, Data) ->
    Now = utime:unixtime(),
    % ?PRINT("============== OperationType:~p~n",[OperationType]),
    case OperationType of
        replace ->
            case Data of
                [Accid, AccName, RoleLv] ->
                    case db:get_row(io_lib:format(?SQL_SELECT_CLUSTER_DATA, [Accid, AccName])) of
                        [_, OldLv, _] when RoleLv < OldLv -> skip;
                        _ ->  db:execute(io_lib:format(?SQL_REPLACE_CLUSTER_DATA, [Accid, AccName, 0, RoleLv, 0, 0, Now]))
                    end;
                _ ->
                    skip
            end;
        update ->
            case Data of
                [ServerId, RoleId, Accid, AccName] ->
                    db:execute(io_lib:format(?SQL_UPDATE_CLUSTER_DATA, [ServerId, RoleId, Now, Accid, AccName]));
                _ ->
                    skip
            end;
        gm_replace ->
            DbList = [[Accid, AccName, 0, RoleLv, 0, 0, Now] || {{Accid, AccName}, RoleLv} <- Data],
            Sql = usql:replace(beta_login_cluster, [accid, accname, award_state, old_lv, server_id, player_id, time], DbList),
            DbList =/= [] andalso db:execute(Sql);
        _ -> skip
    end.

%% 获取活动数据
get_reward_status(PS, Type, 1) when Type == ?CUSTOM_ACT_TYPE_BETA_REWARD ->
    #player_status{id = RoleId, source = Source, accid = Accid, accname = AccName, beta_data = #beta_data{data = DataMap}} = PS,
    case maps:get(?KEY, DataMap, []) of
        #beta_data_loacal{is_sync = IsSync} ->
            IsActOpen = lib_custom_act_api:is_open_act(Type, 1),
            IsReferenceSource = judge_source(Type, 1, Source),
            % ?PRINT("@@@@@@@@ IsReferenceSource:~p,IsSync:~p,IsActOpen:~p,Source:~p~n",[IsReferenceSource, IsSync, IsActOpen,Source]),
            if
                IsReferenceSource == false -> skip;
                IsSync == 0 andalso IsActOpen == true ->
                    % ?PRINT("@@@@@@@@@ get_reward_status~n",[]),
                    GameNode = node(),
                    mod_clusters_node:apply_cast(lib_beta_login, request_beta_data, [GameNode, Accid, AccName, RoleId]);
                IsSync == 0 -> skip;
                true ->
                    skip
            end;
        _ ->
            skip
    end;
get_reward_status(_, _, _) -> skip.

request_beta_data(GameNode, Accid, AccName, RoleId) ->
    % ?PRINT("@@@@@@@@@ request_beta_data~n",[]),
    case db:get_row(io_lib:format(?SQL_SELECT_CLUSTER_DATA, [Accid, AccName])) of
        [RewardState, OldLv, Time] -> skip;
        _ -> RewardState = RoleId, OldLv = 0, Time = 0 % 跨服中没有该平台账号数据，设置奖励状态为RoleId（非0）使得不能触发奖励
    end,
    % ?PRINT("@@@@@@@@@ RewardState:~p~n",[RewardState]),
    LoacalData = #beta_data_loacal{is_sync = 1, id = RewardState, old_lv = OldLv, time = Time},
    mod_clusters_center:apply_cast(GameNode, lib_beta_login, data_come_back, [RoleId, LoacalData]),
    ok.

data_come_back(RoleId, LoacalData) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_beta_login, update_player_info, [LoacalData]).

update_player_info(PS, DataLocal) ->
    #player_status{accid = Accid, accname = AccName, beta_data = #beta_data{data = DataMap} = BetaData} = PS,
    NewDataLocal = send_reward(PS, DataLocal),
    NewMap = maps:put(?KEY, NewDataLocal, DataMap),
    db_replace(Accid, AccName, NewDataLocal),
    PS#player_status{beta_data = BetaData#beta_data{data = NewMap}}.

send_reward(PS, DataLocal) ->
    #player_status{id = RoleId, source = Source, accid = Accid, accname = AccName, server_id = ServerId} = PS,
    #beta_data_loacal{is_sync = 1, id = RewardState} = DataLocal,
    if
        RewardState == 0 ->
            % ?PRINT("@@@@@@@@@@@@@ ~n",[]),
            case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_BETA_REWARD, 1) of
                #custom_act_cfg{condition = Condition} -> Condition;
                _ -> Condition = []
            end,
            case lists:keyfind(login_reward, 1, Condition) of
                {login_reward, Reward} ->
                    {Title, Content} = get_mail_info(),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward),
                    lib_log_api:log_beta_login_reward(Accid, AccName, RoleId, Source),
                    mod_clusters_node:apply_cast(lib_beta_login, set_center_data, [update, [ServerId, RoleId, Accid, AccName]]),
                    DataLocal#beta_data_loacal{id = RoleId};
                _ ->
                    DataLocal
            end;
        true ->
            % ?PRINT("@@@@@@@@@@@@@ ~n",[]),
            DataLocal
    end.

db_replace(Accid, AccName, #beta_data_loacal{id = RewardState, old_lv = OldLv, time = Time}) ->
    db:execute(io_lib:format(?SQL_REPLACE_LOCAL_DATA, [Accid, AccName, RewardState, OldLv, Time]));
db_replace(_,_,_) -> skip.

judge_source(Type, SubType, Source) ->
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = Condition} -> Condition;
        _ -> Condition = []
    end,
    case lists:keyfind(source_list, 1, Condition) of
        {_, SourceList} when is_list(SourceList) -> SourceList;
        _ -> SourceList = []
    end,
    AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
    lists:member(AtomSource, SourceList).

get_mail_info() ->
    Title = utext:get(3310062),
    Content = utext:get(3310063),
    {Title, Content}.