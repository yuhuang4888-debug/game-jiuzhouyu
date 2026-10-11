import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, LoadLuaConfigAB, TransformLevel, Util } from "../util/Util"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "./GoodsModel"
import { TaskModel, TaskTipType } from "./TaskModel"
import { OpenFun } from "../common/OpenFun"
import { CookieWrapper } from "../common/CookieWrapper"
import { Scene } from "../scene/Scene"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { PoseState } from "../util/StateMachineManager"
import { FirstBloodModel } from "./FirstBloodModel"
import { VipModel } from "./VipModel"
import { DungeonDragonDefine } from "../dungeonDragon/DungeonDragonDefine"
import { BossModel } from "./BossModel"
import { table } from "../common/table"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { LoginModel } from "../login/LoginModel"
import { TeamEvent, TeamModel } from "./TeamModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class BaseDungeonModel extends EventDispatcher {
	TestData
	//协议
	public static SCMD_REQUEST = "BDunMl.SCMD_REQUEST"

	//副本通用
	public static UPDATE_DUNGEON_TYPE_VIEW = "BDunMl.UPDATE_DUNGEON_TYPE_VIEW"
	public static OPEN_DENGEON_RESULT_VIEW = "BDunMl.OPEN_DENGEON_RESULT_VIEW"
	public static UPDATE_DUNGEON_INFO = "BDunMl.UPDATE_DUNGEON_INFO"
	public static UPDATE_DUNGEON_END_TIME = "BDunMl.UPDATE_DUNGEON_END_TIME"
	public static NEXT_WAVE_TIME_INFO = "BDunMl.NEXT_WAVE_TIME_INFO"
	public static NOW_TIME_SCORE_STATE = "BDunMl.NOW_TIME_SCORE_STATE"
	public static DUNGON_ACTIVITY_UPDATE = "BDunMl.DUNGON_ACTIVITY_UPDATE"
	public static UPDATE_HELP_DATA = "BDunMl.UPDATE_HELP_DATA"
	public static UPDATE_MONSTER_NUM = "UPDATE_MONSTER_NUM"

	//材料副本
	public static UPDATE_DUNGEON_TIME = "BDunMl.UPDATE_DUNGEON_TIME"

	//经验副本
	public static UPDATE_EXP = "BDunMl.UPDATE_EXP"
	public static UPDATE_INSPRITE_INFO = "BDunMl.UPDATE_INSPRITE_INFO"
	public static EXP_GUIDE_STATE_CHANGE = "BDunMl.EXP_GUIDE_STATE_CHANGE"
	public static SHOW_MESSAGE_INSPRITE = "SHOW_MESSAGE_INSPRITE"
	public static SHOW_EXP_DETAIL = "SHOW_EXP_DETAIL"
	public static TIMING_UPDATE_EXP = "TIMING_UPDATE_EXP" // 定时更新经验

	//爬塔副本
	public static UPDATE_EXTRA_REWARD_LIST = "BDunMl.UPDATE_EXTRA_REWARD_LIST"
	public static RECEVIED_EXTRA_REWARD = "BDunMl.RECEVIED_EXTRA_REWARD"

	//主线副本
	public static UPDATE_BRUSH_STRANGE_INFO = "BDunMl.UPDATE_BRUSH_STRANGE_INFO"
	public static UPDATE_BRUSH_STRANGE_STATE = "BDunMl.UPDATE_BRUSH_STRANGE_STATE"
	public static UPDATE_MAIN_LINE_LEVEL = "BDunMl.UPDATE_MAIN_LINE_LEVEL"
	public static UPDATE_MAIN_LINE_DONE_STATE = "BDunMl.UPDATE_MAIN_LINE_DONE_STATE"

	//神纹副本
	public static UPDATE_DRAGON_SKILL_COUNT = "BDunMl.UPDATE_DRAGON_SKILL_COUNT"
	public static UPDATE_DRAGON_REFRESH_DATA = "BDunMl.UPDATE_DRAGON_REFRESH_DATA"
	public static UPDATE_WAVE_REWARD_DATA = "BDunMl.UPDATE_WAVE_REWARD_DATA"
	public static UPDATE_BEST_RECORD = "BDunMl.UPDATE_BEST_RECORD"
	public static UPDATE_RED_STATE = "BDunMl.UPDATE_RED_STATE"
	public static SHOW_DRAGONE_WAVE_ITEM = "BunMl.SHOW_DRAGONE_WAVE_ITEM"
	public static UPDATE_DRAGON_JUMP_DATA = "BunMl.UPDATE_DRAGON_JUMP_DATA"

	//心魔副本
	public static UPDATE_HEART_SKILL_DATA = "BDunMl.UPDATE_HEART_SKILL_DATA"
	public static SKILL_OPEN_ICON_FLY = "BDunMl.SKILL_OPEN_ICON_FLY"

	//副本活动
	public static UPDATE_ACTIVITY = "BDunMl.UPDATE_ACTIVITY"

	//引导
	public static GUIDE_FIGHT_SUCCESS = "BDunMl.GUIDE_FIGHT_SUCCESS"

	//添加boss出现特效
	public static SHOW_BOSS_BRON = "SHOW_BOSS_BRON"

	//使魔副本
	public static PET_DUNGEON_ID_RETURN = "BunMl.PET_DUNGEON_ID_RETURN "
	public static PET_DUNGEON_SWEEP = "BunMl.PET_DUNGEON_SWEEP "
	public static PET_DUNGEON_SELECT_END = "BunMl.PET_DUNGEON_SELECT_END "
	public static PET_DUNGEON_SELECT_DELECT = "BunMl.PET_DUNGEON_SELECT_DELECT "
	public static PET_DUNGEON_SELECT_ADD = "BunMl.PET_DUNGEON_SELECT_ADD "

	//高级经验副本
	public static ADVANCEDEXP_PANEL_INFO = "ADVANCEDEXP_PANEL_INFO"
	public static ADVANCEDEXP_SET_INFO_RETURN = "ADVANCEDEXP_SET_INFO_RETURN"
	public static ADVANCEDEXP_SET_INFO_CHANGE = "ADVANCEDEXP_SET_INFO_CHANGE"
	public static ADVANCEDEXP_POP_VIEW = "ADVANCEDEXP_POP_VIEW"
	public static ADVANCEDEXP_CLOSE_POP_VIEW = "ADVANCEDEXP_CLOSE_POP_VIEW"

	public static UPDATE_MERGE_STAGE = "UPDATE_MERGE_STAGE"
	public static UPDATE_COIN_INSPRITE_STAGE = "UPDATE_COIN_INSPRITE_STAGE"
	public static UPDATE_DIAMOND_INSPRITE_STAGE = "UPDATE_DIAMOND_INSPRITE_STAGE"

	//周本
	public static POLAR_DATA_RETURN = "POLAR_DATA_RETURN"
	public static POLAR_RANK_DATA_RETURN = "POLAR_RANK_DATA_RETURN"
	public static POLAR_BALANCE_RETURN = "POLAR_BALANCE_RETURN"
	public static OPEN_POLAR_BALANCE = "OPEN_POLAR_BALANCE"
	public static POLAR_RELIVE_TIME = "POLAR_RELIVE_TIME"
	public static POLAR_BOSS_INFO_UPDATE = "POLAR_BOSS_INFO_UPDATE"
	public static POLAR_DEAD_TIME = "POLAR_DEAD_TIME"
	public static POLAR_PLAYER_DIE = "POLAR_PLAYER_DIE"
	public static CHANGE_POLAR_BOSS = "CHANGE_POLAR_BOSS"

	public static GET_RUNE_DUN_REWARD = "GET_RUNE_DUN_REWARD"
	public static CHANGE_RUNE_DUN_REWARD = "CHANGE_RUNE_DUN_REWARD"

	public static SHOW_TRIGGER_TIP = "BDunMl.SHOW_TRIGGER_TIP"

	public static SHOW_MOSTER_TIP = "BDunMl.SHOW_MOSTER_TIP"

	public static FIND_WAY = "BDunMl.FIND_WAY" //副本寻路

	public static UPDATE_RUNE_UNLOCK_FLOOR = "BDunMl.UPDATE_RUNE_UNLOCK_FLOOR"
	public static UPDATE_RUNE_DAILY_REWARD_STATE = "BDunMl.UPDATE_RUNE_DAILY_REWARD_STATE"


	//限时爬塔
	public static LIMIT_TIME_TOWER_UPDATE = "TOWER.LIMIT_TIME_TOWER_UPDATE"
	public static LIMIT_TIME_TOWER_ITEM_SELECT = "TOWER.LIMIT_TIME_TOWER_ITEM_SELECT"
	public static LIMIT_TIME_TOWER_ITEM_ROUND = "TOWER.LIMIT_TIME_TOWER_ITEM_ROUND"
	//限时爬塔图标
	public static TOWER_ICON_TYPE = "331@97"

	//新资源副本
	public static NEW_DUNGEON_UPDATE_NUM = "NEW_DUNGEON_UPDATE_NUM"  //次数更新
	public static NEW_DUNGEON_ONE_KEY = "NEW_DUNGEON_ONE_KEY"	//一键扫荡一键挑战

	//退出副本返回
	public static QUIT_DUNGEON_RETURN = "QUIT_DUNGEON_RETURN"

	/*
	一些设定
	*/
	public static MODULE_ID = 610
	//副本模块ID
	public static VIP_PARAMETER = 4000000
	//副本这边取VIP参数 key值要加这个数
	public static VIP_COUNT_PARAMETER = 1000000
	//副本这边取VIP数量参数 key值要加这个数
	public static Recommend_Power_Module = 1.05
	//推荐战斗力系数
	public static Show_Drop_Mon_Type = 6
	//显示副本结算的怪物类型 0.普通怪、1:普通野外怪、2:精英怪物、3:本服BOSS、4:跨服BOSS、5:活动BOSS、6:副本BOSS、7:任务BOSS

	//经验
	public static SWEEPING_GOODS_ID = 38040001
	//扫荡卷ID
	public static EXP_TICKET_ID = 38030001
	//经验副本门票ID
	public static EXP_WAVE_COUNT = 3
	//经验副本波束
	public static EXP_DUN_ID = 20001 //经验副本ID
	public static EXP_GUILD_LV = 200
	//经验副本引导等级限制(小于)
	public static GUILD_EXP_ID = 20002
	public static GUILD_TASK_ID = 101160
	//经验副本再来一次
	public static EXP_AGAIN_GOODS_ID = 38280001

	//符文
	public static Rune_Floor_Modulus = 12000
	public static Rune_Hole_Id = 38250002

	//材料副本模拟掉落配置
	public static Material_Drop_Cfg = {
		[2]: { wave_count: 1, drop: [[0, 31, 1]], count: 2 },
		[6]: { wave_count: 1, drop: [[0, 31, 1]], count: 10 },
		[18]: { wave_count: 3, drop: [[0, 16020001, 1]], count: 1 },
		[19]: { wave_count: 3, drop: [[0, 17020001, 1]], count: 1 },
		[22]: { wave_count: 3, drop: [[0, 18020001, 1]], count: 1 }
	}


	public static MORE_ACTIVITY = 12
	public static DOUBLE_ACTIVITY = 16

	//神纹副本
	public static DragonRedFlag = {
		DunTimes: 0x001,
		RewardState: 0x002
	}
	public static DragonRedALLFlag = BaseDungeonModel.DragonRedFlag.DunTimes + BaseDungeonModel.DragonRedFlag.RewardState

	//经验副本
	public static From_Enter_View = false

	//新资源副本
	/***0  日常 没有挑战次数*/
	public static TYPE_NORMAL = 0
	/***1  日常 有挑战次数*/
	public static TYPE_NORMAL_HAS_TIMES = 1
	/***2  新副本，（在界面将显示新副本的tips）*/
	public static TYPE_NEW_DUNGEON = 2
	/***3  新难度 有挑战次数（在界面将显示新难度的tips)*/
	public static TYPE_NEW_DIFF_SHOW = 3
	/***4  新难度，无挑战次数(在界面不会显示新难度的tips)*/
	public static TYPE_NEW_DIFF_HIDE = 4
	/***5  未解锁副本*/
	public static TYPE_NEW_INLOCK = 5


	//新资源副本组的类型
	public static GROUP_TYPE = 1

	public static Instance: BaseDungeonModel

	init_main_line_level = false
	mainline_dun_need_open = true
	mainline_dun_exit_time = 15
	total_count = 0
	unreal_level = 0
	material_auto_buy_state = false
	vip_person_view_status = false
	none_alert = false
	streng_item_click = false
	first_login_red = [true]
	_dungeonPetId = 0
	_dungeonPetRecordId = 0
	_dungeonPetSweep = false
	pet_dun_id = 33000
	pet_dun_count = 5
	DungeonPetDic = []
	DungeonPetSweepDic = []
	petSelectMax = 5
	pet_Monster_instance_id_list = []
	adExpSelAlert = false
	AdvancedExpMin = 34001
	AdvancedExpMax = 34004
	adExpNeedPop = false
	polarRankMax = 10
	relive_time = 0
	boss_info = []
	dead_time = 0
	dead_time_wait = 15
	show_inspite_msg = false
	extraReward = []
	role_pos_event_list = [] //保存坐标触发的事件  因为这个服务端处理不了 只能客户端来判断触发
	request_trigger_monster_time
	enter_dungeon_time //进入副本的时间
	kill_all_monster_time = null
	refresh_monster_info = []
	curr_wave_num = 1 //当前副本波数
	curr_wave_type = 0//当前副本波数类型
	exp_dun_info
	dun_cd_data
	dungeon_scene_msg
	select_pet_instance_id
	adExpPanelInfo
	polarBalance
	wait_load_find_way_fun
	copperGrade
	init_id_2_type_state
	copperLeve = "A"
	alert_view_time_id_ //经验副本二次确认弹窗处理


	InitConfig
	InitTurnRelation
	GetDunType
	SetDunBaseInfo
	SetDungeonInfo
	GetDungeonInfo
	SetDungeonResultInfo
	GetDungeonResultInfo: () => IDungeonResultInfo
	SetDungeonMonsterDeadPos
	GetDungeonMonsterDeadPos
	TryAddResultDrop
	GetNextUnlockRune
	GetDungeonHighestRecord
	SetExpDungeonInfo
	GetExpDungeonInfo
	SetDungeonCd
	GetDungeonCd
	SetInspireInfo
	GetInspireInfo
	DungeonOpenCondition
	activity_Config
	showTime
	showActivityTime
	dungeonActivity
	getTime
	closeDungeonActivity
	removeDungeonActivityTimer
	showEffect
	showDoubleEffect
	setCloseTimer
	onTimer
	checkDungeonNoNumber
	getPoint
	convertTime
	SetDungeonSceneMsg
	GetDungeonSceneMsg
	SetDungeonHelpData
	GetdDungeonHelpData
	RefreshVipPersonRed
	GetVipPersonRed
	RefreshMaterialRed
	GetMaterialRedState
	RefreshRuneRed
	GetDunReward
	RuneCanChallenge
	RuneChallenged
	RuneAllIsDone
	GetRuneChallengeData
	GetRuneCurFloor
	GetRuneMaxFloor
	GetRuneFirstTab
	GetRuneFirstTabIndex
	RefreshEquipRed
	GetEquipRedState
	SetDragonRewardState
	SetDragonTimeState
	RefreshDragonRedState
	HasDragonRedFlag
	GetDragonRedState
	RefreshSoulRed
	GetRuneRedState
	GetSoulRedState
	RefreshExpRed
	GetExpRedState
	IsShowDropDungeonType
	IsShowBornEffectDungeonType
	GetDunLeftTime
	SetDunFailureJumpData
	TryJumpFailureId
	GetDunIDbyGuildType
	GetRuneNowFloor
	SetDragonSkillData
	GetDragonSkillData
	SetDragonRefreshData
	GetDragonRefreshData
	SetDragonWaveRewardData
	GetWaveRewardData
	CheckRewardState
	IsDragonDunDone
	SetDragonJumpData
	GetDragonJumpData
	IsInDunTypeScene
	SetHeartSkillData
	GetHeartSkillData
	GetHeartSkillLv
	GetLearnSkillByTaskId
	IsHeartSkill
	exit
	setDungeonPetLayer
	checkSweepRedDot
	checkChallengeRedDot
	updatePetRed
	showLayerList
	setDungeonInfoDic
	setDungeonSweepDic
	addPetSelectDic
	delPetSelectDic
	PetSelectNum
	petSelectIndex
	petSelectInfo2
	petSelectList
	reSetPetSelectDic
	setPetMonster
	checkSelectPetMonster
	SetReddot
	CheckRedStatus
	selectRedDot
	checkPower
	checkPower2
	dungeonPetRedDot
	GetAdvancedExpInfo
	setAdExpInfo
	setAdExpInfo2
	setAdExpPopView
	setDunSetInfo
	DunSetInfo
	changeDunSetInfo
	RefreshAdExpRed
	dungeonAdExpRedDot
	getAdExpSceneObj
	addAdExpSceneObj
	removeAdExpSceneObj
	setPolarInfo
	getPolarInfo
	setPolarRank
	getPolarRank
	polarRankCfg
	getRewaedCfgList
	rewardHasGet
	polarbossList
	setPolarSpData
	PolarBossInfo
	setPolarBalance
	GetPolarSkillList
	check_inspite_msg
	showInspriteMsg
	IsLoadingDunType
	EnterSceneStart
	SetRuneReward
	GetRuneReward
	GetRuneRewardData
	RuneRewardRed
	RuneRewardOneKey
	SetMergeExpCount
	GetMergeExpCount
	SetRuneExtraReward
	ResetData
	GetDunInitState
	SetDunInitState
	CheckDunOpenState
	ResetDunInitState
	InitDragonReward
	SetRuneDailyRewardState
	SetRuneUnlockFloor
	GetRuneDailyRewardState
	GetRuneUnlockFloor



	//爬塔相关
	dungeon_tower_scmd
	ToGetTowerBigReward//领取限时爬塔本轮的大奖
	GetTowerInfoDatas
	CheckTowerIsPass
	GetTowerRewards
	GetTowerRewardState
	AddTowerIcon
	RefreshTowerRed
	CheckTowerRed
	GetTowerIds
	GetNextChallenge
	OpenLimitTowerView
	GetLimitTowerSkin
	GetLimitTowerIcon
	GetLimitTowerName
	RequestLimitTowerData
	cur_tower_round
	is_continue_show //是否让限时爬塔的图标在领取大奖后，保持本次登录显示



	//新资源副本
	//param
	dungeon_num_data_
	dungeon_red_state = {}
	dungeon_new_list

	//func
	RequestDungeonNum
	RequestDungeonChallenge
	SaveDungeonNumData
	ShowDungeonResult
	GetDungeonChallengeTimes
	IsNewMateriaDungeon
	GetDungeonTimesData
	GetCurDifficult
	GetAllDungeonChallengeTimes
	GetAllDungeonSweepTimes
	GetDungeonDifficultNum
	GetOneLowerDiffDun
	GetValByKey
	GetTextColor
	GetSweepCost
	GetAllCanSweepDunCost
	UpdateNewMatrialRed
	CheckNewMatrialRed
	InitNewMatrialRed
	IsNewDungeonOpen
	GetNewDungeonOpenTips
	GetNewDungeonOpenTaskId
	mat_new_list
	public constructor() {
		super()

		if (BaseDungeonModel.Instance) {
			return
		}
		BaseDungeonModel.Instance = this

		this.init_main_line_level = false
		this.total_count = 0
		this.unreal_level = 0
		this.material_auto_buy_state = false
		this.vip_person_view_status = false
		this.none_alert = false
		this.streng_item_click = false
		this.first_login_red = [true]
		this._dungeonPetId = 0
		this._dungeonPetRecordId = 0
		this._dungeonPetSweep = false
		this.pet_dun_id = 33000
		this.pet_dun_count = 5
		this.DungeonPetDic = []
		this.DungeonPetSweepDic = []
		this.petSelectMax = 5
		this.pet_Monster_instance_id_list = []
		this.adExpSelAlert = false
		this.AdvancedExpMin = 34001
		this.AdvancedExpMax = 34004
		this.adExpNeedPop = false
		this.polarRankMax = 10
		this.relive_time = 0
		this.boss_info = []
		this.dead_time = 0
		this.dead_time_wait = 15
		this.show_inspite_msg = false
		this.extraReward = []
		this.role_pos_event_list = [] //保存坐标触发的事件  因为这个服务端处理不了 只能客户端来判断触发
		this.request_trigger_monster_time = Status.NowTime
		this.enter_dungeon_time = Status.NowTime //进入副本的时间
		this.kill_all_monster_time = null
		this.refresh_monster_info = []
		this.curr_wave_num = 1 //当前副本波数
		this.curr_wave_type = 0//当前副本波数类型
		this.mat_new_list = [
			DUN_TYPE.NEW_MOUNT,
			DUN_TYPE.NEW_AMULET,
			DUN_TYPE.NEW_WEAPON,
			DUN_TYPE.Material_Copper,
			DUN_TYPE.NEW_WING,
			DUN_TYPE.Material_Mount,
			DUN_TYPE.NEW_BACK_ORNAMENT
		]

		//爬塔
		this.dungeon_tower_scmd = null
		this.cur_tower_round = 0
		this.is_continue_show = false





		let cfg_has_default_value = Config.ConfigHasDefaultValue,
			local_Config = Config,
			local_ErlangParser_Instance = ErlangParser.GetInstance(),
			local_DUN_TYPE = DUN_TYPE,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			local_Util = Util,
			local_CommonManager_Instance = CommonManager.GetInstance(),
			local_TimeUtil = TimeUtil,
			local_Date = Date,
			custom_activity_model = CustomActivityModel.GetInstance(),
			local_ActivityIconManager = ActivityIconManager,
			vip_model = VipModel.GetInstance(),
			role_mgr = RoleManager.GetInstance(),
			scene_mgr = SceneManager.GetInstance(),
			local_Erlang = ErlangParser.GetInstance(),
			local_Alert = Alert,
			local_Alert_Type = Alert_Type,
			red_dot_mgr = RedDotManager.GetInstance(),
			inspite_msg = null,
			config_ = [],
			dungeon_info_list_ = [],
			dungeon_result_info_: IDungeonResultInfo = null,
			dungeon_help_times_ = null,
			main_line_rank_info_ = null,
			main_line_level_ = 0,
			main_line_max_level_ = null,
			main_line_open_auto_level_ = null,
			inspire_info_ = null,
			material_red_state_ = false,
			rune_red_state_ = false,
			person_red_state_ = false,
			vip_person_red_state_ = false,
			exp_red_state_ = false,
			soul_red_state_ = false,
			equip_red_state_ = false,
			dragon_red_flag_ = 0,
			wave_reward_list_ = null,
			advancedExpRed_ = false,
			heart_skill_data_ = null,
			task_to_dungeon_ = null,
			rune_cur_floor_ = null,
			_petSelectDic_ = [],
			adExpSceneObj_ = [],
			canUseAdExpSceneObj_ = [],
			polarInfo_ = [],
			polarRank_ = [],
			boss_info_ = [],
			next_time_ = 8,
			closeTimer_ = null,
			_dun_id_2_dun_type_dic_ = [],
			dungeon_monster_dead_pos_ = null,
			_more_Config_ = null,
			_double_Config_ = null,
			_dungeonActivity_ = [],
			_openActivity_ = [],
			binEvent_ = false,
			failure_jump_id_ = null,
			drageon_skill_data_ = null,
			drageon_refresh_data_ = null,
			dragon_jump_data_ = null,
			DunTypeSetList_ = [DUN_TYPE.AdvancedExp],
			DunIdSetInfo_ = [],
			DunTypeSetInfo_ = [],
			merge_exp_count = false,
			dun_init_state,
			rune_daily_reward_state,
			rune_unlock_floor,
			material_type = [18, 2, 42, 43, 44, 45, 46],
			rune_unlock_floor_state

		this.ResetData = () => {
			this.InitNewMatrialRed()
			this.ResetDunInitState()
		}

		this.GetDunInitState = (dun_type) => {
			if (dun_init_state == null) {
				dun_init_state = {}
			}
			return dun_init_state[dun_type]
		}

		this.SetDunInitState = (dun_type) => {
			let state = this.GetDunInitState(dun_type)
			if (!state) {
				let check_func_name = ""
				switch (dun_type) {
					case DUN_TYPE.Rune:
						check_func_name = "DungeonRuneEnterView"
						break
					case DUN_TYPE.Material_Copper:
					case DUN_TYPE.Material_Mount:
					case local_DUN_TYPE.NEW_AMULET:
					case local_DUN_TYPE.NEW_MOUNT:
					case local_DUN_TYPE.NEW_WEAPON:
					case local_DUN_TYPE.NEW_WING:
					case local_DUN_TYPE.NEW_BACK_ORNAMENT:
						check_func_name = "DungeonMaterialNewEnterView"
						break
					case DUN_TYPE.Exp:
						check_func_name = "DungeonExpEnterView"
						break
					case DUN_TYPE.SingleRank:
						check_func_name = "kfSRMainView"
						break
				}
				state = CommonManager.GetInstance().CheckFuncOpenState(check_func_name, true)
				dun_init_state[dun_type] = state
			}

			return state
		}

		this.ResetDunInitState = () => {
			dun_init_state = null
		}

		this.CheckDunOpenState = (dun_type) => {
			let state = false
			let check_func_name
			switch (dun_type) {
				case DUN_TYPE.Rune:
					check_func_name = "DungeonRuneEnterView"
					break
				case DUN_TYPE.Material_Copper:
				case local_DUN_TYPE.NEW_AMULET:
				case local_DUN_TYPE.NEW_MOUNT:
				case local_DUN_TYPE.NEW_WEAPON:
				case local_DUN_TYPE.NEW_WING:
				case DUN_TYPE.NEW_BACK_ORNAMENT:
				case DUN_TYPE.Material_Mount:
					check_func_name = "DungeonMaterialNewEnterView"
					break
				case DUN_TYPE.Exp:
					check_func_name = "DungeonExpEnterView"
					break
				case DUN_TYPE.Equip:
					check_func_name = "DungeonEquipEnterView"
					break
				case DUN_TYPE.Dragon:
					check_func_name = "DungeonDragonEnterView"
					break
				case DUN_TYPE.SingleRank:
					check_func_name = "kfSRMainView"
					break
				case DUN_TYPE.Heart:
					check_func_name = "DungeonHeartEnterView"
					break
				case DUN_TYPE.Vip_Rerson_Boss:
					check_func_name = "BossPersonalEnterView"
					break
				case DUN_TYPE.SentientAct:
					check_func_name = "SentientActMainView"
					break
			}
			if (check_func_name) {
				state = CommonManager.GetInstance().CheckFuncOpenState(check_func_name, true)
			}
			return state
		}

		this.InitTurnRelation = (cfg?) => {
			if (cfg && !this.init_id_2_type_state) {
				if (!_dun_id_2_dun_type_dic_) {
					_dun_id_2_dun_type_dic_ = []
				}
				for (let dun_id in cfg) {
					let dun_cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
					_dun_id_2_dun_type_dic_[dun_id] = dun_cfg.type
				}
				this.init_id_2_type_state = true
			}
		}

		this.GetDunType = (dun_id?) => {
			return _dun_id_2_dun_type_dic_ && _dun_id_2_dun_type_dic_[dun_id]
		}

		this.SetDunBaseInfo = (data?, dungeon_cfg?, dungeon_ui_cfg?) => {
			if (!data || !data.dun_id) {
				return
			}
			let dun_id = data.dun_id
			let cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, dungeon_cfg)
			if (cfg) {
				data.name = cfg.name
				data.level = 0
				data.turn = 0
				data.type = cfg.type
				data.recommend_power = Number(cfg.recommend_power)
				data.sweep_lv = cfg.sweep_lv
				data.reward = null
				let count_cond = cfg.count_cond
				if (count_cond) {
					let vo = ErlangParser.GetInstance().Parse(count_cond)[0]
					if (vo) {
						data.count_type = vo[0]
						data.count_cond = Number(vo[1])
					}
				}
				let condition = cfg.condition
				if (condition) {
					let cond = local_ErlangParser_Instance.Parse(condition)
					for (let _tmpi in cond) {
						var v = cond[_tmpi]
						if (v[0] == "lv") {
							data.level = v[1]
						}
						if (v[0] == "turn") {
							data.turn = v[1]
						}
						if (v[0] == "vip_lv") {
							data.vip_lv = v[1]
						}
						if (v[0] == "vip_type") {
							data.vip_type = v[1]
						}
						if (v[0] == "finish_dun_id") {
							data.finish_dun_id = v[1]
						}
						if (v[0] == "vip_lv_auto_buy") {
							data.vip_lv_auto_buy = v[1]
						}
					}
				}
			}

			cfg = dungeon_ui_cfg && Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, dun_id, false, dungeon_ui_cfg)
			if (cfg) {
				data.reward = cfg.rewards
				data.desc = cfg.desc1
			}
		}

		this.SetDungeonInfo = (type?, vo?) => {
			dungeon_info_list_[type] = vo
		}

		this.GetDungeonInfo = (type?) => {
			return dungeon_info_list_[type]
		}

		this.SetDungeonResultInfo = (scmd?) => {
			if (scmd && scmd.dun_type && scmd.dun_type == DUN_TYPE.New_Main_Line) {
				let reward = []
				let len = scmd.reward_list.length
				for (let i = len - 1; i >= 0; i--) {
					reward.push(scmd.reward_list[i])
				}
				scmd.reward_list = reward
			}


			//更新新资源副本评分
			if (scmd && scmd.dun_type && scmd.result == 1 && this.IsNewMateriaDungeon(scmd.dun_type)) {
				let dun_datas = this.GetDungeonInfo(scmd.dun_type)
				for (let i = 0; i < dun_datas.length; i++) {
					let dun_data = dun_datas[i]
					if (!dun_data) continue
					if (dun_data.dun_id != scmd.dun_id) continue
					dun_data.is_sweep = scmd.is_sweep
					let list = dun_data.rec_data

					let is_set = false
					for (let i = 0; i < list.length; i++) {
						let obj = list[i]
						if (obj.key == 2) {
							obj.val = scmd.grade
							is_set = true
							break
						}
					}

					if (!is_set) {
						dun_data.rec_data.push({ key: 2, val: scmd.grade })
					}
				}
			}

			dungeon_result_info_ = scmd
		}

		//寻装觅刃测试数据
		// this.TestData = () => {
		// 	let obj
		// 	obj =
		// 	{
		// 		count: 1,
		// 		dun_id: 5005,
		// 		dun_type: 5,
		// 		ex_data: [
		// 			{
		// 				key: 9,
		// 				val: 0
		// 			}
		// 		],
		// 		grade: 3,
		// 		other_reward: [],
		// 		result: 1,
		// 		result_subtype: 0,
		// 		result_type: 0,
		// 		reward_list: [
		// 		],
		// 		scene_id: 5001
		// 	}


		// 	let rewa
		// 	rewa={
		// 		reward_type: 0,
		// 		size: 85,
		// 		vo:
		// 		{
		// 			count: 5,
		// 			goods_id: 0,
		// 			style: 0,
		// 			typeId: 37010055
		// 		}
		// 	}

		// 	for(let i=0;i<9;i++){
		// 		obj.reward_list.push(rewa)
		// 	}
		// 	return obj
		// }
		// let tesd

		this.GetDungeonResultInfo = () => {
			return dungeon_result_info_
			//test扫荡
			// let sweep_list = {other_reward = [], reward_list = [{goods_id : 0, count : 600000, style : 3, typeId : 0}, {goods_id : 0, count : 120000, style : 5, typeId : 0}]}
			// let reward_list = {
			// 	{
			// 		goods_id = 0,
			// 		typeId = 0,
			// 		reward_type = 0,
			// 		count = 600000,
			// 		style = 3,
			// 	},
			// 	{
			// 		goods_id = 0,
			// 		typeId = 0,
			// 		reward_type = 0,
			// 		count = 120000,
			// 		style = 5,
			// 	}
			// }
			// let info = {dun_id = 2001, _iid = 921, grade = 3, left_count = 2, use_delete_method = false,
			// 	result_type = 1, sweep_list = sweep_list, dun_type = 2, result = 1, error_code = 1, reward_list = reward_list
			// }
			// return info
			//test金币本结算
			// let info = {
			// 	dun_id = 2001,
			// 	_iid = 1273,
			// 	result_type = 0,
			// 	scene_id = 2003,
			// 	use_delete_method = false,
			// 	dun_type = 2,
			// 	other_reward = [],
			// 	result = 1,
			// 	grade = 3,
			// 	count = 1,
			// 	result_subtype = 0,
			// }
			// let ex_data = [{key : 0, val : 0}]
			// info.ex_data = ex_data
			// let reward_list = {
			// 	{
			// 		goods_id = 0,
			// 		typeId = 0,
			// 		reward_type = 0,
			// 		count = 120000,
			// 		style = 5,
			// 	},
			// 	{
			// 		goods_id = 0,
			// 		typeId = 0,
			// 		reward_type = 0,
			// 		count = 600000,
			// 		style = 3,
			// 	},
			// }
			// for (let i = 1; i <= 40; i++){
			// 	table.insert(reward_list, {
			// 		goods_id = 0,
			// 		typeId = 0,
			// 		reward_type = 0,
			// 		count = 600000,
			// 		style = 3,
			// 	})
			// }
			// info.reward_list = reward_list
			// return info
		}

		this.SetDungeonMonsterDeadPos = (pos?) => {
			dungeon_monster_dead_pos_ = pos
			this.TryAddResultDrop()
		}

		this.GetDungeonMonsterDeadPos = () => {
			return dungeon_monster_dead_pos_
		}

		this.TryAddResultDrop = () => {
			let pos = this.GetDungeonMonsterDeadPos()
			let data = this.GetDungeonResultInfo()
			let open_result_func = () => {
				if (data.dun_type == local_DUN_TYPE.New_Main_Line && !this.mainline_dun_need_open) {
					return
				} else {
					this.Fire(BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
				}
			}

			if (data &&
				(((!this.IsShowDropDungeonType(data.dun_type) || data.result == 0) || data.result == 2) ||
					data.result_type == DungeonResultType.Sweeping)
			) {
				open_result_func()
			} else if (((data && this.IsShowDropDungeonType(data.dun_type)) && data.result == 1) && pos) {
				let reward_list = []

				switch (data.dun_type) {
					case local_DUN_TYPE.New_Main_Line:
						this.mainline_dun_need_open = true
						this.mainline_dun_exit_time = 15
						let random_coin_count = Util.RandomRange(5, 8)
						for (let j in data.reward_list) {
							let item = data.reward_list[j]
							let vo = item["vo"]
							if (vo && vo.style == 0) {
								reward_list.push({ style: 0, typeId: vo.typeId, count: vo.count, show_type: 0 })
								this.mainline_dun_need_open = false
								this.mainline_dun_exit_time = 10
							}
						}
						let i = reward_list.length
						do {
							reward_list.push({ style: 3, typeId: 0, count: 1 })
							reward_list.push({ style: 2, typeId: 0, count: 1 })
							i = i + 1
						} while ((i < random_coin_count))
						break;
					case local_DUN_TYPE.ReincarnationDun:
						for (let i = 1; i <= 10; i++) {
							reward_list.push({ style: 3, typeId: 0, count: 1 })
						}
						for (let i = 1; i <= 4; i++) {
							reward_list.push({ style: 2, typeId: 0, count: 1 })
						}
						break;
					case local_DUN_TYPE.Material_Copper:
						for (let i = 1; i <= 4; i++) {
							for (let _ = 0; _ < data.reward_list.length; _++) {
								var v = data.reward_list[_]
								reward_list.push(Util.DeepCopy(v))
							}
						}
						break;
					default:
						reward_list = data.reward_list
						break
				}

				Util.ShowDrop(reward_list, pos, open_result_func)
			}
		}

		this.GetNextUnlockRune = (dungeon_rune_lv_data?) => {
			let unlock_floor = this.GetRuneUnlockFloor()
			if (unlock_floor == null) {
				return [null, null]
			}
			let list = []
			for (let key in dungeon_rune_lv_data) {
				let vo = dungeon_rune_lv_data[key]
				list.push(vo)
			}
			list.sort((a, b) => {
				return a.lv - b.lv
			})
			let next_floor = 0
			let cfg_data = null
			for (let _tmpi in list) {
				var v = list[_tmpi]
				if (Number(v.lv) > unlock_floor && Number(v.unlock_rune) != 0) {
					next_floor = Number(v.lv)
					cfg_data = v
					break
				}
			}
			return [next_floor, cfg_data]
		}

		this.GetDungeonHighestRecord = (dun_type?) => {

			let dungeon_list = dungeon_info_list_[dun_type]
			let record = 0
			if (dungeon_list) {
				for (let _tmpi in dungeon_list) {
					var vo = dungeon_list[_tmpi]
					if (vo.permanent_count > 0) {
						record = record + 1
					}
				}
			}
			return record
			// return 4
		}

		this.SetExpDungeonInfo = (scmd?) => {
			this.ChangeVar("exp_dun_info", scmd)
		}

		this.GetExpDungeonInfo = () => {
			return this.exp_dun_info
		}

		this.SetDungeonCd = (scmd?) => {
			if (!this.dun_cd_data) {
				this.dun_cd_data = {}
			}

			this.dun_cd_data[scmd.dun_id] = scmd.next_time
			this.ChangeVar("dun_cd_data", this.dun_cd_data, false, true)
		}

		this.GetDungeonCd = (dun_id?) => {
			return this.dun_cd_data && this.dun_cd_data[dun_id]
		}

		this.SetInspireInfo = (inspire_info?) => {
			inspire_info_ = inspire_info
		}

		this.GetInspireInfo = () => {
			return inspire_info_
		}

		this.DungeonOpenCondition = (dun_type?) => {
			let class_name = ""

			switch (dun_type) {
				case DUN_TYPE.Material_Mount:
					class_name = "MountDungeon"
					break;
				case DUN_TYPE.Material_WING:
					class_name = "WingDungeon"
					break;
				case DUN_TYPE.Material_Partner:
					class_name = "PartnerDungeon"
					break;
				case DUN_TYPE.Material_Copper:
					class_name = "CopperDungeon"
					break;
				case DUN_TYPE.NEW_WING:
					class_name = "WingsComponentView"
					break;
				case DUN_TYPE.NEW_AMULET:
					class_name = "ArtifactComponentView"
					break;
				case DUN_TYPE.NEW_MOUNT:
					class_name = "HorseComponentView"
					break;
				case DUN_TYPE.NEW_WEAPON:
					class_name = "HolyDeviceComponentView"
					break;
				//背饰副本是要在背饰系统开启之前开启
				// case DUN_TYPE.NEW_BACK_ORNAMENT:
				// 	class_name = "BackOrnamentComponentView"
				// 	break;
			}

			let func_is_open = local_CommonManager_Instance.CheckFuncOpenState(class_name, true)
			return func_is_open
		}

		this.activity_Config = (type?, show_id?, dungeon_time_cfg?) => {
			let Config = null
			if (type == BaseDungeonModel.MORE_ACTIVITY) {
				if (!_more_Config_) {

					let obj = dungeon_time_cfg[BaseDungeonModel.MORE_ACTIVITY + "_" + show_id]
					_more_Config_ = obj
				}
				Config = _more_Config_
			} else {
				if (!_double_Config_) {

					let obj = dungeon_time_cfg[BaseDungeonModel.DOUBLE_ACTIVITY + "_" + show_id]
					_double_Config_ = obj
				}
				Config = _double_Config_
			}
			return Config
		}

		this.showTime = (week_list?, time_list?) => {
			let time = 0
			let serverTime = local_TimeUtil.timeHMS(local_TimeUtil.getServerTime() * 1000)
			let startime = null
			let endTime = null
			let timeState = 0
			for (let key in time_list) {


				let timeObj = time_list[key]
				startime = timeObj[0][0] * 60 * 60 + timeObj[0][1] * 60
				endTime = timeObj[1][0] * 60 * 60 + timeObj[1][1] * 60
				if (serverTime < startime) {
					time = startime - serverTime
					timeState = 0
					break
				} else if (serverTime >= startime && serverTime < endTime) {
					time = endTime - serverTime
					timeState = 1
					break
				} else {
					time = 24 * 60 * 60 - serverTime + startime
					timeState = 2
				}
			}
			let mydate = new local_Date(local_TimeUtil.getServerTime() * 1000)
			let myday = mydate.getDay()

			myday = (myday == 0 && (7) || (myday))
			let index = week_list.find(myday.toString())
			let fullDay = index != -1
			if (fullDay) {
				if (timeState == 2) {

					let i = (index + 1 > week_list.length - 1 && (0) || (index + 1))
					let nextDay = Number(week_list[i])

					let day = (nextDay - myday < 0 && (nextDay + 7 - myday) || (nextDay - myday))
					day = day - 1
					time = time + 24 * 60 * 60 * day
				}
			} else {
				if (timeState == 1) {
					time = 24 * 60 * 60 - serverTime + startime
					timeState = 0
				} else {
					let day = null
					let count = 0
					for (let _tmpi in week_list) {
						var week = week_list[_tmpi]
						if (myday < week) {
							day = week - myday
							break
						}
						count = count + 1
					}
					if (count == week_list.length) {
						day = 7 - myday + Number(week_list[0]) - 1
					}
					time = time + 24 * 60 * 60 * day
				}
			}
			// return {time, timeState}
			return [time, timeState]
		}

		this.showActivityTime = (activity?) => {
			let time = 0
			let timeState = 0
			if (activity && activity.condition) {
				let obj = local_ErlangParser_Instance.Parse(activity.condition)
				let serverTime = local_TimeUtil.timeHMS(local_TimeUtil.getServerTime() * 1000)
				let timeObj = obj[1][1]
				let startime =
					Number(timeObj[0][0]) * 60 * 60 + Number(timeObj[0][1]) * 60 +
					Number(timeObj[0][2])
				let endTime =
					Number(timeObj[1][0]) * 60 * 60 + Number(timeObj[1][1]) * 60 +
					Number(timeObj[1][2])
				if (serverTime < startime) {
					time = startime - serverTime
					timeState = 0
				} else if (serverTime >= startime && serverTime < endTime) {
					time = endTime - serverTime
					timeState = 1
				} else {
					time = 24 * 60 * 60 - serverTime + startime
					timeState = 2
				}
			}
			// return {time, timeState}
			return [time, timeState]
		}

		this.dungeonActivity = (base_type?, sub_type?) => {
			let key = base_type + "_" + sub_type
			let canOpen = false

			if (!_openActivity_[key]) {
				let obj = []

				obj["base_type"] = base_type

				obj["sub_type"] = sub_type
				let activity = CustomActivityModel.GetInstance().GetActInfo(base_type, sub_type)
				if (activity && activity.condition) {
					let [openTime, endTime] = this.getTime(activity)

					obj["openTime"] = openTime

					obj["endTime"] = endTime

					obj["etime"] = activity.etime

					obj["condition"] = activity.condition

					_openActivity_[key] = obj
					this.setCloseTimer()
					let serverTime = local_TimeUtil.timeHMS(local_TimeUtil.getServerTime() * 1000)
					canOpen = serverTime >= openTime && serverTime < endTime
					this.Fire(BaseDungeonModel.DUNGON_ACTIVITY_UPDATE, base_type)
				}
			}

			let last = _dungeonActivity_[key]
			if (!last && canOpen) {

				_dungeonActivity_[key] = true
				local_GlobalEventSystem.Fire(
					local_ActivityIconManager.UPDATE_EFFECT,
					610,
					"ui_activity",
					true,
					false,
					{ x: 30, y: -30 }
				)
				this.Fire(BaseDungeonModel.UPDATE_ACTIVITY, base_type, sub_type)
			}
		}


		this.getTime = (activity?) => {
			let endTime = 0
			let openTime = 0
			let obj = local_ErlangParser_Instance.Parse(activity.condition)
			let serverTime = local_TimeUtil.timeHMS(local_TimeUtil.getServerTime() * 1000)
			let timeObj = null
			for (let key in obj) {


				let info = obj[key]
				if (info[0] == "time") {
					timeObj = info[1]
					break
				}
			}
			endTime =
				Number(timeObj[1][0]) * 60 * 60 + Number(timeObj[1][1]) * 60 +
				Number(timeObj[1][2])
			openTime =
				Number(timeObj[0][0]) * 60 * 60 + Number(timeObj[0][1]) * 60 +
				Number(timeObj[0][1])
			// return {openTime, endTime}
			return [openTime, endTime]
		}

		this.closeDungeonActivity = (base_type?, sub_type?) => {
			let key = base_type + "_" + sub_type

			let last = _dungeonActivity_[key]

			_dungeonActivity_[key] = false
			if (last) {
				this.Fire(BaseDungeonModel.UPDATE_ACTIVITY, base_type, sub_type)
				let send = true
				for (let key in _dungeonActivity_) {


					let state = _dungeonActivity_[key]
					if (state) {
						send = false
						break
					}
				}
				if (send) {
					local_GlobalEventSystem.Fire(local_ActivityIconManager.UPDATE_EFFECT, 610, "ui_activity", false, false)
					this.Fire(BaseDungeonModel.UPDATE_ACTIVITY, base_type, sub_type)
					let serverTime = local_TimeUtil.getServerTime()
					let etime = 0
					let close = true
					for (let key in _openActivity_) {


						let activity = _openActivity_[key]
						etime = activity.etime
						if (serverTime < etime) {
							close = false
							break
						}
					}
					if (close) {
						this.removeDungeonActivityTimer()
					}
				}
			}
		}


		this.removeDungeonActivityTimer = () => {
			if (closeTimer_) {
				GlobalTimerQuest.CancelQuest(closeTimer_)
				closeTimer_ = null
			}
			for (let key in _openActivity_) {


				let obj = _openActivity_[key]
				if (obj) {
					local_GlobalEventSystem.Fire(local_ActivityIconManager.UPDATE_EFFECT, 610, "ui_activity", false, false)
					this.Fire(
						BaseDungeonModel.UPDATE_ACTIVITY,
						obj.base_type,
						obj.sub_type
					)
				}
			}
			_openActivity_ = []
			_dungeonActivity_ = []
		}


		this.showEffect = (base_type?) => {
			let flag = false
			for (let key in _openActivity_) {


				let activity = _openActivity_[key]
				if (activity.base_type == base_type && !this.checkDungeonNoNumber(activity.condition)) {
					flag = true
					break
				}
			}
			return flag
		}


		this.showDoubleEffect = (base_type?) => {
			let metiral_flag = false
			let partner_flag = false
			for (let key in _openActivity_) {


				let activity = _openActivity_[key]
				let condition = activity.condition
				if (activity && activity.etime && activity.etime <= TimeUtil.getServerTime()) { break }
				if (activity.base_type == base_type && !this.checkDungeonNoNumber(condition)) {
					let list = ErlangParser.GetInstance().Parse(condition)[0]
					if (list[0] == "types") {
						for (let key in list[1]) {


							let info = list[1][key]
							if (37 == Number(info[0])) {
								partner_flag = true
							} else if (material_type.indexOf(Number(info[0])) != -1) {
								metiral_flag = true
							}
						}
					}
					break
				}
			}
			return [metiral_flag, partner_flag]
		}


		this.setCloseTimer = () => {


			closeTimer_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.onTimer()
			}, 1)
			this.onTimer()

		}



		this.onTimer = () => {
			let serverTime = local_TimeUtil.timeHMS(local_TimeUtil.getServerTime() * 1000)
			for (let key in _openActivity_) {


				let obj = _openActivity_[key]
				if (!obj) {
					this.removeDungeonActivityTimer()
				} else {

					if ((serverTime >= obj.endTime || serverTime < obj.openTime) ||
						_dungeonActivity_[key] && this.checkDungeonNoNumber(obj.condition)
					) {
						this.closeDungeonActivity(obj.base_type, obj.sub_type)
					} else if (serverTime >= obj.openTime && serverTime < obj.endTime) {
						this.dungeonActivity(obj.base_type, obj.sub_type)
					}
				}
			}
		}



		this.checkDungeonNoNumber = (condition?) => {
			let list = local_ErlangParser_Instance.Parse(condition)

			list = (list[0] && list[0][1] && (list[0] && list[0][1]) || ({}))
			let count = 0
			let num = 0
			for (let key in list) {


				let dun_info = list[key]
				let dun_type = Number(dun_info[0])
				let vip_card = vip_model.GetNobleCardState()
				let vip_flag = role_mgr.GetMainRoleVo().vip_flag
				if (vip_flag >= 1) {
					vip_card = 99
				}
				let vip_default_count =
					vip_model.GetVipPrivilegeValue(
						BaseDungeonModel.MODULE_ID,
						BaseDungeonModel.VIP_COUNT_PARAMETER + dun_type,
						vip_card,
						vip_flag
					)
				let data = this.GetDungeonInfo(dun_type)
				if (data) {
					data = data[0]
					let daily_default_count = Number(data.count_cond) + vip_default_count
					let total_count = data.add_count + data.vip_count + daily_default_count
					let left_times = total_count - data.daily_count
					if (left_times <= 0) {
						count = count + 1
					}
				}
				num = num + 1
			}
			return count >= num
		}


		this.getPoint = (dun_type?) => {
			let point = 0


			//定制活动12的  优先度最高
			for (let key in _openActivity_) {
				let activity = _openActivity_[key]
				if (activity) {
					let list = local_ErlangParser_Instance.Parse(activity.condition)[0]
					if (list[0] == "types") {
						for (let key in list[1]) {


							let info = list[1][key]
							if (dun_type == Number(info[0])) {
								if (dun_type == local_DUN_TYPE.Exp) {
									point = 1 + Number(info[1]) / 10000
								} else {
									point = Number(info[1])
								}
								break
							}
						}
					}
				}
			}

			//周中庆典的倍数加成
			if (point == 0) {
				if (dun_type == local_DUN_TYPE.Exp) {
					let exp = custom_activity_model.GetActivenessStatus("331@56" + DungeonEnterViewIndex.Exp)
					if (exp) point = 2
				} else if (this.IsNewMateriaDungeon(dun_type)) {
					//先检查双倍
					let material = custom_activity_model.GetActivenessStatus("331@56" + DungeonEnterViewIndex.Material)
					if (!material) {
						//双倍没有开 检查1.15倍
						material = custom_activity_model.GetActivenessStatus(CustomActivityModel.MATIAL_ICON_115)
						if (material) {
							point = 1.15
						}
					} else {
						point = 2
					}
				}
			}
			return point
		}

		this.convertTime = (times?) => {
			let D = Math.floor(times / 60 / 60 / 24)
			let h = Math.floor(times / 60 / 60) % 24
			let m = Math.floor(times / 60) % 60
			let s = times % 60
			if (D > 0) {
				return D + "天" + h + "时" + m + "分"
			} else {
				if (h > 0) {
					return h + "时" + m + "分" + s + "秒"
				}
				if (m > 0) {
					return m + "分" + s + "秒"
				}
				if (s > 0) {
					return s + "秒"
				}
			}
		}

		this.SetDungeonSceneMsg = (data?) => {

			this.ChangeVar("dungeon_scene_msg", data)
		}

		this.GetDungeonSceneMsg = () => {
			return this.dungeon_scene_msg
		}

		this.SetDungeonHelpData = (scmd?) => {
			if (!dungeon_help_times_) {
				dungeon_help_times_ = []
			}

			dungeon_help_times_[scmd.dun_id] = scmd
			this.Fire(BaseDungeonModel.UPDATE_HELP_DATA, scmd.dun_id)
		}

		this.GetdDungeonHelpData = (dun_id?) => {

			return dungeon_help_times_ && dungeon_help_times_[dun_id]
		}

		this.RefreshVipPersonRed = () => {
			let open = local_CommonManager_Instance.CheckFuncOpenState("BossPersonalEnterView", true)
			if (open) {
				ResManager.GetInstance().LoadGameConfig(this,
					"config_dungeon", false, null, (cfg?) => {
						let bool = false
						let data = this.GetDungeonInfo(local_DUN_TYPE.Vip_Rerson_Boss)
						let dun_data = data && data[0]
						let dun_id = dun_data && dun_data.dun_id
						let dun_cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
						let vip_flag = role_mgr.GetMainRoleVo().vip_flag
						let lv = role_mgr.mainRoleInfo.level
						let lv_over = true
						if ((dun_data && dun_data.vip_lv) && Number(dun_data.vip_lv) > vip_flag) {
							lv_over = false
						}
						if (data) {
							for (let i in data) {
								let dun = data[i]
								if (lv >= Number(dun.level) && dun.rec_data) {
									for (let j in dun.rec_data) {
										let vo = dun.rec_data[j]
										if (vo.key == 10 && vo.val == 0) {
											bool = true
											break
										}
									}
								}
								if (bool) {
									break
								}
							}
						}
						if (!bool && ((dun_data && dun_cfg) && lv_over) && lv >= Number(dun_data.level)) {
							let vip_card = vip_model.GetNobleCardState()
							let subId = BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.Vip_Rerson_Boss)
							let num_type = vip_model.GetVipCfgNumType(BaseDungeonModel.MODULE_ID, subId)
							if (num_type == 2) {
								vip_card = 99
							}
							let vip_default_count = vip_model.GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, subId, vip_card, vip_flag)
							let daily_default_count = Number(dun_data.count_cond) + vip_default_count
							let total_count = dun_data.add_count + dun_data.vip_count + daily_default_count
							let remain_time = total_count - dun_data.daily_count
							let cost = local_ErlangParser_Instance.Parse(dun_cfg.cost)
							let type_id = null
							let cost_num = null
							for (let _tmpi in cost) {
								var v = cost[_tmpi]
								if (Number(v[0]) <= dun_data.daily_count + 1 && Number(v[1]) >= dun_data.daily_count + 1) {
									type_id = Number(v[2][0][1])
									cost_num = Number(v[2][0][2])
								}
							}
							let goods_num = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
							let vip_lv_auto_buy = Number(dun_data.vip_lv_auto_buy)
							if (vip_flag >= vip_lv_auto_buy && remain_time > 0) {
								bool = true
							} else if (this.vip_person_view_status) {
								bool = false
							} else {
								if (vip_flag >= vip_lv_auto_buy) {
									if (remain_time > 0 && cost_num <= goods_num) {
										bool = true
									}
								} else if (vip_flag < vip_lv_auto_buy) {
									if (remain_time > 0 && cost_num <= goods_num) {
										bool = true
									}
								}
							}
						}
						if (vip_person_red_state_ != bool) {
							vip_person_red_state_ = bool
							local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
								"BossEnterView", BossModel.Index.Vip_Person_Boss, bool)
							local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 4601)
							this.Fire(BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, local_DUN_TYPE.Vip_Rerson_Boss)
						}
						ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon", false)
					}
				)
			}
		}

		this.GetVipPersonRed = () => {
			return vip_person_red_state_
		}

		this.RefreshMaterialRed = () => {
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonMaterialNewEnterView", true)
			let bool = false
			if (open) {
				let dungeon_ui_tab_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_ui_tab
				if (!dungeon_ui_tab_cfg) {
					return
				}
				let material_type_dic = []
				for (let key in dungeon_ui_tab_cfg) {


					let v = dungeon_ui_tab_cfg[key]
					if (v.group == 1) {

						material_type_dic[v.dun_type] = true
					}
				}
				let role_lv = role_mgr.GetMainRoleVo().level
				let vip_card = vip_model.GetNobleCardState()
				let vip_flag = role_mgr.GetMainRoleVo().vip_flag
				if (vip_flag >= 1) {
					vip_card = 99
				}
				for (let dun_type in material_type_dic) {

					let data = this.GetDungeonInfo(dun_type)
					let class_name = null

					switch (Number(dun_type)) {
						case local_DUN_TYPE.Material_Mount:
							class_name = "MountDungeon"
							break;
						case local_DUN_TYPE.Material_Partner:
							class_name = "PartnerDungeon"
							break;
						case local_DUN_TYPE.Material_WING:
							class_name = "WingDungeon"
							break;
					}
					let func_bool = true
					if (class_name) {
						func_bool = local_CommonManager_Instance.CheckFuncOpenState(class_name, true)
					}
					if (((func_bool && data) && data[0]) && Number(data[0].level) <= role_lv) {
						for (let _tmpi in data) {
							var dun_data = data[_tmpi]
							let vip_default_count =
								vip_model.GetVipPrivilegeValue(
									BaseDungeonModel.MODULE_ID,
									BaseDungeonModel.VIP_COUNT_PARAMETER + Number(dun_type),
									vip_card,
									vip_flag
								)
							let daily_default_count = Number(dun_data.count_cond) + vip_default_count
							let total_count = dun_data.add_count + dun_data.vip_count + daily_default_count
							let left_times = total_count - dun_data.daily_count
							if (left_times > 0) {
								bool = true
								break
							}
						}
					}
				}
				if (material_red_state_ != bool) {
					material_red_state_ = bool
					local_GlobalEventSystem.Fire(
						local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
						"DungeonEnterView",
						DungeonEnterViewIndex.Material,
						bool
					)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
				}
			}
		}

		this.GetMaterialRedState = () => {
			return material_red_state_
		}

		this.RefreshRuneRed = () => {
			let bool = false
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonRuneEnterView", true)
			if (open) {

				//每日奖励
				let daily_reward_state = this.GetRuneDailyRewardState()
				if (daily_reward_state == 1) {
					bool = true
				}

				//解锁
				if (!bool) {
					let dun_list = this.GetDungeonInfo(DUN_TYPE.Rune)
					let unlock_floor = rune_unlock_floor
					//副本数据和解锁层级数据同时存在时才可判断
					if (dun_list && unlock_floor != null) {
						let [next_floor, cfg_data] = this.GetNextUnlockRune(Config.PRELOAD_SERVER_CONFIG.config_dungeon_rune_lv_data)
						if (next_floor) {
							let cur_floor = this.GetRuneCurFloor()
							if (cur_floor >= next_floor) {
								bool = true
							}
						}
					}
				}

				//首杀
				if (!bool) {
					bool = FirstBloodModel.GetInstance().RuneFirstRed()
				}

				//层数奖励
				if (!bool) {
					bool = this.RuneRewardRed()
				}

				//推荐战斗力
				// if (!bool) {
				let fighting = role_mgr.GetMainRoleVo().fighting
				let dun_list = this.GetDungeonInfo(local_DUN_TYPE.Rune)
				if (dun_list) {
					let next_floor_data = null
					for (let _tmpi in dun_list) {
						var vo = dun_list[_tmpi]
						//if (vo.permanent_count == 0 ) {
						let val = 0
						let findVal = false
						let needBreak = false
						do {
							for (let key in vo.rec_data) {
								var rec = vo.rec_data[key]
								if (rec.key == 5 || rec.key == "5") {
									val = rec.val
									findVal = true
									break
								}
							}
							if (!findVal) {
								break
							}
							if (val == 0) {
								next_floor_data = vo
								needBreak = true
								break
							}
						} while (false)
						if (needBreak) {
							break
						}
					}
					if (next_floor_data) {
						rune_cur_floor_ = next_floor_data.dun_id - BaseDungeonModel.Rune_Floor_Modulus - 1
					} else {
						rune_cur_floor_ = dun_list[dun_list.length - 1].dun_id - BaseDungeonModel.Rune_Floor_Modulus
					}
					if (next_floor_data && fighting > next_floor_data.recommend_power * BaseDungeonModel.Recommend_Power_Module) {
						bool = true
					}
				}

				// }
			}



			if (rune_red_state_ != bool) {
				rune_red_state_ = bool
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"DungeonEnterView",
					DungeonEnterViewIndex.Rune,
					bool
				)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
			}
			return bool
		}


		this.GetDunReward = (dun_type?, config_dun_reward?) => {
			let list = []
			if (config_dun_reward)
				for (let i in config_dun_reward) {
					var info = config_dun_reward[i]
					if (info.dun_type == dun_type) {
						list.push(info)
					}
				}
			return list
		}

		this.RuneCanChallenge = (floor?) => {
			let bool = false
			if (!this.RuneAllIsDone() && rune_cur_floor_ != null) {
				bool = floor - rune_cur_floor_ == 1
			}
			return bool
		}

		this.RuneChallenged = (floor?) => {
			return rune_cur_floor_ && floor <= rune_cur_floor_
		}


		this.RuneAllIsDone = () => {
			let dun_list = this.GetDungeonInfo(DUN_TYPE.Rune)
			if (rune_cur_floor_ != null && dun_list) {
				return rune_cur_floor_ == dun_list[dun_list.length - 1].dun_id - BaseDungeonModel.Rune_Floor_Modulus
			}
		}

		this.GetRuneChallengeData = () => {
			let dun_list = this.GetDungeonInfo(DUN_TYPE.Rune)
			if (rune_cur_floor_ != null && dun_list) {
				return dun_list[rune_cur_floor_]
			}
		}

		this.GetRuneCurFloor = () => {
			return rune_cur_floor_
		}

		this.GetRuneMaxFloor = () => {
			let dun_list = this.GetDungeonInfo(DUN_TYPE.Rune)
			return (dun_list && dun_list[dun_list.length - 1]) && dun_list[dun_list.length - 1].dun_id - BaseDungeonModel.Rune_Floor_Modulus
		}

		this.GetRuneFirstTab = (config_boss_first_blood_plus_boss) => {
			let cfg = config_boss_first_blood_plus_boss
			let list = []

			for (let key in cfg) {
				var info = cfg[key]
				if (info.type == 105 && info.sub_type == 1) {
					list.push(info)
				}
			}
			list.sort((a, b) => {
				let aIndex = a.object_id
				let bIndex = b.object_id
				let aGet = FirstBloodModel.GetInstance().GetRuneFirstHave(a.object_id)
				if (aGet) {
					aIndex = aIndex + 1000
				}
				let bGet = FirstBloodModel.GetInstance().GetRuneFirstHave(b.object_id)
				if (bGet) {
					bIndex = bIndex + 1000
				}
				return aIndex - bIndex
			})
			return list
		}

		this.GetRuneFirstTabIndex = (list?) => {
			let index = 0
			let find = false
			for (let i in list) {
				var cfg = list[i]
				let red = FirstBloodModel.GetInstance().GetRuneFirstRed(cfg.object_id)
				if (red) {
					find = true
					break
				}
				index = index + 1
			}
			if (!find)
				index = 0
			return index
		}

		this.RefreshEquipRed = () => {
			let bool = false
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonEquipEnterView", true)
			if (open) {
				let dun_list = this.GetDungeonInfo(local_DUN_TYPE.Equip)
				if (dun_list && dun_list.length > 0) {
					let cur_data = dun_list[0]
					let total_count = Number(cur_data.count_cond) + cur_data.add_count + cur_data.vip_count
					let left_times = total_count - cur_data.daily_count
					if (left_times > 0) {
						bool = true
					}
				}
			}
			if (equip_red_state_ != bool) {
				equip_red_state_ = bool
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"DungeonEnterView",
					DungeonEnterViewIndex.Equip,
					bool
				)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
			}
			return bool
		}

		this.GetEquipRedState = () => {
			return equip_red_state_
		}

		this.SetDragonRewardState = () => {
			let bool = false
			if (wave_reward_list_) {
				for (let dun_id in wave_reward_list_) {


					let data = wave_reward_list_[dun_id]
					if (data) {
						let list = data.list
						for (let _tmpi in list) {
							var vo = list[_tmpi]
							if (vo.state == 0) {
								bool = true
								break
							}
						}
					}
					if (bool) {
						break
					}
				}
			}
			this.RefreshDragonRedState(BaseDungeonModel.DragonRedFlag.RewardState, bool)
		}

		this.SetDragonTimeState = () => {
			let bool = false
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonDragonEnterView", true)
			if (open) {
				let dun_list = this.GetDungeonInfo(local_DUN_TYPE.Dragon)
				if (dun_list && dun_list.length > 0) {
					let cur_data = dun_list[0]
					let role_lv = role_mgr.GetMainRoleVo().level
					// let vip_card = vip_model.GetNobleCardState()
					// let vip_flag = role_mgr.GetMainRoleVo().vip_flag
					// if (vip_flag >= 1 ) {
					// 	vip_card = 99
					// }
					let vip_default_count = 0
					// vip_model.GetVipPrivilegeValue(
					// 	BaseDungeonModel.MODULE_ID,
					// 	BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.Dragon),
					// 	vip_card,
					// 	vip_flag
					// )
					let daily_default_count = Number(cur_data.count_cond) + vip_default_count
					let total_count = cur_data.add_count + cur_data.vip_count + daily_default_count
					let left_times = total_count - cur_data.daily_count
					if (left_times > 0) {
						bool = true
					}
				}
			}
			this.RefreshDragonRedState(BaseDungeonModel.DragonRedFlag.DunTimes, bool)
		}


		this.RefreshDragonRedState = (flag?, state?) => {
			if (!flag) {
				return
			}
			let now_flag = 0
			if (state) {
				now_flag = dragon_red_flag_ | flag
				// now_flag =  bit.bor(dragon_red_flag_, flag)
			} else {
				now_flag = dragon_red_flag_ & ~flag
				// now_flag = bit.band(dragon_red_flag_, bit.bnot(flag))
			}
			if (now_flag == dragon_red_flag_) {
				return
			}
			dragon_red_flag_ = now_flag
			this.Fire(BaseDungeonModel.UPDATE_RED_STATE, flag)
			local_GlobalEventSystem.Fire(
				local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"DungeonEnterView",
				DungeonEnterViewIndex.Dragon,
				this.GetDragonRedState()
			)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
		}


		this.HasDragonRedFlag = (flag?) => {
			if (!flag) {
				return false
			}
			// return (dragon_red_flag_ & flag) != 0
			return (dragon_red_flag_ & flag) != 0
		}

		this.GetDragonRedState = () => {
			return dragon_red_flag_ > 0
		}

		this.RefreshSoulRed = () => {
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonSoulEnterView", true)
			let bool = false
			if (open) {
				ResManager.GetInstance().LoadGameConfig(
					this,
					"config_dungeon",
					false,
					null,
					(cfgs?) => {
						let data = this.GetDungeonInfo(local_DUN_TYPE.Soul)
						let dun_data = data && data[0]
						let dun_id = dun_data && dun_data.dun_id
						let dun_cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfgs)
						let vip_flag = role_mgr.GetMainRoleVo().vip_flag
						if ((dun_data && dun_cfg) && role_mgr.mainRoleInfo.level > Number(dun_data.level)) {
							// let vip_card = vip_model.GetNobleCardState()
							let vip_default_count = 0
							// vip_model.GetVipPrivilegeValue(
							// 	BaseDungeonModel.MODULE_ID,
							// 	BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.Soul),
							// 	vip_card,
							// 	vip_flag
							// )
							let daily_default_count = Number(dun_data.count_cond) + vip_default_count
							let total_count = dun_data.add_count + dun_data.vip_count + daily_default_count
							let left_times = total_count - dun_data.daily_count
							bool = left_times > 0
						}
						if (soul_red_state_ != bool) {
							soul_red_state_ = bool
							//local_GlobalEventSystem:Fire(
							//local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
							//"DungeonEnterView",
							//DungeonEnterViewIndex.Soul,
							//bool || dungeonSoulModel.GetInstance().rewardRed
							//)
							//local_GlobalEventSystem:Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
						}
						ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon", false)
					}
				)
			}
			return bool
		}


		this.GetRuneRedState = () => {
			return rune_red_state_
		}

		this.GetSoulRedState = () => {
			// return soul_red_state_ || dungeonSoulModel.GetInstance().rewardRed
		}

		this.RefreshExpRed = () => {
			let bool = false
			let open = local_CommonManager_Instance.CheckFuncOpenState("DungeonExpEnterView", true)
			if (open) {
				let dun_list = this.GetDungeonInfo(local_DUN_TYPE.Exp)
				if (dun_list && dun_list.length > 0) {
					let cur_data = dun_list[0]
					let vip_card = vip_model.GetNobleCardState()
					let vip_flag = role_mgr.GetMainRoleVo().vip_flag
					if (vip_flag >= 1) {
						vip_card = 99
					}
					let vip_default_count = vip_model.GetVipPrivilegeValue(
						BaseDungeonModel.MODULE_ID,
						BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.Exp),
						vip_card,
						vip_flag
					)
					let daily_default_count = Number(cur_data.count_cond) + vip_default_count
					let total_count = cur_data.vip_count + daily_default_count + cur_data.add_count
					let left_times = total_count - cur_data.daily_count
					if (left_times > 0) {
						bool = true
					}
				}

				if (!bool) {
					let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(BaseDungeonModel.EXP_AGAIN_GOODS_ID)
					bool = goods_num > 0
				}

			}
			let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()

			let bool_task = MainLineTaskVo && MainLineTaskVo.task_id == BaseDungeonModel.GUILD_TASK_ID && MainLineTaskVo.has_finish == 1
			if (exp_red_state_ != bool) {
				exp_red_state_ = bool
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"DungeonEnterView",
					DungeonEnterViewIndex.Exp,
					bool && !bool_task
				)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
				this.Fire(BaseDungeonModel.UPDATE_ACTIVITY)
			}
			return bool
		}

		this.GetExpRedState = () => {
			let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()

			let bool_task = MainLineTaskVo && MainLineTaskVo.task_id == BaseDungeonModel.GUILD_TASK_ID && MainLineTaskVo.has_finish == 1
			return exp_red_state_ && !bool_task
		}

		this.IsShowDropDungeonType = (dun_type?) => {
			return dun_type == local_DUN_TYPE.Material_Copper
				|| dun_type == local_DUN_TYPE.Material_Mount
				|| dun_type == local_DUN_TYPE.Material_Partner
				|| dun_type == local_DUN_TYPE.Material_WING
				|| dun_type == local_DUN_TYPE.Rune
				|| dun_type == local_DUN_TYPE.Tower
				|| dun_type == local_DUN_TYPE.Main_Line
				|| dun_type == local_DUN_TYPE.ReincarnationDun
				|| dun_type == local_DUN_TYPE.New_Main_Line
				|| dun_type == local_DUN_TYPE.NEW_AMULET
				|| dun_type == local_DUN_TYPE.NEW_MOUNT
				|| dun_type == local_DUN_TYPE.NEW_WEAPON
				|| dun_type == local_DUN_TYPE.NEW_WING
				|| dun_type == local_DUN_TYPE.NEW_BACK_ORNAMENT
		}

		this.IsShowBornEffectDungeonType = (dun_type?) => {
			return dun_type == local_DUN_TYPE.Material_Copper
				|| dun_type == local_DUN_TYPE.Material_Mount
				|| dun_type == local_DUN_TYPE.Material_Partner
				|| dun_type == local_DUN_TYPE.Material_WING
				|| dun_type == local_DUN_TYPE.Main_Line
				|| dun_type == local_DUN_TYPE.Vip_Rerson_Boss
				|| dun_type == local_DUN_TYPE.MonsterInvasion
				|| dun_type == local_DUN_TYPE.Equip
				|| dun_type == local_DUN_TYPE.New_Main_Line
				|| dun_type == local_DUN_TYPE.NEW_AMULET
				|| dun_type == local_DUN_TYPE.NEW_MOUNT
				|| dun_type == local_DUN_TYPE.NEW_WEAPON
				|| dun_type == local_DUN_TYPE.NEW_WING
				|| dun_type == local_DUN_TYPE.NEW_BACK_ORNAMENT
				|| dun_type == local_DUN_TYPE.Heart
				|| dun_type == local_DUN_TYPE.ReincarnationDun
		}

		this.GetDunLeftTime = (dun_type?, dun_id?) => {
			let left_times = 0
			let total_times = 0
			let data = this.GetDungeonInfo(dun_type)
			if (data) {
				let dun_data = null
				if (dun_id) {
					for (let _tmpi in data) {
						var vo = data[_tmpi]
						if (vo.dun_id == dun_id) {
							dun_data = vo
							break
						}
					}
				} else {
					dun_data = data[0]
				}
				if (dun_data) {
					let vip_card = vip_model.GetNobleCardState()
					let vip_flag = role_mgr.GetMainRoleVo().vip_flag
					if (vip_flag >= 1) {
						vip_card = 99
					}
					let vip_default_count =
						vip_model.GetVipPrivilegeValue(
							BaseDungeonModel.MODULE_ID,
							BaseDungeonModel.VIP_COUNT_PARAMETER + Number(dun_type),
							vip_card,
							vip_flag
						)
					let daily_default_count = Number(dun_data.count_cond) + vip_default_count
					total_times = dun_data.vip_count + daily_default_count
					left_times = total_times - dun_data.daily_count
				}
			}
			// return {left_times, total_times}
			return [left_times, total_times]
		}

		this.SetDunFailureJumpData = (jump_id?) => {
			failure_jump_id_ = jump_id
			this.TryJumpFailureId()
		}


		this.TryJumpFailureId = () => {
			if (failure_jump_id_ && !scene_mgr.IsDungeonScene()) {
				OpenFun.OpenFunHandler(failure_jump_id_)
				failure_jump_id_ = null
			}
		}

		this.GetRuneNowFloor = () => {
			let dun_list = this.GetDungeonInfo(local_DUN_TYPE.Rune)
			let cur_floor = 0
			if (dun_list) {
				let all_floor = dun_list.length
				for (let key in dun_list) {


					if (dun_list[key].permanent_count > 0) {
						cur_floor = Number(key)
					}
				}
			}
			cur_floor = cur_floor + 1
			return cur_floor
		}

		this.SetDragonSkillData = (scmd?) => {
			drageon_skill_data_ = scmd.skill_list
			this.Fire(BaseDungeonModel.UPDATE_DRAGON_SKILL_COUNT)
		}

		this.GetDragonSkillData = () => {
			return drageon_skill_data_
		}

		this.SetDragonRefreshData = (scmd?) => {
			drageon_refresh_data_ = scmd
			this.Fire(BaseDungeonModel.UPDATE_DRAGON_REFRESH_DATA)
		}

		this.GetDragonRefreshData = () => {
			return drageon_refresh_data_
		}

		this.SetDragonWaveRewardData = (scmd?) => {
			let dungeon_wave_helper_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_wave_helper
			let dungeon_cfg = null
			let call_func = () => {
				if (!dungeon_wave_helper_cfg || !dungeon_cfg) {
					return
				}
				if (!wave_reward_list_) {
					wave_reward_list_ = []
				}
				let dic = []
				for (let _tmpi in scmd.record_list) {
					var vo = scmd.record_list[_tmpi]

					dic[vo.wave] = true
				}
				let list = []
				let dunId = scmd.dun_id
				let cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dunId, false, dungeon_cfg)
				let total_count = 0
				if (cfg) {
					total_count = cfg.wave_num
				}
				let wave_helper = dungeon_wave_helper_cfg
				if (wave_helper) {
					let index = 1
					do {
						let key = dunId + "@" + index

						let wave_cfg = wave_helper[key]
						// if (wave_cfg && wave_cfg.stage_reward != "[]" ) {
						if (wave_cfg) {
							let stage_reward = JSON.parse(wave_cfg.stage_reward)
							if (stage_reward.length > 0) {
								//0 领取  1未达成  2已领取
								let state = scmd.wave >= wave_cfg.wave ? (dic[wave_cfg.wave] ? 2 : 0) : 1
								list.push(
									{
										dun_id: dunId,
										wave: wave_cfg.wave,
										state: state,
										reward: JSON.parse(wave_cfg.stage_reward)
									}
								)
							}
						}
						index = index + 1
					} while ((index < total_count + 1))
				}

				wave_reward_list_[dunId] = { list: list, wave: scmd.wave }
				this.SetDragonRewardState()
				this.Fire(BaseDungeonModel.UPDATE_WAVE_REWARD_DATA, scmd.dun_id)
				ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon", false)
			}

			ResManager.GetInstance().LoadGameConfig(
				this,
				"config_dungeon",
				false,
				null,
				(cfgs?) => {
					dungeon_cfg = cfgs
					call_func()
				}
			)
		}

		this.GetWaveRewardData = (dun_id?) => {
			return wave_reward_list_ && wave_reward_list_[dun_id]
		}

		this.CheckRewardState = (dun_id?) => {
			let data = this.GetWaveRewardData(dun_id)
			let bool = false
			if (data) {
				for (let _tmpi in data.list) {
					var vo = data.list[_tmpi]
					if (vo.state == 1) {
						if (data.wave >= vo.wave) {
							vo.state = 0
							bool = true
						}
					}
				}
			}
			if (bool) {
				this.SetDragonRewardState()
				this.Fire(BaseDungeonModel.UPDATE_WAVE_REWARD_DATA, dun_id)
			}
		}

		this.IsDragonDunDone = (dun_id?, cfg?) => {
			let dun_cfg = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
			let bool = false
			let data = this.GetWaveRewardData(dun_id)
			if (dun_cfg && data) {
				if (dun_cfg.wave_num - 1 == data.wave) {
					bool = true
				}
			}
			return bool
		}

		this.SetDragonJumpData = (scmd?) => {
			dragon_jump_data_ = scmd
			this.Fire(BaseDungeonModel.UPDATE_DRAGON_JUMP_DATA)
		}

		this.GetDragonJumpData = () => {
			return dragon_jump_data_
		}




		this.IsInDunTypeScene = (dun_type?) => {
			let dun_id = scene_mgr.GetCurrDunId()
			let type = this.GetDunType(dun_id)
			if (type) {
				return type == dun_type
			}
		}

		this.SetHeartSkillData = (scmd?) => {
			heart_skill_data_ = []
			for (let _tmpi in scmd.skill_list) {
				var vo = scmd.skill_list[_tmpi]

				heart_skill_data_[vo.skill_id] = vo.skill_lv
			}
			this.Fire(BaseDungeonModel.UPDATE_HEART_SKILL_DATA)
		}

		this.GetHeartSkillData = () => {
			return heart_skill_data_
		}

		this.GetHeartSkillLv = (skill_id?) => {

			return heart_skill_data_ && heart_skill_data_[skill_id]
		}

		this.GetLearnSkillByTaskId = (task_id?) => {

			return task_to_dungeon_[task_id]
		}

		this.IsHeartSkill = (skill_id?, dungeon_learn_skill_cfg?) => {
			skill_id = Number(skill_id)
			let bool = false
			let cfg = dungeon_learn_skill_cfg
			if (cfg) {
				for (let key in cfg) {


					let value = cfg[key]
					let skill_list = JSON.parse(value.skill_list)
					let career = RoleManager.GetInstance().GetMainRoleCareer()
					for (let _ in skill_list) {
						var v = skill_list[_]
						if (career == Number(v[0])) {
							for (let _tmpi in v[1]) {
								var vo = v[1][_tmpi]
								if (Number(vo[0]) == skill_id) {
									bool = true
									break
								}
							}
						}
					}
					if (bool) {
						break
					}
				}
			}
			return bool
		}

		this.exit = () => {



			let ok_func = () => {
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
				let dun_type = null
				if (scene_mgr.IsVipPersonalBossDungeon()) {
					dun_type = local_DUN_TYPE.Vip_Rerson_Boss
				}
				if (dun_type) {
					this.Fire(BaseDungeonModel.SCMD_REQUEST, 61020, dun_type)
				}
			}

			if(this.alert_view_time_id_){
				clearTimeout(this.alert_view_time_id_)
				this.alert_view_time_id_ = null
			}

			if (scene_mgr.IsExpDungeon()) {
				local_Alert.Show(
					Util.StrToHTML("确定要从场景中退出吗？<br>" + Util.HtmlColorTxt("挑战次数无法返还,错过海量经验", "'#ff4f50'")),
					local_Alert_Type.Two, () => {

						//弹窗里面套同样类型的弹窗 需要点时间让逻辑把上一个弹窗先关掉
						this.alert_view_time_id_ = setTimeout(() => {
							local_Alert.Show(
								Util.StrToHTML("真的要退出场景吗？<br>" + Util.HtmlColorTxt("挑战次数无法返还", "'#ff4f50'")),
								local_Alert_Type.Two,
								ok_func,
								null,
								"退出",
								"取消"
							)
						}, 150);
					},
					null,
					"退出",
					"取消"
				)
			} else if (scene_mgr.IsVipPersonalBossDungeon()) {
				local_Alert.Show(
					Util.StrToHTML("确定要从场景中退出吗？<br>" + Util.HtmlColorTxt("提前退出不会返还门票和挑战次数", "'#ff4f50'")),
					local_Alert_Type.Two,
					ok_func,
					null,
					"退出",
					"取消"
				)
			} else if (scene_mgr.IsDragonDungeon()) {
				local_Alert.Show("确定要离开当前场景吗？<br>直接离开可能会导致奖励损失", local_Alert_Type.Two, ok_func, null, "退出", "取消")
			} else if (scene_mgr.IsEquipDungeon()) {
				let str = `确定要从场景中退出吗？<br>${HtmlColorTxt("提前退出不会返还挑战次数", Enum_ColorUtil_Light.RED)}`
				local_Alert.Show(str, local_Alert_Type.Two, ok_func, null, "退出", "取消")
			} else {
				local_Alert.Show("确定要从场景中退出吗？", local_Alert_Type.Two, ok_func, null, "退出", "取消")
			}
		}

		this.setDungeonPetLayer = (data?) => {
			//this._dungeonPetId = data.dun_id
			//if (data.dun_id == 0 ) {
			//this._dungeonPetId = this.pet_dun_id
			//}
			//this._dungeonPetSweep = data.have_sweep
			//this._dungeonPetRecordId = data.yesterday_dun_id
			//let index = 0
			//if (Util.TableSize(_petSelectDic_) == 0 ) {
			//if (data.demon_list.length == 0 ) {
			//_petSelectDic_ = []
			//let list = DemonModel.GetInstance().GetDemonsList()
			//for (let key in list) {


			//let element = list[key]
			//this:addPetSelectDic(key, 0)
			//break
			//}
			//}else{
			//for (let key in data.demon_list) {


			//let info = data.demon_list[key]
			//this:addPetSelectDic(info.demon_id, index)
			//index = index + 1
			//}
			//}
			//this:Fire(BaseDungeonModel.PET_DUNGEON_SELECT_END)
			//}
			//this:checkSweepRedDot()
			//this:checkChallengeRedDot()
			//this:Fire(BaseDungeonModel.PET_DUNGEON_ID_RETURN)
		}

		this.checkSweepRedDot = () => {
			let bool = false
			let now_bool = this.CheckRedStatus(ModuleType.DUNGEON_PET, 1)
			bool = !this._dungeonPetSweep && this._dungeonPetRecordId != 0
			if (now_bool != bool) {
				this.SetReddot(ModuleType.DUNGEON_PET, 1, bool)
				this.updatePetRed()
			}
		}

		this.checkChallengeRedDot = () => {
			ResManager.GetInstance().LoadGameConfig(
				this,
				"config_dungeon_special_cfg",
				false,
				null,
				(dungeon_special_cfg?) => {
					let bool = false
					let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition

					let open_cfg = cfg["DungeonPetView"]
					let level = role_mgr.GetMainRoleVo().level
					if (open_cfg && open_cfg.open_lv > level) {
						return
					}
					let challenge_time = CookieWrapper.GetInstance().GetCookie("DungeonPet_Challenge_time")
					let cookiDate = new local_Date(Number(challenge_time))
					let time = local_TimeUtil.getServerTimeMs()
					let date = new local_Date(time)
					let maxLayer = 100

					if (dungeon_special_cfg[local_DUN_TYPE.Pet + "@demon_floors_num"]) {

						maxLayer = dungeon_special_cfg[local_DUN_TYPE.Pet + "@demon_floors_num"].value
					}
					let cur_layer = this._dungeonPetRecordId - this.pet_dun_id
					bool =
						(((!challenge_time || date.getFullYear() != cookiDate.getFullYear()) || date.getMonth() != cookiDate.getMonth()) ||
							date.getDate() != cookiDate.getDate()) &&
						cur_layer < maxLayer
					let now_bool = this.CheckRedStatus(ModuleType.DUNGEON_PET, 2)
					if (now_bool != bool) {
						this.SetReddot(ModuleType.DUNGEON_PET, 2, bool)
						this.updatePetRed()
					}
				}
			)
		}

		this.updatePetRed = () => {
			//local_GlobalEventSystem:Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
			//local_GlobalEventSystem:Fire(
			//local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			//"DungeonEnterView",
			//DungeonEnterViewIndex.Pet,
			//this:dungeonPetRedDot()
			//)
		}

		this.showLayerList = (layer?) => {
			let list = []
			let integer = Math.floor(layer / this.pet_dun_count)
			let residue = layer % this.pet_dun_count
			let i = integer * this.pet_dun_count + 1
			do {
				list.push(this.pet_dun_id + i)
				i = i + 1
			} while ((i <= integer * this.pet_dun_count + 5))
			return list
		}

		this.setDungeonInfoDic = (config?) => {
			for (let key in config) {

				let vo = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon_grade.name, key, false, config)

				this.DungeonPetDic[vo.dun_id] = vo
			}
		}
		this.setDungeonSweepDic = (config?) => {
			this.DungeonPetSweepDic = config
		}

		this.addPetSelectDic = (demons_id?, index?) => {
			if (index >= this.petSelectMax) {
				return
			}

			_petSelectDic_[demons_id] = index
			this.Fire(BaseDungeonModel.PET_DUNGEON_SELECT_ADD, demons_id)
		}

		this.delPetSelectDic = (demons_id?) => {

			let _index = _petSelectDic_[demons_id]

			_petSelectDic_[demons_id] = null
			for (let key in _petSelectDic_) {


				let index = _petSelectDic_[key]
				if (index > _index) {
					index = index - 1
				}

				_petSelectDic_[key] = index
			}
			this.Fire(BaseDungeonModel.PET_DUNGEON_SELECT_DELECT)
		}

		this.PetSelectNum = () => {
			return Util.TableSize(_petSelectDic_)
		}

		this.petSelectIndex = (demons_id?) => {

			return _petSelectDic_[demons_id]
		}

		this.petSelectInfo2 = (index?) => {
			for (let key in _petSelectDic_) {


				let _index = _petSelectDic_[key]
				if (_index == index) {
					return key
				}
			}
		}



		this.petSelectList = () => {
			let list = []
			for (let key in _petSelectDic_) {
				list.push(key)
				// table.insert(list, key)
			}
			list.sort((a, b) => {
				let aIndex = _petSelectDic_[a]
				let bIndex = _petSelectDic_[b]
				if (aIndex != null && bIndex != null) {
					return aIndex - bIndex
				} else {
					return 1
				}
			})
			// table.sort(list,(a?, b?) => {
			// 		let aIndex = _petSelectDic_[a]
			// 		let bIndex = _petSelectDic_[b]
			// 		if (aIndex != null && bIndex != null ) {
			// 			return aIndex < bIndex
			// 		}else{
			// 			return false
			// 		}
			// 	})
			return list
		}

		this.reSetPetSelectDic = () => {
			_petSelectDic_ = []
		}

		this.setPetMonster = (instance_id?) => {
			// table.insert(this.pet_Monster_instance_id_list, instance_id)
			this.pet_Monster_instance_id_list.push(instance_id)
		}

		this.checkSelectPetMonster = () => {
			let count = 0
			for (let _tmpi in this.pet_Monster_instance_id_list) {
				var id = this.pet_Monster_instance_id_list[_tmpi]
				let pet_monster = scene_mgr.GetMonsterVo(id)
				if (pet_monster) {
					this.select_pet_instance_id = id
					break
				}
				count = count + 1
			}
			if (count == this.pet_Monster_instance_id_list.length) {
				this.select_pet_instance_id = null
			}
		}

		this.SetReddot = (mType?, rtype?, red?) => {
			red_dot_mgr.SetRedStatus(mType, rtype, red)
		}

		this.CheckRedStatus = (mType?, rtype?) => {
			return red_dot_mgr.CheckRedStatus(mType, rtype)
		}

		this.selectRedDot = () => {
			let flag = false
			//let list = DemonModel.GetInstance().GetDemonsList()
			//let select_List = this.petSelectList()
			//flag = select_List.length < this.petSelectMax && Util.TableSize(list) > select_List.length
			//if (flag ) {
			//return true
			//}
			//let dataList = DemonModel.GetInstance().GetDemonsList()
			//for (let _tmpi in select_List) {
			// var id = select_List[_tmpi]
			//let msg = DemonModel.GetInstance().GetDemonData(id)
			//if (msg ) {
			//flag = this.checkPower(msg.power)
			//if (flag ) {
			//return true
			//}
			//}
			//}
			return flag
		}

		this.checkPower = (pow?) => {
			//let dataList = DemonModel.GetInstance().GetDemonsList()
			//let select_List = this.petSelectList()
			//for (let key in dataList) {


			//let info = dataList[key]
			//let msg = DemonModel.GetInstance().GetDemonData(info.demon_id)
			//if ((select_List.find(info.demon_id + "") == -1 && msg) && pow < msg.power ) {
			//return true
			//}
			//}
			return false
		}

		this.checkPower2 = (pow?) => {
			//let select_List = this.petSelectList()
			//if (select_List.length == 0 ) {
			//return true
			//}
			//for (let _tmpi in select_List) {
			// var id = select_List[_tmpi]
			//let msg = DemonModel.GetInstance().GetDemonData(id)
			//if (msg && pow > msg.power ) {
			//return true
			//}
			//}
			return false
		}

		this.dungeonPetRedDot = () => {
			return this.CheckRedStatus(ModuleType.DUNGEON_PET, 1) || this.CheckRedStatus(ModuleType.DUNGEON_PET, 2)
		}

		this.GetAdvancedExpInfo = () => {
			let list = []
			let i = this.AdvancedExpMin
			do {
				// table.insert(list, i)
				list.push(i)
				i = i + 1
			} while ((i <= this.AdvancedExpMax))
			return list
		}

		this.setAdExpInfo = (data?) => {
			this.adExpPanelInfo = data
			if (data.wave_start_time + next_time_ >= local_TimeUtil.getServerTime()) {
				this.Fire(BaseDungeonModel.NEXT_WAVE_TIME_INFO, data.wave_start_time + next_time_)
			}
			if (data.wave_end_time >= local_TimeUtil.getServerTime()) {
				this.Fire(BaseDungeonModel.UPDATE_DUNGEON_END_TIME, data.wave_end_time)
			}
			this.Fire(BaseDungeonModel.ADVANCEDEXP_PANEL_INFO)
		}

		this.setAdExpInfo2 = (data?) => {
			if (this.adExpPanelInfo) {
				this.adExpPanelInfo.wave = data.wave
				this.adExpPanelInfo.history_wave = data.history_wave
				this.adExpPanelInfo.exp = data.exp
			} else {
				this.adExpPanelInfo = []

				this.adExpPanelInfo["wave"] = data.wave

				this.adExpPanelInfo["history_wave"] = data.history_wave

				this.adExpPanelInfo["exp"] = data.exp
			}
			this.Fire(BaseDungeonModel.ADVANCEDEXP_PANEL_INFO)
		}

		this.setAdExpPopView = (data?) => {
			if (this.adExpPanelInfo) {
				this.adExpPanelInfo.wave = data.wave
				this.adExpPanelInfo.history_wave = data.history_wave
				this.adExpPanelInfo.exp = data.exp
			} else {
				this.adExpPanelInfo = []

				this.adExpPanelInfo["wave"] = data.wave

				this.adExpPanelInfo["history_wave"] = data.history_wave

				this.adExpPanelInfo["exp"] = data.exp
			}
			this.adExpNeedPop = true
			this.Fire(BaseDungeonModel.ADVANCEDEXP_POP_VIEW)
		}

		this.setDunSetInfo = (data?, config_dungeon?) => {
			let obj = []
			for (let key in data.setting_list) {


				let info = data.setting_list[key]

				obj[info.type] = info
				if (info.type == 2) {
					this.Fire(BaseDungeonModel.UPDATE_DIAMOND_INSPRITE_STAGE, info.is_open, data.dun_id)
				} else if (info.type == 4) {
					this.Fire(BaseDungeonModel.UPDATE_COIN_INSPRITE_STAGE, info.is_open, data.dun_id)
				} else {
					this.Fire(BaseDungeonModel.UPDATE_MERGE_STAGE, info.is_open, data.dun_id)
				}
			}
			data.setting_list = obj
			let cfg =
				local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, data.dun_id, false, config_dungeon)
			// table.find(DunTypeSetList_,cfg.type)
			if (cfg && DunTypeSetList_.indexOf(cfg.type) != -1) {

				DunTypeSetInfo_[data.dun_id] = data
			} else {

				DunIdSetInfo_[data.dun_id] = data
			}
			this.check_inspite_msg(inspite_msg)
		}

		this.DunSetInfo = (dun_id?, need_request?, config_dungeon?) => {
			if (need_request == null) {
				need_request = false
			}
			let info = null
			let cfg =
				local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, config_dungeon)
			//table.find(DunTypeSetList_,cfg.type) != -1
			if (cfg && DunTypeSetList_.indexOf(cfg.type) != -1) {

				info = DunTypeSetInfo_[dun_id]
			} else {

				info = DunIdSetInfo_[dun_id]
			}
			if (info) {
				return info.setting_list
			} else if (!info && need_request) {
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61062, dun_id)
			}
		}

		this.changeDunSetInfo = (data?) => {
		}

		this.RefreshAdExpRed = () => {
			let bool = false
			let open = local_CommonManager_Instance.CheckFuncOpenState("AdvancedExpEnterView", true)
			if (open) {
				let dungeonInfo = this.GetDungeonInfo(local_DUN_TYPE.AdvancedExp)
				let dungeon_data = dungeonInfo[0]
				let left_times = 0
				if (dungeon_data) {
					// let vip_card = vip_model.GetNobleCardState()
					// let vip_flag = role_mgr.GetMainRoleVo().vip_flag
					// if (vip_flag >= 1 ) {
					// 	vip_card = 99
					// }
					let vip_default_count = 0
					// vip_model.GetVipPrivilegeValue(
					// 	BaseDungeonModel.MODULE_ID,
					// 	BaseDungeonModel.VIP_COUNT_PARAMETER + Number(local_DUN_TYPE.AdvancedExp),
					// 	vip_card,
					// 	vip_flag
					// )
					let total_times = dungeon_data.vip_count + Number(dungeon_data.count_cond) + vip_default_count
					left_times = total_times - dungeon_data.daily_count
				}
				bool = left_times > 0
			}
			if (advancedExpRed_ != bool) {
				advancedExpRed_ = bool
				//local_GlobalEventSystem:Fire(
				//local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				//"DungeonEnterView",
				//DungeonEnterViewIndex.AdvanExp,
				//bool
				//)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
			}
		}

		this.dungeonAdExpRedDot = () => {
			return advancedExpRed_
		}

		this.getAdExpSceneObj = () => {
			for (let key in canUseAdExpSceneObj_) {


				let obj = canUseAdExpSceneObj_[key]
				if (obj) {

					canUseAdExpSceneObj_[key] = null
					return obj
				}
			}

			let obj = window["AdvancedExpSceneObj"].New()

			adExpSceneObj_[obj.hashCode] = obj
			return obj
		}

		this.addAdExpSceneObj = (obj?) => {

			canUseAdExpSceneObj_[obj.hashCode] = obj
		}

		this.removeAdExpSceneObj = () => {
			for (let key in adExpSceneObj_) {


				let obj = adExpSceneObj_[key]
				obj.DeleteMe()
			}
			adExpSceneObj_ = []
			canUseAdExpSceneObj_ = []
		}

		this.setPolarInfo = (data?) => {
			for (let key in data.dun_list) {

				let info = data.dun_list[key]
				polarInfo_[info.week_dun_id] = info
			}
			this.Fire(BaseDungeonModel.POLAR_DATA_RETURN)
		}

		this.getPolarInfo = (week_dun_id?) => {
			return polarInfo_[week_dun_id]
		}

		this.setPolarRank = (data?) => {
			polarRank_[data.team_dun_id] = data
			this.Fire(BaseDungeonModel.POLAR_RANK_DATA_RETURN)
		}

		this.getPolarRank = (dun_id?) => {
			return polarRank_[dun_id]
		}

		this.polarRankCfg = (cfg?, dun_id?, rank?) => {
			for (let key in cfg) {

				let info = cfg[key]
				if ((info.dun_id == dun_id && rank >= info.rank1) && rank <= info.rank2) {
					return info
				}
			}
		}

		this.getRewaedCfgList = (cfg?, id?) => {
			let list = []
			for (let key in cfg) {

				let info = cfg[key]
				if (info.dun_id == id && info.rewards_view.trim() != "[]") {
					// table.insert(list, info)
					list.push(info)
				}
			}
			list.sort((a, b) => {
				return a.boss_id - b.boss_id
			})
			// table.sort(list,(a?,b?) => {
			// 		return a.boss_id < b.boss_id
			// 	})
			return list
		}

		this.rewardHasGet = (polar_dun_id?, boss_id?) => {
			let flag = false
			let info = this.getPolarInfo(polar_dun_id)
			if (info) {
				for (let key in info.boss_reward) {

					let data = info.boss_reward[key]
					if (data.boss_id == boss_id) {
						flag = data.reward_st == 1
						break
					}
				}
			}
			this.Fire(BaseDungeonModel.POLAR_RANK_DATA_RETURN)
			return flag
		}

		this.polarbossList = (cfg?, dun_id?) => {
			let list = []
			for (let key in cfg) {

				let info = cfg[key]
				if (dun_id == info.rel_dun_id) {
					// table.insert(list, info)
					list.push(info)
				}
			}
			list.sort((a, b) => {
				return a.boss_id - b.boss_id
			})
			// table.sort(list,(a?,b?) => {
			// 		return a.boss_id < b.boss_id
			// 	})
			return list
		}

		this.setPolarSpData = (data?, config_week_dungeon_kv?) => {
			let list = local_ErlangParser_Instance.Parse(data.content)
			let dic = []
			for (let key in list) {
				let info = list[key]
				dic[info[0]] = info[1]
			}
			if (scene_mgr.IsPolarDungeon() || scene_mgr.IsKFPolarDungeon()) {
				if (dic["left_count"]) {
					this.relive_time = dic["left_count"]
					this.Fire(BaseDungeonModel.POLAR_RELIVE_TIME)
				}
				if (dic["boss_info"]) {
					for (let key in dic["boss_info"]) {

						let boss = dic["boss_info"][key]
						let boss_id = Number(boss[0])
						let state = boss[1]
						if (this.boss_info[boss_id] != Number(state)) {
							this.boss_info[boss_id] = Number(state)
							this.Fire(BaseDungeonModel.POLAR_BOSS_INFO_UPDATE, boss_id)
						}
					}
				}

				if (dic["dead_time"]) {


					// this.dead_time = Number(dic["dead_time"])
					// this.Fire(BaseDungeonModel.POLAR_DEAD_TIME, this.dead_time)
					// if (data.push_type == 1&&this.dead_time>0) {
					// 	let week_dungeon_kv_cfg = config_week_dungeon_kv
					// 	let wait_time = scene_mgr.IsKFPolarDungeon() && Number(week_dungeon_kv_cfg[0].value) || Number(week_dungeon_kv_cfg[1].value)

					// 	let dead_times=this.dead_time + wait_time
					// 	if (dead_times > local_TimeUtil.getServerTime()) {
					// 		//还有剩余时间  打开复活界面继续读秒
					// 		this.Fire(BaseDungeonModel.SCMD_REQUEST, 20013)
					// 	} else {
					// 		local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 9)
					// 	}
					// }

					//极限试炼死亡测试
					let local_rolemainVo = RoleManager.GetInstance().GetMainRoleVo()
					if (local_rolemainVo && local_rolemainVo.hp == 0) {
						this.dead_time = Number(dic["dead_time"])
						this.Fire(BaseDungeonModel.POLAR_DEAD_TIME, this.dead_time)
						if (data.push_type == 1) {
							let week_dungeon_kv_cfg = config_week_dungeon_kv
							let wait_time = scene_mgr.IsKFPolarDungeon() && Number(week_dungeon_kv_cfg[0].value) || Number(week_dungeon_kv_cfg[1].value)

							if (this.dead_time + wait_time > local_TimeUtil.getServerTime()) {
								this.Fire(BaseDungeonModel.SCMD_REQUEST, 20013)
							} else {
								local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 9)
							}
						}
					} else {
						this.dead_time = null
					}
				}
			}
		}

		this.PolarBossInfo = (boss_id?) => {
			for (let key in this.boss_info) {

				let state = this.boss_info[key]
				if (Number(key) == boss_id) {
					return state
				}
			}
		}

		this.setPolarBalance = (data?) => {
			this.polarBalance = data
			console.warn(data)
			console.warn("打开界面")
			this.Fire(BaseDungeonModel.OPEN_POLAR_BALANCE)
		}

		this.GetPolarSkillList = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_week_dungeon
			let cur_skill_cfg = null
			let dun_id = SceneManager.GetInstance().GetCurrDunId()
			for (let k in cfg) {
				var info = cfg[k]
				if (dun_id == info.single_dun_id || dun_id == info.team_dun_id) {
					cur_skill_cfg = info
					break
				}
			}
			let skill_list = []
			if (cur_skill_cfg) {
				let cfg_dic = JSON.parse(cur_skill_cfg.active_skill)
				let career = RoleManager.GetInstance().GetMainRoleCareer()
				let skill_cfg = null
				for (let i = 0; i < cfg_dic.length; i++) {
					var _cfg = cfg_dic[i]
					if (Number(_cfg[0]) == career) {
						skill_cfg = cfg_dic[career]
						break
					}
				}
				if (skill_cfg) {
					let list = skill_cfg[1]
					for (let i = 0; i < list.length; i++) {
						var skill = list[i]
						let skillVo = SkillManager.GetInstance().getSkill(skill[0])
						if (skillVo) {
							// table.insert(skill_list,skillVo)
							skill_list.push(skillVo)
						}
					}
				}
			}
			return skill_list
		}

		this.check_inspite_msg = (data?) => {
			if (this.show_inspite_msg) {
				inspite_msg = data
				this.show_inspite_msg = false
				this.showInspriteMsg()
			}
		}

		this.showInspriteMsg = () => {
			if (!inspite_msg) {
				return
			}
			let coin_insprite_count = inspite_msg.coin_count
			let diamond_insprite_count = inspite_msg.gold_count
			let dun_id = scene_mgr.GetCurrDunId()
			let info = this.DunSetInfo(dun_id)
			if (!info) {
				this.show_inspite_msg = true
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61062, dun_id)
				return
			}
			let coin_switch = info[4] && info[4].is_open
			let diamond_switch = info[2] && info[2].is_open
			if (((coin_insprite_count == 0 && diamond_insprite_count == 0) && !coin_switch) && !diamond_switch) {
				return
			}
			let total_count = coin_insprite_count + diamond_insprite_count
			if (total_count > 0) {
				let str_list = []
				let dun_id = scene_mgr.GetCurrDunId()
				let num = 10
				if (dun_id == BaseDungeonModel.GUILD_EXP_ID) {
					num = 5
				}
				for (let i = 1; i <= total_count; i++) {
					let str = "鼓舞成功，当前伤害加成为 " + i * num + "%"
					Laya.timer.frameOnce(i, this, () => {
						Message.show(str)
					})
				}

			}
			if ((coin_switch && 0 <= coin_insprite_count) && coin_insprite_count < 5) {
				Message.show("铜币不足")
			}
			if ((diamond_switch && 0 <= diamond_insprite_count) && diamond_insprite_count < 5) {
				Message.show("勾玉不足")
			}
			inspite_msg = null
		}

		this.IsLoadingDunType = (dun_id?) => {
			let find = false
			for (let i in DungeonLoadindType) {
				var type = DungeonLoadindType[i]
				if (type == dun_id) {
					find = true
					break
				}
			}
			return find
		}

		this.EnterSceneStart = () => {
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let dun_type = this.GetDunType(cur_dun_id)
			if (this.IsLoadingDunType(dun_type)) {
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61111)
			}
		}

		this.SetRuneReward = (data?) => {
			this.extraReward[data.dun_type] = data
		}

		this.GetRuneReward = (dun_type?) => {
			let data = this.extraReward[dun_type]
			return !data && {} || data
		}

		this.GetRuneRewardData = (dun_id?, config_dun_reward?) => {
			let edata = this.GetRuneReward(DUN_TYPE.Rune, config_dun_reward)
			let dun_list = edata.dun_list
			dun_list = !dun_list && {} || dun_list
			for (let i in dun_list) {
				var data = dun_list[i]
				if (data.dun_id == dun_id) {
					return data
				}
			}
		}

		this.RuneRewardRed = () => {
			let edata = this.GetRuneReward(DUN_TYPE.Rune)
			let dun_list = edata.dun_list
			dun_list = !dun_list && {} || dun_list
			for (let i in dun_list) {
				var data = dun_list[i]
				if (data.reward_status == 0) {
					return true
				}
			}
			return false
		}

		this.RuneRewardOneKey = () => {
			let edata = this.GetRuneReward(DUN_TYPE.Rune)
			let list = []
			let dun_list = edata.dun_list
			dun_list = !dun_list && {} || dun_list
			for (let i in dun_list) {
				var data = dun_list[i]
				if (data.reward_status == 0) {
					// table.insert(list, {dun_id = data.dun_id , reward_type = data.reward_type})
					list.push({ dun_id: data.dun_id, reward_type: data.reward_type })
				}
			}
			if (list.length > 0) {
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61112, list)
			} else {
				Message.show("当前无可领取")
			}
		}

		this.SetMergeExpCount = (bool?) => {
			merge_exp_count = bool
		}
		this.GetMergeExpCount = () => {
			return merge_exp_count
		}


		this.SetRuneExtraReward = (data?) => {
			let edata = this.GetRuneReward(DUN_TYPE.Rune)
			if (edata) {
				let dun_list = edata.dun_list
				dun_list = !dun_list && {} || dun_list
				for (let j in data.reward_args_list) {
					var _data = data.reward_args_list[j]
					for (let i in dun_list) {
						var info = dun_list[i]
						if (_data.dun_id == info.dun_id) {
							info.reward_status = 1
							this.Fire(BaseDungeonModel.GET_RUNE_DUN_REWARD, _data.dun_id)
							break
						}
					}
				}

			}
			Util.ShowCongratulationView(data.reward_list)
			this.Fire(BaseDungeonModel.CHANGE_RUNE_DUN_REWARD)
			this.RefreshRuneRed()
		}


		//神纹副本初始奖励 初始化
		this.InitDragonReward = () => {
			let list = DungeonDragonDefine.WaveRewardTabList
			for (let i = 0; i < list.length; i++) {
				this.Fire(BaseDungeonModel.SCMD_REQUEST, 61051, list[i].dun_id)
			}
		}

		this.SetRuneDailyRewardState = (state) => {
			rune_daily_reward_state = state
			this.Fire(BaseDungeonModel.UPDATE_RUNE_DAILY_REWARD_STATE)
		}

		this.SetRuneUnlockFloor = (floor) => {
			rune_unlock_floor = floor
			this.Fire(BaseDungeonModel.UPDATE_RUNE_UNLOCK_FLOOR)
		}

		this.GetRuneDailyRewardState = () => {
			return rune_daily_reward_state
		}

		this.GetRuneUnlockFloor = () => {
			return rune_unlock_floor
		}


		//**限时爬塔 
		//领取大奖
		this.ToGetTowerBigReward = () => {
			if (this.dungeon_tower_scmd == null || this.dungeon_tower_scmd.round == 0) return
			this.Fire(BaseDungeonModel.SCMD_REQUEST, 61118, this.dungeon_tower_scmd.round)
		}

		//获取塔的数据
		this.GetTowerInfoDatas = () => {
			let round = this.dungeon_tower_scmd.round
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_limit_tower_round[round]
			return cfg
		}

		//检查塔是否已经通关 true已通关
		this.CheckTowerIsPass = (dun_id) => {
			let list = this.dungeon_tower_scmd.pass_list || []
			for (let i = 0; i < list.length; i++) {
				if (list[i].dun_id == dun_id) return true
			}
			return false
		}


		this.GetTowerRewards = (dun_id?, config_dun_reward?) => {
			let key = `${dun_id}@0@0`
			let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_grade.name, key, false, config_dun_reward)
			if (dun_cfg && dun_cfg.reward) {
				//关卡所有奖励
				return ErlangParser.GetInstance().parse(dun_cfg.reward)
			}
			return []

		}

		/**大奖领取状态   0不可领取 1可领取  2已领取*/
		this.GetTowerRewardState = () => {
			let reward_mode = this.dungeon_tower_scmd.reward_mode || 0
			return reward_mode
		}


		this.AddTowerIcon = (over_time, round?) => {
			if (!over_time
				|| over_time == 0
				|| (!this.is_continue_show && this.GetTowerRewardState() == 2)
			) {

				ActivityIconManager.GetInstance().deleteIcon(BaseDungeonModel.TOWER_ICON_TYPE)
			} else {
				this.is_continue_show = true
				ActivityIconManager.GetInstance().addIcon(BaseDungeonModel.TOWER_ICON_TYPE, over_time, null, null, this.GetLimitTowerIcon(round))
			}

		}

		this.RefreshTowerRed = () => {
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, BaseDungeonModel.TOWER_ICON_TYPE, this.CheckTowerRed())
		}

		this.CheckTowerRed = () => {

			if (!this.dungeon_tower_scmd) return false

			if (this.GetTowerRewardState() == 1) return true
			if (this.GetTowerRewardState() == 2) return false //大奖领取完毕 活动结束
			return this.GetNextChallenge() != 0
		}


		this.GetTowerIds = (round_cfg) => {
			let list = ErlangParser.GetInstance().parse(round_cfg.dup_list)
			let new_list = []
			for (let i = 0; i < list.length; i++) {
				let is_max1 = i == list.length - 1 ? true : false
				table.insert(new_list, { dun_id: Number(list[i]), is_max: is_max1, idx: (i + 1) })
			}
			return new_list
		}


		this.GetNextChallenge = (not_need_fight?) => {
			let round_cfg = this.GetTowerInfoDatas()
			let all_data = this.GetTowerIds(round_cfg)
			let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
			let dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
			for (let i = 0; i < all_data.length; i++) {
				let dun_id = all_data[i].dun_id
				if (this.CheckTowerIsPass(dun_id)) continue

				//不需要对比战力，直接返回一个未通关的关卡id
				if (not_need_fight) {
					return dun_id
				}

				let cfg_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false, dun_cfg)

				if (cfg_vo) {
					if (fighting >= Number(cfg_vo.recommend_power)) return dun_id
				}
			}

			return 0
		}

		this.OpenLimitTowerView = () => {
			if (this.dungeon_tower_scmd == null || this.dungeon_tower_scmd.round == 0) {
				return
			}
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonTowerBaseView")
		}

		this.GetLimitTowerSkin = (type) => {
			let round = 1
			if (this.dungeon_tower_scmd && this.dungeon_tower_scmd.round > 0) {
				round = this.dungeon_tower_scmd.round
			}

			switch (type) {
				case 1: //背景
					return `ui_limit_tower_${round}.jpg`
				case 2://小方格背景
					return `act_box_bg_${round}`
				case 3://活动title
					return `act_title_${round}`
			}
		}

		this.GetLimitTowerName = () => {
			let round = 1
			if (this.dungeon_tower_scmd && this.dungeon_tower_scmd.round > 0) {
				round = this.dungeon_tower_scmd.round
			}

			switch (round) {
				case 1: //背景
					return `崇天之途`
				case 2://小方格背景
					return `荒川之途`
				case 3://活动title
					return `御灵之途`
			}
		}

		this.GetLimitTowerIcon = (round) => {
			return `33197_${round == 0 ? 1 : round}`
		}

		this.RequestLimitTowerData = () => {
			//请求爬塔的数据
			this.Fire(BaseDungeonModel.SCMD_REQUEST, 61117)
		}


		//新资源副本

		/**请求次数 dun_type==0请求所有副本的次数*/
		this.RequestDungeonNum = (dun_type) => {
			if (dun_type == 0) {
				this.dungeon_num_data_ = {}
			}
			this.Fire(BaseDungeonModel.SCMD_REQUEST, 61121, dun_type)
		}

		// 操作类型 1-一键挑战 2-一键扫荡
		this.RequestDungeonChallenge = (oper_type) => {
			this.Fire(BaseDungeonModel.SCMD_REQUEST, 61120, oper_type)
		}

		this.SaveDungeonNumData = (scmd) => {
			if (!scmd) return
			if (!this.dungeon_num_data_) {
				this.dungeon_num_data_ = {}
			}
			let list = scmd.count_list || []
			for (let i = 0; i < list.length; i++) {
				let vo = list[i]//{dun_type: 45, sweep_count: 0, challenge_count: 0}
				this.dungeon_num_data_[vo.dun_type] = vo
			}
		}


		//type:1获取已挑战次数 2获取已扫荡次数
		this.GetDungeonTimesData = (dun_type, type) => {
			let times = 0
			if (this.dungeon_num_data_[dun_type]) {
				let vo = this.dungeon_num_data_[dun_type]
				if (type == 1) {
					times = vo.challenge_count
				} else {
					times = vo.sweep_count
				}

			}
			return times
		}

		this.ShowDungeonResult = (scmd) => {
			if (!scmd) return
			console.warn("----------------61120------------", scmd)
			let list = []

			let local_GoodsModel_Instance = GoodsModel.GetInstance()
			for (let p = 0; p < scmd.sweep_list.length; p++) {
				let sub_list = scmd.sweep_list[p]
				for (let _tmpi in sub_list.reward_list) {
					var vo = sub_list.reward_list[_tmpi]
					let count = vo.count
					let [type_id, lock] = local_GoodsModel_Instance.GetMappingTypeId(vo.style, vo.typeId)
					let basic = local_GoodsModel_Instance.GetGoodsBasicByTypeId(type_id)
					if ((count > 1 && basic) && basic.type != 36) {

						let max_overlap = (basic.max_overlap == 0 && (1) || (basic.max_overlap))
						while ((count > 0)) {
							let num = null
							if (count > max_overlap) {
								num = max_overlap
								count = count - max_overlap
							} else {
								num = count
								count = 0
							}
							//table.insert(list2, [obj.drop_type, obj.type_id, obj.drop_num, obj.drop_id])
							table.insert(list, [vo.style, vo.typeId, num, vo.goods_id])
						}
					} else {
						table.insert(list, [vo.style, vo.typeId, vo.count, vo.goods_id])
					}
				}
				for (let _tmpi in sub_list.other_reward) {
					var other_reward = sub_list.other_reward[_tmpi]
					for (let _tmpi in other_reward.other_reward_list) {
						var vo = other_reward.other_reward_list[_tmpi]
						let count = vo.count1
						if (count > 1) {
							let [type_id, lock] = local_GoodsModel_Instance.GetMappingTypeId(vo.style1, vo.type_id1)
							let basic = local_GoodsModel_Instance.GetGoodsBasicByTypeId(type_id)
							if (basic) {

								let max_overlap = (basic.max_overlap == 0 && (1) || (basic.max_overlap))
								if (basic.type == 36) {
									max_overlap = 999999999999999
								}
								while ((count > 0)) {
									let num = null
									if (count > max_overlap) {
										num = max_overlap
										count = count - max_overlap
									} else {
										num = count
										count = 0
									}
									//_goods_data
									//_goods_data[0]  style_id 
									//_goods_data[1]  type_id
									//_goods_data[2]  num
									//_goods_data[3]  goods_id
									//_goods_data[4]  is_zhouka  周卡
									//_goods_data[5]  is_yueka   月卡
									//_goods_data[6]  double     额外奖励

									//other_reward.reward_type == 9 周卡
									//other_reward.reward_type == 1 额外奖励
									if (other_reward.reward_type == 9) {
										table.insert(list, [vo.style1, vo.type_id1, num, vo.goods_id1, 1, 0, 0])
									} else {
										table.insert(list, [vo.style1, vo.type_id1, num, vo.goods_id1, 0, 0, 1])
									}

								}
							}
						} else {
							if (other_reward.reward_type == 9) {
								table.insert(list, [vo.style1, vo.type_id1, vo.count1, vo.goods_id1, 1, 0, 0])
							} else {
								table.insert(list, [vo.style1, vo.type_id1, vo.count1, vo.goods_id1, 0, 0, 1])
							}
						}
					}
				}

			}

			// let sort_func = (a, b) => {
			// 	let a_value = a[4] * 100 + a[5] * 10 + a[6] * 1
			// 	let b_value = b[4] * 100 + b[5] * 10 + b[6] * 1
			// 	return a_value < b_value
			// }

			// table.sort(list, sort_func)
			if (list && list.length > 0) {
				Util.ShowCongratulationView(list)
			}
		}


		//type:1获取挑战次数 2获取扫荡次数
		this.GetDungeonChallengeTimes = (dun_type, type) => {
			let vip_model = VipModel.GetInstance()

			let total_count = 0
			let vip_card = vip_model.GetNobleCardState()  //99类型就是开启了特权卡
			let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			if (vip_card == 99) {
				//开启了特权卡
				if (type == 1) {
					//挑战
					total_count = vip_model.GetVipPVSweepNum(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_COUNT_PARAMETER + Number(dun_type), vip_card, vip_flag)
				} else {
					//扫荡 
					total_count = vip_model.GetVipPVSweepNum(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_PARAMETER + Number(dun_type), vip_card, vip_flag)
				}
			} else {
				if (type == 1) {
					//挑战
					total_count = vip_model.GetVipPVChallengeNum(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_COUNT_PARAMETER + Number(dun_type))
				} else {
					//扫荡 
					total_count = vip_model.GetVipPVChallengeNum(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_PARAMETER + Number(dun_type))
				}
			}


			return total_count
		}

		/***是否是新资源副本类型 */
		this.IsNewMateriaDungeon = (dun_type) => {
			// switch (dun_type) {
			// 	case DUN_TYPE.NEW_MOUNT:
			// 	case DUN_TYPE.NEW_WING:
			// 	case DUN_TYPE.NEW_AMULET:
			// 	case DUN_TYPE.NEW_WEAPON:
			// 	case DUN_TYPE.Material_Copper:
			// 	case DUN_TYPE.Material_Mount:
			// 		return true
			// }
			if (this.mat_new_list.indexOf(Number(dun_type)) != -1) return true
			return false
		}


		//[当前副本难度，展示类型，下一个副本预告]
		this.GetCurDifficult = (dun_type) => {
			let all_data = this.GetDungeonInfo(Number(dun_type))
			if (!all_data || !all_data[0]) return [null, 0, null]
			let cur_difficuly = null //当前难度数据 null表示没有开始挑战 是全新的副本
			let want_difficult = null //下一个可以挑战的难度
			let pre_difficult = null//下一个副本预告 
			let role_lv = role_mgr.mainRoleInfo.level


			let pass_index = 0
			let i
			//当前玩家挑战过的最大难度副本
			for (i = 0; i < all_data.length; i++) {
				let vo = all_data[i]
				if (vo.is_sweep == 1) {
					cur_difficuly = vo
					pass_index = i + 1
				}
			}


			//下一个玩家可以挑战的最大难度副本（未挑战）
			let unpas_index2 = 0
			if (cur_difficuly && this.GetValByKey(2, cur_difficuly.rec_data) >= 3) {
				for (i = pass_index; i < all_data.length; i++) {
					let vo = all_data[i]
					if (vo.is_sweep == 0) {
						if (role_lv >= Number(vo.level)) {
							want_difficult = vo
							unpas_index2 = i + 1
							break;
						}
					}
				}
			} else {
				want_difficult = all_data[0]
				unpas_index2 = 1
			}


			//判断类型
			let type = BaseDungeonModel.TYPE_NORMAL
			let is_set = false

			//新副本
			if (cur_difficuly == null && !is_set) {
				type = BaseDungeonModel.TYPE_NEW_DUNGEON
				is_set = true
			}
			//新难度
			if (cur_difficuly && want_difficult && !is_set) {
				if (cur_difficuly.dun_id != want_difficult.dun_id) {
					//如果当天没有挑战次数 则显示可扫荡的副本
					let challenge_times = this.GetDungeonChallengeTimes(dun_type, 1) //总共挑战次数
					let left_count_challenge = challenge_times - this.GetDungeonTimesData(dun_type, 1)//剩余挑战次数
					if (left_count_challenge <= 0) {
						type = BaseDungeonModel.TYPE_NEW_DIFF_HIDE
					} else {
						type = BaseDungeonModel.TYPE_NEW_DIFF_SHOW
					}
					is_set = true
				}
			}

			//验证日常  是否有挑战次数
			if (!is_set) {
				let ctimes = this.GetDungeonChallengeTimes(dun_type, 1)
				let left = ctimes - this.GetDungeonTimesData(dun_type, 1)
				type = left > 0 ? BaseDungeonModel.TYPE_NORMAL_HAS_TIMES : BaseDungeonModel.TYPE_NORMAL
			}


			//下一个难度预告
			if ((cur_difficuly == null && want_difficult) || (cur_difficuly && want_difficult)) {
				if (unpas_index2 < all_data.length) {
					pre_difficult = all_data[unpas_index2]
				}
			}

			if (want_difficult == null) {
				if (pass_index < all_data.length) {
					pre_difficult = all_data[pass_index]
				}
			}


			//返回
			if (type == BaseDungeonModel.TYPE_NEW_DIFF_SHOW || type == BaseDungeonModel.TYPE_NEW_DUNGEON) {
				if (type == BaseDungeonModel.TYPE_NEW_DUNGEON && !this.IsNewDungeonOpen(want_difficult.dun_id)) {
					//判断新副本类型是否开启 未解锁变更类型
					type = BaseDungeonModel.TYPE_NEW_INLOCK
				}
				return [want_difficult, type, pre_difficult]
			}
			if (type == BaseDungeonModel.TYPE_NEW_DIFF_HIDE) {
				return [cur_difficuly, type, want_difficult]
			}

			return [cur_difficuly, type, pre_difficult]
		}

		//获得所有副本的可挑战次数 
		//list=[dun_type,...]
		//check_new_dun  是否检测新副本类型
		//check_cha  	是否检测新难度类型
		this.GetAllDungeonChallengeTimes = (list, check_new_dun = true, check_cha = true) => {
			let total1 = 0
			for (let i = 0; i < list.length; i++) {
				let dun_type = list[i]
				let arr = this.GetCurDifficult(dun_type)
				if (!arr[0]) continue
				if ((check_cha && arr[1] == BaseDungeonModel.TYPE_NEW_DIFF_SHOW)
					|| (check_new_dun && arr[1] == BaseDungeonModel.TYPE_NEW_DUNGEON)
					|| arr[1] == BaseDungeonModel.TYPE_NORMAL_HAS_TIMES) {

					let ctimes = this.GetDungeonChallengeTimes(dun_type, 1)
					let left = ctimes - this.GetDungeonTimesData(dun_type, 1)
					total1 += left
				}
			}
			return total1
		}

		//获得所有副本的可扫荡次数 没有通关的副本可扫荡次数为0  list=[dun_type,...]
		this.GetAllDungeonSweepTimes = (list) => {
			let total1 = 0
			for (let i = 0; i < list.length; i++) {
				let dun_type = list[i]
				let arr = this.GetCurDifficult(dun_type)
				if (!arr[0]) continue
				if (arr[1] != BaseDungeonModel.TYPE_NEW_DUNGEON) {
					let ctimes = this.GetDungeonChallengeTimes(dun_type, 2)
					let left = ctimes - this.GetDungeonTimesData(dun_type, 2)
					total1 += (left > 0 ? left : 0)
				}
			}
			return total1
		}

		//获得副本难度值
		this.GetDungeonDifficultNum = (dun_data) => {
			let dun_name: String = dun_data.name
			let name2 = dun_name.slice(dun_name.indexOf("(") + 1, dun_name.length - 1)
			switch (name2) {
				case "新手":
				case "简单":
					return 1
				case "冒险":
				case "普通":
					return 2
				case "专精":
					return 3
				case "困难":
				case "勇士":
					return 4
				case "噩梦":
				case "王者":
					return 5
				case "地狱":
				case "英雄":
					return 6
			}
			return 0
		}



		this.GetTextColor = (dun_id, is_html = false, is_drak = true) => {
			let color
			let dun_id_index = dun_id%100
			switch (dun_id_index) {
				case 1:
					color = is_drak ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Light.GREEN
					break;
				case 2:
					color = is_drak ? Enum_ColorUtil_Dark.BLUE : Enum_ColorUtil_Light.BLUE
					break;
				case 3:
					color = is_drak ? Enum_ColorUtil_Dark.PURPLE : Enum_ColorUtil_Light.PURPLE
					break;
				case 4:
					color = "'#ff6519'"  //橙色
					break;
				case 5:
					color = is_drak ? Enum_ColorUtil_Dark.RED : Enum_ColorUtil_Light.RED
					break;
				case 6:
					color = is_drak ? Enum_ColorUtil_Dark.PINK : Enum_ColorUtil_Light.PINK
					break;
				default:
					color = "'#ff6519'"  //橙色
					break;
			}
			if (!is_html) color = ColorUtil.GetReplaceChar(color)

			return color
		}



		//获取一个最低难度并有挑战次数的副本  list=[dun_type,...]
		this.GetOneLowerDiffDun = (list) => {
			let dun_data_temp = null
			let diff = 999
			for (let i = list.length - 1; i >= 0; i--) {
				let dun_type = list[i]
				let arr = this.GetCurDifficult(dun_type)
				if (!arr[0]) continue
				let left = this.GetAllDungeonChallengeTimes([dun_type])
				if (left <= 0) continue
				if (arr[1] == BaseDungeonModel.TYPE_NEW_DIFF_SHOW || arr[1] == BaseDungeonModel.TYPE_NEW_DUNGEON) {
					let cud_diff = this.GetDungeonDifficultNum(arr[0])
					if (cud_diff < diff) {
						dun_data_temp = arr[0]
						diff = cud_diff

					}
				}
			}
			return dun_data_temp
		}



		// 1: 最佳通关时间
		// 2: 评价星级
		// 3: 历史最高分
		// 4: 今日最高分
		// 5: 是否通关  0 否  1 是
		// ...
		this.GetValByKey = (key_num, rec_data) => {
			for (let i = 0; i < rec_data.length; i++) {
				let obj = rec_data[i]
				if (obj.key == key_num) return obj.val
			}
			return 0
		}


		/***第N次扫荡的消耗
		 * @param dun_id   副本id
		 * @param times    扫荡第几次
		*/
		this.GetSweepCost = (dun_id, times) => {
			let dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[dun_id]
			if (dun_cfg) {

				let ctimes = times
				let sweep_costs = ErlangParser.GetInstance().parse(dun_cfg.sweep_cost)
				let sewwp_cfg = null
				for (let i = 0; i < sweep_costs.length; i++) {
					let cost_vo = sweep_costs[i]
					if (Number(cost_vo[0]) <= ctimes && ctimes <= Number(cost_vo[1])) {
						sewwp_cfg = cost_vo[2]
						break
					}
				}
				return sewwp_cfg
			}

			return null
		}


		/**
		 * 一键扫荡总共消耗
		 * @param list [dun_type,.....]
		 */
		this.GetAllCanSweepDunCost = (list) => {
			let count = 0

			let str_test = []
			for (let i = 0; i < list.length; i++) {
				let dun_type = list[i]
				let arr = this.GetCurDifficult(dun_type)
				if (arr[1] == BaseDungeonModel.TYPE_NEW_DUNGEON) continue
				if (arr[1] == BaseDungeonModel.TYPE_NEW_DIFF_SHOW) continue
				if (arr[1] == BaseDungeonModel.TYPE_NORMAL_HAS_TIMES) continue

				let vo = arr[0]
				if (vo) {
					let ctimes = this.GetDungeonChallengeTimes(dun_type, 2)	  //总共可扫荡次数
					let has_sweeps = this.GetDungeonTimesData(dun_type, 2)		//已扫荡次数
					let left = ctimes - has_sweeps //剩余扫荡次数
					for (let j = (has_sweeps + 1); j <= ctimes; j++) {
						let costs = this.GetSweepCost(vo.dun_id, j)
						count += Number(costs[2])
						str_test.push(`${vo.name}_${j}:${Number(costs[2])}`)
					}
				}
			}
			console.warn("-------------一键扫荡消耗---------", str_test)
			return count
		}

		//重置数据
		this.InitNewMatrialRed = () => {
			this.dungeon_red_state = {}
			this.dungeon_new_list = []
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_ui_tab
			for (let key in cfg) {
				let v = cfg[key]
				if (v.group == BaseDungeonModel.GROUP_TYPE) {
					this.dungeon_new_list.push(v.dun_type)
				}
			}
		}

		//更新某个副本类型的红点  dun_type==0 更新所有的新资源副本
		this.UpdateNewMatrialRed = (scmd) => {
			if (!scmd) return
			let count_list = scmd.count_list
			for (let i = 0; i < count_list.length; i++) {
				let dun_type = count_list[i].dun_type

				let dun_data = this.GetCurDifficult(dun_type)
				if(dun_data[1] == BaseDungeonModel.TYPE_NEW_INLOCK)continue

				let role_lv = role_mgr.GetMainRoleVo() && role_mgr.GetMainRoleVo().level
				let data = this.GetDungeonInfo(dun_type)
				if (!data) continue
				let open = this.DungeonOpenCondition(dun_type)
				if (!open) continue
				if (data && data[0] && Number(data[0].level) <= role_lv) {
					//挑战次数
					let cha_times = this.GetAllDungeonChallengeTimes([dun_type])
					//扫荡次数
					let swp_times = this.GetAllDungeonSweepTimes([dun_type])

					if (cha_times <= 0 && swp_times <= 0) {
						this.dungeon_red_state[dun_type] = 0
					} else {
						this.dungeon_red_state[dun_type] = 1
					}
				}
			}
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 610)
		}

		//检查某个副本类型的红点  dun_type==0 检测所有的新资源副本
		this.CheckNewMatrialRed = (dun_type) => {
			if (dun_type != 0) {
				return this.dungeon_red_state[dun_type]
			} else {
				for (let key in this.dungeon_red_state) {
					if (this.dungeon_red_state[key] == 1) return true
				}
			}
			return false
		}

		/**检查某个副本是否开启 dun_id (只判断任务id和等级)
		 * @param dun_id    副本id
		 * 
		 */
		this.IsNewDungeonOpen = (dun_id) => {
			let tip_strs = []
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
			let data_vo = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
			let newest_finish_task_id = TaskModel.GetInstance().newest_finish_task_id
			if (data_vo && data_vo["condition"]) {
				let conds = ErlangParser.GetInstance().parse(data_vo["condition"])
				for (let i = 0; i < conds.length; i++) {
					let value
					switch (conds[i][0]) {
						case "task_id":
							value = Number(conds[i][1])
							if (newest_finish_task_id < value) {
								return false
							}
							break;
						case "lv":
							let role_lv = role_mgr.GetMainRoleLevel()
							value = Number(conds[i][1])
							if (role_lv < value) {
								return false
							}
							break;
						case "open_day":
							value = Number(conds[i][1])
							let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
							if (open_day < value) {
								return false
							}
							break;
					}
				}
			}

			return true
		}

		/***新资源副本开启提示
		 * 
		 * @param is_not_sub 是否不拼接所有条件 默认false
		 */
		this.GetNewDungeonOpenTips = (dun_id,is_not_sub?) => {
			let tip_strs = []
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
			let data_vo = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
			let newest_finish_task_id = TaskModel.GetInstance().newest_finish_task_id
			if (data_vo && data_vo["condition"]) {
				let conds = ErlangParser.GetInstance().parse(data_vo["condition"])

				//条件排序
				table.sort(conds,(a,b)=>{
					let value_a = 0
					if(a[0]=="task_id")value_a+=1000
					if(a[0]=="open_day")value_a+=100
					if(a[0]=="lv")value_a+=1


					let value_b = 0
					if(b[0]=="task_id")value_b+=1000
					if(b[0]=="open_day")value_b+=100
					if(b[0]=="lv")value_b+=1

					return value_a>value_b
				})

				for (let i = 0; i < conds.length; i++) {
					let value
					let is_break=false
					switch (conds[i][0]) {
						case "task_id":
							value = Number(conds[i][1])
							if (newest_finish_task_id < value) {
								let task_cfg = TaskModel.GetInstance().GetTaskCfg(value)
								if (task_cfg && task_cfg["main_line_order"] != null) {
									let str_1 = `【${task_cfg["main_line_order"]}】`
									//let str_1 = `【${value}】`
									table.insert(tip_strs, `任务${HtmlColorTxt(str_1, Enum_ColorUtil_Dark.ORANGE)}解锁`)
									if(is_not_sub){
										is_break=true
									}
								}
							}

							break;
						case "lv":
							let role_lv = role_mgr.GetMainRoleLevel()
							value = Number(conds[i][1])
							if (role_lv < value) {
								table.insert(tip_strs, `等级达到${TransformLevel(value)}级开启`)
								if(is_not_sub){
									is_break=true
								}
							}
							break;
						case "open_day":
							value = Number(conds[i][1])
							let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
							if (open_day < value) {
								table.insert(tip_strs, `开服${HtmlColorTxt(`【${value}天】`, Enum_ColorUtil_Dark.ORANGE)}解锁`)
								if(is_not_sub){
									is_break=true
								}
							}
							break;
					}


					if(is_break)break;
				}
			}

			let tip_str = tip_strs.join("且")
			return tip_str
		}

		/**获取到开启任务的 排列顺序 (从小到大)   主线任务>开服天数*/
		this.GetNewDungeonOpenTaskId = (dun_id) => {
			let tip_strs = []
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
			let data_vo = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
			if (data_vo && data_vo["condition"]) {
				let conds = ErlangParser.GetInstance().parse(data_vo["condition"])
				for (let i = 0; i < conds.length; i++) {
					let value

					//暂时没有兼容任务和开服天数一起的条件 偷个懒
					switch (conds[i][0]) {
						case "task_id":
							value = Number(conds[i][1])
							return value
						case "open_day":
							value = Number(conds[i][1])+500000
							return value
					}
				}
			}

			return 0
		}


		//#########组队状态下尝试进入单人副本的提示弹窗
		this.TryToEnterDungeon = (dun_id) => {
			let team_model = TeamModel.GetInstance()
			let team_info = team_model.team_info
			if (team_info) {

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
				let data_vo = local_Config.GetConfigVo(cfg_has_default_value.config_dungeon.name, dun_id, false, cfg)
				let dun_name_: String = data_vo && data_vo.name || "当前副本"
				let str = `组队状态下无法进入${HtmlColorTxt(dun_name_, Enum_ColorUtil_Dark.ORANGE)},<br>是否退出队伍并进入?`
				let ok_func = () => {
					// team_model.quit_team_match = team_info.activity_id;
					this.act_dun_type = dun_id
					team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005);
				}
				Alert.Show(Util.StrToHTML(str), Alert_Type.Two, ok_func)
				return false
			}
			return true
		}


		this.ActionforView = () => {
			if (this.act_dun_type != 0) {
				this.Fire(BaseDungeonModel.QUIT_DUNGEON_RETURN, this.act_dun_type)
				this.act_dun_type = 0
			}

		}


	}

	//#########组队状态下尝试进入单人副本的提示弹窗
	act_dun_type = 0
	TryToEnterDungeon
	ActionforView

	public CopperLevelImgUrl(level?) {
		let lv = level ? level : this.copperLeve

		let url = ""
		switch (lv) {
			case "S":
				url = "uijs_044"
				break
			case "A":
				url = "uijs_040"
				break
			case "B":
				url = "uijs_041"
				break
			case "C":
				url = "uipj_042"
				break
		}
		return url
	}

	public GetDungeonUnlockLv(dun_id?) {

		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false)
		let cond = ErlangParser.GetInstance().Parse(cfg.condition)
		let unlock_lv = 0
		for (let i = 0; i < cond.length; i++) {
			var v = cond[i]
			if ("lv" == v[0]) {
				unlock_lv = Number(v[1])
				break
			}
		}
		return unlock_lv
	}

	public IsCanEnterMainLineDungeon(show_tips?) {
		let main_role = Scene.Instance.GetMainRole()
		let bool = true
		let tips = ""
		if (main_role) {
			if (main_role.IsInState(PoseState.JUMP) || main_role.IsInState(PoseState.TASK_JUMP)) {
				bool = false
				tips = "跳跃中无法进入"
			}
		}
		if (show_tips && !bool) {
			Message.show(tips)
		}
		return bool
	}

	//初始化副本信息  获取该副本的坐标触发事件  该副本需要击杀的boss名字
	public InitDungeonInfo(dungeon_id?, ConfigDungeonClient?, config_dungeon_level?) {

		let cfg = null
		let curr_scene_id = SceneManager.Instance.GetSceneId()
		let is_level_dungeon = false //是否关卡副本
		if (ConfigDungeonClient.Dungeon_level_ids[dungeon_id]) {
			is_level_dungeon = true
			cfg = config_dungeon_level[dungeon_id + "@" + curr_scene_id]
		} else {
			is_level_dungeon = false
			cfg = config_dungeon_level[dungeon_id]
		}
		if (cfg) {
			this.request_trigger_monster_time = Status.NowTime
			this.enter_dungeon_time = Status.NowTime
			this.kill_all_monster_time = null
			let p1, p2, pos_x, pos_y, x_range, y_range, order = null
			let element_cfg = null
			for (let key in cfg) {
				var value = cfg[key]
				element_cfg = null
				if (is_level_dungeon) {
					if (typeof (value) == "string") {
						element_cfg = value
					}
				} else {
					if (typeof (value) == "object") {
						element_cfg = value[curr_scene_id]
					}
				}
				if (element_cfg) {
					p2 = -1
					while (p2) {
						// p1, p2, pos_x, pos_y, x_range, y_range, order = string.find(element_cfg, "%{role_pos%, -(%d+), -(%d+), -(%d+), -(%d+), -(%d+)", p2 + 1)
						if (p2) {
							// table.insert(this.role_pos_event_list, {
							// 		scene_id = curr_scene_id,
							// 		pos_x = Number(pos_x),
							// 		pos_y = Number(pos_y),
							// 		x_range = Number(x_range),
							// 		y_range = Number(y_range),
							// 		order = Number(order),
							// 		trigger_state = 1, //1未触发 2//正在触发  3//触发完成
							// 	})

							this.role_pos_event_list.push(
								{
									scene_id: curr_scene_id,
									pos_x: Number(pos_x),
									pos_y: Number(pos_y),
									x_range: Number(x_range),
									y_range: Number(y_range),
									order: Number(order),
									trigger_state: 1, //1未触发 2//正在触发  3//触发完成
								}
							)
						}
					}
				}
			}
		}
		var onSortFunction = (v1, v2) => {
			// return v1.order < v2.order
			return v1.order - v2.order
		}
		this.role_pos_event_list.sort(onSortFunction)
		// table.sort(this.role_pos_event_list, onSortFunction)
	}

	public ResetPosEventList(server_record_list?) {

		if (server_record_list && server_record_list.length > 0) {
			for (let i = 0; i < this.role_pos_event_list.length; i++) {
				var vo = this.role_pos_event_list[i]
				for (let j = 0; j < server_record_list.length; j++) {
					var vo2 = server_record_list[j]
					if (vo.pos_x == vo2.x && vo.pos_y == vo2.y) {
						vo.trigger_state = 3
						break
					}
				}
			}
		}
	}

	//成功触发坐标触发事件
	public SuccessTriggerRolePos(pos_x?, pos_y?) {

		for (let i = 0; i < this.role_pos_event_list.length; i++) {
			var vo = this.role_pos_event_list[i]
			if (Math.abs(pos_x - vo.pos_x) <= vo.x_range && Math.abs(pos_y - vo.pos_y) <= vo.y_range) {
				vo.trigger_state = 3
			} else if (vo.trigger_state == 2) {
				vo.trigger_state = 1
			}
		}
	}



	public TriggerFlushMonster(x?, y?) {

		this.Fire(BaseDungeonModel.SCMD_REQUEST, 61007, x, y)
		this.request_trigger_monster_time = Status.NowTime
	}

	//刷怪通知
	public RefreshMonster(dungeon_id?, scene_id?, type?, time?) {
		ResManager.GetInstance().LoadGameConfig(this, "config_dungeon_wave", false, null, (cfg) => {
			let refresh_vo, vo
			for (let i in cfg) {
				vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_wave.name, i, false, cfg)
				if (vo.dun_id == dungeon_id && vo.scene_id == scene_id && vo.type == type) {
					refresh_vo = {
						start_time: TimeUtil.getServerTime() + vo.refresh_time / 1000,
						// stay_time = time + vo.msg_time / 1000 + vo.msg_stay_time / 1000,
						// msg = vo.msg
					}
					// PrintTable(vo)
					// console.log("有人想出现刷怪提示 ",vo.refresh_time,vo.subtype)
					this.ChangeVar("refresh_monster_info", refresh_vo)
					this.Fire(BaseDungeonModel.SHOW_MOSTER_TIP, this.refresh_monster_info)
					break
				}
			}
			ResManager.GetInstance().DestoryGameConfig(this, "config_dungeon_wave", false)
		})
	}

	//获取某个波数怪物的刷新点
	public GetSpawnPoint(wave?, config_dungeon_wave?) {

		if (!wave) {
			wave = Math.max(this.curr_wave_num, 1)
			if (this.curr_wave_type && this.curr_wave_type > 0) {
				wave = this.curr_wave_type
			}
		}

		let curr_dungeon_id = SceneManager.Instance.GetCurrDunId()
		let curr_scene_id = SceneManager.Instance.GetSceneId()

		if (curr_dungeon_id == 0) { return } //0代表不是副本场景
		if (curr_scene_id <= 0) { return } //0不是真的场景

		let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_wave.name, `${curr_dungeon_id}@${curr_scene_id}@${wave}@1`, false, config_dungeon_wave)
		// let config = config_dungeon_wave[`${curr_dungeon_id}@${curr_scene_id}@${wave}@1`]
		if (!config) {
			// console.warn("没有配置怪物位置1  Config.Dungeonwave " + curr_dungeon_id + "@" + curr_scene_id + "@" + wave + "@1")
			return [0, 0, 0]
		}

		let mon_list = ErlangParser.GetInstance().Parse(config.mon_list)
		if (mon_list && mon_list.length > 0) {
			return [
				mon_list[0][1] / SceneObj.GetLogicRealRatio().x,
				mon_list[0][2] / SceneObj.GetLogicRealRatio().y,
				mon_list[0][0]
			]
		} else {
			// console.warn("没有配置怪物位置2  " + curr_dungeon_id)
		}
		return [0, 0, 0]
	}

	public ClearDungeonInfo() {

		this.role_pos_event_list = []
		this.refresh_monster_info = []
		this.curr_wave_type = 0
	}

	public static GetInstance() {
		if (!BaseDungeonModel.Instance) {
			new BaseDungeonModel()
		}
		return BaseDungeonModel.Instance
	}
}

