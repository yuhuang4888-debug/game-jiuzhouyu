import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { PlatformManager } from "../PlatformManager"
import { Util } from "../util/Util"

export class InnateUpCondItem extends BaseItem1 {
	_lb_cond: Laya.HTMLDivElement
	_Group1: Laya.Box
	_Image1: Laya.Image
	model

	public constructor(parent?) {
		super(parent)


		this.base_file = "innateSkill"
		this.layout_file = "InnateUpCondItem"
		this.model = SkillUIModel.GetInstance()
		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_cond.size  = 18
			// }
		}
	}

	public SetData(cond?) {

		if (cond) {

			let str
			let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
			if (!skill_ui_cfg) {
				return
			}
			let ui_cfg = skill_ui_cfg["innateSkill"]
			let info = this.model.GetInnateInfo()
			let _type = cond[1]
			let _point = cond[2]

			if ("point" == cond[0]) {
				if (_type && _point) {
					if (ui_cfg[_type] && info) {
						let use_point = 0
						if (info.talent_skills) {
							for (let _tmpi in info.talent_skills) {
								var v = info.talent_skills[_tmpi]
								if (v.skill_type == _type) {
									use_point = v.point
									break
								}
							}
						}
						let color = use_point >= Number(_point) && "#0a953e" || "#ff4f50"
						str = Util.StrToHTML(ui_cfg[_type].name + "系投入:<font color=\"" + color + "\">" + use_point + "/" + _point + "</font>")
					}
				}
			} else if ("pre_skill" == cond[0]) {
				let per_skill = this.model.GetInnateAllInfoByID(cond[1])
				if (!per_skill) {
					return
				}
				let lv = per_skill && per_skill.skill_lv || 0
				let color = lv >= Number(cond[2]) && "#0a953e" || "#ff4f50"
				str = Util.StrToHTML("前置天赋:<font color=\"" + color + "\">" + per_skill.name + " " + lv + "/" + cond[2] + "</font>")
			}
			this._lb_cond.width=300
			this._lb_cond.innerHTML = str
			if(PlatformManager.IsEyouPlatform()){
				this._lb_cond.style.width = 300
				this._lb_cond.style.wordWrap = true
				this._lb_cond.style.leading = 0.1
				this.display_obj.height = this._lb_cond.contextHeight + 2
			}else{
				this.display_obj.height = 22 
			}
		}
	}
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this._lb_cond,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"_lb_cond",
			])
		this._lb_cond.style.fontSize=20
		this._lb_cond.width=600
		this._lb_cond.style.color="#663915"

	}
}
window["InnateUpCondItem"] = InnateUpCondItem