import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
// import { StarEquipMainView } from "../godBefall/StarEquipMainView";
import { RoleManager } from "./RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { EventDispatcher } from "../util/EventDispatcher";
import { Util } from "../util/Util";
import { EquipModel } from "./EquipModel";
import { GoodsModel } from "./GoodsModel";
import { MainFunc } from "./MainUIModel";
import { SkillUIModel } from "./SkillUIModel";
import { CompositeModel } from "./CompositeModel";

export const GodBefallDefine = {
	EQUIP_COUNT: 4,     //装备数量
	STAR_COUNT: 5,      //星数
	EQUIP_TYPE: 70,     //装备类型
	GOOD_TYPE: 71,      //材料类型
	UP_SUBTYPE: 1,      //升级子类型
	STAGE_SUBTYPE: 2,   //升阶子类型
	COM_SUBTYPE: 3,     //合成子类型
	OPEN_LV: 400,       //开启等级
	COM_TYPE_ID: 11,    //合成类型id
}
window["GodBefallDefine"] = GodBefallDefine
export const GodBefallEvent = {
	"REQUEST_PROTO": "GBEvent.REQUEST_PROTO",
	"UPDATE_GOD_VO": "GBEvent.UPDATE_GOD_VO",
	"KEEP_TIME": "GBEvent.KEEP_TIME",
	"UPDATE_BATTLE_ID": "GBEvent.UPDATE_BATTLE_ID",
	"ACTIVE_SUCCESS": "GBEvent.ACTIVE_SUCCESS",
	"UPGRADE_SUCCESS": "GBEvent.UPGRADE_SUCCESS",
	"UPGRADE_FAIL": "GBEvent.UPGRADE_FAIL",
	"STAR_SUCCESS": "GBEvent.STAR_SUCCESS",
	"UPDATE_GOODS_RED": "GBEvent.UGR",
	"COM_SUCCESS": "GBEvent.COM_SUCCESS",
	"UPDATE_NO_POWER": "GBEvent.UPDATE_NO_POWER",
	"REQUEST_OTHER_PROTO": "REQUEST_OTHER_PROTO",
	"UPDATE_COMPOSE_LIST": "UPDATE_COMPOSE_LIST",
	"UPDATE_STRONG_GOD_VIEW": "UPDATE_STRONG_GOD_VIEW",
	"UPDATE_STRONG_EXP": "UPDATE_STRONG_EXP",
	"AUTO_SELECT_ITEM": "AUTO_SELECT_ITEM",
	"UPDATE_AUTO_COMPOSE_VIEW": "UPDATE_AUTO_COMPOSE_VIEW",
	"STRONG_SUCCESS": "STRONG_SUCCESS",
	"STOP_GOD_SOUND": "STOP_GOD_SOUND"
}
window["GodBefallEvent"] = GodBefallEvent
export const GodBefallRedList = [
	ModuleType.GOD_ACTIVE,
	ModuleType.GOD_LV,
	ModuleType.GOD_STAGE,
	ModuleType.GOD_STAR,
]
window["GodBefallRedList"] = GodBefallRedList
export const GodBefallRedSpecList = [
	ModuleType.GOD_EQUIP,
	ModuleType.GOD_QUICK_COM
]
window["GodBefallRedSpecList"] = GodBefallRedSpecList
export class GodBefallModel extends EventDispatcher {
	static Instance: GodBefallModel;
	public _lv_goods_list;
	public _cur_data;       //主界面选中降神配置标志
	public _cur_battle_id;  //出战降神id
	public _com_god_id;     //用于合成界面默认标签
	public _scene_list: Array<any>;     //禁止变身场景数组
	public _com_mark = false;           //快速合成提示标志
	public check_box_dir = {}
	public bag_item_dic = {}
	public can_add = true
	god_skill_list = {}
	//function
	InitCfg
	Reset
	SetDataDic
	GetKVData
	GetGodData
	GetLvData
	GetStarData
	GetStageData
	GetEquipData
	GetStarLimitData
	SetGodInfo
	GetGodInfo
	SetGodVoInDic
	GetGodVoInDic
	SetGodTime
	GetGodTime
	GetAllAttrListByVo
	GetAttrListAndAdd
	GetSkillList
	GetTalentList
	GetEquipList
	GetEquipInfo
	CheckEquipColorCanStar
	CheckEquipCanReplaceOne
	CheckEquipCanReplace
	GetMaxStarCount
	GetGoodsByBagCond
	GetGodEquipTypeName
	GetGodEquipPosName
	GetCurCanSetEquip
	CheckCompositeData
	GetCompositeData
	CheckEquipCanStar
	GetAttrStr
	StartTimer
	ClearTimer
	GetTimerData
	GetJsonCacheAndSet
	GetCache
	SetCache
	DicToList
	CheckGodCanActive
	CheckGodCanUp
	CheckGodCanStage
	CheckGodCanStar
	CheckGodAllPosReplace
	CheckGodCanReplace
	CheckGodCanCom
	CheckGodCanComOne
	CheckAllResStatus
	CheckQuickComRedStatus
	CheckEquipRedStatus
	CheckActiveRedStatus
	CheckLvRedStatus
	CheckStageRedStatus
	CheckStarRedStatus
	CheckOneGodRedStatus
	SetAnyRedStatus
	GetRedStatus
	GetAllRedStatus
	GetGodSepcRedStatus
	GetGodSepcRedStatusAll
	CheckOpenShenGe
	CheckCanAutoCompose
	SetStrongGodDic
	GetStrongGodDic
	GetGodTypeEquipList
	CheckAutoComposeRed
	GetAutoComposeRed
	CheckTabRed
	CheckShenGeRed
	GetShenGeRed
	RefreshShenGeRed
	GetGodSkillId
	LoadGodSkills
	ClearGodSkillList
	CheckAndGetMainRoleGodAllSkill
	CleanGodInfo

