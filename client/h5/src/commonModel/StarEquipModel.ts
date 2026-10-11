import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { CommonManager } from "../common/CommonManager"
import { GoodsModel } from "./GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { Message } from "../sysInfo/SysInfoController"
import { MainFunc } from "./MainUIModel"
import { Trim } from "../util/Util"
import { chcModel } from "./chcModel"

export class StarEquipModel extends EventDispatcher {
	BagIndex
	CanDevour
	CheckDevourRed
	ClearComSelect
	ClearDevourSelect
	CreateDevourList
	CurExp
	DevourIndex
	FirstCheckRed
	GetBagList
	GetColorDropData
	GetComTabName
	GetDevourList
	GetEquipStar
	GetPageCondition
	GetPageEquip
	GetPageEquipInfo
	GetPageTypeEquip
	GetPosDropData
	GetRedDot
	GetTabIdList
	GetWearEquip
	InitComList
	OldSelectTab
	OpenLv
	SelectComGoods
	SelectComMat
	SelectDevourGoods
	SetOnePageInfo
	SetStarPageInfo
	StarEquipIsActive
	UpdateComRed
	UpdateEquipRed
	UpdatePageUnLockRed
	activeStar
	bagSelectIndex
	canComEquip
	canUnlockPage
	comExtraList
	comPoint
	comRatio
	comRed
	comSelect
	comSpNumList
	devColor
	devourExp
	devourList
	devourLv
	devourPower
	devourRed
	devourSelect
	devourTips
	dropColor
	dropPos
	equipRedList
	notDevourColor
	oldMaxStar
	pageInfo
	starEquip_tab_id_list
	starEquip_tab_id_obj_
	starPower
	totalEquipRed
	totalStar
	typePreviewCache
	static _instance
	devSingle
	masterRed
	public static waitShowMaster
	public static waitShowMasterInfo

	public static OPEN_VIEW = "SE1"
	public static SEND_PROTO = "SE2"
	public static REFRESH_RED = "SE3"
	public static DEVOUR_RED_DOT = "SE4"
	public static ADD_DEVOUR_EFFECT = "SE5"
	public static UPDATE_DEVOUR_TAB = "SE6"
	public static UPDATE_DEVOUR_DROP = "SE7"
	public static UPDATE_STAR_INFO = "SE8"
	public static UPDATE_PAGE_RED = "SE9"
	public static PREVIEW_TOOLTIPS = "SE10"
	public static STAR_MASTER_INFO = "SE11"
	public static UPDATE_DEVOUR_DATA = "SE12"
	public static COM_FAIL = "SE13"
	public static COM_SUCCESS = "SE14"
	public static REQUEST_DEVOUR = "SE15"
	public static UPDATE_ADD_EXTRA = "SE16"
	public static MASTR_UP = "SE17"
	public static COM_REQUEST = "SE18"
	public static ACTIVE_PAGE = "SE19"
	public static DEVOUR_SUCCESS = "SE20"
	public static SELECT_COM_MAT = "SE21"
	public static CLOSE_VIEW = "SE22"
	public static COMPARED_EQUIP = "SE23"
	public static CLOSE_COMPARED = "SE24"
	public static TRANSFROM_PREVIEW = "SE25"
	public static UPDATE_COM_TIME = "SE26"
	public static OPEN_COMVIEW = "SE27"
	public static WAIT_SHOW_UP_MASTER = "SE28"

	public static posList = [[120, 245], [168, 338], [252, 390], [355, 390], [442, 340], [495, 248], [142, 113], [465, 113], [306, 17], [300, 202]]
	public static starMasterPos = [[21, 63], [134, 63], [165, 192], [290, 125], [403, 197], [492, 132]]
	public static GOODS_TYPE = 79
	public static ComRuleId = 79

