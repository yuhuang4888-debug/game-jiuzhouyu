import { RedDotController } from "./../common/RedDotController"
import { RedKey } from "./../common/RedDotDefine"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

export const BabyEvent = {
	OPEN_VIEW: "BE1",
	REQUEST_PROTO: "BE2",
	UPDATE_BABY_BASIC: "BE3",
	BABY_CULSTAGE: "BE4",
	BABY_DATA_LIST: "BE5",
	BABY_CULTIVATE: "BE6",
	BABY_EQUIP_DATA: "BE7",
	BABY_ILLUSION_DATA: "BE8",
	BABY_FAMILY_DATA: "BE9",
	BABY_LIKE_RANK: "BE10",
	BABY_BELIKE_DATA: "BE11",
	UPDATE_TAB_RED: "BE12",
	SELECT_ILLU_ITEM: "BE13",
	UPDATE_TASK: "BE14",
	CONTRAST_EQUIP: "BE15",
	WEAR_SUCCESS: "BE16",
	UPDATE_EQUIP_FORGE_RED: "BE17",
	UPDATE_EQUIP_IMP_RED: "BE18",
	SELECT_EQUIP_ITEM: "BE19",//装备强化界面选择装备
	UPDATE_ILLU_RED: "BE20",
	CLICK_IMP_ICON: "BE21",
	UPDATE_IMPRINT_DATA: "BE22",
	ADD_IMPRINT_ITEM: "BE23",
	IMP_GOODS: "BE24",
	UPDATE_ILLU_FIGHT: "BE25",
	IMP_SUCCESS: "BE26",
	IMP_FAILED: "BE27",
	UPDATE_EQUIP_RED: "Be28"
}
window["BabyEvent"] = BabyEvent
export class BabyModel extends EventDispatcher {
	private static _instance: BabyModel
	public activeTime
	public babyUseId
	public babyName = `宝宝`
	public changedName
	/**宝宝培养界面信息03*/
	public babyCultivateData
	/**宝宝培养升阶信息04*/
	public babyCulStageData
	/**宝宝宝具信息*/
	public babyEquipData: any = {}
	/**宝宝幻化信息*/
	private _babyIllusionData
	/**宝宝家庭信息*/
	public babyFamilyData
	/**点赞列表*/
	public likeRank
	/**被点赞列表*/
	public belikeData
	/**宝宝信息列表*/
	public babyDataList: any = {}

	public TabRedList = {}
	/**界面索引*/
	/**选择的列表*/
	PosToMatList = []
	SelectGoodsList = {}
	IlluDataFinish
	public static ViewIndex = {
		Cultivate: 0,
		Family: 1,
		Equip: 2,
		Illusion: 3
	}

	public static BabyEqiupPos = [1, 2, 3, 4, 5, 6]
	//public stageMat
	clientCfg
	/**宝宝培养配置*/
	// culCfg
	/**宝宝常量配置*/
	babyCfg
	/**宝宝任务配置*/
	taskCfg
	/**宝宝幻行配置*/
	illuCfg
	/**宝宝幻行等级配置*/
	illuStageCfg
	/**宝宝默认资源id*/
	public DefaultRes = 901005
	/**宝宝装备升级配置*/
	babyEquipStren
	/**宝宝升阶装备*/
	babyEquipStage
	/**宝宝装备配置*/
	babyEquipCfg

	static GOODS_TYPE = 65
	static EquipMaxLv = 10
	FirstRed
	babyLikeRed = false
	stageRed
	lvTaskRed = false
	betterEquipRed
	// equipForgeMat = []


