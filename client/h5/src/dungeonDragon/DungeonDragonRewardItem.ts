import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SetSizeDelta } from "../util/Util"

export class DungeonDragonRewardItem extends BaseItemRenderer {
	equip_item

	public WIDTH = 78
	public HEIGT = 78

	public constructor(parent) {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonRewardItem"
		this.load_callback = () => {
			this.init()
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.data) {
			let size = this.data.size
			this.equip_item.SetItemSize(size,size)
			//SetSizeDelta(this.display_obj, size, size)
			let vo1 = this.data.vo
			let type_id, lock 
			[type_id, lock]= GoodsModel.GetInstance().GetMappingTypeId(vo1.style, vo1.typeId)
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			
			this.equip_item.SetData(goods_vo.type_id, vo1.count, lock)
		}
	}

	public init() {


		// super.load_callback()
		// this.equip_item =  new EquipmentItem(this._gp_con)
		this.equip_item = new EquipmentItem(this._gp_con)
		// this.equip_item.SetMaskId(this.mask_id)
		// this.equip_item.SetMaskRect(this.mask_corners)
		this.equip_item.Load()
	}

	public DeleteMe() {

		if (this.equip_item) {
			this.equip_item.DeleteMe()
			this.equip_item = null
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
window["DungeonDragonRewardItem"] = DungeonDragonRewardItem