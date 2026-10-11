import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { CookieWrapper } from "../common/CookieWrapper"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { DownDropBtn } from "../common/DownDropBtn"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { AStarEquipBagItem } from "./AStarEquipBagItem"

export class StarEquipBagView extends BaseItem1 {
	ClickColor
	ClickPos
	GetBagList
	InitView
	LocalDeleteMe
	colorBtn
	posBtn

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipBagView"
		this.layer_value = Enum_UILayer.Activity

		let local_CookieWrapper = CookieWrapper
		let cookie_wrapper = local_CookieWrapper.GetInstance()
		let local_StarEquipModelIns = StarEquipModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let lcoal_goodsIns = local_GoodsModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()
		let bagArr = null

		this.load_callback = () => {
			this.capacityLb.style.fontSize = 22
			this.capacityLb.style.color = "##7f6152"
			this.capacityLb.style.wordWrap = false
			
			//this.RegisterMask(this.bagGp)
			this.InitView()
		}

		this.InitView = () => {
			this.colorBtn = new DownDropBtn(this.colorGp)
			this.posBtn = new DownDropBtn(this.posGp)

			//let obj = cookie_wrapper.GetCookie(local_CookieWrapper.STAR_EQUIP_INFO, true)
			//if (obj ) {
			//let info = local_Erlang.Parse(obj)
			//local_StarEquipModelIns.dropColor = info.drop_color || 0
			//local_StarEquipModelIns.dropPos = info.drop_stage || 0
			//}

			let defaultText = "任意部位"
			let PosList = local_StarEquipModelIns.GetPosDropData()
			for (let key in PosList) {

				let vo = PosList[key]
				if (vo.cond == local_StarEquipModelIns.dropPos) {
					defaultText = vo.content
				}
			}
			this.posBtn.Init(PosList, this.ClickPos, defaultText, "content", "Activity", 7, false, false)
			this.posBtn.Load()

			let colorList = local_StarEquipModelIns.GetColorDropData()
			defaultText = "任意品质"
			for (let key in colorList) {

				let vo = colorList[key]
				if (vo.cond == local_StarEquipModelIns.dropColor) {
					defaultText = vo.content
				}
			}
			this.colorBtn.Init(colorList, this.ClickColor, defaultText, "content", "Activity", null, false, false)
			this.colorBtn.Load()

			this.BindEvent(lcoal_goodsIns, local_GoodsModel.CHANGE_STAREQUIP_BAG, () => {
				if (!this.use_delete_method) {
					this.GetBagList(local_StarEquipModelIns.dropPos, local_StarEquipModelIns.dropColor)
					this.capacityLb.innerHTML = Util.StrToHTML("容量:<font color='#443630'>" + lcoal_goodsIns.starEquipBagList.length + "/" + 100 + "</font>")
				}
			}
			)
			this.capacityLb.innerHTML = Util.StrToHTML("容量:<font color='#443630'>" + lcoal_goodsIns.starEquipBagList.length + "/" + 100 + "</font>")
			this.GetBagList(local_StarEquipModelIns.dropPos, local_StarEquipModelIns.dropColor)
		}

		this.ClickPos = (index?, data?) => {
			if (data) {
				local_StarEquipModelIns.dropPos = data.cond
				this.GetBagList(local_StarEquipModelIns.dropPos, local_StarEquipModelIns.dropColor)
			}
		}

		this.ClickColor = (index?, data?) => {
			if (data) {
				local_StarEquipModelIns.dropColor = data.cond
				this.GetBagList(local_StarEquipModelIns.dropPos, local_StarEquipModelIns.dropColor)
			}
		}

		this.GetBagList = (pos?, color?) => {
			let list = local_StarEquipModelIns.GetBagList(pos, color)
			if (!bagArr) {
				bagArr = new LoopScrowViewMgr()
				bagArr.SetData(this._Scroller1, AStarEquipBagItem, list, LoopScrCon.Vertical)
			} else {
				bagArr.replaceAll(list)
			}
		}

		this.LocalDeleteMe = () => {
			if (bagArr) {
				bagArr.DeleteMe()
				bagArr = null
			}
			if (this.colorBtn) {
				this.colorBtn.DeleteMe()
				this.colorBtn = null
			}
			if (this.posBtn) {
				this.posBtn.DeleteMe()
				this.posBtn = null
			}
			//let obj = [drop_color=local_StarEquipModelIns.dropColor, drop_stage=local_StarEquipModelIns.dropPos]
			//cookie_wrapper:SaveCookie(local_CookieWrapper.STAR_EQUIP_INFO, local_Erlang.stringify(obj), true)
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_Image1: Laya.Image
	capacityLb: Laya.HTMLDivElement
	_Scroller1: Laya.List
	colorGp: Laya.Box
	posGp: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this.capacityLb,
			this._Scroller1,
			this.colorGp,
			this.posGp,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"capacityLb",
				"_Scroller1",
				"colorGp",
				"posGp",
			])
	}
}
window["StarEquipBagView"] = StarEquipBagView