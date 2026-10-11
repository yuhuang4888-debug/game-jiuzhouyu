import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { SetSizeDelta, SetAnchoredPosition, Util, SetHtmlStyle, SetHtmlCenter } from "../util/Util"

export class Kf1vnQuizSelectItem extends BaseItemRenderer {
	model
	public WIDTH = 265
	public HEIGT = 91

	public constructor(parent?) {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnQuizSelectItem"
		this.model = Kf1vnModel.GetInstance()
		this.load_callback = () => {
			SetHtmlStyle(this.desc, { c: "#0a953e", f: 22, ww: false, w: 265 })
		}
		this.Load()
	}

	public DeleteMe() {
		super.DeleteMe()

	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.desc.innerHTML = this.data.desc
		SetHtmlCenter(this.desc, { x: 0, w: 265 })
		this.select_bg.visible = this.selected
	}




	_Image1: Laya.Image
	desc: Laya.HTMLDivElement
	select_bg: Laya.Image
	_box_click: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this.desc,
			this.select_bg,
			this._box_click,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"desc",
				"select_bg",
				"_box_click",
			])
	}
}
window["Kf1vnQuizSelectItem"] = Kf1vnQuizSelectItem