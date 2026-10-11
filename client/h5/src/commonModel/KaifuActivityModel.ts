import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { CustomActivityModel } from "./CustomActivityModel"
import { GoodsModel } from "./GoodsModel"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { Alert, Alert_Type } from "../alert/Alert"
import { CookieWrapper } from "../common/CookieWrapper"
import { table } from "../common/table"
import { TaskModel } from "./TaskModel"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, HtmlColorTxt } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { WeekCardModel } from "./WeekCardModel"



export const KAIFUACTIVITY_CONFIG = {
	BOOKOFCONTRACT_TAB: 0,
	BOOKOFCONTRACT_ITEM: 1,
	INVESTMENT_TYPES: 2,
	INVESTMENT_REWARDS: 3,
	INVESTMENT_ITEM: 4
}

export const KaifuActivityModelEvent = { OPEN_KAIFUACTIVITYVIEW: "KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW", OPEN_BOOKACTIVATEVIEW: "KaifuActivityModelEvent.OPEN_BOOKACTIVATEVIEW", REQUEST_BOOK_DATA: "KaifuActivityModelEvent.REQUEST_BOOK_DATA", REQUEST_BOOK_ALL_DATA: "KaifuActivityModelEvent.REQUEST_BOOK_ALL_DATA", UPDATE_BOOK_DATA: "KaifuActivityModelEvent.UPDATE_BOOK_DATA", REQUEST_BOOK_GET: "KaifuActivityModelEvent.REQUEST_BOOK_GET", SELECT_LVINVEST_LEVEL: "KaifuActivityModelEvent.SELECT_LVINVEST_LEVEL", REQUEST_INVEST_DATA: "KaifuActivityModelEvent.REQUEST_INVEST_DATA", INVEST_DATA_UPDATE: "KaifuActivityModelEvent.INVEST_DATA_UPDATE", SEND_INVEST_LEVEL: "KaifuActivityModelEvent.SEND_INVEST_LEVEL", GET_INVEST: "KaifuActivityModelEvent.GET_INVEST", UPDATE_TAB_RED: "KaifuActivityModelEvent.UPDATE_TAB_RED", OPEN_TOP_IVITY_VIEW: "KaifuActivityModelEvent.OPEN_TOP_IVITY_VIEW", SELECT_TOP_LEVEL: "KaifuActivityModelEvent.SELECT_TOP_LEVEL" }
export const BookOfContractType = { first_recharge: "first_recharge", battle_power: "battle_power", equip_ids: "equip_ids", vip: "vip", month_card: "month_card", diamond_investment: "diamond_investment", equip: "equip", attr: "attr", boss: "boss", boss_num: "boss_num", equip_suit: "equip_suit", active_magic: "active_magic", lv: "lv", dun: "dun", guild_join: "guild_join", husong: "husong", compose: "compose", jjc: "jjc", turn: "turn", wash_equip_status: "wash_equip_status", rune_dun: "rune_dun", seal_status: "seal_status", wear_equip_status: "wear_equip_status", combat: "combat", active_suit: "active_suit", dun_dragon: "dun_dragon" }
export const investType = { level: 1, month: 2, vip: 3, top: 5, king: 6, extreme: 7, god: 8 }
export const ViewClassCFG = {
	[0]: { id: 1, class: "LVinvestView", label: { label: "等级投资" }, bg: "uity_060.jpg" },
	[1]: { id: 2, class: "MonthCardView", label: { label: "月卡投资" }, bg: "uikfhd_yktz_001.jpg" },
	[2]: { id: 3, class: "VIPinvestView", label: { label: "VIP投资" } },
	[4]: { id: 5, class: "TopInvestView", label: { label: "巅峰投资" }, showDay: 3, bg: "uity_060.jpg" },
	[5]: { id: 6, class: "zKingInvestView", label: { label: "王者投资" }, showDay: 3, bg: "uity_060.jpg" },
	[6]: { id: 7, class: "zExtremeInvestView", label: { label: "至尊投资" }, showDay: 3, bg: "uity_060.jpg" },
	[7]: { id: 8, class: "zGodInvestView", label: { label: "神眷投资" }, showDay: 3, bg: "uity_060.jpg" }
}


