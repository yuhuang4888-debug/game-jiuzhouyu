import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "./RoleManager"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { TaskModel } from "./TaskModel"
import { PlayBigEffect } from "../util/Util"
import { table } from "../common/table"

export const ForbiddenSkillType = {
	Normal: 0,
	ShenHun: 1,
	MoHun: 2
}

export const ForbiddenSkillTypeStr = { Normal: "通用", ShenHun: "神魂天籁", MoHun: "魔魂天咒" }

window["ForbiddenSkillType"] = ForbiddenSkillType
window["ForbiddenSkillTypeStr"] = ForbiddenSkillTypeStr
export class SkillUIModel extends EventDispatcher {

	public static UPDATE_RED_DOT = "SkillUIModel.UPDATE_RED_DOT"
	public static SELECT_SKILL_ITEM = "SkillUIModel.SELECT_SKILL_ITEM"
	public static UPDATE_SKILL_INFO = "SkillUIModel.UPDATE_SKILL_INFO"
	public static UPGRADE_SKILL_SUCCESS = "SkillUIModel.UPGRADE_SKILL_SUCCESS"
	public static UPDATE_SKILL_RED_SPEC = "SkillUIModel.UPDATE_SKILL_RED_SPEC"
	public static UPDATE_INNATE_VIEW = "SkillUIModel.UPDATE_INNATE_VIEW"
	public static SELECT_INNATE_ITEM = "SkillUIModel.SELECT_INNATE_ITEM"
	public static UPDATE_SKILL_VIEW_RED = "SkillUIModel.UPDATE_SKILL_VIEW_RED"
	public static OPEN_SKILL_VIEW = "SkillUIModel.OPEN_SKILL_VIEW"
	public static UPDATE_FORBIDDEN_SKILL_INFO = "SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO"
	//SkillUIModel.OPEN_SKILL_UI_VIEW = "SkillUIModel.OPEN_SKILL_UI_VIEW"
	public static SELECT_ASSEMBLY_ITEM = "SkillUIModel.SELECT_ASSEMBLY_ITEM"
	public static FORBIDDEN_SKILL_UPGRADE_SUCCESS = "SkillUIModel.FORBIDDEN_SKILL_UPGRADE_SUCCESS"
	public static FORBIDDEN_SKILL_SELECT_TYPE_SUCCESS = "SkillUIModel.FORBIDDEN_SKILL_SELECT_TYPE_SUCCESS"
	public static FORBIDDEN_SKILL_UPDATE_RED_DOT = "SkillUIModel.FORBIDDEN_SKILL_UPDATE_RED_DOT"
	public static UPDATE_CAREER_SKILL_BUFF = "SUE1"
	static Instance
	public static GetInstance() {

		if (!SkillUIModel.Instance) {
			SkillUIModel.Instance = new SkillUIModel()
		}
		return SkillUIModel.Instance
	}



	CanActiveForbiddenSkill
	CanBreakForbiddenSkill
	CanUpgradeForbiddenSkill
	CheckLvUnlockSkill
	CheckSkillStrenReddot
	CheckSkillStrenReddotAll
	CheckTaskFinish
	ForbiddenSkillBreakSuccess
	ForbiddenSkillByRuleId
	ForbiddenSkillConditionIsEnough
	ForbiddenSkillRedDot
	ForbiddenSkillUpgradeSuccess
	GetAllShowList
	GetBeforeBreakSkillId
	GetBreakCfg
	GetBreakSkillId
	GetForbiddenSkillAllLvDesc
	GetForbiddenSkillList
	GetForbiddenSkillLvCfg
	GetForbiddenSkillRedDot
	GetForbiddenSkillRuleCfg
	GetInnateAllInfoByID
	GetInnateInfo
	GetInnateOpenStatus
	GetInnateRed
	GetInnateSkillIdByCfg
	GetJsonCache
	GetJsonCacheAndSet
	GetLvCacheAndSet
	GetMinSkillData
	GetMyForbiddenSkillAllLv
	GetMyForbiddenSkillLv
	GetRealSkillId
	GetRuleIdBySkillId
	GetSkillInfoFromDic
	GetSkillRedDot
	GetSkillStrenData
	GetSkillStrenInfo
	GetTurnCacheAndSet
	InitConfig
	InitForbiddenSkillCfg
	IsInSpecialPos
	Reset
	SetInnateInfo
	SetJsonCache
	SetSkillStrenDic
	SetSkillStrenDicFromScmd
	SetSkillStrenInfo
	UpdateForbiddenSkillInfo
	UpdateInnateInfo
	UpdateInnateRed
	UpdateTabDot
	career_skill_buff_list
	config_item
	forbbiden_skill_info
	skill_bar_info
	now_select_skill_id
	GetCommonSkill
	GetTaskCacheAndSet

	ReleaseGodBefallSkillTip
	ReleasePartnerSkillTip
	PreLoadSkillEffectRes

	


