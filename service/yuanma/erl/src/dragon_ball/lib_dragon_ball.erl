%% ---------------------------------------------------------------------------
%% @doc lib_dragon_ball

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/8/11
%% @deprecated  龙珠
%% ---------------------------------------------------------------------------
-module(lib_dragon_ball).

%% API
-export([
    login/1,
    handle_event/2,
    active_dragon_statue/1,
    get_passive_skills/1,
    get_skill_and_attr/1,
    get_skill_power/1,
    get_dragon_ball_list/1,
    active_dragon_ball/2,
    upgrade_dragon_ball/2,
    send_dragon_figure_list/1,
    take_dragon_figure/3,
    active_dragon_figure/3,
    calc_sum_sum_power/1,
    send_star_nuclear/1,
    gm_refresh_buy_time/1,
    refresh/1,
    refresh_data/0,
    gm_active_dragon_statue/1
]).

-include("server.hrl").
-include("common.hrl").
-include("dragon_ball.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("rec_recharge.hrl").
-include("activitycalen.hrl").

%% 登陆
login(Ps) ->
    #player_status{id = RoleId, figure = Figure, st_liveness = StLiveness} = Ps,

    % 龙珠初始化
    case db:get_all(io_lib:format(?sql_load_dragon_ball, [RoleId])) of
        [] -> StatusDragonBall0 = #status_dragon_ball{items = []};
        DragonList ->
            BallItems = [{BallId, BallLv, 0} || [BallId, BallLv] <- DragonList],
            StatusDragonBall0 = #status_dragon_ball{items = BallItems}
    end,

    % 龙珠雕像、龙珠形象初始化
    [Statue, FigureType, FigureList, NuclearBuy] = lib_dragon_ball_data:db_select_dragon_ball_statue(RoleId),
    StatusDragonBall1 = StatusDragonBall0#status_dragon_ball{statue = Statue, figure_type = FigureType, figure_list = FigureList, nuclear_buy = NuclearBuy},

    % 神龙雕像自动激活处理
    % 如未激活雕像但已有激活龙珠，自动免费激活雕像
    case StatusDragonBall1 of
        #status_dragon_ball{statue = ?UNACTIVE, items = Items} when length(Items) > 0 ->
            StatusDragonBall2 = StatusDragonBall1#status_dragon_ball{statue = ?ACTIVE},
            lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, StatusDragonBall2);
        _ ->
            StatusDragonBall2 = StatusDragonBall1
    end,

    % 属性、技能处理
    StatusDragonBall3 = calc_dragon_attr_skills(StatusDragonBall2),
    Ps1 = Ps#player_status{dragon_ball = StatusDragonBall3},

    % 形象处理
    FigureId = lib_dragon_ball_data:get_dragon_figure_id(StatusDragonBall3),
    Figure1 = Figure#figure{liveness = FigureId},
    StLiveness1 = StLiveness#st_liveness{figure_id = FigureId},
    Ps2 = Ps1#player_status{figure = Figure1, st_liveness = StLiveness1},

    Ps2.

