%% ---------------------------------------------------------------------------
%% @doc lib_player_behavior

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/3 0003
%% @desc    接受协议，封装数据到玩家进程身上，用于后续行为判断
%% ---------------------------------------------------------------------------
-module(lib_player_behavior_data).

%% API
-export([
    router_msg/3
]).

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("attr.hrl").
-include("player_behavior.hrl").

router_msg(PS, Cmd, DataBin) ->
    {ok, Data} = pt_server:read(Cmd, DataBin),
    handle_proto(Cmd, PS, Data).

%% 场景内有玩家移动
handle_proto(12001, PS, [BX, BY, Id, _F, _FX, _FY]) -> user_move(PS, Id, BX, BY);

%% 加载场景
handle_proto(12002, PS, [UserList, MonList, PartnerList, NormalList, DummyList, _MarkList]) ->
    AfUserPS = add_user(PS, UserList),
    AfObjPS = add_object(AfUserPS, MonList++PartnerList++NormalList++DummyList),
    AfEventPS = lib_player_behavior_event:load_scene(AfObjPS),
    AfEventPS;

%% 玩家进入
handle_proto(12003, PS, [User]) -> add_user(PS, [User]);

%% 玩家离开
handle_proto(12004, PS, [Id]) -> delete_user(PS, [Id]);

%% 切换场景,直接加载场景
handle_proto(12005, PS, [_Id, _X, _Y, _ErrCode, _DunId, _Callback, _TransType]) ->
    AfEventPS = lib_player_behavior_event:change_scene(PS),
    pp_scene:handle(12002, AfEventPS, server);

%% 怪物消失
handle_proto(12006, PS, [Id]) -> delete_object(PS, [Id]);

%% 怪物进入视野
handle_proto(12007, PS, [SceneObject]) -> add_object(PS, [SceneObject]);

%% 怪物移动
handle_proto(12008, PS, [X, Y, Id]) -> object_move(PS, Id, X, Y);

%% 加载角色信息
handle_proto(12011, PS, [AddUserList, DelUserIdList]) -> delete_user(add_user(PS, AddUserList), DelUserIdList);

%% 加载怪物信息
handle_proto(12012, PS, [AddMonList, AddPartnerList, AddNormalList, AddDummyList, DelObjectIdList]) ->
    AfAddPS = add_object(PS, AddMonList++AddPartnerList++AddNormalList++AddDummyList),
    delete_object(AfAddPS, DelObjectIdList);

%% 伙伴进入视野
handle_proto(12013, PS, [PartnerList]) -> add_object(PS, [PartnerList]);

%% 一般对象进入视野
handle_proto(12014, PS, [NormalList]) -> add_object(PS, [NormalList]);

%% 假人进入视野
handle_proto(12015, PS, [DummyList]) -> add_object(PS, [DummyList]);

%% 新伙伴进入视野
handle_proto(12016, PS, [CompanionList]) -> add_object(PS, [CompanionList]);

%% 掉落包
handle_proto(12017, PS, [_MonId, _Time, _Scene, _X, _Y, _Boss, DropList]) -> add_drop(PS, DropList);

%% 掉落包
handle_proto(12018, PS, [DropList]) -> add_drop(PS, DropList);

%% 掉落包消失
handle_proto(12019, PS, [DropIdL]) -> delete_drop(PS, DropIdL);

%% 掉落包信息更新
handle_proto(12024, PS, [DropId, RoleId, DropEndTime]) -> change_drop(PS, DropId, RoleId, DropEndTime);

%% 隐藏属性
handle_proto(12070, PS, [?BATTLE_SIGN_PLAYER, Id, Hide]) -> change_user_attr(PS, Id, [{hide, Hide}]);
handle_proto(12070, PS, [_Sign, Id, Hide]) -> change_object_attr(PS, Id, [{hide, Hide}]);

%% 幽灵属性
handle_proto(12071, PS, [?BATTLE_SIGN_PLAYER, Id, Ghost]) -> change_user_attr(PS, Id, [{ghost, Ghost}]);
handle_proto(12071, PS, [_Sign, Id, Ghost]) -> change_object_attr(PS, Id, [{ghost, Ghost}]);

%% 分组属性
handle_proto(12072, PS, [?BATTLE_SIGN_PLAYER, Id, Group]) -> change_user_attr(PS, Id, [{group, Group}]);
handle_proto(12072, PS, [_Sign, Id, Group]) -> change_object_attr(PS, Id, [{group, Group}]);

