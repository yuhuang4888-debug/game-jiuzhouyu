%% ---------------------------------------------------------------------------
%% @doc lib_companion

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/4/29
%% @deprecated  伙伴模块，角色进程处理
%% ---------------------------------------------------------------------------
-module(lib_companion).

%% API
-compile([export_all]).

-include("common.hrl").
-include("server.hrl").
-include("companion.hrl").
-include("errcode.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("scene.hrl").
-include("attr.hrl").
-include("skill.hrl").
-include("goods.hrl").

login(Ps) ->
    #player_status{id = RoleId, figure = Figure} = Ps,
    List = db:get_all(io_lib:format(?sql_select_companion, [RoleId])),
    F = fun([CompanionId, Stage, Star, BiographyBin, Blessing, IsFight, TrainNum]) ->
        #companion_item{
            companion_id = CompanionId,
            star = Star, stage = Stage,
            biography = util:bitstring_to_term(BiographyBin),
            blessing = Blessing,
            is_fight = IsFight,
            train_num = TrainNum
        }
        end,
    CompanionList = lists:map(F, List),
    StatusCompanion = lib_companion_util:calc_status_companion(#status_companion{companion_list = CompanionList}),
    NewFigure = load_figure(Figure, StatusCompanion#status_companion.fight_id),
    Ps#player_status{figure = NewFigure, status_companion = StatusCompanion}.


load_figure(Figure, 0) -> Figure;
load_figure(Figure, FightId) ->
    #base_companion{figure_id = FigureId}= data_companion:get_companion(FightId),
    #figure{mount_figure = MountF, mount_figure_ride = MountFRide} = Figure,
    NewMountF = lists:keystore(?FigureType, 1, MountF, {?FigureType, FigureId}),
    NewMountFRide = lists:keystore(?FigureType, 1, MountFRide, {?FigureType, 1}),
    Figure#figure{mount_figure = NewMountF, mount_figure_ride = NewMountFRide}.

load_train_obj(TrainObj, 0) -> TrainObj;
load_train_obj(TrainObj, _) ->
    SceneTrainObj = #scene_train_object{att_sign = ?BATTLE_SIGN_COMPANION, battle_attr = #battle_attr{}},
    maps:put(?BATTLE_SIGN_COMPANION, SceneTrainObj, TrainObj).

load_mount_figure(RoleId) ->
    Sql = io_lib:format(<<"select `companion_id` from `player_companion` where `role_id` = ~p and `is_fight` = 1 limit 1">>, [RoleId]),
    case db:get_one(Sql) of
        null -> [];
        CompanionId ->
            case data_companion:get_companion(CompanionId) of
                #base_companion{figure_id = FigureId} ->
                    [{?FigureType, FigureId, 0}];
                _ -> []
            end
    end .

%% 临时激活默认伙伴
active_default_companion_tmp(Ps, DunId) ->
    CompanionId = ?DEFAULT_COMPANION_ID,
    #player_status{status_companion = StatusCompanion, id = RoleId} = Ps,
    #status_companion{companion_list = CompanionList, is_tmp = IsTmp} = StatusCompanion,
    case lib_companion_util:check_companion(CompanionId, StatusCompanion, [check_no_active]) of
        true ->
            case IsTmp == ?NotTmp andalso DunId == ?TMPACTIVEDUNID of
                true ->
                    Companion = lib_companion_util:logic_init_companion(CompanionId),
                    NewCompanionList = lists:keystore(CompanionId, #companion_item.companion_id, CompanionList, Companion),
                    StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList, is_tmp = ?IsTmp},
                    NewStatusCompanion = lib_companion_util:calc_status_companion(StatusCompanionTmp),
                    %% 不加属性
                    LastPs = Ps#player_status{status_companion = NewStatusCompanion#status_companion{sum_attr = []}},
                    %% 处理下train_obj
                    SceneTrainObj = #scene_train_object{att_sign = ?BATTLE_SIGN_COMPANION, battle_attr = #battle_attr{}},
                    mod_scene_agent:update(LastPs, [{scene_train_object, SceneTrainObj}]),
                    LastPs1 = lib_player:update_scene_train_obj([{scene_train_object, SceneTrainObj}], LastPs),
                    Combat = lib_companion_util:get_companion_active_power(CompanionId, LastPs1),
                    lib_server_send:send_to_uid(LastPs1#player_status.id, pt_142, 14204, [?SUCCESS, CompanionId, Combat]),
                    pp_companion:do_handle(14202, LastPs1, []),
                    %% 不能通过广播发送，由于该函数是切场景前调用的
                    FigureId = lib_companion_util:get_figure_id(CompanionId),
                    {ok, BinData} = pt_142:write(14200, [?FigureType, RoleId, FigureId]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    {ok, LastPs1};
                _ -> {ok, Ps}
            end;
        _ ->
            {ok, Ps}
    end.

%% 取消临时激活
cancel_default_companion_tmp(Ps) ->
    CompanionId = ?DEFAULT_COMPANION_ID,
    #player_status{status_companion = StatusCompanion, train_object = TrainObject} = Ps,
    #status_companion{companion_list = CompanionList, is_tmp = IsTmp} = StatusCompanion,
    case IsTmp of
        ?IsTmp ->
            NewCompanionList = lists:keydelete(CompanionId, #companion_item.companion_id, CompanionList),
            StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList, is_tmp = ?NotTmp},
            NewStatusCompanion = lib_companion_util:calc_status_companion(StatusCompanionTmp),
            NewPs = Ps#player_status{status_companion = NewStatusCompanion},
            LastPs = lib_player:count_player_attribute(NewPs),
            lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
            mod_scene_agent:update(LastPs, [{battle_attr, LastPs#player_status.battle_attr}]),
            pp_companion:do_handle(14202, LastPs, []),
            {ok, LastPs#player_status{train_object = maps:remove(?BATTLE_SIGN_COMPANION, TrainObject)}};
        _ -> {ok, Ps}
    end.

%% 伙伴出战
fight_companion(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion, id = RoleId, figure = Figure} = Ps,
    CheckList = [check_active, check_fight],
    case lib_companion_util:check_companion_return_item(CompanionId, StatusCompanion, CheckList) of
        {true, ComItem} ->
            Fun = fun() -> fight_companion_core(RoleId, ComItem, StatusCompanion) end,
            case db:transaction(Fun) of
                {true, NewStatusCompanionTmp} ->
                    NewFigure = load_figure(Figure, CompanionId),
                    NewStatusCompanion = lib_companion_util:calc_status_companion(NewStatusCompanionTmp),
                    NewPsTmp = Ps#player_status{status_companion = NewStatusCompanion, figure = NewFigure},
                    LastPsTmp = lib_player:count_player_attribute(NewPsTmp),
                    %% 发送操作成功协议
                    LastPs = lib_companion_event:combat_change(LastPsTmp),
                    %% 广播场景
                    broadcast_to_scene(Ps, CompanionId),
                    SceneTrainObj = #scene_train_object{att_sign = ?BATTLE_SIGN_COMPANION, battle_attr = #battle_attr{}},
                    lib_companion_event:fight_companion(LastPs, CompanionId, StatusCompanion, SceneTrainObj),
                    LastPs1 = lib_player:update_scene_train_obj([{scene_train_object, SceneTrainObj}], LastPs),
                    {true, LastPs1};
                _Err ->
                    ?ERR("fight_companion err: ~p~n", [_Err]),
                    {false, ?FAIL}
            end;
        Error -> Error
    end.


fight_companion_core(RoleId, Companion, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    %% 卸下之前出战的
    case lists:keyfind(?IS_FIGHT, #companion_item.is_fight, CompanionList) of
        false -> CompanionListTmp = CompanionList, ReplaceParam1 = [];
        OldFightCompanion ->
            #companion_item{companion_id = OldFightCompanionId} = OldFightCompanion,
            UnFightCompanion = OldFightCompanion#companion_item{is_fight = ?NOT_FIGHT},
            ReplaceParam1 = [get_companion_replace_param(RoleId, UnFightCompanion)],
            CompanionListTmp = lists:keystore(OldFightCompanionId, #companion_item.companion_id, CompanionList, UnFightCompanion)
    end,
    NewFightCompanion = Companion#companion_item{is_fight = ?IS_FIGHT},
    #companion_item{companion_id = NewFightCompanionId, skill = FightSkill} = NewFightCompanion,
    ReplaceParam = [get_companion_replace_param(RoleId, NewFightCompanion)|ReplaceParam1],
    Sql = usql:replace(player_companion, [role_id, companion_id, stage, star, biography, blessing, is_fight, train_num], ReplaceParam),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    NewCompanionList = lists:keystore(NewFightCompanionId, #companion_item.companion_id, CompanionListTmp, NewFightCompanion),
    NewStatusCompanion = StatusCompanion#status_companion{companion_list = NewCompanionList, skill_list = FightSkill, fight_id = NewFightCompanionId},
    {true, NewStatusCompanion}.


%% 场景广播
broadcast_to_scene(Ps, CompanionId) ->
    #player_status{ id = RoleId, scene = Sid, scene_pool_id = PoolId,
        copy_id = CopyId, x = X, y = Y} = Ps,
    FigureId = lib_companion_util:get_figure_id(CompanionId),
    {ok, BinData} = pt_142:write(14200, [?FigureType, RoleId, FigureId]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).


%% 激活伙伴
active_companion(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion} = Ps,
    [SpecailCompanionGold|_] = ?SPECIAL_COMPANION_ID,
    DefaultCompanionId = ?DEFAULT_COMPANION_ID,
    case lib_companion_util:check_companion(CompanionId, StatusCompanion, [check_no_active]) of
        true ->
            case CompanionId of
                SpecailCompanionGold ->
                    %% 特殊伙伴特殊处理
                    active_special_companion(Ps, CompanionId);
                DefaultCompanionId ->
                    active_default_companion(Ps);
                _ ->
                    active_normal_companion(Ps, CompanionId)
            end;
        Error -> Error
    end.

%% 激活默认伙伴
active_default_companion(Ps) ->
    CompanionId = ?DEFAULT_COMPANION_ID,
    #player_status{status_companion = StatusCompanion, id = RoleId, tid = Tid, figure = Figure} = Ps,
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    NeedFinishIds = ?OPENFUNNEEDTASKS,
%%    F = fun(NeedId, Flag) -> Flag andalso mod_task:is_finish_task_id(Tid, NeedId) end,
%%    IsSatisfy = lists:foldl(F, true, NeedFinishIds),
    IsSatisfy = mod_task:is_finish_task_ids(Tid, NeedFinishIds),
    if
        not IsSatisfy -> {false, ?ERRCODE(err142_no_finish_task)};
        true ->
            Companion = lib_companion_util:logic_init_companion(CompanionId),
            NewCompanionList = lists:keystore(CompanionId, #companion_item.companion_id, CompanionList, Companion),
            StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList},
            NewStatusCompanion = lib_companion_util:calc_status_companion(StatusCompanionTmp),
            save_companion(RoleId, Companion),
            NewFigure = load_figure(Figure, CompanionId),
            NewPs = Ps#player_status{status_companion = NewStatusCompanion, figure = NewFigure},
            LastPsTmp = lib_player:count_player_attribute(NewPs),
            LastPs = lib_companion_event:combat_change(LastPsTmp),
            lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
            SceneTrainObj = #scene_train_object{att_sign = ?BATTLE_SIGN_COMPANION, battle_attr = #battle_attr{}},
            mod_scene_agent:update(LastPs, [
                {battle_attr, LastPs#player_status.battle_attr},
                {scene_train_object, SceneTrainObj},
                {back_decora_figure, NewFigure#figure.mount_figure},
                {back_decora_figure_ride, NewFigure#figure.mount_figure_ride}
            ]),
            LastPs1 = lib_player:update_scene_train_obj([{scene_train_object, SceneTrainObj}], LastPs),
            Combat = lib_companion_util:get_companion_active_power(CompanionId, LastPs1),
            lib_server_send:send_to_uid(RoleId, pt_142, 14204, [?SUCCESS, CompanionId, Combat]),
            pp_companion:do_handle(14202, LastPs1, []),
            broadcast_to_scene(LastPs1, CompanionId),
            {true, LastPs1}
    end.

%% 特殊伙伴特殊激活处理
active_special_companion(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion, id = RoleId, figure = Figure} = Ps,
    #figure{name = Name} = Figure,
    TotalGold = lib_recharge_api:get_total(RoleId),
    [SpecailCompanionGold|_] = ?SPECIAL_COMPANION_GOLD,
    case TotalGold >= SpecailCompanionGold of
        false -> {false, ?ERRCODE(err142_recharge_not_enough)};
        true ->
            Fun = fun() -> active_companion_core(RoleId, CompanionId, StatusCompanion) end,
            case db:transaction(Fun) of
                {true, NewStatusCompanion} ->
                    #base_companion{name = CName} = data_companion:get_companion(CompanionId),
                    NewFigure = load_figure(Figure, CompanionId),
                    NewPsTmp = Ps#player_status{status_companion = NewStatusCompanion, figure = NewFigure},
                    broadcast_to_scene(NewPsTmp, CompanionId),
                    LastPsTmp = lib_player:count_player_attribute(NewPsTmp),
                    LastPsTmp1 = lib_companion_event:combat_change(LastPsTmp),
                    LastPs = lib_companion_event:active_event(LastPsTmp1, CompanionId),
                    lib_log_api:log_companion_stage(RoleId,CompanionId,0,0,0,?MIN_STAGE_,?MIN_STAR_,0, []),
                    lib_chat:send_TV({all}, ?MOD_COMPANION, 1, [Name, CName]),
                    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                    Combat = lib_companion_util:get_companion_active_power(CompanionId, LastPs),
                    mod_scene_agent:update(LastPs, [{back_decora_figure, NewFigure#figure.mount_figure}, {back_decora_figure_ride, NewFigure#figure.mount_figure_ride}]),
                    lib_server_send:send_to_uid(RoleId, pt_142, 14204, [?SUCCESS, CompanionId, Combat]),
                    pp_companion:do_handle(14201, LastPs, [CompanionId]),
                    {true, LastPs};
                _Err ->
                    ?ERR("active_companion err: ~p~n", [_Err]),
                    {false, ?FAIL}
            end
    end.

%% 激活通常伙伴
active_normal_companion(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion, id = RoleId, figure = Figure} = Ps,
    #figure{name = Name} = Figure,
    #base_companion{goods_id = GoodsId, goods_num = GoodsNum, name = CName} = data_companion:get_companion(CompanionId),
    Cost = [{?TYPE_GOODS, GoodsId, GoodsNum}],
    case lib_goods_api:cost_object_list_with_check(Ps, Cost, companion_active, "") of
        {true, NewPsTmp1} ->
            Fun = fun() -> active_companion_core(RoleId, CompanionId, StatusCompanion) end,
            case db:transaction(Fun) of
                {true, NewStatusCompanion} ->
                    NewFigure = load_figure(Figure, CompanionId),
                    NewPsTmp = NewPsTmp1#player_status{status_companion = NewStatusCompanion, figure = NewFigure},
                    broadcast_to_scene(NewPsTmp, CompanionId),
                    LastPsTmp = lib_player:count_player_attribute(NewPsTmp),
                    LastPsTmp1 = lib_companion_event:combat_change(LastPsTmp),
                    LastPs = lib_companion_event:active_event(LastPsTmp1, CompanionId),
                    lib_log_api:log_companion_stage(RoleId,CompanionId,0,0,0,?MIN_STAGE_,?MIN_STAR_,0,Cost),
                    lib_chat:send_TV({all}, ?MOD_COMPANION, 1, [Name, CName]),
                    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                    Combat = lib_companion_util:get_companion_active_power(CompanionId, LastPs),
                    mod_scene_agent:update(LastPs, [{back_decora_figure, NewFigure#figure.mount_figure}, {back_decora_figure_ride, NewFigure#figure.mount_figure_ride}]),
                    lib_server_send:send_to_uid(RoleId, pt_142, 14204, [?SUCCESS, CompanionId, Combat]),
                    pp_companion:do_handle(14201, LastPs, [CompanionId]),
                    {true, LastPs};
                _Err ->
                    ?ERR("active_companion err: ~p~n", [_Err]),
                    {false, ?FAIL}
            end;
        {false, ErrorCode, _ErrPs} ->
            {false, ErrorCode}
    end.

active_companion_core(RoleId, CompanionId, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    InitCompanion = lib_companion_util:logic_init_companion(CompanionId),
    ReplaceParam1 = [get_companion_replace_param(RoleId, InitCompanion)],
    %% 取消之前出战的伙伴
    case lists:keyfind(?IS_FIGHT, #companion_item.is_fight, CompanionList) of
        false -> CompanionListTmp = CompanionList, ReplaceParam = ReplaceParam1;
        OldFightCompanion ->
            UnFightCompanion = OldFightCompanion#companion_item{is_fight = ?NOT_FIGHT},
            ReplaceParam = [get_companion_replace_param(RoleId, UnFightCompanion)|ReplaceParam1],
            CompanionListTmp = lists:keystore(UnFightCompanion#companion_item.companion_id, #companion_item.companion_id, CompanionList, UnFightCompanion)
    end,
    Sql = usql:replace(player_companion, [role_id, companion_id, stage, star, biography, blessing, is_fight, train_num], ReplaceParam),
    ?IF(Sql =/= [], db:execute(Sql), skip),
    NewCompanionList = lists:keystore(CompanionId, #companion_item.companion_id, CompanionListTmp, InitCompanion),
    StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList, fight_id = CompanionId},
    NewStatusCompanion = lib_companion_util:calc_status_companion(StatusCompanionTmp),
    {true, NewStatusCompanion}.


%% 消耗材料升阶伙伴
upgrade_star(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion, id = RoleId} = Ps,
    CheckList = [check_active, check_upgrade],
    case lib_companion_util:check_companion_return_item(CompanionId, StatusCompanion, CheckList) of
        {true, Companion} ->
            {Cost, NewCompanion, IsUpgrade} = calc_cost_upgrade(Ps, CompanionId, Companion),
%%            ?PRINT("{Cost, NewCompanion, IsUpgrade} ~p ~n", [{Cost, NewCompanion, IsUpgrade}]),
            [{_, _, CostNum}|_] = Cost,
            if
                CostNum == 0 -> {false, ?GOODS_NOT_ENOUGH};
                true ->
                    case lib_goods_api:cost_object_list_with_check(Ps, Cost, companion_upgrade, "") of
                        {true, NewPsTmp} ->
                            Fun = fun() -> upgrade_star_core(RoleId, NewCompanion, IsUpgrade, StatusCompanion) end,
                            case db:transaction(Fun) of
                                {true, NewStatusCompanion} ->
                                    NewPs = NewPsTmp#player_status{status_companion = NewStatusCompanion},
                                    case IsUpgrade of
                                        true ->     %% 此处角色战力属性才会实际变化
                                            NewPs1 = lib_player:count_player_attribute(NewPs),
                                            LastPsTmp = lib_companion_event:stage_upgrade(NewPs1, CompanionId),
%%                                            pp_companion:do_handle(14201, LastPs, [CompanionId]),
                                            pp_skill:handle(21002, NewPs, []),
                                            mod_scene_agent:update(LastPsTmp, [{battle_attr, LastPsTmp#player_status.battle_attr}]),
                                            lib_player:send_attribute_change_notify(LastPsTmp, ?NOTIFY_ATTR);
                                        false -> LastPsTmp = NewPs
                                    end,
                                    LastPs = lib_companion_event:combat_change(LastPsTmp),
                                    log_companion_stage(RoleId,Companion, NewCompanion, Cost),
                                    #companion_item{stage = NewStage, star = NewStar, blessing = NewBlessing} = NewCompanion,
                                    lib_server_send:send_to_uid(RoleId, pt_142, 14205, [?SUCCESS, CompanionId, NewStage, NewStar, NewBlessing]),
                                    mod_scene_agent:update(LastPs, [{delete_passive_skill, StatusCompanion#status_companion.skill_list}, {passive_skill, NewStatusCompanion#status_companion.skill_list}]),
                                    {true, LastPs};
                                _Err ->
                                    ?ERR("upgrade_star err: ~p~n", [_Err]),
                                    {false, ?FAIL}
                            end;
                        {false, ErrorCode, _ErrPs} ->
                            {false, ErrorCode}
                    end
            end;
        Error -> Error
    end.

%% 计算此次 upgrade_star 所需消耗
%% 根据companion blessing 百分比扣除
%% 返回 {Cost, NewCompanion, IsUpgrade}
calc_cost_upgrade(Ps, CompanionId, Companion) ->
    #companion_item{
        stage = Stage, star = Star,
        blessing = OldBlessing
    } = Companion,
    #base_companion{single_exp = Exp, goods_id = GoodsId} = data_companion:get_companion(CompanionId),
    #base_companion_stage{need_blessing = BlessingTmp} = data_companion:get_companion_stage(CompanionId, Stage, Star),
    NeedAddBless = ?UPGRADE_PERCENT(BlessingTmp),
    [{_, GoodsNum}|_] = lib_goods_api:get_goods_num(Ps, [GoodsId]),
    {CostNum, ActualAddBless} = calc_cost_upgrade_core(Exp, GoodsNum, NeedAddBless),
    CompanionTmp = Companion#companion_item{blessing = OldBlessing + ActualAddBless},
    {NewCompanion, IsUpgrade} = calc_companion_stage(CompanionTmp, BlessingTmp, false),
    {[{?TYPE_GOODS, GoodsId, CostNum}], NewCompanion, IsUpgrade}.

%% @param Exp 每个物品提供祝福值
%% @param GoodsNum 拥有物品数量
%% @param NeedAddBless 需要添加的祝福值
%% @return {CostNum, ActualAddBless} 消耗了多少物品，实际添加的祝福值
calc_cost_upgrade_core(Exp, GoodsNum, NeedAddBless) ->
    NeedNum = ?IF(NeedAddBless < Exp, 1, round(NeedAddBless / Exp)),
    case NeedNum > GoodsNum of
        true -> {GoodsNum, GoodsNum * Exp};
        false -> {NeedNum, NeedNum * Exp}
    end.

%% 判断当前祝福值是否达到升星条件
%% @param Companion
%% @param UpNeedBlessing 所需升级祝福值
%% @param Status true/false 该函数会递归调用，判断是否改变了
%% @return {NewCompanion, Status(true/false)}
calc_companion_stage(Companion, UpNeedBlessing, Status) ->
    #companion_item{
        companion_id = CompanionId,
        blessing = CurrentBlessing,
        stage = Stage, star = Star
    } = Companion,
    if
        CurrentBlessing < UpNeedBlessing -> {Companion, Status};
        true ->
            NewBlessingTmp = CurrentBlessing - UpNeedBlessing,
            case Star == ?MAX_STAR_ of
                true ->
                    case Stage == ?MAX_STAGE_ of
                        true -> %% 已经是最大等级了（逻辑上不会跑到这）
                            NewBlessing = CurrentBlessing, NewStar = Star, NewStage = Stage;
                        false -> %% 升阶
                            NewBlessing = NewBlessingTmp, NewStar = ?MIN_STAR_, NewStage = Stage + 1
                    end;
                false -> %% 升星
                    NewBlessing = NewBlessingTmp, NewStar = Star + 1, NewStage = Stage
            end,
            NewCompanion = Companion#companion_item{blessing = NewBlessing, star = NewStar, stage = NewStage},
            if
                NewCompanion == Companion ->
                    %% 已经是最大等级了（逻辑上不会跑到这）
                    {Companion, Status};
                true ->
                    case NewStage == ?MAX_STAGE_ andalso NewStar == ?MAX_STAR_ of
                        true ->
                            %% 升到顶级，跳出递归
                            {NewCompanion, true};
                        false ->
                            %% 非顶级，进行尾递归，房子blessing溢出
                            #base_companion_stage{need_blessing = NewNeedBlessing} = data_companion:get_companion_stage(CompanionId, NewStage, NewStar),
                            calc_companion_stage(NewCompanion, NewNeedBlessing, true)
                    end

            end
    end.


%% 升阶伙伴逻辑操作
%% @param NewCompanion 新的伙伴信息
%% @param IsUpgrade 当true时需要重新计算NewCompanion里面的属性技能
upgrade_star_core(RoleId, NewCompanion, IsUpgrade, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    NewCompanionList = lists:keystore(NewCompanion#companion_item.companion_id, #companion_item.companion_id, CompanionList, NewCompanion),
    StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList},
    save_companion(RoleId, NewCompanion),
    %% 判断此次升阶是否有提升等级
    %% 提升了重新计算StatusCompanion属性技能
    NewStatusCompanion =
        case IsUpgrade of
            true -> lib_companion_util:calc_status_companion(StatusCompanionTmp);
            false -> StatusCompanionTmp
        end,
    {true, NewStatusCompanion}.


%% 使用精华道具加成
train_companion(Ps, CompanionId) ->
    #player_status{status_companion = StatusCompanion, id = RoleId} = Ps,
    CheckList = [check_active, check_train],
    case lib_companion_util:check_companion_return_item(CompanionId, StatusCompanion, CheckList) of
        {true, Companion} ->
            {Cost, NewCompanion} = calc_cost_train(Ps, CompanionId, Companion),
            [{_, _, CostNum}|_] = Cost,
            if
                CostNum == 0 -> {false, ?GOODS_NOT_ENOUGH};
                true ->
                    case lib_goods_api:cost_object_list_with_check(Ps, Cost, companion_train, "") of
                        {true, NewPsTmp} ->
                            Fun = fun() -> train_companion_core(RoleId, NewCompanion, StatusCompanion) end,
                            case db:transaction(Fun) of
                                {true, NewStatusCompanion} ->
                                    NewPs = NewPsTmp#player_status{status_companion = NewStatusCompanion},
                                    LastPsTmp = lib_player:count_player_attribute(NewPs),
                                    LastPs = lib_companion_event:combat_change(LastPsTmp),
                                    lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                                    lib_server_send:send_to_uid(RoleId, pt_142, 14206, [?SUCCESS, CompanionId]),
                                    log_companion_train(RoleId, Companion, NewCompanion, Cost),
                                    pp_companion:do_handle(14201, LastPs, [CompanionId]),
                                    {true, LastPs};
                                _Err ->
                                    ?ERR("upgrade_star err: ~p~n", [_Err]),
                                    {false, ?FAIL}
                            end;
                        {false, ErrorCode, _ErrPs} ->
                            {false, ErrorCode}
                    end
            end;
        Error -> Error
    end.


calc_cost_train(Ps, CompanionId, Companion) ->
    #base_companion{train_goods_id = GoodsId, train_limit = LimitNum} = data_companion:get_companion(CompanionId),
    #companion_item{train_num = UseNum} = Companion,
    [{_, GoodsNum}|_] = lib_goods_api:get_goods_num(Ps, [GoodsId]),
    ActualNum = ?IF(UseNum + GoodsNum > LimitNum, LimitNum - UseNum, GoodsNum),
    NewCompanion = Companion#companion_item{train_num = ActualNum + UseNum},
    {[{?TYPE_GOODS, GoodsId, ActualNum}], NewCompanion}.


train_companion_core(RoleId, NewCompanion, StatusCompanion) ->
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    NewCompanionList = lists:keystore(NewCompanion#companion_item.companion_id, #companion_item.companion_id, CompanionList, NewCompanion),
    StatusCompanionTmp = StatusCompanion#status_companion{companion_list = NewCompanionList},
    save_companion(RoleId, NewCompanion),
    NewStatusCompanion = lib_companion_util:calc_status_companion(StatusCompanionTmp),
    {true, NewStatusCompanion}.

%% 激活伙伴传记
%% @return {true, #player_status{}} | {false, ErrCode}
unlock_biog(PS, CompanionId, BiogLv) ->
    #player_status{status_companion = StatusCompanion, id = RoleId} = PS,
    #status_companion{companion_list = CompanionList} = StatusCompanion,
    CheckList = [{check_biog_unlock, BiogLv}, {check_companion_stage_star, BiogLv}],
    case lib_companion_util:check_companion_return_item(CompanionId, StatusCompanion, CheckList) of
        {true, Companion} ->
            % 更新伙伴解锁传记数据
            #companion_item{biography = BiogList} = Companion,
            Companion1 = Companion#companion_item{biography = [BiogLv | BiogList]},
            CompanionList1 = lists:keystore(CompanionId, #companion_item.companion_id, CompanionList, Companion1),
            StatusCompanion1 = StatusCompanion#status_companion{companion_list = CompanionList1},
            StatusCompanion2 = lib_companion_util:calc_status_companion(StatusCompanion1),

            % 入库
            save_companion(RoleId, Companion1),

            % 发放奖励
            RewardList = get_biog_unlock_reward(PS, CompanionId, BiogLv),
            Produce = #produce{type = 'companion_biog', reward = RewardList},
            PS1 = lib_goods_api:send_reward(PS, Produce),

            {true, PS1#player_status{status_companion = StatusCompanion2}};
        Error ->
            Error
    end.

save_companion(RoleId, Companion) when is_record(Companion, companion_item) ->
    #companion_item{
        companion_id = CompanionId
        ,stage = Stage ,star = Star
        ,biography = Biography
        ,blessing = Blessing
        ,is_fight = IsFight ,train_num = TrainNum
    } = Companion,
    BiographyBin = util:term_to_bitstring(Biography),
    Sql = io_lib:format(?sql_replace_companion, [RoleId, CompanionId, Stage, Star, BiographyBin, Blessing, IsFight, TrainNum]),
    db:execute(Sql).

%% 获取批量插入的参数，usql:replace使用
get_companion_replace_param(RoleId, Companion) when is_record(Companion, companion_item) ->
    #companion_item{
        companion_id = CompanionId ,stage = Stage
        ,star = Star ,blessing = Blessing
        ,biography = Biography
        ,is_fight = IsFight ,train_num = TrainNum
    } = Companion,
    BiographyBin = util:term_to_bitstring(Biography),
    [RoleId, CompanionId, Stage, Star, BiographyBin, Blessing, IsFight, TrainNum].


log_companion_stage(RoleId, OldCompanion, NewCompanion, Cost) ->
    #companion_item{companion_id = CompanionId, star = OldStar, stage = OldStage, blessing = OldBlessing} = OldCompanion,
    #companion_item{star = NewStar, stage = NewStage, blessing = NewBlessing} = NewCompanion,
    lib_log_api:log_companion_stage(RoleId,CompanionId,OldStage,OldStar,OldBlessing,NewStage,NewStar,NewBlessing,Cost).


log_companion_train(RoleId, OldCompanion, NewCompanion, Cost) ->
    #companion_item{companion_id = CompanionId, train_num=OldNum} = OldCompanion,
    #companion_item{train_num = NewNum} = NewCompanion,
    #base_companion{train_attr=TAttr} = data_companion:get_companion(CompanionId),
    BAttr = [{AId, AVal * OldNum}||{AId, AVal}<-TAttr],
    AAttr = [{AId, AVal * NewNum}||{AId, AVal}<-TAttr],
    lib_log_api:log_companion_train(RoleId,CompanionId,NewNum,Cost,BAttr,AAttr).


get_companion_active_cnt(PS) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = PS,
    length(CompanionList).

get_companion_active_list(PS) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = PS,
    [CompanionId ||#companion_item{companion_id = CompanionId} <- CompanionList].

get_companion_stage_by_id(PS, PartnerId) ->
    #player_status{status_companion = #status_companion{companion_list = CompanionList}} = PS,
    case lists:keyfind(PartnerId, #companion_item.companion_id, CompanionList) of
        #companion_item{stage = Stage} -> Stage;
        _ -> 0
    end.

%% 获取伙伴传记解锁奖励
get_biog_unlock_reward(_PS, CompanionId, BiogLv) ->
    case data_companion:get_biog_stage_star(CompanionId, BiogLv) of
        [{Stage, Star}] ->
            #base_companion_stage{other = OtherList} = data_companion:get_companion_stage(CompanionId, Stage, Star),
            {_, RewardList} = ulists:keyfind(biog_reward, 1, OtherList, []),
            RewardList;
        _ -> []
    end.