%% ---------------------------------------------------------------------------
%% @doc lib_protect.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-03
%% @deprecated 免战保护
%% ---------------------------------------------------------------------------
-module(lib_protect).

-compile(export_all).

-include("server.hrl").
-include("protect.hrl").
-include("scene.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("attr.hrl").

% get_conifg(T) ->
%     % 特殊

make_record(protect, [SceneType, ProtectTime, UseCount, Utime]) ->
    #protect{scene_type = SceneType, protect_time = ProtectTime, use_count = UseCount, utime = Utime}.

%% 加载保护信息
load_status_protect(RoleId) ->
    DbProtectL = db_role_protect_select(RoleId),
    F = fun(T) ->
       Protect = make_record(protect, T),
       {Protect#protect.scene_type, Protect}
    end,
    ProtectMap = maps:from_list(lists:map(F, DbProtectL)),
    #status_protect{protect_map = ProtectMap}.

%% 使用保护的物品
use_protect_goods(Player, GoodsTypeId, GoodsNum) ->
    case data_goods:get_effect_val(GoodsTypeId, protect_time) of
        {SceneType, AddProtectTime} when SceneType > 0, AddProtectTime > 0 ->
            add_protect_time(Player, SceneType, AddProtectTime*GoodsNum);
        _ ->
            {false, ?ERRCODE(err150_type_err)}
    end.

%% 增加保护时间
%% @return {ok, Player} | {false, ErrCode}
add_protect_time(Player, SceneType, AddProtectTime) ->
    case data_protect:get_protect(SceneType) of
        [] -> {false, ?MISSING_CONFIG};
        #base_protect{} -> do_add_protect_time(Player, SceneType, AddProtectTime)
    end.

do_add_protect_time(Player, SceneType, AddProtectTime) ->
    #player_status{id = RoleId, status_protect = StatusProtect} = Player,
    % 存储保存数据
    #status_protect{protect_map = ProtectMap} = StatusProtect,
    case maps:get(SceneType, ProtectMap, []) of
        [] -> Protect = make_record(protect, [SceneType, 0, 0, 0]);
        Protect -> ok
    end,
    #protect{protect_time = ProtectTime} = Protect,
    NewProtect = Protect#protect{protect_time = ProtectTime+AddProtectTime},
    db_role_protect_replace(RoleId, NewProtect),
    log_protect(RoleId, 1, AddProtectTime, NewProtect),
    NewProtectMap = maps:put(SceneType, NewProtect, ProtectMap),
    NewStatusProtect = StatusProtect#status_protect{protect_map = NewProtectMap},
    NewPlayer = Player#player_status{status_protect = NewStatusProtect},
    % ?MYLOG("hjhprotect", "SceneType:~p, AddProtectTime:~p Old:~p ProtectTime:~p ~n", 
    %     [SceneType, AddProtectTime, ProtectTime, ProtectTime+AddProtectTime]),
    send_protect_time_info(NewPlayer, NewProtect),
    {ok, NewPlayer}.

%% 保护时间更新
send_protect_time_info(Player, Protect) ->
    #protect{scene_type = SceneType, protect_time = ProtectTime} = Protect,
    UseCount = get_use_count(Protect),
    {ok, BinData} = pt_202:write(20204, [SceneType, ProtectTime, UseCount]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 场景保护信息
send_info(Player) ->
    #player_status{status_protect = StatusProtect} = Player,
    #status_protect{protect_map = ProtectMap} = StatusProtect,
    F = fun(SceneType, #protect{protect_time = ProtectTime} = Protect, TmpList) ->
        UseCount = get_use_count(Protect),
        [{SceneType, ProtectTime, UseCount}|TmpList]
    end,
    List = maps:fold(F, [], ProtectMap),
    {ok, BinData} = pt_202:write(20201, [List]),
    % ?MYLOG("hjhprotect", "List:~p ~n", [List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 获得使用时间
get_use_count(#protect{use_count = UseCount, utime = Utime}) ->
    case utime:is_today(Utime) of
        true -> UseCount;
        false -> 0
    end.

%% 使用保护
use_protect(Player, SceneType) ->
    case check_use_protect(Player, SceneType) of
        {false, ErrCode} -> 
            NewProtectTime = 0, NewUseCount = 0,
            PlayerAfUse = Player;
        {supvip_free, Protect, UseCount, AddTime} ->
            ErrCode = {free, ?SUCCESS},
            {ok, PlayerAfUse, NewProtectTime, NewUseCount} = do_use_protect_for_supvip_free(Player, Protect, UseCount, AddTime);
        {true, Protect, UseCount, AddTime} -> 
            ErrCode = ?SUCCESS,
            {ok, PlayerAfUse, NewProtectTime, NewUseCount} = do_use_protect(Player, Protect, UseCount, AddTime)
    end,
    % 使用的返回码
    case ErrCode of
        {free, ErrCodeInt} -> ok;
        ErrCodeInt -> ok
    end,
    {ok, BinData} = pt_202:write(20202, [ErrCodeInt, SceneType, NewProtectTime, NewUseCount]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    % 免费使用的操作
    case ErrCode of
        % 通知次数
        {free, _} -> lib_supreme_vip:send_free_use_pk_safe(PlayerAfUse);
        _ -> skip
    end,
    % ?MYLOG("hjhprotect", "ErrCode:~p SceneType:~p, NewProtectTime:~p NewUseCount:~p ~n", [ErrCode, SceneType, NewProtectTime, NewUseCount]),
    {ok, PlayerAfUse}.

check_use_protect(Player, SceneType) ->
    #player_status{status_protect = StatusProtect, scene = SceneId} = Player,
    #status_protect{protect_map = ProtectMap, scene_type = OldSceneType, end_time = EndTime} = StatusProtect,
    case maps:get(SceneType, ProtectMap, []) of
        [] -> Protect = make_record(protect, [SceneType, 0, 0, 0]);
        Protect -> ok
    end,
    #protect{protect_time = ProtectTime} = Protect,
    NowTime = utime:unixtime(),
    UseCount = get_use_count(Protect),
    BaseProtect = data_protect:get_protect(SceneType),
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> SceneTypeBool = true;
        _ -> SceneTypeBool = false
    end,
    CheckFree = lib_supreme_vip:check_use_protect_free(Player, SceneType),
    if
        is_record(BaseProtect, base_protect) == false -> {false, ?MISSING_CONFIG};
        SceneTypeBool == false -> {false, ?ERRCODE(err202_this_scene_not_to_protect)};
        OldSceneType == SceneType andalso NowTime < EndTime -> {false, ?ERRCODE(err202_have_left_safe_time)};
        UseCount >= BaseProtect#base_protect.use_count -> {false, ?ERRCODE(err202_max_use_count)};
        CheckFree =/= false -> 
            {true, AddTime} = CheckFree,
            {supvip_free, Protect, UseCount, AddTime};
        % 使用时间池的判断
        ProtectTime =< 0 -> {false, ?ERRCODE(err202_no_protect_time)};
        true ->
            #base_protect{use_time = UseTime} = BaseProtect, 
            AddTime = min(ProtectTime, UseTime),
            {true, Protect, UseCount, AddTime}
    end.

do_use_protect_for_supvip_free(Player, Protect, UseCount, AddTime) ->
    PlayerAfSupvip = lib_supreme_vip:use_pk_safe(Player),
    #player_status{id = RoleId, status_protect = StatusProtect, battle_attr = BA} = PlayerAfSupvip,
    % 存储保存数据
    #status_protect{protect_map = ProtectMap} = StatusProtect,
    #protect{scene_type = SceneType, protect_time = ProtectTime} = Protect,
    NowTime = utime:unixtime(),
    NewUseCount = UseCount+1,
    NewProtect = Protect#protect{use_count = NewUseCount, utime = NowTime},
    db_role_protect_replace(RoleId, NewProtect),
    log_protect(RoleId, 2, AddTime, NewProtect),
    NewProtectMap = maps:put(SceneType, NewProtect, ProtectMap),
    EndTime = NowTime + AddTime,
    NewStatusProtect = StatusProtect#status_protect{protect_map = NewProtectMap, scene_type = SceneType, end_time = EndTime},
    % 场景
    #battle_attr{pk = Pk} = BA,
    NewPk = Pk#pk{protect_time = EndTime}, 
    PlayerAfSave = PlayerAfSupvip#player_status{status_protect = NewStatusProtect, battle_attr = BA#battle_attr{pk = NewPk}},
    mod_scene_agent:update(PlayerAfSave, [{pk, NewPk}]),
    lib_scene:broadcast_player_attr(PlayerAfSave, [{11, EndTime}]),
    % ?PRINT("AddTime:~p EndTime:~p ~n", [AddTime, EndTime]),
    {ok, PlayerAfSave, ProtectTime, NewUseCount}.

do_use_protect(Player, Protect, UseCount, AddTime) ->
    #player_status{id = RoleId, status_protect = StatusProtect, battle_attr = BA} = Player,
    % 存储保存数据
    #status_protect{protect_map = ProtectMap} = StatusProtect,
    #protect{scene_type = SceneType, protect_time = ProtectTime} = Protect,
    NewProtectTime = ProtectTime - AddTime,
    NowTime = utime:unixtime(),
    NewUseCount = UseCount+1,
    NewProtect = Protect#protect{use_count = NewUseCount, protect_time = NewProtectTime, utime = NowTime},
    db_role_protect_replace(RoleId, NewProtect),
    log_protect(RoleId, 3, AddTime, NewProtect),
    NewProtectMap = maps:put(SceneType, NewProtect, ProtectMap),
    EndTime = NowTime + AddTime,
    NewStatusProtect = StatusProtect#status_protect{protect_map = NewProtectMap, scene_type = SceneType, end_time = EndTime},
    % 场景
    #battle_attr{pk = Pk} = BA,
    NewPk = Pk#pk{protect_time = EndTime}, 
    NewPlayer = Player#player_status{status_protect = NewStatusProtect, battle_attr = BA#battle_attr{pk = NewPk}},
    mod_scene_agent:update(NewPlayer, [{pk, NewPk}]),
    lib_scene:broadcast_player_attr(NewPlayer, [{11, EndTime}]),
    {ok, NewPlayer, NewProtectTime, NewUseCount}.


%% 保护结束时间
send_protect_info(Player) ->
    #player_status{status_protect = StatusProtect, scene = SceneId} = Player,
    #status_protect{scene_type = SceneType, end_time = EndTime} = StatusProtect,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> RoleEndtime = EndTime;
        _ -> RoleEndtime = 0
    end,
    {ok, BinData} = pt_202:write(20203, [RoleEndtime]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 关闭保护
close_protect(Player, SceneType) ->
    case check_close_protect(Player, SceneType) of
        {false, ErrCode} -> NewPlayer = Player;
        true ->
            ErrCode = ?SUCCESS,
            #player_status{status_protect = StatusProtect, battle_attr = BA} = Player,
            NewStatusProtect = StatusProtect#status_protect{scene_type = 0, end_time = 0},
            % 场景
            #battle_attr{pk = Pk} = BA,
            NewPk = Pk#pk{protect_time = 0}, 
            NewPlayer = Player#player_status{status_protect = NewStatusProtect, battle_attr = BA#battle_attr{pk = NewPk}},
            mod_scene_agent:update(NewPlayer, [{pk, NewPk}]),
            lib_scene:broadcast_player_attr(NewPlayer, [{11, 0}])
    end,
    {ok, BinData} = pt_202:write(20205, [ErrCode, SceneType]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer}.

%% 检查关闭保护
check_close_protect(Player, SceneType) ->
    #player_status{status_protect = StatusProtect, scene = SceneId} = Player,
    #status_protect{scene_type = OldSceneType, end_time = EndTime} = StatusProtect,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> SceneTypeBool = true;
        _ -> SceneTypeBool = false
    end,
    NowTime = utime:unixtime(),
    if
        NowTime > EndTime -> {false, ?ERRCODE(err202_had_close_protect)};
        SceneTypeBool == false -> {false, ?ERRCODE(err202_this_scene_not_to_close)};
        OldSceneType =/= SceneType -> {false, ?ERRCODE(err202_this_scene_type_not_to_close)};
        true -> true
    end.

%% 切换场景
change_scene(Player, EnterSceneId, LeaveSceneId) ->
    #player_status{status_protect = StatusProtect, battle_attr = BA} = Player,
    #status_protect{scene_type = _SceneType, end_time = _EndTime} = StatusProtect,
    #battle_attr{pk = Pk} = BA,
    if
        EnterSceneId == LeaveSceneId -> Player;
        true ->
            % 场景和保护时间校验
            % case data_scene:get(LeaveSceneId) of
            %     #ets_scene{type = SceneType} when EndTime > 0, Pk#pk.protect_time == EndTime -> 
            %         NewStatusProtect = StatusProtect#status_protect{scene_type = 0, end_time = 0},
            %         NewPk = Pk#pk{protect_time = 0}, 
            %         Player#player_status{status_protect = NewStatusProtect, battle_attr = BA#battle_attr{pk = NewPk}};
            %     _ ->
            %         Player
            % end
            NewStatusProtect = StatusProtect#status_protect{scene_type = 0, end_time = 0},
            NewPk = Pk#pk{protect_time = 0}, 
            Player#player_status{status_protect = NewStatusProtect, battle_attr = BA#battle_attr{pk = NewPk}}
    end.

%% 获得保护时间
get_scene_protect_time(Player) ->
    #player_status{status_protect = StatusProtect, scene = SceneId} = Player,
    #status_protect{scene_type = SceneType, end_time = EndTime} = StatusProtect,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} -> EndTime;
        _ -> 0
    end.

%% 免战保护日志
%% @param Type 
%%  1 => 增加
%%  2 => 免费
%%  3 => 消耗
log_protect(RoleId, Type, Value, Protect) ->
    #protect{scene_type = SceneType, protect_time = ProtectTime} = Protect,
    UseCount = get_use_count(Protect),
    lib_log_api:log_protect(RoleId, Type, Value, SceneType, ProtectTime, UseCount),
    ok.

%% ----------------------------------------------------
%% 数据库
%% ----------------------------------------------------

%% 获取场景保护
db_role_protect_select(RoleId) ->
    Sql = io_lib:format(?sql_role_protect_select, [RoleId]),
    db:get_all(Sql).

%% 保存场景保护
db_role_protect_replace(RoleId, Protect) ->
    #protect{scene_type = SceneType, protect_time = ProtectTime, use_count = UseCount, utime = Utime} = Protect,
    Sql = io_lib:format(?sql_role_protect_replace, [RoleId, SceneType, ProtectTime, UseCount, Utime]),
    db:execute(Sql).

%% ----------------------------------------------------
%% 秘籍
%% ----------------------------------------------------

%% 清理保护时间使用次数
gm_clear_use_count(Player, SceneType) ->
    #player_status{id = RoleId, status_protect = StatusProtect} = Player,
    % 存储保存数据
    #status_protect{protect_map = ProtectMap} = StatusProtect,
    case maps:get(SceneType, ProtectMap, []) of
        [] -> Player;
        #protect{} = Protect ->
            NewProtect = Protect#protect{use_count = 0, utime = 0},
            db_role_protect_replace(RoleId, NewProtect),
            NewProtectMap = maps:put(SceneType, NewProtect, ProtectMap),
            NewStatusProtect = StatusProtect#status_protect{protect_map = NewProtectMap},
            NewPlayer = Player#player_status{status_protect = NewStatusProtect},
            send_info(NewPlayer),
            NewPlayer
    end.