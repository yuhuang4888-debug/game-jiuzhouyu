%%%-----------------------------------
%%% @Module  : lib_scene_agent
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.05.17
%%% @Description: 场景管理器
%%%-----------------------------------
-module(lib_scene_agent).
-export([
        get_scene_user/0,
        get_scene_user/1,
        get_scene_user/4,
        send_to_local_area_scene/4,
        send_to_local_scene/2,
        send_to_local_scene/1,
        send_to_group/3,
        clear_scene_room/1,
        clear_scene/0,
        clear_all_process_dict/0,
        put_user/1,
        get_user/1,
        del_user/1,
        save_to_area/4,
        del_to_area/4,
        del_all_area/1,
        get_area/2,
        get_area_num/2,
        save_area_num/3,
        get_scene_id/0,
        get_origin_type/0,
        get_broadcast/0,
        send_to_any_area/3,
        get_area_mark/1,
        change_area_mark/2,
        get_dynamic_eff/1,
        change_dynamic_eff/2,
        get_mon_create_delay/1,
        set_mon_create_delay/2,
        move_send_and_getuser/3,
        move_send_and_getid/3,
        get_all_area_user/2,
        get_all_area_user_by_bd/2,
        get_att_target_info_by_id/1,
        create_mon_on_user/5,
        player_apply_cast/5
    ]).

-export([
        get_trace_info/2,
        get_trace_info_cast/4,
        %% get_scene_user_for_assist/7,
        get_scene_user_pid_area/4,
        get_scene_user_id_pid_area/4,
        get_scene_user_by_condition/4,
        get_boss_bl_who_users/7,   %% 获取boss归属玩家
        get_scene_boss_hurt_user/8,
        get_scene_boss_hurt_user_with_id_list/6,
        timer_call_back/3,
        check_battle_broadcast/2,
        check_move_broadcast/2,
        check_broadcast/3
        ,thorough_sleep/3  %% 彻底睡眠假人
        ,change_mon_attr/3 %%改变怪物战斗分组
        ,clear_collect_mon_msg/1  %%清除采集怪的数据
        , update_scene/2
    ]).

%% 触发事件
-export([
        handle_event/2,
        get_scene_user_test/1,
        get_ets_user_num_test/2
    ]).

