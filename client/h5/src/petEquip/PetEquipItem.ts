import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ModuleType } from "../common/RedDotManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { PetEquipDefine, PetEquipType } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class PetEquipItem extends BaseItem1 {
	_click: Laya.Box
	_group_data: Laya.Box
	_group_item: Laya.Box
	_group_left: Laya.Box
	_img_color: Laya.Image
	_lb_star: Laya.Label
	_Image1: Laya.Image
	_img_icon: Laya.Image
	_group_empty: Laya.Box
	_Image2: Laya.Image
	_reddot: Laya.Image


	private _model = PetEquipModel.GetInstance();
	private _pos: number;
	private _type: PetEquipType;
	private _item: EquipmentItem;
	private _data;


	public constructor(parent?, pos?, type?) {
		super(parent)
		this.base_file = "petEquip"
		this.layout_file = "PetEquipItem"
		this._type = type
		this._pos = pos

		this.load_callback = () => {

			this.display_obj.scaleX = this.display_obj.scaleY = 0.8
			this.LoadSuccess()
		}

	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._click, () => {
			if (!this._data) {
				return
			}
			let data = this._data
			if ((data.type == PetEquipDefine.HORSE_TYPE_ID || data.type == PetEquipDefine.PARTNER_TYPE_ID)
				&& data.subtype <= PetEquipDefine.EQUIP_POS_COUNT) {
				UIToolTipMgr.GetInstance().AppendPetEquipTips(data.type_id, this._data)
			} else {
				UIToolTipMgr.GetInstance().AppendGoodsTips(data.type_id, undefined, undefined, undefined, this._data.goods_num)
			}
		}, this, true)
	}

	public SetData(data?) {
		this._data = data
		if (!this._item) {
			this._item = new EquipmentItem(this._group_item)
			this._item.Load()
			this._item.ExcuteCallback(()=>{
				this._item.display_obj.scale(0.9,0.9)
			})
			this._item.SetShowTips(false)
		}
		if (data && data.goods_id) {
			let edata = this._model.GetPetEquipData(this._type, data.goods_id)
			this._item.SetData(data.type_id, null, null, null, null, null, null, null, data.goods_id)
			this._item.SetStrengthen(edata ? edata.pos_lv : 0)
			this._img_icon.visible = false
		} else {
			this._item.SetData()
			this._img_icon.visible = true
		}
		this._item.ExcuteCallback(() => {
			this._img_icon.skin = GameResPath.GetIcon("petEquip",`petEquip_${this._type}_${this._pos}`)// `petEquip_json.petEquip_${this._type}_${this._pos}_png`
		})
	}

	public SetEmptyVisible(visible?) {
		this._group_empty.visible = visible
		this._group_data.visible = !visible
	}

	public CheckReddot() {
		let red = this._model.GetRedStatus(ModuleType.PEH_EQUIP, this._pos)
			|| this._model.GetRedStatus(ModuleType.PEH_STREN, this._pos)
			|| this._model.GetRedStatus(ModuleType.PEH_STAR, this._pos)
		return red
	}


	public GetComponents() {
		[
			this._click,
			this._group_data,
			this._group_item,
			this._group_left,
			this._img_color,
			this._lb_star,
			this._Image1,
			this._img_icon,
			this._group_empty,
			this._Image2,
			this._reddot,
		]
			= this.GetChildrenByNames([

				"_click",
				"_group_data",
				"_group_item",
				"_group_left",
				"_img_color",
				"_lb_star",
				"_Image1",
				"_img_icon",
				"_group_empty",
				"_Image2",
				"_reddot",
			])
	}
}
window["PetEquipItem"] = PetEquipItem