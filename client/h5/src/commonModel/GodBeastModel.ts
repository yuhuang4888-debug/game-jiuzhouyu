import { red } from "../../node_modules/colors/index"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { SecretTreasureMainViewIndex } from "./LungModel"
import { MainFunc } from "./MainUIModel"
import { RoleManager } from "./RoleManager"

export const GodBeastEvent = {
	REQUEST_PROTO: "GodBeastEvent.REQUEST_PROTO",
	STREN_SUCCESS: "GodBeastEvent.STREN_SUCCESS",
	STREN_UPGRADE: "GodBeastEvent.STREN_UPGRADE",
	BEAST_EQUIP_STREN: "GodBeastEvent.BEAST_EQUIP_STREN",
	SELECT_STREN_ITEM: "GodBeastEvent.SELECT_STREN_ITEM",
	SELECT_STREN_MTRL_ITEM: "GodBeastEvent.SELECT_STREN_MTRL_ITEM",
	SELECT_STREN_ALL_ITEM: "GodBeastEvent.SELECT_STREN_ALL_ITEM",
	EQUIP_UPDATE: "GodBeastEvent.EQUIP_UPDATE",
	SELECT_SBEAST_ITEM: "GodBeastEvent.SELECT_SBEAST_ITEM",
	BEAST_ACTIVE: "GodBeastEvent.BEAST_ACTIVE",
	SEND_STREN_PREVIEW: "GodBeastEvent.SEND_STREN_PREVIEW",
	RECTIVE_STREN_PREVIEW: "GodBeastEvent.RECTIVE_STREN_PREVIEW",
	GET_ATTR_POWER: "GodBeastEvent.GET_ATTR_POWER",
	UPDATE_ATTR_POWER: "GodBeastEvent.UPDATE_ATTR_POWER",
	SELECT_COM_EQUIP: "GBE1",
	COM_EQUIP: "GBE2",
	COM_SUCCESS: "GBE3",
	QUICK_EQUIP: "GodBeastEvent.QUICK_EQUIP"
}
export enum GodBeastDefine {
	POS_MAX_COUNT = 6,
	POS_DEF_COUNT = 3,
	STREN_BAG_COUNT = 12,
	GOODS_TYPE = 39
}
window["GodBeastEvent"] = GodBeastEvent
window["GodBeastDefine"] = GodBeastDefine
export class GodBeastModel extends EventDispatcher {
	CanGodBeastCom
	CheckAllRedStatus
	CheckEquipRedStatus
	CheckFightRedStatus
	CheckStrenRedStatus
	GetAllBeastEquips
	GetBagEquipsByPos
	GetBeastAutoCom
	GetBeastData
	GetBeastEquipCond
	GetBeastEquipPosData
	GetBeastEquips
	GetBeastInfo
	GetBeastInfoOne
	GetBestEquipGoodIDList
	GetDonwDropData
	GetEquipData
	GetEquipPosName
	GetFightingCount
	GetGoodsByBagCond
	GetGoodsByCond
	GetGoodsByDropCond
	GetReplaceRedStatus
	GetStrenData
	GetWearEquipByIdAndPos
	GetWearEquipInfo
	GetWearEquipInfoFromBeastInfo
	GodBeastComRed
	InitCfg
	Reset
	SetBeastInfo
	SetBeastInfoOne
	SetBeastPosCount
	SetBeastStatus
	SetRedStutus
	SetStrenInfoToData
	CheckMatItems


	_beast_info
	_double_not_alert
	_fight_count
	_select_beast_id
	materId
	beastComRed = false
	now_select_stren_goods_id
	auto_composite_state = false

	public static EQUIP_POS_LIST = [1, 2, 3, 4, 5]
	public static RED_TYPES = [ModuleType.BEAST_EQUIP, ModuleType.BEAST_FIGHT, ModuleType.BEAST_STREN]
	public static RED_BEAST = [ModuleType.BEAST_EQUIP, ModuleType.BEAST_FIGHT]
	public static EMPTY_BAG_DATA = { "type_id": 0, "_select": false }

	/**蜃妖秘卷 */
	public static GOODS_SENYAO_MIJUAN = 39510011

