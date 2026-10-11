import { GoodsModel } from "../commonModel/GoodsModel";
import { BaseItemRenderer } from "./BaseItemRenderer";
import { EquipmentItem } from "./EquipmentItem";
import { ResManager } from "./ResManager";

export class CommonRewardItem extends BaseItemRenderer {
	private equip_item: EquipmentItem
	WIDTH = 85
	HEIGT = 85

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "CommonRewardItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {
		this.InitEvent()
		this.equip_item = new EquipmentItem(this._gp_con)
		this.equip_item.Load()
	}

	InitEvent() {

	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (this.data) {
			let size = this.data.size
			this._img_other.visible = (this.data.reward_type != undefined) && (this.data.reward_type != 0)
			if (this.data.reward_type != undefined) {
				switch (this.data.reward_type) {
					case 9: //周卡
						ResManager.GetInstance().SetImageSprite(this.base_item, this._img_other, "common2", "zhouka", true)
						break;
					case 1: //额外
						ResManager.GetInstance().SetImageSprite(this, this._img_other, "common", "common_4", true)
						break;
				}
			}

			if (size) {
				this.equip_item.SetItemSize(size, size)
			}
			let vo = this.data.vo
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this.equip_item.SetData(goods_vo.type_id, vo.count, lock)
			if(this.data.show_name){
				this.equip_item.ShowName(true)
			}
		}
	}

	public DeleteMe() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
			this.equip_item = null
		}
		super.DeleteMe()
	}


	_gp_con: Laya.Box
	_img_other: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_other,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_img_other",
			])
	}
}
window["CommonRewardItem"] = CommonRewardItem