%%---------------------------------------------------------------------------
%% @doc:        lib_mount_upgrade_sys
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-3月-04. 17:44
%% @deprecated: 坐骑精灵升级系统
%%---------------------------------------------------------------------------
-module(lib_mount_upgrade_sys).

-include("common.hrl").
-include("server.hrl").
-include("mount.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("goods.hrl").

%% API
-export([
    send_panel_info/2,
    upgrade_mount/2,
    upgrade_skill_level/3,
    init_data/1,
    auto_active_skill_by_level/3,
    after_add_skill/2,
    get_data/2
]).

-export([
    gm_set_mount_level/3
]).

send_panel_info(Ps, TypeId) ->
    #player_status{id = PlayerId, status_mount = StatusMountL } = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountL) of
        #status_mount{combat = Combat, upgrade_sys_skill = SkillList, upgrade_sys_exp = Exp, upgrade_sys_level = Lv} ->
            UnlockSkillList = data_mount:get_skill_by_type(TypeId, ?MOUNT_UPGRADE_SYS_SKILL, 0),
            NotActiveSkill = [{SkillId, 0} || SkillId <- UnlockSkillList, lists:keymember(SkillId, 1, SkillList) == false],
            Args = [TypeId, Lv, Exp, Combat, [], SkillList ++ NotActiveSkill],
            pack(PlayerId, 16028, Args);
        _ ->
            skip
    end.

upgrade_mount(Ps, TypeId) ->
    #player_status{id = PlayerId, status_mount = StatusMountL } = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountL) of
        #status_mount{upgrade_sys_exp = PreExp, upgrade_sys_level = PreLevel, upgrade_sys_skill = SkillList} = StatusMount ->
            case catch check_can_upgrade_mount(PlayerId, StatusMount) of
                {ok, NewLevel, OverExp, CostsL, AddSumExp} ->
                    %% 删除消耗
                    {true, NewPs} = lib_goods_api:cost_object_list(Ps, CostsL, mount_upgrade_cost, ""),
                    %% 判断是否有需要自动激活的技能
                    case NewLevel > PreLevel of
                        true ->
                            NewSkillList = auto_active_skill_by_level(TypeId, NewLevel, SkillList);
                        _ ->
                            NewSkillList = SkillList
                    end,
                    %% 更新数据库内容
                    db:execute(io_lib:format(?SQL_UPDATE_MOUNT_UPGRADE_DATA, [PlayerId, TypeId, NewLevel, OverExp, util:term_to_string(NewSkillList)])),
                    %% 更新PlayerStatus
                    NewStatusMount0 = StatusMount#status_mount{ upgrade_sys_exp = OverExp, upgrade_sys_level = NewLevel, upgrade_sys_skill = NewSkillList},
                    NewStatusMount = after_add_skill(Ps, NewStatusMount0),
                    NewStatusMountList = lists:keyreplace(TypeId, #status_mount.type_id, StatusMountL, NewStatusMount),
                    %% 记录日志
                    lib_log_api:log_mount_upgrade_sys(PlayerId, TypeId, PreLevel, PreExp, AddSumExp, NewLevel, OverExp, CostsL),
                    IsLevelUp = NewLevel =/= PreLevel,
                    case IsLevelUp of
                        true ->
                            %% 升到新等级时更新战力、属性等相关信息
                            PlayerAfFigure = lib_mount:count_mount_attr(NewPs#player_status{status_mount = NewStatusMountList}),
                            %% 向场景广播
                            NewPlayerS = lib_mount:broadcast_to_scene(TypeId, PlayerAfFigure),
                            %% 时间触发
                            LastPs = lib_mount_api:power_change_event(NewPlayerS, TypeId);
                        false ->
                            LastPs = NewPs#player_status{ status_mount = NewStatusMountList }
                    end,
                    Combat = lib_mount:get_status_combat(TypeId, LastPs),
                    UnlockSkillList = data_mount:get_skill_by_type(TypeId, ?MOUNT_UPGRADE_SYS_SKILL, 0),
                    SendSkillList = NewSkillList ++ [ {SkillId, 0} || SkillId <- UnlockSkillList,  lists:keymember(SkillId, 1, NewSkillList) == false],
                    SendArgs = [?SUCCESS, TypeId, NewLevel, OverExp, AddSumExp, Combat, SendSkillList, []],
                    upgrade_mount_event(LastPs, CostsL, IsLevelUp, TypeId, NewLevel),
                    pack(PlayerId, 16029, SendArgs);
                {error, ErrorType} ->
                    LastPs = Ps,
                    pack(PlayerId, 16029, [?ERRCODE(ErrorType), TypeId, 0, 0, 0, 0, [], []])
            end;
        _ ->
            LastPs = Ps,
            pack(PlayerId, 16029, [?ERRCODE(lv_limit), TypeId, 0, 0, 0, 0, [], []])
    end,
    {ok, LastPs}.

upgrade_mount_event(PS, CostsL, IsLevelUp, TypeId, NewLevel) ->
    IsLevelUp andalso lib_task_api:upgrade_mount_level(PS, TypeId, NewLevel),
    lib_cycle_rank:calc_cycle_rank_score(PS, CostsL).


%% 技能升级操作
upgrade_skill_level(Ps, TypeId, SkillId) ->
    #player_status{ id = PlayerId, status_mount = StatusMountList } = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountList) of
        #status_mount{
            upgrade_sys_skill = SkillLevelList,
            upgrade_sys_level = UpgradeLevel,
            devour_exp = OverExp
        } = StatusMount ->
            case catch check_can_upgrade_skill_level(TypeId, UpgradeLevel, SkillId, SkillLevelList) of
                {ok, NewSkillLevelList, NewLevel} ->
                    db:execute(io_lib:format(?SQL_UPDATE_MOUNT_UPGRADE_DATA, [PlayerId, TypeId, UpgradeLevel, OverExp, util:term_to_string(NewSkillLevelList)])),
                    NewStatusMount0 = StatusMount#status_mount{ upgrade_sys_skill = NewSkillLevelList },
                    NewStatusMount = after_add_skill(Ps, NewStatusMount0),
                    NewStatusMountL = lists:keystore(TypeId, #status_mount.type_id, StatusMountList, NewStatusMount),
                    PlayerAfFigure = lib_mount:count_mount_attr(Ps#player_status{status_mount = NewStatusMountL}),
                    NewPlayerS = lib_mount:broadcast_to_scene(TypeId, PlayerAfFigure),
                    LastPs = lib_mount_api:power_change_event(NewPlayerS, TypeId),
                    pack(PlayerId, 16030, [?SUCCESS, TypeId, SkillId, NewLevel]);
                {error, CodeMsg} ->
                    LastPs = Ps,
                    pack(PlayerId, 16030, [?ERRCODE(CodeMsg), TypeId, 0, 0])
            end;
        _ ->
            LastPs = Ps,
            pack(PlayerId, 16030, [?ERRCODE(lv_limit), TypeId, 0, 0])
    end,
    {ok, LastPs}.

%% 初始化该培养线的数据
init_data(TypeId) ->
    InitSkillL = auto_active_skill_by_level(TypeId, ?INIT_UPGRADE_LV, []),
    {?INIT_UPGRADE_LV, ?INIT_UPGRADE_EXP, InitSkillL}.

%% 自动激活或者升级技能
auto_active_skill_by_level(TypeId, Level, SkillList) ->
    UnlockSkillList = data_mount:get_skill_by_type(TypeId, ?MOUNT_UPGRADE_SYS_SKILL, 0),
    Fun = fun(SkillId, AccL) ->
        case data_mount:get_skill_cfg(TypeId, SkillId) of
            #mount_skill_cfg{ stage = 0 } ->
                AccL;
            #mount_skill_cfg{ stage = State } ->
                case Level >= State andalso not lists:keymember(SkillId, 1, AccL) of
                    true ->
                        [{SkillId, ?INIT_SKILL_LEVEL}|AccL];
                    _ ->
                        AccL
                end;
            _ ->
                AccL
        end
    end,
    lists:foldl(Fun, SkillList, UnlockSkillList).

%% 添加技能后的处理
after_add_skill(Player, StatuMount) ->
    #status_mount{ skills = SkillL, figure_skills = FSkillL, upgrade_sys_skill = USkillL } = StatuMount,
    NewPassiveSkills = lib_skill_api:divide_passive_skill(SkillL ++ FSkillL ++ USkillL),
    case NewPassiveSkills =/= [] of
        true ->
            mod_scene_agent:update(Player, [{passive_skill, NewPassiveSkills}]);
        false -> skip
    end,
    StatuMount#status_mount{ passive_skills = NewPassiveSkills}.

%% ========================================================
%% function_inner_function
%% ========================================================

%% 检测坐骑类升级的合法性
%% 最后返回{ok, 新等级, 超过经验数量, 消耗道具列表, 总增加的金养殖}
check_can_upgrade_mount(Ps, StatusMount) ->
    #status_mount{ type_id = TypeId, upgrade_sys_level = CurLevel, upgrade_sys_exp = CurExp } = StatusMount,
    AllGoodsIdList = data_mount:get_all_goods(TypeId, ?EXPGOODS_TYPE_UPGRADE),
    #base_mount_level_info{ need_exp = LevelMaxExp} = data_mount:get_mount_level_info(TypeId, CurLevel),
    %% 满级需要的经验值
    DifferExp = LevelMaxExp - CurExp,
    %% 计算背包各类道具的数量与经验总额
    Fun = fun(GoodsId, AccL) ->
        case get_goods_num(Ps, GoodsId) of
            0 ->
                AccL;
            Num when is_integer(Num) ->
                AccL ++ [{GoodsId, Num}];
            _ ->
                AccL
        end
    end,
    GoodsNumList = lists:foldl(Fun, [], AllGoodsIdList),
    ?IF( GoodsNumList =/= [], ok, throw({error, err160_no_goods_upgrade})),
    {NeedCostList, SuperPlusExp, IsEnd} = exp_goods_is_enough(GoodsNumList, TypeId, [], DifferExp, false),
    NewLevel = ?IF(IsEnd, CurLevel+1, CurLevel),
    ?IF( data_mount:get_mount_level_info(TypeId, NewLevel) == [], throw({error, err423_max_lv}), ok),
    SumAddExp = calc_this_times_add_exp(NeedCostList, 0, TypeId),
    case IsEnd of
        true ->
            %% 在使用一次道具后，累加的经验是否足够升多级
            {ok, FixNewLevel, FixSuperPlusExp} = is_more_level(TypeId, NewLevel, SuperPlusExp),
            {ok, FixNewLevel, FixSuperPlusExp, NeedCostList, SumAddExp};
        _ ->
            NewExp = CurExp + SuperPlusExp,
            {ok, NewLevel, NewExp, NeedCostList, SumAddExp}
    end.

%% 检测背包道具是否足够升一级
exp_goods_is_enough([], _, CostsL, OverExp, IsOver) ->
    {CostsL, OverExp, IsOver};
exp_goods_is_enough(_, _, CostsL, OverExp, true) ->
    {CostsL, OverExp, true};
%% 升级时判断经验道具是否足够
exp_goods_is_enough([{GoodsId, Num}|Tail], TypeId, CostsL, OverExp, _IsOver) ->
    #mount_prop_cfg{ exp = OneExp } = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
    NeedNum = util:ceil(OverExp/OneExp),
    case Num >= NeedNum of
        true ->
            %% 道具足够升级
            NeedCostsL = [{?TYPE_GOODS, GoodsId, NeedNum}|CostsL],
            NewOverExp = NeedNum * OneExp - OverExp,
            NewIsOver = true;
        false ->
            %% 道具总经验值不够
            NeedCostsL = [{?TYPE_GOODS, GoodsId, Num}|CostsL],
            %% NewOverExp = OverExp - Num*OneExp,
            NewOverExp = Num * OneExp,
            NewIsOver = false
    end,
    exp_goods_is_enough(Tail, TypeId, NeedCostsL, NewOverExp, NewIsOver).

%% 是否一次消耗而升多级
is_more_level(TypeId, CurLevel, SuperPlusExp) ->
    #base_mount_level_info{ need_exp = LevelMaxExp } = data_mount:get_mount_level_info(TypeId, CurLevel),
    NewSuperPlusExp = SuperPlusExp - LevelMaxExp,
    case NewSuperPlusExp >= 0 of
        true ->
            NewLevel = CurLevel + 1,
            is_more_level(TypeId, NewLevel, NewSuperPlusExp);
        false ->
            {ok, CurLevel, SuperPlusExp}
    end.

calc_this_times_add_exp([], Sum, _) ->
    Sum;
calc_this_times_add_exp([{_, GoodsId, Num}|Tail], Sum, TypeId) ->
    #mount_prop_cfg{ exp = One} = data_mount:get_mount_prop_cfg(TypeId, GoodsId),
    Add = One * Num,
    calc_this_times_add_exp(Tail, Sum+Add, TypeId).

%% 检测技能升级请求的合法性
check_can_upgrade_skill_level(TypeId, UpgradeLevel, SkillId, SkillLevelList) ->
    UnlockSkillList = data_mount:get_skill_by_type(TypeId, ?MOUNT_UPGRADE_SYS_SKILL, 0),
    ?IF(lists:member(SkillId, UnlockSkillList), ok, throw({error, err160_skill_no_exist})),
    CurSkillLevel = proplists:get_value(SkillId, SkillLevelList, 0),
    NewSkillLevel = CurSkillLevel + 1 ,
    %% 解锁条件
    case data_skill:get_lv_data(SkillId, NewSkillLevel) of
        #skill_lv{ condition = ConList, power = Power } ->
            case ConList == [] andalso Power == 0 of
                true ->
                    ConditionLevel = none;
                _ ->
                    %% 健壮性容错
                    case ConList == [] orelse not lists:keymember(mount_upgrade_lv, 1, ConList) of
                        true ->
                            #mount_skill_cfg{ stage = ConditionLevel} = data_mount:get_skill_cfg(TypeId, SkillId);
                        _ ->
                            ConditionLevel = proplists:get_value(mount_upgrade_lv, ConList)
                    end
            end;
        _ ->
            ConditionLevel = none
    end,
    ?IF( ConditionLevel =/= none, ok, throw({error, err423_max_lv})),
    ?IF( UpgradeLevel >= ConditionLevel, ok, throw({error, err160_no_skill_can_upgrade})),
    NewSkillLevelList = lists:keystore(SkillId, 1, SkillLevelList, {SkillId, NewSkillLevel}),
    {ok, NewSkillLevelList, NewSkillLevel}.

%% =============================================
%% base_function
%% =============================================

pack(PlayerId, Cmd, Args) ->
    {ok, Bin} = pt_160:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, Bin).

get_data(Ps, TypeId) ->
    #player_status{ status_mount = SList } = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, SList) of
        #status_mount{ upgrade_sys_skill = SkillL, upgrade_sys_level = Level, upgrade_sys_exp = Exp } ->
            {SkillL, Level, Exp};
        _ -> skip
    end.

%% 获取某个物品的数据
get_goods_num(Ps, GoodsId) when is_integer(GoodsId) ->
    {_PlayerId, Pid} = get_id_pid(Ps),
    case Pid =:= self() of
        true ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            case data_goods_type:get(GoodsId) of
                #ets_goods_type{bag_location = BagLocation} ->
                    GoodsList = lib_goods_util:get_type_goods_list(GoodsStatus#goods_status.player_id, GoodsId, BagLocation, GoodsStatus#goods_status.dict),
                    lib_goods_util:get_goods_totalnum(GoodsList);
                _ ->
                    ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsId]),
                    0
            end;
        false ->
            0
    end.

get_id_pid(PlayerInfo) ->
    PlayerId = case PlayerInfo of
                   Id when is_integer(Id) ->
                       Id;
                   PS when is_record(PS, player_status) ->
                       PS#player_status.id
               end,
    Pid = misc:get_player_process(PlayerId),
    {PlayerId, Pid}.

%% ========================================================
%% gm_function
%% ========================================================
gm_set_mount_level(Ps, TypeId, NewLevel)  ->
    #player_status{id = PlayerId, status_mount = StatusMountL } = Ps,
    case lists:keyfind(TypeId, #status_mount.type_id, StatusMountL) of
        #status_mount{} = Old ->
            New = Old#status_mount{ upgrade_sys_level = NewLevel };
        _ ->
            UnlockSkillList = data_mount:get_skill_by_type(TypeId, ?MOUNT_UPGRADE_SYS_SKILL, 0),
            NotActiveSkill = [{SkillId, 0} || SkillId <- UnlockSkillList],
            New = #status_mount{ upgrade_sys_level = NewLevel, upgrade_sys_skill = NotActiveSkill }
    end,
    #status_mount{ upgrade_sys_exp = OverExp, upgrade_sys_skill = SendSkillList } = New,
    %% 更新数据库内容
    db:execute(io_lib:format(?SQL_UPDATE_MOUNT_UPGRADE_DATA, [PlayerId, TypeId, NewLevel, OverExp, util:term_to_string(SendSkillList)])),
    NewStatusMountList = lists:keystore(TypeId, #status_mount.type_id, StatusMountL, New),
    PlayerAfFigure = lib_mount:count_mount_attr(Ps#player_status{status_mount = NewStatusMountList}),
    NewPlayerS = lib_mount:broadcast_to_scene(TypeId, PlayerAfFigure),
    LastPs = lib_mount_api:power_change_event(NewPlayerS, TypeId),
    Combat = lib_mount:get_status_combat(TypeId, LastPs),
    SendArgs = [?SUCCESS, TypeId, NewLevel, OverExp, 0, Combat, SendSkillList, []],
    pack(PlayerId, 16029, SendArgs),
    LastPs.