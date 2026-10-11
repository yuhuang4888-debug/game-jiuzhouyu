import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class MarketTypeBtn extends BaseItemRenderer {
	_img_btn: Laya.Image
	public static width = 108
	public static height = 108
	WIDTH = 108
    HEIGT = 108
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketTypeBtn"

		this.Load()
		this.load_callback = () => {

		}
		// this.load_callback = () => {

		// }
	}
	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			if (this.selected) {
				ResManager.GetInstance().SetImageSprite(this, this._img_btn, "market_asset", data.dpic)
			} else {
				ResManager.GetInstance().SetImageSprite(this, this._img_btn, "market_asset", data.npic)
			}
		}
	}



	public GetComponents() {
		[
			this._img_btn,
		]
			= this.GetChildrenByNames([

				"_img_btn",
			])
	}
}

window["MarketTypeBtn"] = MarketTypeBtn