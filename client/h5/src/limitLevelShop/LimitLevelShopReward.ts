import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"

export class LimitLevelShopReward extends BaseItemRenderer {
	_gp_con: Laya.Box
	cache_sorting_order
	form
	item


	public static width = 91
	public static height = 88

	public constructor(parent) {
		super()
		this.WIDTH=91
		this.HEIGT=88
		this.base_file = "limitLevelShop"
		this.layout_file = "LimitLevelShopReward"
		// this.layer_value = Enum_UILayer.Activity
		// this.load_callback = () => {

		// this.cache_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		// }
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		let size = data.size
		let vo = this.data.vo
		if (!this.item) {
			this.item = new BaseAwardItem(this._gp_con)
			// this.item.SetCacheSortOrder(this.cache_sorting_order)
			this.item.SetItemSize(size, size)
			// this.item.SetUseMask(true)
			this.item.Load()
		}
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		this.item.SetData(goods_vo.type_id, vo.count, lock)
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
			this._gp_con,
		]
			= this.GetChildrenByNames([

				"_gp_con",
			])
	}
}
window["LimitLevelShopReward"] = LimitLevelShopReward