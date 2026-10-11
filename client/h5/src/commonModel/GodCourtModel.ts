import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CommonManager } from "../common/CommonManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"

export class GodCourtModel extends EventDispatcher {
	public static _instance: GodCourtModel
	AutoEquip
	CanComposite
	ChangeDevourColor
	CheckDevourRed
	CheckEquipReddot
	CheckHouseRed
	CheckStageRed
	CheckStrenRed
	CheckUnlockRed
	CheckUpColor
	ClearComSelect
	ClearDevourSelect
	ConditionCheck
	CreateDevourBagList
	FirstRedDot
	GetData
	GetEquipData
	GetEquipPosGoodsVo
	GetHouseRewardLv
	GetStage
	GetTabRed
	IsGodCourtActive
	SelectComMat
	SelectDevourGoods
	SetGodCourtData
	UpdateEquipState
	SetGodHouseData
	SetHouseLvData
	ShowRed
	UpdateCryColor
	bagViewSelect
	betterEquipList
	betterEquipRed
	comRed
	comSelect
	devourBagList
	devourPoint
	devourRed
	devourSelect
	devoureMatId
	godCourtRedList
	godcourtData
	godcourt_com_id_list
	houseData
	houseLv
	lotteryRed
	maxClickGodCourt
	regualrMatList
	rewardRed
	showColor
	showDevour
	showDevourTips
	showLowTips
	showType
	strenRed
	strenRedList
	unlockRed
	unlockRedList
	upStageRed
	upStageRedList
	IsHasHeight
	public static OPEN_VIEW = "JG0";
	public static SEND_SCMD = "JG1";
	public static CLOSE_VIEW = "JG2";
	public static REFRESH_RED = "JG3";
	public static UPDATE_EQUIP = "JG4";
	public static UPDATE_STREN_DATA = "JG5";
	public static UNLOCK = "JG6";
	public static UPDATE_GODCOURT = "JG7";
	public static SELECT_STAGE = "JG8";
	public static DEVOUR = "JG10";
	public static UPDATE_HOUSE = "JG11";
	public static UPDATE_COLOR = "JG12";
	public static UPDATE_LVDATA = "JG13";
	public static CLOSE_COMPARED = "JG14";
	public static SELECT_COM_MAT = "JG15";
	public static UPDATE_DEVOUR_COLOR = "JG16";
	public static DEVOUR_EFFECT = "JG17";
	public static UPDATE_STAGE = "JG18";
	public static PosList = [[240, 29], [311, 101], [311, 207], [240, 280], [130, 280], [60, 207], [60, 101], [130, 29], [185, 157]];
	public static GoodsType = 80;
	public static ComId = 78;
	public static SubtypeNameList = ["尚武纹章", "神道纹章", "月度纹章", "海魂纹章", "均衡纹章", "九华纹章", "冥纹纹章", "炎蚀纹章", "尚武之风", "神道羽扇", "月神之伞", "迦具土命", "六瓣八重", "须佐之剑", "轮回之笔", "阴阳法镜"];
	public static GCEffectOffset = [[3, 4], [-2, 3], [-6, -1], [10, 2], [2, -2]]

