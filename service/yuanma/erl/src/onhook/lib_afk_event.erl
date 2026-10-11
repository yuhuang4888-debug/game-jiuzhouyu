%% ---------------------------------------------------------------------------
%% @doc lib_afk_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-05-19
%% @deprecated 挂机(规则2)事件
%% ---------------------------------------------------------------------------

-module(lib_afk_event).

-include("common.hrl").
-include("server.hrl").


-export([
    afk_exp_change/1
    , get_extra_afk_reward_on_off/3
    , trigger_afk_on_online/2
]).


%% 挂机经验变化
afk_exp_change(#player_status{id = RoleId} = Player) ->
    PerMExp = lib_afk_api:get_minus_afk_exp(Player),
    lib_common_rank_api:refresh_rank_by_afk(RoleId, PerMExp),
    Player.

%% 获取离线挂机的额外奖励
%% @param Multi 次数
%% @return [{Type, GoodsTypeId, Num}]
get_extra_afk_reward_on_off(Player, Date, Multi) ->
    {NewPS, ActRewardL} = lib_custom_act_api:calc_offline_act_drop(Player, Date, Multi),
    {NewPS, ActRewardL}.

%% 在线触发挂机掉落(不归入挂机掉落)
trigger_afk_on_online(Player, _Multi) ->
    NewPS = lib_custom_act_api:calc_act_drop_online(Player, _Multi),
    NewPS.
