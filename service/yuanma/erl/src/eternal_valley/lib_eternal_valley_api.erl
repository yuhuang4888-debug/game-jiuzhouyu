%%-----------------------------------------------------------------------------
%% @Module  :       lib_eternal_valley_api
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-01-12
%% @Description:    永恒碑谷API
%%-----------------------------------------------------------------------------
-module(lib_eternal_valley_api).

-include("server.hrl").
-include("def_event.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("boss.hrl").
-include("eternal_valley.hrl").

-compile([export_all]).

%% vip 等级触发
handle_event(Player, #event_callback{type_id = ?EVENT_VIP}) when is_record(Player, player_status) ->
    #player_status{figure = Figure} = Player,
    trigger(Player, {vip, Figure#figure.vip});

%% 升级
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{figure = Figure} = Player,
    trigger(Player, {lv, Figure#figure.lv});

%% 进入/扫荡 副本
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_ENTER, data = #callback_dungeon_enter{dun_type = SubType, count = Count}}) when is_record(Player, player_status) ->
    %% DungeonList = [?DUNGEON_TYPE_SPRITE_MATERIAL, ?DUNGEON_TYPE_COIN],
    DungeonList = ?DUNGEON_NEW_VERSION_MATERIEL_LIST,
    case lists:member(SubType, DungeonList) of
        true ->trigger(Player, {dun, SubType, Count});
        _ -> {ok, Player}
    end;

%% 通关副本
handle_event(Player, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = #callback_dungeon_succ{dun_type = DunType, dun_id = DunId}}) when is_record(Player, player_status) ->
    case DunType of
        ?DUNGEON_TYPE_RUNE2 ->
            Level = lib_dungeon_rune:get_dungeon_level(Player),
            lib_eternal_valley_api:trigger(Player, {rune_dun, Level});
        ?DUNGEON_TYPE_DRAGON ->
            trigger(Player, {dun_dragon, DunId});
        _ -> {ok, Player}
    end;


%% 加入工会
handle_event(Player, #event_callback{type_id = ?EVENT_JOIN_GUILD}) when is_record(Player, player_status)->
    trigger(Player, {guild_join});

%% 战力 变化触发
handle_event(Player, #event_callback{type_id = ?EVENT_COMBAT_POWER}) when is_record(Player, player_status) ->
    #player_status{combat_power = CombatPower} = Player,
    trigger(Player, {combat, CombatPower});

handle_event(Player, _) -> {ok, Player}.

%%kill_mon(IsClsType, BLWhos, Mid) ->
%%    F = fun(T) ->
%%        case T of
%%            #mon_atter{node = Node,id = RoleId} when IsClsType == 1 ->
%%                mod_clusters_center:apply_cast(Node, lib_eternal_valley_api, async_trigger, [RoleId, [{boss, Mid}]]),
%%                mod_clusters_center:apply_cast(Node, lib_eternal_valley_api, async_trigger, [RoleId, [{boss_num, Mid}]]);
%%            #mon_atter{id = RoleId} ->
%%                lib_eternal_valley_api:async_trigger(RoleId, [{boss, Mid}]),
%%                lib_eternal_valley_api:async_trigger(RoleId, [{boss_num, Mid}]);
%%            _ -> skip
%%        end
%%    end,
%%    lists:foreach(F, BLWhos).

%% （跨服）圣域boss击杀
sanctuary_boss(Player) -> trigger(Player, [{boss, ?BOSS_TYPE_KF_SANCTUARY, 1}]).

kill_mon(IsClsType, AtterSign, _AtterId, ServerId, Mid, BLWhos) ->
    BossTypeList = [?BOSS_TYPE_NEW_OUTSIDE, ?BOSS_TYPE_FORBIDDEN],
    case data_boss:get_boss_cfg(Mid) of
        #boss_cfg{type = BossType} ->
            IsInType = lists:member(BossType, BossTypeList);
        _ -> IsInType = false, BossType = 0
    end,
    IsPlayerKill = AtterSign == ?BATTLE_SIGN_PLAYER,
    if
        IsInType andalso IsPlayerKill ->
            [begin
                 case IsClsType of
                     1 ->
                         mod_clusters_center:apply_cast(ServerId, lib_eternal_valley_api, async_trigger, [[PlayerId], [{boss, BossType, 1}]]);
                     0 ->
                         lib_eternal_valley_api:async_trigger([PlayerId], [{boss, BossType, 1}]);
                     _ -> skip
                 end
             end||#mon_atter{id = PlayerId}<-BLWhos];
        true -> skip
    end.

%% 异步触发
async_trigger(RoleId, Args) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_eternal_valley_api, trigger, Args);
async_trigger([], _Args) ->
    skip;

async_trigger([H | L] = PlayerList, Args) when is_list(PlayerList) ->
    lib_player:apply_cast(H, ?APPLY_CAST_SAVE, lib_eternal_valley_api, trigger, Args),
    async_trigger(L, Args);


async_trigger(_PlayerId, _A) -> skip.

trigger(Player, _Args) -> {ok, Player}.
    %case catch do_trigger(Player, Args) of
    %    {ok, NewPlayer} ->
    %        {ok, NewPlayer};
    %    Err ->
    %        ?ERR("eternal valley trigger err:~p", [Err]),
    %        {ok, Player}
    %end.

do_trigger(Player, Args) ->
    case is_tuple(Args) of
        true ->
            #player_status{id = RoleId, figure = Figure, eternal_valley = RoleEternalValley} = Player,
            #figure{lv = RoleLv} = Figure,
            NewRoleEternalValley = lib_eternal_valley:trigger(RoleId, RoleLv, RoleEternalValley, [Args]),
            NewPlayer = Player#player_status{eternal_valley = NewRoleEternalValley},
            {ok, NewPlayer};
        false ->
            {ok, Player}
    end.


fix_config_error() ->
    Sql = <<"select role_id from eternal_valley_stage where chapter = 2 and stage = 7 and progress = 2 and status = 0">>,
    case db:get_all(Sql) of
        [] -> skip;
        RoleIdList ->
            Ids = ulists:list_to_string(lists:flatten(RoleIdList), ","),
            Sql1 = io_lib:format(<<"update eternal_valley_stage set status = 1 where chapter = 2 and stage = 7 and role_id in (~s)">>, [Ids]),
            db:execute(Sql1)
    end,
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, reload_status, []) || E <- OnlineRoles].

reload_status(Ps) ->
    #player_status{id = RoleId} = Ps,
    EternalValley = lib_eternal_valley:login(RoleId),
    NewPs = Ps#player_status{eternal_valley = EternalValley},
    pp_eternal_valley:handle(42401, NewPs, []),
    NewPs.


fix_config_add() ->
    ChapterIds1 = [1,2,3],
    ChapterIds = [{1,200000},{2,14},{3,22}],
    Sql = <<"select role_id, chapter from eternal_valley_chapter where status = 2">>,
    case db:get_all(Sql) of
        [] -> skip;
        RoleChapterList ->
            [begin
                 case lists:keyfind(Chapter, 1, ChapterIds) of
                     {Chapter, Process} ->
                         SqlTmp = <<"insert into `eternal_valley_stage`(`role_id`, `chapter`, `stage`, `progress`, `status`, `extra`) values(~p, ~p, ~p, ~p, ~p, '~s')">>,
                         Sql2 = io_lib:format(SqlTmp, [RoleId, Chapter, 8, Process, 2, ""]),
                         timer:sleep(50),
                         db:execute(Sql2);
                     _ -> skip
                 end
             end||[RoleId, Chapter]<-RoleChapterList, lists:member(Chapter, ChapterIds1)]
    end,
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, ?MODULE, reload_status, []) || E <- OnlineRoles].

