import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { PetEquipDefine, PetEquipType } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { TaskFinishView } from "../task/TaskFinishView"

export class PetEquipBagItem extends BaseItemRenderer {
	_group_item: Laya.Box
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_ban: Laya.Image


	private _model: PetEquipModel;
	private _item: EquipmentItem;
	protected _type: PetEquipType;

	public constructor() {
		super()
		this.WIDTH=87
		this.HEIGT=87
		// this.skinName = "resource/game/petEquip/exml/PetEquipBagItemExml.exml"
		this.base_file = "petEquip"
		this.layout_file = "PetEquipBagItem"
		this._model = PetEquipModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()
		
	}
	public load_callback(){
		// this.display_obj.scale(0.8,0.8)
		if (!this._item) {
			this._item = new EquipmentItem(this._group_item)
			this._item.SetItemSize(87, 87)
			this._item.Load()
		}
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

		let data = this.data
		if (data && data.type_id) {
			if (data.subtype <= PetEquipDefine.EQUIP_POS_COUNT) {
				let sdata = this._model.GetStageData(this._type, data.equip_type, data.equipStage)
				let color = sdata ? sdata.color : 0
				this._item.ExcuteCallback(() => {
					this._item.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
					this._item.SetGrade(data.equipStage)
					this._item.UpdatePetEquipGroup(color, data.equipStar)
					this._item.SetClickCallBack(this.ClickCallBack)
					let wear = this._model.GetWearEquipInfo(this._type, data.equip_type)
					let canEquip = this._model.CheckCanEquip(this._type, data.type_id)
					this._img_up.visible = (!wear || data.rating > wear.rating && canEquip)
					this._img_down.visible = (wear && data.rating < wear.rating && canEquip)
					this._img_ban.visible = !canEquip
				})
			} else {
				this._item.SetData(data.type_id, data.goods_num)
				this._img_up.visible = false
				this._img_down.visible = false
				this._img_ban.visible = false
			}
		} else {
			this._img_up.visible = false
			this._img_down.visible = false
			this._img_ban.visible = false
			this._item.SetData()
		}
	}

	private ClickCallBack = () => {
		if (!this.data) {
			return
		}
		let data = this.data
		if ((data.type == PetEquipDefine.HORSE_TYPE_ID || data.type == PetEquipDefine.PARTNER_TYPE_ID)
			&& data.subtype <= PetEquipDefine.EQUIP_POS_COUNT) {
			UIToolTipMgr.GetInstance().AppendPetEquipTips(data.type_id, this.data, null, [0, 2])
		} else {
			UIToolTipMgr.GetInstance().AppendGoodsTips(data.type_id, undefined, undefined,  [0, 1], this.data.goods_num)
		}
	}


	public GetComponents() {
		[
			this._group_item,
			this._img_down,
			this._img_up,
			this._img_ban,
		]
			= this.GetChildrenByNames([

				"_group_item",
				"_img_down",
				"_img_up",
				"_img_ban",
			])
	}
}
window["PetEquipBagItem"] = PetEquipBagItem