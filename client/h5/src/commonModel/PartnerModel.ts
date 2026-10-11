import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { VipModel } from "./VipModel"


export class PartnerModel extends EventDispatcher {
	public static Instance: PartnerModel

	public static REQUSET_SCMD = "REQUSET_SCMD"
	public static UPDATE_VIEW = "UPDATE_VIEW"
	public static UPDATE_FOLLOW = "UPDATE_FOLLOW"		//跟随状态更新
	public static UPDATE_NUCLEUS = "UPDATE_NUCLEUS"		//核心培养物更新
	public static UPDATE_UP_ACT = "UPDATE_UP_ACT"		//激活、升级红点更新
	public static UPDATE_REQUESE_STATUS = "UPDATE_REQUESE_STATUS"   //更新升级协议请求状态
	public static UP_LV_ANIMATION = "UP_LV_ANIMATION"    //升级动画
	public static FIGHTPROVIEW = "FIGHTPROVIEW"			//战力预览
	public static REQUSET_UP = "REQUSET_UP"				//升阶
	public static SELECTE_ID = "SELECTE_ID"              //界面选择伙伴
	public static REF_PARTNERSKILL = "REF_PARTNERSKILL"  //更新伙伴技能
	public static REF_REQUEST_STATUS = "REF_REQUEST_STATUS" //刷新升星协议请求状态
	public static UPDATE_STATE = "UPDATE_STATE" // 真正升一星
	public static UNLOCK_BIOG = "UNLOCK_BIOG" // 接触传记封印
	public static UPDATE_BIOG_RED = "UPDATE_BIOG_RED" // 传记红点

	public static Is_Requeste = false                    //升级请求状态

	public red_mgr = RedDotManager.GetInstance()
	public res_mgr = ResManager.GetInstance()
	public pre_ser_cfg = Config.PRELOAD_SERVER_CONFIG

	public info = null				//伙伴信息
	public sub_red = {}				//伙伴红点
	public all_partner_list = []	//所有伙伴列表

	public cfg_kv

	public constructor() {
		super()

		if (PartnerModel.Instance) {
			return
		}
		PartnerModel.Instance = this
	}

	public static GetInstance() {
		if (!PartnerModel.Instance) {
			new PartnerModel()
		}
		return PartnerModel.Instance
	}

	public InitConfig() {
		this.biog_unlock_obj = {}
		this.biog_lock_obj = {}
		this.biog_red_obj = {}
		this.cfg_kv = Config.PRELOAD_SERVER_CONFIG.config_companion_kv
		this.RefRed()
	}

	public GetPartnerList() {//获取所有伙伴列表（转换为数组形式）
		if (this.all_partner_list.length <= 0) {
			let all_cfgs = this.pre_ser_cfg.config_companion
			for (let i in all_cfgs) {
				let v = all_cfgs[i]
				this.all_partner_list.push(v)
			}
			this.all_partner_list.sort((a, b) => {
				return a.id - b.id
			})
		}

		return this.all_partner_list
	}

	public SetScmd14202(scmd?) {
		this.info = scmd
		this.UpdateUnlockList(this.info)
		this.RefRed()
	}

	public GetInfo() {
		return this.info
	}

	public GetInfoByID(id?) {
		id = Number(id)
		if (this.info && !Util.IsTableEmpty(this.info.companion_list)) {
			for (let k in this.info.companion_list) {
				let v = this.info.companion_list[k]
				if (v.companion_id == id) {
					return v
				}
			}
		}
		return null
	}

	//伙伴是否激活
	public PartnerIsActiveById(id?) {
		let active = false
		id = Number(id)
		if (this.info && !Util.IsTableEmpty(this.info.companion_list)) {
			for (let k in this.info.companion_list) {
				let v = this.info.companion_list[k]
				if (v.companion_id == id && v.is_active > 0) {
					active = true
					break
				}
			}
		}
		return active
	}

