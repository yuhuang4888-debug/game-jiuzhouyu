import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { CompositeModel } from "./CompositeModel"

export enum RevelationEvent {
	REQUEST_PROTO = "RE1",
	OPEN_VIEW = "RE2",
	UPDATE_SUIT_DATA = "RE3",
	SELECT_DEVOUR_ITEM = "RE4",
	UPDATE_EQUIP_DATA = "RE5",
	UPDATE_FIGURE_ID = "RE6",
	EQUIP_LV_UP_SUCCESS = "RE7",
	EQUIP_DEVOUR_SUCCESS = "RE8",
	SKILL_LV_UP = "RE9",
	UPDATE_EQUIP_RED = "RE10",
	UPDATE_DEVOUR_RED = "RE11",
	UPDATE_LV_RED = "RE12",
	DEVOUR_EQUIP = "RE13",
	SELECT_DEVOUR_MAT = "RE14",
	UPDATE_POWER = "RE15",
	SELECT_SUIT_NAME = "RE16"
}

export enum RevelationToolTipsBtn {
	unload = 2,
	replace = 1,
	upShelf = 0,
	close = 3,
	outShelf = 4
}
window["RevelationEvent"] = RevelationEvent
window["RevelationToolTipsBtn"] = RevelationToolTipsBtn
export class RevelationModel extends EventDispatcher {
	CheckDevourRed
	CheckEquipRed
	CheckSkillRed
	GetBagFullList
	GetEquipTypeName
	GetRedDot
	GetWearEquipByPos
	GetWearEquipInfo
	NameList
	ReSetDevour
	SelectExp
	SelectList
	equipData

