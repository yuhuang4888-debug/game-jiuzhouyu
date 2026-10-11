%% ---------------------------------------------------------------------------
%% @doc lib_scene_object_agent
%% @author ming_up@foxmail.com
%% @since  2017-02-05
%% @deprecated  场景对象进程字典接口
%% ---------------------------------------------------------------------------
-module(lib_scene_object_agent).

-export([
         get_scene_object/0
        , get_scene_object/1
        , get_scene_object/2
        , get_scene_object_by_ids/2
        , get_scene_object_battle_attr_by_ids/2
        , update/2
        , clear_scene_object/3
        , clear_scene_object_by_ids/2
        , get_scene_mon_by_mids/3
        , clear_scene_mon_by_mids/3
        , change_attr_by_mids/3
        , change_attr_by_ids/2
        ]).
%% 对场景模块内部接口
-export([
         get_area_object/2,               %% 获取格子对象信息
         get_all_area_object/2,           %% 获取九宫格子对象信息
         get_all_area_object_by_bd/2,
         get_object/1,                    %% 获取怪物（根据怪物id）
         put_object/1,                    %% 保存怪物数据
         del_object/1,                    %% 保存怪物数据
         get_area/2,                      %% 获取格子怪物id
         get_all_area/2,                  %% 获取九宫格子怪物id
         save_to_area/4,                  %% 添加在九宫格
         del_to_area/4,                   %% 删除在九宫格
         del_all_area/1,                  %% 删除9宫格数据
         put_trace/4,
         get_trace/3,
         del_trace/1,
         del_trace/4,
         change_ai/7,
         do_for_trace/6,
         del_room/1,
         save_to_deploy/4,
         get_from_deploy/2,
         del_from_deploy/3,
         save_to_coordinate/5,
         get_from_coodinate/3,
         del_from_coodinate/5,
         get_from_coodinates/7,
         get_new_object_in_warning_range/6,
         get_cl_mons/3                    %% 获取采集怪
        ]).

-export([clear_treasure_chest_object/1]).

-export([save_scene_object/1]).

