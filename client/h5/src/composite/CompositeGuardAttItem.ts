import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"

export class CompositeGuardAttItem extends BaseItem1 {
	InitView
	SetData
	_Image1

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeGuardAttItem"

		let local_WordManager = WordManager

		this.load_callback = () => {

		}

		this.SetData = (data?) => {
			if (data) {
				this.InitView(data)
			}
		}

		this.InitView = (data?) => {
			if (!data) {
				return
			}
			let name = local_WordManager.GetProperties(data[0])
			let value = local_WordManager.ConvertToPercentValue(data[0], data[1])
			this._lb_att.text = name + ":"
			this.lb_num.text = value
		}
	}
	gp_attr: Laya.HBox
	_lb_att: Laya.Label
	lb_num: Laya.Label
	public GetComponents() {
		[
			this.gp_attr,
			this._lb_att,
			this.lb_num,
		]
			= this.GetChildrenByNames([

				"gp_attr",
				"_lb_att",
				"lb_num",
			])
	}
}
window["CompositeGuardAttItem"] = CompositeGuardAttItem