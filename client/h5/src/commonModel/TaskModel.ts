import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { OpenFun } from "../common/OpenFun"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DailyEvent } from "../daily/DailyEvent"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { OperateManager } from "../operation/OperateManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { TaskVo } from "../sharedata/TaskVo"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { ClientConfig, GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BagModel } from "./BagModel"
import { BaseDungeonModel, DungeonEnterViewIndex, DUN_TYPE } from "./BaseDungeonModel"
import { BossModel } from "./BossModel"
import { DailyModel } from "./DailyModel"
import { GuardModel } from "./GuardModel"
import { GuildModel, GuildEvent } from "./GuildModel"
import { MainFunc, MainUIModel } from "./MainUIModel"
import { PartnerModel } from "./PartnerModel"
import { RuneTreasureEvent, RuneTreasureModel } from "./RuneTreasureModel"
import { StoryModel } from "./StoryModel"
import { Role } from "../scene/sceneobj/Role"
import { PoseState } from "../util/StateMachineManager"
import { AutoBrushModel } from "./AutoBrushModel"
import { EnumAutoBrushTabType } from "../autoBrush/AutoBrushBaseView"
import { OnHookModel } from "./OnHookModel"
import { enum_OutWardType, OutWardBaseModel } from "./OutWardBaseModel"
import { MainStrongerEvent, MainStrongerModel } from "./MainStrongerModel"
import { TempleAwakenModel } from "./TempleAwakenModel"
import { FriendEvent, FriendModel } from "./FriendModel"
import { HashObject } from "../common/BaseClass"
import { SettingModel } from "./SettingModel"


let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
/** 任务类型,和后台配置的任务内容类型保持一致 */
export enum TaskTipType {
	/**击败怪物 */
	Kill = 1,
	/**击杀BOSS（可配置类型，击杀数量） */
	KillBoss = 2,
	/**收集物品(打怪) */
	Item = 3,
	/**采集 */
	Collect = 4,
	/**与npc对话 */
	Talk = 5,
	/**开始对话（不可选） */
	StartTalk = 6,
	/**结束对话（不可选） */
	EndTalk = 7,
	/**强化装备（id填+N,数量填件数） */
	StrenEquip = 8,
	/**完成某类型副本（id填写副本类型） */
	FinDunType = 9,
	/**通过主线副本（数量填关卡数，结界守护） */
	PassMainDungeon = 10,
	/**完成副本（具体的副本ID） */
	FinDungeon = 11,
	/**穿戴N件装备（数量填件数） */
	DressEquip = 12,
	/**添加好友 */
	AddFriend = 13,
	/**加入结社 */
	JoinGuild = 14,
	/**精炼装备（id填+N,数量填件数） */
	RefineEquip = 15,
	/**完成结社活动（id请填写公会活动的功能子类） */
	GuildActivity = 16,
	/**捐献一件装备到结社仓库 */
	GuildDonate = 17,
	/**熔炼装备（数量填熔炼等级） */
	FusionEquip = 18,
	/**从市场购买1件装备 */
	BuyFromTrading = 19,
	/**在市场上架1件装备 */
	TradingPutaway = 20,
	/**物品合成 */
	GoodsCompose = 21,
	/**完成任务(id填任务id) */
	FinTask = 22,
	/**培养坐骑（id填阶数，数量填星数） */
	TrainMount = 23,
	/**培养羽翼（id填阶数，数量填星数） */
	TrainWing = 24,
	/**培养侍魂（id填阶数，数量填星数） */
	TrainPartner = 25,
	/**升级勋章（数量填阶数） */
	UpgradeMedal = 26,
	/**到达等级 */
	LV = 27,
	/**天命觉醒N次 */
	Awakening = 28,
	/**领取成就奖励 */
	AchvAward = 29,
	/**激活称号数量 */
	ActiveDsg = 30,
	/**全身强化数 */
	StrenSum = 31,
	/**全身精炼数 */
	RefineSum = 32,
	/**镶嵌御魂数量 */
	RuneNum = 33,
	/**装备阶数(id填阶数，数量填装备数量) */
	EquipPre = 34,
	/**参加排位赛次数 */
	JoinJcc = 35,
	/**到达战斗力 */
	CombatPower = 36,
	/**进入游戏欢迎界面 */
	Welcome = 37,
	/**激活坐骑(数量填1) */
	ActiveMount = 38,
	/**激活羽翼(数量填1) */
	ActiveWing = 39,
	/**激活神巫(数量填1) */
	ActivePartner = 40,
	/**培养神兵（id填阶数，数量填星数） */
	TrainArtifact = 41,
	/**激活神兵(数量填1) */
	ActiveArtifact = 42,
	/**完成主线任务(id填任务id) */
	FinMainTask = 43,
	/**激活某个称号(id填称号id) */
	ActiveDesignation = 44,
	/**野外挂机波数(数量填波数) */
	KillMonWaveNum = 45,
	/**升级技能强度 */
	UpgradeSkillStren = 46,
	/**技能强化总等级 */
	SkillStrenNum = 47,
	/**宝石强化总等级(数量填总等级) */
	EquipStoneNum = 48,
	/**御魂强化达到X级N个（id填X,数量填N） */
	RuneLv = 49,
	/**御魂强化总等级（数量填总等级） */
	RuneLvSum = 50,
	/**职称等级达到N级（数量填N） */
	AchvLv = 51,
	/**击杀X等级大妖N只（id填x，数量填N） */
	KillBossLv = 52,
	/**活跃等级到达N（数量填N） */
	Activity_lv = 53,
	/**领取等级礼包 */
	Award_lv_gift = 54,
	/**领取契约之书奖励 */
	Award_eternal_valley = 55,
	/**完成御魂夺宝 */
	Rune_treasure = 56,
	/**副本关卡 */
	Dungeon_level = 57,
	/**获得N点活跃度 */
	Activity_acc = 58,
	/**完成N次决斗场 */
	Fin_glad = 59,
	/**穿戴N件*色以上装备（id填颜色类型） */
	Equip_color = 60,
	/**消耗资源 */
	CollectMaterial = 61,
	/**击杀某个等级（包含）以上的怪物（id填等级） */
	Kill_lv = 62,
	/**击败大妖N次(id填怪物id) */
	Kill_boss_id = 63,
	/**领取七日奖励 */
	Award_7day = 64,
	/**领取每日签到奖励 */
	Award_daily = 65,
	/**完成赏金任务N次 */
	Fin_task_daily = 66,
	/**击杀野外场景某个等级（包含）及以上的普通怪物（id填等级） */
	Outside_kill_lv = 67,
	/**完成结社周任务 */
	Fin_task_guild = 68,
	/**完成护送N次 */
	Fin_husong = 69,
	/**击杀专属大妖N次 */
	Kill_vip_boss = 70,
	/**参与击杀异域大妖 */
	Kill_shengyu_boss = 71,
	/**镶嵌N个影装 */
	Seal_set_num = 72,
	/**神装合成N次 */
	Red_equip_combine = 73,
	/**激活N件神装加成 */
	Active_red_suit = 74,
	/**激活N件套装加成 */
	Active_suit = 75,
	/**激活式神N次 */
	Active_god = 76,
	/**单次恶灵退治达到XX经验 */
	Single_dun_exp = 77,
	/**竞技场挑战达到前XXX名 */
	Jjc_rank = 78,
	/**累计登录天数 */
	Login_day = 79,		
	/**金币 */
	Coin = 80,
	/**开启某些功能模块 */
	Open_function = 81,
	/**扣除物品 */
	Cost_goods = 82,
	/**进行托管行为 */
	Deposit = 83,
	/**套装收集 */
	Suit_clt = 84,
	/**进入永恒圣殿N次 */	
	Enter_Sanctum = 85,
	/**进入龙语BOssN次 */
	Enter_dranlan = 86,
	/**时空圣痕争夺值达到xx */
	Chrono_value = 87,
	/**完成N次Boss协助 */
	Boss_assist = 88,
	/**激活指定妖物 */
	ActiveSoap = 89, 
	/**坐骑系统培养等级#Id填类型， need_num填所需等级 */
	MountLevel = 90,
	/**领取挂机奖励次数#need_num填次数 */
	AfkReceiveTimes = 91, 
	/**培养圣器/御守（id填阶数，数量填星数） */
	ArtifactLevel = 92, 
	/**穿戴N件M阶橙色以上装备（id填阶数， 数量填件数） */
	DressOrangeEquip = 93,
	/**公会仓库兑换 */
	GuildExchange = 94,
	/**收集物品,物品减少不影响进度 */
	Item2 = 95
}

window["TaskTipType"] = TaskTipType

export enum TaskType {
	/**主线任务 */
	MAIN_LINE = 1,
	/**唤醒任务(神殿觉醒) */
	AWAKE_LINE = 2,
	/**转生任务 */
	REINCARNATION = 3,
	/**支线任务 */
	EXTENSION_LINE = 5,
	/**公会任务（结社任务） */
	GUILD = 6,
	/**日常任务 */
	DAILY = 7,
	/** */
	NORMAL_DAILY = 8,
	/**帝国悬赏(圣兽领/蜃气楼) */
	EUDAEMON_TASK = 9,
	/**跨服异域 */
	KFHOLYAREA_TASK =10
}
window["TaskType"] = TaskType

export const TaskTypeStr = {
	"1": "主线任务",
	"2": "唤醒任务",
	"3": "转生任务",
	"5": "支线任务",
	"6": "结社任务",
	"7": "日常任务",
	"8": "日常任务",
	"9": "帝国悬赏"
}
window["TaskTypeStr"] = TaskTypeStr

export const TaskTypeTitle = {
	"1": "[主]",
	"2": "[唤醒]",
	"3": "[转]",
	"5": "[支]",
	"6": "[公]",
	"7": "[常]",
	"8": "[常]",
	"9": "[常]"
}
window["TaskTypeTitle"] = TaskTypeTitle

export const TaskTypeColor = {
	"0": "'#60aeff'",
	"1": "'#ff9015'",
	"2": "'#60aeff'",
	"3": "'#a376ff'",
	"5": "'#60aeff'",
	"6": "'#60aeff'",
	"7": "'#60aeff'",
	"8": "'#60aeff'",
	"9": "'#60aeff'"
}
window["TaskTypeColor"] = TaskTypeColor

export enum KillBossIdType {
	/**蛮荒BOSS */
	man_huang = 4,
	/**世界BOSS */
	field = 6,
	/**boss之家 */
	deep = 7,
	/**新世界boss */
	new_field_boss = 12,
	/**秘境领域boss */
	mystery_boss = 16,
	/**怨灵封印(幻饰BOSS) */
	domainserver = 17,
	/**蜃气楼(圣兽领) */
	eudaemon = 10,
}
window["KillBossIdType"] = KillBossIdType

export class TaskModel extends EventDispatcher {
	/** 请求协议 */
	static REQUEST_CCMD_EVENT = "TASKMODEL_REQUEST_CCMD_EVENT";
	/** 更新主线任务vo */
	static UPDATE_MAIN_LINE_TASK_VO = "UPDATE_MAIN_LINE_TASK_VO";
	/** 更新转生任务列表 */
	static UPDATE_REINCARNATION_TASK_LIST = "UPDATE_REINCARNATION_TASK_LIST";
	/** 完成任务 */
	static FINISH_TASK = "FINISH_TASK";
	/** 更新一个任务 30001*/
	static UPDATE_ONE_TASK = "UPDATE_ONE_TASK";
	/** 更新所有任务 30000 */
	static UPDATE_ALL_TASK_FROM_30000 = "UPDATE_ALL_TASK_FROM_30000";
	/** 打开任务模块的界面 */
	static TASK_OPEN_VIEW = "TASK_OPEN_VIEW";
	/** 关闭任务模块的界面 */
	static TASK_CLOSE_VIEW = "TASK_CLOSE_VIEW";
	/** 点击TaskView任务界面内的Bar标签 */
	static CLICK_TASK_BAR_ITEM = "CLICK_TASK_BAR_ITEM";
	/** 刷新TaskView任务界面的滑动组件尺寸 */
	static REFRESH_SCROLL_SIZE = "REFRESH_SCROLL_SIZE";
	/** 更新环任务奖励（日常/结社等） */
	static UPDATE_CIRCLE_TASK_REWARD = "UPDATE_CIRCLE_TASK_REWARD";
	/** 更新环任务进度（日常/结社等） */
	static UPDATE_CIRCLE_TASK_PROGRESS = "UPDATE_CIRCLE_TASK_PROGRESS";
	/** 打开升级贴士界面 */
	static OPEN_UPALERT_VIEW = "OPEN_UPALERT_VIEW";
	/** 关闭升级贴士界面 */
	static CLOSE_UPALERT_VIEW = "CLOSE_UPALERT_VIEW";
	/** 点击做任务 */
	static CLICK_DO_TASK = "CLICK_DO_TASK";
	/** 做采集任务时通知场景给采集怪添加特效 */
	static FIRE_COLLECT_EFFECT = "FIRE_COLLECT_EFFECT";
	/** 刷新界面任务数据*/
	static UPDATE_TASK_ALERT_VIEW = "UPDATE_TASK_ALERT_VIEW";

	/**
	 * 由于任务/任务引导的需求五花八门,如果有需要判断特定的任务ID需在这里定义静态属性来使用，并备注好用途。
	 */


