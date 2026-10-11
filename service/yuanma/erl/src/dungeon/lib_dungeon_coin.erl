%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_coin.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-29
%% @Description:    金币副本
%%-----------------------------------------------------------------------------

-module (lib_dungeon_coin).

-include ("dungeon.hrl").
-include("def_fun.hrl").
-include("common.hrl").
-include ("rec_event.hrl").
-include ("server.hrl").

-export ([
    dunex_calc_record_score/2
    ,dunex_update_dungeon_record/2
    ]).


%%用于扫荡的时候，计算评分，用上一次通关评分来计算扫荡评分
dunex_calc_record_score(_DunId, RecData) ->
    case lists:keyfind(?DUNGEON_REC_SCORE, 1, RecData) of
        {?DUNGEON_REC_SCORE, Score} ->
            Score;
        _ -> 0
    end.


%%更新铜币本的记录，用于副本通关时的调用
dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = DunId, 
        pass_time = PassTime
    } = ResultData,
    if
        PassTime >= 0 ->
            case maps:get(DunId, Record, []) of
                [{?DUNGEON_REC_PASSTIME, OldPassTime}|_] when OldPassTime =< PassTime ->
                    PS;
                _ ->
                    Score = lib_dungeon:get_time_score(DunId, PassTime),
                    update_dungeon_record_help(PS, Score, DunId, RoleId, Record, PassTime)
            end;
        true ->
            PS
    end.

update_dungeon_record_help(PS, Score, DunId, RoleId, Record, PassTime) ->
    Data = [{?DUNGEON_REC_PASSTIME, PassTime}, {?DUNGEON_REC_SCORE, Score}],
    NewRecord = maps:put(DunId, Data, Record),
    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),  %%同步到数据库
    PS#player_status{dungeon_record = NewRecord}.