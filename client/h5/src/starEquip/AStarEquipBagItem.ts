import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class AStarEquipBagItem extends BaseItemRenderer {
	equipItem
	model

	WIDTH = 102
	HEIGT = 100
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipBagItem"
		this.model = StarEquipModel.GetInstance()

		this.load_callback = () => {
			if (!this.equipItem) {
				this.equipItem = new EquipmentItem(this.itemGp)
				this.equipItem.Load()
				this.equipItem.SetUseMask(true)
				this.equipItem.SetItemSize(96, 96)
				this.equipItem.SetClickCallBack(() => {
					this.ClickFunc()
				})
			}
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public ClickFunc() {
		if (this.data && this.data.type_id) {
			//UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.data.type_id, this.data, null, { StarEquipToolTip.Btn.inEquip })
			UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.data.type_id, this.data, null, [1])
		}
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		let ban = null
		let up = null
		let color = 0
		let star = 0
		if (this.data.type_id) {
			if (this.data.lv && this.data.lv > RoleManager.GetInstance().GetMainRoleVo().level) {
				ban = true
			} else if (this.data.type == StarEquipModel.GOODS_TYPE) {
				let wearEquip = GoodsModel.GetInstance().GetStarEquipBuyPagePos(this.data.page, this.data.subtype)
				if (!wearEquip || wearEquip.rating < this.data.rating) {
					up = true
				}
			}
			color = this.data.color
			star = this.data.star
		}
		this.equipItem.ExcuteCallback(() => {
			this.equipItem.SetStarEquipStar(color, star)
		}
		)
		this.equipItem.SetData(this.data.type_id)
		this.banImg.visible = ban
		this.upImg.visible = up
	}

	public DeleteMe() {
		if (this.equipItem) {
			this.equipItem.DeleteMe()
			this.equipItem = null
		}
		super.DeleteMe()
	}

	itemGp: Laya.Box
	banImg: Laya.Image
	upImg: Laya.Image
	effectGp: Laya.Box
	public GetComponents() {
		[
			this.itemGp,
			this.banImg,
			this.upImg,
			this.effectGp,
		]
			= this.GetChildrenByNames([
				"itemGp",
				"banImg",
				"upImg",
				"effectGp",
			])
	}
}
window["AStarEquipBagItem"] = AStarEquipBagItem