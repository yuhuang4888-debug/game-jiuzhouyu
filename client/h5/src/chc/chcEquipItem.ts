import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ColorUtil } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { chcModel } from "../commonModel/chcModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"

export class chcEquipItem extends BaseItemRenderer {
	_model
	_show_item
	WIDTH = 150
	HEIGT = 196
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEquipItem"

		this._model = chcModel.GetInstance()
		this.load_callback = () => {
			this.BindEvent(this._model, chcModel.UPDATE_RESULT, (type?, bool?) => {
				if (!bool || (this.data && this.data.type != type)) {
					return
				}
				this.UpdateData()
			})

			this.BindEvent(chcModel.GetInstance(), chcModel.UPDATE_RED, () => {
				this.UpdateRed()
			})
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (this.data) {
			if (!this.is_loaded) {
				this.need_refresh = true
				return
			}
			if (!this._show_item) {
				this._show_item = new EquipmentItem(this._gp_item)
				this._show_item.SetItemSize(87, 87)
				this._show_item.SetShowTips(false)
				this._show_item.Load()
				this._show_item.SetUseMask(true)
			}
			let data = this.data
			let type_id = data.vo.type_id
			this._show_item.ExcuteCallback(() => {
				this._show_item.SetData(type_id)
				this._show_item.SetStarEquipStar(data.vo.color, data.vo.star)
			}
			)
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)
			this._lb_name.text = basic.goods_name
			this._Image2.visible = this.selected
			let icon = this.selected ? "uisydz_004" : "uisydz_005"
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "chc", icon)
			this.UpdateData()
		}
	}

	public UpdateData() {
		let data = this.data
		if (this.data) {
			let sdata = this._model.GetDataByPos(data.type, data.stype, data.vo.cell)
			let str = this._model.GetTypeStr(data.type)
			if (data.type == chcModel.CHCTYPE.SOUL) {
				let is_spirit = (sdata && (sdata.is_spirit == 1) || (false))
				this._lb_tips.text = (is_spirit && ("已" + str) || ("未" + str))
			} else {
				let lv = (sdata && (sdata.lv) || (0))
				this._lb_tips.text = str + (" + ") + lv
			}
			this.UpdateRed()
		}
	}

	public UpdateRed() {
		let data = this.data
		if (data) {
			let bool = this._model.GetReddotOne(data.type, data.stype, data.vo.cell)
			this._reddot.visible = bool
		}
	}

	_Image1: Laya.Image
	_Image2: Laya.Image
	_reddot: Laya.Image
	_gp_item: Laya.Box
	_lb_name: Laya.Label
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._reddot,
			this._gp_item,
			this._lb_name,
			this._lb_tips,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_reddot",
				"_gp_item",
				"_lb_name",
				"_lb_tips",
			])
	}
}
window["chcEquipItem"] = chcEquipItem