	public RefRed() {
		if (!this.cfg_kv) {
			return
		}

		this.sub_red = {}
		if (!CommonManager.GetInstance().CheckFuncOpenState("PartnerBaseView", true)) {
			return false
		}
		let stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_companion_stage
		let cfg = this.pre_ser_cfg.config_companion
		for (let k in cfg) {
			let v = cfg[k]
			let info = this.GetInfoByID(v.id)
			let active = info && info.is_active == 1
			let bool = false
			if (active) {
				this.SetSubRed(v.id, 1, false)
				let bool1 = this.RefRoundRed(v, info)
				let bool2 = this.RefUpRed(v, info, stage_cfg)
				bool = bool1 || bool2
			} else {
				bool = this.RefActiveRed(v)
			}
			this.red_mgr.SetRedStatus(ModuleType.PARTNER, Number(v.id), bool)
			RedDotController.ins.add(RedKey.PARTNER + Number(v.id), RedKey.PARTNER)
			RedDotController.ins.up(RedKey.PARTNER + Number(v.id), bool ? 1 : 0)
		}
		let bool = this.GetRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 2, bool)
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
		this.Fire(PartnerModel.UPDATE_UP_ACT)
	}

	//红点子类：1-激活，2-升星，3-培养物
	public GetRed(id?, sub_type?) {
		let bool: any = false
		if (id && sub_type) {
			bool = this.sub_red[id] && this.sub_red[id][sub_type]
		} else if (id) {
			bool = this.red_mgr.CheckRedStatus(ModuleType.PARTNER, Number(id))
		} else {
			bool = this.red_mgr.GetRedStatus(ModuleType.PARTNER)
			bool = bool && bool > 0
		}
		return bool
	}

	//某个伙伴子红点,1-激活，2-升星，3-培养物
	public SetSubRed(id?, sub_type?, bool?) {
		this.sub_red[id] = this.sub_red[id] || {}
		this.sub_red[id][sub_type] = bool
	}

	//激活红点
	public RefActiveRed(cfg?) {
		let bool = false
		if (cfg) {
			if (this.IsSpecialActive(cfg.id)) {
				bool = false
				let have_num = VipModel.GetInstance().all_recharge_record
				let need_num = this.GetSpecialActiveCost(cfg.id)
				bool = have_num >= need_num

			} else {
				let have_num = GoodsModel.GetInstance().GetTypeGoodsNum(cfg.goods_id)
				if (have_num >= Number(cfg.goods_num)) {
					bool = true
				}
			}
		}
		this.SetSubRed(cfg.id, 1, bool)
		return bool
	}

	//升星红点
	public RefUpRed(cfg, info, stage_cfg) {
		let bool = false
		if (cfg && !this.IsMaxLv(cfg.id)) {
			let key = cfg.id + "@" + info.stage + "@" + info.star
			let cur_stage_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_companion_stage.name, key, false, stage_cfg)
			if (cur_stage_cfg) {
				let have_num = GoodsModel.GetInstance().GetTypeGoodsNum(cfg.goods_id)
				let have_exp = have_num * cfg.single_exp
				if (info) {
					if (info.blessing + have_exp >= cur_stage_cfg.need_blessing) {
						bool = true
					}
				}
			}
		}
		this.SetSubRed(cfg.id, 2, bool)
		return bool
	}

	//培养物红点
	public RefRoundRed(cfg?, info?) {
		let bool = false
		if (cfg && (!info || info.train_num < cfg.train_limit)) {
			let have_num = GoodsModel.GetInstance().GetTypeGoodsNum(cfg.train_goods_id)
			if (have_num > 0) {
				bool = true
			}
		}
		this.SetSubRed(cfg.id, 3, bool)
		return bool
	}

	//刷新出战状态
	public UpdateFollowData(scmd?) {
		if (this.info) {
			this.info.fight_id = scmd.fight_id
			this.Fire(PartnerModel.UPDATE_FOLLOW)
		}
	}

	//刷新单个伙伴信息、走14201
	public RefOnePartner(scmd?) {
		if (this.info) {
			this.info.sum_attr = scmd.sum_attr
			this.info.fight_id = scmd.fight_id
			if (this.info && !Util.IsTableEmpty(this.info.companion_list)) {
				for (let k in this.info.companion_list) {
					let v = this.info.companion_list[k]
					if (v.companion_id == scmd.fight_id) {
						v.is_fight = 1
					} else {
						v.is_fight = 0
					}
					if (v.companion_id == scmd.companion_id) {
						v.stage = scmd.stage
						v.star = scmd.star
						v.is_active = scmd.is_active
						v.blessing = scmd.blessing
						v.train_num = scmd.train_num
						v.attr = scmd.attr
						v.combat = scmd.combat
					}
				}
			}
			this.RefRed()
		}
	}

	//是否满级
	public IsMaxLv(id?) {
		let maxStage = this.cfg_kv[6].value
		let maxstar = this.cfg_kv[7].value
		let info = this.GetInfoByID(id)
		if (info && info.stage >= maxStage && info.star >= maxstar) {
			return true
		}
		return false
	}

	//获取出战伙伴主动技能
	public GetSkill() {
		if (!this.info) { return [null, null] }
		let id = this.info.fight_id
		let cfg = this.pre_ser_cfg.config_companion[id]
		if (cfg && cfg.skill_list) {
			let skill_list = JSON.parse(cfg.skill_list)
			if (skill_list && !Util.IsTableEmpty(skill_list)) {
				let skill_cfg = SkillManager.GetInstance().getSkillFromConfig(Number(skill_list[0]))
				return [skill_cfg, skill_cfg && skill_cfg.id]
			}
		}
		return [null, null]
	}

	//获取出战伙伴普攻
	public GetAttackSkill() {
		if (!this.info) { return null }
		let id = this.info.fight_id
		let cfg = this.pre_ser_cfg.config_companion[id]
		if (cfg && cfg.attack_skill) {
			return cfg.attack_skill
		}
		return null
	}

	//获取伙伴自动释放技能状态
	public GetAutoStatus(id?) {
		let bool = false
		if (!id) { // id 为空,获取当前出战伙伴状态
			id = this.info && this.info.fight_id
		}
		if (id) {
			let _info = this.GetInfoByID(id)
			if (!_info) { return null }
			let cookie = CookieWrapper.GetInstance().GetCookie(`${CookieWrapper.PARTNER_AUTO_STATUS}${id}`, true)
			if (cookie) {
				bool = _info.is_active == 1 && Number(cookie) == 1
			}
		}
		return bool
	}

	//设置伙伴自动释放技能状态
	public SetAutoStatus(id?, value?) {
		if (!id) { return }
		CookieWrapper.GetInstance().SaveCookie(`${CookieWrapper.PARTNER_AUTO_STATUS}${id}`, value ? 1 : 0, true)
		return null
	}

	//是否特殊激活伙伴
	public IsSpecialActive(id?) {
		let list = this.cfg_kv[11].value
		list = JSON.parse(list)
		if (list) {
			for (let k in list) {
				let v = list[k]
				if (Number(v) == id) {
					return true
				}
			}
		}
	}

	//特殊激活伙伴钻石数量
	public GetSpecialActiveCost(id?) {
		let list = this.cfg_kv[11].value
		let cost_list = this.cfg_kv[12].value
		list = JSON.parse(list)
		cost_list = JSON.parse(cost_list)
		if (list) {
			for (let k in list) {
				let v = list[k]
				if (Number(v) == id) {
					return Number(cost_list[k])
				}
			}
		}
	}

	//根据培养物获取伙伴id
	public GetIDByRound(round_id?) {
		let cfg = this.pre_ser_cfg.config_companion
		if (cfg) {
			for (let _ in cfg) {
				let v = cfg[_]
				if (v.train_goods_id == round_id) {
					return v.id
				}
			}
		}
		return null
	}

	/**解锁传记对应的等级 */
	biog_lock_obj = {}
	/**已经解锁的传记id */
	biog_unlock_obj = {}
	/**保存红点状态 */
	biog_red_obj = {}
	/**
	 * 传记到什么阶段解锁
	 * @param id  伙伴id
	 * @param c_id  传记id
	 */
	public GetBiogUnLockData(companion_id, biog_id) {
		let key_ = companion_id + "@" + biog_id
		if (!this.biog_lock_obj[key_]) {
			let stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_companion_stage
			let max_stage = 10
			let max_star = 10
			let lv_data = [10, 10]
			let is_break = false
			for (let stage = 1; stage <= max_stage; stage++) {
				//star 从0开始 0星
				for (let star = 0; star <= max_star; star++) {
					let key = companion_id + "@" + stage + "@" + star
					let cur_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfg)
					if (cur_cfg && cur_cfg.biography == biog_id) {
						is_break = true
						lv_data = [stage, star]
						break;
					}
				}
				if (is_break) break;
			}
			this.biog_lock_obj[key_] = lv_data
		}
		return this.biog_lock_obj[key_]
	}
	/**
	 * 传记是否解锁  0未解锁  1 待解锁 2解锁
	 * @param id  伙伴id
	 * @param c_id  传记id
	 */
	public CheckIsUnlockBiog(companion_id, biog_id) {
		let info = this.GetInfoByID(companion_id)
		if (!info) return 0
		let is_open = this.biog_unlock_obj[companion_id] && this.biog_unlock_obj[companion_id][biog_id] ? true : false //是否已经解锁
		if (is_open) {
			return 2
		} else {
			let arr = PartnerModel.GetInstance().GetBiogUnLockData(companion_id, biog_id)
			if (info.stage > arr[0]) {
				return 1
			}
			if (info.stage == arr[0] && info.star >= arr[1]) {
				return 1
			}
		}
		return 0
	}
	/**
	 * 保存解锁的传记等级
	 * @param info 
	 * @returns 
	 */
	public UpdateUnlockList(info) {
		if (!info) return
		let companion_list = info.companion_list || []
		for (let i = 0; i < companion_list.length; i++) {
			let companion_id = companion_list[i].companion_id
			let biog_list = companion_list[i].biog_list
			for (let k = 0; k < biog_list.length; k++) {
				let biog_id = biog_list[k].lv
				if (!this.biog_unlock_obj[companion_id]) {
					this.biog_unlock_obj[companion_id] = {}
				}
				this.biog_unlock_obj[companion_id][biog_id] = 1
			}
		}
	}
	/**
	 * （解封单个）保存解锁的传记等级
	 * @param companion_id 
	 * @param biog_id 
	 */
	public SaveBiogLockStatus(companion_id, biog_id) {
		if (!this.biog_unlock_obj[companion_id]) {
			this.biog_unlock_obj[companion_id] = {}
		}
		this.biog_unlock_obj[companion_id][biog_id] = 1
		if (this.biog_red_obj[companion_id] && this.biog_red_obj[companion_id][biog_id]) {
			this.biog_red_obj[companion_id][biog_id] = 0
			this.Fire(PartnerModel.UPDATE_BIOG_RED)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
		}
	}
	/**
	 * 是否有待解锁的传记
	 */
	public UpdateCompanionBiogRed() {
		this.biog_red_obj = {}
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigCompanionBiog
		for (let kry in cfg) {
			let biog_list_ = cfg && cfg[kry] || []
			for (let i = 0; i < biog_list_.length; i++) {
				let c_id = Number(kry)
				if (!this.biog_red_obj[c_id]) {
					this.biog_red_obj[c_id] = {}
				}
				if (this.CheckIsUnlockBiog(c_id, biog_list_[i].id) == 1) {
					this.biog_red_obj[c_id][biog_list_[i].id] = 1
				} else {
					this.biog_red_obj[c_id][biog_list_[i].id] = 0
				}
			}
		}
		this.Fire(PartnerModel.UPDATE_BIOG_RED)
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
	}
	/**
	 * 检查红点
	 * @param companion_id 
	 * @param biog_id 
	 */
	public CheckCompanionBiogRed(companion_id, biog_id) {
		if (this.biog_red_obj[companion_id] && this.biog_red_obj[companion_id][biog_id]) {
			return this.biog_red_obj[companion_id][biog_id]
		}
		return 0
	}
	/**
 * 检查某个契灵所有传记红点
 * @param companion_id 
 * @param biog_id 
 */
	public CheckCompanionRed(companion_id) {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigCompanionBiog
		let biog_list_ = cfg && cfg[companion_id] || []
		for (let i = 0; i < biog_list_.length; i++) {
			if (this.CheckCompanionBiogRed(companion_id, biog_list_[i].id)) {
				return true
			}
		}
		return false
	}
	/**
 * 检查所有传记红点
 * @param companion_id 
 * @param biog_id 
 */
	public CheckAllCompanionRed() {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigCompanionBiog
		for (let kry in cfg) {
			let biog_list_ = cfg && cfg[kry] || []
			for (let i = 0; i < biog_list_.length; i++) {
				if (this.CheckCompanionBiogRed(kry, biog_list_[i].id)) {
					return true
				}
			}
		}
		return false
	}
	/**
	 * 契灵传记解封奖励
	 */
	public GetBiogLockReward(companion_id, biog_id) {
		let arr = this.GetBiogUnLockData(companion_id, biog_id)
		let key = companion_id + "@" + arr[0] + "@" + arr[1]
		let stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_companion_stage
		let cur_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfg)
		let rewards=[]
		if (cur_cfg&&cur_cfg.other) {
			let others = ErlangParser.GetInstance().parse(cur_cfg.other)
			for(let i= 0;i<others.length;i++){
				if(others[i][0]=="biog_reward"){
					rewards = others[i][1]
				}
			}
		}
		return rewards
	}
}

window["PartnerModel"] = PartnerModel