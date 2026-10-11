import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipBasicTab extends BaseItemRenderer {
	WIDTH = 150
	HEIGT = 60
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipBasicTab"

		this.load_callback = () => {
			this.BindEvent(StarEquipModel.GetInstance(), StarEquipModel.REFRESH_RED, (type?) => {
				if (this.index == 2 && type == 2) {
					this._red_dot.visible = StarEquipModel.GetInstance().devourRed
				}
			})

			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (!this.data) {
			return
		}
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		this._lb.text = this.data
		if (this.index == 2) {
			this._red_dot.visible = StarEquipModel.GetInstance().devourRed
		}
		if (this.selected) {
			//ResManager.GetInstance().SetImageSprite(this, this._Image1, "starEquip_asset", "uilwmb_041")
			//this._lb.strokeColor = ColorUtil.TryParseHtmlString("#d26b40")
			this._lb.color = "#000000"
		} else {
			//ResManager.GetInstance().SetImageSprite(this, this._Image1, "starEquip_asset", "uilwmb_042")
			//this._lb.strokeColor = ColorUtil.TryParseHtmlString("#885f4c")
			this._lb.color = "#ffffff"
		}
		this._img_select.visible = this.selected
	}

	_Image1: Laya.Image
	_img_select: Laya.Image
	_lb: Laya.Label
	_red_dot: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._img_select,
			this._lb,
			this._red_dot,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_img_select",
				"_lb",
				"_red_dot",
			])
	}
}
window["StarEquipBasicTab"] = StarEquipBasicTab