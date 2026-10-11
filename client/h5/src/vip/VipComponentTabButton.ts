import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil } from "../util/ColorUtil"

export class VipComponentTabButton extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.HBox
	labelDisplay: Laya.Label
	vip_red: Laya.Image
	bind_id
	outline

	public static width = 150
	public static height = 66

	public constructor(parent) {
		super()
		this.WIDTH = 150
		this.HEIGT = 59
		this.base_file = "vip"
		this.layout_file = "VipTabButton"

		this.Load()
	}

	public load_callback() {
		if (PlatformManager.IsEyouEnPlatform() ) {
			this.labelDisplay.fontSize  = 18
		}
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this.labelDisplay.size  = 18
		// }
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this.labelDisplay.size  = 18
		// }

		this.bind_id = VipModel.GetInstance().Bind(VipModel.UPDATE_VIP_TAB_RED, (red?, type?) => {
			if (this.data && type == this.data.index) {
				this.vip_red.visible = red
			}
		}
		)

		// this.outline = this.labelDisplay.GetComponent("Outline")

		// Util.AddClickEvent(this.gameObject,(e?) => {
		// 	console.log("点击")
		// }
		// , this, true)
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.data) {
			this.labelDisplay.text = this.data.label
			// [ts2lua]VipModel:GetInstance().show_red_list下标访问可能不正确
			this.vip_red.visible = VipModel.GetInstance().show_red_list[this.data.index]

			if (this.selected) {
				this._Image2.visible=false
				this._Image1.visible=true
				// ResManager.GetInstance().SetImageSprite(this, this._Image1, "vip_asset", "vip_018", true)
				this.labelDisplay.color = ColorUtil.TryParseHtmlString("#ffffff")
				this.labelDisplay.strokeColor="#ad455c"
				// this.outline.effectColor = ColorUtil.TryParseHtmlString("#c75600")
			} else {
				this._Image2.visible=true
				this._Image1.visible=false
				// ResManager.GetInstance().SetImageSprite(this, this._Image1, "vip_asset", "vip_019", true)
				this.labelDisplay.color = ColorUtil.TryParseHtmlString("#4f538f")
				this.labelDisplay.strokeColor="#c6c3f4"
				// this.outline.effectColor = ColorUtil.TryParseHtmlString("#5e5146")
			}
		}
	}

	public DeleteMe() {

		if (this.bind_id) {
			VipModel.GetInstance().UnBind(this.bind_id)
			this.bind_id = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Group1,
			this.labelDisplay,
			this.vip_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Group1",
				"labelDisplay",
				"vip_red",
			])
	}
}
window["VipComponentTabButton"] = VipComponentTabButton