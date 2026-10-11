import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { ErlangParser } from "../util/ErlangParser"
import { MarriageModel } from "../commonModel/MarriageModel"

export class MarriageHonourItem extends BaseItemRenderer {
	WIDTH = 502
	HEIGT = 93

	_model

	public constructor() {
		super()
		this.base_file = "marriage"
		this.layout_file = "MarriageHonourItem"
		this._model = MarriageModel.GetInstance()

		this.load_callback = () => {
			this._lb_attr.style.fontSize = 22
			this._lb_attr.style.color = "#ef8d9f"
			this._lb_attr.style.wordWrap = false

			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {
		this.BindVar(this._model, "_flower_info", () => {
			this.SetFameData(this.data)
		})
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (!this.data) {
			return
		}
		let data = this.data
		//this._lb_name.color = ColorUtil.GetNumColorLight(data.color)
		this._lb_title.text = data.name
		let str = this._model.GetHonourAttrStr(JSON.parse(data.attr), "'#a13a4d'")
		this._lb_attr.innerHTML = Util.StrToHTML(str)
		this.SetFameData(data)
	}

	public SetFameData(data?) {
		let fame = this._model.GetRoleFame()
		let lock = data.fame > fame
		this._img_unlock.visible = !lock

		//this._lb_honour.color = lock && Color(156 / 255, 156 / 255, 156 / 255, 255 / 255) || Color(239 / 255, 141 / 255, 159 / 255, 255 / 255)
		this._lb_honour.text = data.fame
	}

	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_lb_honour: Laya.Label
	_lb_attr: Laya.HTMLDivElement
	_img_title: Laya.Image
	_lb_title: Laya.Text
	_img_unlock: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_icon,
			this._lb_honour,
			this._lb_attr,
			this._img_title,
			this._lb_title,
			this._img_unlock,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_icon",
				"_lb_honour",
				"_lb_attr",
				"_img_title",
				"_lb_title",
				"_img_unlock",
			])
	}
}
window["MarriageHonourItem"] = MarriageHonourItem