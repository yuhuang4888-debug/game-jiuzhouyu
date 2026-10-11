import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { ColorUtil } from "../util/ColorUtil"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"

export class SacredShopItem extends BaseItemRenderer {
	_gp_item: Laya.Box
	_Image1: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_gp_award: Laya.Box
	_lb_num: Laya.HTMLDivElement
	_img_icon: Laya.Image
	_lb_price: Laya.HTMLDivElement
	data
	goods_item
	money_type
	need_refresh
	WIDTH = 330
	HEIGT = 155
	public constructor(parent?) {
		super()


		this.base_file = "sacredShop"
		this.layout_file = "SacredShopItem"
		this.load_callback = () => {

			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("sacredShop", "uisy_051"))

		}
		this.Load()
	}

	public InitEvent() {


		Util.AddClickEvent(this._gp_item, () => {
			if (this.data.quota_num - this.data.sold_out <= 0) {
				Message.show("商品已售罄")
				return
			}
			if (GoodsModel.GetInstance().GetSpecialScore(this.data.money_type) >= this.data.price) {
				this.data.scmd = 15302
				ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data)
			} else {
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.money_type)
				if (basic) {
					Message.show(basic.goods_name + "不足")
				}
			}
		}
			, this, true)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (vo.currency_id == this.data.money_type) {
				this.RefreshMoneyNum()
			}
		}
		)

		let refresh_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				this.data = ShopModel.GetInstance().GetShopDataByKeyId(key_id)
				this.RefreshGoodNum()
			}
		}

		this.BindEvent(ShopModel.GetInstance(), ShopEvent.UPDATE_SHOP_ONE_DATA, refresh_fun)
	}

	public RefreshMoneyNum() {


		// [ts2lua]lua中0和空字符串也是true，此处GoodsModel:GetInstance():GetSpecialScore(this.data.money_type) >= this.data.price需要确认
		let color = (GoodsModel.GetInstance().GetSpecialScore(this.data.money_type) >= this.data.price && ("#639c12") || ("#ff4f50"))
		this._lb_price.style.fontSize = 24
		this._lb_price.style.valign = "center"
		this._lb_price.style.color = "#ffffff"
		this._lb_price.width = 200
		this._lb_price.innerHTML = Util.StrToHTML("<font color='" + color + "'>" + this.data.price + "</font>")
	}

	public RefreshGoodNum() {


		let num = this.data.quota_num - this.data.sold_out
		// [ts2lua]lua中0和空字符串也是true，此处num > 0需要确认
		let color = (num > 0 && ("#d15e00") || ("#ff4f50"))
		this._lb_num.style.fontSize = 20
		this._lb_num.style.valign = "center"
		this._lb_num.style.color = "#663915"
		this._lb_num.width = 200
		this._lb_num.innerHTML = Util.StrToHTML("限购:<font color='" + color + "'>" + num + "/" + this.data.quota_num + "</font>")
	}

	public InitView() {


		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_id)
		if (basic && basic.goods_name) {
			let color_str = ColorUtil.GetColorLight(basic.color)
			this._lb_name.style.fontSize = 22
			this._lb_name.style.valign = "center"
			this._lb_name.style.color = "#4a3a32"
			this._lb_name.width = 200
			this._lb_name.innerHTML = Util.StrToHTML("<font color=" + color_str + ">" + Trim(basic.goods_name) + "</font>")
		}
		let gp = <Laya.HBox>this._lb_name.parent
		if (gp)
			gp.refresh()
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.money_type, 0)
		this.money_type = type_id
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(type_id))
		this.RefreshGoodNum()
		this.RefreshMoneyNum()
		if (!this.goods_item) {
			this.goods_item = new BaseAwardItem(this._gp_award)
			this.goods_item.Load()
			this.goods_item.SetItemSize(93, 93)
		}
		//this.goods_item.ExcuteCallback(() => {
		this.goods_item.SetData(this.data.goods_id, this.data.num)
		//}
		//)
	}

	public dataChanged() {
		if (super.dataChanged()) {

			if (this.data) {
				if (this.is_loaded) {
					this.InitView()
					this.InitEvent()

				}
			}
		}
	}

	public DeleteMe() {


		if (this.goods_item) {
			this.goods_item.DeleteMe()
			this.goods_item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._gp_item,
			this._Image1,
			this._lb_name,
			this._gp_award,
			this._lb_num,
			this._img_icon,
			this._lb_price,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_Image1",
				"_lb_name",
				"_gp_award",
				"_lb_num",
				"_img_icon",
				"_lb_price",
			])
	}
}
window["SacredShopItem"] = SacredShopItem