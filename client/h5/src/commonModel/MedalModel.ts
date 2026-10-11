import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { HtmlColorTxt, Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

export interface MedalCostParam {
	type: EnumMedalCostType,
	con: string | number, // 条件
	layerNum: number, // 层数
}

/**
 * 勋章消耗条件类型
 */
export enum EnumMedalCostType {
	ePower = 1,
	eLayerNum,
	eItem,
}

let MEDAL_COFIG = {
	Medal: 0
}
//let MedalEvent = [MedalModel.MedalUP="MedalEvent.MedalUP", RequestData="MedalEvent.RequestData", UpdateInfo="MedalEvent.UpdateInfo", UPDATE_RED_DOT="MedalEvent.UPDATE_RED_DOT", CLICK_TITLE_ITEM="CLICK_TITLE_ITEM", MEDAL_REQUEST_PROTO="MEDAL_REQUEST_PROTO", UPDATE_TITLE_MAIN_VIEW="UPDATE_TITLE_MAIN_VIEW", SUCCCESS_UP_LEVEL="SUCCCESS_UP_LEVEL", UPDATE_TITLE_RED="UPDATE_TITLE_RED", MEDAL_STRENGTHEN_RETURN="MEDAL_STRENGTHEN_RETURN", MEDAL_STRENGTHEN_LEVEL_CHANGE="MEDAL_STRENGTHEN_LEVEL_CHANGE"]

//window["MedalEvent"] = MedalEvent
window["MEDAL_COFIG"] = MEDAL_COFIG
export class MedalModel extends EventDispatcher {
	BlendAttrCfg
	CheckRedStatus
	CheckTitleRedDot
	GetTitleInfo
	OneKeySendCost
	SendCost
	SetReddot
	SetTitleInfo
	SetTitleRed
	SetTitleRedDot
	_honour
	_medalLevId
	honour
	formatGoods
	medalAttrList: (list?, color1?, color?) => string
	medalAttrListValue: (list?, color1?, color?) => string
	medalConfig
	medalData
	medalNextConfig
	medalStrSelItem
	medal_bin_redDot
	medal_str_red
	setMedalData
	setMedalStrRed
	setShowRedDot
	successUp
	title_red_list
	GetTitleEffetName
	public static MEDAL_REQUEST_PROTO = "MEDAL_REQUEST_PROTO"
	public static RequestData = "RequestData"
	public static MedalUP = "MedalUP"
	public static SUCCCESS_UP_LEVEL = "SUCCCESS_UP_LEVEL"
	public static CLOSE_MEDAL_VIEW = "CLOSE_MEDAL_VIEW"
	public static UPDATE_TITLE_MAIN_VIEW = "UPDATE_TITLE_MAIN_VIEW"
	public static MEDAL_STRENGTHEN_LEVEL_CHANGE = "MEDAL_STRENGTHEN_LEVEL_CHANGE"
	public static MEDAL_STRENGTHEN_RETURN = "MEDAL_STRENGTHEN_RETURN"
	public static UpdateInfo = "UpdateInfo"
	public static UPDATE_TITLE_RED = "UPDATE_TITLE_RED"
	public static CLICK_TITLE_ITEM = "CLICK_TITLE_ITEM"
	public static SELECT_TITLE = "SELECT_TITLE"
	public static GOODS_TYPE = 76
	public static CLICK_TITLE = "CLICK_TITLE"
	public static RED_DOT = "RED_DOT"
	public static CHANGE_RED_DOT = "CHANGE_RED_DOT"

	static Instance

	private _passLayers: number = 0;

	get passLayers() {
		return this._passLayers;
	}

	set passLayers(val: number) {
		this._passLayers = val;
	}

	public constructor() {
		super()

		if (MedalModel.Instance) {
			return
		}
		MedalModel.Instance = this
		this.successUp = false;
		this.medal_bin_redDot = false;
		this.title_red_list = {};
		this._honour = 0;
		this._medalLevId = 0;
		this.medal_str_red = false;
		this.medalData = null
		this.medalStrSelItem = null
		let gameStar = true
		let title_info = null
		let _local_GlobalEventSystem = GlobalEventSystem
		let _local_EventName = EventName
		let _local_RedDotManager = RedDotManager.GetInstance()
		let _local_RoleManager = RoleManager.GetInstance()
		this.medalConfig = (cfg?) => {
			let lev = this._medalLevId == 0 && 1 || this._medalLevId
			for (let key in cfg) {

				let element = cfg[key]
				if (element.id == lev) {
					return element
				}
			}
		}

		this.medalNextConfig = (cfg?) => {
			let medallv = this._medalLevId == 0 && 1 || this._medalLevId
			for (let key in cfg) {

				let element = cfg[key]
				if (element.id == medallv + 1) {
					return element
				}
			}
		}

		this.setMedalData = (honour?, medalLevId?) => {
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_medal
			this.honour = honour
			this._medalLevId = medalLevId
			this.setShowRedDot(cfgs)
			this.setMedalStrRed()
			this.Fire(MedalModel.UpdateInfo)
		}

		this.setShowRedDot = (configs?) => {
			let cfgs = configs
			let flag = false
			let lv = _local_RoleManager.GetMainRoleVo().level
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
			let medal_cfg = cfg["MedalView"]
			if ((medal_cfg && lv >= medal_cfg.open_lv) && cfgs) {
				let conf = this.medalConfig(cfgs)
				let nextConf = this.medalNextConfig(cfgs)
				let costValue = 0
				let num = 0
				if (nextConf && conf) {
					let fight = _local_RoleManager.GetMainRoleVo().fighting
					if (conf.cost != "[]") {
						let cost = JSON.parse(conf.cost)
						costValue = cost[0][2]
						num = GoodsModel.GetInstance().GetTypeGoodsNum(cost[0][1])
					}
					let fullLayer = true
					if (conf.other_condition != "[]") {
						let codition = JSON.parse(conf.other_condition);
						let costNum: number = codition[0][1];
						// let list = codition[0]
						// let dun_id = Number(list[1])
						// //let layer = dun_id - BaseDungeonModel.Rune_Floor_Modulus
						// let layer
						// let cur_floor = 0
						// //let dun_list = BaseDungeonModel.GetInstance().GetDungeonInfo(DUN_TYPE.Rune)
						// let dun_list
						// if (dun_list) {
						// 	for (let key in dun_list) {

						// 		if (dun_list[key].permanent_count > 0) {
						// 			cur_floor = Number(key) + 1
						// 		}
						// 	}
						// }

						fullLayer = this._passLayers >= costNum;
					}
					if ((num >= Number(costValue) && fight >= Number(conf.upgrade_power)) && fullLayer) {
						flag = true
					}
				}
			}
			this.SetReddot(ModuleType.MEDAL, 1, flag)
			RedDotController.ins.up(RedKey.MEDAL_COMMON, flag ? 1 : 0)
		}

		this.SetReddot = (mType?, rtype?, red?) => {
			let last = MedalModel.GetInstance().CheckRedStatus(mType, rtype)
			if (last != red) {
				_local_RedDotManager.SetRedStatus(mType, rtype, red)
				_local_GlobalEventSystem.Fire(_local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			}
		}

		this.CheckRedStatus = (mType?, rtype?) => {
			return _local_RedDotManager.CheckRedStatus(mType, rtype)
		}

		this.medalAttrList = (list?, color1?, color?) => {
			let str = ""
			let index = 0
			for (let key in list) {

				let attr_info = list[key]
				if ((attr_info != [] || attr_info != null)) {
					str = str + HtmlColorTxt(WordManager.GetProperties(attr_info[0]), color1) + ": ";
					str = str + "<br/>"; // &nbsp;
				}
				// if (index != 0 || index != list.length - 1) {
				// 	str = str + "<br/>"
				// }
				index = index + 1
			}
			return str
		}

		this.medalAttrListValue = (list?, color1?, color?) => {
			let str = ""
			let index = 0
			for (let key in list) {

				let attr_info = list[key]
				if ((attr_info != [] || attr_info != null)) {
					str = str + HtmlColorTxt(WordManager.ConvertToPercentValue(attr_info[0], attr_info[1]), color);
					str = str + "<br/>"; // &nbsp;
				}
				// if (index != 0 || index != list.length - 1) {
				// 	str = str + "<br/>"
				// }
				index = index + 1
			}
			return str
		}

		this.SetTitleInfo = (info?) => {
			title_info = info
		}

		this.GetTitleInfo = () => {
			return title_info
		}

		this.SetTitleRedDot = (cfgs) => {
			let cfg = cfgs
			if (!title_info) {
				return
			}
			this.title_red_list = {}
			let i = 0
			do {
				for (let key in cfg) {

					let value = cfg[key]
					if ((title_info[i] && title_info[i].id == value.id && title_info[i].level + 1 == value.star) && title_info[i].is_equip != 0) {
						let cost = JSON.parse(value.cost)
						let goods_id = null
						let goods_num = null
						for (let _tmpi in cost) {
							var goods_vo = cost[_tmpi]
							goods_id = Number(goods_vo[1])
							goods_num = Number(goods_vo[2])
						}
						let have_num = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
						if (have_num >= goods_num) {
							this.title_red_list[title_info[i].id] = { goods_id: goods_id, have_num: have_num }
						}
					}
					if ((title_info[i] && title_info[i].is_equip == 0 && title_info[i].id == value.id) && 0 == value.star) {
						let cost = JSON.parse(value.cost)
						let goods_id = null
						let goods_num = null
						for (let _tmpi in cost) {
							var goods_vo = cost[_tmpi]
							goods_id = Number(goods_vo[1])
							goods_num = Number(goods_vo[2])
						}
						let have_num = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
						if (have_num >= goods_num) {
							this.title_red_list[title_info[i].id] = { goods_id: goods_id, have_num: have_num }
						}
					}
				}
				i = i + 1
			} while ((i < title_info.length))
			this.SetTitleRed()
		}

		this.CheckTitleRedDot = () => {
			if (!CommonManager.GetInstance().CheckFuncOpenState("TitleMainView", true)) {
				return false
			}
			return Util.TableSize(this.title_red_list) > 0
		}

		this.SetTitleRed = () => {
			let red = this.CheckTitleRedDot()
			this.Fire(MedalModel.UPDATE_TITLE_RED)
			_local_GlobalEventSystem.Fire(_local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			_local_GlobalEventSystem.Fire(_local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MedalEnterView", 1, red)
		}

		this.BlendAttrCfg = (now_cfg?, next_cfg?) => {
			let list = []
			let now_data = now_cfg && JSON.parse(now_cfg.attr) || {}
			if (next_cfg) {
				let attr_id_list = []
				let next_data = JSON.parse(next_cfg.attr)
				let len = next_data.length > now_data.length && next_data.length || now_data.length

				for (let i = 1; i <= len; i += 1) {
					let now_info = now_data[i]
					let attr_id = null
					let now_value = null
					let next_value = null
					if (now_info) {
						attr_id = now_info[1]
						now_value = now_info[2]
					}


					for (let j = 1; j <= next_data.length; j += 1) {
						let next_info = next_data[j]
						if (attr_id && next_info[1] == attr_id) {
							next_value = next_info[2]
							break
						} else if (!attr_id && !attr_id_list[Number(next_info[1])]) {
							attr_id = next_info[1]
							next_value = next_info[2]
						}
					}
					let obj = { attr_id: attr_id, now: now_value, next: next_value }
					if ((!attr_id_list[Number(attr_id)])) {
						table.insert(attr_id_list, attr_id)
					}
					table.insert(list, obj)
				}
			} else {
				for (let key in now_data) {

					let now_info = now_data[key]
					let obj = { attr_id: now_info[1], now: now_info[2], next: null }
					table.insert(list, obj)
				}
			}
			return list
		}

		this.formatGoods = (send_dic?) => {
			let sendObj = []
			for (let key in send_dic) {

				let count = send_dic[key]
				let type_id = key
				let index = 0
				let list = GoodsModel.GetInstance().GetTypeGoods(type_id)
				if (list.length > 1) {
					for (let key in list) {

						let vo = list[key]
						let count = sendObj[vo.goods_id]
						if (!count) {
							sendObj[vo.goods_id] = 1
						} else {
							sendObj[vo.goods_id] = sendObj[vo.goods_id] + 1
						}
						index = index + 1
						if (index >= count) {
							break
						}
					}
				} else {
					let vo = list[0]
					if (!vo) {
						break
					}
					let _count = (vo.goods_num > count && (count) || (vo.goods_num))
					sendObj[vo.goods_id] = _count
				}
			}
			return sendObj
		}

		this.SendCost = (type_id?) => {
			let needObj = []
			needObj[type_id] = 1
			let obj = this.formatGoods(needObj)
			this.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13407, obj)
		}

		this.OneKeySendCost = (cost_cfg?, next_cfg?) => {
			if (!next_cfg) {
				return
			}
			let obj = []
			let _continue = false
			length = 0
			for (let key in cost_cfg) {

				let info = cost_cfg[key]
				let count = GoodsModel.GetInstance().GetTypeGoodsNum(info.goods_id)
				if (count > 0) {
					_continue = true
				}
				let cost = cost_cfg[info.goods_id]
				obj[info.color] = { goods_id: info.goods_id, count: count, exp: info.exp }
				length = length + 1
			}
			if (!_continue) {
				return
			}
			let needExp = next_cfg.exp - this.medalData.stren_exp
			let nowExp = 0
			let needObj = []
			if (length > 0) {

				for (let i = 1; i <= length; i += 1) {
					let goods = obj[i]
					if (goods.count > 0) {
						let allExp = goods.count * goods.exp
						if (allExp <= needExp - nowExp) {
							needObj[goods.goods_id] = goods.count
							nowExp = nowExp + allExp
						} else {
							let needCount = Math.ceil(needExp - nowExp / goods.exp)
							needObj[goods.goods_id] = needCount
							nowExp = nowExp + goods.exp * needCount
						}
						if (nowExp >= needExp) {
							break
						}
					}
				}
			}
			let sendObj = this.formatGoods(needObj)
			this.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13407, sendObj)
		}

		this.setMedalStrRed = () => {
			let cost_cfg = Config.PRELOAD_SERVER_CONFIG.config_medal_stren_cost
			let lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_medal_stren_lv
			let flag = false
			if (this.medalData && cost_cfg && lv_cfg) {
				let stren_lv = this.medalData.stren_lv
				let next_cfg = lv_cfg[stren_lv + 1]
				if (next_cfg) {
					let needExp = next_cfg.exp - this.medalData.stren_exp
					for (let key in cost_cfg) {
						let cost = cost_cfg[key]
						if (this._medalLevId >= cost.medal_lv) {
							let nowExp = 0
							let count = GoodsModel.GetInstance().GetTypeGoodsNum(cost.goods_id)
							if (count > 0) {
								nowExp = nowExp + count * cost.exp
							}
							if (nowExp >= needExp) {
								flag = true
								break
							}
						}
					}
				}
				this.SetReddot(ModuleType.MEDAL_STRENGTHEN, 1, flag)
				RedDotController.ins.up(RedKey.MEDAL_STRENGTHEN, flag ? 1 : 0)
			}
		}

		this.GetTitleEffetName = (show_id) => {
			let res = show_id >= 10 ? `effect_shenmingjiemian_${show_id}` : `effect_shenmingjiemian_0${show_id}`
			return res
		}
	}

	public static GetInstance() {
		if (!MedalModel.Instance) {
			MedalModel.Instance = new MedalModel()
		}
		return MedalModel.Instance
	}

	public gethonour() {

		return this._honour
	}

	public sethonour(value?) {

		if (this._honour != value) {
			this._honour = value
		}
	}

	public medalLevId() {

		return this._medalLevId
	}

}
window["MedalModel"] = MedalModel