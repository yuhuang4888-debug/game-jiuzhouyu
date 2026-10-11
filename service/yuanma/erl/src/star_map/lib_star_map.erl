-module(lib_star_map).
-include("star_map.hrl").
-include("server.hrl").
-include("figure.hrl").
-compile(export_all).

login(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = RoleLv}} = PS,
    case RoleLv < ?STAR_MAP_OPEN_LV of
        true ->
            PS#player_status{star_map_status = #star_map_status{star_map_id = 1, attr = count_star_map_attr(1)}};
        _ ->
            StarMap = case db:get_row(io_lib:format(?sql_select_star_map, [RoleId])) of
                [StarMapId] ->
                    TotalAttr = count_star_map_attr(StarMapId),
                    #star_map_status{star_map_id = StarMapId, attr = TotalAttr};
                _ ->
                    #star_map_status{star_map_id = 1, attr = count_star_map_attr(1)}
            end,
            PS#player_status{star_map_status = StarMap}
    end.

count_star_map_attr(StarMapId) ->
    case data_star_map:get_starmap_cfg(StarMapId) of 
        #base_star_map{attr = Attr, extra_attr = ExAttr} ->
            TmpAttr = util:combine_list(Attr ++ ExAttr),
            lib_player_attr:partial_attr_convert(TmpAttr);
        _ -> []
    end.


