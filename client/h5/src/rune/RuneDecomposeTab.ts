import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";

export class RuneDecomposeTab extends BaseItemRenderer {
	public WIDTH = 140
	public HEIGT = 52

	setRed
	model: RuneModel
	public constructor(parent) {
		super()
		this.base_file = "rune"
		this.layout_file = "RuneDecomposeTab"
		this.model = RuneModel.GetInstance()
		this.Load()

		this.BindEvent(RuneModel.GetInstance(), RuneEvent.DEC_MAIN_VIEW_RED, (index?, bool?) => {
			if (this.index == index) {
				this.setRed(bool)
			}
		})

		this.dataChanged = () => {
			if (super.dataChanged()) {
				if (this.data) {
					this.img1.visible = !this.selected
					this.img_down.visible = this.selected
					this._lb.color = this.selected ? "#4a3a32" : "#ffffff"
					this._lb.text = this.data
					if (this.index == 0) {
						this.setRed(RuneModel.GetInstance()._resolve_red)
					}
				}
			}
		}

		this.setRed = (bool?) => {
			this._red_dot.visible = bool
		}
	}


	img1: Laya.Image
	img_down: Laya.Image
	_lb: Laya.Label
	_red_dot: Laya.Image
	public GetComponents() {
		[
			this.img1,
			this.img_down,
			this._lb,
			this._red_dot,
		]
			= this.GetChildrenByNames([

				"img1",
				"img_down",
				"_lb",
				"_red_dot",
			])
	}
}
window["RuneDecomposeTab"] = RuneDecomposeTab