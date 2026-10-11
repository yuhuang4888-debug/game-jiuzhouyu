import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { longlangModel } from "../commonModel/longlangModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class LonglangExItem extends BaseItemRenderer {
	AttrLb0
	AttrLb1
	AttrLb2
	_Image1
	bg
	buyBtn
	c0
	c1
	c2
	i0
	i1
	i2
	mainRoleVo
	moneyEnough
	moneyIcon
	moneyLb
	propEnough
	propList
	rewardGp
	rewardItem
	Image: Laya.Image
	Text: Laya.Label
	public WIDTH = 676
	public HEIGT = 142
	public constructor(parent) {
		super()

		this.base_file = "longlangExchange"
		this.layout_file = "LonglangExItem"
		this.Load()
		// this.skinName="resource/game/longlangExchange/exml/LonglangExItemExml.exml"
		this.propList = [];
		// this.load_callback = () => {

		// }
	}

	public load_callback() {

		let local_shopModel = ShopModel.GetInstance()
		let local_goodsModel = GoodsModel.GetInstance()
		Util.AddClickEvent(this.buyBtn, () => {
			if (!this.moneyEnough) {
				Message.show("神祭碎片不足")
				MaterialsTool.GetInstance().materialsTips(longlangModel.SHOP_MONEY)
				return
			}
			if (!this.propEnough) {
				Message.show("当前神祭属性不足，无法兑换")
				return
			}
			if (this.data) {
				local_shopModel.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", this.data.key_id, 1)
			}
		}
			, this, true)
		let local_wordMgr = WordManager
		this.mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let attrList = longlangModel.PropList
		let id = null
		let value = null
		let color = null
		let needNum = null
		let i = 0
		do {
			this.BindVar(this.mainRoleVo, attrList[i][1], () => {
				if (attrList[i]) {
					id = attrList[i][0]
					// [ts2lua]this.mainRoleVo下标访问可能不正确
					value = this.mainRoleVo[attrList[i][1]]
					// [ts2lua]lua中0和空字符串也是true，此处value >= 100 * i需要确认
					color = (value >= (100 * i)) && "#0a953e" || "#ff4f50"
					// [ts2lua]this.propList下标访问可能不正确
					needNum = this.propList[id] || 0
					// [ts2lua]this下标访问可能不正确
					this["AttrLb" + i].style.fontSize = 20
					this["AttrLb" + i].style.color = "#663915"
					// this["AttrLb" + i].style.bold=true
					this["AttrLb" + i].innerHTML = Util.StrToHTML("需&nbsp;<font color='" + color + "'>" + local_wordMgr.ConvertToPercentValue(id, needNum) + "</font>&nbsp;" + local_wordMgr.GetProperties(id))
					this["AttrLb" + i].width = 500
				}
			}
			)
			i = i + 1
		} while ((i < 3))
		let goodsBasic = local_goodsModel.GetGoodsBasicByTypeId(longlangModel.SHOP_MONEY)
		if (goodsBasic) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.moneyIcon, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
		}
		ResManager.GetInstance().SetImageSpriteTrans(this, this.bg, GameResPath.GetIcon("longlangExchange", "ui_Shop_03"))
		this.BindEvent(local_goodsModel, GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (vo.currency_id == longlangModel.SHOP_MONEY) {
				this.SetMoney()
			}
		}
		)
		this.BindEvent(local_shopModel, ShopEvent.BUY_GOODS_SUCCESS, (key_id?) => {
			if (this.data && this.data.key_id == key_id) {
				let list = [{ "0": 0, "1": this.data.goods_id, "2": 1 }]
				// let local_pos = UILocalToCanvasPoint(this.rewardGp,co.TableXY(0, 1), co.TableXY(0, 1))
				let local_pos = this.rewardGp.localToGlobal(0, 0)
				GlobalEventSystem.Fire(EventName.REWARD_FLY, list, local_pos, null, null, -40, 300, 700)
			}
		}
		)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				if (!this.rewardItem) {
					this.rewardItem = new EquipmentItem(this.rewardGp)
					this.rewardItem.Load()
					this.rewardItem.SetItemSize(81, 81)
					//this.rewardItem.SetMaskId(1)
				}
				this.rewardItem.SetData(this.data.goods_id)
				this.SetProp(this.data.condition)
				this.SetMoney()
			}
		}
	}

	public SetProp(condition?) {

		if (condition) {
			let attrList = longlangModel.PropList
			let prop = ErlangParser.GetInstance().Parse(condition)
			this.propEnough = true
			if (Util.TableSize(prop) > 0) {
				if (prop[0][0] == "attr") {
					this.propList = []
					let id = null
					let curValue = null
					let needNum = null
					let color = null
					let propArr = prop[0][1]
					let i = 0
					do {
						if (propArr[i]) {
							id = propArr[i][0]
							// [ts2lua]this.mainRoleVo下标访问可能不正确
							curValue = Number(this.mainRoleVo[attrList[i][1]])
							needNum = Number(propArr[i][1])
							// [ts2lua]lua中0和空字符串也是true，此处curValue >= needNum需要确认
							color = (curValue >= needNum) && "#0a953e" || "#ff4f50"
							if (curValue < needNum) {
								this.propEnough = false
							}
							// [ts2lua]this下标访问可能不正确
							this["AttrLb" + i].style.fontSize = 20
							this["AttrLb" + i].style.color = "#663915"
							// this["AttrLb" + i].style.bold=true
							this["AttrLb" + i].innerHTML = Util.StrToHTML("需&nbsp;<font color='" + color + "'>" + WordManager.ConvertToPercentValue(id, needNum) + "</font>&nbsp;" + WordManager.GetProperties(Number(id)))
							this["AttrLb" + i].width = 500
							// [ts2lua]this.propList下标访问可能不正确
							this.propList[id] = needNum
							// [ts2lua]this下标访问可能不正确
							// this["objAttrLb" + i].visible = true 
							// [ts2lua]this下标访问可能不正确
							// [ts2lua]this下标访问可能不正确
							// this["objc" + i].visible = true 
							// [ts2lua]this下标访问可能不正确
							// [ts2lua]this下标访问可能不正确
							// this["obji" + i].visible = true 
						} else {
							// [ts2lua]this下标访问可能不正确
							// this["objAttrLb" + i].visible = false 
							// [ts2lua]this下标访问可能不正确
							// [ts2lua]this下标访问可能不正确
							// this["objc" + i].visible = false 
							// [ts2lua]this下标访问可能不正确
							// [ts2lua]this下标访问可能不正确
							// this["obji" + i].visible = false 
						}
						i = i + 1
					} while ((i < 3))
				}
			}
		}
	}

	public SetMoney() {

		let money = GoodsModel.GetInstance().GetSpecialScore(longlangModel.SHOP_MONEY)
		this.moneyEnough = money >= this.data.price
		// [ts2lua]lua中0和空字符串也是true，此处this.moneyEnough需要确认
		let color = this.moneyEnough && "#d15e00" || "#ff4f50"
		this.moneyLb.text = this.data.price
		this.moneyLb.color = color
	}

	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this.i0,
			this.i1,
			this.i2,
			this.c0,
			this.c1,
			this.c2,
			this.moneyIcon,
			this.rewardGp,
			this.moneyLb,
			this.AttrLb0,
			this.AttrLb1,
			this.AttrLb2,
			this.buyBtn,
			this.Image,
			this.Text,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"i0",
				"i1",
				"i2",
				"c0",
				"c1",
				"c2",
				"moneyIcon",
				"rewardGp",
				"moneyLb",
				"AttrLb0",
				"AttrLb1",
				"AttrLb2",
				"buyBtn",
				"Image",
				"Text",
			])
	}
}
window["LonglangExItem"] = LonglangExItem