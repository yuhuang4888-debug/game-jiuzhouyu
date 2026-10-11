%%%-----------------------------------
%%% @Module      : lib_title
%%% @Created     : 2019 9.12
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_title).
-include("server.hrl").
-include("title.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("figure.hrl").

%% API
-compile(export_all).

%%登录初始化
login(#player_status{id = RoleId, figure = Figure} = Ps) ->
    {TitleList, EquipTitle, NewAttr} = get_title_info_on_db(RoleId),
    RoleTitle = #title{equip_title = EquipTitle, title_list = TitleList, total_attr = NewAttr},
    Ps#player_status{title = RoleTitle, figure = Figure#figure{title_id = EquipTitle}}.

title_operation(Ps, TitleId) ->
    #player_status{id = RoleId, title = RoleTitle, figure = Figure} = Ps,
    #title{title_list = TitleList} = RoleTitle,
    #figure{lv = RoleLv, name = RoleName} = Figure,
    CheckList = [
        {lv_enougth, RoleLv},
        {title_is_exists, TitleId},
        {can_up_star, Ps, TitleId, RoleTitle}
    ],
    case check(CheckList) of
        true ->
            case lists:keyfind(TitleId, 1, TitleList) of
                {_, Star, Status} ->
                    NewStar = Star+1;
                _ ->
                    NewStar = 0, Star = 0, Status = ?UNACTIVE
            end,
            #base_title_cfg{cost = Cost, name = Name} = data_title:get_title_cfg(TitleId, NewStar),
            case lib_goods_api:cost_object_list(Ps, Cost, title_upgrade_star, [TitleId, NewStar]) of  %%消耗
                {false, Res, NewPs} ->
                    lib_server_send:send_to_uid(RoleId, pt_134, 13403, [Res, TitleId, 0, 0, 0]),
                    {ok, NewPs};
                {true, NewPs} ->
                    if
                        NewStar == 0 -> %% 激活
                            NewEquipId = TitleId,
                            NewStatus = ?EQUIPED,
                            Fun = fun({TemTitle, TemStar, TemStatus}, Acc) ->
                                if 
                                    TemStatus == ?EQUIPED ->
                                        db:execute(io_lib:format(?SQL_UPDATE_TITLE_INFO, [?ACTIVED, TemTitle, RoleId])),
                                        [{TemTitle, TemStar, ?ACTIVED}|Acc];
                                    true ->
                                        [{TemTitle, TemStar, TemStatus}|Acc]
                                end
                            end,
                            NTitleList = lists:foldl(Fun, [], TitleList),
                            NewTitleList = lists:keystore(TitleId, 1, NTitleList, {TitleId, NewStar, NewStatus}),
                            NewAttr = calc_attr(NewTitleList),
                            List = data_title:get_value(need_not_send_tv),
                            case lists:member(TitleId, List) of
                                false ->
                                    lib_chat:send_TV({all}, ?MOD_MEDAL, 1, [RoleName, RoleId, Name, TitleId]);
                                _ ->
                                    skip
                            end,
                            _LastPs = NewPs#player_status{title = RoleTitle#title{equip_title = NewEquipId, title_list = NewTitleList, total_attr = NewAttr}, 
                                    figure = Figure#figure{title_id = NewEquipId}},  %%修改Ps
                            lib_role:update_role_show(RoleId, [{figure, Figure#figure{title_id = NewEquipId}}]),
                            mod_scene_agent:update(_LastPs, [{figure, Figure#figure{title_id = NewEquipId}}]),
                            lib_scene:broadcast_player_attr(NewPs, [{12, NewEquipId}]);
                        true ->
                            NewTitleList = lists:keystore(TitleId, 1, TitleList, {TitleId, NewStar, Status}),
                            NewAttr = calc_attr(NewTitleList),
                            NewStatus = Status,
                            _LastPs = NewPs#player_status{title = RoleTitle#title{title_list = NewTitleList, total_attr = NewAttr}}  %%修改Ps
                    end,
                    %%计算属性
                    LastPs = lib_player:count_player_attribute(_LastPs),
                    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                    %%同步数据库
                    Power = partial_power(TitleId, NewStar, LastPs#player_status.original_attr),
                    db:execute(io_lib:format(?SQL_REPLACE_TITLE_INFO, [RoleId, TitleId, NewStar, NewStatus])),

                    lib_log_api:log_title_info(RoleId, RoleName, TitleId, Star, NewStar, Cost),

                    lib_server_send:send_to_uid(RoleId, pt_134, 13403, [?SUCCESS, TitleId, NewStar, Power, NewStatus]),
                    {ok, LastPs}
            end;
        Errcode ->
            lib_server_send:send_to_uid(RoleId, pt_134, 13403, [Errcode, TitleId, 0, 0, 0])
    end.

title_equip(Ps, TitleId) ->
    #player_status{id = RoleId, title = RoleTitle, figure = Figure} = Ps,
    #title{title_list = TitleList} = RoleTitle,
    #figure{lv = RoleLv} = Figure,
    CheckList = [
        {lv_enougth, RoleLv},
        {title_is_exists, TitleId},
        {can_equip, TitleId, RoleTitle}
    ],
    case check(CheckList) of
        true ->
            {_, Star, _} = lists:keyfind(TitleId, 1, TitleList),
            NewEquipId = TitleId,
            Fun = fun({TemTitle, TemStar, TemStatus}, Acc) ->
                if 
                    TemStatus == ?EQUIPED ->
                        db:execute(io_lib:format(?SQL_UPDATE_TITLE_INFO, [?ACTIVED, TemTitle, RoleId])),
                        [{TemTitle, TemStar, ?ACTIVED}|Acc];
                    true ->
                        [{TemTitle, TemStar, TemStatus}|Acc]
                end
            end,
            NTitleList = lists:foldl(Fun, [], TitleList),
            NewTitleList = lists:keystore(TitleId, 1, NTitleList, {TitleId, Star, ?EQUIPED}),
            _LastPs = Ps#player_status{title = RoleTitle#title{equip_title = NewEquipId, title_list = NewTitleList},
                    figure = Figure#figure{title_id = NewEquipId}},  %%修改Ps

            lib_role:update_role_show(RoleId, [{figure, Figure#figure{title_id = NewEquipId}}]),
            mod_scene_agent:update(_LastPs, [{figure, Figure#figure{title_id = NewEquipId}}]),
            lib_scene:broadcast_player_attr(_LastPs, [{12, NewEquipId}]),
            %%同步数据库
            db:execute(io_lib:format(?SQL_REPLACE_TITLE_INFO, [RoleId, TitleId, Star, ?EQUIPED])),
            lib_server_send:send_to_uid(RoleId, pt_134, 13404, [TitleId, ?SUCCESS]),
            {ok, _LastPs};
        Errcode ->
            lib_server_send:send_to_uid(RoleId, pt_134, 13404, [TitleId, Errcode])
    end.

title_info(Ps) ->
    #player_status{id = RoleId, title = RoleTitle, figure = Figure, original_attr = SumOAttr} = Ps,
    #title{title_list = TitleList} = RoleTitle,
    #figure{lv = RoleLv} = Figure,
    CheckList = [
        {lv_enougth, RoleLv}
    ],
    case check(CheckList) of
        true ->
            List = data_title:get_all_title(),
            Fun = fun(TitleId, Acc) ->
                case lists:keyfind(TitleId, 1, TitleList) of
                    {_, Star, Status} ->
                        Power = partial_power(TitleId, Star, SumOAttr),
                        [{TitleId, Star, Power, Status}|Acc];
                    _ ->
                        Power = expact_power(TitleId, 0, SumOAttr),
                        [{TitleId, 0, Power, 0}|Acc]
                end
            end,
            SendList = lists:foldl(Fun, [], lists:reverse(List)),
            lib_server_send:send_to_uid(RoleId, pt_134, 13405, [SendList]);
        _ ->
            lib_server_send:send_to_uid(RoleId, pt_134, 13405, [[]])
    end.

title_unequip(Ps) ->
    #player_status{id = RoleId, title = RoleTitle, figure = Figure} = Ps,
    #title{equip_title = EquipTitle, title_list = TitleList} = RoleTitle,
    #figure{lv = RoleLv} = Figure,
    CheckList = [
        {lv_enougth, RoleLv},
        {can_unequip, EquipTitle}
    ],
    case check(CheckList) of
        true ->
            Fun = fun({TemTitle, TemStar, TemStatus}, Acc) ->
                if 
                    TemStatus == ?EQUIPED ->
                        db:execute(io_lib:format(?SQL_UPDATE_TITLE_INFO, [?ACTIVED, TemTitle, RoleId])),
                        [{TemTitle, TemStar, ?ACTIVED}|Acc];
                    true ->
                        [{TemTitle, TemStar, TemStatus}|Acc]
                end
            end,
            NewTitleList = lists:foldl(Fun, [], TitleList),
            _LastPs = Ps#player_status{title = RoleTitle#title{equip_title = 0, title_list = NewTitleList},
                    figure = Figure#figure{title_id = 0}},  %%修改Ps

            lib_role:update_role_show(RoleId, [{figure, Figure#figure{title_id = 0}}]),
            mod_scene_agent:update(_LastPs, [{figure, Figure#figure{title_id = 0}}]),
            lib_scene:broadcast_player_attr(_LastPs, [{12, 0}]),
            lib_server_send:send_to_uid(RoleId, pt_134, 13406, [?SUCCESS]),
            {ok, _LastPs};
        Errcode ->
            lib_server_send:send_to_uid(RoleId, pt_134, 13406, [Errcode])
    end.


check([{lv_enougth, RoleLv}|T]) ->
    OpenLv = data_title:get_value(open_lv),
    if
        OpenLv =< RoleLv ->
            check(T);
        true ->
            ?ERRCODE(err331_lv_not_enougth) 
    end;
check([{title_is_exists, TitleId}|T]) ->
    List = data_title:get_all_title(),
    case lists:member(TitleId, List) of
        true -> check(T);
        _ -> ?ERRCODE(title_is_not_exists)
    end;
check([{can_up_star, PS, TitleId, #title{title_list = TitleList}}|T]) ->
    case lists:keyfind(TitleId, 1, TitleList) of
        {_, Star, _} ->
            NewStar = Star+1;
        _ ->
            NewStar = 0
    end,
    case data_title:get_title_cfg(TitleId, NewStar) of
        #base_title_cfg{cost = Cost} -> 
            case lib_goods_api:check_object_list(PS, Cost) of
                true ->
                    check(T);
                {false, Code} ->
                    Code
            end;
        _ -> ?ERRCODE(max_title_star)
    end;
check([{can_equip, TitleId, #title{title_list = TitleList}}|T]) ->
    case lists:keyfind(TitleId, 1, TitleList) of
        {_, _, _} ->
            check(T);
        _ ->
            ?ERRCODE(title_is_not_active)
    end;
check([{can_unequip, EquipTitle}|T]) ->
    case EquipTitle =/= 0 of
        true -> check(T);
        _ -> ?ERRCODE(title_is_not_equip)
    end;
check(_) -> true.

calc_attr(TitleList) ->
    Fun = fun({TitleId, Star, _}, Acc) ->
        case data_title:get_title_cfg(TitleId, Star) of
            #base_title_cfg{attr = Attr} -> 
                Attr ++ Acc;
            _ -> 
                Acc
        end
    end,
    lists:foldl(Fun, [], TitleList).

expact_power(TitleId, Star, SumOAttr) ->
    case data_title:get_title_cfg(TitleId, Star) of
        #base_title_cfg{attr = Attr} -> 
            lib_player:calc_expact_power(SumOAttr, 0, Attr);
        _ -> 
            0
    end.

partial_power(TitleId, Star, SumOAttr) ->
    case data_title:get_title_cfg(TitleId, Star) of
        #base_title_cfg{attr = Attr} -> 
            lib_player:calc_partial_power(SumOAttr, 0, Attr);
        _ -> 
            0
    end.

get_title_info_on_db(RoleId) ->
    Sql = io_lib:format(?SQL_SELECT_TITLE_INFO, [RoleId]),
    List = db:get_all(Sql),
    Fun = fun([TitleId, Star, Status], {Acc, Title, AttrList}) ->
        case data_title:get_title_cfg(TitleId, Star) of
            #base_title_cfg{attr = Attr} -> 
                NewTitle = ?IF(Status == ?EQUIPED, TitleId, Title),
                {[{TitleId, Star, Status}|Acc], NewTitle, Attr ++ AttrList};
            _ -> 
                {Acc, Title, AttrList}
        end
    end,
    {TitleList, EquipTitle, NewAttr} = lists:foldl(Fun, {[], 0, []}, List),
    {TitleList, EquipTitle, NewAttr}.

gm_clear_title(PS) ->
    #player_status{id = RoleId, figure = Figure} = PS,
    lib_role:update_role_show(RoleId, [{figure, Figure#figure{title_id = 0}}]),
    mod_scene_agent:update(PS, [{figure, Figure#figure{title_id = 0}}]),
    lib_scene:broadcast_player_attr(PS, [{12, 0}]),
    db:execute(io_lib:format(?SQL_DELETE_TITLE_INFO, [RoleId])),
    NewPS = PS#player_status{figure = Figure#figure{title_id = 0}, title = #title{equip_title = 0, title_list = [], total_attr = []}},
    title_info(NewPS),
    NewPS.
    
    