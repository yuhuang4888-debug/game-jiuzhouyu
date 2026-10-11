import { EventDispatcher } from "../util/EventDispatcher"
import { ErlangParser } from "../util/ErlangParser"
import { Config } from "../common/Config"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ResManager } from "../common/ResManager"
import { CommonManager } from "../common/CommonManager"
import { TaskModel } from "./TaskModel"
import { BossModel } from "./BossModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Message } from "../sysInfo/SysInfoController"
import { OpenFun } from "../common/OpenFun"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

export const HTEvent = {
	UPDATE_ROLE_RANK: "UPDATE_ROLE_RANK",
	UPDATE_GUILD_RANk: "UPDATE_GUILD_RANk",
	OPEN_VIEW: "OPEN_VIEW",
	UPDATE_FGOLLOW_INFO: "UPDATE_FGOLLOW_INFO",
	REQUEST_PROTO: "REQUEST_PROTO",
	UPDATE_MONSTER_DATA: "UPDATE_MONSTER_DATA",
	BOSS_KILL: "BOSS_KILL",
	UPDATE_RELIVE: "UPDATE_RELIVE",
	KILL_DATA: "KILL_DATA",
	DSGT_DATA: "DSGT_DATA",
	UPDATE_SETTLE: "UPDATE_SETTLE",
	GO_HT: "HT1",
	FATIGUE: "HT2",
	UPDATE_RED: "UPDATE_RED"
}
window["HTEvent"] = HTEvent
export class HolyTerritoryModel extends EventDispatcher {
	CanAttack
	GetDsgtData
	GetKv
	GetScore
	GetTerData
	GoHT
	HasOpen
	InitCfg
	IsHTMonster
	IsSelfHT
	IsSelfHTById
	NeedShow
	RealTimeOpen
	SelfHT
	SetBossInfo
	SetBossRebornTime
	SetFatigue
	autoRelive
	dieTimes
	dsgtData
	killData
	maxDay
	maxFatige
	minDay
	monsterData
	nextReliveTime
	notFind
	safe_time
	sceneIdtoIndex
	setNextReliveTime
	showArrow
	icon_red = true
	ht_red_dir = {}
	monster_red_dir = {}

	Bosscfg
	Sanctuarykv
	Sanctuarymon
	SettleInfo
	GetIconRed
	SetIconRed
	RedFunc
	CanInto
	rRankData
	gRankData
	IsRealOpen
	OpenMaxDay
	red_icon_=false
	static _instance: HolyTerritoryModel

