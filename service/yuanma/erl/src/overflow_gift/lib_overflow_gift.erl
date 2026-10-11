%%-----------------------------------------------------------------------------
%% @Module  :       lib_overflow_gift
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2018-5-21
%% @Description:    超值礼包活动
%%-----------------------------------------------------------------------------
-module(lib_overflow_gift).

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
        figure = #figure{lv = Lv},
        overflow_gift = Maps
    } = Player,
    F = fun
            (#act_info{key = {_, SubType}}, AccMap) ->
                case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG, SubType) of
                    #custom_act_cfg{condition = Conditon} ->
                        case lib_custom_act_check:check_act_condtion([role_lv], Conditon) of
                            [CfgLv] ->
                                case Lv == CfgLv orelse (Lv > CfgLv andalso maps:get(SubType, Maps, false) =:= false) of
                                    true ->
                                        Sql = io_lib:format(<<"replace into overflow_gift(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, SubType, NowTime]),
                                        db:execute(Sql),
                                        maps:put(SubType, NowTime, AccMap);
                                    false -> AccMap
                                end;
                            _ -> ?ERR("cfg err!~n", []), AccMap
                        end;
                    _ -> ?ERR("cfg err!~n", []), AccMap
                end
        end,
    NewMaps = lists:foldl(F, Maps, lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG) ),
    NewPlayer = Player#player_status{overflow_gift = NewMaps},
    {ok, NewPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

%% 登录处理
%% return:  #player_status{}
login(Player) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = Player,
    Lists = db:get_all(io_lib:format(<<"select sub_type, lv_time from overflow_gift where role_id = ~p">>, [RoleId])),
    F = fun([SubType, Time], AccMap) ->
        maps:put(SubType, Time, AccMap)
        end,
    TmpMap = lists:foldl(F, #{}, Lists),
    F1 = fun(#act_info{key = {Type, SubType}, stime = Stime, etime = Etime}, AccMap) ->
            case maps:get(SubType, AccMap, false) of
                OldTime when OldTime >= Stime andalso OldTime =< Etime ->
                    AccMap;
                _ ->
                    case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
                        #custom_act_cfg{condition = Condition} ->
                            case lib_custom_act_check:check_act_condtion([role_lv], Condition) of
                                [CfgLv] when RoleLv >= CfgLv ->
                                    Sql = io_lib:format(<<"replace into overflow_gift(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, SubType, NowTime]),
                                    db:execute(Sql),
                                    maps:put(SubType, NowTime, AccMap);
                                _ ->
                                    AccMap
                            end;
                        _ ->
                            ?ERR("cfg err!~n", []), AccMap
                    end
            end
        end,
    NewMap = lists:foldl(F1, TmpMap, lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_TYPE_OVERFLOW_GIFTBAG)),
    Player#player_status{overflow_gift = NewMap}.

gm_repair() ->
    spawn(fun()->
        TDelIdL1 = db:get_all(<<"select id from player_low where lv < 290">>),
        TDelIdL2 = db:get_all(<<"select id from player_low where lv < 320">>),
        TChgIdL = db:get_all(<<"select id from player_low where lv >= 320">>),
        DelIdL1 = lists:flatten(TDelIdL1),
        DelIdL2 = lists:flatten(TDelIdL2),
        ChgIdL = lists:flatten(TChgIdL),
        F = fun
                (RoleId, SubType) ->
                    Pid = misc:get_player_process(RoleId),
                    case misc:is_process_alive(Pid) of
                        true ->
                            lib_player:apply_cast(Pid, 3, ?MODULE, gm_delete, [SubType]);
                        _ ->
                            Sql = io_lib:format(<<"delete from overflow_gift where role_id = ~p and sub_type = ~p ">>, [RoleId, SubType]),
                            db:execute(Sql)
                    end,
                    timer:sleep(20)
            end,
        F1 = fun
                 (RoleId) ->
                     Pid = misc:get_player_process(RoleId),
                     case misc:is_process_alive(Pid) of
                         true ->
                             lib_player:apply_cast(Pid, 3, ?MODULE, gm_change, []);
                         _ ->
                             Sql = io_lib:format(<<"replace into overflow_gift(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, 2, utime:unixtime()]),
                             db:execute(Sql)
                     end,
                     timer:sleep(20)
             end,
        [F(RoleId, 1)  ||RoleId  <-DelIdL1],
        [F(RoleId, 2)  ||RoleId  <-DelIdL2],
        [F1(RoleId)  ||RoleId  <-ChgIdL]
        end),
    ok.

gm_delete(PS, SubType) ->
    #player_status{id = RoleId, overflow_gift = Map} = PS,
    NewMap = maps:remove(SubType, Map),
    Sql = io_lib:format(<<"delete from overflow_gift where role_id = ~p and sub_type = ~p ">>, [RoleId, SubType]),
    db:execute(Sql),
    {ok, PS#player_status{overflow_gift = NewMap}}.

gm_change(PS) ->
    #player_status{id = RoleId, overflow_gift = Map} = PS,
    NewMap = maps:put(2, utime:unixtime(), Map),
    Sql = io_lib:format(<<"replace into overflow_gift(role_id, sub_type, lv_time) values (~p, ~p, ~p)">>, [RoleId, 2, utime:unixtime()]),
    db:execute(Sql),
    {ok, PS#player_status{overflow_gift = NewMap}}.

