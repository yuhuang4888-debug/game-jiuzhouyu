%%%--------------------------------------
%%% @Module  : lib_mystery_util
%%% @Author  : zengzy 
%%% @Created : 2017-11-28
%%% @Description:  神秘商店系统
%%%--------------------------------------
-module(lib_mystery_util).
-compile(export_all).
-export([]).

-include("errcode.hrl").
-include("common.hrl").
-include("shop.hrl").

%% ---------------------------------- 检测函数 -----------------------------------
checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

%% 检查神秘商店的配置
check({check_mystery_show, Tmp, ConfigList}) ->
    case ConfigList =/= [] of
        true ->
            case (lists:min(ConfigList) > Tmp) orelse (Tmp > lists:max(ConfigList)) of
                true ->
                    {false, ?ERRCODE(err153_out_config)};
                false -> true
            end;
        false ->
            true
    end;

%% 检查转生阶级限制
check({check_enough_turn_stage , Tmp, ConfigList}) ->
    case ConfigList =/= [] of
        true ->
            case (lists:min(ConfigList) > Tmp) orelse (Tmp > lists:max(ConfigList)) of
                true ->
                    {false, ?ERRCODE(err153_enough_turn_stage)};
                false -> true
            end;
        false ->
            true
    end;

%% 检查开服天数限制
check({check_open_day , Tmp, ConfigList}) ->
    case ConfigList =/= [] of
        true ->
            case (lists:min(ConfigList) > Tmp) orelse (Tmp > lists:max(ConfigList)) of
                true ->
                    {false, ?ERRCODE(err153_not_enough_server_time)};
                false -> true
            end;
        false ->
            true
    end;

%% 检查世界等级限制
check({check_world_lv , Tmp, ConfigList}) ->
    case ConfigList =/= [] of
        true ->
            case (lists:min(ConfigList) > Tmp) orelse (Tmp > lists:max(ConfigList)) of
                true ->
                    {false, ?ERRCODE(err153_not_enough_world_lv)};
                false -> true
            end;
        false ->
            true
    end;

%% 检查玩家等级限制
check({check_enough_lv , Tmp, ConfigList}) ->
    case ConfigList =/= [] of
        true ->
            case (lists:min(ConfigList) > Tmp) orelse (Tmp > lists:max(ConfigList)) of
                true ->
                    {false, ?ERRCODE(err153_not_enough_lv)};
                false -> true
            end;
        false ->
            true
    end;


%%检测配置
check({check_cfg, Cfg, CfgType}) ->
    case is_record(Cfg, CfgType) of
        true -> true;
        false -> {false, ?ERRCODE(err153_missing_config)}
    end;


check({check_shop_buy, PS, Cfg, Price}) ->
    #base_shop_good{old_price = OCost} = Cfg,
    case Price == 0 of
        true -> check({check_cost, OCost, PS});
        false ->
            [{TypeId, GoodId, _}] = OCost,
            ?PRINT("[{TypeId, GoodId, Price}]:~w~n",[[{TypeId, GoodId, Price}]]),
            check({check_cost, [{TypeId, GoodId, Price}], PS})
    end;

check({check_cost, CostList, PS}) ->
    Result = lib_goods_util:check_object_list(PS, CostList),
    case Result of
        true ->
            true;
        {false, Res} ->
            ?PRINT("Res :~p~n",[Res]),
            {false, Res};
        _Othre ->
            true
    end;

check(_) ->
    false.

%% ---------------------------------- 日志 -----------------------------------

log_shop_bag(RoleId, Id, Cost, GoodList) ->
    lib_log_api:log_mystery_shop_bag(RoleId, Id, Cost, GoodList).


