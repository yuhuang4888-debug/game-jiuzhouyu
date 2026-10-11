%% ---------------------------------------------------------------------------
%% @doc 任务模块对外接口.

%% @author zzm
%% @since  2016-11-23
%% @deprecated  任务模块对外接口
%% ---------------------------------------------------------------------------
-module(lib_task_api).

-compile(export_all).

-include("common.hrl").
-include("task.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("def_module.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("reincarnation.hrl").
-include("mount.hrl").
-include("medal.hrl").
-include("designation.hrl").
-include("jjc.hrl").
-include("skill.hrl").
-include("activitycalen.hrl").
-include("boss.hrl").
-include("awakening.hrl").
-include("rec_rush_giftbag.hrl").
-include("welfare.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("def_daily.hrl").
-include("predefine.hrl").
-include("seal.hrl").
-include("enchantment_guard.hrl").

%% ps转为任务参数(需在玩家进程调用)
ps2task_args(PS) ->
    #player_status{id=Id, figure=Figure, sid=Sid, scene=Scene, npc_info=NpcInfo,
        medal=#medal{id=MedalId}, status_mount=StatusMount, dsgt_status = DsgtStatus,
        combat_power=CombatPower, skill=Skill, st_liveness = StLiveness, awakening = Awakening,
        rush_giftbag=RushGiftBag, last_task_id=LastTaskId, coin=Coin, seal_status = SealStatus,
        enchantment_guard = #enchantment_guard{soap_status = #enchantment_soap_status{soap_map = SoapMap}}
    } = PS,
    #goods_status{dict=GsDict, stren_award_list=SAL, refine_award_list=RAL, stone_award_list=StoneAL,
        stage_award_list=StageAL, rec_fusion=RC, color_award_list=ColorAL,
        red_equip_award_list = RedEquipAwardList, equip_suit_list=SuitList
    } = lib_goods_do:get_goods_status(),
    % 装备颜色，星数，阶数
    #dsgt_status{dsgt_map = DsgtMap} = DsgtStatus,
    #awakening{active_ids = ActiveIds} = Awakening,
    TrainStarList = [{TypeId, Stage, Star, SysLevel}|| #status_mount{type_id=TypeId, stage = Stage, star = Star, upgrade_sys_level = SysLevel} <- StatusMount],
    MainChapter = lib_enchantment_guard:get_max_chapter(PS),
    DsgNum = maps:size(DsgtMap),
    JjcDailyNum = mod_daily:get_count(Id, ?MOD_JJC, ?JJC_USE_NUM),
    RuneList = lib_goods_util:get_goods_list(Id, ?GOODS_LOC_RUNE, GsDict),
    RuneNum = length(RuneList),
    RuneLvList = [ TmpG#goods.level || TmpG <- RuneList],
    AchvFinIds = lib_achievement:get_fin_ids(Id),
    AchvFinNum = length(AchvFinIds),
    SkillStrenSum = lists:sum([Stren || {_, Stren} <- Skill#status_skill.stren_list]),
    #st_liveness{lv = ActivityLv, liveness=_LiveNess} = StLiveness,
    % LivenessSum = lib_liveness:liveness_sum(ActivityLv-1, LiveNess),
    LivenessDaily = mod_daily:get_count_offline(Id, ?MOD_ACTIVITY, ?ACTIVITY_LIVE_DAILY),
    DunLevelM = lib_dungeon_api:get_dun_level_map(PS),
    RushBagLvL = [BagLv|| {BagLv, RushBagS, _, _} <- RushGiftBag#rush_giftbag.giftbag_state, RushBagS==?GIFTBAG_RECEIVED],
    ReRedEquipAwardList = lib_equip:re_static_red_equip_award(RedEquipAwardList),
    SuitNumList = lib_equip:statistics_suit_num(SuitList),
    LoginDays = lib_player_login_day:get_player_login_days(PS),
    #seal_status{equip_list = SealEquipList} = SealStatus,
    %% 好友数量
    RelaList = lib_relationship:get_rela_list(Id, 1),
    #task_args{id=Id, figure=Figure, sid=Sid, scene=Scene, npc_info=NpcInfo, gs_dict = GsDict,
        train_star_list=TrainStarList, stren_award_list=SAL, refine_award_list=RAL, stage_award_list=StageAL, stone_award_list=StoneAL,
        color_award_list=ColorAL, equip_info=lib_equip_api:get_equip_task_info(Id), medal_lv = MedalId, chapter = MainChapter, fusion_lv = RC#rec_fusion.lv,
        dsg_num = DsgNum, dsg_map=DsgtMap, combat_power = CombatPower, jjc_daily_num = JjcDailyNum, rune_num = RuneNum,
        achv_fin_num = AchvFinNum, achv_ids=AchvFinIds, skill_stren_sum=SkillStrenSum, rune_lv_list = RuneLvList,
        activity_lv=ActivityLv, activity_liveness=LivenessDaily, dun_level_map = DunLevelM, awakening_active_ids = ActiveIds,
        rush_bag_lv_list=RushBagLvL, last_task_id=LastTaskId, re_red_equip_award_list=ReRedEquipAwardList, suit_num_list=SuitNumList,
        coin=Coin, login_days=LoginDays, seal_equip_list = SealEquipList, soap_map = SoapMap, friend_num = erlang:length(RelaList)
    }.

%% 跨服中心击杀怪物，只有小部分怪物触发任务系统
cluster_kill_mon(Klist, SceneId, MonId, MonLv) ->
    [mod_clusters_center:apply_cast(P#mon_atter.node, lib_task_api, kill_mon, [P#mon_atter.id, SceneId, MonId, MonLv]) || P <- Klist].

%% 击杀怪物
kill_mon(#player_status{id = RoleId, tid = Tid}, SceneId, MonId, MonLv) ->
    event(Tid, ?TASK_CONTENT_KILL, {num, MonId, 1}, RoleId),
    event(Tid, ?TASK_CONTENT_KILL_BOSS_ID, {num, MonId, 1}, RoleId), %% 用于客户端做区份
    event(Tid, ?TASK_CONTENT_KILL_LV, {id_num_more, MonLv, 1}, RoleId),
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_OUTSIDE} -> event(Tid, ?TASK_CONTENT_OUTSIDE_KILL_V, {id_num_more, MonLv, 1}, RoleId);
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} -> event(Tid, ?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} -> event(Tid, ?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        _ -> skip
    end;
kill_mon(RoleId, SceneId, MonId, MonLv) ->
    event(?TASK_CONTENT_KILL, {num, MonId, 1}, RoleId),
    event(?TASK_CONTENT_KILL_BOSS_ID, {num, MonId, 1}, RoleId), %% 用于客户端做区份
    event(?TASK_CONTENT_KILL_LV, {id_num_more, MonLv, 1}, RoleId),
    case data_scene:get(SceneId) of
        #ets_scene{type = ?SCENE_TYPE_OUTSIDE} -> event(?TASK_CONTENT_OUTSIDE_KILL_V, {id_num_more, MonLv, 1}, RoleId);
        #ets_scene{type = ?SCENE_TYPE_KF_SANCTUARY} -> event(?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        #ets_scene{type = ?SCENE_TYPE_SANCTUARY} -> event(?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        _ -> skip
    end.

%% 击杀BOSS(BOSS类型)
kill_boss(#player_status{id = RoleId, tid = Tid}, OBossType, BossLv) ->
    %% 无限层世界boss当成世界boss|策划说只处理神殿觉醒和任务（lib_task_api）相关的，锤倒过来再改
    BossType = case OBossType == ?BOSS_TYPE_WORLD_PER of true -> ?BOSS_TYPE_NEW_OUTSIDE; _ -> OBossType end,
    event(Tid, ?TASK_CONTENT_KILL_BOSS, {num, BossType, 1}, RoleId),
    event(Tid, ?TASK_CONTENT_KILL_BOSS_LV, {id_num_more, BossLv, 1}, RoleId),
    case BossType of
        ?BOSS_TYPE_VIP_PERSONAL -> event(Tid, ?TASK_CONTENT_KILL_VIP_BOSS, {num, 1}, RoleId);
        ?BOSS_TYPE_KF_SANCTUARY -> event(Tid, ?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        ?BOSS_TYPE_SANCTUARY -> event(Tid, ?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        _ -> skip
    end;
kill_boss(Klist, BossType, BossLv) when is_list(Klist) ->
    [lib_task_api:kill_boss(P#mon_atter.id, BossType, BossLv) || P <- Klist];
kill_boss(RoleId, OBossType, BossLv) ->
    % BossType = case OBossType of
    %     ?BOSS_TYPE_SPECIAL -> ?BOSS_TYPE_NEW_OUTSIDE;
    %     _ -> OBossType
    % end,
    BossType = OBossType,
    event(?TASK_CONTENT_KILL_BOSS, {num, BossType, 1}, RoleId),
    event(?TASK_CONTENT_KILL_BOSS_LV, {id_num_more, BossLv, 1}, RoleId),
    case BossType of
        ?BOSS_TYPE_VIP_PERSONAL -> event(?TASK_CONTENT_KILL_VIP_BOSS, {num, 1}, RoleId);
        ?BOSS_TYPE_KF_SANCTUARY -> event(?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        ?BOSS_TYPE_SANCTUARY -> event(?TASK_CONTENT_KILL_SANCTUARY_BOSS, {num, 1}, RoleId);
        _ -> skip
    end.

%% 收集物品(通过杀怪收集)
collect_goods(#player_status{id = RoleId, tid = Tid}, GoodsNumList) ->
    event(Tid, ?TASK_CONTENT_ITEM, {id_num_list, GoodsNumList}, RoleId),
    event(Tid, ?TASK_CONTENT_ITEM2, {id_num_list, GoodsNumList}, RoleId);
collect_goods(RoleId, GoodsNumList) ->
    event(?TASK_CONTENT_ITEM, {id_num_list, GoodsNumList}, RoleId),
    event(?TASK_CONTENT_ITEM2, {id_num_list, GoodsNumList}, RoleId).

%% 收集物品减少(通过触发任务来更新任务的完成状态)
collect_goods_reduce(#player_status{id = RoleId, tid = Tid}, GoodsNumList)->
    event(Tid, ?TASK_CONTENT_ITEM, {reduce_id_num_list, GoodsNumList}, RoleId);
collect_goods_reduce(RoleId, GoodsNumList) ->
    event(?TASK_CONTENT_ITEM, {reduce_id_num_list, GoodsNumList}, RoleId).

%% 采集物品(采集怪物)
collect_mon(#player_status{id = RoleId, tid = Tid}, MonId) ->
    event(Tid, ?TASK_CONTENT_COLLECT, {num, MonId, 1}, RoleId);
collect_mon(RoleId, MonId) ->
    event(?TASK_CONTENT_COLLECT, {num, MonId, 1}, RoleId).

%% 穿戴N件装备
equip(#player_status{id = RoleId, tid = Tid}, EquipTaskInfo) ->
    event(Tid, ?TASK_CONTENT_EQUIP, {more, length(EquipTaskInfo)}, RoleId),
    OrangeEquipList = [{EquipColor, _EquipStage, _EquipStar}||{EquipColor, _EquipStage, _EquipStar}<-EquipTaskInfo, EquipColor >= ?ORANGE],
    event(Tid, ?TASK_CONTENT_EQUIP_ORANGE, {equip_stage, OrangeEquipList}, RoleId).

%% 点亮天命觉醒星格
awakening(RoleId, PlayerLv) ->
    event(?TASK_CONTENT_AWAKENING, {awakening, PlayerLv, 1}, RoleId).

%% 强化装备(去到任务进程统计EqStrenList=[{StrenLv, Num}])
stren_equip(#player_status{id = RoleId, tid = Tid}, EqStrenList) ->
    event(Tid, ?TASK_CONTENT_STREN, {equip_pre_check, EqStrenList}, RoleId),
    event(Tid, ?TASK_CONTENT_STREN_SUM, {equip_sum, EqStrenList}, RoleId).

%% 精炼装备
refine_equip(#player_status{id = RoleId, tid = Tid}, EqRefineList) ->
    event(Tid, ?TASK_CONTENT_REFINE_EQUIP, {equip_pre_check, EqRefineList}, RoleId),
    event(Tid, ?TASK_CONTENT_REFINE_SUM, {equip_sum, EqRefineList}, RoleId).

%% 装备阶数
equip_stage(#player_status{id = RoleId, tid = Tid}, EqStageList) ->
    event(Tid, ?TASK_CONTENT_EQUIP_STAGE, {equip_pre_check, EqStageList}, RoleId).

%% 装备品质（颜色）
equip_color(#player_status{id = RoleId, tid = Tid}, ColorList) ->
    event(Tid, ?TASK_CONTENT_EQUIP_COLOR, {equip_pre_check, ColorList}, RoleId).

%% 宝石等级数
equip_stone_lv(#player_status{id = RoleId, tid = Tid}, StoneAwardList) ->
    event(Tid, ?TASK_CONTENT_EQUIP_STONE_SUM, {equip_sum, StoneAwardList}, RoleId).

%% 红装合成
red_equip_combine(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_RAD_EQUIP_COMBINE, {num, Num}, RoleId).

%% 激活N件红装加成
active_red_suit(#player_status{id = RoleId, tid = Tid}, ReRedEquipAwardList) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_RAD_SUIT, {equip_num, ReRedEquipAwardList}, RoleId).

%% 激活N件套装加成
active_suit(#player_status{id = RoleId, tid = Tid}, SuitNumList) ->
    case lists:reverse(lists:keysort(2, SuitNumList)) of
        [{_, Num}|_] -> event(Tid, ?TASK_CONTENT_ACTIVE_SUIT, {more, Num}, RoleId);
        _ -> skip
    end.

%% 完成特定类型副本事件
fin_dun_type(RoleId, DunType) ->
    event(?TASK_CONTENT_DUNGEON_TYPE, {num, DunType, 1}, RoleId).

%% 完成副本事件
fin_dun(RoleId, DunId) ->
    event(?TASK_CONTENT_DUNGEON, {id, DunId}, RoleId).

%% 完成关卡副本事件
fin_dun_level(RoleId, DunType, Level) ->
    event(?TASK_CONTENT_DUNGEON_LEVEL, {id_more, DunType, Level}, RoleId).

%% 完成主线副本
fin_main_dun(#player_status{id = RoleId, tid = Tid}, Chapter) ->
    event(Tid, ?TASK_CONTENT_MAIN_DUNGEON, {more, Chapter}, RoleId).

%% 添加好友
add_friend(#player_status{id = RoleId, tid = Tid}) ->
    event(Tid, ?TASK_CONTENT_ADD_FRIEND, {num, 1}, RoleId);
add_friend(RoleId) ->
    event(?TASK_CONTENT_ADD_FRIEND, {num, 1}, RoleId).

%% 加入公会（包括创建公会）
join_guild(#player_status{id = RoleId, tid = Tid}) ->
    event(Tid, ?TASK_CONTENT_JOIN_GUILD, {num, 1}, RoleId);
join_guild(RoleId) ->
    event(?TASK_CONTENT_JOIN_GUILD, {num, 1}, RoleId).

%% 完成公会活动任务
guild_activity(RoleId, SubModId)->
    event(?TASK_CONTENT_GUILD_ACTIVITY, {id, SubModId}, RoleId).

%% 公会装备捐献
guild_donate(#player_status{id = RoleId, tid = Tid})->
    event(Tid, ?TASK_CONTENT_GUILD_EQ_DONATE, {num, 1}, RoleId);
guild_donate(RoleId) ->
    event(?TASK_CONTENT_GUILD_EQ_DONATE, {num, 1}, RoleId).

guild_donate(#player_status{id = RoleId, tid = Tid}, Num)->
    event(Tid, ?TASK_CONTENT_GUILD_EQ_DONATE, {num, Num}, RoleId);
guild_donate(RoleId, Num) ->
    event(?TASK_CONTENT_GUILD_EQ_DONATE, {num, Num}, RoleId).

%% 公会装备兑换
guild_exchange(RoleId, Num) ->
    event(?TASK_CONTENT_EXCG_GUILD_DEPOT, {num, Num}, RoleId).

%% 从市场购买
buy_from_trading(RoleId) ->
    event(?TASK_CONTENT_BUY_FROM_TRADING, {num, 1}, RoleId).

%% 市场上架
trading_putaway(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_TRADING_PUTAWAY, {num, Num}, RoleId);
trading_putaway(RoleId, Num) ->
    event(?TASK_CONTENT_TRADING_PUTAWAY, {num, Num}, RoleId).

%% 物品合成任务
finish_goods_compose(#player_status{id = RoleId, tid = Tid}, GId, Num)->
    event(Tid, ?TASK_CONTENT_GOODS_COMPOSE, {num, GId, Num}, RoleId).

%% 完成任务
fin_task(#player_status{id = RoleId, tid = Tid}, TaskId) ->
    event(Tid, ?TASK_CONTENT_FIN_TASK, {id, TaskId}, RoleId),
    event(Tid, ?TASK_CONTENT_FIN_MAIN_TASK, {id, TaskId}, RoleId).

%% 完成赏金任务
fin_task_daily(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FIN_TASK_DAILY, {num, Num}, RoleId).

%% 完成帮派任务
fin_task_guild(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FIN_TASK_GUILD, {num, Num}, RoleId).

%% 完成护送
fin_husong(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FIN_HUSONG, {num, Num}, RoleId).

%% 熔炼装备
fusion_equip(#player_status{id = RoleId, tid = Tid}, FusionLv) ->
    event(Tid, ?TASK_CONTENT_FUSION_EQUIP, {more, FusionLv}, RoleId).

%% 激活、培养 幻化系统
train_something(#player_status{id = RoleId, tid = Tid}, TypeId, Stage, Star) ->
    case TypeId of
        ?MOUNT_ID ->
            event(Tid, ?TASK_CONTENT_TRAIN_MOUNT, {train_something, Stage, Star}, RoleId),
            event(Tid, ?TASK_CONTENT_ACTIVE_MOUNT, {num, 1}, RoleId);
        ?FLY_ID ->
            event(Tid, ?TASK_CONTENT_TRAIN_WING, {train_something, Stage, Star}, RoleId),
            event(Tid, ?TASK_CONTENT_ACTIVE_WING, {num, 1}, RoleId);
        ?MATE_ID ->
            event(Tid, ?TASK_CONTENT_TRAIN_PARTNER, {train_something, Stage, Star}, RoleId),
            event(Tid, ?TASK_CONTENT_ACTIVE_PARTNER, {num, 1}, RoleId);
        ?HOLYORGAN_ID ->
            event(Tid, ?TASK_CONTENT_TRAIN_HOLYORGAN, {train_something, Stage, Star}, RoleId),
            event(Tid, ?TASK_CONTENT_ACTIVE_HOLYORGAN, {num, 1}, RoleId);
        ?ARTIFACT_ID ->
            event(Tid, ?TASK_CONTENT_TRAIN_ARTIFACT, {train_something, Stage, Star}, RoleId);
        _ -> skip
    end.

%% 升级勋章
upgrade_medal(#player_status{id = RoleId, tid = Tid}, MedelId) ->
    event(Tid, ?TASK_CONTENT_UPGRADE_MEDAL, {more, MedelId}, RoleId).

%% 领取成就奖励
achv_award(#player_status{id = RoleId, tid = Tid}, _Id) ->
    event(Tid, ?TASK_CONTENT_ACHV_AWARD, {num, 1}, RoleId).

%% 成就等级
achv_lv(#player_status{id = RoleId, tid = Tid}, Lv) ->
    event(Tid, ?TASK_CONTENT_ACHV_LV, {more, Lv}, RoleId).

%% 激活称号
active_dsg(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_DSG, {more, Num}, RoleId).

%% 激活某个称号
active_dsg_id(#player_status{id = RoleId, tid = Tid}, DsgId) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_DSG_ID, {id, DsgId}, RoleId).

%% 战力
combat_power(#player_status{id = RoleId, tid = Tid}, CombatPower) ->
    event(Tid, ?TASK_CONTENT_COMBATPOWER, {more, CombatPower}, RoleId).

%% 镶嵌符文数量
rune_num(#player_status{id = RoleId, tid = Tid}, RuneNum) ->
    event(Tid, ?TASK_CONTENT_RUNE_NUM, {more, RuneNum}, RoleId).

%% 符文强化等级
rune_lv(#player_status{id = RoleId, tid = Tid}, RuneLvList) ->
    event(Tid, ?TASK_CONTENT_RUNE_LV, {num_more_list, RuneLvList}, RoleId),
    event(Tid, ?TASK_CONTENT_RUNE_LV_SUM, {more, lists:sum(RuneLvList)}, RoleId).

%% 参加排位赛
join_jjc(RoleId, Num) ->
    event(?TASK_CONTENT_JOIN_JJC, {num, Num}, RoleId).

%% 野外挂机波数
onhook_wave(#player_status{id = RoleId, tid = Tid}, WaveNum) ->
    event(Tid, ?TASK_CONTENT_ONHOOK_WAVE, {num, WaveNum}, RoleId).

%% 技能强化
skill_stren(#player_status{id = RoleId, tid = Tid}, StrenNum) ->
    event(Tid, ?TASK_CONTENT_UPGRADE_SKILL_STREN, {num, 1}, RoleId),
    event(Tid, ?TASK_CONTENT_SKILL_STREN_SUM, {more, StrenNum}, RoleId).

%% 活跃度
activity_lv(#player_status{id = RoleId, tid = Tid}, ActivityLv) ->
    event(Tid, ?TASK_CONTENT_ACTIVITY_LV, {more, ActivityLv}, RoleId).

%% 当日活跃度累计
activity_acc(#player_status{id = RoleId, tid = Tid}, ActivityDaily) ->
    event(Tid, ?TASK_CONTENT_ACTIVITY_ACC, {more, ActivityDaily}, RoleId);
activity_acc(RoleId, ActivityDaily) ->
    event(?TASK_CONTENT_ACTIVITY_ACC, {more, ActivityDaily}, RoleId).

%% 领取等级礼包
award_lv_gift(#player_status{id = RoleId, tid = Tid}, BagLv) ->
     event(Tid, ?TASK_CONTENT_AWARD_LV_GIFT, {id, BagLv}, RoleId).

%% 领取契约之书奖励
award_eternal_valley(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_AWARD_ETERNAL_VALLEY, {num, Num}, RoleId).

%% 完成符文夺宝
fin_rune_hurt(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FIN_RUNE_HURT, {num, Num}, RoleId).

%% 完成一次决斗场
fin_glad(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FIN_GLAD, {num, Num}, RoleId).

%% 增加材料
%% @param GoodsNumList [{GoodsTypeId, GetNum}]
add_stuff(#player_status{id = RoleId, tid = Tid}, GoodsNumList) ->
    event(Tid, ?TASK_CONTENT_COST_STUFF, {add_stuff, GoodsNumList}, RoleId),
    event(Tid, ?TASK_CONTENT_COST_GOODS, {id_num_list, GoodsNumList}, RoleId).

%% 设置材料数量
%% @param GoodsNumList [{GoodsTypeId, DelNum, AllNum}]
set_stuff(#player_status{id = RoleId, tid = Tid}, GoodsNumList) ->
    event(Tid, ?TASK_CONTENT_COST_STUFF, {set_stuff, GoodsNumList}, RoleId),
    event(Tid, ?TASK_CONTENT_COST_GOODS, {id_more_list, GoodsNumList}, RoleId).

%% 消耗材料
cost_stuff(#player_status{id = RoleId, tid = Tid}, TaskId, GoodsTypeId, Num) ->
    event(Tid, TaskId, ?TASK_CONTENT_COST_STUFF, {cost_stuff, GoodsTypeId, Num}, RoleId).

%% 领取7日奖励
award_7day(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_AWARD_7DAY, {num, Num}, RoleId).

%% 领取每日奖励
award_daily(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_AWARD_DAILY, {num, Num}, RoleId).

%% 镶嵌N个圣印
seal_set_num(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_SEAL_SET_NUM, {more, Num}, RoleId).

%% 等级提升
lv_up(#player_status{id = RoleId, tid = Tid, figure=#figure{lv=Lv}}) ->
    event(Tid, ?TASK_CONTENT_LV, {more, Lv}, RoleId).

%% 激活降神
active_god(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_GOD, {num, Num}, RoleId).

%% 经验副本
dun_exp_finish(#player_status{id = RoleId, tid = Tid}, AddExp) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_DUN_EXP, {more, AddExp}, RoleId).

%% 竞技场排名
jjc_rank(#player_status{id = RoleId, tid = Tid}, Rank) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_JJC_RANK, {less, Rank}, RoleId).

%% 累计登录时间更新
update_login_days(#player_status{id = RoleId, tid = Tid}, LoginDays) ->
    event(Tid, ?TASK_CONTENT_LOGIN_DAY, {more, LoginDays}, RoleId).

%% 开启觉醒之路
open_temple_awaken(#player_status{id = RoleId, tid = Tid}) ->
    event(Tid, ?TASK_CONTENT_OPEN_FUNCTION, {num, 1}, RoleId).

%% 完成托管活动
finish_fake_client(#player_status{id = RoleId, tid = Tid}, Num) ->
    event(Tid, ?TASK_CONTENT_FAKE_CLIENT, {num, Num}, RoleId).

%% 套装收集
suit_ctl(#player_status{id = RoleId, tid = Tid}, SuitStatus) ->
    event(Tid, ?TASK_CONTENT_SUIT_CLT, {suit_clt, SuitStatus}, RoleId).

%% 进入永恒圣殿
enter_sanctum(RoleId) ->
    event(?TASK_CONTENT_ENTER_SANCTUM, {num, 1}, RoleId).

%% 进入龙语Boss
enter_dragon_lan(RoleId) ->
    event(?TASK_CONTENT_ENTER_DRANLAN, {num, 1}, RoleId).

%% 时空圣痕争夺值
chrono_value(#player_status{tid = Tid, id = RoleId}, Value) ->
    event(Tid, ?TASK_CONTENT_CHRONO_VALUE, {more, Value}, RoleId).

%% 完成Boss协助
boss_assist(#player_status{tid = Tid, id = RoleId}) ->
    event(Tid, ?TASK_CONTENT_BOSS_ASSIST, {num, 1}, RoleId).

%% 激活古宝
active_soap(#player_status{tid = Tid, id = RoleId}, SoapId) ->
    event(Tid, ?TASK_CONTENT_ACTIVE_SOAP, {id, SoapId}, RoleId).

%% 坐骑类型升级
upgrade_mount_level(#player_status{tid = Tid, id = RoleId}, TypeId, Level) ->
    event(Tid, ?TASK_CONTENT_MOUNT_LEVEL, {train_something, TypeId, Level}, RoleId).

%% 领取挂机收益次数
receive_afk_times(#player_status{tid = Tid, id = RoleId}) ->
    event(Tid, ?TASK_CONTENT_AFK_RECEIVE_TIMES, {num, 1}, RoleId).

%% 跨服异域个人积分增加
kf_sanctuary_add_score(#player_status{tid = Tid, id = RoleId}, Value) ->
    event(Tid, ?TASK_CONTENT_KF_SANCTUARY_PERSON_SCORE, {more, Value}, RoleId).

%% 跨服异域个人积分增加
kf_sanctuary_kill_player(#player_status{tid = Tid, id = RoleId}) ->
    event(Tid, ?TASK_CONTENT_KILL_KF_SANCTUARY_PLAYER, {num,1}, RoleId).

%% 事件触发
event(Event, Params, RoleId) ->
    mod_task:event(Event, Params, RoleId).
event(Tid, Event, Params, RoleId) ->
    mod_task:event(Tid, Event, Params, RoleId).
event(Tid, TaskId, Event, Params, RoleId) ->
    mod_task:event(Tid, TaskId, Event, Params, RoleId).

%% 直接提交一个任务(玩家进程)
finish(Status, TaskId) ->
    CellNum = lib_goods_api:get_cell_num(Status),
    mod_task:finish(Status#player_status.tid, TaskId, [[], CellNum], ps2task_args(Status)).

%% 直接提交一个任务(玩家进程)
gm_finish(Status, TaskId) ->
    CellNum = lib_goods_api:get_cell_num(Status),
    mod_task:gm_finish(Status#player_status.tid, TaskId, [[], CellNum], ps2task_args(Status)).

%% 玩家转生成功要刷新任务列表
turn_up(PS) ->
    #player_status{tid = Tid} = PS,
    TaskArgs = ps2task_args(PS),
    mod_task:lv_up(Tid, TaskArgs).

%% 处理玩家事件
handle_event(#player_status{id = RoleId, tid = Tid, figure = #figure{lv = Lv}}=PS, #event_callback{type_id=?EVENT_LV_UP}) ->
    TaskArgs = ps2task_args(PS),
    mod_task:lv_up(Tid, TaskArgs),
    event(Tid, ?TASK_CONTENT_LV, {more, Lv}, RoleId),
    {ok, PS};
handle_event(PS, #event_callback{type_id=?EVENT_GUILD_DONATE}) ->
    guild_donate(PS),
    {ok, PS};
handle_event(PS, #event_callback{type_id=?EVENT_LOGIN_CAST}) ->
    update_login_days(PS, lib_player_login_day:get_player_login_days(PS)),
    fix_20220727_task(PS),
    {ok, PS};
handle_event(PS, #event_callback{type_id = ?EVENT_FAKE_CLIENT}) ->
%%    finish_fake_client(PS),
    {ok, PS};
handle_event(PS, _) ->
    {ok, PS}.

%% 修复20220524新增的主线任务，当前主线大于指定值直接完成，策划需求（不想让老号有指引）
%% 果断时间记得去除
fix_20220524_task(PS) ->
    #player_status{tid = Tid, last_task_id = LastTaskId} = PS,
    TaskIdL = [100521, 100901, 101211],
    NeedFinishL = lists:foldl(
        fun(TaskId, AccL) ->
            case LastTaskId > TaskId andalso not mod_task:is_finish_task_id(Tid, TaskId) of
                true -> [TaskId|AccL];
                _ -> AccL
            end
        end, [], TaskIdL),
    lists:foreach(fun(TaskId) -> lib_task_api:gm_finish(PS, TaskId) end, NeedFinishL).

%% 修复20220727新增的主线任务，当前主线大于指定值直接完成
%% 过段时间记得去除
fix_20220727_task(PS) ->
    #player_status{id = RoleId, figure = #figure{lv = Lv}, last_task_id = LastTaskId, tid = Tid} = PS,
    F = fun(TaskId) ->
        LastTaskId > TaskId andalso
        case data_task:get(TaskId) of
            #task{type = ?TASK_TYPE_MAIN} -> true;
            _ -> false
        end
    end,
    TaskList = lists:filter(F, data_task_lv:get_ids(Lv)),
    %?INFO("TaskList ~p ~n", [TaskList]),
    NeedFinishTaskL = TaskList -- mod_task:get_finish_task_id_list(Tid, TaskList),
    %?INFO("NeedFinishTaskL ~p ~n", [NeedFinishTaskL]),
    lists:foreach(fun(TaskId) -> lib_task_api:gm_finish(PS, TaskId) end, mod_task:get_trigger_task_id_list(Tid, NeedFinishTaskL)),
    % 符文本，防止老号打完了符文本无法触发
    Level = lib_dungeon_api:get_dungeon_level(PS, 12),
    lib_task_api:fin_dun_level(RoleId, 12, Level),
    ok.

%% 出售，交易物品减少，任务状态修改
handle_task_goods_reduce(Ps, ReduceGoodsList) ->
    TaskGoodsIdList = mod_task:can_gain_item(Ps#player_status.tid),
    case TaskGoodsIdList of
        [] -> skip;
        _  ->
            %% 找到需要处理的物品
            Fun = fun({GoodTypeId, Num}, [TL, GNL]) ->
                          case lists:member(GoodTypeId, TaskGoodsIdList) of
                              false -> [TL, GNL];
                              true ->  [[{GoodTypeId, Num}|TL], [GoodTypeId|GNL]]
                          end
                  end,
            case lists:foldl(Fun, [[], []], ReduceGoodsList) of
                [[], _] -> skip;
                [ReduceTaskList, L] ->
                    GNumL = lib_goods_do:goods_num(L),
                    Fun1 = fun({GID, GNUM}, GAL) ->
                        case lists:keyfind(GID, 1, GNumL) of
                            false -> [{GID, GNUM, 0}|GAL];
                            {_, AllNum} -> [{GID, GNUM, AllNum}|GAL]
                        end
                    end,
                    Reduces = lists:foldl(Fun1, [], ReduceTaskList),
                    lib_task_api:collect_goods_reduce(Ps, Reduces),
                    lib_task_api:set_stuff(Ps, Reduces)
            end
    end.

gm_reload_goods(RoleId, GoodsId) when is_integer(RoleId) ->
    lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_reload_goods, [GoodsId]);
gm_reload_goods(Player, GoodsId) ->
    [{GoodsId, GoodsNum}] = lib_goods_api:get_goods_num(Player, [GoodsId]),
    lib_task_api:set_stuff(Player, [{GoodsId, 0,GoodsNum}]),
    {ok, Player}.

gm_finish_current_task(Type, RoleId) ->
    if
        Type == ?TASK_TYPE_DAILY; Type == ?TASK_TYPE_GUILD; Type == ?TASK_TYPE_DAY; Type == ?TASK_TYPE_DAILY_EUDEMONS ->
            Sql = io_lib:format("select task_id from task_bag_clear where role_id = ~p and type = ~p ", [RoleId, Type]);
        true ->
            Sql = io_lib:format("select task_id from task_bag where role_id = ~p and type = ~p ", [RoleId, Type])
    end,
    case db:get_row(Sql) of
        [TaskId] ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, gm_finish_current_task2, [TaskId]);
        _E ->
            ?PRINT("Sql ~s ~n", [Sql]),
            no_task
    end.

gm_finish_current_task2(PS, TaskId) ->
    CellNum = lib_goods_api:get_cell_num(PS),
    mod_task:gm_finish_current_task(PS#player_status.tid, TaskId, CellNum, lib_task_api:ps2task_args(PS)).
