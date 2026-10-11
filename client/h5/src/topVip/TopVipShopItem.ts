import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, SetAnchoredPosition, SetAnchoredPositionY, Util } from "../util/Util"

export class TopVipShopItem extends BaseItem1 {
	bg_img: Laya.Image
	name_lb: Laya.Label
	item_gp: Laya.Box
	buy_gp: Laya.Box
	buy_img: Laya.Image
	buy_lb: Laya.Label
	price_lb: Laya.Label
	diamond_img: Laya.Image
	buyed_gp: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	limit_gp: Laya.Box
	image: Laya.Image
	_Label2: Laya.Label
	can_buy_num_lb: Laya.Label
	forecast_lb: Laya.Label
	forecast_img: Laya.Image
	cur_sorting_order
	data
	goods_id
	is_last
	key_id
	model
	need_refresh_data
	num
	price
	quota_num
	show_item
	sold_out

	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.is_last = false;
		this.model = TopVipModel.GetInstance();
		this.base_file = "topVip"
		this.layout_file = "TopVipShopItem"
		this.preload_server_config={
			"config_shop":false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			// 	if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 		this.forecast_lb.size  = 13
			// 		this.buy_lb.size  = 16
			// 		this.price_lb.size  = 16
			// 		SetAnchoredPositionX(this.buy_lb,-65)
			// 		SetAnchoredPositionX(this.diamond_img,70)
			// 		SetAnchoredPosition(this.price_lb,63,-6)
		// 		this._Label2.size  = 16
			// 		SetAnchoredPositionY(this._Label2,-5)
			// 		SetAnchoredPositionX(this.can_buy_num_lb,68)
			// 	}
		}
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetImageSprite(this, this.bg_img, "topVip", "uizzsd_004")
		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public UpdataView() {

		let config_shop = ResManager.GetInstance().GetGameConfigFromCache(this, "config_shop", false)
		if (this.is_last) {
			this.is_last = false
			this.item_gp.visible = false
			this.limit_gp.visible = false
			this.buy_gp.visible = false
			this.buyed_gp.visible = false
			this.forecast_img.visible = true
			this.forecast_lb.visible = true
			let key = this.model.GetSupremeVipCreateShopItemKeyIdBefore() + 1
			this.name_lb.text = "神秘道具"
			// [ts2lua]config_shop下标访问可能不正确
			if (config_shop[key]) {
				this.forecast_lb.text = "购买上一个道具后\n永久解锁"
			} else {
				this.forecast_lb.text = "商品已全部激活\n更多商品即将到来"
			}
			return
		}
		if (!this.show_item) {
			this.show_item = new BaseAwardItem(this.item_gp, null, "UI")

			this.show_item.Load()
			this.show_item.SetItemSize(87,87)
			// this.show_item.SetMaskId(this.mask_id || 1)
			this.show_item.ExcuteCallback(() => {
				// this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
				this.show_item.SetCacheSortOrder(this.cur_sorting_order)
				this.show_item.CoverEffectOutside(this.limit_gp)
				// this.show_item.ReplaceUIShader(this.limit_gp)
				//this.show_item.ReplaceUIShader(this.limit_gp)
			})
		}
		this.show_item.SetData(this.goods_id)//, this.num
		let goods_base = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.goods_id)
		this.item_gp.visible = true
		this.limit_gp.visible = true
		this.forecast_img.visible = false
		this.forecast_lb.visible = false
		let goods_name = goods_base.goods_name
		this.name_lb.text = String(goods_name)
		this.price_lb.text = String(this.price)
		// [ts2lua]lua中0和空字符串也是true，此处this.quota_num - this.sold_out < 0需要确认
		let buy_num = (this.quota_num - this.sold_out < 0) && 0 || (this.quota_num - this.sold_out)
		this.can_buy_num_lb.text = String(buy_num) + "/" + String(this.quota_num)
		if (this.quota_num == this.sold_out) {
			this.buy_gp.visible = true
			this.buyed_gp.visible = true
		} else {
			this.buy_gp.visible = true
			this.buyed_gp.visible = false
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.buy_gp, () => {
			if (this.quota_num > 6) {
				ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data)
			} else {
				this.model.Fire(TopVipEvent.TOP_VIP_REQUEST_PROTO, 15302, "ii", this.key_id, 1)
			}
		}
			, this, true)
		Util.AddClickEvent(this.buyed_gp, () => {
			Message.show("商品今日已卖完，请明日再来")
		}
			, this, true)
		this.BindEvent(ShopModel.GetInstance(), ShopEvent.BUY_GOODS_SUCCESS, (key_id?) => {
			if (key_id == this.key_id) {
				let local_pos = {x:this.item_gp.x,y:this.item_gp.y}//UILocalToCanvasPoint(this.item_gp, co.TableXY(0, 1), co.TableXY(0, 1))
				this.model.Fire(TopVipEvent.BUY_SUCCESS, local_pos, this.goods_id)
			}
		}
		)
	}

	public SetData(data?) {

		this.data = data
		if (!this.data ) {
			this.is_last = true
		} else {
			this.data.scmd = 15302
			this.key_id = this.data.key_id
			this.goods_id = this.data.goods_id
			this.num = this.data.num
			this.price = this.data.price
			this.quota_num = this.data.quota_num
			this.sold_out = this.data.sold_out
			this.model.AddItemGoodsIdByKey(this.key_id, this.goods_id)
			this.model.SetSupremeVipCreateShopItemKeyIdBefore(this.key_id)
		}
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}


	public DeleteMe() {

		if (this.show_item) {
			this.show_item.DeleteMe()
			this.show_item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this.bg_img,
			this.name_lb,
			this.item_gp,
			this.buy_gp,
			this.buy_img,
			this.buy_lb,
			this.price_lb,
			this.diamond_img,
			this.buyed_gp,
			this._Image1,
			this._Label1,
			this.limit_gp,
			this.image,
			this._Label2,
			this.can_buy_num_lb,
			this.forecast_lb,
			this.forecast_img,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"name_lb",
				"item_gp",
				"buy_gp",
				"buy_img",
				"buy_lb",
				"price_lb",
				"diamond_img",
				"buyed_gp",
				"_Image1",
				"_Label1",
				"limit_gp",
				"image",
				"_Label2",
				"can_buy_num_lb",
				"forecast_lb",
				"forecast_img",
			])
	}
}
window["TopVipShopItem"]=TopVipShopItem