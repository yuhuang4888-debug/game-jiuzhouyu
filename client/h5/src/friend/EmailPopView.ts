import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { ChatModel } from "../commonModel/ChatModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, SetSizeDelta, Split, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { EmailPopViewItem } from "./EmailPopViewItem"

export class EmailPopView extends BaseView1 {
	InitEvent
	LoadSuccess
	back_login_toClose
	click_bg_toClose
	close_callback
	destroy_callback
	emailId
	is_center
	loop_mgr
	open_callback
	show_open_movie
	updateInfo
	use_background

	public constructor() {
		super()


		this.emailId = 0;
		this.base_file = "friend"
		this.layout_file = "EmailPopView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.destroy_imm = true
		let _goodslist = []
		let _arrayCollection = null
		let _model = null
		let _data = null
		let itemArr = []
		let length = 0
		let local_OpenFun = OpenFun
		this.load_callback = () => {
			_model = FriendModel.GetInstance()
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	SetAnchoredPositionX(this._Label2,20)
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label2.size  = 20
			// 	this._Label3.size  = 20
			// }
			this.InitEvent()
		}

		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.destroy_callback = () => {
			for (let key in itemArr) {

				// [ts2lua]itemArr下标访问可能不正确
				itemArr[key].DeleteMe()
			}
			itemArr = []
		}

		this.open_callback = () => {

			// this.RegisterMask(this.Viewport)
			this.updateInfo()
		}

		this.InitEvent = () => {
			let getClick = () => {
				if (_data.is_receive == 1) {
					this.Close();
					let _next_mail_id: number = _model.nextMailId();
					if( _next_mail_id > -1 && _next_mail_id != _data.mail_id){
						
						_model.Fire(FriendEvent.REQUEST_EMAIL_INFO, _next_mail_id)
					}
					// Message.show("附件已经被领取")
					return
				}
				let get = () => {
					_model.Fire(FriendEvent.REQUEST_EMAIL_REWARD, { _data })
				}

				GoodsModel.GetInstance().CheckEquipNum(length, 0, get)
			}

			Util.AddClickEvent(this.btnGet, getClick, this, true)
			let closeClick = () => {
				this.Close()
			}

			let closeClick2 = () => {
				let _next_mail_id: number = _model.nextMailId();
				this.Close();
				if( _next_mail_id > -1 && _next_mail_id != _data.mail_id){
					_model.Fire(FriendEvent.REQUEST_EMAIL_INFO, _next_mail_id)
				}
			}

			//Util.AddClickEvent(this.btnClose, closeClick, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.btnClose2, closeClick2, this, true)
			Util.AddClickEvent(this.close, closeClick, this, true)

			let update = () => {
				if (this.is_loaded && this.isPop) {
					this.updateInfo()
				}
			}

			this.BindEvent(_model, FriendEvent.EMAIL_REWARD_UPDATE, update)
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("common2","uitc_001"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this.Image111, GameResPath.GetIcon("friend", "uirwv4_007"))
		}

		this.updateInfo = () => {
			_data = _model.getEmailInfo(this.emailId)
			if (_data) {
				this.sendName.text = _data.sender
				this.title.text = _data.title
				if (typeof (_data.content) == "string") {
					this.content.style.color="#663915"
					this.content.style.fontSize=20
					this.content.style.leading=20
					let text = _model.formatEmailContent(_data.content)
					let colorList=text.match(/color@[0-9]*/gi)
					if(colorList){
						for(let key in colorList){
							let color=colorList[key]
							let colorNumber=Number(color.replace("color@",""))
							let finalColor=ColorUtil.GetColorDark(colorNumber);
							text=text.replace(/color@[0-9]*/,"font color="+finalColor)
							text=text.replace("/color","/font")
						}
					}
					if(text && text != ""){
						let replaceFunc = (match?) => {
							let str = match.substring(1, match.length - 1)
							return `<font href = 'event:${str}'>`
						}
						text = text.replace(/<a@.+?>/gi, replaceFunc)
						text = text.replace(/<\/a>/gi, "</font>")
					}
					
					this.content.innerHTML=text
					this.content.width=533
					this.content.on(Laya.Event.LINK,this, (text?)=>{
						let param_list = Split(text, "@");
						if(param_list[1] == 'open_fun' && param_list[1] != null){
							this.Close()
							local_OpenFun.OpenFunHandler(Number(param_list[2]))
							
						}
					});
				}
				this.btnGet.visible = _data.attachment.length > 0
				this.Image111.visible = _data.attachment.length > 0
				this.btnClose2.visible = !this.btnGet.visible
				if(_data.attachment.length > 0 && _data.is_receive == 0){
					this._Label_get.text = "领取"
					this._Label_get.strokeColor = "#c95b37";
					ResManager.GetInstance().SetImageSprite(this, this._Image_get, "common_asset", "uian_010b")

				}else{
					let _next_mail_id: number = _model.nextMailId();
					this._Label_close.text = this._Label_get.text = _next_mail_id > -1 && _next_mail_id != _data.mail_id? "下一封": "关闭";
					ResManager.GetInstance().SetImageSprite(this, this._Image_get, "common_asset", "uian_0120b")
					this._Label_get.strokeColor = "#3e9298";
				}
				
				// this.bg.sizeDelta = new Vector2(this.bg.sizeDelta.x,_data.attachment.length > 0 && 359 || 245)
				SetSizeDelta(this.bg, this.bg.width, _data.attachment.length > 0 && 384 || 245)
				// let a = this.bg.sizeDelta
				// this.bg1.sizeDelta =new  Vector2(this.bg1.sizeDelta.x,_data.attachment.length > 0 && 675 || 555)
				SetSizeDelta(this.bg1, this.bg1.width, _data.attachment.length > 0 && 675 || 555)
				// let b = this.bg1.sizeDelta
				// this.bg2.sizeDelta = new Vector2(this.bg2.sizeDelta.x,_data.attachment.length > 0 && 603 || 483)
				SetSizeDelta(this.bg2, this.bg2.width, _data.attachment.length > 0 && 603 || 483)
				// let c = this.bg2.sizeDelta
				let [data, length] = _model.emailReward(_data.attachment, _data.is_receive)
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
					this.loop_mgr.SetData(this.Content_list, EmailPopViewItem, data, LoopScrCon.Horizontal, 1)
				} else {
					this.loop_mgr.replaceAll(data)
				}
			}
		}


	}
	bg1: Laya.Image
	bg2: Laya.Image
	_Image1: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	bg: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label2: Laya.Label
	_Label3: Laya.Label
	sendName: Laya.Label
	title: Laya.Label
	_Scroller1: Laya.Panel
	content: Laya.HTMLDivElement
	btnGet: Laya.Box
	_Label_get: Laya.Label
	_goods_scroller: Laya.Panel
	Content_list: Laya.List
	btnClose2: Laya.Box
	_Label_close: Laya.Label
	Image111: Laya.Image
	line: Laya.Image
	close: Laya.Image
	_Image_close: Laya.Image
	_Image_get: Laya.Image
	public GetComponents() {
		[
			this.bg1,
			this.bg2,
			this._Image1,
			this._Group1,
			this._Image2,
			this._Label1,
			this.bg,
			this._Image4,
			this._Image5,
			this._Label2,
			this._Label3,
			this.sendName,
			this.title,
			this._Scroller1,
			this.content,
			this.btnGet,
			this._Label_get,
			this._goods_scroller,
			this.Content_list,
			this.btnClose2,
			this._Label_close,
			this.Image111,
			this.line,
			this.close,
			this._Image_get,
			this._Image_close,
		]
			= this.GetChildrenByNames([

				"bg1",
				"bg2",
				"_Image1",
				"_Group1",
				"_Image2",
				"_Label1",
				"bg",
				"_Image4",
				"_Image5",
				"_Label2",
				"_Label3",
				"sendName",
				"title",
				"_Scroller1",
				"content",
				"btnGet",
				"_Label_get",
				"_goods_scroller",
				"Content_list",
				"btnClose2",
				"_Label_close",
				"Image111",
				"line",
				"close",
				"_Image_get",
				"_Image_close"
			])
	}
}
 window["EmailPopView"]= EmailPopView