%% 复活信息
handle_proto(12083, PS, [ReviveType, _ScenceId, _X, _Y, _SceneName, _Hp, _Gold, _BGold, _AttProtectedTime]) ->
    case ReviveType of
        2 -> %% 重新加载场景
            pp_scene:handle(12002, PS, server);
        _ -> %% 原地复活不处理
            skip
    end;

%% 战斗信息
handle_proto(20001, PS, [_AtterType, _Id, _Hp, _Anger, _MoveType, _SkillId, _SkillLv, _AerX, _AerY, _AttX, _AttY, _AttAngle, _AttBuffList, DefList]) ->
    %% 删除血量为0的场景对象
    DelList = [{Sign1, Id1} ||{Sign1, Id1, Hp1, _, _, _, _, _, _, _, _, _} <- DefList, Hp1 == 0],
    {DelUserList, DelMonList} = lists:partition(fun({Sign1, _}) -> Sign1 == ?BATTLE_SIGN_PARTNER end, DelList),
    DelUserIdList = [Id1 || {_, Id1} <- DelUserList],
    DelMonIdList = [Id1 || {_, Id1} <- DelMonList],
    AfUserPS = delete_user(PS, DelUserIdList),
    delete_object(AfUserPS, DelMonIdList);

%% %% 玩家采集结果
handle_proto(20008, PS, [Code]) -> lib_player_behavior:collect_mon_result(PS, Code);

%% %% 玩家采集被打断
handle_proto(20026, PS, [_StopperId]) -> lib_player_behavior:interrupt_collect_mon(PS);

handle_proto(15053, PS, [Res, Args, Status, DropId]) -> lib_player_behavior:pick_up_result(PS, Res, Args, Status, DropId);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    ?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.

%% =============================================== Inner Fun ===============================================

%% 场景角色移动，更新信息
user_move(PS, Id, X, Y) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{user_map = UserMap} = BehaviorStatus,
    NewUserMap =
        case maps:get(Id, UserMap, false) of
            #ets_scene_user{} = User ->
                UserMap#{Id => User#ets_scene_user{x = X, y = Y}};
            _ ->
                UserMap
        end,
    NewBehaviorStatus = BehaviorStatus#player_behavior{user_map = NewUserMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 添加角色
add_user(PS, UserList) ->
    #player_status{behavior_status = BehaviorStatus, id = RoleId} = PS,
    #player_behavior{user_map = UserMap} = BehaviorStatus,
    F = fun(User, AccMap) ->
        #ets_scene_user{id = UserId} = User,
        case RoleId == UserId of
            true -> AccMap;
            _ -> AccMap#{UserId => User}
        end
    end,
    NewUserMap = lists:foldl(F, UserMap, UserList),
    NewBehaviorStatus = BehaviorStatus#player_behavior{user_map = NewUserMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 删除角色
delete_user(PS, UserIdL) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{user_map = UserMap} = BehaviorStatus,
    F = fun(Id, AccMap) -> maps:remove(Id, AccMap) end,
    NewUserMap = lists:foldl(F, UserMap, UserIdL),
    NewBehaviorStatus = BehaviorStatus#player_behavior{user_map = NewUserMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 改变角色属性
change_user_attr(PS, Id, AttrList) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{user_map = UserMap} = BehaviorStatus,
    case maps:get(Id, UserMap, false) of
        #ets_scene_user{} = User ->
            NewUser = do_change_user_attr(User, AttrList),
            NewUserMap = UserMap#{Id => NewUser},
            NewBehaviorStatus = BehaviorStatus#player_behavior{user_map = NewUserMap},
            PS#player_status{behavior_status = NewBehaviorStatus};
        _ -> PS
    end.

