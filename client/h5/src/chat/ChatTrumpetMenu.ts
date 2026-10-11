import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ChatModel, TRUMPET_TYPE, ChatModelEvent } from "../commonModel/ChatModel"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { Message } from "../sysInfo/SysInfoController"
import { SetSizeDeltaY } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { ChatTrumpetMenuItem } from "./ChatTrumpetMenuItem"

export class ChatTrumpetMenu extends BaseView1 {
	InitEvent
	LoadSuccess
	Local_Open
	btnClickHandler
	btnGroup
	destroy_imm
	img_bg
	open_callback
	open_mode
	updateView
	x
	y


	public constructor() {
		super()

		this.base_file = "chat"
		this.layout_file = "ChatTrumpetMenu"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.back_login_toClose = true
		let _model = ChatModel.GetInstance()
		let _btnList = []
		let _localPoint = null
		let local_TRUMPET_TYPE = TRUMPET_TYPE
		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.display_obj.x = _localPoint.x
			// this.y = _localPoint.y + 45
			this.display_obj.y = _localPoint.y
			// this.form.anchoredPosition = Vector2(_localPoint.x, _localPoint.y)
			this.display_obj.height=150;
		}

		this.InitEvent = () => {

		}

		this.Local_Open = (...new_args) => {
			let args = new_args
			_localPoint = args[0][1]
			super.Open()
		}

		this.LoadSuccess = () => {
			this.updateView()
		}

		this.updateView = () => {
			let btnList = [local_TRUMPET_TYPE.WORLD, ]
			let btn = null
			let type = null
			let index = 0
			let i = 0
			if(ChatModel.GetInstance().kuaFuOpenData()){
				btnList.push(local_TRUMPET_TYPE.SMALL_KUAFU)
			}
			if(DiamondFightModel.GetInstance().stage_info.war_state == 1||( Kf1vnModel.GetInstance().stage_info.stage >= 2 && Kf1vnModel.GetInstance().stage_info.stage < 6)){
				btnList.push(local_TRUMPET_TYPE.KUAFU)
			}
			do {
				btn = _btnList[i]
				if (!btn) {
					// btn = eui. new Button()
					// table.insert(_btnList, btn)
					// this.btnGroup.addChild(btn)
					// btn.addEventListener(Laya.TouchEvent.TOUCH_TAP, this.btnClickHandler, this)
					btn = new ChatTrumpetMenuItem(this.btnGroup)
					btn.Load()
				}
				// btn.skinName = "resource/game/chat/exml/ChatTrumpetMenuItemExml.exml"
				type = btnList[i]
				let label = _model.trumpetName(type)
				// btn.label = label
				// btn.name = type + ""
				btn.SetData({ label: label, name: type + "", clickFunc: this.btnClickHandler })
				index = index + 1
				i = i + 1
			} while ((i < btnList.length))
			if (index < _btnList.length) {
				let i = _btnList.length - 1
				do {
					btn = _btnList[i]
					// this.btnGroup.removeChild(btn)
					// _btnList.splice(i, 1)
					btn.SetVisible(false)
					i = i - 1
				} while ((i >= index))
			}
			// this._bg.height = btnList.length * 40 + 33
			SetSizeDeltaY(this.img_bg, btnList.length * 40 + 33)
		}

		// this.btnClickHandler = ( e?) => {
		this.btnClickHandler = (item?) => {
			// let btn = e.currentTarget
			// let type = Number(btn.name)
			let type = Number(item.data.name)
			if (type == local_TRUMPET_TYPE.SMALL_KUAFU && !_model.SmallKuaFuOpen()) {
				Message.show("跨服频道暂未开放")
			} else {
				_model.Fire(ChatModelEvent.SELECT_TRUMPET_TYPE, type)
			}
			this.Close()
		}


	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
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

window["ChatTrumpetMenu"] = ChatTrumpetMenu