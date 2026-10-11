import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { Demon } from "../scene/sceneobj/Demon"
import { Partner } from "../scene/sceneobj/Partner"
import { Sprite } from "../scene/sceneobj/Sprite"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { PlayBigEffect, Util } from "../util/Util"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { isCallChain } from "../../node_modules/typescript/lib/typescript"
import { FairyWishModel } from "./FairyWishModel"
import { TaskModel } from "./TaskModel"
import { FashionModel } from "./FashionModel"
import { CookieWrapper } from "../common/CookieWrapper"

export enum MountPetViewIndex {
	Mount = 0,
	Partner = 1,
	GodBefall = 2,
	Demon = 3,
	Sprite = 5
}
window["MountPetViewIndex"] = MountPetViewIndex;

export enum enum_OutWardType {
	Horse = 1,
	Partner = 2,
	Wings = 3,
	// 神兵和御守写反了，界面类型神兵是HolyDevice，这里变成了Artifact
	Artifact = 4,
	HolyDevice = 5,
	Sprite = 6,
	Pet = 7,
	MagicArr = 8,
	BackOrnament = 12,
}

export const type_OutWardIcon ={
	"2":"wxzg_zq",
	"3":"wxzg_yy",
	"4":"wxzg_sb",
	"5":"wxzg_ys",
	"8":"wxzg_sh",
}
export const OutWarIlluTypeRedKeyMap = {
	[enum_OutWardType.Horse]: RedKey.ILLU_HORSE,
	[enum_OutWardType.Partner]: RedKey.ILLU_PEP,
	[enum_OutWardType.Wings]: RedKey.ILLU_WING,
	[enum_OutWardType.HolyDevice]: RedKey.ILLU_ARTIFACT,
	[enum_OutWardType.Artifact]: RedKey.ILLU_HOLYDEVICE,
	[enum_OutWardType.BackOrnament]: RedKey.BACK_ORNAMENT,
}
export const OutWarDevTypeRedKeyMap = {
	[enum_OutWardType.Horse]: RedKey.HORSE,
	[enum_OutWardType.Partner]: RedKey.PEP,
	[enum_OutWardType.Wings]: RedKey.ROLE_DEV_WING,
	[enum_OutWardType.HolyDevice]: RedKey.ROLE_DEV_ARTIFACT,
	[enum_OutWardType.Artifact]: RedKey.ROLE_DEV_HOLYDEVICE,
	[enum_OutWardType.BackOrnament]: RedKey.ROLE_DEV_BACK_ORNAMENT,
}
window["enum_OutWardType"] = enum_OutWardType;

export class OutWardBaseModel extends EventDispatcher {
	public static UPDATE_OUTWARD_DATA = "UPDATE_OUTWARD_DATA";
	public static ILLUSION_OUTWARD = "ILLUSION_OUTWARD";
	public static REQUEST_OUTWARD_INFO = "REQUEST_OUTWARD_INFO";
	public static OUTWARD_EVOLUTION = "OUTWARD_EVOLUTION";
	public static REQUEST_ILLUSION_INFO = "REQUEST_ILLUSION_INFO";
	public static REQUEST_OUTWARD_DATA = "REQUEST_OUTWARD_DATA";
	public static ACTIVE_OUTWARD_FIGURE = "ACTIVE_OUTWARD_FIGURE";
	public static EVOLUTION_OUTWARD_FIGURE = "EVOLUTION_OUTWARD_FIGURE";
	public static USE_OUTWARD_ITEM = "USE_OUTWARD_ITEM";
	public static ILLUSION_OUTWARD_SUCCESS = "ILLUSION_OUTWARD_SUCCESS";
	public static UPDATA_OUTWARD_EVOLUTION_DATA = "UPDATA_OUTWARD_EVOLUTION_DATA";
	public static UPDATE_OUTWARD_ILLUSION_VIEW = "UPDATE_OUTWARD_ILLUSION_VIEW";
	public static UPDATE_OUTWARD_FIGURE_DATA = "UPDATE_OUTWARD_FIGURE_DATA";
	public static ATIVATE_OUTWARD_FIGURE_SUCCESS = "ATIVATE_OUTWARD_FIGURE_SUCCESS";
	public static UPDATE_OUTWARD_CRYSTAL_DATA = "UPDATE_OUTWARD_CRYSTAL_DATA";
	public static OPEN_OUTWARD_ILLUSION_VIEW = "OPEN_OUTWARD_ILLUSION_VIEW";
	public static OPEN_MOUNTPET_ILLUSION_VIEW = "OPEN_MOUNTPET_ILLUSION_VIEW";
	public static OPEN_MOUNTPET_VIEW = "OPEN_MOUNTPET_VIEW";
	public static OPEN_OUTWARD_VIEW = "OPEN_OUTWARD_VIEW";
	public static UPDATA_OUTWARD_FIGURE_EVOLUTION_DATA = "UPDATA_OUTWARD_FIGURE_EVOLUTION_DATA";
	public static USE_CRYSTAL_SUCCESS = "USE_CRYSTAL_SUCCESS";
	public static SELECT_RESOLVE_VIEW = "SELECT_RESOLVE_VIEW";
	public static PET_ACTIVE_LIMIT = "PET_ACTIVE_LIMIT";
	public static SELECT_ILLUSION_ITEM = "SELECT_ILLUSION_ITEM";
	public static REQUEST_PROTO = "REQUEST_PROTO";
	public static CANCEL_ACTIVE = "CANCEL_ACTIVE";
	public static UPDATE_PET_RESLOVE_RED = "UPDATE_PET_RESLOVE_RED";
	public static OPEN_VIEW = "OPEN_VIEW";
	public static UPDATE_OUTWARD_RED = "UPDATE_OUTWARD_RED";
	public static UPDATE_CULTURE_RED = "UPDATE_CULTURE_RED";
	public static UPDATE_ILLUSION_RED = "UPDATE_ILLUSION_RED";
	public static UPDATE_SKILL_POWER = "UPDATE_SKILL_POWER";
	public static UPDATE_SMELT_DATA = "OWE1";
	public static SELECT_SMELT = "OWE2";
	public static SMELT_GOODS = "OWE3";
	public static SELECT_ILLU_STAR_ITEM = "OWE4";
	public static UPSTAR_SUCCESS = "OWE5";
	public static REAL_FIGHT = "OW6";
	public static UPDATE_AUTO_STATE = "OW7";
	public static UPLV_FAILD = "OW8";
	public static CHANGE_VIEW = "OW9";
	public static OUTWARD_CHANGE_VIEW_CLOSE = "OW10";
	public static UPDATE_STAR_FIGHT = "OW11";
	public static CHANGE_HORSE_STATE = "OW12";
	public static REQUEST_LV_INFO = "REQUEST_LV_INFO"//请求新升级系统的信息
	public static UPDATE_LV_VIEW = "UPDATE_LV_VIEW" //刷新升级系统显示
	public static REQUEST_LV_UP = "REQUEST_LV_UP"    //升级系统升级
	public static REQUEST_LV_UP_SKILL = "REQUEST_LV_UP_SKILL"   //升级系统技能升级
	public static UPDATE_LV_UP_SYSTEM_VIEW = "UPDATE_LV_UP_SYSTEM_VIEW"
	public static UPDATE_LVSYSTEM_SKILL_VIEW = "UPDATE_LVSYSTEM_SKILL_VIEW"
	public static UPDATE_LV_RED_OPEN_STATE = "UPDATE_LV_RED_OPEN_STATE"

