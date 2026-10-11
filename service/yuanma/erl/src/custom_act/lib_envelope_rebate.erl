%% ---------------------------------------------------------------------------
%% @doc lib_envelope_rebate

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2022/3/7
%% @desc    红包返利功能 | 涉及到现金相关的，比较敏感，数据存储方面不走定制活动通用
%% ---------------------------------------------------------------------------
-module(lib_envelope_rebate).

%% API
-export([
      login/1
    , init_data_lv_up/1                                 % 升级事件 初始化数据
    , handle_recharge/3                                 % 充值事件 通知客户端领取情况
    , ensure_acc_first/1                                % 确认本账号下是否首个角色
    , login_day/1                                       % 登录天数
    , send_act_info/2                                   % 发送活动信息
    , envelope_withdrawal/5                             % 提现红包
    , envelope_withdrawal_callback/6                    % 提现红包HTTP消息回调
    , envelope_withdrawal_callback_offline/6            % 提现红包HTTP消息回调 角色离线处理
    , envelope_withdrawal_callback_online/5             % 提现红包HTTP消息回调 角色在线处理
    , count_reward_status/3                             % 计算奖励领取状态
    , receive_reward/4                                  % 领取奖励
    , act_end/2
]).

-export([
    test_envelope_withdrawal/0,
    gm_finish_all/1,
    gm_set_envelope/7,
    gm_fix_envelope_money/0,
    fix_envelope_money/1
]).

-include("server.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_recharge.hrl").
-include("rec_recharge.hrl").
-include("def_module.hrl").
-include("php.hrl").
-include("def_id_create.hrl").

% 返利红包物品ID
-define(ENVELOPE_GOODS_ID, 38180015).

% 红包类型
-define(ENVELOPE_TYPE_LOGIN,    1).     % 登录
-define(ENVELOPE_TYPE_RECHARGE, 2).     % 充值

-define(ENVELOPE_STATUS_NOT_USE,  0).
-define(ENVELOPE_STATUS_HAD_USE,  1).
-define(ENVELOPE_STATUS_USING,    2).
% 红包中心ID
-define(ENVELOPE_CENTER_ID,      34).
-define(ENVELOPE_MONEY(EnvelopeId), get_money(EnvelopeId)).

%% 红包返利
-record(custom_envelope_rebate, {
    is_init = 0,
    is_quality = 0,             % 是否有资格参加
    start_time = 0,             % 活动初始化时间
    end_time = 0,               % 活动初始化时间
    login_day_list = 0,         % 登录天数和当天充值的金额列表 [{LoginDay, Gold}]
    last_login_time = 0,
    login_money = 0,
    recharge_money = 0,
    login_envelope_ids = [],    % 红包ID列表 [{红包ID, 金额, 是否提现}] 0 未体现 1 已提现 2 提现中
    recharge_envelope_ids = [], % 红包ID列表 [{红包ID, 金额, 是否提现}] 0 未体现 1 已提现 2 提现中
    login_lock = 0,
    recharge_lock = 0
}).

