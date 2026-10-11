%%-----------------------------------------------------------------------------
%% @Module  :       lib_godweapon.erl
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2017-10-9
%% @Description:    神兵
%%-----------------------------------------------------------------------------
-module(lib_godweapon).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("godweapon.hrl").
-include("figure.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("common_rank.hrl").
-include("attr.hrl").

-export([
    handle_event/2
    , login/1
    , change_display_status/2
    , use_goods/3
    , upgrade_star/2
    , illusion_figure/3
    , upgrade_lv/3
    , broadcast_to_scene/1
    , active_figure/2
    , count_godweapon_attr/1
    , get_db_god_equip_model/1
    , get_feather_max_times/2
]).

% 等级达到后解锁神兵
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{
        id            = RoleId,
        scene         = Sid,
        scene_pool_id = PoolId,
        copy_id       = CopyId,
        x             = X,
        y             = Y,
        figure        = Figure,
        status_godweapon = OldStGodweapon
    } = Player,
    OpenLv = lib_module:get_open_lv(?MOD_GODWEAPON, 1),
    case Figure#figure.lv == OpenLv orelse (Figure#figure.lv > OpenLv andalso OldStGodweapon#status_godweapon.lv < ?GODWEAPON_MIN_LV) of
        true ->
            {_SkillAttr, SkillIds} = get_godweapon_skill(0),
            PassiveSkills = lib_skill_api:divide_passive_skill(SkillIds),
            case PassiveSkills =/= [] of
                true ->
                    mod_scene_agent:update(Player, [{passive_skill, PassiveSkills}]);
                false -> skip
            end,
            case data_godweapon:get_stage_cfg(?GODWEAPON_MIN_STAGE) of          %% 没激活化形id 0
                #godweapon_stage_cfg{figure_id = FigureId} -> ok;
                _ -> FigureId = 0
            end,
            StatusGodweapon = #status_godweapon{
                lv             = ?GODWEAPON_MIN_LV,
                illusion_id    = ?GODWEAPON_MIN_STAGE,
                figure_list    = [#godweapon_figure{id = ?GODWEAPON_MIN_STAGE}],
                figure_id      = FigureId,
                skills         = SkillIds,
                passive_skills = PassiveSkills,
                display_status = ?GODWEAPON_DISPLAY
            },
            %% 同步到场景玩家并广播
            %?PRINT("~p~n", [FigureId]),
            EquipModel = [{?MODEL_PART_WEAPON, FigureId}],
            mod_scene_agent:update(Player, [{god_equip_model, EquipModel}]),
            {ok, BinData} = pt_169:write(16901, [RoleId, EquipModel]),
            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
            NewFigure = Figure#figure{god_equip_model = EquipModel},
            NewPlayerTmp = count_godweapon_attr(Player#player_status{status_godweapon = StatusGodweapon, figure = NewFigure}),
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            db:execute(io_lib:format(?sql_player_godweapon_replace,
                [RoleId, ?GODWEAPON_MIN_LV, ?GODWEAPON_MIN_STAGE, ?GODWEAPON_DISPLAY])),
            lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player
    end,
    case Figure#figure.lv >= OpenLv of
        true ->
            GTypeIds = data_godweapon:get_feather_ids(),
            F = fun(GTypeId) ->
                case data_godweapon:get_feather_cfg(GTypeId) of
                    #godweapon_feather_cfg{max_times = MaxTimesL} ->
                        TmpL = [Tmp || {LLim, _HLim, _} = Tmp <- MaxTimesL, Figure#figure.lv == LLim],
                        TmpL =/= [];
                    _ -> false
                end
                end,
            IsUSign = lists:any(F, GTypeIds),
            case IsUSign of
                true ->
                    pp_godweapon:handle(16911, NewPlayer, []);
                false -> skip
            end;
        false -> skip
    end,
    {ok, NewPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

get_db_god_equip_model(RoleId) ->
    Sql = io_lib:format(?sql_player_godweapon_select, [RoleId]),
    case db:get_row(Sql) of
        [_, _, IllusionId, _] ->
            case data_godweapon:get_stage_cfg(IllusionId) of          %% 没激活化形id 0
                #godweapon_stage_cfg{figure_id = FigureId} -> ok;
                _ -> FigureId = 0
            end;
        _ -> FigureId = 0
    end,
    [{?MODEL_PART_WEAPON, FigureId}].

login(Player) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    Sql = io_lib:format(?sql_player_godweapon_select, [RoleId]),
    NewPlayer = case db:get_row(Sql) of
                    [Lv, Exp, IllusionId, DisplayStatus] ->
                        {_SkillAttr, SkillIds} = get_godweapon_skill(Lv),
                        GTypeIds = data_godweapon:get_feather_ids(),
                        case CounterList = mod_counter:get_count_offline(RoleId, ?MOD_GOODS, GTypeIds) of
                            [{_GId, _GNum} | _CountL] -> F = fun({GId, GNum}, AttrSum) ->
                                case data_godweapon:get_feather_cfg(GId) of
                                    #godweapon_feather_cfg{attr = Attr} -> skip;
                                    _ -> Attr = []
                                end,
                                case Attr of
                                    [{_Id, _Val} | _AttrL] ->
                                        AttrSum ++ lists:map(fun({AId, AVal}) -> {AId, AVal * GNum} end, Attr);
                                    _ -> AttrSum = []
                                end
                                                             end,
                                BaseAttrL = lists:foldl(F, [], CounterList),
                                BaseAttr = util:combine_list(BaseAttrL);
                            _ -> BaseAttr = []
                        end,
                        case data_godweapon:get_stage_cfg(IllusionId) of          %% 没激活化形id 0
                            #godweapon_stage_cfg{figure_id = FigureId} -> ok;
                            _ -> FigureId = 0
                        end,
                        TmpStatusGodweapon = #status_godweapon{
                            lv     = Lv, exp = Exp, illusion_id = IllusionId, figure_id = FigureId, base_attr = BaseAttr,
                            skills = SkillIds, display_status = DisplayStatus},
                        count_godweapon_attr(Player#player_status{status_godweapon = TmpStatusGodweapon, figure = Figure#figure{god_equip_model = [{?MODEL_PART_WEAPON, FigureId * DisplayStatus}]}});
                    _ -> Player#player_status{status_godweapon = #status_godweapon{}}
                end,

    #player_status{status_godweapon = StatusGodweapon} = NewPlayer,

    Sql1 = io_lib:format(?sql_player_godweapon_figure_select, [RoleId]),
    {FigureList, FigureAttrL}
        = lists:foldl(fun([Id, Star], {TmpFL, TmpFAttrL}) ->
        case data_godweapon:get_star_cfg(Id, Star) of
            #godweapon_star_cfg{attr = FStarAttr} -> skip;
            _ -> FStarAttr = []
        end,
        TmpFAttr = lib_player_attr:partial_attr_convert(FStarAttr),
        TmpFAttrR = lib_player_attr:to_attr_record(TmpFAttr),
        TmpFCombat = lib_player:calc_all_power(TmpFAttrR),
        TmpR = #godweapon_figure{
            id   = Id, star = Star,
            attr = TmpFAttr, combat = TmpFCombat},
        {[TmpR | TmpFL], TmpFAttr ++ TmpFAttrL}
                      end, {[], []}, db:get_all(Sql1)),
    %% 把化形属性Key相同的Val合并到一起
    LastFigureAttrL = util:combine_list(FigureAttrL),
    PassiveSkills = lib_skill_api:divide_passive_skill(StatusGodweapon#status_godweapon.skills),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(StatusGodweapon#status_godweapon.attr ++ LastFigureAttrL, ?SP_ATTR_MAP),
    NewStatusGodweapon = StatusGodweapon#status_godweapon{
        figure_list    = FigureList ++ [#godweapon_figure{id = ?GODWEAPON_MIN_STAGE}],
        figure_attr    = LastFigureAttrL,
        passive_skills = PassiveSkills,
        special_attr   = SpecialAttrMap
    },
    NewPlayer#player_status{status_godweapon = NewStatusGodweapon}.

%% 获取神兵技能
get_godweapon_skill(Lv) ->
    SkillIds = data_godweapon:get_all_skill_ids(),
    do_get_godweapon_skill(SkillIds, Lv, []).

do_get_godweapon_skill([], _Lv, LearnSkillIds) ->
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_GODWEAPON, LearnSkillIds),
    {SkillAttr, LearnSkillIds};
do_get_godweapon_skill([Id | L], Lv, LearnSkillIds) ->
    case data_godweapon:get_skill_cfg(Id) of
        #godweapon_skill_cfg{lv = UnlockLv} -> ok;
        _ -> UnlockLv = 99999
    end,
    case Lv >= UnlockLv of
        true ->
            do_get_godweapon_skill(L, Lv, [Id | LearnSkillIds]);
        false ->
            do_get_godweapon_skill(L, Lv, LearnSkillIds)
    end.

%% 刷新幻形的技能以及属性信息
refresh_illusion_data(StatusGodweapon) ->
    #status_godweapon{attr = AttrL, figure_list = FigureList} = StatusGodweapon,
    FAttrList = lists:foldl(fun(#godweapon_figure{attr = Attr}, TmpFAttrL) ->
        Attr ++ TmpFAttrL end, [], FigureList),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(AttrL ++ FAttrList, ?SP_ATTR_MAP),
    StatusGodweapon#status_godweapon{figure_attr = FAttrList, special_attr = SpecialAttrMap}.


%% 计算神兵属性和战力
count_godweapon_attr(Player) ->
    #player_status{status_godweapon = StatusGodweapon, skill = SkillStatus} = Player,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    #status_godweapon{
        lv          = Lv,
        base_attr   = BaseAttr,
        skills      = SkillIds,
        figure_attr = FigureAttr
    } = StatusGodweapon,
    case data_godweapon:get_lv_cfg(Lv) of
        #godweapon_lv_cfg{attr = LvAttr} -> skip;
        _ -> LvAttr = []
    end,
    case SkillIds =/= [] of
        true ->
            NewSkillIds = SkillIds,
            SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_GODWEAPON, NewSkillIds);
        false ->
            {SkillAttr, NewSkillIds} = get_godweapon_skill(Lv)
    end,
    TalentSkillAttr = lib_skill_api:get_skill_attr2mod(?MOD_GODWEAPON, SkillTalentList),
    AttrList = util:combine_list(TalentSkillAttr ++ BaseAttr ++ LvAttr ++ SkillAttr),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(NewAttr ++ FigureAttr, ?SP_ATTR_MAP),
    NewStatusGodweapon = StatusGodweapon#status_godweapon{skills = NewSkillIds, attr = NewAttr, combat = NewCombat, special_attr = SpecialAttrMap},
    NewPlayer = Player#player_status{status_godweapon = NewStatusGodweapon},
    % lib_common_rank_api:refresh_common_rank(NewPlayer, ?RANK_TYPE_GODWEAPON),
    NewPlayer.

%% 改变神兵显示状态
%% Type: 0: 隐藏 1: 显示
change_display_status(Player, Type) ->
    #player_status{sid = Sid, id = RoleId, status_godweapon = StatusGodweapon, figure = Figure} = Player,
    #status_godweapon{lv = Lv, display_status = DisplayStatus, figure_id = FigureId} = StatusGodweapon,
    %% 检测负面状态
    if
        Type =/= ?GODWEAPON_HIDE andalso Type =/= ?GODWEAPON_DISPLAY -> NewPlayer = Player, ErrorCode = skip;
        Type == DisplayStatus -> NewPlayer = Player, ErrorCode = skip;
        Lv < 1 -> NewPlayer = Player, ErrorCode = ?ERRCODE(err169_figure_unactive);
        true ->
            db:execute(io_lib:format(?sql_update_godweapon_display_status, [Type, RoleId])),
            NewStatusGodweapon = StatusGodweapon#status_godweapon{display_status = Type},
            NewPlayer = Player#player_status{status_godweapon = NewStatusGodweapon, figure = Figure#figure{god_equip_model = [{?MODEL_PART_WEAPON, FigureId * Type}]}},
            broadcast_to_scene(NewPlayer),
            ErrorCode = ?SUCCESS
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData} = pt_169:write(16904, [ErrorCode, Type]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ -> skip
    end,
    {ok, NewPlayer}.

%%  广播给场景玩家
broadcast_to_scene(Player) ->
    #player_status{
        id            = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x             = X, y = Y, status_godweapon = StatusGodweapon
    } = Player,
    #status_godweapon{figure_id = FigureId, display_status = DisplayStatus} = StatusGodweapon,
    EquipModel = [{?MODEL_PART_WEAPON, FigureId * DisplayStatus}],
    mod_scene_agent:update(Player, [{god_equip_model, EquipModel}]),
    {ok, BinData} = pt_169:write(16901, [RoleId, EquipModel]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).


%% 使用仙羽
use_goods(Player, GTypeId, OwnNum) ->
    case data_godweapon:get_feather_cfg(GTypeId) of
        #godweapon_feather_cfg{attr = Attr} ->
            #player_status{id = RoleId, status_godweapon = StatusGodweapon, figure = #figure{lv = RoleLv}} = Player,
            #status_godweapon{lv = Lv, base_attr = BaseAttr} = StatusGodweapon,
            case Lv > 0 of
                true ->
                    Count = mod_counter:get_count(RoleId, ?MOD_GOODS, GTypeId),
                    MaxTimes = get_feather_max_times(GTypeId, RoleLv),
                    UseNum = min(MaxTimes - Count, OwnNum),
                    case Count < MaxTimes of
                        true ->
                            Cost = [{?TYPE_GOODS, GTypeId, UseNum}],
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, godweapon_use_feather, "") of
                                {true, NewPlayerTmp} ->
                                    TmpAttr = [{AId, AVal * UseNum}|| {AId, AVal} <- Attr],
                                    NewBaseAttr = util:combine_list(TmpAttr ++ BaseAttr),
                                    mod_counter:plus_count(RoleId, ?MOD_GOODS, GTypeId, UseNum),
                                    NewStatusGodweapon = StatusGodweapon#status_godweapon{base_attr = NewBaseAttr},
                                    NewPlayerTmp1 = count_godweapon_attr(NewPlayerTmp#player_status{status_godweapon = NewStatusGodweapon}),
                                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
                                    %% 日志
                                    lib_log_api:log_godweapon_develop(RoleId, GTypeId, Count + UseNum, MaxTimes, StatusGodweapon#status_godweapon.attr, NewPlayer#player_status.status_godweapon#status_godweapon.attr),

                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    {ok, ?SUCCESS, NewPlayer};
                                {false, 1003, NewPlayerTmp} ->
                                    {fail, ?ERRCODE(err169_not_enough_cost), NewPlayerTmp};
                                {false, ErrorCode, NewPlayerTmp} -> {fail, ErrorCode, NewPlayerTmp}
                            end;
                        _ -> {fail, ?ERRCODE(err169_max_goods_use_times), Player}
                    end;
                false -> {fail, ?ERRCODE(err169_figure_not_active), Player}
            end;
        _ -> {fail, ?ERRCODE(err_config), Player}
    end.


%% 神兵升级检测
check_upgrade_lv(StatusGodweapon, GoodsId, RoleId) ->
    #status_godweapon{lv = Lv} = StatusGodweapon,
    LvCfg = data_godweapon:get_lv_cfg(Lv),
    GoodCfg = data_godweapon:get_goods_exp(GoodsId),
    [{_GId, GoodNum}] = lib_goods_api:get_goods_num(RoleId, [GoodsId]),
    if
        GoodNum =< 0 -> {fail, ?ERRCODE(err169_not_enough_cost)};
        Lv =< 0 -> {fail, ?ERRCODE(err169_figure_unactive)};
        is_record(LvCfg, godweapon_lv_cfg) == false -> {fail, ?ERRCODE(err_config)};
        is_record(GoodCfg, godweapon_goods_exp_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            NextLvCfg = data_godweapon:get_lv_cfg(Lv + 1),
            if
                is_record(NextLvCfg, godweapon_lv_cfg) == false -> {fail, ?ERRCODE(err169_max_lv)};
                true -> {ok, GoodNum}
            end
    end.

%% 神兵升级
upgrade_lv(Player, GoodsId, Type) ->
    #player_status{sid = Sid, id = RoleId, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{lv = Lv, exp = Exp} = StatusGodweapon,
    {Code, NewPlayer} = case check_upgrade_lv(StatusGodweapon, GoodsId, RoleId) of
                            {ok, NumOwn} ->
                                #godweapon_lv_cfg{max_exp = MaxExp} = data_godweapon:get_lv_cfg(Lv),
                                #godweapon_goods_exp_cfg{exp = OneExp} = data_godweapon:get_goods_exp(GoodsId),
                                case Exp + OneExp >= MaxExp of
                                    true -> GoodNum = 1;
                                    _ ->
                                        case Type of
                                            ?GODWEAPON_LV_MANUAL -> GoodNum = 1;
                                            ?GODWEAPON_LV_AUTO ->
                                                NumTmp = util:ceil((MaxExp - Exp) / OneExp),
                                                GoodNum = min(NumTmp, NumOwn)
                                        end
                                end,
                                ExpPlus = OneExp * GoodNum,  %%协议一个个发 num现在为1
                                case lib_goods_api:cost_object_list_with_check(Player, Cost = [{?TYPE_GOODS, GoodsId, GoodNum}], godweapon_upgrade_lv, "") of
                                    {true, NewPlayerTmp} ->
                                        do_upgrade_lv(NewPlayerTmp, ExpPlus, MaxExp, Cost);
                                    {false, 1003, NewPlayerTmp} ->
                                        {?ERRCODE(err169_not_enough_cost), NewPlayerTmp};
                                    {false, ErrorCode, NewPlayerTmp} -> {ErrorCode, NewPlayerTmp}
                                end;
                            {fail, ErrorCode} -> {ErrorCode, Player}
                        end,
    case is_integer(Code) of
        true ->
            {ok, BinData1} = pt_169:write(16900, [Code]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,
    {ok, NewPlayer}.

upgrade_lv_help(Lv, Exp, ExpPlus, MaxExp, Name) ->
    case Exp + ExpPlus >= MaxExp of
        true ->
            NextLv = Lv + 1,
            NextExp = Exp + ExpPlus - MaxExp,
            case data_godweapon:get_lv_cfg(NextLv) of
                #godweapon_lv_cfg{max_exp = NextMaxExp, is_tv = IsTv} ->
                    case IsTv == 1 of
                        true ->
                            lib_chat:send_TV({all}, ?MOD_GODWEAPON, 1, [Name, NextLv]);
                        false -> skip
                    end,
                    case NextExp >= NextMaxExp of
                        true -> {NewLv, NewExp} = upgrade_lv_help(NextLv, 0, NextExp, NextMaxExp, Name);
                        _ ->
                            NewLv = NextLv,
                            NewExp = NextExp
                    end;
                _ ->
                    NewLv = Lv,
                    NewExp = Exp + ExpPlus
            end;
        false ->
            NewLv = Lv,
            NewExp = Exp + ExpPlus
    end,
    {NewLv, NewExp}.


do_upgrade_lv(Player, ExpPlus, MaxExp, Cost) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{lv = Lv, exp = Exp, skills = SkillIds, passive_skills = PassiveSkills} = StatusGodweapon,
    {NewLv, NewExp} = upgrade_lv_help(Lv, Exp, ExpPlus, MaxExp, Figure#figure.name),
    case NewLv =/= Lv of
        true ->
            {_SkillAttr, NewSkillIds} = get_godweapon_skill(NewLv),
            NewPassiveSkills = lib_skill_api:divide_passive_skill(NewSkillIds);
        false ->
            NewSkillIds = SkillIds,
            NewPassiveSkills = PassiveSkills
    end,
    db:execute(io_lib:format(?sql_update_godweapon_lv, [NewLv, NewExp, RoleId])),
    NewStatusGodweapon = StatusGodweapon#status_godweapon{
        lv             = NewLv,
        exp            = NewExp,
        skills         = NewSkillIds,
        passive_skills = NewPassiveSkills},
    case NewLv =/= Lv of
        true ->
            %% 同步新解锁的被动技能到玩家场景
            PassiveSkillsAdd = lib_skill_api:divide_passive_skill(NewSkillIds),
            case PassiveSkillsAdd =/= [] of
                true ->
                    mod_scene_agent:update(Player, [{passive_skill, PassiveSkillsAdd}]);
                false -> skip
            end,
            NewPlayerTmp = count_godweapon_attr(Player#player_status{status_godweapon = NewStatusGodweapon}),
            NewPlayer2 = lib_player:count_player_attribute(NewPlayerTmp),
            {ok, NewPlayer} = lib_achievement_api:godweapon_lv_up_event(NewPlayer2, NewLv),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player#player_status{status_godweapon = NewStatusGodweapon}
    end,
    %% 日志
    lib_log_api:log_godweapon_lv(RoleId, Lv, Exp, NewLv, NewExp, Cost, NewSkillIds),
    {ok, BinData} = pt_169:write(16905, [?SUCCESS, NewLv, NewExp, ExpPlus]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.


%% 神兵幻化
illusion_figure(RoleId, StatusGodweapon, SelId) ->
    #status_godweapon{figure_list = FigureList, illusion_id = CurIllusionId} = StatusGodweapon,
    IsActive = lists:keyfind(SelId, #godweapon_figure.id, FigureList),
    FigureCfg = data_godweapon:get_stage_cfg(SelId),
    if
        SelId == CurIllusionId -> {fail, ?ERRCODE(err169_already_active)};
        IsActive == false -> {fail, ?ERRCODE(err169_figure_not_active)};
        is_record(FigureCfg, godweapon_stage_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            #godweapon_stage_cfg{figure_id = FigureId} = FigureCfg,
            NewStatusGodweapon = StatusGodweapon#status_godweapon{
                illusion_id = SelId,
                figure_id   = FigureId
            },
            db:execute(io_lib:format(?sql_update_godweapon_illusion, [SelId, RoleId])),
            {ok, NewStatusGodweapon}
    end.

active_figure(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, status_godweapon = StatusGodweapon, figure = Figure} = Player,
    #status_godweapon{figure_list = FigureList} = StatusGodweapon,
    case lists:keyfind(Id, #godweapon_figure.id, FigureList) of
        false ->
            case data_godweapon:get_stage_cfg(Id) of
                #godweapon_stage_cfg{prop = [{_Type, _Gid, _GNum} | _LCost] = Cost, turn = Turn} ->
                    case Figure#figure.turn >= Turn of
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, godweapon_active_figure, "") of
                                {true, NewPlayerTmp} ->
                                    case data_godweapon:get_star_cfg(Id, ?GODWEAPON_MIN_STAR) of
                                        #godweapon_star_cfg{attr = FStarAttr} -> skip;
                                        _ -> FStarAttr = []
                                    end,
                                    FAttr = lib_player_attr:partial_attr_convert(FStarAttr),
                                    FAttrR = lib_player_attr:to_attr_record(FAttr),
                                    FCombat = lib_player:calc_all_power(FAttrR),
                                    TmpR = #godweapon_figure{id = Id, star = ?GODWEAPON_MIN_STAR, attr = FAttr, combat = FCombat},
                                    NewFigureList = [TmpR | FigureList],
                                    NewStatusGodweapon = refresh_illusion_data(StatusGodweapon#status_godweapon{figure_list = NewFigureList}),
                                    NewPlayer = NewPlayerTmp#player_status{status_godweapon = NewStatusGodweapon},
                                    lib_server_send:send_to_sid(Sid, pt_169, 16908, [?SUCCESS, Id]),
                                    %% 激活马上幻化
                                    {ok, NewPlayer1} = pp_godweapon:handle(16903, NewPlayer, [Id]),
                                    {ok, NewPlayer2} = lib_achievement_api:godweapon_acti_event(NewPlayer1, Id),
                                    LastPlayer = lib_player:count_player_attribute(NewPlayer2),
                                    db:execute(io_lib:format(?sql_update_godweapon_illusion_info, [RoleId, Id, ?GODWEAPON_MIN_STAR])),
                                    %% 日志
                                    lib_log_api:log_godweapon_illusion(RoleId, Id, 0, 0, 0, Cost),
                                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR);
                                {false, ErrorCode, LastPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_169, 16900, [ErrorCode])
                            end;
                        false ->
                            LastPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_169, 16900, [?ERRCODE(err169_not_turn)])
                    end;
                _ ->
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_169, 16900, [?ERRCODE(error_config)])
            end;
        _ -> LastPlayer = Player %% 已经激活过
    end,
    {ok, LastPlayer}.


%% 神兵幻形升星检测
check_upgrade_star(StatusGodweapon, SelId) ->
    #status_godweapon{figure_list = FigureList} = StatusGodweapon,
    FigureInfo = lists:keyfind(SelId, #godweapon_figure.id, FigureList),
    if
        FigureInfo == false -> {fail, ?ERRCODE(err169_figure_not_active)};
        true ->
            #godweapon_figure{star = Star} = FigureInfo,
            StarCfg = data_godweapon:get_star_cfg(SelId, Star),
            NextStarCfg = data_godweapon:get_star_cfg(SelId, Star + 1),
            if
                is_record(StarCfg, godweapon_star_cfg) == false ->
                    {fail, ?ERRCODE(err_config)};
                is_record(NextStarCfg, godweapon_star_cfg) == false ->
                    {fail, ?ERRCODE(err169_max_star)};
                true ->
                    {ok, StarCfg, FigureInfo}
            end
    end.

%神兵化形升星
upgrade_star(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, status_godweapon = StatusGodweapon} = Player,
    #status_godweapon{figure_list = FigureList} = StatusGodweapon,
    case check_upgrade_star(StatusGodweapon, Id) of
        {ok, #godweapon_star_cfg{cost = Cost}, FigureInfo} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, godweapon_upgrade_star, "") of
                {true, NewPlayerTmp} ->
                    ErrorCode = nothing,
                    NewFigureInfo = do_upgrade_star(FigureInfo),
                    NewFigureList = lists:keystore(Id, #godweapon_figure.id, FigureList, NewFigureInfo),
                    NewStatusGodweapon = StatusGodweapon#status_godweapon{figure_list = NewFigureList},
                    #godweapon_figure{star = NewStar} = NewFigureInfo,
                    db:execute(io_lib:format(?sql_update_godweapon_illusion_info, [RoleId, Id, NewStar])),
                    case NewStar =/= FigureInfo#godweapon_figure.star of
                        true ->
                            LastStatusGodweapon = refresh_illusion_data(NewStatusGodweapon),
                            LastPlayer = lib_player:count_player_attribute(NewPlayerTmp#player_status{status_godweapon = LastStatusGodweapon}),
                            %% 日志
                            lib_log_api:log_godweapon_illusion(RoleId, Id, 1, FigureInfo#godweapon_figure.star, NewStar, Cost),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR);
                        false ->
                            LastPlayer = NewPlayerTmp#player_status{status_godweapon = NewStatusGodweapon}
                    end,
                    {ok, BinData} = pt_169:write(16906, [?SUCCESS, NewStar, Id]),
                    lib_server_send:send_to_sid(Sid, BinData);
                {false, 1003, LastPlayer} -> ErrorCode = ?ERRCODE(err169_not_enough_cost);
                {false, ErrorCode, LastPlayer} -> skip
            end;
        {fail, ErrorCode} -> LastPlayer = Player
    end,
    case is_integer(ErrorCode) of
        true ->
            {ok, BinData1} = pt_169:write(16900, [ErrorCode]),
            lib_server_send:send_to_sid(Sid, BinData1);
        false -> skip
    end,
    {ok, LastPlayer}.

do_upgrade_star(FigureInfo) ->
    #godweapon_figure{id = Id, star = Star} = FigureInfo,
    NewStar = Star + 1,
    case data_godweapon:get_star_cfg(Id, NewStar) of
        #godweapon_star_cfg{attr = FStarAttr} -> skip;
        _ -> FStarAttr = []
    end,
    FAttr = lib_player_attr:partial_attr_convert(FStarAttr),
    FAttrR = lib_player_attr:to_attr_record(FAttr),
    FCombat = lib_player:calc_all_power(FAttrR),
    FigureInfo#godweapon_figure{
        star   = NewStar,
        attr   = FAttr,
        combat = FCombat}.


%% 根据人物等级拿配置的最大次数(培养)
get_feather_max_times(GTypeId, RoleLv) ->
    case data_godweapon:get_feather_cfg(GTypeId) of
        #godweapon_feather_cfg{max_times = [{_, _, _} | _] = MaxTimesL} ->
            do_get_feather_max_times(MaxTimesL, RoleLv);
        _ -> 0
    end.

do_get_feather_max_times([], _RoleLv) -> 0;
do_get_feather_max_times([{MinLv, MaxLv, Num} | T], RoleLv) ->
    case RoleLv >= MinLv andalso RoleLv =< MaxLv of
        true -> Num;
        _ -> do_get_feather_max_times(T, RoleLv)
    end.


