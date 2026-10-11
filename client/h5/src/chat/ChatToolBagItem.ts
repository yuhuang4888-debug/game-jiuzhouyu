import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { EquipModel } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { RoleManager } from "../commonModel/RoleManager"

export class ChatToolBagItem extends BaseItemRenderer {
	_img_ban
	_img_down
	_img_up
	_model
	is_batch
	is_delay_callback
	item
	itemGroup
	config_seal_equip
	_Image1: Laya.Image
	_img_tips: Laya.Image

	public WIDTH = 110
	public HEIGT = 100

	public constructor(parent) {
		super()

		this.is_batch = true
		this.base_file = "chat"
		this.layout_file = "ChatToolBagItem"
		// this.layer_value = Enum_UILayer.Activity
		this._model = ChatModel.GetInstance()
		this.is_delay_callback = true
		this.Load()

	}

	public load_callback() {

		// BaseAwardItem.StartBatchLoad()
		ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_seal_equip", false, undefined, (cfgs) => {
			this.config_seal_equip = cfgs
		});
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				if (!this.item) {
					this.item = new EquipmentItem(this.itemGroup, null, Enum_UILayer.Activity, null, this.is_batch)
					// this.item.scaleX = 0.7
					// this.item.scaleY = 0.7
					// this.item.touchEnabled = false
					// this.item.touchChildren = false
					// SetLocalScaleX(this.item.transform, 0.9)
					// SetLocalScaleY(this.item.transform, 0.9)
					// this.item.layer_value = this.layer_value
					// this.item.SetMaskItemMaterial(this.mat)
					// this.item.SetMaskId(this.mask_id)
					// this.item.SetMaskRect(this.mask_corners)
					this.item.SetClickCallBack(() => {
						this.click()
					})
					this.item.Load()
				}
				this.item.SetData(this.data.type_id, this.data.goods_num)
				this.item.SetStrengthen(this.data.stren)
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(ResManager.GetInstance(), "Goods", false)
				if (this.data.type == 10) {
					let ban = EquipModel.GetInstance().CantWearEquip(this.data.type_id, cfgs)
					// this._img_ban.visible = ban
					this._img_ban.visible = ban
					let info = EquipModel.GetInstance().GetWearEquipInfo(this.data.equip_type)
					if (!ban) {
						let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(this.data.equip_type)
						// this._img_up.visible = ! wear_equip_info || wear_equip_info.rating < this.data.rating
						// this._img_down.visible = wear_equip_info && wear_equip_info.rating > this.data.rating
						this._img_up.visible = !wear_equip_info || wear_equip_info.rating < this.data.rating
						this._img_down.visible = wear_equip_info && wear_equip_info.rating > this.data.rating
					} else {
						this._img_up.visible = false
						this._img_down.visible = false
					}
				} else if (this.data.type == HolySealModel.GOODS_TYPE) {
					let ban = HolySealModel.GetInstance().CantWearEquip(this.data.type_id)
					this._img_ban.visible = ban


					this.item.ChangeCountVisible(this.data.goods_num > 1)
					if (!ban) {
						let holy_seal_data = HolySealModel.GetInstance().GetHolySealData(this.data.type_id, this.config_seal_equip)
						//let attr_list = []
						//let base_attr = ErlangParser.GetInstance().Parse(holy_seal_data.base_attr)
						//for (let _tmpi in base_attr) {
						// let vo = base_attr[_tmpi]
						//table.insert(attr_list, vo)
						//}
						//let rating = Util.CalAttrPower(attr_list, false)
						let wear_equip_info = HolySealModel.GetInstance().GetWearEquipByPos(this.data.subtype)
						this._img_up.visible = !wear_equip_info || wear_equip_info.rating < holy_seal_data.rating
						this._img_down.visible = wear_equip_info && wear_equip_info.rating > holy_seal_data.rating
					} else {
						this._img_up.visible = false
						this._img_down.visible = false
					}
				} else {
					this._img_ban.visible = false
					this._img_up.visible = false
					this._img_down.visible = false
				}
			}
		}

	}

	public click(e?) {

		let role_id = RoleManager.GetInstance().GetMainRoleId()
		let data = this.data
		if (!this.data) {
			return
		}
		if (!this.data.goods_name) {
			data = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
			// [ts2lua]data下标访问可能不正确
			data["goods_id"] = this.data.goods_id
		}
		ChatModel.GetInstance().Fire(ChatModelEvent.ADD_BAG_GOODS, data, ChatModel.GetInstance().selectChannel)
		// e.stopImmediatePropagation()
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item=null
		}
		super.DeleteMe()
		// BaseAwardItem.EndBatchLoad()
	}


	public GetComponents() {
		[
			this._Image1,
			this.itemGroup,
			this._img_tips,
			this._img_down,
			this._img_up,
			this._img_ban,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"itemGroup",
				"_img_tips",
				"_img_down",
				"_img_up",
				"_img_ban",
			])
	}
}

window["ChatToolBagItem"] = ChatToolBagItem


