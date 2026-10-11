import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ParticleManager } from "../particalEffect/ParticleManager"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { MonsterType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameError } from "../util/GameError"
import { GameMath } from "../util/GameMath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { CustomActivityDefine } from "./CustomActivityDefine"
import { CustomActivityModel } from "./CustomActivityModel"
import { GoodsModel } from "./GoodsModel"
import { ShopModel } from "./ShopModel"
import { TaskModel, TaskType } from "./TaskModel"
import { TeamEvent, TeamModel } from "./TeamModel"
import { VipModel } from "./VipModel"
import { HolyTerritoryModel, HTEvent } from "./HolyTerritoryModel"
import { CrossServerViewIndex } from "../commonController/BossController"
import { MainUIController } from "../commonController/MainUIController"
import { KfHolyAreaModel } from "./KfHolyAreaModel"
import { EternityModel } from "./EternityModel"
import { FightManager } from "../scene/fight/FightManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { KaifuActivityModel } from "./KaifuActivityModel"
import { OpenFun } from "../common/OpenFun"


export class BossModel extends EventDispatcher {

	public static SCMD_REQUEST = "B.SCMD_REQUEST"
	public static UPDATE_BOSS_INFO = "B.UPDATE_BOSS_INFO"
	public static OPEN_BOSS_RESULT_VIEW = "B.OPEN_BOSS_RESULT_VIEW"
	public static OPEN_REBORN_TIPS_VIEW = "B.OPEN_REBORN_TIPS_VIEW"
	public static CLOSE_REBORN_TIPS_VIEW = "B.CLOSE_REBORN_TIPS_VIEW"
	public static OPEN_TIPS_VIEW = "B.OPEN_TIPS_VIEW"
	public static KILL_BOSS = "B.KILL_BOSS"
	public static FINDWAY_INDEX = "B.FINDWAY_INDEX"
	public static CHANGE_BOSS_TARGET = "B.CHANGE_BOSS_TARGET"
	public static UPDATE_PLAYER_NUM = "B.UPDATE_PLAYER_NUM"
	public static UPDATE_ER_TIRED_VALUE = "B.UPDATE_ER_TIRED_VALUE"
	public static PUSH_MSG = "B.PUSH_MSG"
	public static REFRESH_CROSS_SERVER_LIST = "B.REFRESH_CROSS_SERVER_LIST"
	public static SHOW_FEASE_BOSS_END_TIME = "B.SHOW_FEASE_BOSS_END_TIME"
	public static SHOW_FEASE_BOSS_NEXT_WAVE_TIME = "B.SHOW_FEASE_BOSS_NEXT_WAVE_TIME"
	public static UPDATE_REMIND_STATE = "B.UPDATE_REMIND_STATE"
	public static OPEN_DROP_RECORD_VIEW = "B.OPEN_DROP_RECORD_VIEW"
	public static OPEN_MYSTERY_BOSS_REWARD_VIEW = "B.OPEN_MYSTERY_BOSS_REWARD_VIEW"
	public static DROPRECORDDATA_RETURN = "B.DROPRECORDDATA_RETURN"
	public static OPEN_BOSSBELONGBOX_VIEW = "B.OPEN_BOSSBELONGBOX_VIEW"
	public static CLOSE_BOSSBELONGBOX_VIEW = "B.CLOSE_BOSSBELONGBOX_VIEW"
	public static OPEN_ABYSS_FAILURE_VIEW = "B.OPEN_ABYSS_FAILURE_VIEW"
	public static UPDATE_BELONG_BOX_VIEW = "UPDATE_BELONG_BOX_VIEW"
	public static OPEN_RELIVE_TRIED_VIEW = "B.OPEN_RELIVE_TRIED_VIEW"
	public static SHOW_RELIVE_TIRED_ICON = "B.SHOW_RELIVE_TIRED_ICON"
	public static OPEN_DROP_PROGRESS_VIEW = "B.OPEN_DROP_PROGRESS_VIEW"
	public static OPEN_KILL_RECORD_VIEW = "B.OPEN_KILL_RECORD_VIEW"
	public static OPEN_BOSS_TIRED_ALERT = "B.OPEN_BOSS_TIRED_ALERT"
	public static GOODS_HAVE_PICKING = "B.GOODS_HAVE_PICKING"
	public static KILL_RECORD_DATA_RETURN = "B.KILL_RECORD_DATA_RETURN"
	public static NEW_KILL_RECORD = "B.NEW_KILL_RECORD"
	public static UPDATE_MON_POS = "B.UPDATE_MON_POS"
	public static FEAST_BOSS_END = "B.FEAST_BOSS_END"
	public static UPDATE_MYSTERY_BOSS_REWARD = "B.UPDATE_MYSTERY_BOSS_REWARD"
	public static GET_MYSTERY_BOSS_REWARD_SUCCESS = "B.GET_MYSTERY_BOSS_REWARD_SUCCESS"
	public static SHOW_WAY_FINDING_PANEL = "B.SHOW_WAY_FINDING_PANEL"
	public static START_SPECIAL_BOSS_OR_BOX_FIND = "B.START_SPECIAL_BOSS_OR_BOX_FIND"
	public static UPDATE_SELECT_BOSS_INFO = "B.UPDATE_SELECT_BOSS_INFO"
	public static ENTER_DOMAINBOSS = "B.ENTER_DOMAINBOSS"
	public static DOMAINBOSS_DATA_RETUEN = "B.DOMAINBOSS_DATA_RETUEN"
	public static DOMAINBOSS_LIKE_RETURN = "B.DOMAINBOSS_LIKE_RETURN"
	public static DOMAINBOSS_ROLE_RANK_RETURN = "B.DOMAINBOSS_ROLE_RANK_RETURN"
	public static DOMAINBOSS_BUY_TIME_RETURN = "B.DOMAINBOSS_BUY_TIME_RETURN"
	public static DOMAINBOSS_EXIT_TIME = "B.DOMAINBOSS_EXIT_TIME"
	public static DOMAINBOSS_RELIVE_TIME = "B.DOMAINBOSS_RELIVE_TIME"
	public static DOMAINBOSS_SELECT_CHECKBOX = "B.DOMAINBOSS_SELECT_CHECKBOX"
	public static UPDATE_BOSS_HP = "B.UPDATE_BOSS_HP"
	public static UPDATE_HUNTING_INFO = "B.UPDATE_HUNTING_INFO"
	public static UPDATE_EUDAEMON_RANK = "UPDATE_EUDAEMON_RANK"
	public static UPDATE_EUDAEMON_RED = "UPDATE_EUDAEMON_RED"
	public static COLLECT_BOX = "COLLECT_BOX"
	public static UPDATE_WAR_FREE_TIME = "UPDATE_WAR_FREE_TIME"
	public static ADD_BOSS_USE_COUNT = "ADD_BOSS_USE_COUNT"
	public static UPDATE_WAR_FREE_VIEW = "UPDATE_WAR_FREE_VIEW"
	public static CHANGE_WINDOW_BG = "CHANGE_WINDOW_BG"
	public static SELECT_TASK_ITEM = "SELECT_TASK_ITEM"
	public static SHOW_DAMAGE = "SHOW_DAMAGE"
	public static DOMAIN_MODULE_ID = 471//幻域BOSS模块ID
	public static FORCE_SHOW_TASK = "FORCE_SHOW_TASK"
	public static SELECT_TASK_TEAM_VIEW = "SELECT_TASK_TEAM_VIEW"
	public static UPDATE_VIT_TIME = "UPDATE_VIT_TIME"
	public static OPEN_VIT_VIEW = "OPEN_VIT_VIEW"
	public static FEAST_BOSS_ACT_INFO = "FEAST_BOSS_ACT_INFO"
	public static FEAST_BOSS_COLLECT_NO_TIMES = "FEAST_BOSS_COLLECT_NO_TIMES"
	public static VIP_PERSON_BOSS_kill = "VIP_PERSON_BOSS_kill"
	public static UPDATE_ABYSS_BOSS_RED = "UPDATE_ABYSS_BOSS_RED"//大妖之境红点
	public static UPDATE_EDU_BOSS_RED = "UPDATE_ABYSS_BOSS_RED"//蜃气楼boss
	public static BOSS_FIELD_BACK_VIT_UPDATE = "UPDATE_ABYSS_BOSS_RED"//世界boss体力找回
	public static BOSS_EUDA_BOSS_UPDATE_VIEW = "BOSS_EUDA_BOSS_UPDATE_VIEW"//蜃气楼boss更新页面
	public static BOSS_EUDA_UPDATE_BOSS_ROOM = "BOSS_EUDA_UPDATE_BOSS_ROOM"//蜃气楼boss 更新选中
	public static BOSS_EUDA_REMIAN_UPDATE = "BOSS_EUDA_REMIAN_UPDATE"//蜃气楼boss 关注更新

	public static cross_boss_base_index = 1000
	/**跨服圣域boss没有携带boss_type属性，这里为了创建墓碑怪，定义为900 */
	public static GRAVE_KF_HOLY_BOSS_TYPE = 900
	/**永恒圣殿/天启之源boss没有携带boss_type属性，这里为了创建墓碑怪，定义为901 */
	public static GRAVE_ETERNITY_BOSS_TYPE = 901
	public static FEAST_BOSS_ID = 51
	public static Index = {
		Field_Boss: 0,
		Abyss_Boss: 1,
		Vip_Person_Boss: 2,
		Suit_Boss: 3,
		Dragon_Boss: 4,
		World_Boss: 9999,
		Secret_Boss: 99999
	}

	public static BossType = {
		suit: 4,//蛮荒
		abyss: 7,//大妖之境
		secret: 9,//秘境boss-旧
		eudaemon: 10,//圣兽岭/蜃气楼
		feast: 11,//节日boss
		field: 12,//世界boss
		fieldspecial: 13,//世界boss特殊层
		holyterritory: 14,//圣域(领地)boss
		mystery: 20,//秘境领域boss  本服16  跨服20
		domainserver: 17,// 幻域BOSS 服务端类型
		holy_wuxian: 18, //
		field_infinite: 19,//世界boss 单人无限层

		//跨服
		holy: 1 + BossModel.cross_boss_base_index,
		domain: 471// 幻域BOSS
	}

	public static BaseBossSceneId = {
		[7]: 22100,
		[4]: 23100,
		[11]: 32001,
		[12]: 34100,
		[13]: 35000,//野外BOSS特殊层
		[14]: 36000,//圣域(领地)boss
		[16]: 43000,//秘境boss
		[18]: 12004,//蜃气楼无限层
		[19]: 56000,//世界boss无限层
		[20]: 58000,//跨服秘境大妖
		[1001]: 12000  //蜃气楼
	}

	/**用于创建墓碑怪  [场景类型]:BossType  */
	public static GetBossTypeBySceneType = {
		[12]: 1 + BossModel.cross_boss_base_index,  //蜃气楼
		[16]: 4, //蛮荒大妖
		[22]: 7, //boss之家
		[34]: 12,//世界boss
		[35]: 13,//世界boss特殊层
		[36]: 14,//本服异域
		[38]: BossModel.GRAVE_KF_HOLY_BOSS_TYPE,
		[43]: 16,//秘境领域boss
		[44]: BossModel.GRAVE_ETERNITY_BOSS_TYPE, //天启之源
		[54]: 18,//蜃气楼无限层
		[56]: 19,//世界boss 单人无限层
		[58]: 20,//跨服秘境大妖
	}


	public static CrossServerBossCond = { open_lv: 320, open_day: 8 }
	public static Field_Refresh_Red_Vit = 100
	public static Field_Refresh_Red_Level = 120
	public static tired_goods_id = 38160001
	public static domian_goods_id = 38290001
	public static belong_time = 90

	//幻兽岭
	public static eudaemon_base_scene_id = 2100
	public static C_BOX_TYPE = 1
	public static S_BOX_TYPE = 2
	public static CRYSTAL_TYPE = 3
	public static NOT_EUDA_SHOP_ALERT = false


	/**普通boss */
	public static MYSTERY_NORMAL_BOSS_TYPE = 0
	/**毁灭领主 */
	public static MYSTERY_SPECIAL_BOSS_TYPE = 1
	/**普通宝箱 */
	public static MYSTERY_BOX_TYPE = 2
	/**金箱子 */
	public static MYSTERY_SUPER_BOX_TYPE = 3

	//世界大妖无限层
	public static BOSS_FIELD_INFINITE = 56001


	public static FIELD_BOSS_GUIDE_TASK_ID = 101200
	public static FIELD_BOSS_GUIDE_TASK_ID2 = 101481

	//boss 通用等级碾压
	public static HIGT_LEVEL_TIPS_VALUE = 150

	//世界boss 等级碾压
	public static FIELD_HIGT_LEVEL_TIPS_VALUE = 50

	erlang_parser: ErlangParser
	game_error: GameError
	particle_mgr: ParticleManager
	activity_icon_mgr: ActivityIconManager
	scene: Scene
	scene_mgr: SceneManager
	common_mgr: CommonManager
	role_mgr: RoleManager
	goods_model: GoodsModel
	vip_model: VipModel
	server_time_model: ServerTimeModel
	task_model: TaskModel
	res_mgr: ResManager

	feast_boss_timer_id
	bos_drop
	box_data
	member_dead_pos
	suit_mon_list
	suit_boos_red = false
	mystery_boss_red = false
	mystery_boss_cost_list
	war_free_end_time
	boss_die_effect_dic = []
	dungeon_monster_dead_pos
	boss_result_info
	find_list_drop = []
	buff_timer
	boss_relive_ti_red_timer
	boss_relive_ti_red_time = 0
	need_field_return = false
	need_field_special_return = false
	need_field_infinite_return = false
	hunting_level_data
	near_drop_time_out
	pick_up_boss_drop_vo_dic = []
	time_id
	time_func
	drop_timer
	tips_timer
	holy_buff_timer
	boss_info = {}
	enter_boss_info
	field_boss_red
	domain_boss_red = false
	vit_data = []
	suit_boss_alert = false
	suitboss_attention_num = 0
	is_owner_snatch = false
	abyss_cost_alert = false
	need_relive_snatch = false
	eudaemon_ridge_alert = false
	remount_info
	auto_relive = false
	reconnect = false
	suit_boss_first_status = true
	has_show_challenge_dot = false
	domain_alert = false
	drop_dic = []
	kill_record_red = false
	timer_dic = []
	timer_mark_dic = []
	domain_unfollow_dic = {}
	auto_pick_up = false
	pickUping = false
	killer_vo
	eudaemon_has_click = false
	red_list = []
	get_eudamon_task = false
	find_cry_stal = false
	do_main_select_boss_id = 0
	role_rank_list = []
	role_rank_length = 5
	domain_sel_alert = false
	pick_up_mon = []
	feast_boss_box_map = {}
	doMian_boss_relive_time
	drop_record_data
	kill_record
	boxs_pos
	feast_boss_scene_can_not_collect_mon_id
	holy_relive_data
	mystery_boss_reward
	need_hide_box_list
	do_main_data
	domain_boss_enter_type
	exit_call_back
	feast_boss_nect_wave_time
	cross_server_data