	public static IndexToWord = ["隐冰异域", "千森异域", "落日异域"];
	public static BackIndex = null;
	public constructor() {
		super()

		if (HolyTerritoryModel._instance) {
			return
		}
		this.monsterData = {};
		this.dsgtData = [];
		this.killData = [];
		this.sceneIdtoIndex = { [36001]: 1, [36002]: 2, [36003]: 3 };
		this.NeedShow = false;
		this.showArrow = false;
		this.SelfHT = false;
		this.notFind = false;
		this.minDay = 2;
		this.maxDay = 4;
		this.maxFatige = 80;
		this.nextReliveTime = 0;
		this.dieTimes = 0;
		this.safe_time = 0;
		this.autoRelive = false;
		let local_Config = Config
		let local_Erlang = ErlangParser.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let boss_base_model = BossModel.GetInstance()
		let local_BossBaseModel = BossModel
		let scene_mgr = SceneManager.GetInstance()
		let local_HTEvent = HTEvent
		let server_time_model = ServerTimeModel.GetInstance()
		let kvCfg_ = null
		let curFatige_ = 0
		let buffTime_ = 0
		let _buffTimer_ = null
		let _buffTime_ = 0
		this.InitCfg = () => {
			this.Bosscfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg
			this.Sanctuarykv = Config.PRELOAD_SERVER_CONFIG.config_sanctuary_kv
			this.Sanctuarymon = Config.PRELOAD_SERVER_CONFIG.config_sanctuary_mon
		}

		this.GetDsgtData = (id?) => {
			// [ts2lua]this.dsgtData下标访问可能不正确
			return this.dsgtData[id]
		}

		this.GetTerData = (id?) => {
			// [ts2lua]this.monsterData下标访问可能不正确
			return this.monsterData[id]
		}

		this.SetBossRebornTime = (sanctuary_id?, boss_id?, reborn_time?) => {
			// [ts2lua]this.monsterData下标访问可能不正确
			let bossData = this.monsterData[sanctuary_id]
			if (bossData) {
				let bossList = bossData.boss_info
				if (bossList) {
					for (let _tmpi in bossList) {
						var vo = bossList[_tmpi]
						if (vo.boss_id == boss_id) {
							vo.reborn_time = reborn_time
							break
						}
					}
				}
				// [ts2lua]this.monsterData下标访问可能不正确
				this.monsterData[sanctuary_id].boss_info = bossList
			}
		}

		this.GetScore = (type?, htId?, bossInfo?) => {
			if (!this.monsterData) {
				return
			}
			// [ts2lua]this.monsterData下标访问可能不正确
			let info = this.monsterData[htId]
			if (!info) {
				return
			}
			let notBelong = info.belong != role_mgr.GetMainRoleVo().guild_id
			if (notBelong && bossInfo) {
				// [ts2lua]cfgs下标访问可能不正确
				let cfg = this.Bosscfg[bossInfo.id]
				if (cfg && cfg.sign == 1) {
					return "<br/>击杀无法夺取积分"
				}
			}
			if ((info && info.belong) && notBelong) {
				let point = null
				// [ts2lua]kvCfg_下标访问可能不正确
				if (this.Sanctuarykv["kill_point"]) {
					// [ts2lua]kvCfg_下标访问可能不正确
					let list = JSON.parse(this.Sanctuarykv["kill_point"].sanctuary_value)
					for (let index in list) {

						// [ts2lua]list下标访问可能不正确
						if (Number(list[index][0]) == type) {
							// [ts2lua]list下标访问可能不正确
							if (Number(list[index][1]) < 1) {
								// [ts2lua]list下标访问可能不正确
								point = Number(list[index][1]) * 100 + "%"
							} else {
								// [ts2lua]list下标访问可能不正确
								point = Number(list[index][1])
							}
						}
					}
				}
				return "<br/>击杀夺取对方结社<font color='#0a953e'>" + point + "</font>积分"
			} else {
				return
			}
		}

		this.SetFatigue = (fatigue?) => {
			curFatige_ = fatigue
			let info = boss_base_model.GetBossTypeInfo(local_BossBaseModel.BossType.holyterritory)
			if (info) {
				info.tired = fatigue
				boss_base_model.SetBossTypeInfo(local_BossBaseModel.BossType.holyterritory, info)
			}
			this.Fire(local_HTEvent.FATIGUE, curFatige_, this.maxFatige)
		}

		this.SetBossInfo = (vo?, boss_cfgs?) => {
			if (!vo) {
				return
			}
			for (let _tmpi in vo.boss_info) {
				var boss = vo.boss_info[_tmpi]
				// [ts2lua]boss_cfgs下标访问可能不正确
				let boss_cfg = boss_cfgs[boss.boss_id]
				let mon_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, boss.boss_id, false)
				let typeCfg = this.Sanctuarymon
				// [ts2lua]typeCfg下标访问可能不正确
				if (typeCfg && typeCfg[vo.sanctuary_id + "@" + boss.boss_id]) {
					// [ts2lua]typeCfg下标访问可能不正确
					boss.monType = typeCfg[vo.sanctuary_id + "@" + boss.boss_id].mon_type
				}
				let condition = boss_cfg && boss_cfg.condition
				let open_lv = 0
				let max_lv = 999999
				let enter_vip = 0
				if (condition) {
					let list = JSON.parse(condition)
					for (let _tmpi in list) {
						var v = list[_tmpi]
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
					let list = JSON.parse(free_condition)
					for (let _tmpi in list) {
						var v = list[_tmpi]
						if (v[0] == "vip") {
							free_vip = Number(v[1])
						}
					}
				}
				boss.free_vip = free_vip
				let cost = boss_cfg && boss_cfg.cost
				let enter_cost = null
				if (cost) {
					let list = JSON.parse(cost)
					if (list.length > 0) {
						enter_cost = list
					}
				}
				boss.enter_cost = enter_cost
				boss.layer = vo.sanctuary_id
				boss.ratio_goods = boss_cfg && boss_cfg.ratio_goods
				boss.icon = mon_cfg && mon_cfg.icon
				boss.boss_name = mon_cfg && mon_cfg.name
				boss.lv = -1
				boss.boss_type = vo.boss_type
				// [ts2lua]lua中0和空字符串也是true，此处boss.is_remind == 1需要确认
				boss.is_remind = (boss.is_remind == 1 && (true) || (false))
			}
			//table.sort(vo.boss_info,(a?, b?) => {
			////return a.monType < b.monType
			//})
			vo.tired = curFatige_
			vo.all_tired = this.maxFatige
			boss_base_model.SetBossTypeInfo(local_BossBaseModel.BossType.holyterritory, vo)
		}

		this.GetKv = (key?) => {
			// [ts2lua]kvCfg_下标访问可能不正确
			if (this.Sanctuarykv[key]) {
				// [ts2lua]kvCfg_下标访问可能不正确
				return this.Sanctuarykv[key].sanctuary_value
			}
		}

		this.IsSelfHT = (sceneId?) => {
			let scene = sceneId || scene_mgr.GetSceneId()
			// [ts2lua]this.sceneIdtoIndex下标访问可能不正确
			if ((this.SettleInfo && this.SettleInfo.sanctuary_id) && this.sceneIdtoIndex[scene] == this.SettleInfo.sanctuary_id) {
				return true
			}
			return false
		}

		this.IsSelfHTById = (id?) => {
			// [ts2lua]this.sceneIdtoIndex下标访问可能不正确
			if (id && (this.SettleInfo && this.SettleInfo.sanctuary_id) && id == this.SettleInfo.sanctuary_id) {
				return true
			}
			return false
		}
		this.GoHT = (htId?, bossId?, cfg?) => {
			// [ts2lua]this.monsterData下标访问可能不正确
			let data = this.monsterData[htId]
			this.SetBossInfo(data, cfg)
			let index = 0
			let info = boss_base_model.GetBossTypeInfo(local_BossBaseModel.BossType.holyterritory)
			if (info && info.boss_info) {
				boss_base_model.SetEnterBossInfo({ boss_id: bossId })
				this.Fire(local_HTEvent.REQUEST_PROTO, 28303, "c", htId)
			}
		}

		this.IsHTMonster = (id?) => {
			if (id && this.Sanctuarymon) {
				// [ts2lua]this.sceneIdtoIndex下标访问可能不正确
				// [ts2lua]this.monCfg下标访问可能不正确
				return this.Sanctuarymon[this.sceneIdtoIndex[scene_mgr.curr_scene_id] + "@" + id]
			}
			return false
		}

		this.CanAttack = (type_id?) => {
			if (this.IsSelfHT()) {
				return
			}
			if (curFatige_ >= this.maxFatige) {
				// [ts2lua]Config.config_boss_cfg下标访问可能不正确
				let config = this.Bosscfg[type_id]
				if ((config && config.sign == 1)) {
					return false
				}
			}
			return true
		}

		/**废弃 */
		this.RealTimeOpen = () => {
			let cfg = this.GetKv("open_time")
			if (cfg) {
				let day = JSON.parse(cfg)
				let date = new Date(server_time_model.GetOpenServerTime() * 1000)
				let need_year = Number(day[1][0])
				let need_month = Number(day[1][1])
				let need_day = Number(day[1][2])
				if (date.getFullYear() > need_year || (date.getFullYear() == need_year &&
					date.getMonth() + 1 > need_month) || (date.getFullYear() == need_year &&
						date.getMonth() + 1 == need_month && date.getDate() >= need_day)) {
					return true
				}
			}
			return false
		}

		this.setNextReliveTime = (data?) => {
			this.nextReliveTime = data.time
			buffTime_ = data.die_time
			this.dieTimes = data.die_times
			this.safe_time = data.safe_time
			if (buffTime_ <= TimeUtil.getServerTime()) {
				this.dieTimes = 0
			}
			this.Fire(local_HTEvent.UPDATE_RELIVE)
		}

		this.HasOpen = () => {
			let cfg = CommonManager.GetInstance().GetFunctionIconCfg("283")
			if (cfg) {
				let roleVo = role_mgr.GetMainRoleVo()
				let openDay = server_time_model.GetOpenServerDay()
				if (((roleVo.level < cfg.open_lv || openDay < cfg.open_day) || cfg.max_open_day && openDay > cfg.max_open_day) || cfg.open_task_id && TaskModel.GetInstance().newest_finish_task_id < cfg.open_task_id) {
					return false
				}
				return true
			}
		}

		this.IsRealOpen =(is_tip?)=>{
			let boo =false
			let tip_str = ""
			if(this.HasOpen){
				let cfg = this.GetKv("open_day")
				if (cfg) {
					let data = JSON.parse(cfg) //{0: 2, 1: 4}
					let openDay = server_time_model.GetOpenServerDay()
					let min_openday = data[0]||2
					let max_openday = data[1]||4
					if (openDay>=min_openday&&openDay<=max_openday) {
						boo =true
					}
					if(is_tip){
						if (openDay<min_openday) {
							tip_str = `开服第${min_openday}天开启${is_tip}`
						}else if (openDay>max_openday) {
							tip_str = `活动不在开启时间`
						}
					}
				}
			}else{
				let cfg = CommonManager.GetInstance().GetFunctionIconCfg("283")
				tip_str = `开服第${cfg.open_day}天开启${is_tip}`
			}
			if(is_tip&&!boo){
				Message.show(tip_str)
			}
			return boo
		}
		//活动开启的最大开服天数
		this.OpenMaxDay=()=>{
			let cfg = CommonManager.GetInstance().GetFunctionIconCfg("283")
			return cfg&&cfg.max_open_day||0
		}
		this.SetIconRed = (r) => {
			let red = (this.GetIconRed() || r) && this.CanInto()
			this.red_icon_ = red
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 283, red)
		}

