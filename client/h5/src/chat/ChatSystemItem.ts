import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ChatModel } from "../commonModel/ChatModel"
import { Util } from "../util/Util"

export class ChatSystemItem extends BaseItemRenderer {
_model
empty
contentLabel
_gp_title

public static width = 88
public static height = 45

public constructor(parent){
super() 
	
  
  this.empty = "系统氵 ";
  this.base_file = "chat"
  this.layout_file = "ChatSystemItemExml"
  // this.skinName="resource/game/chat/exml/SystemItemExml.exml"
  this._model = ChatModel.GetInstance()
}

public createChildren(){ 
	
  // this.contentLabel.addEventListener(Laya.TextEvent.LINK, this.ClickLink, this)
  super.createChildren()
}

public DeleteMe(){ 
	super.DeleteMe()
}

public dataChanged(){ 
	
  if (super.dataChanged())
  {
    if (! this._gp_title.visible)
    {
      this._gp_title.visible = true
    }
    let chatVo = this.data
    let msg = this._model.FormatColorTag(chatVo.msg)
    let text = this._model.FormatLinkTag(msg)
    text = this._model.changeToDark(text)
    this.contentLabel.textFlow = Util.StrToHTML(this.empty + text)
  }
}

public ClickLink(evt?){ 
	
  this._model.LinkEvtInChatItem(evt)
}

}
window["ChatSystemItem"] = ChatSystemItem