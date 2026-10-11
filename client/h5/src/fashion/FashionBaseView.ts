import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { FashionModel } from "../commonModel/FashionModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DressEvent, DressModel } from "../commonModel/DressModel"
import { PlatformManager } from "../PlatformManager"

import "../dress/DressView"
import "../dress/DressSubView"
import "./FashionMainView"
import "./HeadFashionMainView"
import "./FashionSuitView"
import { RedKey } from "../common/RedDotDefine"


let local_GlobalEventSystem = GlobalEventSystem
let local_FashionModel = FashionModel
export class FashionBaseView extends BaseWindowComponent {
	InitMyEvent
	public constructor() {
		super()
		let fashion_model = FashionModel.GetInstance()
		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let isbackId_ = false
		this.destroy_imm = true
		this.dependent_res = ["fashion", "dress"]
		this.titleStr = "fashion.fashion_icon_image"
		this.tabStrList = [
			{ label: "时装"},
			{ label: "发饰"},
			{ label: "装扮"},
			{ label: "套装"}
		]
		this.viewClassList = [
			"FashionMainView", 
			"HeadFashionMainView", 
			"DressView",
			"FashionSuitView"
		]

		this.bg_list = [
			"ui_role_bg3.jpg", 
			"ui_role_bg3.jpg", 
			"ui_role_bg4.jpg",
			"ui_role_bg7.jpg"
		]

		this.window_load_back = () => {
			this.InitMyEvent()
			let red0 = fashion_model.IsPosShowRed(local_FashionModel.FashionType.Fashion)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", 0, red0)
			let red2 = fashion_model.IsPosShowRed(local_FashionModel.FashionType.Head)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", 1, red2)

			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", 3, fashion_model.GetSuitRedState())

		}

		this.tab_new_cond = {
			"0": () => {
				return !PlatformManager.GetInstance().is_wx_alpha
			}
		}

		this.InitMyEvent = () => {
			let dot_fun = () => {
				local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", 2, DressModel.GetInstance().DressCanShowRedDot())
			}

			this.BindEvent(DressModel.GetInstance(), DressEvent.DRESS_UPDATE_RED_DOT, dot_fun)
			dot_fun()
		}

		this.BaseWindowCloseFunc = () => {
			super.BaseWindowCloseFunc()
			if (!isbackId_) {
				local_GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
			}
			isbackId_ = false
		}
	}

	public Open(...new_args) {

		let parms = new_args
		if (parms && parms.length > 0) {
			this.SetIndexParameter(parms[0], parms[1], parms[3])
		}
		super.Open()
	}

}
window["FashionBaseView"] = FashionBaseView