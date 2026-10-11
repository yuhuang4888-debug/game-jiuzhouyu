import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GhostWalkEvent, GhostWalkModel } from "../commonModel/GhostWalkModel"
import { Util } from "../util/Util"

export class GhostWalkChatMenuView extends BaseView1 {

	InitEvent
	Local_Open
	click_target: any
	_localPoint
	_btn_txt
	public constructor() {
		super()

		this.base_file = "ghostWalk"
		this.layout_file = "GhostWalkChatMenuView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		let _localPoint = null
		this.load_callback = () => {

			this.InitEvent()
		}

		this.close_callback = () => {

		}

		this.open_callback = () => {
			this.display_obj.x = _localPoint.x + 70
			this.display_obj.y = _localPoint.y + 20
			this.lblGo.text=this._btn_txt
		}

		// isPicture 是否自定义头像
		this.Local_Open = (...new_args) => {
			[this.click_target,this._btn_txt] = new_args
			if (!this.click_target) return
			_localPoint = this.click_target.localToGlobal(new Laya.Point(0, 0), true)
			super.Open()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btnGo,()=>{
				GhostWalkModel.ins.Fire(GhostWalkEvent.CLICK_GROUP_BTN);
				this.Close()
			},this,true)
		}


	}
	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	img_bg: Laya.Image
	btnGo: Laya.Image
	lblGo: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.btnGo,
			this.lblGo,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"btnGo",
				"lblGo",
			])
	}
}
window["GhostWalkChatMenuView"] = GhostWalkChatMenuView