	public constructor() {
		super()
		this.maxClickGodCourt = 1001;
		this.bagViewSelect = true;
		this.godcourtData = [];
		this.houseLv = 0;
		this.houseData = [];
		this.CheckUpColor = true;
		this.FirstRedDot = true;
		this.showColor = 0;
		this.showType = 0;
		this.showDevour = 0;
		this.devoureMatId = 36255098;
		this.devourBagList = [];
		this.devourSelect = [];
		this.devourPoint = 0;
		this.devourRed = false;
		this.showDevourTips = true;
		this.unlockRed = false;
		this.unlockRedList = [];
		this.showLowTips = true;
		this.comSelect = [];
		this.godcourt_com_id_list = [];
		this.comRed = true;
		this.regualrMatList = [];
		this.strenRed = false;
		this.strenRedList = [];
		this.upStageRed = false;
		this.upStageRedList = [];
		this.betterEquipRed = false;
		this.betterEquipList = [];
		this.godCourtRedList = [];
		this.GetData = (id?) => {
			return this.godcourtData[id]
		}

		this.IsGodCourtActive = (type?, showMsg?) => {
			let active = this.godcourtData[type] && this.godcourtData[type].is_active != 0
			if (showMsg && !active) {
				Message.show("请先解锁神社")
			}
			return active
		}

		let firstSet = true


		this.SetGodCourtData = (list?) => {
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.godcourtData[vo.court_id] = vo
				table.sort(vo.equip_list, (a?, b?) => {
					return a.pos < b.pos
				})
				let canEquipCore = true
				for (let _tmpi in vo.equip_list) {
					let equip = vo.equip_list[_tmpi]
					if (equip.pos < 9) {
						let con
						if (equip) {
							let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(equip.equip_id)
							if (goodsVo && goodsVo.color >= 4) {
								con = true
							}
						}
						if (!con) {
							canEquipCore = false
							break
						}
					}
				}
				vo.canEquipCore = canEquipCore
			}

			if (firstSet) {
				this.CheckUnlockRed()
				this.CheckStrenRed()
				this.CheckEquipReddot()
				this.CheckStageRed()
				let max = 1001
				for (let key in this.godcourtData) {
					let Vo = this.godcourtData[key]
					if (Vo.is_active != 0 && Vo.court_id >= max) {
						max = Vo.court_id + 1
					}
					this.maxClickGodCourt = max
				}
				firstSet = null
			}
		}

		this.UpdateEquipState = () => {
			for (let i in this.godcourtData) {
				let vo = this.godcourtData[i]
				let canEquipCore = true
				for (let _tmpi in vo.equip_list) {
					let equip = vo.equip_list[_tmpi]
					if (equip.pos < 9) {
						let con
						if (equip) {
							let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(equip.equip_id)
							if (goodsVo && goodsVo.color >= 4) {
								con = true
							}
						}
						if (!con) {
							canEquipCore = false
							break
						}
					}
				}
				vo.canEquipCore = canEquipCore
			}
		}

		this.SetGodHouseData = (data?) => {
			this.houseLv = data.house_lv
			this.houseData = data
		}

		this.UpdateCryColor = (data?) => {
			for (let key in data) {

				if (key != "error_code") {
					this.houseData[key] = data[key]
				}
			}
		}

		this.SetHouseLvData = (data?) => {
			for (let key in data) {

				if (key != "error_code" && key != "reward_list") {
					this.houseData[key] = data[key]
					if (key == "house_lv") {
						this.houseLv = data[key]
					}
				}
			}
		}

		this.ConditionCheck = (condition?) => {
			for (let _tmpi in condition) {
				let vo = condition[_tmpi]
				if (vo[0] == "god_house") {
					return this.houseLv >= Number(vo[1])
				}
			}
		}

		this.GetEquipData = (courtId?, subtype?) => {
			if (courtId && subtype) {
				let courtData = this.godcourtData[courtId]
				if (courtData) {
					if (subtype > 8) {
						subtype = 9
					}
					return courtData.equip_list[subtype - 1]
				}
			}
		}

		this.GetStage = (courtId?, pos?) => {
			let data = this.GetEquipData(courtId, pos)
			if (data) {
				return data.stage
			}
			return 0
		}

