import { BaseItem1 } from "../common/BaseItem1"
import { ChatModel } from "../commonModel/ChatModel"
import { PlatformManager } from "../PlatformManager"
import { Util } from "../util/Util"

export class ChatTrumpetMenuItem extends BaseItem1 {
	_model
	data
	labelDisplay
	needRefreshData
	use_local_view
	clickBox
	_Image1: Laya.Image



	public constructor(parent) {
		super(parent)

		this.base_file = "chat"
		this.layout_file = "ChatTrumpetMenuItem"
		this._model = ChatModel.GetInstance()
		// this.use_local_view = true
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.labelDisplay.size = 18
			}
			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = null
			}

			Util.AddClickEvent(this.clickBox, () => {
				if (this.data && this.data.clickFunc) {
					this.data.clickFunc(this)
				}
			}, this)
		}
	}

	public SetData(data?) {

		this.data = data
		if (!this.is_loaded) {
			this.needRefreshData = true
			return
		}

		this.labelDisplay.text = data.label
	}



	public GetComponents() {
		[
			this.clickBox,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"clickBox",
				"_Image1",
				"labelDisplay",
			])
	}
}

window["ChatTrumpetMenuItem"] = ChatTrumpetMenuItem