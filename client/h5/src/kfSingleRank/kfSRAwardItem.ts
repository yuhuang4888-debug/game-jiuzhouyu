import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"

export class kfSRAwardItem extends BaseItemRenderer {
	_item
	_model

	public static width = 92
	public static height = 92
	public WIDTH = 92
	public HEIGT = 92

	protected scaleValue = 92

	public constructor(parent) {
		super()

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRAwardItem"
		this._model = kfSingleRankModel.GetInstance()
		this.load_callback = () => {
			this.load_callback1()
		}
		this.Load()
	}

	public load_callback1() {



	}



	public DeleteMe() {

		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		this._Image1.visible = data.rw_state == 1
		if (data.rw_state == 1) {
			this._Image1.scale(this.scaleValue / 92, this.scaleValue / 92)
		}

		this._item = new EquipmentItem(this._gp_item)
		this._item.Load()
		this._item.SetItemSize(this.scaleValue, this.scaleValue)


		let type_id, lock
		[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
		this._item.SetData(type_id, data[2], lock)
	}



	_gp_item: Laya.Box
	_Image1: Laya.Image
	public GetComponents() {
		[
			this._gp_item,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_Image1",
			])
	}
}
window["kfSRAwardItem"] = kfSRAwardItem