		this.GetIconRed = () => {
			let red = this.icon_red && this.IsRealOpen()
			return red
		}

		this.RedFunc = () => {
			let red = false
				for (let sanctuary_id in this.monsterData) {
					let bossData = this.monsterData[sanctuary_id]
					let data = this.GetTerData(sanctuary_id)
					let bool = (data && (data.belong != RoleManager.GetInstance().GetMainRoleVo().guild_id || data.belong == 0)) ? true : false
					if (bossData ) {
						let bossList = bossData.boss_info
						if (bossList) {
							for (let _tmpi in bossList) {
								let vo = bossList[_tmpi]
								if (vo.monType == 3) {
									if ((vo.reborn_time == 0 || vo.reborn_time - TimeUtil.getServerTime() <= 0) && this.CanInto() && bool) {
										this.ht_red_dir[sanctuary_id] = true
										this.monster_red_dir[vo.boss_id] = true
										red = true
									}
									else {
										this.ht_red_dir[sanctuary_id] = false
										this.monster_red_dir[vo.boss_id] = false
									}
								}

							}

						}
					}
				}

			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "holyTerritoryMainView", 1, red)
			this.SetIconRed(red)
			RedDotController.ins.up(RedKey.HOLY_TERRITORY, red);
			this.Fire(local_HTEvent.UPDATE_RED)
		}

		this.CanInto = () => {
			let server_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let date = new Date(TimeUtil.getServerTime() * 1000)
			let hour = date.getHours()
			return (server_day >= 2 && server_day <= 3 && ((hour >= 8 && hour <= 20) || ((hour >= 22 && hour <= 23) || (hour >= 0 && hour <= 2)))) || (server_day == 4 && hour >= 8 && hour <= 20)
		}
	}

	public static GetInstance() {

		if (!HolyTerritoryModel._instance) {
			HolyTerritoryModel._instance = new HolyTerritoryModel()
		}
		return HolyTerritoryModel._instance
	}

	// public static IsOpen() {
	// 	if (ServerTimeModel.GetInstance().GetOpenServerDay()==1) {
	// 		let date = new Date(TimeUtil.getServerTime() * 1000)
	// 		if (date.getHours() < 23) {
	// 			return false
	// 		}
	// 	}
	// 	return true
	// }

}
window["HolyTerritoryModel"] = HolyTerritoryModel