	public constructor() {
		super()
		this.totalEquipRed = false
		this.equipRedList = []
		this.pageInfo = {}
		this.dropPos = 0
		this.dropColor = 0
		this.notDevourColor = 6
		this.comSpNumList = []
		this.CurExp = 0
		this.starPower = 0
		this.oldMaxStar = 0
		this.OpenLv = 580
		this.devourList = []
		this.devourSelect = []
		this.devourLv = 0;
		this.devourExp = 0;
		this.devourPower = 0;
		this.OldSelectTab = null;
		this.BagIndex = 0
		this.DevourIndex = 1
		this.bagSelectIndex = 1;
		this.comSelect = [];
		this.comPoint = 0;
		this.comExtraList = [];
		this.comRatio = null;
		this.typePreviewCache = [];
		this.FirstCheckRed = true;
		this.devourTips = true;
		this.totalStar = 0
		this.devColor = 0
		this.activeStar = 0

		let local_Erlang = ErlangParser.GetInstance()
		let global_sys = GlobalEventSystem
		let local_eventName = EventName
		let local_goodsIns = GoodsModel.GetInstance()

		this.GetPageEquipInfo = (page?) => {
			return this.pageInfo[page]
		}

		this.GetPosDropData = (cfg_constellation_pos) => {
			let cfg = cfg_constellation_pos //Config.config_constellation_pos
			let drop = []
			table.insert(drop, { id: 0, content: "任意部位", cond: 0 })
			if (cfg) {
				for (let i = 1; i <= 10; i++) {
					table.insert(drop, { id: i, content: cfg[i].name, cond: i })
				}
			}
			return drop
		}

		this.GetColorDropData = () => {
			let drop = []
			let colorList = [3, 4, 5, 7]
			table.insert(drop, { id: 0, content: "任意品质", cond: 0 })
			for (let key in colorList) {
				let vo = colorList[key]
				table.insert(drop, { id: vo, content: ColorUtil.GetColorName(vo) + "装备", cond: vo })
			}
			return drop
		}

		this.GetBagList = (pos?, color?) => {
			let list = local_goodsIns.starEquipBagList
			let showList = []
			let vo = null
			for (let key in list) {
				vo = list[key]
				if ((pos == 0 || vo.subtype == pos) && (vo.color >= color)) {
					table.insert(showList, vo)
				}
			}
			for (let i = showList.length; i < 100; i++) {
				table.insert(showList, { none: true })
			}
			return showList
		}

		this.CreateDevourList = (cfg_constellation_equip) => {
			this.devourList = []
			let list = local_goodsIns.starEquipBagList

			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (((!cfg_constellation_equip[vo.type_id] || vo.star >= 2) || vo.color >= this.notDevourColor) || vo.subtype > 6) {
				} else {
					table.insert(this.devourList, vo)
				}
			}
		}

