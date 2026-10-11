import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleManager } from "./RoleManager"
import { EquipModel } from "./EquipModel"
import { GoodsModel } from "./GoodsModel"
import { CommonManager } from "../common/CommonManager"
import { longlangModel } from "./longlangModel"
import { ErlangParser } from "../util/ErlangParser"
import { RuneModel } from "./RuneModel"
import { GuardModel } from "./GuardModel"
import { MainFunc } from "./MainUIModel"
import { GodBeastModel } from "./GodBeastModel"
import { ResManager } from "../common/ResManager"
import { HolySealModel } from "./HolySealModel"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { GodCourtModel } from "./GodCourtModel"
import { CookieWrapper } from "../common/CookieWrapper"
import { PlatformManager } from "../PlatformManager"

export enum MatViewType {
	EQUIP = 0,
	RING = 1,
	RINGUP = 2
}
export enum CompositeEvent {
	REQUEST_PROTO = "CompositeEvent.REQUEST_PROTO",
	SELECT_COMP_EQUIP_MAT = "CompositeEvent.SELECT_COMP_EQUIP",
	COMPOSITE_MAT_VIEW_OPEN = "CompositeEvent.COMPOSITE_MAT_VIEW_OPEN",
	COMPOSITE_MAT_VIEW_CLOSE = "CompositeEvent.COMPOSITE_MAT_VIEW_CLOSE",
	REFRESH_MSG_AFTER_SELECT = "CompositeEvent.REFRESH_MSG_AFTER_SELECT",
	CLICK_MAT_TO_COMP_BTN = "CompositeEvent.CLICK_MAT_TO_COMP_BTN",
	CLICK_MAT_TO_MAT_POS = "CompositeEvent.CLICK_MAT_TO_MAT_POS",
	MARK_OPEN_MAT_POS_TYPE = "CompositeEvent.MARK_OPEN_MAT_POS_TYPE",
	OPEN_VIEW = "CompositeEvent.OPEN_VIEW",
	SELECT_RUNE_GOODS = "CompositeEvent.SELECT_RUNE_GOODS",
	COMPOSE_SUCCESS = "CompositeEvent.COMPOSE_SUCCESS",
	SELECT_EQUIP_GOODS = "CompositeEvent.SELECT_EQUIP_GOODS",
	SELECT_GODBEAST_GOODS = "CompositeEvent.SELECT_GODBEAST_GOODS",
	SELECT_RING_GOODS = "CompositeEvent.SELECT_RING_GOODS",
	SELECT_RING_UP_GOODS = "CompositeEvent.SELECT_RING_UP_GOODS",
	COMPOSE_Fail = "CompositeEvent.COMPOSE_Fail",
	SELECT_SOUL_GOODS = "CompositeEvent.SELECT_SOUL_GOODS",
	TAKE_OUT_SOUL_GOODS = "CompositeEvent.TAKE_OUT_SOUL_GOODS",
	SELECT_GOD_GOODS = "CompositeEvent.SELECT_GOD_GOODS",
	SELECT_UNREAL_GOODS = "CompositeEvent.SELECT_UNREAL_GOODS",
	UNINSTALL_UNREAL = "CompositeEvent.UNINSTALL_UNREAL",
	SELECT_EQUIP_RESOLVE_ITEM = "CompositeEvent.SELECT_EQUIP_RESOLVE_ITEM",
	GOODS_COMPOSE = "CE1",
	BABY_SELECT_GOODS = "CE2",
	RED_EQUIP_OPEN_VIEW = "CE3",
	OPEN_RED_VIEW = "OPEN_RED_VIEW"
}
window["MatViewType"] = MatViewType
window["CompositeEvent"] = CompositeEvent
/*
CompositeDefine {
	EQUIP_MATERIAL_POS : [0, 1, 2, 3, 4]
}
*/

export class CompositeModel extends EventDispatcher {
	CanCompose
	CheckSoulColorCompose
	DelRuneComposeAwake
	DelSoulComposeAwake
	EquipCanComposite
	GetSexByEquipCompositeRuid
	EquipTabCanCom
	GetAllMatList
	GetBeastReddot
	GetCanSelectEquip
	GetEquipCompositeList
	GetEquipRedDot
	GetGodBeastCompositeList
	GetGodBeastSubRedDot
	GetGodCompositeList
	GetGodCourtRed
	GetGodReddot
	GetGodSubRedDot
	GetGoodsComposeNameList
	GetGoodsRedDot
	GetGuardComposeNameList
	GetGuardRedDot
	GetHolySealComposeNameList
	GetHolySealRedDot
	GetLonglangComposeNameList
	GetLonglangRedDot
	GetRevelationComposeNameList
	GetRevelationRedDot
	GetRingComposeData
	GetRingCompositeList
	GetRingList
	GetRingSubRedDot
	GetRingUpgradeComposeData
	GetRingUpgradeSubRedDot
	GetRuneComposeData
	GetSoulComposeData
	GetSoulRedDot
	GetSubRedDot
	GetTabBarData
	GetTabIdList
	GetUnrealComposeNameList
	GetUnrealCompositeList
	GetUnrealRedDot
	GodBeastCanCompose
	GodBeastReddot
	GodReddot
	InitBabyTabIdList
	InitEquipTab
	InitGoodsTabIdList
	InitGuardTabIdList
	InitHolySealTabIdList
	InitLonglangTabIdList
	InitRevelationList
	InitSoulTabIdList
	InitUnrallTabIdList
	IsRuneCanCompose
	ReSetRuneComposeAwake
	ReSetSoulComposeAwake
	RefreshBabyRedDot
	RefreshGoodsRedDot
	RefreshGuardRedDot
	RefreshHolySealRedDot
	RefreshLonglangRedDot
	RefreshRevelationRedDot
	RefreshShowRed
	RefreshSoulRedDot
	RefreshUnrealRedDot
	ResCfg
	RingCanComposite
	RingReddot
	RingUpgradeReddot
	RuneComposeAwakeList
	RuneComposeRedDot
	SaveRuneComposeAwake
	SaveSoulComposeAwake
	SoulComposeAwakeList
	UnrealCanCompose
	UpdateEquipRed
	_SaveSoulComposeAwake
	babySelectedEquipArray
	babySelectedEquipList
	babyTabIdList
	checkWearEquip
	compEquip_regular_glist
	compEquip_specify_glist
	compGodBeast_regular_glist
	compGodBeast_specify_glist
	compGod_regular_glist
	compGod_specify_glist
	cur_wear_equip_list
	equip_red_list
	equip_tab_id_list
	equip_tab_list
	equipment_mat_list
	godCourtComRed
	god_mat_list
	god_need_list
	god_red_dot
	godbeast_mat_list
	godbeast_need_list
	godbeast_red_dot
	goods_red_dot
	goods_tab_id_list
	guard_red_dot
	guard_tab_id_list
	holy_seal_red_dot
	holy_seal_tab_id_list
	isRedShowRed
	isShowRed
	lifeSkillAdd
	longlang_red_dot
	longlang_tab_id_list
	need_goods_list
	revelation_red_dot
	revelation_tab_id_list
	ring_mat_list
	ring_one_key_red_list
	ring_up_mat_list
	ring_up_one_key_red_list
	rune_red_dot
	selected_equip_list
	selected_god_list
	selected_godbeast_list
	selected_ring_list
	selected_ring_up_list
	selected_unreal_list
	soul_red_dot
	soul_select_goodsId
	soul_select_index
	unreal_mat_list
	unreal_need_list
	unreal_red_dot
	unreal_tab_id_list
	babyComRed
	equip_red_dot
	ring_red_dot
	ring_upgrade_red_dot 

	public static OPEN_CHOSE_EQUIPMENT_VIEW = "CompositeModel.OPEN_CHOSE_EQUIPMENT_VIEW"
	public static COLSE_CHOSE_EQUIPMENT_VIEW = "CompositeModel.COLSE_CHOSE_EQUIPMENT_VIEW"
	public static OPEN_CHOSE_GODBEAST_VIEW = "CompositeModel.OPEN_CHOSE_GODBEAST_VIEW"
	public static OPEN_CHOSE_UNREAL_VIEW = "CompositeModel.OPEN_CHOSE_UNREAL_VIEW"
	public static CLOSE_CHOSE_GODBEAST_VIEW = "CompositeModel.CLOSE_CHOSE_GODBEAST_VIEW"
	public static UPDATA_SUCCESS_RATIO = "CompositeModel.UPDATA_SUCCESS_RATIO"
	public static UPDATA_GODBEAST_SUCCESS_RATIO = "CompositeModel.UPDATA_GODBEAST_SUCCESS_RATIO"
	public static UPDATA_GOD_SUCCESS_RATIO = "CompositeModel.UPDATA_GOD_SUCCESS_RATIO"
	public static UNINSTALL_EQUIP = "CompositeModel.UNINSTALL_EQUIP"
	public static OPEN_COMPOSITE_VIEW = "CompositeModel.OPEN_COMPOSITE_VIEW"
	public static OPEN_CHOSE_GOD_VIEW = "CompositeModel.OPEN_CHOSE_GOD_VIEW"
	public static CLOSE_CHOSE_GOD_VIEW = "CompositeModel.CLOSE_CHOSE_GOD_VIEW"
	public static OPEN_BABY_COM_SELECT = "CompositeModel.OPEN_BABY_COM_SELECT"
	public static UNINSTALL_BABY_EQUIP = "CompositeModel.UNINSTALL_BABY_EQUIP"
	public static OPEN_COMPOSITE_ENTER_VIEW = "CompositeModel.OPEN_COMPOSITE_ENTER_VIEW"
	public static SELECT_GOD_EQUIP = "SELECT_GOD_EQUIP"
	public static UPDATE_EQUIP_RED = "UPDATE_EQUIP_RED"
	public static UPDATE_COMPOSE_RED = "UPDATE_COMPOSE_RED"

	public static selectMatView_isOpen = false
	public static EquipmentResolveRuleSubTabId = 710000
	public static HolySealComposeRule = 80
	public static EquipmentComposeRule = 1000
	public static RuneComposeRule = 3000
	public static SoulComposeRule = 4000
	public static UnrealComposeRule = 5000
	public static GodBeastcomposeRule = 6000
	public static EquipmentResolveRule = 7000
	public static RingComposeRuleRule = 9000
	public static RingUpgradeRuleRule = 10000
	public static GoodsComRule = 2000
	public static GodcomposeRule = 8000
	public static BabyEquipRule = 15000
	public static RevelationComposeRule = 72
	public static GuardComposeRule = 26000
	public static LonglangRule = 7700
	public static Index = {
		Goods: 0,
		Rune: 1,
		HolySeal: 2,
		//Soul=4,
		GodBeast: 3,
		Unreal: 4,
		God: 5,
		//Baby=8,
		Revelation: 6,
		Guard: 7,
		GodCourt: 8,
		Longlang: 9
	}
	static Instance: CompositeModel

