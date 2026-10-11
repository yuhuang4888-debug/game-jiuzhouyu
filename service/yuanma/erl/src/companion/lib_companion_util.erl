%% ---------------------------------------------------------------------------
%% @doc lib_companion_util

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/4/28
%% @deprecated   伙伴模块,工具函数
%% ---------------------------------------------------------------------------
-module(lib_companion_util).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("companion.hrl").
-include("skill.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("attr.hrl").

%% 获取战力信息
%% 计算战力时调用
get_power_info(StatusCompanion) ->
    #status_companion{sum_attr = SumAttr, skill_list = SkillList} = StatusCompanion,
    Power = get_skill_power(SkillList),
    {SumAttr, Power}.

%% 逻辑初始化
logic_init_companion(CompanionId) ->
    #base_companion_stage{
        attr = Attr
    } = data_companion:get_companion_stage(CompanionId, ?MIN_STAGE_, ?ACTIVE_STAR_),
    #companion_item{
        companion_id= CompanionId ,stage= ?MIN_STAGE_
        ,star = ?ACTIVE_STAR_ ,stage_attr = Attr
        ,skill = get_companion_skills(CompanionId, ?MIN_STAGE_)
        ,is_fight = ?IS_FIGHT  %% 默认出战
    }.

%% 获取伙伴经验加成
get_exp_ratio(Ps) ->
    #player_status{status_companion = StatusCompanion} = Ps,
    #status_companion{sum_attr = SumAttr} = StatusCompanion,
    {_, ExpRatio} = ulists:keyfind(?EXP_ADD, 1, SumAttr, {?EXP_ADD, 0}),
    ExpRatio.

%% 检查当前技能
check_skill_has_fight(Ps, SkillId) ->
    #player_status{status_companion = StatusCompanion} = Ps,
    #status_companion{skill_list = SkillList, fight_id = CompanionId} = StatusCompanion,
    AttSkill =
        case data_companion:get_companion(CompanionId) of
            #base_companion{attack_skill = ASkillId} -> [{ASkillId, 1}];
            _ -> []
        end,
    ulists:keyfind(SkillId, 1, SkillList ++ AttSkill, false).

%% 计算status属性，技能\
%% 伙伴身上的技能：只有出站了的伙伴，被动技能和主动技能才会生效
%%  但是被动节能的属性增益只要激活了就会生效
calc_status_companion(StatusCompanion) ->
    #status_companion{
        companion_list = CompanionList
    } = StatusCompanion,
    F = fun(Companion, {GrandList, GrandAttr, GrandSkill, FId}) ->
        #companion_item{
            stage = Stage, star = Star, companion_id = CId,
            train_num = TrainNum, is_fight = IsFight
        } = Companion,
        #base_companion_stage{attr = StageAttr} = data_companion:get_companion_stage(CId, Stage, Star),
        #base_companion{train_attr = SingleAttr} = data_companion:get_companion(CId),
        TrainAttr = ?IF(TrainNum /= 0, [{Key, Val * TrainNum}||{Key, Val} <-SingleAttr], []),

        SkillList = get_companion_skills(CId, Stage),

        SkillAttr = lib_skill:get_passive_skill_attr(SkillList),

        NewAttr = lib_player_attr:add_attr(list, [GrandAttr, TrainAttr, StageAttr, SkillAttr]),

        NewCompanion = Companion#companion_item{
            train_attr = TrainAttr,
            skill = SkillList,
            stage_attr = StageAttr
        },

        {NewFId, NewSkillList} = ?IF(IsFight == ?IS_FIGHT, {CId, SkillList}, {FId, GrandSkill}),

        {[NewCompanion|GrandList], NewAttr, NewSkillList, NewFId}
        end,
    {NewCompanionList, SumAttr, SkillList, NewFightId} = lists:foldl(F, {[], [], [], 0}, CompanionList),
    StatusCompanion#status_companion{sum_attr = SumAttr, skill_list = SkillList, fight_id = NewFightId, companion_list = NewCompanionList}.


%% 根据伙伴id和当前阶数获取伙伴当前技能List
get_companion_skills(CompanionId, Stage) ->
    SkillIdList = data_companion:list_companion_skill_id(CompanionId),
    F = fun(SkillId, {Lv, GrandList}) ->
        #base_companion_skill{unlock_stage = NeedStage, main_skill_lv = MLv} = data_companion:get_companion_skill(CompanionId, SkillId),
        ?IF(Stage >= NeedStage, {max(Lv, MLv), [SkillId|GrandList]}, {Lv, GrandList})
        end,
    {MainSkillLv, HavingSList} = lists:foldl(F, {1, []}, SkillIdList),
    %% 技能等级封装，被动技能默认1级， 主动技能根据被动情况设置等级
    [begin
         case data_companion:get_companion_skill(CompanionId, SkillId) of
             #base_companion_skill{skill_type = ?SKILL_ACTIVE} -> {SkillId, MainSkillLv};
             _ -> {SkillId, 1}
         end
     end||SkillId<-HavingSList].

