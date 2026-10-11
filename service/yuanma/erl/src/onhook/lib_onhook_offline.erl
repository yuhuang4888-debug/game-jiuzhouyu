%% ---------------------------------------------------------------------------
%% @doc lib_onhook_offline
%% @author ming_up@foxmail.com
%% @since  2017-05-16
%% @deprecated  玩家离线挂机, 在mod_scene_agent中执行
%% ---------------------------------------------------------------------------
-module(lib_onhook_offline).

-include("common.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("skill.hrl").
-include("server.hrl").
-include("team.hrl").
-include("rec_onhook.hrl").
-include("def_fun.hrl").
-include("battle.hrl").

-export([
        go_to_onhook_place/2,
        select_a_onhook_place/2,
        get_onhook_exp/2,
        combo/3,
        interrupt/1
    ]).

-export([
        login_for_onhook_fix_ref/1
        , make_onhook_fix_ref/3
        , onhook_fix_ref/5
    ]).

%% 默认攻击频率
-define(DEF_ATT_TIME, 7000).
%% 死亡等待时间
-define(DEF_DIE_TIME, 10000).

%% 挑选一个挂机地点
%% 监狱特殊处理
select_a_onhook_place(PsOrUser, Scene) when
    is_record(PsOrUser, player_status) orelse is_record(PsOrUser, ets_scene_user)->
    case PsOrUser of
        #player_status{figure = Figure, battle_attr = BA} -> skip;
        #ets_scene_user{figure = Figure, battle_attr = BA} -> skip
    end,
    #figure{lv = Lv} = Figure,
    #battle_attr{combat_power = Power} = BA,
    case data_onhook:get_lv_extent(Lv) of
        [] -> false;
        List ->
            % case lib_jail:is_in_jail(Scene) of
            %     true -> lib_jail:onhook_place();
            %     false ->
            %         case get_recommend_onhook_place(List, Power, Lv, {0, 0}) of
            %             false -> false;
            %             {TScene, TId} ->
            %                 #base_onhook{xy = XyList} =  data_onhook:get(TScene, TId),
            %                 [{TX, TY}|_] = ulists:list_shuffle(XyList),
            %                 ?IF(TScene == Scene, {TId, TX, TY}, {TScene, TId, TX, TY})
            %         end
            % end
            case get_recommend_onhook_place(List, Power, Lv, {0, 0}) of
                false -> false;
                {TScene, TId} ->
                    #base_onhook{xy = XyList} =  data_onhook:get(TScene, TId),
                    [{TX, TY}|_] = ulists:list_shuffle(XyList),
                    ?IF(TScene == Scene, {TId, TX, TY}, {TScene, TId, TX, TY})
            end
    end;
select_a_onhook_place(_User, _Scene) -> false.

%% 找到推荐挂机点
get_recommend_onhook_place([], _CombatPower, _Lv, H)->
    ?IF(H == {0, 0}, false, H);
get_recommend_onhook_place([{SceneId, Id}=H|T], CombatPower, Lv, LastH)->
    case data_onhook:get(SceneId, Id) of
        #base_onhook{power = Power, onhook_type = OnhookType,
                     min_lv = MinLv, max_lv = MaxLv} when OnhookType == 0 ->
            if
                MinLv =< Lv andalso Lv < MaxLv -> %% 找到玩家最合适的区间
                    if
                        CombatPower =< Power -> ?IF(LastH == {0, 0}, H, LastH);
                        true -> get_recommend_onhook_place(T, CombatPower, Lv, H)
                    end;
                true ->
                    get_recommend_onhook_place(T, CombatPower, Lv, LastH)
            end;
        _-> get_recommend_onhook_place(T, CombatPower, Lv, H)
    end;
get_recommend_onhook_place([_|T], CombatPower, Lv, H) ->
    get_recommend_onhook_place(T, CombatPower, Lv, H).

