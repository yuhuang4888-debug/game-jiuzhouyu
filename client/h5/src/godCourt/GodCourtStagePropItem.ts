import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"

export class GodCourtStagePropItem extends BaseItem1 {
	curData
	needRefresh
	nextData

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GodCourtStagePropItem"

		this.load_callback = () => {
			this.curLb.style.fontSize = 20
			this.curLb.style.color = "#663915"
			this.curLb.style.wordWrap = false

			if (this.needRefresh) {
				this.SetData(this.curData, this.nextData)
				this.needRefresh = null
			}
		}
	}

	public SetData(curData?, nextData?) {
		if (this.is_loaded) {
			if (curData) {
				this.curLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(curData[0]) + ("<font color='#d15e00'> + ") + WordManager.ConvertToPercentValue(curData[0], curData[1]) + "</font>"
				)
			} else if (nextData) {
				this.curLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(nextData[0]) + ("<font color='#d15e00'> + ") + WordManager.ConvertToPercentValue(nextData[0], 0) + "</font>"
				)
			}
			if (nextData) {
				this.nextLb.text = WordManager.ConvertToPercentValue(nextData[0], nextData[1])
				this.arrow.visible = true
			} else {
				this.nextLb.text = ""
				this.arrow.visible = false
			}
		} else {
			this.needRefresh = true
			this.curData = curData
			this.nextData = nextData
		}
	}

	curLb: Laya.HTMLDivElement
	arrow: Laya.Image
	nextLb: Laya.Label
	public GetComponents() {
		[
			this.curLb,
			this.arrow,
			this.nextLb,
		]
			= this.GetChildrenByNames([
				"curLb",
				"arrow",
				"nextLb",
			])
	}
}
window["GodCourtStagePropItem"] = GodCourtStagePropItem