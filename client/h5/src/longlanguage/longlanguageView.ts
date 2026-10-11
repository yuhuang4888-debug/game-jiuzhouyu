import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { RedDotManager } from "../common/RedDotManager"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { longlangModel } from "../commonModel/longlangModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ModuleType } from "../common/RedDotManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { longlangEquipItem } from "./longlangEquipItem"
import { longlangBagItem } from "./longlangBagItem"

import "./longlangAttrView"
import "./longlangSuitView"
import "./longlangStrView"
import "./longlangSBaseView"

export class longlanguageView extends BaseItem1 {
	InitEquipItem
	InitView
	LocalDeleteMe
	ReOpen_callback
	SetComRed
	SetDecRed
	SetEquipData
	SetFight
	SetStrRed
	UpdateBag

	fight_item
	loop_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longlanguageView"

		let local_redMgr = RedDotManager.GetInstance()
		let local_longlangModel = longlangModel
		let local_longlangModelIns = local_longlangModel.GetInstance()
		let local_compositeModel = CompositeModel
		let local_goodsModel = GoodsModel
		let local_goodsModelIns = local_goodsModel.GetInstance()
		let local_modelType = ModuleType.LONGLANG
		//let Pos_ = [{ 164, - 97}, { 458, -97 }, { 93, -202 }, { 532, -203 }, { 121, -315 }, { 522, -314 }, { 180.5, -236 }, { 447, -236 }, { 306.5, -250 }, { 312, -400 }, { 310, -77 }]
		let bagArr_ = null
		let itemList_ = []

		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			// this.cover_effect_cache_sort_order = this.AddCurrLayerSortingOrder("UI")
			// this.RegisterMask(this.bagGp)
			this.InitView()
		}

		this.ReOpen_callback = () => {
			// this.AddUIEffect("UI_1303e", this.layer_value, this.effect1, null, null, true)
			// this.AddUIEffect("UI_1303d", this.layer_value, this.effect0, null, null, true, {
			// 	custom_sorting_order = this.cover_effect_cache_sort_order, load_call_back =() => {
			// 		this.CoverEffect(this.equipGp, this.layer_value, this.cover_effect_cache_sort_order)
			// 	}
			// })
		}

		this.InitView = () => {
			this.fight_item = new FightingShowSmallItem(this.fight)
			this.fight_item.Load()
			ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetGoodsIconPath(String(local_longlangModel.MONEY_TYPE)))
			local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62207)
			this.InitEquipItem()
			Util.AddClickEvent(this.btn1, () => {
				local_longlangModelIns.Fire(local_longlangModel.OPEN_VIEW, "longlangSuitView")
			}
				, this, true)
			Util.AddClickEvent(this.btn2, () => {
				local_longlangModelIns.Fire(local_longlangModel.OPEN_VIEW, "longlangSBaseView")
			}
				, this, true)
			Util.AddClickEvent(this.btn3, () => {
				local_longlangModelIns.Fire(local_longlangModel.OPEN_VIEW, "longlangStrView")
			}
				, this, true)
			Util.AddClickEvent(this.btn4, () => {
				local_compositeModel.GetInstance().Fire(local_compositeModel.OPEN_COMPOSITE_VIEW, local_compositeModel.Index.Longlang)
			}
				, this, true)
			Util.AddClickEvent(this.propBtn, () => {
				local_longlangModelIns.Fire(local_longlangModel.OPEN_VIEW, "longlangAttrView")
			}
				, this, true)
			Util.AddClickEvent(this.icon, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(local_longlangModel.MONEY_TYPE, null, null, null, local_goodsModelIns.GetSpecialScore(local_longlangModel.MONEY_TYPE), null, this)
			}
				, this, true)
			this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_LONGLANG_BAG, () => {
				this.UpdateBag()
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_LONGLANG_EQUIP, () => {
				local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62207)
				this.SetEquipData()
				this.UpdateBag()
			}
			)
			this.BindEvent(local_longlangModelIns, local_longlangModel.REFRESH_RED, (flag?) => {
				if (1 == flag) {
					this.SetStrRed()
				} else if (2 == flag) {
					this.SetStrRed()
				} else if (3 == flag) {
					this.SetDecRed()
				} else if (4 == flag) {
					this.SetComRed()
				}
			}
			)
			this.BindVar(local_longlangModelIns, "rating", () => {
				this.SetFight()
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == local_longlangModel.MONEY_TYPE) {
					this.money.text = vo.num
				}
			}
			)
			this.BindEvent(local_compositeModel.GetInstance(), CompositeEvent.COMPOSE_SUCCESS, (ruleId?, goodsId?) => {
				if (this.display_obj.visible && local_longlangModelIns.comId == ruleId) {
					//this:AddUIEffect("ui_shengjiechenggong_glow", this.effectGp)
					// this.AddUIEffect("UI_1102_shengjiechenggong", "UI", this.effectGp)
					local_longlangModelIns.comId = null
				}
			})

			Util.AddClickEvent(this.shopBtn, () => {
				OpenFun.OpenFunHandler(168, null, 164)
			}, this, true)

			this.money.text = String(local_goodsModelIns.GetSpecialScore(local_longlangModel.MONEY_TYPE))
			this.UpdateBag()
			this.SetEquipData()
			this.SetStrRed()
			this.SetDecRed()
			this.SetComRed()
			this.SetFight()
			//this:AddUIEffect("ui_draconic_arrary", this.effect0, null, null, true)
			//this:AddUIEffect("ui_draconic_eye", this.effect1, null, null, true)
			// this.AddUIEffect("UI_1303e", this.layer_value, this.effect1, null, null, true)
			// this.AddUIEffect("UI_1303d", this.layer_value, this.effect0, null, null, true, {
			// 	custom_sorting_order = this.cover_effect_cache_sort_order, load_call_back =() => {
			// 		this.CoverEffect(this.equipGp, this.layer_value, this.cover_effect_cache_sort_order)
			// 	}
			// })
			//this:AddUIEffect("ui_draconic_wenli_life", this.effect2, null, null, true)
			//this:AddUIEffect("ui_draconic_wenli_right", this.effect3, null, null, true)
		}

		this.SetFight = () => {
			this.fight_item.Updatefighting(local_longlangModelIns.rating)
		}

		this.InitEquipItem = () => {
			let i = local_longlangModel.EQUIP_COUNT - 1
			do {
				let item = itemList_[i]
				if (!item) {
					let parent = this["_gp_" + i]
					item = new longlangEquipItem(parent)
					item.Load()
					itemList_[i] = item
				}
				i = i - 1
			} while ((i >= 0))
		}

		this.SetEquipData = () => {
			let list = local_goodsModelIns.longlang_equip_list
			let data = null
			let item = null
			let i = 0
			do {
				data = list[i + 1]
				if (!data) {
					data = { equip_type: i + 1, type_id: 0 }
				}
				item = itemList_[i]
				if (item) { item.SetData(data) }
				i = i + 1
			} while ((i < local_longlangModel.EQUIP_COUNT))
		}

		this.UpdateBag = () => {
			let list = local_longlangModelIns.GetLonglangBag()
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, longlangBagItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.SetDecRed = () => {
			this.red2.visible = local_redMgr.CheckRedStatus(local_modelType, 3)
		}

		this.SetStrRed = () => {
			this.red3.visible = local_redMgr.CheckRedStatus(local_modelType, 2)
		}

		this.SetComRed = () => {
			this.red4.visible = local_redMgr.CheckRedStatus(local_modelType, 4)
		}

		this.LocalDeleteMe = () => {
			if (itemList_) {
				for (let key in itemList_) {
					itemList_[key].DeleteMe()
					itemList_[key] = null
				}
				itemList_ = []
			}
			// this.ClearUIEffect(this.effectGp)
			local_longlangModelIns.comId = null
			// this.ClearUIEffect(this.effect0)
			// this.ClearUIEffect(this.effect1)
			// this.ClearUIEffect(this.effect2)
			// this.ClearUIEffect(this.effect3)
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.fight_item) {
				this.fight_item.DeleteMe()
				this.fight_item = null
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_Scroller1: Laya.List
	btn1: Laya.Image
	btn2: Laya.Image
	red2: Laya.Image
	btn3: Laya.Image
	red3: Laya.Image
	btn4: Laya.Image
	red4: Laya.Image
	shopBtn: Laya.Image
	_Image3: Laya.Image
	icon: Laya.Image
	fight: Laya.Box
	equipGp: Laya.Box
	_gp_0: Laya.Box
	_gp_1: Laya.Box
	_gp_2: Laya.Box
	_gp_3: Laya.Box
	_gp_4: Laya.Box
	_gp_5: Laya.Box
	_gp_6: Laya.Box
	_gp_7: Laya.Box
	_gp_8: Laya.Box
	_gp_9: Laya.Box
	_gp_10: Laya.Box
	propBtn: Laya.Image
	money: Laya.Label
	img_line1: Laya.Image
	img_line2: Laya.Image
	public GetComponents() {
		[
			this._Scroller1,
			this.btn1,
			this.btn2,
			this.red2,
			this.btn3,
			this.red3,
			this.btn4,
			this.red4,
			this.shopBtn,
			this._Image3,
			this.icon,
			this.fight,
			this.equipGp,
			this._gp_0,
			this._gp_1,
			this._gp_2,
			this._gp_3,
			this._gp_4,
			this._gp_5,
			this._gp_6,
			this._gp_7,
			this._gp_8,
			this._gp_9,
			this._gp_10,
			this.propBtn,
			this.money,
			this.img_line1,
			this.img_line2,
		]
			= this.GetChildrenByNames([

				"_Scroller1",
				"btn1",
				"btn2",
				"red2",
				"btn3",
				"red3",
				"btn4",
				"red4",
				"shopBtn",
				"_Image3",
				"icon",
				"fight",
				"equipGp",
				"_gp_0",
				"_gp_1",
				"_gp_2",
				"_gp_3",
				"_gp_4",
				"_gp_5",
				"_gp_6",
				"_gp_7",
				"_gp_8",
				"_gp_9",
				"_gp_10",
				"propBtn",
				"money",
				"img_line1",
				"img_line2",
			])
	}
}
window["longlanguageView"] = longlanguageView