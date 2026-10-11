import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class upStarPropItem extends BaseItem1 {
	curLb: Laya.Label
	nextLb: Laya.Label
	arrow: Laya.Image


	public constructor(parent?) {
		super(parent)

		this.base_file = "pet"
		this.layout_file = "upStarPropItem"
	}

	public SetData(curAttr?, nextAttr?) {
		let local_wordMgr = WordManager
		this.curLb.text = local_wordMgr.GetProperties(curAttr[0]) + ":" + local_wordMgr.ConvertToPercentValue(curAttr[0], curAttr[1])
		if (nextAttr) {
			this.arrow.visible = true
			this.nextLb.text = local_wordMgr.ConvertToPercentValue(curAttr[0], nextAttr[1] - curAttr[1])
		} else {
			this.arrow.visible = false
			this.nextLb.text = ""
		}
	}
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
window["upStarPropItem"] = upStarPropItem