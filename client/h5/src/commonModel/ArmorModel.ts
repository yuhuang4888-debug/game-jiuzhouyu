import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "./RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"

export class ArmorModel extends EventDispatcher {
	public static REQUEST_SCMD = "REQUEST_SCMD"
	public static OPEN_VIEW = "OPEN_VIEW"
	public static UPDATE_ARMOR_VIEW = "UPDATE_ARMOR_VIEW"
	public static UPDATE_SELECT_TAB = "UPDATE_SELECT_TAB"
	public static SELECT_EQUIP = "SELECT_EQUIP"
	public static UPDATE_RED = "UPDATE_RED"
	public static MAKE_SUCCED = "MAKE_SUCCED"
	static Instance: any

	goods_model
	role_mgr
	data
	show_stage
	reddot: any

	public constructor() {
		super()
		if (ArmorModel.Instance) {
			return
		}

		// config_armor_suit = Config.Armoursuit
		// config_armor_equip = Config.Armourequipment
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.data = []
		this.show_stage = 0
	}

	public static GetInstance() {
		if (!ArmorModel.Instance) {
			ArmorModel.Instance = new ArmorModel()
		}
		return ArmorModel.Instance
	}

	// 数据更新
	public SetData(scmd?) {
		let data = scmd.stage_list
		for (let i in data) {
			let vo = data[i]
			for (let j in vo.type_list) {
				let vo2 = vo.type_list[j]
				table.sort(vo2.pos_list, (a?, b?) => {
					return a.pos < b.pos
				})
			}
			table.sort(vo.type_list, (a?, b?) => {
				return a.type < b.type
			})
		}
		table.sort(data, (a?, b?) => {
			return a.stage < b.stage
		})
		let config_armour_suit = Config.PRELOAD_SERVER_CONFIG.config_armour_suit
		this.data = []
		let level = this.role_mgr.GetMainRoleLevel()
		let cfg
		for (let i in data) {
			let vo = data[i]
			cfg = config_armour_suit["1@" + vo.stage]
			if (level < cfg.open_lv) {
				vo.lock = true
				vo.tips = cfg.open_lv > 370 ? ("神创" + (cfg.open_lv - 370)) : (cfg.open_lv + "级")
				table.insert(this.data, vo)
				break
			}
			table.insert(this.data, vo)
		}
		this.CheckStage()
		let config_armour_equipment = Config.PRELOAD_SERVER_CONFIG.config_armour_equipment
		this.CheckRedSate(config_armour_equipment)
	}

	public UpdateData(data?) {
		let find = false
		for (let i in this.data) {
			let vo = this.data[i]
			if (vo.stage == data[0].stage) {
				for (let j in vo.type_list) {
					let vo2 = vo.type_list[j]
					if (vo2.type == data[0].type_list[0].type) {
						vo2.status = data[0].type_list[0].status
						vo2.pos_list = data[0].type_list[0].pos_list
						table.sort(vo2.pos_list, (a?, b?) => {
							return a.pos < b.pos
						})
						find = true
						break
					}
				}
			}
			if (find) { break }
		}
		this.CheckStage()
		this.Fire(ArmorModel.UPDATE_RED)
	}

	public CheckStage() {
		let flag = true
		for (let i in this.data) {
			let vo = this.data[i]
			flag = true
			for (let j in vo.type_list) {
				let vo2 = vo.type_list[j]
				if (vo2.status == 0) {
					flag = false
					break
				}
			}
			vo.status = flag
		}
		this.Fire(ArmorModel.UPDATE_ARMOR_VIEW)
	}

	// 属性相关
	public CombineAttrList(list_a?, list_b?) {

		for (let k in list_b) {
			let vo = list_b[k]
			if (list_a[k]) {
				list_a[k][1] = list_a[k][1] + vo[1]
			} else {
				list_a[k] = vo
			}
		}
	}

	public GetAllAttrList(config_armor_suit, config_armor_equip) {
		let attr_list = {}
		let temp_list = {}
		for (let i in this.data) {
			let vo = this.data[i]
			for (let j in vo.type_list) {
				let vo2 = vo.type_list[j]
				if (vo2.status == 1) {
					temp_list = this.GetSuitAttrList(this.show_stage, vo2.type, config_armor_suit)
					this.CombineAttrList(attr_list, temp_list)
				}
				for (let k in vo2.pos_list) {
					let vo3 = vo2.pos_list[k]
					if (vo3.status == 1) {
						temp_list = this.GetEquipAttrList(vo3.gtype_id, config_armor_equip)
						this.CombineAttrList(attr_list, temp_list)
					}
				}
			}
		}
		return attr_list
	}

