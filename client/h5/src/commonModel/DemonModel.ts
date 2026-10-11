import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { SkillVo } from "../skill/SkillVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { IsInTable } from "../util/Util"
import { DemonData } from "./DemonData"
import { DemonDefine } from "./DemonDefine"
import { DemonEvent } from "./DemonEvent"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { Config } from "../common/Config"

export class DemonModel extends EventDispatcher {
	static Instance: DemonModel;

	static RedFlag = {
		Level: 0x001, 	//升级
		Star: 0x002, 	//升星
		Skill: 0x004, 	//升级技能
		Rotary: 0x008,	//激活
		Painting: 0x0010,	//上卷
		Talent: 0x0020,	//天赋
		Shop: 0x0040,	//黑市
		LifeSkill: 0X0080
	}

	bless_value
	common_mgr
	demons_data_dic
	demons_level_red
	demons_life_skill_red
	demons_power
	demons_rotary_red
	demons_skill_red
	demons_star_red
	demons_talent_fight
	demons_talent_red
	fetters_data
	goods_model
	res_mgr: ResManager
	goods_talent_fight
	level_up_materials
	not_show_talent_replace_skill_tips
	not_show_talent_shop_tips
	painting_data
	red_flag
	resource_dic
	talent_shop_first_open_tips
	unlock_talent_slot_cond
	_talenShopData


	select_demon_data
	select_slot

	public constructor() {
		super()
		if (DemonModel.Instance != null) {
			return
		}
		DemonModel.Instance = this

		this.not_show_talent_replace_skill_tips = false
		this.not_show_talent_shop_tips = false
		this.talent_shop_first_open_tips = false

		this.common_mgr = CommonManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
	}

	public InitData() {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_demons_value
		let demons_cfgs = Config.PRELOAD_SERVER_CONFIG.config_demons
		this.InitMaterials(cfg)
		this.InitDemonsResource(demons_cfgs)
		this.InitUnLockSlotCond(cfg)
	}

	public ResetData() {
		this.demons_data_dic = null
		this.demons_power = null
		this.painting_data = null
		this.fetters_data = null

		this.demons_star_red = null
		this.demons_skill_red = null
		this.demons_level_red = null
		this.demons_life_skill_red = null
		this.demons_talent_red = null

		this.demons_talent_fight = {}
		this.goods_talent_fight = {}

		this.red_flag = 0

		this.bless_value = 0
	}

