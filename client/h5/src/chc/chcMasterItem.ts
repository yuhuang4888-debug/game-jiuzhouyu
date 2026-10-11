import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ColorUtil } from "../util/ColorUtil"
import { chcModel } from "../commonModel/chcModel"

export class chcMasterItem extends BaseItemRenderer {
	_model
	is_delay_callback
	WIDTH = 538
	HEIGT = 100
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcMasterItem"
		this._model = chcModel.GetInstance()
		this.is_delay_callback = false

		this.load_callback = () => {
			this._lb_attr.width = 300
			this._lb_attr.style.fontSize = 20
			this._lb_attr.style.color = "#663915"
			this._lb_attr.style.leading = 8
			
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
		let color = ColorUtil.TryParseHtmlString(data.vo && data.vo.status == 2 && "#179846" || "#9c9c9c")
		let str = this._model.GetTypeStr(data._type)
		this._lb_lv.text = "全身" + str + (" + ") + data.lv
		this._lb_lv.color = color
		this._lb_attr.style.color = color
		let attr_list = JSON.parse(data.attr)
		this._lb_attr.innerHTML = this._model.GetAttrStr(attr_list, null, " +")
		this._lb_attr.width = 300
		this._lb_attr["_refresh"]()
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_lv: Laya.Label
	_lb_attr: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_lv,
			this._lb_attr,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_lv",
				"_lb_attr",
			])
	}
}
window["chcMasterItem"] = chcMasterItem