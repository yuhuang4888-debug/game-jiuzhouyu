import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "./RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { HtmlColorTxt, Util } from "../util/Util"
import { EquipModel } from "./EquipModel"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { OutWardBaseModel } from "./OutWardBaseModel"
import { PetEquipDefine, PetEquipTypeRedKeyMap, PetEquipRedKeyMap, PetEquipEvent, PetEquipType, PetEquipWholeType, PetEquipStarMaxDic, PetEquipTypeList, PetHorseRedList, PetPartnerRedList } from "./PetEquipDefine"

//1.装备 2.强化 3.打磨
export class PetEquipModel extends EventDispatcher {
	static Instance: PetEquipModel;

	InitCfg
	Reset
	CreateStarMaxDic
	SetPetEquipInfo
	GetPetEquipInfo
	GetPetEquipData
	GetMaxData
	GetLvData
	GetStarData
	GetStageData
	GetGoodsData
	GetWholeDataTwo
	GetLvDataByExp
	GetBagGoods
	GetTypeBagGoodDic
	GetPetEquipGoodOne
	GetBagGoodsByType
	GetBagGoodsOnlyEquip
	GetBagEquipsByType
	GetWearEquipInfo
	GetWearEquipInfos
	GetAllLv
	GetKeyByType
	GetAttrStr
	GetAddAttrStr
	GetAddAttrList
	GetStrenGoods
	GetStarGoods
	AddEmptyToList
	DicToList
	GetAttrListByTwo
	GetAttrListByMultList
	GetShowItemClass
	CheckCanEquip
	GetPosName
	PetEquipTypeName
	GetGoodTypeByType
	GetTypeByGoodType
	GetAllAttrList
	GetJsonCacheAndSet
	GetCache
	SetCache
	GetGoodsPower
	GetRedListByType
	CheckRedStatus
	SetRedStatus
	GetRedStatus
	GetAllRedStatus
	CheckEquipRedStatus
	CheckStrenRedStatus
	CheckStarRedStatus
	GetRedIDByType
	public constructor() {
		super()

		if (PetEquipModel.Instance) {
			return
		}

		let config_preload_server = Config.PRELOAD_SERVER_CONFIG,
			local_PetEquipDefine = PetEquipDefine,
			local_PetEquipEvent = PetEquipEvent,
			local_PetEquipType = PetEquipType,
			goods_model = GoodsModel.GetInstance(),
			local_PetEquipWholeType = PetEquipWholeType,
			local_WordManager = WordManager,
			local_Util = Util,
			outward_base_model = OutWardBaseModel.GetInstance(),
			role_mgr = RoleManager.GetInstance(),
			local_JSON = JSON,
			common_mgr = CommonManager.GetInstance(),
			red_dot_mgr = RedDotManager.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_ModuleType = ModuleType,
			_cfg_dic_ = {},
			_cache_dic_ = {},
			_star_max_dic_ = {},
			_equip_dic_ = {}


		this.InitCfg = () => {
			this.CreateStarMaxDic()
			_cfg_dic_["config_pet_equip_stage"] = Config.PRELOAD_SERVER_CONFIG.config_pet_equip_stage
			_cfg_dic_["config_pet_equip_star"] = Config.PRELOAD_SERVER_CONFIG.config_pet_equip_star
			_cfg_dic_["config_pet_equip_goods"] = Config.PRELOAD_SERVER_CONFIG.config_pet_equip_goods

			this.CheckRedStatus(PetEquipType.HORSE)
			this.CheckRedStatus(PetEquipType.PARTNER)
		}

		this.Reset = () => {
			_equip_dic_ = {}
		}

		this.CreateStarMaxDic = () => {
			_star_max_dic_ = PetEquipStarMaxDic
		}

		this.SetPetEquipInfo = (scmd?) => {
			_equip_dic_[scmd.type_id] = scmd
			this.CheckRedStatus(scmd.type_id)
			this.Fire(local_PetEquipEvent.UPDATE_INFO, scmd.type_id)
		}

		this.GetPetEquipInfo = (type?) => {
			return _equip_dic_[type]
		}

		this.GetPetEquipData = (type?, goods_id?) => {
			let info = this.GetPetEquipInfo(type)
			if (!info) {
				return
			}
			for (let data of info.pet_equip_list) {
				if (data.goods_id == goods_id) {
					return data
				}
			}
		}

		this.GetMaxData = (type?, pos?) => {
			return _star_max_dic_[`${type}@${pos}`]
		}

		this.GetLvData = (type_id?, pos?, pos_lv?, pet_equip_pos_lv_cfg?) => {
			let key = `${type_id}@${pos}@${pos_lv}`
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_pet_equip_pos_lv.name, key, false, pet_equip_pos_lv_cfg)
			return cfg
		}

