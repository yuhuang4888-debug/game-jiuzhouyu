import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { Util } from "../util/Util"

export class ChatToolGridItem extends BaseItemRenderer {
	_id

	img
	needRefreshData
	use_local_view
	_Image1: Laya.Image

	public WIDTH = 80
	public HEIGT = 80

	public constructor(parent) {
		super()

		this.base_file = "chat"
		this.layout_file = "ChatToolGridItem"
		this.Load()
		// this.skinName="resource/game/chat/exml/ChatToolGridItemExml.exml"
		// this.use_local_view = true
		// this.load_callback()
	}

	public load_callback() {


		// this.addEventListener(Laya.TouchEvent.TOUCH_TAP, this.click, this)
		Util.AddClickEvent(this.img, () => {
			ChatModel.GetInstance().Fire(ChatModelEvent.ADD_FACE, this.data, ChatModel.GetInstance().selectChannel)
		}, this, true)
		// super.createChildren()
		// if (this.needRefreshData) {
		// 	// this.SetData(this.data)
		// 	this.needRefreshData = false
		// }
	}

	public dataChanged(data?) {
		if(super.dataChanged()){
			this._id = this.data
			this.img.skin ="resource/game/emoji/texture/"+this._id+".png"
		}
	}

	public DeleteMe() {
		super.DeleteMe()
		// this.removeEventListener(Laya.TouchEvent.TOUCH_TAP, this.click, this)
	}


	public GetComponents() {
		[
			this._Image1,
			this.img,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"img",
			])
	}
}

window["ChatToolGridItem"] = ChatToolGridItem