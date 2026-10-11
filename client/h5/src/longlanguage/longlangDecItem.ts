import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { longlangModel } from "../commonModel/longlangModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { Alert, Alert_Type } from "../alert/Alert"

export class longlangDecItem extends BaseItemRenderer {
	WIDTH = 90
	HEIGT = 90
	
	model
	_equipment

	public constructor() {
		super()
		this.base_file = "longlanguage"
		this.layout_file = "longlangDecItem"
		this.model = longlangModel.GetInstance()
		this.load_callback = () => {
			//this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("_dgp_bag_con"))
		}
		this.Load()
	}

	public DeleteMe() {
		if (this._equipment) {
			this._equipment.DeleteMe()
			this._equipment = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data) {
			let data = this.data.equip_info
			if (!this._equipment) {
				this._equipment = new EquipmentItem(this._gp_item)
				this._equipment.ChangeCountVisible(false)
				this._equipment.Load()
			}
			this._equipment.ExcuteCallback(() => {
				this._equipment.SetItemSize(85, 85)
				this._equipment.SetClickCallBack(() => {
					if ((this.data && this.data.equip_info) && this.data.equip_info.type_id != 0) {
						let selectFunc = () => {
							this.data.is_selected = !this.data.is_selected
							this.UpdateSelect()
							if (this.data.dec_type == 1) {
								this.model.Fire(longlangModel.SELECT_DIS_ITEM, this.data)
							} else {
								this.model.Fire(longlangModel.SELECT_DEC_ITEM, this.data)
							}
						}

						if (((this.data.dec_type != 1 && !this.data.is_selected) && this.data.equip_info.subtype > 6) && this.model.showDecTips) {
							Alert.Show("当前神祭装备品质较为珍稀是否确认分解", Alert_Type.AlertTypeCheckBox, selectFunc, null, null, null, null, null, (bool?) => {
								this.model.showDecTips = !bool
							}
							)
						} else {
							selectFunc()
						}
					}
				}
				)
			})
			this._equipment.SetData(data.type_id, data.goods_num, data.bind)
			this.UpdateSelect()
		}
	}

	public UpdateSelect() {
		this._equipment.SetSelect(this.data.is_selected)
	}

	_gp_item: Laya.Box
	public GetComponents() {
		[
			this._gp_item,
		]
			= this.GetChildrenByNames([
				"_gp_item",
			])
	}
}
window["longlangDecItem"] = longlangDecItem