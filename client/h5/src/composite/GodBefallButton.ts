import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { PlatformManager } from "../PlatformManager"

export class GodBefallButton extends BaseItemRenderer {
	WIDTH = 108
	HEIGT = 45

	public constructor(parent) {
		super()
		this.base_file = "composite"
		this.layout_file = "GodBefallButton"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this._label.height = 43
			this._label.width = 109
			this._label.leading = 0.1
			this._label.wordWrap =true
			this._label.pos(54,23)
			this._label.align="center"
			this._label.valign="middle"
			this._label.fontSize = 16
			}
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		if (!this.data) {
			return
		}

		let data = this.data
		this.red_dot.visible = data.red_state
		this._label.text = data.label
		this._img_up.visible = !this.selected
		this._img_down.visible = this.selected
		this._label.color = this.selected ? "#663915" : "#ffffff"
	}

	_img_up: Laya.Image
	_img_down: Laya.Image
	_label: Laya.Label
	red_dot: Laya.Image
	public GetComponents() {
		[
			this._img_up,
			this._img_down,
			this._label,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"_img_up",
				"_img_down",
				"_label",
				"red_dot",
			])
	}
}
window["GodBefallButton"] = GodBefallButton