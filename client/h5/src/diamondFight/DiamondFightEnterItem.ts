import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"

export class DiamondFightEnterItem extends BaseItemRenderer {

	model: DiamondFightModel

	WIDTH = 201
	HEIGT = 38

	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightEnterItem"

		this.model = DiamondFightModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			this._lb_index.text = data.index
			this._lb_value.text = data.count
		}
	}


	_img_bg: Laya.Image
	_lb_index: Laya.Label
	_lb_value: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_index,
			this._lb_value,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_index",
				"_lb_value",
			])
	}
}
window["DiamondFightEnterItem"] = DiamondFightEnterItem