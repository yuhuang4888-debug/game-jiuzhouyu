%% ---------------------------------------------------------------------------
%% @doc lib_scene_object_ai
%% @author ming_up@foxmail.com
%% @since  2017-02-11
%% @deprecated 场景对象公共ai
%% ---------------------------------------------------------------------------
-module(lib_scene_object_ai).

-export([]).

-include("scene.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("battle.hrl").
-include("skill.hrl").
-include("figure.hrl").
-include("def_fun.hrl").
-include("server.hrl").

-export([
        mon_to_mon_ai/7
        , get_next_step/8
        , move/5
        , move_dest_path/5
        , dest_path/5
        , dest_path_speed/6
        , auto_move/1
        , is_combo/2
        , trace_to_att/11
        , set_ac_state/2
        , combo/2
        % , find_target_combo/2
        , get_skill_owner_args/1
        , get_guild_id/1
        , get_pk_status/1
        , select_a_skill/8
        , mon_speak/2
        , mon_frenzy/2
        , handle_assist_res/5
        , handle_battle_res/5
        , assist_combo_res/3
        , battle_combo_res/3
        , object_ac_skill/3
        ]).

-compile(export_all).

%% 怪物走路ai触发(必须得有分组属性)
mon_to_mon_ai(_Scene, _CopyId, _Xpx, _Ypx, _Id, _Pid, _Group) -> 
    % case Group /= 0 of
    %     true ->
    %         {X, Y} = lib_scene_calc:pixel_to_logic_coordinate(Xpx, Ypx),
    %         List = case lib_mon:get_ai(Scene, CopyId, X, Y) of
    %                    skip -> [];
    %                    Other -> Other
    %                end,
    %         [Aid ! {'ai', Id, Pid, 1, Group}  || Aid <- List]; %% 数字1表示是怪物走路
    %     false ->
    %         skip
    % end.
    ok.

%% 获取下一步的坐标
get_next_step(OX, OY, StrikingDistance, SceneId, CopyId, TX, TY, IsCheckBlock0) ->
    % 动态区域默认不检查障碍区
    IsDynamicScene = lib_scene:is_dynamic_scene(SceneId),
    IsCheckBlock = ?IF(IsDynamicScene, false, IsCheckBlock0),
    case trace_line(OX, OY, TX, TY, StrikingDistance) of
        true -> attack;
        {LineNX, LineNY} when IsCheckBlock ->
            case lib_scene:is_blocked(SceneId, CopyId, LineNX, LineNY) of
                false -> {LineNX, LineNY};
                _     -> lib_scene_object_path:get_next_point(OX, OY, SceneId, CopyId, StrikingDistance, TX, TY)
            end;
        {LineNX, LineNY} -> {LineNX, LineNY}
    end.

%% 怪物移动
move(X, Y, SceneObject, Speed, IsCheckBlock) ->
    #scene_object{x=MonX, y=MonY, scene=SceneId, copy_id=CopyId} = SceneObject,
    % 动态区域一律不判断动态区域
    IsDynamicScene = lib_scene:is_dynamic_scene(SceneId),
    if
        IsDynamicScene -> IsBlocked = false;
        IsCheckBlock -> IsBlocked = lib_scene:is_blocked(SceneId, CopyId, X, Y);
        true -> IsBlocked = false
    end,
    if
        IsBlocked -> block;
        true ->
            Dis = umath:distance({X, Y}, {MonX, MonY}),
            NewSceneObject = SceneObject#scene_object{x = X, y = Y},
            lib_scene_object:send_object_move_msg(MonX, MonY, NewSceneObject),
            lib_scene_object:change_xy(NewSceneObject),
            Time = case Dis == 0 of
                true  -> 200;
                false -> round(Dis * 1000 / max(1,Speed))+100
            end,
            %% ?PRINT("============= MOVE ONCE ~ts:~p~n", [ulists:list_to_bin(SceneObject#scene_object.figure#figure.name), {Speed, Time}]),
            {true, NewSceneObject, Time}
    end.

%% 直线移动
move_dest_path(SceneObject, OldX, OldY, X, Y) ->
    Dis = umath:distance({OldX, OldY}, {X, Y}),
    NewSceneObject = SceneObject#scene_object{x = X, y = Y},
    lib_scene_object:send_object_move_msg(OldX, OldY, NewSceneObject),
    lib_scene_object:change_xy(NewSceneObject),
    Time = case Dis == 0 of
        true  -> 1000;
        false -> round(Dis * 1000 / max(1, NewSceneObject#scene_object.battle_attr#battle_attr.speed))
    end,
    {NewSceneObject, Time}.

-define(ONE_STEP_X, 120).
-define(ONE_STEP_Y, 60).
-define(ONE_STEP,   134).

%% 随机方向移动
auto_move(SceneObject) ->
    #scene_object{x=X, y=Y, scene=SceneId, copy_id=CopyId, d_x=Dx, d_y=Dy} = SceneObject,
    {Xnext, Ynext} = case abs(X-Dx) > ?ONE_STEP_X*2 orelse abs(Y-Dy) > ?ONE_STEP_Y*2 of
        true -> {Dx, Dy};
        _ ->
            Angle = urand:rand(-1000, 1000)*math:pi()/1000,
            TmpX = max(0, round(X+?ONE_STEP*math:sin(Angle))),
            TmpY = max(0, round(Y+?ONE_STEP*math:cos(Angle))),
            case lib_scene:is_blocked(SceneId, CopyId, TmpX, TmpY) of
                true -> {Dx, Dy};
                _ -> {TmpX, TmpY}
            end
    end,
    move_dest_path(SceneObject, X, Y, Xnext, Ynext).

%%先进入曼哈顿距离遇到障碍物再转向A*
%%每次移动2格
%%X1,Y1 原位置
%%X2,Y2 目标位置
trace_line(OX, OY, OX, OY, _StrikingDistance) -> true; %% 已经到达目标位置
trace_line(OX, OY, TX, TY, StrikingDistance) ->
    %% ActualPx = umath:distance({OX, OY}, {TX, TY}),
    StrikingDistance1 = max(80, StrikingDistance),
    Str2 = StrikingDistance1*StrikingDistance1,
    DX = TX-OX,
    DY = TY-OY,
    %% ?PRINT("ATTACK ~p~n", [{DX, DY, DX*DX + 4*DY*DY, Str2}]),
    case DX*DX + 4*DY*DY =< Str2 of
        %% case ActualPx =< StrikingDistance of
        true when StrikingDistance =< 100 -> {TX, TY};
        true -> true; %% 可直接攻击
        %% false when ActualPx =< ?ONE_STEP -> {TX, TY};
        false ->
            OriginalAngle = math:atan2(DY, DX),
            %% 最后走的距离的角度微调，使怪物不容易扎堆
            %% GrapLen = max(ActualPx-StrikingDistance, 0),
            %% if GrapLen > ?ONE_STEP ->
            %% ?PRINT("StrikingDistance1 ~p~n", [{StrikingDistance, StrikingDistance1, DX, DY}]),
            if
                abs(DX)-?ONE_STEP_X*2 =< StrikingDistance1 andalso abs(DY)-?ONE_STEP_Y*2 =< StrikingDistance1 ->
                    %% 最后一步
                    Angle = OriginalAngle + (math:pi()/40 * urand:rand(1,9)) * urand:rand(-1,1),
                    TanA = math:tan(Angle),
                    TanA2 = TanA*TanA,
                    Strl2 = (StrikingDistance1-10)*(StrikingDistance1-10),
                    X0 = trunc(TX+math:sqrt(Strl2/(1+4*TanA2))*(-DX div max(1, abs(DX)))),
                    Y0 = trunc(TY+math:sqrt(Strl2*TanA2/(1+4*TanA2))*(-DY div max(1, abs(DY)))),
                    %%?PRINT("X0, Y0 ~p~n", [{X0-TX, Y0-TY}]),
                    ok;
                true ->
                    X0 = round(OX+?ONE_STEP*math:cos(OriginalAngle)),
                    Y0 = round(OY+?ONE_STEP*math:sin(OriginalAngle))
            end,
            %% if
            %%    abs(DX)+abs(DY) > 2*?ONE_STEP ->
            %%        Angle  = OriginalAngle,
            %%        MovePx = ?ONE_STEP;
            %%   true ->
            %%        Angle = OriginalAngle + (math:pi()/40 * urand:rand(1,9)) * urand:rand(-1,1),
            %%        MovePx = ?ONE_STEP %(px)
            %% end,
            %% if
            %%    Angle /= 0 ->
            %%        X0 = round(OX+MovePx*math:cos(Angle)),
            %%        Y0 = round(OY+MovePx*math:sin(Angle));
            %%    OY == TY andalso OX /= TX  -> %% Y轴相等
            %%        X0 = round(OX + min(?ONE_STEP_X,MovePx) * (DX div abs(DX))),
            %%        Y0 = OY;
            %%    OX == TX andalso OY /= TY ->  %% X轴相等
            %%        Y0 = round(OY + min(?ONE_STEP_Y,MovePx) * (DY div abs(DY))),
            %%        X0 = OX;
            %%    true -> %% 其他情况
            %%        X0 = OX + min(?ONE_STEP_X,MovePx),
            %%        Y0 = OY
            %% end,
            %% ?PRINT("x0, Y0 ~p~n", [{X0, Y0}]),
            {max(0, X0), max(0, Y0)}
    end.

%% 直线坐标数组
dest_path(_, _, _, _, 0) -> [];
dest_path(OldX, OldY, OldX, OldY, _Speed) -> [];
dest_path(OldX, OldY, DestX, DestY, _Speed) ->
    %% 逻辑坐标距离
    DisX = max(1, util:ceil(abs(DestX - OldX)/?LENGTH_UNIT)),
    DisY = max(1, util:ceil(abs(DestY - OldY)/?WIDTH_UNIT)),
    dest_path_core(OldX, OldY, DestX, DestY, DisX, DisY).

%% 直线坐标数组
dest_path_speed(_OldX, _OldY, _DestX, _DestY, _GapMs, 0) -> [];
dest_path_speed(OldX, OldY, OldX, OldY, _GapMs, _Speed) -> [];
dest_path_speed(OldX, OldY, DestX, DestY, GapMs, Speed) ->
    %% 逻辑坐标距离
    Dis = (Speed * GapMs) div 1000,
    DisX = max(1, util:ceil(abs(DestX - OldX)/Dis)),
    DisY = max(1, util:ceil(abs(DestY - OldY)/Dis)),
    dest_path_core(OldX, OldY, DestX, DestY, DisX, DisY).

dest_path_core(OldX, OldY, DestX, DestY, DisX, DisY) ->
    %% 斜率A
    A = case DestX - OldX == 0 of
            true -> 0;
            false -> (DestY - OldY) / (DestX - OldX)
        end,
    %% 常量B
    B = DestY - A * DestX,
    %% 细化坐标
    if
        DisX > DisY ->
            F = fun(I, Result) ->
                X = case OldX < DestX of
                        true  -> OldX + I*?LENGTH_UNIT;
                        false -> OldX - I*?LENGTH_UNIT
                    end,
                Y = trunc(A*X + B),
                {ok, [{X, Y}|Result]}
                end,
            {ok, Path} = util:for(1, DisX, F, []),
            lists:reverse([{DestX, DestY}|Path]);
        true ->
            F = fun(I, Result) ->
                Y = case OldY < DestY of
                        true  -> OldY + I*?WIDTH_UNIT;
                        false -> OldY - I*?WIDTH_UNIT
                    end,
                X = case A == 0 of
                        true -> OldX;
                        false -> trunc((Y - B)/A)
                    end,

                {ok, [{X, Y}|Result]}
                end,
            {ok, Path} = util:for(1, DisY, F, []),
            lists:reverse([{DestX, DestY}|Path])
    end.

mon_speak(Minfo, Args) ->
    [LanId|_] = Args,
    #scene_object{id = Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y} = Minfo,
    Msg = utext:get(LanId),
    {ok, BinData} = pt_120:write(12023,[Id, Msg]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData).

%% 怪物狂暴
mon_frenzy(Minfo, EndTime) ->
    #scene_object{id = Id, sign = Sign, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y} = Minfo,
    lib_scene_object:update(Minfo, [{frenzy_enter_time, EndTime}]),
    {ok, BinData} = pt_120:write(12091, [Sign, Id, EndTime]),
    lib_server_send:send_to_area_scene(Scene, ScenePoolId, CopyId, X, Y, BinData),
    ok.

%% 选择一个技能
select_a_skill(SkillL, SkillCd, PubSkillCdCfg, PubSkillCd, LastSkillId, StrikingDistance, SkillLinkInfo, AttType) ->
    % ?PRINT("LastSkillId:~p SkillL:~p SkillCd:~p ~n", [LastSkillId, SkillL, SkillCd]),
    Now = utime:longunixtime(),
    case SkillL of
        %% 远程
        [] when AttType == 1 ->
            format_a_skill(1110000001, 1, StrikingDistance, SkillLinkInfo);
        %% 近程
        [] -> 
            format_a_skill(1110000001, 1, StrikingDistance, SkillLinkInfo);
        _  ->
            case filter_skills_cd(SkillCd, SkillL, Now, PubSkillCdCfg, PubSkillCd, 0) of
                {[], NextSelectTime} -> {false, NextSelectTime};
                {NSkillL, _} ->
                    % ?PRINT("NSkillL:~p ~n", [NSkillL]),
                    {SkillId, SkillLv, NSkillLinkInfo} = rand_a_skill(NSkillL, LastSkillId, SkillLinkInfo),
                    format_a_skill(SkillId, SkillLv, StrikingDistance, NSkillLinkInfo)
            end
    end.

role_select_a_skill([], _, _, _, _, _, _) -> false;
role_select_a_skill(SkillL, SkillCd, PubSkillCdCfg, PubSkillCd, LastSkillId, StrikingDistance, SkillLinkInfo) ->
    Now = utime:longunixtime(),
    case filter_skills_cd(SkillCd, SkillL, Now, PubSkillCdCfg, PubSkillCd, 0) of
        {[], NextSelectTime} -> {false, NextSelectTime};
        {NSkillL, _} ->
            {RealSkL, NormalSkList} = split_normal_skill(NSkillL),
            {SkId, SkLv} = select_len_cd_skill(RealSkL),
            % 随机出普通技能
            {UseSkillId, UseSkillLv, NSkillLinkInfo} =
                case SkId of
                    0 ->
                        NewNormalSkList = lists:reverse(NormalSkList),
                        {NormalSkId, NormalSkLv, NormalSkLink} = select_normal_skill(LastSkillId, NewNormalSkList),
                        {SkillId, SkillLinkInfo1} = skill_link_change_skill(NormalSkLink, NormalSkId, SkillLinkInfo),
                        {SkillId, NormalSkLv, SkillLinkInfo1};
                    _  ->
                        {SkId, SkLv, SkillLinkInfo}
                end,
            format_a_skill(UseSkillId, UseSkillLv, StrikingDistance, NSkillLinkInfo)
    end.

%% 移除正在cd的技能
filter_skills_cd([], SkillList, _Now, _PubSkillCdCfg, _PubSkillCd, NextSelectTime) -> {SkillList, NextSelectTime};
filter_skills_cd([{SkillId, EndTime}|T], SkillList, Now, PubSkillCdCfg, PubSkillCd, NextSelectTime) ->
    case lists:keyfind(SkillId, 1, PubSkillCdCfg) of
        {SkillId, CdNo, _NeedCd} ->
            case lists:keyfind(CdNo, 1, PubSkillCd) of
                {CdNo, PubEndTime} -> ok;
                _ -> PubEndTime = 0
            end;
        _ ->
            PubEndTime = 0
    end,
    if
        % 直接释放
        EndTime =< Now andalso PubEndTime =< Now ->
            filter_skills_cd(T, SkillList, Now, PubSkillCdCfg, PubSkillCd, NextSelectTime);
        % 还在cd中
        EndTime > Now -> 
            GapTime = ?IF(EndTime - Now < NextSelectTime orelse NextSelectTime == 0, EndTime - Now, NextSelectTime),
            filter_skills_cd(T, lists:keydelete(SkillId, 1, SkillList), Now, PubSkillCdCfg, PubSkillCd, GapTime);
        % cd结束,但在公共cd内
        true ->
            GapTime = ?IF(PubEndTime - Now < NextSelectTime orelse NextSelectTime == 0, PubEndTime - Now, NextSelectTime),
            filter_skills_cd(T, lists:keydelete(SkillId, 1, SkillList), Now, PubSkillCdCfg, PubSkillCd, GapTime)
    end.

%% %% 随机一个技能释放:考虑优先使用近战技能
rand_a_skill([], _LastSkillId, _SkillLinkInfo) -> {false, 5000};
rand_a_skill(SkillL, LastSkillId, SkillLinkInfo) ->
    % F = fun({SkillId, SkillLv}, {TmpDis, Sk, NormalSkList}) ->
    %     case data_skill:get(SkillId, SkillLv) of
    %         #skill{type = ?SKILL_TYPE_PASSIVE} -> {TmpDis, Sk, NormalSkList};
    %         #skill{is_normal = 0, range = 1, lv_data = #skill_lv{distance = Dis, area = Area}}
    %                 when Dis+0.8*Area > TmpDis -> %% 圆形技能
    %             {trunc(Dis+0.8*Area), {SkillId, SkillLv}, NormalSkList };
    %         #skill{is_normal = 0, lv_data = #skill_lv{distance = Dis}} when Dis > TmpDis -> %% 技能
    %             {Dis, {SkillId, SkillLv}, NormalSkList };
    %         #skill{is_normal = 1, skill_link = SkillLink} -> %% 普攻，不会被覆盖
    %             {TmpDis, Sk, [{SkillId, SkillLv, SkillLink}|NormalSkList] };
    %         _ ->
    %             {TmpDis, Sk, NormalSkList}
    %     end
    % end,
    % 按顺序释放
    {SkL, NormalSkList} = split_normal_skill(SkillL),
    {SkId, SkLv} = select_other_skill(LastSkillId, lists:reverse(SkL)),
    % 随机出普通技能
    case SkId of
        0 ->
            NewNormalSkList = lists:reverse(NormalSkList),
            {NormalSkId, NormalSkLv, NormalSkLink} = select_normal_skill(LastSkillId, NewNormalSkList),
            {SkillId, SkillLinkInfo1} = skill_link_change_skill(NormalSkLink, NormalSkId, SkillLinkInfo),
            {SkillId, NormalSkLv, SkillLinkInfo1};
        _  ->
            {SkId, SkLv, SkillLinkInfo}
    end.

%% 分理出普攻与技能
split_normal_skill(SkillL) ->
    F = fun({SkillId, SkillLv}, {TmpDis, SkL, NormalSkList}) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{type = ?SKILL_TYPE_PASSIVE} -> {TmpDis, SkL, NormalSkList};
            #skill{is_normal = 0, is_combo = 1} -> %% 副技能
                {TmpDis, SkL, NormalSkList};
            #skill{is_normal = 0, lv_data = #skill_lv{distance = Dis}} -> %% 技能
                {Dis, [{SkillId, SkillLv}|SkL], NormalSkList };
            #skill{is_normal = 1, skill_link = SkillLink} -> %% 普攻，不会被覆盖
                {TmpDis, SkL, [{SkillId, SkillLv, SkillLink}|NormalSkList] };
            _ ->
                {TmpDis, SkL, NormalSkList}
        end
    end,
    {_, SkL, NormalSkList} = lists:foldl(F, {-1, [], []}, SkillL),
    {SkL, NormalSkList}.

select_other_skill(_LastSkillId, []) -> {0, 0};
select_other_skill(0, [T|_NormalSkList]) -> T;
select_other_skill(LastSkillId, NormalSkList) ->
    % ?PRINT("NormalSkList:~p ~n", [NormalSkList]),
    case lists:keymember(LastSkillId, 1, NormalSkList) of
        true -> do_select_other_skill(LastSkillId, NormalSkList, NormalSkList);
        false -> 
            case urand:list_rand(NormalSkList) of
                null -> {0, 0};
                Result -> Result
            end
    end.

do_select_other_skill(LastSkillId, NormalSkList, [{LastSkillId, _NormalSkLv}|LeftNormalSkList]) ->
    case LeftNormalSkList == [] of
        true -> hd(NormalSkList);
        false -> hd(LeftNormalSkList)
    end;
do_select_other_skill(LastSkillId, NormalSkList, [_T|LeftNormalSkList]) ->
    do_select_other_skill(LastSkillId, NormalSkList, LeftNormalSkList).

% 选择技能cd长的技能
select_len_cd_skill([]) -> {0, 0};
select_len_cd_skill(SkillList) ->
    F_sort = fun({SkId1, SkLv1}, {SkId2, SkLv2}) ->
        case data_skill:get(SkId1, SkLv1) of
            #skill{lv_data = #skill_lv{cd = Cd1}} -> ok;
            _ -> Cd1 = 0
        end,
        case data_skill:get(SkId2, SkLv2) of
            #skill{lv_data = #skill_lv{cd = Cd2}} -> ok;
            _ -> Cd2 = 0
        end,
        Cd1 > Cd2
    end,
    hd(lists:sort(F_sort, SkillList)).

select_normal_skill(_LastSkillId, []) -> {0, 0, []};
select_normal_skill(0, [T|_NormalSkList]) -> T;
select_normal_skill(LastSkillId, NormalSkList) ->
    % ?PRINT("NormalSkList:~p ~n", [NormalSkList]),
    case lists:keymember(LastSkillId, 1, NormalSkList) of
        true -> do_select_normal_skill(LastSkillId, NormalSkList, NormalSkList);
        false -> 
            case urand:list_rand(NormalSkList) of
                null -> {0, 0, []};
                Result -> Result
            end
    end.

do_select_normal_skill(LastSkillId, NormalSkList, [{LastSkillId, _NormalSkLv, _NormalSkLink}|LeftNormalSkList]) ->
    case LeftNormalSkList == [] of
        true -> hd(NormalSkList);
        false -> hd(LeftNormalSkList)
    end;
do_select_normal_skill(LastSkillId, NormalSkList, [_T|LeftNormalSkList]) ->
    do_select_normal_skill(LastSkillId, NormalSkList, LeftNormalSkList).

%% 获取技能数据
format_a_skill(SkillId, SkillLv, StrikingDistance, SkillLinkInfo) ->
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = Type, range = Range, refind_target = ReFindT, is_normal = IsNormal,
               time = SpellTime, lv_data = #skill_lv{distance = Dis, area = Area}} ->
            LastStrikingDis = case Dis of
                _ when Range==?SKILL_RANGE_CIRCLE -> trunc(Dis+0.8*Area);
                0 -> max(150, StrikingDistance);
                _ -> Dis
            end,
            {SkillId, SkillLv, LastStrikingDis, Type, ReFindT, SpellTime, SkillLinkInfo, IsNormal};
        _ ->
            {false, 5000}
    end.

% skill_link_change_skill([], SkillId, _) -> {SkillId, []};
skill_link_change_skill([_|T], SkillId, SkillLinkInfo) ->
    case SkillLinkInfo of
        [] -> {SkillId, T};
        [H1|T1] -> {H1, T1}
    end;
skill_link_change_skill(_, SkillId, _) -> {SkillId, []}.

is_combo(_, []) -> false;
is_combo(MainSkillId, SkillCombo) ->
    case lists:keyfind(MainSkillId, #skill_combo.main_skill_id, SkillCombo) of
        #skill_combo{main_skill_lv=MainSkillLv, bullet_dis=BulletDis, next_time=NextTime, combo_list=[{NextSkillId, _, _}|_]} ->
            {NextSkillId, MainSkillLv, NextTime, BulletDis};
        _ -> false
    end.

%% BattleArgs: {target, AtterType, Id} | {xy, X, Y}...
%% return: {State, Args}
%% State: trace|back|error 对象进程要处理这3个返回状态
trace_to_att(_SceneObject, _TX, _TY, _BattleArgs, Ref, _NextAttTime, NextMoveTime, NowTime, _SkillLinkInfo, _CheckBlock, _ReleaseSkill)
        when NextMoveTime > NowTime -> %% 下一次行动
    Ref1 = lib_scene_object:send_event_after(Ref, NextMoveTime-NowTime, repeat),
    {trace, [{ref, Ref1}]};

trace_to_att(SceneObject, TX, TY, BattleArgs, Ref, NextAttTime, _NextMoveTime, NowTime, SkillLinkInfo, CheckBlock, ReleaseSkill) ->
    #scene_object{
        sign = ObjectSign, id = ObjectId, aid = Aid,
        scene = SceneId, scene_pool_id = ScenePoolId, x = X, y = Y, copy_id = CopyId,
        battle_attr = BA, att_time = GapAttTime, 
        skill = SkillL, temp_skill = TempSkillL, skill_cd = SkillCd, pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd, 
        last_skill_id = LastSkillId, striking_distance = StrikingDistance, att_type = AttType, shaking_skill = _ShakingSkill
        } = SceneObject,
    IsOnReleaseSkill = is_on_release_skill(ReleaseSkill, NowTime),
    case select_a_skill(TempSkillL++SkillL, SkillCd, PubSkillCdCfg, PubSkillCd, LastSkillId, StrikingDistance, SkillLinkInfo, AttType) of
        _ when IsOnReleaseSkill ->
            case ReleaseSkill of
                #release_skill{end_time = EndTime} -> Ref1 = lib_scene_object:send_event_after(Ref, max(EndTime-NowTime+100, 100), repeat);
                _ -> Ref1 = lib_scene_object:send_event_after(Ref, 5000, repeat)
            end,
            {trace, [{ref, Ref1}] };
        {false, NextSelectTime} -> 
            Ref1 = lib_scene_object:send_event_after(Ref, NextSelectTime+50, repeat),
            {trace, [{ref, Ref1}] };

        %% 辅助技能
        {SkillId, SkillLv, _, ?SKILL_TYPE_ASSIST, IsReFindT, SpellTime, _, _} ->
            SelectedSkillInfo 
            = #selected_skill{
                att_time = NowTime+GapAttTime, 
                skill_id = SkillId, 
                spell_time = SpellTime, 
                is_refind_t = IsReFindT
            },
            ReleaseSkillInfo = #release_skill{skill_id = SkillId, spell_time = SpellTime, end_time = NowTime+SpellTime},
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_assist_cast, [Aid, ObjectId, SkillId, SkillLv]),
            Ref1 = lib_scene_object:send_event_after(Ref, 5000, repeat),
            {back, [{ref, Ref1}, {selected_skill, {SkillId, SelectedSkillInfo}}, {release_skill, ReleaseSkillInfo}]};
        %% 主动技能
        {SkillId, SkillLv, SkillDistance, ?SKILL_TYPE_ACTIVE, IsReFindT, SpellTime, SkillLinkInfo1, IsNormal} ->
            %% 判断是否可以攻击   
            case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, CheckBlock) of
                attack when NowTime > NextAttTime ->
                    case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                        {false, _K, AttWaitMs} ->
                            Ref1 = lib_scene_object:send_event_after(Ref, AttWaitMs, repeat),
                            {trace, [{ref, Ref1}]};
                        true ->
                            SelectedSkillInfo 
                            = #selected_skill{
                                att_time = NowTime+GapAttTime, 
                                skill_id = SkillId, 
                                spell_time = SpellTime, 
                                is_refind_t = IsReFindT, 
                                link_info = SkillLinkInfo1, 
                                normal = IsNormal
                            },
                            ReleaseSkillInfo = #release_skill{skill_id = SkillId, spell_time = SpellTime, end_time = NowTime+SpellTime},
                            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_battle_cast, [Aid, ObjectSign, ObjectId, BattleArgs, SkillId, SkillLv, 0]),
                            Ref1 = lib_scene_object:send_event_after(Ref, 5000, repeat),
                            {back, [{ref, Ref1}, {selected_skill, {SkillId, SelectedSkillInfo}}, {release_skill, ReleaseSkillInfo}]}
                    end;

                %% 没有到出手时间
                attack ->
                    case data_scene:get(SceneId) of
                                #ets_scene{type = ?SCENE_TYPE_JJC} -> 
                                    ?MYLOG(lists:concat(["hjhjjc", ObjectId]), "==== NextAttTime-NowTime:~p ~n", [NextAttTime-NowTime]);
                                _ -> skip
                            end,
                    Ref1 = lib_scene_object:send_event_after(Ref, max(200, NextAttTime-NowTime), repeat),
                    {trace, [{ref, Ref1}]};
                
                %% 移动
                {NextX, NextY} ->
                    #battle_attr{speed = Speed, attr = _Attr} = BA,
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        {false, MoveWaitMs} ->
                            Ref1 = lib_scene_object:send_event_after(Ref, MoveWaitMs, repeat),
                            {trace, [{ref, Ref1}]};
                        false -> %% 本身速度为0：一般为策划填错配置，本身可反击或主动，但是移动速度为0
                            {error, [{att, undefined}] };
                        true ->
                            case lib_scene_object_ai:move(NextX, NextY, SceneObject, Speed, CheckBlock) of
                                block ->
                                    Ref1 = lib_scene_object:send_event_after(Ref, 500, repeat),
                                    {back, [{ref, Ref1}, {att, undefined}]};
                                {true, NewObj, Time} ->
                                    Ref1 = lib_scene_object:send_event_after(Ref, Time, repeat),
                                    {trace, [{obj, NewObj}, {ref, Ref1}, {move_begin_time, NowTime}, {each_move_time, Time}, {o_point, {X, Y}}, {back_dest_path, null}]}
                            end
                    end
            end;
        _R ->
            %% ?PRINT("sign:~w, id=~w, [SceneObject#scene_object.sign, ObjectId, SkillId, SkillLv, SkillType]:~w~n",
            %% [SceneObject#scene_object.sign, ObjectId, _R]),
            {back, []}
    end.

combo({_OX, _OY, _X, _Y, SkillId, SkillLv, IsReFindT, _BulletDis, _OldRadian} = ComboArgs, State) ->
    #ob_act{att=Att, object=Object, selected_skill = SelectedSkillMap} = State,
    #scene_object{sign=Sign, id=Id, scene=SceneId, scene_pool_id=ScenePoolId, x=SelfX, y=SelfY, aid = Aid} = Object,
    case lib_battle:combo_active_battle_set_args_radian(Att, SelfX, SelfY, ComboArgs) of
        {_SkillR, Args, Radian} ->
            SelectedSkillInfo = #selected_skill{skill_id = SkillId, is_refind_t = IsReFindT},
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, combo_battle_cast, [Aid, Sign, Id, Args, SkillId, SkillLv, Radian]),
            State#ob_act{selected_skill = SelectedSkillMap#{SkillId => SelectedSkillInfo}};
        {_SkillR, combo} ->
            SelectedSkillInfo = #selected_skill{skill_id = SkillId, is_refind_t = IsReFindT},
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, combo_assist_cast, [Aid, Id, SkillId, SkillLv]),
            State#ob_act{selected_skill = SelectedSkillMap#{SkillId => SelectedSkillInfo}};
        _ -> State
    end.

set_ac_state([H|T], ObAct) ->
    NewObAct = case H of
        {obj, Value} -> ObAct#ob_act{object = Value};
        {ref, Value} -> ObAct#ob_act{ref = Value};
        {att, Value} -> ObAct#ob_act{att = Value};
        {att_time, Value} -> ObAct#ob_act{next_att_time = Value};
        {move_time, Value} -> ObAct#ob_act{next_move_time = Value};
        {skill_link_info, Value} -> ObAct#ob_act{skill_link_info = Value};
        {each_move_time, Value} -> ObAct#ob_act{each_move_time = Value};
        {o_point, Value} -> ObAct#ob_act{o_point = Value};
        {move_begin_time, Value} -> ObAct#ob_act{move_begin_time = Value};
        {selected_skill, {K, V}} -> 
            SelectedSkillMap = ObAct#ob_act.selected_skill,
            ObAct#ob_act{selected_skill = SelectedSkillMap#{K => V}};
        {release_skill, Value} ->
            ObAct#ob_act{release_skill = Value};
        {back_dest_path, Value} ->
            ObAct#ob_act{back_dest_path = Value};
        _ -> ObAct
    end,
    set_ac_state(T, NewObAct);
set_ac_state([], NewObAct) -> NewObAct.

%% 获取skill_owern关键参数
get_skill_owner_args(#skill_owner{id=Id, sign=Sign}) -> {Sign, Id};
get_skill_owner_args(_) -> {0, 0}.

%% 获取公会id
get_guild_id(#scene_object{skill_owner = SkillOwner, figure = #figure{guild_id = SceneGuildId}}) -> 
    case SkillOwner of 
        #skill_owner{guild_id = GuildId} -> GuildId; 
        _ -> SceneGuildId 
    end;
get_guild_id(#ets_scene_user{figure = #figure{guild_id = GuildId}}) -> GuildId;
get_guild_id(#battle_status{skill_owner = SkillOwner, figure = #figure{guild_id = SceneGuildId}}) -> 
    case SkillOwner of 
        #skill_owner{guild_id = GuildId} -> GuildId; 
        _ -> SceneGuildId 
    end;
get_guild_id(_) -> 0.

%% 获取pk状态
get_pk_status(#scene_object{battle_attr = #battle_attr{pk = #pk{pk_status = PkStatus}}}) -> PkStatus;
get_pk_status(#ets_scene_user{battle_attr = #battle_attr{pk = #pk{pk_status = PkStatus}}}) -> PkStatus;
get_pk_status(#battle_status{battle_attr = #battle_attr{pk = #pk{pk_status = PkStatus}}}) -> PkStatus;
get_pk_status(#player_status{battle_attr = #battle_attr{pk = #pk{pk_status = PkStatus}}}) -> PkStatus;
get_pk_status(_) -> false.

handle_assist_res(State, SelectedSkillInfo, SceneObject, Ref, Res) ->
    #ob_act{release_skill = ReleaseSkill} = State,
    #scene_object{aid = Aid, x = X, y = Y, temp_skill = TempSkillL} = SceneObject,
    #selected_skill{
        att_time = AttTime, 
        skill_id = SkillId, 
        spell_time = SpellTime, 
        is_refind_t = IsReFindT
    } = SelectedSkillInfo,
    case Res of
        #skill_return{
            aer_info = BackData, 
            % rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
            used_skill = SkillId,
            main_skill = MainSkillId
        } ->
            BackObj = lib_battle_api:update_by_slim_back_data(SceneObject, BackData),
            case is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} -> %% combo技能施放
                    ComboArgs = {X, Y, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            TempSkillL1 = lists:keydelete(SkillId, 1, TempSkillL),
            Ref1 = lib_scene_object:send_event_after(Ref, max(200, SpellTime+100), repeat),
            % 成功释放
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, ReleaseSkill#release_skill{is_ok = 1}}];
                _ -> ReleaseSkillL = []
            end,
            {trace, [{ref, Ref1}, {obj, BackObj#scene_object{temp_skill=TempSkillL1} }, {att_time, AttTime}, {selected_skill, {SkillId, []}}]++ReleaseSkillL };
        
        {false, _Err} ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            % 失败释放就去掉
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            {trace, [{ref, Ref1}, {selected_skill, {SkillId, []}}]++ReleaseSkillL};
        _O ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            {back, [{ref, Ref1}, {att, undefined}, {selected_skill, {SkillId, []}}]++ReleaseSkillL}
    end.

handle_battle_res(State, SelectedSkillInfo, SceneObject, Ref, Res) ->
    #ob_act{release_skill = ReleaseSkill} = State,
    #selected_skill{
        att_time = AttTime, 
        skill_id = SkillId, 
        spell_time = SpellTime, 
        is_refind_t = IsReFindT, 
        link_info = SkillLinkInfo1, 
        normal = IsNormal
    } = SelectedSkillInfo,
    #scene_object{aid = Aid, temp_skill = TempSkillL} = SceneObject,
    case Res of
        #skill_return{
            aer_info = BackData, 
            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
            used_skill = SkillId,
            main_skill = MainSkillId
        } ->
            BackObj = lib_battle_api:update_by_slim_back_data(SceneObject, BackData),
            case lib_scene_object_ai:is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            %% 技能施放时间
            SpellTime1 = ?IF(IsNormal == 1, max(200, SpellTime+100), SpellTime),                                            
            TempSkillL1 = lists:keydelete(SkillId, 1, TempSkillL),
            Ref1 = lib_scene_object:send_event_after(Ref, SpellTime1, repeat),
            % 成功释放
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, ReleaseSkill#release_skill{is_ok = 1}}];
                _ -> ReleaseSkillL = []
            end,
            {trace, [{ref, Ref1}, {obj, BackObj#scene_object{temp_skill=TempSkillL1}}, 
                {skill_link_info, SkillLinkInfo1}, {att_time, AttTime}, {selected_skill, {SkillId, []}}]++ReleaseSkillL };
        {false, _ErrCode} ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            % 失败释放就去掉
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            {trace, [{ref, Ref1}, {att_time, AttTime}, {selected_skill, {SkillId, []}}]++ReleaseSkillL };

        _O ->
            Ref1 = lib_scene_object:send_event_after(Ref, 1000, repeat),
            case ReleaseSkill of
                #release_skill{is_ok = 0, skill_id = SkillId} -> ReleaseSkillL = [{release_skill, undefined}];
                _ -> ReleaseSkillL = []
            end,
            {back, [{ref, Ref1}, {att, undefined}, {selected_skill, {SkillId, []}}]++ReleaseSkillL }
    end.

battle_combo_res(SelectedSkillInfo, State, Res) ->
    #ob_act{object = Object} = State,
    #scene_object{aid = Aid} = Object,
    #selected_skill{is_refind_t = IsReFindT} = SelectedSkillInfo,
    case Res of
        #skill_return{
            aer_info = BackData, 
            rx = OX1, ry = OY1, tx = AttX, ty = AttY, radian = Radian,
            main_skill = MainSkillId
        } ->
        % {true, BackData, OX1, OY1, AttX, AttY, MainSkillId, Radian} ->
            BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
            case lib_scene_object_ai:is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, NewBulletDis} ->
                    ComboArgs = {OX1, OY1, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, NewBulletDis, Radian},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            State#ob_act{object=BackObj};
        {false, _ErrCode} -> State;
        _O -> State
    end.

assist_combo_res(SelectedSkillInfo, State, Res) ->
    #ob_act{object = Object} = State,
    #scene_object{aid=Aid, x=X, y=Y} = Object,
    #selected_skill{is_refind_t = IsReFindT} = SelectedSkillInfo,
    case Res of
        #skill_return{
            aer_info = BackData, 
            % rx = RX, ry = RY, tx = TX, ty = TY, radian = Radian,
            % used_skill = SkillId,
            main_skill = MainSkillId
        } ->
            BackObj = lib_battle_api:update_by_slim_back_data(Object, BackData),
            case lib_scene_object_ai:is_combo(MainSkillId, BackObj#scene_object.skill_combo) of
                false -> skip;
                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                    ComboArgs = {X, Y, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                    erlang:send_after(NextSkillTime, Aid, {'combo', ComboArgs})
            end,
            State#ob_act{object=BackObj};
        {false, _Err} ->  State;
        _ -> State
    end.

%% 直接释放一个技能
object_ac_skill(State, SkillId, SkillLv) ->
    #ob_act{skill_link_info = SkillLinkInfo, selected_skill = SelectedSkillMap, object = Object} = State,
    #scene_object{sign = ObjectSign, id = ObjectId, aid = Aid, att_time = GapAttTime, 
        scene = SceneId, scene_pool_id = ScenePoolId, last_skill_id = LastSkillId} = Object,
    NowTime = utime:longunixtime(),
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = ?SKILL_TYPE_ASSIST, refind_target = IsReFindT, time = SpellTime} ->
            SelectedSkillInfo 
            = #selected_skill{
                att_time = NowTime+GapAttTime, 
                skill_id = SkillId, 
                spell_time = SpellTime, 
                is_refind_t = IsReFindT
            },
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_assist_cast, [Aid, ObjectId, SkillId, SkillLv]),
            State#ob_act{selected_skill = SelectedSkillMap#{SkillId => SelectedSkillInfo}};
        #skill{type = ?SKILL_TYPE_ACTIVE, refind_target = IsReFindT, time = SpellTime, is_normal = IsNormal} ->
            {SkillId1, SkillLv1, SkillLinkInfo1} = rand_a_skill([{SkillId, SkillLv}], LastSkillId, SkillLinkInfo),
            SelectedSkillInfo 
            = #selected_skill{
                att_time = NowTime+GapAttTime, 
                skill_id = SkillId1, 
                spell_time = SpellTime, 
                is_refind_t = IsReFindT, 
                link_info = SkillLinkInfo1, 
                normal = IsNormal
            },
            % ?MYLOG(Object#scene_object.config_id==3600004, "hjhaibattle1", "battle SkillLv:~p SkillLv:~p ~n", 
            %     [SkillId, SkillLv]),
            mod_scene_agent:apply_cast_with_state(SceneId, ScenePoolId, lib_battle, object_battle_cast, [Aid, ObjectSign, ObjectId, find_target, SkillId1, SkillLv1, 0]),
            State#ob_act{selected_skill = SelectedSkillMap#{SkillId => SelectedSkillInfo}};
        _ ->
            State
    end.

%% 是否处于释放技能中
is_on_release_skill(ReleaseSkill, NowTime) ->
    case ReleaseSkill of
        #release_skill{end_time = EndTime} when NowTime < EndTime -> true;
        _ -> false
    end.