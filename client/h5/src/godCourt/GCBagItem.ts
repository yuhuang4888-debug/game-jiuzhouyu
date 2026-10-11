import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { RoleManager } from "../commonModel/RoleManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { GodCourtTooltip } from "../common/GodCourtTooltip"

export class GCBagItem extends BaseItemRenderer {
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
		this.model = GodCourtModel.GetInstance()

		if (!this.equipItem) {
			this.equipItem = new EquipmentItem(this.itemGp)
			this.equipItem.Load()
			this.equipItem.SetItemSize(90, 90)
			this.equipItem.SetClickCallBack(() => {
				this.ClickFunc()
			})
		}

		this.BindEvent(this.model, GodCourtModel.UPDATE_GODCOURT, () => {
			this.dataChanged()
		})
	}

	public ClickFunc() {
		if (this.data && this.data.type_id) {
			if (this.data.subtype != 17) {
				UIToolTipMgr.GetInstance().AppendGodCourtTips(this.data.type_id, this.data, this.data.bagGodCourtId, [GodCourtTooltip.Btn.inEquip])
			} else {
				UIToolTipMgr.GetInstance().AppendGoodsTips(this.data.type_id, null, null, this.data)
			}
		}
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data) {
			let ban = null
			let up = null
			let color = 0
			//let star = 0
			if (this.data.type_id) {
				if (this.data.lv && this.data.lv > RoleManager.GetInstance().GetMainRoleVo().level) {
					ban = true
				} else if (this.data.type == GodCourtModel.GoodsType) {
					if (this.data.bagGodCourtId && (this.data.subtype < 9 || (this.model.godcourtData[this.data.bagGodCourtId] && this.model.godcourtData[this.data.bagGodCourtId].canEquipCore) && this.data.subtype + 992 == this.data.bagGodCourtId)) {
						let wearEquip = this.model.GetEquipPosGoodsVo(this.data.bagGodCourtId, this.data.subtype)
						if (!wearEquip || wearEquip.rating < this.data.rating) {
							up = true
						}
					}
				}
				color = this.data.color
			}
			let goodsNum = this.data.subtype == 17 && this.data.goods_num
			this.equipItem.SetData(this.data.type_id, goodsNum)
			this.banImg.visible = ban
			this.upImg.visible = up
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
window["GCBagItem"] = GCBagItem