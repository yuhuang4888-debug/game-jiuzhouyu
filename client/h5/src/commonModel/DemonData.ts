import { BaseClass } from "../common/BaseClass"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { GlobalTimerQuest } from "../util/Util"

export class DemonData extends BaseClass {
	demon_id
	level
	exp
	star
	skill_dic
	power
	scale
	demons_name
	realm
	color
	resource

	level_attr
	star_attr

	slot_num
	talent_dic

	timer_id

	public constructor(data, demons_cfg, demons_level_cfg, demons_star_cfg) {
		super()

		this.demon_id = data.demons_id
		this.slot_num = data.slot_num
		let demon_cfg = demons_cfg && demons_cfg[this.demon_id]
		if (demon_cfg) {
			this.realm = demon_cfg.realm
			this.color = demon_cfg.color
			this.demons_name = demon_cfg.demons_name
			this.scale = demon_cfg.scale ? demon_cfg.scale : 1
		}
		this.RefreshData(data, demons_level_cfg, demons_star_cfg)
		this.RefreshSkillData(data.skill_list)
		this.RefreshTalent(data.slot_skill || [])
	}

	public RefreshData(data, demons_level_cfg, demons_star_cfg) {
		if (this.star != data.star) {
			this.star = data.star
			this.RefreshStarAttr(demons_star_cfg)
		}

		if (this.level != data.level) {
			this.level = data.level
			this.RefreshLevelAttr(demons_level_cfg)
		}

		this.exp = data.exp
		this.power = data.power
	}

	public RefreshSkillData(skill_list?) {
		this.skill_dic = {}
		for (let _tmpi in skill_list) {
			let vo = skill_list[_tmpi]
			this.skill_dic[vo.skill_id] = {
				skill_id: vo.skill_id,
				skill_lv: vo.skill_lv,
				process: vo.process,
				is_active: vo.is_active,
			}
		}
	}

	public GetLifeSkillData(demons_skill_cfg) {
		if (this.skill_dic) {
			let skill_cfg
			for (let skill_id in this.skill_dic) {
				let vo = this.skill_dic[skill_id]
				skill_cfg = demons_skill_cfg[this.demon_id + "@" + skill_id]
				if (skill_cfg && skill_cfg.sk_type == 1) {
					return vo
				}
			}
		}
	}

	public RefreshLevelAttr(demons_level_cfg) {
		let attr = {}
		if (this.realm) {
			let level_cfg = demons_level_cfg && demons_level_cfg[this.realm + "@" + this.level]
			if (level_cfg) {
				for (let vo of JSON.parse(level_cfg.attr)) {
					attr[vo[0]] = vo[1]
				}
			}
		}
		this.level_attr = attr
	}

	public RefreshStarAttr(demons_star_cfg) {
		let attr = {}
		let level_cfg = demons_star_cfg && demons_star_cfg[this.demon_id + "@" + this.star]
		if (level_cfg) {
			for (let vo of JSON.parse(level_cfg.attr)) {
				attr[vo[0]] = vo[1]
			}
		}
		this.star_attr = attr
	}

	public RefreshFollowAttr() {
		if (this.IsFollowed()) {
			if (!this.timer_id) {
				this.timer_id = GlobalTimerQuest.AddDelayQuest(() => {
					if (this.IsFollowed()) {
						let demon = Scene.GetInstance().GetDemon(RoleManager.GetInstance().GetMainRoleId())
						if (demon && demon.vo) {
							demon.vo.RefreshDemonProperty()
						}
					}
					this.timer_id = null
				}, 1000)
			}
		}
	}

	public IsFollowed() {
		return this.demon_id == RoleManager.GetInstance().GetMainRoleVo().demon_id
	}

	public GetSkillLevel(skill_id?) {
		return this.skill_dic && this.skill_dic[skill_id] && this.skill_dic[skill_id].skill_lv
	}

	public RefreshTalent(talent_list?) {
		this.talent_dic = {}
		for (let _tmpi in talent_list) {
			let vo = talent_list[_tmpi]
			this.talent_dic[vo.slot] = vo
		}
	}

	public GetTalentData(slot?) {
		return this.talent_dic && this.talent_dic[slot]
	}
}

window["DemonData"] = DemonData