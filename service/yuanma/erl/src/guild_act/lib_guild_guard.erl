%%-----------------------------------------------------------------------------
%% @Module  :       lib_guild_guard.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-20
%% @Description:    守卫公会
%%-----------------------------------------------------------------------------
-module (lib_guild_guard).
-export ([collect_guild_info_and_enter_act/1]).
-include ("guild.hrl").
-include ("common.hrl").

collect_guild_info_and_enter_act(GuildId) ->
    case lib_guild_data:get_guild_by_id(GuildId) of
        #guild{lv = Lv, combat_power = CombatPower} ->
            ActiveNum = lib_guild_mod:get_active_member_num(GuildId),
            mod_guild_guard:create_dun(GuildId, [Lv, CombatPower, ActiveNum]);
        _ ->
            ?ERR("collect_guild_info_and_enter_act cannot find guild ~p~n", [GuildId])
    end.
