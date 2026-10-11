import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"

export const Adventure_Cfg = {
	loc: 0,
	reward: 1,
	kv: 2,
	rand: 3
}

export class AdventureModel extends EventDispatcher {
	BuyShopData
	CheckAdveOpenStatus
	CheckAllRed
	GetBoxCfg
	GetBoxType
	GetCfgBYType
	GetLocCfgByTurn
	GetRedValue
	GetShopRed
	GetViewInfo
	GetZoreStatus
	InitLocCfg
	LoadCfg
	RefShopRed
	SetAdvShopData
	SetTimeInfo
	SetViewInfo
	alert_ref
	alert_status
	cur_icon_type
	free_times
	is_request_42702
	outTime
	setAdventureKvCfg
	shop_data
	act_open_
	public static Instance
	public static OPEN_VIEW = "AdventureModel.OPEN_VIEW";
	public static REQUEST_SCMD = "AdventureModel.REQUEST_SCMD";
	public static UPDATA_VIEW = "AdventureModel.UPDATA_VIEW";
	public static OPEN_BOX = "AdventureModel.OPEN_BOX";
	public static UPDATE_SHOPVIEW = "AdventureModel.UPDATE_SHOPVIEW";
	public static BUY_SUCCESS = "AdventureModel.BUY_SUCCESS";
	public static UPDATE_RED = "AdventureModel.UPDATE_RED";
	public constructor() {
		super()


		this.is_request_42702 = false;
		this.free_times = 0;
		this.alert_ref = true;
		this.outTime = 15;
		this.alert_status = { alert_go: true, alert_ref: true, alert_shop_ref: true, alert_shop_buy: true };
		let local_Adventure_Cfg = Adventure_Cfg
		let local_Erlang = ErlangParser.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_AdventureModel = AdventureModel
		let local_Message = Message
		let cfg_list_ = []
		let info_ = null
		let loc_dic_ = null
		this.act_open_ = false
		let shop_free_red_ = 0
		this.LoadCfg = () => {
			this.alert_status = { alert_go: true, alert_ref: true, alert_shop_ref: true, alert_shop_buy: true };
			this.is_request_42702 = false;
			this.free_times = 0;
			this.alert_ref = true;
			info_ = null
			loc_dic_ = null
			this.act_open_ = false
			shop_free_red_ = 0
			ResManager.GetInstance().LoadGameConfig(this, "config_adventure_rand", false, undefined, (cfg?) => {
				cfg_list_[local_Adventure_Cfg.rand] = cfg
				this.InitLocCfg()
			}) //Config.Adventurerand

		}

		this.InitLocCfg = () => {
			let rand_list = cfg_list_[local_Adventure_Cfg.rand]
			if (rand_list) {
				for (let i in rand_list) {
					let cost = rand_list[i].cost
					if (cost != "[]" && typeof (cost) == "string") {
						rand_list[i].cost = JSON.parse(cost)
					} else if (cost == "[]") {
						let num = rand_list[i].high_point - rand_list[i].low_point + 1
						this.free_times = this.free_times + num
					}
				}
				cfg_list_[local_Adventure_Cfg.rand] = rand_list
			}
		}

		this.setAdventureKvCfg = (adventure_kv_cfg?) => {
			let kv_list = adventure_kv_cfg
			if (kv_list && !adventure_kv_cfg["has_set_parse_value"]) {
				let box_type_dic = []
				for (let key in kv_list) {

					let boxs = null
					let _type = null
					if (5 == Number(key)) {
						_type = "com"
						boxs = kv_list[key]
					} else if (6 == Number(key)) {
						_type = "high"
						boxs = kv_list[key]
					} else if (9 == Number(key)) {
						_type = "ultimate"
						boxs = kv_list[key]
					} else if (10 == Number(key)) {
						_type = "special"
						boxs = kv_list[key]
					} else if (12 == Number(key)) {
						let value = kv_list[key].value
						if (typeof (value) == "string") {
							value = JSON.parse(value)
						}
						let dic = []
						if (!value) {
							return
						}
						for (let _tmpi in value) {
							var v = value[_tmpi]
							for (let _tmpi in v[1]) {
								var vo = v[1][_tmpi]
								dic[Number(vo)] = v[0]
							}
						}
						kv_list[key].value = dic
					}
					if (boxs) {
						let list = boxs.value
						if (typeof (list) == "string") {
							list = local_Erlang.Parse(list)
						}
						for (let _tmpi in list) {
							var v = list[_tmpi]
							box_type_dic[Number(v)] = _type
						}
					}
				}
				kv_list["box_dic"] = box_type_dic
				adventure_kv_cfg["has_set_parse_value"] = true
			}
			return kv_list
		}

		this.GetBoxType = (box_id?, config_adventure_kv?) => {
			let list = this.setAdventureKvCfg(config_adventure_kv)
			if (!list) {
				return null
			}
			if (!list["box_dic"]) {
				return null
			}
			return list["box_dic"][box_id]
		}

		this.GetBoxCfg = (stage?, _type?, config_adventure_reward?) => {
			let box_cfg = null
			let reward_list = config_adventure_reward
			let reward = null
			if (reward_list) {
				for (let i in reward_list) {

					let reward = reward_list[i].reward
					if (typeof (reward) == "string") {
						reward = JSON.parse(reward)
					}
					reward_list[i].reward = reward
				}
				box_cfg = reward_list
			}
			if (box_cfg) {
				for (let key in box_cfg) {

					let cur_cfg = box_cfg[key]
					if ((cur_cfg && cur_cfg.stage == stage) && cur_cfg.type == _type) {
						let rew = cur_cfg.reward
						if (rew && typeof (rew) == "string") {
							rew = local_Erlang.Parse(rew)
						}
						if (rew.length) {
							reward = rew
						}
					}
				}
			}
			return reward
		}

		this.GetLocCfgByTurn = (stage?, turn?, adventure_loc_cfg?) => {
			let loc_doc = []
			if (adventure_loc_cfg) {
				for (let key in adventure_loc_cfg) {

					let v = adventure_loc_cfg[key]
					let s = v.stage
					loc_doc = loc_doc || []
					loc_doc[s] = loc_doc[s] || []
					table.insert(loc_doc[s], v)
				}
				if (Util.IsTableEmpty(loc_doc)) {
					return
				}
				let list = loc_doc[stage]
				let vo = []
				if (list) {
					for (let _tmpi in list) {
						var v = list[_tmpi]
						if (v.down_turn <= turn && v.up_turn >= turn) {
							table.insert(vo, v)
						}
					}
				}
				return vo
			}
		}

		this.GetCfgBYType = (type?) => {
			if (type != null) {
				return cfg_list_[type]
			}
		}

		this.SetTimeInfo = (adventure_kv_cfg?, scmd?) => {
			let ai_mgr = ActivityIconManager.GetInstance()
			ai_mgr.deleteIcon("42701")
			ai_mgr.deleteIcon("42702")
			if (scmd) {
				info_ = info_ || {}
				info_.stage = scmd.stage
				info_.start_time = scmd.start_time
				info_.end_time = scmd.end_time
			}
			if (!info_) {
				return
			}
			let now_date = new Date(local_TimeUtil.getServerTime() * 1000)
			let cur_ween = (now_date.getDay() && (now_date.getDay()) || (7))
			let config_adventure_kv = this.setAdventureKvCfg(adventure_kv_cfg)
			let kv_value = (config_adventure_kv && config_adventure_kv[12]) && config_adventure_kv[12].value
			let iocn_type = "42701"
			if (kv_value) {
				iocn_type = kv_value[cur_ween]
			}
			this.act_open_ = false
			let func_is_open = common_mgr.CheckFuncOpenState("GodEquipBuildView", true)

			if (((func_is_open && info_.stage > 0) && local_TimeUtil.getServerTime() >= info_.start_time) && local_TimeUtil.getServerTime() < info_.end_time) {
				this.act_open_ = true
				this.Fire(local_AdventureModel.REQUEST_SCMD, 42701)
				this.Fire(local_AdventureModel.REQUEST_SCMD, 42704)
				ai_mgr.addIcon(iocn_type)
				this.cur_icon_type = String(iocn_type)
			}
		}

		this.SetViewInfo = (scmd?) => {
			if (!scmd) {
				return
			}
			info_ = info_ || {}
			info_.circle = scmd.circle
			info_.location = scmd.location
			info_.left_times = scmd.left_times
			info_.throw_times = scmd.throw_times
			info_.free_reset_times = scmd.free_reset_times
			info_.free_throw_times = scmd.free_throw_times
			this.CheckAllRed()
		}

		this.CheckAllRed = () => {
			let red_state = this.GetRedValue() || this.GetShopRed()
			if (this.cur_icon_type) {
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, this.cur_icon_type, red_state)
			}
			this.Fire(local_AdventureModel.UPDATE_RED)
		}

