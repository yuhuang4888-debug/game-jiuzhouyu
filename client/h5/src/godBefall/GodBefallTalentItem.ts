import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { SkillManager } from "../skill/SkillManager"

export class GodBefallTalentItem extends BaseItem1 {
	_model
	data

	public constructor(parent) {
		super(parent)
		this.base_file = "godBefall"
		this.layout_file = "GodBefallTalentItem"
		this._model = GodBefallModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(
			this._gp_click, () => {
				let sdata = { skill_id: this.data, skill_lv: 1 }
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SkillTipsView", sdata)
			},
			this,
			true
		)
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		let skill_id = this.data
		let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
		if (skill_vo) {
			let lv_data = skill_vo.getLevelVo(1)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(lv_data.icon))
		}
	}

	_gp_click: Laya.Box
	_Image1: Laya.Image
	_img_icon: Laya.Image
	public GetComponents() {
		[
			this._gp_click,
			this._Image1,
			this._img_icon,
		]
			= this.GetChildrenByNames([
				"_gp_click",
				"_Image1",
				"_img_icon",
			])
	}
}
window["GodBefallTalentItem"] = GodBefallTalentItem