import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { PetEquipType, PetEquipEvent } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { GameResPath } from "../util/GameResPath";

export class APetEquipShowItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_group_item: Laya.Box
	_img_icon: Laya.Image
	_reddot: Laya.Image


	private _model: PetEquipModel;
	private _item: EquipmentItem;
	protected _type: PetEquipType;
	protected _red_type;
	private _red_list;

	public constructor() {
		super()
		this.WIDTH=150
		this.HEIGT=184
		// this.skinName = "resource/game/petEquip/exml/PetEquipShowItemExml.exml"
		this.base_file = "petEquip"
		this.layout_file = "PetEquipShowItem"
		this._model = PetEquipModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()
	}
	
	public load_callback(){
		this.BindEvent(this._model, PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
			this._reddot.visible = this.GetRedStatus()
		})
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (!this._item) {
			this._item = new EquipmentItem(this._group_item)
			this._item.Load()
			this._item.SetItemSize(87, 87)
			this._item.SetShowTips(false)
		}
		let data = this.data
		this._Image2.visible=this.selected
		if (data && data.type_id) {
			this._item.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
			this._img_icon.visible = false
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			let edata = this._model.GetPetEquipData(this._type, data.goods_id)
			let lv = edata && edata.pos_lv > 0 ? `+${edata.pos_lv}` : ``
			this._lb_name.text = `${lv} ${basic.goods_name}`
		} else {
			this._item.SetData()
			let type = this._model.GetGoodTypeByType(this._type)
			let name = this._model.GetPosName(type, data.pos)
			this._lb_name.text = `需先穿戴${name}`
			this._img_icon.visible = true
			this._img_icon.skin =GameResPath.GetIcon("petEquip",`petEquip_${this._type}_${data.pos}`) //`petEquip_json.petEquip_${this._type}_${data.pos}_png`
		}
		this._reddot.visible = this.GetRedStatus()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe()
	}

	public GetRedStatus() {
		if(this.data==undefined || this.data.goods_id==undefined){
			return
		}
		if (!this.data.goods_id) {
			return false
		}
		let id = this._model.GetRedIDByType(this._type, this._red_type)
		let red = this._model.GetRedStatus(id, this.data.equip_type)
		return red
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_name,
			this._group_item,
			this._img_icon,
			this._reddot,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_name",
				"_group_item",
				"_img_icon",
				"_reddot",
			])
	}
}
window["APetEquipShowItem"] = APetEquipShowItem