%% 获取离线挂机经验配置
get_onhook_exp(Lv, Power)->
    case data_onhook:get_lv_extent(Lv) of
        [] -> 0;
        List ->
            case get_recommend_onhook_place(List, Power, Lv, {0, 0}) of
                false -> 0;
                {TScene, TId} ->
                    #base_onhook{onhook_exp = OnhookExp} =  data_onhook:get(TScene, TId),
                    OnhookExp
            end
    end.

%% 走到挂机地点
go_to_onhook_place(
        #ets_scene_user{
            id = Id, figure = _Figure, scene = SceneId, scene_pool_id = ScenePoolId, x = X, y = Y,
            copy_id = CopyId, battle_attr = BA, follow_target_xy = {Xf, Yf},
            onhook_sxy = {_OSid, _OTId, OX, OY}, onhook_path = OnhookPath
            }=User
        , EtsScene) ->
    % ?MYLOG(Id == 4294967314, "hjhonhook", "go_to_onhook_place Id:~p {SceneId, X, Y}:~p, {Xf, Yf}:~p {_OSid, _OTId, OX, OY}:~p ~n", 
    %     [Id, {SceneId, X, Y}, {Xf, Yf}, {_OSid, _OTId, OX, OY}]),
    if
        %% 死亡结束挂机
        BA#battle_attr.hp =< 0 orelse BA#battle_attr.ghost == 1 orelse BA#battle_attr.hide == 1 ->
            % ?IF(Id == 4294967442, ?MYLOG("hjhonhook", "find_target_to_att 11111111111111111  ~n", []), skip),
            erlang:send_after(?DEF_DIE_TIME, self(), {'onhook_wait_for_stop', Id});

        %% 离线挂机点挂机:是直接切场景的，避免走路消耗
        OX /= 0 andalso OY /= 0 ->
            % ?MYLOG("hjhonhook", "find_target_to_att 11111111111111111  ~n", []),
            % case User#ets_scene_user.mount_figure > 0 of
            %     true -> lib_player:update_player_info(Id, [{mount, 0}]);
            %     false -> skip
            % end,
            find_target_to_att(User, EtsScene);

        %% 队伍跟随
        Xf /= 0 andalso Yf /= 0 ->
            % ?IF(Id == 4294967442, ?MYLOG("hjhonhook", "find_target_to_att 11111111111111111  ~n", []), sip),
            case lib_scene_object_ai:get_next_step(X, Y, 180, SceneId, CopyId, Xf, Yf, false) of
                attack ->
                    User1 = User#ets_scene_user{follow_target_xy = {0, 0}, onhook_path = []},
                    find_target_to_att(User1, EtsScene);
                {Xnext, Ynext} ->
                    lib_scene_agent:put_user(User#ets_scene_user{onhook_target=undefined}),
                    #battle_attr{speed=Speed} = User#ets_scene_user.battle_attr,
                    NowTime = utime:longunixtime(),
                    case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                        {false, MoveWaitMs} ->
                            erlang:send_after(MoveWaitMs, self(), {'go_to_onhook_place', Id});
                        false ->
                            erlang:send_after(?DEF_DIE_TIME, self(), {'go_to_onhook_place', Id});
                        true ->
                            mod_scene_agent:cast_to_scene(SceneId, ScenePoolId,  {'move', [CopyId, Xnext, Ynext, 0, X, Y, Xnext, Ynext, 0, 0, Id]}),
                            lib_player:update_player_info(Id, [{xy, {Xnext, Ynext}}]),
                            SleepTime = util:ceil(umath:distance({X,Y},{Xnext,Ynext})*1000/max(Speed, 1)),
                            erlang:send_after(SleepTime+200, self(), {'go_to_onhook_place', Id})
                    end
            end;

        %% 走到估计目的地
        true ->
            % ?IF(Id == 4294967442, ?MYLOG("hjhonhook", "find_target_to_att 11111111111111111  OnhookPath:~p~n", [OnhookPath]), skip),
            case OnhookPath of
                [{Xnext, Ynext}|T] ->
                    lib_scene_agent:put_user(User#ets_scene_user{onhook_path=T}),
                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId,  {'move', [CopyId, Xnext, Ynext, 0, X, Y, Xnext, Ynext, 0, 0, Id]}),
                    lib_player:update_player_info(Id, [{xy, {Xnext, Ynext}}]),
                    SleepTime = util:ceil(umath:distance({X,Y},{Xnext,Ynext})*1000/max(BA#battle_attr.speed, 1)),
                    erlang:send_after(SleepTime, self(), {'go_to_onhook_place', Id});
                [] ->
                    % case User#ets_scene_user.mount_figure > 0 of
                    %     true -> lib_player:update_player_info(Id, [{mount, 0}]);
                    %     false -> skip
                    % end,
                    find_target_to_att(User, EtsScene);
                _  ->
                    erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id})
            end
    end.

% -define(SPELL_TIME_NORMAL, 500).    % 通用加延迟
% -define(SPELL_TIME_LONG, 700).      % 较长延迟

%% @doc 寻找目标攻击
%% return skip | TimerRef
%% @end
find_target_to_att(User, EtsScene) ->
    #ets_scene_user{
        id = Id, battle_attr = BA, onhook_target = OnhookTarget, 
        scene = SceneId, scene_pool_id = ScenePoolId, copy_id = CopyId, x = X, y = Y, skill_list = _SkillL,
        quickbar = SkillL1, skill_cd = SkillCd, skill_link = SkillLink, pub_skill_cd_cfg = PubSkillCdCfg, pub_skill_cd = PubSkillCd, 
        last_skill_id = LastSkillId
        } = User,
    NowTime = utime:longunixtime(),
    % CfgSkillList = data_skill:get_ids(Career, Sex),
    % SkillL1 = [{OneSkillId, OneSkillLv} || {OneSkillId, OneSkillLv} <- SkillL, lists:keymember(OneSkillId, 1, CfgSkillList)],%, not lib_skill_api:is_figure_skill(OneSkillId)],
    % F = fun({OneSkillId, _OneSkillLv}, TmpSkillL) ->
    %     case lists:keyfind(OneSkillId, 1, SkillL) of
    %         false -> TmpSkillL;
    %         {_, OneSkillLv} -> [{OneSkillId, OneSkillLv}|TmpSkillL]
    %     end
    % end,
    % SkillL1 = lists:reverse(lists:foldl(F, [], CfgSkillList)),
    % ?IF(Id == 4294967484, ?MYLOG("hjhonhook", "find_target_to_att NowTime:~p ~n", [NowTime]), skip),
    % ?IF(Id == 4294967312, begin 
    %     % ?MYLOG("hjhonhookbattle", "================ find_target_to_att NowTime:~p  ~n", [NowTime]),
    %     lib_player:gm_trigger_monitor(onhookbattle, 0)
    %     end, 
    %     skip),
    % 使用快捷栏的技能列表
    case lib_scene_object_ai:select_a_skill(SkillL1, SkillCd, PubSkillCdCfg, PubSkillCd, LastSkillId, 0, SkillLink, NowTime) of

        %% 下一次攻击时间
        {false, NextSelectTime} ->
            % ?IF(Id == 4294967312, ?MYLOG("hjhonhookbattle", "find_target_to_att {false, NextSelectTime}:~p  ~n", [NextSelectTime]), skip),
            erlang:send_after(NextSelectTime+1200, self(), {'go_to_onhook_place', Id});

        %% 辅助技能
        {SkillId, SkillLv, _, ?SKILL_TYPE_ASSIST, IsReFindT, SpellTime, _, _} ->
            % ?IF(Id == 4294967312, ?MYLOG("hjhonhookbattle", "find_target_to_att SKILL_TYPE_ASSIST SpellTime:~p ~n", [SpellTime]), skip),
            #skill{is_combo = IsCombo} = data_skill:get(SkillId, SkillLv),
            CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
            %% 默认给自己施放
            case lib_battle:assist_to_anyone(Id, Id, IsCombo, SkillId, SkillLv, CallBackArgs, EtsScene) of
                #skill_return{aer_info = [SkillCombo|_], main_skill = MainSkillId} ->
                    case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                        false ->
                            erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id});
                        {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} -> %% 施放combo技能
                            ComboArgs = {X, Y, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                            erlang:send_after(NextSkillTime, self(), {'combo', Id, ComboArgs})
                    end,
                    erlang:send_after(SpellTime+700, self(), {'go_to_onhook_place', Id});
                _ ->
                    erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id})
            end;

        %% 主动技能
        {SkillId, SkillLv, SkillDistance, ?SKILL_TYPE_ACTIVE, IsReFindT, SpellTime, SkillLinkInfo1, IsNormal} ->
            % ?MYLOG(Id == 4294967297, "hjhonhookbattle", "find_target_to_att SKILL_TYPE_ACTIVE SkillId:~p SkillLv:~p NowTime:~p SpellTime:~p SkillL1:~p~n", 
            %     [SkillId, SkillLv, NowTime, SpellTime, SkillL1]),
            Res = case OnhookTarget of
                      {?BATTLE_SIGN_PLAYER, Id1} ->
                          case lib_scene_agent:get_user(Id1) of
                              #ets_scene_user{x=X1, y=Y1, battle_attr=#battle_attr{hp=Hp}} when Hp > 0 -> {?BATTLE_SIGN_PLAYER, Id1, X1, Y1};
                              _ -> false
                          end;
                      {Sign1, Id1} ->
                          case lib_scene_object_agent:get_object(Id1) of
                              #scene_object{x=X1, y=Y1, battle_attr=#battle_attr{hp=Hp}} when Hp > 0 -> {Sign1, Id1, X1, Y1};
                              _ -> false
                          end;
                      _ ->
                          false
                  end,

            %% 获取攻击目标
            TargetInfo = case Res of
                false ->
                    % Args = {BA#battle_attr.group, ?BATTLE_SIGN_PLAYER, Id, 0, 0},
                    Args = #scene_calc_args{
                        group = BA#battle_attr.group, sign = ?BATTLE_SIGN_PLAYER, id = Id, owner_sign = 0, owner_id = 0, kind = 0,
                        guild_id = lib_scene_object_ai:get_guild_id(User),
                        pk_status = lib_scene_object_ai:get_pk_status(User)},
                    case lib_scene_calc:get_area_for_trace_offline(CopyId, X, Y, Args, EtsScene) of
                        false -> false;
                        {FSign, FId, _, Xf, Yf} -> {FSign, FId, Xf, Yf}
                    end;
                _ ->
                    Res
            end,
            % ?MYLOG("hjhonhook", "find_target_to_att IsNormal:~p OnhookTarget:~p Res:~p TargetInfo:~p ~n", [IsNormal, OnhookTarget, Res, TargetInfo]),
            % ?IF(Id == 4294967442, ?MYLOG("hjhonhookatt", "find_target_to_att LastSkillId:~p, SkillId:~p, SkillLv:~p, IsNormal:~p SpellTime:~p TargetInfo:~p ~n", 
            %     [LastSkillId, SkillId, SkillLv, IsNormal, SpellTime, TargetInfo]), skip),
            case TargetInfo of
                false ->
                    % TODO:查询一下 玩家的 onhook_path 是不是空了,导致玩家原地一直找不到怪物？
                    erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id});

                {TSign, TId, TX, TY} -> %% 将目标锁定
                    User1 = if
                        TSign == ?BATTLE_SIGN_PLAYER -> User; %% 离线挂机不将目标玩家目标锁定
                        true -> User#ets_scene_user{onhook_target={TSign, TId}}
                    end,
                    lib_scene_agent:put_user(User1),
                    % ?IF(Id == 4294967442, ?MYLOG("hjhonhookatt", "find_target_to_att LastSkillId:~p, SkillId:~p, SkillLv:~p, IsNormal:~p SpellTime:~p TargetInfo:~p NextStep:~p ~n", 
                    %     [LastSkillId, SkillId, SkillLv, IsNormal, SpellTime, TargetInfo, lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, false)]), skip),
                    case lib_scene_object_ai:get_next_step(X, Y, SkillDistance, SceneId, CopyId, TX, TY, false) of
                        attack ->
                            case lib_skill_buff:is_can_attack(BA#battle_attr.other_buff_list, IsNormal, NowTime) of
                                {false, _K, AttWaitMs} ->
                                    erlang:send_after(AttWaitMs+700, self(), {'go_to_onhook_place', Id});

                                true ->
                                    %% 发起攻击
                                    case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, Id, {target, TSign, TId}, SkillId, SkillLv, 0, EtsScene) of
                                        #skill_return{
                                            aer_info = [SkillCombo|_],
                                            rx = OX, ry = OY, tx = AttX, ty = AttY, radian = Radian,
                                            main_skill = MainSkillId
                                        } ->
                                            case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                                                false -> skip;
                                                {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                                                    ComboArgs = {OX, OY, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
                                                    erlang:send_after(NextSkillTime+500, self(), {'combo', Id, ComboArgs})
                                            end,
                                            AfSkillUser = lib_scene_agent:get_user(Id),
                                            lib_scene_agent:put_user(AfSkillUser#ets_scene_user{skill_link=SkillLinkInfo1}),
                                            % NSpellTime = ?IF(IsNormal == 1, SpellTime+100, SpellTime+200),
                                            % 大于300可以不加容错时间.防止定时器频繁
                                            case SpellTime >= 300 of
                                                true -> NSpellTime = SpellTime;
                                                false -> NSpellTime = ?IF(IsNormal == 1, SpellTime+100, SpellTime+200)
                                            end,
                                            erlang:send_after(NSpellTime, self(), {'go_to_onhook_place', Id});
                                        _O ->
                                            % ?PRINT("offline player id=~w, use_skill(~w,~w) other_error:~p~n", [Id, SkillId, SkillLv, _O]),
                                            erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id})
                                    end
                            end;
                        {Xnext, Ynext} ->
                            #battle_attr{speed=Speed} = BA,
                            case lib_skill_buff:is_can_move(BA#battle_attr.other_buff_list, Speed, NowTime) of
                                {false, MoveWaitMs} ->
                                    erlang:send_after(MoveWaitMs+500, self(), {'go_to_onhook_place', Id});
                                false ->
                                    erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id});
                                true ->
                                    mod_scene_agent:cast_to_scene(SceneId, ScenePoolId,  {'move', [CopyId, Xnext, Ynext, 0, X, Y, Xnext, Ynext, 0, 0, Id]}),
                                    lib_player:update_player_info(Id, [{xy, {Xnext, Ynext}}]),
                                    SleepTime = util:ceil(umath:distance({X,Y},{Xnext,Ynext})*1000/max(Speed, 1)),
                                    erlang:send_after(SleepTime+500, self(), {'go_to_onhook_place', Id})
                            end
                    end
            end;
        _Other->
            % ?IF(Id == 4294967312, ?MYLOG("hjhonhookbattle", "find_target_to_att _Other:~p ~n", [_Other]), skip),
            erlang:send_after(?DEF_ATT_TIME, self(), {'go_to_onhook_place', Id})
    end.