	constructor() {
		super()
		// this.InitCfg()
		let config_preload_server = Config.PRELOAD_SERVER_CONFIG,
			local_Config = Config,
			local_JSON = JSON,
			local_GodBefallEvent = GodBefallEvent,
			goods_model = GoodsModel.GetInstance(),
			equip_model = EquipModel.GetInstance(),
			local_Number = Number,
			local_GodBefallDefine = GodBefallDefine,
			local_WordManager = WordManager,
			// local_egret = egret,
			local_ModuleType = ModuleType,
			common_mgr = CommonManager.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			update_function_icon_red_event = EventName.REFRESH_FUNCTION_ICON_RED_DOT,
			red_dot_mgr = RedDotManager.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_GodBefallRedSpecList = GodBefallRedSpecList,
			_cfg_dic_ = {},
			_cache_dic_ = {},
			_timer_dic_ = {},
			_cur_rule_id_,  //当前合成id/记录第一层材料
			_lv_goods_dic_,
			_god_dic_,
			_god_info_,
			_god_time_,
			strong_god_dic = {},
			auto_compose_red = false,
			shen_ge_red = false
		this.InitCfg = () => {

			// ResManager.GetInstance().LockLoadModuleConfig("GodBefallModel")


			// let p1 = Util.LoadServerConfig("config_god_kv"),
			//     p2 = Util.LoadServerConfig("config_god"),
			//     p3 = Util.LoadServerConfig("config_god_lv"),
			//     p4 = Util.LoadServerConfig("config_god_star"),
			//     p5 = Util.LoadServerConfig("config_god_stage"),
			//     p6 = Util.LoadServerConfig("config_god_equip"),
			//     p7 = Util.LoadServerConfig("config_god_star_up_limit");


			// [
			//     _cfg_dic_["config_god_kv"],
			//     _cfg_dic_["config_god"],
			//     _cfg_dic_["config_god_lv"],
			//     _cfg_dic_["config_god_star"],
			//     _cfg_dic_["config_god_stage"],
			//     _cfg_dic_["config_god_equip"],
			//     _cfg_dic_["config_god_star_up_limit"]
			// ] = await Promise.all([p1, p2, p3, p4, p5, p6, p7])
			// ResManager.GetInstance().UnlockLoadModuleConfig("GodBefallModel")

			// _cfg_dic_["config_god_kv"] = Config.PRELOAD_SETVER_CONFIG.config_god_kv
			_cfg_dic_["config_god"] = config_preload_server.config_god
			// _cfg_dic_["config_god_lv"] = Config.PRELOAD_SETVER_CONFIG.config_god_lv
			// _cfg_dic_["config_god_star"] = Config.PRELOAD_SETVER_CONFIG.config_god_star
			// _cfg_dic_["config_god_stage"] = Config.PRELOAD_SETVER_CONFIG.config_god_stage
			_cfg_dic_["config_god_equip"] = config_preload_server.config_god_equip
			// _cfg_dic_["config_god_star_up_limit"] = Config.PRELOAD_SETVER_CONFIG.config_god_star_up_limit
			this.SetDataDic()
		}



		this.Reset = () => {
			_god_dic_ = {}
			// _god_info_ = undefined
			_god_time_ = undefined
			this._com_mark = false
			this._cur_battle_id = 0
		}

		this.SetDataDic = () => {
			_lv_goods_dic_ = {}
			let config_god_kv = Config.PRELOAD_SERVER_CONFIG.config_god_kv
			let kvdata = this.GetKVData("update_lv_goods", config_god_kv)
			let list = local_JSON.parse(kvdata)
			this._lv_goods_list = list
			for (let vo of list) {
				_lv_goods_dic_[vo[0]] = local_Number(vo[1])
			}
			kvdata = this.GetKVData("forbid_scene_type", config_god_kv)
			this._scene_list = local_JSON.parse(kvdata)
		}

		this.GetKVData = (key, config_god_kv) => {
			return config_god_kv && config_god_kv[key].values
		}

		this.GetGodData = (id) => {
			return _cfg_dic_["config_god"][id]
		}

		this.GetLvData = (id, lv, config_god_lv) => {
			return config_god_lv && config_god_lv[`${id}@${lv}`]
		}

		this.GetStarData = (id, star, config_god_star) => {
			return config_god_star && config_god_star[`${id}@${star}`]
		}

		this.GetStageData = (id, stage, config_god_stage) => {
			return config_god_stage && config_god_stage[`${id}@${stage}`]
		}

		this.GetEquipData = (type_id) => {
			return _cfg_dic_["config_god_equip"][type_id]
		}

		this.GetStarLimitData = (star, config_god_star_up_limit) => {
			return config_god_star_up_limit && config_god_star_up_limit[star]
		}

		///////////////////////////////////////////////////////////////////

		this.SetGodInfo = (info) => {
			_god_info_ = info
			for (let vo of info.god_list) {
				_god_dic_[vo.god_id] = vo
				if (vo.is_battle) {
					this._cur_battle_id = vo.god_id
					SkillUIModel.GetInstance().PreLoadSkillEffectRes(null, vo.god_id)
					this.Fire(local_GodBefallEvent.UPDATE_BATTLE_ID, vo.god_id)
				}
				vo.equip_dic = {}
				for (let info of vo.equip_list) {
					vo.equip_dic[info.pos] = info
				}
			}
			this.CheckAllResStatus()
			this.ChangeVar("_god_info", info, false, true)
		}

		this.GetGodInfo = () => {
			return _god_info_
		}

		this.SetGodVoInDic = (id, data) => {
			res_mgr.LoadGameConfig(this, "config_equip_attr", false, undefined, (cfg) => {
				let vo = this.GetGodVoInDic(id)
				if (!vo) {
					let rinfo = this.GetGodInfo()
					if (rinfo) {
						data.equip_dic = {}
						rinfo.god_list.push(data)
						_god_dic_[id] = data
					} else {
						this.Fire(local_GodBefallEvent.REQUEST_PROTO, 44000)
					}
				} else {
					for (let key in data) {
						vo[key] = data[key]
					}
					vo.equip_dic = {}
					for (let info of vo.equip_list) {
						vo.equip_dic[info.pos] = info
					}
				}
				//目前升级会影响激活
				this.CheckActiveRedStatus()
				this.CheckOneGodRedStatus(id, cfg)
				this.Fire(local_GodBefallEvent.UPDATE_GOD_VO, id)
				res_mgr.DestoryGameConfig(this, "config_equip_attr", false)
			})
		}

		this.GetGodVoInDic = (id) => {
			return _god_dic_[id]
		}

		this.SetGodTime = (info) => {
			_god_time_ = info
		}

		this.GetGodTime = () => {
			return _god_time_
		}

		this.GetAllAttrListByVo = (id, vo, config_god_lv, config_god_star, config_god_stage) => {
			let grade = 0, lv = 0, star = 0
			let sgdata = this.GetStageData(id, vo ? vo.grade : grade, config_god_stage)
			let stdata = this.GetStarData(id, vo ? vo.star : star, config_god_star)
			let lvdata = this.GetLvData(id, vo ? vo.lv : lv, config_god_lv)
			let sgAttrs = local_JSON.parse(sgdata.attr)
			let stAttrs = local_JSON.parse(stdata.attr)
			let lvAttrs = local_JSON.parse(lvdata.attr)
			let nlvdata = vo ? this.GetLvData(id, vo.lv + 1, config_god_lv) : undefined
			let nlvAttrs = nlvdata ? local_JSON.parse(nlvdata.attr) : undefined
			let up_dic = {}
			if (nlvdata) {
				for (let i = 0; i < nlvAttrs.length; i++) {
					up_dic[nlvAttrs[i][0]] = nlvAttrs[i][1] - lvAttrs[i][1]
				}
			}
			let dic = {}
			for (let i = 0; i < sgAttrs.length; i++) {
				dic[sgAttrs[i][0]] = sgAttrs[i][1]
			}
			for (let i = 0; i < stAttrs.length; i++) {
				let attr = dic[stAttrs[i][0]]
				dic[stAttrs[i][0]] = attr ? attr + stAttrs[i][1] : stAttrs[i][1]
			}
			for (let i = 0; i < lvAttrs.length; i++) {
				let attr = dic[lvAttrs[i][0]]
				dic[lvAttrs[i][0]] = attr ? attr + lvAttrs[i][1] : lvAttrs[i][1]
			}
			let list = []
			for (let key in dic) {
				let attr = [key, dic[key], up_dic[key]]
				list.push(attr)
			}
			return list
		}

		this.GetAttrListAndAdd = (clist, nlist) => {
			if (!nlist || nlist.length < 1) return clist
			let len = Math.max(clist.length, nlist.length)
			for (let i = 0; i < len; i++) {
				clist[i] = clist[i] || [nlist[i][0], 0]
				clist[i][2] = nlist[i][1] - clist[i][1]
			}
			return clist
		}

		this.GetSkillList = (id?, grade?) => {
			let data = this.GetGodData(id)
			if (!data) {
				return {}
			}
			let god_skill = this.GetJsonCacheAndSet("skill@" + id, data.skill)
			grade = grade + 1
			if (grade >= god_skill.length) {
				grade = god_skill.length - 1
			}

			let grade_list = god_skill[grade][1]
			let list = []
			if (grade_list) {
				for (let _tmpi = 0; _tmpi < grade_list.length; _tmpi++) {
					var skill_id = grade_list[_tmpi]
					// [ts2lua]vo下标访问可能不正确
					let vo = []
					vo["god_id"] = id
					vo["skill_id"] = skill_id
					vo["is_skill"] = true
					if (_tmpi == grade_list.length - 1) {
						vo["is_tag_skill"] = true
					}
					list.push(vo)
				}
			}
			return list
		}

		this.GetTalentList = (id) => {
			let data = this.GetGodData(id)
			if (!data) return []
			let list = local_JSON.parse(data.talent)
			for (let vo of list) {
				vo["god_id"] = id
			}
			return list
		}

		this.GetEquipList = (vo) => {
			let list = []
			if (vo) {
				for (let data of vo.equip_list) {
					data.god_id = vo.god_id
					list[data.pos - 1] = data
				}
				for (let i = 0; i < local_GodBefallDefine.EQUIP_COUNT; i++) {
					list[i] = list[i] || { empty: true, pos: i + 1, god_id: vo.god_id }
				}
			} else {
				for (let i = 0; i < local_GodBefallDefine.EQUIP_COUNT; i++) {
					list[i] = { unlock: true, pos: i + 1 }
				}
			}
			return list
		}

		this.GetEquipInfo = (goods_id) => {
			let dic = goods_model.wear_god_dic
			return dic[goods_id]
		}

		this.CheckEquipColorCanStar = (star, equip_list, config_god_star_up_limit) => {
			if (equip_list.length < local_GodBefallDefine.EQUIP_COUNT) return false
			//判断是否满星
			let data = this.GetStarLimitData(star+1, config_god_star_up_limit)
			if (!data) return false
			for (let vo of equip_list) {
				let info = this.GetEquipInfo(vo.goods_id)
				if (!info) return false
				if (info.color != data.color) return false
				if (equip_model.GetEquipData(info.type_id).star != data.equip_star) return false
			}
			return true
		}

		this.CheckEquipCanReplaceOne = (vo, pos) => {
			if (!vo.equip_dic) return false
			let data = this.GetGodData(vo.god_id)
			let dic = goods_model.god_bag_type_dic
			if (!data) return false
			if (!dic[pos]) return false
			let evo = vo.equip_dic[pos]
			let basic = evo ? this.GetEquipInfo(evo.goods_id) : undefined
			let bpower = basic ? equip_model.GetEquipData(basic.type_id).base_rating : 0
			for (let info of dic[pos]) {
				let edata = this.GetEquipData(info.type_id)
				if (data.color == edata.limit) {
					if (!evo) {
						return true
					} else {
						let apower = equip_model.GetEquipData(info.type_id).base_rating
						if (basic && apower > bpower) return true
					}
				}
			}
			return false
		}

		this.CheckEquipCanReplace = (vo) => {
			if (!vo.equip_dic) return false
			let data = this.GetGodData(vo.god_id)
			let dic = goods_model.god_bag_type_dic
			if (!data) return false
			for (let i = 1; i <= local_GodBefallDefine.EQUIP_COUNT; i++) {
				if (!dic[i]) continue
				let evo = vo.equip_dic[i]
				let basic = evo ? this.GetEquipInfo(evo.goods_id) : undefined
				let bpower = basic ? equip_model.GetEquipData(basic.type_id).base_rating : 0
				for (let info of dic[i]) {
					let edata = this.GetEquipData(info.type_id)
					if (data.color == edata.limit) {
						if (!evo) {
							return true
						} else {
							let apower = equip_model.GetEquipData(info.type_id).base_rating
							if (basic && apower > bpower) return true
						}
					}
				}
			}
			return false
		}

		this.GetMaxStarCount = (id?, config_god_star?) => {
			let star_index = 3
			while (this.GetStarData(id, star_index + 1, config_god_star) != null) {
				star_index = star_index + 1
			}
			return star_index
		}

		this.GetGoodsByBagCond = (color, subtype, god_id) => {
			let list = []
			let bag_list = goods_model.god_bag_list
			let scolor = parseInt((color / 10).toString(), 10)
			let star = color % 10
			for (let info of bag_list) {
				if (color != 99 && info.color != scolor) continue
				let data = this.GetEquipData(info.type_id)
				let edata = equip_model.GetEquipData(info.type_id)
				if (color != 99 && star != edata.star) continue
				if (subtype != 99 && local_Number(data.limit) != subtype) continue
				info._god_id = god_id
				list.push(info)
			}
			list.sort((a, b) => {
				if (a.color != b.color) {
					return b.color - a.color
				} else {
					let astar = equip_model.GetEquipData(a.type_id).star
					let bstar = equip_model.GetEquipData(b.type_id).star
					if (astar != bstar) {
						return bstar - astar
					} else {
						if (a.subtype != b.subtype) {
							return a.subtype - b.subtype
						} else {
							let alimit = this.GetEquipData(a.type_id).limit
							let blimit = this.GetEquipData(b.type_id).limit
							return alimit - blimit
						}
					}
				}
			})
			return list
		}

		this.GetGodEquipTypeName = (god_color) => {
			if (god_color == 3) return "荒原神器"
			else if (god_color == 4) return "信仰神器"
			else if (god_color == 5) return "国津神器"
			else if (god_color == 6) return "天津神器"
		}

		this.GetGodEquipPosName = (pos) => {
			let key = `${local_GodBefallDefine.EQUIP_TYPE}@${pos}`
			let cfg = config_preload_server.GoodsSubtype[key]
			return cfg ? cfg.subtype_name : ""
		}

		//获取当前选择降神符合升星条件的装备
		this.GetCurCanSetEquip = (pos, config_god_star_up_limit) => {
			if (!this._cur_data) return
			let dic = goods_model.god_bag_type_dic
			if (!dic[pos] || dic[pos].length < 1) return
			let data = this._cur_data
			let vo = this.GetGodVoInDic(data.id)
			if (!vo) return
			let ldata = this.GetStarLimitData(vo.star, config_god_star_up_limit)
			let gdata = this.GetGodData(data.id)
			let power = 0
			let max_info
			for (let info of dic[pos]) {
				let edata1 = this.GetEquipData(info.type_id)
				let edata2 = equip_model.GetEquipData(info.type_id)
				if (!edata1 || !edata2) continue
				if (edata1.limit != gdata.color) continue
				if (ldata && info.color == ldata.color && edata2.star == ldata.equip_star) {
					return info
				} else {
					if (edata2.base_rating > power) {
						power = edata2.base_rating
						max_info = info
					}
				}
			}
			return max_info
		}

		this.CheckCompositeData = (goods_vo) => {
			let dtype_dic = {}, type_dic = {}, mat_dic = {}, mat_list = []
			let data = this.GetEquipData(goods_vo.type_id)
			if (!data || !data.composite_rule) return []
			_cur_rule_id_ = data.composite_rule
			let can = this.GetCompositeData(data.composite_rule, dtype_dic, type_dic, mat_dic, mat_list, goods_vo)
			_cur_rule_id_ = undefined
			let list = new Array<any>(can, dtype_dic, type_dic, mat_list)
			return list
		}

		//dtype_dic[type_id,need_count] --类型-数量(第一层材料)
		//type_dic[type_id,need_count]  --类型-数量(其他材料)
		//mat_dic[goods_id,count]   --id-数量
		//mat_list[goods_id]        --ids
		this.GetCompositeData = (rule_id, dtype_dic, type_dic, mat_dic, mat_list, goods_vo) => {
			let com_cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_compose
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false, com_cfg)
			if (!cfg) return false
			let list = ErlangParser.GetInstance().Parse(cfg.regular_mat)
			if (list.length < 1) return false
			let is_self = rule_id == _cur_rule_id_
			for (let info of list) {
				let vo = info[0]
				let number = local_Number(vo[2])
				let [type_id] = goods_model.GetMappingTypeId(vo[0], vo[1])
				// let dic = is_self ? dtype_dic : type_dic
				// dic[type_id] = dic[type_id] ? dic[type_id] + number : number
				if (is_self) {
					dtype_dic[type_id] = dtype_dic[type_id] ? dtype_dic[type_id] + number : number
				}
				let tVo = goods_vo
				//处理自己本身//装备不会叠加
				if (!mat_dic[tVo.goods_id] && tVo.type_id == type_id) {
					mat_list.push(tVo.goods_id)
					let count = mat_dic[tVo.goods_id]
					mat_dic[tVo.goods_id] = count ? count + number : number
				} else {
					let goods_list = goods_model.GetTypeGoods(type_id)
					let mark = false
					for (let gVo of goods_list) {
						if (mat_dic[gVo.goods_id] >= gVo.goods_num) continue
						//协议关系,n个材料需要传n个goods_id
						//当材料需要多个唯一物品叠加时，计算所需数量
						let mat_num = mat_dic[gVo.goods_id]
						let remain_num = mat_num ? gVo.goods_num - mat_num : gVo.goods_num
						let not_enough = remain_num < number
						let tCount = not_enough ? remain_num : number
						for (let i = 0; i < tCount; i++) {
							mat_list.push(gVo.goods_id)
						}
						mat_dic[gVo.goods_id] = mat_num ? mat_num + tCount : tCount
						number = not_enough ? number - gVo.goods_num : number
						mark = !not_enough
						if (!is_self) {
							type_dic[type_id] = type_dic[type_id] ? type_dic[type_id] + number : number
						}
						if (mark) break
					}
					if (!mark) {
						//普通物品不需要向下递归
						let data = this.GetEquipData(type_id)
						if (data) {
							if (!data.next_equip) return false
							let can = this.GetCompositeData(data.next_equip, dtype_dic, type_dic, mat_dic, mat_list, goods_vo)
							if (!can) return false
						} else {
							return false
						}
					}
				}
			}
			return true
		}

