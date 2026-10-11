import { ChatItem } from "../chat/ChatItem"
import { ChatVoiceManager } from "../chat/ChatVoiceManager"
import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, SetAnchoredPositionX, Trim, SetSizeDeltaY, SetAnchoredPosition, SetLocalScaleX, SetSizeDeltaX, SetSizeDelta, SetHtmlCenter, SetHtmlStyle } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EveningChatItem extends BaseItem1 {

	data
	needRefreshData
	_model
	_sendId
	chat_item
	public constructor(parent) {
		super(parent)
		this._sendId = 0;
		this.base_file = "evening"
		this.layout_file = "EveningChatItem"
		this._model = ChatModel.GetInstance()
		this.is_delay_callback = false

		this.load_callback = () => {
			this.load_callback1()

		}

	}

	//获取消息发送者id
	public GetSenderPlayerId() {

		let player_id = this.data.player_id || this.data.player_list[1].player_id
		return player_id
	}

	public load_callback1() {
		SetHtmlStyle(this.sysContent,{c:"#411d00",f:20,w:470,lh:25})
		if (this.needRefreshData) {
			this.SetData(this.data)
			this.needRefreshData = null
		}
	}

	// public SetPos(component?, right?, value?, spe_value?) {
	// 	if (right) {
	// 		component.anchorX = 1
	// 		let v = spe_value ? spe_value : 0
	// 		SetAnchoredPositionX(component, component.parent.width - value + v)
	// 	} else {
	// 		component.anchorX = 0
	// 		SetAnchoredPositionX(component, value)
	// 	}
	// }

	public SetData(data?) {

		this.data = data || this.data
		if (!this.is_loaded) {
			this.needRefreshData = true
			return
		}

		let channel = this.data.channel
		let is_sys = (channel == CHAT_TYPE.SYSTEM || this.data.GuildChat) || this.data.chuanwen
		if (is_sys) {
			this.SetSystemData()
		} else {
			this.SetPlayerData()
		}
		this.normalGroup.visible = !is_sys
		this.sysGroup.visible = is_sys
	}

	public SetPlayerData(){
		if(!this.chat_item){
			this.chat_item = new ChatItem(this.normalGroup)
			this.chat_item.Load()
		}

		this.chat_item.SetData(this.data)
		this.chat_item.LayoutCallBack=(height?)=>{
			if(this.display_obj)this.display_obj.height=height
		}
	}



	public SetSystemData() {

		let chatVo = this.data
		let text = this._model.FormatLinkTag(chatVo.msg)
		text = this._model.FormatColorTag(text, false)
		text = this._model.changeToDark(text)
		this.sysContent.innerHTML = Trim(Util.StrToHTML(text))
		this.sysContent.style.width=470
		SetSizeDeltaY(this.display_obj, this.sysContent.contextHeight + 15)
	}


	public DeleteMe() {
		if(this.chat_item){
			this.chat_item.DeleteMe()
			this.chat_item=null
		}
		super.DeleteMe()
	}

	public myId() {

		return RoleManager.GetInstance().GetMainRoleId()
	}



	normalGroup: Laya.Box
	sysGroup: Laya.Box
	sysContent: Laya.HTMLDivElement
	_Group1: Laya.Box
	sysIcon: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this.normalGroup,
			this.sysGroup,
			this.sysContent,
			this._Group1,
			this.sysIcon,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"normalGroup",
				"sysGroup",
				"sysContent",
				"_Group1",
				"sysIcon",
				"_Label1",
			])
	}
}
window["EveningChatItem"] = EveningChatItem