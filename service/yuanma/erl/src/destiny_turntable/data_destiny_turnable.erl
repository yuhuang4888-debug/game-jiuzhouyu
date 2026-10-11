%% ---------------------------------------------------------------------------
%% @doc data_destiny_turnable

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/6/17
%% @deprecated  天命转盘手动配置
%% ---------------------------------------------------------------------------
-module(data_destiny_turnable).

-include("custom_act.hrl").

%% API
-export([
    get_double_consume_type/0
    , get_double_consume_type2/0
    , get_double_jump_ids/0
]).

%% 以下函数分开写的原因是月卡投资的消耗类型和超级投资的是一样的
%% 但是客户端的跳转id不一致

%% 获取双倍天命值的消耗类型
get_double_consume_type() ->
    [buy_vip_up, buy_vip, investment_buy].

%% 特殊条件下可触发双倍天命值得消耗类型
get_double_consume_type2() ->
    OpDay = util:get_open_day(),
    ConditionL = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_DESTINY_TURN, 1, 'double_point2'),
    case ConditionL of
        false -> [];
        {_, ActList} -> [Type || {Type, _, OpDayRange} <- ActList, ulists:is_in_range(OpDayRange, OpDay) /= false] % 因为历史原因，导致这个配置相当冗余复杂
    end.

%% 获取双倍天命值的客户端跳转Id
%% 购买vip, 超级投资, 月卡投资
get_double_jump_ids() ->
    [23, 191, 61, 250].