	innate_open_turn_cond = 4
	public constructor() {
		super()

		if (SkillUIModel.Instance) {
			return
		}
		SkillUIModel.Instance = this

		this.forbbiden_skill_info = null
		this.now_select_skill_id = null
		this.skill_bar_info = null
		// this.config_item = ConfigItemMgr.Instance
		let skill_mgr = SkillManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_SkillUIModel = SkillUIModel
		let local_GlobalEventSystem = GlobalEventSystem
		let REFRESH_FUNCTION_ICON_RED_DOT = EventName.REFRESH_FUNCTION_ICON_RED_DOT
		let role_mgr = RoleManager.GetInstance()
		let local_Number = Number
		let common_mgr = CommonManager.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let REQUEST_CCMD_EVENT = SkillManager.REQUEST_CCMD_EVENT
		let local_ForbiddenSkillType = ForbiddenSkillType
		let skillRedDot_ = 0
		let cfg_dic_ = null
		let cfg_asset_dic_ = []
		let skill_stren_info_ = null
		let skill_dic_ = []
		let skill_data_dic_ = []
		let innate_skill_info_ = null
		let innate_skill_list_ = null
		let innate_frist_red_ = true
		let forbbiden_skill_cfg_ = null
		let last_career = 0
		let forbidden_skill_dot_ = 0

		this.Reset = () => {
			cfg_asset_dic_ = []
			skill_stren_info_ = null
			skill_data_dic_ = []
		}

		this.InitConfig = () => {
			cfg_dic_ = []
			cfg_dic_["config_skill_stren"] = Config.PRELOAD_SERVER_CONFIG.config_skill_stren
			this.SetSkillStrenDic(Config.PRELOAD_CLIENT_CONFIG.ConfigSkillUI)
			//lua_resM:ReduceReferenceCount(ResManager.GetInstance().hashCode, ResManager.GetInstance().GetConfigFullUrl("ConfigSkillUI", true))
		}

		this.UpdateTabDot = () => {

			ResManager.GetInstance().LoadGameConfig(this, "config_skill", false, null, (skill_ui_cfg) => {
				let list = skill_mgr.GetShowPassitiveSkillList(skill_ui_cfg)
				skillRedDot_ = 0
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					let next_vo = vo.getLevelVo(vo.level + 1)
					if (next_vo) {
						let goods_info = next_vo.condition.goods
						//let goods_info = null
						//if (cond ) {
						//goods_info = cond.split(",")
						//}
						if (goods_info) {
							let cost_count = goods_info[2]
							let my_count = goods_model.GetTypeGoodsNum(goods_info[1])
							if (cost_count <= my_count) {
								skillRedDot_ = 1
								break
							}
						}
					}
				}
				this.Fire(local_SkillUIModel.UPDATE_RED_DOT)
				local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
				this.Fire(local_SkillUIModel.UPDATE_SKILL_VIEW_RED)
				ResManager.GetInstance().DestoryGameConfig(this, "config_skill", false);
			});
			// this.GetGameConfig("ConfigSkillUI", (skill_ui_cfg?) => {
			// 	let list = skill_mgr.GetShowPassitiveSkillList(skill_ui_cfg)
			// 	skillRedDot_ = 0
			// 	for (let _tmpi in list) {
			// 		var vo = list[_tmpi]
			// 		let next_vo = vo.getLevelVo(vo.level + 1)
			// 		if (next_vo) {
			// 			let goods_info = next_vo.condition.goods
			// 			//let goods_info = null
			// 			//if (cond ) {
			// 			//goods_info = cond.split(",")
			// 			//}
			// 			if (goods_info) {
			// 				let cost_count = goods_info[2]
			// 				let my_count = goods_model.GetTypeGoodsNum(goods_info[1])
			// 				if (cost_count <= my_count) {
			// 					skillRedDot_ = 1
			// 					break
			// 				}
			// 			}
			// 		}
			// 	}
			// 	this.Fire(local_SkillUIModel.UPDATE_RED_DOT)
			// 	local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			// 	this.Fire(local_SkillUIModel.UPDATE_SKILL_VIEW_RED)
			// 	this.DestoryGameConfig("ConfigSkillUI", true)
			// }, true)
		}

		this.GetSkillRedDot = () => {
			return skillRedDot_ > 0
		}

		this.GetSkillStrenData = (skill_id?, stren?) => {
			let id_dic = skill_data_dic_[skill_id]
			if (!id_dic) {
				skill_data_dic_[skill_id] = []
				id_dic = skill_data_dic_[skill_id]
			}
			if (!id_dic[stren]) {
				let cfg = cfg_dic_["config_skill_stren"]
				for (let key in cfg) {

					let data = cfg[key]
					if (skill_id != data.skill_id) {
						break
					}
					if (data.min_stren > stren) {
						break
					}
					if (data.max_stren < stren) {
						break
					}
					skill_data_dic_[skill_id][stren] = data
				}
			}
			return id_dic[stren]
		}

		this.SetSkillStrenInfo = (info?) => {
			skill_stren_info_ = info
			this.SetSkillStrenDicFromScmd()
			this.Fire(local_SkillUIModel.UPDATE_SKILL_INFO)
		}

		this.GetSkillStrenInfo = () => {
			return skill_stren_info_
		}

		this.GetMinSkillData = () => {

		}

