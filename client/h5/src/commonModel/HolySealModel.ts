import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "./RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { BagModel } from "./BagModel"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

export class HolySealModel extends EventDispatcher {
	static Instance: HolySealModel
	alert_decompose
	bag_full_list
	erlang_parser
	goods_model:GoodsModel
	not_show_decompose_tips
	red_flag
	role_mgr
	soul_data
	stren_data
	total_rating

	public static REQUEST_CCMD_EVENT = "HolySealModel.REQUEST_CCMD_EVENT"
	public static STREN_SUCCESS = "HolySealModel.STREN_SUCCESS"
	public static SELECT_BREAK_DOWN_ITEM = "HolySealModel.SELECT_BREAK_DOWN_ITEM"
	public static REFRESH_RED_FLAG = "HolySealModel.REFRESH_RED_FLAG"
	public static UPDATE_SUIT_DATA = "HolySealModel.UPDATE_SUIT_DATA"
	public static UPDATE_ALL_SUIT_DATA = "HolySealModel.UPDATE_ALL_SUIT_DATA"
	public static PLAY_END_EFFECT = "HolySealModel.PLAY_END_EFFECT"

	//装备数量
	public static EQUIP_COUNT = 11
	//圣印物品类型
	public static GOODS_TYPE = 60
	//圣印其他物品类型
	public static OTHER_GOODS_TYPE = 61
	//圣魂丹子类形
	public static SOUL_SUB_ID = 1
	//强化消耗的特殊货币类型
	public static MONEY_TYPE = 23
	//颜色筛选基数
	public static DROP_BASE_TYPE = 2
	//自动分解装备品质上限
	public static AUTO_DECOMPOSE_COLOR = 3
	//分解背包显示上限
	public static MAX_DECOMPOSE_COLOR = 5


	public static Suit_Type = { One: 0, Two: 1 }
	public static RedFlag = {
		Strong: 0x001,//更好的装备
		Decompose: 0x002,//分解
		Stren: 0x004,//强化
		Composite: 0x008,//合成
		Soul: 0x010//圣魂
	}



	// ResetData
	// InitSealSoul
	// GetWearEquipByPos
	// GetEquipList
	// GetHolySealBagList
	// GetWearEquipInfo
	// GetEquipTypeName
	// GetHolySealData
	// GetkeyValue
	// GetHolySealSuitCfg
	// GetHolySealStrenCfg
	// GetHolySealStrenDate
	// GetStage2BgSource
	// GetStage2StrokeColor
	// GetStageDropData
	// GetColorDropData
	// RefreshStrongRed
	// RefreshDecomposeRed
	// RefreshStrenRed
	// RefreshSoulRed
	// SetRedFlag
	// HasRedFlag
	// GetRedState
	// GetOpenState
	// CantWearEquip
	// TryRefreshStrenRed


	open_lv
	public constructor() {
		super()

		this.alert_decompose = false
		this.goods_model = GoodsModel.GetInstance()

		this.erlang_parser = ErlangParser.GetInstance()
		this.role_mgr = RoleManager.GetInstance()


		this.red_flag = 0
		this.bag_full_list = []
		this.not_show_decompose_tips = false

		// for (let key in HolySealModel.RedFlag) {

		// 	let value = HolySealModel.RedFlag[key]
		// 	HolySealModel.RedALLFlag = HolySealModel.RedALLFlag + value
		// }

		this.ResetData()
	}


	ResetData() {

		this.total_rating = 0
		this.stren_data = false
		this.open_lv = 99999
	}

