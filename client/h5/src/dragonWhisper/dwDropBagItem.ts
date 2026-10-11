import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseAwardItem } from "../common/BaseAwardItem"

export class dwDropBagItem extends BaseItemRenderer {
	WIDTH = 85
	HEIGT = 85
	_item

	public constructor() {
		super()

		this.base_file = "dragonWhisper"
		this.layout_file = "dwDropBagItem"
		this.load_callback = () => {
		}
		this.Load()
	}

	public dataChanged() {
		let data = this.data
		if (!this._item) {
			this._item = new BaseAwardItem(this._conta)
			this._item.Load()
			this._item.SetItemSize(85, 85)
		}

		this._item.ExcuteCallback(() => {
			if (data && data != null && data.type_id) {
				this._item.SetData(data.type_id)
				this._item.ForceSetNumber(data.goods_num)
			} else {
				this._item.SetData(null)
			}
		})
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}
	
	_conta: Laya.Box
	public GetComponents() {
		[
			this._conta,
		]
			= this.GetChildrenByNames([
				"_conta",
			])
	}
}
window["dwDropBagItem"] = dwDropBagItem