		this.CheckSkillStrenReddot = (data?) => {
			let next_stren = data.stren + 1
			let next_data = this.GetSkillStrenData(data.skill_id, next_stren)
			if (!next_data) {
				return false
			}
			let role_lv = role_mgr.GetMainRoleVo().level
			let cfg = this.config_item.GetSkillItem(data.skill_id)
			if (!cfg) {
				return false
			}
			let lv_cache = this.GetLvCacheAndSet(data.skill_id, cfg)
			if (lv_cache && lv_cache > role_lv) {
				return false
			}
			if (role_lv <= data.stren) {
				return false
			}
			let cost = this.GetJsonCacheAndSet(data.skill_id, next_stren, "cost", next_data)
			let per_cost = this.GetJsonCacheAndSet(data.skill_id, next_stren, "per_cost", next_data)
			if (cost && per_cost) {
				cost = cost[1]
				per_cost = per_cost[1]
				let add_cost = (next_stren - next_data.min_stren) * local_Number(per_cost[3])
				let own = goods_model.GetRoleSpecGoodsNum(cost[1], cost[2])
				return own >= local_Number(cost[3]) + add_cost
			}
			return false
		}

		this.CheckSkillStrenReddotAll = (check_up?) => {
			if (!common_mgr.CheckFuncOpenState("SkillSubView", true)) {
				return false
			}
			let red_status = false
			let old_status = red_dot_mgr.CheckAnyRedStatus(local_ModuleType.SKILL_STREN)
			let diff_count = 0
			for (let key in skill_dic_) {

				let info = skill_dic_[key]
				let old_red = red_dot_mgr.CheckAnyRedStatus(local_ModuleType.SKILL_STREN, info.skill_id)
				if ((check_up != null && check_up) && old_red) {
					break
				}
				if ((check_up != null && !check_up) && !old_red) {
					break
				}
				let new_red = this.CheckSkillStrenReddot(info)
				red_dot_mgr.SetAnyRedStatus(local_ModuleType.SKILL_STREN, info.skill_id, new_red)
				RedDotController.ins.add(RedKey.ROLE_SKILL_STREN + info.skill_id, RedKey.ROLE_SKILL_STREN)
				RedDotController.ins.up(RedKey.ROLE_SKILL_STREN + info.skill_id, new_red ? 1 : 0)
				if (!red_status && new_red) {
					red_status = new_red
				}
				if (old_red != new_red) {
					diff_count = diff_count + 1
				}
			}
			if (diff_count > 0) {
				this.Fire(local_SkillUIModel.UPDATE_SKILL_RED_SPEC)
			}
			if (old_status != red_status) {
				let is_open = common_mgr.CheckFuncOpenState("SkillSubView", true)
				if (!is_open) {
					return
				}
				local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
				this.Fire(local_SkillUIModel.UPDATE_SKILL_VIEW_RED)
			}
		}

		this.SetSkillStrenDic = (skill_ui_cfg?) => {
			skill_dic_ = []
			let career = role_mgr.GetMainRoleVo().career
			if (career > 0) {
				let skill_list = skill_ui_cfg["carrerSkillList"][career]
				if (skill_list) {
					for (let _tmpi in skill_list) {
						var info = skill_list[_tmpi]
						skill_dic_[info.skill_id] = info
					}
				}
			}
		}

		this.SetSkillStrenDicFromScmd = () => {
			let stren_info = this.GetSkillStrenInfo()
			if (!stren_info) {
				return
			}
			for (let _tmpi in stren_info.skill_list) {
				var info = stren_info.skill_list[_tmpi]
				skill_dic_[info.skill_id] = info
			}
		}

		this.GetSkillInfoFromDic = (skill_id?) => {
			return skill_dic_[skill_id]
		}

		this.GetJsonCache = (skill_id?, stren?, key?) => {
			let cfg_asset = cfg_asset_dic_[skill_id + "@" + stren]
			return cfg_asset && cfg_asset[key]
		}

		this.SetJsonCache = (skill_id?, stren?, key?, value?) => {
			let cfg_asset = cfg_asset_dic_[skill_id + "@" + stren]
			if (!cfg_asset) {
				cfg_asset_dic_[skill_id + "@" + stren] = []
			}
			cfg_asset_dic_[skill_id + "@" + stren][key] = value
		}

		this.GetJsonCacheAndSet = (skill_id?, stren?, key?, cfg?) => {
			if (!cfg) {
				return
			}
			let cache = this.GetJsonCache(skill_id, stren, key)
			if (!cache) {
				cache = ErlangParser.GetInstance().Parse(cfg[key])
				this.SetJsonCache(skill_id, stren, key, cache)
			}
			return cache
		}

		this.GetLvCacheAndSet = (skill_id?, cfg?, lv = 1) => {
			let lv_cache = this.GetJsonCache(skill_id, lv, "open_lv")
			if (lv_cache == null) {
				let lv_data = JSON.parse(cfg.lv_data)
				let lv_index = lv - 1
				let cond 
				if(lv_data[lv_index]){
					if(typeof(lv_data[lv_index].condition) == "string"){
						cond = ErlangParser.GetInstance().Parse(lv_data[lv_index].condition)
					}
					else{
						//不是字符串说明已经解析过了或者是空数组
						cond = lv_data[lv_index].condition
					}
				}

				if (cond && cond.length > 0) {
					for(let key in cond){
						let lv_cond = cond[key]
						if (lv_cond[0] == "lv" && lv_cond[1] != null) {
							lv_cache = Number(lv_cond[1])
							this.SetJsonCache(skill_id, lv, "open_lv", lv_cache)
							break
						}
					}	
				}
			}
			return lv_cache
		}