export var DUN_TYPE =
{
	/**金币副本 */
	Material_Copper: 2,
	/**装备副本 */
	Equip: 5,
	/***/
	Soul: 8,
	/**专属大妖 */
	Vip_Rerson_Boss: 10,
	/***/
	GuildGuard: 11,
	/**御魂副本 */
	Rune: 12,
	/**姻缘副本 */
	Marriage: 13,
	/***/
	LOVE: 13,
	ReincarnationDun: 16,
	/**侍魂副本 */
	Material_Mount: 18,
	Material_Partner: 19,
	Exp: 20,
	Main_Line: 21,
	Material_WING: 22,
	/***/
	Tower: 24,
	/***/
	SevenDayChallenge: 25,
	/***/
	Unreal: 26,
	MonsterInvasion: 27,
	Boss_Guide_One: 29,
	Boss_Guide_Two: 30,
	/**魂殿觉醒 */
	Heart: 31,
	/**龙纹副本 */
	Dragon: 32,
	Pet: 33,
	AdvancedExp: 34,
	/**天境副本 */
	SingleRank: 35,
	/***/
	Polar: 36,
	/**神巫副本 */
	Partner: 37,
	/**日常副本 */
	Daily: 38,
	/**新主线副本 */
	New_Main_Line: 39,
	/**限时爬塔 */
	TOWER_LIMIT: 40,
	/**众生之门 */
	SentientAct: 41,
	/**资源副本 坐骑 */
	NEW_MOUNT: 42,
	/**资源副本 翅膀 */
	NEW_WING: 43,
	/**资源副本 御守 */
	NEW_AMULET: 44,
	/**资源副本 神兵 */
	NEW_WEAPON: 45,
	/**资源副本 背饰 */
	NEW_BACK_ORNAMENT: 46,
	/**百鬼夜行 */
	GHOST_WALK: 57,
}

