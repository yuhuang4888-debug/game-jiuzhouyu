import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class ArmorAttrItem extends BaseItem1 {
	data
	type
	need_refresh = false

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipArmor"
		this.layout_file = "ArmorAttrItem"

		this.load_callback = () => {
			if (this.need_refresh) {
				this.need_refresh = false
				this.SetData(this.data, this.type)
			}
		}
	}

	public SetData(data?, type?) {
		if (!data) {
			return
		}
		this.data = data
		this.type = type

		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		let name = null
		let value = null
		if (type == 1) {
			name = WordManager.GetProperties(this.data[0]) + ": "
			value = WordManager.ConvertToPercentValue(this.data[0], this.data[1])
			this.attr.text = name + value
			this.up.text = ""
		} else if (type == 2) {
			name = WordManager.GetProperties(this.data[0]) + ": 0"
			value = "+" + WordManager.ConvertToPercentValue(this.data[0], this.data[1])
			this.attr.text = name
			this.up.text = value
			this.up.color = "#0a953e"
		} else {
			name = WordManager.GetProperties(this.data[0]) + ": "
			value = "+" + WordManager.ConvertToPercentValue(this.data[0], this.data[1])
			this.attr.text = name
			this.up.text = value
			this.up.color = "#0a953e"
		}
	}

	gp_attr: Laya.HBox
	attr: Laya.Label
	up: Laya.Label
	public GetComponents() {
		[
			this.gp_attr,
			this.attr,
			this.up,
		]
			= this.GetChildrenByNames([
				"gp_attr",
				"attr",
				"up",
			])
	}
}
window["ArmorAttrItem"] = ArmorAttrItem