	/**法阵展示间隔时间*/
	public static MagicArrShowTime = 10
	public static Instance: OutWardBaseModel

	public outward_max_stage = {}
	public illu_max_stage_list = {}
	//数据 16002 
	public outward_data_list = {}
	//已经激活的幻化 16006
	public outward_illu_data_list = {}
	//请求的幻化 16007
	public outward_figure_list = {}

	public outward_skill_cfg
	public outward_stage_cfg
	public outward_crystal_cfg
	public outward_star_cfg
	public outward_illusion_cfg
	public outward_figure_stage_cfg
	public outward_action_cfg
	public outward_pos_cfg
	public upStarCfg
	public select_resolve_num = 0 

	public typetoword = {
		"1": "坐骑",
		"2": "侍魂",
		"3": "羽翼",
		"4": "神器",
		"5": "御守",
		"6": "精灵",
		"7": "飞骑",
		"8": "法阵",
		"12": "背饰"
	}

	public active_illu_list = {}

	//吞噬模块
	public smeltInfo = {}
	public selectSmelt = {}
	public horseSmeltRed = false
	public partnerSmeltRed = false
	public useDiaFlag = {}
	public auto_horse = true

	/**等级红点开关 */
	lv_red_open_state_dic
	//func
	SetOutWardData
	GetOutWardData
	UpdateOutWardStrongerRed
	UpdateOutWardFigure
	UpdateOutWardEvolutionData
	UpdataOutWardIllusionData
	UpdateOutWardFigureData
	UpdateOutWardFigureEvolutionData
	UpdateOutWardCrystalUseData
	GetLvCfg
	GetConfig
	GetExpItemList
	GetCrystalList
	GetDefaultSkillList
	GetIllusionList
	GetCrystalData
	ShowCrytalDot
	GetMaxStar
	GetReddotState
	GetPetResolveList
	GetDistinguishKey
	ShowCultureRed
	ShowIlluRed
	ShowPetResolveRed
	ShowHoresIconRed
	ShowOutWardIconRed
	SetTrainSkill
	SetIllusionSkill
	GetSkillId
	GetIllusionCfgByKey
	GetIllusionSatgeCfgByKey
	GetOutWardSmeltData
	CheckTypeIconRed
	CanLvUp
	CanIllusionUP
	SelectSmeltGoods
	CheckSmeltRed
	CheckResolveRed
	CheckIlluStarRed
	GetRedType
	HasActiveIllu
	SetLvSystemInfo
	GetLvSystemInfo
	LvsystemCanLvUp
	GetLvSystemGoods
	UpdaLvSysteInfo
	LvsystemSkillCanLvUp
	GetLvSystemOpenState
	ChangeLvRedOpenState
	SaveLvRedOpenStateCookies
	Choose_Tab //骑宠界面页签选择
	public constructor() {
		super()

		if (OutWardBaseModel.Instance) {
			return
		}

		let local_OutWardBaseModel = OutWardBaseModel
		let role_mgr = RoleManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_enum_OutWardType = enum_OutWardType
		let config_preload_server = Config.PRELOAD_SERVER_CONFIG
		let config_preload_client = Config.PRELOAD_CLIENT_CONFIG
		let local_Number = Number
		let local_FairyModel = FairyWishModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_JSON = JSON
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let common_mgr = CommonManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let open_level_list_ = {}
		let outward_crystal_data_ = {}
		let check_illusion_red_ = {}
		let outward_goods_cfg_
		let constant_cfg_
		let smeltCfg_
		let smeltExpCfg_
		let cfg_ready_ = false
		let outward_material_list_ = {}
		let outward_skill_list_ = {}
		let outward_crystal_list_ = {}
		let outward_illusion_list_ = {}
		let pet_reolve_list_ = []
		let pet_reolve_material_list_ = []
		let use_skill_id_list_ = {}
		let smeltExp_ = 0
		let outward_lv_info_list = {}
		let outwrard_lvsystem_goods = {}
		this.Choose_Tab = 1
		this.SetOutWardData = (data?) => {
			this.outward_data_list[data.type_id] = data
			this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_DATA, data)
			this.UpdateOutWardStrongerRed(data.type_id)
			this.SetTrainSkill(data.type_id)
			if (data.type_id == 2) {
				let partner = Scene.GetInstance().GetPartner(role_mgr.mainRoleInfo.role_id)
				if (partner && partner.vo) {
					//partner.vo.SetPartherProperty(data.attr_list)
				}
			}
			this.CheckTypeIconRed(data.type_id)
		}