combo({OX, OY, X, Y, SkillId, SkillLv, IsReFindT, BulletDis, Radian}, User, EtsScene) ->
    #ets_scene_user{id = Id} = User,
    case data_skill:get(SkillId, SkillLv) of
        #skill{type = ?SKILL_TYPE_ACTIVE, is_combo = 1} ->
            Args = if
                       IsReFindT -> find_target;
                       BulletDis > 0 ->
                           %% Radian = math:atan2(Y-OY, X-OX),
                           {xy, round(OX+BulletDis*math:cos(Radian)), round(OY+BulletDis*math:sin(Radian)), X, Y, BulletDis};
                       true -> {xy, OX, OY, X, Y}
                   end,

            case lib_battle:object_start_battle(?BATTLE_SIGN_PLAYER, Id, Args, SkillId, SkillLv, Radian, EtsScene) of
                {false, _ErrCode} -> skip;
                #skill_return{
                    aer_info = [SkillCombo|_],
                    rx = OX1, ry = OY1, tx = AttX, ty = AttY, radian = Radian,
                    main_skill = MainSkillId
                } ->
                    case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                        false -> skip;
                        {NextSkillId, NextSkillLv, NextSkillTime, _} ->
                            ComboArgs = {OX1, OY1, AttX, AttY, NextSkillId, NextSkillLv, IsReFindT, BulletDis, Radian},
                            erlang:send_after(NextSkillTime+500, self(), {'combo', Id, ComboArgs})
                    end,
                    skip;
                _O ->
                    skip
            end;
        #skill{type = ?SKILL_TYPE_ASSIST, is_combo = 1} ->
            CallBackArgs = lib_skill:make_skill_use_call_back(User, SkillId, SkillLv),
            case lib_battle:assist_to_anyone(Id, Id, 1, SkillId, SkillLv, CallBackArgs, EtsScene) of
                #skill_return{aer_info = [SkillCombo|_], main_skill = MainSkillId} ->
                    case lib_scene_object_ai:is_combo(MainSkillId, SkillCombo) of
                        false -> skip;
                        {NextSkillId, NextSkillLv, NextSkillTime, BulletDis} ->
                            ComboArgs = {OX, OY, X, Y, NextSkillId, NextSkillLv, IsReFindT, BulletDis, 0},
                            erlang:send_after(NextSkillTime+500, self(), {'combo', Id, ComboArgs})
                    end,
                    skip;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

