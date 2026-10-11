%%-----------------------------------------------------------------------------
%% @Module  :       lib_holy_ghost.erl
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2018-5-28
%% @Description:    圣灵
%%-----------------------------------------------------------------------------
-module(lib_holy_ghost).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("holy_ghost.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("def_fun.hrl").

-compile(export_all).

%% 登录
login(Player) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = Figure} = Player,
    HolyGhost0 = case db:get_row(io_lib:format(?sql_player_holy_ghost_select, [RoleId])) of
                     [FightId, IlluId, Display, BBoundIds] ->
                         BoundIds = util:bitstring_to_term(BBoundIds),
                         #status_holy_ghost{fight_id = FightId, illus_id = IlluId, display = Display, bound_ids = BoundIds, battle_attr = #battle_attr{}};
                     _ -> #status_holy_ghost{battle_attr = #battle_attr{}}
                 end,
    F1 = fun
             ([Id, Stage, Exp, Lv, Time], AccL) ->
                 [#ghost{id = Id, stage = Stage, exp = Exp, lv = Lv, active_time = Time} | AccL]
         end,
    GhostL = lists:foldl(F1, [], db:get_all(io_lib:format(?sql_holy_ghost_select, [RoleId]))),
    HolyGhost1 = HolyGhost0#status_holy_ghost{ghost = GhostL},
    F2 = fun
             ([Id, ATime, ETime], AccL) when NowTime >= ATime + ETime ->
                 db:execute(io_lib:format(?sql_delete_holy_ghost_illu, [RoleId, Id])),
                 AccL;
             ([Id, ATime, ETime], AccL) ->
                 lib_player_record:role_func_check_update(RoleId, holyghost_illu, {Id, ATime + ETime}),
                 [#ghost_illu{id = Id, active_time = ATime, effect_time = ETime} | AccL]
         end,
    GhostIlluL = lists:foldl(F2, [], db:get_all(io_lib:format(?sql_holy_ghost_illu_select, [RoleId]))),
    HolyGhost2 = HolyGhost1#status_holy_ghost{ghost_illu = GhostIlluL},
    RelicAttr = get_relic_attr(RoleId),
    HolyGhost3 = HolyGhost2#status_holy_ghost{relic_attr = RelicAttr},
    LastHolyGhost = sync_data(Player, HolyGhost3),
    Player#player_status{
        holy_ghost = LastHolyGhost,
        figure     = Figure#figure{h_ghost_figure = LastHolyGhost#status_holy_ghost.figure_id, h_ghost_display = LastHolyGhost#status_holy_ghost.display}
    }.

sync_data(PS, HG) ->
    #status_holy_ghost{
        fight_id    = FightId,
        illus_id    = IlluId,
        ghost       = GhostL,
        ghost_illu  = IlluL,
        relic_attr  = RelicAttr,      %% 遗迹属性通过计数器
        battle_attr = BattleAttr
    } = HG,
    %% 基本圣灵属性和普通技能
    NewGhostL = refresh_ghost_attr(FightId, GhostL),
    F1 = fun
             (#ghost{norm_skill = NormSkill, attr = Attr}, {TmpAttrL, TmpSkillL}) ->
                 {Attr ++ TmpAttrL, NormSkill ++ TmpSkillL}
         end,
    {GhostAttr, GhostSkills} = lists:foldl(F1, {[], []}, NewGhostL),
    %% 幻形属性
    NewIlluL = refresh_ghost_illu_attr(IlluId, IlluL),
    F2 = fun
             (#ghost_illu{attr = Attr}, AccL) -> Attr ++ AccL
         end,
    IlluAttr = lists:foldl(F2, [], NewIlluL),
    %% 结界属性
    F3 = fun
             (Id, AccL) ->
                 case data_holy_ghost:get_bound(Id) of
                     #base_holy_ghost_bound{attr = Attr, condition = Condition} ->
                         case check_bound_condition(HG, Condition) of
                             true -> Attr ++ AccL;
                             false -> AccL
                         end;
                     _ -> AccL, ?ERR("cfg err! ~n", [])
                 end
         end,
    BoundAttr = lists:foldl(F3, [], data_holy_ghost:get_bound_ids()),
    %% 结界技能
    F4 = fun
             (Id, AccL) ->
                 case data_holy_ghost:get_bound_skill(Id) of
                     #base_holy_ghost_bound_skill{skill = Skill, condition = Condition} ->
                         case check_bound_skill_condition(HG, Condition) of
                             true -> Skill ++ AccL;
                             false -> AccL
                         end;
                     _ -> AccL, ?ERR("cfg err! ~n", [])
                 end
         end,
    BoundSkills = lists:foldl(F4, [], data_holy_ghost:get_bound_skill_ids()),
    %% 出战技能会根据基本的和幻形的判断
    FightSkill = get_fight_skill(HG, NewGhostL, NewIlluL),
    SumSkills = FightSkill ++ GhostSkills ++ BoundSkills,
    PassiveSkills = lib_skill_api:divide_passive_skill(SumSkills),
    ?IF(PassiveSkills =:= [], skip, mod_scene_agent:update(PS, [{passive_skill, PassiveSkills}])),
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_HOLY_GHOST, SumSkills),
    SumAttr = util:combine_list(SkillAttr ++ GhostAttr ++ BoundAttr ++ IlluAttr ++ RelicAttr),
    NewAttr = lib_player_attr:partial_attr_convert(SumAttr),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewComBat = lib_player:calc_all_power(NewAttrR),
    NewBattleAttr = BattleAttr#battle_attr{attr = NewAttrR},
    case PS#player_status.scene > 0 of
        true -> mod_scene_agent:update(PS, [{holyghost_battle_attr, NewBattleAttr}]);
        false -> skip
    end,
    NewHG = HG#status_holy_ghost{
        ghost         = NewGhostL,
        ghost_illu    = NewIlluL,
        ghost_attr    = GhostAttr,
        bound_attr    = BoundAttr,
        illu_attr     = IlluAttr,
        norm_skill    = GhostSkills,
        bound_skill   = BoundSkills,
        fight_skill   = FightSkill,
        passive_skill = PassiveSkills,
        figure_id     = get_figure_id(HG),
        attr          = NewAttr,
        combat        = NewComBat,
        battle_attr   = NewBattleAttr
    },
    lib_common_rank_api:refresh_rank_by_holy_ghost(PS#player_status{holy_ghost = NewHG}),
    NewHG.


%% 根据配置的阶数限制获取普通技能
get_norm_skill_by_stage(SkillCfg, Stage) ->
    F = fun
            ({SkillId, StageLim}, AccL) when Stage >= StageLim ->
                [{SkillId, 1} | AccL];
            (_, AccL) ->
                AccL
        end,
    lists:foldl(F, [], SkillCfg).


%% 检测结界属性条件
check_bound_condition(HolyGhost, [{NumLim, StageLim}]) ->
    #status_holy_ghost{ghost = GhostL, bound_ids = BoundInfos} = HolyGhost,
    BoundIds = [Id || {_, Id} <- BoundInfos],
    Pred1 = length(BoundIds) >= NumLim,
    F = fun
            (Id, P) ->
                case lists:keyfind(Id, #ghost.id, GhostL) of
                    #ghost{stage = Stage} when Stage >= StageLim ->
                        P andalso true;
                    _ ->
                        P andalso false
                end
        end,
    Pred2 = lists:foldl(F, true, BoundIds),
    Pred1 andalso Pred2.

%% 检测结界技能条件
check_bound_skill_condition(HolyGhost, Condition) ->
    #status_holy_ghost{ghost = GhostL, bound_ids = BoundInfos} = HolyGhost,
    BoundIds = [Id || {_, Id} <- BoundInfos],
    F = fun
            ({Id, LvLim}, P) ->
                case lists:member(Id, BoundIds) of
                    true ->
                        case lists:keyfind(Id, #ghost.id, GhostL) of
                            #ghost{lv = Lv} when Lv >= LvLim ->
                                P andalso true;
                            _ ->
                                P andalso false
                        end;
                    _ ->
                        P andalso false
                end
        end,
    lists:foldl(F, true, Condition).

%% 获取遗迹属性 终生计数器
get_relic_attr(RoleId) ->
    CounterL = mod_counter:get_count_offline(RoleId, ?MOD_HOLY_GHOST, data_holy_ghost:get_relic_good_ids()),
    F = fun
            ({GId, Num}, AccL) ->
                case data_holy_ghost:get_holy_ghost_relic(GId) of
                    #base_holy_ghost_relic{attr = Attr} ->
                        [{AId, AVal * Num} || {AId, AVal} <- Attr] ++ AccL;
                    _ ->
                        AccL, ?ERR("cfg err! ~n", [])
                end
        end,
    lists:foldl(F, [], CounterL).

%% 出战技能
get_fight_skill(HolyGhost, GhostL, IlluL) ->
    #status_holy_ghost{fight_id = GhostId, illus_id = IlluId} = HolyGhost,
    case IlluId == 0 of     %% 当前没幻形
        true ->
            case lists:keyfind(GhostId, #ghost.id, GhostL) of
                #ghost{fight_skill = FightSkill} -> FightSkill;
                _ -> []
            end;
        false ->
            case lists:keyfind(IlluId, #ghost_illu.id, IlluL) of
                #ghost_illu{fight_skill = FightSkill} -> FightSkill;
                _ -> []
            end
    end.

%% 出战技能
get_figure_id(HolyGhost) ->
    #status_holy_ghost{fight_id = GhostId, illus_id = IlluId} = HolyGhost,
    case IlluId == 0 of     %% 当前没幻形
        true ->
            case data_holy_ghost:get_holy_ghost(GhostId) of
                #base_holy_ghost{figure_id = FigureId} -> FigureId;
                _ -> 0
            end;
        false ->
            case data_holy_ghost:get_holy_ghost_illu(IlluId) of
                #base_holy_ghost_figure{figure_id = FigureId} -> FigureId;
                _ -> 0
            end
    end.

%% 单个圣灵属性和技能
refresh_ghost_attr(FightId, GhostL) ->
    F = fun
            (#ghost{id = Id, stage = Stage, lv = Lv} = G) ->
                case data_holy_ghost:get_holy_ghost_stage(Id, Stage) of
                    #base_holy_ghost_stage{attr = StageAttr} -> skip;
                    _ -> StageAttr = [], ?ERR("cfg err! ~n", [])
                end,
                case data_holy_ghost:get_holy_ghost_awake(Id, Lv) of
                    #base_holy_ghost_awake{attr = LvAttr, fight_skill_lv = AwakeFightSkill} -> skip;
                    _ -> LvAttr = [], AwakeFightSkill = []
                end,
                case data_holy_ghost:get_holy_ghost(Id) of
                    #base_holy_ghost{norm_skill = NormSkillCfg, fight_skill = InitFightSkill} ->
                        NormSkill = get_norm_skill_by_stage(NormSkillCfg, Stage);
                    _ -> NormSkill = InitFightSkill = [], ?ERR("cfg err! ~n", [])
                end,
                %% 有觉醒用觉醒
                FightSkill = ?IF(AwakeFightSkill =:= [], InitFightSkill, AwakeFightSkill),
                case FightId == Id of        %% 当前出战的话 属性算上
                    true -> SumSkills = FightSkill ++ NormSkill;
                    false -> SumSkills = NormSkill
                end,
                SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_HOLY_GHOST, SumSkills),
                NewAttr = partial_attr_convert(SkillAttr ++ StageAttr ++ LvAttr),
                NewAttrR = lib_player_attr:to_attr_record(NewAttr),
                NewCombat = lib_player:calc_all_power(NewAttrR),
                G#ghost{norm_skill = NormSkill, fight_skill = FightSkill, attr = NewAttr, combat = NewCombat}
        end,
    [F(G) || G <- GhostL].

%% 单个幻形属性和技能
refresh_ghost_illu_attr(_IlluId, IlluL) ->
    F = fun
            (#ghost_illu{id = Id} = I) ->
                case data_holy_ghost:get_holy_ghost_illu(Id) of
                    #base_holy_ghost_figure{attr = IlluAttr, skill = FightSill} -> skip;
                    _ -> FightSill = IlluAttr = [], ?ERR("cfg err! ~n", [])
                end,
                AttrR = lib_player_attr:to_attr_record(IlluAttr),
                Combat = lib_player:calc_all_power(AttrR),
                I#ghost_illu{attr = IlluAttr, combat = Combat, fight_skill = FightSill}
        end,
    [F(I) || I <- IlluL].

%% 根据人物等级拿配置的最大次数
get_relic_max_times(GId, RoleLv) ->
    case data_holy_ghost:get_holy_ghost_relic(GId) of
        #base_holy_ghost_relic{id = RelicId, num_limit = [{_, _, _} | _] = NumLimL} ->
            {RelicId, do_get_relic_max_times(NumLimL, RoleLv)};
        _ -> ?ERR("cfg err!~n", []), {0, 0}
    end.
do_get_relic_max_times([], _RoleLv) -> 0;
do_get_relic_max_times([{MinLv, MaxLv, Num} | T], RoleLv) ->
    case RoleLv >= MinLv andalso RoleLv =< MaxLv of
        true -> Num;
        _ -> do_get_relic_max_times(T, RoleLv)
    end.

%% 幻形时效失效
cancel_illu(PS, IlluId) ->
    #player_status{sid = Sid, id = RoleId, holy_ghost = StatusHG} = PS,
    #status_holy_ghost{illus_id = SelIlluId, ghost_illu = IlluL, ghost = GhostL, display = Display, bound_ids = BoundIds} = StatusHG,
    NewIlluL = lists:keydelete(IlluId, #ghost_illu.id, IlluL),
    #base_holy_ghost_figure{name = IlluName} = data_holy_ghost:get_holy_ghost_illu(IlluId),
    case IlluId == SelIlluId of
        true ->
            TmpL = [{Time, Id, illu} || #ghost_illu{id = Id, active_time = Time} <- NewIlluL] ++ [{Time, Id, ghost} || #ghost{id = Id, active_time = Time} <- GhostL],
            case TmpL of
                [] ->
                    NewStatusHG = lib_holy_ghost:sync_data(PS, StatusHG#status_holy_ghost{fight_id = 0, illus_id = 0, ghost_illu = NewIlluL}),
                    PlayerTmp = lib_player:count_player_attribute(PS#player_status{holy_ghost = NewStatusHG}),
                    NewPlayer = PlayerTmp#player_status{figure = #figure{h_ghost_figure = 0}},
                    pp_holy_ghost:broadcast_to_scene(NewPlayer),
                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                    db:execute(io_lib:format(?sql_replace_player_holy_ghost, [RoleId, 0, 0, Display, util:term_to_string(BoundIds)]));
                _ ->
                    case lists:max(TmpL) of
                        {_Time, Id, illu} ->
                            {ok, _, NewPlayer} = pp_holy_ghost:handle(60611, PS#player_status{holy_ghost = StatusHG#status_holy_ghost{ghost_illu = NewIlluL}}, [2, Id]);
                        {_Time, Id, ghost} ->
                            {ok, _, NewPlayer} = pp_holy_ghost:handle(60611, PS#player_status{holy_ghost = StatusHG#status_holy_ghost{ghost_illu = NewIlluL}}, [1, Id])
                    end
            end;
        _ -> NewPlayer = PS#player_status{holy_ghost = StatusHG#status_holy_ghost{ghost_illu = NewIlluL}}
    end,
    db:execute(io_lib:format(?sql_delete_holy_ghost_illu, [RoleId, IlluId])),
    lib_log_api:log_holy_ghost_illu_active(RoleId, IlluName, 1, []),
    lib_mail_api:send_sys_mail([RoleId], utext:get(6060001), utext:get(6060002, [IlluName]),[]),
    lib_server_send:send_to_sid(Sid, pt_606, 60610, [IlluId]),
    NewPlayer.

get_holy_ghost_max_stage(Ps) ->
    #player_status{holy_ghost = StatusHG} = Ps,
    #status_holy_ghost{ghost = GhostL, ghost_illu = IlluL} = StatusHG,
    case L = [{Stage, Id} || #ghost{id = Id, stage = Stage} <- GhostL] of
        [] ->
            case IlluL of
                [#ghost_illu{id = Id} | _] ->
                    {Id, 0};
                _ -> {0, 0}
            end;
        _ ->
            {TStage, TId} = lists:max(L),
            {TId, TStage}
    end.

partial_attr_convert(AttrList) ->
    AttrList1 = util:combine_list(AttrList),
    case lists:keyfind(?PARTIAL_WHOLE_ADD_RATIO, 1, AttrList1) of
        {?PARTIAL_WHOLE_ADD_RATIO, WholeAddRatio} when WholeAddRatio > 0 ->
            AttrList2 = lists:keydelete(?PARTIAL_WHOLE_ADD_RATIO, 1, AttrList1),
            [{AId, round(AVal * (1 + WholeAddRatio / ?RATIO_COEFFICIENT))} || {AId, AVal} <- AttrList2];
        _ -> AttrList1
    end.

%% 检查客户端是不是可以发起技能攻击
check_skill_has_learn(RoleId, HolyGhost, SkillId) ->
    #status_holy_ghost{fight_skill = FightSkill} = HolyGhost,
    case lists:keyfind(SkillId, 1, FightSkill) of
        false -> false;
        {_, SkillLv}->
            case get({holy_ghost, RoleId}) of
                {LastCdTime, 1} -> %% 只有服务端标记类才能使用
                    put({holy_ghost, RoleId}, {LastCdTime, 0}),
                    SkillLv;
                _R ->
                    false
            end
    end.

%% 检查玩家是不是可以释放该特殊技能
check_holy_ghost_skill(Ps, AttOrDef) ->
    #player_status{id = RoleId, sid = Sid, holy_ghost = HolyGhost} = Ps,
    #status_holy_ghost{fight_id = FightId, illus_id = IllusId} = HolyGhost,
    case data_holy_ghost:get_holy_ghost_illu(IllusId) of %% 存在幻型
        #base_holy_ghost_figure{trigger_type = Type, trigger_prob = Ratio, skill = FightSkill} ->
            case check_can_use_holy_ghost_skill(RoleId, AttOrDef, Type, Ratio, FightSkill) of
                false -> skip;
                {true, SkillId} ->
                    lib_server_send:send_to_sid(Sid, pt_200, 20019, [SkillId])
            end;
        _ ->
            case data_holy_ghost:get_holy_ghost(FightId) of
                #base_holy_ghost{trigger_type = Type, trigger_prob = Ratio, fight_skill = FightSkill} ->
                    case check_can_use_holy_ghost_skill(RoleId, AttOrDef, Type, Ratio, FightSkill) of
                        false ->
                            skip;
                        {true, SkillId} ->
                            lib_server_send:send_to_sid(Sid, pt_200, 20019, [SkillId])
                    end;
                _ ->
                    skip
            end
    end.

%% 检查配置数据和cd时间
check_can_use_holy_ghost_skill(RoleId, AttOrDef, Type, Ratio, FightSkill) ->
    if
        AttOrDef =/= Type -> false;
        FightSkill == [] -> false;
        true ->
            Rand = urand:rand(1, 10000),
            if
                Rand > Ratio -> false;
                true ->
                    [{SkillId, _SkillLv}|_] = FightSkill,
                    #skill{lv_data = SkillLvData} = data_skill:get(SkillId, 1),
                    #skill_lv{cd = Cd} = SkillLvData,
                    if
                        Cd == 0 -> false;
                        true ->
                            NowLongTime = utime:longunixtime(),
                            case get({holy_ghost, RoleId}) of
                                undefined ->
                                    put({holy_ghost, RoleId}, {NowLongTime+Cd+100, 1}),
                                    {true, SkillId};
                                {LastCdTime, _IsCanUse} when LastCdTime > NowLongTime-> %% 时间和是否可以施放技能标记
                                    false;
                                _R ->
                                    put({holy_ghost, RoleId}, {NowLongTime+Cd+100, 1}),
                                    {true, SkillId}
                            end
                    end
            end
    end.
