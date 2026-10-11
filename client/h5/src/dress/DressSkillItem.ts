import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { DressModel } from "../commonModel/DressModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DressSkillItem extends BaseItem1 {
	_Image1: Laya.Image
	skill_img: Laya.Image
	condition_bg: Laya.Image
	condition: Laya.Label
	InitEvents
	LoadSuccess
	SetData


	public constructor(parent?) {
		super(parent)


		this.base_file = "dress"
		this.layout_file = "DressSkillItem"
		let model = DressModel.GetInstance()
		let cfg_ = null
		let lv_ = null
		let needRefresh_ = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvents()
		}



		this.LoadSuccess = () => {
			// this.display_obj.scale(0.8,0.8)
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.condition.size  = 16
			// }
		}

		this.InitEvents = () => {
			let click_fun = () => {
				if (cfg_) {
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView", cfg_.skill, 0)
				}
			}

			Util.AddClickEvent(this.skill_img, click_fun, this)
			if (needRefresh_) {
				this.SetData(cfg_, lv_)
			}
		}

		this.SetData = (cfg?, lv?) => {
			cfg_ = cfg
			lv_ = lv
			if (this.is_loaded) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_img, GameResPath.GetSkillIconPath(cfg_.skill))
				let has_active = lv_ >= cfg_.level
				if(PlatformManager.IsEyouEnPlatform()){
					this.condition.text = (has_active && ("") || ("Lv."+cfg_.level + " to activate"))
				}else{
					this.condition.text = (has_active && ("") || (cfg_.level + "级激活"))
				}
				this.condition_bg.visible = !has_active
				this.condition.visible = !has_active
				Util.SetImageGray(this.skill_img, !has_active)
			} else {
				needRefresh_ = true
			}
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this.skill_img,
			this.condition_bg,
			this.condition,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"skill_img",
				"condition_bg",
				"condition",
			])
	}
}
window["DressSkillItem"] = DressSkillItem