		this.GetStarData = (type_id?, pos?, star?) => {
			let key = `${type_id}@${pos}@${star}`
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_pet_equip_star.name, key, false, _cfg_dic_["config_pet_equip_star"])
			return cfg
		}

		this.GetStageData = (type_id?, pos?, stage?) => {
			let key = `${type_id}@${pos}@${stage}`
			let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_pet_equip_stage.name, key, false, _cfg_dic_["config_pet_equip_stage"])
			return c
		}

		this.GetGoodsData = (type_id?) => {
			return _cfg_dic_["config_pet_equip_goods"][type_id]
		}

		this.GetWholeDataTwo = (type?, wtype?) => {
			let lv = this.GetAllLv(type, wtype)
			if (type == local_PetEquipType.PARTNER) {
				wtype = wtype + 3
			}
			let [cur_data, next_data] = EquipModel.GetInstance().GetWholeAwardCfg(wtype, lv)
			return [cur_data, next_data]
		}

		this.GetLvDataByExp = (type?, pos?, exp?, edata?, pet_equip_pos_lv_cfg?) => {
			let sdata = this.GetStageData(type, pos, edata.stage)
			let lv = edata.pos_lv
			let ldata = this.GetLvData(type, pos, lv, pet_equip_pos_lv_cfg)
			let re_exp = exp - ldata.exp
			while (re_exp >= 0) {
				lv++
				ldata = this.GetLvData(type, pos, lv, pet_equip_pos_lv_cfg)
				if (lv >= sdata.limit_pos_lv) break
				if (re_exp < ldata.exp) break
				re_exp -= ldata.exp
			}

			return ldata
		}

		//获取背包物品
		this.GetBagGoods = (type?) => {
			let list = []
			if (type == local_PetEquipType.HORSE) {
				return list.concat(goods_model.horse_bag_goods_list)
			} else if (type == local_PetEquipType.PARTNER) {
				return list.concat(goods_model.partner_bag_goods_list)
			}
		}

		//获取背包物品
		this.GetTypeBagGoodDic = (type?) => {
			if (type == local_PetEquipType.HORSE) {
				return goods_model.horse_bag_type_dic
			} else if (type == local_PetEquipType.PARTNER) {
				return goods_model.partner_bag_type_dic
			}
		}

		//获取背包物品
		this.GetPetEquipGoodOne = (type?, goods_id?) => {
			let data
			if (!goods_id) {
				return data
			}
			if (type == local_PetEquipType.HORSE) {
				data = goods_model.horse_bag_goods_dic[goods_id]
			} else if (type == local_PetEquipType.PARTNER) {
				data = goods_model.partner_bag_goods_dic[goods_id]
			}
			if (!data) {
				let edata = this.GetPetEquipData(type, goods_id)
				if (!edata) {
					return
				}
				data = this.GetWearEquipInfo(type, edata.pos_id)
			}
			return data
		}

		//根据装备类型从装备背包获取装备(包括升级物品)
		this.GetBagGoodsByType = (type?, stype?) => {
			let list = []
			let goods = this.GetBagGoods(type)
			for (let info of goods) {
				if (info.equip_type == stype || info.subtype > local_PetEquipDefine.EQUIP_POS_COUNT) {
					list.push(info)
				}
			}
			return list
		}

		//从背包获取装备
		this.GetBagGoodsOnlyEquip = (type?) => {
			let list = []
			let goods = this.GetBagGoods(type)
			for (let info of goods) {
				if (info.subtype <= local_PetEquipDefine.EQUIP_POS_COUNT) {
					list.push(info)
				}
			}
			return list
		}

		//根据装备类型从装备背包获取装备
		this.GetBagEquipsByType = (type?, pos?) => {
			let dic = this.GetTypeBagGoodDic(type)
			return dic[pos] || {}
		}

		//获取当前身上装备某件装备
		this.GetWearEquipInfo = (type?, equip_type?) => {
			equip_type = equip_type - 1
			if (type == local_PetEquipType.HORSE) {
				return goods_model.wear_horse_list[equip_type]
			} else if (type == local_PetEquipType.PARTNER) {
				return goods_model.wear_partner_list[equip_type]
			}
		}

		//获取当前身上所有装备
		this.GetWearEquipInfos = (type?) => {
			if (type == local_PetEquipType.HORSE) {
				return goods_model.wear_horse_list
			} else if (type == local_PetEquipType.PARTNER) {
				return goods_model.wear_partner_list
			}
		}

		this.GetAllLv = (type?, wtype?) => {
			let pinfo = this.GetPetEquipInfo(type)
			if (!pinfo) {
				return 0
			}
			let key = this.GetKeyByType(wtype)
			let lv = 0
			for (let info of pinfo.pet_equip_list) {
				lv = lv + info[key]
			}
			return lv
		}

		this.GetKeyByType = (wtype?) => {
			if (local_PetEquipWholeType.STAGE == wtype) {
				return "stage"
			} else if (local_PetEquipWholeType.STAR == wtype) {
				return "star"
			} else if (local_PetEquipWholeType.STREN == wtype) {
				return "pos_lv"
			}
		}

		this.GetAttrStr = (attr_list?, color?) => {
			let str = ""
			if (!attr_list) {
				return str
			}
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				let line = i + 1 != attr_list.length ? "\n" : ""
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				let name = local_WordManager.GetProperties(attr[0])
				str = str + `${name}：${local_Util.HtmlColorTxt(`+${value}`, color)}` + line
			}
			return str
		}

		//不做升级添加额外属性的判断
		this.GetAddAttrStr = (attr_list?, nattr_list?, color?) => {
			let str = ""
			if (!attr_list) {
				return str
			}
			if (!nattr_list || nattr_list.length < 1) {
				return this.GetAttrStr(attr_list, color)
			}
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				let nattr = nattr_list[i]
				let line = i + 1 != attr_list.length ? "\n" : ""
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				let nvalue = local_WordManager.ConvertToPercentValue(nattr[0], nattr[1])
				let name = local_WordManager.GetProperties(attr[0])
				let val_str = local_Util.HtmlColorTxt(`+${value}`, color)
				nvalue = nvalue - value
				let nval_str = local_Util.HtmlColorTxt(`  +${nvalue}`, Enum_ColorUtil_Light.GREEN)
				str = str + `${name}：${val_str} ${nval_str}` + line
			}

			return str
		}

		this.GetAddAttrList = (attr_list?, nattr_list?) => {
			let list = []
			if (!attr_list) {
				return list
			}
			if (!nattr_list || nattr_list.length < 1) {
				return attr_list
			}
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				let nattr = nattr_list[i]
				list.push([attr[0], attr[1], nattr[1]])
			}
			return list
		}

		this.GetStrenGoods = (type?, data?, empty?) => {
			let list = []
			list = this.AddEmptyToList(list, local_PetEquipDefine.BAG_DEFAULT_COUNT)
			if (!data) {
				return list
			}
			let gdata = this.GetGoodsData(data.type_id)
			if (!gdata) {
				return list
			}
			list = this.GetBagGoodsOnlyEquip(type)
			let wear
			let tlist = []
			for (let info of list) {
				wear = this.GetWearEquipInfo(type, info.equip_type)
				if (!wear || wear.rating < info.rating) {
					continue
				}
				tlist.push(info)
				info._is_select = false
			}
			if (empty) {
				tlist = this.AddEmptyToList(tlist, local_PetEquipDefine.BAG_DEFAULT_COUNT)
			}
			return tlist
		}

		this.GetStarGoods = (type?, data?, empty?) => {
			let list = []
			list = this.AddEmptyToList(list, local_PetEquipDefine.BAG_DEFAULT_COUNT)
			let edata = this.GetPetEquipData(type, data.goods_id)
			if (!edata) {
				return list
			}
			list = []
			let goods = this.GetBagGoodsByType(type, data.equip_type)
			let sdata, own, type_id, can_push, cost_list
			for (let info of goods) {
				if (info.subtype > local_PetEquipDefine.EQUIP_POS_COUNT) {
					let mdata = this.GetMaxData(type, data.equip_type)
					if (info.subtype == 5) {
						if (edata.stage >= mdata.stage) {
							continue
						}
						sdata = this.GetStageData(type, edata.pos_id, edata.stage)
						if (!sdata) {
							continue
						}
						cost_list = this.GetJsonCacheAndSet(`stage@${type}@${edata.pos_id}@${edata.stage}`, sdata.cost_list)
					} else if (info.subtype == 6) {
						if (edata.star >= mdata.star) {
							continue
						}
						sdata = this.GetStarData(type, edata.pos_id, edata.star)
						if (!sdata) {
							continue
						}
						cost_list = this.GetJsonCacheAndSet(`star@${type}@${edata.pos_id}@${edata.star}`, sdata.cost_list)
					}
					can_push = true
					for (let cost of cost_list) {
						[type_id] = goods_model.GetMappingTypeId(cost[0], cost[1])
						if (Number(type_id) != info.type_id) {
							can_push = false
							continue
						}
						own = goods_model.GetTypeGoodsNum(type_id)
						if (own < Number(cost[2])) {
							can_push = false
						}
					}
					if (can_push) {
						info._is_select = false
						list.push(info)
					}
				} else {
					if (info.equipStar > edata.star || info.equipStage > edata.stage) {
						info._is_select = false
						list.push(info)
					}
				}
			}
			if (empty) {
				list = this.AddEmptyToList(list, local_PetEquipDefine.BAG_DEFAULT_COUNT)
			}
			return list
		}

		this.AddEmptyToList = (list?, count?) => {
			let empty = { type_id: false }
			for (let i = list.length; i < count; i++) {
				list.push(empty)
			}
			return list
		}

		this.DicToList = (dic?, list?) => {
			list = list || []
			for (let key in dic) {
				list.push(dic[key])
			}
			return list
		}

		//避免2个数组属性不一样
		this.GetAttrListByTwo = (mAttrs?, nAttrs?) => {
			let dic = {}
			let list = []
			for (let attr of mAttrs) {
				dic[attr[0]] = attr[1]
			}
			for (let attr of nAttrs) {
				dic[attr[0]] = dic[attr[0]] ? dic[attr[0]] + attr[1] : attr[1]
			}
			for (let key in dic) {
				list.push([Number(key), dic[key]])
			}
			return list
		}

		//参数为多个属性列表(不能少于2个)
		this.GetAttrListByMultList = (...lists) => {
			if (!lists || lists.length < 2) {
				return []
			}
			let dic = {}
			let list = []
			for (let attr of lists[0]) {
				dic[attr[0]] = attr[1]
			}
			lists.splice(0, 1)
			for (let attr_list of lists) {
				for (let attr of attr_list) {
					dic[attr[0]] = dic[attr[0]] ? dic[attr[0]] + attr[1] : attr[1]
				}
			}
			for (let key in dic) {
				list.push([key, dic[key]])
			}
			return list
		}

		this.GetShowItemClass = (type?, red_type?) => {
			if (type == local_PetEquipType.HORSE) {
				if (red_type == 2) {
					return window["PEHStrenShowItem"]
				} else if (red_type == 3) {
					return window["PEHStarShowItem"]
				}
			} else if (type == local_PetEquipType.PARTNER) {
				if (red_type == 2) {
					return window["PEPStrenShowItem"]
				} else if (red_type == 3) {
					return window["PEPStarShowItem"]
				}
			}
		}

		this.CheckCanEquip = (type?, type_id?) => {
			let data = outward_base_model.outward_data_list[type]
			if (!data) {
				return false
			}
			let gdata = this.GetGoodsData(type_id)
			if (!gdata) {
				return false
			}
			let role_lv = role_mgr.GetMainRoleVo().level
			return data.stage >= gdata.pet_stage_limit && role_lv >= gdata.player_lv_limit
		}

		this.GetPosName = (type?, subtype?) => {
			let key = `${type}@${subtype}`
			let cfg = config_preload_server.GoodsSubtype[key]
			return cfg ? cfg.subtype_name : "通用"
		}

		this.PetEquipTypeName = (type?) => {
			if (type == local_PetEquipDefine.HORSE_TYPE_ID) {
				return "坐骑"
			} else if (type == local_PetEquipDefine.PARTNER_TYPE_ID) {
				return "侍魂"
			}
		}

		this.GetGoodTypeByType = (type?) => {
			if (type == local_PetEquipType.HORSE) {
				return local_PetEquipDefine.HORSE_TYPE_ID
			} else if (type == local_PetEquipType.PARTNER) {
				return local_PetEquipDefine.PARTNER_TYPE_ID
			}
		}

		this.GetTypeByGoodType = (gType?) => {
			if (gType == local_PetEquipDefine.HORSE_TYPE_ID) {
				return local_PetEquipType.HORSE
			} else if (gType == local_PetEquipDefine.PARTNER_TYPE_ID) {
				return local_PetEquipType.PARTNER
			}
		}

		this.GetAllAttrList = (type?, goods_id?, pet_equip_pos_lv_cfg?) => {
			let edata = this.GetPetEquipData(type, goods_id)
			if (!edata) {
				return []
			}
			let lvData = this.GetLvData(type, edata.pos_id, edata.pos_lv, pet_equip_pos_lv_cfg)
			let starData = this.GetStarData(type, edata.pos_id, edata.star)
			let stageData = this.GetStageData(type, edata.pos_id, edata.stage)
			let lv_list = lvData && local_JSON.parse(lvData.attr_list) || []
			let star_list = local_JSON.parse(starData.attr_list)
			let stage_list = local_JSON.parse(stageData.attr_list)
			let attr_list = this.GetAttrListByMultList(lv_list, star_list, stage_list)
			return attr_list
		}

		this.GetJsonCacheAndSet = (key?, json?) => {
			if (!json) {
				return
			}
			let cache = this.GetCache(key)
			if (!cache) {
				cache = local_JSON.parse(json)
				this.SetCache(key, cache)
			}
			return cache
		}

		this.GetCache = (key?) => {
			return _cache_dic_[key]
		}

		this.SetCache = (key?, value?) => {
			_cache_dic_[key] = value
		}

		this.GetGoodsPower = (type?, data?) => {
			let star_data = this.GetStarData(type, data.pos_id, data.star)
			let stage_data = this.GetStageData(type, data.pos_id, data.stage)
			let star_attr = local_JSON.parse(star_data.attr_list)
			let stage_attr = local_JSON.parse(stage_data.attr_list)
			let attr_list = this.GetAttrListByTwo(star_attr, stage_attr)
			let power = Util.CalAttrPower(attr_list, false)
			return power
		}

		this.GetRedListByType = (type?) => {
			if (type == local_PetEquipType.HORSE) {
				return PetHorseRedList
			} else if (type == local_PetEquipType.PARTNER) {
				return PetPartnerRedList
			}
		}

		this.CheckRedStatus = (type?) => {
			if (!_cfg_dic_["config_pet_equip_stage"] || !_cfg_dic_["config_pet_equip_star"] || !_cfg_dic_["config_pet_equip_goods"]) {
				return
			}
			if (!common_mgr.CheckFuncOpenState("PetEquipBaseView", true)) {
				return
			}
			if (type == local_PetEquipType.HORSE) {
				if (!common_mgr.CheckFuncOpenState("HorseComponentView", true)) {
					return
				}
				if (role_mgr.GetMainRoleVo().level < local_PetEquipDefine.HORSE_OPEN_LV) {
					return
				}
			} else if (type == local_PetEquipType.PARTNER) {
				if (!common_mgr.CheckFuncOpenState("PartnerComponentView", true)) {
					return
				}
				if (role_mgr.GetMainRoleVo().level < local_PetEquipDefine.PARTNER_OPEN_LV) {
					return
				}
			}
			this.CheckEquipRedStatus(type)
			this.CheckStrenRedStatus(type)
			this.CheckStarRedStatus(type)
			this.Fire(local_PetEquipEvent.UPDATE_RED_STATUS, type)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
		}

		this.SetRedStatus = (mType?, id?, active?) => {
			red_dot_mgr.SetRedStatus(mType, id, active)
		}

		this.GetRedStatus = (mType?, id?) => {
			return red_dot_mgr.CheckRedStatus(mType, id)
		}

		this.GetAllRedStatus = () => {
			let red = red_dot_mgr.CheckRedStatusMultModule(PetHorseRedList)
			if (!red) {
				red = red_dot_mgr.CheckRedStatusMultModule(PetPartnerRedList)
			}
			return red
		}

		//更好装备/等级限制/评分
		this.CheckEquipRedStatus = (type?) => {
			let mType = this.GetRedIDByType(type, 1)
			red_dot_mgr.ClearRedStatus(mType)

			let wears = this.GetWearEquipInfos(type)
			let dic = this.GetTypeBagGoodDic(type)
			let role_lv = role_mgr.GetMainRoleVo().level
			let data = outward_base_model.outward_data_list[type]
			let stage = data ? data.stage : 0
			for (let i = 1; i <= local_PetEquipDefine.EQUIP_POS_COUNT; i++) {
				let wear = wears[i - 1]
				let list = dic[i]
				if (!list) continue
				for (let equip of list) {
					if (wear) {
						let gdata = this.GetGoodsData(equip.type_id)
						if (role_lv < gdata.player_lv_limit) continue
						if (stage < gdata.pet_stage_limit) continue
						if (equip.rating <= wear.rating) continue
						this.SetRedStatus(mType, i, true)
						RedDotController.ins.add(PetEquipRedKeyMap[mType] + i, PetEquipTypeRedKeyMap[type])
						RedDotController.ins.up(PetEquipRedKeyMap[mType] + i, 1)
						break
					} else {
						let gdata = this.GetGoodsData(equip.type_id)
						if (role_lv < gdata.player_lv_limit) continue
						if (stage < gdata.pet_stage_limit) continue
						this.SetRedStatus(mType, i, true)
						RedDotController.ins.add(PetEquipRedKeyMap[mType] + i, PetEquipTypeRedKeyMap[type])
						RedDotController.ins.up(PetEquipRedKeyMap[mType] + i, 1)
					}
				}
			}

		}

		//满足强化条件/满级
		this.CheckStrenRedStatus = (type?) => {
			let mType = this.GetRedIDByType(type, 2)
			red_dot_mgr.ClearRedStatus(mType)
			let wears = this.GetWearEquipInfos(type)
			if (!wears) {
				return
			}
			for (let info of wears) {
				if (!info) {
					continue
				}
				let edata = this.GetPetEquipData(type, info.goods_id)
				if (!edata) {
					continue
				}
				let stage_data = this.GetStageData(type, edata.pos_id, edata.stage)
				if (stage_data.limit_pos_lv <= edata.pos_lv) {
					continue
				}
				let red = this.GetStrenGoods(type, info, false).length > 0
				this.SetRedStatus(mType, info.equip_type, red)
				RedDotController.ins.add(PetEquipRedKeyMap[mType] + info.equip_type, PetEquipTypeRedKeyMap[type])
				RedDotController.ins.up(PetEquipRedKeyMap[mType] + info.equip_type, red ? 1 : 0)
			}
		}

		//能升阶/星
		this.CheckStarRedStatus = (type?) => {
			let mType = this.GetRedIDByType(type, 3)
			red_dot_mgr.ClearRedStatus(mType)
			let wears = this.GetWearEquipInfos(type)
			if (!wears) {
				return
			}
			for (let info of wears) {
				if (info) {
					let red = this.GetStarGoods(type, info, false).length > 0
					this.SetRedStatus(mType, info.equip_type, red)
					RedDotController.ins.add(PetEquipRedKeyMap[mType] + info.equip_type, PetEquipTypeRedKeyMap[type])
					RedDotController.ins.up(PetEquipRedKeyMap[mType] + info.equip_type, red ? 1 : 0)
				}
			}
		}

		//类型/ 红点类型
		this.GetRedIDByType = (type?, subtype?) => {
			if (type == local_PetEquipType.HORSE) {
				if (subtype == 1) {
					return local_ModuleType.PEH_EQUIP
				} else if (subtype == 2) {
					return local_ModuleType.PEH_STREN
				} else if (subtype == 3) {
					return local_ModuleType.PEH_STAR
				}
			} else if (type == local_PetEquipType.PARTNER) {
				if (subtype == 1) {
					return local_ModuleType.PEP_EQUIP
				} else if (subtype == 2) {
					return local_ModuleType.PEP_STREN
				} else if (subtype == 3) {
					return local_ModuleType.PEP_STAR
				}
			}
		}


	}

	public static GetInstance() {
		if (!PetEquipModel.Instance) {
			PetEquipModel.Instance = new PetEquipModel()
		}
		return PetEquipModel.Instance
	}

}

window["PetEquipModel"] = PetEquipModel