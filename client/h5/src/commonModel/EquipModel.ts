import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
export const EquipEvent = {
	REQUEST_PROTO: "EquipEvent.REQUEST_PROTO",
	SELECT_EQUIP: "EquipEvent.SELECT_EQUIP",
	SELECT_SMELT: "EquipEvent.SELECT_SMELT",
	OPEN_STREN_MASTER_VIEW: "EquipEvent.OPEN_MASTER_VIEW",
	OPEN_SMELT_MASTER_VIEW: "EquipEvent.OPEN_SMELT_MASTER_VIEW",
	OPEN_VIEW: "EquipEvent.OPEN_VIEW",
	CLOSE_VIEW: "EquipEvent.CLOSE_VIEW",
	SELECT_EQUIP_TO_WEAR: "EquipEvent.SELECT_EQUIP_TO_WEAR",
	UPDATE_ALL_STREN: "EquipEvent.UPDATE_ALL_STREN",
	UPDATE_ALL_SMELT: "EquipEvent.UPDATE_ALL_SMELT",
	UPDATE_ONE_STREN: "EquipEvent.UPDATE_ONE_STREN",
	UPDATE_ONE_SMELT: "EquipEvent.UPDATE_ONE_SMELT",
	SELECT_SMELT_EQUIP: "EquipEvent.SELECT_SMELT_EQUIP",
	SELECT_STREN_EQUIP: "EquipEvent.SELECT_STREN_EQUIP",
	SELECT_JEWEL_EQUIP: "EquipEvent.SELECT_JEWEL_EQUIP",
	SELECT_JEWEL_GOODS: "EquipEvent.SELECT_JEWEL_GOODS",
	SELECT_JEWEL_POS: "EquipEvent.SELECT_JEWEL_POS",
	SET_JEWEL: "EquipEvent.SET_JEWEL",
	OFF_JEWEL: "EquipEvent.OFF_JEWEL",
	UPGRADE_JEWEL: "EquipEvent.UPGRADE_JEWEL",
	COMPOSE_JEWEL: "EquipEvent.COMPOSE_JEWEL",
	WEAR_SUCCESS: "EquipEvent.WEAR_SUCCESS",
	SELECT_SUIT_ITEM: "EquipEvent.SELECT_SUIT_ITEM",
	BUILD_SUIT_SUCCESS: "EquipEvent.BUILD_SUIT_SUCCESS",
	BACK_SUIT_SUCCESS: "EquipEvent.BACK_SUIT_SUCCESS",
	UPDATE_SUIT_COND: "EquipEvent.UPDATE_SUIT_COND",
	UPDATE_STREN_RED: "EquipEvent.UPDATE_STREN_RED",
	UPDATE_SMELT_RED: "EquipEvent.UPDATE_SMELT_RED",
	UPDATE_JEWEL_RED: "EquipEvent.UPDATE_JEWEL_RED",
	UPDATE_WASH_RED: "EquipEvent.UPDATE_WASH_RED",
	SELECT_WASH_EQUIP: "SELECT_WASH_EQUIP",
	OPEN_WASH_PROP: "OPEN_WASH_PROP",
	LOCK_WASH_PROP: "LOCK_WASH_PROP",
	UPDATE_WASH_EQUIP: "UPDATE_WASH_EQUIP",
	UPDATE_WASH_FREETIEM: "UPDATE_WASH_FREETIEM",
	UPDATE_WASH_PROP_RED: "UPDATE_WASH_PROP_RED",
	PLAY_PROP_EFFECT: "PLAY_PROP_EFFECT",
	UPDATE_DIVISION_RED: "UPDATE_DIVISION_RED",
	JEWEL_SEMLT_SUCCESS: "JEWEL_SEMLT_SUCCESS",
	JEWEL_SEMLT_INFO: "JEWEL_SEMLT_INFO",
	SELECT_JEWEL_CARVE_GOODS: "SELECT_JEWEL_CARVE_GOODS",
	UPDATE_JEWEL_CARVE_RED: "UPDATE_JEWEL_CARVE_RED",
	ALL_STREN_FAIL: "ALL_STREN_FAIL",
	ALL_SMELT_FAIL: "ALL_SMELT_FAIL",
	GOD_EQUIP_UP: "EquipEvent.GOD_EQUIP_UP",
	GOD_EQUIP_DATA: "EquipEvent.GOD_EQUIP_DATA",
	UPDATE_SUIT_REWARD: "EquipEvent.UPDATE_SUIT_REWARD",
	GOD_EQUIP_POWER_UP_RETURN: "EquipEvent.GOD_EQUIP_POWER_UP_RETURN",
	SUBTYPE_POWER: "EquipEvent.SUBTYPE_POWER",
	UPDATE_SMELT_ITEM_RED: "UPDATE_SMELT_ITEM_RED",
	UPDATE_REFI_RED: "EquipEvent.UPDATE_REFI_RED",
	UPDATA_REFI_VIEW: "EquipEvent.UPDATA_REFI_VIEW",
	UPDATE_SUIT_DATA: "UPDATE_SUIT_DATA",
	CLOSE_REFIUP_VIEW: "CLOSE_REFIUP_VIEW",
	UPDATE_MASTER_VIEW: "UPDATE_MASTER_VIEW",
	UPDATE_MASTER_RED: "UPDATE_MASTER_RED",
	PLAY_END_EFFECT: "PLAY_END_EFFECT"
}
window["EquipEvent"] = EquipEvent
export const EquipDefine = {
	EQUIP_POS: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
	JEWEL_POS: [1, 2, 3, 4, 5, 6],
	SPIEIT_POS: [1, 4, 8, 6, 2, 10, 5, 3],
	RED_POS: [1, 2, 4, 6, 8, 10],
	SUIT_TYPE_LIST: [1, 2, 3],
	EQUIP_COUNT: 10,
	SMELT_GOODS_TYPE_ID: 38040002,
	SMELT_TOP_GOODS_TYPE_ID: 38040093,
	STREN_GOODS_TYPE_ID: 31,
	STREN_WHOLE_TYPE: 1,
	SMELT_WHOLE_TYPE: 8,
	JEWEL_WHOLE_TYPE: 3,
	EQUIP_TYPE: 10,
	JEWEL_TYPE: 14,
	JEWEL_SMELT_SUBTYPE: 3,
	JEWEL_COUNT: 6,
	NOT_SHOW_OND_KEY_WEAR_DOT_LV: 210,
	JEWEL_OPEN_LV: 120,
	SUIT_NAME_CFG: ["妖魂", "修罗", "万物"],
	SUIT_GOODS_TYPE: 38,
	SUIT_GOODS_SUBTYPE: 24,
	SUIT_OPEN_LV: 240,
	SUIT_MIN_SLV: 1,
	SUIT_MAX_SLV: 12,
	RING_SHOW_ID: 101094071,
	BANGLE_SHOW_ID: 101074071,
	WASH_DIVISION_GOODS: 38040027,
	REFINEMENT_GOODS: 38040092,
	REFINEMENT_TWO_GOODS: 38040095,
	REFINEMENT_DIVISION: 9,
	JEWEL_TYPE_DIC: { "1": { id: 14010009, name: "攻击" }, "2": { id: 14020009, name: "防御" } },
	JEWEL_UP_GOODS: 14110007,
	EQUIP_SUIT_COUNT_LIST: [2, 4, 6],
	JEWEL_SUIT_COUNT_LIST: [2, 3, 4],
	EQUIP_SUIT_MIN_STAGE: 5, //装备套装最小阶数
}
window["EquipDefine"] = EquipDefine
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "./RoleManager"
import { Enum_ColorUtil_Dark, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
// EquipTips = [SET_EQUIPS="您换下的为套装部件，且无法转移到新的装备上，\n是否更换该装备（返还全部套装石）？"]

import { EventDispatcher } from "../util/EventDispatcher"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { HtmlColorTxt, Trim, Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { VipModel } from "./VipModel"

export enum EquipmentViewSecond_Menu_Type {
	Skill = 1,
	Fashion = 2,
	Achv = 3,
	Medal = 4,
	Dsgt = 5,
	Suit = 6,
	Unreal = 7
}
window["EquipmentViewSecond_Menu_Type"] = EquipmentViewSecond_Menu_Type
export const EquipmentViewSecond_Open_Id = [
	69,
	107,
	59,
	12,
	35,
	24,
	113
]
window["EquipmentViewSecond_Open_Id"] = EquipmentViewSecond_Open_Id
export enum EquipViewToIndex {
	Strength = 0,
	Smlet = 1,
	Jewel = 2,
	Wash = 3,
	Refinement = 4,
	Armor = 5
}
window["EquipViewToIndex"] = EquipViewToIndex
export class EquipModel extends EventDispatcher {
	GetWearEquipsStrenPower
	GetSuitMaxStage
	GetEquipWashAllRed
	wash_lock_dic
	CheckSuitRedDotOne
	canNotBuildMessage
	equip_smelt_info
	wash_free_times
	jewel_max_dic
	GetStrongEquipsRed
	GetBagJewelsByType
	CheckSuitRedDotAll
	getGodEquipName
	GetSuitMakeCost
	GetStrenData
	GetSmeltMasterPower
	CheckStrenRedDotOne
	GetTrueStren
	CookieLockList
	InitConfig2
	SetWashRedStatus
	wash_select_pos
	CheckJewelCraveReddot
	CheckJewelUpgrade
	GetWearEquipsPower
	getGodEquipConf
	CheckSmeltRedDotAll
	otherFullGodEquip
	CheckStrongestRed
	equip_wash_hint
	GetWearEquipsSmeltPower
	DoSetAll
	GetSuitNumAndEquipsBySType
	CheckEquipJewelRedOne
	SetSuitData
	getAddAttr
	shortExtraAttrColor
	CompareStage
	GetStrenMasterPower
	GetEquipData
	CheckEquipJewelRedOneChange
	CheckJewelEmptyPos
	GetCurSuitsLv
	JewelSuitCanUp
	setGodEquipInfo
	jewel_one_up
	GetNormalWearEquipInfos
	GetStageByTypeId
	suitRed
	GetWholeAwardCfg
	GetSuitType
	IsOpenCrave
	checkRefinementRed
	GetWashUnlockLvInfo
	is_setting // 是否一键镶嵌中
	isOneKeyUpgrade = false // 是否一键升级中
	InitConfig1
	GetSuitCfg
	IsUnLockSuit
	CantWearEquip
	GetWashInfo
	getGodEquipNameConf
	GetStarByTypeId
	InitEquipWashLockDic
	CheckSmeltRedDotOne
	suitDataList
	CheckEquipJewelRedAll
	IsCanCrave
	checkFullPos
	checkGodEquip
	GetEquipSuitRed
	CopySCMD
	CheckWashProFreeRed
	GetAllRedStatusPower
	godEquipShowTips
	GetWashRedStatus
	GetSuitNumAndEquips
	godEquipAllattr
	CheckWashFreeRed
	GetSuitMakeCfg
	GetAttrStr
	CheckStrenRedMarkOne
	suitJewelRedList
	CheckCanRefine
	GetJewelWeakestPower
	CheckJewelRedAll
	GetUnLockSuitCondition
	GetBagEquipInfos
	CheckJewelUpgradeByTypeId
	GetSuitDataByDynamic
	getGodEquipInfo
	GetUnLockSuitConditionByCfg
	EquipSuitCanUp
	CheckEquipJewelRedAllChange
	CheckStrenRedDotAll
	GetSmeltInfo
	GodEquipNotStr
	GetJewelTypeByPos
	CheckSuitRedStatus
	GetWearEquipInfo
	godEquipitemRedDot
	getGodEquipConfList
	SetSuitRedStatus
	SetSmeltInfo
	GetWearEquipInfos
	CheckWashRed
	GetStrongestEquipByType
	GetAllSmeltLv
	GetStrengthInfo
	GetDynamicsByType
	showTipsAttr2
	godEquipIndex
	SetStrengthInfo
	CheckEquipJewelRedOneUpgrade
	jewel_crave_data_list
	CheckJewelUpgradeByAllGoods
	GetSuitNumAndEquipsByDynamic
	GetWearEquipDynamics
	godEquipRedDot
	GetJewelAttrStr
	GetWearEquipDynamic
	getRefineAttr
	GetBagJewels
	GetAllJewelLv
	IsWashDivision
	CheckWearJewelUpgradeByTypeId
	CheckJewelSetOne
	GetWearEquipsJewelPower
	SetJewelRedStatus
	CheckSmetlRedMarkOne
	GetAllRedStatus
	GetBagJewelStrongestPower
	GetSmeltData
	GetStrongestEquips
	showTipsAttr
	UpdateSuitData
	GetAllStrenLv
	godEquip_total_power_up
	CheckWashDivisionRed
	fullGodEquip
	CheckWashDivisionRedAll
	suitEquipRedList
	checkFullAttr
	GetJewelSuitRed
	GetEquipInfosByType
	GetSuitMakeCfgByDynamic
	Reset
	GetSmeltInfos
	GetSuitCfgByDynamic
	CheckJewelReplace
	GetWashAttrInfo
	CheckJewelRedStatus
	GetCurSuitLv
	GetSuitMaxStageByTypeId
	godEquip_total_power
	SetMasterData
	UpdateMasterData
	GetMasterLv
	GetMasterNextLv
	CheckMasterRed
	wash_lock
	one_key_mark
	GetRedDic
	static Instance

	config_equip_pos2suittype
	config_equip_suit_make
	config_equip_suit_item
	config_god_pos_limit
	config_god_equip_cfg

	public constructor() {
		super()
		if (EquipModel.Instance) {
			return
		}
		EquipModel.Instance = this

		this.equip_smelt_info = 0
		this.equip_wash_hint = false
		this.wash_lock = false
		// this.jewel_max_dic = [];
		this.jewel_crave_data_list = {}
		this.wash_lock_dic = {}
		this.wash_select_pos = 0
		this.godEquip_total_power = 0
		this.godEquip_total_power_up = 0
		this.wash_free_times = 0
		let ConfigHasDefaultValue = Config.ConfigHasDefaultValue
		let local_Config = Config
		let local_Erlang = ErlangParser.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_EquipDefine = EquipDefine
		let erlang_parser = ErlangParser.GetInstance()
		let local_Number = Number
		let role_mgr = RoleManager.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem
		let REFRESH_FUNCTION_ICON_RED_DOT = EventName.REFRESH_FUNCTION_ICON_RED_DOT
		let local_EventName = EventName
		let local_EquipEvent = EquipEvent
		let cookie_wrapper = CookieWrapper.GetInstance()
		let local_WordManager = WordManager
		let whole_cfg_ = null
		let stren_cost_dic_ = {}
		let smelt_cost_dic_ = {}
		let smelt_cost_top_dic_ = {}
		// let stren_data_dic_ = []
		// let smelt_data_dic_ = []
		let equip_wash_attr_ = null
		let jewel_crave_goods_list_ = {}
		let _strongest_red_ = false
		let equip_str_info_ = null
		let _godEquip_dic_ = {}
		let equip_smelt_info_ = null
		let equip_str_dic_ = {}
		let equip_smelt_dic_ = {}
		let equip_master_dic = {}
		let master_red = {}

		this.InitConfig1 = () => {
			this.config_equip_pos2suittype = Config.PRELOAD_SERVER_CONFIG.config_equip_pos2suittype
			this.config_god_equip_cfg = Config.PRELOAD_SERVER_CONFIG.config_god_equip_cfg
			this.config_god_pos_limit = Config.PRELOAD_SERVER_CONFIG.config_god_pos_limit
			this.config_equip_suit_item = Config.PRELOAD_SERVER_CONFIG.config_equip_suit_item
			this.config_equip_suit_make = Config.PRELOAD_SERVER_CONFIG.config_equip_suit_make
		}

		this.InitConfig2 = () => {
		}

		this.Reset = () => {
			equip_str_info_ = null
			equip_smelt_info_ = null
			stren_cost_dic_ = {}
			smelt_cost_dic_ = {}
			smelt_cost_top_dic_ = {}
			// stren_data_dic_ = []
			// smelt_data_dic_ = []
		}

		// this.preload_server_config = {
		// 	"config_equip_pos2suittype":false,
		// 	"config_equip_suit_make":false,
		// 	"config_equip_suit_item":false
		// }

		this.GetWashInfo = (pos?, equip_wash_cfg?) => {
			return equip_wash_cfg[pos]
		}

		this.GetWashUnlockLvInfo = (pos) => {
			//这里已保证调用的时候配置被加载了
			let config_equip_wash_unlock_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash_unlock_lv", false)
			return config_equip_wash_unlock_lv[pos]
		}

		this.GetWashAttrInfo = (pos?, cfgs?) => {
			let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.config_equip_wash_attr.name, pos, false, cfgs)
			if (cfg && typeof (cfg.attr_color) == 'string') {
				cfg.attr_color = cfg.attr_color && JSON.parse(cfg.attr_color)
				cfg.attr_white = cfg.attr_white && JSON.parse(cfg.attr_white)
				cfg.attr_green = cfg.attr_green && JSON.parse(cfg.attr_green)
				cfg.attr_blue = cfg.attr_blue && JSON.parse(cfg.attr_blue)
				cfg.attr_purple = cfg.attr_purple && JSON.parse(cfg.attr_purple)
				cfg.attr_orange = cfg.attr_orange && JSON.parse(cfg.attr_orange)
				cfg.attr_red = cfg.attr_red && JSON.parse(cfg.attr_red)
			}
			return (cfg && (cfg) || (null))
		}

		this.SetStrengthInfo = (info?, fire?) => {
			if (fire == null) {
				fire = true
			}
			if (fire) {
				this.ChangeVar("equip_str_info", info)
			}
			equip_str_dic_[info.equip_type] = info
		}

		this.GetStrengthInfo = (equip_type?) => {
			return equip_str_dic_[equip_type]
		}

		this.SetSmeltInfo = (info?, fire?) => {
			if (fire == null) {
				fire = true
			}
			if (fire) {
				this.ChangeVar("equip_smelt_info", info)
			}
			equip_smelt_dic_[info.equip_type] = info
		}

		this.GetSmeltInfo = (equip_type?) => {
			return equip_smelt_dic_[equip_type]
		}

		this.GetSmeltInfos = () => {
			return equip_smelt_dic_
		}

		this.GetStageByTypeId = (type_id?, equip_attr_cfg?) => {
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false, equip_attr_cfg)
			return attr_cfg && attr_cfg.stage || 0
		}

		this.GetStarByTypeId = (type_id?, equip_attr_cfg?) => {
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false, equip_attr_cfg)
			return attr_cfg && attr_cfg.star || 0
		}

		this.GetEquipData = (type_id?) => {
			return Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false)
		}

		this.GetWearEquipDynamic = (equip_type?) => {
			let equipInfo = this.GetWearEquipInfo(equip_type)
			if (!equipInfo) {
				return
			}
			let dynamic = goods_model.GetDynamic(equipInfo.goods_id, null, false, true)
			return dynamic
		}

		this.GetWearEquipDynamics = () => {
			let equipInfos = this.GetWearEquipInfos()
			let gmodel = goods_model
			let list = []
			for (let key in equipInfos) {
				let v = equipInfos[key]
				let dynamic = gmodel.GetDynamic(v.goods_id, null, false, true)
				if (dynamic) {
					table.insert(list, dynamic)
				}
			}
			return list
		}

		this.GetWearEquipInfos = () => {
			return goods_model.wear_equip_list
		}

		this.GetNormalWearEquipInfos = () => {
			let list = []
			for (let key in goods_model.wear_equip_list) {
				let equip = goods_model.wear_equip_list[key]
				//local  = goods_model.wear_equip_list[key]
				if (((equip.cell == 5 || equip.cell == 7) || equip.cell == 9) || equip.cell == 3) {
				} else {
					table.insert(list, equip)
				}
			}
			return list
		}

		this.GetWearEquipInfo = (equip_type?) => {
			return goods_model.wear_equip_list[equip_type]
		}

		this.GetTrueStren = (info?, stren?, stren_max_cfg?) => {
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false)
			let max_key = attr_cfg.stage + "@" + info.color + "@" + info.equip_type
			let max_cfg = stren_max_cfg[max_key]
			let lv = 0
			if (max_cfg) {
				let is_max = max_cfg.stren_max <= stren
				lv = is_max && max_cfg.stren_max || stren
			}
			return lv
		}

		this.GetStrenMasterPower = () => {
			let lv = this.GetAllStrenLv()
			let [cur_cfg, next_cfg] = this.GetWholeAwardCfg(local_EquipDefine.STREN_WHOLE_TYPE, lv)
			if (!cur_cfg) {
				return 0
			}
			return Util.CalAttrPower(cur_cfg.attr_list)
		}

		this.GetSmeltMasterPower = () => {
			let lv = this.GetAllSmeltLv()
			let [cur_cfg, next_cfg] = this.GetWholeAwardCfg(local_EquipDefine.SMELT_WHOLE_TYPE, lv)
			if (!cur_cfg) {
				return 0
			}
			return Util.CalAttrPower(cur_cfg.attr_list)
		}

		this.GetWearEquipsStrenPower = (stren_key_cfg?, stren_cfg?, stren_max_cfg?) => {
			let power = 0
			let list = this.GetWearEquipInfos()
			if (Util.TableSize(list) < 1) {
				return power
			}
			// let attr_cfg = Config.ConfigItemAttr
			for (let key in list) {
				let info = list[key]
				let stren_info = this.GetStrengthInfo(info.equip_type)
				if (stren_info) {
					let stren = this.GetTrueStren(info, stren_info.stren, stren_max_cfg)
					let cfg = this.GetStrenData(info.equip_type, stren, stren_key_cfg, stren_cfg)
					let attr_list = cfg && erlang_parser.Parse(cfg.attr_list) || {}
					for (let _tmpi in attr_list) {
						let attr = attr_list[_tmpi]
						attr[1] = local_Number(attr[1]) * stren
					}
					power = power + Util.CalAttrPower(attr_list, false)
				}
			}
			return power
		}

		this.GetWearEquipsSmeltPower = (equip_refine_lv_cfgs?, equip_stren_lv_cfgs?) => {
			if (!equip_refine_lv_cfgs) {
				return
			}
			let power = 0
			let list = this.GetWearEquipInfos()
			if (Util.TableSize(list) < 1) {
				return power
			}
			// let attr_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let pacent = 0
			let lv = this.GetAllSmeltLv()
			let all_strong = null
			let [cur_cfg, next_cfg] = this.GetWholeAwardCfg(EquipDefine.SMELT_WHOLE_TYPE, lv)
			if (cur_cfg) {
				all_strong = cur_cfg.stren_ratio
			}
			for (let key in list) {
				pacent = 0
				let info = list[key]
				let smelt_info = this.GetSmeltInfo(info.equip_type)
				if (!smelt_info || !smelt_info.refine) {
				} else {
					let cfg = this.GetSmeltData(info.equip_type, smelt_info.refine, equip_refine_lv_cfgs)
					if (cfg) {
						let attr_list = JSON.parse(cfg.attr_list)
						for (let key1 = cfg.refine; key1 >= 0; key1 -= 1) {
							let value = equip_refine_lv_cfgs[cfg.part + "@" + key1]
							if (value) {
								pacent = pacent + value.stren_ratio
							}
						}
						let str_list = equip_str_dic_
						if (str_list[cfg.part]) {
							let strong_lv = str_list[cfg.part].stren
							let cfg1 = Config.GetConfigVo(ConfigHasDefaultValue.config_equip_stren_lv.name, cfg.part + "@0", false, equip_stren_lv_cfgs)
							if (cfg1) {
								let str_cfg = cfg1.attr_list
								let attr = ErlangParser.GetInstance().Parse(str_cfg)
								let j = 0
								pacent = (all_strong && (pacent + all_strong) || (pacent))
								for (let _tmpi in attr) {
									let atr = attr[_tmpi]
									atr[1] = atr[1] * strong_lv
									attr_list[j] = [Number(atr[0]), Math.floor(atr[1] * pacent / 10000)]
									j = j + 1
								}
								power = power + Util.CalAttrPower(attr_list, false)
							}
						}
					}
				}
			}
			return power
		}

		this.GetWearEquipsJewelPower = (jewel_lv_cfg?, equip_stone_refine_cfg?) => {
			let power = 0
			let list = this.GetWearEquipDynamics()
			if (Util.TableSize(list) < 1) {
				return power
			}
			let attr_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let jewel_cfg = jewel_lv_cfg
			let cur_equip_power = 0
			for (let _tmpi in list) {
				let info = list[_tmpi]
				cur_equip_power = 0
				for (let _tmpi in info.stone_list) {
					let jinfo = info.stone_list[_tmpi]
					let cfg = jewel_cfg[jinfo.type_id]
					cur_equip_power = cur_equip_power + Util.CalAttrPower(cfg.attr)
				}
				let crave_data = this.jewel_crave_data_list[info.equip_type]
				if (crave_data) {
					let crave_config = equip_stone_refine_cfg[crave_data.equip_type + "@" + crave_data.refine_lv]
					if (crave_config) {
						cur_equip_power = cur_equip_power + Util.CalAttrPower(crave_config.attr)
						cur_equip_power = cur_equip_power * 1 + crave_config.overall_plus / 100
					}
				}
				power = power + Mathf.Floor(cur_equip_power)
			}
			return power
		}

		this.GetWearEquipsPower = () => {
			let power = 0
			let list = this.GetWearEquipInfos()
			if (Util.TableSize(list) < 1) {
				return power
			}
			for (let key in list) {
				let info = list[key]
				power = power + info.combat_power
			}
			return power
		}

		this.GetBagEquipInfos = () => {
			return goods_model.bag_goods_list
		}

		this.GetEquipInfosByType = (stype?) => {
			let equips = goods_model.GetEquipList()
			let list = []
			for (let _tmpi in equips) {
				let info = equips[_tmpi]
				if (info.equip_type == stype) {
					table.insert(list, info)
				}
			}
			return list
		}

		this.CheckStrongestRed = (goods_cfg?) => {
			let [list] = this.GetStrongestEquips(goods_cfg)
			let bool = list.length > 0
			if (bool != _strongest_red_) {
				_strongest_red_ = bool
			}
		}

		this.GetStrongEquipsRed = () => {
			return _strongest_red_
		}

		this.GetStrongestEquips = (goods_cfg?, target_pos?, checkSuit?) => {
			let list = []
			let bagEquips = goods_model.bag_goods_list
			if (bagEquips.length < 1) {
				return [list]
			}
			//是否显示套装提示
			let showSuitAlert
			let empty
			let equips = this.GetWearEquipInfos()
			let equipList = goods_model.GetEquipList()
			for (let i = 0; i < local_EquipDefine.EQUIP_POS.length; i++) {
				if (!target_pos || target_pos && target_pos == i + 1) {
					let pos = local_EquipDefine.EQUIP_POS[i]
					let info = this.GetWearEquipInfo(pos)
					let strongest = this.GetStrongestEquipByType(pos, goods_cfg, equipList)
					if ((!info && strongest) || ((info && strongest) && strongest.rating > info.rating)) {
						if (!info) {
							table.insert(list, 1, strongest)
							empty = true
						} else {
							if (checkSuit && !showSuitAlert) {
								// let suitCfg = GameResPath.GetServerConfigPath("config_equip_pos2suittype")[pos]
								// if (suitCfg) {
								// 	if (suitCfg.type == 1) {
								// 		let curLv = this.GetCurSuitLv(pos)
								// 		if (curLv > 0) {
								// 			if (info.stage == strongest.stage) {
								// 				showSuitAlert = !this.EquipSuitCanUp(strongest, false, true)
								// 			} else {
								// 				showSuitAlert = true
								// 			}
								// 		}
								// 	} else {
								// 		let cursLv = this.GetCurSuitsLv(strongest.equip_type)
								// 		if (cursLv > 0) {
								// 			showSuitAlert = !this.JewelSuitCanUp(strongest, false, true)
								// 		}
								// 	}
								// }
							}
							table.insert(list, strongest)
						}
					}
				}
			}
			return [list, empty, showSuitAlert]
		}

		this.GetStrongestEquipByType = (stype?, goods_cfg?, equipList?) => {
			let career = role_mgr.GetMainRoleVo().career
			let equips = equipList//this:GetBagEquipInfos()
			let strongest = null
			for (let _tmpi in equips) {
				let info = equips[_tmpi]
				let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, info.type_id, false)
				if (cfg) {
					if (cfg.career_id != 0 && career != cfg.career_id) {
					} else {
						if (info.equip_type != stype) {
						} else {
							if (role_mgr.GetMainRoleVo().level < cfg.level) {
							} else {
								if (cfg.turn != 0 && role_mgr.GetMainRoleVo().turn < cfg.turn) {
								} else {
									if (cfg.sex != 0 && role_mgr.GetMainRoleVo().sex != cfg.sex) {
									} else {
										strongest = (strongest && info.rating < strongest.rating && (strongest) || (info))
									}
								}
							}
						}
					}
				}
			}
			return strongest
		}

		this.GetWholeAwardCfg = (stype?, lv?) => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_whole_reward
			let cur_cfg, next_cfg
			let cur_index = 0
			let index = stype * 1000
			let data
			while (cfg[index]) {
				data = cfg[index]
				cur_index += 1
				if (lv >= data.need_lv && lv <= data.next_nlv) {
					cur_cfg = data
					break
				}
				index += 1
			}
			cur_index = cur_cfg ? cur_index : 0
			next_cfg = cur_cfg ? cfg[(index + 1).toString()] : cfg[(stype * 1000).toString()]
			return [cur_cfg, next_cfg, cur_index]
		}

		this.GetAllSmeltLv = () => {
			let refine = 0
			for (let key in equip_smelt_dic_) {
				let info = equip_smelt_dic_[key]
				refine = refine + info.refine
			}
			return refine
		}

		this.GetAllStrenLv = () => {
			let lv = 0
			let wear_infos = this.GetWearEquipDynamics()
			if (wear_infos.length < 1) {
				return lv
			}
			for (let _tmpi in wear_infos) {
				let info = wear_infos[_tmpi]
				lv = lv + info.stren
			}
			return lv
		}

		/**获取已镶嵌宝石总等级 */
		this.GetAllJewelLv = (jewel_lv_cfg?) => {
			let lv = 0
			let wear_infos = this.GetWearEquipDynamics()
			if (wear_infos.length < 1) {
				return lv
			}
			for (let _tmpi in wear_infos) {
				let info = wear_infos[_tmpi]
				for (let _tmpi in info.stone_list) {
					let jinfo = info.stone_list[_tmpi]
					lv = lv + jewel_lv_cfg[jinfo.type_id].lv
				}
			}
			return lv
		}

		/**
		 * 宝石可合成红点
		 */
		this.CheckWearJewelUpgradeByTypeId = (type_id?, jewel_lv_cfg?) => {
			let cur_data = jewel_lv_cfg[type_id]
			let can_up = cur_data.next_lv_stone != 0
			if (!can_up) {
				return false
			}
			let own = goods_model.GetTypeGoodsNum(type_id)
			if (own + 1 >= cur_data.need_num) {
				return true
			}
			let result = this.CheckJewelUpgradeByAllGoods(type_id, cur_data.need_num - 1, jewel_lv_cfg)
			return result
		}

		/**判断改宝石合成材料是否足够 */
		this.CheckJewelUpgradeByTypeId = (type_id?, jewel_lv_cfg?) => {
			let cfg = jewel_lv_cfg[type_id]
			let can_up = cfg.next_lv_stone != 0
			if (!can_up) {
				return false
			}
			let own = goods_model.GetTypeGoodsNum(type_id)
			return own >= cfg.need_num
		}

		/** 该部位下是否可合成红点 */
		this.CheckJewelUpgrade = (dynamic?, jewel_lv_cfg?) => {
			if (dynamic.stone_list.length < 1) {
				return false
			}
			let gmodel = goods_model
			let cfg = jewel_lv_cfg
			let cur_data = null
			for (let _tmpi in dynamic.stone_list) {
				let jinfo = dynamic.stone_list[_tmpi]
				let own = gmodel.GetTypeGoodsNum(jinfo.type_id)
				cur_data = cfg[jinfo.type_id]
				let can_up = cur_data.next_lv_stone != 0
				if (can_up) {
					if (this.jewel_one_up > 0 || own + 1 >= cur_data.need_num) {
						return true
					} else {
						let result = this.CheckJewelUpgradeByAllGoods(jinfo.type_id, cur_data.need_num - 1, jewel_lv_cfg)
						if (result) {
							return true
						}
					}
				}
			}
			return false
		}

		this.CheckJewelUpgradeByAllGoods = (target_id?, need_num?, jewel_lv_cfg?) => {
			let cur_data = jewel_lv_cfg[target_id]
			let own = goods_model.GetTypeGoodsNum(target_id)
			let can_up = own >= need_num
			if (can_up) {
				return true
			}
			if (cur_data != null && cur_data.pre_lv_stone) {
				let target_num = cur_data.need_num * need_num - own
				let result = this.CheckJewelUpgradeByAllGoods(cur_data.pre_lv_stone, target_num, jewel_lv_cfg)
				if (result) {
					return true
				}
			} else {
				return can_up
			}
			return false
		}

		this.CheckJewelReplace = (dynamic?, equip_stone_inlay_cfg?, jewel_lv_cfg?) => {
			let [wpower, weakest] = this.GetJewelWeakestPower(dynamic, jewel_lv_cfg)
			if (!weakest) {
				return [false]
			}
			let [spower, strongest] = this.GetBagJewelStrongestPower(dynamic.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg)
			return [spower > wpower, strongest, weakest]
		}

		this.CheckJewelEmptyPos = (dynamic?, equip_stone_pos_unlock_cfg?) => {
			if (dynamic.stone_list.length >= local_EquipDefine.JEWEL_COUNT) {
				return [false]
			}
			let list = []
			for (let _tmpi in dynamic.stone_list) {
				let stdata = dynamic.stone_list[_tmpi]
				list[stdata.pos] = Number(stdata.pos)
			}
			for (let pos of local_EquipDefine.JEWEL_POS) {
				if (list[pos] == null) {
					let cfg = equip_stone_pos_unlock_cfg[dynamic.equip_type + "@" + pos]
					let cond = JSON.parse(cfg.condition)
					if (cond.length < 1) {
						return [true, dynamic.equip_type, pos]
					}
					cond = cond[0]
					if (cond[0] == "stage") {
						let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, dynamic.type_id, false)
						if (local_Number(cond[1]) <= attr_cfg.stage) {
							return [true, dynamic.equip_type, pos]
						}
					} else if (cond[0] == "vip") {
						let card = VipModel.GetInstance().GetNobleCardState()
						let vip_flag = role_mgr.GetMainRoleVo().vip_flag
						if (local_Number(cond[2]) <= vip_flag && local_Number(cond[1]) <= card) {
							return [true, dynamic.equip_type, pos]
						}
					}
				}
			}
			return [false]
		}

		this.GetBagJewelStrongestPower = (equip_type?, equip_stone_inlay_cfg?, jewel_lv_cfg?) => {
			let power = 0
			let target = null
			let glist = goods_model.bag_goods_list
			if (glist.length < 1) {
				return [0, target]
			}
			let jewel_types = JSON.parse(equip_stone_inlay_cfg[equip_type].stone_type)
			let cfg = jewel_lv_cfg
			let list = []
			for (let info of glist) {
				if (info.type == local_EquipDefine.JEWEL_TYPE && jewel_types.indexOf(info.subtype) >= 0) {
					table.insert(list, info)
				}
			}
			for (let _tmpi in list) {
				let info = list[_tmpi]
				if (cfg[info.type_id].rating > power) {
					power = cfg[info.type_id].rating
					target = info
				}
			}
			return [power, target]
		}

		this.GetJewelWeakestPower = (dynamic?, jewel_lv_cfg?) => {
			let power = Number.MAX_VALUE
			let target = null
			if (dynamic.stone_list.length < 1) {
				return [0, target]
			}
			let cfg = jewel_lv_cfg
			for (let _tmpi in dynamic.stone_list) {
				let jinfo = dynamic.stone_list[_tmpi]
				if (cfg[jinfo.type_id].rating < power) {
					power = cfg[jinfo.type_id].rating
					target = jinfo
				}
			}
			return [power, target]
		}

		/**获取背包中的宝石类型数据 */
		this.GetBagJewels = () => {
			let list = []
			let bag_list = goods_model.bag_goods_list
			for (let info of bag_list) {
				if (info.type == local_EquipDefine.JEWEL_TYPE) {
					table.insert(list, info)
				}
			}
			return list
		}

		this.GetBagJewelsByType = (equip_type?, equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_type_id?) => {
			let list = []
			let cfg = equip_stone_inlay_cfg[equip_type]
			if (!cfg) {
				return list
			}
			let type_list = cfg.stone_type
			let bag_list = goods_model.bag_goods_list
			let cur_cfg = jewel_lv_cfg[equip_type_id]
			if (cur_cfg) {
				for (let info of bag_list) {
					if (info.type == local_EquipDefine.JEWEL_TYPE && type_list.indexOf(String(info.subtype)) >= 0) {
						let tmp_cfg = jewel_lv_cfg[info.type_id]
						if (cur_cfg.rating < tmp_cfg.rating) {
							table.insert(list, info)
						}
					}
				}
			} else {
				for (let info of bag_list) {
					if (info.type == local_EquipDefine.JEWEL_TYPE && (type_list.indexOf(String(info.subtype)) >= 0)) {
						table.insert(list, info)
					}
				}
			}
			table.sort(list, (a?, b?) => {
				let aCfg = jewel_lv_cfg[a.type_id]
				let bCfg = jewel_lv_cfg[b.type_id]
				return bCfg.rating - aCfg.rating < 0
			}
			)
			return list
		}

		this.CopySCMD = (scmd?) => {
			let obj = []
			for (let key in scmd) {
				obj[key] = scmd[key]
			}
			return obj
		}

		/**通过宝石部位获取宝石子类型 */
		this.GetJewelTypeByPos = (dynamic?, pos?) => {
			for (let _tmpi in dynamic.stone_list) {
				let info = dynamic.stone_list[_tmpi]
				if (info.pos == pos) {
					return local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, info.type_id, false).subtype
				}
			}
			return -1
		}

		this.CheckJewelSetOne = (dynamic?, equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			let [has_empty, equip_type, stone_pos] = this.CheckJewelEmptyPos(dynamic, equip_stone_pos_unlock_cfg)
			if (has_empty) {
				return [has_empty, equip_type, stone_pos]
			}
			let [can_replace, strongest, weakest] = this.CheckJewelReplace(dynamic, equip_stone_inlay_cfg, jewel_lv_cfg)
			if (can_replace) {
				return [can_replace, dynamic.equip_type, weakest.pos]
			}
			return [false]
		}

		this.DoSetAll = (equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			let list = this.GetWearEquipDynamics()
			if (list.length < 1) {
				this.is_setting = false
				return false
			}
			for (let info of list) {
				let jewels = this.GetBagJewelsByType(info.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg)
				if (jewels.length > 0) {
					let [result, equip_type, pos] = this.CheckJewelSetOne(info, equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
					if (result) {
						let [power, goods_data] = this.GetBagJewelStrongestPower(info.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg)
						if (goods_data) {
							Laya.timer.once(100, this, () => {
								this.Fire(local_EquipEvent.REQUEST_PROTO, 15208, "ccl", equip_type, pos, goods_data.goods_id)
							})
							return true
						}
					}
				}
			}
			this.is_setting = false
			return false
		}

		this.CheckStrenRedDotAll = (is_add?) => {
			if (!common_mgr.CheckFuncOpenState("EquipView", true)) {
				return
			}
			let equips = this.GetWearEquipDynamics()
			if (equips.length < 1) {
				return
			}
			let equip_attr_cfg
			let stren_key_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stren_lv_key
			let stren_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stren_lv
			let stren_max_cfg
			let callback = () => {
				if (stren_key_cfg && stren_cfg && stren_max_cfg) {
					equip_attr_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
					let result = false
					let old_red = false
					for (let equip of equips) {
						result = red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_STREN, equip.equip_type)
						old_red = result
						if (is_add == null) {
							result = this.CheckStrenRedMarkOne(equip, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
						} else if (is_add && !old_red) {
							result = this.CheckStrenRedMarkOne(equip, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
						} else if (!is_add && old_red) {
							result = this.CheckStrenRedMarkOne(equip, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
						}
						if (result) {
							break
						}
					}
					local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
					let red = result || this.CheckMasterRed(1)
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Strength, red)

					ResManager.GetInstance().DestoryGameConfig(this, "config_equip_strengthen_max", false)
				}
			}

			ResManager.GetInstance().LoadGameConfig(this, "config_equip_strengthen_max", false, undefined, (cfg) => {
				stren_max_cfg = cfg
				callback()
			})
		}

		this.CheckStrenRedDotOne = (equip?, cfgs?, stren_key_cfg?, stren_cfg?, stren_max_cfg?) => {
			if (!equip) {
				return false
			}
			let stren_info = this.GetStrengthInfo(equip.equip_type)
			if (!stren_info) {
				return false
			}
			let key = equip.equip_type + "@" + stren_info.stren
			let cfg = this.GetStrenData(equip.equip_type, stren_info.stren, stren_key_cfg, stren_cfg)
			if (!cfg) {
				return false
			}
			let stage = this.GetStageByTypeId(equip.type_id, cfgs)
			let max_key = stage + "@" + equip.color + "@" + equip.equip_type
			let max_cfg = stren_max_cfg[max_key]
			if (!max_cfg) {
				return false
			}
			let is_max = max_cfg.stren_max <= stren_info.stren
			if (is_max) {
				return false
			}
			let cost = stren_cost_dic_[key]
			if (!cost) {
				cost = erlang_parser.Parse(cfg.object_list)
				if (cost.length < 1) {
					return false
				}
				cost = cost[0]
				stren_cost_dic_[key] = cost
			}
			let own = goods_model.GetRoleSpecGoodsNum(cost[0], cost[1])
			return own >= Number(cost[2])
		}

		this.CheckSmeltRedDotAll = (is_add?) => {
			if (!common_mgr.CheckFuncOpenState("EquipSmeltView", true)) {
				return
			}
			let equips = this.GetWearEquipDynamics()
			if (equips.length < 1) {
				return
			}
			let equip_attr_cfgs
			let equip_refine_lv_cfgs
			let smelt_max_cfg
			let callback = () => {
				if (equip_refine_lv_cfgs && smelt_max_cfg) {
					equip_attr_cfgs = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
					let result = false
					let old_red = false
					for (let _tmpi in equips) {
						let equip = equips[_tmpi]
						result = red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_SMELT, equip.equip_type)
						old_red = result
						if (is_add == null) {
							result = this.CheckSmetlRedMarkOne(equip, equip_attr_cfgs, equip_refine_lv_cfgs, smelt_max_cfg)
						} else if (is_add && !old_red) {
							result = this.CheckSmetlRedMarkOne(equip, equip_attr_cfgs, equip_refine_lv_cfgs, smelt_max_cfg)
						} else if (!is_add && old_red) {
							result = this.CheckSmetlRedMarkOne(equip, equip_attr_cfgs, equip_refine_lv_cfgs, smelt_max_cfg)
						}
						if (result) {
							break
						}
					}
					local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Smlet, result)
					ResManager.GetInstance().DestoryGameConfig(this, "config_equip_refine_lv", false)
					ResManager.GetInstance().DestoryGameConfig(this, "config_equip_refine_max", false)
				}
			}
			ResManager.GetInstance().LoadGameConfig(this, "config_equip_refine_lv", false, undefined, (cfg) => {
				equip_refine_lv_cfgs = cfg
				callback()
			})
			ResManager.GetInstance().LoadGameConfig(this, "config_equip_refine_max", false, undefined, (cfg) => {
				smelt_max_cfg = cfg
				callback()
			})
		}

		this.CheckSmeltRedDotOne = (equip?, equip_attr_cfgs?, equip_refine_lv_cfgs?, smelt_max_cfg?) => {
			let smelt_info = this.GetSmeltInfo(equip.equip_type)
			if (!smelt_info) {
				return false
			}
			let key = equip.equip_type + "@" + smelt_info.refine
			let cfg = this.GetSmeltData(equip.equip_type, smelt_info.refine, equip_refine_lv_cfgs)
			if (!cfg) {
				return false
			}
			let stage = this.GetStageByTypeId(equip.type_id, equip_attr_cfgs)
			let max_key = stage + "@" + equip.color + "@" + equip.equip_type
			let max_cfg = smelt_max_cfg[max_key]
			if (!max_cfg) {
				return false
			}
			let is_max = max_cfg.refine_max <= smelt_info.refine
			if (is_max) {
				return false
			}
			let cost = smelt_cost_dic_[key]
			let cost_top = smelt_cost_top_dic_[key]
			if (!cost || !cost_top) {
				let obj_list = JSON.parse(cfg.object_list)
				if (obj_list.length < 1) {
					return false
				}
				cost = obj_list[0]
				cost_top = (obj_list[1] && (obj_list[1]) || (null))
				smelt_cost_dic_[key] = cost
				smelt_cost_top_dic_[key] = cost_top
			}
			let result = null
			let own = goods_model.GetRoleSpecGoodsNum(cost[0], cost[1])
			let own_top = null
			if (cost_top) {
				own_top = goods_model.GetRoleSpecGoodsNum(cost_top[0], cost_top[1])
			}
			result = (cost_top && (own_top >= Number(cost_top[2]) && own >= Number(cost[2])) || (own >= Number(cost[2])))
			return result
		}

		this.CheckStrenRedMarkOne = (equip?, cfgs?, stren_key_cfg?, stren_cfg?, stren_max_cfg?) => {
			if (!equip) {
				return false
			}
			let red = this.CheckStrenRedDotOne(equip, cfgs, stren_key_cfg, stren_cfg, stren_max_cfg)
			red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_STREN, equip.equip_type, red)
			RedDotController.ins.add(RedKey.EQUIP_STREN + equip.equip_type, RedKey.EQUIP_STREN);
			RedDotController.ins.up(RedKey.EQUIP_STREN + equip.equip_type, red ? 1 : 0);
			return red
		}

		this.CheckSmetlRedMarkOne = (equip?, equip_attr_cfgs?, equip_refine_lv_cfgs?, smelt_max_cfg?) => {
			let red = this.CheckSmeltRedDotOne(equip, equip_attr_cfgs, equip_refine_lv_cfgs, smelt_max_cfg)
			red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_SMELT, equip.equip_type, red)
			RedDotController.ins.add(RedKey.EQUIP_SMELT + equip.equip_type, RedKey.EQUIP_SMELT);
			RedDotController.ins.up(RedKey.EQUIP_SMELT + equip.equip_type, red ? 1 : 0);
			return red
		}

		this.CheckEquipJewelRedOneChange = (dynamic?, equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			let jewels = this.GetBagJewelsByType(dynamic.equip_type, equip_stone_inlay_cfg, jewel_lv_cfg)
			if (jewels.length < 1) {
				return false
			}
			let [result] = this.CheckJewelSetOne(dynamic, equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
			return result
		}

		this.CheckEquipJewelRedAllChange = (equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			if (!common_mgr.CheckFuncOpenState("EquipJewelView", true)) {
				return false
			}
			let list = this.GetWearEquipDynamics()
			if (list.length < 1) {
				return false
			}
			let jewels = this.GetBagJewels()
			if (jewels.length < 1) {
				return false
			}
			for (let key in list) {
				let result = this.CheckEquipJewelRedOneChange(list[key], equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
				if (result) {
					return true
				}
			}
			return false
		}

		/**该部位下是否有合成红点 */
		this.CheckEquipJewelRedOneUpgrade = (dynamic?, jewel_lv_cfg?) => {
			let result = this.CheckJewelUpgrade(dynamic, jewel_lv_cfg)
			return result
		}

		/**改部位下是否有镶嵌或者合成红点 */
		this.CheckEquipJewelRedOne = (dynamic?, equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			let result = this.CheckEquipJewelRedOneChange(dynamic, equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
			if (!result) {
				result = this.CheckEquipJewelRedOneUpgrade(dynamic, jewel_lv_cfg)
			}
			return result
		}

		/**宝石镶嵌/合成/大师总红点 */
		this.CheckEquipJewelRedAll = (equip_stone_inlay_cfg?, jewel_lv_cfg?, equip_stone_pos_unlock_cfg?) => {
			let list = this.GetWearEquipDynamics()
			if (Util.TableSize(list) < 1) {
				return
			}
			for (let key in list) {
				let result = this.CheckEquipJewelRedOne(list[key], equip_stone_inlay_cfg, jewel_lv_cfg, equip_stone_pos_unlock_cfg)
				let red = result || this.CheckMasterRed(3)
				this.SetJewelRedStatus(list[key].equip_type, red)
			}
		}

		this.CheckJewelRedAll = () => {
			if (!common_mgr.CheckFuncOpenState("EquipJewelView", true)) {
				return
			}
			let Equipstoneinlay = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_inlay
			let Equipstonelv = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv
			let Equipstoneposunlock = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_pos_unlock

			if (Equipstoneinlay && Equipstonelv && Equipstoneposunlock) {
				this.jewel_one_up = goods_model.GetTypeGoodsNum(EquipDefine.JEWEL_UP_GOODS)
				this.CheckEquipJewelRedAll(Equipstoneinlay, Equipstonelv, Equipstoneposunlock)
				this.Fire(local_EquipEvent.UPDATE_JEWEL_RED)
				local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
			}
		}

		this.SetJewelRedStatus = (equip_type?, active?) => {
			red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_JEWEL, equip_type, active)
			RedDotController.ins.add(RedKey.EQUIP_JEWEL + equip_type, RedKey.EQUIP_JEWEL)
			RedDotController.ins.up(RedKey.EQUIP_JEWEL + equip_type, active ? 1 : 0);
		}

		this.CheckJewelRedStatus = (equip_type?) => {
			return red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_JEWEL, equip_type)
		}

		this.CheckWashRed = () => {
			if (!common_mgr.CheckFuncOpenState("EquipWashView", true)) {
				return false
			}
			if (this.GetWearEquipDynamics().length < 1) {
				return false
			}
			let equip_wash_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_wash
			let config_equip_wash_unlock_lv = Config.PRELOAD_SERVER_CONFIG.config_equip_wash_unlock_lv
			if (equip_wash_cfg && config_equip_wash_unlock_lv) {
				let equip_attr_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
				let role_lv = role_mgr.GetMainRoleVo().level
				let bool = false
				for (let pos = 1; pos < 10; pos++) {
					if (role_lv >= this.GetWashUnlockLvInfo(pos)["unlock_lv"]) {
						let list = this.GetWearEquipDynamics()
						for (let _tmpi in list) {
							let vo = list[_tmpi]
							if (pos == vo.equip_type) {
								let equip_red = this.CheckWashDivisionRed(vo, equip_attr_cfg, equip_wash_cfg)
								bool = (this.CheckWashProFreeRed(vo) || equip_red) || this.CheckWashFreeRed(vo, equip_attr_cfg, equip_wash_cfg)
								this.SetWashRedStatus(pos, bool)
							}
						}
					}
				}
				this.CheckWashDivisionRedAll()
			}
		}

		this.CheckWashDivisionRedAll = () => {
			if (!common_mgr.CheckFuncOpenState("EquipWashView", true)) {
				return
			}
			this.Fire(local_EquipEvent.UPDATE_DIVISION_RED)
			this.Fire(local_EquipEvent.UPDATE_WASH_RED)
			local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
		}

		this.GetEquipWashAllRed = () => {
			if (!common_mgr.CheckFuncOpenState("EquipWashView", true)) {
				return false
			}
			let status = red_dot_mgr.GetRedStatus(local_ModuleType.EQUIP_WASH)
			return status && status > 0
		}

		this.SetWashRedStatus = (equip_type?, active?) => {
			red_dot_mgr.SetRedStatus(local_ModuleType.EQUIP_WASH, equip_type, active)
			RedDotController.ins.add(RedKey.EQUIP_WASH + equip_type, RedKey.EQUIP_WASH);
			RedDotController.ins.up(RedKey.EQUIP_WASH + equip_type, active ? 1 : 0);
			local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
		}

		this.GetWashRedStatus = (equip_type?) => {
			return red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_WASH, equip_type)
		}

		this.CheckWashFreeRed = (vo?, equip_attr_cfg?, equip_wash_cfg?) => {
			let bool = false
			if (!vo) {
				return bool
			}
			if (this.wash_free_times && this.wash_free_times > 0) {
				bool = true
			}
			let next_pos = vo.equip_type + "@" + (vo.division + 1)
			let next_wash = this.GetWashInfo(next_pos, equip_wash_cfg)
			if (!next_wash) {
				return bool
			}
			let pos = vo.equip_type + "@" + vo.division
			let wash_list = this.GetWashInfo(pos, equip_wash_cfg)
			if (!wash_list) {
				return bool
			}
			let stage = this.GetStageByTypeId(vo.type_id, equip_attr_cfg)
			if ((wash_list.need_rating && vo.wash_rating && vo.wash_rating >= wash_list.need_rating) && this.wash_free_times > 0) {
				bool = false
			}
			return bool
		}

		this.CheckWashDivisionRed = (vo?, equip_attr_cfg?, equip_wash_cfg?) => {
			let bool = this.IsWashDivision(vo, equip_attr_cfg, equip_wash_cfg)
			if (!bool) {
				return bool
			}
			let pos = vo.equip_type + "@" + vo.division
			let wash_list = this.GetWashInfo(pos, equip_wash_cfg)
			if (!wash_list) {
				return false
			}
			let up_cost = wash_list.up_cost
			if (up_cost != "[]") {
				if (typeof (up_cost) == "string") {
					up_cost = JSON.parse(up_cost)[0]
					//this:GetWashInfo(pos, equip_wash_cfg).up_cost = up_cost
				}
			}
			let goodsModel = goods_model
			let [type_id] = goodsModel.GetMappingTypeId(up_cost[0], up_cost[1])
			if (type_id) {
				let have_num = goods_model.GetTypeGoodsNum(type_id)
				if (have_num >= Number(up_cost[2])) {
					return true
				}
			}
			return false
		}

		this.IsWashDivision = (equip_info?, equip_attr_cfg?, equip_wash_cfg?) => {
			if (!equip_info) {
				return
			}
			let next_pos = equip_info.equip_type + "@" + (equip_info.division + 1)
			let next_wash = this.GetWashInfo(next_pos, equip_wash_cfg)
			if (!next_wash) {
				return false
			}
			let pos = equip_info.equip_type + "@" + equip_info.division
			let wash_list = this.GetWashInfo(pos, equip_wash_cfg)
			if (!wash_list) {
				return false
			}
			let stage = this.GetStageByTypeId(equip_info.type_id, equip_attr_cfg)
			if (((wash_list.need_rating && wash_list.need_stage) && equip_info.wash_rating >= wash_list.need_rating) && stage >= wash_list.need_stage) {
				return true
			}
			return false
		}

		this.CheckWashProFreeRed = (vo?) => {
			if (!vo) {
				return false
			}
			let unlock_info = this.GetWashUnlockLvInfo(vo.equip_type)
			if (!unlock_info) {
				return false
			}
			let open_cost = unlock_info["unlock_cost"]
			let lv = role_mgr.mainRoleInfo.level
			if (lv < unlock_info.unlock_lv) {
				return false
			}
			if (typeof (open_cost) == "string") {
				open_cost = JSON.parse(open_cost)
			}
			for (let i in open_cost) {
				if (open_cost[i][1].length == 0 && !vo.wash_attr[i]) {
					return true
				}
			}
			return false
		}

		this.InitEquipWashLockDic = () => {
			let lock_str = cookie_wrapper.GetCookie(CookieWrapper.EQUIP_WASH_LOCK_LIST + RoleManager.GetInstance().GetMainRoleId())
			if (!lock_str) {
				this.wash_lock_dic = {}
				return
			}
			let pos = local_EquipDefine.EQUIP_POS
			this.wash_lock_dic = {}
			for (let subtype of pos) {
				this.wash_lock_dic[subtype] = this.wash_lock_dic[subtype] || {}
				for (let j = 0; j < 4; j++) {
					if (lock_str[(subtype - 1) * 4 + j] == "1") {
						this.wash_lock_dic[subtype][j + 1] = true
					}
				}
			}
		}

		this.CookieLockList = () => {
			let pos = local_EquipDefine.EQUIP_POS
			let lock_str = ""
			for (let subtype of pos) {
				for (let j = 0; j < 4; j++) {
					let pos_lock = this.wash_lock_dic[subtype]
					if (pos_lock && pos_lock[j + 1]) {
						lock_str = lock_str + "1"
					} else {
						lock_str = lock_str + "0"
					}
				}
			}
			cookie_wrapper.SaveCookie(CookieWrapper.EQUIP_WASH_LOCK_LIST + RoleManager.GetInstance().GetMainRoleId(), lock_str)
			//cookie_wrapper.WriteAll()
		}

		this.CheckJewelCraveReddot = () => {
			let has_open = common_mgr.CheckFuncOpenState("EquipJewelCraveEnterView", true)
			if (!has_open) {
				return false
			}
			let equip_stone_refine_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_refine
			let equip_stone_refine_goods_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_refine_goods
			let equip_stone_refine_limit_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_refine_limit

			if (!equip_stone_refine_cfg || !equip_stone_refine_goods_cfg || !equip_stone_refine_limit_cfg) {
				return
			}
			let list = this.GetWearEquipDynamics()
			if (Util.IsTableEmpty(jewel_crave_goods_list_)) {
				for (let key in equip_stone_refine_goods_cfg) {
					jewel_crave_goods_list_[equip_stone_refine_goods_cfg[key].goods_id] = true
				}
			}
			for (let key in jewel_crave_goods_list_) {
				let goodsNum = goods_model.GetTypeGoodsNum(key)
				jewel_crave_goods_list_[key] = goodsNum
			}
			let red = null
			let posExp = []
			for (let key in equip_stone_refine_goods_cfg) {
				let vo = equip_stone_refine_goods_cfg[key]
				if (!posExp[vo.equip_pos]) {
					posExp[vo.equip_pos] = vo.exp * jewel_crave_goods_list_[vo.goods_id]
				} else {
					posExp[vo.equip_pos] = posExp[vo.equip_pos] + vo.exp * jewel_crave_goods_list_[vo.goods_id]
				}
			}
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				red = false
				if (this.IsCanCrave(vo.equip_type, equip_stone_refine_cfg, equip_stone_refine_limit_cfg)) {
					let data = this.jewel_crave_data_list[vo.equip_type]
					if (data) {
						let lv = data.refine_lv
						let config = equip_stone_refine_cfg[vo.equip_type + "@" + lv]
						if (config && (posExp[vo.equip_type] >= config.exp - data.exp)) {
							red = true
						}
					}
				}
				red_dot_mgr.SetRedStatus(local_ModuleType.JEWEL_CRAVE_RED, vo.equip_type, red)
				RedDotController.ins.add(RedKey.JEWEL_CRAVE_RED + vo.equip_type, RedKey.JEWEL_CRAVE_RED);
				RedDotController.ins.up(RedKey.JEWEL_CRAVE_RED + vo.equip_type, red ? 1 : 0);
			}
			this.Fire(local_EquipEvent.UPDATE_JEWEL_CARVE_RED)
		}

		this.IsCanCrave = (equip_type?, equip_stone_refine_cfg?, equip_stone_refine_limit_cfg?) => {
			let data = this.jewel_crave_data_list[equip_type]
			if (data) {
				let lv = data.refine_lv
				let config = equip_stone_refine_cfg[equip_type + "@" + (lv + 1)]
				if (!this.IsOpenCrave(equip_type, equip_stone_refine_limit_cfg)) {
					return false
				}
				if (config) {
					return true
				} else {
					return false
				}
			}
			return false
		}

		this.IsOpenCrave = (equip_type?, equip_stone_refine_limit_cfg?) => {
			let equip_data = this.GetWearEquipDynamic(equip_type)
			let limit_config = equip_stone_refine_limit_cfg[equip_type]
			if (limit_config && equip_data) {
				let cfg_attr = JSON.parse(limit_config.limit)
				let stage_config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip_data.type_id, false)
				if (cfg_attr.length > 0 && stage_config) {
					if (stage_config.stage < Number(cfg_attr[0][0])) {
						return false
					}
					if (equip_data.color < Number(cfg_attr[0][1])) {
						return false
					}
				}
				return true
			}
			return false
		}

		this.GetSuitMakeCfg = (equip_type?, suit_lv?, suit_slv?) => {
			return Config.GetConfigVo("config_equip_suit_make", equip_type + "@" + suit_lv + "@" + suit_slv, false, this.config_equip_suit_make)
		}

		this.GetSuitMakeCfgByDynamic = (vo?, suit_lv?) => {
			let sdata = this.GetSuitDataByDynamic(vo, suit_lv)
			let suit_slv = sdata.suit_slv + 1
			return this.GetSuitMakeCfg(vo.equip_type, suit_lv, suit_slv)
		}

		this.GetSuitCfg = (suit_type?, lv?, slv?) => {
			return Config.GetConfigVo("config_equip_suit_item", suit_type + "@" + lv + "@" + slv, false, this.config_equip_suit_item)
		}

		this.GetSuitCfgByDynamic = (vo?, suit_lv?) => {
			let suit_type = this.GetSuitType(vo.equip_type)
			let sdata = this.GetSuitDataByDynamic(vo, suit_lv)
			let suit_slv = sdata.suit_slv + 1
			return Config.GetConfigVo("config_equip_suit_item", suit_type + "@" + suit_lv + "@" + suit_slv, false, this.config_equip_suit_item)
		}

		this.IsUnLockSuit = (dynamic?, suit_lv?, suit_slv?) => {
			let stage = null
			let color = null
			let star = 0
			let compare = null
			let result = false
			let sstage = this.GetStageByTypeId(dynamic.type_id)
			let cfg = this.GetSuitMakeCfgByDynamic(dynamic, suit_lv)
			if (!cfg) {
				return false
			}
			if (cfg.condition == "[]") {
				return true
			}
			let dstar = this.GetStarByTypeId(dynamic.type_id)
			let cond = JSON.parse(cfg.condition)
			for (let _tmpi in cond) {
				let info = cond[_tmpi]
				if (info[1] == "stage") {
					compare = info[2]
					stage = Number(info[3])
					result = this.CompareStage(compare, sstage, stage)
					if (!result) {
						return false
					}
				} else if (info[1] == "quality") {
					color = Number(info[2])
					star = Number(info[3])
					if (color > dynamic.color) {
						return false
					} else if (color == dynamic.color && star > dstar) {
						return false
					}
				} else if (info[1] == "activated") {
				}
			}
			return true
		}

		this.GetUnLockSuitCondition = (dynamic?, suit_lv?) => {
			let stage = null
			let color = null
			let star = null
			let cfg = this.GetSuitMakeCfgByDynamic(dynamic, suit_lv)
			if (!cfg) {
				return
			}
			return this.GetUnLockSuitConditionByCfg(cfg.condition)
		}

		this.GetUnLockSuitConditionByCfg = (condition?) => {
			if (condition == "[]") {
				return {}
			}
			let stage = 0
			let color = 0
			let star = 0
			let cond = JSON.parse(condition)
			for (let _tmpi in cond) {
				let info = cond[_tmpi]
				if (info[0] == "stage") {
					stage = info[2]
				} else if (info[0] == "quality") {
					color = info[1]
					star = info[2]
				}
			}
			return [stage, color, star]
		}

		this.CompareStage = (type_str?, sA?, sB?) => {
			if (type_str == "eq") {
				return sA == sB
			} else if (type_str == "gt") {
				return sA > sB
			} else if (type_str == "lt") {
				return sA < sB
			} else if (type_str == "ge") {
				return sA >= sB
			} else if (type_str == "le") {
				return sA <= sB
			} else {
				return false
			}
		}

		this.GetSuitType = (equip_type?) => {
			if (!equip_type) {
				return
			}
			return Config.GetConfigVo("config_equip_pos2suittype", equip_type, null, this.config_equip_pos2suittype).type
		}

		// this.GetSuitMaxStage = (equip_stage?, equip_type?) => {
		// 	if (!equip_stage) {
		// 		return 0
		// 	}
		// 	let suit_type = this.GetSuitType(equip_type)
		// 	let data = null
		// 	if (suit_type == 1) {
		// 		data = Config.Equipsuitstage[equip_stage]
		// 	} else {
		// 		data = Config.Equipsuitstagedecor[equip_stage]
		// 	}
		// 	return data && data.suit_stage || 0
		// }

		this.GetSuitMaxStageByTypeId = (type_id?) => {
			let stage = this.GetStageByTypeId(type_id)
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			return this.GetSuitMaxStage(stage, basic.equip_type)
		}

		// this.GetDynamicsByType = (type?) => {
		// 	let list = []
		// 	let equips = this.GetWearEquipDynamics()
		// 	for (let _tmpi in equips) {
		// 		let dynamic = equips[_tmpi]
		// 		let stype = this.GetSuitType(dynamic.equip_type)
		// 		if (stype == type) {
		// 			table.insert(list, dynamic)
		// 		}
		// 	}
		// 	return list
		// }

		this.GetSuitMakeCost = (equip_type?, suit_lv?, suit_slv?) => {
			let cfg = this.GetSuitMakeCfg(equip_type, suit_lv, suit_slv)
			if (!cfg) {
				return
			}
			let sex = role_mgr.GetMainRoleVo().sex
			let cost_cfg = JSON.parse(cfg.cost)
			for (let key in cost_cfg) {
				let info = cost_cfg[key]
				if (Number(info[0]) == sex) {
					return info[1]
				}
			}
			return
		}

		this.GetSuitNumAndEquipsByDynamic = (dynamic?) => {
			return this.GetSuitNumAndEquips(dynamic.equip_type, dynamic.suit_lv, dynamic.suit_slv)
		}

		this.GetSuitNumAndEquips = (equip_type?, suit_lv?, suit_slv?) => {
			let num = 0
			let list = []
			let dynamics = this.GetWearEquipDynamics()
			let suit_type = this.GetSuitType(equip_type)
			for (let _tmpi in dynamics) {
				let info = dynamics[_tmpi]
				if (this.GetSuitType(info.equip_type) == suit_type) {
					let sdata = this.GetSuitDataByDynamic(info, suit_lv)
					if (sdata.suit_lv != suit_lv) {
					} else {
						if (sdata.suit_slv != suit_slv) {
						} else {
							table.insert(list, info)
							num = num + 1
						}
					}
				}
			}
			return { num: num, list: list }
		}

		this.GetSuitNumAndEquipsBySType = (suit_type?, suit_lv?, suit_slv?) => {
			let num = 0
			let list = []
			let dynamics = this.GetWearEquipDynamics()
			for (let _tmpi in dynamics) {
				let info = dynamics[_tmpi]
				if (this.GetSuitType(info.equip_type) == suit_type) {
					let sdata = this.GetSuitDataByDynamic(info, suit_lv)
					if (sdata.suit_lv != suit_lv) {
					} else {
						if (sdata.suit_slv != suit_slv) {
						} else {
							table.insert(list, info)
							num = num + 1
						}
					}
				}
			}
			return { num: num, list: list }
		}

		this.SetSuitRedStatus = (mType?, rType?, active?) => {
			red_dot_mgr.SetRedStatus(mType, rType, active)
		}

		this.CheckSuitRedStatus = (mType?, rType?) => {
			return red_dot_mgr.CheckRedStatus(mType, rType)
		}

		this.GetAllRedStatus = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.SUIT_ONE)
			if (!red) {
				red = red_dot_mgr.CheckRedStatus(local_ModuleType.SUIT_SEC)
			}
			return red
		}

		this.GetAllRedStatusPower = () => {
			let red = red_dot_mgr.CheckRedStatus(local_ModuleType.SUIT_ONE_POWER)
			if (!red) {
				red = red_dot_mgr.CheckRedStatus(local_ModuleType.SUIT_SEC_POWER)
			}
			return this.suitRed
		}

		this.CheckSuitRedDotOne = (dynamic?, suit_lv?, equip_attr_cfgs?, suit_make_cfg?, suit_stage_cfg?, suit_stage_decor_cfg?) => {
			let stage = this.GetSuitMaxStageByTypeId(dynamic.type_id, equip_attr_cfgs, suit_stage_cfg, suit_stage_decor_cfg)
			let sdata = this.GetSuitDataByDynamic(dynamic, suit_lv)
			if (sdata.suit_slv >= stage) {
				return false
			}
			let suit_slv = sdata.suit_slv + 1
			let unlock = this.IsUnLockSuit(dynamic, suit_lv, equip_attr_cfgs, suit_make_cfg)
			if (!unlock) {
				return false
			}
			let cost_cfg = this.GetSuitMakeCost(dynamic.equip_type, suit_lv, suit_slv, suit_make_cfg)
			if (!cost_cfg) {
				return false
			}
			for (let key in cost_cfg) {
				let info = cost_cfg[key]
				let type_id = goods_model.GetMappingTypeId(info[0], info[1])
				let own = goods_model.GetTypeGoodsNum(type_id)
				if (own < Number(info[3])) {
					return false
				}
			}
			return true
		}

		// let GetTableLen = (tb) => {
		// 	let len = 0
		// 	if (!tb) { return len }
		// 	for (let k in tb) {
		// 		let v = tb[k]
		// 		if (k > len) {
		// 			len = k
		// 		}
		// 	}
		// 	return len
		// }

		this.CheckSuitRedDotAll = () => {
			if (!common_mgr.CheckFuncOpenState("EquipSuitBaseView", true)) {
				return
			}
			//装备 有升级就有红点
			//饰品 等级最小的可以升级就有红点
			//let suit_cfg = Config.Equipsuititem
			//let equip_attr_cfgs = Config.config_equip_attr
			//let suit_make_cfg = Config.Equipsuitmake
			//let suit_stage_cfg = Config.Equipsuitstage
			//let suit_stage_decor_cfg = Config.Equipsuitstagedecor
			this.suitEquipRedList = []
			this.suitJewelRedList = []
			this.suitRed = false
			if (this.suitDataList) {
				//饰品等级最低的数据
				let minData = []
				for (let equipType in this.suitDataList) {
					let suitData = this.suitDataList[equipType]
					//装备
					let suitType = this.config_equip_pos2suittype[suitData.equip_type] && this.config_equip_pos2suittype[suitData.equip_type].type
					if (suitType) {
						if (suitType == 1) {
							let equipStage = 0
							let canUp = this.EquipSuitCanUp(this.GetWearEquipDynamic(suitData.equip_type), true)
							if (canUp) {
								if (!this.suitEquipRedList[suitData.lv + 1]) {
									this.suitEquipRedList[suitData.lv + 1] = {}
								}
								this.suitEquipRedList[suitData.lv + 1][suitData.equip_type] = true
							}
						} else {
							//饰品 先找出最小的
							let canUp = this.JewelSuitCanUp(this.GetWearEquipDynamic(suitData.equip_type), true)
							if (canUp) {
								if (minData.length == 0) {
									minData = [suitData]
								} else if (minData[0].slv > suitData.slv) {
									minData = [suitData]
								} else if (minData[0].slv == suitData.slv) {
									table.insert(minData, suitData)
								}
							}
						}
					}
				}
				if (minData.length > 0) {
					//let canUp = this.JewelSuitCanUp(this.GetWearEquipDynamic(minData[1].equip_type),true)
					//if (canUp ) {
					for (let key in minData) {
						let suitData = minData[key]
						this.suitJewelRedList[suitData.equip_type] = true
					}
				}
			}
			this.suitRed = !Util.IsTableEmpty(this.suitJewelRedList) || !Util.IsTableEmpty(this.suitEquipRedList)
			this.Fire(local_EquipEvent.UPDATE_SUIT_COND)
			local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
		}

		this.GetAttrStr = (attr_list?, color?) => {
			let str = ""
			if (!attr_list) {
				return str
			}
			let i = 0
			do {
				let attr = attr_list[i]
				let line = (i + 1 != attr_list.length && ("\n") || (""))
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				if (color) {
					str = str + local_WordManager.GetProperties(attr[0]) + "：" + "<font color=\"" + color + "\">" + value + "</font><br/>" + line
				} else {
					str = str + local_WordManager.GetProperties(attr[0]) + "：" + value + "<br/>" + line
				}

				i = i + 1
			} while ((i < attr_list.length))
			return str
		}

		this.GetJewelAttrStr = (attr_list?) => {
			let str = ""
			if (!attr_list) {
				return str
			}
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				if (!attr) { break }
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				if (i == attr_list.length - 1) {
					str = str + local_WordManager.GetProperties(attr[0]) + "<font color='#0a953e'>+" + value + "</font>"
				} else {
					str = str + local_WordManager.GetProperties(attr[0]) + "<font color='#0a953e'>+" + value + "</font><br/>"
				}
			}
			return str
		}

		this.GetSuitDataByDynamic = (dynamic?, suit_lv?) => {
			if (dynamic && dynamic.suit_list) {
				for (let _tmpi in dynamic.suit_list) {
					let info = dynamic.suit_list[_tmpi]
					if (info.suit_lv == suit_lv) {
						return info
					}
				}
			}
			return { suit_lv: 0, suit_slv: 0, suit_count: 0 }
		}

		this.GetSmeltData = (pos?, lv?, equip_refine_lv_cfgs?) => {
			let kkey = pos + "@" + lv
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refine_lv", false)
			return cfg[kkey]
		}

		this.GetStrenData = (pos?, lv?, stren_key_cfg?, stren_cfg?) => {
			let kkey = pos + "@" + lv
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stren_lv
			return local_Config.GetConfigVo(ConfigHasDefaultValue.config_equip_stren_lv.name, kkey, false, cfg)
		}

		this.CantWearEquip = (type_id?, cfgs?) => {
			let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, type_id, false, cfgs)
			let ditt_sex = cfg.sex != 0 && role_mgr.GetMainRoleVo().sex != cfg.sex
			let ditt_career = cfg.career_id != 0 && role_mgr.GetMainRoleVo().career != cfg.career_id
			return ditt_sex || ditt_career
		}

		this.setGodEquipInfo = (data?) => {
			this.godEquip_total_power = data.total_power
			for (let key in data.god_info) {
				let info = data.god_info[key]
				_godEquip_dic_[info.pos] = info
			}
			this.Fire(local_EquipEvent.GOD_EQUIP_DATA)
			this.ChangeVar("godEquip_red_dot", this.godEquipRedDot(), false, true)
		}

		this.getGodEquipInfo = (pos?) => {
			return _godEquip_dic_[pos]
		}

		this.getGodEquipConf = (pos?, level?) => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_god_equip_level
			return cfg[pos + "@" + level]
		}

		this.getGodEquipConfList = (pos?) => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_god_equip_level
			let list = []
			for (let key in cfg) {
				let conf = cfg[key]
				if (conf.pos == pos) {
					table.insert(list, conf)
				}
			}
			return list
		}

		this.getGodEquipNameConf = (config_god_equip_cfg, level?) => {
			return config_god_equip_cfg[level]
		}

		this.getGodEquipName = (config_god_equip_cfg, level?, isTitle?) => {
			if (isTitle == null) {
				isTitle = true
			}
			let name = ''
			let conf = this.getGodEquipNameConf(config_god_equip_cfg, level)
			if (conf) {
				name = (isTitle && (conf.show_all) || (conf.show))
			}
			return name
		}

		this.godEquipIndex = (attr_cfg?) => {
			let index = null
			let count = 0
			let canBuild = null
			let first = null
			let posList = local_EquipDefine.EQUIP_POS
			for (let key in posList) {
				let pos = posList[key]
				let equip = this.GetWearEquipInfo(pos)
				if (first == null && equip) {
					first = count
				}
				if (equip && this.godEquipitemRedDot(equip)) {
					canBuild = count
					break
				}
				count = count + 1
			}
			index = canBuild != null && canBuild || first
			return index
		}

		this.godEquipShowTips = (config_god_equip_cfg, goods_vo?, god_lv?) => {
			let name = ""
			if (god_lv) {
				name = this.getGodEquipName(config_god_equip_cfg, god_lv)
			} else {
				let equip = goods_model.wear_equip_list[goods_vo.cell]
				if (equip && equip.goods_id == goods_vo.goods_id) {
					let posinfo = this.getGodEquipInfo(goods_vo.cell)
					//let level = (posinfo && posinfo.level && (posinfo.level) || (0))
					if (posinfo) {
						name = this.getGodEquipName(config_god_equip_cfg, posinfo.level)
					}
				}
			}
			return name
		}

		this.fullGodEquip = (_equip?, goods_vo?) => {
			let flag = false
			if (!_equip) {
				return flag
			}
			let equip = null
			if (goods_vo) {
				equip = goods_model.wear_equip_list[goods_vo.cell]
			} else {
				equip = _equip
			}
			if (!equip) {
				return false
			}
			let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false)
			if (this.checkFullPos(equip.cell, equip.color, attr_list.stage, attr_list.star)) {
				flag = true
			}
			return flag
		}

		this.otherFullGodEquip = (goods_vo?, cfgs?) => {
			let flag = false
			if (!goods_vo) {
				return flag
			}
			if (!this.checkFullAttr(goods_vo.god_level, goods_vo.cell, goods_vo.stage)) {
				return false
			}
			let limit = cfgs && cfgs["strength_limit"]
			let limitList = []
			if (limit && limit.value) {
				limitList = JSON.parse(limit.value)
			}
			let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, goods_vo.type_id, false)
			if (this.checkFullPos(goods_vo.cell, goods_vo.color, attr_list.stage, attr_list.star)) {
				flag = true
			}
			return flag
		}

		this.showTipsAttr = (cfg_god_equip_cfg, goods_vo?) => {
			let tips = ""
			let title = ""
			let flag = false
			let equip = goods_model.wear_equip_list[goods_vo.cell]
			if ((equip && this.fullGodEquip(equip)) && equip.goods_id == goods_vo.goods_id) {
				let posinfo = this.getGodEquipInfo(goods_vo.cell)
				let level = (posinfo && posinfo.level && (posinfo.level) || (0))
				let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false)
				let conf = this.getGodEquipConf(goods_vo.cell, level)
				let tslet_not = !cfg_god_equip_cfg || !this.checkFullAttr(level, goods_vo.cell, attr_list.stage)
				if (((posinfo && conf) && conf.extra_attr) && local_Number(conf.extra_attr) != 0) {
					flag = true
					let color = (tslet_not && ("#93847D") || ("#ff4f50"))
					let att = Mathf.Floor(local_Number(conf.extra_attr) / 100)
					tips = "<font color='" + color + "'>" + local_WordManager.GetEquipPos(goods_vo.cell) + "专有属性：" + att + "%</font>"
					title = this.getGodEquipName(cfg_god_equip_cfg, posinfo.level, false)
				}
				if (tslet_not) {
					tips = tips + "<font color='#93847D'>" + this.GodEquipNotStr(cfg_god_equip_cfg, attr_list.stage) + "</font>"
				}
				if (posinfo && conf && conf.base_attr_add && Trim(conf.base_attr_add) != '[]') {
					let base_attr_add = JSON.parse(conf.base_attr_add)
					for (let key in base_attr_add) {
						let attr_obj = base_attr_add[key]
						let str = ""
						if (attr_obj[0] == 'attr') {
							for (let key in attr_obj[1]) {
								let element = attr_obj[1][key]
								str = str + "<br>" + local_WordManager.GetProperties(element[0]) + "：" + HtmlColorTxt(local_WordManager.ConvertToPercentValue(element[0], element[1]), "'#d15e00'")
							}
						} else {
							let attr = Mathf.Floor(local_Number(attr_obj[1]) / 100)
							str = "<br>" + local_WordManager.GetEquipPos(goods_vo.cell) + "基础属性：<font color='#d15e00'>" + attr + "%</font>"
						}
						tips = tips + str
					}
				}
			}
			return [tips, title, flag]
		}

		this.showTipsAttr2 = (cfg_god_equip_cfg, goods_vo?, lev?) => {
			let tips = ""
			let title = ""
			let posinfo = this.getGodEquipInfo(goods_vo.cell)
			let level = null
			if (lev != null) {
				level = lev
			} else {
				level = (posinfo && posinfo.level && (posinfo.level) || (0))
			}
			let conf = this.getGodEquipConf(goods_vo.cell, level)
			if (conf && conf.extra_attr && local_Number(conf.extra_attr) != 0) {
				let godEquip_cfg = cfg_god_equip_cfg[level]
				let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, goods_vo.type_id, false)
				let tslet_not = !godEquip_cfg || !this.checkFullAttr(level, goods_vo.cell, attr_list.stage)
				let color = (tslet_not && ("#93847D") || ("#ff4f50"))
				let att = Mathf.Floor(local_Number(conf.extra_attr) / 100)
				tips = "<font color='" + color + "'>" + local_WordManager.GetEquipPos(goods_vo.cell) + "专有属性：" + att + "%</font>"
				if (tslet_not) {
					tips = tips + "<font color='#93847D'>" + this.GodEquipNotStr(cfg_god_equip_cfg, attr_list.stage) + "</font>"
				}
			}
			if (conf && conf.base_attr_add && Trim(conf.base_attr_add) != '[]') {
				let base_attr_add = JSON.parse(conf.base_attr_add)
				for (let key in base_attr_add) {
					let attr_obj = base_attr_add[key]
					let str = ""
					if (attr_obj[0] == 'attr') {
						for (let key in attr_obj[1]) {
							let element = attr_obj[1][key]
							str = str + "<br>" + local_WordManager.GetProperties(element[0]) + "：" + HtmlColorTxt(local_WordManager.ConvertToPercentValue(element[0], element[1]), Enum_ColorUtil_Dark.WHITE)
						}
					} else {
						let attr = Mathf.Floor(local_Number(attr_obj[1]) / 100)
						str = "<br>" + local_WordManager.GetEquipPos(goods_vo.cell) + "基础属性：<font color=" + Enum_ColorUtil_Dark.WHITE + ">" + attr + "%</font>"
					}
					tips = tips + str
				}
			}
			title = this.getGodEquipName(cfg_god_equip_cfg, lev, false)
			return [tips, title]
		}

		this.GodEquipNotStr = (cfg_god_equip, stage?) => {
			let cfg = cfg_god_equip
			let str = ''
			let cfgLevel = 0
			for (let key in cfg) {
				let info = cfg[key]
				if (((cfgLevel > 0 && info.level < cfgLevel) || cfgLevel == 0) && stage <= info.max) {
					let a: String = Trim(info.show_all)
					let endIndex = a.length - 1
					let name = a.slice(0, endIndex)
					str = "(" + name + "可唤醒)"
					cfgLevel = info.level
				}
			}
			return str
		}

		// BaseAwardItem里设置特效用
		// this.checkGodEquip = (goods_id?) => {
		// 	let flag = false
		// 	let equipInfos = this.GetWearEquipInfos()
		// 	for (let key in equipInfos) {

		// 		let equip = equipInfos[key]
		// 		let posinfo = this.getGodEquipInfo(equip.cell)
		// 		if (((equip.goods_id == goods_id && posinfo) && posinfo.level >= 1) && this.fullGodEquip(equip)) {
		// 			let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false)
		// 			if (this.checkFullAttr(posinfo.level, equip.cell, attr_list.stage)) {
		// 				flag = true
		// 				break
		// 			}
		// 		}
		// 	}
		// 	return flag
		// }

		this.godEquipitemRedDot = (equip?) => {
			let flag = true
			let posinfo = this.getGodEquipInfo(equip.cell)
			let level = (posinfo && posinfo.level && (posinfo.level) || (0))
			let conf = this.getGodEquipConf(equip.cell, level)
			let nextConf = this.getGodEquipConf(equip.cell, level + 1)
			if (!nextConf) {
				return false
			}
			//let a = Config.Godequipkv
			//let limit = Config.Godequipkv["strength_limit"]
			//if (limit && limit.value) {
			//	let limitList =  JSON.parse(limit.value)
			let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false)
			if (!this.checkFullPos(equip.cell, equip.color, attr_list.stage, attr_list.star)) {
				return false
			}
			//}
			let materialsList = []
			if (conf && conf.cost) {
				materialsList = JSON.parse(conf.cost)
			} else {
				flag = false
			}
			for (let key in materialsList) {
				let materials = materialsList[key]
				let [type_id, lock] = goods_model.GetMappingTypeId(materials[0], materials[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(local_Number(type_id))
				if (!goods_vo) {
					continue
				}
				let num = goods_model.GetTypeGoodsNum(goods_vo.type_id)
				let needNum = Number(materials[2])
				if (num < needNum) {
					flag = false
					break
				}
			}
			return flag
		}

		this.godEquipRedDot = () => {
			let flag = false
			let lv = role_mgr.GetMainRoleVo().level
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
			if (!cfg) {
				RedDotController.ins.up(RedKey.GOD_EQUIPMENT_BUILD, 0)
				return flag
			}
			let _cfg = cfg["GodEquipBuildView"]
			if (lv < _cfg.open_lv) {
				RedDotController.ins.up(RedKey.GOD_EQUIPMENT_BUILD, 0)
				return flag
			}
			let equipInfos = this.GetWearEquipInfos()
			//let limit = cfg_god_equip_kv && cfg_god_equip_kv["strength_limit"]
			//let limitList = []
			//if (limit && limit.value) {
			//	limitList = JSON.parse(limit.value)
			//} else {
			//	return flag
			//}
			for (let key in equipInfos) {
				let equip = equipInfos[key]
				let attr_list = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false)
				if (!this.checkFullPos(equip.cell, equip.color, attr_list.stage, attr_list.star)) {
					continue
				}
				flag = this.godEquipitemRedDot(equip)
				if (flag) {
					break
				}
			}
			RedDotController.ins.up(RedKey.GOD_EQUIPMENT_BUILD, flag ? 1 : 0)
			return flag
		}

		// this.godEquipAllattr = (equip?, type?) => {
		// 	let attr = ''
		// 	let allAttr = this.getAddAttr(type, equip.cell)
		// 	attr = allAttr / 100 + "%"
		// 	return attr
		// }

		// this.getAddAttr = (type?, pos?) => {
		// 	let allAttr = 0
		// 	let GodEquipInfo = this.getGodEquipInfo(pos)
		// 	let level = (GodEquipInfo && GodEquipInfo.level && (GodEquipInfo.level) || (0))
		// 	let ConfList = this.getGodEquipConfList(pos)
		// 	for (let key in ConfList) {

		// 		let conf = ConfList[key]
		// 		if (((conf && level >= conf.level) && conf.base_attr_add) && conf.base_attr_add != "[]") {
		// 			let attrList =  JSON.parse(conf.base_attr_add)
		// 			for (let key in attrList) {

		// 				let attrInfo = attrList[key]
		// 				if (attrInfo[0] == type) {
		// 					allAttr = allAttr + local_Number(attrInfo[1])
		// 					break
		// 				}
		// 			}
		// 		}
		// 	}
		// 	return allAttr
		// }

		this.checkFullPos = (pos?, color?, stage?, star?) => {
			let limit = this.config_god_pos_limit && this.config_god_pos_limit[pos]
			let limitList = []
			if (limit && limit.limit) {
				limitList = JSON.parse(limit.limit)
			} else {
				return false
			}
			let needStage = Number(limitList[0][1])
			let needStar = Number(limitList[1][1])
			let needColor = Number(limitList[2][1])
			if ((color < needColor || stage < needStage) || star < needStar) {
				return false
			}
			return true
		}

		this.canNotBuildMessage = (cfg_god_pos_limit, pos?) => {
			let str = ""
			let limit = cfg_god_pos_limit && cfg_god_pos_limit[pos]
			let limitList = []
			if (limit && limit.limit) {
				limitList = JSON.parse(limit.limit)
			} else {
				return str
			}
			let needStage = Number(limitList[0][1])
			let needStar = Number(limitList[1][1])
			let needColor = Number(limitList[2][1])
			str = needStage + "阶" + ColorUtil.GetColorName(needColor) + "及以上且至少" + needStar + "星的装备，即可进行神装打造！"
			return str
		}

		this.checkFullAttr = (level?, pos?, stage?) => {
			let flag = true
			let godEquip_cfg = this.config_god_equip_cfg[level]
			if (!godEquip_cfg) {
				return false
			}
			let limit = this.config_god_pos_limit && this.config_god_pos_limit[pos]
			if (!limit && !limit.min) {
				return false
			}
			if (stage < limit.min || stage > godEquip_cfg.max) {
				return false
			}
			return flag
		}

		// this.getRefineAttr = (attr?, refi_lv?, equip_type?) => {
		// 	let str = null
		// 	let suit_type = this.GetSuitType(equip_type)
		// 	let key = refi_lv + "@" + suit_type
		// 	let cfg = Config.Equiprefinement[key]
		// 	if (cfg) {
		// 		let value = attr.attr_val * cfg.promote / 10000
		// 		value = Math.floor(value + 0.5)
		// 		str = "神炼+" + value / 100 + "%"
		// 	} else {
		// 		str = "神炼+0%"
		// 	}
		// 	return str
		// }

		// this.CheckCanRefine = (equip?) => {
		// 	let extra_attr = equip.equip_extra_attr
		// 	let can_refi = false
		// 	let type_id = equip.type_id
		// 	let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false)
		// 	let stage = attr_cfg && attr_cfg.stage
		// 	if ((stage >= local_EquipDefine.REFINEMENT_DIVISION && extra_attr) && extra_attr.length > 0) {
		// 		for (let _tmpi in extra_attr) {
		// 			let v = extra_attr[_tmpi]
		// 			if (v.color >= 4) {
		// 				can_refi = true
		// 				break
		// 			}
		// 		}
		// 	}
		// 	return can_refi
		// }

		// this.canNotBuildMessage = (pos?) => {
		// 	let str = ""
		// 	let limit = Config.Godposlimit && Config.Godposlimit[pos]
		// 	let limitList = []
		// 	if (limit && limit.limit) {
		// 		limitList = local_Erlang.Parse(limit.limit)
		// 	} else {
		// 		return str
		// 	}
		// 	let needStage = Number(limitList[0][1])
		// 	let needStar = Number(limitList[1][1])
		// 	let needColor = Number(limitList[2][1])
		// 	str = needStage + "阶" + ColorUtil.GetColorName(needColor) + "及以上且至少" + needStar + "星的装备，即可进行神装打造！"
		// 	return str
		// }

		// this.checkFullAttr = (level?, pos?, stage?) => {
		// 	let flag = true
		// 	let godEquip_cfg = Config.Godequipcfg[level]
		// 	if (!godEquip_cfg) {
		// 		return false
		// 	}
		// 	let limit = Config.Godposlimit && Config.Godposlimit[pos]
		// 	if (!limit && !limit.min) {
		// 		return false
		// 	}
		// 	if (stage < limit.min || stage > godEquip_cfg.max) {
		// 		return false
		// 	}
		// 	return flag
		// }

		this.getRefineAttr = (attr?, refi_lv?, equip_type?, Equiprefinement?) => {
			let str = null
			let suit_type = this.GetSuitType(equip_type)
			let key = refi_lv + "@" + suit_type
			let cfg = Equiprefinement[key]
			if (cfg) {
				let value = attr.attr_val * cfg.promote / 10000
				value = Math.floor(value + 0.5)
				str = "神炼+" + (value / 100) + "%"
			} else {
				str = "神炼+0%"
			}
			return str
		}

		this.CheckCanRefine = (equip?) => {
			let extra_attr = equip.equip_extra_attr
			let can_refi = false
			let type_id = equip.type_id
			let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, type_id, false)
			let stage = attr_cfg && attr_cfg.stage
			if ((stage >= local_EquipDefine.REFINEMENT_DIVISION && extra_attr) && extra_attr.length > 0) {
				for (let _tmpi in extra_attr) {
					let v = extra_attr[_tmpi]
					if (v.color >= 4) {
						can_refi = true
						break
					}
				}
			}
			return can_refi
		}

		this.checkRefinementRed = () => {
			let equip_infos = this.GetWearEquipDynamics()
			if (!equip_infos || equip_infos.length == 0) {
				return
			}
			if (!common_mgr.CheckFuncOpenState("EquipRefinementView", true)) {
				red_dot_mgr.ClearRedStatus(ModuleType.REFINEMENT_RED)
				return
			}
			ResManager.GetInstance().LoadGameConfig(this, "config_equip_refinement", false, undefined, (cfg) => {
				for (let _tmpi in equip_infos) {
					let vo = equip_infos[_tmpi]
					let extra_attr = vo.equip_extra_attr
					let can_refi = false
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, vo.type_id, false)
					let stage = c && c.stage
					if ((stage && stage >= local_EquipDefine.REFINEMENT_DIVISION && extra_attr) && extra_attr.length > 0) {
						for (let _tmpi in extra_attr) {
							let v = extra_attr[_tmpi]
							if (v.color >= 4) {
								can_refi = true
								break
							}
						}
					}
					let lv = vo.refinement_lv
					if (lv == 0) {
						lv = 1
					} else {
						lv = lv + 1
					}
					if (lv && can_refi) {
						let suit_type = this.GetSuitType(vo.equip_type)
						let refi_cfg = cfg && cfg[lv + "@" + suit_type]
						if (refi_cfg && refi_cfg.cost_list != "[]") {
							let cost = JSON.parse(refi_cfg.cost_list)[0]
							let have_num = goods_model.GetTypeGoodsNum(cost[1])
							red_dot_mgr.SetRedStatus(ModuleType.REFINEMENT_RED, vo.equip_type, have_num >= Number(cost[2]))
							RedDotController.ins.add(RedKey.REFINEMENT_RED + vo.equip_type, RedKey.REFINEMENT_RED);
							RedDotController.ins.up(RedKey.REFINEMENT_RED + vo.equip_type, have_num >= Number(cost[2]) ? 1 : 0)
						} else {
							red_dot_mgr.SetRedStatus(ModuleType.REFINEMENT_RED, vo.equip_type, false)
							RedDotController.ins.add(RedKey.REFINEMENT_RED + vo.equip_type, RedKey.REFINEMENT_RED);
							RedDotController.ins.up(RedKey.REFINEMENT_RED + vo.equip_type, 0)
						}
					} else {
						red_dot_mgr.SetRedStatus(ModuleType.REFINEMENT_RED, vo.equip_type, false)
						RedDotController.ins.add(RedKey.REFINEMENT_RED + vo.equip_type, RedKey.REFINEMENT_RED);
						RedDotController.ins.up(RedKey.REFINEMENT_RED + vo.equip_type, 0)
					}
				}
				this.Fire(local_EquipEvent.UPDATE_REFI_RED)
				local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
				ResManager.GetInstance().DestoryGameConfig(this, "config_equip_refinement", false)
			})
		}


		this.shortExtraAttrColor = (extra_attr?) => {
			if (!extra_attr) {
				return {}
			}
			let sortFunc = (a?, b?) => {
				return b.color < a.color
			}
			table.sort(extra_attr, sortFunc)
			return extra_attr
		}

		// //装备套装
		this.SetSuitData = (data?) => {
			this.suitDataList = {}
			for (let key in data) {
				let value = data[key]
				this.suitDataList[value.equip_type] = value
			}
			for (let i = 1; i <= 10; i++) {
				if (!this.suitDataList[i]) {
					if (Config.GetConfigVo("config_equip_pos2suittype", i, false, this.config_equip_pos2suittype) && Config.GetConfigVo("config_equip_pos2suittype", i, false, this.config_equip_pos2suittype).type == 2) {
						this.suitDataList[i] = { equip_type: i, lv: 1, slv: 0 }
					} else {
						this.suitDataList[i] = { equip_type: i, lv: 0, slv: 0 }
					}
				}
			}
		}

		this.UpdateSuitData = (data?) => {
			if (this.suitDataList) {
				this.suitDataList[data.equip_type] = { equip_type: data.equip_type, lv: data.lv, slv: data.slv }
			}
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_pos2suittype")
			if (cfg) {
				let curType = cfg[data.equip_type].type
				for (let key in cfg) {
					let v = cfg[key]
					if (curType == v.type) {
						let dynamic = this.GetWearEquipDynamic(v.pos)
						if (dynamic) {
							dynamic.suit_list = data.suit_list
						}
					}
				}
			}
			this.Fire(EquipEvent.UPDATE_SUIT_DATA)
		}

		this.GetCurSuitLv = (equip_type?) => {
			return this.suitDataList && this.suitDataList[equip_type].lv || 0
		}

		this.GetCurSuitsLv = (equip_type?) => {
			return this.suitDataList && this.suitDataList[equip_type].slv || 0
		}

		//withCost 是否检测消耗
		//isReplace 是否是替换检测 替换检测是检测是否符合当前的要求
		this.EquipSuitCanUp = (dynamic?, withCost?, isReplace?) => {
			if (!dynamic) {
				return
			}
			let stage = this.GetStageByTypeId(dynamic.type_id)
			let curLv = this.GetCurSuitLv(dynamic.equip_type)
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_suit_make", false)
			let cfg = Config.GetConfigVo("config_equip_suit_make", dynamic.equip_type + "@" + (isReplace && curLv || (curLv + 1)) + "@" + stage, false, config)
			if (!cfg) {
				return false
			}
			if (cfg.condition == "[]" && !withCost) {
				return true
			}
			let dstar = this.GetStarByTypeId(dynamic.type_id)
			let cond = JSON.parse(cfg.condition)
			for (let _tmpi in cond) {
				let info = cond[_tmpi]
				if (info[0] == "stage") {
					if (!this.CompareStage(info[1], stage, Number(info[2]))) {
						return false
					}
				} else if (info[0] == "quality") {
					if (dynamic.color < Number(info[1]) || dstar < Number(info[2])) {
						return false
					}
				} else if (info[0] == "activated") {
					if (curLv < Number(info[2])) {
						return false
					}
				}
			}
			if (withCost) {
				let sex = role_mgr.GetMainRoleVo().sex
				let cost_cfg = JSON.parse(cfg.cost)
				for (let key in cost_cfg) {
					let info = cost_cfg[key]
					if (Number(info[0]) == sex) {
						for (let k in info[1]) {
							let v = info[1][k]
							if (goods_model.GetTypeGoodsNum(v[1]) < Number(v[2])) {
								return false
							}
						}
					}
				}
			}
			return true
		}

		// //withCost 是否检测消耗
		// //replace 是否是替换检测 替换检测是检测是否符合当前的要求
		this.JewelSuitCanUp = (dynamic?, withCost?, isReplace?) => {
			if (!dynamic) {
				return
			}
			let stage = this.GetStageByTypeId(dynamic.type_id)
			let cursLv = this.GetCurSuitsLv(dynamic.equip_type)
			let cfg = Config.GetConfigVo("config_equip_suit_make", dynamic.equip_type + "@1@" + (isReplace && cursLv || cursLv + 1), false, this.config_equip_suit_make)
			if (!cfg) {
				return false
			}
			if (cfg.condition == "[]") {
				return true
			}
			let dstar = this.GetStarByTypeId(dynamic.type_id)
			let cond = JSON.parse(cfg.condition)
			for (let _tmpi in cond) {
				let info = cond[_tmpi]
				if (info[0] == "stage") {
					if (!this.CompareStage(info[1], stage, Number(info[2]))) {
						return false
					}
				} else if (info[0] == "quality") {
					if (dynamic.color < Number(info[1]) || dstar < Number(info[2])) {
						return false
					}
				} else if (info[0] == "activated") {
					if (cursLv < Number(info[2])) {
						return false
					}
				}
			}
			if (withCost) {
				let sex = role_mgr.GetMainRoleVo().sex
				let cost_cfg = JSON.parse(cfg.cost)
				for (let key in cost_cfg) {
					let info = cost_cfg[key]
					if (Number(info[0]) == sex) {
						for (let k in info[1]) {
							let v = info[1][k]
							if (goods_model.GetTypeGoodsNum(v[1]) < Number(v[2])) {
								return false
							}
						}
					}
				}
			}
			return true
		}

		this.GetEquipSuitRed = (equip_type?, lv?) => {
			return this.suitEquipRedList && this.suitEquipRedList[lv] && this.suitEquipRedList[lv][equip_type]
		}

		this.GetJewelSuitRed = (equip_type?) => {
			return this.suitJewelRedList && this.suitJewelRedList[equip_type]
		}
		//装备套装

		this.SetMasterData = (list) => {
			for (let i in list) {
				let info = list[i]
				equip_master_dic[info.type] = info.whole_lv
			}
		}

		this.UpdateMasterData = (type, whole_lv) => {
			equip_master_dic[type] = whole_lv
		}

		this.GetMasterLv = (type) => {
			return equip_master_dic[type]
		}

		this.GetMasterNextLv = (type) => {
			let cur_lv = equip_master_dic[type]

			let cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_whole_reward
			let index = type * 1000
			let data
			while (cfg[index]) {
				data = cfg[index]
				if (cur_lv < data.need_lv) {
					return data.need_lv
				}
				index += 1
			}
			return 0
		}

		this.CheckMasterRed = (type) => {
			let cur_lv = 0
			let next_lv = this.GetMasterNextLv(type)
			if (!next_lv) {
				return false
			}
			if (type == 1) {
				cur_lv = this.GetAllStrenLv()
			} else if (type == 3) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv
				if (!cfg) {
					return false
				}
				cur_lv = this.GetAllJewelLv(cfg)
			}
			RedDotController.ins.add(RedKey.EQUIP_STREN_MASTER + type, RedKey.EQUIP_STREN_MASTER);
			RedDotController.ins.up(RedKey.EQUIP_STREN_MASTER + type, cur_lv >= next_lv ? 1 : 0)
			return cur_lv >= next_lv
		}

		/**
		 * @param not_use_goods 不检测直升卡JEWEL_UP_GOODS
		 */
		this.GetRedDic = (not_use_goods?) => {
			let jewel_lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv;
			let list = this.GetWearEquipDynamics();
			let lv_list = []
			let goods_id_dic = []
			let type_id_dic = []
			let gmodel = goods_model
			let up_goods = not_use_goods?0:gmodel.GetTypeGoodsNum(EquipDefine.JEWEL_UP_GOODS)
			for (let _tmpi in list) {
				let info = list[_tmpi]
				for (let i = 0; i < info.stone_list.length; i++) {
					let stdata = info.stone_list[i]
					let lv_cfg = jewel_lv_cfg[stdata.type_id]
					let basic = gmodel.GetGoodsBasicByTypeId(stdata.type_id)
					if (!lv_list[basic.subtype]) {
						lv_list[basic.subtype] = []
					}
					lv_list[basic.subtype][lv_cfg.lv] = stdata.type_id
					if (up_goods > 0 && lv_cfg.next_lv_stone != 0) {
						goods_id_dic[info.goods_id] = true
						type_id_dic[stdata.type_id] = true
					}
				}
			}
			for (let sublist of lv_list) {
				let red = null
				let lv = null
				if (sublist) {
					for (let i in sublist) {
						let type_id = sublist[i]
						if (type_id) {
							red = this.CheckWearJewelUpgradeByTypeId(type_id, jewel_lv_cfg)
							if (red) {
								lv = i
								break
							}
						}
					}
					if (lv != null && lv > 0) {
						type_id_dic[sublist[lv]] = true
					}
				}
			}

			for (let type_id in type_id_dic) {
				for (let _tmpi in list) {
					let info = list[_tmpi]
					for (let _tmpi in info.stone_list) {
						let stone = info.stone_list[_tmpi]
						if (stone.type_id == type_id) {
							goods_id_dic[info.goods_id] = true
							break
						}
					}
				}
			}
			return [type_id_dic, goods_id_dic]; // type_id_dic宝石位红点 goods_id_dic装备位红点
		}
	}

	/**
	 * 该物品是否穿戴
	 * @param goodsId 商品唯一id
	 * @returns 
	 */
	public GetIsWearByGoodsId(goodsId: number) {
		return Boolean(GoodsModel.GetInstance().GetEquipById(goodsId))
	}

	public static GetInstance(): EquipModel {
		if (!EquipModel.Instance) {
			EquipModel.Instance = new EquipModel()
		}
		return EquipModel.Instance
	}
}
window["EquipModel"] = EquipModel