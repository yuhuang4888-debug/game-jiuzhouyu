% ---------------------------------------------------------------------------
%% @doc  藏宝图
%% @author xiaoxiang
%% @since  2017-04-24
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_tsmap_util).
-include("server.hrl").
-include("tsmaps.hrl").
-include("attr.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("team.hrl").
-include("goods.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-compile(export_all).

% check_collect(Player, _GoodsId, _SubType, _Status, []) -> {true, Player};
% check_collect(Player, GoodsId, SubType, Status, [H|T]) ->
%     case do_check_collect(Player, GoodsId, SubType, Status, H) of
%         {true, NewPlayer} ->
%             check_collect(NewPlayer, GoodsId, SubType, Status, T);
%         {false, ErrCode, NewPlayer} ->
%             ?PRINT("H:~p ~n", [H]),
%             {false, ErrCode, NewPlayer};
%         {false, ErrCode, NewPlayer, Args} ->
%             ?PRINT("H:~p ~n", [H]),
%             {false, ErrCode, NewPlayer, Args};
%         _R ->
%             ?PRINT("H:~p _R:~p ~n", [H,_R])
%     end.          

% do_check_collect(Player, _GoodsId, SubType, _Status, team_num) ->
%     #player_status{team=#status_team{team_id=TeamId}} = Player,
%     ?IF(SubType==?GOODS_SUBTYPE_FINE, 
%         ?IF(TeamId==0, 
%             {false, ?ERRCODE(err421_6_not_team), Player}, 
%             ?IF(length(lib_team_api:get_mb_ids(TeamId))>=2, 
%                 {true, Player}, 
%                 {false, ?ERRCODE(err421_7_not_num), Player})),
%         {true, Player});

% do_check_collect(Player, GoodsId, SubType, _Status, lv) ->
%     #player_status{figure=#figure{lv=Lv}, team=#status_team{team_id=TeamId}} = Player,
%     case lib_tsmap:get_goods_info(Player, GoodsId) of
%         [] ->
%             ?PRINT("GoodsId:~p ~n", [GoodsId]),
%             {false, ?FAIL, Player};
%         #goods{level=LimitLv} ->
%             ?IF(Lv>=LimitLv, 
%                 ?IF(SubType==?GOODS_SUBTYPE_FINE,
%                     do_check_teammate_lv(Player, lib_team_api:get_mb_ids(TeamId), GoodsId),
%                     {true, Player}),
%                 {false, ?ERRCODE(err421_8_lv_not),Player})
%     end;


% do_check_collect(Player, _GoodsId, SubType, _Status, guild_id) ->
%     ?IF(SubType/=?GOODS_SUBTYPE_MYSTICAL,
%         {true, Player},
%         ?IF(Player#player_status.figure#figure.guild_id/=0,
%             {true, Player},
%             {false, ?ERRCODE(err421_13_not_guild), Player}));

% do_check_collect(Player, GoodsId, SubType, _Status, clue) ->
%     case lib_tsmap:get_pos(Player, GoodsId)of
%         {NewPlayer, _, _Scene, Pos,_} ->
%             ?IF(SubType==?GOODS_SUBTYPE_MYSTICAL,
%                 ?IF(lib_tsmap:check_pos_enough(Pos),
%                     {true, NewPlayer}, 
%                     {false, ?ERRCODE(err421_5_clue_not_enough), Player }),
%                 {true, NewPlayer});
%         NewPlayer ->    
%             {false, ?FAIL, NewPlayer}      
%     end;

% %% 检测玩家坐标是否满足采集条件 
% do_check_collect(Player, GoodsId, SubType, _Status, xy) ->
%     #player_status{id=RoleId, team=#status_team{team_id=TeamId}} = Player,
%     case lib_tsmap:get_pos(Player, GoodsId)of
%         {NewPlayer, _, PosScene, Pos, _} ->
%             case SubType of
%                 ?GOODS_SUBTYPE_NORMAL ->
%                     case Pos of
%                         [{_,PosX, PosY, _,_}] ->
%                            do_check_teammate_xy(NewPlayer, [RoleId], PosScene, PosX, PosY);
%                         _R ->
%                             ?PRINT("_R:~p ~n", [_R]),
%                             {false, ?ERRCODE(err421_2_not_xy), NewPlayer}
%                     end;
%                 ?GOODS_SUBTYPE_FINE ->
%                     case Pos of
%                         [{_,PosX, PosY, _,_}] ->
%                             do_check_teammate_xy(NewPlayer, lib_team_api:get_mb_ids(TeamId), PosScene, PosX, PosY);
%                         _R ->    
%                             ?PRINT("R:~p ~n", [_R]),
%                             {false, ?ERRCODE(err421_2_not_xy), NewPlayer}
%                     end;
%                 ?GOODS_SUBTYPE_MYSTICAL ->
%                     case lists:keyfind(1,1,Pos) of
%                         {_,PosX, PosY, _,_} ->
%                            do_check_teammate_xy(NewPlayer, [RoleId], PosScene, PosX, PosY);
%                         _R ->
%                             ?PRINT("_R:~p ~n", [_R]),
%                             {false, ?ERRCODE(err421_2_not_xy), NewPlayer}
%                     end;
%                 _R ->
%                     ?PRINT("R:~p ~n", [_R]),
%                     {false, ?FAIL, NewPlayer}
%             end;
%         _ ->
%             {false, ?FAIL, Player}
%     end;

% %%　检测采集时间
% do_check_collect(Player, GoodsId, SubType, Status, time_status) ->
%     #player_status{status_tsmaps = #status_tsmaps{tsmap_maps=TsmapMaps}} = Player,
%     Tsmap = #tsmap{time=Time} = maps:get(GoodsId, TsmapMaps, #tsmap{}), 
%     Now = utime:unixtime(),
%     case Status of
%         ?TSMAP_COLLECT_START ->
%             NewTsmap = Tsmap#tsmap{time=Now},
%             NewPlayer = Player#player_status{status_tsmaps = #status_tsmaps{tsmap_maps=maps:put(GoodsId, NewTsmap, TsmapMaps)}},
%             {true, NewPlayer};
%         _ ->
%             NeedTime = case SubType of
%                 ?GOODS_SUBTYPE_NORMAL ->
%                     5;
%                 _ ->
%                     10
%             end,
%             case abs(Time+NeedTime-Now)<4 of
%                 true ->
%                     {true, Player};
%                 _ ->
%                     ?PRINT("abs(Time+NeedTime-Now):~p ~n", [abs(Time+NeedTime-Now)]),
%                     {false, ?ERRCODE(err421_3_collec_wrong), Player}
%             end
%     end;
 
% %%　采集结束消耗一张藏宝图 并需要重新刷新最上一张的藏宝图坐标
% do_check_collect(Player, _GoodsId, _SubType, ?TSMAP_COLLECT_START, cost) -> 
%     {true, Player};

% do_check_collect(Player, GoodsId, SubType, ?TSMAP_COLLECT_END, cost) ->    
%     #player_status{id=RoleId, figure=#figure{name=Name},status_tsmaps = #status_tsmaps{tsmap_maps=TsmapMaps}} = Player,
%     Tsmap = #tsmap{pos=Pos} = maps:get(GoodsId, TsmapMaps, #tsmap{}), 
%     case lists:keyfind(1,1,Pos) of
%         {1,X,Y,Role,_} when (Role==0 andalso SubType==?GOODS_SUBTYPE_MYSTICAL) orelse (SubType/=?GOODS_SUBTYPE_MYSTICAL) ->
%             % case catch lib_goods_api:cost_object_list_with_check(Player, [{?TYPE_GOODS, data_tsmaps:get_value(SubType), 1}], tsmap_cost, "tsmap_cost") of
%             case catch lib_goods_api:delete_more_by_list(Player, [{GoodsId, 1}], tsmap_cost) of
%                 1 ->
%                     NewPos=lists:keystore(1,1,Pos, {1,X,Y,RoleId,Name}),
%                     NewPlayer=Player#player_status{status_tsmaps = #status_tsmaps{tsmap_maps=maps:put(GoodsId, Tsmap#tsmap{pos=NewPos}, TsmapMaps)}},
%                     {true, NewPlayer};
%                 ErrCode ->
%                     ?PRINT("false~n", []),
%                     {false, ErrCode, Player}
%             end;
%         {1,_,_,_,_}  ->
%             ?PRINT("false~n", []),
%             {false, ?ERRCODE(err421_15_already_get_tsmap), Player};
%         _ ->
%             ?PRINT("false~n", []),
%             {false, ?FAIL, Player}
%     end;
% do_check_collect(Player, _GoodsId, _SubType, _Status, _) -> {false, ?FAIL, Player}.



% do_check_teammate_xy(Player, [], _Scene, _X, _Y) -> {true, Player};
% do_check_teammate_xy(Player, [MsId|T], Scene, X, Y) ->
%     #player_status{id=RoleId}=Player,
%     ?IF(RoleId==MsId,
%         case chec_xy(Player, Scene, X, Y) of
%             true ->
%                 do_check_teammate_xy(Player, T, Scene, X, Y);
%             _ ->
%                 {false, ?ERRCODE(err421_2_not_xy), Player}
%         end,    
%         case catch lib_player:apply_call(MsId, ?APPLY_CALL_STATUS, ?MODULE, chec_xy, [Scene, X, Y], 1000) of
%             true ->
%                 do_check_teammate_xy(Player, T, Scene, X, Y);
%             {false,  Name} ->
%                 {false, ?ERRCODE(err421_19_not_xy_extra), Player, Name};
%             _ ->
%                 {false, ?FAIL, Player}
%         end).

% chec_xy(Player, Scene, X, Y) ->
%     #player_status{figure=#figure{name=Name}, scene=RoleScene, x=RoleX, y=RoleY} =Player,
%     case RoleScene==Scene andalso abs(RoleX-X)<data_tsmaps:get_value(?TSMAP_CONFIG_XY) andalso abs(RoleY-Y)<data_tsmaps:get_value(?TSMAP_CONFIG_XY) of
%         true ->
%             true;
%         _ ->
%             ?PRINT("config:~p, role:~p ~n", [{Scene, X, Y}, {RoleScene, RoleX, RoleY}]),
%             {false,  Name}
%     end.


% do_check_teammate_lv(Player,[], _GoodsId) -> {true, Player};
% do_check_teammate_lv(Player,[RoleId|T], GoodsId) ->
%     #player_status{id=Id}=Player,
%     ?IF(RoleId==Id, 
%         do_check_teammate_lv(Player,T, GoodsId),
%         case catch lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, ?MODULE, check_lv, [GoodsId], 1000) of
%             true ->
%                 do_check_teammate_lv(Player,T, GoodsId);
%             {false, Name} ->
%                 {false, ?ERRCODE(err421_20_lv_not_extra), Player, Name};
%             _ ->
%                 {false, ?FAIL, Player}
%         end).


% check_lv(Player, GoodsId) ->
%     #player_status{figure=#figure{lv=LV, name=Name}} = Player,
%     case lib_tsmap:get_goods_info(Player, GoodsId) of
%         [] ->
%             ?PRINT("GoodsId:~p ~n", [GoodsId]),
%             {false, ?FAIL, Player};
%         #goods{level=LimitLv} ->
%             ?IF(LV>=LimitLv, true, {false, Name})
%     end.


% % -------------------------------------
% % check_arrive_tsmap(_Player, _RoleId, _Name, _Sid, _X, _Y, _TeamId, []) -> true;
% % check_arrive_tsmap(Player, RoleId, Name, Sid, X, Y, TeamId, [H|T]) ->
% %     case do_check_arrive_tsmap(Player, RoleId, Name, Sid, X, Y, TeamId, H) of
% %         true ->
% %             check_arrive_tsmap(Player, RoleId, Name, Sid, X, Y, TeamId, T);
% %         _ ->
% %             skip
% %     end.

% % do_check_arrive_tsmap(Player, _RoleId, _Name, _Sid, _X, _Y, TeamId, team_id) ->
% %     #player_status{team=#status_team{team_id=TId}} = Player,
% %     TeamId = TId andalso TeamId /= 0;

% do_check_arrive_tsmap(Player, GoodsId,  RoleId, Name, Sid, X, Y) ->
%     #player_status{status_tsmaps=#status_tsmaps{tsmap_maps=TsmapMaps}}=Player,
%     case maps:get(GoodsId, TsmapMaps, false) of
%         #tsmap{scene=Scene, pos=[{Index,RoleX, RoleY, Id, _}]} =Tsmap ->
%             case Sid==Scene andalso abs(RoleX-X)<data_tsmaps:get_value(?TSMAP_CONFIG_XY) andalso abs(RoleY-Y)<data_tsmaps:get_value(?TSMAP_CONFIG_XY) andalso Id == 0 of
%                 true ->
%                     NewPlayer = Player#player_status{status_tsmaps=#status_tsmaps{tsmap_maps=maps:put(GoodsId, Tsmap#tsmap{pos=[{Index,RoleX, RoleY, RoleId, Name}]}, TsmapMaps)}},
%                     {true, NewPlayer, Scene, RoleX, RoleY};
%                 _ ->
%                     false
%             end;
%         _ ->
%             false
%     end.




% %% ---------------------------------dun check----------------------------------------------------------
% do_check_dun(_RoleId, _PreNumFull, _HisTeammate,_DunPid, _Scene, _CopyId, _X, _Y, []) -> true;
% do_check_dun(RoleId, PreNumFull, HisTeammate, DunPid, Scene, CopyId, X, Y, [H|T]) -> 
%     case do_check_dun_help(RoleId, PreNumFull, HisTeammate, DunPid, Scene, CopyId, X, Y, H) of
%         true ->
%             do_check_dun(RoleId, PreNumFull, HisTeammate, DunPid, Scene, CopyId, X, Y, T);
%         {false, ErrCode} ->
%             {false, ErrCode}
%     end.

% do_check_dun_help(RoleId, _PreNumFull, _HisTeammate, _DunPid, _Scene, _CopyId, _X, _Y, scene) ->
%     case lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, lib_scene, is_transferable, []) of
%         {true, 1} ->
%             true;
%         {false, ErrCode} ->
%             {false, ErrCode}
%     end;
% do_check_dun_help(RoleId, _PreNumFull, HisTeammate, _DunPid, _Scene, _CopyId, _X, _Y, his) ->
%     case not lists:member(RoleId, HisTeammate) of
%         true ->
%             true;
%         false ->
%             {false, ?ERRCODE(err421_24_not_enter_again)}
%     end;
% do_check_dun_help(_RoleId, PreNumFull, _HisTeammate, _DunPid, _Scene, _CopyId, _X, _Y, full) ->
%     case PreNumFull == 0 of
%         true ->
%             true;
%         false ->
%             {false, ?ERRCODE(err421_23_team_spill)}
%     end;

% do_check_dun_help(RoleId, _PreNumFull, _HisTeammate, _DunPid, _Scene, _CopyId, _X, _Y, num) ->
%     case mod_daily:lessthan_limit(RoleId, ?MOD_TSMAPS, ?TSMAP_DUN_HELP) of 
%         true ->
%             true;
%         false ->
%             {false, ?ERRCODE(err421_25_dun_num_limit )}
%     end;

% do_check_dun_help(_RoleId, _PreNumFull, _HisTeammate, DunPid, _Scene, _CopyId, _X, _Y, level) ->
%     case catch mod_dungeon:tsmap_dun_level(DunPid) of
%         {IsEnd, Level, IsLevelEnd} ->
%             case Level == 1 andalso IsLevelEnd == ?DUN_IS_LEVEL_END_NO andalso IsEnd == ?DUN_IS_LEVEL_END_NO of
%                 true ->
%                     true;
%                 false ->
%                     {false, ?ERRCODE(err421_26_dun_level)}
%             end;
%         _ ->
%             {false, ?FAIL}
%     end;


% do_check_dun_help(_RoleId, _PreNumFull, _HisTeammate, _DunPid, _Scene, _CopyId, _X, _Y, _) -> {false, ?FAIL}.