	last_scene_id
	doMainSelectBossId
	do_main_sel_alert
	/** 保持MainUITaskTeamView面板不关闭，任务面板切换成寻路面板 */
	main_ui_setting_flag
	show_damage_boss_ins_id
	reborn_tip_info = []
	reborn_tip_dir = {}

	init_field_infinite_proto_state

	static Instance: BossModel
	public constructor() {
		super()
		this.erlang_parser = ErlangParser.GetInstance()
		this.game_error = GameError.Instance
		this.particle_mgr = ParticleManager.GetInstance()
		this.activity_icon_mgr = ActivityIconManager.GetInstance()
		this.scene = Scene.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.common_mgr = CommonManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.vip_model = VipModel.GetInstance()
		this.server_time_model = ServerTimeModel.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.doMainSelectBossId = 0
		this.do_main_sel_alert = false
	}

	public static GetInstance() {
		if (!BossModel.Instance) {
			BossModel.Instance = new BossModel()
		}
		return BossModel.Instance
	}

	public static GetShowModelCfg(boss_type, mon_res, boss_cfg) {
		if (!boss_cfg) {
			return
		}
		let show_cfg = boss_cfg.BossUITrans
		return show_cfg && show_cfg[boss_type] && show_cfg[boss_type][mon_res]
	}

	/**
	 * 设置boss信息
	 * @param vo 当前boss信息
	 * @param eudemons_boss_cfg 圣兽领boss配置
	 * @param boss_cfg boss配置
	 * @param boss_type_cfg boss类型配置
	 */
	SetBossInfo = (vo, eudemons_boss_cfg, boss_cfg, boss_type_cfgs) => {
		let boss_cfgs = null, config_name
		if (this.IsCrossServerBoss(vo.boss_type)) {
			boss_cfgs = eudemons_boss_cfg
			config_name = Config.ConfigHasDefaultValue.config_boss_cfg.name
		}else if(vo.boss_type == BossModel.BossType.mystery){
			boss_cfgs = Config.PRELOAD_SERVER_CONFIG.config_kf_great_demon
			config_name = Config.ConfigHasDefaultValue.config_kf_great_demon.name
		} else {
			boss_cfgs = boss_cfg
			config_name = Config.ConfigHasDefaultValue.config_boss_cfg.name
		}
		for (let _tmpi in vo.boss_info) {
			let boss = vo.boss_info[_tmpi]
			let boss_cfg = Config.GetConfigVo(config_name, boss.boss_id, false, boss_cfgs)
			let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss.boss_id, false)
			let condition = boss_cfg && boss_cfg.condition
			let open_lv = 0
			let max_lv = 999999
			let enter_vip = 0
			if (condition) {
				let list =[]
				if(vo.boss_type == BossModel.BossType.mystery){
					list = this.erlang_parser.Parse(condition)
				}else{
					list = JSON.parse(condition)//this.erlang_parser.Parse(condition)
				}
				for (let _tmpi in list) {
					let v = list[_tmpi]
					if (v[0] == "lv") {
						open_lv = Number(v[1])
					}
					if (v[0] == "max_lv") {
						max_lv = Number(v[1])
					}
					if (v[0] == "vip") {
						enter_vip = Number(v[1])
					}
				}
			}
			boss.open_lv = open_lv
			boss.max_lv = max_lv
			boss.enter_vip = enter_vip

			let free_vip = -1
			let free_condition = boss_cfg && boss_cfg.free_condition
			if (free_condition) {
				let list = JSON.parse(free_condition)//this.erlang_parser.Parse(free_condition)
				for (let _tmpi in list) {
					let v = list[_tmpi]
					if (v[0] == "vip") {
						free_vip = Number(v[1])
					}
				}
			}
			boss.free_vip = free_vip
			let cost = boss_cfg && boss_cfg.cost
			let enter_cost = null
			if (cost) {
				let list = JSON.parse(cost) //this.erlang_parser.Parse(cost)
				if (list.length > 0) {
					enter_cost = list
				}
			}
			boss.enter_cost = enter_cost
			boss.layer = boss_cfg && boss_cfg.layers
			boss.mon_type = boss_cfg && boss_cfg.mon_type
			boss.limit_num = boss_cfg && boss_cfg.num
			boss.ratio_goods = boss_cfg && boss_cfg.ratio_goods
			boss.icon = mon_cfg && mon_cfg.icon
			boss.boss_name = mon_cfg && mon_cfg.name
			boss.lv = mon_cfg && mon_cfg.lv
			boss.anger = mon_cfg && mon_cfg.anger
			boss.ui_scale = boss_cfg && boss_cfg.ui_scale
			boss.drop_lv = boss_cfg && boss_cfg.drop_lv
			boss.sign = boss_cfg && boss_cfg.sign
			boss.boss_type = vo.boss_type
			boss.is_remind = boss.is_remind == 1 && true || false
			boss.tired_add = boss_cfg && boss_cfg.tired_add || 0
			boss.arrow_num = boss_cfg && boss_cfg.arrow_num || 0
			boss.item_hightlight = boss_cfg && boss_cfg.item_hightlight || []
		}

		vo.boss_info.sort((a, b) => {
			if (a.open_lv == b.open_lv) {
				if (a.lv && b.lv) {
					return a.lv < b.lv
				}
			} else {
				return a.open_lv < b.open_lv
			}
		})

		if (vo.boss_type == BossModel.BossType.mystery) {
			let boss_type_cfg = boss_type_cfgs[vo.boss_type]
			vo.all_tired = boss_type_cfg && boss_type_cfg.max_anger || 100
		}
		this.boss_info[vo.boss_type] = vo

