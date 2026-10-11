import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { EquipModel } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BagItemRenderer } from "./BagItemRenderer"
export class GoodsBagItemRenderer extends BagItemRenderer {
	is_batch

	public constructor() {
		super()
		this.is_batch = true

		this.ClickCallBack = () => {
			let bagModel = BagModel.GetInstance()
			if (this.data) {
				if (this.data.color == -1) {
					bagModel.Fire(BagModel.OPEN_VIEW, "ExpandBagView", GoodsModel.GOODS_POS_TYPE.bag, this.data.index)
				} else if (this.data.color) {
					if (this.data.type == 10) {
						let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(this.data.equip_type)
						if (wear_equip_info) {
							BagModel.GetInstance().Fire(BagModel.CONTRAST_EQUIP, this.data)
						} else {
							UIToolTipMgr.GetInstance().AppendEquipTips(this.data.type_id, null, null, this.data, null, [0])
						}
					} else {
						if (this.data.deposite) {
							this.data.deposite = false
						}
						super.ClickFunc()
					}
				}
			}
		}
	}

	public load_callback() {
		this.BindEvent(GlobalEventSystem, EventName.CHANGE_MAINROLE_CAREER, () => {
			this.changeCareerEff()
		}
		)
		super.load_callback()
	}



	public changeCareerEff() {

		let need_sub_list = [1, 2, 4, 6, 8, 10]

		if (this.data.type == 10 && table.find(need_sub_list, this.data.subtype) != -1) {
			super.UpdateEffect()
		}
	}

}
window["GoodsBagItemRenderer"] = GoodsBagItemRenderer