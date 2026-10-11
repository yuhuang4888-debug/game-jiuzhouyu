import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class RecelationActivateItem extends BaseItem1 {
	data
	need_refresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RecelationActivateItem"

		this.load_callback = () => {
			if (this.need_refresh) {
				this.SetData(this.data)
				this.need_refresh = false
			}
		}
	}

	public SetData(data?) {
		if (this.is_loaded) {
			let id = data[0]
			let value = data[1]
			this.lb_attr.text = WordManager.GetProperties(id)
			this.lb_num.text = "+" + WordManager.ConvertToPercentValue(id, value)
		} else {
			this.need_refresh = true
			this.data = data
		}
	}

	gp_attr: Laya.HBox
	lb_attr: Laya.Label
	lb_num: Laya.Label
	public GetComponents() {
		[
			this.gp_attr,
			this.lb_attr,
			this.lb_num,
		]
			= this.GetChildrenByNames([
				"gp_attr",
				"lb_attr",
				"lb_num",
			])
	}
}
window["RecelationActivateItem"] = RecelationActivateItem