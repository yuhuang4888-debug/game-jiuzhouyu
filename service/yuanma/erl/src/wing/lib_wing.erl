%%-----------------------------------------------------------------------------
%% @Module  :       lib_wing.erl
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2017-10-9
%% @Description:    翅膀
%%-----------------------------------------------------------------------------
-module(lib_wing).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("wing.hrl").
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
    , count_wing_attr/1
    , get_db_wing_figure/1
    , get_feather_max_times/2
]).

%%  等级达到后解锁翅膀
handle_event(Player, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(Player, player_status) ->
    #player_status{
        id            = RoleId,
        scene         = Sid,
        scene_pool_id = PoolId,
        copy_id       = CopyId,
        x             = X,
        y             = Y,
        figure        = Figure,
        status_wing   = OldStatusWing
    } = Player,
    #figure{lv = Lv} = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_WING, 1),
    case Lv == OpenLv orelse (Lv > OpenLv andalso OldStatusWing#status_wing.lv < ?WING_MIN_LV) of
        true ->
            %% 技能
            {_SkillAttr, SkillIds} = get_wing_skill(0),
            PassiveSkills = lib_skill_api:divide_passive_skill(SkillIds),
            case PassiveSkills =/= [] of
                true ->
                    mod_scene_agent:update(Player, [{passive_skill, PassiveSkills}]);
                false -> skip
            end,
            %% 基础外形资源id
            FigureId = get_cfg_figure_id(?WING_MIN_STAGE),
            StatusWing = #status_wing{
                lv             = ?WING_MIN_LV,          %% 最低等级
                illusion_id    = ?WING_MIN_STAGE,       %% 化形id(0)
                figure_list    = [#wing_figure{id = ?WING_MIN_STAGE}],  %% 基础形象（化形id 0）
                figure_id      = FigureId,              %% 资源id
                skills         = SkillIds,              %% 技能
                passive_skills = PassiveSkills,         %% 被动技能
                display_status = ?WING_DISPLAY          %% 激活后默认显示
            },
            %% 同步到场景玩家并广播
            mod_scene_agent:update(Player, [{wing_figure, FigureId}]),
            {ok, BinData} = pt_161:write(16101, [RoleId, FigureId]),
            lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData),
            %% 更新PS
            NewFigure = Figure#figure{wing_figure = FigureId},
            NewPlayerTmp = count_wing_attr(Player#player_status{status_wing = StatusWing, figure = NewFigure}),
            NewPlayer = lib_player:count_player_attribute(NewPlayerTmp),
            %% db 插入新数据
            db:execute(io_lib:format(?sql_player_wing_replace,
                [RoleId, ?WING_MIN_LV, ?WING_MIN_STAGE, ?WING_DISPLAY])),
            %% 更新缓存里的翅膀figure
            lib_role:update_role_show(RoleId, [{figure, NewFigure}]),
            %% 通知客户端属性改变
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player
    end,
    case Lv >= OpenLv of
        true ->
            GTypeIds = data_wing:get_feather_ids(),
            F = fun(GTypeId) ->
                case data_wing:get_feather_cfg(GTypeId) of
                    #wing_feather_cfg{max_times = MaxTimesL} ->
                        TmpL = [Tmp || {LLim, _HLim, _} = Tmp <- MaxTimesL, Lv == LLim],
                        TmpL =/= [];
                    _ -> false
                end
                end,
            IsUSign = lists:any(F, GTypeIds),
            case IsUSign of
                true ->
                    pp_wing:handle(16111, NewPlayer, []);
                false -> skip
            end;
        false -> skip
    end,
    {ok, NewPlayer};
handle_event(Player, #event_callback{}) -> {ok, Player}.

%% 登录处理
%% return:  #player_status{}
login(Player) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    %% 拿db数据
    Sql = io_lib:format(?sql_player_wing_select, [RoleId]),
    NewPlayer = case db:get_row(Sql) of
                    [Lv, Exp, IllusionId, DisplayStatus] ->
                        %% 技能
                        {_SkillAttr, SkillIds} = get_wing_skill(Lv),
                        GTypeIds = data_wing:get_feather_ids(), %% 仙羽Ids
                        %% 终生计数器里拿数量
                        case mod_counter:get_count_offline(RoleId, ?MOD_GOODS, GTypeIds) of
                            [{_, _} | _] = CounterList ->
                                F = fun({GId, GNum}, AttrSum) ->
                                    Attr = case data_wing:get_feather_cfg(GId) of
                                               #wing_feather_cfg{attr = TmpAttr} -> TmpAttr;
                                               _ -> []
                                           end,
                                    %% 仙羽给的属性加起来
                                    case Attr of
                                        [{_, _} | _] -> [{AId, AVal * GNum} || {AId, AVal} <- Attr] ++ AttrSum;
                                        _ -> []
                                    end
                                    end,
                                BaseAttrL = lists:foldl(F, [], CounterList),
                                BaseAttr = util:combine_list(BaseAttrL);
                            _ -> BaseAttr = []
                        end,
                        FigureId = get_cfg_figure_id(IllusionId),
                        TmpStatusWing =
                            #status_wing{
                                lv        = Lv, exp = Exp, illusion_id = IllusionId,
                                figure_id = FigureId, base_attr = BaseAttr,
                                skills    = SkillIds, display_status = DisplayStatus
                            },
                        %% 计算翅膀属性并返回新ps(不包括化形属性)
                        count_wing_attr(Player#player_status{status_wing = TmpStatusWing, figure = Figure#figure{wing_figure = FigureId * DisplayStatus}});
                    _ -> Player#player_status{status_wing = #status_wing{}}
                end,
    StatusWing = NewPlayer#player_status.status_wing,
    %% 化形数据
    Sql1 = io_lib:format(?sql_player_wing_figure_select, [RoleId]),
    F1 = fun([Id, Star], {TmpFL, TmpFAttrL}) ->
        FStarAttr = get_cfg_star_attr(Id, Star),
        TmpFAttr = lib_player_attr:partial_attr_convert(FStarAttr),
        TmpFAttrR = lib_player_attr:to_attr_record(TmpFAttr),
        TmpFCombat = lib_player:calc_all_power(TmpFAttrR),
        TmpR = #wing_figure{
            id   = Id, star = Star,
            attr = TmpFAttr, combat = TmpFCombat},
        {[TmpR | TmpFL], TmpFAttr ++ TmpFAttrL}
         end,
    {FigureList, FigureAttrL} = lists:foldl(F1, {[], []}, db:get_all(Sql1)),
    %% 把化形属性Key相同的Val合并到一起
    LastFigureAttrL = util:combine_list(FigureAttrL),
    PassiveSkills = lib_skill_api:divide_passive_skill(StatusWing#status_wing.skills),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(StatusWing#status_wing.attr ++ LastFigureAttrL, ?SP_ATTR_MAP),
    NewStatusWing = StatusWing#status_wing{
        figure_list    = FigureList ++ [#wing_figure{id = ?WING_MIN_STAGE}], %% 额外加上基础形象的
        figure_attr    = LastFigureAttrL,
        passive_skills = PassiveSkills,
        special_attr   = SpecialAttrMap
    },
    NewPlayer#player_status{status_wing = NewStatusWing}.

%% 获取翅膀技能
get_wing_skill(Lv) ->
    SkillIds = data_wing:get_all_skill_ids(),
    do_get_wing_skill(SkillIds, Lv, []).

do_get_wing_skill([], _Lv, LearnSkillIds) ->
    SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_WING, LearnSkillIds),
    {SkillAttr, LearnSkillIds};
do_get_wing_skill([Id | L], Lv, LearnSkillIds) ->
    UnlockLv = case data_wing:get_skill_cfg(Id) of
                   #wing_skill_cfg{lv = TmpUnlockLv} -> TmpUnlockLv;
                   _ -> 99999
               end,
    case Lv >= UnlockLv of
        true ->
            do_get_wing_skill(L, Lv, [Id | LearnSkillIds]);
        false ->
            do_get_wing_skill(L, Lv, LearnSkillIds)
    end.

%% 刷新化形总属性
refresh_illusion_data(StatusWing) ->
    #status_wing{attr = AttrL, figure_list = FigureList} = StatusWing,
    F = fun(#wing_figure{attr = Attr}, TmpFAttrL) ->
        Attr ++ TmpFAttrL
        end,
    FAttrList = lists:foldl(F, [], FigureList),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(AttrL ++ FAttrList, ?SP_ATTR_MAP),
    StatusWing#status_wing{figure_attr = FAttrList, special_attr = SpecialAttrMap}.

%% 计算翅膀属性和战力
count_wing_attr(Player) ->
    #player_status{status_wing = StatusWing, skill = SkillStatus} = Player,
    #status_skill{skill_talent_list = SkillTalentList} = SkillStatus,
    #status_wing{lv = Lv, base_attr = BaseAttr, skills = SkillIds, figure_attr = FigureAttr} = StatusWing,
    %% 等级属性
    LvAttr = case data_wing:get_lv_cfg(Lv) of
                 #wing_lv_cfg{attr = TmpLvAttr} -> TmpLvAttr;
                 _ -> []
             end,
    %% 技能的
    case SkillIds =/= [] of
        true ->
            NewSkillIds = SkillIds,
            SkillAttr = lib_skill:count_skill_attr_with_mod_id(?MOD_WING, NewSkillIds);
        false ->
            {SkillAttr, NewSkillIds} = get_wing_skill(Lv)
    end,
    TalentSkillAttr = lib_skill_api:get_skill_attr2mod(?MOD_WING, SkillTalentList),
    %% 总属性 以及 战力
    AttrList = util:combine_list(TalentSkillAttr ++ BaseAttr ++ LvAttr ++ SkillAttr),
    NewAttr = lib_player_attr:partial_attr_convert(AttrList),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    SpecialAttrMap = lib_player_attr:filter_specify_attr(NewAttr ++ FigureAttr, ?SP_ATTR_MAP),
    %% 更新PS
    NewStatusWing = StatusWing#status_wing{skills = NewSkillIds, attr = NewAttr, combat = NewCombat, special_attr = SpecialAttrMap},
    NewPlayer = Player#player_status{status_wing = NewStatusWing},
    %% 翅膀战力变动时 刷新通用榜单
    lib_common_rank_api:refresh_common_rank(NewPlayer, ?RANK_TYPE_WING),
    NewPlayer.

%% 改变翅膀显示状态
%% Type: 0: 隐藏 1: 显示
change_display_status(Player, Type) ->
    #player_status{sid = Sid, id = RoleId, status_wing = StatusWing, figure = Figure} = Player,
    #status_wing{lv = Lv, display_status = DisplayStatus, figure_id = FigureId} = StatusWing,
    if
        (Type =/= ?WING_HIDE andalso Type =/= ?WING_DISPLAY) orelse Type == DisplayStatus ->
            ErrorCode = skip,
            NewPlayer = Player;
        Lv < 1 ->
            ErrorCode = ?ERRCODE(err161_figure_unactive),
            NewPlayer = Player;
        true ->
            ErrorCode = ?SUCCESS,
            %% 更新PS
            NewStatusWing = StatusWing#status_wing{display_status = Type},
            NewPlayer = Player#player_status{status_wing = NewStatusWing, figure = Figure#figure{wing_figure = FigureId * Type}},
            %% 更新db
            db:execute(io_lib:format(?sql_update_wing_display_status, [Type, RoleId])),
            %% 通知客户端形象更改
            broadcast_to_scene(NewPlayer)
    end,
    case is_integer(ErrorCode) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_161, 16104, [ErrorCode, Type]);
        _ -> skip
    end,
    {ok, NewPlayer}.

%%  广播给场景玩家
broadcast_to_scene(Player) ->
    #player_status{
        id            = RoleId, scene = Sid,
        scene_pool_id = PoolId, copy_id = CopyId,
        x             = X, y = Y, status_wing = StatusWing
    } = Player,
    #status_wing{figure_id = FigureId, display_status = DisplayStatus} = StatusWing,
    mod_scene_agent:update(Player, [{wing_figure, FigureId * DisplayStatus}]),
    {ok, BinData} = pt_161:write(16101, [RoleId, FigureId * DisplayStatus]),
    lib_server_send:send_to_area_scene(Sid, PoolId, CopyId, X, Y, BinData).


