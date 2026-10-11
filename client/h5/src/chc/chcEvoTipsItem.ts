import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { HtmlColorTxt } from "../util/Util"

export class chcEvoTipsItem extends BaseItemRenderer {
	WIDTH = 450
	HEIGT = 25
	need_refresh = false
	
	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEvoTipsItem"

		this.load_callback = () => {
			this._lb_attr_cur.style.fontSize = 22
			this._lb_attr_cur.style.color = "#663915"
			this._lb_attr_cur.style.wordWrap = false
			this._lb_attr_next.style.fontSize = 22
			this._lb_attr_next.style.color = "#663915"
			this._lb_attr_next.style.wordWrap = false
			
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
		let vo = this.data
		let name = WordManager.GetProperties(vo[0])
		let val = WordManager.ConvertToPercentValue(vo[0], vo[2])
		let vstr = HtmlColorTxt(val, "'#d15e00'")
		this._lb_attr_cur.innerHTML = name + "：" + vstr
		val = WordManager.ConvertToPercentValue(vo[0], vo[1])
		vstr = HtmlColorTxt(val, "'#179846'")
		this._lb_attr_next.innerHTML = name + "：" + vstr
	}

	_lb_attr_cur: Laya.HTMLDivElement
	_lb_attr_next: Laya.HTMLDivElement
	_Image1: Laya.Image
	public GetComponents() {
		[
			this._lb_attr_cur,
			this._lb_attr_next,
			this._Image1,
		]
			= this.GetChildrenByNames([
				"_lb_attr_cur",
				"_lb_attr_next",
				"_Image1",
			])
	}
}
window["chcEvoTipsItem"] = chcEvoTipsItem