	public GetSuitAttrList(stage, type, config_armor_suit) {
		let attr_list = {}
		let cfg = config_armor_suit[type + "@" + stage]
		if (cfg) {
			let attr = ErlangParser.GetInstance().parse(cfg.attr)
			let index = 0
			for (let i in attr) {
				let vo = attr[i]
				index = Number(vo[0])
				if (!attr_list[index]) {
					attr_list[index] = [index, Number(vo[1])]
				} else {
					attr_list[index][1] = attr_list[index][1] + Number(vo[1])
				}
			}
		}
		return attr_list
	}

	public GetEquipAttrList(type_id, config_armor_equip) {
		let attr_list = {}
		let cfg = config_armor_equip[type_id]
		if (cfg) {
			let attr = ErlangParser.GetInstance().parse(cfg.attr)
			let index = 0
			for (let vo of attr) {
				index = Number(vo[0])
				if (!attr_list[index]) {
					attr_list[index] = [index, Number(vo[1])]
				} else {
					attr_list[index][1] = attr_list[index][1] + Number(vo[1])
				}
			}
		}
		return attr_list
	}

	// 打造装备
	public GetEquipConsume(type_id, config_armor_equip) {
		let consume_list = []
		let cfg = config_armor_equip[type_id]
		if (cfg) {
			consume_list = ErlangParser.GetInstance().parse(cfg.consume)
			for (let i in consume_list) {
				let vo = consume_list[i]
				for (let k in vo) {
					let vo2 = vo[k]
					vo[k] = Number(vo2)
				}
			}
		}
		table.sort(consume_list, (a?, b?) => {
			return a[2] < b[2]
		})
		return consume_list
	}

	public GetEquipTips(type_id, config_armor_equip) {
		if (!config_armor_equip[type_id]) {
			return ""
		}
		let stage = WordManager.NumConvertStage(config_armor_equip[type_id].stage) + "阶"
		return stage
	}

	public CheckEquipStatus(type_id, config_armor_equip) {
		let cfg = config_armor_equip[type_id]
		if (cfg) {
			let pos = cfg.pos
			if (pos > 5) {
				pos = pos - 5
			}
			if (this.data[cfg.stage - 1].type_list[cfg.type - 1].pos_list[pos - 1].status == 1) {
				return true
			}
		}
		return false
	}

	public CheckUpdate(stage, type, pos, config_armor_equip) {
		if (pos > 5) {
			pos = pos - 5
		}
		if (this.data[stage - 1].type_list[type - 1].pos_list[pos - 1].status == 1) {
			return 2
		}
		let type_id = this.data[stage - 1].type_list[type - 1].pos_list[pos - 1].gtype_id
		let consume_list = this.GetEquipConsume(type_id, config_armor_equip)
		for (let i in consume_list) {
			let vo = consume_list[i]
			let num = this.goods_model.GetTypeGoodsNum(vo[1])
			if (vo[2] > num) {
				if (!this.CheckEquipStatus(vo[1], config_armor_equip)) {
					return 0
				}
			}
		}
		return 1
	}

	// 红点
	public CheckRedSate(config_armor_equip) {
		this.reddot = false
		for (let i in this.data) {
			let vo = this.data[i]
			if (!vo.lock && this.CheckStageRed(vo.stage, config_armor_equip)) {
				this.reddot = true
			}
		}
		this.Fire(ArmorModel.UPDATE_RED)
		RedDotController.ins.up(RedKey.EQUIP_ARMOR, this.reddot ? 1 : 0)
	}

	public CheckStageRed(stage, config_armor_equip) {
		let data = this.data[stage - 1].type_list
		for (let i in data) {
			let vo = data[i]
			if (this.CheckTypeRed(stage, vo.type, config_armor_equip)) {
				return true
			}
		}
		return false
	}

	public CheckTypeRed(stage, type, config_armor_equip) {
		let data = this.data[stage - 1].type_list[type - 1].pos_list
		for (let i in data) {
			let vo = data[i]
			if (this.CheckPosRed(stage, type, vo.pos, config_armor_equip)) {
				if (stage == 1 || this.data[stage - 2].type_list[type - 1].status == 1) {
					return true
				}
			}
		}
		return false
	}

	public CheckPosRed(stage, type, pos, config_armor_equip) {
		let ans = this.CheckUpdate(stage, type, pos, config_armor_equip)
		if (ans == 1) {
			if (stage == 1 || this.data[stage - 2].type_list[type - 1].status == 1) {
				return true
			}
		}
		return false
	}

	public GetRedDot() {
		return this.reddot
	}
}
window["ArmorModel"] = ArmorModel