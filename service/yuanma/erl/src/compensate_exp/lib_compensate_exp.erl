%% ---------------------------------------------------------------------------
%% @doc lib_compensate_exp.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-05-11
%% @deprecated 经验补偿
%% ---------------------------------------------------------------------------
-module(lib_compensate_exp).
-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("attr.hrl").
-include("def_module.hrl").
-include("compensate_exp.hrl").
-include("common.hrl").

%% 补偿
compensate(#player_status{id = RoleId, figure = #figure{lv = Lv}, reg_time = RegTime} = Player, CostOnhookTime, Exp) ->
    Count = mod_daily:get_count(RoleId, ?MOD_ONHOOK, 1),
    % 补偿经验
    Day = utime:diff_days(RegTime)+1,
    Ratio = data_compensate_exp:get_exp_ratio(Day, Lv),
    AddExp = round(Exp*Ratio/?RATIO_COEFFICIENT),
    case AddExp > 0 of
        true -> NewPlayer = lib_player:add_exp(Player, AddExp);
        false -> NewPlayer = Player
    end,
    % 补偿经验丹
    #player_status{figure = #figure{lv = NewLv}} = NewPlayer,
    % 每天只有一次补偿经验丹
    case Count == 0 andalso CostOnhookTime>=?COMPENSATE_EXP_ONHOOK_TIME of
        true -> Reward = data_compensate_exp:get_exp_goods_reward(Day, Lv);
        false -> Reward = []
    end,
    lib_log_api:log_compensate_exp(RoleId, CostOnhookTime, Exp, Lv, AddExp, NewLv, Reward),
    case Reward == [] of
        true -> {ok, NewPlayer};
        false -> 
            mod_daily:increment(RoleId, ?MOD_ONHOOK, 1),
            Remark = lists:concat(["Lv:", Lv, ",NewLv:", NewLv]),
            Produce = #produce{type = compensate_exp, reward = Reward, remark = Remark},
            PlayerAfReward = lib_goods_api:send_reward(NewPlayer, Produce),
            {ok, PlayerAfReward}
    end.
            