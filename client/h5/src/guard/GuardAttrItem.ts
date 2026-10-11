import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class GuardAttrItem extends BaseItem1 {
	data
	need_refresh = false

	public constructor(parent?) {
		super(parent)
		this.base_file = "guard"
		this.layout_file = "GuardAttrItem"

		this.load_callback = () => {
			if (this.need_refresh) {
				this.need_refresh = false
				this.SetData(this.data)
			}
		}
	}

	public SetData(data?) {
		if (!data) {
			return
		}
		this.data = data

		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		this.lb_name.text = data[0]
		this.lb_attr.text = "+" + data[1]
	}

	gp_attr: Laya.HBox
	lb_name: Laya.Label
	lb_attr: Laya.Label
	public GetComponents() {
		[
			this.gp_attr,
			this.lb_name,
			this.lb_attr,
		]
			= this.GetChildrenByNames([
				"gp_attr",
				"lb_name",
				"lb_attr",
			])
	}
}
window["GuardAttrItem"] = GuardAttrItem