		this.CheckEquipCanStar = (god_id, pos, equip_attr_cfg, config_god_star_up_limit) => {
			let vo = this.GetGodVoInDic(god_id)
			if (!vo) return false
			if (!vo.equip_dic || !vo.equip_dic[pos]) return false
			//穿上代表类型符合-不再判断
			let ldata = this.GetStarLimitData(vo.star, config_god_star_up_limit)
			if (!ldata) return false
			let info = this.GetEquipInfo(vo.equip_dic[pos].goods_id)
			if (!info) return false
			let edata = this.GetEquipData(info.type_id)
			if (!edata) return false
			let estar = equip_model.GetStarByTypeId(info.type_id, equip_attr_cfg)
			return ldata.color == edata.color && ldata.equip_star == estar
		}

		this.GetAttrStr = (attr_list: Array<any>, color: number): string => {
			let str = ""
			if (!attr_list) return str
			for (let i = 0; i < attr_list.length; i++) {
				let attr = attr_list[i]
				let line = i + 1 != attr_list.length ? "<br>" : ""
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				str = str + `${local_WordManager.GetProperties(attr[0])}：${Util.HtmlColorTxt(value, color)}` + line
			}
			return str
		}

		this.StartTimer = (key: string, delta: number, func: Function) => {
			// this.ClearTimer(key)
			// let timer = new local_egret.Timer(delta, 0)
			// timer.addEventListener(local_egret.TimerEvent.TIMER, func, this)
			// timer.start()
			// let data = { func: func, timer: timer }
			// _timer_dic_[key] = data
		}

