import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Util } from "../util/Util"


export class FriendChatTabItem extends BaseItemRenderer {
	_Image1
	_Image2
	_gp_redDot
	_lb_name
	_lb_num
	_playerHead
	click
	head
	itemIndex
	public WIDTH = 158
	public HEIGT = 124
	public constructor(parent) {
		super()
		this.base_file = "friend"
		this.layout_file = "FriendChatTabItem"
		this.Load()
	}

	public load_callback() {

		Util.AddClickEvent(this.click, () => {
			ChatModel.GetInstance().reSetPrivateNum(this.data.role_id)
			FriendModel.GetInstance().openChatId = this.data.role_id
			FriendModel.GetInstance().Fire(FriendEvent.UPDATE_CHAT_VIEW, this.data)
		}
			, this, true)

		let update = (e?) => {
			if(this.data){
				let id = this.data.role_id
				let openopenChatId=FriendModel.GetInstance().openChatId
				if ((this.data && e == id) && (id != openopenChatId)) {
						this.updateChat()
				}
			}
		}

		let _model = ChatModel.GetInstance()
		this.BindEvent(_model, ChatModelEvent.CHAT_MSG_NUM_UPDATE, update)
		this.BindEvent(_model, ChatModelEvent.CHAT_MSG_UPDATE, update)
	}

	public DeleteMe() {

		if (this._playerHead) {
			this._playerHead.DeleteMe()
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if(super.dataChanged()){
			this._lb_name.text = this.data.role_name
			let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
			let lv = this.data.lv
	
			if (this._playerHead == null) {
				this._playerHead = new CustomHeadItem(this.head)
				this._playerHead.Load()
			}
			this._playerHead.SetRoleVoData(this.data)
	
			//this._playerHead.setData(this.data.lv, this.data.career, this.data.picture, null, null, frame_id)
			if(this.index!=0){
				this.updateChat()
			}
			if (this.index == 0) {
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "friend_asset", "uilt_018", true)
			} else {
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "friend_asset", "uilt_019", true)
			}
		}
	}

	public updateChat() {
		let num = this.GetchatNum()
		this._gp_redDot.visible = num > 0
		if (this._gp_redDot.visible) {
			this._lb_num.text = String(num)
		}
	}

	public GetchatNum() {

		let num = 0
		let obj = ChatModel.GetInstance().getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
		let sendId = this.data.role_id
		if (obj[String(sendId)]) {
			// [ts2lua]obj下标访问可能不正确
			num = obj[sendId][1]
		}
		return num
	}

	public Getindex() {

		return this.itemIndex
	}

	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._gp_redDot,
			this._Image2,
			this._lb_num,
			this.head,
			this.click,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_gp_redDot",
				"_Image2",
				"_lb_num",
				"head",
				"click",
			])
	}
}

window["FriendChatTabItem"] = FriendChatTabItem