%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_tower.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-09-20
%% @deprecated 爬塔副本
%% ---------------------------------------------------------------------------
-module(lib_dungeon_tower).

%% 回调函数
-export([
    dunex_calc_record_score/2
        , dunex_update_dungeon_record/2
    ]).

%% 其他接口
-export([
        get_dungeon_level/2
    ]).

-compile(export_all).
-include("dungeon.hrl").
-include("server.hrl").
-include ("rec_event.hrl").
-include("def_module.hrl").
-include("common.hrl").

dunex_calc_record_score(_DunId, RecData) ->
    case lists:keyfind(?DUNGEON_REC_SCORE, 1, RecData) of
        {?DUNGEON_REC_SCORE, Score} ->
            Score;
        _ -> 0
    end.

dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = DunId, 
        dun_type = DunType,
        pass_time = PassTime
    } = ResultData,
    % ?MYLOG("hjhtower", "PassTime:~p DunId:~p DunType:~p ~n", [PassTime, DunId, DunType]),
    if
        PassTime >= 0 ->
            case maps:get(DunId, Record, []) of
                [{?DUNGEON_REC_PASSTIME, OldPassTime}|_] when OldPassTime =< PassTime ->
                    PS;
                _ ->
                    Score = lib_dungeon:get_time_score(DunId, PassTime),
                    Data = [{?DUNGEON_REC_PASSTIME, PassTime}, {?DUNGEON_REC_SCORE, Score}],
                    NewRecord = maps:put(DunId, Data, Record),
                    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
                    NewPS = PS#player_status{dungeon_record = NewRecord},
                    lib_common_rank_api:refresh_rank_by_dun(NewPS, DunType),
                    Level = lib_dungeon_api:get_dungeon_level(NewPS, DunType),
                    lib_task_api:fin_dun_level(RoleId, DunType, Level),
                    NewPS
            end;
        true ->
            PS
    end.

%% 获得副本通关的关卡
get_dungeon_level(Player, DunType) ->
    #player_status{dungeon_record = Rec} = Player,
    Ids = data_dungeon:get_ids_by_type(DunType),
    lists:foldl(fun
        (Id, Acc) ->
            case maps:is_key(Id, Rec) of
                true ->
                    Acc + 1;
                _ ->
                    Acc
            end
    end, 0, Ids).

%% 设置关卡
gm_set_gate(#player_status{id = RoleId} = Status, DunType, Gate) ->
    Ids = data_dungeon:get_ids_by_type(DunType),
    IdsStr = util:link_list(Ids, ","),
    db:execute(io_lib:format("DELETE FROM `dungeon_best_record` WHERE player_id=~p and dun_id in(~ts)", [RoleId, IdsStr])),
    RecrodList = [{DunId, [{?DUNGEON_REC_PASSTIME, 1}, {?DUNGEON_REC_SCORE, 1}]}||DunId<-lists:sublist(Ids, Gate)],
    lib_dungeon:save_dungeon_record(RoleId, RecrodList),
    mod_counter:clear(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Ids),
    mod_counter:clear(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, Ids),
    CounterL = lists:flatten([[{{?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, Id}, 1}, {{?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, Id}, 1}]||Id<-lists:sublist(Ids, Gate)]),
    mod_counter:set_count(RoleId, CounterL),
    NewPS = lib_dungeon:load_dungeon_record(Status#player_status{dungeon_record = undefined}),
    pp_dungeon:handle(61020, NewPS, [?DUNGEON_TYPE_TOWER]),
    pp_dungeon:handle(61020, NewPS, [?DUNGEON_TYPE_RUNE2]),
    NewPS.