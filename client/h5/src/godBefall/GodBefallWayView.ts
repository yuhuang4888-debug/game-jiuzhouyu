import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BossModel } from "../commonModel/BossModel"
import { OpenFun } from "../common/OpenFun"

export class GodBefallWayView extends BaseView1 {
	InitEvent

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallWayView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		this.load_callback = () => {
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_get, () => {
				this.Close()
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GodBefallEquipView")
				OpenFun.OpenFunHandler(135)
			}, this, true)
		}
	}

_Image1:Laya.Image
_Image2:Laya.Image
_btn_close:Laya.Image
_Image3:Laya.Image
_Label1:Laya.Label
_Image5:Laya.Image
_btn_get:Laya.Box
_Image6:Laya.Image
_Label2:Laya.Label
lb_title:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image2,
this._btn_close,
this._Image3,
this._Label1,
this._Image5,
this._btn_get,
this._Image6,
this._Label2,
this.lb_title,
]
 = this.GetChildrenByNames([
"_Image1",
"_Image2",
"_btn_close",
"_Image3",
"_Label1",
"_Image5",
"_btn_get",
"_Image6",
"_Label2",
"lb_title",
])
}
}

window["GodBefallWayView"] = GodBefallWayView