%%%-----------------------------------
%%% @Module  : lib_scene_calc
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.07.22
%%% @Description: 场景广播算法,在场景进程中使用
%%%-----------------------------------
-module(lib_scene_calc).

-export([
        make_scene_calc_args/1,
        make_scene_calc_args_def/1,
        partner_find_target/9,
        get_area_for_trace/7,
        get_any_for_trace_cast/8,
        % get_any_for_back_born_cast/7,
        get_area_for_trace_offline/5,
        partner_do_for_area/6,
        get_ellipse_object_for_battle/6,
        get_rectangle_object_for_battle/8,
        get_cross_object_for_battle/8,
        % get_rectangle_object_for_battle/8,
        get_sector_object_for_battle/9,
        get_scene_object_for_assist/6,
        get_scene_mon_for_assist/6,
        check_user_in_range/5,
        get_object_for_battle/5,
        get_object_for_collect/6
    ]).

-export([
        get_xy/2,
        move_broadcast/10,
        move_broadcast/11,
        is_area_scene_by_scene_id/5,
        is_area_scene/5,
        get_broadcast_user/4,
        get_broadcast_object/4,
        get_the_area/2,
        get_the_area/3,
        pixel_to_logic_coordinate/2,
        pixel_to_logic_coordinate/3,
        logic_to_pixel_coordinate/2,
        save_areas_num/3
    ]).

-include("scene.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("team.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("server.hrl").

%% 构造场景计算
make_scene_calc_args(User) ->
    case User of
        % 怪物
        #scene_object{sign = Sign, id = Id, battle_attr = BA, skill_owner = SkillOwner, mon=#scene_mon{kind=MonKind}} ->
            {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner);
        #scene_object{sign = Sign, id = Id, battle_attr = BA, skill_owner = SkillOwner} ->
            {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner),
            MonKind = 0;
        #ets_scene_user{id = Id, battle_attr = BA} ->
            OwnerSign = 0, OwnerId = 0, Sign = ?BATTLE_SIGN_PLAYER, MonKind = 0;
        #player_status{id = Id, battle_attr = BA} ->
            OwnerSign = 0, OwnerId = 0, Sign = ?BATTLE_SIGN_PLAYER, MonKind = 0;
        #battle_status{sign=Sign, id=Id, battle_attr=BA, skill_owner=SkillOwner, kind = MonKind} ->
            {OwnerSign, OwnerId} = lib_scene_object_ai:get_skill_owner_args(SkillOwner)
    end,
    #battle_attr{group = Group} = BA,
    #scene_calc_args{
        group = Group, sign = Sign, id = Id,
        owner_sign = OwnerSign, owner_id = OwnerId, kind = MonKind,
        guild_id = lib_scene_object_ai:get_guild_id(User),
        pk_status = lib_scene_object_ai:get_pk_status(User)
    }.

make_scene_calc_args_def(User) ->
    case User of
        #scene_object{
            id=Id, sign=Sign, x=X, y=Y, is_be_atted=IsBeAtted, skill_owner=SkillOwner, mon = _Mon,
            battle_attr=#battle_attr{hp=Hp, ghost=Ghost, hide=Hide, group=Group}
        } ->
            ok;
        #ets_scene_user{id=Id, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, ghost=Ghost, hide=Hide, group=Group}, hide_type = HideType} ->
            Sign=?BATTLE_SIGN_PLAYER,
            IsBeAtted = ?IF(HideType > 0, 0, 1),
            SkillOwner=[],
            _Mon = undefined
    end,
    #scene_calc_args_def{
        id=Id, sign=Sign, x=X, y=Y, is_be_atted=IsBeAtted, skill_owner=SkillOwner,
        mon = _Mon, ghost = Ghost, hide = Hide, group = Group, hp = Hp
    }.