		if (this.need_field_return && vo.boss_type == BossModel.BossType.field) {
			this.need_field_return = false
			this.TipsTimerReturn()
		} else if (this.need_field_special_return && vo.boss_type == BossModel.BossType.fieldspecial) {
			this.need_field_special_return = false
			this.TipsTimerReturn()
		}
		else if (this.need_field_infinite_return && vo.boss_type == BossModel.BossType.field_infinite) {
			this.need_field_infinite_return = false
			this.TipsTimerReturn()
		}

	}

	GetBossInfo = (boss_type?, boss_id?) => {
		let vo = this.boss_info[boss_type]
		if (vo) {
			for (let _tmpi in vo.boss_info) {
				let value = vo.boss_info[_tmpi]
				if (value.boss_id == boss_id) {
					return value
				}
			}
		}
	}

	GetBossTypeInfo = (boss_type?) => {
		return this.boss_info[boss_type]
	}

	SetBossTypeInfo = (boss_type?, boss_info?) => {
		this.boss_info[boss_type] = boss_info
	}

	SetWarFreeTime = (time?) => {
		this.war_free_end_time = time
	}

	GetWarFreeTime = () => {
		return this.war_free_end_time
	}

	GetBossTypeCondition = (boss_type, boss_type_cfg?) => {
		let type_cfgs = null
		// if (this.IsCrossServerBoss(boss_type) ) {
		// 	type_cfgs = Config.PRELOAD_SETVER_CONFIG.config_eudemons_boss_type
		// }else{
		type_cfgs = boss_type_cfg
		// }
		let type_cfg = type_cfgs[boss_type]
		if (type_cfg) {
			let cond = type_cfg.condition
			let list = JSON.parse(cond) // this.erlang_parser.Parse(cond)
			let vip = 0
			let lv = 1
			for (let _tmpi in list) {
				let value = list[_tmpi]
				if (value[0] == "lv") {
					lv = Number(value[1])
				} else if (value[1] == "vip") {
					vip = Number(value[1])
				}
			}
			return [lv, vip]
		}
		return [false, 0]
	}

	GetBossKeyValue = (boss_type, key_name, config_boss_type_key_value) => {
		let cfg = config_boss_type_key_value
		let key = boss_type + "@" + key_name
		let value = cfg[key]
		if (value) {
			return value.value
		}
	}

	SetMemberDeadPos = (pos?) => {
		this.member_dead_pos = pos
	}

	GetMemberDeadPos = () => {
		return this.member_dead_pos
	}

	SetEnterBossInfo = (enter_boss_info?) => {
		this.enter_boss_info = enter_boss_info
	}

	GetEnterBossInfo = () => {
		return this.enter_boss_info
	}

	SetBossRebornTime = (boss_type?, boss_id?, time?) => {
		let list = this.GetBossTypeInfo(boss_type)
		if (list) {
			let boss_info = list.boss_info
			for (let _tmpi in boss_info) {
				let data = boss_info[_tmpi]
				if (data.boss_id == boss_id) {
					data.reborn_time = time
					break
				}
			}
			this.boss_info[boss_type] = list
		}

		//更新红点
		switch (boss_type) {
			case BossModel.BossType.abyss:
				this.UpdateBossAbyssRed()
				break
			case BossModel.BossType.holy:
				this.UpdateEduRed()
				break
		}

	}

	IsCrossServerBoss = (boss_type?) => {
		return boss_type && Number(boss_type) >= BossModel.cross_boss_base_index
	}

	GetBossPos = (boss_id, boss_type, config_eudemons_boss_cfg, config_boss_cfg) => {
		let bossVo = null
		let pos = null
		if (boss_type && this.IsCrossServerBoss(boss_type)) {
			bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, boss_id, false, config_eudemons_boss_cfg)
			let list = JSON.parse(bossVo.fixed_xy)[0] //this.erlang_parser.Parse(bossVo.fixed_xy)[1]
			pos = { x: list[0], y: list[1] }
		} else if (boss_type == BossModel.BossType.mystery && (this.IsBoxByBossId(boss_id) || this.IsSpecialBoss(boss_id))) {
			let pos_list = this.GetBoxsPos(boss_id, BossModel.BossType.mystery)
			if (pos_list) {
				let index = Util.RandomRange(1, pos_list.length)
				pos = pos_list[index]
			}
		} else {
			bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
			if (bossVo) {
				pos = { x: bossVo.x, y: bossVo.y }
			} else {
				this.game_error.SendErrorToPHP("BossModel can ! find boss cfg. id is = " + boss_id)
			}
		}
		return pos
	}

	ShowBossDieEffect = (boss_id?, show?, pos?) => {
		let effect_id = this.boss_die_effect_dic[boss_id]
		if (show) {
			if (effect_id || !pos) {
				return
			}
			effect_id = this.particle_mgr.AddPosEffect("scene_ghost", pos, true, null, null, false, null, null, 2, true)
			this.boss_die_effect_dic[boss_id] = effect_id
		} else {
			if (effect_id) {
				this.particle_mgr.DelEffect(effect_id)
			}
		}
	}

	CleanBossDieEffect = () => {
		for (let key in this.boss_die_effect_dic) {

			if (this.boss_die_effect_dic.hasOwnProperty(key)) {
				let effect_id = this.boss_die_effect_dic[key]
				this.particle_mgr.DelEffect(effect_id)
			}
		}
		this.boss_die_effect_dic = []
	}

	NeedHideBoxList = (ins_id?) => {
		let hide = false
		if (this.need_hide_box_list) {
			for (let _tmpi in this.need_hide_box_list) {
				let vo = this.need_hide_box_list[_tmpi]
				if (ins_id == vo.box_id) {
					hide = true
					break
				}
			}
		}
		return hide
	}

	GetFeastBossTime = (base_type?, sub_type?) => {
		let act_info = CustomActivityModel.GetInstance().GetActInfo(base_type, sub_type)
		let is_in_activity_time = false
		let left_time = 0
		let next_open_time = 0
		let next_open_time_sec = 0
		if (act_info) {
			let show_time = null
			let time_arr = null
			let condition = ErlangParser.GetInstance().Parse(act_info.condition) //this.erlang_parser.Parse(act_info.condition)
			if (condition) {
				for (let _tmpi in condition) {
					let vo = condition[_tmpi]
					if (vo[0] == "show_time") {
						show_time = Number(vo[1])
					} else if (vo[0] == "time") {
						time_arr = vo[1]
					}
				}
			}
			if (time_arr) {
				//let curTime = TimeUtil.getServerTime()
				let curTime = TimeUtil.GetZoneTime()
				if (curTime >= act_info.stime && curTime < act_info.etime) {
					let date = new Date(curTime * 1000)
					let hour = date.getHours()
					let minutes = date.getMinutes()
					let sec = date.getSeconds()
					for (let _tmpi in time_arr) {
						let vo = time_arr[_tmpi]
						if (hour >= Number(vo[0][0]) && hour <= Number(vo[1][0])) {
							let hour_gap = Number(vo[1][0]) - Number(vo[0][0])
							let min_gap = Number(vo[1][1]) - Number(vo[0][1])
							let sec_gap = Number(vo[1][2]) - Number(vo[0][2])
							let all_sce_time = hour_gap * 60 * 60 + min_gap * 60 + sec_gap
							let now_hour_gap = hour - Number(vo[0][0])
							let now_min_gap = minutes - Number(vo[0][1])
							let now_sec_gap = sec - Number(vo[0][2])
							let now_all = now_hour_gap * 60 * 60 + now_min_gap * 60 + now_sec_gap
							if (now_all > 0 && now_all <= all_sce_time) {
								left_time = all_sce_time - now_all + TimeUtil.getServerTime()
								is_in_activity_time = vo
								break
							}
						}
					}
					if (is_in_activity_time) {
					} else {
						let call_down_time = 0
						for (let _tmpi in time_arr) {
							let vo = time_arr[_tmpi]
							let vo_time = Number(vo[0][0])
							let vo_time2 = Number(vo[0][1])
							let vo_time3 = Number(vo[0][2])
							if (hour < vo_time ||
								(hour == vo_time && minutes < vo_time2 ||
									(hour == vo_time && minutes == vo_time2) && sec < vo_time3)
							) {
								next_open_time = vo[0]
								let now_hour_gap = vo_time
								let now_min_gap = vo_time2
								let now_sec_gap = vo_time3
								date.setHours(0)
								date.setMinutes(0)
								date.setSeconds(0)
								let base_time = Math.round(date.getTime() / 1000) //Mathf.Round(os.time(date) / 1000)
								next_open_time_sec = base_time + now_hour_gap * 60 * 60 + now_min_gap * 60 + now_sec_gap
								break
							}
						}
					}
				}
			}
		}
		let list = [is_in_activity_time, left_time, next_open_time, next_open_time_sec]
		this.timer_mark_dic[base_type] = sub_type
		this.timer_dic[base_type * 1000 + sub_type] = list
		return [is_in_activity_time, left_time, next_open_time, next_open_time_sec]
	}

	FeastBossActivity = (base_type?, sub_type?) => {
		if (Util.TableSize(this.timer_mark_dic) <= 0) {
			this.CancelTimer()
		}
		let [is_in_activity_time, left_time, next_open_time, next_open_time_sec] = this.GetFeastBossTime(base_type, sub_type)

		let icon_id = CustomActivityDefine.AdvanceIcon[base_type]
		if (is_in_activity_time) {
			let info = this.activity_icon_mgr.getIconInfo(icon_id)
			if (info && info.data) {
				info.data.count_down_time = true
			}
			this.activity_icon_mgr.addIcon(icon_id, left_time)
		} else {
			if (next_open_time && typeof (next_open_time) == "object") {
				
				
				let str = "即将开启"
				if (next_open_time && typeof (next_open_time) == "object") {
					let min = Number(next_open_time[1]) >= 10 && Number(next_open_time[1]) || `0${next_open_time[1]}`
					str = next_open_time[0] + ":" + min + "开启"
				}
				if (!this.activity_icon_mgr.getIconInfo(icon_id)) {
					this.activity_icon_mgr.addIcon(icon_id, null, null, str)
					GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, str, "#fe1a1a")
				} else {
					GlobalEventSystem.Fire(ActivityIconManager.SET_ICON_TEXT, icon_id, str, "#fe1a1a")
				}
				let curTime = TimeUtil.getServerTime()
				if (next_open_time_sec > curTime) {
					this.StartFeastTimer()
				}
			} else {
				this.activity_icon_mgr.deleteIcon(icon_id)
			}
		}
		this.Fire(BossModel.FEAST_BOSS_ACT_INFO)
	}

	NeedDeleteFeastBossIcon = (base_type?) => {
		let call_back = () => {
			let sub_type = this.timer_mark_dic[base_type]
			if (base_type && sub_type) {
				this.FeastBossActivity(base_type, sub_type)
			}
		}
		setTimeout(call_back, 2)
	}

	StartFeastTimer = () => {
		if (Util.TableSize(this.timer_mark_dic) <= 0) {
			this.CancelTimer()
		}
		if (!this.feast_boss_timer_id) {
			let loop_func = () => {
				let curTime = TimeUtil.getServerTime()
				for (let base_type in this.timer_mark_dic) {

					let sub_type = this.timer_mark_dic[base_type]
					let key = Number(base_type) * 1000 + sub_type
					let a = this.timer_dic[key][1],
						b = this.timer_dic[key][2],
						c = this.timer_dic[key][3],
						next_open_time_sec = this.timer_dic[key][4]

					if (next_open_time_sec - curTime <= -2) {
						this.timer_mark_dic[base_type] = null
						this.timer_dic[key] = null
						this.FeastBossActivity(base_type, sub_type)
					}
				}
			}

			this.feast_boss_timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				loop_func()
			}, 1. - 1)
		}
	}

	CancelTimer = () => {
		if (this.feast_boss_timer_id) {
			GlobalTimerQuest.CancelQuest(this.feast_boss_timer_id)
			this.feast_boss_timer_id = null
		}
	}

	GetBoxDrop = (config_boss_type_key_value) => {
		if (!this.bos_drop) {
			let value = this.GetBossKeyValue(11, "feast_boss_collect_reward", config_boss_type_key_value)
			if (value) {
				this.bos_drop = []
				value = JSON.parse(value) //this.erlang_parser.Parse(value)
				if (value) {
					for (let _tmpi in value) {
						let vo = value[_tmpi]
						let obj = null
						obj = []
						obj.type = vo[0]
						obj.type_id = vo[1]
						obj.count = vo[2]
						table.insert(this.bos_drop, obj)
					}
				}
			}
		}
		return this.bos_drop
	}

	ShowBosDrop = (ins_id?) => {
		if (ins_id) {
			let monster = this.scene.GetMonster(ins_id)
			if (monster) {
				monster.ShowDrop()
				setTimeout(() => {
					let drop_list = this.scene.drop_list
					for (let id in drop_list) {

						let obj = drop_list[id]
						if (obj) {
							obj.MoveToMainRole()
						}
					}
				},
					1
				)
			}
		}
	}

	ClearFeastBossBoxMap = () => {
		this.feast_boss_box_map = {}
	}

	static COLLECT_MAX_LIMIT = 2
	CompleteCollect = (mon_id?, mon_ins_id?) => {
		if (this.feast_boss_box_map) {
			let need_check = false
			// set
			for (let boss_id in this.feast_boss_box_map) {
				let mon_map = this.feast_boss_box_map[boss_id]
				if (mon_map && mon_map[mon_ins_id] != null) {
					mon_map[mon_ins_id] = true
					need_check = true
					break
				}
			}

			// check
			if (need_check) {
				let collect_cnt = 0
				for (let boss_id in this.feast_boss_box_map) {
					let mon_map = this.feast_boss_box_map[boss_id]
					collect_cnt = 0
					for (let ins_id in mon_map) {
						let state = mon_map[ins_id]
						if (state) {
							collect_cnt = collect_cnt + 1
						}
					}
					if (collect_cnt >= BossModel.COLLECT_MAX_LIMIT) {
						for (let ins_id in mon_map) {
							let state = mon_map[ins_id]
							this.scene_mgr.DeleteMonsterVo(ins_id)
						}
						delete this.feast_boss_box_map[boss_id]
					}
				}
			}
		}
	}

	ShowBoxMonster = (scmd?) => {
		if (scmd) {
			this.box_data = scmd
			if (scmd.box_list) {
				this.feast_boss_box_map[scmd.boss_id] = {}
				let custom_vo = null
				for (let _tmpi in scmd.box_list) {
					let vo = scmd.box_list[_tmpi]
					this.feast_boss_box_map[scmd.boss_id][vo.auto_id] = false
					let monster_vo = this.scene_mgr.CreateMonsterVo()
					monster_vo.pos_x = scmd.boss_x
					monster_vo.pos_y = scmd.boss_y
					monster_vo.instance_id = vo.auto_id
					monster_vo.type_id = vo.mon_cfg_id
					monster_vo.hp = vo.hp
					monster_vo.maxHp = vo.hp_lim
					monster_vo.level = vo.lv
					monster_vo.name = vo.name
					monster_vo.move_speed = vo.sp
					monster_vo.monster_res = vo.mon_resource
					monster_vo.effect_res = vo.mon_res
					monster_vo.texture_res = vo.imag_id
					monster_vo.weapon_id = vo.weapon_id
					monster_vo.attack_mode = vo.att_type
					monster_vo.type = vo.kind
					monster_vo.quality = vo.color
					monster_vo.guaji_flag = vo.on_hook
					monster_vo.boss_type = vo.boss
					monster_vo.pick_time = vo.collect_time
					monster_vo.can_pick = vo.is_be_clicked
					monster_vo.can_attack = vo.is_be_atted
					monster_vo.hide_flag = vo.hide
					monster_vo.ghost_mode = vo.ghost
					monster_vo.warGroup = vo.mon_group
					monster_vo.guild_id = vo.guild_id
					monster_vo.birth_angle = vo.Angel
					monster_vo.five_element = vo.attr_type
					monster_vo.title = vo.title
					monster_vo.SetBasePropertyFromConfig()
					monster_vo.reborn_end_pos = new Vector2(vo.x, vo.y)
					//monster_vo:SetMonsterRebornWay({x = vo.x, y = vo.y})
					this.scene_mgr.AddMonsterVo(monster_vo, false)
				}
			}
		}
	}

	AddFeastBossDrop = (data?) => {
		if (data && data.drop_list) {
			let reward = null
			reward = []
			reward.reward_list = []
			for (let _tmpi in data.drop_list) {
				let vo = data.drop_list[_tmpi]
				let obj = null
				obj = []
				obj.type = vo.drop_type
				obj.goods_type_id = vo.type_id
				table.insert(reward.reward_list, obj)
			}
			let pos = { x: data.pos_x, y: data.pos_y }
			this.ShowDropAnmiation(reward, pos)
		}
	}

	AddCanNotCollectMon = (mon_id?) => {
		if (!this.feast_boss_scene_can_not_collect_mon_id) {
			this.feast_boss_scene_can_not_collect_mon_id = {}
		}
		this.feast_boss_scene_can_not_collect_mon_id[mon_id] = true
	}

	ClearNotCollectMon = () => {
		this.feast_boss_scene_can_not_collect_mon_id = null
	}

	DeleteNotCollectMon = (mon_id?) => {
		if (this.feast_boss_scene_can_not_collect_mon_id && this.feast_boss_scene_can_not_collect_mon_id[mon_id]) {
			delete this.feast_boss_scene_can_not_collect_mon_id[mon_id]
		}
	}

	FeastBossSceneCanCollect = (mon_id?) => {
		let can_collect = true
		if (this.feast_boss_scene_can_not_collect_mon_id && this.feast_boss_scene_can_not_collect_mon_id[mon_id]) {
			can_collect = false
		}
		return can_collect
	}

	FindNearestCollect = () => {
		if (!this.scene.main_role) {
			return
		}
		let mon,
			min_dist,
			real_pos = this.scene.main_role.GetRealPos(),
			mon_real_pos,
			monster,
			collecnt_count = 0,
			cant_collect_count = 0


		for (let id in this.scene.monster_list) {
			monster = this.scene.monster_list[id]
			if(monster.vo && monster.vo.type == MonsterType.COLLECT && !monster.IsDead() && !monster.vo.reborn_end_pos){
				collecnt_count++
				if (!this.FeastBossSceneCanCollect(id)){
					cant_collect_count++
					continue
				}
				
				mon_real_pos = monster.GetRealPos()
				let dist_pw = GameMath.GetDistance(mon_real_pos.x, mon_real_pos.y, real_pos.x, real_pos.y, false)
				if (!mon || min_dist > dist_pw) {
					mon = monster
					min_dist = dist_pw
				}
			}
		}
		if(!mon && cant_collect_count > 0){
			//如果当前采集怪物数量和屏蔽的采集怪数量相等,那么清理屏蔽采集怪列表
			if(collecnt_count == cant_collect_count){
				this.ClearNotCollectMon()
			}
		}
		return mon
	}

	IsShowDropBossType = (boss_type?) => {
		return 0
	}

	SetBossDeadPos = (pos?) => {
		this.dungeon_monster_dead_pos = pos
	}

	GetBossDeadPos = () => {
		return this.dungeon_monster_dead_pos
	}

	TryAddDungeonDrop = () => {
		let pos = this.GetBossDeadPos()
		let data = this.GetBossResultInfo()
		let open_result_func = () => {
			this.Fire(BossModel.OPEN_BOSS_RESULT_VIEW, data)
			this.SetBossResultInfo(null)
			this.SetBossDeadPos(null)
		}

		if (data && !this.IsShowDropScene()) {
			open_result_func()
			return
		}
		if (data && pos) {
			this.ShowDropAnmiation(data, pos, open_result_func)
		}
	}

	ShowDropAnmiation = (data?, pos?, call_back?) => {
		if (data && pos) {
			call_back() //打开恭喜获得界面
			//掉落动画走12017协议，show_type字段:2
			//ShowDrop(data.reward_list,pos,call_back)
		}
	}

	SetBossResultInfo = (scmd?) => {
		this.boss_result_info = scmd
		this.TryAddDungeonDrop()
	}

	GetBossResultInfo = () => {
		return this.boss_result_info
	}

	IsShowDropScene = () => {
		return this.scene_mgr.IsSuitBossScene() || this.scene_mgr.IsMysteryBossScene()
	}

	RefreshFieldBossRed = () => {
		let bool = false
		let open = this.common_mgr.CheckFuncOpenState("BossFieldEnterView", true)
		let level = this.role_mgr.GetMainRoleVo().level
		let data = this.GetBossTypeInfo(BossModel.BossType.field)
		if ((level >= BossModel.Field_Refresh_Red_Level && data) && open) {
			bool = data.tired >= 1 || ShopModel.GetInstance().CheckSoulOfWarRed()
		}
		if (this.field_boss_red != bool) {
			this.field_boss_red = bool
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Field_Boss,
				bool
			)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 4601)
		}
		return bool
	}

	GetFieldBossRedState = () => {
		return this.field_boss_red
	}

	StartFieldBossRedTime = (func?, interval?, times?) => {
		this.CancelFieldBossRedTime()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, interval, times)
	}

	CancelFieldBossRedTime = () => {
		if (!this.time_id) {
			return
		}
		GlobalTimerQuest.CancelQuest(this.time_id)
		this.time_id = null
	}

	SetDropRecordData = (data?) => {
		if (!this.drop_record_data) {
			this.drop_record_data = []
		}
		this.drop_record_data = data
		this.drop_record_data["return_time"] = TimeUtil.getServerTime()
		this.Fire(BossModel.DROPRECORDDATA_RETURN)
	}

	RequestDropRecordData = (force?) => {
		let data = this.DropRecordData()
		if ((!data || force) || TimeUtil.getServerTime() - this.DropRecordData()["return_time"] > 3) {
			this.Fire(BossModel.SCMD_REQUEST, 46002)
		} else {
			this.Fire(BossModel.DROPRECORDDATA_RETURN)
		}
	}

	RequestEudeamonDrop = () => {
		this.Fire(BossModel.SCMD_REQUEST, 47002)
	}

	SortDopLog = (log_list?) => {
		if (!log_list) { return log_list }

		table.sort(log_list, (a?, b?) => {
			if (a.is_top != null && b.is_top != null) {
				if (a.is_top != b.is_top) {
					return a.is_top > b.is_top
				}
			}
			if (a.time != null && b.time != null) {
				if (a.time != b.time) {
					return a.time > b.time
				}
			}
			return false
		})
		return log_list
	}

	GetBossTypeName = (type?) => {
		let name = ""
		switch (type) {
			case BossModel.BossType.field:
			case BossModel.BossType.fieldspecial:
			case BossModel.BossType.field_infinite:
				name = "世界大妖"
				break
			case BossModel.BossType.secret:
				name = "秘境大妖"
				break
			case BossModel.BossType.abyss:
				name = "大妖之境"
				break
			case BossModel.BossType.suit:
				name = "蛮荒大妖"
				break
			case BossModel.BossType.mystery:
				name = "秘境大妖"
				break
			case BossModel.BossType.domain:
				name = "怨灵封印"
				break
			case 2:
				name = "专属大妖"
				break
		}
		return name
	}

	SetkillRecord = (data?) => {
		this.kill_record = data.send_list
		this.Fire(BossModel.KILL_RECORD_DATA_RETURN)
	}

	SetNewkillRecord = (data?) => {
		let list = this.KillRecord()
		if (!list) {
			list = []
		}
		table.insert(list, data)
		this.Fire(BossModel.KILL_RECORD_DATA_RETURN)
		this.set_killRecordRed(true)
	}

	SetKfkillRecord = (data?) => {
		let list = this.KillRecord()
		if (!list) {
			list = []
		}
		table.insert(list, data)
		this.Fire(BossModel.KILL_RECORD_DATA_RETURN)
		this.set_killRecordRed(true)
	}

	SetBoxsPos = (scmd?, boss_type?) => {
		if (!this.boxs_pos) {
			this.boxs_pos = {}
		}
		this.boxs_pos[boss_type] = {}
		for (let _tmpi in scmd.info) {
			let vo = scmd.info[_tmpi]
			this.boxs_pos[boss_type][vo.boss_id] = vo.xylist
		}
	}

	AddBoxsPos = (scmd?, boss_type?) => {
		let dic = this.boxs_pos && this.boxs_pos[boss_type]
		if (dic) {
			dic[scmd.boss_id] = scmd.xylist
		}
	}

	GetBoxsPos = (boss_id?, boss_type?) => {
		return (this.boxs_pos && this.boxs_pos[boss_type]) && this.boxs_pos[boss_type][boss_id]
	}

	FieldBossTipsTimer = () => {
		if (!this.scene_mgr.IsFieldScene()) {
			GlobalTimerQuest.CancelQuest(this.tips_timer)
		} else if (!this.tips_timer) {
			let loop_func = () => {
				this.need_field_return = true
				this.need_field_special_return = true
				this.need_field_infinite_return = true
				this.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field)
				this.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.fieldspecial)
				this.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.field_infinite)
			}
			this.tips_timer = GlobalTimerQuest.AddPeriodQuest(loop_func, 15 * 60, -1)
		}
	}

	TipsTimerReturn = () => {
		if (this.need_field_return || this.need_field_special_return || this.need_field_infinite_return) {
			return
		}
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.field)
		let data = [].concat(boss_info.boss_info) //table.merge(({}),table.merge(boss_info.boss_info, boss_info.boss_info))
		let lv = this.role_mgr.GetMainRoleVo().level
		let likeList = []
		for (let key in data) {
			let boss = data[key]
			if ((boss.is_remind && boss.reborn_time <= TimeUtil.getServerTime()) && boss.lv > lv) {
				table.insert(likeList, boss)
			}
		}
		if (likeList.length > 0) {
			table.sort(likeList, (a?, b?) => {
				return b.lv < a.lv
			})
			let info = likeList[0]
			info["boss_type"] = BossModel.BossType.field
			this.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, info)
		} else {
			boss_info = this.GetBossTypeInfo(BossModel.BossType.field_infinite)
			// data = table.merge(({}), table.merge(boss_info.boss_info, boss_info.boss_info))
			data = [].concat(boss_info.boss_info)
			for (let key in data) {

				let boss = data[key]
				if ((boss.is_remind && boss.reborn_time <= TimeUtil.getServerTime()) && boss.lv > lv) {
					table.insert(likeList, boss)
				}
			}
			if (likeList.length > 0) {
				table.sort(likeList, (a?, b?) => {
					return a.lv < b.lv
				})
				let info = likeList[0]
				info["boss_type"] = BossModel.BossType.field_infinite
				this.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, info)
			} else {
				boss_info = this.GetBossTypeInfo(BossModel.BossType.fieldspecial)
				// data = table.merge(({}), table.merge(boss_info.boss_info, boss_info.boss_info))
				data = [].concat(boss_info.boss_info)
				for (let key in data) {

					let boss = data[key]
					if ((boss.is_remind && boss.reborn_time <= TimeUtil.getServerTime()) && boss.lv > lv) {
						table.insert(likeList, boss)
					}
				}
				if (likeList.length > 0) {
					table.sort(likeList, (a?, b?) => {
						return a.lv < b.lv
					})
					let info = likeList[0]
					info["boss_type"] = BossModel.BossType.fieldspecial
					this.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, info)
				}
			}
		}
	}



	ShowConditionAlert = (cond_str?) => {

		switch (cond_str) {
			case "vip":
				Message.show("VIP等级不足无法进入")
				break
			case "lv":
				Message.show("等级不足无法进入")
				break
			case "vip_type":
				Message.show("请先激活特权卡")
				break
			case "cost":
				Message.show("消耗物品数量不足")
				break
			case "cross":
				Message.show("等级不足无法进入")
				break
			case "count":
				Message.show("进入次数不足")
				break
		}
	}

	EnterDunByHelp = (boss_type?, boss_id?) => {
		boss_type = Number(boss_type)
		boss_id = Number(boss_id)
		if (boss_type == BossModel.BossType.holyterritory) {
			HolyTerritoryModel.GetInstance().Fire(HTEvent.REQUEST_PROTO, 28303, "c", boss_id)
		} else if (boss_type == 1) {
			// let teamInfo = TeamModel.GetInstance().team_info
			// if (teamInfo && teamInfo.team_id ) {
			// 	Alert.Show("组队状态无法进入圣兽岭,是否退出退伍?",Alert_Type.Two,() => {
			// 			TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
			// 			this.Fire(BossModel.SCMD_REQUEST, 47003, 1, boss_id)
			// 		})
			// }else{
			this.Fire(BossModel.SCMD_REQUEST, 47003, 1, boss_id)
			// }
		} else {
			this.Fire(BossModel.SCMD_REQUEST, 46003, boss_type, boss_id)
		}
	}

	CheckEnterCondition = (boss_type?, boss_id?, is_alert?, config_eudemons_boss_cfg?, config_boss_cfg?, config_boss_type?) => {
		if (is_alert == null) {
			is_alert = true
		}
		boss_type = Number(boss_type)
		boss_id = Number(boss_id)
		if (boss_type == 1) {
			let data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, boss_id, false, config_eudemons_boss_cfg)
			if (!data) {
				return false
			}
			let can_open = this.CheckCrossServerBossOpen()
			if (!can_open) {
				if (is_alert) {
					this.ShowConditionAlert("cross")
				}
				return false
			}
			let condition = JSON.parse(data.condition) //this.erlang_parser.Parse(data.condition)
			if (condition.length > 0) {
				for (let _tmpi in condition) {
					let cond = condition[_tmpi]
					if (cond[0] == "lv") {
						let role_lv = this.role_mgr.GetMainRoleVo().level
						if (role_lv < Number(cond[1])) {
							if (is_alert) {
								this.ShowConditionAlert("lv")
							}
							return false
						}
					}
				}
			}
		} else if (boss_type == BossModel.BossType.holyterritory) {
			let limit_lv = HolyTerritoryModel.GetInstance().GetKv("limit_lv")
			let role_lv = this.role_mgr.GetMainRoleVo().level
			if (role_lv < limit_lv) {
				if (is_alert) {
					this.ShowConditionAlert("lv")
				}
				return false
			}
			return true
		} else if (boss_type == BossModel.BossType.suit) {
			let costConf = this.GetSuitBossTypeCost(BossModel.BossType.suit, config_boss_type)
			let boss_info = this.GetBossTypeInfo(BossModel.BossType.suit)
			let _cost = boss_info && costConf[boss_info.all_count - boss_info.count + 1]
			if (!_cost) {
				return false
			}
			let _cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[_cost.type_id]
			if (!_cfg) {
				return false
			}
			let ticket_num = this.goods_model.GetTypeGoodsNum(_cfg.type_id)
			let goods_price = _cfg.price
			let goods_cfgs = null
			let goods_cfg =
				Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, _cost.type_id, false, goods_cfgs)
			let goods_name = goods_cfg.goods_name
			return ["suit", _cost.type_id, ticket_num, _cost.need_num, goods_price, goods_name]
		} else if (boss_type == BossModel.BossType.mystery) {
			let boss_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
			if (!boss_info) {
				Message.show("当前场景无法跳转")
				return false
			}
			if (boss_info && boss_info.count <= 0) {
				if (is_alert) {
					this.ShowConditionAlert("count")
				}
				return false
			}
			let select_boss_info = this.GetBossInfo(BossModel.BossType.mystery, boss_id)
			let lv = this.role_mgr.GetMainRoleVo().level
			if (select_boss_info && lv < select_boss_info.open_lv) {
				if (is_alert) {
					this.ShowConditionAlert("lv")
				}
				return false
			}
			let now_times = boss_info.all_count - boss_info.count
			let cost = this.GetMysteryBossCost(now_times, config_boss_type)
			if (cost) {
				let [type_id, lock] = this.goods_model.GetMappingTypeId(cost[0], cost[1])
				let have = this.goods_model.GetTypeGoodsNum(type_id)
				let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[type_id]
				let goods_price = goods_info.price
				let basic = this.goods_model.GetGoodsBasicByTypeId(type_id)
				let _tiket_name = basic.goods_name
				if (have >= Number(cost[2])) {
					return true
				} else {
					return ["mystery", type_id, have, Number(cost[2]), goods_info.price, _tiket_name]
				}
			}
		} else {
			let data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
			if (!data) {
				return false
			}
			let cost = JSON.parse(data.cost) //this.erlang_parser.Parse(data.cost)
			let condition = JSON.parse(data.condition) //this.erlang_parser.Parse(data.condition)
			let free_condition = JSON.parse(data.free_condition) //this.erlang_parser.Parse(data.free_condition)
			if (condition.length > 0) {
				for (let _tmpi in condition) {
					let cond = condition[_tmpi]
					if (cond[1] == "lv") {
						let role_lv = this.role_mgr.GetMainRoleVo().level
						if (role_lv < Number(cond[2])) {
							if (is_alert) {
								this.ShowConditionAlert("lv")
							}
							return false
						}
					} else if (cond[1] == "vip") {
						let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag
						if (vip_flag < Number(cond[2])) {
							if (is_alert) {
								this.ShowConditionAlert("vip")
							}
							return false
						}
					} else if (cond[1] == "vip_type") {
						let crad_type = this.vip_model.GetMaxVipCardType()
						if (crad_type < Number(cond[2])) {
							if (is_alert) {
								this.ShowConditionAlert("vip_type")
							}
							return false
						}
					}
				}
			}
			if (free_condition.length > 0) {
				for (let _tmpi in free_condition) {
					let cond = free_condition[_tmpi]
					if (cond[1] == "vip") {
						let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag
						if (vip_flag >= Number(cond[2])) {
							return true
						}
					}
				}
			}
			for (let _tmpi in cost) {
				let vo = cost[_tmpi]
				if (Number(vo[0]) == 0) {
					let own = this.goods_model.GetRoleSpecGoodsNum(vo[0], vo[1])
					if (own < vo[2]) {
						if (is_alert) {
							this.ShowConditionAlert("cost")
						}
						return false
					}
				} else {
					return vo
				}
			}
		}
		return true
	}

	CheckEnterCondAndGoCost = (boss_type?, boss_id?, pos?, is_alert?) => {
		if (is_alert == null) {
			is_alert = true
		}
		let cfg1, cfg2
		let cfg3 = Config.PRELOAD_SERVER_CONFIG.config_boss_type
		let ok_func = () => {
			if (cfg1 && cfg2 && cfg3) {
				let enter = () => {
					this.SetMemberDeadPos(pos)
					this.EnterDunByHelp(boss_type, boss_id)
				}

				let result = this.CheckEnterCondition(boss_type, boss_id, is_alert, cfg1, cfg2, cfg3)
				if (typeof (result) == "boolean") {
					if (!result) {
						return
					}
					enter()
				} else if (result[0] == "suit" || result[0] == "mystery") {
					if (result[2] < result[3]) {
						GlobalEventSystem.Fire(
							EventName.OPEN_VIEW,
							"BossPersonalAlert",
							result[1],
							result[2],
							result[3],
							result[4],
							boss_id,
							result[5],
							boss_type, () => {
								enter()
							}
						)
						return
					}
					enter()
				} else {
					this.goods_model.CheckCoinEnough(Number(result[0]), Number(result[2]),
						true, (is_enough?) => {
							if (is_enough) {
								Alert.Show(
									"是否消耗" + result[2] + "绑玉进入？",
									Alert_Type.Two, () => {
										enter()
									},
									null,
									"确定",
									"取消"
								)
							} else {
								enter()
							}
						}
					)
				}
			}
		}
		ResManager.GetInstance().GetGameConfigWithAutoDestory("config_eudemons_boss_cfg", (cfg) => {
			cfg1 = cfg
			ok_func()
		}, false)
		ResManager.GetInstance().GetGameConfigWithAutoDestory("config_boss_cfg", (cfg) => {
			cfg2 = cfg
			ok_func()
		}, false)
	}

	CheckCrossServerBossOpen = () => {
		let level = this.role_mgr.GetMainRoleVo().level
		let open_day = this.server_time_model.GetOpenServerDay()
		let need_lv = BossModel.CrossServerBossCond.open_lv
		let need_day = BossModel.CrossServerBossCond.open_day
		return level >= need_lv && open_day >= need_day
	}

	SetHuntingLevelData = (scmd?) => {
		this.hunting_level_data = scmd
		this.Fire(BossModel.UPDATE_HUNTING_INFO)
	}

	GetHuntingLevelData = () => {
		return this.hunting_level_data
	}
	GetHuntingLevel = () => {
		return this.hunting_level_data && this.hunting_level_data.level
	}

	GetBossType = () => {
		if (this.scene_mgr.IsFieldBossScene()) {
			return BossModel.BossType.field
		} else if (this.scene_mgr.IsFieldSpecialBossScene()) {
			return BossModel.BossType.fieldspecial
		} else if (this.scene_mgr.IsFieldInfiniteBossScene()) {
			return BossModel.BossType.field_infinite
		} else if (this.scene_mgr.IsAbyssBossScene()) {
			return BossModel.BossType.abyss
		} else if (this.scene_mgr.IsSuitBossScene()) {
			return BossModel.BossType.suit
		} else if (this.scene_mgr.IsHolyBossScene()) {
			return BossModel.BossType.holy
		} else if (this.scene_mgr.IsHolyTerritory()) {
			return BossModel.BossType.holyterritory
		} else if (this.scene_mgr.IsFeastBossScene()) {
			return BossModel.BossType.feast
		} else if (this.scene_mgr.IsMysteryBossScene()) {
			return BossModel.BossType.mystery
		} else if (this.scene_mgr.IsBossDoMainScene()) {
			return BossModel.BossType.domain
		} else if (this.scene_mgr.IsCrossWuxianBossScene()) {
			return BossModel.BossType.holy_wuxian
		}
	}

	BossToField = (pos?) => {
		let type = this.GetBossType()
		let call = () => {
			this.scene.MainRoleMove(pos)
		}

		if (this.IsCrossServerBoss(type)) {
			this.Fire(BossModel.SCMD_REQUEST, 47004, type - BossModel.cross_boss_base_index, call)
		} else {
			this.Fire(BossModel.SCMD_REQUEST, 46004, type, call)
		}
	}

	BossToFeastScene = (pos?) => {
		let call = () => {
			this.scene.MainRoleMove(pos)
		}

		this.Fire(BossModel.SCMD_REQUEST, 46003, BossModel.BossType.feast, 0, call)
	}

	GetBossTypeCost = (boss_type?, config_boss_type?) => {
		if (!config_boss_type) return
		let cfg = config_boss_type
		let cost_list = JSON.parse(cfg[boss_type]["cost"]) //this.erlang_parser.Parse(cfg[boss_type]["cost"])
		let cost_dic = []
		for (let _tmpi in cost_list) {
			let cost = cost_list[_tmpi]
			let _cost = cost[1][0]
			let dic = []
			dic["type_id"] = _cost[1]
			dic["need_num"] = _cost[2]

			cost_dic[cost[0]] = dic
		}
		return cost_dic
	}

	GetSuitBossTypeCost = (boss_type?, config_boss_type?) => {
		let cfg = config_boss_type
		let cost_list = JSON.parse(cfg[boss_type]["cost"]) //this.erlang_parser.Parse(cfg[boss_type]["cost"])
		let cost_dic = []
		for (let _tmpi in cost_list) {
			let cost = cost_list[_tmpi]
			let _cost = cost[1][0]
			let dic = []
			dic["type_id"] = Number(_cost[1])
			dic["need_num"] = Number(_cost[2])
			cost_dic[Number(cost[0])] = dic
		}
		return cost_dic
	}

	GetBossRebornCost = (boss_type, config_boss_type) => {
		let cfg = config_boss_type
		if (this.scene_mgr.IsHolyBossScene()) {
			boss_type = 10
		}
		let bossCfg = cfg[boss_type]
		if (bossCfg) {
			let cost_list = JSON.parse(bossCfg["reborn_cost"]) //this.erlang_parser.Parse(bossCfg["reborn_cost"])
			if (cost_list.length > 0) {
				return cost_list[0]
			}
		}
	}

	GetSuitRed = () => {
		return this.suit_boos_red
	}

	RefreshSuitRed = (config_boss_type?) => {
		let bool = false
		let open = this.common_mgr.CheckFuncOpenState("BossSuitEnterView", true)
		let data = this.GetBossTypeInfo(BossModel.BossType.suit)
		if (data && open) {
			let cost = this.GetBossTypeCost(data.boss_type, config_boss_type)
			if (!cost) {
				return
			}
			let need_num = 1
			let count = data.count
			let all_count = data.all_count
			let have_num = this.goods_model.GetTypeGoodsNum(cost[1] && cost[1].type_id)
			if (count == 0 && cost[String(all_count + 1)]) {
				need_num = cost[String(all_count + 1)].need_num
			} else if (count == 0 && !cost[String(all_count + 1)]) {
				need_num = 0
			} else if (count != 0) {
				need_num = cost[String(all_count - count + 1)].need_num
			}
			if (count >= all_count) {
				bool = true
			} else if ((count > 0 && have_num >= Number(need_num)) && this.suit_boss_first_status) {
				bool = true
			}
		}
		if (this.suit_boos_red != bool) {
			this.suit_boos_red = bool
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Suit_Boss,
				bool
			)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 4601)
		}
	}

	SetMysteryBossReward = (scmd?) => {
		this.mystery_boss_reward = scmd
		this.Fire(BossModel.UPDATE_MYSTERY_BOSS_REWARD)
	}

	GetMysteryRewardList = (reward_id?, config_domain_kill_reward?) => {
		let cfg = config_domain_kill_reward
		if (cfg && cfg[reward_id]) {
			let reward_list = JSON.parse(cfg[reward_id].reward_list) //this.erlang_parser.Parse(cfg[reward_id].reward_list)
			if (reward_list && Util.TableSize(reward_list) > 0) {
				return reward_list
			}
		}
	}

	GetMysteryBossNowStageNum = (stage_list?, kill_num?) => {
		let num = 0
		if ((stage_list && stage_list.length > 0) && kill_num != null) {
			for (let _tmpi in stage_list) {
				let vo = stage_list[_tmpi]
				num = vo.kill_boss_num
				if (vo.kill_boss_num > kill_num) {
					num = vo.kill_boss_num
					break
				}
			}
		}
		return num
	}

	GetMysteryBossRewardCfg = (kill_num?, config_domain_kill_reward?) => {
		let cfg = config_domain_kill_reward
		let list = null
		list = []
		let reach = 0
		let lv = this.role_mgr.mainRoleInfo.level
		if (cfg) {
			for (let key in cfg) {
				let vo = cfg[key]
				if (lv >= vo.limit_down && lv <= vo.limit_up) {
					vo.reward = JSON.parse(vo.reward_list) //this.erlang_parser.Parse(vo.reward_list)
					table.insert(list, vo)
				}
			}
		}

		let sort_fun = (a?, b?) => {
			return a.stage < b.stage
		}
		table.sort(list, sort_fun)
		if (kill_num) {
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.kill_boss_num <= kill_num) {
					reach = reach + 1
				}
			}
		}
		return [list, reach, list.length]
	}

	GetMysteryBossCost = (now_times?, config_boss_type?) => {
		let cost = null
		let type_cfgs = config_boss_type[BossModel.BossType.mystery]
		if (type_cfgs) {
			this.mystery_boss_cost_list = JSON.parse(type_cfgs.cost) //this.erlang_parser.Parse(type_cfgs.cost)
			if (this.mystery_boss_cost_list) {
				let tmp = this.mystery_boss_cost_list[now_times-1]
				if (!tmp) {
					tmp = this.mystery_boss_cost_list[this.mystery_boss_cost_list.length - 1]
				}
				if ((tmp && tmp[1]) && tmp[1][0]) {
					cost = tmp[1][0]
				}
			}
		}
		return cost
	}

	RefreshMysteryBossRedDot = (config_domain_kill_reward) => {
		let open = this.common_mgr.CheckFuncOpenState("MysteryBossEnterView", true)
		if (open) {
			let show = (this.MysteryChallengeTimesMaxDot() || this.MysteryTicketEnoughDot()) || this.RefreshMBRewardDot(config_domain_kill_reward)
			this.mystery_boss_red = show
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"CrossServerEnterView",
				CrossServerViewIndex.Mystery_Boss,
				show
			)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
		}
	}

	GetMysteryBossRed = () => {
		return this.mystery_boss_red
	}

	MysteryChallengeTimesMaxDot = () => {
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		let can_challenge = false
		if (boss_info) {
			if (boss_info.all_count == boss_info.count) {
				can_challenge = true
			}
		}
		return can_challenge
	}

	MysteryTicketEnoughDot = (config_boss_type?, fire_event?) => {
		if (!config_boss_type) {
			return
		}
		let can_challenge = false
		let open = this.common_mgr.CheckFuncOpenState("BossSuitEnterView", true)
		let level_open = this.common_mgr.CheckFuncOpenState("MysteryBossEnterView", true)
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		if ((open && level_open) && boss_info) {
			if (boss_info.count > 0 && !this.has_show_challenge_dot) {
				let now_times = boss_info.all_count - boss_info.count
				let cost = this.GetMysteryBossCost(now_times, config_boss_type)
				if (cost) {
					let [type_id, lock] = this.goods_model.GetMappingTypeId(cost[0], cost[1])
					let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
					let have = this.goods_model.GetTypeGoodsNum(type_id)
					if (have >= Number(cost[2])) {
						can_challenge = true
					}
				}
			}
		}
		return can_challenge
	}

	RefreshMBRewardDot = (config_domain_kill_reward) => {
		let reward_dot = false
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		if (boss_info && this.mystery_boss_reward) {
			let [stage_list, reach, all_len] = this.GetMysteryBossRewardCfg(this.mystery_boss_reward.kill_num, config_domain_kill_reward)
			let has_get = null
			if (stage_list) {
				for (let _tmpi in stage_list) {
					let data = stage_list[_tmpi]
					has_get = false
					for (let _tmpi in this.mystery_boss_reward.had_reward_list) {
						let vo = this.mystery_boss_reward.had_reward_list[_tmpi]
						if (vo.stage == data.stage) {
							has_get = true
							break
						}
					}
					if (!has_get && this.mystery_boss_reward.kill_num >= data.kill_boss_num) {
						reward_dot = true
					}
				}
			}
		}
		return reward_dot
	}

	GetLayerByBossId = (boss_id?, config_boss_cfg?) => {
		let layer = 0
		let boss_cfgs = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
		if (boss_cfgs) {
			layer = boss_cfgs.layers
		}
		return layer
	}

	IsBossByBossId = (boss_id?, config_boss_cfg?) => {
		let is_boss = false
		let boss_cfgs = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
		if (boss_cfgs) {
			if (boss_cfgs.mon_type == BossModel.MYSTERY_NORMAL_BOSS_TYPE ||
				boss_cfgs.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE
			) {
				is_boss = true
			}
		}
		return is_boss
	}

	IsSpecialBoss = (boss_id?, config_boss_cfg?) => {
		let is_special = false
		let boss_cfgs = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
		if (boss_cfgs) {
			if (boss_cfgs.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
				is_special = true
			}
		}
		return is_special
	}

	IsBoxByBossId = (boss_id?, config_boss_cfg?) => {
		let is_box = false
		let boss_cfgs = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false, config_boss_cfg)
		if (boss_cfgs) {
			if (boss_cfgs.mon_type == BossModel.MYSTERY_BOX_TYPE ||
				boss_cfgs.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE
			) {
				is_box = true
			}
		}
		return is_box
	}

	MysteryBossJumpBySceneId = (scene_id?) => {
		let layer_num = scene_id - BossModel.BaseBossSceneId[BossModel.BossType.mystery]
		let info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		if (info && info.boss_info) {
			let boss_id = null
			for (let _tmpi in info.boss_info) {
				let vo = info.boss_info[_tmpi]
				if (vo.layer == layer_num && vo.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
					boss_id = vo.boss_id
					break
				}
			}
			if (boss_id) {
				OpenFun.OpenFunHandler(27, boss_id)
			}
		}
	}

	ShowMysteryDrop = (vo?) => {
		if (vo && vo.drop_list) {
			let basic_a = null
			let basic_b = null
			if (this.IsBossByBossId(vo.mon_id)) {
				let god_sort_fun = (a?, b?) => {
					basic_a = this.goods_model.GetGoodsBasicByTypeId(a.goods_type_id)
					basic_b = this.goods_model.GetGoodsBasicByTypeId(b.goods_type_id)
					if (basic_a.subtype == basic_b.subtype) {
						return basic_b.color < basic_a.color
					} else {
						return basic_b.type < basic_a.type
					}
				}

				let sort_fun = (a?, b?) => {
					basic_a = this.goods_model.GetGoodsBasicByTypeId(a.goods_type_id)
					basic_b = this.goods_model.GetGoodsBasicByTypeId(b.goods_type_id)
					return basic_b.color < basic_a.color
				}

				let data = null
				data = []
				data.reward_type = 2
				data.reward_list = []
				let equip_list = []
				let list2 = []
				let list3 = []
				let basic = null
				for (let _tmpi in vo.drop_list) {
					let obj = vo.drop_list[_tmpi]
					if (this.role_mgr.mainRoleInfo.role_id == obj.role_id) {
						basic = this.goods_model.GetGoodsBasicByTypeId(obj.type_id)
						if (basic) {
							if (basic.type == 71) {
								if (basic.subtype == 3 || basic.subtype == 2) {
									table.insert(
										equip_list,
										{ type: obj.drop_type, goods_type_id: obj.type_id, num: obj.drop_num, id: obj.drop_id }
									)
								} else {
									table.insert(list3, { type: obj.drop_type, goods_type_id: obj.type_id, num: obj.drop_num, id: obj.drop_id })
								}
							} else {
								table.insert(list2, { type: obj.drop_type, goods_type_id: obj.type_id, num: obj.drop_num, id: obj.drop_id })
							}
						}
					}
				}
				table.sort(equip_list, god_sort_fun)
				table.sort(list2, sort_fun)
				table.sort(list3, sort_fun)
				equip_list = equip_list.concat(list2) //table.merge(equip_list, list2)
				data.reward_list = equip_list.concat(list3) //table.merge(equip_list, list3)
				if (data.reward_list.length > 0) {
					this.SetBossResultInfo(data)
				}
			} else if (this.IsBoxByBossId(vo.mon_id)) {
				let god_sort_fun2 = (a?, b?) => {
					basic_a = this.goods_model.GetGoodsBasicByTypeId(a[1])
					basic_b = this.goods_model.GetGoodsBasicByTypeId(b[1])
					if (basic_a.subtype == basic_b.subtype) {
						return basic_b.color < basic_a.color
					} else {
						return basic_b.type < basic_a.type
					}
				}

				let sort_fun2 = (a?, b?) => {
					basic_a = this.goods_model.GetGoodsBasicByTypeId(a[1])
					basic_b = this.goods_model.GetGoodsBasicByTypeId(b[1])
					return basic_b.color < basic_a.color
				}

				if (vo.drop_list) {
					let list = []
					let equip_list = []
					let list2 = []
					let list3 = []
					let basic = null
					for (let _tmpi in vo.drop_list) {
						let obj = vo.drop_list[_tmpi]
						if (this.role_mgr.mainRoleInfo.role_id == obj.role_id) {
							basic = this.goods_model.GetGoodsBasicByTypeId(obj.type_id)
							if (basic) {
								if (basic.type == 71) {
									if (basic.subtype == 3 || basic.subtype == 2) {
										table.insert(equip_list, [obj.drop_type, obj.type_id, obj.drop_num, obj.drop_id])
									} else {
										table.insert(list3, [obj.drop_type, obj.type_id, obj.drop_num, obj.drop_id])
									}
								} else {
									table.insert(list2, [obj.drop_type, obj.type_id, obj.drop_num, obj.drop_id])
								}
							}
						}
					}
					table.sort(equip_list, god_sort_fun2)
					table.sort(list2, sort_fun2)
					table.sort(list3, sort_fun2)
					equip_list = equip_list.concat(list2) // table.merge(equip_list, list2)
					list = equip_list.concat(list3) //table.merge(equip_list, list3)
					if (list.length > 0) {
						Util.ShowCongratulationView(list)
					}
				}
			}
		}
	}

	GetMaxBoxNumByType = (mon_type?, layer?) => {
		let num = 0
		let boss_type_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		if (boss_type_info && boss_type_info.boss_info) {
			for (let _tmpi in boss_type_info.boss_info) {
				let vo = boss_type_info.boss_info[_tmpi]
				if (vo.layer == layer) {
					if (vo.mon_type == mon_type) {
						num = num + vo.limit_num
					}
				}
			}
		}
		return num
	}

	GetNowBoxNum = (mon_type?, layer?) => {
		let num = 0
		let boss_type_info = this.GetBossTypeInfo(BossModel.BossType.mystery)
		if (boss_type_info && boss_type_info.boss_info) {
			let list = boss_type_info.boss_info
			if (list) {
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (vo.layer == layer && vo.mon_type == mon_type) {
						let pos_list = this.GetBoxsPos(vo.boss_id, BossModel.BossType.mystery)
						if (pos_list) {
							let len = pos_list.length
							if (len > 0) {
								num = num + len
							}
						}
					}
				}
			}
		}
		return num
	}

	GetNowSpecialBossNum = (layer?) => {
		let num = 0
		let list = null
		let vo = null
		if (this.boxs_pos) {
			for (let boss_type in this.boxs_pos) {

				if (Number(boss_type) == BossModel.BossType.mystery) {
					list = this.boxs_pos[boss_type]
					if (list) {
						for (let boss_id in list) {
							vo = list[boss_id]
							if (this.IsSpecialBoss(boss_id) && this.GetLayerByBossId(boss_id) == layer) {
								if (vo) {
									num = num + vo.length
								}
							}
						}
					}
				}
			}
		}
		return num
	}

	GetNowCollectBoxMonType = () => {
		let mon_type = 0
		let mon_id = FightManager.GetInstance().collect_monster_ins_id
		if (mon_id) {
			let mon = this.scene.GetMonster(mon_id)
			if (mon) {
				let boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, mon.type_id, false)
				if (boss_cfg) {
					mon_type = boss_cfg.mon_type
				}
			}
		}
		return mon_type
	}


	GetEudaemonRed = () => {
		if (!this.common_mgr.CheckFuncOpenState("EudaemonEnterView", true)) {
			return false
		}
		if (!this.eudaemon_has_click) {
			for (let _tmpi in this.red_list) {
				let vo = this.red_list[_tmpi]
				if (vo) {
					return true
				}
			}
		}

		if(this.GetEduBossRed()){
			return true
		}

		return false
	}


	/**
	 * 悬赏没做完的红点
	 */
	public GetEudaemonTaskRed = () => {
		if (!this.common_mgr.CheckFuncOpenState("EudaemonEnterView", true)) {
			return false
		}

		let taskData = this.GetEudaemonTask()
		if (taskData && taskData.length > 0) {
			if(taskData[0]["finish"]){
				return false
			}
			return true
		}
		return false
	}

	FindEudaemonTarget = () => {
	}

	EudaemonEnterScene = (collect?, taskSceneId?, config_eudemons_boss_cfg?) => {
		let cross_server_boss_list = this.GetBossTypeInfo(BossModel.BossType.holy)
		let roleLv = this.role_mgr.GetMainRoleVo().level
		let boss_info = null
		if (cross_server_boss_list && cross_server_boss_list.boss_info) {
			for(let i = cross_server_boss_list.boss_info.length-1;i>=0;i--){
				let vo = cross_server_boss_list.boss_info[i]
				let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.boss_id, false)
				if ((mon_cfg && (mon_cfg.kind == 0 || collect)) && roleLv >= vo.open_lv) {
					let monsterCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, vo.boss_id, false, config_eudemons_boss_cfg)
					if (collect) {
						if (monsterCfg && monsterCfg.is_rare == 3) {
							boss_info = vo
						}
					} else if (taskSceneId) {
						if (monsterCfg && monsterCfg.scene == taskSceneId) {
							boss_info = vo
						}
					} else {
						boss_info = vo
					}
				}
			}
			if (boss_info) {
				this.SetEnterBossInfo({ boss_id: boss_info.boss_id })
				let boss_type = boss_info.boss_type - BossModel.cross_boss_base_index
				let teamInfo = TeamModel.GetInstance().team_info
				if (teamInfo && teamInfo.team_id) {
					Alert.Show("组队状态无法进入蜃气楼,是否退出退伍?", Alert_Type.Two, () => {
						TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
						this.Fire(BossModel.SCMD_REQUEST, 47003, boss_type, boss_info.boss_id)
					})
				} else {
					this.Fire(BossModel.SCMD_REQUEST, 47003, boss_type, boss_info.boss_id)
				}
			}
		}
	}

	GetEudaemonTask = () => {
		let totalTask = []
		let find = false
		let euda_task = this.task_model.circle_task_progress_data[TaskType.EUDAEMON_TASK]
		let total = this.task_model.GetHasReceiveTaskList()
		let crystalId = this.common_mgr.GetValue(4700006)
		if (total) {
			for (let key in total) {

				let taskInfo = total[key]
				if (taskInfo[0] && taskInfo[0].task_type == TaskType.EUDAEMON_TASK) {
					find = true
					table.insert(totalTask, 1, taskInfo[0])
				}
				if (taskInfo[0] && taskInfo[0].task_id == crystalId) {
					table.insert(totalTask, taskInfo[0])
				}
			}
			if (euda_task && euda_task.finish_num == euda_task.all_num) {
				if (totalTask.length == 0) {
					table.insert(totalTask, 1, { finish: true })
				}
			} else if (!find) {
				table.insert(totalTask, 1, {})
			}
		}
		return totalTask
		// return []
	}

	AttckRole = (roleId?) => {
		let local_BossSceneManager_Instance = BossSceneManager.GetInstance()
		let roleVo = this.scene_mgr.GetRoleVo(roleId)
		if (roleVo) {
			let canFight = this.scene_mgr.IsCanAttackByMainRole(roleVo, false, false, true)
			if (!canFight) {
				local_BossSceneManager_Instance.SetAutoState(true)
				return
			}
			local_BossSceneManager_Instance.SetAutoState(false)
			let attackObj = this.scene.GetRole(roleId)
			if (attackObj) {
				local_BossSceneManager_Instance.SetAttackTarget(attackObj)
				this.scene.SetClickTarget(attackObj)
				AutoFightManager.GetInstance().SetAutoFight(true)
				this.Fire(BossModel.CHANGE_BOSS_TARGET, attackObj)
			}
		}
	}

	DoEudaemonTask = () => {
		if (this.get_eudamon_task) {
			let task_info1 = this.task_model.HaveThisTypeTask(TaskType.EUDAEMON_TASK)
			if (!task_info1) {
				this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30011, TaskType.EUDAEMON_TASK)
			} else {
				let taskList = this.task_model.GetHasReceiveTaskList()
				for (let key in taskList) {
					let taskVo = taskList[key]
					if (taskVo[0] && taskVo[0].task_type == TaskType.EUDAEMON_TASK) {
						this.task_model.DoTask(taskVo[0])
						break
					}
				}
			}
			this.get_eudamon_task = false
		}
		this.find_cry_stal = false
	}

	GetLayerName = (layer?) => {
		return "蜃气楼" + layer + "层"
	}

	DoMainBossInfo = (boss_id?) => {
		if (!this.do_main_data || !this.do_main_data.boss_list) {
			return null
		}
		for (let key in this.do_main_data.boss_list) {

			let info = this.do_main_data.boss_list[key]
			if (info.boss_id == boss_id) {
				return info
			}
		}

		return null
	}

	DomainBossList = (cfg?, select_boss_id?) => {
		let index = 0
		let count = 0
		let list1 = []
		let list2 = []
		let is_find = false
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let need_openDay = 0

		for (let key in cfg) {

			let boss = cfg[key]
			table.insert(list1, boss)
		}

		table.sort(list1, (a?, b?) => {
			return a.boss_id < b.boss_id
		})

		for (let key2 in list1) {

			need_openDay = 0
			let boss = list1[key2]
			let condition = JSON.parse(boss.condition)
			for (let key in condition) {

				let element = condition[key]
				if (element[0] == "open_day") {
					need_openDay = Number(element[1])
					break
				}
			}
			if (open_day >= need_openDay) {
				table.insert(list2, boss)

				if (select_boss_id == 0) {
					let boss_data = this.DoMainBossInfo(boss.boss_id)
					if (boss_data) {
						let arr = this.DomainBossCfgInfo(boss)
						let is_open = arr[0] && arr[1] && arr[2]
						if (is_open && boss_data.reborn_time <= 0) {
							index = count
						}
					}

				} else {
					if (!is_find && select_boss_id && select_boss_id == boss.boss_id) {
						index = count
						is_find = true
					}
				}

				count = count + 1
			}
		}
		return [list2, index]
	}

	/**boss_id: 4500001
	boss_type: 2
	buff_double_ids: "[]"
	cls_type: 1
	condition: "[{\"0\":\"lv\",\"1\":360}]"
	revive_time: 1200
	role_num: 10
	scene_id: 45001
	x: 1497
	y: 874 */
	public DomainBossCfgInfo(boss_cfg) {

		let sorce = 0
		let list = GoodsModel.GetInstance().wear_unreal_dic
		for (let key in list) {
			let vo = list[key]
			if (vo) {
				sorce = sorce + vo.overall_rating
			}
		}

		//数据
		let condition = JSON.parse(boss_cfg.condition)
		let lv = RoleManager.GetInstance().GetMainRoleVo().level

		let is_can_challenge = false 	//是否可以挑战
		let is_enough_lv = false		//等级是否足够
		let is_enough_equip = true		//装备数量条件是否满足
		let need_sorce = 0 				//需要幻饰达到的评分
		let need_lv = 0					//需要幻饰达到的等级
		let need_eq_type = 0			//需要幻饰的类型
		let need_eq_num = 0				//需要幻饰的数量


		for (let key in condition) {
			let element = condition[key]
			if (element[0] == "lv") {
				need_lv = Number(element[1])
			} else if (element[0] == "decoration_rating") {
				need_sorce = Number(element[1])
			} else if (element[0] == "constellation_suit") {
				need_eq_type = Number(element[1])
				need_eq_num = Number(element[2])
			}
		}

		//分析
		is_can_challenge = sorce >= need_sorce
		is_enough_lv = lv >= need_lv
		if (need_eq_type > 0 && need_eq_num > 0) {
			let num = GoodsModel.GetInstance().GetStarEquipPageNum(need_eq_type, true)
			is_enough_equip = num >= need_eq_num
		}

		return [is_can_challenge, is_enough_lv, is_enough_equip, need_sorce, need_lv, need_eq_type, need_eq_num]
	}


	/**幻域boss是否有可购买次数 */
	public IsDomainBossHasTimesCanBuy() {
		let vip_model = VipModel.GetInstance()
		let vip_card = vip_model.GetNobleCardState()
		let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag

		//需要激活特权卡才可以购买
		let can_buy = vip_card > 0
		if (!can_buy) return false

		//vip每天购买次数(已经购买)
		let vip_bug_time = this.do_main_data.buy_count
		//vip每天可购买次数（未购买）
		let vip_can_buy = vip_model.GetVipPrivilegeValue(BossModel.DOMAIN_MODULE_ID, 3, vip_card, vip_flag)

		return (vip_bug_time - vip_can_buy) < 0
	}


	/**幻域boss是否有可挑战次数 */
	public IsDomainBossHasTimesCanChallenge() {
		let vip_model = VipModel.GetInstance()
		let vip_card = vip_model.GetNobleCardState()
		let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag
		//每天默认进入次数
		let default_time = vip_model.GetVipPrivilegeValue(BossModel.DOMAIN_MODULE_ID, 1, vip_card, vip_flag)
		//vip每天购买次数(已经购买)
		let vip_bug_time = this.do_main_data.buy_count
		//总共次数
		let go_times = default_time + vip_bug_time
		//已使用次数
		let used_time = this.do_main_data.count
		let left = go_times - used_time

		return left > 0
	}

	GetDomainBossRemind = (boss_id?) => {
		let flag = true
		if (this.domain_unfollow_dic[boss_id]) {
			flag = false
		}
		return flag
	}

	RequestDomainBossDrop = () => {
		this.Fire(BossModel.SCMD_REQUEST, 47108)
	}
	RequestMysteryBossDrop = () => {
		this.Fire(BossModel.SCMD_REQUEST, 46046, BossModel.BossType.mystery)
	}

	ChangeRoleRank = (data?) => {
		if (this.role_rank_list.length == 0) {
			table.insert(this.role_rank_list, data)
		} else {
			let find = false
			let i = 0
			do {
				let obj = this.role_rank_list[i]
				if (obj.role_id == data.role_id) {
					find = true
					obj.hurt = data.hurt
					break
				}
				i = i + 1
			} while ((i < this.role_rank_list.length)
			)
			if (!find) {
				table.insert(this.role_rank_list, data)
			}
			table.sort(this.role_rank_list, (a?, b?) => {
				return b.hurt < a.hurt
			}
			)
		}
		this.Fire(BossModel.DOMAINBOSS_ROLE_RANK_RETURN)
	}

	DomainBossTime = (confg?) => {
		//let str = ""
		//let time_list = this.erlang_parser.Parse(confg)
		//let serverTime = TimeUtil.timeHMS(TimeUtil.getServerTimeMs())
		//for (let key in time_list) {

		//let time_obj = time_list[key]
		//let time = time_obj[0] * 60 * 60 + time_obj[1] * 60
		//if (serverTime < time ) {
		//return time_obj[0] + ":" + (time_obj[1] == 0 && ( "00" ) || ( time_obj[1] ) )
		//}
		//}
		//return "次日" + time_list[0][0] + ":" + (time_list[0][1] == 0 && ( "00" ) || ( time_list[0][1] ) )
	}

	DoMainBossExitTime = (time?) => {
		if (time > TimeUtil.getServerTime()) {
			this.Fire(BossModel.DOMAINBOSS_EXIT_TIME, time)
		}
	}

	DoMianBossReliveTime = (time?) => {
		if (time > TimeUtil.getServerTime()) {
			this.doMian_boss_relive_time = time
			this.Fire(BossModel.DOMAINBOSS_RELIVE_TIME, time)
		}
	}

	CheckDomainBossMsg = () => {
		if (this.scene_mgr.IsBossDoMainScene() && this.domain_boss_enter_type == 2) {
			Message.show("协助模式下无法对boss造成伤害")
		}
	}

	ReliveTips = (data?, config_decoration_boss?) => {
		if (this.scene_mgr.IsFieldScene() && !this.domain_unfollow_dic[data.boss_id]
			&& this.do_main_data && this.do_main_data.count > 0) {
			let cfg = config_decoration_boss
			let boss = cfg[data.boss_id]
			if (boss) {
				let sorce = 0
				let list = this.goods_model.wear_unreal_dic
				for (let key in list) {

					let vo = list[key]
					if (vo) {
						sorce = sorce + vo.overall_rating
					}
				}
				let need_sorce = 0
				let need_lv = 0
				if (boss.condition) {
					let rating_list = JSON.parse(boss.condition)[1] //this.erlang_parser.Parse(boss.condition)[1]
					need_sorce = (rating_list && rating_list[1] && (rating_list[1]) || (0))
					let level_list = JSON.parse(boss.condition)[0] // this.erlang_parser.Parse(boss.condition)[0]
					need_lv = (level_list && level_list[1] && (level_list[1]) || (0))
				}
				let lv = this.role_mgr.GetMainRoleVo().level
				let _canChallenge = sorce >= Number(need_sorce)
				let _fullLevel = lv >= Number(need_lv)
				if (_canChallenge && _fullLevel) {
					let obj = []
					obj["boss_type"] = BossModel.BossType.domain
					obj["boss_id"] = data.boss_id
					this.Fire(BossModel.OPEN_REBORN_TIPS_VIEW, obj)
				}
			}
		}
	}

	DomainBossId = (cfg?, selectId?) => {
		let cfg_list = []
		for (let i in cfg) {
			let _cfg = cfg[i]
			table.insert(cfg_list, _cfg)
		}
		table.sort(cfg_list, (a?, b?) => {
			return a.boss_id < b.boss_id
		})

		let role_lv = this.role_mgr.GetMainRoleVo().level
		let sorce = 0
		let list = this.goods_model.wear_unreal_dic
		let info = null
		for (let key in list) {

			let vo = list[key]
			if (vo) {
				sorce = sorce + vo.overall_rating
			}
		}
		let index = 1
		let isFight = false
		for (let key in cfg_list) {

			let boss_cfg = cfg_list[key]
			if (boss_cfg.boss_id == selectId) {
				isFight = boss_cfg.boss_type == 1
			} else if (boss_cfg.boss_id > selectId) {
				if (!(isFight && boss_cfg.boss_type != 1)) {
					let need_sorce = 0
					let need_lv = 0
					let need_eq_type = 0
					let need_eq_num = 0
					let need_openDay = 0
					let condition = JSON.parse(boss_cfg.condition) //this.erlang_parser.Parse(boss_cfg.condition)
					for (let key in condition) {

						let element = condition[key]
						if (element[0] == "open_day") {
							need_openDay = Number(element[1])
						} else if (element[0] == "lv") {
							need_lv = Number(element[1])
						} else if (element[0] == "decoration_rating") {
							need_sorce = Number(element[1])
						} else if (element[0] == "constellation_suit") {
							need_eq_type = Number(element[1])
							need_eq_num = Number(element[2])
						}
					}
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					let _fullOpenDay = open_day >= need_openDay
					let _canChallenge = sorce >= need_sorce
					let _fullLevel = role_lv >= need_lv
					let _fullEquip = true
					if (need_eq_type > 0 && need_eq_num > 0) {
						let num = GoodsModel.GetInstance().GetStarEquipPageNum(need_eq_type, true)
						_fullEquip = num >= need_eq_num
					}
					if (((!_canChallenge || !_fullLevel) || !_fullEquip) || !_fullOpenDay) {
						index = index + 1
						break
					} else {
						if (!info || (need_lv >= info.level && boss_cfg.boss_id > info.boss_id)) {
							let obj = { boss_id: boss_cfg.boss_id, level: need_lv, index: index, boss_type: boss_cfg.boss_type }
							info = obj
						}
					}
				}
			}
			index = index + 1
		}
		return info
	}

	SetDomainBossRed = () => {
		let openDay = this.server_time_model.GetOpenServerDay()
		let level = this.role_mgr.GetMainRoleVo().level
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
		let view_cfg = cfg.BossDomainView
		if (openDay < view_cfg.open_day || level < view_cfg.open_lv) {
			return
		}
		let vip_card = this.vip_model.GetNobleCardState()
		let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag
		let go_times = this.vip_model.GetVipPrivilegeValue(BossModel.DOMAIN_MODULE_ID, 1, vip_card, vip_flag) + this.do_main_data.buy_count + this.do_main_data.add_count
		let count = go_times - this.do_main_data.count
		let bool = count > 0
		if (this.domain_boss_red != bool) {
			this.domain_boss_red = bool
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"CrossServerEnterView",
				CrossServerViewIndex.Domain_Boss,
				bool
			)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
		}
	}

	GetDomainBossRed = () => {
		return this.domain_boss_red
	}

	SetDropDic = (drop_list?) => {
		let dic = this.drop_dic
		for (let _tmpi in drop_list) {
			let vo1 = drop_list[_tmpi]
			if (!dic[vo1.type_id]) {
				dic[vo1.type_id] = { type_id: vo1.type_id || vo1[2], goods_num: vo1.drop_num || vo1[3] }
			} else {
				dic[vo1.type_id].goods_num = dic[vo1.type_id].goods_num + vo1.drop_num
			}
		}
	}

	SetDropDic2 = (drop_list?) => {
		let dic = this.drop_dic
		for (let _tmpi in drop_list) {
			let vo1 = drop_list[_tmpi]
			if (!dic[vo1[2]]) {
				dic[vo1[2]] = { type_id: vo1[2], goods_num: vo1[3] }
			} else {
				dic[vo1[2]].goods_num = dic[vo1[2]].goods_num + vo1[3]
			}
		}
	}

	CheckIsPickupMon = () => {
		let pick_list = []
		let main_role = Scene.GetInstance().main_role
		let monster_list = this.scene.GetMonsterList()
		for (let ins_id in monster_list) {

			let monster = monster_list[ins_id]
			if (monster.vo.type == MonsterType.PICK && !this.pick_up_mon[ins_id]) {
				let mx = main_role.real_pos.x
				let my = main_role.real_pos.y
				let monster_pos = monster.GetRealPos()
				let monVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, monster.GetVo().type_id, false)
				let range = monVo.warning_range
				if (GameMath.GetDistance(mx, my, monster_pos.x, monster_pos.y) <= range * range) {
					table.insert(pick_list, ins_id)
					this.pick_up_mon[ins_id] = true
				}
			}
		}
		if (pick_list.length > 0) {
			GlobalEventSystem.Fire(ObjectEventType.MAIN_ROLE_COLLIDE_MONSTER, pick_list)
		}
	}

	RemovePickupMonState = (ins_id?) => {
		if (this.pick_up_mon[ins_id]) {
			this.pick_up_mon[ins_id] = null
		}
	}

	update_boss_hp_id = null
	boss_hp_data = null
	boss_hp_cfg = null
	update_Vit_id = null

	StartUpdateBossHp = () => {
		if (!this.update_boss_hp_id) {
			let loop_func = () => {
				this.Fire(BossModel.SCMD_REQUEST, 46040)
			}
			this.update_boss_hp_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 5, -1)
			loop_func()
		}
	}

	StopUpdateBossHp = () => {
		if (this.update_boss_hp_id) {
			GlobalTimerQuest.CancelQuest(this.update_boss_hp_id)
		}
		this.update_boss_hp_id = null
	}

	UpdateBossHpData = (scmd?) => {
		this.boss_hp_data = []
		for (let _tmpi in scmd.list) {
			let vo = scmd.list[_tmpi]
			this.boss_hp_data[vo.mon_id] = vo
		}
		this.Fire(BossModel.UPDATE_BOSS_HP)
	}

	GetBossHpData = (type_id?) => {
		return this.boss_hp_data && this.boss_hp_data[type_id]
	}

	SetBossHpCfg = (cfg?) => {
		this.boss_hp_cfg = []
		if (cfg) {
			// for (let _tmpi in this.erlang_parser.Parse(cfg.boss_ids)) {
			// 	let boss_id = this.erlang_parser.Parse(cfg.boss_ids)[_tmpi]
			// 	this.boss_hp_cfg[Number(boss_id)] = true
			// }
			let parse_cfg = JSON.parse(cfg.boss_ids)
			for (let _tmpi in parse_cfg) {
				let boss_id = parse_cfg[_tmpi]
				this.boss_hp_cfg[Number(boss_id)] = true
			}
		}
	}

	HasBossHpCfg = (type_id?) => {
		return this.boss_hp_cfg && this.boss_hp_cfg[Number(type_id)]
	}


	JudgeTired = (show?, boss_type?, boss_id?) => {
		if (show == null) {
			show = true
		}
		let flag = true
		if (this.scene_mgr.IsHolyBossScene()) {
			let info = this.GetBossTypeInfo(BossModel.BossType.holy)
			if (info) {
				flag = info.tired < info.max_tired
			}
			if (!flag) {
				if (show) {
					Message.show("今日已无次数，无法对BOSS造成伤害！")
				}
			}
		} else if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
			if (boss_type && boss_type != BossModel.BossType.field) {
				return flag
			}
			let info = this.GetBossTypeInfo(boss_type)
			if (this.scene_mgr.IsFieldBossScene()) {
				info = this.GetBossTypeInfo(BossModel.BossType.field)
			} else if (this.scene_mgr.IsFieldInfiniteBossScene()) {
				info = this.GetBossTypeInfo(BossModel.BossType.field_infinite)
			}
			//if (info ) {
			//flag = info.all_tired - info.tired > 0
			//}
			if (boss_id && info) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false)
				let tired_add = config.tired_add
				flag = info.tired >= tired_add
			}
			if (!flag && show) {
				this.Fire(BossModel.OPEN_BOSS_TIRED_ALERT)
			}
		} else if (this.scene_mgr.IsHolyTerritory()) {
			let info = this.GetBossTypeInfo(BossModel.BossType.holyterritory)
			if (info) {
				flag = info.tired < info.all_tired
			}
			if (!flag) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false)
				if (!config || config.sign != 1) {
					flag = true
				}
				if ((!flag && show)) { //&& ! HolyTerritoryModel.GetInstance().IsSelfHT()
					Alert.Show("和平大妖疲劳值已满，无法攻击和平大妖。<br>请前往攻击<font color='#639c12'>非和平大妖</font>")
					//Message.show("今日疲劳已满，无法对BOSS造成伤害！")
				}
			}
		}
		return flag
	}


	SetVitData = (scmd?) => {
		this.vit_data = scmd
	}

	GetVitData = () => {
		return this.vit_data
	}

	DropRecordData() {
		return this.drop_record_data
	}

	CanFindNextDrop() {

		if (SceneManager.GetInstance().IsBossSnatchTreasure()) {
			return false
		}
		return true
	}

	KillRecord() {
		return this.kill_record
	}

	get_killRecordRed() {

		return this.kill_record_red
	}

	set_killRecordRed(value?) {

		if (this.kill_record_red != value) {
			this.kill_record_red = value
			this.Fire(BossModel.NEW_KILL_RECORD)
		}
	}

	GuideTaskDone() {
		return TaskModel.GetInstance().newest_finish_task_id >= BossModel.FIELD_BOSS_GUIDE_TASK_ID
	}

	GuideTaskDone2() {
		return TaskModel.GetInstance().newest_finish_task_id >= BossModel.FIELD_BOSS_GUIDE_TASK_ID2
	}


	GetBossList() {

		let curr_scene_id = SceneManager.GetInstance().curr_scene_id
		let boss_type = this.GetBossType()
		let info = this.GetBossTypeInfo(boss_type)
		let layer = 1
		if (boss_type != BossModel.BossType.holy_wuxian) {
			if (curr_scene_id == 34090 || curr_scene_id == BossModel.BOSS_FIELD_INFINITE) {
				layer = 0 //无限层特殊处理
			} else {
				layer = curr_scene_id - BossModel.BaseBossSceneId[boss_type]
			}
		}

		let boss_info = []
		for (let _tmpi in info.boss_info) {
			let vo = info.boss_info[_tmpi]
			if (vo.layer == layer && vo.boss_type == boss_type) {
				table.insert(boss_info, vo)
			}
		}
		return boss_info
	}


	public SetMainUITeamVisible(boo?) {
		MainUIController.GetInstance().SetMainUIViewVisible(11, boo)
	}

	public GetActiveDrop() {
		let cfg_mon_drop_rule = Config.PRELOAD_SERVER_CONFIG.config_mon_drop_rule
		let cfg_special_drop = Config.PRELOAD_SERVER_CONFIG.config_special_drop
		let base_type = 8
		let sub_type
		let drop_id
		let type_id
		let act = CustomActivityModel.GetInstance().GetActInfoByType(base_type)
		if (act) {
			sub_type = act.sub_type
		}
		for (let i in cfg_mon_drop_rule) {
			let vo = cfg_mon_drop_rule[i]
			if (base_type == vo.act_id && sub_type == vo.sub_id) {
				drop_id = ErlangParser.GetInstance().parse(vo.drop_list)[0]
				break
			}
		}
		if (drop_id) {
			for (let i in cfg_special_drop) {
				let vo = cfg_special_drop[i]
				if (vo.list_id == drop_id) {
					type_id = vo.goods_id
					break
				}
			}
		}
		return type_id
	}

	//-----------------------------boss之家/专属大妖 
	boss_abyss_red_state_ = false//红点状态
	public static BOSS_ABYSS_OPEN_VIP_LV = 4

	/**获取红点状态 */
	public GetBossAbyssRed = () => {
		return this.boss_abyss_red_state_
	}


	public UpdateRedHelp() {
		this.boss_abyss_red_state_ = false
		//判断vip等级
		let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
		if (role_vip >= BossModel.BOSS_ABYSS_OPEN_VIP_LV) {
			//是否有关注的boss
			let boss_info = this.GetBossTypeInfo(BossModel.BossType.abyss)
			if (boss_info) {
				let list = boss_info.boss_info
				let len = list.length
				let boss_vo
				for (let i = 0; i < len; i++) {
					boss_vo = list[i]
					if (this.CheckBossRemainState(boss_vo)) {
						this.boss_abyss_red_state_ = true
						break
					}
				}
			}

		}


		//派发事件
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 4601)
		this.Fire(BossModel.UPDATE_ABYSS_BOSS_RED)
	}

	public UpdateBossAbyssRed = () => {

		//延迟更新
		Laya.timer.frameOnce(5, this, this.UpdateRedHelp, null, true)
	}

	/**检查boss是否被关注 
	 * @param is_live 是否关注存活
	*/
	public CheckBossRemainState(boss_vo, is_live = true) {
		if (is_live) {
			if (boss_vo.is_remind && TimeUtil.getServerTime() >= boss_vo.reborn_time) {

				//大妖之境  人物等级达不到boss的开启条件 
				if (boss_vo && boss_vo.boss_type == BossModel.BossType.abyss) {
					let role_lv = RoleManager.GetInstance().mainRoleInfo.level
					if (role_lv < boss_vo.open_lv) {
						return false
					}
				}

				return true
			}
		} else {
			if (boss_vo.is_remind) {
				return true
			}
		}

		return false
	}

	/**检查大妖之境某一层是否有红点 拓展了一下，其他功能也用到*/
	public CheckBossAbyssLayer(layer, boss_type = BossModel.BossType.abyss) {
		//判断vip等级
		let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
		if (role_vip < BossModel.BOSS_ABYSS_OPEN_VIP_LV && boss_type == BossModel.BossType.abyss) {
			return false
		}

		//是否有关注的boss
		let boss_info = this.GetBossTypeInfo(boss_type)
		if (boss_info) {
			let list = boss_info.boss_info
			let len = list.length
			let boss_vo
			for (let i = 0; i < len; i++) {
				boss_vo = list[i]

				//蜃气楼无限层 boss类型18 层数是1  因为界面特殊处理了layer=0 但数据源还是1 这里兼容下
				if (boss_type != BossModel.BossType.holy_wuxian) {
					if (boss_vo.layer != layer) continue
				}

				if (this.CheckBossRemainState(boss_vo)) {
					return true
				}
			}
		}

		return false
	}

	remian_boss_list
	remain_cancal_list
	remian_boss_index
	remian_cancal_index
	is_remaing//是否在设置自动关注中
	is_receview_base = false//是否接受到基本信息


	public AutoRemainBossAbyss2() {
		if (this.use_delete_method) return
		if (this.is_remaing) return
		if (!this.is_receview_base) return
		let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
		if (role_vip < BossModel.BOSS_ABYSS_OPEN_VIP_LV) return
		let role_lv = RoleManager.GetInstance().mainRoleInfo.level
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.abyss)

		//清理
		Laya.timer.clear(this, this.AutoRemianHelp)
		Laya.timer.clear(this, this.AutoRemianCancal)
		this.remian_boss_list = []
		this.remain_cancal_list = []

		if (boss_info) {
			let list = boss_info.boss_info
			let len = list.length
			let boss_vo
			for (let i = 0; i < len; i++) {
				boss_vo = list[i]
				if (role_vip < boss_vo.free_vip) continue

				//让他关注的boss能有收益，且不会有被碾压
				let level_gap = Math.abs(role_lv - boss_vo.lv)
				if (level_gap >= 100) {
					//低于-100级的 自动取关
					if ((role_lv - boss_vo.lv) > 0 && this.CheckBossRemainState(boss_vo, false)) {
						table.insert(this.remain_cancal_list, boss_vo)
					}
					continue
				}
				if (!this.CheckBossRemainState(boss_vo, false) && !this.IsPlayerCancalRemain(boss_vo)) {
					table.insert(this.remian_boss_list, boss_vo)
				}


			}
		}

		this.is_remaing = true
		this.remian_boss_index = 0
		this.remian_cancal_index = 0
		this.AutoRemianHelp()
	}

	/**vip等级提升 自动关注boss 
	 * 
	*/
	public AutoRemainBossAbyss() {
		Laya.timer.frameOnce(5, this, this.AutoRemainBossAbyss2)
	}

	public AutoRemianCancal() {
		if (this.remian_cancal_index >= this.remain_cancal_list.length) {
			this.is_remaing = false
			this.remian_cancal_index = 0
			this.remain_cancal_list = []
			return
		}

		let boss_vo = this.remain_cancal_list[this.remian_cancal_index]
		this.remian_cancal_index++
		if (boss_vo) {
			console.warn("自动取关-------------", boss_vo.boss_name, boss_vo.lv, boss_vo.layer)
			this.Fire(BossModel.SCMD_REQUEST, 46007, boss_vo.boss_type, boss_vo.boss_id, 0, 1)
		}
		//延迟更新
		Laya.timer.frameOnce(1, this, this.AutoRemianCancal, null, true)
	}



	public AutoRemianHelp() {
		if (this.remian_boss_index >= this.remian_boss_list.length) {
			this.remian_boss_index = 0
			this.remian_boss_list = []

			//自动取消部分
			this.AutoRemianCancal()
			return
		}

		let boss_vo = this.remian_boss_list[this.remian_boss_index]
		this.remian_boss_index++
		if (boss_vo) {
			console.warn("自动关注-------------", boss_vo.boss_name, boss_vo.lv, boss_vo.layer)
			this.Fire(BossModel.SCMD_REQUEST, 46007, boss_vo.boss_type, boss_vo.boss_id, 1, 1)
		}
		//延迟更新
		Laya.timer.frameOnce(1, this, this.AutoRemianHelp, null, true)
	}

	/**是否玩家自动取消关注 自动关注需要验证这个方法  1自动关注  0手动关注*/
	public IsPlayerCancalRemain(boss_vo) {
		return boss_vo.auto_remind == 0
	}


	/**--------------------蜃气楼红点 */

	edu_login_red = true
	edu_boss_red = false



	//有boss关注并存活  有奖励次数 
	public UpdateEduRed() {
		if (!this.common_mgr.CheckFuncOpenState("CrossServerEnterView", true)) return false

		let bool = false

		//无限层
		let boss_info = this.GetBossTypeInfo(BossModel.BossType.holy_wuxian)
		if (boss_info) {
			let list = boss_info.boss_info
			let len = list.length
			let boss_vo
			for (let i = 0; i < len; i++) {
				boss_vo = list[i]
				if (this.CheckBossRemainState(boss_vo)) {
					bool = true
					break
				}
			}
		}


		//正常层   
		let cross_server_boss_info = this.GetBossTypeInfo(BossModel.BossType.holy)
		if (!bool && cross_server_boss_info) {
			//是否有奖励次数
			let left_time = cross_server_boss_info.max_tired - cross_server_boss_info.tired
			if (left_time <= 0) {
				bool = false
			}else{

			let list = cross_server_boss_info.boss_info
			let len = list.length
			let boss_vo
			for (let i = 0; i < len; i++) {
				boss_vo = list[i]
				if (this.CheckBossRemainState(boss_vo)) {
					bool = true
					break
					}
				}
			}
		}


		if (bool != this.edu_boss_red) {
			//派发事件
			this.edu_boss_red = bool
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
			this.Fire(BossModel.UPDATE_EDU_BOSS_RED)
		}

	}


	/**蜃气楼红点 */
	public GetEduBossRed() {
		return this.edu_boss_red
	}

	/**检查登录红点 */
	public GetEduLoginRed() {
		if (!this.common_mgr.CheckFuncOpenState("CrossServerEnterView", true)) return false
		let cross_server_boss_info = this.GetBossTypeInfo(BossModel.BossType.holy)
		if (this.edu_login_red && cross_server_boss_info) {
			let left_time = cross_server_boss_info.max_tired - cross_server_boss_info.tired
			return left_time > 0
		}
		return false
	}

	/***登录红点 破坏 */
	public EduLoginRedBreak() {
		this.edu_login_red = false
		this.Fire(BossModel.UPDATE_EDU_BOSS_RED)
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
	}


	//墓碑怪相关

	/**切换场景 尝试在场景中创建墓碑怪
	 * 切换场景 会统一使用clearScene的方法清理墓碑怪
	*/
	public TryToCreatGrave() {
		let sceneInfo = this.scene_mgr.GetSceneInfo()
		if (!sceneInfo) return
		let scene_id = sceneInfo.id
		let boss_type = BossModel.GetBossTypeBySceneType[sceneInfo.type] || 0
		if (boss_type == 0) return

		let boss_Infos
		if (this.scene_mgr.IsKfHolyAreaScene()) {
			let scene_data = KfHolyAreaModel.GetInstance().GetSceneData(scene_id)
			boss_Infos = scene_data
		} else if (this.scene_mgr.IsEternityScene()) {
			let mdata = EternityModel.GetInstance().GetMonData()
			if (!mdata) {
				return
			}
			if (scene_id != mdata.scene) {
				return
			}
			boss_Infos = {}
			boss_Infos["boss_info"] = mdata.mon
		} else if (this.scene_mgr.IsHolyTerritory()) {
			let layer_num = scene_id - BossModel.BaseBossSceneId[boss_type]
			let terr_data = HolyTerritoryModel.GetInstance().monsterData[layer_num]
			boss_Infos = terr_data
		} else {
			boss_Infos = BossModel.GetInstance().GetBossTypeInfo(boss_type)
		}


		if (boss_Infos && boss_Infos.boss_info) {
			let boos_list = boss_Infos.boss_info
			for (let i = 0; i < boos_list.length; i++) {
				let boss_vo_source = boos_list[i]
				let boss_vo

				//是否检查boss的层级
				let is_check_layer = boss_type != BossModel.BossType.holy_wuxian ////蜃气楼无限层boss的layer会在EudaemonEnterView界面修改数据源  所以这里不检查层级

				if (this.scene_mgr.IsKfHolyAreaScene()) {
					//跨服异域
					is_check_layer = false //不需要区分层级
					boss_vo = this.GetGraveKfHolyBossInfo(boss_vo_source, boss_type)
				} else if (this.scene_mgr.IsEternityScene()) {
					//天启之源
					is_check_layer = false  //不需要区分层级
					boss_vo = this.GetGraveEternityBossInfo(boss_vo_source, boss_type, sceneInfo.id)
				} else if (this.scene_mgr.IsHolyTerritory()) {
					is_check_layer = false  //不需要区分层级
					boss_vo = boss_vo_source

				} else {
					boss_vo = boss_vo_source
				}

				if (boss_vo.reborn_time == 0) {
					//当前boss已经复活，检查这个boss的墓碑有没有创建，如果创建则删除
					this.SceneDeleteGrave(boss_vo.boss_type, boss_vo.boss_id)
					continue
				}

				//过滤不属于当前地图层级的boss
				if (is_check_layer) {
					let layer_num = scene_id - BossModel.BaseBossSceneId[boss_vo.boss_type]
					if (boss_vo.layer != layer_num) continue
				}


				//秘境boss   过滤宝箱、毁灭领主
				if (boss_vo.boss_type == BossModel.BossType.mystery && boss_vo.mon_type != 0) continue 


				//蜃气楼boss     秘宝处理
				if (boss_vo.boss_type == (1 + BossModel.cross_boss_base_index)) {
					let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_vo.boss_id, false)
					if (mon_cfg && mon_cfg.kind != 0) {
						continue
					}
				}

				SceneManager.GetInstance().AddGraveVo(boss_vo)
			}
		}

	}


	/**在场景中删除墓碑怪*/
	public SceneDeleteGrave(boss_type, boss_id) {

		let boss_vo = BossModel.GetInstance().GetBossInfo(boss_type, boss_id)
		if (boss_vo) {
			SceneManager.GetInstance().DeleteGraveVo(boss_vo.boss_id)
		}
	}


	/**创建跨服圣域boss墓碑数据 */
	public GetGraveKfHolyBossInfo(boss_vo_source, boss_type) {
		//跨服异域boss数据进行改造  尽量和平常的boss统一样式 需要避免修改数据源
		let boss_vo = {}
		boss_vo["lv"] = boss_vo_source["boss_lv"] || 1
		boss_vo["boss_id"] = boss_vo_source["bossid"] || 0
		boss_vo["reborn_time"] = boss_vo_source["reborn_time"] || 0
		boss_vo["boss_type"] = boss_type
		let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_vo_source["bossid"], false)
		boss_vo["boss_name"] = boss_info && boss_info.name || "神秘大妖"

		//位置
		let cfg = KfHolyAreaModel.GetInstance().GetMonsterCfg(boss_vo_source["bossid"])
		boss_vo["pos"] = cfg ? { x: cfg.x, y: cfg.y } : { x: 0, y: 0 }
		return boss_vo
	}


	/**创建天启之源boss墓碑数据 */
	public GetGraveEternityBossInfo(boss_vo_source, boss_type, scene_id) {

		// bl_server: 0
		// bl_server_name: ""
		// bl_server_num: 0
		// mon_id: 44003101
		// mon_lv: 624
		// mon_type: 1
		// reborn_time: 0

		let boss_vo = {}
		boss_vo["lv"] = boss_vo_source["lv"] || 1
		boss_vo["boss_id"] = boss_vo_source["mon_id"] || 0
		boss_vo["reborn_time"] = boss_vo_source["reborn_time"] || 0
		boss_vo["boss_type"] = boss_type

		//名字
		let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, boss_vo_source["mon_id"], false)
		boss_vo["boss_name"] = mdata && mdata.name || "神秘大妖"

		//位置
		let map_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientMapConfig[scene_id]
		if (map_cfg && map_cfg.point_list) {
			let p_list = map_cfg.point_list
			for (let i = 0; i < p_list.length; i++) {
				if (p_list[i].mon_id == boss_vo_source["mon_id"]) {
					boss_vo["pos"] = { x: p_list[i].x, y: p_list[i].y }
					break;
				}
			}
		} else {
			boss_vo["pos"] = { x: 0, y: 0 }
		}
		return boss_vo
	}


	/**
	 * 世界大妖  如果有未恢复的体力值额度，那么设置定时器刷新体力值
	 */
	public BossFieldRefreshVit(scmd) {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		//恢复一点体力所需要的时间
		let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
		//每天最多恢复的体力上限
		let add_vit_max = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_max", cfg)
		//每天恢复达到上限
		if (scmd.add_vit >= Number(add_vit_max)) return
		if (scmd.vit >= scmd.max_vit) return
		let v = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? 0.8 : 1
		let end_time = scmd.last_vit_time + time * v
		let left_time = end_time - TimeUtil.getServerTime()+1  //+1秒兼容
		GlobalTimerQuest.AddDelayQuest(()=>{
			BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
		},left_time)
	}
	///
}
window["BossModel"] = BossModel