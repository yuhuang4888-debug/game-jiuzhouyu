import { BaseItem1 } from "../common/BaseItem1"
import { CompositeModel } from "../commonModel/CompositeModel"

export class CompositeEquipResolveItem extends BaseItem1 {
	data
	model
	needRefresh

	public constructor(parent?) {
		super(parent)


		this.base_file = "composite"
		this.layout_file = "CompositeEquipResolveItem"
		this.model = CompositeModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public LoadSuccess() {
	}
	
	public InitEvents() {
		if (this.needRefresh) {
			this.SetData(this.data)
		}
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {

		} else {
			this.needRefresh = true
		}
	}
	
	bg: Laya.Image
	equip_con: Laya.Box
	click_bg: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this.equip_con,
			this.click_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"equip_con",
				"click_bg",
			])
	}
}
window["CompositeEquipResolveItem"] = CompositeEquipResolveItem