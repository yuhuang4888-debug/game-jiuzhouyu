import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GodCourtSuitSingle } from "./GodCourtSuitSingle"

export class GodCourtSuitItem extends BaseItemRenderer {
	WIDTH = 500
	HEIGT = 160
	itemList

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtSuitItem"
		this.load_callback = () => {
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (!this.itemList) {
			this.itemList = []
			let i = 0
			do {
				let item = new GodCourtSuitSingle(this.itemGp)
				item.Load()
				this.itemList[i] = item
				i = i + 1
			} while ((i < 3))
		}
		let i = 0
		do {
			this.itemList[i].SetData([this.data.cfg[i], this.data.data,this.data.stage])
			i = i + 1
		} while ((i < 3))
	}

	public DeleteMe() {
		if (this.itemList) {
			for (let _tmpi in this.itemList) {
				let vo = this.itemList[_tmpi]
				vo.DeleteMe()
			}
			this.itemList = null
		}
		super.DeleteMe()
	}

	itemGp: Laya.HBox
	public GetComponents() {
		[
			this.itemGp,
		]
			= this.GetChildrenByNames([
				"itemGp",
			])
	}
}
window["GodCourtSuitItem"] = GodCourtSuitItem