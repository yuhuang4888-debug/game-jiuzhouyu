%% ---------------------------------------------------------------------------
%% @doc lib_supreme_vip.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-07-23
%% @deprecated 至尊vip
%% ---------------------------------------------------------------------------
-module(lib_supreme_vip).

-compile(export_all).

-include("server.hrl").
-include("supreme_vip.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("mount.hrl").
-include("def_module.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("rec_baby.hrl").
-include("def_fun.hrl").
-include("predefine.hrl").
-include("demons.hrl").
-include("attr.hrl").
-include("scene.hrl").
-include("daily.hrl").
-include("dragon.hrl").
-include("boss.hrl").

%% 结构
make_record(supvip_right, [RightType, Data, Utime]) ->
    #supvip_right{right_type = RightType, data = Data, utime = Utime};
make_record(supvip_skill_task, [TaskId, IsFinish, IsCommit, Content]) ->
    #supvip_skill_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content};
make_record(supvip_skill_effect, [SkillId, EffectId, Data, Utime]) ->
    #supvip_skill_effect{id = {SkillId, EffectId}, skill_id = SkillId, effect_id = EffectId, data = Data, utime = Utime};
make_record(supvip_currency_task, [TaskId, IsFinish, IsCommit, Content, Utime]) ->
    #supvip_currency_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content, utime = Utime}.

%% 登录
%% 注意:会设置定时器,只能登录的时候使用
load_status_supvip(RoleId) -> 
    case db_role_supvip_select(RoleId) of
        [SupvipType, SupvipTime, ActiveTime, ChargeDay, TodayGold, TodayGoldUtime, SkillStage, _SkillSubStage, DaysUtime, LoginDays] -> ok;
        [] -> 
            SupvipType = 0, SupvipTime = 0, ActiveTime = 0, ChargeDay = 0, TodayGold = 0, TodayGoldUtime = 0, 
            SkillStage = 0, DaysUtime = 0, LoginDays = 0
    end,
    % 特权
    DbRightList = db_role_supvip_right_select(RoleId),
    RightF = fun([RightType, DataBin, Utime]) -> 
        make_record(supvip_right, [RightType, util:bitstring_to_term(DataBin), Utime])
    end,
    RightList = lists:map(RightF, DbRightList),
    % 技能
    DbSkillTaskL = db_role_supvip_skill_task_select(RoleId),
    SkillTaskF = fun([TaskId, IsFinish, IsCommit, ContentBin]) ->
        make_record(supvip_skill_task, [TaskId, IsFinish, IsCommit, util:bitstring_to_term(ContentBin)])
    end,
    SkillTaskL = lists:map(SkillTaskF, DbSkillTaskL),
    % 子类型重新计算
    SkillSubStage = recalc_skill_sub_stage(SkillStage, SkillTaskL),
    % 技能效果
    DbSkillEffectL = db_role_supvip_skill_effect_select(RoleId),
    SkillEffectF = fun([SkillId, EffectId, DataBin, Utime]) ->
        make_record(supvip_skill_effect, [SkillId, EffectId, util:bitstring_to_term(DataBin), Utime])
    end,
    SkillEffectL = lists:map(SkillEffectF, DbSkillEffectL),
    % 至尊币任务
    DbCurrencyTaskL = db_role_supvip_currency_task_select(RoleId),
    CurrencyTaskF = fun([TaskId, IsFinish, IsCommit, ContentBin, Utime]) ->
        make_record(supvip_currency_task, [TaskId, IsFinish, IsCommit, util:bitstring_to_term(ContentBin), Utime])
    end,
    CurrencyTaskL = lists:map(CurrencyTaskF, DbCurrencyTaskL),
    SupVipStatus = #status_supvip{
        supvip_type = SupvipType, supvip_time = SupvipTime, active_time = ActiveTime, 
        charge_day = ChargeDay, today_gold = TodayGold, today_gold_utime = TodayGoldUtime, 
        right_list = RightList, skill_stage = SkillStage, skill_sub_stage = SkillSubStage, skill_task_list = SkillTaskL,
        skill_effect_list = SkillEffectL, currency_task_list = CurrencyTaskL, days_utime = DaysUtime, login_days = LoginDays
        },
    NewSupVipStatus = calc_attr(SupVipStatus),
    NewSupVipStatus.


%% 登录后再次处理(#status_supvip{}初始化完)
%% TODO:由于此处会发15714协议（至尊vip隔天登录,挂机的时间计算时异步计算，
%% TODO:会导致客户端限制的挂机时间不对(客户端显示优先级)，将after_login
%% TODO:改成异步触发， 本该改成用 ?EVENT_LOGIN_CAST 事件触发，但由于有
%% TODO:LoginType做参,直接使用lib_player_cast临时处理，待优化（该尽量减少进程发消息次数
after_login(Player, LoginType) ->
    lib_player:apply_cast(Player#player_status.id, ?APPLY_CAST_SAVE, ?MODULE, cast_after_login, [LoginType]),
    Player.

cast_after_login(Player, LoginType) ->
    % 计算属性
%%    PlayerAfAttr = calc_attr(Player),
    PlayerAfAttr = Player,
    case LoginType == ?NORMAL_LOGIN orelse LoginType == ?ONHOOK_AGENT_LOGIN of
        true ->
            % 天数
            PlayerAfDays = update_login_days(PlayerAfAttr),
            % 技能buff
            PlayerAfEffect = trigger_skill_effect(PlayerAfDays);
        false ->
            PlayerAfEffect = PlayerAfAttr
    end,
    % 自动升阶
    {_IsUp, PlayerAfUp} = auto_up_stage(PlayerAfEffect),
    % 触发
    PlayerAfRef = try_trigger_ex_ref(PlayerAfUp),
    {ok, PlayerAfRef}.

%% 重连
relogin(Player) ->
    % 天数
    PlayerAfDays = update_login_days(Player),
    % 技能buff
    PlayerAfEffect = trigger_skill_effect(PlayerAfDays),
    % 自动升阶
    {_IsUp, PlayerAfUp} = auto_up_stage(PlayerAfEffect),
    PlayerAfUp.

%% 更新天数
update_login_days(#player_status{id = RoleId, supvip = StatusSupVip} = Player) ->
    #status_supvip{supvip_type = SupvipType, days_utime = DaysUtime, login_days = LoginDays} = StatusSupVip,
    if
        SupvipType == ?SUPVIP_TYPE_NO -> Player;
        true ->
            case utime:is_today(DaysUtime) of
                true -> Player;
                false ->
                    NowDate = utime:standard_unixdate(),
                    NewLoginDays = LoginDays + 1,
                    NewStatusSupVip = StatusSupVip#status_supvip{login_days = NewLoginDays, days_utime = NowDate},
                    db_role_supvip_replace(RoleId, NewStatusSupVip),
                    PlayerAfSave = Player#player_status{supvip = NewStatusSupVip},
                    {ok, PlayerAfTrigger} = lib_supreme_vip_api:trigger_login_days(PlayerAfSave, NewLoginDays),
                    PlayerAfTrigger
            end
    end.

%% 添加蛮荒怒气
add_forbid_angle(Player) ->
    #player_status{id = RoleId, scene = SceneId} = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_FORBIDDEB_BOSS} ->
            AddAngle = lib_supreme_vip_api:get_anger_add(Player, ?BOSS_TYPE_FORBIDDEN),
            mod_boss:boss_anger_add(RoleId, ?BOSS_TYPE_FORBIDDEN, AddAngle);
        _ -> skip
    end.

%% 减少蛮荒怒气
reduce_forbid_angle(Player) ->
    #player_status{id = RoleId, scene = SceneId} = Player,
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_FORBIDDEB_BOSS} ->
            case data_supreme_vip:get_supreme_vip(?SUPVIP_TYPE_EX, ?SUPVIP_RIGHT_FORBIDDEN_ANGER) of
                #base_supreme_vip{value = Value} ->
                    mod_boss:boss_anger_reduce(RoleId, ?BOSS_TYPE_FORBIDDEN, Value);
                _ -> skip
            end;
        _ -> skip
    end.

%% 计算属性
calc_attr(StatusSupVip) when is_record(StatusSupVip, status_supvip) ->
    #status_supvip{skill_stage = Stage, skill_sub_stage = SubStage} = StatusSupVip,
    SupvipType = get_supvip_type(StatusSupVip),
    if
        SupvipType == ?SUPVIP_TYPE_NO ->
            NewStatusSupVip = StatusSupVip#status_supvip{
                skill_list = [], skill_attr = [], passive_skills = [], exp_ratio = 0, skill_power = 0, total_attr = []};
        true ->
            % 阶段属性
            StageAttr = calc_attr(Stage, SubStage),
            % 技能列表
            SkillList = calc_skill_list(Stage, SubStage),
            PassiveSkillAttr = lib_skill:get_passive_skill_attr(SkillList),
            PassiveSkill = lib_skill:divide_passive_skill(SkillList),
            SkillPower = lib_skill_api:get_skill_power(SkillList),
            % 总属性
            TotalAttr = util:combine_list(StageAttr ++ PassiveSkillAttr),
            case lists:keyfind(?EXP_ADD, 1, TotalAttr) of
                false -> SkillExpRatio = 0;
                {_, SkillExpRatio} -> skip
            end,
            NewStatusSupVip = StatusSupVip#status_supvip{
                skill_list = SkillList, skill_attr = PassiveSkillAttr, passive_skills = PassiveSkill,
                exp_ratio = SkillExpRatio, skill_power = SkillPower, total_attr = TotalAttr}
    end,
    NewStatusSupVip;
calc_attr(Player) when is_record(Player, player_status) ->
    #player_status{supvip = StatusSupVip} = Player,
    NewStatusSupVip = calc_attr(StatusSupVip),
    Player#player_status{supvip = NewStatusSupVip}.

%% 计算属性
calc_attr(Stage, SubStage) ->
    F = fun({TmpStage, TmpSubStage}, SumAttr) ->
        case Stage > TmpStage orelse (Stage == TmpStage andalso SubStage >= TmpSubStage) of
            true ->
                #base_supreme_vip_skill{attr = Attr} = data_supreme_vip:get_supreme_vip_skill(TmpStage, TmpSubStage),
                Attr ++ SumAttr;
            false ->
                SumAttr
        end
    end,
    KeyList = data_supreme_vip:get_supvip_skill_key_list(),
    util:combine_list(lists:foldl(F, [], KeyList)).
    
%% 计算技能
calc_skill_list(Stage, SubStage) ->
    F = fun({TmpStage, TmpSubStage}, SumSkillList) ->
        case Stage > TmpStage orelse (Stage == TmpStage andalso SubStage >= TmpSubStage) of
            true ->
                #base_supreme_vip_skill{skill_list = SkillList} = data_supreme_vip:get_supreme_vip_skill(TmpStage, TmpSubStage),
                SkillList ++ SumSkillList;
            false ->
                SumSkillList
        end
    end,
    KeyList = data_supreme_vip:get_supvip_skill_key_list(),
    lists:foldl(F, [], KeyList).

%% 获取经验加成
get_exp_ratio(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{exp_ratio = ExpRatio} = StatusSupVip,
    ExpRatio.

%% 触发技能效果
trigger_skill_effect(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_list = SkillList} = StatusSupVip,
    F = fun({SkillId, _Lv}, TmpPlayer) ->
        case data_supreme_vip:get_supreme_vip_skill_effect(SkillId) of
            #base_supreme_vip_skill_effect{effect_list = EffectList} ->
                do_trigger_skill_effect(EffectList, SkillId, TmpPlayer);
            _ -> 
                TmpPlayer
        end
    end,
    lists:foldl(F, Player, SkillList).

do_trigger_skill_effect([], _SkillId, Player) -> Player;
do_trigger_skill_effect([{EffectId=?SUPVIP_SKILL_EFFECT_ONHOOK_TIME, H}|T], SkillId, Player) when is_integer(H) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{skill_effect_list = SkillEffectL} = StatusSupVip,
    Key = {SkillId, EffectId},
    case lists:keyfind(Key, #supvip_skill_effect.id, SkillEffectL) of
        false -> SkillEffect = make_record(supvip_skill_effect, [SkillId, EffectId, [], 0]);
        SkillEffect -> ok
    end,
    #supvip_skill_effect{utime = Utime} = SkillEffect,
    case utime_logic:is_logic_same_day(Utime) of
        true -> PlayerAfOnhook = Player;
        false ->
            NewSkillEffect = SkillEffect#supvip_skill_effect{utime = utime:unixtime()},
            db_role_supvip_skill_effect_replace(RoleId, NewSkillEffect),
            NewSkillEffectL = lists:keystore(Key, #supvip_skill_effect.id, SkillEffectL, NewSkillEffect),
            NewStatusSupVip = StatusSupVip#status_supvip{skill_effect_list = NewSkillEffectL},
            PlayerAfSave = Player#player_status{supvip = NewStatusSupVip},
            {ok, PlayerAfOnhook} = lib_afk:add_afk_time(PlayerAfSave, H)
    end,
    do_trigger_skill_effect(T, SkillId, PlayerAfOnhook);
do_trigger_skill_effect([_H|T], SkillId, Player) ->
    do_trigger_skill_effect(T, SkillId, Player).

%% 离线加载
offine_load_status_supvip(RoleId) ->
    case db_role_supvip_offline_select(RoleId) of
        [SupvipType, SupvipTime, SkillStage, SkillSubStage] -> ok;
        _ -> SupvipType = 0, SupvipTime = 0, SkillStage = 0, SkillSubStage = 0
    end,
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime, skill_stage = SkillStage, skill_sub_stage = SkillSubStage}.

%% 离线登录数据
after_offine_login(Player) ->
    % 计算属性
    PlayerAfAttr = calc_attr(Player),
    PlayerAfAttr.

%% 登出
%% 清理定时器
logout(#player_status{supvip = StatusSupVip}) ->
    #status_supvip{ex_ref = ExRef} = StatusSupVip,
    util:cancel_timer(ExRef),
    ok.

%% 尝试触发体验定时器
try_trigger_ex_ref(#player_status{supvip = StatusSupVip} = Player) ->
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime, ex_ref = ExRef} = StatusSupVip,
    NowTime = utime:unixtime(),
    if
        SupvipType == ?SUPVIP_TYPE_EX andalso NowTime =< SupvipTime -> 
            RefTime = (SupvipTime - NowTime+1)*1000,
            NewExRef = util:send_after(ExRef, RefTime, self(), {'supvip_ex_ref'}),
            NewStatusSupVip = StatusSupVip#status_supvip{ex_ref = NewExRef},
            Player#player_status{supvip = NewStatusSupVip};
        true -> 
            util:cancel_timer(ExRef),
            NewStatusSupVip = StatusSupVip#status_supvip{ex_ref = none},
            Player#player_status{supvip = NewStatusSupVip}
    end.

%% 至尊vip体验定时器
supvip_ex_ref(#player_status{id = RoleId, figure = Figure, supvip = StatusSupVip} = Player) ->
    reduce_forbid_angle(Player),
    % ?MYLOG("hjhsupviptimeout", "RoleId:~p ~n", [RoleId]),
    IsSupvip = 0,
    NewFigure = Figure#figure{is_supvip = IsSupvip},
    #status_supvip{ex_ref = ExRef} = StatusSupVip,
    util:cancel_timer(ExRef),
    NewStatusSupVip = StatusSupVip#status_supvip{ex_ref = none},
    NewPlayer = Player#player_status{figure = NewFigure, supvip = NewStatusSupVip},
    % 派发事件
    lib_player_event:async_dispatch(RoleId, ?EVENT_SUPVIP),
    PlayerAfAttr = calc_attr(NewPlayer),
    % 同步战力
    PlayerAfCount = lib_player:count_player_attribute(PlayerAfAttr),
    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
    #player_status{battle_attr = BattleAttr, supvip = #status_supvip{skill_list = SkillList}} = PlayerAfCount,
    mod_scene_agent:update(PlayerAfCount, [{is_supvip, IsSupvip}, {battle_attr, BattleAttr}, {delete_passive_skill, SkillList}]),
    lib_scene:broadcast_player_attr(PlayerAfCount, [{10, IsSupvip}]),
    % 其他操作
    send_free_use_pk_safe(PlayerAfCount),
    {ok, PlayerAfCount}.

%% 重新计算子类型
recalc_skill_sub_stage(SkillStage, SkillTaskL) ->
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(SkillStage),
    length([1||#supvip_skill_task{task_id = TaskId, is_commit = IsCommit}<-SkillTaskL, IsCommit == ?SUPVIP_COMMIT_YES andalso lists:member(TaskId, TaskIdL)]).

%% ----------------------------------------------------
%% 协议处理
%% ----------------------------------------------------

%% 查看至尊vip信息
send_info(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime} = StatusSupVip,
    F = fun(RightType, TmpList) ->
        case make_right_for_client(RightType, Player) of
            false -> TmpList;
            RightClient -> [RightClient|TmpList]
        end
    end,
    NowSupvipType = get_supvip_type(StatusSupVip),
    RightTypeL = data_supreme_vip:get_supvip_right_type_list(NowSupvipType),
    ClientRightList = lists:foldl(F, [], RightTypeL),
    ChargeDay = get_charge_day(Player),
    TodayGold = get_today_gold(Player),
    % ?MYLOG("hjhsupvip", "send_info [SupvipType, SupvipTime, ClientRightList, ChargeDay, TodayGold]:~w ~n", 
    %     [[SupvipType, SupvipTime, ClientRightList, ChargeDay, TodayGold]]),
    IsFreeUse = is_free_use_pk_safe(Player),
    {ok, BinData} = pt_451:write(45101, [SupvipType, SupvipTime, ClientRightList, ChargeDay, TodayGold, IsFreeUse]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 打包特权信息的客户端数据
make_right_for_client(RightType = ?SUPVIP_RIGHT_DAILY_REWARD, Player) ->
    RewardStatus = get_right_reward_status(Player, RightType),
    #supvip_right{utime = Utime} = get_supvip_right(Player, RightType),
    {RightType, util:term_to_string([RewardStatus]), Utime};
make_right_for_client(_RightType, _Player) ->
    false.

%% 获取特权领取奖励
get_right_reward_status(Player, RightType) when 
        RightType == ?SUPVIP_RIGHT_DAILY_REWARD;
        RightType == ?SUPVIP_RIGHT_PK_SAFE ->
    IsHaveRight = is_have_right(Player, RightType),
    #supvip_right{utime = Utime} = get_supvip_right(Player, RightType),
    IsToday = utime:is_today(Utime),
    if
        IsToday -> ?SUPVIP_HAD_GET;
        IsHaveRight == false -> ?SUPVIP_CAN_NOT_GET;
        true -> ?SUPVIP_CAN_GET
    end;
get_right_reward_status(_Player, _RightType) ->
    ?SUPVIP_CAN_NOT_GET.

%% 获取当前的至尊类型
get_supvip_type(#player_status{supvip = StatusSupVip}) ->
    get_supvip_type(StatusSupVip);
get_supvip_type(StatusSupVip) ->
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime} = StatusSupVip,
    get_supvip_type(SupvipType, SupvipTime).

%% 是否超级vip
is_supvip(StatusSupVip) ->
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime} = StatusSupVip,
    is_supvip(SupvipType, SupvipTime).

%% 是否超级vip
is_supvip(SupvipType, SupvipTime) ->
    NewSupvipType = get_supvip_type(SupvipType, SupvipTime),
    if
        NewSupvipType == ?SUPVIP_TYPE_NO -> 0;
        true -> 1
    end.

%% 是否超级vip##给figure使用,不能根据时间计算
get_supvip_type(SupvipType, SupvipTime) -> 
    NowTime = utime:unixtime(),
    if
        SupvipType == ?SUPVIP_TYPE_FOREVER -> SupvipType;
        SupvipType == ?SUPVIP_TYPE_EX andalso NowTime < SupvipTime -> SupvipType;
        true -> ?SUPVIP_TYPE_NO
    end.

%% 获得特权##会根据特权重新计算
get_supvip_right(Player, RightType) when 
        RightType == ?SUPVIP_RIGHT_DAILY_REWARD;
        RightType == ?SUPVIP_RIGHT_PK_SAFE ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{right_list = RightList} = StatusSupVip,
    % 每天零点重置数据
    case lists:keyfind(RightType, #supvip_right.right_type, RightList) of
        false -> #supvip_right{right_type = RightType, data = [], utime = 0};
        #supvip_right{utime = Utime} = Right -> 
            case utime:is_today(Utime) of
                true -> Right;
                false -> #supvip_right{right_type = RightType, data = [], utime = 0}
            end
    end;
get_supvip_right(_Player, _RightType) ->
    false.

%% 是否拥有特权
is_have_right(Player, RightType) ->
    SupvipType = get_supvip_type(Player),
    RightTypeL = data_supreme_vip:get_supvip_right_type_list(SupvipType),
    lists:member(RightType, RightTypeL).

%% 计算充值天数
get_charge_day(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{charge_day = ChargeDay, today_gold = TodayGold} = StatusSupVip,
    get_charge_day(ChargeDay, TodayGold).

get_charge_day(ChargeDay, TodayGold) ->
    {NeedGold, _NeedDay} = ?SUPVIP_KV_UP_FOREVER_RECHARGE,
    case TodayGold >= NeedGold of
        true -> ChargeDay + 1;
        false -> ChargeDay
    end.

%% 获取今天充值数
get_today_gold(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{today_gold = TodayGold, today_gold_utime = TodayGoldUtime} = StatusSupVip,
    case utime:is_today(TodayGoldUtime) of
        true -> TodayGold;
        false -> 0
    end.

%% 查看技能任务
send_skill_task_info(OldPlayer) ->
    Player = auto_trigger_skill_task(OldPlayer),
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, skill_sub_stage = SubStage} = StatusSupVip,
    F = fun(TaskId) ->
        #base_supreme_vip_skill_task{content = Content} = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
        SkillTask = get_skill_task(Player, TaskId),
        make_skill_task_for_client(SkillTask, Content)
    end,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    List = lists:map(F, TaskIdL),
    % ?MYLOG("hjhsupvip", "send_skill_task_info Stage:~p, SubStage:~p, List:~w ~n", [Stage, SubStage, List]),
    {ok, BinData} = pt_451:write(45102, [Stage, SubStage, List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, Player}.

%% 构造
make_skill_task_for_client(SkillTask, CfgContent) ->
    #supvip_skill_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content} = SkillTask,
    R = do_make_skill_task_for_client(CfgContent, Content, []),
    % ?MYLOG("hjhsupvip", "make_skill_task_for_client TaskId:~w, IsFinish:~w, IsCommit:~w, R:~w ~n", [TaskId, IsFinish, IsCommit, R]),
    {TaskId, IsFinish, IsCommit, util:term_to_string(R)}.

do_make_skill_task_for_client([], _Content, R) -> R;
do_make_skill_task_for_client([{TaskType, _N, _M, _Y}|T], Content, R) -> 
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    do_make_skill_task_for_client(T, Content, [{TaskType, Num}|R]);
do_make_skill_task_for_client([{TaskType, _N, _M}|T], Content, R) -> 
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    do_make_skill_task_for_client(T, Content, [{TaskType, Num}|R]);
do_make_skill_task_for_client([{TaskType, _N}|T], Content, R) -> 
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        {TaskType, Num, _Utime} -> ok;
        _ -> Num = 0
    end,
    do_make_skill_task_for_client(T, Content, [{TaskType, Num}|R]);
do_make_skill_task_for_client([_H|T], Content, R) -> 
    do_make_skill_task_for_client(T, Content, R).

%% 技能任务
get_skill_task(Player, TaskId) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_task_list = TaskList} = StatusSupVip,
    case lists:keyfind(TaskId, #supvip_skill_task.task_id, TaskList) of
        false -> #supvip_skill_task{task_id = TaskId};
        SkillTask -> SkillTask
    end.

%% 提交技能任务
commit_skill_task(#player_status{id = RoleId, supvip = StatusSupVip} = Player, TaskId) ->
    case check_commit_skill(Player, TaskId) of
        {false, ErrCode} -> IsUp = false, PlayerAfAuto = Player;
        {true, SkillTask, BaseSkillTask} ->
            F = fun() ->
                #status_supvip{skill_stage = SkillStage, skill_task_list = SkillTaskL} = StatusSupVip,
                NewSkillTask = SkillTask#supvip_skill_task{is_commit = ?SUPVIP_COMMIT_YES},
                db_role_supvip_skill_task_replace(RoleId, NewSkillTask),
                NewSkillTaskL = lists:keystore(TaskId, #supvip_skill_task.task_id, SkillTaskL, NewSkillTask),
                SubStage = recalc_skill_sub_stage(SkillStage, NewSkillTaskL),
                NewStatusSupVip = StatusSupVip#status_supvip{skill_sub_stage = SubStage, skill_task_list = NewSkillTaskL},
                db_role_supvip_replace(RoleId, NewStatusSupVip),
                {ok, NewStatusSupVip}
            end,
            case db:transaction(F) of
                {ok, NewStatusSupVip} ->
                    ErrCode = ?SUCCESS,
                    #status_supvip{skill_stage = SkillStage, skill_sub_stage = SubStage} = NewStatusSupVip,
                    NewPlayer = Player#player_status{supvip = NewStatusSupVip},
                    #base_supreme_vip_skill_task{reward = Reward} = BaseSkillTask,
                    Produce = #produce{type = supvip_skill_task, reward = Reward, remark = integer_to_list(TaskId)},
                    PlayerAfReward = lib_goods_api:send_reward(NewPlayer, Produce),
                    PlayerAfAttr = calc_attr(PlayerAfReward),
                    % 同步战力
                    PlayerAfCount = lib_player:count_player_attribute(PlayerAfAttr),
                    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
                    #player_status{battle_attr = BattleAttr, supvip = #status_supvip{passive_skills = NewPassveSkill}} = PlayerAfCount,
                    mod_scene_agent:update(PlayerAfCount, [{battle_attr, BattleAttr}, {passive_skill, NewPassveSkill}]),
                    % 技能buff
                    PlayerAfEffect = trigger_skill_effect(PlayerAfCount),
                    lib_log_api:log_supvip_skill_task(RoleId, SkillStage, SubStage, TaskId, Reward),
                    ta_agent_fire:log_supvip_skill_task(Player, [SkillStage, SubStage, TaskId]),
                    % 自动升阶
                    {IsUp, PlayerAfAuto} = auto_up_stage(PlayerAfEffect);
                _Error ->
                    ErrCode = ?FAIL, IsUp = false,
                    ?ERR("_R:~p ~n", [_Error]),
                    PlayerAfAuto = Player
            end
    end,
    % ?MYLOG("hjhsupvip", "ErrCode:~p, TaskId:~p ~n", [ErrCode, TaskId]),
    case ErrCode == ?SUCCESS of
        true -> 
            IsMax = is_max_stage_and_sub(PlayerAfAuto),
            IsUpInt = ?IF(IsUp orelse IsMax, 1, 0);
        false -> 
            IsUpInt = 0
    end,
    {ok, BinData} = pt_451:write(45103, [ErrCode, TaskId, IsUpInt]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfAuto}.

%% 检查是否能提交任务
check_commit_skill(Player, TaskId) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, skill_sub_stage = SubStage} = StatusSupVip,
    BaseSkillTask = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
    BaseSupvipSkill = data_supreme_vip:get_supreme_vip_skill(Stage, SubStage+1),
    SkillTask = get_skill_task(Player, TaskId),
    SupvipType = get_supvip_type(Player),
    if
        SupvipType == ?SUPVIP_TYPE_NO -> {false, ?ERRCODE(err451_this_supvip_type_not_to_commit)};
        is_record(BaseSkillTask, base_supreme_vip_skill_task) == false -> {false, ?MISSING_CONFIG};
        is_record(BaseSupvipSkill, base_supreme_vip_skill) == false -> {false, ?MISSING_CONFIG};
        SkillTask#supvip_skill_task.is_finish == ?SUPVIP_FINISH_NO -> {false, ?ERRCODE(err451_no_finish)};
        SkillTask#supvip_skill_task.is_commit == ?SUPVIP_COMMIT_YES -> {false, ?ERRCODE(err451_had_commit)};
        true -> {true, SkillTask, BaseSkillTask}
    end.

%% 自动升阶
%% @return {IsUp, Player}
auto_up_stage(Player) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, skill_sub_stage = SubStage} = StatusSupVip,
    SubStageList = data_supreme_vip:get_supvip_skill_sub_stage_list(Stage),
    case SubStageList == [] of
        true -> IsMax = false;
        false -> IsMax = lists:max(SubStageList) == SubStage
    end,
    NewStage = Stage + 1,
    BaseSupvipSkill = data_supreme_vip:get_supreme_vip_skill(NewStage, 1),
    if
        IsMax == false -> {false, Player};
        is_record(BaseSupvipSkill, base_supreme_vip_skill) == false -> {false, Player};
        true ->
            F = fun() ->
                NewStatusSupVip = StatusSupVip#status_supvip{skill_stage = NewStage, skill_sub_stage = 0, skill_task_list = []},
                % 保存阶数,删除旧任务
                db_role_supvip_replace(RoleId, NewStatusSupVip),
                db_role_supvip_skill_task_delete(RoleId),
                {ok, NewStatusSupVip}
            end,
            case catch db:transaction(F) of
                {ok, NewStatusSupVip} ->
                    NewPlayer = Player#player_status{supvip = NewStatusSupVip},
                    PlayerAfAuto = auto_trigger_skill_task(NewPlayer),
                    lib_log_api:log_supvip_skill_task(RoleId, NewStage, 0, 0, []),
                    ta_agent_fire:log_supvip_skill_task(Player, [NewStage, 0, 0]),
                    {true, PlayerAfAuto};
                _Error ->
                    ?ERR("_R:~p ~n", [_Error]),
                    {false, Player}
            end
    end.

%% 是不是达到最大阶数和子阶数
is_max_stage_and_sub(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, skill_sub_stage = SubStage} = StatusSupVip,
    StageList = data_supreme_vip:get_supvip_skill_stage_list(),
    case StageList == [] of
        true -> false;
        false -> 
            MaxStage = lists:max(StageList),
            SubStageList = data_supreme_vip:get_supvip_skill_sub_stage_list(MaxStage),
            case SubStageList == [] of
                true -> false;
                false -> 
                    MaxSubStage = lists:max(SubStageList),
                    Stage == MaxStage andalso SubStage == MaxSubStage
            end
    end.

%% 发送至尊币任务
send_currency_task_info(OldPlayer) ->
    PlayerAfDel = auto_del_timeout_currency_task(OldPlayer),
    Player = auto_trigger_currency_task(PlayerAfDel),
    F = fun(TaskId, TmpList) ->
        #base_supreme_vip_currency_task{condition = Condition, content = Content} = data_supreme_vip:get_supreme_vip_currency_task(TaskId),
        case check_currency_task_open(Condition, Player) of
            true -> 
                CurrencyTask = get_currency_task(Player, TaskId),
                [make_currency_task_for_client(CurrencyTask, Content)|TmpList];
            {false, _ErrCode} ->
                TmpList
        end
    end,
    TaskIdL = data_supreme_vip:get_supvip_currency_task_id_list(),
    List = lists:foldl(F, [], TaskIdL),
    {ok, BinData} = pt_451:write(45104, [List]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    % ?MYLOG("hjhsupvipcurrency", "send_currency_task_info List:~w ~n", [List]),
    {ok, Player}.

%% 至尊币任务
get_currency_task(Player, TaskId) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{currency_task_list = CurrencyTaskL} = StatusSupVip,
    NowTime = utime:unixtime(),
    case lists:keyfind(TaskId, #supvip_currency_task.task_id, CurrencyTaskL) of
        false -> #supvip_currency_task{task_id = TaskId, utime = NowTime};
        #supvip_currency_task{utime = Utime} = CurrencyTask -> 
            case utime:is_same_day(NowTime, Utime) of
                true -> CurrencyTask;
                false -> #supvip_currency_task{task_id = TaskId, utime = NowTime}
            end
    end.

%% 删除过期
auto_del_timeout_currency_task(Player) -> 
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{currency_task_list = CurrencyTaskL} = StatusSupVip,
    UnixDate = utime:standard_unixdate(),
    F = fun(#supvip_currency_task{utime = Utime}) -> Utime =< UnixDate end,
    {Satisfying, NotSatisfying} = lists:partition(F, CurrencyTaskL),
    case Satisfying == [] of
        true -> skip;
        false -> db_role_supvip_currency_task_delete(RoleId, UnixDate)
    end,
    % ?MYLOG("hjhsupvipcurrency", "auto_del_timeout_currency_task Satisfying:~w, NotSatisfying:~w ~n", [Satisfying, NotSatisfying]),
    NewStatusSupVip = StatusSupVip#status_supvip{currency_task_list = NotSatisfying},
    Player#player_status{supvip = NewStatusSupVip}.

%% 检查任务是否开启
check_currency_task_open([], _Player) -> true;
check_currency_task_open([{lv, NeedLv}|T], Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case Lv >= NeedLv of
        true -> check_currency_task_open(T, Player);
        false -> {false, ?LEVEL_LIMIT}
    end;
check_currency_task_open([{lv, DownLv, UpLv}|T], Player) ->
    #player_status{figure = #figure{lv = Lv}} = Player,
    case Lv >= DownLv andalso Lv =< UpLv of
        true -> check_currency_task_open(T, Player);
        false -> {false, ?LEVEL_LIMIT}
    end;
check_currency_task_open([{open_day, StartOpenDay, EndOpenDay}|T], Player) ->
    OpenDay = util:get_open_day(),
    case OpenDay >= StartOpenDay andalso OpenDay =< EndOpenDay of
        true -> check_currency_task_open(T, Player);
        false -> {false, ?ERRCODE(err451_not_enough_open_day)}
    end.

%% 构造
make_currency_task_for_client(CurrencyTask, CfgContent) ->
    #supvip_currency_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content} = CurrencyTask,
    R = do_make_currency_task_for_client(CfgContent, Content, []),
    % ?MYLOG("hjhsupvipcurrency", "make_skill_task_for_client TaskId:~w, IsFinish:~w, IsCommit:~w, R:~w ~n", [TaskId, IsFinish, IsCommit, R]),
    {TaskId, IsFinish, IsCommit, util:term_to_string(R)}.

do_make_currency_task_for_client([], _Content, R) -> R;
do_make_currency_task_for_client([{TaskType, _N, _M}|T], Content, R) -> 
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    do_make_currency_task_for_client(T, Content, [{TaskType, Num}|R]);
do_make_currency_task_for_client([{TaskType, _N}|T], Content, R) -> 
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    do_make_currency_task_for_client(T, Content, [{TaskType, Num}|R]);
do_make_currency_task_for_client([_H|T], Content, R) ->
    do_make_currency_task_for_client(T, Content, R).

%% 提交至尊币任务
commit_currency_task(#player_status{id = RoleId, supvip = StatusSupVip} = Player, TaskId) ->
    case check_commit_currency_task(Player, TaskId) of
        {false, ErrCode} -> PlayerAfReward = Player;
        {true, CurrencyTask, Reward} ->
            ErrCode = ?SUCCESS,
            #status_supvip{currency_task_list = CurrencyTaskL} = StatusSupVip,
            NewCurrencyTask = CurrencyTask#supvip_currency_task{is_commit = ?SUPVIP_COMMIT_YES},
            db_role_supvip_currency_task_replace(RoleId, NewCurrencyTask),
            NewCurrencyTaskL = lists:keystore(TaskId, #supvip_currency_task.task_id, CurrencyTaskL, NewCurrencyTask),
            NewStatusSupVip = StatusSupVip#status_supvip{currency_task_list = NewCurrencyTaskL},
            NewPlayer = Player#player_status{supvip = NewStatusSupVip},
            Produce = #produce{type = supvip_currency_task, reward = Reward, remark = integer_to_list(TaskId)},
            PlayerAfReward = lib_goods_api:send_reward(NewPlayer, Produce),
            lib_log_api:log_supvip_currency_task(RoleId, TaskId, Reward),
            ta_agent_fire:log_supvip_currency_task(Player, [TaskId])
    end,
    {ok, BinData} = pt_451:write(45105, [ErrCode, TaskId]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfReward}.

check_commit_currency_task(Player, TaskId) ->
    BaseCurrencyTask = data_supreme_vip:get_supreme_vip_currency_task(TaskId),
    CurrencyTask = get_currency_task(Player, TaskId),
    SupvipType = get_supvip_type(Player),
    if
        SupvipType == ?SUPVIP_TYPE_NO -> {false, ?ERRCODE(err451_this_supvip_type_not_to_commit)};
        is_record(BaseCurrencyTask, base_supreme_vip_currency_task) == false -> {false, ?MISSING_CONFIG};
        CurrencyTask#supvip_currency_task.is_finish == ?SUPVIP_FINISH_NO -> {false, ?ERRCODE(err451_no_finish)};
        CurrencyTask#supvip_currency_task.is_commit == ?SUPVIP_COMMIT_YES -> {false, ?ERRCODE(err451_had_commit)};
        true -> 
            #base_supreme_vip_currency_task{condition = Condition, reward = Reward} = BaseCurrencyTask,
            case check_currency_task_open(Condition, Player) of
                {false, ErrCode} -> {false, ErrCode};
                true -> 
                    case lib_goods_api:can_give_goods(Player, Reward) of
                        {false, ErrCode} -> {false, ErrCode};
                        true -> {true, CurrencyTask, Reward}
                    end
            end
    end.

%% 购买体验
buy_ex(Player) ->
    case check_buy_ex(Player) of
        {false, ErrCode} -> PlayerAfBuy = Player;
        {true, Cost} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, supvip_buy_ex, "") of
                {false, ErrCode, PlayerAfBuy} -> ok;
                {true, PlayerAfCost} -> 
                    ErrCode = ?SUCCESS,
                    PlayerAfBuy = do_buy_ex(PlayerAfCost, Cost) 
            end
    end,
    {ok, BinData} = pt_451:write(45106, [ErrCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    % ?MYLOG("hjhsupvip", "buy_ex ErrCode:~w ~n", [ErrCode]),
    {ok, PlayerAfBuy}.

%% 检查购买体验
check_buy_ex(Player) ->
    #player_status{figure = #figure{lv = Lv, vip = VipLv}, supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType} = StatusSupVip,
    NeedLv = ?SUPVIP_KV_BUY_EX_NEED_LV,
    NeedVipLv = ?SUPVIP_KV_BUY_EX_NEED_VIP_LV,
    if
        SupvipType =/= ?SUPVIP_TYPE_NO -> {false, ?ERRCODE(err451_had_buy_ex)};
        Lv < NeedLv -> {false, ?ERRCODE(err451_not_enough_lv_to_buy_ex)};
        VipLv < NeedVipLv -> {false, ?ERRCODE(err451_not_enough_vip_to_buy_ex)};
        true -> {true, ?SUPVIP_KV_EX_COST}
    end.

do_buy_ex(#player_status{id = RoleId, figure = Figure, supvip = StatusSupVip} = Player, Cost) ->
    NowTime = utime:unixtime(),
    % 存储
    SupvipType = ?SUPVIP_TYPE_EX, SupvipTime = NowTime+?SUPVIP_KV_EX_TIME,
    TodayGold = lib_recharge_data:get_today_pay_gold(RoleId),
    NewStatusSupVip = StatusSupVip#status_supvip{
        supvip_type = SupvipType, supvip_time = SupvipTime, active_time = NowTime, 
        today_gold = TodayGold, today_gold_utime = NowTime
        },
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    % 传闻
    #figure{name = Name} = Figure,
    lib_chat:send_TV({all}, ?MOD_SUPVIP, 1, [Name, RoleId]),
    IsSupvip = is_supvip(SupvipType, SupvipTime),
    NewFigure = Figure#figure{is_supvip = IsSupvip},
    PlayerAfBuy = Player#player_status{figure = NewFigure, supvip = NewStatusSupVip},
    log_supvip_active(PlayerAfBuy, 1, Cost),
    % 同步场景
    mod_scene_agent:update(PlayerAfBuy, [{is_supvip, IsSupvip}]),
    lib_scene:broadcast_player_attr(PlayerAfBuy, [{10, IsSupvip}]),
    % 派发事件
    lib_player_event:async_dispatch(RoleId, ?EVENT_SUPVIP),
    PlayerAfDays = update_login_days(PlayerAfBuy),
    PlayerAfRef = try_trigger_ex_ref(PlayerAfDays),
    add_forbid_angle(PlayerAfRef),
    PlayerAfRef.

%% 购买至尊vip永久
buy_forever(Player) ->
    case check_buy_forever(Player) of
        {false, ErrCode} -> PlayerAfBuy = Player;
        {true, Cost} ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, supvip_buy_forever, "") of
                {false, ErrCode, PlayerAfBuy} -> ok;
                {true, PlayerAfCost} -> 
                    ErrCode = ?SUCCESS,
                    PlayerAfBuy = do_buy_forever(PlayerAfCost, Cost) 
            end
    end,
    {ok, BinData} = pt_451:write(45107, [ErrCode]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfBuy}.

check_buy_forever(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType} = StatusSupVip,
    if
        SupvipType =/= ?SUPVIP_TYPE_EX -> {false, ?ERRCODE(err451_first_buy_ex)};
        true -> {true, ?SUPVIP_KV_UP_FOREVER_COST}
    end.

do_buy_forever(#player_status{id = RoleId, figure = Figure, supvip = StatusSupVip} = Player, Cost) ->
    #status_supvip{ex_ref = ExRef} = StatusSupVip,
    util:cancel_timer(ExRef),
    SupvipType = ?SUPVIP_TYPE_FOREVER,
    NewStatusSupVip = StatusSupVip#status_supvip{supvip_type = SupvipType},
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    #figure{name = Name} = Figure,
    lib_chat:send_TV({all}, ?MOD_SUPVIP, 2, [Name, RoleId]),
    IsSupvip  = is_supvip(SupvipType, 0),
    NewFigure = Figure#figure{is_supvip = IsSupvip},
    NewPlayer = Player#player_status{figure = NewFigure, supvip = NewStatusSupVip},
    log_supvip_active(NewPlayer, 2, Cost),
    % 派发事件
    lib_player_event:async_dispatch(RoleId, ?EVENT_SUPVIP),
    PlayerAfAttr = calc_attr(NewPlayer),
    % 同步战力
    PlayerAfCount = lib_player:count_player_attribute(PlayerAfAttr),
    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
    #player_status{battle_attr = BattleAttr, supvip = #status_supvip{passive_skills = NewPassveSkill}} = PlayerAfCount,
    mod_scene_agent:update(PlayerAfCount, [{is_supvip, IsSupvip}, {battle_attr, BattleAttr}, {passive_skill, NewPassveSkill}]),
    lib_scene:broadcast_player_attr(PlayerAfCount, [{10, IsSupvip}]),
    % ?INFO("do_buy_forever Scene:~p X:~p Y:~p SupvipType:~w IsSupvip:~w ~n", [Scene, X, Y, SupvipType, IsSupvip]),
    % 技能buff
    PlayerAfEffect = trigger_skill_effect(PlayerAfCount),
    case StatusSupVip#status_supvip.supvip_type of
        ?SUPVIP_TYPE_EX -> skip;
        _ -> add_forbid_angle(PlayerAfEffect)
    end,
    PlayerAfEffect.

%% 领取特权奖励
handle_get_right_reward(Player, RightType) ->
    case check_handle_get_right_reward(Player, RightType) of
        {false, ErrCode} -> PlayerAfReward = Player;
        {true, Reward} ->
            ErrCode = ?SUCCESS,
            #player_status{id = RoleId, supvip = StatusSupVip} = Player,
            #status_supvip{right_list = RightList} = StatusSupVip,
            case lists:keyfind(RightType, #supvip_right.right_type, RightList) of
                false -> Right = #supvip_right{right_type = RightType, data = [], utime = utime:unixtime()};
                OldRight -> Right = OldRight#supvip_right{right_type = RightType, data = [], utime = utime:unixtime()}
            end,
            db_role_supvip_right_replace(RoleId, Right),
            NewRightList = lists:keystore(RightType, #supvip_right.right_type, RightList, Right),
            NewStatusSupVip = StatusSupVip#status_supvip{right_list = NewRightList},
            NewPlayer = Player#player_status{supvip = NewStatusSupVip},
            Produce = #produce{type = supvip_right_reward, reward = Reward, remark = integer_to_list(RightType)},
            PlayerAfReward = lib_goods_api:send_reward(NewPlayer, Produce)
    end,
    ?PRINT("handle_get_right_reward ErrCode:~p RightType:~p ~p ~n", [ErrCode, RightType, get_right_reward_status(Player, RightType)]),
    {ok, BinData} = pt_451:write(45108, [ErrCode, RightType]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    {ok, PlayerAfReward}.

check_handle_get_right_reward(Player, RightType) when 
        RightType == ?SUPVIP_RIGHT_DAILY_REWARD ->
    #player_status{supvip = StatusSupVip} = Player,
    SupvipType = get_supvip_type(StatusSupVip),
    BaseSupvip = data_supreme_vip:get_supreme_vip(SupvipType, RightType),
    if
        is_record(BaseSupvip, base_supreme_vip) == false -> {false, ?MISSING_CONFIG};
        true ->
            #base_supreme_vip{args = Args} = BaseSupvip,
            case get_right_reward_status(Player, RightType) of
                ?SUPVIP_CAN_NOT_GET -> {false, ?ERRCODE(err451_can_not_get)};
                ?SUPVIP_HAD_GET -> {false, ?ERRCODE(err451_had_get)};
                ?SUPVIP_CAN_GET -> {true, Args};
                _ -> {false, ?FAIL}
            end
    end;
check_handle_get_right_reward(_Player, _RightType) ->
    {false, ?FAIL}.

%% ----------------------------------------------------
%% 触发
%% ----------------------------------------------------

%% ----------------------------------------------------
%% 技能任务
%% ----------------------------------------------------

%% 自动检查技能任务
auto_trigger_skill_task(#player_status{id = RoleId, supvip = StatusSupVip} = Player) ->
    #status_supvip{skill_stage = Stage, skill_task_list = OldSkillTaskList} = StatusSupVip,
    F = fun(TaskId, TmpList) ->
        #base_supreme_vip_skill_task{content = Content} = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
        SkillTask = get_skill_task(Player, TaskId),
        {IsUpdate, NewSkillTask} = check_skill_task_content(Player, SkillTask, Content),
        case IsUpdate == true of
            true -> db_role_supvip_skill_task_replace(RoleId, NewSkillTask);
            false -> skip
        end,
        lists:keystore(TaskId, #supvip_skill_task.task_id, TmpList, NewSkillTask)
    end,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    SkillTaskL = lists:foldl(F, OldSkillTaskList, TaskIdL),
    NewStatusSupVip = StatusSupVip#status_supvip{skill_task_list = SkillTaskL},
    Player#player_status{supvip = NewStatusSupVip}.

%% 检查内容是否更新
%% @return {IsUpdate, SkillTask}
check_skill_task_content(Player, SkillTask, Content) ->
    case SkillTask#supvip_skill_task.is_finish == ?SUPVIP_FINISH_YES of
        true -> {false, SkillTask};
        false -> do_check_skill_task_content(Content, Player, true, false, SkillTask)
    end.

%% 通用检查
do_check_skill_task_content([], _Player, IsFinish, IsUpdate, SkillTask) -> 
    case IsFinish of
        true -> {true, SkillTask#supvip_skill_task{is_finish = ?SUPVIP_FINISH_YES}};
        false -> {IsUpdate, SkillTask}
    end;

% N件装备强化+M以上##{1,N,M}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_EQUIP_STREN, NeedNum, StrenNum}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #goods_status{stren_award_list = StrenAwardList} = lib_goods_do:get_goods_status(),
    {CheckNum, Num} = calc_equip_pre_num(StrenAwardList, NeedNum, StrenNum, 0),
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Num}),
    do_check_skill_task_content(T, Player, IsFinish andalso CheckNum, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% M养成功能升阶至N阶##{2,N,M}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_TRAIN, NeedStage, MountType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #player_status{status_mount = StatusMount} = Player,
    case lists:keyfind(MountType, #status_mount.type_id, StatusMount) of
        #status_mount{stage = Stage} -> ok;
        _ -> Stage = 0
    end,
    StageBool = Stage >= NeedStage,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Stage}),
    do_check_skill_task_content(T, Player, IsFinish andalso StageBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 通关符文本第N层##{3,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_RUNE_DUN, NeedLevel}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Level = lib_dungeon_rune:get_dungeon_level(Player),
    LevelBool = Level >= NeedLevel,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Level}),
    do_check_skill_task_content(T, Player, IsFinish andalso LevelBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 完成N次M副本(材料、金币、经验)##{4,N,M}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DUN_COUNT, NeedCount, _DunType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> ok;
        _ -> Count = 0
    end,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 勋章提升至N阶##{5,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_MEDAL_ID, NeedMedalId}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #player_status{figure = #figure{medal_id = MedelId}} = Player,
    #supvip_skill_task{content = Content} = SkillTask,
    MedelIdBool = MedelId >= NeedMedalId,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, MedelId}),
    do_check_skill_task_content(T, Player, IsFinish andalso MedelIdBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 充值任意金额N天##{6,N}##{6,N,更新时间}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_RECHARGE, NeedDay}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #player_status{id = RoleId} = Player,
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Day, Utime} -> OneIsUpdate = false;
        _ -> 
            Gold = lib_recharge_data:get_today_pay_gold(RoleId),
            case Gold > 0 of
                true -> Day = 1, Utime = utime:unixtime();
                false -> Day = 0, Utime = 0
            end,
            OneIsUpdate = true
    end,
    DayBool = Day >= NeedDay,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Day, Utime}),
    do_check_skill_task_content(T, Player, IsFinish andalso DayBool, IsUpdate orelse OneIsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 完成N转##{7,N}##{7,N}##{7,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_TURN, NeedTurn}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #player_status{figure = #figure{turn = Turn}} = Player,
    #supvip_skill_task{content = Content} = SkillTask,
    TurnBool = Turn >= NeedTurn,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Turn}),
    do_check_skill_task_content(T, Player, IsFinish andalso TurnBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 击败M级以上Y类型(世界boss等)N次##{8,N,M,Y}##{8,N}##{8,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_KILL_BOSS, NeedCount, _BossLevel, _BoosType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> ok;
        _ -> Count = 0
    end,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 穿戴N件M(坐骑/伙伴)装备##{9,N,M}##{9,N}##{9,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_MOUNT_EQUIP, NeedCount, MountType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #player_status{id = RoleId} = Player,
    #supvip_skill_task{content = Content} = SkillTask,
    case MountType of
        ?MOUNT_ID -> GoodLocal = ?GOODS_LOC_MOUNT_EQUIP;
        ?MATE_ID -> GoodLocal = ?GOODS_LOC_MATE_EQUIP;
        _ -> GoodLocal = false
    end,
    case is_integer(GoodLocal) of
        true ->
            #goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
            EquipWearList = lib_goods_util:get_goods_list(RoleId, GoodLocal, Dict),
            Count = length(EquipWearList);
        false ->
            Count = 0
    end,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活N本契约之书##{10,N}##{10,N}##{10,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_ETERNAL_VALLEY, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = lib_eternal_valley:get_finish_count(Player),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 成就等级##{11,N}##{11,N}##{11,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_ACHI_LV, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #player_status{figure = #figure{achiv_stage = Count}} = Player,
    #supvip_skill_task{content = Content} = SkillTask,
    Bool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso Bool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活M功能(坐骑,伙伴,法阵...)N个幻化外形##{12, N, M}##{12,N}##{12,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_MOUNT_FIGURE, NeedCount, MountType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = lib_mount:get_figure_count(Player, MountType),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 装备M品质Y类型N个龙纹##{13,N,M,Y}##{13,N}##{13,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DRAGON_EQUIP, NeedCount, NeedColor, NeedKind}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = lib_dragon_api:get_equip_list(Player, NeedColor, NeedKind),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 宝宝培养至N级##{14,N}##{14,N}##{14,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_BABY_LV, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #player_status{status_baby = #status_baby{raise_lv = Count}} = Player,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% N件装备神装打造至M级#{15,N,M}##{15,N}##{15,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_GOD_EQUIP, NeedCount, NeedLv}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #goods_status{god_equip_list = GodEquipLevelList} = lib_goods_do:get_goods_status(),
    Count = length([EquipPos||{EquipPos, Level}<-GodEquipLevelList, Level >= NeedLv]),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活N个降神##{16,N}##{16,N}##{16,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_GOD_NUM, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = lib_god_api:get_god_count(Player),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 任意幻饰升至N阶##{17,N}##{17,N}##{17,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DECORATION_STAGE, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = lib_decoration:get_max_stage(Player),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 购买N类型投资##{18,N}##{18,N}##{18,N} 
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_INVESTMENT, InvestType}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    Count = ?IF(lib_investment:is_buy_by_type(Player, InvestType), 1, 0),
    CountBool = Count >= 1,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 宝宝N个幻化外形##{19,N}##{19,N}##{19,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_BABY_FIGURE, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #player_status{status_baby = #status_baby{active_list = ActiveList}} = Player,
    Count = length(ActiveList),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 穿戴粉红色装备N件##{20,N}##{20,N}##{20,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_PINK_EQUIP, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #goods_status{color_award_list = ColorAwardList} = lib_goods_do:get_goods_status(),
    {CountBool, Count} = calc_equip_pre_num(ColorAwardList, NeedCount, ?PINK, 0),
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活任意天启N件套##{21,N}##{21,N}##{21,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_REVELATION_EQUIP, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    StarList = lib_revelation_equip:get_suit_msg_for_super_vip(Player),
    case calc_equip_num(StarList, NeedCount, 0) of
        {false, Count} -> 0;
        true -> Count = NeedCount
    end,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活M类型天启套装N件##{22,N,M}##{22,N}##{22,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_REVELATION_EQUIP_SUIT, NeedCount, Star}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    StarList = lib_revelation_equip:get_suit_msg_for_super_vip(Player),
    case lists:keyfind(Star, 1, StarList) of
        {Star, Count} -> ok;
        _ -> Count = 0
    end,
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活N个使魔##{23,N}##{23,N}##{23,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DEMONS, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #player_status{status_demons = #status_demons{demons_list = DemonsList}} = Player,
    Count = length(DemonsList),
    CountBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 装备M品质使魔技能N种##{24,N,M}##{24,N}##{24,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DEMONS_SKILL, NeedCount, Quality}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    SlotSkillList = lib_demons_util:get_role_slot_skill_info(Player),
    {CountBool, Count} = calc_equip_pre_num(SlotSkillList, NeedCount, Quality, 0),
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
    do_check_skill_task_content(T, Player, IsFinish andalso CountBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 累计登录N天##{25,N}##{25,N}##{25,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_LOGIN_DAYS, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    #player_status{supvip = #status_supvip{login_days = LoginDays}} = Player,
    DayBool = LoginDays >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, LoginDays}),
    do_check_skill_task_content(T, Player, IsFinish andalso DayBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 参与N次永恒圣殿玩法##{26,N}##{26,N}##{26,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_SANCTUM, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count, Utime} -> ok;
        _ -> Count = 0, Utime = 0
    end,
    DayBool = Count >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count, Utime}),
    do_check_skill_task_content(T, Player, IsFinish andalso DayBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 激活xx伙伴##{27, N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_COMPANION_ACTIVE, CompanionId}|T], Player, IsFinish, IsUpdate, SkillTask) ->
    #supvip_skill_task{content = Content} = SkillTask,
    IsActive = lib_companion_util:is_active(Player, CompanionId),
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, ?IF(IsActive, 1, 0)}),
    do_check_skill_task_content(T, Player, IsFinish andalso IsActive, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});
% 激活N个伙伴##{28, N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_COMPANION_NUM, NeedNum}|T], Player, IsFinish, IsUpdate, SkillTask) ->
    #supvip_skill_task{content = Content} = SkillTask,
    ActiveNum = lib_companion_util:active_num(Player),
    ActiveBool = ActiveNum >= NeedNum,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, ActiveNum}),
    do_check_skill_task_content(T, Player, IsFinish andalso ActiveBool, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});
%%% 获得N本S级使魔天赋##{31,N}
%%do_check_skill_task_content([{TaskType, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) when
%%    TaskType == ?SUPVIP_SKILL_TASK_DEMONS_GOODS ->
%%    #supvip_skill_task{content = Content} = SkillTask,
%%    #goods_status{dict = GoodsDict} = lib_goods_do:get_goods_status(),
%%    Dict1 = dict:filter(fun(_Key, [Value]) -> lists:member(Value#goods.goods_id, data_supreme_vip:get_kv(8)) end, GoodsDict),
%%    DictList = dict:to_list(Dict1),
%%    List = lib_goods_dict:get_list(DictList, []),
%%    Count = length(List),
%%    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count}),
%%    IsSatisfy = Count >= NeedCount,
%%    do_check_skill_task_content(T, Player, IsFinish andalso IsSatisfy, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});
% 获得N本S级使魔天赋##{31,N}
% 合成n件粉装##{29, N}
% 装备强化总等级达到XX级##{32,N}
do_check_skill_task_content([{TaskType, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) when
    TaskType == ?SUPVIP_SKILL_TASK_COMPOSE_PINK;
    TaskType == ?SUPVIP_SKILL_TASK_DEMONS_GOODS->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> NewContent = Content;
        _ ->
            Count = 0, NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Count})
    end,
    IsSatisfy = Count >= NeedCount,
    do_check_skill_task_content(T, Player, IsFinish andalso IsSatisfy, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});
% 龙纹开启N个孔##{30,N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_DRAGON_POS, NeedCount}|T], Player, IsFinish, IsUpdate, SkillTask) ->
    #supvip_skill_task{content = Content} = SkillTask,
    #status_dragon{pos_list = PosRdList} = Player#player_status.dragon,
    PosNum = length(PosRdList),
    IsSatisfy = PosNum >= NeedCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, PosNum}),
    do_check_skill_task_content(T, Player, IsFinish andalso IsSatisfy, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

% 装备强化总等级达到xx ##{32，N}
do_check_skill_task_content([{TaskType=?SUPVIP_SKILL_TASK_EQUIP_STREN_SUM, NeedLv}|T], Player, IsFinish, IsUpdate, SkillTask) ->
    #supvip_skill_task{content = Content} = SkillTask,
    #goods_status{stren_award_list = StrenAwardList} = lib_goods_do:get_goods_status(),
    F = fun({StrNum, N}, GrandLv) -> StrNum * N + GrandLv end,
    SumLv = lists:foldl(F, 0, StrenAwardList),
    IsSatisfy = SumLv >= NeedLv,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, SumLv}),
    do_check_skill_task_content(T, Player, IsFinish andalso IsSatisfy, IsUpdate, SkillTask#supvip_skill_task{content = NewContent});

do_check_skill_task_content([_H|_T], _Player, _IsFinish, IsUpdate, SkillTask) ->
    {IsUpdate, SkillTask}.

%% 检查装备（强化，精炼...）大于等于StrenNum有多少件
calc_equip_pre_num(_EqPreList, Num, _StrenNum, Count) when Count >= Num -> {true, Num};
calc_equip_pre_num([{StrNum, N}|T], Num, StrenNum, Count)->
    if
        StrNum >= StrenNum andalso N >= Num -> {true, Num};
        StrNum >= StrenNum -> calc_equip_pre_num(T, Num, StrenNum, Count+N);
        true -> calc_equip_pre_num(T, Num, StrenNum, Count)
    end;
calc_equip_pre_num([], _Num, _StrenNum, Count) -> {false, Count}.

%% 检查装备列表里面数量是否大于某个值
calc_equip_num([{_, Num}|_], NeedNum, _) when Num>=NeedNum -> true;
calc_equip_num([{_, Num}|T], NeedNum, Max) -> 
    case Num > Max of
        true -> calc_equip_num(T, NeedNum, Num);
        false -> calc_equip_num(T, NeedNum, Max)
    end;
calc_equip_num([], _, Max) -> {false, Max}.

%% 触发技能任务##增加对应的值
trigger_skill_task(Player, TaskType, Args) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType} = StatusSupVip,
    if
        SupvipType == ?SUPVIP_TYPE_NO -> Player;
        true -> trigger_skill_task_help(Player, TaskType, Args)
    end.

trigger_skill_task_help(#player_status{id = RoleId, supvip = StatusSupVip} = Player, TaskType, Args) ->
    #status_supvip{skill_stage = Stage, skill_task_list = OldSkillTaskList} = StatusSupVip,
    F = fun(TaskId, {TmpList, TmpFinList}) ->
        #base_supreme_vip_skill_task{content = Content} = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
        SkillTask = get_skill_task(Player, TaskId),
        {IsUpdate, NewSkillTask} = trigger_skill_task(Player, SkillTask, Content, TaskType, Args),
        case IsUpdate of
            true -> db_role_supvip_skill_task_replace(RoleId, NewSkillTask);
            false -> skip
        end,
        NewTmpList = lists:keystore(TaskId, #supvip_skill_task.task_id, TmpList, NewSkillTask),
        % 触发完成任务
        case SkillTask#supvip_skill_task.is_finish =/= NewSkillTask#supvip_skill_task.is_finish of
            true -> {NewTmpList, [NewSkillTask|TmpFinList]};
            false -> {NewTmpList, TmpFinList}
        end
    end,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    {SkillTaskL, FinSkillTaskL} = lists:foldl(F, {OldSkillTaskList, []}, TaskIdL),
    NewStatusSupVip = StatusSupVip#status_supvip{skill_task_list = SkillTaskL},
    case FinSkillTaskL == [] of
        true -> skip;
        false ->
            F2 = fun(#supvip_skill_task{task_id = TaskId} = SkillTask) ->
                #base_supreme_vip_skill_task{content = Content} = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
                make_skill_task_for_client(SkillTask, Content)
            end,
            ClientL  = lists:map(F2, FinSkillTaskL),
            {ok, BinData} = pt_451:write(45110, [ClientL]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end,
    % ?MYLOG("hjhsupvipskill", "trigger_skill_task_help SkillTaskL:~p FinSkillTaskL:~p ~n", [SkillTaskL, FinSkillTaskL]),
    Player#player_status{supvip = NewStatusSupVip}.

trigger_skill_task(Player, SkillTask, Content, TaskType, Args) ->
    case SkillTask#supvip_skill_task.is_finish == ?SUPVIP_FINISH_YES of
        true -> {false, SkillTask};
        false -> 
            {IsUpdate, IsTrigger, NewSkillTask} = do_trigger_skill_task(Content, false, false, SkillTask, TaskType, Args),
            % ?MYLOG("hjhsupvipskill", "trigger_skill_task_help Content:~p SkillTask:~p, TaskType:~p, Args:~p ~n", [Content, SkillTask, TaskType, Args]),
            % ?MYLOG("hjhsupvipskill", "trigger_skill_task_help NewSkillTask:~p ~n", [NewSkillTask]),
            case IsTrigger of
                true ->
                    {IsUpdateAfCheck, SkillTaskAfCheck} = check_skill_task_content(Player, NewSkillTask, Content),
                    {IsUpdateAfCheck orelse IsUpdate, SkillTaskAfCheck};
                false ->
                    {IsUpdate, NewSkillTask}
            end
    end.

do_trigger_skill_task([], IsUpdate, IsTrigger, SkillTask, _TaskType, _Args) -> {IsUpdate, IsTrigger, SkillTask};

% 充值任意金额N天##{6,N}##{6,N,更新时间}
do_trigger_skill_task([{TaskType=?SUPVIP_SKILL_TASK_RECHARGE, _NeedDay}|T], IsUpdate, IsTrigger, SkillTask, TaskType, {add, Gold}) ->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Day, Utime} -> 
            case utime:is_today(Utime) of
                true -> 
                    NewDay = Day,
                    NewUtime = utime:unixtime();
                false ->
                    NewDay = Day + 1,
                    NewUtime = utime:unixtime()
            end;
        _ ->
            NewDay = 1,
            NewUtime = utime:unixtime()
    end,
    % ?MYLOG("hjhsupvipskill", "trigger_skill_task_help {TaskType, NewDay, NewUtime}:~p ~n", [{TaskType, NewDay, NewUtime}]),
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewDay, NewUtime}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, {add, Gold});

% 完成N次M副本(材料、金币、经验)##{4,N,M}
do_trigger_skill_task([{TaskType=?SUPVIP_SKILL_TASK_DUN_COUNT, _NeedCount, DunType}|T], IsUpdate, IsTrigger, SkillTask, TaskType, {more, AddCount, DunType}) ->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> ok;
        _ -> Count = 0
    end,
    NewCount = Count + AddCount,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewCount}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, {more, AddCount, DunType});

% 击败M级以上Y类型(世界boss等)N次##{8,N,M,Y}##{8,N}##{8,N}
do_trigger_skill_task([{TaskType=?SUPVIP_SKILL_TASK_KILL_BOSS, _NeedCount, NeedBossLevel, BossType}|T], IsUpdate, IsTrigger, SkillTask, TaskType, 
        {more_lv, AddCount, BossLevel, BossType} = Args) -> 
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> ok;
        _ -> Count = 0
    end,
    case BossLevel >= NeedBossLevel of
        true -> NewCount = Count + AddCount;
        false -> NewCount = Count
    end,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewCount}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, Args);

% 参与N次永恒圣殿玩法##{26,N}##{26,N}##{26,N,更新时间}
do_trigger_skill_task([{TaskType=?SUPVIP_SKILL_TASK_SANCTUM, _NeedCount}|T], IsUpdate, IsTrigger, SkillTask, TaskType, {add, AddCount}) ->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count, Utime} -> 
            case utime:is_today(Utime) of
                true -> 
                    NewCount = Count,
                    NewUtime = utime:unixtime();
                false ->
                    NewCount = Count + AddCount,
                    NewUtime = utime:unixtime()
            end;
        _ ->
            NewCount = AddCount,
            NewUtime = utime:unixtime()
    end,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewCount, NewUtime}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, {add, AddCount});

