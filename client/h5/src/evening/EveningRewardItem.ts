import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"

export class EveningRewardItem extends BaseItemRenderer {
	_award_item
	model

	public WIDTH = 119
	public HEIGT = 143
	is_set = false
	public constructor(parent) {
		super()

		this.base_file = "evening"
		this.layout_file = "EveningRewardItem"
		this.model = GuildActivityModel.GetInstance()
		// this.once(Laya.UIEvent.REMOVED_FROM_STAGE, this.Clear, this)
		this.load_callback = () => {
			this._award_item = new BaseAwardItem(this._group_item)
			this._award_item.SetItemSize(119, 119)
			this._award_item.Load()

			if (!this.is_set) {
				this.SetData()
				this.is_set = true
			}
		}

		this.Load()
	}


	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}
		if (this.is_loaded) {
			this.SetData()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}

	SetData() {
		if (!this.data) return
		let type_id, lock = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		this._award_item.SetData(type_id)
		this._lb_name.text = basic.goods_name
	}

	public Clear() {

		if (this._award_item) {
			this._award_item.DeleteMe()
			this._award_item = null
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_group_item: Laya.Box
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._group_item,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_group_item",
				"_lb_name",
			])
	}
}

window["EveningRewardItem"] = EveningRewardItem