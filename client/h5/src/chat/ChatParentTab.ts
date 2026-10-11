import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ChatModel } from "../commonModel/ChatModel"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { SetSizeDeltaX, Util } from "../util/Util"

export class ChatParentTab extends BaseItemRenderer {
	_Image1
	_model
	is_delay_callback
	labelDisplay
	use_local_view

	public WIDTH = 111
	public HEIGT = 62

	public constructor(parent) {
		super()
		this.base_file = "chat"
		this.layout_file = "ChatParentTab"
		this._model = ChatModel.GetInstance()
		// this.use_local_view = true
		this.selected = false
		this.is_delay_callback = true
		this.Load()
		// this.load_callback = () => { 


		// 	// Util.AddClickEvent(this.gameObject,(e?) => {
		// 	// 	console.log("点击")
		// 	// }
		// 	// , this, true)
		// }
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (!this) {
				return
			}
			if (!this.data.label) {
				// [ts2lua]this._model.ViewClassCFG下标访问可能不正确
				let cof = this._model.ViewClassCFG[this.data]
				if (cof) {
					this.labelDisplay.text = cof.label
				}
			} else {
				this.labelDisplay.text = this.data.label
			}

			if (this.selected) {
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "chat_asset", "uilt_008")
				SetSizeDeltaX(this._Image1, 111)
				this.labelDisplay.color = "#9b572f"
			} else {
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "chat_asset", "uilt_009")
				SetSizeDeltaX(this._Image1, 111)
				this.labelDisplay.color = "#FFFFFF"
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

window["ChatParentTab"]=ChatParentTab