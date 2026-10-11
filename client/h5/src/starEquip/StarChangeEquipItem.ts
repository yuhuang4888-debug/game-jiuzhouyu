import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { EquipModel } from "../commonModel/EquipModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarChangeEquipItem extends BaseItemRenderer {
	_item
	_model

	WIDTH = 379
	HEIGT = 106
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarChangeEquipItem"

		this._model = EquipModel.GetInstance()

		this.load_callback = () => {
			if (!this._item) {
				this._item = new EquipmentItem(this._gp_item)
				this._item.SetUseMask(true)
				this._item.Load()
				this._item.SetItemSize(87, 87)
			}
			Util.AddClickEvent(this._gp_item, () => {
				if (this.data) {
					StarEquipModel.GetInstance().Fire(StarEquipModel.COMPARED_EQUIP, this.data)
					StarEquipModel.GetInstance().Fire(StarEquipModel.CLOSE_VIEW, "StarChangeEquipView")
				}
			}
				, this, true)
			Util.AddClickEvent(this.clickImg, () => {
				if (this.data) {
					let wearEquip = StarEquipModel.GetInstance().GetWearEquip(this.data.page, this.data.subtype)
					if (((wearEquip && wearEquip.addition_attrlist.length >= 2) && this.data.rating > wearEquip.rating) && this.data.addition_attrlist.length == 0) {
						StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipTransform", wearEquip, this.data)
						StarEquipModel.GetInstance().Fire(StarEquipModel.CLOSE_VIEW, "StarChangeEquipView")
						return
					}
					StarEquipModel.GetInstance().Fire(StarEquipModel.SEND_PROTO, 23202, "lic", this.data.goods_id, this.data.page, 0)
					StarEquipModel.GetInstance().Fire(StarEquipModel.CLOSE_VIEW, "StarChangeEquipView")
				}
			}, this, false)

			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		let data = this.data
		this._item.SetData(data.type_id)
		this._item.SetShowTips(false)
		this._item.SetClickCallBack(() => {

		})
		this._item.SetStarEquipStar(data.color, data.star)
		this._lb_name.text = data.goods_name
		this._lb_name.color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorDark(data.color))
	}

	clickImg: Laya.Image
	_gp_item: Laya.Box
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this.clickImg,
			this._gp_item,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"clickImg",
				"_gp_item",
				"_lb_name",
			])
	}
}
window["StarChangeEquipItem"] = StarChangeEquipItem