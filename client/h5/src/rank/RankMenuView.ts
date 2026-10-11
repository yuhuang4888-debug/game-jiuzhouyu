import { BaseView1 } from "../common/BaseView1"
import { CustomRoleHead } from "../common/CustomRoleHead"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { SetSizeDeltaY, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"

export class RankMenuView extends BaseView1 {
	img_bg: Laya.Image
	btnGroup: Laya.VBox
	btn_1: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	btn_2: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	btn_3: Laya.Box
	_Image3: Laya.Image
	_Label3: Laya.Label
	InitEvent
	SetData
	_role_id
	addIndex
	background_alpha
	click_bg_toClose
	close_callback
	destroy_imm
	initView
	isPicture
	open_callback
	removeEvent
	show_open_movie
	updateView
	use_background

	public constructor() {
		super()

		this.base_file = "rank"
		this.layout_file = "RankMenuView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		let local_FriendModel = FriendModel.GetInstance()
		let _localPoint_ = null
		let _server_id_ = null
		let _btnList = []
		this.load_callback = () => {

			this.InitEvent()
			this.initView()
		}

		this.close_callback = () => {
			this.removeEvent()
		}

		//this.open_callback = () => {

		//}

		this.InitEvent = (name?,btn?) => {
			//this:BindEvent(GlobalEventSystem, EventName.STAGE_CLICK_EVENT,() => {
			//this:Close()
			//}
			//)
			if ("查看信息" == name) {
				Util.AddClickEvent(btn, () => {
					local_FriendModel.requestPlayerMessage(this.role_id())
					this.Close()
				}, this)

			} else if ("加为好友" == name) {
				Util.AddClickEvent(btn, () => {
					let info = local_FriendModel.getMenuData(this.role_id());
					// if ((info && this._vo.rela == 1)) {
					// 	Message.show("对方已是您的好友")
					// 	return
					// }
					local_FriendModel.Fire(FriendEvent.ADD_FRIEND, this.role_id())
				}, this)
				// } else if ("踢出禁卫" == name) {
				// 	SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.REMOVE_SOLDIER, this.role_id())
			} else if ("举报头像" == name) {
				Util.AddClickEvent(btn, () => {
					CustomRoleHead.GetInstance().ComplainRoleHead(this.role_id())
				}, this)
			}
		}

		this.initView = () => {
			if (_localPoint_ ) {
				this.display_obj.x =_localPoint_.x
				this.display_obj.y=_localPoint_.y
			}
			this.updateView()
		}

		this.updateView = () => {
			if (this.is_loaded) {
				let btnList = ["查看信息", "加为好友"]
				// if (this.addIndex == 1) {
				// 	table.insert(btnList, "踢出禁卫")
				// }

				if (this.isPicture) {
					table.insert(btnList, "举报头像")
				}

				let btn = null
				let label = ""
				let i = 0
				if ((i < btnList.length)) {
					do {
						btn = btnList[i]
						let source = null
						let label = btnList[i]
						if (label == "踢出禁卫" || label == "举报头像") {
							source = "com_rect_btn3"
						} else {
							source = "com_rect_btn5"
						}
						this["_Label"+(i+1)].text=btn
						this.InitEvent(btn,this["btn_"+(i+1)])
						// if (!btn) {
						// 	btn = NewImage(this, this.btnGroup, new Vector2(149, 60), this.layer_value, true, () => {
						// 		if ("查看信息" == label) {
						// 			local_FriendModel.requestPlayerMessage(this.role_id())
						// 		} else if ("加为好友" == label) {
						// 			let info = local_FriendModel.getMenuData(this.role_id());
						// 			if ((info && this._vo.rela == 1)) {
						// 				Message.show("对方已是您的好友")
						// 				return
						// 			}
						// 			local_FriendModel.Fire(FriendEvent.ADD_FRIEND, this.role_id())
						// 		} else if ("踢出禁卫" == label) {
						// 			SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.REMOVE_SOLDIER, this.role_id())
						// 		} else if ("举报头像" == label) {
						// 			CustomRoleHead.GetInstance().ComplainRoleHead(this.role_id())
						// 		}
						// 		this.Close()
						// 	}, null, null, source, { x: 0, y: 1 })
						// 	let font_size = 24
						// 	// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
						// 	// 	font_size = 20
						// 	// }
						// 	NewText(btn, 149, font_size, label, UnityEngine.TextAnchor.MiddleCenter, this.layer_value, null, null, null, null, null, Vector2(-75, -15))
						// 	table.insert(_btnList, btn)
						// }
						// btn.visible = true
						i = i + 1
					} while ((i <= btnList.length))
					this.btn_3.visible=false
					// this.img_bg.height=187
				}
				// SetSizeDeltaY(this.img_bg, btnList.length * 60 + 15)
			}
		}

		this.removeEvent = () => {
			_btnList = []
			this.addIndex = null
		}

		this.SetData = (point?, role_id?, server_id?, index?, isPicture?) => {
			_localPoint_ = point
			this._role_id = role_id
			_server_id_ = server_id
			this.addIndex = index
			this.isPicture = isPicture
		}
	}

	public role_id() {

		return this._role_id
	}

	public GetComponents() {
		[
			this.img_bg,
			this.btnGroup,
			this.btn_1,
			this._Image1,
			this._Label1,
			this.btn_2,
			this._Image2,
			this._Label2,
			this.btn_3,
			this._Image3,
			this._Label3,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"btnGroup",
				"btn_1",
				"_Image1",
				"_Label1",
				"btn_2",
				"_Image2",
				"_Label2",
				"btn_3",
				"_Image3",
				"_Label3",
			])
	}
}
window["RankMenuView"]=RankMenuView