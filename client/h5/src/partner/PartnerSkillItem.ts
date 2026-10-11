import { BaseItem1 } from "../common/BaseItem1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { SkillManager } from "../skill/SkillManager";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { PartnerModel } from "../commonModel/PartnerModel";
import { PlatformManager } from "../PlatformManager";


export class PartnerSkillItem extends BaseItem1 {
	bg: Laya.Image
	skill_mask: Laya.Image
	skill_icon: Laya.Image
	activeEffect: Laya.Box
	skill_tag: Laya.Image
	lock: Laya.Box
	lock_mask: Laya.Image
	unlock_cond: Laya.Label
	effect: Laya.Box
	img_click: Laya.Image


	res_mgr = ResManager.GetInstance()

	active
	cache_id
	model
	need_refresh
	skill_id
	id
	not_show_cond
	index

	public constructor(parent?) {
		super(parent)

		this.base_file = "partner"
		this.layout_file = "PartnerSkillItem"
		this.layer_value = Enum_UILayer.UI
		this.model = PartnerModel.GetInstance()
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.unlock_cond.width = 93
				this.unlock_cond.height = 46
				this.unlock_cond.wordWrap = true
				this.unlock_cond.leading = 0.1
			}
			this.Load_callback()
			this.InitEvent()
		}
	}

	public Load_callback() {
		this.skill_icon.mask = this.skill_mask
		if (this.need_refresh) {
			this.InitView()
			this.need_refresh = false
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.skill_icon, () => {
			if (this.skill_id) {
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView", this.skill_id, 1)
			}
		}, this, true)

	}

	public InitView() {
		if (!this.skill_id || !this.id) { return }
		let info = this.model.GetInfoByID(this.id)
		let skill_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_companion_skill", false)
		let cfg = skill_cfgs[this.id + "@" + this.skill_id]
		if (!cfg) { return }
		let is_active = false
		if (info.stage >= cfg.unlock_stage) {
			is_active = true
		}
		this.lock.visible = !is_active && !this.not_show_cond
		if (this.active != null && this.active != undefined && this.active != is_active && this.cache_id && this.cache_id == this.id) { //技能激活
			// this.AddUIEffect("UI_partner_skillicon_02", this.activeEffect)
			this.AddUIEffect("UI_partner_skillicon_02", this.activeEffect, null, 11, false, undefined, undefined, undefined, undefined, undefined, undefined, undefined, false)

		}
		this.active = is_active
		this.cache_id = this.id
		if (!is_active) {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.unlock_cond.text =`G${cfg.unlock_stage}\nActivate`
			}else{
				this.unlock_cond.text = cfg.unlock_stage + "阶\n激活"
			}
			this.ClearUIEffect(this.effect)
		} else {
			// this.AddUIEffect("UI_partner_skillicon_01", this.effect, null, null, true)
		}
		this.skill_tag.visible = is_active && this.index == 0
		let skill_vo = SkillManager.GetInstance().getSkill(this.skill_id)
		let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
		this.res_mgr.SetTexture(this, this.skill_icon, GameResPath.GetSkillIcon(show_icon))
	}

	public SetData(...parms) {
		this.skill_id = parms[0]
		this.id = parms[1]
		this.not_show_cond = parms[2]
		this.index = parms[3]
		if (this.is_loaded) {
			this.InitView()
		} else {
			this.need_refresh = true
		}
	}

	public DeleteMe() {

		this.active = null
		this.cache_id = null

		super.DeleteMe()
	}


	public GetComponents() {
		[
			this.bg,
			this.skill_mask,
			this.skill_icon,
			this.activeEffect,
			this.skill_tag,
			this.lock,
			this.lock_mask,
			this.unlock_cond,
			this.effect,
			this.img_click,
		]
			= this.GetChildrenByNames([

				"bg",
				"skill_mask",
				"skill_icon",
				"activeEffect",
				"skill_tag",
				"lock",
				"lock_mask",
				"unlock_cond",
				"effect",
				"img_click"
			])
	}
}
window["PartnerSkillItem"] = PartnerSkillItem