import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { longlangModel } from "../commonModel/longlangModel"
import { ShopModel, ShopEvent, ShopType } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LonglangExItem } from "./LonglangExItem"

export class LonglangExchangeView extends BaseItem1 {

	itemGp
	loop_mgr

	public constructor(parent?) {
		super(parent)


		this.base_file = "longlangExchange"
		this.layout_file = "LonglangExchangeView"
		// let local_shopModel = ShopModel.GetInstance()
		// let local_gModel = GoodsModel.GetInstance()
		// let local_wordMgr = WordManager
		// let local_resmgr = ResManager.GetInstance()
		// let moneyId = longlangModel.SHOP_MONEY
		// let mainroleVo = RoleManager.GetInstance().GetMainRoleVo()
		this.load_callback = () => {
			console.log(this.is_loaded)
			this.InitEvent()
		}

	}

	public InitEvent() {
		let local_shopModel = ShopModel.GetInstance()
		let local_gModel = GoodsModel.GetInstance()
		let local_wordMgr = WordManager
		let local_resmgr = ResManager.GetInstance()
		let moneyId = longlangModel.SHOP_MONEY
		let mainroleVo = RoleManager.GetInstance().GetMainRoleVo()
		//this.RegisterMask(this.itemGp)
		this.BindEvent(local_gModel, GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (!vo || vo.currency_id == moneyId) {
				this.moneyLb.text = local_gModel.GetSpecialScore(moneyId)
			}
		}
			, true)
		let attrList = longlangModel.PropList
		let i = 0
		do {
			this.BindVar(mainroleVo, attrList[i][1], () => {
				// [ts2lua]this下标访问可能不正确
				// [ts2lua]mainroleVo下标访问可能不正确
				this["AttrLb" + i].style.fontSize = 18
				this["AttrLb" + i].style.color = "#663915"
				this["AttrLb" + i].innerHTML = Util.StrToHTML(local_wordMgr.GetProperties(Number(attrList[i][0])) + "&nbsp;<font color='#0a953e'>" + local_wordMgr.ConvertToPercentValue(attrList[i][0], mainroleVo[attrList[i][1]]) + "</font>")
				this["AttrLb" + i].width = 500
			}
				, true)
			i = i + 1
		} while ((i < 3))
		local_resmgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconJpg("longlangExchange", "uilydh_003"), true)
		let goodsBasic = local_gModel.GetGoodsBasicByTypeId(moneyId)
		if (goodsBasic) {
			local_resmgr.SetOutsideImageSprite(this, this.moneyIcon, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
		}
		this.BindEvent(local_shopModel, ShopEvent.UPDATE_SHOP_DATA, () => {
			if (this.display_obj.visible) {
				this.SetShopData()
			}
		}
			, true)
		local_shopModel.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15301, "c", ShopType.LonglangEx)
		Util.AddClickEvent(this.moneyIcon, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(longlangModel.SHOP_MONEY)
		}
			, this, true)
	}


	public SetShopData() {
		let local_shopModel = ShopModel.GetInstance()
		let originalList = local_shopModel.GetShopDataByType(ShopType.LonglangEx) || []
		let vauleList = []
		let showList = []
		let notEnough = null
		let mainroleVo = RoleManager.GetInstance().GetMainRoleVo()
		let i1 = 0
		do {
			let attrInfo = longlangModel.PropList[i1]
			// [ts2lua]vauleList下标访问可能不正确
			// [ts2lua]mainroleVo下标访问可能不正确
			vauleList[attrInfo[0]] = mainroleVo[attrInfo[1]]
			i1 = i1 + 1
		} while ((i1 < 3))
		let i = 0
		do {
			let data = originalList[i]
			let prop = ErlangParser.GetInstance().Parse(data.condition)
			if (Util.TableSize(prop) > 0) {
				if (prop[0][0] == "attr") {
					let curValue = null
					let needNum = null
					let propArr = prop[0][1]
					let j = 0
					do {
						// [ts2lua]vauleList下标访问可能不正确
						curValue = vauleList[Number(propArr[j][0])]
						//curValue = propArr[j][0]
						needNum = propArr[j][1]
						if (Number(curValue) < Number(needNum)) {
							notEnough = true
							break
						}
						j = j + 1
					} while (j < 3)
				}
			}
			table.insert(showList, data)
			// this.Content.repeatY=showList.length
			if (notEnough || i == originalList.length - 1) {
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					// this.Content.repeatY=showList.length
					this.loop_mgr.SetData(this.Content, LonglangExItem, showList, LoopScrCon.Vertical, 1)
				} else {
					// this.Content.repeatY=showList.length
					this.loop_mgr.replaceAll(showList)
				}
				break
			}
			i = i + 1
		} while (i < originalList.length)
	}

	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		
		super.DeleteMe()
	}

bg1:Laya.Image
_Label1:Laya.Label
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_Image6:Laya.Image
moneyIcon:Laya.Image
AttrLb0:Laya.HTMLDivElement
AttrLb1:Laya.HTMLDivElement
AttrLb2:Laya.HTMLDivElement
moneyLb:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.List
_imgge7:Laya.Image
	public GetComponents() {
		[
			this.bg1,
			this._Label1,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this.moneyIcon,
			this.AttrLb0,
			this.AttrLb1,
			this.AttrLb2,
			this.moneyLb,
			this._Scroller1,
			this.Content,
this._imgge7,
		]
			= this.GetChildrenByNames([

				"bg1",
				"_Label1",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"moneyIcon",
				"AttrLb0",
				"AttrLb1",
				"AttrLb2",
				"moneyLb",
				"_Scroller1",
				"Content",
"_imgge7",
			])
	}
}

window["LonglangExchangeView"]=LonglangExchangeView