		this.GetViewInfo = () => {
			return info_
		}

		this.CheckAdveOpenStatus = (not_alert?) => {
			let func_is_open = common_mgr.CheckFuncOpenState("GodEquipBuildView", true)
			if (!func_is_open) {
				if (!not_alert) {
					local_Message.show("开启神装功能方可参与此活动")
				}
				return false
			}
			if (!this.act_open_) {
				if (!not_alert) {
					local_Message.show("活动未开启")
				}
				return false
			}
			return true
		}

		this.GetRedValue = () => {
			if (!this.CheckAdveOpenStatus(true)) {
				return false
			}
			if (!info_) {
				return false
			}
			if (info_.location == 30) {
				return false
			}
			return (this.free_times + info_.free_throw_times - info_.throw_times) > 0
		}

		this.SetAdvShopData = (scmd?) => {
			if (scmd) {
				if (scmd.goods_list) {
					scmd.goods_list = table.reverse(scmd.goods_list)
				}
				this.shop_data = scmd
				this.RefShopRed()
				this.CheckAllRed()
			}
		}

		this.BuyShopData = (id?) => {
			if (this.shop_data && this.shop_data.goods_list) {
				for (let i in this.shop_data.goods_list) {

					let v = this.shop_data.goods_list[i]
					if (v.id == id) {
						v.state = 1
						shop_free_red_ = shop_free_red_ - 1
						break
					}
				}
			}
			this.CheckAllRed()
		}

		this.RefShopRed = () => {
			shop_free_red_ = 0
			if (this.shop_data && this.shop_data.goods_list) {
				for (let i in this.shop_data.goods_list) {

					let v = this.shop_data.goods_list[i]
					if (v.state == 0 && v.price == 0) {
						shop_free_red_ = shop_free_red_ + 1
						return
					}
				}
			}
		}

		this.GetShopRed = () => {
			if (!this.CheckAdveOpenStatus(true)) {
				return false
			}
			return shop_free_red_ > 0
		}

		this.GetZoreStatus = () => {
			let zero_time = local_TimeUtil.GetFutureZeroStamp(1)
			let start_time = zero_time - this.outTime
			let end_time = zero_time + this.outTime
			let now_time = local_TimeUtil.getServerTime()
			if (now_time >= start_time && now_time < end_time) {
				let left_time = end_time - now_time
				return left_time
			} else {
				return 0
			}
		}


	}

	public static GetInstance() {

		if (!AdventureModel.Instance) {
			AdventureModel.Instance = new AdventureModel()
		}
		return AdventureModel.Instance
	}
}
window["AdventureModel"] = AdventureModel
