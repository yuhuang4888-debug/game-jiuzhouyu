import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ChatModel, CHAT_TYPE, ChatModelEvent } from "../commonModel/ChatModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class SystemItem extends BaseItem1 {
	data
	is_last_msg
	model
	needRefreshData
	use_local_view

	sysCon
	txt_sys_content
	txt_sys_channel
	sysIcon
	SpriteGraphic: Laya.Box
	_Group1: Laya.Box


	public constructor(parent) {
		super(parent)

		this.base_file = "chat"
		this.layout_file = "SystemItem"
		// this.use_local_view = true
		this.model = ChatModel.GetInstance()
		this.is_delay_callback=true
		this.Load()
		this.load_callback = () => {

			this.LoadSuccess()

			if (this.needRefreshData) {
				this.UpdateItem()
				this.needRefreshData = null
			}
		}
	}


	public LoadSuccess() {
		this.InitEvent()
		if (PlatformManager.IsEyouEnPlatform()) {
			this.txt_sys_channel.size = 20
		}
	}

	//获取消息发送者id
	public GetSenderPlayerId() {

		let player_id = this.data.player_id || this.data.player_list[0].player_id
		return player_id
	}

	public InitEvent() {


	}

	public SetData(data?, is_last_msg?) {

		this.data = data
		this.is_last_msg = is_last_msg
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.needRefreshData = true
		}
	}

	public UpdateItem() {

		let data = this.data
		if (data) {
			let msg = data.msg
			if (this.data.result == 1) {
				msg = this.model.disposeChtaGoods(data.msg, this.data, this.data.player_id);
			}
			msg = this.model.FormatColorTag(msg, false)
			msg = this.model.changeToDark(msg)
			this.sysCon.visible = true
			let chatVo = this.data
			let title = "系统"
			let src = "mainUI_chat_1"
			if (this.data.channel == CHAT_TYPE.SYSTEM) {
				src = "mainUI_chat_1"
				title = "系统"
			} else if (this.data.channel == CHAT_TYPE.WORLD || table.find(ChatModel.SPECIAL_CHANNEL, this.data.channel) != -1) {
				if (this.data.channel == CHAT_TYPE.SMALL_KUAFU) {
					title = "跨服"
					src = "mainUI_chat_4"
				} else if (this.data.channel == CHAT_TYPE.WORLD_KUAFU) {
					title = "活动"
					src = "mainUI_chat_5"
				}
			} else if (this.data.channel == CHAT_TYPE.GUILD) {
				src = "mainUI_chat_3"
				title = "结社"
			} else if (this.data.channel == CHAT_TYPE.TEAM) {
				title = "组队"
				src = "mainUI_chat_9"
			} else if (this.data.channel == CHAT_TYPE.SEA) {
				title = "海域"
				src = "mainUI_chat_7"
			}
			// this.txt_sys_channel.text = title
			ResManager.GetInstance().SetImageSprite(this, this.sysIcon, "mainUI_asset", src)
			// msg=msg.replace("<a@","<a href='@")
			// msg=msg.replace("@>","@'>")
			msg=ChatModel.GetInstance().disposeChtaFace(msg,70,48,24)
			// SetInlineText(this.txt_sys_content, msg, null, true)
			this.txt_sys_content.style.fontSize=24
			this.txt_sys_content.style.color="#53433b"
			this.txt_sys_content.style.leading=5
			this.txt_sys_content.innerHTML = msg
			this.txt_sys_content.width=465
			this.txt_sys_content.on(Laya.Event.LINK,this, (text?)=>{
				this.model.LinkEvtInChatItem(text)
				this.model.Fire(ChatModelEvent.CLOSECHATPANEL)
			});
			this.display_obj.height=this.txt_sys_content.contextHeight+5
			if(this.data.channel== CHAT_TYPE.WORLD && this.data.chuanwen){
				this.display_obj.height=this.txt_sys_content.contextHeight+10
			}
			// AddInlineLickEvent(this.txt_sys_content,(param_list?) => {

			// 	})
			if (this.is_last_msg) {
				// GlobalEventSystem.FireNextFrame(ChatModelEvent.KEEP_CHATVIEW_MSG_NEW)
				GlobalEventSystem.Fire(ChatModelEvent.KEEP_CHATVIEW_MSG_NEW)
			}
		}
	}

	//清除界面
	public DeleteMe() {
		super.DeleteMe()
	}

	public ClickLink(evt?){ 
	
		this.model.LinkEvtInChatItem(evt)
	  }



	public GetComponents() {
		[
			this.sysCon,
			this.txt_sys_content,
			this.SpriteGraphic,
			this._Group1,
			this.sysIcon,
			this.txt_sys_channel,
		]
			= this.GetChildrenByNames([

				"sysCon",
				"txt_sys_content",
				"SpriteGraphic",
				"_Group1",
				"sysIcon",
				"txt_sys_channel",
			])
	}
}

window["SystemItem"]=SystemItem