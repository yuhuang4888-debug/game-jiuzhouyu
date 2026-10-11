import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { PetEquipType } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { Util } from "../util/Util";

export class PetEquipSelectItem extends BaseItemRenderer {
	_group_item: Laya.Box
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_select: Laya.Image
	_img_click: Laya.Image


	private _model: PetEquipModel;
	private _item: EquipmentItem;
	protected _type: PetEquipType;
	private _select = false;

	public constructor() {
		super()
		this.HEIGT=87
		this.WIDTH=87
		// this.skinName = "resource/game/petEquip/exml/PetEquipSelectItemExml.exml"
		this.base_file = "petEquip"
		this.layout_file = "PetEquipSelectItem"
		this._model = PetEquipModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()
		
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		if (!this._item) {
			this._item = new EquipmentItem(this._group_item)
			this._item.Load()
			this._item.SetItemSize(87, 87)
			this._item.SetShowTips(false)
		}
		if (this.data && this.data.type_id) {
			let goods_num = (this.data.equip_type > 0 && (null) || (this.data.goods_num))
			this._item.SetData(this.data.type_id, goods_num, null, null, null, null, null, null, this.data.goods_id)
			this.SetSelectStatus(this.data._is_select)
		} else {
			this._item.SetData()
			this.SetSelectStatus(false)
		}
	}

	public SetSelectStatus(visible?) {
		this._select = visible	
		this._img_select.visible = visible
	}


	public GetComponents() {
		[
			this._group_item,
			this._img_down,
			this._img_up,
			this._img_select,
			this._img_click,
		]
			= this.GetChildrenByNames([

				"_group_item",
				"_img_down",
				"_img_up",
				"_img_select",
				"_img_click"
			])
	}
}
window["PetEquipSelectItem"] = PetEquipSelectItem