	public static PosIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	public static StarList = [3, 5, 7, 10]
	public static GOODS_TYPE = 72
	skillRed: boolean
	static instance: any
	InitConfig: () => void
	public constructor() {
		super()
		this.SelectList = []
		this.SelectExp = 0
		this.equipData = []
		this.NameList = ["武器", "头盔", "项链", "上衣", "护符", "下装", "手镯", "护手", "戒指", "鞋子"]
		let goods_model = GoodsModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_RevelationEvent = RevelationEvent

		this.GetBagFullList = () => {
			let list = []
			let bagList = goods_model.revelation_bag_list
			for (let i = 0; i < bagList.length; i++) {
				list.push(bagList[i])
			}
			table.sort(list, (a?, b?) => {
				if (a.star != b.star) {
					return b.star < a.star
				} else if (a.equip_type != b.equip_type) {
					return a.equip_type < b.equip_type
				} else {
					return b.type < a.type
				}
			})
			let count = bagList.length
			let num = 24 - count % 6
			for (let i = 0; i < num; i++) {
				table.insert(list, { type_id: 0 })
			}
			return list
		}

		this.GetWearEquipByPos = (pos?) => {
			if (pos != null) {
				let revelation_list = goods_model.revelation_equip_list
				return revelation_list && revelation_list[pos - 1]
			}
		}

		this.GetWearEquipInfo = (goodsId?) => {
			return goods_model.revelation_equip_dic[goodsId]
		}

		this.CheckEquipRed = () => {
			if (!common_mgr.CheckFuncOpenState("RevelationEquipView", true)) {
				return
			}
			red_dot_mgr.ClearRedStatus(local_ModuleType.REVE_EQUIP_RED)
			let equipList = goods_model.revelation_equip_list
			let list = goods_model.revelation_bag_list
			if (!equipList || !list) {
				return
			}
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.type == RevelationModel.GOODS_TYPE) {
					let curEquip = equipList[vo.equip_type - 1]
					if (!curEquip || curEquip.rating < vo.rating) {
						red_dot_mgr.SetRedStatus(local_ModuleType.REVE_EQUIP_RED, vo.equip_type, true)
						RedDotController.ins.add(RedKey.REVE_EQUIP_RED + vo.equip_type, RedKey.REVE_DEVOUR_RED);
						RedDotController.ins.up(RedKey.REVE_EQUIP_RED + vo.equip_type, 1);
					}
				}
			}
			this.Fire(local_RevelationEvent.UPDATE_EQUIP_RED)
		}

		this.CheckDevourRed = () => {
			if (!common_mgr.CheckFuncOpenState("RevelationEquipView", true)) {
				return
			}
			if (!this.equipData || !this.equipData.gathering) {
				return
			}
			let equipList = goods_model.revelation_equip_list
			if (equipList && equipList.length > 0) {
				let Revelationequipattr
				let Revelationequipgathering
				let Revelationequipswallow
				let load_call_back = () => {
					if (Revelationequipattr && Revelationequipgathering && Revelationequipswallow) {
						red_dot_mgr.ClearRedStatus(local_ModuleType.REVE_DEVOUR_RED)
						for (let _tmpi in equipList) {
							var vo = equipList[_tmpi]
							if (vo) {
								let equipCfg = Revelationequipattr[vo.type_id]
								if (!equipCfg || equipCfg.star < 3) {
								} else {
									let equip_type = vo.equip_type
									let curVo = this.equipData.gathering[10 - equip_type]
									if (vo && curVo) {
										let curExp = curVo.exp
										let curCfg = Revelationequipgathering[equip_type + "@" + curVo.lv]
										if (curCfg) {
											let needExp = curCfg.exp
											let nextCfg = Revelationequipgathering[equip_type + "@" + (curVo.lv + 1)]
											if (nextCfg && curExp >= needExp) {
												red_dot_mgr.SetRedStatus(local_ModuleType.REVE_DEVOUR_RED, 10 + equip_type, true)
												RedDotController.ins.add(RedKey.REVE_DEVOUR_RED + 10 + equip_type, RedKey.REVE_DEVOUR_RED);
												RedDotController.ins.up(RedKey.REVE_DEVOUR_RED + 10 + equip_type, 1);
											} else if (nextCfg) {
												let haveExp = 0
												let typeList = goods_model.revelation_type_dic[equip_type]
												if (typeList) {
													for (let _tmpi in typeList) {
														var vo = typeList[_tmpi]
														if (vo) {
															if (Revelationequipswallow[vo.type_id]) {
																haveExp = haveExp + Revelationequipswallow[vo.type_id].exp
															}
														}
													}
													if (haveExp + curExp >= needExp) {
														red_dot_mgr.SetRedStatus(local_ModuleType.REVE_DEVOUR_RED, equip_type, true)
														RedDotController.ins.add(RedKey.REVE_DEVOUR_RED + equip_type, RedKey.REVE_DEVOUR_RED);
														RedDotController.ins.up(RedKey.REVE_DEVOUR_RED + equip_type, 1);
													}
												}
											}
										}
									}
								}
							}
						}
						this.Fire(local_RevelationEvent.UPDATE_DEVOUR_RED)
						GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
						this.Fire(RevelationEvent.EQUIP_DEVOUR_SUCCESS, true)
					}
				}
				ResManager.GetInstance().LoadGameConfig(this, "config_revelation_equip_attr", false, undefined, (cfg) => {
					Revelationequipattr = cfg
					load_call_back()
				})
				ResManager.GetInstance().LoadGameConfig(this, "config_revelation_equip_gathering", false, undefined, (cfg) => {
					Revelationequipgathering = cfg
					load_call_back()
				})
				ResManager.GetInstance().LoadGameConfig(this, "config_revelation_equip_swallow", false, undefined, (cfg) => {
					Revelationequipswallow = cfg
					load_call_back()
				})
			}
		}

		this.CheckSkillRed = () => {
			let showRed = false
			let devourList = this.equipData.gathering
			let min = null
			let Revelationequipskill

			let load_call_back = () => {
				if (devourList && devourList.length > 0) {
					for (let _tmpi in devourList) {
						var vo = devourList[_tmpi]
						if (vo.flag && vo.flag == 1) {
							if (min == null || vo.lv < min) {
								min = vo.lv
							}
						} else {
							min = 0
							break
						}
					}
				}
				if (min) {
					let maxSkillLv = null
					let tempMin = null
					for (let key in Revelationequipskill) {
						var vo = Revelationequipskill[key]
						let skillInfo = JSON.parse(vo.skill_id)[0]
						if (Number(key) <= min && (!tempMin || tempMin < Number(key))) {
							tempMin = Number(key)
							maxSkillLv = Number(skillInfo[1])
						}
					}
					let SKilllist = this.equipData.skill_list
					if (maxSkillLv) {
						showRed = true
						if (SKilllist.length > 0) {
							for (let _tmpi in SKilllist) {
								var SKillVo = SKilllist[_tmpi]
								showRed = SKillVo.lv < maxSkillLv
							}
						}
					}
				}
				this.ChangeVar("skillRed", showRed)
			}
			Revelationequipskill = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_skill
			load_call_back()
		}

		this.GetEquipTypeName = (equip_type?) => {
			return this.NameList[equip_type - 1]
		}

		this.ReSetDevour = () => {
			this.SelectList = []
			this.SelectExp = 0
		}

		this.GetRedDot = () => {
			let reds = red_dot_mgr.GetRedStatus(local_ModuleType.REVE_EQUIP_RED)
			let reds2 = red_dot_mgr.GetRedStatus(local_ModuleType.REVE_DEVOUR_RED)
			return (reds && reds > 0) || (reds2 && reds2 > 0) || this.skillRed || CompositeModel.GetInstance().GetRevelationRedDot()
		}
	}

	public static GetInstance() {
		if (!RevelationModel.instance) {
			RevelationModel.instance = new RevelationModel()
		}
		return RevelationModel.instance
	}
}
window["RevelationModel"] = RevelationModel