	InitSealSoul() {
		if (!this.soul_data) {
			this.soul_data = {}
		}
		let config_seal_pill = Config.PRELOAD_SERVER_CONFIG.config_seal_pill
		for (let key in config_seal_pill) {
			let cfg = config_seal_pill[key]
			if (cfg) {
				let data = this.soul_data[cfg.goods_id]
				if (!data) {
					data = { goods_id: cfg.goods_id, add_attr: JSON.parse(cfg.attr), cond: [], num: 0 }
					this.soul_data[cfg.goods_id] = data
				}
				table.insert(data.cond, { lv_min: cfg.lv_min, lv_max: cfg.lv_max, num: cfg.num })
			}
		}
		this.RefreshSoulRed()

		let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_seal_kv
		if (cfg2) {
			this.open_lv = Number(this.GetkeyValue(3, cfg2))
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BagView",
				BagModel.Index.HolySeal,
				this.GetRedState()
			)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
		}
	}

	GetWearEquipByPos(pos?) {
		if (pos != null) {
			let wear_holy_seal_list = this.goods_model.wear_holy_seal_list
			return wear_holy_seal_list && wear_holy_seal_list[pos - 1]
		}
	}

	GetEquipList() {
		let equip_list = []
		let wear_holy_seal_list = this.goods_model.wear_holy_seal_list
		for (let _tmpi in wear_holy_seal_list) {
			var equip = wear_holy_seal_list[_tmpi]
			equip_list[equip.subtype - 1] = equip
		}
		return equip_list
	}

	GetHolySealBagList(config_seal_kv) {

		this.bag_full_list = []
		for (let index in this.goods_model.holy_seal_bag_goods_list) {
			var vo = this.goods_model.holy_seal_bag_goods_list[index]
			this.bag_full_list[index] = vo
		}

		let count = this.bag_full_list.length
		let max_count = this.GetkeyValue(1, config_seal_kv)
		let blockCount = max_count - count
		let i = 0
		do {
			table.insert(this.bag_full_list, { type_id: 0 })
			i = i + 1
		} while ((i < blockCount))
		return this.bag_full_list
	}

	GetWearEquipInfo(goods_id?) {

		return this.goods_model.wear_holy_seal_dic[goods_id]
	}


	GetEquipTypeName(equip_type, cfgs) {
		let key = HolySealModel.GOODS_TYPE + "@" + equip_type
		let cfg = cfgs[key] //Config.GoodsSubtype
		return cfg && cfg.subtype_name || ""
	}

	GetHolySealData(type_id, config_seal_equip) {
		return config_seal_equip && config_seal_equip[Number(type_id)] //config_seal_equip
	}

	GetkeyValue(key, config_seal_kv) {
		return config_seal_kv && config_seal_kv[key] && config_seal_kv[key]["value"] //config_seal_kv
	}

	GetHolySealSuitCfg(suit_id, config_seal_suit) {
		return config_seal_suit && config_seal_suit[suit_id] //config_seal_suit
	}

	GetHolySealStrenCfg(equip_type, stren, config_seal_strong) {
		if (equip_type != null && stren != null) {
			return config_seal_strong && config_seal_strong[equip_type + "@" + stren] //config_seal_strong
		}
	}

	GetHolySealStrenDate(equip_type?) {
		return this.stren_data && this.stren_data[equip_type]
	}

	GetStage2BgSource(stage?) {

		let source = ""
		switch (stage) {
			case 1:
				source = "uisy_014b"
				break;
			case 2:
				source = "uisy_014c"
				break;
			case 3:
				source = "uisy_014d"
				break;
			case 4:
				source = "uisy_014e"
				break;
			case 5:
				source = "uisy_014f"
				break;
			case 6:
				source = "uisy_014g"
				break;
			case 7:
				source = "uisy_014g"
				break;
			default:
				source = "uisy_014a"
				break
		}
		return source
	}


	GetStage2StrokeColor(stage?) {
		let color = ""
		switch (stage) {
			case 1:
				color = "#687a3a"
				break;
			case 2:
				color = "#396796"
				break;
			case 3:
				color = "#6c3b95"
				break;
			case 4:
				color = "#984821"
				break;
			case 5:
				color = "#9e2a2a"
				break;
			case 6:
				color = "#c02c57"
				break;
			case 7:
				color = "#c02c57"
				break;
			default:
				color = "#F8f56e"
				break
		}
		return color
	}


	GetStageDropData() {

		let drop = []
		table.insert(drop, { id: 0, content: "不筛选" })
		let i = 4
		do {
			table.insert(drop, { id: i, content: WordManager.ConvertNum(i) + "阶以下", cond: i })
			i = i + 1
		} while ((i <= 15))
		return drop
	}

	GetColorDropData() {

		let drop = []
		table.insert(drop, { id: 0, content: "不筛选" })
		let i = 0
		do {
			let color = i + HolySealModel.DROP_BASE_TYPE
			// if (PlatformManager.GetInstance().IsEyouThPlatform() ) {
			// 	table.insert(drop, {id = i, content = "ดังต่อไปนี้" + ColorUtil.GetColorName(color) , cond = color})
			// }else{
			table.insert(drop, { id: i, content: ColorUtil.GetColorName(color) + "以下", cond: color })
			// }
			i = i + 1
		} while ((i < 5)
		)
		return drop
	}

	RefreshStrongRed(seal_equip_cfg) {
		let strong_bool = false
		let holy_seal_bag_goods_list = this.goods_model.holy_seal_bag_goods_list
		if (holy_seal_bag_goods_list) {
			for (let _tmpi in holy_seal_bag_goods_list) {
				var goods_vo = holy_seal_bag_goods_list[_tmpi]
				if (goods_vo.type == HolySealModel.GOODS_TYPE) {
					let equip = this.GetWearEquipByPos(goods_vo.subtype)
					if (equip && goods_vo.color == 3 && equip.color > 3) {
						let equip_data = this.GetHolySealData(equip.type_id, seal_equip_cfg)
						let now_data = this.GetHolySealData(goods_vo.type_id, seal_equip_cfg)
						if (equip_data && now_data && now_data.stage - equip_data.stage > 5) {
							strong_bool = true
							break
						}
					} else {
						if (!equip || goods_vo.rating > equip.rating) {
							strong_bool = true
							break
						}
					}
				}
			}
		}
		this.SetRedFlag(HolySealModel.RedFlag.Strong, strong_bool)
	}


	RefreshDecomposeRed() {

		let decompose_bool = false
		let holy_seal_bag_goods_list = this.goods_model.holy_seal_bag_goods_list
		for (let _tmpi in holy_seal_bag_goods_list) {
			var goods_vo = holy_seal_bag_goods_list[_tmpi]
			if (goods_vo.type != HolySealModel.GOODS_TYPE) {
				decompose_bool = true
				break
			}
		}
		this.SetRedFlag(HolySealModel.RedFlag.Decompose, decompose_bool)
	}

	TryRefreshStrenRed() {
		let config_seal_equip, config_seal_strong
		config_seal_equip = Config.PRELOAD_SERVER_CONFIG.config_seal_equip
		config_seal_strong = Config.PRELOAD_SERVER_CONFIG.config_seal_strong

		if (config_seal_equip && config_seal_strong) {
			this.RefreshStrenRed(config_seal_equip, config_seal_strong)
		}
	}


	RefreshStrenRed(config_seal_equip, config_seal_strong) {

		let stren_bool = false
		let stren_data = this.stren_data
		if (stren_data) {
			for (let pos in stren_data) {
				let lv = stren_data[pos]
				let equip_data = this.GetWearEquipByPos(pos)
				if (equip_data) {
					let holy_data = this.GetHolySealData(equip_data.type_id, config_seal_equip)
					let max_lv = holy_data.strong
					let stren_cfg = this.GetHolySealStrenCfg(pos, lv + 1, config_seal_strong)
					if (stren_cfg && max_lv > lv) {
						let cost_cfg = JSON.parse(stren_cfg.cost)
						let cost = cost_cfg && cost_cfg[0] && cost_cfg[0][2]
						let have = this.goods_model.GetSpecialScore(HolySealModel.MONEY_TYPE)
						if (have >= Number(cost)) {
							stren_bool = true
							break
						}
					}
				}
			}
		}
		this.SetRedFlag(HolySealModel.RedFlag.Stren, stren_bool)
	}

	RefreshSoulRed() {

		let soul_bool = false
		let soul_data = this.soul_data
		let main_role_lv = this.role_mgr.GetMainRoleVo().level
		if (soul_data) {
			for (let goods_id in soul_data) {

				let data = soul_data[goods_id]
				let max_count = 0
				for (let _tmpi in data.cond) {
					var vo = data.cond[_tmpi]
					if (main_role_lv >= vo.lv_min && main_role_lv <= vo.lv_max) {
						max_count = vo.num
						break
					}
				}
				if (max_count) {
					let my_count = this.goods_model.GetTypeGoodsNum(goods_id)
					if (max_count > data.num && my_count > 0) {
						soul_bool = true
						break
					}
				}
			}
		}
		this.SetRedFlag(HolySealModel.RedFlag.Soul, soul_bool)
	}



	SetRedFlag(flag?, state?) {

		if (!flag) {
			return
		}
		let now_flag = 0
		if (state) {
			now_flag = this.red_flag | flag
		} else {
			now_flag = this.red_flag & ~flag
		}
		if (now_flag == this.red_flag) {
			return
		}
		this.red_flag = now_flag
		this.Fire(HolySealModel.REFRESH_RED_FLAG, flag)
		RedDotController.ins.up(RedKey.BRIGHT_SEA, this.red_flag ? 1 : 0)
		GlobalEventSystem.Fire(
			EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			"BagView",
			BagModel.Index.HolySeal,
			this.GetRedState()
		)
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
	}

	HasRedFlag(flag?) {

		if (!flag) {
			return false
		}
		return ((this.red_flag & flag) != 0)
	}

	GetRedState() {
		let open_state = this.GetOpenState()
		return open_state ? this.red_flag > 0 : false
	}

	GetOpenState() {
		let bool1 = this.open_lv <= RoleManager.GetInstance().GetMainRoleLevel()
		let bool2 = CommonManager.GetInstance().CheckFuncOpenState("HolySealView", true)
		return bool1 && bool2
	}

	CantWearEquip(type_id?, cfgs?) {

		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, type_id, false)
		let ditt_sex = cfg.sex != 0 && this.role_mgr.GetMainRoleVo().sex != cfg.sex
		return ditt_sex
	}

	GetSuitType(pos) {
		return Number(pos) < 7 ? HolySealModel.Suit_Type.One : HolySealModel.Suit_Type.Two
	}

	GetEquipBgbByType(equip_type) {
		equip_type = Number(equip_type)
		if (equip_type < 7 || equip_type == 11) {
			return 1
		}
		else
			return 2
	}


	public static GetInstance() {

		if (!HolySealModel.Instance) {
			HolySealModel.Instance = new HolySealModel()
		}
		return HolySealModel.Instance
	}
}
window["HolySealModel"] = HolySealModel