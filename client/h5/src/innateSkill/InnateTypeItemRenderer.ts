import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"

export class InnateTypeItemRenderer extends BaseItemRenderer {
	_lb_data: Laya.HBox
	_img_select
	_img_skill_icon
	_lb_lv :Laya.Label
	model
	typeLb :Laya.Label
	public static width = 140
	public static height = 234

	public constructor(parent) {
		super()

		this.HEIGT = 75.532
		this.WIDTH = 138.323
		this.base_file = "innateSkill"
		this.layout_file = "InnateTypeItemRenderer"
		this.model = SkillUIModel.GetInstance()
		// this.skinName = "resource/game/innateSkill/exml/InnateTypeItemRendererExml.exml"
		// this.load_callback = () => {
		this.Load()

		// }
	}

	public load_callback() {

		this.BindEvent(this.model, SkillUIModel.UPDATE_INNATE_VIEW, () => {
			if (this.data && this.data.type) {
				let type = Number(this.data.type)
				let info = this.model.GetInnateInfo()
				let point = 0
				if (info) {
					for (let _tmpi in info.talent_skills) {
						var v = info.talent_skills[_tmpi]
						if (v.skill_type == type) {
							point = v.point
						}
					}
				}
				this._lb_lv.text = "(" + point + ")"
				this._lb_data.refresh()
			}
		})
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this.InitView()
		}
	}

	public InitView() {


		if (!this.data) {
			return
		}
		this._lb_lv.color = this.selected ? "#ffffff" : "#4f538f"
		this._lb_lv.strokeColor=this.selected ? "#ad455c" : "#c6c3f4"
		this.typeLb.color = this.selected ? "#ffffff" : "#4f538f"
		this.typeLb.strokeColor= this.selected ?"#ad455c" : "#c6c3f4"
		let type = Number(this.data.type)
		let info = this.model.GetInnateInfo()
		let point = 0
		if (info) {
			for (let _tmpi in info.talent_skills) {
				var v = info.talent_skills[_tmpi]
				if (v.skill_type == type) {
					point = v.point
				}
			}
		}
		this._lb_lv.text = "(" + point + ")"
		let url = null
		if (5 == type) {
			this.typeLb.text = "攻击"
			url = this.selected && "ui_role_btn_3" || "ui_role_btn_4"
		} else if (6 == type) {
			this.typeLb.text = "防御"
			url = this.selected && "ui_role_btn_3" || "ui_role_btn_4"
		} else if (7 == type) {
			this.typeLb.text = "通用"
			url = this.selected && "ui_role_btn_3" || "ui_role_btn_4"
		} else if (8 == type) {
			this.typeLb.text = "绝对"
			url = this.selected && "ui_role_btn_3" || "ui_role_btn_4"
		}

		if (url) {
			ResManager.GetInstance().SetImageSprite(this, this._img_skill_icon, "innateSkill_asset", url)
		}
		this._lb_data.refresh()
		// this._img_select.visible = this.selected
	}


	public GetComponents() {
		[
			this._img_skill_icon,
			this._lb_data,
			this._lb_lv,
			this.typeLb,
		]
			= this.GetChildrenByNames([

				"_img_skill_icon",
				"_lb_data",
				"_lb_lv",
				"typeLb",
			])
	}
}
window["InnateTypeItemRenderer"] = InnateTypeItemRenderer