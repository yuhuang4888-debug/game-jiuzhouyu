import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"

export class EmailPopViewItem extends BaseItemRenderer {
	_gp
	item
	public WIDTH = 127 * 0.75
	public HEIGT = 127 * 0.75
	public constructor(parent) {
		super()


		this.base_file = "friend"
		this.layout_file = "EmailPopViewItem"
		this.Load()
		// this.skinName="resource/game/friend/exml/EmailPopViewItemExml.exml"
		// this.load_callback = () => {
		// 	this.gp = this.GetChild("_gp")
		// }
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let vo = this.data
			if (vo == null) { return }
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.object_type, vo.type_id)
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			// [ts2lua]lua中0和空字符串也是true，此处(goods_vo && goods_vo.max_overlap == 0) && goods_vo.type == 10需要确认
			let num = (goods_vo && goods_vo.max_overlap == 0) && goods_vo.type == 10 && 1 || vo.num
			if (!this.item) {
				this.item = new EquipmentItem(this._gp)
				// this.item.SetMaskId(this.mask_id || 1)
				this.item.Load()
			}
			this.item.SetScale(0.75)
			if (goods_vo) {
				this.item.SetData(goods_vo.type_id, num, lock, null, vo.is_receive == 1)
				//this.item.SetStrengthen(goods_vo.stren)
			}
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._gp,
		]
			= this.GetChildrenByNames([

				"_gp",
			])
	}
}

window["EmailPopViewItem"] = EmailPopViewItem