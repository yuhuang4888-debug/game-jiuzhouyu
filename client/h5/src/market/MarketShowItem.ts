import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem";
import { Util } from "../util/Util";
import { HolySealModel } from "../commonModel/HolySealModel"
import { HolySealToolTips } from "../common/HolySealToolTips"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { RevelationModel } from "../commonModel/RevelationModel"
import { longlangModel } from "../commonModel/longlangModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel } from "../commonModel/EquipModel";
import { RoleManager } from "../commonModel/RoleManager";
import { LonglangToolTips } from "../common/LonglangToolTips";
import { BagModel } from "../commonModel/BagModel";

export class MarketShowItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_group_item: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_group_plz: Laya.Box
	_Label1: Laya.Label
	_lb_player: Laya.Label
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_ban: Laya.Image
	_lb_stage: Laya.Label
	_Group1: Laya.Box
	_Image3: Laya.Image
	_lb_price: Laya.Label
	_btn_sell: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_btn_repeal: Laya.Box
	_Image111: Laya.Image
	labelDisplay11: Laya.Label
	_btn_buy: Laya.Box
	_Image1111: Laya.Image
	labelDisplay1: Laya.Label

	Emp_btn_buy
	Emp_btn_repeal
	Emp_btn_sell
	item
	public WIDTH = 678
    public HEIGT = 120
	
	public static width = 678
	public static height = 120
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketShowItem"

		
		this.load_callback = () => {
			this.item = new EquipmentItem(this._group_item)
			this.item.SetClickCallBack(() => {
				if (this.data == null) { return }
				let data = this.data
				let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
				if (goods_basic.type == 10) {
					UIToolTipMgr.GetInstance().AppendEquipTips(goods_basic.type_id, null, null, null, data.player_id)
				} else if (goods_basic.type == HolySealModel.GOODS_TYPE) {
					UIToolTipMgr.GetInstance().AppendHolySealTips(goods_basic.type_id, null, null, [HolySealToolTips.Btn.close])
				} else if (goods_basic.type == GodBefallDefine.EQUIP_TYPE) {
					UIToolTipMgr.GetInstance().AppendGodEquipTips(goods_basic.type_id)
				} else if (goods_basic.type == RevelationModel.GOODS_TYPE) {
					UIToolTipMgr.GetInstance().AppendRevelationTooltips(data.type_id, null, null, [4])
				} else if (goods_basic.type == longlangModel.GOODS_TYPE) {
					UIToolTipMgr.GetInstance().AppendLongLangToolTips(goods_basic.type_id, null, null, [LonglangToolTips.Btn.close])
				} else if (goods_basic.type == 12 || BagModel.IlluType[goods_basic.type] == goods_basic.subtype) {
					UIToolTipMgr.GetInstance().AppendIllusionTips(data.type_id)
				} else {
					UIToolTipMgr.GetInstance().AppendGoodsTips(goods_basic.type_id)
				}
			}
			)
			this.item.Load()
			this.item.ExcuteCallback(() => {
				this.SetStage()
				this.item.SetItemSize(85 ,85)
			})
			Util.AddClickEvent(this._btn_buy, () => {
				this.ClickBuy()
			}, this, true)
			Util.AddClickEvent(this._btn_sell, () => {
				this.ClickSell()
			}, this, true)
			Util.AddClickEvent(this._btn_repeal, () => {
				this.ChickRepeal()
			}, this, true)
		}
		this.Load()
		// this.load_callback = () => {

		// 	if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 		this._lb_name.size  = 20
		// 	}

		// }

	}
	public createChildren() {
		super.createChildren()
		
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data == null) { return }
			let data = this.data
			this.item.SetData(data.type_id, data.goods_num)
			
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			this._lb_name.text = basic.goods_name
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
			// [ts2lua]lua中0和空字符串也是true，此处basic.type == 10需要确认
			this._lb_stage.text = basic.type == 10 && EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) + "阶" || ""
			this._lb_price.text = data.unit_price
			this._lb_player.text = data.role_name || ""
			let is_own = data.player_id == RoleManager.GetInstance().GetMainRoleId()
			this._btn_sell.visible = data.role_name && !is_own
			this._btn_buy.visible = !data.role_name && !is_own
			this._btn_repeal.visible = is_own
			if (this.item.is_loaded) {
				this.SetStage()
			}
		}
	}
	public SetStage() {

		let data = this.data
		if (!data) {
			return
		}
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
		if (basic.type == 10) { //or basic.type == HolySealModel.GOODS_TYPE
			let cfgs = undefined//ResManager.GetInstance().GetGameConfigFromCache(this, "Goods", false)
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

	public ClickBuy() {

		let data = this.data
		MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15111, "cliiliii", 1, data.id, data.type, data.subtype, data.player_id, data.type_id, data.goods_num, data.unit_price)
	}

	public ClickSell() {

		let data = this.data
		MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15117, "lliii", data.id, data.player_id, data.type_id, data.goods_num,data.unit_price)
	}

	public ChickRepeal() {

		let data = this.data
		MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15108, "clii", 1, data.id, data.type_id, data.goods_num)
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._group_item,
			this._Image2,
			this._lb_name,
			this._group_plz,
			this._Label1,
			this._lb_player,
			this._img_down,
			this._img_up,
			this._img_ban,
			this._lb_stage,
			this._Group1,
			this._Image3,
			this._lb_price,
			this._btn_sell,
			this._Image11,
			this.labelDisplay,
			this._btn_repeal,
			this._Image111,
			this.labelDisplay11,
			this._btn_buy,
			this._Image1111,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_group_item",
				"_Image2",
				"_lb_name",
				"_group_plz",
				"_Label1",
				"_lb_player",
				"_img_down",
				"_img_up",
				"_img_ban",
				"_lb_stage",
				"_Group1",
				"_Image3",
				"_lb_price",
				"_btn_sell",
				"_Image11",
				"labelDisplay",
				"_btn_repeal",
				"_Image111",
				"labelDisplay11",
				"_btn_buy",
				"_Image1111",
				"labelDisplay1",
			])
	}
}

window["MarketShowItem"] = MarketShowItem