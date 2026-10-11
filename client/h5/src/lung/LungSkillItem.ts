import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIEffect } from "../common/UIEffect"
import { LungEvent, LungModel } from "../commonModel/LungModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class LungSkillItem extends BaseItemRenderer {

	WIDTH = 72
	HEIGT = 72
	public effect_group
	public tween_id

	AddEffect
	SetGary
	InitEvent
	Local_DeleteMe
	private effect: UIEffect;

	public constructor() {
		super()
		this.base_file = "lung"
		this.layout_file = "LungSkillItem"
		this.effect = new UIEffect();

		this.InitEvent = () => {
			let OnClick = () => {
				if(this.data){
					let skill_id = this.data.skill_id;
					let skill_lv = this.data.lv;
					let skill_desc = this.data.skill_desc;
					LungModel.GetInstance().Fire(LungEvent.LUNG_OPEN_VIEW, "LungSkillTipsView", skill_id, skill_lv, skill_desc);
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.click_group)
				}
			}
			Util.AddClickEvent(this.click_group, OnClick, this, true)
		}

		this.load_callback = () => {
			this.InitEvent()
		}

		this.Load()

		this.SetGary = (gary?) => {
			Util.SetImageGray(this.icon, gary)
		}

		this.AddEffect = (effect_str?, layer_value?) => {
			this.effect.ClearUIEffect(this.effBox);
			this.effBox.visible = true;
			this.effect.AddUIEffect(effect_str, this.effBox, { x: 0, y: 0 }, 10, false, 0.5, () => {
				this.effBox.visible = false;
			});
		}

		this.Local_DeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
			}
			if (this.effect_group) {
				this.effect.ClearUIEffect(this.effect_group)
			}
		}
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
		let skill_id = this.data.skill_id
		let skill_vo = SkillManager.GetInstance().getSkill(skill_id);
		let skill_lv = this.data.lv;
		let show_icon = (skill_lv == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon(skill_lv);
		let source_str = `resource/game/skillIcon/${show_icon}.png`;
		ResManager.GetInstance().SetTexture(this, this.icon, source_str)
	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}


	click_group: Laya.Box
	icon_bg: Laya.Image
	icon_bg_mask: Laya.Image
	icon: Laya.Image
	effBox: Laya.Box
	public GetComponents() {
		[
			this.click_group,
			this.icon_bg,
			this.icon_bg_mask,
			this.icon,
			this.effBox,
		]
			= this.GetChildrenByNames([

				"click_group",
				"icon_bg",
				"icon_bg_mask",
				"icon",
				"effBox",
			])
	}
}
window["LungSkillItem"] = LungSkillItem