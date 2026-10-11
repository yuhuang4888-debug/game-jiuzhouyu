import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { HolySealModel } from "../commonModel/HolySealModel"



export class HolySealDecomposeItem extends BaseItemRenderer {
	public WIDTH = 95
	public HEIGT = 95


	private _equipment: EquipmentItem

	private model: HolySealModel

	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealDecomposeItem"
		this.model = HolySealModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public DeleteMe() {
		if (this._equipment) {
			this._equipment.DeleteMe()
			this._equipment = undefined
		}
		super.DeleteMe()
	}

	LoadSuccess() {
		this._equipment = new EquipmentItem(this._gp_item)
		this._equipment.Load()
		this._equipment.SetItemSize(87, 87)
		this._equipment.SetClickCallBack(() => {
			this.data.is_selected = !this.data.is_selected
			this.UpdateSelect()
			this.model.Fire(HolySealModel.SELECT_BREAK_DOWN_ITEM, this.data)
		})
		this._equipment.ExcuteCallback(() => {
			this.UpdateEquip()
		})
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			this.UpdateEquip()
			this.UpdateSelect()
		}
	}

	UpdateEquip() {
		let data = this.data && this.data.equip_info
		if (this._equipment.is_loaded && data) {
			this._equipment.ChangeCountVisible(data.goods_num > 1)
			this._equipment.SetData(data.type_id, data.goods_num, data.bind)
		}
	}

	UpdateSelect() {
		this._img_select.visible = this.data.is_selected
		
	}
	_gp_item: Laya.Box
	_img_select: Laya.Image
	public GetComponents() {
		[
			this._gp_item,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_img_select",
			])
	}
}
window["HolySealDecomposeItem"] = HolySealDecomposeItem