%% 充值事件处理
handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product}}) ->
    #player_status{id = RoleId, dragon_ball = StatusDragonBall, figure = #figure{lv = Lv}} = PS,
    #status_dragon_ball{statue = Statue} = StatusDragonBall,
    OpenDay = util:get_open_day(),

    RechargeId = ?DRAGON_STATUE_RECHARGE_ID,
    IsLvEnough = Lv >= ?DRAGON_STATUE_OP_LV,
    IsOpDayEnough = OpenDay >= ?DRAGON_STATUE_OP_DAY,
    ProductId = Product#base_recharge_product.product_id,
    NewPS =
    case {Statue, ProductId, IsLvEnough, IsOpDayEnough} of
        {?UNACTIVE, RechargeId, true, true} ->
            PS1 = active_dragon_statue(PS),

            % 钻石返利
            ReturnGold = data_recharge:get_value_of_gold(ProductId),
            PS2 = lib_goods_util:add_money(PS1, ReturnGold, ?GOLD, recharge, ""),

            PS2;
        _ ->
            RechargeIds = data_dragon_ball:get_all_recharge_id(),
            case lists:member(ProductId, RechargeIds) of
                true ->
                    #status_dragon_ball{nuclear_buy = NuclearBuy} = StatusDragonBall,
                    GiftId = data_dragon_ball:get_nuclear_id_by_recharge_id(ProductId),
                    #base_star_nuclear{reward = Reward, send_id = SendId} = data_dragon_ball:get_star_nuclear(GiftId),
                    Now = utime:unixtime(),
                    #base_star_nuclear{open_day = CheckDay, times_limit = TimesLimit} = data_dragon_ball:get_star_nuclear(GiftId),
                    {GiftId, OldBuyTimes, OldBuyTime} = ulists:keyfind(GiftId, 1, NuclearBuy, {GiftId, 0, 0}),
                    CheckList =
                        [{check_open_day, OpenDay, CheckDay},
                        {check_times, TimesLimit, OldBuyTimes, Now, OldBuyTime},
                        {check_today_buy, Now, NuclearBuy, GiftId, SendId}],
                    case check_buy(CheckList) of
                        true ->

                            BuyTimes = case utime:is_same_day(OldBuyTime, Now) of
                                           true -> OldBuyTimes + 1;
                                           _ -> 1
                                       end,
                            NewNuclearBuy = lists:keystore(GiftId, 1, NuclearBuy, {GiftId, BuyTimes, Now}),
                            StatusDragonBall3 = StatusDragonBall#status_dragon_ball{nuclear_buy = NewNuclearBuy},
                            lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, StatusDragonBall3),
                            PS1 = PS#player_status{dragon_ball = StatusDragonBall3},
                            SendPs = lib_goods_api:send_reward(PS1, Reward, star_nuclear_buy, 0),
                            pp_dragon_ball:handle(14311, SendPs, []),
                            lib_server_send:send_to_uid(RoleId, pt_143, 14312, [Reward]),
                            SendPs;
                        _ -> PS
                    end;
                _ -> PS
            end
    end,
    {ok, NewPS};

handle_event(PS, _) ->
    {ok, PS}.

