import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
export class MarketRadioBtn extends BaseItemRenderer {
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public static width = 124
	public static height = 52
	WIDTH = 124
    HEIGT = 52
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketRadioBtn"

		this.Load()
		this.load_callback = () => {

		}
		// this.load_callback = () => {

		// 	if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 		this.labelDisplay.size  = 16
		// 		this.labelDisplay.lineSpacing = 0.8
		// 	}
		// }
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let name = String(this.data)
			this.labelDisplay.text = name
			if (this.selected ) {
				this.labelDisplay.color = "#9b572f"//ColorUtil.TryParseHtmlString("#FFFFFF") 
				ResManager.GetInstance().SetImageSprite(this,this._Image1,"market_asset","uishi_011")
			}else{
				//let color = ColorUtil.TryParseHtmlString("#CBB5AC")
				this.labelDisplay.color = "#ffffff"//color
				ResManager.GetInstance().SetImageSprite(this,this._Image1,"market_asset","uishi_012")
			}
		}
	}





	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
			])
	}
}

window["MarketRadioBtn"] = MarketRadioBtn