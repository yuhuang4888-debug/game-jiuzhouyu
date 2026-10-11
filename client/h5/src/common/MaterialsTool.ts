import { PlatformManager } from "../PlatformManager"
import { BaseClass } from "./BaseClass"
import { MaterialsView } from "./MaterialsView"

export class MaterialsTool extends BaseClass {
	public static Instance

	materialsView
	materialsTips

	public constructor() {
		super()


		let plat_form_mgr = PlatformManager.GetInstance()
		this.materialsTips = (type_id?, goods_vo?) => {
			if (plat_form_mgr.is_alpha || plat_form_mgr.need_alpha_open_charge) {
				return
			}
			if (!this.materialsView) {
				this.materialsView = new MaterialsView()
			}
			this.materialsView.Open(type_id, goods_vo)
		}


	}

	public static GetInstance() {

		if (!MaterialsTool.Instance) {
			MaterialsTool.Instance = new MaterialsTool()
		}
		return MaterialsTool.Instance
	}
}

window["MaterialsTool"] = MaterialsTool