get_companion_status_power(Ps) ->
    #status_companion{
        sum_attr = SumAttr,
        skill_list = SkillList
    } = Ps#player_status.status_companion,
    SkillPower = get_skill_power(SkillList),
    lib_player:calc_partial_power(Ps#player_status.original_attr, SkillPower, SumAttr).

%% 获取当前伙伴的真实战力
get_companion_active_power(CompanionId, Ps) when is_integer(CompanionId) ->
    #companion_item{
        companion_id = CompanionId,
        skill = SkillList,stage_attr = StageAttr
    } = lib_companion_util:logic_init_companion(CompanionId),
    SkillPower = lib_companion_util:get_skill_power(SkillList),
    Combat = lib_player:calc_partial_power(Ps#player_status.original_attr, SkillPower, StageAttr),
    Combat.

get_companion_real_power(Companion, Ps) ->
    #companion_item{
        stage = Stage, star = Star, skill = SkillList,
        train_num = TrainNum, companion_id = CId
    } = Companion,
    #base_companion_stage{attr = StageAttr} = data_companion:get_companion_stage(CId, Stage, Star),
    #base_companion{train_attr = SingleAttr} = data_companion:get_companion(CId),
    TrainAttr = ?IF(TrainNum /= 0, [{Key, Val * TrainNum}||{Key, Val} <-SingleAttr], []),
    ItemAttr = lib_player_attr:add_attr(list, [StageAttr, TrainAttr]),
    SkillPower = lib_companion_util:get_skill_power(SkillList),
    Combat = lib_player:calc_partial_power(Ps#player_status.original_attr, SkillPower, ItemAttr),
    Combat.

%% 获取当前伙伴的主动技能
get_active_skill(Ps) when is_record(Ps, player_status) ->
    #status_companion{
        skill_list = SkillList,
        fight_id = CompanionId
    } = Ps#player_status.status_companion,
    F = fun({SkillId, SkillLv}, GrandSL) ->
        case data_companion:get_companion_skill(CompanionId, SkillId) of
            #base_companion_skill{skill_type = SkillType} ->
                case SkillType of
                    ?SKILL_PASSIVE -> GrandSL;
                    _ ->
                        case data_skill:get(SkillId, SkillLv) of
                            #skill{type = ?SKILL_TYPE_ACTIVE} -> [{SkillId, SkillLv}|GrandSL];
                            _ ->GrandSL
                        end
                end;
            _ ->
                ?ERR("data_companion_skill_err ~p ~n", [[CompanionId, SkillId]]),
                GrandSL
        end
        end,
    case data_companion:get_companion(CompanionId) of
        [] -> NorSkill = [];
        #base_companion{attack_skill = AttackSkillId} ->
            NorSkill = [{AttackSkillId, 1}]
    end,
    ActiveSkillList = lists:foldl(F, [], SkillList),
    ActiveSkillList ++ NorSkill;

get_active_skill(CompanionId) when is_integer(CompanionId) ->
    case data_companion:get_companion(CompanionId) of
        #base_companion{skill_list = SkillLists} ->
            case SkillLists of
                [] -> 0;
                [ActiveSkillId|_] -> ActiveSkillId
            end;
        _ -> 0
    end.

%% 获取被动技能
get_passive_skill(Ps) ->
    #status_companion{
        skill_list = SkillList,
        fight_id = CompanionId
    } = Ps#player_status.status_companion,
    F = fun({SkillId, SkillLv}, GrandSL) ->
        case data_companion:get_companion_skill(CompanionId, SkillId) of
            #base_companion_skill{skill_type = SkillType} ->
                case SkillType of
                    ?SKILL_PASSIVE ->
                        case data_skill:get(SkillId, SkillLv) of
                            #skill{type = ?SKILL_TYPE_PASSIVE} -> [{SkillId, SkillLv}|GrandSL];
                            _ ->GrandSL
                        end;
                    _ -> GrandSL
                end;
            _ ->
                ?ERR("data_companion_skill_err ~p ~n", [[CompanionId, SkillId]]),
                GrandSL
        end
        end,
    lists:foldl(F, [], SkillList).

%% 获取当前伙伴的真实战力
get_companion_real_power(Companion, ItemAttr, Ps) ->
    #companion_item{skill = SkillList} = Companion,
    SkillPower = lib_companion_util:get_skill_power(SkillList),
    Combat = lib_player:calc_partial_power(Ps#player_status.original_attr, SkillPower, ItemAttr),
    Combat.

%% 获取所有伙伴真是战力
get_all_companion_real_power(Ps) ->
    #player_status{status_companion = StatusCompanion} = Ps,
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    F = fun(CompanionItem, FunCombat) ->
        #companion_item{
            stage_attr = StageAttr, train_attr = TrainAttr
        } = CompanionItem,
        ItemAttr = lib_player_attr:add_attr(list, [StageAttr, TrainAttr]),
        Combat = lib_companion_util:get_companion_real_power(CompanionItem, ItemAttr, Ps),
        FunCombat + Combat
    end,
    lists:foldl(F, 0, CompanionList).

