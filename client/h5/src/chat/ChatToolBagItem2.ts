import { Enum_UILayer } from "../common/LayerManager"
import { ChatModel } from "../commonModel/ChatModel"
import { ChatToolBagItem } from "./ChatToolBagItem"

export class ChatToolBagItem2 extends ChatToolBagItem {
	_model
	is_batch
	is_delay_callback

	public constructor(parent?) {
		super(parent)
		this.is_batch = false //因为两个viewport的矩形不一样，不合批
		this.base_file = "chat"
		this.layout_file = "ChatToolBagItem"
		// this.layer_value = Enum_UILayer.Activity
		// this.skinName="resource/game/chat/exml/ChatToolBagItemExml.exml"
		this._model = ChatModel.GetInstance()
		this.is_delay_callback = true
	}
}

window["ChatToolBagItem2"] = ChatToolBagItem2