-include("scene.hrl").
-include("server.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("common.hrl").
-include("battle.hrl").
-include("dungeon.hrl").
-include("figure.hrl").

%% 获取场景所有玩家数据
get_scene_user() ->
    AllUser = get(),
    [ User || {_Key, User} <- AllUser, is_record(User, ets_scene_user)].

%% 获取场景玩家数据
get_scene_user(CopyId) ->
    AllUser = get_room(CopyId),
    get_scene_user_helper(AllUser, CopyId, []).

get_scene_user(CopyId, X, Y, Area) ->
    AllArea = lib_scene_calc:get_the_area(X, Y),
    AllUser = get_all_area_user(AllArea, CopyId),
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    [ User || User <-AllUser,
        User#ets_scene_user.x >= X2 andalso User#ets_scene_user.x =< X1 andalso 
            User#ets_scene_user.y >= Y2 andalso User#ets_scene_user.y =< Y1].


get_scene_user_helper([], _, Data) ->
    Data;
get_scene_user_helper([Key | T], CopyId, Data) ->
    case get(Key) of
        undefined ->
            del_to_room(CopyId, Key),
            get_scene_user_helper(T, CopyId, Data);
        User ->
            get_scene_user_helper(T, CopyId, [User | Data])
    end. 

%% 获取一定范围内玩家的pid
get_scene_user_pid_area(CopyId, X, Y, Area) ->
    AllArea = lib_scene_calc:get_the_area(X, Y),
    AllUser = get_all_area_user(AllArea, CopyId),
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    [ User#ets_scene_user.pid || User <-AllUser, 
                                 User#ets_scene_user.x >= X2 andalso User#ets_scene_user.x =< X1, 
                                 User#ets_scene_user.y >= Y2 andalso User#ets_scene_user.y =< Y1].

get_scene_user_id_pid_area(CopyId, X, Y, Area) ->
    AllArea = lib_scene_calc:get_the_area(X, Y),
    AllUser = get_all_area_user(AllArea, CopyId),
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    [ [{User#ets_scene_user.id, User#ets_scene_user.server_id}, User#ets_scene_user.pid] 
      || User <-AllUser, 
         User#ets_scene_user.battle_attr#battle_attr.hp > 0, 
         User#ets_scene_user.x >= X2 andalso User#ets_scene_user.x =< X1, 
         User#ets_scene_user.y >= Y2 andalso User#ets_scene_user.y =< Y1].

%% 条件获取
get_scene_user_by_condition(CopyId, X, Y, Condition) ->
    AllArea = lib_scene_calc:get_the_area(X, Y),
    AllUser = get_all_area_user(AllArea, CopyId),
    [ [User#ets_scene_user.id] 
      || User <-AllUser, 
         User#ets_scene_user.battle_attr#battle_attr.hp > 0, check_get_condition(User, Condition)].

check_get_condition(_User, []) -> true;
check_get_condition(User, [{K, V}|Confdition])->
    Bool = case K of 
               team_id ->  
                   User#ets_scene_user.team#status_team.team_id == V;
               _ -> 
                   true 
           end, 
    if 
        Bool -> check_get_condition(User, Confdition);
        true -> false 
    end.

%% 获取boss的归属玩家返回
get_boss_bl_who_users(Pid, X, Y, CurX, CurY, Area, RoleId) ->
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    X3 = CurX + Area,
    X4 = CurX - Area,
    Y3 = CurY + Area,
    Y4 = CurY - Area,
    Users = case get_user(RoleId) of
                #ets_scene_user{x = RX, y = RY} ->
                    if 
                        RX >= X2 andalso RX =< X1 andalso RY >= Y2 andalso RY =< Y1 -> [RoleId];
                        RX >= X4 andalso RX =< X3 andalso RY >= Y4 andalso RY =< Y3 -> [RoleId];
                        true -> []
                    end;
                _ -> []
            end,
    Pid ! {'get_boss_bl_who_users', RoleId, Users}.

%% 获取范围内的玩家
get_scene_boss_hurt_user(Pid, Scene, CopyId, X, Y, CurX, CurY, Area) ->
    case lib_boss:is_in_outside_boss(Scene) orelse lib_boss:is_in_abyss_boss(Scene) 
            orelse lib_boss:is_in_fairy_boss(Scene) of
        true -> 
            AllUser = get_scene_user(CopyId);
        false ->
            AllArea1 = lib_scene_calc:get_the_area(X, Y),
            AllArea2 = lib_scene_calc:get_the_area(CurX, CurY),
            AllArea = AllArea1 ++ [A || A <- AllArea2, lists:member(A, AllArea1) == false],
            AllUser = get_all_area_user(AllArea, CopyId)
    end,
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    X3 = CurX + Area,
    X4 = CurX - Area,
    Y3 = CurY + Area,
    Y4 = CurY - Area,
    UsersIds = [begin 
                    User#ets_scene_user.id 
                end
                || User <-AllUser, 
                   %?PRINT("X:~p, Y:~p, Area:~p x1:~p x2:~p ~n", [X, Y, Area, User#ets_scene_user.x, User#ets_scene_user.y]) == ok,
                   (User#ets_scene_user.x >= X2 andalso User#ets_scene_user.x =< X1
                    andalso User#ets_scene_user.y >= Y2 andalso User#ets_scene_user.y =< Y1) orelse
                   (User#ets_scene_user.x >= X4 andalso User#ets_scene_user.x =< X3
                    andalso User#ets_scene_user.y >= Y4 andalso User#ets_scene_user.y =< Y3)
                ],
    %?PRINT("X:~p, Y:~p, CurX:~p, CurY:~p, Area:~p UsersIds:~p ~n", [X, Y, CurX, CurY, Area, UsersIds]),
    Pid ! {'hurt_remove', UsersIds}.

%% 获得范围内的玩家
get_scene_boss_hurt_user_with_id_list(Pid, CopyId, X, Y, Area, RoleIdList) ->
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    F = fun(RoleId, List) ->
        case get_user(RoleId) of
            #ets_scene_user{x = RolxX, y = RoleY, copy_id = CopyId} = SceneUser when 
                    (RolxX >= X2 andalso RolxX =< X1) andalso
                    (RoleY >= Y2 andalso RoleY =< Y1)  ->
                #ets_scene_user{
                    pid = RolePid, node = Node, server_id = ServerId, server_num = ServerNum, 
                    figure = #figure{name = Name, lv = Lv, mask_id = MaskId}, team = #status_team{team_id = TeamId},
                    world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel, camp_id = Camp, assist_id = AssistId
                } = SceneUser,
                MonAtter = #mon_atter{
                    id = RoleId, pid = RolePid, node = Node, camp_id = Camp,
                    server_id = ServerId, team_id = TeamId, att_sign = ?BATTLE_SIGN_PLAYER, att_lv = Lv,
                    name = Name, server_num = ServerNum, world_lv = WorldLv, server_name = ServerName, mod_level = ModLevel,
                    mask_id = MaskId, assist_id = AssistId
                    },
                [MonAtter|List];
            _ ->
                List
        end
    end,
    MonAtterL = lists:foldl(F, [], RoleIdList),
    % ?PRINT("add_team_mon_atter_list RoleIdList:~p MonAtterL:~p ~n", [RoleIdList, MonAtterL]),
    Pid ! {'add_team_mon_atter_list', MonAtterL}.

%% 给场景玩家发信息
send_to_local_scene(CopyId, Bin) ->
    AllUser = get_room(CopyId),
    F = fun(Key) ->
                case get(Key) of
                    undefined ->
                        del_to_room(CopyId, Key);
                    User ->
                        lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, Bin)
                end
        end,
    [ F(Key) || Key <- AllUser].

send_to_group(CopyId, Group, Bin) ->
    AllUser = get_room(CopyId),
    F = fun(Key) ->
            case get(Key) of
                undefined ->
                    del_to_room(CopyId, Key);
                #ets_scene_user{node = Node, sid = Sid, battle_attr = #battle_attr{group = Group}}->
                    lib_server_send:send_to_sid(Node, Sid, Bin);
                _ ->
                    skip
            end
        end,
    [ F(Key) || Key <- AllUser].

%% 给场景玩家发信息
send_to_local_scene(Bin) ->
    AllUser = get_scene_user(),
    [lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, Bin)|| User <- AllUser],
    ok.

%% 给区域玩家发信息
send_to_local_area_scene(CopyId, X, Y, Bin) ->
    Area = lib_scene_calc:get_the_area(X, Y),
    send_to_any_area(Area, CopyId, Bin).

%% ==========================  mod_scene_agent进程字典数据 ===================================

clear_scene_room(CopyId) -> 
    lib_scene_object_agent:clear_scene_object(0, CopyId, 1),
    AllUser = get_scene_user(CopyId),
    [del_user(Id)|| #ets_scene_user{id=Id} <- AllUser],
    lib_scene_object_agent:del_all_area(CopyId),
    lib_scene_object_agent:del_trace(CopyId),
    lib_scene_object_agent:del_room(CopyId),
    clear_area_mark(CopyId),
    clear_dynamic_eff(CopyId),
    clear_mon_create_delay_ref(CopyId),
    ok.

%% 清理场景数据
clear_scene() -> 
    lib_scene_object_agent:clear_scene_object(0, [], 0), %% stop所有场景对象进程
    clear_all_process_dict(),
    erlang:garbage_collect(),
    ok.

%% 清理场景中所有进程字典数据
clear_all_process_dict() ->
    F = fun({Key, Value}) -> 
        case Key of
            %% 角色
            {user, _} -> erase(Key);
            {area, _} -> erase(Key);
            {area_num, _} -> erase(Key);
            {room, _} -> erase(Key);
            {role_move, _} -> erase(Key);
            {role_battle, _} -> erase(Key);
            %% 场景元素
            {object,  _} -> erase(Key);
            {object_area, _} -> erase(Key);
            {object_room, _} -> erase(Key);
            {object_ai, _} -> erase(Key);
            {coodinate, _} -> erase(Key);
            {scene_area, _} -> erase(Key);
            {scene_eff, _} -> erase(Key);
            %% 其他元素
            block_pos -> erase(Key);
            safe_pos -> erase(Key);
            mon_create_delay -> clear_mon_create_delay_ref_help(Value), erase(Key);
            % node_socket -> erase(Key); % [{Node, RoleIdL, {Nth, Len, RoleIdList}}]
            % scene_id -> erase(Key); % 不可清理
            % scene_origin_type -> erase(Key); % 不可清理
            _ -> skip
        end
    end,
    [F(E)||E <- get()],
    ok.

%% 保存玩家数据
put_user(SceneUser) ->
    #ets_scene_user{id=Id, copy_id=CopyId, x=X, y=Y} = SceneUser,
    PDUserKey ={user, Id},
    IsAdd = case get(PDUserKey) of
        undefined ->
            save_to_room(CopyId, PDUserKey),
            save_to_area(CopyId, X, Y, PDUserKey),
            save_area_num(CopyId, X, Y, 1),
            1;
        #ets_scene_user{copy_id=OldCopyId, x=OldX, y=OldY} ->
            XYNew = lib_scene_calc:get_xy(X, Y),
            XYOld = lib_scene_calc:get_xy(OldX, OldY),
            if 
                CopyId == OldCopyId andalso XYOld == XYNew ->
                    skip;
                true ->
                    del_to_area(OldCopyId, XYOld, PDUserKey),
                    save_to_area(CopyId, XYNew, PDUserKey),
                    lib_scene_calc:save_areas_num(XYOld, XYNew, CopyId)
            end,
            0
    end,
    put(PDUserKey, SceneUser),
    IsAdd.


%% 获取玩家数据
get_user(UserKey) ->
    case get({user, UserKey}) of
        undefined -> [];
        User      -> User
    end.


%% 删除玩家数据
del_user(UserKey) -> 
    PDUserKey = {user, UserKey},
    case get(PDUserKey) of
        undefined -> [];
        #ets_scene_user{copy_id=CopyId, x=X, y=Y} ->
            del_to_room(CopyId, PDUserKey),
            del_to_area(CopyId, X, Y, PDUserKey),
            save_area_num(CopyId, X, Y, -1),
            del_broadcast_data(UserKey),
            erase(PDUserKey)
    end.


%% ==========================  mod_scene_agent进程九宫格数据 ===================================
%% 删除在九宫格
del_to_area(CopyId, X, Y, PDUserKey) ->
    XY = lib_scene_calc:get_xy(X, Y),
    del_to_area(CopyId, XY, PDUserKey).

del_to_area(CopyId, XY, PDUserKey) ->
    PDAreaKey = {area, {XY, CopyId}},
    case get(PDAreaKey) of
        undefined ->
            skip;
        D ->
            D1 = maps:remove(PDUserKey, D),
            case maps:size(D1) of
                0 -> erase(PDAreaKey);
                _ -> put(PDAreaKey, D1)
            end
    end.

%% 删除所有9宫格数据
del_all_area(CopyId) ->
    F = fun(Elem) -> 
                case Elem of
                    {{area, {_, CopyId}}=Key, _} -> erase(Key);
                    {{area_num, {_, CopyId}}=Key, _} -> erase(Key);
                    _ -> skip
                end
        end,
    lists:map(F, get()),
    ok.

%% 添加在九宫格
save_to_area(CopyId, X, Y, PDUserKey) -> 
    XY = lib_scene_calc:get_xy(X, Y),
    save_to_area(CopyId, XY, PDUserKey).

save_to_area(CopyId, XY, PDUserKey) ->
    PDAreaKey = {area, {XY, CopyId}},
    case get(PDAreaKey) of
        undefined ->
            put(PDAreaKey, #{PDUserKey => 0});
        D ->
            put(PDAreaKey, D#{PDUserKey => 0})
    end.

%% 获取9宫格玩家
get_area(XY, CopyId) ->
    case get({area, {XY, CopyId}}) of
        undefined -> [];
        D -> maps:keys(D)
    end.

%% 保存格子玩家数量
save_area_num(CopyId, X, Y, Num) -> 
    XYs = lib_scene_calc:get_the_area(X, Y),
    [save_area_num(XY, CopyId, Num) || XY <- XYs]. 
save_area_num(XY, CopyId, Num) -> 
    PDAreaNumKey = {area_num, {XY, CopyId}},
    case get(PDAreaNumKey) of
        undefined when Num>0 -> put(PDAreaNumKey, Num);
        undefined -> skip;
        OldNum when OldNum+Num =< 0 -> erase(PDAreaNumKey);
        OldNum -> put(PDAreaNumKey, OldNum+Num)
    end.

%% 获取格子玩家数量
get_area_num(XY, CopyId) -> 
    PDAreaNumKey = {area_num, {XY, CopyId}},
    case get(PDAreaNumKey) of
        undefined -> 0;
        Num -> Num
    end.

%% 获得场景id
get_scene_id() -> 
    get(scene_id).

%% 获得场景原点类型
get_origin_type() ->
    get(scene_origin_type).

%% 获得广播
get_broadcast() ->
    SceneId = get(scene_id),
    case data_scene:get(SceneId) of
        #ets_scene{broadcast = Broadcast} -> Broadcast;
        _ -> ?BROADCAST_AREA
    end.
    
%% ==========================  mod_scene_agent进程房间信息 ===================================
%% 保存id
save_to_room(CopyId, PDUserKey) ->
    PDRoomKey = {room, CopyId},
    case get(PDRoomKey) of
        undefined ->
            put(PDRoomKey, #{PDUserKey => 0});
        D ->
            put(PDRoomKey, D#{PDUserKey => 0})
    end.

%% 获取id
get_room(CopyId) ->
    case get({room, CopyId}) of
        undefined -> [];
        D -> maps:keys(D)
    end.

%% 删除id
del_to_room(CopyId, PDUserKey) ->
    PDRoomKey = {room, CopyId},
    case get(PDRoomKey) of
        undefined -> skip;
        D ->
            D1 = maps:remove(PDUserKey, D),
            case maps:size(D1) of
                0 -> erase(PDRoomKey);
                _ -> put(PDRoomKey, D1)
            end
    end.

%% ==========================  mod_scene_agent进程九宫格广播 ===================================
%% 发送消息给部分区域
send_to_any_area(_Area, _CopyId, <<>>) -> [];
send_to_any_area(Area, CopyId, Bin) ->
    F1 = fun(PDUserKey, OneArea) ->
        case get(PDUserKey) of
            undefined ->
                del_to_room(CopyId, PDUserKey),
                del_to_area(CopyId, OneArea, PDUserKey);
            User ->
                if 
                    User#ets_scene_user.online == ?ONLINE_ON orelse User#ets_scene_user.online == ?ONLINE_FAKE_ON -> 
                        lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, Bin);
                    true -> skip
                end
        end
    end,
    % F3 = fun(OneArea, Sum) ->
    %     List = get_area(OneArea, CopyId),
    %     Sum++List
    % end,
    % case get_scene_id() of
    %     34001 -> ?MYLOG("hjhbl", "34001:~p ~n ", [lists:foldl(F3, [], Area)]);
    %     _ -> skip
    % end,
    F2 = fun(OneArea) ->
        List = get_area(OneArea, CopyId),
        [F1(PDUserKey, OneArea) || PDUserKey <- List]
    end,
    [ F2(A) || A <- Area].

%% 移动9宫格广播用
move_send_and_getuser(Area, CopyId, Bin) ->
    lists:foldl(
        fun(A, L) -> 
            List = get_area(A, CopyId),
            %% move_send_and_getuser_loop(List, {CopyId, A}, Bin, []) ++ L 
            move_send_and_getuser_loop(List, {CopyId, A}, Bin, L)
        end, 
        [], Area).

move_send_and_getuser_loop([], _, _,Data) ->
    Data;
move_send_and_getuser_loop([Key | T], {CopyId, A}, Bin, Data) ->
    case get(Key) of
        undefined ->
            del_to_room(CopyId, Key),
            del_to_area(CopyId, A, Key),
            move_send_and_getuser_loop(T, {CopyId, A}, Bin, Data);
        User->
            lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, Bin),
            move_send_and_getuser_loop(T, {CopyId, A}, Bin, [User|Data])
    end.

%% 移动9宫格广播用
move_send_and_getid(Area, CopyId, Bin) ->
    F = fun(Key, A) ->
                case get(Key) of
                    undefined ->
                        del_to_room(CopyId, Key),
                        del_to_area(CopyId, A, Key),
                        0;
                    User ->
                        lib_server_send:send_to_sid(User#ets_scene_user.node, User#ets_scene_user.sid, Bin),
                        User#ets_scene_user.id
                end
        end,
    lists:foldl(
      fun(A, L) -> 
              List = get_area(A, CopyId),
              List1 = [F(Key, A) || Key <- List],
              List1 ++ L 
      end, [], Area).


%% 获取g宫格子玩家信息
get_all_area_user(Area, CopyId) ->
    List = lists:foldl(
             fun(A, L) -> 
                     get_area(A, CopyId) ++ L 
             end, 
             [], Area),
    get_scene_user_helper(List, CopyId, []).

%% 根据广播,获取g宫格子玩家信息
get_all_area_user_by_bd(Area, CopyId) ->
    case get_broadcast() of
        ?BROADCAST_ALL -> get_scene_user(CopyId);
        _ -> get_all_area_user(Area, CopyId)
    end.

%% 获取动态区域
get_area_mark(CopyId) -> 
    PDAreaKey = {scene_area, CopyId},
    case get(PDAreaKey) of
        undefined -> [];
        M -> maps:to_list(M)
    end.

%% 改变动态区域障碍点
%% AreaMarkL: [{AreaId, ClientMark},...]
change_area_mark(CopyId, AreaMarkL) -> 
    PDAreaKey = {scene_area, CopyId},
    case get(PDAreaKey) of
        undefined -> 
            Map = maps:from_list(AreaMarkL),
            put(PDAreaKey, Map);
        M -> 
            Map = maps:from_list(AreaMarkL),
            NewMap = maps:merge(M, Map),
            put(PDAreaKey, NewMap)
    end,
    ok.

%% 移除动态区域障碍点
clear_area_mark(CopyId) -> 
    erase({scene_area, CopyId}).

%% 获取动态场景特效
get_dynamic_eff(CopyId) -> 
    PDAreaKey = {scene_eff, CopyId},
    case get(PDAreaKey) of
        undefined -> [];
        M -> maps:to_list(M)
    end.

%% 改变动态场景特效
%% EffChangeValues = [{EffId, DelOrAdd},...]
change_dynamic_eff(CopyId, EffChangeValues) -> 
    PDAreaKey = {scene_eff, CopyId},
    case get(PDAreaKey) of
        undefined -> 
            Map = maps:from_list(EffChangeValues),
            put(PDAreaKey, Map);
        M -> 
            Map = maps:from_list(EffChangeValues),
            NewMap = maps:merge(M, Map),
            put(PDAreaKey, NewMap)
    end,
    ok.

%% 清理动态场景特效
clear_dynamic_eff(CopyId) -> 
    erase({scene_eff, CopyId}).

%% 获得怪物创建延迟
get_mon_create_delay(CopyId) ->
    Key = {mon_create_delay, CopyId},
    case get(Key) of
        undefined -> [];
        RefL -> RefL
    end.

%% 获得怪物创建延迟
set_mon_create_delay(CopyId, RefL) ->
    Key = {mon_create_delay, CopyId},
    put(Key, RefL).

%% 清理怪物创建延迟定时器
clear_mon_create_delay_ref(CopyId) ->
    case get({mon_create_delay, CopyId}) of
        undefined -> skip;
        RefL -> clear_mon_create_delay_ref_help(RefL)
    end.

% (怪物死亡触发创建怪物ai)防止延迟期间清理了场景导致产出怪物,所以无法用进程处理,只能去场景进程处理
clear_mon_create_delay_ref_help(RefL) when is_list(RefL) ->
    [util:cancel_timer(Ref)||Ref<-RefL];
clear_mon_create_delay_ref_help(_) ->
    skip.

%% 获取玩家部分数据
get_trace_info(Sign, Id) -> 
    case Sign of
        ?BATTLE_SIGN_PLAYER -> 
            case get_user(Id) of
                #ets_scene_user{battle_attr=BA, x=X, y=Y} when BA#battle_attr.hp > 0 andalso
                                                               BA#battle_attr.hide == 0 andalso BA#battle_attr.ghost == 0 -> {BA#battle_attr.hp, X, Y};
                _ -> false
            end;
        _ -> 
            case lib_scene_object_agent:get_object(Id) of
                #scene_object{battle_attr=BA, x=X, y=Y} when BA#battle_attr.hp > 0 andalso
                                                             BA#battle_attr.hide == 0 andalso BA#battle_attr.ghost == 0 -> {BA#battle_attr.hp, X, Y};
                _ -> false
            end
    end.

get_trace_info_cast(From, Sign, Id, Args) ->
    case get_trace_info(Sign, Id) of
        {_Hp, X, Y} ->
            From ! {'trace_info_back', [Id, X, Y, Args]};
        _ ->
            From ! {'trace_info_back', false}
    end.

%% 怪物追踪目标时获取目标信息
get_att_target_info_by_id([MonAid, Key, AttType, MonGroup]) ->
    AttInfo = case get_user(Key) of
                  Player when is_record(Player, ets_scene_user), Player#ets_scene_user.battle_attr#battle_attr.hp > 0 -> 
                      case (MonGroup == 0 orelse MonGroup /= Player#ets_scene_user.battle_attr#battle_attr.group) andalso 
                          Player#ets_scene_user.battle_attr#battle_attr.ghost =/= 1 of
                          true -> 
                              X0 = Player#ets_scene_user.x,
                              Y0 = Player#ets_scene_user.y,
                              Hp0 = Player#ets_scene_user.battle_attr#battle_attr.hp,
                              {true, X0, Y0, Hp0, Player};
                          false ->
                              false
                      end;
                  _ ->
                      false
              end,
    mod_mon_active:trace_info_back(MonAid, AttType, AttInfo).

%% 定时器返回
timer_call_back(TimeRef, [{Sign, Id, EventId, Args}|T], EtsState) -> 
    User = case Sign of
               ?BATTLE_SIGN_PLAYER -> get_user(Id);
               _ -> lib_scene_object_agent:get_object(Id)
           end,
    case User of
        [] -> skip;
        _  -> lib_battle:timer_call_back(User, EventId, Args, EtsState, TimeRef)
    end,
    timer_call_back(TimeRef, T, EtsState);
timer_call_back(_TimeRef, [], _) -> ok.


%% 根据人数判断是否可广播
check_battle_broadcast(RoleCount, UserId) -> 
    %% Interval = 2,
    Interval = if
                   RoleCount =:= undefined -> true;
                   RoleCount =<  12        -> true; %% 28
                   RoleCount =<  34        -> 2;
                   RoleCount =<  45        -> 3;
                   RoleCount =<  54        -> 5;
                   RoleCount =<  69        -> 8;
                   RoleCount =<  88        -> 13;
                   RoleCount =< 112        -> 21;
                   RoleCount =< 142        -> 34;
                   RoleCount =< 181        -> 55;
                   true -> false
               end,
    case Interval of
        true  -> true;
        false -> false;
        _     -> check_broadcast(role_battle, UserId, Interval)
    end.

%% 检查移动是否广播
%% 与战斗广播数计算相同公式
%% F(800).
check_move_broadcast(RoleCount, UserId) -> 
    %% Interval = 2,
    Interval = if
                   RoleCount =:= undefined -> true;
                   RoleCount =<  28        -> true;
                   RoleCount =<  40        -> 2;
                   RoleCount =<  48        -> 3;
                   RoleCount =<  63        -> 5;
                   RoleCount =<  80        -> 8;
                   RoleCount =< 101        -> 13;
                   RoleCount =< 129        -> 21;
                   RoleCount =< 164        -> 34;
                   RoleCount =< 209        -> 55;
                   true -> false
               end,
    case Interval of
        true  -> true;
        false -> false;
        _     -> check_broadcast(role_move, UserId, Interval)
    end.

%% 检查是否广播（主要针对广播和战斗消息，在线高时量比较大）
%% Key      : role_move | role_battle
%% UserId   : 角色id
%% Interval : 间隔
check_broadcast(Key, UserId, Interval) ->
    {N, LastInterval} = case get({Key, UserId}) of
                            {_, _} = Info -> Info;
                            _ -> {0, 0}
                        end,
    if
        LastInterval =/= Interval ->
            put({Key, UserId}, {1, Interval}),
            true;
        N rem Interval =:= 0 ->
            put({Key, UserId}, {1, Interval}),
            true;
        true ->
            put({Key, UserId}, {N + 1, Interval}),
            false
    end.

del_broadcast_data(UserId) -> 
    erase({role_move, UserId}),
    erase({role_battle, UserId}).

create_mon_on_user(CopyId, Data, Mid, IsActive, OtherArgs) ->
    [OX, OY, Distance, N] = Data,
    Users = get_scene_user(CopyId, OX, OY, Distance),
    LuckyUsers = urand:get_rand_list(N, Users),
    [lib_mon:async_create_mon(Mid, Scene, ScenePoolId, X, Y, IsActive, CopyId, 1, OtherArgs) || #ets_scene_user{scene = Scene, scene_pool_id = ScenePoolId, x = X, y = Y} <- LuckyUsers].


%% 对场景里的玩家执行lib_player:apply_cast/5
player_apply_cast(CopyId, CastType, Module, Fun, Args) ->
    Users = get_scene_user(CopyId),
    [begin
         if 
             Node =:= none ->
                 lib_player:apply_cast(Pid, CastType, Module, Fun, Args);
             true ->
                 rpc:cast(Node, lib_player, apply_cast, [Pid, CastType, Module, Fun, Args])
         end
     end || #ets_scene_user{pid = Pid, node = Node} <- Users].

%% ========================== 其他 ===================================

%% 触发事件
handle_event(hp_change, [OldSceneUser, NewSceneUser]) ->
    #ets_scene_user{scene = SceneId, copy_id = CopyId, battle_attr = #battle_attr{hp=NewHp, hp_lim = HpLim} } = NewSceneUser,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when SceneType==?SCENE_TYPE_DUNGEON orelse SceneType==?SCENE_TYPE_MAIN_DUN ->
            case get({dungeon_hp_rate, CopyId}) of
                undefined -> skip;
                HpRateList -> 
                    #ets_scene_user{battle_attr = #battle_attr{hp=OldHp} } = OldSceneUser,
                    HpR1 = NewHp/HpLim,
                    HpR2 = OldHp/HpLim,
                    F = fun(EventHp) -> (EventHp>=HpR1 andalso EventHp=<HpR2) orelse (EventHp>=HpR2 andalso EventHp=<HpR1) end,
                    case lists:filter(F, HpRateList) of
                        [] -> skip;
                        FilterHpRateList -> 
                            put({dungeon_hp_rate, CopyId}, HpRateList -- FilterHpRateList),
                            EventData = #dun_callback_role_hp{hp_rate_list = FilterHpRateList},
                            mod_dungeon:dispatch_dungeon_event(CopyId, ?DUN_EVENT_TYPE_ID_ROLE_HP, EventData)
                    end
            end;
        _ ->
            skip
    end;

handle_event(_, _) ->
    skip.

%% ================================= 测试输出不要调用 =================================
%% 测试输出方法
%% 获取场景玩家数据
get_scene_user_test(CopyId) ->
    AllUser = get_room(CopyId),
    case AllUser of 
        [] -> {[], 0};
        [U|_] -> {U, length(AllUser)}
    end.

%% ets表人数统计
get_ets_user_num_test(SceneId, PoolId)->
    EtsRoleNum = 
        if 
            PoolId == all ->
                case ets:match_object(?ETS_SCENE_LINES, #ets_scene_lines{scene=SceneId, _='_', _='_'}) of
                    [] -> 
                        0;
                    SceneList ->
                        F = fun(Info, TNum) ->
                                    #ets_scene_lines{lines = NumMaps} = Info,
                                    NewList = [Num || {_N, {Num, _Id, _Time}} <- maps:to_list(NumMaps)],
                                    lists:sum(NewList) + TNum
                            end,
                        lists:foldl(F, 0, SceneList)
                end;
            true ->
                case ets:match_object(?ETS_SCENE_LINES,
                                      #ets_scene_lines{scene=SceneId, 
                                                            pool_id=PoolId, _='_'}) of
                    [] -> 0;
                    [Info|_] ->
                        #ets_scene_lines{lines = NumMaps} = Info,
                        NewList = [Num || {_N, {Num, _Ids, _Time}} <- maps:to_list(NumMaps)],
                        lists:sum(NewList)
                end
        end,
    PoolId1 = if PoolId == all -> 0; true -> PoolId end,
    L = mod_scene_agent:apply_call(SceneId, PoolId1, lib_scene_agent, get_scene_user, []),
    SecenUserLen = length(L),
    {EtsRoleNum, SecenUserLen}.

%%彻底休眠假人
thorough_sleep(Scene, ScenePool, AutoId) ->
    mod_scene_agent:apply_cast_with_state(Scene, ScenePool, lib_scene_object, thorough_sleep, [AutoId]).
%%改变怪物的属性
change_mon_attr(SceneId, ScenePool, KeyValueList) ->
    mod_scene_agent:apply_cast_with_state(SceneId, ScenePool, lib_scene_object, change_mon_attr, [KeyValueList]).


clear_collect_mon_msg(RoleId) ->
    User = lib_scene_agent:get_user(RoleId),
    case lib_scene_agent:get_user(RoleId) of
        #ets_scene_user{} ->
            NewUser1 = lib_battle:interrupt_collect_force(User),
            lib_scene_agent:put_user(NewUser1);
        _ ->
            ok
    end.

%% 更新场景数据[场景进程使用]
update_scene([], State) -> State;
update_scene([H|T], State) ->
    case H of
        {broadcast, Broadcast} -> NewState = State#ets_scene{broadcast = Broadcast};
        {origin_type, OriginType} -> 
            put(scene_origin_type, OriginType),
            NewState = State#ets_scene{origin_type = OriginType};
        _ ->
            NewState = State
    end,
    update_scene(T, NewState).
