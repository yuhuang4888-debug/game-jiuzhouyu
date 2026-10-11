import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { ChatParentView } from "./ChatParentView"

export class ChatEntView extends BaseWindowComponent {
_model
change_scene_close
channelList
destroy_callback
money_list
tabStrList
titleStr
viewClassList


public constructor(){
super() 
	
  this.channelList = [];
  this.dependent_res = ["chat"]
  this._model = ChatModel.GetInstance()
  this.titleStr = "chat_json.chat_title_png"
  this.change_scene_close = false
  this.money_list = [2, 1, 0]
  this.tabStrList = [{label:"聊天"}]
  this.viewClassList = [ChatParentView]

  this.destroy_callback = () => {
    this.Clear()
  }
}

public Open(){ 
	
  if (this.viewList)
  {
    let index = this.GetWindowDefaultIndex()
    // [ts2lua]this.viewList下标访问可能不正确
    let sub_view = this.viewList[index]
    if (sub_view && typeof(sub_view.CustomMehod) == "function")
    {
      
    }
  }
  super.Open()
}

// function ChatEntView.Close()
public Clear(){ 
	
  this._model.Fire(ChatModelEvent.CLOSETOOLPANEL)
}

}
window["ChatEntView"] = ChatEntView