window["DUN_TYPE"] = DUN_TYPE
export var DUN_COFIG =
{
	Client: 0,
	UiTab: 1,
	MainLineReward: 2,
	MainLineSweep: 3,
	MainLineHangOn: 4,
	MainLineSealCount: 5,
	MainLineExpAddRadio: 6,
	Time: 7,
	Wave_Helper: 8,
	Special: 9,
	LearnSkill: 10
}
window["DUN_COFIG"] = DUN_COFIG
export var DUN_SET_TYPE =
{
	Com: 1,
	Diamond_Inspire: 2,
	Use: 3,
	Coin_Inspire: 4
}
window["DUN_SET_TYPE"] = DUN_SET_TYPE
export var DungeonResultType = {
	Default: 0,
	Sweeping: 1,
	Exp: 2,
	Soul: 3,
	AdvancedExp: 4
}
window["DungeonResultType"] = DungeonResultType
export var DungeonLoadindType = [ //开始需要发协议的副本类型
	DUN_TYPE.Rune,
	DUN_TYPE.Partner,
	DUN_TYPE.Dragon,
	DUN_TYPE.Heart,
	DUN_TYPE.Equip,
	DUN_TYPE.Polar,
	DUN_TYPE.SingleRank,
]
window["DungeonLoadindType"] = DungeonLoadindType
export var DungeonEnterViewIndex = {
	Material: 1,
	Rune: 0,
	Exp: 2,
	Equip: 3,
	Dragon: 4,
	DungeonPartner: 5,
	SingleRank: 6
}

window["BaseDungeonModel"] = BaseDungeonModel