-include("scene.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("figure.hrl").

get_scene_object() ->
    [ Object || {{object, _}, Object} <- get()].

get_scene_object(CopyId) ->
    case CopyId of
        [] -> get_scene_object();
        _  ->
            AllObjectIds = get_from_room(CopyId),
            get_scene_object_helper(AllObjectIds, CopyId, [])
    end.

get_scene_object(CopyId, ResultForm) ->
    AllObject = case CopyId of
                    [] -> get_scene_object();
                    _  -> get_scene_object(CopyId)
                end,
    [util:record_return_form(Object, ResultForm)||Object <- AllObject].

get_scene_object_by_ids(Ids, ResultForm) ->
    AllObject = [ get_object(Id) || Id <- Ids ],
    [util:record_return_form(Object, ResultForm) || Object <- AllObject].

clear_scene_object(0, CopyId, BroadCast) ->
    AllObject = get_scene_object(CopyId),
    [Object#scene_object.aid !  {'stop', BroadCast} || Object <- AllObject, Object/=[]],
    ok;
clear_scene_object(Sign, CopyId, BroadCast) ->
    AllObject = get_scene_object(CopyId),
    [
     begin
         Object#scene_object.aid !  {'stop', BroadCast},
         del_object(Object#scene_object.id)
     end || Object <- AllObject, Object/=[], Object#scene_object.sign==Sign],
    ok.

clear_scene_object_by_ids(BroadCast, Ids) ->
    AllObject = get_scene_object_by_ids(Ids, all),
    [Object#scene_object.aid ! {'stop', BroadCast} || Object <- AllObject, Object/=[]],
    ok.

%% 清理青云夺宝的特定怪物
%% 放到这里方便后期修改接口统一管理
clear_treasure_chest_object(CopyId) ->
    SceneId = data_treasure_chest:get_cfg(1),
    case CopyId of
        [] ->
            %% 获得当前场景所有房间id列表
            SceneCopyIds = lib_scene:get_room_list(SceneId, 0),
            %% 活动初始化的时候1线是默认开启的
            DefaultCopyId = lib_treasure_chest:get_default_copy_id(),
            case lists:member(DefaultCopyId, SceneCopyIds) of
                true -> RealSceneCopyIds = SceneCopyIds;
                false -> RealSceneCopyIds = [DefaultCopyId|SceneCopyIds]
            end,
            F = fun(TmpCopyId, AccMap) -> AccMap#{TmpCopyId => []} end,
            SceneCopyMap = lists:foldl(F, #{}, RealSceneCopyIds);
        _ ->
            %% 初始化指定场景分线的怪物
            SceneCopyMap = #{CopyId => []}
    end,
    %% 获取场景的所有对象
    AllObject = get_scene_object(CopyId),
    F1 = fun(T, AccMap) ->
                if
                    T == [] -> AccMap;
                    T#scene_object.sign =/= ?BATTLE_SIGN_MON -> AccMap;
                    true ->
                        #scene_object{id = TId, aid = TAid, mon = TMon, copy_id = TCopyId, x = Tx, y = Ty} = T,
                        #scene_mon{create_key = CreateKey, is_collecting = IsCollecting} = TMon,
                        IsChestMon = case CreateKey of
                                         {treasure_chest, _Key} -> true;
                                         _ -> false
                                     end,
                        if
                            IsChestMon == false -> AccMap;
                            IsCollecting > 0 -> %% 正在被采集的怪不移除 没有被移除的怪物坐标点要返回给调用接口
                                AccL = maps:get(TCopyId, AccMap, []),
                                maps:put(TCopyId, [{Tx, Ty}|AccL], AccMap);
                            true ->
                                TAid ! {'stop', 1},
                                del_object(TId),
                                AccMap
                        end
                end
        end,
    lists:foldl(F1, SceneCopyMap, AllObject).

get_scene_object_battle_attr_by_ids(Ids, ResultForm) ->
    AllObject = [ get_object(Id) || Id <- Ids ],
    [util:record_return_form(BA, ResultForm) || #scene_object{battle_attr = BA} <- AllObject].

%% 怪物接口
get_scene_mon_by_mids(CopyId, Mids, ResultForm) ->
    AllObject = get_scene_object(CopyId),
    F = fun(Object) ->
                case Object#scene_object.sign of
                    ?BATTLE_SIGN_MON -> lists:member(Object#scene_object.mon#scene_mon.mid, Mids);
                    _ -> false
                end
        end,
    [util:record_return_form(Object, ResultForm) || Object <- lists:filter(F, AllObject)].

clear_scene_mon_by_mids(CopyId, BroadCast, Mids) ->
    AllAid = get_scene_mon_by_mids(CopyId, Mids, #scene_object.aid),
    [Aid ! {'stop', BroadCast} || Aid <- AllAid],
    ok.

change_attr_by_mids(CopyId, Mids, KeyValues) ->
    AllAid = get_scene_mon_by_mids(CopyId, Mids, #scene_object.aid),
    [Aid ! {'change_attr', KeyValues} || Aid <- AllAid],
    ok.

change_attr_by_ids(Ids, KeyValues) ->
    AllObject = get_scene_object_by_ids(Ids, all),
    [Aid ! {'change_attr', KeyValues} || #scene_object{aid=Aid} <- AllObject],
    ok.

update(Id, KeyValues) ->
    case get_object(Id) of
        [] -> skip;
        Object ->
            NewObject = set_kv_args(KeyValues, Object),
            put_object(NewObject)
    end.

set_kv_args([H|T], Object) ->
    Object1 = case H of
        {skill_owner, Value} ->
            Object#scene_object{skill_owner=Value};
        {figure, Value} ->
            Object#scene_object{figure=Value};
        {battle_attr, Value} ->
            Object#scene_object{battle_attr=Value};
        {pos, Value} ->
            Object#scene_object{pos=Value};
        {filter_skill, Value} ->
            Object#scene_object{skill=Value};
        {dummy, Value} ->
            Object#scene_object{dummy = Value};
        {hp, Value} ->
            BA = Object#scene_object.battle_attr,
            Object#scene_object{battle_attr=BA#battle_attr{hp=Value}};
        {hp_lim, Value} ->
            BA = Object#scene_object.battle_attr,
            #battle_attr{attr = Attr} = BA,
            Object#scene_object{battle_attr=BA#battle_attr{hp_lim=Value, attr=Attr#attr{hp=Value}}};
        {is_be_atted, Value} ->
            Object#scene_object{is_be_atted = Value};
        {is_be_clicked, Value} ->
            Object#scene_object{is_be_clicked = Value};
        {xy, X, Y} ->
            Object#scene_object{x = X, y = Y};
        {mon, Value} ->
            Object#scene_object{mon=Value};
        {mod_args, Value} ->
            Object#scene_object{mod_args=Value};
        {angle, Value} ->
            Object#scene_object{angle=Value};
        {type, Value} ->
            Object#scene_object{type=Value};
        {weapon_id, Value} ->
            Object#scene_object{weapon_id=Value};
        {die_info, Value} ->
            Object#scene_object{die_info = Value};
        {hurt_check, Value} ->
            Object#scene_object{hurt_check = Value};
        {is_collecting, Value} ->
            Mon = Object#scene_object.mon,
            Object#scene_object{mon = Mon#scene_mon{is_collecting = Value}};
        {has_cltimes, Value} ->
            Mon = Object#scene_object.mon,
            Object#scene_object{mon = Mon#scene_mon{has_cltimes = Value}};
        {change_speed, Value} ->
            BA = Object#scene_object.battle_attr,
            Object#scene_object{battle_attr=BA#battle_attr{speed = Value}};
        {be_att_limit, Value} ->
            Object#scene_object{be_att_limit=Value};
        {bl_role_id, Value} ->
            Object#scene_object{bl_role_id=Value};
        {pub_skill_cd_cfg, Value} ->
            Object#scene_object{pub_skill_cd_cfg=Value};
        {frenzy_enter_time, Value} ->
            Object#scene_object{frenzy_enter_time=Value};
        {server_num, Value} ->
            Object#scene_object{server_num=Value};
        {up_assist_ids, Value} ->
            Object#scene_object{assist_ids=Value};
        {boss, Value} ->
            Mon = Object#scene_object.mon,
            Object#scene_object{mon = Mon#scene_mon{boss = Value}};
        {att, Value} ->
            BA = Object#scene_object.battle_attr,
            #battle_attr{attr = Attr} = BA,
            Object#scene_object{battle_attr=BA#battle_attr{attr=Attr#attr{att=Value}}};
        {lv, Value} ->
            Figure = Object#scene_object.figure,
            Object#scene_object{figure=Figure#figure{lv=Value}};
        _ ->
          Object
    end,
    set_kv_args(T, Object1);
set_kv_args([], Object) -> Object.

save_scene_object(Object) ->
    put_object(Object).

%% ============================ mod_scene_agent 保存伙伴信息 ===============================
-define(object_key(X), {object, X}).
%% 保存怪物数据
put_object(Object) ->
    #scene_object{id=Id, copy_id=CopyId, x=X, y=Y, sign=_Sign, pos=Pos, battle_attr=#battle_attr{group=Group}} = Object,
    case get(?object_key(Id)) of
        undefined ->
            save_to_room(CopyId, Id),
            save_to_area(CopyId, X, Y, Id),
            save_to_deploy(CopyId, Pos, Id, Group),
            %% save_to_coordinate(CopyId, X, Y, Sign, Id),
            ok;
        #scene_object{x=OldX, y=OldY} ->
            XYNew = lib_scene_calc:get_xy(X, Y),
            XYOld = lib_scene_calc:get_xy(OldX, OldY),
            if
                XYNew == XYOld -> skip;
                true ->
                    del_to_area(CopyId, XYOld, Id),
                    save_to_area(CopyId, XYNew, Id),
                    %% del_from_coodinate(CopyId, OldX, OldY, Sign, Id),
                    %% save_to_coordinate(CopyId, X, Y, Sign, Id),
                    ok
            end
    end,
    put(?object_key(Id), Object).


get_object(IdList) when is_list(IdList)->
    [get_object(Id)||Id<-IdList];

%% 获取怪物数据
get_object(Id) ->
    case get(?object_key(Id)) of
        undefined -> [];
        Object -> Object
    end.

get_scene_object_helper([], _, Data) ->
    lists:reverse(Data);
get_scene_object_helper([Id | T], CopyId, Data) ->
    case get(?object_key(Id)) of
        undefined ->
            del_from_room(CopyId, Id),
            get_scene_object_helper(T, CopyId, Data);
        Object ->
            get_scene_object_helper(T, CopyId, [Object | Data])
    end.

%% 删除怪物数据
del_object(Id) ->
    case get(?object_key(Id)) of
        undefined -> [];
        Object ->
            #scene_object{copy_id=CopyId, x=X, y=Y, d_x=Dx, d_y=Dy, sign=_Sign, aid=Aid, warning_range=WaringRange, pos=Pos} = Object,
            del_from_room(CopyId, Id),
            del_to_area(CopyId, X, Y, Id),
            do_for_trace(Aid, CopyId, WaringRange, Dx, Dy, 2),
            del_from_deploy(CopyId, Pos, Id),
            %% del_from_coodinate(CopyId, X, Y, Sign, Id),
            erase(?object_key(Id))
    end.

%% ============================ mod_scene_agent 保存怪物警戒信息 ===============================

-define(object_trace(X), {object_trace, X}).
%% 写入怪物ai(设定怪物追踪范围，角色走路进行触发怪物追踪)
put_trace(CopyId, X, Y, Aid) ->
    case get(?object_trace(CopyId)) of
        undefined ->
            put(?object_trace(CopyId), #{{X, Y} => [Aid]});
        D ->
            case maps:find({X, Y}, D) of
                {ok, OL} -> put(?object_trace(CopyId), D#{{X, Y} := [Aid|OL]});
                _ ->        put(?object_trace(CopyId), D#{{X, Y} => [Aid]})
            end
    end,
    ok.

%% 获取怪物ai
get_trace(CopyId, X, Y) ->
    case get(?object_trace(CopyId)) of
        undefined -> [];
        D ->
            case maps:find({X, Y}, D) of
                {ok, MonAidL} -> MonAidL;
                _ -> []
            end
    end.

%% 删除怪物ai
del_trace(CopyId) ->
    erase(?object_trace(CopyId)).

%% 移除某只怪物的ai
del_trace(CopyId, X, Y, Aid) ->
    case get(?object_trace(CopyId)) of
        undefined -> ok;
        D ->
            case maps:find({X, Y}, D) of
                {ok, OL} ->
                    case lists:delete(Aid, OL) of
                        [] ->
                            D1 = maps:remove({X, Y}, D),
                            case maps:size(D1) of
                                0 -> erase(?object_trace(CopyId));
                                _ -> put(?object_trace(CopyId), D1)
                            end;
                        CL ->
                            put(?object_trace(CopyId), D#{{X, Y} := CL})
                    end;
                _ ->
                    ok
            end
    end.

%% 改变警戒区
change_ai(Aid, CopyId, WaringRange, X, Y, OX, OY) ->
    do_for_trace(Aid, CopyId, WaringRange, OX, OY, 2),
    do_for_trace(Aid, CopyId, WaringRange, X, Y, 1),
    ok.

%% 插入/移除警戒区
%% Type :: integer(),  %% 操作类型(1插入警戒区， 2移除警戒区)
do_for_trace(Aid, CopyId, WaringRange, Xpx, Ypx, Type) ->
    TraceXpx = min(?LENGTH * 3 bsr 1, WaringRange),  %% 控制最大追踪范围(px)
    TraceYpx = min(?WIDTH  * 3 bsr 1, WaringRange),  %% 控制最大追踪范围(px)
    Xmin = max(0,  Xpx - TraceXpx),
    Ymin = max(0,  Ypx - TraceYpx),
    Xmax = Xpx + TraceXpx,
    Ymax = Ypx + TraceYpx,
    {Xlmin, Ylmin} = lib_scene_calc:pixel_to_logic_coordinate(Xmin, Ymin),
    {Xlmax, Ylmax} = lib_scene_calc:pixel_to_logic_coordinate(Xmax, Ymax),
    Fun = case Type of
              1 -> fun put_trace/4;
              2 -> fun del_trace/4
          end,
    loop_post_x(Xlmin, Xlmax, Ylmin, Ylmax, Aid, CopyId, Fun),
    ok.

loop_post_x(M, M, Y, Y1, Aid, CopyId, Fun) ->
    loop_post_y(M, Y, Y1, Aid, CopyId, Fun);
loop_post_x(X, M, Y, Y1, Aid, CopyId, Fun) ->
    loop_post_y(X, Y, Y1, Aid, CopyId, Fun),
    loop_post_x(X+1, M, Y, Y1, Aid, CopyId, Fun).

loop_post_y(X, M, M, Aid, CopyId, Fun) ->
    do_post_aid(Aid, CopyId, X, M, Fun);
loop_post_y(X, Y, M, Aid, CopyId, Fun) ->
    do_post_aid(Aid, CopyId, X, Y, Fun),
    loop_post_y(X, Y+1, M, Aid, CopyId, Fun).

do_post_aid(Aid, CopyId, X, Y, Fun) ->
    Fun(CopyId, X, Y, Aid).

%% ============================ mod_scene_agent 保存怪物九宫格信息 ===============================

-define(object_area(X, Y), {object_area, {X, Y}}).
%% 添加在九宫格
save_to_area(CopyId, XY, Id) ->
    PDAreaKey = ?object_area(XY, CopyId),
    case get(PDAreaKey) of
        undefined ->
            put(PDAreaKey, #{Id => 0});
        D ->
            put(PDAreaKey, D#{Id => 0})
    end.

save_to_area(CopyId, X, Y, Id) ->
    XY = lib_scene_calc:get_xy(X, Y),
    save_to_area(CopyId, XY, Id).


%% 获取一个格子怪物id
get_area(XY, CopyId) ->
    case get(?object_area(XY, CopyId)) of
        undefined -> [];
        D -> maps:keys(D)
    end.

%% 获取多个格子怪物id
get_all_area(Area, CopyId) ->
    Keys = lists:foldl(
        fun(OneArea, L) ->
            lists:reverse(get_area(OneArea, CopyId)) ++ L
        end,
        [], Area),
    lists:reverse(Keys).

%% 获取一个格子object信息
get_area_object(XY, CopyId) ->
    AllObject = get_area(XY, CopyId),
    get_scene_object_helper(AllObject, CopyId, []).

%% 获取多个格子object信息
get_all_area_object(Area, CopyId) ->
    List = get_all_area(Area, CopyId),
    get_scene_object_helper(List, CopyId, []).

%% 根据广播,获取多个格子object信息
get_all_area_object_by_bd(Area, CopyId) ->
    case lib_scene_agent:get_broadcast() of
        ?BROADCAST_ALL -> get_scene_object(CopyId);
        _ ->
            List = get_all_area(Area, CopyId),
            get_scene_object_helper(List, CopyId, [])
    end.

del_to_area(CopyId, XY, Id) ->
    case get(?object_area(XY, CopyId)) of
        undefined -> skip;
        D ->
            D1 = maps:remove(Id, D),
            case maps:size(D1) of
                0 -> erase(?object_area(XY, CopyId));
                _ -> put(?object_area(XY, CopyId), D1)
            end
    end.

del_to_area(CopyId, X, Y, Id) ->
    XY = lib_scene_calc:get_xy(X, Y),
    del_to_area(CopyId, XY, Id).

%% 删除9宫格数据
del_all_area(CopyId) ->
    Data = get(),
    F = fun({Key, _}) ->
                case Key of
                    {object_area, {_, CopyId}} -> erase(Key);
                    _ -> skip
                end
        end,
    lists:foreach(F, Data).

%% ============================ mod_scene_agent 保存怪物房间信息 ===============================
-define(object_room(X), {object_room, X}).
%% 保存怪物id到房间
save_to_room(CopyId, Id) ->
    case get(?object_room(CopyId)) of
        undefined ->
            put(?object_room(CopyId), #{Id => 0});
        D ->
            put(?object_room(CopyId), D#{Id => 0})
    end.

%% 从房间获取所有怪物id
get_from_room(CopyId) ->
    case get(?object_room(CopyId)) of
        undefined -> [];
        D -> maps:keys(D)
    end.

%% 从房间中删除怪物id
del_from_room(CopyId, Id) ->
    case get(?object_room(CopyId)) of
        undefined -> skip;
        D ->
            D1 = maps:remove(Id, D),
            case maps:size(D1) of
                0 -> erase(?object_room(CopyId));
                _ -> put(?object_room(CopyId), D1)
            end
    end.

del_room(CopyId) ->
    erase(?object_room(CopyId)).

%% ============================ mod_scene_agent 保存怪物房间信息 ===============================
-define(deploy(CopyId), {deploy, CopyId}).
%% 保存对象到逻辑坐标
save_to_deploy(_, 0, _, _) -> skip;
save_to_deploy(CopyId, Pos, Id, Group) ->
    case get(?deploy(CopyId)) of
        undefined ->
            put(?deploy(CopyId), #{Pos => [{Id,Group}] });
        D ->
            D1 = case maps:get(Pos, D, false) of
                     false -> D#{Pos => [{Id,Group}]};
                     L     -> D#{Pos => [{Id,Group}|lists:keydelete(Id, 1, L)]}
                 end,
            put(?deploy(CopyId), D1)
    end.

%% 从逻辑坐标获取所有对象id
get_from_deploy(CopyId, Pos) ->
    case get(?deploy(CopyId)) of
        undefined -> false;
        D -> maps:get(Pos, D, false)
    end.

%% 从房间中删除怪物id
del_from_deploy(_, 0, _) -> skip;
del_from_deploy(CopyId, Pos, Id) ->
    case get(?deploy(CopyId)) of
        undefined -> skip;
        D ->
            case maps:get(Pos, D, false) of
                false -> skip;
                L     ->
                    D1 = case lists:keydelete(Id, 1, L) of
                             [] -> maps:remove(Pos, D);
                             L1 -> D#{Pos => L1}
                         end,
                    case maps:size(D1) of
                        0 -> erase(?deploy(CopyId));
                        _ -> put(?deploy(CopyId), D1)
                    end
            end
    end.

%% ============================ mod_scene_agent 保存怪物房间信息 ===============================
-define(coodinate(CopyId, X, Y), {coodinate, {CopyId, X, Y}}).
%% 保存对象到逻辑坐标
save_to_coordinate(CopyId, Xpx, Ypx, Sign, Id) ->
    {X, Y} = lib_scene_calc:pixel_to_logic_coordinate(Xpx, Ypx),
    case get(?coodinate(CopyId, X, Y)) of
        undefined ->
            put(?coodinate(CopyId, X, Y), #{{Sign,Id} => 0});
        D ->
            put(?coodinate(CopyId, X, Y), D#{{Sign,Id} => 0})
    end.

%% 从逻辑坐标获取所有对象id
get_from_coodinate(CopyId, X, Y) ->
    case get(?coodinate(CopyId, X, Y)) of
        undefined -> [];
        D -> maps:keys(D)
    end.

%% 从房间中删除怪物id
del_from_coodinate(CopyId, Xpx, Ypx, Sign, Id) ->
    {X, Y} = lib_scene_calc:pixel_to_logic_coordinate(Xpx, Ypx),
    case get(?coodinate(CopyId, X, Y)) of
        undefined -> skip;
        D ->
            D1 = maps:remove({Sign,Id}, D),
            case maps:size(D1) of
                0 -> erase(?coodinate(CopyId, X, Y));
                _ -> put(?coodinate(CopyId, X, Y), D1)
            end
    end.

%% 对逻辑坐标范围内的所有场景对象进行处理
get_from_coodinates(Xop, Xed, Xc, Yop, Yed, Yc, CopyId) ->
    get_from_x_coodinate(Xop, Xed, Xc, Yop, Yed, Yc, CopyId, fun get_from_coodinate/3, []).

get_from_x_coodinate(Xed, Xed, _, Yop, Yed, Yc, CopyId, Fun, Result) ->
    get_from_y_coodinate(Xed, Yop, Yed, Yc, CopyId, Fun, Result);
get_from_x_coodinate(Xtmp, Xed, Xc, Yop, Yed, Yc, CopyId, Fun, Result) ->
    TmpResult = get_from_y_coodinate(Xtmp, Yop, Yed, Yc, CopyId, Fun, Result),
    get_from_x_coodinate(Xtmp+Xc, Xed, Xc, Yop, Yed, Yc, CopyId, Fun, TmpResult).

get_from_y_coodinate(X, Yed, Yed, _, CopyId, Fun, Result) ->
    Fun(CopyId, X, Yed) ++ Result;
get_from_y_coodinate(X, Ytmp, Yed, Yc, CopyId, Fun, Result) ->
    TmpResult = Fun(CopyId, X, Ytmp) ++ Result,
    get_from_y_coodinate(X, Ytmp+Yc, Yed, Yc, CopyId, Fun, TmpResult).

%% 从两个警戒区中获取新的场景对象
get_new_object_in_warning_range(CopyId, X, Y, TX, TY, WarningRange) ->
    {XW, YW} = lib_scene_calc:pixel_to_logic_coordinate(WarningRange, WarningRange),
    {Xlg, Ylg} = lib_scene_calc:pixel_to_logic_coordinate(X, Y),
    {TXlg, TYlg} = lib_scene_calc:pixel_to_logic_coordinate(TX, TY),
    if
        Xlg == TXlg andalso Ylg == TYlg -> [];
        TXlg - XW < Xlg - XW orelse TXlg + XW > Xlg + XW orelse TYlg - YW < Ylg - YW orelse TYlg + YW > Ylg + XW ->  %% 前后两个警戒区不相交
            lib_scene_object_agent:get_from_coodinates(TXlg -XW, TXlg + XW, 1, TYlg - YW, TYlg + YW, 1, CopyId);
        %% 前后两个警戒区相交
        Xlg == TXlg ->
            YGag = TYlg - Ylg,
            YR = YGag div abs(YGag),
            %% ?PRINT("one y ~p~n", [{TXlg - XW, TXlg + XW, 1, Ylg + YR*YW, TYlg + YR*YW, YR}]),
            lib_scene_object_agent:get_from_coodinates(TXlg - XW, TXlg + XW, 1, Ylg + YR*YW+YR, TYlg + YR*YW, YR, CopyId);
        Ylg == TYlg ->
            XGag = TXlg - Xlg,
            XR = XGag div abs(XGag),
            %% ?PRINT("one x ~p~n", [{Xlg + XR*XW+XR, TXlg + XR*XW, XR, Ylg - YW, TYlg + YW, 1}]),
            lib_scene_object_agent:get_from_coodinates(Xlg + XR*XW+XR, TXlg + XR*XW, XR, Ylg - YW, TYlg + YW, 1, CopyId);
        true -> %% 前后两个警戒区相交
            YGag = TYlg - Ylg,
            YR = YGag div abs(YGag),
            XGag = TXlg - Xlg,
            XR = XGag div abs(XGag),
            %% ?PRINT("two ~p, ~p~n", [{Xlg + XR*XW+XR, TXlg + XR*XW, XR, Ylg - YW, TYlg + YW, 1}, {TXlg - XR*XW, Xlg + XR*XW, XR, Ylg + YR*YW, TYlg + YR*YW, YR}]),
            %% 先计算x
            XObjects = lib_scene_object_agent:get_from_coodinates(Xlg + XR*XW+XR, TXlg + XR*XW, XR, Ylg - YW, TYlg + YW, 1, CopyId),
            YObjects = lib_scene_object_agent:get_from_coodinates(TXlg - XR*XW, Xlg + XR*XW, XR, Ylg + YR*YW, TYlg + YR*YW, YR, CopyId),
            XObjects ++ YObjects
    end.

%%--------------------------------------------------
%% 获取采集怪物信息
%% @param  CopyId CopyId
%% @param  X      像素坐标X
%% @param  Y      像素坐标Y
%% @return        description
%%--------------------------------------------------
get_cl_mons(CopyId, X, Y) ->
    XY = lib_scene_calc:get_xy(X, Y),
    Objects = get_area_object(XY, CopyId),
    [Obj#scene_object.aid || Obj <- Objects, is_record(Obj#scene_object.mon, scene_mon) andalso
                                 lists:member(Obj#scene_object.mon#scene_mon.kind, [?MON_KIND_COLLECT, ?MON_KIND_TASK_COLLECT, ?MON_KIND_UNDIE_COLLECT, ?MON_KIND_COUNT_COLLECT])].

