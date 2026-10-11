-module(pp_star_map).
-include("errcode.hrl").
-include("star_map.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("common.hrl").
-export([handle/3]).

handle(42200, PS, []) ->
    #player_status{sid = Sid, star_map_status = StarMapSt,  currency_map = CurrencyMap} = PS,
    #star_map_status{star_map_id = StarMapId, attr = Attr} = StarMapSt,
    StarValue = maps:get(?GOODS_ID_STAR, CurrencyMap, 0),
    send_to_client(Sid, 42200, [StarMapId, StarValue, Attr]),
    {ok, PS};

handle(42201, PS, [StarMapId]) ->
    #player_status{id = RoleId, sid = Sid, star_map_status = StarMapSt, figure = #figure{lv = RoleLv}} = PS,
    #star_map_status{star_map_id = CurStarMapId} = StarMapSt,
    case data_star_map:get_starmap_cfg(StarMapId) of
        StarMapCfg when is_record(StarMapCfg, base_star_map) ->
            #base_star_map{consume = Consume} = StarMapCfg,
            CheckList = [
            {lv_valid, RoleLv}
            ,{has_acti, StarMapId, CurStarMapId}
            ,{can_acti, StarMapId, CurStarMapId}
            ],
            case check(CheckList) of
                success ->
                    case lib_goods_api:cost_object_list_with_check(PS, [{?TYPE_CURRENCY, ?GOODS_ID_STAR, Consume}], star_active, "") of
                        {true, NewPlayerTmp} ->
                            lib_log_api:log_role_star_map(RoleId, [{?TYPE_CURRENCY, ?GOODS_ID_STAR, Consume}],
                                CurStarMapId, StarMapId),
                            NewStarValue = maps:get(?GOODS_ID_STAR, NewPlayerTmp#player_status.currency_map, 0),                
                            TotalAttr = lib_star_map:count_star_map_attr(StarMapId),
                            NewStarMapSt = StarMapSt#star_map_status{star_map_id = StarMapId, attr = TotalAttr},
                            LastPlayer = lib_player:count_player_attribute(NewPlayerTmp#player_status{star_map_status = NewStarMapSt}),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                            send_to_client(Sid, 42201, [?SUCCESS]),
                            send_to_client(Sid, 42200, [StarMapId, NewStarValue, TotalAttr]),
                            %% ------db--------%%
                             db:execute(io_lib:format(?sql_replace_star_map, [RoleId, StarMapId])),
                            {ok, LastPlayer};
                        {false, _, LastPlayer} ->                  
                            send_to_client(Sid,  42201, [?ERRCODE(err422_starvalue_not_enough)]),
                            {ok, LastPlayer}
                    end;
                {fail, Res} ->
                    send_to_client(Sid,  42201, [Res]),
                    {ok,PS}
            end;
        _ ->
            send_to_client(Sid,  42201, [?ERRCODE(err422_cfg_not_exists)]),
            {ok, PS}
    end;

handle(_Code, _PS, _Args) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.

send_to_client(Sid, ProCode, Res) ->
    {ok, BinData} = pt_422:write(ProCode, Res),
    lib_server_send:send_to_sid(Sid, BinData).

check([]) -> success;
check([H|T]) ->
    case do_check(H) of
        success -> check(T);
        {fail, Res} -> {fail, Res}
    end.

do_check({lv_valid, RoleLv}) ->
    if
        RoleLv >= ?STAR_MAP_OPEN_LV -> success;
        true -> {fail, ?ERRCODE(err422_level_invalid)}
    end;

do_check({has_acti, StarMapId, CurStarMapId}) ->
    if
        StarMapId =< CurStarMapId -> {fail, ?ERRCODE(err422_has_acti)};
        true -> success
    end;
do_check({can_acti, StarMapId, CurStarMapId}) ->
    case get_next_star(CurStarMapId) of
        none -> {fail, ?ERRCODE(err422_last_star)};
        NextId ->
            if
                NextId =/= StarMapId -> {fail, ?ERRCODE(err422_cant_acti)};
                true -> success
            end
    end;
do_check({value_enough, Consume, StarValue}) ->
    if
        StarValue >= Consume -> success;
        true -> {fail, ?ERRCODE(err422_starvalue_not_enough)}
    end;
do_check(_Other) ->
    {fail, ?ERRCODE(err422_bad_check)}.

get_next_star(CurStarMapId) ->
    AllCons = lists:usort(data_star_map:get_all_cons()),
    case AllCons == [] of
        false ->
            F = fun(Id, {Flag, Next}) ->
                if
                    Flag == true ->
                        {false, Id};
                    Id == CurStarMapId  ->
                        {true, Next};
                    true ->
                        {Flag, Next}
                end
            end,
            {_, NextId} = lists:foldl(F, {false, none}, AllCons),
            case NextId of
                none -> none;
                _ -> NextId
            end;
        true ->
            none
    end.
