import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, ColorType } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { SetAnchoredPositionX, Util, SetSizeDelta, SetHtmlStyle, SetHtmlCenter, HtmlColorTxt } from "../util/Util";

export class DemonShopItem extends BaseItemRenderer {
	_gp: Laya.Box
	_Image1: Laya.Image
	_Image22: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_gp_item: Laya.Box
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_Image2: Laya.Image
	_gp_cost: Laya.Box
	_lb_cost: Laya.Label
	_Image3: Laya.Image
	_Group2: Laya.HBox
	_Label2: Laya.Label
	_Image4: Laya.Image
	_lb_cost_now: Laya.Label
	_gp_buy: Laya.Box
	_Image5: Laya.Image
	_Label3: Laya.Label
	_img: Laya.Image
	_gp_effect: Laya.Box
	sell_out: Laya.Box
	Image: Laya.Image


	demon_model
	equip_item

	public constructor() {
		super()
		// this.skinName = "resource/game/demon/exml/DemonShopItemExml.exml";
		this.base_file = "demon"
		this.layout_file = "DemonShopItem"
		this.WIDTH=151
		this.HEIGT=233
		this.demon_model = DemonModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren();
	}

	public load_callback(){
		SetHtmlStyle(this._lb_name,{f:20,c:"#e036f4",ww:false,w:170})
		Util.AddClickEvent(this._gp_buy, () => {
			if (!this.data) { return }

			let bool = false
			let cost = Math.floor(this.data.cost_num * this.data.discount / 100)

			if (Number(this.data.price) == 1) {
				bool = RoleManager.GetInstance().mainRoleInfo.jin >= cost
				if (!bool) {
					Alert.Show("勾玉数量不足，是否进行充值", Alert_Type.Two, () => {
						OpenFun.OpenFunHandler(21)
					})
				}
			} else if (Number(this.data.price) == 2) {
				bool = RoleManager.GetInstance().mainRoleInfo.jinLock >= cost
				if (!bool) {
					Message.show("绑定勾玉不足")
				}
			}

			if (bool) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18312, this.data.id)
			}
		}, this, true)

		this.BindEvent(this.demon_model, DemonEvent.TALENT_SHOP_BUY_RETURN, (id?) => {
			if(!this.data) return 
			if (this.data.id == id) {
				let point=new Laya.Point(this._gp_item.x,this._gp_item.y)
				let pos =  this._gp_item.localToGlobal(point,false,)
				// this.demon_model.Fire(DemonEvent.TALENT_SHOP_ICON_FLY, this.data.goods_id, pos)

				// let pos = UILocalToCanvasPoint(this._gp_item, co.TableXY(0, 1), co.TableXY(0, 1))
				let list = [[0, this.data.goods_id, 1]]
				GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)
			}
		})
	}

	public DeleteMe() {
		if (this.equip_item) {
			this.equip_item.DeleteMe()
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (!this.equip_item) {
			this.equip_item = new BaseAwardItem(this._gp_item)
			this.equip_item.Load()
			this.equip_item.SetItemSize(87,87)
		}
		let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_id)
		if (goodsBasic) {
			this._lb_name.innerHTML = HtmlColorTxt(goodsBasic.goods_name,ColorUtil.GetColorLight(goodsBasic.color))
			SetHtmlCenter(this._lb_name,{x:-8,w:170})
			this.equip_item.SetData(goodsBasic.type_id)
		}

		let canBuy = this.data.buy_num < this.data.can_buy_num
		this.equip_item.ExcuteCallback(() => {
			this.equip_item.ForceSetNumber(this.data.num)
		})
		this._lb_cost.text = `${this.data.cost_num}`
		this._lb_cost_now.text = `${Math.floor(this.data.cost_num * this.data.discount / 100)}`
		this._img.visible = this.data.discount > 0
		ResManager.GetInstance().SetOutsideImageSprite(this.base_item, this._img,GameResPath.GetIconOtherPath("demon",`${this.data.discount / 10}_uisbdb_016`))
		// ResManager.GetInstance().SetImageSprite(this.base_item, this._img,"demon",`${this.data.discount / 10}_uisbdb_016`)

		let [cost_goods_id] = GoodsModel.GetInstance().GetMappingTypeId(this.data.price)
		let cost_goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cost_goods_id)
		let cost_icon = cost_goods_basic.goods_icon
		ResManager.GetInstance().SetTexture(this.base_item, this._Image2, GameResPath.GetGoodsIconPath(cost_icon))
		ResManager.GetInstance().SetTexture(this.base_item, this._Image4, GameResPath.GetGoodsIconPath(cost_icon))

		Util.SetImageGray(this._gp, !canBuy);

		this.sell_out.visible = !canBuy
		this._gp_buy.mouseEnabled = canBuy;
		// this._gp_buy.touchChildren = canBuy;
		// this.ClearUIEffect(this._gp_effect)
		if (goodsBasic && goodsBasic.color >= ColorType.RED && canBuy) {
			// this.AddUIEffect("ui_Pokemon_frame_big", this._gp_effect, null, null, true)
		}
	}

	/*
	public SetGray(bool?) {
		this._Image1.gray = bool
		this._Image2.gray = bool
		this._Image3.gray = bool
		this._Image4.gray = bool
		this._Image5.gray = bool
		this._img.gray = bool

		if (this.equip_item) {
			this.equip_item.SetGary(bool)
		}
	}
	*/


	public GetComponents() {
		[
			this._gp,
			this._Image1,
			this._Image22,
			this._lb_name,
			this._gp_item,
			this._Group1,
			this._Label1,
			this._Image2,
			this._gp_cost,
			this._lb_cost,
			this._Image3,
			this._Group2,
			this._Label2,
			this._Image4,
			this._lb_cost_now,
			this._gp_buy,
			this._Image5,
			this._Label3,
			this._img,
			this._gp_effect,
			this.sell_out,
			this.Image,
		]
			= this.GetChildrenByNames([

				"_gp",
				"_Image1",
				"_Image22",
				"_lb_name",
				"_gp_item",
				"_Group1",
				"_Label1",
				"_Image2",
				"_gp_cost",
				"_lb_cost",
				"_Image3",
				"_Group2",
				"_Label2",
				"_Image4",
				"_lb_cost_now",
				"_gp_buy",
				"_Image5",
				"_Label3",
				"_img",
				"_gp_effect",
				"sell_out",
				"Image",
			])
	}
}
window["DemonShopItem"]=DemonShopItem