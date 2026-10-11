import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { chcModel } from "../commonModel/chcModel"

export class chcMasterIcon extends BaseItemRenderer {
	_model
	is_delay_callback
	WIDTH = 90
	HEIGT = 85
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcMasterIcon"
		this._model = chcModel.GetInstance()
		//this.is_delay_callback = false

		this.load_callback = () => {
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		let data = this.data
		//let info = this._model.GetInfoByStype(data._type, data.type)
		let lv = (data.vo && (data.vo.lv) || (0))
		let dark = lv < data.stage
		ResManager.GetInstance().SetImageSprite(this, this._img_icon, "chc", "chc_icon_" + data.pos)
		this._img_icon.gray = dark

		this._lb_lv.text = "+" + lv
		this._lb_lv1.text = "+" + lv
		this._lb_lv.visible = dark
		this._lb_lv1.visible = !dark
	}

	_img_icon: Laya.Image
	_lb_lv: Laya.Label
	_lb_lv1: Laya.Label
	public GetComponents() {
		[
			this._img_icon,
			this._lb_lv,
			this._lb_lv1,
		]
			= this.GetChildrenByNames([

				"_img_icon",
				"_lb_lv",
				"_lb_lv1",
			])
	}
}
window["chcMasterIcon"] = chcMasterIcon