		this.ClearTimer = (key: string) => {
			// if (_timer_dic_[key]) {
			//     let data = _timer_dic_[key]
			//     data.timer.stop()
			//     data.timer.removeEventListener(local_egret.TimerEvent.TIMER, data.func, this)
			//     delete _timer_dic_[key]
			// }
		}

		this.GetTimerData = (key) => {
			return _timer_dic_[key]
		}

		this.GetJsonCacheAndSet = (key, json) => {
			if (!json) return
			let cache = this.GetCache(key)
			if (!cache) {
				cache = local_JSON.parse(json)
				this.SetCache(key, cache)
			}
			return cache
		}

		this.GetCache = (key) => {
			return _cache_dic_[key]
		}

		this.SetCache = (key, value) => {
			_cache_dic_[key] = value
		}

		this.DicToList = (dic) => {
			let list = []
			for (let key in dic) {
				list.push(dic[key])
			}
			return list
		}

		///////////////////////////////////////////////////////////////////

		this.CheckGodCanActive = (id) => {
			let vo = this.GetGodVoInDic(id)
			if (vo) return false
			let data = this.GetGodData(id)
			if (!data) return false
			let cond_goods = this.GetJsonCacheAndSet(`cond_good@${data.id}`, data.condition)
			let cond_lvs = this.GetJsonCacheAndSet(`cond_lv@${data.id}`, data.condition_lv)
			let cond_all_lv = this.GetJsonCacheAndSet(`cond_all_lv@${data.id}`, data.condition_all_lv)
			// let goods_can = true, lv_can = true, all_lv_can = true
			if (cond_goods.length > 0) {
				for (let cond of cond_goods) {
					let [type_id] = goods_model.GetMappingTypeId(cond[0], cond[1])
					let own = goods_model.GetTypeGoodsNum(type_id)
					if (own < local_Number(cond[2])) return false
				}
			}
			if (cond_lvs.length > 0) {
				for (let cond of cond_lvs) {
					let vo = this.GetGodVoInDic(cond[0])
					if (!vo) return false
					if (vo.lv < cond[1]) return false
				}
			}
			if (cond_all_lv[0]) {
				let id_list = cond_all_lv[0]
				let all_lv = cond_all_lv[1]
				let lv = 0
				for (let id of id_list) {
					let vo = this.GetGodVoInDic(id)
					if (vo) lv += vo.lv
				}
				if (lv < all_lv) return false
			}
			return true
			// return goods_can && lv_can && all_lv_can
		}