		this.GetTaskCacheAndSet = (skill_id?, cfg?, lv = 1) => {
			let task_id_cache = this.GetJsonCache(skill_id, lv, "task_id")
			if (task_id_cache == null) {
				let lv_data = JSON.parse(cfg.lv_data)
				let lv_index = lv - 1

				let cond 
				if(lv_data[lv_index]){
					if(typeof(lv_data[lv_index].condition) == "string"){
						cond = ErlangParser.GetInstance().Parse(lv_data[lv_index].condition)
					}
					else{
						//不是字符串说明已经解析过了或者是空数组
						cond = lv_data[lv_index].condition
					}
				}

				if (cond && cond.length > 0) {
					for(let key in cond){
						let task_cond = cond[key]
						if (task_cond[0] == "task_id" && task_cond[1] != null) {
							task_id_cache = Number(task_cond[1])
							this.SetJsonCache(skill_id, lv, "task_id", task_id_cache)
							break
						}
					}	
				}
			}
			return task_id_cache
		}

		this.GetTurnCacheAndSet = (skill_id?, cfg?, lv = 1) => {
			let turn_cache = this.GetJsonCache(skill_id, lv, "turn")

			if (turn_cache == null) {
				let lv_data = JSON.parse(cfg.lv_data)
				let lv_index = lv - 1

				let cond 
				if(lv_data[lv_index]){
					if(typeof(lv_data[lv_index].condition) == "string"){
						cond = ErlangParser.GetInstance().Parse(lv_data[lv_index].condition)
					}
					else{
						//不是字符串说明已经解析过了或者是空数组
						cond = lv_data[lv_index].condition
					}
				}

				if (cond && cond.length > 0) {
					for(let key in cond){
						let turn_cond = cond[key]
						if (turn_cond[0] == "turn" && turn_cond[1] != null) {
							turn_cache = Number(turn_cond[1])
							this.SetJsonCache(skill_id, lv, "turn", turn_cache)
							break
						}
					}	
				}
			}

			return turn_cache
		}

		this.CheckTaskFinish = (task_id?) => {
			if (!task_id) {
				return true
			}
			let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
			if (!task_vo) {
				return true
			}
			if (task_vo.task_id == task_id) {
				return task_vo.has_finish
			}
			return task_vo.task_id > task_id
		}

		this.CheckLvUnlockSkill = (role_lv?, skill_ui_cfg?) => {
			if (role_lv == 1) {
				return
			}
			let career = role_mgr.GetMainRoleVo().career
			let skill_list = skill_ui_cfg["carrerSkillList"][career]
			if (!skill_list) {
				return
			}
			for (let _tmpi in skill_list) {
				var info = skill_list[_tmpi]
				let cfg = this.config_item.GetSkillItem(info.skill_id)
				if (!cfg) {
					break
				}
				let lv_cache = this.GetLvCacheAndSet(info.skill_id, cfg)
				if (lv_cache && lv_cache == role_lv) {
					local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SkillShowView", info.skill_id)
					return
				}
			}
		}

		//天赋技能
		this.SetInnateInfo = (scmd?) => {
			innate_skill_info_ = scmd
			if (innate_skill_info_.is_first != false) {
				innate_skill_info_.is_first = true
			}
			this.UpdateInnateRed()
		}

		this.UpdateInnateInfo = (scmd?) => {
			let info = innate_skill_info_
			if (!info) {
				return
			}
			info.less_point = scmd.less_point
			let talent_skills = info.talent_skills
			if (talent_skills.length > 0) {
				for (let _tmpi in talent_skills) {
					var v = talent_skills[_tmpi]
					if (v.skills.length > 0) {
						for (let _tmpj in v.skills) {
							var skill = v.skills[_tmpj]
							if (skill.skill_id == scmd.skill_id) {
								skill.skill_lv = scmd.skill_lv
								v.point = v.point + 1
								return
							}
						}
					}
				}
			}
			skill_mgr.Fire(REQUEST_CCMD_EVENT, 21010)
		}

		this.UpdateInnateRed = (is_del_red?) => {
			// local_GlobalEventSystem.Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			this.Fire(local_SkillUIModel.UPDATE_SKILL_VIEW_RED, "InnateSkillView")
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
		}

		this.GetInnateRed = () => {
			if (!this.GetInnateOpenStatus()) {
				return false
			}
			if (innate_skill_info_ && innate_skill_info_.less_point > 0) {
				let skill_lv_num = 87 + 87 + 140
				let list = innate_skill_info_.talent_skills
				let use_num = 0
				for (let i in list) {

					use_num = use_num + list[i].point
				}
				if (skill_lv_num > use_num) {
					return true
				}
			}
			return false
		}

		// 天赋技能界面信息
		this.GetInnateInfo = () => {
			return innate_skill_info_

		}

		this.GetInnateOpenStatus = () => {
			let turn = role_mgr.mainRoleInfo.turn
			return turn >= this.innate_open_turn_cond
		}

		//天赋技能界面布局配置
		this.GetInnateAllInfoByID = (skill_id?) => {
			let cfg = skill_mgr.getSkillFromConfig(skill_id)
			if (!cfg) {
				return
			}
			let skill_lv = 0
			let info = this.GetInnateInfo()
			let talent_skills = info && info.talent_skills
			if (talent_skills && talent_skills.length > 0) {
				for (let i in talent_skills) {

					if (talent_skills[i].skill_type == cfg.type) {
						cfg.point = talent_skills[i].point
						if (talent_skills[i].point == 0) {
							break
						}
						for (let _tmpi in talent_skills[i].skills) {
							var vo = talent_skills[i].skills[_tmpi]
							if (vo.skill_id == skill_id) {
								skill_lv = vo.skill_lv
								break
							}
						}
						break
					}
				}
			}
			cfg.skill_lv = skill_lv
			return cfg
		}

