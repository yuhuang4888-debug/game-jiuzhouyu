import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { ColorUtil, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { Color, RefBoxChildsLayout } from "../util/Util"

export class EveningMainItem extends BaseItemRenderer {
	model

	public WIDTH = 147
	public HEIGT = 62

	is_set
	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningMainItem"
		this.model = GuildActivityModel.GetInstance()

		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_name.size  = 20
			// }

			if (!this.is_set) {
				this.is_set = true
				this.SetDate()
			}
		}
		this.Load()
	}



	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}
		if (!this.is_loaded) {
			this.is_set = false
		} else {
			this.is_set = true
			this.SetDate()
		}

	}


	SetDate() {
		if (!this.data) return
		this._lb_name.text = this.data.name
		//ResManager.GetInstance().SetImageSprite(this, this._img_icon, "evening_asset", this.data.icon, true)
		if (this.selected) {

			ResManager.GetInstance().SetImageSprite(this, this._img_select, "common2", "uian_003a")
			this._img_select.height = 62
			this._lb_name.color = Enum_ColorUtil_NEW.RED_GRAY
			//this._lb_name.strokeColor = Enum_ColorUtil_NEW.RED_GRAY
			


		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_select, "common2", "uian_003c")
			this._img_select.height = 57
			this._lb_name.color = Enum_ColorUtil_NEW.WHITE
			//this._lb_name.strokeColor = Enum_ColorUtil_NEW.WHITE
		}



	}

	public DeleteMe() {
		super.DeleteMe()
	}



	_img_select: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._img_select,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_img_select",
				"_lb_name",
			])
	}
}
window["EveningMainItem"] = EveningMainItem