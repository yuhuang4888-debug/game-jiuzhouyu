import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { HolySealModel } from "../commonModel/HolySealModel"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { RevelationModel } from "../commonModel/RevelationModel"
import { longlangModel } from "../commonModel/longlangModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { MarketModel } from "../commonModel/MarketModel"
import { BagModel } from "../commonModel/BagModel"
import { LonglangToolTips } from "../common/LonglangToolTips"
import { IllusionTips } from "../common/IllusionTips"
export class MarketSellItem extends BaseItemRenderer {
	_group_item: Laya.Box
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_ban: Laya.Image
	ClickCallBack
	item
	parent_mask_corners
	public static width = 137
	public static height = 137
	public WIDTH = 85
    public HEIGT = 85
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketSellItem"

		this.Load()
		this.load_callback = () => {

		}
		// this.load_callback = () => {

		// 	let scroll_rect = this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))
		// 	if (scroll_rect && scroll_rect.transform ) { 
		// 		let list_bag = scroll_rect.transform.Find("_list_bag")
		// 		if (list_bag ) { 
		// 			this.parent_mask_corners = GetWorldCorners(list_bag)
		// 		}
		// 	}
		// 	//this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("_list_bag"))

		// }

		this.ClickCallBack = () => {
			let data = this.data
			if (data.type == 10) {
				let list = data.sell_type && [7] || [6]
				UIToolTipMgr.GetInstance().AppendEquipTips(data.type_id, null, null, data, null, list)
			} else if (data.type == HolySealModel.GOODS_TYPE) {
				UIToolTipMgr.GetInstance().AppendHolySealTips(data.type_id, data, null, [HolySealToolTips.Btn.upShelf])
			} else if (data.type == GodBefallDefine.EQUIP_TYPE) {
				UIToolTipMgr.GetInstance().AppendGodEquipTips(data.type_id, data, [2])
			} else if (data.type == RevelationModel.GOODS_TYPE) {
				UIToolTipMgr.GetInstance().AppendRevelationTooltips(data.type_id, data, null, [0])
			} else if (data.type == longlangModel.GOODS_TYPE) {
				UIToolTipMgr.GetInstance().AppendLongLangToolTips(data.type_id, data, null, [LonglangToolTips.Btn.upShelf])
			} else if (data.type == 12 || BagModel.IlluType[data.type] == data.subtype) {
				UIToolTipMgr.GetInstance().AppendIllusionTips(data.type_id, null, null, data, null, [IllusionTips.Btn.UpShelf])
			} else {
				UIToolTipMgr.GetInstance().AppendGoodsTips(data.type_id, null, null, data)
			}
		}

	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data == null) { return }
			let data = this.data
			if (!this.item) {
				this.item = new EquipmentItem(this._group_item)
				this.item.SetClickCallBack(() => {
					this.ClickCallBack()
				})
				this.item.ExcuteCallback(() => {
					this.SetStage()
					this.item.SetItemSize(85,85)
				})
				// this.item.SetMaskId(this.mask_id || 1)
				// this.item.SetMaskRect(this.mask_corners)
				this.item.Load()
			}
			this.item.SetData(data.type_id, data.goods_num, data.is_lock)
			if (this.item.is_loaded) {
				this.SetStage()
			}
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}
	public SetStage() {


		let data = this.data
		if (data) {
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			if (basic.type == 10) { //or basic.type == HolySealModel.GOODS_TYPE
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_goods", false)
				let cant = MarketModel.GetInstance().CantWearEquip(basic, cfgs)
				let [up, down] = MarketModel.GetInstance().IsEquipPowerOver(basic, data.rating)
				this._img_up.visible = up && !cant
				this._img_down.visible = down && !cant
				this._img_ban.visible = cant
			} else {
				this._img_up.visible = false
				this._img_down.visible = false
				this._img_ban.visible = false
			}
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

window["MarketSellItem"] = MarketSellItem