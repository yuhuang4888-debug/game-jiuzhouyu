
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-05-06 17.44:32
////////////////////////////////////////////////////////////////////-

import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"


export class EudaemonShopItem extends BaseItem1 {



	data
	need_refresh_data
	commodity
	public constructor(parent) {
		super(parent)


		this.base_file = "eudaemon"
		this.layout_file = "EudaemonShopItem"
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this._html_limit.style.color = "#663915"
		this._html_limit.style.fontSize = 18
		this._html_limit.style.wordWrap = false

		let success_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				// let pos = UILocalToCanvasPoint(this.itemGp,co.TableXY(0, 1), co.TableXY(0, 1))
				// GlobalEventSystem.Fire(EventName.REWARD_FLY, [{0, this.data.goods_id, this.data.num}], pos)
			}
		}

		this.BindEvent(ShopModel.GetInstance(), ShopEvent.BUY_GOODS_SUCCESS, success_fun)

		Util.AddClickEvent(this._box_buy, () => {
			if (this.data) {
				let data = this.data
				if (data.sold_out >= data.quota_num) {
					Message.show("没货了~")
					return
				}
				let enough = GoodsModel.GetInstance().GetSpecialScore(data.money_type) >= data.price
				if (!enough) {
					MaterialsTool.GetInstance().materialsTips(data.money_type)
					Message.show("货币不足")
					return
				}
				let OkFunc = () => {
					ShopModel.GetInstance().Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", this.data.key_id, 1)
				}

				if (!BossModel.NOT_EUDA_SHOP_ALERT) {
					let CheckFunc = (bool?) => {
						BossModel.NOT_EUDA_SHOP_ALERT = bool
					}

					Alert.Show("是否消耗" + this.data.price + GoodsModel.GetGoodsNameWithColorDark(this.data.money_type) + "购买" + GoodsModel.GetGoodsNameWithColorDark(this.data.goods_id) + "*" + this.data.num + "?", Alert_Type.AlertTypeCheckBox, OkFunc, null, null, null, null, null, CheckFunc)
				} else {
					OkFunc()
				}
			}
		}
			, this, true)

		let refresh_fun = (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				this.data = ShopModel.GetInstance().GetShopDataByKeyId(key_id)
				this.UpdateItem()
			}
		}

		this.BindEvent(ShopModel.GetInstance(), ShopEvent.UPDATE_SHOP_ONE_DATA, refresh_fun)


		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateItem()
		}
	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		}
		else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {
		if(!this.is_loaded) return 
		let data = this.data
		let canBuy = data.quota_num > data.sold_out
		let condition = ErlangParser.GetInstance().Parse(data.condition)
		let showlimitText2
		if (condition[1]) {
			//圣衣有特殊的购买限制
			if (String(condition[1][0]) == "constellation_equip" && !StarEquipModel.GetInstance().StarEquipIsActive(Number(condition[1][1]))) {
				showlimitText2 = true

				let ClientStarEquip = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientStarEquip", true)
				let tabList = ClientStarEquip && ClientStarEquip.tabList[Number(condition[1][1]) - 1]
				if (tabList) {
					this._lb_limit_cond.text = `需解锁${tabList.name}`
				}
			}
		}
		let limitStr = "限购"
		if (this.data.quota_type == 1) {
			limitStr = "每日限购"
		} else if (this.data.quota_type == 2) {
			limitStr = "每周限购"
		} else if (this.data.quota_type == 3) {
			limitStr = "终生限购"
		}
		//"<font color=" + color + ">" + str + "</font>"
		this._html_limit.innerHTML = `${limitStr} <font color='#0bb20f'>${data.quota_num - data.sold_out}/${data.quota_num}</font>`
		this._img_sell_out.visible = !canBuy
		this._img_buy.gray = !canBuy
		this._lb_sell_out.visible = !canBuy
		this._lb_buy.visible = canBuy
		this._lb_money.visible = canBuy
		this._img_icon.visible = canBuy

		this._box_buy.visible = !showlimitText2
		this._lb_limit_cond.visible = showlimitText2

		this._lb_money.text = data.price
		//if (data.discount < 100 ) {
		//this.hotImg.visible = true 
		//lua_resM:SetOutsideImageSprite(this, this.hotImg,"saiboTreasure_asset",  Math.ceil(data.discount / 10) + "_uisbdb_016")
		//}else{
		//this.hotImg.visible = false 
		//}
		//this.hotImg.visible = false
		if (!this.commodity) {
			this.commodity = new BaseAwardItem(this._box_item)
			this.commodity.Load()
			this.commodity.SetScale(0.7)
		}
		this.commodity.SetData(data.goods_id, data.num)
		this.commodity.SetGary(!canBuy)


		let goodsBasic2 = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.goods_id)
		if(goodsBasic2){
			this._lb_name.text = goodsBasic2.goods_name
			this._lb_name.color = ColorUtil.GetColorLight(goodsBasic2.color, false)
		}


		let cost_type_id = (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type] && (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.money_type].goods_id) || (0))
		let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cost_type_id)
		if (goodsBasic) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
		}
	}

	public DeleteMe() {

		if (this.commodity) {
			this.commodity.DeleteMe()
			this.commodity = null
		}
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_box_item: Laya.Box
	_html_limit: Laya.HTMLDivElement
	_box_buy: Laya.Box
	_img_buy: Laya.Image
	_lb_buy: Laya.Label
	_lb_money: Laya.Label
	_img_icon: Laya.Image
	_lb_sell_out: Laya.Label
	_img_hot: Laya.Image
	_img_sell_out: Laya.Image
	_lb_limit_cond: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_name,
			this._box_item,
			this._html_limit,
			this._box_buy,
			this._img_buy,
			this._lb_buy,
			this._lb_money,
			this._img_icon,
			this._lb_sell_out,
			this._img_hot,
			this._img_sell_out,
			this._lb_limit_cond,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_name",
				"_box_item",
				"_html_limit",
				"_box_buy",
				"_img_buy",
				"_lb_buy",
				"_lb_money",
				"_img_icon",
				"_lb_sell_out",
				"_img_hot",
				"_img_sell_out",
				"_lb_limit_cond",
			])
	}
}
window["EudaemonShopItem"] = EudaemonShopItem