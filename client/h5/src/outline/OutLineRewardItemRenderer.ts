import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class OutLineRewardItemRenderer extends BaseItemRenderer {
	WIDTH = 80
	HEIGT = 80

	reward

	public constructor() {
		super()
		this.base_file = "outline"
		this.layout_file = "OutLineRewardItemRenderer"

		this.load_callback = () => {
			if (!this.reward) {
				this.reward = new EquipmentItem(this._gp_con)
				this.reward.SetUseMask(true)
				this.reward.Load()
				this.reward.SetItemSize(80, 80)
			}
			this.reward.ExcuteCallback(() => {
				this.dataChanged()
			})
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data) {
			let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.type, this.data.goods_id)
			this.reward.SetData(type, this.data.num)
		}
	}

	public DeleteMe() {
		if (this.reward) {
			this.reward.DeleteMe()
			this.reward = null
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
window["OutLineRewardItemRenderer"] = OutLineRewardItemRenderer