		this.UpdateOutWardStrongerRed = (type_id) =>{
			let red = this.ShowCultureRed(type_id) || this.ShowIlluRed(type_id) || local_FairyModel.ShowFairyRed(type_id)
			if (OutWarDevTypeRedKeyMap[type_id]) {
				RedDotController.ins.up(OutWarDevTypeRedKeyMap[type_id], red ? 1 : 0)
			}
			this.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, type_id, red)
		}

		this.GetOutWardData = (type_id?) => {
			if (this.outward_data_list) {
				return this.outward_data_list[type_id]
			}
		}

		this.UpdateOutWardFigure = (data?) => {
			if (data.type == 1) {
				if (this.outward_data_list && this.outward_data_list[data.type_id]) {
					this.outward_data_list[data.type_id].figure_stage = data.args
				}
				if (this.outward_illu_data_list && this.outward_illu_data_list[data.type_id]) {
					this.outward_illu_data_list[data.type_id].illusion_id = 0
				}
			} else if (data.type == 2) {
				if (this.outward_data_list && this.outward_data_list[data.type_id]) {
					this.outward_data_list[data.type_id].figure_stage = 0
				}
				if (this.outward_illu_data_list && this.outward_illu_data_list[data.type_id]) {
					this.outward_illu_data_list[data.type_id].illusion_id = data.args
				}
			}
			if (data.type == 1) {
				this.SetTrainSkill(data.type_id)
			} else if (data.type == 2) {
				this.SetIllusionSkill(data.type_id)
			}
			this.Fire(local_OutWardBaseModel.ILLUSION_OUTWARD_SUCCESS, data)
		}

		this.UpdateOutWardEvolutionData = (data?) => {
			if (data) {
				let is_up = false
				if (this.outward_data_list[data.type_id] && (this.outward_data_list[data.type_id].star != data.star || this.outward_data_list[data.type_id].stage != data.stage)) {
					if (this.outward_data_list[data.type_id].stage != data.stage) {
						data.isFirst = false;
						data.cb = () => {
							this.Fire(OutWardBaseModel.ILLUSION_OUTWARD, data.type_id, 1, data.stage, 0)
						}
						this.Fire(local_OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data, 0)
					} else {

						if (data.type_id == enum_OutWardType.Partner || data.type_id == enum_OutWardType.Horse) {
							Laya.timer.frameOnce(3, this, () => {
								PlayBigEffect("ui_shengxingchengong")
							}, null, true)
						} else {
							Laya.timer.frameOnce(3, this, () => {
								PlayBigEffect("ui_shengjitexiao")
							}, null, true)
						}

					}
					is_up = true
					this.outward_data_list[data.type_id].star = data.star
					if (this.outward_data_list[data.type_id].stage < data.stage) {
						this.outward_data_list[data.type_id].stage = data.stage
					}
					let x = data.type_id
					this.Fire(local_OutWardBaseModel.REQUEST_OUTWARD_INFO, data.type_id)
				}
				this.outward_data_list[data.type_id].blessing = data.blessing
				this.outward_data_list[data.type_id].etime = data.etime
				this.Fire(local_OutWardBaseModel.UPDATA_OUTWARD_EVOLUTION_DATA, data, is_up)
			}
		}

		this.UpdataOutWardIllusionData = (data?) => {
			ResManager.GetInstance().LoadGameConfig(this, "config_mount_figure", false, null, (cfg) => {
				this.outward_illusion_cfg = cfg
				if (this.outward_illu_data_list) {
					this.outward_illu_data_list[data.type_id] = data
				}
				if (data.type_id == local_enum_OutWardType.Pet) {
					pet_reolve_material_list_ = null
					pet_reolve_material_list_ = []
					for (let Vo of data.figure_list) {
						let active_cfg = this.outward_illusion_cfg[`7@${Vo.id}@${role_mgr.GetMainRoleVo().career}`]
						if (active_cfg) {
							pet_reolve_material_list_.push(active_cfg.goods_id)
						}
					}
				}
				this.active_illu_list[data.type_id] = {}
				for (let Vo of data.figure_list) {
					this.active_illu_list[data.type_id][Vo.id] = Vo
					if (OutWarIlluTypeRedKeyMap[data.type_id]) {
						let key = `${data.type_id}@${Vo.id}@${Vo.stage}`
						let illusion_cfg = this.outward_figure_stage_cfg[key]
						if(illusion_cfg){
							let goods_list = local_JSON.parse(illusion_cfg.cost)
							if (goods_list.length > 0 && goods_model.GetTypeGoodsNum(goods_list[0][1]) >= Number(goods_list[0][2])) {
								RedDotController.ins.up(OutWarIlluTypeRedKeyMap[data.type_id], 1)
							}
						}
					}
				}
				if (!check_illusion_red_[data.type_id]) {
					if (data.type_id == 1 || data.type_id == 2 || data.type_id == 7) {
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
						check_illusion_red_[data.type_id] = true
						for (let vo of data.figure_list) {
							this.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16007, "ci", data.type_id, vo.id)
						}
						if (data.type_id == 1) {
							//this:ChangeVar("horseSmeltRed", this.CheckResolveRed(1))
						} else if (data.type_id == 2) {
							//this:ChangeVar("partnerSmeltRed", this.CheckResolveRed(2))
						}
					} else {
						check_illusion_red_[data.type_id] = true
						local_GlobalEventSystem.Fire(local_EventName.CHECK_ITEM_USE)
					}
				}
				this.SetIllusionSkill(data.type_id)
				this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_ILLUSION_VIEW, data)
				this.CheckTypeIconRed(data.type_id)
				FashionModel.GetInstance().TryRefreshSuitUpStageRed()
			})

		}

		this.UpdateOutWardFigureData = (data?) => {
			if (this.outward_figure_list) {
				if (!this.outward_figure_list[data.type_id]) {
					this.outward_figure_list[data.type_id] = {}
				}
				if (!this.outward_figure_list[data.type_id][data.id]
					&& (data.type_id == local_enum_OutWardType.Horse || data.type_id == local_enum_OutWardType.Partner || data.type_id == local_enum_OutWardType.Pet)) {
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
				}
				this.outward_figure_list[data.type_id][data.id] = data
				this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_FIGURE_DATA, data)
			}
		}

		this.UpdateOutWardFigureEvolutionData = (data?) => {
			this.Fire(local_OutWardBaseModel.UPDATA_OUTWARD_FIGURE_EVOLUTION_DATA, data)
		}

		this.UpdateOutWardCrystalUseData = (data?) => {
			if (outward_crystal_data_) {
				ResManager.GetInstance().LoadGameConfig(this, "config_mount_goods", false, null, (cfg) => {
					this.outward_crystal_cfg = cfg
					outward_crystal_data_[data.type_id] = data.counter_list
					this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_CRYSTAL_DATA, data)
					let red = this.ShowCultureRed(data.type_id) || this.ShowIlluRed(data.type_id)
					this.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, data.type_id, red)
					if (data.type_id == local_enum_OutWardType.Horse || data.type_id == local_enum_OutWardType.Partner) {
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
					} else if (data.type_id == local_enum_OutWardType.Wings || data.type_id == local_enum_OutWardType.HolyDevice 
						|| data.type_id == local_enum_OutWardType.Artifact || data.type_id == local_enum_OutWardType.MagicArr 
						|| data.type_id == local_enum_OutWardType.BackOrnament) {
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
						this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_RED)
					}
				})
			}
		}

		this.GetLvCfg = () => {
			constant_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_mount_constant
			if (constant_cfg_) {
				for (let index in local_enum_OutWardType) {
					if (!isNaN(local_Number(index))) {
						if (constant_cfg_[index]) {
							open_level_list_[index] = constant_cfg_[index].val
						}
					}

				}
				this.outward_max_stage[1] = constant_cfg_[11].val
				this.outward_max_stage[2] = constant_cfg_[11].val
				this.outward_max_stage[3] = 1
				this.outward_max_stage[4] = 1
				this.outward_max_stage[5] = 1
				this.outward_max_stage[6] = 1
				this.outward_max_stage[7] = 1
				this.outward_max_stage[8] = 1
				this.outward_max_stage[12] = 1
				if (constant_cfg_[13] && constant_cfg_[13].val) {
					local_OutWardBaseModel.MagicArrShowTime = constant_cfg_[13].val
				}
			}
		}

		this.GetConfig = () => {
			outward_goods_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_mount_prop
			this.outward_skill_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_skill
			this.outward_crystal_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_goods
			this.outward_stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_stage
			this.outward_star_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_star
			this.outward_illusion_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_figure
			this.outward_figure_stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_figure_stage
			// smeltCfg_ = res_mgr.LoadGameConfig(this, "Mountdevour", false)
			// smeltExpCfg_ = res_mgr.LoadGameConfig(this, "Mountdevourexp", false)
			this.outward_action_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardModel
			this.outward_pos_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardPos

			this.upStarCfg = Config.PRELOAD_SERVER_CONFIG.config_mount_figure_star
			this.CheckIlluStarRed(local_enum_OutWardType.Horse)
			this.CheckIlluStarRed(local_enum_OutWardType.Partner)
			GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
			GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
		}

		this.GetExpItemList = (type_id?, type?) => {
			if (!outward_material_list_[type_id]) {
				for (let index in outward_goods_cfg_) {
					if (!outward_material_list_[outward_goods_cfg_[index].type_id]) {
						outward_material_list_[outward_goods_cfg_[index].type_id] = {}
					}
					outward_material_list_[outward_goods_cfg_[index].type_id][index] = outward_goods_cfg_[index]
				}
			}
			if (type) {
				let list = {}
				for (let k in outward_material_list_[type_id]) {
					let v = outward_material_list_[type_id][k]
					if (v.type == type) {
						list[k] = v
					}
				}
				return list
			}
			return outward_material_list_[type_id]
		}

		this.GetCrystalList = (type_id?) => {
			if (!outward_crystal_list_[type_id]) {
				for (let index in this.outward_crystal_cfg) {
					if (!outward_crystal_list_[this.outward_crystal_cfg[index].type_id]) {
						outward_crystal_list_[this.outward_crystal_cfg[index].type_id] = {}
					}
					outward_crystal_list_[this.outward_crystal_cfg[index].type_id][index] = this.outward_crystal_cfg[index]
				}
			}
			return outward_crystal_list_[type_id]
		}

		this.GetDefaultSkillList = (type_id?) => {
			if (!outward_skill_list_[type_id]) {
				for (let index in this.outward_skill_cfg) {
					if (this.outward_skill_cfg[index].type == 1) {
						let skill_info = SkillManager.GetInstance().getSkillFromConfig(this.outward_skill_cfg[index].skill_id)
						if (skill_info && skill_info.type != 1) {
							if (!outward_skill_list_[this.outward_skill_cfg[index].type_id]) {
								outward_skill_list_[this.outward_skill_cfg[index].type_id] = []
							}
							outward_skill_list_[this.outward_skill_cfg[index].type_id].push(this.outward_skill_cfg[index])
						}
					}
				}
				let sort_func = (a?, b?) => {
					return a.stage > b.stage
				}

				for (let index in outward_skill_list_) {
					if (outward_skill_list_[index]) {
						table.sort(outward_skill_list_[index], sort_func)
					}
				}
			}

			return outward_skill_list_[type_id]
		}

		this.GetIllusionList = (enum_id?) => {
			if (!outward_illusion_list_[enum_id] && this.outward_illusion_cfg) {
				let illusion_type_list = {}
				outward_illusion_list_[enum_id] = {}
				for (let index in this.outward_illusion_cfg) {
					if (this.outward_illusion_cfg[index].type_id == enum_id) {
						illusion_type_list[this.outward_illusion_cfg[index].id] = this.outward_illusion_cfg[index]
					}
				}
				outward_illusion_list_[enum_id] = illusion_type_list
			}

			return outward_illusion_list_[enum_id]
		}

		this.GetCrystalData = (type_id?) => {
			return outward_crystal_data_[type_id]
		}

		this.GetMaxStar = (type_id?, stage?) => {
			let key = `${type_id}@${stage}@${role_mgr.GetMainRoleVo().career}`
			let cfg = this.outward_stage_cfg
			let cfg_k = cfg && cfg[key]
			if (cfg_k) {
				return Number(cfg_k.max_star)
			}
		}

		this.GetReddotState = (type_id?, id?) => {
			let open_day: number = ServerTimeModel.GetInstance().GetOpenServerDay();
			if (this.active_illu_list[type_id]) {
				if (this.active_illu_list[type_id][id]) {

					// 坐骑开服三天不需要红点 
					if (open_day == 3 && type_id == 1) {
						return false;
					}
					// 待魂开服四天不需要红点
					if (open_day == 4 && type_id == 2) {
						return false;
					}

					if (!this.outward_figure_stage_cfg || !this.outward_illusion_cfg) {
						return false
					}
					let activeInfo = this.active_illu_list[type_id][id]
					if (!this.outward_figure_stage_cfg[`${type_id}@${id}@${activeInfo.stage + 1}`] || (!this.outward_figure_list[type_id] && (type_id == local_enum_OutWardType.Horse || type_id == local_enum_OutWardType.Partner))) {
						return false
					}
					let key = `${type_id}@${id}@${activeInfo.stage}`
					let illusion_cfg = this.outward_figure_stage_cfg[key]
					if (illusion_cfg) {
						if (type_id == local_enum_OutWardType.Horse || type_id == local_enum_OutWardType.Partner) {
							let info = this.outward_figure_list[type_id][id]
							if (info) {
								let needExp = illusion_cfg.max_blessing - info.blessing
								let cost_cfg = this.outward_illusion_cfg[`${type_id}@${id}@${role_mgr.GetMainRoleVo().career}`]
								let cost
								if (cost_cfg) {
									cost = cost_cfg.exp_goods && local_JSON.parse(cost_cfg.exp_goods)
								}
								if (cost) {
									for (let k in cost) {
										let v = cost[k]
										let goods_list = this.GetExpItemList(type_id)
										for (let k1 in goods_list) {
											let v1 = goods_list[k1]
											if (Number(v) == v1.goods_id) {
												let goodsNum = goods_model.GetTypeGoodsNum(v1.goods_id)
												needExp = needExp - goodsNum * v1.exp
												if (needExp <= 0) {
													return true
												}
											}
										}
									}
								}
							}
						} else {
							let goods_list = local_JSON.parse(illusion_cfg.cost)
							if (goods_list.length > 0 && goods_model.GetTypeGoodsNum(goods_list[0][1]) >= Number(goods_list[0][2])) {
								return true
							}
						}
					}
				} else {
					let key = `${type_id}@${id}@${role_mgr.GetMainRoleVo().career}`
					let cfg = this.outward_illusion_cfg[key]
					if (cfg) {
						let goods_num = goods_model.GetTypeGoodsNum(cfg.goods_id)
						let condition_list = local_JSON.parse(cfg.condition_list)
						if (condition_list.length > 0) {
							for (let vo of condition_list) {
								if ("turn" == vo[0]) {
									let show_red = role_mgr.GetMainRoleVo().turn >= Number(vo[1])
									if (!show_red) {
										return false
									}
								} else if ("active_id" == vo[0]) {
									if ((this.active_illu_list[type_id] && this.active_illu_list[type_id][vo[1].id]) && this.active_illu_list[type_id][vo[1].id].stage >= vo[1].lv) {

									} else {
										return false
									}
								}
							}
						}
						if (goods_num >= cfg.goods_num) {
							return true
						}
					}
				}
			}
			return false
		}

		this.GetPetResolveList = (type_id?) => {
			let pet_illu = this.GetIllusionList(type_id)
			let goods_count = 0
			for (let index in pet_illu) {
				let goods_type_id = pet_illu[index].goods_id
				let goodsVo = goods_model.GetTypeGoods(goods_type_id)
				if (!Util.IsTableEmpty(goodsVo)) {
					if (this.active_illu_list[type_id][pet_illu[index].id]) {
						pet_reolve_list_.splice(goods_count, 1, { goodsData: goodsVo, index: goods_count, select_state: false, gary: false, type: type_id })
					} else {
						pet_reolve_list_.splice(goods_count, 1, { goodsData: goodsVo, index: goods_count, select_state: false, gary: true, type: type_id })
					}
					goods_count++
				}
				let fragmentId = goods_type_id + 100
				goodsVo = goods_model.GetTypeGoods(fragmentId)
				if (!Util.IsTableEmpty(goodsVo)) {
					if (this.active_illu_list[type_id][pet_illu[index].id]) {
						pet_reolve_list_.splice(goods_count, 1, { goodsData: goodsVo, index: goods_count, select_state: false, gary: false, type: type_id })
					} else {
						pet_reolve_list_.splice(goods_count, 1, { goodsData: goodsVo, index: goods_count, select_state: false, gary: true, type: type_id })
					}
					goods_count++
				}
			}
			let total_count = goods_count + 40 - (goods_count % 4)
			for (goods_count; goods_count < total_count; goods_count++) {
				pet_reolve_list_.splice(goods_count, 1, { color: 0, index: -1, select_state: false, gary: false })
			}
			pet_reolve_list_.splice(goods_count)
			return pet_reolve_list_
		}

		this.GetDistinguishKey = (type_id?, key?) => {
			if (key) {
				let career = role_mgr.mainRoleInfo.career
				key = `${key}@${career}`
			}
			return key
		}

		this.ShowCultureRed = (type_id?) => {
			if (!this.outward_data_list[type_id]) {
				return false
			}
			if (this.CanLvUp(type_id)) {
				return true
			}
			if (this.LvsystemCanLvUp(type_id)) {
				return true
			}
			if (this.LvsystemSkillCanLvUp(type_id)) {
				return true
			}
			if (this.ShowCrytalDot(type_id)) {
				return true
			}
			return false
		}

		this.ShowCrytalDot = (type_id?) => {
			let cry_data = this.GetCrystalData(type_id)
			if (cry_data) {
				for (let crystalVo of cry_data) {
					let goods_num = goods_model.GetTypeGoodsNum(crystalVo.goods_id)
					if (goods_num > 0) {
						let times = crystalVo.times
						let key = `${type_id}@${crystalVo.goods_id}`
						let cfg = this.outward_crystal_cfg[key]
						if (cfg) {
							let max_time_list = local_JSON.parse(cfg.max_times)
							for (let j = 0; j < max_time_list.length; j++) {
								if (role_mgr.mainRoleInfo.level >= local_Number(max_time_list[j][0])
									&& role_mgr.mainRoleInfo.level <= local_Number(max_time_list[j][1])
									&& times < max_time_list[j][2]) {
									return true
								}
							}
						}
					}
				}
			}
		}

		this.ShowIlluRed = (type_id?) => {
			if ((!this.outward_data_list[type_id] && type_id != local_enum_OutWardType.Pet) || type_id == local_enum_OutWardType.Pet && !common_mgr.CheckFuncOpenState("PetIllusionView", true)) {
				return false
			}

			let illu_red = false
			let illu_list = this.GetIllusionList(type_id)
			if (Object.keys(illu_list).length > 0) {
				let key;
				for (key in illu_list) {
					if (this.GetReddotState(type_id, illu_list[key].id)) {
						illu_red = true
						break
					} else {
						RedDotController.ins.add(OutWarIlluTypeRedKeyMap[type_id] + illu_list[key].id, OutWarIlluTypeRedKeyMap[type_id])
						RedDotController.ins.up(OutWarIlluTypeRedKeyMap[type_id] + illu_list[key].id, 0)
					}
				}

				RedDotController.ins.add(OutWarIlluTypeRedKeyMap[type_id] + illu_list[key].id, OutWarIlluTypeRedKeyMap[type_id])
				RedDotController.ins.up(OutWarIlluTypeRedKeyMap[type_id] + illu_list[key].id, illu_red ? 1 : 0)
			}
			if (type_id == local_enum_OutWardType.Pet) {
				illu_red = red_dot_mgr.CheckRedStatus(local_ModuleType.PET_ILLU_STAR) || illu_red
			}
			if (type_id == local_enum_OutWardType.Horse) {
				illu_red = red_dot_mgr.CheckRedStatus(local_ModuleType.HOR_ILLU_STAR) || illu_red
			}
			if (type_id == local_enum_OutWardType.Partner) {
				illu_red = red_dot_mgr.CheckRedStatus(local_ModuleType.PAR_ILLU_STAR) || illu_red
			}
			return illu_red
		}

		this.ShowPetResolveRed = () => {
			if (!common_mgr.CheckFuncOpenState("PetIllusionView", true)) {
				return false
			}
			let red = false
			for (let vo of pet_reolve_material_list_) {
				let goods_num = goods_model.GetTypeGoodsNum(vo)
				if (goods_num > 0) {
					red = true
					break
				}
			}
			this.Fire(local_OutWardBaseModel.UPDATE_PET_RESLOVE_RED, red)
			return red
		}

		this.ShowHoresIconRed = () => {
			let red = false
			if (common_mgr.CheckFuncOpenState("HorseComponentView", true)) {
				red = this.ShowCultureRed(local_enum_OutWardType.Horse) 
				|| this.ShowIlluRed(local_enum_OutWardType.Horse)
				|| local_FairyModel.ShowFairyRed(local_enum_OutWardType.Horse)
				if (!red) {
					red = this.ShowIlluRed(local_enum_OutWardType.Pet)
				}
			}
			if (!red && common_mgr.CheckFuncOpenState("PartnerComponentView", true)) {
				red = this.ShowCultureRed(local_enum_OutWardType.Partner)
				 || this.ShowIlluRed(local_enum_OutWardType.Partner)
				 ||local_FairyModel.ShowFairyRed(local_enum_OutWardType.Partner)
			}

			return red
		}

		this.ShowOutWardIconRed = () => {
			let red = false
			if (common_mgr.CheckFuncOpenState("OutWardView", true)) {
				red = this.ShowCultureRed(local_enum_OutWardType.Wings)
				 || this.ShowIlluRed(local_enum_OutWardType.Wings) 
				 || local_FairyModel.ShowFairyRed(local_enum_OutWardType.Wings)
				if (!red) {
					red = this.ShowCultureRed(local_enum_OutWardType.Artifact) 
					|| this.ShowIlluRed(local_enum_OutWardType.Artifact)
					||local_FairyModel.ShowFairyRed(local_enum_OutWardType.Artifact)
				}
				if (!red) {
					red = this.ShowCultureRed(local_enum_OutWardType.HolyDevice) 
					|| this.ShowIlluRed(local_enum_OutWardType.HolyDevice)
					||local_FairyModel.ShowFairyRed(local_enum_OutWardType.HolyDevice)
				}
				if (!red) {
					red = this.ShowCultureRed(local_enum_OutWardType.BackOrnament) 
					|| this.ShowIlluRed(local_enum_OutWardType.BackOrnament)
				}
				// if (!red) {
				// 	red = this.ShowCultureRed(local_enum_OutWardType.MagicArr) || this.ShowIlluRed(local_enum_OutWardType.MagicArr)
				// }
			}
			return red
		}

		this.SetTrainSkill = (type_id?) => {
			if (!this.outward_skill_cfg) {
				return
			}
			if (this.outward_data_list[type_id]) {
				let data = this.outward_data_list[type_id]
				if (data.figure_stage) {
					for (let key in this.outward_skill_cfg) {
						if (this.outward_skill_cfg[key].type == 3
							&& this.outward_skill_cfg[key].type_id == data.type_id
							&& this.outward_skill_cfg[key].stage == data.figure_stage) {
							use_skill_id_list_[data.type_id] = this.outward_skill_cfg[key].skill_id
							break
						}
					}
				}
			}
		}

		this.SetIllusionSkill = (type_id?) => {
			if (!this.outward_skill_cfg) {
				return
			}
			if (this.outward_data_list[type_id] && this.outward_data_list[type_id].figure_stage == 0) {
				let data = this.outward_illu_data_list[type_id]
				if (data.illusion_id != 0) {
					for (let key in this.outward_skill_cfg) {
						if (this.outward_skill_cfg[key].type == 3
							&& this.outward_skill_cfg[key].type_id == data.type_id
							&& this.outward_skill_cfg[key].ownership_id == data.illusion_id) {
							use_skill_id_list_[data.type_id] = this.outward_skill_cfg[key].skill_id
							break
						}
					}
				}
			}
		}

		this.GetSkillId = (type_id?) => {
			return use_skill_id_list_[type_id]
		}

		this.GetIllusionCfgByKey = (type_id?, id?, career?) => {
			return this.outward_illusion_cfg[type_id + "@" + id + "@" + career]
		}

		this.GetIllusionSatgeCfgByKey = (type_id?, id?, stage?) => {
			return this.outward_figure_stage_cfg[type_id + "@" + id + "@" + stage]
		}

		this.GetOutWardSmeltData = (type_id?) => {
			let goods_list = []
			let illu_active_data = this.active_illu_list[type_id]
			if (illu_active_data) {
				let key = ``
				for (let index in illu_active_data) {
					key = `${type_id}@${illu_active_data[index].id}@${role_mgr.GetMainRoleVo().sex}`
					let active_cfg = this.outward_illusion_cfg[key]
					if (active_cfg) {
						let goodsVo = goods_model.GetTypeGoods(active_cfg.goods_id)
						if (Util.TableSize(goodsVo) > 0) {
							for (let i in goodsVo) {
								goods_list.push(goodsVo[i])
							}
						}
					}
				}
			}
			if (goods_list.length < 8) {
				goods_list.length = 8
			}
			return goods_list
		}

		this.CheckTypeIconRed = (type_id?) => {
			if (type_id == local_enum_OutWardType.Artifact || type_id == local_enum_OutWardType.HolyDevice || type_id == local_enum_OutWardType.Wings || type_id == local_enum_OutWardType.MagicArr ||  type_id == local_enum_OutWardType.BackOrnament) {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
				this.Fire(local_OutWardBaseModel.UPDATE_OUTWARD_RED)
			} else {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
			}
		}

		this.CanLvUp = (type_id?) => {
			if (!this.outward_data_list[type_id]) {
				return false
			}
			let cur_data = this.outward_data_list[type_id]
			let max_star = this.GetMaxStar(type_id, cur_data.stage)
			if (max_star && !(cur_data.stage >= this.outward_max_stage[type_id] && cur_data.star >= max_star)) {
				let needExp
				if (!this.outward_star_cfg) {
					return false
				}
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_star.name, `${type_id}@${cur_data.stage}@${cur_data.star}`, false, this.outward_star_cfg)
				if (cfg) {
					needExp = cfg.max_blessing - cur_data.blessing
					for (let key in outward_goods_cfg_) {
						if (outward_goods_cfg_[key].type_id == type_id && outward_goods_cfg_[key].type == 1) {
							let goodsNum = goods_model.GetTypeGoodsNum(outward_goods_cfg_[key].goods_id)
							needExp = needExp - goodsNum * outward_goods_cfg_[key].exp
							if (needExp <= 0) {
								return true
							}
						}
					}
				}
			}
		}

		this.CanIllusionUP = (type_id?, FuncId?) => {
			if (type_id && FuncId) {
				if (FuncId[1] == local_enum_OutWardType.Horse || FuncId[1] == local_enum_OutWardType.Partner || FuncId[1] == local_enum_OutWardType.Pet) {
					let red1 = red_dot_mgr.CheckRedStatus(this.GetRedType(FuncId[1]), FuncId[2])
					if (!red1) {
						if (this.active_illu_list[FuncId[1]] && !this.active_illu_list[FuncId[1]][FuncId[2]]) {
							red1 = this.GetReddotState(FuncId[1], FuncId[2])
						}
					}
					return red1
				} else {
					return this.GetReddotState(FuncId[1], FuncId[2])
				}
			}
		}

		this.SelectSmeltGoods = (goods_id?, goods_num?, type_id?, status?) => {
			if (smeltExpCfg_) {
				let expCfg = smeltExpCfg_[type_id]
				if (expCfg) {
					if (status) {
						this.selectSmelt[goods_id] = goods_num
						smeltExp_ = smeltExp_ + expCfg.add_exp * goods_num
						local_OutWardBaseModel.GetInstance().Fire(local_OutWardBaseModel.SELECT_SMELT, goods_id, true)
					} else {
						let goodsNum = this.selectSmelt[goods_id]
						delete this.selectSmelt[goods_id]
						smeltExp_ = smeltExp_ - expCfg.add_exp * goodsNum
						local_OutWardBaseModel.GetInstance().Fire(local_OutWardBaseModel.SELECT_SMELT, goods_id, false)
					}
				}
			}
		}

		this.CheckSmeltRed = (typeId?) => {
			if (typeId == local_enum_OutWardType.Horse) {
				//this:ChangeVar("horseSmeltRed", this.CheckResolveRed(typeId))
			} else if (typeId == local_enum_OutWardType.Partner) {
				//this:ChangeVar("partnerSmeltRed", this.CheckResolveRed(typeId))
			}
		}

		this.CheckResolveRed = (type_id?) => {

		}

		this.CheckIlluStarRed = (type_id?) => {
			if (type_id != local_enum_OutWardType.Horse && type_id != local_enum_OutWardType.Partner) { return }
			let illu_active_data = this.outward_illu_data_list[type_id]
			if (illu_active_data && illu_active_data["figure_list"] && this.upStarCfg) {
				let key = ``
				let sex = role_mgr.GetMainRoleVo().sex
				for (let vo of illu_active_data["figure_list"]) {
					key = `${type_id}@${vo.id}@${vo.star}`
					let starCfg = this.upStarCfg[key]
					if (starCfg) {
						let cost = local_JSON.parse(starCfg.cost)
						if (cost.length > 0) {
							let goodsNum = goods_model.GetTypeGoodsNum(cost[0][1])
							red_dot_mgr.SetRedStatus(this.GetRedType(type_id), vo.id, goodsNum >= Number(cost[0][2]))
						} else {
							red_dot_mgr.SetRedStatus(this.GetRedType(type_id), vo.id, false)
						}
					}
				}
			}
		}

		this.GetRedType = (type?) => {
			if (type == 1) {
				return local_ModuleType.HOR_ILLU_STAR
			} else if (type == 2) {
				return local_ModuleType.PAR_ILLU_STAR
			} else if (type == 7) {
				return local_ModuleType.PET_ILLU_STAR
			}
		}

		this.HasActiveIllu = (type_id?, id?) => {
			if (this.outward_figure_list[type_id] && this.outward_figure_list[type_id][id]) {
				return true
			} else if (this.outward_illu_data_list[type_id]) {
				let activeList = this.outward_illu_data_list[type_id].figure_list
				for (let vo of activeList) {
					if (vo.id == id) {
						return true
					}
				}
				return false
			}
		}

		this.SetLvSystemInfo = (scmd?) => {
			if (!outward_lv_info_list[scmd.type_id]) {
				outward_lv_info_list[scmd.type_id] = scmd
			} else {
				this.UpdaLvSysteInfo(scmd)
				// outward_lv_info_list[scmd.type_id] = scmd
			}

		}

		this.GetLvSystemInfo = (type_id?) => {
			if (type_id && outward_lv_info_list && outward_lv_info_list[type_id]) {
				return outward_lv_info_list[type_id]
			} else {
				return false
			}
		}

		this.UpdaLvSysteInfo = (scmd?) => {
			outward_lv_info_list[scmd.type_id].level = scmd.level
			outward_lv_info_list[scmd.type_id].cur_exp = scmd.cur_exp
			outward_lv_info_list[scmd.type_id].combat = scmd.combat
			outward_lv_info_list[scmd.type_id].skill_list = scmd.skill_list
			outward_lv_info_list[scmd.type_id].add_exp = scmd.add_exp
		}

		this.LvsystemCanLvUp = (type_id?, ignore_lv_red_open?) => {
			if (!outward_lv_info_list[type_id]) {
				return false
			}
			if(!this.GetLvSystemOpenState(type_id)){
				return false
			}

			if(this.lv_red_open_state_dic == null){
				let state = CookieWrapper.GetInstance().GetCookie(CookieWrapper.OUTWARD_LV_RED_OPEN_STATE)
				let state_dic
				if(!state){
					state_dic = {}
				}
				else{
					state_dic = JSON.parse(state)
				}
				this.lv_red_open_state_dic = state_dic
			}

			if(this.lv_red_open_state_dic[type_id] == false && !ignore_lv_red_open){
				return false
			}

			let cur_data = outward_lv_info_list[type_id]
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_level
			let lv_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name,type_id + "@" + cur_data.level, false, cfg)// ResManager.GetInstance().GetGameConfigFromCache(this, "config_mount_level", false)[type_id + "@" + cur_data.level ]
			let next_lv_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_level.name,type_id + "@" + (cur_data.level + 1), false, cfg)
			if (next_lv_info && lv_info) {
				let needExp = lv_info.need_exp - cur_data.cur_exp
				for (let key in outward_goods_cfg_) {
					if (outward_goods_cfg_[key].type_id == type_id && outward_goods_cfg_[key].type == 4) {
						let goodsNum = goods_model.GetTypeGoodsNum(outward_goods_cfg_[key].goods_id)
						needExp = needExp - goodsNum * outward_goods_cfg_[key].exp
						if (needExp <= 0) {
							return true
						}
					}
				}
			}
			return false
		}

		this.GetLvSystemGoods = (type_id?, type?) => {
			if (!outwrard_lvsystem_goods[type_id]) {
				for (let index in outward_goods_cfg_) {
					if (!outwrard_lvsystem_goods[outward_goods_cfg_[index].type_id]) {
						outwrard_lvsystem_goods[outward_goods_cfg_[index].type_id] = {}
					}
					outwrard_lvsystem_goods[outward_goods_cfg_[index].type_id][index] = outward_goods_cfg_[index]
				}
			}
			if (type) {
				let list = {}
				for (let k in outwrard_lvsystem_goods[type_id]) {
					let v = outwrard_lvsystem_goods[type_id][k]
					if (v.type == type) {
						list[k] = v
					}
				}
				return list
			}
			return outwrard_lvsystem_goods[type_id]
		}

		this.LvsystemSkillCanLvUp = (type_id?) => {
			if (!outward_lv_info_list[type_id]) {
				return false
			}
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_skill_lv_data", false)
			let cur_data =  outward_lv_info_list[type_id].skill_list
			let conditions
			let is_can_lv_up = false
			for (let key in cur_data) {
				let next_skill_vo = Config.GetConfigVo (Config.ConfigHasDefaultValue.config_skill_lv_data.name,cur_data[key].skill_id + "@" +(cur_data[key].skill_level+1),false,cfg)// cfg[cur_data[key].skill_id + "@" + (cur_data[key].skill_level + 1)]
				if (next_skill_vo) {
					conditions = ErlangParser.GetInstance().Parse(next_skill_vo.condition)
					for (let key in conditions) {
						if (conditions[key][0] == "mount_upgrade_lv") {
							is_can_lv_up = conditions[key][1] <= outward_lv_info_list[type_id].level ? true : false
							if(is_can_lv_up){
								return is_can_lv_up
							}
							// return is_can_lv_up
						}
					}
				}
			}
			return is_can_lv_up
		}

		this.GetLvSystemOpenState = (type :enum_OutWardType) =>{
			if(type == enum_OutWardType.Horse){
				return CommonManager.GetInstance().CheckFuncOpenState("HorseLvSystem", true)
			}else if(type == enum_OutWardType.Partner){
				return CommonManager.GetInstance().CheckFuncOpenState("PartnerLvSystem", true)
			}else if (type == enum_OutWardType.HolyDevice) {
				return CommonManager.GetInstance().CheckFuncOpenState("HolyDeviceLvSystem", true)
			}else if (type == enum_OutWardType.Wings) {
				return CommonManager.GetInstance().CheckFuncOpenState("WingsLvSystem", true)
			}else if (type == enum_OutWardType.Artifact) {
				return CommonManager.GetInstance().CheckFuncOpenState("ArtifactLvSystem", true)
			}else if (type == enum_OutWardType.BackOrnament) {
				return CommonManager.GetInstance().CheckFuncOpenState("BackOrnamentLvSystem", true)
			}
			return true
		}

		this.ChangeLvRedOpenState = (type_id, bool) =>{
			if(!type_id) return
			if(this.lv_red_open_state_dic == null){
				let state = CookieWrapper.GetInstance().GetCookie(CookieWrapper.OUTWARD_LV_RED_OPEN_STATE)
				let state_dic
				if(!state){
					state_dic = {}
				}
				else{
					state_dic = JSON.parse(state)
				}
				this.lv_red_open_state_dic = state_dic
			}
			if(this.lv_red_open_state_dic[type_id] == bool){
				return
			}
			this.lv_red_open_state_dic[type_id] = bool
			this.Fire(local_OutWardBaseModel.UPDATE_LV_RED_OPEN_STATE, type_id)
			this.CheckTypeIconRed(type_id)
			this.UpdateOutWardStrongerRed(type_id)
			this.SaveLvRedOpenStateCookies()
		}

		this.SaveLvRedOpenStateCookies = () =>{
			if(this.lv_red_open_state_dic == null){
				return
			}
			CookieWrapper.GetInstance().SaveCookie(CookieWrapper.OUTWARD_LV_RED_OPEN_STATE, JSON.stringify(this.lv_red_open_state_dic))
		}

		this.GetLvCfg()
		this.GetConfig()
	}

	public static GetInstance() {
		if (!OutWardBaseModel.Instance) {
			OutWardBaseModel.Instance = new OutWardBaseModel()
		}
		return OutWardBaseModel.Instance
	}

	public static TypeToWord(type) {
		return OutWardBaseModel.TypeToWord[type]
	}

}
window["OutWardBaseModel"] = OutWardBaseModel