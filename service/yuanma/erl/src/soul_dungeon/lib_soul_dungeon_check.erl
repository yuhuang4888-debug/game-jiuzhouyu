%%%-----------------------------------
%%% @Module      : lib_soul_dungeon_check
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 19. 十一月 2018 14:04
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_soul_dungeon_check).
-author("chenyiming").

%% API
-compile(export_all).
-include("dungeon.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("soul_dungeon.hrl").


%%检查是否可以立即刷新，要处于等待刷新时间内
quik_create_mon(#dungeon_state{common_event_map = CommonEventMap, typical_data = DataMap}) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    CommonEventId = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, DataMap, -1),
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap, []),
    WaveSubtypeMap =
        case CommonEvent of
            [] ->
                #{};
            #dungeon_common_event{wave_subtype_map = _WaveSubtypeMap} ->  %%刷怪事件
                _WaveSubtypeMap
        end,
    WaveSubList = maps:values(WaveSubtypeMap),
    case WaveSubList of
        [] ->
            ?MYLOG("cym", "log1 CommonEventId ~p DataMap ~p ~n", [CommonEventId, DataMap]),
            {false, ?FAIL};
        [WaveSubtypeRecord | _] ->
            #dungeon_wave_subtype{cycle_num = CycleNum, create_time = CreateTime} = WaveSubtypeRecord,
            case CycleNum == 0 andalso CreateTime >= utime:unixtime() of %%循环次数为0， 且创新时间 >= 当前时间
                true ->
                    true;
                false ->
                    ?MYLOG("cym", "CycleNum ~p  CreatTime ~p  now ~p  CommonEventId ~p~n",
                        [CycleNum, CreateTime, utime:unixtime(), CommonEventId]),
                    {false, ?FAIL}
            end;
        _ ->
            ?MYLOG("cym", "log2 CommonEventId ~p DataMap ~p ~n", [CommonEventId, DataMap]),
            {false, ?FAIL}
    end.


%%检查能否创建怪物  2是否是处于刷新时间
create_mon(#dungeon_state{common_event_map = CommonEventMap, typical_data = DataMap, end_time = _EndTime}) ->
    BelongType = ?DUN_EVENT_BELONG_TYPE_MON,
    CommonEventId = maps:get(?DUN_ROLE_SPECIAL_KEY_MON_COMMON_EVENT_ID, DataMap, -1),
    BossStatus = maps:get(?boss_create_status, DataMap, ?boss_can_create),
    CommonEvent = maps:get({BelongType, CommonEventId}, CommonEventMap, []),
    WaveSubtypeMap =
        case CommonEvent of
            [] ->
                #{};
            #dungeon_common_event{wave_subtype_map = _WaveSubtypeMap} ->  %%刷怪事件
                _WaveSubtypeMap
        end,
    WaveSubList = maps:values(WaveSubtypeMap),
    case WaveSubList of
        [] ->
            {false, ?FAIL};
        [_WaveSubtypeRecord | _] ->
            case BossStatus of
                ?boss_can_create ->  %%可以创建boss怪
                    true;
                ?boss_can_not_create ->
                    {false, ?ERRCODE(err215_yet_create_boss)}  %%
            end;
        _ ->
            {false, ?FAIL}
    end.



check_sweep(Player, Dun, AutoNum, DailyList) ->
    #dungeon{id = DunId, type = DunType, sweep_lv = Lv,
        count_cond = CountCondition} = Dun,
    #player_status{figure = #figure{lv = RoleLv, vip = VipLv, vip_type = VipType}, dungeon_record = Rec, id = RoleId} = Player,
    case maps:find(DunId, Rec) of
        {ok, _RecData} ->
            IsFinish = true;
        _ ->
            IsFinish = false
    end,
    Count = mod_counter:get_count(Player#player_status.id, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId),
    if
        Lv =:= 0 ->
            {false, ?ERRCODE(err610_sweep_limit_error)};
        RoleLv < Lv ->
            {false, ?ERRCODE(err150_lv_not_enough)};
    % 没有挑战过以及没有记录
        Count =< 0  ->
            {false, ?ERRCODE(err215_sweep_never_finish)};
        true ->
            case lib_dungeon_sweep:check_sweep_count(RoleId, VipType, VipLv, DunId, DunType, AutoNum, DailyList, CountCondition) of
                true ->
                    true;
                Error ->
                    Error
            end
    end.

%%一般性检查
common_check(#player_status{scene = SceneId, copy_id = DunPid} = _Ps) ->
    CheckList = [
        {is_in_scene, SceneId},   %%场景检查
        {is_pid, DunPid}
    ],
    check_list(CheckList).

sweep(#player_status{id = _RoleId}, _DunId, _Time, BossNum) ->
    CheckList = [
        {boss_num, BossNum}   %%boss次数限制
    ],
    check_list(CheckList).
check_list([]) ->
    true;
check_list([H | CheckList]) ->
    case check(H) of
        true ->
            check_list(CheckList);
        {false, Res} ->
            {false, Res}
    end.


check({is_in_scene, SceneId}) ->
    SoulDunSceneId =
        case data_soul_dungeon:get_value_by_key(scene_id) of
            [_V] ->
                _V;
            _ ->
                0
        end,
    case SoulDunSceneId == SceneId of
        true ->
            true;
        false ->
            {false, ?ERRCODE(err215_not_in_soul_scene)}
    end;

check({is_pid, DunPid}) ->
    case is_pid(DunPid) of
        true ->
            true;
        false ->
            {false, ?FAIL}
    end;




check({boss_num, BossNum}) ->
    WaveNum  =
        case  data_soul_dungeon:get_value_by_key(wave_num) of
            [_V] ->
                _V;
            _ ->
                0
        end,
    case WaveNum >= BossNum of
        true ->
            true;
        false ->
            {false, ?ERRCODE(err215_err_sweep_boss_num)}
    end;


check(_H) ->
    true.



%%复活前的检查
check_revive(Player, ?REVIVE_SOUL_DUNGEON) ->
    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    case IsOnDungeon of
        true ->
            case lib_dungeon:get_revive_info(Player) of
                {false, ErrorCode} ->
                    {false, ErrorCode};
                {true, _NextReiveTime} ->
                    true  %%没有冷却时间限制
            end;
        false ->
            true
    end;
check_revive(_Status, _) ->
    true.