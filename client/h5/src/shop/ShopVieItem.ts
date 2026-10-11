import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { Util, GetSizeDeltaX, SetSizeDeltaX, HtmlColorTxt } from "../util/Util"

export class ShopVieItem extends BaseItemRenderer {
	Emp_btn_buy_dis
	Emp_btn_buy_nor
	Emp_btn_over
	_Group1
	_btn_buy_dis
	_btn_buy_nor
	_btn_over
	_buy_event_id
	_cost_item
	_group_cost
	_group_item
	_img_cost_dis
	_img_disc
	_img_line
	_img_soldout
	_lb_limit
	_lb_name
	_lb_price
	_lb_price_dis
	_model
	_show_item
	overImg
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Group2: Laya.HBox
	_Image2: Laya.Image
	_Label2: Laya.Label
	_Image3: Laya.Image
	_Group3: Laya.HBox
	_Label3: Laya.Label
	_Label4: Laya.Label

	public WIDTH = 221
	public HEIGT = 342

	public constructor(parent) {
		super()


		this.base_file = "shop"
		this.layout_file = "ShopVieItem"
		// this.skinName= "resource/game/shop/exml/ShopVieItemExml.exml"
		this._model = ShopModel.GetInstance()

		this._show_item = null
		this._cost_item = null
		this._buy_event_id = null
		this.Load()
	}



	public load_callback() {
		this.LoadSuccess()
	}

	public DeleteMe() {

		if (this._show_item) {
			this._show_item.DeleteMe()
			this._show_item = null
		}
		if (this._cost_item) {
			this._cost_item.DeleteMe()
			this._cost_item = null
		}
		super.DeleteMe()
	}

	public SendProto() {

		this._model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 64001, "ii", this.data.id, 1)
	}

	public LoadSuccess() {


		if (!this._show_item) {
			this._show_item = new BaseAwardItem(this._group_item)
			this._show_item.SetUseMask(true)
			this._show_item.Load()
			this._show_item.SetItemSize(110, 110)
		}

		if (!this._cost_item) {
			this._cost_item = new BaseAwardItem(this._group_cost)
			this._cost_item.Load()
			this._cost_item.SetItemSize(27, 27)
			this._cost_item.SetItembgVisible(false)
		}
		Util.SetImageGray(this.overImg, true)
		this.InitEvent()
	}

	public dataChanged() {
		if (super.dataChanged) {
			let data = this.data

			let has_dis = data.new_price != data.old_price
			let name = GoodsModel.GetGoodsNameWithColorLight(data.good_id)
			this._lb_name.text = name
			this._lb_price.text = has_dis && data.old_price || data.new_price
			this._img_line.visible = has_dis
			let text_width = this._lb_price.preferredWidth
			let cost_width = GetSizeDeltaX(this._group_cost)
			SetSizeDeltaX(this._img_line, text_width + cost_width + 10)

			let remain = data.daily_limit_num - data.buy_num
			let limit_color = remain > 0 && "#4a3a32" || "#ff4f50"
			// let limit_text = HtmlColorTxt(remain + "/" + this.data.daily_limit_num, limit_color)
			this._lb_limit.text = remain + "/" + this.data.daily_limit_num
			this._lb_limit.color=limit_color
			//LayoutRebuilder(this._Group1)

			let disc = Mathf.Ceil(data.new_price / data.old_price * 10)
			ResManager.GetInstance().SetImageSprite(this, this._img_disc, "common2_asset", "sh_discount_" + disc, true)

			let over1 = data.buy_num >= data.daily_limit_num
			let over2 = data.left_limit_num <= 0
			let show_out = over1 || over2
			this._img_soldout.visible = show_out
			this._btn_buy_dis.visible = !show_out && has_dis
			this._btn_buy_nor.visible = !show_out && !has_dis
			this._btn_over.visible = show_out
			this._show_item.SetGary(show_out)
			Util.SetImageGray(this._img_disc, show_out)

			let cfg = this._model.GetVieData(data.id)
			this._show_item.SetData(data.good_id, cfg.default_num)

			//let normal = Config.ConfigNotNormalGoods[data.price_type]
			let normal = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[data.price_type]
			this._cost_item.SetData(normal.goods_id)

			if (!show_out && has_dis) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost_dis, GoodsModel.GetGoodsPath(normal.goods_id))
				this._lb_price_dis.text = data.new_price
			}
		}

	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_buy_dis, () => {
			if (!this.data) {
				return
			}
			GoodsModel.GetInstance().CheckCoinEnough(this.data.price_type, this.data.new_price, true, () => {
				this.SendProto()
			})
		}, this, true)

		Util.AddClickEvent(this._btn_buy_nor, () => {
			if (!this.data) {
				return
			}
			GoodsModel.GetInstance().CheckCoinEnough(this.data.price_type, this.data.new_price, true, () => {
				this.SendProto()
			})
		}, this, true)

		Util.AddClickEvent(this._btn_over, () => {
			Message.show("没货啦~")
		}, this, true)

		let success_fun = (scmd?) => {
			if (this.data && this.data.id == scmd.id) {
				let cfg = this._model.GetVieData(scmd.id)
				//let pos = UILocalToCanvasPoint(this._group_item, co.TableXY(0, 1), co.TableXY(0, 1))
				let pos = this._group_item.loaclToGlobal(0, 0)
				let list = [{ "0": 0, "1": this.data.good_id, "2": 1 }]
				GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
				//this._model.Fire(ShopEvent.SHOP_ICON_FLY, this.data.good_id, pos)
				let name = GoodsModel.GetGoodsNameWithColorLight(this.data.good_id)
				Message.show("获得 " + name + "x" + cfg.default_num)
			}
		}
		this.BindEvent(this._model, ShopEvent.BUY_VIE_GOODS_SUCCESS, success_fun)
	}

	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._group_item,
			this._img_disc,
			this._Group1,
			this._Label1,
			this._lb_limit,
			this._Group2,
			this._group_cost,
			this._lb_price,
			this._img_line,
			this._img_soldout,
			this._btn_buy_nor,
			this._Image2,
			this._Label2,
			this._btn_buy_dis,
			this._Image3,
			this._Group3,
			this._Label3,
			this._img_cost_dis,
			this._lb_price_dis,
			this._btn_over,
			this.overImg,
			this._Label4,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_group_item",
				"_img_disc",
				"_Group1",
				"_Label1",
				"_lb_limit",
				"_Group2",
				"_group_cost",
				"_lb_price",
				"_img_line",
				"_img_soldout",
				"_btn_buy_nor",
				"_Image2",
				"_Label2",
				"_btn_buy_dis",
				"_Image3",
				"_Group3",
				"_Label3",
				"_img_cost_dis",
				"_lb_price_dis",
				"_btn_over",
				"overImg",
				"_Label4",
			])
	}
}
window["ShopVieItem"] = ShopVieItem