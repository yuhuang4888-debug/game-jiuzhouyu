import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"


export class RolePropertyItemRenderer extends BaseItemRenderer {
	public property_group: Laya.Box;
	public property_name: Laya.Label;
	public property_value: Laya.Label;



	public static width = 300
	public static height = 38

	public constructor(parent) {
		super()
		this.base_file = "role"
		this.layout_file = "RolePropertyItemRenderer"
		this.HEIGT=38
		// this.skinName = "resource/game/role/exml/RolePropertyItemRendererExml.exml"
		this.Load()

	}

	public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let lb_len=this.data.attr.length
			// this.property_name.width=lb_len*25
			this.property_name.text = this.data.attr + ":"
			this.property_value.text = this.data.value.toString()
		}
	}


	public GetComponents() {
		[
			this.property_group,
			this.property_name,
			this.property_value,
		]
			= this.GetChildrenByNames([

				"property_group",
				"property_name",
				"property_value",
			])
	}
}
window["RolePropertyItemRenderer"] = RolePropertyItemRenderer