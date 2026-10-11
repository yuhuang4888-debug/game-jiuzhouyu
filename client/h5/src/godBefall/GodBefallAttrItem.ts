import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ColorUtil } from "../util/ColorUtil"
import { WordManager } from "../common/WordManager"
import { SetLocalPositionX, GetSizeDeltaX } from "../util/Util"
import { GodBefallModel } from "../commonModel/GodBefallModel"

export class GodBefallAttrItem extends BaseItemRenderer {
	WIDTH = 208
	HEIGT = 28

	_model
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallAttrItem"

		this._model = GodBefallModel.GetInstance()

		this.load_callback = () => {
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public DeleteMe() {
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
		let name = WordManager.GetProperties(data[0])
		let value = WordManager.ConvertToPercentValue(data[0], data[1])
		this._lb_name.text = name + ":"
		//UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._lb_name)
		let pos_x = GetSizeDeltaX(this._lb_name) + 4
		this._lb_val.text = value
		SetLocalPositionX(this._lb_val, pos_x)
		this._Image1.visible = !(!data[2])
		this._lb_add.visible = !(!data[2])
		this._lb_add.text = (data[2] && (WordManager.ConvertToPercentValue(data[0], data[2])) || (""))
	}

	_gp_left: Laya.HBox
	_lb_name: Laya.Label
	_lb_val: Laya.Label
	_Image1: Laya.Image
	_lb_add: Laya.Label
	public GetComponents() {
		[
			this._gp_left,
			this._lb_name,
			this._lb_val,
			this._Image1,
			this._lb_add,
		]
			= this.GetChildrenByNames([

				"_gp_left",
				"_lb_name",
				"_lb_val",
				"_Image1",
				"_lb_add",
			])
	}
}
window["GodBefallAttrItem"] = GodBefallAttrItem