import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { EquipModel } from "../commonModel/EquipModel"
import { ResManager } from "../common/ResManager"

export class EquipRefiUpTabItem extends BaseItem1 {
	model
	lv
	data
	equip_type
	cfg_refine
	need_refresh = false

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipRefinement"
		this.layout_file = "EquipRefiUpTabItem"

		this.model = EquipModel.GetInstance()

		this.load_callback = () => {
			this.cfg_refine = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refinement", false)
			
			this.lb_name.style.fontSize = 20
			this.lb_name.style.color = "#663915"
			this.lb_name.style.wordWrap = false
			
			if (this.need_refresh) {
				this.need_refresh = false
				this.UpdateView()
			}
		}
	}

	public SetData(data, equip_type, lv) {
		this.data = data
		this.equip_type = equip_type
		this.lv = lv

		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh = true
		}
	}

	private UpdateView() {
		let value_str = this.model.getRefineAttr(this.data, this.lv, this.equip_type, this.cfg_refine)
		this.lb_value.text = value_str
		
		let name_str = Util.GetAttrStr([[this.data.attr_id, this.data.attr_val]], "'#d85d03'")
		this.lb_name.innerHTML = name_str
	}

	img_bg: Laya.Image
	lb_name: Laya.HTMLDivElement
	lb_value: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.lb_name,
			this.lb_value,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"lb_name",
				"lb_value",
			])
	}
}
window["EquipRefiUpTabItem"] = EquipRefiUpTabItem