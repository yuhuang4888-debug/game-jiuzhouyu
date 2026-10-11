%%-----------------------------------------------------------------------------
%% @Module  :       lib_spec_sell_act
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2018-5-21
%% @Description:    精品特卖
%%-----------------------------------------------------------------------------
-module(lib_spec_sell_act).

-include("server.hrl").
-include("errcode.hrl").
-include("custom_act.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-compile(export_all).

handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    NowTime = utime:unixtime(),
    #player_status{
        id            = RoleId,
        figure        = #figure{lv = Lv},
        spec_sell_act = Maps
    } = Player,
    F = fun
            (#act_info{key = {_, SubType}}, AccMap) ->
                case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_SPEC_SELL, SubType) of
                    #custom_act_cfg{condition = Conditon} ->
                        case lib_custom_act_check:check_act_condtion([role_lv], Conditon) of
                            [CfgLv] ->
                                case Lv == CfgLv orelse (Lv > CfgLv andalso maps:get(SubType, Maps, false) =:= false) of
                                    true ->
                                        Sql = io_lib:format(<<"replace into spec_sell_act(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, SubType, NowTime]),
                                        db:execute(Sql),
                                        maps:put(SubType, NowTime, AccMap);
                                    false -> AccMap
                                end;
                            _ -> ?ERR("cfg err!~n", []), AccMap
                        end;
                    _ -> ?ERR("cfg err!~n", []), AccMap
                end
        end,
    NewMaps = lists:foldl(F, Maps, lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_SPEC_SELL)),
    NewPlayer = Player#player_status{spec_sell_act = NewMaps},
    {ok, NewPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

%% 登录处理
%% return:  #player_status{}
login(Player) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    Lists = db:get_all(io_lib:format(<<"select sub_type, lv_time from spec_sell_act where role_id = ~p">>, [RoleId])),
    F = fun
            ([SubType, Time], AccMap) ->
                maps:put(SubType, Time, AccMap)
        end,
    TmpMap = lists:foldl(F, #{}, Lists),
    F1 = fun(#act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, AccMap) ->
        case maps:get(SubType, AccMap, false) of
            OldTime when OldTime >= Stime andalso OldTime =< Etime ->
                case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                    #custom_act_cfg{condition = Condition} ->
                        case lib_custom_act_check:check_act_condtion([role_lv], Condition) of
                            [CfgLv] when RoleLv < CfgLv ->
                                Sql = io_lib:format(<<"delete from spec_sell_act where role_id = ~p and sub_type = ~p ">>, [RoleId, SubType]),
                                db:execute(Sql),
                                maps:remove(SubType, AccMap);
                            _ ->
                                AccMap
                        end;
                    _ -> AccMap 
                end;
            _ ->
                case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                    #custom_act_cfg{condition = Condition} ->
                        case lib_custom_act_check:check_act_condtion([role_lv], Condition) of
                            [CfgLv] when RoleLv >= CfgLv ->
                                Sql = io_lib:format(<<"replace into spec_sell_act(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, SubType, NowTime]),
                                db:execute(Sql),
                                maps:put(SubType, NowTime, AccMap);
                            _ ->
                                AccMap
                        end;
                    _ -> AccMap
                end
        end
         end,
    NewMap = lists:foldl(F1, TmpMap, lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_SPEC_SELL)),
    Player#player_status{spec_sell_act = NewMap}.
