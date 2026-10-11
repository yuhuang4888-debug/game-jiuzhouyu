%%-----------------------------------------------------------------------------
%% @Module  :       lib_goods_exchange
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-18
%% @Description:    物品兑换
%%-----------------------------------------------------------------------------
-module(lib_goods_exchange).

-include("server.hrl").
-include("goods.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("def_fun.hrl").

-export([
    send_info/2
    , exchange/5
    , check_times_limit/6
    , check_condition/2
    , check_rule_is_vaild/1
    ]).

%% 新加了兑换类型记得去goods.hrl的EXCHANGE_TYPE加上


%% 兑换信息
send_info(PlayerStatus, Type) ->
    #player_status{sid = Sid, id = RoleId} = PlayerStatus,
    Ids = data_exchange:get_ids(Type),
    F = fun(Id) ->
        #goods_exchange_cfg{
            type = Type,
            lim_type = LimType,
            module = ModuleId,
            sub_module = SubModuleId,
            condition = Condition
        } = data_exchange:get(Id),
        case lib_goods_exchange:check_condition(Condition, PlayerStatus) of
            true -> CanExchange = 1;
            _ -> CanExchange = 0
        end,
        ExchangeTimes = get_exchange_times(LimType, RoleId, Id, ModuleId, SubModuleId),
        {Id, ExchangeTimes, CanExchange}
    end,
    {ok, BinData} = pt_150:write(15026, [Type, lists:map(F, Ids)]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

get_exchange_times(1, RoleId, RuleId, 0, 0) ->
    mod_daily:get_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId);
get_exchange_times(2, RoleId, RuleId, 0, 0) ->
    mod_week:get_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId);
get_exchange_times(3, RoleId, RuleId, 0, 0) ->
    mod_counter:get_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId);

get_exchange_times(1, RoleId, RuleId, ModuleId, SubModuleId) ->
    mod_daily:get_count(RoleId, ModuleId, SubModuleId, RuleId);
get_exchange_times(2, RoleId, RuleId, ModuleId, SubModuleId) ->
    mod_week:get_count(RoleId, ModuleId, SubModuleId, RuleId);
get_exchange_times(3, RoleId, RuleId, ModuleId, SubModuleId) ->
    mod_counter:get_count(RoleId, ModuleId, SubModuleId, RuleId);

get_exchange_times(_, _RoleId, _RuleId, _ModuleId, _SubModuleId) ->
    0.

%% 兑换
exchange(PlayerStatus, ExchangeRule, ExchangeTimes, RealCostList, RealObtainList) ->
    #goods_exchange_cfg{
        id = RuleId,
        type = Type,
        lim_type = LimType,
        module = ModuleId,
        sub_module = SubModuleId
    } = ExchangeRule,
    #player_status{sid = Sid, id = RoleId} = PlayerStatus,
    case lib_goods_api:cost_object_list(PlayerStatus, RealCostList, goods_exchange, "") of
        {true, NewPlayerStatus} ->
            ErrCode = ?SUCCESS,
            increment_exchange_times(LimType, RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes),

            %% 日志
            lib_log_api:log_goods_exchange(RoleId, Type, RealCostList, RealObtainList),

            do_some_other_af_exchange(NewPlayerStatus, ExchangeRule, ExchangeTimes),
            LastPlayerStatus = lib_goods_api:send_reward(NewPlayerStatus, RealObtainList, goods_exchange, 0);
        {false, ErrCode, NewPlayerStatus} -> LastPlayerStatus = NewPlayerStatus
    end,
    {ok, BinData} = pt_150:write(15022, [ErrCode, RuleId, Type]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, LastPlayerStatus}.

%% 增加兑换次数
increment_exchange_times(1, RoleId, 0, 0, RuleId, ExchangeTimes) ->
    mod_daily:plus_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId, ExchangeTimes);
increment_exchange_times(2, RoleId, 0, 0, RuleId, ExchangeTimes) ->
    mod_week:plus_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId, ExchangeTimes);
increment_exchange_times(3, RoleId, 0, 0, RuleId, ExchangeTimes) ->
    mod_counter:plus_count(RoleId, ?MOD_GOODS, ?MOD_GOODS_EXCHANGE, RuleId, ExchangeTimes);

increment_exchange_times(1, RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes) ->
    mod_daily:plus_count(RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes);
increment_exchange_times(2, RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes) ->
    mod_week:plus_count(RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes);
increment_exchange_times(3, RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes) ->
    mod_counter:plus_count(RoleId, ModuleId, SubModuleId, RuleId, ExchangeTimes);
increment_exchange_times(_, _RoleId, _RuleId, _ModuleId, _SubModuleId, _ExchangeTimes) -> skip.

%% 处理兑换后的一些其他事情
do_some_other_af_exchange(PlayerStatus, ExchangeRule, _ExchangeTimes) ->
    #goods_exchange_cfg{id = _ExchangeId, type = Type} = ExchangeRule,
    case Type of
        ?EXCHANGE_TYPE_TREASURE_HUNT ->
            pp_treasure_hunt:handle(41601, PlayerStatus, []);
        _ -> skip
    end,
    ok.

%% 检测某些特殊的兑换规则是否开启
%% 如:特殊活动的
check_rule_is_vaild(ExchangeRule) ->
    #goods_exchange_cfg{type = Type} = ExchangeRule,
    case Type of
        _ -> true
    end.

%% 检测兑换是否达到次数上限
check_times_limit(0, _RoleId, _RuleId, _ModuleId, _SubModuleId, _ExchangeTimes) -> true;

check_times_limit(LimType, RoleId, RuleId, ModuleId, SubModuleId, ExchangeTimes) when 
        LimType == 1;
        LimType == 2;
        LimType == 3 ->
    Value = get_exchange_times(LimType, RoleId, RuleId, ModuleId, SubModuleId),
    LimitTimes = get_count_limit(RuleId),
    Value + ExchangeTimes =< LimitTimes;

check_times_limit(_, _RoleId, _RuleId, _ModuleId, _CounterId, _ExchangeTimes) -> false.

get_count_limit(RuleId) ->
    case data_exchange:get(RuleId) of
        #goods_exchange_cfg{
            lim_num = LimNum
        } ->
            LimNum;
        _ -> 0
    end.

check_condition([], _) -> true;
check_condition([T|L], Player) ->
    case do_check_condition(T, Player) of
        true ->
            check_condition(L, Player);
        {false, ErrCode} ->
            {false, ErrCode}
    end.

do_check_condition({role_lv, Lv}, Player) ->
    #player_status{figure = Figure} = Player,
    case Figure#figure.lv >= Lv of
        true -> true;
        false -> {false, ?ERRCODE(err150_require_err)}
    end;
do_check_condition({finish_dun, DunId}, Player) ->
    #player_status{id = RoleId} = Player,
    case lib_dungeon_api:check_ever_finish(RoleId, DunId) of
        true -> true;
        false -> {false, ?ERRCODE(err150_require_err)}
    end;
do_check_condition(_, _) ->
    {false, ?ERRCODE(err150_require_err)}.
