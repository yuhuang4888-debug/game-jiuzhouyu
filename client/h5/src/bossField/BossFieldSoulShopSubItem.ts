import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class BossFieldSoulShopSubItem extends BaseItem1 {


	need_refresh_data
	data

	key_id
	goods_id
	num
	price
	quota_num
	sold_out
	can_buy
	show_item

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossField"
		this.layout_file = "BossFieldSoulShopSubItem"
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public UpdataView() {

		let data = this.data
		let goods_base = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.goods_id)
		let name = goods_base.goods_name
		this._lb_name.text = name
		this._lb_prive.text = this.price

		this._lb_quota.text = `限购${this.quota_num - this.sold_out}/${this.quota_num}`

		this._box_buy.visible = this.sold_out < this.quota_num
		this._box_soldout.visible = this.sold_out >= this.quota_num
		this._box_buy.gray = this.sold_out >= this.quota_num
		if (!this.show_item) {
			this.show_item = new BaseAwardItem(this._box_icon)
			this.show_item.Load()
			this.show_item.SetItemSize(83, 83)
			this.show_item.ExcuteCallback(() => {
			})
		}
		this.show_item.SetData(this.goods_id)
	}

	public InitEvent() {

		Util.AddClickEvent(this._box_buy, () => {
			//if (this.quota_num > 6 ) {
			//	ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data)
			//}else{
			if (this.can_buy) {
				ShopModel.GetInstance().Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", this.key_id, 1)
			} else {
				Message.show("商品今日已卖完，请明日再来")
			}
			//}
		}
			, this, true)

		this.BindEvent(ShopModel.GetInstance(), ShopEvent.BUY_GOODS_SUCCESS, (key_id?) => {
			if (key_id == this.key_id) {
				// let local_pos = UILocalToCanvasPoint(this.icon, co.TableXY(0, 1), co.TableXY(0, 1))
				// this.IconFly(this.goods_id, local_pos)
			}
		}
		)
	}

	public SetData(data?) {

		this.data = data
		this.key_id = data.key_id
		this.goods_id = data.goods_id
		this.num = data.num
		this.price = data.price
		this.quota_num = data.quota_num
		this.sold_out = data.sold_out
		this.can_buy = this.sold_out < this.quota_num
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
	public IconFly(type_id?, pos?) {
		if (type_id && pos) {
			let list = [[0, type_id, 1]]
			GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
		}
	}

	_img_bg: Laya.Image
	_box_icon: Laya.Box
	_img_quota: Laya.Image
	_lb_quota: Laya.Label
	_lb_name: Laya.Label
	_img_icon: Laya.Image
	_lb_prive: Laya.Label
	_box_buy: Laya.Box
	_img_buy: Laya.Image
	_lb_buy: Laya.Label
	_box_soldout: Laya.Box
	_lb_soldout: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._box_icon,
			this._img_quota,
			this._lb_quota,
			this._lb_name,
			this._img_icon,
			this._lb_prive,
			this._box_buy,
			this._img_buy,
			this._lb_buy,
			this._box_soldout,
			this._lb_soldout,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_icon",
				"_img_quota",
				"_lb_quota",
				"_lb_name",
				"_img_icon",
				"_lb_prive",
				"_box_buy",
				"_img_buy",
				"_lb_buy",
				"_box_soldout",
				"_lb_soldout",
			])
	}
}
window["BossFieldSoulShopSubItem"] = BossFieldSoulShopSubItem
