import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { MonBookModel } from "../commonModel/MonBookModel"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil } from "../util/ColorUtil"
import { Trim } from "../util/Util"

export class MonBookTabItem extends BaseItemRenderer {
	public WIDTH = 124
	public HEIGT = 50

	name
	type
	is_group
	public static width = 130
	public static height = 53
	model:MonBookModel
	public constructor() {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookTabItem"
		this.model = MonBookModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
			this.labelDisplay.leading = 0.1
			this.labelDisplay.fontSize = 17
			this.labelDisplay.width = 115
		}
		this.BindEvent(MonBookModel.GetInstance(), MonBookModel.REFUSE_TAB_RED, (type?, bool?, is_group?) => {
			if (type == this.type && is_group == this.is_group) {
				this._img_red.visible = bool
			}
		}
		)
	}

	public dataChanged() {
		if (super.dataChanged() && this.data) {
			this.type = this.data.type
			this.name = this.data.name
			this.is_group = this.data.is_group
			let name = Trim(String(this.name))
			this.labelDisplay.text = name
			// this.selected = !this.is_group ? this.model.now_select_type == this.type : this.model.now_select_group_type == this.type
			if (this.selected) {
				this.labelDisplay.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4_asset", "ui_button_orange")
			} else {
				let color = "#FFFFFF"
				this.labelDisplay.color = color
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4_asset", "uian_003c")
			}
			let config_mon_pic_group = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_mon_pic_group", false)
			this._img_red.visible = !this.is_group ? this.model.IsShowCurrTabDot(this.type) : this.model.IsShowGroupDot(this.type, config_mon_pic_group)
		}
	}

	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
				"_img_red",
			])
	}
}
window["MonBookTabItem"] = MonBookTabItem