import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { PetEquipType, PetEquipDefine, PetEquipEvent } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { PetEquipItem } from "../petEquip/PetEquipItem"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class PetEquipOutItem extends BaseItem1 {
	_group_data: Laya.Box
	_group_item: Laya.Box
	_group_empty: Laya.Box
	_Image1: Laya.Image
	_img_icon: Laya.Image
	_reddot: Laya.Image


	private _model = PetEquipModel.GetInstance();
	private _pos: number;
	private _type: PetEquipType;
	private _item: PetEquipItem;
	private _data;

	public constructor(parent?, pos?, type?) {
		super(parent)

		this.base_file = "petEquip"
		this.layout_file = "PetEquipOutItem"

		this._type = type
		this._pos = pos

		this.load_callback = () => {
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
		this._img_icon.skin =GameResPath.GetIcon("petEquip",`petEquip_${this._type}_${this._pos}`) //`petEquip_json.petEquip_${this._type}_${this._pos}_png`
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetIcon("petEquip", "petEquip_${this._type}_${this._pos}"))
		this._reddot.visible = this.CheckReddot()
		this.SetEmptyVisible(true)

		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._group_empty, () => {
			let data = this._data
			if (data) {
				if ((data.type == PetEquipDefine.HORSE_TYPE_ID || data.type == PetEquipDefine.PARTNER_TYPE_ID)
					&& data.subtype <= PetEquipDefine.EQUIP_POS_COUNT) {
					UIToolTipMgr.GetInstance().AppendPetEquipTips(data.type_id, this._data, null, [0, 1])
				} else {
					UIToolTipMgr.GetInstance().AppendGoodsTips(data.type_id, undefined, undefined, undefined, this._data.goods_num)
				}
			} else {
				let equips = this._model.GetBagEquipsByType(this._type, this._pos)
				if (!equips.length) {
					Message.show("暂无可穿戴装备")
					return false
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PetEquipBaseView", this._type)
			}
		}, this, true)

		this.BindEvent(PetEquipModel.GetInstance(), PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
			if (type != this._type) {
				return
			}
			this._reddot.visible = this.CheckReddot()
		})
	}

	public SetData(data?) {
		this._data = data
		if (!this._item) {
			this._item = new PetEquipItem(this._group_item)
			this._item.Load()
			// this._item.SetItemSize(87, 87)
			// this._item.SetShowTips(false)
		}
		this._item.ExcuteCallback(()=>{
			if (data) {
				this._item.SetData(data)
				this.SetEmptyVisible(false)
			} else {
				this._item.SetData()
				this.SetEmptyVisible(true)
			}
			this._reddot.visible = this.CheckReddot()
		})
	}

	public SetEmptyVisible(visible?) {
		this._group_empty.visible = visible
		this._group_data.visible = !visible
	}

	public CheckReddot() {
		let red = this.GetRedStatusOne(this._type, this._pos)
		return red
	}

	public GetRedStatusOne(type?, pos?) {
		let mtype = this._model.GetRedIDByType(type, 1)
		return this._model.GetRedStatus(mtype, pos)
	}


	public GetComponents() {
		[
			this._group_data,
			this._group_item,
			this._group_empty,
			this._Image1,
			this._img_icon,
			this._reddot,
		]
			= this.GetChildrenByNames([

				"_group_data",
				"_group_item",
				"_group_empty",
				"_Image1",
				"_img_icon",
				"_reddot",
			])
	}
}
window["PetEquipOutItem"] = PetEquipOutItem