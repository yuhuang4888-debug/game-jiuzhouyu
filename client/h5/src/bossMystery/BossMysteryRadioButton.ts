import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class BossMysteryRadioButton extends BaseItemRenderer {
	public WIDTH = 128
	public HEIGT = 54

	public constructor() {
		super()
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryRadioButton"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		let data = this.data
		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "bossField", "ui_chief_btn_1", true)
			this._lb_floor.color = "#9b572f"
		} else {
			this._lb_floor.color = "#ffffff"
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "bossField", "ui_chief_btn_5", true)
		}
		this._lb_floor.text = data.label
	}

	_img_bg: Laya.Image
	_lb_floor: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_floor,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_lb_floor",
			])
	}
}
window["BossMysteryRadioButton"] = BossMysteryRadioButton