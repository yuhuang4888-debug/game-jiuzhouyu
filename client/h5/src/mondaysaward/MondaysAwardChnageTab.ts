import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { Color, SetAnchoredPosition } from "../util/Util"

export class MondaysAwardChnageTab extends BaseItemRenderer {
	_Image1
	_lb
	line_lb

	public WIDTH = 130
	public HEIGT = 52

	public constructor(parent) {
		super()


		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardChnageTab"
		this.Load()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb.size  = 16
			// }
		}
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if(this.is_loaded){
				this._lb.text = this.data.desc
				if (this.selected) {
					this._lb.color = "9b572f"
					ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4_asset", "ui_button_orange", true)
				} else {
					this._lb.color ="#ffffff"
					ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4_asset", "ui_btn_achv", true)
				}
			}
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._lb,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb",
			])
	}
}
window["MondaysAwardChnageTab"] = MondaysAwardChnageTab