	//func
	InitCfg
	CanOpen
	CheckUpStage
	CheckUpLvRed
	CheckIlluRed
	GetWearEquipVo
	GetWearEquipInfo
	UpStageFuncOpen
	CanLvUp
	CanForgeEquip
	GetBabyStage
	CheckLvRed
	CheckBetterEquip
	GetIconRed
	public constructor() {
		super()
		let local_Config = Config
		let local_JSON = JSON
		let goods_model = GoodsModel.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let common_mgr = CommonManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		this.InitCfg = async () => {
			// await res_mgr.LoadGameConfig(this, "config_baby_figure_star", false, undefined, (obj)=>{
			// 	this.illuStageCfg = obj
			// 	res_mgr.DestoryGameConfig(this, "config_baby_figure_star", false)
			// })
			// await res_mgr.LoadGameConfig(this, "config_baby_figure", false, undefined, (obj)=>{
			// 	this.illuCfg = obj
			// 	res_mgr.DestoryGameConfig(this, "config_baby_figure", false)
			// })
		}

		this.CanOpen = (index, showTips?) => {
			return true
		}

		/**检查是否可以升阶*/
		this.CheckUpStage = (baby_stage_cfgs, baby_value_cfgs) => {
			let stageMat = local_JSON.parse(baby_value_cfgs[4].value)
			if (!this.UpStageFuncOpen(baby_value_cfgs)) {
				return
			}
			let data = this.babyCulStageData
			if (data) {
				let nextcfg = baby_stage_cfgs[`2@${data.stage}@${data.stage_lv + 1}`]
				if (!nextcfg) {
					nextcfg = baby_stage_cfgs[`2@${data.stage + 1}@1`]
				}
				if (nextcfg) {
					let needExp = nextcfg.exp_con - data.stage_exp
					if (stageMat) {
						for (let vo of stageMat) {
							let goodsNum = goods_model.GetTypeGoodsNum(vo[0])
							needExp -= goodsNum * vo[1]
							if (needExp <= 0) {
								this.ChangeVar("stageRed", true)
								return
							}
						}
					}
				}
				this.ChangeVar("stageRed", false)
			}
		}


		this.CheckUpLvRed = () => {
			let data = this.babyCultivateData
			let red = false
			if (data) {
				for (let vo of data.task_list) {
					if (vo.finish_state == 1) {
						red = true
						break
					}
				}
			}
			this.ChangeVar("lvTaskRed", red)
		}


		this.CheckIlluRed = (baby_figure_star_cfg) => {
			let data = this.babyIllusionData
			res_mgr.LoadGameConfig(this, "config_baby_figure", false, undefined, (obj) => {
				let illuCfg = obj
				if (data && illuCfg && baby_figure_star_cfg) {
					let red = false
					for (let key in illuCfg) {
						red = this.CanLvUp(key, obj, baby_figure_star_cfg)
						red_dot_mgr.SetRedStatus(local_ModuleType.BABY_ILLU_RED, Number(key), red)
						RedDotController.ins.add(RedKey.BABY_ILLU_RED + Number(key), RedKey.BABY_EQUIP_FOR)
						RedDotController.ins.up(RedKey.BABY_ILLU_RED + Number(key), red ? 1 : 0)
					}
					this.Fire(BabyEvent.UPDATE_ILLU_RED)
				}
				res_mgr.DestoryGameConfig(this, "config_baby_figure", false)
			})
		}

		this.GetWearEquipVo = (posId) => {
			let equip = this.GetWearEquipInfo(posId)
			if (equip) {
				return goods_model.baby_equip_dic[equip.id]
			}
		}

		this.GetWearEquipInfo = (posId) => {
			let list = this.babyEquipData.equip_list
			if (list) {
				return list[posId]
			}
		}



		this.UpStageFuncOpen = (baby_value_cfgs) => {
			if (!common_mgr.CheckFuncOpenState("BabyMainView", true)) {
				return
			}
			let cfg = baby_value_cfgs[3].value
			if (cfg) {
				if (this.babyCultivateData && this.babyCultivateData.raise_lv >= Number(cfg)) {
					return true
				}
			}
		}

		this.CanLvUp = (id, config_baby_figure, config_baby_figure_star) => {
			if (!this.IlluDataFinish) {
				return false
			}
			let data = this.babyIllusionData
			let red = false
			if (config_baby_figure && data) {
				let cfg = config_baby_figure[id]
				if (cfg) {
					let info = data[id]
					if (info) {
						let key = `${info.baby_id_a}@${info.baby_star + 1}`
						let cfg = config_baby_figure_star[key]
						if (cfg) {
							let cost = local_JSON.parse(cfg.cost)
							if (cost.length > 0) {
								let canActive = true
								for (let vo of cost) {
									let goodsNum = goods_model.GetTypeGoodsNum(vo[1])
									if (goodsNum < vo[2]) {
										canActive = false
										break
									}
								}
								if (canActive) {
									red = true
								}
							}
						}
					} else {
						let cost = local_JSON.parse(cfg.cost)
						if (cost.length > 0) {
							let canActive = true
							for (let vo of cost) {
								let goodsNum = goods_model.GetTypeGoodsNum(vo[1])
								if (goodsNum < vo[2]) {
									canActive = false
									break
								}
							}
							if (canActive) {
								red = true
							}
						}
					}
				}
			}
			return red
		}

		/**装备锻造红点*/
		this.CanForgeEquip = (posId, baby_value_cfg, baby_equip_stage_cfg, baby_equip_stren_cfg) => {
			let equipForgeMat = local_JSON.parse(baby_value_cfg[8].value)
			let data = this.GetWearEquipInfo(posId)
			if (data) {
				let key = `${data.pos_id}@${data.estage}@${data.estage_lv + 1}`
				let nextCfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_baby_equip_stren.name, key, false, baby_equip_stren_cfg)
				if (nextCfg) {//升级模式
					let needExp = nextCfg.point_con - data.estage_exp
					for (let vo of equipForgeMat) {
						let exp = goods_model.GetTypeGoodsNum(vo[0]) * vo[1]
						if (exp >= needExp) {
							return true
						} else {
							needExp -= exp
						}
					}
				} else {//升阶状态
					key = `${data.pos_id}@${data.estage + 1}@0`
					nextCfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_baby_equip_stren.name, key, false, baby_equip_stren_cfg)
					if (nextCfg) {
						let nextStageCfg = baby_equip_stage_cfg[`${data.estage + 1}`]
						if (nextStageCfg) {
							let cost = local_JSON.parse(nextStageCfg.cost)
							if (cost.length > 0) {
								for (let vo of cost) {
									let have_num = goods_model.GetTypeGoodsNum(vo[1])
									if (have_num < vo[2]) {
										return false
									}
								}
								return true
							}
						}
					}
				}
			}
		}


		this.GetBabyStage = () => {
			if (this.babyCulStageData) {
				return this.babyCulStageData.stage
			}
			return 0
		}

		this.CheckLvRed = () => {
			if (this.FirstRed) {
				this.FirstRed = false
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
				GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Love)
			}
		}


		this.CheckBetterEquip = () => {
			let BagequipList = goods_model.baby_bag_list
			let red = false
			for (let vo of BagequipList) {
				let data = this.GetWearEquipVo(vo.equip_type)
				if (!data || data.rating < vo.rating) {
					red = true
					break
				}
			}
			this.ChangeVar("betterEquipRed", red)
		}

		this.GetIconRed = () => {
			if (!common_mgr.CheckFuncOpenState("BabyMainView", true)) {
				return false
			}
			return this.stageRed || red_dot_mgr.GetRedStatus(local_ModuleType.BABY_ILLU_RED) || this.lvTaskRed || this.FirstRed || this.babyLikeRed
				|| red_dot_mgr.GetRedStatus(local_ModuleType.BABY_EQUIP_FOR) || this.betterEquipRed
			// || RuneTreasureModel.GetInstance().babyTreasureRed
		}
	}
	public static GetInstance() {
		if (!BabyModel._instance) {
			BabyModel._instance = new BabyModel()
		}
		return BabyModel._instance
	}
	/**获取星座*/
	public static GetConstellation(mount, date) {
		let total = mount * 100 + date
		if (total >= 121 && total <= 219) {
			return `水瓶`
		} else if (total >= 220 && total <= 320) {
			return `双鱼`
		} else if (total >= 321 && total <= 420) {
			return `白羊`
		} else if (total >= 421 && total <= 521) {
			return `金牛`
		} else if (total >= 522 && total <= 621) {
			return `双子`
		} else if (total >= 622 && total <= 722) {
			return `巨蟹`
		} else if (total >= 723 && total <= 823) {
			return `狮子`
		} else if (total >= 824 && total <= 923) {
			return `处女`
		} else if (total >= 924 && total <= 1023) {
			return `天秤`
		} else if (total >= 1024 && total <= 1122) {
			return `天蝎`
		} else if (total >= 1123 && total <= 1221) {
			return `射手`
		} else {
			return `摩羯`
		}
	}
	public get babyIllusionData() {
		return this._babyIllusionData || {}
	}

	public set babyIllusionData(value) {
		if (!this._babyIllusionData) {
			this._babyIllusionData = {}
		}
		for (let vo of value) {
			this._babyIllusionData[vo.baby_id_a] = vo
			// this.Fire(BabyEvent.BABY_ILLUSION_DATA)
		}
	}

	public static GetBlood(time) {
		switch (time % 4) {
			case 0:
				return `A`;
			case 1:
				return `B`;
			case 2:
				return `O`;
			case 3: return `AB`;
		}
	}




}

window["BabyModel"] = BabyModel