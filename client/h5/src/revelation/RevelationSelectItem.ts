import { RevelationBagItem } from "./RevelationBagItem"
import { RevelationEvent } from "../commonModel/RevelationModel"
import { ResManager } from "../common/ResManager"
import { SetAnchoredPosition, SetSizeDelta} from "../util/Util"

export class RevelationSelectItem extends RevelationBagItem {
	selectImg

	public constructor() {
		super()
	}

	public ClickFunc() {
		if (this.data) {
			let goods_id = this.data.goods_id
			if (this.model.SelectList[goods_id]) {
				this.model.SelectList[goods_id] = null
			} else {
				this.model.SelectList[goods_id] = true
			}
			this.model.Fire(RevelationEvent.SELECT_DEVOUR_MAT, goods_id, this.model.SelectList[goods_id])
			this.dataChanged()
		}
	}

	public dataChanged() {
		super.dataChanged()
		if (this.model.SelectList[this.data.goods_id]) {
			if (!this.selectImg) {
				this.selectImg = new Laya.Image()
				this._gp_con.addChild(this.selectImg)
				this.selectImg.x = -5
				this.selectImg.y = -5
				this.selectImg.width = 95
				this.selectImg.height = 95
				ResManager.GetInstance().SetImageSprite(this, this.selectImg, "revelation", "select")
			} else {
				this.selectImg.visible = true
			}
		} else if (this.selectImg) {
			this.selectImg.visible = false
		}
	}
}

window["RevelationSelectItem"] = RevelationSelectItem