% 粉色装备合成N件
% 收集使魔天赋书N本(add)
do_trigger_skill_task([{TaskType, _NeedCount}|T], _IsUpdate, _IsTrigger, SkillTask, TaskType, {add, AddCount})
    when TaskType == ?SUPVIP_SKILL_TASK_DEMONS_GOODS orelse TaskType == ?SUPVIP_SKILL_TASK_COMPOSE_PINK ->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> NewCount = Count + AddCount;
        _ -> NewCount = AddCount
    end,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewCount}),
    do_trigger_skill_task(T, true, true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, {add, AddCount});

% 收集使魔天赋书N本(reduce)
do_trigger_skill_task([{TaskType, _NeedCount}|T], _IsUpdate, _IsTrigger, SkillTask, TaskType, {reduce, AddCount})
    when TaskType == ?SUPVIP_SKILL_TASK_DEMONS_GOODS ->
    #supvip_skill_task{content = Content} = SkillTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Count} -> NewCount = max(Count - AddCount, 0);
        _ -> NewCount = 0
    end,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewCount}),
    do_trigger_skill_task(T, true, true, SkillTask#supvip_skill_task{content = NewContent}, TaskType, {add, AddCount});

% M养成功能升阶至N阶##{2,N,M}
do_trigger_skill_task([{TaskType, _N, M}|T], IsUpdate, IsTrigger, SkillTask, TaskType, {trigger, M}) ->
    do_trigger_skill_task(T, IsUpdate, IsTrigger orelse true, SkillTask, TaskType, {trigger, M});

% N件装备强化+M以上##{1,N,M}
do_trigger_skill_task([{TaskType, _N, _M}|T], IsUpdate, IsTrigger, SkillTask, TaskType, Args) ->
    do_trigger_skill_task(T, IsUpdate, IsTrigger orelse true, SkillTask, TaskType, Args);

% 通关符文本第N层##{3,N}
% 勋章提升至N阶##{5,N}
% 激活xx伙伴##{27,N}
% 激活N个伙伴##{28,N}
% 开启龙纹N个孔##{31,N}
% 强化总等级达到N ##{32,N}
do_trigger_skill_task([{TaskType, _N}|T], IsUpdate, IsTrigger, SkillTask, TaskType, Args) ->
    do_trigger_skill_task(T, IsUpdate, IsTrigger orelse true, SkillTask, TaskType, Args);

do_trigger_skill_task([_|T], IsUpdate, IsTrigger, SkillTask, TaskType, Args) ->
    do_trigger_skill_task(T, IsUpdate, IsTrigger, SkillTask, TaskType, Args).

%% ----------------------------------------------------
%% 至尊币任务
%% ----------------------------------------------------

%% 自动触发至尊币任务
auto_trigger_currency_task(#player_status{id = RoleId, supvip = StatusSupVip} = Player) ->
    #status_supvip{currency_task_list = OldCurrencyTaskL} = StatusSupVip,
    F = fun(TaskId, TmpList) ->
        #base_supreme_vip_currency_task{condition = Condition, content = Content} = data_supreme_vip:get_supreme_vip_currency_task(TaskId),
        case check_currency_task_trigger(Condition, Player) of
            true ->
                CurrencyTask = get_currency_task(Player, TaskId),
                {IsUpdate, NewCurrencyTask} = check_currency_task_content(Player, CurrencyTask, Content),
                case IsUpdate of
                    true -> db_role_supvip_currency_task_replace(RoleId, NewCurrencyTask);
                    false -> skip
                end,
                lists:keystore(TaskId, #supvip_currency_task.task_id, TmpList, NewCurrencyTask);
            false ->
                TmpList
        end    
    end,
    TaskIdL = data_supreme_vip:get_supvip_currency_task_id_list(),
    CurrencyTaskL = lists:foldl(F, OldCurrencyTaskL, TaskIdL),
    NewStatusSupVip = StatusSupVip#status_supvip{currency_task_list = CurrencyTaskL},
    Player#player_status{supvip = NewStatusSupVip}.

%% 检查任务是否开启
check_currency_task_trigger([], _Player) -> true;
check_currency_task_trigger([{open_day, StartOpenDay, EndOpenDay}|T], Player) ->
    OpenDay = util:get_open_day(),
    case OpenDay >= StartOpenDay andalso OpenDay =< EndOpenDay of
        true -> check_currency_task_trigger(T, Player);
        false -> false
    end;
check_currency_task_trigger([_H|T], Player) ->
    check_currency_task_trigger(T, Player).

check_currency_task_content(Player, CurrencyTask, Content) ->
    case CurrencyTask#supvip_currency_task.is_finish == ?SUPVIP_FINISH_YES of
        true -> {false, CurrencyTask};
        false -> do_check_currency_task_content(Content, Player, true, false, CurrencyTask)
    end.

%% 通用检查
do_check_currency_task_content([], _Player, IsFinish, IsUpdate, CurrencyTask) -> 
    case IsFinish of
        true -> {true, CurrencyTask#supvip_currency_task{is_finish = ?SUPVIP_FINISH_YES}};
        false -> {IsUpdate, CurrencyTask}
    end;
% 充值N钻石##{1,N}##{1,N}
do_check_currency_task_content([{TaskType=?SUPVIP_CURRENCY_TASK_RECHARGE, NeedGold}|T], Player, IsFinish, IsUpdate, CurrencyTask) ->
    #player_status{id = RoleId} = Player,
    #supvip_currency_task{content = Content} = CurrencyTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Gold} -> OneIsUpdate = false;
        _ -> 
            Gold = lib_recharge_data:get_today_pay_gold(RoleId),
            OneIsUpdate = true
    end,
    GoldBool = Gold >= NeedGold,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Gold}),
    do_check_currency_task_content(T, Player, IsFinish andalso GoldBool, IsUpdate orelse OneIsUpdate, CurrencyTask#supvip_currency_task{content = NewContent});
% 购买N次M副本(材料，金币，经验)##{2, N, M}##{2,N}
% 击杀N个M类型boss(个人boss,世界boss,boss之家)##{3, N, M}##{3,N}
% 进入N次M玩法(蛮荒,秘境)##{4, N, M}##{4,N}
% 完成N次M副本(材料、金币、经验)##{7,N,M}##{7,N}##{7,N}
% 扫荡N次M副本(伙伴)##{8,N,M}
do_check_currency_task_content([{TaskType, NeedNum, _M}|T], Player, IsFinish, IsUpdate, CurrencyTask) when
        TaskType == ?SUPVIP_CURRENCY_TASK_BUY_DUN;
        TaskType == ?SUPVIP_CURRENCY_TASK_KILL_BOSS;
        TaskType == ?SUPVIP_CURRENCY_TASK_ENTER;
        TaskType == ?SUPVIP_CURRENCY_TASK_DUN_CLEAN;
        TaskType == ?SUPVIP_CURRENCY_TASK_DUN_COUNT ->
    #supvip_currency_task{content = Content} = CurrencyTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    NumBool = Num >= NeedNum,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Num}),
    do_check_currency_task_content(T, Player, IsFinish andalso NumBool, IsUpdate, CurrencyTask#supvip_currency_task{content = NewContent});
% <br>护送N次##{5,N}##{5,N}
% <br>消耗N钻石##{6,N}##{6,N}
% <br>参与璀璨之海N次##{9,N}
do_check_currency_task_content([{TaskType, NeedNum}|T], Player, IsFinish, IsUpdate, CurrencyTask) when
        TaskType == ?SUPVIP_CURRENCY_TASK_HUSONG;
        TaskType == ?SUPVIP_CURRENCY_TASK_COST;
        TaskType == ?SUPVIP_CURRENCY_TASK_SEA_TREA ->
    #supvip_currency_task{content = Content} = CurrencyTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    NumBool = Num >= NeedNum,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, Num}),
    do_check_currency_task_content(T, Player, IsFinish andalso NumBool, IsUpdate, CurrencyTask#supvip_currency_task{content = NewContent});
do_check_currency_task_content([_H|T], Player, _IsFinish, IsUpdate, CurrencyTask) ->
    do_check_currency_task_content(T, Player, false, IsUpdate, CurrencyTask).

%% 至尊币任务触发
trigger_currency_task(Player, TaskType, Args) -> 
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType} = StatusSupVip,
    if
        SupvipType == ?SUPVIP_TYPE_NO -> Player;
        true ->
            % 删除过期
            PlayerAfDel = auto_del_timeout_currency_task(Player),
            % 触发 
            trigger_currency_task_help(PlayerAfDel, TaskType, Args)
    end.

trigger_currency_task_help(#player_status{id = RoleId, supvip = StatusSupVip} = Player, TaskType, Args) ->
    #status_supvip{currency_task_list = OldCurrencyTaskL} = StatusSupVip,
    F = fun(TaskId, {TmpList, TmpFinList}) ->
        #base_supreme_vip_currency_task{condition = Condition, content = Content} = data_supreme_vip:get_supreme_vip_currency_task(TaskId),
        case check_currency_task_trigger(Condition, Player) of
            true ->
                CurrencyTask = get_currency_task(Player, TaskId),
                {IsUpdate, NewCurrencyTask} = trigger_currency_task(Player, CurrencyTask, Content, TaskType, Args),
                case IsUpdate of
                    true -> db_role_supvip_currency_task_replace(RoleId, NewCurrencyTask);
                    false -> skip
                end,
                NewTmpList = lists:keystore(TaskId, #supvip_currency_task.task_id, TmpList, NewCurrencyTask),
                % 触发完成任务
                case CurrencyTask#supvip_currency_task.is_finish =/= NewCurrencyTask#supvip_currency_task.is_finish of
                    true -> {NewTmpList, [NewCurrencyTask|TmpFinList]};
                    false -> {NewTmpList, TmpFinList}
                end;
            false ->
                {TmpList, TmpFinList}
        end
    end,
    TaskIdL = data_supreme_vip:get_supvip_currency_task_id_list(),
    {CurrencyTaskL, FinCurrencyTaskL} = lists:foldl(F, {OldCurrencyTaskL, []}, TaskIdL),
    case FinCurrencyTaskL == [] of
        true -> skip;
        false ->
            F2 = fun(#supvip_currency_task{task_id = TaskId} = CurrencyTask) ->
                #base_supreme_vip_currency_task{content = Content} = data_supreme_vip:get_supreme_vip_currency_task(TaskId),
                make_currency_task_for_client(CurrencyTask, Content)
            end,
            ClientL  = lists:map(F2, FinCurrencyTaskL),
            {ok, BinData} = pt_451:write(45111, [ClientL]),
            lib_server_send:send_to_sid(Player#player_status.sid, BinData)
    end,
    NewStatusSupVip = StatusSupVip#status_supvip{currency_task_list = CurrencyTaskL},
    Player#player_status{supvip = NewStatusSupVip}.

trigger_currency_task(Player, CurrencyTask, Content, TaskType, Args) ->
    case CurrencyTask#supvip_currency_task.is_finish == ?SUPVIP_FINISH_YES of
        true -> {false, CurrencyTask};
        false -> 
            {IsUpdate, IsTrigger, NewCurrencyTask} = do_trigger_currency_task(Content, false, false, CurrencyTask, TaskType, Args),
            % ?MYLOG("hjhsupvipcurrency", "trigger_currency_task Content:~p NewCurrencyTask:~p, TaskType:~p, Args:~p ~n", [Content, NewCurrencyTask, TaskType, Args]),
            case IsTrigger of
                true ->
                    {IsUpdateAfCheck, CurrencyTaskAfCheck} = check_currency_task_content(Player, NewCurrencyTask, Content),
                    {IsUpdateAfCheck orelse IsUpdate, CurrencyTaskAfCheck};
                false ->
                    {IsUpdate, NewCurrencyTask}
            end
    end.

do_trigger_currency_task([], IsUpdate, IsTrigger, CurrencyTask, _TaskType, _Args) -> {IsUpdate, IsTrigger, CurrencyTask};
% 充值N钻石##{1,N}
% 护送N次##{5,N}
% 消耗N钻石##{6,N}
% 参与璀璨之海N次##{9,N}##{9,N}##{9,N}
do_trigger_currency_task([{TaskType, _NeedNum}|T], IsUpdate, IsTrigger, CurrencyTask, TaskType, {add, AddNum}) ->
    #supvip_currency_task{content = Content} = CurrencyTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    NewNum = Num + AddNum,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewNum}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, CurrencyTask#supvip_currency_task{content = NewContent}, TaskType, {add, AddNum});
% 购买N次M副本(材料，金币，经验)##{2, N, M}
% 击杀N个M类型boss(个人boss,世界boss,boss之家)##{3, N, M}
% 进入N次M玩法(蛮荒,秘境)##{4, N, M}
% 完成N次M副本(材料、金币、经验)##{7,N,M}##{7,N}##{7,N}
% 扫荡N次M副本(伙伴)##{8,N,M}##{8,N}##{8,N}
do_trigger_currency_task([{TaskType, _NeedNum, Type}|T], IsUpdate, IsTrigger, CurrencyTask, TaskType, {more, AddNum, Type}) ->
    #supvip_currency_task{content = Content} = CurrencyTask,
    case lists:keyfind(TaskType, 1, Content) of
        {TaskType, Num} -> ok;
        _ -> Num = 0
    end,
    NewNum = Num + AddNum,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, NewNum}),
    do_trigger_skill_task(T, IsUpdate orelse true, IsTrigger orelse true, CurrencyTask#supvip_currency_task{content = NewContent}, TaskType, {more, AddNum, Type});

do_trigger_currency_task([_|T], IsUpdate, IsTrigger, CurrencyTask, TaskType, Args) ->
    do_trigger_currency_task(T, IsUpdate, IsTrigger, CurrencyTask, TaskType, Args).

%% ----------------------------------------------------
%% 其他
%% ----------------------------------------------------

%% 处理充值天数##会自动激活永久
handle_charge_day(Player, Gold) ->
    #player_status{id = RoleId, figure = #figure{name = Name} = Figure, supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime, charge_day = ChargeDay, today_gold = TodayGold, today_gold_utime = TodayGoldUtime} = StatusSupVip,
    if
        SupvipType =/= ?SUPVIP_TYPE_EX -> Player;
        true ->
            {NeedGold, NeedDay} = ?SUPVIP_KV_UP_FOREVER_RECHARGE,
            case utime:is_today(TodayGoldUtime) of
                true -> 
                    NewTodayGold = TodayGold + Gold,
                    NewTodayGoldUtime = utime:unixtime(),
                    NewChargeDay = ChargeDay;
                false -> 
                    NewTodayGold = Gold,
                    NewTodayGoldUtime = utime:unixtime(),
                    % 旧的充值是否满足充值天数的条件
                    case TodayGold >= NeedGold of
                        true -> NewChargeDay = ChargeDay + 1;
                        false -> NewChargeDay = ChargeDay
                    end
            end,
            IsUpForever = get_charge_day(NewChargeDay, NewTodayGold) >= NeedDay,
            case IsUpForever of
                true -> NewSupvipType = ?SUPVIP_TYPE_FOREVER;
                false -> NewSupvipType = SupvipType
            end,
            NewStatusSupVip = StatusSupVip#status_supvip{
                supvip_type = NewSupvipType, charge_day = NewChargeDay, today_gold = NewTodayGold, today_gold_utime = NewTodayGoldUtime
                },
            db_role_supvip_replace(RoleId, NewStatusSupVip),
            NewPlayer = Player#player_status{supvip = NewStatusSupVip},
            % 提升至尊vip
            case IsUpForever of
                true -> 
                    #figure{name = Name} = Figure,
                    IsSupvip  = is_supvip(NewSupvipType, SupvipTime),
                    NewFigure = Figure#figure{is_supvip = IsSupvip},
                    PlayerAfFigure = NewPlayer#player_status{figure = NewFigure},
                    % 派发事件
                    lib_player_event:async_dispatch(RoleId, ?EVENT_SUPVIP),
                    case SupvipType of
                        ?SUPVIP_TYPE_EX -> skip;
                        _ -> add_forbid_angle(PlayerAfFigure)
                    end,
                    PlayerAfAttr = calc_attr(PlayerAfFigure),
                    % 同步战力
                    PlayerAfCount = lib_player:count_player_attribute(PlayerAfAttr),
                    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
                    #player_status{battle_attr = BattleAttr, supvip = #status_supvip{passive_skills = NewPassveSkill}} = PlayerAfCount,
                    mod_scene_agent:update(PlayerAfCount, [{is_supvip, IsSupvip}, {battle_attr, BattleAttr}, {passive_skill, NewPassveSkill}]),
                    lib_scene:broadcast_player_attr(PlayerAfCount, [{10, IsSupvip}]),
                    % ?MYLOG("hjhsupvip", "do_buy_forever IsSupvip:~w ~n", [IsSupvip]),
                    % 技能buff
                    PlayerAfEffect = trigger_skill_effect(PlayerAfCount),
                    % 日志传闻
                    log_supvip_active(PlayerAfEffect, 3, []),
                    lib_chat:send_TV({all}, ?MOD_SUPVIP, 2, [Name, RoleId]),
                    {ok, BinData} = pt_451:write(45109, []),
                    lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                false ->
                    PlayerAfEffect = NewPlayer
            end,
            PlayerAfEffect
    end.

%% 充值返还至尊币
return_currency(Player, Gold) ->
    SupvipType = get_supvip_type(Player),
    Ratio = ?SUPVIP_KV_CURRENCY_RATIO,
    if
        SupvipType == ?SUPVIP_TYPE_NO -> Player;
        is_number(Ratio) == false orelse Ratio =< 0 orelse Gold =< 0 -> Player;
        true ->
            Reward = [{?TYPE_CURRENCY, ?GOODS_ID_SUPVIP, round(Gold*Ratio)}],
            Remark = lists:concat(["Gold:", Gold, ",Ratio:", util:term_to_string(Ratio)]),
            Produce = #produce{type = supvip_return_currency, reward = Reward, remark = Remark},
            PlayerAfReward = lib_goods_api:send_reward(Player, Produce),
            PlayerAfReward
    end.

%% 每天触发
daily_timer(?TWELVE = Clock) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> 
        lib_goods_api:db_delete_currency_by_currency_id(?GOODS_ID_SUPVIP),
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_supreme_vip, daily_timer, [Clock])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok;
daily_timer(?FOUR = Clock) ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    spawn(fun() -> 
        F = fun(E) ->
            lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_supreme_vip, daily_timer, [Clock])
        end,
        lists:foreach(F, OnlineRoles)
    end),
    ok.

daily_timer(#player_status{online = ?ONLINE_ON} = Player, ?TWELVE) -> 
    PlayerAfDay = update_login_days(Player),
    PlayerAfCurrency = clear_currency(PlayerAfDay),
    {ok, PlayerAfCurrency};
daily_timer(Player, ?TWELVE) -> 
    PlayerAfCurrency = clear_currency(Player),
    {ok, PlayerAfCurrency};

daily_timer(#player_status{online = ?ONLINE_ON} = Player, ?FOUR) -> 
    % 技能buff
    PlayerAfEffect = trigger_skill_effect(Player),
    {ok, PlayerAfEffect};
daily_timer(Player, _Clock) -> 
    {ok, Player}.

%% 清理货币
clear_currency(Player) ->
    Currency = lib_goods_api:get_currency(Player, ?GOODS_ID_SUPVIP),
    Cost = ?IF(Currency > 0 , [{?TYPE_CURRENCY, ?GOODS_ID_SUPVIP, Currency}], []),
    % ?PRINT("Cost:~p ~n", [Cost]),
    if
        Cost == [] ->
            Player;
        true ->
            case lib_goods_api:cost_object_list_with_check(Player, Cost, supvip_clear_currency, "") of
                {true, NewPlayer} ->
                    NewPlayer;
                {false, _Error, NewPlayer} ->
                    NewPlayer
            end
    end.

%% 特权奖励
use_pk_safe(Player) ->
    RightType = ?SUPVIP_RIGHT_PK_SAFE,
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{right_list = RightList} = StatusSupVip,
    case lists:keyfind(RightType, #supvip_right.right_type, RightList) of
        false -> Right = #supvip_right{right_type = RightType, data = [], utime = utime:unixtime()};
        OldRight -> Right = OldRight#supvip_right{right_type = RightType, data = [], utime = utime:unixtime()}
    end,
    db_role_supvip_right_replace(RoleId, Right),
    NewRightList = lists:keystore(RightType, #supvip_right.right_type, RightList, Right),
    NewStatusSupVip = StatusSupVip#status_supvip{right_list = NewRightList},
    Player#player_status{supvip = NewStatusSupVip}.

%% 是否有免费
check_use_protect_free(Player, SceneType) ->
    if
        SceneType =/= ?SCENE_TYPE_ABYSS_BOSS -> false;
        true -> get_free_use_pk_safe_info(Player)
    end.

get_free_use_pk_safe_info(Player) ->
    RightType = ?SUPVIP_RIGHT_PK_SAFE,
    #player_status{supvip = StatusSupVip} = Player,
    SupvipType = get_supvip_type(StatusSupVip),
    BaseSupvip = data_supreme_vip:get_supreme_vip(SupvipType, RightType),
    GetStatus = get_right_reward_status(Player, RightType),
    if
        is_record(BaseSupvip, base_supreme_vip) == false -> false;
        GetStatus =/= ?SUPVIP_CAN_GET -> false;
        BaseSupvip#base_supreme_vip.value =< 0 -> false;
        true -> {true, BaseSupvip#base_supreme_vip.value}
    end.

%% 获得免费
is_free_use_pk_safe(Player) ->
    case get_free_use_pk_safe_info(Player) of
        false -> 0;
        {true, _Value} -> 1
    end.

%% 发送免费使用pk的信息
send_free_use_pk_safe(Player) ->
    IsFree = is_free_use_pk_safe(Player),
    {ok, BinData} = pt_451:write(45112, [IsFree]),
    lib_server_send:send_to_sid(Player#player_status.sid, BinData),
    ok.

%% 至尊vip激活
%% 1:体验
%% 2:永久
%% 3:自动升永久
log_supvip_active(Player, Type, Cost) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{supvip_type = SupvipType, supvip_time = SupvipTime} = StatusSupVip,
    lib_log_api:log_supvip_active(RoleId, Type, Cost, SupvipType, SupvipTime),
    ta_agent_fire:log_supvip_active(Player, [Type, SupvipType, SupvipTime]),
    ok.

%% ----------------------------------------------------
%% 数据库
%% ----------------------------------------------------

%% 至尊vip
db_role_supvip_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_select, [RoleId]),
    db:get_row(Sql).

db_role_supvip_replace(RoleId, StatusSupVip) ->
    #status_supvip{
        supvip_type = SupvipType, supvip_time = SupvipTime, active_time = ActiveTime, 
        charge_day = ChargeDay, today_gold = TodayGold, today_gold_utime = TodayGoldUtime, skill_stage = SkillStage, skill_sub_stage = SkillSubStage,
        days_utime = DaysUtime, login_days = LoginDays
        } = StatusSupVip,
    Sql = io_lib:format(?sql_role_supvip_replace, [RoleId, SupvipType, SupvipTime, ActiveTime, ChargeDay, TodayGold, TodayGoldUtime, SkillStage, 
        SkillSubStage, DaysUtime, LoginDays]),
    db:execute(Sql).

%% 至尊vip的离线数据
db_role_supvip_offline_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_offline_select, [RoleId]),
    db:get_row(Sql).

%% 至尊vip特权
db_role_supvip_right_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_right_select, [RoleId]),
    db:get_all(Sql).

db_role_supvip_right_replace(RoleId, Right) ->
    #supvip_right{right_type = RightType, data = Data, utime = Utime} = Right,
    DataBin = util:term_to_bitstring(Data),
    Sql = io_lib:format(?sql_role_supvip_right_replace, [RoleId, RightType, DataBin, Utime]),
    db:execute(Sql).

%% 至尊vip技能
db_role_supvip_skill_task_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_skill_task_select, [RoleId]),
    db:get_all(Sql).

db_role_supvip_skill_task_replace(RoleId, SkillTask) ->
    #supvip_skill_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content} = SkillTask,
    ContentBin = util:term_to_bitstring(Content),
    Sql = io_lib:format(?sql_role_supvip_skill_task_replace, [RoleId, TaskId, IsFinish, IsCommit, ContentBin]),
    db:execute(Sql).

db_role_supvip_skill_task_delete(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_skill_task_delete, [RoleId]),
    db:execute(Sql).

%% 至尊vip技能效果
db_role_supvip_skill_effect_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_skill_effect_select, [RoleId]),
    db:get_all(Sql).

db_role_supvip_skill_effect_replace(RoleId, SkillEffect) ->
    #supvip_skill_effect{skill_id = SkillId, effect_id = EffectId, data = Data, utime = Utime} = SkillEffect,
    DataBin = util:term_to_bitstring(Data),
    Sql = io_lib:format(?sql_role_supvip_skill_effect_replace, [RoleId, SkillId, EffectId, DataBin, Utime]),
    db:execute(Sql).

%% 至尊币任务
db_role_supvip_currency_task_select(RoleId) ->
    Sql = io_lib:format(?sql_role_supvip_currency_task_select, [RoleId]),
    db:get_all(Sql).

db_role_supvip_currency_task_replace(RoleId, CurrencyTask) ->
    #supvip_currency_task{task_id = TaskId, is_finish = IsFinish, is_commit = IsCommit, content = Content, utime = Utime} = CurrencyTask,
    ContentBin = util:term_to_bitstring(Content),
    Sql = io_lib:format(?sql_role_supvip_currency_task_replace, [RoleId, TaskId, IsFinish, IsCommit, ContentBin, Utime]),
    db:execute(Sql).

db_role_supvip_currency_task_delete(RoleId, DelTime) ->
    Sql = io_lib:format(?sql_role_supvip_currency_task_delete, [RoleId, DelTime]),
    db:execute(Sql).

%% ----------------------------------------------------
%% 秘籍
%% ----------------------------------------------------

%% 更新充值天数
gm_update_charge_day(Player, ChargeDay) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    NewStatusSupVip = StatusSupVip#status_supvip{charge_day = ChargeDay},
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    NewPlayer = Player#player_status{supvip = NewStatusSupVip},
    PlayerAfDay = handle_charge_day(NewPlayer, 0),
    PlayerAfDay.

%% 更新登录天数
gm_update_login_days(Player, LoginDays) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    NewStatusSupVip = StatusSupVip#status_supvip{login_days = LoginDays},
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    NewPlayer = Player#player_status{supvip = NewStatusSupVip},
    {ok, NewPlayer2} = send_skill_task_info(NewPlayer),
    NewPlayer2.

%% 更新任务充值天数
gm_update_task_charge_day(#player_status{id = RoleId, supvip = StatusSupVip} = Player, ChargeDay) ->
    #status_supvip{skill_stage = Stage, skill_task_list = OldSkillTaskList} = StatusSupVip,
    F = fun(TaskId, TmpList) ->
        #base_supreme_vip_skill_task{content = Content} = data_supreme_vip:get_supreme_vip_skill_task(Stage, TaskId),
        SkillTask = get_skill_task(Player, TaskId),
        {IsUpdate, NewSkillTask} = do_gm_update_task_charge_day(Content, SkillTask, ChargeDay),
        case IsUpdate == true of
            true -> db_role_supvip_skill_task_replace(RoleId, NewSkillTask);
            false -> skip
        end,
        lists:keystore(TaskId, #supvip_skill_task.task_id, TmpList, NewSkillTask)
    end,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    SkillTaskL = lists:foldl(F, OldSkillTaskList, TaskIdL),
    NewStatusSupVip = StatusSupVip#status_supvip{skill_task_list = SkillTaskL},
    Player#player_status{supvip = NewStatusSupVip}.

do_gm_update_task_charge_day([], SkillTask, _ChargeDay) -> {false, SkillTask};
do_gm_update_task_charge_day([{TaskType=?SUPVIP_SKILL_TASK_RECHARGE, _NeedDay}|_T], SkillTask, ChargeDay) ->
    #supvip_skill_task{content = Content} = SkillTask,
    NewContent = lists:keystore(TaskType, 1, Content, {TaskType, ChargeDay, 0}),
    {true, SkillTask#supvip_skill_task{content = NewContent}};
do_gm_update_task_charge_day([_H|T], SkillTask, ChargeDay) ->
    do_gm_update_task_charge_day(T, SkillTask, ChargeDay).

%% 完成任务
gm_finish_skill_task(Player, TaskId) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, skill_task_list = SkillTaskList} = StatusSupVip,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    case lists:member(TaskId, TaskIdL) of
        true -> 
            SkillTask = get_skill_task(Player, TaskId),
            NewSkillTask = SkillTask#supvip_skill_task{is_finish = ?SUPVIP_FINISH_YES},
            db_role_supvip_skill_task_replace(RoleId, NewSkillTask),
            NewSkillTaskList = lists:keystore(TaskId, #supvip_skill_task.task_id, SkillTaskList, NewSkillTask),
            NewStatusSupVip = StatusSupVip#status_supvip{skill_task_list = NewSkillTaskList},
            Player#player_status{supvip = NewStatusSupVip};
        false ->
            Player
    end.

%% 完成本阶段所有任务
gm_finish_skill_task(Player) ->
    #player_status{supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage} = StatusSupVip,
    F = fun(TaskId, TmpPlayer) ->
        gm_finish_skill_task(TmpPlayer, TaskId)
    end,
    TaskIdL = data_supreme_vip:get_supvip_skill_task_id_list(Stage),
    lists:foldl(F, Player, TaskIdL).

%% 设置体验过期
gm_ex_ref(#player_status{id = RoleId, figure = Figure, supvip = StatusSupVip} = Player, Time) ->
    reduce_forbid_angle(Player),
    NowTime = utime:unixtime(),
    % 存储
    SupvipType = ?SUPVIP_TYPE_EX, SupvipTime = NowTime+Time,
    TodayGold = lib_recharge_data:get_today_pay_gold(RoleId),
    NewStatusSupVip = StatusSupVip#status_supvip{
        supvip_type = SupvipType, supvip_time = SupvipTime, active_time = NowTime, 
        today_gold = TodayGold, today_gold_utime = NowTime
        },
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    % 传闻
    #figure{name = Name} = Figure,
    lib_chat:send_TV({all}, ?MOD_SUPVIP, 1, [Name, RoleId]),
    IsSupvip = is_supvip(SupvipType, SupvipTime),
    NewFigure = Figure#figure{is_supvip = IsSupvip},
    PlayerAfBuy = Player#player_status{figure = NewFigure, supvip = NewStatusSupVip},
    % 同步场景
    mod_scene_agent:update(PlayerAfBuy, [{is_supvip, IsSupvip}]),
    lib_scene:broadcast_player_attr(PlayerAfBuy, [{10, IsSupvip}]),
    % 派发事件
    lib_player_event:async_dispatch(RoleId, ?EVENT_SUPVIP),
    PlayerAfDays = update_login_days(PlayerAfBuy),
    PlayerAfRef = try_trigger_ex_ref(PlayerAfDays),
    PlayerAfRef.

gm_print(Player) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{skill_stage = Stage, total_attr = TotalAttr, skill_list = SkillList, passive_skills = PassiveSkill} = StatusSupVip,
    ?PRINT("RoleId:~p Stage:~p TotalAttr:~p SkillList:~p PassiveSkill:~p ~n", [RoleId, Stage, TotalAttr, SkillList, PassiveSkill]).

%% 更新阶段
gm_update_stage(Player, SkillStage) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    % 子类型重新计算
    #status_supvip{skill_task_list = SkillTaskL} = StatusSupVip,
    SkillSubStage = recalc_skill_sub_stage(SkillStage, SkillTaskL),
    NewStatusSupVip = StatusSupVip#status_supvip{skill_stage = SkillStage, skill_sub_stage = SkillSubStage},
    db_role_supvip_replace(RoleId, NewStatusSupVip),
    NewPlayer = Player#player_status{supvip = NewStatusSupVip},
    send_info(NewPlayer),
    NewPlayer.

%% 清理特权
gm_clear_supvipright(Player, RightType) ->
    #player_status{id = RoleId, supvip = StatusSupVip} = Player,
    #status_supvip{right_list = RightList} = StatusSupVip,
    case lists:keyfind(RightType, #supvip_right.right_type, RightList) of
        false -> Player;
        OldRight -> 
            Right = OldRight#supvip_right{right_type = RightType, data = [], utime = 0},
            db_role_supvip_right_replace(RoleId, Right),
            NewRightList = lists:keystore(RightType, #supvip_right.right_type, RightList, Right),
            NewStatusSupVip = StatusSupVip#status_supvip{right_list = NewRightList},
            NewPlayer = Player#player_status{supvip = NewStatusSupVip},
            send_info(NewPlayer),
            NewPlayer
    end.
    