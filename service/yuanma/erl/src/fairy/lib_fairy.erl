%%%-------------------------------------------------------------------
%%% @author whao
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%%
%%% @end
%%% Created : 07. 十二月 2018 17:11
%%%-------------------------------------------------------------------
-module(lib_fairy).
-author("whao").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("fairy.hrl").
-include("predefine.hrl").
-include("skill.hrl").
-include("scene.hrl").
%% API
-compile(export_all).

login(Player) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    {NewFairy, FigureTmp} =
        case sql_select_fairy(RoleId) of
        [] -> {#fairy{} ,Figure};
        [BattleId, FairyAttrBin] ->
            FairyAttr = util:bitstring_to_term(FairyAttrBin),
            FairyList =
                case sql_select_all_fairy_sub(RoleId) of
                    [[]] -> [];
                    AllFairyList ->
                        [#fairy_sub{
                            fairy_id = FairyId,
                            stage = Stage,
                            level = Level,
                            exp = Exp,
                            combat = Combat,
                            skill_list = util:bitstring_to_term(SkillList),
                            attr_list = util:bitstring_to_term(AttrList)}
                            || [FairyId, Stage, Level, Exp, Combat, SkillList, AttrList] <- AllFairyList]
                end,
            BattleId1 =
            case lists:keyfind(BattleId, #fairy_sub.fairy_id, FairyList) of
                false -> 0;
                #fairy_sub{
                    fairy_id = FairyId,
                    stage = Stage1,
                    level = Level1,
                    exp = Exp1,
                    combat = Combat1,
                    skill_list = SkillList1,
                    attr_list = AttrList1} ->
                    FairyInfo = data_fairy:get_fairy_info(BattleId),
                    %% 保存的Combat是不准确的，每次请求都需要重新算
                    lib_server_send:send_to_uid(RoleId, pt_148, 14802, [?SUCCESS, FairyId, Stage1, Level1, Exp1, Combat1, SkillList1, AttrList1]),
                    FairyInfo#fairy_info_cfg.figure_id
            end,
            NewPower = get_active_skill_power(FairyList),
            FairyTmp =
                #fairy{
                battle_id = BattleId,
                attr = FairyAttr,
                fairy_list = FairyList,
                power = NewPower
            },
            NewFigure = update_role_show(RoleId, Figure, {6, BattleId1}),
            {FairyTmp ,NewFigure}
    end,
    Player#player_status{fairy = NewFairy, figure = FigureTmp}.

offlogin(RoleId) ->
    case sql_select_fairy(RoleId) of
        [] -> #fairy{};
        [BattleId, FairyAttrBin] ->
            FairyAttr = util:bitstring_to_term(FairyAttrBin),
            FairyList =
                case sql_select_all_fairy_sub(RoleId) of
                    [[]] -> [];
                    AllFairyList ->
                        [#fairy_sub{
                            fairy_id = FairyId,
                            stage = Stage,
                            level = Level,
                            exp = Exp,
                            combat = Combat,
                            skill_list = util:bitstring_to_term(SkillList),
                            attr_list = util:bitstring_to_term(AttrList)}
                            || [FairyId, Stage, Level, Exp, Combat, SkillList, AttrList] <- AllFairyList]
                end,
            case lists:keyfind(BattleId, #fairy_sub.fairy_id, FairyList) of
                false -> skip;
                #fairy_sub{
                    fairy_id = FairyId,
                    stage = Stage1,
                    level = Level1,
                    exp = Exp1,
                    combat = Combat1,
                    skill_list = SkillList1,
                    attr_list = AttrList1} ->
                    FairyInfo = data_fairy:get_fairy_info(BattleId),
                    BattleId1 = FairyInfo#fairy_info_cfg.figure_id,
                    lib_server_send:send_to_uid(RoleId, pt_148, 14802, [?SUCCESS, FairyId, Stage1, Level1, Exp1, Combat1, SkillList1, AttrList1]),
                    lib_server_send:send_to_uid(RoleId, pt_148, 14806, [RoleId, BattleId1])
            end,

            NewPower = get_active_skill_power(FairyList),
            #fairy{
                battle_id = BattleId,
                attr = FairyAttr,
                fairy_list = FairyList,
                power = NewPower
            }
    end.

