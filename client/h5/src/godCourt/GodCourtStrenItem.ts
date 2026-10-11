import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"

export class GodCourtStrenItem extends BaseItemRenderer {
	WIDTH = 325
    HEIGT = 32
	
	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtStrenItem"

		this.load_callback = () => {
			this.curLb.style.fontSize = 20
			this.curLb.style.color = "#663915"
			this.curLb.style.wordWrap = false
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		let curData = this.data[0]
		let nextData = this.data[1]
		if (curData) {
			this.curLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(curData[0]) + "：<font color='#d15e00'>" + WordManager.ConvertToPercentValue(curData[0], curData[1]) + "</font>")
		} else if (nextData) {
			this.curLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(nextData[0]) + "：<font color='#d15e00'>" + WordManager.ConvertToPercentValue(nextData[0], 0) + "</font>")
		}
		if (nextData) {
			this.nextLb.text = "+" + WordManager.ConvertToPercentValue(nextData[0], nextData[1] - curData[1])
			this.arrow.visible = true
		} else {
			this.nextLb.text = ""
			this.arrow.visible = false
		}
	}

	curLb: Laya.HTMLDivElement
	nextLb: Laya.Label
	arrow: Laya.Image
	public GetComponents() {
		[
			this.curLb,
			this.nextLb,
			this.arrow,
		]
			= this.GetChildrenByNames([
				"curLb",
				"nextLb",
				"arrow",
			])
	}
}
window["GodCourtStrenItem"] = GodCourtStrenItem