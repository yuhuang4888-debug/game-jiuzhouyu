import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"

export class ListGoodsItem extends BaseItemRenderer {
	WIDTH = 70
	HEIGT = 70
	item

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListGoodsItem"

		this.load_callback = () => {

		}
		this.Load()
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		let type_id = this.data[0]
		let num = this.data[1]
		if (!this.item) {
			this.item = new BaseAwardItem(this._gp_item)
			this.item.Load()
			this.item.SetItemSize(70, 70)
		}
		this.item.ExcuteCallback(() => {
			this.item.SetData(type_id, num)
		})
	}

	_gp_item: Laya.Box
	public GetComponents() {
		[
			this._gp_item,
		]
			= this.GetChildrenByNames([
				"_gp_item",
			])
	}
}
window["ListGoodsItem"] = ListGoodsItem