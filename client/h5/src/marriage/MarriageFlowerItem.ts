import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Config } from "../common/Config";
import { ResManager } from "../common/ResManager";
import { BagModel } from "../commonModel/BagModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageDefine, MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";

export class MarriageFlowerItem extends BaseItemRenderer {
	public WIDTH = 444
	public HEIGT = 113

	private _model: MarriageModel;
	private _item: BaseAwardItem;
	private _click_time = 0;

	public constructor() {
		super()
		this.base_file = "marriage"
		this.layout_file = "MarriageFlowerItem"
		this._model = MarriageModel.GetInstance()
		this.Load()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public load_callback() {
		if (!this._item) {
			this._item = new BaseAwardItem(this._group_item)
			this._item.Load()
			this._item.SetItemSize(65, 65)
		}

		Util.AddClickEvent(this._btn_flower, () => {
			if(!this.data)return
			if (TimeUtil.getServerTime() - this._click_time < 1.5) return
			this._click_time = TimeUtil.getServerTime()
			let goods_vo = GoodsModel.GetInstance().GetBindGoodsVoFirstByTypeId(this.data.goods_id)
			if (goods_vo) {
				if (goods_vo.goods_num >= MarriageDefine.FLOWER_BATCH_COUNT) {
					BagModel.GetInstance().Fire(BagModel.OPEN_VIEW, "BatchUseView", goods_vo, 1, 1, Number(goods_vo.goods_num))
				} else {
					this._model.Fire(MarriageEvent.GIVE_GIFT, this.data.goods_id, 1)
				}
			}
		}, this, true)

		Util.AddClickEvent(this._btn_buy, () => {
			if (!this.data) return
			if (TimeUtil.getServerTime() - this._click_time < 1.5) return
			let pdata = Config.PRELOAD_SERVER_CONFIG.config_goods_price[this.data.goods_id]
			if (!pdata) return
			this._click_time = TimeUtil.getServerTime()
			if (!this._model._hide_buy_tips) {
				let gdata = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[pdata.price_type]
				let name = GoodsModel.GetGoodsName(gdata.goods_id)
				Alert.Show(`购买该礼物需要消耗${pdata.price}${name}，是否继续购买`, Alert_Type.AlertTypeCheckBox, () => {
					GoodsModel.GetInstance().CheckCoinEnough(pdata.price_type, pdata.price, true, () => {
						this._model.Fire(MarriageEvent.GIVE_GIFT, this.data.goods_id, 1)
					})
				}, null, null, null, null, null, this.SetBuyTips)
			} else {
				this._model.Fire(MarriageEvent.GIVE_GIFT, this.data.goods_id, 1)
			}
		}, this, true)

		//ResManager.GetInstance().SetTexture(this.base_item, this._img_103, "resource/game/marriage/texture/uijh_103.png")
	}

	private SetBuyTips = (selected) => {
		this._model._hide_buy_tips = selected
	}

	protected dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		this._lb_name.text = GoodsModel.GetGoodsName(data.goods_id)
		this._lb_intimacy.text = data.intimacy
		this._lb_charm.text = data.charm
		this._lb_fame.text = data.fame

		let num = GoodsModel.GetInstance().GetTypeGoodsNum(data.goods_id)
		let has_good = num > 0
		this._btn_buy.visible = !has_good
		this._btn_flower.visible = has_good
		if (!has_good) {
			let pdata = Config.PRELOAD_SERVER_CONFIG.config_goods_price[data.goods_id]
			if (pdata) {
				this._lb_cost.text = pdata.price
				let gdata = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[pdata.price_type]
				ResManager.GetInstance().SetTexture(this.base_item, this._img_cost, GoodsModel.GetGoodsPath(gdata.goods_id))
			}
		}
		this._item.SetData(data.goods_id, num)
	}

	_img_103: Laya.Image
	_btn_flower: Laya.Box
	img1: Laya.Image
	label1: Laya.Label
	_btn_buy: Laya.Box
	img2: Laya.Image
	group1: Laya.HBox
	_img_cost: Laya.Image
	_lb_cost: Laya.Label
	group2: Laya.Box
	img3: Laya.Image
	_lb_name: Laya.Label
	_group_item: Laya.Box
	_group_charm: Laya.Box
	_img__charm: Laya.Image
	_lb_charm: Laya.Label
	group4: Laya.HBox
	_group_intimacy: Laya.Box
	_img__intimacy: Laya.Image
	_lb_intimacy: Laya.Label
	_group_fame: Laya.Box
	_img_fame: Laya.Image
	_lb_fame: Laya.Label
	public GetComponents() {
		[
			this._img_103,
			this._btn_flower,
			this.img1,
			this.label1,
			this._btn_buy,
			this.img2,
			this.group1,
			this._img_cost,
			this._lb_cost,
			this.group2,
			this.img3,
			this._lb_name,
			this._group_item,
			this._group_charm,
			this._img__charm,
			this._lb_charm,
			this.group4,
			this._group_intimacy,
			this._img__intimacy,
			this._lb_intimacy,
			this._group_fame,
			this._img_fame,
			this._lb_fame,
		]
			= this.GetChildrenByNames([
				"_img_103",
				"_btn_flower",
				"img1",
				"label1",
				"_btn_buy",
				"img2",
				"group1",
				"_img_cost",
				"_lb_cost",
				"group2",
				"img3",
				"_lb_name",
				"_group_item",
				"_group_charm",
				"_img__charm",
				"_lb_charm",
				"group4",
				"_group_intimacy",
				"_img__intimacy",
				"_lb_intimacy",
				"_group_fame",
				"_img_fame",
				"_lb_fame",
			])
	}
}
window["MarriageFlowerItem"] = MarriageFlowerItem