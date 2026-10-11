import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { ColorType, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { CompositeEvent, CompositeModel } from "./CompositeModel"

export const RuneEvent = {
	RUNE_REQUEST_PROTO: "RUNE_REQUEST_PROTO",
	OPEN_VIEW: "OPEN_VIEW",
	UPDATE_RUNE_DATA: "UPDATE_RUNE_DATA",
	CLICK_RUNE_ICON: "CLICK_RUNE_ICON",
	CLOSE_BAG_VIEW: "CLOSE_BAG_VIEW",
	UPDATE_ONE_RUNE_DATA: "UPDATE_ONE_RUNE_DATA",
	UPDTE_RUNE_CONVERT_VIEW: "UPDTE_RUNE_CONVERT_VIEW",
	CLICK_RUNE_RESOLVE_ITEM: "CLICK_RUNE_RESOLVE_ITEM",
	RESOLVE_PREVIEW: "RESOLVE_PREVIEW",
	REQUEST_RESOLVE_PREVIEW: "REQUEST_RESOLVE_PREVIEW",
	GET_COMPOSE_PREVIEW: "GET_COMPOSE_PREVIEW",
	COMPOSE_PREVIEW_RETURN: "COMPOSE_PREVIEW_RETURN",
	UPGRADE_SUCCESS: "UPGRADE_SUCCESS",
	UPDATE_RUNE_RED_DOT: "UPDATE_RUNE_RED_DOT",
	RUNE_SELECT_DECOMPOSE_ITEM: "RUNE_SELECT_DECOMPOSE_ITEM",
	RUNE_AWAKEN: "RE1",
	RUNE_AWAKEN_RETURN: "RE2",
	DEC_MAIN_VIEW_RED: "RE3",
	RUNE_RESOLUTION: "RE4",
	RUNE_RESOLUTION_SELECT: "RE5",
	RUNE_RESOLUTION_RETURN: "RE6",
	RESOLUTION_RETURN_VIEW: "RE7",
	SELECT_SKILL: "RE8",
	UPDATE_RUNE_SKILL: "RE9",
	SELECT_AWAKE_MAT: "RE10",
	RESOLUTION_PREVIEW: "RE11",
	SKILL_LV_UP: "RE12",
	RESOLUTION_PREVIEW_RETURN: "RE13",
	INSERT_SUCCESS: "RE14",
	CHANGE_RUNE_TAB: "CHANGE_RUNE_TAB" // 用于控制御魂分解和拆解页签
}
window["RuneEvent"] = RuneEvent

export class RuneModel extends EventDispatcher {
	CanActiveSkill
	CanAwake
	CanExchange
	CanInsert
	CanResolve
	CanSkillUp
	CanUpgrade
	ChangeRuneData
	CheckRedStatus
	DECOMPOSE
	FindIsWearTheSame
	GetAllProShow
	GetCanReturnExAfterDecompose
	GetFightAndProList
	GetJingHuaExpDesc
	GetMtrlIntro
	GetOpenCondition
	GetOpenConditionNum
	GetProBySubtype
	GetProStr
	GetRunDataByGoodsId
	GetRuneAttr
	GetRuneAwakeSkillcfg
	GetRuneDataByPosId
	GetRuneExp
	GetRuneProList
	GetRuneResolutionMat
	GetRunesAwakenInBag
	GetRunesInBag
	GetRunesResolutionInBag
	GetSubRuneEquipDic
	GetTipShowProBySubtype
	GetTipsAwakeStr
	GetUnLockStr
	GetUpgradeCostNum
	InitConfig
	InitInsertSubTypeList
	IsExcludeSubtypeByPosId
	IsIncludeSubtypeByPosId
	RESOLUTION
	RuneAttrCanAwake
	RuneAwakeBagList
	RuneAwakeTabIndex
	RuneCanAwake
	RuneDecSelectTab
	RuneTypeGoodsList
	RuneTypeGoodsNum
	SetRuneInfo
	ShowRuneRedDot
	UpdateRed
	UpdateRuneDataLvByGoodsId
	_resolutionDic
	_resolve_red
	addResolutionDic
	awakeSelect
	decSelectNum
	decompose_not_alert
	delResolutionDic
	disSelectNum
	max_bag_goods_num
	reSetResolutionDic
	rune_info
	rune_tower_floor
	saveSoulComposeAwake
	showReward
	skillRed
	souldAwakeAttrIndex
	GetWakeUpCfg
	GetCoefficientCfg
	GetRuneAttrNumCfg
	GetGoodsDecomposeCfg
	GetRunePosCfg
	GetGoodsSubtypeCfg
	GetRuneAllShowCfg
	GetRunewakeuplvCfg
	GetRunewakeupexpCfg
	GetRunewakeskillCfg
	GetAwakenLvByVo

	guide_goods_id
	attr_select_index
	awake_select_goods_id
	static RuneDecomposeGoods = {
		"36100001": { "id": 1, "type_id": 36100001, "desc": "经验" },
		"36100002": { "id": 2, "type_id": 36100002, "desc": "物品1" },
		"36100003": { "id": 3, "type_id": 36100003, "desc": "物品2" }
	}
	static RuneAttrToSubType = {
		"202": 1,
		"1": 2,
		"2": 3,
		"3": 4,
		"4": 5,
		"5": 6,
		"6": 7,
		"7": 8,
		"8": 9,
		"222": 10,
		"223": 11,
		"224": 12,
		"221": 13,
		"70": 14,
		"69": 15,
		"226": 16,
		"225": 17,
		"46": 26,
		"47": 27
	}

	static RuneCheckColor = [
		{ id: 2, name: "蓝色以下", key: "blue" },
		{ id: 3, name: "紫色", key: "purple" },
		{ id: 4, name: "橙色", key: "orange" },
		{ id: 5, name: "红色", key: "red" }
	]



	public static RuneStone = 36100002;
	public static RuneCrystal = 38040012;
	public static ComposeBtnShowLv = 160;
	public static MaxLv = 200;
	public static IgnoreAttackSubType = 22;
	public static IgnoreDefendSubType = 23;
	public static ExpRuneSubType = 1;
	public static RuneExp = 36100001;
	public static SkillId = 7000001;
	public static MaxDecNum = 50;
	static Instance: RuneModel
	public constructor() {
		super()

		if (RuneModel.Instance) {
			return
		}
		RuneModel.Instance = this
		this.rune_tower_floor = 0;
		this.decompose_not_alert = false;
		this.max_bag_goods_num = 800;
		this._resolutionDic = [];
		this.awakeSelect = [];
		this.decSelectNum = 0;
		this.disSelectNum = 0;
		this._resolve_red = false;
		this.RuneDecSelectTab = 0;
		this.DECOMPOSE = 0;
		this.RESOLUTION = 1;
		this.saveSoulComposeAwake = [];
		this.guide_goods_id = 0
		this.attr_select_index = 0
		this.awake_select_goods_id = 0

		let local_RuneEvent = RuneEvent
		let local_Erlang = ErlangParser.GetInstance()
		let local_Config = Config
		let local_Math = Math
		let local_WordManager = WordManager
		let goods_model = GoodsModel.GetInstance()
		let local_RuneModel = RuneModel
		let common_mgr = CommonManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let local_Util = Util
		// let composite_model = CompositeModel.GetInstance()
		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
		let local_ColorType = ColorType
		let all_pro_style_ = null
		let exclude_subtype_list_ = []
		let include_subtype_list_ = []
		let _insert_red_ = false
		let _upgrade_red_ = false
		let _show_red_ = false
		let awakeRed_ = false
		let rune_attr_num_cfg
		let config_goods_decompose = null
		let coefficient_cfg
		// let rune_pos_cfg
		let goods_sub_type_cfg
		// let config_rune_all_show
		let config_rune_wake_up
		// let config_rune_wake_up_lv
		// let config_rune_wake_up_exp
		// let config_rune_awake_skill
		this.InitConfig = () => {
			goods_sub_type_cfg = Config.PRELOAD_SERVER_CONFIG.GoodsSubtype
			config_goods_decompose = Config.PRELOAD_SERVER_CONFIG.config_goods_decompose
			//常用的几个配置
			rune_attr_num_cfg = Config.PRELOAD_SERVER_CONFIG.config_rune_attr_num
			coefficient_cfg = Config.PRELOAD_SERVER_CONFIG.config_rune_attr_coefficient
			config_rune_wake_up = Config.PRELOAD_SERVER_CONFIG.config_rune_wake_up

			// await res_mgr.LoadGameConfig(this, "config_rune_pos", false, undefined, (obj)=>{
			// 	rune_pos_cfg = obj
			// 	res_mgr.DestoryGameConfig(this, "config_rune_pos", false)
			// })
			// await res_mgr.LoadGameConfig(this, "GoodsSubtype", false, undefined, (obj)=>{
			// 	goods_sub_type_cfg = obj
			// 	res_mgr.DestoryGameConfig(this, "GoodsSubtype", false)
			// })
			// await res_mgr.LoadGameConfig(this, "config_rune_all_show", false, undefined, (obj)=>{
			// 	config_rune_all_show = obj
			// 	res_mgr.DestoryGameConfig(this, "config_rune_all_show", false)
			// })
			// await res_mgr.LoadGameConfig(this, "config_rune_wake_up_lv", false, undefined, (obj)=>{
			// 	config_rune_wake_up_lv = obj
			// 	res_mgr.DestoryGameConfig(this, "config_rune_wake_up_lv", false)
			// })
			// await res_mgr.LoadGameConfig(this, "config_rune_wake_up_exp", false, undefined, (obj)=>{
			// 	config_rune_wake_up_exp = obj
			// 	res_mgr.DestoryGameConfig(this, "config_rune_wake_up_exp", false)
			// })
			this.InitInsertSubTypeList()
			this.wait_goods_id={}
		}

		this.GetCoefficientCfg = () => {
			return coefficient_cfg
		}

		this.GetRuneAttrNumCfg = () => {
			return rune_attr_num_cfg
		}

		this.GetGoodsDecomposeCfg = () => {
			return config_goods_decompose
		}

		// this.GetRunePosCfg = ()=>{
		// 	return rune_pos_cfg
		// }

		this.GetGoodsSubtypeCfg = () => {
			return goods_sub_type_cfg
		}

		// this.GetRuneAllShowCfg = ()=>{
		// 	return config_rune_all_show
		// }

		this.GetWakeUpCfg = () => {
			return config_rune_wake_up
		}

		// this.GetRunewakeuplvCfg = ()=>{
		// 	return config_rune_wake_up_lv
		// }
		// this.GetRunewakeupexpCfg = ()=>{
		// 	return config_rune_wake_up_exp
		// }
		// this.GetRunewakeskillCfg = ()=>{
		// 	return config_rune_awake_skill
		// }

		this.SetRuneInfo = (data?) => {
			this.rune_info = data
			this.Fire(local_RuneEvent.UPDATE_RUNE_DATA)
		}

		this.GetRuneDataByPosId = (pos_id?) => {
			let rune = null
			if (this.rune_info && this.rune_info.rune_list) {
				let i = 0
				do {
					if (this.rune_info.rune_list[i] && this.rune_info.rune_list[i].pos_id == pos_id) {
						rune = this.rune_info.rune_list[i]
						break
					}
					i = i + 1
				} while ((i < this.rune_info.rune_list.length))
			}
			return rune
		}

		this.UpdateRuneDataLvByGoodsId = (goods_id?, rune_point?) => {
			if (this.rune_info && this.rune_info.rune_list) {
				this.rune_info.rune_point = rune_point
				let data = null
				let i = 0
				do {
					if (this.rune_info.rune_list[i] && this.rune_info.rune_list[i].goods_id == goods_id) {
						this.rune_info.rune_list[i].lv = this.rune_info.rune_list[i].lv + 1
						data = this.rune_info.rune_list[i]
						break
					}
					i = i + 1
				} while ((i < this.rune_info.rune_list.length))
				this.Fire(local_RuneEvent.UPDATE_ONE_RUNE_DATA, goods_id, data)
			}
		}

		this.GetRuneProList = (subtype?, lv?, color?) => {
			let result_list = []
			let obj = null
			if (subtype && lv && color) {
				if (rune_attr_num_cfg && coefficient_cfg) {
					let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, subtype + "@" + lv, false, rune_attr_num_cfg)
					let cfg2 = coefficient_cfg[subtype + "@" + color]
					if (cfg && cfg2 && cfg.attr_num_list && cfg2.attr_coefficient_list) {
						let pro_list = JSON.parse(cfg.attr_num_list)
						let rate_list = JSON.parse(cfg2.attr_coefficient_list)
						if (pro_list && rate_list) {
							let i = 0
							do {
								obj = []
								obj[0] = Number(pro_list[i][0])
								if (rate_list[i]) {
									obj[1] = Math.round(pro_list[i][1] * rate_list[i][1] / 1000)
								} else {
									obj[1] = Number(pro_list[i][1])
								}
								result_list.push(obj)
								i = i + 1
							} while ((i < pro_list.length))
						}
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a[0] - b[0]
			}
			result_list.sort(sort_fun)
			return result_list
		}

		this.GetProStr = (pro_list?, color_str_number?, max_pro_list?, awakeAtrr?, withoutName?) => {
			let str = ""
			if (pro_list) {
				let max = null
				let i = 0
				do {
					if (pro_list[i]) {
						max = ""
						if (max_pro_list && max_pro_list[i] && max_pro_list[i][1] != 202) {
							max = " <font color='#639c12'>(满级:" + local_WordManager.ConvertToPercentValue(max_pro_list[i][0], max_pro_list[i][1]) + ")</font>"
						}
						if (awakeAtrr && awakeAtrr[pro_list[i][0]]) {
							pro_list[i][1] = pro_list[i][1] + awakeAtrr[pro_list[i][0]]
						}
						if (i + 1 != pro_list.length) {
							if (withoutName) {
								str = str + "<font color=" + color_str_number + ">" + local_WordManager.ConvertToPercentValue(pro_list[i][0], pro_list[i][1]) + "</font>" + max + "<br/>"
							} else {
								str = str + local_WordManager.GetProperties(pro_list[i][0]) + "：" + "<font color=" + color_str_number + ">" + local_WordManager.ConvertToPercentValue(pro_list[i][0], pro_list[i][1]) + "</font>" + max + "<br/>"
							}
						} else {
							if (withoutName) {
								str = str + "<font color=" + color_str_number + ">" + local_WordManager.ConvertToPercentValue(pro_list[i][0], pro_list[i][1]) + max + "</font>"
							} else {
								str = str + local_WordManager.GetProperties(pro_list[i][0]) + "：" + "<font color=" + color_str_number + ">" + local_WordManager.ConvertToPercentValue(pro_list[i][0], pro_list[i][1]) + max + "</font>"
							}
						}
					}
					i = i + 1
				} while ((i < pro_list.length))
			}
			return str
		}

		this.GetUpgradeCostNum = (subtype?, lv?, color?) => {
			let need_num = 0
			let obj = null
			if (subtype && lv && color) {
				let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, subtype + "@" + lv, false, rune_attr_num_cfg)
				let cfg2 = coefficient_cfg[subtype + "@" + color]
				if (cfg && cfg2) {
					need_num = Math.round(cfg.lv_up_num * cfg2.lv_up_coefficient / 1000)
				}
			}
			return need_num
		}

		this.GetOpenCondition = (pos_id?, config_rune_pos?) => {
			let str = ""
			if (config_rune_pos && config_rune_pos[pos_id]) {
				let cfg = JSON.parse(config_rune_pos[pos_id].condition)
				if (cfg) {
					for (let _tmpi in cfg) {
						var vo = cfg[_tmpi]
						if (vo[0] == "rune_tower") {
							str = "通关御魂塔第" + vo[1] + "层解锁"
						}
					}
				}
			}
			return str
		}

		this.GetOpenConditionNum = (pos_id?, config_rune_pos?) => {
			if (config_rune_pos && config_rune_pos[pos_id]) {
				let cfg = JSON.parse(config_rune_pos[pos_id].condition)
				if (cfg) {
					for (let _tmpi in cfg) {
						var vo = cfg[_tmpi]
						if (vo[0] == "rune_tower") {
							return vo[1];
						}
					}
				}
			}
		}

		this.GetCanReturnExAfterDecompose = (pro_cfg?, rate_cfg?, subtype?, lv?, color?) => {
			let exp = 0
			let obj = null
			let cfg = null
			let cfg2 = null
			let lv_up_num = 0
			if ((((pro_cfg && rate_cfg) && subtype) && lv) && color) {
				cfg2 = rate_cfg[subtype + "@" + color]
				if (cfg2) {
					let i = 1
					do {
						cfg = pro_cfg[subtype + "@" + lv]
						if (cfg) {
							lv_up_num = cfg.lv_up_num * cfg2.lv_up_coefficient / 1000
							exp = exp + lv_up_num
						}
						i = i + 1
					} while ((i < lv))
				}
			}
			return exp
		}

		this.GetFightAndProList = () => {
			let all_fight = 0
			let all_pao = []
			let is_same = false
			let tmp = null
			if (this.rune_info && this.rune_info.rune_list) {
				for (let _tmpi in this.rune_info.rune_list) {
					var obj = this.rune_info.rune_list[_tmpi]
					for (let _tmpi in obj.attr_list) {
						var pro = obj.attr_list[_tmpi]
						is_same = false
						for (let _tmpi in all_pao) {
							var val = all_pao[_tmpi]
							if (val[0] == pro.attr_id) {
								is_same = true
								val[1] = val[1] + pro.attr_num
								break
							}
						}
						if (!is_same) {
							tmp = []
							tmp[0] = pro.attr_id
							tmp[1] = pro.attr_num
							all_pao.push(tmp)
						}
					}
				}
			}
			all_fight = Util.CalAttrPower(all_pao, false)
			return [all_fight, all_pao]
		}

		this.GetJingHuaExpDesc = (type_id?) => {
			let str = ""
			if (config_goods_decompose && type_id) {
				let cfg = Config.GetConfigVo("config_goods_decompose", type_id, false, config_goods_decompose)
				if (cfg) {
					let mat = JSON.parse(cfg.regular_mat)
					if (mat && mat[0]) {
						str = "御魂经验<font color='#0a953e'>+" + mat[0][2] + "</font>"
					}
				}
			}
			return str
		}

		this.GetAllProShow = (list?) => {
			if (!all_pro_style_) {
				all_pro_style_ = []
				let sub_type = []
				for (let key in goods_sub_type_cfg) {
					if (goods_sub_type_cfg[key].type == 26) {
						sub_type.push(goods_sub_type_cfg[key].subtype)
					}
				}
				let cfg = null
				let pro = null
				let find_same = false
				let obj = null
				for (let _tmpi in sub_type) {
					obj = sub_type[_tmpi]
					cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, obj + "@1", false, rune_attr_num_cfg)
					if (cfg) {
						pro = JSON.parse(cfg.attr_num_list)
						if (pro) {
							for (let _tmpi in pro) {
								var vo = pro[_tmpi]
								find_same = false
								let i = 0
								do {
									if (all_pro_style_[i] && all_pro_style_[i][0] == vo[0]) {
										find_same = true
										break
									}
									i = i + 1
								} while ((i < all_pro_style_.length))
								if (!find_same) {
									obj = []
									obj[0] = vo[0]
									obj[1] = 0
									all_pro_style_.push(obj)
								}
							}
						}
					}
				}
				let sort_fun = (a?, b?) => {
					if (a && b && a[1] && b[1]) {
						return a[1] - b[1]
					}
				}
				all_pro_style_.sort(sort_fun)
			}
			let pro_list = Util.DeepCopy(all_pro_style_)
			if (list) {
				for (let _tmpi in pro_list) {
					var obj = pro_list[_tmpi]
					for (let _tmpi in list[1]) {
						var vo = list[1][_tmpi]
						if (Number(obj[0]) == vo[0]) {
							obj[1] = obj[1] + vo[1]
						}
					}
				}
			}
			return pro_list
		}

		this.CanInsert = (pos_id?) => {
			let can_insert = false
			let find_same = false
			let vo = null
			if (this.rune_info) {
				if (pos_id) {
					let basic = null
					for (let _tmpi in this.rune_info.rune_list) {
						var obj = this.rune_info.rune_list[_tmpi]
						if (obj.pos_id == pos_id && obj.if_open > 0) {
							if (obj.goods_type_id > 0) {
								basic = goods_model.GetGoodsBasicByTypeId(obj.goods_type_id)
								if (basic) {
									let i = 0
									do {
										vo = goods_model.runebag_goods_list[i]
										if (vo && vo.subtype != 99) {
											if (vo.subtype == basic.subtype && vo.color > obj.color) {
												can_insert = true
												break
											}
										}
										i = i + 1
									} while ((i < goods_model.runebag_goods_list.length))
									// if (!can_insert && basic.subtype != local_RuneModel.ExpRuneSubType) {
									// 	let is_exclude = false
									// 	let is_include = true
									// 	let _vo = null
									// 	let i = 0
									// 	do {
									// 		_vo = goods_model.runebag_goods_list[i]
									// 		if (_vo && _vo.subtype != 99 && pos_id != 9 && pos_id != 10 && _vo.subtype != local_RuneModel.ExpRuneSubType) {
									// 			is_exclude = this.IsExcludeSubtypeByPosId(pos_id, _vo.subtype)
									// 			is_include = this.IsIncludeSubtypeByPosId(pos_id, _vo.subtype)
									// 			if (!is_exclude && is_include) {
									// 				find_same = this.FindIsWearTheSame(_vo)
									// 				if (!find_same && _vo.color > obj.color) {
									// 					can_insert = true
									// 					break
									// 				}
									// 			}
									// 		}
									// 		i = i + 1
									// 	} while ((i < goods_model.runebag_goods_list.length))
									// }
								}
							} else {				//未镶嵌
								let is_exclude = false
								let is_include = true
								let _vo = null
								let i = 0
								do {
									_vo = goods_model.runebag_goods_list[i]
									if (_vo && _vo.subtype != 99) {
										is_exclude = this.IsExcludeSubtypeByPosId(pos_id, _vo.subtype)
										is_include = this.IsIncludeSubtypeByPosId(pos_id, _vo.subtype)
										if (!is_exclude && is_include) {
											find_same = this.FindIsWearTheSame(_vo)
											if (!find_same) {
												can_insert = true
												break
											}
										}
									}
									i = i + 1
								} while ((i < goods_model.runebag_goods_list.length))
							}
						}
					}
				} else {
					let i = 1
					do {
						can_insert = this.CanInsert(i)
						if (can_insert) {
							break
						}
						i = i + 1
					} while ((i <= 10))
					if (can_insert != _insert_red_) {
						_insert_red_ = can_insert
						this.UpdateRed()
					}
				}
			}
			return can_insert
		}

		this.GetRunDataByGoodsId = (goods_id?) => {
			let vo = null
			if (this.rune_info && this.rune_info.rune_list) {
				for (let i = 0; i < this.rune_info.rune_list.length; i++) {
					var v = this.rune_info.rune_list[i]
					if (v.goods_id == goods_id) {
						vo = v
						break
					}
				}
			}
			return vo
		}

		this.FindIsWearTheSame = (bag_vo?) => {
			let same = false
			if (bag_vo) {
				let pro_list = this.GetRuneProList(bag_vo.subtype, bag_vo.level, bag_vo.color)
				let j = 0
				let wear_vo = null
				if (this.rune_info && this.rune_info.rune_list) {
					do {
						wear_vo = goods_model.wear_rune_list[j]
						if (wear_vo) {
							if (wear_vo.subtype == bag_vo.subtype) {
								same = true
								break
							}
							if (!same && pro_list) {
								for (let i = 0; i < pro_list.length; i++) {
									var v = pro_list[i]
									for (let j = 0; j < this.rune_info.rune_list.length; j++) {
										var o = this.rune_info.rune_list[j]
										for (let h = 0; h < o.attr_list.length; h++) {
											var val = o.attr_list[h]
											if (Number(v[0]) == val.attr_id) {
												same = true
												break
											}
										}
										if (same) {
											break
										}
									}
									if (same) {
										break
									}
								}
							}
						}
						j = j + 1
					} while ((j < goods_model.wear_rune_list.length))
				}
			}
			return same
		}

		this.CanUpgrade = (pos_id?) => {
			let can_upgrade = false
			let rune_data = null
			let basic = null
			if (this.rune_info) {
				if (pos_id) {
					rune_data = this.GetRuneDataByPosId(pos_id)
					if (rune_data) {
						basic = goods_model.GetGoodsBasicByTypeId(rune_data.goods_type_id)
						if (basic) {
							let lv = rune_data.lv + 1
							let next_cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, basic.subtype + "@" + lv, false, rune_attr_num_cfg)
							if (next_cfg) {
								let cost_num = this.GetUpgradeCostNum(basic.subtype, rune_data.lv + 1, basic.color)
								if (this.rune_info.rune_point > cost_num) {
									can_upgrade = true
								}
							}
						}
					}
				} else {
					let i = 1
					do {
						can_upgrade = this.CanUpgrade(i)
						if (can_upgrade) {
							break
						}
						i = i + 1
					} while ((i <= 10))
					if (_upgrade_red_ != can_upgrade) {
						_upgrade_red_ = can_upgrade
						this.UpdateRed()
					}
				}
			}
			return can_upgrade
		}

		this.CanExchange = () => {
			let can_exchange = false
			return can_exchange
		}

		this.CanResolve = (bag_rune?) => {
			if (!this.rune_info) {
				return false
			}
			bag_rune = bag_rune == null && this.GetRunesInBag() || bag_rune
			let can_resolve = false
			let vo = null
			let basic = null
			let i = 0
			if (bag_rune) {
				for (let i = 0; i < bag_rune.length; i++) {
					vo = bag_rune[i]
					if (vo.subtype == 99 || (vo.color <= 2 && !vo.is_better)) {
						can_resolve = true
						break
					}
				}
			}
			//do {
			//vo = goods_model.runebag_goods_list[i]
			//if (vo ) { 
			//if (vo.subtype == 99 ) {
			//can_resolve = true
			//break
			//} else if (vo.subtype < 24 ) {
			//if (vo.color <= 2 ) {
			//for (let _tmpi in this.rune_info.rune_list) {
			// var wear = this.rune_info.rune_list[_tmpi]
			//basic = goods_model.GetGoodsBasicByTypeId(wear.goods_type_id)
			//if (basic ) {
			//if (vo.subtype == basic.subtype ) {
			//if (vo.color < basic.color ) {
			//can_resolve = true
			//} else if (vo.color == basic.color ) {
			//if (vo.level <= wear.lv ) {
			//can_resolve = true
			//}else{
			//can_resolve = false
			//}
			//}else{
			//can_resolve = false
			//}
			//}
			//}
			//}
			//if (! can_resolve ) {
			//for (let _tmpi in goods_model.runebag_goods_list) {
			// var tmp = goods_model.runebag_goods_list[_tmpi]
			//if (vo.subtype == tmp.subtype && vo.goods_id != tmp.goods_id ) {
			//if (vo.color < tmp.color ) {
			//can_resolve = true
			//} else if (vo.color == tmp.color ) {
			//if (vo.level < tmp.level ) {
			//can_resolve = true
			//}else{
			//can_resolve = false
			//}
			//}else{
			//can_resolve = false
			//}
			//}
			//}
			//}
			//}
			//}
			//}

			//if (can_resolve ) {
			//break
			//}
			//i=i+1
			//} while ((i < goods_model.runebag_goods_list.length))
			if (this._resolve_red != can_resolve) {
				this._resolve_red = can_resolve
				this.UpdateRed()
			}
			return can_resolve
		}

		this.UpdateRed = () => {
			let bool = this.ShowRuneRedDot()
			if (bool != _show_red_) {
				_show_red_ = bool
				this.Fire(local_RuneEvent.UPDATE_RUNE_RED_DOT)
				GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
			}
		}

		this.ShowRuneRedDot = () => {
			RedDotController.ins.up(RedKey.RUNE, common_mgr.CheckFuncOpenState("SecretTreasureMainView", true) && (_upgrade_red_ || _insert_red_ || this._resolve_red || awakeRed_ || this.skillRed) ? 1 : 0)
			return common_mgr.CheckFuncOpenState("SecretTreasureMainView", true) && (_upgrade_red_ || _insert_red_ || this._resolve_red || awakeRed_ || this.skillRed)
		}

		this.GetProBySubtype = (subtype?, level?, color?, rune_attr_coefficient_cfg?, awakeCfg?) => {
			let str = ""
			let pro_list = this.GetRuneProList(subtype, level, color)
			if (pro_list) {
				let attrList1 = []
				let composite_model = window["CompositeModel"].GetInstance()
				if (awakeCfg && !Util.IsTableEmpty(composite_model.RuneComposeAwakeList())) {
					let awake_list = composite_model.RuneComposeAwakeList()
					for (let key in awake_list) {
						let awakeInfo = awake_list[key]
						let attr_id = (awakeInfo.attr_id && (awakeInfo.attr_id) || (awakeInfo.attr_type))
						let awake_lv = awakeInfo.awake_lv
						let config = awakeCfg[color + "@" + attr_id + "@" + awake_lv]
						if (config) {
							let attrList = JSON.parse(config.attr)
							if (attrList.length > 0) {
								attrList1[attrList[0][0]] = attrList[0][1]
							}
						}
					}
				}
				str = this.GetProStr(pro_list, local_Enum_ColorUtil_Dark.GREEN, null, attrList1)
			}
			return str
		}

		this.GetTipShowProBySubtype = (subtype?, color?, goods_id?) => {
			let str = ""
			let pro_list = this.GetRuneProList(subtype, 1, color)
			let max_pro_list = []
			if (color >= 4 && goods_id == null) {
				max_pro_list = this.GetRuneProList(subtype, local_RuneModel.MaxLv, color)
			}
			if (pro_list) {
				str = this.GetProStr(pro_list, local_Enum_ColorUtil_Dark.GREEN, max_pro_list)
			}
			return str
		}

		this.GetUnLockStr = (type_id, config_rune_all_show) => {
			let floor = 0
			if (config_rune_all_show) {
				for (let key in config_rune_all_show) {
					if (config_rune_all_show[key].goods_type_id == type_id) {
						floor = config_rune_all_show[key].unlock_floor
						break
					}
				}
			}
			let str = ""
			if (floor > 0) {
				str = "【御魂塔第" + floor + "层解锁】"
			}
			return str
		}

		this.InitInsertSubTypeList = () => {
			let rune_pos_cfg = Config.PRELOAD_SERVER_CONFIG.config_rune_pos
			if (config_goods_decompose && rune_pos_cfg) {
				let exclude = null
				let include = null
				let config_rune_pos = rune_pos_cfg
				for (let pos in config_rune_pos) {
					exclude = []
					include = []
					let cfg = JSON.parse(config_rune_pos[pos].condition)
					if (cfg) {
						for (let _tmpi in cfg) {
							var vo = cfg[_tmpi]
							if (vo[0] == "exclude_rune_subtype") {
								exclude = vo[1]
							} else if (vo[0] == "rune_subtype") {
								include = vo[1]
							}
						}
					}
					exclude_subtype_list_[pos] = exclude
					include_subtype_list_[pos] = include
				}
			}
		}

		this.IsExcludeSubtypeByPosId = (pos_id?, subtype?) => {
			let is_exclude = false
			if (exclude_subtype_list_ && exclude_subtype_list_[pos_id]) {
				for (let _tmpi in exclude_subtype_list_[pos_id]) {
					var vo = exclude_subtype_list_[pos_id][_tmpi]
					if (subtype == Number(vo)) {
						is_exclude = true
						break
					}
				}
			}
			return is_exclude
		}

		this.IsIncludeSubtypeByPosId = (pos_id?, subtype?) => {
			let is_include = true
			if (include_subtype_list_ && include_subtype_list_[pos_id] && include_subtype_list_[pos_id].length > 0) {
				is_include = false
				for (let _tmpi in include_subtype_list_[pos_id]) {
					var vo = include_subtype_list_[pos_id][_tmpi]
					if (subtype == Number(vo)) {
						is_include = true
						break
					}
				}
			}
			return is_include
		}

		this.RuneTypeGoodsNum = (goods_id?, type_id?) => {
			let num = 0
			let list = goods_model.runebag_goods_list
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.goods_id == goods_id) {
					break
				}
				let awake = false
				for (let key in vo.awake_list) {

					let info = vo.awake_list[key]
					if (info.awake_lv > 0) {
						awake = true
						break
					}
				}
				if (awake) {
					break
				}
				if (vo.type_id == type_id) {
					num = num + 1
				}
			}
			return num
		}

		this.RuneTypeGoodsList = (goods_id?, type_id?, needNum?) => {
			let list = []
			let num = 0
			for (let _tmpi in goods_model.runebag_goods_list) {
				var vo = goods_model.runebag_goods_list[_tmpi]
				if (vo.goods_id == goods_id) {
					break
				}
				let awake = false
				for (let key in vo.awake_list) {

					let info = vo.awake_list[key]
					if (info.awake_lv > 0) {
						awake = true
						break
					}
				}
				if (awake) {
					break
				}
				if (vo.type_id == type_id) {
					list.push(vo.goods_id)
					num = num + 1
				}
				if (needNum && num >= needNum) {
					break
				}
			}
			return list
		}

		this.GetRunesAwakenInBag = () => {
			let list = []
			let saveDic = []
			if (!this.rune_info) {
				return list
			}
			let pushList = this.rune_info.rune_list
			for (let _tmpi in pushList) {
				var vo = pushList[_tmpi]
				if (vo.color < local_ColorType.ORANGE) {

				} else {
					let goos_vo = goods_model.GetGoodsBasicByTypeId(vo.goods_type_id)
					if (goos_vo) {
						let awake_lv = 0
						let awakenList = vo.attr_list
						for (let key in awakenList) {

							let awakeninfo = awakenList[key]
							if (awakeninfo.awake_lv > awake_lv) {
								awake_lv = awakeninfo.awake_lv
							}
						}
						let key = goos_vo.subtype + "@" + goos_vo.color
						vo["Index"] = 10000
						saveDic[key] = { "vo": vo, "awake_lv": awake_lv };
					}
				}
			}
			let bagList = goods_model.runebag_goods_list
			for (let _tmpi in bagList) {
				var vo = bagList[_tmpi]
				if (vo.subtype == 99 || vo.color < local_ColorType.ORANGE) {

				} else {
					let key = vo.subtype + "@" + vo.color
					let saveVo = saveDic[key] && saveDic[key]["vo"]
					let save_awake_lv = saveDic[key] && saveDic[key]["awake_lv"]
					let awake_lv = 0
					let awakenList = vo.awake_list
					for (let key in awakenList) {

						let awakeninfo = awakenList[key]
						if (awakeninfo.awake_lv > awake_lv) {
							awake_lv = awakeninfo.awake_lv
						}
					}
					if (!saveVo || awake_lv > save_awake_lv || (awake_lv == 0 && save_awake_lv == 0 && !saveVo.subtype && vo.level > saveVo.lv)) {
						vo["Index"] = 0
						saveDic[key] = { "vo": vo, "awake_lv": awake_lv };
					}
				}
			}
			for (let key in saveDic) {
				let vo = saveDic[key]["vo"]
				if (vo) {
					if (!vo.subtype) {
						let goos_vo = goods_model.GetGoodsBasicByTypeId(vo.goods_type_id)
						if (goos_vo) {
							vo.Index = vo.Index - goos_vo.subtype
						}
					} else {
						vo.Index = vo.Index - vo.subtype
					}
					vo.Index = vo.Index + 100 * vo.color
					list.push(vo)
				}
			}
			list.sort((a?, b?) => {
				return b.Index - a.Index
			}
			)
			return list
		}

		this.RuneAwakeTabIndex = (list?, config_rune_wake_up?, config_rune_wake_up_exp?, config_rune_wake_up_lv?) => {
			let index = 0
			let can = false
			for (let key in list) {
				let vo = list[key]
				let isBag = vo.subtype != null
				if (isBag) {
					index = index + 1
				} else {
					if (this.RuneCanAwake(vo, config_rune_wake_up, config_rune_wake_up_exp, config_rune_wake_up_lv)) {
						can = true
						break
					}
					index = index + 1
				}
			}
			index = (can && (index) || (0))
			return index
		}

		this.RuneCanAwake = (info?, config_rune_wake_up?, config_rune_wake_up_exp?, config_rune_wake_up_lv?) => {
			let flag = false
			let awakenList = (info.attr_list && (info.attr_list) || (info.awake_list))
			let goods_id = info.goods_id
			if (!info.subtype) {
				let goos_vo = goods_model.GetGoodsBasicByTypeId(info.goods_type_id)
				if (goos_vo) {
					info = goos_vo
				}
			}
			for (let key in awakenList) {
				let awakeninfo = awakenList[key]
				let attr_id = (awakeninfo.attr_id && (awakeninfo.attr_id) || (awakeninfo.attr_type))
				let attrConfig = config_rune_wake_up[info.color + "@" + attr_id + "@" + (awakeninfo.awake_lv + 1) || 1]
				if (attrConfig) {
					flag = this.RuneAttrCanAwake(awakeninfo.awake_lv || 0, awakeninfo.awake_exp || 0, goods_id, RuneModel.RuneAttrToSubType[Number(attr_id)] || Number(attr_id), config_rune_wake_up_exp, config_rune_wake_up_lv)
				}
				if (flag) {
					return true
				}
			}
			return false
		}

		this.RuneAttrCanAwake = (awake_lv?, awake_exp?, goods_id?, subType?, config_rune_wake_up_exp?, config_rune_wake_up_lv?) => {
			if (awake_exp == null) {
				awake_exp = 0
			}
			let flag = false
			let lvCfg = config_rune_wake_up_lv
			let expCfg = config_rune_wake_up_exp
			let ExpConfig = lvCfg[awake_lv]
			if (ExpConfig) {
				let needExp = ExpConfig.exp - awake_exp
				let list = goods_model.rune_type_dic[subType]
				if (list) {
					let color = null
					let bag_list = goods_model.GetRuneBagDic()
					if (bag_list) {
						let goods_vo = bag_list[goods_id]
						if (!goods_vo) {
							goods_vo = this.GetRunDataByGoodsId(goods_id)
						}
						if (goods_vo) {
							color = goods_vo.color
						}
					}
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						if (vo.goods_id != goods_id && vo.color > 3 && vo.color < 6 && (color == null || color >= vo.color)) {
							let notAwake = true
							for (let _tmpi in vo.awake_list) {
								var awakeInfo = vo.awake_list[_tmpi]
								if (awakeInfo.awake_lv > 0) {
									notAwake = false
									break
								}
							}
							if (notAwake) {
								needExp = needExp - expCfg[vo.color].exp || 0
								if (needExp <= 0) {
									return true
								}
							}
						}
					}
				}
			}
			return false
		}

		this.souldAwakeAttrIndex = (list?, config_rune_wake_up_exp?, config_rune_wake_up_lv?) => {
			let index = 0
			let can = false
			for (let key in list) {
				let attrInfo = list[key]
				if (this.RuneAttrCanAwake(attrInfo["awake_lv"], attrInfo["awake_exp"], attrInfo["goods_id"], RuneModel.RuneAttrToSubType[Number(attrInfo[0])], config_rune_wake_up_exp, config_rune_wake_up_lv)) {
					can = true
					break
				}
				index = index + 1
			}
			index = (can && (index) || (0))
			return index
		}

		this.CheckRedStatus = (mType?, rtype?) => {
			return RedDotManager.GetInstance().CheckRedStatus(mType, rtype)
		}

		this.GetRunesInBag = () => {
			let goods = []
			let other = []
			let better_dic = []
			let dic = this.GetSubRuneEquipDic()
			for (let _tmpi in goods_model.runebag_goods_list) {
				var vo = goods_model.runebag_goods_list[_tmpi]
				let awake = false
				for (let key in vo.awake_list) {
					let awakeInfo = vo.awake_list[key]
					if (awakeInfo.awake_lv > 0) {
						awake = true
						break
					}
				}
				if (awake) {

				} else {
					let attrCfg = coefficient_cfg[vo.subtype + "@" + vo.color]
					let attr = JSON.parse(attrCfg.attr_coefficient_list)
					if (attrCfg && attrCfg.attr_coefficient_list && attr && attr.length > 1 && attrCfg.sub_type != 26 && attrCfg.sub_type != 27) {

					} else {
						let c = Config.GetConfigVo("config_goods_decompose", vo.type_id, false, config_goods_decompose)
						if (c) {
							vo.is_selected = vo.is_selected || false
							vo.is_better = false
							if (vo.subtype == 99) {
								vo.soul_intro = this.GetMtrlIntro(vo.type_id)
								vo.is_selected = true
								other.push(vo)
							} else {
								goods.push(vo)
								let esoul = dic[vo.subtype]
								if (esoul) {
									let is_better = vo.color > esoul.color || (vo.color == esoul.color && vo.level > esoul.level)
									if (is_better) {
										let betVo = better_dic[vo.subtype]
										if (!betVo) {
											better_dic[vo.subtype] = vo
											vo.is_better = true
										} else {
											is_better = vo.color > betVo.color || (vo.color == betVo.color && vo.level > betVo.level)
											if (is_better) {
												better_dic[vo.subtype] = vo
												betVo.is_better = false
												vo.is_better = is_better
											}
										}
									}
								} else {
									vo.is_better = true
									dic[vo.subtype] = vo
									better_dic[vo.subtype] = vo
								}
							}
						}
					}
				}
			}

			goods.sort((a?, b?) => {
				if (a.subtype == 99 || b.subtype == 99) {
					if (a.subtype == b.subtype) {
						return a.color - b.color
					}
					if (a.subtype == 99) {
						return -1
					} else if (b.subtype == 99) {
						return 1
					}
				} else {
					if (a.color != b.color) {
						return a.color - b.color
					} else {
						if (a.subtype != b.subtype) {
							return a.subtype - b.subtype
						} else {
							return a.level - b.level
						}
					}
				}
			}
			)
			for (let i = 0; i < goods.length; i++) {
				var v = goods[i]
				other.push(v)
			}
			return other
		}

		this.GetRuneExp = () => {
			if (!this.rune_info) {
				return 0
			}
			return this.rune_info.rune_point
		}

		this.GetSubRuneEquipDic = () => {
			let dic = []
			let rune_dic = goods_model.wear_rune_dic
			for (let key in rune_dic) {
				if (rune_dic[key]) {
					dic[rune_dic[key].subtype] = rune_dic[key]
				}
			}
			return dic
		}

		this.GetMtrlIntro = (type_id?) => {
			let intro = ""
			if (!config_goods_decompose) {
				return intro
			}
			let cfg = Config.GetConfigVo("config_goods_decompose", type_id, false, config_goods_decompose)
			if (!cfg) {
				return intro
			}
			if (cfg.regular_mat) {
				let mat = JSON.parse(cfg.regular_mat)
				if (!mat || !mat[0]) {
					return intro
				}
				intro = "御魂经验<font color='#0a953e'>+" + mat[0][2] + "</font>"
			}
			return intro
		}

		this.reSetResolutionDic = () => {
			this._resolutionDic = []
		}

		this.GetRunesResolutionInBag = () => {
			let list = []
			for (let _tmpi in goods_model.runebag_goods_list) {
				var vo = goods_model.runebag_goods_list[_tmpi]
				if (vo.subtype == 99) {

				} else {
					let awake = false
					for (let key in vo.awake_list) {

						let info = vo.awake_list[key]
						if (info.awake_lv > 0) {
							awake = true
							break
						}
					}
					if (awake) {
						list.push(vo)
					} else {
						let config = coefficient_cfg[vo.subtype + "@" + vo.color]
						if ((!config || vo.subtype == 26) || vo.subtype == 27) {

						} else {
							if (config.attr_coefficient_list) {
								let attrlist = JSON.parse(config.attr_coefficient_list)
								let length = Util.TableSize(attrlist)
								if (length >= 2) {
									list.push(vo)
								}
							}
						}
					}
				}
			}
			list.sort((a?, b?) => {
				if (a.color == b.color) {
					return a.subtype - b.subtype
				} else {
					return a.color - b.color
				}
			}
			)
			return list
		}

		this.addResolutionDic = (vo?, index?) => {
			if (!this._resolutionDic[index]) {
				this._resolutionDic[index] = vo
				this.Fire(local_RuneEvent.RUNE_RESOLUTION_SELECT)
			}
		}

		this.GetRuneResolutionMat = (config_rune_awake?, decompose_cfg?, config_rune_attr?) => {
			let dic = []
			for (let key in this._resolutionDic) {
				let vo = this._resolutionDic[key]
				if (!vo) {
					break
				}
				let decomposeConfig = Config.GetConfigVo("config_goods_decompose", vo.type_id, false, config_goods_decompose)
				let i = 0
				let attrCfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, vo.subtype + "@" + vo.color, false)
				let doubleAttr = attrCfg && attrCfg.attr_coefficient_list && JSON.parse(attrCfg.attr_coefficient_list) >= 2
				if (decomposeConfig && doubleAttr) {
					let matList = JSON.parse(decomposeConfig.regular_mat)
					for (let key in matList) {
						let matinfo = matList[key]
						let matKey = matinfo[0] + "@" + matinfo[1]
						if (!dic[matKey]) {
							dic[matKey] = matinfo
						} else {
							dic[matKey][2] = dic[matKey][2] + matinfo[2]
						}
					}
				}
				for (let key in vo.awake_list) {
					let info = vo.awake_list[key]
					let config = config_rune_wake_up[vo.color + "@" + info.attr_type + "@" + info.awake_lv]
					if (config) {
						let backcostList = JSON.parse(config.back_cost)
						for (let key in backcostList) {

							let cost = backcostList[key]
							let costKey = cost[0] + "@" + cost[1]
							if (!doubleAttr) {
								cost[2] = cost[2] + 1
							}
							if (!dic[costKey]) {
								dic[costKey] = cost
							} else {
								dic[costKey][2] = dic[costKey][2] + cost[2]
							}
						}
					}
				}
			}
			return dic
		}

		this.GetRuneAttr = (sub_type?, lv?, quality?) => {
			let data = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_rune_attr_num.name, sub_type + "@" + lv, false, rune_attr_num_cfg)
			if (!data) {
				return {}
			}
			let ratio = coefficient_cfg[sub_type + "@" + quality]
			if (!ratio || !ratio.attr_coefficient_list) {
				return {}
			}
			let attr_list = JSON.parse(data.attr_num_list)
			let ratio_list = JSON.parse(ratio.attr_coefficient_list)
			let i = 0
			do {
				attr_list[i][1] = Math.round(attr_list[i][1] * ratio_list[i][1] / 1000)
				i = i + 1
			} while ((i < attr_list.length))
			return attr_list
		}

		this.delResolutionDic = (index?) => {
			this._resolutionDic[index] = null
			this.Fire(local_RuneEvent.RUNE_RESOLUTION_SELECT)
		}

		this.CanAwake = (config_rune_wake_up?, config_rune_wake_up_exp?, config_rune_wake_up_lv?) => {
			if (!common_mgr.CheckFuncOpenState("RuneAwakenView", true)) {
				return false
			}
			let flag = false
			let list = (this.rune_info && (this.rune_info.rune_list) || ({}))
			for (let key in list) {

				let info = list[key]
				flag = this.RuneCanAwake(info, config_rune_wake_up, config_rune_wake_up_exp, config_rune_wake_up_lv)
				if (flag) {
					break
				}
			}
			if (awakeRed_ != flag) {
				awakeRed_ = flag
				this.UpdateRed()
			}
			return awakeRed_
		}

		this.CanActiveSkill = (config_rune_awake_skill) => {
			if (!this.rune_info) {
				return false
			}
			let flag = false
			if (this.CanSkillUp(this.rune_info["skill_lv"] + 1, config_rune_awake_skill)) {
				flag = true
			}
			if (flag != this.skillRed) {
				this.skillRed = flag
				this.UpdateRed()
				return
			}
			return flag
		}

		// this.GetRuneAwakeSkillcfg = (skill_id?, skill_lv?) => {
		// 	return config_rune_awake_skill[skill_id + "@" + skill_lv]
		// }

		this.CanSkillUp = (skillLv?, config_rune_awake_skill?) => {
			// let lvCfg = this.GetRuneAwakeSkillcfg(local_RuneModel.SkillId, skillLv)
			if (config_rune_awake_skill) {
				let lvCfg = config_rune_awake_skill[local_RuneModel.SkillId + "@" + skillLv]
				if (lvCfg) {
					let condition = JSON.parse(lvCfg.condition)
					for (let _tmpi in condition) {
						var vo = condition[_tmpi]
						let count = Number(vo[1])
						for (let _tmpi in this.rune_info.rune_list) {
							var runeInfo = this.rune_info.rune_list[_tmpi]
							if (runeInfo.color >= Number(vo[0])) {
								for (let _tmpi in runeInfo.attr_list) {
									var awakeVo = runeInfo.attr_list[_tmpi]
									if (awakeVo.awake_lv >= Number(vo[2])) {
										count = count - 1
										break
									}
								}
							}
							if (count <= 0) {
								return true
							}
						}
					}
				}
			}
		}

		this.RuneAwakeBagList = (goods_id?, subType?) => {
			let list = []
			for (let _tmpi in goods_model.runebag_goods_list) {
				var vo = goods_model.runebag_goods_list[_tmpi]
				if (vo.goods_id == goods_id || vo.color < 4 || vo.color > 5) {

				} else {
					let awake = false
					for (let key in vo.awake_list) {

						let info = vo.awake_list[key]
						if (info.awake_lv > 0) {
							awake = true
							break
						}
					}
					if (awake) {

					} else {
						if (vo.subtype == Number(subType)) {
							list.push(vo)
						}
					}
				}
			}
			return list
		}

		this.ChangeRuneData = (data?) => {
			let pushList = this.rune_info.rune_list
			for (let _tmpi in pushList) {
				let vo = pushList[_tmpi]
				if (vo.color < local_ColorType.ORANGE) {

				} else {
					if (Number(vo.goods_id) == Number(data.goods_id)) {
						vo.lv = data.lv
						let changeLv = false
						for (let key in vo.attr_list) {
							let attrInfo = vo.attr_list[key]
							if (attrInfo.attr_id == data.attr_id) {
								changeLv = data.awake_lv > attrInfo.awake_lv
								attrInfo.awake_lv = data.awake_lv
								attrInfo.awake_exp = data.exp
								attrInfo.next_power = data.next_power
								attrInfo.cur_power = data.cur_power
								this.Fire(local_RuneEvent.RUNE_AWAKEN_RETURN, data.goods_id, vo)
								this.Fire(local_RuneEvent.RUNE_REQUEST_PROTO, 16700)
								return changeLv
							}
						}
					}
				}
			}
			let vo = goods_model.GetGoodsVoByGoodsId(data.goods_id)
			if (vo) {
				let find = false
				let changeLv = false
				vo.level = data.lv
				for (let key in vo.awake_list) {

					let awakeInfo = vo.awake_list[key]
					if (awakeInfo.attr_type == data.attr_id) {
						changeLv = awakeInfo.awake_lv > data.awake_lv
						awakeInfo.awake_lv = data.awake_lv
						find = true
						break
					}
				}
				if (!find) {
					let obj = []
					obj["attr_type"] = data.attr_id
					obj["awake_lv"] = data.awake_lv
					vo.awake_list.push(obj)
					changeLv = true
				}
				this.Fire(local_RuneEvent.RUNE_AWAKEN_RETURN, data.goods_id, vo)
				return changeLv
			}
		}

		this.GetTipsAwakeStr = (subtype?, color?, awakeList?) => {
			if ((!rune_attr_num_cfg || !coefficient_cfg) || !config_rune_wake_up) {
				return
			}
			let str = ""
			let attrList = this.GetRuneProList(subtype, 1, color)
			let awakeProp = []
			if (awakeList && awakeList.length > 0) {
				let i = 0
				do {
					let cfg = config_rune_wake_up[color + "@" + awakeList[i].attr_type + "@" + awakeList[i].awake_lv]
					if (cfg) {
						let addAttr = JSON.parse(cfg.attr)
						if (addAttr[0]) {
							awakeProp[addAttr[0][0]] = addAttr[0][1]
						}
					}
					i = i + 1
				} while ((i < awakeList.length))
			}
			let awake = null
			for (let _tmpi in attrList) {
				var vo = attrList[_tmpi]
				awake = ""
				if (awakeProp[vo[0]]) {
					awake = " <font color='#639c12'>(觉醒:" + local_WordManager.ConvertToPercentValue(vo[0], awakeProp[vo[0]]) + ")</font > "
				}
				str = str + local_WordManager.GetProperties(vo[0]) + ": " + "<font color=" + local_Enum_ColorUtil_Dark.GREEN + ">" + local_WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>" + awake + "<br/>"
			}
			return str.replace('<br/>$', "")
		}

		this.showReward = (list?) => {
			let data = []
			for (let _tmpi in list) {
				var reward = list[_tmpi]
				for (let key in reward.goods_list) {

					let info = reward.goods_list[key]
					let vo = []
					vo.push(info.style)
					vo.push(info.typeId)
					vo.push(info.count)
					if (data[info.typeId]) {
						data[info.typeId][2] = data[info.typeId][2] + info.count
					} else {
						data[info.typeId] = vo
					}
				}
			}
			let _list = []
			for (let key in data) {
				let vo = data[key]
				_list.push(vo)
			}
			let success_view_ = new CongratulationObtainView(_list, 10)
			success_view_.Open()
		}

		this.GetAwakenLvByVo = (vo) => {
			if(vo && vo.attr_list){
				for (let key in vo.attr_list) {
					let awakeninfo = vo.attr_list[key];
					if(awakeninfo && awakeninfo.awake_lv != undefined)
					if (awakeninfo.awake_lv > 0)
					   return awakeninfo.awake_lv
				}
			}
			return 0
		}

	}

	/**
	 * 获取身上穿戴的同类型符文
	 * not_need_cfg  是否需要返回配置
	 */
	public GetWearRuneSame(type_id, not_need_cfg?) {
		//获取身上穿戴的同类型符文
		let ware_list = GoodsModel.GetInstance().wear_rune_dic 
		if (ware_list) {
			for(let key in ware_list){
				let wear_info = ware_list[key]
				if (wear_info.type_id == type_id) {
					let baseic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (!baseic) continue
					if (!not_need_cfg) {
						let cfg = Util.DeepCopy(baseic)
						cfg["level"] = wear_info.level
						cfg["goods_id"] = wear_info.goods_id
						cfg["pos_id"] = wear_info.cell
						cfg["awake_list"]=wear_info.awake_list
						return cfg
					} else {
						return 1
					}
				}
			}
		}
		return null
	}
	//穿戴在身上的御魂需要先卸载再才能进行合成操作，记录等待队列
	wait_goods_id = {}
	use_to_compose
	/**合成这里需要弹出物品使用小弹窗 仅仅用于合成界面 */
	is_request_composite=false 
	/**请求合成 */
	public RequestComposite(use_to_compose) {
		let wear_ = GoodsModel.GetInstance().wear_rune_dic  //身上穿戴的御魂
		this.use_to_compose = use_to_compose
		let is_has = false
		if (wear_) {
			let list = this.use_to_compose.wear_list
			//合成材料里面是否包含已穿戴的符文
			if (list && list.length > 0) {
				for (let i = 0; i < list.length; i++) {
					let vo = list[i]
					is_has = true
					if (!this.wait_goods_id) {
						this.wait_goods_id = {}
					}
					this.wait_goods_id[vo.goods_id]=1
					this.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16711,"cl", vo.pos_id, vo.goods_id)
				}
			}
		}
		if (!is_has) {
			this.is_request_composite =true
			CompositeModel.GetInstance().Fire(CompositeEvent.REQUEST_PROTO, this.use_to_compose.rule_id, this.use_to_compose.regular_glist, this.use_to_compose.specify_glist)
		}
	}
	/**穿在身上的御魂需要先卸载再合成 */
	public WaitCompositeBack() {
		let is_del =false
		if(this.wait_goods_id){
			for(let key in this.wait_goods_id){
				let bag_vo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(Number(this.wait_goods_id[key]))
				if(!bag_vo){
					delete this.wait_goods_id[key]
					is_del=true
				}
			}
		}
		//卸载完毕开始合成
		if(is_del&&Util.IsTableEmpty(this.wait_goods_id)&&this.use_to_compose){
			this.is_request_composite =true
			CompositeModel.GetInstance().Fire(CompositeEvent.REQUEST_PROTO, this.use_to_compose.rule_id, this.use_to_compose.regular_glist, this.use_to_compose.specify_glist)
		}
	}
	/**是否是穿戴在身上的御魂*/
	public IsRuneDress(data) {
		let ware_list = GoodsModel.GetInstance().wear_rune_dic  //身上穿戴的御魂
		if(!ware_list)return false
		for(let key in ware_list){
			let wear_info = ware_list[key]
			if (wear_info.type_id == data.type_id&&wear_info.goods_id==data.goods_id) {
				return true
			}
		}
		return false
	}
	public static GetInstance() {

		if (!RuneModel.Instance) {
			RuneModel.Instance = new RuneModel()
		}
		return RuneModel.Instance
	}
}


window["RuneModel"] = RuneModel