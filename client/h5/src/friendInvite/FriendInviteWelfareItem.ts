import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"

export class FriendInviteWelfareItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_lb_goods_name: Laya.HTMLDivElement
	_gp_award: Laya.Box
	award_item
	public static width = 136
	public static height = 134
	WIDTH = 136
	HEIGT = 134
	public constructor(parent) {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteWelfareItem"
		this.load_callback = () => {

			if (!this.award_item) {
				this.award_item = new EquipmentItem(this._gp_award)
				this.award_item.SetItemSize(92, 92)
				this.award_item.Load()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				this.award_item.SetData(type_id, this.data[2], lock)
				this._lb_goods_name.style.fontSize = 18
				this._lb_goods_name.style.color = "#e036f4"
				this._lb_goods_name.style.align = "center"
				this._lb_goods_name.style.stroke = 2
				this._lb_goods_name.style.strokeColor = "#fff7e6"
				this._lb_goods_name.style.wordWrap = false
				this._lb_goods_name.innerHTML = goods_vo.goods_name
			}
			let a = <Laya.HBox>this._lb_goods_name.parent
			if (a)
				a.refresh()
		}
	}

	public DeleteMe() {

		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._lb_goods_name,
			this._gp_award,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_goods_name",
				"_gp_award",
			])
	}
}
window["FriendInviteWelfareItem"] = FriendInviteWelfareItem