get_no_active_info(PS, FairyId) ->
    #player_status{sid = Sid, original_attr = OriginAttr} = PS,
    case data_fairy:get_fairy_info(FairyId) of
        [] -> lib_server_send:send_to_sid(Sid, pt_148, 14800, [?FAIL]);
        _InfoConfig ->
            StarCombat = get_combat(OriginAttr, FairyId, ?STAGE_INIT, ?LEVEL_INIT, expact),
            lib_server_send:send_to_sid(Sid, pt_148, 14807, [?SUCCESS, FairyId, StarCombat])
    end.

get_combat(OriginAttr, FairyId, Stage, Level, Type) ->
    {Attr1, Skills} = case data_fairy:get_fairy_stage(FairyId, Stage) of 
        [] -> {[], []};
        #fairy_stage_cfg{attr = Attr11, skill_list = Skills1} -> {Attr11, Skills1}
    end,
    Attr2 = case data_fairy:get_fairy_level(FairyId, Level) of 
        [] -> {[], []};
        #fairy_level_cfg{attr = Attr22} -> Attr22
    end,
    SkillPower = get_skill_power(Skills, 0),
    FAttr = Attr1 ++ Attr2,
    case Type == expact of
        true -> lib_player:calc_expact_power(OriginAttr, SkillPower, FAttr);
        _ -> lib_player:calc_partial_power(OriginAttr, SkillPower, FAttr)
    end.

get_skill_power([], Combat) -> Combat;
get_skill_power([SkillId|OtherSkill], Combat) ->
    #skill_lv{power = Power} = data_skill:get_lv_data(SkillId, 1),
    get_skill_power(OtherSkill, Combat + Power).

