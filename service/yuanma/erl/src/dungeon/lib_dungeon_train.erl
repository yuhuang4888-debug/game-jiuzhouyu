%%-----------------------------------------------------------------------------
%% @Module  :       lib_dungeon_train.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-24
%% @Description:    试炼副本
%%-----------------------------------------------------------------------------
-module (lib_dungeon_train).
-include ("dungeon.hrl").
-include ("server.hrl").
-include ("rec_event.hrl").

-export ([
    dunex_update_dungeon_record/2
    ]).

dunex_update_dungeon_record(PS, ResultData) ->
    #player_status{id = RoleId, dungeon_record = Record} = PS,
    #callback_dungeon_succ{
        dun_id = DunId,
        pass_time = PassTime
    } = ResultData,
    if
        PassTime >= 0 ->
            case maps:get(DunId, Record, []) of
                [{?DUNGEON_REC_UPDATE_TIME, _}|_] ->
                    PS;
                _ ->
                    Data = [{?DUNGEON_REC_UPDATE_TIME, utime:unixtime()}],
                    NewRecord = maps:put(DunId, Data, Record),
                    lib_dungeon:save_dungeon_record(RoleId, DunId, Data),
                    TmpPS = PS#player_status{dungeon_record = NewRecord},
                    case lib_skill:auto_learn_skill(TmpPS, {finish_dun, DunId}) of
                        {ok, NewPS} ->
                            NewPS;
                        _ ->
                            TmpPS
                    end
            end;
        true ->
            PS
    end.

