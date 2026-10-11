%%-----------------------------------------------------------------------------
%% @Module  :       lib_sea_treasure_api
%% @Author  :       xlh
%% @Email   :       
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）接口
%%-----------------------------------------------------------------------------
-module (lib_sea_treasure_api).

-include("rec_event.hrl").
-include("def_event.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("sea_treasure.hrl").

-export([handle_event/2]).

%% -----------------------------------------------------------------
%% 玩家数据收集，统一更新到跨服
%% -----------------------------------------------------------------
handle_event(PS, #event_callback{type_id = Type}) when is_record(PS, player_status) andalso
Type == ?EVENT_LV_UP orelse Type == ?EVENT_COMBAT_POWER orelse Type == ?EVENT_RENAME ->
    Openday = util:get_open_day(),
    #player_status{id = RoleId, combat_power = Power, figure = #figure{name = RoleName, lv = RoleLv}} = PS,
    List = [{open_lv, RoleLv}, {open_day, Openday}],
    case lib_sea_treasure:check(List) of
        true ->
            {N, Val} = if
                Type == ?EVENT_LV_UP ->
                    {#role_shipping_info.role_lv, RoleLv};
                Type == ?EVENT_COMBAT_POWER ->
                    {#role_shipping_info.power, Power};
                true ->
                    {#role_shipping_info.role_name, RoleName}
            end,
            mod_sea_treasure_local:update_role_info({role, RoleId, N, Val});
        _ ->
            skip
    end,
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.