%% 激活玩家龙珠雕像
%% @return #player_status{}
active_dragon_statue(PS) ->
    #player_status{id = RoleId, dragon_ball = StatusDragonBall} = PS,
    StatusDragonBall1 = StatusDragonBall#status_dragon_ball{statue = ?ACTIVE},
    StatusDragonBall2 = calc_dragon_attr_skills(StatusDragonBall1),
    lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, StatusDragonBall2),
    PS1 = PS#player_status{dragon_ball = StatusDragonBall2},

    PS2 = lib_player:count_player_attribute(PS1),
    lib_player:send_attribute_change_notify(PS2, ?NOTIFY_ATTR),

    #status_dragon_ball{skills = SkillList} = StatusDragonBall2,
    mod_scene_agent:update(PS2, [{passive_skill, SkillList}, {battle_attr, PS2#player_status.battle_attr}]),

    pp_dragon_ball:handle(14310, PS2, []),
    pp_dragon_ball:handle(14306, PS2, []),
    get_dragon_ball_list(PS2),
    PS2.

%% 星核直购礼包购买检查
check_buy([]) -> true;
check_buy([{check_open_day, OpenDay, CheckDay} | N]) ->
    case OpenDay >= CheckDay of
        true -> check_buy(N);
        _ ->
            false
    end;
check_buy([{check_times, TimesLimit, OldBuyTimes, Now, OldBuyTime} | N]) ->
    case utime:is_same_day(OldBuyTime, Now) of
        true ->
            case TimesLimit > OldBuyTimes of
                true -> check_buy(N);
                _ -> false
            end;
        _ -> check_buy(N)
    end;
check_buy([{check_today_buy, Now, NuclearBuy, GiftId, SendId} | N]) ->
    case GiftId == SendId of
        true ->
            case check_has_buy_today(NuclearBuy, GiftId, Now) of
                true -> false;
                _ -> check_buy(N)
            end;
        _ ->
            check_buy(N)
    end;
check_buy([_ | _N]) -> false.

%% 获取龙珠总属性
get_total_attr(PS) ->
    #player_status{dragon_ball = StatusDragonBall} = PS,
    #status_dragon_ball{attr = AttrList} = StatusDragonBall,
    {_, StatueAttrL} = ulists:keyfind(statue_attr, 1, AttrList, {statue_attr, []}),
    {_, BallAttrL} = ulists:keyfind(ball_attr, 1, AttrList, {ball_attr, []}),
    {_, FigureAttrL} = ulists:keyfind(figure_attr, 1, AttrList, {figure_attr, []}),
    StatueAttrL ++ BallAttrL ++ FigureAttrL.

%% 获取被动技能
get_passive_skills(Ps) ->
    #player_status{dragon_ball = #status_dragon_ball{skills = PassiveSkills}} = Ps,
    Fun = fun
        ({SkillId, SkillLv}) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{type = ?SKILL_TYPE_PASSIVE} -> true;
            _ -> false
        end;
        (_) -> false
    end,
    lists:filter(Fun, PassiveSkills).

%% 获取技能战力
get_skill_power(Ps) when is_record(Ps, player_status) ->
    #player_status{dragon_ball = #status_dragon_ball{skills = PassiveSkills}} = Ps,
    get_skill_power(PassiveSkills);
get_skill_power(PassiveSkills) when is_list(PassiveSkills) ->
    PowerList = [begin
                     #skill{lv_data = #skill_lv{power = Power}} =data_skill:get(SkillId, SkillLv),
                     Power
                 end||{SkillId, SkillLv}<-PassiveSkills],
    lists:sum(PowerList);
get_skill_power(_R) ->
    0.

get_skill_and_attr(Ps) ->
    #player_status{dragon_ball = #status_dragon_ball{
        skill_power = SkillPower,
        skill_attr = SkillAttr
    }} = Ps,
    AttrL = get_total_attr(Ps),

    {AttrL++SkillAttr, SkillPower}.

%% 获取龙珠列表
get_dragon_ball_list(Ps) ->
    #player_status{sid = Sid, dragon_ball = StatusDragonBall} = Ps,
    #status_dragon_ball{items = DragonBallItems} = StatusDragonBall,
    AllBallIds = data_dragon_ball:list_dragon_ball_ids(),
    DragonBallItems1 = [
        begin
            case lists:keyfind(BallId, 1, DragonBallItems) of
                false -> {BallId, 0, 0};
                Item -> Item
            end
        end
     || BallId <- AllBallIds
    ],
    DragonBallItems2 = calc_dragon_ball_power(Ps, DragonBallItems1),
    {ok, BinData} = pt_143:write(14300, [DragonBallItems2]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 激活龙珠
active_dragon_ball(Ps, DraBallId) ->
    #player_status{dragon_ball = StatusDragonBall, id = RoleId, figure = #figure{name = RoleName}} = Ps,
    #status_dragon_ball{statue = Statue, items = DragonBallItems} = StatusDragonBall,
    BallItem = lists:keyfind(DraBallId, 1, DragonBallItems),

    if
        Statue == ?UNACTIVE -> {false, ?ERRCODE(err143_statue_not_active)};
        BallItem /= false -> {false, ?ERRCODE(err143_had_active)};
        true ->
            case data_dragon_ball:get_dragon_ball(DraBallId, 1) of
                [] -> {false, ?MISSING_CONFIG};
                #base_dragon_ball{name = Name, cost = ActiveCost} ->
                    case lib_goods_api:cost_object_list_with_check(Ps, ActiveCost, dragon_ball, "") of
                        {false, ErrCode, _} -> {false, ErrCode};
                        {true, NewPs} ->
                            % SinglePower = get_skill_power_item({DraBallId, 1}),
                            NewDragonBallItems = lists:keystore(DraBallId, 1, DragonBallItems, {DraBallId, 1, 0}),
                            db:execute(io_lib:format(?sql_replace_dragon_ball, [RoleId, DraBallId, 1])),

                            StatusDragonBall1 = StatusDragonBall#status_dragon_ball{items = NewDragonBallItems},
                            StatusDragonBall2 = calc_dragon_attr_skills(StatusDragonBall1),
                            LastPsTmp = NewPs#player_status{dragon_ball = StatusDragonBall2},

                            LastPs = lib_player:count_player_attribute(LastPsTmp),
                            lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                            mod_scene_agent:update(LastPs, [{passive_skill, StatusDragonBall2#status_dragon_ball.skills}, {battle_attr, LastPs#player_status.battle_attr}]),
                            pp_dragon_ball:handle(14306, LastPs, []),
                            get_dragon_ball_list(LastPs),

                            lib_log_api:log_dragon_ball(RoleId, DraBallId, 0, 1, ActiveCost),
                            lib_chat:send_TV({all}, ?MOD_DRAGON_BALL, 1, [RoleName, Name]),
                            [{_, _, SinglePower, NextPower}] = calc_dragon_ball_power(LastPs, [{DraBallId, 1, 0}]),
                            {ok, SinglePower, NextPower, LastPs}
                    end
            end
    end.

%% 龙珠升级
upgrade_dragon_ball(Ps, DraBallId) ->
    #player_status{dragon_ball = StatusDragonBall, id = RoleId} = Ps,
    #status_dragon_ball{items = DragonBallItems} = StatusDragonBall,
    case lists:keyfind(DraBallId, 1, DragonBallItems) of
        {DraBallId, OldLv, _} ->
            NewLv = OldLv + 1,
            case data_dragon_ball:get_dragon_ball(DraBallId, NewLv) of
                [] -> {false, ?ERRCODE(err143_max_lv)};
                #base_dragon_ball{cost = UpgradeCost} ->
                    case lib_goods_api:cost_object_list_with_check(Ps, UpgradeCost, dragon_ball, "") of
                        {false, ErrCode, _} -> {false, ErrCode};
                        {true, NewPs} ->
                            NewDragonBallItems = lists:keystore(DraBallId, 1, DragonBallItems, {DraBallId, NewLv, 0}),
                            db:execute(io_lib:format(?sql_replace_dragon_ball, [RoleId, DraBallId, NewLv])),

                            StatusDragonBall1 = StatusDragonBall#status_dragon_ball{items = NewDragonBallItems},
                            StatusDragonBall2 = calc_dragon_attr_skills(StatusDragonBall1),
                            LastPsTmp = NewPs#player_status{dragon_ball = StatusDragonBall2},

                            LastPs = lib_player:count_player_attribute(LastPsTmp),
                            lib_player:send_attribute_change_notify(LastPs, ?NOTIFY_ATTR),
                            mod_scene_agent:update(LastPs, [{passive_skill, StatusDragonBall2#status_dragon_ball.skills}, {battle_attr, LastPs#player_status.battle_attr}]),
                            pp_dragon_ball:handle(14306, LastPs, []),
                            get_dragon_ball_list(LastPs),

                            lib_log_api:log_dragon_ball(RoleId, DraBallId, OldLv, NewLv, UpgradeCost),
                            [{_, _, SinglePower, NextPower}] = calc_dragon_ball_power(LastPs, [{DraBallId, NewLv, 0}]),
                            {ok, NewLv, SinglePower, NextPower, LastPs}
                    end
            end;
        _ ->
            {false, ?ERRCODE(err143_no_active)}
    end.

%% 龙珠套装列表
send_dragon_figure_list(Player) ->
    #player_status{sid = SId, dragon_ball = DragonBallStatus} = Player,
    #status_dragon_ball{figure_type = FigureType, figure_list = FigureList} = DragonBallStatus,
    TypeList = data_dragon_ball:get_dragon_figure_types(),
    FigureList1 = [
        begin
            case lists:keyfind(Type, 1, FigureList) of
                false -> {Type, 0};
                Item -> Item
            end
        end
     || Type <- TypeList
    ],
    FigureList2 = calc_dragon_figure_power(Player, FigureList1),
    lib_server_send:send_to_sid(SId, pt_143, 14303, [FigureType, FigureList2]).

%% 穿戴、脱下龙珠套装
%% @return {ok, #player_status{}} | {false, ErrCode :: integer()}
take_dragon_figure(Player, Type, ?TAKE_ON) ->
    #player_status{dragon_ball = DragonBallStatus} = Player,
    #status_dragon_ball{figure_list = FigureList} = DragonBallStatus,
    case lists:keyfind(Type, 1, FigureList) of
        false -> {false, ?ERRCODE(err143_figure_not_active)};
        _ -> take_dragon_figure_on(Player, Type)
    end;

take_dragon_figure(Player, Type, ?TAKE_OFF) ->
    #player_status{dragon_ball = DragonBallStatus} = Player,
    #status_dragon_ball{figure_type = CurType} = DragonBallStatus,
    case Type == CurType of
        true -> take_dragon_figure_on(Player, ?NULL_FIGURE);
        false -> {false, ?ERRCODE(err143_figure_not_wear)}
    end.

%% 替换当前龙珠套装为Type
%% @return {ok, #player_status{}}
take_dragon_figure_on(Player, Type) ->
    #player_status{id = RoleId, dragon_ball = DragonBall} = Player,

    DragonBall1 = DragonBall#status_dragon_ball{figure_type = Type},
    Player1 = Player#player_status{dragon_ball = DragonBall1},
    lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, DragonBall1),

    FigureId = lib_dragon_ball_data:get_dragon_figure_id(DragonBall1),
    Player2 = update_dragon_figure(Player1, FigureId),

    {ok, Player2}.

%% 更新各模块龙珠形象
%% 注:因为显示部位上是完全替代活跃度形象#figure.liveness,故龙珠形象在此延用此字段
%% @return #player_status{}
update_dragon_figure(Player, FigureId) ->
    #player_status{id = RoleId, figure = Figure, st_liveness = StLiveness} = Player,
    Figure1 = Figure#figure{liveness = FigureId},
    StLiveness1 = StLiveness#st_liveness{figure_id = FigureId},
    Player1 = Player#player_status{figure = Figure1, st_liveness = StLiveness1},

    lib_team_api:update_team_mb(Player1, [{figure, Figure1}]),
    lib_role:update_role_show(RoleId, [{figure, Figure1}]),
    mod_guild:update_guild_member_attr(RoleId, [{figure, Figure1}]),
    % mod_scene_agent:update(Player1, [{livenss, FigureId}]),
    lib_liveness:brocast_ps_attr(Player1),

    Player1.

%% 激活龙珠套装
%% @return {ok, #player_status{}} | {false, ErrCode :: integer()}
active_dragon_figure(Player, Type, Lv) ->
    #player_status{id = RoleId, dragon_ball = StatusDragonBall} = Player,
    case lib_dragon_ball_data:check_active_dragon_figure(StatusDragonBall, Type, Lv) of
        true ->
            #status_dragon_ball{figure_type = FigureType, figure_list = FigureList} = StatusDragonBall,
            FigureList1 = lists:keystore(Type, 1, FigureList, {Type, Lv}),

            StatusDragonBall1 = StatusDragonBall#status_dragon_ball{figure_list = FigureList1},
            StatusDragonBall2 = calc_dragon_attr_skills(StatusDragonBall1),
            lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, StatusDragonBall2),
            Player1 = Player#player_status{dragon_ball = StatusDragonBall2},

            Player2 = lib_player:count_player_attribute(Player1),
            lib_player:send_attribute_change_notify(Player2, ?NOTIFY_ATTR),
            mod_scene_agent:update(Player2, [{battle_attr, Player2#player_status.battle_attr}]),

            pp_dragon_ball:handle(14306, Player2, []),
            get_dragon_ball_list(Player2),
            send_dragon_figure_list(Player2),
            {ok, Player3} = ?IF(FigureType == Type, take_dragon_figure_on(Player2, Type), {ok, Player2}),

            send_active_dragon_figure_tv(Player2, Type, Lv),

            {ok, Player3};
        Err -> Err
    end.

%% 发送龙珠套装激活传闻
send_active_dragon_figure_tv(Player, Type, 1) -> % 激活时才需要传闻
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = Player,
    #base_dragon_ball_figure{name = FigureName, conditions = Conditions} = data_dragon_ball:get_dragon_figure(Type, 1),
    {_, N, _} = lists:keyfind(dragon_ball, 1, Conditions),
    lib_chat:send_TV({all}, ?MOD_DRAGON_BALL, 2, [RoleName, RoleId, N, FigureName]);

send_active_dragon_figure_tv(_, _, _) ->
    ok.

%% 计算龙珠的战力和下一级预览提升战力
%% @param Player :: #player_status{}
%%        DragonBallItems :: [{BallId, BallLv, _}, ...]
%% @return [{BallId, BallLv, Power, NextPower}, ...]
calc_dragon_ball_power(Player, DragonBallItems) ->
    #player_status{original_attr = OriginalAttr} = Player,
    F = fun({BallId, BallLv, _}, AccL) ->
        % 计算龙珠当前战力
        Power =
        case data_dragon_ball:get_dragon_ball(BallId, BallLv) of
            #base_dragon_ball{skill = Skill, attr = Attr} ->
                SkillPower = get_skill_power(Skill),
                SkillAttr = lib_skill:get_passive_skill_attr(Skill),
                AttrList = Attr++SkillAttr,
                lib_player:calc_partial_power(OriginalAttr, SkillPower, AttrList);
            _ ->
                AttrList = [],
                0
        end,

        % 计算龙珠下一级战力
        NextPower =
        case data_dragon_ball:get_dragon_ball(BallId, BallLv+1) of
            #base_dragon_ball{skill = Skill1, attr = Attr1} ->
                OriginalAttr1 = lib_player_attr:minus_attr(record, [OriginalAttr, AttrList]), % 先减去当前等级的属性
                SkillPower1 = get_skill_power(Skill1),
                SkillAttr1 = lib_skill:get_passive_skill_attr(Skill1),
                AttrList1 = Attr1++SkillAttr1,
                lib_player:calc_expact_power(OriginalAttr1, SkillPower1, AttrList1);
            _ ->
                0
        end,
        [{BallId, BallLv, Power, NextPower} | AccL]
    end,
    lists:foldl(F, [], DragonBallItems).

%% 计算龙珠套装的战力和下一级预览提升战力
%% @param FigureList :: [{FigureType, FigureLv},...]
%% @return [{FigureType, FigureLv, Power, NextPower},...]
calc_dragon_figure_power(Player, FigureList) ->
    #player_status{original_attr = OriginalAttr} = Player,
    F = fun({Type, Lv}, AccL) ->
        % 计算套装当前战力
        Power =
        case data_dragon_ball:get_dragon_figure(Type, Lv) of
            #base_dragon_ball_figure{attr = Attr1} ->
                lib_player:calc_partial_power(OriginalAttr, 0, Attr1);
            _ ->
                Attr1 = [],
                0
        end,

        % 计算套装下一级战力
        NextPower =
        case data_dragon_ball:get_dragon_figure(Type, Lv+1) of
            #base_dragon_ball_figure{attr = Attr2} ->
                OriginalAttr1 = lib_player_attr:minus_attr(record, [OriginalAttr, Attr1]), % 先减去当前等级的属性
                lib_player:calc_expact_power(OriginalAttr1, 0, Attr2);
            _ ->
                0
        end,
        [{Type, Lv, Power, NextPower} | AccL]
    end,
    lists:foldl(F, [], FigureList).

%% 计算龙珠系统属性和技能相关
%% @return #status_dragon_ball{}
calc_dragon_attr_skills(StatusDragonBall) ->
    StatusDragonBall0 = StatusDragonBall#status_dragon_ball{attr = [], skills = []},
    StatusDragonBall1 = calc_dragon_statue(StatusDragonBall0),
    StatusDragonBall2 = calc_dragon_balls(StatusDragonBall1),
    StatusDragonBall3 = calc_dragon_figure(StatusDragonBall2),
    StatusDragonBall3.

%% 计算雕像属性和技能相关
%% 注：仅由calc_dragon_attr_skills调用，若其它地方调用可能会造成属性或技能重复计算
%% @return #status_dragon_ball{}
calc_dragon_statue(#status_dragon_ball{statue = ?UNACTIVE} = Status) -> Status;

calc_dragon_statue(StatusDragonBall) ->
    #status_dragon_ball{attr = Attr, skills = Skills} = StatusDragonBall,
    SkillList = ?DRAGON_STATUE_SKILLS++Skills,
    SkillAttrL = lib_skill:get_passive_skill_attr(SkillList),
    SkillPower = get_skill_power(SkillList),
    StatusDragonBall#status_dragon_ball{
        attr = [{statue_attr, ?DRAGON_STATUE_ATTR} | Attr],
        skills = SkillList,
        skill_attr = SkillAttrL,
        skill_power = SkillPower
    }.

%% 计算龙珠属性、技能列表、技能属性、技能战力
%% 注：仅由calc_dragon_attr_skills调用，若其它地方调用可能会造成属性或技能重复计算
%% @return #status_dragon_ball{}
calc_dragon_balls(StatusDragonBall) ->
    #status_dragon_ball{items = Items, attr = Attr, skills = Skills} = StatusDragonBall,
    {Items1, BallAttrL, SkillList} = lists:foldl(fun calc_dragon_balls/2, {[], [], []}, Items),
    SkillList1 = SkillList++Skills,
    SkillAttrL = lib_skill:get_passive_skill_attr(SkillList1),
    SkillPower = get_skill_power(SkillList1),
    StatusDragonBall#status_dragon_ball{
        items = Items1,
        attr = [{ball_attr, BallAttrL} | Attr],
        skills = SkillList1,
        skill_attr = SkillAttrL,
        skill_power = SkillPower
    }.

calc_dragon_balls({BallId, BallLv, _}, {BallItems, BallAttrL, SkillList}) ->
    case data_dragon_ball:get_dragon_ball(BallId, BallLv) of
        #base_dragon_ball{skill = Skill, attr = Attr} ->
            % 单个龙珠战力在此不做计算，需要时才计算
            {[{BallId, BallLv, 0} | BallItems], Attr++BallAttrL, Skill++SkillList};
        _ ->
            {BallItems, BallAttrL, SkillList}
    end.

%% 计算神龙形象属性
%% 注：仅由calc_dragon_attr_skills调用，若其它地方调用可能会造成属性或技能重复计算
%% @return #status_dragon_ball{}
calc_dragon_figure(StatusDragonBall) ->
    #status_dragon_ball{attr = Attr, figure_list = FigureList} = StatusDragonBall,
    F = fun({Type, Lv}, AttrList) ->
        #base_dragon_ball_figure{attr = Attr1} = data_dragon_ball:get_dragon_figure(Type, Lv),
        Attr1++AttrList
    end,
    FigureAttr = lists:foldl(F, [], FigureList),
    StatusDragonBall#status_dragon_ball{
        attr = [{figure_attr, FigureAttr} | Attr]
    }.

calc_sum_sum_power(Ps) ->
    {AttrList, SkillPower} = get_skill_and_attr(Ps),
    lib_player:calc_partial_power(Ps#player_status.original_attr, SkillPower, AttrList).

send_star_nuclear(Player) ->
    #player_status{dragon_ball = StatusDragonBall, sid = Sid} = Player,
    #status_dragon_ball{items = Items, nuclear_buy = NuclearBuy} = StatusDragonBall,
    NuclearIds = data_dragon_ball:get_all_nuclear_id(),
    AlreadyBuy = [data_dragon_ball:get_nuclear_id_by_good(BallId) || {BallId, _, _} <- Items],
    OpenDay = util:get_open_day(),
    Now = utime:unixtime(),
    {Id, BuyTimes} = get_send_star_nuclear(NuclearIds -- AlreadyBuy, NuclearBuy, OpenDay, Now),
    lib_server_send:send_to_sid(Sid, pt_143, 14311, [Id, BuyTimes]),
    {ok, Player}.

get_send_star_nuclear([], _NuclearBuy, _OpenDay, _Now) -> {0, 0};
get_send_star_nuclear([Id | N], NuclearBuy, OpenDay, Now) ->
    #base_star_nuclear{send_id = SendId, open_day = CheckDay, times_limit = LimitTimes} = data_dragon_ball:get_star_nuclear(Id),
    {Id, BuyTimes, BuyTime} = ulists:keyfind(Id, 1, NuclearBuy, {Id, 0, 0}),
    case OpenDay >= CheckDay of
        true ->
            case SendId == Id of
                true ->
                    case check_has_buy_today(NuclearBuy, Id, Now) of
                        true -> {0, 0};
                        _ ->
                            SendTimes =
                                case utime:is_same_day(Now, BuyTime) of
                                    true -> BuyTimes;
                                    _ -> 0
                                end,
                            {Id, SendTimes}
                    end;
                _ ->
                    case LimitTimes > BuyTimes of
                        true -> {Id, BuyTimes};
                        _ -> get_send_star_nuclear(N, NuclearBuy, OpenDay, Now)
                    end
            end;
        _ -> {0, 0}
    end.

check_has_buy_today([], _Id, _Now) -> false;
check_has_buy_today([{Id, _, _Time} | N], Id, Now) ->
    check_has_buy_today(N, Id, Now);
check_has_buy_today([{_, _, Time} | N], Id, Now) ->
    case utime:is_same_day(Now, Time) of
        true -> true;
        _ -> check_has_buy_today(N, Id, Now)
    end.


gm_refresh_buy_time(Player) ->
    #player_status{id = RoleId, dragon_ball = StatusDragonBall} = Player,
    #status_dragon_ball{nuclear_buy = NuclearBuy} = StatusDragonBall,
    NewNuclearBuy = [{Id, State, 0} || {Id, State, _Time} <- NuclearBuy],
    NStatusDragonBall = StatusDragonBall#status_dragon_ball{nuclear_buy = NewNuclearBuy},
    lib_dragon_ball_data:db_replace_dragon_ball_statue(RoleId, NStatusDragonBall),
    LastPs = Player#player_status{dragon_ball = NStatusDragonBall},
    pp_dragon_ball:handle(14311, LastPs, []),
    LastPs.

%% 0:00刷新星核直购
refresh(_DelaySec) ->
    util:rand_time_to_delay(3000, lib_dragon_ball, refresh_data, []).

refresh_data() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_dragon_ball, send_star_nuclear, []) || E <- OnlineRoles].

%% 秘籍 - 激活玩家龙珠雕像
gm_active_dragon_statue(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, ?MODULE, active_dragon_statue, []).