	public constructor() {
		super()
		if (CompositeModel.Instance) {
			return
		}

		this.compEquip_regular_glist = [];
		this.compEquip_specify_glist = [];
		this.selected_equip_list = {}
		this.equipment_mat_list = {}
		this.cur_wear_equip_list = [];
		this.need_goods_list = [];
		this.godbeast_need_list = [];
		this.selected_godbeast_list = [];
		this.godbeast_mat_list = [];
		this.compGodBeast_regular_glist = [];
		this.compGodBeast_specify_glist = [];
		this.god_need_list = [];
		this.selected_god_list = [];
		this.god_mat_list = [];
		this.compGod_regular_glist = [];
		this.compGod_specify_glist = [];
		this.unreal_need_list = [];
		this.selected_unreal_list = [];
		this.unreal_mat_list = [];
		this.selected_ring_list = {}
		this.ring_mat_list = {}
		this.selected_ring_up_list = {}
		this.ring_up_mat_list = {}
		this.babySelectedEquipArray = [];
		this.babySelectedEquipList = [];
		this.lifeSkillAdd = 0;
		this.soul_select_index = 0;
		this.soul_select_goodsId = [];
		this.unreal_red_dot = false;
		this.soul_red_dot = false;
		this.holy_seal_red_dot = false;
		this.longlang_red_dot = false;
		this.revelation_red_dot = false;
		this.godbeast_red_dot = false;
		this.god_red_dot = false;
		this.goods_red_dot = false;
		this.guard_red_dot = false;
		this.godCourtComRed = false;
		this.ring_one_key_red_list = [];
		this.ring_up_one_key_red_list = [];
		this._SaveSoulComposeAwake = [];
		this.rune_red_dot = false
		//装备合成红点list[{{ }]}
		this.equip_red_list = {}
		this.equip_tab_id_list = []
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let equip_model = EquipModel.GetInstance()
		let local_CompositeModel = CompositeModel
		let common_mgr = CommonManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let long_lang_model = longlangModel.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let total_mat_list_ = []
		let ring_total_list_ = null
		let god_total_list_ = null
		let unreal_tab_id_obj_ = null
		let soul_tab_id_list_ = null
		let soul_tab_id_obj_ = null
		let holy_seal_tab_id_obj_ = null
		let longlang_tab_id_obj_ = null
		let goods_tab_id_obj_ = null
		let revelation_tab_id_obj_ = null
		let guard_tab_id_obj_ = null
		let rune_compose_tab_id_and_anme_list_ = null
		let _SaveRuneComposeAwake_ = []
		this.ResCfg = () => {
		}

		this.GetRuneComposeData = (config_compose_menu, config_compose_menu_id) => {
			if (!rune_compose_tab_id_and_anme_list_) {
				let tab_bar_id_list = []
				let bar = null
				let tab_bar_name_list = []
				let bar_name = null
				//let Composemenu = local_Config.Composemenu
				//let Composemenuid = local_Config.Composemenuid
				let Composemenu = config_compose_menu
				let Composemenuid = config_compose_menu_id
				let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
				if ((Composemenu && Composemenuid) && Goodscompose) {
					// [ts2lua]Composemenu下标访问可能不正确
					let menu_cfg = Composemenu[local_CompositeModel.RuneComposeRule]
					let sub_menu_cfg = null
					let menu_id_cfg = null
					let goods_cfg = null
					if (menu_cfg) {
						let menu_list = erlang_parser.Parse(menu_cfg.list)
						let sub_menu_list = null
						if (menu_list) {
							for (let _tmpi in menu_list) {
								let obj = menu_list[_tmpi]
								bar = []
								bar[0] = obj
								bar[1] = []
								menu_id_cfg = Composemenuid[Number(obj)]
								if (menu_id_cfg) {
									bar_name = []
									bar_name[0] = menu_id_cfg.name
									bar_name[1] = []
								}
								sub_menu_cfg = Composemenu[Number(obj)]
								if (sub_menu_cfg) {
									sub_menu_list = erlang_parser.Parse(sub_menu_cfg.list)
									for (let _tmpi in sub_menu_list) {
										let sub = sub_menu_list[_tmpi]
										table.insert(bar[1], Number(sub))
										goods_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, Number(sub), false, Goodscompose)
										if (goods_cfg) {
											table.insert(bar_name[1], goods_cfg.name)
										}
									}
								}
								table.insert(tab_bar_id_list, bar)
								table.insert(tab_bar_name_list, bar_name)
							}
						}
					}
				}
				let result = []
				result[0] = tab_bar_id_list
				result[1] = tab_bar_name_list
				rune_compose_tab_id_and_anme_list_ = result
			}
			return rune_compose_tab_id_and_anme_list_
		}