%% 中断跟随
interrupt(Status) ->
    #player_status{id=Id, online=Online, team=#status_team{team_id=TeamId}, scene=SceneId, scene_pool_id=ScenePoolId} = Status,
    case Online of
        0 ->
            case TeamId > 0 of
                true  -> lib_team_api:inerrupt_follow(TeamId, Id);
                false -> skip
            end,
            mod_scene_agent:cast_to_scene(SceneId, ScenePoolId, {'inerrupt_follow', Id}),
            Status#player_status{follow_target_xy={0,0}, follow_target_conut=0};
        _ ->
            Status
    end.

%% 登录修复(托管登录需要处理)
login_for_onhook_fix_ref(Player) ->
    #player_status{socket = Socket, onhook = Onhook} = Player,
    if 
        is_port(Socket) == false -> 
            #status_onhook{
                lv = Lv, exp = Exp,
                c_lv = Clv, c_exp = CExp
                } = Onhook,
            % 获取挂机等级和经验
            case Clv == 0 of
                true -> OnhookLv = Lv, OnhookExp = CExp+Exp;
                false -> OnhookLv = Clv, OnhookExp = CExp+Exp
            end,
            make_onhook_fix_ref(Player, OnhookLv, OnhookExp);
        true -> 
            Player
    end.