do_change_user_attr(User, []) -> User;
do_change_user_attr(User, [{hide, Hide}|T]) ->
    do_change_user_attr(User#ets_scene_user{hide_type = Hide}, T);
do_change_user_attr(#ets_scene_user{battle_attr = BA} = User, [{group, Group}|T]) ->
    do_change_user_attr(User#ets_scene_user{battle_attr = BA#battle_attr{group = Group}}, T);
do_change_user_attr(#ets_scene_user{battle_attr = BA} = User, [{ghost, Ghost}|T]) ->
    do_change_user_attr(User#ets_scene_user{battle_attr = BA#battle_attr{ghost = Ghost}}, T);
do_change_user_attr(User, [_|T]) ->
    do_change_user_attr(User, T).

%% 场景对象移动
object_move(PS, Id, X, Y) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{object_map = ObjectMap} = BehaviorStatus,
    NewObjectMap =
        case maps:get(Id, ObjectMap, false) of
            #scene_object{} = User ->
                ObjectMap#{Id => User#scene_object{x = X, y = Y}};
            _ ->
                ObjectMap
        end,
    NewBehaviorStatus = BehaviorStatus#player_behavior{object_map = NewObjectMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 添加场景对象
add_object(PS, ObjectList) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{object_map = ObjectMap} = BehaviorStatus,
    F = fun(Object, AccMap) ->
        #scene_object{id = ObjectId} = Object,
        AccMap#{ObjectId => Object}
    end,
    NewObjectMap = lists:foldl(F, ObjectMap, ObjectList),
    NewBehaviorStatus = BehaviorStatus#player_behavior{object_map = NewObjectMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 删除场景对象
delete_object(PS, ObjectIdL) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{object_map = ObjectMap} = BehaviorStatus,
    F = fun(Id, AccMap) -> maps:remove(Id, AccMap) end,
    NewObjectMap = lists:foldl(F, ObjectMap, ObjectIdL),
    NewBehaviorStatus = BehaviorStatus#player_behavior{object_map = NewObjectMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 改变对象属性
change_object_attr(PS, Id, AttrList) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{object_map = ObjectMap} = BehaviorStatus,
    case maps:get(Id, ObjectMap, false) of
        #scene_object{} = Obj ->
            NewObject = do_change_object_attr(Obj, AttrList),
            NewObjectMap = ObjectMap#{Id => NewObject},
            NewBehaviorStatus = BehaviorStatus#player_behavior{object_map = NewObjectMap},
            PS#player_status{behavior_status = NewBehaviorStatus};
        _ -> PS
    end.

do_change_object_attr(User, []) -> User;
%do_change_object_attr(User, [{hide, Hide}|T]) ->
%    do_change_object_attr(User#scene_object{hide_type = Hide}, T);
do_change_object_attr(#scene_object{battle_attr = BA} = User, [{group, Group}|T]) ->
    do_change_object_attr(User#scene_object{battle_attr = BA#battle_attr{group = Group}}, T);
do_change_object_attr(#scene_object{battle_attr = BA} = User, [{ghost, Ghost}|T]) ->
    do_change_object_attr(User#scene_object{battle_attr = BA#battle_attr{ghost = Ghost}}, T);
do_change_object_attr(User, [_|T]) ->
    do_change_object_attr(User, T).

%% 添加掉落包
add_drop(PS, DropList) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{drop_map = DropMap} = BehaviorStatus,
    F = fun(DropGoods, AccMap) ->
        #ets_drop{id = DropId, x = X, y = Y} = DropGoods,
        AccMap#{DropId => DropGoods}
    end,
    NewDropMap = lists:foldl(F, DropMap, DropList),
    NewBehaviorStatus = BehaviorStatus#player_behavior{drop_map = NewDropMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

%% 删除掉落包
delete_drop(PS, DropIdList) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{drop_map = DropMap} = BehaviorStatus,
    F = fun(Id, AccMap) -> maps:remove(Id, AccMap) end,
    NewDropMap = lists:foldl(F, DropMap, DropIdList),
    NewBehaviorStatus = BehaviorStatus#player_behavior{drop_map = NewDropMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.

change_drop(PS, DropId, PickRoleId, DropEndTime) ->
    #player_status{behavior_status = BehaviorStatus} = PS,
    #player_behavior{drop_map = DropMap} = BehaviorStatus,
    NewDropMap =
        case maps:get(DropId, DropMap, false) of
            #ets_drop{} = DropGoods ->
                NewDropGoods = DropGoods#ets_drop{pick_player_id = PickRoleId, pick_end_time = DropEndTime},
                DropMap#{DropId => NewDropGoods};
            _ -> DropMap
        end,
    NewBehaviorStatus = BehaviorStatus#player_behavior{drop_map = NewDropMap},
    PS#player_status{behavior_status = NewBehaviorStatus}.
