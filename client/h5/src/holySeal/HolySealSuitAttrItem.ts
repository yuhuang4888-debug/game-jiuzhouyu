import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { HolySealModel } from "../commonModel/HolySealModel"
import { Util } from "../util/Util"

export class HolySealSuitAttrItem extends BaseItem1 {

	model: HolySealModel

	data
	is_activating
	need_refresh_data

	public constructor(parent) {
		super(parent)
		this.base_file = "holySeal"
		this.layout_file = "HolySealSuitAttrItem"
		this.model = HolySealModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	LoadSuccess() {


		this._lb_attr.style.fontSize = 20
		this._lb_attr.style.color = "#7B4E35"
		this._lb_attr.style.leading = 5
		this._lb_attr.style.width = 300
		this._lb_attr.style.height = 300

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	InitEvent() {

	}

	SetData(data, is_activating) {
		this.data = data
		this.is_activating = is_activating
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	UpdateView() {
		let data = this.data
		this._img_bg.gray = this._img_bg2.gray = this._img_bg3.gray = this._lb_title.gray = !this.is_activating
		// Util.SetImageGray(this._img_bg, !this.is_activating)


		this._lb_title.text = `【${data[0]}件加成】`
		let attr_list = data[1]
		let str = ""


		let text_color

		if(this.is_activating){
			this._lb_attr.style.color = "#7B4E35"
			text_color = "'#0a953e'"
		}
		else{
			this._lb_attr.style.color = "#888888"
			text_color = "'#888888'"
		}

		for (let val of attr_list) {
			str += `${WordManager.GetProperties(val[0])}:${Util.HtmlColorTxt(WordManager.ConvertToPercentValue(val[0], val[1]), text_color)}<br/>`;
		}
		this._lb_attr.innerHTML = str
		this._lb_attr.width = 200
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_lb_attr: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._lb_title,
			this._lb_attr,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_lb_title",
				"_lb_attr",
			])
	}
}
window["HolySealSuitAttrItem"] = HolySealSuitAttrItem