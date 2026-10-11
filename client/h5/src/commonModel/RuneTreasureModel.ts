import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { Config } from "../common/Config"

export const RuneTreasureEvent = {
	RUNE_TREASURE_REQUEST_PROTO: "RUNE_TREASURE_REQUEST_PROTO",
	RUNE_TREASURE_OPEN_VIEW: "RUNE_TREASURE_OPEN_VIEW",
	UPDATE_RUNE_TREASURE_DATA: "UPDATE_RUNE_TREASURE_DATA",
	OPEN_GETREWARD_VIEW: "OPEN_GETREWARD_VIEW",
	UPDATE_EQUIP_RECORD_DATA: "UPDATE_EQUIP_RECORD_DATA",
	ADD_RECORD_DATA: "ADD_RECORD_DATA",
	SELECT_SHOP_ITEM: "SELECT_SHOP_ITEM",
	UPDATE_EQUIP_SCORE: "UPDATE_EQUIP_SCORE",
	GET_REWARD_TO_BAG: "GET_REWARD_TO_BAG",
	GET_ONE_REWARD: "GET_ONE_REWARD",
	UPDATE_LUCKEY: "UPDATE_LUCKEY",
	FIRST: "FIRST",
	UPDATE_RED: "UPDATE_RED",
	UPDATE_REWARD_TYPE: "UPDATE_REWARD_TYPE",
	TASK_UPDATE: "TASK_UPDATE",
	RUNE_ANIM_END: "RUNE_ANIM_END"
}
window["RuneTreasureEvent"] = RuneTreasureEvent
export class RuneTreasureModel extends EventDispatcher {
	CancelEquipFreeTimer
	CancelExtremeFreeTimer
	CancelFreeTimer
	CancelPeakFreeTimer
	GetAllRed
	GetImageStatus
	GetLuckValue
	GetTreasureHuneKeyCfg
	GetTreasureRewardByRuneFloor
	GetTreasureRewardByColor
	GetTypeWord
	InitConfig
	SetRecordData
	SetRuneTreasureData
	ShowEquipRed
	ShowRedDot
	StartEquipFreeTimer
	StartExtremeFreeTimer
	StartFreeTimer
	StartPeakFreeTimer
	TypeToColor
	TypeToModule
	check_equip_free
	check_extreme_free
	check_peak_free
	drawRedList
	drawWeaponlist
	equip_treasure_socre
	luckey
	on_time
	record_data_list
	red_state_list
	rune_treasure_data
	show_daimond_cost_alert
	show_rune_alert
	taskCfg
	taskList
	cfg
	need_init_effect = true
	treasure_rune_lock = false
	public treasure_type_id = 1 //当前打开的夺宝界面，不包含御魂召唤
	public static show_bag_pos

	public static RUNE_TREASURE_TASK_ID = 100990;
	public static EQUIP_TREASURE_TASK_ID = 100400;
	public static RUNE_TREASURE_TYPE = 4;
	public static RUNE_TREASURE_TICKET = 36255006;
	public static RUNE_TREASURE_OPEN_LV = 68;
	public static EQUIP_TREASURE_TYPE = 1;
	public static EQUIP_TREASURE_TICKET = 38180001;
	public static EQUIP_TREASURE_OPEN_LV = 30;
	public static show_equip_cost_alert = false;
	public static PEAK_TREASURE_TYPE = 2;
	public static PEAK_TREASURE_TICKET = 38180002;
	public static PEAK_TREASURE_OPEN_LV = 371;
	public static show_peak_cost_alert = false;
	public static EXTREME_TREASURE_TYPE = 3;
	public static EXTREME_TREASURE_TICKET = 36255009;
	public static EXTREME_TREASURE_OPEN_LV = 500;
	public static show_extreme_cost_alert = false;
	public static BABY_TREASURE_TYPE = 5;
	public static BABY_TREASURE_TICKET = 36255037;
	public static BABY_TREASURE_OPEN_LV = 120;
	public static show_baby_cost_alert = false;
	public static QF_RECORD_LEN = 20;
	public static GR_RECORD_LEN = 30;
	public static showCount = 10;
	public static ViewToIndex = { EQUIP: 0, RUNE: 1, PEAK: 2, EXTREME: 3 };
	public static TEN_COMPANY_TICKET = 36255000;
	static Instance: any

