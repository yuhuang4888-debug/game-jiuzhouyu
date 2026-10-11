import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"

export class DungeonMarriageFightSceneRewardItem extends BaseItemRenderer {
	public WIDTH = 70
	public HEIGT = 70

	item:EquipmentItem
	public constructor() {
		super()
		this.base_file = "dungeonMarriage"
		this.layout_file = "DungeonMarriageFightSceneRewardItem"
		this.Load()
	}

	public load_callback() {
		this.item = new EquipmentItem(this._gp_con)
		// this.item.SetScale(0.6)
		this.item.SetItemSize(70, 70)
		this.item.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this.item.SetData(goods_vo.type_id, this.data[2], lock)
		}
	}



	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	_gp_con: Laya.Box
	public GetComponents() {
		[
			this._gp_con,
		]
			= this.GetChildrenByNames([

				"_gp_con",
			])
	}
}
window["DungeonMarriageFightSceneRewardItem"] = DungeonMarriageFightSceneRewardItem