-define(SQL_SELECT_ENVELOPE_REBATE, <<"select `is_quality`, `start_time`, `end_time`, `login_day_list`,
    `last_login_time`, `login_money`, `recharge_money`, `login_envelope_ids`, `recharge_envelope_ids`,
    `login_lock`, `recharge_lock` from `role_envelope_rebate` where `type` = ~p and `sub_type` = ~p and `role_id` = ~p">>).

-define(SQL_REPLACE_ENVELOPE_REBATE, <<"replace into `role_envelope_rebate` (`type`, `sub_type`, `role_id`, `is_quality`,
    `start_time`, `end_time`, `login_day_list`, `last_login_time`, `login_money`, `recharge_money`, `login_envelope_ids`,
     `recharge_envelope_ids`, `login_lock`, `recharge_lock`) values
    (~p, ~p, ~p, ~p, ~p, ~p, '~s', ~p, ~p, ~p, '~s', '~s', ~p, ~p)">>).

-define(DELETE_ENVELOPE_REBATE, <<"delete from `role_envelope_rebate` where `type` = ~p and `sub_type` = ~p">>).

%% 登录
login(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> init_data_info(AccPS, Type, SubType) end,
    LastPS = lists:foldl(F, PS, SubTypeList),
    LastPS.

%% 升级
init_data_lv_up(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_init_data_lv_up(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubTypeList).

do_init_data_lv_up(PS, Type, SubType) ->
    case get_data_info(PS, Type, SubType) of
        #custom_envelope_rebate{is_init = 1} -> PS;
        _ ->
            #player_status{figure = #figure{lv = Lv}} = PS,
            StartLv = get_act_start_lv(Type, SubType),
            case StartLv > Lv of
                true -> PS;
                _ ->
                    LastPS = init_data_info(PS, Type, SubType),
                    pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
                    LastPS
            end
    end.

%% 充值
handle_recharge(PS, Product, _Gold) ->
    IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
    if
        IsTrigger -> %% 只要常规充值才会触发
            Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
            SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
            F = fun(SubType, AccPS) -> do_handle_recharge(AccPS, Type, SubType) end,
            lists:foldl(F, PS, SubTypeList);
        true ->
            PS
    end.
do_handle_recharge(PS, Type, SubType) ->
    NowTime = utime:unixtime(),
    case get_data_info(PS, Type, SubType) of
        #custom_envelope_rebate{is_quality = 1, end_time = EndTime} = DataInfo when NowTime < EndTime ->
            #custom_envelope_rebate{start_time = StartTime, login_day_list = LoginDayL} = DataInfo,
            Day = utime:diff_days(StartTime, NowTime) + 1,
            Gold = lib_recharge_api:get_today_pay_gold(PS#player_status.id),
            NewLoginDayL = lists:keystore(Day, 1, LoginDayL, {Day, Gold}),
            NewDataInfo = DataInfo#custom_envelope_rebate{login_day_list = NewLoginDayL},
            LastPS = save_data_info_with_db(PS, Type, SubType, NewDataInfo),
            pp_custom_act:handle(LastPS, 33104, [Type, SubType]),
            LastPS;
        _ -> PS
    end.

%% 账号情况确认
ensure_acc_first(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_ensure_acc_first(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubTypeList).

do_ensure_acc_first(PS, Type, SubType) ->
    #player_status{figure = #figure{lv = Lv}} = PS,
    StartLv = get_act_start_lv(Type, SubType),
    case StartLv > Lv of
        true -> PS;
        _ ->
            DataInfo = get_data_info(PS, Type, SubType),
            IsQuality = ?IF(is_eligible(PS, DataInfo, Type, SubType), 1, 0),
            NewDataInfo = DataInfo#custom_envelope_rebate{is_quality = IsQuality},
            LastPS = save_data_info_with_db(PS, Type, SubType, NewDataInfo),
            pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
            LastPS
    end.

%% 登录天数
login_day(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_login_day(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubTypeList).

do_login_day(PS, Type, SubType) ->
    NowTime = utime:unixtime(),
    case get_data_info(PS, Type, SubType) of
        #custom_envelope_rebate{is_quality = 1, end_time = EndTime} = DataInfo when NowTime < EndTime ->
            #custom_envelope_rebate{login_day_list = LoginDayL, start_time = StartTime} = DataInfo,
            Day = utime:diff_days(NowTime, StartTime) + 1,
            Gold = lib_recharge_api:get_today_pay_gold(PS#player_status.id),
            NewLoginDayL = [{Day, Gold}|lists:keydelete(Day, 1, LoginDayL)],
            NewDayInfo = DataInfo#custom_envelope_rebate{login_day_list = NewLoginDayL},
            NewPS = save_data_info_with_db(PS, Type, SubType, NewDayInfo),
            pp_custom_act:handle(NewPS, 33104, [Type, SubType]),
            NewPS;
        _ -> PS
    end.


%% 发送活动信息
send_act_info(PS, #act_info{key = {Type, SubType}}) ->
    #custom_envelope_rebate{
        is_quality = IsQuality, start_time = StartTime,
        end_time = EndTime, login_money = LoginMoney, recharge_money = RechargeMoney,
        login_lock = LoginLock, recharge_lock = RechargeLock
    } = get_data_info(PS, Type, SubType),
    IsFirst1 = ?IF(get_role_withdrawal_times(PS#player_status.id, ?ENVELOPE_TYPE_LOGIN) == 0, 1, 0),
    IsFirst2 = ?IF(get_role_withdrawal_times(PS#player_status.id, ?ENVELOPE_TYPE_RECHARGE) == 0, 1, 0),
    Times1 = get_withdrawal_current_times(?ENVELOPE_TYPE_LOGIN),
    Times2 = get_withdrawal_current_times(?ENVELOPE_TYPE_RECHARGE),
    {ok, BinData} = pt_332:write(33255, [Type, SubType, IsQuality, StartTime, EndTime, LoginMoney, RechargeMoney,
        LoginLock, RechargeLock, IsFirst1, IsFirst2, Times1, Times2]),
    % ?PRINT("Type, SubType, IsQuality, StartTime, EndTime, LoginMoney, RechargeMoney, LoginLock, RechargeLock ~p ~n",
    %     [{Type, SubType, IsQuality, StartTime, EndTime, LoginMoney, RechargeMoney, LoginLock, RechargeLock}]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData).

%% 红包提现
envelope_withdrawal(PS, #act_info{key = {Type, SubType}}, WithDrawType, PackageCode, TokenId) ->
    case check_envelope_withdrawal(PS, Type, SubType, WithDrawType) of
        {true, DataInfo} ->
            #player_status{sid = Sid, id = RoleId} = PS,
            {Money, EnvelopeIds} = get_envelope_id_money(DataInfo, WithDrawType),
            F = fun({_EnvelopeId, _, Status}) -> Status == ?ENVELOPE_STATUS_NOT_USE end,
            {SatisfyEnvelopeIds, NotSatisfyEnvelopeIds} = lists:partition(F, EnvelopeIds),
            case SatisfyEnvelopeIds of
                [] ->
                    {ok, BinData} = pt_332:write(33256, [Type, SubType, ?ERRCODE(err332_rebate_withdrawal_ing), 0, 0, 0, 0]),
                    lib_server_send:send_to_sid(Sid, BinData);
                _ ->
                    F2 = fun({EId, Cents, _}, {L, Sum}) -> {[EId|L], Cents + Sum} end,
                    {WithdrawIdL, WithdrawCents} = lists:foldl(F2, {[], 0}, SatisfyEnvelopeIds),
                    %% 异步提现
                    envelope_withdrawal_core(PS, Type, SubType, PackageCode, TokenId, WithDrawType, WithdrawIdL),
                    % 发起提现请求的时候不修改acc_money 等回调处理
                    NewEnvelopeIds = [{EnvelopeId, Cents, ?ENVELOPE_STATUS_USING}||{EnvelopeId, Cents, _}<-SatisfyEnvelopeIds] ++ NotSatisfyEnvelopeIds,
                    NewDataInfo = save_envelope_id_money_lock(DataInfo, WithDrawType, Money, NewEnvelopeIds),
                    LastPS = save_data_info_with_db(PS, Type, SubType, NewDataInfo),
                    lib_log_api:log_envelope_rebate_withdrawal(Type, SubType, RoleId, WithDrawType, WithdrawIdL, WithdrawCents, 0),
                    #custom_envelope_rebate{login_money = Money1, recharge_money = Money2, login_lock = Lock1, recharge_lock = Lock2} = NewDataInfo,
                    {ok, BinData} = pt_332:write(33256, [Type, SubType, ?SUCCESS, Money1, Money2, Lock1, Lock2]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    LastPS
            end;
        {false, ErrCode} ->
            {ok, BinData} = pt_332:write(33256, [Type, SubType, ErrCode, 0, 0, 0, 0]),
            lib_server_send:send_to_sid(PS#player_status.sid, BinData)
    end.
check_envelope_withdrawal(PS, Type, SubType, WithDrawType) ->
    IsDevServer = ?IS_DEV_SERVER == true,
    IsDevp = lib_vsn:is_sy_internal_devp(),
    DataInfo = get_data_info(PS, Type, SubType),
    #custom_envelope_rebate{start_time = StartTime, is_quality = IsQuality} = DataInfo,
    {IsLock, Money, _} = get_envelope_id_money_lock(DataInfo, WithDrawType),
    % 活动开启天数（绑玩家）
    StartDay = utime:diff_days(StartTime) + 1,
    WithdrawalL = get_withdrawal_limit_day(Type, SubType, WithDrawType),
    IsSatisfy = lists:member(StartDay, WithdrawalL),
    if
        % 非开发服且非内部开发不允许提现
        IsDevp, IsDevServer == false -> {false, ?ERRCODE(err332_rebate_dev_cant)};
        IsQuality == 0 -> {false, ?ERRCODE(err332_rebate_no_in_day)};
        IsLock == 1 -> {false, ?ERRCODE(err332_rebate_withdrawal_ing)};
        Money == 0 -> {false, ?ERRCODE(err332_rebate_no_money)};
        not IsSatisfy -> {false, ?ERRCODE(err332_rebate_no_in_day)};
        true ->
            %% 判断是否首次
            IsFirst = get_role_withdrawal_times(PS#player_status.id, WithDrawType) == 0,
            case IsFirst of
                true ->
                    LimitTimes = get_withdrawal_limit_times(Type, SubType, WithDrawType),
                    CurrentTimes = get_withdrawal_current_times(WithDrawType),
                    ?IF(CurrentTimes >= LimitTimes, {false, ?ERRCODE(err332_rebate_withdrawal_limit)}, {true, DataInfo});
                _ ->
                    {true, DataInfo}
            end
    end.

envelope_withdrawal_core(PS, Type, SubType, PackageCode, TokenId, WithDrawType, WithdrawIdL) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}} = PS,
    IsDevp = lib_vsn:is_sy_internal_devp(),
    if
        %% 开发环境模拟提现情况
        ?IS_DEV_SERVER; IsDevp == true ->
            erlang:send_after(3000, self(), {'mod', ?MODULE, envelope_withdrawal_callback_online,
                [Type, SubType, WithDrawType, WithdrawIdL]});
        true ->
            PostData = [
                {package_code, PackageCode}, {tokenid, TokenId}, {main_id, ?ENVELOPE_CENTER_ID},
                {rule_ids, util:term_to_string(WithdrawIdL)}, {role_id, RoleId},
                {role_name, RoleName}, {role_level, RoleLv}, {server_id, config:get_server_num()},
                {server_name, util:get_server_name()}, {type, Type}, {subtype, SubType}
            ],
            PhpRequest = #php_request{role_id = RoleId, mfa = {?MODULE, envelope_withdrawal_callback, [Type, SubType, WithDrawType, RoleName]}},
            lib_php_api:request_register(withdraw_redapi, PostData, PhpRequest)
    end,
    ok.


%% 回调
envelope_withdrawal_callback(_PhpRequest, <<>>, _Type, _SubType, _WithDrawType, _RoleName) when is_record(_PhpRequest, php_request) -> ?ERR("~p Error:JsonData is <<>>~n", [?FUNCTION_NAME]);
envelope_withdrawal_callback(PhpRequest, JsonData, Type, SubType, WithDrawType, RoleName) when is_record(PhpRequest, php_request) ->
    #php_request{role_id = RoleId} = PhpRequest,
    case catch mochijson2:decode(JsonData) of
        {'EXIT', Error} -> ?ERR("~p Error:~p~n", [?FUNCTION_NAME, Error]);
        JsonTuple ->
            % case lib_gift_card:extract_mochijson2([<<"type">>], JsonTuple) of
            %     [_Type] -> ok;
            %     _ -> _Type = 117
            % end,
            % case lib_gift_card:extract_mochijson2([<<"subtype">>], JsonTuple) of
            %     [_SubType] -> ok;
            %     _ -> _SubType = 1
            % end,
            case lib_gift_card:extract_mochijson2([<<"rule_ids">>], JsonTuple) of
                [IdLStr] -> SuccEnvelopeIds = util:bitstring_to_term(IdLStr);
                _ -> SuccEnvelopeIds = []
            end,
            envelope_withdrawal_callback(RoleId, Type, SubType, WithDrawType, RoleName, SuccEnvelopeIds)
    end;
envelope_withdrawal_callback(RoleId, Type, SubType, WithDrawType, _RoleName, []) when is_integer(RoleId) ->
    lib_log_api:log_envelope_rebate_withdrawal(Type, SubType, RoleId, WithDrawType, [], 0, 2);
envelope_withdrawal_callback(RoleId, Type, SubType, WithDrawType, RoleName, SuccEnvelopeIds) when is_integer(RoleId) ->
    Pid = misc:get_player_process(RoleId),
    case misc:is_process_alive(Pid) of
        true ->
            gen_server:cast(Pid, {apply_cast, ?APPLY_CAST_SAVE, ?MODULE, envelope_withdrawal_callback_online,
                [Type, SubType, WithDrawType, SuccEnvelopeIds]});
        _ ->
            envelope_withdrawal_callback_offline(RoleId, Type, SubType, WithDrawType, RoleName, SuccEnvelopeIds)
    end.

envelope_withdrawal_callback_offline(RoleId, Type, SubType, WithDrawType, RoleName, SuccEnvelopeIds) ->
    Sql = io_lib:format(<<"select `login_money`, `recharge_money`, `login_envelope_ids`, `recharge_envelope_ids`
             from `role_envelope_rebate` where `type` = ~p and `sub_type` = ~p and `role_id` = ~p">>, [Type, SubType, RoleId]),
    case db:get_row(Sql) of
        [LoginMoney, LoginEnvelopeIdsStr, RechargeMoney, RechargeEnvelopeIdsStr] ->
            LoginEnvelopeIds = util:bitstring_to_term(LoginEnvelopeIdsStr),
            RechargeEnvelopeIds = util:bitstring_to_term(RechargeEnvelopeIdsStr),
            {Money, EnvelopeIds} = ?IF(WithDrawType == ?ENVELOPE_TYPE_LOGIN, {LoginMoney, LoginEnvelopeIds},
                {RechargeMoney, RechargeEnvelopeIds}),
            {NewMoney, NewEnvelopeIds} = envelope_withdrawal_callback_core(Money, EnvelopeIds, SuccEnvelopeIds),
            case WithDrawType of
                ?ENVELOPE_TYPE_LOGIN ->
                    UpdateSql = io_lib:format(<<"update `role_envelope_rebate` set `login_money` = ~p, `login_envelope_ids` = ~p
                     where `type` = ~p and `sub_type` = ~p and `role_id` = ~p">>, [NewMoney,
                        util:term_to_string(NewEnvelopeIds), Type, SubType, RoleId]);
                _ ->
                    UpdateSql = io_lib:format(<<"update `role_envelope_rebate` set `recharge_money` = ~p, `recharge_envelope_ids` = ~p
                     where `type` = ~p and `sub_type` = ~p and `role_id` = ~p">>, [NewMoney,
                        util:term_to_string(NewEnvelopeIds), Type, SubType, RoleId])
            end,
            db:execute(UpdateSql),
            mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, []}),
            %% 首次提现的玩家增加全服提现次数
            add_global_withdrawal_times(RoleId, WithDrawType),
            lib_log_api:log_envelope_rebate_withdrawal(Type, SubType, RoleId, WithDrawType, SuccEnvelopeIds, max(0, Money - NewMoney), 1);
        _ ->
            ?ERR("envelope_withdrawal_callback occor a error, RoleId ~p, Type ~p, SubType ~p SuccEnvelopeIds ~p ~n",
                [RoleId,Type,SubType,SuccEnvelopeIds])
    end.

envelope_withdrawal_callback_online(PS, Type, SubType, WithDrawType, SuccEnvelopeIds) ->
    DataInfo = get_data_info(PS, Type, SubType),
    {Money, EnvelopeIds} = get_envelope_id_money(DataInfo, WithDrawType),
    {NewMoney, NewEnvelopeIds} = envelope_withdrawal_callback_core(Money, EnvelopeIds, SuccEnvelopeIds),
    NewDataInfo = save_envelope_id_money_unlock(DataInfo, WithDrawType, NewMoney, NewEnvelopeIds),
    LastPS = save_data_info_with_db(PS, Type, SubType, NewDataInfo),
    pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, []}),
    lib_log_api:log_envelope_rebate_withdrawal(Type, SubType, PS#player_status.id, WithDrawType, SuccEnvelopeIds, max(0, Money - NewMoney), 1),
    %% 首次提现的玩家增加全服提现次数
    add_global_withdrawal_times(RoleId, WithDrawType),
    LastPS.

envelope_withdrawal_callback_core(AccMoney, EnvelopeIds, SuccEnvelopeIds) ->
    F = fun(EnvelopeId, {AccDelMoney, AccEnvelopeIds}) ->
        case lists:keyfind(EnvelopeId, 1, AccEnvelopeIds) of
            {EnvelopeId, Cents, _} ->
                NewAccEnvelopeIds = lists:keystore(EnvelopeId, 1, AccEnvelopeIds, {EnvelopeId, Cents, ?ENVELOPE_STATUS_HAD_USE}),
                NewAccDelMoney = Cents + AccDelMoney;
            _ ->
                NewAccEnvelopeIds = AccEnvelopeIds,
                NewAccDelMoney = AccDelMoney
        end,
        {NewAccDelMoney, NewAccEnvelopeIds}
    end,
    {DelMoney, NewEnvelopeIds} = lists:foldl(F, {0, EnvelopeIds}, SuccEnvelopeIds),
    NewAccMoney = max(0, AccMoney - DelMoney),
    {NewAccMoney, NewEnvelopeIds}.


%% 奖励领取信息
count_reward_status(PS, #act_info{key = {Type, SubType}} = ActInfo, RewardCfg) ->
    case lib_custom_act_check:check_reward_receive_times(PS, ActInfo, RewardCfg) of
        false -> ?ACT_REWARD_HAS_GET;
        _ ->
            NowTime = utime:unixtime(),
            #custom_envelope_rebate{
                is_quality = IsQuality, end_time = EndTime,
                start_time = StartTime
            } = DataInfo = get_data_info(PS, Type, SubType),
            #custom_act_reward_cfg{condition = Condition} = RewardCfg,
            case lib_custom_act_check:check_act_condtion([login_day, gold], Condition) of
                % 无资格
                _ when IsQuality =/= 1; EndTime < NowTime ->
                    ?ACT_REWARD_CAN_NOT_GET;
                [NeedDay, NeedGold] ->
                    #custom_envelope_rebate{login_day_list = LoginDayList} = DataInfo,
                    case lists:keyfind(NeedDay, 1, LoginDayList) of
                        {_, Gold} -> IsSatisfy = Gold >= NeedGold;
                        _ -> IsSatisfy = false
                    end,
                    if
                        IsSatisfy -> ?ACT_REWARD_CAN_GET;
                        true ->
                            CurrentDay = utime:diff_days(StartTime, NowTime) + 1,
                            IsOverdue = CurrentDay > NeedDay,
                            ?IF(IsOverdue, ?ACT_REWARD_TIME_OUT, ?ACT_REWARD_CAN_NOT_GET)
                    end;
                _ ->
                    ?ACT_REWARD_CAN_NOT_GET
            end
    end.

% 领取奖励
receive_reward(PS, Type, SubType, GradeId) ->
    #player_status{id = RoleId} = PS,
    NowTime = utime:unixtime(),
    case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{
            etime = Etime
        } = ActInfo when NowTime < Etime ->
            RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
            case count_reward_status(PS, ActInfo, RewardCfg) of
                ?ACT_REWARD_CAN_GET ->
                    PS1 = lib_custom_act:update_receive_times(PS, Type, SubType, RewardCfg#custom_act_reward_cfg.grade, 1),
                    LastPS = send_reward(PS1, Type, SubType, RewardCfg),
                    {ok, LastPS};
                _ErrCode ->
                    lib_custom_act:send_error_code(RoleId, _ErrCode)
            end;
        _ ->
            skip
    end.

%% =======================================================
% 发送奖励
% 红包物品需要特殊处理
send_reward(PS, Type, SubType, RewardCfg) ->
    #custom_act_reward_cfg{grade = GradeId, reward = Reward, condition = Condition} = RewardCfg,
    DataInfo = get_data_info(PS, Type, SubType),
    F = fun({_, GoodsTypeId, _}) -> GoodsTypeId == ?ENVELOPE_GOODS_ID end,
    {EnvelopeR, NormalR} =lists:partition(F, Reward),
    _AddMoney = lists:foldl(fun({_, _, Num}, Acc) -> Num + Acc end, 0, EnvelopeR),
    case NormalR of
        [] -> NewPS = PS;
        _ ->
            Remark = lists:concat(["SubType:", SubType, "GradeId:", GradeId]),
            Produce = #produce{type = envelope_rebate, subtype = Type, remark = Remark, reward = NormalR, show_tips = ?SHOW_TIPS_1},
            NewPS = lib_goods_api:send_reward(PS, Produce)
    end,
    case _AddMoney > 0 of
        true ->
            [EnvelopeId, EnvelopeType] = lib_custom_act_check:check_act_condtion([envelope_id, type], Condition),
            AddMoney = ?ENVELOPE_MONEY(EnvelopeId),
            {Money, EnvelopeIds} = get_envelope_id_money(DataInfo, EnvelopeType),
            NewEnvelopeIds = [{EnvelopeId, AddMoney, ?ENVELOPE_STATUS_NOT_USE}|EnvelopeIds],
            LastDataInfo = save_envelope_id_money(DataInfo, EnvelopeType, Money + AddMoney, NewEnvelopeIds);
        _ ->
            LastDataInfo = DataInfo
    end,
    LastPS = save_data_info_with_db(NewPS, Type, SubType, LastDataInfo),
    {ok, BinData} = pt_331:write(33105, [?SUCCESS, Type, SubType, GradeId]),
    lib_server_send:send_to_uid(LastPS#player_status.id, BinData),
    pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
    lib_log_api:log_custom_act_reward(LastPS#player_status.id, Type, SubType, GradeId, Reward),
    LastPS.

%% 活动结束
act_end(Type, SubType) ->
    spawn(
        fun() ->
            timer:sleep(10000),
            db:execute(io_lib:format(?DELETE_ENVELOPE_REBATE, [Type, SubType]))
        end
    ).

% 初始化信息
init_data_info(PS, Type, SubType) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}} = PS,
    StartLv = get_act_start_lv(Type, SubType),
    if
        StartLv > Lv -> PS;
        true ->
            Sql = io_lib:format(?SQL_SELECT_ENVELOPE_REBATE, [Type, SubType, RoleId]),
            case db:get_row(Sql) of
                [
                    IsQuality, StartTime, EndTime, LoginDayLStr, LastLoginTime0, LoginMoney,
                    RechargeMoney, LoginEnvelopeIdsStr, RechargeEnvelopeIdsStr, LoginLock, RechargeLock
                ] ->
                    NowTime = utime:unixtime(),
                    IsToday = utime:is_same_day(LastLoginTime0, NowTime),
                    LoginDayL = util:bitstring_to_term(LoginDayLStr),
                    case IsToday of
                        true ->
                            IsInDb = false,
                            LastLoginTime = LastLoginTime0,
                            LoginEnvelopeIds = util:bitstring_to_term(LoginEnvelopeIdsStr),
                            RechargeEnvelopeIds = util:bitstring_to_term(RechargeEnvelopeIdsStr),
                            RealLoginLock = LoginLock,
                            RealRechargeLock = RechargeLock,
                            NewLoginDayL = LoginDayL;
                        _ ->
                            IsInDb = true,
                            LastLoginTime = NowTime,
                            Day = utime:diff_days(NowTime, StartTime) + 1,
                            Gold = lib_recharge_api:get_today_pay_gold(RoleId),
                            F_c = fun({E, M, S}) -> {E, M, ?IF(S==?ENVELOPE_STATUS_USING, ?ENVELOPE_STATUS_NOT_USE, S)} end,
                            LoginEnvelopeIds = lists:map(F_c, util:bitstring_to_term(LoginEnvelopeIdsStr)),
                            RechargeEnvelopeIds = lists:map(F_c, util:bitstring_to_term(RechargeEnvelopeIdsStr)),
                            RealLoginLock = 0,
                            RealRechargeLock = 0,
                            NewLoginDayL = [{Day, Gold}|lists:keydelete(Day, 1, LoginDayL)]
                    end,
                    DataInfo = #custom_envelope_rebate{
                        is_init = 1, is_quality = IsQuality, start_time = StartTime,
                        end_time = EndTime, login_day_list = NewLoginDayL,
                        last_login_time = LastLoginTime, login_money = LoginMoney, recharge_money = RechargeMoney,
                        login_envelope_ids = LoginEnvelopeIds,
                        recharge_envelope_ids = RechargeEnvelopeIds,
                        login_lock = RealLoginLock, recharge_lock = RealRechargeLock
                    },
                    case IsInDb of
                        true ->
                            save_data_info_with_db(PS, Type, SubType, DataInfo);
                        _ ->
                            lib_custom_act:save_other_act_data_to_player(PS, Type, SubType, DataInfo)
                    end;
                _ ->
                    LastLoginTime = utime:unixtime(),
                    StartTime = utime:unixdate(LastLoginTime),
                    DurationDay = get_act_duration_day(Type, SubType),
                    EndTime = StartTime + DurationDay * ?ONE_DAY_SECONDS,
                    %% 如果算出的EndTime > ActETime 也不会有资格
                    IsQuality = ?IF(is_eligible(PS, EndTime, Type, SubType), 1, 0),
                    LoginDayL = [{1, lib_recharge_api:get_today_pay_gold(RoleId)}],
                    DataInfo = #custom_envelope_rebate{
                        is_init = 1,
                        is_quality = IsQuality, start_time = StartTime, end_time = EndTime,
                        login_day_list = LoginDayL, last_login_time = LastLoginTime
                    },
                    save_data_info_with_db(PS, Type, SubType, DataInfo)
            end
    end.

% 判断是否有资格
is_eligible(PS, #custom_envelope_rebate{end_time = EndTime}, Type, SubType) ->
    is_eligible(PS, EndTime, Type, SubType);
is_eligible(PS, EndTime, Type, SubType) ->
    #player_status{first_state = FirstState, source = Source} = PS,
    IsUnique = is_unique_role_act(Type, SubType),
    #act_info{etime = ActETime} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    %% 如果算出的EndTime > ActETime 也不会有资格| + 10 的原因是定制活动结束时间会在 59分59秒
    IsSatisfy = EndTime < ActETime + 10,
    SourceSatisfy =
        case lib_custom_act_check:check_act_condition(Type, SubType, [source]) of
            [NeedSourceL] ->
                AtomSource = erlang:list_to_atom(util:make_sure_list(Source)),
                lists:member(AtomSource, NeedSourceL);
            _ ->
                true
        end,
    SourceSatisfy andalso IsSatisfy andalso (FirstState == ?ACC_FIRST_ROLE_TRUE orelse IsUnique == false).

%% ===================================== 红包类型相关处理 ===================================
get_envelope_id_money(DataInfo, EnvelopeType) ->
    #custom_envelope_rebate{
        login_money = LoginMoney, login_envelope_ids = LoginEnvelopeIds ,
        recharge_money = RechargeMoney, recharge_envelope_ids = RechargeEnvelopeIds
    } = DataInfo,
    case EnvelopeType of
        ?ENVELOPE_TYPE_LOGIN -> {LoginMoney, LoginEnvelopeIds};
        _ -> {RechargeMoney, RechargeEnvelopeIds}
    end.

get_envelope_id_money_lock(DataInfo, EnvelopeType) ->
    #custom_envelope_rebate{
        login_money = LoginMoney, login_envelope_ids = LoginEnvelopeIds , login_lock = LoginLock,
        recharge_money = RechargeMoney, recharge_envelope_ids = RechargeEnvelopeIds, recharge_lock = RechargeLock
    } = DataInfo,
    case EnvelopeType of
        ?ENVELOPE_TYPE_LOGIN -> {LoginLock, LoginMoney, LoginEnvelopeIds};
        _ -> {RechargeLock, RechargeMoney, RechargeEnvelopeIds}
    end.

save_envelope_id_money(DataInfo, EnvelopeType, Money, EnvelopeIds) ->
    case EnvelopeType of
        ?ENVELOPE_TYPE_LOGIN ->
            DataInfo#custom_envelope_rebate{login_money = Money, login_envelope_ids = EnvelopeIds};
        _ ->
            DataInfo#custom_envelope_rebate{recharge_money = Money, recharge_envelope_ids = EnvelopeIds}
    end.

save_envelope_id_money_lock(DataInfo, EnvelopeType, Money, EnvelopeIds) ->
    case EnvelopeType of
        ?ENVELOPE_TYPE_LOGIN ->
            DataInfo#custom_envelope_rebate{login_money = Money, login_envelope_ids = EnvelopeIds, login_lock = 1};
        _ ->
            DataInfo#custom_envelope_rebate{recharge_money = Money, recharge_envelope_ids = EnvelopeIds, recharge_lock = 1}
    end.

save_envelope_id_money_unlock(DataInfo, EnvelopeType, Money, EnvelopeIds) ->
    case EnvelopeType of
        ?ENVELOPE_TYPE_LOGIN ->
            DataInfo#custom_envelope_rebate{login_money = Money, login_envelope_ids = EnvelopeIds, login_lock = 0};
        _ ->
            DataInfo#custom_envelope_rebate{recharge_money = Money, recharge_envelope_ids = EnvelopeIds, recharge_lock = 0}
    end.


%% ========================= 活动数据相关 获取与存储 ==============================
% 获取玩家的活动数据
get_data_info(PS, Type, SubType) ->
    case lib_custom_act:act_other_data(PS, Type, SubType) of
        #custom_envelope_rebate{} = DataInfo -> DataInfo;
        _ ->
            #custom_envelope_rebate{}
    end.

% 保存活动数据
save_data_info_with_db(PS, Type, SubType, DataInfo) ->
    #player_status{id = RoleId} = PS,
    #custom_envelope_rebate{
        is_quality = IsQuality, start_time = StartTime, end_time = EndTime,
        login_day_list = LoginDayL, last_login_time = LastLoginTime,
        login_money = LoginMoney, recharge_money = RechargeMoney,
        login_envelope_ids = LoginEnvelopeIds, recharge_envelope_ids = RechargeEnvelopeIds,
        login_lock = LoginLock, recharge_lock = RechargeLock
    } = DataInfo,
    Sql = io_lib:format(?SQL_REPLACE_ENVELOPE_REBATE, [Type, SubType, RoleId, IsQuality, StartTime, EndTime,
        util:term_to_string(LoginDayL), LastLoginTime, LoginMoney, RechargeMoney, util:term_to_string(LoginEnvelopeIds),
        util:term_to_string(RechargeEnvelopeIds),LoginLock, RechargeLock]),
    db:execute(Sql),
    lib_custom_act:save_other_act_data_to_player(PS, Type, SubType, DataInfo).

%% ================================ 计数器相关 =====================================
add_global_withdrawal_times(RoleId, WithDrawType) ->
    IsFirst = get_role_withdrawal_times(RoleId, WithDrawType) == 0,
    case IsFirst of
        true ->
            increment_role_withdrawal_times(RoleId, WithDrawType),
            increment_withdrawal_current_times(WithDrawType);
        _ -> skip
    end.

get_role_withdrawal_times(RoleId, WithDrawType) ->
    case WithDrawType of
        ?ENVELOPE_TYPE_LOGIN ->
            mod_counter:get_count_offline(RoleId, ?MOD_AC_CUSTOM_OTHER, 1);
        _ ->
            mod_counter:get_count_offline(RoleId, ?MOD_AC_CUSTOM_OTHER, 2)
    end.
increment_role_withdrawal_times(RoleId, WithDrawType) ->
    case WithDrawType of
        ?ENVELOPE_TYPE_LOGIN ->
            mod_counter:increment_offline(RoleId, ?MOD_AC_CUSTOM_OTHER, 1);
        _ ->
            mod_counter:increment_offline(RoleId, ?MOD_AC_CUSTOM_OTHER, 2)
    end.

get_withdrawal_current_times(WithDrawType) ->
    case WithDrawType of
        ?ENVELOPE_TYPE_LOGIN ->
            mod_global_counter:get_count(?MOD_AC_CUSTOM_OTHER, 1);
        _ ->
            mod_global_counter:get_count(?MOD_AC_CUSTOM_OTHER, 2)
    end.

increment_withdrawal_current_times(WithDrawType) ->
    case WithDrawType of
        ?ENVELOPE_TYPE_LOGIN ->
            mod_global_counter:increment(?MOD_AC_CUSTOM_OTHER, 1);
        _ ->
            mod_global_counter:increment(?MOD_AC_CUSTOM_OTHER, 2)
    end.
%% ================================ 获取配置相关 =====================================
%% 获取限制他条件
get_withdrawal_limit_day(Type, SubType, WithDrawType) ->
    Fields = ?IF(WithDrawType == ?ENVELOPE_TYPE_LOGIN, [withdrawal_day_login], [withdrawal_day_recharge]),
    [LimitDayL] = get_custom_act_condition(Type, SubType, Fields),
    LimitDayL.

%% 获取全区提现次数限制
get_withdrawal_limit_times(Type, SubType, WithDrawType) ->
    Fields = ?IF(WithDrawType == ?ENVELOPE_TYPE_LOGIN, [withdrawal_limit_login], [withdrawal_limit_recharge]),
    case get_custom_act_condition(Type, SubType, Fields) of
        [LimitDayL] -> LimitDayL;
        _ -> 999999
    end.

% 获取活动持续时间
get_act_duration_day(Type, SubType) ->
    [DurationDay] = get_custom_act_condition(Type, SubType, [day_limit]),
    DurationDay.

%% 是否角色唯一的活动
is_unique_role_act(Type, SubType) ->
    [IsUnique] = get_custom_act_condition(Type, SubType, [is_unique]),
    IsUnique == 1.

get_act_start_lv(Type, SubType) ->
    [RoleLv] = get_custom_act_condition(Type, SubType, [role_lv]),
    RoleLv.

% 获取活动条件
get_custom_act_condition(Type, SubType, Fields) ->
    #custom_act_cfg{condition = ActCondition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
    lib_custom_act_check:check_act_condtion(Fields, ActCondition).

get_money(EnvelopeId) ->
    case EnvelopeId of
        325 -> 30;
        326 -> 30;
        327 -> 30;
        328 -> 30;
        329 -> 30;
        330 -> 30;
        331 -> 30;
        332 -> 120;
        333 -> 80;
        334 -> 40;
        335 -> 100;
        336 -> 60;
        337 -> 40;
        338 -> 50;
        _ ->
            ?ERR("error envelope_id ~p ~n", [EnvelopeId]),
            0
    end.

gm_finish_all(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_gm_finish_all(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubTypeList).

do_gm_finish_all(PS, Type, SubType) ->
    #act_info{stime = Stime, etime = Etime} = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
    LoginDayL = [{1,100}, {2,100}, {3,100}, {4,100}, {5,100}, {6,100}, {7,100}],
    DataInfo = #custom_envelope_rebate{
        login_day_list = LoginDayL, is_quality = 1,
        start_time = Stime, end_time = Etime
    },
    LastPS = save_data_info_with_db(PS, Type, SubType, DataInfo),
    pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
    pp_custom_act:handle(33104, LastPS, [Type, SubType]),
    LastPS.

test_envelope_withdrawal() ->
    RuleIds = util:term_to_bitstring([293,294]),
    PostData = [
        {package_code, "P0010940"}, {tokenid, 0}, {main_id, ?ENVELOPE_CENTER_ID},
        {rule_ids, RuleIds}, {role_id, 111},
        {role_name, <<"型男"/utf8>>}, {role_level, 150}, {server_id, config:get_server_num()},
        {server_name, util:get_server_name()}, {type, 117}, {subtype, 1}
    ],
    PhpRequest = #php_request{role_id = 111, mfa = {?MODULE, envelope_withdrawal_callback, [1]}},
    lib_php_api:request_register(withdraw_redapi, PostData, PhpRequest),
    <<"型男"/utf8>>.

gm_set_envelope(RoleId, LoginMoney, LoginEnvelopeIdsStr, LoginLock, RMoney, REnvelopeIdsStr, RLock) ->
    Sql = io_lib:format(<<"update `role_envelope_rebate` set is_quality = 1, `login_money` = ~p, `login_envelope_ids` = '~s', login_lock = ~p,
     `recharge_money` = ~p, `recharge_envelope_ids` = '~s', `recharge_lock` = ~p where `role_id` = ~p">>,
        [LoginMoney, util:make_sure_list(LoginEnvelopeIdsStr), LoginLock, RMoney, util:make_sure_list(REnvelopeIdsStr), RLock, RoleId]),
    db:execute(Sql).

gm_fix_envelope_money() ->
    Sql = <<"select role_id, login_envelope_ids, recharge_envelope_ids from role_envelope_rebate where is_quality = 1
        and (login_envelope_ids != '[]' or recharge_envelope_ids != '[]')">>,
    List = db:get_all(Sql),
    spawn(fun() -> do_gm_fix_envelope_money(List) end),
    length(List).

do_gm_fix_envelope_money([]) -> ok;
do_gm_fix_envelope_money([[RoleId, LoginEnvelopeIdsStr, RechargeEnvelopeIdsStr]|T]) ->
    timer:sleep(1000),
    case misc:is_process_alive(misc:get_player_process(RoleId)) of
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?MODULE, fix_envelope_money, []),
            do_gm_fix_envelope_money(T);
        _ ->
            LoginEnvelopeIds = util:bitstring_to_term(LoginEnvelopeIdsStr),
            RechargeEnvelopeIds = util:bitstring_to_term(RechargeEnvelopeIdsStr),
            F = fun
                    ({EnvelopeId, _, ?ENVELOPE_STATUS_HAD_USE}, {AccL, AccMoney}) ->
                        {[{EnvelopeId, get_money(EnvelopeId), ?ENVELOPE_STATUS_HAD_USE}|AccL], AccMoney};
                    ({EnvelopeId, _, Status}, {AccL, AccMoney}) ->
                        M = get_money(EnvelopeId),
                        {[{EnvelopeId, M, Status}|AccL],  M + AccMoney}
            end,
            {LoginEnvelopeIdsTmp, LoginMoney} = lists:foldl(F, {[], 0}, LoginEnvelopeIds),
            {RechargeEnvelopeIdsTmp, RechargeMoney} = lists:foldl(F, {[], 0}, RechargeEnvelopeIds),
            NewLoginEnvelopeIds = lists:reverse(LoginEnvelopeIdsTmp),
            NewRechargeEnvelopeIds = lists:reverse(RechargeEnvelopeIdsTmp),
            Sql = io_lib:format(<<"update role_envelope_rebate set login_envelope_ids = '~s', login_money = ~p,
             recharge_envelope_ids = '~s', recharge_money = ~p where role_id = ~p">>, [util:term_to_string(NewLoginEnvelopeIds),
                LoginMoney, util:term_to_string(NewRechargeEnvelopeIds),RechargeMoney,RoleId]),
            db:execute(Sql),
            do_gm_fix_envelope_money(T)
    end.

fix_envelope_money(PS) ->
    Type = ?CUSTOM_ACT_TYPE_ENVELOPE_REBATE,
    SubTypeList = lib_custom_act_api:get_open_subtype_ids(Type),
    F = fun(SubType, AccPS) -> do_fix_envelope_money(AccPS, Type, SubType) end,
    lists:foldl(F, PS, SubTypeList).

do_fix_envelope_money(PS, Type, SubType) ->
    case get_data_info(PS, Type, SubType) of
        #custom_envelope_rebate{login_envelope_ids = LoginEnvelopeIds, recharge_envelope_ids = RechargeEnvelopeIds} = DataInfo  ->
            F = fun
                    ({EnvelopeId, _, ?ENVELOPE_STATUS_HAD_USE}, {AccL, AccMoney}) ->
                        {[{EnvelopeId, get_money(EnvelopeId), ?ENVELOPE_STATUS_HAD_USE}|AccL], AccMoney};
                    ({EnvelopeId, _, Status}, {AccL, AccMoney}) ->
                        M = get_money(EnvelopeId),
                        {[{EnvelopeId, M, Status}|AccL],  M + AccMoney}
                end,
            {LoginEnvelopeIdsTmp, LoginMoney} = lists:foldl(F, {[], 0}, LoginEnvelopeIds),
            {RechargeEnvelopeIdsTmp, RechargeMoney} = lists:foldl(F, {[], 0}, RechargeEnvelopeIds),
            NewLoginEnvelopeIds = lists:reverse(LoginEnvelopeIdsTmp),
            NewRechargeEnvelopeIds = lists:reverse(RechargeEnvelopeIdsTmp),
            NewDataInfo = DataInfo#custom_envelope_rebate{login_envelope_ids = NewLoginEnvelopeIds,
                login_money = LoginMoney, recharge_envelope_ids = NewRechargeEnvelopeIds, recharge_money = RechargeMoney},
            LastPS = save_data_info_with_db(PS, Type, SubType, NewDataInfo),
            pp_custom_act_list:handle(33255, LastPS, [Type, SubType]),
            LastPS;
        _ -> PS
    end.

