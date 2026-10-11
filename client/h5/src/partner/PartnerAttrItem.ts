import { BaseItem1 } from "../common/BaseItem1";
import { WordManager } from "../common/WordManager";
import { PartnerModel } from "../commonModel/PartnerModel";

export class PartnerAttrItem extends BaseItem1 {
	bg: Laya.Image
	attr_icon: Laya.Image
	value: Laya.Label
	gp_up: Laya.Box
	image: Laya.Image
	up_value: Laya.Label
	name:Laya.Label


	model
	index
	data
	next_cfg

	public constructor(parent?) {
		super(parent)
		this.base_file = "partner"
		this.layout_file = "PartnerAttrItem"
		this.model = PartnerModel.GetInstance()
		this.load_callback = () => {
		}
	}
	public InitView() {
		if (this.index == undefined || this.data == undefined) {
			return
		}
		let attr_icon
		let attr_type = Number(this.data[0]) || this.data["attr_id"]
		if (attr_type) {
			let val1 = Number(this.data[1] || this.data["attr_val"])
			this.name.text=WordManager.GetProperties(attr_type) + ":" 
			this.value.text = val1.toString()//WordManager.ConvertToPercentValue(attr_type, val1)
			this.gp_up.visible = false
			if (this.next_cfg) {
				for (let k in this.next_cfg) {
					let v = this.next_cfg[k]
					if ((Number(v[0]) || v["attr_id"]) == attr_type) {
						this.gp_up.visible = true
						let val2 = Number(v[1] || v["attr_val"])
						this.up_value.text = WordManager.ConvertToPercentValue(attr_type, val2)
						break
					}
				}
			}
		}
	}
	public SetData(...parms) {
		this.index = parms[0]
		this.data = parms[1]
		this.next_cfg = parms[2]
		this.InitView()
	}

	public GetComponents() {
		[
			this.bg,
			this.attr_icon,
			this.value,
			this.gp_up,
			this.image,
			this.up_value,
			this.name
		]
			= this.GetChildrenByNames([

				"bg",
				"attr_icon",
				"value",
				"gp_up",
				"image",
				"up_value",
				"name"
			])
	}
}
window["PartnerAttrItem"] = PartnerAttrItem