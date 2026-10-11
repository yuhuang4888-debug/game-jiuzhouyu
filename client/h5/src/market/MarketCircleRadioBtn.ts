import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
export class MarketCircleRadioBtn extends BaseItemRenderer {
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	select_img:Laya.Image
	public static width = 130
	public static height = 53
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketCircleRadioBtn"

		this.Load()
		this.load_callback = () => {

		}

	}

	public dataChanged() {
		if (super.dataChanged()) {
			this.labelDisplay.text = String(this.data)
			this.select_img.visible = this.selected
			// if (this.selected ) {
			// 	//this._lb_name.color = ColorUtil.TryParseHtmlString("#FFFFFF") 
			// 	ResManager.GetInstance().SetImageSprite(this,this._Image1,"common_asset","com_ui_gx1")
			// }else{
			// 	//let color = ColorUtil.TryParseHtmlString("#CBB5AC")
			// 	//this._lb_name.color = color
			// 	ResManager.GetInstance().SetImageSprite(this,this._Image1,"common_asset","com_ui_gx")
			// }
			// //LayoutRebuilder(this.form)
		}
	}



	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this.select_img
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
				"select_img"
			])
	}
}

window["MarketCircleRadioBtn"] = MarketCircleRadioBtn