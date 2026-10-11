import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Trim, Util } from "../util/Util"
import { CustomActivityModel } from "./CustomActivityModel"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { MysteryShopType, ShopModel } from "./ShopModel"

export enum SecretTreasureMainViewIndex {
	Rune = 0,
	MonBook = 1,
	//Soul=2,
	//Lung=3,
	//GodBeast=4,
	//GodCourt=5,
	//Secret=6

	Lung = 2,
	GodBeast = 3,
	//Secret=5,
	Unreal = 4
}
window["SecretTreasureMainViewIndex"] = SecretTreasureMainViewIndex
export enum InsertState {
	Insert = 1,
	HaveSame = 2,
	NotKind = 3
}
window["InsertState"] = InsertState
export enum LungDotSubType {
	StoneExchenge = 1,
	Insert = 2,
	StoveFirstOpen = 3,
	Upgrade = 4,
	StoveFreeTimes = 5,
	StoveReward = 6,
	Shop = 7,
	StoveGoods = 8
}
window["LungDotSubType"] = LungDotSubType
export const LungEvent = {
	LUNG_REQUEST_PROTO: "LUNG_REQUEST_PROTO",
	LUNG_REQUEST_OTHER_PROTO: "LUNG_REQUEST_OTHER_PROTO",
	LUNG_OPEN_VIEW: "LUNG_OPEN_VIEW",
	LUNG_CLOSE_VIEW: "LUNG_CLOSE_VIEW",
	LUNG_CLICK_GRID_ITEM: "LUNG_CLICK_GRID_ITEM",
	CLICK_LUNG_RESOLVE_ITEM: "CLICK_LUNG_RESOLVE_ITEM",
	LUNG_STOVE_SUCCESS: "LUNG_STOVE_SUCCESS",
	LUNG_WEAR_OFF_SUCCESS: "LUNG_WEAR_OFF_SUCCESS",
	LUNG_UPGRADE_SUCCESS: "LUNG_UPGRADE_SUCCESS",
	LUNG_SHOW_STOVE_ICON: "LUNG_SHOW_STOVE_ICON",
	LUNG_SELECT_BAG: "LUNG_SELECT_BAG"
}

window["SecretTreasureMainViewIndex"] = SecretTreasureMainViewIndex
window["InsertState"] = InsertState
window["LungDotSubType"] = LungDotSubType
window["LungEvent"] = LungEvent
export class LungModel extends EventDispatcher {
	CanInsertDot
	CanInsertInEmptyGrid
	CanInsertInThisGrid
	CancelFreeTimer
	ChipCanComposeDot
	ExchangeSuccess
	GetAllGridList
	GetAllSkillDesc
	GetBasePro
	GetDecomposeCfg
	GetExchangeGoodsData
	GetInstertState
	GetLunStarCfg
	GetLunStarCfgByStar
	GetLungBagListByIndex
	GetLungLvCfg
	GetLungLvToStarLvCfg
	GetLungPower
	GetLungRealLvAndStar
	GetLungSkill
	GetLungSkillDesc
	GetLungStar
	GetLungStyleSource
	GetLungTotalLv
	GetMaxPro
	GetPosCfg
	GetPosCfgByPos
	GetDragonStarUpCfg
	GetDragonLvUpCfg
	GetPraticeCost
	GetProList
	GetResolveReward
	GetSeriesDesc
	GetSkillList
	GetSkillStr
	GetStarBgSource
	GetStoveCfg
	GetStoveStageState
	HasWearTheSameKind
	HasWearTheSameTypeAndColorDown
	HasWearTheSameTypeAndColorUp
	HideShopTabDot
	InitConfig
	IsBetterThanWear
	IsNeedUpStar
	IsSameKind
	LungCanUpgrade
	LungIsTopLevel
	LungMaxLevel
	LungRedDot
	OnFreeTime
	ResolveSuccess
	RestoreShopTabDot
	SetLungData
	SetLungTotalLevel
	SetStoveData
	ShopDot
	ShowGoodsFly
	StartFreeTimer
	StoveFirstRedDot
	StoveFreeRedDot
	StoveOpenState
	StoveStageRewardCanGet
	ThisGridPosIsOpen
	GetPosNextPower
	is_first_show_stove_dot
	lung_daimond_cost_alert
	setStoveDot
	setStoveIcon
	GetMyWearLung
	getMaxLv

	stove_data
	lung_data
	stove_open_state

	getCanComposeId
	isHigherQuality
	getCanInsertByTypeId
	isWearByPos