window["KAIFUACTIVITY_CONFIG"] = KAIFUACTIVITY_CONFIG
window["KaifuActivityModelEvent"] = KaifuActivityModelEvent
window["BookOfContractType"] = BookOfContractType
window["investType"] = investType
window["ViewClassCFG"] = ViewClassCFG
export class KaifuActivityModel extends EventDispatcher {
	AddBookIcon
	BookChapterSkill
	BookChapterSkillOpen
	BookOfContractCondition
	BookOfContractItem
	BookOfContractItemList
	BookOfContractProgress
	BookOfContractTabCofByChapter
	InvestHasGet
	InvestOpen
	InvestRewordRedDot
	InvestShowIcon
	InvestTypeConf
	InvestViewLists
	KaifuActivityOpenFun
	MessageShow
	SetBookInfoData
	_BookInfoData
	_BookOfContractItemCof
	_BookOfContractTabCof
	_vipInvestRewardsConf
	allPrice
	canShowIcon
	changeBookData
	checkMoneyEnough
	checkMonthOpenStatus
	checkMonthReddot
	checkVIPReddot
	clickInvest
	curLevelCfg
	finishAll
	fullShowIconTime
	getBookChapterProgress
	getBookInfoData
	getBookInfoDataList
	getConfig
	getInvestData
	getInvestLevelByType
	getVIPRewardData
	getVIPcondition
	iconHasOpen
	iconIndex
	initConfig
	investCondition
	investConfig
	investOpenStatus
	investReddot
	investRewards
	investRewardsConf
	investRewardsHasGet
	investRewardsList
	investReword
	lvClick
	menuConfList
	monthCondition
	open_data
	parseVipCondition
	selectIndex
	setBookInfoRewardData
	setBookOpen
	setBookRedDot
	setImageAndName
	setInvestData
	setInvestLevelData
	setInvestReddot
	setInvestRewardData
	setLEVELReddot
	setMonthReddot
	setRequestData
	setVIPReddot
	sortBook
	sortInvest
	tabRedDot
	topInvestOpenFun
	upateInvestRedDot
	updateBookInfoData
	vipClick
	vipIInvestRewardsList
	GetInvestIconRedDot
	_InvestData
	CheckHaveMonthCard
	public static Instance: KaifuActivityModel
	public constructor() {
		super()

		if (KaifuActivityModel.Instance) {
			return
		}
		KaifuActivityModel.Instance = this

		this.clickInvest = [];
		this._BookOfContractItemCof = [];
		this._BookInfoData = [];
		this._BookOfContractTabCof = [];
		this._vipInvestRewardsConf = [];
		let local_KAIFUACTIVITY_CONFIG = KAIFUACTIVITY_CONFIG
		let local_Config = Config
		let server_time_model = ServerTimeModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let local_KaifuActivityModelEvent = KaifuActivityModelEvent
		let local_Number = Number
		let local_ColorUtil = ColorUtil
		let local_ColorType = ColorType
		//let local_Erlang = ErlangParser.GetInstance()
		let local_BookOfContractType = BookOfContractType
		//let local_RES = RES

		let local_GlobalEventSystem = GlobalEventSystem
		let refresh_icon_red_event = EventName.REFRESH_ACTIVITY_ICON_RED_DOT
		let role_mgr = RoleManager.GetInstance()
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_Message = Message
		let red_dot_mgr = RedDotManager.GetInstance()
		let cooie_wrapper = CookieWrapper.GetInstance()
		let local_TimeUtil = TimeUtil
		let res_mgr = ResManager.GetInstance()
		let local_investType = investType
		let config = []
		let _InvestData = []
		let _InvestLevelData = []
		let _investRewardsConf = []
		let showInvestIcon_ = []
		let Investmentitem = undefined
		this._InvestData = _InvestData
		this.initConfig = () => {
			config[local_KAIFUACTIVITY_CONFIG.BOOKOFCONTRACT_TAB] = Config.PRELOAD_SERVER_CONFIG.config_eternal_valley_chapter
			config[local_KAIFUACTIVITY_CONFIG.BOOKOFCONTRACT_ITEM] = Config.PRELOAD_SERVER_CONFIG.config_eternal_valley_stage
			config[local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES] = Config.PRELOAD_SERVER_CONFIG.config_investment_types
			config[local_KAIFUACTIVITY_CONFIG.INVESTMENT_REWARDS] = Config.PRELOAD_SERVER_CONFIG.config_investment_rewards
			Investmentitem = Config.PRELOAD_SERVER_CONFIG.config_investment_item
		}

		this.getConfig = (dun_type?) => {
			return config[dun_type]
		}

		this.BookOfContractTabCofByChapter = (chapter) => {
			let conf = this.GetBookOfContractTabCof()
			for (let key in conf) {

				let info = conf[key]
				if (info.id == chapter) {
					return info
				}
			}
			return null
		}

		this.BookOfContractItemList = (chapter) => {
			let list = []
			let conf = this.GetBookOfContractItemCof()
			for (let key in conf) {

				if (conf[key]) {
					let info = conf[key]
					if (info.chapter == chapter) {
						table.insert(list, info)
					}
				}
			}
			table.sort(list, (a?, b?) => {
				return this.sortBook(a, b)
			})
			return list
		}

		this.sortBook = (a?, b?) => {
			let aIndex = 200 - a.stage
			let bIndex = 200 - b.stage
			let info = this.getBookInfoData(a.chapter, a.stage)
			if (info && info.status == 1) {
				aIndex = aIndex + 100
			}
			if (info && info.status == 2) {
				aIndex = aIndex - 100
			}
			info = this.getBookInfoData(b.chapter, b.stage)
			if (info && info.status == 1) {
				bIndex = bIndex + 100
			}
			if (info && info.status == 2) {
				bIndex = bIndex - 100
			}
			return aIndex > bIndex
		}

		this.BookOfContractItem = (chapter?, stage?) => {
			let list = this.BookOfContractItemList(chapter)
			for (let key in list) {

				if (list[key]) {
					let info = list[key]
					if (info.stage == stage) {
						return info
					}
				}
			}
		}

		this.SetBookInfoData = (data?) => {
			for (let key in data.list) {

				if (data.list[key]) {
					let info = data.list[key]
					this._BookInfoData[info.chapter] = info
				}
			}
			this.AddBookIcon()
			this.Fire(local_KaifuActivityModelEvent.UPDATE_BOOK_DATA)
			this.setBookRedDot()
		}


		this.AddBookIcon = () => {
			if (!this.finishAll()) {
				let openday = server_time_model.GetOpenServerDay()
				let finish_task_id = TaskModel.GetInstance().newest_finish_task_id
				let icon = ActivityIconManager.GetInstance().getIconInfo("424@2")
				let icon_info = common_mgr.GetFunctionIconCfg("424@2")
				if (icon_info && openday >= icon_info.open_day
					&& ((icon_info.max_open_day > 0 && openday <= icon_info.max_open_day) || icon_info.max_open_day == 0)
					&& finish_task_id >= icon_info.open_task_id) {
					activity_icon_mgr.addIcon("424@2")
				} else if (icon) {
					activity_icon_mgr.deleteIcon("424@2")
				}
				icon = ActivityIconManager.GetInstance().getIconInfo("424")
				icon_info = common_mgr.GetFunctionIconCfg("424")
				if (icon_info && openday >= icon_info.open_day
					&& ((icon_info.max_open_day > 0 && openday <= icon_info.max_open_day) || icon_info.max_open_day == 0)
					&& finish_task_id >= icon_info.open_task_id) {
					activity_icon_mgr.addIcon("424")
				} else if (icon) {
					activity_icon_mgr.deleteIcon("424")
				}
				icon = ActivityIconManager.GetInstance().getIconInfo("424@1")
				icon_info = common_mgr.GetFunctionIconCfg("424@1")
				if (icon_info && openday >= icon_info.open_day
					&& ((icon_info.max_open_day > 0 && openday <= icon_info.max_open_day) || icon_info.max_open_day == 0)
					&& finish_task_id >= icon_info.open_task_id) {
					activity_icon_mgr.addIcon("424@1")
				} else if (icon) {
					activity_icon_mgr.deleteIcon("424@1")
				}
			}
		}

		this.setBookOpen = (chapter?) => {
			let info = this._BookInfoData[chapter]
			info.status = 2
		}

		this.getBookInfoDataList = (chapter?, returnList?) => {
			// if (returnList == null) {
			// 	returnList = true
			// }
			// let flag = false
			// let info = this.BookOfContractTabCofByChapter(chapter)
			// if (info) {
			// 	if (Trim(info.condition) == "[]") {
			// 		flag = true
			// 	} else {
			// 		let condition = Number(String.match(info.condition, "%d+"))
			// 		let data = this._BookInfoData[condition]
			// 		flag = data && data.status == 2 && data.stage_list.length > 0
			// 	}
			// }
			// if (returnList) {
			// 	let list = this._BookInfoData[chapter]
			// 	return (!list && ({}) || (list))
			// } else {
			// 	return flag
			// }
		}

		this.getBookChapterProgress = (chapter?) => {
			let progress = ''
			let list = this.getBookInfoDataList(chapter)
			let conflist = this.BookOfContractItemList(chapter)
			if ((list && list.stage_list) && list.stage_list.length > 0) {
				let count = 0
				for (let key in list.stage_list) {

					if (list.stage_list[key]) {
						let info = list.stage_list[key]
						if (info.status == 2) {
							count = count + 1
						}
					}
				}
				let color = (count >= conflist.length && (local_ColorUtil.GetColorLight(local_ColorType.GREEN)) || (local_ColorUtil.GetColorLight(local_ColorType.RED)))
				progress = "<font color=" + color + ">(" + count + "/" + conflist.length + ")</font>"
			} else {
				progress = "<font color=" + local_ColorUtil.GetColorLight(local_ColorType.RED) + ">(0/" + conflist.length + ")</font>"
			}
			return progress
		}

		this.finishAll = () => {
			let conf = this.GetBookOfContractTabCof()
			for (let key in conf) {

				// [ts2lua]conf下标访问可能不正确
				let info = conf[key]
				let list = this.getBookInfoDataList(info.id)
				let conflist = this.BookOfContractItemList(info.id)
				let count = 0
				if (list.stage_list) {
					for (let key in list.stage_list) {

						if (list.stage_list[key]) {
							// [ts2lua]list.stage_list下标访问可能不正确
							let data = list.stage_list[key]
							if (data.status == 2) {
								count = count + 1
							}
						}
					}
				}
				if (count < conflist.length) {
					return false
				}
			}
			return true
		}

		this.BookChapterSkill = () => {
			let skillList = []
			let conf = this.GetBookOfContractTabCof()
			let chapter = null
			for (let key in conf) {

				if (conf[key]) {
					// [ts2lua]conf下标访问可能不正确
					let chapterinfo = conf[key]
					chapter = chapterinfo.id
					let list = this.getBookInfoDataList(chapter)
					let conflist = this.BookOfContractItemList(chapter)
					if (list.stage_list && list.stage_list.length > 0) {
						let count = 0
						for (let key in list.stage_list) {

							if (list.stage_list[key]) {
								// [ts2lua]list.stage_list下标访问可能不正确
								let info = list.stage_list[key]
								if (info.status == 2) {
									count = count + 1
								}
							}
						}
						if (count >= conflist.length) {
							table.insert(skillList, chapter)
						}
					}
				}
			}
			return skillList
		}

		this.BookChapterSkillOpen = (skillId?) => {
			let chapter = skillId - 300200
			let skillList = this.BookChapterSkill()
			for (let key in skillList) {

				if (skillList[key]) {
					let id = skillList[key]
					if (chapter == id) {
						return true
					}
				}
			}
			return false
		}

		this.MessageShow = (chapter) => {
			// let name = ""
			// let info = this.BookOfContractTabCofByChapter(chapter)
			// if (info) {
			// 	let condition = Number(String.match(info.condition, "%d+"))
			// 	let conditionInfo = this.BookOfContractTabCofByChapter(condition)
			// 	name = conditionInfo.name
			// }
			// return "激活" + name + "后解锁"
		}

		this.getBookInfoData = (chapter?, stage?) => {
			let datalist = this.getBookInfoDataList(chapter)
			if (datalist.stage_list) {
				for (let key in datalist.stage_list) {

					if (datalist.stage_list[key]) {
						let info = datalist.stage_list[key]
						if (info.stage == stage) {
							return info
						}
					}
				}
			}
			return null
		}

		this.updateBookInfoData = (data?) => {
			this._BookInfoData[data.chapter] = data
			this.setBookRedDot()
			this.Fire(local_KaifuActivityModelEvent.UPDATE_BOOK_DATA)
		}

		this.setBookInfoRewardData = (chapter, stage) => {
			let info = this._BookInfoData[chapter]
			let list = info.stage_list
			for (let key in list) {

				if (list[key]) {
					let stage_info = list[key]
					if (stage_info.stage == stage) {
						stage_info.status = 2
						list[key] = stage_info
						break
					}
				}
			}
			info.stage_list = list
			this._BookInfoData[chapter] = info
			this.setBookRedDot()
			this.Fire(local_KaifuActivityModelEvent.UPDATE_BOOK_DATA)
		}

		this.setRequestData = (list) => {
			for (let key in list) {

				if (list[key]) {
					let chapterInfo = list[key]
					this.Fire(local_KaifuActivityModelEvent.REQUEST_BOOK_DATA, chapterInfo.chapter)
				}
			}
		}

		this.BookOfContractProgress = (data, info) => {
			let str = data.desc
			let condition = data.condition
			let condition_list = JSON.parse(condition)
			let list = []
			for (let key in condition_list[0]) {

				if (condition_list[0][key]) {
					let c = condition_list[0][key]
					table.insert(list, c)
				}
			}
			let type = list[0]
			let max = null
			if (type == local_BookOfContractType.boss || type == local_BookOfContractType.dun) {
				max = Number(list[3])
			} else if (type == local_BookOfContractType.equip_suit || type == local_BookOfContractType.equip || type == local_BookOfContractType.vip || type == local_BookOfContractType.dun_dragon)
				max = 1
			else if (type == local_BookOfContractType.attr) {
				max = Number(list[list.length])
			} else {
				max = list[list.length]
				max = (!max || max.length == 0) && 1 || max
				max = Trim(max) == "[]" && 1 || Number(max)
			}
			let value = (!info && (0) || (info.progress))
			let color = (value >= max && (local_ColorUtil.GetColorLight(local_ColorType.GREEN)) || (local_ColorUtil.GetColorLight(local_ColorType.RED)))
			str = str + "<font color=" + color + ">(" + Math.min(value, max) + "/" + max + ")</font>"
			return str
		}

		this.BookOfContractCondition = (data) => {
			let list = []
			let condition = data.condition
			let condition_list = JSON.parse(condition)
			let type = condition_list[0][0]
			//if (type == local_BookOfContractType.boss ) {
			//let bosslist = condition_list[0][1]
			//for (let key in bosslist) {

			//if (bosslist[key] ) {
			//let boss = bosslist[key]
			//table.insert(list, {type, boss, {data.chapter, data.stage}})
			//}
			//}
			//}else{
			if (type == local_BookOfContractType.boss_num)
				table.insert(list, { [0]: type, [1]: condition_list[0][1], [2]: { [0]: data.chapter, [1]: data.stage } })
			else if (type == local_BookOfContractType.equip_ids) {
				let equiplist = condition_list[0][1]
				for (let key in equiplist) {

					if (equiplist[key]) {
						let equip = equiplist[key]
						table.insert(list, { [0]: type, [1]: equip, [2]: { [0]: data.chapter, [1]: data.stage } })
					}
				}
			} else if (type == local_BookOfContractType.equip) {
				list = [type, condition_list[0][1], { [0]: data.chapter, [1]: data.stage }]
			}
			else {
				list = [type, { [0]: data.chapter, [1]: data.stage }]
			}

			return list
		}

		this.iconIndex = (data?) => {
			let index = 1
			for (let key in data) {

				if (data[key]) {
					let infolist = data[key]
					if (infolist.length <= 2) {
						break
					}
					if (infolist.length > 2) {
						let open = this.iconHasOpen(infolist)
						if (!open) {
							break
						}
					}
					index = index + 1
				}
			}
			return index
		}

		this.iconHasOpen = (data?) => {
			let flag = false
			let id = data[1]
			if (data.length > 2) {
				let info = this.getBookInfoData(data[2][0], data[2][1])
				if (info && Trim(info.extra) != "[]" && info.extra.find(id) != -1) {
					flag = true
				}
			}
			return flag
		}

		this.setImageAndName = (img?, type?, id?) => {
			//let name = ""
			if (type == local_BookOfContractType.first_recharge) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "159")
			} else if (type == local_BookOfContractType.equip_ids) {
				let icon_id = GoodsModel.GetGoodsIcon(id)
				ResManager.GetInstance().SetOutsideImageSprite(this, img, "client/assets/icon/goodsIcon/" + icon_id + ".png")
			} else if (type == local_BookOfContractType.vip) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "12")
			} else if (type == local_BookOfContractType.month_card) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "12")
			} else if (type == local_BookOfContractType.diamond_investment) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "12")
			} else if (type == local_BookOfContractType.equip) {
				let str = (id >= 10 && (id) || ("0" + id))
				ResManager.GetInstance().SetOutsideImageSprite(this, img, "client/assets/icon/goodsIcon/10104" + str + ".png")
			} else if (type == local_BookOfContractType.attr) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "role")
			} else if (type == local_BookOfContractType.equip_suit) {
				ResManager.GetInstance().SetImageSprite(this, img, "role_asset", "role_suit_btn")
			} else if (type == local_BookOfContractType.battle_power) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "role")
			} else if (type == local_BookOfContractType.active_magic) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "bag")
			} else if (type == local_BookOfContractType.boss || type == local_BookOfContractType.boss_num) {
				//let monster = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, id, false)
				//if (monster ) {
				//lua_resM:SetOutsideImageSprite(this, img, "client/assets/icon/monsterHead/" + monster.icon + ".png")
				////name = monster.name
				//}else{
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "15")
				//}
			} else if (type == local_BookOfContractType.lv) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "role")
			} else if (type == local_BookOfContractType.dun) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "16")
			} else if (type == local_BookOfContractType.guild_join) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "guild")
			} else if (type == local_BookOfContractType.husong) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "25")
			} else if (type == local_BookOfContractType.compose) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "red")
			} else if (type == local_BookOfContractType.jjc) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "19")
			} else if (type == local_BookOfContractType.turn) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "130")
			} else if (type == local_BookOfContractType.combat) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "role")
			} else if (type == local_BookOfContractType.rune_dun) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "16")
			} else if (type == local_BookOfContractType.wear_equip_status) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "red")
			} else if (type == local_BookOfContractType.active_suit) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "role")
			} else if (type == local_BookOfContractType.dun_dragon) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "16")
			} else if (type == local_BookOfContractType.seal_status) {
				ResManager.GetInstance().SetImageSprite(this, img, "mainUI_asset", "bag")
			} else if (type == local_BookOfContractType.wash_equip_status) {
				ResManager.GetInstance().SetImageSpriteTrans(this, img, GameResPath.GetIcon("functionOpenIcon", "3730"))
			}
		}


		this.changeBookData = (data?) => {
			let book_data = this._BookInfoData[data.chapter]
			if (book_data) { //章节解锁了才请求
				this.Fire(local_KaifuActivityModelEvent.REQUEST_BOOK_DATA, data.chapter)
			}
		}

		this.tabRedDot = (chapter) => {
			// let flag = false
			// let configList = this.BookOfContractItemList(chapter)
			// let info = this.BookOfContractTabCofByChapter(chapter)
			// if (info) {
			// 	if (Trim(info.condition) != "[]") {
			// 		let condition = Number(String.match(info.condition, "%d+"))
			// 		let data = this._BookInfoData[condition]
			// 		if (!(data && data.status == 2)) {
			// 			return false
			// 		}
			// 	}
			// }
			// for (let key in configList) {

			// 	let config = configList[key]
			// 	let data = this.getBookInfoData(chapter, config.stage)
			// 	if (data && data.status == 1) {
			// 		flag = true
			// 		break
			// 	}
			// }
			// return flag
		}

		this.setBookRedDot = () => {
			CustomActivityModel.GetInstance().RefreshIconRed(424, 0)
			local_GlobalEventSystem.Fire(refresh_icon_red_event, "424", this.GetBookRedDot())
			local_GlobalEventSystem.Fire(refresh_icon_red_event, "424@1", this.GetBookRedDot())
			local_GlobalEventSystem.Fire(refresh_icon_red_event, "424@2", this.GetBookRedDot())
		}

		this.InvestOpen = (data?) => {
			this.open_data = data
			let show = false
			let showIcon = false
			for (let key in data.open_list) {

				let investInfo = data.open_list[key]
				let flag = false
				if ((investInfo.state == 0 || investInfo.state == 1) || investInfo.state == 2 && data.type != local_investType.top) {
					flag = true
					show = true
				} else if (investInfo.state == 3) {

				}
				if (investInfo.show_id == 1) {
					let cfg = ViewClassCFG[investInfo.type - 1]
					if (!cfg) {
						break
					}
					let icon = activity_icon_mgr.getIconInfo("4205")
					if (this.fullShowIconTime(investInfo.refresh_time, cfg.showDay)) {
						show = true
						showIcon = true
						if (!icon) {
							activity_icon_mgr.addIcon("4205")

						}
						showInvestIcon_[investInfo.type] = true
					} else {
						showInvestIcon_[investInfo.type] = false
					}
				}
				if (flag) {
					this.Fire(local_KaifuActivityModelEvent.REQUEST_INVEST_DATA, investInfo.type)
				}
			}

			if (show) {
				let icon = activity_icon_mgr.getIconInfo("1112")
				if (!icon) {
					activity_icon_mgr.addIcon('1112')
				}
			}
			if (!showIcon) {
				let icon = activity_icon_mgr.getIconInfo("4205")
				if (icon) {
					activity_icon_mgr.deleteIcon("4205")
				}
			}
		}

		this.InvestShowIcon = (type?) => {
			let bool = showInvestIcon_[type]
			if (!bool) {
				bool = false
			}
			return bool
		}

		this.setInvestData = (data?) => {
			_InvestData[data.type] = data
			this.upateInvestRedDot(data.type)
			this.Fire(local_KaifuActivityModelEvent.INVEST_DATA_UPDATE, data.type)
		}

		this.getInvestData = (type?) => {
			return _InvestData[type]
		}

		this.CheckHaveMonthCard = () => {
			let data = this.getInvestData(local_investType.month)
			if(!data) return false
			return !(data.cur_lv <= 0 || !data.cur_lv)
		}

		this.setInvestLevelData = (data?) => {
			_InvestLevelData[data.type] = data.lv
			this.Fire(local_KaifuActivityModelEvent.REQUEST_INVEST_DATA, data.type)
		}

		this.setInvestRewardData = (data?) => {
			let typeData = _InvestData[data.type]
			let rewardsList = typeData.rewards
			let flag = true
			if (rewardsList.length > 0) {
				for (let key in typeData.rewards) {

					let reward = typeData.rewards[key]
					if (reward.id == data.id) {
						flag = false
						reward.got_lv = typeData.cur_lv
						typeData.rewards[key] = reward
						break
					}
				}
			}
			if (flag) {
				let reward = []
				reward["id"] = data.id
				reward["got_lv"] = typeData.cur_lv
				table.insert(rewardsList, reward)
			}
			typeData.rewards = rewardsList
			_InvestData[data.type] = typeData
			this.upateInvestRedDot(data.type)
			this.Fire(local_KaifuActivityModelEvent.INVEST_DATA_UPDATE, data.type)
		}

		this.investConfig = (type?, conftype?) => {
			let list = []
			let config = this.getConfig(conftype)
			for (let key in config) {

				let info = config[key]
				if (info.type == type) {
					table.insert(list, info)
				}
			}
			return list
		}

		this.InvestTypeConf = (type?, level?) => {
			let _LVinvestTypeConf = []
			let conf = this.investConfig(type, local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
			for (let key in conf) {

				let info = conf[key]
				if (level && level == info.level) {
					return info
				}
				table.insert(_LVinvestTypeConf, info)
			}
			table.sort(_LVinvestTypeConf, (a?, b?) => {
				return a.price < b.price
			})
			return _LVinvestTypeConf
		}

		this.lvClick = (type?, level?) => {
			let curData = this.getInvestData(type)
			let curConf = this.InvestTypeConf(type, level)
			let mainVo = role_mgr.GetMainRoleVo()
			let cost = curConf.price
			let flag = mainVo.jin >= cost
			let str = "是否花费<font color='#34a064'>" + cost + "勾玉</font>进行投资<br/>(投资后总共可获得<font color='#34a064'>" + this.allPrice(level, false, type) + "绑玉</font>)"
			let content = Util.StrToHTML(str)
			local_Alert.Show(content, local_Alert_Type.Two, () => {
				if (flag) {
					this.Fire(local_KaifuActivityModelEvent.SEND_INVEST_LEVEL, type, level)
				} else {
					// local_Message.show("你的勾玉余额不足")
					// setTimeout(() => {
					// 	OpenFun.OpenFunHandler(21)
					// }
					// 	, 300)
					local_Alert.Show("勾玉不足，是否前往充值？", local_Alert_Type.Two, () => {
						OpenFun.OpenFunHandler(21)
					})
				}
			}
				, null, "确定", "取消")
		}

		this.vipClick = () => {
			let idata = this.getInvestData(local_investType.vip)
			if (!idata) {
				return false
			}
			if (idata.buy_time > 0) {
				local_Message.show("已投资")
				return
			}
			let _cur_lv = idata.cur_lv || 1
			let cond_vip = this.getVIPcondition(_cur_lv)
			if (role_mgr.GetMainRoleVo().vip_flag < cond_vip) {
				local_Alert.Show("当前vip等级不足，是否前往提升", local_Alert_Type.Two, () => {
					setTimeout(() => {
						OpenFun.OpenFunHandler(23)
					}
						, 0.28)
				}
					, null, "确定", "取消")
				return false
			}
			let can, cfg = this.checkMoneyEnough(local_investType.vip, _cur_lv)
			if (can) {
				let price = HtmlColorTxt(cfg.price, Enum_ColorUtil_Dark.GREEN)
				let str = Util.StrToHTML("是否花费" + price + "勾玉进行vip投资")
				local_Alert.Show(str, local_Alert_Type.Two, () => {
					this.Fire(local_KaifuActivityModelEvent.SEND_INVEST_LEVEL, local_investType.vip, _cur_lv)
				}
					, null, "确定", "取消")
			}
			return can
		}

		this.menuConfList = (type?) => {
			let list = []
			let conf = this.InvestTypeConf(type)
			list = conf
			return list
		}

		this.investRewardsConf = (type?) => {
			// [ts2lua]_investRewardsConf下标访问可能不正确
			let list = _investRewardsConf[type]
			if (!list || list.length == 0) {
				list = []
				let conf = this.investConfig(type, local_KAIFUACTIVITY_CONFIG.INVESTMENT_REWARDS)
				for (let key in conf) {

					// [ts2lua]conf下标访问可能不正确
					let info = conf[key]
					table.insert(list, info)
				}
				// [ts2lua]_investRewardsConf下标访问可能不正确
				_investRewardsConf[type] = list
			}
			// [ts2lua]_investRewardsConf下标访问可能不正确
			return _investRewardsConf[type]
		}

		this.selectIndex = (type?) => {
			let index = 0
			let level = this.getInvestLevelByType(type)
			let list = this.menuConfList(type)
			for (let key in list) {

				let cof = list[key]
				if (cof.level == level) {
					break
				}
				index = index + 1
			}
			return index
		}

		this.investRewardsList = (level?, type?) => {
			let list = []
			let conf = this.investRewardsConf(type)
			for (let key in conf) {

				// [ts2lua]conf下标访问可能不正确
				let info = conf[key]
				if (info.level == level) {
					table.insert(list, info)
				}
			}

			list.sort((a, b) => { return this.sortInvest(a, b) });
			return list
		}

		this.sortInvest = (a?, b?) => {
			let aIndex = 200 + a.id
			let bIndex = 200 + b.id
			if (this.InvestHasGet(a.level, a.id, a.type)) {
				aIndex = aIndex + 100
			}
			if (this.InvestHasGet(b.level, b.id, b.type)) {
				bIndex = bIndex + 100
			}
			return aIndex - bIndex
		}

		this.InvestHasGet = (level?, id?, type?) => {
			let flag = false
			let curData = this.getInvestData(type)
			if (curData) {
				for (let key in curData.rewards) {

					// [ts2lua]curData.rewards下标访问可能不正确
					let info = curData.rewards[key]
					if (info.id == id && info.got_lv == level) {
						flag = true
					}
				}
			}
			return flag
		}

		this.investRewards = (level?, id?, type?) => {
			let list = this.investRewardsList(level, type)
			for (let key in list) {

				let info = list[key]
				if (info.id == id) {
					return info
				}
			}
		}

		this.allPrice = (level, minus, type) => {
			if (minus == null) {
				minus = false
			}
			if (type == null) {
				type = local_investType.level
			}
			let price = 0
			let curData = this.getInvestData(type)
			let list = this.investRewardsList(level, type)
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				let info = list[key]
				let rewordList = JSON.parse(info.rewards)
				price = price + local_Number(rewordList[0][2])
			}
			if (minus && curData.cur_lv < level) {
				price = price - this.getPrice()
			}
			return price
		}

		this.curLevelCfg = (type?) => {
			let data = this.getInvestData(type)
			let cfg = null
			if (data && data.cur_lv != 0) {
				cfg = this.InvestTypeConf(type, data.cur_lv)
			}
			if (!cfg) {
				let list = this.InvestTypeConf(type)
				let length = list.length
				length = (length < 0 && (0) || (length))
				cfg = list[length - 1]
			}
			return cfg
		}

		this.getInvestLevelByType = (type?) => {
			let level = _InvestLevelData[type]
			if (!level) {
				level = 1
				let cfg = this.curLevelCfg(type)
				if (cfg) {
					level = this.curLevelCfg(type).level
				}
			}
			return level
		}

		this.investRewardsHasGet = (dataConf?, type?) => {
			let flag = false
			let data = this.getInvestData(type)
			if (data) {
				for (let key in data.rewards) {

					// [ts2lua]data.rewards下标访问可能不正确
					let reward = data.rewards[key]
					if (reward.id == dataConf.id && dataConf.level == reward.got_lv) {
						flag = data.cur_lv != 0 && data.cur_lv == reward.got_lv
						break
					}
				}
			}
			return flag
		}

		this.investReword = (dataConf?, type?) => {
			let data = this.getInvestData(local_investType.level)
			// [ts2lua]lua中0和空字符串也是true，此处data && data.cur_lv == dataConf.level需要确认
			data = (data && data.cur_lv == dataConf.level && (data) || (null))
			let flag = false
			let rewordList = JSON.parse(dataConf.rewards)
			let last_lv = null
			let num = null
			if (data) {
				for (let key in data.rewards) {

					if (data.rewards[key]) {
						// [ts2lua]data.rewards下标访问可能不正确
						let reward = data.rewards[key]
						if (reward.id == dataConf.id) {
							last_lv = reward.got_lv
							flag = last_lv != data.cur_lv
							break
						}
					}
				}
			}
			if (flag) {
				let lastConf = this.investRewards(last_lv, dataConf.id, type)
				let lastRewordList = JSON.parse(lastConf.rewards)
				num = local_Number(rewordList[0][2]) - local_Number(lastRewordList[0][2])
			} else {
				num = local_Number(rewordList[0][2])
			}
			rewordList = [rewordList[0][0], rewordList[0][1], num]
			return rewordList
		}

		this.InvestRewordRedDot = (type?) => {
			let levelData = this.getInvestData(type)
			// [ts2lua]this.clickInvest下标访问可能不正确
			let click = this.clickInvest[type]
			if (!click && (levelData && levelData.cur_lv == 0)) {
				return true
			}
			let level = this.getInvestLevelByType(type)
			let confData = this.investRewardsList(level, type)
			for (let key in confData) {

				// [ts2lua]confData下标访问可能不正确
				let info = confData[key]
				let flag = levelData && levelData.cur_lv > 0
				if (Trim(info.condition) != "[]") {
					let conditionList = JSON.parse(info.condition)
					let level = Number(conditionList[0][1])
					let mylevel = role_mgr.GetMainRoleVo().level
					flag = flag && mylevel >= level
				}
				if (!flag) {
					break
				}
				let get = this.investRewardsHasGet(info, type)
				if (!get) {
					return true
				}
			}
			return false
		}

		this.setLEVELReddot = () => {
			this.Fire(local_KaifuActivityModelEvent.UPDATE_TAB_RED, "LVinvestView", this.InvestRewordRedDot(local_investType.level))
			local_GlobalEventSystem.Fire(refresh_icon_red_event, 1112, this.GeticonRedDot())
		}

		this.investReddot = (flag?) => {
			if (flag == null) {
				flag = false
			}
			if (!flag && !this.InvestShowIcon(local_investType.top) || flag) {
				this.setInvestReddot(local_investType.top)
			}
			if (!flag && !this.InvestShowIcon(local_investType.king) || flag) {
				this.setInvestReddot(local_investType.king)
			}
			if (!flag && !this.InvestShowIcon(local_investType.extreme) || flag) {
				this.setInvestReddot(local_investType.extreme)
			}
			if (!flag && !this.InvestShowIcon(local_investType.god) || flag) {
				this.setInvestReddot(local_investType.god)
			}
		}

		this.setInvestReddot = (type?) => {
			let view = ""
			let redDot = false
			if (type == local_investType.top) {
				view = "TopInvestView"
				redDot = this.InvestRewordRedDot(type)
			} else if (type == local_investType.king) {
				view = "zKingInvestView"
				redDot = this.InvestRewordRedDot(type)
			} else if (type == local_investType.extreme) {
				view = "zExtremeInvestView"
				redDot = this.InvestRewordRedDot(type)
			} else if (type == local_investType.god) {
				view = "zGodInvestView"
				redDot = this.InvestRewordRedDot(type)
			}
			this.Fire(local_KaifuActivityModelEvent.UPDATE_TAB_RED, view, redDot)
			if (this.InvestShowIcon(type)) {
				let bool = this.GetInvestIconRedDot()
				local_GlobalEventSystem.Fire(refresh_icon_red_event, "4205", bool)
			} else {
				local_GlobalEventSystem.Fire(refresh_icon_red_event, 1112, this.GeticonRedDot())
			}
		}

		this.GetInvestIconRedDot = () => {
			return (this.InvestShowIcon(investType.top) && this.InvestRewordRedDot(investType.top)) ||
				(this.InvestShowIcon(investType.king) && this.InvestRewordRedDot(investType.king)) ||
				(this.InvestShowIcon(investType.extreme) && this.InvestRewordRedDot(investType.extreme)) ||
				(this.InvestShowIcon(investType.god) && this.InvestRewordRedDot(investType.god))
		}




		this.vipIInvestRewardsList = (level?) => {
			let list = []
			let conf = this.GetvipInvestRewardsConf()
			for (let key in conf) {

				if (conf[key]) {
					// [ts2lua]conf下标访问可能不正确
					let info = conf[key]
					if (info.level == level) {
						table.insert(list, info)
					}
				}
			}
			return list
		}

		this.investCondition = (type?, config_investment_item?) => {
			let cfg = config_investment_item
			if (!cfg) {
				return
			}
			// [ts2lua]cfg下标访问可能不正确
			let cond = JSON.parse(cfg[type].condition)
			let max_lv = null
			let min_lv = null
			let open_begin = null
			let open_end = null
			for (let _tmpi in cond) {
				var info = cond[_tmpi]
				if (info[0] == "max_lv") {
					max_lv = local_Number(info[1])
				} else if (info[0] == "min_lv") {
					min_lv = local_Number(info[1])
				} else if (info[0] == "open_begin") {
					open_begin = local_Number(info[1])
				} else if (info[0] == "open_end") {
					open_end = local_Number(info[1])
				}
			}
			return { min_lv, max_lv, open_begin, open_end }
		}

		this.investOpenStatus = (type?, Investmentitem?) => {
			let min_lv, max_lv, open_begin, open_end = this.investCondition(type, Investmentitem)
			if (min_lv && role_mgr.GetMainRoleVo().level < min_lv) {
				return false
			}
			if (max_lv && role_mgr.GetMainRoleVo().level > max_lv) {
				return false
			}
			if (open_begin && server_time_model.GetOpenServerDay() < open_begin) {
				return false
			}
			if (open_end && server_time_model.GetOpenServerDay() > open_end) {
				return false
			}
			return true
		}

		this.getVIPRewardData = (id?) => {
			let idata = this.getInvestData(local_investType.vip)
			for (let _tmpi in idata.rewards) {
				var info = idata.rewards[_tmpi]
				if (info.id == id) {
					return info
				}
			}
		}

		this.getVIPcondition = (lv?) => {
			let type_cfg = this.getConfig(local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
			// [ts2lua]type_cfg下标访问可能不正确
			let cfg = type_cfg[local_investType.vip + "@" + lv]
			if (!cfg) {
				return 0
			}
			let conds = JSON.parse(cfg.condition)
			return local_Number(conds[0][1])
		}

		this.checkMoneyEnough = (type?, lv?) => {
			let type_cfg = this.getConfig(local_KAIFUACTIVITY_CONFIG.INVESTMENT_TYPES)
			// [ts2lua]type_cfg下标访问可能不正确
			let cfg = type_cfg[type + "@" + lv]
			if (!cfg) {
				return [false, - 1]
			}

			let enough = GoodsModel.GetInstance().CheckCoinEnough(cfg.price_type, cfg.price, true)
			return [enough, cfg]
		}

		this.setVIPReddot = (red?) => {
			red_dot_mgr.SetRedStatus(ModuleType.VIPINVEST, 1, red)
			this.Fire(local_KaifuActivityModelEvent.UPDATE_TAB_RED, "VIPinvestView", red)
			local_GlobalEventSystem.Fire(refresh_icon_red_event, 1112, this.GeticonRedDot())
		}

		this.checkVIPReddot = () => {
			let cookie_time = cooie_wrapper.GetCookie(CookieWrapper.VIP_INVEST_RED_TIME)
			let red = !cookie_time || local_TimeUtil.getServerTime() > local_Number(cookie_time)
			if (red) {
				return true
			}
			let idata = this.getInvestData(local_investType.vip)
			let rewards = this.vipIInvestRewardsList(idata.cur_lv || 1)
			for (let _tmpi in rewards) {
				var data = rewards[_tmpi]
				let rdata = this.getVIPRewardData(data.id)
				let login = this.parseVipCondition(data.condition)
				let has_buy = idata.cur_lv != 0
				let can_get = has_buy && (!login || idata.login_days >= login)
				let has_get = (has_buy && rdata) && idata.cur_lv <= rdata.got_lv
				if (!has_get && can_get) {
					return true
				}
			}
			return false
		}

		this.parseVipCondition = (condition?) => {
			let conds = JSON.parse(condition)
			for (let _tmpi in conds) {
				var cond = conds[_tmpi]
				if (cond[0] != "login_days") {
					break
				}
				return cond[1]
			}
		}

		this.upateInvestRedDot = (type?) => {
			if (type == local_investType.vip) {
				this.setVIPReddot(this.checkVIPReddot())
			} else if (type == local_investType.level) {
				this.setLEVELReddot()
			} else if (type == local_investType.month) {
				this.setMonthReddot(this.checkMonthReddot())
			} else if (type == local_investType.top) {
				this.setInvestReddot(type)
			} else if (type == local_investType.king) {
				this.setInvestReddot(type)
			} else if (type == local_investType.extreme) {
				this.setInvestReddot(type)
			} else if (type == local_investType.god) {
				this.setInvestReddot(type)
			} else if (typeof(type) == "string" && type == "WeekCardMainView"){
				//这个需求很奇怪，运营要求写死（如果要改动，那就把周卡也新加一个类型整合到超值投资）
				local_GlobalEventSystem.Fire(refresh_icon_red_event, 1112, this.GeticonRedDot())
			}
		}

		this.InvestViewLists = (type?) => {
			let list = []
			let labels = []
			let bgs = []
			let index = 0
			if (!this.open_data) {
				return [list, labels, bgs]
			}

			table.sort(this.open_data.open_list, (a?, b?) => {
				return a.type < b.type
			})

			let count = 0
			for (let i = 0; i < this.open_data.open_list.length; i++) {
				let data = this.open_data.open_list[i]
				if (data.show_id != 1) {
					continue
				}
				let cfg = ViewClassCFG[data.type - 1]
				let canShow = cfg.showDay && this.fullShowIconTime(data.refresh_time, cfg.showDay)
				if ((cfg && data.state != 3) && canShow) {
					if (cfg.bg) {
						bgs[list.length] = cfg.bg
					}
					table.insert(list, cfg.class)
					table.insert(labels, cfg.label)
					if (type != null && type == data.type) {
						index = count
					}
					count = count + 1
				}
			}
			return [list, labels, bgs, index]
		}

		this.fullShowIconTime = (starTime?, day?) => {
			let time = local_TimeUtil.getServerTime()
			return time < local_TimeUtil.GetTimeFutureZeroStamp(starTime, day)
		}

		this.canShowIcon = () => {
			let list, labels, bgs = this.GetviewLabelLists()
			return list.length > 0
		}

		this.monthCondition = () => {
			let cfg = this.getConfig(local_KAIFUACTIVITY_CONFIG.INVESTMENT_ITEM)
			let cond = JSON.parse(cfg[local_investType.month].condition)
			let vip = null
			let min_lv = null
			let open_begin = null
			let open_end = null
			for (let _tmpi in cond) {
				var info = cond[_tmpi]
				if (info[0] == "min_lv") {
					min_lv = local_Number(info[1])
				} else if (info[0] == "open_end") {
					open_end = local_Number(info[1])
				}
			}
			return { min_lv, open_end }
		}

		this.checkMonthOpenStatus = () => {
			let min_lv, open_end = this.monthCondition()
			if (role_mgr.GetMainRoleVo().level < min_lv) {
				return false
			}
			if (server_time_model.GetOpenServerDay() > open_end) {
				return false
			}
			return true
		}

		this.setMonthReddot = (red?) => {
			red_dot_mgr.SetRedStatus(ModuleType.MONTHINVSET, 1, red)
			this.Fire(local_KaifuActivityModelEvent.UPDATE_TAB_RED, "MonthCardView", red)
			local_GlobalEventSystem.Fire(refresh_icon_red_event, 1112, this.GeticonRedDot())
		}

		this.checkMonthReddot = () => {
			let idata = this.getInvestData(local_investType.month)
			if (!idata) {
				return false
			}
			if (idata.cur_lv <= 0 || !idata.cur_lv) {

				let cookie_time = CookieWrapper.Instance.GetCookie(CookieWrapper.MONTH_INVEST_RED_TIME)
				let red = !cookie_time || local_TimeUtil.getServerTime() > local_Number(cookie_time)
				if (red) {
					return true
				}
				return false
			} else {
				if (idata.get_time == 0) {
					return true
				} else {
					let time_date = new Date(idata.get_time * 1000)
					time_date.setHours(0, 0, 0)
					let time = Math.floor(time_date.getTime() / 1000) + 24 * 60 * 60
					return local_TimeUtil.getServerTime() >= time
				}
			}
		}

		this.KaifuActivityOpenFun = (type?,has_week_card?) => {
			let investment_item_cfg = Investmentitem
			let cfg = investment_item_cfg[type]
			if (!cfg) {
				return
			}
			let level = role_mgr.GetMainRoleVo().level
			let needLevel = JSON.parse(cfg.condition)[0]
			if (level < local_Number(needLevel[1])) {
				local_Message.show("达到" + needLevel[1] + "级开启")
				return
			}

			if (this.open_data && this.open_data.open_list) {
				table.sort(this.open_data.open_list, (a?, b?) => {
					return a.type < b.type
				})
			}

			let index = 0
			let open = false
			for (let _tmpi in this.open_data.open_list) {
				var data = this.open_data.open_list[_tmpi]
				if (data.type == type && data.state != 3) {
					open = true
					break
				}
				index = index + 1
			}
			if (open) {
				if(has_week_card){
					index = index + 1
				}
				this.Fire(local_KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW, index)
			} else {
				local_Message.show("未开启")
			}
		}

		this.topInvestOpenFun = (type?) => {
			let investment_item_cfg = Investmentitem
			let cfg = investment_item_cfg[type]
			if (!cfg) {
				return
			}
			let level = role_mgr.GetMainRoleVo().level
			let needLevel = JSON.parse(cfg.condition)[0]
			if (level < local_Number(needLevel[1])) {
				local_Message.show("达到" + needLevel[1] + "级开启")
				return
			}
			if (this.InvestShowIcon(type)) {
				this.Fire(local_KaifuActivityModelEvent.OPEN_TOP_IVITY_VIEW, type)
			} else {
				this.KaifuActivityOpenFun(type)
			}
		}
	}

	public static GetInstance() {

		if (!KaifuActivityModel.Instance) {
			KaifuActivityModel.Instance = new KaifuActivityModel()
		}
		return KaifuActivityModel.Instance
	}

	public GetBookOfContractTabCof() {

		if (this._BookOfContractTabCof.length == 0) {
			let config = this.getConfig(KAIFUACTIVITY_CONFIG.BOOKOFCONTRACT_TAB)
			for (let key in config) {

				if (config[key]) {
					let info = config[key]
					table.insert(this._BookOfContractTabCof, info)
				}
			}
			table.sort(this._BookOfContractTabCof, (a?, b?) => {
				return a.id < b.id
			})

		}
		return this._BookOfContractTabCof
	}

	public GetBookOfContractItemCof() {

		if (this._BookOfContractItemCof.length == 0) {
			let config = this.getConfig(KAIFUACTIVITY_CONFIG.BOOKOFCONTRACT_ITEM)
			for (let key in config) {

				if (config[key]) {
					let info = config[key]
					table.insert(this._BookOfContractItemCof, info)
				}
			}
		}
		return this._BookOfContractItemCof
	}

	public GetselectTabIndex() {

		let conflist = this.GetBookOfContractTabCof()
		let index = 1
		for (let key in conflist) {
			var tab = conflist[key]
			do {
				let data = this._BookInfoData[tab.id]
				if (!data || data.status != 1) {
					break
				}

				if (this.tabRedDot(tab.id)) {
					return tab.id
				}
			} while (true)
		}

		for (let key in conflist) {
			var tab = conflist[key]
			let data = this._BookInfoData[tab.id]
			do {
				if (!data) {
					break
				}
				let list = this.BookOfContractItemList(data.chapter)
				let select = false
				let length = data.stage_list.length
				if (data.stage_list.length < list.length) {
					select = true
				} else {
					for (let i = 0; i < data.stage_list.length; i++) {
						var _data = data.stage_list[i]
						if (_data.status != 2) {
							select = true
							break
						}
					}
					index = data.chapter
				}

				if (select) {
					return data.chapter
				}
			} while (true)
		}
		return index
	}

	public GetBookRedDot() {

		let flag = false
		let conflist = this.GetBookOfContractTabCof()
		for (let key in conflist) {

			if (conflist[key]) {
				let tab = conflist[key]
				flag = this.tabRedDot(tab.id)
				if (flag) {
					break
				}
			}
		}
		return flag
	}

	public getPrice() {

		let curData = this.getInvestData(investType.level)
		let level = curData.cur_lv
		let price = 0
		if (level > 0) {
			for (let key in curData.rewards) {

				if (curData.rewards[key]) {
					let reward = curData.rewards[key]
					let conf = this.investRewards(level, reward.id, investType.level)
					let rewordList = JSON.parse(conf.rewards)
					price = price + Number(rewordList[0][2])
				}
			}
		}
		return price
	}

	public GetvipInvestRewardsConf() {

		if (this._vipInvestRewardsConf.length == 0) {
			let conf = this.investConfig(investType.vip, KAIFUACTIVITY_CONFIG.INVESTMENT_REWARDS)
			for (let key in conf) {

				if (conf[key]) {
					// [ts2lua]conf下标访问可能不正确
					let info = conf[key]
					table.insert(this._vipInvestRewardsConf, info)
				}
			}
		}
		return this._vipInvestRewardsConf
	}

	public GeticonRedDot() {
		return this.InvestRewordRedDot(investType.level) ||
			RedDotManager.GetInstance().CheckRedStatus(ModuleType.VIPINVEST, 1) ||
			RedDotManager.GetInstance().CheckRedStatus(ModuleType.MONTHINVSET, 1) ||
			(!this.InvestShowIcon(investType.top) && this.InvestRewordRedDot(investType.top)) ||
			(!this.InvestShowIcon(investType.king) && this.InvestRewordRedDot(investType.king)) ||
			(!this.InvestShowIcon(investType.extreme) && this.InvestRewordRedDot(investType.extreme)) ||
			(!this.InvestShowIcon(investType.god) && this.InvestRewordRedDot(investType.god)) ||
			WeekCardModel.GetInstance().CanReceive()
	}

	public GetviewLabelLists() {

		let list = []
		let labels = []
		let bgs = []
		if (!this.open_data) {
			return [list, labels]
		}
		table.sort(this.open_data.open_list, (a?, b?) => {
			return a.type < b.type
		}
		)
		for (let _tmpi in this.open_data.open_list) {
			var data = this.open_data.open_list[_tmpi]
			let cfg = ViewClassCFG[data.type - 1]
			if (!cfg) {
				break
			}
			let refresh_time = data.refresh_time
			let canShow = !cfg.showDay || cfg.showDay && !this.fullShowIconTime(refresh_time, cfg.showDay)
			if ((cfg && data.state != 3) && canShow) {
				if (cfg.bg) {
					bgs[list.length] = cfg.bg
				}
				table.insert(list, cfg.class)
				table.insert(labels, cfg.label)
			}
		}
		return [list, labels, bgs]
	}
}

window["KaifuActivityModel"] = KaifuActivityModel