	/** 第一个任务ID */
	static FIRST_TASK_ID = 100010;
	/** 日常任务ID(没有接取日常任务时取这个任务ID的数据) */
	static CLIENT_DAILY_TASK_ID = 400100;
	/** 客户端显示日常任务等级*/
	static CLIENT_DAILY_SHOW_LV = 65;
	/** 结社任务ID(没有接取结社任务时取这个任务ID的数据) */
	static CLIENT_GUILD_TASK_ID = 500100;
	/** 客户端显示结社任务等级*/
	static CLIENT_GUILD_SHOW_LV = 130;
	/** 等级引导判定时长 */
	static lV_ARROW_TIME_LEN = 60;
	/** 任务目标距离玩家位置大于7个格子时加速 */
	static ADD_SPEED_DISTANCE = 7
	/** 任务栏使用2类型排序的等级*/
	static SortOrder2Level = 150
	/** 新手等级 */
	static GuideLevel = 180
	/** 自动任务等级 */
	static AutoGuideLevel = 130
	/** 新手任务在这之前 */
	static GuideTask = 101870
	/** 降神开启支线任务 */
	static GodOpenTaskId = 200900
	/** 自动推关任务ID */
	static AutoBrushTaskId = 101420
	/** 领取离线奖励任务ID*/
	static AfkReceiveTimesTaskId = 101210
	/**101330开始的任务点击默认开启自动闯关 并走到任务指定场景地点挂机打妖 */
	static BRUSH_BOSS_TASK_ID = 101330

	//支线引导
	/**公会捐赠 */
	static GuildDonateTaskId = 201070
	/**公会兑换 */
	static GuildExchangeTaskId = 201080


	static Instance: TaskModel
	public static GetInstance() {
		if (!TaskModel.Instance) {
			TaskModel.Instance = new TaskModel()
		}
		return TaskModel.Instance
	}


	GetMainLineTaskVo
	IsShowExpTask
	IsTaskNeedGuide
	DoTask
	IsFirstTask
	GetTaskTipsMsg
	GetTaskTipsMsgByMainUITaskItem: (task?: ITaskVo, func?: (txt: string, color?: string) => Laya.Text) => Laya.Text[]
	SetCircleTaskProgressData
	IsCircleTask
	IsEudaemonTask
	IsCurrMainTaskHasFinish
	ShouldShowFinishView
	IsAwakeTask
	MainTaskIsJoinGuildTaskType
	FindNextAutoFightTask
	IsAllStepFinish
	GetTypeTask
	GetTaskData
	FormatCircleTaskReaward
	InitConfig
	MainLineTaskNeedShowArrow
	GetNowGuideCfg
	ShouldRestoreTask
	SetCircleTaskReward
	GetTaskTagName
	NotShowFinger
	IsNewFinish
	SetClientDailyAndGuildTask
	GetSortIndex
	MainTaskIsEquipDungeonTaskType
	MainTaskIsExpDungeonTaskType
	SendProtoToFinsh
	IsIndoingCircleTask
	MainTaskIsTowerDungeonTaskType
	MainTaskIsNewMaterialDunTaskType
	MainTaskIsCopperDungeonTaskType
	HaveThisTypeTask
	IsMainTask
	GetTaskNameTitle
	MainTaskIsAwardLvGifttaskType
	MainTaskIsRuneDungeonTaskType
	IsInDoKillMonsterTask
	GetCicleTaskProgressByTaskType
	FindIndex
	DailyAndGuildTaskFun
	ThisTaskTypeCanShowView
	MainTaskIsJoinJJCTaskType
	GetNowGuideCfgByTaskTipsype
	IsCurrMainLineTaskTipType
	ShowRecinationAlert
	GetPauseState
	UpdateHasReceiveTaskListByTaskId
	SetHasReceiveTaskList
	GetHasReceiveTaskList: <A>(task_id?: A) => CheckNever<A> extends 'no' ? { [key: number]: ITaskVo[] } : ITaskVo[]
	SetAllTaskList
	GetAllTaskList
	UpdateAllTaskList
	SetCanTaskList
	GetCanTaskList
	SetMainLineTaskVo
	SetReincarnationTaskList
	GetReincarnationTaskList
	GetTaskCfg
	IsFindNpcTask
	TaskSpeed
	AddSpeedEffect
	CancelSpeedEffect
	GetReceiveTaskVoByTaskType
	HasFinishLvTask
	HasNotFinishLvTask
	ShowTaskAcceptTaskSound
	TaskFinish
	TriggerTaskJump
	CircleTaskIsFinish
	HaveCollectTask
	HavePartnerAwakeTask
	HavePartnerAwakeDungeonTask
	PauseAutoDoTask
	GetAutoTaskSetting
	ShowTaskAutoAlert
	FinishPartnerAwake
	OpenHeartView
	IsPassMainDungeon
	IsSpecialBrushTask
	IsStrengeGuiderTask
	ClearData
	/**获取到公会捐赠引导配置 */
	GetBranchTaskCfg
	IsHasBranchTask
	IsKKHolyAreaTask




