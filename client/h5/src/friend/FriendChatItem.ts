import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { SetLocalScale, GlobalTimerQuest, Util, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class FriendChatItem extends BaseItem1 {
	_head_main
	_model
	_offsetX
	_offsetY
	_str
	_vip_icon
	bitmapList
	chatBg
	data
	head
	is_last
	label
	myId
	name_gp
	need_refreshData
	need_update
	sendId
	timer_id
	width

	nameLabel
	_lb_time
	contentLabel
	titleGroup
	chatBg_img
	nameGroup
	_Image1: Laya.Image
	chLabel: Laya.Label
	SpriteGraphic: Laya.Box

	public constructor(parent) {
		super(parent)


		this._str = "";
		this._offsetX = 0;
		this._offsetY = 0;
		this.bitmapList = [];
		this.base_file = "friend"
		this.layout_file = "FriendChatItem"
		this._model = ChatModel.GetInstance()
		this.need_refreshData = false
		this.load_callback = () => {
			this.name_gp = this.nameGroup
			this.label = this.contentLabel

			if (this.need_refreshData) {
				this.SetData(this.data, this.is_last, this.need_update)
				this.need_refreshData = false
			}
		}
	}

	//function FriendChatItem.createChildren()
	//this._playerHead.addEventListener(Laya.TouchEvent.TOUCH_TAP, this.clickHead, this)
	//this.contentLabel.addEventListener(Laya.TextEvent.LINK, this.ClickLink, this)
	//}

	

	public SetData(data?, is_last?, need_update?) {

		this.data = data
		this.is_last = is_last
		this.need_update = need_update
		if (this.is_loaded) {
			//if (! this._gp.visible ) {
			//this._gp.visible = true
			//}
			this.myId = RoleManager.GetInstance().GetMainRoleId()
			if (!this.data) {
				return
			}
			let sendInfo = this.data.player_list[0]
			this.sendId = sendInfo.player_id
			let is_mine = this.sendId == this.myId
			//this:setPosition(this._playerHead, is_mine, 5)
			//this:setPosition(this.nameGroup, is_mine, 130)
			//this:setPosition(this.chatGroup, is_mine, 122)
			//this:setPosition(this.titleGroup, is_mine, 328)
			let dress_id = DressModel.GetInstance().GetDressByType(sendInfo.dress_list, DressType.Bubble)
			let resouce = null
			if (dress_id) {
				let str = is_mine && "_1" || "_0"
				resouce = DressType.Bubble + "_" + dress_id + str
				ResManager.GetInstance().SetImageSprite(this, this.chatBg_img, "chat", resouce)
				this.chatBg_img.sizeGrid = "35,67,35,58"
				if(dress_id == 2 || dress_id == 3 || dress_id == 4 || dress_id ==5|| dress_id ==6 || dress_id ==7){
					this.chatBg_img.top = 50
				}
			} else {
				if (is_mine) {
					if (!resouce) {
						resouce = "chat_contentbg2"
					}
					ResManager.GetInstance().SetImageSprite(this, this.chatBg_img, "chat_asset", resouce)
					//this.contentGroup.horizontalCenter = 3
					//this.chatBg.scaleX = -1
				} else {
					if (!resouce) {
						resouce = "chat_contentbg1"
					}
					ResManager.GetInstance().SetImageSprite(this, this.chatBg_img, "chat_asset", resouce)
				}
			}

			////this.contentGroup.horizontalCenter = -3
			////this.chatBg.scaleX = 1
			//}
			//let contentHtml = this.data.msg
			//if (this.data.result == 1 ) {
			//let send_player_vo = this.data.player_list[0]
			//contentHtml = this._model.disposeChtaGoods(contentHtml, this.data, send_player_vo.player_id)
			//}
			//contentHtml = this._model.FormatColorTag(contentHtml, false)
			//contentHtml = this._model.FormatLinkTag(contentHtml)
			let msg = data.msg
			if (data.result == 1) {
				msg = this._model.disposeChtaGoods(data.msg, data, data.player_list[0].player_id)
			}
			msg = this._model.FormatColorTag(msg, false)
			msg = this._model.changeToDark(msg)
			// AddInlineLickEvent(this.contentLabel,(param_list?) => {
			// 	})
			// SetInlineText(this.contentLabel, msg, null, true)
			// msg=msg.replace("<a@","<a href='@")
			// msg=msg.replace("@>","@'>")
			// msg=ChatModel.GetInstance().disposeChtaFace(msg)
			this.contentLabel.style.color = "#411d00";
			this.contentLabel.style.fontSize = 20;
			// this.contentLabel.style.valign="bottom"
			// ChatModel.GetInstance().disposeChtaFace(msg,msg,this.contentLabel,this.chatBg,[])
			msg=ChatModel.GetInstance().disposeChtaFace(msg,70,48,20)
			this.contentLabel.innerHTML=msg;
			// this.contentLabel.innerHTML = Util.StrToHTML(msg)
			this.contentLabel.width=330
			this.contentLabel.on(Laya.Event.LINK,this, (text?)=>{
				this._model.LinkEvtInChatItem(text)
			});
			this.nameLabel.text = " "+sendInfo.name+" "
			this._lb_time.text = this._model.timeFormat(this.data.time)
			let frame_id = DressModel.GetInstance().GetDressByType(sendInfo.dress_list, DressType.Photo)
			//this._playerHead.setData(sendInfo.level, sendInfo.career, sendInfo.picture, null, null, frame_id)
			if (this._head_main == null) {
				this._head_main = new CustomHeadItem(this.head)
				this._head_main.Load()
			}
			this._head_main.SetRoleVoData(sendInfo)
			let vip_Lv = sendInfo.vip_flag
			let is_hide_vip = sendInfo.is_hide_vip
			let str
			this._vip_icon.visible = vip_Lv > 0
			//this._vip_icon.includeInLayout = vip_Lv > 0
			if (this._vip_icon.visible) {
				if(is_hide_vip > 0){
					str = "VIP-x"
					SetLocalScale(this._vip_icon, 1, 1, 1)
					this._vip_icon.y = -4
					if (sendInfo.supreme_vip == 1) {
						str = "SVIP-x"
						SetLocalScale(this._vip_icon, 1, 1, 1)
						this._vip_icon.y = -9
					}
				}
				else{
					str = "uivip_zjm_" + vip_Lv
					SetLocalScale(this._vip_icon, 1, 1, 1)
					this._vip_icon.y = -4
					if (sendInfo.supreme_vip == 1) {
						str = "VIP_" + vip_Lv
						SetLocalScale(this._vip_icon, 1, 1, 1)
						this._vip_icon.y = -9
					}
				}
				if (this._vip_icon) {
					ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
				}
			}


			let size = this.contentLabel.contextHeight
			size = size + 90
			let x = 390

			let width = Math.min(size, x)
			this.chatBg_img.width = width
			//this.width = Math.min(this.contentGroup.width, 602)
			//this.chatBg.width = this.contentGroup.width + 70
			//this.chatBg.height = this.contentGroup.height + 50

			//if (this.need_update ) {
			//this.label.visible = false 
			if (this.timer_id) {
				this.timer_id = GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
			}
			// LayoutRebuilder(this.form)
			//this.label.visible = true 
			if (this.is_last) {
				this.timer_id = GlobalTimerQuest.AddDelayQuest(() => {
					FriendModel.GetInstance().Fire(FriendEvent.UPDATE_MSG_POS)
				}, 0.02)
			}

			this.layout(dress_id)
			this.nameBoxLayout()
			//}
			// LayoutRebuilder(this.name_gp)
		} else {
			this.need_refreshData = true
		}
	}

	public nameBoxLayout(){
		RefBoxChildsLayout(this.nameGroup, 2, null, true, "left");
	}

	public layout(dress_id?){
		let bg_width=0
		let bg_height=0
		// this.contentLabel.y=this.contentLabel.y-5
		if(this.contentLabel.contextHeight==20 ||this.contentLabel.contextHeight==40){
			this.contentLabel.y=this.contentLabel.y+5
		}
		if(this.contentLabel.contextHeight == 20){
			this.display_obj.height = 125	
		}else if (this.contentLabel.contextHeight==50 ){
			this.display_obj.height=150
		}else if(this.contentLabel.contextHeight==78){
			this.display_obj.height=180
		}else if(this.contentLabel.contextHeight == 106) {
			this.display_obj.height = 210
		} else{
			this.display_obj.height=140
		}
		if(dress_id ==2 || dress_id ==3|| dress_id ==4 || dress_id ==5|| dress_id == 6 || dress_id == 7 ){
			bg_height=this.contentLabel.contextHeight+45
			
		}else{
			bg_height=this.contentLabel.contextHeight+20
		}
		bg_width=50+this.contentLabel.contextWidth
		if(bg_height<45){
			bg_height=45
		}
		if(bg_width<70){
			bg_width=70
		}
		this.chatBg_img.width=bg_width
		this.chatBg_img.height=bg_height
	}

	public ClickLink(evt?) {

		this._model.LinkEvtInChatItem(evt)
	}

	//function FriendChatItem.setPosition(group, is_mine, limit)

	//// [ts2lua]lua中0和空字符串也是true，此处is_mine需要确认
	//group.left = (is_mine && ( null ) || ( limit ) )
	//// [ts2lua]lua中0和空字符串也是true，此处is_mine需要确认
	//group.right = (is_mine && ( limit ) || ( null ) )
	//if (group == this.nameGroup ) {
	//// [ts2lua]lua中0和空字符串也是true，此处is_mine需要确认
	//this.nameGroup.setChildIndex(this._lb_time, (is_mine && ( 0 ) || ( this.nameGroup.numChildren - 1 ) ))
	//}
	//}

	public clickHead(e?) {

		let myId = RoleManager.GetInstance().GetMainRoleId()
		if (this.sendId == this.myId) {
			return
		}
		//Laya.Tween.get(this._playerHead):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn):to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut).call(() => {
		//Laya.Tween.removeTweens(this._playerHead)
		//}
		//)
		let isPicture = Number(this.data.picture) == this.sendId
		this._model.Fire(ChatModelEvent.OPEN_CHAT_MENU, e.currentTarget, this.sendId, this.data.ser_id, true, null, null, null, isPicture)
		//e:stopImmediatePropagation()
	}

	public DeleteMe() {

		if (this._head_main) {
			this._head_main.DeleteMe()
		}
		if (this.timer_id) {
			this.timer_id = GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		//this._playerHead.removeEventListener(Laya.TouchEvent.TOUCH_TAP, this.clickHead, this)
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.nameGroup,
			this.nameLabel,
			this._vip_icon,
			this._lb_time,
			this.titleGroup,
			this._Image1,
			this.chLabel,
			this.chatBg_img,
			this.chatBg,
			this.contentLabel,
			this.SpriteGraphic,
			this.head,
		]
			= this.GetChildrenByNames([

				"nameGroup",
				"nameLabel",
				"_vip_icon",
				"_lb_time",
				"titleGroup",
				"_Image1",
				"chLabel",
				"chatBg_img",
				"chatBg",
				"contentLabel",
				"SpriteGraphic",
				"head",
			])
	}
}

window["FriendChatItem"] = FriendChatItem