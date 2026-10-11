import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"

export class DrawItem extends BaseItemRenderer {

	WIDTH = 126
    HEIGT = 121

	_gp_item: Laya.Box
	_img_status: Laya.Image
	cfg
	is_drawed
	item

	public constructor(parent?) {
		super()


		this.base_file = "surpriseGift"
		this.layout_file = "DrawItem"
		this.load_callback = () => {

		}
		this.Load()
	}

	public InitView() {


		if (!this.cfg) {
			return
		}
		let reward = this.cfg.reward_list
		if (reward) {
			if (typeof (reward) == "string") {
				reward = JSON.parse(reward)[0]
			}
			if (!this.item) {
				this.item = new EquipmentItem(this._gp_item)
				this.item.Load()
				this.item.SetItemSize(85, 85)
			}
			this.item.ExcuteCallback(() => {
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
				this.item.SetData(type_id, reward[2], lock)
			}
			)
		}
		this._img_status.visible = this.is_drawed
	}

	
	public dataChanged() {
		if (super.dataChanged()) {
			this.cfg = this.data
			this.is_drawed = this.data.is_draw
			this.InitView()
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
			this._gp_item,
			this._img_status,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_img_status",
			])
	}
}
window["DrawItem"] = DrawItem