		//CHECK
		this.SelectDevourGoods = (id?, type_id?, bool?, num?) => {
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, type_id, false)
			if (cfg) {
				let count = JSON.parse(cfg.regular_mat)[0][2]
				if (bool) {
					this.ChangeVar("devourPoint", this.devourPoint + count * num)
					this.devourSelect[id] = num
				} else if (this.devourSelect[id]) {
					this.ChangeVar("devourPoint", this.devourPoint - count * num)
					this.devourSelect[id] = null
				}
			}
		}

		this.ClearDevourSelect = () => {
			this.devourSelect = []
			this.ChangeVar("devourPoint", 0)
		}

		this.CreateDevourBagList = (godCourtId?) => {
			this.devourBagList = []
			let list = GoodsModel.GetInstance().godCourtBagList
			let wearEquipList = []
			let i = 0
			do {
				let goodsVo = null
				let equipInfo = this.GetEquipData(godCourtId, i + 1)
				if (equipInfo) {
					goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(equipInfo.equip_id)
				}
				table.insert(wearEquipList, goodsVo)
				i = i + 1
			} while ((i < 9))
			let matList = []
			let list1 = []
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				let type_id = vo.type_id
				if ((type_id == 801701 || type_id == 801702) || type_id == 801703) {
					table.insert(matList, vo)
				} else {
					let wearVo = wearEquipList[vo.subtype - 1]
					if (!wearVo || wearVo.rating < vo.rating) {
					} else {
						vo.godCourtId = godCourtId
						if (vo.subtype < 9) {
							table.insert(list1, vo)
						}
					}
				}
			}
			this.devourBagList = matList.concat(list1)
			return this.devourBagList
		}

		//CHECK
		this.ChangeDevourColor = () => {
			this.devourSelect = []
			let list = this.devourBagList
			let point = 0
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, vo.type_id, false)
				if (cfg && (vo.subtype == 17 || (vo.color < this.showDevour && vo.subtype < 9))) {
					this.devourSelect[vo.goods_id] = vo.goods_num
					point = point + Number(JSON.parse(cfg.regular_mat)[0][2]) * vo.goods_num
				}
			}
			this.ChangeVar("devourPoint", point)
		}

		this.SelectComMat = (goods_id?, index?, bool?) => {
			if (bool) {
				this.comSelect[goods_id] = index
			} else {
				delete this.comSelect[goods_id]
			}
			this.Fire(GodCourtModel.SELECT_COM_MAT, goods_id, bool, index)
		}

		//CHECK
		this.CheckUnlockRed = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("GodCourtView", true)) {
				//if (lockCfg ) {
				this.unlockRedList = []
				this.unlockRed = false
				for (let key in this.godcourtData) {
					let godCourtVo = this.godcourtData[key]
					if (godCourtVo.is_active == 0) {
						let curCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court[key]
						if (curCfg) {
							let red = this.ConditionCheck(JSON.parse(curCfg.condition))
							if (red) {
								this.unlockRed = red
								this.unlockRedList[key] = true
							}
						}
					}
				}
				RedDotController.ins.up(RedKey.GOD_COURT_UNLOCK, this.unlockRed ? 1 : 0)
				this.Fire(GodCourtModel.REFRESH_RED, 1)
				//}
				GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			}
		}

		this.ShowRed = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("GodCourtView", true)) {
				return this.unlockRed
					|| this.devourRed
					|| this.upStageRed
					|| (this.comRed && CompositeModel.GetInstance().godCourtComRed)
					|| this.strenRed
					|| this.betterEquipRed
					|| this.lotteryRed
					|| this.rewardRed
					|| (this.FirstRedDot && CustomActivityModel.GetInstance().GetDayFirstLoginStatus())
			}
		}

		this.CanComposite = (id?) => {
			return false
		}

		this.ClearComSelect = () => {
			this.comSelect = []
			this.regualrMatList = []
		}

		this.GetTabRed = (godId?) => {
			if (((this.unlockRedList[godId] || this.strenRedList[godId]) || this.betterEquipList[godId]) || this.upStageRedList[godId]) {
				return true
			}
			return false
		}

		this.AutoEquip = (data?) => {
			if (data) {
				let bagList = GoodsModel.GetInstance().godCourtBagList
				for (let _tmpi in bagList) {
					let vo = bagList[_tmpi]
					if (vo.subtype == data.pos) {
						this.Fire(GodCourtModel.SEND_SCMD, 23303, "icl", data.godCourtId, data.pos, vo.goods_id)
						return true
					}
				}
			}
		}

		this.GetEquipPosGoodsVo = (godCourtId?, pos?) => {
			let equipInfo = this.GetEquipData(godCourtId, pos)
			if (equipInfo) {
				return GoodsModel.GetInstance().GetGoodsVoByGoodsId(equipInfo.equip_id)
			}
		}

		//CHECK
		this.CheckStrenRed = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("GodCourtView", true)) {
				//this:GetGameConfig("config_god_court_strength",(strenCfg?) => {
				//if (strenCfg ) {
				this.strenRedList = []
				this.strenRed = false
				let goodsNum = null
				for (let key in this.godcourtData) {
					let godCourtVo = this.godcourtData[key]
					if (godCourtVo.is_active != 0) {
						let curCfg = Config.PRELOAD_SERVER_CONFIG.config_god_court_strength[this.godcourtData[key].court_lv]
						if (curCfg) {
							let costList = JSON.parse(curCfg.cost)
							if (costList.length > 0) {
								goodsNum = GoodsModel.GetInstance().GetSpecialScore(Number(costList[0][1]))
								if (goodsNum >= Number(costList[0][2])) {
									this.strenRed = true
									this.strenRedList[key] = true
								}
							}
						}
					}
				}
				this.Fire(GodCourtModel.REFRESH_RED, 4)
				RedDotController.ins.up(RedKey.GOD_COURT_STRENGTH, this.strenRed ? 1 : 0)
				GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
				//}
				//this:DestoryGameConfig("config_god_court_strength", false)
				//}
				//, false)
			}
		}

		//CHECK
		this.CheckStageRed = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("GodCourtView", true)) {
				//this:GetGameConfig("config_god_court_equip_stage",(stageCfg?) => {
				//if (stageCfg ) {
				this.upStageRedList = []
				this.upStageRed = false
				let stageCanUp = []
				let id = null
				let goodsNum = null
				let cfg_stage = Config.PRELOAD_SERVER_CONFIG.config_god_court_equip_stage
				for (let key in cfg_stage) {
					let vo = cfg_stage[key]
					let cost = JSON.parse(vo.cost)
					if (cost.length > 0) {
						if (goodsNum == null) {
							goodsNum = GoodsModel.GetInstance().GetTypeGoodsNum(Number(cost[0][1]))
						}
						stageCanUp[key] = goodsNum >= Number(cost[0][2])
					}
				}
				if (goodsNum) {
					for (let key in this.godcourtData) {
						if (this.godcourtData[key].is_active != 0) {
							let equiplist = this.godcourtData[key].equip_list
							let PosList = null
							for (let _tmpi in equiplist) {
								let vo = equiplist[_tmpi]
								if ((vo.pos < 9 && vo.equip_id && vo.equip_id != 0) && stageCanUp[vo.stage]) {
									this.upStageRed = true
									if (!PosList) {
										PosList = []
									}
									PosList[vo.pos] = true
								}
							}
							if (PosList) {
								this.upStageRedList[key] = PosList
							}
						}
					}
				}
				this.Fire(GodCourtModel.REFRESH_RED, 2)
				RedDotController.ins.up(RedKey.GOD_COURT_UPSTAGE, this.upStageRed ? 1 : 0)
				GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
				//}
				//this:DestoryGameConfig("config_god_court_equip_stage", false)
				//}
				//, false)
			}
		}

		this.CheckEquipReddot = () => {
			let list = GoodsModel.GetInstance().godCourtBagList
			let bestList = []
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (!bestList[vo.subtype] || vo.rating > bestList[vo.subtype].rating) {
					bestList[vo.subtype] = vo
				}
			}
			this.betterEquipRed = false
			this.betterEquipList = []
			for (let key in this.godcourtData) {
				let godCourtVo = this.godcourtData[key]
				if (godCourtVo.is_active && godCourtVo.is_active != 0) {
					let equiplist = godCourtVo.equip_list
					let posList = null
					for (let _tmpi in equiplist) {
						let vo = equiplist[_tmpi]
						let rating = 999999
						if (vo.equip_id != 0) {
							let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(vo.equip_id)
							if (goodsVo) {
								rating = goodsVo.rating
							}
						}
						if ((vo.equip_id == 0 && bestList[vo.pos]) || ((vo.equip_id && bestList[vo.pos]) && bestList[vo.pos].rating > rating)) {
							if (vo.pos > 8 && !godCourtVo.canEquipCore) {
							} else {
								this.betterEquipRed = true
								if (!posList) {
									posList = []
								}
								posList[vo.pos] = true
							}
						}
					}
					if (posList) {
						this.betterEquipList[key] = posList
					}
				}
			}
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			this.Fire(GodCourtModel.REFRESH_RED, 5)
			RedDotController.ins.up(RedKey.GOD_COURT_BETTER_EQUIP, this.betterEquipRed ? 1 : 0)
		}

		this.CheckDevourRed = () => {
			let list = GoodsModel.GetInstance().godCourtBagList
			this.devourRed = false
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.subtype == 17) {
					this.devourRed = true
					break
				}
			}
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			this.Fire(GodCourtModel.REFRESH_RED, 6)
			RedDotController.ins.up(RedKey.GOD_COURT_DEVOUR, this.devourRed ? 1 : 0)
		}

		this.CheckHouseRed = () => {
			let goodsNum = GoodsModel.GetInstance().GetTypeGoodsNum(801707)
			this.lotteryRed = goodsNum > 0
			this.rewardRed = false
			let houseData = this.houseData.grand_status
			if (houseData) {
				for (let _tmpi in houseData) {
					let vo = houseData[_tmpi]
					if (vo.status == 1) {
						this.rewardRed = true
					}
				}
			}
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			this.Fire(GodCourtModel.REFRESH_RED, 8)
			RedDotController.ins.up(RedKey.GOD_COURT_LOTTERY, this.lotteryRed ? 1 : 0)
			RedDotController.ins.up(RedKey.GOD_COURT_REWARD, this.rewardRed ? 1 : 0)
		}

		this.GetHouseRewardLv = () => {
			if (this.houseData) {
				return this.houseData.reward_lv
			}
			return 1
		}
		//是否有更高阶的替代 {N件套：0/1}
		this.IsHasHeight = (cfg, cus_list) => {
			if (!cfg) return 0
			let suitCfgList = JSON.parse(cfg.suit_attr)
			table.sort(cus_list, (a?, b?) => {
				return a.stage > b.stage
			})
			let obj = {}
			for (let _tmpi in suitCfgList) {
				let vo = suitCfgList[_tmpi]  //vo[0] ==几件套
				for (let key in cus_list) {
					let v_stage = cus_list[key].stage
					let num = cus_list[key].num
					if (obj[vo[0]] > v_stage) continue
					obj[vo[0]] = num >= vo[0] ? v_stage : 0
				}
			}
			return obj
		}
	}

	public static GetInstance() {
		if (!GodCourtModel._instance) {
			GodCourtModel._instance = new GodCourtModel()
		}
		return GodCourtModel._instance
	}

	public static GetNameBySubtype(subtype) {
		return GodCourtModel.SubtypeNameList[subtype]
	}

	public static GetColorEffectName(color) {
		if (color == 1) {
			return "shrine_green"
		} else if (color == 2) {
			return "shrine_blue"
		} else if (color == 3) {
			return "shrine_purple"
		} else if (color == 4) {
			return "shrine_yellow"
		} else if (color == 5) {
			return "shrine_red"
		}
		return ""
	}
}