	public constructor() {
		super()

		if (RuneTreasureModel.Instance) {
			return
		}
		this.red_state_list = [];
		this.show_daimond_cost_alert = false;
		this.show_rune_alert = false
		this.equip_treasure_socre = 0;
		this.record_data_list = [];
		this.luckey = [];
		this.drawWeaponlist = [];
		this.drawRedList = [];
		this.taskList = [];
		let local_RuneTreasureModel = RuneTreasureModel
		let local_RuneTreasureEvent = RuneTreasureEvent
		let local_laya = Laya
		let local_TimeUtil = TimeUtil
		let goods_model = GoodsModel.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let count_free_time_id_ = null
		let equip_free_timer_ = null
		let peak_free_timer_ = null
		let extreme_free_timer_ = null
		this.InitConfig = () => {
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt
			if (cfgs) {
				local_RuneTreasureModel.EQUIP_TREASURE_TICKET = cfgs[4].value
				local_RuneTreasureModel.EQUIP_TREASURE_OPEN_LV = cfgs[1].value
				local_RuneTreasureModel.PEAK_TREASURE_TICKET = cfgs[5].value
				local_RuneTreasureModel.PEAK_TREASURE_OPEN_LV = cfgs[2].value
				local_RuneTreasureModel.EXTREME_TREASURE_TICKET = cfgs[6].value
				local_RuneTreasureModel.EXTREME_TREASURE_OPEN_LV = cfgs[3].value
				// [ts2lua]config_treasure_hunt_下标访问可能不正确
				local_RuneTreasureModel.BABY_TREASURE_TICKET = cfgs[42].value
				// [ts2lua]config_treasure_hunt_下标访问可能不正确
				local_RuneTreasureModel.BABY_TREASURE_OPEN_LV = cfgs[41].value
				// [ts2lua]config_treasure_hunt_下标访问可能不正确
				local_RuneTreasureModel.RUNE_TREASURE_OPEN_LV = cfgs[12].value
				if (cfgs[39]) {
					// [ts2lua]config_treasure_hunt_下标访问可能不正确
					local_RuneTreasureModel.showCount = cfgs[39].value
				}
				this.cfg = cfgs
			}

			this.taskCfg = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt_task
		}

		this.SetRuneTreasureData = (data?) => {
			this.rune_treasure_data = data
			this.Fire(local_RuneTreasureEvent.UPDATE_RUNE_TREASURE_DATA)
			this.ShowRedDot()
			if (this.rune_treasure_data) {
				this.StartFreeTimer(this.rune_treasure_data.rune_free_time)
			}
		}

		this.StartFreeTimer = (time?) => {
			/* 	this.CancelFreeTimer()
	
				//count_free_time_id_ = local_laya. new Timer(1000, 0)
				//count_free_time_id_:addEventListener(local_laya.TimerEvent.TIMER, this.on_time, this)
				//count_free_time_id_:start()
				count_free_time_id_ = GlobalTimerQuest.AddDelayQuest(() => {
					this.on_time()
				}, 1)
	
				this.on_time() */
			// 倒计时结束请求刷新
			let left_time = this.rune_treasure_data.rune_free_time - local_TimeUtil.getServerTime();
			if (left_time > 0) {
				let nextTime = GlobalTimerQuest.AddDelayQuest(() => {
					this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41601, "h", local_RuneTreasureModel.RUNE_TREASURE_TYPE)
					nextTime = null;
				}, left_time)
			}
		}

		/* 	this.on_time = () => {
				if (this.rune_treasure_data && this.rune_treasure_data.rune_free_time != null) {
	
					if (left_time < 0) {
						this.CancelFreeTimer()
	
						return
					}
				} else {
					this.CancelFreeTimer()
				}
			} */

		this.CancelFreeTimer = () => {
			if (count_free_time_id_) {
				//count_free_time_id_:stop()
				//count_free_time_id_:removeEventListener(local_laya.TimerEvent.TIMER, this.on_time, this)
				GlobalTimerQuest.CancelQuest(count_free_time_id_)
				count_free_time_id_ = null
			}
		}