		// 更新上古禁术
		this.UpdateForbiddenSkillInfo = (info?) => {
			//this.forbbiden_skill_info = info
			//this:Fire(local_SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO)
		}

		// 初始化禁术类别
		this.InitForbiddenSkillCfg = (cfg?, config_arcana?) => {
			//if (cfg && config_arcana ) {
			//let career = role_mgr.mainRoleInfo.career
			//if (! forbbiden_skill_cfg_ || last_career != career ) {
			//last_career = career
			//forbbiden_skill_cfg_ = []
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.Normal] = []
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.ShenHun] = []
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.MoHun] = []
			//let vo = null
			//let tmp = null
			//for (let key in cfg) {

			//// [ts2lua]cfg下标访问可能不正确
			//vo = cfg[key]
			//if (vo.career == career && vo.lv == 1 ) {
			//// [ts2lua]config_arcana下标访问可能不正确
			//tmp = config_arcana[vo.id + "@" + vo.career]
			//if (tmp ) {
			//vo.arcana = tmp
			//vo.pos = tmp.pos
			//vo.core_type = tmp.core_type
			//if (tmp.is_core == 0 ) {
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//table.insert(forbbiden_skill_cfg_[local_ForbiddenSkillType.Normal], vo)
			//}else{
			//if (tmp.core_type == local_ForbiddenSkillType.ShenHun ) {
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//table.insert(forbbiden_skill_cfg_[local_ForbiddenSkillType.ShenHun], vo)
			//}else{
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//table.insert(forbbiden_skill_cfg_[local_ForbiddenSkillType.MoHun], vo)
			//}
			//}
			//}
			//}
			//}
			//let sort_fun = (a?, b?) => {
			//if (a.pos && b.pos ) {
			//return a.pos - b.pos
			//}
			//}

			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.Normal].sort(sort_fun)
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.ShenHun].GetInnateSkillIdByCfg(sort_fun)
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//forbbiden_skill_cfg_[local_ForbiddenSkillType.MoHun].sort(sort_fun)
			//}
			//}
		}

		// 获取上古禁术配置通过类别
		this.GetForbiddenSkillList = (cfg?, config_arcana?, _type?) => {
			//let career = role_mgr.mainRoleInfo.career
			//if (cfg ) {
			//this:InitForbiddenSkillCfg(cfg, config_arcana)
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//return forbbiden_skill_cfg_[_type]
			//}
		}

		// 上古禁术技能
		this.ForbiddenSkillByRuleId = (rule_id?) => {
			//let data = null
			//if ((this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list) && rule_id ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//if (vo.id == rule_id ) {
			//data = vo
			//break
			//}
			//}
			//}
			//return data
		}

		// 规则配置
		this.GetForbiddenSkillRuleCfg = (rule_cfg?, rule_id?, career?) => {
			//if (rule_cfg ) {
			//// [ts2lua]rule_cfg下标访问可能不正确
			//return rule_cfg[rule_id + "@" + career]
			//}
		}

		// 获取上古禁术等级配置
		this.GetForbiddenSkillLvCfg = (lv_cfg?, rule_id?, career?, level?) => {
			//if ((lv_cfg && rule_id) && level ) {
			//// [ts2lua]lv_cfg下标访问可能不正确
			//return lv_cfg[rule_id + "@" + career + "@" + level]
			//}
		}

		// 获取上古禁术某一规则的所有等级对应的技能描述列表
		this.GetForbiddenSkillAllLvDesc = (lv_cfg?, rule_id?, career?, level?, break_lv?) => {
			//let desc_list = null
			//if (((lv_cfg && rule_id) && level) && career ) {
			//desc_list = []
			//let list = []
			//let cfg = null
			//for (let key in lv_cfg) {

			//// [ts2lua]lv_cfg下标访问可能不正确
			//cfg = lv_cfg[key]
			//if (cfg.id == rule_id && cfg.career == career ) {
			//table.insert(list, cfg)
			//}
			//}
			//let sort_fun = (a?, b?) => {
			//return a.lv - b.lv
			//}

			//list:sort(sort_fun)
			//let skill_mgr = SkillManager.GetInstance()
			//let obj = null
			//let arr = null
			//let skill_id = null
			//let skill_lv = null
			//for (let _tmpi in list) {
			// var vo = list[_tmpi]
			//skill_id, skill_lv = this.GetRealSkillId(lv_cfg, rule_id, career, vo.lv, break_lv)
			//arr = skill_mgr.GetSkillFromConfigByIdAndLevelAndPower(skill_id, skill_lv)
			//if (arr ) {
			//obj = []
			//obj[0] = vo.lv
			//obj[1] = vo.skill_id
			//obj[2] = vo.skill_lv
			//obj[3] = arr[0]
			//table.insert(desc_list, obj)
			//}
			//}
			//}
			//return desc_list
		}

		// 获取突破配置
		this.GetBreakCfg = (rule_id?, career?, lv?) => {
			//let break_cfg = Config.config_arcana_break
			//if (((break_cfg && rule_id) && career) && lv != null ) {
			//// [ts2lua]break_cfg下标访问可能不正确
			//return break_cfg[rule_id + "@" + career + "@" + lv]
			//}
		}

		// 根据等级(本功能的规则等级)和突破等级获取真实的技能id
		this.GetRealSkillId = (lv_cfg?, rule_id?, career?, lv?, break_lv?) => {
			//let skill_id = null
			//let skill_lv = null
			//if (((lv_cfg && rule_id) && career) && lv != null ) {
			//let cfg = null
			//if (break_lv ) {
			//cfg = this.GetBreakCfg(rule_id, career, break_lv)
			//// [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			//skill_id = (cfg && ( cfg.break_skill_id ) || ( null ) )
			//cfg = this.GetForbiddenSkillLvCfg(lv_cfg, rule_id, career, lv)
			//// [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			//skill_lv = (cfg && ( cfg.skill_lv ) || ( null ) )
			//}else{
			//cfg = this.GetForbiddenSkillLvCfg(lv_cfg, rule_id, career, lv)
			//// [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			//skill_id = (cfg && ( cfg.skill_id ) || ( null ) )
			//// [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			//skill_lv = (cfg && ( cfg.skill_lv ) || ( null ) )
			//}
			//}
			//return {skill_id, skill_lv}
		}

		// 我拥有的等级
		this.GetMyForbiddenSkillLv = (rule_id?) => {
			//let lv = 0
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//if (vo.id == rule_id ) {
			//lv = vo.lv
			//break
			//}
			//}
			//}
			//return lv
		}

		// .我拥有的技能总等级
		this.GetMyForbiddenSkillAllLv = () => {
			//let all_lv = 0
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//all_lv = all_lv + vo.lv
			//}
			//}
			//return all_lv
		}

		this.ForbiddenSkillUpgradeSuccess = (id?) => {
			//let data = null
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//if (vo.id == id ) {
			//vo.lv=vo.lv+1
			//data = vo
			//break
			//}
			//}
			//}
			//if (! data ) {
			//skill_mgr:Fire(REQUEST_CCMD_EVENT, 21101)
			//this:Fire(local_SkillUIModel.FORBIDDEN_SKILL_UPGRADE_SUCCESS, false)
			//data = []
			//data.id = id
			//data.lv = 1
			//data.break_lv = 0
			//this:Fire(local_SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO, data)
			//}else{
			//this:Fire(local_SkillUIModel.FORBIDDEN_SKILL_UPGRADE_SUCCESS, true)
			//this:Fire(local_SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO, data)
			//this:ForbiddenSkillRedDot()
			//}
		}

		this.ForbiddenSkillBreakSuccess = (id?) => {
			//let data = null
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//if (vo.id == id ) {
			//vo.break_lv=vo.break_lv+1
			//data = vo
			//break
			//}
			//}
			//}
			//this:Fire(local_SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO, data)
			//this:ForbiddenSkillRedDot()
		}

		// .获取所有的技能展示
		this.GetAllShowList = (config_arcana_lv?, config_arcana?) => {
			//this:InitForbiddenSkillCfg(config_arcana_lv, config_arcana)
			//let list = []
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//list = table.merge(list, forbbiden_skill_cfg_[local_ForbiddenSkillType.Normal])
			//if (this.forbbiden_skill_info ) {
			//if (this.forbbiden_skill_info.core_type == local_ForbiddenSkillType.ShenHun ) {
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//list = table.merge(list, forbbiden_skill_cfg_[local_ForbiddenSkillType.ShenHun])
			//}else{
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//list = table.merge(list, forbbiden_skill_cfg_[local_ForbiddenSkillType.MoHun])
			//}
			//}else{
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//list = table.merge(list, forbbiden_skill_cfg_[local_ForbiddenSkillType.ShenHun])
			//// [ts2lua]forbbiden_skill_cfg_下标访问可能不正确
			//list = table.merge(list, forbbiden_skill_cfg_[local_ForbiddenSkillType.MoHun])
			//}
			//let sort_fun = (a?, b?) => {
			//let a_data = this.ForbiddenSkillByRuleId(a.id)
			//let b_data = this.ForbiddenSkillByRuleId(b.id)
			//// [ts2lua]lua中0和空字符串也是true，此处a_data需要确认
			//let a_active = (a_data && ( 1 ) || ( 0 ) )
			//// [ts2lua]lua中0和空字符串也是true，此处b_data需要确认
			//let b_active = (b_data && ( 1 ) || ( 0 ) )
			//if (a_active == b_active ) {
			//if (a.core_type == b.core_type ) {
			//return a.pos - b.pos
			//}else{
			//return a.core_type - b.core_type
			//}
			//}else{
			//return b_active - a_active
			//}
			//}

			//list:sort(sort_fun)
			//let len = list.length
			//let vo = null
			//let cfg = null
			//let i = len - 1
			//do {
			//vo = list[i]
			//if (vo ) {
			//cfg = skill_mgr.getSkillFromConfig(vo.skill_id)
			//if (cfg ) {
			//if (cfg.type != SkillVo.SkillType.Initiative ) {
			//list:splice(i, 1)
			//}
			//}
			//}
			//i=i-1
			//} while ((i >= 0))
			//return list
		}

		// 通过技能id获取规则配置
		this.GetRuleIdBySkillId = (config_arcana_lv?, skill_id?) => {
			//let cfg = null
			//let break_cfg = Config.config_arcana_break
			//if ((config_arcana_lv && break_cfg) && skill_id ) {
			//let career = role_mgr.mainRoleInfo.career
			//let tmp = null
			//for (let key in break_cfg) {

			//// [ts2lua]break_cfg下标访问可能不正确
			//tmp = break_cfg[key]
			//if (tmp.break_skill_id == skill_id && tmp.career == career ) {
			//// [ts2lua]break_cfg下标访问可能不正确
			//cfg = break_cfg[key]
			//break
			//}
			//}
			//if (! cfg ) {
			//for (let key in config_arcana_lv) {

			//// [ts2lua]config_arcana_lv下标访问可能不正确
			//tmp = config_arcana_lv[key]
			//if (tmp.skill_id == skill_id && tmp.career == career ) {
			//// [ts2lua]config_arcana_lv下标访问可能不正确
			//cfg = config_arcana_lv[key]
			//break
			//}
			//}
			//}
			//}
			//return cfg
		}

		// 获取突破前的技能id
		this.GetBeforeBreakSkillId = (break_skill_id?) => {
			let before_break_skill_id = null
			// let cfg = Config.config_arcana_break
			let cfg
			ResManager.GetInstance().LoadGameConfig(this, "config_arcana_break", false, null, (config) => {
				cfg = config
			});
			if (cfg) {
				let vo = null
				for (let key in cfg) {

					vo = cfg[key]
					if (vo.break_skill_id == break_skill_id) {
						before_break_skill_id = vo.skill_id
						break
					}
				}
			}
			return before_break_skill_id
		}

		// 获取突破后的技能id
		this.GetBreakSkillId = (before_break_skill_id?) => {
			let break_skill_id = null
			// let cfg = Config.config_arcana_break
			let cfg
			ResManager.GetInstance().LoadGameConfig(this, "config_arcana_break", false, null, (config) => {
				cfg = config
			});
			if (cfg) {
				let vo = null
				for (let key in cfg) {

					vo = cfg[key]
					if (vo.skill_id == before_break_skill_id) {
						break_skill_id = vo.break_skill_id
						break
					}
				}
			}
			return break_skill_id
		}

		// 是否在1， 2这两个特殊的位置上
		this.IsInSpecialPos = (skill_id?) => {
			//let is_special = false
			//if (skill_mgr.skill_bar_info && skill_id ) {
			//for (let _tmpi in skill_mgr.skill_bar_info) {
			// var vo = skill_mgr.skill_bar_info[_tmpi]
			//if (vo.skill_id == skill_id && (vo.pos == 1 || vo.pos == 2) ) {
			//is_special = true
			//break
			//}
			//}
			//}
			//return is_special
		}

		this.GetForbiddenSkillRedDot = () => {
			//return forbidden_skill_dot_ > 0
		}

		// 上古奥术技能红点
		this.ForbiddenSkillRedDot = () => {
			//this:GetGameConfig("config_arcana_lv",(config_arcana_lv?) => {
			//let show_dot = false
			//show_dot = (this.CanActiveForbiddenSkill(config_arcana_lv) || this.CanUpgradeForbiddenSkill(config_arcana_lv)) || this.CanBreakForbiddenSkill()
			//// [ts2lua]lua中0和空字符串也是true，此处show_dot需要确认
			//forbidden_skill_dot_ = (show_dot && ( 1 ) || ( 0 ) )
			//this:Fire(local_SkillUIModel.FORBIDDEN_SKILL_UPDATE_RED_DOT, show_dot)
			//local_GlobalEventSystem:Fire(REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			//this:DestoryGameConfig("config_arcana_lv")
			//}
			//, false)
		}

		// 技能是否可激活
		this.CanActiveForbiddenSkill = (lv_cfg?, rule_id?) => {
			//let can_active = false
			//if (! CommonManager.GetInstance().CheckFuncOpenState("ForbiddenSkillView", true) ) {
			//return false
			//}
			//if (lv_cfg ) {
			//let career = role_mgr.mainRoleInfo.career
			//let info = null
			//if (rule_id ) {
			//info = this.ForbiddenSkillByRuleId(rule_id)
			//if (! info ) {
			//let cfg = this.GetForbiddenSkillLvCfg(lv_cfg, rule_id, career, 1)
			//if (cfg ) {
			//let condition_list = ErlangParser.GetInstance().parse(cfg.condition)
			//can_active = this.ForbiddenSkillConditionIsEnough(condition_list)
			//}
			//}
			//}else{
			//let cfg = null
			//let my_info = null
			//for (let key in lv_cfg) {

			//// [ts2lua]lv_cfg下标访问可能不正确
			//cfg = lv_cfg[key]
			//if (cfg.lv == 1 && cfg.career == career ) {
			//can_active = this.CanActiveForbiddenSkill(lv_cfg, cfg.id)
			//if (can_active ) {
			//break
			//}
			//}
			//}
			//}
			//}
			//return can_active
		}

		// 奥术激活，升级，突破消耗是否足够
		this.ForbiddenSkillConditionIsEnough = (condition_list?) => {
			//let enough = null
			//if (condition_list ) {
			//for (let _tmpi in condition_list) {
			// var data = condition_list[_tmpi]
			//if (data[0] != "pre_skill" ) {
			//if (enough == null ) {
			//enough = true
			//}
			//if (data[0] == "arcana" ) {
			//if (Number(data[2]) > this.GetMyForbiddenSkillLv(data[1]) ) {
			//enough = false
			//}
			//} else if (data[0] == "arcana_lv" ) {
			//if (this.GetMyForbiddenSkillAllLv() < data[1] ) {
			//enough = false
			//}
			//} else if (data[0] == "cost" ) {
			//if (data[1] && data[1][0] ) {
			//let type_id, is_lock = goods_model.GetMappingTypeId(data[1][0][0], data[1][0][1])
			//let my_have = goods_model.GetTypeGoodsNum(type_id) || 0
			//enough = my_have >= Number(data[1][0][2])
			//}
			//}
			//if (! enough ) {
			//break
			//}
			//}
			//}
			//}
			//if (enough == null ) {
			//enough = false
			//}
			//return enough
		}

		// 技能是否可升级
		this.CanUpgradeForbiddenSkill = (lv_cfg?, vo?) => {
			//let can_upgrade = false
			//if (! CommonManager.GetInstance().CheckFuncOpenState("ForbiddenSkillView", true) ) {
			//return false
			//}
			//if (lv_cfg ) {
			//let career = role_mgr.mainRoleInfo.career
			//let info = null
			//if (vo ) {
			//let cfg = this.GetForbiddenSkillLvCfg(lv_cfg, vo.id, career, vo.lv + 1)
			//if (cfg ) {
			//let condition_list = ErlangParser.GetInstance().parse(cfg.condition)
			//can_upgrade = this.ForbiddenSkillConditionIsEnough(condition_list)
			//}
			//}else{
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//can_upgrade = this.CanUpgradeForbiddenSkill(lv_cfg, vo)
			//if (can_upgrade ) {
			//break
			//}
			//}
			//}
			//}
			//}
			//return can_upgrade
		}

		// 技能是否可突破
		this.CanBreakForbiddenSkill = (vo?) => {
			//let can_break = false
			//if (! CommonManager.GetInstance().CheckFuncOpenState("ForbiddenSkillView", true) ) {
			//return false
			//}
			//let config_arcana_break = Config.config_arcana_break
			//if (config_arcana_break ) {
			//let career = role_mgr.mainRoleInfo.career
			//let info = null
			//if (vo ) {
			//let cfg = this.GetBreakCfg(vo.id, career, vo.break_lv + 1)
			//if (cfg ) {
			//let condition_list = ErlangParser.GetInstance().parse(cfg.condition)
			//can_break = this.ForbiddenSkillConditionIsEnough(condition_list)
			//}
			//}else{
			//if (this.forbbiden_skill_info && this.forbbiden_skill_info.arcana_list ) {
			//for (let _tmpi in this.forbbiden_skill_info.arcana_list) {
			// var vo = this.forbbiden_skill_info.arcana_list[_tmpi]
			//can_break = this.CanBreakForbiddenSkill(vo)
			//if (can_break ) {
			//break
			//}
			//}
			//}
			//}
			//}
			//return can_break
		}

		this.GetInnateSkillIdByCfg = (cfg?) => {
			if (typeof (cfg) == "number" || typeof (cfg) == "string") {
				return cfg
			} else {
				let career = RoleManager.GetInstance().GetMainRoleCareer()
				return cfg[career - 1]
			}
		}

		this.GetCommonSkill = (career) => {

			let skill_ui_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigSkillUI
			let config_list = skill_ui_cfg && skill_ui_cfg.carrerSkillList[career]
			if (config_list) {
				let v
				for (let i in config_list) {
					v = config_list[i]
					if (v.common) {
						return v.skill_id
					}
				}
			}
		}


		let skill_list = null
		/***释放 降神技能tip */
		this.ReleaseGodBefallSkillTip = (god_id) => {
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigUISkillEffectShow["god"]
			if (!cfg || !cfg[god_id]) return

			PlayBigEffect(cfg[god_id], { x: 0, y: 1 }, null, 1)
		}

		/**释放 伙伴技能 */
		this.ReleasePartnerSkillTip = (skill_id) => {
			let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
			if (!skill_vo) return
			let skill_info = skill_vo.basic
			if (skill_info && skill_info.career == 52 && skill_info.is_passive == 0 && skill_info.is_normal == 0) {

				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigUISkillEffectShow["partner"]
				if (!cfg || !cfg[skill_id]) return
				PlayBigEffect(cfg[skill_id], { x: -8, y: 0 }, 3.5, 2)
			}

		}


		let cur_partner_id
		let cur_god_id
		/**预加载所需要的资源 */
		this.PreLoadSkillEffectRes = (partner_skill_id?, god_id?) => {
			let rescores = []
			if (partner_skill_id && partner_skill_id != cur_partner_id) {
				cur_partner_id = partner_skill_id

				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigUISkillEffectShow["partner"]
				if (cfg && cfg[partner_skill_id]) {
					table.insert(rescores, `${ResManager.GetInstance().cdn_res_path}resource/effect/objs/ui_effect/${cfg[partner_skill_id]}.lh`)
				}
			}

			if (god_id && god_id != cur_god_id) {
				cur_god_id = god_id

				let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigUISkillEffectShow["god"]
				if (cfg && cfg[god_id]) {
					table.insert(rescores, `${ResManager.GetInstance().cdn_res_path}resource/effect/objs/ui_effect/${cfg[god_id]}.lh`)
				}
			}

			if (rescores && rescores.length > 0) {
				//console.warn(rescores)
				Laya.loader.create(rescores)
			}

		}

	}
}


window["SkillUIModel"] = SkillUIModel