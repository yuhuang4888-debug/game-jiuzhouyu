import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillVo } from "../skill/SkillVo"
import { Util } from "../util/Util"

export class InnateSkillItem extends BaseItem1 {
	_Image1
	_Image2: Laya.Image
	_group
	_img_icon
	_img_select
	_lb_lv
	model
	skill_cfg
	skill_id
	_gp_lv
	_img_mask: Laya.Image
	public constructor(parent?) {
		super(parent)

		this.skill_cfg = null
		this.skill_id = null
		this.base_file = "innateSkill"
		this.layout_file = "InnateSkillItem"
		this.model = SkillUIModel.GetInstance()
		this.load_callback = () => {
			this.InitEvent()
		}

	}

	public InitEvent() {


		Util.AddClickEvent(this._group, () => {
			this.model.Fire(SkillUIModel.SELECT_INNATE_ITEM, this.skill_cfg)
		}, this.display_obj, true)
		// Util.AddClickEvent(this._gp_lv, () => {
		// 	this.model.Fire(SkillUIModel.SELECT_INNATE_ITEM, this.skill_cfg)
		// }, this.display_obj, true)

		this.BindEvent(this.model, SkillUIModel.SELECT_INNATE_ITEM, (skill_cfg?) => {
			if (skill_cfg.id == this.skill_cfg.id) {
				this._img_select.visible = true
			} else {
				this._img_select.visible = false
			}
		})
	}

	public InitView(skill_id?, skill_type?, is_select?) {

		this.display_obj.scaleY = 0.8
		this.display_obj.scaleX = 0.8
		let cfg = this.model.GetInnateAllInfoByID(skill_id)
		if (!cfg) {
			return
		}
		this.skill_cfg = cfg
		let a = new SkillVo(cfg.id).GetIcon()
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/skillIcon/" + a + ".png")
		let lv_data = cfg.lv_data
		lv_data = JSON.parse(lv_data)
		//if (typeof(lv_data) == "string" ) {
		//lv_data = ErlangParser.GetInstance().Parse(lv_data)
		//}
		if (!lv_data) {
			return
		}
		let lv = cfg.skill_lv && cfg.skill_lv || 0
		this._Image1.gray = lv == 0
		this._img_icon.gray = lv == 0
		this._Image2.gray = lv == 0
		// Laya.UIUtils.gray(this._Image1, lv == 0)
		// Laya.UIUtils.gray(this._img_icon, lv == 0)
		// Laya.UIUtils.gray(this._Image2, lv == 0)
		this._lb_lv.text = lv + "/" + lv_data.length
		this._img_select.visible = is_select && true || false
	}

	public SetData(skill_id?, skill_type?, is_select?) {

		
		this.skill_id = skill_id
		this.InitView(skill_id, skill_type, is_select)
	}




	public GetComponents() {
		[
			this._group,
			this._Image1,
			this._img_mask,
			this._img_icon,
			this._img_select,
			this._gp_lv,
			this._Image2,
			this._lb_lv,
		]
			= this.GetChildrenByNames([

				"_group",
				"_Image1",
				"_img_mask",
				"_img_icon",
				"_img_select",
				"_gp_lv",
				"_Image2",
				"_lb_lv",
			])
	}
}
window["InnateSkillItem"] = InnateSkillItem