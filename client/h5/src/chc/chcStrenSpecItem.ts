import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { ColorUtil } from "../util/ColorUtil"
import { chcModel } from "../commonModel/chcModel"

export class chcStrenSpecItem extends BaseItemRenderer {
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
		let attr_list = JSON.parse(data.vo.special_attr)
		let attr = attr_list[0]
		let name = WordManager.GetProperties(attr[0])
		let valc = WordManager.ConvertToPercentValue(attr[0], attr[1])
		let edata = this._model.GetDataByPos(chcModel.CHCTYPE.STREN, data.stype, data.vo.pos)
		let lv = (edata && (edata.lv) || (0))
		let unlock = lv >= data.vo.lv
		let color = unlock && "'#639c12'" || "'#4A3A32'"
		let str = unlock && (name + "：" + valc) || (name + "：" + valc + ("(强化 + ") + data.vo.lv + "解锁)")
		this._lb_con.innerHTML = "<font color = " + color +">" + str + "</font>"
		this.gp_lb.callLater(() => {
			if(this.use_delete_method) return
			this._lb_con.event("resize")
		})
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
window["chcStrenSpecItem"] = chcStrenSpecItem