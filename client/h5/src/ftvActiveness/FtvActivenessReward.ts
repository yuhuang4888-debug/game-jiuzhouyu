import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { GoodsModel } from "../commonModel/GoodsModel"

export class FtvActivenessReward extends BaseItem1 {
	_bg: Laya.Image
	_item: Laya.Box
	data
	item
	needRefreshData

	public constructor(parent?) {
		super(parent)

		this.base_file = "ftvActiveness"
		this.layout_file = "FtvActivenessReward"

		this.data = null
		this.item = null

		this.load_callback = () => {

			this.InitView()
		}

	}

	public InitView() {
		if (!this.data) {
			return
		}
		if (this.needRefreshData) {
			this.UpdateItem()
			this.needRefreshData = null
		}
	}

	public UpdateItem() {
		if (!this.item) {
			this.item = new BaseAwardItem(this._item, null, "UI")
			// this.item.SetMaskId(3)
			this.item.Load()
			this.item.SetItemSize(80, 80)
		}
		this.item.ExcuteCallback(() => {
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0][0], this.data[0][1])
			this.item.SetData(type_id, this.data[0][2])
		}
		)
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.needRefreshData = true
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._bg,
			this._item,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_item",
			])
	}
}
window["FtvActivenessReward"]=FtvActivenessReward