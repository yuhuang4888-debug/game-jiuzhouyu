import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { HolySealModel } from "../commonModel/HolySealModel"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { RevelationModel } from "../commonModel/RevelationModel"
import { longlangModel } from "../commonModel/longlangModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { LonglangToolTips } from "../common/LonglangToolTips"
import { BagModel } from "../commonModel/BagModel"
import { IllusionTips } from "../common/IllusionTips"
//import { RevelationToolTips } from "../revelation/RevelationToolTips"

export class MarketSellGoodsItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_group_item: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_lb_price: Laya.Label
	_img_goods: Laya.Image
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_ban: Laya.Image
	click_gp: Laya.Box
	peddle: Laya.Image
	ClickCallBack
	item
	parent_mask_corners
	public static width = 347
	public static height = 157
	public WIDTH = 330
    public HEIGT = 120

	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketSellGoodsItem"

		
		this.load_callback = () => {
			this.item = new EquipmentItem(this._group_item)
			//this.item.SetMaskId(this.mask_id || 1)
			//this.item.SetMaskRect(this.parent_mask_corners)
			this.item.Load()
			this.item.ExcuteCallback(() => {
				this.SetStage()
				this.item.SetItemSize(85,85)
				//this.item.click_group.GetComponent("Image").raycastTarget = false
			})
			this.item.SetShowTips(false)
			Util.AddClickEvent(this.click_gp, () => {
				this.ClickCallBack()
			}, this, false)
			
			Util.AddClickEvent(this.peddle, () => {
				MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15122, "l", this.data.id)
			}, this, true)
		}

		let ui_tool_tip_mgr = UIToolTipMgr.GetInstance()
		this.Load()
		// this.load_callback = () => {


		// }
		this.ClickCallBack = () => {
			let data = this.data
			if (data.type == 10) {
				let list = data.sell_type && [7] || [6]
				ui_tool_tip_mgr.AppendEquipTips(data.type_id, null, null, data, null, list)
			} else if (data.type == HolySealModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendHolySealTips(data.type_id, data, null, [HolySealToolTips.Btn.outShelf])
			} else if (data.type == GodBefallDefine.EQUIP_TYPE) {
				ui_tool_tip_mgr.AppendGodEquipTips(data.type_id, data, [7])
			} else if (data.type == RevelationModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendRevelationTooltips(data.type_id, data, null, [4])
			} else if (data.type == longlangModel.GOODS_TYPE) {
				ui_tool_tip_mgr.AppendLongLangToolTips(data.type_id, data, null, [LonglangToolTips.Btn.outShelf])
			} else if (data.type == 12 || BagModel.IlluType[data.type] == data.subtype) {//时装和培养的幻化
				ui_tool_tip_mgr.AppendIllusionTips(data.type_id, null, null, data, null, [IllusionTips.Btn.OutShelf])
			} else {
				ui_tool_tip_mgr.AppendGoodsTips(data.type_id, null, null, data)
			}
		};
	}
	public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data == null) { return }
			let data = this.data
			this._lb_name.text = data.goods_name
			this._lb_price.text = data.unit_price
			this.item.SetData(data.type_id, data.goods_num)
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
				let up, down = MarketModel.GetInstance().IsEquipPowerOver(basic, data.rating)
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
			this._Image1,
			this._group_item,
			this._Image2,
			this._lb_name,
			this._lb_price,
			this._img_goods,
			this._img_down,
			this._img_up,
			this._img_ban,
			this.click_gp,
			this.peddle
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_group_item",
				"_Image2",
				"_lb_name",
				"_lb_price",
				"_img_goods",
				"_img_down",
				"_img_up",
				"_img_ban",
				"click_gp",
				"peddle"
			])
	}
}

window["MarketSellGoodsItem"] = MarketSellGoodsItem