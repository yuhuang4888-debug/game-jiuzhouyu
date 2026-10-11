%% ---------------------------------------------------------------------------
%% @doc lib_arcana.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-10-22
%% @deprecated 幻饰boss
%% ---------------------------------------------------------------------------
-module(lib_arcana).

-include("server.hrl").
-include("arcana.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("skill.hrl").
-include("goods.hrl").

-compile(export_all).

make_record(arcana, [ArcanaId, Lv, BreakLv]) ->
    #arcana{id = ArcanaId, lv = Lv, break_lv = BreakLv}.

%% 登录
login(#player_status{id = RoleId} = Player) ->
    case db_role_arcana_core_select(RoleId) of
        [] -> CoreType = 0;
        [CoreType] -> ok
    end,
    List = db_role_arcana_select(RoleId),
    F = fun(T) -> make_record(arcana, T) end,
    ArcanaL = lists:map(F, List),
    StatusArcana = #status_arcana{core_type = CoreType, arcana_list = ArcanaL},
    NewPlayer = Player#player_status{arcana = StatusArcana},
    PlayerAfCalc = calc_mod(NewPlayer),
    PlayerAfCalc.

%% 重连
relogin(Player) ->
    PlayerAfFix = atuo_fix_skill_lv(Player),
    PlayerAfFix.

%% 自动修复主动技能等级##防止某一时间点没有触发成功
atuo_fix_skill_lv(Player) ->
    #player_status{figure = #figure{career = Career, sex = Sex}, arcana = StatusArcana, skill = StatusSkill} = Player,
    #status_arcana{arcana_list = ArcanaL} = StatusArcana,
    #status_skill{skill_list = SkillL} = StatusSkill,
    F = fun(#arcana{id = ArcanaId, lv = ArcanaLv}, TmpPlayer) ->
        case data_arcana:get_arcana_lv(ArcanaId, Career, ArcanaLv) of
            #base_arcana_lv{skill_id = SkillId, skill_lv = SkillLv} ->
                CareerSkillIds = data_skill:get_ids(Career, Sex),
                IsMember = lists:keymember(SkillId, 1, CareerSkillIds),
                if
                    % 只能触发玩家技能
                    IsMember == false -> TmpPlayer;
                    true ->
                        % 等级超过就不触发
                        case lists:keyfind(SkillId, 1, SkillL) of
                            {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> TmpPlayer;
                            _ ->
                                {_IsSuccess, NewTmpPlayer} = lib_skill:immediate_upgrade_skill(TmpPlayer, SkillId),
                                NewTmpPlayer
                        end
                end;
            _ ->
                TmpPlayer
        end
    end,
    NewPlayer = lists:foldl(F, Player, ArcanaL),
    NewPlayer.

%% 计算模块
calc_mod(Player) ->
    #player_status{figure = #figure{career = Career}, arcana = StatusArcana} = Player,
    #status_arcana{arcana_list = ArcanaL} = StatusArcana,
    F = fun(#arcana{id = ArcanaId, lv = Lv, break_lv = BreakLv}, {LvSkillL, BreakSkillL}) ->
        case data_arcana:get_arcana_lv(ArcanaId, Career, Lv) of
            #base_arcana_lv{skill_id = SkillId, skill_lv = SkillLv} -> NewLvSkillL = [{SkillId, SkillLv}|LvSkillL];
            _ -> NewLvSkillL = LvSkillL
        end,
        case data_arcana:get_arcana_break(ArcanaId, Career, BreakLv) of
            #base_arcana_break{skill_id = BfSkillId, break_skill_id = BreakSkillId} when BreakLv > 0 -> 
                NewBreakSkillL = [{BfSkillId, BreakSkillId}|BreakSkillL];
            _ ->
                NewBreakSkillL = BreakSkillL
        end,
        {NewLvSkillL, NewBreakSkillL}
    end,
    {LvSkillL, BreakSkillL} = lists:foldl(F, {[], []}, ArcanaL),
    F2 = fun({SkillId, SkillLv}, TmpList) ->
        case lists:keyfind(SkillId, 1, BreakSkillL) of
            false -> [{SkillId, SkillLv}|TmpList];
            {SkillId, BreakSkillId} -> [{BreakSkillId, SkillLv}|TmpList]
        end
    end,
    % 总技能列表
    SkillL = lists:foldl(F2, [], LvSkillL),
    % 被动技能
    PassiveSkills = lib_skill:divide_passive_skill(SkillL),
    % 主动技能
    F3 = fun({SkillId, SkillLv}, TmpList) ->
        case data_skill:get(SkillId, SkillLv) of
            #skill{career = ?SKILL_CAREER_ARCANA, type = 1, is_combo = 0} -> [{SkillId, SkillLv}|TmpList];
            _ -> TmpList
        end
    end,
    ActiveList = lists:foldl(F3, [], SkillL),
    % 获得属性
    Attr = lib_skill:get_passive_skill_attr(SkillL),
    % 获得技能替换
    ReSkillL = BreakSkillL,
    % 技能
    SecAttr = lib_skill:get_passive_skill_sec_attr(PassiveSkills),
    SkillPower = lib_skill_api:get_skill_power(SkillL),
    NewStatusArcana = StatusArcana#status_arcana{
        skill_list = SkillL, passive_skills = PassiveSkills, active_list = ActiveList, total_attr = Attr, 
        reskill_list = ReSkillL, sec_attr = SecAttr, skill_power = SkillPower
        },
    Player#player_status{arcana = NewStatusArcana}.

%% 获取被动技能
get_passive_skill(#player_status{arcana = #status_arcana{passive_skills = PassiveSkills}}) -> 
    PassiveSkills.

%% 获取远古奥术的技能
get_active_skill(#player_status{arcana = #status_arcana{active_list = ActiveList}}) -> 
    ActiveList.

%% 是否学习技能
check_skill_has_learn(#player_status{arcana = #status_arcana{active_list = ActiveList}}, SkillId) ->
    case lists:keyfind(SkillId, 1, ActiveList) of
        {SkillId, SkillLv} when SkillLv > 0 -> {true, SkillLv};
        _ -> false
    end.

%% 替换快捷栏技能
re_quickbar(Player) ->
    #player_status{quickbar = Quickbar} = Player,
    F = fun({Pos, Type, SkillId, Auto}) ->
        case Type == ?QUICKBAR_TYPE_SKILL of
            true -> 
                ReSkillId = get_high_reskill_id(Player, SkillId),
                {Pos, Type, ReSkillId, Auto};
            false ->
                {Pos, Type, SkillId, Auto}
        end
    end,
    NewQuickbar = lists:map(F, Quickbar),
    NewPlayer = Player#player_status{quickbar = NewQuickbar},
    case Quickbar =/= NewQuickbar of
        true -> {true, NewPlayer};
        false -> {false, Player}
    end.

%% 替换快捷栏技能
re_quickbar_with_notify(Player) ->
    {IsChange, NewPlayer} = re_quickbar(Player),
    case IsChange of
        true -> 
            lib_player:db_save_quickbar(NewPlayer),
            lib_player:send_quickbar_info(NewPlayer);
        false -> 
            skip
    end,
    NewPlayer.

%% 获取高级的技能id
get_high_reskill_id(Player, SkillId) ->
    #player_status{arcana = #status_arcana{reskill_list = ReSkillL}} = Player,
    get_high_reskill_id_help(ReSkillL, SkillId).

get_high_reskill_id_help([], SkillId) -> SkillId;
get_high_reskill_id_help(ReSkillL, SkillId) ->
    case lists:keytake(SkillId, 1, ReSkillL) of
        false -> SkillId;
        {value, {SkillId, ReSkillId}, LeftReSkillL} -> 
            get_high_reskill_id_help(LeftReSkillL, ReSkillId)
    end.

%% 获得替换前的技能id
get_before_reskill_id(Player, ReSkillId) ->
    #player_status{arcana = #status_arcana{reskill_list = ReSkillL}} = Player,
    get_before_reskill_id_help(ReSkillL, ReSkillId).

get_before_reskill_id_help([], ReSkillId) -> ReSkillId;
get_before_reskill_id_help(ReSkillL, ReSkillId) ->
    case lists:keytake(ReSkillId, 2, ReSkillL) of
        false -> ReSkillId;
        {value, {SkillId, ReSkillId}, LeftReSkillL} -> 
            get_before_reskill_id_help(LeftReSkillL, SkillId)
    end.
    
%% 同步到场景
sync_to_scene(Player, OldPlayer) ->
    #player_status{battle_attr = BattleAttr, arcana = #status_arcana{passive_skills = NewPassveSkills}} = Player,
    #player_status{arcana = #status_arcana{passive_skills = OldPassiveSkills}} = OldPlayer,
    F = fun({SkillId, Lv}, DelPassiveSkills) ->
        case lists:keymember(SkillId, 1, NewPassveSkills) of
            true -> DelPassiveSkills;
            false -> [{SkillId, Lv}|DelPassiveSkills]
        end
    end,
    DelPassiveSkills = lists:foldl(F, [], OldPassiveSkills),
    KvList = [{battle_attr, BattleAttr}, {passive_skill, NewPassveSkills}, {delete_passive_skill, DelPassiveSkills}],
    mod_scene_agent:update(Player, KvList),
    ok.

%% 远古奥术信息
send_info(Player) ->
    #player_status{sid = Sid, arcana = StatusArcana} = Player,
    #status_arcana{core_type = CoreType, arcana_list = ArcanaL} = StatusArcana,
    F = fun(#arcana{id = ArcanaId, lv = Lv, break_lv = BreakLv}) -> {ArcanaId, Lv, BreakLv} end,
    ClientArcanaL = lists:map(F, ArcanaL),
    {ok, BinData} = pt_211:write(21101, [CoreType, ClientArcanaL]),
    lib_server_send:send_to_sid(Sid, BinData),
    ok.

%% 升级
up_lv(#player_status{sid = Sid} = Player, ArcanaId) ->
    {ErrCode, PlayerAfCount} = up_lv_help(Player, ArcanaId),
    ?PRINT("ArcanaId:~p ~n", [ArcanaId]),
    {ok, BinData} = pt_211:write(21102, [ErrCode, ArcanaId]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PlayerAfCount}.

%% 判断基础
up_lv_help(#player_status{figure = #figure{lv = Lv}} = Player, ArcanaId) ->
    CheckLv = Lv >= ?ARCANA_KV_LV,
    CheckOpenDay = util:get_open_day() >= ?ARCANA_KV_OPEN_DAY,
    if
        CheckLv == false -> {?ERRCODE(err211_lv_not_enough), Player};
        CheckOpenDay == false -> {?ERRCODE(err211_open_day_not_enough), Player};
        true ->
            auto_up_lv_help(Player, ArcanaId)
    end.

%% 自动升级
auto_up_lv_help(#player_status{id = RoleId} = Player, ArcanaId) ->
    case chekc_up_lv(Player, ArcanaId) of
        {false, ErrCode} -> PlayerAfCount = Player;
        {true, Arcana, NewArcanaLv, Cost} -> 
            About = lists:concat(["ArcanaId:", ArcanaId, ",ArcanaLv:", NewArcanaLv]),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, arcana_lv, About) of
                {false, ErrCode, PlayerAfCount} -> ok;
                {true, PlayerAfCost} -> 
                    ErrCode = ?SUCCESS,
                    #player_status{arcana = StatusArcana} = PlayerAfCost,
                    #status_arcana{arcana_list = ArcanaL} = StatusArcana,
                    NewArcana = Arcana#arcana{lv = NewArcanaLv},
                    db_role_arcana_replace(RoleId, NewArcana),
                    lib_log_api:log_arcana_lv(RoleId, ArcanaId, NewArcanaLv, Cost),
                    NewArcanaL = lists:keystore(ArcanaId, #arcana.id, ArcanaL, NewArcana),
                    NewStatusArcana = StatusArcana#status_arcana{arcana_list = NewArcanaL},
                    NewPlayer = Player#player_status{arcana = NewStatusArcana},
                    PlayerAfCalc = calc_mod(NewPlayer),
                    PlayerAfTrigger = trigger_skill_lv(PlayerAfCalc, ArcanaId, NewArcanaLv),
                    % 同步战力
                    PlayerAfCount = lib_player:count_player_attribute(PlayerAfTrigger),
                    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
                    sync_to_scene(PlayerAfCount, Player)
            end
    end,
    {ErrCode, PlayerAfCount}.

%% 触发技能升级[要触发一下玩家技能升级]
trigger_skill_lv(Player, ArcanaId, ArcanaLv) ->
    #player_status{figure = #figure{career = Career, sex = Sex}, skill = #status_skill{skill_list = SkillL}} = Player,
    case data_arcana:get_arcana_lv(ArcanaId, Career, ArcanaLv) of
        #base_arcana_lv{skill_id = SkillId, skill_lv = SkillLv} ->
            CareerSkillIds = data_skill:get_ids(Career, Sex),
            IsMember = lists:keymember(SkillId, 1, CareerSkillIds),
            if
                % 只能触发玩家技能
                IsMember == false -> Player;
                true ->
                    % 等级超过就不触发
                    case lists:keyfind(SkillId, 1, SkillL) of
                        {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> Player;
                        _ ->
                            {_IsSuccess, NewPlayer} = lib_skill:immediate_upgrade_skill(Player, SkillId),
                            NewPlayer
                    end
            end;
        _ ->
            Player
    end.
            
chekc_up_lv(Player, ArcanaId) ->
    #player_status{figure = #figure{career = Career}, arcana = StatusArcana} = Player,
    #status_arcana{core_type = CoreType, arcana_list = ArcanaL} = StatusArcana,
    case lists:keyfind(ArcanaId, #arcana.id, ArcanaL) of
        false -> Arcana = make_record(arcana, [ArcanaId, 0, 0]);
        Arcana -> ok
    end,
    #arcana{lv = ArcanaLv} = Arcana,
    NewArcanaLv = ArcanaLv + 1,
    BaseArcana = data_arcana:get_arcana(ArcanaId),
    BaseArcanaLv = data_arcana:get_arcana_lv(ArcanaId, Career, NewArcanaLv),
    if
        is_record(BaseArcana, base_arcana) == false -> {false, ?MISSING_CONFIG};
        is_record(BaseArcanaLv, base_arcana_lv) == false -> {false, ?MISSING_CONFIG};
        BaseArcana#base_arcana.is_core == 1 andalso CoreType =/= BaseArcana#base_arcana.core_type -> 
            {false, ?ERRCODE(err211_core_type_error)};
        true ->
            #base_arcana_lv{condition = Condition} = BaseArcanaLv,
            case check_condition(Condition, Player) of
                {false, ErrCode} -> {false, ErrCode};
                true -> 
                    case lists:keyfind(cost, 1, Condition) of
                        false -> Cost = [];
                        {cost, Cost} -> ok
                    end,
                    {true, Arcana, NewArcanaLv, Cost}
            end
    end.

check_condition([], _Player) -> true;

check_condition([{arcana, ArcanaId, NeedLv}|T], Player) ->
    #player_status{arcana = #status_arcana{arcana_list = ArcanaL}} = Player,
    case lists:keyfind(ArcanaId, #arcana.id, ArcanaL) of
        #arcana{lv = Lv} when Lv >= NeedLv -> check_condition(T, Player);
        _ -> {false, ?ERRCODE(err211_this_arcana_lv_not_enough)}
    end;

check_condition([{arcana_lv, NeedLv}|T], Player) ->
    Lv = get_arcana_total_lv(Player),
    case Lv >= NeedLv of
        true -> check_condition(T, Player);
        false -> {false, ?ERRCODE(err211_arcana_total_lv_not_enough)}
    end;

check_condition([{cost, Cost}|T], Player) ->
    case lib_goods_api:check_object_list(Player, Cost) of
        {false, ErrCode} -> {false, ErrCode};
        true -> check_condition(T, Player)
    end;

check_condition([{pre_skill, SkillId, NeedLv}|T], Player) ->
    #player_status{skill = #status_skill{skill_list = SkillL}} = Player,
    case lists:keyfind(SkillId, 1, SkillL) of
        {SkillId, Lv} when Lv >= NeedLv -> check_condition(T, Player);
        _ -> {false, ?ERRCODE(err211_must_finish_pre_skill)}
    end;

check_condition([_H|_T], _Player) -> 
    {false, ?FAIL}.

%% 获取总等级
get_arcana_total_lv(Player) ->
    #player_status{arcana = #status_arcana{arcana_list = ArcanaL}} = Player,
    lists:sum([Lv||#arcana{lv=Lv}<-ArcanaL]).

%% 自动升级
auto_up_lv(#player_status{figure = #figure{career = Career}, arcana = #status_arcana{arcana_list = ArcanaL}} = Player) ->
    ArcanaIdL = data_arcana:get_arcana_id_list(Career),
    F = fun(ArcanaId, {TmpPlayer, IsChange}) ->
        case lists:keyfind(ArcanaId, #arcana.id, ArcanaL) of
            false -> Lv = 0;
            #arcana{lv = Lv} -> ok
        end,
        NewLv = Lv + 1,
        case data_arcana:get_arcana_lv(ArcanaId, Career, NewLv) of
            #base_arcana_lv{is_auto = 1} ->
                {ErrCode, NewTmpPlayer} = auto_up_lv_help(TmpPlayer, ArcanaId),
                {NewTmpPlayer, ErrCode == ?SUCCESS orelse IsChange};
            _ ->
                {TmpPlayer, IsChange}
        end
    end,
    {NewPlayer, IsChange} = lists:foldl(F, {Player, false}, ArcanaIdL),
    case IsChange of
        true -> send_info(Player);
        false -> skip
    end,
    NewPlayer.

%% 突破
break_lv(#player_status{id = RoleId, sid = Sid} = Player, ArcanaId) ->
    case check_break_lv(Player, ArcanaId) of
        {false, ErrCode} -> PlayerAfCount = Player, NewBreakLv = 0;
        {true, Arcana, NewBreakLv, Cost} -> 
            About = lists:concat(["ArcanaId:", ArcanaId, ",BreakLv:", NewBreakLv]),
            case lib_goods_api:cost_object_list_with_check(Player, Cost, arcana_break_lv, About) of
                {false, ErrCode, PlayerAfCount} -> ok;
                {true, PlayerAfCost} -> 
                    ErrCode = ?SUCCESS,
                    #player_status{arcana = StatusArcana} = PlayerAfCost,
                    #status_arcana{arcana_list = ArcanaL} = StatusArcana,
                    NewArcana = Arcana#arcana{break_lv = NewBreakLv},
                    db_role_arcana_replace(RoleId, NewArcana),
                    lib_log_api:log_arcana_break(RoleId, ArcanaId, NewBreakLv, Cost),
                    NewArcanaL = lists:keystore(ArcanaId, #arcana.id, ArcanaL, NewArcana),
                    NewStatusArcana = StatusArcana#status_arcana{arcana_list = NewArcanaL},
                    NewPlayer = Player#player_status{arcana = NewStatusArcana},
                    PlayerAfCalc = calc_mod(NewPlayer),
                    % 突破可能技能id换了
                    PlayerAfRe = re_quickbar_with_notify(PlayerAfCalc),
                    % 同步战力
                    PlayerAfCount = lib_player:count_player_attribute(PlayerAfRe),
                    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
                    sync_to_scene(PlayerAfCount, Player)
            end
    end,
    {ok, BinData} = pt_211:write(21103, [ErrCode, ArcanaId, NewBreakLv]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PlayerAfCount}.

check_break_lv(Player, ArcanaId) ->
    #player_status{figure = #figure{career = Career, lv = Lv}, arcana = StatusArcana} = Player,
    #status_arcana{core_type = CoreType, arcana_list = ArcanaL} = StatusArcana,
    case lists:keyfind(ArcanaId, #arcana.id, ArcanaL) of
        false -> Arcana = make_record(arcana, [ArcanaId, 0, 0]);
        Arcana -> ok
    end,
    #arcana{break_lv = BreakLv} = Arcana,
    NewBreakLv = BreakLv + 1,
    BaseArcana = data_arcana:get_arcana(ArcanaId),
    BaseArcanaBreak = data_arcana:get_arcana_break(ArcanaId, Career, NewBreakLv),
    CheckLv = Lv >= ?ARCANA_KV_LV,
    CheckOpenDay = util:get_open_day() >= ?ARCANA_KV_OPEN_DAY,
    if
        is_record(BaseArcana, base_arcana) == false -> {false, ?MISSING_CONFIG};
        is_record(BaseArcanaBreak, base_arcana_break) == false -> {false, ?MISSING_CONFIG};
        BaseArcana#base_arcana.is_core == 1 andalso CoreType =/= BaseArcana#base_arcana.core_type -> 
            {false, ?ERRCODE(err211_core_type_not_same)};
        CheckLv == false -> {false, ?ERRCODE(err211_lv_not_enough)};
        CheckOpenDay == false -> {false, ?ERRCODE(err211_open_day_not_enough)};
        true ->
            #base_arcana_break{condition = Condition} = BaseArcanaBreak,
            case check_condition(Condition, Player) of
                {false, ErrCode} -> {false, ErrCode};
                true -> 
                    case lists:keyfind(cost, 1, Condition) of
                        false -> Cost = [];
                        {cost, Cost} -> ok
                    end,
                    {true, Arcana, NewBreakLv, Cost}
            end
    end.

%% 选择核心
select_core(#player_status{id = RoleId, sid = Sid} = Player, CoreType) ->
    case check_select_core(Player, CoreType) of
        {false, ErrCode} -> NewPlayer = Player;
        true ->
            ErrCode = ?SUCCESS,
            #player_status{arcana = StatusArcana} = Player,
            NewStatusArcana = StatusArcana#status_arcana{core_type = CoreType},
            db_role_arcana_core_replace(RoleId, NewStatusArcana),
            lib_log_api:log_arcana_core(RoleId, CoreType),
            NewPlayer = Player#player_status{arcana = NewStatusArcana}
    end,
    {ok, BinData} = pt_211:write(21104, [ErrCode, CoreType]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, NewPlayer}.

check_select_core(Player, TargetCoreType) ->
    #player_status{figure = #figure{career = Career, lv = Lv}, arcana = StatusArcana} = Player,
    #status_arcana{core_type = CoreType} = StatusArcana,
    CoreTypeL = data_arcana:get_arcana_core_type(Career, 1),
    IsMember = lists:member(TargetCoreType, CoreTypeL),
    CheckLv = Lv >= ?ARCANA_KV_LV,
    CheckOpenDay = util:get_open_day() >= ?ARCANA_KV_OPEN_DAY,
    if
        CoreType > 0 -> {false, ?ERRCODE(err211_had_select_core)};
        IsMember == false -> {false, ?ERRCODE(err211_core_type_error)};
        CheckLv == false -> {false, ?ERRCODE(err211_lv_not_enough)};
        CheckOpenDay == false -> {false, ?ERRCODE(err211_open_day_not_enough)};
        true -> true
    end.

%% 重置

change_arcana_with_transfer(Player, OldCareer) ->
    #player_status{id = RoleId, figure = #figure{career = Career, sex = Sex}, arcana = StatusArcana} = Player,
    #status_arcana{arcana_list = ArcanaL} = StatusArcana,
    CareerSkillIds = data_skill:get_ids(Career, Sex),
    F = fun(Arcana, {List, TmpPlayer}) ->
        #arcana{id = OldArcanaId, lv = ArcanaLv} = Arcana,
        case data_transfer:get_arcana_transfer(OldCareer, Career, OldArcanaId) of 
            0 -> {[Arcana|List], TmpPlayer};
            NewArcanaId ->
                case data_arcana:get_arcana_lv(NewArcanaId, Career, ArcanaLv) of
                    #base_arcana_lv{skill_id = SkillId, skill_lv = SkillLv} ->
                        NewArcana = Arcana#arcana{id = NewArcanaId},
                        db:execute(io_lib:format("update role_arcana set arcana_id = ~p where role_id=~p and arcana_id=~p", [NewArcanaId, RoleId, OldArcanaId])),
                        IsMember = lists:keymember(SkillId, 1, CareerSkillIds),
                        NewList = [NewArcana|List],
                        if
                            % 只能触发玩家技能
                            IsMember == false -> 
                                {NewList, TmpPlayer};
                            true ->
                                % 等级超过就不触发
                                case lists:keyfind(SkillId, 1, TmpPlayer#player_status.skill#status_skill.skill_list) of
                                    {SkillId, NowSkillLv} when NowSkillLv >= SkillLv -> 
                                        {NewList, TmpPlayer};
                                    _ ->
                                        NewTmpPlayer = lib_skill:replace_skill_level(TmpPlayer, SkillId, SkillLv),
                                        {NewList, NewTmpPlayer}
                                end
                        end;
                    _ ->
                        {[Arcana|List], TmpPlayer}
                end
        end 
    end,
    {NewArcanaL, PlayerAftransfer} = lists:foldl(F, {[], Player}, ArcanaL),
    NewStatusArcana = StatusArcana#status_arcana{arcana_list = NewArcanaL},
    NewPlayer = PlayerAftransfer#player_status{arcana = NewStatusArcana},
    PlayerAfCalc = calc_mod(NewPlayer),
    PlayerAfCalc.

% 骑士 480112 480113 480115 480122 480123 480125
% 弓箭手 480212 480213 480215 480222 480223 480225
gm_reset(Player) ->
    #player_status{id = RoleId, arcana = StatusArcana} = Player,
    NewStatusArcana = StatusArcana#status_arcana{core_type = 0, arcana_list = []},
    NewPlayer = Player#player_status{arcana = NewStatusArcana},
    Sql = io_lib:format(<<"DELETE FROM role_arcana WHERE role_id = ~p">>, [RoleId]),
    db:execute(Sql),
    Sql2 = io_lib:format(<<"DELETE FROM role_arcana_core WHERE role_id = ~p">>, [RoleId]),
    db:execute(Sql2),
    PlayerAfCalc = calc_mod(NewPlayer),
    % 同步战力
    PlayerAfCount = lib_player:count_player_attribute(PlayerAfCalc),
    lib_player:send_attribute_change_notify(PlayerAfCount, ?NOTIFY_ATTR),
    sync_to_scene(PlayerAfCount, Player),
    lib_arcana:send_info(PlayerAfCount),
    PlayerAfCount.
    
%% 获取远古奥术核心类型
db_role_arcana_core_select(RoleId) ->
    Sql = io_lib:format(?sql_role_arcana_core_select, [RoleId]),
    db:get_row(Sql).

%% 插入远古奥术核心类型
db_role_arcana_core_replace(RoleId, StatusArcana) ->
    #status_arcana{core_type = CoreType} = StatusArcana,
    Sql = io_lib:format(?sql_role_arcana_core_replace, [RoleId, CoreType]),
    db:execute(Sql).

%% 获取远古奥术
db_role_arcana_select(RoleId) ->
    Sql = io_lib:format(?sql_role_arcana_select, [RoleId]),
    db:get_all(Sql).

%% 插入远古奥术
db_role_arcana_replace(RoleId, Arcana) ->
    #arcana{id = ArcanaId, lv = Lv, break_lv = BreakLv} = Arcana,
    Sql = io_lib:format(?sql_role_arcana_replace, [RoleId, ArcanaId, Lv, BreakLv]),
    db:execute(Sql).