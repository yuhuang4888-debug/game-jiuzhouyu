import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { ColorUtil } from "../util/ColorUtil"
import { HtmlColorTxt } from "../util/Util"
import { chcModel } from "../commonModel/chcModel"

export class chcMagicAddItem extends BaseItemRenderer {
	_model
	need_refresh = false
	WIDTH = 458
	HEIGT = 32

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcMagicAddItem"
		this._model = chcModel.GetInstance()

		this.load_callback = () => {
			this._lb_con.style.fontSize = 20
			this._lb_con.style.color = "#4a3a32"
			this._lb_con.style.wordWrap = false

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
		let attr = data.vo
		let name = WordManager.GetProperties(attr[0])
		let valc = WordManager.ConvertToPercentValue(attr[0], attr[1])
		let vo = this._model.GetMasterByLv(chcModel.CHCTYPE.MAGIC, data.stype, data.lv)
		let unlock = vo && vo.status == 2
		let color = unlock ? ("#663915") : ("#9b9a9a")
		this._lb_con.style.color = color
		let color1 = unlock ? ("'#b94a00'") : ("'#9b9a9a'")
		let color2 = unlock ? ("'#009916'") : ("'#9b9a9a'")
		let lv_str = HtmlColorTxt("全身觉醒" + data.lv + "级：", color1)
		let val_str = HtmlColorTxt(valc, color2)
		this._lb_con.innerHTML = lv_str  + name + (" + ") + val_str
		this.gp_lb.width = this._lb_con.contextWidth
		//179846
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	gp_lb: Laya.HBox
	_lb_con: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this.gp_lb,
			this._lb_con,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_Image3",
				"gp_lb",
				"_lb_con",
			])
	}
}
window["chcMagicAddItem"] = chcMagicAddItem