import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CompositeModel } from "../commonModel/CompositeModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class RingUpCompositeItem extends BaseItemRenderer {
	WIDTH = 234
	HEIGT = 109
	
	item
	model
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "RingCompositeItem"
		this.model = CompositeModel.GetInstance()

		this.load_callback = () => {
			if (this.need_refresh)
			{
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
		}

		super.DeleteMe()
	}

	public dataChanged() {
		if (!this.is_loaded){
			this.need_refresh = true
			return
		}
		if (!this.item) {
			this.item = new EquipmentItem(this._gp)
			this.item.Load()
			this.item.SetItemSize(85, 85)
			this.item.SetShowTips(false)
		}
		let vo = this.data[0]
		this.item.ExcuteCallback(() => {
			let type_id, lock
			[type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(type_id))
			if (goods_vo) {
				this.item.SetData(goods_vo.type_id, vo[2], lock)
				this._lb_name.text = goods_vo.goods_name
			}
		}
		)
		this.selectimg.visible = this.selected
		this._red_dot.visible = this.model.ring_up_one_key_red_list[this.index]
	}

	_Group1: Laya.Box
	_Image1: Laya.Image
	selectimg: Laya.Image
	_lb_name: Laya.Label
	_gp: Laya.Box
	_red_dot: Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.selectimg,
			this._lb_name,
			this._gp,
			this._red_dot,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"_Image1",
				"selectimg",
				"_lb_name",
				"_gp",
				"_red_dot",
			])
	}
}
window["RingUpCompositeItem"] = RingUpCompositeItem