	public SetDemonsList(demons_list?) {
		let demons_cfg, demons_level_cfg, demons_star_cfg
		let callback = () => {
			if (demons_cfg && demons_level_cfg && demons_star_cfg) {
				for (let _tmpi in demons_list) {
					let vo = demons_list[_tmpi]
					this.SetDemonData(vo, demons_cfg, demons_level_cfg, demons_star_cfg)
				}
				this.RefreshStarRed(demons_cfg, demons_star_cfg)
				this.RefreshLevelRed(demons_level_cfg)

				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_painting", (cfg) => {
					this.RefreshPaintingReward(cfg)
				}, false)

				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_skill", (cfg) => {
					this.RefreshLifeSkillRed(cfg)
				}, false)
				// this.RefreshSkillUpRed()
				this.RefreshTalentRed()
				this.Fire(DemonEvent.UPDATE_DEMONS_LIST)
			}
		}

		this.res_mgr.GetGameConfigWithAutoDestory("config_demons", (cfg1) => {
			demons_cfg = cfg1
			this.res_mgr.GetGameConfigWithAutoDestory("config_demons_level", (cfg2) => {
				demons_level_cfg = cfg2
				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_star", (cfg3) => {
					demons_star_cfg = cfg3
					callback()
				}, false)
			}, false)
		}, false)

	}

	public SetDemonData(data, demons_cfg, demons_level_cfg, demons_star_cfg) {
		if (!this.demons_data_dic) {
			this.demons_data_dic = {}
		}
		let demon_data: DemonData = this.GetDemonData(data.demons_id)
		if (!demon_data) {
			demon_data = new DemonData(data, demons_cfg, demons_level_cfg, demons_star_cfg)
			this.demons_data_dic[data.demons_id] = demon_data
		} else {
			demon_data.RefreshData(data, demons_level_cfg, demons_star_cfg)
			demon_data.RefreshSkillData(data.skill_list)
		}
		demon_data.RefreshLevelAttr(demons_level_cfg)
		demon_data.RefreshStarAttr(demons_star_cfg)

		this.Fire(DemonEvent.UPDATE_DEMON_DATA, data.demons_id)
	}

	public GetDemonData(demon_id?) {
		return this.demons_data_dic && this.demons_data_dic[demon_id]
	}

	public GetDemonsList() {
		return this.demons_data_dic
	}

	public SetDemonPower(demon_id?, power?) {
		if (!this.demons_power) {
			this.demons_power = {}
		}

		this.demons_power[demon_id] = power
		this.Fire(DemonEvent.UPDATE_DEMONS_POWER, demon_id)
	}

	public GetDemonPower(demon_id?) {
		return this.demons_power && this.demons_power[demon_id]
	}

	public GetLevelUpMaterial(type?) {
		return this.level_up_materials && this.level_up_materials[Number(type)]
	}

	public SetPaintingData(scmd?) {
		this.painting_data = scmd
		this.Fire(DemonEvent.UPDATE_PAINTING_DATA, scmd)
	}

	public GetPaintingData() {
		return this.painting_data
	}

	public GetTotalStarCount() {
		let count = 0
		if (this.demons_data_dic) {
			for (let key in this.demons_data_dic) {
				let value = this.demons_data_dic[key]
				if (value && value.star >= 3) {
					count = count + value.star
				}
			}
		}
		return count
	}

	public SetFettersData(scmd?) {
		this.fetters_data = {}
		for (let _tmpi in scmd.fetters_list) {
			let fetters_vo = scmd.fetters_list[_tmpi]
			this.fetters_data[fetters_vo.fetters_id] = true
		}
		this.Fire(DemonEvent.UPDATE_FETTERS_DATA)
	}

	public GetFettersState(fetters_id?) {
		let bool = false
		if (this.fetters_data && this.fetters_data[fetters_id]) {
			bool = true
		}
		return bool
	}

	public GetDemonsSkilllv(demons_id?, skill_id?) {
		let demon_data = this.GetDemonData(demons_id)
		if (demon_data) {
			return demon_data.GetSkillLevel(skill_id)
		}
	}

	public GetDemonAttr(demon_id?) {
		let attr_dic = {}
		let demon_data = this.GetDemonData(demon_id)
		if (demon_data) {
			let level_attr = demon_data.level_attr
			let star_attr = demon_data.star_attr
			for (let attr_id in level_attr) {
				attr_dic[attr_id] = level_attr[attr_id]
			}
			for (let attr_id in star_attr) {
				if (attr_dic[attr_id]) {
					attr_dic[attr_id] = attr_dic[attr_id] + star_attr[attr_id]
				} else {
					attr_dic[attr_id] = star_attr[attr_id]
				}
			}
		}
		return attr_dic
	}

	public InitMaterials(demons_value_cfg) {
		this.level_up_materials = {}
		let info = JSON.parse(demons_value_cfg[2].value)
		for (let _tmpi in info) {
			let vo = info[_tmpi]
			this.level_up_materials[Number(vo[0])] = vo[1]
		}
	}

	public InitDemonsResource(demons_cfg) {
		if (!this.resource_dic) {
			this.resource_dic = {}
		}
		let value
		for (let demons_id in demons_cfg) {
			value = demons_cfg[demons_id]
			this.resource_dic[demons_id] = value.resource
		}
	}

	public InitUnLockSlotCond(demons_value_cfgs) {
		let conds = JSON.parse(demons_value_cfgs[10].value)
		this.unlock_talent_slot_cond = []
		for (let _ in conds) {
			let data = conds[_]
			this.unlock_talent_slot_cond[Number(data[0]) - 1] = Number(data[1][1])
		}

	}

	public GetResource(demon_id?) {
		return this.resource_dic && this.resource_dic[demon_id]
	}

	public IsActive(demon_id?) {
		let bool = false
		if (this.GetDemonData(demon_id)) {
			bool = true
		}
		return bool
	}

	public SetRedFlag(flag?, state?) {
		if (!flag) {
			return
		}
		let now_flag = 0
		if (state) {
			now_flag = this.red_flag | flag
		} else {
			now_flag = this.red_flag & ~flag
		}
		if (now_flag == this.red_flag) {
			return
		}

		this.red_flag = now_flag

		if (flag == DemonModel.RedFlag.Painting) {
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DemonSecondView", DemonDefine.SecondViewIndex.Painting, state)
		} else if (flag == DemonModel.RedFlag.Shop) {
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DemonSecondView", DemonDefine.SecondViewIndex.Shop, state)
		}

		this.Fire(DemonEvent.REFRESH_RED_FLAG, flag)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 3, this.GetRedState())
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
	}

	//是否包含指定flag
	public HasRedFlag(flag?) {
		if (!flag) {
			return false
		}
		return ((this.red_flag & flag) != 0)
	}

	public GetRedState() {
		return this.common_mgr.CheckFuncOpenState("DemonMainView", true) ? this.red_flag > 0 : false
	}

	public CanLevelUp(demon_id, demons_level_cfg) {
		let bool = false
		let demon_data = this.GetDemonData(demon_id)
		if (demon_data) {
			let next_level_cfg = demons_level_cfg[demon_data.realm + "@" + (demon_data.level + 1)]
			let have_exp = 0
			let now_exp = demon_data.exp
			if (next_level_cfg) {
				let material_dic = this.GetLevelUpMaterial(demon_data.realm)
				let add_exp
				let count
				for (let _tmpi in material_dic) {
					let vo = material_dic[_tmpi]
					add_exp = vo[1]
					count = this.goods_model.GetTypeGoodsNum(vo[0])
					have_exp = have_exp + add_exp * count
				}
				if (have_exp >= (next_level_cfg.exp - now_exp)) {
					bool = true
				}
			}
		}
		return bool
	}

	public CanStarUp(demon_id, demons_star_cfg) {
		let bool = false
		let demon_data = this.GetDemonData(demon_id)
		let star = 0
		if (demon_data) {
			star = demon_data.star + 1
		}

		let next_star_cfg = demons_star_cfg[demon_id + "@" + star]
		let cost = next_star_cfg && JSON.parse(next_star_cfg.cost)
		if (cost && cost[0]) {
			cost = cost[0]
			let my_count = this.goods_model.GetTypeGoodsNum(cost[1])
			let need_count = cost[2]
			bool = my_count >= need_count
		}
		return bool
	}

	public CanSkillUp(skill_id, skill_lv, demons_skill_upgrade_cfgs) {
		let bool = false
		let skill_upgrade_cfgs = demons_skill_upgrade_cfgs[skill_id + "@" + (skill_lv + 1)]
		let cost = skill_upgrade_cfgs && JSON.parse(skill_upgrade_cfgs.cost)
		if (cost && cost[0]) {
			cost = cost[0]
			let my_count = this.goods_model.GetTypeGoodsNum(cost[1])
			let need_count = cost[2]
			bool = my_count >= need_count
		}
		return bool
	}

	public CanActivating(demon_id, demons_star_cfg) {
		let bool = false
		let demon_data = this.GetDemonData(demon_id)
		if (!demon_data) {
			let star_cfg = demons_star_cfg[demon_id + "@0"]
			let cost = star_cfg && JSON.parse(star_cfg.cost)
			if (cost && cost[0]) {
				cost = cost[0]
				let my_count = this.goods_model.GetTypeGoodsNum(cost[1])
				let need_count = cost[2]
				bool = my_count >= need_count
			}
		}
		return bool
	}

	public RefreshLevelRed(demons_level_cfgs) {
		let level_bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open) {
			if (!this.demons_level_red) {
				this.demons_level_red = {}
			}
			let demons_datas = this.GetDemonsList()
			let bool
			let last_bool
			if (demons_datas) {
				for (let demons_id in demons_datas) {
					bool = this.CanLevelUp(demons_id, demons_level_cfgs)
					last_bool = this.demons_level_red[demons_id]
					if (bool != last_bool) {
						this.demons_level_red[demons_id] = bool
						this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Level, demons_id)
					}
					if (!level_bool && bool) {
						level_bool = true
					}
				}
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.Level, level_bool)
		RedDotController.ins.up(RedKey.DEMON_LEVEL, level_bool ? 1 : 0)
	}

	public RefreshStarRed(demons_cfg, demons_star_cfgs) {
		let star_bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open) {
			if (!this.demons_star_red) {
				this.demons_star_red = {}
			}
			//let demons_datas = this.GetDemonsList()
			let bool
			let last_bool
			if (demons_cfg) {
				for (let demons_id in demons_cfg) {
					bool = this.CanStarUp(demons_id, demons_star_cfgs)
					last_bool = this.demons_star_red[demons_id]
					if (bool != last_bool) {
						this.demons_star_red[demons_id] = bool
						this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Star, demons_id)
					}
					if (!star_bool && bool) {
						star_bool = true
					}
				}
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.Star, star_bool)
		RedDotController.ins.up(RedKey.DEMON_STAR, star_bool ? 1 : 0)
	}

	public RefreshSkillUpRed(demons_skill_upgrade_cfgs) {
		let skill_bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open && this.demons_data_dic) {
			if (!this.demons_skill_red) {
				this.demons_skill_red = {}
			}
			let demon_data
			let bool = false
			let last_bool = false
			for (let demons_id in this.demons_data_dic) {
				demon_data = this.demons_data_dic[demons_id]
				if (demon_data) {
					for (let skill_id in demon_data.skill_dic) {
						let vo = demon_data.skill_dic[skill_id]
						bool = this.CanSkillUp(skill_id, vo.skill_lv, demons_skill_upgrade_cfgs)
						last_bool = this.demons_skill_red[skill_id]
						if (bool != last_bool) {
							this.demons_skill_red[skill_id] = bool
							this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Skill, skill_id)
						}
						if (!skill_bool && bool) {
							skill_bool = true
						}
					}
				}
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.Skill, skill_bool)
		RedDotController.ins.up(RedKey.DEMON_SKILL, skill_bool ? 1 : 0)
	}

	public RefreshPaintingReward(demons_painting_cfgs) {
		let bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		let data = this.GetPaintingData()
		if (open && data) {
			let count = this.GetTotalStarCount()
			let get_dic = {}
			let show_data
			let reward_list = []
			let is_all_get = true
			for (let _tmpi in data.painting_get) {
				let vo = data.painting_get[_tmpi]
				get_dic[vo.painting_id] = true
			}
			for (let painting_id in demons_painting_cfgs) {
				show_data = demons_painting_cfgs[painting_id]
				if (!get_dic[painting_id]) {
					is_all_get = false
					break
				}
			}
			if (!is_all_get) {
				bool = count >= show_data.painting_num
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.Painting, bool)
		RedDotController.ins.up(RedKey.DEMON_PAINTING, bool ? 1 : 0)
	}

	public RefreshLifeSkillRed(demons_skill_cfgs) {
		let life_skill_bool = false

		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open && this.demons_data_dic) {
			if (!this.demons_life_skill_red) {
				this.demons_life_skill_red = {}
			}
			let demon_data
			let bool = false
			let last_bool = false
			for (let demon_id in this.demons_data_dic) {
				let demon_data = this.demons_data_dic[demon_id]
				if (demon_data) {
					bool = this.LifeSkillCanActivation(demon_id, demons_skill_cfgs)
					last_bool = this.demons_life_skill_red[demon_id]
					if (bool != last_bool) {
						this.demons_life_skill_red[demon_id] = bool
						this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.LifeSkill, demon_id)
					}
					if (!life_skill_bool && bool) {
						life_skill_bool = true
					}
				}
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.LifeSkill, life_skill_bool)
		RedDotController.ins.up(RedKey.DEMON_LIFESKILL, life_skill_bool ? 1 : 0)
	}

	public LifeSkillCanActivation(demon_id, demons_skill_cfgs) {
		let demon_data: DemonData = this.GetDemonData(demon_id)
		let bool = false
		if (demon_data) {
			let life_skill_data = demon_data.GetLifeSkillData(demons_skill_cfgs)
			if (life_skill_data && life_skill_data.is_active == 0) {
				let skill_cfg = demons_skill_cfgs[demon_id + "@" + life_skill_data.skill_id]
				let max_process = this.GetLifeSkillMaxProgress(demon_id, life_skill_data.skill_id, demons_skill_cfgs)
				bool = life_skill_data.process >= max_process
			}
		}
		return bool
	}

	/**获得妖灵生活技能 最大进度值*/
	public GetLifeSkillMaxProgress(demon_id, skill_id, demons_skill_cfgs) {
		let skill_cfg = demons_skill_cfgs[demon_id + "@" + skill_id]
		let max_process = 0
		if (skill_cfg) {
			let cond = JSON.parse(skill_cfg.usage)
			if (cond && cond[0]) {
				cond = cond[0]
				if (IsInTable(cond[1], DemonDefine.LifeSkillSpecialKeyList)) {
					max_process = Number(cond[2][1])
				} else {
					max_process = Number(cond[2])
				}
			}
		}
		return max_process
	}



	public HaveLifeSkillBeenActivated(demon_id, demons_skill_cfgs) {
		let demon_data: DemonData = this.GetDemonData(demon_id)
		let bool = false
		if (demon_data) {
			let life_skill_data = demon_data.GetLifeSkillData(demons_skill_cfgs)
			if (life_skill_data) {
				bool = life_skill_data.is_active == 1
			}
		}
		return bool
	}

	public GetTalentCfgByTypeId(typeId, demons_skill_add_cfgs) {
		for (let key in demons_skill_add_cfgs) {
			let cfg = demons_skill_add_cfgs[key]
			if (cfg.goods_id == typeId) {
				return cfg
			}
		}
	}

	public GetTalentData(index?, data?) {
		for (let key in data) {
			let info = data[key]
			if (info.slot == index) {
				return info
			}
		}
	}

	public SetTalentFight(data?) {
		if (data.sign != 0) {
			this.demons_talent_fight[data.demons_id + "@" + data.sk_id + "@" + data.sign + "@" + data.sk_lv] = data
		} else {
			this.goods_talent_fight[data.sk_id + "@" + data.sk_lv] = data
		}
		this.Fire(DemonEvent.TALENT_FIGHT_RETURN, data.sign, data.sk_id, data.sk_lv)
	}

	public GetTalentFight(demons_id, sign, skill_id, lv = 1, goods_id) {
		let data
		let sk_id
		let sendSign = 0
		if (sign != 0) {
			data = this.demons_talent_fight[demons_id + "@" + skill_id + "@" + sign + "@" + lv]
			sk_id = skill_id
			sendSign = 1
		} else {
			data = this.goods_talent_fight[skill_id + "@" + lv]
			sk_id = goods_id
		}
		if (!data) {
			this.Fire(DemonEvent.REQUEST_PROTO, 18314, demons_id, sendSign, sk_id, lv)
		} else {
			return data
		}
	}

	public UpTalent(data?) {
		let demon_data = this.GetDemonData(data.demons_id)
		demon_data.talent_dic[data.slot] = {
			sk_id: data.skill_id,
			sk_lv: data.leve,
			slot: data.slot,
			quality: data.quality,
			sort: data.sort
		}
		this.Fire(DemonEvent.TALENT_UP_RETURN, data.demons_id, data.slot)
		this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Talent, data.demons_id)
		this.RefreshTalentRed()
	}

	public SetTalenShopData(data?) {
		this._talenShopData = data
		this.Fire(DemonEvent.TALENT_SHOP_DATA_RETURN)
	}

	public GetTalenGoodsNum(typeId?) {
		let id = Number(typeId)
		let theNum = 0
		if (id < 1) {
			return 0
		}
		let list = this.goods_model.demontalent_bag_type_dic[typeId] || {}
		for (let _tmpi in list) {
			let vo = list[_tmpi]
			if (vo.expire_time == 0 || vo.expire_time - TimeUtil.getServerTime() > 0) {
				theNum = theNum + vo.goods_num
			}
		}
		return theNum
	}

	public CheckShopRare(cfg_demons_skill_add) {
		let list = this._talenShopData.shop
		for (let key in list) {
			let shopData = list[key]
			let talentConf = this.GetTalentCfgByTypeId(shopData.goods_id, cfg_demons_skill_add)
			if (talentConf) {
				if (talentConf.quality >= 4 && shopData.buy_num < shopData.can_buy_num) {
					return true
				}
			}
		}
		return false
	}

	/**
	 * 一个妖灵不同的技能天赋只能学习一次
	 * @param demon_data 
	 * @param quality 
	 * @param sort 
	 * @param skill_id 
	 * @param slot 
	 * @returns 
	 */
	public DemonTalentKind(demon_data?, quality?, sort?, skill_id?, slot?) {
		let talent_dic = demon_data && demon_data.talent_dic
		if (talent_dic) {
			for (let key in talent_dic) {
				let talent = talent_dic[key]
				if (((slot == talent.slot && talent.sk_id != skill_id) || slot != talent.slot)
					&& talent.quality == quality
					&& talent.sort == sort) {
					return true
				}
			}
		}
		return false
	}

	/**
	 * 检查是否有可升级、可学习的天赋技能
	 * @param type_id 			需要检查的技能书id
	 * @param slot 				天赋孔位 0下标
	 * @param demon_id 			妖灵id
	 * @param talent_cfgs 		技能配置
	 * @param only_check_quality 检查技能是否比已有的技能品质更好
	 * @returns 
	 */
	public TalentSelectRedDot(type_id, slot, demon_id, talent_cfgs, only_check_quality?) {
		let demon_data = this.GetDemonData(demon_id)
		let talent_data = demon_data.GetTalentData(slot)
		let cfg = this.GetTalentCfgByTypeId(type_id, talent_cfgs)
		let skill_vo = new SkillVo(cfg.skill_id)

		//是否是同种技能
		let is_study = talent_data && talent_data.sk_id == cfg.skill_id
		let lv = 1
		let max = false
		let need_count = 0
		if (is_study) {
			lv = talent_data.sk_lv
		}

		if (skill_vo) {
			//判断技能是否可学习或者可升级
			let next_lv = lv + 1
			let lv_data = skill_vo.getLevelVo(next_lv)
			max = is_study && !lv_data
			if (lv_data) {
				let conf = ErlangParser.GetInstance().parse(lv_data.condition)
				let arr = conf && conf[0] || [0, 0, 0]
				need_count = Number(arr[2])
			}
		}

		//检查品质  
		let quality_cond = true
		if (talent_data && !is_study) {
			quality_cond = talent_cfgs[cfg.skill_id].quality > talent_cfgs[talent_data.sk_id].quality
		}



		let num = this.GetTalenGoodsNum(type_id)
		let is_kind = this.DemonTalentKind(demon_data, cfg.quality, cfg.sort, cfg.skill_id, slot)//一个妖灵不能重复学习同样的技能
		let is_empty = !talent_data //未学习状态
		let is_can_up = is_study && !max //已经学习的状态下  技能天赋可升级
		let is_enough = num >= need_count //学习或升级天赋所需要的道具数量
		return !is_kind && (is_empty || is_can_up || only_check_quality) && is_enough && quality_cond
	}

	public TalentSlotRedDot(demon_id, slot, talent_cfgs) {
		let list = this.goods_model.demontalent_bag_list
		for (let key in list) {
			let goodsVo = list[key]
			let flag = this.TalentSelectRedDot(goodsVo.type_id, slot, demon_id, talent_cfgs)
			if (flag) {
				return true
			}
		}
		return false
	}

	/**可学习新的技能书 
	 * @param demon_id    妖灵id
	 * @param talent_cfgs 配置cfg_demons_skill_add
	 * @param slot        专门检查某个孔位是否有学习技能
	*/
	public DemonTalentRedDot(demon_id, talent_cfgs, cus_slot?) {
		let demon_data = this.GetDemonData(demon_id)
		if (demon_data) {

			if (cus_slot == null) {
				for (let slot = 0; slot < demon_data.slot_num; slot++) {
					let flag = this.TalentSlotRedDot(demon_id, slot, talent_cfgs)
					if (flag) {
						return true
					}

				}
			} else {
				return this.TalentSlotRedDot(demon_id, cus_slot, talent_cfgs)
			}

		}
		return false
	}

	public RefreshTalentRed() {
		let talent_cfgs = Config.PRELOAD_SERVER_CONFIG.config_demons_skill_add
		let talent_bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open && this.demons_data_dic) {
			if (!this.demons_talent_red) {
				this.demons_talent_red = {}
			}
			let bool = false
			let last_bool = false
			for (let demon_id in this.demons_data_dic) {
				let demon_data = this.demons_data_dic[demon_id]
				if (!this.demons_talent_red[demon_id]) {
					this.demons_talent_red[demon_id] = {}
				}
				for (let slot = 0; slot < demon_data.slot_num; slot++) {
					last_bool = this.demons_talent_red[demon_id][slot]
					bool = this.TalentSlotRedDot(demon_id, slot, talent_cfgs)
					if (bool != last_bool) {
						this.demons_talent_red[demon_id][slot] = bool
						this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Talent, demon_id, slot)
					}
					if (!talent_bool && bool) {
						talent_bool = true
					}
				}
			}
		}
		this.SetRedFlag(DemonModel.RedFlag.Talent, talent_bool)
		RedDotController.ins.up(RedKey.DEMON_TALENT, talent_bool ? 1 : 0)
	}

	public RefreshDemonShopRedDot() {
		this.SetRedFlag(DemonModel.RedFlag.Shop, !this.talent_shop_first_open_tips)
		RedDotController.ins.up(RedKey.DEMON_SHOP, !this.talent_shop_first_open_tips ? 1 : 0)
	}

	public RefreshRotaryRed() {
		let rotary_kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_spirit_rotary_kv
		let rotary_bool = false
		let open = this.common_mgr.CheckFuncOpenState("DemonMainView", true)
		if (open) {
			if (!this.demons_rotary_red) {
				this.demons_rotary_red = []
			}
			let low_cond = JSON.parse(rotary_kv_cfg[1].value)[0]
			let [type1, lock1] = this.goods_model.GetMappingTypeId(low_cond[0], low_cond[1])
			let need_count = Number(low_cond[2])
			let my_count = this.goods_model.GetTypeGoodsNum(type1)
			this.demons_rotary_red[0] = my_count >= need_count

			let high_cond = JSON.parse(rotary_kv_cfg[2].value)[0]
			let [type2, lock2] = this.goods_model.GetMappingTypeId(high_cond[0], high_cond[1])
			need_count = Number(high_cond[2])
			my_count = this.goods_model.GetTypeGoodsNum(type2)
			this.demons_rotary_red[1] = my_count >= need_count

			rotary_bool = this.demons_rotary_red[0] || this.demons_rotary_red[1]
		}

		this.SetRedFlag(DemonModel.RedFlag.Rotary, rotary_bool)
		RedDotController.ins.up(RedKey.DEMON_ROTARY, rotary_bool ? 1 : 0)
		this.Fire(DemonEvent.REFRESH_RED_FLAG, DemonModel.RedFlag.Rotary)
	}

	public GetRedFlagState(flag?, key?, key2?) {
		if (flag == DemonModel.RedFlag.Level) {
			return this.demons_level_red && this.demons_level_red[key]
		} else if (flag == DemonModel.RedFlag.Star) {
			return this.demons_star_red && this.demons_star_red[key]
		} else if (flag == DemonModel.RedFlag.Skill) {
			return this.demons_skill_red && this.demons_skill_red[key]
		} else if (flag == DemonModel.RedFlag.LifeSkill) {
			return this.demons_life_skill_red && this.demons_life_skill_red[key]
		} else if (flag == DemonModel.RedFlag.Rotary) {
			return this.demons_rotary_red && this.demons_rotary_red[key]
		} else if (flag == DemonModel.RedFlag.Talent) {
			if (key2 != undefined) {
				return this.demons_talent_red && this.demons_talent_red[key] && this.demons_talent_red[key][key2]
			} else {
				return this.demons_talent_red && this.demons_talent_red[key]
			}

		}
	}

	public static GetInstance() {
		if (!DemonModel.Instance) {
			new DemonModel()
		}
		return DemonModel.Instance
	}

	public static SetStars = (gp, level: number, img_size = 23, gap = 4) => {
		let stage = Math.floor(level / DemonDefine.StarsCount),
			index = level % DemonDefine.StarsCount,
			stage_source = DemonDefine.StarsStageSource,
			img,
			layout = gp.layout;


		// if (!gp["_has_set"]) {
		// 	let layout: eui.HorizontalLayout = new eui.HorizontalLayout()
		// 	layout.horizontalAlign = egret.HorizontalAlign.LEFT
		// 	layout.gap = gap
		// 	gp.layout = layout
		// }

		for (let i = 0; i < DemonDefine.StarsCount; i++) {
			if (!gp["_has_set"]) {
				img = new Laya.Image()
				img.width = img.height = img_size
				gp.addChild(img)
			}
			else {
				img = gp.getChildAt(i)
			}
			img.skin = index > i ? GameResPath.GetIcon(stage_source[stage + 1][0], stage_source[stage + 1][1]) : GameResPath.GetIcon(stage_source[stage][0], stage_source[stage][1])//stage_source[stage + 1] : stage_source[stage]
		}
		gp["_has_set"] = true
	}

	/**
	 * 根据物品数据获得一个圆形的icon  仅仅处理妖灵碎片
	 */
	public GetCirItemIcon(basic) {
		if (basic.type == 73 && basic.subtype == 2) {
			let id = basic.type_id - 7301000
			return GameResPath.GetIconOtherPath("demon", `demon_head_${id}`)
		} else {
			return GameResPath.GetGoodsIconPath(basic.goods_icon)
		}

	}

}
window["DemonModel"] = DemonModel