%% 使用仙羽
use_goods(Player, GTypeId, OwnNum) ->
    case data_wing:get_feather_cfg(GTypeId) of
        #wing_feather_cfg{attr = Attr} ->
            #player_status{id = RoleId, status_wing = StatusWing, figure = #figure{lv = RoleLv}} = Player,
            #status_wing{lv = Lv, base_attr = BaseAttr} = StatusWing,
            case Lv > 0 of
                true ->
                    %[{_, OwnNum}] = lib_goods_api:get_goods_num(Player, [GTypeId]),
                    Count = mod_counter:get_count_offline(RoleId, ?MOD_GOODS, GTypeId),
                    MaxTimes = get_feather_max_times(GTypeId, RoleLv),
                    UseNum = min(MaxTimes - Count, OwnNum),
                    case Count < MaxTimes of
                        true ->
                            Cost = [{?TYPE_GOODS, GTypeId, UseNum}],
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, wing_use_feather, "") of
                                {true, NewPlayerTmp} ->
                                    %% 基础属性增加
                                    TmpAttr = [ {AId, AVal * UseNum} || {AId, AVal} <- Attr ],
                                    NewBaseAttr = util:combine_list(TmpAttr ++ BaseAttr),
                                    mod_counter:plus_count(RoleId, ?MOD_GOODS, GTypeId, UseNum),
                                    %% 更新PS
                                    NewStatusWing = StatusWing#status_wing{base_attr = NewBaseAttr},
                                    NewPlayerTmp1 = count_wing_attr(NewPlayerTmp#player_status{status_wing = NewStatusWing}),
                                    NewPlayer = lib_player:count_player_attribute(NewPlayerTmp1),
                                    %% 日志
                                    lib_log_api:log_wing_develop(RoleId, GTypeId, Count + UseNum, MaxTimes, StatusWing#status_wing.attr, NewPlayer#player_status.status_wing#status_wing.attr),
                                    %% 通知客户端属性改变
                                    lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR),
                                    {ok, ?SUCCESS, NewPlayer};
                                {false, ErrorCode, NewPlayerTmp} -> {fail, ErrorCode, NewPlayerTmp}
                            end;
                        _ -> {fail, ?ERRCODE(err161_max_goods_use_times), Player}
                    end;
                false -> {fail, ?ERRCODE(err161_figure_not_active), Player}
            end;
        _ -> {fail, ?ERRCODE(err_config), Player}
    end.

%% 翅膀升级检测
check_upgrade_lv(StatusWing, GoodsId, RoleId) ->
    #status_wing{lv = Lv} = StatusWing,
    LvCfg = data_wing:get_lv_cfg(Lv),
    GoodCfg = data_wing:get_goods_exp(GoodsId),
    [{_GId, GoodNum}] = lib_goods_api:get_goods_num(RoleId, [GoodsId]),
    %io:format("~p~n", [Lv]),
    if
        GoodNum =< 0 -> {fail, ?ERRCODE(err161_not_enough_cost)};
        Lv =< 0 -> {fail, ?ERRCODE(err161_figure_unactive)};
        is_record(LvCfg, wing_lv_cfg) == false -> {fail, ?ERRCODE(err_config)};
        is_record(GoodCfg, wing_goods_exp_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            NextLvCfg = data_wing:get_lv_cfg(Lv + 1),
            if
                is_record(NextLvCfg, wing_lv_cfg) == false -> {fail, ?ERRCODE(err161_max_lv)};
                true -> {ok, GoodNum}
            end
    end.

%% 翅膀升级
upgrade_lv(Player, GoodsId, Type) ->
    #player_status{sid = Sid, id = RoleId, status_wing = StatusWing} = Player,
    #status_wing{lv = Lv, exp = Exp} = StatusWing,
    {Code, NewPlayer} =
        case check_upgrade_lv(StatusWing, GoodsId, RoleId) of
            {ok, NumOwn} ->
                %% 当前升级需要经验
                #wing_lv_cfg{max_exp = MaxExp} = data_wing:get_lv_cfg(Lv),
                %% 单个物品提供的经验
                #wing_goods_exp_cfg{exp = OneExp} = data_wing:get_goods_exp(GoodsId),
                GoodNum = case Exp + OneExp >= MaxExp of
                              true -> 1;
                              _ ->
                                  case Type of
                                      ?WING_LV_MANUAL -> 1;
                                      ?WING_LV_AUTO ->
                                          NumTmp = util:ceil((MaxExp - Exp) / OneExp),
                                          min(NumTmp, NumOwn)
                                  end
                          end,
                %% 增加的经验
                ExpPlus = OneExp * GoodNum,
                case lib_goods_api:cost_object_list_with_check(Player, Cost = [{?TYPE_GOODS, GoodsId, GoodNum}], wing_upgrade_lv, "") of
                    {true, NewPlayerTmp} ->
                        lib_activitycalen_api:role_success_end_activity(RoleId,  ?MOD_WING,  1),
                        do_upgrade_lv(NewPlayerTmp, ExpPlus, MaxExp, Cost);
                    {false, ErrorCode, NewPlayerTmp} -> {ErrorCode, NewPlayerTmp}
                end;
            {fail, ErrorCode} -> {ErrorCode, Player}
        end,
    case is_integer(Code) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_161, 16100, [Code]);
        false -> skip
    end,
    {ok, NewPlayer}.

do_upgrade_lv(Player, ExpPlus, MaxExp, Cost) ->
    #player_status{sid = Sid, id = RoleId, figure = Figure, status_wing = StatusWing} = Player,
    #status_wing{lv = Lv, exp = Exp, skills = SkillIds, passive_skills = PassiveSkills} = StatusWing,
    {NewLv, NewExp} = do_upgrade_lv_help(Lv, Exp, ExpPlus, MaxExp, Figure#figure.name),
    case NewLv =/= Lv of
        true ->
            {_SkillAttr, NewSkillIds} = get_wing_skill(NewLv),
            NewPassiveSkills = lib_skill_api:divide_passive_skill(NewSkillIds);
        false ->
            NewSkillIds = SkillIds,
            NewPassiveSkills = PassiveSkills
    end,
    db:execute(io_lib:format(?sql_update_wing_lv, [NewLv, NewExp, RoleId])),
    NewStatusWing = StatusWing#status_wing{
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
            NewPlayerTmp = count_wing_attr(Player#player_status{status_wing = NewStatusWing}),
            NewPlayer2 = lib_player:count_player_attribute(NewPlayerTmp),
            %% 成就
            {ok, NewPlayer} = lib_achievement_api:wing_lv_up_event(NewPlayer2, NewLv),
            lib_player:send_attribute_change_notify(NewPlayer, ?NOTIFY_ATTR);
        false -> NewPlayer = Player#player_status{status_wing = NewStatusWing}
    end,
    %% 日志
    lib_log_api:log_wing_lv(RoleId, Lv, Exp, NewLv, NewExp, Cost, NewSkillIds),
    {ok, BinData} = pt_161:write(16105, [?SUCCESS, NewLv, NewExp, ExpPlus]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

do_upgrade_lv_help(Lv, Exp, ExpPlus, MaxExp, Name) ->
    case Exp + ExpPlus >= MaxExp of
        true ->
            NextLv = Lv + 1,
            NextExp = Exp + ExpPlus - MaxExp,
            case data_wing:get_lv_cfg(NextLv) of
                #wing_lv_cfg{max_exp = NextMaxExp, is_tv = IsTv} ->
                    %% 传闻 （考虑到一个物品能升很多级的情况， 所以放在这）
                    case IsTv == 1 of
                        true -> lib_chat:send_TV({all}, ?MOD_WING, 1, [Name, NextLv]);
                        false -> skip
                    end,
                    %% 能再升下一级的情况
                    case NextExp >= NextMaxExp of
                        true -> do_upgrade_lv_help(NextLv, 0, NextExp, NextMaxExp, Name);
                        _ -> {NextLv, NextExp}
                    end;
                _ -> {Lv, Exp + ExpPlus}
            end;
        false -> {Lv, Exp + ExpPlus}
    end.

%% 翅膀幻化
illusion_figure(RoleId, StatusWing, SelId) ->
    #status_wing{figure_list = FigureList, illusion_id = CurIllusionId} = StatusWing,
    IsActive = lists:keyfind(SelId, #wing_figure.id, FigureList),
    FigureCfg = data_wing:get_stage_cfg(SelId),
    if
        SelId == CurIllusionId -> skip;
        IsActive == false -> {fail, ?ERRCODE(err161_figure_not_active)};
        is_record(FigureCfg, wing_stage_cfg) == false -> {fail, ?ERRCODE(err_config)};
        true ->
            #wing_stage_cfg{figure_id = FigureId} = FigureCfg,
            %% 更新PS
            NewStatusWing = StatusWing#status_wing{illusion_id = SelId, figure_id = FigureId},
            %% 更新db
            db:execute(io_lib:format(?sql_update_wing_illusion, [SelId, RoleId])),
            {ok, NewStatusWing}
    end.

%% 激活化形形象
active_figure(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, status_wing = StatusWing, figure = Figure} = Player,
    #status_wing{figure_list = FigureList} = StatusWing,
    case lists:keyfind(Id, #wing_figure.id, FigureList) of
        false ->
            case data_wing:get_stage_cfg(Id) of
                #wing_stage_cfg{prop = [{_, _, _} | _] = Cost, turn = Turn} ->
                    %% 判断转生条件是否满足
                    case Figure#figure.turn >= Turn of
                        true ->
                            case lib_goods_api:cost_object_list_with_check(Player, Cost, wing_active_figure, "") of
                                {true, NewPlayerTmp} ->
                                    FStarAttr = get_cfg_star_attr(Id, ?WING_MIN_STAR),
                                    FAttr = lib_player_attr:partial_attr_convert(FStarAttr),
                                    FAttrR = lib_player_attr:to_attr_record(FAttr),
                                    FCombat = lib_player:calc_all_power(FAttrR),
                                    %% 新激活的加进幻形列表里
                                    TmpR = #wing_figure{id = Id, star = ?WING_MIN_STAR, attr = FAttr, combat = FCombat},
                                    NewFigureList = [TmpR | FigureList],
                                    %% 更新化形总属性
                                    NewStatusWing = refresh_illusion_data(StatusWing#status_wing{figure_list = NewFigureList}),
                                    %% 日志
                                    lib_log_api:log_wing_illusion(RoleId, Id, 0, 0, 0, Cost),
                                    %%--更新PS--
                                    NewPlayer = NewPlayerTmp#player_status{status_wing = NewStatusWing},
                                    %% 激活马上幻化
                                    {ok, NewPlayer2} = pp_wing:handle(16103, NewPlayer, [Id]),
                                    LastPlayer = lib_player:count_player_attribute(NewPlayer2),
                                    %%--db--
                                    db:execute(io_lib:format(?sql_update_wing_illusion_info, [RoleId, Id, ?WING_MIN_STAR])),
                                    %% 通知客户端属性改变
                                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                                    lib_server_send:send_to_sid(Sid, pt_161, 16108, [?SUCCESS, Id]);
                                {false, ErrorCode, LastPlayer} ->
                                    lib_server_send:send_to_sid(Sid, pt_161, 16100, [ErrorCode])
                            end;
                        false ->
                            LastPlayer = Player,
                            lib_server_send:send_to_sid(Sid, pt_161, 16100, [?ERRCODE(err161_not_turn)])
                    end;
                _ ->
                    LastPlayer = Player,
                    lib_server_send:send_to_sid(Sid, pt_161, 16100, [?ERRCODE(err_config)])
            end;
        _ -> LastPlayer = Player %% 已经激活过
    end,
    {ok, LastPlayer}.

%% 翅膀幻形升星检测
check_upgrade_star(StatusWing, SelId) ->
    #status_wing{figure_list = FigureList} = StatusWing,
    FigureInfo = lists:keyfind(SelId, #wing_figure.id, FigureList),
    if
        FigureInfo == false -> {fail, ?ERRCODE(err161_figure_not_active)};
        true ->
            #wing_figure{star = Star} = FigureInfo,
            StarCfg = data_wing:get_star_cfg(SelId, Star),
            NextStarCfg = data_wing:get_star_cfg(SelId, Star + 1),
            if
                is_record(StarCfg, wing_star_cfg) == false ->
                    {fail, ?ERRCODE(err_config)};
                is_record(NextStarCfg, wing_star_cfg) == false ->
                    {fail, ?ERRCODE(err161_max_star)};
                true ->
                    {ok, StarCfg, FigureInfo}
            end
    end.

%翅膀化形升星
upgrade_star(Player, Id) ->
    #player_status{sid = Sid, id = RoleId, status_wing = StatusWing} = Player,
    #status_wing{figure_list = FigureList} = StatusWing,
    case check_upgrade_star(StatusWing, Id) of
        {ok, #wing_star_cfg{cost = Cost}, FigureInfo} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, wing_upgrade_star, "") of
                {true, NewPlayerTmp} ->
                    ErrorCode = nothing,
                    NewFigureInfo = do_upgrade_star(FigureInfo),
                    NewFigureList = lists:keystore(Id, #wing_figure.id, FigureList, NewFigureInfo),
                    NewStatusWing = StatusWing#status_wing{figure_list = NewFigureList},
                    NewStar = NewFigureInfo#wing_figure.star,
                    %%--db--
                    db:execute(io_lib:format(?sql_update_wing_illusion_info, [RoleId, Id, NewStar])),
                    case NewStar =/= FigureInfo#wing_figure.star of
                        true ->
                            %% 日志
                            lib_log_api:log_wing_illusion(RoleId, Id, 1, FigureInfo#wing_figure.star, NewStar, Cost),
                            %% 更新幻形总属性
                            LastStatusWing = refresh_illusion_data(NewStatusWing),
                            LastPlayer = lib_player:count_player_attribute(NewPlayerTmp#player_status{status_wing = LastStatusWing}),
                            lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR);
                        false ->
                            LastPlayer = NewPlayerTmp#player_status{status_wing = NewStatusWing}
                    end,
                    lib_server_send:send_to_sid(Sid, pt_161, 16106, [?SUCCESS, NewStar, Id]);
                {false, ErrorCode, LastPlayer} -> skip
            end;
        {fail, ErrorCode} -> LastPlayer = Player
    end,
    case is_integer(ErrorCode) of
        true ->
            lib_server_send:send_to_sid(Sid, pt_161, 16100, [ErrorCode]);
        false -> skip
    end,
    {ok, LastPlayer}.

do_upgrade_star(FigureInfo) ->
    #wing_figure{id = Id, star = Star} = FigureInfo,
    NewStar = Star + 1,
    FStarAttr = get_cfg_star_attr(Id, NewStar),
    FAttr = lib_player_attr:partial_attr_convert(FStarAttr),
    FAttrR = lib_player_attr:to_attr_record(FAttr),
    FCombat = lib_player:calc_all_power(FAttrR),
    FigureInfo#wing_figure{star = NewStar, attr = FAttr, combat = FCombat}.

%% 获取db里的figure id
get_db_wing_figure(RoleId) ->
    Sql = io_lib:format(?sql_player_wing_select, [RoleId]),
    case db:get_row(Sql) of
        [_, _, IllusionId, _] ->
            get_cfg_figure_id(IllusionId);
        _ -> 0
    end.


%%--------配置相关--------%%

%% 获取配置figure id
get_cfg_figure_id(Stage) ->
    case data_wing:get_stage_cfg(Stage) of
        #wing_stage_cfg{figure_id = FigureId} -> FigureId;
        _ -> 0
    end.

%% 获取星级属性
get_cfg_star_attr(Id, Star) ->
    case data_wing:get_star_cfg(Id, Star) of
        #wing_star_cfg{attr = FStarAttr} -> FStarAttr;
        _ -> []
    end.

%% 根据人物等级拿配置的最大次数
get_feather_max_times(GTypeId, RoleLv) ->
    case data_wing:get_feather_cfg(GTypeId) of
        #wing_feather_cfg{max_times = [{_, _, _} | _] = MaxTimesL} ->
            do_get_feather_max_times(MaxTimesL, RoleLv);
        _ -> 0
    end.

do_get_feather_max_times([], _RoleLv) -> 0;
do_get_feather_max_times([{MinLv, MaxLv, Num} | T], RoleLv) ->
    case RoleLv >= MinLv andalso RoleLv =< MaxLv of
        true -> Num;
        _ -> do_get_feather_max_times(T, RoleLv)
    end.

