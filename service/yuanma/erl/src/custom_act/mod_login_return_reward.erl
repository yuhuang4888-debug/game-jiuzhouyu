%%-----------------------------------------------------------------------------
%% @Module  :       mod_login_return_reward
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-05-08
%% @Description:    登录返还有礼(0元豪礼)
%%-----------------------------------------------------------------------------
-module(mod_login_return_reward).

-include("custom_act.hrl").
-include("login_return_reward.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
% -include("goods.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    send_act_info/3
    , check_buy/4
    , buy/8
    , check_receive_reward/4
    , receive_reward/5
    , act_end/2
    , gm_act_end/3
    , daily_clear/1
]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Sql = io_lib:format(?sql_select_login_return_reward, []),
    List = db:get_all(Sql),
    F = fun([RoleId, SubType, Grade, BuyTime, ReceiveTime, Utime], AccMap) ->
        Key = {SubType, Grade},
        RoleInfo = #role_info{
            key = Key,
            role_id = RoleId,
            buy_time = BuyTime,
            receive_time = ReceiveTime,
            utime = Utime
        },
        RoleInfoL = maps:get(RoleId, AccMap, []),
        NewRoleInfoL = lists:keystore(Key, #role_info.key, RoleInfoL, RoleInfo),
        maps:put(RoleId, NewRoleInfoL, AccMap)
        end,
    RoleMap = lists:foldl(F, #{}, List),
    State = #act_state{role_map = RoleMap},
    {ok, State}.

send_act_info(RoleId, RoleLv, SubType) ->
    gen_server:cast(?MODULE, {'send_act_info', RoleId, RoleLv, ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType}).

buy(RoleId, RoleName, RoleLv, SubType, GradeId, CostL, RewardCfg, RewardL) ->
    gen_server:cast(?MODULE, {'buy', RoleId, RoleName, RoleLv, ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType, GradeId, CostL, RewardCfg, RewardL}).

receive_reward(RoleId, RoleLv, SubType, GradeId, RewardL) ->
    gen_server:cast(?MODULE, {'receive_reward', RoleId, RoleLv, ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType, GradeId, RewardL}).

act_end(EndType, ActInfo) ->
    gen_server:cast(?MODULE, {'act_end', EndType, ActInfo}).

gm_act_end(SubType, STime, EndTime) ->
    ActInfo = #act_info{key = {?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType}, stime = STime, etime = EndTime},
    gen_server:cast(?MODULE, {'act_end', ?CUSTOM_ACT_STATUS_CLOSE, ActInfo}).

daily_clear(_DelaySec) ->
    gen_server:cast(?MODULE, {'daily_clear'}).

check_buy(RoleId, RoleLv, SubType, GradeId) ->
    gen_server:call(?MODULE, {'check_buy', RoleId, RoleLv, ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType, GradeId}, 1000).

check_receive_reward(RoleId, RoleLv, SubType, GradeId) ->
    gen_server:call(?MODULE, {'check_receive_reward', RoleId, RoleLv, ?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType, GradeId}, 1000).

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

%% 获取活动界面信息
do_handle_cast({'send_act_info', RoleId, RoleLv, Type, SubType}, State) ->
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
        #custom_act_cfg{condition = ActCondition} ->
            {expire_show, IsExpireShow} = ulists:keyfind(expire_show, 1, ActCondition, {expire_show, 0});
        _ ->
            IsExpireShow = 0
    end,
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, ActInfo, BuyDayLim} ->
            #act_state{role_map = RoleMap} = State,
            #act_info{stime = Stime, etime = Etime} = ActInfo,
            AllGradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            F = fun(GradeId, Acc) ->
                case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                    #custom_act_reward_cfg{name = Name, desc = Desc, condition = Condition, format = FormatType, reward = RewardL} ->
                        case lists:keyfind(receive_day, 1, Condition) of
                            {receive_day, ReceiveDay} ->
                                case lists:keyfind({SubType, GradeId}, #role_info.key, RoleInfoL) of
                                    #role_info{buy_time = BuyTime, receive_time = 0, utime = Utime} when BuyTime > 0 andalso Utime >= Stime andalso Utime < Etime -> %% 买了未领取 注: 不在这次活动期间的数据过滤掉
                                        Status = ?REWARD_STATUS_HAS_BUY,
                                        CanReceiveTime = BuyTime + ReceiveDay * ?ONE_DAY_SECONDS - utime:get_seconds_from_midnight(BuyTime),
                                        [{GradeId, FormatType, Status, CanReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                    #role_info{buy_time = BuyTime, receive_time = _ReceiveTime, utime = Utime} when BuyTime > 0 andalso Utime >= Stime andalso Utime < Etime -> %% 买了已经领取 注: 不在这次活动期间的数据过滤掉
                                        % Status = ?REWARD_STATUS_HAS_RECEIVE,
                                        % CanReceiveTime = ReceiveTime,    % 返利时间
                                        case IsExpireShow == 1 of 
                                            true -> 
                                                Status = ?REWARD_STATUS_HAS_RECEIVE,
                                                [{GradeId, FormatType, Status, _ReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                            false -> Acc
                                        end;
%%                                        [{GradeId, FormatType, Status, CanReceiveTime, Name, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                    #role_info{utime = Utime} when Utime < Stime orelse Utime > Etime ->
                                        case (NowTime - Stime) div ?ONE_DAY_SECONDS < BuyDayLim of
                                            true ->
                                                Status = ?REWARD_STATUS_NOT_BUY,
                                                CanReceiveTime = 0,
                                                [{GradeId, FormatType, Status, CanReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                            false when IsExpireShow == 1 -> %% 过期了过了购买时间还要展示
                                                Status = ?REWARD_STATUS_NOT_BUY,
                                                CanReceiveTime = 0,
                                                [{GradeId, FormatType, Status, CanReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                            _ -> %% 买了过了购买时间
                                                Acc
                                        end;
                                    false -> %% 没有买
                                        case (NowTime - Stime) div ?ONE_DAY_SECONDS < BuyDayLim of
                                            true ->
                                                Status = ?REWARD_STATUS_NOT_BUY,
                                                CanReceiveTime = 0,
                                                [{GradeId, FormatType, Status, CanReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                            false when IsExpireShow == 1 -> %% 过期了过了购买时间还要展示
                                                Status = ?REWARD_STATUS_NOT_BUY,
                                                CanReceiveTime = 0,
                                                [{GradeId, FormatType, Status, CanReceiveTime, Name, Desc, util:term_to_string(Condition), util:term_to_string(RewardL)} | Acc];
                                            _ ->   %  没买过了购买时间
                                                Acc
                                        end;
                                    _ ->
                                        Acc
                                end;
                            _ ->
                                Acc
                        end;
                    _ ->
                        Acc
                end
                end,
            PackL = lists:foldl(F, [], AllGradeIds),
            % ?MYLOG("cxd_zero", "PackL:~p", [PackL]),
            lib_server_send:send_to_uid(RoleId, pt_331, 33136, [?SUCCESS, SubType, PackL]);
        {false, ErrCode} ->
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]);
        _ ->
            skip
    end,
    {ok, State};

do_handle_cast({'buy', RoleId, RoleName, RoleLv, Type, SubType, GradeId, CostL, _RewardCfg, RewardL}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, ActInfo, BuyDayLim} ->
            #act_info{stime = Stime} = ActInfo,
            case (NowTime - Stime) div ?ONE_DAY_SECONDS < BuyDayLim of
                true ->
                    #act_state{role_map = RoleMap} = State,
                    RoleInfoL = maps:get(RoleId, RoleMap, []),
                    NewRoleInfo = #role_info{
                        key = {SubType, GradeId},
                        role_id = RoleId,
                        buy_time = NowTime,
                        utime = NowTime
                    },
                    save_role_info(NewRoleInfo),
                    NewRoleInfoL = [NewRoleInfo | lists:keydelete({SubType, GradeId}, #role_info.key, RoleInfoL)],
                    NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
                    %% 发奖励给玩家
                    lib_goods_api:send_reward_by_id(RewardL, login_return_reward_buy, 0, RoleId, 1),
                    %% 日志
                    lib_log_api:log_login_return_reward(RoleId, SubType, GradeId, 1, CostL, RewardL),
                    %% 传闻  触发传闻  绑定返还
%%                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 15, [RoleName, RoleId, lib_custom_act_api:get_act_name(Type, SubType), RewardCfg#custom_act_reward_cfg.name]),
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 21, [RoleName, RoleId, lib_custom_act_api:get_act_name(Type, SubType), Type, SubType]),
                    NewState = State#act_state{role_map = NewRoleMap},
                    lib_server_send:send_to_uid(RoleId, pt_331, 33137, [?SUCCESS, GradeId, SubType]);
                _ ->
                    NewState = State,
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_not_in_buy_day)])
            end;
        {false, ErrCode} ->
            NewState = State,
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode]);
        _ -> NewState = State
    end,
    {ok, NewState};

do_handle_cast({'receive_reward', RoleId, RoleLv, Type, SubType, GradeId, RewardL}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, _ActInfo, _BuyDayLim} ->
            % #act_info{stime = Stime} = ActInfo,
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            case lists:keyfind({SubType, GradeId}, #role_info.key, RoleInfoL) of
                RoleInfo when is_record(RoleInfo, role_info) ->
                    NewRoleInfo = RoleInfo#role_info{
                        receive_time = NowTime,
                        utime = NowTime
                    },
                    save_role_info(NewRoleInfo),
                    NewRoleInfoL = [NewRoleInfo | lists:keydelete({SubType, GradeId}, #role_info.key, RoleInfoL)],
                    NewRoleMap = maps:put(RoleId, NewRoleInfoL, RoleMap),
                    %% 发奖励给玩家
                    lib_goods_api:send_reward_by_id(RewardL, login_return_reward_return, 0, RoleId, 1),
                    %% 日志
                    lib_log_api:log_login_return_reward(RoleId, SubType, GradeId, 2, [], RewardL),
                    NewState = State#act_state{role_map = NewRoleMap},
                    lib_server_send:send_to_uid(RoleId, pt_331, 33138, [?SUCCESS, GradeId, SubType]);
                _ ->
                    NewState = State,
                    lib_server_send:send_to_uid(RoleId, pt_331, 33100, [?ERRCODE(err331_act_can_not_get)])
            end;
        {false, ErrCode} ->
            NewState = State,
            lib_server_send:send_to_uid(RoleId, pt_331, 33100, [ErrCode])
    end,
    {ok, NewState};

do_handle_cast({'act_end', EndType, #act_info{key = {_Type, SubType}} = ActInfo}, State) ->
    db:execute(io_lib:format(?sql_delete_login_return_reward, [SubType])),
    #act_state{role_map = RoleMap} = State,
    case EndType of
        ?CUSTOM_ACT_STATUS_CLOSE ->
            spawn(fun() ->
                timer:sleep(60 * 1000),
                auto_send_unreceive_reward(maps:to_list(RoleMap), [ActInfo])
                  end);
        _ -> skip
    end,
    F = fun(_Key, RoleInfoL) ->
        [
            T || T <- RoleInfoL,
            begin case T#role_info.key of
                      {SubType, _} -> false;
                      _ -> true
                  end
            end
        ]
        end,
    NewRoleMap = maps:map(F, RoleMap),
    NewState = State#act_state{role_map = NewRoleMap},
    {ok, NewState};

do_handle_cast({'daily_clear'}, State) ->
    % NowTime = utime:unixtime(),
    % EggsL = [#egg_info{id = Index} || Index <- lists:seq(1, ?EGG_NUM)],
    % EggArgs = [{Id, Status, GoodsId, GoodsNum, Effect} || #egg_info{id = Id, status = Status, goods_id = GoodsId, goods_num = GoodsNum, effect = Effect} <- EggsL],
    % db:execute(io_lib:format(?sql_reset_smashed_egg, [0, 0, 0, 0, 0, util:term_to_string(EggArgs), NowTime])),
    % #act_state{role_map = RoleMap} = State,
    % F1 = fun(RoleInfo) ->
    %     RoleInfo#role_info{
    %         online_time = 0,
    %         lfree_smashed_time = NowTime,
    %         refresh_times = 0,
    %         add_refresh_times = 0,
    %         free_smashed_times = 0,
    %         eggs = EggsL,
    %         utime = NowTime
    %     }
    % end,
    % F = fun(_RoleId, RoleInfoL) ->
    %     lists:map(F1, RoleInfoL)
    % end,
    % NewRoleMap = maps:map(F, RoleMap),
    % NewState = State#act_state{role_map = NewRoleMap},
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} when is_record(NewState, act_state) ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'check_buy', RoleId, RoleLv, Type, SubType, GradeId}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, #act_info{stime = Stime, etime = Etime} = ActInfo, BuyDayLim} ->
            case (NowTime - Stime) div ?ONE_DAY_SECONDS < BuyDayLim of
                true ->
                    #act_state{role_map = RoleMap} = State,
                    RoleInfoL = maps:get(RoleId, RoleMap, []),
                    RoleInfo = lists:keyfind({SubType, GradeId}, #role_info.key, RoleInfoL),
                    HasBuy = case RoleInfo of
                                 false -> false;
                                 #role_info{utime = Utime} when Utime < Stime orelse Utime > Etime ->
                                     false; %% 过期的数据视为未购买
                                 _ -> true
                             end,
                    case HasBuy of
                        false ->
                            case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                                #custom_act_reward_cfg{condition = Condition} = RewardCfg ->
                                    case lists:keyfind(lv, 1, Condition) of
                                        {lv, BuyNeedLv} -> skip;
                                        _ -> BuyNeedLv = 0
                                    end,
                                    case lists:keyfind(cost, 1, Condition) of
                                        {cost, BuyNeedCost} -> skip;
                                        _ -> BuyNeedCost = []
                                    end,
                                    case RoleLv >= BuyNeedLv of
                                        true ->
                                            {ok, {ok, BuyNeedCost, ActInfo, RewardCfg}};
                                        _ ->
                                            {ok, {false, ?ERRCODE(err331_act_can_not_get)}}
                                    end;
                                _ -> {ok, {false, ?ERRCODE(err_config)}}
                            end;
                        _ ->
                            {ok, {false, ?ERRCODE(err331_login_return_reward_has_buy)}}
                    end;
                _ ->
                    {ok, {false, ?ERRCODE(err331_not_in_buy_day)}}
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

do_handle_call({'check_receive_reward', RoleId, RoleLv, Type, SubType, GradeId}, State) ->
    NowTime = utime:unixtime(),
    case check_act(Type, SubType, RoleLv, NowTime) of
        {true, #act_info{stime = Stime, etime = Etime} = _ActInfo, _BuyDayLim} ->
            #act_state{role_map = RoleMap} = State,
            RoleInfoL = maps:get(RoleId, RoleMap, []),
            case lists:keyfind({SubType, GradeId}, #role_info.key, RoleInfoL) of
                #role_info{buy_time = BuyTime, receive_time = ReceiveTime, utime = Utime}
                    when BuyTime > 0 andalso ReceiveTime == 0 andalso Utime >= Stime andalso Utime < Etime -> %% 在活动期间购买了才能领取
                    case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
                        #custom_act_reward_cfg{condition = Condition} ->
                            case lists:keyfind(return_reward, 1, Condition) of
                                {return_reward, ReturnRewardL} ->
                                    {ok, {ok, ReturnRewardL}};
                                _ -> {ok, {false, ?ERRCODE(err_config)}}
                            end;
                        _ -> {ok, {false, ?ERRCODE(err_config)}}
                    end;
                #role_info{buy_time = 0} ->
                    {ok, {false, ?ERRCODE(err331_act_can_not_get)}};
                false ->
                    {ok, {false, ?ERRCODE(err331_act_can_not_get)}};
                #role_info{receive_time = ReceiveTime, utime = Utime} when ReceiveTime > 0 andalso Utime >= Stime andalso Utime < Etime ->
                    {ok, {false, ?ERRCODE(err331_already_get_reward)}};
                _ ->
                    {false, ?FAIL}
            end;
        {false, ErrCode} -> {ok, {false, ErrCode}};
        _ -> {ok, {false, ?FAIL}}
    end;

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

check_act(Type, SubType, RoleLv, NowTime) ->
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{etime = Etime} = ActInfo when NowTime < Etime ->
            case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                #custom_act_cfg{
                    condition = Condition
                } ->
                    ?PRINT("Condition ~p-------~n", [Condition]),
                    case lib_custom_act_check:check_act_condtion([role_lv, buy_day], Condition) of
                        [OpenLv, BuyDayLim] when RoleLv >= OpenLv ->
                            {true, ActInfo, BuyDayLim};
                        [_OpenLv, _BuyTime] -> {false, ?ERRCODE(lv_limit)};
                        _ -> {false, ?ERRCODE(err_config)}
                    end;
                _ -> {false, ?ERRCODE(err_config)}
            end;
        false -> {false, ?ERRCODE(err331_act_closed)}
    end.

% make_role_info(Type, SubType, RoleId, NowTime) ->
%     AllGradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
%     Sql = usql:replace(player_login_return_reward, [role_id, subtype, grade, time], [{RoleId, SubType, GradeId, NowTime} || GradeId <- AllGradeIds]),
%     db:execute(Sql),
%     [#role_info{key = {SubType, GradeId}, role_id = RoleId, utime = NowTime} || GradeId <- AllGradeIds].

% make_role_info(Type, SubType, RoleId, GradeId, NowTime) ->
%     RoleInfo = #role_info{
%         key = {SubType, GradeId},
%         role_id = RoleId,
%         buy_time = NowTime,
%         utime = NowTime
%     },
%     save_role_info(RoleInfo),
%     RoleInfo.

save_role_info(RoleInfo) ->
    #role_info{
        key = {SubType, GradeId},
        role_id = RoleId,
        buy_time = BuyTime,
        receive_time = ReceiveTime,
        utime = Utime
    } = RoleInfo,
    Sql = io_lib:format(?sql_save_login_return_reward,
        [RoleId, SubType, GradeId, BuyTime, ReceiveTime, Utime]),
    db:execute(Sql).

auto_send_unreceive_reward([], _) -> skip;
auto_send_unreceive_reward([{RoleId, RoleInfoL} | L], ActInfoL) ->
    F = fun(T, {LogArgs, Acc}) ->
        case T of
            #role_info{key = {SubType, GradeId}, buy_time = BuyTime, receive_time = ReceiveTime, utime = Utime} when BuyTime > 0 andalso ReceiveTime == 0 ->
                case lists:keyfind({?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType}, #act_info.key, ActInfoL) of
                    #act_info{stime = Stime, etime = Etime} when Utime >= Stime andalso Utime < Etime ->
                        case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_LOGIN_RETURN_REWARD, SubType, GradeId) of
                            #custom_act_reward_cfg{condition = Condition} ->
                                case lists:keyfind(return_reward, 1, Condition) of
                                    {return_reward, ReturnRewardL} ->
                                        {[{SubType, GradeId, ReturnRewardL} | LogArgs], ReturnRewardL ++ Acc};
                                    _ -> {LogArgs, Acc}
                                end;
                            _ -> {LogArgs, Acc}
                        end;
                    _ -> {LogArgs, Acc}
                end;
            _ -> {LogArgs, Acc}
        end
        end,
    {LogArgs, AllRewardL} = lists:foldl(F, {[], []}, RoleInfoL),
    case AllRewardL =/= [] of
        true ->
            LastAllRewardL = ulists:object_list_merge(AllRewardL),
%%            ?PRINT("0 yuan ======================LastAllRewardL:~p~n",[LastAllRewardL]),
            lib_mail_api:send_sys_mail([RoleId], utext:get(3310022), utext:get(3310023), LastAllRewardL),
            log_auto_send_unreceive_reward(LogArgs, RoleId),
            timer:sleep(100);
        false -> skip
    end,
    auto_send_unreceive_reward(L, ActInfoL).

log_auto_send_unreceive_reward([], _) -> ok;
log_auto_send_unreceive_reward([{SubType, GradeId, ReturnRewardL} | L], RoleId) ->
    lib_log_api:log_login_return_reward(RoleId, SubType, GradeId, 3, [], ReturnRewardL),
    log_auto_send_unreceive_reward(L, RoleId).