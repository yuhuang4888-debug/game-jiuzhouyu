import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { longlangModel } from "../commonModel/longlangModel"
import { RedDotManager } from "../common/RedDotManager"
import { ModuleType } from "../common/RedDotManager"

export class longlangDecTab extends BaseItemRenderer {
	WIDTH = 150
    HEIGT = 70
	model

	public constructor() {
		super()
		this.model = longlangModel.GetInstance()
		this.base_file = "longlanguage"
		this.layout_file = "longlangDecTab"

		this.load_callback = () => {
			this.InitEvent()
		}
		this.Load()
	}

	public InitEvent() {
		this.BindEvent(this.model, longlangModel.REFRESH_RED, (flag?) => {
			if (flag == 3 && this.index == 0) {
				this._red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LONGLANG, 3)
			}
		}
		)
	}

	public dataChanged() {
		if(!super.dataChanged()){
			return
		}
		if (this.data) {
			this.img1.visible = !this.selected
			this.img_down.visible = this.selected
			this._lb.text = this.data
			this._lb.color = this.selected ? "#ffffff" : "#4f538f"
			if (this.index == 0) {
				this._red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LONGLANG, 3)
			}
		}
	}

	public setRed(bool?) {
		this._red_dot.visible = bool
	}

	img_down: Laya.Image
	img1: Laya.Image
	_lb: Laya.Label
	_red_dot: Laya.Image
	public GetComponents() {
		[
			this.img_down,
			this.img1,
			this._lb,
			this._red_dot,
		]
			= this.GetChildrenByNames([
				"img_down",
				"img1",
				"_lb",
				"_red_dot",
			])
	}
}
window["longlangDecTab"] = longlangDecTab