		this.GetDevourList = (cfg_constellation_equip) => {
			let list = this.devourList
			this.devourSelect = []
			let exp = 0
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if ((this.devColor == 1 && vo.color <= 3) || (this.devSingle == 1 && vo.star <= 1)) {
					let curEquip = this.GetWearEquip(vo.page, vo.subtype)
					if (!curEquip || curEquip.rating < vo.rating) {
					} else {
						this.devourSelect[vo.goods_id] = vo.goods_num
						exp = exp + cfg_constellation_equip[vo.type_id].decompose_exp
					}
				}
			}
			this.ChangeVar("CurExp", exp)
			this.Fire(StarEquipModel.UPDATE_DEVOUR_DROP)
		}

		this.SelectDevourGoods = (cfg_constellation_equip, id?, type_id?, bool?) => {
			let cfg = cfg_constellation_equip[type_id]
			if (cfg) {
				if (bool) {
					this.ChangeVar("CurExp", this.CurExp + cfg.decompose_exp)
					this.devourSelect[id] = true
				} else if (this.devourSelect[id]) {
					this.ChangeVar("CurExp", this.CurExp - cfg.decompose_exp)
					this.devourSelect[id] = null
				}
			}
		}

		this.ClearDevourSelect = () => {
			this.devourSelect = []
			this.ChangeVar("CurExp", 0)
		}

		this.SelectComGoods = (cfg_constellation_equip, id?, type_id?, bool?) => {
			let curComCfg = cfg_constellation_equip[type_id]
			if (curComCfg) {
				if (bool) {
					if (this.comPoint >= Number(this.comRatio[2])) {
						Message.show("成功率已达到最大")
						return
					}
					this.ChangeVar("comPoint", this.comPoint + Number(curComCfg.compose_info))
					this.comExtraList[id] = true
				} else {
					this.ChangeVar("comPoint", this.comPoint - Number(curComCfg.compose_info))
					this.comExtraList[id] = null
				}
				this.Fire(StarEquipModel.UPDATE_ADD_EXTRA)
			}
		}

		this.ClearComSelect = () => {
			this.comExtraList = []
			this.comSelect = []
			this.ChangeVar("comPoint", 0)
		}

		this.GetPageEquip = (page?) => {
			return local_goodsIns.starEquipList[page] || {}
		}

		this.GetPageTypeEquip = (page?, pos?) => {
			let list = local_goodsIns.starEquipBagList
			let showList = []
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.page == page && vo.subtype == pos) {
					table.insert(showList, vo)
				}
			}
			return showList
		}

		this.GetWearEquip = (page?, pos?) => {
			let list = local_goodsIns.starEquipList
			return list[page] && list[page][pos]
		}

		this.SetStarPageInfo = (cfg_compose_menu, cfg_constellation_compose, item_list?) => {
			if (item_list) {
				for (let _tmpi in item_list) {
					let vo = item_list[_tmpi]
					let oldInfo = this.pageInfo[vo.page]
					if (oldInfo) {
						if (vo.normal_num > oldInfo.normal_num && ((vo.normal_num == 2 || vo.normal_num == 4) || vo.normal_num == 6)) {
							this.Fire(StarEquipModel.OPEN_VIEW, "StarEquipActiveSuit", vo.page, vo.normal_num, 1)
						} else if (vo.special_num > oldInfo.special_num && (vo.special_num == 2 || vo.special_num == 4)) {
							this.Fire(StarEquipModel.OPEN_VIEW, "StarEquipActiveSuit", vo.page, vo.special_num, 2)
						}
					}
					this.pageInfo[vo.page] = vo
				}
			}
			if (this.FirstCheckRed) {
				this.FirstCheckRed = false
				this.UpdateEquipRed()
				this.InitComList(cfg_compose_menu, cfg_constellation_compose)
				this.UpdateComRed(cfg_constellation_compose)
			}
		}

		this.SetOnePageInfo = (scmd?) => {
			let list = this.pageInfo[scmd.page]
			if (list) {
				list.attr = scmd.attr
			}
		}

		this.InitComList = (cfg_compose_menu, cfg_constellation_compose) => {
			let [is_set, list, obj] = this.GetTabIdList(cfg_compose_menu, cfg_constellation_compose, StarEquipModel.ComRuleId, null)
			this.starEquip_tab_id_list = list
			this.starEquip_tab_id_obj_ = obj
		}

		this.GetComTabName = (cfg_compose_menu, config_compose_menu_id, cfg_constellation_compose) => {
			let tab_bar_name_list = []
			let cfg = cfg_compose_menu[StarEquipModel.ComRuleId]
			//let tab_id_list = this.starEquip_tab_id_list
			let star_id_cfg = cfg_constellation_compose
			let com_id_cfg = config_compose_menu_id
			if (cfg && com_id_cfg) {
				let menu_list = local_Erlang.Parse(cfg.list)
				for (let index in menu_list) {
					let sub_id = Number(menu_list[index])
					//let sub_id_obj = menu_list[index]
					let sub_id_cfg = com_id_cfg[sub_id]
					let bar_name = null
					if (sub_id_cfg) {
						bar_name = []
						bar_name[0] = sub_id_cfg.name
						bar_name[1] = []
					}
					let sub_cfg = cfg_compose_menu[sub_id]
					let sub_menu_list = local_Erlang.Parse(sub_cfg.list)
					for (let _tmpi in sub_menu_list) {
						let sub_sub_id = sub_menu_list[_tmpi]
						let sub_sub_id_cfg = star_id_cfg[Number(sub_sub_id)]
						if (sub_sub_id_cfg) {
							let cond = JSON.parse(sub_sub_id_cfg.condition)
							let select = true
							for (let _tmpi in cond) {
								let vo = cond[_tmpi]
								if (vo[0] == "constelltion_page") {
									if (!this.StarEquipIsActive(Number(vo[1]))) {
										select = false
									}
								}
							}
							if (select) {
								table.insert(bar_name[1], sub_sub_id_cfg.id)
							}
						}
					}
					table.insert(tab_bar_name_list, bar_name)
				}
			}
			return tab_bar_name_list
		}

		this.UpdateEquipRed = (list?) => {
			if (!CommonManager.GetInstance().CheckFuncOpenState("StarEquipView", true)) {
				return false
			}
			if (!list) {
				this.equipRedList = []
				this.totalEquipRed = false
			}
			list = list || local_goodsIns.starEquipBagList
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (this.pageInfo[vo.page] && this.pageInfo[vo.page].is_active == 1) {
					let wearEquip = this.GetWearEquip(vo.page, vo.subtype)
					let redType = 0
					if (!wearEquip || vo.rating > wearEquip.rating) {
						redType = 1
					}
					if ((((vo.color >= 4 && vo.addition_attrlist.length > 0) && wearEquip) && wearEquip.addition_attrlist.length == 0) && wearEquip.color > vo.color) {
						redType = redType + 2
					}
					if (redType != 0) {
						let pageData = this.equipRedList[vo.page] || {}
						pageData[vo.subtype] = redType
						this.equipRedList[vo.page] = pageData
						this.totalEquipRed = true
					}
				}
			}
			global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			this.Fire(StarEquipModel.REFRESH_RED, 1)
		}

		this.CheckDevourRed = (cfg_constellation_equip) => {
			if (!CommonManager.GetInstance().CheckFuncOpenState("StarEquipView", true)) {
				return false
			}
			let length = local_goodsIns.starEquipBagList.length
			let red = false
			if (length > 70) {
				let list = local_goodsIns.starEquipBagList
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (this.CanDevour(cfg_constellation_equip, vo)) {
						red = true
						break
					}
				}
			}
			this.devourRed = red
			RedDotController.ins.up(RedKey.STAR_EQUIP_DEVOUR, red ? 1 : 0)
			global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			this.Fire(StarEquipModel.REFRESH_RED, 2)
		}

		this.CanDevour = (cfg_constellation_equip, vo?) => {
			if ((cfg_constellation_equip[vo.type_id]) && (!vo.star || vo.star < 2) && vo.color < ColorType.ORANGE) {
				let wearEquip = this.GetWearEquip(vo.page, vo.subtype)
				if (wearEquip && vo.rating <= wearEquip.rating) {
					return true
				}
			}
		}

		this.GetPageCondition = (data?) => {
			if (data[0] == "constellation_num") {
				let needNum = Number(data[3])
				let needColor = Number(data[4])
				let pageList = local_goodsIns.starEquipList[Number(data[1])]
				if (pageList) {
					for (let _tmpi in pageList) {
						let vo = pageList[_tmpi]
						if ((vo && vo.subtype < 7) && vo.color >= needColor) {
							needNum = needNum - 1
							if (needNum <= 0) {
								return [true, Number(data[3])]
							}
						}
					}
				}
				return [false, Number(data[3]) - needNum]
			} else if (data[0] == "evolution_lv") {
				let Num = chcModel.GetInstance().GetFuncLvAll(chcModel.CHCTYPE.EVO, Number(data[1]))
				return [Num >= Number(data[2]), Num]
			} else if (data[0] == "strength_lv") {
				let Num = chcModel.GetInstance().GetFuncLvAll(chcModel.CHCTYPE.STREN, Number(data[1]))
				return [Num >= Number(data[2]), Num]
			}
			return [false, 0]
		}

		this.SelectComMat = (goods_id?, index?, bool?) => {
			if (bool) {
				this.comSelect[goods_id] = index
			} else {
				this.comSelect[goods_id] = null
			}
			this.Fire(StarEquipModel.SELECT_COM_MAT, goods_id, bool, index)
		}

		this.GetRedDot = () => {
			return (((this.totalEquipRed || this.comRed) || this.devourRed) || this.masterRed) || this.canUnlockPage != null || chcModel.GetInstance().GetReddotAll()
		}

		this.StarEquipIsActive = (page?) => {
			return this.pageInfo[page] && this.pageInfo[page].is_active != 0
		}

		this.UpdatePageUnLockRed = (cfg_constellation_page) => {
			if (!cfg_constellation_page) {
				return
			}
			this.canUnlockPage = null
			let unlockPage = null
			for (let key in this.pageInfo) {
				if (!this.pageInfo[key] || (!this.pageInfo[key].is_active || this.pageInfo[key].is_active == 0)) {
					unlockPage = this.pageInfo[key].page
					break
				}
			}
			if (unlockPage != null) {
				let pageCfg = cfg_constellation_page[unlockPage]
				if (pageCfg) {
					let cond = JSON.parse(pageCfg.condition)
					let allFinish = true
					let lock
					for (let _tmpi in cond) {
						let vo = cond[_tmpi]
						lock = this.GetPageCondition(vo)[0]
						if (!lock) {
							allFinish = false
							break
						}
					}
					if (allFinish) {
						this.canUnlockPage = unlockPage
					}
				}
			}
			this.Fire(StarEquipModel.REFRESH_RED, 3)
			global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
		}

		this.GetTabIdList = (cfg_compose_menu, cfg_constellation_compose, rule_id?, same?) => {
			let tab_id_list = []
			let tab_id_obj = []
			let cfg = cfg_compose_menu[rule_id]
			if (!cfg) {
				return [false, null, null]
			}
			let menu_list = local_Erlang.Parse(cfg.list)
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
				let [is_set, list, obj] = this.GetTabIdList(cfg_compose_menu, cfg_constellation_compose, sub_id, same)
				if (is_set == false) {
					tab_id_obj[sub_id] = menu_list
					table.insert(tab_id_list, menu_list)
					for (let i = menu_list.length - 1; i >= 0; i -= 1) {
						let id = Number(menu_list[i])
						if (cfg_constellation_compose[id]) {
							let cond = JSON.parse(cfg_constellation_compose[id].condition)
							for (let _tmpi in cond) {
								let vo = cond[_tmpi]
								if (vo[0] == "constelltion_page") {
									if (!this.StarEquipIsActive(Number(vo[1]))) {
										table.remove(menu_list, i)
									}
								}
							}
						}
					}
					break
				} else {
					tab_id_obj[sub_id] = obj
					table.insert(tab_id_list, list)
				}
			}
			return [true, tab_id_list, tab_id_obj]
		}

		this.UpdateComRed = (cfg_constellation_compose) => {
			//this:GetGameConfig("config_constellation_compose",(comCfg?) => {
			let list = this.starEquip_tab_id_list
			let comRed = false
			if (list) {
				for (let _tmpi in list) {
					let tabList = list[_tmpi]
					for (let _tmpi in tabList) {
						let subList = tabList[_tmpi]
						for (let _tmpi in subList) {
							let subVo = subList[_tmpi]
							if (this.canComEquip(cfg_constellation_compose, subVo)) {
								comRed = true
								break
							}
						}
					}
					if (comRed) {
						break
					}
				}
			}
			if (this.comRed != comRed) {
				this.comRed = comRed
				RedDotController.ins.up(RedKey.STAR_EQUIP_COM, comRed ? 1 : 0)
				this.Fire(StarEquipModel.REFRESH_RED, 5)
			}
			//this:DestoryGameConfig("config_constellation_compose", false)
			//}
			//, false)
		}

		this.canComEquip = (cfg_constellation_compose, comId?) => {
			let curCfg = cfg_constellation_compose[Number(comId)]
			if (curCfg) {
				let com = true
				let reList = JSON.parse(curCfg.regular_mat)
				for (let _tmpi in reList) {
					let vo = reList[_tmpi]
					let goodsNum = local_goodsIns.GetTypeGoodsNum(vo[1])
					if (goodsNum < Number(vo[2])) {
						com = false
						break
					}
				}
				let irList = JSON.parse(curCfg.irregular_mat)
				let irNum = irList.length == 0
				for (let _tmpi in irList) {
					let vo = irList[_tmpi]
					irNum = local_goodsIns.GetTypeGoodsNum(vo) > 0
					if (irNum) {
						break
					}
				}
				return com && irNum
			}
			return false
		}

		this.GetEquipStar = (cfg_constellation_equip, type_id?) => {
			let star = 0
			let cfg = cfg_constellation_equip[type_id]
			if (cfg) {
				let attrList = JSON.parse(Trim(cfg.extra_attr))
				for (let i in attrList) {
					let vo = attrList[i]
					star = star + Number(vo[3])
				}
			}
			return star
		}
	}

	public static GetInstance(): StarEquipModel {
		if (!StarEquipModel._instance) {
			StarEquipModel._instance = new StarEquipModel()
		}
		return StarEquipModel._instance
	}
}
window["StarEquipModel"] = StarEquipModel