%% 伙伴找目标
partner_find_target(CopyId, X, Y, Area, Args, Personality, Pos, IsPersonlity, EtsScene) ->
    AllArea = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    Xmax = X + Area,
    Xmin = X - Area,
    Ymax = Y + Area,
    Ymin = Y - Area,
    F = fun(Xtmp, Ytmp, Hide) ->
        Hide == 0
            andalso not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin)
    end,

    if
        Personality == 4 andalso IsPersonlity ->
            AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
            case filter_battle_obj(AllUsers, F, Args, [], undefined) of
                [User|_] -> {?BATTLE_SIGN_PLAYER, User#ets_scene_user.id, User#ets_scene_user.pid, User#ets_scene_user.x, User#ets_scene_user.y};
                _ ->
                    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
                    case  filter_battle_obj(AllObjects, F, Args, [], undefined) of
                        [Object|_] = FilterObjs ->
                            case find_a_dummy(FilterObjs) of
                                false  -> {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
                                Result -> Result
                            end;
                        _ -> false
                    end
            end;
        (Personality == 5 orelse Personality == 7) andalso IsPersonlity->
            AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
            AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
            case find_min_hp(filter_battle_obj(AllUsers, F, Args, [], undefined), infinity, false) of
                false ->
                    case find_min_hp(filter_battle_obj(AllObjects, F, Args, [], undefined), infinity, false) of
                        false  -> false;
                        Result -> Result
                    end;
                {MinHp, Result} ->
                    {_, Result1} = find_min_hp(filter_battle_obj(AllObjects, F, Args, [], undefined), MinHp, Result),
                    Result1
            end;
        Personality == 8 andalso IsPersonlity->
            AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
            AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
            case find_close_obj(filter_battle_obj(AllUsers, F, Args, [], undefined), X, Y, infinity, false) of
                {_, false} ->
                    case find_close_obj(filter_battle_obj(AllObjects, F, Args, [], undefined), X, Y, infinity, false) of
                        {_, Result} -> Result;
                        _  -> false
                    end;
                {MinDis, Result} ->
                    {_, Result1} = find_close_obj(filter_battle_obj(AllObjects, F, Args, [], undefined), X, Y, MinDis, Result),
                    Result1
            end;
        Personality == 15 andalso IsPersonlity ->
            AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
            case find_min_hp_ratio(filter_battle_obj(AllUsers, F, Args, [], undefined))of
                false ->
                    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
                    case  filter_battle_obj(AllObjects, F, Args, [], undefined) of
                        [Object|_] = FilterObjs ->
                            case find_min_hp_ratio(FilterObjs) of
                                false  -> {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
                                Result -> Result
                            end;
                        _ -> false
                    end;
                Result -> Result
            end;
        true ->
            {GroupA, _SignA, IdA, _OwnerSignA, _OwnerIdA} = Args,
            Res = case Pos > 0 of
                      true ->
                          %% ?PRINT(" =========== find_target : ~w~n", [Pos]),
                          get_pos_target(get_pos_seq(Pos), CopyId, IdA, GroupA, Args);
                      _ -> false
                  end,
            case Res of
                false ->
                    AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
                    case filter_battle_obj(AllUsers, F, Args, [], undefined) of
                        [User|_] -> {?BATTLE_SIGN_PLAYER, User#ets_scene_user.id, User#ets_scene_user.pid, User#ets_scene_user.x, User#ets_scene_user.y};
                        _ ->
                            AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
                            case  filter_battle_obj(AllObjects, F, Args, [], undefined) of
                                [Object|_] -> {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
                                _ -> false
                            end
                    end;
                _ -> Res
            end
    end.

%% 4 1       3 6
%% 5 2  <->  2 5
%% 6 3       1 4
get_pos_seq(1) -> [3,6,2,5,1,4];
get_pos_seq(2) -> [2,5,3,6,1,4];
get_pos_seq(3) -> [1,4,2,5,3,6];
get_pos_seq(4) -> [3,6,2,5,1,4];
get_pos_seq(5) -> [2,5,3,6,1,4];
get_pos_seq(6) -> [1,4,2,5,3,6];
get_pos_seq(_) -> [].

get_pos_target([H|T], CopyId, Id, Group, Args) ->
    case lib_scene_object_agent:get_from_deploy(CopyId, H) of
        false -> get_pos_target(T, CopyId, Id, Group, Args);
        L ->
            case [EId ||{EId, EGroup} <- L, EGroup /= Group, Id /= EId] of
                [] -> get_pos_target(T, CopyId, Id, Group, Args);
                Ids ->
                    F = fun(_Xtmp, _Ytmp, Hide) -> Hide == 0 end,
                    Objects = lib_scene_object_agent:get_scene_object_by_ids(Ids, all),
                    case  filter_battle_obj(Objects, F, Args, [], undefined) of
                        [Object|_] ->
                            {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
                        _ -> get_pos_target(T, CopyId, Id, Group, Args)
                    end
            end
    end;
get_pos_target([], _CopyId, _Id, _Group, _Args) -> false.

find_a_dummy([#scene_object{sign = ?BATTLE_SIGN_DUMMY, id=Id, aid=Aid, x=X, y=Y}|_]) ->
    {?BATTLE_SIGN_DUMMY, Id, Aid, X, Y};
find_a_dummy([_|T]) ->
    find_a_dummy(T);
find_a_dummy([]) -> false.

find_min_hp([#ets_scene_user{id=Id, x=X, y=Y, pid=Pid, battle_attr=#battle_attr{hp=Hp} }|T], MinHp, Result) ->
    case Hp < MinHp of
        true  -> find_min_hp(T, Hp, {?BATTLE_SIGN_PLAYER, Id, Pid, X, Y});
        false -> find_min_hp(T, MinHp, Result)
    end;
find_min_hp([#scene_object{sign=Sign, aid=Aid, id=Id, x=X, y=Y, battle_attr=#battle_attr{hp=Hp} }|T], MinHp, Result) ->
    case Hp < MinHp of
        true  -> find_min_hp(T, Hp, {Sign, Id, Aid, X, Y});
        false -> find_min_hp(T, MinHp, Result)
    end;
find_min_hp([], MinHp, Result) -> {MinHp, Result}.

find_min_hp_ratio([#ets_scene_user{id=Id, pid=Pid, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim} }|_]) when Hp/HpLim <0.3 ->
    {?BATTLE_SIGN_PLAYER, Id, Pid, X, Y};
find_min_hp_ratio([#scene_object{sign = Sign, id=Id, aid=Aid, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, hp_lim=HpLim}}|_]) when Hp/HpLim <0.3 ->
    {Sign, Id, Aid, X, Y};
find_min_hp_ratio([_|T]) ->
    find_min_hp_ratio(T);
find_min_hp_ratio([]) -> false.

find_close_obj([#ets_scene_user{id=Id, pid=Pid, x=X, y=Y} |T], OX, OY, MinDis, Result) ->
    ThisDis = abs(OX-X)+abs(OY-Y),
    case ThisDis < MinDis of
        true  -> find_close_obj(T, OX, OY, ThisDis, {?BATTLE_SIGN_PLAYER, Id, Pid, X, Y});
        false -> find_close_obj(T, OX, OY, MinDis, Result)
    end;
find_close_obj([#scene_object{sign=Sign, id=Id, aid=Aid, x=X, y=Y} |T], OX, OY, MinDis, Result) ->
    ThisDis = abs(OX-X)+abs(OY-Y),
    case ThisDis < MinDis of
        true  -> find_close_obj(T, OX, OY, ThisDis, {Sign, Id, Aid, X, Y});
        false -> find_close_obj(T, OX, OY, MinDis, Result)
    end;
find_close_obj([], _, _, MinDis, Result) -> {MinDis, Result}.


get_any_for_trace_cast(From, CopyId, X, Y, Area, Args, SelectOp, EtsScene) ->
    Res = get_area_for_trace(CopyId, X, Y, Area, Args, SelectOp, EtsScene),
    From ! {'get_for_trace', Res}.

% get_any_for_back_born_cast(From, CopyId, X, Y, Area, Args, SelectOp) ->
%     Res = get_area_for_trace(CopyId, X, Y, Area, Args, SelectOp),
%     From ! {'get_for_back_born', Res}.

check_user_in_range(Aid, X, Y, Area, UserIds) ->
    Xmax = X + Area,
    Xmin = X - Area,
    Ymax = Y + Area,
    Ymin = Y - Area,
    F = fun(Id) ->
            case lib_scene_agent:get_user(Id) of
                #ets_scene_user{x = Xtmp, y = Ytmp}->
                    not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin);
                _ ->
                    false
            end
        end,
    Res = [Id || Id <- UserIds, F(Id)],
    Aid ! {check_user_in_range_res, Res}.

%% 从九宫格中获取可攻击的对象(离线挂机只选怪物挂机)
get_area_for_trace_offline(CopyId, X, Y, Args, EtsScene) ->
    AllArea = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    Area = 600,
    Xmax = X + Area,
    Xmin = X - Area,
    Ymax = Y + Area,
    Ymin = Y - Area,
    F = fun(Xtmp, Ytmp, Hide) -> Hide == 0 andalso not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin) end,
    AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    case filter_battle_obj(AllObjects, F, Args, [], undefined) of
        [] -> false;
        [Object] -> {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
        ObjectList when is_list(ObjectList)->
            [Object|_]  = ulists:list_shuffle(ObjectList),
            {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
        _ -> false
    end.
    %% F = fun(Xtmp, Ytmp, Hide) -> Hide == 0 andalso not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin) end,
    %% AllUsers    = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    %% UserInfo = case filter_battle_obj(AllUsers, F, Args, []) of
    %%                [User|_] -> {?BATTLE_SIGN_PLAYER, User#ets_scene_user.id, User#ets_scene_user.pid, User#ets_scene_user.x, User#ets_scene_user.y};
    %%                _ -> false
    %%            end,
    %% case UserInfo of
    %%     false ->
    %%         AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    %%         case  filter_battle_obj(AllObjects, F, Args, []) of
    %%             [Object|_] -> {Object#scene_object.sign, Object#scene_object.id, Object#scene_object.aid, Object#scene_object.x, Object#scene_object.y};
    %%             _ -> false
    %%         end;
    %%     _ -> UserInfo
    %% end.

get_area_for_trace(CopyId, X, Y, Area, Args, SelectOp, EtsScene) ->
    AllArea = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    %% Area = 600,
    Xmax = X + Area,
    Xmin = X - Area,
    Ymax = Y + Area,
    Ymin = Y - Area,
    F = fun(Xtmp, Ytmp, Hide) -> Hide == 0 andalso not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin) end,

    FindTargetType = 1,
    case FindTargetType of
        2 ->
            AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
            MonInfo = case  filter_battle_obj(AllObjects, F, Args, [], SelectOp) of
                [#scene_object{sign=SignM, id=IdM, aid=AidM, x=XM, y=YM}|_] -> {SignM, IdM, AidM, XM, YM};
                _ -> false
            end,
            case MonInfo of
                false ->
                    AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
                    case filter_battle_obj(AllUsers, F, Args, [], SelectOp) of
                       [#ets_scene_user{id=IdU, pid=PidU, x=XU, y=YU} |_] -> {?BATTLE_SIGN_PLAYER, IdU, PidU, XU, YU};
                       _ -> false
                   end;
                _ -> MonInfo
            end;
        _ ->
            AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
            UserInfo = case filter_battle_obj(AllUsers, F, Args, [], SelectOp) of
                [#ets_scene_user{id=IdU, pid=PidU, x=XU, y=YU} |_] -> {?BATTLE_SIGN_PLAYER, IdU, PidU, XU, YU};
                _ -> false
            end,
            case UserInfo of
                false ->
                    AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
                    case  filter_battle_obj(AllObjects, F, Args, [], SelectOp) of
                        [#scene_object{sign=SignM, id=IdM, aid=AidM, x=XM, y=YM}|_] -> {SignM, IdM, AidM, XM, YM};
                        _ -> false
                    end;
                _ -> UserInfo
            end
    end.

%% 伙伴对视野里面的玩家影响
partner_do_for_area(CopyId, X, Y, Args, Fex, EtsScene) ->
    AllArea     = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    AllUsers    = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    Area = 1024,
    Xmax = X + Area,
    Xmin = X - Area,
    Ymax = Y + (Area bsr 1),
    Ymin = Y - (Area bsr 1),
    F = fun(Xtmp, Ytmp, Hide) ->
        Hide == 0 andalso 
            not (Xtmp > Xmax orelse Xtmp < Xmin orelse Ytmp > Ymax orelse Ytmp < Ymin)
    end,
    FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
    [Fex(E) ||  E <- FilterObjets],
    FilterUsers = filter_battle_obj(AllUsers, F, Args, [], undefined),
    [Fex(E) ||  E <- FilterUsers],
    ok.

%% 获取椭圆范围内的场景对象X,Y是参考点的坐标
get_ellipse_object_for_battle(CopyId, X, Y, Area, Args, EtsScene) ->
    #ets_scene{origin_type = OriginType} = EtsScene,
    AllArea     = get_the_area(OriginType, X, Y),
    AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    AllUsers    = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    Area2 = Area*Area,
    F = fun(Xtmp, Ytmp, _) ->
        DX = Xtmp-X, DY = Ytmp-Y,
        % abs(DX) =< Area andalso abs(DY) =< (Area bsr 1) andalso DX*DX + 4*DY*DY =< Area2
        case OriginType of
            ?MAP_ORIGIN_LU -> abs(DX) =< Area andalso abs(DY) =< (Area bsr 1) andalso DX*DX + 4*DY*DY =< Area2;
            _ -> abs(DX) =< Area andalso abs(DY) =< Area andalso DX*DX + DY*DY =< Area2
        end
    end,
    FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
    filter_battle_obj(AllUsers, F, Args, FilterObjets, undefined).

%% 获取矩形范围可攻击的场景对象
get_rectangle_object_for_battle(CopyId, Length, Width, OX, OY, Radian, Args, EtsScene) ->
    Cos     = math:cos(Radian),
    Sin     = math:sin(Radian),
    OXtr    = trunc(OX*Cos+OY*Sin), %% 旋转坐标
    OYtr    = trunc(OY*Cos-OX*Sin),
    Xmax    = OXtr + Length,
    Xmin    = OXtr,
    #ets_scene{origin_type = OriginType} = EtsScene,
    case OriginType of
        ?MAP_ORIGIN_LU -> 
            Ymax = OYtr + (Width bsr 2),
            Ymin = OYtr - (Width bsr 2);
        _ -> 
            Ymax = OYtr + Width,
            Ymin = OYtr - Width
    end,
    AllArea = get_the_area(EtsScene#ets_scene.origin_type, OX, OY),
    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    F = fun(X, Y, _) ->
        Xtr = trunc(X*Cos+Y*Sin), Ytr = trunc(Y*Cos-X*Sin), %% 旋转坐标
        not (Xtr<Xmin orelse Xtr>Xmax orelse Ytr<Ymin orelse Ytr>Ymax)
    end,
    FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
    filter_battle_obj(AllUsers, F, Args, FilterObjets, undefined).

% get_rectangle_object_for_battle({Mid, SkillId}, CopyId, Length, Width, OX, OY, Radian, Args) ->
%     Cos     = math:cos(Radian),
%     Sin     = math:sin(Radian),
%     OXtr    = trunc(OX*Cos+OY*Sin), %% 旋转坐标
%     OYtr    = trunc(OY*Cos-OX*Sin),
%     Xmax    = OXtr + Length,
%     Xmin    = OXtr,
%     Ymax    = OYtr + (Width bsr 2),
%     Ymin    = OYtr - (Width bsr 2),
%     ?MYLOG(Mid==8 andalso (SkillId==3601012 orelse SkillId==3601013), "hjhai", "Radian:~p OXtr:~p OYtr:~p Xmin:~p Xmax:~p Ymin:~p Ymax:~p ~n", 
%         [Radian, OXtr, OYtr, Xmin, Xmax, Ymin, Ymax]),
%     AllArea = get_the_area(OX, OY),
%     AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
%     AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
%     F = fun(X, Y, _) ->
%         Xtr = trunc(X*Cos+Y*Sin), Ytr = trunc(Y*Cos-X*Sin), %% 旋转坐标
%         not (Xtr<Xmin orelse Xtr>Xmax orelse Ytr<Ymin orelse Ytr>Ymax)
%     end,
%     FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
%     filter_battle_obj(AllUsers, F, Args, FilterObjets, undefined).

%% 获得十字
get_cross_object_for_battle(CopyId, Length, Width, OX, OY, Radian, Args, EtsScene) ->
    #ets_scene{origin_type = OriginType} = EtsScene,
     case OriginType of
        ?MAP_ORIGIN_LU -> 
            Cos     = math:cos(Radian),
            Sin     = math:sin(Radian),
            OXtr    = trunc(OX*Cos+OY*Sin), %% 旋转坐标
            OYtr    = trunc(OY*Cos-OX*Sin),
            Xmax    = OXtr + Length,
            Xmin    = OXtr - Length,
            Ymax    = OYtr + (Width bsr 2),
            Ymin    = OYtr - (Width bsr 2),

            % y轴压缩一半
            CrossX = math:cos(Radian+math:pi()/2),
            CrossY = math:sin(Radian+math:pi()/2) / 2,
            CrossRadian = math:atan2(CrossY, CrossX),
            CrossCos     = math:cos(CrossRadian),
            CrossSin     = math:sin(CrossRadian),
            CrossOXtr    = trunc(OX*CrossCos+OY*CrossSin), %% 旋转坐标
            CrossOYtr    = trunc(OY*CrossCos-OX*CrossSin),
            CrossXmax    = CrossOXtr + Length,
            CrossXmin    = CrossOXtr - Length,
            CrossYmax    = CrossOYtr + (Width bsr 2),
            CrossYmin    = CrossOYtr - (Width bsr 2);
        _ -> 
            Cos     = math:cos(Radian),
            Sin     = math:sin(Radian),
            OXtr    = trunc(OX*Cos+OY*Sin), %% 旋转坐标
            OYtr    = trunc(OY*Cos-OX*Sin),
            Xmax    = OXtr + Length,
            Xmin    = OXtr - Length,
            Ymax    = OYtr + Width,
            Ymin    = OYtr - Width,

            % y轴压缩一半
            CrossX = math:cos(Radian+math:pi()/2),
            CrossY = math:sin(Radian+math:pi()/2),
            CrossRadian = math:atan2(CrossY, CrossX),
            CrossCos     = math:cos(CrossRadian),
            CrossSin     = math:sin(CrossRadian),
            CrossOXtr    = trunc(OX*CrossCos+OY*CrossSin), %% 旋转坐标
            CrossOYtr    = trunc(OY*CrossCos-OX*CrossSin),
            CrossXmax    = CrossOXtr + Length,
            CrossXmin    = CrossOXtr - Length,
            CrossYmax    = CrossOYtr + Width,
            CrossYmin    = CrossOYtr - Width
    end,
    
    % ?PRINT("Radian:~p ~p , CrossRadin:~p Radian:~p CrossRadin:~p ~n", 
    %     [Radian, Radian+math:pi()/2, CrossRadian, umath:radian_to_360degree(Radian), umath:radian_to_360degree(CrossRadian)]),
    AllArea = get_the_area(EtsScene#ets_scene.origin_type, OX, OY),
    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    AllUsers = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    F = fun(X, Y, _) ->
        Xtr = trunc(X*Cos+Y*Sin), Ytr = trunc(Y*Cos-X*Sin), %% 旋转坐标
        CrossXtr = trunc(X*CrossCos+Y*CrossSin), CrossYtr = trunc(Y*CrossCos-X*CrossSin), %% 旋转坐标
        (not (Xtr<Xmin orelse Xtr>Xmax orelse Ytr<Ymin orelse Ytr>Ymax)) orelse 
            (not (CrossXtr<CrossXmin orelse CrossXtr>CrossXmax orelse CrossYtr<CrossYmin orelse CrossYtr>CrossYmax))
    end,
    FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
    filter_battle_obj(AllUsers, F, Args, FilterObjets, undefined).

%% 获取扇形内的攻击对象
get_sector_object_for_battle(CopyId, X, Y, TX, TY, Distance, Area, Args, EtsScene) ->
    AllArea     = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    AllObjects  = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    AllUsers    = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    R2 = Distance*Distance,
    %% 向量OT
    Tvx = TX - X, Tvy = TY - Y,
    TLen2 = math:pow(Tvx, 2) + math:pow(Tvy, 2),
    CosArea = math:cos(umath:degree_to_radian(min(180, Area) bsr 1)),
    CosArea2 = math:pow(CosArea, 2),
    F = fun(Xtmp, Ytmp, _) ->
        DX = Xtmp-X, DY = Ytmp-Y,
        case abs(DX) =< Distance andalso abs(DY) =< (Distance bsr 1) andalso DX*DX + 4*DY*DY =< R2 of
            true ->
                Tmpvx = Xtmp - X, Tmpvy = Ytmp - Y,
                TmpLen2 = math:pow(Tmpvx, 2) + math:pow(Tmpvy, 2),
                Dot = Tvx*Tmpvx+Tvy*Tmpvy, %% 点积
                if
                    Dot > 0 andalso CosArea > 0 -> math:pow(Dot, 2) > TmpLen2*TLen2*CosArea2;
                    Dot < 0 andalso CosArea < 0 -> math:pow(Dot, 2) < TmpLen2*TLen2*CosArea2;
                    true -> Dot >= 0
                end;
            false -> false
        end
    end,
    FilterObjets = filter_battle_obj(AllObjects, F, Args, [], undefined),
    filter_battle_obj(AllUsers, F, Args, FilterObjets, undefined).

%% 获取攻击目标(进程无关)
%% 不检查范围，攻击列表有其他模块提供，直接选出最近就可以
get_object_for_battle(AllObjectList, _X, _Y, Args, SelectOp) ->
    % Area = 600,
    % Xmax = X + Area,
    % Xmin = X - Area,
    % Ymax = Y + Area,
    % Ymin = Y - Area,
    F = fun(_Xtmp, _Ytmp, Hide) -> Hide == 0 end,
    case filter_battle_obj(AllObjectList, F, Args, [], SelectOp) of
        [] -> false;
        [Object] -> Object;
        ObjectList when is_list(ObjectList)->
            [Object|_]  = ulists:list_shuffle(ObjectList),
            Object;
        _ -> false
    end.

get_object_for_collect(AllObjectList, EtsScene, _X, _Y, Args, SelectOp) ->
    F = fun(_Xtmp, _Ytmp, Hide) -> Hide == 0 end,
    case filter_collect_obj(AllObjectList, EtsScene, F, Args, [], SelectOp) of
        [] -> false;
        [Object] -> Object;
        ObjectList when is_list(ObjectList)->
            [Object|_]  = ulists:list_shuffle(ObjectList),
            Object;
        _ -> false
    end.

%% 过滤战斗对象
%% @param SelectOp 选择
filter_battle_obj([Der|T], Fun, Args, Result, SelectOp) ->
    #scene_calc_args_def{
        id=IdD, sign=DerSign, x=XD, y=YD, is_be_atted=IsBeAttedD, skill_owner=SkillOwnerD,
        mon = _Mon, ghost = GhostD, hide = HideD, group = GroupD, hp = DerHp
    } = make_scene_calc_args_def(Der),
    GuildIdD = lib_scene_object_ai:get_guild_id(Der),
    #scene_calc_args{
        group = GroupA, sign = SignA, id = IdA, owner_sign = OwnerSignA, owner_id = OwnerIdA, kind = MonKindA,
        guild_id = GuildIdA, pk_status = PkStatusA
    } = Args,
%%    ?IF(Id == 4294967297, ?PRINT("PkStatusA:~p GuildIdA:~p, GuildId:~p ~n", [PkStatusA, GuildIdA, GuildId]), skip),
    Result1 = if
        IsBeAttedD == 0 -> Result;
        DerHp =< 0 -> Result;
        GhostD == 1 -> Result; %% 幽灵不能攻击
        SignA == DerSign andalso IdA == IdD -> Result; %% 同一个对象
        GroupD /= 0 andalso GroupD == GroupA -> Result;  %% 同组
        GroupD == 0 andalso GroupD == GroupA andalso DerSign /= ?BATTLE_SIGN_PLAYER andalso DerSign == SignA -> Result; %% group值为0的非玩家对象不能选择同类同组攻击
        % SignA == ?BATTLE_SIGN_PLAYER andalso is_record(Mon, scene_mon) andalso Mon#scene_mon.boss /= ?MON_NORMAL_OUSIDE -> Result;
        OwnerIdA > 0 andalso DerSign == OwnerSignA andalso IdD == OwnerIdA -> Result; %% 是本对象的下属
        SkillOwnerD#skill_owner.id > 0 andalso SkillOwnerD#skill_owner.sign == SignA andalso SkillOwnerD#skill_owner.id == IdA -> Result; %% 是攻击方的所属
        SkillOwnerD#skill_owner.id > 0 andalso SkillOwnerD#skill_owner.sign == OwnerSignA andalso SkillOwnerD#skill_owner.id == OwnerIdA -> Result; %% 同一所属
        SignA == ?BATTLE_SIGN_MON andalso MonKindA == ?MON_KIND_ATT_NOT_PLAYER andalso DerSign == ?BATTLE_SIGN_PLAYER -> Result;   %% 不攻击人的进击怪
        %% 非全体模式下且组别等于0,同公会不攻击[未完成] todo   暂时先放开，后续完成PK模式代码记得修改
        (PkStatusA == false orelse PkStatusA == ?PK_PEACE) andalso SignA == DerSign andalso DerSign == ?BATTLE_SIGN_PLAYER -> Result;
        (PkStatusA == false orelse PkStatusA /= ?PK_ALL) andalso GuildIdA > 0 andalso GuildIdA == GuildIdD andalso GroupA == 0 -> Result;
        true ->
            case Fun(XD, YD, HideD) of
                false -> Result;
                true ->
                    case SelectOp of
                        {closest, OX, OY} ->
                            case Result of
                                [#scene_object{x = X1, y = Y1}|_] when abs(OX-XD)+abs(OY-YD) < abs(OX-X1)+abs(OY-Y1) ->
                                    [Der];
                                [#ets_scene_user{x = X1, y = Y1}|_] when abs(OX-XD)+abs(OY-YD) < abs(OX-X1)+abs(OY-Y1) ->
                                    [Der];
                                [] ->
                                    [Der];
                                _ ->
                                    Result
                            end;
                        _ ->
                            [Der|Result]
                    end
            end
    end,
    filter_battle_obj(T, Fun, Args, Result1, SelectOp);
filter_battle_obj([], _Fun, _Args, Result, _SelectOp) -> Result.

filter_collect_obj([H|T], EtsScene, Fun, Args, BattleObjL, SelectOp) ->
    NBattleObjL = do_filter_collect_obj(Args, H, EtsScene, Fun, BattleObjL, SelectOp),
    filter_collect_obj(T, EtsScene, Fun, Args, NBattleObjL, SelectOp);
filter_collect_obj([], _EtsScene, _F, _Args, BattleObjL, _SelectOp) -> BattleObjL.

do_filter_collect_obj(Aer, Der, _EtsScene, Fun, BattleObjL, SelectOp) ->
    #scene_calc_args_def{
        id=IdD, sign=DerSign, x=XD, y=YD, skill_owner=SkillOwnerD,
        mon = _Mon, ghost = GhostD, hide = HideD, group = GroupD
    } = make_scene_calc_args_def(Der),
    #scene_calc_args{
        group = GroupA, sign = AerSign, id = IdA, owner_sign = OwnerSignA,
        owner_id = OwnerIdA, guild_id = _GuildIdA
    } = Aer,
    Res =
        if
            not is_record(_Mon, scene_mon) ->
                {false, 0};
            _Mon#scene_mon.kind /= ?MON_KIND_COLLECT ->
                {false, 0};
            _Mon#scene_mon.is_collecting == 1 ->
                {false, 0};
            _Mon#scene_mon.has_cltimes == 0 ->
                {false, 0};
            IdA == SkillOwnerD#skill_owner.id andalso AerSign == SkillOwnerD#skill_owner.sign -> {false, 14}; % 不能攻击自己的下属
            OwnerIdA > 0 andalso OwnerIdA == IdD andalso OwnerSignA == DerSign -> {false, 1}; % 不能攻击所属方
            OwnerIdA > 0 andalso OwnerIdA == SkillOwnerD#skill_owner.id andalso OwnerSignA == SkillOwnerD#skill_owner.sign -> {false, 2}; % 不能攻击同所属方
            IdA == IdD andalso AerSign == DerSign -> {false, 3};    % 不能攻击自己
            GroupA > 0 andalso GroupA == GroupD -> {false, 4};  % 分组一样
            GhostD > 0 -> {false, 5};   % 是幽灵状态
            true -> true
        end,
    case Res == true andalso Fun(XD, YD, HideD) == true of
        false -> BattleObjL;
        true ->
            case SelectOp of
                {closest, OX, OY} ->
                    case BattleObjL of
                        [#scene_object{x = X1, y = Y1}|_] when abs(OX-XD)+abs(OY-YD) < abs(OX-X1)+abs(OY-Y1) ->
                            [Der];
                        [#ets_scene_user{x = X1, y = Y1}|_] when abs(OX-XD)+abs(OY-YD) < abs(OX-X1)+abs(OY-Y1) ->
                            [Der];
                        [] ->
                            [Der];
                        _ ->
                            BattleObjL
                    end;
                _ ->
                    [Der|BattleObjL]
            end
    end.

get_scene_object_for_assist(CopyId, OX, OY, Area, TeamIdA, Args) ->
    AllArea = lib_scene_calc:get_the_area(OX, OY),
    AllUser = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
    Xmax = OX + Area,
    Xmin = OX - Area,
    Ymax = OY + Area,
    Ymin = OY - Area,
    % {GroupA, SignA, IdA, OwnerSignA, OwnerIdA} = Args,
    % #scene_calc_args{group = GroupA, sign = SignA, id = IdA, owner_sign = OwnerSignA, owner_id = OwnerIdA, kind = MonKindA} = Args,
    #scene_calc_args{
        group = GroupA, sign = SignA, id = IdA, owner_sign = OwnerSignA, owner_id = OwnerIdA, kind = MonKindA,
        guild_id = _GuildIdA, pk_status = _PkStatusA
        } = Args,
    F = fun(Elem) ->
        case Elem of
            #scene_object{id=Id, sign=Sign, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, ghost=Ghost, group=Group}, skill_owner=SkillOwner} -> TeamId = 0;
            #ets_scene_user{id=Id, x=X, y=Y, battle_attr=#battle_attr{hp=Hp, ghost=Ghost, group=Group}, team=#status_team{team_id=TeamId} } ->
                Sign=?BATTLE_SIGN_PLAYER, SkillOwner=[]
        end,
        _GuildId = lib_scene_object_ai:get_guild_id(Elem),
        if
            Ghost == 1 -> false;
            Hp =< 0 -> false;
            X > Xmax orelse X < Xmin orelse Y > Ymax orelse Y < Ymin -> false;
            SignA == Sign andalso IdA == Id -> false; %% 自己排除
            SignA == ?BATTLE_SIGN_MON andalso MonKindA == ?MON_KIND_ATT_NOT_PLAYER andalso Sign == ?BATTLE_SIGN_PLAYER -> false;   %% 不攻击人的进击怪
            TeamIdA > 0 andalso TeamIdA == TeamId -> true;
            OwnerIdA > 0 andalso Sign == OwnerSignA andalso Id == OwnerIdA -> true; %% 是本对象的下属
            SkillOwner#skill_owner.id > 0 andalso SkillOwner#skill_owner.sign == SignA andalso SkillOwner#skill_owner.id == IdA -> true;
            SkillOwner#skill_owner.id > 0 andalso SkillOwner#skill_owner.sign == OwnerSignA andalso SkillOwner#skill_owner.id == OwnerIdA -> true;
            GroupA > 0 andalso GroupA =:= Group -> true;
            % 非全体模式下且组别等于0,是同盟[未完成]
            % (PkStatusA == false orelse PkStatusA /= ?PK_ALL) andalso GuildIdA > 0 andalso GuildIdA == GuildId andalso GroupA == 0 -> true;
            true -> false
        end
    end,
    lists:filter(F, AllUser) ++ lists:filter(F, AllObjects).

get_scene_mon_for_assist(CopyId, OX, OY, _Area, _TeamIdA, Args) ->
    AllArea = lib_scene_calc:get_the_area(OX, OY),
    AllUser = lib_scene_agent:get_all_area_user_by_bd(AllArea, CopyId),
    AllObjects = lib_scene_object_agent:get_all_area_object_by_bd(AllArea, CopyId),
%%    Xmax = OX + Area,
%%    Xmin = OX - Area,
%%    Ymax = OY + Area,
%%    Ymin = OY - Area,
    % {_GroupA, SignA, IdA, OwnerSignA, OwnerIdA} = Args,
    % #scene_calc_args{sign = SignA, id = IdA, owner_sign = OwnerSignA, owner_id = OwnerIdA, kind = MonKindA} = Args,
    #scene_calc_args{
        group = _GroupA, sign = SignA, id = IdA, owner_sign = OwnerSignA, owner_id = OwnerIdA, kind = MonKindA,
        guild_id = _GuildIdA, pk_status = _PkStatusA
        } = Args,
    F = fun(Elem) ->
        case Elem of
            #scene_object{id=Id, sign=Sign, x=_X, y=_Y, battle_attr=#battle_attr{hp=Hp, ghost=Ghost, group=Group}, skill_owner=SkillOwner} -> TeamId = 0;
            #ets_scene_user{id=Id, x=_X, y=_Y, battle_attr=#battle_attr{hp=Hp, ghost=Ghost, group=Group}, team=#status_team{team_id=TeamId} } ->
                Sign=?BATTLE_SIGN_PLAYER, SkillOwner=[]
        end,
        _GuildId = lib_scene_object_ai:get_guild_id(Elem),
        if
            Ghost == 1 ->  false;
            Hp =< 0 ->  false;
            Sign =/= ?BATTLE_SIGN_MON -> false;
%%            X > Xmax orelse X < Xmin orelse Y > Ymax orelse Y < Ymin ->?MYLOG("cym",  "log1 ~n" , []), false;
            SignA == Sign andalso IdA == Id -> false; %% 自己排除
            SignA == ?BATTLE_SIGN_MON andalso MonKindA == ?MON_KIND_ATT_NOT_PLAYER andalso Sign == ?BATTLE_SIGN_PLAYER -> false;   %% 不攻击人的进击怪
            TeamId == 0 -> true;
            OwnerIdA > 0 andalso Sign == OwnerSignA andalso Id == OwnerIdA -> true; %% 是本对象的下属
            SkillOwner#skill_owner.id > 0 andalso SkillOwner#skill_owner.sign == SignA andalso SkillOwner#skill_owner.id == IdA -> true;
            SkillOwner#skill_owner.id > 0 andalso SkillOwner#skill_owner.sign == OwnerSignA andalso SkillOwner#skill_owner.id == OwnerIdA -> true;
            % 非全体模式下且组别等于0,是同盟[未完成]
            % (PkStatusA == false orelse PkStatusA /= ?PK_ALL) andalso GuildIdA > 0 andalso GuildIdA == GuildId andalso GroupA == 0 -> true; 
            Group == 0 -> true;
            true -> false
        end
    end,
    lists:filter(F, AllUser) ++ lists:filter(F, AllObjects).


%%  获取要广播的范围用户信息
get_broadcast_user(CopyId, X, Y, EtsScene) ->
    Area = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    lib_scene_agent:get_all_area_user(Area, CopyId).

%%  获取要广播的范围场景对象信息
get_broadcast_object(CopyId, X, Y, EtsScene) ->
    Area = get_the_area(EtsScene#ets_scene.origin_type, X, Y),
    lib_scene_object_agent:get_all_area_object(Area, CopyId).

%% 是否在9宫格内
is_area_scene_by_scene_id(SceneId, X1, Y1, X2, Y2) ->
    OriginType = lib_scene:get_origin_type(SceneId),
    is_area_scene(OriginType, X1, Y1, X2, Y2).

%是否在9宫格内
is_area_scene(_OriginType, X1, Y1, X2, Y2) ->
    XY2 = get_xy(X2, Y2),
    XY = get_xy(X1, Y1),
    if
        XY == XY2 orelse XY == XY2 + ?LU_MAP_LENGTH_R orelse XY == XY2 + ?LU_MAP_LENGTH_L orelse XY == XY2 + ?LU_MAP_LENGTH_U
                orelse XY == XY2 + ?LU_MAP_LENGTH_D orelse XY == XY2 + ?LU_MAP_LENGTH_LU orelse XY == XY2 + ?LU_MAP_LENGTH_RD
                orelse XY == XY2 + ?LU_MAP_LENGTH_RU  orelse XY == XY2 + ?LU_MAP_LENGTH_LD ->
            true;
        true->
            false
    end.
% is_area_scene(_OriginType, X1, Y1, X2, Y2) ->
%     XY2 = get_xy(X2, Y2),
%     XY = get_xy(X1, Y1),
%     if
%         XY == XY2 orelse XY == XY2 + ?LD_MAP_LENGTH_R orelse XY == XY2 + ?LD_MAP_LENGTH_L orelse XY == XY2 + ?LD_MAP_LENGTH_U
%                 orelse XY == XY2 + ?LD_MAP_LENGTH_D orelse XY == XY2 + ?LD_MAP_LENGTH_LU orelse XY == XY2 + ?LD_MAP_LENGTH_RD
%                 orelse XY == XY2 + ?LD_MAP_LENGTH_RU  orelse XY == XY2 + ?LD_MAP_LENGTH_LD ->
%             true;
%         true->
%             false
%     end.
% is_area_scene(_OriginType, _X1, _Y1, _X2, _Y2) ->
%     ?ERR("is_area_scene _OriginType:~p, _X1:~p, _Y1:~p, _X2:~p, _Y2:~p ~n", [_OriginType, _X1, _Y1, _X2, _Y2]),
%     false.

% %% 是否在9宫格内
% is_area_scene(OriginType, X1, Y1, X2, Y2) ->
%     NineMap = get_nine_map(OriginType),
%     XY2 = get_xy(X2, Y2),
%     XY = get_xy(X1, Y1),
%     if
%         XY == XY2 orelse XY == XY2 + NineMap#nine_map.r orelse XY == XY2 + NineMap#nine_map.l
%                 orelse XY == XY2 + NineMap#nine_map.u orelse XY == XY2 + NineMap#nine_map.d
%                 orelse XY == XY2 + NineMap#nine_map.lu orelse XY == XY2 + NineMap#nine_map.rd
%                 orelse XY == XY2 + NineMap#nine_map.ru  orelse XY == XY2 + NineMap#nine_map.ld ->
%             true;
%         true->
%             false
%     end.

% %% 获取九宫格
% get_the_area(OriginType, X, Y) ->
%     NineMap = get_nine_map(OriginType),
%     XY = get_xy(X, Y),
%     [XY, XY + NineMap#nine_map.r, XY + NineMap#nine_map.l, 
%         XY + NineMap#nine_map.u, XY + NineMap#nine_map.d, 
%         XY + NineMap#nine_map.lu, XY + NineMap#nine_map.rd, 
%         XY + NineMap#nine_map.ru, XY +  NineMap#nine_map.ld].

%% 获取九宫格[只能场景进程使用]
get_the_area(X, Y) ->
    OriginType = lib_scene_agent:get_origin_type(),
    get_the_area(OriginType, X, Y).

% 获取九宫格
get_the_area(_OriginType, X, Y) ->
    XY = get_xy(X, Y),
    [XY, XY + ?LU_MAP_LENGTH_R, XY + ?LU_MAP_LENGTH_L,
        XY + ?LU_MAP_LENGTH_D, XY + ?LU_MAP_LENGTH_U, 
        XY + ?LU_MAP_LENGTH_RD, XY + ?LU_MAP_LENGTH_LD, 
        XY + ?LU_MAP_LENGTH_RU, XY + ?LU_MAP_LENGTH_LU].
% get_the_area(_OriginType, X, Y) ->
%     XY = get_xy(X, Y),
%     [XY, XY + ?LD_MAP_LENGTH_R, XY + ?LD_MAP_LENGTH_L,
%         XY + ?LD_MAP_LENGTH_U, XY + ?LD_MAP_LENGTH_D, XY + ?LD_MAP_LENGTH_LU,
%         XY + ?LD_MAP_LENGTH_RD, XY + ?LD_MAP_LENGTH_RU, XY + ?LD_MAP_LENGTH_LD].
% get_the_area(_OriginType, _X, _Y) ->
%     ?ERR("get_the_area _OriginType:~p, _X:~p, _Y:~p ~n", [_OriginType, _X, _Y]),
%     [].

% get_the_area(X, Y, Distance) ->
%     Dis = trunc(umath:ceil(Distance / ?LENGTH)),
%     Edge = Dis * 2 + 1,
%     XY = get_xy(X, Y),
%     Left = XY - (?MAP_LENGTH * Dis) - Dis,
%     Grids = [Left + Line * ?MAP_LENGTH + Col || Line <- lists:seq(0, Edge - 1), Col <- lists:seq(0, Edge - 1)],
%     [P || P <- Grids, P > 0].

%%--------------------------九宫格加载场景---------------------------
%% 根据每张地图实际大小，分成一个个10*15的大格子，并从左到右赋予编号。
%% 如把整个地图共有100*150个格子，0，0坐标点为原点，以10*15为一个格子，从左到右编号， 那么坐标50,50所在的格子的编号就是Y div 15 * 10 + X div 10 + 1.

%% 获取当前所在的格子的编号
get_xy(X, Y) ->
    Y div ?WIDTH * ?MAP_LENGTH + X div ?LENGTH + 1.

%%当人物或者怪物移动时候的广播
%%终点要X1，Y1，原点是X2,Y2
%%BinData走路协议包, BinData1移除玩家包 BinData2有玩家进入
move_broadcast(CopyId, X1, Y1, X2, Y2, BinData, BinData1, BinData2, SendList, EtsScene) ->
    move_broadcast(true, CopyId, X1, Y1, X2, Y2, BinData, BinData1, BinData2, SendList, EtsScene).
move_broadcast(IsBroadcast, CopyId, X1, Y1, X2, Y2, BinData, BinData1, BinData2, SendList, EtsScene) ->
    XY1 = get_xy(X1, Y1),
    XY2 = get_xy(X2, Y2),
    move_user_broadcast(IsBroadcast, CopyId, XY1, XY2, BinData, BinData1, BinData2, SendList, EtsScene),

    %% 怪物移动不用通知怪物
    case SendList of
        [] -> skip;
        _  -> move_mon_broadcast(CopyId, XY1, XY2, SendList, EtsScene)
    end.

%% 广播给玩家
move_user_broadcast(IsBroadcast, CopyId, XYNew, XYOld, BinData, BinData1, BinData2, SendList, EtsScene) ->
    [AreaAdd, AreaDel, AreaMove] = get_move_area(EtsScene#ets_scene.origin_type, XYOld, XYNew),
    UserAdd = lib_scene_agent:move_send_and_getuser(AreaAdd, CopyId, BinData2),
    UserDel = lib_scene_agent:move_send_and_getid(AreaDel, CopyId, BinData1),
    case IsBroadcast of
        true  -> lib_scene_agent:send_to_any_area(AreaMove, CopyId, BinData);
        false -> skip
    end,
    case SendList =:= [] orelse (UserAdd == [] andalso UserDel == []) of
        true ->
            ok;
        false ->
            %%加入和移除玩家
            {ok, BinData3} = pt_120:write(12011, [UserAdd, UserDel]),
            [Node, Sid] = SendList,
            lib_server_send:send_to_sid(Node, Sid, BinData3)
    end.


%% =====================================
%% =============== 怪物 ================
%% =====================================
%% 注意：这里仅用于mod_scene_agent进程内调用
%% 广播给怪物
move_mon_broadcast(CopyId, XY1, XY2, SendList, EtsScene) ->
    [AreaAdd, AreaDel, _] = get_move_area(EtsScene#ets_scene.origin_type, XY2, XY1),
    ObjectAdd = lib_scene_object_agent:get_all_area_object(AreaAdd, CopyId),
    ObjectDel = lib_scene_object_agent:get_all_area(AreaDel, CopyId),
    case ObjectAdd == [] andalso ObjectDel == [] of
        true ->
            ok;
        false ->
            %%加入和移除怪物
            {ok, BinData4} = pt_120:write(12012, [ObjectAdd, ObjectDel]),
            [Node, Sid] = SendList,
            lib_server_send:send_to_sid(Node, Sid, BinData4)
    end.

%% 移动时，获取增加和移除对象的格子[只能场景进程使用]
get_move_area(XYOld, XYNew) ->
    OriginType = lib_scene_agent:get_origin_type(),
    get_move_area(OriginType, XYOld, XYNew).

%% 移动时，获取增加和移除对象的格子
%% @return [AreaAdd, AreaDel, AreaMove]
get_move_area(_OriginType, XYOld, XYNew) ->
    if
        XYOld == XYNew ->  %% 同个格子移动 5
            [
                [], [],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_U, 
                    XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU]
            ];
        XYOld + ?LU_MAP_LENGTH_R == XYNew -> %% 向右移动 6
            [
                [XYNew + ?LU_MAP_LENGTH_R, XYNew + ?LU_MAP_LENGTH_RD, XYNew + ?LU_MAP_LENGTH_RU],
                [XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_LU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_RU]
            ];
        XYOld + ?LU_MAP_LENGTH_L == XYNew -> %% 向左移动 4
            [
                [XYNew + ?LU_MAP_LENGTH_L, XYNew + ?LU_MAP_LENGTH_LD, XYNew + ?LU_MAP_LENGTH_LU],
                [XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_RU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_LU]
            ];
        XYOld + ?LU_MAP_LENGTH_U == XYNew -> %% 向上移动 8
            [
                [XYNew + ?LU_MAP_LENGTH_U, XYNew + ?LU_MAP_LENGTH_LU, XYNew + ?LU_MAP_LENGTH_RU],
                [XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU]
            ];
        XYOld + ?LU_MAP_LENGTH_D == XYNew -> %% 向下移动 2
            [
                [XYNew + ?LU_MAP_LENGTH_D, XYNew + ?LU_MAP_LENGTH_LD, XYNew + ?LU_MAP_LENGTH_RD],
                [XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD]
            ];
        XYOld + ?LU_MAP_LENGTH_LU == XYNew -> %% 向左上移动 7
            [
                [XYNew + ?LU_MAP_LENGTH_LU, XYNew + ?LU_MAP_LENGTH_L, XYNew + ?LU_MAP_LENGTH_U, XYNew + ?LU_MAP_LENGTH_LD, XYNew + ?LU_MAP_LENGTH_RU],
                [XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_RU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_LU]
            ];
        XYOld + ?LU_MAP_LENGTH_LD == XYNew -> %% 向左下移动 1
            [
                [XYNew + ?LU_MAP_LENGTH_LD, XYNew + ?LU_MAP_LENGTH_L, XYNew + ?LU_MAP_LENGTH_D, XYNew + ?LU_MAP_LENGTH_LU, XYNew + ?LU_MAP_LENGTH_RD],
                [XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_LD]
            ];
        XYOld + ?LU_MAP_LENGTH_RU == XYNew -> %% 向右上移动 9
            [
                [XYNew + ?LU_MAP_LENGTH_RU, XYNew + ?LU_MAP_LENGTH_R, XYNew + ?LU_MAP_LENGTH_U, XYNew + ?LU_MAP_LENGTH_RD, XYNew + ?LU_MAP_LENGTH_LU],
                [XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_LU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_RU]
            ];
        XYOld + ?LU_MAP_LENGTH_RD == XYNew -> %% 向右下移动 3
            [
                [XYNew + ?LU_MAP_LENGTH_RD, XYNew + ?LU_MAP_LENGTH_R, XYNew + ?LU_MAP_LENGTH_D, XYNew + ?LU_MAP_LENGTH_RU, XYNew + ?LU_MAP_LENGTH_LD],
                [XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_U, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU],
                [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_RD]
            ];
        true -> %% 跨相邻九宫格移动
            Area1 = [XYNew, XYNew + ?LU_MAP_LENGTH_R, XYNew + ?LU_MAP_LENGTH_L, XYNew + ?LU_MAP_LENGTH_D, XYNew + ?LU_MAP_LENGTH_U, 
                XYNew + ?LU_MAP_LENGTH_RD, XYNew + ?LU_MAP_LENGTH_LD, XYNew + ?LU_MAP_LENGTH_RU, XYNew + ?LU_MAP_LENGTH_LU],
            Area2 = [XYOld, XYOld + ?LU_MAP_LENGTH_R, XYOld + ?LU_MAP_LENGTH_L, XYOld + ?LU_MAP_LENGTH_D, XYOld + ?LU_MAP_LENGTH_U, 
                XYOld + ?LU_MAP_LENGTH_RD, XYOld + ?LU_MAP_LENGTH_LD, XYOld + ?LU_MAP_LENGTH_RU, XYOld + ?LU_MAP_LENGTH_LU],
            F = fun(E, [AddUserL, DelUserL, MoveUserL]) ->
                case lists:member(E, Area2) of
                    true  -> [AddUserL, DelUserL -- [E], [E|MoveUserL]];
                    false -> [[E|AddUserL], DelUserL -- [E], [E|MoveUserL]]
                end
            end,
            lists:foldl(F, [[], Area2, []], Area1)
    end.
% get_move_area(_OriginType, XYOld, XYNew) ->
%     if
%         XYOld == XYNew ->  %% 同个格子移动 5
%             [
%                 [], [],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_D,
%                     XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_RU, XYOld+ ?LD_MAP_LENGTH_LD]
%             ];
%         XYOld + ?LD_MAP_LENGTH_R == XYNew -> %% 向右移动 6
%             [
%                 [XYNew + ?LD_MAP_LENGTH_R, XYNew + ?LD_MAP_LENGTH_RD, XYNew + ?LD_MAP_LENGTH_RU],
%                 [XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_LD],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_U,  XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_RU]
%             ];
%         XYOld + ?LD_MAP_LENGTH_L == XYNew -> %% 向左移动 4
%             [
%                 [XYNew + ?LD_MAP_LENGTH_L, XYNew + ?LD_MAP_LENGTH_LU, XYNew + ?LD_MAP_LENGTH_LD],
%                 [XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_RU],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_LD]
%             ];
%         XYOld + ?LD_MAP_LENGTH_U == XYNew -> %% 向上移动 8
%             [
%                 [XYNew + ?LD_MAP_LENGTH_U, XYNew + ?LD_MAP_LENGTH_LU, XYNew + ?LD_MAP_LENGTH_RU],
%                 [XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_LD],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_RU]
%             ];
%         XYOld + ?LD_MAP_LENGTH_D == XYNew -> %% 向下移动 2
%             [
%                 [XYNew + ?LD_MAP_LENGTH_D, XYNew + ?LD_MAP_LENGTH_RD, XYNew + ?LD_MAP_LENGTH_LD],
%                 [XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_RU],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_LD]
%             ];
%         XYOld + ?LD_MAP_LENGTH_LU == XYNew -> %% 向左上移动 7
%             [
%                 [XYNew + ?LD_MAP_LENGTH_L, XYNew + ?LD_MAP_LENGTH_LU, XYNew + ?LD_MAP_LENGTH_U, XYNew + ?LD_MAP_LENGTH_RU, XYNew + ?LD_MAP_LENGTH_LD],
%                 [XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_LD, XYOld + ?LD_MAP_LENGTH_RU],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_U]
%             ];
%         XYOld + ?LD_MAP_LENGTH_LD == XYNew -> %% 向左下移动 1
%             [
%                 [XYNew + ?LD_MAP_LENGTH_LU, XYNew + ?LD_MAP_LENGTH_L, XYNew + ?LD_MAP_LENGTH_LD, XYNew + ?LD_MAP_LENGTH_D, XYNew + ?LD_MAP_LENGTH_RD],
%                 [XYOld + ?LD_MAP_LENGTH_RD, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_RU, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_LU],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_LD]
%             ];
%         XYOld + ?LD_MAP_LENGTH_RU == XYNew -> %% 向右上移动 9
%             [
%                 [XYNew + ?LD_MAP_LENGTH_R, XYNew + ?LD_MAP_LENGTH_RD, XYNew + ?LD_MAP_LENGTH_RU, XYNew + ?LD_MAP_LENGTH_U, XYNew + ?LD_MAP_LENGTH_LU],
%                 [XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_LD, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_RU]
%             ];
%         XYOld + ?LD_MAP_LENGTH_RD == XYNew -> %% 向右下移动 3
%             [
%                 [XYNew + ?LD_MAP_LENGTH_R, XYNew + ?LD_MAP_LENGTH_LD, XYNew + ?LD_MAP_LENGTH_D, XYNew + ?LD_MAP_LENGTH_RD, XYNew + ?LD_MAP_LENGTH_RU],
%                 [XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_RU, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_LD],
%                 [XYOld, XYOld + ?LD_MAP_LENGTH_R, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD]
%             ];
%         true -> %% 跨相邻九宫格移动
%             Area1 = [XYNew, XYNew + ?LD_MAP_LENGTH_LU, XYNew + ?LD_MAP_LENGTH_U, XYNew + ?LD_MAP_LENGTH_RU, XYNew + ?LD_MAP_LENGTH_L, XYNew + ?LD_MAP_LENGTH_R,
%                 XYNew + ?LD_MAP_LENGTH_LD, XYNew + ?LD_MAP_LENGTH_D, XYNew + ?LD_MAP_LENGTH_RD],
%             Area2 = [XYOld, XYOld + ?LD_MAP_LENGTH_LU, XYOld + ?LD_MAP_LENGTH_U, XYOld + ?LD_MAP_LENGTH_RU, XYOld + ?LD_MAP_LENGTH_L, XYOld + ?LD_MAP_LENGTH_R,
%                 XYOld + ?LD_MAP_LENGTH_LD, XYOld + ?LD_MAP_LENGTH_D, XYOld + ?LD_MAP_LENGTH_RD],
%             F = fun(E, [AddUserL, DelUserL, MoveUserL]) ->
%                 case lists:member(E, Area2) of
%                     true  -> [AddUserL, DelUserL -- [E], [E|MoveUserL]];
%                     false -> [[E|AddUserL], DelUserL -- [E], [E|MoveUserL]]
%                 end
%             end,
%             lists:foldl(F, [[], Area2, []], Area1)
%     end.
% get_move_area(_OriginType, _XYOld, _XYOld) ->
%     ?ERR("get_move_area _OriginType:~p, _X:~p, _Y:~p ~n", [_OriginType, _XYOld, _XYOld]),
%     [[], [], []].

%% 存储九宫格的数量
save_areas_num(XYOld, XYNew, CopyId) ->
    [AddArea, DelArea, _] = get_move_area(XYOld, XYNew),
    [lib_scene_agent:save_area_num(E, CopyId,  1) || E <- AddArea],
    [lib_scene_agent:save_area_num(E, CopyId, -1) || E <- DelArea],
    ok.

%% 像素坐标转换为逻辑坐标
pixel_to_logic_coordinate(Xpx, Ypx) ->
    {Xpx div ?LENGTH_UNIT, Ypx div ?WIDTH_UNIT}.

%% 像素坐标转换为逻辑坐标
pixel_to_logic_coordinate(?MAP_ORIGIN_LU, Xpx, Ypx) ->
    {Xpx div ?LU_LENGTH_UNIT, Ypx div ?LU_WIDTH_UNIT};
pixel_to_logic_coordinate(_OriginType, Xpx, Ypx) ->
    pixel_to_logic_coordinate(Xpx, Ypx).

%% 逻辑坐标转换为像素坐标
logic_to_pixel_coordinate(Xl, Yl) ->
    {Xl * ?LENGTH_UNIT, Yl * ?WIDTH_UNIT}.

% %% 获取螺旋生长的格子 由内而外
% get_helix_points_from_inside(X, Y, MaxX, MaxY, Num, Check) ->