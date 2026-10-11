import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class dwTab extends BaseItemRenderer {
	public WIDTH = 128
	public HEIGT = 54

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwTab"

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
		this._img_red.visible = data.red_state
		if (this.selected) {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "bossField", "ui_chief_btn_1", true)
			this._lb_floor.color = "#9b572f"
		} else {
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "dragonWhisper", "ui_chief_btn_6", true)
			this._lb_floor.color = "#ffffff"
		}
		this._lb_floor.text = data.label
		this._img_red.visible = data.red_state
	}

	_img_bg: Laya.Image
	_lb_floor: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_floor,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_floor",
				"_img_red",
			])
	}
}
window["dwTab"] = dwTab