		this.GetSoulComposeData = (config_compose_menu, config_compose_menu_id) => {
			let tab_bar_id_list = []
			let bar = null
			let tab_bar_name_list = []
			let bar_name = null
			let Composemenu = config_compose_menu
			let Composemenuid = config_compose_menu_id
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			if ((Composemenu && Composemenuid) && Goodscompose) {
				let menu_cfg = Composemenu[local_CompositeModel.SoulComposeRule]
				let sub_menu_cfg = null
				let menu_id_cfg = null
				let goods_cfg = null
				if (menu_cfg) {
					let menu_list = erlang_parser.Parse(menu_cfg.list)
					let sub_menu_list = null
					if (menu_list) {
						for (let _tmpi in menu_list) {
							let obj = menu_list[_tmpi]
							bar = []
							bar[0] = obj
							bar[1] = []
							menu_id_cfg = Composemenuid[obj]
							if (menu_id_cfg) {
								bar_name = []
								bar_name[0] = menu_id_cfg.name
								bar_name[1] = []
							}
							sub_menu_cfg = Composemenu[obj]
							if (sub_menu_cfg) {
								sub_menu_list = erlang_parser.Parse(sub_menu_cfg.list)
								for (let _tmpi in sub_menu_list) {
									let sub = sub_menu_list[_tmpi]
									table.insert(bar[1], sub)
									goods_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, sub, false, Goodscompose)
									if (goods_cfg) {
										table.insert(bar_name[1], goods_cfg.name)
									}
								}
							}
							table.insert(tab_bar_id_list, bar)
							table.insert(tab_bar_name_list, bar_name)
						}
					}
				}
			}
			let result = []
			result[0] = tab_bar_id_list
			result[1] = tab_bar_name_list
			return result
		}

		this.GetRingComposeData = (config_compose_menu, config_compose_menu_id) => {
			let tab_bar_id_list = []
			let bar = null
			let tab_bar_name_list = []
			let tab_bar_icon_list = []
			let bar_name = null
			let Composemenu = config_compose_menu
			let Composemenuid = config_compose_menu_id
			if (Composemenu && Composemenuid) {
				let menu_cfg = Composemenu[local_CompositeModel.RingComposeRuleRule]
				let sub_menu_cfg = null
				let menu_id_cfg = null
				if (menu_cfg) {
					let menu_list = erlang_parser.Parse(menu_cfg.list)
					let sub_menu_list = null
					if (menu_list) {
						for (let _tmpi in menu_list) {
							let obj = menu_list[_tmpi]
							bar = []
							let fir_tab_data = Composemenuid[obj]
							if (fir_tab_data && role_mgr.mainRoleInfo.level >= fir_tab_data.open_lv) {
								bar_name = []
								bar_name[0] = fir_tab_data.name
								bar_name[1] = []
								menu_id_cfg = Composemenu[obj]
								if (menu_id_cfg) {
									table.insert(tab_bar_icon_list, obj)
									let sec_list = erlang_parser.Parse(menu_id_cfg.list)
									if (sec_list) {
										for (let _tmpi in sec_list) {
											let sec_obj = sec_list[_tmpi]
											let sec_data = Composemenuid[sec_obj]
											if (sec_data && role_mgr.mainRoleInfo.level >= sec_data.open_lv) {
												table.insert(bar, sec_obj)
												table.insert(bar_name[1], sec_data.name)
											}
										}
									}
									table.insert(tab_bar_id_list, bar)
									table.insert(tab_bar_name_list, bar_name)
								}
							}
						}
					}
				}
				let result = []
				result[0] = tab_bar_id_list
				result[1] = tab_bar_name_list
				result[2] = tab_bar_icon_list
				return result
			}
		}

		this.GetRingUpgradeComposeData = (config_compose_menu, config_compose_menu_id) => {
			let tab_bar_id_list = []
			let bar = null
			let tab_bar_name_list = []
			let tab_bar_icon_list = []
			let bar_name = null
			let Composemenu = config_compose_menu
			let Composemenuid = config_compose_menu_id
			if (Composemenu && Composemenuid) {
				let menu_cfg = Composemenu[local_CompositeModel.RingUpgradeRuleRule]
				let sub_menu_cfg = null
				let menu_id_cfg = null
				if (menu_cfg) {
					let menu_list = erlang_parser.Parse(menu_cfg.list)
					let sub_menu_list = null
					if (menu_list) {
						for (let _tmpi in menu_list) {
							let obj = menu_list[_tmpi]
							bar = []
							let fir_tab_data = Composemenuid[obj]
							if (fir_tab_data && role_mgr.mainRoleInfo.level >= fir_tab_data.open_lv) {
								bar_name = []
								bar_name[0] = fir_tab_data.name
								bar_name[1] = []
								menu_id_cfg = Composemenu[obj]
								if (menu_id_cfg) {
									table.insert(tab_bar_icon_list, obj)
									let sec_list = erlang_parser.Parse(menu_id_cfg.list)
									if (sec_list) {
										for (let _tmpi in sec_list) {
											let sec_obj = sec_list[_tmpi]
											let sec_data = Composemenuid[sec_obj]
											if (sec_data && role_mgr.mainRoleInfo.level >= sec_data.open_lv) {
												table.insert(bar, sec_obj)
												table.insert(bar_name[1], sec_data.name)
											}
										}
									}
									table.insert(tab_bar_id_list, bar)
									table.insert(tab_bar_name_list, bar_name)
								}
							}
						}
					}
				}
				let result = []
				result[0] = tab_bar_id_list
				result[1] = tab_bar_name_list
				result[2] = tab_bar_icon_list
				return result
			}
		}

		this.GetRingList = (config_compose_menu, id?) => {
			let list = []
			let cfgList = []
			id = Number(id)
			let conf = config_compose_menu[id]
			if (conf) {
				let confList = erlang_parser.Parse(conf.list)
				for (let key in confList) {
					let id = Number(confList[key])
					let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
					let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, id, false, Goodscompose)
					table.insert(cfgList, cfg)
					let goods_cfg = erlang_parser.Parse(cfg.goods)
					table.insert(list, goods_cfg)
				}
			}
			return [cfgList, list]
		}

		this.GetEquipCompositeList = (type_list?, chose_count?) => {
			let can_select_list = []
			let list = []
			let total_count = 0
			let flag = false
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let goods = goods_model.GetTypeGoods(Number(type_id))
				if (goods && !Util.IsTableEmpty(goods)) {
					table.insert(list, goods)
				}
			}
			let sortFunc = (a?, b?) => {
				if (a.length > b.length) {
					return true
				}
			}
			table.sort(list, sortFunc)

			if (list.length > 0) {
				let i = 0
				do {
					for (let index in list[i]) {
						flag = false
						let goods_id = list[i][index].goods_id
						for (let index in this.selected_equip_list) {
							if (this.selected_equip_list[index] == goods_id) {
								flag = true
								break
							}
						}
						if (!flag) {
							for (let index in this.equipment_mat_list) {
								if (this.equipment_mat_list[index] == goods_id) {
									flag = true
									break
								}
							}
							if (!flag) {
								total_count = total_count + 1
								table.insert(can_select_list, list[i][index])
								if (chose_count && can_select_list.length >= chose_count) {
									return can_select_list
								}
							}
						}
					}
					i = i + 1
				} while ((i < list.length))
			}
			return can_select_list
		}

		this.GetGodBeastCompositeList = (type_list?) => {
			ring_total_list_ = []
			let list = []
			let item = null
			let total_count = 0
			let flag = false
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let goods = goods_model.GetTypeGoods(Number(type_id))
				if (goods && goods.length > 0) {
					table.insert(list, goods)
				}
			}
			let sortFunc = (a?, b?) => {
				if (a.length != b.length) {
					return a.length > b.length
				}
				return false
			}
			table.sort(list, sortFunc)

			if (list.length > 0) {
				let i = 0
				do {
					for (let index in list[i]) {
						flag = false
						let goods_id = list[i][index].goods_id
						for (let index in this.selected_godbeast_list) {
							if (this.selected_godbeast_list[index] == goods_id) {
								flag = true
							}
						}
						if (!flag && (!GodBeastModel.GetInstance().GetWearEquipInfo(goods_id))) {
							table.insert(ring_total_list_, list[i][index])
						}
					}
					i = i + 1
				} while ((i < list.length))
			}
			return ring_total_list_
		}

		this.GetGodCompositeList = (type_list?) => {
			god_total_list_ = []
			let list = []
			let item = null
			let total_count = 0
			let flag = false
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let goods = goods_model.GetTypeGoods(Number(type_id))
				if (goods) {
					table.insert(list, goods)
				}
			}
			let sortFunc = (a?, b?) => {
				if (a.length > b.length) {
					return true
				}
			}
			table.sort(list, sortFunc)

			if (list.length > 0) {
				let i = 0
				do {
					for (let index in list[i]) {
						flag = false
						let goods_id = list[i][index].goods_id
						for (let index in this.selected_god_list) {
							if (this.selected_god_list[index] == goods_id) {
								flag = true
							}
						}
						if (!flag) {
							table.insert(god_total_list_, list[i][index])
						}
					}
					i = i + 1
				} while ((i < list.length))
			}
			return god_total_list_
		}

		this.GetUnrealCompositeList = (cond?, pos?) => {
			let list = []
			let item = null
			let total_count = 0
			let flag = false
			let type_list = cond && cond[pos]
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let goods_list = goods_model.GetTypeGoods(Number(type_id))
				if (goods_list && goods_list.length > 0) {
					for (let _tmpi in goods_list) {
						let vo = goods_list[_tmpi]
						if (vo) {
							flag = false
							for (let index in this.selected_unreal_list) {
								if (this.selected_unreal_list[index] == vo.goods_id) {
									flag = true
								}
							}
							if (!flag) {
								table.insert(list, vo)
							}
						}
					}
				}
			}
			return list
		}

		this.GetRingCompositeList = (type_list?, selectList?, matlist?) => {
			let ring_total_list = []
			let list = []
			let total_count = 0
			let flag = false
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let typeId = Number(type_id)
				let equipList = equip_model.GetWearEquipInfos()
				for (let key in equipList) {
					let equip = equipList[key]
					if (equip.type_id == typeId) {
						table.insert(list, { equip })
						break
					}
				}
				let goods = goods_model.GetTypeGoods(typeId)
				if (goods) {
					table.insert(list, goods)
				}
			}
			//let sortFunc = (a?, b?) => {
			//if (a.length > b.length ) {
			//return true
			//}
			//}
			//table.sort(list,sortFunc)

			if (list.length > 0) {
				let i = 0
				do {
					for (let index in list[i]) {
						flag = false
						let goods_id = list[i][index].goods_id
						for (let index in selectList) {
							if (selectList[index] == goods_id) {
								flag = true
								break
							}
						}
						if (!flag) {
							for (let index in matlist) {
								if (matlist[index] == goods_id) {
									flag = true
									break
								}
							}
							if (!flag) {
								total_count = total_count + 1
								table.insert(ring_total_list, list[i][index])
							}
						}
					}
					i = i + 1
				} while ((i < list.length))
			}
			return ring_total_list
		}

		//根据和策划的约定，配置的规则ID倒数第三位未性别
		this.GetSexByEquipCompositeRuid = (rule_id) =>{
			if(!rule_id) return [false, 0]
			rule_id = String(rule_id)
			return rule_id.substring(rule_id.length - 3, rule_id.length - 2)
		}
		
		//checkExtra 是否检查备注中的合成Id，为了实现不同材料合成同一个道具 在合成配置的备注字段中添加了另一个合成id
		//getRedType  是否获取红点类型  如果为true 则会返回 是否可合成,红点类型（1第一个可合成 2 第二个可合成 3 都可合成）
		this.EquipCanComposite = (rule_id?, checkExtra?, getRedType?) => {
			if (rule_id) {
				rule_id = Number(rule_id)
				let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false, Goodscompose)
				if (cfg) {
					if (cfg.sex == role_mgr.mainRoleInfo.sex || cfg.sex == 0) {

						//如果合成规则没有性别的要求
						if(cfg.sex == 0){
							//装备合成，如果合成物是护符(equip_type=5) 项链 (equip_type=3) 只在和自己性别一致的Tab内显示红点
							let goods = ErlangParser.GetInstance().Parse(cfg.goods)[0]
							let basic = goods_model.GetGoodsBasicByTypeId(goods[1])
							if(basic.equip_type == 5 || basic.equip_type == 3){
								let sex = this.GetSexByEquipCompositeRuid(rule_id)
								if(sex != role_mgr.mainRoleInfo.sex){
									return [false ,0]
								}
							}
						}
						let regular_list = erlang_parser.Parse(cfg.regular_mat)
						let need_count = 0
						let now_count = null
						let eliminate_list = []
						let brreak_flag
						for (let _tmpi in regular_list) {
							let regular_data = regular_list[_tmpi]
							let can_compose = false
							for (let _tmpi in regular_data) {
								let Vo = regular_data[_tmpi]
								now_count = goods_model.GetTypeGoodsNum(Vo[1])
								if (now_count) {
									if (eliminate_list[Vo[1]]) {
										now_count = now_count - eliminate_list[Vo[1]]
									}
									if (now_count >= Number(Vo[2])) {
										if (!eliminate_list[Vo[1]]) {
											eliminate_list[Vo[1]] = 0
										}
										eliminate_list[Vo[1]] = eliminate_list[Vo[1]] + Number(Vo[2])
										can_compose = true
										break
									}
								}
							}
							if (!can_compose) {
								brreak_flag = true
								break
							}
						}
						if (!brreak_flag) {
							if (cfg.ratio_type == 2) {
								let ratio_cfg = erlang_parser.Parse(cfg.ratio)
								for (let _tmpi in ratio_cfg) {
									let Vo = ratio_cfg[_tmpi]
									if (Number(Vo[1]) > 0) {
										need_count = Number(Vo[0])
										break
									}
								}
								let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
								if (irregular_list && irregular_list.length > 0) {
									for (let _tmpi in irregular_list[0]) {
										let Vo = irregular_list[0][_tmpi]
										now_count = goods_model.GetTypeGoodsNum(Vo)
										if (eliminate_list[Vo]) {
											now_count = now_count - eliminate_list[Vo]
										}
										if (now_count >= 1) {
											if (!eliminate_list[Vo]) {
												eliminate_list[Vo] = 0
											}
											eliminate_list[Vo] = eliminate_list[Vo] + now_count
											need_count = need_count - now_count
											if (need_count <= 0) {
												if (getRedType && typeof (cfg.extra) == "number") {
													let ans = this.EquipCanComposite(cfg.extra)
													if (ans[0]) {
														return [true, 3]
													} else {
														return [true, 1]
													}
												} else {
													return [true, 0]
												}
											}
										}
									}
								}
							} else if (cfg.ratio_type == 1) {
								let ratio_cfg = erlang_parser.Parse(cfg.ratio)
								if (ratio_cfg == 100) {
									if (getRedType && typeof (cfg.extra) == "number") {
										let ans = this.EquipCanComposite(cfg.extra)
										if (ans[0]) {
											return [true, 3]
										} else {
											return [true, 1]
										}
									} else {
										return [true, 0]
									}
								}
							}
						}
						if (checkExtra && cfg.extra) {
							let ans = this.EquipCanComposite(cfg.extra)
							return [ans[0], 2]
						}
					}
				}
			}
			return [false, 0]
		}

		this.RingCanComposite = (rule_id?) => {
			let can_com = false
			if (rule_id) {
				rule_id = Number(rule_id)
				let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false, Goodscompose)
				if (cfg) {
					if (cfg.sex == role_mgr.mainRoleInfo.sex || cfg.sex == 0) {
						let regular_list = cfg.er_regular_mat
						if (!regular_list) {
							regular_list = erlang_parser.Parse(cfg.regular_mat)
							cfg.er_regular_mat = regular_list
						}
						let need_count = 0
						let now_count = null
						let eliminate_list = []
						let type_id = 0
						for (let _tmpi in regular_list) {
							let regular_data = regular_list[_tmpi]
							let can_compose = false
							for (let _tmpi in regular_data) {
								let Vo = regular_data[_tmpi]
								type_id = Number(Vo[1])
								now_count = goods_model.GetTypeGoodsNum(type_id)
								let equipList = equip_model.GetWearEquipInfos()
								//for (let key in equipList) {
								// [ts2lua]equipList下标访问可能不正确
								//let equip = equipList[key]
								if (equipList && ((equipList[7] && equipList[7].type_id == type_id) || (equipList[9] && equipList[9].type_id == type_id))) {
									now_count = now_count + 1
									//break
								}
								//}
								if (now_count > 0) {
									// [ts2lua]eliminate_list下标访问可能不正确
									if (eliminate_list[type_id]) {
										// [ts2lua]eliminate_list下标访问可能不正确
										now_count = now_count - eliminate_list[type_id]
									}
									if (now_count >= Number(Vo[2])) {
										// [ts2lua]eliminate_list下标访问可能不正确
										if (!eliminate_list[type_id]) {
											// [ts2lua]eliminate_list下标访问可能不正确
											eliminate_list[type_id] = 0
										}
										// [ts2lua]eliminate_list下标访问可能不正确
										// [ts2lua]eliminate_list下标访问可能不正确
										eliminate_list[type_id] = eliminate_list[type_id] + Number(Vo[2])
										can_compose = true
										break
									}
								}
							}
							if (!can_compose) {
								return false
							}
						}
						if (cfg.ratio_type == 2) {
							let ratio_cfg = cfg.er_ratio
							if (!ratio_cfg) {
								ratio_cfg = erlang_parser.Parse(cfg.ratio)
								cfg.er_ratio = ratio_cfg
							}
							for (let _tmpi in ratio_cfg) {
								let Vo = ratio_cfg[_tmpi]
								if (Vo[1] == 100) {
									need_count = Vo[0]
									break
								}
							}
							let irregular_list = cfg.er_irregular_mat
							if (!irregular_list) {
								irregular_list = erlang_parser.Parse(cfg.irregular_mat)
								cfg.er_irregular_mat = irregular_list
							}
							if (irregular_list) {
								for (let _tmpi in irregular_list) {
									let pos_data = irregular_list[_tmpi]
									let have_goods = false
									for (let _tmpi in pos_data) {
										let Vo = pos_data[_tmpi]
										now_count = goods_model.GetTypeGoodsNum(Vo)
										let equipList = equip_model.GetWearEquipInfos()
										for (let key in equipList) {
											// [ts2lua]equipList下标访问可能不正确
											let equip = equipList[key]
											if (equip.type_id == Vo) {
												now_count = now_count + 1
												break
											}
										}
										// [ts2lua]eliminate_list下标访问可能不正确
										if (eliminate_list[Vo]) {
											// [ts2lua]eliminate_list下标访问可能不正确
											now_count = now_count - eliminate_list[Vo]
										}
										if (now_count >= 1) {
											// [ts2lua]eliminate_list下标访问可能不正确
											if (!eliminate_list[Vo]) {
												// [ts2lua]eliminate_list下标访问可能不正确
												eliminate_list[Vo] = 0
											}
											// [ts2lua]eliminate_list下标访问可能不正确
											// [ts2lua]eliminate_list下标访问可能不正确
											eliminate_list[Vo] = eliminate_list[Vo] + 1
											have_goods = true
											break
										}
									}
									if (!have_goods) {
										return false
									}
								}
								return true
							}
						} else if (cfg.ratio_type == 1) {
							//let ratio_cfg = cfg.ratio
							if (cfg.ratio == 100) {
								return true
							}
						}
					}
				}
			}
			return false
		}

		this.GetSubRedDot = (config_compose_menu, callback?) => {
			if (!config_compose_menu) {
				return
			}
			let result_list = []
			let menu_cfg = config_compose_menu[local_CompositeModel.EquipmentComposeRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				let role_lv = role_mgr.mainRoleInfo.level
				if (menu_list) {
					let menu_func = (_tmpi, Vo) => {
						let fir_red_list = []
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_lv >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_red_list
									// [ts2lua]local_Config.Composemenu下标访问可能不正确
									let sec_cfg = config_compose_menu[Number(secVo)]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										////////////////////////////////////////////////////////////-
										//特殊处理 装备合成  (3,5)外的其他材料合成 都是同样的消耗材料  只用就算一次 //
										////////////////////////////////////////////////////////////-
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											let num_temp = Number(_tmpi)
											if (num_temp == 1 || num_temp == 3 || num_temp == 5) {
												result = this.EquipCanComposite(Goodsid)
												if (result[0]) {
													sec_red_list = true
													flag = true
													break
												}
												//} else if (_tmpi >=7 ) {
												//result = this.EquipCanComposite(Goodsid)
												//if (result ) {
												//sec_red_list = true
												//flag = true
												//break
												//}
											}
										}
										if (!flag) {
											sec_red_list = false
										}
									}
									if (sec_red_list != null) {
										table.insert(fir_red_list, sec_red_list)
									}
								}
							}
						}
						if (fir_red_list.length > 0) {
							table.insert(result_list, fir_red_list)
						}
						if (_tmpi == menu_list.length) {
							callback(result_list)
						}
					}

					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						menu_func(_tmpi, Vo)
						//setTimeout(menu_func,0.15 * _tmpi,_tmpi, Vo)
					}
				}
			}
			//return result_list
		}
		//里面的判断只能返回bool值
		this.isShowRed = () => {
			let has_open = common_mgr.CheckFuncOpenState("CompositeView", true)
			if (!has_open) {
				return false
			}
			let red = this.GetGoodsRedDot()
				|| this.rune_red_dot
				|| this.GetHolySealRedDot()
				|| this.GetGuardRedDot()
				|| this.GetGodReddot()
				|| this.GetUnrealRedDot()
				|| this.GetRevelationRedDot()
				|| this.godCourtComRed
				|| this.GetLonglangRedDot()
				|| this.godbeast_red_dot
			return red
		}

		this.RefreshShowRed = (config_compose_menu, config_compose_menu_id) => {
			//this:RefreshSoulRedDot()
			this.GodBeastReddot(config_compose_menu, config_compose_menu_id)
			this.RefreshUnrealRedDot()
			this.RefreshHolySealRedDot()
			this.RefreshGoodsRedDot()
			this.GodReddot(config_compose_menu, config_compose_menu_id)
			//this:RefreshBabyRedDot()
			this.RefreshRevelationRedDot()
			this.RuneComposeRedDot()
			this.RefreshGuardRedDot()
			//this.RefreshLonglangRedDot()
			this.GetGodCourtRed()
		}

		this.GetAllMatList = (config_compose_menu) => {
			total_mat_list_ = []
			// [ts2lua]local_Config.Composemenu下标访问可能不正确
			let menu_cfg = config_compose_menu[local_CompositeModel.EquipmentComposeRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						// [ts2lua]local_Config.Composemenu下标访问可能不正确
						let first_cfg = config_compose_menu[Vo]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									// [ts2lua]local_Config.Composemenu下标访问可能不正确
									let sec_cfg = config_compose_menu[secVo]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
											let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, Goodsid, false, Goodscompose)
											if (cfg) {
												if (cfg.sex == role_mgr.mainRoleInfo.sex || cfg.sex == 0) {
													let regular_list = erlang_parser.Parse(cfg.regular_mat)
													for (let _tmpi in regular_list) {
														let Vo = regular_list[_tmpi]
														// [ts2lua]total_mat_list_下标访问可能不正确
														total_mat_list_[Vo[1]] = Vo[1]
													}
													let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
													for (let _tmpi in irregular_list) {
														let Vo = irregular_list[_tmpi]
														// [ts2lua]total_mat_list_下标访问可能不正确
														total_mat_list_[Vo] = Vo
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			return total_mat_list_
		}

		this.IsRuneCanCompose = (type_id?) => {
			let can_compose = false
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			if (Goodscompose) {
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, type_id, false, Goodscompose)
				if (cfg) {
					let fit = true
					let condition = erlang_parser.Parse(cfg.condition)
					if (condition && condition.length > 0) {
						if (RuneModel.GetInstance().rune_tower_floor < Number(condition[0][1])) {
							fit = false
						}
					}

					//符文
					if (fit) {
						let mat = erlang_parser.Parse(cfg.regular_mat)
						if (mat) {
							for (let _tmpi in mat) {
								let vo = mat[_tmpi]
								let cost = vo[0]
								if (cost) {
									let [type_id, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
									let my_num = goods_model.GetTypeGoodsNum(type_id)

									//身上穿戴的符文也可以算次数
									let wear_info = RuneModel.GetInstance().GetWearRuneSame(type_id,true)
									if (wear_info) {
										my_num++
									}
							
									if (my_num < Number(cost[2])) {
										fit = false
										break
									}
								}
							}
						}
					}

					//御魂魔晶
					if (fit) {
						let other_cost = erlang_parser.Parse(cfg.cost)
						if (other_cost) {
							for (let _tmpi in other_cost) {
								let vo = other_cost[_tmpi]
								let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
								let my_num = goods_model.GetTypeGoodsNum(type_id)
								if (my_num < Number(vo[2])) {
									fit = false
									break
								}
							}
						}
					}
					can_compose = fit
				}
			}
			return can_compose
		}

		this.CanCompose = (type_id?) => {
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			if (!Goodscompose) {
				return false
			}
			type_id = Number(type_id)
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, type_id, false, Goodscompose)
			if (!cfg) {
				return false
			}
			let regular_mat = erlang_parser.Parse(cfg.regular_mat)
			if (!regular_mat) {
				return false
			}
			let regular_mat_dic = {}
			for (let key in regular_mat) {
				let value = regular_mat[key]
				let vo = value[0]
				if (!regular_mat_dic[vo[1]]) {
					regular_mat_dic[vo[1]] = Number(vo[2])
				} else {
					regular_mat_dic[vo[1]] = regular_mat_dic[vo[1]] + Number(vo[2])
				}
			}
			for (let typeId in regular_mat_dic) {
				let count1 = regular_mat_dic[typeId]
				let my_num = goods_model.GetTypeGoodsNum(typeId)
				if (GuardModel.GetInstance().goodsToType[Number(typeId)]) {
					my_num = my_num + GuardModel.GetInstance().GetActiveGuardNum(typeId)
				}
				if (my_num < count1) {
					return false
				}
			}
			let irregular_mat = erlang_parser.Parse(cfg.irregular_mat)
			if (!irregular_mat) {
				return false
			}
			let ratio = erlang_parser.Parse(cfg.ratio)
			if (!ratio) {
				return false
			}
			let hole_list = erlang_parser.Parse(cfg.hole_list)
			if (!hole_list) {
				return false
			}
			let need_count = 0
			for (let _tmpi in ratio) {
				let vo = ratio[_tmpi]
				if (Number(vo[1]) == 100) {
					need_count = Number(vo[0])
					break
				}
			}
			let index = 0
			let count = 0
			let dic = []
			//-console.log("___________________")
			//-PrintTable(irregular_mat, 1)
			for (let _tmpi in hole_list) {
				let hole_id = hole_list[_tmpi]
				//-console.log("___________________", index)
				if (Number(hole_id) == 2) {
					let list = irregular_mat[index]
					if (list) {
						for (let _tmpi in list) {
							let type_id = list[_tmpi]
							if (dic[type_id] != null) {
								if (dic[type_id] > 0) {
									dic[type_id] = dic[type_id] - 1
									count = count + 1
								}
							} else {
								let my_num = goods_model.GetTypeGoodsNum(type_id)
								if (GuardModel.GetInstance().goodsToType[Number(type_id)]) {
									my_num = my_num + GuardModel.GetInstance().GetActiveGuardNum(type_id)
								}
								if (my_num > 0) {
									dic[type_id] = my_num - 1
									count = count + 1
								}
							}
						}
					}
					index = index + 1
				} else if (Number(hole_id) == 1) {
					//固定材料在上面就已经检查完了 
					//let list = irregular_mat[index]
					//for (let type_id in regular_mat_dic) {

					//let num = regular_mat_dic[type_id]
					//let my_num = goods_model.GetTypeGoodsNum(type_id)
					//if (my_num >= num ) {
					//count = count + num
					//}
					//}
				}
			}
			if (count < need_count) {
				return false
			}
			let other_cost = erlang_parser.Parse(cfg.cost)
			if (!other_cost) {
				return false
			}
			for (let _tmpi in other_cost) {
				let vo = other_cost[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let my_num = goods_model.GetTypeGoodsNum(type_id)
				if (my_num < Number(vo[2])) {
					return false
				}
			}
			return true
		}

		this.UnrealCanCompose = (type_id?) => {
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			if (!Goodscompose) {
				return false
			}
			if (type_id) {
				type_id = Number(type_id)
				let bool = false
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, type_id, false, Goodscompose)
				let regular_list = erlang_parser.Parse(cfg.regular_mat)
				let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
				let regular_bool = true
				let can_com = false
				if (cfg) {
					let regular_list = erlang_parser.Parse(cfg.regular_mat)
					let need_count = 0
					let now_count = null
					let eliminate_list = []
					for (let _tmpi in regular_list) {
						let regular_data = regular_list[_tmpi]
						let can_compose = false
						for (let _tmpi in regular_data) {
							let Vo = regular_data[_tmpi]
							now_count = goods_model.GetTypeGoodsNum(Vo[1])
							if (now_count) {
								if (eliminate_list[Vo[1]]) {
									now_count = now_count - eliminate_list[Vo[1]]
								}
								if (now_count >= Number(Vo[2])) {
									if (!eliminate_list[Vo[1]]) {
										eliminate_list[Vo[1]] = 0
									}
									eliminate_list[Vo[1]] = eliminate_list[Vo[1]] + Number(Vo[2])
									can_compose = true
									break
								}
							}
						}
						if (!can_compose) {
							return false
						}
					}
					if (cfg.ratio_type == 2) {
						let ratio_cfg = erlang_parser.Parse(cfg.ratio)
						for (let _tmpi in ratio_cfg) {
							let Vo = ratio_cfg[_tmpi]
							if (Vo[1] == 100) {
								need_count = Vo[0]
								break
							}
						}
						let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
						if (irregular_list) {
							for (let _tmpi in irregular_list) {
								let pos_data = irregular_list[_tmpi]
								let have_goods = false
								for (let _tmpi in pos_data) {
									let Vo = pos_data[_tmpi]
									now_count = goods_model.GetTypeGoodsNum(Vo)
									if (eliminate_list[Vo]) {
										now_count = now_count - eliminate_list[Vo]
									}
									if (now_count >= 1) {
										if (!eliminate_list[Vo]) {
											eliminate_list[Vo] = 0
										}
										eliminate_list[Vo] = eliminate_list[Vo] + 1
										have_goods = true
										break
									}
								}
								if (!have_goods) {
									return false
								}
							}
							return true
						}
					} else if (cfg.ratio_type == 1) {
						let ratio_cfg = erlang_parser.Parse(cfg.ratio)
						if (ratio_cfg == 100) {
							return true
						}
					}
				}
			}
		}

		this.GetUnrealComposeNameList = (Composemenuid?) => {
			let tab_bar_name_list = []
			let tab_id_obj = unreal_tab_id_obj_
			if (Composemenuid && tab_id_obj) {
				for (let sub_id in tab_id_obj) {

					let sub_id_obj = tab_id_obj[sub_id]
					let sub_id_cfg = Composemenuid[Number(sub_id)]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
						bar_name[2] = Number(sub_id)
					}
					for (let sub_sub_id in sub_id_obj) {

						let sub_sub_id_cfg = Composemenuid[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							table.insert(bar_name[1], sub_sub_id_cfg.name)
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			table.sort(tab_bar_name_list, (a?, b?) => {
				return a[2] < b[2]
			})
			return tab_bar_name_list
		}

		this.GetHolySealComposeNameList = (config_compose_menu, Composemenuid?) => {
			let tab_bar_name_list = []
			let cfg = config_compose_menu[local_CompositeModel.HolySealComposeRule]
			let tab_id_list = this.holy_seal_tab_id_list
			if (cfg && Composemenuid) {
				let menu_list = erlang_parser.Parse(cfg.list)
				for (let index in menu_list) {
					let sub_id = menu_list[index]
					//let sub_id_obj = menu_list[index]
					let sub_id_cfg = Composemenuid[Number(sub_id)]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
					}
					let sub_cfg = config_compose_menu[Number(sub_id)]
					let sub_menu_list = erlang_parser.Parse(sub_cfg.list)
					for (let _tmpi in sub_menu_list) {
						let sub_sub_id = sub_menu_list[_tmpi]
						let sub_sub_id_cfg = Composemenuid[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							table.insert(bar_name[1], sub_sub_id_cfg.name)
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			return tab_bar_name_list
		}

		this.GetLonglangComposeNameList = (config_compose_menu, Composemenuid?) => {
			let tab_bar_name_list = []
			let cfg = config_compose_menu[local_CompositeModel.LonglangRule]
			let tab_id_list = this.longlang_tab_id_list
			if (cfg && Composemenuid) {
				let menu_list = erlang_parser.Parse(cfg.list)
				for (let index in menu_list) {
					let sub_id = menu_list[index]
					let sub_id_obj = menu_list[index]
					let sub_id_cfg = Composemenuid[Number(sub_id)]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
					}
					let sub_cfg = config_compose_menu[Number(sub_id)]
					let sub_menu_list = erlang_parser.Parse(sub_cfg.list)
					for (let _tmpi in sub_menu_list) {
						let sub_sub_id = sub_menu_list[_tmpi]
						let sub_sub_id_cfg = Composemenuid[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							table.insert(bar_name[1], sub_sub_id_cfg.name)
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			return tab_bar_name_list
		}

		this.GetGoodsComposeNameList = (Composemenuid?) => {
			let tab_bar_name_list = []
			let tab_id_obj = goods_tab_id_obj_
			if (Composemenuid && tab_id_obj) {
				for (let sub_id in tab_id_obj) {

					// [ts2lua]tab_id_obj下标访问可能不正确
					let sub_id_obj = tab_id_obj[sub_id]
					// [ts2lua]Composemenuid下标访问可能不正确
					let sub_id_cfg = Composemenuid[Number(sub_id)]
					let bar_name = null
					let tmp_list = []
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						//bar_name[2] = []
						bar_name[2] = sub_id
					}
					for (let sub_sub_id in sub_id_obj) {
						table.insert(tmp_list, Number(sub_sub_id))
					}
					let temp_2 = []
					table.sort(tmp_list, (a?, b?) => {
						return a < b
					})
					for (let _ in tmp_list) {
						let v = tmp_list[_]
						let sub_sub_id_cfg = Composemenuid[v]
						if (sub_sub_id_cfg) {
							table.insert(temp_2, sub_sub_id_cfg.name)
						}
					}
					bar_name[1] = temp_2
					table.insert(tab_bar_name_list, bar_name)
				}
				table.sort(tab_bar_name_list, (a?, b?) => {
					return a[2] < b[2]
				})
			}
			return tab_bar_name_list
		}

		this.GetRevelationComposeNameList = (config_compose_menu, Composemenuid?) => {
			let tab_bar_name_list = []
			let cfg = config_compose_menu[local_CompositeModel.RevelationComposeRule]
			let tab_id_list = this.revelation_tab_id_list
			if (cfg && Composemenuid) {
				let menu_list = erlang_parser.Parse(cfg.list)
				for (let index in menu_list) {
					let sub_id = Number(menu_list[index])
					//let sub_id_obj = Number(menu_list[index])
					let sub_id_cfg = Composemenuid[sub_id]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
					}
					let sub_cfg = config_compose_menu[sub_id]
					let sub_menu_list = erlang_parser.Parse(sub_cfg.list)
					for (let _tmpi in sub_menu_list) {
						let sub_sub_id = sub_menu_list[_tmpi]
						let sub_sub_id_cfg = Composemenuid[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							table.insert(bar_name[1], sub_sub_id_cfg.name)
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			return tab_bar_name_list
		}

		this.GetGuardComposeNameList = (Composemenuid?) => {
			let tab_bar_name_list = []
			let tab_id_obj = guard_tab_id_obj_
			if (Composemenuid && tab_id_obj) {
				for (let sub_id in tab_id_obj) {
					let sub_id_obj = tab_id_obj[sub_id]
					let sub_id_cfg = Composemenuid[Number(sub_id)]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
					}
					for (let sub_sub_id in sub_id_obj) {
						let sub_sub_id_cfg = Composemenuid[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							table.insert(bar_name[1], sub_sub_id_cfg.name)
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			return tab_bar_name_list
		}

		this.GetTabIdList = (config_compose_menu, rule_id?, same?) => {
			let tab_id_list = []
			let tab_id_obj = []
			let cfg = config_compose_menu[rule_id]
			if (!cfg) {
				return [false, null, null]
			}
			let menu_list = erlang_parser.Parse(cfg.list)
			if (Number(menu_list[0]) == rule_id) {
				if (same) {
					return [false, null, null]
				} else {
					same = true
				}
			}
			for (let _tmpi in menu_list) {
				let sub_id = menu_list[_tmpi]
				sub_id = Number(sub_id)
				let is_set, list, obj
				[is_set, list, obj] = this.GetTabIdList(config_compose_menu, sub_id, same)
				if (is_set == false) {
					tab_id_obj[sub_id] = menu_list
					table.insert(tab_id_list, menu_list)
					break
				} else {
					tab_id_obj[sub_id] = obj
					table.insert(tab_id_list, list)
				}
			}
			return [true, tab_id_list, tab_id_obj]
		}

		this.InitUnrallTabIdList = (config_compose_menu) => {
			let tab_id_list = []
			let tab_id_obj = []
			let cfg = config_compose_menu[local_CompositeModel.UnrealComposeRule]
			if (cfg) {
				let menu_list = erlang_parser.Parse(cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let sub_id = menu_list[_tmpi]
						let sub_ids = []
						tab_id_obj[sub_id] = []
						let sub_cfg = config_compose_menu[Number(sub_id)]
						let sub_list = erlang_parser.Parse(sub_cfg.list)
						if (sub_list) {
							for (let _tmpi in sub_list) {
								let sub_sub_id = sub_list[_tmpi]
								let sub_sub_cfg = config_compose_menu[Number(sub_sub_id)]
								let list = erlang_parser.Parse(sub_sub_cfg.list)
								tab_id_obj[sub_id][sub_sub_id] = list
								table.insert(sub_ids, list)
							}
						}
						table.insert(tab_id_list, sub_ids)
					}
				}
			}
			this.unreal_tab_id_list = tab_id_list
			unreal_tab_id_obj_ = tab_id_obj
		}

		this.InitHolySealTabIdList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.HolySealComposeRule)
			this.holy_seal_tab_id_list = list
			holy_seal_tab_id_obj_ = obj
		}

		this.InitLonglangTabIdList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.LonglangRule)
			long_lang_model.InitCfg(list)
			this.longlang_tab_id_list = list
			longlang_tab_id_obj_ = obj
		}

		this.InitSoulTabIdList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.SoulComposeRule)
			soul_tab_id_list_ = list
			soul_tab_id_obj_ = obj
		}

		this.InitGoodsTabIdList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.GoodsComRule)
			this.goods_tab_id_list = list
			goods_tab_id_obj_ = obj
		}

		this.InitRevelationList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.RevelationComposeRule)
			this.revelation_tab_id_list = list
			revelation_tab_id_obj_ = obj
		}

		this.InitGuardTabIdList = (config_compose_menu) => {
			let is_set, list, obj
			[is_set, list, obj] = this.GetTabIdList(config_compose_menu, local_CompositeModel.GuardComposeRule)
			this.guard_tab_id_list = list
			guard_tab_id_obj_ = obj
		}

		this.RefreshUnrealRedDot = () => {
			let tab_id_list = this.unreal_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.UnrealCanCompose(composite_id)) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.unreal_red_dot) {
				this.ChangeVar("unreal_red_dot", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
			}
			return bool
		}

		this.GetUnrealRedDot = () => {
			return this.unreal_red_dot
		}

		this.RefreshSoulRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeSoulView", true)) {
				return false
			}
			let tab_id_list = soul_tab_id_list_
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CheckSoulColorCompose(composite_id) && this.CanCompose(composite_id)) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.soul_red_dot) {
				this.ChangeVar("soul_red_dot", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.CheckSoulColorCompose = (composite_id?) => {
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, composite_id, false, Goodscompose)
			if (!cfg) {
				return false
			}
			let goods = erlang_parser.Parse(cfg.goods)
			if (!goods || goods.length < 1) {
				return false
			}
			let type_id = goods[0][1]
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			if (!basic) {
				return false
			}
			// [ts2lua]goods_model.wear_soul_type_dic下标访问可能不正确
			let data = goods_model.wear_soul_type_dic[basic.subtype]
			if (data && data.color >= basic.color) {
				return false
			} else {
				// [ts2lua]goods_model.soulbag_type_dic下标访问可能不正确
				let goods_list = goods_model.soulbag_type_dic[basic.subtype]
				if (!goods_list) {
					return true
				}
				for (let _tmpi in goods_list) {
					let vo = goods_list[_tmpi]
					if (vo.color >= basic.color) {
						return false
					}
				}
			}
			return true
		}

		this.GetSoulRedDot = () => {
			return this.soul_red_dot
		}

		this.RefreshHolySealRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeHolySealView", true)) {
				return false
			}
			let tab_id_list = this.holy_seal_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CanCompose(composite_id[0])) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.holy_seal_red_dot) {
				this.ChangeVar("holy_seal_red_dot", bool)
				HolySealModel.GetInstance().SetRedFlag(HolySealModel.RedFlag.Composite, bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetHolySealRedDot = () => {
			return this.holy_seal_red_dot
		}

		this.RefreshLonglangRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeLonglangView", true)) {
				return false
			}
			let tab_id_list = this.longlang_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CanCompose(composite_id[0])) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.longlang_red_dot) {
				this.ChangeVar("longlang_red_dot", bool)
				RedDotManager.GetInstance().SetRedStatus(ModuleType.LONGLANG, 4, bool)
				RedDotController.ins.up(RedKey.EQUIP_COMPOSITE, bool ? 1 : 0)
				long_lang_model.Fire(longlangModel.REFRESH_RED, 4)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetLonglangRedDot = () => {
			return this.longlang_red_dot
		}

		this.RefreshRevelationRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeRevelationView", true)) {
				return false
			}
			let tab_id_list = this.revelation_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CanCompose(composite_id[0])) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.revelation_red_dot) {
				this.ChangeVar("revelation_red_dot", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetRevelationRedDot = () => {
			return this.revelation_red_dot
		}

		this.RuneComposeRedDot = () => {
			// return false
			let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
			let cfg2 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu_id
			let list = this.GetRuneComposeData(cfg1, cfg2)
			let rune_red_dot = false
			if (list) {
				// let red_index = 0
				// let red_sub_index = 0
				// let btn_need_red = false
				let arr = null
				let id = null
				let i = 0
				do {
					// let need_red = false
					arr = list[0][i]
					let j = 0
					do {
						id = arr[1][j]
						// 检查是否有勾选
						let key = "rune" + id
						let cookie = CookieWrapper.GetInstance().GetCookie(key)
						let ignore = true
						if (!cookie || Number(cookie) == 0) {
							ignore = false
						}
						rune_red_dot = this.IsRuneCanCompose(id) && (!ignore)
						if (rune_red_dot) {
							break
						}
						j = j + 1
					} while ((j < arr[1].length))
					if (rune_red_dot) {
						break
					}
					i = i + 1
				} while ((i < list[0].length))
			}
			this.ChangeVar("rune_red_dot", rune_red_dot)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			return rune_red_dot
		}

		this.GodBeastCanCompose = (type_id?) => {
			let Goodscompose = local_Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			if (!Goodscompose) {
				return false
			}
			if (type_id) {
				type_id = Number(type_id)
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, type_id, false, Goodscompose)
				if (cfg) {
					let regular_list = erlang_parser.Parse(cfg.regular_mat)

					let now_count = null
					let eliminate_list = []
					//蜃之源核
					for (let _tmpi in regular_list) {
						let regular_data = regular_list[_tmpi]
						let can_compose = false
						for (let _tmpi in regular_data) {
							let Vo = regular_data[_tmpi]
							now_count = goods_model.GetTypeGoodsNum(Vo[1])
							if (now_count) {
								if (eliminate_list[Vo[1]]) {
									now_count = now_count - eliminate_list[Vo[1]]
								}
								if (now_count >= Number(Vo[2])) {
									if (!eliminate_list[Vo[1]]) {
										eliminate_list[Vo[1]] = 0
									}
									eliminate_list[Vo[1]] = eliminate_list[Vo[1]] + Number(Vo[2])
									can_compose = true
									break
								}
							}
						}
						if (!can_compose) {
							return false
						}
					}
					if (cfg.ratio_type == 2) {
						let irregular_list = erlang_parser.Parse(cfg.irregular_mat)
						if (irregular_list) {
							for (let _tmpi in irregular_list) {
								let pos_data = irregular_list[_tmpi]
								let have_goods = false
								for (let _tmpi in pos_data) {
									let Vo = pos_data[_tmpi]
									now_count = goods_model.GetTypeGoodsNum(Vo)
									if (eliminate_list[Vo]) {
										now_count = now_count - eliminate_list[Vo]
									}
									if (now_count >= 1) {
										if (!eliminate_list[Vo]) {
											eliminate_list[Vo] = 0
										}
										eliminate_list[Vo] = eliminate_list[Vo] + 1
										have_goods = true
										break
									}
								}
								if (!have_goods) {
									return false
								}
							}
							return true
						}
					} else if (cfg.ratio_type == 1) {
						let ratio_cfg = erlang_parser.Parse(cfg.ratio)
						if (ratio_cfg == 100) {
							return true
						}
					}
				}
			}
		}

		this.GetGodBeastSubRedDot = (config_compose_menu) => {
			let result_list = []
			// [ts2lua]local_Config.Composemenu下标访问可能不正确
			let menu_cfg = config_compose_menu[local_CompositeModel.GodBeastcomposeRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let fir_red_list = []
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_red_list = []
									let sec_cfg = config_compose_menu[Number(secVo)]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											result = this.GodBeastCanCompose(Goodsid)
											if (result) {
												table.insert(sec_red_list, true)
												flag = true
												break
											}
										}
										if (!flag) {
											sec_red_list.push(false)
										}
									}
									if (sec_red_list.length > 0) {
										table.insert(fir_red_list, sec_red_list)
									}
								}
							}
						}
						if (fir_red_list.length > 0) {
							table.insert(result_list, fir_red_list)
						}
					}
				}
			}
			return result_list
		}

		this.GodBeastReddot = (config_compose_menu, config_compose_menu_id) => {
			if (!common_mgr.CheckFuncOpenState("GodBeastCompositeView", true)) {
				return false
			}
			let list = this.GetTabBarData(config_compose_menu, config_compose_menu_id, local_CompositeModel.GodBeastcomposeRule)
			let godbeast_red_dot = false
			if (list) {
				let red_index = 0
				let red_sub_index = 0
				let btn_need_red = false
				let arr = null
				let id = null
				let i = 0
				do {
					let need_red = false
					arr = list[0][i]
					let j = 0
					do {
						let rule_cfg = config_compose_menu[Number(arr[j])]
						let rule_list = erlang_parser.Parse(rule_cfg.list)
						if (rule_list) {
							let k = 0
							do {
								godbeast_red_dot = this.GodBeastCanCompose(rule_list[k])
								if (godbeast_red_dot) {
									break
								}
								k = k + 1
							} while ((k < rule_list.length))
						}
						if (godbeast_red_dot) {
							break
						}
						j = j + 1
					} while ((j < arr.length))
					if (godbeast_red_dot) {
						break
					}
					i = i + 1
				} while ((i < list[0].length))
			}
			if (godbeast_red_dot != this.godbeast_red_dot) {
				this.ChangeVar("godbeast_red_dot", godbeast_red_dot)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return godbeast_red_dot
		}

		this.GetBeastReddot = () => {
			return this.godbeast_red_dot
		}

		this.GetGodSubRedDot = (config_compose_menu) => {
			let result_list = []
			// [ts2lua]local_Config.Composemenu下标访问可能不正确
			let menu_cfg = config_compose_menu[local_CompositeModel.GodcomposeRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let fir_red_list = []
						// [ts2lua]local_Config.Composemenu下标访问可能不正确
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_red_list = []
									// [ts2lua]local_Config.Composemenu下标访问可能不正确
									let sec_cfg = config_compose_menu[Number(secVo)]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											result = this.CanCompose(Goodsid)
											if (result) {
												table.insert(sec_red_list, true)
												flag = true
												break
											}
										}
										if (!flag) {
											//table.insert(sec_red_list, false)
											sec_red_list.push(false)
										}
									}
									if (sec_red_list.length > 0) {
										table.insert(fir_red_list, sec_red_list)
									}
								}
							}
						}
						if (fir_red_list.length > 0) {
							table.insert(result_list, fir_red_list)
						}
					}
				}
			}
			return result_list
		}

		this.GodReddot = (config_compose_menu, config_compose_menu_id) => {
			if (!common_mgr.CheckFuncOpenState("GodBefallCompositeView", true)) {
				return false
			}
			let list = this.GetTabBarData(config_compose_menu, config_compose_menu_id, local_CompositeModel.GodcomposeRule)
			let god_red_dot = false
			if (list) {
				let red_index = 0
				let red_sub_index = 0
				let btn_need_red = false
				let arr = null
				let id = null
				let i = 0
				do {
					let need_red = false
					arr = list[0][i]
					if (arr) {
						let j = 0
						do {
							// [ts2lua]local_Config.Composemenu下标访问可能不正确
							let rule_cfg = config_compose_menu[Number(arr[j])]
							let rule_list = erlang_parser.Parse(rule_cfg.list)
							if (rule_list) {
								let k = 0
								do {
									god_red_dot = this.CanCompose(rule_list[k])
									if (god_red_dot) {
										break
									}
									k = k + 1
								} while ((k < rule_list.length))
							}
							if (god_red_dot) {
								break
							}
							j = j + 1
						} while ((j < arr.length))
					}
					if (god_red_dot) {
						break
					}
					i = i + 1
				} while ((i < list[0].length))
			}
			if (god_red_dot != this.god_red_dot) {
				this.ChangeVar("god_red_dot", god_red_dot)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return god_red_dot
		}

		this.GetGodReddot = () => {
			return this.god_red_dot
		}

		this.RefreshGoodsRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeGoodsView", true)) {
				return false
			}
			let tab_id_list = this.goods_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CanCompose(Number(composite_id[0]))) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.goods_red_dot) {
				this.ChangeVar("goods_red_dot", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetGoodsRedDot = () => {
			return this.goods_red_dot
		}

		this.GetGodCourtRed = () => {
			let config_compose_menu = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
			if (!common_mgr.CheckFuncOpenState("GodCourtView", true)) {
				return false
			}
			let menu_cfg = config_compose_menu && config_compose_menu[GodCourtModel.ComId]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_cfg = config_compose_menu[Number(secVo)]
									result = this.CanCompose(secVo)
									if (result) {
										this.ChangeVar("godCourtComRed", result)
										GodCourtModel.GetInstance().Fire(GodCourtModel.REFRESH_RED, 7)
										RedDotController.ins.up(RedKey.GOD_COURT_COM, result ? 1 : 0)
										GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
										GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
										return result
									}
								}
							}
						}
					}
				}
			}
			this.ChangeVar("godCourtComRed", false)
			GodCourtModel.GetInstance().Fire(GodCourtModel.REFRESH_RED, 7)
			RedDotController.ins.up(RedKey.GOD_COURT_COM, 0)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			return false
		}

		this.isRedShowRed = () => {
			let has_open = common_mgr.CheckFuncOpenState("RedEnterView", true)
			if (!has_open) {
				return false
			}
			let red = ((this.equip_red_dot || this.ring_red_dot) || this.ring_upgrade_red_dot) || equip_model.godEquipRedDot()
			return red
		}

		this.GetRingSubRedDot = (config_compose_menu) => {
			let result_list = []
			let menu_cfg = config_compose_menu[local_CompositeModel.RingComposeRuleRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let fir_red_list = []
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_red_list = []
									let sec_cfg = config_compose_menu[Number(secVo)]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											result = this.RingCanComposite(Goodsid)
											if (result) {
												table.insert(sec_red_list, true)
												flag = true
												break
											}
										}
										if (!flag) {
											sec_red_list.push(false)
										}
									}
									if (sec_red_list.length > 0) {
										table.insert(fir_red_list, sec_red_list)
									}
								}
							}
						}
						if (fir_red_list.length > 0) {
							table.insert(result_list, fir_red_list)
						}
					}
				}
			}
			return result_list
		}

		this.GetRingUpgradeSubRedDot = (config_compose_menu) => {
			let result_list = []
			let menu_cfg = config_compose_menu[local_CompositeModel.RingUpgradeRuleRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let fir_red_list = []
						let first_cfg = config_compose_menu[Number(Vo)]
						if (first_cfg && role_mgr.mainRoleInfo.level >= first_cfg.open_lv) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi in sec_list) {
									let secVo = sec_list[_tmpi]
									let sec_red_list = []
									let sec_cfg = config_compose_menu[Number(secVo)]
									if (sec_cfg && role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
										let goods_list = erlang_parser.Parse(sec_cfg.list)
										let flag = false
										for (let _tmpi in goods_list) {
											let Goodsid = goods_list[_tmpi]
											result = this.RingCanComposite(Goodsid)
											if (result) {
												table.insert(sec_red_list, true)
												flag = true
												break
											}
										}
										if (!flag) {
											sec_red_list.push(false)
										}
									}
									if (sec_red_list.length > 0) {
										table.insert(fir_red_list, sec_red_list)
									}
								}
							}
						}
						if (fir_red_list.length > 0) {
							table.insert(result_list, fir_red_list)
						}
					}
				}
			}
			return result_list
		}

		this.RingReddot = (config_compose_menu, config_compose_menu_id) => {
			if (!common_mgr.CheckFuncOpenState("RingCompositeView", true)) {
				return false
			}
			let list = this.GetTabBarData(config_compose_menu, config_compose_menu_id, local_CompositeModel.RingComposeRuleRule)
			let ring_red_dot = false
			if (list) {
				let red_index = 0
				let red_sub_index = 0
				let btn_need_red = false
				let arr = null
				let id = null
				let i = 0
				if (i < list[0].length) {
					do {
						let need_red = false
						arr = list[0][i]
						let j = 0
						if (j < arr.length) {
							do {
								// [ts2lua]local_Config.Composemenu下标访问可能不正确
								let rule_cfg = config_compose_menu[Number(arr[j])]
								let rule_list = erlang_parser.Parse(rule_cfg.list)
								if (rule_list) {
									let k = 0
									do {
										ring_red_dot = this.RingCanComposite(rule_list[k])
										if (ring_red_dot) {
											break
										}
										k = k + 1
									} while ((k < rule_list.length))
								}
								if (ring_red_dot) {
									break
								}
								j = j + 1
							} while ((j < arr.length))
						}
						if (ring_red_dot) {
							break
						}
						i = i + 1
					} while ((i < list[0].length))
				}
			}
			this.ChangeVar("ring_red_dot", ring_red_dot)
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Red)
			RedDotController.ins.up(RedKey.GOD_EQUIPMENT_RING, ring_red_dot ? 1 : 0)
			return ring_red_dot
		}

		this.RingUpgradeReddot = (config_compose_menu, config_compose_menu_id) => {
			if (!common_mgr.CheckFuncOpenState("RingUpgradeView", true)) {
				return false
			}
			let list = this.GetTabBarData(config_compose_menu, config_compose_menu_id, local_CompositeModel.RingUpgradeRuleRule)
			let ring_Upgrade_red_dot = false
			if (list) {
				let red_index = 0
				let red_sub_index = 0
				let btn_need_red = false
				let arr = null
				let id = null
				let i = 0
				do {
					if (i < list[0].length) {
						let need_red = false
						arr = list[0][i]
						let j = 0
						do {
							if (j < arr.length) {
								// [ts2lua]local_Config.Composemenu下标访问可能不正确
								let rule_cfg = config_compose_menu[Number(arr[j])]
								let rule_list = erlang_parser.Parse(rule_cfg.list)
								if (rule_list) {
									let k = 0
									do {
										ring_Upgrade_red_dot = this.RingCanComposite(rule_list[k])
										if (ring_Upgrade_red_dot) {
											break
										}
										k = k + 1
									} while ((k < rule_list.length))
								}
								if (ring_Upgrade_red_dot) {
									break
								}
								j = j + 1
							}
						} while ((j < arr.length))
						if (ring_Upgrade_red_dot) {
							break
						}
						i = i + 1
					}
				} while ((i < list[0].length))
			}
			this.ChangeVar("ring_upgrade_red_dot", ring_Upgrade_red_dot)
			RedDotController.ins.up(RedKey.GOD_EQUIPMENT_RING_UPGRADE, ring_Upgrade_red_dot ? 1 : 0)
			return ring_Upgrade_red_dot
		}

		this.checkWearEquip = (goods_id?) => {
			let equipList = equip_model.GetWearEquipInfos()
			for (let key in equipList) {

				// [ts2lua]equipList下标访问可能不正确
				let equip = equipList[key]
				if (equip.goods_id == goods_id) {
					return true
				}
			}
			return false
		}

		this.GetCanSelectEquip = (type_list?) => {
			let can_select_list = []
			let list = []
			if (!type_list) {
				return
			}
			for (let _tmpi in type_list) {
				let type_id = type_list[_tmpi]
				let goods = goods_model.GetTypeGoods(type_id)
				if (goods) {
					table.insert(list, goods)
				}
			}
			if (list.length > 0) {
				let i = 0
				do {
					do {
						for (let index in list[i]) {
							let goods_id = list[i][index].goods_id
							if (this.babySelectedEquipList[goods_id]) {
								break
							}
							table.insert(can_select_list, list[i][index])
						}
					} while (true)
					i = i + 1
				} while ((i < list.length))
			}
			return can_select_list
		}

		this.InitBabyTabIdList = () => {
			let list = this.GetTabBarData(local_CompositeModel.BabyEquipRule)
			if (list && list[0].length > 0) {
				this.babyTabIdList = list[0]
			}
		}

		this.RefreshBabyRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("BabyCompositeView", true)) {
				return false
			}
			let tab_id_list = this.babyTabIdList
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					for (let _tmpi in sub_list) {
						let composite_id = sub_list[_tmpi]
						if (this.CanCompose(composite_id)) {
							bool = true
							break
						}
					}
				}
			}
			if (bool != this.babyComRed) {
				this.ChangeVar("babyComRed", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetTabBarData = (config_compose_menu, config_compose_menu_id, ...new_args) => {
			let parms = new_args
			let tab_bar_id_list = []
			let bar = null
			let tab_bar_name_list = []
			let tab_bar_icon_list = null
			if (parms[0] == local_CompositeModel.RingComposeRuleRule || parms[0] == local_CompositeModel.RingUpgradeRuleRule) {
				tab_bar_icon_list = []
			}
			let bar_name = null
			let Composemenu = config_compose_menu
			let Composemenuid = config_compose_menu_id
			if (Composemenu && Composemenuid) {
				let get_fun = (menu_cfg?) => {
					//let sub_menu_cfg = null
					let menu_id_cfg = null
					if (menu_cfg) {
						let menu_list = erlang_parser.Parse(menu_cfg.list)
						//let sub_menu_list = null
						if (menu_list) {
							for (let _tmpi in menu_list) {
								let obj = menu_list[_tmpi]
								bar = []
								let fir_tab_data = Composemenuid[Number(obj)]
								if (fir_tab_data && role_mgr.mainRoleInfo.level >= fir_tab_data.open_lv) {
									bar_name = []
									bar_name[0] = fir_tab_data.name
									bar_name[1] = []
									bar_name[2] = fir_tab_data.id
									menu_id_cfg = Composemenu[Number(obj)]
									if (menu_id_cfg) {
										if (tab_bar_icon_list) {
											table.insert(tab_bar_icon_list, obj)
										}
										let last_data
										let sec_list = erlang_parser.Parse(menu_id_cfg.list)
										if (sec_list) {
											for (let _tmpi in sec_list) {
												let sec_obj = sec_list[_tmpi]
												let sec_data = Composemenuid[Number(sec_obj)]
												if (sec_data && role_mgr.mainRoleInfo.level >= sec_data.open_lv) {
													table.insert(bar, sec_obj)
													table.insert(bar_name[1], sec_data.name)
												} else if (!last_data && parms[0] == local_CompositeModel.EquipmentComposeRule) {
													//table.insert(bar, sec_obj)
													/*
													if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
														table.insert(bar_name[2], "Lv." + sec_data.open_lv + "\nto unlock @Lv." + sec_data.open_lv + "to Unlock")
													} else if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
														table.insert(bar_name[2], "Lv." + sec_data.open_lv + "เปิด@" + sec_data.open_lv + "เปิด")
													} else {
														table.insert(bar_name[2], sec_data.open_lv + "级开启@" + sec_data.open_lv + "级开启")
													}
													*/
													let level = sec_data.open_lv > 370 ? (sec_data.open_lv - 370) : sec_data.open_lv
													let name = sec_data.open_lv > 370 ? "神创" : ""
													if (PlatformManager.IsEyouEnPlatform()) {
														table.insert(bar_name[1], name +" Lv."+ level + " to unlock @" + name + level + "Unlocks at Lv.")
													}else{
													table.insert(bar_name[1], name + level + "级开启@" + name + level + "级开启")
													}
													//table.insert(bar_name[1], sec_data.open_lv + "级开启@" + sec_data.open_lv + "级开启")
													break
												}
											}
										}
										table.insert(tab_bar_id_list, bar)
										table.insert(tab_bar_name_list, bar_name)
									}
								}
							}
						}
					}
				}
				for (let _tmpi in parms) {
					let vo = parms[_tmpi]
					let menu_cfg = Composemenu[vo]
					get_fun(menu_cfg)
				}
				let result = []
				result[0] = tab_bar_id_list
				result[1] = tab_bar_name_list
				if (tab_bar_icon_list) {
					result[2] = tab_bar_icon_list
				}
				return result
			}
		}

		this.SaveSoulComposeAwake = (list?) => {
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				let attr = list[key]
				// [ts2lua]this._SaveSoulComposeAwake下标访问可能不正确
				this._SaveSoulComposeAwake[attr.attr_type] = attr
			}
		}

		this.DelSoulComposeAwake = (list?) => {
			if (list) {
				for (let key in list) {

					// [ts2lua]list下标访问可能不正确
					let attr = list[key]
					// [ts2lua]this._SaveSoulComposeAwake下标访问可能不正确
					this._SaveSoulComposeAwake[attr.attr_type] = null
				}
			}
		}

		this.SoulComposeAwakeList = () => {
			let list = []
			for (let key in this._SaveSoulComposeAwake) {

				// [ts2lua]this._SaveSoulComposeAwake下标访问可能不正确
				let attr = this._SaveSoulComposeAwake[key]
				table.insert(list, attr)
			}
			return list
		}

		this.ReSetSoulComposeAwake = () => {
			this._SaveSoulComposeAwake = []
		}

		this.SaveRuneComposeAwake = (list?) => {
			for (let key in list) {
				let attr = list[key]
				_SaveRuneComposeAwake_[attr.attr_type] = attr
			}
		}

		this.DelRuneComposeAwake = (list?) => {
			for (let key in list) {
				let attr = list[key]
				_SaveRuneComposeAwake_[attr.attr_type] = null
			}
		}

		this.RuneComposeAwakeList = () => {
			let list = []
			for (let key in _SaveRuneComposeAwake_) {
				let attr = _SaveRuneComposeAwake_[key]
				table.insert(list, attr)
			}
			return list
		}

		this.ReSetRuneComposeAwake = () => {
			_SaveRuneComposeAwake_ = []
		}

		this.RefreshGuardRedDot = () => {
			if (!common_mgr.CheckFuncOpenState("CompositeGuardView", true)) {
				return false
			}
			let tab_id_list = this.guard_tab_id_list
			let bool = false
			if (tab_id_list) {
				for (let _tmpi in tab_id_list) {
					let sub_list = tab_id_list[_tmpi]
					if (bool) {
						break
					}
					for (let _tmpi in sub_list) {
						let composite_list = sub_list[_tmpi]
						if (bool) {
							break
						}
						for (let _tmpi in composite_list) {
							let composite_id = composite_list[_tmpi]
							if (this.CanCompose(composite_id[0])) {
								bool = true
								break
							}
						}
					}
				}
			}
			if (bool != this.guard_red_dot) {
				this.ChangeVar("guard_red_dot", bool)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Composite)
			}
			return bool
		}

		this.GetGuardRedDot = () => {
			return this.guard_red_dot
		}

		this.InitEquipTab = (config_compose_menu) => {
			this.equip_red_list = {}
			this.equip_tab_list = []
			this.equip_tab_id_list = []
			let red
			let menu_cfg = config_compose_menu[local_CompositeModel.EquipmentComposeRule]
			if (menu_cfg) {
				let result = null
				let menu_list = erlang_parser.Parse(menu_cfg.list)
				let role_lv = role_mgr.mainRoleInfo.level
				if (menu_list) {
					for (let _tmpi in menu_list) {
						let Vo = menu_list[_tmpi]
						let sec_id = Number(Vo)
						let fir_red_list = []
						let fir_tab_id_list = []
						let first_cfg = config_compose_menu[sec_id]
						if (first_cfg) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							if (sec_list) {
								for (let _tmpi1 in sec_list) {
									let secVo = sec_list[_tmpi1]
									let tab_red = this.EquipTabCanCom(config_compose_menu, Number(secVo))
									if (tab_red) {
										red = true
									}
									this.equip_tab_list[Number(secVo)] = [sec_id, _tmpi1]
									table.insert(fir_tab_id_list, Number(secVo))
									fir_red_list.push(tab_red)
									//table.insert(fir_red_list, tab_red)
								}
							}
						}
						this.equip_tab_id_list[_tmpi] = fir_tab_id_list
						this.equip_red_list[sec_id] = fir_red_list
					}
				}
			}

			this.ChangeVar("equip_red_dot", red)
			RedDotController.ins.up(RedKey.GOD_EQUIPMENT_COMPOSITE, red ? 1 : 0)
		}
		//
		//粉色装备合成需要的 CompositeModel.EquipComGoods = 38040017
		//更新装备合成红点
		// tabList = [11000,12000,13000,11002,12002,13002]
		this.UpdateEquipRed = (config_compose_menu, list?) => {
			if (!list) {
				return
			}
			let need_refresh_list = []
			let tab_list = [11000, 12000, 14000, 13000, 11002, 12002, 14002, 13002]

			let getTabIndex = (tab_index?, sub_index?) => {
				if (this.equip_tab_id_list[tab_index]) {
					let tab_id = this.equip_tab_id_list[tab_index][sub_index]
					if (tab_id) {
						let vo = this.equip_tab_list[tab_id]
						if (vo) {
							need_refresh_list[tab_id] = vo
						}
					}
				}
			}
			for (let _ in list) {
				let vo = list[_]
				let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
				if (goodsbasic) {
					if (goodsbasic.type_id == 38040017 || goodsbasic.type_id == 38040020) {
						let first_cfg = config_compose_menu[13000]
						if (first_cfg) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							for (let _ in sec_list) {
								let vo = sec_list[_]
								need_refresh_list[vo] = this.equip_tab_list[Number(vo)]
							}
						}
						first_cfg = config_compose_menu[13002]
						if (first_cfg) {
							let sec_list = erlang_parser.Parse(first_cfg.list)
							for (let _ in sec_list) {
								let vo = sec_list[_]
								need_refresh_list[vo] = this.equip_tab_list[Number(vo)]
							}
						}
					} else if (goodsbasic.type == 10) {
						let equip_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, goodsbasic.type_id, false)
						if (!equip_cfg) {
							return
						}
						if (equip_cfg.star == 2 && ((goodsbasic.color == 4 && equip_cfg.class_type == 0) || (goodsbasic.color == 5 && equip_cfg.class_type == 1))) {
							//let index = goodsbasic.sex == 1 && 1 || 4
							if (goodsbasic.sex == 0) {
								getTabIndex(0, equip_cfg.stage - 4)
								getTabIndex(4, equip_cfg.stage - 4)
							} else if (goodsbasic.sex == 1) {
								getTabIndex(0, equip_cfg.stage - 4)
							} else if (goodsbasic.sex == 2) {
								getTabIndex(4, equip_cfg.stage - 4)
							}
						} else if ((equip_cfg.star == 2 && goodsbasic.color == 5 && equip_cfg.class_type == 0) || (equip_cfg.star == 3 && goodsbasic.color == 5 && equip_cfg.class_type == 1)) {
							if (goodsbasic.sex == 0) {
								getTabIndex(1, equip_cfg.stage - 5)
								getTabIndex(5, equip_cfg.stage - 5)
							} else if (goodsbasic.sex == 1) {
								getTabIndex(1, equip_cfg.stage - 5)
							} else if (goodsbasic.sex == 2) {
								getTabIndex(5, equip_cfg.stage - 5)
							}
						} else if (equip_cfg.star == 3 && goodsbasic.color == 5 && equip_cfg.class_type == 0) {
							if (goodsbasic.sex == 0) {
								getTabIndex(2, equip_cfg.stage - 7)
								getTabIndex(6, equip_cfg.stage - 7)
								getTabIndex(3, equip_cfg.stage - 9)
								getTabIndex(7, equip_cfg.stage - 9)
							} else if (goodsbasic.sex == 1) {
								getTabIndex(2, equip_cfg.stage - 7)
								getTabIndex(3, equip_cfg.stage - 9)
							} else if (goodsbasic.sex == 2) {
								getTabIndex(6, equip_cfg.stage - 7)
								getTabIndex(7, equip_cfg.stage - 9)
							}
						} else if (equip_cfg.star == 3 && (goodsbasic.color == 6 || goodsbasic.color == 7) && equip_cfg.class_type == 0) {
							if (goodsbasic.sex == 0) {
								getTabIndex(3, equip_cfg.stage - 9)
								getTabIndex(7, equip_cfg.stage - 9)
							} else if (goodsbasic.sex == 1) {
								getTabIndex(3, equip_cfg.stage - 9)
							} else if (goodsbasic.sex == 2) {
								getTabIndex(7, equip_cfg.stage - 9)
							}
						}
					}
				}
			}
			let red
			for (let i in need_refresh_list) {
				let vo = need_refresh_list[i]
				red = this.EquipTabCanCom(config_compose_menu, i)
				this.equip_red_list[vo[0]][vo[1]] = red
			}

			if (!red) {
				for (let _ in this.equip_red_list) {
					let list1 = this.equip_red_list[_]
					for (let _ in list1) {
						let vo = list1[_]
						if (vo) {
							red = true
						}
					}
				}
			}
			this.Fire(CompositeModel.UPDATE_EQUIP_RED)
			this.ChangeVar("equip_red_dot", red)
			RedDotController.ins.up(RedKey.GOD_EQUIPMENT_COMPOSITE, red ? 1 : 0)
		}

		this.EquipTabCanCom = (config_compose_menu, id?) => {
			let sec_cfg = config_compose_menu[Number(id)]
			if (sec_cfg) {
				if (role_mgr.mainRoleInfo.level >= sec_cfg.open_lv) {
					let goods_list = erlang_parser.Parse(sec_cfg.list)
					let flag = false
					////////////////////////////////////////////////////////////-
					//特殊处理 装备合成 前面1-6 都是同样的消耗材料  只用就算一次 //
					////////////////////////////////////////////////////////////-
					let ans1 = this.EquipCanComposite(goods_list[0], true)
					let ans2 = this.EquipCanComposite(goods_list[2], true)
					let ans3 = this.EquipCanComposite(goods_list[4], true)
					if (ans1[0] || ans2[0] || ans3[0]) {
						return true
					}
				}
			}
			return false
		}
	}



	public static GetInstance() {
		if (!CompositeModel.Instance) {
			CompositeModel.Instance = new CompositeModel()
		}
		return CompositeModel.Instance
	}
}
window["CompositeModel"] = CompositeModel