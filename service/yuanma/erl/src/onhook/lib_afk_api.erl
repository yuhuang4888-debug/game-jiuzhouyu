%% ---------------------------------------------------------------------------
%% @doc lib_afk_api.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-04-13
%% @deprecated 挂机(规则2):接口
%% ---------------------------------------------------------------------------

-module(lib_afk_api).
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("afk.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").

-define(REWARD_COMBAT_TYPE, 1).
-define(REWARD_LV_TYPE,     2).

handle_event(#player_status{figure = #figure{lv = Lv}} = Player, #event_callback{type_id = TypeId}) when
        TypeId == ?EVENT_LV_UP;
        TypeId == ?EVENT_COMBAT_POWER;
        TypeId == ?EVENT_USE_BUFF_GOODS;
        TypeId == ?EVENT_REFRESH_BUFF ->
    case Lv >= ?AFK_KV_OPEN_LV of
        true -> 
            lib_afk:send_exp_effect_info(Player),
            EventPlayer = lib_afk_event:afk_exp_change(Player),
            {ok, EventPlayer};
        false -> 
            {ok, Player}
    end;
    
handle_event(Player, _EventCallback) ->
    {ok, Player}.

%% 获取每分钟经验加成
get_minus_afk_exp(Player) ->
    lib_afk:get_exp_effect(Player).