	/** 最新完成的任务ID */
	newest_finish_task_id = 0
	/** 当前任务的任务类型 */
	now_do_task_type = TaskType.MAIN_LINE;
	/** 打开过活动界面 */
	has_open_act_view
	/** 环任务进度 */
	circle_task_progress_data = {};
	/** 记录点击等级引导时间戳 */
	click_lv_arrow_time = undefined
	/** 显示过等级引导的次数*/
	show_lv_times = 0
	/** 上次点击主界面任务栏时间 */
	last_click_main_ui_task_time: number
	/** 完成任务VO */
	finish_task_vo
	/** 是否显示过日常赏金任务的引导箭头 */
	has_show_daily_task_finger
	/** 当前选中的任务ID */
	now_select_task_id = 0
	/** 怪物中心坐标 */
	monster_center_pos
	/** 需要去做任务的缓存,等到可做任务时优先取缓存任务 */
	need_go_to_task_cache
	/** 不执行任务操作 */
	not_dotask = false
	/** 自动任务界面是否打开过*/
	auto_task_view_has_open = false
	/** 自动任务引导锁*/
	auto_setting_view_lock_obj:HashObject
	/** 获取日历活动配置*/
	GetConfigAc
	public constructor() {
		super()
		if (TaskModel.Instance) {
			return
		}
		TaskModel.Instance = this

		let TypeSortOrder = {}
		TypeSortOrder[TaskType.MAIN_LINE] = 2
		TypeSortOrder["finish"] = 3
		TypeSortOrder[TaskType.REINCARNATION] = 4
		TypeSortOrder[TaskType.DAILY] = 5
		TypeSortOrder[TaskType.GUILD] = 6
		TypeSortOrder[TaskType.EXTENSION_LINE] = 7
		TypeSortOrder[TaskType.NORMAL_DAILY] = 8
		TypeSortOrder[TaskType.EUDAEMON_TASK] = 9

		let TypeSortOrder2 = {}
		TypeSortOrder2["finish"] = 2
		TypeSortOrder2[TaskType.MAIN_LINE] = 3
		TypeSortOrder2[TaskType.REINCARNATION] = 4
		TypeSortOrder2[TaskType.DAILY] = 5
		TypeSortOrder2[TaskType.GUILD] = 6
		TypeSortOrder2[TaskType.EXTENSION_LINE] = 7
		TypeSortOrder2[TaskType.NORMAL_DAILY] = 8
		TypeSortOrder2[TaskType.EUDAEMON_TASK] = 9
		TypeSortOrder2[TaskType.AWAKE_LINE] = 10

		let local_DUN_TYPE = DUN_TYPE
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let local_BaseDungeonModel = BaseDungeonModel
		let local_AutoFightManager = AutoFightManager
		let local_GameMath = GameMath
		let local_Vector2 = Vector2
		let local_SceneEventType = SceneEventType
		let local_StoryModel = StoryModel
		let local_OpenFun = OpenFun
		let local_Config = Config
		let local_TaskModel = TaskModel
		let local_TaskTipType = TaskTipType
		let local_KillBossIdType = KillBossIdType
		let local_TaskType = TaskType
		let local_TaskTypeTitle = TaskTypeTitle

		let scene_mgr = SceneManager.GetInstance()
		let scene = Scene.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let auto_mgr = local_AutoFightManager.GetInstance()


		let _main_line_task_vo = undefined
		/**已接任务列表 */
		let _has_receive_task_list: { [key: number]: ITaskVo[] } = {}
		/**所有任务列表，包括可接已接 */
		let _all_task_list = {}
		/**可接任务 */
		let _can_task_list = {}
		/**任务加速状态 */
		let _is_add_speed_effect = false
							
		let monster_center_pos = null
		/**是否暂停继续任务 */
		let _pause_to_do_task = false
		let _next_delay_timer_id
		let _delay_out_id
		let _last_main_line_task_id
		let _reincarnation_task_list
		let _delay_id

		this.InitConfig = () => {
			
		}

		this.ClearData = () =>{
			this.has_open_act_view = false
		}

		this.GetMainLineTaskVo = () => {
			return _main_line_task_vo
		}

		this.IsFirstTask = () => {
			if (_main_line_task_vo && _main_line_task_vo.task_id == local_TaskModel.FIRST_TASK_ID) {
				return true
			}
		}

		this.NotShowFinger = () => {
			return false
		}

		this.IsCurrMainTaskHasFinish = () => {
			if (_main_line_task_vo && _main_line_task_vo.has_finish == 1) {
				return true
			} else {
				return false
			}
		}

		this.IsTaskNeedGuide = (task_vo?) => {
			task_vo = task_vo || this.GetMainLineTaskVo()

			// 这个值目前没用了
			// if (task_vo && task_vo.need_guide == 1) {
			// 	return true
			// } else {
			// 	return false
			// }
			return true
		}

		this.IsCurrMainLineTaskTipType = (task_tip_type?) => {
			let main_line_task_vo = this.GetMainLineTaskVo()
			if (main_line_task_vo) {
				return main_line_task_vo.task_tips_type == task_tip_type
			}
			return false
		}

		this.MainTaskIsRuneDungeonTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == local_DUN_TYPE.Rune) {
					return true
				}
			}
		}

		this.MainTaskIsExpDungeonTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == local_DUN_TYPE.Exp) {
					return true
				}
			}
		}

		this.MainTaskIsEquipDungeonTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == local_DUN_TYPE.Equip) {
					return true
				}
			}
		}

		this.MainTaskIsTowerDungeonTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == local_DUN_TYPE.Tower) {
					return true
				}
			}
		}


		/***是否是新资源副本类型的任务 */
		this.MainTaskIsNewMaterialDunTaskType = (new_dun_type) => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == new_dun_type) {
					return true
				}
			}
		}

		this.MainTaskIsCopperDungeonTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.FinDunType && _main_line_task_vo.id == local_DUN_TYPE.Material_Copper) {
					return true
				}
			}
		}

		this.MainTaskIsJoinGuildTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.JoinGuild) {
					return true
				}
			}
		}

		this.MainTaskIsJoinJJCTaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.JoinJcc) {
					return true
				}
			}
		}

		this.MainTaskIsAwardLvGifttaskType = () => {
			if (_main_line_task_vo) {
				if (_main_line_task_vo.task_tips_type == local_TaskTipType.Award_lv_gift) {
					return true
				}
			}
		}

		this.DoTask = (task_vo?, is_skip?, force_show_mainui_icon?, show_alert?, daily_or_guild_one_key_view?) => {
			if (this.not_dotask) {
				return
			}

			if (force_show_mainui_icon == null) {
				force_show_mainui_icon = true
			}
			if (show_alert == null) {
				show_alert = false
			}
			let boss_mgr = window["BossModel"] && window["BossModel"].GetInstance()
			task_vo = task_vo || this.GetMainLineTaskVo()

			if (is_skip == null) {
				is_skip = true
			}

			let need_skip = true
			console.warn("------DoTask------", task_vo, is_skip)
			if (task_vo) {
				if (daily_or_guild_one_key_view && (task_vo.task_type == local_TaskType.DAILY || task_vo.task_type == local_TaskType.GUILD)) {
					let sweep = Config.PRELOAD_SERVER_CONFIG.config_task_sweep
					if (((sweep && sweep[task_vo.task_type]) && role_mgr.mainRoleInfo.level >= sweep[task_vo.task_type].can_sweep_level) && role_mgr.mainRoleInfo.vip_flag >= sweep[task_vo.task_type].vip_lv) {
						let ok_func = () => {
							this.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30013, task_vo.task_type)
						}

						let cancel_func = (is_close?) => {
							if (!is_close) {
								this.DoTask(task_vo, is_skip, force_show_mainui_icon, show_alert)
							}
						}

						let close_func = () => {
							this.DoTask(task_vo, is_skip, force_show_mainui_icon, show_alert)
						}
						let content = Util.StrToHTML("可免费扫荡<font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">" + TaskTypeStr[task_vo.task_type] + "</font>，是否扫荡？")
						Alert.Show(content, Alert_Type.Two, ok_func, cancel_func, "确定", "取消", null, null, null, null, null, null, null, null, null, null, null, "alert_asset.uitc_056", close_func)
						return false
					}
				}
				if (this.now_do_task_type == task_vo.task_type) {
					this.Fire(local_TaskModel.CLICK_DO_TASK, task_vo.task_id, task_vo.task_type)
				}

				if (this.GetPauseState()) {
					console.log("任务状态是暂停状态//////return////-")
					return false
				}

				let task_tips_type = task_vo.task_tips_type
				if (this.IsAllStepFinish(task_vo.task_id) && !this.IsFindNpcTask(task_tips_type)) {
					if (task_tips_type == local_TaskTipType.Award_lv_gift || task_tips_type == local_TaskTipType.Award_eternal_valley) {
						local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.KaiFuBtn, false)
					} else if ((task_tips_type == local_TaskTipType.FinDunType || task_tips_type == local_TaskTipType.FinDungeon) || task_tips_type == local_TaskTipType.KillBoss) {
						local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, false)
						local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
					}
					return false
				}
				let is_main_task = true
				if (task_vo.task_type != local_TaskType.MAIN_LINE) {
					is_main_task = false
				}
				switch (task_tips_type) {
					case local_TaskTipType.Welcome:
						break;
					case local_TaskTipType.Kill:
					case local_TaskTipType.Collect:
					case local_TaskTipType.Item:
						if (!is_skip) {

						} else {
							if (task_vo.scene_id && task_tips_type == local_TaskTipType.Item && scene_mgr.IsFieldBossScene(task_vo.scene_id)) {	//需要杀世界boss， 获取掉落
								if (!CommonManager.GetInstance().CheckFuncOpenState("BossFieldEnterView", true)) {
									Message.show("需要先完成世界大妖任务哦~")
									return false
								} else {
									let boss_id
									if (Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskIdToBossId) {
										boss_id = Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskIdToBossId[task_vo.task_id]
									}
									local_OpenFun.OpenFunHandler(26, boss_id)
								}
								return false
							}
							let logic_pos = scene.main_role.GetLogicPos()
							let pos_x = task_vo.scene_x / SceneObj.GetLogicRealRatio().x
							let pos_y = task_vo.scene_y / SceneObj.GetLogicRealRatio().y
							let distance = local_GameMath.GetDistance(logic_pos.x, logic_pos.y, pos_x, pos_y, true)
							let is_circle_task = false
							let end_func = () => {
								if ((is_circle_task && !this.IsIndoingCircleTask())) {
									return
								}

								this.need_go_to_task_cache = null
								monster_center_pos = null
								let target = scene.GetNearestMonsterByTypeId(task_vo.id)
								if (target) {
									scene.SetClickTarget(target)
								}
								GlobalEventSystem.Fire(local_EventName.STARTAUTOFIGHT)
							}

							let update_func = () => {
								if ((is_circle_task && !this.IsIndoingCircleTask())) {
									return
								}
								if (task_tips_type == local_TaskTipType.Collect) {
									this.Fire(local_TaskModel.FIRE_COLLECT_EFFECT)
								}

								if (task_tips_type == local_TaskTipType.Kill) {
									let target = scene.GetNearestMonsterByTypeId(task_vo.id)
									if (target) {
										let real_pos = scene.main_role.GetRealPos()
										let target_real_pos = target.GetRealPos()
										let distance = GameMath.GetDistance(target_real_pos.x, target_real_pos.y, real_pos.x, real_pos.y, false)
										if (distance < Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.task_rush_to_monster_max_dist * Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.task_rush_to_monster_max_dist) {
											scene.clearGoToData();
											OperateManager.GetInstance().ClearSrcOper()
											scene.MainRoleAttackMonster(target, false, false, true, true)
											GlobalEventSystem.Fire(local_EventName.STARTAUTOFIGHT)
										}
									}
								}
							}

							let move_fun = () => {
								if (task_vo.task_type != local_TaskType.EUDAEMON_TASK && !SceneManager.GetInstance().IsFieldScene()) {
									this.need_go_to_task_cache = task_vo
									Message.show("当前场景不能进入")
									return
								}
								if (!this.IsEudaemonTask(task_vo.task_id)) {
									this.need_go_to_task_cache = task_vo
								}
								monster_center_pos = new local_Vector2(task_vo.scene_x, task_vo.scene_y)
								console.log("taskmodel//-TaskSpeed////////-:", monster_center_pos.x, monster_center_pos.y)
								scene.SetClickTarget(null)
								scene.ClearLastAttack()
								GlobalEventSystem.Fire(local_EventName.STOPAUTOFIGHT)

								// console.warn("------move_fun------")
								this.TaskSpeed(pos_x, pos_y)
								scene.MainRoleMove(new local_Vector2(pos_x, pos_y), 0, end_func, null, null, true, update_func)
							}

							//触发寻路先停掉自动闯关
							AutoBrushModel.GetInstance().StopAutoBrushState()
							if (!this.IsEudaemonTask(task_vo.task_id)) {
								this.need_go_to_task_cache = task_vo
							}
							if (this.IsIndoingCircleTask()) {
								if (task_vo.scene_id == scene_mgr.GetSceneId()) {
									//move_fun()
									if (task_vo.task_type == local_TaskType.EUDAEMON_TASK) {
										move_fun()
									} else {
										is_circle_task = true
										GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(task_vo.scene_id), task_vo.scene_x, task_vo.scene_y, move_fun)
									}
								} else {
									if (task_vo.task_type == local_TaskType.EUDAEMON_TASK) {
										if (boss_mgr) {
											boss_mgr.EudaemonEnterScene(null, task_vo.scene_id)
										}
									} else {
										is_circle_task = true
										GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(task_vo.scene_id), task_vo.scene_x, task_vo.scene_y, end_func)
										//local_GlobalEventSystem:Fire(local_SceneEventType.REQUEST_CHANGE_SCENE, Number(task_vo.scene_id), null, 1, task_vo.scene_x, task_vo.scene_y, null, end_func)
									}
								}
							} else {
								let is_same_pos = false
								if (scene.goToPos) {
									let dist = local_GameMath.GetDistance(scene.goToPos.x, scene.goToPos.y, pos_x, pos_y, true)
									if (dist <= 2) {
										is_same_pos = true
									}
								}
								if (task_vo.scene_id == scene_mgr.GetSceneId()) {
									move_fun()
								} else {
									if (SceneManager.GetInstance().IsFieldScene(task_vo.scene_id)) {
										GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(task_vo.scene_id), task_vo.scene_x, task_vo.scene_y, end_func)
									}
									else {
										let change_scene_call = () => {
											move_fun()
										}
										local_GlobalEventSystem.Fire(local_SceneEventType.REQUEST_CHANGE_SCENE, Number(task_vo.scene_id), null, null, null, change_scene_call)
									}
								}
							}
						}
						break;

					case local_TaskTipType.EquipPre:

						break;
					case local_TaskTipType.PassMainDungeon:
						let auto_brush_model: AutoBrushModel = AutoBrushModel.GetInstance()
						if (!is_skip) {
							if (CommonManager.GetInstance().CheckFuncOpenState("AutoBrush", true)) {
								let auto_state = auto_brush_model.GetAutoBrushStrangeState()
								if (!auto_state) {
									let level = auto_brush_model.GetLevel()
									let next_level = level + 1
									let power_cond_state = true
									let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, next_level, false)
									if (cfg) {
										let main_role_power = RoleManager.GetInstance().GetMainRoleVo().fighting
										if (main_role_power < cfg.power) {
											power_cond_state = false
										}
									}
									//当前关卡失败过且战力条件没达到时
									if (next_level == auto_brush_model.last_failue_level && !power_cond_state) {
										//啥也不做
									}
									else {
										if (task_vo.task_id < TaskModel.BRUSH_BOSS_TASK_ID) {
											local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MainLineDungeon, true, force_show_mainui_icon)
										}
									}
								}
							}
						} else {
							let do_fun = () => {
								GlobalEventSystem.Fire(local_EventName.CLOSE_REINCARNATION_ENTER_VIEW)
								if (CommonManager.GetInstance().CheckFuncOpenState("AutoBrush", true)) {
									let auto_state = auto_brush_model.GetAutoBrushStrangeState()
									if (!auto_state) {
										local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MainLineDungeon, false)
										auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 0)
									}
								} else {
									//未开启自动推关时，走过去直接进
									let info = auto_brush_model.GetBrushStrangeInfo()
									if (info.current_times == info.need_times) {
										auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13305, "c", 0)
									}
								}
							}

							if (task_vo.scene_x != 0 && task_vo.scene_y != 0) {//寻到目标点再进副本
								let findVo = new FindVo()
								findVo.type = FindVo.POINT
								findVo.id = task_vo.id
								findVo.sceneId = task_vo.scene_id
								findVo.x = task_vo.scene_x / SceneObj.LogicRealRatio2D.x
								findVo.y = task_vo.scene_y / SceneObj.LogicRealRatio2D.y
								findVo.call_back = () => {
									let vo = new FindVo()
									vo.type = FindVo.POINT
									vo.id = task_vo.id
									vo.sceneId = task_vo.scene_id
									vo.x = task_vo.scene_x / SceneObj.LogicRealRatio2D.x
									vo.y = task_vo.scene_y / SceneObj.LogicRealRatio2D.y
									vo.call_back = () => {
										do_fun()
									}
									GlobalEventSystem.Fire(local_EventName.FIND, vo)
								}
								let scene_info = SceneManager.Instance.GetSceneInfo(task_vo.scene_id)
								if (scene_info == null) {
									Message.show("场景不存在", task_vo.scene_id)
									return
								}
								if (task_vo.scene_id == scene_mgr.GetSceneId()) {
									this.TaskSpeed(findVo.x, findVo.y)
									GlobalEventSystem.Fire(local_EventName.FIND, findVo)
								} else {		//跨场景
									GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(findVo.sceneId), task_vo.scene_x, task_vo.scene_y, do_fun)
								}
							} else {

								let auto_state = auto_brush_model.GetAutoBrushStrangeState()
								if (!auto_state) {


									let level = auto_brush_model.GetLevel()
									let next_level = level + 1
									let power_cond_state = true
									let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, next_level, false)
									if (cfg) {
										let main_role_power = RoleManager.GetInstance().GetMainRoleVo().fighting
										if (main_role_power < cfg.power) {
											power_cond_state = false
										}
									}

									//当前关卡失败过且战力条件没达到时
									if (next_level == auto_brush_model.last_failue_level && !power_cond_state) {
										//当变强功能开启且有可变强内容时
										if (CommonManager.GetInstance().CheckFuncOpenState("MainStronger", true) && MainStrongerModel.ins.strongerNum > 0) {
											GlobalEventSystem.Fire(MainStrongerEvent.AUTO_BRUSH_SHOW_ARROW)
										}
										else {
											auto_brush_model.Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW2)
										}
									}
									else {
										auto_brush_model.Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW2)
									}
								} else {
									auto_mgr.StartFieldSceneAutoFight()
								}

								// do_fun()
							}
						}
						break;

					case local_TaskTipType.DressEquip:
						if (!is_skip) {

						} else
							local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, 1)
						break;
					case local_TaskTipType.FusionEquip:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BagIcon, true, force_show_mainui_icon)
						} else {
							if (is_main_task) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BagIcon, false)
								if (!this.IsTaskNeedGuide()) {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_SMELTING_VIEW, 0)
								} else {
									if (MainFunc) {
										local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Bag)
									}
								}
							}
						}
						break;
					case local_TaskTipType.DressOrangeEquip:

						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BagIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BagIcon, false)
							if (MainFunc) {
								local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Bag)
							}
						}
						break;
					case local_TaskTipType.TradingPutaway:
					case local_TaskTipType.BuyFromTrading:
						if (!is_skip) {

						} else {
							local_OpenFun.OpenFunHandler(94)
						}
						break;
					case local_TaskTipType.StrenEquip:
					case local_TaskTipType.StrenSum:
					case local_TaskTipType.EquipStoneNum:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ForgingIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ForgingIcon, false)
							if (MainFunc) {
								local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Equip)
							}
						}
						break;
					case local_TaskTipType.FinDungeon:
						if (!is_skip) {
						} else {
							let do_fun = () => {
								if (scene_mgr.IsReincarnationDungeon(task_vo.id)) {
									local_BaseDungeonModel.GetInstance().Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, task_vo.id)
								} else if (scene_mgr.IsHeartDungeon(task_vo.id)) {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonHeartEnterView", task_vo)
									//local_BaseDungeonModel:GetInstance():Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, task_vo.id)
								} else if (scene_mgr.IsEquipDungeon(task_vo.id)) {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Equip)
								} else if (scene_mgr.IsDailyDungeon(task_vo.id) || scene_mgr.IsNewMainLineDungeon(task_vo.id)) {
									local_BaseDungeonModel.GetInstance().Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, task_vo.id)
								} else if (scene_mgr.IsPolarDungeon(task_vo.id) || scene_mgr.IsKFPolarDungeon(task_vo.id)) {
									local_OpenFun.OpenFunHandler(165)
								}
							}
							if (scene_mgr.IsNewMainLineDungeon(task_vo.id) && scene_mgr.IsDungeonScene(scene_mgr.GetSceneId())) {
								let dungeonInfo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, task_vo.id, false)
								if (dungeonInfo && dungeonInfo.scene_id == scene_mgr.GetSceneId()) {
									GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
									return
								}
							}
							if (task_vo.scene_x != 0 && task_vo.scene_y != 0) {    //寻到目标点再进副本
								let findVo = new FindVo()
								findVo.type = FindVo.POINT
								findVo.id = task_vo.id
								findVo.sceneId = task_vo.scene_id
								findVo.x = task_vo.scene_x / SceneObj.LogicRealRatio2D.x
								findVo.y = task_vo.scene_y / SceneObj.LogicRealRatio2D.y
								findVo.call_back = () => {
									let vo = new FindVo()
									vo.type = FindVo.POINT
									vo.id = task_vo.id
									vo.sceneId = task_vo.scene_id
									vo.x = task_vo.scene_x / SceneObj.LogicRealRatio2D.x
									vo.y = task_vo.scene_y / SceneObj.LogicRealRatio2D.y
									vo.call_back = () => {
										do_fun()
									}
									GlobalEventSystem.Fire(EventName.FIND, vo)
								}
								let scene_info = SceneManager.Instance.GetSceneInfo(task_vo.scene_id)
								if (scene_info == null) {
									Message.show("场景不存在", task_vo.scene_id)
									return
								}
								//触发寻路先停掉自动闯关
								AutoBrushModel.GetInstance().StopAutoBrushState()
								if (task_vo.scene_id == scene_mgr.GetSceneId()) {
									this.TaskSpeed(findVo.x, findVo.y)
									GlobalEventSystem.Fire(EventName.FIND, findVo)
								} else {		//跨场景
									GlobalEventSystem.Fire(EventName.USE_FLY_SHOE, Number(findVo.sceneId), task_vo.scene_x, task_vo.scene_y, do_fun)
								}
							} else {
								do_fun()
							}
						}
						break
					case local_TaskTipType.FinDunType:
						let finish_tower = false
						let finish_rune = false
						if (!is_skip) {
							if (task_vo.id == local_DUN_TYPE.Boss_Guide_One || task_vo.id == local_DUN_TYPE.Boss_Guide_Two) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, true)
							} else {
								if (finish_tower) {
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
								} else {
									//报错屏蔽
									if (!GuardModel.GetInstance().experice_view_open) {
										local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, true)
									}
								}
							}
						} else {
							if (task_vo.id == local_DUN_TYPE.Boss_Guide_One
								|| task_vo.id == local_DUN_TYPE.Boss_Guide_Two) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, false)
								local_OpenFun.OpenFunHandler(26)
							}
							// else if (task_vo.id == local_DUN_TYPE.NEW_MOUNT) {
							// 	local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, true)
							// } 
							else {
								if (is_main_task && BaseDungeonModel.GetInstance().IsNewMateriaDungeon(task_vo.id)) {
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Material)
								}
								else if ((is_main_task && !finish_tower && !finish_rune) && task_vo.id != local_DUN_TYPE.MonsterInvasion && task_vo.id != local_DUN_TYPE.Main_Line && task_vo.task_id != 101270 && task_vo.task_id != 101160) {
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Rune)
								} else {
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
									if (task_vo.id == local_DUN_TYPE.Rune || finish_rune) {
										let open = CommonManager.GetInstance().CheckFuncOpenState("DungeonRuneEnterView")
										if (open) {
											local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Material)
										}
									} else if (task_vo.id == local_DUN_TYPE.Exp) {
										local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Exp)
									} else if (task_vo.id == local_DUN_TYPE.Tower || finish_tower) {
										let open = CommonManager.GetInstance().CheckFuncOpenState("DungeonTowerEnterView")
										if (open) {

										}
									} else if (task_vo.id == local_DUN_TYPE.MonsterInvasion) {
										// MonsterInvasionModel.GetInstance().Fire(MonsterInvasionModel.OPEN_VIEW)
									} else if (task_vo.id == local_DUN_TYPE.Vip_Rerson_Boss) {
										local_OpenFun.OpenFunHandler(29)
									} else if (task_vo.id == local_DUN_TYPE.Equip) {
										local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Equip)
									} else if (task_vo.id == local_DUN_TYPE.Dragon) {
										local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Dragon)
									} else if (task_vo.id == local_DUN_TYPE.SingleRank) {
										local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.SingleRank)
									} else if (task_vo.id == local_DUN_TYPE.Main_Line) {
										local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "AutoBrushBaseView")
									} else {
										local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Material)
									}
								}
							}




						}
						break;
					case local_TaskTipType.TrainMount:
					case local_TaskTipType.TrainPartner:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.PetIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.PetIcon, false)
							if (!is_main_task && task_tips_type == local_TaskTipType.TrainPartner || task_tips_type == local_TaskTipType.TrainPartner && task_vo.task_id != 100430) {
								if (CommonManager.GetInstance().CheckFuncOpenState("PartnerComponentView") && MainFunc) {
									if (task_vo.task_type == local_TaskType.EXTENSION_LINE) {
										local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet, 1)
									} else {
										local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet, 1)
									}
								}
							} else {
								if (MainFunc) {
									local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet)
								}
							}
						}
						break;
					case local_TaskTipType.ArtifactLevel:
					case local_TaskTipType.TrainWing:
					case local_TaskTipType.TrainArtifact:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RoleIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RoleIcon, false)
							if (MainFunc) {
								local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
							}
						}
						break;
					case local_TaskTipType.MountLevel:
						if (!is_skip) {
							switch (task_vo.id) {
								case 3:
								case 4:
								case 5:
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RoleIcon, true, force_show_mainui_icon)
									break;
								case 1:
								case 2:
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.PetIcon, true, force_show_mainui_icon)
									break;
							}
						} else {
							switch (task_vo.id) {
								case 3:
								case 4:
								case 5:
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RoleIcon, false)
									if (MainFunc) {
										local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role, task_vo.id - 2)
									}
									break;
								case 1:
								case 2:
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.PetIcon, false)
									if (MainFunc) {
										local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet, task_vo.id - 1)
									}
									break;
							}

						}
						break;
					case local_TaskTipType.KillBoss:
						if (!is_skip) {
							if (task_vo.id == local_KillBossIdType.field || task_vo.id == local_KillBossIdType.new_field_boss) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, true)
							}
						} else {
							if (task_vo.id == local_KillBossIdType.field || task_vo.id == local_KillBossIdType.new_field_boss) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, false)
								local_OpenFun.OpenFunHandler(26)
							} else if (task_vo.id == local_KillBossIdType.deep) {
								local_OpenFun.OpenFunHandler(28)
							} else if (task_vo.id == local_KillBossIdType.man_huang) {
								local_OpenFun.OpenFunHandler(30)
							} else if (task_vo.id == local_KillBossIdType.mystery_boss) {
								local_OpenFun.OpenFunHandler(135)
							} else if (task_vo.id == local_KillBossIdType.eudaemon) {
								local_OpenFun.OpenFunHandler(86)
							} else if (task_vo.id == local_KillBossIdType.domainserver) {
								local_OpenFun.OpenFunHandler(157)
							}
						}
						break;
					case local_TaskTipType.JoinJcc:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ArenaBtn, true)
						} else {
							if (is_main_task) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ArenaBtn, false)
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView")
							} else {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView")
							}
						}
						break;
					case local_TaskTipType.CombatPower:
						if (!is_skip) {

						} else {
							if (role_mgr.mainRoleInfo.level < 150) {
								if (window["MainFunc"]) {
									local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Equip)
								}
							} else {
								DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 5, 3)
							}
						}
						break;
					case local_TaskTipType.RefineEquip:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ForgingIcon, true, force_show_mainui_icon)
						}
						break;
					case local_TaskTipType.RefineSum:

						break;
					case local_TaskTipType.AddFriend:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.FriendIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.FriendIcon, false)
							local_GlobalEventSystem.Fire(local_EventName.OPEN_FRIEND_VIEW, { "index": 0, "force": 1 })
							FriendModel.GetInstance().Fire(FriendEvent.OPEN_ADD_VIEW)
						}
						break;
					case local_TaskTipType.JoinGuild:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.GuildIcon, true, force_show_mainui_icon)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.GuildIcon, false)
							GuildModel.GetInstance().OpenGuildView()
						}
						break;
					case local_TaskTipType.ActiveMount:
					case local_TaskTipType.ActiveWing:
					case local_TaskTipType.ActivePartner:
					case local_TaskTipType.ActiveArtifact:
						if (!is_skip) {
							need_skip = false
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RebornBtn, false)
						}
						break;
					case local_TaskTipType.AchvAward:
					case local_TaskTipType.UpgradeMedal:
						if (!is_skip) {

						} else {
							if (task_tips_type == local_TaskTipType.UpgradeMedal) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_MEDAL_ENTER_VIEW, 0)
							}
						}
						break;
					case local_TaskTipType.LV:
						if (!is_skip) {
							need_skip = false
						} else {
							this.Fire(local_TaskModel.OPEN_UPALERT_VIEW)
						}
						break;
					case local_TaskTipType.ActiveDsg:
					case local_TaskTipType.ActiveDesignation:
						if (!is_skip) {
							need_skip = false
						} else {

						}
						break;
					case local_TaskTipType.RuneLvSum:
					case local_TaskTipType.RuneNum:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MallIcon, true, force_show_mainui_icon)
						} else {
							if (is_main_task) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MallIcon, false)
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SecretTreasureMainView")
							}
						}
						break;
					case local_TaskTipType.UpgradeSkillStren:
					case local_TaskTipType.SkillStrenNum:
						if (!is_skip) {
							need_skip = false
						} else {

						}
						break;
					case local_TaskTipType.FinTask:
						if (!is_skip) {
							need_skip = false
							if (task_vo.id == 200110) {

							}
						} else {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_REINCARNATION_ENTER_VIEW)
						}
						break;
					case local_TaskTipType.FinMainTask:
						if (!is_skip) {
							need_skip = false
						} else {

						}
						break;
					case local_TaskTipType.RuneLv:
						if (!is_skip) {
							need_skip = false
						} else {

						}
						break;
					case local_TaskTipType.AchvLv:
						if (!is_skip) {

						} else {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_MEDAL_ENTER_VIEW)
						}
						break;
					case local_TaskTipType.KillBossLv:
						if (!is_skip) {

						} else {
							local_OpenFun.OpenFunHandler(26)
						}
						break;
					case local_TaskTipType.Activity_lv:

						break;
					case local_TaskTipType.Award_lv_gift:
					case local_TaskTipType.Award_eternal_valley:
						if (!is_skip) {
							if (MainUIModel.GetInstance().activity_icon_in_show) {
								if (task_tips_type == local_TaskTipType.Award_lv_gift) {
									if (!this.has_open_act_view) {
										this.has_open_act_view = true
										local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3", 417)
									} else {
										//local_GlobalEventSystem:Fire(local_EventName.OPEN_ACT_VIEW, "331@3")
									}

								} else {
									local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.KaiFuBtn, true)
								}
							}
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.KaiFuBtn, false)
							if (task_tips_type == local_TaskTipType.Award_lv_gift) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3", 417)
							} else {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3")
							}
						}
						break;
					case local_TaskTipType.Rune_treasure:
						if (!is_skip) {
							if (MainUIModel.GetInstance().activity_icon_in_show) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RuneTreasureBtn, true)
							}
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RuneTreasureBtn, false)
							RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView")
						}
						break;
					case local_TaskTipType.Dungeon_level:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, true)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SingleDungeon, false)
							if (task_vo.id == local_DUN_TYPE.Rune) {
								let open = CommonManager.GetInstance().CheckFuncOpenState("DungeonRuneEnterView")
								if (open) {
									local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Rune)
								}
							} else if (task_vo.id == local_DUN_TYPE.Tower) {
								let open = CommonManager.GetInstance().CheckFuncOpenState("DungeonTowerEnterView")
								if (open) {

								}
							} else {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Material)
							}
						}
						break;
					case local_TaskTipType.Activity_acc:
						if (!is_skip) {
							need_skip = false
						} else {
							DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView")
						}
						break;
					case local_TaskTipType.Fin_glad:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ArenaBtn, true)
						} else {
							if (is_main_task) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.ArenaBtn, false)
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView")
							}
						}
						break;
					case local_TaskTipType.Equip_color:
						if (!is_skip) {
							need_skip = false
						} else {

						}
						break;
					case local_TaskTipType.Kill_lv:
					case local_TaskTipType.Outside_kill_lv:
					case local_TaskTipType.Item2:
						if (!is_skip) {
							need_skip = false
						} else {
							auto_mgr.StartFieldSceneAutoFight()
						}
						break;
					case local_TaskTipType.Kill_boss_id:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, true)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BossDungeon, false)
							local_OpenFun.OpenFunHandler(26, task_vo.id)
						}
						break;
					case local_TaskTipType.Award_7day:
						if (!is_skip) {
							need_skip = false
						} else {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_SEVENDAY_VIEW)
						}
						break;
					case local_TaskTipType.Award_daily:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.WefareBtn, true)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.WefareBtn, false)
							local_GlobalEventSystem.Fire(local_EventName.OPEN_WELFARE_VIEW)
						}
						break;
					case local_TaskTipType.Fin_task_daily:
					case local_TaskTipType.Fin_task_guild:
					case local_TaskTipType.Fin_husong:
						if (!is_skip) {
							need_skip = false
						} else {
							if (task_tips_type == local_TaskTipType.Fin_task_guild && RoleManager.GetInstance().GetMainRoleVo().guild_id == 0) {
								let ok_func = () => {
									// GuildModel.GetInstance().Fire(GuildEvent.OPEN_VIEW, "GuildJoinBaseView")
									GuildModel.GetInstance().OpenGuildView()
								}

								Alert.Show("需要加入结社才可以接取结社任务", Alert_Type.Two, ok_func, null, "前往", "取消")
								return
							}
							if (task_tips_type == local_TaskTipType.Fin_task_daily) {
								this.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30011, local_TaskType.DAILY)
							} else if (task_tips_type == local_TaskTipType.Fin_task_guild) {
								this.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30011, local_TaskType.GUILD)
							} else {
								// DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView")
							}
						}
						break;
					case local_TaskTipType.CollectMaterial:
					case local_TaskTipType.Cost_goods:
						if (task_vo.scene_id && scene_mgr.IsFieldBossScene(task_vo.scene_id)) {	//需要杀世界boss， 获取掉落
							if (scene_mgr.IsDungeonScene()) {
								Message.show("当前场景无法进入")
								return
							}
							if (!CommonManager.GetInstance().CheckFuncOpenState("BossFieldEnterView", true)
								|| this.newest_finish_task_id < Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.FirstBossTaskId) {
								Message.show("需要先完成世界首领任务哦~")
								return false
							} else {
								let boss_id
								if (Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskIdToBossId) {
									boss_id = Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskIdToBossId[task_vo.task_id]
								}
								local_OpenFun.OpenFunHandler(26, boss_id)
							}
							return false
						}

						if (task_vo.now_num >= task_vo.need_num) {
							local_OpenFun.OpenFunHandler(18)
						} else {
							if (task_vo.scene_x != 0 && task_vo.scene_y != 0) {
								let findVo = new FindVo()
								findVo.type = FindVo.POINT
								findVo.id = task_vo.id
								findVo.sceneId = task_vo.scene_id
								// if (scene_mgr.Is3DScene(task_vo.scene_id)) {
								// 	findVo.x = task_vo.scene_x / SceneObj.GetLogicRealRatio().x
								// 	findVo.y = task_vo.scene_y / SceneObj.GetLogicRealRatio().y
								// } else {
								findVo.x = task_vo.scene_x / SceneObj.GetLogicRealRatio().x
								findVo.y = task_vo.scene_y / SceneObj.GetLogicRealRatio().y
								// }
								findVo.call_back = () => {
									GlobalEventSystem.Fire(local_EventName.STARTAUTOFIGHT)
								}
								let scene_info = SceneManager.Instance.GetSceneInfo(task_vo.scene_id)
								if (scene_info == null) {
									Message.show("场景不存在", task_vo.scene_id)
									return
								}
								//触发寻路先停掉自动闯关
								AutoBrushModel.GetInstance().StopAutoBrushState()
								GlobalEventSystem.Fire(local_EventName.FIND, findVo)
							} else {
								auto_mgr.StartFieldSceneAutoFight()
							}
						}
						break;
					case local_TaskTipType.Awakening:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(18)
						}

						break;
					case local_TaskTipType.Kill_vip_boss:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(29)
						}
						break;
					case local_TaskTipType.Kill_shengyu_boss:
						if (!is_skip) {
							need_skip = false
						} else {
							let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
							if (open_day < 5) {
								local_OpenFun.OpenFunHandler(88)
							} else {
								let kf_holy_model = window["KfHolyAreaModel"]
								{
									let open_lv = kf_holy_model.GetInstance().GetKeyValue("open_lv")
									if (open_lv) {
										if (role_mgr.mainRoleInfo.level >= open_lv) {
											//防止在场景里面被任务系统再次打开页面
											if(!SceneManager.GetInstance().IsKfHolyAreaScene()){
											local_OpenFun.OpenFunHandler(104)
											}
										} else {
											// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
											// 	Message.show("Lv." + open_lv + "เปิดแดนเซนต์ข้ามSV")
											// } else {
											Message.show(open_lv + "级开启跨服异域")
											// }
										}
									}
								}
							}
						}
						break;
					case local_TaskTipType.Seal_set_num:
						if (!is_skip) {
							need_skip = false
						} else {
							let bag_model = window["BagModel"]
							if (bag_model) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW, bag_model.Index.HolySeal)
							}
						}
						break;
					case local_TaskTipType.Red_equip_combine:
						if (!is_skip) {
							if (MainUIModel.GetInstance().show_type == 1) {
								//第二页
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RedIcon, true, false, true)
							} else {
								//第一页
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MainUISwitchBtn, true, false, true)
							}
						} else {
							if (MainUIModel.GetInstance().show_type == 1) {
								//第二页
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RedIcon, false)
							} else {
								//第一页
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.MainUISwitchBtn, false)
							}
							if (MainFunc) {
								local_GlobalEventSystem.Fire(local_EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Red)
							}
							//local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.RedIcon, true, true)
							// local_OpenFun.OpenFunHandler(96)
						}
						break;
					case local_TaskTipType.Active_red_suit:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(116)
						}
						break;
					case local_TaskTipType.Active_suit:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(24)
						}
						break;
					case local_TaskTipType.Active_god:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(126)
						}
						break;
					case local_TaskTipType.Single_dun_exp:
						if (!is_skip) {
							need_skip = false
						} else {
							local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Exp)
						}
						break;
					case local_TaskTipType.Jjc_rank:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(48)
						}
						break;
					case local_TaskTipType.Talk:
					case local_TaskTipType.StartTalk:
					case local_TaskTipType.EndTalk:
						if (!is_skip) {
							need_skip = false
						} else {
							if (task_vo.id == 0) { //自言自语
								// GlobalEventSystem.Fire(SceneEventType.SHOW_TASK, task_vo.id)
								return
							} else {
								let findVo = new FindVo()
								findVo.type = FindVo.NPC
								findVo.id = task_vo.id
								findVo.sceneId = task_vo.scene_id
								findVo.x = task_vo.scene_x / SceneObj.LogicRealRatio2D.x
								findVo.y = task_vo.scene_y / SceneObj.LogicRealRatio2D.y
								let scene_info = SceneManager.Instance.GetSceneInfo(task_vo.scene_id)
								if (scene_info == null) {
									Message.show("场景不存在", task_vo.scene_id)
									return
								}
								//触发寻路先停掉自动闯关
								AutoBrushModel.GetInstance().StopAutoBrushState()
								let npc_vo = SceneManager.Instance.GetNpcVo(findVo.id)   //npc寻路，只有npc和主角在同一场景才有位置值
								if (npc_vo) {
									findVo.x = npc_vo.logic_x
									findVo.y = npc_vo.logic_y
								} else {
									if (findVo.x != 0 && findVo.y != 0) {
										findVo.type = FindVo.NPC
										findVo.call_back = () => {
											Scene.Instance.MainRoleToNpc(findVo.id)
										}
									}
								}
								// let logic_pos = scene.main_role.GetLogicPos()
								// let distance = local_GameMath.GetDistance(logic_pos.x, logic_pos.y, findVo.x, findVo.y, true)
								let is_circle_task = false
								let end_func = () => {
									if (!is_circle_task || (is_circle_task && this.IsIndoingCircleTask())) {
										GlobalEventSystem.Fire(local_EventName.FIND, findVo)
									}
								}
								if (SceneManager.GetInstance().IsFieldScene()) {
									scene.SetClickTarget(null)
									scene.ClearLastAttack()
									GlobalEventSystem.Fire(local_EventName.STOPAUTOFIGHT)

									if (this.IsIndoingCircleTask()) {		//环任务
										is_circle_task = true
										GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(findVo.sceneId), task_vo.scene_x, task_vo.scene_y, end_func)
									} else {
										if (task_vo.scene_id == scene_mgr.GetSceneId()) {
											this.TaskSpeed(findVo.x, findVo.y)
											GlobalEventSystem.Fire(local_EventName.FIND, findVo)
										} else {		//跨场景
											GlobalEventSystem.Fire(local_EventName.USE_FLY_SHOE, Number(findVo.sceneId), task_vo.scene_x, task_vo.scene_y, end_func)

										}
									}
								} else {
									this.need_go_to_task_cache = task_vo
									if (!scene_mgr.IsDailyDungeon() && !scene_mgr.IsMainLineDungeonScene()) {		//环任务
										Message.show("当前场景不能进入")
									}
								}
							}
						}
						break;
					case local_TaskTipType.Login_day:
						if (!is_skip) {
							need_skip = false
						} else {
							Message.show("次日登录可完成")
						}
						break;
					case local_TaskTipType.Coin:
						if (!is_skip) {
							need_skip = false
						} else {
							let tong = RoleManager.GetInstance().GetMainRoleVo().tong
							let is_enough = tong >= task_vo.need_num
							if (is_enough) {
								var ok = () => {
									this.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, task_vo.task_id)
								}
								let str = Util.StrToHTML("是否上交<font color='" + Enum_ColorUtil_Dark.GREEN + "'>" + task_vo.need_num + "</font>金币以完成任务")
								Alert.Show(str, Alert_Type.Two, ok, null, "确定", "取消")
							} else {
								Message.show("铜币不足~")
								// MaterialsTool.GetInstance().materialsTips(Config.ConfigNotNormalGoods[3].goods_id)
							}
						}
						break;
					case local_TaskTipType.Open_function:
						if (!is_skip) {
							if (!TempleAwakenModel.GetInstance().is_moving) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.TempleAwakenBtn, true)
							}

						} else {
							local_OpenFun.OpenFunHandler(429)
						}
						break;
					case local_TaskTipType.Deposit:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(199)
						}
						break;
					case local_TaskTipType.Suit_clt:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SuitActivityBtn, true)
						} else {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.SuitActivityBtn, false)
							local_OpenFun.OpenFunHandler(196)
						}
						break;
					case local_TaskTipType.Enter_Sanctum:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(136)
						}
						break;
					case local_TaskTipType.Enter_dranlan:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(163)
						}
						break;
					case local_TaskTipType.Chrono_value:
						if (!is_skip) {
							need_skip = false
						} else {
							local_OpenFun.OpenFunHandler(174)
						}
						break;
					case local_TaskTipType.Boss_assist:
						if (!is_skip) {
							need_skip = false
						} else {
							if (GuildModel.IsHasGuild()) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GuildHelpView")
							}
							else {
								let ok_func = () => {
									GuildModel.GetInstance().OpenGuildView()
								}

								Alert.Show("需要加入结社才可以进行结社求助", Alert_Type.Two, ok_func, null, "前往", "取消")
							}
						}
						break;
					case local_TaskTipType.ActiveSoap:
						if (!is_skip) {
							if (this.IsSpecialBrushTask()) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BrushBtn, true)
							}
						} else {
							if (this.IsSpecialBrushTask()) {
								local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.BrushBtn, false)
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "AutoBrushBaseView", EnumAutoBrushTabType.eAutoBrush)
							} else {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "AutoBrushBaseView", EnumAutoBrushTabType.eAutoBrush)
							}
						}
						break;
					case local_TaskTipType.MountLevel:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.PetIcon, true, force_show_mainui_icon)
						} else {
							if (task_vo.id == enum_OutWardType.Horse) {
								OutWardBaseModel.GetInstance().Choose_Tab = 1
								local_OpenFun.OpenFunHandler(2)
							} else if (task_vo.id == enum_OutWardType.Partner) {
								OutWardBaseModel.GetInstance().Choose_Tab = 1
								local_OpenFun.OpenFunHandler(15)
							}

						}
						break;
					case local_TaskTipType.AfkReceiveTimes:
						if (!is_skip) {
							local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, local_StoryModel.StoryTargetName.AfkReceiveBtn, true, force_show_mainui_icon)
						} else {
							OnHookModel.GetInstance().Fire(OnHookModel.OPEN_VIEW, "OnHookMainView")
						}
						break;
					case local_TaskTipType.GuildDonate:
					case local_TaskTipType.GuildExchange:
						if (!is_skip) {

						} else {
							local_OpenFun.OpenFunHandler(50)
						}
						break
					default:
						need_skip = false
						break
				}

			}
			return need_skip
		}

		this.IsMainTask = (task_id?) => {
			let is_main_task = false
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				if (task_cfg.type == local_TaskType.MAIN_LINE) {
					is_main_task = true
				}
			}
			return is_main_task
		}

		this.IsAwakeTask = (task_id?) => {
			let awake_task = false
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				if (task_cfg.type == local_TaskType.AWAKE_LINE) {
					awake_task = true
				}
			}
			return awake_task
		}

		this.IsKKHolyAreaTask = (task_id?) => {
			let kfHolyArea_task = false
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				if (task_cfg.type == local_TaskType.KFHOLYAREA_TASK) {
					kfHolyArea_task = true
				}
			}
			return kfHolyArea_task
		}

		this.IsEudaemonTask = (task_id?) => {
			let eudaemon_task = false
			if (task_id == CommonManager.GetInstance().GetValue(4700006)) {
				eudaemon_task = true
			}
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				if (task_cfg.type == local_TaskType.EUDAEMON_TASK) {
					eudaemon_task = true
				}
			}
			return eudaemon_task
		}

		this.IsShowExpTask = (task_id?) => {
			let show = false
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				if ((task_cfg.type == local_TaskType.MAIN_LINE || task_cfg.type == local_TaskType.DAILY) || task_cfg.type == local_TaskType.GUILD) {
					show = true
				}
			}
			return show
		}

		//是否是主线关卡类型10 里面的任务
		this.IsPassMainDungeon = (task_id, is_main_ui_arrow = true) => {
			let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTaskArrow
			if (!cfg) return false
			let now_cfg = cfg[local_TaskTipType.PassMainDungeon]
			if (!now_cfg) return false
			if (is_main_ui_arrow) {
				let main_ui_cfg = now_cfg.in_main_ui
				if (main_ui_cfg.sub_dun_type_in_main_ui && main_ui_cfg.sub_dun_type_in_main_ui[task_id]) {
					return true
				}
			} else {
				let main_ui_cfg = now_cfg.sub_in_view
				if (main_ui_cfg[task_id]) {
					return true
				}
			}
			return false
		}


		this.GetNowGuideCfg = (is_main_ui_arrow?, task_vo?) => {
			let arrow_cfg = null
			let task = task_vo || _main_line_task_vo
			if (task) {
				if(task.task_id == TaskModel.FIRST_TASK_ID){
					arrow_cfg = { direction: 4, text: "点击此处完成任务吧" }
				}
				let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTaskArrow
				if (cfg) {
					let now_cfg = cfg[task.task_tips_type]
					if (now_cfg) {
						if (is_main_ui_arrow) {
							let main_ui_cfg = now_cfg.in_main_ui
							if (main_ui_cfg) {
								if (task.task_tips_type == local_TaskTipType.FinDunType
									|| task.task_tips_type == local_TaskTipType.MountLevel) {
									if (main_ui_cfg.sub_dun_type_in_main_ui && main_ui_cfg.sub_dun_type_in_main_ui[task.id]) {
										let dun_main_ui_cfg = main_ui_cfg.sub_dun_type_in_main_ui[task.id]
										if (task.has_finish == 1) {
											arrow_cfg = dun_main_ui_cfg.finish
										} else {
											arrow_cfg = dun_main_ui_cfg.not_finish
										}
									}
								} else if (task.task_tips_type == local_TaskTipType.PassMainDungeon) {
									let dun_main_ui_cfg
									if (main_ui_cfg.sub_dun_type_in_main_ui && main_ui_cfg.sub_dun_type_in_main_ui[task.task_id]) {
										dun_main_ui_cfg = main_ui_cfg.sub_dun_type_in_main_ui[task.task_id]
										if (task.has_finish == 1) {
											arrow_cfg = dun_main_ui_cfg.finish
										}
										else {
											arrow_cfg = dun_main_ui_cfg.not_finish
										}
									}
								} else if (task.task_tips_type == local_TaskTipType.Red_equip_combine) {
									if (task.has_finish == 0) {
										if (MainUIModel.GetInstance().show_type == 0) {
											arrow_cfg = main_ui_cfg.switch_not_finish
										} else {
											arrow_cfg = main_ui_cfg.not_finish
										}
									}
								}

								if (!arrow_cfg) {
									if (task.has_finish == 1) {
										arrow_cfg = main_ui_cfg.finish
									} else if (task.task_tips_type != local_TaskTipType.Kill) {
										arrow_cfg = main_ui_cfg.not_finish
									}
								}
							}
						} else {
							if (now_cfg) {
								let step = local_StoryModel.GetInstance().curr_view_story_step
								let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
								if (open_day >= 8 || PlatformManager.GetInstance().is_alpha || PlatformManager.GetInstance().need_alpha_open_charge) {
									if (this.IsCurrMainLineTaskTipType(local_TaskTipType.Award_lv_gift) && step == 0) {
										step = 1
									}
								}
								if (task.task_tips_type == local_TaskTipType.FinDunType
									|| task.task_tips_type == local_TaskTipType.TrainMount
									|| task.task_tips_type == local_TaskTipType.MountLevel) {
									if ((now_cfg.sub_dun_type && now_cfg.sub_dun_type) && now_cfg.sub_dun_type[task.id]) {
										let dun_arrow_cfg = now_cfg.sub_dun_type[task.id]
										arrow_cfg = dun_arrow_cfg.in_view[step]
									}
								}

								if (task.task_tips_type == local_TaskTipType.PassMainDungeon) {
									if ((now_cfg.sub_in_view && now_cfg.sub_in_view) && now_cfg.sub_in_view[task.task_id]) {
										let dun_arrow_cfg = now_cfg.sub_in_view[task.task_id]
										arrow_cfg = dun_arrow_cfg[step]
									}
								}


								if (!arrow_cfg) {
									if (now_cfg.in_view) {
										arrow_cfg = now_cfg.in_view[step]
									}
								}
							}
						}
					}
				}

			}
			return arrow_cfg
		}

		this.GetNowGuideCfgByTaskTipsype = (task_tips_type?, is_finish?) => {
			let arrow_cfg = null
			let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTaskArrow
			if (cfg) {
				let now_cfg = cfg[task_tips_type]
				if (now_cfg) {
					if (now_cfg.not_main_line) {
						if (is_finish) {
							arrow_cfg = now_cfg.not_main_line.finish
						} else {
							arrow_cfg = now_cfg.not_main_line.not_finish
						}
					}
				}
			}
			return arrow_cfg
		}

		this.IsInDoKillMonsterTask = () => {
			let is_in_do = false
			let monster_list, role_list = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 500, null, null, null)
			let main_role = scene.main_role
			let task = null
			let distance = null
			let logic_pos = main_role.GetLogicPos()
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				for (let task_id in receive_task_list) {

					task = receive_task_list[task_id]
					if (task) {
						for (let _tmpi in task) {
							var task_vo = task[_tmpi]
							if (task_vo.task_tips_type == local_TaskTipType.Kill) {
								distance = local_GameMath.GetDistance(logic_pos.x, logic_pos.y, task_vo.scene_x / SceneObj.GetLogicRealRatio().x, task_vo.scene_y / SceneObj.GetLogicRealRatio().y, true)
								if ((((distance < 10 && monster_list) && monster_list.length > 0) && monster_list[0].vo) && task_vo.id == monster_list[0].vo.type_id) {
									is_in_do = true
									break
								}
							}
						}
					}
					if (is_in_do) {
						break
					}
				}
			}
			return is_in_do
		}

		//自动下一个任务
		this.FindNextAutoFightTask = () => {
			let tips_list = null
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				let find = false
				for (let task_id in receive_task_list) {
					tips_list = receive_task_list[task_id]
					if (tips_list) {
						for (let _tmpi in tips_list) {
							let task_vo = tips_list[_tmpi]
							if (task_vo.task_type == this.now_do_task_type) {
								if ((task_vo.task_tips_type == local_TaskTipType.Kill && task_vo.has_finish != 1)
									|| this.now_do_task_type == local_TaskType.GUILD
									|| this.now_do_task_type == local_TaskType.DAILY
									|| this.now_do_task_type == local_TaskType.EUDAEMON_TASK
									|| task_vo.task_tips_type == local_TaskTipType.Talk
									|| task_vo.task_tips_type == local_TaskTipType.StartTalk
									|| task_vo.task_tips_type == local_TaskTipType.EndTalk
									|| task_vo.task_tips_type == local_TaskTipType.Collect
									|| task_vo.task_tips_type == local_TaskTipType.PassMainDungeon
								) {

									let step_cfg = this.GetNowGuideCfg(true, task_vo)
									if(step_cfg) return

									if (_next_delay_timer_id) {
										clearTimeout(_next_delay_timer_id)
										_next_delay_timer_id = null
									}
									if (this.now_do_task_type == local_TaskType.GUILD || this.now_do_task_type == local_TaskType.DAILY) {
										let delay_fun = () => {
											this.DoTask(task_vo)
										}
										_next_delay_timer_id = setTimeout(delay_fun, 700)
									} else {
										this.DoTask(task_vo)
									}
									find = true
									break
								}
							}
						}
					}
					if (find) {
						break
					}
				}
			}
		}

		this.SetCircleTaskProgressData = (scmd?) => {
			this.circle_task_progress_data[scmd.task_type] = scmd
			this.SetClientDailyAndGuildTask(true, scmd.task_type)
			this.DelayFire(local_TaskModel.UPDATE_CIRCLE_TASK_PROGRESS, scmd)
		}

		this.GetTaskData = () => {
			let task_data = []
			let not_finish_vo = null
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				for (let task_id in receive_task_list) {

					let task_vo = receive_task_list[task_id]
					if (task_vo && task_vo[0]) {
						let task = task_vo[0]
						if (task) {
							if (task.task_type == local_TaskType.MAIN_LINE) {
								let main_line_task = { "type": local_TaskType.MAIN_LINE, "data": null, "sort_index": 1 }
								// main_line_task.data = this.GetMainLineTaskVo()
								main_line_task.data = task
								task_data.push(main_line_task)
							} else if (task.task_type == local_TaskType.GUILD) {
								let guild_task = { "type": local_TaskType.GUILD, "data": null, "sort_index": 6 }
								guild_task.data = task
								task_data.push(guild_task)
							} else if (task.task_type == local_TaskType.DAILY || task.task_type == local_TaskType.NORMAL_DAILY) {
								let daily_task = { "type": local_TaskType.DAILY, "data": null, "sort_index": 7 }
								daily_task.data = task
								task_data.push(daily_task)
							} else if (task.task_type == local_TaskType.REINCARNATION) {
								if (role_mgr.GetMainRoleVo().turn < 4) {
									let rein_task = { "type": local_TaskType.REINCARNATION, "data": null, "sort_index": 3 }
									rein_task.data = task
									task_data.push(rein_task)
								}
							} else if (task.task_type == local_TaskType.EXTENSION_LINE) {
								let extension_task = { "type": local_TaskType.EXTENSION_LINE, "data": null, "sort_index": 8 }
								extension_task.data = task
								task_data.push(extension_task)
							}
						}
					}
				}
			}
			let sort_fun = (a, b) => {
				if (a.sort_index == b.sort_index) {
					if (a.data && b.data) {
						return a.data.task_id - b.data.task_id
					}
				} else {
					return a.sort_index - b.sort_index
				}
			}

			task_data.sort(sort_fun)
			return task_data
		}

		this.IsCircleTask = (task_type?) => {
			if (task_type == local_TaskType.GUILD || task_type == local_TaskType.DAILY) {
				return true
			}
		}

		this.IsIndoingCircleTask = () => {
			if (this.now_do_task_type == local_TaskType.GUILD || this.now_do_task_type == local_TaskType.DAILY || this.now_do_task_type == local_TaskType.EUDAEMON_TASK) {
				return true
			}
		}

		this.GetCicleTaskProgressByTaskType = (task_type?) => {
			let _type = (task_type != null && (task_type) || (this.now_do_task_type))
			let now_progress = this.circle_task_progress_data[_type]
			if (!now_progress) return [null, null]
			let { finish_num, all_num } = now_progress
			finish_num++;
			if (task_type == TaskType.GUILD) {
				all_num = 10
				if (finish_num == null) {
					finish_num = 0
				}
				finish_num = (finish_num % 10 == 0 && (10) || (finish_num % 10))
			}
			return [finish_num, all_num || 0]

		}

		this.SetCircleTaskReward = (task_id?, reward_list?, extra_reward_list?) => {
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				let task_vo = null
				task_vo = receive_task_list[task_id]
				if (task_vo && task_vo.length > 0) {
					for (let _tmpi in task_vo) {
						var vo = task_vo[_tmpi]
						vo.circle_task_normal_reward = reward_list
						vo.circle_task_extra_reward = extra_reward_list
					}
				}
				this.DelayFire(local_TaskModel.UPDATE_CIRCLE_TASK_REWARD, task_id)
			}
		}

		this.FormatCircleTaskReaward = (task_tips_vo?) => {
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				let task_vo = null
				task_vo = receive_task_list[task_tips_vo.task_id]
				if (task_vo) {
					if (task_vo[0] && (task_vo[0].task_type == local_TaskType.GUILD || task_vo[0].task_type == local_TaskType.DAILY)) {
						task_tips_vo.circle_task_normal_reward = task_vo[0].circle_task_normal_reward
						task_tips_vo.circle_task_extra_reward = task_vo[0].circle_task_extra_reward
					}
				}
			}
		}

		this.ThisTaskTypeCanShowView = (vo?) => {
			return vo &&
				(
					(
						(vo.task_type == local_TaskType.GUILD || vo.task_type == local_TaskType.DAILY || vo.task_type == local_TaskType.EUDAEMON_TASK)
						&& vo.task_tips_type != local_TaskTipType.ActiveMount
						&& vo.task_tips_type != local_TaskTipType.ActiveWing
						&& vo.task_tips_type != local_TaskTipType.ActivePartner
						&& vo.task_tips_type != local_TaskTipType.ActiveArtifact
					)
					|| vo.show_finish == 1
				)
		}

		this.ShouldShowFinishView = (task_tips_list?) => {
			let is_finish_lv_task = false
			let need_break = false
			if (task_tips_list) {
				for (let _tmpi in task_tips_list) {
					var vo = task_tips_list[_tmpi]
					if (vo.has_finish == 1) {
						if (vo.new_finish_flag) {
							vo.new_finish_flag = false
							if (this.ThisTaskTypeCanShowView(vo)) {
								if (scene_mgr.IsFieldScene() || scene_mgr.IsHolyBossScene()) {
									if (this.IsCircleTask(vo.task_type)) {
										this.Fire(TaskModel.TASK_OPEN_VIEW, 'TaskCircleFinishView', vo);
									}
									else {
										this.Fire(TaskModel.TASK_OPEN_VIEW, 'TaskFinishView', vo);
									}
								} else {
									this.finish_task_vo = vo
								}
								break
							}
						}
						[is_finish_lv_task, need_break] = this.SendProtoToFinsh(vo)
						if (need_break) {
							break
						}
					}
				}
			}
			return is_finish_lv_task
		}

		//发协议直接完成
		this.SendProtoToFinsh = (vo?) => {
			let is_finish_lv_task = false
			let need_break = false
			if (vo && vo.has_finish == 1) {
				if (vo.task_type == local_TaskType.MAIN_LINE && (
					vo.task_tips_type == local_TaskTipType.Kill
					|| vo.task_tips_type == local_TaskTipType.LV
					|| vo.task_tips_type == local_TaskTipType.Collect
					// || vo.task_tips_type == local_TaskTipType.PassMainDungeon //斩妖需要关闭结算界面并退出场景才完成任务
				)
				) { //杀怪任务,卡级,采集任务直接完成

					if (vo.task_tips_type == local_TaskTipType.Collect) {
						GlobalEventSystem.Fire(local_EventName.STOPAUTOFIGHT)
					}
					if (vo.task_tips_type == local_TaskTipType.LV && RoleManager.Instance.mainRoleInfo.level < TaskModel.GuideLevel) {
						this.now_do_task_type = vo.task_type
						is_finish_lv_task = true
						GlobalEventSystem.Fire(local_EventName.STOPAUTOFIGHT)
						if (_delay_out_id) {
							clearTimeout(_delay_out_id)
							_delay_out_id = null
						}
						GlobalEventSystem.Fire(SceneEventType.CLOSE_DIALOGUE_VIEW)
					}
					this.Fire(local_TaskModel.REQUEST_CCMD_EVENT, 30004, vo.task_id)
					need_break = true
				}
			}
			return [is_finish_lv_task, need_break]
		}

		//赏金和结社
		this.DailyAndGuildTaskFun = (task_tips_list?) => {
			if (task_tips_list) {
				if (this.now_do_task_type == local_TaskType.GUILD || this.now_do_task_type == local_TaskType.DAILY) {
					for (let _tmpi in task_tips_list) {
						var vo = task_tips_list[_tmpi]
						if (
							(vo.task_type == local_TaskType.GUILD || vo.task_type == local_TaskType.DAILY)
							&& (
								vo.task_tips_type == local_TaskTipType.Kill
								|| vo.task_tips_type == local_TaskTipType.Talk
								|| vo.task_tips_type == local_TaskTipType.StartTalk
								|| vo.task_tips_type == local_TaskTipType.EndTalk
								|| vo.task_tips_type == local_TaskTipType.FinDungeon
							)) {
							if (vo.task_tips_type != local_TaskTipType.Kill || vo.now_num == 0) {
								if (!this.HasFinishLvTask()) {
									if (_delay_out_id) {
										clearTimeout(_delay_out_id)
										_delay_out_id = null
									}
									_delay_out_id = setTimeout(() => {
										//console.log("继续任务//////////：", vo.task_tips_type, vo.now_num)
										this.DoTask(vo)
										_delay_out_id = null
									}, 500)
								}
							}
						}
					}
				}
			}
		}

		this.GetTaskTipsMsg = (task?, color_light?) => {
			let tips_msg = task.task_tips_msg
			color_light = color_light || false
			if (task) {
				let color_str = color_light && "#00fa64" || "#0a953e"
				if ((task.task_type == local_TaskType.GUILD || task.task_type == local_TaskType.DAILY)
					&& task.task_tips_type != local_TaskTipType.Talk && task.task_tips_type != local_TaskTipType.StartTalk && task.task_tips_type != local_TaskTipType.EndTalk) {
					if (task.task_tips_type == local_TaskTipType.FinDungeon) { 	//通关副本
						let cfg_dungeon = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, task.id, false)
						if (cfg_dungeon) {
							tips_msg = "通关<font color='" + color_str + "'>" + cfg_dungeon.name + "</font>副本"
						}
					} else {
						let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, task.id, false);
						if (monster) {
							tips_msg = "击杀<font color='" + color_str + "'>" + monster.name + "</font>"
						}
					}

				} else if (task.task_type == local_TaskType.EUDAEMON_TASK) {
					let taskCfg = this.GetTaskCfg(task.task_id)
					let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, task.id, false)
					if (taskCfg.kind == 2) {
						let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(task.id)
						if (goodsVo) {
							tips_msg = "收集<font color='" + color_str + "'>" + goodsVo.goods_name + "</font>"
						}
					} else if (monster) {
						if (taskCfg && taskCfg.kind == 3) {
							tips_msg = "采集<font color='" + color_str + "'>" + monster.name + "</font>"
						} else {
							tips_msg = "击杀<font color='" + color_str + "'>" + monster.name + "</font>"
						}
					}
				} else if (task.task_tips_type == local_TaskTipType.Talk || task.task_tips_type == local_TaskTipType.StartTalk || task.task_tips_type == local_TaskTipType.EndTalk) {
					let npc_config = local_Config.GetConfigVo("config_npc", task.id, false)
					if (npc_config) {
						// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
						// 	tips_msg = "Chat with " + "<font color='" + color_str + "'>" + npc_config.name + "</font>"
						// } else {
						tips_msg = "与" + "<font color='" + color_str + "'>" + npc_config.name + "</font>交谈"
						// }
					}
				} else {
					tips_msg = task.task_tips_msg
				}
			}
			return tips_msg
		}

		this.GetTaskTipsMsgByMainUITaskItem = (task?: ITaskVo, func?) => {
			let lblArr: Laya.Text[] = [];
			if (!task) return null;
			if (task.task_tips_type == TaskTipType.Talk || task.task_tips_type == TaskTipType.StartTalk || task.task_tips_type == TaskTipType.EndTalk) {
				let npc_config = local_Config.GetConfigVo('config_npc', task.id, false);
				if (npc_config) {
				if(PlatformManager.IsEyouEnPlatform()){
						lblArr.push(func('Talk to'));
						lblArr.push(func(npc_config.name, '#00fa64'));
				}
				else if(PlatformManager.IsEyouThPlatform()){
						lblArr.push(func('คุยกับ'));
						lblArr.push(func(npc_config.name, '#00fa64'));
				}else{
						lblArr.push(func('与'));
						lblArr.push(func(npc_config.name, '#00fa64'));
						lblArr.push(func('交谈'));
				}
					
				}
				return lblArr;
			}
			switch (task.task_type) {
				case local_TaskType.DAILY:
				case local_TaskType.GUILD:
					if (task.task_tips_type == TaskTipType.FinDungeon) {
						//通关副本
						let cfg_dungeon = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, task.id, false);
						if (cfg_dungeon) {
							lblArr.push(func('通关'));
							lblArr.push(func(cfg_dungeon.name, '#00fa64'));
							lblArr.push(func('副本'));
						}
					} else {
						let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, task.id, false);
						if (monster) {
							lblArr.push(func('击杀'));
							lblArr.push(func(monster.name, '#00fa64'));
						}
					}
					break;
				case local_TaskType.EUDAEMON_TASK:
					let taskCfg = this.GetTaskCfg(task.task_id);
					if (taskCfg.kind == 2) {
						let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(task.id);
						if (goodsVo) {
							lblArr.push(func('收集'));
							lblArr.push(func(goodsVo.goods_name, '#00fa64'));
						}
						break;
					}
					let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, task.id, false);
					if (monster) {
						if (taskCfg?.kind == 3) {
							lblArr.push(func('采集'));
						} else {
							lblArr.push(func('击杀'));
						}
						lblArr.push(func(monster.name, '#00fa64'));
					}
					break;
				default:
					lblArr.push(func(task.task_tips_msg));
					break;
			}
			if (!lblArr?.length) {
				lblArr.push(func(task.task_tips_msg));
			}
			return lblArr;
		};

		this.IsNewFinish = (task_vo?) => {
			let is_new = false
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				let task = null
				for (let task_id in receive_task_list) {

					if (task_vo.task_id == task_id) {
						task = receive_task_list[task_id]
						for (let _tmpi in task) {
							var vo = task[_tmpi]
							if (task_vo.task_tips_type == vo.task_tips_type && task_vo.id == vo.id && task_vo.need_num == vo.need_num && task_vo.scene_id == vo.scene_id && task_vo.scene_x == vo.scene_x && task_vo.scene_y == vo.scene_y) {
								if (vo.has_finish != 1) {
									is_new = true
								} else {
									is_new = false
								}
								break
							}
						}
					}
				}
			}
			return is_new
		}

		this.HaveThisTypeTask = (task_type?) => {
			let have = false
			let receive_task_list = this.GetAllTaskList()
			if (task_type && receive_task_list) {
				let task = null
				for (let task_id in receive_task_list) {

					task = receive_task_list[task_id]
					if (task) {
						for (let _tmpi in task) {
							var task_vo = task[_tmpi]
							if (task_vo.task_type == task_type) {
								have = true
								this.now_do_task_type = task_type
								if (task_vo.has_finish == 1) {
									//按照需求屏蔽弹出，需要玩家手动点击
									//this.Fire(local_TaskModel.TASK_OPEN_VIEW, "TaskView")
								} else {
									this.DoTask(task_vo, null, null, null, false)
								}
								break
							}
						}
					}
				}
			}
			return have
		}

		this.ShowRecinationAlert = (task_tips_list?) => {
			let task = null
			let task2 = null
			let recain_num = null
			if ((task_tips_list && task_tips_list[0]) && task_tips_list[0].task_type == local_TaskType.REINCARNATION) {
				task = task_tips_list[0]
				recain_num = Number(String(task.task_id).substr(3, 4))
				if (recain_num == 12) {
					task2 = this.GetHasReceiveTaskList(task.task_id)
					if (task2 && task2[0]) {
						if (task2[0].task_tips_type != task.task_tips_type && task.task_tips_type == local_TaskTipType.CollectMaterial) {
							let str = Util.StrToHTML("<font color='#639c12'>离线挂机也可获得转职材料哦</font>")
							Alert.Show(str, Alert_Type.One)
						}
					}
				}
			}
		}

		this.ShouldRestoreTask = () => {
			if (this.need_go_to_task_cache && this.GetHasReceiveTaskList(this.need_go_to_task_cache.task_id)) {
				//关闭自动任务状态,不处理缓存的任务的逻辑
				if(this.GetAutoTaskSetting()){
					this.now_do_task_type = this.need_go_to_task_cache.task_type
					this.DoTask(this.need_go_to_task_cache)
					this.need_go_to_task_cache = null
					return true
				}
				else{
					this.need_go_to_task_cache = null
					return true
				}
			} else {
				this.need_go_to_task_cache = null
				return false
			}
		}

		this.FindIndex = (task_id?, task_type?, is_finish?) => {
			let index = null
			let sub_index = null
			if (task_id && task_type) {
				let lv = role_mgr.mainRoleInfo.level
				let order_list = TypeSortOrder
				if (lv >= TaskModel.SortOrder2Level) {
					order_list = TypeSortOrder2
				}
				if (is_finish) {
					index = order_list["finish"]
					sub_index = order_list[task_type]
				} else {
					index = order_list[task_id]
					if (!index) {
						index = order_list[task_type]
						sub_index = order_list[task_type]
					}
				}
			}
			if (!index) {
				index = 99
			}
			if (!sub_index) {
				sub_index = 99
			}
			return [index, sub_index]
		}

		//获取排序
		this.GetSortIndex = (task_id?) => {
			let task_cfg = this.GetTaskCfg(task_id)
			let index = 0
			let sub_index = 0
			let same_type_order_index = 0
			if (task_cfg) {
				let is_finish = this.IsAllStepFinish(task_id)
				let [a, b] = this.FindIndex(task_id, task_cfg.type, is_finish)
				index = a
				sub_index = b
				same_type_order_index = task_cfg.sep
			}
			return [index, sub_index, same_type_order_index]
		}

		this.MainLineTaskNeedShowArrow = () => {
			let main_line_task_vo = this.GetMainLineTaskVo()
			if (main_line_task_vo) {
				// if (this.IsPassMainDungeonAutoTask(main_line_task_vo.task_id)) {
				// 	return false
				// }
				return this.IsTaskNeedGuide(main_line_task_vo) //|| main_line_task_vo.main_line_order <= 30
			}
			return false
		}

		this.IsAllStepFinish = (task_id?) => {
			if (!this.GetAllTaskList()) {
				return
			}
			// [ts2lua]this.HasReceiveTaskList下标访问可能不正确
			let arr = this.GetAllTaskList(task_id)
			let is_finish = true
			if (arr) {
				for (let _tmpi in arr) {
					var vo = arr[_tmpi]
					if (vo.has_finish != 1) {
						is_finish = false
						break
					}
					else {
						//转生任务特殊处理
						if (vo.task_type == TaskType.REINCARNATION && window["ReincarnationModel"]) {
							let lv = window["ReincarnationModel"].GetInstance().needStageList[vo.task_id] || 0;
							if (RoleManager.GetInstance().GetMainRoleVo().level < lv) {
								is_finish = false
								break
							}
						}
					}
				}
			}
			return is_finish
		}

		this.GetTaskNameTitle = (task_id?) => {
			let str = ""
			let task_cfg = this.GetTaskCfg(task_id)
			if (task_cfg) {
				str = local_TaskTypeTitle[task_cfg.type] + task_cfg.name
			}
			return str
		}

		this.SetClientDailyAndGuildTask = (need_update?, task_type?) => {
			if (this.circle_task_progress_data) {
				let progress = this.circle_task_progress_data[task_type]
				if (progress) {
					let have_task = false
					// let task_vo = null
					let tips_list = null
					let receive_task_list = this.GetHasReceiveTaskList()
					if (receive_task_list) {
						for (let task_id in receive_task_list) {

							tips_list = receive_task_list[task_id]
							if (tips_list) {
								for (let _tmpi in tips_list) {
									var task_vo = tips_list[_tmpi]
									if (task_vo && task_vo.task_type == task_type) {
										have_task = true
										break
									}
								}
							}
							if (have_task) {
								break
							}
						}
					}
					if (!have_task) {
						let lv = local_TaskModel.CLIENT_DAILY_SHOW_LV
						let task_id = local_TaskModel.CLIENT_DAILY_TASK_ID
						let task_tips_type = local_TaskTipType.Fin_task_daily
						let str = "完成20次日常任务"
						let times = 20
						if (task_type == local_TaskType.GUILD) {
							lv = local_TaskModel.CLIENT_GUILD_SHOW_LV
							task_id = local_TaskModel.CLIENT_GUILD_TASK_ID
							task_tips_type = local_TaskTipType.Fin_task_guild
							str = "完成10次结社任务"
							times = 10
						}
						//if (progress.finish_num <= 0 && role_mgr.mainRoleInfo.level >= lv ) {
						if (progress.finish_num < times && role_mgr.mainRoleInfo.level >= lv) {
							let task_tips_list = []
							task_tips_list.push(new TaskVo(task_id, task_tips_type, str, 0, 0, times, 0, 0, 0, 0, 0, 0))
							if (!this.GetHasReceiveTaskList()) {
								this.SetHasReceiveTaskList({})
							}
							this.UpdateHasReceiveTaskListByTaskId(task_id, task_tips_list)
							this.UpdateAllTaskList(task_id, task_tips_list)
							if (need_update) {
								this.DelayFire(local_TaskModel.UPDATE_ALL_TASK_FROM_30000)
							}
						}
					}
				}
			}
		}

		this.GetTypeTask = (task_type?) => {
			let taskList = this.GetHasReceiveTaskList()
			if (taskList) {
				for (let key in taskList) {
					let taskInfo = taskList[key]
					if (taskInfo[0] && taskInfo[0].task_type == task_type) {
						return taskInfo[0]
					}
				}
			}
		}



		//任务图标类型
		this.GetTaskTagName = (task_type?) => {
			let name = "支"
			if (task_type == TaskType.MAIN_LINE) {
				name = "主"
			} else if (task_type == TaskType.DAILY) {
				name = "日"
			} else if (task_type == TaskType.GUILD) {
				name = "结"
			} else if (task_type == TaskType.REINCARNATION) {
				name = "转"
			}
			return name
		}

		this.UpdateHasReceiveTaskListByTaskId = (task_id?, task_tips_list?) => {

			if (_has_receive_task_list) {
				_has_receive_task_list[task_id] = task_tips_list
			}
		}

		this.SetHasReceiveTaskList = (value?) => {
			_has_receive_task_list = value
		}

		this.GetHasReceiveTaskList = (task_id?) => {

			if (!_has_receive_task_list || Util.TableSize(_has_receive_task_list) <= 0) {
				return null
			}
			if (task_id) {
				//@ts-ignore
				return _has_receive_task_list[task_id]
			} else {
				return _has_receive_task_list
			}
		}


		this.SetAllTaskList = (value?) => {
			_all_task_list = value
		}

		this.GetAllTaskList = (task_id?) => {

			if (!_all_task_list) {
				return null
			}
			if (task_id) {
				return _all_task_list[task_id]
			} else {
				return _all_task_list
			}
		}

		this.UpdateAllTaskList = (task_id?, task_tips_list?) => {

			if (_all_task_list) {
				_all_task_list[task_id] = task_tips_list
			}
		}

		this.SetCanTaskList = (value?) => {
			_can_task_list = value
		}

		this.GetCanTaskList = (task_id?) => {

			if (!_can_task_list) {
				return null
			}
			if (task_id) {
				return _can_task_list[task_id]
			} else {
				return _can_task_list
			}
		}

		this.SetMainLineTaskVo = (value?) => {
			if (_main_line_task_vo) {
				_last_main_line_task_id = _main_line_task_vo.task_id
			} else {
				_last_main_line_task_id = null
			}
			_main_line_task_vo = value
			this.DelayFire(TaskModel.UPDATE_MAIN_LINE_TASK_VO, value, (value && (_last_main_line_task_id == value.task_id) || (false)))
		}

		this.SetReincarnationTaskList = (value?) => {
			_reincarnation_task_list = value
			this.Fire(TaskModel.UPDATE_REINCARNATION_TASK_LIST, value)
			if (value) {
				ActivityIconManager.GetInstance().addIcon(130)
			} else {
				ActivityIconManager.GetInstance().deleteIcon(130)
			}
		}

		this.GetReincarnationTaskList = () => {
			return _reincarnation_task_list
		}

		this.GetTaskCfg = (task_id?) => {
			return Config.GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, task_id, false)
		}

		this.IsFindNpcTask = (task_tips_type?) => {

			if (task_tips_type == TaskTipType.Talk || task_tips_type == TaskTipType.StartTalk || task_tips_type == TaskTipType.EndTalk) {
				return true
			}
			return false
		}

		//任务加速
		this.TaskSpeed = (findVo_x?, findVo_y?, force?) => {
			let logic = Scene.GetInstance().main_role.GetLogicPos()
			if (findVo_x != -1 && findVo_y != -1 && logic.x != -1 && logic.y != -1) {
				if ((GameMath.GetDistance(logic.x, logic.y, findVo_x, findVo_y) > TaskModel.ADD_SPEED_DISTANCE * TaskModel.ADD_SPEED_DISTANCE || force)
					&& SceneManager.GetInstance().TaskCanAddSpeedBuffScene()) {
					this.AddSpeedEffect()
				} else {
					this.CancelSpeedEffect()
				}
			}
		}

		//长距离任务加速
		this.AddSpeedEffect = () => {

			if (_is_add_speed_effect) {
				return
			}
			_is_add_speed_effect = true
			setTimeout(() => {
				if (_is_add_speed_effect) {
					// MainCamera.GetInstance().ChangeSmoothState(MainCamera.SmoothState.NewBieTask)
					let main_role = Scene.GetInstance().GetMainRole()
					main_role.AddSpeedBuffEffect()
				}
			}, 150)
		}

		//取消长距离加速
		this.CancelSpeedEffect = () => {
			if (!_is_add_speed_effect) {
				return
			}
			_is_add_speed_effect = false
			let main_role = Scene.GetInstance().main_role
			main_role.CancleSpeedBuffEffect()
			// if (main_role.IsOnHorse()) {
			// 	MainCamera.GetInstance().ChangeSmoothState(MainCamera.SmoothState.Horse)
			// } else {
			// 	MainCamera.GetInstance().ChangeSmoothState(MainCamera.SmoothState.Normal)
			// }
		}

		//通过任务类型获取已接任务
		this.GetReceiveTaskVoByTaskType = (task_type?) => {

			let receive_task_list = this.GetHasReceiveTaskList()
			let result_vo = null
			let tips_list = null
			if (receive_task_list) {
				for (let task_id in receive_task_list) {

					tips_list = receive_task_list[task_id]
					if (tips_list) {
						for (let _tmpi in tips_list) {
							var task_vo = tips_list[_tmpi]
							if (task_vo && task_vo.task_type == task_type) {
								result_vo = task_vo
								break
							}
						}
					}
					if (result_vo) {
						break
					}
				}
			}
			return result_vo
		}

		//是否含有已完成的卡级任务
		this.HasFinishLvTask = () => {

			let has_finish_lv = false
			let receive_task_list = this.GetHasReceiveTaskList()
			let tips_list = null
			if (receive_task_list) {
				for (let task_id in receive_task_list) {

					tips_list = receive_task_list[task_id]
					if (tips_list) {
						for (let _tmpi in tips_list) {
							var task_vo = tips_list[_tmpi]
							if (task_vo && task_vo.task_type == TaskType.MAIN_LINE && task_vo.task_tips_type == TaskTipType.LV && task_vo.has_finish == 1) {
								has_finish_lv = true
								break
							}
						}
					}
					if (has_finish_lv) {
						break
					}
				}
			}
			return has_finish_lv
		}

		//是否含有未完成的卡级任务，且含有日常任务
		this.HasNotFinishLvTask = () => {
			let has_lv = false
			let lv_task_vo = null
			let daily_task = null
			// if (RoleManager.GetInstance().mainRoleInfo.level < TaskModel.SortOrder2Level) {
			let receive_task_list = this.GetHasReceiveTaskList()
			let tips_list = null
			if (receive_task_list) {
				for (let task_id in receive_task_list) {

					tips_list = receive_task_list[task_id]
					if (tips_list) {
						for (let _tmpi in tips_list) {
							var task_vo = tips_list[_tmpi]
							if (task_vo && task_vo.task_tips_type == TaskTipType.LV && task_vo.has_finish != 1 && task_vo.task_type == TaskType.MAIN_LINE) {
								has_lv = true
								lv_task_vo = task_vo
								break
							}
						}
					}
					if (has_lv) {
						break
					}
				}
			}
			daily_task = this.GetReceiveTaskVoByTaskType(TaskType.DAILY)
			// }
			return [has_lv, lv_task_vo, daily_task]
		}

		//播放新接的任务的音效
		this.ShowTaskAcceptTaskSound = (new_receive_task_list?) => {
			let last_receive_task_list = this.GetHasReceiveTaskList()
			if (last_receive_task_list && new_receive_task_list) {
				let is_new_accept = false
				for (let task_id in new_receive_task_list) {
					var v = new_receive_task_list[task_id]
					is_new_accept = true
					for (let tmp_id in last_receive_task_list) {
						var vo = last_receive_task_list[tmp_id]
						if (task_id == tmp_id) {
							is_new_accept = false
							break
						}
					}
					if (is_new_accept) {
						// TaskSoundManager.GetInstance().PlayTaskAcceptSound(task_id)
						break
					}
				}
			}
		}

		//任务完成
		this.TaskFinish = (task_id?) => {

			if (task_id == TaskModel.GodOpenTaskId) {
				local_OpenFun.OpenFunHandler(126)
			}

			let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTaskJump && Config_PRELOAD_CLIENT_CONFIG.ConfigTaskJump[task_id]
			if (cfg && cfg.trigger_type == 2) {
				this.TriggerTaskJump(cfg)
			}
			Scene.GetInstance().StartTaskTalk(task_id)
		}

		this.TriggerTaskJump = (cfg) => {
			let scene_id = SceneManager.GetInstance().GetSceneId()
			if (scene_id != cfg.scene_id) return
			let main_role = Scene.GetInstance().GetMainRole()
			if (main_role.is_shoe_flying) { return }
			if (main_role.IsInState(PoseState.TASK_JUMP)) { return }
			main_role.DoTaskJump(Role.MULTI_JUMP_TYPE.Jump_4, Util.DeepCopy(cfg.jump_pos_list), null, cfg.speed, cfg.gravity_speed, true)
		}

		//结社或赏金任务是否已完成
		this.CircleTaskIsFinish = (task_type?) => {

			let is_finish = false
			if (this.circle_task_progress_data) {
				let progress = this.circle_task_progress_data[task_type]
				if (progress) {
					let times = 20
					if (task_type == TaskType.GUILD) {
						times = 10
					}
					if (progress.finish_num >= times) {
						is_finish = true
					}
				}
			}
			return is_finish
		}

		//拥有采集任务
		this.HaveCollectTask = (mon_id?) => {

			let is_suitable = false
			let receive_task_list = this.GetHasReceiveTaskList()
			if (receive_task_list) {
				let task
				for (let task_id in receive_task_list) {

					task = receive_task_list[task_id]
					if (task) {
						for (let _tmpi in task) {
							var task_vo = task[_tmpi]
							if (task_vo.task_tips_type == TaskTipType.Collect && task_vo.id == mon_id) {
								is_suitable = true
								break
							}
						}
					}
				}
			}
			return is_suitable
		}

		//是否有伙伴唤醒任务
		this.HavePartnerAwakeTask = () => {

			let bool = this.GetHasReceiveTaskList(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.root_task_id) != null
				|| this.GetHasReceiveTaskList(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.task_list.main_task_id) != null
				|| this.GetHasReceiveTaskList(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.task_list2.main_task_id) != null
				|| !PartnerModel.GetInstance().PartnerIsActiveById(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.partner_id)

			return bool
		}

		//是否有伙伴唤醒的经验副本任务
		this.HavePartnerAwakeDungeonTask = () => {
			if (!Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake) {
				return []
			}
			let task = this.GetHasReceiveTaskList(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.ExpDungeonTaskId)
			let task_vo
			if (task && task[0]) {
				task_vo = task[0]
			}
			return [task != null, task_vo]
		}

		//暂停, 恢复任务
		this.PauseAutoDoTask = (bool?) => {
			if (RoleManager.Instance.mainRoleInfo.level > TaskModel.AutoGuideLevel) {
				console.log("暂停为false////////////-")
				_pause_to_do_task = false
				return
			}
			let task_vo = this.GetMainLineTaskVo()
			if (task_vo && task_vo.task_id) {
				if (_delay_id) {
					clearTimeout(_delay_id)
					_delay_id = null
				}
				_pause_to_do_task = bool


				if (bool) {
					OperateManager.GetInstance().StopMove(true)  //先清掉当前场景的操作包，避免继续移动寻路
				} else {
					//卡级任务不触发引导/任务
					if (task_vo.task_tips_type == TaskTipType.LV) {
						return
					}
					if (task_vo) {
						let delay_fun = () => {
							if (!StoryModel.GetInstance().HasFingerIsShowing() && this.GetAutoTaskSetting()) {
								if (this.IsCurrMainLineTaskTipType(TaskTipType.TrainArtifact)
									|| this.IsCurrMainLineTaskTipType(TaskTipType.TrainMount)
									|| this.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)
									|| this.IsCurrMainLineTaskTipType(TaskTipType.TrainWing)
									|| this.IsCurrMainLineTaskTipType(TaskTipType.ArtifactLevel)
								) {
									this.DoTask(task_vo, false)
								} else {
									if (this.IsCurrMainLineTaskTipType(TaskTipType.Kill)
										|| this.IsCurrMainLineTaskTipType(TaskTipType.Collect)
										|| this.IsCurrMainLineTaskTipType(TaskTipType.Talk)
										|| this.IsCurrMainLineTaskTipType(TaskTipType.EndTalk)
										|| this.IsCurrMainLineTaskTipType(TaskTipType.ArtifactLevel)
									) {
										this.DoTask(task_vo, null)
									}
								}
							}
						}
						_delay_id = setTimeout(delay_fun, 400)
					}
				}
			}
		}

		//获取是否暂停任务状态   暂停为true 
		this.GetPauseState = () => {
			return _pause_to_do_task
		}

		//自动任务设置
		this.GetAutoTaskSetting = () => {
			if(ClientConfig.auto_task_view || ClientConfig.auto_task_setting){
				return SettingModel.GetInstance().GetBlockProperty(SettingModel.SettingType.SysSetting, "auto_task")
			}
			else{
				return true
			}
		}

		//是否显示自动任务选择弹窗
		this.ShowTaskAutoAlert = (task_id?) => {
			let is_first = false
			return is_first
		}

		//完成伙伴唤醒任务
		this.FinishPartnerAwake = (task_id?) => {
			if (Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake && Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView && task_id &&
				(Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.root_task_id == task_id					//整个唤醒的主任务
					|| Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.task_list.main_task_id == task_id		//唤醒阶段任务
					|| Config_PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.TaskView.task_list2.main_task_id == task_id)) {	//唤醒阶段任务
				if (this.IsAllStepFinish(task_id)) {
					console.log("唤醒主任务，是否发30004////-：", task_id)
					this.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, task_id)
				}
			}
		}

		this.OpenHeartView = (dun_id?) => {
			let task_data = TaskModel.GetInstance().GetTaskData()
			for (let i = 0; i < task_data.length; i++) {
				let vo = task_data[i].data
				if (vo && vo.task_type == TaskType.EXTENSION_LINE && vo.task_tips_type == TaskTipType.FinDungeon) {
					if (!dun_id) {
						if (vo.id >= 31001 && vo.id <= 31007) {
							GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonHeartEnterView", vo)
							return true
						}
					} else {
						if (vo.id == dun_id) {
							GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonHeartEnterView", vo)
							return true
						}
					}

				}
			}

			return false
		}

		/**当前任务是否是激活指定妖物  任务类型89 */
		this.IsSpecialBrushTask = () => {
			let task_vo = this.GetMainLineTaskVo()
			if (!task_vo) return false
			return this.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap) && task_vo.id == 10002
		}

		/**锻造强化任务 */
		this.IsStrengeGuiderTask = () => {
			let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
			if (!task_vo) return
			let list = [101435, 101620, 101702, 101825]
			return list.indexOf(task_vo.task_id) != -1
		}

		/**支线任务引导配置
		 * task_id 支线任务id
		 * step 步数
		 */
		this.GetBranchTaskCfg = (task_id?, step?) => {
			if (!task_id) return null

			//判断是否有装备可捐赠
			if (task_id == TaskModel.GuildDonateTaskId) {
				let list = GuildModel.GetInstance().GetShowEquips()
				if (!list || list.length == 0) return null
			}

			if (!this.GetAllTaskList()) {
				return null
			}
			let arr = this.GetAllTaskList(task_id)
			var task_vo
			if (arr) {
				for (let _tmpi in arr) {
					task_vo = arr[_tmpi]
					if (task_vo.task_id == task_id) {
						break
					}
				}
			}

			if (!task_vo) return null

			let arrow_cfg = null
			let cfg = Config_PRELOAD_CLIENT_CONFIG.ConfigTaskArrow
			if (cfg) {
				let now_cfg = cfg[task_vo.task_tips_type]
				if (now_cfg) {
					if (now_cfg.in_view) {
						let arr = now_cfg.in_view
						for (let i = 0; i < arr.length; i++) {
							arrow_cfg = now_cfg.in_view[i]
							if (arrow_cfg.step == step) {
								break;
							}
						}

					}
				}
			}
			return arrow_cfg
		}

		/**是否有该支线任务 */
		this.IsHasBranchTask = (task_id) => {
			let arr = this.GetAllTaskList(task_id)
			var task_vo
			if (arr) {
				for (let _tmpi in arr) {
					task_vo = arr[_tmpi]
					if (task_vo.task_id == task_id) {
						break
					}
				}
			}
			return task_vo == null ? false : true
		}

		this.GetConfigAc = (key)=>{
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_ac[key]
			let vo = Util.DeepCopy(cfg)
			return vo
		}

		this.ClearData = () =>{

		}
	}
}

window["TaskModel"] = TaskModel