		this.GetTreasureRewardByRuneFloor = (hunt_reward_cfg?, floor?) => {
			let list = []
			if (hunt_reward_cfg && floor != null) {
				let vo = null
				let basic = null
				for (let key in hunt_reward_cfg) {
					vo = hunt_reward_cfg[key]
					if (vo.htype == local_RuneTreasureModel.RUNE_TREASURE_TYPE && (floor >= vo.max_rlv || floor == vo.min_rlv && floor <= vo.max_rlv)) {
						basic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
						if (basic) {
							table.insert(list, vo)
							vo.color = basic.color
						}
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a.id < b.id
			}
			table.sort(list, sort_fun)
			return list
		}

		this.GetTreasureRewardByColor = (hunt_reward_cfg?, color?) => {
			let list = []
			if (hunt_reward_cfg && color != null) {
				let vo = null
				let basic = null
				for (let key in hunt_reward_cfg) {
					vo = hunt_reward_cfg[key]
					if(vo.goods_id == 26270005 || vo.goods_id == 26260005) continue
					basic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
					if (vo.htype == local_RuneTreasureModel.RUNE_TREASURE_TYPE && basic && basic.color >= color) {
						table.insert(list, vo)
						vo.color = basic.color
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a.id < b.id
			}
			table.sort(list, sort_fun)
			return list
		}

		this.GetTreasureHuneKeyCfg = (key?) => {
			return this.cfg[key]
		}

		this.ShowRedDot = () => {
			if (this.rune_treasure_data) {
				red_dot_mgr.ClearRedStatus(local_ModuleType.RUNE_TREASURE_RED)
				let show = false
				if (CommonManager.GetInstance().CheckFuncOpenState("RuneTreasureMainView", true)) {
					show = this.rune_treasure_data.rune_free_time - local_TimeUtil.getServerTime() > 0 ? false : true
					if (!show) {
						let my_have = goods_model.GetTypeGoodsNum(local_RuneTreasureModel.RUNE_TREASURE_TICKET)
						let specail_num = goods_model.GetTypeGoodsNum(local_RuneTreasureModel.TEN_COMPANY_TICKET)
						//折扣
						let config_treasure_hunt_ = Config.PRELOAD_SERVER_CONFIG.config_treasure_hunt
						let discount=0
						if(config_treasure_hunt_){
							let discount_list = JSON.parse(config_treasure_hunt_[47].value)
							discount = discount_list[1][1]
						}
						let need_num = discount == 0 || discount == 10 ? 10 : discount
						show = my_have >= need_num || specail_num > 0
						if (!show) {
							for (let _tmpi in this.rune_treasure_data.stage_reward_list) {
								var vo = this.rune_treasure_data.stage_reward_list[_tmpi]
								if (vo.status == 1) {
									show = true
									break
								}
							}
						}
					}
				}
				red_dot_mgr.SetRedStatus(local_ModuleType.RUNE_TREASURE_RED, 1, show)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 416)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RuneTreasureBaseView", RuneTreasureModel.ViewToIndex.RUNE, show)
			}
		}

		this.ShowEquipRed = () => {
			let index = 1
			let RoleLv = RoleManager.GetInstance().GetMainRoleVo().level
			if (RoleLv >= local_RuneTreasureModel.EQUIP_TREASURE_OPEN_LV && goods_model.GetTypeGoodsNum(local_RuneTreasureModel.EQUIP_TREASURE_TICKET) >= 9) {
				red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_TREASURE_RED, 1, true)
			} else {
				red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_TREASURE_RED, 1, false)
			}
			if (RoleLv >= local_RuneTreasureModel.PEAK_TREASURE_OPEN_LV && goods_model.GetTypeGoodsNum(local_RuneTreasureModel.PEAK_TREASURE_TICKET) >= 9) {
				red_dot_mgr.SetRedStatus(local_ModuleType.PEAK_TREASURE_RED, 1, true)
			} else {
				red_dot_mgr.SetRedStatus(local_ModuleType.PEAK_TREASURE_RED, 1, false)
			}
			if (RoleLv >= local_RuneTreasureModel.EXTREME_TREASURE_OPEN_LV && goods_model.GetTypeGoodsNum(local_RuneTreasureModel.EXTREME_TREASURE_TICKET) >= 9) {
				red_dot_mgr.SetRedStatus(local_ModuleType.EXTREME_TREASURE_RED, 1, true)
			} else {
				red_dot_mgr.SetRedStatus(local_ModuleType.EXTREME_TREASURE_RED, 1, false)
			}
			let bagRed = goods_model.treasure_goods_list && goods_model.treasure_goods_list.length > 0
			red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_TREASURE_RED, 2, bagRed)
			red_dot_mgr.SetRedStatus(local_ModuleType.PEAK_TREASURE_RED, 2, bagRed)
			red_dot_mgr.SetRedStatus(local_ModuleType.EXTREME_TREASURE_RED, 2, bagRed)
			if (this.record_data_list) {
				let i = 1
				do {
					let key = i + "@2"
					let show = false
					if (!this.record_data_list[key]) {
						key = i + "@1"
					}
					if (this.record_data_list[key]) {
						if (this.record_data_list[key].free_time == 0 && this.record_data_list[key].freetimes > 0) {
							show = true
						} else {
							show = this.record_data_list[key].free_time - local_TimeUtil.getServerTime() > 0 ? false : true
						}
					}
					red_dot_mgr.SetRedStatus(this.TypeToModule(i), 3, show)
					i = i + 1
				} while ((i < 4))
			} else {
				red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_TREASURE_RED, 3, false)
				red_dot_mgr.SetRedStatus(local_ModuleType.PEAK_TREASURE_RED, 3, false)
				red_dot_mgr.SetRedStatus(local_ModuleType.EXTREME_TREASURE_RED, 3, false)
			}
			let i = 1
			do {
				red_dot_mgr.SetRedStatus(this.TypeToModule(i), 4, this.drawRedList[i] && this.drawWeaponlist[i])
				i = i + 1
			} while ((i < 4))
			this.Fire(local_RuneTreasureEvent.UPDATE_RED)
			///////////////
			let iconred = false
			let red11 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.EQUIP_TREASURE_RED)
			let red22 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.PEAK_TREASURE_RED)
			let red33 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.PEAK_TREASURE_RED)
			iconred = iconred || red11 || red22 || red33
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 416, iconred)
		}

		this.SetRecordData = (data?) => {
			if ((data && data.htype) && data.rtype) {
				if (!this.record_data_list[data.htype + "@" + data.rtype]) {
					this.record_data_list[data.htype + "@" + data.rtype] = []
				}
				if (data.rtype == 1) {
					if (data.list.length > local_RuneTreasureModel.QF_RECORD_LEN) {
						let length = data.list.length

						for (let i = length; i >= local_RuneTreasureModel.QF_RECORD_LEN; i -= 1) {
							table.remove(data.list, i)
						}
						//data.list.splice(local_RuneTreasureModel.QF_RECORD_LEN)
					}
				} else if (data.rtype == 2) {
					if (data.list.length > local_RuneTreasureModel.GR_RECORD_LEN) {
						let length = data.list.length

						for (let i = length; i >= local_RuneTreasureModel.GR_RECORD_LEN; i -= 1) {
							table.remove(data.list, i)
						}
						//data.list.splice(local_RuneTreasureModel.GR_RECORD_LEN)
					}
				}
				// [ts2lua]this.record_data_list下标访问可能不正确
				this.record_data_list[data.htype + "@" + data.rtype] = data
				this.equip_treasure_socre = data.score
				this.Fire(local_RuneTreasureEvent.UPDATE_EQUIP_RECORD_DATA, data)
				// [ts2lua]this.drawWeaponlist下标访问可能不正确
				this.drawWeaponlist[data.htype] = data.draw_weapon
				if (data.freetimes == 0 && data.free_time > local_TimeUtil.getServerTime()) {
					if (data.htype == local_RuneTreasureModel.EQUIP_TREASURE_TYPE) {
						this.StartEquipFreeTimer()
					} else if (data.htype == local_RuneTreasureModel.PEAK_TREASURE_TYPE) {
						this.StartPeakFreeTimer()
					} else if (data.htype == local_RuneTreasureModel.EXTREME_TREASURE_TYPE) {
						this.StartExtremeFreeTimer()
					}
				}
				this.ShowEquipRed()
			}
		}

		this.GetTypeWord = (type?) => {
			if (type == local_RuneTreasureModel.EQUIP_TREASURE_TYPE) {
				return "装备夺宝"
			} else if (type == local_RuneTreasureModel.PEAK_TREASURE_TYPE) {
				return "巅峰夺宝"
			} else if (type == local_RuneTreasureModel.EXTREME_TREASURE_TYPE) {
				return "至尊夺宝"
			}
			return ""
		}

		this.StartEquipFreeTimer = () => {
			this.CancelEquipFreeTimer()

			//equip_free_timer_ = local_laya. new Timer(1000, 0)
			//equip_free_timer_:addEventListener(local_laya.TimerEvent.TIMER, this.check_equip_free, this)
			//equip_free_timer_:start()
			equip_free_timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.check_equip_free()
			}, 1, -1)

			this.check_equip_free()
		}

		this.check_equip_free = () => {
			// [ts2lua]this.record_data_list下标访问可能不正确
			// [ts2lua]this.record_data_list下标访问可能不正确
			if ((this.record_data_list && this.record_data_list["1@2"]) && this.record_data_list["1@2"].free_time != null) {
				// [ts2lua]this.record_data_list下标访问可能不正确
				let left_time = this.record_data_list["1@2"].free_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelEquipFreeTimer()
					this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41608, "cc", local_RuneTreasureModel.EQUIP_TREASURE_TYPE, 1)
					if (ServerTimeModel.GetInstance().GetOpenServerDay() >= 8) {
						this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41612, "c", local_RuneTreasureModel.EQUIP_TREASURE_TYPE)
					}
					return
				}
			} else {
				this.CancelEquipFreeTimer()
			}
		}

		this.CancelEquipFreeTimer = () => {
			if (equip_free_timer_) {
				//equip_free_timer_:stop()
				//equip_free_timer_:removeEventListener(local_laya.TimerEvent.TIMER, this.check_equip_free, this)
				GlobalTimerQuest.CancelQuest(equip_free_timer_)
				equip_free_timer_ = null
			}
		}

		this.StartPeakFreeTimer = () => {
			this.CancelPeakFreeTimer()
			//peak_free_timer_ = local_laya. new Timer(1000, 0)
			//peak_free_timer_:addEventListener(local_laya.TimerEvent.TIMER, this.check_peak_free, this)
			//peak_free_timer_:start()
			peak_free_timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.check_peak_free()
			}, 1, -1)
			this.check_peak_free()
		}

		this.check_peak_free = () => {
			// [ts2lua]this.record_data_list下标访问可能不正确
			// [ts2lua]this.record_data_list下标访问可能不正确
			if ((this.record_data_list && this.record_data_list["2@2"]) && this.record_data_list["2@2"].free_time != null) {
				// [ts2lua]this.record_data_list下标访问可能不正确
				let left_time = this.record_data_list["2@2"].free_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelPeakFreeTimer()
					this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41608, "cc", local_RuneTreasureModel.PEAK_TREASURE_TYPE, 1)
					if (ServerTimeModel.GetInstance().GetOpenServerDay() >= 8) {
						this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41612, "c", local_RuneTreasureModel.PEAK_TREASURE_TYPE)
					}
					return
				}
			} else {
				this.CancelPeakFreeTimer()
			}
		}

		this.CancelPeakFreeTimer = () => {
			if (peak_free_timer_) {
				//peak_free_timer_:stop()
				//peak_free_timer_:removeEventListener(local_laya.TimerEvent.TIMER, this.check_peak_free, this)
				GlobalTimerQuest.CancelQuest(peak_free_timer_)
				peak_free_timer_ = null
			}
		}

		this.StartExtremeFreeTimer = () => {
			this.CancelExtremeFreeTimer()
			//extreme_free_timer_ = local_laya. new Timer(1000, 0)
			//extreme_free_timer_:addEventListener(local_laya.TimerEvent.TIMER, this.check_extreme_free, this)
			//extreme_free_timer_:start()


			extreme_free_timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.check_extreme_free()
			}, 1, -1)

			this.check_extreme_free()
		}

		this.check_extreme_free = () => {
			// [ts2lua]this.record_data_list下标访问可能不正确
			// [ts2lua]this.record_data_list下标访问可能不正确
			if ((this.record_data_list && this.record_data_list["3@2"]) && this.record_data_list["3@2"].free_time != null) {
				// [ts2lua]this.record_data_list下标访问可能不正确
				let left_time = this.record_data_list["3@2"].free_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelExtremeFreeTimer()
					this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41608, "cc", local_RuneTreasureModel.EXTREME_TREASURE_TYPE, 1)
					if (ServerTimeModel.GetInstance().GetOpenServerDay() >= 8) {
						this.Fire(local_RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41612, "c", local_RuneTreasureModel.EXTREME_TREASURE_TYPE)
					}
					return
				}
			} else {
				this.CancelExtremeFreeTimer()
			}
		}

		this.CancelExtremeFreeTimer = () => {
			if (extreme_free_timer_) {
				//extreme_free_timer_:stop()
				//extreme_free_timer_:removeEventListener(local_laya.TimerEvent.TIMER, this.check_extreme_free, this)
				GlobalTimerQuest.CancelQuest(extreme_free_timer_)
				extreme_free_timer_ = null
			}
		}

		this.TypeToColor = (type?) => {
			let color = null
			if (1 == type) {
				color = "b"
			} else if (2 == type) {
				color = "p"
			} else if (3 == type) {
				color = "y"
			}
			return color
		}

		this.GetImageStatus = (type?) => {
			// [ts2lua]this.luckey下标访问可能不正确
			let luck1 = this.luckey[type]
			let status = null
			let index = 0
			let resName = ""
			if (luck1 && luck1.luckey_value) {
				if (luck1.luckey_value < 400) {
					status = false
					resName = ""
				} else if (luck1.luckey_value < 500) {
					status = true
					resName = "uizbxb_013a"
				} else {
					status = true
					resName = "uizbxb_013b"
				}
			}
			if (type != 1) {
				index = type
			}
			return [status, index, resName]
		}

		this.GetLuckValue = () => {
			let max = 0
			let roleLv = RoleManager.GetInstance().GetMainRoleLevel()
			for (let key in this.luckey) {
				var vo = this.luckey[key]
				if (vo.luckey_value > max) {
					if (vo.htype == 1 && roleLv >= RuneTreasureModel.EQUIP_TREASURE_OPEN_LV ||
						vo.htype == 3 && roleLv >= RuneTreasureModel.EXTREME_TREASURE_OPEN_LV ||
						vo.htype == 2 && roleLv >= RuneTreasureModel.PEAK_TREASURE_OPEN_LV) {
						max = vo.luckey_value
					}
				}
			}
			if (max < 400) {
				return 0
			} else if (max >= 500) {
				return 2
			} else {
				return 1
			}
		}

		this.TypeToModule = (type?) => {
			if (type == 1) {
				return local_ModuleType.EQUIP_TREASURE_RED
			} else if (type == 2) {
				return local_ModuleType.PEAK_TREASURE_RED
			} else if (type == 3) {
				return local_ModuleType.EXTREME_TREASURE_RED
			}
		}

		this.GetAllRed = (thisObj?) => {
			let bool = (red_dot_mgr.GetRedStatus(ModuleType.EQUIP_TREASURE_RED) && red_dot_mgr.GetRedStatus(ModuleType.EQUIP_TREASURE_RED) > 0) ||
				(red_dot_mgr.GetRedStatus(ModuleType.PEAK_TREASURE_RED) && red_dot_mgr.GetRedStatus(ModuleType.PEAK_TREASURE_RED) > 0) ||
				(red_dot_mgr.GetRedStatus(ModuleType.EXTREME_TREASURE_RED) && red_dot_mgr.GetRedStatus(ModuleType.EXTREME_TREASURE_RED) > 0) ||
				(red_dot_mgr.GetRedStatus(ModuleType.RUNE_TREASURE_RED) && red_dot_mgr.GetRedStatus(ModuleType.RUNE_TREASURE_RED) > 0)
			if (bool == null) {
				bool = false
			}
			return bool
		}
	}

	public static GetInstance() {

		if (!RuneTreasureModel.Instance) {
			RuneTreasureModel.Instance = new RuneTreasureModel()
		}
		return RuneTreasureModel.Instance
	}

}
window["RuneTreasureModel"] = RuneTreasureModel