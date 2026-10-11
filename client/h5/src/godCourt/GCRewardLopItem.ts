import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"

export class GCRewardLopItem extends BaseItemRenderer {
	WIDTH = 90
    HEIGT = 90
	model
	equipItem

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCBagItem"
		this.Load()
	}

	public load_callback() {
		if (!this.equipItem) {
			this.equipItem = new EquipmentItem(this.itemGp)
			this.equipItem.Load()
			this.equipItem.SetItemSize(90, 90)
		}
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data) {
			this.equipItem.SetData(this.data[1], this.data[2])
		}
	}

	public DeleteMe() {
		if (this.equipItem) {
			this.equipItem.DeleteMe()
			this.equipItem = null
		}
		super.DeleteMe()
	}

	itemGp: Laya.Box
	upImg: Laya.Image
	banImg: Laya.Image
	effectGp: Laya.Box
	public GetComponents() {
		[
			this.itemGp,
			this.upImg,
			this.banImg,
			this.effectGp,
		]
			= this.GetChildrenByNames([
				"itemGp",
				"upImg",
				"banImg",
				"effectGp",
			])
	}
}
window["GCRewardLopItem"] = GCRewardLopItem