import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class DungeonPolarChatItem extends BaseItem1 {
_data
_model

public constructor(parent?){
super(parent) 
	
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarChatItem"
	this._model = BaseDungeonModel.GetInstance()
	this.load_callback = () => {
		
		this.initLabel()
		this.InitEvent()
	}
}

public InitEvent(){ 
	
	Util.AddClickEvent(this._box,() => {
			let roleVo = RoleManager.GetInstance().GetMainRoleVo()
			ChatModel.GetInstance().Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, CHAT_TYPE.TEAM, roleVo.province, roleVo.city, 0, this._data, {}, 0, "")
			GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DungeonPolarChatView")
		}
		, this)
}

public DeleteMe(){ 
	
	this._data = null
	super.DeleteMe()
}

public setData(data?){ 
	
	this._data = data
	if (this.is_loaded ) {
		this.initLabel()
	}
}

public initLabel(){ 
	
	if (! this._data ) {
		return
	}
	this._lb_content.text = this._data
}


_box:Laya.Box
_Image1:Laya.Image
_lb_content:Laya.Label
public GetComponents() {
[
this._box,
this._Image1,
this._lb_content,
]
 = this.GetChildrenByNames([

"_box",
"_Image1",
"_lb_content",
])
}
}
 window["DungeonPolarChatItem"]= DungeonPolarChatItem