%% 获取指定伙伴的期望战力
get_companion_expect_power(CompanionId, Ps) ->
    #companion_item{
        companion_id = CompanionId,
        skill = SkillList,stage_attr = StageAttr
    } = lib_companion_util:logic_init_companion(CompanionId),
    SkillPower = lib_companion_util:get_skill_power(SkillList),
    Combat = lib_player:calc_expact_power(Ps#player_status.original_attr, SkillPower, StageAttr),
    Combat.


%% 获取figure_id
get_figure_id(CompanionId) ->
    case data_companion:get_companion(CompanionId) of
        #base_companion{figure_id = FigureId} -> FigureId;
        _ -> 0
    end .

%% 判断当前伙伴是否激活
is_active(Player, CompanionId) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = Player,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        #companion_item{} -> true;
        _ -> false
    end.

%% 获取激活伙伴数量
active_num(Player) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = Player,
    length(CompanionList).


%% 获取技能战力
get_skill_power(SkillList) -> get_skill_power(0, SkillList).

get_skill_power(SumPower, []) -> SumPower;
get_skill_power(SumPower, [{SkillId, Lv}|T]) ->
    case data_skill:get_lv_data(SkillId, Lv) of
        #skill_lv{power = Power} -> get_skill_power(SumPower + Power, T);
        _ -> get_skill_power(SumPower, T)
    end;
get_skill_power(SumPower, [SkillId|T]) when is_integer(SkillId) ->
    case data_skill:get_lv_data(SkillId, 1) of
        #skill_lv{power = Power} -> get_skill_power(SumPower + Power, T);
        _ -> get_skill_power(SumPower, T)
    end.

check_companion_return_item(CompanionId, StatusCompanion, CheckList) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case check_companion(CompanionId, StatusCompanion, CheckList) of
        true ->
            {true, lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList)};
        Error -> Error
    end.

check_companion(_CompanionId, _StatusCompanion, []) -> true;
check_companion(CompanionId, StatusCompanion, [T|H]) ->
    case data_companion:get_companion(CompanionId) of
        [] -> {false, ?MISSING_CONFIG};
        _ ->
            case do_check_companion(T, CompanionId, StatusCompanion) of
                true ->
                    check_companion(CompanionId, StatusCompanion, H);
                Error ->
                    Error
            end
    end.


do_check_companion(check_active, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> {false, ?ERRCODE(err142_no_active)};
        #companion_item{} -> true
    end;

do_check_companion(check_no_active, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> true;
        #companion_item{} -> {false, ?ERRCODE(err142_had_active)}
    end;

do_check_companion(check_fight, CompanionId, StatusCompanion) ->
    #status_companion{fight_id = FightId} = StatusCompanion,
    if
        CompanionId == FightId ->
            {false, ?ERRCODE(err142_had_fight)};
        true -> true
    end;

do_check_companion(check_upgrade, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    LimitStage = ?MAX_STAGE_,
    LimitStar = ?MAX_STAR_,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> {false, ?ERRCODE(err142_no_active)};
        #companion_item{stage = LimitStage, star = LimitStar} ->
            {false, ?ERRCODE(err142_max_stage)};
        _ -> true
    end;

do_check_companion(check_train, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> {false, ?ERRCODE(err142_no_active)};
        #companion_item{train_num = TrainNum} ->
            #base_companion{train_limit = LimitTrain} = data_companion:get_companion(CompanionId),
            case TrainNum >= LimitTrain of
                true -> {false, ?ERRCODE(err142_train_limit)};
                false -> true
            end
    end;

%% 检查当前伙伴是否还没解锁该传记等级
do_check_companion({check_biog_unlock, BiogLv}, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> {false, ?ERRCODE(err142_no_active)};
        #companion_item{biography = BiogList} ->
            case lists:member(BiogLv, BiogList) of
                true -> {false, ?ERRCODE(err142_biog_had_unlock)};
                false -> true
            end
    end;

%% 检查当前伙伴是否可以解锁该传记等级
do_check_companion({check_companion_stage_star, BiogLv}, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    case lists:keyfind(CompanionId, #companion_item.companion_id, CompanionList) of
        false -> {false, ?ERRCODE(err142_no_active)};
        #companion_item{stage = Stage, star = Star} ->
            case data_companion:get_biog_stage_star(CompanionId, BiogLv) of
                [] ->
                    {false, ?MISSING_CONFIG};
                [{MinStage, MinStar}|_] when Stage > MinStage; Stage == MinStage, Star >= MinStar ->
                    true;
                _ ->
                    {false, ?ERRCODE(err142_stage_star_not_enough)}
            end
    end;

do_check_companion(_, _, _) -> false.
