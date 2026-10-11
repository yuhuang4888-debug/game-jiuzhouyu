import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { EquipModel } from "../commonModel/EquipModel"

export class EquipAttrItem extends BaseItem1 {
	cdata
	equip_type
	ndata
	type

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipAttrItem"

		this.load_callback = () => {
			this.SetData(this.type, this.cdata, this.ndata, this.equip_type)
		}
	}

	public SetData(type?, cdata?, ndata?, equip_type?) {
		this.type = type
		this.cdata = cdata
		this.ndata = ndata
		this.equip_type = equip_type

		if (!cdata && type != 2) {
			return
		}
		if (!this.is_loaded) {
			return
		}

		if (type == 1) {
			this.name.text = WordManager.GetProperties(cdata[0]) + "："
			this.attr.text = String(cdata[1])
			this.up.text = (ndata ? ("+" + (ndata[1] - cdata[1])) : (""))
		} else {
			let smelt_info = EquipModel.GetInstance().GetSmeltInfo(equip_type)
			this.name.text = WordManager.GetEquipPos(equip_type) + "强化："
			this.attr.text = smelt_info.refine ? cdata / 100 + "%" : '0%';
			this.up.text = (ndata && ndata > 0) ? ("+" + ndata / 100 + "%") : ""
		}
	}

	gp_now: Laya.HBox
	name: Laya.Label
	attr: Laya.Label
	up: Laya.Label
	public GetComponents() {
		[
			this.gp_now,
			this.name,
			this.attr,
			this.up,
		]
			= this.GetChildrenByNames([

				"gp_now",
				"name",
				"attr",
				"up",
			])
	}
}
window["EquipAttrItem"] = EquipAttrItem