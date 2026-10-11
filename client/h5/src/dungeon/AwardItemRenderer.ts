import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"

export class AwardItemRenderer extends BaseItemRenderer {

	item
	public static width = 108
	public static height = 108
	WIDTH = 108
	HEIGT = 108
	_gp_award_con: Laya.Box
	_img_other: Laya.Image
	public constructor(parent) {
		super()

		this.base_file = "dungeonCommon"
		this.layout_file = "AwardItemRenderer"
		this.load_callback = () => {

		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				this.item = new EquipmentItem(this._gp_award_con, null, "Activity")
				this.item.SetScale(0.85)
				this.item.SetUseMask(true)
				this.item.Load()
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.style, this.data.typeId)
				let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				let goods_vo = null
				if (this.data.goods_id) {
					goods_vo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(this.data.goods_id)
				}
				if (vo) {
					this.item.SetClickCallBack(() => {
						if (vo.type == 10 && goods_vo) {
							UIToolTipMgr.GetInstance().AppendEquipTips(type_id, null, null, goods_vo, null, [1])
						} else {
							this.item.DefaultCallFun()
						}
					}
					)
					this.item.SetData(vo.type_id, this.data.count, lock)
				}
				this._img_other.visible = this.data.reward_type == 1
			}

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
			this._gp_award_con,
			this._img_other,
		]
			= this.GetChildrenByNames([

				"_gp_award_con",
				"_img_other",
			])
	}
}
window["AwardItemRenderer"] = AwardItemRenderer