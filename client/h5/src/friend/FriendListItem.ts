import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, HtmlColorTxt, SetLocalScale } from "../util/Util"

export class FriendListItem extends BaseItemRenderer {
	_head_main
	_model
	_vip_icon
	_vo
	firstLod
	head
	name_gp

	lb_name
	lb_online
	lb_fight
	_lb_intimacy
	chatNumLabel
	chatBtn
	touchGroup
	redDotGroup
	_Group1
	bg

	public HEIGT = 120
	public WIDTH = 673
	public constructor(parent) {
		super()

		this.base_file = "friend"
		this.layout_file = "FriendListItem"
		// this.skinName="resource/game/friend/exml/FriendListItemExml.exml"
		this._model = FriendModel.GetInstance()
		this.Load()
		this.firstLod = true;
	}

	public load_callback() {
		// this.name_gp = this._Group1

		if (PlatformManager.IsEyouEnPlatform()) {
			SetAnchoredPositionX(this._lb_intimacy, 155)
		}
		this.InitEvents()
	}

	public InitEvents() {
		let chatClick = () => {
			this._model.Fire(FriendEvent.OPEN_CHAT_VIEW, this._vo)
		}

		Util.AddClickEvent(this.chatBtn, chatClick, this, true)
		ResManager.GetInstance().SetImageSpriteTrans(this, this.bg, GameResPath.GetIcon("friend", "uitc_007"))
		Util.AddClickEvent(this.touchGroup, (e?, x?, y?) => {
			if (this.data == null) { return }
			if (RoleManager.GetInstance().GetMainRoleId() == this.data.role_id) {
				return
			}
			//Laya.Tween.get(this.clickGroup):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn):to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut).call(() => {
			//Laya.Tween.removeTweens(this.clickGroup)
			//}
			//)
			this._model.Fire(FriendEvent.OPEN_FRIEND_MENU, e.stageX, e.stageY, this._vo)
			//evt:stopImmediatePropagation()
		}, this)
		let update = (e?) => {
			if ((this._vo && e == this._vo.role_id) && e != this._model.openChatId) {
				this.updateChat()
			}
		}
		this.BindEvent(ChatModel.GetInstance(),ChatModelEvent.CHAT_MSG_CHANGE,update)
		this.BindEvent(ChatModel.GetInstance(),ChatModelEvent.CHAT_MSG_UPDATE,update)
		this.BindEvent(ChatModel.GetInstance(), ChatModelEvent.CHAT_MSG_NUM_UPDATE,update)
		this.BindEvent(this._model, FriendEvent.INTIMACY_UPDATE, (data?) => {
			if(this.use_delete_method){
				return;
			}
			if ((!data || !this._vo) || data.role_id != this._vo.role_id) {
				return
			}
			this._lb_intimacy.text = data.intimacy + ''
		})

	}

	public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data == null) { return }
			this._vo = this.data
			this.lb_name.text = this._vo.role_name
			// [ts2lua]lua中0和空字符串也是true，此处this._vo.online_flag == 0需要确认

			if (this._vo.online_flag == 1) {
				this.lb_online.text = "(在线)"
				this.lb_online.color="#0a953e"
			} else if (this._vo.online_flag == 0) {
				let str = "(离线 " + (TimeUtil.GetTimeStrByServerTime(TimeUtil.getServerTime() - this._vo.offline_time)) + ")"
				this.lb_online.text = str
				this.lb_online.color="#ff4f50"
			}
			this.lb_fight.text = String(this._vo.combat_power)
			this._lb_intimacy.text = this._vo.intimacy + ''
			let vip_Lv = this._vo.vip
			let str
			this._vip_icon.visible = vip_Lv > 0
			if (this._vip_icon.visible) {
				if(this._vo.vip_hide > 0){
					str = "VIP-x"
					// SetLocalScale(this._vip_icon, 1.5, 1.5, 1)
					if (this._vo.is_supvip == 1) {
						str = "SVIP-x"
					// 	SetLocalScale(this._vip_icon, 1.8, 1.8, 1)
					}
				}else{
					str = "uivip_zjm_" + vip_Lv
					// SetLocalScale(this._vip_icon, 1.5, 1.5, 1)
					if (this._vo.is_supvip == 1) {
						str = "VIP_" + vip_Lv   
					// 	SetLocalScale(this._vip_icon, 1.8, 1.8, 1)
					}
				}
			
				ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
				// this._vip_icon.skin="resource/game/common4/texture/com_vip"+vip_Lv+".png"
				this.lb_name.x=39
			}else{
				this.lb_name.x=0
			}
			let frame_id = DressModel.GetInstance().GetDressByType(this._vo.dress_list, DressType.Photo)
			// LayoutRebuilder(this.name_gp)
			this.updateChat()
			//let photo_frame_id = RoleManager.GetInstance().mainRoleInfo.GetDressByType(DressType.Photo)
			//this._head_main.setData(null, local_RoleManager_Instance.mainRoleInfo.career, local_RoleManager_Instance.mainRoleInfo["picture"], null, null, photo_frame_id)

			if (this._head_main == null) {
				this._head_main = new CustomHeadItem(this.head)
				this._head_main.SetActiveLevel(true)
				this._head_main.Load()
			}
			this._head_main.SetRoleVoData(this._vo, null, null, this._vo.lv)
		}
	}


	public updateChat() {
		if(!this.use_delete_method){
			let num = this.GetchatNum()
			this.redDotGroup.visible = num > 0
			if (this.redDotGroup.visible) {
				this.chatNumLabel.text = String(num)
			}
		}
	}

	public DeleteMe() {

		if (this._head_main) {
			this._head_main.DeleteMe()
			this._head_main = null
		}
		super.DeleteMe()
	}

	public GetchatNum() {

		let num = 0
		let obj = ChatModel.GetInstance().getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
		let sendId = this._vo.role_id
		if (obj[sendId]) {
			// [ts2lua]obj下标访问可能不正确
			num = obj[sendId][1]
		}
		return num
	}
	clickGroup: Laya.Box
	gp: Laya.Box
	Image: Laya.Image
	text: Laya.Label
	_Image1: Laya.Image
	_Group2: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	public GetComponents() {
		[
			this.clickGroup,
			this.bg,
			this._Group1,
			this.lb_name,
			this.gp,
			this.lb_online,
			this._vip_icon,
			this.Image,
			this.text,
			this.lb_fight,
			this._Image1,
			this.chatBtn,
			this._Group2,
			this._Image2,
			this._Label1,
			this._lb_intimacy,
			this.touchGroup,
			this.redDotGroup,
			this._Image3,
			this.chatNumLabel,
			this.head,
		]
			= this.GetChildrenByNames([

				"clickGroup",
				"bg",
				"_Group1",
				"lb_name",
				"gp",
				"lb_online",
				"_vip_icon",
				"Image",
				"text",
				"lb_fight",
				"_Image1",
				"chatBtn",
				"_Group2",
				"_Image2",
				"_Label1",
				"_lb_intimacy",
				"touchGroup",
				"redDotGroup",
				"_Image3",
				"chatNumLabel",
				"head",
			])
	}
}

window["FriendListItem"] = FriendListItem