%% 每20分钟检查是否有经验,修复离线挂机
make_onhook_fix_ref(Player, CheckOnhookLv, CheckOnhookExp) ->
    #player_status{figure = #figure{lv=CheckRoleLv}, exp = CheckRoleExp, onhook_fix_ref = OldRef, pid = RolePid} = Player,
    Ref = util:send_after(OldRef, 1200*1000, RolePid, {'onhook_fix_ref', CheckOnhookLv, CheckOnhookExp, CheckRoleLv, CheckRoleExp}),
    Player#player_status{onhook_fix_ref = Ref}.

onhook_fix_ref(Player, CheckOnhookLv, CheckOnhookExp, CheckRoleLv, CheckRoleExp) ->
    case Player#player_status.online of
        ?ONLINE_OFF_ONHOOK ->
            #player_status{
                id = RoleId, scene = Scene, scene_pool_id = PoolId, x = X, y = Y, figure = #figure{lv=RoleLv}, exp = RoleExp,
                onhook = Onhook, onhook_fix_ref = OldRef,
                battle_attr = #battle_attr{ghost = Ghost, hide = Hide, hp = Hp}
                } = Player,
            #status_onhook{
                lv = Lv, exp = Exp,
                c_lv = Clv, c_exp = CExp,
                onhook_sxy = OnhookSxy
                } = Onhook,
            % 获取挂机等级和经验
            case Clv == 0 of
                true -> OnhookLv = Lv, OnhookExp = CExp+Exp;
                false -> OnhookLv = Clv, OnhookExp = CExp+Exp
            end,
            % 输出数据并且再强制挂机
            % 1.挂机经验不动
            % 2.玩家经验没有动
            case (OnhookLv == CheckOnhookLv andalso OnhookExp == CheckOnhookExp) orelse (CheckRoleLv==RoleLv andalso CheckRoleExp==RoleExp) of
                true -> 
                    % About = util:term_to_string([Scene, X, Y, OnhookLv, OnhookExp]),
                    About = lists:concat(["Scene:", Scene, ",X:", X, ",Y:",Y, ",OnhookLv:", OnhookLv, ",CheckOnhookLv:", CheckOnhookLv, 
                        ",OnhookExp:", OnhookExp, ",CheckOnhookExp:", CheckOnhookExp, ",CheckRoleLv:", CheckRoleLv, ",RoleLv:", RoleLv,
                        ",CheckRoleExp:", CheckRoleExp, ",RoleExp:", RoleExp, ",Hp:", Hp, ",Ghost:", Ghost, ",Hide:", Hide, ",OnhookSxy:", util:term_to_string(OnhookSxy)]),
                    lib_log_api:log_game_error(RoleId, 1, About),
                    % 强制挂机
                    TargetPlace = lib_onhook_offline:select_a_onhook_place(Player, Scene),
                    case TargetPlace of
                        false -> PlayerAfOnhook = Player;
                        _ ->
                            case TargetPlace of
                                {TId, TX, TY} -> %% 在推荐挂机场景
                                    TSid = Scene,
                                    PlayerAfFix = Player#player_status{x = TX, y = TY};
                                {TSid, TId, TX, TY} ->
                                    PlayerAfFix = lib_scene:change_scene(Player, TSid, PoolId, 0, TX, TY, false, [])
                            end,
                            NewOnhook = Onhook#status_onhook{onhook_sxy = {TSid, TId, TX, TY}},
                            PlayerAfOnhook = PlayerAfFix#player_status{onhook = NewOnhook},
                            gen_server:cast(self(), {'set_data', [{load_scene_auto, 0}]})
                    end;
                false ->
                    PlayerAfOnhook = Player
            end,
            % About0 = lists:concat(["Scene:", Scene, ",X:", X, ",Y:",Y, ",OnhookLv:", OnhookLv, ",CheckOnhookLv:", CheckOnhookLv, 
            %     ",OnhookExp:", OnhookExp, ",CheckOnhookExp:", CheckOnhookExp, ",CheckRoleLv:", CheckRoleLv, ",RoleLv:", RoleLv,
            %     ",CheckRoleExp:", CheckRoleExp, ",RoleExp:", RoleExp, ",Hp:", Hp, ",Ghost:", Ghost, ",Hide:", Hide]),
            % lib_log_api:log_game_error(RoleId, 0, About0),
            % gen_server:cast(self(), {'set_data', [{load_scene_auto, 0}]}),
            % ?MYLOG("hjhfix", "onhook_fix_ref RoleId:~p ~n", [RoleId]),
            util:cancel_timer(OldRef),
            NewPlayer = make_onhook_fix_ref(PlayerAfOnhook, OnhookLv, OnhookExp),
            NewPlayer;
        _ ->
            Player
    end.

