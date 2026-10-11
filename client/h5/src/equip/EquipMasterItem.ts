import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"

export class EquipMasterItem extends BaseItemRenderer {
	public WIDTH = 395
	public HEIGT = 35

	need_refresh = false

	public constructor() {
		super()
		this.base_file = "equip"
		this.layout_file = "EquipMasterItem"
		this.Load()
	}

	public load_callback() {
		if (this.need_refresh) {
			this.need_refresh = false
			this.UpdateView()
		}
	}

	public dataChanged() {
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh = true
		}
	}

	private UpdateView() {
		let list = this.data
		this.lb_attr.color = "#4a3a32"
		if (list[0]) {			
			this.lb_name.text = WordManager.GetProperties(list[0])
			this.lb_attr.text = "+" + list[1]
		} else {
			this.lb_name.text = "全身强化"
			this.lb_attr.text = "+" + (list[1] / 100) + "%"
		}
	}

	gp_msg: Laya.HBox
	lb_name: Laya.Label
	lb_attr: Laya.Label
	public GetComponents() {
		[
			this.gp_msg,
			this.lb_name,
			this.lb_attr,
		]
			= this.GetChildrenByNames([

				"gp_msg",
				"lb_name",
				"lb_attr",
			])
	}
}
window["EquipMasterItem"] = EquipMasterItem