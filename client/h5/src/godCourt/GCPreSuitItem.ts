import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"

export class GCPreSuitItem extends BaseItemRenderer {
	WIDTH = 490
	HEIGT = 150

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCPreSuitItem"

		this.load_callback = () => {
			this.attrLb.style.fontSize = 20
			this.attrLb.style.color = "#663915"
			this.attrLb.style.leading = 8
			this.attrLb.width = 450
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data) {
			let CfgData = this.data[0]
			let suitCfgList = JSON.parse(CfgData.suit_attr)
			let num = WordManager.NumConvertStage(CfgData.stage)
			this._lb_suit.text = num + "阶套装"
			//ResManager.GetInstance().SetImageSprite(this, this.suitLb, "godCourt_asset", "uitzyl_sp" + CfgData.stage, true)
			let attrStr = ""
			for (let _tmpi in suitCfgList) {
				let vo = suitCfgList[_tmpi]
				let color1s = this.data[1][vo[0]]&&this.data[1][vo[0]] ==CfgData.stage  ? ["#a376ff", "#ff4f50"] : ["#4a3a32", "#4a3a32"]
				attrStr = attrStr + "<font color='" + color1s[0] + "'>【" + vo[0] + "件套】</font> <font color='" + color1s[1] + "'>"
				for (let _tmpi in vo[1]) {
					let attrVo = vo[1][_tmpi]
					attrStr = attrStr + WordManager.GetProperties(attrVo[0]) + (" + ") + WordManager.ConvertToPercentValue(attrVo[0], attrVo[1]) + "&nbsp;&nbsp;"
				}
				attrStr = attrStr + "</font><br>"
			}
			this.attrLb.innerHTML = attrStr
			this.attrLb.width = 450
		}
	}

	_img_bg: Laya.Image
	_lb_suit: Laya.Label
	attrLb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._lb_suit,
			this.attrLb,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_lb_suit",
				"attrLb",
			])
	}
}
window["GCPreSuitItem"] = GCPreSuitItem