%% 升阶
stage_up(PS, FairyId) ->
    #player_status{sid = Sid, id = RoleId, fairy = Fairy, figure = Figure} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    AllFairyIds = data_fairy:get_all_fairy_id(),
    {ErrCode, NewPlayer} =
        case lists:member(FairyId, AllFairyIds) of
            true ->
                case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
                    false ->     %1. 未激活
                        #fairy_stage_cfg{cost = Cost} = data_fairy:get_fairy_stage(FairyId, 0),
                        Info = data_fairy:get_fairy_info(FairyId),
                        case lib_goods_api:cost_object_list_with_check(PS, Cost, fairy_activation, "") of
                            {true, Player1} ->
                                Stage = ?STAGE_INIT,
                                {NewAttr, NewCombat} = get_fairy_id_attr(FairyId, Stage, ?LEVEL_INIT),
                                #fairy_stage_cfg{skill_list = SkillList} = data_fairy:get_fairy_stage(FairyId, Stage),
                                FairySub =
                                    #fairy_sub{
                                        fairy_id = FairyId,
                                        stage = Stage,
                                        level = ?LEVEL_INIT,
                                        exp = ?EXP_INIT,
                                        combat = NewCombat,
                                        skill_list = SkillList,
                                        attr_list = NewAttr},
                                NewFairyList = lists:keystore(FairyId, #fairy_sub.fairy_id, FairyList, FairySub),
                                NewAllAttr = get_all_fairy_attr(NewFairyList),
                                %%    计算主动技能战力
                                ActivePower = get_active_skill_power(NewFairyList),
                                NewFairy = Fairy#fairy{battle_id = FairyId, attr = NewAllAttr, power = ActivePower, fairy_list = NewFairyList},
                                Player2 = Player1#player_status{fairy = NewFairy},
                                Player3 = broadcast_to_scene(FairyId, Player2),
                                lib_achievement_api:spirit_figure_event(Player3, erlang:length(NewFairyList)),
                                %%  记录日志
                                lib_log_api:log_fairy_stage(RoleId, FairyId, 0, Stage, Cost),
                                sql_replace_fairy(RoleId, FairyId, NewAllAttr),
                                sql_replace_fairy_sub(RoleId, FairyId, Stage, ?LEVEL_INIT, ?EXP_INIT, NewCombat, SkillList, NewAttr),
                                %%  更新总属性, 总战力
                                Player4 = lib_player:count_player_attribute(Player3),
                                lib_player:send_attribute_change_notify(Player4, ?NOTIFY_ATTR),
                                lib_chat:send_TV({all}, ?MOD_FAIRY, 1, [Figure#figure.name, Info#fairy_info_cfg.name]),
                                {ok, Player4};
                            {false, ErrorCode1, NewPlayer1} ->
                                {ErrorCode1, NewPlayer1}
                        end;
                    #fairy_sub{stage = Stage, level = Level, exp = Exp} = FairySub ->  %2. 已激活
                        NewStage = Stage + 1,
                        case data_fairy:get_fairy_stage(FairyId, NewStage) of
                            [] ->   % 已达阶级上限
                                {?ERRCODE(err148_stage_limit), PS};
                            #fairy_stage_cfg{skill_list = SkillList} ->
                                #fairy_stage_cfg{cost = Cost} = data_fairy:get_fairy_stage(FairyId, NewStage),
                                case lib_goods_api:cost_object_list_with_check(PS, Cost, fairy_stage_up, "") of
                                    {true, Player1} ->
                                        {NewAttr, NewCombat} = get_fairy_id_attr(FairyId, NewStage, Level),
                                        NewFairySub =
                                            FairySub#fairy_sub{
                                                fairy_id = FairyId,
                                                stage = NewStage,
                                                combat = NewCombat,
                                                skill_list = SkillList,
                                                attr_list = NewAttr},
                                        NewFairyList = lists:keyreplace(FairyId, #fairy_sub.fairy_id, FairyList, NewFairySub),
                                        NewAllAttr = get_all_fairy_attr(NewFairyList),
                                        NewPower = get_active_skill_power(NewFairyList),
                                        NewFairy = Fairy#fairy{battle_id = FairyId, attr = NewAllAttr, power = NewPower, fairy_list = NewFairyList},
                                        Player2 = Player1#player_status{fairy = NewFairy},
                                        Player3 = broadcast_to_scene(FairyId, Player2),
                                        Fun = fun(#fairy_sub{stage = TemStage}, Acc) ->
                                            case lists:keyfind(TemStage, 1, Acc) of
                                                {TemStage, TemNum} -> lists:keystore(TemStage, 1, Acc, {Stage, TemNum+1});
                                                _ -> lists:keystore(TemStage, 1, Acc, {Stage, 1})
                                            end
                                        end,
                                        AchivList = lists:foldl(Fun, [], NewFairyList),
                                        lib_achievement_api:spirit_stage_event(Player3, AchivList),
                                        %%  记录日志
                                        lib_log_api:log_fairy_stage(RoleId, FairyId, Stage, NewStage, Cost),
                                        sql_replace_fairy(RoleId, FairyId, NewAllAttr),
                                        sql_replace_fairy_sub(RoleId, FairyId, NewStage, Level, Exp, NewCombat, SkillList, NewAttr),
                                        %%  更新总属性, 总战力
                                        Player4 = lib_player:count_player_attribute(Player3),
                                        lib_player:send_attribute_change_notify(Player4, ?NOTIFY_ATTR),
                                        {ok, Player4};
                                    {false, ErrorCode1, NewPlayer1} ->
                                        {ErrorCode1, NewPlayer1}
                                end
                        end
                end;
            false ->
                {?ERRCODE(err148_not_exist_fairy), PS}
        end,
    case is_integer(ErrCode) of
        true ->
            ?PRINT("14803 ErrCode:~w~n", [[ErrCode]]),
            lib_server_send:send_to_sid(Sid, pt_148, 14800, [ErrCode]);
        false ->
            NewFairyStage = lib_fairy:get_fairy_stage(NewPlayer, FairyId),
            NewFairyAttr = lib_fairy:get_fairy_attr(NewPlayer, FairyId),
            ?PRINT("14803 FairyId, NewFairyStage, NewFairyAttr:~w~n", [[FairyId, NewFairyStage, NewFairyAttr]]),
            lib_server_send:send_to_sid(Sid, pt_148, 14803, [?SUCCESS, FairyId, NewFairyStage, NewFairyAttr])
    end,
    NewPlayer.


%% 精灵升级
level_up(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    AllFairyIds = data_fairy:get_all_fairy_id(),
    case lists:member(FairyId, AllFairyIds) of
        true ->
            case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
                false ->     %1. 未激活
                    {false, ?ERRCODE(err148_fairy_not_active)};
                #fairy_sub{level = Level} ->      %2. 已激活
                    NewLevel = Level + 1,
                    case data_fairy:get_fairy_level(FairyId, NewLevel) of
                        [] ->   % 已达等级上限
                            {false, ?ERRCODE(err148_level_limit)};
                        _ ->
                            AllLevGoods = data_fairy:get_all_lev_goods(),
                            NewPlayer = level_up_help(FairyId, AllLevGoods, PS),
                            {ok, NewPlayer}
                    end
            end;
        false ->
            {false, ?ERRCODE(err148_not_exist_fairy)}
    end.

%%   精灵升级
level_up_help(_FairyId, [], Player) -> Player;
level_up_help(FairyId, [GoodsId | GoodsList], Player) ->
    #player_status{sid = Sid, id = RoleId, fairy = Fairy = #fairy{fairy_list = FairyList}} = Player,
    FairySub = lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList),
    #fairy_sub{exp = Exp, level = Level, stage = Stage, skill_list = SkillList} = FairySub,
    #fairy_level_cfg{exp = MaxExp} = data_fairy:get_fairy_level(FairyId, Level),
    GoodsExp = data_fairy:get_fairy_prop(GoodsId),
    [{_GoodsId, OwnNum}] = lib_goods_api:get_goods_num(Player, [GoodsId]),
    {_ErrCode, NewPlayer} =
        case OwnNum > 0 of
            true ->
                NeedExp = MaxExp - Exp,     % 升级所需的消耗数量
                {RealCostNum, ExpPlus} = count_fairy_level(Exp, OwnNum, GoodsExp, NeedExp, 0, 0),
                ?PRINT("========RealCostNum, ExpPlus ,FairyId, Level, Exp, ExpPlus~w~n",[[RealCostNum, ExpPlus, FairyId, Level, Exp, ExpPlus]]),
                {NewLevel, NewExp} = count_fairy_level_helper(FairyId, Level, Exp, ExpPlus),
                ?PRINT("++++++NewLevel, NewExp~w~n",[[NewLevel, NewExp]]),
                Cost = [{?TYPE_GOODS, GoodsId, RealCostNum}],
                case lib_goods_api:cost_object_list_with_check(Player, Cost, fairy_level_up, "") of
                    {true, Player1} ->            % 物品满足条件扣除
                        {NewAttr, NewCombat} = get_fairy_id_attr(FairyId, Stage, NewLevel),
                        NewFairySub =
                            FairySub#fairy_sub{
                                fairy_id = FairyId,
                                level = NewLevel,
                                exp = NewExp,
                                combat = NewCombat,
                                attr_list = NewAttr},
                        ?PRINT("level_up_help NeedExp , MaxExp, Exp, RealCostNum, ExpPlus, NewLevel, NewExp:~w~n",[[NeedExp ,MaxExp, Exp,RealCostNum, ExpPlus, NewLevel, NewExp]]),
                        NewFairyList = lists:keyreplace(FairyId, #fairy_sub.fairy_id, FairyList, NewFairySub),
                        NewAllAttr = get_all_fairy_attr(NewFairyList),
                        NewFairy = Fairy#fairy{battle_id = FairyId, attr = NewAllAttr, fairy_list = NewFairyList},
                        Player2 = Player1#player_status{fairy = NewFairy},
                        %%  记录日志
                        lib_log_api:log_fairy_level(RoleId, FairyId, Level, Exp, NewLevel, NewExp, Cost),
                        sql_replace_fairy(RoleId, FairyId, NewAllAttr),
                        sql_replace_fairy_sub(RoleId, FairyId, Stage, NewLevel, NewExp, NewCombat, SkillList, NewAttr),
                        %%  更新总属性, 总战力
                        Player3 = lib_player:count_player_attribute(Player2),
                        lib_player:send_attribute_change_notify(Player3, ?NOTIFY_ATTR),
                        lib_server_send:send_to_sid(Sid, pt_148, 14804, [?SUCCESS, FairyId, NewLevel, NewExp, NewAttr]),
                        {ok, Player3};
                    {false, 1003, NewPlayerTmp} ->     % 物品不足
                        {?ERRCODE(err160_not_enough_cost), NewPlayerTmp};
                    {false, ErrorCode, NewPlayerTmp} -> {ErrorCode, NewPlayerTmp}
                end;
            false ->
                {?ERRCODE(err160_not_enough_cost), Player}
        end,

    NLevel = get_fairy_level(NewPlayer, FairyId),
    ?PRINT("--------Level, NLevel :~p ~p~n",[Level, NLevel]),
%%     循环判断
    case Level =/= NLevel of    % 判断是否升级
        true ->   % 当已经升级
            NewPlayer;
        false ->  % 当没有升级
            level_up_help(FairyId, GoodsList, NewPlayer)
    end.

%% 升级计算
count_fairy_level(Blessing, OwnNum, Exp, NeedCostNum, RealCostNum, BlessingPlus) ->
    ?PRINT("Blessing, OwnNum, Exp, NeedCostNum, RealCostNum, BlessingPlus:~w~n",[[Blessing, OwnNum, Exp, NeedCostNum, RealCostNum, BlessingPlus]]),
    NewBlessingPlus = BlessingPlus + Exp,  % 新增长的经验值
    NewRealCostNum = RealCostNum + 1,      % 实际需要的数量
    NewOwnNum = OwnNum - 1,                % 拥有的数量
    case NewOwnNum > 0 of
        true ->
            case NewBlessingPlus >= NeedCostNum of
                true ->
                    {NewRealCostNum, NewBlessingPlus};
                false ->
                    count_fairy_level(Blessing, NewOwnNum, Exp, NeedCostNum, NewRealCostNum, NewBlessingPlus)
            end;
        false ->
            {NewRealCostNum, NewBlessingPlus}
    end.

%% 计算升级
count_fairy_level_helper(FairyId, Level, Exp, ExpPlus) ->
%    ?PRINT("FairyId~p, Level~p, Exp~p, ExpPlus:~p~n", [FairyId, Level, Exp, ExpPlus]),
    case data_fairy:get_fairy_level(FairyId, Level) of
        #fairy_level_cfg{exp = MaxExp} when MaxExp > 0 ->
            case Exp + ExpPlus >= MaxExp of
                true ->
                    ?PRINT("Exp + ExpPlus  MaxExp:~w~n", [[Exp, ExpPlus, MaxExp]]),
                    NewLevel = Level + 1,
                    NewExpPlus = Exp + ExpPlus - MaxExp,
                    count_fairy_level_helper(FairyId, NewLevel, 0, NewExpPlus);
                false ->
                    ?PRINT("Exp + ExpPlus,MaxExp:~w~n", [[Exp, ExpPlus, MaxExp]]),
                    {Level, Exp + ExpPlus}
            end;
        _ ->
            {Level, Exp + ExpPlus}
    end.


%% 获取精灵id属性  总属性 = 阶级属性 + 技能属性 + 等级属性
get_fairy_id_attr(FairyId, Stage, Level) ->
    #fairy_stage_cfg{attr = StageAttr, skill_list = SkillList} = data_fairy:get_fairy_stage(FairyId, Stage),
    FairyLevelCfg = case data_fairy:get_fairy_level(FairyId, Level) of
        [] -> #fairy_level_cfg{};
        Cfg -> Cfg
    end,
    #fairy_level_cfg{attr = LevelAttr} = FairyLevelCfg,
    %% 计算功能被动技能的属性
    % DivSkillIds = lib_skill_api:divide_passive_skill(SkillList),
    SkillLvList = lists:map(fun(SKId) -> {SKId, 1} end, SkillList),
    SkillAttr = lib_skill:get_passive_skill_attr(SkillLvList),
    AttrList = util:combine_list(StageAttr ++ LevelAttr ++ SkillAttr),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    {NewAttr, NewCombat}.

%% 计算主动技能战力
get_active_skill_power(NewFairyList) ->
    F = fun(FairyListTmp, SkillTmp) ->
        #fairy_sub{skill_list = SkillList} = FairyListTmp,
        SkillTmp ++ SkillList
        end,
    AllSkillList = lists:foldl(F, [], NewFairyList),
    F1 = fun(SkillId, PowerTmp) ->
        case data_skill:get(SkillId, 1) of
            #skill{type = _Type, lv_data = #skill_lv{power = SkPower}}
            %%   when Type == ?SKILL_TYPE_ACTIVE
                ->
                SkPower + PowerTmp;
            _ ->
                PowerTmp
        end
         end,
    Power = lists:foldl(F1, 0, AllSkillList),
    Power.

%%  场景广播
broadcast_to_scene(FairyId, Player) ->
    #player_status{id = RoleId, scene = Sid, scene_pool_id = PoolId,
        copy_id = CopyId, x = X, y = Y, figure = Figure, fairy = #fairy{fairy_list=FairyList, battle_id=BattleId}} = Player,
    #figure{mount_figure = MountFigure} = Figure,
    %% 更新角色的figure_id
    FairyInfo = data_fairy:get_fairy_info(FairyId),
    FigureId = FairyInfo#fairy_info_cfg.figure_id,

    NewMountFigure = lists:keystore(6, 1, MountFigure, {6, FigureId, 0}),
    NewFigure = Figure#figure{mount_figure = NewMountFigure},

    lib_role:update_role_show(RoleId, [{mount_figure, NewMountFigure}]),
    SkillList = get_fairy_skill_list(Player, FairyId),
    %% 同步新解锁的被动技能到玩家场景
    PassiveSkills = lib_skill_api:divide_passive_skill(SkillList),
    case lists:keyfind(BattleId, #fairy_sub.fairy_id, FairyList) of
        false -> SceneTrainKv = [];
        #fairy_sub{attr_list=Attr} ->
            AttrRecord = lib_player_attr:to_attr_record(Attr),
            SceneTrainKv = lib_player:calc_scene_obj_kvlist(Player, ?BATTLE_SIGN_FAIRY, [{scene_train_attr, {?BATTLE_SIGN_FAIRY, AttrRecord}}])
    end,
    case PassiveSkills =/= [] orelse FairyId =/= [] of
        true ->
            mod_scene_agent:update(Player, SceneTrainKv++[{passive_skill, PassiveSkills}, {mount_figure, {6, FigureId, 0}}]);
        false -> 
            mod_scene_agent:update(Player, SceneTrainKv)
    end,
    {ok, BinData} = pt_148:write(14806, [RoleId, FigureId]),
    ?PRINT("[RoleId, FigureId]:~w~n", [[RoleId, FigureId]]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
    NewPlayer = Player#player_status{figure = NewFigure},
    NewPlayer2 = lib_player:update_scene_train_obj(SceneTrainKv, NewPlayer),
    NewPlayer2.

%% 更新角色的 figure
update_role_show(RoleId, Figure, {TypeId, FigureId}) ->
    #figure{mount_figure = MountFigure} = Figure,
    NewMountFigure = lists:keystore(TypeId, 1, MountFigure, {TypeId, FigureId, 0}),
    lib_role:update_role_show(RoleId, [{mount_figure, NewMountFigure}]),
    Figure#figure{mount_figure = NewMountFigure}.


%% 获取被动技能
get_all_passive_skill_attr(PS) ->
    #player_status{fairy = Fairy} =PS,
    #fairy{fairy_list = FairyList } =Fairy,
    AllSkill = get_all_fairy_skill(FairyList),
    % DivSkillIds = lib_skill_api:divide_passive_skill(AllSkill),
    % SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_FAIRY, DivSkillIds),
    SkillLvList = lists:map(fun(SKId) -> {SKId, 1} end, AllSkill),
    SkillAttr = lib_skill:get_passive_skill_attr(SkillLvList),
    SkillAttr.

%% 获取精灵的总属性
get_all_fairy_attr(NewFairyList) ->
    F = fun(FairyListTmp, AttrTmp) ->
        #fairy_sub{attr_list = AttrList} = FairyListTmp,
        AttrTmp ++ AttrList
        end,
    NewAttr = lists:foldl(F, [], NewFairyList),
    util:combine_list(NewAttr).

%% 获取精灵的总技能
get_all_fairy_skill(NewFairyList) ->
    F = fun(FairyListTmp, AttrTmp) ->
        #fairy_sub{skill_list = SkillList} = FairyListTmp,
        AttrTmp ++ SkillList
        end,
    lists:foldl(F, [], NewFairyList).


%% 获取精灵的阶级
get_fairy_stage(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false -> 0;
        TmpFairy -> TmpFairy#fairy_sub.stage
    end.


%% 获取精灵的等级
get_fairy_level(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false -> 0;
        TmpFairy -> TmpFairy#fairy_sub.level
    end.

%% 获取精灵的经验
get_fairy_exp(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false -> 0;
        TmpFairy -> TmpFairy#fairy_sub.exp
    end.

%% 获取精灵的属性
get_fairy_attr(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false -> [];
        TmpFairy -> TmpFairy#fairy_sub.attr_list
    end.

%% 获取技能列表
get_fairy_skill_list(PS, FairyId) ->
    #player_status{fairy = Fairy} = PS,
    #fairy{fairy_list = FairyList} = Fairy,
    case lists:keyfind(FairyId, #fairy_sub.fairy_id, FairyList) of
        false -> [];
        TmpFairy -> TmpFairy#fairy_sub.skill_list
    end.


%% 检查技能是否存在
check_skill_has_learn(Player, SkillId) ->
    #player_status{fairy = Fairy} = Player,
    AllFairy = get_all_fairy_skill(Fairy#fairy.fairy_list),
    lists:member(SkillId, AllFairy).


%% 获取精灵战力
get_fairy_all_power(Player) ->
    #player_status{fairy = Fairy} = Player,
    #fairy{attr = FairyAttr, power = FairyPower} = Fairy,
    AttrList = lib_player_attr:add_attr(list, [FairyAttr]),
    NewTotalAttr = lib_player_attr:to_attr_record(AttrList),
    AttrPower = lib_player:calc_all_power(NewTotalAttr),
    AttrPower + FairyPower.



%% ---------------------------------- db函数 -----------------------------------

sql_select_fairy(RoleId) ->
    Sql = io_lib:format(?sql_select_fairy, [RoleId]),
    db:get_row(Sql).

sql_select_fairy_battle_id(RoleId) ->
    Sql = io_lib:format(?sql_select_fairy_battle_id, [RoleId]),
    db:get_one(Sql).

sql_replace_fairy(RoleId, BattleId, FairyAttr) ->
    FairyAttrBin = util:term_to_bitstring(FairyAttr),
    Sql = io_lib:format(?sql_replace_fairy, [RoleId, BattleId, FairyAttrBin]),
    db:execute(Sql).

sql_update_fairy_battle_id(BattleId, RoleId) ->
    Sql = io_lib:format(?sql_update_fairy_battle_id, [BattleId, RoleId]),
    db:execute(Sql).


sql_select_all_fairy_sub(RoleId) ->
    Sql = io_lib:format(?sql_select_all_fairy_sub, [RoleId]),
    db:get_all(Sql).


sql_replace_fairy_sub(RoleId, FairyId, Stage, Level, Exp, Combat, SkillList, AttrList) ->
    SkillListBin = util:term_to_bitstring(SkillList),
    AttrListBin = util:term_to_bitstring(AttrList),
    Sql = io_lib:format(?sql_replace_fairy_sub, [RoleId, FairyId, Stage, Level, Exp, Combat, SkillListBin, AttrListBin]),
    db:execute(Sql).


sql_update_fairy_sub_lev(RoleId, FairyId) ->
    Sql = io_lib:format(?sql_update_fairy_sub_lev, [RoleId, FairyId]),
    db:execute(Sql).





















