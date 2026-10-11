%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_pet.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-10-19
%% @Description:    宠物副本特殊逻辑
%%-----------------------------------------------------------------------------

-module (lib_dungeon_pet).
-include ("dungeon.hrl").
-include ("rec_event.hrl").
-include ("server.hrl").

-export ([
    dunex_calc_record_score/2
    ,dunex_update_dungeon_record/2
    ]).

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
        pass_time = PassTime
    } = ResultData,
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
                    PS#player_status{dungeon_record = NewRecord}
            end;
        true ->
            PS
    end.

% calc_score(State, _RoleId) ->
    
