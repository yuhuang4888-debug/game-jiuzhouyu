import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent, ShopType } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPositionY, SetSizeDeltaY, SetAnchoredPositionX, Util, Trim, HtmlColorTxt } from "../util/Util"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class ShopItem extends BaseItemRenderer {
	Empbuy_btn
	_Group1
	_img_buy
	_lb
	buy_btn
	condition
	cost_icon
	cost_item
	goods_icon
	goodsname
	item
	jinLock_event_id
	jin_event_id
	limitLb
	limit_conta
	limit_num
	line_lb
	model
	now_price
	price
	soldout
	update_one_event_id

	_Image1: Laya.Image
	img_disc: Laya.Image

	//gap 6
	public WIDTH = 221
	public HEIGT = 324

	public constructor(parent) {
		super()


		this.base_file = "shop"
		this.layout_file = "ShopItem"
		// this.skinName="resource/game/shop/exml/ShopItemExml.exml"

		this.now_price = null
		this.jin_event_id = null
		this.jinLock_event_id = null
		this.update_one_event_id = null
		this.model = ShopModel.GetInstance()
		this.Load()
		// this.load_callback()

	}

	public load_callback() {
		this.LoadSuccess()
		if (PlatformManager.IsEyouEnPlatform()) {
			this.goodsname.centerX= 0
			this.goodsname.y = 106
			this.goodsname.width = 174
			this.goodsname.height = 68
			this.goodsname.fontSize = 18
			this.goodsname.wordWrap = true
			this.goodsname.align="center"
			this.goodsname.valign="middle"
			this.goodsname.leading = 0.1
			this.limitLb.fontSize = 18
			this.limit_num.fontSize = 18
			this.condition.wordWrap = true
			this.condition.leading = 0.1
		}

	}

	public LoadSuccess() {

		if (PlatformManager.IsEyouEnPlatform()) {
			this.goodsname.size = 20
		}
		this.item = new BaseAwardItem(this.goods_icon)
		this.item.SetUseMask(true)
		this.item.Load()
		this.item.SetItemSize(82, 84)
		this.cost_item = new BaseAwardItem(this.cost_icon)
		this.cost_item.SetUseMask(true)
		this.cost_item.Load()
		this.cost_item.SetItemSize(32, 32)
		this.cost_item.SetItembgVisible(false)

		this.InitEvent()
	}

	public InitEvent() {


		Util.AddClickEvent(this.buy_btn, () => {
			if (this.data) {
				let ok_func = (force?) => {
					if (!force && this.data.mystery_shop_good) {
						let [enough, gap, my_have, str] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							Message.show(str)
							return
						}
					}
					this.model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", this.data.key_id, 1)
				}

				let check_func = (bool?) => {
					this.model.jinLock_not_enough_not_alert = bool
				}

				let ok_btn_fun = () => {
					ok_func(true)
				}

				if ((this.data.quota_num == 0 || this.data.sold_out < this.data.quota_num) && this.data.type != ShopType.Outward) {
					this.data.scmd = 15302
					ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data)
				} else {
					if (this.data.money_type == 2) { //消耗绑钻
						let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
						if (!enough) {
							let diamond_enough, gap2 = this.model.MoneyIsEnough(1, gap)
							if (diamond_enough) {
								if (this.model.jinLock_not_enough_not_alert == false) {
									let content = Util.StrToHTML("<font color='#ff4f50'>当前绑玉数量不足，是否消耗勾玉代替？</font>")
									Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_btn_fun, null, "确定", "取消", null, false, check_func, "本次登录不再提示")
									Alert.SetIsCharge(true)
								} else {
									ok_btn_fun()
								}
							} else {
								ok_func()
							}
						} else {
							ok_func()
						}
					} else {
						ok_func()
					}
				}
			}
		}, this, true)

		let refresh_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				this.data = this.model.GetShopDataByKeyId(key_id)
				this.SetState()
			}
		}
		this.BindEvent(this.model, ShopEvent.UPDATE_SHOP_ONE_DATA, refresh_fun)

		let refresh_fun2 = (key_id?) => {
			this.SetState()
		}
		this.BindVar(RoleManager.Instance.mainRoleInfo, "jinLock", refresh_fun2)
		this.BindVar(RoleManager.Instance.mainRoleInfo, "jin", refresh_fun2)

		let success_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id && this.data.type == ShopType.Outward) {
				//let pos = UILocalToCanvasPoint(this.goods_icon,co.TableXY(0, 1), co.TableXY(0, 1))
				let pos = this.goods_icon.loaclToGlobal(0, 0)
				let list = [{ "0": 0, "1": this.data.goods_id, "2": 1 }]
				GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
				this.model.Fire(ShopEvent.SHOP_ICON_FLY, this.data.goods_id, pos)
			}
		}
		this.BindEvent(this.model, ShopEvent.BUY_GOODS_SUCCESS, success_fun)
	}

	public dataChanged() {

		//if (this.item ) {
		//this.item.DeleteMe()
		//this.item = null
		//}
		if (super.dataChanged()) {
			if (!this.item) {
				this.item = new BaseAwardItem(this.goods_icon)
				this.item.Load()
				this.item.SetItemSize(110, 110)
			}
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_id)
			if (basic) {
				//商品图标
				this.item.SetData(this.data.goods_id, this.data.num)
				//商品名字
				let color_str = ColorUtil.GetColorLight(basic.color)
				color_str = color_str.replace(SpecialCharKey.ShopItem1, "");
				color_str = color_str.replace(SpecialCharKey.ShopItem1, "");
				let name = "<font color=" + color_str + ">" + Trim(basic.goods_name) + "</font>"
				// this.goodsname.text = name
				this.goodsname.text = Trim(basic.goods_name)
				this.goodsname.color = color_str
				//商品价格
				let now_price = Mathf.Round(this.data.price * this.data.discount / 100)
				this.now_price = now_price
				// this.price.text = String(now_price)
				this.price.text = String(now_price)
				//LayoutRebuilder(this._Group1)
				this.SetState()
			}
		}
	}

	public SetState() {

		if (this.data) {
			//价格颜色
			let [enough, gap] = this.model.MoneyIsEnough(this.data.money_type, this.now_price)
			// let color_str = enough && ColorUtilValue.DARKWHITE || ColorUtilValue.RED
			// let color_str = enough && Enum_ColorUtil_Dark.WHITE || Enum_ColorUtil_Light.RED
			// this.price.color = color_str
			if (enough) {
				this.price.color = "#d15e00"
			} else {
				this.price.color = "#ff4f50"
			}
			//货币图标
			let cost_type_id = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type] && Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type].goods_id || 0
			this.cost_item.SetData(cost_type_id, null, null, null, null, true)
			//销售状态
			let sell_out = false
			if (this.data.quota_num != 0 && this.data.sold_out >= this.data.quota_num) {
				sell_out = true
			}
			this.item.SetGary(sell_out)
			Util.SetImageGray(this.buy_btn, sell_out)
			// this.line_lb.effectColor = sell_out && ColorUtilValue.GRAY || ColorUtilValue.BROWN 
			// this.line_lb.effectColor = sell_out && Enum_ColorUtil_Dark.GRAY || Enum_ColorUtil_Dark.GOLDEN
			// this.Empbuy_btn.raycastTarget = ! sell_out
			// this.Empbuy_btn.touchEnabled = ! sell_out
			if (this._lb && sell_out) {
				this._lb.text = "售罄"
				// this._lb.textFlow = Util.StrToHTML("售罄")
			} else {
				this._lb.text = "购买"
				// this._lb.textFlow = Util.StrToHTML("购买")
			}
			this.soldout.visible = sell_out
			//限购状态
			this.limit_conta.visible = this.data.quota_num > 0
			let limit_color = (this.data.quota_num - this.data.sold_out > 0) && "#d15e00" || "#ff4f50"
			limit_color = limit_color.replace(SpecialCharKey.ShopItem1, "");
			limit_color = limit_color.replace(SpecialCharKey.ShopItem1, "");
			let limit_text = (this.data.quota_num - this.data.sold_out) + "/" + this.data.quota_num
			// limit_text = HtmlColorTxt(limit_text, limit_color)
			this.limit_num.text = limit_text
			this.limit_num.color = limit_color
			// this.limit_num.textFlow = Util.StrToHTML(limit_text)
			let limitStr = "限购"
			if (this.data.quota_type == 3) {
				limitStr = "终生限购"
			}
			this.limitLb.text = limitStr
			// this.limitLb.textFlow = Util.StrToHTML(limitStr)
			//LayoutRebuilder(this.limit_conta)

			//购买条件
			let condition = ErlangParser.GetInstance().Parse(this.data.condition)
			let is_show_cond = false
			if (Util.TableSize(condition) > 0) {
				if (condition[0] && typeof (condition[0][1]) == "string") {

					let str = ""
					// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
					// 	str = String(condition[1][1]) == "vip" && "Khusus VIP " + condition[1][2] + " keatas" || condition[1][2] + "Bisa beli di atas lv "
					// }else{
					// 	str = String(condition[1][1]) == "vip" && "VIP" + condition[1][2] + "以上可购买" || condition[1][2] + "级以上可购买"
					// }
					str = String(condition[0][0]) == "vip" && "VIP" + condition[0][1] + "以上可购买" || condition[0][1] + "级以上可购买"
					if (String(condition[0][0]) == "lv" && RoleManager.Instance.mainRoleInfo.level < Number(condition[0][1])) {
						is_show_cond = true
					} else if (String(condition[0][0]) == "vip" && RoleManager.Instance.mainRoleInfo.vip_flag < Number(condition[0][1])) {
						is_show_cond = true
					} else if ((condition[1] && String(condition[1][0]) == "constellation_equip"
						&& !StarEquipModel.GetInstance().StarEquipIsActive(Number(condition[1][1]))
					)) {
						is_show_cond = true
						str = ""
						ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "ClientStarEquip", true, undefined, (cfgs) => {
							let tabList = cfgs.tabList[Number(condition[1][1] - 1)]
							if (tabList) {
								str = "需解锁" + tabList.name
								this.condition.text = str
							}
						});
					}
					this.condition.text = str
					// this.condition.textFlow = Util.StrToHTML(str)
				}
			}
			this.condition.visible = is_show_cond
			this.buy_btn.visible = !is_show_cond
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.cost_item) {
			this.cost_item.DeleteMe()
			this.cost_item = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this.goodsname,
			this.goods_icon,
			this.img_disc,
			this.limit_conta,
			this.limitLb,
			this.limit_num,
			this._Group1,
			this.cost_icon,
			this.price,
			this.soldout,
			this.buy_btn,
			this._img_buy,
			this._lb,
			this.condition,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"goodsname",
				"goods_icon",
				"img_disc",
				"limit_conta",
				"limitLb",
				"limit_num",
				"_Group1",
				"cost_icon",
				"price",
				"soldout",
				"buy_btn",
				"_img_buy",
				"_lb",
				"condition",
			])
	}
}
window["ShopItem"] = ShopItem