	public static LungGoodsType = 63;
	public static LungExchangeType = 6;
	public static LungMaterialGoodsType = 64;	//神纹碎片材料
	public static LungStone1 = 36255025;
	public static LungStone2 = 36255026;
	public static LungStone3 = 36255027;
	public static Goods = 38040030;
	public static Goods1 = 36255028;
	public static LUNG_TOP_ICON = "181";
	public static stoveDot = 0;
	public static callNum = 0;
	public static is_open_stove_Icon = false;
	public static lung_msg_hide = false
	static Instance: any
	public constructor() {
		super()

		this.is_first_show_stove_dot = true;
		this.lung_daimond_cost_alert = true;

		let role_mgr = RoleManager.GetInstance()
		let local_LungModel = LungModel
		let server_time_model = ServerTimeModel.GetInstance()
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()
		let local_Number = Number
		let local_InsertState = InsertState
		let red_dot_mgr = RedDotManager.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let refresh_function_icon_red_event = EventName.REFRESH_FUNCTION_ICON_RED_DOT
		let refresh_activity_icon_red_event = EventName.REFRESH_ACTIVITY_ICON_RED_DOT
		let local_MainFunc = MainFunc
		let local_ModuleType_Lung = ModuleType.LUNG_DOT
		let local_LungDotSubType = LungDotSubType
		let local_TimeUtil = TimeUtil
		let local_Message = Message
		let local_WordManager = WordManager
		let stone_exchange_lung_rule_list_ = null
		let config_dragon_lv_ = null
		let config_dragon_lv_up_ = null
		let config_dragon_star_lv_ = null
		let config_goods_decompose_ = null
		let config_dragon_star_up_ = null
		let config_goods_exchange_rule_ = null
		// let config_dragon_pos_
		let all_grid_list_ = null
		let lung_total_level_ = 0
		let count_free_time_id_ = null
		let has_show_shop_tab_dot_ = false
		this.InitConfig = () => {
			config_goods_decompose_ = Config.PRELOAD_SERVER_CONFIG.config_goods_decompose
			config_goods_exchange_rule_ = Config.PRELOAD_SERVER_CONFIG.config_goods_exchange_rule
			config_dragon_star_up_ = Config.PRELOAD_SERVER_CONFIG.config_dragon_star_up
			config_dragon_star_lv_ = Config.PRELOAD_SERVER_CONFIG.config_dragon_star_lv
			config_dragon_lv_up_ = Config.PRELOAD_SERVER_CONFIG.config_dragon_lv_up

			// await res_mgr.LoadGameConfig(this, "config_dragon_pos", false, undefined, (obj)=>{
			// 	config_dragon_pos_ = obj
			// 	res_mgr.DestoryGameConfig(this, "config_dragon_pos", false)
			// })
		}

		// this.GetPosCfg = () => {
		// 	return config_dragon_pos_
		// }

		this.GetPosCfgByPos = (config_dragon_pos?, pos?) => {
			return config_dragon_pos && config_dragon_pos[pos]
		}

		this.GetDragonStarUpCfg = () => {
			return config_dragon_star_up_
		}

		this.GetDragonLvUpCfg = () => {
			return config_dragon_lv_up_
		}

		this.GetLungLvCfg = (type_id?, lv?) => {
			let cfg = null
			let tmp = null
			let [level, star] = this.GetLungRealLvAndStar(lv)
			if (type_id && level != null) {
				let key = type_id + "@" + level + "@" + level
				cfg = Config.GetConfigVo("config_dragon_lv_up", key, false, config_dragon_lv_up_)
			}
			return cfg
		}

		this.GetLungLvToStarLvCfg = (type_id?, level?) => {
			let key = type_id + "@" + level + "@" + level
			let cfg = Config.GetConfigVo("config_dragon_lv_up", key, false, config_dragon_lv_up_)
			return cfg
		}

		this.getMaxLv = (type_id?:number) =>{
			let lv: number = 0;
			if(type_id){	
				let cfg = this.GetDragonLvUpCfg();
				for (const key in cfg) {
					let temp = cfg[key];
					if(temp.gtype_id == type_id && temp.lv_max > lv){
						lv = temp.lv_max
					}
				}
			}
			return lv
		}

		this.LungIsTopLevel = (type_id?, level?) => {
			let [lv, star] = this.GetLungRealLvAndStar(level)
			let next_cfg = this.GetLungLvToStarLvCfg(type_id, lv + 1)
			if (next_cfg) {
				return false
			} else {
				return true
			}
		}
		this.LungMaxLevel = (type_id?) => {
			let cfg = config_dragon_star_up_
			let max_lv = 0
			let i = 0
			while ((cfg[type_id + "@" + i])) {
				max_lv = cfg[type_id + ("@" + i)].lv_limit + i
				i = i + 1
			}
			return max_lv
		}

		this.GetLunStarCfg = (type_id?, lv?) => {
			let cfg = null
			let tmp = null
			let [level, star] = this.GetLungRealLvAndStar(lv)
			if (type_id && star != null) {
				for (let key in config_dragon_star_up_) {
					tmp = config_dragon_star_up_[key]
					if (tmp.gtype_id == type_id && tmp.star == star) {
						cfg = tmp
						break
					}
				}
			}
			return cfg
		}

		this.GetLunStarCfgByStar = (type_id?, star?) => {
			let cfg = null
			let tmp = null
			if (type_id && star != null && config_dragon_star_up_ && Util.TableSize(config_dragon_star_up_) > 0) {
				for (let key in config_dragon_star_up_) {
					tmp = config_dragon_star_up_[key]
					if (tmp.gtype_id == type_id && tmp.star == star) {
						cfg = tmp
						break
					}
				}
			}
			return cfg
		}

		this.GetDecomposeCfg = (type_id?) => {
			let cfg = Config.GetConfigVo("config_goodsdecompose", type_id, false, config_goods_decompose_)
			return cfg
		}

		this.GetStoveCfg = (stove_id?, dragon_crucible_cfg?) => {
			return dragon_crucible_cfg && dragon_crucible_cfg[stove_id + "@" + role_mgr.mainRoleInfo.career]
		}

		this.SetLungData = (scmd?) => {
			this.ChangeVar("lung_data", scmd)
			this.LungRedDot()
		}

		this.SetStoveData = (scmd?) => {
			this.ChangeVar("stove_data", scmd)
			this.StartFreeTimer()
			this.LungRedDot()
			this.setStoveIcon()
		}

		this.setStoveIcon = () => {
			let cfg = CommonManager.GetInstance().GetFunctionIconCfg(local_LungModel.LUNG_TOP_ICON);
			if (((this.StoveOpenState(true) == true && local_LungModel.is_open_stove_Icon == false) && server_time_model.GetOpenServerDay() >= cfg.open_day) && role_mgr.GetMainRoleVo().level >= cfg.open_lv) {
				local_LungModel.is_open_stove_Icon = true
				let time = this.stove_data.end_time
				activity_icon_mgr.addIcon(local_LungModel.LUNG_TOP_ICON, time)
			} else if (this.StoveOpenState(true) == false && local_LungModel.is_open_stove_Icon == true) {
				local_LungModel.is_open_stove_Icon = false
				activity_icon_mgr.deleteIcon(local_LungModel.LUNG_TOP_ICON)
			}
		}

		this.GetAllGridList = (dragon_pos_cfg?) => {
			if (!all_grid_list_ || all_grid_list_.length <= 0) {
				all_grid_list_ = []
				if (dragon_pos_cfg) {
					let cfg_list = []
					for (let key in dragon_pos_cfg) {
						let cfg = dragon_pos_cfg[key]
						if (!cfg_list[cfg.subtype]) {
							cfg_list[cfg.subtype] = []
						}
						cfg_list[cfg.subtype].push(cfg)
					}
					let sort_fun = (a?, b?) => {
						return a.pos - b.pos
					}
					for (let key in cfg_list) {
						let cfg = cfg_list[key]
						cfg.sort(sort_fun)
						let obj_list = null
						obj_list = []
						obj_list.style = key
						obj_list.grid_list = cfg
						all_grid_list_.push(obj_list)
					}
					let sort_fun2 = (a?, b?) => {
						return a.style - b.style
					}

					all_grid_list_.sort(sort_fun2)
				}
			}
			return all_grid_list_
		}

		this.ThisGridPosIsOpen = (pos?) => {
			let is_open = false
			if (this.lung_data) {
				for (let _tmpi in this.lung_data.pos_list) {
					var vo = this.lung_data.pos_list[_tmpi]
					if (vo.pos == pos) {
						is_open = true
						break
					}
				}
			}
			return is_open
		}

		this.GetPosNextPower = (pos?) => {
			let power = 0;
			if (pos && this.lung_data) {
				for (let k in this.lung_data.pos_list) {
					var vo = this.lung_data.pos_list[k];
					if (vo.pos == pos) {
						power = vo.next_power;
						break;
					}
				}
			}

			return power;
		}

		this.GetSkillList = () => {
			let key = null
			let cfg = null
			let list = null
			let skill_list = []
			let tmp_list = []
			let goods_vo = null
			let tmp = null
			for (let key in goods_model.wear_lung_dic) {
				goods_vo = goods_model.wear_lung_dic[key]
				cfg = this.GetLunStarCfg(goods_vo.type_id, goods_vo.level)
				if (cfg) {
					list = JSON.parse(cfg.skill)
					for (let _tmpi in list) {
						tmp = list[_tmpi]
						if (local_Number(tmp[0]) == role_mgr.mainRoleInfo.career) {
							tmp_list = tmp[1]
							if (tmp_list) {
								for (let _tmpi in tmp_list) {
									var vo = tmp_list[_tmpi]
									let data = null
									data = []
									data.skill_id = local_Number(vo[0])
									data.lv = local_Number(vo[1])
									let desc_key = role_mgr.mainRoleInfo.career > 1? "desc_" + role_mgr.mainRoleInfo.career: "desc" 
									let _skill_desc:string = cfg[desc_key] || "";
									_skill_desc = _skill_desc.replace("%%", "%%%%")
									_skill_desc = _skill_desc.replace("{1}", Trim(cfg.value))
									data.skill_desc = _skill_desc
									skill_list.push(data)
								}
							}
						}
					}
				}
			}
			return skill_list
		}

		this.GetAllSkillDesc = () => {
			let key = null
			let cfg = null
			let list = null
			let skill_desc = ""
			let goods_vo = null
			let count = 0
			let param = ""
			let tmp_str = ""
			let career = role_mgr.mainRoleInfo.career
			for (let key in goods_model.wear_lung_dic) {
				goods_vo = goods_model.wear_lung_dic[key]
				cfg = this.GetLunStarCfg(goods_vo.type_id, goods_vo.level)
				if (cfg) {
					if (career == 1) {
						tmp_str = cfg.desc
					} else if (career == 2) {
						tmp_str = cfg.desc_2
					} else if (career == 3) {
						tmp_str = cfg.desc_3
					} else {
						tmp_str = cfg.desc_4
					}
					param = cfg.value
					tmp_str = tmp_str.replace("{1}", param)
					if (tmp_str != "") {
						count = count + 1
						if (count == 1) {
							skill_desc = tmp_str
						} else {
							skill_desc = Trim(skill_desc) + "<br/>" + Trim(tmp_str)
						}
					}
				}
			}
			return skill_desc
		}

		this.SetLungTotalLevel = () => {
			let lv = 0
			let config = null
			let goods_vo = null
			let real_lv = 0
			let real_star = 0
			let list = goods_model.wear_lung_dic
			for (let key in list) {

				// [ts2lua]list下标访问可能不正确
				goods_vo = list[key];
				[real_lv, real_star] = this.GetLungRealLvAndStar(goods_vo.level)
				if (real_lv) {
					lv = lv + real_lv
				}
			}
			lung_total_level_ = lv
		}

		this.GetLungTotalLv = () => {
			return lung_total_level_
		}

		this.GetLungStyleSource = (style?) => {
			let sour = "uilwmb_003c"
			if (style == 2) {
				sour = "uilwmb_003b"
			} else if (style == 3) {
				sour = "uilwmb_003a"
			}
			return sour
		}

		this.GetStarBgSource = (color?) => {
			let source = null
			if (color == 1) {
				source = "uilwmb_006a_06"
			} else if (color == 2) {
				source = "uilwmb_006a_08"
			} else if (color == 3) {
				source = "uilwmb_006a_10"
			} else if (color == 4) {
				source = "uilwmb_006a_03"
			} else if (color == 5) {
				source = "uilwmb_006a_12"
			} else if (color == 6) {
				source = "uilwmb_006a_14"
			}
			return source
		}

		this.CanInsertInThisGrid = (pos?, sub_type?, dragon_pos_cfg?) => {
			let is_fit = false
			let cfg = dragon_pos_cfg[pos]
			if (cfg) {
				let include_list = JSON.parse(cfg.permiss_list)
				if (include_list) {
					if (this.ThisGridPosIsOpen(pos)) {
						for (let _tmpi in include_list) {
							var vo = include_list[_tmpi]
							if (sub_type == local_Number(vo)) {
								is_fit = true
								break
							}
						}
					}
				}
			}
			return is_fit
		}

		this.IsSameKind = (type_id?, type_id2?) => {
			let is_same = false
			let cfg = this.GetLungLvCfg(type_id, 1)
			let cfg2 = this.GetLungLvCfg(type_id2, 1)
			if (cfg && cfg2) {
				if (cfg.kind == cfg2.kind) {
					is_same = true
				}
			}
			return is_same
		}

		this.HasWearTheSameKind = (type_id?) => {
			let equip_list = goods_model.wear_lung_dic
			let have_same = false
			let equip_vo = null
			if (equip_list) {
				let vo = null
				let cfg = this.GetLungLvCfg(type_id, 1)
				if (cfg) {
					let tmp = null
					for (let key in equip_list) {
						vo = equip_list[key]
						tmp = vo && this.GetLungLvCfg(vo.type_id, 1)
						if (tmp) {
							if (tmp.kind == cfg.kind) {
								equip_vo = equip_list[key]
								have_same = true
								break
							}
						}
					}
				}
			}
			return [have_same, equip_vo]
		}

		this.HasWearTheSameTypeAndColorDown = (type_id?) => {
			let equip_list = goods_model.wear_lung_dic
			let have_wear = false
			let equip_vo = null
			if (equip_list) {
				let vo = null
				let cfg = this.GetLungLvCfg(type_id, 1)
				if (cfg) {
					let tmp = null
					for (let key in equip_list) {

						// [ts2lua]equip_list下标访问可能不正确
						vo = equip_list[key]
						tmp = this.GetLungLvCfg(vo.type_id, 1)
						if (tmp) {
							if (tmp.kind == cfg.kind) {
								// [ts2lua]equip_list下标访问可能不正确
								equip_vo = equip_list[key]
								let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
								if (equip_vo.color <= goods_vo.color) {
									have_wear = true
								}
								break
							}
						}
					}
				}
			}
			return have_wear
		}
		this.HasWearTheSameTypeAndColorUp = (type_id?) => {
			let equip_list = goods_model.wear_lung_dic
			let have_wear = false
			let equip_vo = null
			if (equip_list) {
				let vo = null
				let cfg = this.GetLungLvCfg(type_id, 1)
				if (cfg) {
					let tmp = null
					for (let key in equip_list) {

						// [ts2lua]equip_list下标访问可能不正确
						vo = equip_list[key]
						tmp = this.GetLungLvCfg(vo.type_id, 1)
						if (tmp) {
							if (tmp.kind == cfg.kind) {
								// [ts2lua]equip_list下标访问可能不正确
								equip_vo = equip_list[key]
								let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
								if (equip_vo.color > goods_vo.color) {
									have_wear = true
								}
								break
							}
						}
					}
				}
			}
			return have_wear
		}

		this.GetInstertState = (pos?, sub_type?, type_id?, _type?, dragon_pos_cfg?) => {
			let state = local_InsertState.Insert
			let is_fit = this.CanInsertInThisGrid(pos, sub_type, dragon_pos_cfg)
			if (is_fit) {
				let is_same = false
				if (_type == 2) {
					let equip_list = goods_model.wear_lung_list
					if (equip_list && equip_list[pos - 1]) {
						let vo = equip_list[pos - 1]
						if (vo) {
							is_same = this.IsSameKind(type_id, vo.type_id)
						}
					}
				}
				let [wear_same, equip_vo] = this.HasWearTheSameKind(type_id)
				if (wear_same && !is_same) {
					state = local_InsertState.HaveSame
				}
			} else {
				state = local_InsertState.NotKind
			}
			return state
		}

		this.GetLungBagListByIndex = (index?) => {
			let bag_list = goods_model.lungbag_goods_list
			let list = []
			let lung_type_list = {}
			let is_recommend_compose = false
			let can_compose = null
			let cost_num = null
			let id = null
			let recommed_list = []
			if (index == 0) {
				lung_type_list = { "63": true, "64": true }
			} else if (index == 1) {
				lung_type_list = { "63": true }
			} else if (index == 2) {
				lung_type_list = { "64": true }
			}
			for (let key in bag_list) {
				let goods = bag_list[key]
				is_recommend_compose = false
				if (goods.type == local_LungModel.LungMaterialGoodsType && (index == 1 || index == 3)) {
					[can_compose, cost_num, id, is_recommend_compose] = this.ChipCanComposeDot(goods.type_id)
				}
				if (is_recommend_compose) {
					recommed_list.push(goods)
				} else {
					if (lung_type_list[goods.type]) {
						list.push(goods)
					}
				}
			}
			let sort_fun = (a?, b?) => {
				if (a.type == b.type) {
					if (a.color == b.color) {
						if (a.type_id == b.type_id) {
							return b.level - a.level
						} else {
							return a.type_id - b.type_id
						}
					} else {
						return b.color - a.color
					}
				} else {
					return a.type - b.type
				}
			}

			list.sort(sort_fun)
			recommed_list.sort(sort_fun)
			recommed_list = recommed_list.concat(list)
			return recommed_list
		}

		this.GetLungStar = (goods_id?) => {
			let level = 1
			let star = 0
			if (goods_id) {
				let vo = goods_model.GetGoodsVoByGoodsId(goods_id)
				if (vo) {
					[level, star] = this.GetLungRealLvAndStar(vo.level)
				}
			}
			return star
		}

		this.GetLungRealLvAndStar = (goods_lv?) => {
			let cfg = config_dragon_star_lv_ && config_dragon_star_lv_[goods_lv]
			if (cfg) {
				return [cfg.lv, cfg.star]
			}
			return [0, 0]
		}

		this.GetResolveReward = (goods_list?) => {
			let tmp = []
			if (goods_list) {
				let list = null
				let cfg = null
				// let real_lv
				// let star
				let lv_gap = 0
				for (let _tmpi in goods_list) {
					var vo = goods_list[_tmpi]
					cfg = this.GetLungLvCfg(vo.type_id, vo.level)
					if (cfg) {
						let base = JSON.parse(cfg.base_decompose)
						let add = JSON.parse(cfg.add_decompose)
						let [real_lv, star] = this.GetLungRealLvAndStar(vo.level)
						lv_gap = real_lv - cfg.lv_min
						if (base) {
							for (let _tmpi in base) {
								var a = base[_tmpi]
								let obj = Util.DeepCopy(a)
								obj[2] = local_Number(obj[2]) * vo.goods_num
								tmp.push(obj)
							}
						}
						if (add) {
							for (let _tmpi in add) {
								var a = add[_tmpi]
								let obj = Util.DeepCopy(a)
								obj[2] = local_Number(obj[2]) * lv_gap * vo.goods_num
								tmp.push(obj)
							}
						}
					}
					cfg = this.GetLunStarCfg(vo.type_id, vo.level)
					if (cfg) {
						let star_base = JSON.parse(cfg.decompose)
						if (star_base) {
							if (star_base) {
								for (let _tmpi in star_base) {
									var a = star_base[_tmpi]
									let obj = Util.DeepCopy(a)
									obj[2] = local_Number(obj[2]) * vo.goods_num
									tmp.push(obj)
								}
							}
						}
					}
				}
			}
			let find = false
			let result = []
			for (let _tmpi in tmp) {
				var vo = tmp[_tmpi]
				find = false
				for (let _tmpi in result) {
					var h = result[_tmpi]
					if (local_Number(vo[1]) == local_Number(h[1])) {
						find = true
						h[2] = local_Number(h[2]) + local_Number(vo[2])
					}
				}
				if (!find) {
					let obj = Util.DeepCopy(vo)
					if (local_Number(obj[2]) > 0) {
						result.push(obj)
					}
				}
			}
			return result
		}

		this.GetStoveStageState = (count?) => {
			let state = 0
			if (this.stove_data && count) {
				for (let _tmpi in this.stove_data.status_list) {
					var vo = this.stove_data.status_list[_tmpi]
					if (vo.count == count) {
						state = vo.status
						break
					}
				}
			}
			return state
		}

		this.IsNeedUpStar = (now_lv?, next_lv?) => {
			let need_up_star = false
			let [n_lv, n_star] = this.GetLungRealLvAndStar(now_lv)
			let [ne_lv, ne_star] = this.GetLungRealLvAndStar(next_lv)
			if (n_lv == ne_lv) {
				need_up_star = true
			}
			return need_up_star
		}

		this.GetProList = (type_id?, lv?) => {
			let [real_lv, real_star] = this.GetLungRealLvAndStar(lv)
			let tmp = []
			if (real_lv) {
				let lv_cfg = this.GetLungLvCfg(type_id, lv)
				let star_cfg = this.GetLunStarCfg(type_id, lv)
				let base_list = null
				let add_list = null
				let lv_gap = null
				if (lv_cfg) {
					lv_gap = real_lv - local_Number(lv_cfg.lv_min)
					base_list = JSON.parse(lv_cfg.base_attr)
					add_list = JSON.parse(lv_cfg.add_attr)
					if (base_list) {
						for (let _tmpi in base_list) {
							var a = base_list[_tmpi]
							let obj = Util.DeepCopy(a)
							tmp.push(obj)
						}
					}
					if (add_list) {
						for (let _tmpi in add_list) {
							var a = add_list[_tmpi]
							let obj = Util.DeepCopy(a)
							obj[1] = local_Number(obj[1]) * lv_gap
							tmp.push(obj)
						}
					}
				}
				if (star_cfg) {
					base_list = JSON.parse(star_cfg.attr)
					for (let _tmpi in base_list) {
						var a = base_list[_tmpi]
						let obj = Util.DeepCopy(a)
						tmp.push(obj)
					}
				}
			}
			let find = false
			let result = []
			for (let _tmpi in tmp) {
				var vo = tmp[_tmpi]
				find = false
				for (let _tmpi in result) {
					var h = result[_tmpi]
					if (local_Number(vo[0]) == local_Number(h[0])) {
						find = true
						h[1] = local_Number(h[1]) + local_Number(vo[1])
					}
				}
				if (!find) {
					let obj = Util.DeepCopy(vo)
					result.push(obj)
				}
			}
			let sort_fun = (a?, b?) => {
				return local_Number(a[0]) - local_Number(b[0])
			}

			result.sort(sort_fun)
			return result
		}

		this.GetLungSkill = (type_id?, level?, show_up_star_style?) => {
			let skill_list = []
			let tmp_list = []
			let cfg = this.GetLunStarCfg(type_id, level)
			if (cfg) {
				let list = JSON.parse(cfg.skill)
				if (list) {
					for (let _tmpi in list) {
						var tmp = list[_tmpi]
						if (local_Number(tmp[0]) == role_mgr.mainRoleInfo.career) {
							tmp_list = tmp[1]
							if (tmp_list) {
								for (let _tmpi in tmp_list) {
									var vo = tmp_list[_tmpi]
									let data = null
									data = []
									data.skill_id = local_Number(vo[0])
									data.lv = local_Number(vo[1])
									skill_list.push(data)
								}
							}
						}
					}
				}
			}
			return skill_list
		}

		this.GetLungSkillDesc = (type_id?, level?, show_up_star_style?) => {
			let skill_desc = ""
			let max_cfg = this.GetLunStarCfg(type_id, 55)
			let cfg = this.GetLunStarCfg(type_id, level)
			let career = role_mgr.mainRoleInfo.career
			if (cfg && max_cfg) {
				if (career == 1) {
					skill_desc = cfg.desc
				} else if (career == 2) {
					skill_desc = cfg.desc_2
				} else if (career == 3) {
					skill_desc = cfg.desc_3
				} else {
					skill_desc = cfg.desc_4
				}
				let param = Trim(cfg.value) + "</font><font color='#ff9015'>(满级：</font><font color='#639c12'>" + Trim(max_cfg.value) + "</font><font color='#ff9015'>)"
				if (show_up_star_style) {
					param = `${cfg.value} -> ${cfg.prevalue}</font><font color='#ff9015'>(满级：</font><font color='#639c12'>${max_cfg.value}</font><font color='#ff9015'>)</font>`
				}
				param = param.replace("%%", "%%%%")
				if (!skill_desc) {
					skill_desc = ""
				}
				skill_desc = skill_desc.replace("{1}", param)
			}
			return skill_desc
		}

		this.GetPraticeCost = (is_up_star?, type_id?, lv?) => {
			let cost = null
			if (type_id && lv) {
				let [real_lv, real_star] = this.GetLungRealLvAndStar(lv)
				if (is_up_star) {
					let star_cfg = this.GetLunStarCfgByStar(type_id, real_star)
					if (star_cfg) {
						let tmp = JSON.parse(star_cfg.cost)
						if (tmp && tmp[0]) {
							cost = tmp[0]
						}
					}
				} else {
					let cfg = this.GetLungLvCfg(type_id, lv)
					if (cfg) {
						let base_cost = JSON.parse(cfg.base_cost)
						let add_cost = JSON.parse(cfg.add_cost)
						if (base_cost && base_cost[0]) {
							cost = base_cost[0]
						}
						let lv_gap = real_lv + 1 - cfg.lv_min
						if ((add_cost && add_cost[0]) && cost) {
							cost[2] = cost[2] + local_Number(add_cost[0][2]) * lv_gap
						}
					}
				}
			}
			return cost
		}

		this.GetExchangeGoodsData = () => {
			if (!stone_exchange_lung_rule_list_) {
				let data = goods_model.GetGoodsExchangeData(local_LungModel.LungExchangeType)
				if (data && config_goods_exchange_rule_) {
					let goods = null
					let tmp = null
					for (let _tmpi in data) {
						var vo = data[_tmpi]
						vo.cfg = config_goods_exchange_rule_[vo.id]
						if (vo.cfg) {
							tmp = JSON.parse(vo.cfg.obtain_list)
							if (tmp && tmp[0]) {
								vo.obtain_type_id = local_Number(tmp[0][1])
								vo.obtain_num = local_Number(tmp[0][2])
							}
							tmp = JSON.parse(vo.cfg.cost_list)
							if (tmp && tmp[0]) {
								vo.cost_type_id = local_Number(tmp[0][1])
								vo.cost_num = local_Number(tmp[0][2])
							}
						}
					}
					stone_exchange_lung_rule_list_ = data
				}
			}
			return stone_exchange_lung_rule_list_
		}

		this.ChipCanComposeDot = (type_id?, visual_num_from_exchange?) => {
			let can_compose = null
			let cost_num = 0
			let id = 0
			let list = this.GetExchangeGoodsData()
			let show_red_dot = false
			can_compose = false
			let is_recommend = false
			let target_type_id = 0
			visual_num_from_exchange = visual_num_from_exchange || 0
			let use_exchange_num = false
			if (list) {
				if (type_id) {
					let my_have = goods_model.GetTypeGoodsNum(type_id)
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						if (vo.cost_type_id == type_id) {
							target_type_id = vo.obtain_type_id
							cost_num = vo.cost_num
							id = vo.id
							if (vo.cost_num <= my_have) {
								can_compose = true
							} else {
								if (vo.cost_num <= (my_have + visual_num_from_exchange)) {
									can_compose = true
									use_exchange_num = true
								}
							}
							break
						}
					}
					if (can_compose && target_type_id) {
						let target_basic = goods_model.GetGoodsBasicByTypeId(target_type_id)
						if (target_basic) {
							let [wear_same, equip_vo] = this.HasWearTheSameKind(target_type_id)
							if (wear_same) {
								if (equip_vo.color < target_basic.color) {
									is_recommend = true
								}
							}
							if (goods_model.lungbag_goods_list) {
								let high_color = false
								for (let _ in goods_model.lungbag_goods_list) {
									var v = goods_model.lungbag_goods_list[_]
									if (v.type == local_LungModel.LungGoodsType) {
										if (this.IsSameKind(v.type_id, target_type_id)) {
											if (v.color >= target_basic.color) {
												high_color = true
												is_recommend = false
												break
											}
										}
									}
								}
								if (!high_color && !wear_same) {
									is_recommend = true
								}
							}
						}
					}
				} else {
					if (goods_model.lungbag_goods_list) {
						for (let _t in goods_model.lungbag_goods_list) {
							var vo1 = goods_model.lungbag_goods_list[_t]
							if (vo1.type == local_LungModel.LungMaterialGoodsType) {
								[can_compose, cost_num, id, is_recommend, target_type_id, use_exchange_num] = this.ChipCanComposeDot(vo1.type_id)
								if (is_recommend) {
									break
								}
							}
						}
					}
					red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoneExchenge, is_recommend)
					RedDotController.ins.up(RedKey.LUNG_EXCHANGE, is_recommend ? 1 : 0)
				}
			}
			return [can_compose, cost_num, id, is_recommend, target_type_id, use_exchange_num]
		}

		this.GetLungPower = (type_id?, lv?) => {
			let prolist = this.GetProList(type_id, lv)
			let skill_list = this.GetLungSkill(type_id, lv)
			let power = 0
			let skill_mgr = SkillManager.GetInstance()
			if (prolist) {
				power = Util.CalAttrPower(prolist, false)
			}
			if (skill_list) {
				for (let _tmpi in skill_list) {
					var vo = skill_list[_tmpi]
					let desc, name, fight = skill_mgr.GetSkillFromConfigByIdAndLevelAndPower(vo.skill_id, vo.lv)
					power = power + local_Number(fight)
				}
			}
			return power
		}

		this.IsBetterThanWear = (vo?, pos?) => {
			let wear_power = 0
			let target_power = 0
			let is_same = false
			let high_color = false
			let same_kind = null
			let same_color = false
			if (vo && pos) {
				let equip_list = goods_model.wear_lung_list
				if (equip_list) {
					let data = equip_list[pos - 1]
					if (data) {
						wear_power = data.combat_power
						same_kind = this.IsSameKind(data.type_id, vo.type_id)
						let basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
						if (same_kind && basic) {
							if (basic.color > data.color) {
								high_color = true
							} else if (basic.color == data.color) {
								same_color = true
							}
						}
					}
				}
				target_power = vo.combat_power
			}
			if (target_power == wear_power) {
				is_same = true
			}
			return [target_power > wear_power, is_same, high_color, same_kind, same_color]
		}

		this.LungRedDot = () => {
			let open = common_mgr.CheckFuncOpenState("LungMainView", true)
			if (open) {
				res_mgr.LoadGameConfig(this, "config_dragon_pos", false, undefined, (obj) => {
					let dragon_pos_cfg = obj
					// let cfgs = config_dragon_pos_
					// dragon_pos_cfg = cfgs
					if (dragon_pos_cfg) {
						this.ChipCanComposeDot()
						this.CanInsertDot(dragon_pos_cfg)
						this.LungCanUpgrade()
						this.StoveFreeRedDot()
						this.StoveStageRewardCanGet()
						this.ShopDot()
						this.GetStoveGoodsRed();
						local_GlobalEventSystem.Fire(refresh_function_icon_red_event, local_MainFunc.Treasure)
					}
					res_mgr.DestoryGameConfig(this, "config_dragon_pos")
				})
			}
		}

		this.CanInsertDot = (dragon_pos_cfg?, pos_id?, get_replace?) => {
			let can_insert = false
			if (pos_id) {
				let equip_list = goods_model.wear_lung_list
				let state = local_InsertState.Insert
				if (equip_list) {
					if (!equip_list[pos_id - 1] && !get_replace) {
						for (let _tmpi in goods_model.lungbag_goods_list) {
							var vo = goods_model.lungbag_goods_list[_tmpi]
							if (vo.type == local_LungModel.LungGoodsType) {
								state = this.GetInstertState(pos_id, vo.subtype, vo.type_id, 1, dragon_pos_cfg)
								if (state == local_InsertState.Insert) {
									can_insert = true
									break
								}
							}
						}
					} else {
						let is_better = null
						let same = null
						let wear = null
						let high_color = false
						let same_kind = null
						let same_color = null
						for (let _tmpi in goods_model.lungbag_goods_list) {
							var vo = goods_model.lungbag_goods_list[_tmpi]
							if (vo.type == local_LungModel.LungGoodsType) {
								state = this.GetInstertState(pos_id, vo.subtype, vo.type_id, 2, dragon_pos_cfg)
								if (state == local_InsertState.Insert) {
									[is_better, same, high_color, same_kind, same_color] = this.IsBetterThanWear(vo, pos_id)
									if ((is_better && !same) && (!same_kind || same_color) || high_color) {
										can_insert = !this.CanInsertInEmptyGrid(pos_id, vo.subtype, vo.type_id, dragon_pos_cfg)
										if (can_insert) {
											break
										}
									}
								}
							}
						}
					}
				}
			} else {
				let i = 1
				do {
					can_insert = this.CanInsertDot(dragon_pos_cfg, i)
					if (can_insert) {
						break
					}
					i = i + 1
				} while ((i < 13))
				red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.Insert, can_insert)
				RedDotController.ins.up(RedKey.LUNG_INSERT, can_insert ? 1 : 0)
			}
			return can_insert
		}

		this.CanInsertInEmptyGrid = (pos_id?, subtype?, type_id?, dragon_pos_cfg?) => {
			let can = false
			let wear = null
			let equip_list = goods_model.wear_lung_list
			let state = null
			let i = 1
			do {
				if (i != pos_id) {
					wear = equip_list[i - 1]
					if (!wear) {
						state = this.GetInstertState(i, subtype, type_id, 1, dragon_pos_cfg)
						if (state == local_InsertState.Insert) {
							can = true
							break
						}
					}
				}
				i = i + 1
			} while ((i < 13))
			return can
		}

		this.StoveFirstRedDot = () => {
			if (this.StoveOpenState(true)) {
				if (CustomActivityModel.GetInstance().GetDayFirstLoginStatus()) {
					if (this.is_first_show_stove_dot) {
						red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoveFirstOpen, true)
						RedDotController.ins.up(RedKey.LUNG_STOVE_FIRST_OPEN, 1)
					} else {
						red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoveFirstOpen, false)
						RedDotController.ins.up(RedKey.LUNG_STOVE_FIRST_OPEN, 0)
					}
				} else {
					red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoveFirstOpen, false)
					RedDotController.ins.up(RedKey.LUNG_STOVE_FIRST_OPEN, 0)
				}
			}
		}

		this.LungCanUpgrade = (pos_id?) => {
			let can_upgrade = false
			let vo = null
			if (pos_id) {
				vo = goods_model.wear_lung_list[pos_id - 1]
				if (vo) {
					let max_lv = this.LungIsTopLevel(vo.type_id, vo.level)
					if (!max_lv) {
						let cost_list = this.GetPraticeCost(this.IsNeedUpStar(vo.level, vo.level + 1), vo.type_id, vo.level)
						if (cost_list) {
							let my_have = goods_model.GetTypeGoodsNum(local_Number(cost_list[1])) || 0
							if (my_have >= local_Number(cost_list[2])) {
								can_upgrade = true
								for (let _tmpi in goods_model.lungbag_goods_list) {
									var goods = goods_model.lungbag_goods_list[_tmpi]
									if (goods.type == local_LungModel.LungGoodsType && this.IsSameKind(vo.type_id, goods.type_id)) {
										if (goods.color > vo.color) {
											can_upgrade = false
											break
										}
									}
								}
							}
						}
					}
				}
			} else {
				for (let goods_id in goods_model.wear_lung_dic) {
					vo = goods_model.wear_lung_dic[goods_id]
					can_upgrade = this.LungCanUpgrade(vo.cell)
					if (can_upgrade) {
						break
					}
				}
				red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.Upgrade, can_upgrade)
				RedDotController.ins.up(RedKey.LUNG_UPGRADE, can_upgrade ? 1 : 0)
			}
			return can_upgrade
		}

		//神纹熔炉红点
		this.StoveFreeRedDot = () => {
			let is_free = this.stove_data && this.stove_data.free_times > 0
			red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoveFreeTimes, is_free)
			this.setStoveDot(is_free)
			return false
		}

		this.StoveStageRewardCanGet = () => {
			let can_get = false
			if (this.stove_data && this.stove_data.status_list) {
				for (let _tmpi in this.stove_data.status_list) {
					var vo = this.stove_data.status_list[_tmpi]
					if (vo.status == 1) {
						can_get = true
						break
					}
				}
			}
			red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.StoveReward, can_get)
			RedDotController.ins.up(RedKey.LUNG_STOVE_REWARD, can_get ? 1 : 0)
			this.setStoveDot(can_get)
			return can_get
		}

		this.setStoveDot = (dot?) => {
			if (dot) {
				local_GlobalEventSystem.Fire(refresh_activity_icon_red_event, 181, true)
			} else {
				local_LungModel.stoveDot = local_LungModel.stoveDot + 1
				if (local_LungModel.stoveDot == 2) {
					local_GlobalEventSystem.Fire(refresh_activity_icon_red_event, 181, false)
				}
			}
			local_LungModel.callNum = local_LungModel.callNum + 1
			if (local_LungModel.callNum == 2) {
				local_LungModel.stoveDot = 0
				local_LungModel.callNum = 0
			}
		}

		this.ShopDot = (shop_vo?) => {
			if (!common_mgr.CheckFuncOpenState("LungMainView", true)) {
				return
			}
			let can_exchange = false
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods
			if (shop_vo) {
				if (shop_vo.mystery_shop_good) {
					let goods = JSON.parse(shop_vo.mystery_shop_good.goods)
					if (goods && goods[0]) {
						let cost_type_id = (cfg[shop_vo.mystery_shop_good.price_type] && (cfg[shop_vo.mystery_shop_good.price_type].goods_id) || (0))
						let my_have = 0
						if (cost_type_id == local_LungModel.LungStone1) {
							my_have = goods_model.GetSpecialScore(local_LungModel.LungStone1)
						} else if (cost_type_id == local_LungModel.LungStone2) {
							my_have = goods_model.GetSpecialScore(local_LungModel.LungStone2)
						} else if (cost_type_id == local_LungModel.LungStone3) {
							my_have = goods_model.GetSpecialScore(local_LungModel.LungStone3)
						}
						let can_buy_num = 0
						if (shop_vo.mystery_shop_good.limit > 0) {
							let left_num = shop_vo.mystery_shop_good.limit - shop_vo.buy_num
							if (left_num > 0 && my_have >= shop_vo.price) {
								can_buy_num = Math.min(left_num, Math.floor(my_have / shop_vo.price))
							}
						}
						// if (my_have >= shop_vo.price) {
						// 	can_exchange = true
						// }
						// if (can_exchange && shop_vo.mystery_shop_good.limit > 0) {
						// 	can_exchange = shop_vo.mystery_shop_good.limit - shop_vo.buy_num > 0 && true || false
						// }
						if (can_buy_num > 0) {
							let type_id = Number(goods[0][1])
							if (type_id == LungModel.Goods) {	//神纹精粹
								can_exchange = true
							} else {
								//如玩家从未拥有某一个神纹，且背包当前碎片数量无法合成一个完整的神纹，加上可购买的限购数量即可合成，则红点提示
								// let [can_compose, cost_num, id, is_recommend, target_type_id, use_exchange_num] = this.ChipCanComposeDot(type_id, can_buy_num)
								// if (is_recommend == true && use_exchange_num == true) {
								// 	can_exchange = true
								// }
								// if (can_exchange == false && target_type_id) {	//进阶的过程中，可兑换数量 + 已拥有数量 > 进阶消耗
								// 	let wear_vo = this.GetMyWearLung(target_type_id)
								// 	if (wear_vo) {
								// 		if (this.IsNeedUpStar(wear_vo.level, wear_vo.level + 1)) {
								// 			let cost_list = this.GetPraticeCost(true, wear_vo.type_id, wear_vo.level)
								// 			if (cost_list) {
								// 				let my_have = goods_model.GetTypeGoodsNum(local_Number(cost_list[1])) || 0
								// 				let need = local_Number(cost_list[2])
								// 				if (my_have < need && (my_have + can_buy_num) >= need) {
								// 					can_exchange = true
								// 				}
								// 			}
								// 		}
								// 	}
								// }
								if(this.isHigherQuality(type_id) || this.getCanInsertByTypeId(type_id)){
									can_exchange = true
								}
							}
						}
					}
				}
			} else {
				let shop_data = ShopModel.GetInstance().GetMysteryDataByType(MysteryShopType.LungShopType)
				if (shop_data && shop_data.good_list && shop_data.good_list.length > 0) {
					for (let _tmpi in shop_data.good_list) {
						var vo = shop_data.good_list[_tmpi]
						can_exchange = this.ShopDot(vo)
						if (can_exchange) {
							break
						}
					}
				}
				if (can_exchange) {
					if (has_show_shop_tab_dot_) {
						can_exchange = false
					}
				}
				red_dot_mgr.SetRedStatus(local_ModuleType_Lung, local_LungDotSubType.Shop, can_exchange)
				RedDotController.ins.up(RedKey.LUNG_SHOP, can_exchange ? 1 : 0)
				local_GlobalEventSystem.Fire(refresh_function_icon_red_event, local_MainFunc.Treasure)
			}
			return can_exchange
		}

		this.getCanComposeId =(typeId : number) => {
			let _datas = LungModel.GetInstance().GetExchangeGoodsData()
			if(_datas){
				for (let i = 0, len = _datas.length; i < len; i++) {
					if(_datas[i].cost_type_id == typeId){
						return _datas[i].obtain_type_id
					}
				}
			}
			return null
		}

		this.isHigherQuality = (typeId : number) => {
			let composeId: number = this.getCanComposeId(typeId);
			for (let i = 0; i < 12; i++) {
				let wear = GoodsModel.GetInstance().wear_lung_list[i];
				if(wear && wear.type_id){
					if(Math.floor(composeId/10) == Math.floor(wear.type_id/10)){
						if(composeId > wear.type_id){
							return true
						}else if(composeId == wear.type_id){
							let maxLv = this.LungIsTopLevel(wear.type_id, wear.level)
							return !maxLv
						}
					}
				}
			}
			return false
		}

		this.getCanInsertByTypeId = (typeId: number) => {
			let isBuy: boolean = false;
			let isCanWear: boolean = false
			let composeId: number = this.getCanComposeId(typeId);
			res_mgr.LoadGameConfig(this, "config_dragon_pos", false, undefined, (obj) => {
				let dragon_pos_cfg = obj
				if (dragon_pos_cfg) {
					for (const key in dragon_pos_cfg) {
						let pos = dragon_pos_cfg[key].pos;
						let subtype = dragon_pos_cfg[key].subtype;
						if(this.ThisGridPosIsOpen(pos) && !this.isWearByPos(pos)){
							let state = this.GetInstertState(pos, subtype, composeId, 2, dragon_pos_cfg)
							if(state == 1){
								isCanWear = true
							}
						}
					}
				}
				res_mgr.DestoryGameConfig(this, "config_dragon_pos")
			})
			let haveNum = GoodsModel.GetInstance().GetTypeGoodsNum(typeId);
			if(isCanWear && haveNum > 0){
				isBuy = true
			}
			return isBuy
		}

		//当前部位是否穿戴
		this.isWearByPos = (pos: number) =>{
			let equip_list = goods_model.wear_lung_list
			if(equip_list[pos - 1]){
				return true
			}
			return false
		}

		this.HideShopTabDot = () => {
			let show = red_dot_mgr.CheckRedStatus(local_ModuleType_Lung, local_LungDotSubType.Shop)
			if (show && !has_show_shop_tab_dot_) {
				has_show_shop_tab_dot_ = true
				this.ShopDot()
			}
		}

		this.RestoreShopTabDot = () => {
			has_show_shop_tab_dot_ = false
			this.ShopDot()
		}

		this.GetSeriesDesc = (subtype?) => {
			let desc = ""
			if (subtype == 1) {
				desc = "基础"
			} else if (subtype == 2) {
				desc = "启迪"
			} else if (subtype == 3) {
				desc = "超然"
			}
			return desc
		}

		this.StoveOpenState = (not_alert?) => {
			let open = true
			if ((!this.stove_data || this.stove_data.crucible_id == 0) || local_TimeUtil.getServerTime() - this.stove_data.end_time > 0) {
				open = false
				if ((!not_alert && this.stove_open_state) && this.stove_open_state.start_time > 0) {
					let time = this.stove_open_state.start_time - local_TimeUtil.getServerTime()
					if (time > 0 && server_time_model.GetOpenServerDay() >= 5) {
						let str = local_TimeUtil.convertTimeColor(time)
						local_Message.show(str + "后召唤开启")
					}
				}
			}
			return open
		}

		this.ExchangeSuccess = (id?) => {
			let list = this.GetExchangeGoodsData()
			if (list) {
				let goods_list = []
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (vo.id == id) {
						let obj = []
						obj[0] = 0
						obj[1] = vo.obtain_type_id
						obj[2] = vo.obtain_num
						goods_list.push(obj)
					}
				}
				if (goods_list.length > 0) {
					let view = new CongratulationObtainView(goods_list, 10)
					view.Open()
				}
			}
		}

		this.ResolveSuccess = (reward_list?) => {
			if (reward_list) {
				let list = []
				for (let _tmpi in reward_list) {
					var vo = reward_list[_tmpi]
					let obj = []
					obj[0] = 0
					obj[1] = vo.typeId
					obj[2] = vo.count
					list.push(obj)
				}
				this.ShowGoodsFly(list)
			}
		}

		this.ShowGoodsFly = (goods_list?) => {
			if (goods_list) {
				for (let _tmpi in goods_list) {
					var vo = goods_list[_tmpi]
					let goods_vo = goods_model.GetGoodsBasicByTypeId(local_Number(vo[1]))
					if (goods_vo) {
						goods_vo["drop_num"] = local_Number(vo[2])
						local_Message.showGoods(goods_vo)
					}
				}
			}
		}

		this.GetBasePro = (type_id?, lv?) => {
			let str = ""
			if (type_id && lv != null) {
				let pro_list = this.GetProList(type_id, lv)
				if (pro_list) {
					for (let k in pro_list) {
						var v = pro_list[k]
						if (k != pro_list.length) {
							str = str + local_WordManager.GetProperties(v[0]) + "：<font color='#d15e00'>" + local_WordManager.ConvertToPercentValue(v[0], v[1]) + "</font><br/>"
						} else {
							str = str + local_WordManager.GetProperties(v[0]) + "：<font color='#d15e00'>" + local_WordManager.ConvertToPercentValue(v[0], v[1]) + "</font>"
						}
					}
				}
			}
			return str
		}

		this.GetMaxPro = (type_id?, lv?) => {
			let str = ""
			if (type_id && lv != null) {
				let pro_list = this.GetProList(type_id, lv)
				if (pro_list) {
					for (let k in pro_list) {
						var v = pro_list[k]
						if (k + 1 != pro_list.length) {
							str = str + "<font color='#d15e00'>(满级：</font>" + "<font color='#0a953e'>" + local_WordManager.ConvertToPercentValue(v[0], v[1]) + "</font><font color='#ff9015'>)</font><br/>"
						} else {
							str = str + "<font color='#d15e00'>(满级：</font>" + "<font color='#0a953e'>" + local_WordManager.ConvertToPercentValue(v[0], v[1]) + "</font><font color='#ff9015'>)</font><br/>"
						}
					}
				}
			}
			return str
		}

		this.GetSkillStr = (type_id?, level?) => {
			let skill_desc = this.GetLungSkillDesc(type_id, level)
			// skill_desc = skill_desc.replace(/<color=#639c12>/g, "")
			// skill_desc = skill_desc.replace(/<\/color>/g, "")
			// skill_desc = skill_desc.replace(/</g, "")
			// skill_desc = skill_desc.replace(/>/g, "")
			if (Trim(skill_desc) == "") {
				skill_desc = "启迪系和超然系神纹可拥有特殊效果"
			}
			return skill_desc
		}

		this.StartFreeTimer = () => {
			this.CancelFreeTimer()
			count_free_time_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnFreeTime()
			}, 1.7)
			this.OnFreeTime()
		}

		this.OnFreeTime = () => {
			if (this.stove_data && this.stove_data.next_free_time && this.stove_data.next_free_time != 0) {
				let left_time = this.stove_data.next_free_time - local_TimeUtil.getServerTime()
				if (left_time < -2) {
					this.CancelFreeTimer()
					this.Fire(LungEvent.LUNG_REQUEST_PROTO, 18105)
					return
				}
			} else {
				this.CancelFreeTimer()
			}
		}

		this.CancelFreeTimer = () => {
			if (count_free_time_id_) {
				GlobalTimerQuest.CancelQuest(count_free_time_id_)
			}
		}
		//获取身上装备的神纹
		this.GetMyWearLung = (type_id) => {
			let goods_vo
			if (type_id && goods_model.wear_lung_dic) {
				let vo
				for (let key in goods_model.wear_lung_dic) {
					vo = goods_model.wear_lung_dic[key]
					if (vo && vo.type_id == type_id) {
						goods_vo = vo
						break
					}
				}
			}
			return goods_vo
		}
	}

	public GetStoveGoodsRed() {
		let isOpen: boolean = this.StoveOpenState(true)
		let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(36255028) || 0;
		let red: boolean = isOpen && my_have > 0;
		RedDotManager.GetInstance().SetRedStatus(ModuleType.LUNG_DOT, LungDotSubType.StoveGoods, red)
		this.setStoveDot(red)
	}



	public static GetInstance() {
		if (!LungModel.Instance) {
			LungModel.Instance = new LungModel()
		}
		return LungModel.Instance
	}

}


window["LungModel"] = LungModel