		this.CheckGodCanUp = (id, config_god_lv) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			let data = this.GetLvData(id, vo.lv, config_god_lv)
			if (!data) return false
			let ndata = this.GetLvData(id, vo.lv + 1, config_god_lv)
			if (!ndata) return false
			let need = data.exp - vo.exp
			let has_exp = 0
			for (let key in _lv_goods_dic_) {
				let own = goods_model.GetTypeGoodsNum(key)
				has_exp += own * _lv_goods_dic_[key]
				if (has_exp >= need) return true
			}
			return has_exp >= need
		}

		this.CheckGodCanStage = (id, config_god_stage) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			let data = this.GetStageData(vo.god_id, vo.grade, config_god_stage)
			if (!data) return false
			let cond_list = this.GetJsonCacheAndSet(`stage@${vo.god_id}@${vo.grade}`, data.condition)
			if (cond_list.length > 0) {
				for (let cond of cond_list) {
					let [type_id] = goods_model.GetMappingTypeId(cond[0], cond[1])
					let own = goods_model.GetTypeGoodsNum(type_id)
					if (own < local_Number(cond[2])) return false
				}
				return true
			}
			return false
		}

		this.CheckGodCanStar = (id, config_god_star_up_limit) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			return this.CheckEquipColorCanStar(vo.star, vo.equip_list, config_god_star_up_limit)
		}

		this.CheckGodAllPosReplace = (id, equip_attr_cfg, config_god_star_up_limit) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			for (let i = 1; i <= local_GodBefallDefine.EQUIP_COUNT; i++) {
				let id = vo.god_id * 10000 + i
				let inStar = this.CheckEquipCanStar(vo.god_id, i, equip_attr_cfg, config_god_star_up_limit)
				if (inStar) {
					this.SetAnyRedStatus(local_ModuleType.GOD_EQUIP, id, false)
					RedDotController.ins.add(RedKey.GOD_EQUIP + id, RedKey.GOD_EQUIP)
					RedDotController.ins.up(RedKey.GOD_EQUIP + id, 0)
				} else {
					let red = this.CheckEquipCanReplaceOne(vo, i)
					this.SetAnyRedStatus(local_ModuleType.GOD_EQUIP, id, red)
					RedDotController.ins.add(RedKey.GOD_EQUIP + id, RedKey.GOD_EQUIP)
					RedDotController.ins.up(RedKey.GOD_EQUIP + id, red ? 1 : 0)
				}
			}
		}

		this.CheckGodCanReplace = (id) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			return this.CheckEquipCanReplace(vo)
		}

		this.CheckGodCanCom = (id, equip_attr_cfg, config_god_star_up_limit) => {
			let vo = this.GetGodVoInDic(id)
			if (!vo) return false
			if (!vo.equip_dic) return false
			let dic = goods_model.wear_god_dic
			for (let i = 1; i <= local_GodBefallDefine.EQUIP_COUNT; i++) {
				let inStar = this.CheckEquipCanStar(id, i, equip_attr_cfg, config_god_star_up_limit)
				let red_id = vo.god_id * 10000 + i
				if (inStar) {
					this.SetAnyRedStatus(local_ModuleType.GOD_QUICK_COM, red_id, false)
					RedDotController.ins.add(RedKey.GOD_QUICK_COM + red_id, RedKey.GOD_QUICK_COM)
					RedDotController.ins.up(RedKey.GOD_QUICK_COM + red_id, 0)
				} else {
					let red = this.CheckGodCanComOne(vo, i)
					this.SetAnyRedStatus(local_ModuleType.GOD_QUICK_COM, red_id, red)
					RedDotController.ins.add(RedKey.GOD_QUICK_COM + red_id, RedKey.GOD_QUICK_COM)
					RedDotController.ins.up(RedKey.GOD_QUICK_COM + red_id, red ? 1 : 0)
				}
			}
		}

		this.CheckGodCanComOne = (vo, pos) => {
			if (!vo.equip_dic) return false
			let svo = vo.equip_dic[pos]
			if (!svo) return false
			let dic = goods_model.wear_god_dic
			if (!dic[svo.goods_id]) return false
			let [red] = this.CheckCompositeData(dic[svo.goods_id])
			return red
		}

		this.CheckAllResStatus = () => {
			if (!common_mgr.CheckFuncOpenState("GodBefallMainView", true)) return
			this.CheckLvRedStatus()
			this.CheckStageRedStatus()
			this.CheckStarRedStatus()
			this.CheckActiveRedStatus()
			this.CheckEquipRedStatus()
			this.CheckQuickComRedStatus()
			local_GlobalEventSystem.Fire(update_function_icon_red_event, MainFunc.Pet)
		}

		this.CheckQuickComRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_QUICK_COM)
			let gInfo = this.GetGodInfo()
			if (!gInfo) return
			res_mgr.LoadGameConfig(this, "config_equip_attr", false, undefined, (cfg) => {
				res_mgr.LoadGameConfig(this, "config_god_star_up_limit", false, undefined, (config_god_star_up_limit) => {
					let dic = goods_model.wear_god_dic
					for (let vo of gInfo.god_list) {
						this.CheckGodCanCom(vo.god_id, cfg, config_god_star_up_limit)
					}
					res_mgr.DestoryGameConfig(this, "config_god_star_up_limit", false)
				})
				res_mgr.DestoryGameConfig(this, "config_equip_attr", false)
			})

		}

		this.CheckEquipRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_EQUIP)
			let gInfo = this.GetGodInfo()
			if (!gInfo) return
			res_mgr.LoadGameConfig(this, "config_equip_attr", false, undefined, (cfg) => {
				res_mgr.LoadGameConfig(this, "config_god_star_up_limit", false, undefined, (config_god_star_up_limit) => {
					for (let vo of gInfo.god_list) {
						for (let i = 1; i <= local_GodBefallDefine.EQUIP_COUNT; i++) {
							let inStar = this.CheckEquipCanStar(vo.god_id, i, cfg, config_god_star_up_limit)
							let id = vo.god_id * 10000 + i
							if (inStar) {
								this.SetAnyRedStatus(local_ModuleType.GOD_EQUIP, id, false)
								RedDotController.ins.add(RedKey.GOD_EQUIP + id, RedKey.GOD_EQUIP)
								RedDotController.ins.up(RedKey.GOD_EQUIP + id, 0)
							} else {
								let red = this.CheckEquipCanReplaceOne(vo, i)
								this.SetAnyRedStatus(local_ModuleType.GOD_EQUIP, id, red)
								RedDotController.ins.add(RedKey.GOD_EQUIP + id, RedKey.GOD_EQUIP)
								RedDotController.ins.up(RedKey.GOD_EQUIP + id, red ? 1 : 0)
							}
						}
					}
					res_mgr.DestoryGameConfig(this, "config_god_star_up_limit", false)
				})
				res_mgr.DestoryGameConfig(this, "config_equip_attr", false)
			})
		}

		this.CheckActiveRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_ACTIVE)
			let dic = _cfg_dic_["config_god"]
			// let list = this.DicToList(dic)
			for (let key in dic) {
				let data = dic[key]
				let vo = this.GetGodVoInDic(data.id)
				if (vo) continue
				this.SetAnyRedStatus(local_ModuleType.GOD_ACTIVE, data.id, this.CheckGodCanActive(data.id))
				RedDotController.ins.add(RedKey.GOD_ACTIVE + data.id, RedKey.GOD_ACTIVE)
				RedDotController.ins.up(RedKey.GOD_ACTIVE + data.id, this.CheckGodCanActive(data.id) ? 1 : 0)
			}
		}

		this.CheckLvRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_LV)
			let gInfo = this.GetGodInfo()
			if (!gInfo) return
			let has_exp = 0
			for (let key in _lv_goods_dic_) {
				let own = goods_model.GetTypeGoodsNum(key)
				has_exp += own * _lv_goods_dic_[key]
			}
			res_mgr.LoadGameConfig(this, "config_god_lv", false, undefined, (config_god_lv) => {
				for (let vo of gInfo.god_list) {
					let data = this.GetLvData(vo.god_id, vo.lv, config_god_lv)
					let ndata = this.GetLvData(vo.god_id, vo.lv + 1, config_god_lv)
					if (!ndata) continue
					this.SetAnyRedStatus(local_ModuleType.GOD_LV, vo.god_id, has_exp >= data.exp - vo.exp)
					RedDotController.ins.add(RedKey.GOD_LV + vo.god_id, RedKey.GOD_LV)
					RedDotController.ins.up(RedKey.GOD_LV + vo.god_id, has_exp >= data.exp - vo.exp ? 1 : 0)
				}
				res_mgr.DestoryGameConfig(this, "config_god_lv", false)
			})
		}

		this.CheckStageRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_STAGE)
			let gInfo = this.GetGodInfo()
			if (!gInfo) return
			res_mgr.LoadGameConfig(this, "config_god_stage", false, undefined, (config_god_stage) => {
				for (let vo of gInfo.god_list) {
					this.SetAnyRedStatus(local_ModuleType.GOD_STAGE, vo.god_id, this.CheckGodCanStage(vo.god_id, config_god_stage))
					RedDotController.ins.add(RedKey.GOD_STAGE + vo.god_id, RedKey.GOD_STAGE)
					RedDotController.ins.up(RedKey.GOD_STAGE + vo.god_id, this.CheckGodCanStage(vo.god_id, config_god_stage) ? 1 : 0)
				}
				res_mgr.DestoryGameConfig(this, "config_god_stage", false)
			})
		}

		this.CheckStarRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(local_ModuleType.GOD_STAR)
			let gInfo = this.GetGodInfo()
			if (!gInfo) return
			res_mgr.LoadGameConfig(this, "config_god_star_up_limit", false, undefined, (config_god_star_up_limit) => {
				for (let vo of gInfo.god_list) {
					let red = this.CheckEquipColorCanStar(vo.star, vo.equip_list, config_god_star_up_limit)
					this.SetAnyRedStatus(local_ModuleType.GOD_STAR, vo.god_id, red)
					RedDotController.ins.add(RedKey.GOD_STAR + vo.god_id, RedKey.GOD_STAR)
					RedDotController.ins.up(RedKey.GOD_STAR + vo.god_id, red ? 1 : 0)
				}
				res_mgr.DestoryGameConfig(this, "config_god_star_up_limit", false)
			})
		}


		this.CheckOneGodRedStatus = (id, equip_attr_cfg) => {
			if (!common_mgr.CheckFuncOpenState("GodBefallMainView", true)) return
			res_mgr.LoadGameConfig(this, "config_god_lv", false, undefined, (config_god_lv) => {
				res_mgr.LoadGameConfig(this, "config_god_stage", false, undefined, (config_god_stage) => {
					res_mgr.LoadGameConfig(this, "config_god_star_up_limit", false, undefined, (config_god_star_up_limit) => {
						let vo = this.GetGodVoInDic(id)
						this.SetAnyRedStatus(local_ModuleType.GOD_LV, id, vo ? this.CheckGodCanUp(vo.god_id, config_god_lv) : false)
						this.SetAnyRedStatus(local_ModuleType.GOD_STAGE, id, vo ? this.CheckGodCanStage(vo.god_id, config_god_stage) : false)
						this.SetAnyRedStatus(local_ModuleType.GOD_STAR, id, vo ? this.CheckGodCanStar(vo.god_id, config_god_star_up_limit) : false,)
						RedDotController.ins.add(RedKey.GOD_LV + id, RedKey.GOD_LV)
						RedDotController.ins.add(RedKey.GOD_STAGE +id, RedKey.GOD_STAGE)
						RedDotController.ins.add(RedKey.GOD_STAR + id, RedKey.GOD_STAR)
						RedDotController.ins.up(RedKey.GOD_LV + id, vo ? (this.CheckGodCanUp(vo.god_id, config_god_lv) ? 1 : 0) : 0)
						RedDotController.ins.up(RedKey.GOD_STAGE + id, vo ? (this.CheckGodCanStage(vo.god_id, config_god_stage) ? 1 : 0) : 0)
						RedDotController.ins.up(RedKey.GOD_STAR + id, vo ? (this.CheckGodCanStar(vo.god_id, config_god_star_up_limit) ? 1 : 0) : 0)
						this.CheckGodAllPosReplace(id, equip_attr_cfg, config_god_star_up_limit)
						this.CheckGodCanCom(id, equip_attr_cfg, config_god_star_up_limit)
						local_GlobalEventSystem.Fire(update_function_icon_red_event, MainFunc.Pet)
						res_mgr.DestoryGameConfig(this, "config_god_star_up_limit", false)
					})
					res_mgr.DestoryGameConfig(this, "config_god_stage", false)
				})
				res_mgr.DestoryGameConfig(this, "config_god_lv", false)
			})

		}

		this.SetAnyRedStatus = (mType, id, active) => {
			red_dot_mgr.SetAnyRedStatus(mType, id, active)
		}

		this.GetRedStatus = (mType, id?) => {
			return red_dot_mgr.CheckAnyRedStatus(mType, id)
		}

		this.GetAllRedStatus = () => {
			let red = red_dot_mgr.CheckAnyRedStatusMultModule(GodBefallRedList)
			if (!red) red = red_dot_mgr.CheckAnyRedStatusMultModule(local_GodBefallRedSpecList)
			if (!red) red = this.GetAutoComposeRed()
			//if (!red) red = this.GetShenGeRed()
			return red
		}

		this.GetGodSepcRedStatus = (rtype, god_id) => {
			for (let i = 1; i <= local_GodBefallDefine.EQUIP_COUNT; i++) {
				let id = god_id * 10000 + i
				let red = this.GetRedStatus(rtype, id)
				if (red) return true
			}
			return false
		}

		this.GetGodSepcRedStatusAll = (god_id) => {
			for (let rtype of local_GodBefallRedSpecList) {
				let red = this.GetGodSepcRedStatus(rtype, god_id)
				if (red) return true
			}
			return false
		}
		this.CheckOpenShenGe = (GodBefallTabData) => {
			let open_dir = {}
			if (!GodBefallTabData) return
			for (let vo of GodBefallTabData) {
				let open = true
				let color = vo[2].color
				for (let id of vo[1]) {
					let info = this.GetGodVoInDic(id)
					if (!info || info.star < vo[3]) {
						open_dir[color] = false
						open = false
						break
					}
				}
				if (open == true) {
					open_dir[color] = true
				}
			}
			return open_dir
		}
		this.CheckCanAutoCompose = () => {
			let god_info = this.GetGodInfo()
			if (!god_info) return
			let god_list = god_info.god_list
			let can_Auto_compose_dir = {}
			let color_list = [0, 2, 3, 4]
			if (!god_list || god_list.length <= 0) return
			let color = 0
			let equip_list = []
			let bag_goods_list = goods_model.god_bag_list
			if (!bag_goods_list || bag_goods_list.length <= 0) return
			for (let i = 0; i < god_list.length; i++) {
				let bool = false
				let info = god_list[i]
				let god_id = info.god_id
				let data = this.GetGodData(god_id)
				let now_equip_list = this.GetEquipList(god_list[i])
				if (!now_equip_list || now_equip_list.length <= 0) continue
				if (!equip_list || equip_list.length <= 0) {
					equip_list = now_equip_list
				}
				else {
					for (let j = 0; j < 4; j++) {
						if (color != data.color) break
						if (now_equip_list[j].empty && !equip_list[j].empty)
							equip_list[j] = now_equip_list[j]
						let goods_info = equip_list[j]
						if (goods_info.empty) continue
						let goods_vo = this.GetEquipInfo(goods_info.goods_id)
						let goods_info_now = now_equip_list[j]
						let goods_vo_now = this.GetEquipInfo(goods_info_now.goods_id)
						if (!goods_vo || !goods_vo_now) return
						if (goods_vo.color > goods_vo_now.color)
							equip_list[j] = now_equip_list[j]
					}
				}
				if (color == 0) {
					color = data.color
				}
				if (color != data.color || i == god_list.length - 1) {
					if (color != data.color && i == god_list.length - 1)
						bool = true
					if (!equip_list || equip_list.length <= 0)
						continue
					let type_dir = {}
					for (let a = 0; a < color_list.length; a++) {
						let need_color = color_list[a]
						for (let i = 0; i < equip_list.length; i++) {
							let add_id
							for (let j = 0; j < bag_goods_list.length; j++) {
								let goods_info = equip_list[i]
								if (goods_info.empty) continue
								let goods_vo = this.GetEquipInfo(goods_info.goods_id)
								if (!goods_vo) return
								let bag_goods_data = this.GetEquipData(bag_goods_list[j].type_id)
								let equip_goods_data = this.GetEquipData(goods_vo.type_id)
								let pos = bag_goods_data.pos
								let vo_bag = EquipModel.GetInstance().GetEquipData(bag_goods_list[j].type_id)
								let vo_equip = EquipModel.GetInstance().GetEquipData(goods_vo.type_id)
								if (goods_vo && (goods_vo.color > bag_goods_list[j].color || vo_bag.star < vo_equip.star) && goods_info.pos == pos && Number(equip_goods_data.limit) == Number(bag_goods_data.limit)) {
									let num = goods_model.GetGodBefullGoodsNum(bag_goods_list[j].type_id)
									let need_num = bag_goods_list[j].color < 3 ? 5 : 3
									if (need_color != bag_goods_list[j].color) continue
									if (add_id && add_id == bag_goods_data.id) continue
									if (bag_goods_list[j].color < 3 && num >= 5) {
										let dir_num = 0
										if (can_Auto_compose_dir && Util.TableSize(can_Auto_compose_dir) > 0) {
											for (let key in can_Auto_compose_dir) {
												dir_num += can_Auto_compose_dir[key].can_compose_num
											}
										}
										let can_compose_num = Math.floor(num / 5) + dir_num > 100 ? 100 - dir_num : Math.floor(num / 5)
										can_Auto_compose_dir[bag_goods_data.id] = { id: bag_goods_data.id, next_id: bag_goods_data.id + 1, can_compose_num: can_compose_num, need_num: need_num, compose_id: bag_goods_data.composite_rule, goods_id: bag_goods_list[j].goods_id }
										add_id = bag_goods_data.id
										type_dir[bag_goods_data.id] = { id: bag_goods_data.id }
										if (can_compose_num + dir_num >= 100)
											return can_Auto_compose_dir
									}
									else if (((bag_goods_list[j].color == 4 && vo_bag.star < 2) || bag_goods_list[j].color == 3) && num >= 3) {
										let dir_num = 0
										if (can_Auto_compose_dir && Util.TableSize(can_Auto_compose_dir) > 0) {
											for (let key in can_Auto_compose_dir) {
												dir_num += can_Auto_compose_dir[key].can_compose_num
											}
										}
										let can_compose_num = Math.floor(num / 3) + dir_num > 100 ? 100 - dir_num : Math.floor(num / 3)
										can_Auto_compose_dir[bag_goods_data.id] = { id: bag_goods_data.id, next_id: bag_goods_data.id + 1, can_compose_num: can_compose_num, need_num: need_num, compose_id: bag_goods_data.composite_rule, goods_id: bag_goods_list[j].goods_id }
										add_id = bag_goods_data.id
										type_dir[bag_goods_data.id] = { id: bag_goods_data.id }
										if (can_compose_num + dir_num >= 100)
											return can_Auto_compose_dir
									}
								}
							}
						}
						// if (Util.TableSize(type_dir) > 0) {
						//     type_dir = {}
						//     break
						// }
					}
					equip_list = []
					if (i != god_list.length - 1 || bool) {
						i -= 1
						bool = false
					}
					color = 0
				}
			}
			return can_Auto_compose_dir
		}

		// this.CheckCanAutoCompose = () => {
		//     let god_info = this.GetGodInfo()
		//     if (!god_info) {
		//         return
		//     }
		//     let god_list = god_info.god_list
		//     let can_Auto_compose_dir = []
		//     let color_list = [0, 2, 3, 4]
		//     if (!god_list || god_list.length <= 0) {
		//         return
		//     }
		//     let color = 0
		//     let equip_list = []
		//     let bag_goods_list = goods_model.god_bag_list
		//     if (!bag_goods_list || bag_goods_list.length <= 0) {
		//         return
		//     }
		//     let i = 0
		//     do {
		//         do {
		//             let bool = false
		//             let info = god_list[i]
		//             let god_id = info.god_id
		//             let data = this.GetGodData(god_id)
		//             if (!data) { break }
		//             let now_equip_list = this.GetEquipList(god_list[i])
		//             if (!now_equip_list || now_equip_list.length <= 0) {
		//                 break
		//             }
		//             if (!equip_list || equip_list.length <= 0) {
		//                 equip_list = now_equip_list
		//             } else {
		//                 let j = 0
		//                 do {
		//                     do {
		//                         if (color != data.color) {
		//                             break
		//                         }
		//                         if (now_equip_list[j].empty && !equip_list[j].empty) {
		//                             equip_list[j] = now_equip_list[j]
		//                         }
		//                         let goods_info = equip_list[j]
		//                         if (goods_info.empty) {
		//                             break
		//                         }
		//                         let goods_vo = this.GetEquipInfo(goods_info.goods_id)
		//                         let goods_info_now = now_equip_list[j]
		//                         let goods_vo_now = this.GetEquipInfo(goods_info_now.goods_id)
		//                         if (!goods_vo || !goods_vo_now) {
		//                             return
		//                         }
		//                         if (goods_vo.color > goods_vo_now.color) {
		//                             equip_list[j] = now_equip_list[j]
		//                         }
		//                     } while (true)
		//                     j = j + 1
		//                 } while ((j < 4))
		//             }
		//             if (color == 0) {
		//                 color = data.color
		//             }
		//             if (color != data.color || i == god_list.length - 1) {
		//                 if (color != data.color && i == god_list.length - 1) {
		//                     bool = true
		//                 }
		//                 if (!equip_list || equip_list.length <= 0) {
		//                     break
		//                 }
		//                 let type_dir = []
		//                 let a = 0
		//                 do {
		//                     do {
		//                         let need_color = color_list[a]
		//                         let i = 0
		//                         do {
		//                             do {
		//                                 let add_id = null
		//                                 let j = 0
		//                                 do {
		//                                     do {
		//                                         let goods_info = equip_list[i]
		//                                         if (goods_info.empty) {
		//                                             break
		//                                         }
		//                                         let goods_vo = this.GetEquipInfo(goods_info.goods_id)
		//                                         if (!goods_vo) {
		//                                             return
		//                                         }
		//                                         let bag_goods_data = this.GetEquipData(bag_goods_list[j].type_id)
		//                                         let equip_goods_data = this.GetEquipData(goods_vo.type_id)
		//                                         let pos = bag_goods_data.pos
		//                                         let vo_bag = EquipModel.GetInstance().GetEquipData(bag_goods_list[j].type_id)
		//                                         let vo_equip = EquipModel.GetInstance().GetEquipData(goods_vo.type_id)
		//                                         if (((goods_vo && (goods_vo.color > bag_goods_list[j].color || vo_bag.star < vo_equip.star)) && goods_info.pos == pos) &&
		//                                             Number(equip_goods_data.limit) == Number(bag_goods_data.limit)
		//                                         ) {
		//                                             let num = goods_model.GetGodBefullGoodsNum(bag_goods_list[j].type_id)
		//                                             let need_num = (bag_goods_list[j].color < 3 && (5) || (3))
		//                                             if (need_color != bag_goods_list[j].color) {
		//                                                 break
		//                                             }
		//                                             if (add_id && add_id == bag_goods_data.id) {
		//                                                 break
		//                                             }
		//                                             if (bag_goods_list[j].color < 3 && num >= 5) {
		//                                                 let dir_num = 0
		//                                                 if (can_Auto_compose_dir && Util.TableSize(can_Auto_compose_dir) > 0) {
		//                                                     for (let key in can_Auto_compose_dir) {
		//                                                         dir_num = dir_num + can_Auto_compose_dir[key].can_compose_num
		//                                                     }
		//                                                 }
		//                                                 let can_compose_num = (Math.floor(num / 5) + dir_num > 100 && (100 - dir_num) || (Math.floor(num / 5)))
		//                                                 can_Auto_compose_dir[bag_goods_data.id] = {
		//                                                     id : bag_goods_data.id,
		//                                                     next_id : bag_goods_data.id + 1,
		//                                                     can_compose_num : can_compose_num,
		//                                                     need_num : 5,
		//                                                     compose_id : bag_goods_data.composite_rule,
		//                                                     goods_id : bag_goods_list[j].goods_id
		//                                                 }
		//                                                 add_id = bag_goods_data.id
		//                                                 type_dir[bag_goods_data.id] = {id : bag_goods_data.id}
		//                                                 if (can_compose_num + dir_num >= 100) {
		//                                                     return can_Auto_compose_dir
		//                                                 }
		//                                             }
		//                                             else if ((bag_goods_list[j].color == 4 && vo_bag.star < 2 || bag_goods_list[j].color == 3) && num >= 3) {
		//                                                 let dir_num = 0
		//                                                 if (can_Auto_compose_dir && Util.TableSize(can_Auto_compose_dir) > 0) {
		//                                                     for (let key in can_Auto_compose_dir) {
		//                                                         dir_num = dir_num + can_Auto_compose_dir[key].can_compose_num
		//                                                     }
		//                                                 }
		//                                                 let can_compose_num = (Math.floor(num / 3) + dir_num > 100 && (100 - dir_num) || (Math.floor(num / 3)))
		//                                                 can_Auto_compose_dir[bag_goods_data.id] = {
		//                                                     id : bag_goods_data.id,
		//                                                     next_id : bag_goods_data.id + 1,
		//                                                     can_compose_num : can_compose_num,
		//                                                     need_num : 3,
		//                                                     compose_id : bag_goods_data.composite_rule,
		//                                                     goods_id : bag_goods_list[j].goods_id
		//                                                 }
		//                                                 add_id = bag_goods_data.id
		//                                                 // [ts2lua]type_dir下标访问可能不正确
		//                                                 type_dir[bag_goods_data.id] = {id : bag_goods_data.id}
		//                                                 if (can_compose_num + dir_num >= 100) {
		//                                                     return can_Auto_compose_dir
		//                                                 }
		//                                             }
		//                                         }
		//                                     } while (true)
		//                                     j = j + 1
		//                                 } while ((j < bag_goods_list.length))
		//                             } while (true)
		//                             i = i + 1
		//                         } while ((i < equip_list.length))
		//                         if (Util.TableSize(type_dir) > 0) {
		//                             type_dir = []
		//                             break
		//                         }
		//                     } while (true)
		//                     a = a + 1
		//                 } while ((a < color_list.length))
		//                 equip_list = []
		//                 if (i != god_list.length - 1 || bool) {
		//                     i = i - 1
		//                     bool = false
		//                 }
		//                 color = 0
		//             }
		//         } while (true)
		//         i = i + 1
		//     } while ((i < god_list.length))
		//     return can_Auto_compose_dir
		// }

		this.SetStrongGodDic = (info) => {
			strong_god_dic[info.god_type] = { current_lv: info.current_lv, current_exp: info.current_exp }
		}
		this.GetStrongGodDic = () => {
			return strong_god_dic
		}
		this.GetGodTypeEquipList = () => {
			let bag_goods_list = goods_model.god_bag_list
			let equip_dic = {}
			if (!bag_goods_list || bag_goods_list.length <= 0) return
			for (let i = 0; i < bag_goods_list.length; i++) {
				let bag_goods_data = this.GetEquipData(bag_goods_list[i].type_id)
				if (bag_goods_data.color > 4) continue
				if (!equip_dic[bag_goods_data.limit]) {
					equip_dic[bag_goods_data.limit] = []
					equip_dic[bag_goods_data.limit].push({ type_id: bag_goods_list[i].type_id, num: 1, goods_id: bag_goods_list[i].goods_id, color: bag_goods_list[i].color })
					//equip_dic[bag_goods_data.limit].goods_id.push(bag_goods_list[i].goods_id)
				}
				else {
					let list = equip_dic[bag_goods_data.limit]
					for (let j = 0; j < list.length; j++) {
						if (list[j].type_id == bag_goods_list[i].type_id) {
							let num = list[j].num
							num += 1
							list[j].num = num
							break
						}
						if (j == list.length - 1) {
							list.push({ type_id: bag_goods_list[i].type_id, num: 1, goods_id: bag_goods_list[i].goods_id, color: bag_goods_list[i].color })
							//list.goods_id.push(bag_goods_list[i].goods_id)
							break
						}
					}

				}
			}
			return equip_dic
		}
		this.CheckAutoComposeRed = () => {
			res_mgr.LoadGameConfig(this, "ConfigGodBefall", true, undefined, (cfg) => {
				let GodBefallTabData = cfg && cfg["GodBefallTabData"]
				let dir = this.CheckCanAutoCompose(GodBefallTabData)
				auto_compose_red = Util.TableSize(dir) > 0 ? true : false
				let red = this.GetAllRedStatus()
				this.Fire(CompositeModel.UPDATE_EQUIP_RED)
				// GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "StarEquipMainView", StarEquipMainView.TabIndex.GodBefall, red)
				res_mgr.DestoryGameConfig(this, "ConfigGodBefall", true)
			})
		}
		this.CheckShenGeRed = (GodBefallTabData?) => {
			let call_fun = () => {
				let open_dir = this.CheckOpenShenGe(GodBefallTabData)
				for (let i = 3; i < 7; i++) {
					if (open_dir[i]) {
						shen_ge_red = this.CheckTabRed(i, 200, GodBefallTabData)
						if (shen_ge_red)
							break
					}
				}
			}
			if (GodBefallTabData) {
				call_fun()
			} else {
				res_mgr.LoadGameConfig(this, "ConfigGodBefall", true, undefined, (cfg) => {
					let tab_data = cfg && cfg["GodBefallTabData"]
					this.CheckShenGeRed(tab_data)
					let red = this.GetAllRedStatus()
					// GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "StarEquipMainView", StarEquipMainView.TabIndex.GodBefall, red)
					res_mgr.DestoryGameConfig(this, "ConfigGodBefall", true)
				})
			}

		}
		this.GetAutoComposeRed = () => {
			return auto_compose_red
		}
		this.CheckTabRed = (god_type, max_level, GodBefallTabData?) => {
			let goods_dic = this.GetGodTypeEquipList()
			if (Util.TableSize(goods_dic) <= 0 || !goods_dic[god_type] || goods_dic[god_type].length <= 0) {
				return false
			}
			let dic = this.GetStrongGodDic()
			let info = dic[god_type]
			if (!info) return false
			if (info.current_lv < max_level) return true
		}
		this.GetShenGeRed = () => {
			return shen_ge_red
		}

		this.RefreshShenGeRed = (GodBefallTabData?) => {
			this.CheckShenGeRed(GodBefallTabData)
			return shen_ge_red
		}

		this.GetGodSkillId = (god_id, skill_index) => {
			this.god_skill_list = this.god_skill_list || {}
			if (!this.god_skill_list[god_id]) {
				this.god_skill_list[god_id] = this.LoadGodSkills(god_id)
			}
			return this.god_skill_list[god_id][skill_index - 1]
		}

		this.LoadGodSkills = (god_id?) => {
			let vo = this.GetGodVoInDic(god_id)
			let grade = (vo && vo.grade || 0)
			//grade = grade + 1
			let skills = []
			let god_cfg = this.GetGodData(god_id)
			if (god_cfg) {
				let source_skills = JSON.parse(god_cfg.skill)
				if (grade > source_skills.length) {
					grade = source_skills.length
				}
				if (source_skills[grade]) {
					source_skills = source_skills[grade][1]
					for (let _ = 0; _ < source_skills.length; _++) {
						var v = source_skills[_]
						skills.push(Number(v))
					}
				}
			}
			return skills
		}

		this.ClearGodSkillList = () => {
			_cache_dic_ = []
			this.god_skill_list = []
		}

		this.CleanGodInfo = () => {
			this._cur_battle_id = null
			GlobalEventSystem.Fire(EventName.HIDE_GOD_ICON)
		}

		this.CheckAndGetMainRoleGodAllSkill = (delegete?) => {
			let list = []
			let god_id = RoleManager.Instance.mainRoleInfo.god_id
			if (god_id > 0) {
				this.god_skill_list = this.god_skill_list || {}
				let skills = this.god_skill_list[god_id]
				if (!skills) {
					skills = this.LoadGodSkills(god_id)
					this.god_skill_list[god_id] = skills
				}
				if (skills) {
					for (let _ = 0; _ < skills.length; _++) {
						var skill_id = skills[_]
						let skillVo = delegete.getSkill(skill_id)
						if (skillVo) {
							list.push(skillVo)
						}
					}
				}
			}
			return list
		}
	}
	public static GetInstance() {
		if (!GodBefallModel.Instance) {
			GodBefallModel.Instance = new GodBefallModel()
		}
		return GodBefallModel.Instance
	}
}
window["GodBefallModel"] = GodBefallModel