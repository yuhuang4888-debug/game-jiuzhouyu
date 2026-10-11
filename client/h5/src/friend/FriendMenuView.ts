import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CustomRoleHead } from "../common/CustomRoleHead"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetAnchoredPosition, SetSizeDeltaY, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class FriendMenuView extends BaseView1 {
	InitEvent
	_localX
	_localY
	_vo
	btn_gp
	initView
	updateView

	btnGroup :Laya.VBox
	_bg
	img_bg : Laya.Image

	public constructor() {
		super()


		this.base_file = "friend"
		this.layout_file = "FriendMenuView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.use_background = true
		this.click_bg_toClose = true
		// this.hide_maincancas = false
		this.background_alpha = 0
		let _model = FriendModel.GetInstance()
		let _rela = 0
		let _btnList = []
		let local_GlobalEventSystem = GlobalEventSystem
		let local_FriendEvent = FriendEvent
		this.load_callback = () => {
			this.btn_gp = this.btnGroup
			this.InitEvent()
		}

		this.close_callback = () => {
			_btnList = []
		}

		this.open_callback = () => {
			//延迟一帧执行，dis_object的povit在同一帧会异常变化，原因未知
			Laya.timer.frameOnce(1, this,()=>{
				if (this.use_delete_method) return
				this.initView()
			})
		}

		this.InitEvent = () => {

			let update = () => {
				this.updateView()
			}
			this.BindEvent(_model, local_FriendEvent.MENU_DATA_UPDTE, update)
		}

		this.initView = () => {
			if(this.is_loaded){
				this._bg = this.img_bg
				SetAnchoredPosition(this.display_obj, this._localX, this._localY)
				_model.Fire(local_FriendEvent.REQUEST_MENU_DATA, this._vo.role_id)
				// this.BindEvent(_model, local_FriendEvent.CLOSE_BUTTON_LIST, () => {
				// 	this.Close()
				// })
			}
		}

		this.updateView = () => {
			if (this.is_loaded) {
				let info = _model.getMenuData(this._vo.role_id)
				if (info) {
					_rela = info.rela
					let btnList = ["查看信息", "加为好友", "赠礼给TA", "拉入黑名单"]
					if (info.rela == 1) {
						// btnList = ["查看信息", "开始聊天", "删除好友", "赠礼给TA", "拉入黑名单"]
						btnList = ["查看信息", "开始聊天", "赠礼给TA", "删除好友", "拉入黑名单"]
					} else if (info.rela == 3 || info.rela == 4) {
						btnList = ["查看信息", "解除黑名单"]
					}

					if (btnList && btnList.length > 0) {
						for (let k in btnList) {
							let v = btnList[k]
						}
					}

					if (this._vo.picture && Number(this._vo.picture) == this._vo.role_id) {
						table.insert(btnList, "举报头像")
					}

					if (_btnList && _btnList.length > 0) {
						for (let i = 0; i < _btnList.length; i++) {
							if(_btnList[i]){
								_btnList[i].visible = false
								_btnList[i].destroy()
								_btnList[i]=null
							}
						}
					}
					SetSizeDeltaY(this._bg, btnList.length * 60 + 16)
					for (let i = 0; i < btnList.length; i++) {
						//if (_btnList[i] ) {
						//_btnList[i].visible = true 
						//}else{
						let label = btnList[i]
						let source = null
						if (label == "拉入黑名单" || label == "解除黑名单" || label == "举报头像" || label == "删除好友") {
							source = "resource/game/common/texture/com_rect_btn3.png"
						} else {
							source = "resource/game/common/texture/com_rect_btn1.png"
						}
						let btn = new Laya.Image();
						btn.skin=source
						btn.width = 149
						btn.height = 60;
						this.btnGroup.addChild(btn);
						let clickHandler=(e?) => {
							let btn = e

							if ("查看信息" == label) {
								_model.requestPlayerMessage(this._vo.role_id)
							} else if ("加为好友" == label) {
								_model.Fire(local_FriendEvent.ADD_FRIEND, this._vo.role_id)
							} else if ("拉入黑名单" == label) {
								_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 2, this._vo.role_id)
							} else if ("解除黑名单" == label) {
								_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 3, this._vo.role_id)
								FriendModel.GetInstance().Fire(FriendEvent.REQUEST_MENU_DATA, this._vo.role_id)
							} else if ("开始聊天" == label) {
								_model.Fire(local_FriendEvent.OPEN_CHAT_VIEW, this._vo)
							} else if ("删除好友" == label) {
								let str = "您确定要删除好友吗？"
								if (this._vo && this._vo.role_name) {
									str = "您确定要删除好友<font color='#639c12'>" + this._vo.role_name + "</font>吗？"
								}
								Alert.Show(str, Alert_Type.Two, () => {
									_model.Fire(local_FriendEvent.FRIENDS_OPERATIONT, 1, this._vo.role_id)
								}
									, null, "确定")
							} else if ("赠礼给TA" == label) {
								local_GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", this._vo)
							} else if ("举报头像" == label) {
								CustomRoleHead.GetInstance().ComplainRoleHead(this._vo.role_id)
							}
							this.Close()
						}
						Util.AddClickEvent(btn,clickHandler,this)
						// btn.on(Laya.Event.MOUSE_UP, this, );
						let text=new Laya.Label();
						btn.addChild(text)
						text.text=label
						text.fontSize=24
						text.color="#ffffff"
						text.centerX=0
						text.centerY=0
						_btnList[i] = btn
						let font_size = 24
						let lineSpacing = 1
						// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
						// 	font_size = 16
						// 	lineSpacing = 0.8
						if (PlatformManager.IsEyouEnPlatform()) {
							font_size = 20
							lineSpacing = 0.8
						}
						// NewText(_btnList[i],149,font_size,label,UnityEngine.TextAnchor.MiddleCenter,this.layer_value,null,null,null,null,null,new Vector2(0,-15), null, lineSpacing)
						//}
						_btnList[i].visible = true
					}
				} else {
					this.Close()
				}

			}
			//GlobalTimerQuest:AddDelayQuest(() => {
			//UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._bg)
			//},0.1)
		}




	}

	public setData(x?, y?, vo?) {

		this._localX  = x 
		this._localY = y
		this._vo = vo
	}

	public GetComponents() {
		[
			this.img_bg,
			this.btnGroup,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"btnGroup",
			])
	}
}

window["FriendMenuView"] = FriendMenuView