	static Instance: any
	public constructor() {
		super()

		if (GodBeastModel.Instance) {
			return
		}
		GodBeastModel.Instance = this
		this._double_not_alert = false
		this._select_beast_id = 0
		this._fight_count = 0
		this.materId = 39510000
		let goods_model = GoodsModel.GetInstance()
		let local_GodBeastModel = GodBeastModel
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem
		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let local_Number = Number
		let _cfg_dic_ = []
		let _color_cache_dic_ = []
		let _red_active_list_ = []
		let _red_fight_list_ = []
		this.InitCfg = () => {
		}

		this.Reset = () => {
			this._beast_info = null
			this._double_not_alert = false
			this._select_beast_id = 0
			this._fight_count = 0
			this.auto_composite_state = false
		}

		this.SetBeastInfo = (scmd?) => {
			this._beast_info = scmd
			this._fight_count = this.GetFightingCount()
			this.CheckAllRedStatus()
			this.ChangeVar("_beast_info", scmd, false, true)
		}

		this.GetBeastInfo = () => {
			return this._beast_info
		}

		this.SetBeastInfoOne = (scmd?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			let i = 0
			do {
				do {
					let info = beast_info.eudemons_list[i]
					if (info.id != scmd.id) {
						break
					}
					beast_info.eudemons_list[i] = scmd
					break
				} while (true)
				i = i + 1
			} while ((i < beast_info.eudemons_list.length))
			this.SetBeastInfo(beast_info)
		}

		this.GetBeastInfoOne = (id?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info.id == id) {
					return info
				}
			}
		}

		this.SetBeastStatus = (scmd?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			let i = 0
			do {
				do {
					let info = beast_info.eudemons_list[i]
					if (info.id != scmd.id) {
						break
					}
					info.state = scmd.state
					break
				} while (true)
				i = i + 1
			} while ((i < beast_info.eudemons_list.length))
			this.SetBeastInfo(beast_info)
		}

		this.SetBeastPosCount = (scmd?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			beast_info.fight_count = scmd.fight_count
			this.SetBeastInfo(beast_info)
		}

		this.SetStrenInfoToData = (data?, scmd?) => {
			data.exp = scmd.exp
			data.stren = scmd.stren
		}

		this.GetBeastEquips = (id?) => {
			let list = []
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return list
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info.id != id) {
					break
				}
				for (let _tmpi in info.equip_list) {
					let equip = info.equip_list[_tmpi]
					let vo = goods_model.wear_beast_dic[equip.goods_id]
					list.push(vo)
				}
				break
			}
			return list
		}

		this.GetAllBeastEquips = () => {
			let list = []
			let dic = goods_model.wear_beast_dic
			for (let key in dic) {
				if (dic[key]) {
					list.push(dic[key])
				}
			}
			let sort_fun = (a, b) => {
				return a.cell < b.cell
			}
			table.sort(list, sort_fun)
			return list
		}

		this.GetBeastData = (id?, eudemons_item_cfg?) => {
			return eudemons_item_cfg[id]
		}

		this.GetBeastEquipPosData = (id?, pos?, eudemons_equip_pos_cfg?) => {
			return eudemons_equip_pos_cfg[id + "@" + pos]
		}

		this.GetStrenData = (pos?, stren?, eudemons_strength_cfg?) => {
			return eudemons_strength_cfg[pos + "@" + stren]
		}

		this.GetDonwDropData = (key?, cfg?) => {
			if (cfg) {
				return cfg[key]
			}
		}

		this.GetEquipData = (type_id?, eudemons_equip_attr_cfg?) => {
			return eudemons_equip_attr_cfg[type_id]
		}

		this.GetEquipPosName = (pos?) => {
			let key = GodBeastDefine.GOODS_TYPE + "@" + pos
			let cfg = Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key]
			return (cfg && (cfg.subtype_name) || (""))
		}

		this.GetWearEquipInfoFromBeastInfo = (goods_id?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				for (let _tmpi in info.equip_list) {
					let equip = info.equip_list[_tmpi]
					if (equip.goods_id == goods_id) {
						return equip
					}
				}
			}
		}

		this.GetWearEquipInfo = (goods_id?) => {
			return goods_model.wear_beast_dic[goods_id]
		}

		this.GetGoodsByCond = (id?, pos?, eudemons_equip_pos_cfg?, eudemons_equip_attr?) => {
			let bag_list = goods_model.beastbag_goods_list
			let cond = this.GetBeastEquipCond(id, pos, eudemons_equip_pos_cfg)
			let list = []
			for (let _tmpi in bag_list) {
				let info = bag_list[_tmpi]
				if (info.subtype != 51 && info.equip_type == pos && info.color >= cond.color) {
					let edata = this.GetEquipData(info.type_id, eudemons_equip_attr)
					if (edata && edata.star >= cond.star && (!this.GetWearEquipInfo(info.goods_id))) {
						list.push(info)
					}
				}
			}
			list.sort((a?, b?) => {
				if (b.rating != a.rating) {
					return b.rating - a.rating
				}
				return -1
			}
			)

			//let equip = this.GetWearEquipByIdAndPos(id, pos)
			//if (equip ) {
			//    egret.log("___xxx", equip.goods_id)
			//    table.unshift(list, equip)
			//}
			return list
		}

		this.GetGoodsByDropCond = (color?) => {
			let list = []
			let bag_list = goods_model.beastbag_goods_list
			if (color == null || color == 99) {
				return list.concat(bag_list)
			}
			for (let _tmpi in bag_list) {
				let info = bag_list[_tmpi]
				if (color == -1) {
					if (info.subtype == 51) {
						list.push(info)
					}
				}
				else if (color == 2) {
					if (info.color <= color) {
						list.push(info)
					}
				} else {
					if (info.color == color) {
						list.push(info)
					}
				}
			}
			return list
		}

		this.GetGoodsByBagCond = (color?, star?, eudemons_equip_attr_cfg?) => {
			let list = []
			let bag_list = this.GetGoodsByDropCond(color)
			for (let _tmpi in bag_list) {
				let info = bag_list[_tmpi]
				if (info.subtype == 51) {
					break
				}
				if (star == 99 && (!this.GetWearEquipInfo(info.goods_id))) {
					list.push(info)
				} else {
					let data = this.GetEquipData(info.type_id, eudemons_equip_attr_cfg)
					let cstar = (data && (data.star) || (0))
					if (cstar == star && (!this.GetWearEquipInfo(info.goods_id))) {
						list.push(info)
					}
				}
			}
			list.sort((a?, b?) => {
				if (b.rating != a.rating) {
					return b.rating - a.rating
				} else {
					return a.type_id - b.type_id
				}
				// return -1
			}
			)
			return list
		}

		this.GetWearEquipByIdAndPos = (id?, pos?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info.id == id) {
					for (let _tmpi in info.equip_list) {
						let equip = info.equip_list[_tmpi]
						if (equip.pos == pos) {
							return this.GetWearEquipInfo(equip.goods_id)
						}
					}
				}
			}
		}

		this.GetBagEquipsByPos = (pos?) => {
			let bag_list = goods_model.beastbag_goods_list
			if (bag_list.length < 1) {
				return bag_list
			}
			let list = []
			for (let _tmpi in bag_list) {
				let info = bag_list[_tmpi]
				if (info.equip_type == pos) {
					list.push(info)
				}
			}
			return list
		}

		this.GetFightingCount = () => {
			let count = 0
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return count
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info.state == 2) {
					count = count + 1
				}
			}
			return count
		}

		this.GetBestEquipGoodIDList = (id?, eudemons_equip_pos?, eudemons_equip_attr?) => {
			let list = []
			let info = this.GetBeastInfoOne(id)
			let dic = goods_model.beastbag_type_dic
			for (let _tmpi in local_GodBeastModel.EQUIP_POS_LIST) {
				let pos = local_GodBeastModel.EQUIP_POS_LIST[_tmpi]
				if (dic[pos] && dic[pos].length > 0) {
					let cond = this.GetBeastEquipCond(info.id, pos, eudemons_equip_pos)
					let max_power = 0
					let max_goods_id = null
					if (info.equip_dic && info.equip_dic[pos]) {
						let wear_info = this.GetWearEquipInfo(info.equip_dic[pos].goods_id)
						if (wear_info) {
							max_power = wear_info.rating
						}
					}
					for (let _tmpi in dic[pos]) {
						let equip = dic[pos][_tmpi]
						if (equip.color >= cond.color) {
							let edata = this.GetEquipData(equip.type_id, eudemons_equip_attr)
							if (edata && edata.star >= cond.star) {
								if (equip.rating > max_power) {
									max_power = equip.rating
									max_goods_id = equip.goods_id
								}
							}
						}
					}
					if (max_goods_id) {
						list.push(max_goods_id)
					}
				}
			}
			return list
		}

		this.CheckAllRedStatus = () => {
			let is_open = CommonManager.GetInstance().CheckFuncOpenState("GodBeastView", true)
			if (!is_open) {
				return
			}
			let eudemons_item_cfg = Config.PRELOAD_SERVER_CONFIG.config_eudemons_item
			let eudemons_equip_pos = Config.PRELOAD_SERVER_CONFIG.config_eudemons_equip_pos
			let eudemons_equip_attr_cfg = Config.PRELOAD_SERVER_CONFIG.config_eudemons_equip_attr
			let eudemons_strength_cfg = Config.PRELOAD_SERVER_CONFIG.config_eudemons_strength

			if (((eudemons_item_cfg && eudemons_equip_pos) && eudemons_equip_attr_cfg) && eudemons_strength_cfg) {
				this.CheckEquipRedStatus(eudemons_item_cfg, eudemons_equip_pos, eudemons_equip_attr_cfg)
				this.CheckFightRedStatus(eudemons_item_cfg)
				this.CheckStrenRedStatus(eudemons_strength_cfg)
				this.GodBeastComRed(eudemons_equip_attr_cfg)

				//拓展位置可拓展
				let boo = this.CheckMatItems()
				RedDotController.ins.up(RedKey.GOD_BEAST_MIJUAN, boo);

				local_GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
				let is_show =((red_dot_mgr.CheckRedStatusMultModule(local_GodBeastModel.RED_BEAST) 
				|| this.beastComRed) 
				|| red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_STREN)) 
				||red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_REPLACE)

				local_GlobalEventSystem.Fire(update_window_red_event, "SecretTreasureMainView", SecretTreasureMainViewIndex.GodBeast, is_show||boo)
				is_show = red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_STREN)
				local_GlobalEventSystem.Fire(update_window_red_event, "GodBeastStrenBaseView", 0, is_show)
			}
		}

		this.SetRedStutus = (mType?, rType?, active?) => {
			red_dot_mgr.SetRedStatus(mType, rType, active)
		}

		///拓展位置可拓展
		this.CheckMatItems = () => {

			let beast_info = this.GetBeastInfo()
			if (!beast_info) return false

			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_eudemons_cfg", false)
			let extra = beast_info.fight_count - GodBeastDefine.POS_DEF_COUNT + 1

			let cfg_cost = config[`fight_location_cost@${extra}`]

			let cost_cfg = cfg_cost && cfg_cost.value
			if (!cost_cfg) return false

			let cfg = JSON.parse(cost_cfg)
			let cdata = cfg[0][1][0]
			let [type_id] = goods_model.GetMappingTypeId(cdata[0], cdata[1])
			let main_vo_level = RoleManager.GetInstance().mainRoleInfo.level

			let need_lv = cfg[2][1];
			if (local_Number(need_lv) <= main_vo_level) {
				//可以拓展
				let have_num = goods_model.GetTypeGoodsNum(type_id)
				if (have_num > 0) {
					return true
				}
			}
			return false
		}

		this.CheckStrenRedStatus = (eudemons_strength_cfg?) => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.BEAST_STREN)
			let wear_list = goods_model.wear_beast_list
			if (wear_list.length < 1) {
				red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_STREN, 1, false)
				return
			}
			let have = goods_model.GetTypeGoodsNum(this.materId)
			if (!have) {
				red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_STREN, 1, false)
				return
			}
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info && info.state == 2) {
					for (let _tmpi in info.equip_list) {
						let equip = info.equip_list[_tmpi]
						let next_data = this.GetStrenData(equip.pos, equip.stren + 1, eudemons_strength_cfg)
						if (next_data && next_data.exp - equip.exp / 100 <= have) {
							red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_STREN, info.id, true)
							red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_STREN, equip.goods_id, true)
						}
					}
				}
			}
		}

		this.GetBeastEquipCond = (id?, pos?, eudemons_equip_pos_cfg?) => {
			let dic = _color_cache_dic_[id]
			if (!dic) {
				dic = []
			}
			if (dic[pos]) {
				return dic[pos]
			}
			let pos_data = this.GetBeastEquipPosData(id, pos, eudemons_equip_pos_cfg)
			let cond = JSON.parse(pos_data.conditions)
			let color = (cond && cond[0] && (local_Number(cond[0][1])) || (0))
			let star = (cond && cond[1] && (local_Number(cond[1][1])) || (0))
			let data = { "color": color, "star": star }
			dic[pos] = data
			return data
		}

		this.CheckFightRedStatus = (eudemons_item_cfg?) => {
			let beast_info = this.GetBeastInfo()
			if (!beast_info) {
				return
			}
			let fight_count = this._fight_count
			let has_empty = beast_info.fight_count > fight_count
			let can_fight_count = beast_info.fight_count - fight_count
			_red_active_list_ = []
			_red_fight_list_ = []
			let active_list = _red_active_list_
			let fight_list = _red_fight_list_
			//let min_fight_score = local_Number.MAX_VALUE
			for (let _tmpi in beast_info.eudemons_list) {
				let info = beast_info.eudemons_list[_tmpi]
				if (info.state == 0) {
					this.SetRedStutus(local_ModuleType.BEAST_FIGHT, info.id, false)
					let red = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_EQUIP, info.id)
					if (red) {
						fight_list.push(info)
					}
				}
				else if (info.state == 1) {
					active_list.push(info)
				}
				else if (info.state == 2) {
					this.SetRedStutus(local_ModuleType.BEAST_FIGHT, info.id, false)
				}
			}
			active_list = active_list.concat(fight_list)
			if (active_list.length <= can_fight_count) {
				for (let _tmpi in active_list) {
					let info = active_list[_tmpi]
					let red = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_EQUIP, info.id)
					if (!red) {
						this.SetRedStutus(local_ModuleType.BEAST_FIGHT, info.id, true)
					}
				}
			} else {
				active_list.sort((a?, b?) => {
					let aScore = this.GetBeastData(a.id, eudemons_item_cfg).score
					let bScore = this.GetBeastData(b.id, eudemons_item_cfg).score
					if (bScore != aScore) {
						return bScore - aScore
					}
					return -1
				}
				)

				for (let i = 0; i < active_list.length; i++) {
					let red = red_dot_mgr.CheckRedStatus(local_ModuleType.BEAST_EQUIP, active_list[i].id)
					//this:SetRedStutus(local_ModuleType.BEAST_FIGHT, active_list[i].id, i < can_fight_count && ! red)
					this.SetRedStutus(local_ModuleType.BEAST_FIGHT, active_list[i].id, can_fight_count > 0 && !red)
					//if (i >= can_fight_count && red ) {
					//    this.SetRedStutus(local_ModuleType.BEAST_EQUIP, active_list[i].id, false)
					//}
				}
			}
		}

		this.CheckEquipRedStatus = (eudemons_item_cfg, eudemons_equip_pos, eudemons_equip_attr_cfg) => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.BEAST_REPLACE)
			red_dot_mgr.ClearRedStatus(local_ModuleType.BEAST_EQUIP)
			let beast_info = this.GetBeastInfo()
			if (!beast_info) return
			let fight_count = this._fight_count
			let can_fight_count = beast_info.fight_count - fight_count
			let dic = goods_model.beastbag_type_dic
			let mark = true
			let fit_count = 0
			_red_active_list_.length = 0
			_red_fight_list_.length = 0
			let active_list = _red_active_list_
			let fight_list = _red_fight_list_
			for (let info of beast_info.eudemons_list) {
				if (info.state == 1) continue
				fit_count = 0
				mark = true
				for (let pos of local_GodBeastModel.EQUIP_POS_LIST) {
					if (!mark) break
					let old_fit_count = fit_count
					//未上阵神兽判断有装备则继续判断下个部位
					if (info.state != 2 && info.equip_dic && info.equip_dic[pos]) {
						fit_count++
						continue
					}
					//没有该位置装备
					if (!dic[pos] || dic[pos].length < 1) {
						this.SetRedStutus(local_ModuleType.BEAST_EQUIP, info.id, false)
						if (info.state == 0) break
						else if (info.state == 2) continue
					}

					let cond = this.GetBeastEquipCond(info.id, pos, eudemons_equip_pos)
					for (let equip of dic[pos]) {
						if (equip && this.GetWearEquipInfo(equip.goods_id)) {
							continue
						}
						//穿戴标志，替换标志
						let emark, rmark
						//品质不满足条件
						if (equip.color < cond.color) continue
						let edata = this.GetEquipData(equip.type_id, eudemons_equip_attr_cfg)
						if (edata && edata.star < cond.star) continue
						//身上没有穿装备
						if (!info.equip_dic || !info.equip_dic[pos]) {
							fit_count++
							break
						}
						let wear_info = this.GetWearEquipInfo(info.equip_dic[pos].goods_id)
						//上阵神兽
						if (info.state == 2) {
							//背包装备品质比身上装备品质高
							let rtype = info.id * 10000 + pos
							if (!rmark && wear_info) {
								if (equip.color > wear_info.color) {
									rmark = true
									red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_REPLACE, rtype, true)
								} else if (equip.color == wear_info.color) {
									let e1 = this.GetEquipData(equip.type_id, eudemons_equip_attr_cfg)
									let e2 = this.GetEquipData(wear_info.type_id, eudemons_equip_attr_cfg)
									if (e1 && e2 && e1.star > e2.star) {
										rmark = true
										red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_REPLACE, rtype, true)
									}
								}
							}
							//背包装备评分比身上装备评分高
							if (!emark && wear_info && equip.rating > wear_info.rating) {
								// this.SetRedStutus(ModuleType.BEAST_EQUIP, info.id, true)
								// mark = false
								red_dot_mgr.SetAnyRedStatus(local_ModuleType.BEAST_REPLACE, rtype, true)
								emark = true
								fight_list.push(info)
							}
							if (emark && rmark) break
						}
					}
					if (info.state == 0 && old_fit_count == fit_count) {
						mark = false
						this.SetRedStutus(local_ModuleType.BEAST_EQUIP, info.id, false)
						break
					}
				}

				if (info.state == 0) {
					if (fit_count >= local_GodBeastModel.EQUIP_POS_LIST.length) {
						if (can_fight_count > 0) {
							active_list.push(this.GetBeastData(info.id, eudemons_item_cfg))
						} else {
							this.SetRedStutus(local_ModuleType.BEAST_EQUIP, info.id, false)
						}
					} else {
						this.SetRedStutus(local_ModuleType.BEAST_EQUIP, info.id, false)
					}
				}
			}
			//如没有可上阵神兽，则已上阵神兽的装备判断红点
			//若有可上阵神兽且少于空闲出战位置，则判断红点
			//若有可上阵神兽且大于空闲出战位置，则选出N(空闲出战位置数量)个最强神兽
			let count = active_list.length
			if (can_fight_count <= 0) {
				// for (let info of fight_list) {
				//     this.SetRedStutus(ModuleType.BEAST_EQUIP, info.id, true)
				// }
				// } else if (count <= can_fight_count) {
				//     for (let info of active_list) {
				//         this.SetRedStutus(local_ModuleType.BEAST_EQUIP, info.id, true)
				//     }
			} else {
				active_list.sort((a, b) => {
					let aScore = this.GetBeastData(a.id, eudemons_item_cfg).score
					let bScore = this.GetBeastData(b.id, eudemons_item_cfg).score
					return bScore - aScore
				})
				for (let i = 0; i < active_list.length; i++) {
					// this.SetRedStutus(local_ModuleType.BEAST_EQUIP, active_list[i].id, i < can_fight_count)
					this.SetRedStutus(local_ModuleType.BEAST_EQUIP, active_list[i].id, can_fight_count > 0)

				}
			}
		}

		this.GetReplaceRedStatus = (id?) => {
			for (let _tmpi in local_GodBeastModel.EQUIP_POS_LIST) {
				let pos = local_GodBeastModel.EQUIP_POS_LIST[_tmpi]
				let red_id = id * 10000 + pos
				let red = red_dot_mgr.CheckAnyRedStatus(local_ModuleType.BEAST_REPLACE, red_id)
				if (red) {
					return red
				}
			}
			return false
		}

		this.GetBeastAutoCom = (eudemons_compose_cfg?, color?, star?) => {
			let cfg = eudemons_compose_cfg
			if (!cfg) {
				return false
			}
			let sort_cfg = []
			for (let key in cfg) {
				let v = cfg[key]
				sort_cfg.push(v)
			}
			sort_cfg.sort((a?, b?) => {
				if (a.id != b.id) {
					return a.id - b.id
				}
				return -1
			})
			for (let key = 0; key < sort_cfg.length; key++) {
				let v = sort_cfg[key]
				let list = this.CanGodBeastCom(eudemons_compose_cfg, v.id, color, star)
				if (list) {
					return list
				}
			}
		}

		this.CanGodBeastCom = (eudemons_compose_cfg?, id?, color?, star?) => {
			if (id) {
				let bool = false
				let cfg = eudemons_compose_cfg[id]
				let regular_bool = true
				let can_com = false
				if (cfg) {
					let eliminate_list = []
					let material_list = JSON.parse(cfg.material)
					if (color) {
						let equipInfo = goods_model.GetGoodsBasicByTypeId(Number(material_list[1]))
						if (color < equipInfo.color) {
							return
						}
					}
					if (star) {
						let equipInfo = goods_model.GetGoodsBasicByTypeId(Number(material_list[1]))
						let config_eudemons_equip_attr = Config.PRELOAD_SERVER_CONFIG.config_eudemons_equip_attr
						let data = this.GetEquipData(equipInfo.type_id, config_eudemons_equip_attr)
						if (data && star < data.star) {
							return
						}

					}
					let needCount = cfg.cnum
					if (material_list) {
						for (let _tmpi = 0; _tmpi < material_list.length; _tmpi++) {
							let Vo = material_list[_tmpi]
							let equipList = goods_model.GetTypeGoods(Number(Vo))
							for (let _tmpi = 0; _tmpi < equipList.length; _tmpi++) {
								let vo = equipList[_tmpi]
								if (!eliminate_list[Vo.goods_id] && (!this.GetWearEquipInfo(vo.goods_id))) {
									eliminate_list[vo.goods_id] = vo.goods_id
									needCount = needCount - 1
									if (needCount <= 0) {
										return [eliminate_list, cfg.id]
									}
								}
							}
						}
					}
				}
			}
		}
		//合成红点
		this.GodBeastComRed = (eudemons_equip_attr_cfg) => {
			let list = goods_model.beastbag_goods_list
			if (list && list.length >= 4) {

				//如果有未出战的槽位 有可装备的蜃装 不显示合成红点
				//剩余蜃位
				let _beast_info_ = this.GetBeastInfo()
				if (!_beast_info_) {
					this.ChangeVar("beastComRed", false)
					return
				}

				//记录每个类型的数量
				let is_show_red = false


				if (this._fight_count < _beast_info_.fight_count) {
					//助战位置没有占满
					let obj_num = {}
					let left_num = _beast_info_.fight_count - this._fight_count
					for (let i = 0; i < list.length; i++) {
						let vo = list[i]
						if (vo.goods_id == this.materId) continue	//蜃妖精华 跳过
						let equip_type = vo.equip_type//部位
						if (!obj_num[equip_type]) {
							obj_num[equip_type] = 1
						} else {
							obj_num[equip_type] += 1
						}
					}


					for (let key in obj_num) {
						if ((obj_num[key] - left_num) >= 4) {
							is_show_red = true
							break
						}
					}
				} else {
					//助战位置已经占满
					is_show_red = true
				}

				if (!is_show_red) {
					this.ChangeVar("beastComRed", false)
					return
				}




				//正常的红点逻辑
				let comList = {}
				for (let vo of list) {
					if (vo.color >= 6) {
						continue
					}
					let data = this.GetEquipData(vo.type_id, eudemons_equip_attr_cfg)

					//蜃妖精华 跳过
					if (data.goods_id == this.materId) continue

					let star = data ? data.star : 0
					if (vo.color >= 5 && star >= 2) {
						continue
					}
					if (!comList[`${star}@${vo.color}`]) {
						comList[`${star}@${vo.color}`] = 1
					} else {
						comList[`${star}@${vo.color}`]++
					}
					if (comList[`${star}@${vo.color}`] >= 4) {
						this.ChangeVar("beastComRed", true)
						return
					}
				}
			}
			this.ChangeVar("beastComRed", false)

		}
	}

	public static GetInstance() {
		if (!GodBeastModel.Instance) {
			GodBeastModel.Instance = new GodBeastModel()
		}
		return GodBeastModel.Instance
	}

}


window["GodBeastModel"] = GodBeastModel