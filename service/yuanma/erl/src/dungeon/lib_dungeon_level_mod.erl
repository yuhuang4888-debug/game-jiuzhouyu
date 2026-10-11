%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_level_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-02-14
%% @deprecated 副本关卡处理
%% ---------------------------------------------------------------------------
-module(lib_dungeon_level_mod).
-export([]).

-compile(export_all).

-include("dungeon.hrl").
-include("common.hrl").

%% 获得顺序的场景id
get_order_scene_id(DunId, Level) ->
    SceneIdList = data_dungeon_level:get_scene_id_list(DunId),
    lists:nth(Level, SceneIdList).

%% 根据当前波数重新计算事件Map[注意:特殊副本才需要重新计算]
calc_common_event_map_by_cur_wave(CommonEventMap, CurWave) ->
    F = fun({BelongType, CommonEventId}, CommonEvent, TmpMap) ->
        #dungeon_common_event{args = Args} = CommonEvent,
        case lists:keyfind(wave_no, 1, Args) of
            false -> TmpMap;
            {wave_no, WaveNo} ->
                if
                    BelongType == ?DUN_EVENT_BELONG_TYPE_MON andalso CurWave >= WaveNo -> 
                        maps:remove({BelongType, CommonEventId}, TmpMap);
                    CurWave == 0 -> TmpMap;
                    CurWave+1 == WaveNo -> 
                        NewCommonEvent = CommonEvent#dungeon_common_event{event_list = []},
                        maps:put({BelongType, CommonEventId}, NewCommonEvent, TmpMap);
                    true ->
                        TmpMap
                end
        end
    end,
    maps:fold(F, CommonEventMap, CommonEventMap).
