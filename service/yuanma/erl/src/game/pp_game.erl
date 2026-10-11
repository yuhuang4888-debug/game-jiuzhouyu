%% ---------------------------------------------------------------------------
%% @doc pp_game.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-23
%% @deprecated 游戏基础相关
%% ---------------------------------------------------------------------------
-module(pp_game).
-export([handle/3]).

-include("server.hrl").
-include("game.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("subscribe.hrl").
-include("scene.hrl").

%% 获取合服信息
handle(10200, Player, []) ->
    lib_game:send_zone_mod(Player),
    {ok, Player};

%% 获取开服合服时间
handle(10201, Player, []) ->
    lib_game:send_game_info(Player),
    {ok, Player};

%% 系统开关设置列表
handle(10202, Player, [Type]) ->
    #player_status{setting = StatusSetting} = Player,
    #status_setting{setting_map = SettingMap} = StatusSetting,
    F = fun(_Key, Setting, List) ->
        #setting{type = TmpType, subtype = Subtype, is_open = IsOpen} = Setting,
        case TmpType == Type of
            true -> [{Subtype, IsOpen}|List];
            false -> List
        end
    end,
    List = maps:fold(F, [], SettingMap),
    {ok, BinData} = pt_102:write(10202, [Type, List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData);

%% 系统开关设置
handle(10203, Player, [SettingList]) ->
    #player_status{id = RoleId, setting = StatusSetting, copy_id = CopyId} = Player,
    %% 记录日志
    lib_log_api:log_setting(RoleId, SettingList),
    #status_setting{setting_map = SettingMap} = StatusSetting,
    Keys = data_setting:get_keys(),
    F = fun({Type, Subtype, IsOpen}, {FunSettingMap, FunDbList}) ->
        IsKey = lists:member({Type, Subtype}, Keys),
        if
            Type == ?SYS_SETTING andalso Subtype == 22 -> %% 隐藏连天频道开关不保存数据
                {FunSettingMap, FunDbList};
            IsKey ->
                Setting = lib_game:make_record(setting, [Type, Subtype, IsOpen]),
                NewFunSettingMap = maps:put(Setting#setting.key, Setting, FunSettingMap),
                {NewFunSettingMap, [[RoleId, Type, Subtype, IsOpen] | FunDbList]};
            true ->
                {FunSettingMap, FunDbList}
        end
    end,
    {NewSettingMap, DbList} = lists:foldl(F, {SettingMap, []}, SettingList),
    case DbList =/= [] of
        true ->
            Sql = usql:replace(player_setting, [id, type, subtype, is_open], DbList),
            db:execute(Sql);
        false -> skip
    end,
    NewPlayer = Player#player_status{setting = StatusSetting#status_setting{setting_map = NewSettingMap}},
    %% 更新副本里的设置状态
    SysSetting = [Subtype || {Type, Subtype, _IsOpen} <- SettingList, Type == ?SYS_SETTING],
    ToUpdateDunRole = lists:member(?PICK_UP_BLUE, SysSetting) orelse lists:member(?PICK_UP_PURPLE, SysSetting) orelse lists:member(?PICK_UP_ORANGE, SysSetting),
    case lib_dungeon:is_on_dungeon(Player) andalso ToUpdateDunRole of
        true ->
            NewDunSettingMap = lib_game:get_dungeon_role_setting(NewPlayer#player_status.setting),
            mod_dungeon:set_dun_role_setting(CopyId, RoleId, NewDunSettingMap);
        false -> skip
    end,
    ErrorCode = ?SUCCESS,
    {ok, BinData} = pt_102:write(10203, [ErrorCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

%% 系统开关设置
% handle(10203, Player, [Type, Subtype, IsOpen]) when IsOpen >= 0 andalso IsOpen < 256 ->
%     #player_status{id = RoleId, setting = StatusSetting} = Player,
%     #status_setting{setting_map = SettingMap} = StatusSetting,
%     Keys = data_setting:get_keys(),
%     case lists:member({Type, Subtype}, Keys) of
%         true ->
%             ErrorCode = ?SUCCESS,
%             Setting = lib_game:make_record(setting, [Type, Subtype, IsOpen]),
%             lib_game:db_player_setting_replace(RoleId, Setting),
%             NewSettingMap = maps:put(Setting#setting.key, Setting, SettingMap);
%         false ->
%             ErrorCode = ?ERRCODE(err102_setting_key_not_exist),
%             NewSettingMap = SettingMap
%     end,
%     NewPlayer = Player#player_status{setting = StatusSetting#status_setting{setting_map = NewSettingMap} },
%     {ok, BinData} = pt_102:write(10203, [ErrorCode, Type, Subtype, IsOpen]),
%     lib_server_send:send_to_sid(Player#player_status.sid, BinData),
%     {ok, NewPlayer};

%% 上传客户端版本号
handle(10204, Player, [ClientVer]) ->
    NewPlayer = Player#player_status{client_ver = ClientVer},
    {ok, BinData} = pt_102:write(10204, [?SUCCESS]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, NewPlayer};

% %% 订阅信息
% handle(10208, Player, []) ->
%     #player_status{subscribe_type = SubscribeType} = Player,
%     {ok, BinData} = pt_102:write(10208, [SubscribeType]),
%     lib_server_send:send_to_sid(Player#player_status.sid, BinData);

% %% 设置订阅
% handle(10209, #player_status{id = RoleId, accname = Accname, subscribe_type = OldSubscribeType, last_logout_time = LastLogoutTime} = Player, [SubscribeType]) ->
%     case SubscribeType == 0 orelse lists:member(SubscribeType, ?SUBSCRIBE_TYPE_LIST) of
%         true ->
%             NewPlayer = Player#player_status{subscribe_type = SubscribeType},
%             case SubscribeType == 0 of
%                 true ->
%                     lib_subscribe:db_role_subscribe_delete(RoleId),
%                     mod_subscribe:remove_subscribe(OldSubscribeType, Accname);
%                 false ->
%                     lib_subscribe:db_role_subscribe_replace(RoleId, SubscribeType),
%                     mod_subscribe:set_subscribe_type(SubscribeType, Accname, LastLogoutTime)
%             end,
%             {ok, NewPlayer};
%         false ->
%             skip
%     end;

%% 脱离卡死
handle(10210, #player_status{id = RoleId, scene_pool_id = PoolId, copy_id = CopyId} = Player, []) ->
    #player_status{scene = SceneId, x = X, y = Y} = Player,
    Coordinate = [X, Y],
    lib_log_api:log_escape_stuck(RoleId, SceneId, Coordinate),
    case data_scene:get(SceneId) of
        #ets_scene{type = Type} when Type == ?SCENE_TYPE_NORMAL orelse Type == ?SCENE_TYPE_OUTSIDE -> %% 主城和野外才会切场景
            lib_scene:player_change_scene(Player#player_status.id, SceneId, PoolId, CopyId, true, []),
            Code = ?SUCCESS;
        EtsScene when is_record(EtsScene, ets_scene) -> %% 其他场景只会记录坐标点
            Code = ?ERRCODE(err130_escape_not_change_scene);
        _ ->
            Code = ?MISSING_CONFIG
    end,
    {ok, BinData} = pt_102:write(10210, [Code]),
    lib_server_send:send_to_uid(RoleId, BinData);

%% 功能弹窗(登录请求)
handle(10211, PS, []) ->
    NewPS = lib_popup:login(PS),
    {ok, NewPS};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.