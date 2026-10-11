import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GCBagTabItem extends BaseItemRenderer {
	WIDTH = 150
	HEIGT = 60

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCBagTabItem"

		this.load_callback = () => {
			this.BindEvent(GodCourtModel.GetInstance(), GodCourtModel.REFRESH_RED, (type?) => {
				if ((type == 5 || type == 6) && this.data) {
					if (this.data.index == 1) {
						this.redDot.visible = GodCourtModel.GetInstance().devourRed
					}
				}
			})
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		this.nameLb.text = this.data.name
		if (this.data.index == 1) {
			this.redDot.visible = GodCourtModel.GetInstance().devourRed
		}

		if (this.selected) {
			this.nameLb.color = "#9b572f"
		} else {
			this.nameLb.color = "#ffffff"
		}
		this._img_select.visible = this.selected
	}

	_Image1: Laya.Image
	_img_select: Laya.Image
	nameLb: Laya.Label
	redDot: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._img_select,
			this.nameLb,
			this.redDot,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_img_select",
				"nameLb",
				"redDot",
			])
	}
}
window["GCBagTabItem"] = GCBagTabItem